#!/bin/sh
# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi
#
# make doctor NS3DIR=/path/to/ns-3 (#605): check an ns-3 tree before a long
# build fails halfway. Prints one line per check (ok / warn / FAIL), a verdict,
# and one machine-readable line that the learn site's install quest (#636)
# parses locally:
#
#   ##DOCTOR## v=1 ns3=3.42 cmake=3.28.3 cxx=g++-13.2.0 python=3.11.9
#              contrib=writable module=installed baselines=aomdv:ok,gpsr:ok,oracle:ok
#              built=no verdict=ok
#
# (one line in the output). The format is versioned by v=; fields are only ever
# added. Exit status: 0 for ok/warn, 1 for FAIL.
#
# POSIX sh on purpose: it must run on whatever box the user has before
# anything else is installed.

NS3DIR=${1:-}
fails=0
warns=0
say() { printf '%-5s %s\n' "$1" "$2"; }
ok() { say ok "$1"; }
warn() { say warn "$1"; warns=$((warns + 1)); }
fail() { say FAIL "$1"; fails=$((fails + 1)); }

# Supported range: the CI matrix (ci.yml ns3-build) — keep the two in step.
MIN_MINOR=36
MAX_MINOR=48

ns3=unknown cmake=missing cxx=missing python=missing contrib=missing
module=missing baselines=none built=no

# --- the tree ---------------------------------------------------------------
if [ -z "$NS3DIR" ]; then
    fail "NS3DIR is not set: make doctor NS3DIR=/path/to/ns-3"
elif [ ! -d "$NS3DIR" ]; then
    fail "NS3DIR=$NS3DIR does not exist"
elif [ ! -d "$NS3DIR/contrib" ] || [ ! -f "$NS3DIR/CMakeLists.txt" ]; then
    fail "$NS3DIR does not look like an ns-3 tree (no contrib/ or CMakeLists.txt)"
else
    ok "ns-3 tree: $NS3DIR"
    # ns-3 records its version in VERSION ("3.42", or "3-dev" on ns-3-dev);
    # CMake reads the same file into NS3_VER.
    if [ -f "$NS3DIR/VERSION" ]; then
        ns3=$(head -n 1 "$NS3DIR/VERSION" | tr -d ' \r')
    fi
    case "$ns3" in
        3.[0-9]*)
            minor=$(printf '%s' "$ns3" | sed 's/^3\.\([0-9]*\).*/\1/')
            if [ "$minor" -lt 36 ]; then
                fail "ns-3 $ns3 is waf-based; the module needs ns-3.$MIN_MINOR+ (CMake)"
            elif [ "$minor" -gt "$MAX_MINOR" ]; then
                warn "ns-3 $ns3 is newer than the tested range 3.$MIN_MINOR-3.$MAX_MINOR"
            else
                ok "ns-3 $ns3 (tested range 3.$MIN_MINOR-3.$MAX_MINOR)"
            fi ;;
        3-dev)
            warn "ns-3-dev: not a release; tested range is 3.$MIN_MINOR-3.$MAX_MINOR" ;;
        *)
            ns3=unknown
            warn "could not read the ns-3 version from $NS3DIR/VERSION" ;;
    esac
    if [ -w "$NS3DIR/contrib" ]; then
        contrib=writable; ok "contrib/ is writable"
    else
        contrib=readonly; fail "$NS3DIR/contrib is not writable (make install-ns3 copies into it)"
    fi
    if [ -d "$NS3DIR/contrib/anthocnet" ]; then
        module=installed; ok "AntHocNet installed in contrib/anthocnet"
    else
        module=missing; warn "AntHocNet not installed yet: make install-ns3 NS3DIR=$NS3DIR"
    fi
    b=""
    for m in aomdv gpsr oracle; do
        if [ -d "$NS3DIR/contrib/$m" ]; then s=ok; else s=missing; fi
        b="${b:+$b,}$m:$s"
    done
    baselines=$b
    case "$baselines" in
        *missing*)
            if [ "$module" = installed ]; then
                warn "comparison baselines: $baselines -- the comparison harnesses (anthocnet-compare, isl-grid, leo-walker) are skipped without them; the module, its tests and anthocnet-example still build (BASELINES=0 installs)"
            fi ;;
        *) ok "comparison baselines: $baselines" ;;
    esac
    if ls "$NS3DIR"/build/lib/libns3*anthocnet* >/dev/null 2>&1; then
        built=yes; ok "module library is built"
    else
        built=no
    fi
fi

# --- the toolchain ------------------------------------------------------------
if command -v cmake >/dev/null 2>&1; then
    cmake=$(cmake --version | head -n 1 | awk '{print $3}')
    cmajor=$(printf '%s' "$cmake" | cut -d. -f1)
    cminor=$(printf '%s' "$cmake" | cut -d. -f2)
    if [ "$cmajor" -lt 3 ] || { [ "$cmajor" -eq 3 ] && [ "$cminor" -lt 13 ]; }; then
        warn "CMake $cmake: ns-3 needs 3.13 or newer (3.20+ for recent releases)"
    else
        ok "CMake $cmake"
    fi
else
    fail "cmake not found"
fi

CXXBIN=${CXX:-c++}
if command -v "$CXXBIN" >/dev/null 2>&1; then
    v=$("$CXXBIN" --version 2>/dev/null | head -n 1)
    num=$(printf '%s' "$v" | grep -o '[0-9][0-9]*\.[0-9][0-9.]*' | head -n 1)
    case "$v" in
        *clang*) cxx="clang++-$num"; need=10 ;;
        *)       cxx="g++-$num"; need=9 ;;
    esac
    major=$(printf '%s' "$num" | cut -d. -f1)
    if [ -n "$major" ] && [ "$major" -lt "$need" ]; then
        warn "C++ compiler $cxx: ns-3 needs C++17 (g++ 9+ or clang 10+)"
    else
        ok "C++ compiler $cxx"
    fi
else
    fail "no C++ compiler ($CXXBIN) on PATH"
fi

if command -v python3 >/dev/null 2>&1; then
    python=$(python3 -c 'import platform; print(platform.python_version())')
    ok "python3 $python (ns-3's ./ns3 driver)"
else
    fail "python3 not found (ns-3's ./ns3 driver needs it)"
fi

# --- verdict -------------------------------------------------------------------
if [ "$fails" -gt 0 ]; then verdict=fail
elif [ "$warns" -gt 0 ]; then verdict=warn
else verdict=ok; fi
echo "----"
case "$verdict" in
    ok)   echo "verdict: ok" ;;
    warn) echo "verdict: ok with $warns warning(s)" ;;
    fail) echo "verdict: $fails problem(s) to fix first" ;;
esac
echo "##DOCTOR## v=1 ns3=$ns3 cmake=$cmake cxx=$cxx python=$python contrib=$contrib module=$module baselines=$baselines built=$built verdict=$verdict"
[ "$verdict" = fail ] && exit 1
exit 0
