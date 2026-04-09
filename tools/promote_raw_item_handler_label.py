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
COMMENT_ADDR_RE = re.compile(r";C?(?P<addr>[0-9A-F]{5,6})\b")


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


def parse_comment_addr(line: str) -> int | None:
    match = COMMENT_ADDR_RE.search(line)
    if not match:
        return None
    token = match.group("addr")
    if len(token) == 5:
        token = f"C{token}"
    return int(token, 16)


def db_line_end_addr(line: str) -> int | None:
    start = parse_comment_addr(line)
    if start is None:
        return None
    bytes_ = [int(tok.group(1), 16) for tok in DB_TOKEN_RE.finditer(line.split(";")[0])]
    if not bytes_:
        return None
    return start + len(bytes_)


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
        lines.insert(insert_at, f"{new_symbol}:")
        if not dry_run:
            write_lines(path, lines)
        return insert_at + 1, "\n".join([f"{new_symbol}:", lines[insert_at + 1]])
    raise SystemExit(f"no promotable asm entry found at {entry_addr:06X}")


def promote_raw_entry(path: Path, entry_addr: int, new_symbol: str, dry_run: bool) -> tuple[int, str]:
    containing = find_containing_region(entry_addr)
    if containing is None:
        return promote_asm_entry(path, entry_addr, new_symbol, dry_run)
    regions, index = containing
    region = regions[index]
    offset = entry_addr - region.addr
    lines = load_lines(path)
    old_line = lines[region.line_no - 1]
    if not old_line.strip().startswith(".db") and ".db " not in old_line:
        raise SystemExit(f"expected .db line at {path}:{region.line_no}")

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
    replacement = [
        format_db_line(prefix, region.addr),
        f"{new_symbol}:",
        format_db_line(suffix, entry_addr),
    ]
    lines[region.line_no - 1 : region.line_no] = replacement
    if not dry_run:
        write_lines(path, lines)
    return region.line_no, "\n".join(replacement)


def verify() -> None:
    subprocess.run(
        "make -B -j PYTHON=.venv/bin/python && shasum -c shiren.sha1",
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
