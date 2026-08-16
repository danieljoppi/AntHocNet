#!/usr/bin/env bash
# Devcontainer post-create (#334): make the image's ns-3 tree carry *this*
# checkout's AntHocNet module, then build it.
#
# The base image (ghcr.io/danieljoppi/anthocnet-ns3, see docker/Dockerfile.ns3)
# already has ns-3 configured and fully built at /opt/ns-3, with an AntHocNet
# module baked in from whatever commit the image was published at. That copy is
# not the branch you just opened, so this script reinstalls the module from the
# workspace and rebuilds. Since every stock object file is already in the
# image's build cache, only the AntHocNet delta compiles.
#
# The three steps below mirror .github/workflows/ci.yml's `ns3-build` job —
# "Install AntHocNet module", "Configure (scope examples/tests to AntHocNet)"
# and "Build" — on purpose: if it builds here it builds in CI, and there is one
# place to change when the build recipe changes.
set -euo pipefail

# containerEnv sets this in devcontainer.json; the default keeps the script
# runnable via `bash .devcontainer/post-create.sh` in a plain `docker run`.
NS3DIR=${NS3DIR:-/opt/ns-3}

# --- 1. Install AntHocNet module (ci.yml: "Install AntHocNet module") --------
# Additive: copies ns3/{model,helper,examples,test} plus the shared core/ into
# $NS3DIR/contrib/anthocnet. No stock ns-3 file is edited (see ns3/Makefile).
echo ">> Installing the AntHocNet module from $PWD into $NS3DIR"
make install-ns3 NS3DIR="$NS3DIR"

# --- 2. Configure (ci.yml: "Configure (scope examples/tests to AntHocNet)") ---
cd "$NS3DIR"

# Build only AntHocNet's own examples/tests, not the stock modules' (their
# cross-module deps drift by release). The filter flag scopes that to our
# module; it was added after ns-3.36, so older trees just build + smoke.
# #435: this list must match ci.yml's mods= — without aomdv/gpsr/oracle the
# anthocnet-compare and isl-grid examples are SKIPPED silently (their
# CMakeLists lists those libs), so the "run anthocnet-compare" suggestion
# below would point at a binary that was never built. Consistency is now
# enforced by ns3/tools/check-allowlists.sh.
mods='anthocnet;aomdv;gpsr;oracle;wifi;mobility;applications;csma;aodv;olsr;dsdv;flow-monitor;point-to-point'
if ./ns3 configure --help 2>/dev/null | grep -q filter-module-examples-and-tests; then
    ./ns3 configure --enable-tests --enable-examples \
        --filter-module-examples-and-tests=anthocnet \
        --enable-modules="$mods"
else
    ./ns3 configure --enable-examples --enable-modules="$mods"
fi

# No `-d <profile>` flag here, matching ci.yml: every `anthocnet-ns3` tag is
# built in ns-3's **default** profile (assertions + NS_LOG compiled in), and the
# `-opt`/release-profile tier exists for the plain `ns3` image only — see
# docker/README.md "Build profiles (#123)". If this devcontainer is ever
# repointed at a release-profile image, this configure must gain `-d release`
# or it silently hands back the 2-10x campaign speedup.

# --- 3. Build (ci.yml: "Build") ----------------------------------------------
./ns3 build

cat <<EOF

>> AntHocNet is built. Run your first simulation:

     cd $NS3DIR
     ./ns3 run anthocnet-example

   Compare against AODV / OLSR / DSDV:
     ./ns3 run "anthocnet-compare --nNodes=20 --time=30"

   Module test suite:
     ./test.py -s anthocnet

   Core unit tests (no simulator needed), from the workspace folder:
     make test
EOF
