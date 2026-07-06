# Ant Colony routing: from foraging ants to AntHocNet

> A conceptual primer. This page explains *the idea* behind the protocol — where
> it comes from biologically, how it became a network-routing algorithm
> (**AntNet**), and how it was adapted to mobile ad-hoc networks
> (**AntHocNet**). The protocol details and formulas below are taken from the
> original paper: G. Di Caro, F. Ducatelle, L. M. Gambardella, *"AntHocNet: an
> Ant-Based Hybrid Routing Algorithm for Mobile Ad Hoc Networks"*, PPSN VIII,
> LNCS 3242, pp. 461–470, 2004 (Best Paper Award; IDSIA tech. report
> IDSIA-25-04). For *how this repository implements it*, read
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

The first ant-based routing algorithms were **ABC** (Schoonderwoerd et al.,
1996) and **AntNet** (Gianni Di Caro & Marco Dorigo, 1998) — both cited by the
AntHocNet paper as its direct ancestors. ACO is a natural fit for routing: a
routing table is essentially a set of "which next hop is good for this
destination?" preferences — exactly what pheromone expresses.

In AntNet each node holds a **pheromone table**: for every destination, a
goodness value for each neighbour (possible next hop). Two kinds of ant maintain
it:

- **Forward ants** are launched at regular intervals toward (randomly chosen)
  destinations. At each node a forward ant picks its next hop stochastically
  (weighted by pheromone), and it **records the nodes it visits and the time
  taken**. It experiences the same queues and delays as real data, so its trip
  time measures real path quality.
- When a forward ant reaches the destination it becomes a **backward ant**,
  which **retraces the exact path in reverse**. At each node on the way back it
  **updates the pheromone** for the neighbour it came from toward the
  destination, by an amount derived from the measured trip time — good (fast)
  paths get more pheromone.

Data packets are then routed using the pheromone table, **stochastically**:
links with more pheromone are chosen with higher probability, which spreads
traffic across good alternatives and load-balances. Because ants keep sampling
and pheromone keeps evaporating, AntNet **adapts continuously** to changing
traffic and topology — its selling point versus the shortest-path protocols of
the day.

The **forward-ant-measures / backward-ant-deposits** split is the structural idea
AntHocNet inherits directly. The catch the AntHocNet authors call out: ant-based
routing "crucially relies on repeated path sampling," which "can cause
significant overhead if not dealt with carefully" — earlier MANET ant protocols
(ARA, PERA) lost the proactive sampling trying to cut that overhead. AntHocNet's
whole design is about keeping the sampling **but spending it only where there is
traffic**.

---

## 4. Why wireless ad-hoc networks are harder

A **MANET** (Mobile Ad-hoc NETwork) is a set of mobile nodes with **no fixed
infrastructure** — no routers, no base stations. Every node is also a router,
and the topology changes constantly as nodes move. Compared to the wired setting
AntNet targeted, this breaks several assumptions:

- **Links appear and disappear** as nodes move in and out of radio range. A
  path that was efficient "can quickly become inefficient or even infeasible,"
  so routing information must be refreshed far more often than on a wired
  network.
- **The medium is shared and broadcast.** A node "can only send or receive data
  if no other node is sending in their neighborhood"; bandwidth is scarce and
  contended, and the MAC layer (802.11 DCF) adds its own overhead — so **control
  traffic is expensive** and you cannot flood ants freely.
- **No global addressing/topology service** to lean on; routes must be
  discovered and repaired locally.

So a pure proactive scheme (keep a fresh route to *everything* all the time, like
DSDV) wastes bandwidth tracking topology nobody is using, while a pure reactive
scheme (only find a route when data needs it, like AODV/DSR) pays a discovery
delay on every new flow and "can suffer from oscillations in performance since
they are never prepared for disruptive events." The good answer is a **hybrid**
(like ZRP) — and, ideally, **multipath**, since most MANET protocols use a single
path and lose both robustness and the chance to spread load.

---

## 5. AntHocNet: ACO routing for MANETs

**AntHocNet** (Di Caro, Ducatelle & Gambardella, 2004) is a **hybrid, multipath**
protocol: **reactive** route setup, **proactive** maintenance/exploration while a
flow runs, and **local repair** for link failures. Each node `i` keeps a routing
table `T^i` whose entry `T^i_{nd}` is the **pheromone** — an estimate of the
goodness of going to destination `d` via next hop `n`. Because each
`(destination)` can have several `(next hop)` entries, the tables together
describe a **mesh of paths**, and data is spread over them.

### Reactive route setup (on demand)

A route is built only when there is traffic for it. When source `s` has data for
a destination it has **no pheromone for**, it queues the packet and broadcasts a
**reactive forward ant**. Each forward ant is **unicast** when the current node
has pheromone for `d`, and **broadcast** otherwise, so it proliferates along
plausible directions while recording the list `P = [1, …, n]` of nodes it
visits. To curb the flood, when a node sees several ants of the **same
generation** (same original ant from `s`), it only forwards one whose **hop count
and travel time are both within a factor 1.5** of the best ant of that generation
seen so far — bad paths are pruned, multiple *good* paths survive. At the
destination the forward ant becomes a **backward ant** that retraces `P`, laying
pheromone hop by hop, so by the time it returns `s` has usable routes and the
queued data flows. (This is the AODV-like reactive part — but it installs a
*pheromone gradient over multiple paths*, not one fixed route.)

### How a path's quality becomes pheromone (the metric)

This is the heart of the algorithm — turning a path into a number:

- Each node `i` keeps a **MAC-layer time estimate** `T̂^i_mac`, a running average
  of the time from a packet arriving at the MAC layer to the end of its
  successful transmission (so it includes channel-access contention — local
  congestion): `T̂^i_mac = α·T̂^i_mac + (1−α)·t^i_mac`.
- The estimated time to cross one hop is `T̂_{i→i+1} = (Q^i_mac + 1)·T̂^i_mac`,
  where `Q^i_mac` is the number of packets queued at the MAC layer. The backward
  ant sums these along the path: `T̂_P = Σ T̂_{i→i+1}`.
- The pheromone deposited for a path with end-to-end time estimate `T̂_{s→d}` and
  `h` hops is the **inverse of the average of time and hop-cost**:

  ```
  τ_id = ( (T̂_{s→d} + h·T_hop) / 2 ) ^ -1
  ```

  where `T_hop` is a fixed "time of one hop under no load." Averaging time with
  `h·T_hop` damps oscillations from traffic bursts and folds in both delay and
  hop count, so higher pheromone = faster *and* shorter.
- If an entry already exists, it is updated as a **weighted running average**
  (this is the "reinforcement"):

  ```
  T^i_nd = γ·T^i_nd + (1−γ)·τ_id
  ```

In the paper both `α` and `γ` were set to **0.7**. Note there is **no separate
evaporation term** — pheromone is kept current by this running average and by
link-failure cleanup (see the evaporation note below).

### Stochastic data routing — and the two betas

Data is **not** pinned to a single shortest path. At each node with several next
hops for `d`, the next hop is drawn with probability proportional to the
**square** of its pheromone:

```
        (T_{nd}) ^ 2
P_nd = ─────────────────       (β = 2 for data)
        Σ (T_{id}) ^ 2
        i
```

"We take the square in order to be more greedy with respect to the better
paths." Crucially, **proactive ants use the *unsquared* values** (β = 1) "so that
they sample the paths more evenly." That is the origin of this codebase's
**two-beta** design:

- **`betaAnts`** (≈1) — lower greediness, so exploring ants keep trying
  alternatives;
- **`betaData`** (≈2) — higher greediness, so payload concentrates on the
  best-known paths while ants still explore.

Spreading data this way gives **automatic load balancing**: a congested path's
delay rises, its pheromone falls, and traffic shifts off it. (See
[ADR-0010](adr/0010-data-forwarding-prevhop-excluded-stochastic.md)
for the data rule — the previous hop is excluded for loop safety — and
improvement 01
for the two-beta split.)

### Proactive maintenance and exploration (while a flow is active)

Once a session runs, `s` sends **proactive forward ants** at a rate tied to the
data rate (one ant every *n*th data packet). They follow pheromone like data
(but unsquared), so they re-sample the paths in use and refresh their pheromone
in both directions. Each ant also has a **small probability of being broadcast**
at any node, letting it step *off* the known trails to discover better or
alternate paths. To stop a broadcast ant from flooding the whole network, the
**number of broadcasts is capped at two**: if a proactive ant finds no routing
information within two hops it is deleted. The effect is that exploration stays
**concentrated around the current paths** — looking for improvements and
variations, not rediscovering the world. This continuous sampling is what keeps
the multipath mesh fresh as the network moves.

### Pheromone diffusion (virtual pheromone)

Nodes broadcast periodic **hello messages** (every `t_hello`, e.g. 1 s) so each
node learns its immediate neighbours and gets pheromone information about them.
In the 2004 paper this already lets an ant arriving at a *neighbour of the
destination* "go straight to its goal," which the authors frame as a basic form
of **pheromone diffusion** — "pheromone deposited on the ground diffuses, and can
be detected also by ants further away" — and they explicitly flag **extending**
this diffusion to better guide proactive ants as **future work**.

This repository implements that *extended* idea: a node combines a neighbour's
advertised estimate with the local one-hop cost to derive a **virtual pheromone**
value for destinations it has never reached itself, used **only to steer
exploring ants — never to forward data** (data trusts only **regular** pheromone
laid by ants that completed the trip). The split is explicit in the code; see the
[glossary](../CONTEXT.md#9-glossary). Because it is an extension beyond the 2004
paper, diffusion is **config-gated**
([ADR-0007](adr/0007-proactive-diffusion-gated.md)).

### Local link-failure repair

Nodes detect a lost link when a **unicast transmission fails** or **expected
hellos stop arriving** (after missing 2 hellos a neighbour is dropped). The
response is proportional to the damage:

- If other next hops to the destination remain, or the destination wasn't carrying
  data, the node just updates its table and **notifies neighbours** — the
  notification lists the affected destinations and the node's new best
  delay/hop estimates, and propagates further if a neighbour also lost its best
  or only path.
- If the destination *was* in active use and this was the **only** path — and the
  loss was discovered by a **failed data packet** — the node broadcasts a **route
  repair ant** toward that destination (like a reactive ant, but capped at **2
  broadcasts**). It waits ~**5× the estimated end-to-end time** of the lost path;
  if no backward repair ant returns, it gives up and removes the destination.

This local repair avoids tearing down and rediscovering a whole route on every
break. In this codebase the liveness side uses **two independent detectors**
(missed-hello timeout + MAC unicast failure);
[ADR-0008](adr/0008-neighbour-liveness-two-detectors.md).

### A note on evaporation

The original AntHocNet has **no classic evaporation term**: pheromone is kept
current by the backward-ant running average (`T ← γ·T + (1−γ)·τ`) and by removing
a neighbour's entries on link failure. This repository **adds** time-proportional
evaporation as a **secondary safety net** for entries those two mechanisms miss;
it is config-gated and on by default
([ADR-0012](adr/0012-evaporation-is-a-secondary-safety-net.md)).

### Canonical parameters (2004 paper)

| Symbol | Meaning | Paper value |
|---|---|---|
| `α` | MAC time-estimate smoothing | 0.7 |
| `γ` | pheromone reinforcement weight | 0.7 |
| β (data) | data-routing greediness (square of pheromone) | 2 |
| β (ants) | ant-routing greediness (pheromone unsquared) | 1 |
| acceptance factor | same-generation ant filter (hops & time) | 1.5 |
| max broadcasts | proactive & repair ant broadcast cap | 2 |
| `t_hello` | hello interval | ~1 s |
| missed hellos | before dropping a neighbour | 2 |
| repair wait | multiple of est. end-to-end of lost path | 5× |

### Putting it together

| Concern | Pure reactive (AODV/DSR) | Pure proactive (AntNet/DSDV) | **AntHocNet (hybrid)** |
|---|---|---|---|
| Route discovery | on demand (delay per flow) | always ready (constant overhead) | **on demand, then kept fresh only while used** |
| Multiple paths | usually one | possibly | **mesh of paths, load-balanced stochastically** |
| Adapting to movement | rediscover on break | periodic refresh | **proactive sampling + local repair** |
| Overhead placement | per discovery | everywhere, always | **concentrated on active destinations** |

In the paper's QualNet experiments (50 nodes, random-waypoint mobility, 20 CBR
sources, 802.11 DCF), AntHocNet beat AODV on **packet delivery ratio in every
scenario**, and on **average delay in the harder ones** (longer/sparser areas,
higher mobility, larger scale) — its multipath mesh avoids the rare
very-high-delay packets that hurt single-path AODV's jitter.

---

## 6. How the concepts map to this codebase

The whole conceptual model above lives, simulator-independent, in
[`core/`](../core). The mapping:

| Concept (this page) | In the code |
|---|---|
| Pheromone table (per-destination, per-neighbour goodness) | `PheromoneTable` |
| Deposit / reinforcement (`T ← γ·T + (1−γ)·τ`), evaporation | `PheromoneEngine` |
| Forward / backward / hello / repair ant | `AntMessage` (type + direction) |
| Stochastic next-hop choice (`pheromone ^ β`), squared vs not | `PheromoneTable` selection, driven by `betaData` / `betaAnts` |
| The per-node decision-making (the "rules a node follows") | `AntRouterLogic` (pure: returns `RouteDecision`s) |
| Same-generation duplicate-ant suppression during a flood | `AntHistoryTracker` |
| Regular vs **virtual** pheromone (diffusion) | two maps in `PheromoneTable`; gated by `enableDiffusion` |

The pure core returns **`RouteDecision`s** (`Unicast` / `Broadcast` / `Queue` /
`Deliver` / `Drop` / `None`); the thin **NS-2** and **NS-3** adapters translate
real packets into `AntMessage`s and carry those decisions out. See
[`architecture.md`](architecture.md) for the full decision flow.

> **A note on fidelity.** This repository follows the canonical AntHocNet
> design but is not a bit-for-bit reproduction of the 2004 paper: some
> mechanisms beyond it (extended pheromone diffusion, a secondary evaporation
> term, the explicit two-beta split) are implemented as **config-gated** options
> with their rationale recorded in the [ADRs](adr). Where the on-wire format
> differs from the paper, see [`wire-format.md`](wire-format.md).

---

## 7. Further reading

The canonical sources for the algorithm lineage:

- M. Dorigo, V. Maniezzo, A. Colorni — *Ant System: Optimization by a colony of
  cooperating agents*, IEEE Trans. SMC-B (1996). The origin of ACO.
- M. Dorigo, G. Di Caro, L. M. Gambardella — *Ant Algorithms for Discrete
  Optimization*, Artificial Life 5(2):137–172 (1999). The ACO framework.
- R. Schoonderwoerd, O. Holland, J. Bruten, L. Rothkrantz — *Ant-Based Load
  Balancing in Telecommunications Networks*, Adaptive Behavior (1996). ABC, the
  first ant-routing algorithm.
- G. Di Caro, M. Dorigo — *AntNet: Distributed Stigmergic Control for
  Communications Networks*, JAIR 9:317–365 (1998). ACO applied to wired routing.
- **G. Di Caro, F. Ducatelle, L. M. Gambardella — *AntHocNet: an Ant-Based
  Hybrid Routing Algorithm for Mobile Ad Hoc Networks*, PPSN VIII, LNCS 3242,
  pp. 461–470 (2004; Best Paper Award).** The paper this primer is based on.
- F. Ducatelle, G. Di Caro, L. M. Gambardella — *An Adaptive Nature-Inspired
  Algorithm for Routing in Mobile Ad Hoc Networks*, European Transactions on
  Telecommunications 16(5):443–455 (2005). The extended journal treatment.
- F. Ducatelle — *Adaptive Routing in Ad Hoc Wireless Multi-hop Networks* (PhD
  thesis, IDSIA, 2007). The fullest treatment of AntHocNet, including extended
  pheromone diffusion.

Within this repository:

- [`architecture.md`](architecture.md) — the core/adapter design and decision flow.
- [`../CONTEXT.md`](../CONTEXT.md) — project orientation and the full glossary.
- [`adr/`](adr) — the *why* behind specific design choices referenced above.
- [`wire-format.md`](wire-format.md) — the on-wire ant layout, and where it
  differs from the papers.
