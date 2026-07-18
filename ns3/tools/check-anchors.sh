#!/usr/bin/env bash
# Validation-anchor gate (#59): run a known-expected scenario on the *stock*
# baselines harness (manet-baselines — no AntHocNet code in the binary) and
# fail if PDR falls below the floor in anchors.yml. This is the enforcement
# half of docs/benchmarks.md "Validation anchors": a channel/PHY/harness
# regression (like the #51 IdealWifiManager ~50% single-hop loss) fails CI
# loudly instead of silently corrupting every published number.
#
# Usage: check-anchors.sh <ns3-dir> <single-hop|broch-low-mobility>
#
# The ns-3 tree must already be configured + built with the anthocnet module's
# examples enabled (manet-baselines builds as part of the module's examples).
set -euo pipefail

NS3DIR=${1:-}
ANCHOR=${2:-}
if [ -z "$NS3DIR" ] || [ -z "$ANCHOR" ]; then
    echo "usage: $0 <ns3-dir> <single-hop|broch-low-mobility>" >&2
    exit 2
fi

ANCHORS_FILE="$(cd "$(dirname "$0")" && pwd)/anchors.yml"

floor_for() {
    # "key: 99.0  # comment" -> 99 (the "+0" strips any trailing comment).
    awk -F': *' -v k="$1" \
        '$1 == k { print $2 + 0; found = 1 } END { if (!found) exit 1 }' \
        "$ANCHORS_FILE"
}

case "$ANCHOR" in
    single-hop)
        # 2 nodes, 50x50 m, 300 m disk range, static (pause=900 speed=1):
        # every packet is one in-range hop, so the stack itself must deliver
        # ~everything. AODV (reactive, buffers during route discovery) and
        # DSDV (proactive, buffers until the first periodic update) both read
        # 100.0% post-#51; OLSR is excluded because its multi-second neighbor
        # sensing loses early packets on a short run (startup artefact, not a
        # channel property).
        args="--nNodes=2 --areaX=50 --areaY=50 --range=300 --pause=900 --speed=1 --time=60 --runs=1"
        protocols="aodv,dsdv"
        floor=$(floor_for single_hop_pdr_min)
        ;;
    broch-low-mobility)
        # Broch/Perkins 1500x300 m 50-node field (--scenario=paper) at
        # near-static mobility: the literature calibration target — stock
        # AODV delivers ~90-100% here (Broch et al., MobiCom 1998).
        args="--scenario=paper --pause=900 --speed=1 --time=300 --runs=2"
        protocols="aodv"
        floor=$(floor_for broch_low_mobility_aodv_pdr_min)
        ;;
    *)
        echo "unknown anchor '$ANCHOR' (want: single-hop | broch-low-mobility)" >&2
        exit 2
        ;;
esac

cmd="manet-baselines $args --protocols=$protocols"
echo "[$ANCHOR] ./ns3 run \"$cmd\"  (gate: PDR >= $floor)"
cd "$NS3DIR"
if ! out=$(./ns3 run "$cmd" 2>&1); then
    printf '%s\n' "$out" | tail -n 40
    echo "FAIL [$ANCHOR]: manet-baselines did not run (output tail above)"
    exit 1
fi
printf '%s\n' "$out"

status=0
for proto in ${protocols//,/ }; do
    # Summary-table row: "<proto>  <PDR%>  <delay> ...". Diag lines never
    # start with a bare protocol name, so this only matches the table.
    pdr=$(printf '%s\n' "$out" |
          awk -v p="$proto" '$1 == p && $2 ~ /^[0-9.]+$/ { v = $2 } END { print v }')
    if [ -z "$pdr" ]; then
        echo "FAIL [$ANCHOR]: no result row for '$proto' — empty table (#28-style silent failure)"
        status=1
    elif awk -v v="$pdr" -v f="$floor" 'BEGIN { exit (v + 0 >= f + 0) ? 0 : 1 }'; then
        echo "PASS [$ANCHOR] $proto PDR=$pdr >= $floor"
    else
        echo "FAIL [$ANCHOR] $proto PDR=$pdr < floor $floor — validation anchor regressed."
        echo "  A drop here means the harness/channel/PHY config broke (cf. #51), not a"
        echo "  protocol property. See docs/benchmarks.md 'Validation anchors' and #59;"
        echo "  thresholds live in ns3/tools/anchors.yml."
        status=1
    fi
done
exit $status
