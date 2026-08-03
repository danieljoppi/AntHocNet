# Roadmap

The plan in one page. The authoritative, living version is
[#298](https://github.com/danieljoppi/AntHocNet/issues/298) — it carries the
literature gap analysis the epics came from, and issue state is always truer
than a checked-in diagram. This page exists because the *ordering constraints*
are the part that is hard to hold in your head, and a graph shows them better
than prose.

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

    SATBUILD["satellite build epics<br/>#192 #193 #194 #195 #196<br/>#208 #210 #211"]
    ENABLE["enablers<br/>#121 affordability · #126 seed-splitting"]

    ENABLE --> E293
    F179 & F180 -.->|"change protocol character —<br/>re-baseline once, not twice"| E295
    E293 --> E294 --> E295 --> E296
    E295 --> E300 --> E301
    E296 -.->|"oracle control"| E297
    SATBUILD --> E297
    E293 --> E302
    F179 & F180 -.-> E302
    E300 -.->|"high-churn cell for<br/>trust evidence"| E302

    style E293 fill:#e2f0ed,stroke:#0f7f70,stroke-width:2px
    style E297 fill:#e8e6f8,stroke:#5b4fc4,stroke-width:2px
    style E302 fill:#f6dede,stroke:#c0392b,stroke-width:2px
    style FID fill:#fff8e6,stroke:#c48f00
```

**The one sequencing rule worth memorising:** the fidelity fixes (#179, #180)
change the protocol's character, so they must land *before* v1.4.0's expensive
realism campaigns — otherwise every published grid is measured twice. They are
otherwise independent of the epic chain.

## What each release must show to ship

| Release | Exit criteria |
|---|---|
| **v1.3.0** | Every published table carries a 95 % CI; `bench_parse --ab` reports paired-difference verdicts; runs-floor and warm-up policy documented. |
| **v1.4.0** | Headline grid under ≥2 mobility × ≥2 channel models with a ranking-stability statement; TCP arm; a published 200-node point. |
| **v1.5.0** | Oracle control in both suites; AOMDV and GPSR spikes resolved (working arm **or** a written infeasibility verdict with threat-to-validity text). |
| **v1.6.0** | README family table shows ≥4 supported families, each with a results page, plus a cross-family ranking-stability statement. |
| **v2.0.0** | A committed time-varying Walker result: scheduled handovers, failure overlay, oracle + geographic comparators, handover metric family, calibration deltas vs Hypatia/LENS. |
| **v3.0.0** | Four-protocol vulnerability table under blackhole/grayhole; defense profile recovering PDR under attack while reading **NOISE** in benign scenarios; `EnableSecurity=false` path proven byte-identical. |

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
