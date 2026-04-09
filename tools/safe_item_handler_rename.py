#!/usr/bin/env python3
"""Safely rename an item use/throw handler and verify the build.

This only automates safe cases:
- update the item's use/throw table entry in bank_03.asm
- rename an existing lifted label when the handler already resolves to a label

It intentionally refuses to rewrite raw mid-blob entry points that do not
already have a standalone label.

Examples:
  python3 tools/safe_item_handler_rename.py Item_AntidoteHerb AntidoteHerbUseEffect --effect use --dry-run
  python3 tools/safe_item_handler_rename.py Item_AntidoteHerb AntidoteHerbUseEffect --effect use
"""

from __future__ import annotations

import argparse
import re
import subprocess
import sys
from pathlib import Path

from item_pipeline import ROOT, BANK03_PATH, build_item_infos, match_query


ASM_PATHS = sorted((ROOT / "code").rglob("*.asm"))
SYM_PATH = ROOT / "shiren.sym"
TABLE_LABELS = {"use": "ItemUseEffectFunctionTable", "throw": "ItemThrowEffectFunctionTable"}
TABLE_COMMENT_RE = re.compile(r"^(?P<prefix>\s*\.dw\s+)(?P<target>[^;]+?)(?P<suffix>\s*;\s*(?P<label>.*))?$")
LABEL_LINE_RE = re.compile(r"^(?P<indent>\s*)(?P<label>[A-Za-z0-9_@.]+):(?P<rest>\s*)$")
FUNC_ADDR_RE = re.compile(r"^func_C([0-9A-F]{5,6})$")
SYM_LINE_RE = re.compile(r"^(?P<bank>[0-9a-fA-F]+):(?P<addr>[0-9a-fA-F]+)\s+(?P<label>\S+)$")


def load_lines(path: Path) -> list[str]:
    return path.read_text(encoding="utf-8").splitlines()


def write_lines(path: Path, lines: list[str]) -> None:
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def raw_to_entry_addr(raw: str, bank: int = 0xC3) -> int | None:
    token = raw.strip().upper()
    if token.startswith("$"):
        token = token[1:]
    if re.fullmatch(r"[0-9A-F]{4}", token):
        return (bank << 16) | ((int(token, 16) + 1) & 0xFFFF)
    if re.fullmatch(r"[0-9A-F]{6}", token):
        return int(token, 16)
    return None


def parse_table_target_value(target: str, symbol_addrs: dict[str, int]) -> int | None:
    token = target.strip()
    if token.startswith("$"):
        try:
            return int(token[1:], 16)
        except ValueError:
            return None
    if token.endswith("-1"):
        base = token[:-2]
        if base in symbol_addrs:
            return (symbol_addrs[base] - 1) & 0xFFFF
        return None
    if token in symbol_addrs:
        return symbol_addrs[token] & 0xFFFF
    return None


def choose_table_expr(original_value: int, symbol_addr: int, symbol: str) -> str:
    symbol_value = symbol_addr & 0xFFFF
    if symbol_value == original_value:
        return symbol
    if ((symbol_value - 1) & 0xFFFF) == original_value:
        return f"{symbol}-1"
    raise SystemExit(
        f"cannot preserve original table value ${original_value:04X} with symbol {symbol} at ${symbol_value:04X}"
    )


def load_sym_addrs() -> dict[str, int]:
    if not SYM_PATH.exists():
        raise SystemExit(f"symbol file not found: {SYM_PATH}")
    mapping: dict[str, int] = {}
    for line in load_lines(SYM_PATH):
        match = SYM_LINE_RE.match(line.strip())
        if not match:
            continue
        mapping[match.group("label")] = (int(match.group("bank"), 16) << 16) | int(match.group("addr"), 16)
    return mapping


def find_item(query: str):
    infos = build_item_infos()
    matches = [info for info in infos if match_query(info, query)]
    if not matches:
        raise SystemExit(f"no item matches query: {query}")
    return matches[0]


def find_existing_label(label_name: str) -> tuple[Path, int, str] | None:
    for path in ASM_PATHS:
        for idx, line in enumerate(load_lines(path), 1):
            stripped = line.strip()
            match = LABEL_LINE_RE.match(stripped)
            if not match:
                continue
            label = match.group("label")
            if label == label_name:
                return path, idx, label
    return None


def find_existing_label_for_raw_target(raw_target: str, symbol_addrs: dict[str, int]) -> tuple[Path, int, str, int] | None:
    if not raw_target.startswith("$"):
        return None
    token = raw_target[1:]
    if not re.fullmatch(r"[0-9A-Fa-f]{4}", token):
        return None
    raw_value = int(token, 16)
    exact_candidates: list[tuple[Path, int, str, int]] = []
    plus_one_candidates: list[tuple[Path, int, str, int]] = []
    for full_addr, bucket in (
        ((0xC3 << 16) | raw_value, exact_candidates),
        ((0xC3 << 16) | ((raw_value + 1) & 0xFFFF), plus_one_candidates),
    ):
        for label, addr in symbol_addrs.items():
            if addr != full_addr:
                continue
            label_target = find_existing_label(label)
            if label_target is not None:
                bucket.append((*label_target, full_addr))
    if len(exact_candidates) == 1:
        return exact_candidates[0]
    if len(exact_candidates) > 1:
        raise SystemExit(f"ambiguous exact standalone label candidates for raw target {raw_target}")
    if len(plus_one_candidates) == 1:
        return plus_one_candidates[0]
    if len(plus_one_candidates) > 1:
        raise SystemExit(f"ambiguous +1 standalone label candidates for raw target {raw_target}")
    return None


def find_existing_label_for_addr(entry_addr: int) -> tuple[Path, int, str] | None:
    for path in ASM_PATHS:
        for idx, line in enumerate(load_lines(path), 1):
            stripped = line.strip()
            match = LABEL_LINE_RE.match(stripped)
            if not match:
                continue
            label = match.group("label")
            addr_match = FUNC_ADDR_RE.match(label)
            if not addr_match:
                continue
            token = addr_match.group(1)
            if len(token) == 5:
                token = f"C{token}"
            if int(token, 16) == entry_addr:
                return path, idx, label
    return None


def update_table_entry(item_suffix: str, effect: str, table_expr: str, dry_run: bool) -> tuple[str, str]:
    lines = load_lines(BANK03_PATH)
    in_table = False
    for idx, line in enumerate(lines):
        stripped = line.strip()
        if stripped == f"{TABLE_LABELS[effect]}:":
            in_table = True
            continue
        if not in_table:
            continue
        if stripped and not stripped.startswith(".dw"):
            break
        match = TABLE_COMMENT_RE.match(line)
        if not match:
            continue
        if match.group("label") != item_suffix:
            continue
        old_target = match.group("target").strip()
        lines[idx] = f"{match.group('prefix')}{table_expr}{match.group('suffix') or ''}"
        if not dry_run:
            write_lines(BANK03_PATH, lines)
        return old_target, lines[idx]
    raise SystemExit(f"table entry for {item_suffix} not found in {TABLE_LABELS[effect]}")


def rename_label_and_references(path: Path, line_no: int, old_label: str, new_label: str, dry_run: bool) -> str:
    lines = load_lines(path)
    line = lines[line_no - 1]
    match = LABEL_LINE_RE.match(line)
    if not match or match.group("label") != old_label:
        raise SystemExit(f"label mismatch at {path}:{line_no}")
    lines[line_no - 1] = f"{match.group('indent')}{new_label}:{match.group('rest')}"
    for idx, text in enumerate(lines):
        if idx == line_no - 1:
            continue
        lines[idx] = text.replace(old_label, new_label)
    if not dry_run:
        write_lines(path, lines)
    return lines[line_no - 1]


def run_verify() -> None:
    cmd = "make -j PYTHON=.venv/bin/python && shasum -c shiren.sha1"
    subprocess.run(
        cmd,
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
    item_suffix = info.const_name.removeprefix("Item_")
    symbol_addrs = load_sym_addrs()

    label_target: tuple[Path, int, str] | None = None
    old_symbol = current_handler
    old_symbol_addr: int | None = symbol_addrs.get(current_handler)
    if current_handler.startswith("$"):
        resolved = find_existing_label_for_raw_target(current_handler, symbol_addrs)
        label_target = None if resolved is None else resolved[:3]
        old_symbol_addr = None if resolved is None else resolved[3]
        if label_target is None:
            raise SystemExit(
                f"{info.const_name} {args.effect} handler {current_handler} has no standalone label; "
                "refusing to rename raw mid-blob code automatically"
            )
        old_symbol = label_target[2]
    elif re.fullmatch(r"[A-Za-z_@.][A-Za-z0-9_@.]*", current_handler):
        for path in ASM_PATHS:
            for idx, line in enumerate(load_lines(path), 1):
                stripped = line.strip()
                match = LABEL_LINE_RE.match(stripped)
                if match and match.group("label") == current_handler:
                    label_target = (path, idx, current_handler)
                    break
            if label_target is not None:
                break

    if old_symbol_addr is None:
        old_symbol_addr = symbol_addrs.get(old_symbol)
    if old_symbol_addr is None:
        raise SystemExit(f"no symbol address found for {old_symbol} in {SYM_PATH.name}")

    old_table_value = parse_table_target_value(current_handler, symbol_addrs)
    if old_table_value is None:
        raise SystemExit(f"could not parse current table target: {current_handler}")
    table_expr = choose_table_expr(old_table_value, old_symbol_addr, args.symbol)

    old_table, new_table = update_table_entry(item_suffix, args.effect, table_expr, args.dry_run)
    print(f"table: {old_table} -> {table_expr}")

    if label_target is not None and old_symbol != args.symbol:
        path, line_no, label = label_target
        new_line = rename_label_and_references(path, line_no, label, args.symbol, args.dry_run)
        print(f"label: {path.relative_to(ROOT)}:{line_no}: {label} -> {args.symbol}")
        print(f"       {new_line}")
    else:
        print("label: no existing label rename needed")

    if args.dry_run:
        print("dry run: no files written")
        return 0

    if not args.skip_verify:
        run_verify()
        print("verify: shiren.sfc: OK")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
