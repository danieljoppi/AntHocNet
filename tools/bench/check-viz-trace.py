#!/usr/bin/env python3
# SPDX-License-Identifier: MIT OR GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
"""Cross-check an ns-3 replay trace (#641) against its run and its cell.

    check-viz-trace.py TRACE.jsonl [--cell results/cells/<cell>.txt] [--max-mb 2]

A replay is only worth watching if it is the measured run. This checks:
  * the trace is a complete v1 trace (header, steps in time order, end line);
  * the last step's delivered count equals the run's own books (the end
    line), so the counter the player shows ends where the run's PDR does;
  * with --cell, the end line's PDR equals the cell's ##RUN## row for the
    same seed and the anthocnet arm, to the decimals the cell prints --
    the replay is that seed of the published cell, not a different run;
  * the trace is small enough to fetch (default 2 MB).
Exit 1 on any FAIL.
"""
import argparse
import json
import os
import sys


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("trace")
    ap.add_argument("--cell")
    ap.add_argument("--max-mb", type=float, default=2.0)
    a = ap.parse_args()

    bad = []
    with open(a.trace) as f:
        lines = [json.loads(line) for line in f if line.strip()]
    head = lines[0] if lines else {}
    if head.get("kind") != "header" or head.get("v") != 1:
        bad.append("first line is not a v1 header")
    steps = [x for x in lines if "t" in x]
    end = next((x for x in lines if x.get("kind") == "end"), None)
    if not steps:
        bad.append("no steps")
    if end is None:
        bad.append("no end line: the run did not finish")
    times = [s["t"] for s in steps]
    if times != sorted(times):
        bad.append("steps out of time order")
    if steps and end:
        last = steps[-1]
        if last["rx"] != end["rx"]:
            bad.append(f"last step delivered {last['rx']} != the run's {end['rx']}")
        if last["tx"] > end["tx"]:
            bad.append(f"last step sent {last['tx']} > the run's offered {end['tx']}")
    mb = os.path.getsize(a.trace) / 1e6
    if mb > a.max_mb:
        bad.append(f"{mb:.2f} MB > {a.max_mb} MB")

    cell_pdr, digits = None, 2
    if a.cell and end:
        seed = head.get("seed")
        with open(a.cell) as f:
            for line in f:
                p = line.split()
                if len(p) > 3 and p[0] == "##RUN##" and p[2] == "anthocnet" and int(p[1]) == seed:
                    cell_pdr = float(p[3])
                    digits = len(p[3].split(".")[1]) if "." in p[3] else 0
        if cell_pdr is None:
            bad.append(f"{a.cell} has no ##RUN## row for anthocnet, seed {seed}")
        elif f"{end['pdr']:.{digits}f}" != f"{cell_pdr:.{digits}f}":
            bad.append(f"PDR {end['pdr']:.{digits}f} != the cell's {cell_pdr:.{digits}f} for seed {seed}")

    name = os.path.basename(a.trace)
    for b in bad:
        print(f"FAIL: {name}: {b}")
    if bad:
        sys.exit(1)
    extra = f"; matches {os.path.basename(a.cell)} seed {head['seed']} ({cell_pdr:.{digits}f} %)" if cell_pdr is not None else ""
    print(f"ok: {name}: {len(steps)} steps, {head['nodes']} nodes, {mb:.2f} MB, "
          f"delivered {end['rx']}/{end['tx']} = {end['pdr']:.2f} %{extra}")


if __name__ == "__main__":
    main()
