#!/usr/bin/env bash
# Mechanical AGENTS.md golden-rule checks on a diff, in one call — so a review
# doesn't spend a dozen greps/reads discovering them by hand. Reports PASS/WARN/
# FAIL per rule; exits non-zero if any FAIL. Heuristic, not a substitute for
# reading the diff — it catches the invariants that are cheap to check and easy
# to forget.
#
# Usage: check_invariants.sh [BASE]      (BASE defaults to origin/main)
set -u
cd "$(git rev-parse --show-toplevel)" || exit 2
BASE="${1:-origin/main}"
MB=$(git merge-base "$BASE" HEAD 2>/dev/null || echo "$BASE")
changed=$(git diff --name-only "$MB"...HEAD; git diff --name-only; git diff --cached --name-only)
changed=$(printf '%s\n' "$changed" | sort -u | grep -v '^$')
diff_txt=$(git diff "$MB"...HEAD; git diff; git diff --cached)
fail=0; warn=0
say() { printf '%-5s %s\n' "$1" "$2"; }

# Rule 1 — core/ must never include an NS-2/NS-3 header (the portability invariant).
bad=$(printf '%s\n' "$changed" | grep -E '^core/(src|include)/' \
      | while read -r f; do [ -f "$f" ] && grep -lE '#include\s*[<"](ns3|ns2)/' "$f"; done)
if [ -n "$bad" ]; then say FAIL "core/ includes an NS header:"; echo "$bad" | sed 's/^/        /'; fail=1
else say PASS "core/ has no NS-2/NS-3 headers"; fi

# Rule 1 (browser) — core/ must not include emscripten either; WASM glue lives in web/.
bad=$(printf '%s\n' "$changed" | grep -E '^core/(src|include)/' \
      | while read -r f; do [ -f "$f" ] && grep -lE '#include\s*[<"]emscripten' "$f"; done)
if [ -n "$bad" ]; then say FAIL "core/ includes an emscripten header (belongs in web/):"; echo "$bad" | sed 's/^/        /'; fail=1; fi

# Rule 4 — a wire-format change must bump kWireVersion (+ both adapters, test_codec, doc).
wire_touched=$(printf '%s\n' "$changed" | grep -E 'ant_message(\.h|_codec)' || true)
if [ -n "$wire_touched" ]; then
  if printf '%s\n' "$diff_txt" | grep -qE '^\+.*kWireVersion'; then
    say PASS "wire files changed and kWireVersion is bumped"
  else
    say WARN "wire files changed but no kWireVersion bump in the diff:"; echo "$wire_touched" | sed 's/^/        /'
    say WARN "  also update the ns-3 header (ns3/model/anthocnet-packet), test_codec.cpp, docs/wire-format.md"; warn=1
  fi
fi

# Rule 7 — core logic changes are covered by a core unit test.
core_src=$(printf '%s\n' "$changed" | grep -E '^core/(src|include)/' | grep -v '/tests/' || true)
core_test=$(printf '%s\n' "$changed" | grep -E '^core/tests/' || true)
if [ -n "$core_src" ] && [ -z "$core_test" ]; then
  say WARN "core/ logic changed but no core/tests/ file changed (golden rule #7)"; warn=1
elif [ -n "$core_src" ]; then
  say PASS "core/ change has an accompanying core/tests/ change"
fi

# Rule 8 — a new mechanism ships default-off (ADR-0019/0020).
on=$(printf '%s\n' "$diff_txt" | grep -E '^\+\s*bool\s+enable[A-Za-z0-9_]*\s*=\s*true' || true)
if [ -n "$on" ]; then
  say WARN "new default-ON switch in the diff — new mechanisms ship off (golden rule #8):"; echo "$on" | sed 's/^/        /'; warn=1
fi

# Rule 9 — browser adapter changes must keep native/WASM parity.
if printf '%s\n' "$changed" | grep -qE '^web/(src|include)/'; then
  say WARN "web/ adapter changed — run web/test/parity.sh and web/test/smoke.mjs (learn-site skill)"; warn=1
fi

# Rule 10 — nothing shipped depends on .claude/ (ADR-0014 amendment, #604).
dep=$(printf '%s\n' "$changed" | grep -vE '^(\.claude/|tools/release/|AGENTS\.md|CLAUDE\.md|docs/handoffs/)' \
      | while read -r f; do [ -f "$f" ] && grep -lE '\.claude/skills/[^ ]+\.(py|sh)|"\.claude", *"skills"' "$f"; done)
if [ -n "$dep" ]; then say FAIL "shipped file depends on a .claude/skills script (move it to tools/):"; echo "$dep" | sed 's/^/        /'; fail=1; fi

# New docs page must be in the mkdocs nav (else it is unreachable on the site).
for f in $(printf '%s\n' "$changed" | grep -E '^docs/.*\.md$' | grep -vE '^docs/handoffs/'); do
  [ -f "$f" ] || continue
  git cat-file -e "$MB:$f" 2>/dev/null && continue
  grep -qF "${f#docs/}" mkdocs.yml || { say WARN "new page $f is not in the mkdocs.yml nav"; warn=1; }
done

# Behavioural change to a documented decision should touch a doc/ADR.
if [ -n "$core_src$wire_touched" ] && ! printf '%s\n' "$changed" | grep -qE '^docs/'; then
  say WARN "core/adapter change with no docs/ update — confirm no ADR/improvement doc needs it"; warn=1
fi

echo "----"
if [ "$fail" = 1 ]; then say FAIL "invariant violation — must fix before merge"; exit 1
elif [ "$warn" = 1 ]; then say WARN "review the warnings above"; exit 0
else say PASS "mechanical invariants clean"; exit 0; fi
