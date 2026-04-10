#!/usr/bin/env python3
"""Promote a raw item handler entry into a standalone label and verify the build.

This tool is for the next step after item pipeline / raw tracing:
- item points at a raw use/throw handler
- the handler lives inside a `.db` byte region
- we want to split the `.db` line at the exact entry address
- insert a standalone label
- rewrite the table entry using the correct `Label` vs `Label-1` form
- rebuild and verify

Examples:
  python3 tools/promote_raw_item_handler_label.py Item_HappinessHerb HappinessHerbUseEffect --effect use --dry-run
  python3 tools/promote_raw_item_handler_label.py Item_HappinessHerb HappinessHerbUseEffect --effect use
"""

from __future__ import annotations

import argparse
import re
import subprocess
import sys
from pathlib import Path

from item_pipeline import ROOT, BANK03_PATH, build_item_infos, match_query
from raw_handler_trace import normalize_addr, find_containing_region
from safe_item_handler_rename import (
    load_lines,
    write_lines,
    update_table_entry,
    choose_table_expr,
)


DB_TOKEN_RE = re.compile(r"\$([0-9A-F]{2})")
DW_TOKEN_RE = re.compile(r"\$([0-9A-F]{4})")
COMMENT_ADDR_RE = re.compile(r";C?(?P<addr>[0-9A-F]{5,6})\b")
LABEL_RE = re.compile(r"^[A-Za-z0-9_@.]+:\s*$")
LABEL_ADDR_RE = re.compile(r"C(?P<addr>[0-9A-F]{5,6})")
LABEL_NAME_RE = re.compile(r"^(?P<label>[A-Za-z0-9_@.]+):\s*$")


def _db_bytes_from_line(line: str) -> list[int]:
    return [int(tok.group(1), 16) for tok in DB_TOKEN_RE.finditer(line.split(";")[0])]


def _dw_bytes_from_line(line: str) -> list[int]:
    out: list[int] = []
    for tok in DW_TOKEN_RE.finditer(line.split(";")[0]):
        word = int(tok.group(1), 16)
        out.extend([word & 0xFF, (word >> 8) & 0xFF])
    return out


def find_item(query: str):
    infos = build_item_infos()
    matches = [info for info in infos if match_query(info, query)]
    if not matches:
        raise SystemExit(f"no item matches query: {query}")
    return matches[0]


def format_db_line(bytes_: list[int], addr: int | None = None) -> str:
    body = ",".join(f"${byte:02X}" for byte in bytes_)
    if addr is None:
        return f"\t.db {body}"
    return f"\t.db {body}   ;{addr:06X}"


def format_dw_line(bytes_: list[int]) -> str:
    if len(bytes_) % 2 != 0:
        raise ValueError("dw line requires an even number of bytes")
    words = []
    for i in range(0, len(bytes_), 2):
        word = bytes_[i] | (bytes_[i + 1] << 8)
        words.append(f"${word:04X}")
    return "\t.dw " + ",".join(words)


def parse_comment_addr(line: str) -> int | None:
    match = COMMENT_ADDR_RE.search(line)
    if not match:
        return None
    token = match.group("addr")
    if len(token) == 5:
        token = f"C{token}"
    return int(token, 16)


def parse_label_addr(line: str) -> int | None:
    stripped = line.strip()
    if not LABEL_RE.match(stripped):
        return None
    name = stripped[:-1]
    match = LABEL_ADDR_RE.search(name)
    if not match:
        return None
    token = match.group("addr")
    if len(token) == 5:
        token = f"C{token}"
    return int(token, 16)


def parse_label_name(line: str) -> str | None:
    stripped = line.strip()
    match = LABEL_NAME_RE.match(stripped)
    if not match:
        return None
    return match.group("label")


def replace_label_refs(text: str, old: str, new: str) -> str:
    return re.sub(rf"(?<![A-Za-z0-9_@.]){re.escape(old)}(?![A-Za-z0-9_@.])", new, text)


def normalize_local_labels(lines: list[str], insert_idx: int) -> None:
    parent_start: int | None = None
    for scan in range(insert_idx - 1, -1, -1):
        label = parse_label_name(lines[scan])
        if label and not label.startswith("@"):
            parent_start = scan
            break
    if parent_start is None:
        return

    parent_end = len(lines)
    for scan in range(parent_start + 1, len(lines)):
        label = parse_label_name(lines[scan])
        if label and not label.startswith("@"):
            parent_end = scan
            break

    renames: list[tuple[str, str]] = []
    for scan in range(parent_start + 1, parent_end):
        label = parse_label_name(lines[scan])
        if not label or not label.startswith("@"):
            continue
        renames.append((label, label[1:]))

    if not renames:
        return

    for old, new in renames:
        for scan in range(parent_start, parent_end):
            lines[scan] = replace_label_refs(lines[scan], old, new)


def db_line_end_addr(line: str) -> int | None:
    start = parse_comment_addr(line)
    if start is None:
        return None
    if ".db" in line:
        bytes_ = _db_bytes_from_line(line)
    elif ".dw" in line:
        bytes_ = _dw_bytes_from_line(line)
    else:
        return None
    if not bytes_:
        return None
    return start + len(bytes_)


def estimate_asm_line_size(stripped: str) -> int | None:
    if not stripped or stripped.startswith(";") or LABEL_RE.match(stripped):
        return 0
    if ".db " in stripped or stripped.startswith(".db"):
        bytes_ = _db_bytes_from_line(stripped)
        return len(bytes_) if bytes_ else None
    if ".dw " in stripped or stripped.startswith(".dw"):
        body = stripped.split(".dw", 1)[1].strip()
        if not body:
            return None
        parts = [part.strip() for part in body.split(",") if part.strip()]
        return len(parts) * 2 if parts else None

    op = stripped.split()[0]
    rest = stripped[len(op):].strip()
    op = op.lower()
    op_base = op.split(".", 1)[0]

    one_byte = {
        "pha",
        "pla",
        "phx",
        "plx",
        "phy",
        "ply",
        "phb",
        "plb",
        "php",
        "plp",
        "rts",
        "rtl",
        "tax",
        "txa",
        "tay",
        "tya",
        "xba",
        "tsx",
        "txs",
        "dex",
        "inx",
        "dey",
        "iny",
        "clc",
        "sec",
        "xce",
        "nop",
        "inc",
        "dec",
    }
    if op_base in one_byte and (not rest or rest == "a"):
        return 1
    if op_base in {"sep", "rep"}:
        return 2
    if op_base in {"bra", "bcc", "bcs", "beq", "bmi", "bne", "bpl", "bvc", "bvs"}:
        return 2
    if op_base == "jsl":
        return 4
    if op_base in {"jsr", "jmp"}:
        return 3
    if op_base == "call_savebank":
        return 4

    if "#" in rest:
        if ".l" in op or ".l " in stripped:
            return 4
        if ".w" in op:
            return 3
        return 2

    if ",s" in rest or rest.endswith(",s"):
        return 2
    if ".w" in op:
        return 3
    if ".l" in op:
        return 4
    if op_base in {"lda", "sta", "ldx", "stx", "ldy", "sty", "cmp", "cpx", "cpy", "adc", "sbc", "eor", "and", "ora", "bit", "stz"}:
        return 2
    return None


def promote_asm_entry(path: Path, entry_addr: int, new_symbol: str, dry_run: bool) -> tuple[int, str]:
    lines = load_lines(path)
    for idx, line in enumerate(lines):
        if db_line_end_addr(line) != entry_addr:
            continue
        insert_at = idx + 1
        while insert_at < len(lines):
            stripped = lines[insert_at].strip()
            if not stripped or stripped.startswith(";"):
                insert_at += 1
                continue
            break
        if insert_at >= len(lines):
            break
        normalize_local_labels(lines, insert_at)
        lines.insert(insert_at, f"{new_symbol}:")
        if not dry_run:
            write_lines(path, lines)
        return insert_at + 1, "\n".join([f"{new_symbol}:", lines[insert_at + 1]])
    raise SystemExit(f"no promotable asm entry found at {entry_addr:06X}")


def promote_mixed_region_entry(path: Path, entry_addr: int, new_symbol: str, dry_run: bool) -> tuple[int, str]:
    lines = load_lines(path)
    current_addr: int | None = None
    for idx, line in enumerate(lines):
        stripped = line.strip()
        comment_addr = parse_comment_addr(line)
        if comment_addr is not None and (current_addr is None or comment_addr >= current_addr):
            current_addr = comment_addr
        label_addr = parse_label_addr(line)
        if label_addr is not None and (current_addr is None or label_addr >= current_addr):
            current_addr = label_addr
        size = estimate_asm_line_size(stripped)
        if current_addr is None or size is None:
            continue
        if size == 0:
            continue
        if ".db " in stripped or stripped.startswith(".db"):
            end_addr = current_addr + size
            if current_addr < entry_addr < end_addr:
                bytes_ = _db_bytes_from_line(line)
                offset = entry_addr - current_addr
                replacement = [
                    format_db_line(bytes_[:offset], current_addr),
                    f"{new_symbol}:",
                    format_db_line(bytes_[offset:], entry_addr),
                ]
                lines[idx : idx + 1] = replacement
                if not dry_run:
                    write_lines(path, lines)
                return idx + 1, "\n".join(replacement)
        if ".dw " in stripped or stripped.startswith(".dw"):
            end_addr = current_addr + size
            if current_addr < entry_addr < end_addr:
                bytes_ = _dw_bytes_from_line(line)
                offset = entry_addr - current_addr
                if offset % 2 != 0:
                    raise SystemExit(f"entry {entry_addr:06X} is in the middle of a .dw word")
                replacement: list[str] = []
                if offset:
                    replacement.append(format_dw_line(bytes_[:offset]))
                replacement.append(f"{new_symbol}:")
                if offset < len(bytes_):
                    replacement.append(format_dw_line(bytes_[offset:]))
                lines[idx : idx + 1] = replacement
                if not dry_run:
                    write_lines(path, lines)
                return idx + 1, "\n".join(replacement)
        if current_addr == entry_addr:
            normalize_local_labels(lines, idx)
            lines.insert(idx, f"{new_symbol}:")
            if not dry_run:
                write_lines(path, lines)
            return idx + 1, "\n".join([f"{new_symbol}:", lines[idx + 1]])
        current_addr += size
    raise SystemExit(f"no promotable mixed-region entry found at {entry_addr:06X}")


def promote_raw_entry(path: Path, entry_addr: int, new_symbol: str, dry_run: bool) -> tuple[int, str]:
    containing = find_containing_region(entry_addr)
    if containing is None:
        try:
            return promote_asm_entry(path, entry_addr, new_symbol, dry_run)
        except SystemExit:
            return promote_mixed_region_entry(path, entry_addr, new_symbol, dry_run)
    regions, index = containing
    region = regions[index]
    offset = entry_addr - region.addr
    lines = load_lines(path)
    old_line = lines[region.line_no - 1]
    is_db = old_line.strip().startswith(".db") or ".db " in old_line
    is_dw = old_line.strip().startswith(".dw") or ".dw " in old_line
    if not is_db and not is_dw:
        raise SystemExit(f"expected .db or .dw line at {path}:{region.line_no}")

    if offset == 0:
        replacement = [
            f"{new_symbol}:",
            old_line,
        ]
        lines[region.line_no - 1 : region.line_no] = replacement
        if not dry_run:
            write_lines(path, lines)
        return region.line_no, "\n".join(replacement)

    if offset < 0 or offset >= len(region.bytes_):
        raise SystemExit(
            f"entry {entry_addr:06X} is not inside a promotable raw region"
        )

    prefix = region.bytes_[:offset]
    suffix = region.bytes_[offset:]
    if is_db:
        replacement = [
            format_db_line(prefix, region.addr),
            f"{new_symbol}:",
            format_db_line(suffix, entry_addr),
        ]
    else:
        if offset % 2 != 0:
            raise SystemExit(f"entry {entry_addr:06X} is in the middle of a .dw word")
        replacement = []
        if prefix:
            replacement.append(format_dw_line(prefix))
        replacement.append(f"{new_symbol}:")
        if suffix:
            replacement.append(format_dw_line(suffix))
    lines[region.line_no - 1 : region.line_no] = replacement
    if not dry_run:
        write_lines(path, lines)
    return region.line_no, "\n".join(replacement)


def verify() -> None:
    subprocess.run(
        "make -B -j1 PYTHON=.venv/bin/python && shasum -c shiren.sha1",
        shell=True,
        check=True,
        cwd=ROOT,
    )


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("query", help="item id/name/constant")
    parser.add_argument("symbol", help="new handler symbol name")
    parser.add_argument("--effect", choices=("use", "throw"), default="use")
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--skip-verify", action="store_true")
    args = parser.parse_args(argv)

    info = find_item(args.query)
    current_handler = info.use_handler if args.effect == "use" else info.throw_handler
    if not current_handler.startswith("$"):
        raise SystemExit(f"{info.const_name} {args.effect} handler is not raw: {current_handler}")

    entry_addr, raw_ptr = normalize_addr(current_handler, bank=0xC3)
    if raw_ptr is None:
        raise SystemExit(f"unsupported raw handler format: {current_handler}")

    containing = find_containing_region(entry_addr)
    path = None
    if containing is not None:
        regions, index = containing
        region = regions[index]
        path = region.path
    else:
        for candidate in sorted((ROOT / "code").rglob("*.asm")):
            try:
                promote_asm_entry(candidate, entry_addr, args.symbol, dry_run=True)
                path = candidate
                break
            except SystemExit:
                try:
                    promote_mixed_region_entry(candidate, entry_addr, args.symbol, dry_run=True)
                    path = candidate
                    break
                except SystemExit:
                    continue
        if path is None:
            raise SystemExit(f"no promotable region found for {current_handler}")

    line_no, new_chunk = promote_raw_entry(path, entry_addr, args.symbol, args.dry_run)
    table_expr = choose_table_expr(raw_ptr, entry_addr, args.symbol)
    old_table, new_table = update_table_entry(info.const_name.removeprefix("Item_"), args.effect, table_expr, args.dry_run)

    print(f"entry: {current_handler} -> {entry_addr:06X}")
    print(f"table: {old_table} -> {table_expr}")
    print(f"label: {path.relative_to(ROOT)}:{line_no}")
    print(new_chunk)

    if args.dry_run:
        print("dry run: no files written")
        return 0

    if not args.skip_verify:
        verify()
        print("verify: shiren.sfc: OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
