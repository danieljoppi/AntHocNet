#!/usr/bin/env python3
"""Parse anthocnet-compare output and A/B-compare cells with a noise verdict.

Scripts in this environment cannot download CI logs/artifacts (the proxy blocks
the blob hosts), so this does NOT fetch — you hand it the result text (paste the
`get_job_logs` tail into a file, or use the workflow's compact ``##BENCH##``
block). It offloads the parsing, per-metric delta, and noise call that would
otherwise cost reasoning tokens on every A/B.

Usage:
    bench_parse.py FILE [FILE ...]        # each FILE = one run's output
    bench_parse.py --all FILE ...         # show every protocol, not just anthocnet
    ... FILE ...                          # a leading '# <label>' line in a FILE
                                          #   names that cell (else the filename)

With >=2 cells it prints each cell's anthocnet row, then deltas vs the FIRST
cell (the baseline / OFF), with a per-pair verdict:
  IMPROVED / WORSE / NOISE  (NOISE = |dPDR|<1pp and |d_delay|<10% and |d_NRL|<10%).
If an even number of cells is given with --ab, they are read as (off,on) pairs
and a cross-pair inconsistency (deltas disagreeing in sign) is called out as the
signature of run-to-run noise.

If both compared cells carry per-run ``##RUN##`` rows (#128), an additional
"paired dPDR by run" line pairs the runs by number (every protocol/cell sees
the identical RNG realisation per run) and reports the per-seed delta signs —
PAIRED-NOISE when neither direction reaches >2/3 of the runs.
"""
import argparse
import re
import sys

# A results row: "anthocnet   50.2   1108.3   10656.8   2.57   83.30"
# (trailing columns — #57 jitter / offered-load percentiles, possibly "inf" —
# are tolerated and ignored; the first six fields are position-stable).
ROW = re.compile(
    r"^\s*([A-Za-z][\w-]*)\s+"
    r"([-\d.]+)\s+([-\d.]+)\s+([-\d.]+)\s+([-\d.]+)\s+([-\d.]+)(?:\s+\S+)*\s*$"
)
METRICS = ["pdr", "delay", "delay99", "thrput", "nrl"]
# Compact single-line form the workflow can emit: "##BENCH## anthocnet 50.2 ..."
BENCH = re.compile(r"##BENCH##\s+(.+)$")
# Per-run row (#128): "##RUN## <run> <proto> <pdr> ..." — only PDR is needed
# for the paired sign test; later fields (may include "inf") are ignored.
RUN = re.compile(r"##RUN##\s+(\d+)\s+([A-Za-z][\w-]*)\s+([-\d.]+)")


def parse_cell(text):
    """Return {proto: {metric: float}} from one run's output text."""
    rows = {}
    for line in text.splitlines():
        m = BENCH.search(line) or ROW.match(line)
        parts = (m.group(1).split() if m and m.re is BENCH
                 else (m.groups() if m else None))
        if not parts:
            continue
        proto = parts[0]
        if proto.lower() in ("protocol", "pdr"):  # header
            continue
        try:
            vals = [float(x) for x in parts[1:6]]
        except (ValueError, IndexError):
            continue
        if len(vals) == 5:
            rows[proto] = dict(zip(METRICS, vals))
    return rows


def parse_runs(text):
    """Return {proto: {run: pdr}} from a cell's ##RUN## per-seed rows (#128)."""
    runs = {}
    for line in text.splitlines():
        m = RUN.search(line)
        if m:
            runs.setdefault(m.group(2), {})[int(m.group(1))] = float(m.group(3))
    return runs


def paired(base_runs, cur_runs):
    """Paired per-seed dPDR line (#128), or None without common runs.

    Pairs the two cells' ##RUN## PDR values by run number and reports the
    delta signs: sign-consistent when one direction reaches >2/3 of the runs,
    else PAIRED-NOISE (the split-signs signature of run-to-run noise).
    """
    common = sorted(set(base_runs) & set(cur_runs))
    if not common:
        return None
    signs = ["+" if cur_runs[r] > base_runs[r] else
             "-" if cur_runs[r] < base_runs[r] else "0" for r in common]
    pos, neg, n = signs.count("+"), signs.count("-"), len(signs)
    if pos * 3 > n * 2:
        call = f"{pos}/{n} positive (sign-consistent)"
    elif neg * 3 > n * 2:
        call = f"{neg}/{n} negative (sign-consistent)"
    else:
        call = f"{pos}/{n} positive, {neg}/{n} negative -> PAIRED-NOISE"
    return f"paired dPDR by run: {','.join(signs)} -> {call}"


def label_of(path, text):
    for line in text.splitlines():
        s = line.strip()
        if s.startswith("#") and not s.startswith("##"):  # '# label', not '##BENCH##'
            return s.lstrip("# ").strip()[:32]
        if s:
            break
    return path.rsplit("/", 1)[-1]


def fmt(v):
    return f"{v:>9.2f}"


def verdict(base, cur):
    dp = cur["pdr"] - base["pdr"]

    def pct(k):
        return (cur[k] - base[k]) / base[k] * 100 if base.get(k) else 0.0

    dd = pct("delay")
    dd99 = pct("delay99")   # the paper's QoS/jitter metric — often the real signal
    dn = pct("nrl")
    # Per-metric "good" direction, only counted past a materiality threshold:
    # PDR up is good; delay99 and NRL down are good. A flat-PDR run whose tail and
    # overhead both drop is an IMPROVEMENT, not "MIXED" (the A2 hotspot case).
    sig = []
    if abs(dp) >= 1.0:  sig.append(1 if dp > 0 else -1)
    if abs(dd99) >= 10: sig.append(1 if dd99 < 0 else -1)
    if abs(dn) >= 10:   sig.append(1 if dn < 0 else -1)
    if not sig:
        v = "NOISE"
    elif all(s > 0 for s in sig):
        v = "IMPROVED"
    elif all(s < 0 for s in sig):
        v = "WORSE"
    else:
        v = "MIXED"
    return v, dp, dd, dd99, dn


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("files", nargs="+")
    ap.add_argument("--all", action="store_true", help="show every protocol")
    ap.add_argument("--proto", default="anthocnet", help="protocol to compare")
    ap.add_argument("--ab", action="store_true",
                    help="read files as (off,on) pairs; flag cross-pair sign flips")
    args = ap.parse_args()

    cells = []
    for path in args.files:
        with (sys.stdin if path == "-" else open(path)) as fh:
            text = fh.read()
        cells.append((label_of(path, text), parse_cell(text), parse_runs(text)))

    protos = ([args.proto] if not args.all else
              sorted({p for _, r, _ in cells for p in r}))

    hdr = f"{'cell':<28}{'proto':<11}" + "".join(f"{m:>9}" for m in METRICS)
    print(hdr)
    print("-" * len(hdr))
    for lbl, rows, _ in cells:
        for p in protos:
            if p in rows:
                print(f"{lbl:<28}{p:<11}" + "".join(fmt(rows[p][m]) for m in METRICS))

    if len(cells) < 2:
        return
    p = args.proto

    if args.ab:
        # (off, on) pairs: delta is on-vs-off within each pair.
        print("\nA/B deltas (on vs off, anthocnet):")
        signs = []
        for i in range(0, len(cells) - 1, 2):
            off_lbl, off = cells[i][0], cells[i][1].get(p)
            on_lbl, on = cells[i + 1][0], cells[i + 1][1].get(p)
            if not off or not on:
                continue
            v, dp, dd, dd99, dn = verdict(off, on)
            signs.append((dp > 0) - (dp < 0))
            print(f"  {off_lbl} -> {on_lbl:<20} dPDR={dp:+5.1f}pp  "
                  f"d_delay={dd:+6.1f}%  d_d99={dd99:+6.1f}%  d_NRL={dn:+6.1f}%   {v}")
            pline = paired(cells[i][2].get(p, {}), cells[i + 1][2].get(p, {}))
            if pline:
                print(f"    {pline}")
        if len({s for s in signs if s}) > 1:
            print("\n  ! cross-pair PDR deltas disagree in sign -> run-to-run "
                  "NOISE, not a real effect (cf. issue #47). Bump --runs.")
        return

    print(f"\ndeltas vs first cell ({p}):")
    base = cells[0][1].get(p)
    if base:
        for lbl, rows, runs in cells[1:]:
            cur = rows.get(p)
            if not cur:
                continue
            v, dp, dd, dd99, dn = verdict(base, cur)
            print(f"  {lbl:<26} dPDR={dp:+5.1f}pp  d_delay={dd:+6.1f}%  "
                  f"d_d99={dd99:+6.1f}%  d_NRL={dn:+6.1f}%   {v}")
            pline = paired(cells[0][2].get(p, {}), runs.get(p, {}))
            if pline:
                print(f"    {pline}")


if __name__ == "__main__":
    main()
