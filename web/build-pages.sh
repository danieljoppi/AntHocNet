#!/usr/bin/env bash
# Assemble the whole Pages site (#626): the game at /, the docs at /docs/, the
# API reference at /api/, every page under the one top bar (web/shell/), and the
# old-URL redirects. pages.yml deploys this; CI's web job smoke-tests it.
# Needs: an activated emsdk, mkdocs-material (requirements-dev.txt), doxygen.
set -euo pipefail
cd "$(dirname "$0")/.."
OUT=${1:-web/build-pages}
web/build-site.sh "$OUT"                       # empties $OUT first
mkdocs build --strict --site-dir "$OUT/docs"
mkdir -p build/api
AHN_VERSION="$(cat VERSION)" doxygen api/Doxyfile >/dev/null
rm -rf "$OUT/api" && cp -r build/api/html "$OUT/api"
python3 web/shell/inject.py api "$OUT/api"
python3 web/shell/api_index.py build/api/xml "$OUT/api/api-index.json"   # the Nest (#635)
web/site-redirects.sh "$OUT"
echo "pages assembled in $OUT ($(du -sh "$OUT" | cut -f1))"
