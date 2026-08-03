#!/usr/bin/env python3
"""Self-test for stats_util.py and the #293 statistics in bench_parse.py /
sweep_summary.py.

Same rationale as test_scenario_check.py: these numbers gate what gets
published, so "a rule that can't fire isn't a gate" (#293 acceptance). Each
piece gets a case where it must fire / produce the known value, and one where
it must stay quiet. Exact-test expectations are hand-computable small cases
(the n=4 Wilcoxon enumeration is 16 subsets, done in the comment), not
regression snapshots.

Run: python3 test_stats.py     (no pytest dependency; exits non-zero on the
                                first failure)
"""

import contextlib
import importlib.util
import io
import math
import os
import sys


def _load(name):
    """Load a module from source next to this file (same reasons as
    test_scenario_check.py: no stale __pycache__, no sys.path juggling)."""
    path = os.path.join(os.path.dirname(os.path.abspath(__file__)),
                        name + ".py")
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    # bench_parse does `import stats_util`; make sure it resolves to the
    # sibling file even when this test runs from another cwd.
    sys.path.insert(0, os.path.dirname(path))
    try:
        spec.loader.exec_module(module)
    finally:
        sys.path.pop(0)
    return module


su = _load("stats_util")
bp = _load("bench_parse")
sw = _load("sweep_summary")

CASES = []


def case(desc):
    def wrap(fn):
        CASES.append((desc, fn))
        return fn
    return wrap


def approx(a, b, tol=1e-3):
    assert abs(a - b) <= tol, f"{a} != {b} (tol {tol})"


# ---- t quantiles -----------------------------------------------------------

@case("t975 matches the standard table at df=1/4/19/30")
def _():
    approx(su.t975(1), 12.706)
    approx(su.t975(4), 2.776)
    approx(su.t975(19), 2.093)
    approx(su.t975(30), 2.042)


@case("t975 interpolates sanely beyond the table and approaches 1.96")
def _():
    assert 2.000 < su.t975(50) < 2.021         # between df=60 and df=40 anchors
    assert 1.960 < su.t975(1000) < 1.965
    prev = su.t975(1)
    for df in (2, 5, 10, 20, 30, 40, 60, 120, 240, 10000):
        cur = su.t975(df)
        assert cur < prev, f"t975 not decreasing at df={df}"
        prev = cur


# ---- sd / CI ----------------------------------------------------------------

@case("sample_sd known value and n<2 guard")
def _():
    approx(su.sample_sd([2, 4, 4, 4, 5, 5, 7, 9]), math.sqrt(32 / 7.0))
    assert su.sample_sd([5]) == 0.0
    assert su.sample_sd([]) == 0.0


@case("t_halfwidth: [1..5] gives 3 ± 1.963")
def _():
    mean, hw = su.t_ci([1, 2, 3, 4, 5])
    approx(mean, 3.0)
    approx(hw, 2.776 * math.sqrt(2.5) / math.sqrt(5))  # 1.963
    assert su.t_halfwidth(1.0, 1) is None


# ---- bootstrap --------------------------------------------------------------

@case("bootstrap CI is deterministic, brackets the mean, and guards n<2")
def _():
    xs = [100.0, 120.0, 95.0, 400.0, 110.0, 105.0, 130.0, 90.0]  # skewed
    lo1, hi1 = su.bootstrap_ci_mean(xs)
    lo2, hi2 = su.bootstrap_ci_mean(xs)
    assert (lo1, hi1) == (lo2, hi2), "bootstrap not reproducible"
    m = sum(xs) / len(xs)
    assert lo1 < m < hi1
    assert su.bootstrap_ci_mean([1.0]) == (None, None)


@case("bootstrap interval is asymmetric on a skewed sample (why not t)")
def _():
    xs = [10.0] * 9 + [1000.0]
    lo, hi = su.bootstrap_ci_mean(xs)
    m = sum(xs) / len(xs)
    assert (hi - m) > (m - lo), "expected a longer upper tail"


# ---- Wilcoxon ---------------------------------------------------------------

@case("wilcoxon exact: [1,2,3,-4] -> W+=6, p=0.875 (16-subset enumeration)")
def _():
    # |d| ranks 1,2,3,4; W+ = 6, min(W+,W-) = 4. Subset rank-sums <= 4:
    # {},{1},{2},{3},{4},{1,2},{1,3} = 7 of 16 -> p = 2*7/16 = 0.875.
    n, w, p, method = su.wilcoxon([1, 2, 3, -4])
    assert (n, w, method) == (4, 6.0, "exact")
    approx(p, 0.875)


@case("wilcoxon exact: six same-sign diffs -> p = 2/64")
def _():
    n, w, p, method = su.wilcoxon([1, 2, 3, 4, 5, 6])
    assert (n, w, method) == (6, 21.0, "exact")
    approx(p, 2.0 / 64.0)


@case("wilcoxon drops zeros; all-zero input is degenerate")
def _():
    n, _, _, _ = su.wilcoxon([0, 0, 1, 2, 3])
    assert n == 3
    n, _, p, method = su.wilcoxon([0.0, 0.0])
    assert (n, p, method) == (0, None, "degenerate")


@case("wilcoxon falls back to normal approx on ties and on n>25")
def _():
    _, _, p, method = su.wilcoxon([1, 1, -1, 2, 2, -2, 3, 3])
    assert method == "normal" and 0.0 < p <= 1.0
    _, _, p, method = su.wilcoxon(list(range(1, 31)))  # n=30, no ties
    assert method == "normal" and p < 0.001


# ---- bench_parse: per-run parsing + CI lines --------------------------------

def _cell(label, base_pdr, d99_base, shift_pdr=0.0, shift_d99=0.0,
          runs=10, stddev=True, sd_override=None):
    """Synthetic anthocnet-compare tail: ##RUN## rows + '# stddev' lines whose
    values are internally consistent (unless sd_override poisons one)."""
    lines = [f"# {label}"]
    cols = {m: [] for m in ("pdr", "delay", "delay99", "nrl", "nrl_bytes")}
    for r in range(1, runs + 1):
        pdr = base_pdr + 0.1 * r + shift_pdr + (0.01 * r if shift_pdr else 0)
        delay = 100.0 + r
        d99 = d99_base + r + shift_d99 - (0.5 * r if shift_d99 else 0)
        nrl = 3.0 + 0.01 * r
        nrlb = 50.0 + 0.1 * r
        cols["pdr"].append(round(pdr, 1))
        cols["delay"].append(round(delay, 1))
        cols["delay99"].append(round(d99, 1))
        cols["nrl"].append(round(nrl, 2))
        cols["nrl_bytes"].append(round(nrlb, 4))
        lines.append(f"##RUN## {r} anthocnet {pdr:.1f} {delay:.1f} {d99:.1f} "
                     f"5.00 {nrl:.2f} 10.00 inf inf {nrlb:.4f}")
    mean = {m: sum(v) / len(v) for m, v in cols.items()}
    lines.append(f"anthocnet {mean['pdr']:.1f} {mean['delay']:.1f} "
                 f"{mean['delay99']:.1f} 5.00 {mean['nrl']:.2f}")
    if stddev:
        sd = {m: su.sample_sd(v) for m, v in cols.items()}
        if sd_override:
            sd[sd_override[0]] = sd_override[1]
        lines.append(f"# stddev anthocnet pdr={sd['pdr']:.2f} "
                     f"delay={sd['delay']:.1f} delay99={sd['delay99']:.1f} "
                     f"nrl={sd['nrl']:.3f} nrl_bytes={sd['nrl_bytes']:.3f}")
    return "\n".join(lines) + "\n"


@case("parse_runs keeps all positional fields and tolerates inf")
def _():
    runs = bp.parse_runs(_cell("a", 80.0, 500.0))["anthocnet"]
    assert len(runs) == 10
    assert set(runs[1]) == {"pdr", "delay", "delay99", "thrput", "nrl",
                            "jitter", "nrl_bytes"}  # off50/off90 were inf


@case("ci_line emits t half-widths and a bootstrap interval for delay99")
def _():
    runs = bp.parse_runs(_cell("a", 80.0, 500.0))["anthocnet"]
    line = bp.ci_line("anthocnet", runs)
    assert "n=10" in line and "±" in line and "boot[" in line
    assert bp.ci_line("anthocnet", {1: {"pdr": 80.0}}) is None


@case("mapping check passes on a consistent cell")
def _():
    text = _cell("ok", 80.0, 500.0)
    checks, fails = bp.mapping_check(bp.parse_runs(text),
                                     bp.parse_stddev(text))
    assert checks == 5 and not fails, (checks, fails)


@case("mapping check fires on a poisoned '# stddev' (column-swap class)")
def _():
    # delay sd reported where delay99's belongs — the plausible-but-wrong
    # positional shift the #110 campaign's 40 checks were guarding against.
    text = _cell("bad", 80.0, 500.0, sd_override=("delay99", 0.30))
    checks, fails = bp.mapping_check(bp.parse_runs(text),
                                     bp.parse_stddev(text))
    assert any(f[1] == "delay99" for f in fails), fails


@case("paired_stats: consistent shift -> PAIRED-IMPROVED with tight CIs")
def _():
    base = bp.parse_runs(_cell("off", 80.0, 500.0))["anthocnet"]
    cur = bp.parse_runs(_cell("on", 80.0, 500.0,
                              shift_pdr=2.0, shift_d99=-50.0))["anthocnet"]
    n, stats, v = bp.paired_stats(base, cur)
    assert n == 10 and v == "PAIRED-IMPROVED", (n, v, stats)
    dmean, lo, hi, p = stats["pdr"]
    assert lo > 0 and p < 0.01
    dmean, lo, hi, p = stats["delay99"]
    assert hi < 0, "delay99 bootstrap CI must exclude zero here"


@case("paired_stats: alternating noise -> PAIRED-NOISE")
def _():
    base = bp.parse_runs(_cell("off", 80.0, 500.0))["anthocnet"]
    cur = {r: dict(v) for r, v in base.items()}
    for r in cur:  # ±0.2pp alternating, mean ~0
        cur[r]["pdr"] += 0.2 if r % 2 else -0.2
    res = bp.paired_stats(base, cur)
    assert res[2] == "PAIRED-NOISE", res[2]


@case("paired_stats needs >=2 common runs")
def _():
    base = bp.parse_runs(_cell("off", 80.0, 500.0))["anthocnet"]
    assert bp.paired_stats(base, {1: base[1]}) is None


# ---- sweep_summary: CI column ------------------------------------------------

@case("pdr_hw: t half-width from aggregate sd/runs; blank when absent")
def _():
    row = {"pdr_sd": "1.0", "runs": "20"}
    approx(float(sw.pdr_hw(row)), 2.093 / math.sqrt(20), tol=0.05)
    assert sw.pdr_hw({"pdr_sd": "", "runs": "20"}) == ""
    assert sw.pdr_hw({"pdr_sd": "1.0", "runs": "1"}) == ""


# ---- end-to-end through main() ----------------------------------------------

@case("bench_parse main: paired verdict replaces materiality verdict")
def _():
    import tempfile
    with tempfile.TemporaryDirectory() as td:
        off = os.path.join(td, "off.txt")
        on = os.path.join(td, "on.txt")
        with open(off, "w") as fh:
            fh.write(_cell("off", 80.0, 500.0))
        with open(on, "w") as fh:
            fh.write(_cell("on", 80.0, 500.0, shift_pdr=2.0, shift_d99=-50.0))
        argv, sys.argv = sys.argv, ["bench_parse.py", off, on]
        out = io.StringIO()
        try:
            with contextlib.redirect_stdout(out):
                try:
                    bp.main()
                except SystemExit as e:
                    assert not e.code, f"exit {e.code}\n{out.getvalue()}"
        finally:
            sys.argv = argv
        text = out.getvalue()
        assert "PAIRED-IMPROVED" in text, text
        assert "column mapping vs '# stddev' OK (5 checks)" in text, text
        assert "paired 95% CI (n=10)" in text, text


@case("bench_parse main: mapping failure exits non-zero")
def _():
    import tempfile
    with tempfile.TemporaryDirectory() as td:
        bad = os.path.join(td, "bad.txt")
        with open(bad, "w") as fh:
            fh.write(_cell("bad", 80.0, 500.0, sd_override=("pdr", 9.99)))
        argv, sys.argv = sys.argv, ["bench_parse.py", bad]
        out = io.StringIO()
        try:
            with contextlib.redirect_stdout(out):
                code = 0
                try:
                    bp.main()
                except SystemExit as e:
                    code = e.code
        finally:
            sys.argv = argv
        assert code == 1, out.getvalue()
        assert "MAPPING" in out.getvalue().upper() or \
               "mapping check FAILED" in out.getvalue(), out.getvalue()


def main():
    failed = 0
    for desc, fn in CASES:
        try:
            fn()
            print(f"PASS  {desc}")
        except AssertionError as e:
            failed += 1
            print(f"FAIL  {desc}\n      {e}")
    if failed:
        sys.exit(f"{failed}/{len(CASES)} case(s) failed")
    print(f"all {len(CASES)} cases passed")


if __name__ == "__main__":
    main()
