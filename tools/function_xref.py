#!/usr/bin/env python3
"""Lightweight static cross-reference search for disassembly symbols and addresses.

Examples:
  python3 tools/function_xref.py func_C30E71
  python3 tools/function_xref.py '$0EA0'
  python3 tools/function_xref.py C30EA0
  python3 tools/function_xref.py MedicinalHerb --context 1
"""

from __future__ import annotations

import argparse
import re
import sys
from dataclasses import dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
SEARCH_DIRS = ("code", "constants", "data", "structs", "notes")
SEARCH_FILES = ("wram.asm",)
CALL_RE = re.compile(
    r"\b(?P<op>jsl(?:\.l)?|jsr(?:\.w)?|jmp(?:\.w)?|call_savebank)\s+(?P<target>[^;\s]+)"
)
DW_RE = re.compile(r"\.dw\s+(?P<target>[^;]+?)(?:\s*;\s*(?P<comment>.*))?$")
LABEL_RE = re.compile(r"^(?P<label>[A-Za-z0-9_@.]+):\s*$")
COMMENT_ADDR_RE = re.compile(r";C(?P<addr>[0-9A-F]{5})\b")


@dataclass
class QuerySpec:
    raw: str
    tokens: set[str]
    is_symbol: bool
    is_16bit_addr: bool
    is_24bit_addr: bool


@dataclass
class Hit:
    kind: str
    path: Path
    line_no: int
    line: str


def iter_search_paths() -> list[Path]:
    paths: list[Path] = []
    for dirname in SEARCH_DIRS:
        base = ROOT / dirname
        if not base.exists():
            continue
        paths.extend(sorted(base.rglob("*.asm")))
        paths.extend(sorted(base.rglob("*.md")))
    for filename in SEARCH_FILES:
        path = ROOT / filename
        if path.exists():
            paths.append(path)
    deduped: list[Path] = []
    seen: set[Path] = set()
    for path in paths:
        if path in seen:
            continue
        seen.add(path)
        deduped.append(path)
    return deduped


def normalize_query(raw: str) -> QuerySpec:
    query = raw.strip()
    tokens = {query}
    is_symbol = bool(re.fullmatch(r"[A-Za-z_@.][A-Za-z0-9_@.]*", query))
    is_16bit_addr = False
    is_24bit_addr = False
    if query.startswith("$"):
        hex_part = query[1:].upper()
        tokens.add(hex_part)
        if len(hex_part) == 4:
            is_16bit_addr = True
            tokens.add(f"C3{hex_part}")
        elif len(hex_part) == 6:
            is_24bit_addr = True
    elif re.fullmatch(r"[0-9A-Fa-f]{4}", query):
        upper = query.upper()
        is_16bit_addr = True
        tokens.add(f"${upper}")
        tokens.add(f"C3{upper}")
    elif re.fullmatch(r"[0-9A-Fa-f]{6}", query):
        upper = query.upper()
        is_24bit_addr = True
        tokens.add(f"${upper[-4:]}")
        tokens.add(upper)
    elif query.startswith("func_C") and len(query) >= 11:
        addr = query.split("_C", 1)[1].upper()
        if len(addr) == 6:
            is_symbol = True
            tokens.add(addr)
            tokens.add(f"${addr[-4:]}")
    return QuerySpec(
        raw=query,
        tokens=tokens,
        is_symbol=is_symbol,
        is_16bit_addr=is_16bit_addr,
        is_24bit_addr=is_24bit_addr,
    )


def contains_any(line: str, tokens: set[str]) -> bool:
    return any(token in line for token in tokens)


def classify_line(line: str, spec: QuerySpec) -> str | None:
    stripped = line.strip()
    label_match = LABEL_RE.match(stripped)
    if label_match and contains_any(label_match.group("label"), spec.tokens):
        return "definition"

    call_match = CALL_RE.search(stripped)
    if call_match and contains_any(call_match.group("target"), spec.tokens):
        return f"call:{call_match.group('op')}"

    dw_match = DW_RE.search(stripped)
    if dw_match and contains_any(dw_match.group("target"), spec.tokens):
        return "table"

    comment_addr = COMMENT_ADDR_RE.search(line)
    if comment_addr and spec.is_24bit_addr and contains_any(comment_addr.group("addr"), spec.tokens):
        return "comment_addr"

    if spec.is_16bit_addr:
        return None

    if contains_any(line, spec.tokens):
        return "text"
    return None


def gather_hits(spec: QuerySpec) -> list[Hit]:
    hits: list[Hit] = []
    for path in iter_search_paths():
        try:
            lines = path.read_text(encoding="utf-8").splitlines()
        except UnicodeDecodeError:
            continue
        rel = path.relative_to(ROOT)
        for line_no, line in enumerate(lines, 1):
            kind = classify_line(line, spec)
            if kind is None:
                continue
            hits.append(Hit(kind=kind, path=rel, line_no=line_no, line=line.rstrip()))
    return hits


def sort_key(hit: Hit) -> tuple[int, str, int]:
    order = {
        "definition": 0,
        "call:jsl.l": 1,
        "call:jsl": 1,
        "call:jsr.w": 1,
        "call:jsr": 1,
        "call:jmp.w": 1,
        "call:jmp": 1,
        "call:call_savebank": 1,
        "table": 2,
        "comment_addr": 3,
        "text": 4,
    }
    return (order.get(hit.kind, 9), str(hit.path), hit.line_no)


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("query", help="symbol, 16-bit address, or 24-bit C3xxxx address")
    parser.add_argument(
        "--context",
        type=int,
        default=0,
        help="show N lines of surrounding context for each hit",
    )
    args = parser.parse_args(argv)

    spec = normalize_query(args.query)
    hits = sorted(gather_hits(spec), key=sort_key)
    if not hits:
        print(f"no hits for {args.query}", file=sys.stderr)
        return 1

    lines_cache: dict[Path, list[str]] = {}
    for hit in hits:
        print(f"[{hit.kind}] {hit.path}:{hit.line_no}")
        if args.context <= 0:
            print(f"  {hit.line}")
            continue
        if hit.path not in lines_cache:
            lines_cache[hit.path] = (ROOT / hit.path).read_text(encoding="utf-8").splitlines()
        lines = lines_cache[hit.path]
        start = max(1, hit.line_no - args.context)
        end = min(len(lines), hit.line_no + args.context)
        for line_no in range(start, end + 1):
            prefix = ">" if line_no == hit.line_no else " "
            print(f"{prefix} {line_no:5d}: {lines[line_no - 1]}")
        print()
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
