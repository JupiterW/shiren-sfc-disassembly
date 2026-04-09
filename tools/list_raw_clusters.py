#!/usr/bin/env python3
"""List candidate raw clusters in an asm file.

This is a planner for the local-lift workflow:
- scan one file using computed address flow
- find regions that contain raw `.db`/`.dw` lines
- report candidate start/end ROM addresses
- classify clusters as raw-only vs mixed
- print the `lift_raw_cluster.py` command you would run next

Examples:
  python3 tools/list_raw_clusters.py --file code/item_effects.asm
  python3 tools/list_raw_clusters.py --file code/item_effects.asm --min-bytes 8 --max-clusters 20
"""

from __future__ import annotations

import argparse
import re
from dataclasses import dataclass
from pathlib import Path

from lift_raw_cluster import ROOT, _compute_line_starts, _resolve_file
from promote_raw_item_handler_label import estimate_asm_line_size, load_lines


RAW_RE = re.compile(r"^\s*\.(db|dw)\b")
LABEL_RE = re.compile(r"^[A-Za-z0-9_@.]+:\s*$")


@dataclass
class Cluster:
    start_idx: int
    end_idx: int
    start_addr: int
    end_addr: int
    raw_lines: int
    asm_lines: int
    label_lines: int
    byte_count: int

    @property
    def kind(self) -> str:
        return "mixed" if self.asm_lines else "raw-only"


def _is_label(line: str) -> bool:
    return bool(LABEL_RE.match(line.strip()))


def find_clusters(lines: list[str]) -> list[Cluster]:
    line_starts = _compute_line_starts(lines)
    clusters: list[Cluster] = []

    open_start: int | None = None
    raw_lines = asm_lines = label_lines = 0
    first_addr: int | None = None
    last_addr: int | None = None

    def finish(end_idx: int) -> None:
        nonlocal open_start, raw_lines, asm_lines, label_lines, first_addr, last_addr
        if open_start is None or first_addr is None or last_addr is None:
            open_start = None
            raw_lines = asm_lines = label_lines = 0
            first_addr = last_addr = None
            return
        clusters.append(
            Cluster(
                start_idx=open_start,
                end_idx=end_idx,
                start_addr=first_addr,
                end_addr=last_addr,
                raw_lines=raw_lines,
                asm_lines=asm_lines,
                label_lines=label_lines,
                byte_count=last_addr - first_addr + 1,
            )
        )
        open_start = None
        raw_lines = asm_lines = label_lines = 0
        first_addr = last_addr = None

    for idx, line in enumerate(lines):
        stripped = line.strip()
        line_start = line_starts[idx]
        line_size = estimate_asm_line_size(stripped)
        line_end = None if line_start is None or line_size in (None, 0) else line_start + line_size - 1

        is_raw = bool(RAW_RE.match(stripped))
        is_label = _is_label(line)
        is_code = line_size is not None and line_size > 0

        if is_label and open_start is not None:
            finish(idx - 1)

        if is_raw:
            if open_start is None:
                open_start = idx
            raw_lines += 1
        elif open_start is not None:
            if is_label:
                label_lines += 1
            elif is_code:
                asm_lines += 1
            elif stripped and not stripped.startswith(";"):
                asm_lines += 1

        if open_start is not None and line_start is not None and line_end is not None:
            if first_addr is None:
                first_addr = line_start
            last_addr = line_end

    if open_start is not None:
        finish(len(lines) - 1)

    return clusters


def fmt_cluster(path: Path, cluster: Cluster) -> str:
    return (
        f"{cluster.start_addr:06X}-{cluster.end_addr:06X}  "
        f"{cluster.kind:<8}  "
        f"bytes={cluster.byte_count:<4}  "
        f"lines={cluster.start_idx + 1}-{cluster.end_idx + 1}  "
        f"raw={cluster.raw_lines} asm={cluster.asm_lines}  "
        f"cmd=\"python3 tools/lift_raw_cluster.py --file {path.relative_to(ROOT)} "
        f"--start {cluster.start_addr:06X} --end {cluster.end_addr:06X}\""
    )


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--file", required=True, help="asm file to scan")
    parser.add_argument("--min-bytes", type=int, default=1, help="minimum cluster byte size to report")
    parser.add_argument("--max-clusters", type=int, default=0, help="maximum number of clusters to print (0 = all)")
    parser.add_argument("--raw-only", action="store_true", help="only report raw-only clusters")
    args = parser.parse_args(argv)

    path = _resolve_file(args.file)
    lines = load_lines(path)
    clusters = find_clusters(lines)
    clusters = [c for c in clusters if c.byte_count >= args.min_bytes]
    if args.raw_only:
        clusters = [c for c in clusters if c.kind == "raw-only"]
    clusters.sort(key=lambda c: (c.kind != "mixed", -(c.byte_count), c.start_addr))

    if args.max_clusters:
        clusters = clusters[: args.max_clusters]

    print(f"{path.relative_to(ROOT)}")
    print(f"clusters: {len(clusters)}")
    for cluster in clusters:
        print(fmt_cluster(path, cluster))
    return 0


if __name__ == "__main__":
    raise SystemExit(main(__import__("sys").argv[1:]))
