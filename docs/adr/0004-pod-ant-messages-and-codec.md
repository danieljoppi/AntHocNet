# ADR-0004: POD ant messages with a single canonical wire codec

- **Status:** Accepted
- **Date:** 2026-06-25

## Context

The original ant packet stored its visited-node path as a heap-allocated
`AntTimeEntry**` array referenced from the NS-2 packet header. NS-2 pools and
**byte-copies** header memory and runs no constructors, so:

- broadcasting an ant duplicated the raw pointer → **double-free**;
- the arrays were never freed → **leak**;
- `size()` returned `sizeof(pointer)` → a wrong serialized packet size,
  distorting MAC/airtime modelling.

Each simulator also needs to serialize ants, and the two must agree on the wire
layout or they cannot interoperate or be compared.

## Decision

- Represent an ant as a **plain, copyable value type** `AntMessage` (type,
  direction, src/dst, 32-bit `seqNum`, timing, `VisitedPath` =
  `std::vector<AntHop>`, history, hello adverts, back-ant pheromone fields). No
  heap-resident pointers in any packet header.
- Define **one canonical, length-prefixed little-endian wire format** in
  `core/ant_message_codec`. Both adapter headers — the NS-2 POD
  `ant_packet_ns2` and the NS-3 `AntHeader` — follow the **same field order**,
  and the codec is round-trip tested (`core/tests/test_codec.cpp`).
- Bound the carried path and the dedup history via `Config::maxPathLength` /
  `maxHistory` so they cannot grow without limit.

## Consequences

- The double-free, the leak, and the wrong-size bug are eliminated by
  construction.
- Value semantics make ants trivially copyable/broadcastable and testable.
- **Coupling to manage:** changing `AntMessage`'s fields means updating, in the
  same order, the codec, the NS-2 header, the NS-3 header, and the round-trip
  tests. This is called out as a golden rule in [`AGENTS.md`](../../AGENTS.md).
- A POD header has a fixed capacity; `maxPathLength` caps the worst-case size.
