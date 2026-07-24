# ADR-0014: Agent skills are script-first — analysis and validation run in scripts, not in LLM context

- **Status:** Accepted — tooling tracked in #134 (scenario validation),
  consumers in #128 (paired stats), #131 (##PERF## pass-through)
- **Date:** 2026-07-24

## Context

Much of the recurring agent work in this repo is not code change but *data
work*: parsing benchmark tables, computing A/B deltas, judging run-to-run
noise, validating scenario configs and result plausibility, transforming
campaign CSVs for the papers repo. Done "in context" — the model reading raw
tables and doing arithmetic in its head — this work is:

1. **Error-prone.** The #47/#68/#71 EnableMacMetric episode showed the exact
   failure: eyeballed deltas with opposite signs across pairs read as signal
   when they were noise. A scripted, thresholded verdict does not make that
   mistake twice.
2. **Token-expensive.** A classified campaign CSV is ~25 columns × dozens of
   rows; a CI job log is hundreds of lines. Loading them into context on
   every session burns budget the CLAUDE.md token-economy policy exists to
   save — and the numbers themselves must stay byte-exact, which summarising
   in prose does not guarantee.
3. **Non-reproducible across sessions.** An in-context judgement leaves no
   artifact; the next session (any model) re-derives it, possibly
   differently. ADR-0013 solved this for *findings* (issues); this ADR
   solves it for *procedures*.

## Decision

Recurring parse/analysis/validation loops ship as **executable scripts inside
the agent skills** (`.claude/skills/`), and the skill instructions direct the
model to run the script and read only its compact output. Rules:

1. **Raw data stays out of context.** Job-log tails and CSVs are saved to
   files and handed to scripts; only verdict lines (a delta grid, a
   FAIL/WARN/OK summary) should be read back. Never eyeball tables, compute
   deltas by hand, or hand-type result numbers.
2. **Scripts are stdlib-only Python** (or POSIX shell), runnable in any
   sandbox with no installs, and are **validated against real repo data**
   before landing (e.g. the rescued #122 campaign CSVs, the committed
   `##BENCH##` formats).
3. **Thresholds live in one place.** Scripts read shared threshold files
   (e.g. `ns3/tools/anchors.yml`, #59) rather than duplicating constants
   that would drift.
4. **New recurring analysis extends a script** rather than being performed
   in context; one-off exploration is fine in context but graduates to a
   script the second time it recurs.

Current inventory:

| Script | Skill | Job |
|---|---|---|
| `bench_parse.py` | `benchmark-results` | parse `##BENCH##` cells, A/B deltas, noise verdict |
| `sweep_summary.py` | `benchmark-results` | campaign-CSV schema check, per-point deltas, stddev-aware noise call, papers export |
| `scenario_check.py` | `benchmark-results` | pre-flight scenario degeneracy checks; result plausibility + anchor floors (#134) |
| `check_invariants.sh` | `protocol-review` | golden-rule checks on a diff |
| `figdata.py` | `figures` (papers repo) | campaign CSV / `##BENCH##` → paper plot data, diff report, preliminary-flag audit |

## Alternatives considered

- **Keep procedures in prose (SKILL.md/issue notes only).** The procedure
  survives, but the arithmetic still happens in context — the #47-class
  errors and the token cost remain. Rejected.
- **A single monolithic CLI tool in `tools/`.** Couples agent workflow
  tooling to the shipped software; skills keep agent-facing tooling
  discoverable at the point of use and out of release artifacts. Rejected.
- **CI-only enforcement (no local scripts).** CI gates (e.g. #59 anchors)
  catch regressions post-push but cannot do pre-flight checks before an
  expensive dispatch (#121) or ad-hoc A/B analysis mid-session. The two are
  complementary; CI enforcement alone is insufficient.

## Consequences

- Session context spends tokens on decisions, not on tables; verdicts are
  identical across sessions and models.
- The scripts are themselves code: they need the same review care, and their
  formats (e.g. `##BENCH##`, the classified CSV schema) become interfaces —
  a harness output change must update the parsers in the same PR.
- The papers repo participates via its `figures` skill (`figdata.py`), so
  numbers cross the repo boundary only through validated transforms
  (papers-repo golden rules 1–3), never by hand.
