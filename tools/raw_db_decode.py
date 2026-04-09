#!/usr/bin/env python3
"""Lightweight decoder for raw `.db` byte lines in asm files.

This is intentionally 90/20:
- decode common 65816 opcodes we keep seeing in item handlers
- show offsets, bytes, and a best-effort mnemonic
- leave unknown bytes as raw `.db`

Examples:
  python3 tools/raw_db_decode.py 'E2 20 A9 13 85 00 22 79 35 C2 60'
  python3 tools/raw_db_decode.py --addr C31344 'E2 20 A9 0B 85 01'
  python3 tools/raw_db_decode.py --line '	.db $E2,$20,$A9,$13,$85,$00   ;C310EC'
  python3 tools/raw_db_decode.py --addr C31649 --table16 5 --line '	.db $57,$16,$6D,$16,$83,$16,$99,$16,$BF,$16,$22,$10,$AD,$16,$E2,$20 ;C31649'
"""

from __future__ import annotations

import argparse
from dataclasses import dataclass
import re
import sys


DB_TOKEN_RE = re.compile(r"\$([0-9A-Fa-f]{2})|(?<![0-9A-Fa-f])([0-9A-Fa-f]{2})(?![0-9A-Fa-f])")


@dataclass
class DecodeState:
    m_width: int = 8
    x_width: int = 8


def parse_bytes(text: str) -> list[int]:
    text = text.split(";")[0]
    text = text.replace(".db", " ").replace(",", " ").replace("\t", " ")
    out: list[int] = []
    for match in DB_TOKEN_RE.finditer(text):
        token = match.group(1) or match.group(2)
        out.append(int(token, 16))
    if not out:
        raise ValueError("no bytes found")
    return out


def parse_addr(text: str | None) -> int | None:
    if not text:
        return None
    token = text.strip().upper().removeprefix("$")
    if len(token) == 5:
        token = f"C{token}"
    if len(token) != 6:
        raise ValueError(f"unsupported address: {text}")
    return int(token, 16)


def fmt_addr(addr: int | None, offset: int) -> str:
    if addr is None:
        return f"+{offset:02X}"
    return f"{addr + offset:06X}"


def decode_one(data: list[int], i: int, base_addr: int | None, state: DecodeState) -> tuple[int, str]:
    op = data[i]
    b = lambda n: data[i + n] if i + n < len(data) else None

    def imm8(name: str) -> tuple[int, str]:
        if b(1) is None:
            return 1, f".db ${op:02X}"
        return 2, f"{name} #${b(1):02X}"

    def imm16(name: str) -> tuple[int, str]:
        if b(2) is None:
            return 1, f".db ${op:02X}"
        return 3, f"{name} #${b(1) | (b(2) << 8):04X}"

    def imm_acc(name: str) -> tuple[int, str]:
        return imm16(name) if state.m_width == 16 else imm8(name)

    def imm_idx(name: str) -> tuple[int, str]:
        return imm16(name) if state.x_width == 16 else imm8(name)

    def dp(name: str) -> tuple[int, str]:
        if b(1) is None:
            return 1, f".db ${op:02X}"
        return 2, f"{name} ${b(1):02X}"

    def stack_rel(name: str) -> tuple[int, str]:
        if b(1) is None:
            return 1, f".db ${op:02X}"
        return 2, f"{name} ${b(1):02X},s"

    def absolute(name: str) -> tuple[int, str]:
        if b(2) is None:
            return 1, f".db ${op:02X}"
        return 3, f"{name} ${b(1) | (b(2) << 8):04X}"

    def absolute_x(name: str) -> tuple[int, str]:
        if b(2) is None:
            return 1, f".db ${op:02X}"
        return 3, f"{name} ${b(1) | (b(2) << 8):04X},x"

    def absolute_y(name: str) -> tuple[int, str]:
        if b(2) is None:
            return 1, f".db ${op:02X}"
        return 3, f"{name} ${b(1) | (b(2) << 8):04X},y"

    def long_call(name: str) -> tuple[int, str]:
        if b(3) is None:
            return 1, f".db ${op:02X}"
        target = b(1) | (b(2) << 8) | (b(3) << 16)
        return 4, f"{name} ${target:06X}"

    def short_call(name: str) -> tuple[int, str]:
        if b(2) is None:
            return 1, f".db ${op:02X}"
        target = b(1) | (b(2) << 8)
        return 3, f"{name} ${target:04X}"

    def abs_x_indirect(name: str) -> tuple[int, str]:
        if b(2) is None:
            return 1, f".db ${op:02X}"
        target = b(1) | (b(2) << 8)
        return 3, f"{name} (${target:04X},x)"

    def long_x(name: str) -> tuple[int, str]:
        if b(3) is None:
            return 1, f".db ${op:02X}"
        target = b(1) | (b(2) << 8) | (b(3) << 16)
        return 4, f"{name} ${target:06X},x"

    def long_addr(name: str) -> tuple[int, str]:
        if b(3) is None:
            return 1, f".db ${op:02X}"
        target = b(1) | (b(2) << 8) | (b(3) << 16)
        return 4, f"{name} ${target:06X}"

    def branch(name: str) -> tuple[int, str]:
        if b(1) is None:
            return 1, f".db ${op:02X}"
        disp = b(1)
        if disp >= 0x80:
            disp -= 0x100
        src = (base_addr + i) if base_addr is not None else 0
        return 2, f"{name} ${src + 2 + disp:06X}" if base_addr is not None else f"{name} {disp:+d}"

    def branch_long(name: str) -> tuple[int, str]:
        if b(2) is None:
            return 1, f".db ${op:02X}"
        disp = b(1) | (b(2) << 8)
        if disp >= 0x8000:
            disp -= 0x10000
        src = (base_addr + i) if base_addr is not None else 0
        return 3, f"{name} ${src + 3 + disp:06X}" if base_addr is not None else f"{name} {disp:+d}"

    def sep_or_rep(name: str, set_bits: bool) -> tuple[int, str]:
        size, text = imm8(name)
        if size != 2:
            return size, text
        mask = b(1)
        assert mask is not None
        if mask & 0x20:
            state.m_width = 8 if set_bits else 16
        if mask & 0x10:
            state.x_width = 8 if set_bits else 16
        return size, text

    table: dict[int, tuple[int, str] | callable] = {
        0x60: (1, "rts"),
        0x6B: (1, "rtl"),
        0x0A: (1, "asl a"),
        0x3A: (1, "dec a"),
        0x1A: (1, "inc a"),
        0x18: (1, "clc"),
        0x38: (1, "sec"),
        0x28: (1, "plp"),
        0x48: (1, "pha"),
        0x68: (1, "pla"),
        0x5A: (1, "phy"),
        0x7A: (1, "ply"),
        0x8B: (1, "phb"),
        0xAB: (1, "plb"),
        0x88: (1, "dey"),
        0x98: (1, "tya"),
        0x8A: (1, "txa"),
        0x9B: (1, "txy"),
        0xAA: (1, "tax"),
        0xA8: (1, "tay"),
        0xDA: (1, "phx"),
        0xFA: (1, "plx"),
        0xBB: (1, "tyx"),
        0xEB: (1, "xba"),
        0xE2: lambda: sep_or_rep("sep", True),
        0xC2: lambda: sep_or_rep("rep", False),
        0xA9: lambda: imm_acc("lda"),
        0xA2: lambda: imm_idx("ldx"),
        0xA0: lambda: imm_idx("ldy"),
        0xAF: lambda: long_addr("lda"),
        0xA5: lambda: dp("lda"),
        0xA6: lambda: dp("ldx"),
        0xA4: lambda: dp("ldy"),
        0xA3: lambda: stack_rel("lda"),
        0xB9: lambda: absolute_y("lda"),
        0xBD: lambda: absolute_x("lda"),
        0xBC: lambda: absolute_x("ldy"),
        0xBE: lambda: absolute_y("ldx"),
        0x85: lambda: dp("sta"),
        0x86: lambda: dp("stx"),
        0x84: lambda: dp("sty"),
        0x83: lambda: stack_rel("sta"),
        0x9D: lambda: absolute_x("sta"),
        0x9F: lambda: long_x("sta"),
        0x64: lambda: dp("stz"),
        0xE4: lambda: dp("cpx"),
        0x24: lambda: dp("bit"),
        0x89: lambda: imm_acc("bit"),
        0x25: lambda: dp("and"),
        0xC5: lambda: dp("cmp"),
        0xC9: lambda: imm_acc("cmp"),
        0xD9: lambda: absolute_y("cmp"),
        0xDF: lambda: long_x("cmp"),
        0xE9: lambda: imm_acc("sbc"),
        0xFF: lambda: long_x("sbc"),
        0x63: lambda: stack_rel("adc"),
        0x69: lambda: imm_acc("adc"),
        0x79: lambda: absolute_y("adc"),
        0x7F: lambda: long_x("adc"),
        0x49: lambda: imm_acc("eor"),
        0x09: lambda: imm_acc("ora"),
        0x19: lambda: absolute_y("ora"),
        0x29: lambda: imm_acc("and"),
        0xBF: lambda: long_x("lda"),
        0x22: lambda: long_call("jsl"),
        0x20: lambda: short_call("jsr"),
        0x4C: lambda: short_call("jmp"),
        0x7C: lambda: abs_x_indirect("jmp"),
        0xF0: lambda: branch("beq"),
        0xD0: lambda: branch("bne"),
        0x10: lambda: branch("bpl"),
        0x30: lambda: branch("bmi"),
        0x70: lambda: branch("bvs"),
        0x82: lambda: branch_long("brl"),
        0x80: lambda: branch("bra"),
        0x90: lambda: branch("bcc"),
        0xB0: lambda: branch("bcs"),
    }

    entry = table.get(op)
    if entry is None:
        return 1, f".db ${op:02X}"
    if isinstance(entry, tuple):
        return entry
    return entry()


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("bytes", nargs="?", help="raw bytes, e.g. 'E2 20 A9 13'")
    parser.add_argument("--line", help="a literal .db source line")
    parser.add_argument("--addr", help="starting address, e.g. C31344")
    parser.add_argument("--m-width", type=int, choices=(8, 16), default=8, help="initial accumulator width")
    parser.add_argument("--x-width", type=int, choices=(8, 16), default=8, help="initial index width")
    parser.add_argument(
        "--table16",
        type=int,
        default=0,
        help="interpret the first N little-endian 16-bit words as local jump-table targets before decoding the remaining bytes as code",
    )
    args = parser.parse_args(argv)

    source = args.line or args.bytes
    if not source:
        parser.error("provide raw bytes or --line")
    data = parse_bytes(source)
    base = parse_addr(args.addr)

    i = 0
    if args.table16:
        if len(data) < args.table16 * 2:
            raise ValueError("not enough bytes for requested --table16 count")
        bank = (base or 0xC30000) & 0xFF0000
        for table_index in range(args.table16):
            word_off = table_index * 2
            target = data[word_off] | (data[word_off + 1] << 8)
            chunk = f"{data[word_off]:02X} {data[word_off + 1]:02X}"
            target_text = f"${bank | target:06X}" if base is not None else f"${target:04X}"
            print(f"{fmt_addr(base, word_off)}  {chunk:<15}  .dw {target_text}")
        i = args.table16 * 2

    state = DecodeState(m_width=args.m_width, x_width=args.x_width)
    while i < len(data):
        size, text = decode_one(data, i, base, state)
        chunk = " ".join(f"{b:02X}" for b in data[i : i + size])
        print(f"{fmt_addr(base, i)}  {chunk:<15}  {text}")
        i += max(size, 1)
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
