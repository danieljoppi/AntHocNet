# 12 — Codec hardening (enforce protocol bounds on untrusted input) + threat model

- **Covers:** C1
- **Priority:** P1 (trust-boundary; cheap to fix)
- **Effort:** S
- **Layer:** `core/` (codec) + docs (`SECURITY.md`)
- **Depends on:** nothing

## Summary

The wire codec decodes packets that arrive from the network (untrusted). It is
already **over-read safe** — every length is checked against the remaining bytes
before use — but it does **not** enforce the protocol's own bounds
(`Config::maxPathLength`, `Config::maxHistory`) on decoded counts. That breaks
golden-rule #5 ("keep bounded structures bounded") precisely at the trust
boundary, and lets a peer push 16-bit-max element counts. This item clamps the
decode and adds a fuzz target, plus writes down the (currently implicit) threat
model.

It also introduces the **1-byte wire-version field** decided in
[ADR-0006](../adr/0006-on-wire-protocol-version.md): a version mismatch is the
cheapest, earliest possible rejection of a foreign/garbage frame, so it belongs
in the same hardening pass. The full byte layout is in
[`docs/wire-format.md`](../wire-format.md).

## What's already good (don't regress)

`deserialize` bounds every variable-length section against the buffer before
resizing:

```134:147:core/src/ant_message_codec.cpp
    const std::uint16_t nVisited = r.u16();
    if (!r.ok || r.remaining < static_cast<std::size_t>(nVisited) * kHopSize) return false;
    msg.visited.resize(nVisited);
    for (auto& h : msg.visited) { h.node = r.i32(); h.time = r.dbl(); }

    const std::uint16_t nHistory = r.u16();
    if (!r.ok || r.remaining < static_cast<std::size_t>(nHistory) * kHopSize) return false;
    msg.history.resize(nHistory);
    ...
    const std::uint16_t nHello = r.u16();
    if (!r.ok || r.remaining < static_cast<std::size_t>(nHello) * kHelloSize) return false;
```

So a malformed packet cannot cause an out-of-bounds read or allocate more than
the buffer can back. Good.

## The gap

- The counts are only bounded by `uint16` (≤ 65535) and by the incoming buffer
  size, **not** by `maxPathLength` / `maxHistory`. A crafted (or just buggy) peer
  can hand the core a `visited`/`history` far larger than the algorithm's
  invariant allows, which then flows into router logic that assumes those caps.
- `msg.type` / `msg.direction` are cast straight from a byte to the enums with no
  validation — an unknown value becomes an out-of-range enum.
- No fuzzing exists for the parser, despite it being the only code that touches
  untrusted bytes.

## Required change

### 0. Add the wire-version field (ADR-0006)

Prepend a 1-byte `version` at **offset 0** of the frame (shifting `type` to
offset 1) and validate it before anything else:

```cpp
// codec-local constant, asserted identical in both adapter headers + tests:
constexpr std::uint8_t kWireVersion = 0x01;

// serialize(): write first
putU8(out, kWireVersion);

// deserialize(): read + check first, before any length field
if (r.u8() != kWireVersion) return false;   // foreign / stale / garbage frame
```

This is an O(1) reject at the trust boundary, ahead of the count checks below.
Bump `kWireVersion` on any future field/semantic change (this is the
golden-rule #4 maintenance rule; see [`docs/wire-format.md`](../wire-format.md)).
Update the NS-2 (`ant_packet_ns2`) and NS-3 (`AntHeader`) headers and their
`wireSize()` / `GetSerializedSize()` to account for the extra byte.

### 1. Clamp decoded counts to protocol bounds

`deserialize` should reject (or clamp) counts that exceed the configured maxima.
Two options — pick reject for strictness:

```cpp
// after reading nVisited, before resize:
if (nVisited > kMaxVisitedOnWire) return false;   // kMaxVisitedOnWire == Config::maxPathLength default
```

Since the free-function codec has no `Config`, expose the caps as codec
constants (mirroring the `Config` defaults) or add an overload that takes the
caps. Apply to `visited`, `history`, and `helloDests`.

### 2. Validate the enums

After reading `type`/`direction`, verify they are one of the known values;
return `false` (drop) otherwise. Prevents undefined enum values reaching the
state machine.

### 3. Add a fuzz target

Add `core/tests/fuzz_codec.cpp` (libFuzzer):

```cpp
extern "C" int LLVMFuzzerTestOneInput(const uint8_t* data, size_t size) {
    anthocnet::core::AntMessage m;
    anthocnet::core::codec::deserialize(data, size, m);  // must never crash/UB
    return 0;
}
```

Wire an optional `-DANTHOCNET_FUZZ=ON` CMake path (clang `-fsanitize=fuzzer,address`).
A short OSS-style run in CI (e.g. 60 s) on PRs touching the codec is enough.

### 4. Round-trip + clamp tests

Extend `core/tests/test_codec.cpp`: a packet declaring `nVisited` beyond the cap
is rejected; an out-of-range `type` byte is rejected; a truncated buffer for each
section returns `false` (already implicitly covered — make it explicit).

## Threat model (write into `SECURITY.md`)

Document the protocol's security posture honestly (it's a research routing
protocol):

- **Trust boundary:** `codec::deserialize` is the only parser of untrusted bytes;
  it is over-read safe and (after this item) bound-enforcing and enum-validating.
- **Known, by-design limitations (out of scope to fix in the algorithm):**
  - Ants are **unauthenticated** — a malicious node can inject false pheromone
    (blackhole/greyhole), advertise bogus hello destinations, or mount wormhole
    attacks. This is inherent to vanilla AntHocNet; mitigations (signed control
    messages, trust/reputation) are research extensions, not protocol bugs.
  - No replay protection beyond `(src,seq)` dedup (bounded history → replays
    after eviction are possible).
- **In scope (this item):** memory-safety and resource-bound enforcement of the
  parser so a single malformed packet cannot crash, over-read, or violate the
  bounded-structure invariant.

## Files to touch

- `core/src/ant_message_codec.cpp` + its header (version byte + `kWireVersion`;
  clamp + enum validation; expose caps)
- `ns2/src/ant_packet_ns2` + `ns3/model/anthocnet-packet` (account for the extra
  version byte; assert the same `kWireVersion`)
- `core/tests/test_codec.cpp` (version-mismatch, clamp, enum, truncation tests)
- `core/tests/fuzz_codec.cpp` + `core/tests/CMakeLists.txt` (optional fuzz target)
- `docs/wire-format.md` (already documents the layout — keep offsets in sync)
- `SECURITY.md` (threat model section)
- `.github/workflows/ci.yml` (optional short fuzz job on codec changes)

## Acceptance criteria

1. A frame whose offset-0 byte is not `kWireVersion` is rejected
   (`deserialize` returns `false`) before any length field is read; valid frames
   carry the version byte and still round-trip.
2. A packet with `nVisited`/`nHistory`/`nHello` above the configured caps is
   rejected (`deserialize` returns `false`); valid packets still round-trip
   (existing `test_codec.cpp` passes).
3. An out-of-range `type`/`direction` byte is rejected.
4. The fuzz target builds and runs without crashes/UB on a short corpus.
5. `SECURITY.md` documents the trust boundary + the unauthenticated-ants
   limitation.
6. Both adapter headers account for the version byte and assert the same
   `kWireVersion`; `make test` green; golden rules #4 and #5 now hold at the wire
   boundary too.

## Risks / notes

- Rejecting (vs clamping) is safer but means a peer running a larger
  `maxPathLength` than this node will have its legitimately-long ants dropped —
  keep the on-wire cap a documented constant shared by both adapters (it already
  must match across the codec + NS-2 + NS-3 headers).
- Keep the codec free of `Config` coupling if possible (use codec-local constants
  that equal the `Config` defaults) to preserve its standalone testability.
