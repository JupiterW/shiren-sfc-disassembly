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
import re
import subprocess
import sys
from dataclasses import dataclass
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

CONTROL_MNEMONICS = {
    "jsl", "jsr", "jmp", "rtl", "rts", "php", "plp", "pha", "pla",
    "phx", "plx", "phy", "ply", "pea", "per", "rep", "sep",
}
BRANCH_MNEMONICS = {
    "beq", "bne", "bpl", "bmi", "bvs", "bvc", "bcc", "bcs", "bra", "brl",
}
SUSPICIOUS_MNEMONICS = {"rti", "brk", "cop", "wdm", "stp"}
HEX_OPERAND_RE = re.compile(r"\$([0-9A-F]{4,6})\b", re.IGNORECASE)
PREVIEW_ADDR_RE = re.compile(r";([0-9A-F]{6})\s*$")
PREVIEW_LABEL_RE = re.compile(r"^\s*([A-Za-z0-9_@.]+):\s*$")


@dataclass(frozen=True)
class WorkItem:
    start_addr: int
    end_addr: int
    exact_start: bool = False
    exact_end: bool = False


@dataclass(frozen=True)
class PreviewEntry:
    addr: int | None
    kind: str
    text: str
    mnemonic: str | None


def has_func_opcodes(lines: list[str], line_starts: list[int | None], start_addr: int, end_addr: int) -> bool:
    """Return True if any raw .db byte in [start_addr, end_addr] is a function call/return opcode."""
    for idx, line in enumerate(lines):
        ls = line_starts[idx]
        if ls is None:
            continue
        if not RAW_RE.match(line.strip()):
            continue
        db_bytes = _db_bytes_from_line(line)
        if not db_bytes:
            continue
        line_end = ls + len(db_bytes) - 1
        if ls > end_addr:
            break
        if line_end < start_addr:
            continue
        for offset, byte_val in enumerate(db_bytes):
            addr = ls + offset
            if start_addr <= addr <= end_addr and byte_val in FUNC_OPCODES:
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


def apply_lift(rel: Path, item: WorkItem) -> subprocess.CompletedProcess[str]:
    cmd = [
        sys.executable,
        "tools/lift_raw_cluster.py",
        "--file",
        str(rel),
        "--start",
        f"{item.start_addr:06X}",
        "--end",
        f"{item.end_addr:06X}",
        "--apply",
        "--quiet",
    ]
    if item.exact_start:
        cmd.append("--exact-start")
    if item.exact_end:
        cmd.append("--exact-end")
    return subprocess.run(cmd, cwd=ROOT, text=True, capture_output=True)


def preview_lift(rel: Path, item: WorkItem) -> subprocess.CompletedProcess[str]:
    cmd = [
        sys.executable,
        "tools/lift_raw_cluster.py",
        "--file",
        str(rel),
        "--start",
        f"{item.start_addr:06X}",
        "--end",
        f"{item.end_addr:06X}",
    ]
    if item.exact_start:
        cmd.append("--exact-start")
    if item.exact_end:
        cmd.append("--exact-end")
    return subprocess.run(cmd, cwd=ROOT, text=True, capture_output=True)


DATA_LABEL_PREFIXES = ("DATA", "UNREACH_")
DATA_LABEL_SUFFIXES = ("Table", "Table:", "Limits", "Limits:", "List", "List:", "Array", "Array:")
DATA_LABEL_SUBSTRINGS = ("Table", "JumpTable", "PtrTable", "Pointers")


def _looks_like_data_label(label: str) -> bool:
    # Strip trailing colon for comparisons
    name = (label[:-1] if label.endswith(":") else label).upper()
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


def _parse_preview(candidate: str) -> list[PreviewEntry]:
    entries: list[PreviewEntry] = []
    for raw_line in candidate.splitlines():
        if raw_line.startswith("; candidate lift for "):
            continue
        line = raw_line.rstrip()
        stripped = line.strip()
        if not stripped:
            entries.append(PreviewEntry(addr=None, kind="blank", text=line, mnemonic=None))
            continue
        label_match = PREVIEW_LABEL_RE.match(line)
        if label_match:
            entries.append(PreviewEntry(addr=None, kind="label", text=line, mnemonic=label_match.group(1)))
            continue

        addr_match = PREVIEW_ADDR_RE.search(line)
        addr = int(addr_match.group(1), 16) if addr_match else None
        body = PREVIEW_ADDR_RE.sub("", stripped).strip()
        parts = body.split(None, 1)
        mnemonic = parts[0].lower() if parts else None
        kind = "instr"
        if mnemonic == ".db":
            kind = "db"
        elif mnemonic == ".dw":
            kind = "dw"
        elif mnemonic in {".accu", ".index"}:
            kind = "directive"
        entries.append(PreviewEntry(addr=addr, kind=kind, text=body, mnemonic=mnemonic))
    return entries


def _operand_looks_table_like(text: str) -> bool:
    for match in HEX_OPERAND_RE.finditer(text):
        token = match.group(1).upper()
        if len(token) not in (4, 6):
            continue
        bytes_ = [token[i : i + 2] for i in range(0, len(token), 2)]
        edge_bytes = sum(1 for byte in bytes_ if byte in {"00", "FF"})
        if edge_bytes >= len(bytes_) - 1:
            return True
    return False


def _preview_window_score(entries: list[PreviewEntry], start_idx: int, window: int = 8) -> int:
    score = 0
    suspicious = 0
    control = 0
    data_words = 0
    inspected = 0

    for entry in entries[start_idx:]:
        if entry.kind == "blank":
            continue
        inspected += 1
        if entry.kind == "label":
            if entry.mnemonic and _looks_like_data_label(entry.mnemonic):
                score -= 6
            elif entry.mnemonic and entry.mnemonic.startswith("@"):
                score += 2
            continue
        if entry.kind in {"db", "dw"}:
            data_words += 1
            score -= 3 if entry.kind == "db" else 2
        elif entry.kind == "directive":
            score += 1
        elif entry.mnemonic is not None:
            if entry.mnemonic in CONTROL_MNEMONICS:
                control += 1
                score += 4
            elif entry.mnemonic in BRANCH_MNEMONICS:
                control += 1
                score += 3
            elif entry.mnemonic in SUSPICIOUS_MNEMONICS:
                suspicious += 1
                score -= 5
            else:
                score += 1
            if _operand_looks_table_like(entry.text):
                suspicious += 1
                score -= 4
        if inspected >= window:
            break

    if inspected == 0:
        return 0
    if data_words >= max(2, inspected // 2):
        score -= 4
    if control == 0 and suspicious >= 2:
        score -= 5
    if suspicious >= 3:
        score -= 4
    return score


def is_data_like_candidate(candidate: str) -> bool:
    entries = _parse_preview(candidate)
    content = [entry for entry in entries if entry.kind != "blank"]
    if not content:
        return False

    first = content[0]
    if first.kind == "label" and first.mnemonic is not None and _looks_like_data_label(first.mnemonic):
        return True

    # Preview windows that begin with repeated FF/00-style operands and have
    # no control-flow shape are almost always data tables that merely decode.
    return _preview_window_score(content, 0) <= -4


def _find_addr_entry(entries: list[PreviewEntry], addr: int) -> int | None:
    for idx, entry in enumerate(entries):
        if entry.addr == addr:
            return idx
    return None


def _first_code_start_after(entries: list[PreviewEntry], start_idx: int) -> int | None:
    best_idx: int | None = None
    best_score = -10**9
    for idx in range(start_idx, len(entries)):
        entry = entries[idx]
        if entry.addr is None or entry.kind != "instr":
            continue
        if entry.mnemonic in SUSPICIOUS_MNEMONICS:
            continue
        if _operand_looks_table_like(entry.text):
            continue

        score = _preview_window_score(entries, idx)
        if entry.mnemonic in CONTROL_MNEMONICS or entry.mnemonic in BRANCH_MNEMONICS:
            score += 4

        if score > best_score:
            best_idx = idx
            best_score = score

        # Prefer the first strongly plausible entry point rather than scanning
        # through an entire code island and landing on a later branch target.
        if score >= 10:
            return idx

    if best_idx is not None and best_score >= 6:
        return best_idx
    return None


def split_mixed_candidate(candidate: str, item: WorkItem) -> list[WorkItem] | None:
    entries = _parse_preview(candidate)
    addr_entries = [entry for entry in entries if entry.addr is not None]
    if not addr_entries:
        return None

    first_addr_idx = _find_addr_entry(entries, addr_entries[0].addr)
    if first_addr_idx is None:
        return None

    current_start = item.start_addr
    current_exact_start = item.exact_start
    first_score = _preview_window_score(entries, first_addr_idx)
    if first_score <= -4:
        next_code_idx = _first_code_start_after(entries, first_addr_idx + 1)
        if next_code_idx is None:
            return []
        next_start = entries[next_code_idx].addr
        if next_start is None or next_start <= item.start_addr:
            return []
        current_start = next_start
        current_exact_start = True

    split_items: list[WorkItem] = []
    idx = _find_addr_entry(entries, current_start)
    if idx is None:
        idx = first_addr_idx

    while idx < len(entries):
        entry = entries[idx]
        if entry.kind == "instr" and entry.mnemonic in {"rts", "rtl"} and entry.addr is not None:
            next_idx = idx + 1
            while next_idx < len(entries) and entries[next_idx].addr is None:
                next_idx += 1
            if next_idx >= len(entries):
                break
            if _preview_window_score(entries, next_idx) <= -4:
                next_code_idx = _first_code_start_after(entries, next_idx + 1)
                split_items.append(WorkItem(current_start, entry.addr, exact_start=current_exact_start))
                if next_code_idx is None:
                    return split_items
                next_start = entries[next_code_idx].addr
                if next_start is None or next_start <= entry.addr:
                    return split_items
                current_start = next_start
                current_exact_start = True
                idx = next_code_idx
                continue
        idx += 1

    final_item = WorkItem(current_start, item.end_addr, exact_start=current_exact_start, exact_end=item.exact_end)
    if not split_items and final_item == item:
        return None
    split_items.append(final_item)
    return split_items


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


def format_batch_message(template: str, rel: Path, items: list[WorkItem]) -> str:
    first_start = items[0].start_addr
    first_end = items[0].end_addr
    last_start = items[-1].start_addr
    last_end = items[-1].end_addr
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


def is_noop_candidate(lines: list[str], item: WorkItem) -> bool:
    start_idx, end_idx, out = build_candidate(
        lines,
        item.start_addr,
        item.end_addr,
        8,
        8,
        0,
        exact_start=item.exact_start,
        exact_end=item.exact_end,
    )
    current = [line.rstrip("\n") for line in lines[start_idx:end_idx]]
    return out == current


def refine_work_item(
    rel: Path,
    lines: list[str],
    line_starts: list[int | None],
    item: WorkItem,
    *,
    code_only: bool,
) -> tuple[list[WorkItem], dict[str, int]]:
    stats = {"no_func": 0, "data_like": 0, "noop": 0}
    if code_only and not has_func_opcodes(lines, line_starts, item.start_addr, item.end_addr):
        print(f"SKIP  {item.start_addr:06X}-{item.end_addr:06X} no-func-opcodes")
        stats["no_func"] += 1
        return [], stats

    preview = preview_lift(rel, item)
    if preview.returncode == 0:
        split_items = split_mixed_candidate(preview.stdout, item)
        if split_items is not None and split_items != [item]:
            if not split_items:
                print(f"SKIP  {item.start_addr:06X}-{item.end_addr:06X} data-like")
                stats["data_like"] += 1
                return [], stats
            kept: list[WorkItem] = []
            for split_item in split_items:
                refined, child_stats = refine_work_item(
                    rel,
                    lines,
                    line_starts,
                    split_item,
                    code_only=False,
                )
                kept.extend(refined)
                for key in stats:
                    stats[key] += child_stats[key]
            return kept, stats

        if is_data_like_candidate(preview.stdout):
            print(f"SKIP  {item.start_addr:06X}-{item.end_addr:06X} data-like")
            stats["data_like"] += 1
            return [], stats

    if is_noop_candidate(lines, item):
        print(f"SKIP  {item.start_addr:06X}-{item.end_addr:06X} noop")
        stats["noop"] += 1
        return [], stats

    return [item], stats


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

    kept = 0
    failures: list[tuple[int, int, str]] = []
    baseline = snapshot(path)
    rel = path.relative_to(ROOT)

    base_items = (
        [WorkItem(s[2], s[3]) for s in segments]
        if args.mode == "segment"
        else [WorkItem(c.start_addr, c.end_addr) for c in clusters]
    )
    base_items = [
        item
        for item in base_items
        if not overlaps_any_skip(item.start_addr, item.end_addr, args.skip_range)
    ]

    original_lines = load_lines(path)
    original_line_starts = _compute_line_starts(original_lines)

    skipped_data_like = 0
    skipped_noop = 0
    skipped_no_func = 0
    work_items: list[WorkItem] = []
    for item in base_items:
        refined, stats = refine_work_item(
            rel,
            original_lines,
            original_line_starts,
            item,
            code_only=args.code_only,
        )
        skipped_no_func += stats["no_func"]
        skipped_data_like += stats["data_like"]
        skipped_noop += stats["noop"]
        work_items.extend(refined)

    if args.dry_run:
        for item in work_items:
            extra = []
            if item.exact_start:
                extra.append("exact-start")
            if item.exact_end:
                extra.append("exact-end")
            extra_suffix = f" ({', '.join(extra)})" if extra else ""
            print(
                f"{item.start_addr:06X}-{item.end_addr:06X} "
                f"segment bytes={item.end_addr - item.start_addr + 1}"
                f"{extra_suffix}"
            )
        print(f"planned lifts: {len(work_items)}")
        return 0

    def process_batch(items: list[WorkItem]) -> bool:
        nonlocal baseline, kept
        if not items:
            return True

        before = baseline
        for item in items:
            proc = apply_lift(rel, item)
            if proc.returncode != 0:
                restore(path, before)
                if len(items) > 1:
                    mid = len(items) // 2
                    left_ok = process_batch(items[:mid])
                    right_ok = process_batch(items[mid:])
                    return left_ok and right_ok
                print(f"FAIL  {item.start_addr:06X}-{item.end_addr:06X} apply")
                if proc.stderr:
                    print(proc.stderr.strip())
                if proc.stdout:
                    print(proc.stdout.strip())
                failures.append((item.start_addr, item.end_addr, "apply"))
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
                if args.commit:
                    status = "KEPT+COMMIT" if committed else "KEPT-NOOP"
                else:
                    status = "KEPT"
                print(f"{status}  {items[0].start_addr:06X}-{items[0].end_addr:06X}")
            else:
                if args.commit:
                    status = "KEPT+COMMIT" if committed else "KEPT-NOOP"
                else:
                    status = "KEPT"
                print(
                    f"{status}  {items[0].start_addr:06X}-{items[-1].end_addr:06X} "
                    f"batch={len(items)}"
                )
            return True

        restore(path, before)
        if len(items) > 1:
            mid = len(items) // 2
            left_ok = process_batch(items[:mid])
            right_ok = process_batch(items[mid:])
            return left_ok and right_ok

        item = items[0]
        print(f"FAIL  {item.start_addr:06X}-{item.end_addr:06X} verify")
        if verify.stdout:
            print(verify.stdout.strip())
        if verify.stderr:
            print(verify.stderr.strip())
        failures.append((item.start_addr, item.end_addr, "verify"))
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
