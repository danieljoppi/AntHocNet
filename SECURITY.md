# Security Policy

AntHocNet is a **research routing protocol** for simulation (NS-2 / NS-3). This
document records its security posture honestly rather than promising guarantees
the protocol does not provide.

## Trust boundary

`core::codec::deserialize` is the **only** parser of untrusted bytes (an ant
frame arriving from the network). It is:

- **over-read safe** — every length-prefixed section is bounds-checked against
  the remaining buffer before it is read or allocated;
- **bound-enforcing** — declared element counts (`visited`, `history`,
  `helloDests`) are rejected if they exceed the protocol caps
  (`kMaxVisitedOnWire` / `kMaxHistoryOnWire` / `kMaxHelloOnWire`), so a peer
  cannot push 16-bit-max counts past the algorithm's invariants;
- **version- and enum-validating** — a frame whose offset-0 wire-version byte
  does not match `kWireVersion`, or whose `type`/`direction` byte is not a known
  enum value, is rejected in O(1) before any further parsing.

In scope for the implementation to guarantee: a single malformed packet cannot
crash, over-read, over-allocate, or violate the bounded-structure invariants.

## Known, by-design limitations (out of scope)

These are inherent to vanilla AntHocNet, not implementation bugs:

- **Ants are unauthenticated.** A malicious node can inject false pheromone
  (blackhole / greyhole), advertise bogus hello destinations, or mount wormhole
  attacks. Mitigations (signed control messages, trust / reputation systems) are
  research extensions, not protocol fixes.
- **Limited replay protection.** Replays are suppressed only by the bounded
  `(src, seq)` dedup history; once an entry is evicted, a replay is possible.

## Reporting a vulnerability

This is a research / educational codebase. If you find a memory-safety or
resource-exhaustion issue in the parser (the in-scope surface above), please
open an issue describing the malformed input and the observed behaviour.
