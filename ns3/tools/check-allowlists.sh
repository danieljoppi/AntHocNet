#!/usr/bin/env bash
# Allowlist consistency gate (#435): assert that every hand-maintained
# module / protocol-arm / ##MARKER## allowlist in the tree agrees with a
# ground truth DERIVED from the tree, so the next module/arm/marker addition
# fails this cheap per-PR check instead of the next campaign or release.
#
# Usage: check-allowlists.sh        (no arguments; pure text, no ns-3 build)
#
# Why this exists. Adding oracle (#419), gpsr (#412) and aomdv (#414) meant
# editing TEN independently hand-maintained lists; FOUR were missed, each
# failing silently or misleadingly (#421, #423, #435):
#   - ci.yml's two mods= lines             -> compile error on all 5 versions
#   - paper-benchmark.yml's ##BENCH## awk  -> arm silently absent from the
#     published compact block
#   - check-determinism.sh's filter_rows() -> arm dropped from BOTH sides of
#     the diff, gate said PASS having compared nothing
#   - docker/Dockerfile.ns3 --enable-modules -> every v1.5.0 ns-3 release
#     image failed to publish
# Every one of those sites carries a "keep this in step" comment; a comment
# is a request for vigilance, this gate is the mechanism (#435).
#
# Ground truths (derived, never listed here):
#   modules  = LIBNAME entries of the vendored module CMakeLists under ns3/
#   arms     = the `proto == "<name>"` dispatch in anthocnet-compare.cc
#   markers  = the `"##NAME## ` string literals anthocnet-compare.cc prints
#
# Failure-to-find is failure: if a checked file or the pattern locating a
# list inside it disappears (a refactor moved the list), this gate FAILS
# loudly instead of passing by matching nothing — same rule as
# check-sat-arms.sh's --PrintHelp derivation (#422).
set -euo pipefail

ROOT=$(cd "$(dirname "$0")/../.." && pwd)
cd "$ROOT"

fail=0

# A checked site that cannot be found is a broken gate, not a clean pass.
need_file() {
    if [ ! -f "$1" ]; then
        echo "FAIL [allowlists]: checked file '$1' not found — a site this gate covers moved."
        echo "  Update ns3/tools/check-allowlists.sh to follow it; the gate must fail rather"
        echo "  than silently check nothing (#435)."
        fail=1
        return 1
    fi
}

count_lines() { printf '%s' "$1" | grep -c . || true; }

# --- ground truth 1: vendored module names --------------------------------
# Each vendored module (anthocnet at ns3/, plus the contrib baselines/controls
# under ns3/<dir>/) declares itself via `build_lib(LIBNAME <name> ...)`.
modules=$({ cat ns3/CMakeLists.txt ns3/*/CMakeLists.txt 2>/dev/null || true; } \
    | sed -n 's/^[[:space:]]*LIBNAME[[:space:]]*\([a-z0-9-]*\).*/\1/p' | sort -u)
if ! printf '%s\n' "$modules" | grep -qx 'anthocnet'; then
    echo "FAIL [allowlists]: could not derive the vendored module set from"
    echo "  ns3/CMakeLists.txt + ns3/*/CMakeLists.txt (no 'LIBNAME anthocnet' found)."
    echo "  If build_lib moved, update the derivation here — do not hardcode a list (#435)."
    exit 1
fi

# --- ground truth 2: protocol arms the compare harness dispatches on ------
harness=ns3/examples/anthocnet-compare.cc
need_file "$harness" || exit 1
arms=$(grep -oE 'proto == "[a-z0-9]+"' "$harness" | sed 's/.*"\(.*\)"/\1/' | sort -u)
if ! printf '%s\n' "$arms" | grep -qx 'anthocnet'; then
    echo "FAIL [allowlists]: could not derive the protocol-arm set from $harness"
    echo "  (no 'proto == \"anthocnet\"' dispatch found). If the dispatch changed shape,"
    echo "  update the derivation here — do not hardcode a list (#435)."
    exit 1
fi

# --- ground truth 3: ##MARKER##s the compare harness emits ----------------
# Emission sites all print a string literal of the form "##NAME## " (trailing
# space distinguishes an emission from a marker merely *mentioned* in help
# text, e.g. "read ##GOODPUT##.").
markers=$(grep -oE '"##[A-Z]+## ' "$harness" | grep -oE '[A-Z]+' | sort -u)
if ! printf '%s\n' "$markers" | grep -qx 'RUN'; then
    echo "FAIL [allowlists]: could not derive the ##MARKER## set from $harness"
    echo "  (no '\"##RUN## ' emission found). If the emission format changed, update"
    echo "  the derivation here — do not hardcode a list (#435)."
    exit 1
fi

echo "[allowlists] modules: $(printf '%s\n' "$modules" | tr '\n' ' ')"
echo "[allowlists] arms:    $(printf '%s\n' "$arms" | tr '\n' ' ')"
echo "[allowlists] markers: $(printf '%s\n' "$markers" | tr '\n' ' ')"

# --- check class 1: module allowlists -------------------------------------
# $1 file, $2 line regex, $3 expected match count, $4 human label.
# Every derived module must appear as a ;-token in every matched list.
check_module_list() {
    local file=$1 regex=$2 expect=$3 label=$4 lines n i list m
    need_file "$file" || return 0
    lines=$(grep -E -e "$regex" "$file" || true)
    n=$(count_lines "$lines")
    if [ "$n" -ne "$expect" ]; then
        echo "FAIL [allowlists]: $label — expected $expect line(s) matching \"$regex\" in $file, found $n."
        echo "  If the list moved, update check-allowlists.sh; the gate must never pass by matching nothing (#435)."
        fail=1
        return 0
    fi
    i=0
    while IFS= read -r line; do
        i=$((i + 1))
        list=$(printf '%s\n' "$line" | sed "s/.*'\([^']*\)'.*/\1/")
        for m in $modules; do
            case ";$list;" in
                *";$m;"*) ;;
                *)
                    echo "FAIL [allowlists]: module '$m' missing from $label ($file, match $i of $expect):"
                    echo "    $list"
                    fail=1
                    ;;
            esac
        done
    done <<EOF
$lines
EOF
}

check_module_list .github/workflows/ci.yml \
    "^[[:space:]]*mods='" 2 "ci.yml mods= (ns3-build + ns3-asan)"
check_module_list .github/workflows/benchmarks.yml \
    "--enable-modules='" 1 "benchmarks.yml --enable-modules"
check_module_list .github/workflows/paper-benchmark.yml \
    "--enable-modules='" 1 "paper-benchmark.yml --enable-modules"
check_module_list .github/workflows/scenario-matrix.yml \
    "--enable-modules='" 1 "scenario-matrix.yml --enable-modules"
check_module_list .github/workflows/satellite-benchmark.yml \
    "--enable-modules='" 1 "satellite-benchmark.yml --enable-modules"
# The devcontainer mirrors ci.yml's ns3-build recipe (#334) — an eleventh
# hand-maintained copy, found while writing this gate (#435).
check_module_list .devcontainer/post-create.sh \
    "^[[:space:]]*mods='" 1 "post-create.sh mods= (devcontainer)"

# docker/Dockerfile.ns3 carries TWO --enable-modules lines and only one is an
# allowlist for this gate:
#   - the `anthocnet` stage list must name every vendored module (missing
#     `oracle` here is what broke every v1.5.0 ns-3 release image, #435);
#   - the `base` stage list is a DELIBERATE exception: it is the stock-ns-3
#     build the manet-baselines control (#24) runs on, and must NOT include
#     any vendored module — no AntHocNet code in the control binary.
df=docker/Dockerfile.ns3
if need_file "$df"; then
    dflines=$(grep -E -e "--enable-modules='" "$df" || true)
    dfn=$(count_lines "$dflines")
    if [ "$dfn" -ne 2 ]; then
        echo "FAIL [allowlists]: Dockerfile.ns3 — expected exactly 2 --enable-modules lines"
        echo "  (stock base build for #24 + module build), found $dfn. If a stage was"
        echo "  added/moved, update check-allowlists.sh (#435)."
        fail=1
    else
        optline=$(printf '%s\n' "$dflines" | grep 'anthocnet' || true)
        stockline=$(printf '%s\n' "$dflines" | grep -v 'anthocnet' || true)
        if [ "$(count_lines "$optline")" -ne 1 ] || [ "$(count_lines "$stockline")" -ne 1 ]; then
            echo "FAIL [allowlists]: Dockerfile.ns3 — expected one module-build list (with"
            echo "  anthocnet) and one stock-base list (without, the #24 control). Found:"
            printf '%s\n' "$dflines" | sed 's/^/    /'
            fail=1
        else
            optlist=$(printf '%s\n' "$optline" | sed "s/.*'\([^']*\)'.*/\1/")
            stocklist=$(printf '%s\n' "$stockline" | sed "s/.*'\([^']*\)'.*/\1/")
            for m in $modules; do
                case ";$optlist;" in
                    *";$m;"*) ;;
                    *)
                        echo "FAIL [allowlists]: module '$m' missing from Dockerfile.ns3 module-build"
                        echo "  --enable-modules (this is the #435 release-image break): $optlist"
                        fail=1
                        ;;
                esac
                case ";$stocklist;" in
                    *";$m;"*)
                        echo "FAIL [allowlists]: vendored module '$m' found in Dockerfile.ns3's STOCK base"
                        echo "  --enable-modules — that build is the #24 manet-baselines control and must"
                        echo "  stay free of AntHocNet/vendored code: $stocklist"
                        fail=1
                        ;;
                esac
            done
        fi
    fi
fi

# --- check class 2: protocol-arm awk alternations -------------------------
# Both metric-row filters keep rows via `$1 ~ /^(a|b|c)$/`; an arm missing
# there is dropped SILENTLY (from the published block, or from both sides of
# the determinism diff — #421). Every dispatched arm must be in each.
check_arm_alternation() {
    local file=$1 label=$2 alts n alt a
    need_file "$file" || return 0
    alts=$(grep -oE '\^\([a-z|]+\)\$' "$file" || true)
    n=$(count_lines "$alts")
    if [ "$n" -ne 1 ]; then
        echo "FAIL [allowlists]: $label — expected exactly 1 '^(a|b|c)\$' arm alternation in $file, found $n."
        echo "  If the filter moved or changed shape, update check-allowlists.sh (#435)."
        fail=1
        return 0
    fi
    alt=${alts#^(}
    alt=${alt%)\$}
    for a in $arms; do
        case "|$alt|" in
            *"|$a|"*) ;;
            *)
                echo "FAIL [allowlists]: arm '$a' missing from $label ($file): ($alt)"
                echo "  A missing arm is dropped silently, not reported (#421)."
                fail=1
                ;;
        esac
    done
}

check_arm_alternation .github/workflows/paper-benchmark.yml "##BENCH## awk arm filter"
check_arm_alternation ns3/tools/check-determinism.sh "check-determinism.sh filter_rows()"

# --- check class 3: ##MARKER## re-emit list -------------------------------
# paper-benchmark.yml's compact-block step re-emits each harness marker via
# `grep '^##NAME##' ...` so a cheap log tail carries everything. A marker
# emitted but not re-emitted is unreachable from that tail — the class hit by
# ##MATCH## and again by ##ORACLE## (#423): "emitting it is only half of
# shipping it".
pb=.github/workflows/paper-benchmark.yml
if need_file "$pb"; then
    reemit=$(grep -oE "grep '\^##[A-Z]+##'" "$pb" | grep -oE '[A-Z]+' | sort -u || true)
    if [ -z "$reemit" ]; then
        echo "FAIL [allowlists]: found no \"grep '^##NAME##'\" re-emit lines in $pb —"
        echo "  the compact-block step moved or changed shape; update check-allowlists.sh (#435)."
        fail=1
    else
        for mk in $markers; do
            if ! printf '%s\n' "$reemit" | grep -qx "$mk"; then
                echo "FAIL [allowlists]: ##$mk## is emitted by $harness but not re-emitted in"
                echo "  $pb's compact block — unreachable from a cheap log tail (#423)."
                fail=1
            fi
        done
    fi
fi

if [ "$fail" -ne 0 ]; then
    echo "FAIL [allowlists]: at least one hand-maintained allowlist disagrees with the tree (#435)."
    exit 1
fi
echo "PASS [allowlists] every module/arm/marker allowlist matches the tree-derived ground truth"
