# ADR-0022: The satellite substrate is stock ns-3.48's LEO model

- **Status:** Accepted
- **Date:** 2026-10-08
- **Decides:** [#193](https://github.com/danieljoppi/AntHocNet/issues/193)
  (substrate spike set). **Refines** [ADR-0015](0015-satellite-substrate-lives-in-the-image.md)
  on one point: with a substrate that ships *inside* ns-3, the substrate image
  is the existing `ns3:3.48` image — no new image target.

## Context

The satellite track ([#192](https://github.com/danieljoppi/AntHocNet/issues/192))
needed a platform on which AntHocNet could route a **moving** constellation.
#193 set seven selection criteria (version distance from the CI matrix;
whether a third-party `Ipv4RoutingProtocol` can be installed; real ISL net
devices; licence/maintenance/containerisability; node-count ceiling; effort to
one routed packet; and — added by the #202 survey — whether the base is
**current and reproducible** enough to carry an *evaluation* claim).

The candidates were ns3-leo (#198), Hypatia (#197), SNS3 (#199), roll-your-own
SGP4 (#200), a non-ns-3 simulator (#201), and, after the #202 source check,
Silva's `ns3-satellite` mobility model. On 2026-08-03 the #298 roadmap research
added a fourth ns-3 option: **ns-3.48 (June 2026) ships a LEO constellation
mobility model in stock ns-3.**

What the stock model is, verified against the ns-3.48 source tree
(`src/mobility/model/`, `src/mobility/helper/`):

- `LeoCircularOrbitMobilityModel` — circular orbits from altitude and
  inclination, spherical Earth, Earth-rotation offset applied; positions in
  ECEF via `GetGeocentricPosition()`.
- `LeoOrbitalShell` + `LeoCircularOrbitPositionAllocator` +
  `LeoOrbitNodeHelper` — Walker-delta / Walker-star shells from
  `altitude,inclination,planes,sats[,phasing,raanSpan]`.
- `GeocentricConstantPositionMobilityModel` — ground stations at geodetic
  coordinates.
- Its headers carry **Tim Schubert's authorship** (ported to mainline by
  Thiago Miyazaki): this *is* ns3-leo's mobility layer, upstreamed. GPL-2.0-only,
  the same licence as this repository.

## Decision

**Build the satellite track on stock ns-3.48's LEO mobility model, with our
own link layer in the example harness.**

1. **Mobility:** `LeoCircularOrbitMobilityModel` via `LeoOrbitNodeHelper`.
   Nothing vendored, nothing patched; the version is pinned by the ns-3 release
   like every other model we cite.
2. **Links:** stock net devices driven by the harness —
   `PointToPoint` ISLs in a +grid whose `Delay` attribute is re-read from the
   satellites' ECEF distance every `--delayUpdate` s; ground-satellite links as
   one `Csma` segment per ground station holding every satellite ever visible
   from it, with only the serving satellite's interface up. This is the #210
   / #211 scope delivered as *example code* (`ns3/examples/leo-walker.cc`), not
   as a module.
3. **Version:** satellite runs and their CI smoke are **ns-3.48 only**
   (ADR-0015 point 3 — one version, not the matrix). The example is guarded at
   configure time on the stock header, so the 3.36–3.47 legs skip it silently
   rather than fail.
4. **Control:** the precomputed shortest-path control (#196) is the existing
   `oracle` module, extended with `Metric=delay` (Dijkstra on current channel
   delays, re-solved every recompute) — the Hypatia-style precomputed
   forwarding #197 was going to supply.

## Why this option, criterion by criterion

| #193 criterion | stock ns-3.48 LEO |
|---|---|
| 1. distance from CI matrix | zero — 3.48 is already a matrix leg and a published image (`ghcr.io/danieljoppi/ns3:3.48`) |
| 2. third-party routing installable | yes — nodes are ordinary `Node`s with `InternetStack`; AntHocNet, AODV, OLSR and the oracle all install unchanged |
| 3. ISLs as real net devices, per-interface subnets | yes — we build them (p2p, one /30 per ISL), the shape #203 fixed and #214 already exercised |
| 4. licence / maintenance / container | GPL-2.0-only; maintained by ns-3 releases; ships in the image we already build |
| 5. node-count ceiling | 576 satellites (24×24) ran in ~15 s for two arms over 60 s; OLSR is the practical limit there, not the substrate |
| 6. effort to one routed packet | done — `leo-walker` delivers end-to-end ground-to-ground traffic under every arm |
| 7. current and reproducible | the strongest possible answer: mainline ns-3, current release, rebuilt from the same recipe as every other result here |

## Rejected options, and why (so nobody re-evaluates them)

- **ns3-leo (#198)** — *subsumed, not rejected.* Its mobility layer is now
  upstream; using the upstream copy gets the same model with release pinning
  and no third-party tree. Its out-of-tree ISL/GSL devices are not needed: stock
  p2p/CSMA devices with harness-driven delay and up/down state answer the
  routing question, which is about topology and delay, not PHY.
- **Hypatia (#197)** — pinned to an old ns-3 base (fails criterion 7), and its
  forwarding is precomputed by design — it is the *control*, not the substrate.
  The control is the `oracle` `Metric=delay` mode above. Its published
  Starlink-class RTTs remain useful as an external **calibration** reference
  (#297 item 4).
- **SNS3 (#199)** — GEO bent-pipe, DVB-S2/RCS2: one hop, nothing to route. The
  expected reject, confirmed by the Manzanares-Lopez et al. review
  (*Software: Practice & Experience*, 2025, doi 10.1002/spe.70001).
- **Roll-your-own SGP4 (#200)** — circular Walker shells are what the routing
  question needs (the Starlink shells are near-circular); SGP4/TLE adds
  real-satellite fidelity the claim does not depend on, at the cost of code we
  would own. If TLE-driven runs are ever wanted, `GeocentricEcefMobilityModel`
  is the stock hook.
- **Non-ns-3 simulators (#201)** — would require a third adapter for the
  *evaluation* (ADR-0002) and forfeit comparability with every MANET, FANET and
  VANET number this repo has published. No candidate offered a property that
  outweighs that.
- **Silva's `ns3-satellite`** — the mobility layer under Hypatia; same old-base
  problem, and the stock model now covers the same ground.
- **Our own module (#195)** — the gate on that epic was "only if nothing
  existing fits". Something does.

## Consequences

- No satellite image target is needed: ADR-0015's substrate dimension collapses
  to "the 3.48 image". #234/#235 (unpublished spike image, then a published
  `ns3-sat` image) are superseded; the satellite CI smoke runs in the existing
  3.48 leg.
- Satellite results are **3.48-only** and say so. If a later ns-3 release
  changes the LEO model, the release-notes check that already gates a matrix
  bump covers it.
- The model is circular-orbit, spherical-Earth. Satellite results are claims
  about routing over Walker-shell geometry and delay, never about orbital
  precision or RF — `leo-walker`'s geometry anchors (shell radius, in-plane
  chord, orbital period against `2π√(a³/μ)`) check exactly that much.
- The harness owns link behaviour (delay updates, GSL handover, failure
  overlay). That code lives in one example and is covered by its CI smoke and
  the scenario_check rules, not by a module test suite.
