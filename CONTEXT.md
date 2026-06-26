# Project Context — AntHocNet

> Orientation document for contributors and for "grill-with-docs" comprehension
> checks. It captures *what* this project is, *why* it is shaped this way, its
> *current state*, and the *open questions*. For design detail read
> [`docs/architecture.md`](docs/architecture.md); for maintenance detail read
> [`docs/porting-notes.md`](docs/porting-notes.md); for the reasoning behind the
> structure read the [ADRs](docs/adr/).

## 1. One-paragraph summary

AntHocNet is an **Ant Colony Optimization (ACO)** routing protocol for mobile
ad-hoc networks. This repository implements it **once**, as a
**simulator-agnostic algorithm core** (`core/`), and ships **thin adapters**
that install the protocol onto an existing **NS-2** (source patch) or **NS-3**
(additive contrib module) tree. The core has no simulator dependency and is
covered by unit tests; the adapters translate packets and execute the
decisions the core returns.

## 2. Why this project exists / history

- The protocol is a legacy academic implementation (originally by Daniel
  Henrique Joppi, ~2008–2011) written *inside* a vendored `ns-allinone-2.34`
  snapshot for NS-2.34.
- It was reviewed and fixed, then **refactored** into the current shape: the
  algorithm was extracted from NS-2 into a portable, tested `core/`, the
  vendored simulator tree was removed, and NS-2/NS-3 adapters were added. The
  refactor also fixed several latent bugs (see §6).
- The motivation: one maintained algorithm, runnable on two simulators, with no
  forked simulator tree to carry.

## 3. Domain background (enough to follow the code)

- **MANET**: mobile nodes, no fixed infrastructure; links come and go as nodes
  move, so routing must adapt continuously.
- **ACO routing**: "forward ants" explore toward a destination recording their
  path; "backward ants" retrace it depositing **pheromone** — a numeric
  goodness value per `(neighbor, destination)` next-hop choice. Data packets are
  then forwarded **stochastically** in proportion to `pheromone^beta` — data uses
  a greedier `betaData` than ants' `betaAnts`, concentrating traffic on the best
  paths while ants still explore. Unused paths **evaporate**.
- **AntHocNet** is *hybrid*: routes are set up **reactively** on demand (a data
  packet with no route triggers a flooded reactive forward ant; the returning
  backward ant lays the route), **maintained proactively** while in use, and
  **repaired** locally on link failure. It also disseminates **virtual**
  pheromone via hello ants so nodes can route toward destinations they have not
  yet reached themselves.

## 4. Architecture at a glance

A ports-and-adapters (hexagonal) design — full diagram in
[`docs/architecture.md`](docs/architecture.md).

```
            core/  (no simulator headers)
   PheromoneTable · PheromoneEngine · AntHistoryTracker
   AntRouterLogic  ── pure: returns RouteDecisions, performs no I/O
   AntMessage (POD) · VisitedPath · AntMessageCodec (canonical wire format)
   Ports: IClock · IRng · INeighborProvider · ITimerScheduler
                         ▲                      ▲
        implements ports │  returns decisions   │
              ┌──────────┴──────────┐ ┌─────────┴───────────┐
              │        ns2/         │ │        ns3/          │
              │ Agent adapter +     │ │ Ipv4RoutingProtocol  │
              │ source patch        │ │ contrib module       │
              └─────────────────────┘ └──────────────────────┘
```

- **`AntRouterLogic`** is the pure state machine: `onReceiveAnt(msg, prevHop)`
  and `onDataPacket(dst)` return `vector<RouteDecision>`; the adapter executes
  each `RouteDecision { action ∈ {Unicast,Broadcast,Queue,Deliver,Drop,None},
  nextHop, message }`.
- **Adapters** convert headers ⇄ `AntMessage`, carry out decisions, own the
  timers and pending-packet queue (and the NS-2 link-failure callback).

## 5. Repository map

```
README.md                 ← start here: what/why, quick start, what changed
CONTEXT.md                ← this file
AGENTS.md                 ← build/verify/conventions for AI agents
Makefile                  ← make test | install-ns2 | install-ns3 | clean
docs/
  architecture.md         ← design + decision flow
  porting-notes.md        ← bugs fixed, NS-2 patch anchors, wire format, caveats
  wire-format.md          ← canonical ant byte layout, version byte, diffs vs original/spec
  adr/*.md                ← architecture decision records
core/
  include/anthocnet/core/ ← public headers (types, ports, config, messages, logic)
  src/                    ← implementation (.cpp)
  tests/                  ← ctest unit tests (codec, pheromone, history, logic)
  CMakeLists.txt
ns2/
  src/                    ← Agent adapter (ahn_router, ant_packet_ns2, ahn_adapters)
  patch/                  ← idempotent anchor-based installer + fragments + selftest
  tcl/                    ← example scenarios
ns3/
  model/ helper/ examples/ test/   ← native NS-3 module
.github/workflows/ci.yml  ← core tests + NS-2 patch round-trip (+ optional NS-3 build)
```

## 6. Bugs fixed during the extraction (see `docs/porting-notes.md`)

These were latent in the original NS-2 module and are fixed in `core/`:

1. **Header-resident heap pointers** → the packet stored `malloc`'d
   `AntTimeEntry**`; NS-2 byte-copies headers, so broadcasting an ant
   double-freed and leaked, and `size()` reported `sizeof(pointer)`. Replaced
   by `AntMessage` value types + a length-prefixed codec.
2. **Evaporation aged the wrong link** (competing links never decayed).
3. **8-bit sequence number** wrapped after 256 ants, aliasing dedup.
4. **Unbounded dedup history** → now FIFO-capped (`Config::maxHistory`).
5. **`randomDestination` never randomised** (integer-division bug) → uniform.

## 7. Current state

- **`core/` builds and all unit tests pass** (`make test`, 5/5 — verified).
- **NS-2 patch apply/revert round-trips** on a synthetic tree
  (`bash ns2/patch/selftest.sh`, in CI).
- **NS-3 module** builds against ns-3.36+; CI builds it only on manual dispatch
  (heavy). No end-to-end NS-2/NS-3 simulation is run from this repo — that needs
  an external simulator tree.

## 8. What is missing / caveats

- **Cross-simulator metric parity is not guaranteed.** NS-2 and NS-3 have
  different MAC/PHY models; treat a cross-sim comparison as behaviour
  re-validation, not a bit-for-bit port.
- **No full simulation runs in CI** — only the core tests and the NS-2 patch
  round-trip. Behavioural validation on real NS-2/NS-3 trees is manual.
- **Old NS-2 toolchains** may default to < C++14 and need `-std=c++14` added to
  `CCOPT` (documented in `docs/porting-notes.md`).
- The NS-2 patch depends on **stable text anchors** in upstream files; a future
  NS-2 release that moves an anchor makes the installer fail loudly (by design)
  and the fragment must be updated.

## 9. Glossary

| Term | Meaning |
|------|---------|
| Core | the simulator-agnostic algorithm library in `core/`. |
| Adapter | the thin NS-2 or NS-3 layer that wires the core to a simulator. |
| Port | an interface the core depends on, implemented by adapters (`IClock`, `IRng`, `INeighborProvider`, `ITimerScheduler`). |
| `AntMessage` | the POD value type describing an ant (replaces header-resident pointers). |
| `RouteDecision` | the verb the core returns for the adapter to execute. |
| `AntRouterLogic` | the pure per-node state machine. |
| Regular pheromone | next-hop goodness for a destination learned from real ant traversals (backward ants). Used by data. |
| Virtual pheromone | next-hop goodness gossiped via hello ants for destinations not reached directly. Used only to guide proactive ants, never data. Config-gated (`enableDiffusion`, ADR-0007). _Avoid_: "diffused pheromone" (the papers' synonym). |
| Pheromone diffusion | the mechanism: spreading virtual pheromone hop-by-hop through hello ants. The *process*, not the value. Gated with proactive exploration (ADR-0007). |
| Bootstrapping | the method of deriving a virtual-pheromone value from a neighbour's advertised estimate plus the local one-hop cost (vs. Monte-Carlo sampling by ants). |
| Reinforcement | the spec's adaptation engine: a running weighted average on backward-ant arrival, `T ← gamma·T + (1−gamma)·estimate`. The `(1−gamma)` term is the "forgetting". |
| Evaporation | time-proportional decay (`alpha^(Δt/evaporationInterval)`) applied on the maintenance tick. A **secondary safety net** for entries the running average + link-failure removal miss — the original AntHocNet has *no* evaporation term. Config-gated (`enableEvaporation`, default on; ADR-0012). |
| Forward / backward / hello / repair ant | path collector / pheromone depositor / neighbour-discovery + gossip / link-failure local search. |
| Neighbour liveness | a neighbour is "gone" via either missed hellos (core timer, primary) or a failed unicast (MAC signal, fast-path); both call `loseNeighbor`. `INeighborProvider` is advisory, never authoritative for removal (ADR-0008). |
| Stochastic data routing | data is forwarded by a per-packet pheromone-weighted draw, **excluding the prev hop** (loop safety; only-option fallback). Per-flow stickiness (a bounded `(src,dst)→hop` cache) is config-gated, default off (ADR-0010). |
| `NodeAddress` | core address type (`int32_t`), = a node's primary interface IP, treated opaquely; `kInvalidAddress` = -1 = "no route / no specific next hop". Broadcast is a `RouteAction`, **never** a `NodeAddress` (ADR-0011). |

## 10. Open questions for future work

- What scenario + metrics (delivery ratio, delay, overhead vs. AODV) define
  "working", and on which simulator are they the reference?
- Should there be an automated end-to-end smoke test against a pinned NS-3
  checkout in CI (beyond the current build job)?
- Are the `Config` defaults (`alpha`/`betaAnts`/`betaData`/`gamma`, intervals, `maxPathLength`,
  `maxHistory`) the right operating point, or should they be tuned per
  simulator?
