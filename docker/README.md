# Container images

Reproducible, self-contained build environments. For each supported simulator
version we publish **two** images — a plain simulator (no AntHocNet) and the same
simulator with AntHocNet built in — so the protocol can be compared against a
clean baseline. They fetch and build the simulator themselves; nothing here
vendors ns-2 or ns-3.

| Image | Versions | Contents |
|-------|----------|----------|
| `ns3` | `3.36`, `3.41`, `3.42`, `3.47`, `3.48` | Plain ns-3 with the comparison protocols (AODV/OLSR/DSDV/…), **no AntHocNet**. |
| `anthocnet-ns3` | `3.36`, `3.41`, `3.42`, `3.47`, `3.48` | The same ns-3 **plus** the additive AntHocNet module (configured, built, `test.py -s anthocnet` run). |
| `ns2` | `2.34`, `2.35` | Plain ns-allinone-2.3x built from source, **no AntHocNet**. |
| `anthocnet-ns2` | `2.34`, `2.35` | The same ns-2 **plus** the AntHocNet patch applied and **compiled** (the only place the ns-2 adapter is actually built). |

Published to GHCR on every merge to the default branch:
`ghcr.io/danieljoppi/{ns3,anthocnet-ns3,ns2,anthocnet-ns2}:<version>`.

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
the known modern-gcc fix, builds the stock ns-allinone tree, then patches and
recompiles — giving the project a real ns-2 **compile** check (CI alone only
validates that the patch applies and reverts; see `ns2/patch/selftest.sh`).

The shared `core/` is C++14, so the ns-2 build compiles the AntHocNet objects
with `-std=gnu++14` while leaving the stock ns-2 objects on their default flags.

## Notes

- The `Images` workflow (`.github/workflows/images.yml`) builds and pushes all
  images on merges to the default branch (and on manual dispatch — a dispatch on
  a branch builds only, no push). It does **not** run on PRs, so the slow ns-2
  build never gates a PR; the image recipes are refined post-merge.
- ns-2.34 is the oldest supported tree; if its build needs extra fixes on the
  pinned base they go in `docker/Dockerfile.ns2` behind the `NS2_VERSION` arg.
