# AntHocNet for NS-3

A native, additive NS-3 module implementing AntHocNet as an
`ns3::Ipv4RoutingProtocol`, on top of the shared simulator-agnostic
[`core/`](../core). No core ns-3 files are edited — installing just drops the
module (and `core/`) into `contrib/anthocnet`.

Targets ns-3.36+ (CMake). A `wscript` is included for older waf-based ns-3
(< 3.36).

## Install

```bash
# from the repository root
make install-ns3 NS3DIR=/path/to/ns-3-dev

# then (re)configure and build ns-3
cd /path/to/ns-3-dev
./ns3 configure --enable-examples --enable-tests
./ns3 build
```

## Run

```bash
./ns3 run anthocnet-example
./ns3 run "anthocnet-example --nNodes=15 --time=30"
```

## Test

```bash
./test.py -s anthocnet
```

The test suite has two cases: an `AntHeader` serialize/deserialize round-trip,
and a deterministic **multi-hop delivery** test over `SimpleNetDevice`s (a
3-node line with the end-to-end link black-listed, so traffic must be routed
through the middle node). The latter guards the real routing path — hello,
neighbour learning, reactive discovery, forwarding and delivery.

## Compare against AODV / OLSR / DSDV

`anthocnet-compare` runs the *same* mobile-ad-hoc scenario (identical layout,
mobility and traffic, same RNG run) under each routing protocol and reports the
metrics from the AntHocNet paper — packet-delivery ratio, **mean and
99th-percentile** end-to-end delay (the paper's QoS/jitter metric), throughput,
and **normalized routing load** (NRL = routing-control packets transmitted /
data packets delivered, counted uniformly at the IP layer):

```bash
# requires aodv, olsr, dsdv and flow-monitor enabled
./ns3 configure --enable-examples \
  --enable-modules='anthocnet;wifi;mobility;applications;aodv;olsr;dsdv;flow-monitor;point-to-point'
./ns3 build

# the paper's base scenario (50 nodes, 1500x300 m, RWP 20 m/s / 30 s pause,
# 20 CBR sources, 300 m range, 900 s), averaged over 5 RNG runs:
./ns3 run "anthocnet-compare --scenario=paper --runs=5"
# sweeps (paper Fig. 1/2): vary the area long edge, or the mobility pause time:
./ns3 run "anthocnet-compare --scenario=paper --areaX=2500 --runs=5"
./ns3 run "anthocnet-compare --scenario=paper --pause=0 --runs=5"
```

Example output:

```
protocol        PDR%  delay(ms)  delay99(ms)  thrput(kbps)   NRL
-----------------------------------------------------------------
anthocnet       92.4       41.2        180.0          0.49  1.85
aodv            88.1       55.7        430.0          0.47  2.40
olsr            74.6        3.1         22.0          0.40  3.10
dsdv            61.2      120.4        980.0          0.33  1.20
```

Single-seed runs are noisy; average over runs with `--runs=N` for a stable
comparison. Results vary by node density, mobility and traffic — this is a
re-validation harness, not a claim that any one protocol always wins.

Options: `--scenario=paper --nNodes --time --area --areaX --areaY --speed
--pause --range --flows --cbrBps --runs --protocols --csv`. (`--scenario=paper`
sets the paper defaults; any explicit flag overrides them, which is how the
area/pause sweeps above work. The numbers above are illustrative.)
(e.g. `--protocols=anthocnet,aodv`).

## Uninstall

```bash
make uninstall-ns3 NS3DIR=/path/to/ns-3-dev
cd /path/to/ns-3-dev && ./ns3 build
```

## Using it in a script

```cpp
#include "ns3/anthocnet-helper.h"

AntHocNetHelper anthocnet;
anthocnet.Set("HelloInterval", TimeValue(Seconds(1.0)));
InternetStackHelper internet;
internet.SetRoutingHelper(anthocnet);
internet.Install(nodes);
```

Attributes exposed on `ns3::anthocnet::RoutingProtocol`:
`HelloInterval`, `ProactiveInterval`, `Alpha`, `Beta`, `Gamma`.

## Layout

```
ns3/
  model/
    anthocnet-routing-protocol.{h,cc}  Ipv4RoutingProtocol over core
    anthocnet-packet.{h,cc}            ns3::Header <-> core::AntMessage
    anthocnet-rqueue.{h,cc}            pending-packet queue (GC + cap)
    anthocnet-adapters.{h,cc}          IClock/IRng ports over Simulator/RNG
  helper/anthocnet-helper.{h,cc}       Ipv4RoutingHelper
  examples/anthocnet-example.cc        minimal wifi adhoc demo
  examples/anthocnet-compare.cc        vs AODV/OLSR/DSDV (FlowMonitor metrics)
  test/anthocnet-test-suite.cc         header round-trip + multi-hop delivery
  CMakeLists.txt                       ns-3.36+ build
  wscript                              ns-3 < 3.36 build
```

## Notes

- Ant control packets use UDP port 6900.
- Metric parity with the NS-2 build is **not** guaranteed: the MAC/PHY models
  differ. Treat cross-simulator comparison as a re-validation of behaviour, not
  a bit-for-bit port.
