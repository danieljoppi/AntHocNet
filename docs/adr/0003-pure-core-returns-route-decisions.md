# ADR-0003: The core is pure and returns RouteDecisions

- **Status:** Accepted
- **Date:** 2026-06-25

## Context

Given the one-core/two-adapters split ([ADR-0002](0002-one-core-two-adapters.md)),
the core still has to express *effects* — send this ant to that neighbour,
broadcast, queue a data packet, deliver locally, drop. One option is to let the
core call back into the adapter (callbacks / an output port it invokes). That
re-introduces control-flow coupling and makes the core's behaviour depend on
when and how the adapter responds, which is hard to test deterministically.

## Decision

Make `AntRouterLogic` a **pure decision function**. Its entry points —
`onReceiveAnt(msg, prevHop)` and `onDataPacket(dst)` — **return values**:

```
std::vector<RouteDecision>
RouteDecision { RouteAction action; NodeAddress nextHop; AntMessage message; }
RouteAction ∈ { None, Unicast, Broadcast, Queue, Deliver, Drop }
```

The core performs no I/O: it reads time via `IClock` and randomness via `IRng`,
mutates only its own state (pheromone table, dedup history, sequence counter),
and hands back a list of decisions. The adapter maps each action onto its
simulator (schedule a send, enqueue, deliver to the local transport, drop).

## Consequences

- The state machine is **deterministic and unit-testable** from the injected
  clock/RNG with no simulator in the loop (`core/tests/test_router_logic.cpp`).
- Effects are explicit and auditable as data, not hidden in callbacks.
- The adapter owns *how* an action happens (e.g. NS-2 jitters broadcasts); the
  core owns *which* action happens.
- New effects require extending the `RouteAction` enum and handling it in both
  adapters — a deliberately visible, reviewable change.
