#!/usr/bin/env python3
"""Shared statistics for the benchmark-results skill (#293).

Stdlib-only (ADR-0014: these scripts must run anywhere with bare python3).
Provides the 95% confidence-interval and paired-test primitives that
`bench_parse.py` and `sweep_summary.py` emit next to every mean:

- ``t975(df)``            — two-sided 97.5% Student-t quantile (table +
                            1/df interpolation; exact enough for CI half-widths,
                            max error < 0.002 vs scipy across df 1..inf).
- ``t_halfwidth(sd, n)``  — 95% CI half-width  t_{0.975,n-1} * sd / sqrt(n).
- ``bootstrap_ci_mean(xs)`` — percentile-bootstrap 95% CI for the mean, for
                            skewed/tail metrics (delay99) where a t-CI on a
                            p99 is not defensible. Deterministic seed so a
                            re-run reproduces the published interval.
- ``wilcoxon(diffs)``     — two-sided Wilcoxon signed-rank test on paired
                            per-seed differences: exact null distribution for
                            n <= 25 without ties, normal approximation with
                            tie correction + continuity correction otherwise.

The choice of methods is recorded in docs/benchmarks/methodology.md (#293
items 4/5); change them there and here together.
"""
import math
import random

# t_{0.975, df} — Student-t two-sided 95% critical values. df 1..30 exact
# (standard tables); beyond 30, linear interpolation in 1/df between the
# anchors below is accurate to <0.002.
_T975 = {
    1: 12.706, 2: 4.303, 3: 3.182, 4: 2.776, 5: 2.571, 6: 2.447, 7: 2.365,
    8: 2.306, 9: 2.262, 10: 2.228, 11: 2.201, 12: 2.179, 13: 2.160,
    14: 2.145, 15: 2.131, 16: 2.120, 17: 2.110, 18: 2.101, 19: 2.093,
    20: 2.086, 21: 2.080, 22: 2.074, 23: 2.069, 24: 2.064, 25: 2.060,
    26: 2.056, 27: 2.052, 28: 2.048, 29: 2.045, 30: 2.042,
}
_T975_ANCHORS = [(30, 2.042), (40, 2.021), (60, 2.000), (120, 1.980)]
_T975_INF = 1.960


def t975(df):
    """Two-sided 97.5% Student-t quantile for `df` degrees of freedom."""
    if df < 1:
        raise ValueError("df must be >= 1")
    if df in _T975:
        return _T975[df]
    if df <= 30:  # non-integer df never happens here, but stay safe
        return _T975[int(df)]
    prev = _T975_ANCHORS[0]
    for anchor in _T975_ANCHORS[1:]:
        if df <= anchor[0]:
            (d0, t0), (d1, t1) = prev, anchor
            w = (1.0 / df - 1.0 / d0) / (1.0 / d1 - 1.0 / d0)
            return t0 + w * (t1 - t0)
        prev = anchor
    d0, t0 = _T975_ANCHORS[-1]
    w = (1.0 / df) / (1.0 / d0)  # interpolate toward 1/df -> 0
    return _T975_INF + w * (t0 - _T975_INF)


def sample_sd(xs):
    """Sample standard deviation (n-1 denominator); 0.0 for n < 2."""
    n = len(xs)
    if n < 2:
        return 0.0
    m = sum(xs) / n
    return math.sqrt(sum((x - m) ** 2 for x in xs) / (n - 1))


def t_halfwidth(sd, n):
    """95% CI half-width from a sample sd and run count; None when n < 2."""
    if n < 2 or sd is None:
        return None
    return t975(n - 1) * sd / math.sqrt(n)


def t_ci(xs):
    """(mean, halfwidth) of a sample; halfwidth None when n < 2."""
    if not xs:
        return None, None
    m = sum(xs) / len(xs)
    return m, t_halfwidth(sample_sd(xs), len(xs))


# Fixed seed: the interval is part of the published record, so a re-run of the
# parser on the same input must reproduce it byte-for-byte (#293).
BOOTSTRAP_SEED = 293
BOOTSTRAP_RESAMPLES = 10000


def bootstrap_ci_mean(xs, resamples=BOOTSTRAP_RESAMPLES, seed=BOOTSTRAP_SEED):
    """Percentile-bootstrap 95% CI (lo, hi) for the mean of `xs`.

    For skewed metrics (per-run delay99) where the t-CI's symmetry assumption
    fails. Deterministic for a given input. None, None when n < 2.
    """
    n = len(xs)
    if n < 2:
        return None, None
    rng = random.Random(seed)
    means = sorted(
        sum(xs[rng.randrange(n)] for _ in range(n)) / n
        for _ in range(resamples))
    lo = means[int(0.025 * resamples)]
    hi = means[min(int(0.975 * resamples), resamples - 1)]
    return lo, hi


def wilcoxon(diffs):
    """Two-sided Wilcoxon signed-rank test on paired differences.

    Returns (n_used, w_plus, p, method). Zero differences are dropped (the
    standard treatment); ties in |d| get midranks. Exact null distribution
    when n <= 25 and there are no ties (integer ranks); otherwise the normal
    approximation with tie correction and continuity correction.
    method is 'exact', 'normal', or 'degenerate' (all diffs zero -> p None).
    """
    d = [x for x in diffs if x != 0]
    n = len(d)
    if n == 0:
        return 0, 0.0, None, "degenerate"
    pairs = sorted((abs(x), x > 0) for x in d)
    vals = [a for a, _ in pairs]
    ranks = []
    i = 0
    while i < n:
        j = i
        while j < n and vals[j] == vals[i]:
            j += 1
        ranks.extend([(i + 1 + j) / 2.0] * (j - i))
        i = j
    w_plus = sum(r for r, (_, pos) in zip(ranks, pairs) if pos)
    has_ties = len(set(vals)) != n

    if n <= 25 and not has_ties:
        total = n * (n + 1) // 2
        counts = [0] * (total + 1)
        counts[0] = 1
        for r in range(1, n + 1):  # subset-sum DP over rank sums
            for s in range(total, r - 1, -1):
                counts[s] += counts[s - r]
        m = int(min(w_plus, total - w_plus))
        p = min(1.0, 2.0 * sum(counts[: m + 1]) / float(2 ** n))
        return n, w_plus, p, "exact"

    mu = n * (n + 1) / 4.0
    tie_term = 0.0
    i = 0
    while i < n:
        j = i
        while j < n and vals[j] == vals[i]:
            j += 1
        t = j - i
        tie_term += t ** 3 - t
        i = j
    var = n * (n + 1) * (2 * n + 1) / 24.0 - tie_term / 48.0
    if var <= 0:
        return n, w_plus, None, "degenerate"
    cc = 0.5 if w_plus > mu else (-0.5 if w_plus < mu else 0.0)
    z = (w_plus - mu - cc) / math.sqrt(var)
    p = math.erfc(abs(z) / math.sqrt(2.0))
    return n, w_plus, p, "normal"
