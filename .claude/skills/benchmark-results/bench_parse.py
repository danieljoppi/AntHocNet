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
"""
import argparse
import re
import sys

# A results row: "anthocnet   50.2   1108.3   10656.8   2.57   83.30"
ROW = re.compile(
    r"^\s*([A-Za-z][\w-]*)\s+"
    r"([-\d.]+)\s+([-\d.]+)\s+([-\d.]+)\s+([-\d.]+)\s+([-\d.]+)\s*$"
)
METRICS = ["pdr", "delay", "delay99", "thrput", "nrl"]
# Compact single-line form the workflow can emit: "##BENCH## anthocnet 50.2 ..."
BENCH = re.compile(r"##BENCH##\s+(.+)$")


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
    dd = (cur["delay"] - base["delay"]) / base["delay"] * 100 if base["delay"] else 0
    dn = (cur["nrl"] - base["nrl"]) / base["nrl"] * 100 if base["nrl"] else 0
    if abs(dp) < 1.0 and abs(dd) < 10 and abs(dn) < 10:
        return "NOISE", dp, dd, dn
    # PDR up and delay/NRL not materially worse -> improvement (and vice versa).
    good = (dp > 0) - (dp < 0)
    return ("IMPROVED" if good > 0 else "WORSE" if good < 0 else "MIXED"), dp, dd, dn


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
        cells.append((label_of(path, text), parse_cell(text)))

    protos = ([args.proto] if not args.all else
              sorted({p for _, r in cells for p in r}))

    hdr = f"{'cell':<28}{'proto':<11}" + "".join(f"{m:>9}" for m in METRICS)
    print(hdr)
    print("-" * len(hdr))
    for lbl, rows in cells:
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
            v, dp, dd, dn = verdict(off, on)
            signs.append((dp > 0) - (dp < 0))
            print(f"  {off_lbl} -> {on_lbl:<20} dPDR={dp:+5.1f}pp  "
                  f"d_delay={dd:+6.1f}%  d_NRL={dn:+6.1f}%   {v}")
        if len({s for s in signs if s}) > 1:
            print("\n  ! cross-pair PDR deltas disagree in sign -> run-to-run "
                  "NOISE, not a real effect (cf. issue #47). Bump --runs.")
        return

    print(f"\ndeltas vs first cell ({p}):")
    base = cells[0][1].get(p)
    if base:
        for lbl, rows in cells[1:]:
            cur = rows.get(p)
            if not cur:
                continue
            v, dp, dd, dn = verdict(base, cur)
            print(f"  {lbl:<26} dPDR={dp:+5.1f}pp  d_delay={dd:+6.1f}%  "
                  f"d_NRL={dn:+6.1f}%   {v}")


if __name__ == "__main__":
    main()
