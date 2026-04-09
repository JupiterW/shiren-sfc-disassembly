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


def promote_raw_entry(path: Path, entry_addr: int, new_symbol: str, dry_run: bool) -> tuple[int, str]:
    containing = find_containing_region(entry_addr)
    if containing is None:
        raise SystemExit(f"no raw region found containing {entry_addr:06X}")
    regions, index = containing
    region = regions[index]
    offset = entry_addr - region.addr
    if offset <= 0 or offset >= len(region.bytes_):
        raise SystemExit(
            f"entry {entry_addr:06X} is not in the middle of a raw region that needs splitting"
        )

    lines = load_lines(path)
    old_line = lines[region.line_no - 1]
    if not old_line.strip().startswith(".db") and ".db " not in old_line:
        raise SystemExit(f"expected .db line at {path}:{region.line_no}")

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
    if containing is None:
        raise SystemExit(f"no raw region found for {current_handler}")
    regions, index = containing
    region = regions[index]
    path = region.path

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
