#!/usr/bin/env bash
# SPDX-License-Identifier: MIT OR GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
# Disaster-family gate (#580): the scene is wired, its walls are honoured,
# and every native arm routes through it.
#
# Usage: check-disaster.sh <ns3-dir> <repo-dir>
#
# The scene (tools/bench/disaster_scene.py, scene seed 1): 47 responders in
# the Aschenbruck et al. 2007 disaster-area roles around a mall with two
# walled fire compartments, on the urban channel with those compartments as
# the buildings (docs/benchmarks/scenarios/disaster.md). 300 s, 2 seeds.
#
# 1. The walls matter. The oracle with the buildings' loss zeroed
#    (DbPerCut = DbPerMeter = 0) is the field's ceiling and must deliver at
#    least disaster_nowalls_oracle_pdr_min. With the walls on it must lose at
#    least disaster_walls_cost_pp_min against that: a channel that ignored
#    --buildings would read the same twice.
# 2. Every native arm routes (#439): AntHocNet, AODV and OLSR each deliver at
#    least disaster_arm_pdr_min on the walled scene.
# 3. The committed scene (ns3/tools/fixtures/disaster/, which the benchmark
#    workflow replays) is what the generator writes, byte for byte.
#
# Thresholds: ns3/tools/anchors.yml. Runs on one matrix version (3.42), like
# the other scenario gates.
set -euo pipefail
# Marker fields are read by name through the tested reader, not by awk
# position (#791; tools/bench/test_bench_parse_query.py).
BENCH_PARSE="$(cd "$(dirname "$0")/../bench" && pwd)/bench_parse.py"
field() { python3 "$BENCH_PARSE" --get "$1" --from "$2" --proto "$3" -; }  # reads stdin

NS3DIR=${1:?usage: check-disaster.sh <ns3-dir> <repo-dir>}
REPO=${2:?usage: check-disaster.sh <ns3-dir> <repo-dir>}
ANCHORS="$REPO/ns3/tools/anchors.yml"
floor() { awk -F: -v k="$1" '$1 == k { sub(/#.*/, "", $2); gsub(/ /, "", $2); print $2 }' "$ANCHORS"; }
TMP=$(mktemp -d)
python3 "$REPO/tools/bench/disaster_scene.py" gen --out "$TMP" --seed 1
fail=0
for f in disaster.ns2 disaster.flows disaster.buildings; do
  if cmp -s "$TMP/$f" "$REPO/ns3/tools/fixtures/disaster/$f"; then echo "ok: fixture $f matches the generator"
  else echo "FAIL: ns3/tools/fixtures/disaster/$f differs from disaster_scene.py gen --seed 1; regenerate it"; fail=1; fi
done
B=$(cat "$TMP/disaster.buildings")
cd "$NS3DIR"
run() {
  ./ns3 run "anthocnet-compare --scenario=disaster --traceFile=$TMP/disaster.ns2 \
    --flowsFile=$TMP/disaster.flows --buildings=$B --time=300 --runs=2 --csv $*" 2>/dev/null
}
pdr() { printf '%s\n' "$1" | field pdr csv "$2"; }
walls=$(run --protocols=oracle,anthocnet,aodv,olsr)
open=$(run --protocols=oracle --ns3::UrbanObstacleShadowingLossModel::DbPerCut=0 \
  --ns3::UrbanObstacleShadowingLossModel::DbPerMeter=0)
ceiling=$(pdr "$open" oracle); bound=$(pdr "$walls" oracle)
min_open=$(floor disaster_nowalls_oracle_pdr_min); min_cost=$(floor disaster_walls_cost_pp_min)
if awk -v p="${ceiling:-0}" -v m="$min_open" 'BEGIN{exit !(p>=m)}'; then
  echo "ok: oracle without walls ${ceiling}% >= ${min_open}%"
else echo "FAIL: oracle without walls ${ceiling:-none}% < ${min_open}%"; fail=1; fi
if awk -v a="${ceiling:-0}" -v b="${bound:-0}" -v m="$min_cost" 'BEGIN{exit !(a-b>=m)}'; then
  echo "ok: the walls cost the oracle $(awk -v a="$ceiling" -v b="$bound" 'BEGIN{printf "%.1f", a-b}') pp (>= ${min_cost})"
else echo "FAIL: the walls cost the oracle only ${ceiling:-?} - ${bound:-?} pp (< ${min_cost}): --buildings is not reaching the channel"; fail=1; fi
min_arm=$(floor disaster_arm_pdr_min)
for arm in anthocnet aodv olsr; do
  p=$(pdr "$walls" "$arm")
  if awk -v p="${p:-0}" -v m="$min_arm" 'BEGIN{exit !(p>=m)}'; then echo "ok: $arm ${p}% >= ${min_arm}%"
  else echo "FAIL: $arm ${p:-none}% < ${min_arm}% (#439: an arm must route)"; fail=1; fi
done
exit $fail
