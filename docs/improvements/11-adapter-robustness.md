# 11 — Adapter robustness (NS-2 queue bound, NS-3 multi-interface, address mapping)

- **Covers:** B1 (NS-2 unbounded queue), B2 (NS-3 single-interface assumptions +
  ant hop cap), B3 (address mapping)
- **Priority:** B1 **P1** (verified near-bug), B2 **P2**, B3 **P1** (verified
  latent bug)
- **Effort:** M
- **Layer:** adapters (`ns2/`, `ns3/`)
- **Depends on:** nothing

## B1 — NS-2 pending queue is unbounded and never times out *(verified)*

### Problem

The NS-3 adapter bounds its pending queue and expires stale entries
(`RequestQueue(64, Seconds(30))`), but the NS-2 adapter uses a plain map of lists
with **no cap and no timeout**. A destination that never becomes reachable
accumulates packets forever → memory growth, held `Packet*` (leak risk on
shutdown), and eventual delivery of very stale packets.

### Current behaviour

```108:108:ns2/src/ahn_router.h
    std::map<nsaddr_t, std::list<Packet*> > queue_;
```

```267:269:ns2/src/ahn_router.cc
void AntHocNetAgent::enqueue(Packet* p, nsaddr_t dest) {
    queue_[dest].push_back(p);
}
```

Compare NS-3:

```30:34:ns3/model/anthocnet-routing-protocol.cc
RoutingProtocol::RoutingProtocol()
    : m_started(false),
      m_queue(64, Seconds(30)),
```

```11:18:ns3/model/anthocnet-rqueue.cc
bool RequestQueue::Enqueue(QueueEntry& entry) {
    ...
    if (m_queue.size() >= m_maxLen) {
        ...
        m_queue.erase(m_queue.begin());   // drop oldest
    }
    m_queue.push_back(entry);
```

### Required change

Give the NS-2 queue the same discipline as NS-3:
- a per-agent total cap (e.g. `config`-driven, default 64) — drop oldest
  (`drop(p, DROP_RTR_QFULL)`) when exceeded;
- a per-packet enqueue timestamp and a periodic purge that `drop`s entries older
  than a timeout (default 30 s) with `DROP_RTR_QTIMEOUT`;
- free dropped packets via NS-2 `drop()`/`Packet::free` so traces are correct.
Drive the purge from the maintenance tick (item 05) or a dedicated timer.

### Acceptance

- NS-2 self-test / a unit-style check: enqueuing > cap drops the oldest; an entry
  past the timeout is dropped on purge; no packet is leaked (counts balance).

## B2 — NS-3 single-interface assumptions + missing ant hop cap

- **Decision (ADR-0011):** node identity is the node's *primary* AntHocNet
  interface IP; B2 is **egress selection only** and does not change identity.

### Problem

The NS-3 adapter routinely uses `m_socketAddresses.begin()` as *the* interface
for output device / source selection, which is incorrect on multi-interface
nodes; and (per item 06.2) it applies no hop/TTL cap to broadcast ants.

### Current behaviour

```211:219:ns3/model/anthocnet-routing-protocol.cc
        Ptr<Ipv4Route> route = Create<Ipv4Route>();
        route->SetDestination(dst);
        route->SetGateway(ToIpv4(next));
        Ipv4InterfaceAddress ifaceAddr = m_socketAddresses.begin()->second;
        route->SetSource(m_ipv4->SourceAddressSelection(
            m_ipv4->GetInterfaceForAddress(ifaceAddr.GetLocal()), dst));
        route->SetOutputDevice(m_ipv4->GetNetDevice(
            m_ipv4->GetInterfaceForAddress(ifaceAddr.GetLocal())));
```

The same `begin()` pattern recurs in `RouteInput` (line ~257) and `FlushQueue`.

### Required change

- Select the **correct egress interface** for `next` (the interface whose subnet
  contains the next hop / via `GetInterfaceForDevice`), not `begin()`.
- Add an ant **hop/TTL cap**: set the ant packet's IP TTL to
  `config_.networkDiameter` on send and drop on expiry (NS-2 already does; NS-3
  should too), plus the core-level hop cap from item 06.2.
- Document the supported topology (single wifi interface per node is the tested
  path); make multi-interface at least correct, even if not optimised.

### Acceptance

- A two-interface node routes via the interface facing the next hop (test or
  documented smoke run); broadcast ants do not propagate beyond the hop cap.

## B3 — Address mapping collides broadcast with "no route" *(verified latent bug)*

- **Decision (ADR-0011):** `NodeAddress` *is* the IP (treated opaquely);
  **broadcast is a `RouteAction`, never an address**, so the all-ones address is
  never passed through `ToCore`. We do **not** switch to an abstract node id.

### Problem

`ToCore` casts the full 32-bit IPv4 address to `int32`. `255.255.255.255`
(`0xFFFFFFFF`) becomes `int32 -1`, which is exactly `kInvalidAddress` ("no
route"). Any address with the MSB set (≥ `128.0.0.0`) becomes negative, which is
fragile against the `kInvalidAddress` sentinel and signed comparisons.

### Current behaviour

```61:66:ns3/model/anthocnet-routing-protocol.h
    static ::anthocnet::core::NodeAddress ToCore(Ipv4Address a) {
        return static_cast<::anthocnet::core::NodeAddress>(a.Get());
    }
    static Ipv4Address ToIpv4(::anthocnet::core::NodeAddress a) {
        return Ipv4Address(static_cast<uint32_t>(a));
    }
```

Today it's masked because the examples use `10.1.0.0/16` (small values), but it's
a latent trap.

### Required change

Per [ADR-0011](../adr/0011-nodeaddress-is-ip-broadcast-is-an-action.md), keep
`NodeAddress` = the IP (opaque to the core) and fix the contract, **not** the
type:

- **Never feed the all-ones (or directed-broadcast/multicast) address through
  `ToCore` as an identity.** Broadcast is `RouteAction::Broadcast`; the adapter
  maps that decision to its broadcast send, and `ToCore` is only ever called on
  real unicast peer addresses. With that guard the *only* IP that maps to `-1`
  (the broadcast address) never reaches `ToCore`, so no unicast peer can alias the
  sentinel.
- **Leave MSB-set unicast IPs mapping to negative ints** — that's fine, the core
  treats `NodeAddress` opaquely and only compares `== kInvalidAddress`. Do **not**
  switch to an abstract node id (ADR-0011 rejects the id↔IP directory it forces).
- **Assert** `ToCore(unicast) != kInvalidAddress` at the boundary, and keep
  `ToIpv4(ToCore(x)) == x` over the supported unicast range.
- A node's identity is its **primary AntHocNet interface IP**; document
  "one AntHocNet interface per node" as the supported topology (B2 handles egress
  for multi-interface, without changing identity).

### Acceptance

- `ToCore(255.255.255.255) != kInvalidAddress`; addresses ≥ `128.0.0.0` round-trip
  through `ToCore`/`ToIpv4` without aliasing the sentinel (unit test in the NS-3
  test suite).

## Files to touch

- `ns2/src/ahn_router.{h,cc}` (bounded/timed queue, purge)
- `ns3/model/anthocnet-routing-protocol.{h,cc}` (egress interface selection, ant
  TTL, address mapping guard)
- `ns3/test/anthocnet-test-suite.cc` (B3 round-trip test)

## Risks / notes

- B3's id scheme change touches every `ToCore`/`ToIpv4` call — do it in one pass
  and keep `ToIpv4(ToCore(x)) == x` for the supported address range.
- B1's drop semantics should use NS-2 `drop()` so wireless traces stay accurate
  for the benchmark PDR computation in `docs/cross-validation.md`.
