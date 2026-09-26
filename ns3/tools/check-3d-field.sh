#!/usr/bin/env bash
# 3-D field smoke (#480): prove --areaZ really places AND moves nodes in a 3-D
# box, that routing still works there, and that every arm which cannot honour
# a 3-D field is refused rather than silently flattened.
#
# Usage: check-3d-field.sh <ns3-dir>
#
# Why each assertion exists:
#
# 1. Altitude spread at t=0 AND at mid-run, from the harness's own `# geom`
#    diagnostic (printed only under --diag on a 3-D run). The mid-run sample
#    is the load-bearing one. While #480 was being written, the placement was
#    3-D but the Gauss-Markov Bounds box kept a zero z extent. ns-3's
#    UpdateWithBounds then clamped every node to z = 0 on its first step, so
#    t=0 read 11-189 m and t=30 read -0.3-0.8 m. A check of placement alone
#    would have passed a run that was planar for all but its first second.
# 2. Non-zero delivery for AntHocNet and the oracle on that field. The oracle
#    reads its adjacency from 3-D distances, so its delivery shows the field
#    is connected before AntHocNet is judged on it.
# 3. ##CONFIG## names areaZ, so a 3-D run is self-describing. (Planar runs
#    omit the key and stay byte-identical to the published corpus; the
#    determinism and seed-independence gates cover that side.)
# 4. Both 3-D mobility models (gaussmarkov and rwp), and every arm that
#    accepts a 3-D field (all but gpsr), must deliver. The planar arm-delivery
#    gate (#429) says nothing about 3-D, and a baseline that routes in the
#    plane but not in a volume is exactly what that gate exists to catch.
# 5. Determinism in 3-D: the same seed twice must be byte-identical. The 3-D
#    placement adds a third random variable to the allocator; an unpinned
#    stream there would slip past the planar determinism gate entirely.
# 6. Five refusals: tworay, nakagami, ssrwp and gpsr under --areaZ > 0, and a
#    negative --areaZ. Each must exit non-zero with its own message, not
#    produce a plausible run of the wrong geometry.
#
# Runs on one matrix version (3.42), like the other scenario gates.
set -euo pipefail

NS3DIR=${1:?usage: check-3d-field.sh <ns3-dir>}
cd "$NS3DIR"

AREA_Z=200
fail=0
say() { printf '%s\n' "$*"; }

# Every arm that accepts a 3-D field. gpsr is refused (below), so it is the
# one arm absent here.
ARMS=anthocnet,aodv,olsr,dsdv,aomdv,oracle

for MOB in gaussmarkov rwp; do
say "== --mobility=$MOB, --areaZ=$AREA_Z"
# --- 1-4: the 3-D run -------------------------------------------------------
args="anthocnet-compare --csv --diag --protocols=$ARMS --nNodes=20
      --time=60 --area=500 --areaZ=$AREA_Z --range=250 --flows=3 --runs=1
      --mobility=$MOB --speed=20"
out=$(./ns3 run "$(echo $args)" 2>/dev/null)
printf '%s\n' "$out" | grep -E '^# geom|^##CONFIG## scenario|^(anthocnet|aodv|olsr|dsdv|aomdv|oracle),' || true

# Every `# geom` line (both arms, t=0 and mid-run) must span at least a quarter
# of the box vertically. Failure-to-find is failure: no geom lines at all means
# the diagnostic (or the 3-D path) is gone.
geom=$(printf '%s\n' "$out" | grep '^# geom' || true)
if [ -z "$geom" ]; then
    say "FAIL: no '# geom' lines: the 3-D diagnostic or the --areaZ path is missing"
    fail=1
else
    n_mid=$(printf '%s\n' "$geom" | grep -vc ' t=0.00 ' || true)
    if [ "$n_mid" -lt 1 ]; then
        say "FAIL: no mid-run '# geom' sample: only t=0 was checked"
        fail=1
    fi
    bad=$(printf '%s\n' "$geom" | awk -v z="$AREA_Z" '{
            for (i = 1; i <= NF; ++i) {
                if ($i ~ /^zMin=/) { sub(/^zMin=/, "", $i); lo = $i }
                if ($i ~ /^zMax=/) { sub(/^zMax=/, "", $i); hi = $i }
            }
            if (hi - lo < z / 4) print
          }')
    if [ -n "$bad" ]; then
        say "FAIL: altitude span below areaZ/4, so the field was flattened:"
        say "$bad"
        fail=1
    fi
fi

for arm in ${ARMS//,/ }; do
    pdr=$(printf '%s\n' "$out" | awk -F, -v a="$arm" '$1==a{print $7}')
    say "$arm 3-D ($MOB) PDR% = ${pdr:-<none>}"
    awk -v p="${pdr:-0}" 'BEGIN { exit (p+0 > 0) ? 0 : 1 }' \
        || { say "FAIL: $arm delivered nothing on the 3-D $MOB field"; fail=1; }
done

printf '%s\n' "$out" | grep -q "^##CONFIG## .* areaZ=$AREA_Z " \
    || { say "FAIL: ##CONFIG## does not name areaZ=$AREA_Z"; fail=1; }

# --- 5: determinism in 3-D ----------------------------------------------------
again=$(./ns3 run "$(echo $args)" 2>/dev/null)
if [ "$out" = "$again" ]; then
    say "ok: 3-D $MOB run is byte-identical on the same seed"
else
    say "FAIL: 3-D $MOB run differs between two same-seed invocations:"
    diff <(printf '%s\n' "$out") <(printf '%s\n' "$again") | head -10
    fail=1
fi
done

# --- 4: refusals ----------------------------------------------------------------
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
refuse "--propagation=tworay with --areaZ"    --protocols=anthocnet --areaZ=100 --propagation=tworay
refuse "--propagation=nakagami with --areaZ"  --protocols=anthocnet --areaZ=100 --propagation=nakagami
refuse "--mobility=ssrwp with --areaZ"        --protocols=anthocnet --areaZ=100 --range=250 --mobility=ssrwp
refuse "--protocols includes gpsr with --areaZ" --protocols=anthocnet,gpsr --areaZ=100 --range=250
refuse "--areaZ must be >= 0"                 --protocols=anthocnet --areaZ=-5

if [ "$fail" -ne 0 ]; then
    say "3-D field smoke: FAIL"
    exit 1
fi
say "3-D field smoke: PASS"
