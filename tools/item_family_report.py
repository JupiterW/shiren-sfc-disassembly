#!/usr/bin/env python3
"""Summarize handler naming status and sharing within an item family/category.

Examples:
  python3 tools/item_family_report.py herb
  python3 tools/item_family_report.py jar --raw-only
"""

from __future__ import annotations

import argparse
from collections import Counter

from item_pipeline import build_item_infos, is_raw_handler, parse_category_arg


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("category", help="category code or name, e.g. herb, jar, 00, 0B")
    parser.add_argument("--raw-only", action="store_true", help="only list items with raw use/throw handlers")
    args = parser.parse_args(argv)

    category_code = parse_category_arg(args.category)
    infos = [info for info in build_item_infos() if info.category_code == category_code]
    if args.raw_only:
        infos = [info for info in infos if is_raw_handler(info.use_handler) or is_raw_handler(info.throw_handler)]
    if not infos:
        return 1

    print(f"category ${category_code:02X}: {infos[0].category_name}")
    print(f"items: {len(infos)}")
    named_use = sum(not is_raw_handler(info.use_handler) for info in infos)
    named_throw = sum(not is_raw_handler(info.throw_handler) for info in infos)
    print(f"use handlers named: {named_use}/{len(infos)}")
    print(f"throw handlers named: {named_throw}/{len(infos)}")

    use_counts = Counter(info.use_handler for info in infos)
    throw_counts = Counter(info.throw_handler for info in infos)
    print("top shared use handlers:")
    for handler, count in use_counts.most_common(8):
        print(f"  {handler}: {count}")
    print("top shared throw handlers:")
    for handler, count in throw_counts.most_common(8):
        print(f"  {handler}: {count}")

    print("items:")
    for info in infos:
        print(f"  {info.const_name} (${info.item_id:02X}): use={info.use_handler}, throw={info.throw_handler}")
    return 0


if __name__ == "__main__":
    import sys

    raise SystemExit(main(sys.argv[1:]))
