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
| Reactive ant floods when it has no pheromone | 3.1 | default behaviour; `enableDirectedReactive` steers instead (ADR-0016) | ✅ faithful by default — the deviation is **off** |
| Hello beacons (1 s, 2 missed → remove) | 3.3 fn.1 | `helloInterval`, `allowedHelloLoss` | ✅ |
| Link-failure detection + notification | 3.4 | detectors A/D (#19/#44/#54) | ✅ |
| Bounded local repair (≤2 broadcasts, wait 5×) | 3.4 | `repairMaxBroadcasts`, `repairWaitFactor` | ✅ |

Every pinned-down parameter and its match/deviation status is tabulated in the
[paper digest §3](publications/papers/2004-ppsn-anthocnet.md); the corresponding
`Config` defaults, the provenance category of each (`[1] §x` / thesis / repo
choice / **unknown**) and how to calibrate one are in
[`configuration.md`](configuration.md).

## Headline results vs AODV (paper regime: 50 nodes, 1500×300 m, RWP 20 m/s, 20 CBR flows)

| Paper claim ([1] §4.2) | Reproduced? | Evidence (this repo, ns-3, 5 seeds) |
|---|---|---|
| **PDR ≥ AODV**, gap grows with difficulty | ✅ | 92.1 vs 81.4 (disk); 92.9 vs 83.4 (two-ray). #22 (mobility), taxonomy |
| **Overhead (NRL) below AODV** | ✅ | 45 vs 61 (disk); 44 vs 75 (two-ray) |
| **Delay/jitter QoS advantage** (bounded tail) | 🟡 partial | **two-ray (paper PHY): mean-delay parity** with AODV (52.8 vs 52.6 ms), jitter within 11 %, after the #21 reconv hold cap (#104). **Disk model**: tail narrowed (delay99 −37 %, jitter −26 % via `ReconvHoldCap`) but still above AODV |

## Correction pending re-measurement (#169, 2026-07-25)

**Every benchmark number in this document was produced with
`reactiveMaxBroadcasts = 2`**, which — because a reactive forward ant
broadcasts at every node lacking pheromone for the destination — was a *hop
limit on route discovery*: destinations more than ~5 hops away were never
found at all. Both primary sources bound the reactive flood by duplicate
suppression and `maxPathLength`, never by a broadcast count; the 2-broadcast
rule belongs to *proactive* ants ([1] §3.3). The default is now unbounded.

This most likely explains the sparse/long-path results that were previously
read as protocol character — in particular the static-network inversion
(delivery 59.9 % vs AODV 98.9 % at `pause=900`, while AntHocNet *led* under
constant motion) and the decay of its advantage as the field is stretched.
Until the sweeps are re-run, treat every result below — including the headline
PDR/NRL figures — as **pending re-measurement**, and do not cite the
sparse-static weakness as a property of the algorithm.

**Confirmed, and it exposed a second defect.** The first taxonomy run after the
fix bears the diagnosis out: `sparse-static` rose 83.8 → **93.0 %**, overtaking
AODV (81.9 %), and the inversion is gone. But `large-scale` fell 75.8 → 21.7 %
and `heavy-load` 85.0 → 51.4 %, with NRL rising 99.9 → 3071. Cause
([#173](https://github.com/danieljoppi/AntHocNet/issues/173)): with
`enableMultipath` on, a reactive forward ant is admitted by the acceptance band
*instead of* `(src,seq)` duplicate suppression, so removing the broadcast budget
left the reactive flood unbounded in dense graphs. `reactiveMaxBroadcasts` is
now a **per-(node, generation)** broadcast count (default 2) rather than a
per-path budget — bounding the flood without reintroducing the #169 hop limit.
Numbers measured between those two fixes carry the flood and are not
representative either.

## Where we ship [1]'s algorithm and the 2007 thesis superseded it

The thesis is this repo's **designated primary source for parameters that [1]
leaves unspecified** (#58/#70). On three mechanisms the two sources disagree
because the thesis's authors *changed the algorithm*, and in all three we ship
the [1] version. That is defensible — [1] is a real published algorithm and the
one this document's claims are written against — but it had not been stated
anywhere, so a reader checking us against the thesis would read three
deliberate choices as three defects. Recorded here (audit:
[#182](https://github.com/danieljoppi/AntHocNet/issues/182)):

1. **Multipath reactive route setup.** [1] §3.1 admits later same-generation
   ants within a 1.5× band (`enableMultipath`, `antAcceptanceFactor`). The
   thesis parameterises the same band differently (`a1 = 0.9`, plus `a2 = 2`
   for first-hop-disjoint ants) and then records dropping the design: reactive
   setup is restricted to a single route, with multiple routes obtained through
   *proactive* maintenance instead.
   [#177](https://github.com/danieljoppi/AntHocNet/issues/177) is measuring the
   options; [#178](https://github.com/danieljoppi/AntHocNet/issues/178) records
   the citation trap.
2. **Proactive broadcast probability** (`proactiveBroadcastProb = 0.1`). Our
   exact value appears in the thesis, but in §4.3.4, *"Older versions of
   AntHocNet"*. In the shipped thesis algorithm proactive forward ants are
   "never broadcast" — on reaching a node with no routing information for the
   destination they are simply discarded.
3. **Proactive broadcast budget** (`proactiveMaxBroadcasts = 2`). Same section,
   same status: the thesis states the budget as `nb = 2` for the older
   algorithm only. With no proactive broadcasting in the current version, there
   is nothing for the budget to bound there.

So the accurate claim is "faithful to [1]", not "as close to the 2007 thesis as
possible". Provenance for each parameter is in
[`configuration.md`](configuration.md) §3.1, where these rows are marked
`thesis §4.3.4 (superseded version)` rather than a bare `thesis`.

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
6. **Directed reactive discovery** (`enableDirectedReactive`, default **off**;
   ADR-0016) — a mechanism in **neither source**: a reactive forward ant may be
   unicast along the diffused virtual gradient instead of broadcast. Listed here
   for completeness rather than as an active deviation — with the default off the
   shipped protocol matches [1] §3.1 exactly, and the gate exists to make the
   *deviation* runnable (the inverse of item 3, where the gate makes the
   *fidelity* runnable). #244 measures it; #245 tracks the open hazard that a
   stale gradient can strand the single steered ant where a flood would not have
   been.
7. **Cross-simulator parity is not guaranteed** — NS-2 and NS-3 have different
   MAC/PHY; the NS-2 adapter also has no pending-queue hold cap yet. Treat
   cross-sim comparison as behaviour re-validation, not a bit-for-bit port.

## Verification status

- **Algorithm mechanisms**: ✅ covered by `core/tests` (unit + randomized
  property/invariant sweeps), NS-2/NS-3 e2e delivery smokes in CI.
- **Parameters vs [1] (2004 paper)**: ✅ verified — see the digest table.
- **Parameters vs 2007 thesis**: 🟡 partial — thesis obtained 2026-07-25.
  `T_hop` ✅ adopted (3 ms). Jitter estimator ✅ *defined* in the thesis
  (eq. 5.1, `Σ|(tᵢ−tᵢ₋₁)−(tᵢ₋₁−tᵢ₋₂)|`) but **not yet reconciled** with our
  FlowMonitor `jitterSum` metric (#89). Full field table ✅ read from §5.1.3 and
  adopted into `--scenario=thesis` (#58) — five constants corrected
  (2400×800 m, 10 m/s, 2048 bps, 250 m range, 20 repetitions); the thesis's
  two-ray propagation still has to be asked for with `--propagation=tworay`.
- **Numbers on the paper's own 900 s / large-scale field**: ⏳ `--scenario=thesis`
  preset exists; the multi-hour run is future work.

v1.0 is the milestone where the mechanisms and 2004-paper parameters are
faithful and the delivery/overhead claims reproduce; the thesis parameter
cross-check and the full disk-model delay-tail closure are the roadmap beyond it
(#91).
