#!/usr/bin/env python3
"""Emit a candidate asm lift for a bounded raw cluster.

This is intentionally a review-first helper:
- find the source lines overlapping a ROM address range
- decode raw `.db` bytes inside that range with the same width-aware logic as
  `raw_db_decode.py`
- preserve existing non-raw asm lines
- emit a candidate replacement block to stdout

Examples:
  python3 tools/lift_raw_cluster.py --file code/item_effects.asm --start C3186F --end C318A3
  python3 tools/lift_raw_cluster.py --file code/item_effects.asm --start C31649 --end C31657 --m-width 16 --x-width 16 --table16 5
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

from promote_raw_item_handler_label import (
    _db_bytes_from_line,
    estimate_asm_line_size,
    format_db_line,
    load_lines,
    parse_comment_addr,
    parse_label_addr,
)
from raw_db_decode import DecodeState, decode_one, parse_addr


ROOT = Path(__file__).resolve().parents[1]
RAW_LINE_RE = re.compile(r"^\s*\.db\b")


def _resolve_file(path_text: str) -> Path:
    path = Path(path_text)
    if not path.is_absolute():
        path = ROOT / path
    return path


def _fmt_operand(operand: str) -> str:
    text = operand.strip()
    if not text:
        return text
    if text.startswith("$C"):
        return f"${text[2:]}"
    return text


def _fmt_instruction(text: str) -> str:
    if " " not in text:
        return f"\t{text}"
    op, operand = text.split(" ", 1)
    return f"\t{op} { _fmt_operand(operand) }".rstrip()


def _emit_decoded_lines(
    data: list[int], base_addr: int, state: DecodeState, table16: int
) -> list[str]:
    out: list[str] = []
    i = 0

    if table16:
        if len(data) < table16 * 2:
            raise ValueError("not enough bytes for requested --table16 count")
        bank = base_addr & 0xFF0000
        for idx in range(table16):
            off = idx * 2
            target = data[off] | (data[off + 1] << 8)
            out.append(f"\t.dw ${bank | target:06X}")
        i = table16 * 2

    while i < len(data):
        size, text = decode_one(data, i, base_addr, state)
        addr = base_addr + i
        if text.startswith(".db "):
            chunk = data[i : i + size]
            out.append(format_db_line(chunk, addr))
        else:
            out.append(f"{_fmt_instruction(text):<40} ;{addr:06X}")
        i += max(size, 1)

    return out


def _compute_line_starts(lines: list[str]) -> list[int | None]:
    starts: list[int | None] = []
    current_addr: int | None = None

    for line in lines:
        label_addr = parse_label_addr(line)
        comment_addr = parse_comment_addr(line)

        if current_addr is None:
            if label_addr is not None:
                current_addr = label_addr
            elif comment_addr is not None:
                current_addr = comment_addr
        else:
            if label_addr is not None and label_addr >= current_addr:
                current_addr = label_addr
            elif comment_addr is not None and comment_addr >= current_addr:
                current_addr = comment_addr

        starts.append(current_addr)

        size = estimate_asm_line_size(line.strip())
        if current_addr is not None and size is not None and size > 0:
            current_addr += size

    return starts


def _advance_state_from_asm_line(stripped: str, state: DecodeState) -> None:
    if not stripped or stripped.startswith(";") or stripped.endswith(":"):
        return
    parts = stripped.split(None, 1)
    op = parts[0].lower()
    arg = parts[1] if len(parts) > 1 else ""
    if op not in {"rep", "sep"}:
        return
    if "#" not in arg:
        return
    token = arg.split("#", 1)[1].strip()
    token = token.removeprefix("$").split()[0]
    try:
        mask = int(token, 16)
    except ValueError:
        return
    if mask & 0x20:
        state.m_width = 8 if op == "sep" else 16
    if mask & 0x10:
        state.x_width = 8 if op == "sep" else 16


def build_candidate(lines: list[str], start_addr: int, end_addr: int, m_width: int, x_width: int, table16: int) -> tuple[int, int, list[str]]:
    start_idx: int | None = None
    end_idx: int | None = None
    out: list[str] = []
    line_starts = _compute_line_starts(lines)
    state = DecodeState(m_width=m_width, x_width=x_width)
    used_table16 = False

    for idx, line in enumerate(lines):
        stripped = line.strip()
        line_start = line_starts[idx]
        line_size = estimate_asm_line_size(stripped)
        line_end = None if line_start is None or line_size in (None, 0) else line_start + line_size - 1

        if start_idx is None and line_start is not None and line_start <= start_addr <= (line_end or line_start):
            start_idx = idx

        if start_idx is None:
            continue

        if line_start is None:
            out.append(line.rstrip("\n"))
            continue

        if line_start > end_addr:
            end_idx = idx
            break

        if RAW_LINE_RE.match(stripped):
            bytes_ = _db_bytes_from_line(line)
            if not bytes_:
                out.append(line.rstrip("\n"))
                continue
            raw_start = line_start
            if raw_start is None:
                out.append(line.rstrip("\n"))
                continue
            raw_end = raw_start + len(bytes_) - 1
            if raw_end < start_addr or raw_start > end_addr:
                out.append(line.rstrip("\n"))
                continue
            seg_start = max(start_addr, raw_start)
            seg_end = min(end_addr, raw_end)
            prefix = bytes_[: seg_start - raw_start]
            suffix = bytes_[seg_end - raw_start + 1 :]
            if prefix:
                out.append(format_db_line(prefix, raw_start))
            middle = bytes_[seg_start - raw_start : seg_end - raw_start + 1]
            out.extend(_emit_decoded_lines(middle, seg_start, state, table16 if not used_table16 and seg_start == start_addr else 0))
            if table16 and seg_start == start_addr:
                used_table16 = True
            if suffix:
                out.append(format_db_line(suffix, seg_end + 1))
            continue

        _advance_state_from_asm_line(stripped, state)
        out.append(line.rstrip("\n"))

    if start_idx is None:
        raise SystemExit(f"no source region found for start address {start_addr:06X}")
    if end_idx is None:
        end_idx = len(lines)

    return start_idx, end_idx, out


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--file", required=True, help="asm file containing the raw cluster")
    parser.add_argument("--start", required=True, help="start ROM address, e.g. C3186F")
    parser.add_argument("--end", required=True, help="end ROM address, e.g. C318A3")
    parser.add_argument("--m-width", type=int, choices=(8, 16), default=8, help="initial accumulator width")
    parser.add_argument("--x-width", type=int, choices=(8, 16), default=8, help="initial index width")
    parser.add_argument("--table16", type=int, default=0, help="decode first N words of the first raw segment as .dw jump-table targets")
    args = parser.parse_args(argv)

    path = _resolve_file(args.file)
    lines = load_lines(path)
    start_addr = parse_addr(args.start)
    end_addr = parse_addr(args.end)
    if start_addr is None or end_addr is None:
        raise SystemExit("invalid start/end address")
    if start_addr > end_addr:
        raise SystemExit("start must be <= end")

    start_idx, end_idx, out = build_candidate(lines, start_addr, end_addr, args.m_width, args.x_width, args.table16)
    print(f"; candidate lift for {path.relative_to(ROOT)}:{start_idx + 1}-{end_idx}")
    for line in out:
        print(line)
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
