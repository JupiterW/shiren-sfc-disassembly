#!/usr/bin/env python3
"""Emit or apply a candidate asm lift for a bounded raw cluster.

This is intentionally a review-first helper:
- find the source lines overlapping a ROM address range
- decode raw `.db` bytes inside that range with the same width-aware logic as
  `raw_db_decode.py`
- preserve existing non-raw asm lines
- emit a candidate replacement block to stdout
- optionally apply the replacement in place

Examples:
  python3 tools/lift_raw_cluster.py --file code/item_effects.asm --start C3186F --end C318A3
  python3 tools/lift_raw_cluster.py --file code/item_effects.asm --start C3186F --end C318A3 --apply --quiet
  python3 tools/lift_raw_cluster.py --file code/item_effects.asm --start C31649 --end C31657 --m-width 16 --x-width 16 --table16 5
"""

from __future__ import annotations

import argparse
import re
import sys
from dataclasses import dataclass
from pathlib import Path

from promote_raw_item_handler_label import (
    _db_bytes_from_line,
    estimate_asm_line_size,
    format_db_line,
    load_lines,
    parse_comment_addr,
    parse_label_addr,
    write_lines,
)
from raw_db_decode import DecodeState, decode_one, parse_addr


ROOT = Path(__file__).resolve().parents[1]
RAW_LINE_RE = re.compile(r"^\s*\.db\b")
SHORT_BRANCH_OPS = {
    0xF0: "beq",
    0xD0: "bne",
    0x10: "bpl",
    0x30: "bmi",
    0x80: "bra",
    0x90: "bcc",
    0xB0: "bcs",
}
OUT_ADDR_RE = re.compile(r";([0-9A-F]{6})\s*$")
OUT_BRANCH_RE = re.compile(r"^(\s*)(beq|bne|bpl|bmi|bra|bcc|bcs)\s+\$([0-9A-F]{5,6})(\s*;[0-9A-F]{6}\s*)$", re.IGNORECASE)


@dataclass
class DecodedInsn:
    addr: int
    size: int
    text: str
    opcode: int


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
) -> tuple[list[str], dict[int, str]]:
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

    decoded: list[DecodedInsn] = []
    while i < len(data):
        size, text = decode_one(data, i, base_addr, state)
        decoded.append(DecodedInsn(addr=base_addr + i, size=max(size, 1), text=text, opcode=data[i]))
        i += max(size, 1)

    branch_labels: dict[int, str] = {}
    for insn in decoded:
        if insn.opcode not in SHORT_BRANCH_OPS or insn.size < 2:
            continue
        disp = data[insn.addr - base_addr + 1]
        if disp >= 0x80:
            disp -= 0x100
        target = insn.addr + 2 + disp
        if base_addr <= target < base_addr + len(data):
            branch_labels.setdefault(target, f"@lbl_{target:06X}")

    offset = 0
    for insn in decoded:
        if insn.addr in branch_labels:
            out.append(f"{branch_labels[insn.addr]}:")
        if insn.text.startswith(".db "):
            chunk = data[offset : offset + insn.size]
            out.append(format_db_line(chunk, insn.addr))
        else:
            text = insn.text
            if insn.opcode in SHORT_BRANCH_OPS and insn.size >= 2:
                disp = data[offset + 1]
                if disp >= 0x80:
                    disp -= 0x100
                target = insn.addr + 2 + disp
                label = branch_labels.get(target)
                if label is not None:
                    text = f"{SHORT_BRANCH_OPS[insn.opcode]} {label}"
            out.append(f"{_fmt_instruction(text):<40} ;{insn.addr:06X}")
        offset += insn.size

    return out, branch_labels


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


def _rewrite_output_branches(out: list[str]) -> list[str]:
    labels: dict[int, str] = {}
    line_addrs: dict[int, int] = {}
    for idx, line in enumerate(out):
        match = OUT_ADDR_RE.search(line)
        if not match:
            continue
        addr = int(match.group(1), 16)
        line_addrs[addr] = idx

    for line in out:
        match = OUT_BRANCH_RE.match(line)
        if not match:
            continue
        target = int(match.group(3), 16)
        if target not in line_addrs and target < 0x100000:
            banked = target | 0xC00000
            if banked in line_addrs:
                target = banked
        if target in line_addrs:
            labels.setdefault(target, f"@lbl_{target:06X}")

    if not labels:
        return out

    rewritten: list[str] = []
    for idx, line in enumerate(out):
        match = OUT_ADDR_RE.search(line)
        if match:
            addr = int(match.group(1), 16)
            label = labels.get(addr)
            if label is not None:
                rewritten.append(f"{label}:")

        branch_match = OUT_BRANCH_RE.match(line)
        if branch_match:
            indent, op, target_hex, suffix = branch_match.groups()
            target = int(target_hex, 16)
            if target not in line_addrs and target < 0x100000:
                banked = target | 0xC00000
                if banked in line_addrs:
                    target = banked
            label = labels.get(target)
            if label is not None:
                line = f"{indent}{op} {label}{suffix}"
        rewritten.append(line)

    return rewritten


def build_candidate(lines: list[str], start_addr: int, end_addr: int, m_width: int, x_width: int, table16: int) -> tuple[int, int, list[str]]:
    start_idx: int | None = None
    end_idx: int | None = None
    out: list[str] = []
    line_starts = _compute_line_starts(lines)
    state = DecodeState(m_width=m_width, x_width=x_width)
    used_table16 = False
    skip_until = -1
    pending_labels: dict[int, str] = {}

    for idx, line in enumerate(lines):
        if idx <= skip_until:
            continue
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

        if line_start in pending_labels:
            out.append(f"{pending_labels.pop(line_start)}:")

        if RAW_LINE_RE.match(stripped):
            raw_lines: list[tuple[int, list[int]]] = []
            j = idx
            while j < len(lines):
                next_line = lines[j]
                next_stripped = next_line.strip()
                if not RAW_LINE_RE.match(next_stripped):
                    break
                next_start = line_starts[j]
                next_bytes = _db_bytes_from_line(next_line)
                if next_start is None or not next_bytes:
                    break
                raw_lines.append((next_start, next_bytes))
                j += 1

            skip_until = j - 1
            if not raw_lines:
                out.append(line.rstrip("\n"))
                continue

            raw_start = raw_lines[0][0]
            combined: list[int] = []
            for _, next_bytes in raw_lines:
                combined.extend(next_bytes)
            raw_end = raw_start + len(combined) - 1
            if raw_end < start_addr or raw_start > end_addr:
                for raw_line_idx in range(idx, j):
                    out.append(lines[raw_line_idx].rstrip("\n"))
                continue
            seg_start = max(start_addr, raw_start)
            seg_end = min(end_addr, raw_end)
            prefix = combined[: seg_start - raw_start]
            suffix = combined[seg_end - raw_start + 1 :]
            if prefix:
                out.append(format_db_line(prefix, raw_start))
            middle = combined[seg_start - raw_start : seg_end - raw_start + 1]
            decoded_lines, branch_labels = _emit_decoded_lines(
                middle,
                seg_start,
                state,
                table16 if not used_table16 and seg_start == start_addr else 0,
            )
            out.extend(decoded_lines)
            for target, label in branch_labels.items():
                pending_labels.setdefault(target, label)
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

    out = _rewrite_output_branches(out)
    return start_idx, end_idx, out


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--file", required=True, help="asm file containing the raw cluster")
    parser.add_argument("--start", required=True, help="start ROM address, e.g. C3186F")
    parser.add_argument("--end", required=True, help="end ROM address, e.g. C318A3")
    parser.add_argument("--m-width", type=int, choices=(8, 16), default=8, help="initial accumulator width")
    parser.add_argument("--x-width", type=int, choices=(8, 16), default=8, help="initial index width")
    parser.add_argument("--table16", type=int, default=0, help="decode first N words of the first raw segment as .dw jump-table targets")
    parser.add_argument("--apply", action="store_true", help="rewrite the selected cluster in place")
    parser.add_argument("--quiet", action="store_true", help="suppress candidate output; useful with --apply")
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

    if args.apply:
        new_lines = lines[:start_idx] + out + lines[end_idx:]
        write_lines(path, new_lines)
        if args.quiet:
            print(f"applied {path.relative_to(ROOT)}:{start_idx + 1}-{end_idx}")
        else:
            print(f"; applied lift to {path.relative_to(ROOT)}:{start_idx + 1}-{end_idx}")
            for line in out:
                print(line)
        return 0

    print(f"; candidate lift for {path.relative_to(ROOT)}:{start_idx + 1}-{end_idx}")
    for line in out:
        print(line)
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
