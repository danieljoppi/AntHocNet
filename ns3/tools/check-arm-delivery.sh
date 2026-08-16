#!/usr/bin/env bash
# MANET protocol-arm delivery smoke (#429): run *every* arm the wifi compare
# harness advertises on one small, static, MULTI-HOP field and fail unless each
# one actually delivers — PDR above a floor, data reaching IP transmit, a
# multi-hop mean path, and a drop-cause book that closes.
#
# Usage: check-arm-delivery.sh <ns3-dir>
#
# Why this exists. Two vendored baseline ports compiled cleanly on the whole
# five-version CI matrix plus ASan, emitted plausible-looking output, merged —
# and did not route: AOMDV (#414/#416) forwards only single-hop, GPSR (#425)
# delivered 0.00% PDR on 40/40 seeds of a full campaign dispatch. The second
# failed AFTER the first had taught the lesson, because the rule ("no baseline
# merges without a smoke run showing non-zero delivery and a drop book that
# closes", docs/benchmarks/methodology.md) existed only as prose, and prose
# does not fail. This is the satellite suite's check-sat-arms.sh (#420/#422)
# applied to the MANET suite, which had no equivalent — which is exactly why
# GPSR reached a campaign dispatch before anyone measured it.
#
# The arms are read out of the harness's own --PrintHelp rather than listed
# here, so a new arm is covered the moment it is added instead of when someone
# remembers to update this file (#435 is the defect class a hand-kept list
# breeds).
#
# The scenario is deliberately STATIC (RWP pause longer than the run, so every
# node holds its t=0 position) and deliberately MULTI-HOP (area 500 m, disk
# range 175 m — mean degree ~6, corner-to-corner ~4 hops). Multi-hop is
# load-bearing: AOMDV's defect (#416) is invisible on single-hop paths — it
# delivered 10% on a trivial 5-node/100 m field with hopsMean=1.00 and 0% as
# soon as a relay was needed. A single-hop smoke would wave that defect
# through, so the gate asserts hopsMean > 1 per arm, and proves the scenario
# itself offers multi-hop paths via the oracle arm (below). The explicit
# --range also matters structurally: the oracle reads its ground-truth
# adjacency off the disk channel and aborts on the default channel
# (ns3/oracle/README.md).
#
# The `oracle` arm (#296/#415, global-knowledge shortest path) anchors the
# gate: on a static connected field it must deliver near-100%, which proves the
# scenario is deliverable and multi-hop before any real arm is blamed for
# failing on it.
#
# Known-broken arms. GPSR (#425) and AOMDV (#416) were broken when this gate
# landed (both since fixed), and a plain gate would have been red on every PR
# and gotten ignored. Each entry below is an
# expected-fail carrying its issue number: the arm still runs, a delivery
# failure is reported and tolerated, and — the honesty half — if a listed arm
# unexpectedly DELIVERS, the gate FAILS with "remove it from the list", so the
# list can never quietly outlive the defects it records. Removing an entry is
# therefore part of fixing its issue.
#
# Assertion structure (the #425 lesson): the #217/#209 invariants are gated on
# "non-zero whenever PDR is", so a completely inert arm passed them by
# exemption. Here the PDR floor is UNCONDITIONAL per arm; the other checks
# report alongside it rather than being conditioned on it.
#
# Cheap on purpose: 16 nodes, 60 simulated seconds, 1 seed, one invocation per
# arm — a couple of minutes in total on the prebuilt image; fine per-PR. Seed 1
# is fixed, and #129 (determinism) + #352 (seed independence) make the run
# byte-reproducible, so this gate never flakes — it can only change verdict
# when the code does.
#
# The ns-3 tree must already be configured + built with the anthocnet module's
# examples enabled (anthocnet-compare builds as part of the module's examples).
set -euo pipefail

NS3DIR=${1:-}
if [ -z "$NS3DIR" ]; then
    echo "usage: $0 <ns3-dir>" >&2
    exit 2
fi

# arm=issue pairs. An entry means "this arm is expected to FAIL delivery; the
# defect is tracked in that issue". See the header for the removal rule.
# Empty since the #416 aomdv fix — every advertised arm must deliver.
KNOWN_BROKEN=""

# Static (pause 120 s > 60 s run: ns-3 RWP pauses first, so nodes never move),
# multi-hop (500 m field, 175 m disk range), 3 CBR flows, 1 seed. --range>0 is
# required for the oracle's exact adjacency, see header.
ARGS="--nNodes=16 --area=500 --range=175 --pause=120 --flows=3 --time=60 --runs=1"

# PDR floors (percent). Working arms deliver far above 5 on a static connected
# field (the per-merge taxonomy's worst static row is ~87, docs/benchmarks/
# scenarios/sparse-static.md); the defect class this gate exists for reads
# 0.00. The oracle is a global-knowledge upper bound and must be near-perfect
# here — if IT cannot deliver, the scenario is broken, not the arms.
ARM_PDR_FLOOR=5.0
ORACLE_PDR_FLOOR=90.0
# Drop-cause identity tolerance in pp, same FAIL threshold as
# scenario_check.py results (the shortfall legitimately left is packets still
# queued at end of run). GPSR's book was off by -100.00 pp (#425).
DROP_SUM_TOL=5.0

cd "$NS3DIR"

# The supported arms, straight from the harness's --protocols help text: the
# parenthesised comma list in "Comma-separated list (a,b,c)".
help=$(./ns3 run "anthocnet-compare --PrintHelp" 2>&1 || true)
arms=$(printf '%s\n' "$help" \
    | sed -n 's/.*Comma-separated list (\([a-z,]*\)).*/\1/p' \
    | head -n 1 | tr ',' ' ')
if [ -z "$arms" ]; then
    echo "FAIL [arm-delivery]: could not read the arm list from anthocnet-compare --PrintHelp."
    echo "  The --protocols help text must keep its '(a,b,c)' list — this gate"
    echo "  derives its coverage from it so new arms are covered automatically."
    printf '%s\n' "$help" | tail -n 20
    exit 1
fi
echo "[arm-delivery] arms under test: $arms"
echo "[arm-delivery] scenario: $ARGS"

# The anchor must be present: without the oracle nothing proves the scenario
# is deliverable and multi-hop, and every other verdict is unmoored.
case " $arms " in
    *" oracle "*) ;;
    *)
        echo "FAIL [arm-delivery]: 'oracle' is not in the advertised arm list ($arms)."
        echo "  The oracle run is the gate's anchor — it proves the scenario itself is"
        echo "  deliverable and multi-hop. Restore it to the harness's --protocols list."
        exit 1
        ;;
esac

# A known-broken entry whose arm the harness no longer advertises is noted, not
# fatal: the entry waits for the arm (e.g. aomdv is compiled into the harness
# but absent from the stale help list #435 is fixing in parallel).
for e in $KNOWN_BROKEN; do
    a=${e%%=*}
    case " $arms " in
        *" $a "*) ;;
        *) echo "[arm-delivery] note: known-broken arm '$a' (${e#*=}) is not advertised by the harness — not run" ;;
    esac
done

broken_issue() {
    local e
    for e in $KNOWN_BROKEN; do
        if [ "${e%%=*}" = "$1" ]; then
            echo "${e#*=}"
            return
        fi
    done
}

fail=0
for proto in $arms; do
    issue=$(broken_issue "$proto")
    cmd="anthocnet-compare $ARGS --protocols=$proto"
    echo "[arm-delivery] ./ns3 run \"$cmd\""
    if ! out=$(./ns3 run "$cmd" 2>&1); then
        if [ -n "$issue" ]; then
            echo "XFAIL [arm-delivery] $proto did not complete (known broken, $issue)"
            continue
        fi
        printf '%s\n' "$out" | tail -n 25
        echo "FAIL [arm-delivery] '$proto' did not complete (tail above)."
        fail=1
        continue
    fi

    # ##RUN## <seed> <proto> <pdr> ... — the per-seed row (#128).
    pdr=$(printf '%s\n' "$out" \
        | awk -v p="$proto" '$1 == "##RUN##" && $3 == p { v = $4 } END { print v }')
    # ##DROPID## <seed> <proto> hopTx=N ... — data packets reaching IP
    # transmit anywhere. ctrlTx alive + hopTx=0 is precisely GPSR's signature.
    hoptx=$(printf '%s\n' "$out" \
        | sed -n "s/^##DROPID## [0-9]* $proto .*hopTx=\([0-9]*\).*/\1/p" | head -n 1)
    # '# paths <proto> ... hopsMean=X' — mean hop count over delivered packets.
    hops=$(printf '%s\n' "$out" \
        | sed -n "s/^# paths $proto .*hopsMean=\([0-9.]*\).*/\1/p" | head -n 1)
    # '# drops <proto> ... sum=S' — pdr + the five causes; ~100 when the books
    # balance (#215).
    dsum=$(printf '%s\n' "$out" \
        | sed -n "s/^# drops $proto .*sum=\([0-9.]*\).*/\1/p" | head -n 1)

    if [ -z "$pdr" ]; then
        if [ -n "$issue" ]; then
            echo "XFAIL [arm-delivery] $proto emitted no ##RUN## row (known broken, $issue)"
            continue
        fi
        printf '%s\n' "$out" | tail -n 25
        echo "FAIL [arm-delivery] '$proto' exited 0 but emitted no ##RUN## row (#28-style silent failure)."
        fail=1
        continue
    fi

    floor=$ARM_PDR_FLOOR
    if [ "$proto" = "oracle" ]; then floor=$ORACLE_PDR_FLOOR; fi

    reasons=""
    if ! awk -v v="$pdr" -v f="$floor" 'BEGIN { exit (v + 0 >= f + 0) ? 0 : 1 }'; then
        reasons="$reasons PDR=$pdr below floor $floor;"
    fi
    if ! awk -v v="${hoptx:-0}" 'BEGIN { exit (v + 0 > 0) ? 0 : 1 }'; then
        reasons="$reasons hopTx=${hoptx:-<missing>} (no data packet ever reached IP transmit — the #425 signature);"
    fi
    if ! awk -v v="${hops:-0}" 'BEGIN { exit (v + 0 > 1.0) ? 0 : 1 }'; then
        reasons="$reasons hopsMean=${hops:-<missing>} not multi-hop (the #416 signature: single-hop delivery only);"
    fi
    if ! awk -v v="${dsum:-0}" -v t="$DROP_SUM_TOL" \
            'BEGIN { d = v + 0 - 100.0; if (d < 0) d = -d; exit (d <= t) ? 0 : 1 }'; then
        reasons="$reasons drop book does not close (sum=${dsum:-<missing>}, tolerance ${DROP_SUM_TOL} pp);"
    fi

    if [ -z "$issue" ]; then
        if [ -z "$reasons" ]; then
            echo "PASS [arm-delivery] $proto PDR=$pdr hopTx=$hoptx hopsMean=$hops dropSum=$dsum"
        else
            echo "FAIL [arm-delivery] $proto:$reasons"
            if [ "$proto" = "oracle" ]; then
                echo "  The oracle is the gate's anchor: a global-knowledge shortest-path control"
                echo "  that fails here means the SCENARIO is broken (partitioned seed, wrong"
                echo "  range, dead traffic) — fix the scenario before reading any other verdict."
            else
                echo "  A merged arm must demonstrably route on a multi-hop field before it is"
                echo "  compared (docs/benchmarks/methodology.md; the #414/#425 rule). If this arm"
                echo "  is genuinely broken and being landed as such, add it to KNOWN_BROKEN in"
                echo "  $0 with its tracking issue."
            fi
            fail=1
        fi
    else
        if [ -z "$reasons" ]; then
            echo "FAIL [arm-delivery] $proto DELIVERS (PDR=$pdr hopTx=$hoptx hopsMean=$hops dropSum=$dsum)"
            echo "  but is listed as known-broken ($issue). Fixed — remove it from KNOWN_BROKEN"
            echo "  in $0 (and close/update $issue), so the list stays honest."
            fail=1
        else
            echo "XFAIL [arm-delivery] $proto (known broken, $issue):$reasons"
        fi
    fi
done

if [ "$fail" -ne 0 ]; then
    exit 1
fi
echo "PASS [arm-delivery] every working arm delivers multi-hop; known-broken arms still broken (list honest)"
