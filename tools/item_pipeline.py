#!/usr/bin/env python3
"""Inspect the item -> category -> handler pipeline from source tables.

Examples:
  python3 tools/item_pipeline.py Item_BlankScroll
  python3 tools/item_pipeline.py 68
  python3 tools/item_pipeline.py --search jar
  python3 tools/item_pipeline.py --handler JarUseEffect
"""

from __future__ import annotations

import argparse
import re
import sys
from dataclasses import dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
ITEMS_PATH = ROOT / "constants" / "items.asm"
BANK03_PATH = ROOT / "code" / "bank_03.asm"


CATEGORY_NAMES = {
    0x00: "herb/grass-like",
    0x01: "scroll",
    0x02: "onigiri",
    0x03: "weapon",
    0x04: "arrow",
    0x05: "shield",
    0x06: "armband",
    0x07: "staff",
    0x09: "meat",
    0x0B: "jar",
    0x0D: "misc/special",
}


ITEM_RE = re.compile(
    r"^(?P<const>Item_[A-Za-z0-9_]+)\s*=\s*\$(?P<id>[0-9A-F]{2})\s*;\s*(?P<label>.*)$"
)
ENTRY_RE = re.compile(r"\.dw\s+(?P<target>[^;]+?)(?:\s*;\s*(?P<label>.*))?$")


@dataclass
class ItemInfo:
    item_id: int
    const_name: str
    label: str
    category_code: int
    category_name: str
    use_handler: str
    throw_handler: str


def load_lines(path: Path) -> list[str]:
    return path.read_text(encoding="utf-8").splitlines()


def parse_items(lines: list[str]) -> list[tuple[int, str, str]]:
    items: list[tuple[int, str, str]] = []
    for line in lines:
        match = ITEM_RE.match(line.strip())
        if not match:
            continue
        items.append(
            (
                int(match.group("id"), 16),
                match.group("const"),
                match.group("label").strip(),
            )
        )
    items.sort(key=lambda row: row[0])
    return items


def parse_db_table(lines: list[str], label: str) -> list[int]:
    values: list[int] = []
    in_table = False
    for line in lines:
        stripped = line.strip()
        if stripped == f"{label}:":
            in_table = True
            continue
        if not in_table:
            continue
        if not stripped:
            continue
        if not stripped.startswith(".db"):
            break
        payload = stripped[3:]
        for raw in payload.split(","):
            token = raw.strip().split(";")[0].strip()
            if not token:
                continue
            if token.startswith("$"):
                values.append(int(token[1:], 16))
            else:
                values.append(int(token, 10))
    return values


def normalize_target(raw: str) -> str:
    target = raw.strip()
    if target.endswith("-1"):
        target = target[:-2].strip()
    return target


def parse_dw_table(lines: list[str], label: str) -> list[str]:
    values: list[str] = []
    in_table = False
    for line in lines:
        stripped = line.strip()
        if stripped == f"{label}:":
            in_table = True
            continue
        if not in_table:
            continue
        if not stripped:
            continue
        if not stripped.startswith(".dw"):
            break
        match = ENTRY_RE.search(stripped)
        if not match:
            break
        values.append(normalize_target(match.group("target")))
    return values


def build_item_infos() -> list[ItemInfo]:
    item_lines = load_lines(ITEMS_PATH)
    bank03_lines = load_lines(BANK03_PATH)

    items = parse_items(item_lines)
    categories = parse_db_table(bank03_lines, "DATA8_C341BB")
    use_table = parse_dw_table(bank03_lines, "ItemUseEffectFunctionTable")
    throw_table = parse_dw_table(bank03_lines, "ItemThrowEffectFunctionTable")

    infos: list[ItemInfo] = []
    for item_id, const_name, label in items:
        category_code = categories[item_id]
        infos.append(
            ItemInfo(
                item_id=item_id,
                const_name=const_name,
                label=label,
                category_code=category_code,
                category_name=CATEGORY_NAMES.get(category_code, f"unknown({category_code:02X})"),
                use_handler=use_table[item_id],
                throw_handler=throw_table[item_id],
            )
        )
    return infos


def format_item(info: ItemInfo) -> str:
    return "\n".join(
        [
            f"{info.const_name} (${info.item_id:02X})",
            f"label: {info.label}",
            f"category: ${info.category_code:02X} ({info.category_name})",
            f"use: {info.use_handler}",
            f"throw: {info.throw_handler}",
        ]
    )


def match_query(info: ItemInfo, query: str) -> bool:
    q = query.lower()
    return (
        q == f"{info.item_id:02x}"
        or q == f"${info.item_id:02x}"
        or q == info.const_name.lower()
        or q in info.const_name.lower()
        or q in info.label.lower()
    )


def is_raw_handler(handler: str) -> bool:
    return bool(re.fullmatch(r"\$[0-9A-Fa-f]{4}", handler))


def parse_category_arg(raw: str) -> int:
    token = raw.strip().lower()
    aliases = {name.lower(): code for code, name in CATEGORY_NAMES.items()}
    aliases["herb"] = 0x00
    aliases["grass"] = 0x00
    aliases["herbs"] = 0x00
    aliases["grasses"] = 0x00
    aliases["scrolls"] = 0x01
    aliases["onigiri"] = 0x02
    aliases["weapons"] = 0x03
    aliases["arrows"] = 0x04
    aliases["shields"] = 0x05
    aliases["armbands"] = 0x06
    aliases["staffs"] = 0x07
    aliases["staves"] = 0x07
    aliases["meat"] = 0x09
    aliases["jars"] = 0x0B
    aliases["misc"] = 0x0D
    if token in aliases:
        return aliases[token]
    if token.startswith("$"):
        return int(token[1:], 16)
    return int(token, 16 if re.fullmatch(r"[0-9a-f]{1,2}", token) else 10)


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("query", nargs="?", help="item id, constant name, or substring")
    parser.add_argument("--search", help="list all items whose id/name/label match a substring")
    parser.add_argument(
        "--handler",
        help="list all items whose use or throw handler contains this substring",
    )
    parser.add_argument(
        "--category",
        help="filter by category code or name (examples: 00, $00, herb, grass, jar)",
    )
    parser.add_argument(
        "--raw-only",
        action="store_true",
        help="with --category or --handler, only show entries that still use raw $xxxx handlers",
    )
    args = parser.parse_args(argv)

    infos = build_item_infos()

    if args.category:
        category_code = parse_category_arg(args.category)
        matches = [info for info in infos if info.category_code == category_code]
        if args.raw_only:
            matches = [
                info
                for info in matches
                if is_raw_handler(info.use_handler) or is_raw_handler(info.throw_handler)
            ]
        for info in matches:
            print(
                f"{info.const_name} (${info.item_id:02X}): "
                f"use={info.use_handler}, throw={info.throw_handler}"
            )
        return 0 if matches else 1

    if args.handler:
        needle = args.handler.lower()
        matches = [
            info
            for info in infos
            if needle in info.use_handler.lower() or needle in info.throw_handler.lower()
        ]
        if args.raw_only:
            matches = [
                info
                for info in matches
                if is_raw_handler(info.use_handler) or is_raw_handler(info.throw_handler)
            ]
        for info in matches:
            print(
                f"{info.const_name} (${info.item_id:02X}): "
                f"use={info.use_handler}, throw={info.throw_handler}"
            )
        return 0 if matches else 1

    if args.search:
        matches = [info for info in infos if match_query(info, args.search)]
        for info in matches:
            print(f"{info.const_name} (${info.item_id:02X}): {info.label}")
        return 0 if matches else 1

    if not args.query:
        print(f"loaded {len(infos)} items")
        print("use --search, --handler, or pass an item id/name")
        return 0

    matches = [info for info in infos if match_query(info, args.query)]
    if not matches:
        print(f"no item matches query: {args.query}", file=sys.stderr)
        return 1

    for index, info in enumerate(matches):
        if index:
            print()
        print(format_item(info))
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
