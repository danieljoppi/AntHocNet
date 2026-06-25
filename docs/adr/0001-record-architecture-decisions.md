# ADR-0001: Record architecture decisions

- **Status:** Accepted
- **Date:** 2026-06-25

## Context

This project was refactored from a legacy NS-2-only implementation (buried in a
vendored `ns-allinone-2.34` tree) into a simulator-agnostic core with NS-2 and
NS-3 adapters. The new structure embodies several deliberate, non-obvious
decisions (a pure I/O-free core behind ports, POD ant messages with a canonical
codec, an idempotent anchor-based NS-2 patch). Without written rationale, future
contributors — human or LLM — will re-litigate settled choices or break
load-bearing invariants (e.g. by including a simulator header in `core/`).

## Decision

Keep lightweight **Architecture Decision Records** under `docs/adr/`, one per
significant or surprising decision, each stating Status, Context, Decision, and
Consequences. ADRs are append-only: supersede with a new ADR rather than
rewriting an old one.

Together with [`CONTEXT.md`](../../CONTEXT.md),
[`docs/architecture.md`](../architecture.md) and
[`docs/porting-notes.md`](../porting-notes.md), the ADRs form the documentation
corpus used for onboarding and "grill-with-docs" comprehension checks.

## Consequences

- Decisions and their trade-offs are discoverable from the repo.
- Reviews can cite an ADR instead of re-deriving context.
- A small ongoing cost to write an ADR when a notable decision is made.
