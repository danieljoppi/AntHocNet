#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
"""The v2.5.0 comparator readings (#563), as docs/benchmarks/v2.5.0-comparators.md
pre-registered them.

Anchors: ara and qrouting against their papers' reference protocol, in the
same file (the same seeds, one process per seed): ara vs aodv per pause,
qrouting vs oracle per load. Termite's own evaluation (Roth 2005, section
4.4) has no reference protocol; its anchor is a trend across speed cells:
goodput falls and the delivered data paths lengthen from 1 to 20 m/s, read as
the difference of the two cells' means with a Welch 95 % CI.

Family comparison: the arms ran alone on the v2.4.0 control's command lines
and seeds; their rows are paired by seed with the committed v2.4.0 rows of
AntHocNet, the cell's oracle and its best native baseline (native_view.py's
choice). Every comparison is bench_parse.paired_stats (t-CI for PDR and NRL,
bootstrap for delay99), read as "arm minus reference".

    comparator_view.py [--gen v250c] [--control v240] [--dir results/cells]
"""

import argparse
import math
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)

import native_view as nv

bp = nv.bp
su = nv._load("stats_util")
ROUTE = re.compile(r"^##ROUTE##\s+(\d+)\s+([A-Za-z][\w-]*)\s+(.+)$")

ARMS = ["ara", "termite", "qrouting"]
ANCHORS = [
    ("ara", "aodv", [f"anchor-ara-p{p}" for p in (0, 30, 120, 600)]),
    ("qrouting", "oracle", ["anchor-qrouting-low", "anchor-qrouting-high"]),
]


def load(path):
    if not os.path.exists(path):
        return {}
    with open(path) as f:
        return bp.parse_runs(f.read())


TERMITE_TREND = ("anchor-termite-s1", "anchor-termite-s20")


def hops(text, proto):
    """{seed: mean hops of delivered data} from the ##ROUTE## rows (last field)."""
    out = {}
    for line in text.splitlines():
        m = ROUTE.match(line)
        if m and m.group(2) == proto:
            out[int(m.group(1))] = float(m.group(3).split()[-1])
    return out


def welch(a, b):
    """(mean(b) - mean(a), lo, hi): Welch 95 % CI of the difference of means."""
    ma, mb = sum(a) / len(a), sum(b) / len(b)
    va, vb = su.sample_sd(a) ** 2 / len(a), su.sample_sd(b) ** 2 / len(b)
    se = math.sqrt(va + vb)
    if se == 0:
        return mb - ma, mb - ma, mb - ma
    df = (va + vb) ** 2 / (va ** 2 / (len(a) - 1) + vb ** 2 / (len(b) - 1))
    h = su.t975(max(1, int(df))) * se
    return mb - ma, mb - ma - h, mb - ma + h


def termite_trend(gen, d):
    """[(metric, value at s1, value at s20, (diff, lo, hi))], or [] without both cells."""
    texts = []
    for cell in TERMITE_TREND:
        path = os.path.join(d, f"{cell}-{gen}.txt")
        if not os.path.exists(path):
            return []
        with open(path) as f:
            texts.append(f.read())
    pdr = [[r["pdr"] for r in bp.parse_runs(t).get("termite", {}).values()] for t in texts]
    hop = [list(hops(t, "termite").values()) for t in texts]
    out = []
    for name, (a, b) in (("pdr", pdr), ("data hops", hop)):
        if len(a) > 1 and len(b) > 1:
            out.append((name, sum(a) / len(a), sum(b) / len(b), welch(a, b)))
    return out


def compare(arm_runs, ref_runs):
    """{metric: (mean, lo, hi)} and the verdict, arm minus reference, paired by seed."""
    _, st, verdict = bp.paired_stats(ref_runs, arm_runs)
    return st, verdict


def fmt(st, m):
    if m not in st:
        return "—"
    d, lo, hi = st[m][:3]
    return f"{d:+.2f} [{lo:+.2f}, {hi:+.2f}]"


def anchor_rows(gen, d):
    rows = []
    for arm, ref, cells in ANCHORS:
        for cell in cells:
            runs = load(os.path.join(d, f"{cell}-{gen}.txt"))
            if arm not in runs or ref not in runs:
                continue
            st, v = compare(runs[arm], runs[ref])
            rows.append((cell, arm, ref, len(runs[arm]), nv.mean(runs[arm], "pdr"),
                         nv.mean(runs[ref], "pdr"), st, v))
    return rows


def family_rows(gen, control, d):
    rows = []
    for family, cells, natives in nv.FAMILIES:
        for cell in cells:
            arms = load(os.path.join(d, f"{cell}-{gen}.txt"))
            if not arms:
                continue
            ctrl = nv.load_cell(cell, control, d)
            refs = [("anthocnet", "anthocnet"), ("oracle", "oracle")]
            best = nv.best_native(ctrl, natives)
            if best:
                refs.append(("best native", best))
            for arm in ARMS:
                if arm not in arms:
                    continue
                for label, ref in refs:
                    if ref not in ctrl:
                        continue
                    st, v = compare(arms[arm], ctrl[ref])
                    rows.append((family, cell, arm, f"{label} ({ref})" if label != ref else ref,
                                 nv.mean(arms[arm], "pdr"), nv.mean(ctrl[ref], "pdr"), st, v))
    return rows


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    ap.add_argument("--gen", default="v250c")
    ap.add_argument("--control", default="v240")
    ap.add_argument("--dir", default=os.path.join(HERE, "..", "..", "results", "cells"))
    a = ap.parse_args()
    print("## Anchors\n")
    print("| cell | arm | reference | n | arm PDR % | ref PDR % | dPDR (pp) "
          "| d delay99 (ms) | d NRL | verdict |")
    print("|---|---|---|---|---|---|---|---|---|---|")
    for cell, arm, ref, n, pa, pr, st, v in anchor_rows(a.gen, a.dir):
        print(f"| {cell} | {arm} | {ref} | {n} | {pa:.2f} | {pr:.2f} | {fmt(st, 'pdr')} "
              f"| {fmt(st, 'delay99')} | {fmt(st, 'nrl')} | {v} |")
    print("\n## Termite trend (1 -> 20 m/s)\n")
    print("| metric | 1 m/s | 20 m/s | difference (Welch 95 % CI) |")
    print("|---|---|---|---|")
    for name, a1, a20, (dd, lo, hi) in termite_trend(a.gen, a.dir):
        print(f"| {name} | {a1:.2f} | {a20:.2f} | {dd:+.2f} [{lo:+.2f}, {hi:+.2f}] |")
    print("\n## Family comparison\n")
    print("| family | cell | arm | reference | arm PDR % | ref PDR % | dPDR (pp) "
          "| d delay99 (ms) | d NRL | verdict |")
    print("|---|---|---|---|---|---|---|---|---|---|")
    for family, cell, arm, ref, pa, pr, st, v in family_rows(a.gen, a.control, a.dir):
        print(f"| {family} | {cell} | {arm} | {ref} | {pa:.2f} | {pr:.2f} | {fmt(st, 'pdr')} "
              f"| {fmt(st, 'delay99')} | {fmt(st, 'nrl')} | {v} |")
    return 0


if __name__ == "__main__":
    sys.exit(main())
