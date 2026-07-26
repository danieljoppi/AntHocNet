# Container images

Reproducible, self-contained build environments. For each supported simulator
version we publish **two** images — a plain simulator (no AntHocNet) and the same
simulator with AntHocNet built in — so the protocol can be compared against a
clean baseline. They fetch and build the simulator themselves; nothing here
vendors ns-2 or ns-3.

| Image | Versions | Contents |
|-------|----------|----------|
| `ns3` | `3.36`, `3.41`, `3.42`, `3.47`, `3.48` | Plain ns-3 with the comparison protocols (AODV/OLSR/DSDV/…), **no AntHocNet**. |
| `anthocnet-ns3` | `3.36`, `3.41`, `3.42`, `3.47`, `3.48` | The same ns-3 **plus** the additive AntHocNet module (configured, built, `anthocnet-example` smoke-run). |
| `ns2` | `2.34`, `2.35` | Plain ns-allinone-2.3x built from source, **no AntHocNet**. |
| `anthocnet-ns2` | `2.34`, `2.35` | The same ns-2 **plus** the AntHocNet patch applied and **compiled** (the only place the ns-2 adapter is actually built). |

> **Satellite work uses an image variant, not a different build of AntHocNet**
> ([ADR-0015](../docs/adr/0015-satellite-substrate-lives-in-the-image.md)). A
> satellite substrate (ns3-leo, Hypatia, …) is a third-party module installed
> into the *ns-3 tree*, so it belongs to the image; the AntHocNet module itself
> compiles once and is identical in both regimes. No satellite image is
> published yet — the substrate is not chosen ([#193](https://github.com/danieljoppi/AntHocNet/issues/193)),
> and the parameterised build target that answers that question is deliberately
> unpublished. See [#192](https://github.com/danieljoppi/AntHocNet/issues/192).

Published to **GHCR** (`ghcr.io/danieljoppi/…`) for
`{ns3,anthocnet-ns3,ns2,anthocnet-ns2}`. A Docker Hub mirror exists in
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

## Build locally

Each Dockerfile has a `base` stage (plain simulator) and an `anthocnet` stage on
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

# plain ns-2 vs ns-2 + AntHocNet:
docker build -f docker/Dockerfile.ns2 --target base \
             --build-arg NS2_VERSION=2.35 -t ns2:2.35 .
docker build -f docker/Dockerfile.ns2 \
             --build-arg NS2_VERSION=2.35 -t anthocnet-ns2:2.35 .
```

## Why two recipes, two stages

ns-3 integrates as an additive module and builds cleanly from a pinned git tag,
so its image is a thin wrapper over the same steps CI runs. ns-2 is a legacy
tree that does not build on current toolchains and is installed as an
anchor-based **source patch**, so its image pins Ubuntu 18.04 (gcc-7), applies
the known modern-gcc fixes to the stock sources, builds the stock ns-allinone
tree, then patches and recompiles — giving the project a real ns-2 **compile**
check (CI alone only validates that the patch applies and reverts; see
`ns2/patch/selftest.sh`).

gcc-7 defaults to `-std=gnu++14`, so the C++14 shared `core/` and the stock ns-2
sources build under the same working flags — no per-object `-std` override (an
earlier attempt to append one corrupted ns-2's continued `CCOPT` line).

## Notes

- The `Images` workflow (`.github/workflows/images.yml`) builds and pushes all
  images on merges to the default branch (and on manual dispatch — a dispatch on
  a branch builds only, no push). It does **not** run on PRs, so the slow ns-2
  build never gates a PR; the image recipes are refined post-merge.
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
- ns-2.34 is the oldest supported tree; if its build needs extra fixes on the
  pinned base they go in `docker/Dockerfile.ns2` behind the `NS2_VERSION` arg.
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
