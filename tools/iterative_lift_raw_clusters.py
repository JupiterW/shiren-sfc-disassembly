#!/usr/bin/env python3
"""Iteratively apply raw-cluster lifts to one file, verifying after each one.

Examples:
  python3 tools/iterative_lift_raw_clusters.py --file code/item_effects.asm --dry-run
  python3 tools/iterative_lift_raw_clusters.py --file code/item_effects.asm --limit 3
"""

from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path

from list_raw_clusters import find_clusters
from lift_raw_cluster import ROOT, _resolve_file
from promote_raw_item_handler_label import load_lines


def run(cmd: str) -> subprocess.CompletedProcess[str]:
    return subprocess.run(cmd, shell=True, cwd=ROOT, text=True, capture_output=True)


def snapshot(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def restore(path: Path, text: str) -> None:
    path.write_text(text, encoding="utf-8")


def sorted_clusters(path: Path, min_bytes: int, max_bytes: int | None, raw_only: bool) -> list:
    clusters = find_clusters(load_lines(path))
    clusters = [c for c in clusters if c.byte_count >= min_bytes]
    if max_bytes is not None:
        clusters = [c for c in clusters if c.byte_count <= max_bytes]
    if raw_only:
        clusters = [c for c in clusters if c.kind == "raw-only"]
    else:
        clusters = [c for c in clusters if c.kind == "mixed"]
    clusters.sort(key=lambda c: (c.kind != "mixed", -(c.byte_count), c.start_addr))
    return clusters


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--file", required=True, help="asm file to process")
    parser.add_argument("--min-bytes", type=int, default=16, help="minimum cluster size")
    parser.add_argument("--max-bytes", type=int, help="maximum cluster size")
    parser.add_argument("--limit", type=int, help="maximum number of clusters to attempt")
    parser.add_argument("--raw-only", action="store_true", help="process raw-only clusters instead of mixed clusters")
    parser.add_argument("--dry-run", action="store_true", help="list planned clusters without applying them")
    parser.add_argument("--stop-on-fail", action="store_true", default=True, help="stop on first failure")
    args = parser.parse_args(argv)

    path = _resolve_file(args.file)
    clusters = sorted_clusters(path, args.min_bytes, args.max_bytes, args.raw_only)
    if args.limit is not None:
        clusters = clusters[: args.limit]

    if args.dry_run:
        for cluster in clusters:
            print(
                f"{cluster.start_addr:06X}-{cluster.end_addr:06X} "
                f"{cluster.kind} bytes={cluster.byte_count} "
                f"lines={cluster.start_idx + 1}-{cluster.end_idx + 1}"
            )
        print(f"planned lifts: {len(clusters)}")
        return 0

    kept = 0
    baseline = snapshot(path)
    rel = path.relative_to(ROOT)

    for cluster in clusters:
        before = baseline
        cmd = [
            sys.executable,
            "tools/lift_raw_cluster.py",
            "--file",
            str(rel),
            "--start",
            f"{cluster.start_addr:06X}",
            "--end",
            f"{cluster.end_addr:06X}",
            "--apply",
            "--quiet",
        ]
        proc = subprocess.run(cmd, cwd=ROOT, text=True, capture_output=True)
        if proc.returncode != 0:
            restore(path, before)
            print(f"FAIL  {cluster.start_addr:06X}-{cluster.end_addr:06X} apply")
            if proc.stderr:
                print(proc.stderr.strip())
            if proc.stdout:
                print(proc.stdout.strip())
            return 1

        verify = run("make -B -j PYTHON=.venv/bin/python && shasum -c shiren.sha1")
        if verify.returncode == 0:
            kept += 1
            baseline = snapshot(path)
            print(f"KEPT  {cluster.start_addr:06X}-{cluster.end_addr:06X}")
            continue

        restore(path, before)
        print(f"FAIL  {cluster.start_addr:06X}-{cluster.end_addr:06X} verify")
        if verify.stdout:
            print(verify.stdout.strip())
        if verify.stderr:
            print(verify.stderr.strip())
        if args.stop_on_fail:
            break

    print(f"kept lifts: {kept}/{len(clusters)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
