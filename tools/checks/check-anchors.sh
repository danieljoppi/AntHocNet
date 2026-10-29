#!/usr/bin/env bash
# SPDX-License-Identifier: MIT OR GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
# Validation-anchor gate (#59): run a known-expected scenario on the *stock*
# baselines harness (manet-baselines — no AntHocNet code in the binary) and
# fail if PDR falls below the floor in anchors.yml. This is the enforcement
# half of docs/benchmarks/methodology.md "Validation anchors": a channel/PHY/harness
# regression (like the #51 IdealWifiManager ~50% single-hop loss) fails CI
# loudly instead of silently corrupting every published number.
#
# Usage: check-anchors.sh <ns3-dir> <single-hop|broch-low-mobility|fanet-single-hop-3d|fanet-vertical-3d|vanet-single-hop|vanet-building|vanet-gpcr-vs-gpsr|fanet-gpsr3d-recovery|mesh-hwmp-shortest>
#
# The two fanet-* anchors (#482) and the two vanet-* anchors (#488) run on
# anthocnet-compare instead, because manet-baselines has neither a 3-D field
# nor a street grid; they still route only stock AODV and the oracle control,
# so no AntHocNet code is under test. mesh-hwmp-shortest (#708) runs there too,
# with stock 802.11s HWMP and the oracle.
#
# The ns-3 tree must already be configured + built with the anthocnet module's
# examples enabled (manet-baselines builds as part of the module's examples).
set -euo pipefail

NS3DIR=${1:-}
ANCHOR=${2:-}
if [ -z "$NS3DIR" ] || [ -z "$ANCHOR" ]; then
    echo "usage: $0 <ns3-dir> <single-hop|broch-low-mobility|fanet-single-hop-3d|fanet-vertical-3d|vanet-single-hop|vanet-building|vanet-gpcr-vs-gpsr|fanet-gpsr3d-recovery|mesh-hwmp-shortest>" >&2
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
stretch_arm=""
stretch_max=""
gap_arm=""
gap_base=""
gap_min=""
gap_base_args=""
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
    vanet-gpcr-vs-gpsr)
        # #709, GPCR's own paper trend: on a city grid GPCR delivers more than
        # GPSR, whose planar perimeter mode breaks where buildings block the
        # corners (Lochert et al., MC2R 2005, section V, Fig. 4). The
        # vanet-building block: a 180 x 180 m building, so vehicles on
        # opposite streets must relay around a corner. GPCR must beat GPSR
        # by a margin on the same seeds. Measured at this exact invocation
        # (after the #717 fix): ns-3.42 GPCR 89.3 %, GPSR 84.4 % (+4.9 pp),
        # oracle 99.6 %; ns-3.48 90.3 / 85.5 (+4.8).
        harness=anthocnet-compare
        args="--scenario=vanet --nNodes=20 --area=280 --blocksX=1 --blocksY=1 --streetWidth=100 --flows=4 --time=120 --runs=2"
        protocols="gpsr,gpcr,oracle"
        floor=$(floor_for vanet_gpcr_pdr_min)
        gap_arm=gpcr
        gap_base=gpsr
        gap_min=$(floor_for vanet_gpcr_minus_gpsr_pp_min)
        ;;
    fanet-gpsr3d-recovery)
        # #710, the 3-D geographic arm's own paper trend (Bujari, Palazzi &
        # Ronzani, IEEE TMC 2018, section 5.2): on a static, lightly loaded
        # 3-D field, greedy forwarding alone delivers least, because packets
        # stall in local minima, and adding face recovery delivers more. The
        # same arm runs twice on the same seeds: with CFace(3) recovery (as
        # shipped) and with Recovery=false (pure 3-D greedy). Measured at this
        # exact invocation: ns-3.42 74.9 % vs 62.5 % (+12.4 pp) with the
        # oracle at 74.9 % (the field's partition bound); ns-3.48 74.7 vs 62.2.
        harness=anthocnet-compare
        args="--nNodes=50 --areaX=600 --areaY=600 --areaZ=600 --range=200 --pause=900 --speed=1 --flows=2 --cbrBps=512 --time=120 --runs=4"
        protocols="gpsr3d,oracle"
        floor=$(floor_for fanet_gpsr3d_pdr_min)
        gap_arm=gpsr3d
        gap_base=gpsr3d
        gap_base_args="--ns3::gpsr::RoutingProtocol::Recovery=false"
        gap_min=$(floor_for fanet_gpsr3d_recovery_pp_min)
        ;;
    mesh-hwmp-shortest)
        # #708, the static mesh's HWMP anchor, analytic like the FANET/VANET
        # ones. On a static, connected disk field at one fixed rate, HWMP's
        # airtime metric is the same for every link, so the path it converges
        # to is a minimum-hop path: its mean hop count must sit at the
        # oracle's shortest path and can never be below it. Below it means the
        # arm saw a different topology (the #708 stream-pairing defect read
        # 5 hops against the oracle's 6); far above it means path selection is
        # not converging. 16 nodes, 500 m field, 175 m range (the delivery
        # smoke's field), on the 802.11a radio stock 802.11s runs on.
        # Measured at this exact invocation on ns-3.42: HWMP 98.2 % at
        # hopsMean 4.73, oracle 100.0 % at 4.50 (stretch 1.05; 1.04 on 3.48).
        harness=anthocnet-compare
        args="--nNodes=16 --areaX=500 --areaY=500 --range=175 --pause=900 --speed=1 --flows=2 --time=120 --runs=2 --standard=80211a --rateManager=constant6 --diag"
        protocols="hwmp,oracle"
        floor=$(floor_for mesh_hwmp_pdr_min)
        stretch_arm=hwmp
        stretch_max=$(floor_for mesh_hwmp_stretch_max)
        ;;
    *)
        echo "unknown anchor '$ANCHOR' (want: single-hop | broch-low-mobility | fanet-single-hop-3d | fanet-vertical-3d | vanet-single-hop | vanet-building | vanet-gpcr-vs-gpsr | fanet-gpsr3d-recovery | mesh-hwmp-shortest)" >&2
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
if [ -n "$gap_arm" ]; then
    # Paired PDR gap on the same seeds, from the summary table.
    table_pdr() {
        printf '%s\n' "$out" |
            awk -v p="$1" '$1 == p && $2 ~ /^[0-9.]+$/ { v = $2 } END { print v }'
    }
    ga=$(table_pdr "$gap_arm")
    gb=$(table_pdr "$gap_base")
    if [ -n "$gap_base_args" ]; then
        # The reference is the same arm under other attributes: its own run.
        bcmd="$harness $args $gap_base_args --protocols=$gap_base"
        echo "[$ANCHOR] reference: ./ns3 run \"$bcmd\""
        if ! bout=$(./ns3 run "$bcmd" 2>&1); then
            printf '%s\n' "$bout" | tail -n 40
            echo "FAIL [$ANCHOR]: reference run did not complete"
            exit 1
        fi
        gb=$(printf '%s\n' "$bout" |
             awk -v p="$gap_base" '$1 == p && $2 ~ /^[0-9.]+$/ { v = $2 } END { print v }')
        gap_base="$gap_base ($gap_base_args)"
    fi
    if [ -z "$ga" ] || [ -z "$gb" ]; then
        echo "FAIL [$ANCHOR]: no result row for $gap_arm or $gap_base"
        status=1
    elif awk -v a="$ga" -v b="$gb" -v m="$gap_min" 'BEGIN { exit (a - b >= m + 0) ? 0 : 1 }'; then
        echo "PASS [$ANCHOR] $gap_arm PDR=$ga - $gap_base PDR=$gb >= $gap_min pp"
    else
        echo "FAIL [$ANCHOR] $gap_arm PDR=$ga - $gap_base PDR=$gb < $gap_min pp: the paper's trend"
        echo "  (the junction-aware arm beats GPSR around a blocked corner) does not reproduce."
        status=1
    fi
fi
if [ -n "$stretch_arm" ]; then
    # An arm's mean hop count over the oracle's, on the same seeds and the same
    # field: 1.00 is a shortest path for every delivered packet.
    mean_hops() {
        printf '%s\n' "$out" |
            awk -v p="$1" '$1 == "#" && $2 == "paths" && $3 == p {
                     for (i = 4; i <= NF; i++) if ($i ~ /^hopsMean=/) { sub(/^hopsMean=/, "", $i); v = $i } }
                 END { print v }'
    }
    ah=$(mean_hops "$stretch_arm")
    oh=$(mean_hops oracle)
    if [ -z "$ah" ] || [ -z "$oh" ]; then
        echo "FAIL [$ANCHOR]: no '# paths' hopsMean line for $stretch_arm or the oracle"
        status=1
    elif ! awk -v a="$ah" -v o="$oh" -v m="$stretch_max" \
            'BEGIN { exit (o + 0 > 0 && a + 0 >= o + 0 && a / o <= m + 0) ? 0 : 1 }'; then
        echo "FAIL [$ANCHOR] $stretch_arm hopsMean=$ah vs oracle $oh: outside [1.00, $stretch_max] x the shortest path"
        echo "  Below 1.00 the arm ran on a different topology than the oracle (stream pairing);"
        echo "  above $stretch_max its path selection is not converging to a shortest path."
        status=1
    else
        echo "PASS [$ANCHOR] $stretch_arm hopsMean=$ah within [1.00, $stretch_max] x oracle $oh"
    fi
fi
exit $status
