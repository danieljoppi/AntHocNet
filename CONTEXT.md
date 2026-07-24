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

> For the full conceptual lineage — ant foraging/stigmergy → ACO → AntNet →
> AntHocNet, with the canonical references — see
> [`docs/ant-colony-routing.md`](docs/ant-colony-routing.md). The summary below
> is the minimum needed to read the code.

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

- **`core/` builds and all unit tests pass** (`make test`), including
  randomized property/invariant tests (`test_properties`).
- **NS-2 patch apply/revert round-trips** on a synthetic tree
  (`bash ns2/patch/selftest.sh`, in CI), and the **NS-2 adapter is compiled
  against real ns-2.34 / ns-2.35 trees in CI** (the `ns2-compile` job, run
  inside the published plain ns-2 image), which then **runs a small static
  AntHocNet simulation and asserts non-zero CBR delivery** over a forced 2-hop
  route (`ns2/tcl/ci-smoke.tcl`).
- **NS-3 module** builds and tests across **ns-3.36 / 3.41 / 3.42 / 3.47 / 3.48**
  on every push/PR (the `ns3-build` matrix runs inside the prebuilt plain ns-3
  images), running the module test suite and an **asserted end-to-end delivery
  smoke** — AntHocNet must deliver a non-zero PDR in a small connected scenario.
- The **codec decode path is fuzzed** (libFuzzer, 60 s, `codec-fuzz` job).
- Container images for every supported simulator version are published to GHCR
  on merge to the default branch (`.github/workflows/images.yml`).
- **Observability**: the core exposes ant/route counters + an optional
  `IRouterObserver`; the NS-3 module surfaces `Tx`/`Rx`/`RouteChanged` trace
  sources, read by `anthocnet-compare --diag` (item 15).
- **Benchmarks run on every merge**: a classified scenario taxonomy across all
  baselines (AODV/OLSR/DSDV) with the table + a chart auto-committed to
  `docs/benchmarks*`; the paper's area/pause/scale sweeps + charts are the
  manual `scenario-matrix` workflow (items 07/08).
- **Versioned, citable, releasable**: SemVer tags, `VERSION` + `CITATION.cff` +
  `CHANGELOG.md`, a Commitizen-driven `Release` workflow that builds an
  install-bundle zip (Zenodo-ready); Conventional-Commit PR titles are
  CI-enforced (item 14).
- **Agent tooling is script-first** (ADR-0014): the `.claude/skills/` scripts
  do benchmark parsing/A/B noise calls (`bench_parse.py`), campaign-CSV
  summaries (`sweep_summary.py`), scenario pre-flight + result-plausibility
  validation (`scenario_check.py`, #134), and diff invariant checks — raw
  tables and logs stay out of LLM context; only script verdicts are read.
- **Open work is tracked in GitHub issues** — per-area epics #26–#31 and the
  open defects (#20–#23, #51), prioritized via `priority:P1..P3` labels
  (see §10).

## 8. What is missing / caveats

- **Cross-simulator metric parity is not guaranteed.** NS-2 and NS-3 have
  different MAC/PHY models; treat a cross-sim comparison as behaviour
  re-validation, not a bit-for-bit port.
- **The e2e smokes are loose "delivers something" gates**, not performance
  gates — both the NS-2 and NS-3 smoke just assert non-zero delivery in a small
  connected scenario. Performance comparison (multi-seed PDR/delay/overhead) is
  manual, in items 07/08.
- The NS-2 patch depends on **stable text anchors** in upstream files; a future
  NS-2 release that moves an anchor makes the installer fail loudly (by design)
  and the fragment must be updated.
- **Delay-tail (#21) is partly a channel-model artefact.** On the contention-
  dominated ns-3 disk model AntHocNet's delay/jitter tail runs above AODV; on
  two-ray (the paper's PHY) the gap roughly halves, and with the ns-3
  `ReconvHoldCap` (issue #21 lever L2, default **1 s**: deep-tail
  reconvergence holds drop at the cap instead of the 3 s `QueueTimeout`)
  mean delay reaches parity with AODV on two-ray for near-noise PDR cost
  (#103). The residual disk-model gap is the CONTEXT-§8 channel penalty plus
  the still-unverified `T_hop` (#88), not an algorithmic deviation. NS-3 only;
  the NS-2 adapter has no equivalent cap yet.

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
| Multipath reactive setup | a later reactive forward ant of an already-seen `(src,seq)` generation is still forwarded when both its hops and travel time are within `antAcceptanceFactor` (1.5) of the generation's best, laying down several good paths ([1] §3.1). Requires its **linkfail churn bound**: losing a best hop that leaves a usable alternate is absorbed, not flooded — without it multipath *regressed* PDR on the ns-3 disk-model harness. Config-gated (`enableMultipath`, default on; #96). |
| `NodeAddress` | core address type (`int32_t`), = a node's primary interface IP, treated opaquely; `kInvalidAddress` = -1 = "no route / no specific next hop". Broadcast is a `RouteAction`, **never** a `NodeAddress` (ADR-0011). |

## 10. Open questions for future work

> **Start here:** live work is tracked in GitHub issues, grouped into per-area
> epics — #26 fidelity · #27 adapter · #28 benchmark · #29 observability · #30
> packaging · #31 positioning — plus the open defects (#20–#23, #51, all
> `priority:P1`) and the OMNeT++/INET adapter proposal #32. Each ticket has
> evidence, a fix sketch, and acceptance criteria; `priority:P1..P3` labels
> order the backlog (ADR-0013).

- **Highest-leverage next item — #51 (stock single-hop 802.11 unicast loses
  ~50% of UDP in the ns-3 baselines harness).** It invalidates absolute PDR
  numbers for *every* protocol and blocks promoting the validation anchors to
  blocking CI gates (#59). The former top item — #19, the NS-3 MAC repair
  hook — shipped as detector D (#44/#54, closed 2026-06-28; see
  `docs/handoffs/2026-06-28-detector-d-link-failure.md`). The remaining
  protocol regressions vs AODV are #20 (link-failure broadcast storm), #21
  (99th-percentile delay tail), #22 (high-mobility underperformance), #23
  (slow convergence) — all `priority:P1`.
- **What defines "working"** is now partly answered: the scenario taxonomy +
  paper sweeps (`docs/benchmarks.md`, `ns3/tools/run-scenarios.py`) define the
  metrics. Caveat: absolute PDR is low across *all* protocols (#24, closed —
  root cause isolated to the #51 single-hop loss) — relative comparisons are
  valid, absolute numbers aren't yet paper-like.
- Are the `Config` defaults (`alpha`/`betaAnts`/`betaData`/`gamma`, intervals, `maxPathLength`,
  `maxHistory`) the right operating point, or should they be tuned per
  simulator? (See #23 convergence, #26 fidelity.)
