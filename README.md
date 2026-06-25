# AntHocNet

An ant-colony-optimization routing protocol for mobile ad-hoc networks,
implemented once as a **simulator-agnostic algorithm core** with thin adapters
for **NS-2** and **NS-3**.

The repository no longer bundles a copy of any simulator. You install AntHocNet
onto *your own* NS-2 or NS-3 tree:

- **NS-2** — installed as an idempotent, version-independent source patch
  (`ns-2.34` / `ns-2.35`).
- **NS-3** — installed as an additive `contrib/` module (ns-3.36+, with a
  `wscript` for older waf builds).

```
core/   simulator-agnostic C++ (no NS-2/NS-3 dependency) + unit tests
ns2/    thin Agent adapter + anchor-based source patch installer
ns3/    native Ipv4RoutingProtocol module
docs/   architecture and porting notes
```

## Why one core, two adapters

NS-2 and NS-3 are different architectures, so there is no single universal
patch. The algorithm (pheromone table, evaporation/reinforcement, ant
construction, routing decisions) lives in [`core/`](core) and is shared
verbatim. Each simulator gets only a thin adapter:

| | NS-2 | NS-3 |
|---|---|---|
| Integration | OTcl + `Agent`, pooled packet headers, **core-tree edits** | additive module subclassing `Ipv4RoutingProtocol` |
| Install | patch + recompile | drop-in + build |
| Packet header | POD `PacketHeaderClass` | `ns3::Header` |

See [docs/architecture.md](docs/architecture.md).

## Quick start

### Run the core unit tests

```bash
make test
```

(Builds `core/` with CMake and runs the ctest suite — no simulator needed.)

### Install on NS-2

```bash
make install-ns2 NS2DIR=/path/to/ns-allinone-2.3x/ns-2.3x
cd /path/to/ns-allinone-2.3x/ns-2.3x && make
```

Uninstall: `make uninstall-ns2 NS2DIR=...` (reverts the patch cleanly). Details
in [ns2/README.md](ns2/README.md).

### Install on NS-3

```bash
make install-ns3 NS3DIR=/path/to/ns-3-dev
cd /path/to/ns-3-dev && ./ns3 configure --enable-examples --enable-tests && ./ns3 build
./ns3 run anthocnet-example
```

Uninstall: `make uninstall-ns3 NS3DIR=...`. Details in
[ns3/README.md](ns3/README.md).

The NS-3 module also ships `anthocnet-compare`, which benchmarks AntHocNet
against AODV / OLSR / DSDV on an identical scenario (delivery ratio, delay,
throughput via FlowMonitor) — see [ns3/README.md](ns3/README.md#compare-against-aodv--olsr--dsdv).

## What changed from the original

The original project was a whole vendored `ns-allinone-2.34` snapshot with the
protocol buried inside it. This refactor:

- extracts the algorithm into a portable, tested `core/` library;
- replaces the NS-2-coupled, header-resident malloc'd pointer arrays with POD
  value types — removing a memory leak, a broadcast double-free, and an
  incorrect serialized packet size;
- fixes the pheromone-evaporation bug (competing links were never aged),
  widens the ant sequence number past 8 bits, and bounds the dedup history;
- ships the NS-2 integration as an idempotent, anchor-based patch instead of a
  forked simulator tree;
- adds a native NS-3 module.

History of the work is in the per-phase commits; design rationale is in
[docs/](docs).

## License

See [LICENSE](LICENSE). Original implementation by Daniel Henrique Joppi.
