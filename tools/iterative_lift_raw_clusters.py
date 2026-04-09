#!/usr/bin/env python3
"""Iteratively apply raw-cluster lifts to one file, verifying after each one.

Examples:
  python3 tools/iterative_lift_raw_clusters.py --file code/item_effects.asm --dry-run
  python3 tools/iterative_lift_raw_clusters.py --file code/item_effects.asm --limit 3
  python3 tools/iterative_lift_raw_clusters.py --file code/item_effects.asm --limit 10 --commit
"""

from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path

from list_raw_clusters import RAW_RE, find_clusters
from lift_raw_cluster import ROOT, _compute_line_starts, _resolve_file
from promote_raw_item_handler_label import estimate_asm_line_size, load_lines


def run(cmd: str) -> subprocess.CompletedProcess[str]:
    return subprocess.run(cmd, shell=True, cwd=ROOT, text=True, capture_output=True)


def run_argv(argv: list[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(argv, cwd=ROOT, text=True, capture_output=True)


def snapshot(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def restore(path: Path, text: str) -> None:
    path.write_text(text, encoding="utf-8")


def apply_lift(rel: Path, start_addr: int, end_addr: int) -> subprocess.CompletedProcess[str]:
    cmd = [
        sys.executable,
        "tools/lift_raw_cluster.py",
        "--file",
        str(rel),
        "--start",
        f"{start_addr:06X}",
        "--end",
        f"{end_addr:06X}",
        "--apply",
        "--quiet",
    ]
    return subprocess.run(cmd, cwd=ROOT, text=True, capture_output=True)


def commit_if_needed(rel: Path, message: str) -> tuple[bool, str | None]:
    add_proc = run_argv(["git", "add", str(rel)])
    if add_proc.returncode != 0:
        return False, "git-add"

    cached_diff = run_argv(["git", "diff", "--cached", "--quiet", "--", str(rel)])
    if cached_diff.returncode == 0:
        return True, None
    if cached_diff.returncode not in (0, 1):
        return False, "git-diff"

    commit_proc = run_argv(["git", "commit", "-m", message])
    if commit_proc.returncode != 0:
        return False, "git-commit"
    return True, None


def sorted_clusters(path: Path, min_bytes: int, max_bytes: int | None, raw_only: bool) -> list:
    clusters = find_clusters(load_lines(path))
    clusters = [c for c in clusters if c.byte_count >= min_bytes]
    if max_bytes is not None:
        clusters = [c for c in clusters if c.byte_count <= max_bytes]
    if raw_only:
        clusters = [c for c in clusters if c.kind == "raw-only"]
    else:
        clusters = [c for c in clusters if c.kind == "mixed"]
    clusters.sort(key=lambda c: (c.kind != "mixed", -(c.byte_count), c.start_addr))
    return clusters


def sorted_segments(path: Path, min_bytes: int, max_bytes: int | None) -> list[tuple[int, int, int, int]]:
    lines = load_lines(path)
    line_starts = _compute_line_starts(lines)
    segments: list[tuple[int, int, int, int]] = []
    start_idx: int | None = None
    start_addr: int | None = None
    end_addr: int | None = None

    def finish(end_idx: int) -> None:
        nonlocal start_idx, start_addr, end_addr
        if start_idx is None or start_addr is None or end_addr is None:
            start_idx = None
            start_addr = None
            end_addr = None
            return
        byte_count = end_addr - start_addr + 1
        if byte_count >= min_bytes and (max_bytes is None or byte_count <= max_bytes):
            segments.append((start_idx, end_idx, start_addr, end_addr))
        start_idx = None
        start_addr = None
        end_addr = None

    for idx, line in enumerate(lines):
        stripped = line.strip()
        line_start = line_starts[idx]
        line_size = estimate_asm_line_size(stripped)
        line_end = None if line_start is None or line_size in (None, 0) else line_start + line_size - 1

        if RAW_RE.match(stripped) and line_start is not None and line_end is not None:
            if start_idx is None:
                start_idx = idx
                start_addr = line_start
            end_addr = line_end
        else:
            if start_idx is not None:
                finish(idx - 1)

    if start_idx is not None:
        finish(len(lines) - 1)

    segments.sort(key=lambda item: -(item[3] - item[2] + 1))
    return segments


def format_batch_message(template: str, rel: Path, items: list[tuple[int, int]]) -> str:
    first_start = items[0][0]
    first_end = items[0][1]
    last_start = items[-1][0]
    last_end = items[-1][1]
    return template.format(
        start=f"{first_start:06X}",
        end=f"{first_end:06X}",
        first_start=f"{first_start:06X}",
        first_end=f"{first_end:06X}",
        last_start=f"{last_start:06X}",
        last_end=f"{last_end:06X}",
        count=len(items),
        file=str(rel),
    )


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--file", required=True, help="asm file to process")
    parser.add_argument("--min-bytes", type=int, default=16, help="minimum cluster size")
    parser.add_argument("--max-bytes", type=int, help="maximum cluster size")
    parser.add_argument("--limit", type=int, help="maximum number of clusters to attempt")
    parser.add_argument("--batch-size", type=int, default=1, help="apply this many segments at once before verify; failed batches are bisected")
    parser.add_argument("--raw-only", action="store_true", help="process raw-only clusters instead of mixed clusters")
    parser.add_argument("--mode", choices=("cluster", "segment"), default="segment", help="process whole mixed clusters or consecutive raw segments")
    parser.add_argument("--dry-run", action="store_true", help="list planned clusters without applying them")
    parser.add_argument("--stop-on-fail", action="store_true", help="stop on first failure")
    parser.add_argument("--verify-cmd", default="make -B -j1 PYTHON=.venv/bin/python && shasum -c shiren.sha1", help="command used to verify a kept lift")
    parser.add_argument("--commit", action="store_true", help="git add/commit the file after each kept verified lift")
    parser.add_argument(
        "--commit-template",
        default="Lift raw batch {first_start}-{last_end} ({count} segments) in {file}",
        help="commit message template for kept lifts",
    )
    args = parser.parse_args(argv)

    path = _resolve_file(args.file)
    if args.mode == "segment":
        segments = sorted_segments(path, args.min_bytes, args.max_bytes)
        if args.limit is not None:
            segments = segments[: args.limit]
    else:
        clusters = sorted_clusters(path, args.min_bytes, args.max_bytes, args.raw_only)
        if args.limit is not None:
            clusters = clusters[: args.limit]

    if args.dry_run:
        if args.mode == "segment":
            for start_idx, end_idx, start_addr, end_addr in segments:
                print(
                    f"{start_addr:06X}-{end_addr:06X} "
                    f"segment bytes={end_addr - start_addr + 1} "
                    f"lines={start_idx + 1}-{end_idx + 1}"
                )
            print(f"planned lifts: {len(segments)}")
        else:
            for cluster in clusters:
                print(
                    f"{cluster.start_addr:06X}-{cluster.end_addr:06X} "
                    f"{cluster.kind} bytes={cluster.byte_count} "
                    f"lines={cluster.start_idx + 1}-{cluster.end_idx + 1}"
                )
            print(f"planned lifts: {len(clusters)}")
        return 0

    kept = 0
    failures: list[tuple[int, int, str]] = []
    baseline = snapshot(path)
    rel = path.relative_to(ROOT)

    work_items = (
        [(s[2], s[3]) for s in segments]
        if args.mode == "segment"
        else [(c.start_addr, c.end_addr) for c in clusters]
    )

    def process_batch(items: list[tuple[int, int]]) -> bool:
        nonlocal baseline, kept
        if not items:
            return True

        before = baseline
        for start_addr, end_addr in items:
            proc = apply_lift(rel, start_addr, end_addr)
            if proc.returncode != 0:
                restore(path, before)
                if len(items) > 1:
                    mid = len(items) // 2
                    left_ok = process_batch(items[:mid])
                    right_ok = process_batch(items[mid:])
                    return left_ok and right_ok
                print(f"FAIL  {start_addr:06X}-{end_addr:06X} apply")
                if proc.stderr:
                    print(proc.stderr.strip())
                if proc.stdout:
                    print(proc.stdout.strip())
                failures.append((start_addr, end_addr, "apply"))
                return False

        verify = run(args.verify_cmd)
        if verify.returncode == 0:
            if args.commit:
                commit_msg = format_batch_message(args.commit_template, rel, items)
                ok, reason = commit_if_needed(rel, commit_msg)
                if not ok:
                    restore(path, before)
                    if len(items) > 1:
                        mid = len(items) // 2
                        left_ok = process_batch(items[:mid])
                        right_ok = process_batch(items[mid:])
                        return left_ok and right_ok
                    print(f"FAIL  {items[0][0]:06X}-{items[0][1]:06X} {reason}")
                    failures.append((items[0][0], items[0][1], reason or "git"))
                    return False
            kept += len(items)
            baseline = snapshot(path)
            if len(items) == 1:
                start_addr, end_addr = items[0]
                print(f"KEPT  {start_addr:06X}-{end_addr:06X}")
            else:
                print(
                    f"KEPT  {items[0][0]:06X}-{items[-1][1]:06X} "
                    f"batch={len(items)}"
                )
            return True

        restore(path, before)
        if len(items) > 1:
            mid = len(items) // 2
            left_ok = process_batch(items[:mid])
            right_ok = process_batch(items[mid:])
            return left_ok and right_ok

        start_addr, end_addr = items[0]
        print(f"FAIL  {start_addr:06X}-{end_addr:06X} verify")
        if verify.stdout:
            print(verify.stdout.strip())
        if verify.stderr:
            print(verify.stderr.strip())
        failures.append((start_addr, end_addr, "verify"))
        return False

    for batch_start in range(0, len(work_items), args.batch_size):
        batch = work_items[batch_start : batch_start + args.batch_size]
        ok = process_batch(batch)
        if not ok and args.stop_on_fail:
            break

    print(f"kept lifts: {kept}/{len(work_items)}")
    if failures:
        print("failures:")
        for start_addr, end_addr, reason in failures:
            print(f"  {start_addr:06X}-{end_addr:06X} {reason}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
