#!/usr/bin/env bash
# SPDX-License-Identifier: MIT OR GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
# The learn site's "Export to ns-3" kits run (#640). The pages job exports one
# kit per built-in world with web/tools/export-kit.mjs (the code behind the
# game's button); this runs each kit's own run.sh in an ns-3 tree with
# AntHocNet installed and requires AntHocNet to deliver: a kit that replays a
# scene nobody can route in, or that ns-3 refuses, fails here.
#
# Usage: check-ns3-kits.sh <ns3-dir> <kits-dir> "<world> [<world> ...]"
set -euo pipefail
# Marker fields are read by name through the tested reader, not by awk
# position (#791; tools/bench/test_bench_parse_query.py).
BENCH_PARSE="$(cd "$(dirname "$0")/../bench" && pwd)/bench_parse.py"
field() { python3 "$BENCH_PARSE" --get "$1" --from "$2" --proto "$3" -; }  # reads stdin
NS3DIR=${1:?usage: check-ns3-kits.sh <ns3-dir> <kits-dir> "<worlds>"}
KITS=${2:?}
WORLDS=${3:?}
fail=0
for w in $WORLDS; do
  kit="$KITS/$w"
  [ -f "$kit/run.sh" ] || { echo "FAIL: $w: no kit at $kit"; fail=1; continue; }
  for f in README.md run.sh; do [ -s "$kit/$f" ] || { echo "FAIL: $w: $f missing or empty"; fail=1; }; done
  if ! out=$(NS3DIR="$NS3DIR" bash "$kit/run.sh" 2>"$kit/stderr.log"); then
    echo "FAIL: $w: run.sh failed:"; tail -5 "$kit/stderr.log"; fail=1; continue
  fi
  # The harnesses' table row: "<arm> <PDR%> <delay> ..."
  pdr=$(printf '%s\n' "$out" | field pdr table anthocnet)
  if awk -v p="${pdr:-0}" 'BEGIN{exit !(p>0)}'; then echo "ok: $w kit — anthocnet PDR ${pdr}% on ns-3"
  else echo "FAIL: $w kit — anthocnet delivered nothing (PDR=${pdr:-none})"; printf '%s\n' "$out" | tail -8; fail=1; fi
done
[ "$fail" -eq 0 ] && echo "ns-3 kits: PASS" || { echo "ns-3 kits: FAIL"; exit 1; }
