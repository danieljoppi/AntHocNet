# 15 — Observability: trace sources, counters, and routing-table dumps

- **Covers:** F1
- **Priority:** P2 (enables item 08's NRL/overhead metric and debugging)
- **Effort:** S–M
- **Layer:** `core/` (counters/callbacks via a port) + adapters (expose as traces)
- **Depends on:** feeds 08 (overhead/NRL); pairs with 13 (smoke assertions)

## Summary

There is almost no built-in observability: the only introspection is NS-3's
`PrintRoutingTable`. To compute routing overhead/NRL (item 08), to assert
behaviour in smoke tests (item 13), and to debug, the protocol needs counters and
trace hooks for ant traffic, pheromone changes, and route events — exposed the
idiomatic way in each simulator (ns-3 `TracedCallback`/`TracedValue`, ns-2 trace
lines).

## Current state

```416:431:ns3/model/anthocnet-routing-protocol.cc
void RoutingProtocol::PrintRoutingTable(Ptr<OutputStreamWrapper> stream, Time::Unit) const {
    ...
    for (NodeAddress dest : table.regularDestinations()) {
        *os << "  dest " << ToIpv4(dest) << " neighbours:";
        ...
```

That's the extent of it — no ant counters, no pheromone-change trace, no route
add/remove events, and the NS-2 `log-target`/`tracetarget` plumbing exists but is
unused.

## Required change

### 1. Core: counters + an observer port (simulator-agnostic)

Keep the core pure: add lightweight counters and an **optional** observer
interface so the core reports events without doing I/O.

```cpp
// ports.h
struct IRouterObserver {
    virtual ~IRouterObserver() = default;
    virtual void onAntSent(AntType type, AntDirection dir, bool broadcast) {}
    virtual void onAntReceived(AntType type, AntDirection dir) {}
    virtual void onPheromoneChanged(NodeAddress dest, NodeAddress nb, double v) {}
    virtual void onRouteChanged(NodeAddress dest, NodeAddress nb, bool added) {}
};
```

`AntRouterLogic` takes an optional `IRouterObserver*` (default null → zero cost)
and fires events at the natural points (`onReceiveAnt`, `updateRegular`,
neighbour add/remove). Also keep plain integer counters
(`antsSent[type]`, `antsReceived[type]`, `controlBytes`) queryable for tests.

### 2. NS-3: expose as `TracedCallback`/`TracedValue`

Implement an observer that forwards to ns-3 trace sources registered in
`GetTypeId` (`Tx`/`Rx` ant traces, `PheromoneChanged`, `RouteChanged`). This lets
`anthocnet-compare` (item 08) count control packets/bytes directly from the
protocol rather than only via the L3 Tx trace, and lets users `Config::Connect`
to them.

### 3. NS-2: emit trace lines

Wire the already-present `logtarget_`/`tracetarget` to emit ant send/recv and
route-change trace lines in the standard ns-2 trace format, so the awk-based PDR/
overhead post-processors (items 07/08, `docs/cross-validation.md`) can read them.

### 4. Routing-table dump parity

Add an NS-2 equivalent of `PrintRoutingTable` (dump pheromone table on a tcl
command) so both simulators can snapshot state.

## Files to touch

- `core/include/anthocnet/core/ports.h` (`IRouterObserver`)
- `core/include/.../ant_router_logic.{h}` + `.cpp` (optional observer, counters,
  event points)
- `ns3/model/anthocnet-routing-protocol.{h,cc}` (trace sources + observer impl)
- `ns2/src/ahn_router.{h,cc}` (trace-line emission, table dump command)
- `core/tests/` (assert counters increment on the expected events)

## Acceptance criteria

1. Core exposes ant/route counters; a unit test asserts e.g. one reactive ant
   broadcast increments `antsSent[Reactive]` and fires `onAntSent`.
2. NS-3 registers `Tx`/`Rx`/`PheromoneChanged`/`RouteChanged` trace sources that a
   test/example can `Config::Connect` to.
3. `anthocnet-compare` (item 08) can derive control-packet/byte counts from the
   protocol's own counters, cross-checked against the L3 Tx trace.
4. NS-2 emits ant/route trace lines consumable by the benchmark post-processor.
5. Observer is optional and zero-overhead when unset; `make test` green.

## Risks / notes

- Keep the observer **optional and allocation-free on the hot path** (null check;
  no per-packet heap). The core must stay pure — the observer only *reports*, it
  never makes routing decisions or does I/O.
- Don't let trace emission change behaviour or timing (especially under the
  deterministic test harness).
