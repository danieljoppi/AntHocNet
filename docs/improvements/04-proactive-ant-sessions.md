# 04 — Proactive ants for active sessions + per-hop broadcast probability

- **Deviation:** D4
- **Priority:** P1
- **Effort:** M
- **Layer:** `core/` (logic + new "active session" state) and adapters (feed data
  events; rate tied to data)
- **Depends on:** 03 (diffusion guides the exploratory broadcasts)
- **Decision:** the whole proactive subsystem is **config-gated** behind
  `Config::enableProactive` (default on), per
  [ADR-0007](../adr/0007-proactive-diffusion-gated.md). `enableProactive` is the
  master switch; item 03's `enableDiffusion` is the sub-switch for the virtual
  pheromone that guides these ants.

## Summary

Proactive forward ants exist to **monitor and improve the paths a node is
actively using**, and to occasionally explore for better ones. The spec sends
them from the **source of each active session**, **to that session's
destination**, at a rate tied to the data rate, with a **small per-hop
probability of being broadcast** for exploration. The current code instead picks
a **random known destination** on a **fixed timer**, with no per-hop broadcast
probability. This wastes overhead on destinations nobody is using and fails to
maintain the paths that matter.

## Spec reference

> "While a data session is running, the source node sends out proactive forward
> ants according to the data sending rate (**one ant every n data packets**).
> They are normally **unicast**, choosing the next hop according to the pheromone
> values using the same formula as the reactive forward ants, but also **have a
> small probability at each node of being broadcast (this probability was set to
> 0.1 in the experiments)**. ... If a forward ant reaches the destination without
> a single broadcast it simply samples an existing path. ... If on the other hand
> the ant got broadcast at any point, it will leave the currently known paths and
> explore new ones." — [1] §3.3

Two requirements:
1. **Target = active-session destinations**, from the **source** of those
   sessions, at a data-proportional rate.
2. **Per-hop broadcast probability** `p_broadcast` (≈0.1): at each intermediate
   node a proactive ant is normally unicast along pheromone, but with prob.
   `p_broadcast` it is broadcast to explore.

## Current behaviour

Random destination, fixed timer, no per-hop broadcast:

```379:393:ns3/model/anthocnet-routing-protocol.cc
void RoutingProtocol::ProactiveTimerExpire() {
    if (m_logic) {
        NodeAddress dest = m_logic->randomDestination();
        if (dest != kInvalidAddress) {
            AntMessage prfa = m_logic->createForwardAnt(AntType::Proactive, dest);
            NodeAddress next = m_logic->selectNextHop(dest, /*proactive=*/true);
            if (next == kInvalidAddress) {
                SendAnt(prfa, Ipv4Address("255.255.255.255"));
            } else {
                SendAnt(prfa, ToIpv4(next));
            }
        }
    }
    m_proactiveTimer.Schedule(m_proactiveInterval);
}
```

(NS-2 `sendProactive` in `ns2/src/ahn_router.cc:314` is identical in spirit.)

And in the core, an in-transit proactive forward ant is only broadcast when it
has **no** route at all — there is no exploratory broadcast when a route exists:

```151:155:core/src/ant_router_logic.cpp
        NodeAddress next = selectNextHop(ant.dst, proactive);
        if (next == kInvalidAddress) {
            return {{RouteAction::Broadcast, kInvalidAddress, true, ant}};
        }
        return {{RouteAction::Unicast, next, true, ant}};
```

## Impact

- Proactive overhead is spent on destinations with no traffic; active paths get
  no proactive sampling unless they happen to be drawn at random.
- Without per-hop broadcast, proactive ants can only *re-sample known paths*,
  never *discover new* ones — removing the "improve / explore" half of the
  mechanism. Combined with D3, AntHocNet loses nearly all of its proactive
  adaptivity.

## Required change

### 1. Track active sessions in the core

Add to `AntRouterLogic` a small set of "active destinations" with a last-used
timestamp, updated whenever this node **originates** data for a destination:

```cpp
// AntRouterLogic
void noteDataSession(NodeAddress dest);            // call when local data is sent to dest
std::vector<NodeAddress> activeDestinations(double now, double ttl) const;  // recently used
```

Expire a session if no data has been sent to it for some window (e.g.
`config_.sessionTtl`, default a few seconds). Drive `now` from `clock_`.

Adapters call `noteDataSession(dest)` from their data path:
- NS-3: in `RouteOutput` when the packet is locally originated (and in
  `DeferredRouteOutput`).
- NS-2: in `handleData` when `ih->saddr() == id_` (locally originated).

### 2. Emit proactive ants per active session

Replace `randomDestination()` selection with a sweep over
`activeDestinations(...)`. Provide a core entry point so both adapters share it:

```cpp
// returns one proactive forward ant per active destination
// (empty if none, or if !config_.enableProactive — the master gate, ADR-0007)
std::vector<AntMessage> AntRouterLogic::createProactiveAnts();
```

Gate at the source: when `!config_.enableProactive`, `createProactiveAnts()`
returns empty and the per-hop exploratory broadcast in step 3 is skipped, so the
protocol degrades cleanly to reactive-only (the AntHocNet-reactive benchmark
variant in [item 08](08-protocol-comparison-benchmarks.md)). Adapters may also
short-circuit their proactive timer on the same flag to save the tick.

Rate: keep a periodic timer **but** gate it so a proactive ant is only emitted
for a destination if data has flowed recently (the active-session set already
does this). Optionally, to match "one ant every n data packets", have the adapter
count data packets per destination and request a proactive ant every `n`
(default `n` configurable, e.g. 30). The session-set approach is the minimum;
the per-n-packets trigger is the faithful version — implement the session-set
gating first, leave a TODO for the exact data-proportional trigger if needed.

### 3. Per-hop broadcast probability for proactive ants

In `onReceiveAnt`, for an in-transit **proactive** forward ant that *does* have a
route, broadcast with probability `p_broadcast` instead of always unicasting:

```cpp
NodeAddress next = selectNextHop(ant.dst, proactive);
if (next == kInvalidAddress) {
    return {{RouteAction::Broadcast, kInvalidAddress, true, ant}};
}
if (proactive && rng_.uniform() < config_.proactiveBroadcastProb) {
    return {{RouteAction::Broadcast, kInvalidAddress, true, ant}};  // explore
}
return {{RouteAction::Unicast, next, true, ant}};
```

Add `double proactiveBroadcastProb = 0.1;` to `Config`. To bound exploration cost
(the spec limits proliferation), also cap the number of broadcasts a single
proactive ant may undergo — reuse the bounded-broadcast counter introduced in
item 05 (`AntMessage::broadcastBudget`), defaulting e.g. to 2 for proactive ants.
*(Done — issue #45: `Config::proactiveMaxBroadcasts = 2` initialises the budget
in `createForwardAnt`; a budget-exhausted proactive ant is dropped on a route
gap, and with a route it keeps following pheromone instead of exploring.)*

### 4. Source-originated proactive ants follow combined pheromone

`createForwardAnt(AntType::Proactive, dest)` then `selectNextHop(dest, true)`
already uses `sumMaxProbability` (regular ⊕ virtual) — keep that so the diffused
pheromone from item 03 guides the first hop.

## Files to touch

- `core/include/anthocnet/core/config.h` (`enableProactive`, `proactiveBroadcastProb`, `sessionTtl`)
- `core/include/anthocnet/core/ant_router_logic.{h}` + `.cpp`
  (`noteDataSession`, `activeDestinations`, `createProactiveAnts`, per-hop
  broadcast in `onReceiveAnt`)
- `core/include/anthocnet/core/ant_message.h` (`broadcastBudget` — shared with 05)
- `ns3/model/anthocnet-routing-protocol.cc` (`ProactiveTimerExpire`, data paths
  call `noteDataSession`)
- `ns2/src/ahn_router.cc` (`sendProactive`, `handleData` calls `noteDataSession`)
- Expose `ProactiveBroadcastProb` attribute (NS-3) / `proactive_bcast_prob_` bind
  (NS-2).

## Acceptance criteria

Add `core/tests/test_proactive.cpp`:

1. **Only active destinations are probed.** After `noteDataSession(d1)` but not
   `d2` (both in the table), `createProactiveAnts()` yields exactly one ant, for
   `d1`.
2. **Session expiry.** After advancing `FakeClock` past `sessionTtl` with no new
   data, `createProactiveAnts()` returns empty.
3. **Per-hop exploratory broadcast.** With a route present and a `ScriptedRng`
   returning `< proactiveBroadcastProb`, an in-transit proactive forward ant
   yields a `Broadcast`; with `>= prob` it yields a `Unicast`.
4. **Reactive ants unaffected.** The same scenario with `AntType::Reactive` never
   broadcasts when a route exists.
5. **Broadcast budget enforced.** A proactive ant broadcast more than
   `broadcastBudget` times stops being re-broadcast (verify with item 05's
   counter).
6. **Gate off ⇒ reactive-only.** With `enableProactive = false`,
   `createProactiveAnts()` returns empty and an in-transit proactive ant with a
   route never broadcasts; data routing is unaffected.
7. `make test` green.

## Risks / notes

- `createProactiveAnts` originating multiple ants per tick can raise overhead;
  the active-session gating is what keeps it bounded — make sure expiry works.
- Coordinate the `broadcastBudget` field with item 05 so it's added to the wire
  format exactly once (struct + codec + both adapter headers + `test_codec.cpp`).
