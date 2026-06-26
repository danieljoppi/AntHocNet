# ADR-0006: A 1-byte on-wire protocol version, no negotiation

- **Status:** Accepted — implementation tracked in
  [`docs/improvements/12-codec-hardening-and-threat-model.md`](../improvements/12-codec-hardening-and-threat-model.md)
- **Date:** 2026-06-25

## Context

[ADR-0004](0004-pod-ant-messages-and-codec.md) established a single canonical,
length-prefixed wire format shared by the codec and both adapters, and
[`AGENTS.md`](../../AGENTS.md) golden rule #4 requires that any change to
`AntMessage` fields be mirrored across the codec, the NS-2 header, the NS-3
header, and the round-trip tests *in the same field order*.

That rule keeps the **layout** in sync, but the frame has **no version marker**,
so two classes of change are undetectable on the wire:

- **Silent layout change** — adding/removing a field (e.g. the MAC-cost field in
  [item 10](../improvements/10-data-loops-multipath-and-mac-metric.md)).
- **Silent semantic change** — same bytes, new meaning: the back-ant time
  term's units in [item 02](../improvements/02-backward-ant-delay-metric.md), or
  `helloDests[].pheromone` going from a constant `1.0` to a real bootstrapped
  value in [item 03](../improvements/03-pheromone-diffusion.md).

A node on an old build and one on a new build would parse each other's frames as
garbage with **no error**. Within a single simulation run this cannot happen
(every node runs one identical build), but it silently breaks NS-2 ↔ NS-3
cross-validation and any saved trace/pcap compared across versions — exactly the
interoperability ADR-0004 set out to protect.

Several planned changes (items 02, 03, 10) are already churning the format, so
the cost of introducing a version marker is at its lowest now.

## Decision

- Add a **1-byte `version` field at offset 0** of every frame (a `kWireVersion`
  constant, starting at `0x01`), shifting `type` to offset 1.
- `deserialize` validates `version` **first**, before reading any length field,
  and returns `false` (drop) on any unknown value.
- The version constant is defined once in the codec and asserted identical by
  both adapter headers and the round-trip test. **Any change to field order,
  width, units, or semantics bumps `kWireVersion`** — semantic-only changes
  included.
- **No negotiation, translation, or fallback.** A version mismatch is a dropped
  packet. We do not support heterogeneous-version networks; we want cross-version
  artifacts to fail loudly rather than misparse.

The implementation rides along with the codec-hardening work in
[item 12](../improvements/12-codec-hardening-and-threat-model.md); the layout is
documented in [`docs/wire-format.md`](../wire-format.md).

## Alternatives considered

- **Freeze the layout, no version; document a "single-build, no on-wire
  versioning" invariant.** Zero wire cost, but leaves the silent-misparse hazard
  for cross-version traces and NS-2/NS-3 comparison, and makes the
  "one canonical format" invariant only prose, not machine-checkable. Rejected:
  the failure mode is silent, and the items in flight make a corruption
  plausible the first time someone compares two builds.
- **A multi-byte magic + version envelope (e.g. 4 bytes).** More robust framing,
  but costs airtime on every ant in a protocol whose overhead we benchmark
  ([item 08](../improvements/08-protocol-comparison-benchmarks.md)). One byte is
  enough to catch the realistic cases and keeps the metric honest.
- **Full version negotiation / per-version decoders.** Solves a heterogeneity
  problem this project does not have (one build per run). Pure over-engineering.

## Consequences

- A one-time wire break (taken now, alongside items 02/03/10) buys an O(1),
  pre-length-check rejection of foreign/garbage/stale frames — strengthening the
  untrusted-decode story in [item 12](../improvements/12-codec-hardening-and-threat-model.md).
- The "single canonical wire format" invariant becomes **machine-checkable**:
  the layout and its version move in lockstep across codec + both adapters +
  tests, so a forgotten adapter update surfaces as a version/round-trip test
  failure instead of a silent field-misalignment in a later simulation.
- Frame size grows by exactly 1 byte; the documented minimum frame is 61 bytes.
- Maintainers gain one more obligation in the golden-rule #4 checklist: **bump
  `kWireVersion` on any field or semantic change.** This is written into
  [`docs/wire-format.md`](../wire-format.md) and item 12's acceptance criteria.
