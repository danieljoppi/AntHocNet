#!/usr/bin/env python3
# SPDX-License-Identifier: MIT OR GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
"""The family-native readings of a control campaign (ADR-0026, #711).

For each cell, two comparisons with no migrated protocol in them, as the
v2.4.0 plan pre-registered (docs/benchmarks/v2.4.0-campaign.md):

1. AntHocNet against the cell's oracle: the family-neutral yardstick.
2. AntHocNet against the cell's best native baseline: the native protocol
   with the highest mean PDR over the seeds, ties broken by lower delay99.

Both are paired per seed with bench_parse.paired_stats (t-CI for PDR and
NRL, bootstrap for delay99, the PAIRED-* verdicts). A LEO shell's protocols
are separate files (one job each); they are read together by shell.

    native_view.py [--gen v240] [--dir results/cells] [--csv OUT]

prints a markdown table, and with --csv writes the per-cell numbers the
cross-family chart (ns3/tools/family-charts.py) draws.
"""

import argparse
import csv
import importlib.util
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)  # bench_parse imports its sibling stats_util


def _load(name):
    spec = importlib.util.spec_from_file_location(name, os.path.join(HERE, name + ".py"))
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


bp = _load("bench_parse")

# (family, cell, native baselines). The sets are ADR-0026's table as the
# v2.4.0 plan runs them; the bound is always "oracle".
FAMILIES = [
    ("MANET grid", [f"grid-{m}-{c}" for m in ("rwp", "ssrwp", "gaussmarkov")
                    for c in ("tworay", "nakagami")], ["aodv", "olsr", "dsdv", "aomdv"]),
    ("static mesh", ["static-mesh"], ["olsr", "hwmp"]),
    ("FANET", ["fanet-main", "fanet-sparse"], ["aodv", "olsr", "gpsr3d"]),
    ("VANET", ["vanet-main", "vanet-sparse"], ["aodv", "gpsr", "gpcr"]),
    ("ISL grid", ["sat-base", "sat-failcell", "sat-corridor", "sat-seam"], []),
    ("LEO", ["leo-walker16", "leo-starlink1", "leo-starlink1-storm"],
     ["opspf", "geo-greedy"]),
    ("disaster", ["disaster-main"], ["aodv", "olsr"]),
    ("SAGIN", ["sagin-walker16", "sagin-starlink1", "sagin-starlink1-storm"],
     ["opspf", "geo-greedy", "gpsr3d"]),
]
LEO_PROTOS = ["anthocnet", "opspf", "geo-greedy", "gpsr3d", "oracle", "oracle-delay"]


def load_cell(cell, gen, d):
    if cell.startswith(("leo-", "sagin-")):
        runs = {}
        for p in LEO_PROTOS:
            path = os.path.join(d, f"{cell}-{p}-{gen}.txt")
            if os.path.exists(path):
                with open(path) as f:
                    runs.update(bp.parse_runs(f.read()))
        return runs
    with open(os.path.join(d, f"{cell}-{gen}.txt")) as f:
        return bp.parse_runs(f.read())


def mean(runs, metric):
    xs = [r[metric] for r in runs.values() if metric in r]
    return sum(xs) / len(xs) if xs else float("nan")


def best_native(runs, natives):
    present = [p for p in natives if p in runs]
    if not present:
        return None
    return max(present, key=lambda p: (mean(runs[p], "pdr"), -mean(runs[p], "delay99")))


def readings(gen, d):
    out = []
    for family, cells, natives in FAMILIES:
        for cell in cells:
            runs = load_cell(cell, gen, d)
            a = runs.get("anthocnet")
            o = runs.get("oracle")
            row = {"family": family, "cell": cell, "n": len(a or {}),
                   "anthocnet_pdr": mean(a, "pdr") if a else None,
                   "oracle_pdr": mean(o, "pdr") if o else None}
            if a and o:
                _, st, _ = bp.paired_stats(o, a)
                row.update(gap=st["pdr"][0], gap_lo=st["pdr"][1], gap_hi=st["pdr"][2])
            b = best_native(runs, natives)
            row["best"] = b
            if b:
                row["best_pdr"] = mean(runs[b], "pdr")
                _, st, v = bp.paired_stats(runs[b], a)
                for m in ("pdr", "delay99", "nrl"):
                    if m in st:
                        row[f"d_{m}"], row[f"d_{m}_lo"], row[f"d_{m}_hi"] = st[m][:3]
                row["verdict"] = v
            out.append(row)
    return out


def fmt_ci(r, k, unit=""):
    if r.get(k) is None:
        return "—"
    return f"{r[k]:+.2f} [{r[k + '_lo']:+.2f}, {r[k + '_hi']:+.2f}]{unit}"


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--gen", default="v240")
    ap.add_argument("--dir", default=os.path.join(HERE, "..", "..", "results", "cells"))
    ap.add_argument("--csv")
    a = ap.parse_args()
    rows = readings(a.gen, a.dir)
    print("| family | cell | AntHocNet PDR % | oracle PDR % | AntHocNet − oracle (pp) "
          "| best native | its PDR % | dPDR (pp) | d delay99 (ms) | d NRL | verdict |")
    print("|---|---|---|---|---|---|---|---|---|---|---|")
    for r in rows:
        print(f"| {r['family']} | {r['cell']} | {r['anthocnet_pdr']:.2f} | "
              f"{r['oracle_pdr']:.2f} | {fmt_ci(r, 'gap')} | {r['best'] or '—'} | "
              + (f"{r['best_pdr']:.2f}" if r["best"] else "—")
              + f" | {fmt_ci(r, 'd_pdr')} | {fmt_ci(r, 'd_delay99')} | {fmt_ci(r, 'd_nrl')} | "
              f"{r.get('verdict', '—')} |")
    if a.csv:
        keys = ["family", "cell", "n", "anthocnet_pdr", "oracle_pdr", "gap", "gap_lo", "gap_hi",
                "best", "best_pdr", "d_pdr", "d_pdr_lo", "d_pdr_hi", "d_delay99",
                "d_delay99_lo", "d_delay99_hi", "d_nrl", "d_nrl_lo", "d_nrl_hi", "verdict"]
        with open(a.csv, "w", newline="") as f:
            w = csv.DictWriter(f, fieldnames=keys, extrasaction="ignore")
            w.writeheader()
            for r in rows:
                w.writerow({k: (f"{v:.4f}" if isinstance(v, float) else v)
                            for k, v in r.items()})
    return 0


if __name__ == "__main__":
    sys.exit(main())
