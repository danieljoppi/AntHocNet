#!/usr/bin/env bash
# Native-vs-WASM decision-trace parity (#544, ADR-0021): the browser must run
# the same core making the same decisions as a native build. Builds
# ahn-web-trace both ways, runs every built-in scenario for several seeds, and
# requires byte-identical traces (every ant and data transmission, reception,
# route change, queue and drop, with simulated time).
#
# Usage: web/test/parity.sh [seconds=120] [seeds="1 2 7 42"]
# Needs: a native C++ toolchain, cmake, node, and an activated emsdk (emcmake).
set -euo pipefail
cd "$(dirname "$0")/../.."
SECONDS_RUN=${1:-120}
SEEDS=${2:-"1 2 7 42"}
OUT=$(mktemp -d)
trap 'rm -rf "$OUT"' EXIT

cmake -S web -B web/build -DCMAKE_BUILD_TYPE=Release >/dev/null
cmake --build web/build -j"$(nproc)" >/dev/null
emcmake cmake -S web -B web/build-wasm -DCMAKE_BUILD_TYPE=Release >/dev/null
cmake --build web/build-wasm -j"$(nproc)" >/dev/null

fail=0
for s in $SEEDS; do
    web/build/ahn-web-trace "$SECONDS_RUN" "$s" > "$OUT/native-$s.txt"
    node web/build-wasm/ahn-web-trace.js "$SECONDS_RUN" "$s" > "$OUT/wasm-$s.txt"
    lines=$(wc -l < "$OUT/native-$s.txt")
    if cmp -s "$OUT/native-$s.txt" "$OUT/wasm-$s.txt"; then
        echo "ok: seed $s — $lines trace lines byte-identical"
    else
        echo "FAIL: seed $s — native and WASM traces differ:"
        diff "$OUT/native-$s.txt" "$OUT/wasm-$s.txt" | head -20
        fail=1
    fi
    # A trace that delivers nothing proves nothing: require traffic in every
    # scenario.
    if awk '/^# flow/ { split($5, d, "="); if (d[2] + 0 == 0) bad = 1 } END { exit bad }' \
        "$OUT/native-$s.txt"; then :; else
        echo "FAIL: seed $s — a flow delivered nothing"
        grep '^# flow' "$OUT/native-$s.txt"
        fail=1
    fi
done
[ "$fail" -eq 0 ] && echo "parity: PASS" || { echo "parity: FAIL"; exit 1; }
