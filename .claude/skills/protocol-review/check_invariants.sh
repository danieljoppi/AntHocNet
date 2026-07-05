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

# Rule 4 — a wire-format change must bump kWireVersion (+ both adapters, test_codec, doc).
wire_touched=$(printf '%s\n' "$changed" | grep -E 'ant_message(\.h|_codec)' || true)
if [ -n "$wire_touched" ]; then
  if printf '%s\n' "$diff_txt" | grep -qE '^\+.*kWireVersion'; then
    say PASS "wire files changed and kWireVersion is bumped"
  else
    say WARN "wire files changed but no kWireVersion bump in the diff:"; echo "$wire_touched" | sed 's/^/        /'
    say WARN "  also update both adapter headers, test_codec.cpp, docs/wire-format.md"; warn=1
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

# Behavioural change to a documented decision should touch a doc/ADR.
if [ -n "$core_src$wire_touched" ] && ! printf '%s\n' "$changed" | grep -qE '^docs/'; then
  say WARN "core/adapter change with no docs/ update — confirm no ADR/improvement doc needs it"; warn=1
fi

echo "----"
if [ "$fail" = 1 ]; then say FAIL "invariant violation — must fix before merge"; exit 1
elif [ "$warn" = 1 ]; then say WARN "review the warnings above"; exit 0
else say PASS "mechanical invariants clean"; exit 0; fi
