#!/usr/bin/env bash
# SPDX-License-Identifier: MIT OR GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
#
# Drop-in ns-3 module tarball (#606): the six contrib modules exactly as
# `make install-ns3` lays them out, so a user without a checkout installs with
#
#   tar -xzf anthocnet-ns3-modules-<ver>.tar.gz -C /path/to/ns-3/contrib
#
# Built by running the real installer into a scratch tree (one source of truth
# for the layout), then archiving its contrib/. Deterministic: sorted entries,
# fixed owner and mtime, so two builds of one commit are byte-identical.
#
# The same run also writes the two packages that stand alone (#770), for users
# who want the comparison harness or the adaptive arms without AntHocNet:
#
#   routing-bench-<ver>.tar.gz   contrib/routing-bench (the harness, stock arms)
#   adaptive-<ver>.tar.gz        contrib/adaptive (ARA, Termite, Q-routing, BeeAdHoc)
#
# Each unpacks into contrib/ with its README, the licence and an install note.
# adaptive builds alone and registers its arms with routing-bench when both are
# installed. They carry the AntHocNet release version (one version line).
#
# Usage: tools/release/module-tarball.sh <version> <out-dir>
set -euo pipefail
ver=${1:?usage: module-tarball.sh <version> <out-dir>}
out=${2:?usage: module-tarball.sh <version> <out-dir>}
repo=$(cd "$(dirname "$0")/../.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

mkdir -p "$tmp/ns3/contrib" "$out"
touch "$tmp/ns3/CMakeLists.txt"
make -s -C "$repo" install-ns3 NS3DIR="$tmp/ns3" >/dev/null

cat > "$tmp/ns3/contrib/ANTHOCNET-INSTALL.txt" <<TXT
AntHocNet $ver — drop-in ns-3 modules

  tar -xzf anthocnet-ns3-modules-$ver.tar.gz -C /path/to/ns-3/contrib
  cd /path/to/ns-3
  ./ns3 configure --enable-examples --enable-tests && ./ns3 build
  ./test.py -s anthocnet && ./ns3 run anthocnet-example

Contents: contrib/anthocnet (the module + harnesses) and the comparison
modules contrib/aomdv, contrib/gpsr, contrib/oracle, contrib/adaptive and the harness
module contrib/routing-bench. Delete those five to
build AntHocNet alone; ns-3 then skips the comparison harnesses.
Tested on ns-3.36 to ns-3.48. Docs: https://danieljoppi.github.io/AntHocNet/docs/
TXT

epoch=$(git -C "$repo" log -1 --format=%ct 2>/dev/null || echo 0)
pack() {  # pack <dir> <archive name>: deterministic tar.gz of <dir>'s contents
    tar --sort=name --owner=0 --group=0 --numeric-owner --mtime="@${epoch}" \
        -C "$1" -cf - . | gzip -n > "$out/$2"
    echo "$out/$2"
}

# The two standalone packages, cut from the installed tree (each copies only
# its own directory, so the AntHocNet note above stays out of them; #770).
for pkg in routing-bench adaptive; do
    p="$tmp/pkg-$pkg"
    mkdir -p "$p"
    cp -r "$tmp/ns3/contrib/$pkg" "$p/"
    case "$pkg" in
        routing-bench) src="$repo/ns3/routing-bench"
                       what="the protocol-agnostic comparison harness (routing-compare) with the stock ns-3 arms (AODV, OLSR, DSDV, HWMP)"
                       check="./test.py -s routing-bench && ./ns3 run \"routing-compare --PrintHelp\"" ;;
        adaptive)      src="$repo/ns3/baselines/adaptive"
                       what="the adaptive-routing comparator arms (ARA, Termite, Q-routing, BeeAdHoc), written from their papers"
                       check="./test.py -s adaptive" ;;
    esac
    cp "$src/README.md" "$p/$pkg/README.md"
    cp "$repo/LICENSE" "$p/$pkg/LICENSE"
    cat > "$p/$pkg/INSTALL.txt" <<TXT
$pkg $ver (from AntHocNet $ver): $what.

  tar -xzf $pkg-$ver.tar.gz -C /path/to/ns-3/contrib
  cd /path/to/ns-3
  ./ns3 configure --enable-examples --enable-tests && ./ns3 build
  $check

Needs only stock ns-3 (3.36 to 3.48). routing-bench and adaptive install side
by side: with both present, routing-compare also offers the adaptive arms.
The version follows AntHocNet's release line. Licence: GPL-2.0-only (LICENSE).
Docs: https://danieljoppi.github.io/AntHocNet/docs/comparison-harness/
TXT
    pack "$p" "$pkg-${ver}.tar.gz"
done

pack "$tmp/ns3/contrib" "anthocnet-ns3-modules-${ver}.tar.gz"
