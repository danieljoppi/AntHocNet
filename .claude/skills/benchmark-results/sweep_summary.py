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
    sweep_summary.py --export-sweeps out.csv F..  # emit the papers-repo
                                                  #   sweeps.csv schema
                                                  #   (sweep,x,proto,pdr,
                                                  #    delay_ms,delay99_ms)

Verdict per point (same materiality thresholds as bench_parse.py): PDR ±1pp,
delay99 ±10%, NRL ±10%; a material PDR delta inside 2·RSS(pdr_sd) is tagged
`~sd` (within run-to-run dispersion — treat as noise, bump --runs).
"""
import argparse
import csv
import math
import sys

REQUIRED = ["kind", "group", "x", "protocol", "runs",
            "pdr_pct", "delay_ms", "delay99_ms", "nrl"]


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


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("files", nargs="+")
    ap.add_argument("--baseline", default="aodv")
    ap.add_argument("--proto", default="anthocnet")
    ap.add_argument("--group", help="only this group (e.g. area, pause, scale)")
    ap.add_argument("--export-sweeps", metavar="OUT",
                    help="write the papers-repo sweeps.csv schema "
                         "(sweep rows, anthocnet+baseline only)")
    args = ap.parse_args()

    cells = {}   # (kind, group, x) -> {protocol: row}
    for path in args.files:
        for row in load(path):
            if args.group and row["group"] != args.group:
                continue
            cells.setdefault(key(row), {})[row["protocol"]] = row
    if not cells:
        sys.exit("FAIL: no rows matched")

    print(f"{'group':<10}{'x':>8}  {'runs':>4}  "
          f"{'PDR':>6}{'vs':>7}  {'dPDR':>7}{'d99%':>8}{'dNRL%':>8}  verdict")
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
              f"{f(a,'pdr_pct',0):>6.1f}{f(b,'pdr_pct',0):>7.1f}  "
              f"{dp:>+7.1f}{d99:>+8.1f}{dn:>+8.1f}  {tag}")

    if args.export_sweeps:
        with open(args.export_sweeps, "w", newline="") as fh:
            w = csv.writer(fh)
            w.writerow(["sweep", "x", "proto", "pdr", "delay_ms", "delay99_ms"])
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
                                row["delay99_ms"]])
                    n += 1
        print(f"exported {n} sweep rows -> {args.export_sweeps}")


if __name__ == "__main__":
    main()
