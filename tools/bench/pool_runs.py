#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
"""Pool seed-split campaign CSVs into one aggregate CSV (#126).

A point too big for the 6 h hosted-runner ceiling at full seed count runs as
several dispatches of the same point with different --run-first values
(e.g. runs=10 firstRun=1, then runs=10 firstRun=11). Each dispatch produces
an aggregate campaign CSV plus its #319 per-run sibling (<file>-runs.csv).
This script merges the splits back into one publishable aggregate row per
(kind, group, x, protocol):

- pdr/delay/delay99/thrput/nrl/jitter/nrl_bytes and their *_sd columns are
  recomputed EXACTLY from the pooled per-run sibling rows — no combined-
  variance approximation, which is the reason the sibling file exists.
- every other numeric column (energy_*, drop_*, path_*, ...) is the
  runs-weighted mean of the split aggregates (those are means, so the
  weighted mean is exact; their dispersion was never published).
- context columns (scenario/class/nNodes/...) come from the first split row
  and must agree across splits — a mismatch means the splits are not the
  same point and the script FAILs.
- `runs` becomes the pooled total; `run_first` the smallest. Duplicate seeds
  across splits (two dispatches covering the same RNG run) FAIL: pooling
  them would double-weight realisations.

Usage:
    pool_runs.py --out pooled.csv SPLIT_A.csv SPLIT_B.csv [...]

The output is a standard classified CSV (same columns as the inputs), and a
pooled -runs.csv sibling is written next to --out so downstream bootstrap /
paired consumers (#319) keep working on the pooled point.
"""
import argparse
import csv
import os
import sys

import stats_util

# metric -> per-run sibling column it is recomputed from
EXACT = {"pdr_pct": "pdr_pct", "delay_ms": "delay_ms",
         "delay99_ms": "delay99_ms", "throughput_kbps": "throughput_kbps",
         "nrl": "nrl", "jitter_ms": "jitter_ms", "nrl_bytes": "nrl_bytes"}
SD_OF = {"pdr_sd": "pdr_pct", "delay_sd": "delay_ms",
         "delay99_sd": "delay99_ms", "nrl_sd": "nrl"}
CONTEXT = ["scenario", "class", "nNodes", "areaX", "speed", "pause", "flows",
           "propagation"]


def fnum(v):
    try:
        return float(v)
    except (TypeError, ValueError):
        return None


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("files", nargs="+", help="split aggregate campaign CSVs "
                    "(each with its -runs.csv sibling next to it)")
    ap.add_argument("--out", required=True)
    args = ap.parse_args()

    agg = {}       # (kind, group, x, protocol) -> [aggregate rows]
    per_run = {}   # same key -> {seed: sibling row}
    header = None
    run_header = None
    for path in args.files:
        with open(path, newline="") as fh:
            r = csv.DictReader(fh)
            header = header or r.fieldnames
            for row in r:
                k = (row["kind"], row["group"], row["x"], row["protocol"])
                agg.setdefault(k, []).append(row)
        sib = path.removesuffix(".csv") + "-runs.csv"
        if not os.path.exists(sib):
            sys.exit(f"FAIL: {sib} missing — pooling recomputes sd from the "
                     "per-run rows (#319); a split without its sibling "
                     "cannot be pooled exactly")
        with open(sib, newline="") as fh:
            r = csv.DictReader(fh)
            run_header = run_header or r.fieldnames
            for row in r:
                k = (row["kind"], row["group"], row["x"], row["protocol"])
                seed = int(row["run"])
                if seed in per_run.setdefault(k, {}):
                    sys.exit(f"FAIL: seed {seed} of {'/'.join(k)} appears in "
                             "two splits — pooling would double-weight that "
                             "realisation. Fix the dispatch plan.")
                per_run[k][seed] = row

    out_rows = []
    pooled_runs = []
    for k in sorted(agg, key=lambda k: (k[0], k[1], fnum(k[2]) or 0, k[3])):
        splits = agg[k]
        runs_per_split = [int(float(s.get("runs") or 0)) for s in splits]
        total = sum(runs_per_split)
        seeds = per_run.get(k, {})
        if len(seeds) != total:
            sys.exit(f"FAIL: {'/'.join(k)}: {total} runs claimed by the "
                     f"aggregates but {len(seeds)} sibling rows — a split is "
                     "truncated or mismatched")
        for c in CONTEXT:
            vals = {s.get(c, "") for s in splits}
            if len(vals) > 1:
                sys.exit(f"FAIL: {'/'.join(k)}: context column {c} differs "
                         f"across splits ({sorted(vals)}) — not the same "
                         "point")
        out = dict(splits[0])
        out["runs"] = str(total)
        if "run_first" in out:
            out["run_first"] = str(min(
                int(float(s.get("run_first") or 1)) for s in splits))
        for col, src in EXACT.items():
            vals = [v for v in (fnum(r.get(src)) for r in seeds.values())
                    if v is not None and v >= 0]
            if vals and col in out:
                out[col] = f"{sum(vals) / len(vals):.4f}"
        for col, src in SD_OF.items():
            vals = [v for v in (fnum(r.get(src)) for r in seeds.values())
                    if v is not None and v >= 0]
            if vals and col in out:
                out[col] = f"{stats_util.sample_sd(vals):.4f}"
        # runs-weighted mean for every other numeric column
        for col in (header or []):
            if col in EXACT or col in SD_OF or col == "runs" \
                    or col == "run_first" or col in CONTEXT \
                    or col in ("kind", "group", "x", "protocol"):
                continue
            pairs = [(fnum(s.get(col)), n)
                     for s, n in zip(splits, runs_per_split)]
            if any(v is None for v, _ in pairs):
                continue  # blank/sentinel in any split -> keep first as-is
            out[col] = f"{sum(v * n for v, n in pairs) / total:.4f}"
        out_rows.append(out)
        pooled_runs.extend(seeds[s] for s in sorted(seeds))

    with open(args.out, "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=header)
        w.writeheader()
        w.writerows(out_rows)
    sib_out = args.out.removesuffix(".csv") + "-runs.csv"
    with open(sib_out, "w", newline="") as fh:
        w = csv.DictWriter(fh, fieldnames=run_header)
        w.writeheader()
        w.writerows(pooled_runs)
    print(f"pooled {len(args.files)} split(s) -> {args.out} "
          f"({len(out_rows)} row(s)) + {sib_out} ({len(pooled_runs)} run "
          f"row(s))")


if __name__ == "__main__":
    main()
