<!--
Title: conventional-commit style, lowercase subject — `feat(core): add the …`,
not `feat(core): Add the …` (lint-title enforces this).
Scopes in use: core, ns2, ns3, bench, ci, docs.
-->

## What & why

<!-- What changes, and the reasoning/measurement behind it. Link the issue
     that motivated it — findings and decisions live in issues (ADR-0013),
     so a reviewer can trace the evidence chain. -->

## Verification

<!-- Keep only the rows that apply, with real numbers/output:
- core `make test` result (a core/ logic change must add or extend a core test — golden rule)
- protocol-behaviour change: A/B against `main` on identical seeds (both regimes
  where relevant), runs linked — see CONTRIBUTING.md
- wire-format change: `kWireVersion` bumped, both adapter headers + `test_codec` + `docs/wire-format.md` updated
- docs-only: link check
-->

## Record

<!-- Delete what doesn't apply:
- ADR added/updated (a documented decision changed)
- `docs/configuration.md` / `docs/fidelity.md` rows touched (a default or
  fidelity claim changed)
- Closes #NNN / Refs #NNN
-->
