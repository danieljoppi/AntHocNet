# Container images

Reproducible, self-contained build environments. For each supported simulator
version we publish **two** images — a plain simulator (no AntHocNet) and the same
simulator with AntHocNet built in — so the protocol can be compared against a
clean baseline. They fetch and build the simulator themselves; nothing here
vendors ns-3.

| Image | Versions | Contents |
|-------|----------|----------|
| `ns3` | `3.36`, `3.41`, `3.42`, `3.47`, `3.48` | Plain ns-3 with the comparison protocols (AODV/OLSR/DSDV/…), **no AntHocNet**. |
| `anthocnet-ns3` | `3.36`, `3.41`, `3.42`, `3.47`, `3.48` | The same ns-3 **plus** the additive AntHocNet module (configured, built, `anthocnet-example` smoke-run). |

> **NS-2 images are no longer built** (the adapter was removed in v2.0.0, #307).
> Everything already published stays pullable — `ns2` and `anthocnet-ns2` at
> `2.34` / `2.35`, and the immutable release pins such as
> `anthocnet-ns2:2.35-v1.2.0`. See [docs/ns2-support.md](../docs/ns2-support.md).

> **The satellite image is `ns3:3.48` / `anthocnet-ns3:3.48`.** ADR-0015 put a
> satellite substrate in the image rather than in a second build of AntHocNet;
> [ADR-0022](../docs/adr/0022-satellite-substrate-is-stock-ns3-leo.md) then chose
> a substrate that ships *inside* stock ns-3.48 (its LEO mobility model), so no
> separate satellite image exists or is needed. The moving-constellation harness
> `leo-walker` builds on the 3.48 images only.

Published to **GHCR** (`ghcr.io/danieljoppi/…`) for
`{ns3,anthocnet-ns3}`. A Docker Hub mirror exists in
`images.yml` but is **off** (`MIRROR_DOCKERHUB: 'false'`, #158) — GHCR is the
only registry CI, the campaign workflows and this README depend on. Each image
carries three tag tiers, plus a build-profile tier that exists for the plain
`ns3` image only:

| Tag | Example | Meaning | Mutability |
|-----|---------|---------|------------|
| `:<sim-version>` | `:3.42` | latest build for that simulator version | rolling — moves on every merge to the default branch |
| `:<sim-version>-<release>` | `:3.42-v0.3.0` | pinned to an AntHocNet release | **immutable** — written once, never overwritten |
| `:latest` | `:latest` | newest simulator version + latest AntHocNet | rolling — moves on every merge to the default branch |
| `:<sim-version>-opt` | `:3.42-opt` | `ns3` only — the same tree in ns-3's **`release`** build profile (optimized without `-march=native`) | rolling (plus `:3.42-opt-<release>` when a release is pinned) |

Use `:<sim-version>-<release>` when you need a reproducible image for a citation
(the rolling tiers track the default branch and can change under you). The
release-pinned tier is published by the `Release` workflow (which reuses
`images.yml`); the rolling tiers are published on every default-branch merge.

> **v1.5.0 has no `anthocnet-ns3` pins.** Its release run's image jobs failed:
> the `v1.5.0` tag's `Dockerfile.ns3` enabled `anthocnet;wifi;…` but not the
> `aomdv`/`gpsr`/`oracle` modules the examples include, so the ns-3 example
> build broke ([#436](https://github.com/danieljoppi/AntHocNet/pull/436)
> fixed `main` the next day, after the tag). A 2026-09-24 backfill from the tag
> ([#473](https://github.com/danieljoppi/AntHocNet/pull/473)'s pin-only
> dispatch) confirmed the tag cannot build them, and published what it can:
> `ns2:<ver>-v1.5.0`, `anthocnet-ns2:<ver>-v1.5.0` and the plain
> `ns3:<ver>-v1.5.0`. For a pinned AntHocNet ns-3 image use `-v1.6.0` (the
> first release after the fix; its image jobs all passed) or `-v1.4.0`.

A failed release image job can be republished without moving the rolling tags:
dispatch `Images` on `main` with `release=vX.Y.Z` and `pin_only=true`
(#473). The job checks out the release tag, so it only helps when the failure
was transient. It cannot fix a recipe that is broken inside the tag itself,
as v1.5.0's is.

## Build locally

The Dockerfile has a `base` stage (plain simulator) and an `anthocnet` stage on
top, so `--target base` gives the vanilla image and the default gives the
AntHocNet one:

```bash
# plain ns-3 vs ns-3 + AntHocNet:
docker build -f docker/Dockerfile.ns3 --target base \
             --build-arg NS3_VERSION=ns-3.42 -t ns3:3.42 .
docker build -f docker/Dockerfile.ns3 \
             --build-arg NS3_VERSION=ns-3.42 -t anthocnet-ns3:3.42 .

# campaign build profile (release = optimized minus -march=native) — applies to both
# stages; anything other than `default` becomes `./ns3 configure -d <profile>`:
docker build -f docker/Dockerfile.ns3 --target base \
             --build-arg NS3_VERSION=ns-3.42 --build-arg NS3_PROFILE=release \
             -t ns3:3.42-opt .

```

## Why two stages

ns-3 integrates as an additive module and builds cleanly from a pinned git tag,
so the image is a thin wrapper over the same steps CI runs: the `base` stage is
the plain simulator a baseline is measured on, and the `anthocnet` stage adds
the module on top of exactly that tree. (Through v1.9.0 a second recipe,
`Dockerfile.ns2`, built the legacy ns-2 trees on a pinned Ubuntu 18.04; it is
preserved at the v1.9.0 tag.)

## Notes

- The `Images` workflow (`.github/workflows/images.yml`) builds and pushes all
  images on merges to the default branch (and on manual dispatch — a dispatch on
  a branch builds only, no push). It does **not** run on PRs, so the slow image
  builds never gate a PR; the image recipes are refined post-merge.
- The `Release` workflow reuses `images.yml` via `workflow_call` to publish the
  immutable `:<sim-version>-<release>` tags from the release tag. Reuse (not a
  tag `push` event) is deliberate: a tag pushed with the release job's default
  `GITHUB_TOKEN` does not trigger other workflows, so a `push: tags` job would
  never fire — a `workflow_call` job dependency runs in the same release run and
  needs no PAT.
- The **Docker Hub mirror is disabled** (`MIRROR_DOCKERHUB: 'false'` in
  `images.yml`; maintainer decision on #158). Its steps are kept rather than
  deleted, each `continue-on-error: true` and separate from the GHCR push, so a
  dead mirror can never again fail a publish or skip later steps — the #158 bug,
  which silently prevented `ns3:<ver>-opt` from being published at all. To turn
  it back on: set `MIRROR_DOCKERHUB: 'true'` and store a Docker Hub PAT with
  **Read & Write** scope in `DOCKERHUB_TOKEN` (plus `DOCKERHUB_USERNAME`).
- **Build profiles (#123).** `NS3_PROFILE` selects ns-3's build profile.
  `default` (assertions + `NS_LOG` compiled in) is what every image tier above
  carries and what CI consumes — those assertions have caught real bugs, so the
  campaign image must **never** replace them in CI. `release` (assertions and
  logging compiled out, typically 2-10x faster on simulation-heavy runs) is
  published as the extra `ns3:<ver>-opt` tag, for **ns-3.42 only**, and is
  consumed solely by the manual `paper-benchmark` / `scenario-matrix`
  campaigns via their `version` input. Each image records its profile in the
  `NS3_PROFILE` environment variable (`docker inspect`), which is how those
  workflows know whether their in-job `./ns3 configure` needs `-d release` —
  see [`docs/benchmarks/methodology.md`](../docs/benchmarks/methodology.md#build-profiles-default-for-ci-release-for-campaigns)
  for why that is resolved explicitly rather than inherited, and for the
  rationale for `release` over ns-3's `optimized` (which adds `-march=native`).
