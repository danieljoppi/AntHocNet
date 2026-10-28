#!/usr/bin/env bash
# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
#
# Drop-in ns-3 module tarball (#606): the four contrib modules exactly as
# `make install-ns3` lays them out, so a user without a checkout installs with
#
#   tar -xzf anthocnet-ns3-modules-<ver>.tar.gz -C /path/to/ns-3/contrib
#
# Built by running the real installer into a scratch tree (one source of truth
# for the layout), then archiving its contrib/. Deterministic: sorted entries,
# fixed owner and mtime, so two builds of one commit are byte-identical.
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
modules contrib/aomdv, contrib/gpsr, contrib/oracle. Delete those three to
build AntHocNet alone; ns-3 then skips the comparison harnesses.
Tested on ns-3.36 to ns-3.48. Docs: https://danieljoppi.github.io/AntHocNet/docs/
TXT

name="anthocnet-ns3-modules-${ver}.tar.gz"
epoch=$(git -C "$repo" log -1 --format=%ct 2>/dev/null || echo 0)
tar --sort=name --owner=0 --group=0 --numeric-owner --mtime="@${epoch}" \
    -C "$tmp/ns3/contrib" -cf - . | gzip -n > "$out/$name"
echo "$out/$name"
