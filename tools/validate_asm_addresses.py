#!/usr/bin/env python3
"""Validate and optionally fix ROM address comments in ASM files.

Uses baserom.sfc as objective ground truth (the unmodified original ROM,
never overwritten by the build system — unlike shiren.sfc which is rebuilt
from ASM and would produce false mismatches against in-progress edits). For each non-local label with a
ROM address encoded in its name (e.g. func_C2D8F0, DecompressGraphics_C5F0AC),
computes the HiROM file offset, then walks forward accumulating instruction
sizes. For .db/.dw lines the byte content is compared directly against the ROM
to confirm the anchor and current position are correct. Any ;XXXXXX address
comment that disagrees with the ROM-derived address is flagged.

The byte comparison is the objective test: if the .db bytes match the ROM at
the computed offset, those bytes ARE at that address — the comment is wrong,
not the code.

Examples:
  python3 tools/validate_asm_addresses.py --file code/bank_02.asm
  python3 tools/validate_asm_addresses.py --file code/bank_02.asm --fix
  python3 tools/validate_asm_addresses.py --file code/bank_02.asm --anchor C2D8F0
  python3 tools/validate_asm_addresses.py --file code/bank_02.asm --anchor C2D8F0 --fix
"""

from __future__ import annotations

import argparse
import re
import sys
from dataclasses import dataclass, field
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from promote_raw_item_handler_label import (
    _db_bytes_from_line,
    _dw_bytes_from_line,
    estimate_asm_line_size,
    load_lines,
    write_lines,
)

ROOT = Path(__file__).resolve().parent.parent
ROM_PATH = ROOT / "baserom.sfc"

LABEL_NAME_RE = re.compile(r"^([A-Za-z0-9_@.]+):\s*$")
# Matches a C followed by exactly 5 uppercase hex digits anywhere in a label name
EMBEDDED_ADDR_RE = re.compile(r"C([0-9A-F]{5})\b")
# Matches a trailing ;XXXXXX address comment at end of line (with optional whitespace)
TRAILING_ADDR_RE = re.compile(r";([0-9A-F]{6})\s*$")


# ── ROM mapping ──────────────────────────────────────────────────────────────

def snes_to_rom_offset(addr: int) -> int | None:
    """Convert a SNES 24-bit address to a HiROM file offset.

    HiROM banks $40-$7D and $C0-$FF each map a full 64KB bank directly to ROM.
    Banks $00-$3F/$80-$BF expose ROM only in the upper half ($8000-$FFFF).
    Returns None for addresses in WRAM/IO space.
    """
    bank = (addr >> 16) & 0xFF
    offset = addr & 0xFFFF
    if (0x40 <= bank <= 0x7D) or (0xC0 <= bank <= 0xFF):
        return (bank & 0x3F) * 0x10000 + offset
    if offset >= 0x8000:
        return (bank & 0x3F) * 0x10000 + (offset - 0x8000)
    return None  # WRAM / IO region


def rom_offset_to_snes(rom_off: int, bank_hint: int) -> int:
    """Recover a SNES address from a ROM offset, keeping the bank-style of bank_hint.

    bank_hint should be the bank byte of the anchor label so we reconstruct
    addresses in the same $C0-$FF (fast) or $40-$7F (slow) style.
    """
    phys_bank = rom_off >> 16
    page = rom_off & 0xFFFF
    if bank_hint >= 0xC0:
        return ((0xC0 | phys_bank) << 16) | page
    if bank_hint >= 0x40:
        return ((0x40 | phys_bank) << 16) | page
    return (phys_bank << 16) | page


# ── label parsing ─────────────────────────────────────────────────────────────

def anchor_addr_from_label(line: str) -> int | None:
    """Return the SNES address embedded in a non-local label name, or None.

    Handles labels like:
      func_C2D8F0:          → 0xC2D8F0
      DecompressGraphics:   → None  (no address)
      @lbl_C2D8EE:          → None  (local label, skipped)
    """
    stripped = line.strip()
    m = LABEL_NAME_RE.match(stripped)
    if not m:
        return None
    name = m.group(1)
    if name.startswith("@") or name.startswith("."):
        return None  # local label — not a reliable anchor
    hm = EMBEDDED_ADDR_RE.search(name.upper())
    if not hm:
        return None
    return int("C" + hm.group(1), 16)


# ── walk result ───────────────────────────────────────────────────────────────

@dataclass
class Mismatch:
    line_no: int        # 1-based
    orig: str           # original line text (no trailing newline)
    comment_addr: int   # what ;XXXXXX currently says
    correct_addr: int   # what the ROM says it should be

    def describe(self) -> str:
        return (
            f"  line {self.line_no}: comment={self.comment_addr:06X}  "
            f"correct={self.correct_addr:06X}\n"
            f"    {self.orig}"
        )


@dataclass
class AnchorResult:
    anchor_line: int          # 1-based line number of the label
    anchor_addr: int          # SNES address of the anchor
    verified: bool = False    # True if ≥1 .db block byte-matched the ROM
    mismatches: list[Mismatch] = field(default_factory=list)
    stop_reason: str | None = None   # why the walk ended early, if at all


# ── core walk ────────────────────────────────────────────────────────────────

def walk_from_anchor(
    lines: list[str],
    rom: bytes,
    anchor_idx: int,
    anchor_addr: int,
) -> AnchorResult:
    """Walk ASM lines forward from anchor_idx, verifying address comments.

    Stops at:
    - the next non-local label (start of a new anchor domain)
    - a .db byte block that doesn't match the ROM (anchor or walk is wrong)
    - an instruction with unknown size (can't safely continue)
    """
    result = AnchorResult(anchor_line=anchor_idx + 1, anchor_addr=anchor_addr)

    rom_off = snes_to_rom_offset(anchor_addr)
    if rom_off is None:
        result.stop_reason = "address not in ROM-mapped region"
        return result
    if rom_off >= len(rom):
        result.stop_reason = f"ROM offset {rom_off:#x} beyond ROM size {len(rom):#x}"
        return result

    bank_hint = anchor_addr >> 16
    current_off = rom_off

    for idx in range(anchor_idx + 1, len(lines)):
        line = lines[idx]
        stripped = line.strip()

        # Blank line or standalone comment — no bytes
        if not stripped or stripped.startswith(";"):
            continue

        # Assembler directives that affect width state but emit no bytes
        if stripped.upper().startswith((".ACCU", ".INDEX")):
            continue

        # Label line
        lm = LABEL_NAME_RE.match(stripped)
        if lm:
            name = lm.group(1)
            if not (name.startswith("@") or name.startswith(".")):
                # Non-local label — end of this anchor's domain
                result.stop_reason = f"next anchor at line {idx + 1}: {stripped}"
                break
            # Local label — zero bytes, keep going
            continue

        size = estimate_asm_line_size(stripped)
        if size is None:
            result.stop_reason = f"unknown instruction size at line {idx + 1}: {stripped!r}"
            break
        if size == 0:
            continue

        # The correct SNES address for this line
        current_snes = rom_offset_to_snes(current_off, bank_hint)

        # Check the trailing ;XXXXXX comment
        tm = TRAILING_ADDR_RE.search(line)
        if tm:
            comment_val = int(tm.group(1), 16)
            if comment_val != current_snes:
                result.mismatches.append(Mismatch(
                    line_no=idx + 1,
                    orig=line.rstrip(),
                    comment_addr=comment_val,
                    correct_addr=current_snes,
                ))

        # Byte-verify .db lines against ROM — this is the objective check
        if stripped.startswith(".db") or " .db " in stripped:
            db_bytes = _db_bytes_from_line(line)
            if db_bytes:
                end_off = current_off + len(db_bytes)
                if end_off > len(rom):
                    result.stop_reason = "ran off end of ROM"
                    break
                rom_slice = list(rom[current_off:end_off])
                if rom_slice == db_bytes:
                    result.verified = True
                else:
                    # Bytes don't match — anchor is wrong or we've drifted
                    result.stop_reason = (
                        f"byte mismatch at line {idx + 1} "
                        f"(rom={bytes(rom_slice).hex().upper()}, "
                        f"asm={bytes(db_bytes).hex().upper()})"
                    )
                    # Remove the last mismatch we just recorded for this line
                    # (the address might also be wrong but the bytes are wrong first)
                    if result.mismatches and result.mismatches[-1].line_no == idx + 1:
                        result.mismatches.pop()
                    break

        # Byte-verify .dw lines (pointers in little-endian)
        elif stripped.startswith(".dw") or " .dw " in stripped:
            dw_bytes = _dw_bytes_from_line(line)
            if dw_bytes:
                end_off = current_off + len(dw_bytes)
                if end_off <= len(rom):
                    rom_slice = list(rom[current_off:end_off])
                    if rom_slice == dw_bytes:
                        result.verified = True
                    # .dw mismatches don't stop the walk — pointers can be
                    # bank-relative and may not match raw ROM bytes exactly

        current_off += size

    return result


# ── fix helpers ───────────────────────────────────────────────────────────────

def apply_fix(line: str, correct: int) -> str:
    """Replace the trailing ;XXXXXX comment address with the correct value."""
    return TRAILING_ADDR_RE.sub(f";{correct:06X}", line)


# ── main ─────────────────────────────────────────────────────────────────────

def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--file", required=True, help="ASM file to validate")
    parser.add_argument("--rom", default=str(ROM_PATH),
                        help="ROM binary to use as ground truth (default: baserom.sfc)")
    parser.add_argument("--fix", action="store_true",
                        help="rewrite wrong address comments in place")
    parser.add_argument("--anchor",
                        help="only validate from this SNES address, e.g. C2D8F0 or func_C2D8F0")
    parser.add_argument("--verified-only", action="store_true",
                        help="only report mismatches from anchors confirmed by ROM byte match")
    args = parser.parse_args(argv)

    rom_path = Path(args.rom)
    if not rom_path.exists():
        print(f"error: ROM not found: {rom_path}", file=sys.stderr)
        return 1
    rom = rom_path.read_bytes()

    asm_path = Path(args.file)
    if not asm_path.is_absolute():
        asm_path = ROOT / asm_path
    if not asm_path.exists():
        print(f"error: ASM file not found: {asm_path}", file=sys.stderr)
        return 1
    lines = load_lines(asm_path)

    # Parse --anchor
    only_addr: int | None = None
    if args.anchor:
        raw = args.anchor.upper()
        # Strip leading "FUNC_" or similar to get just the hex part
        hm = EMBEDDED_ADDR_RE.search(raw)
        if hm:
            only_addr = int("C" + hm.group(1), 16)
        else:
            raw = raw.lstrip("C")
            if len(raw) == 5:
                raw = "C" + raw
            try:
                only_addr = int(raw, 16)
            except ValueError:
                print(f"error: cannot parse --anchor {args.anchor!r}", file=sys.stderr)
                return 1

    # Gather anchors
    anchors: list[tuple[int, int]] = []  # (line_idx 0-based, snes_addr)
    for idx, line in enumerate(lines):
        addr = anchor_addr_from_label(line)
        if addr is None:
            continue
        if only_addr is not None and addr != only_addr:
            continue
        anchors.append((idx, addr))

    if not anchors:
        target = f" matching {args.anchor!r}" if args.anchor else ""
        print(f"no anchor labels found{target}", file=sys.stderr)
        return 1

    # Walk each anchor
    all_results: list[AnchorResult] = []
    for anchor_idx, anchor_addr in anchors:
        result = walk_from_anchor(lines, rom, anchor_idx, anchor_addr)
        all_results.append(result)

    # Report
    total = 0
    all_mismatches: list[Mismatch] = []
    for result in all_results:
        if args.verified_only and not result.verified:
            continue
        label = lines[result.anchor_line - 1].strip()
        verified_tag = " [ROM-verified]" if result.verified else " [unverified]"
        if result.mismatches:
            print(f"\n[anchor] {label}{verified_tag}")
            for mm in result.mismatches:
                print(mm.describe())
            total += len(result.mismatches)
            all_mismatches.extend(result.mismatches)
        elif args.anchor:
            # When targeting a specific anchor, show clean result too
            print(f"\n[anchor] {label}{verified_tag}")
            print("  no mismatches found")
        if result.stop_reason and args.anchor:
            print(f"  stopped: {result.stop_reason}")

    print(f"\ntotal mismatches: {total} across {len(all_results)} anchors"
          f" ({sum(1 for r in all_results if r.verified)} ROM-verified)")

    # Fix
    if args.fix and all_mismatches:
        fix_map: dict[int, int] = {mm.line_no: mm.correct_addr for mm in all_mismatches}
        new_lines = [
            apply_fix(line, fix_map[idx + 1]) if (idx + 1) in fix_map else line
            for idx, line in enumerate(lines)
        ]
        write_lines(asm_path, new_lines)
        print(f"fixed {len(fix_map)} lines in {asm_path.relative_to(ROOT)}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
