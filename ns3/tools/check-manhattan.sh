#!/usr/bin/env bash
# Manhattan-grid / urban-channel smoke (#488, the VANET family #301): prove
# --mobility=manhattan really keeps vehicles on the street grid, that the
# urban channel's buildings really cut links, that every arm routes there, and
# that the combinations which cannot be honoured are refused.
#
# Usage: check-manhattan.sh <ns3-dir>
#
# Why each assertion exists:
#
# 1. Every vehicle on a street at t=0 AND mid-run, from the harness's own
#    `# road` diagnostic (printed under --diag on a manhattan run): the
#    distance from each node to the nearest street centre line must be ~0.
#    The mid-run sample is the load-bearing one -- a model that placed nodes
#    on streets and then drove them across blocks would pass a t=0-only check
#    (the #480 lesson, recorded in check-3d-field.sh).
# 2. Non-zero delivery for every arm on the urban channel. The oracle's
#    delivery shows the street network is connected through the buildings
#    before AntHocNet is judged on it.
# 3. The oracle reads the urban chain per pair: its ##ORACLE## mode names
#    decode-los-approx, and it keeps strictly fewer edges than on the same
#    field under plain tworay -- buildings only remove links.
# 4. ##CONFIG## names the grid (blocksX/blocksY, streetWidth), so a VANET run
#    is self-describing.
# 5. Determinism: the same seed twice is byte-identical. The grid schedule
#    adds a pinned stream; an unpinned one would slip past the planar gate.
# 6. Refusals: urban without manhattan, manhattan with a 3-D field, manhattan
#    with speedMin 0, a street wider than a block.
#
# Runs on one matrix version (3.42), like the other scenario gates.
set -euo pipefail

NS3DIR=${1:?usage: check-manhattan.sh <ns3-dir>}
cd "$NS3DIR"

fail=0
say() { printf '%s\n' "$*"; }

ARMS=anthocnet,aodv,olsr,dsdv,aomdv,gpsr,oracle
GRID="--nNodes=30 --area=1000 --blocksX=5 --blocksY=5 --mobility=manhattan
      --speedMin=10 --speed=20 --flows=4 --runs=1 --time=60"

# --- 1-5: the urban run ----------------------------------------------------
args="anthocnet-compare --csv --diag --protocols=$ARMS $GRID --propagation=urban"
out=$(./ns3 run "$(echo $args)" 2>/dev/null)
printf '%s\n' "$out" | grep -E '^# road|^##ORACLE##|^##CONFIG## scenario|^(anthocnet|aodv|olsr|dsdv|aomdv|gpsr|oracle),' || true

road=$(printf '%s\n' "$out" | grep '^# road' || true)
if [ -z "$road" ]; then
    say "FAIL: no '# road' lines: the street diagnostic or the manhattan path is missing"
    fail=1
else
    n_mid=$(printf '%s\n' "$road" | grep -vc ' t=0.000 ' || true)
    if [ "$n_mid" -lt 1 ]; then
        say "FAIL: no mid-run '# road' sample: only t=0 was checked"
        fail=1
    fi
    bad=$(printf '%s\n' "$road" | awk '{
            for (i = 1; i <= NF; ++i)
                if ($i ~ /^offStreetMaxM=/) { sub(/^offStreetMaxM=/, "", $i); m = $i }
            if (m + 0 > 0.01) print
          }')
    if [ -n "$bad" ]; then
        say "FAIL: a vehicle left the street grid:"
        say "$bad"
        fail=1
    fi
fi

for arm in ${ARMS//,/ }; do
    pdr=$(printf '%s\n' "$out" | awk -F, -v a="$arm" '$1==a{print $7}')
    say "$arm urban PDR% = ${pdr:-<none>}"
    awk -v p="${pdr:-0}" 'BEGIN { exit (p+0 > 0) ? 0 : 1 }' \
        || { say "FAIL: $arm delivered nothing on the urban Manhattan field"; fail=1; }
done

printf '%s\n' "$out" | grep -q '^##ORACLE## .* mode=[^ ]*decode-los-approx' \
    || { say "FAIL: the oracle did not use the per-pair urban rule (mode decode-los-approx)"; fail=1; }

printf '%s\n' "$out" | grep -q '^##CONFIG## .* blocksX=5 blocksY=5 .*streetWidth=20' \
    || { say "FAIL: ##CONFIG## does not name the grid (blocksX/blocksY/streetWidth)"; fail=1; }

edges() {  # mean of the oracle's edges= field over its ##ORACLE## lines
    awk '/^##ORACLE##/{for(i=1;i<=NF;++i) if($i~/^edges=/){sub(/^edges=/,"",$i); s+=$i; n++}}
         END{if(n) printf "%.1f", s/n}'
}
e_urban=$(printf '%s\n' "$out" | edges)
tworay=$(./ns3 run "anthocnet-compare --csv --protocols=oracle $(echo $GRID) --propagation=tworay" 2>/dev/null)
e_tworay=$(printf '%s\n' "$tworay" | edges)
say "oracle edges: urban=${e_urban:-<none>} tworay=${e_tworay:-<none>}"
awk -v u="${e_urban:-0}" -v t="${e_tworay:-0}" 'BEGIN { exit (u > 0 && u < t) ? 0 : 1 }' \
    || { say "FAIL: buildings removed no links (urban edges must be > 0 and < tworay edges)"; fail=1; }

again=$(./ns3 run "$(echo $args)" 2>/dev/null)
if [ "$out" = "$again" ]; then
    say "ok: urban manhattan run is byte-identical on the same seed"
else
    say "FAIL: urban manhattan run differs between two same-seed invocations:"
    diff <(printf '%s\n' "$out") <(printf '%s\n' "$again") | head -10
    fail=1
fi

# --- 6: refusals ------------------------------------------------------------
refuse() {  # <expected message fragment> <harness args...>
    local want=$1; shift
    local log rc
    set +e
    log=$(./ns3 run "anthocnet-compare --time=5 --nNodes=4 --flows=1 $*" 2>&1)
    rc=$?
    set -e
    if [ "$rc" -ne 0 ] && printf '%s\n' "$log" | grep -qF -- "$want"; then
        say "ok: refused ($*)"
    else
        say "FAIL: not refused with '$want' (rc=$rc): $*"
        printf '%s\n' "$log" | tail -3
        fail=1
    fi
}
refuse "--propagation=urban needs --mobility=manhattan" --protocols=anthocnet --propagation=urban
refuse "--mobility=manhattan with --areaZ"   --protocols=anthocnet --mobility=manhattan --areaZ=100 --range=250
refuse "--mobility=manhattan needs --speedMin > 0" --protocols=anthocnet --mobility=manhattan --speedMin=0
refuse "narrower than a block"               --protocols=anthocnet --mobility=manhattan --propagation=urban --area=500 --streetWidth=200

if [ "$fail" -ne 0 ]; then
    say "Manhattan/urban smoke: FAIL"
    exit 1
fi
say "Manhattan/urban smoke: PASS"
