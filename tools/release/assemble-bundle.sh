#!/usr/bin/env bash
# SPDX-License-Identifier: MIT OR GPL-2.0-only
# Assemble the release install bundle (#604): the one definition of what ships.
# release.yml calls it to build the zip; check-bundle.sh calls it to verify the
# contents on every PR that could change them, so the two can never drift.
#
# Usage: tools/release/assemble-bundle.sh VERSION OUTDIR
#   -> OUTDIR/anthocnet-VERSION/   (zip it yourself; release.yml does)
#
# What ships: the code (core/, ns3/, tools/), the docs, and the top-level files a
# user or contributor reads. What does not: agent-only material (.claude/ skills,
# AGENTS.md, CLAUDE.md), CI config, build output.
set -euo pipefail
VER=${1:?usage: assemble-bundle.sh VERSION OUTDIR}
OUT=${2:?usage: assemble-bundle.sh VERSION OUTDIR}
cd "$(dirname "$0")/../.."
dest="$OUT/anthocnet-$VER"
rm -rf "$dest"
mkdir -p "$dest"
for f in Makefile README.md LICENSE LICENSE-MIT LICENSING.md CHANGELOG.md CITATION.cff VERSION \
         CONTRIBUTING.md CODE_OF_CONDUCT.md SECURITY.md SUPPORT.md CONTEXT.md; do
  [ -e "$f" ] && cp "$f" "$dest/"
done
# Tracked files only: never ship build output, caches or local scratch.
git ls-files -z core ns3 tools docs results \
  | xargs -0 -I{} cp --parents {} "$dest/"
echo "$dest"
