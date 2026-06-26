# AntHocNet — protocol-fidelity improvement specs

> **Audience: an implementing agent (human or AI).** Each file in this folder is
> a self-contained, implementable work item. They describe where the current
> code deviates from the canonical AntHocNet specification, why it matters, and
> exactly what to change, with acceptance criteria. Read this index first, then
> implement the items in the order given (or pick one — each is independent
> unless a dependency is noted).

## How to use these docs

1. Read this README for shared context (spec, code map, conventions, invariants).
2. Open one numbered spec file. Each has the same sections:
   - **Summary** — one paragraph.
   - **Spec reference** — the exact AntHocNet behaviour + citation.
   - **Current behaviour** — what the code does today, with `file:line` anchors.
   - **Impact** — why the deviation matters.
   - **Required change** — precise, step-by-step edits (with proposed code).
   - **Files to touch.**
   - **Acceptance criteria** — tests/observable behaviour that must hold.
   - **Risks / notes.**
3. Keep the architecture invariant intact (see below): algorithm changes go in
   `core/`; adapters only translate and execute.
4. After each item: `make test` must stay green, and add the test(s) named in
   that item's acceptance criteria.

## Architecture invariant (do not break)

```
core/   simulator-agnostic algorithm. No NS-2/NS-3 headers. Pure: returns
        RouteDecisions, performs no I/O. Time & randomness come via ports
        (IClock, IRng). THIS is where protocol logic lives.
ns2/    thin Agent adapter + source patch. Translates header <-> AntMessage,
        executes RouteDecisions, owns timers + link-failure callback.
ns3/    native Ipv4RoutingProtocol module. Same responsibilities as ns2.
```

Rule of thumb: **if a change affects routing decisions, it belongs in `core/`
and must be covered by a `core/tests/` unit test.** Adapters get changed only to
feed the core new inputs (e.g. a periodic "tick", an active-session set) or to
carry out a new `RouteAction`.

## Canonical specification (the source of truth)

All "Spec reference" sections cite these. Equation numbers refer to the journal
version [1].

- **[1]** G. Di Caro, F. Ducatelle, L. M. Gambardella. *AntHocNet: an adaptive
  nature-inspired algorithm for routing in mobile ad hoc networks.* European
  Transactions on Telecommunications, 16(5):443–455, 2005. (IDSIA-27-04)
- **[2]** F. Ducatelle. *Adaptive Routing in Ad Hoc Wireless Multi-hop
  Networks.* PhD thesis, 2007 (the most detailed description of diffusion +
  link-failure handling).
- **[3]** Di Caro, Ducatelle, Gambardella. *AntHocNet: an ant-based hybrid
  routing algorithm for MANETs.* PPSN VIII, LNCS 3242, 2004. (IDSIA-25-04)

### The three core equations

For node `i`, destination `d`, neighbour `n`, pheromone `T_nd^i`:

- **Eq.1 — stochastic next-hop probability**
  `P_nd = (T_nd^i)^β / Σ_{j∈N_d^i} (T_nd^j)^β`, with `β ≥ 1`.
  Two exponents are used: **β1** for ants, **β2 ≥ β1** (larger, greedier) for
  data. See `01-data-vs-ant-beta.md`.
- **Eq.2 — pheromone a backward ant deposits at node i**
  `τ_d^i = ( (T̂_d^i + h·T_hop) / 2 )^{-1}`, where `T̂_d^i` is the estimated
  time to reach `d` from `i` along the path, `h` is the hop count from `i` to
  `d`, and `T_hop` is a fixed per-hop time in unloaded conditions. See
  `02-backward-ant-delay-metric.md`.
- **Eq.3 — pheromone update (bootstrapped average)**
  `T_nd^i = γ·T_nd^i + (1−γ)·τ_d^i`, `γ ∈ [0,1]`. Paper uses `γ = α = 0.7`.

## Code map (where things live today)

| Concern | File |
|---|---|
| Tunables (`alpha`/`beta`/`gamma`/intervals/...) | `core/include/anthocnet/core/config.h` |
| Pheromone math (evaporate/reinforce/update) | `core/src/pheromone_engine.cpp` |
| Stochastic next-hop selection (Eq.1) | `core/src/pheromone_table.cpp` |
| Ant state machine, ant construction, back-ant advance | `core/src/ant_router_logic.cpp` |
| Ant value type + fields | `core/include/anthocnet/core/ant_message.h` |
| Wire codec (keep adapters in sync if fields change) | `core/src/ant_message_codec.cpp` |
| Wire byte layout + version byte (ADR-0006) | `docs/wire-format.md` |
| NS-3 timers / link I/O / sockets | `ns3/model/anthocnet-routing-protocol.cc` |
| NS-2 timers / link-failure callback / queue | `ns2/src/ahn_router.cc` |
| Unit tests | `core/tests/*.cpp` |

## Work items (priority order)

| # | Item | Deviation | Priority | Est. effort | Status |
|---|------|-----------|----------|-------------|--------|
| [01](01-data-vs-ant-beta.md) | Wire `beta`; use β2 > β1 for data vs ants | D1 | **P0** | S | ✅ done |
| [02](02-backward-ant-delay-metric.md) | Fix back-ant delay metric (units + per-hop) | D2 | **P0** | M | ✅ metric + wire-slim (v0x03) |
| [03](03-pheromone-diffusion.md) | Real diffused/bootstrapped pheromone in hellos | D3 | **P1** | M | ✅ done (core; adapter flags with #04) |
| [04](04-proactive-ant-sessions.md) | Proactive ants for active sessions + broadcast prob | D4 | **P1** | M | 🟡 core+adapters; broadcast-budget cap with #05 |
| [05](05-link-failure-detection-and-repair.md) | Hello-timeout detection, failure notification, repair bounding | D5/D6 | **P1** | L | ✅ detection+notify+repair; NS-3 MAC hook TODO |
| [06](06-evaporation-and-minor.md) | Time-based evaporation + minor deviations | D7 | **P2** | S | 🟡 6.1 evap + 6.3 backoff done; 6.2/6.4/6.5 minor |
| [07](07-validation-and-benchmarks.md) | Validation harness + paper-faithful benchmark scenario | — | **P2** | M |
| [08](08-protocol-comparison-benchmarks.md) | Benchmark vs AODV/OLSR/DSDV/DSR (+ overhead/NRL, fairness) | — | **P2** | M |
| [09](09-landscape-and-positioning.md) | Public-implementation landscape + project presentation fixes | — | **P2** | S |
| [10](10-data-loops-multipath-and-mac-metric.md) | Data-loop suppression, multipath safety, reactive broadcast cap, MAC metric | A1/A2/A3 | **P1**/P2 | M | 🟡 A1 prevhop + A3 cap done; A2 MAC + stickiness deferred |
| [11](11-adapter-robustness.md) | NS-2 unbounded queue, NS-3 multi-iface, address-mapping bug | B1/B2/B3 | **P1**/P2 | M | 🟡 B1+B3 done (P1); B2 multi-iface deferred |
| [12](12-codec-hardening-and-threat-model.md) | Enforce protocol bounds on untrusted decode + threat model | C1 | **P1** | S | ✅ done |
| [13](13-ci-e2e-and-fuzzing.md) | CI end-to-end sim smoke + codec fuzzing + property tests | D1/D2 | P2 | M |
| [14](14-reproducibility-and-release.md) | Docker repro + CITATION/releases/DOI + ns-3 version matrix | E1/E2/E3 | P2 | M | 🟡 E1 Docker images (ns2 2.34/2.35 + ns3 3.41/3.42) + GHCR workflow; E2/E3 pending |
| [15](15-observability-and-traces.md) | Trace sources / counters (feeds item 08 NRL) | F1 | P2 | S–M |
| [16](16-pluggable-link-metric.md) | Pluggable `ILinkMetric` port (fuzzy/energy/QoS extensibility) | G1 | P3 | M | ✅ port + ClassicMetric (core); adapter selection is an extension point |

Recommended sequence: **01 → 02** first (biggest correctness/performance levers
and they unlock meaningful benchmarking), then **03 → 04 → 05**, then **06**,
with **07 + 08** run continuously to measure progress. 07 defines the benchmark
**scenarios**; 08 defines the **protocol set + metrics + fairness** for the
cross-protocol comparison. **09** is independent (presentation/positioning, not
code) and high value-for-effort.

Items **10–16** are a second wave found during deeper review. Highest-value among
them: the **verified near-bugs** — `11` (NS-2 unbounded pending queue; NS-3
`ToCore(255.255.255.255) == kInvalidAddress`) and `12` (codec doesn't enforce
`maxPathLength`/`maxHistory` on untrusted input) — plus `10`/A1 (data-loop
suppression). `13`–`15` harden testing/repro/observability; `16` is a
forward-looking extensibility seam (do after 01/02). Grouping: **10** fidelity ·
**11** adapter correctness · **12** security · **13** testing · **14** packaging ·
**15** observability · **16** extensibility.

## Definition of done (per item)

- Change lives in the correct layer (core vs adapter) per the invariant.
- `make test` is green; new unit test(s) from the item's acceptance criteria are
  added under `core/tests/` and registered in `core/tests/CMakeLists.txt`.
- Both adapters still compile (NS-2 patch self-test `bash ns2/patch/selftest.sh`;
  NS-3 builds) — and if a wire field changed, both the NS-2 header
  (`ns2/src/ant_packet_ns2.*`) and NS-3 header (`ns3/model/anthocnet-packet.cc`)
  and `core/src/ant_message_codec.cpp` are updated together and the codec
  round-trip test (`core/tests/test_codec.cpp`) still passes.
- New tunables are exposed as NS-2 TCL binds and NS-3 `TypeId` attributes.
- `docs/porting-notes.md` / `CONTEXT.md` updated if behaviour or wire format
  changed.

## Conventions for the implementer

- C++14. Match existing style (2-space indent, `lowerCamelCase` members with
  trailing `_`, `namespace anthocnet::core`).
- Do not add narrating comments; comment only non-obvious intent.
- Prefer extending `Config` over new magic constants.
- Any new `AntMessage` field must be added to **all three** of: the struct,
  the codec, and both adapter headers — and to `test_codec.cpp`.
- Keep `RouteDecision` as the only output channel from the core.
