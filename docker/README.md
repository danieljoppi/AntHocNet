# Container images

Reproducible, self-contained build environments — **one image per supported
simulator version** — with the AntHocNet code already installed and compiled.
They fetch and build the simulator themselves; nothing here vendors ns-2 or ns-3.

| Image | Versions | What it contains |
|-------|----------|------------------|
| `anthocnet-ns3` | `3.41`, `3.42` | ns-3 + the additive AntHocNet module, configured with the benchmark module set, built, and `test.py -s anthocnet` run. |
| `anthocnet-ns2` | `2.34`, `2.35` | ns-allinone-2.3x built from source + the AntHocNet source patch applied and **compiled** (the only place the ns-2 adapter is actually built). |

Published to GHCR on every push to the default branch:
`ghcr.io/danieljoppi/anthocnet-ns3:<ver>` and `.../anthocnet-ns2:<ver>`.

## Build locally

```bash
# NS-3 (mirrors CI):
docker build -f docker/Dockerfile.ns3 --build-arg NS3_VERSION=ns-3.42 \
             -t anthocnet-ns3:3.42 .
docker run --rm anthocnet-ns3:3.42                 # runs anthocnet-example
docker run --rm anthocnet-ns3:3.42 ./test.py -s anthocnet

# NS-2 (legacy tree; pinned Ubuntu 18.04 toolchain):
docker build -f docker/Dockerfile.ns2 --build-arg NS2_VERSION=2.35 \
             -t anthocnet-ns2:2.35 .
docker run --rm -it anthocnet-ns2:2.35             # `ns` with the AntHocNet agent
```

## Why two recipes

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

- The `Images` workflow (`.github/workflows/images.yml`) builds all four on PRs
  touching `docker/`, `core/`, `ns2/`, or `ns3/` (validation only) and pushes
  them to GHCR on the default branch.
- ns-2.34 is the oldest supported tree; if its build needs extra fixes on the
  pinned base they go in `docker/Dockerfile.ns2` behind the `NS2_VERSION` arg.
