# ADR-0023: One core, one simulator adapter — the seam stays

- **Status:** Accepted
- **Date:** 2026-10-08
- **Supersedes:** [ADR-0002](0002-one-core-two-adapters.md) ("one
  simulator-agnostic core, thin per-simulator adapters"), on the number of
  simulator adapters only.
- **Decides:** [#307](https://github.com/danieljoppi/AntHocNet/issues/307) phase 3.

## Context

ADR-0002 split the protocol into a simulator-free `core/` and thin adapters
because it had to run on **NS-2 and NS-3**, two architectures with no shared
base. v2.0.0 removes the NS-2 adapter (#307): it was the only target that edited
the simulator's own tree (ADR-0005), it never got a benchmark harness, it costs
CI and packaging budget, and reviewers now read NS-2 as a reproducibility red
flag. It shipped frozen from v1.2.0 through v1.9.0.

That removes the reason ADR-0002 gave for the split. The question is whether the
split itself goes with it.

## Decision

**Keep the ports-and-adapters structure exactly as it is, with one simulator
adapter (ns-3).**

1. `core/` still never includes a simulator header, and depends only on its
   ports (`IClock`, `IRng`, `INeighborProvider`, `ITimerScheduler`).
   `check_invariants.sh` keeps enforcing that, and AGENTS.md golden rule 1 is
   unchanged.
2. The ns-3 adapter stays thin: it converts headers ⇄ `core::AntMessage`,
   executes `RouteDecision`s and owns timers and queues. It never reimplements
   routing logic.
3. The wire codec, the `kWireVersion` byte (ADR-0006) and every other core ADR
   stand unchanged.
4. A future simulator adapter (OMNeT++/INET, #32) is still a new adapter, not a
   fork — this ADR does not change how one would be added.

## Why the seam stays without a second simulator

- **The core still has two consumers.** The browser adapter
  ([ADR-0021](0021-the-browser-is-an-adapter.md)) compiles `core/` to
  WebAssembly for the learn site, held to native by a byte-identical
  decision-trace parity gate. A core that drifted toward ns-3 would break that
  gate, so "simulator-agnostic" stays a tested property rather than a memory.
- **The two-simulator demonstration does not expire.** v1.2.0 (DOI
  `10.5281/zenodo.21762983`) and every release through v1.9.0 ship both
  adapters over the same core. Anyone who doubts the seam was exercised
  against a second simulator can check out the tag.
- **Testability never depended on NS-2.** The core is unit-tested without any
  simulator (`make test`); that was the larger half of ADR-0002's payoff.
- **Undoing the split would cost and buy nothing.** Folding `core/` into the
  ns-3 module would invalidate the parity gate, the core unit tests and the
  #32 path in exchange for removing an include directory.

## Consequences

- ADR-0002 is marked superseded by this one; its reasoning stays readable.
- [ADR-0005](0005-ns2-idempotent-anchor-patch.md) (the NS-2 anchor patch) is
  **historical**: it describes how v1.x installed on NS-2 and governs nothing
  on `main`.
- Cross-simulator *metric* parity questions (ADR-0002's last consequence) no
  longer arise on `main`; [cross-validation.md](../cross-validation.md) is
  retired to a historical note.
- Docs that told a reader NS-2 was supported now point at the v1.2.0 / v1.9.0
  tags and images instead ([ns2-support.md](../ns2-support.md)).
