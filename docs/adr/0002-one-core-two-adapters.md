# ADR-0002: One simulator-agnostic core, thin per-simulator adapters

- **Status:** Accepted
- **Date:** 2026-06-25

## Context

The protocol must run on **NS-2** and **NS-3**. These simulators have
fundamentally different architectures (OTcl + `Agent` + pooled C-style packet
headers vs. C++ `Ipv4RoutingProtocol` + `ns3::Header` serialization), so there
is no single universal patch or shared base class. The original code fused the
algorithm with NS-2 internals, which made it impossible to reuse and hard to
test.

## Decision

Adopt a **ports-and-adapters (hexagonal)** structure:

- All routing behaviour lives in [`core/`](../../core) and **never includes a
  simulator header**. It depends only on small interfaces (*ports*): `IClock`,
  `IRng`, `INeighborProvider`, `ITimerScheduler`.
- Each simulator provides a **thin adapter** that implements the ports and does
  only what is intrinsically simulator-specific: convert its packet header ⇄
  `core::AntMessage`, execute the core's `RouteDecision`s, own the periodic
  timers and pending-packet queue (and, for NS-2, the link-failure callback).
- Adapters **must not reimplement routing logic**.

## Consequences

- The algorithm is written, fixed, and unit-tested **once**; both simulators
  share it verbatim, so behaviour cannot silently diverge.
- Adding a third target is a new adapter, not a fork.
- The core is testable without any simulator (`make test`).
- A hard invariant to police in review: no simulator include may appear in
  `core/`, and no behaviour may leak into an adapter.
- Cross-simulator *metric* parity is still not guaranteed — MAC/PHY models
  differ — see [ADR-0005](0005-ns2-idempotent-anchor-patch.md) and the porting
  notes.
