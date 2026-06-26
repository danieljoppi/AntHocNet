# Wire format

Canonical, simulator-agnostic on-wire layout of an ant packet. This is the
single source of truth referenced by [`AGENTS.md`](../AGENTS.md) golden rule #4
and by [`docs/porting-notes.md`](porting-notes.md). The encoder/decoder lives in
`core/src/ant_message_codec.cpp`; the NS-2 header (`ns2/src/ant_packet_ns2`) and
the NS-3 `AntHeader` (`ns3/model/anthocnet-packet`) both delegate to it, so a
byte produced on one simulator is interpreted identically on the other.

All multi-byte integers and `double`s are **little-endian**. Variable arrays are
**length-prefixed** with a `uint16` count. There is exactly one layout — see
[ADR-0006](adr/0006-on-wire-protocol-version.md) for why we version it and why
we do *not* negotiate alternative layouts.

> **Status.** The table below is the layout **the codec emits today**. The
> offset-0 version byte + bounds/enum enforcement
> ([item 12](improvements/12-codec-hardening-and-threat-model.md), ADR-0006) and
> the per-hop-delta `AntHop.time` semantic
> ([item 02](improvements/02-backward-ant-delay-metric.md)) have **landed**. Two
> decided changes remain under [planned evolution](#planned-wire-evolution): the
> backward-ant *byte slim* (removing the four transient fields,
> [item 02](improvements/02-backward-ant-delay-metric.md)/ADR-0009) and the
> repair/link-failure additions ([item 05](improvements/05-link-failure-detection-and-repair.md)).
> Keep this section in sync with the code as each lands.

## Frame layout (current code)

| Offset | Field | Type | Bytes | Meaning |
|-------:|-------|------|------:|---------|
| 0  | `version`   | `u8`     | 1 | Wire-format version (`kWireVersion`, currently `0x02`). Checked first; a mismatch is rejected in O(1). |
| 1  | `type`      | `u8`     | 1 | Ant role (`AntType`): `0x01` Hello, `0x02` Reactive, `0x04` Proactive, `0x08` Repair, `0x10` LinkFail. Validated on decode. |
| 2  | `direction` | `u8`     | 1 | `AntDirection`: `0x11` Up (forward), `0x12` Down (backward). Validated on decode. |
| 3  | `src`       | `i32`    | 4 | Originating node. |
| 7  | `dst`       | `i32`    | 4 | Final destination. |
| 11 | `seqNum`    | `u32`    | 4 | Per-source ant sequence number (32-bit; see [vs. original](#vs-the-original-implementation)). |
| 15 | `timeStart` | `f64`    | 8 | Generation time, for trip-time accounting. |
| 23 | `lifeAnt`   | `f64`    | 8 | Repair-ant lifetime budget (seconds). |
| 31 | `broadcastBudget` | `i32` | 4 | Remaining (re)broadcasts allowed (`-1` = untracked); bounds repair/LinkFail propagation ([item 05](improvements/05-link-failure-detection-and-repair.md)). |
| 35 | `prevHop`   | `i32`    | 4 | Previous hop (set while a backward ant retraces). *Slated for byte-removal — item 02.* |
| 39 | `hops`      | `i32`    | 4 | Hop count accumulated so far. *Slated for byte-removal — item 02.* |
| 43 | `prevSINR`  | `f64`    | 8 | Accumulated path-time term (misnamed; **removed**, not renamed, by [item 02](improvements/02-backward-ant-delay-metric.md)). |
| 51 | `pheromone` | `f64`    | 8 | Running pheromone estimate on the backward ant. *Slated for byte-removal — item 02.* |
| 59 | `nVisited`  | `u16`    | 2 | Count of `visited` entries (rejected if `> kMaxVisitedOnWire`). |
| 61 | `visited[]` | `AntHop` | 12·n | Forward stack: `{ i32 node; f64 time }` per hop. `time` is a **per-hop delta** (seconds) as of [item 02](improvements/02-backward-ant-delay-metric.md); the *byte-removal slim* of the four transient fields above is still pending. |
| …  | `nHistory`  | `u16`    | 2 | Count of `history` entries (rejected if `> kMaxHistoryOnWire`). |
| …  | `history[]` | `AntHop` | 12·n | Back-ant stack being reinforced: `{ i32 node; f64 time }`. |
| …  | `nHello`    | `u16`    | 2 | Count of `helloDests` entries (rejected if `> kMaxHelloOnWire`). Also carries the `LinkFail` payload of `(dest, newBestPheromone)`. |
| …  | `helloDests[]` | `HelloDest` | 12·n | Hello adverts / LinkFail payload: `{ i32 node; f64 pheromone }`. |

Fixed prefix (`version` through `pheromone`) is **59 bytes**; the three empty
arrays add 6 bytes of counts, so the minimum frame is **65 bytes**. Worst-case
size is bounded because `nVisited`/`nHistory`/`nHello` are capped on decode
(`kMaxVisitedOnWire`/`kMaxHistoryOnWire`/`kMaxHelloOnWire`, enforcement added by
[item 12](improvements/12-codec-hardening-and-threat-model.md)).

## Planned wire evolution

`kWireVersion` is a **monotonic counter**, not a fixed value — it was introduced
at `0x01` (item 12) and bumped to `0x02` (item 05); each subsequent
layout/semantic change increments it. Do not hard-code a number; use `current + 1`.

1. ✅ **Version byte (landed, 0x01)** — [item 12](improvements/12-codec-hardening-and-threat-model.md),
   [ADR-0006](adr/0006-on-wire-protocol-version.md). `version : u8` at **offset 0**;
   `deserialize` checks it first and drops unknown values in O(1), then validates
   the `type`/`direction` enums and clamps the element counts to their caps.
2. ✅ **Repair / link-failure (landed, 0x02)** —
   [item 05](improvements/05-link-failure-detection-and-repair.md). Added
   `broadcastBudget : i32` and the `AntType::LinkFail` role (the notification
   reuses the `helloDests` `{node, pheromone}` shape).
3. **Backward-ant slim** (pending) —
   [item 02](improvements/02-backward-ant-delay-metric.md),
   [ADR-0009](adr/0009-backward-ants-carry-path-not-state.md). The per-hop-delta
   `AntHop.time` semantic (Eq.2 metric fix) **has landed** in the core. Still
   pending: **remove** `prevHop`, `hops`, `prevSINR`, `pheromone` from the
   serialized image (they are recomputed locally; verified that neither adapter
   consumes them) — −24 fixed bytes — and **bump `kWireVersion` to `0x03`**.

### Target layout after items 12 + 02

| Offset | Field | Type | Bytes |
|-------:|-------|------|------:|
| 0  | `version`   | `u8`  | 1 |
| 1  | `type`      | `u8`  | 1 |
| 2  | `direction` | `u8`  | 1 |
| 3  | `src`       | `i32` | 4 |
| 7  | `dst`       | `i32` | 4 |
| 11 | `seqNum`    | `u32` | 4 |
| 15 | `timeStart` | `f64` | 8 |
| 23 | `lifeAnt`   | `f64` | 8 |
| 31 | `nVisited`  | `u16` | 2 |
| 33 | `visited[]` | `AntHop` (`{i32 node; f64 delta}`) | 12·n |
| …  | `nHistory` + `history[]` | … | 2 + 12·n |
| …  | `nHello` + `helloDests[]` | … | 2 + 12·n |

Fixed prefix shrinks to **31 bytes**; minimum frame **37 bytes** (was 60). The
backward ant adds nothing beyond the path it inherited.

## Versioning

- **Offset 0 is a `u8` version constant** (`kWireVersion`), once item 12 lands.
- `deserialize` checks it **first** and returns `false` on any unknown value —
  before reading any length field — so foreign, corrupt, or stale-version frames
  are rejected in O(1) at the trust boundary.
- The constant is defined once in the codec and asserted identical by the NS-2
  and NS-3 headers and the round-trip test. **Any change to field order,
  width, units, or semantics bumps `kWireVersion`** (see the maintenance rule in
  [ADR-0006](adr/0006-on-wire-protocol-version.md)).
- We do **not** negotiate or translate between versions. A mismatched version is
  a dropped packet, not a fallback — within a single simulation every node runs
  the same build, and across builds we *want* cross-version traces to fail loudly
  rather than silently misparse. This is the deliberate trade-off recorded in the
  ADR.

This makes the "one canonical wire format" invariant machine-checkable: the
field layout and its version move together, in lockstep, across the codec and
both adapters.

## vs. the original implementation

The original NS-2 module (vendored inside `ns-allinone-2.34`) had **no codec and
no portable wire format at all** — the ant lived as a C++ object whose
`visited`/`history`/hello lists were `AntTimeEntry**` heap arrays referenced
directly from the NS-2 packet header. That carried three defects (see
[ADR-0004](adr/0004-pod-ant-messages-and-codec.md) and
[porting-notes](porting-notes.md)):

| Aspect | Original | This implementation |
|--------|----------|---------------------|
| Path / history / hello storage | Header-resident `AntTimeEntry**` heap pointers | Length-prefixed value arrays in a byte buffer |
| Broadcast semantics | Byte-copying the header duplicated a raw pointer → **double-free** | POD copy is safe; ants are trivially copyable |
| Serialized size | `size()` returned `sizeof(pointer)` → **wrong airtime/MAC modelling** | `serializedSize()` returns the true byte count |
| `seqNum` width | `u_int8_t` → wrapped after 256 ants, aliasing `(src,seq)` dedup | `u32` |
| Path / dedup growth | Unbounded | Capped by `Config::maxPathLength` / `maxHistory` (also enforced on decode) |
| Endianness / portability | Native struct layout (compiler/arch dependent) | Explicit little-endian, compiler/arch independent |
| Version marker | None | None today; 1-byte `version` at offset 0 *planned* (item 12, ADR-0006) |
| Transient compute state on the wire | N/A (live object) | `prevHop`/`hops`/`prevSINR`/`pheromone` today; *being removed* (item 02, ADR-0009) so the wire carries only identity + path |

So there is no "original wire format" to be byte-compatible *with*; this codec is
the first portable format, and the planned version byte exists so the *next*
change is detectable in a way the original never was.

## vs. the protocol specification

AntHocNet is defined by its papers ([1], [2], [3] in
[improvements/README](improvements/README.md)), **not** by any byte-level wire
standard. The papers specify the *contents and semantics* of ants, never an
octet layout, so this format is one faithful encoding of the paper's fields —
plus a few implementation-only fields. There is no newer or competing wire
specification to track.

| Wire field | Status vs. spec | Notes |
|------------|-----------------|-------|
| `type`, `direction` | **Spec concept** | Reactive/proactive forward ants, backward ants, hello messages, repair ants ([1] §3). |
| `src`, `dst` | **Spec concept** | Session endpoints an ant is routing between. |
| `visited`, `history` (node + time) | **Spec concept** | Forward ant records the path and per-hop timing; backward ant retraces it to deposit pheromone ([1] §3.1–3.2). |
| `helloDests` (node + pheromone) | **Spec concept** | Pheromone diffusion: hellos advertise virtual-pheromone goodness for active destinations ([2], diffusion section). The value is real, not constant — see [item 03](improvements/03-pheromone-diffusion.md). |
| `hops` | **Spec-aligned** | Hop count in the path metric. *Computed locally, removed from the wire by item 02 (ADR-0009).* |
| `prevSINR` | **Implementation** | Accumulated time/cost term; misnamed (the spec's metric is delay/quality, not SINR). *Removed from the wire, not renamed, by [item 02](improvements/02-backward-ant-delay-metric.md).* |
| `pheromone` | **Implementation** | Running estimate on the backward ant; the spec computes pheromone per node. *Removed from the wire by item 02 — each node recomputes.* |
| `lifeAnt` | **Implementation** | Repair-ant TTL budget — a concrete realisation of the spec's bounded local repair. |
| `timeStart`, `seqNum` | **Implementation** | Trip-time accounting and `(src,seq)` duplicate suppression. The spec assumes ant identification; these are the mechanisms. |
| `prevHop` | **Implementation** | Retrace bookkeeping. *Computed locally, removed from the wire by item 02.* |
| `version` | **Implementation** | Frame envelope; no spec analogue. *Planned, item 12.* |

Where a field's behaviour deviates from the paper, the deviation is tracked in
`docs/improvements/` (items 02, 03 in particular), not here — this document
describes only the *bytes*.

## Maintenance checklist

When you change `AntMessage` fields, update **in the same field order** and bump
`kWireVersion`:

1. `core/include/anthocnet/core/ant_message.h` (the struct).
2. `core/src/ant_message_codec.cpp` (serialize + deserialize + size constants).
3. `ns2/src/ant_packet_ns2` (NS-2 POD header + `wireSize()`).
4. `ns3/model/anthocnet-packet` (`AntHeader` Serialize/Deserialize/GetSerializedSize).
5. `core/tests/test_codec.cpp` (round-trip + the version-mismatch rejection test).
6. This table and the offsets above.
