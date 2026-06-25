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

The test suite round-trips the `AntHeader` serializer (the riskiest adapter
seam) without needing a full simulation.

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
  examples/anthocnet-example.cc
  test/anthocnet-test-suite.cc
  CMakeLists.txt                       ns-3.36+ build
  wscript                              ns-3 < 3.36 build
```

## Notes

- Ant control packets use UDP port 6900.
- Metric parity with the NS-2 build is **not** guaranteed: the MAC/PHY models
  differ. Treat cross-simulator comparison as a re-validation of behaviour, not
  a bit-for-bit port.
