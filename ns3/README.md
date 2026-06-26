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
mobility and traffic, same RNG run) under each routing protocol and prints
packet-delivery ratio, mean delay and throughput from a FlowMonitor:

```bash
# requires aodv, olsr, dsdv and flow-monitor enabled
./ns3 configure --enable-examples \
  --enable-modules='anthocnet;wifi;mobility;applications;aodv;olsr;dsdv;flow-monitor;point-to-point'
./ns3 build
./ns3 run "anthocnet-compare --nNodes=20 --time=40 --area=300 --flows=5"
```

Example output:

```
protocol          tx      rx     PDR%   delay(ms)  thrput(kbps)
---------------------------------------------------------------
anthocnet        604     125     20.7        28.6          3.21
aodv             805     327     40.6        80.8          6.53
olsr             446     110     24.7         4.9          2.70
dsdv             556      93     16.7       384.9          2.28
```

Single-seed runs are noisy; average over seeds with `--seed=1,2,3,...` for a
stable comparison. Results vary by node density, mobility and traffic — this
is a re-validation harness, not a claim that any one protocol always wins.

Options: `--nNodes --time --area --speed --flows --seed --protocols`
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
