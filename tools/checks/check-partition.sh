#!/usr/bin/env bash
# SPDX-License-Identifier: MIT OR GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
# Partition/merge stress gate (#62): control traffic must stay bounded while
# the field is split, and the flows across the split must deliver again after
# each merge.
#
# Usage: check-partition.sh <ns3-dir> <repo-dir>
#
# The scene (tools/bench/partition_scene.py): two 20-node teams 800 m apart,
# a 3-node bridge chain that withdraws and returns, three merged and three
# split phases of 150 s; five of the ten flows cross the gap. The #20
# linkfail storm and the #45 unbounded proactive flood are the bug class this
# catches: both grow while destinations are unreachable. The checker FAILs
# AntHocNet when its control rate in the second half of a split exceeds the
# first half by more than 1.5x (it reads 1.17x at most), when a crossing
# flow is silent 60 s after a merge (it rejoins in 12-39 s), or when a
# crossing flow delivers while split (the scene, not the protocol, broke).
#
# Runs on one matrix version (3.42), like the other scenario gates.
set -euo pipefail

NS3DIR=${1:?usage: check-partition.sh <ns3-dir> <repo-dir>}
REPO=${2:?usage: check-partition.sh <ns3-dir> <repo-dir>}
TMP=$(mktemp -d)
python3 "$REPO/tools/bench/partition_scene.py" gen --out "$TMP" --seed 1
cd "$NS3DIR"
./ns3 run "anthocnet-compare --protocols=anthocnet --runs=1 --time=900 --range=300 \
  --propagation=range --mobility=trace --traceFile=$TMP/partition.ns2 \
  --flowsFile=$TMP/partition.flows --diag --seriesEvery=1" > "$TMP/run.txt" 2>/dev/null
grep '^##RUN##' "$TMP/run.txt"
python3 "$REPO/tools/bench/partition_scene.py" check "$TMP/partition.flows" "$TMP/run.txt" \
  --proto anthocnet --strict
