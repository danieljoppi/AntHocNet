#!/usr/bin/env bash
#
# cross-check.sh NS3DIR [runs] [nNodes] [area] [time] [flows]
#
# Runs the NS-3 side of an NS-2/NS-3 cross-validation: AntHocNet only, on a
# given scenario, averaged over `runs` seeds, emitting the CSV row (PDR, delay,
# throughput). Pair the numbers with an equivalent NS-2 run -- see
# docs/cross-validation.md.

set -euo pipefail

NS3DIR="${1:-}"
RUNS="${2:-10}"
NNODES="${3:-7}"
AREA="${4:-500}"
TIME="${5:-50}"
FLOWS="${6:-1}"

if [[ -z "$NS3DIR" || ! -x "$NS3DIR/ns3" ]]; then
    echo "usage: cross-check.sh NS3DIR [runs] [nNodes] [area] [time] [flows]" >&2
    exit 2
fi

ARGS="--protocols=anthocnet --csv --runs=$RUNS --nNodes=$NNODES --area=$AREA --time=$TIME --flows=$FLOWS"
( cd "$NS3DIR" && ./ns3 run "anthocnet-compare $ARGS" 2>/dev/null ) \
    | grep -E '^(protocol,|anthocnet,)'
