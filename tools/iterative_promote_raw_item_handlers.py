#!/usr/bin/env python3
"""Iteratively promote raw item handlers for a family, verifying after each one.

Examples:
  python3 tools/iterative_promote_raw_item_handlers.py staff --effect use --dry-run
  python3 tools/iterative_promote_raw_item_handlers.py staff --effect use
"""

from __future__ import annotations

import argparse
import re
import subprocess
import sys
from pathlib import Path

from item_pipeline import ROOT, build_item_infos, is_raw_handler, parse_category_arg
from item_rename_candidates import gather_direct_call_counts, raw_to_entry_addr, build_addr_to_label


TOUCHED = [
    ROOT / "code/bank_03.asm",
    ROOT / "code/item_effects.asm",
]


def run(cmd: str) -> subprocess.CompletedProcess[str]:
    return subprocess.run(cmd, shell=True, cwd=ROOT, text=True, capture_output=True)


def snapshot_files() -> dict[Path, str]:
    return {path: path.read_text(encoding="utf-8") for path in TOUCHED}


def restore(snapshot: dict[Path, str]) -> None:
    for path, text in snapshot.items():
        path.write_text(text, encoding="utf-8")


def make_symbol(const_name: str, effect: str) -> str | None:
    base = const_name.removeprefix("Item_")
    if not re.fullmatch(r"[A-Za-z][A-Za-z0-9_]*", base):
        return None
    suffix = "UseEffect" if effect == "use" else "ThrowEffect"
    return f"{base}{suffix}"


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("category")
    parser.add_argument("--effect", choices=("use", "throw"), default="use")
    parser.add_argument("--dry-run", action="store_true")
    parser.add_argument("--limit", type=int)
    parser.add_argument("--stop-on-fail", action="store_true")
    args = parser.parse_args(argv)

    infos = [i for i in build_item_infos() if i.category_code == parse_category_arg(args.category)]
    handler_attr = "use_handler" if args.effect == "use" else "throw_handler"
    addr_to_label = build_addr_to_label()
    direct_calls = gather_direct_call_counts()

    planned: list[tuple[str, str]] = []
    for info in infos:
        handler = getattr(info, handler_attr)
        if not is_raw_handler(handler):
            continue
        owners = sum(1 for other in infos if getattr(other, handler_attr) == handler)
        if owners != 1:
            continue
        entry_addr = raw_to_entry_addr(handler)
        lifted = addr_to_label.get(entry_addr) if entry_addr is not None else None
        caller_keys = [k for k in (handler, lifted) if k]
        if sum(direct_calls.get(key, 0) for key in caller_keys) != 0:
            continue
        symbol = make_symbol(info.const_name, args.effect)
        if symbol is None:
            continue
        planned.append((info.const_name, symbol))

    if args.limit is not None:
        planned = planned[: args.limit]

    if args.dry_run:
        for const_name, symbol in planned:
            print(f"{const_name} -> {symbol}")
        print(f"planned promotions: {len(planned)}")
        return 0

    kept = 0
    baseline = snapshot_files()
    for const_name, symbol in planned:
        attempt_base = dict(baseline)
        cmd = [
            sys.executable,
            "tools/promote_raw_item_handler_label.py",
            const_name,
            symbol,
            "--effect",
            args.effect,
        ]
        proc = subprocess.run(cmd, cwd=ROOT, text=True, capture_output=True)
        if proc.returncode == 0:
            kept += 1
            baseline = snapshot_files()
            print(f"KEPT  {const_name} -> {symbol}")
            continue
        print(f"FAIL  {const_name} -> {symbol}")
        if proc.stdout:
            print(proc.stdout.strip())
        if proc.stderr:
            print(proc.stderr.strip())
        restore(attempt_base)
        verify = run("make -B -j PYTHON=.venv/bin/python && shasum -c shiren.sha1")
        if verify.returncode != 0:
            print(verify.stdout)
            print(verify.stderr, file=sys.stderr)
            return 1
        if args.stop_on_fail:
            break

    print(f"kept promotions: {kept}/{len(planned)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
