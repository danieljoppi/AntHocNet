#!/usr/bin/env bash
#
# run-comparison.sh NS3DIR [runs] [nNodes] [time] [area] [flows]
#
# Runs the anthocnet-compare benchmark inside an ns-3 tree that already has the
# AntHocNet module installed and the comparison modules enabled, and writes the
# averaged results to stdout as CSV. Used locally and by the benchmark CI
# pipeline.
#
# The ns-3 tree must have been configured with:
#   ./ns3 configure --enable-examples \
#     --enable-modules='anthocnet;wifi;mobility;applications;aodv;olsr;dsdv;flow-monitor;point-to-point'

set -euo pipefail

NS3DIR="${1:-}"
RUNS="${2:-10}"
NNODES="${3:-20}"
TIME="${4:-40}"
AREA="${5:-300}"
FLOWS="${6:-5}"

if [[ -z "$NS3DIR" || ! -x "$NS3DIR/ns3" ]]; then
    echo "usage: run-comparison.sh NS3DIR [runs] [nNodes] [time] [area] [flows]" >&2
    echo "  (NS3DIR must be a configured ns-3 tree with the anthocnet module)" >&2
    exit 2
fi

ARGS="--csv --runs=$RUNS --nNodes=$NNODES --time=$TIME --area=$AREA --flows=$FLOWS"

# Keep only the CSV (header + data rows); drop ns-3 build/run chatter.
( cd "$NS3DIR" && ./ns3 run "anthocnet-compare $ARGS" 2>/dev/null ) \
    | grep -E '^(protocol,|anthocnet,|aodv,|olsr,|dsdv,)'
