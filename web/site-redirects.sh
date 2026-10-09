#!/usr/bin/env bash
# Keep the old Pages URLs working after the front-page move (ADR-0021,
# amendment 2026-10-09): the game is the site root, the docs moved from / to
# /docs/, and the game itself used to live at /learn/. For every rendered docs
# page this writes a stub at its old path that forwards to the new one, hash
# included, so links in papers, issues and the Zenodo records still land.
# Usage: web/site-redirects.sh <site-root>   (after the docs are in <site>/docs)
set -euo pipefail
SITE=${1:?usage: site-redirects.sh <site-root>}
[ -d "$SITE/docs" ] || { echo "no $SITE/docs: build the docs first" >&2; exit 1; }

stub() { # stub <file> <relative-target>
  mkdir -p "$(dirname "$1")"
  cat > "$1" <<HTML
<!doctype html>
<html lang="en"><head><meta charset="utf-8"><title>Moved</title>
<link rel="canonical" href="$2">
<meta http-equiv="refresh" content="0; url=$2">
<script>location.replace("$2" + location.search + location.hash);</script>
</head><body><p>This page moved: <a href="$2">$2</a>.</p></body></html>
HTML
}

n=0
while IFS= read -r page; do
  rel=${page#"$SITE/docs/"}          # e.g. benchmarks/grid/index.html
  [ "$rel" = index.html ] && continue  # the root is the game now
  [ -e "$SITE/$rel" ] && { echo "redirect would overwrite $SITE/$rel" >&2; exit 1; }
  dir=$(dirname "$rel")
  up=$(printf '%s' "$dir" | sed -E 's#[^/]+#..#g')
  stub "$SITE/$rel" "$up/docs/$dir/"
  n=$((n + 1))
done < <(find "$SITE/docs" -name index.html | sort)

# The game's old home; its #world?seed=N hash carries over.
stub "$SITE/learn/index.html" "../"
# mkdocs' 404 page uses absolute URLs, so it serves the whole site.
cp "$SITE/docs/404.html" "$SITE/404.html"
echo "redirects: $n docs pages + /learn/"
