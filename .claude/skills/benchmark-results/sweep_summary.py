#!/usr/bin/env python3
"""Validate + summarize classified campaign CSVs (run-scenarios.py schema).

The scenario-matrix / campaign CSVs (docs/benchmarks/campaign/*.csv, or a
fresh `run-scenarios.py --out` file) are hundreds of cells wide; never load
them into LLM context to compare by eye. This script does the schema check,
the per-point AntHocNet-vs-baseline deltas, the stddev-aware noise call, and
prints a compact grid — the only thing that should reach context.

Usage:
    sweep_summary.py FILE [FILE ...]              # summarize, anthocnet vs aodv
    sweep_summary.py --baseline olsr FILE         # different baseline
    sweep_summary.py --group area FILE            # one sweep/scenario group only
    sweep_summary.py --vs BEFORE.csv AFTER.csv    # same sweep, two code
                                                  #   generations (a default
                                                  #   change): after vs before
    sweep_summary.py --export-sweeps out.csv F..  # emit the papers-repo
                                                  #   sweeps.csv schema
                                                  #   (sweep,x,proto,pdr,
                                                  #    delay_ms,delay99_ms)

Verdict per point (same materiality thresholds as bench_parse.py): PDR ±1pp,
delay99 ±10%, NRL ±10%; a material PDR delta inside 2·RSS(pdr_sd) is tagged
`~sd` (within run-to-run dispersion — treat as noise, bump --runs).

The PDR columns carry a `±95` neighbour (#293): the 95% CI half-width from
the CSV's `pdr_sd`/`runs` aggregate columns (t-distribution, n-1 df), blank
for pre-#28 CSVs or runs<2. Per-run bootstrap intervals for tail metrics need
##RUN## rows and live in bench_parse.py.

`--vs` answers "what did this code change do to the sweep?" rather than "how
does AntHocNet compare to AODV?" — the loop needed after #88 (T_hop) and #169
(reactiveMaxBroadcasts) invalidated every published number. It also prints a
**control**: the baseline protocols are untouched code on identical seeds, so
their numbers must be byte-identical across the two generations. If they moved,
the harness moved too and the AntHocNet delta is not attributable to the code
change (a #51-class finding).
"""
import argparse
import csv
import math
import sys

import stats_util

REQUIRED = ["kind", "group", "x", "protocol", "runs",
            "pdr_pct", "delay_ms", "delay99_ms", "nrl"]


def pdr_hw(row):
    """95% CI half-width for a row's PDR from pdr_sd/runs (t, n-1 df; #293).

    Blank string when the CSV predates #28 stddev columns or runs < 2.
    Campaign CSVs carry aggregates only (mean + sd), so this is a t-CI;
    per-run bootstrap intervals for tail metrics need ##RUN## rows and live
    in bench_parse.py.
    """
    sd, runs = f(row, "pdr_sd"), f(row, "runs")
    if sd is None or runs is None or runs < 2:
        return ""
    return f"{stats_util.t_halfwidth(sd, int(runs)):.1f}"


def load(path):
    with open(path, newline="") as fh:
        rows = list(csv.DictReader(fh))
    if not rows:
        sys.exit(f"FAIL {path}: empty CSV")
    missing = [c for c in REQUIRED if c not in rows[0]]
    if missing:
        sys.exit(f"FAIL {path}: missing columns {missing} — not a "
                 f"run-scenarios.py classified CSV")
    return rows


def f(row, col, default=None):
    v = row.get(col, "")
    try:
        return float(v)
    except (TypeError, ValueError):
        return default


def key(row):
    return (row["kind"], row["group"], f(row, "x", 0.0))


def verdict(a, b):
    """AntHocNet row a vs baseline row b -> (tag, dPDR, d99%, dNRL%)."""
    dp = f(a, "pdr_pct", 0) - f(b, "pdr_pct", 0)
    d99 = ((f(a, "delay99_ms", 0) - f(b, "delay99_ms", 0))
           / f(b, "delay99_ms", 1) * 100 if f(b, "delay99_ms") else 0.0)
    dn = ((f(a, "nrl", 0) - f(b, "nrl", 0))
          / f(b, "nrl", 1) * 100 if f(b, "nrl") else 0.0)
    sig = []
    if abs(dp) >= 1.0:  sig.append(1 if dp > 0 else -1)
    if abs(d99) >= 10:  sig.append(1 if d99 < 0 else -1)
    if abs(dn) >= 10:   sig.append(1 if dn < 0 else -1)
    if not sig:
        tag = "NOISE"
    elif all(s > 0 for s in sig):
        tag = "BETTER"
    elif all(s < 0 for s in sig):
        tag = "WORSE"
    else:
        tag = "MIXED"
    # stddev gate on the PDR delta: material but within joint dispersion?
    sda, sdb = f(a, "pdr_sd"), f(b, "pdr_sd")
    if abs(dp) >= 1.0 and sda is not None and sdb is not None:
        if abs(dp) < 2 * math.hypot(sda, sdb):
            tag += " ~sd"
    return tag, dp, d99, dn


def collect(paths, group=None):
    """paths -> {(kind, group, x): {protocol: row}}"""
    cells = {}
    for path in paths:
        for row in load(path):
            if group and row["group"] != group:
                continue
            cells.setdefault(key(row), {})[row["protocol"]] = row
    return cells


CONTROL_COLS = ["pdr_pct", "delay_ms", "delay99_ms", "nrl"]


def generation_diff(before, after, proto, baseline):
    """Print after-vs-before for `proto`, plus the untouched-baseline control.

    Returns the exit status: non-zero if the control failed.
    """
    print(f"{'group':<10}{'x':>8}  {'runs':>4}  "
          f"{'after':>6}{'±95':>5}{'before':>7}{'±95':>5}  "
          f"{'dPDR':>7}{'d99%':>8}{'dNRL%':>8}  verdict")
    shared = sorted(k for k in after if k in before)
    for k in shared:
        kind, group, x = k
        a, b = after[k].get(proto), before[k].get(proto)
        if a is None or b is None:
            print(f"{group:<10}{x:>8g}  -- {proto} missing in "
                  f"{'after' if a is None else 'before'}")
            continue
        tag, dp, d99, dn = verdict(a, b)
        print(f"{group:<10}{x:>8g}  {f(a,'runs',0):>4.0f}  "
              f"{f(a,'pdr_pct',0):>6.1f}{pdr_hw(a):>5}"
              f"{f(b,'pdr_pct',0):>7.1f}{pdr_hw(b):>5}  "
              f"{dp:>+7.1f}{d99:>+8.1f}{dn:>+8.1f}  {tag}")

    only_a = len(after) - len(shared)
    only_b = len(before) - len(shared)
    if only_a or only_b:
        print(f"note: {only_a} point(s) only in after, {only_b} only in before "
              f"— compared the {len(shared)} shared point(s)")

    # Control: baselines are untouched code on identical seeds.
    protos = {p for cell in after.values() for p in cell} - {proto}
    moved = []
    for k in shared:
        for p in sorted(protos):
            a, b = after[k].get(p), before[k].get(p)
            if a is None or b is None:
                continue
            for col in CONTROL_COLS:
                va, vb = f(a, col), f(b, col)
                if va is None or vb is None or va == vb:
                    continue
                moved.append((k[1], k[2], p, col, vb, va))
    if not protos:
        print("control: no baseline protocols in these CSVs — not checked")
        return 0
    if not moved:
        print(f"control: {', '.join(sorted(protos))} identical across "
              f"generations on {len(shared)} point(s) x {len(CONTROL_COLS)} "
              f"metrics — delta is attributable to the {proto} change")
        return 0
    print(f"control: FAIL — {len(moved)} baseline metric(s) moved; the "
          f"harness is not held constant, so the {proto} delta is NOT "
          f"attributable to the code change (#51-class). First few:")
    for group, x, p, col, vb, va in moved[:6]:
        print(f"  {group} x={x:g} {p}.{col}: {vb:g} -> {va:g}")
    return 1


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("files", nargs="+")
    ap.add_argument("--baseline", default="aodv")
    ap.add_argument("--proto", default="anthocnet")
    ap.add_argument("--group", help="only this group (e.g. area, pause, scale)")
    ap.add_argument("--vs", metavar="BEFORE", nargs="+",
                    help="compare the same sweep across two code generations: "
                         "these are the BEFORE CSVs, the positional files are "
                         "AFTER. Prints per-point deltas for --proto plus a "
                         "control that the baselines did not move.")
    ap.add_argument("--export-sweeps", metavar="OUT",
                    help="write the papers-repo sweeps.csv schema "
                         "(sweep rows, anthocnet+baseline only)")
    args = ap.parse_args()

    cells = collect(args.files, args.group)   # (kind, group, x) -> {proto: row}
    if not cells:
        sys.exit("FAIL: no rows matched")

    if args.vs:
        before = collect(args.vs, args.group)
        if not before:
            sys.exit("FAIL: no rows matched in the --vs (before) files")
        sys.exit(generation_diff(before, cells, args.proto, args.baseline))

    print(f"{'group':<10}{'x':>8}  {'runs':>4}  "
          f"{'PDR':>6}{'±95':>5}{'vs':>7}{'±95':>5}  "
          f"{'dPDR':>7}{'d99%':>8}{'dNRL%':>8}  verdict")
    for k in sorted(cells):
        kind, group, x = k
        a = cells[k].get(args.proto)
        b = cells[k].get(args.baseline)
        if a is None or b is None:
            have = ",".join(sorted(cells[k]))
            print(f"{group:<10}{x:>8g}  -- missing {args.proto}/"
                  f"{args.baseline} (have: {have})")
            continue
        tag, dp, d99, dn = verdict(a, b)
        print(f"{group:<10}{x:>8g}  {f(a,'runs',0):>4.0f}  "
              f"{f(a,'pdr_pct',0):>6.1f}{pdr_hw(a):>5}"
              f"{f(b,'pdr_pct',0):>7.1f}{pdr_hw(b):>5}  "
              f"{dp:>+7.1f}{d99:>+8.1f}{dn:>+8.1f}  {tag}")

    if args.export_sweeps:
        # #293: the papers schema's optional *_ci columns are 95% CI
        # half-widths (t, n-1 df) from the aggregate *_sd/runs columns —
        # plot_sweeps.py draws them as yerr. Blank for pre-#28 CSVs.
        def hw(row, sd_col):
            sd, runs = f(row, sd_col), f(row, "runs")
            if sd is None or runs is None or runs < 2:
                return ""
            return f"{stats_util.t_halfwidth(sd, int(runs)):.3g}"

        with open(args.export_sweeps, "w", newline="") as fh:
            w = csv.writer(fh)
            w.writerow(["sweep", "x", "proto", "pdr", "delay_ms", "delay99_ms",
                        "pdr_ci", "delay_ci", "delay99_ci"])
            n = 0
            for k in sorted(cells):
                kind, group, x = k
                if kind != "sweep":
                    continue
                for proto in (args.proto, args.baseline):
                    row = cells[k].get(proto)
                    if row is None:
                        continue
                    w.writerow([group, f"{x:g}", proto,
                                row["pdr_pct"], row["delay_ms"],
                                row["delay99_ms"], hw(row, "pdr_sd"),
                                hw(row, "delay_sd"), hw(row, "delay99_sd")])
                    n += 1
        print(f"exported {n} sweep rows -> {args.export_sweeps}")


if __name__ == "__main__":
    main()
