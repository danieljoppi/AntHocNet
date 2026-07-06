# ADR-0011: `NodeAddress` is the node's IP; broadcast is a RouteAction, never an address

- **Status:** Accepted — implementation tracked in
  item 11 (B2, B3)
- **Date:** 2026-06-25

## Context

The NS-3 adapter converts addresses by casting a full IPv4 address to the core's
`int32` `NodeAddress`:

```cpp
static NodeAddress ToCore(Ipv4Address a) { return static_cast<NodeAddress>(a.Get()); }
```

`255.255.255.255` (`0xFFFFFFFF`) becomes `int32 -1`, which is exactly
`kInvalidAddress` ("no route"); any address ≥ `128.0.0.0` becomes negative. It is
masked today only because the examples use `10.1.0.0/16`. Underneath the bug is an
**unstated contract**: is a `NodeAddress` the simulator's IP or an abstract node
id? And on a **multi-interface** node (B2), which address *is* the node? B2 and B3
are the same question from two angles.

## Decision

- **`NodeAddress` is the node's primary AntHocNet-interface IPv4 address.** A
  routing protocol fundamentally speaks IP — the core returns a next-hop
  `NodeAddress` that the adapter turns directly into a gateway IP + output device —
  so the core address space *is* the IP space. The core treats it **opaquely**
  and only ever compares `== kInvalidAddress`.
- **Broadcast/multicast are a verb, never a noun.** They are expressed *only* as
  `RouteAction::Broadcast` (with `kInvalidAddress` = "no specific next hop"). The
  all-ones address is **never** fed through `ToCore` as an identity. With that
  guard the only IP that maps to `-1` is the broadcast address — which never
  reaches `ToCore` — so no unicast peer can alias the sentinel. MSB-set unicast
  IPs still map to *negative* ints, which is fine because `NodeAddress` is opaque
  and never ordered against the sentinel.
- **Identity ≠ interface.** A node's identity is its *primary* AntHocNet
  interface IP; "one AntHocNet interface per node" is the supported/tested
  topology. B2's multi-interface work is purely **egress selection** (route via
  the interface facing `next`, not `m_socketAddresses.begin()`) and does **not**
  change identity.
- Add `ToCore(unicast) != kInvalidAddress` as an assertion + a round-trip test
  (`ToIpv4(ToCore(x)) == x` over the supported unicast range).

## Alternatives considered

- **`NodeAddress` = abstract node id (e.g. `Node::GetId()`).** Structurally kills
  the sentinel collision and decouples identity from interface, so B2 would fall
  out for free. Rejected: it forces an adapter-maintained id↔IP directory on both
  NS-2 and NS-3 (to resolve a next-hop id back to a gateway IP + device) that
  AntHocNet does not otherwise need and would have to populate and keep fresh. The
  IP-as-identity contract plus the two invariants above fix the bug without that
  machinery.

## Consequences

- The literal B3 collision is fixed structurally (broadcast never an address;
  unicast never aliases `-1`) rather than by widening or re-sentinelling the type.
- B2 reduces to correct egress-interface selection; node identity is unaffected,
  so multi-interface support can be incremental.
- The "one AntHocNet interface per node" assumption is now an explicit, documented
  contract rather than an accident of the example addressing plan.
- No wire-format impact (addressing is an adapter ⇄ core boundary concern, not a
  serialized field).
