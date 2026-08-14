#!/usr/bin/env bash
# Satellite protocol-arm smoke (#420): run *every* arm the ISL suite offers on a
# small torus and fail unless each one completes and delivers something.
#
# Usage: check-sat-arms.sh <ns3-dir>
#
# Why this exists. The satellite CI legs ran the analytic anchors
# (check-sat-anchors.sh) and the determinism gate — both on a single arm — so
# nothing per-PR ever asked whether the *other* arms could run at all. They
# could not: DSDV aborted on every multi-ISL grid from the day the arm was
# written, and it took a full campaign dispatch, 20 seeds deep, to find out.
# The anchors are about the *values* a run produces; this gate is about the far
# cheaper question underneath them — does the arm run.
#
# The arms are read out of the harness's own --PrintHelp rather than listed
# here, so a new arm is covered the moment it is added instead of when someone
# remembers to update this file.
#
# Cheap on purpose: a 3x3 torus for 20 simulated seconds per arm, which is the
# smallest grid that still gives every satellite more than one ISL — the
# multi-interface shape the whole satellite track is for, and the precondition
# of the #420 defect. Seconds per arm; fine per-PR.
#
# The ns-3 tree must already be configured + built with the anthocnet module's
# examples enabled (isl-grid builds as part of the module's examples).
set -euo pipefail

NS3DIR=${1:-}
if [ -z "$NS3DIR" ]; then
    echo "usage: $0 <ns3-dir>" >&2
    exit 2
fi

# 3x3 torus: 9 satellites, every one holding 4 ISLs on 4 separate /30s.
ARGS="--rows=3 --cols=3 --torus=true --flows=2 --time=20"

cd "$NS3DIR"

# The supported arms, straight from the harness's --protocols help text: the
# parenthesised comma list in "Comma-separated list (a,b,c)".
help=$(./ns3 run "isl-grid --PrintHelp" 2>&1 || true)
arms=$(printf '%s\n' "$help" \
    | sed -n 's/.*Comma-separated list (\([a-z,]*\)).*/\1/p' \
    | head -n 1 | tr ',' ' ')
if [ -z "$arms" ]; then
    echo "FAIL [sat:arms]: could not read the arm list from isl-grid --PrintHelp."
    echo "  The --protocols help text must keep its '(a,b,c)' list — this gate"
    echo "  derives its coverage from it so new arms are covered automatically."
    printf '%s\n' "$help" | tail -n 20
    exit 1
fi
echo "[sat:arms] arms under test: $arms"

# isl-grid --csv row: protocol,runs,rows,cols,nodes,links,isl_delay_ms,flows,pdr_pct,...
# so PDR is field 9 (same layout check-sat-anchors.sh reads).
fail=0
for proto in $arms; do
    cmd="isl-grid --csv --protocols=$proto $ARGS"
    echo "[sat:arms] ./ns3 run \"$cmd\""
    if ! out=$(./ns3 run "$cmd" 2>&1); then
        printf '%s\n' "$out" | tail -n 25
        echo "FAIL [sat:arms] '$proto' did not complete on a 3x3 ISL torus (tail above)."
        echo "  A default arm that cannot finish a 20 s run cannot carry a campaign — this"
        echo "  is exactly #420, where the crash surfaced only after 20 seeds of dispatch."
        fail=1
        continue
    fi
    pdr=$(printf '%s\n' "$out" | awk -F, -v p="$proto" '$1 == p { v = $9 } END { print v }')
    if [ -z "$pdr" ]; then
        printf '%s\n' "$out" | tail -n 25
        echo "FAIL [sat:arms] '$proto' exited 0 but emitted no CSV row (#28-style silent failure)."
        fail=1
        continue
    fi
    if awk -v v="$pdr" 'BEGIN { exit (v + 0 > 0) ? 0 : 1 }'; then
        echo "PASS [sat:arms] $proto PDR=$pdr"
    else
        echo "FAIL [sat:arms] $proto delivered nothing (PDR=$pdr) on a 3x3 ISL torus."
        fail=1
    fi
done

# The other half of #420: an arm that *cannot* run here must say so and stop,
# not crash partway through. Without this the harness could regress to dying at
# simulated t=15 s with an empty stderr and still pass the loop above, because
# dsdv is no longer in the arm list at all.
echo "[sat:arms] rejection check: dsdv on a multi-ISL torus must be refused cleanly"
if out=$(./ns3 run "isl-grid --csv --protocols=dsdv $ARGS" 2>&1); then
    printf '%s\n' "$out" | tail -n 25
    echo "FAIL [sat:arms] dsdv was accepted on a multi-ISL torus."
    echo "  ns-3's DSDV is single-interface-only; it forwards on a null output device"
    echo "  here and SIGSEGVs in the -opt profile (#420). The harness must reject it."
    fail=1
elif printf '%s\n' "$out" | grep -q "dsdv cannot run on this ISL topology"; then
    echo "PASS [sat:arms] dsdv refused up front with the explanatory message"
else
    printf '%s\n' "$out" | tail -n 25
    echo "FAIL [sat:arms] dsdv failed, but not via the harness's own check (message above)."
    echo "  #420 must fail fast at argument time with a message naming the reason, not"
    echo "  abort inside the simulation where the -opt profile turns it into a bare SIGSEGV."
    fail=1
fi

if [ "$fail" -ne 0 ]; then
    exit 1
fi
echo "PASS [sat:arms] every supported ISL arm ran; dsdv correctly refused"
