#!/usr/bin/env python3
"""Rank item handler rename candidates by uniqueness and direct-call reuse.

Examples:
  python3 tools/item_rename_candidates.py herb
  python3 tools/item_rename_candidates.py herb --effect use --unnamed-only
  python3 tools/item_rename_candidates.py jar --effect throw
"""

from __future__ import annotations

import argparse
import re
from collections import Counter, defaultdict
from dataclasses import dataclass
from pathlib import Path

from item_pipeline import ROOT, build_item_infos, is_raw_handler, parse_category_arg


ASM_PATHS = sorted((ROOT / "code").rglob("*.asm"))
CALL_RE = re.compile(
    r"\b(?P<op>jsl(?:\.l)?|jsr(?:\.w)?|jmp(?:\.w)?|call_savebank)\s+(?P<target>[^;\s]+)"
)
LABEL_RE = re.compile(r"^(?P<label>[A-Za-z0-9_@.]+):\s*$")
FUNC_ADDR_RE = re.compile(r"^func_C([0-9A-F]{5,6})$")


@dataclass
class Candidate:
    item_const: str
    item_id: int
    handler: str
    owners: int
    direct_callers: int
    lifted_symbol: str | None


def load_lines(path: Path) -> list[str]:
    return path.read_text(encoding="utf-8").splitlines()


def build_addr_to_label() -> dict[int, str]:
    mapping: dict[int, str] = {}
    for path in ASM_PATHS:
        for line in load_lines(path):
            stripped = line.strip()
            match = LABEL_RE.match(stripped)
            if not match:
                continue
            label = match.group("label")
            addr_match = FUNC_ADDR_RE.match(label)
            if not addr_match:
                continue
            token = addr_match.group(1)
            if len(token) == 5:
                token = f"C{token}"
            mapping[int(token, 16)] = label
    return mapping


def raw_to_entry_addr(raw: str, bank: int = 0xC3) -> int | None:
    token = raw.upper()
    if token.startswith("$"):
        token = token[1:]
    if re.fullmatch(r"[0-9A-F]{4}", token):
        return (bank << 16) | ((int(token, 16) + 1) & 0xFFFF)
    if re.fullmatch(r"[0-9A-F]{6}", token):
        return int(token, 16)
    return None


def gather_direct_call_counts() -> Counter[str]:
    counts: Counter[str] = Counter()
    for path in ASM_PATHS:
        for line in load_lines(path):
            stripped = line.strip()
            match = CALL_RE.search(stripped)
            if not match:
                continue
            counts[match.group("target")] += 1
    return counts


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("category", help="category code or name, e.g. herb, jar, 00, 0B")
    parser.add_argument("--effect", choices=("use", "throw"), default="use")
    parser.add_argument("--unnamed-only", action="store_true")
    args = parser.parse_args(argv)

    infos = build_item_infos()
    category_code = parse_category_arg(args.category)
    infos = [info for info in infos if info.category_code == category_code]
    if not infos:
        return 1

    handler_attr = "use_handler" if args.effect == "use" else "throw_handler"
    handler_counts = Counter(getattr(info, handler_attr) for info in infos)
    addr_to_label = build_addr_to_label()
    direct_call_counts = gather_direct_call_counts()

    candidates: list[Candidate] = []
    for info in infos:
        handler = getattr(info, handler_attr)
        if handler == "UnusedItemUseEffect":
            continue
        if args.unnamed_only and not is_raw_handler(handler):
            continue

        lifted_symbol = None
        if is_raw_handler(handler):
            entry_addr = raw_to_entry_addr(handler)
            if entry_addr is not None:
                lifted_symbol = addr_to_label.get(entry_addr)
        else:
            lifted_symbol = handler

        caller_keys = [k for k in (handler, lifted_symbol) if k]
        direct_callers = sum(direct_call_counts.get(key, 0) for key in caller_keys)
        candidates.append(
            Candidate(
                item_const=info.const_name,
                item_id=info.item_id,
                handler=handler,
                owners=handler_counts[handler],
                direct_callers=direct_callers,
                lifted_symbol=lifted_symbol,
            )
        )

    candidates.sort(
        key=lambda c: (
            c.owners != 1,
            c.direct_callers != 0,
            is_raw_handler(c.handler) is False,
            c.item_id,
        )
    )

    print(f"category ${category_code:02X}, effect={args.effect}")
    print("priority = unique table owner + no direct callers")
    for cand in candidates:
        status = []
        status.append("unique" if cand.owners == 1 else f"shared:{cand.owners}")
        status.append("no-extra-callers" if cand.direct_callers == 0 else f"extra-callers:{cand.direct_callers}")
        status.append("raw" if is_raw_handler(cand.handler) else "named")
        lifted = f", lifted={cand.lifted_symbol}" if cand.lifted_symbol and cand.lifted_symbol != cand.handler else ""
        print(
            f"{cand.item_const} (${cand.item_id:02X}): "
            f"{cand.handler}{lifted} [{', '.join(status)}]"
        )
    return 0


if __name__ == "__main__":
    import sys

    raise SystemExit(main(sys.argv[1:]))
