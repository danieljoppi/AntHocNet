#!/usr/bin/env python3
"""
make-charts.py scenarios.csv [--outdir docs/benchmarks]

Render the classified benchmark CSV (from run-scenarios.py) into figures:

  * sweep-<name>.png  -- paper-style LINE charts (one per sweep: area/pause/
    scale). Three panels: delivery ratio | mean+99th delay | NRL, one line per
    protocol. Mirrors the AntHocNet paper's Fig. 1-3 (avg + 99th delay overlaid),
    extended with NRL (the journal overhead trade-off) and all baselines.
  * discrete-summary.png -- grouped BAR chart of the named scenario taxonomy:
    PDR / mean delay / NRL, scenarios on the x-axis, bars per protocol.

Re-plotting reads only the CSV, so it never re-runs ns-3. Deterministic output.
"""
import argparse
import csv
import os
import sys
from collections import defaultdict

import matplotlib
matplotlib.use("Agg")  # headless: write PNGs, no display
import matplotlib.pyplot as plt  # noqa: E402

# Stable protocol order + colours so every figure is consistent.
PROTO_ORDER = ["anthocnet", "aodv", "olsr", "dsdv", "dsr"]
PROTO_COLOR = {
    "anthocnet": "#d62728", "aodv": "#1f77b4", "olsr": "#2ca02c",
    "dsdv": "#ff7f0e", "dsr": "#9467bd",
}


def load(csv_path):
    with open(csv_path, newline="") as f:
        return list(csv.DictReader(f))


def fnum(s):
    try:
        return float(s)
    except (TypeError, ValueError):
        return None


def protos_in(rows):
    seen = [r["protocol"] for r in rows]
    return [p for p in PROTO_ORDER if p in seen]


def plot_sweep(name, rows, outdir):
    """One paper-style line figure for a single sweep group."""
    protos = protos_in(rows)
    xlabel = rows[0].get("class", name) if rows else name
    # series[proto][metric] -> list of (x, value) sorted by x
    series = defaultdict(lambda: defaultdict(list))
    for r in rows:
        x = fnum(r["x"])
        if x is None:
            continue
        for m in ("pdr_pct", "delay_ms", "delay99_ms", "nrl"):
            v = fnum(r.get(m))
            if v is not None:
                series[r["protocol"]][m].append((x, v))
    for p in series:
        for m in series[p]:
            series[p][m].sort()

    fig, (ax1, ax2, ax3) = plt.subplots(1, 3, figsize=(15, 4.2))
    fig.suptitle(f"Sweep: {name}", fontsize=13, fontweight="bold")

    for p in protos:
        c = PROTO_COLOR.get(p, None)
        pdr = series[p]["pdr_pct"]
        if pdr:
            ax1.plot([x for x, _ in pdr], [y for _, y in pdr],
                     marker="o", color=c, label=p)
        d = series[p]["delay_ms"]
        if d:
            ax2.plot([x for x, _ in d], [y for _, y in d],
                     marker="o", color=c, label=p)
        d99 = series[p]["delay99_ms"]
        if d99:
            ax2.plot([x for x, _ in d99], [y for _, y in d99],
                     marker="^", linestyle="--", color=c, label=f"{p} 99%")
        nrl = series[p]["nrl"]
        if nrl:
            ax3.plot([x for x, _ in nrl], [y for _, y in nrl],
                     marker="o", color=c, label=p)

    ax1.set_title("Packet delivery ratio")
    ax1.set_ylabel("PDR (%)")
    ax2.set_title("End-to-end delay (mean + 99th pct)")
    ax2.set_ylabel("delay (ms)")
    ax3.set_title("Normalized routing load")
    ax3.set_ylabel("NRL (control tx / data delivered)")
    for ax in (ax1, ax2, ax3):
        ax.set_xlabel(xlabel)
        ax.grid(True, alpha=0.3)
        ax.legend(fontsize=8)

    fig.tight_layout(rect=(0, 0, 1, 0.95))
    out = os.path.join(outdir, f"sweep-{name}.png")
    fig.savefig(out, dpi=110)
    plt.close(fig)
    return out


def plot_discrete(rows, outdir):
    """Grouped bar chart of the named scenario taxonomy."""
    scenarios = []
    for r in rows:
        if r["scenario"] not in scenarios:
            scenarios.append(r["scenario"])
    protos = protos_in(rows)
    # value[(scenario, proto)][metric]
    val = defaultdict(dict)
    for r in rows:
        for m in ("pdr_pct", "delay_ms", "nrl"):
            v = fnum(r.get(m))
            if v is not None:
                val[(r["scenario"], r["protocol"])][m] = v

    metrics = [("pdr_pct", "PDR (%)"), ("delay_ms", "mean delay (ms)"),
               ("nrl", "NRL")]
    fig, axes = plt.subplots(len(metrics), 1, figsize=(11, 10))
    fig.suptitle("Scenario taxonomy (named scenarios)", fontsize=13, fontweight="bold")

    n = len(protos)
    width = 0.8 / max(1, n)
    xs = list(range(len(scenarios)))
    for ax, (m, label) in zip(axes, metrics):
        for i, p in enumerate(protos):
            ys = [val.get((s, p), {}).get(m, 0.0) for s in scenarios]
            offs = [x + (i - (n - 1) / 2) * width for x in xs]
            ax.bar(offs, ys, width=width, color=PROTO_COLOR.get(p), label=p)
        ax.set_ylabel(label)
        ax.set_xticks(xs)
        ax.set_xticklabels(scenarios, rotation=20, ha="right", fontsize=8)
        ax.grid(True, axis="y", alpha=0.3)
        ax.legend(fontsize=8, ncol=n)

    fig.tight_layout(rect=(0, 0, 1, 0.96))
    out = os.path.join(outdir, "discrete-summary.png")
    fig.savefig(out, dpi=110)
    plt.close(fig)
    return out


def main():
    ap = argparse.ArgumentParser(description="Render benchmark scenario charts.")
    ap.add_argument("csv", help="classified CSV from run-scenarios.py")
    ap.add_argument("--outdir", default="docs/benchmarks", help="where to write PNGs")
    args = ap.parse_args()

    os.makedirs(args.outdir, exist_ok=True)
    rows = load(args.csv)
    if not rows:
        raise SystemExit("no rows in CSV")

    written = []
    discrete = [r for r in rows if r["kind"] == "discrete"]
    if discrete:
        written.append(plot_discrete(discrete, args.outdir))

    by_sweep = defaultdict(list)
    for r in rows:
        if r["kind"] == "sweep":
            by_sweep[r["group"]].append(r)
    for name, srows in by_sweep.items():
        written.append(plot_sweep(name, srows, args.outdir))

    for w in written:
        print(w)


if __name__ == "__main__":
    main()
