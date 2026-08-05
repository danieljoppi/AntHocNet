#!/usr/bin/env python3
# SPDX-License-Identifier: GPL-2.0-only
# Copyright (C) 2026 Daniel Henrique Joppi

"""Seed-independence gate (issue #352).

A benchmark run's realisation must be a function of its SEED ALONE — not of
where the run happened to sit in the process that produced it.

ns-3 hands every RandomVariableStream its stream index from a *global* counter
at construction time, and RngSeedManager::SetSeed/SetRun do not reset that
counter. anthocnet-compare builds a whole scenario per run and executes many
runs in one process (a protocol-major loop), so before #352 run N drew from
whatever stream indices runs 1..N-1 had left behind. Two consequences, both
silent:

  * splitting a campaign differently (7+7+6 vs 4+4+4+4+4 over the same 20
    seeds) changed the numbers for the same seed — the first protocol matched
    only on seeds 1-4;
  * reordering --protocols changed the numbers for every protocol but the
    first, from seed 1 on.

Campaign CSVs merged across differently-shaped invocations were therefore not
comparing like with like. The fix pins every stream-consuming helper to an
index inside a per-seed block (`kStreamStride` in ns3/examples/*.cc). This
script is the regression gate for that property; it checks two things that do
NOT imply each other:

  structure  the same seeds, run as one invocation vs. split across several,
             must produce byte-identical per-seed rows;
  order      the same seeds with --protocols reversed must produce
             byte-identical per-seed rows.

The structure case alone would pass an implementation that still leaked the
protocol offset (protocol k's block would just be shifted consistently in both
invocations), which is exactly the half of the bug that corrupted every
non-first protocol. Hence two cases.

Compares the harness's per-seed ##RUN## rows (#128), which carry the metrics
downstream tooling actually consumes, keyed by (seed, protocol).

isl-grid received the same pinning fix but exposes no --firstRun, so the
structure half cannot be expressed against it; it is covered by the shared
mechanism plus its own determinism gate (ns3/tools/check-determinism.sh).

Needs an ns-3 tree with the AntHocNet module installed, configured and built
with examples enabled. Runs on stdlib only:

    python3 ns3/tools/check-seed-independence.py /opt/ns-3
"""

import argparse
import subprocess
import sys

# Small, dense, connected field — the same shape as ci.yml's e2e delivery smoke.
# The gate is about identity, not about the numbers, so the cheapest scenario
# that still exercises mobility, wifi, traffic and routing RNG will do.
SCENARIO = "--nNodes=8 --area=150 --flows=2"
PROTOCOLS = ["anthocnet", "aodv"]


def run_compare(ns3dir, protocols, first_run, runs, time_s):
    """Run anthocnet-compare once; return {(seed, proto): row} from ##RUN##."""
    cmd = (
        f"anthocnet-compare {SCENARIO} --time={time_s} "
        f"--protocols={','.join(protocols)} "
        f"--firstRun={first_run} --runs={runs}"
    )
    print(f"[seed-independence] ./ns3 run \"{cmd}\"")
    proc = subprocess.run(
        ["./ns3", "run", cmd],
        cwd=ns3dir,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        check=False,
    )
    if proc.returncode != 0:
        print("\n".join(proc.stdout.splitlines()[-40:]), file=sys.stderr)
        raise SystemExit(f"FAIL [seed-independence]: '{cmd}' exited {proc.returncode}")

    rows = {}
    for line in proc.stdout.splitlines():
        if not line.startswith("##RUN##"):
            continue
        fields = line.split()[1:]  # drop the ##RUN## marker
        seed, proto = fields[0], fields[1]
        rows[(seed, proto)] = " ".join(fields[2:])
    if not rows:
        raise SystemExit(
            f"FAIL [seed-independence]: '{cmd}' produced no ##RUN## rows "
            "(#28-style silent empty result)"
        )
    return rows


def compare(case, reference, other):
    """Print per-key differences; return the number of problems found."""
    problems = 0
    missing = sorted(set(reference) - set(other))
    extra = sorted(set(other) - set(reference))
    for key in missing:
        print(f"  [{case}] missing row for seed={key[0]} proto={key[1]}")
        problems += 1
    for key in extra:
        print(f"  [{case}] unexpected row for seed={key[0]} proto={key[1]}")
        problems += 1
    for key in sorted(set(reference) & set(other)):
        if reference[key] != other[key]:
            print(f"  [{case}] seed={key[0]} proto={key[1]} differs:")
            print(f"      reference: {reference[key]}")
            print(f"      this run : {other[key]}")
            problems += 1
    return problems


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("ns3dir", help="path to the built ns-3 tree")
    parser.add_argument(
        "--seeds", type=int, default=4, help="number of seeds to check (default 4)"
    )
    parser.add_argument(
        "--time", type=float, default=30.0, help="simulated seconds per run (default 30)"
    )
    args = parser.parse_args()

    if args.seeds < 2 or args.seeds % 2 != 0:
        raise SystemExit("--seeds must be an even number >= 2 (it is split in half)")
    half = args.seeds // 2

    # Reference: every seed in one invocation, protocols in the declared order.
    reference = run_compare(args.ns3dir, PROTOCOLS, 1, args.seeds, args.time)

    # Case 1 — structure: the same seeds, split across two invocations.
    split = run_compare(args.ns3dir, PROTOCOLS, 1, half, args.time)
    split.update(run_compare(args.ns3dir, PROTOCOLS, 1 + half, half, args.time))

    # Case 2 — order: the same seeds, protocol list reversed.
    reversed_order = run_compare(
        args.ns3dir, list(reversed(PROTOCOLS)), 1, args.seeds, args.time
    )

    problems = compare("structure", reference, split)
    problems += compare("order", reference, reversed_order)

    if problems:
        print(
            f"\nFAIL [seed-independence]: {problems} row(s) depend on something "
            "other than the seed.\n"
            "  A run's realisation must be a function of its seed alone. If it\n"
            "  is not, campaigns merged across differently-shaped invocations\n"
            "  are not comparing like with like, and per-seed pairing across\n"
            "  protocols is invalid. Usually a newly added stream-consuming\n"
            "  helper in ns3/examples/ that nothing calls AssignStreams() on\n"
            "  from the per-seed base. See #352 and\n"
            "  docs/benchmarks/methodology.md 'Randomness and seeds'.",
            file=sys.stderr,
        )
        return 1

    print(
        f"\nPASS [seed-independence]: {len(reference)} per-seed row(s) identical "
        "across split structures and across protocol order"
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
