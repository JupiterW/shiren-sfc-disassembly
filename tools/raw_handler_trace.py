#!/usr/bin/env python3
"""Trace a raw item handler address to its likely code region and helper calls.

Examples:
  python3 tools/raw_handler_trace.py Item_AntidoteHerb
  python3 tools/raw_handler_trace.py '$1003' --effect use
  python3 tools/raw_handler_trace.py '$39B0' --effect throw
"""

from __future__ import annotations

import argparse
import re
import sys
from dataclasses import dataclass
from pathlib import Path

from item_pipeline import ROOT, build_item_infos, match_query


ASM_PATHS = sorted((ROOT / "code").rglob("*.asm"))
COMMENT_ADDR_RE = re.compile(r";C(?P<addr>[0-9A-F]{5})\b")
LABEL_RE = re.compile(r"^(?P<label>[A-Za-z0-9_@.]+):\s*$")
DB_TOKEN_RE = re.compile(r"\$([0-9A-F]{2})")
FUNC_ADDR_RE = re.compile(r"^func_C([0-9A-F]{5,6})$")

JSL = 0x22
JSR = 0x20
JMP = 0x4C
RTS = 0x60
RTL = 0x6B
BRANCH_OPS = {
    0x80: "bra",
    0x90: "bcc",
    0xB0: "bcs",
    0xD0: "bne",
    0xF0: "beq",
    0x10: "bpl",
    0x30: "bmi",
    0x50: "bvc",
    0x70: "bvs",
}


@dataclass
class LabelDef:
    label: str
    path: Path
    line_no: int
    addr: int | None


@dataclass
class Region:
    path: Path
    line_no: int
    addr: int
    bytes_: list[int]
    line: str


def normalize_addr(raw: str, bank: int) -> tuple[int, int | None]:
    token = raw.strip().upper()
    if token.startswith("$"):
        token = token[1:]
    if re.fullmatch(r"[0-9A-F]{4}", token):
        raw_ptr = int(token, 16)
        return (bank << 16) | ((raw_ptr + 1) & 0xFFFF), raw_ptr
    if re.fullmatch(r"[0-9A-F]{6}", token):
        return int(token, 16), None
    raise ValueError(f"unsupported address format: {raw}")


def load_lines(path: Path) -> list[str]:
    return path.read_text(encoding="utf-8").splitlines()


def build_label_defs() -> tuple[dict[int, LabelDef], dict[str, LabelDef]]:
    labels_by_addr: dict[int, LabelDef] = {}
    labels_by_name: dict[str, LabelDef] = {}
    for path in ASM_PATHS:
        for line_no, line in enumerate(load_lines(path), 1):
            stripped = line.strip()
            match = LABEL_RE.match(stripped)
            if not match:
                continue
            label = match.group("label")
            labels_by_name[label] = LabelDef(label=label, path=path, line_no=line_no, addr=None)
            addr_match = FUNC_ADDR_RE.match(label)
            if addr_match:
                token = addr_match.group(1)
                if len(token) == 5:
                    token = f"C{token}"
                addr = int(token, 16)
                labels_by_addr[addr] = LabelDef(label=label, path=path, line_no=line_no, addr=addr)
                labels_by_name[label] = LabelDef(label=label, path=path, line_no=line_no, addr=addr)
    return labels_by_addr, labels_by_name


def find_regions(path: Path) -> list[Region]:
    regions: list[Region] = []
    for line_no, line in enumerate(load_lines(path), 1):
        comment = COMMENT_ADDR_RE.search(line)
        if not comment:
            continue
        addr = int(comment.group("addr"), 16)
        bytes_ = [int(tok.group(1), 16) for tok in DB_TOKEN_RE.finditer(line.split(";")[0])]
        if not bytes_:
            continue
        regions.append(Region(path=path, line_no=line_no, addr=addr, bytes_=bytes_, line=line.rstrip()))
    return regions


def find_containing_region(target_addr: int) -> tuple[list[Region], int] | None:
    for path in ASM_PATHS:
        regions = find_regions(path)
        for index, region in enumerate(regions):
            start = region.addr
            end = start + len(region.bytes_)
            if start <= target_addr < end:
                return regions, index
    return None


def gather_stream(regions: list[Region], start_index: int, max_bytes: int = 160) -> tuple[list[int], list[tuple[int, Region, int]]]:
    stream: list[int] = []
    mapping: list[tuple[int, Region, int]] = []
    for region in regions[start_index:]:
        for offset, byte in enumerate(region.bytes_):
            if len(stream) >= max_bytes:
                return stream, mapping
            stream.append(byte)
            mapping.append((region.addr + offset, region, offset))
    return stream, mapping


def format_addr(addr: int, labels: dict[int, LabelDef]) -> str:
    label = labels.get(addr)
    return f"{label.label} ({addr:06X})" if label else f"{addr:06X}"


def decode_events(entry_addr: int, stream: list[int], labels: dict[int, LabelDef], bank: int) -> list[str]:
    events: list[str] = []
    i = 0
    saw_return = False
    while i < len(stream):
        pc = entry_addr + i
        op = stream[i]
        if op == JSL and i + 3 < len(stream):
            target = stream[i + 1] | (stream[i + 2] << 8) | (stream[i + 3] << 16)
            events.append(f"{pc:06X}: jsl {format_addr(target, labels)}")
            i += 4
            continue
        if op == JSR and i + 2 < len(stream):
            target = (bank << 16) | stream[i + 1] | (stream[i + 2] << 8)
            events.append(f"{pc:06X}: jsr {format_addr(target, labels)}")
            i += 3
            continue
        if op == JMP and i + 2 < len(stream):
            target = (bank << 16) | stream[i + 1] | (stream[i + 2] << 8)
            events.append(f"{pc:06X}: jmp {format_addr(target, labels)}")
            i += 3
            continue
        if op in BRANCH_OPS and i + 1 < len(stream):
            disp = stream[i + 1]
            if disp >= 0x80:
                disp -= 0x100
            target = pc + 2 + disp
            events.append(f"{pc:06X}: {BRANCH_OPS[op]} {target:06X}")
            i += 2
            continue
        if op == RTS:
            events.append(f"{pc:06X}: rts")
            saw_return = True
            break
        if op == RTL:
            events.append(f"{pc:06X}: rtl")
            saw_return = True
            break
        i += 1
    if not saw_return:
        events.append("no return found within scan window")
    return events


def resolve_query(query: str, effect: str) -> tuple[str, int | None, int | None, str | None]:
    infos = build_item_infos()
    matches = [info for info in infos if match_query(info, query)]
    if matches:
        info = matches[0]
        handler = info.use_handler if effect == "use" else info.throw_handler
        if handler.startswith("$") or re.fullmatch(r"[0-9A-Fa-f]{4,6}", handler):
            entry_addr, raw_ptr = normalize_addr(handler, bank=0xC3)
            return f"{info.const_name} {effect}", entry_addr, raw_ptr, None
        return f"{info.const_name} {effect}", None, None, handler
    if re.fullmatch(r"[A-Za-z_@.][A-Za-z0-9_@.]*", query):
        return f"{effect} handler {query}", None, None, query
    entry_addr, raw_ptr = normalize_addr(query, bank=0xC3)
    return f"{effect} handler {query}", entry_addr, raw_ptr, None


def trace_lifted_label(defn: LabelDef, labels: dict[int, LabelDef]) -> list[str]:
    lines = load_lines(defn.path)
    events: list[str] = []
    for idx in range(defn.line_no, min(len(lines), defn.line_no + 80)):
        stripped = lines[idx].strip()
        if idx + 1 > defn.line_no and LABEL_RE.match(stripped):
            break
        if not stripped or stripped.startswith(";"):
            continue
        if "jsl.l " in stripped or "jsr.w " in stripped or "jmp.w " in stripped or "call_savebank " in stripped:
            events.append(f"{idx + 1}: {stripped}")
        if stripped == "rts" or stripped == "rtl":
            events.append(f"{idx + 1}: {stripped}")
            break
    if not events:
        events.append("no calls/returns found in lifted scan window")
    return events


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("query", help="item name/id, $xxxx raw table pointer, or C3xxxx address")
    parser.add_argument("--effect", choices=("use", "throw"), default="use")
    parser.add_argument("--bank", default="C3", help="default bank for 16-bit raw pointers (default: C3)")
    args = parser.parse_args(argv)

    try:
        title, entry_addr, raw_ptr, symbol = resolve_query(args.query, args.effect)
    except ValueError as exc:
        print(str(exc), file=sys.stderr)
        return 1

    bank = int(args.bank, 16)
    labels, labels_by_name = build_label_defs()
    if symbol is not None:
        lifted = labels_by_name.get(symbol)
        if lifted is None:
            print(f"{title}\nsymbol not found: {symbol}", file=sys.stderr)
            return 1
        print(title)
        print(f"symbol: {lifted.label}")
        print(f"location: {lifted.path.relative_to(ROOT)}:{lifted.line_no}")
        print("calls/returns:")
        for event in trace_lifted_label(lifted, labels):
            print(f"  {event}")
        return 0

    lifted = labels.get(entry_addr)
    if lifted is not None:
        print(title)
        if raw_ptr is not None:
            print(f"raw table pointer: ${raw_ptr:04X}")
        print(f"actual entry: {entry_addr:06X}")
        print(f"lifted label: {lifted.label}")
        print(f"location: {lifted.path.relative_to(ROOT)}:{lifted.line_no}")
        print("calls/returns:")
        for event in trace_lifted_label(lifted, labels):
            print(f"  {event}")
        return 0

    match = find_containing_region(entry_addr)
    if not match:
        print(f"{title}\nentry: {entry_addr:06X}\nno raw region found", file=sys.stderr)
        return 1

    regions, start_index = match
    stream, mapping = gather_stream(regions, start_index)
    offset = entry_addr - mapping[0][0]
    if offset < 0 or offset >= len(stream):
        print(f"{title}\nentry: {entry_addr:06X}\nentry not inside gathered stream", file=sys.stderr)
        return 1

    print(title)
    if raw_ptr is not None:
        print(f"raw table pointer: ${raw_ptr:04X}")
    print(f"actual entry: {entry_addr:06X}")
    print(f"region: {regions[start_index].path.relative_to(ROOT)}:{regions[start_index].line_no}")
    print(f"start line: {regions[start_index].line}")
    print("decoded control-flow hints:")
    for event in decode_events(entry_addr, stream[offset:], labels, bank):
        print(f"  {event}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
