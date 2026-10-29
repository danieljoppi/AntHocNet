#!/usr/bin/env python3
# SPDX-License-Identifier: MIT OR GPL-2.0-only
"""Core speed benchmarks (#620): compare, record and chart `bench_core --csv`.

  core_bench.py compare --base B.csv... --head H.csv...   PR check: markdown
      table on stdout, a ::warning:: per case slower by more than --threshold (25 %).
      Several CSVs per side are runs interleaved on one runner; each side's
      per-case number is the lowest median, the least noise-inflated one.
      Never fails the job: shared runners are noisy, so this warns.
  core_bench.py record RUN.csv --commit SHA --date YYYY-MM-DD --cpu MODEL
      append the run to results/core-bench/history.csv (main only).
  core_bench.py chart  draw docs/benchmarks/charts/core-speed.png from history.
"""
import argparse
import csv
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
HISTORY = os.path.join(ROOT, "results", "core-bench", "history.csv")
CHART = os.path.join(ROOT, "docs", "benchmarks", "charts", "core-speed.png")
FIELDS = ["date", "commit", "cpu", "case", "ns_per_op", "min_ns", "max_ns"]


def read_run(path):
    with open(path, newline="") as f:
        return {r["case"]: float(r["ns_per_op"]) for r in csv.DictReader(f)}


def best(paths):
    out = {}
    for p in paths:
        for case, ns in read_run(p).items():
            out[case] = min(ns, out.get(case, ns))
    return out


def compare(args):
    base, head = best(args.base), best(args.head)
    print("| case | base ns/op | PR ns/op | change |")
    print("|---|---:|---:|---:|")
    slow = []
    for case in head:
        if case not in base:
            print(f"| `{case}` | (new) | {head[case]:.1f} | |")
            continue
        d = head[case] / base[case] - 1
        flag = " ⚠" if d > args.threshold else ""
        print(f"| `{case}` | {base[case]:.1f} | {head[case]:.1f} | {d:+.1%}{flag} |")
        if d > args.threshold:
            slow.append((case, d))
    for case in base:
        if case not in head:
            print(f"| `{case}` | {base[case]:.1f} | (removed) | |")
    print()
    print(f"Lowest median of the interleaved runs per side; ⚠ marks a case more than "
          f"{args.threshold:.0%} slower. Shared runners are noisy: this warns, never fails.")
    for case, d in slow:
        print(f"::warning title=core speed::{case} is {d:+.1%} slower than the base "
              f"branch (threshold {args.threshold:.0%})", file=sys.stderr)


def record(args):
    new = not os.path.exists(HISTORY)
    os.makedirs(os.path.dirname(HISTORY), exist_ok=True)
    with open(args.run, newline="") as f, open(HISTORY, "a", newline="") as out:
        w = csv.DictWriter(out, fieldnames=FIELDS, lineterminator="\n")
        if new:
            w.writeheader()
        for r in csv.DictReader(f):
            w.writerow({"date": args.date, "commit": args.commit[:12], "cpu": args.cpu,
                        "case": r["case"], "ns_per_op": r["ns_per_op"],
                        "min_ns": r["min_ns"], "max_ns": r["max_ns"]})


def chart(args):
    import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt

    with open(HISTORY, newline="") as f:
        rows = list(csv.DictReader(f))
    commits = list(dict.fromkeys(r["commit"] for r in rows))
    cases = list(dict.fromkeys(r["case"] for r in rows))
    x = {c: i for i, c in enumerate(commits)}
    fig, ax = plt.subplots(figsize=(9, 4.8), dpi=120)
    for case in cases:
        pts = [(x[r["commit"]], float(r["ns_per_op"])) for r in rows if r["case"] == case]
        ax.plot([p[0] for p in pts], [p[1] for p in pts], marker="o", ms=3, lw=1.4, label=case)
    # The numbers only compare within one CPU model, and GitHub-hosted
    # runners change model without notice: mark every change.
    cpu = {r["commit"]: r["cpu"] for r in rows}
    for i in range(1, len(commits)):
        if cpu[commits[i]] != cpu[commits[i - 1]]:
            ax.axvline(i - 0.5, color="0.6", ls="--", lw=0.8)
    ax.set_yscale("log")
    ax.set_ylabel("ns per operation (log scale)")
    ax.set_xlabel("merge to main, oldest to newest")
    step = max(1, len(commits) // 12)
    ax.set_xticks(range(0, len(commits), step))
    ax.set_xticklabels([commits[i][:7] for i in range(0, len(commits), step)],
                       rotation=45, ha="right", fontsize=8)
    ax.grid(True, which="major", alpha=0.3)
    ax.set_title("AntHocNet core: cost per operation on each merge (GitHub-hosted runner)")
    ax.legend(fontsize=8, ncol=2, frameon=False)
    fig.tight_layout()
    os.makedirs(os.path.dirname(args.out), exist_ok=True)
    fig.savefig(args.out)


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = ap.add_subparsers(dest="cmd", required=True)
    c = sub.add_parser("compare")
    c.add_argument("--base", nargs="+", required=True)
    c.add_argument("--head", nargs="+", required=True)
    c.add_argument("--threshold", type=float, default=0.25)
    r = sub.add_parser("record")
    r.add_argument("run")
    r.add_argument("--commit", required=True)
    r.add_argument("--date", required=True)
    r.add_argument("--cpu", required=True)
    ch = sub.add_parser("chart")
    ch.add_argument("--out", default=CHART, help="where to write the PNG (make reproduce, #621)")
    args = ap.parse_args()
    {"compare": compare, "record": record, "chart": chart}[args.cmd](args)


if __name__ == "__main__":
    main()
