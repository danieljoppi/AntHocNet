#!/usr/bin/env bash
# Assemble the learn site (#545/#548): build the WASM core and copy it next to
# the static front end. Output: <out>/ (default web/build-site), ready to serve
# or to be the Pages artifact's root (site/; the docs go in under site/docs/).
# Needs an activated emsdk (emcmake) — pinned in ci.yml / pages.yml.
set -euo pipefail
cd "$(dirname "$0")/.."
OUT=${1:-web/build-site}
emcmake cmake -S web -B web/build-wasm -DCMAKE_BUILD_TYPE=Release >/dev/null
cmake --build web/build-wasm -j"$(nproc)" --target anthocnet >/dev/null
rm -rf "$OUT"
mkdir -p "$OUT"
cp -r web/site/. "$OUT/"
cp web/build-wasm/anthocnet.js web/build-wasm/anthocnet.wasm "$OUT/"
# The site's one top bar (#627), shared with the docs and the API reference.
python3 web/shell/inject.py game "$OUT"
# Cache-busting: the core and its glue must always arrive as a pair. Version
# both URLs with the WASM's content hash, so a deploy can never serve a cached
# old core to new JavaScript (GitHub Pages caches for 10 minutes).
v=$(sha256sum "$OUT/anthocnet.wasm" | cut -c1-12)
sed -i "s#'../anthocnet.js'#'../anthocnet.js?v=$v'#" "$OUT/js/engine.js"
sed -i "s#anthocnet.wasm#anthocnet.wasm?v=$v#g" "$OUT/anthocnet.js"
grep -q "anthocnet.js?v=$v" "$OUT/js/engine.js" || { echo "cache-bust: engine.js import not rewritten" >&2; exit 1; }
echo "learn site assembled in $OUT ($(du -sh "$OUT" | cut -f1))"
