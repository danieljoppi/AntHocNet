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
    # series[proto][metric] -> list of (x, value, stddev) sorted by x; stddev
    # comes from the matching *_sd column (#28 dispersion) when present.
    sd_col = {"pdr_pct": "pdr_sd", "delay_ms": "delay_sd",
              "delay99_ms": "delay99_sd", "nrl": "nrl_sd"}
    series = defaultdict(lambda: defaultdict(list))
    for r in rows:
        x = fnum(r["x"])
        if x is None:
            continue
        for m in ("pdr_pct", "delay_ms", "delay99_ms", "nrl"):
            v = fnum(r.get(m))
            if v is not None:
                series[r["protocol"]][m].append((x, v, fnum(r.get(sd_col[m]))))
    for p in series:
        for m in series[p]:
            series[p][m].sort()

    def draw(ax, pts, color, label, marker="o", linestyle="-"):
        xs = [x for x, _, _ in pts]
        ys = [y for _, y, _ in pts]
        errs = [e for _, _, e in pts]
        yerr = errs if any(e is not None and e > 0 for e in errs) else None
        if yerr is not None:
            yerr = [e if e is not None else 0.0 for e in errs]
        ax.errorbar(xs, ys, yerr=yerr, marker=marker, linestyle=linestyle,
                    color=color, label=label, capsize=3, elinewidth=0.8)

    fig, (ax1, ax2, ax3) = plt.subplots(1, 3, figsize=(15, 4.2))
    fig.suptitle(f"Sweep: {name}", fontsize=13, fontweight="bold")

    for p in protos:
        c = PROTO_COLOR.get(p, None)
        pdr = series[p]["pdr_pct"]
        if pdr:
            draw(ax1, pdr, c, p)
        d = series[p]["delay_ms"]
        if d:
            draw(ax2, d, c, p)
        d99 = series[p]["delay99_ms"]
        if d99:
            draw(ax2, d99, c, f"{p} 99%", marker="^", linestyle="--")
        nrl = series[p]["nrl"]
        if nrl:
            draw(ax3, nrl, c, p)

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
    # value[(scenario, proto)][metric]; *_sd columns feed bar error bars (#28).
    sd_col = {"pdr_pct": "pdr_sd", "delay_ms": "delay_sd", "nrl": "nrl_sd"}
    val = defaultdict(dict)
    err = defaultdict(dict)
    for r in rows:
        for m in ("pdr_pct", "delay_ms", "nrl"):
            v = fnum(r.get(m))
            if v is not None:
                val[(r["scenario"], r["protocol"])][m] = v
            e = fnum(r.get(sd_col[m]))
            if e is not None:
                err[(r["scenario"], r["protocol"])][m] = e

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
            es = [err.get((s, p), {}).get(m, 0.0) for s in scenarios]
            offs = [x + (i - (n - 1) / 2) * width for x in xs]
            ax.bar(offs, ys, width=width, color=PROTO_COLOR.get(p), label=p,
                   yerr=es if any(e > 0 for e in es) else None, capsize=2)
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
