#!/usr/bin/env python3
"""Iteratively apply raw-cluster lifts to one file, verifying after each batch.

Examples:
  python3 tools/iterative_lift_raw_clusters.py --file code/item_effects.asm --dry-run
  python3 tools/iterative_lift_raw_clusters.py --file code/item_effects.asm --limit 3
  python3 tools/iterative_lift_raw_clusters.py --file code/item_effects.asm --limit 10 --commit
  python3 tools/iterative_lift_raw_clusters.py --file code/item_effects.asm --batch-size 5
  python3 tools/iterative_lift_raw_clusters.py --file code/graphics_decompress.asm --code-only --commit --min-bytes 1
"""

from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path

from list_raw_clusters import RAW_RE, find_clusters
from lift_raw_cluster import ROOT, _compute_line_starts, _resolve_file, build_candidate
from promote_raw_item_handler_label import _db_bytes_from_line, estimate_asm_line_size, load_lines

# 65816 opcodes that unambiguously indicate executable code (subroutine calls and returns).
# A raw .db cluster containing any of these bytes is almost certainly code, not a data table.
FUNC_OPCODES: frozenset[int] = frozenset({
    0x20,  # JSR abs
    0x22,  # JSL abs long
    0x40,  # RTI
    0x60,  # RTS
    0x6B,  # RTL
    0xFC,  # JSR (abs,X)
})


def has_func_opcodes(lines: list[str], line_starts: list[int | None], start_addr: int, end_addr: int) -> bool:
    """Return True if any raw .db byte in [start_addr, end_addr] is a function call/return opcode."""
    for idx, line in enumerate(lines):
        ls = line_starts[idx]
        if ls is None:
            continue
        if ls > end_addr:
            break
        if ls < start_addr:
            continue
        if not RAW_RE.match(line.strip()):
            continue
        for byte_val in _db_bytes_from_line(line):
            if byte_val in FUNC_OPCODES:
                return True
    return False


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


def preview_lift(rel: Path, start_addr: int, end_addr: int) -> subprocess.CompletedProcess[str]:
    cmd = [
        sys.executable,
        "tools/lift_raw_cluster.py",
        "--file",
        str(rel),
        "--start",
        f"{start_addr:06X}",
        "--end",
        f"{end_addr:06X}",
    ]
    return subprocess.run(cmd, cwd=ROOT, text=True, capture_output=True)


DATA_LABEL_PREFIXES = ("DATA", "UNREACH_")
DATA_LABEL_SUFFIXES = ("Table", "Table:", "Limits", "Limits:", "List", "List:", "Array", "Array:")
DATA_LABEL_SUBSTRINGS = ("Table", "JumpTable", "PtrTable", "Pointers")


def _looks_like_data_label(label: str) -> bool:
    # Strip trailing colon for comparisons
    name = label[:-1] if label.endswith(":") else label
    if not name:
        return False
    if any(name.startswith(prefix) for prefix in DATA_LABEL_PREFIXES):
        return True
    if any(substr in name for substr in DATA_LABEL_SUBSTRINGS):
        return True
    for suffix in ("Table", "Limits", "List", "Array", "Pointers"):
        if name.endswith(suffix):
            return True
    return False


def is_data_like_candidate(candidate: str) -> bool:
    lines = [line.rstrip() for line in candidate.splitlines()]
    content = [line.strip() for line in lines if line.strip() and not line.lstrip().startswith(";")]
    if not content:
        return False

    first = content[0]
    if not first.endswith(":"):
        return False

    # A data-table label is a strong enough signal on its own — the decoded
    # output will show opcodes (data bytes decode as valid instructions), so
    # the .db ratio check is unreliable here.
    return _looks_like_data_label(first)


def commit_if_needed(rel: Path, message: str) -> tuple[bool, str | None, bool]:
    add_proc = run_argv(["git", "add", str(rel)])
    if add_proc.returncode != 0:
        return False, "git-add", False

    cached_diff = run_argv(["git", "diff", "--cached", "--quiet", "--", str(rel)])
    if cached_diff.returncode == 0:
        return True, None, False
    if cached_diff.returncode not in (0, 1):
        return False, "git-diff", False

    commit_proc = run_argv(["git", "commit", "-m", message])
    if commit_proc.returncode != 0:
        return False, "git-commit", False
    return True, None, True


def sorted_clusters(path: Path, min_bytes: int, max_bytes: int | None, kind: str) -> list:
    clusters = find_clusters(load_lines(path))
    clusters = [c for c in clusters if c.byte_count >= min_bytes]
    if max_bytes is not None:
        clusters = [c for c in clusters if c.byte_count <= max_bytes]
    if kind != "all":
        clusters = [c for c in clusters if c.kind == kind]
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
            elif end_addr is not None and line_start != end_addr + 1:
                # Address gap — finish current segment, start a new one
                finish(idx - 1)
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
        end=f"{last_end:06X}",
        first_start=f"{first_start:06X}",
        first_end=f"{first_end:06X}",
        last_start=f"{last_start:06X}",
        last_end=f"{last_end:06X}",
        count=len(items),
        file=str(rel),
    )


def parse_skip_range(text: str) -> tuple[int, int]:
    token = text.strip().upper()
    if "-" not in token:
        raise argparse.ArgumentTypeError("skip range must look like START-END")
    start_text, end_text = token.split("-", 1)
    try:
        start = int(start_text, 16)
        end = int(end_text, 16)
    except ValueError as exc:
        raise argparse.ArgumentTypeError(f"invalid hex skip range: {text}") from exc
    if start > end:
        raise argparse.ArgumentTypeError("skip range start must be <= end")
    return start, end


def overlaps_any_skip(start_addr: int, end_addr: int, skip_ranges: list[tuple[int, int]]) -> bool:
    for skip_start, skip_end in skip_ranges:
        if start_addr <= skip_end and end_addr >= skip_start:
            return True
    return False


def is_noop_candidate(lines: list[str], start_addr: int, end_addr: int) -> bool:
    start_idx, end_idx, out = build_candidate(lines, start_addr, end_addr, 8, 8, 0)
    current = [line.rstrip("\n") for line in lines[start_idx:end_idx]]
    return out == current


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--file", required=True, help="asm file to process")
    parser.add_argument("--min-bytes", type=int, default=16, help="minimum cluster size")
    parser.add_argument("--max-bytes", type=int, help="maximum cluster size")
    parser.add_argument("--limit", type=int, help="maximum number of clusters to attempt")
    parser.add_argument("--batch-size", type=int, default=5, help="apply this many segments at once before verify; failed batches are bisected")
    parser.add_argument("--kind", choices=("mixed", "raw-only", "all"), default="mixed", help="cluster kind to process (default: mixed)")
    parser.add_argument("--mode", choices=("cluster", "segment"), default="segment", help="process whole mixed clusters or consecutive raw segments")
    parser.add_argument("--dry-run", action="store_true", help="list planned clusters without applying them")
    parser.add_argument("--stop-on-fail", action="store_true", help="stop when an entire batch fails (individual items may still fail within a kept batch)")
    parser.add_argument("--verify-cmd", default="make -B -j1 PYTHON=.venv/bin/python && shasum -c shiren.sha1", help="command used to verify a kept lift")
    parser.add_argument("--skip-range", action="append", type=parse_skip_range, default=[], help="skip any candidate range overlapping START-END hex ROM addresses")
    parser.add_argument("--code-only", action="store_true", help="skip raw clusters that contain no function call/return opcodes (jsl, jsr, rts, rtl, rti)")
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
        clusters = sorted_clusters(path, args.min_bytes, args.max_bytes, args.kind)
        if args.limit is not None:
            clusters = clusters[: args.limit]

    if args.dry_run:
        dry_lines = load_lines(path) if args.code_only else []
        dry_line_starts = _compute_line_starts(dry_lines) if args.code_only else []
        if args.mode == "segment":
            kept_count = 0
            for start_idx, end_idx, start_addr, end_addr in segments:
                if args.code_only and not has_func_opcodes(dry_lines, dry_line_starts, start_addr, end_addr):
                    print(f"SKIP  {start_addr:06X}-{end_addr:06X} no-func-opcodes")
                    continue
                print(
                    f"{start_addr:06X}-{end_addr:06X} "
                    f"segment bytes={end_addr - start_addr + 1} "
                    f"lines={start_idx + 1}-{end_idx + 1}"
                )
                kept_count += 1
            print(f"planned lifts: {kept_count}")
        else:
            kept_count = 0
            for cluster in clusters:
                if args.code_only and not has_func_opcodes(dry_lines, dry_line_starts, cluster.start_addr, cluster.end_addr):
                    print(f"SKIP  {cluster.start_addr:06X}-{cluster.end_addr:06X} no-func-opcodes")
                    continue
                print(
                    f"{cluster.start_addr:06X}-{cluster.end_addr:06X} "
                    f"{cluster.kind} bytes={cluster.byte_count} "
                    f"lines={cluster.start_idx + 1}-{cluster.end_idx + 1}"
                )
                kept_count += 1
            print(f"planned lifts: {kept_count}")
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
    work_items = [item for item in work_items if not overlaps_any_skip(item[0], item[1], args.skip_range)]

    # Pre-filter data-like and no-op items before batching to avoid wasted make cycles
    skipped_data_like = 0
    skipped_noop = 0
    skipped_no_func = 0
    filtered_items: list[tuple[int, int]] = []
    original_lines = load_lines(path)
    original_line_starts = _compute_line_starts(original_lines) if args.code_only else []
    for item in work_items:
        if args.code_only and not has_func_opcodes(original_lines, original_line_starts, item[0], item[1]):
            print(f"SKIP  {item[0]:06X}-{item[1]:06X} no-func-opcodes")
            skipped_no_func += 1
            continue
        preview = preview_lift(rel, item[0], item[1])
        if preview.returncode == 0 and is_data_like_candidate(preview.stdout):
            print(f"SKIP  {item[0]:06X}-{item[1]:06X} data-like")
            skipped_data_like += 1
            continue
        if is_noop_candidate(original_lines, item[0], item[1]):
            print(f"SKIP  {item[0]:06X}-{item[1]:06X} noop")
            skipped_noop += 1
            continue
        filtered_items.append(item)
    work_items = filtered_items

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
            committed = False
            if args.commit:
                commit_msg = format_batch_message(args.commit_template, rel, items)
                ok, reason, committed = commit_if_needed(rel, commit_msg)
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
                if args.commit:
                    status = "KEPT+COMMIT" if committed else "KEPT-NOOP"
                else:
                    status = "KEPT"
                print(f"{status}  {start_addr:06X}-{end_addr:06X}")
            else:
                if args.commit:
                    status = "KEPT+COMMIT" if committed else "KEPT-NOOP"
                else:
                    status = "KEPT"
                print(
                    f"{status}  {items[0][0]:06X}-{items[-1][1]:06X} "
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

    skipped_parts: list[str] = []
    if skipped_no_func:
        skipped_parts.append(f"{skipped_no_func} no-func-opcodes")
    if skipped_data_like:
        skipped_parts.append(f"{skipped_data_like} data-like")
    if skipped_noop:
        skipped_parts.append(f"{skipped_noop} noop")
    skipped_suffix = f" (skipped {', '.join(skipped_parts)})" if skipped_parts else ""
    print(f"kept lifts: {kept}/{len(work_items)}{skipped_suffix}")
    if failures:
        print("failures:")
        for start_addr, end_addr, reason in failures:
            print(f"  {start_addr:06X}-{end_addr:06X} {reason}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
