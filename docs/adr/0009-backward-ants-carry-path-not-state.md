# ADR-0009: The wire carries path observations, not computed state

- **Status:** Accepted — implementation tracked in
  [`improvements/02`](../improvements/02-backward-ant-delay-metric.md)
- **Date:** 2026-06-25

## Context

Fixing the backward-ant delay metric ([item 02](../improvements/02-backward-ant-delay-metric.md))
already changes the meaning of `AntHop.time` (cumulative-since-source → per-hop
delta), which is a semantic change to an existing wire field and therefore bumps
`kWireVersion` ([ADR-0006](0006-on-wire-protocol-version.md)) regardless.

While scoping that change we found that a backward ant serializes four fields —
`pheromone`, `hops`, `prevSINR`, `prevHop` — that are **transient compute state**:

- Verified in both adapters (`ns2/src/ant_packet_ns2.cc`,
  `ns3/model/anthocnet-packet.cc`): they are only *marshaled* header ⇄
  `AntMessage`; neither adapter reads them to make a routing decision.
- The core recomputes them at every hop in `advanceBackAnt` (`hops += 1`,
  `prevHop = current.node`, `pheromone = …`). They do not need to survive across
  a hop on the wire.

Carrying them is wasted airtime (relevant to the overhead AntHocNet is
benchmarked on, [item 08](../improvements/08-protocol-comparison-benchmarks.md))
and a trust hazard: a node *could* believe an upstream-supplied `pheromone`
instead of computing its own.

## Decision

**A backward ant's wire image carries identity + the path observation, and each
node computes pheromone locally.** Concretely, as part of item 02:

- **Drop `pheromone`, `hops`, `prevSINR`, `prevHop` from the serialized format.**
  They become (at most) core-local working fields. `prevSINR` is therefore
  *removed*, not renamed — the misnomer simply leaves the wire.
- **Encode time as a per-hop delta** in the existing `AntHop.time` slot (seconds),
  summed on the backward pass — so no new `timeDest` field is added and the frame
  shrinks rather than grows.
- **Bump `kWireVersion`.** Do **not** hard-code the new number: it is a monotonic
  counter, so use `current + 1`. Coordinate with item 12 — whichever of
  {item 02, item 12} lands first introduces the `kWireVersion` constant; the
  other bumps it. See [`docs/wire-format.md`](../wire-format.md) for the target
  layout.

This is a refinement of [ADR-0004](0004-pod-ant-messages-and-codec.md)'s "one
canonical wire format": the format encodes what was *observed* (the path and its
per-hop timing), not what a node *derived* from it.

## Alternatives considered

- **Keep marshaling the four fields (minimal item 02).** Lower blast radius for a
  P0 fix, and ADR-0006 makes a later slim cheap and detectable. Rejected because
  the slim is provably low-risk here — the fields are dead-on-the-wire, so we are
  deleting unused serialized state, not changing logic — and item 02 is already
  an atomic codec + both-headers + `test_codec.cpp` change, so the slim costs no
  extra version bump.
- **Absolute arrival time + a new `timeDest` field.** Simpler subtraction, but
  *grows* the wire with a field whose only purpose is cross-hop time math that the
  per-hop-delta encoding does without. Rejected in favour of the delta.

## Consequences

- Every backward ant is smaller (four fewer fixed fields: −24 bytes), trimming
  control overhead.
- Item 12's threat model tightens: there is no upstream-supplied pheromone/hop
  count to validate or distrust — those values never cross the boundary.
- `prevSINR` disappears from the struct's wire image; if a local time accumulator
  is still wanted it is a private working field, not a serialized one.
- Forward and backward ants now have clearly different wire footprints (the
  backward ant adds nothing beyond the path it inherited) — documented in
  [`docs/wire-format.md`](../wire-format.md).
- One more reason the codec must recompute, never trust: a regression test should
  assert the decoder leaves `pheromone`/`hops` at defaults (they are not on the
  wire) and the core fills them.
- **Single-scalar-cost invariant.** Each per-hop path entry stays `{node, cost}` —
  one scalar. A MAC-aware or otherwise richer per-hop cost (item 10/A2) enters by
  *improving the measurement* fed into that scalar at `stampForward`
  (`ILinkDelay`), never by adding per-hop signal fields. The pheromone-metric port
  (item 16, `ILinkMetric`) is the orthogonal seam for combining path aggregates +
  node-local signals. Adding per-hop *downstream* signal fields to the wire is a
  separate, ADR-gated decision, not a default extensibility point.
