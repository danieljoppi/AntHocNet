# Protocol configuration & calibration

Every tunable AntHocNet parameter, **where its default came from**, what it
affects, and how to change one without fooling yourself. Aimed at researchers
reproducing or extending the protocol, and at contributors adding a knob.

Companion pages: [`fidelity.md`](fidelity.md) (what matches [1] and what
deliberately does not), the [paper digest](publications/papers/2004-ppsn-anthocnet.md)
(§3 is the authoritative parameter table for [1]), and the
[benchmark index](benchmarks.md) (how any claimed effect gets measured).

## 1. Where configuration lives

One struct, two surfaces:

| Layer | File | What it is |
|---|---|---|
| Core | [`core/include/anthocnet/core/config.h`](../core/include/anthocnet/core/config.h) | `anthocnet::core::Config` — **31 fields**, plain C++14 aggregate with default member initializers. The single source of truth; `AntRouterLogic` reads nothing else. |
| NS-3 | [`ns3/model/anthocnet-routing-protocol.cc`](../ns3/model/anthocnet-routing-protocol.cc) | 25 `AddAttribute` blocks on `ns3::anthocnet::RoutingProtocol`. **19** of them write into `Config`; the other 6 are adapter-side state (queue timeouts, hold caps, the MAC failure detector, the MAC service-time EWMA, the adapter's own reactive-retry timer). |
| NS-2 | [`ns2/src/ahn_router.cc`](../ns2/src/ahn_router.cc) | 10 `bind()`/`bind_bool()` TCL variables writing into `Config`, plus four compile-time `AHN_*` macros in [`ahn_router.h`](../ns2/src/ahn_router.h) (`AHN_HELLO_INTERVAL`, `AHN_PROACTIVE_INTERVAL`, `AHN_NETWORK_DIAMETER`, `AHN_LIFE_ANT`). |

So a field can be a core default only, or reachable from one adapter, or from
both — the table in §2 says which. Anything not exposed by your adapter must be
changed in `config.h` and rebuilt.

Attribute override syntax for ns-3 (this is what a sweep drives):

```
--ns3::anthocnet::RoutingProtocol::<Attribute>=<value>
```

## 2. Why this document exists — the provenance lesson

Two protocol defaults were found wrong within a week of each other in July 2026.
Neither was a coding error. Both were **provenance** errors: the value in the
struct had no traceable source, so nobody could tell it was wrong by reading it.

- **`hopTimeSec`** ([#88](https://github.com/danieljoppi/AntHocNet/issues/88),
  PR #167). [1] defines `T_hop` — "the time of taking one hop in unloaded
  conditions" — but gives no number, so the repo shipped a *provisional* 50 ms.
  The 2007 Ducatelle thesis states it: *"we kept thop on 0.003 sec"*. The
  default was **16.7× too large**, and `T_hop` scales the hop-count term in
  **every** pheromone deposit (`τ = ((T̂ + h·T_hop)/2)⁻¹`) — i.e. it biased
  every routing decision the protocol ever made. The fix was a one-line change;
  finding it took reading a primary source nobody had checked.
- **`reactiveMaxBroadcasts`** ([#169](https://github.com/danieljoppi/AntHocNet/issues/169),
  PR #170). It defaulted to **2**. Because a reactive forward ant broadcasts at
  *every* node that lacks pheromone for the destination, a broadcast budget is a
  **hop limit on discovery**: destinations more than ~5 hops away were never
  found. Both primary sources bound the reactive flood by duplicate suppression,
  `maxPathLength` and the acceptance band — **never** by a count. The
  2-broadcast rule is real, but it belongs to *proactive* ants ([1] §3.3,
  [#45](https://github.com/danieljoppi/AntHocNet/issues/45)); it had been
  generalised to reactive ants in error. This most likely explains the
  sparse/static results that were being read as protocol character (see the
  correction notice in [`fidelity.md`](fidelity.md)).

- **`reactiveMaxBroadcasts`, again** ([#173](https://github.com/danieljoppi/AntHocNet/issues/173)).
  Removing that budget exposed a second defect underneath it, and this one is
  the more instructive of the two: **no single change was wrong.**
  [#96](https://github.com/danieljoppi/AntHocNet/issues/96) made reactive
  forward ants take the multipath acceptance band *instead of* `(src,seq)`
  duplicate suppression — reasonable, since the band is the paper's multipath
  rule. #169 then removed the broadcast budget — also reasonable, and correct.
  But the band *admits* rather than suppresses, so between them the two changes
  left reactive discovery with no flood bound at all: one discovery on a 7×7
  grid cost **30,090** ants, and ns-3 `large-scale` fell from 75.8% to **21.7%**
  PDR at NRL 3071. The fix bounds broadcasts per *(node, generation)*, which
  bounds the flood without reintroducing a hop limit.

The first two cost a benchmark campaign to detect and invalidated published
numbers. The third was invisible to *every* existing test because each change
was locally justified and the invariant they jointly broke — "a reactive flood
is bounded by something" — was written only in a code comment, which silently
became false. The job of §3 below is to make the next one catchable **by
reading**: each default carries the category of evidence behind it, and where
there is none, it says so.

> **Rule of thumb.** If you cannot name the source of a number you are about to
> rely on, treat it as a suspect, not as a setting.

## 3. The parameter table

Every field of `Config`, in declaration order. `source` categories:

- **`[1] §x`** — stated in the 2004 PPSN paper at that section, per the
  [digest](publications/papers/2004-ppsn-anthocnet.md).
- **`thesis`** — from the 2007 Ducatelle thesis (the designated primary source
  for parameter verification, #58/#70).
- **`repo choice`** — chosen by this implementation and documented here (ADR or
  issue), **not** present in any source. Since #182 this also covers numbers an
  audit has *positively confirmed* are absent from the sources; those rows carry
  the search terms that were tried, so the search is not repeated.
- **`derived`** — the mechanism is in a source but the number is implied rather
  than stated.
- **`unknown`** — no recorded justification for the number, anywhere. These are
  listed again in §3.2; they are the next #88/#169 candidates.

The `ns-3 attribute` column is the name you pass to
`--ns3::anthocnet::RoutingProtocol::<name>`; `—` means the field is core-only
(edit `config.h` and rebuild).

### 3.1 All 31 fields

| parameter | default | unit | ns-3 attribute | source | what it affects |
|---|---|---|---|---|---|
| `alpha` | `0.7` | retention factor per `evaporationInterval` | `Alpha` | `repo choice` — legacy `ALFA` constant, and **positively absent from both sources** ([#182](https://github.com/danieljoppi/AntHocNet/issues/182)): [1] has **no** evaporation term, and in the thesis "evaporation" appears *only* in the generic ACO background (its §3.2, eq. 3.2, rate ρ) — AntHocNet itself uses the eq. 4.3 running average plus explicit zeroing on link failure. Searched `evaporat`, `ρ`, `aging\|ageing\|decay`, `set to 0`, `0.7`. This confirms [ADR-0012](adr/0012-evaporation-is-a-secondary-safety-net.md)'s premise: there is no source value to calibrate against. ADR-0012 changed this field's meaning to a time-proportional retention factor and says it "must be re-tuned"; no re-tune is recorded. **⚠ naming trap:** the thesis has *three* distinct 0.7s — γ (pheromone running average → our `gamma` ✅), **α (the hop-count moving average, eq. 4.2, `h_in^d ← α·h_in^d + (1−α)·h` — a mechanism we do not implement**; we feed the ant's instantaneous hop count straight into the metric), and η (MAC send-time average → ns-3 `MacServiceAlpha` ✅). `Config::alpha` corresponds to **none** of them. | How fast unrefreshed regular pheromone decays on the maintenance tick (`α^(Δt/evaporationInterval)`). Lower = more aggressive forgetting. |
| `gamma` | `0.7` | weight | `Gamma` | `[1] §3.1` — "Pheromone running-average weight γ = **0.7**" (digest §3). | Reinforcement inertia: `T ← γ·T + (1−γ)·τ`. Higher = slower adaptation, smoother pheromone. |
| `betaAnts` | `1.0` | exponent | `BetaAnts` | `[1] §3.3` — proactive ants follow **unsquared** pheromone (#70). **The thesis sets β₁ = 20** for reactive ants and β₂ = 20 for proactive ants — two exponents this one field conflates — so this is a 20× deviation that changes the protocol's character, not just its tuning; unsettled, A/B pending ([#179](https://github.com/danieljoppi/AntHocNet/issues/179)). | Exploration greediness of ants. Higher concentrates ants on known-good hops (less exploration). |
| `betaData` | `2.0` | exponent | `BetaData` | `[1] §3.2` — data uses pheromone **squared**, "to be more greedy" (#70). **The thesis sets β₃ = 20** (10× ours); unsettled, A/B pending ([#179](https://github.com/danieljoppi/AntHocNet/issues/179)). | Greediness of stochastic data forwarding. Higher = closer to single-path; lower = more spread (and more reordering). |
| `hopTimeSec` | `0.003` | s | `HopTime` | **`thesis`** — Ducatelle 2007, *"we kept thop on 0.003 sec"* ([#88](https://github.com/danieljoppi/AntHocNet/issues/88), PR #167). [1] §3.1 defines the constant but states no value. **⚠ the thesis uses the symbol `t_hop` for two different values** ([#182](https://github.com/danieljoppi/AntHocNet/issues/182)): eq. 4.7 — the *repair timer*, `timer = 2 · t_hop · h_ij^d` — sets it to **50 ms** ("a fixed delay value per hop"), while eq. 4.10 — *this* pheromone metric — sets it to **3 ms**. `hopTimeSec` feeds the metric, so 3 ms is correct. A reader working forward through the thesis hits the 50 ms first; do **not** "restore" it here. | The hop-count term in **every** pheromone deposit, `τ = ((T̂ + h·T_hop)/2)⁻¹`, and the A2 fallback service time. Larger = hop count dominates measured delay. |
| `enableMacMetric` | `false` | bool | `EnableMacMetric` | Formula `[1] §3.1` (`(Q_mac+1)·T̂_mac`, confirmed in #70); **default-off is `repo choice`** — gated until a benchmark justifies the switch. The thesis makes the same formula (its eq. 4.8) the *base* of every non-hop metric rather than an option, and its headline results use an SINR metric we do not implement at all ([#181](https://github.com/danieljoppi/AntHocNet/issues/181)). | Whether a forward ant records the node's expected MAC send time (congestion-aware) instead of its own wall-clock transit delta. |
| `minPheromone` | `0.00001` | pheromone units | — | `repo choice` — legacy `MIN_PHEROMONE` constant, and **positively absent from the thesis** ([#182](https://github.com/danieljoppi/AntHocNet/issues/182)): it zeroes pheromone on link failure and tests "non-zero"; it never uses a floor. Searched `minimum pheromone`, `threshold`, `prune`, `non-zero`, `small value`, `removed from the pheromone table`. | Prune threshold: links at or below it are dropped from the table and do not count as "has a route". |
| `enableEvaporation` | `true` | bool | — | `repo choice` — [ADR-0012](adr/0012-evaporation-is-a-secondary-safety-net.md). **Not in [1]**, which has no evaporation term; kept as an explicit safety net, gated so the paper-faithful ablation is runnable. | Master switch for time-proportional aging of regular pheromone. Off = running-average + explicit link-failure removal only. |
| `evaporationInterval` | `1.0` | s | — | `repo choice` — introduced by ADR-0012 as a "reference interval"; the number is not justified there or elsewhere, and there is nothing to source it *to*: neither source has a decay tick to have an interval (same search as `alpha`, [#182](https://github.com/danieljoppi/AntHocNet/issues/182)). | Denominator of the decay exponent. Together with `alpha` it *is* the decay rate; changing either alone is meaningless. |
| `reactiveRetryInterval` | `1.0` | s | — (see note) | **`unknown`** (number only) — the *mechanism* is real and belongs to **thesis §4.1.2**; `config.h`'s `[1] §4.2` citation is wrong, because §4.2 of the PPSN paper is the *results* section (see §3.3 below). Neither source states a numeric interval, so the 1.0 s stays unsourced ([#182](https://github.com/danieljoppi/AntHocNet/issues/182)). | At most one reactive forward ant per destination per window, so packets to an unreachable destination cannot flood ants. Also rate-limits repair-ant launches. |
| `enableProactive` | `true` | bool | `EnableProactive` | Mechanism `[1] §3.3`; **the gate** is `repo choice` ([ADR-0007](adr/0007-proactive-diffusion-gated.md)) so the ablation is runnable. | Master switch for proactive ants **and** diffusion. Off = purely reactive AntHocNet. |
| `enableDiffusion` | `true` | bool | `EnableDiffusion` | Mechanism `[1] §3.3` (hello messages as pheromone diffusion); **the gate** is `repo choice` (ADR-0007). | Whether hellos carry pheromone adverts and the virtual table is maintained. Virtual pheromone guides proactive ants only, never data. |
| `proactiveBroadcastProb` | `0.1` | probability per hop | `ProactiveBroadcastProb` | `thesis §4.3.4 (superseded version)` — mechanism `[1] §3.3` ("a small probability of being broadcast"), which states no value; the thesis *does* state our exact 10%, but in **§4.3.4, "Older versions of AntHocNet"**. In the shipped thesis algorithm the mechanism does not exist: proactive forward ants are "**never broadcast**: when they arrive at a node that does not have any routing information for their destination, they are discarded" ([#182](https://github.com/danieljoppi/AntHocNet/issues/182)). Read as [1]'s algorithm, not the thesis's — see [`fidelity.md`](fidelity.md). | How often an in-transit proactive ant explores by broadcast instead of following pheromone. Higher = more exploration, more control overhead. |
| `sessionTtl` | `5.0` | s | `SessionTtl` | `repo choice` — an implementation *necessity* with no source, which is a different thing from an unexplained number ([#182](https://github.com/danieljoppi/AntHocNet/issues/182)). The thesis's simulator knows session boundaries directly — proactive ants are scheduled "only from the moment a session is started, and until the end of it" — so it never needs an inactivity timeout; we have no such oracle. [1] §3.3 clocks proactive ants to the *data rate* (one per n packets) and has no session-TTL concept either. The 5 s value is still not sweep-backed. | How long after the last locally-originated data packet a destination keeps being probed by proactive ants. |
| `helloInterval` | `1.0` | s | `HelloInterval` | `[1] §3.3 fn.1` — `t_hello`, "e.g. 1 s". | Beacon rate, and (with `allowedHelloLoss`) the neighbour-liveness window. Drives baseline control overhead. |
| `proactiveInterval` | `10.0` | s | `ProactiveInterval` | **`unknown`** — the *mechanism* is a documented deviation (`repo choice`: timer-clocked vs [1]'s data-rate clocking, [`fidelity.md`](fidelity.md) deviation 4); the 10 s value has no recorded basis. **The thesis clocks proactive ants on a plain periodic timer as we do** — at `t_hello` = 1 s, with a measured optimum of 2 s and an emission gate we do not implement — so against our designated primary source the mechanism is not the deviation it is documented as, and only the number is wrong ([#180](https://github.com/danieljoppi/AntHocNet/issues/180) owns both corrections). | Proactive forward-ant rate per active session. Lower = faster path re-optimisation, more overhead. |
| `lifeAnt` | `2.0` | s | — | `repo choice` (inert) — no doc comment, and **positively absent from the thesis** ([#182](https://github.com/danieljoppi/AntHocNet/issues/182)), which gives no ant lifetime or TTL for *any* ant type. Searched `TTL`, `time-to-live`, `ant lifetime`, `ants are deleted`, `deleted after`, `expire`. Note it is *carried on the wire* (`AntMessage::lifeAnt`, repair ants) but **no core code reads it back**, so today it changes nothing. | Nominal repair-ant lifetime budget. Currently inert; see §3.3. |
| `allowedHelloLoss` | `2` | count | — | `[1] §3.3 fn.1` — a neighbour is removed after **2** missed expected hellos. | `maxIdle = helloInterval × allowedHelloLoss`. Lower = faster failure detection, more false evictions and rediscovery floods. |
| `repairMaxBroadcasts` | `2` | count | — | `[1] §3.4` — route repair ant, "max **2** broadcasts" (`config.h` cites §3.5; see §3.3). | Re-broadcast budget for repair ants **and** for LinkFail notifications, so local repair cannot storm. |
| `linkfailNotifyInterval` | `5.0` | s | `LinkfailNotifyInterval` | `repo choice` — the [#20](https://github.com/danieljoppi/AntHocNet/issues/20) sweep picked 5.0 (1 s misses the ~3 s flap cycle; 10 s costs PDR/delay). [1] has **no** rate limit. | Minimum spacing between LinkFail notices this node originates about the same destination. `0` disables (spec-faithful). |
| `txFailureThreshold` | `3` | consecutive failures | `TxFailureThreshold` | `repo choice` — a **documented deviation from thesis §4.2.5**, which has *no* debounce at all: on a MAC transmit failure it "assumes in that case that the corresponding link has failed" ([#182](https://github.com/danieljoppi/AntHocNet/issues/182)). Keeping the debounce is argued in [#19](https://github.com/danieljoppi/AntHocNet/issues/19)/[ADR-0008](adr/0008-neighbour-liveness-two-detectors.md) detector D; the **value 3 is still not sweep-backed** (see §3.2). | How many consecutive MAC transmit failures to the same next hop (with no reception in between) count as a broken link. Lower = jumpier, more rediscovery. |
| `reactiveMaxBroadcasts` | `-1` (unbounded) | broadcasts per node per `(src,seq)` generation; `-1` = no bound | — | `derived` — the sources bound the reactive flood by duplicate suppression, `maxPathLength` and the acceptance band, **never by a count** ([#169](https://github.com/danieljoppi/AntHocNet/issues/169)). The per-node bound introduced by [#173](https://github.com/danieljoppi/AntHocNet/issues/173) was retired in [#177](https://github.com/danieljoppi/AntHocNet/issues/177): at the thesis's own `a1 = 0.9` the band is self-limiting, so no count is needed. Kept configurable for sensitivity experiments. | How many times a node re-broadcasts one discovery. Any finite value bounds the flood; `-1` leaves it to the acceptance band. **Note the unit has changed twice** — it was a per-ant hop budget before #169, a per-node count in #173, and is inert at the default now. |
| `enableMultipath` | `true` | bool | `EnableMultipath` | Mechanism `[1] §3.1` (the acceptance filter); **the gate and the linkfail churn bound** are `repo choice` ([#96](https://github.com/danieljoppi/AntHocNet/issues/96), A/B-justified: PDR 92.3 vs 89.4). | Whether later same-generation reactive ants may lay additional paths, and whether losing a best hop that leaves a usable alternate is absorbed instead of flooding a LinkFail. Off = strict `(src,seq)` dedup, single-path setup. |
| `antAcceptanceFactor` | `0.9` | factor (base, `a1`) | `AntAcceptanceFactor` | **`thesis`** — `a1`, "set quite low (to 0.9), in order to only allow the best ants through and avoid too much proliferation of forward ants in the network". [1] §3.1 states a single factor of **1.5**; the thesis supersedes it with this two-factor scheme, and 1.5 was the shipped value until [#177](https://github.com/danieljoppi/AntHocNet/issues/177) measured 0.9/2.0 better. | Applied when the ant's **first hop has already been seen** among accepted ants of this generation. Below 1.0 it admits only ants *better* than the incumbent, so each admission tightens the band — this is what makes the flood self-limiting. |
| `antAcceptanceFactorNewHop` | `2.0` | factor (`a2`) | `AntAcceptanceFactorNewHop` | **`thesis`** — `a2`, "If this first hop is different from those taken by previously accepted ants, we apply a higher (less restrictive) acceptance factor a2 … (a2 was set to 2)" ([#177](https://github.com/danieljoppi/AntHocNet/issues/177)). | Applied when the ant's first hop is **new** for this generation. Deliberately permissive: it buys *disjoint* paths, which the thesis argues protect better against link failures than near-copies of the best path. |
| `proactiveMaxBroadcasts` | `2` | count | — | `[1] §3.3` — a proactive ant may be broadcast "at most **2**" times, else deleted (#45) — **and `thesis §4.3.4 (superseded version)`**, which states the same budget as `nb = 2` but only for the *older* algorithm; the shipped thesis version never broadcasts proactive ants at all, so this budget has nothing to bound there ([#182](https://github.com/danieljoppi/AntHocNet/issues/182)). Not a current-thesis value — see [`fidelity.md`](fidelity.md). | Bounds proactive exploration, including across a route gap en route. Unbounded lets proactive ants flood regions of missing routes (#45). |
| `repairWaitFactor` | `5.0` | × estimated path delay | `RepairWaitFactor` | `[1] §3.4` — wait **5×** the estimated end-to-end delay of the lost path (`config.h` cites §3.5; see §3.3). **Deviation from the thesis** ([#182](https://github.com/danieljoppi/AntHocNet/issues/182)): its repair timer is `2 · t_hop · h_ij^d` with `t_hop = 50 ms` (eq. 4.7) — **hop-count based, not delay based**, which is why it needs no `repairTimeout` fallback. Recorded, not changed. | How long buffered packets wait for a backward repair ant before being discarded and a LinkFail sent (spec D6). |
| `repairTimeout` | `1.0` | s | `RepairTimeout` | **`unknown`** — a fallback the paper does not define (it always has a delay estimate); the value has no recorded basis. | Flat repair wait used when the lost path has no usable delay estimate. |
| `networkDiameter` | `30` | hops | — | `repo choice` (dead) — legacy constant, and **positively absent from the thesis** ([#182](https://github.com/danieljoppi/AntHocNet/issues/182)): the string `diameter` does not occur in it, and it has no hop limit or expanding-ring search. Searched `diameter`, `TTL`, `hop limit`, `maximum number of hops`. **No `core/` code reads this field**; only the NS-2 adapter uses its `AHN_NETWORK_DIAMETER` macro, and it uses the macro directly (as the IP TTL of ant packets), not the `Config` field. | Nothing, in `core/`. See §3.3. |
| `maxPathLength` | `100` | nodes | — | `repo choice` — golden rule 5 (bounded structures); pinned to the wire format (`kMaxVisitedOnWire == 100`). Number is a deliberately generous cap, not a tuned value. | Caps the visited-node stack an ant carries, **and** is a backstop on the reactive flood (with duplicate suppression and, since #173, the per-node broadcast count). Changing it is a wire-format change (golden rule 4). |
| `maxHistory` | `4096` | entries | — | `repo choice` — golden rule 5; digest §6 records that dedup bounds are "not in [1]". Number is a generous cap, not tuned. | FIFO cap on the `(src,seq)` dedup history and the generation-quality tracker. Too small aliases dedup and re-admits old ants. |

### 3.2 Parameters with no recorded provenance

**Four** of the thirty defaults have **no traceable justification for the
number**. They are the standing #88/#169 risk, listed here so the next audit has
a worklist rather than a haystack:

| parameter | default | why it is unknown | risk if wrong |
|---|---|---|---|
| `reactiveRetryInterval` | `1.0` s | The mechanism is thesis §4.1.2 (`config.h`'s `[1] §4.2` citation points at the PPSN results section), but neither source states an interval. | Medium — too large delays rediscovery after a lost ant; too small re-floods. |
| `proactiveInterval` | `10.0` s | No source for 10 s. The thesis *does* state a rate — `t_hello` = 1 s, optimum 2 s — so this number is not merely unsourced but probably wrong; it is being corrected together with the missing emission gate under [#180](https://github.com/danieljoppi/AntHocNet/issues/180). | Medium — the whole proactive maintenance rate. |
| `repairTimeout` | `1.0` s | Fallback path neither source defines — [1] always has a delay estimate, and the thesis's repair timer is hop-count based (`2 · 50 ms · hops`) so it never needs one. | Low–medium — only fires when the lost path had no delay estimate. |
| `txFailureThreshold` | `3` | #19/ADR-0008 justify *having* a debounce (the thesis §4.2.5 has none); the value is not sweep-backed. | Medium — sets link-failure sensitivity, which drives repair/LinkFail volume (cf. #20). |

**This list was eleven rows until the full thesis audit**
([#182](https://github.com/danieljoppi/AntHocNet/issues/182)). Seven rows left it,
and *how* they left matters — none of them became better-justified numbers:

- **Five are positively unsourceable, which is a result rather than a gap.**
  `alpha`, `evaporationInterval`, `minPheromone`, `lifeAnt` and
  `networkDiameter` were searched for in the thesis and are genuinely absent
  (there is no evaporation term, no pheromone floor, no ant TTL and no hop
  limit anywhere in it). They are now `repo choice`, and **each §3.1 row records
  the search terms that were tried** so that nobody re-runs the search. The
  numbers are still untuned — an absent source means there is nothing to
  calibrate against, so a sweep is the only way to justify them.
- **`sessionTtl` is an implementation necessity, not an unexplained number.**
  The thesis's simulator knows session boundaries directly, so it needs no
  inactivity timeout at all; ours does. `repo choice`, value still unswept.
- **`proactiveBroadcastProb` turned out to be sourced — to the algorithm the
  thesis superseded.** Our exact 10% is in thesis §4.3.4, "Older versions of
  AntHocNet"; the shipped thesis version never broadcasts proactive ants. See
  [`fidelity.md`](fidelity.md) for the three mechanisms where we ship [1]'s
  algorithm over the thesis's.

Two further caveats that are *not* "unknown" but are worth knowing: `maxPathLength`
and `maxHistory` have a documented *purpose* (golden rule 5) but untuned
*numbers*; they are deliberately over-provisioned safety caps, and
`maxPathLength` additionally has a wire-format constraint.

### 3.3 Citation discrepancies found while writing this table

Recorded rather than silently normalised — an unresolvable citation is the same
class of defect as a missing one.

1. **`config.h` section numbers do not all match the PPSN-2004 digest.** Three
   comments cite `[1] §3.5` (`allowedHelloLoss`, `repairMaxBroadcasts`,
   `repairWaitFactor`) where the digest puts the content in §3.3 fn.1 / §3.4;
   one cites `[1] §4.2` (`reactiveRetryInterval`) where §4.2 is the results
   section — that mechanism is **thesis §4.1.2**
   ([#182](https://github.com/danieljoppi/AntHocNet/issues/182)). [ADR-0012](adr/0012-evaporation-is-a-secondary-safety-net.md) also
   cites "[1] … ETT 2005 … §3.3" while [`fidelity.md`](fidelity.md) and the
   digest define **[1]** as PPSN VIII 2004. The likely explanation is that some
   comments follow the **2005 ETT journal** version's numbering, which has a
   different section layout. The *mechanisms* all check out against the digest;
   only the pointers drift. Anyone verifying a parameter should read the digest
   §3 table, not the inline `§` number.
2. **`ReactiveRetryInterval` is two different things.** The ns-3 attribute of
   that name (default **0.25 s**) is an *adapter-side* timer that re-floods for
   destinations with data still queued and no route (issue #21); it does **not**
   write into `Config::reactiveRetryInterval` (default **1.0 s**), which is the
   core's per-destination rate limit on originating reactive ants. Setting the
   attribute does not change the core knob.
3. **`networkDiameter` and `lifeAnt` are carried but not consumed** (see §3.2).
   Flagged, not deleted — CLAUDE.md rule 3.

### 3.4 ns-3 attributes that are *not* `Config` fields

Six of the 24 attributes configure the NS-3 adapter, not the algorithm. They are
listed here so a sweep does not mistake one for a protocol parameter:

| attribute | default | what it does |
|---|---|---|
| `EnableMacFailureDetector` | `true` | Enables the WifiMac transmit-failure detector (ADR-0008 detector D). The hello-timeout detector (A) always runs. |
| `QueueTimeout` | `3 s` | How long a data packet may wait for a route before being dropped (#21 deliver-late vs discard trade). |
| `ReconvHoldCap` | `1 s` | Caps how long a reconvergence-held packet may wait (issue #21 lever L2, #103/#104). Bounded by `QueueTimeout`. |
| `RepairHoldCap` | `0 s` (disabled) | The same cap for repair-held packets. |
| `ReactiveRetryInterval` | `0.25 s` | Adapter-side re-flood timer for queued-but-routeless destinations (#21). **Not** `Config::reactiveRetryInterval` — see §3.3. |
| `MacServiceAlpha` | `0.7` | EWMA weight when smoothing the measured MAC service time. This is [1] §3.1's α (#70) — the paper value, matching the digest. |

## 4. Functional groups, and what each trades off

### Pheromone & goodness — `gamma`, `betaAnts`, `betaData`, `hopTimeSec`, `enableMacMetric`, `alpha`, `enableEvaporation`, `evaporationInterval`, `minPheromone`

This group *is* the routing metric. `hopTimeSec` and the β exponents are the
highest-leverage knobs in the whole config and the best-sourced: leave them at
the paper/thesis values unless you are deliberately running an ablation. `gamma`
sets adaptation speed — raise it for smoother pheromone in stable fields, lower
it to react faster under mobility, at the cost of oscillation. `betaData`
controls how single-path the data flow becomes: lowering it spreads load (and
reorders packets), raising it approaches deterministic best-path.

`alpha` + `evaporationInterval` are the aging pair, and are a *documented
extension*, not the spec (ADR-0012) — the honest ablation is
`enableEvaporation=false`, which gives the paper-faithful "running average +
explicit removal only" behaviour. Neither number has a source to calibrate
against — the thesis audit confirmed it has no evaporation term at all (§3.1,
#182) — so a sweep is the only thing that can justify them. `enableMacMetric=true` swaps the
per-hop cost to the paper's congestion-aware A2 formula; it is off by default
purely because no benchmark has yet justified flipping it.

### Reactive setup — `reactiveMaxBroadcasts`, `enableMultipath`, `antAcceptanceFactor`, `reactiveRetryInterval`, `maxPathLength`

How routes are discovered. `reactiveMaxBroadcasts` bounds how often **one
node** re-broadcasts **one generation** (default 2). Read its history before
touching it, because the same name has meant two different things:

- As a budget *carried on the ant* and decremented at each hop it was a **hop
  limit on discovery** — destinations beyond ~5 hops were never found (#169).
  Never reintroduce that form.
- As a per-node count it does not limit reach at all, and it is **required**:
  with multipath on, a reactive forward ant is admitted by the acceptance band
  *instead of* `(src,seq)` duplicate suppression, and the band admits rather
  than suppresses. Without the per-node count one discovery on a 7x7 grid cost
  30,090 ants and ns-3 `large-scale` fell to 21.7% PDR (#173).

Setting it to `-1` restores the unbounded behaviour and is a sensitivity
experiment, not a configuration.

`antAcceptanceFactor` is the multipath dial and its direction is
counter-intuitive: **higher admits more ant copies**, i.e. more paths and more
setup traffic. 1.0 still admits equal-metric copies, so no value gives you
single-path — that is what `enableMultipath=false` is for. Turning multipath off
also turns off the linkfail churn bound that ships with it; expect more LinkFail
volume (#96 round 1 lost 7.5 pp PDR without it).

**Read the sources before tuning this one**, because they do not agree and the
disagreement caused [#173](https://github.com/danieljoppi/AntHocNet/issues/173).
[1] §3.1 states a single factor of 1.5. The 2007 thesis parameterises the same
band as **`a1 = 0.9`** — "set quite low … in order to only allow the best ants
through and avoid too much proliferation" — plus a second, looser **`a2 = 2`**
applied *only* when an ant's **first hop** differs from previously accepted
ants, a disjointness rule this repo does not implement. At 0.9 the band admits
only ants better than the incumbent, so it tightens with each admission and is
self-limiting; at 1.5 it admits ants up to 50% worse, which in a dense graph is
nearly every neighbour's copy. That is why a discovery in a 7×7 grid cost 30,090
ants before the per-node bound landed.

The thesis then records that the authors **abandoned the mechanism entirely** —
"high levels of overhead were often experienced … we decided to restrict
reactive route setup to the creation of just one single route, and to rely on
proactive route maintenance to obtain multiple routes." So the shipped default
implements a design its own authors dropped, at a looser factor than they ever
ran, bounded by a mechanism this repo invented. #177 is measuring the three
options; treat this row as unsettled until it closes.

### Proactive & diffusion — `enableProactive`, `enableDiffusion`, `proactiveInterval`, `proactiveBroadcastProb`, `proactiveMaxBroadcasts`, `sessionTtl`

Path maintenance while a session runs. This group is the repo's largest
*mechanism-level* deviation from [1]: the paper emits one proactive ant per *n*
data packets, so its rate scales with offered load; the repo uses a fixed timer
([`fidelity.md`](fidelity.md) deviation 4). Consequence: at low CBR rates the
repo probes relatively *more*, at high rates relatively *less*, than the paper.
Keep that in mind before attributing an overhead difference to the algorithm.

`enableProactive=false` is the clean ablation (it also disables diffusion);
`enableDiffusion=false` alone keeps proactive ants but removes virtual
pheromone, so ants can no longer be guided toward destinations this node has
never reached. `proactiveBroadcastProb` and `proactiveInterval` both buy
adaptivity with control overhead — sweep them against NRL, not just PDR.

### Neighbour liveness & link failure — `helloInterval`, `allowedHelloLoss`, `txFailureThreshold`, `linkfailNotifyInterval`

Two independent detectors feed one `loseNeighbor` (ADR-0008): the hello timeout
(`helloInterval × allowedHelloLoss`, always on) and the adapter's MAC
transmit-failure fast path (`txFailureThreshold`, ns-3 `EnableMacFailureDetector`).
Both defaults for the hello pair come straight from [1] §3.3 fn.1.

Tightening detection (shorter hellos, fewer allowed losses, threshold 1) makes
the protocol jumpier: transient collisions get read as topology changes,
evicting valid routes and triggering rediscovery floods — precisely the failure
#19 debounced. `linkfailNotifyInterval` is the storm valve, sized by the #20
sweep; setting it to `0` restores spec behaviour and, under link flapping,
re-creates the ~98 %-of-linkfail-volume problem #20 documents.

### Repair — `repairWaitFactor`, `repairTimeout`, `repairMaxBroadcasts`

Local repair on link failure. `repairWaitFactor=5` and `repairMaxBroadcasts=2`
are both [1] §3.4 values; the trade is a straight latency-vs-loss dial — waiting
longer for a backward repair ant delivers more packets late, waiting less
discards them sooner and notifies neighbours earlier. On ns-3 this interacts
with the adapter's `QueueTimeout` / `ReconvHoldCap` (§3.4): the pending-queue cap
can expire a packet before the repair wait does, so sweep them together.

### Bounds & safety — `maxPathLength`, `maxHistory`, `networkDiameter`, `lifeAnt`

Golden rule 5 territory: these exist so a long simulation cannot grow a
structure without limit. They are not performance knobs and should not be tuned
for results. `maxPathLength` is pinned to the wire format
(`kMaxVisitedOnWire == 100`) — changing it is a wire-format change and requires
a `kWireVersion` bump plus both adapters (golden rule 4). `maxHistory` too small
aliases `(src,seq)` dedup and lets old ants back in. `networkDiameter` and
`lifeAnt` are currently inert (§3.3).

## 5. How to calibrate a parameter

The loop, in order. Every step has tooling; none of it involves reading a table
by eye.

**0. Preflight the scenario before spending a dispatch.** A misconfigured field
(partitioned, saturated, accidentally single-hop, too short) produces numbers
that look like a protocol result:

```bash
S=.claude/skills/benchmark-results/scenario_check.py
python3 $S preflight                              # paper base defaults
python3 $S preflight --areaX 2500 --flows 40      # exactly what you intend to dispatch
```

**1. Sweep one parameter at a time**, through the ns-3 attribute, via
`paper-benchmark.yml`'s `extraArgs` input (appended verbatim to the
`anthocnet-compare` command line):

```
--ns3::anthocnet::RoutingProtocol::HopTime=0.05
--ns3::anthocnet::RoutingProtocol::AntAcceptanceFactor=2.0
```

Pair **every** ON run with an identical OFF run — baselines are deterministic on
identical seeds, so an A/B pair is a clean comparison and a lone run is not. For
multi-point sweeps use `scenario-matrix.yml` (`only=<sweep> point=<x>` runs a
single point; `commit=true` writes the CSV into `docs/benchmarks/campaign/`).
Core-only parameters (`—` in §3.1) cannot be swept this way; they need a
`config.h` edit and a rebuilt image.

**2. Parse with a script, never by eye.**

```bash
D=.claude/skills/benchmark-results
python3 $D/bench_parse.py --ab off1.txt on1.txt off2.txt on2.txt   # the money mode
python3 $D/sweep_summary.py docs/benchmarks/campaign/*.csv         # campaign CSVs
```

`--ab` computes on-vs-off within each pair and flags **NOISE** when the PDR
deltas disagree in sign across pairs. Read the verdict, not the table
([ADR-0014](adr/0014-agent-skills-are-script-first.md): raw data stays out of
context).

**3. Validate the results before believing them.**

```bash
python3 .claude/skills/benchmark-results/scenario_check.py results cell.txt
python3 .claude/skills/benchmark-results/scenario_check.py results --anchor broch-low-mobility cell.txt
```

A FAIL is a harness regression (#51-class), not a protocol finding: do not
compare, publish or quote those numbers.

**4. The noise trap.** At `runs=5` a delta that looks material can sit entirely
inside run-to-run dispersion. `sweep_summary.py` marks this `~sd` (a material
PDR delta still inside 2·RSS of `pdr_sd`); `bench_parse.py --ab` calls it NOISE
when pairs disagree in sign. This is the exact trap hit in
[#47](https://github.com/danieljoppi/AntHocNet/issues/47) /
[#68](https://github.com/danieljoppi/AntHocNet/issues/68) /
[#71](https://github.com/danieljoppi/AntHocNet/issues/71): confirm with more
runs before concluding anything. Treat a single pair's verdict at fewer than 5
runs with suspicion.

**5. The golden rule.** A change to protocol behaviour needs an **A/B**, not a
plausibility argument. "This should be faster because…" is a hypothesis; the
`--ab` verdict is the evidence. Record the verdict and the run IDs on the
relevant issue ([ADR-0013](adr/0013-track-bugs-and-findings-as-issues.md)) so the
next session can recover the reasoning — that traceability is what made the
#88 and #169 corrections possible at all.

## 6. Validation anchors — check these before trusting any absolute number

Full detail in [`benchmarks/methodology.md`](benchmarks/methodology.md#validation-anchors-known-expected-results).
The short version, because it is the difference between a result and a bug:

- **Single-hop sanity** — ~10 nodes, all in range: PDR must be ≈ **100 %**.
- **Broch/Perkins low-mobility field** — 50 nodes, 1500×300 m, `pause=900`:
  stock **AODV ≈ 90 %** PDR (Broch et al., MobiCom 1998).

These are literature-known results, so a miss is a harness/PHY misconfiguration,
not a protocol property. [#51](https://github.com/danieljoppi/AntHocNet/issues/51)
is the cautionary tale: with no `RemoteStationManager` pinned, ns-3's default
`IdealWifiManager` alternated unicasts between a rate that delivered and one
that never did — **~50 % single-hop loss, inherited by every protocol**, silently
depressing every absolute number the project had ever measured. The floors now
live in [`ns3/tools/anchors.yml`](../ns3/tools/anchors.yml) and are enforced both
in CI ([#59](https://github.com/danieljoppi/AntHocNet/issues/59)) and locally by
`scenario_check.py results --anchor …`, which reads that file rather than
duplicating it.

Relative comparisons on identical per-protocol realisations stay valid even when
the anchors are off; absolute numbers do not.

## 7. Determinism

Golden rule 3: **all randomness through `IRng`, all time through `IClock`.** The
consequence that matters for calibration is that **the same seed must produce
byte-identical results**. If re-running a sweep point with the same parameters
gives different numbers, that is a **bug** — a stray `rand()`, an uninjected
wall-clock read, or unordered-container iteration feeding a routing decision —
**not** noise to be averaged away.

[`ns3/tools/check-determinism.sh`](../ns3/tools/check-determinism.sh) runs a small
scenario twice and diffs the per-protocol metric rows; it is a blocking CI gate
([#129](https://github.com/danieljoppi/AntHocNet/issues/129)). Every relative
comparison in the benchmark pages is made on identical per-protocol
realisations, so a determinism break invalidates all of them at once.

## 8. Adding or extending a parameter

The checklist that would have prevented #88 and #169:

1. **Core field first**, in [`config.h`](../core/include/anthocnet/core/config.h),
   with a doc comment that **cites its source** in the §3 vocabulary — `[1] §x`,
   thesis, the ADR, or the issue whose sweep chose it. If there is no source,
   write that: *"provisional, no source"* is a maintainable comment;
   a bare number is not. Cite the digest's section numbering, not a remembered
   one (§3.3).
2. **Ask what the parameter *is*.** #169's lesson: a "budget" that is spent once
   per hop is a hop limit. Write down the mechanism the number bounds, not just
   the number.
3. **ns-3 attribute** in
   [`anthocnet-routing-protocol.cc`](../ns3/model/anthocnet-routing-protocol.cc) —
   an `AddAttribute` block *and* the corresponding `m_config.<field> = m_<attr>;`
   assignment (there are two such blocks, one per construction path; miss one and
   the attribute silently does nothing). The description string is user-facing
   documentation: put the source in it.
4. **NS-2 bind** in [`ahn_router.cc`](../ns2/src/ahn_router.cc) if the parameter
   is meaningful there — a member, a `bind()`/`bind_bool()` call, and the
   `config_.<field> = …` line in `startProtocol()`.
5. **A core test** in `core/tests/` (golden rule 7) that pins the *behaviour* the
   parameter controls, not merely that the field round-trips.
6. **Docs**: a row in §3.1 of this file, plus
   [`fidelity.md`](fidelity.md) if it is a deviation from [1], plus the digest
   table if it corresponds to a paper parameter.
7. **Wire format**: if the parameter changes what goes on the wire or the units
   of an existing field, golden rule 4 applies — bump `kWireVersion` and update
   the codec, both adapters, the round-trip tests and
   [`wire-format.md`](wire-format.md).

### Adding a link metric instead of a parameter

If what you actually want is a different *goodness formula*, do not add a
boolean to `Config` and branch inside the state machine. `ILinkMetric`
([`link_metric.h`](../core/include/anthocnet/core/link_metric.h)) is the strategy
seam that turns a backward ant's `LinkObservation` into a pheromone value, and
[`link_metric_registry.h`](../core/include/anthocnet/core/link_metric_registry.h)
([#143](https://github.com/danieljoppi/AntHocNet/issues/143)) resolves one by
name. Register a new metric there and select it; `AntRouterLogic` does not
change. The default (`kClassic`) is the Eq.2 formula from [1] §3.1.

---

**Related:** [`fidelity.md`](fidelity.md) ·
[paper digest](publications/papers/2004-ppsn-anthocnet.md) ·
[`benchmarks.md`](benchmarks.md) ·
[`architecture.md`](architecture.md) ·
[`adr/`](adr/) · [`AGENTS.md`](../AGENTS.md) · [`CONTEXT.md`](../CONTEXT.md)
