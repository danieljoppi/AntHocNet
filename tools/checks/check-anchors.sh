#!/usr/bin/env bash
# Validation-anchor gate (#59): run a known-expected scenario on the *stock*
# baselines harness (manet-baselines — no AntHocNet code in the binary) and
# fail if PDR falls below the floor in anchors.yml. This is the enforcement
# half of docs/benchmarks/methodology.md "Validation anchors": a channel/PHY/harness
# regression (like the #51 IdealWifiManager ~50% single-hop loss) fails CI
# loudly instead of silently corrupting every published number.
#
# Usage: check-anchors.sh <ns3-dir> <single-hop|broch-low-mobility|fanet-single-hop-3d|fanet-vertical-3d|vanet-single-hop|vanet-building>
#
# The two fanet-* anchors (#482) and the two vanet-* anchors (#488) run on
# anthocnet-compare instead, because manet-baselines has neither a 3-D field
# nor a street grid; they still route only stock AODV and the oracle control,
# so no AntHocNet code is under test.
#
# The ns-3 tree must already be configured + built with the anthocnet module's
# examples enabled (manet-baselines builds as part of the module's examples).
set -euo pipefail

NS3DIR=${1:-}
ANCHOR=${2:-}
if [ -z "$NS3DIR" ] || [ -z "$ANCHOR" ]; then
    echo "usage: $0 <ns3-dir> <single-hop|broch-low-mobility|fanet-single-hop-3d|fanet-vertical-3d|vanet-single-hop|vanet-building>" >&2
    exit 2
fi

ANCHORS_FILE="$(cd "$(dirname "$0")/../../ns3/tools" && pwd)/anchors.yml"

floor_for() {
    # "key: 99.0  # comment" -> 99 (the "+0" strips any trailing comment).
    awk -F': *' -v k="$1" \
        '$1 == k { print $2 + 0; found = 1 } END { if (!found) exit 1 }' \
        "$ANCHORS_FILE"
}

harness=manet-baselines
hops_min=""
hops_max=""
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
    fanet-single-hop-3d)
        # #482, the FANET family's analytic anchor: the --scenario=fanet preset
        # (Gauss-Markov, 10-30 m/s, 3-D) shrunk to a 100 m cube with the
        # preset's 350 m range. The cube's diagonal is 173 m, so every pair is
        # in range at every instant: each flow is exactly one hop. Closed form:
        # stock AODV must deliver ~everything (as on the planar single-hop
        # anchor) and the oracle's mean hop count must be exactly 1.00. A 3-D
        # placement, mobility or channel regression breaks one or the other.
        harness=anthocnet-compare
        args="--scenario=fanet --nNodes=10 --areaX=100 --areaY=100 --areaZ=100 --range=350 --time=120 --runs=2"
        protocols="aodv,oracle"
        floor=$(floor_for fanet_single_hop_3d_pdr_min)
        hops_max=$(floor_for fanet_single_hop_3d_oracle_hops_max)
        ;;
    fanet-vertical-3d)
        # #482, the check that altitude is honoured: a 10 x 10 x 1000 m column
        # at 350 m range. Planar distances are all < 15 m, so a field collapsed
        # to 2-D reads exactly 1.00 oracle hops; with z honoured, pairs more
        # than 350 m apart in altitude need relays (measured 1.90 at 2 runs).
        harness=anthocnet-compare
        args="--scenario=fanet --nNodes=10 --areaX=10 --areaY=10 --areaZ=1000 --range=350 --time=120 --runs=2"
        protocols="aodv,oracle"
        floor=$(floor_for fanet_vertical_3d_pdr_min)
        hops_min=$(floor_for fanet_vertical_3d_oracle_hops_min)
        ;;
    vanet-single-hop)
        # #488, the VANET family's analytic anchor: --scenario=vanet shrunk to
        # one 280 x 280 m block whose building is 1 m wide (street width
        # 279 m). The block diagonal, 396 m, is inside the two-ray decode
        # radius (423.3 m) and no line of sight is blocked, so every flow is
        # one hop: AODV must deliver ~everything and the oracle's mean hop
        # count must be 1.00. A street-grid, mobility or channel regression
        # breaks one or the other.
        harness=anthocnet-compare
        args="--scenario=vanet --nNodes=20 --area=280 --blocksX=1 --blocksY=1 --streetWidth=279 --flows=4 --time=120 --runs=2"
        protocols="aodv,oracle"
        floor=$(floor_for vanet_single_hop_pdr_min)
        hops_max=$(floor_for vanet_single_hop_oracle_hops_max)
        ;;
    vanet-building)
        # #488, the check that buildings are honoured: the same block with a
        # 180 x 180 m building (street width 100 m). Vehicles on opposite
        # streets lose line of sight and relay around a corner, so the
        # oracle's mean hop count must exceed 1.2; a channel that ignored the
        # building reads the single-hop 1.00 (measured 1.34).
        harness=anthocnet-compare
        args="--scenario=vanet --nNodes=20 --area=280 --blocksX=1 --blocksY=1 --streetWidth=100 --flows=4 --time=120 --runs=2"
        protocols="aodv,oracle"
        floor=$(floor_for vanet_building_pdr_min)
        hops_min=$(floor_for vanet_building_oracle_hops_min)
        ;;
    *)
        echo "unknown anchor '$ANCHOR' (want: single-hop | broch-low-mobility | fanet-single-hop-3d | fanet-vertical-3d | vanet-single-hop | vanet-building)" >&2
        exit 2
        ;;
esac

cmd="$harness $args --protocols=$protocols"
echo "[$ANCHOR] ./ns3 run \"$cmd\"  (gate: PDR >= $floor)"
cd "$NS3DIR"
if ! out=$(./ns3 run "$cmd" 2>&1); then
    printf '%s\n' "$out" | tail -n 40
    echo "FAIL [$ANCHOR]: $harness did not run (output tail above)"
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
        echo "  protocol property. See docs/benchmarks/methodology.md 'Validation anchors' and #59;"
        echo "  thresholds live in ns3/tools/anchors.yml."
        status=1
    fi
done
if [ -n "$hops_min$hops_max" ]; then
    # "# paths oracle ... hopsMean=1.00 ..." — the oracle's shortest-path hop
    # count over its delivered packets, deterministic for a given seed set.
    hops=$(printf '%s\n' "$out" |
           awk '$1 == "#" && $2 == "paths" && $3 == "oracle" {
                    for (i = 4; i <= NF; i++) if ($i ~ /^hopsMean=/) { sub(/^hopsMean=/, "", $i); v = $i } }
                END { print v }')
    if [ -z "$hops" ]; then
        echo "FAIL [$ANCHOR]: no '# paths oracle' hopsMean line"
        status=1
    elif [ -n "$hops_max" ] && ! awk -v v="$hops" -v m="$hops_max" 'BEGIN { exit (v + 0 <= m + 0) ? 0 : 1 }'; then
        echo "FAIL [$ANCHOR] oracle hopsMean=$hops > $hops_max — a fully connected field routed over relays"
        status=1
    elif [ -n "$hops_min" ] && ! awk -v v="$hops" -v m="$hops_min" 'BEGIN { exit (v + 0 >= m + 0) ? 0 : 1 }'; then
        echo "FAIL [$ANCHOR] oracle hopsMean=$hops < $hops_min — the field's altitude is not being honoured"
        status=1
    else
        echo "PASS [$ANCHOR] oracle hopsMean=$hops within [${hops_min:-0}, ${hops_max:-inf}]"
    fi
fi
exit $status
