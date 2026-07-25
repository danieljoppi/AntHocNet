# Paper fidelity — AntHocNet v1.0

How this implementation maps to the canonical paper, what is reproduced, and
where it deviates — honestly. The reference is **[1]** = Di Caro, Ducatelle &
Gambardella, *AntHocNet: an Ant-Based Hybrid Routing Algorithm for Mobile Ad Hoc
Networks*, PPSN VIII, LNCS 3242, 2004 (digest:
[`publications/papers/2004-ppsn-anthocnet.md`](publications/papers/2004-ppsn-anthocnet.md)).
The living compliance ledger is [issue #91](https://github.com/danieljoppi/AntHocNet/issues/91).

> **What v1.0 claims.** A faithful, simulator-agnostic implementation of the
> AntHocNet algorithm with NS-2 and NS-3 adapters, whose **mechanisms and
> parameters match [1]** and whose **delivery-ratio and overhead advantages over
> AODV reproduce** the paper. It does **not** claim bit-for-bit reproduction of
> the paper's Qualnet numbers, nor that every headline metric is reproduced on
> every ns-3 channel model — see *Known deviations* below.

## Mechanisms (feature ↔ paper § ↔ evidence)

| Mechanism | [1] § | Implementation | Status |
|---|---|---|---|
| Reactive path setup (forward/backward ants) | 3.1 | `core/ant_router_logic` | ✅ core-tested |
| **Multipath** setup (1.5× hops+time acceptance filter) | 3.1 | `GenerationTracker`, `enableMultipath` (#96/#97) | ✅ default on |
| MAC-queue-aware per-hop cost `(Q+1)·T̂_mac` (A2) | 3.1 | `enableMacMetric` (#67/#70) | ✅ formula matches; default off (gated) |
| Pheromone deposit `τ=((T̂+h·T_hop)/2)⁻¹`, running avg γ | 3.1 | `pheromone_engine` | ✅ |
| Stochastic data routing, pheromone² | 3.2 | `betaData=2` (#70/#100) | ✅ aligned |
| Proactive ants, unsquared pheromone, broadcast≤2 | 3.3 | `betaAnts=1`, `proactiveMaxBroadcasts=2` (#45/#70) | ✅ |
| Pheromone diffusion via hello ants | 3.3 | `enableDiffusion` (ADR-0007) | ✅ |
| Hello beacons (1 s, 2 missed → remove) | 3.3 fn.1 | `helloInterval`, `allowedHelloLoss` | ✅ |
| Link-failure detection + notification | 3.4 | detectors A/D (#19/#44/#54) | ✅ |
| Bounded local repair (≤2 broadcasts, wait 5×) | 3.4 | `repairMaxBroadcasts`, `repairWaitFactor` | ✅ |

Every pinned-down parameter and its match/deviation status is tabulated in the
[paper digest §3](publications/papers/2004-ppsn-anthocnet.md).

## Headline results vs AODV (paper regime: 50 nodes, 1500×300 m, RWP 20 m/s, 20 CBR flows)

| Paper claim ([1] §4.2) | Reproduced? | Evidence (this repo, ns-3, 5 seeds) |
|---|---|---|
| **PDR ≥ AODV**, gap grows with difficulty | ✅ | 92.1 vs 81.4 (disk); 92.9 vs 83.4 (two-ray). #22 (mobility), taxonomy |
| **Overhead (NRL) below AODV** | ✅ | 45 vs 61 (disk); 44 vs 75 (two-ray) |
| **Delay/jitter QoS advantage** (bounded tail) | 🟡 partial | **two-ray (paper PHY): mean-delay parity** with AODV (52.8 vs 52.6 ms), jitter within 11 %, after the #21 reconv hold cap (#104). **Disk model**: tail narrowed (delay99 −37 %, jitter −26 % via `ReconvHoldCap`) but still above AODV |

## Known deviations (honest list)

1. **Delay tail on the ns-3 disk model (#21).** On the contention-dominated
   range/disk propagation model AntHocNet's delay99/jitter run above AODV even
   after the multipath (#96), backward-ant flush (#101) and reconv hold-cap
   (#104) work. On **two-ray** — the paper's actual PHY — the gap closes to
   parity on mean delay. The residual is a **channel-model artefact**
   (CONTEXT.md §8), not an algorithmic gap. Mitigated by `ReconvHoldCap=1.0 s`
   (default). **Note (2026-07-25):** the `T_hop` co-lever named in item 2 has
   now been corrected to the thesis value; the benchmark impact on this tail is
   pending a re-run (#88).
2. **`T_hop` — resolved from the primary source (#88, 2026-07-25).** [1] defines
   the constant but states no number. The **2007 Ducatelle thesis** does: *"we
   kept thop on 0.003 sec"*. The repo's provisional **50 ms was 16.7× too
   large** and is now corrected to **3 ms**. Because `T_hop` weights hop count
   against measured delay in every pheromone deposit, this changes all routing
   goodness values — **every benchmark number in this document predates the fix
   and must be re-measured** before being cited as current. A prior sweep
   suggested a few-ms value cuts delay/jitter ~12 %, so the #21 delay tail may
   improve.
3. **Evaporation** (`enableEvaporation`, default on; ADR-0012) — a time-decay
   safety net **not present in [1]** (whose reinforcement is a pure running
   average). Config-gated so the paper-faithful ablation is available.
4. **Proactive ant clocking** — [1] emits one proactive ant per *n* data
   packets; the repo clocks it on a **timer** (`proactiveInterval`). #26 item 04.
5. **Multipath link-failure suppression** — with multipath on, a link break that
   leaves a usable alternate next-hop is absorbed rather than always notified
   (paper §3.4 always notifies). Benchmark-justified (#96): notification floods
   cost PDR on the ns-3 channel.
6. **Cross-simulator parity is not guaranteed** — NS-2 and NS-3 have different
   MAC/PHY; the NS-2 adapter also has no pending-queue hold cap yet. Treat
   cross-sim comparison as behaviour re-validation, not a bit-for-bit port.

## Verification status

- **Algorithm mechanisms**: ✅ covered by `core/tests` (unit + randomized
  property/invariant sweeps), NS-2/NS-3 e2e delivery smokes in CI.
- **Parameters vs [1] (2004 paper)**: ✅ verified — see the digest table.
- **Parameters vs 2007 thesis**: 🟡 partial — thesis obtained 2026-07-25.
  `T_hop` ✅ adopted (3 ms). Jitter estimator ✅ *defined* in the thesis
  (eq. 5.1, `Σ|(tᵢ−tᵢ₋₁)−(tᵢ₋₁−tᵢ₋₂)|`) but **not yet reconciled** with our
  FlowMonitor `jitterSum` metric (#89). Full field table ⏳ (#58).
- **Numbers on the paper's own 900 s / large-scale field**: ⏳ `--scenario=thesis`
  preset exists; the multi-hour run is future work.

v1.0 is the milestone where the mechanisms and 2004-paper parameters are
faithful and the delivery/overhead claims reproduce; the thesis parameter
cross-check and the full disk-model delay-tail closure are the roadmap beyond it
(#91).
