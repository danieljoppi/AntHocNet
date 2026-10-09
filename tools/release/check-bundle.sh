#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0-only
# Release-package gate (#604). Assembles the bundle exactly as release.yml does
# and fails if it ships something it must not, or misses something it must:
#   - agent-only material: .claude/, AGENTS.md, CLAUDE.md, docs/handoffs/
#   - caches and build output: __pycache__, *.pyc, build/ dirs
#   - a shipped script that reaches into .claude/ (it would break in the package)
#   - the tools the shipped harness imports (tools/bench/*.py)
# It also checks that `git archive` (GitHub's "Source code" downloads, and what
# Zenodo archives) honours the same exclusions via .gitattributes export-ignore.
set -uo pipefail
cd "$(dirname "$0")/../.."
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
bundle=$(tools/release/assemble-bundle.sh 0.0.0-check "$tmp") || { echo "FAIL: assemble-bundle.sh"; exit 1; }
fail=0
bad() { echo "FAIL: $*"; fail=1; }
cd "$bundle"
for p in .claude AGENTS.md CLAUDE.md docs/handoffs .github; do
  [ -e "$p" ] && bad "bundle ships $p"
done
junk=$(find . \( -name __pycache__ -o -name '*.pyc' -o -type d -name build \) -print | head -5)
[ -n "$junk" ] && bad "bundle ships caches/build output: $junk"
# A dependency, not a mention: a path to a script under .claude/skills/, or the
# path built from parts (".claude", "skills").
refs=$(grep -rIlE '\.claude/skills/[^/"'"'"' ]+/[^/"'"'"' ]+\.(py|sh)|"\.claude", *"skills"' \
       --include='*.py' --include='*.sh' --include='*.cc' --include='*.h' \
       --include='CMakeLists.txt' --include='Makefile' --exclude-dir=release . 2>/dev/null | head -5)
[ -n "$refs" ] && bad "shipped code references .claude/ (breaks in the package): $refs"
for f in tools/bench/stats_util.py tools/bench/bench_parse.py tools/bench/scenario_check.py \
         tools/bench/pool_runs.py ns3/tools/anchors.yml core/CMakeLists.txt Makefile; do
  [ -e "$f" ] || bad "bundle is missing $f"
done
cd - >/dev/null
# The index tree with the working tree's .gitattributes: in CI that is HEAD;
# locally it includes staged changes.
arch=$(git archive --worktree-attributes --format=tar "$(git write-tree)" | tar -t)
for p in .claude/ AGENTS.md CLAUDE.md docs/handoffs/ .github/; do
  printf '%s\n' "$arch" | grep -q "^$p" && bad "git archive ships $p (add export-ignore)"
done
if [ "$fail" = 0 ]; then
  echo "ok: bundle $(find "$bundle" -type f | wc -l) files, no agent files, no caches, tools/bench present; git archive clean"
fi
exit "$fail"
