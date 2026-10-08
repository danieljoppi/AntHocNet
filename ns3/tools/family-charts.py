#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
"""
family-charts.py [--cells docs/benchmarks/cells] [--outdir docs/benchmarks/charts]

Render the family results pages' figures from the committed result cells
(docs/benchmarks/cells/*.txt -- the harness's own text output, ##RUN##
per-seed rows included). Re-plotting never re-runs a simulator, and the
output is deterministic (the bootstrap is seeded by stats_util).

  * family-<name>.png  -- one row per cell of a family page (MANET static
    mesh, FANET, VANET): horizontal bars for PDR | delay99 | NRL, one bar per
    real arm, AntHocNet emphasised. The oracle is a control, not a
    competitor, so it is drawn as a reference line, not a bar.
  * grid.png           -- the MANET grid (3 mobility x 2 channel cells):
    AntHocNet / AODV / OLSR as dots per cell, oracle as a tick.
  * satellite.png      -- the ISL grid's two dynamic cells, per seed:
    corridor probe delay (bimodal -- a mean would hide it) and failcell
    time-to-reconverge on a log axis.
  * families-vs-aodv.png -- the cross-family ranking-stability statement
    as a forest plot: AntHocNet - AODV paired per-seed difference with its
    95 % t-CI, for every family cell.
  * ../sweep-<name>.png -- the area / pause / scale sweep charts, re-rendered
    by make-charts.py from the committed campaign CSVs each sweep page's
    current block cites (SWEEP_SOURCES below).

Every chart here is drawn from data committed in the repository, so the
Charts workflow (.github/workflows/charts.yml) re-runs this on every change
to the cells, the campaign CSVs or the chart code and commits the result.

Error bars are 95 % CIs over seeds (#293): t-intervals for PDR and NRL, a
percentile bootstrap for delay99 (a t-CI on a p99 is not defensible), and
paired per-seed t-intervals for the differences. Which cells feed which
figure is the CELLS / FAMILY_ROWS tables below: when a results page is
re-measured, point them at the new cell and re-run.
"""
import argparse
import importlib.util
import os
import re
import sys

import matplotlib

matplotlib.use("Agg")  # headless: write PNGs, no display
import matplotlib.pyplot as plt
from matplotlib.lines import Line2D

SKILL = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..",
                     ".claude", "skills", "benchmark-results")


def _load(name):
    """Load a skill-side module (single source for parsing and CI math)."""
    sys.path.insert(0, SKILL)  # bench_parse imports stats_util by name
    spec = importlib.util.spec_from_file_location(
        name, os.path.join(SKILL, f"{name}.py"))
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


su = _load("stats_util")
bp = _load("bench_parse")

# Palette: the validated categorical slots (dataviz reference palette; worst
# all-pairs CVD dE 9.2 for the first three) plus neutral context ink. One
# colour per protocol on every figure, make-charts.py included.
SURFACE = "#fcfcfb"
INK = "#0b0b0b"
INK2 = "#52514e"
GRID = "#e4e3df"
CONTEXT = "#b4b2ab"
PROTO_COLOR = {"anthocnet": "#2a78d6", "aodv": "#eb6834", "olsr": "#1baf7a"}
PROTO_MARKER = {"anthocnet": "o", "aodv": "s", "olsr": "D"}
ARMS = ["anthocnet", "aodv", "olsr", "dsdv", "aomdv", "gpsr"]
LABEL = {"anthocnet": "AntHocNet", "aodv": "AODV", "olsr": "OLSR",
         "dsdv": "DSDV", "aomdv": "AOMDV", "gpsr": "GPSR", "oracle": "oracle"}

plt.rcParams.update({
    "figure.facecolor": SURFACE, "axes.facecolor": SURFACE,
    "savefig.facecolor": SURFACE, "font.family": "DejaVu Sans",
    "font.size": 9, "text.color": INK, "axes.labelcolor": INK2,
    "axes.edgecolor": GRID, "axes.linewidth": 1.0,
    "xtick.color": INK2, "ytick.color": INK, "xtick.major.size": 0,
    "ytick.major.size": 0, "axes.titlesize": 10, "axes.titleweight": "bold",
    "axes.titlelocation": "left", "axes.spines.top": False,
    "axes.spines.right": False,
})

# Cells per family page: (row label, cell file). Current = the CBR (#521)
# restatements and the v1.9.0 VANET campaign.
CELLS = {
    "static-mesh": ("Static Wi-Fi mesh (50 nodes, pause = 900 s)",
                    [("static mesh", "static-mesh-cbr521.txt")]),
    "fanet": ("FANET (3-D Gauss-Markov, 30 m/s)",
              [("main (range 350 m)", "fanet-main-cbr521.txt"),
               ("sparse (range 250 m)", "fanet-sparse-cbr521.txt")]),
    "vanet": ("VANET (Manhattan grid, building shadowing)",
              [("main (100 vehicles)", "vanet-main.txt"),
               ("sparse (40 vehicles)", "vanet-sparse.txt")]),
}
GRID_CELLS = [(f"{m} · {c}", f"grid-{m}-{c}-cbr521.txt")
              for m in ("rwp", "ssrwp", "gaussmarkov")
              for c in ("tworay", "nakagami")]
FAMILY_ROWS = ([("MANET", lab, f) for lab, f in GRID_CELLS]
               + [("static mesh", "static mesh", "static-mesh-cbr521.txt"),
                  ("FANET", "main", "fanet-main-cbr521.txt"),
                  ("FANET", "sparse", "fanet-sparse-cbr521.txt"),
                  ("VANET", "main", "vanet-main.txt"),
                  ("VANET", "sparse", "vanet-sparse.txt")])
SAT_CORRIDOR = "sat-corridor-app517.txt"
SAT_FAILCELL = "sat-failcell-app517.txt"

# The CBR (#521) restatement block of each sweep page cites these campaign
# CSVs (docs/benchmarks/sweeps/<name>.md, "Provenance"). When a sweep is
# re-measured, point its entry at the new files.
SWEEP_SOURCES = {
    "area": [f"{r}-run.csv" for r in (37233283127, 37233284897, 37233286413,
                                       37233288164, 37233289720)],
    "pause": [f"{r}-run.csv" for r in (37233291212, 37233292762, 37233294241,
                                        37233296147, 37233298023)],
    "scale": ["37233299992-run.csv"] + [f"pooled-scale-{x}-20261005.csv"
                                        for x in ("1.4", "1.8", "2.0")],
}


def read(cells, name):
    with open(os.path.join(cells, name)) as f:
        return f.read()


def t_ci(xs):
    """(mean, lo, hi) with a 95 % t half-width."""
    m = sum(xs) / len(xs)
    hw = su.t_halfwidth(su.sample_sd(xs), len(xs)) if len(xs) > 1 else 0.0
    return m, m - hw, m + hw


def cell_stats(text):
    """{proto: {metric: (mean, lo, hi)}} from a cell's ##RUN## rows."""
    out = {}
    for proto, by_run in bp.parse_runs(text).items():
        out[proto] = {}
        for metric in ("pdr", "delay99", "nrl"):
            xs = [r[metric] for r in by_run.values() if metric in r]
            if not xs:
                continue
            if metric == "delay99":
                m = sum(xs) / len(xs)
                lo, hi = su.bootstrap_ci_mean(xs)
                out[proto][metric] = (m, lo, hi)
            else:
                out[proto][metric] = t_ci(xs)
    return out


def paired_diff(text, metric, relative=False):
    """AntHocNet - AODV per seed: (mean, lo, hi); relative = % of AODV."""
    runs = bp.parse_runs(text)
    a, b = runs["anthocnet"], runs["aodv"]
    diffs = []
    for seed in sorted(set(a) & set(b)):
        if metric in a[seed] and metric in b[seed]:
            d = a[seed][metric] - b[seed][metric]
            if relative:
                d = 100.0 * d / b[seed][metric]
            diffs.append(d)
    return t_ci(diffs)


def style_axis(ax):
    ax.grid(True, axis="x", color=GRID, linewidth=1.0)
    ax.set_axisbelow(True)
    ax.spines["left"].set_visible(False)


METRICS = [("pdr", "PDR (%)  →  higher is better"),
           ("delay99", "delay99 (ms)  ←  lower is better"),
           ("nrl", "NRL (control tx / delivered)  ←  lower is better")]


def plot_family(name, cells_dir, outdir):
    """Bars per real arm, one row per cell, oracle as a reference line."""
    title, cells = CELLS[name]
    stats = [(label, cell_stats(read(cells_dir, f))) for label, f in cells]
    arms = [a for a in ARMS if any(a in s for _, s in stats)]
    fig, axes = plt.subplots(len(stats), 3, squeeze=False,
                             figsize=(12, 0.42 * len(arms) * len(stats) + 1.6))
    fig.suptitle(f"{title}: mean of 20 seeds, 95 % CI",
                 x=0.01, ha="left", fontsize=12, fontweight="bold")
    for row, (label, st) in enumerate(stats):
        present = [a for a in arms if a in st]
        ys = list(range(len(present)))[::-1]
        for col, (metric, mlabel) in enumerate(METRICS):
            ax = axes[row][col]
            style_axis(ax)
            vmax = 0.0
            for y, arm in zip(ys, present):
                m, lo, hi = st[arm][metric]
                vmax = max(vmax, hi)
                color = PROTO_COLOR["anthocnet"] if arm == "anthocnet" else CONTEXT
                ax.barh(y, m, height=0.62, color=color, linewidth=0)
                ax.plot([lo, hi], [y, y], color=INK2, linewidth=1.0)
                fmt = "{:.1f}" if metric == "pdr" else (
                    "{:.0f}" if metric == "delay99" else "{:.1f}")
                ax.text(hi, y, "  " + fmt.format(m), va="center",
                        ha="left", fontsize=8, color=INK2,
                        fontweight="bold" if arm == "anthocnet" else "normal")
            ora = st.get("oracle", {}).get(metric)
            if ora and metric != "nrl":  # oracle NRL is 0 by construction
                vmax = max(vmax, ora[0])
                ax.axvline(ora[0], color=INK, linewidth=1.0)
                ax.text(ora[0], len(present) - 0.45,
                        f" oracle {ora[0]:.1f}" if metric == "pdr"
                        else f" oracle {ora[0]:.0f}",
                        fontsize=8, color=INK, va="bottom", ha="left")
            ax.set_xlim(0, vmax * 1.22 if metric != "pdr" else
                        min(115, vmax * 1.18))
            ax.set_ylim(-0.6, len(present) - 0.1)
            ax.set_yticks(ys)
            ax.set_yticklabels([LABEL[a] for a in present] if col == 0 else [])
            if col == 0:
                for tick, arm in zip(ax.get_yticklabels(), present):
                    if arm == "anthocnet":
                        tick.set_fontweight("bold")
            if row == 0:
                ax.set_title(mlabel, fontsize=9, color=INK2, fontweight="normal")
            if col == 0 and len(stats) > 1:
                ax.set_ylabel(label, fontsize=9, color=INK, fontweight="bold")
    fig.tight_layout(rect=(0, 0, 1, 0.965 if len(stats) > 1 else 0.93))
    out = os.path.join(outdir, f"family-{name}.png")
    fig.savefig(out, dpi=130)
    plt.close(fig)
    return out


def plot_grid(cells_dir, outdir):
    """MANET grid: AntHocNet / AODV / OLSR dots per cell, oracle tick."""
    stats = [(label, cell_stats(read(cells_dir, f))) for label, f in GRID_CELLS]
    fig, axes = plt.subplots(1, 3, figsize=(12, 3.9), sharey=True)
    fig.suptitle("MANET grid (3 mobility × 2 channel cells, 50 nodes): "
                 "mean of 20 seeds, 95 % CI",
                 x=0.01, ha="left", fontsize=12, fontweight="bold")
    ys = list(range(len(stats)))[::-1]
    offs = {"anthocnet": 0.2, "aodv": 0.0, "olsr": -0.2}
    for ax, (metric, mlabel) in zip(axes, METRICS):
        style_axis(ax)
        ax.set_title(mlabel, fontsize=9, color=INK2, fontweight="normal")
        for y, (_, st) in zip(ys, stats):
            ora = st.get("oracle", {}).get(metric)
            if ora and metric != "nrl":
                ax.plot([ora[0]] * 2, [y - 0.32, y + 0.32], color=INK,
                        linewidth=1.5, solid_capstyle="butt")
            for arm, dy in offs.items():
                m, lo, hi = st[arm][metric]
                ax.plot([lo, hi], [y + dy] * 2, color=PROTO_COLOR[arm],
                        linewidth=1.0)
                ax.plot(m, y + dy, PROTO_MARKER[arm], color=PROTO_COLOR[arm],
                        markersize=6, markeredgecolor=SURFACE,
                        markeredgewidth=1.0)
        for y in ys[:-1]:
            ax.axhline(y - 0.5, color=GRID, linewidth=1.0)
    axes[0].set_yticks(ys)
    axes[0].set_yticklabels([lab for lab, _ in stats])
    axes[0].set_ylim(-0.6, len(stats) - 0.4)
    handles = [Line2D([], [], marker=PROTO_MARKER[a], color=PROTO_COLOR[a],
                      linestyle="", markersize=6, label=LABEL[a])
               for a in offs]
    handles.append(Line2D([], [], marker="|", color=INK, linestyle="",
                          markersize=10, markeredgewidth=1.5,
                          label="oracle (control)"))
    fig.legend(handles=handles, loc="upper left", ncol=4, frameon=False,
               fontsize=9, bbox_to_anchor=(0.005, 0.935))
    fig.tight_layout(rect=(0, 0, 1, 0.87))
    out = os.path.join(outdir, "grid.png")
    fig.savefig(out, dpi=130)
    plt.close(fig)
    return out


def per_seed(text, cell, field):
    """{arm: [value per seed]} from '# <cell> <arm> seed=N ... field=X'."""
    rx = re.compile(rf"^# {cell} (\w+) seed=(\d+) .*\b{field}=([-\d.]+)")
    out = {}
    for line in text.splitlines():
        m = rx.match(line)
        if m:
            out.setdefault(m.group(1), []).append(float(m.group(3)))
    return out


def plot_satellite(cells_dir, outdir):
    """ISL grid dynamic cells, every seed as a dot."""
    corr = per_seed(read(cells_dir, SAT_CORRIDOR), "corridor", "probeDelayMs")
    fail = per_seed(read(cells_dir, SAT_FAILCELL), "failcell", "tReconverge")
    fig, (a1, a2) = plt.subplots(1, 2, figsize=(12, 2.8))
    fig.suptitle("Satellite ISL grid (6 × 6 +grid torus): every seed is a dot",
                 x=0.01, ha="left", fontsize=12, fontweight="bold")
    arms = ["anthocnet", "aodv", "olsr"]
    ys = list(range(len(arms)))[::-1]
    for ax, data, title, unit in (
            (a1, corr, "corridor: probe delay (ms)  ←  lower is better",
             "ms"),
            (a2, fail, ("failcell: time to reconverge (s, log)  ←  lower "
                        "is better"), "s")):
        style_axis(ax)
        ax.set_title(title, fontsize=9, color=INK2, fontweight="normal")
        ora = data.get("oracle", [])
        if ora:
            mean = sum(ora) / len(ora)
            ax.axvline(mean, color=INK, linewidth=1.0)
            ax.text(mean, len(arms) - 0.45,
                    f" oracle {mean:.0f} ms" if unit == "ms"
                    else f" oracle {mean:.3f} s",
                    fontsize=8, color=INK, va="bottom")
        for y, arm in zip(ys, arms):
            vals = sorted(data.get(arm, []))
            # deterministic vertical spread so coincident seeds stay visible
            for i, v in enumerate(vals):
                jitter = ((i * 7) % 11 - 5) * 0.035
                ax.plot(v, y + jitter, PROTO_MARKER[arm],
                        color=PROTO_COLOR[arm], markersize=5.5, alpha=0.85,
                        markeredgecolor=SURFACE, markeredgewidth=0.8)
            if vals:
                m = sum(vals) / len(vals)
                ax.plot([m, m], [y - 0.3, y + 0.3], color=INK2, linewidth=2)
        ax.set_yticks(ys)
        ax.set_yticklabels([LABEL[a] for a in arms])
        ax.set_ylim(-0.6, len(arms) - 0.1)
    a2.set_xscale("log")
    a1.text(0.99, -0.3, "short bar = mean of 20 seeds", transform=a1.transAxes,
            ha="right", fontsize=8, color=INK2)
    fig.tight_layout(rect=(0, 0, 1, 0.91))
    out = os.path.join(outdir, "satellite.png")
    fig.savefig(out, dpi=130)
    plt.close(fig)
    return out


def plot_families(cells_dir, outdir):
    """Forest plot: AntHocNet - AODV, paired per seed, every family cell."""
    rows = []
    for fam, label, f in FAMILY_ROWS:
        text = read(cells_dir, f)
        rows.append((fam, label, {
            "pdr": paired_diff(text, "pdr"),
            "delay99": paired_diff(text, "delay99", relative=True),
            "nrl": paired_diff(text, "nrl"),
        }))
    panels = [("pdr", "PDR (pp)  →  AntHocNet delivers more"),
              ("delay99", "delay99 (% of AODV's)  ←  AntHocNet's tail shorter"),
              ("nrl", "NRL  ←  AntHocNet's overhead lower")]
    fig, axes = plt.subplots(1, 3, figsize=(12, 4.6), sharey=True)
    fig.suptitle("AntHocNet − AODV across four families: paired per-seed "
                 "difference, 95 % CI",
                 x=0.01, ha="left", fontsize=12, fontweight="bold")
    ys = list(range(len(rows)))[::-1]
    color = PROTO_COLOR["anthocnet"]
    for ax, (metric, mlabel) in zip(axes, panels):
        style_axis(ax)
        ax.set_title(mlabel, fontsize=9, color=INK2, fontweight="normal")
        ax.axvline(0, color=INK, linewidth=1.0)
        prev = None
        for y, (fam, _, d) in zip(ys, rows):
            if prev is not None and fam != prev:
                ax.axhline(y + 0.5, color=GRID, linewidth=1.0)
            prev = fam
            m, lo, hi = d[metric]
            sig = lo > 0 or hi < 0
            ax.plot([lo, hi], [y, y], color=color, linewidth=1.5)
            ax.plot(m, y, "o", markersize=7, markeredgewidth=1.5,
                    color=color if sig else SURFACE, markeredgecolor=color)
    axes[0].set_yticks(ys)
    axes[0].set_yticklabels([f"{fam}: {lab}" if lab != fam else fam
                             for fam, lab, _ in rows])
    axes[0].set_ylim(-0.6, len(rows) - 0.4)
    handles = [Line2D([], [], marker="o", color=color, linestyle="",
                      markersize=7, label="CI excludes 0"),
               Line2D([], [], marker="o", color=SURFACE, markeredgecolor=color,
                      markeredgewidth=1.5, linestyle="", markersize=7,
                      label="not significant")]
    fig.legend(handles=handles, loc="upper left", ncol=2, frameon=False,
               fontsize=9, bbox_to_anchor=(0.005, 0.945))
    fig.tight_layout(rect=(0, 0, 1, 0.90))
    out = os.path.join(outdir, "families-vs-aodv.png")
    fig.savefig(out, dpi=130)
    plt.close(fig)
    return out


def plot_sweeps(campaign_dir, outdir):
    """Re-render the sweep charts with make-charts.py's own sweep plot."""
    spec = importlib.util.spec_from_file_location(
        "make_charts", os.path.join(os.path.dirname(os.path.abspath(__file__)),
                                    "make-charts.py"))
    mc = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mc)
    written = []
    for name, files in SWEEP_SOURCES.items():
        rows = []
        for f in files:
            rows += [r for r in mc.load(os.path.join(campaign_dir, f))
                     if r["kind"] == "sweep" and r["group"] == name]
        # make-charts styles its own figures: render them outside this
        # module's rcParams so a sweep looks the same from either script.
        with matplotlib.rc_context():
            matplotlib.rcdefaults()
            written.append(mc.plot_sweep(name, rows, outdir))
    return written


def main():
    root = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..")
    ap = argparse.ArgumentParser(description="Render family results charts.")
    ap.add_argument("--cells", default=os.path.join(root, "docs", "benchmarks",
                                                    "cells"))
    ap.add_argument("--outdir", default=os.path.join(root, "docs", "benchmarks",
                                                     "charts"))
    ap.add_argument("--campaign", default=os.path.join(root, "docs", "benchmarks",
                                                       "campaign"))
    ap.add_argument("--sweep-outdir", default=os.path.join(root, "docs",
                                                           "benchmarks"))
    args = ap.parse_args()
    os.makedirs(args.outdir, exist_ok=True)
    written = [plot_family(n, args.cells, args.outdir) for n in CELLS]
    written.append(plot_grid(args.cells, args.outdir))
    written.append(plot_satellite(args.cells, args.outdir))
    written.append(plot_families(args.cells, args.outdir))
    written += plot_sweeps(args.campaign, args.sweep_outdir)
    for w in written:
        print(os.path.relpath(w))


if __name__ == "__main__":
    main()
