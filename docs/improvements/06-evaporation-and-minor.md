# 06 — Time-based evaporation + minor deviations

- **Deviation:** D7 (+ small clean-ups)
- **Priority:** P2
- **Effort:** S
- **Layer:** `core/` (+ adapter tick wiring)
- **Depends on:** ideally after 05 (shares the maintenance tick)

## Summary

A grab-bag of lower-impact fidelity items. The main one: **evaporation is
event-driven, not time-based.** It only runs as a side effect of reinforcing a
link (on backward-ant arrival or neighbour learning), so a quiet path neither
decays nor ages on schedule. Classic ACO (and AntHocNet's pheromone aging) treats
evaporation as a periodic, time-proportional process. The remaining items are
small correctness/clarity fixes.

## Items

### 6.1 — Time-based (periodic) evaporation

**Spec/ACO basis:** pheromone evaporation is a function of elapsed time, applied
regularly, so unused entries decay independently of whether new ants arrive.

**Current:** `evaporate` only runs inside `updateRegular`'s loop, which is only
called from `reinforceFromBackAnt` and `learnNeighbor`:

```9:11:core/src/pheromone_engine.cpp
double PheromoneEngine::evaporate(double phValue) const {
    return phValue - (1.0 - config_.alpha) * phValue;
}
```

So a destination that stops receiving backward ants is never aged; its competing
links freeze at their last values.

**Change:** add `PheromoneEngine::evaporateAll(PheromoneTable&)` that ages **every**
regular (and optionally virtual) entry once, pruning entries below
`minPheromone`, and call it from the core maintenance tick (`onMaintenanceTick`,
item 05) at a configurable `Config::evaporationInterval` (e.g. 1–3 s). If the
decay should be time-proportional, scale by elapsed time:
`factor = alpha^(Δt / evaporationInterval)`. Keep the per-reinforcement aging too,
or remove it from `updateRegular` and rely solely on the periodic pass — pick one
and document it (mixing both double-counts decay). **Recommended:** make
`updateRegular` *only reinforce the travelled link*, and move all aging into the
periodic `evaporateAll`. That cleanly separates reinforcement from evaporation
(and removes the awkward "age other links while reinforcing one" coupling that
caused the original D2 evaporation bug).

**Acceptance:** `test_pheromone_engine.cpp` — after N periodic evaporations with
no reinforcement, an entry decays geometrically and is pruned below
`minPheromone`; a reinforced entry does not decay within the same tick.

### 6.2 — `networkDiameter` / expanding-ring TTL

**Spec:** reactive forward ants are bounded by a max hop count; the paper notes
this max is "quite high" and suggests an expanding-ring search or using diffusion
to bound it.

**Current:** `Config::networkDiameter = 30`, applied as an IP TTL in NS-2
(`AHN_NETWORK_DIAMETER`) and as the `maxPathLength` guard in `stampForward`. NS-3
does not appear to apply an equivalent hop cap to broadcast ants.

**Change (small):** ensure **both** adapters cap ant hop count (NS-3 should set
the ant packet TTL / decrement and drop). Optionally implement a simple
expanding-ring retry for reactive setup (start TTL small, grow on failure) —
mark as optional/stretch.

**Acceptance:** an ant exceeding the hop cap is dropped in a core/unit test
(`maxPathLength` already bounds `visited`; add a TTL/hops check in `onReceiveAnt`
that returns `Drop` past the cap), and NS-3 broadcast ants don't propagate beyond
the cap in a smoke run.

### 6.3 — Reactive-ant retry interval

**Spec:** §4.2 of [1] notes the retry interval for reactive forward ants on a
failed setup is "rather low," causing overhead when a destination is unreachable;
suggests backing off.

**Current:** the data path re-launches a reactive ant whenever a packet has no
route (`onDataPacket`), with no per-destination backoff — a stream of packets to
an unreachable destination floods ants.

**Change:** add a per-destination "reactive ant in flight / last sent" guard in
the core (or adapter) so at most one reactive setup is outstanding per
destination, with exponential backoff on repeated failure. Drop buffered packets
after a max number of failed setups.

**Acceptance:** `test_core_paths.cpp` — multiple `onDataPacket(d)` calls in quick
succession with no route emit **one** reactive ant (not one per packet) until the
backoff elapses.

### 6.4 — Naming / clarity (no behaviour change)

- Rename `AntMessage::prevSINR` → `pathTime` (it is accumulated time, not SINR).
  (Folds into item 02.)
- The `kBeta` constant is removed by item 01; ensure no stragglers remain.
- `selectNextHop`'s `proactive` bool would read better as an enum
  `Exponent{Ant, Data}` once item 01 lands, but keep changes minimal.

### 6.5 — Hello advertises a random subset via `rng_.uniform() > 0.5`

**Current:** `createHelloAnt` includes each destination with prob 0.5 (capped at
`maxAdverts`). Combined with item 03 (advertise active destinations only), prefer
advertising **active** destinations deterministically and filling remaining slots
by best pheromone, rather than a coin flip. Minor.

## Files to touch

- `core/src/pheromone_engine.cpp`, `core/include/.../pheromone_engine.h`
  (`evaporateAll`)
- `core/include/anthocnet/core/config.h` (`evaporationInterval`,
  reactive backoff knobs)
- `core/src/ant_router_logic.cpp` (tick calls evaporate; reactive backoff guard;
  hop cap drop)
- `ns3/model/anthocnet-routing-protocol.cc` (ant TTL/hop cap)
- tests as named per item

## Acceptance criteria (summary)

- Periodic evaporation decays unused entries; no double decay.
- One reactive ant per destination per backoff window.
- Ant hop cap enforced in both adapters.
- `make test` green.

## Risks / notes

- 6.1 changes pheromone dynamics; re-tune `alpha`/`evaporationInterval` against
  item 07's benchmark. Land it **after** 01/02 so you measure on a correct metric.
- Keep each sub-item a separate commit; they're independent.
