# Ant Colony routing: from foraging ants to AntHocNet

> A conceptual primer. This page explains *the idea* behind the protocol — where
> it comes from biologically, how it became a network-routing algorithm
> (**AntNet**), and how it was adapted to mobile ad-hoc networks
> (**AntHocNet**). For *how this repository implements it*, read
> [`architecture.md`](architecture.md); for orientation and the glossary, read
> [`../CONTEXT.md`](../CONTEXT.md).

---

## 1. The biological idea: stigmergy and pheromone trails

Real ants find short paths between their nest and food without any central
coordinator, map, or direct communication. Each ant follows simple local rules,
and the *coordination emerges through the environment*. This indirect
communication — agents changing a shared medium that other agents later sense
and react to — is called **stigmergy**.

The medium ants use is **pheromone**: a chemical they deposit as they walk.
Other ants prefer to follow stronger-smelling trails, so the more a path is
used, the more pheromone it accumulates, and the more attractive it becomes — a
**positive feedback** loop. Pheromone also **evaporates** over time, which
erases stale trails and lets the colony forget paths that are no longer useful.

### The double-bridge experiment

The classic demonstration (Deneubourg, Goss, et al.) offers a colony two bridges
between nest and food, one short and one long:

```
            short branch
        ┌───────────────────┐
  NEST ─┤                   ├─ FOOD
        └───────────────────────────┐
                long branch ─────────┘
```

Ants initially choose randomly. But ants on the **short** branch complete the
round trip faster, so they reinforce their branch with pheromone *sooner and
more often*. The growing pheromone difference biases later ants toward the short
branch, until almost the whole colony converges on it. No ant ever "knew" which
branch was shorter — the **travel time**, turned into pheromone density, decided
it.

The three mechanisms to remember:

| Mechanism | Effect |
|---|---|
| **Deposit / reinforcement** | used paths gain pheromone (positive feedback) |
| **Stochastic choice** | ants mostly follow strong trails but sometimes explore |
| **Evaporation** | unused paths fade (negative feedback / forgetting) |

The balance between *exploiting* known-good trails and *exploring* alternatives
is the heart of the whole family of algorithms.

---

## 2. Ant Colony Optimization (ACO)

Marco Dorigo's PhD work (early 1990s) turned this into a general optimization
**metaheuristic**, **Ant Colony Optimization**. The recipe:

1. Represent the problem as a graph where a solution is a path.
2. Send out many simple artificial "ants" that build candidate solutions by
   moving across the graph, choosing each step **probabilistically**, biased by a
   **pheromone** value (learned desirability) and often a **heuristic** value
   (problem-specific hint).
3. After ants finish, deposit pheromone on the components of good solutions
   (more for better solutions) and let all pheromone evaporate a little.
4. Repeat. Over many iterations the pheromone concentrates on high-quality
   solution components.

The canonical first application was the Travelling Salesman Problem (Ant System,
then Ant Colony System). The probabilistic step rule has the shape that recurs
everywhere in this family — pick next hop `n` for destination `d` with
probability proportional to

```
        pheromone(n, d) ^ β
P(n) = ─────────────────────────
        Σ  pheromone(k, d) ^ β
        k
```

where the exponent **β** controls greediness: small β ≈ near-random
exploration, large β ≈ almost always take the strongest trail. (Keep β in mind —
AntHocNet uses *two different* values of it; see §5.)

---

## 3. AntNet: ACO for routing in wired networks

Gianni Di Caro and Marco Dorigo applied ACO to **network routing** in **AntNet**
(1997–1998). The insight is a natural fit: a routing table is essentially a set
of "which next hop is good for this destination?" preferences — exactly what
pheromone expresses.

In AntNet each node holds a **pheromone table**: for every destination, a
goodness value for each neighbour (possible next hop). Two kinds of ant maintain
it:

- **Forward ants** are launched periodically toward destinations. At each node a
  forward ant picks its next hop stochastically (weighted by pheromone), and it
  **records the nodes it visits and the time taken**. It experiences the same
  queues and delays as real data, so its trip time measures real path quality.
- When a forward ant reaches the destination it becomes a **backward ant**,
  which **retraces the exact path in reverse**. At each node on the way back it
  **updates the pheromone** for the neighbour it came from toward the
  destination, by an amount derived from the measured trip time — good (fast)
  paths get more pheromone.

Data packets are then routed using the pheromone table: typically toward the
strongest next hop, sometimes spread across good alternatives for load balancing.
Because ants keep sampling and pheromone keeps evaporating, AntNet **adapts
continuously** to changing traffic and topology — its selling point versus the
shortest-path protocols of the day.

The **forward-ant-measures / backward-ant-deposits** split is the structural idea
AntHocNet inherits directly.

---

## 4. Why wireless ad-hoc networks are harder

A **MANET** (Mobile Ad-hoc NETwork) is a set of mobile nodes with **no fixed
infrastructure** — no routers, no base stations. Every node is also a router,
and the topology changes constantly as nodes move. Compared to the wired setting
AntNet targeted, this breaks several assumptions:

- **Links appear and disappear** as nodes move in and out of radio range. A
  "good" path can vanish mid-transfer.
- **The medium is shared and broadcast.** A transmission is heard by all
  neighbours; bandwidth is scarce and contended, so **control overhead is
  expensive** — you cannot flood ants as freely as on a wired backbone.
- **No global addressing/topology service** to lean on; routes must be
  discovered and repaired locally.

So a pure proactive scheme (keep a fresh route to *everything* all the time, like
AntNet's periodic ants) wastes bandwidth on routes nobody uses, while a pure
reactive scheme (only ever find a route when data needs it, like AODV/DSR) pays a
discovery delay on every new flow and reacts slowly to change. The good answer is
a **hybrid**.

---

## 5. AntHocNet: ACO routing for MANETs

**AntHocNet** (Gianni Di Caro, Frederick Ducatelle, Luca Maria Gambardella,
~2004–2005) adapts the ant/pheromone machinery to MANETs as a **hybrid**
protocol: **reactive** where it must be, **proactive** where it is cheap, with
**local repair** for the inevitable link failures.

### Reactive route setup (on demand)

A route is only built when there is traffic for it. When a node has a data packet
for a destination it has **no pheromone for**, it queues the packet and broadcasts
a **reactive forward ant**. That ant floods toward the destination, recording its
path. The destination turns it into a **backward ant** that retraces the path,
laying pheromone hop by hop, so by the time it returns the source has a usable
route and the queued data can flow. (This is the AODV-like reactive part —
but the route it installs is a *pheromone gradient*, not a single fixed path.)

### Proactive maintenance and exploration (while a flow is active)

While a route is in use, nodes send **proactive forward ants** along it (and
slightly off it) to keep its pheromone fresh and to discover better or alternate
paths as the network moves. This continuous sampling is what lets AntHocNet
maintain a **mesh of multiple paths** per destination and shift traffic onto
better ones — the ACO adaptivity AntNet had, but spent only where there is
actual traffic.

### Pheromone diffusion (virtual pheromone)

To bootstrap exploration cheaply, nodes piggyback their best pheromone estimates
in periodic **hello** messages. A neighbour combines an advertised estimate with
the local one-hop cost to derive a **virtual pheromone** value for destinations
it has never reached itself. This *diffused* information guides proactive ants
toward promising directions **without** flooding — but, crucially, virtual
pheromone is only ever used to **steer ants**, never to forward data (data only
trusts pheromone laid by ants that actually completed the trip). In this
repository the split is explicit: **regular** vs **virtual** pheromone
(see the [glossary](../CONTEXT.md#9-glossary); diffusion is config-gated,
[ADR-0007](adr/0007-proactive-diffusion-gated.md)).

### Local link-failure repair

When a node detects that a neighbour is gone (a missed-hello timeout, or a failed
unicast reported by the MAC layer), it removes that neighbour's pheromone and, if
the failure broke an in-use route, launches a **repair ant** to find a local
detour — instead of tearing the whole route down and rediscovering from scratch.
(Two independent liveness detectors;
[ADR-0008](adr/0008-neighbour-liveness-two-detectors.md).)

### Stochastic data routing — and two betas

Data is **not** pinned to a single shortest path. Each data packet's next hop is
drawn **stochastically**, weighted by `pheromone ^ β`, so traffic naturally
spreads across the good paths of the mesh and load-balances. AntHocNet uses **two
different greediness values**:

- **`betaAnts`** — a *lower* β for exploring ants, so they keep trying
  alternatives;
- **`betaData`** — a *higher* β for data, so payload concentrates on the
  best-known paths while ants still explore.

(See [ADR-0010](adr/0010-data-forwarding-prevhop-excluded-stochastic.md) for the
data-forwarding rule — the previous hop is excluded for loop safety — and
[improvement 01](improvements/01-data-vs-ant-beta.md) for the two-beta split.)

### A note on evaporation

In the original AntHocNet, pheromone is kept current chiefly by the
backward-ant **running average** (`T ← γ·T + (1−γ)·estimate`) and by removing a
neighbour's entries on link failure — there is **no** classic evaporation term.
This repository adds time-proportional evaporation as a **secondary safety net**
for entries those two mechanisms miss; it is config-gated and on by default
([ADR-0012](adr/0012-evaporation-is-a-secondary-safety-net.md)).

### Putting it together

| Concern | Pure reactive (AODV/DSR) | Pure proactive (AntNet/OLSR) | **AntHocNet (hybrid)** |
|---|---|---|---|
| Route discovery | on demand (delay per flow) | always ready (constant overhead) | **on demand, then kept fresh only while used** |
| Multiple paths | usually one | possibly | **mesh of paths, load-balanced stochastically** |
| Adapting to movement | rediscover on break | periodic refresh | **proactive sampling + local repair** |
| Overhead placement | per discovery | everywhere, always | **concentrated on active destinations** |

---

## 6. How the concepts map to this codebase

The whole conceptual model above lives, simulator-independent, in
[`core/`](../core). The mapping:

| Concept (this page) | In the code |
|---|---|
| Pheromone table (per-destination, per-neighbour goodness) | `PheromoneTable` |
| Deposit / reinforcement, evaporation, the update math | `PheromoneEngine` |
| Forward / backward / hello / repair ant | `AntMessage` (type + direction) |
| Stochastic next-hop choice (`pheromone ^ β`) | `PheromoneTable` selection, driven by `betaAnts` / `betaData` |
| The per-node decision-making (the "rules an ant/node follows") | `AntRouterLogic` (pure: returns `RouteDecision`s) |
| Duplicate-ant suppression during a flood | `AntHistoryTracker` |
| Regular vs **virtual** pheromone (diffusion) | two maps in `PheromoneTable`; gated by `enableDiffusion` |

The pure core returns **`RouteDecision`s** (`Unicast` / `Broadcast` / `Queue` /
`Deliver` / `Drop` / `None`); the thin **NS-2** and **NS-3** adapters translate
real packets into `AntMessage`s and carry those decisions out. See
[`architecture.md`](architecture.md) for the full decision flow.

---

## 7. Further reading

The canonical sources for the algorithm lineage:

- M. Dorigo, V. Maniezzo, A. Colorni — *Ant System: Optimization by a colony of
  cooperating agents* (1996). The origin of ACO.
- M. Dorigo, T. Stützle — *Ant Colony Optimization* (MIT Press, 2004). The
  textbook treatment of the metaheuristic.
- G. Di Caro, M. Dorigo — *AntNet: Distributed Stigmergetic Control for
  Communications Networks*, JAIR (1998). ACO applied to wired routing.
- G. Di Caro, F. Ducatelle, L. M. Gambardella — *AntHocNet: An Adaptive
  Nature-Inspired Algorithm for Routing in Mobile Ad Hoc Networks*, European
  Transactions on Telecommunications (2005). The protocol this repository
  implements.
- F. Ducatelle — *Adaptive Routing in Ad Hoc Wireless Multi-hop Networks* (PhD
  thesis, 2007). The fullest treatment of AntHocNet.

Within this repository:

- [`architecture.md`](architecture.md) — the core/adapter design and decision flow.
- [`../CONTEXT.md`](../CONTEXT.md) — project orientation and the full glossary.
- [`adr/`](adr) — the *why* behind specific design choices referenced above.
- [`wire-format.md`](wire-format.md) — the on-wire ant layout, and where it
  differs from the papers.
