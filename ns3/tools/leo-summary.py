#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
"""
leo-summary.py [--cells docs/benchmarks/cells] CELL...

Summarise the moving-constellation campaign (#297) from the committed
leo-walker cells (docs/benchmarks/cells/leo-<cell>-<arm>.txt, one arm per
file, 20 seeds each) as the Markdown tables the results page carries. Stdlib
plus the benchmark-results skill's stats_util, so the numbers on the page are
recomputed by anyone with python3 and never typed by hand.

Per cell it prints:
  * headline: PDR / mean delay (t-CI) / delay99 (bootstrap CI) / NRL per arm,
    and the share of send attempts refused at the source;
  * paired AntHocNet - arm per-seed differences (t-CI + Wilcoxon p), the
    oracles excluded -- they are bounds, not competitors;
  * the handover metric family from the # outage / # handover / # account
    lines: outages and packets lost per class, packets lost per scheduled
    handover, and the median of the per-seed median outage duration;
  * route churn from the # churn lines: hop-count changes per flow per
    minute, and mean hop count.

Usage:
  python3 ns3/tools/leo-summary.py walker16 starlink1 starlink1-storm
"""
import argparse
import importlib.util
import math
import os
import re
import statistics
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
ARMS = ["anthocnet", "aodv", "olsr", "geo-greedy", "oracle", "oracle-delay"]
BOUNDS = {"oracle", "oracle-delay"}
CLASSES = ["startup", "scheduled", "unplanned", "massfail", "other"]


def _load_stats_util():
    path = os.path.join(ROOT, ".claude", "skills", "benchmark-results", "stats_util.py")
    spec = importlib.util.spec_from_file_location("stats_util", path)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


su = _load_stats_util()

RUN = re.compile(r"^##RUN##\s+(\d+)\s+(\S+)\s+" + r"\s+".join([r"([-\d.]+)"] * 7))
KV = re.compile(r"(\w+)=(\S+)")


def parse(path):
    """One arm's cell: per-seed rows, accounts, outages, handovers, churn."""
    runs, acct, outage, ho, churn = {}, {}, {}, {}, []
    with open(path) as fh:
        lines = fh.readlines()
    for line in lines:
        m = RUN.match(line)
        if m:
            v = [float(x) for x in m.groups()[2:]]
            runs[int(m.group(1))] = dict(zip(
                ["pdr", "delay", "delay99", "thrput", "nrl", "nrlbytes", "jitter"], v))
            continue
        parts = line.split()
        if len(parts) < 3 or parts[0] != "#":
            continue
        kind, kv = parts[1], dict(KV.findall(line))
        if "seed" not in kv:
            continue
        seed = int(kv["seed"])
        if kind == "account":
            a = acct.setdefault(seed, {"offered": 0, "refused": 0, "delivered": 0})
            for k in a:
                a[k] += int(kv[k])
        elif kind == "outage":
            outage.setdefault(seed, {})[kv["class"]] = kv
        elif kind == "handover":
            ho[seed] = {k: int(kv[k]) for k in ("scheduled", "forced", "islFailures")}
        elif kind == "churn":
            churn.append((float(kv["hopChangesPerMin"]), float(kv["meanHops"]),
                          int(kv["delivered"])))
    return {"runs": runs, "acct": acct, "outage": outage, "ho": ho, "churn": churn}


def ci(xs):
    mean, half = su.t_ci(xs)
    return f"{mean:.2f} ± {half:.2f}"


def fnum(s):
    try:
        v = float(s)
        return None if math.isnan(v) else v
    except ValueError:
        return None


def cell_tables(cell, cells_dir):
    data = {}
    for arm in ARMS:
        path = os.path.join(cells_dir, f"leo-{cell}-{arm}.txt")
        if os.path.exists(path):
            data[arm] = parse(path)
    if not data:
        print(f"no cells for {cell} under {cells_dir}", file=sys.stderr)
        return
    out = [f"### `{cell}`\n"]

    out.append("| arm | seeds | PDR % | mean delay (ms) | delay99 (ms, boot) | NRL | refused at source % |")
    out.append("|---|---|---|---|---|---|---|")
    for arm, d in data.items():
        seeds = sorted(d["runs"])
        col = {k: [d["runs"][s][k] for s in seeds] for k in ("pdr", "delay", "delay99", "nrl")}
        lo, hi = su.bootstrap_ci_mean(col["delay99"])
        off = sum(a["offered"] for a in d["acct"].values())
        ref = sum(a["refused"] for a in d["acct"].values())
        name = f"*{arm}* (bound)" if arm in BOUNDS else arm
        out.append(f"| {name} | {len(seeds)} | {ci(col['pdr'])} | {ci(col['delay'])} | "
                   f"{statistics.mean(col['delay99']):.1f} [{lo:.1f}, {hi:.1f}] | "
                   f"{ci(col['nrl'])} | {100.0 * ref / off if off else 0:.2f} |")
    out.append("")

    if "anthocnet" in data:
        base = data["anthocnet"]["runs"]
        rows = []
        for arm, d in data.items():
            if arm == "anthocnet" or arm in BOUNDS:
                continue
            seeds = sorted(set(base) & set(d["runs"]))
            if len(seeds) < 2:
                continue
            cells = []
            for k in ("pdr", "delay"):
                diffs = [base[s][k] - d["runs"][s][k] for s in seeds]
                mean, half = su.t_ci(diffs)
                p = su.wilcoxon(diffs)[2]
                pp = "n/a" if p is None else f"{p:.2g}"
                cells.append(f"{mean:+.2f} [{mean - half:+.2f}, {mean + half:+.2f}], p={pp}")
            rows.append(f"| {arm} | {len(seeds)} | {cells[0]} | {cells[1]} |")
        if rows:
            out.append("AntHocNet − arm, paired per seed (95 % t-CI, Wilcoxon p):\n")
            out.append("| vs | n | Δ PDR (pp) | Δ mean delay (ms) |")
            out.append("|---|---|---|---|")
            out.extend(rows)
            out.append("")

    out.append("Handover metric family (sums over seeds; outage = ≥ 3 consecutive lost "
               "send attempts):\n")
    out.append("| arm | " + " | ".join(f"{c} n / lost" for c in CLASSES)
               + " | lost per scheduled handover | median outage, scheduled (s) "
               "| median outage, unplanned (s) |")
    out.append("|---|" + "---|" * (len(CLASSES) + 3))
    for arm, d in data.items():
        tot = {c: [0, 0] for c in CLASSES}
        p50 = {c: [] for c in CLASSES}
        for per in d["outage"].values():
            for c, kv in per.items():
                if c not in tot:
                    continue
                tot[c][0] += int(kv["n"])
                tot[c][1] += int(kv["lost"])
                v = fnum(kv["p50"])
                if v is not None:
                    p50[c].append(v)
        sched_ho = sum(h["scheduled"] for h in d["ho"].values())
        per_ho = f"{tot['scheduled'][1] / sched_ho:.2f}" if sched_ho else "—"
        med = {c: (f"{statistics.median(p50[c]):.2f}" if p50[c] else "—")
               for c in ("scheduled", "unplanned")}
        out.append(f"| {arm} | " + " | ".join(f"{tot[c][0]} / {tot[c][1]}" for c in CLASSES)
                   + f" | {per_ho} | {med['scheduled']} | {med['unplanned']} |")
    out.append("")

    out.append("| arm | hop changes / flow / min | mean hops (delivered) |")
    out.append("|---|---|---|")
    for arm, d in data.items():
        live = [c for c in d["churn"] if c[2] > 0]
        if not live:
            out.append(f"| {arm} | — | — |")
            continue
        out.append(f"| {arm} | {statistics.mean(c[0] for c in live):.2f} | "
                   f"{statistics.mean(c[1] for c in live):.2f} |")
    out.append("")
    print("\n".join(out))


def main():
    ap = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    ap.add_argument("--cells", default=os.path.join(ROOT, "docs", "benchmarks", "cells"))
    ap.add_argument("cell", nargs="+")
    a = ap.parse_args()
    for cell in a.cell:
        cell_tables(cell, a.cells)


if __name__ == "__main__":
    main()
