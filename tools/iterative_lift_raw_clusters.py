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


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--file", required=True, help="asm file to process")
    parser.add_argument("--min-bytes", type=int, default=16, help="minimum cluster size")
    parser.add_argument("--max-bytes", type=int, help="maximum cluster size")
    parser.add_argument("--limit", type=int, help="maximum number of clusters to attempt")
    parser.add_argument("--raw-only", action="store_true", help="process raw-only clusters instead of mixed clusters")
    parser.add_argument("--mode", choices=("cluster", "segment"), default="segment", help="process whole mixed clusters or consecutive raw segments")
    parser.add_argument("--dry-run", action="store_true", help="list planned clusters without applying them")
    parser.add_argument("--stop-on-fail", action="store_true", help="stop on first failure")
    parser.add_argument("--verify-cmd", default="make -B -j1 PYTHON=.venv/bin/python && shasum -c shiren.sha1", help="command used to verify a kept lift")
    parser.add_argument("--commit", action="store_true", help="git add/commit the file after each kept verified lift")
    parser.add_argument(
        "--commit-template",
        default="Lift raw segment {start}-{end} in {file}",
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

    for start_addr, end_addr in work_items:
        before = baseline
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
        proc = subprocess.run(cmd, cwd=ROOT, text=True, capture_output=True)
        if proc.returncode != 0:
            restore(path, before)
            print(f"FAIL  {start_addr:06X}-{end_addr:06X} apply")
            if proc.stderr:
                print(proc.stderr.strip())
            if proc.stdout:
                print(proc.stdout.strip())
            failures.append((start_addr, end_addr, "apply"))
            if args.stop_on_fail:
                break
            continue

        verify = run(args.verify_cmd)
        if verify.returncode == 0:
            kept += 1
            baseline = snapshot(path)
            if args.commit:
                add_proc = run_argv(["git", "add", str(rel)])
                if add_proc.returncode != 0:
                    restore(path, before)
                    print(f"FAIL  {start_addr:06X}-{end_addr:06X} git-add")
                    if add_proc.stdout:
                        print(add_proc.stdout.strip())
                    if add_proc.stderr:
                        print(add_proc.stderr.strip())
                    failures.append((start_addr, end_addr, "git-add"))
                    if args.stop_on_fail:
                        break
                    continue
                cached_diff = run_argv(["git", "diff", "--cached", "--quiet", "--", str(rel)])
                if cached_diff.returncode == 0:
                    print(f"SKIP  {start_addr:06X}-{end_addr:06X} no staged diff")
                    continue
                if cached_diff.returncode not in (0, 1):
                    restore(path, before)
                    print(f"FAIL  {start_addr:06X}-{end_addr:06X} git-diff")
                    failures.append((start_addr, end_addr, "git-diff"))
                    if args.stop_on_fail:
                        break
                    continue
                commit_msg = args.commit_template.format(
                    start=f"{start_addr:06X}",
                    end=f"{end_addr:06X}",
                    file=str(rel),
                )
                commit_proc = run_argv(["git", "commit", "-m", commit_msg])
                if commit_proc.returncode != 0:
                    restore(path, before)
                    print(f"FAIL  {start_addr:06X}-{end_addr:06X} git-commit")
                    if commit_proc.stdout:
                        print(commit_proc.stdout.strip())
                    if commit_proc.stderr:
                        print(commit_proc.stderr.strip())
                    failures.append((start_addr, end_addr, "git-commit"))
                    if args.stop_on_fail:
                        break
                    continue
            print(f"KEPT  {start_addr:06X}-{end_addr:06X}")
            continue

        restore(path, before)
        print(f"FAIL  {start_addr:06X}-{end_addr:06X} verify")
        if verify.stdout:
            print(verify.stdout.strip())
        if verify.stderr:
            print(verify.stderr.strip())
        failures.append((start_addr, end_addr, "verify"))
        if args.stop_on_fail:
            break

    print(f"kept lifts: {kept}/{len(work_items)}")
    if failures:
        print("failures:")
        for start_addr, end_addr, reason in failures:
            print(f"  {start_addr:06X}-{end_addr:06X} {reason}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
