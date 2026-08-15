# Roadmap

The plan in one page. The authoritative, living version is
[#298](https://github.com/danieljoppi/AntHocNet/issues/298) — it carries the
literature gap analysis the epics came from, and issue state is always truer
than a checked-in diagram. This page exists because the *ordering constraints*
are the part that is hard to hold in your head, and a graph shows them better
than prose.

## How this plan is tracked

Each roadmap issue carries a **`release:` label**, so every column of this plan
is a live query rather than a diagram that drifts:

| Release | Board |
|---|---|
| v1.3.0 | [`release:v1.3.0`](https://github.com/danieljoppi/AntHocNet/issues?q=is%3Aopen+label%3A%22release%3Av1.3.0%22) |
| v1.4.0 | [`release:v1.4.0`](https://github.com/danieljoppi/AntHocNet/issues?q=is%3Aopen+label%3A%22release%3Av1.4.0%22) |
| v1.5.0 | [`release:v1.5.0`](https://github.com/danieljoppi/AntHocNet/issues?q=is%3Aopen+label%3A%22release%3Av1.5.0%22) |
| v1.6.0 | [`release:v1.6.0`](https://github.com/danieljoppi/AntHocNet/issues?q=is%3Aopen+label%3A%22release%3Av1.6.0%22) |
| v2.0.0 | [`release:v2.0.0`](https://github.com/danieljoppi/AntHocNet/issues?q=is%3Aopen+label%3A%22release%3Av2.0.0%22) |
| v3.0.0 | [`release:v3.0.0`](https://github.com/danieljoppi/AntHocNet/issues?q=is%3Aopen+label%3A%22release%3Av3.0.0%22) |
| all epics | [`epic`](https://github.com/danieljoppi/AntHocNet/issues?q=is%3Aopen+label%3Aepic) |

Labels, not milestones or a Projects board, because a label is visible in every
issue list and search without leaving the issues view, and because it survives
being edited by anyone with write access rather than needing project-level
permissions. A Projects v2 board over the same labels is a strict addition if
one is ever wanted — it would read these labels, not replace them.

Only issues the ladder actually gates are labelled. Most of the ~90 open issues
are unscheduled work that lands whenever it lands; putting a `release:` on
everything would make the query useless.

## Release ladder

```mermaid
flowchart LR
    V13["<b>v1.3.0</b><br/>every number<br/>carries a CI"]
    V14["<b>v1.4.0</b><br/>off the<br/>perfect disk"]
    V15["<b>v1.5.0</b><br/>credible<br/>baselines"]
    V16["<b>v1.6.0</b><br/>the family<br/>axis"]
    V20["<b>v2.0.0</b><br/>the constellation<br/>actually moves"]
    V30["<b>v3.0.0</b><br/>secured<br/>AntHocNet"]

    V13 --> V14 --> V15 --> V16 --> V20 --> V30

    style V13 fill:#e2f0ed,stroke:#0f7f70,stroke-width:2px
    style V20 fill:#e8e6f8,stroke:#5b4fc4,stroke-width:2px
    style V30 fill:#f6dede,stroke:#c0392b,stroke-width:2px
```

The order is not arbitrary — statistics come first because every later claim is
quoted with a confidence interval, and realism comes before baselines because
adding a baseline to a scenario set you are about to change means measuring
twice.

## Epics and what blocks what

Solid arrows are hard dependencies; dashed are "derisks / informs".

```mermaid
flowchart TB
    subgraph FID["Protocol fidelity — orthogonal, land early"]
        F179["#179 pheromone exponents<br/>(thesis says 20, we ship 1.0/2.0)"]
        F180["#180 proactive rate + emission gate"]
    end

    E293["<b>#293</b> statistics<br/>95% CIs · paired tests · warm-up"]
    E294["<b>#294</b> metrics<br/>AoI · p95/CDF · energy-per-bit · route stability"]
    E295["<b>#295</b> realism<br/>mobility · fading · PHY · TCP · scale"]
    E296["<b>#296</b> baselines<br/>oracle · AOMDV · GPSR"]
    E300["<b>#300</b> FANET"]
    E301["<b>#301</b> VANET"]
    E297["<b>#297</b> satellite credibility<br/>handover metrics · calibration"]
    E302["<b>#302</b> security<br/>default-off profile"]
    E307["<b>#307</b> remove NS-2<br/>frozen at v1.2.0, removed at v2.0.0"]
    E32["<b>#32</b> OMNeT++/INET adapter<br/>the Veins entry ticket"]

    SATBUILD["satellite build epics<br/>#192 #193 #194 #195 #196<br/>#208 #210 #211"]
    ENABLE["enablers<br/>#121 affordability · #126 seed-splitting"]
    I309["<b>#309</b> hold-cap sweep<br/>900 s · 20 seeds · CIs"]
    E308["<b>#308</b> close the delay tail<br/>#21 confirmed at 12x the interval"]

    ENABLE --> E293
    E293 --> I309
    I309 --> E308
    F179 & F180 -.->|"both move which path<br/>data takes"| E308
    F179 & F180 -.->|"change protocol character —<br/>re-baseline once, not twice"| E295
    E293 --> E294 --> E295 --> E296
    E295 --> E300 --> E301
    E296 -.->|"oracle control"| E297
    SATBUILD --> E297
    E293 --> E302
    F179 & F180 -.-> E302
    E307 -.->|"lands with the v2.0.0 major —<br/>dropping a platform is breaking"| E297
    E32 -->|"Veins is the de-facto<br/>VANET stack"| E301
    E300 -.->|"high-churn cell for<br/>trust evidence"| E302

    style E293 fill:#e2f0ed,stroke:#0f7f70,stroke-width:2px
    style E297 fill:#e8e6f8,stroke:#5b4fc4,stroke-width:2px
    style E302 fill:#f6dede,stroke:#c0392b,stroke-width:2px
    style E307 fill:#eee,stroke:#888,stroke-dasharray:4 3
    style E32 fill:#eaf2fb,stroke:#2c6fbb,stroke-width:2px
    style E308 fill:#fde9e9,stroke:#c0392b,stroke-width:2px
    style FID fill:#fff8e6,stroke:#c48f00
```

**The one sequencing rule worth memorising:** the fidelity fixes (#179, #180)
change the protocol's character, so they must land *before* v1.4.0's expensive
realism campaigns — otherwise every published grid is measured twice. They are
otherwise independent of the epic chain.

## What each release must show to ship

| Release | Exit criteria |
|---|---|
| **v1.3.0** | Every published table carries a 95 % CI — **met**: headline ([#110](https://github.com/danieljoppi/AntHocNet/issues/110)), hold-cap ([#309](https://github.com/danieljoppi/AntHocNet/issues/309)) and the pause/area/scale sweeps are all 20-seed with intervals, and the per-merge taxonomy runs at the 10-run floor ([#318](https://github.com/danieljoppi/AntHocNet/issues/318)); `bench_parse --ab` reports paired-difference CIs + Wilcoxon; runs-floor, CI-method-per-metric and warm-up policy documented in [methodology.md](benchmarks/methodology.md#statistical-policy-293). **Shipped** — tag cut 2026-08-04; [#110](https://github.com/danieljoppi/AntHocNet/issues/110), [#121](https://github.com/danieljoppi/AntHocNet/issues/121) and [#293](https://github.com/danieljoppi/AntHocNet/issues/293) closed with it. `v1.3.0` is also the **provenance pin for the whole published corpus** — see [Provenance](benchmarks/methodology.md#provenance-which-version-a-number-was-measured-at). |
| **v1.4.0** | Headline grid under ≥2 mobility × ≥2 channel models with a ranking-stability statement; TCP arm; a published 200-node point. **Plus a verdict on the delay tail** ([#308](https://github.com/danieljoppi/AntHocNet/issues/308)) — either a measured statement that it is the price of the delivery advantage, or a change that reduces it.<br/>**Status:** 200-node point ✅ (published as `scale` f = 2.0, [#110](https://github.com/danieljoppi/AntHocNet/issues/110)). Delay-tail verdict ✅ — the [#308 hold-cap ablation](https://github.com/danieljoppi/AntHocNet/issues/308#issuecomment-5211529535) shows causally, at 20 seeds with AODV byte-identical across arms, that the tail and the delivery advantage are one mechanism; it also found the 1 s default is not on the efficient frontier ([#371](https://github.com/danieljoppi/AntHocNet/issues/371)). Grid ✅ — [six cells](https://github.com/danieljoppi/AntHocNet/issues/295#issuecomment-5225587376) at 20 seeds, {`rwp`, `ssrwp`, `gaussmarkov`} × {`tworay`, `nakagami`} ([#61](https://github.com/danieljoppi/AntHocNet/issues/61), [#60](https://github.com/danieljoppi/AntHocNet/issues/60)). **Ranking-stability statement, scoped:** the *delivery* and *overhead* rankings are stable in every cell (ΔPDR +11.0…+22.1 pp, ΔNRL −26.9…−30.1, all intervals disjoint, all p ≤ 9.6e-05) — but the ***tail* ranking inverts with the channel**: OLSR holds the best `delay99` under two-ray (22–69 ms) and the **worst** under fading (2685–2961 ms), while AntHocNet moves from 4th to 2nd. A tail claim that does not name its channel is unsupported. TCP arm ✅ **published** ([tcp.md](benchmarks/tcp.md), [#391](https://github.com/danieljoppi/AntHocNet/issues/391)) — 20 seeds at `0b42c89`, same-commit UDP control reproducing the published `rwp × tworay` cell exactly (all 80 per-seed rows field-for-field): AntHocNet leads goodput (+319.2 kbps over AODV, 95 % CI [+256.4, +382.1], 20/20 seeds, p = 1.9 × 10⁻⁶) but **ties OLSR** (+10.1, p = 0.43), and **the TCP ranking reorders the UDP one** — AODV falls from 3rd to last, DSDV rises past it. A transport claim that does not name its transport is unsupported; the published delivery ordering is a UDP/CBR ordering. Instrumentation for that arm ✅ — [#389](https://github.com/danieljoppi/AntHocNet/issues/389) widened the data-packet predicate so `drop_mac`/`drop_chan` and the route-quality family stop reading structurally zero under TCP, [confirmed by a pre-registered A/B](https://github.com/danieljoppi/AntHocNet/issues/389#issuecomment-5232649715) (UDP arm byte-identical; TCP drop-cause `sum` 93.3–96.0 → 97.2–100.0).<br/>**Shipped** — tag cut 2026-08-09 ([release v1.4.0](https://github.com/danieljoppi/AntHocNet/releases/tag/v1.4.0), install bundle + checksums published; the version DOI awaits the manual Zenodo backfill into `CITATION.cff`). All exit criteria met; closeout decisions recorded 2026-08-09. The delay-tail verdict closed [#308](https://github.com/danieljoppi/AntHocNet/issues/308)/[#21](https://github.com/danieljoppi/AntHocNet/issues/21) — the tail is the price of the delivery advantage, one mechanism, causally shown — and v1.4.0 ships at the 1 s `ReconvHoldCap` (delivery-biased end of the measured frontier; the 200 ms default change [scheduled into the v1.5.0 re-baseline](https://github.com/danieljoppi/AntHocNet/issues/371#issuecomment-5233019767) has since landed as the [#371](https://github.com/danieljoppi/AntHocNet/issues/371) flip, and the operating point is documented in [configuration.md](configuration.md)). [#365](https://github.com/danieljoppi/AntHocNet/issues/365) closed by accepting the version pins. The fading drop-attribution pair ([#386](https://github.com/danieljoppi/AntHocNet/issues/386)/[#377](https://github.com/danieljoppi/AntHocNet/issues/377)) moved to `v1.5.0` — not in the exit criteria, and the columns it concerns are withheld from every published table, so no wrong number ships. |
| **v1.5.0** | Oracle control in both suites; AOMDV and GPSR spikes resolved (working arm **or** a written infeasibility verdict with threat-to-validity text).<br/>**Plan:** four workstreams want the same cells at defaults that are themselves changing — the [#371](https://github.com/danieljoppi/AntHocNet/issues/371) hold-cap flip, the [#386](https://github.com/danieljoppi/AntHocNet/issues/386) re-injection cap sweep, its publishable detector A/B, and [#296](https://github.com/danieljoppi/AntHocNet/issues/296)'s oracle arm. [`v1.5.0-campaign.md`](benchmarks/v1.5.0-campaign.md) sequences them into **one** campaign (flip → re-baseline → cap×detector → oracle) so nothing is measured twice at three different configurations — the [#365](https://github.com/danieljoppi/AntHocNet/issues/365) failure, avoided prospectively. **All phases complete (2026-08-15).** Phase 0: [#402](https://github.com/danieljoppi/AntHocNet/issues/402) landed ([#407](https://github.com/danieljoppi/AntHocNet/pull/407)). Phase 1: the flip merged as [#411](https://github.com/danieljoppi/AntHocNet/pull/411) (`a1daa7a`) and the six-cell grid is [re-baselined and republished](benchmarks/grid.md) at the 200 ms default with baselines byte-identical to the v1.4.0 corpus ([#371 readout](https://github.com/danieljoppi/AntHocNet/issues/371#issuecomment-5273092510)). Phase 2: the cap × detector sweep ran at 20 seeds and is [published](benchmarks/reinjection.md) — the detector A/B confirms **+5.55/+6.54 pp PDR**, the duplicate rate is **65–67 %** by direct measurement, and neither pre-registered auto-criterion fired, so `MaxReinjectPerPacket` stays unlimited ([#386 readout](https://github.com/danieljoppi/AntHocNet/issues/386#issuecomment-5279088201)). Phase 3: the oracle control is [measured in both suites](benchmarks/grid.md) — **100 % of AntHocNet's two-ray PDR shortfall is routing rather than channel** (95.5–95.8 % under fading), and the exact `approx=0` [ISL torus](benchmarks/satellite/isl-grid.md) shows every arm already at the bound there ([#415 readout](https://github.com/danieljoppi/AntHocNet/issues/415#issuecomment-5297098438)). **Exit criteria — one outstanding.** The oracle runs in both suites ✅ and AOMDV ended in a written infeasibility verdict with threat-to-validity text ✅ ([#414](https://github.com/danieljoppi/AntHocNet/pull/414), [methodology](benchmarks/methodology.md)). **GPSR is neither** ❌: [#412](https://github.com/danieljoppi/AntHocNet/pull/412) merged it on a green five-version matrix + ASan, but its first measurement — dispatched only after the campaign, because phase 3's protocol list never included it — puts it at **0.00 % PDR on 40/40 seeds** with the `aodv` control byte-identical to the corpus, so the fault is in the module ([#425](https://github.com/danieljoppi/AntHocNet/issues/425)). The criterion admits "working arm **or** a written infeasibility verdict"; GPSR has neither yet, so the release is held pending the maintainer's choice between shipping a second documented verdict or fixing the arm. This is [#414](https://github.com/danieljoppi/AntHocNet/pull/414)'s lesson recurring in the very arm whose risk note cited it — hence the standing rule now recorded in [methodology.md](benchmarks/methodology.md): **no baseline merges without a smoke run showing non-zero delivery and a drop book that closes.** |
| **v1.6.0** | README family table shows ≥4 supported families, each with a results page, plus a cross-family ranking-stability statement. **Plus the OMNeT++/INET adapter** ([#32](https://github.com/danieljoppi/AntHocNet/issues/32)) — VANET evaluation runs on Veins, so the adapter is what makes #301 a real arm rather than an ns-3 approximation of one. |
| **v2.0.0** | A committed time-varying Walker result: scheduled handovers, failure overlay, oracle + geographic comparators, handover metric family, calibration deltas vs Hypatia/LENS. **Also the NS-2 removal** ([#307](https://github.com/danieljoppi/AntHocNet/issues/307)) — dropping a supported platform is breaking, so it lands with a major. |
| **v3.0.0** | Four-protocol vulnerability table under blackhole/grayhole; defense profile recovering PDR under attack while reading **NOISE** in benign scenarios; `EnableSecurity=false` path proven byte-identical. |

## Platform support

**NS-2 is being retired.** `v1.2.0` is the **last release in which NS-2 was
actively supported** ([#307](https://github.com/danieljoppi/AntHocNet/issues/307)):
the adapter is frozen — no new NS-2 work lands — but it still ships through the
rest of the `v1.x` line, and the **removal itself lands at v2.0.0** (dropping a
platform is breaking, so it needs a major). Anyone who needs NS-2 should pin the `v1.2.0` tag or its
immutable images (`ghcr.io/danieljoppi/anthocnet-ns2:2.34-v1.2.0` /
`:2.35-v1.2.0`) — already-published tags are not withdrawn, and v1.2.0 stays
citable at its version DOI.

The reasoning is in #307; the short version is that NS-2 is the only target
requiring edits inside the simulator's own tree, it never got a benchmark
harness (#25), and contemporary reviewers read NS-2 in a 2026 paper as a
reproducibility red flag rather than a credential.

What this does **not** change: the simulator-agnostic core, the ports seam, and
the "no NS headers in `core/`" golden rule all stay.

### Why OMNeT++ (#32) is scheduled at v1.6.0, not v2.0.0

The obvious reason to build a second adapter is to keep proving the core is
simulator-agnostic once NS-2 is gone. That reason is **weaker than it looks**:
`v1.2.0` is tagged, immutable and DOI-pinned, so the two-adapter demonstration
stays permanently citable after removal. Nobody can claim the seam was never
exercised — they can check out the tag and exercise it.

The reason that does hold up is **audience**. VANET evaluation happens on
Veins (OMNeT++ + SUMO); it is the de-facto stack for the family, and ns-3 has
no equal-status counterpart. OMNeT++/INET is also co-dominant with ns-3 in
contemporary MANET protocol comparisons. So the adapter is not overhead paid
to defend an architectural claim — it is the entry ticket to the VANET epic
([#301](https://github.com/danieljoppi/AntHocNet/issues/301)), which is why it
is scheduled with the family axis at **v1.6.0** rather than alongside the NS-2
removal at v2.0.0.

Satellite is the counter-case and the reason not to schedule it any earlier:
LEO/constellation work is overwhelmingly ns-3 (Hypatia, ns-3-leo), so #297
gains nothing from an OMNeT++ adapter.

**Honest caveat on the usage claim.** No bibliometric study we found reports
2024–2026 simulator shares for this field, so "co-dominant" and "de-facto" are
judgements from the recent MANET/VANET evaluation literature and from which
toolchains those papers actually run on — not measured percentages. They
should not be quoted as statistics in a publication.

## Deliberate non-goals

Recorded with the reasoning that would reverse each — see the rationale comment
on [#298](https://github.com/danieljoppi/AntHocNet/issues/298). Briefly: a DRL
baseline is *planned but gated* (a leaky comparison would damage credibility);
Sionna RT ray tracing is an upgrade path, not a goal; WSN/IoT (RPL's problem),
DTN store-carry-forward (a capability the protocol structurally lacks), and
NR-V2X sidelink (a different L2/PHY stack) are out.

Security was a non-goal and was **reversed** by converting the objection into a
design constraint ([ADR-0020](adr/0020-security-is-a-default-off-profile.md)) —
that is the template for revisiting any of the others.

## See also

- [#298](https://github.com/danieljoppi/AntHocNet/issues/298) — the roadmap issue: gap analysis, the three literature surveys, live status.
- [ADR-0019](adr/0019-network-families-change-the-evaluation-not-the-protocol.md) — why family support is scenario work, never per-family protocol defaults.
- [ADR-0020](adr/0020-security-is-a-default-off-profile.md) — why security is a default-off profile rather than a fork.
- [`network-regimes.md`](network-regimes.md) · [`software-layers.md`](software-layers.md) · [`ant-types.md`](ant-types.md) — the regime and mechanism references the epics build on.
