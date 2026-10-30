# The comparison harness: running it and adding a protocol

`routing-compare` (still also built as `anthocnet-compare`) is the ns-3
program behind every MANET-family number in this repository. It runs several routing protocols ("arms") on the **same
seeds**, with the same mobility, the same traffic and the same channel. It
reports per-seed rows that pair across arms, so a difference between two
protocols carries a confidence interval rather than an anecdote.

This page is for anyone who wants to use the harness: to rerun a published
cell, to compare an existing protocol, or to add their own. The decisions
behind it are in [methodology.md](benchmarks/methodology.md) and the metric
definitions are in [metrics.md](benchmarks/metrics.md).

[← Benchmark index](benchmarks.md) · [Methodology](benchmarks/methodology.md) · [Metrics](benchmarks/metrics.md) · [v2.5.0 comparators](benchmarks/v2.5.0-comparators.md)

> **Status: protocol-agnostic since v2.6.0**
> ([ADR-0027](adr/0027-the-comparison-harness-is-protocol-agnostic.md)). The
> harness is its own ns-3 module, `routing-bench`, which links only stock ns-3
> and names no protocol. Every arm registers itself from its own module, so
> the harness builds and runs without AntHocNet. `anthocnet-compare` is the
> same program under its old name, kept at least through v3.x. The move
> reproduced every committed MANET-family cell byte for byte
> ([control](benchmarks/v2.6.0-harness-control.md)). Shipping it as
> its own package is planned for v2.7.0 ([Packaging](#packaging-and-what-is-planned)).

## What it measures

One invocation runs every arm in `--protocols` on seeds
`--firstRun … --firstRun+--runs−1`. For each seed and arm it builds a fresh
ns-3 world: nodes, mobility, Wi-Fi channel and CBR or TCP flows. It installs
the arm, runs it and measures it with FlowMonitor and the harness's own trace
sinks. Arms never share a process state that could leak between them. Their
randomness is pinned through `AssignStreams`, so seed *k* gives every arm the
same node trajectories and flow schedule
([#352](https://github.com/danieljoppi/AntHocNet/issues/352)).

Built-in arms, as of v2.5.0:

| arm | what it is | module |
|---|---|---|
| `anthocnet` | this project's protocol | `anthocnet` |
| `aodv`, `olsr`, `dsdv` | stock ns-3 | `routing-bench` (stock arms) |
| `aomdv` | multipath AODV | `aomdv` (vendored) |
| `gpsr`, `gpcr`, `gpsr3d` | geographic routing and its VANET/FANET modes | `gpsr` (vendored) |
| `hwmp` | 802.11s mesh path selection | `routing-bench` (stock ns-3 `mesh`) |
| `oracle` | shortest-path ground truth, an upper bound | `oracle` |
| `ara`, `termite`, `qrouting`, `beeadhoc` | ant-colony, stigmergic, learned and bee-inspired comparators (`beeadhoc`: v2.7.0, #589) | `adaptive` |

`routing-compare --PrintHelp` lists the arms actually installed: the
`--protocols` help is built from the registry. With only `routing-bench`
installed, the harness has the four stock arms.

Scenario presets (`--scenario=paper|fanet|vanet|disaster|…`) set the field,
mobility and channel of each network family. Any flag overrides a preset.

## Running it

With the modules installed into an ns-3 tree (`make install-ns3
NS3DIR=/path/to/ns-3`, or the release's `anthocnet-ns3-modules-<ver>.tar.gz`
unpacked into `contrib/`; `routing-bench` alone is enough for the stock arms):

```bash
cd /path/to/ns-3
./ns3 configure --enable-examples --enable-tests && ./ns3 build
./ns3 run "routing-compare --scenario=paper --runs=10 --time=900 \
    --protocols=anthocnet,aodv,olsr --diag"
```

Useful flags:

- `--nNodes`, `--areaX/--areaY`, `--range`;
- `--mobility=rwp|ssrwp|gaussmarkov|manhattan|trace`;
- `--propagation=range|tworay|nakagami|urban`;
- `--flows`, `--cbrBps`, `--transport=udp|tcp`, `--flowsFile` (explicit flows);
- `--firstRun` to split seeds across jobs;
- any `--ns3::<TypeId>::<Attribute>=<value>` to change one protocol's parameter.

`./ns3 run "routing-compare --PrintHelp"` lists everything.

The output is a summary table plus machine-readable marker lines:

- `##CONFIG##` is the effective configuration.
- `##RUN## <seed> <arm> pdr delay delay99 thrput nrl …` is the per-seed row
  that pairing uses.
- `##ROUTE##`, `##DROPID##`, `##COMMON##` and `##GOODPUT##` cover route
  stability, the drop-cause identity, the identity-matched packet set and
  TCP goodput.
- `# drops` is the drop-cause book, which must sum to about 100 %.

[metrics.md](benchmarks/metrics.md) defines every one of them. Treat the
markers as the interface: the tools below read them, never the human table.

## Reading the results

Never compare numbers by eye. The scripts do the arithmetic and the noise call:

| tool | does |
|---|---|
| `tools/bench/scenario_check.py preflight …` | checks a configuration *before* dispatch: partitioned field, saturated channel, single-hop degeneracy |
| `tools/bench/scenario_check.py results FILE` | plausibility checks on a result: PDR bounds, the drop book closing, delay99 ≥ mean |
| `tools/bench/bench_parse.py --ab A B --proto X` | paired per-seed deltas of one arm between two files, with t and bootstrap CIs and a noise verdict |
| `tools/bench/comparator_view.py` | arm-versus-arm readings: anchors, and arms paired against committed control cells |
| `tools/bench/campaign.py plan/dispatch/collect` | a set of cells × arms run on the `benchmark-cell` workflow, throttled, then collected |

## Adding a protocol

There are two ways in, depending on what you are bringing.

### Your own ns-3 routing module

If your protocol already is an ns-3 `Ipv4RoutingProtocol` with an
`Ipv4RoutingHelper`, it needs no rewrite. Vendor it like
`ns3/baselines/aomdv/` or `ns3/baselines/gpsr/`: its own directory, a
`CMakeLists.txt` built with `build_lib`, and a README carrying the fidelity
sheet. Then register it, as described [below](#registering-an-arm).

### A per-hop, table-driven arm on the `adaptive` base

For a protocol written from a paper that keeps a per-neighbour table (ant
colony, stigmergic, Q-learning-style), `ns3/baselines/adaptive/` gives you a
base class, `ns3::adaptive::RoutingBase`, that does all the ns-3 plumbing.
The arm writes only its policy. ARA, Termite and Q-routing are each one file
pair on top of it.

**What the base does for you:**

| plumbing | detail |
|---|---|
| control channel | UDP sockets per interface, unicast and broadcast, on the arm's port. The harness counts it as control traffic automatically |
| no-route hold | a packet without a next hop waits in a bounded queue (64 packets, 30 s) and is released when the arm learns a route, or dropped as a route drop |
| previous hop | `PrevHopTag` tells every hop which neighbour sent the packet, which ns-3's `RouteInput` does not |
| link failure | MAC retry-limit drops and unanswered ARP are turned into `OnLinkFailure(neighbor)`, and the lost data packet is recovered and re-routed. Traces `MacReinject` and `ArpReinject` keep the drop book honest: an arm that re-routes is booked per packet, by terminal fate ([metrics](benchmarks/metrics.md#per-packet-terminal-fate-on-the-adaptive-arms-761), #761) |
| randomness | one pinned random stream per node (`AssignStreams`) |

**What the arm implements:**

| hook | called when |
|---|---|
| `ControlPort()` | once: the arm's UDP port |
| `SelectNextHop(dst, src, prev, p)` | a data packet needs a next hop; return `Ipv4Address()` for "none" |
| `OnDataReceived(p, header, prev, backtracked)` | a data packet arrived from neighbour `prev`; learn from it, return false to drop it |
| `OnDataForwarded(p, header, next)` | optional: a data packet is being handed to `next` |
| `OnNoRouteInTransit(…)` | optional: no route at an intermediate node; return true to dispose of the packet yourself |
| `StartDiscovery(dst)` | data is held for `dst` and no route exists |
| `RecvControl(p, from, receiver)` | a control message arrived |
| `OnLinkFailure(neighbor)` | the link to `neighbor` is gone |
| `KnownNeighbors()` | the neighbours the failure resolver may match |

The base's services cover sending and flushing:

- `BroadcastControl`, `BroadcastControlJittered` and `UnicastControl` send
  control messages.
- `FlushQueue(dst)` releases held packets once you have a route.
- `DropQueued(dst)` gives up on them.
- `Rng()` is the pinned random stream.

`adaptive-tables.h` holds reusable pheromone tables (geometric or exponential
decay, bounded with floor, ceiling and pruning) and the proportional draw.
`ControlHeader` is a 24-byte control header with type, hops, ttl, seq, origin,
target and a value.

The module links only stock ns-3 (core, network, internet, wifi). Start from
[`qrouting-routing-protocol.cc`](https://github.com/danieljoppi/AntHocNet/blob/main/ns3/baselines/adaptive/model/qrouting-routing-protocol.cc),
the smallest complete arm (about 270 lines), and install it with `AdaptiveHelper("ns3::adaptive::<YourType>")`.

### Registering an arm

An arm is a class derived from `ns3::bench::Arm`
([`routing-bench-arm.h`](https://github.com/danieljoppi/AntHocNet/blob/main/ns3/routing-bench/model/routing-bench-arm.h)),
created fresh for every (seed, arm) run. Three hooks are required:

- `Name()`, the `--protocols` token;
- `InstallRouting(internet, run)`, which sets your routing helper on the stack;
- `AssignStreams(run, stream)`, which pins your protocol's random streams and
  returns how many it took (#352).

The optional hooks cover everything else the harness used to special-case:
own devices (`hwmp`), post-stack wiring (`gpsr`), trace connections, refused
sends added back to the offered load (`oracle`, `olsr`), extra diagnostics,
self-checks and the replay. The stock arms in
[`stock-arms.cc`](https://github.com/danieljoppi/AntHocNet/blob/main/ns3/routing-bench/helper/stock-arms.cc)
and the module arms are the worked examples; Q-routing's is a dozen lines
([`adaptive-bench-arms.cc`](https://github.com/danieljoppi/AntHocNet/blob/main/ns3/baselines/adaptive/helper/adaptive-bench-arms.cc)).

To join the harness, your module ships one file,
`helper/<module>-bench-arms.cc`, defining
`ns3::bench::RegisterArms_<module>()` (hyphens become underscores), which
calls `RegisterArm("<name>", "<summary>", &MakeYourArm)` for each arm. Compile
it into your module only when `routing-bench` is installed and enabled, the way
[`adaptive`'s CMakeLists](https://github.com/danieljoppi/AntHocNet/blob/main/ns3/baselines/adaptive/CMakeLists.txt)
does. `routing-compare` finds the file at configure time, links your module and
calls the function at start-up. No harness source, check script or workflow
changes.

What still needs a line: your module in the `--enable-modules` lists
(`tools/checks/check-allowlists.sh` derives the module set from the tree and
fails on a list that is missing it).

## The gates before a number counts

A protocol this project did not design must clear three gates before its
numbers are published (AGENTS.md, Conventions). These keep comparisons honest:
two vendored arms once compiled, passed CI and forwarded nothing
([#425](https://github.com/danieljoppi/AntHocNet/issues/425),
[#416](https://github.com/danieljoppi/AntHocNet/issues/416)).

1. **Fidelity sheet.** Every parameter from the paper with its section, every
   value the paper does not give marked as a repo choice, and every deviation
   with its reason. The model is the
   [`adaptive` README](https://github.com/danieljoppi/AntHocNet/blob/main/ns3/baselines/adaptive/README.md).
2. **Delivery smoke** (`tools/checks/check-arm-delivery.sh <ns3-dir>`, on
   every PR; [#439](https://github.com/danieljoppi/AntHocNet/issues/439)).
   Every arm in `routing-compare`'s `--protocols` help runs on a small static multi-hop field.
   It must deliver above a floor, use multi-hop paths, and close its drop book.
3. **Anchor.** The arm must reproduce its own paper's headline trend on a
   scenario matching the paper's. The rule is fixed in a pre-registration page
   *before* the run. A miss ships as a written infeasibility verdict, not as
   numbers.

   The [v2.5.0 comparators](benchmarks/v2.5.0-comparators.md) are the worked
   example: ARA passed; Termite and Q-routing missed and shipped as verdicts.

## Packaging and what is planned

**Today (v2.6.0):**

- The release ships `anthocnet-ns3-modules-<ver>.tar.gz`, six ns-3 contrib
  modules to unpack into `contrib/`: `routing-bench` (the harness and the
  stock arms), `anthocnet`, and the comparison modules `aomdv`, `gpsr`,
  `oracle` and `adaptive`. Keep `routing-bench` and drop the rest to run the
  harness on the stock arms alone, or add your own arm module beside it.
- The `adaptive` module also works on its own in any ns-3 ≥ 3.36 tree. Copy
  `contrib/adaptive` alone and use `AdaptiveHelper` in your own program.

**Planned** (epic [#764](https://github.com/danieljoppi/AntHocNet/issues/764)):

- **v2.7.0:** the harness and the `adaptive` arms ship as their own release
  packages, the readers as a Python package with a versioned marker contract,
  and this guide becomes a bring-your-own-protocol tutorial with an arm
  template.

See the [roadmap](roadmap.md) for the exit criteria.

## Citing

Cite the harness and the comparators through the release DOI of the version
you used. The version DOIs are in
[CONTRIBUTING.md](https://github.com/danieljoppi/AntHocNet/blob/main/CONTRIBUTING.md#doi-record);
v2.5.0 is `10.5281/zenodo.23748858`. The concept DOI in `CITATION.cff` always
resolves to the latest release. Name the arms and the version: a number
measured at one version is not guaranteed at another
([provenance](benchmarks/methodology.md#provenance-which-version-a-number-was-measured-at)).
