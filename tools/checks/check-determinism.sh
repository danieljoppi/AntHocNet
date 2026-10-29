#!/usr/bin/env bash
# SPDX-License-Identifier: MIT OR GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
# Determinism gate (#129): run the same small routing-compare scenario TWICE
# with identical parameters and fail unless the per-protocol metric rows are
# byte-identical. Golden rule 3 (AGENTS.md) routes all randomness through IRng
# and all time through IClock precisely so identical seeds reproduce identical
# runs — the property the harness's per-protocol comparison on identical
# realisations rests on. A stray rand(), an uninjected wall-clock read, or
# unordered-container iteration feeding a routing decision would break this
# silently; this gate makes it fail CI loudly instead. It is the "identity"
# anchor of docs/benchmarks/methodology.md "Validation anchors": the expected result is
# not a number but *identical output*.
#
# Usage: check-determinism.sh <ns3-dir> [compare|isl-grid]
#
# `compare` (the default) runs the wifi/MANET field; `isl-grid` runs the same
# identity check on the satellite ISL topology (S5 of #237).
#
# The ns-3 tree must already be configured + built with examples enabled
# (routing-compare is routing-bench's, isl-grid the anthocnet module's).
set -euo pipefail

NS3DIR=${1:-}
HARNESS=${2:-compare}
if [ -z "$NS3DIR" ]; then
    echo "usage: $0 <ns3-dir> [compare|isl-grid]" >&2
    exit 2
fi

case "$HARNESS" in
    compare)
        # Small, fast, connected field (same shape as ci.yml's e2e delivery
        # smoke, longer run): anthocnet exercises the core's IRng/IClock paths,
        # aodv is a stock control. --runs=1 fixes the RNG run number (seeds
        # 1..runs), so both invocations use identical seeds by construction.
        args="--nNodes=8 --area=150 --flows=2 --time=60 --runs=1"
        protocols="anthocnet,aodv"
        prog=routing-compare
        cmd="$prog $args --protocols=$protocols"
        ;;
    isl-grid)
        # S5 of #237 — the same identity anchor on the satellite topology.
        # Worth running separately rather than assuming it follows from the
        # wifi case: a p2p ISL grid exercises a different device, a different
        # channel and (post-#203) the multi-interface next-hop resolution,
        # whose peer map is populated from received hellos — i.e. from an
        # ordering that a container-iteration bug could perturb without ever
        # showing up on a single-interface wifi node.
        args="--rows=4 --cols=4 --torus=true --flows=2 --time=30 --runs=1"
        protocols="anthocnet"
        prog=isl-grid
        cmd="$prog $args --protocols=$protocols"
        ;;
    *)
        echo "unknown harness '$HARNESS' (want: compare | isl-grid)" >&2
        exit 2
        ;;
esac

# Keep only the summary-table metric rows ("<proto> <number> ..."), the same
# row pattern the retired paper-benchmark.yml's ##BENCH## awk matched. This drops ./ns3
# build chatter, '# diag'/'# stddev' lines, and anything timing-dependent
# (timestamps, build durations), so the diff compares simulation results, not
# wall-clock artefacts.
# The arm names come from the harness's own --protocols help (#768: the
# registry for routing-compare), not a hand-kept list. An arm missing here
# would not be "not compared" loudly -- it would be dropped from BOTH sides of
# the diff, so a non-deterministic arm would pass this gate silently (how the
# three post-v1.4.0 arms once went unchecked, #421/#435).
cd "$NS3DIR"
arms=$({ ./ns3 run "$prog --PrintHelp" 2>&1 || true; } \
    | sed -n 's/.*Comma-separated list (\([a-z0-9,]*\)).*/\1/p' | head -n 1 | tr ',' '|')
if [ -z "$arms" ]; then
    echo "FAIL [determinism:$HARNESS]: could not read the arm list from $prog --PrintHelp"
    exit 1
fi
filter_rows() {
    awk -v re="^($arms)\$" '$1 ~ re && $2 ~ /^[0-9.]+$/'
}

echo "[determinism:$HARNESS] ./ns3 run \"$cmd\"  (twice; gate: identical metric rows)"

rows1=
rows2=
for i in 1 2; do
    if ! out=$(./ns3 run "$cmd" 2>&1); then
        printf '%s\n' "$out" | tail -n 40
        echo "FAIL [determinism:$HARNESS]: run $i did not run (output tail above)"
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
    echo "  docs/benchmarks/methodology.md 'Validation anchors'."
    echo "--- run 1 (filtered) ---"
    printf '%s\n' "$rows1"
    echo "--- run 2 (filtered) ---"
    printf '%s\n' "$rows2"
    diff <(printf '%s\n' "$rows1") <(printf '%s\n' "$rows2") || true
    exit 1
fi
