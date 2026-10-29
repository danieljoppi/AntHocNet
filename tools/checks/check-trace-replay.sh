#!/usr/bin/env bash
# SPDX-License-Identifier: MIT OR GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
# Scene replay smoke (#639): anthocnet-compare can replay an ns-2 movement
# trace (--mobility=trace --traceFile) and an explicit flow list
# (--flowsFile), which is how a game level becomes an ns-3 run (#640).
#
# Usage: check-trace-replay.sh <ns3-dir> <repo-dir>
#
# 1. The committed fixture (an 8-node static chain plus two walkers, two
#    flows) delivers for AntHocNet and AODV: the #439 rule, an arm must route.
# 2. Replay is exact: a generated RWP run dumped with --dumpTrace/--dumpFlows
#    and replayed from those files gives byte-identical output (every line but
#    ##CONFIG##, which names the files). Trace mode reserves the RNG streams
#    RWP would take, so every other stream keeps its index.
# 3. Bad input fails before the run, with the file and line: a malformed flow
#    line, a node id out of range, a trace whose node count disagrees with an
#    explicit --nNodes, --mobility=trace without a file.
#
# Runs on one matrix version (3.42), like the other scenario gates.
set -euo pipefail

NS3DIR=${1:?usage: check-trace-replay.sh <ns3-dir> <repo-dir>}
REPO=${2:?usage: check-trace-replay.sh <ns3-dir> <repo-dir>}
FIX="$REPO/ns3/tools/fixtures"
TMP=$(mktemp -d)
cd "$NS3DIR"
fail=0
say() { printf '%s\n' "$*"; }
run() { ./ns3 run "anthocnet-compare $*" 2>/dev/null; }

# 1. the fixture delivers
out=$(run --csv --protocols=anthocnet,aodv --time=60 --range=150 \
  --mobility=trace --traceFile="$FIX/chain-10.ns_movements" --flowsFile="$FIX/chain-10.flows")
for arm in anthocnet aodv; do
  pdr=$(printf '%s\n' "$out" | awk -F, -v a="$arm" '$1==a{print $7}')
  if awk -v p="${pdr:-0}" 'BEGIN{exit !(p>0)}'; then say "ok: fixture replay — $arm PDR ${pdr}%"
  else say "FAIL: fixture replay — $arm delivered nothing (PDR=${pdr:-none})"; fail=1; fi
done
printf '%s\n' "$out" | grep -q "^##CONFIG## .*nNodes=10 .*traceFile=.*flowsFile=" \
  || { say "FAIL: ##CONFIG## does not name nNodes=10 and the two files"; fail=1; }

# 2. generated run == its replay, byte for byte
ARGS="--csv --protocols=anthocnet,aodv --nNodes=20 --time=120 --area=600 --flows=4 --speed=10 --pause=5 --range=300"
run $ARGS --dumpTrace="$TMP/gen.ns_movements" --dumpFlows="$TMP/gen.flows" > "$TMP/gen.out"
run $ARGS --mobility=trace --traceFile="$TMP/gen.ns_movements" --flowsFile="$TMP/gen.flows" > "$TMP/rep.out"
if diff <(grep -v '^##CONFIG##' "$TMP/gen.out") <(grep -v '^##CONFIG##' "$TMP/rep.out") > "$TMP/diff"; then
  pdr=$(awk -F, '$1=="anthocnet"{print $7}' "$TMP/gen.out")
  say "ok: a dumped RWP run replays byte-identically ($(wc -l < "$TMP/gen.out") lines, anthocnet PDR ${pdr}%)"
else
  say "FAIL: the replay differs from the generated run:"; head -20 "$TMP/diff"; fail=1
fi

# 3. bad input is refused before the run, naming the problem
refused() {  # refused <what> <expected message fragment> <args...>
  local what=$1 msg=$2; shift 2
  if ./ns3 run "anthocnet-compare --csv --protocols=anthocnet --time=10 $*" > "$TMP/r.out" 2>&1; then
    say "FAIL: $what was accepted"; fail=1
  elif grep -q -- "$msg" "$TMP/r.out"; then say "ok: refused $what"
  else say "FAIL: $what failed without '$msg':"; tail -5 "$TMP/r.out"; fail=1; fi
}
printf '0 7 2\n' > "$TMP/short.flows"
printf '0 42 2 50 2048\n' > "$TMP/range.flows"
refused "a malformed flow line" "short.flows:1: expected 'src dst start stop cbrBps'" \
  --mobility=trace --traceFile="$FIX/chain-10.ns_movements" --flowsFile="$TMP/short.flows"
refused "a flow to a node that does not exist" "range.flows:1: node ids must be distinct" \
  --mobility=trace --traceFile="$FIX/chain-10.ns_movements" --flowsFile="$TMP/range.flows"
refused "a trace at odds with --nNodes" "but the trace names 10 nodes" \
  --mobility=trace --traceFile="$FIX/chain-10.ns_movements" --nNodes=12
refused "--mobility=trace without a file" "needs --traceFile" --mobility=trace

rm -rf "$TMP"
exit $fail
