#!/usr/bin/env bash
# Determinism gate (#129): run the same small anthocnet-compare scenario TWICE
# with identical parameters and fail unless the per-protocol metric rows are
# byte-identical. Golden rule 3 (AGENTS.md) routes all randomness through IRng
# and all time through IClock precisely so identical seeds reproduce identical
# runs — the property the harness's per-protocol comparison on identical
# realisations rests on. A stray rand(), an uninjected wall-clock read, or
# unordered-container iteration feeding a routing decision would break this
# silently; this gate makes it fail CI loudly instead. It is the "identity"
# anchor of docs/benchmarks.md "Validation anchors": the expected result is
# not a number but *identical output*.
#
# Usage: check-determinism.sh <ns3-dir>
#
# The ns-3 tree must already be configured + built with the anthocnet module's
# examples enabled (anthocnet-compare builds as part of the module's examples).
set -euo pipefail

NS3DIR=${1:-}
if [ -z "$NS3DIR" ]; then
    echo "usage: $0 <ns3-dir>" >&2
    exit 2
fi

# Small, fast, connected field (same shape as ci.yml's e2e delivery smoke,
# longer run): anthocnet exercises the core's IRng/IClock paths, aodv is a
# stock control. --runs=1 fixes the RNG run number (seeds 1..runs), so both
# invocations use identical seeds by construction.
args="--nNodes=8 --area=150 --flows=2 --time=60 --runs=1"
protocols="anthocnet,aodv"
cmd="anthocnet-compare $args --protocols=$protocols"

# Keep only the summary-table metric rows ("<proto> <number> ..."), the same
# row pattern paper-benchmark.yml's ##BENCH## awk matches. This drops ./ns3
# build chatter, '# diag'/'# stddev' lines, and anything timing-dependent
# (timestamps, build durations), so the diff compares simulation results, not
# wall-clock artefacts.
filter_rows() {
    awk '$1 ~ /^(anthocnet|aodv|olsr|dsdv)$/ && $2 ~ /^[0-9.]+$/'
}

echo "[determinism] ./ns3 run \"$cmd\"  (twice; gate: identical metric rows)"
cd "$NS3DIR"

rows1=
rows2=
for i in 1 2; do
    if ! out=$(./ns3 run "$cmd" 2>&1); then
        printf '%s\n' "$out" | tail -n 40
        echo "FAIL [determinism]: run $i of anthocnet-compare did not run (output tail above)"
        exit 1
    fi
    rows=$(printf '%s\n' "$out" | filter_rows)
    if [ -z "$rows" ]; then
        echo "FAIL [determinism]: run $i produced no result rows — empty table (#28-style silent failure)"
        exit 1
    fi
    if [ "$i" -eq 1 ]; then rows1=$rows; else rows2=$rows; fi
done

if [ "$rows1" = "$rows2" ]; then
    echo "PASS [determinism] both runs produced identical metric rows:"
    printf '%s\n' "$rows1"
else
    echo "FAIL [determinism]: same seed, different results — golden rule 3 regressed."
    echo "  Identical parameters (and therefore identical seeds) must reproduce"
    echo "  byte-identical metric rows; a stray rand(), an uninjected clock read,"
    echo "  or unordered-container iteration feeding a decision breaks the"
    echo "  per-protocol comparison on identical realisations. See #129 and"
    echo "  docs/benchmarks.md 'Validation anchors'."
    echo "--- run 1 (filtered) ---"
    printf '%s\n' "$rows1"
    echo "--- run 2 (filtered) ---"
    printf '%s\n' "$rows2"
    diff <(printf '%s\n' "$rows1") <(printf '%s\n' "$rows2") || true
    exit 1
fi
