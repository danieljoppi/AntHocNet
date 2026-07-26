# ADR-0015: One AntHocNet build; the satellite substrate lives in the image

- **Status:** Accepted
- **Date:** 2026-07-26

## Context

The satellite-networking track ([#192](https://github.com/danieljoppi/AntHocNet/issues/192))
needs AntHocNet to run on satellite topologies. Two questions followed, and they
look like one question but are not:

1. Do we need **different builds of AntHocNet** for MANET and satellite work?
2. Do we need **different container images**?

The relevant facts:

- A satellite substrate (ns3-leo, Hypatia, Silva's `ns3-satellite` mobility
  model — the candidates in [#193](https://github.com/danieljoppi/AntHocNet/issues/193))
  is a **third-party ns-3 module that must be present in the ns-3 tree**. It is
  not a dependency of our module; it is part of the simulator installation.
- Those substrates support **narrower ns-3 version ranges** than our CI matrix
  (`3.36`–`3.48`). Hypatia in particular is pinned to an older base.
- The ns-3 image builds are already the long pole in CI — the `3.36` leg alone
  is ~8 minutes.
- Against that, **nothing in the AntHocNet module is satellite-specific.**
  `core/` is one algorithm (ADR-0002); the ns-3 adapter is one
  `Ipv4RoutingProtocol`. The multi-interface fix
  ([#203](https://github.com/danieljoppi/AntHocNet/issues/203)) made the data
  path correct for *any* topology rather than adding a satellite mode, and
  `isl-grid` ([#214](https://github.com/danieljoppi/AntHocNet/issues/214)) is an
  **example**, not a build variant. The only genuine difference between the two
  regimes is *which ns-3 modules are enabled* — `point-to-point` for ISLs,
  `wifi;mobility` for MANET — and both are enabled by a single existing
  configure line today.

## Decision

**Split the image, not the build.**

1. **One AntHocNet build.** There is no MANET build and no satellite build.
   The module compiles once, from one source tree, with one configure line.
   Scenario differences are expressed as *examples and command-line options*
   (`anthocnet-compare` vs `isl-grid`, `--scenario=`, `--protocols=`), never as
   build variants or preprocessor modes.
2. **The substrate is an image concern.** A satellite substrate is installed
   into the ns-3 tree by the image that provides it, as an additional
   `Dockerfile.ns3` target alongside the existing `base` / `anthocnet` stages
   and the `NS3_PROFILE` axis — not vendored into this repository and not added
   to the default images.
3. **Satellite CI runs on one ns-3 version**, in the manner of the existing
   validation-anchor and determinism gates (3.42 only), not across the full
   matrix.
4. **The substrate choice is not baked in before it is made.** Until
   [#193](https://github.com/danieljoppi/AntHocNet/issues/193) concludes, the
   satellite image target is a *parameterised, unpublished* build used to answer
   the substrate spikes. Only the winner gets a published tag.

## Why not separate builds

Two builds drift. The moment a satellite binary is configured differently from
the MANET one, a satellite result and a MANET result stop being comparable — and
the ability to compare them is the reason this repo has a simulator-agnostic
core at all (ADR-0002). The failure would also be quiet: both builds keep
working, the numbers just stop meaning the same thing. That is the same class of
defect as the `#173` "same field, new meaning" trap and the `#19`/`#51`
harness-versus-algorithm confusion, and it is avoided here for free by not
creating the axis.

The stated motivation for splitting — "satellite needs different modules" — is
satisfied entirely by ns-3's `--enable-modules` list, which already names both
sets.

## Consequences

- A satellite topology and a MANET topology are exercised by **the same binary**,
  so a regression in one is visible in the other. `isl-grid`'s CI smoke already
  demonstrates this: it runs on every matrix leg from the ordinary build.
- The image catalogue gains a dimension (substrate) on top of version and build
  profile. That is a real cost in `images.yml` and in `docker/README.md`, and it
  is the cost this ADR accepts in exchange for not splitting the build.
- Anyone reproducing a satellite result needs the substrate image, not a special
  branch or build flag — which keeps reproduction instructions to "pull this
  tag, run this command".
- If a future substrate turns out to require a source change in the module
  (rather than only in the tree it installs into), that is a signal to revisit
  this ADR — not to add a build flag quietly.

## Alternatives considered

- **Separate MANET and satellite builds of the module.** Rejected above:
  no behavioural difference to express, and it silently costs comparability.
- **Vendor a substrate into this repository.** Rejected — the repo deliberately
  does not vendor a simulator (`AGENTS.md`), and a substrate is part of the
  simulator installation. It would also drag a third party's licence and release
  cadence into ours.
- **Add the substrate to the existing default images.** Rejected — it would
  either constrain the CI matrix to the substrate's narrower ns-3 support or
  break the legs outside it, and it makes every MANET build pay for a module it
  never loads.
- **Publish the satellite image now.** Rejected as premature: it would bake in a
  substrate choice that [#193](https://github.com/danieljoppi/AntHocNet/issues/193)
  has not made. The parameterised, unpublished target is what *unblocks* that
  decision, since the spikes' decisive question — can a third-party
  `Ipv4RoutingProtocol` be installed on the substrate's nodes? — can only be
  answered by a build.

## References

ADR-0002 (one core, thin adapters — the invariant this protects),
[#192](https://github.com/danieljoppi/AntHocNet/issues/192) (satellite track),
[#193](https://github.com/danieljoppi/AntHocNet/issues/193) (substrate
selection), [#197](https://github.com/danieljoppi/AntHocNet/issues/197) /
[#198](https://github.com/danieljoppi/AntHocNet/issues/198) /
[#200](https://github.com/danieljoppi/AntHocNet/issues/200) (the spikes this
unblocks), [#214](https://github.com/danieljoppi/AntHocNet/issues/214)
(`isl-grid`, the satellite-shaped scenario that needs no special build),
[#233](https://github.com/danieljoppi/AntHocNet/issues/233) (the epic implementing
this ADR, with [#234](https://github.com/danieljoppi/AntHocNet/issues/234) phase 1
and [#235](https://github.com/danieljoppi/AntHocNet/issues/235) phase 2),
[`docker/README.md`](../../docker/README.md), `.github/workflows/images.yml`.
