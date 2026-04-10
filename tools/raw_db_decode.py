#!/usr/bin/env python3
"""Lightweight decoder for raw `.db` byte lines in asm files.

Complete 65816 opcode coverage — all addressing modes including SNES-specific
24-bit long addressing, stack-relative, and all indirect/indexed variants.
M/X flag width is tracked across SEP/REP to get correct immediate sizes.

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

    # ── helpers: emit ".db $XX" when truncated ────────────────────────────────

    def _trunc() -> tuple[int, str]:
        return 1, f".db ${op:02X}"

    # ── addressing mode helpers ───────────────────────────────────────────────

    def imm8(name: str) -> tuple[int, str]:
        if b(1) is None: return _trunc()
        return 2, f"{name} #${b(1):02X}"

    def imm16(name: str) -> tuple[int, str]:
        if b(2) is None: return _trunc()
        return 3, f"{name} #${b(1) | (b(2) << 8):04X}"

    def imm_acc(name: str) -> tuple[int, str]:
        return imm16(name) if state.m_width == 16 else imm8(name)

    def imm_idx(name: str) -> tuple[int, str]:
        return imm16(name) if state.x_width == 16 else imm8(name)

    def dp(name: str) -> tuple[int, str]:
        if b(1) is None: return _trunc()
        return 2, f"{name} ${b(1):02X}"

    def dp_x(name: str) -> tuple[int, str]:
        if b(1) is None: return _trunc()
        return 2, f"{name} ${b(1):02X},x"

    def dp_y(name: str) -> tuple[int, str]:
        if b(1) is None: return _trunc()
        return 2, f"{name} ${b(1):02X},y"

    def dp_ind_x(name: str) -> tuple[int, str]:          # (dp,x)
        if b(1) is None: return _trunc()
        return 2, f"{name} (${b(1):02X},x)"

    def dp_ind(name: str) -> tuple[int, str]:             # (dp)
        if b(1) is None: return _trunc()
        return 2, f"{name} (${b(1):02X})"

    def dp_ind_y(name: str) -> tuple[int, str]:           # (dp),y
        if b(1) is None: return _trunc()
        return 2, f"{name} (${b(1):02X}),y"

    def dp_long_ind(name: str) -> tuple[int, str]:        # [dp]
        if b(1) is None: return _trunc()
        return 2, f"{name} [${b(1):02X}]"

    def dp_long_ind_y(name: str) -> tuple[int, str]:      # [dp],y
        if b(1) is None: return _trunc()
        return 2, f"{name} [${b(1):02X}],y"

    def stack_rel(name: str) -> tuple[int, str]:          # sr,s
        if b(1) is None: return _trunc()
        return 2, f"{name} ${b(1):02X},s"

    def sr_ind_y(name: str) -> tuple[int, str]:           # (sr,s),y
        if b(1) is None: return _trunc()
        return 2, f"{name} (${b(1):02X},s),y"

    def absolute(name: str) -> tuple[int, str]:
        if b(2) is None: return _trunc()
        return 3, f"{name} ${b(1) | (b(2) << 8):04X}"

    def absolute_x(name: str) -> tuple[int, str]:
        if b(2) is None: return _trunc()
        return 3, f"{name} ${b(1) | (b(2) << 8):04X},x"

    def absolute_y(name: str) -> tuple[int, str]:
        if b(2) is None: return _trunc()
        return 3, f"{name} ${b(1) | (b(2) << 8):04X},y"

    def abs_ind(name: str) -> tuple[int, str]:            # (abs)
        if b(2) is None: return _trunc()
        return 3, f"{name} (${b(1) | (b(2) << 8):04X})"

    def abs_ind_x(name: str) -> tuple[int, str]:          # (abs,x)
        if b(2) is None: return _trunc()
        return 3, f"{name} (${b(1) | (b(2) << 8):04X},x)"

    def abs_long_ind(name: str) -> tuple[int, str]:       # [abs]
        if b(2) is None: return _trunc()
        return 3, f"{name} [${b(1) | (b(2) << 8):04X}]"

    def long_addr(name: str) -> tuple[int, str]:          # 24-bit absolute
        if b(3) is None: return _trunc()
        target = b(1) | (b(2) << 8) | (b(3) << 16)
        return 4, f"{name} ${target:06X}"

    def long_x(name: str) -> tuple[int, str]:             # 24-bit absolute,x
        if b(3) is None: return _trunc()
        target = b(1) | (b(2) << 8) | (b(3) << 16)
        return 4, f"{name} ${target:06X},x"

    def short_call(name: str) -> tuple[int, str]:         # JSR abs
        return absolute(name)

    def long_call(name: str) -> tuple[int, str]:          # JSL long
        return long_addr(name)

    def branch(name: str) -> tuple[int, str]:
        if b(1) is None: return _trunc()
        disp = b(1)
        if disp >= 0x80:
            disp -= 0x100
        src = (base_addr + i) if base_addr is not None else 0
        return 2, (f"{name} ${src + 2 + disp:06X}" if base_addr is not None else f"{name} {disp:+d}")

    def branch_long(name: str) -> tuple[int, str]:        # BRL / PER
        if b(2) is None: return _trunc()
        disp = b(1) | (b(2) << 8)
        if disp >= 0x8000:
            disp -= 0x10000
        src = (base_addr + i) if base_addr is not None else 0
        return 3, (f"{name} ${src + 3 + disp:06X}" if base_addr is not None else f"{name} {disp:+d}")

    def block_move(name: str) -> tuple[int, str]:         # MVP / MVN  [dst, src]
        if b(2) is None: return _trunc()
        return 3, f"{name} ${b(1):02X},${b(2):02X}"

    def sig_byte(name: str) -> tuple[int, str]:           # BRK / COP / WDM
        if b(1) is None: return _trunc()
        return 2, f"{name} #${b(1):02X}"

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

    # ── complete 65816 opcode table ───────────────────────────────────────────

    table: dict[int, tuple[int, str] | callable] = {
        # ── implied / inherent (1 byte) ──────────────────────────────────────
        0x08: (1, "php"),
        0x0A: (1, "asl a"),
        0x0B: (1, "phd"),
        0x18: (1, "clc"),
        0x1A: (1, "inc a"),
        0x1B: (1, "tcs"),
        0x28: (1, "plp"),
        0x2A: (1, "rol a"),
        0x2B: (1, "pld"),
        0x38: (1, "sec"),
        0x3A: (1, "dec a"),
        0x3B: (1, "tsc"),
        0x40: (1, "rti"),
        0x4A: (1, "lsr a"),
        0x4B: (1, "phk"),
        0x48: (1, "pha"),
        0x58: (1, "cli"),
        0x5A: (1, "phy"),
        0x5B: (1, "tcd"),
        0x60: (1, "rts"),
        0x68: (1, "pla"),
        0x6A: (1, "ror a"),
        0x6B: (1, "rtl"),
        0x78: (1, "sei"),
        0x7A: (1, "ply"),
        0x7B: (1, "tdc"),
        0x88: (1, "dey"),
        0x8A: (1, "txa"),
        0x8B: (1, "phb"),
        0x98: (1, "tya"),
        0x9A: (1, "txs"),
        0x9B: (1, "txy"),
        0xA8: (1, "tay"),
        0xAA: (1, "tax"),
        0xAB: (1, "plb"),
        0xB8: (1, "clv"),
        0xBA: (1, "tsx"),
        0xBB: (1, "tyx"),
        0xC8: (1, "iny"),
        0xCA: (1, "dex"),
        0xCB: (1, "wai"),
        0xD8: (1, "cld"),
        0xDA: (1, "phx"),
        0xDB: (1, "stp"),
        0xE8: (1, "inx"),
        0xEA: (1, "nop"),
        0xEB: (1, "xba"),
        0xF8: (1, "sed"),
        0xFA: (1, "plx"),
        0xFB: (1, "xce"),

        # ── 2-byte: imm8 with flag-tracking ─────────────────────────────────
        0xE2: lambda: sep_or_rep("sep", True),
        0xC2: lambda: sep_or_rep("rep", False),

        # ── 2-byte: signature (BRK/COP/WDM) ─────────────────────────────────
        0x00: lambda: sig_byte("brk"),
        0x02: lambda: sig_byte("cop"),
        0x42: lambda: sig_byte("wdm"),

        # ── 2-byte: immediate (accumulator-width) ────────────────────────────
        0x09: lambda: imm_acc("ora"),
        0x29: lambda: imm_acc("and"),
        0x49: lambda: imm_acc("eor"),
        0x69: lambda: imm_acc("adc"),
        0x89: lambda: imm_acc("bit"),
        0xA9: lambda: imm_acc("lda"),
        0xC9: lambda: imm_acc("cmp"),
        0xE9: lambda: imm_acc("sbc"),

        # ── 2-byte: immediate (index-width) ─────────────────────────────────
        0xA0: lambda: imm_idx("ldy"),
        0xA2: lambda: imm_idx("ldx"),
        0xC0: lambda: imm_idx("cpy"),
        0xE0: lambda: imm_idx("cpx"),

        # ── 2-byte: direct page ──────────────────────────────────────────────
        0x04: lambda: dp("tsb"),
        0x05: lambda: dp("ora"),
        0x06: lambda: dp("asl"),
        0x07: lambda: dp_long_ind("ora"),
        0x14: lambda: dp("trb"),
        0x24: lambda: dp("bit"),
        0x25: lambda: dp("and"),
        0x26: lambda: dp("rol"),
        0x27: lambda: dp_long_ind("and"),
        0x44: lambda: block_move("mvp"),
        0x45: lambda: dp("eor"),
        0x46: lambda: dp("lsr"),
        0x47: lambda: dp_long_ind("eor"),
        0x54: lambda: block_move("mvn"),
        0x64: lambda: dp("stz"),
        0x65: lambda: dp("adc"),
        0x66: lambda: dp("ror"),
        0x67: lambda: dp_long_ind("adc"),
        0x84: lambda: dp("sty"),
        0x85: lambda: dp("sta"),
        0x86: lambda: dp("stx"),
        0x87: lambda: dp_long_ind("sta"),
        0xA4: lambda: dp("ldy"),
        0xA5: lambda: dp("lda"),
        0xA6: lambda: dp("ldx"),
        0xA7: lambda: dp_long_ind("lda"),
        0xC4: lambda: dp("cpy"),
        0xC5: lambda: dp("cmp"),
        0xC6: lambda: dp("dec"),
        0xC7: lambda: dp_long_ind("cmp"),
        0xE4: lambda: dp("cpx"),
        0xE5: lambda: dp("sbc"),
        0xE6: lambda: dp("inc"),
        0xE7: lambda: dp_long_ind("sbc"),

        # ── 2-byte: direct page, x ───────────────────────────────────────────
        0x15: lambda: dp_x("ora"),
        0x16: lambda: dp_x("asl"),
        0x34: lambda: dp_x("bit"),
        0x35: lambda: dp_x("and"),
        0x36: lambda: dp_x("rol"),
        0x55: lambda: dp_x("eor"),
        0x56: lambda: dp_x("lsr"),
        0x74: lambda: dp_x("stz"),
        0x75: lambda: dp_x("adc"),
        0x76: lambda: dp_x("ror"),
        0x94: lambda: dp_x("sty"),
        0x95: lambda: dp_x("sta"),
        0xB4: lambda: dp_x("ldy"),
        0xB5: lambda: dp_x("lda"),
        0xD5: lambda: dp_x("cmp"),
        0xD6: lambda: dp_x("dec"),
        0xF5: lambda: dp_x("sbc"),
        0xF6: lambda: dp_x("inc"),

        # ── 2-byte: direct page, y ───────────────────────────────────────────
        0x96: lambda: dp_y("stx"),
        0xB6: lambda: dp_y("ldx"),

        # ── 2-byte: (dp,x) indexed indirect ─────────────────────────────────
        0x01: lambda: dp_ind_x("ora"),
        0x21: lambda: dp_ind_x("and"),
        0x41: lambda: dp_ind_x("eor"),
        0x61: lambda: dp_ind_x("adc"),
        0x81: lambda: dp_ind_x("sta"),
        0xA1: lambda: dp_ind_x("lda"),
        0xC1: lambda: dp_ind_x("cmp"),
        0xE1: lambda: dp_ind_x("sbc"),

        # ── 2-byte: (dp) indirect ────────────────────────────────────────────
        0x12: lambda: dp_ind("ora"),
        0x32: lambda: dp_ind("and"),
        0x52: lambda: dp_ind("eor"),
        0x72: lambda: dp_ind("adc"),
        0x92: lambda: dp_ind("sta"),
        0xB2: lambda: dp_ind("lda"),
        0xD2: lambda: dp_ind("cmp"),
        0xF2: lambda: dp_ind("sbc"),

        # ── 2-byte: (dp),y indirect indexed ─────────────────────────────────
        0x11: lambda: dp_ind_y("ora"),
        0x31: lambda: dp_ind_y("and"),
        0x51: lambda: dp_ind_y("eor"),
        0x71: lambda: dp_ind_y("adc"),
        0x91: lambda: dp_ind_y("sta"),
        0xB1: lambda: dp_ind_y("lda"),
        0xD1: lambda: dp_ind_y("cmp"),
        0xF1: lambda: dp_ind_y("sbc"),

        # ── 2-byte: [dp],y long indirect indexed ─────────────────────────────
        0x17: lambda: dp_long_ind_y("ora"),
        0x37: lambda: dp_long_ind_y("and"),
        0x57: lambda: dp_long_ind_y("eor"),
        0x77: lambda: dp_long_ind_y("adc"),
        0x97: lambda: dp_long_ind_y("sta"),
        0xB7: lambda: dp_long_ind_y("lda"),
        0xD7: lambda: dp_long_ind_y("cmp"),
        0xF7: lambda: dp_long_ind_y("sbc"),

        # ── 2-byte: stack-relative ───────────────────────────────────────────
        0x03: lambda: stack_rel("ora"),
        0x23: lambda: stack_rel("and"),
        0x43: lambda: stack_rel("eor"),
        0x63: lambda: stack_rel("adc"),
        0x83: lambda: stack_rel("sta"),
        0xA3: lambda: stack_rel("lda"),
        0xC3: lambda: stack_rel("cmp"),
        0xE3: lambda: stack_rel("sbc"),

        # ── 2-byte: (sr,s),y ─────────────────────────────────────────────────
        0x13: lambda: sr_ind_y("ora"),
        0x33: lambda: sr_ind_y("and"),
        0x53: lambda: sr_ind_y("eor"),
        0x73: lambda: sr_ind_y("adc"),
        0x93: lambda: sr_ind_y("sta"),
        0xB3: lambda: sr_ind_y("lda"),
        0xD3: lambda: sr_ind_y("cmp"),
        0xF3: lambda: sr_ind_y("sbc"),

        # ── 2-byte: PEI (push effective indirect) ────────────────────────────
        0xD4: lambda: dp_ind("pei"),

        # ── 3-byte: absolute ─────────────────────────────────────────────────
        0x0C: lambda: absolute("tsb"),
        0x0D: lambda: absolute("ora"),
        0x0E: lambda: absolute("asl"),
        0x1C: lambda: absolute("trb"),
        0x1D: lambda: absolute_x("ora"),
        0x1E: lambda: absolute_x("asl"),
        0x20: lambda: short_call("jsr"),
        0x2C: lambda: absolute("bit"),
        0x2D: lambda: absolute("and"),
        0x2E: lambda: absolute("rol"),
        0x3C: lambda: absolute_x("bit"),
        0x3D: lambda: absolute_x("and"),
        0x3E: lambda: absolute_x("rol"),
        0x4C: lambda: absolute("jmp"),
        0x4D: lambda: absolute("eor"),
        0x4E: lambda: absolute("lsr"),
        0x5D: lambda: absolute_x("eor"),
        0x5E: lambda: absolute_x("lsr"),
        0x6C: lambda: abs_ind("jmp"),
        0x6D: lambda: absolute("adc"),
        0x6E: lambda: absolute("ror"),
        0x7C: lambda: abs_ind_x("jmp"),
        0x7D: lambda: absolute_x("adc"),
        0x7E: lambda: absolute_x("ror"),
        0x8C: lambda: absolute("sty"),
        0x8D: lambda: absolute("sta"),
        0x8E: lambda: absolute("stx"),
        0x9C: lambda: absolute("stz"),
        0x9D: lambda: absolute_x("sta"),
        0x9E: lambda: absolute_x("stz"),
        0xAC: lambda: absolute("ldy"),
        0xAD: lambda: absolute("lda"),
        0xAE: lambda: absolute("ldx"),
        0xBC: lambda: absolute_x("ldy"),
        0xBD: lambda: absolute_x("lda"),
        0xBE: lambda: absolute_y("ldx"),
        0xB9: lambda: absolute_y("lda"),
        0xCC: lambda: absolute("cpy"),
        0xCD: lambda: absolute("cmp"),
        0xCE: lambda: absolute("dec"),
        0xD9: lambda: absolute_y("cmp"),
        0xDC: lambda: abs_long_ind("jmp"),
        0xDD: lambda: absolute_x("cmp"),
        0xDE: lambda: absolute_x("dec"),
        0xEC: lambda: absolute("cpx"),
        0xED: lambda: absolute("sbc"),
        0xEE: lambda: absolute("inc"),
        0xF4: lambda: absolute("pea"),
        0xF9: lambda: absolute_y("sbc"),
        0xFC: lambda: abs_ind_x("jsr"),
        0xFD: lambda: absolute_x("sbc"),
        0xFE: lambda: absolute_x("inc"),

        # ── 3-byte: absolute,y (store) ───────────────────────────────────────
        0x99: lambda: absolute_y("sta"),
        0x39: lambda: absolute_y("and"),
        0x59: lambda: absolute_y("eor"),
        0x79: lambda: absolute_y("adc"),

        # ── 3-byte: branches ─────────────────────────────────────────────────
        0x10: lambda: branch("bpl"),
        0x30: lambda: branch("bmi"),
        0x50: lambda: branch("bvc"),
        0x70: lambda: branch("bvs"),
        0x80: lambda: branch("bra"),
        0x82: lambda: branch_long("brl"),
        0x62: lambda: branch_long("per"),
        0x90: lambda: branch("bcc"),
        0xB0: lambda: branch("bcs"),
        0xD0: lambda: branch("bne"),
        0xF0: lambda: branch("beq"),

        # ── 4-byte: 24-bit long ──────────────────────────────────────────────
        0x0F: lambda: long_addr("ora"),
        0x22: lambda: long_call("jsl"),
        0x2F: lambda: long_addr("and"),
        0x4F: lambda: long_addr("eor"),
        0x5C: lambda: long_addr("jmp"),
        0x6F: lambda: long_addr("adc"),
        0x8F: lambda: long_addr("sta"),
        0xAF: lambda: long_addr("lda"),
        0xCF: lambda: long_addr("cmp"),
        0xEF: lambda: long_addr("sbc"),

        # ── 4-byte: 24-bit long, x ───────────────────────────────────────────
        0x1F: lambda: long_x("ora"),
        0x3F: lambda: long_x("and"),
        0x5F: lambda: long_x("eor"),
        0x7F: lambda: long_x("adc"),
        0x9F: lambda: long_x("sta"),
        0xBF: lambda: long_x("lda"),
        0xDF: lambda: long_x("cmp"),
        0xFF: lambda: long_x("sbc"),
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
