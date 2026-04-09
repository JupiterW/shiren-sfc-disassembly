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
TABLE_LABELS = {"use": "ItemUseEffectFunctionTable", "throw": "ItemThrowEffectFunctionTable"}
TABLE_COMMENT_RE = re.compile(r"^(?P<prefix>\s*\.dw\s+)(?P<target>[^;]+?)(?P<suffix>\s*;\s*(?P<label>.*))?$")
LABEL_LINE_RE = re.compile(r"^(?P<indent>\s*)(?P<label>[A-Za-z0-9_@.]+):(?P<rest>\s*)$")
FUNC_ADDR_RE = re.compile(r"^func_C([0-9A-F]{5,6})$")


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


def find_item(query: str):
    infos = build_item_infos()
    matches = [info for info in infos if match_query(info, query)]
    if not matches:
        raise SystemExit(f"no item matches query: {query}")
    return matches[0]


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


def update_table_entry(item_suffix: str, effect: str, new_symbol: str, dry_run: bool) -> tuple[str, str]:
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
        lines[idx] = f"{match.group('prefix')}{new_symbol}-1{match.group('suffix') or ''}"
        if not dry_run:
            write_lines(BANK03_PATH, lines)
        return old_target, lines[idx]
    raise SystemExit(f"table entry for {item_suffix} not found in {TABLE_LABELS[effect]}")


def rename_label(path: Path, line_no: int, old_label: str, new_label: str, dry_run: bool) -> str:
    lines = load_lines(path)
    line = lines[line_no - 1]
    match = LABEL_LINE_RE.match(line)
    if not match or match.group("label") != old_label:
        raise SystemExit(f"label mismatch at {path}:{line_no}")
    lines[line_no - 1] = f"{match.group('indent')}{new_label}:{match.group('rest')}"
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

    label_target: tuple[Path, int, str] | None = None
    old_symbol = current_handler
    if current_handler.startswith("$"):
        entry_addr = raw_to_entry_addr(current_handler)
        if entry_addr is None:
            raise SystemExit(f"unsupported raw handler format: {current_handler}")
        label_target = find_existing_label_for_addr(entry_addr)
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

    old_table, new_table = update_table_entry(item_suffix, args.effect, args.symbol, args.dry_run)
    print(f"table: {old_table} -> {args.symbol}-1")

    if label_target is not None and old_symbol != args.symbol:
        path, line_no, label = label_target
        new_line = rename_label(path, line_no, label, args.symbol, args.dry_run)
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
