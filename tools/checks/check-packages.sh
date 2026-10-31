#!/usr/bin/env bash
# SPDX-License-Identifier: MIT OR GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
#
# The standalone release packages install on a clean ns-3 tree (#770). Builds
# the packages exactly as release.yml does (tools/release/module-tarball.sh),
# unpacks the requested ones into <ns3-dir>/contrib, then configures, builds
# and runs their test suites, and, when the harness is installed, a delivery
# smoke of every arm it advertises.
#
#   routing-bench            the harness alone: exactly the stock arms, and
#                            each of them delivers multi-hop
#   adaptive                 the arms module alone: builds and its tests pass
#                            (it registers no arm without the harness)
#   routing-bench,adaptive   together: the harness also offers the adaptive
#                            arms, and every advertised arm delivers
#
# The smoke is check-arm-delivery.sh's field and floors without its oracle
# anchor: the oracle ships in neither package.
#
# Usage: check-packages.sh <ns3-dir> <package>[,<package>]
set -euo pipefail
# Marker fields are read by name through the tested reader, not by awk
# position (#791; tools/bench/test_bench_parse_query.py).
BENCH_PARSE="$(cd "$(dirname "$0")/../bench" && pwd)/bench_parse.py"
field() { python3 "$BENCH_PARSE" --get "$1" --from "$2" --proto "$3" -; }  # reads stdin

NS3DIR=${1:?usage: check-packages.sh <ns3-dir> <package>[,<package>]}
PKGS=${2:?usage: check-packages.sh <ns3-dir> <package>[,<package>]}
REPO="$(cd "$(dirname "$0")/../.." && pwd)"
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
fail=0
say() { echo "[packages:$PKGS] $*"; }

for m in anthocnet aomdv gpsr oracle adaptive routing-bench; do
    if [ -e "$NS3DIR/contrib/$m" ]; then
        say "FAIL: $NS3DIR/contrib/$m already exists; the tree must be clean"
        exit 1
    fi
done

"$REPO/tools/release/module-tarball.sh" 0.0.0-check "$tmp" >/dev/null
mods="wifi;mobility;applications;aodv;olsr;dsdv;flow-monitor;mesh"
for p in ${PKGS//,/ }; do
    tar -xzf "$tmp/$p-0.0.0-check.tar.gz" -C "$NS3DIR/contrib"
    for f in CMakeLists.txt README.md LICENSE INSTALL.txt; do
        [ -s "$NS3DIR/contrib/$p/$f" ] || { say "FAIL: package $p has no $f"; fail=1; }
    done
    mods="$p;$mods"
done

cd "$NS3DIR"
./ns3 configure --enable-tests --enable-examples \
    --filter-module-examples-and-tests="${PKGS//,/;}" --enable-modules="$mods" >/dev/null
./ns3 build >/dev/null
for p in ${PKGS//,/ }; do
    ./test.py -s "$p" || { say "FAIL: test suite '$p'"; fail=1; }
done

case ",$PKGS," in
    *,routing-bench,*) ;;
    *) [ "$fail" -eq 0 ] && say "PASS (no harness installed: build and tests only)"; exit "$fail" ;;
esac

help=$(./ns3 run "routing-compare --PrintHelp" 2>&1 || true)
arms=$(printf '%s\n' "$help" | sed -n 's/.*Comma-separated list (\([a-z0-9,]*\)).*/\1/p' | head -n 1)
case ",$PKGS," in
    *,adaptive,*) want="aodv,ara,beeadhoc,dsdv,hwmp,olsr,qrouting,termite" ;;
    *)            want="aodv,dsdv,hwmp,olsr" ;;
esac
if [ "$arms" != "$want" ]; then
    say "FAIL: routing-compare offers ($arms), expected ($want)"
    exit 1
fi
say "arms: $arms"

ARGS="--nNodes=16 --area=500 --range=175 --pause=120 --flows=3 --time=60 --runs=1"
for arm in ${arms//,/ }; do
    extra=""
    [ "$arm" = hwmp ] && extra="--standard=80211a --rateManager=constant6"
    out=$(./ns3 run "routing-compare $ARGS $extra --protocols=$arm" 2>&1) \
        || { printf '%s\n' "$out" | tail -n 20; say "FAIL: $arm did not run"; fail=1; continue; }
    pdr=$(printf '%s\n' "$out" | field pdr run "$arm")
    hops=$(printf '%s\n' "$out" | field hopsMean paths "$arm")
    if awk -v p="${pdr:-0}" -v h="${hops:-0}" 'BEGIN { exit (p + 0 >= 5 && h + 0 > 1.0) ? 0 : 1 }'; then
        say "ok: $arm PDR ${pdr}% over ${hops} hops"
    else
        say "FAIL: $arm PDR ${pdr:-none}% hopsMean ${hops:-none} (need >= 5% and > 1 hop)"
        fail=1
    fi
done
[ "$fail" -eq 0 ] && say "PASS"
exit "$fail"
