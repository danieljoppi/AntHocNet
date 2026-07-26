#!/usr/bin/env bash
# Satellite validation-anchor gate (#237): run known-expected ISL-grid
# scenarios and fail unless the results match values derived *analytically*
# rather than from a previous run.
#
# Usage: check-sat-anchors.sh <ns3-dir> <single-isl|hop-delay> [isl-delay-ms]
#
# Why these are stronger than the MANET anchors in check-anchors.sh: those are
# literature-derived and approximate ("AODV ~90-100%"), because a wifi channel
# is stochastic. A point-to-point ISL grid with a fixed per-link delay is not —
# so the expected delivery ratio is exactly 100%, and the expected delay is
# h*d plus a small bounded serialisation term. A substrate, image or topology
# bug cannot hide behind "that looks plausible" (cf. #51, where a ~50%
# single-hop loss silently corrupted every number in the repo until the
# equivalent MANET anchor caught it).
#
# The ns-3 tree must already be configured + built with the anthocnet module's
# examples enabled (isl-grid builds as part of the module's examples).
set -euo pipefail

NS3DIR=${1:-}
ANCHOR=${2:-}
ISL_MS=${3:-5}
if [ -z "$NS3DIR" ] || [ -z "$ANCHOR" ]; then
    echo "usage: $0 <ns3-dir> <single-isl|hop-delay> [isl-delay-ms]" >&2
    exit 2
fi

ANCHORS_FILE="$(cd "$(dirname "$0")" && pwd)/anchors.yml"

floor_for() {
    awk -F': *' -v k="$1" \
        '$1 == k { print $2 + 0; found = 1 } END { if (!found) exit 1 }' \
        "$ANCHORS_FILE"
}

# isl-grid --csv row:
#   protocol,runs,rows,cols,nodes,links,isl_delay_ms,flows,pdr_pct,delay_ms,...
# so PDR is field 9 and mean delay field 10.
csv_field() {  # csv_field <proto> <n>
    awk -F, -v p="$1" -v n="$2" '$1 == p { v = $n } END { print v }'
}

case "$ANCHOR" in
    single-isl)
        # S1 — two satellites, one ISL, nothing to route around. A
        # point-to-point link has no contention and no loss model, so anything
        # below 100% means the stack is broken, not the topology hard. This is
        # the ISL analogue of check-anchors.sh's single-hop anchor.
        #
        # 1x2 open grid = exactly 1 link (AxisLinks(2,false) = 1), asserted by
        # the example's own CheckTopology (#226).
        args="--rows=1 --cols=2 --torus=false --flows=1 --time=30 --islDelayMs=$ISL_MS"
        proto=aodv
        expect_desc="PDR >= $(floor_for sat_single_isl_pdr_min)"
        ;;
    hop-delay)
        # S2 — the hop-count delay identity, the strongest single number the
        # satellite harness produces. On a 4x4 torus the wrap makes opposite
        # corners near neighbours: node 0 (0,0) -> node 15 (3,3) is
        # min(3, 4-3) = 1 step in each dimension, so h = 2 for both default
        # flows. With a uniform per-ISL delay d the mean end-to-end delay must
        # be h*d + s, where s is serialisation/queueing (small, bounded).
        #
        # The lower bound is the interesting half: a packet CANNOT arrive
        # faster than propagation, so delay < h*d is physically impossible and
        # means the delay is not being applied (the #200 unknown) or the
        # topology is not what it claims (#226).
        args="--rows=4 --cols=4 --torus=true --flows=2 --time=30 --islDelayMs=$ISL_MS"
        proto=anthocnet
        expect_desc="delay in [h*d, h*d + slack] with h=2, d=$ISL_MS ms"
        ;;
    *)
        echo "unknown anchor '$ANCHOR' (want: single-isl | hop-delay)" >&2
        exit 2
        ;;
esac

cmd="isl-grid --csv --protocols=$proto $args"
echo "[sat:$ANCHOR] ./ns3 run \"$cmd\"  (gate: $expect_desc)"
cd "$NS3DIR"
if ! out=$(./ns3 run "$cmd" 2>&1); then
    printf '%s\n' "$out" | tail -n 40
    echo "FAIL [sat:$ANCHOR]: isl-grid did not run (output tail above)"
    exit 1
fi
printf '%s\n' "$out"

pdr=$(printf '%s\n' "$out" | csv_field "$proto" 9)
delay=$(printf '%s\n' "$out" | csv_field "$proto" 10)
if [ -z "$pdr" ]; then
    echo "FAIL [sat:$ANCHOR]: no CSV row for '$proto' — empty result (#28-style silent failure)"
    exit 1
fi

case "$ANCHOR" in
    single-isl)
        floor=$(floor_for sat_single_isl_pdr_min)
        if awk -v v="$pdr" -v f="$floor" 'BEGIN { exit (v + 0 >= f + 0) ? 0 : 1 }'; then
            echo "PASS [sat:single-isl] $proto PDR=$pdr >= $floor (delay=${delay} ms)"
        else
            echo "FAIL [sat:single-isl] $proto PDR=$pdr < floor $floor"
            echo "  A point-to-point ISL is lossless and uncontended, so this floor can only"
            echo "  regress via the link/IP/app stack or the substrate — not via the protocol."
            echo "  cf. #51, and see docs/benchmarks/methodology.md 'Satellite validation anchors'."
            exit 1
        fi
        ;;
    hop-delay)
        hops=2
        slack=$(floor_for sat_hop_delay_slack_ms)
        lo=$(awk -v h="$hops" -v d="$ISL_MS" 'BEGIN { print h * d }')
        hi=$(awk -v l="$lo" -v s="$slack" 'BEGIN { print l + s }')
        # Delivery must still be complete, or the delay is an average over a
        # surviving subset and means nothing.
        floor=$(floor_for sat_single_isl_pdr_min)
        if ! awk -v v="$pdr" -v f="$floor" 'BEGIN { exit (v + 0 >= f + 0) ? 0 : 1 }'; then
            echo "FAIL [sat:hop-delay] $proto PDR=$pdr < $floor — delay average is over a subset"
            exit 1
        fi
        if awk -v v="$delay" -v l="$lo" 'BEGIN { exit (v + 0 >= l + 0) ? 0 : 1 }'; then
            :
        else
            echo "FAIL [sat:hop-delay] delay=${delay} ms < ${lo} ms — FASTER THAN PROPAGATION."
            echo "  ${hops} hops x ${ISL_MS} ms is a physical lower bound. Below it, either the"
            echo "  channel delay is not being applied (#200) or the topology is not the"
            echo "  ${hops}-hop path it claims (#226)."
            exit 1
        fi
        if awk -v v="$delay" -v h="$hi" 'BEGIN { exit (v + 0 <= h + 0) ? 0 : 1 }'; then
            echo "PASS [sat:hop-delay] delay=${delay} ms in [${lo}, ${hi}] for h=${hops} d=${ISL_MS} (PDR=$pdr)"
        else
            echo "FAIL [sat:hop-delay] delay=${delay} ms > ${hi} ms — more than serialisation slack"
            echo "  above the ${lo} ms propagation floor. Either routing is not taking the"
            echo "  ${hops}-hop path (torus wrap wrong, or a routing regression), or packets are"
            echo "  being queued/held — check the hold-time diagnostics."
            exit 1
        fi
        ;;
esac
