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

Statistics (#293): a cell whose ``##RUN##`` per-seed rows are present gets a
"95% CI" line per protocol — t-distribution half-widths for pdr/delay/thrput/
nrl and a percentile-bootstrap interval for delay99 (a t-CI on a p99 is not
defensible). When both compared cells carry ``##RUN##`` rows, the delta line
gains a **paired-difference 95% CI and a Wilcoxon signed-rank p** per metric,
and the paired verdict (CI-excludes-zero significance) REPLACES the
materiality-threshold verdict for that pair — per-seed evidence beats
thresholds. The legacy sign-test line (#128) is kept: sign-consistency is
PAIRED-NOISE when neither direction reaches >2/3 of the runs.

Column-mapping self-check (#293): ``##RUN##`` fields are positional, so a
mis-ordered mapping produces a plausible table with delay where jitter should
be — it cannot crash. Any cell carrying both ``##RUN##`` rows and the
harness's independent ``# stddev`` lines gets each metric's sample sd
recomputed from the columns this parser believes are that metric and compared
against the harness's own number; a disagreement prints MAPPING FAIL and the
script exits non-zero. Do not trust any number from a cell that failed.
"""
import argparse
import math
import re
import sys

import stats_util

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
# Per-run row (#128): "##RUN## <run> <proto> <fields...>". Fields are
# POSITIONAL, in the ##BENCH## order (anthocnet-compare.cc keeps them
# field-aligned): pdr delay delay99 thrput nrl jitter off50 off90 nrl_bytes;
# off50/off90 may print "inf".
RUN = re.compile(r"##RUN##\s+(\d+)\s+([A-Za-z][\w-]*)\s+(.+?)\s*$")
RUN_METRICS = ["pdr", "delay", "delay99", "thrput", "nrl",
               "jitter", "off50", "off90", "nrl_bytes"]
# The harness's independent dispersion line (#28):
# "# stddev <proto> pdr=.. delay=.. delay99=.. nrl=.. nrl_bytes=.."
STDDEV = re.compile(r"^#\s+stddev\s+([A-Za-z][\w-]*)\s+(.+)$")
# Sim-cost line (#131): "##PERF## <scenario> all <wall_s> <maxrss_kb>" —
# passed through verbatim so cost shows up next to the quality rows.
PERF = re.compile(r"##PERF##.*")

# Printed-precision half-ulps for the mapping check tolerance: the ##RUN##
# rows and the '# stddev' line round differently (anthocnet-compare.cc
# setprecision), so a recomputed sd can differ from the reported one by the
# rounding alone. run-row: pdr/delay/delay99 .1f, nrl .2f, nrl_bytes .4f;
# stddev line: pdr .2f, delay/delay99 .1f, nrl/nrl_bytes .3f.
ULP_RUN = {"pdr": .05, "delay": .05, "delay99": .05,
           "nrl": .005, "nrl_bytes": .00005}
ULP_SD = {"pdr": .005, "delay": .05, "delay99": .05,
          "nrl": .0005, "nrl_bytes": .0005}


def parse_cell(text):
    """Return {proto: {metric: float}} from one run's output text.

    isl-grid's human table and ##RUN## rows (#259) already parse via ROW/RUN
    (the first six fields are position-identical to anthocnet-compare's);
    its --csv rows are mapped by header name below, so a satellite cell A/Bs
    exactly like a MANET one (#244 directed arm, #250 discriminator).
    """
    rows = {}
    isl_cols = None
    for line in text.splitlines():
        s = line.strip()
        if s.startswith("protocol,runs,rows,cols,"):  # isl-grid --csv header
            isl_cols = s.split(",")
            continue
        if isl_cols and "," in s:
            d = dict(zip(isl_cols, s.split(",")))
            try:
                rows[d["protocol"]] = {
                    "pdr": float(d["pdr_pct"]), "delay": float(d["delay_ms"]),
                    "delay99": float(d["delay99_ms"]),
                    "thrput": float(d["throughput_kbps"]),
                    "nrl": float(d["nrl"])}
            except (KeyError, ValueError):
                pass
            continue
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
    """Return {proto: {run: {metric: float}}} from ##RUN## per-seed rows.

    All positional fields are kept (RUN_METRICS order); "inf" fields are
    dropped from that run's dict. #128 pairing and the #293 CI/paired stats
    both read from this.
    """
    runs = {}
    for line in text.splitlines():
        m = RUN.search(line)
        if not m:
            continue
        vals = {}
        for name, tok in zip(RUN_METRICS, m.group(3).split()):
            try:
                v = float(tok)
            except ValueError:
                continue
            if math.isfinite(v):  # "inf" offered-load percentiles: drop
                vals[name] = v
        if "pdr" in vals:
            runs.setdefault(m.group(2), {})[int(m.group(1))] = vals
    return runs


def parse_stddev(text):
    """Return {proto: {metric: float}} from the harness's '# stddev' lines."""
    sds = {}
    for line in text.splitlines():
        m = STDDEV.match(line.strip())
        if not m:
            continue
        vals = {}
        for tok in m.group(2).split():
            if "=" not in tok:
                continue
            k, _, v = tok.partition("=")
            try:
                vals[k] = float(v)
            except ValueError:
                pass
        if vals:
            sds[m.group(1)] = vals
    return sds


def mapping_check(runs, sds):
    """Recompute each metric's sample sd from the ##RUN## columns and compare
    with the harness's '# stddev' line. Returns (n_checks, failures) where a
    failure is (proto, metric, recomputed, reported). A failure means the
    positional column mapping is wrong — no number from the cell is safe.
    """
    checks, fails = 0, []
    for proto, reported in sorted(sds.items()):
        per_run = runs.get(proto, {})
        for metric in ("pdr", "delay", "delay99", "nrl", "nrl_bytes"):
            if metric not in reported:
                continue
            vals = [r[metric] for r in per_run.values() if metric in r]
            if len(vals) < 2:
                continue
            sd = stats_util.sample_sd(vals)
            tol = (ULP_RUN[metric] + ULP_SD[metric]
                   + 0.01 * max(sd, reported[metric]))
            checks += 1
            if abs(sd - reported[metric]) > tol:
                fails.append((proto, metric, sd, reported[metric]))
    return checks, fails


def paired(base_runs, cur_runs):
    """Paired per-seed dPDR line (#128), or None without common runs.

    Pairs the two cells' ##RUN## PDR values by run number and reports the
    delta signs: sign-consistent when one direction reaches >2/3 of the runs,
    else PAIRED-NOISE (the split-signs signature of run-to-run noise).
    """
    common = sorted(set(base_runs) & set(cur_runs))
    if not common:
        return None
    signs = ["+" if cur_runs[r]["pdr"] > base_runs[r]["pdr"] else
             "-" if cur_runs[r]["pdr"] < base_runs[r]["pdr"] else "0"
             for r in common]
    pos, neg, n = signs.count("+"), signs.count("-"), len(signs)
    if pos * 3 > n * 2:
        call = f"{pos}/{n} positive (sign-consistent)"
    elif neg * 3 > n * 2:
        call = f"{neg}/{n} negative (sign-consistent)"
    else:
        call = f"{pos}/{n} positive, {neg}/{n} negative -> PAIRED-NOISE"
    return f"paired dPDR by run: {','.join(signs)} -> {call}"


# (metric, good-when, absolute-or-none) — the same three signals as verdict().
PAIRED_METRICS = [("pdr", +1), ("delay99", -1), ("nrl", -1)]


def paired_stats(base_runs, cur_runs):
    """Paired-difference stats over common runs (#293 item 3), or None.

    Returns (n, {metric: (dmean, lo, hi, p)}, verdict). Intervals are 95%:
    t-CI for pdr/nrl, percentile bootstrap for delay99 (skewed tail metric).
    p is the two-sided Wilcoxon signed-rank p. The verdict counts a metric
    only when its interval excludes zero — significance, not materiality —
    with the same good-directions as verdict(): pdr up, delay99/NRL down.
    """
    common = sorted(set(base_runs) & set(cur_runs))
    if len(common) < 2:
        return None
    stats, sig = {}, []
    for metric, good in PAIRED_METRICS:
        diffs = [cur_runs[r][metric] - base_runs[r][metric] for r in common
                 if metric in cur_runs[r] and metric in base_runs[r]]
        if len(diffs) < 2:
            continue
        dmean = sum(diffs) / len(diffs)
        if metric == "delay99":
            lo, hi = stats_util.bootstrap_ci_mean(diffs)
        else:
            hw = stats_util.t_halfwidth(stats_util.sample_sd(diffs),
                                        len(diffs))
            lo, hi = dmean - hw, dmean + hw
        _, _, p, _ = stats_util.wilcoxon(diffs)
        stats[metric] = (dmean, lo, hi, p)
        if lo > 0 or hi < 0:  # CI excludes zero
            sig.append(1 if dmean * good > 0 else -1)
    if not sig:
        v = "PAIRED-NOISE"
    elif all(s > 0 for s in sig):
        v = "PAIRED-IMPROVED"
    elif all(s < 0 for s in sig):
        v = "PAIRED-WORSE"
    else:
        v = "PAIRED-MIXED"
    return len(common), stats, v


def fmt_paired(pstats):
    """One line: paired (n=20): dPDR +1.2 [0.8,1.6]pp p=0.001 ... -> VERDICT"""
    n, stats, v = pstats
    bits = []
    for metric, _ in PAIRED_METRICS:
        if metric not in stats:
            continue
        dmean, lo, hi, p = stats[metric]
        unit = "pp" if metric == "pdr" else ("ms" if metric == "delay99" else "")
        pstr = "p=n/a" if p is None else f"p={p:.3g}"
        label = {"pdr": "dPDR", "delay99": "d_d99", "nrl": "d_NRL"}[metric]
        bits.append(f"{label} {dmean:+.2f} [{lo:+.2f},{hi:+.2f}]{unit} {pstr}")
    return f"paired 95% CI (n={n}): " + "  ".join(bits) + f" -> {v}"


def label_of(path, text):
    for line in text.splitlines():
        s = line.strip()
        if s.startswith("#") and not s.startswith("##"):  # '# label', not '##BENCH##'
            if s.lstrip("# ").startswith("stddev "):
                continue
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


def ci_line(proto, per_run):
    """95% CI line for one protocol's per-run rows: t half-widths, except a
    bootstrap interval for delay99 (#293 item 1). None when n < 2."""
    n = len(per_run)
    if n < 2:
        return None
    bits = []
    for metric in METRICS:
        vals = [r[metric] for r in per_run.values() if metric in r]
        if len(vals) < 2:
            bits.append(f"{metric} n/a")
            continue
        mean = sum(vals) / len(vals)
        if metric == "delay99":
            lo, hi = stats_util.bootstrap_ci_mean(vals)
            bits.append(f"delay99 {mean:.1f} boot[{lo:.1f},{hi:.1f}]")
        else:
            hw = stats_util.t_halfwidth(stats_util.sample_sd(vals), len(vals))
            bits.append(f"{metric} {mean:.2f} ±{hw:.2f}")
    return f"  n={n}: " + "  ".join(bits)


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
        perf = [m.group(0) for m in map(PERF.search, text.splitlines()) if m]
        cells.append((label_of(path, text), parse_cell(text),
                      parse_runs(text), perf, parse_stddev(text)))

    protos = ([args.proto] if not args.all else
              sorted({p for _, r, _, _, _ in cells for p in r}))

    hdr = f"{'cell':<28}{'proto':<11}" + "".join(f"{m:>9}" for m in METRICS)
    print(hdr)
    print("-" * len(hdr))
    mapping_failed = False
    for lbl, rows, runs, perf, sds in cells:
        for p in protos:
            if p in rows:
                print(f"{lbl:<28}{p:<11}" + "".join(fmt(rows[p][m]) for m in METRICS))
            cl = ci_line(p, runs.get(p, {}))
            if cl:
                print(f"{'':<28}95% CI{cl}")
        for ln in perf:
            print(ln)
        # #293 column-mapping self-check: runs automatically on any cell that
        # carries both ##RUN## rows and '# stddev' lines (all protocols, not
        # just the compared one — the extra checks are free).
        if runs and sds:
            checks, fails = mapping_check(runs, sds)
            if fails:
                mapping_failed = True
                print(f"{lbl}: ##RUN## column-mapping check FAILED "
                      f"({len(fails)}/{checks}):")
                for proto, metric, sd, rep in fails:
                    print(f"  ! {proto} {metric}: recomputed sd {sd:.4g} != "
                          f"harness '# stddev' {rep:.4g} — positional mapping "
                          f"is wrong, numbers from this cell are unsafe")
            elif checks:
                print(f"{lbl}: column mapping vs '# stddev' OK "
                      f"({checks} checks)")

    if len(cells) < 2:
        sys.exit(1 if mapping_failed else 0)
    p = args.proto

    if args.ab:
        # (off, on) pairs: delta is on-vs-off within each pair.
        print("\nA/B deltas (on vs off, anthocnet):")
        signs = []
        npairs = 0
        for i in range(0, len(cells) - 1, 2):
            off_lbl, off = cells[i][0], cells[i][1].get(p)
            on_lbl, on = cells[i + 1][0], cells[i + 1][1].get(p)
            if not off or not on:
                continue
            npairs += 1
            v, dp, dd, dd99, dn = verdict(off, on)
            signs.append((dp > 0) - (dp < 0))
            ps = paired_stats(cells[i][2].get(p, {}), cells[i + 1][2].get(p, {}))
            shown = ps[2] if ps else v
            print(f"  {off_lbl} -> {on_lbl:<20} dPDR={dp:+5.1f}pp  "
                  f"d_delay={dd:+6.1f}%  d_d99={dd99:+6.1f}%  d_NRL={dn:+6.1f}%   {shown}")
            if ps:
                print(f"    {fmt_paired(ps)}")
            pline = paired(cells[i][2].get(p, {}), cells[i + 1][2].get(p, {}))
            if pline:
                print(f"    {pline}")
        if len({s for s in signs if s}) > 1:
            print("\n  ! cross-pair PDR deltas disagree in sign -> run-to-run "
                  "NOISE, not a real effect (cf. issue #47). Bump --runs.")
        if npairs >= 5:
            print(f"\n  note: {npairs} comparisons at alpha=0.05 — expect "
                  f"~{npairs / 20:.1f} false positives; treat isolated "
                  f"marginal p-values accordingly (#293).")
        sys.exit(1 if mapping_failed else 0)

    print(f"\ndeltas vs first cell ({p}):")
    base = cells[0][1].get(p)
    ncmp = 0
    if base:
        for lbl, rows, runs, _, _ in cells[1:]:
            cur = rows.get(p)
            if not cur:
                continue
            ncmp += 1
            v, dp, dd, dd99, dn = verdict(base, cur)
            ps = paired_stats(cells[0][2].get(p, {}), runs.get(p, {}))
            shown = ps[2] if ps else v
            print(f"  {lbl:<26} dPDR={dp:+5.1f}pp  d_delay={dd:+6.1f}%  "
                  f"d_d99={dd99:+6.1f}%  d_NRL={dn:+6.1f}%   {shown}")
            if ps:
                print(f"    {fmt_paired(ps)}")
            pline = paired(cells[0][2].get(p, {}), runs.get(p, {}))
            if pline:
                print(f"    {pline}")
        if ncmp >= 5:
            print(f"\n  note: {ncmp} comparisons at alpha=0.05 — expect "
                  f"~{ncmp / 20:.1f} false positives; treat isolated "
                  f"marginal p-values accordingly (#293).")
    sys.exit(1 if mapping_failed else 0)


if __name__ == "__main__":
    main()
