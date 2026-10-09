#!/usr/bin/env bash
# Moving-constellation smoke (#192/#297, ADR-0022): prove leo-walker's shell
# really is the Walker geometry it claims, that its links really move, hand
# over and fail, that every routing arm delivers through all of that, and that
# a run is reproducible.
#
# Usage: check-leo-walker.sh <ns3-dir>
#
# Why each assertion exists:
#
# 1. Geometry anchors (`# anchor`): every satellite on the shell radius
#    R+h, the in-plane ISL chord equal to 2(R+h)sin(pi/S) at t=0 AND half an
#    orbit later, and the reported period equal to 2*pi*sqrt(a^3/mu) computed
#    here independently. The t=T/2 chord is the load-bearing one: a model
#    that placed satellites correctly and then moved them off their orbit
#    would pass a t=0-only check (the #480 lesson).
# 1b. Cross-plane pairing (`# anchor isl`): the chosen constant slot shift
#    must give cross-plane ISLs no longer on average than same-slot pairing,
#    and shorter than the in-plane chord. Same-slot pairing is what the
#    first leo-walker shipped: on Starlink S1 it made every cross link the
#    farther of two candidates (1470 km vs 637 km mean) and nearly tripled
#    the Paris-Luanda RTT Hypatia publishes; on this 16 x 16 shell it is
#    2527 km vs 1838 km.
# 2. Every ground station sees at least one satellite above --minElevation
#    (`# visibility`). Zero is how the topocentric-vs-ECEF frame bug showed
#    itself: three cities silently had no service at all.
# 3. Scheduled handovers happen and are attributed (`# handover`
#    scheduled>0) -- without them the run is a static snapshot and the
#    handover metric family (#297 item 3) measures nothing.
# 4. The failure overlay fires (islFailures>0) and the mass failure is
#    recorded as its own outage class (`class=massfail` line present).
# 5. Every arm delivers. oracle-delay first: its delivery shows the moving
#    topology stays routable before AntHocNet or AODV is judged on it.
#    AODV is the arm that used to abort here (interface-down race in stock
#    AODV, see SetLink in leo-walker.cc), so it is part of the smoke.
# 6. The delay oracle reports mode=wired+delay: the latency bound is really
#    the Dijkstra-on-channel-delay mode, not the hop-count one. geo-greedy
#    (the idealised geographic comparator) sends no control packet.
# 6b. scenario_check.py's #297 rules pass on this very output: the handover
#    clock ticked as ##CONFIG## says, and every flow's books close
#    (offered = delivered + outageLost + scatteredLost, classes = flows,
#    ##RUN## PDR = the books' delivered/offered).
# 7. Determinism: the same seed twice is byte-identical for AntHocNet. The
#    failure schedule and the mass-failure draw sit on pinned application
#    streams; an unpinned one would make every arm see different failures.
# 8. Order independence (#352): AntHocNet's row run alone equals its row
#    when it ran after oracle-delay in one process. The unpinned CSMA backoff
#    on the GSL segments broke exactly this before it was pinned. AntHocNet
#    only: stock AODV keys its socket maps on heap addresses (#362), the same
#    exemption check-seed-independence.py makes.
#
# Runs on ns-3.48 only: the stock LEO model first ships there, and the
# example is not built on older trees (ADR-0022).
set -euo pipefail

NS3DIR=${1:?usage: check-leo-walker.sh <ns3-dir>}
# Resolve the repo before leaving it: CI calls this by a relative path.
REPO="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$NS3DIR"

fail=0
say() { printf '%s\n' "$*"; }

ARMS=oracle-delay,anthocnet,aodv,geo-greedy
SHELL_ARGS="--planes=16 --sats=16 --altitude=1150 --inclination=53 --minElevation=25
            --time=60 --islDown=0.02 --massFailAt=30 --massFailFrac=0.05"

out=$(./ns3 run "$(echo leo-walker --csv --protocols=$ARMS $SHELL_ARGS)" 2>/dev/null)
printf '%s\n' "$out" | grep -E '^# (anchor|visibility|handover)|^##ORACLE##|^##RUN##|class=(scheduled|massfail)' || true

# --- 1. geometry anchors ----------------------------------------------------
anchor=$(printf '%s\n' "$out" | grep '^# anchor' || true)
if [ -z "$anchor" ]; then
    say "FAIL: no '# anchor' line"
    fail=1
else
    # shellcheck disable=SC2016
    bad=$(printf '%s\n' "$anchor" | awk '{
        for (i = 1; i <= NF; ++i) { k = $i; sub(/=[^=]*$/, "", k); x = $i; sub(/.*=/, "", x); v[k] = x }
        a = v["radiusKm"] * 1000; mu = 3.986004418e14
        period = 2 * 3.14159265358979 * sqrt(a * a * a / mu) / 60
        if (v["radiusKm"] - 6371 - 1150 > 0.001 || 6371 + 1150 - v["radiusKm"] > 0.001) print "radius " v["radiusKm"]
        if (v["radiusSpreadM"] + 0 > 1) print "radiusSpreadM " v["radiusSpreadM"]
        if (v["chordErrM(t=0)"] + 0 > 1) print "chordErrM(t=0) " v["chordErrM(t=0)"]
        if (v["chordErrM(t=T/2)"] + 0 > 1) print "chordErrM(t=T/2) " v["chordErrM(t=T/2)"]
        d = v["periodMin"] - period; if (d < 0) d = -d
        if (d > 0.01) print "periodMin " v["periodMin"] " vs " period
    }')
    if [ -n "$bad" ]; then
        say "FAIL: geometry anchor out of tolerance: $bad"
        fail=1
    else
        say "ok: shell radius, in-plane chord (t=0 and t=T/2) and period match the analytic Walker shell"
    fi
fi

islA=$(printf '%s\n' "$out" | grep '^# anchor isl' || true)
if [ -z "$islA" ]; then
    say "FAIL: no '# anchor isl' line"
    fail=1
else
    bad=$(printf '%s\n' "$islA" | awk '{
        for (i = 1; i <= NF; ++i) { k = $i; sub(/=[^=]*$/, "", k); x = $i; sub(/.*=/, "", x); v[k] = x }
        if (v["crossMeanKm"] + 0 > v["sameSlotMeanKm"] + 0.001) print "crossMeanKm " v["crossMeanKm"] " > sameSlotMeanKm " v["sameSlotMeanKm"]
        if (v["crossMeanKm"] + 0 >= v["inPlaneKm"] + 0) print "crossMeanKm " v["crossMeanKm"] " >= inPlaneKm " v["inPlaneKm"]
    }')
    if [ -n "$bad" ]; then
        say "FAIL: cross-plane ISL pairing: $bad"
        fail=1
    else
        say "ok: cross-plane ISLs paired at the shortest constant slot shift ($islA)"
    fi
fi

# --- 2. every station served -------------------------------------------------
vis=$(printf '%s\n' "$out" | grep '^# visibility' || true)
zero=$(printf '%s\n' "$vis" | tr ' ' '\n' | grep -E '^[A-Za-z]+=0$' || true)
if [ -z "$vis" ] || [ -n "$zero" ]; then
    say "FAIL: a ground station sees no satellite: ${zero:-<no visibility line>}"
    fail=1
fi

# --- 3/4. handovers, failures, mass failure ---------------------------------
for arm in ${ARMS//,/ }; do
    ho=$(printf '%s\n' "$out" | grep "^# handover $arm " || true)
    sched=$(printf '%s\n' "$ho" | sed -n 's/.* scheduled=\([0-9]*\).*/\1/p')
    islf=$(printf '%s\n' "$ho" | sed -n 's/.* islFailures=\([0-9]*\).*/\1/p')
    [ "${sched:-0}" -gt 0 ] || { say "FAIL: $arm: no scheduled handover in 60 s"; fail=1; }
    [ "${islf:-0}" -gt 0 ] || { say "FAIL: $arm: the ISL failure overlay never fired"; fail=1; }
    printf '%s\n' "$out" | grep -q "^# outage $arm .* class=massfail " \
        || { say "FAIL: $arm: no massfail outage class reported"; fail=1; }
done

# --- 5. every arm delivers ----------------------------------------------------
for arm in ${ARMS//,/ }; do
    pdr=$(printf '%s\n' "$out" | awk -v a="$arm" '$1=="##RUN##" && $3==a {print $4}')
    say "$arm PDR% = ${pdr:-<none>}"
    awk -v p="${pdr:-0}" 'BEGIN { exit (p+0 > 0) ? 0 : 1 }' \
        || { say "FAIL: $arm delivered nothing on the moving constellation"; fail=1; }
done

# --- 6. the latency bound is the delay oracle --------------------------------
printf '%s\n' "$out" | grep -q '^##ORACLE## .* oracle-delay mode=wired+delay ' \
    || { say "FAIL: oracle-delay did not run the delay metric (mode wired+delay)"; fail=1; }

printf '%s\n' "$out" | grep -q '^# geo geo-greedy seed=1 ' \
    || { say "FAIL: geo-greedy printed no '# geo' line"; fail=1; }

# --- 6b. the #297 scenario_check rules on this output --------------------------
SC="$REPO/tools/bench/scenario_check.py"
cell=$(mktemp)
printf '%s\n' "$out" > "$cell"
if python3 "$SC" results "$cell" > "$cell.check" 2>&1; then
    say "ok: scenario_check.py #297 rules (handover clock, outage books) pass"
else
    say "FAIL: scenario_check.py on the smoke output:"
    grep '^FAIL' "$cell.check" || cat "$cell.check"
    fail=1
fi
rm -f "$cell" "$cell.check"

# --- 7. determinism ------------------------------------------------------------
a=$(./ns3 run "$(echo leo-walker --csv --protocols=anthocnet $SHELL_ARGS)" 2>/dev/null)
b=$(./ns3 run "$(echo leo-walker --csv --protocols=anthocnet $SHELL_ARGS)" 2>/dev/null)
if [ "$a" != "$b" ]; then
    say "FAIL: same seed, different output:"
    diff <(printf '%s\n' "$a") <(printf '%s\n' "$b") | head -20
    fail=1
else
    say "ok: same-seed rerun is byte-identical"
fi

# --- 8. order independence -------------------------------------------------------
in_list=$(printf '%s\n' "$out" | grep '^##RUN## 1 anthocnet ' || true)
alone=$(printf '%s\n' "$a" | grep '^##RUN## 1 anthocnet ' || true)
if [ -z "$alone" ] || [ "$in_list" != "$alone" ]; then
    say "FAIL: anthocnet's row depends on the arms that ran before it:"
    say "  after oracle-delay: $in_list"
    say "  alone:              $alone"
    fail=1
else
    say "ok: anthocnet's row is the same alone and after another arm"
fi

if [ "$fail" -ne 0 ]; then
    say "leo-walker smoke: FAIL"
    exit 1
fi
say "leo-walker smoke: PASS"
