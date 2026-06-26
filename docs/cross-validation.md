# NS-2 / NS-3 cross-validation

Both the NS-2 patch and the NS-3 module drive the *same* `core/` algorithm, so
they should exhibit the same routing **behaviour**. They will **not** produce
identical numbers: the two simulators ship different MAC/PHY models, queueing,
and timing, so cross-validation is a behavioural re-validation (does AntHocNet
discover routes and deliver in the same regime?), not a bit-for-bit match.

The shared algorithm itself is pinned down independently of either simulator by
the `core/` unit tests (including an in-memory multi-hop route-discovery test),
so this procedure checks the *adapters*, not the algorithm.

## Procedure

Pick one scenario (node count, area, traffic, time) and run it on both
simulators, then compare packet-delivery ratio and mean delay.

### NS-3 side

```bash
make install-ns3 NS3DIR=/path/to/ns-3-dev
cd /path/to/ns-3-dev
./ns3 configure --enable-examples \
  --enable-modules='anthocnet;wifi;mobility;applications;aodv;olsr;dsdv;flow-monitor;point-to-point'
./ns3 build

# AntHocNet only, averaged over 10 seeds (PDR %, delay ms, throughput kbps):
bash /path/to/AntHocNet/ns3/tools/cross-check.sh "$PWD" 10 7 500 50 1
```

`cross-check.sh NS3DIR [runs] [nNodes] [area] [time] [flows]` wraps
`anthocnet-compare --protocols=anthocnet` and prints the CSV row.

### NS-2 side

The NS-2 examples in [`ns2/tcl/`](../ns2/tcl) already run AntHocNet (e.g.
`1-simple.tcl` is a 7-node, 500x400 m scenario). After installing the patch and
rebuilding NS-2:

```bash
cd /path/to/ns-allinone-2.3x/ns-2.3x
ns /path/to/AntHocNet/ns2/tcl/1-simple.tcl     # writes simple-ant.tr
```

Compute packet-delivery ratio from the wireless trace (count application-layer
CBR packets sent vs received at the agent layer):

```bash
awk '
  $1=="s" && $4=="AGT" && $7=="cbr" { sent++ }
  $1=="r" && $4=="AGT" && $7=="cbr" { recv++ }
  END { if (sent) printf "NS-2 PDR: %.1f%% (%d/%d)\n", 100*recv/sent, recv, sent }
' simple-ant.tr
```

(For the new wireless trace format, the field positions differ; use
`$1=="s"`/`"r"`, the `AGT` trace level and `cbr` packet type accordingly.)

To match the NS-3 scenario, set `val(nn)`, `val(x)`, `val(y)`, `val(stop)` and
the CBR sources in the tcl to the same values you passed to `cross-check.sh`.

## What "agreement" means

Expect the same qualitative picture: routes are discovered after the first
data demand, delivery is non-zero in a connected topology and drops as the
network partitions, and delay grows with hop count. Absolute PDR/delay will
differ between simulators (and from AODV/OLSR/DSDV — see
[benchmarks.md](benchmarks.md)) because of the different lower layers. A large
*qualitative* divergence (e.g. one adapter never delivering in a connected
scenario) indicates an adapter bug, not a modelling difference, and is what
this check is meant to catch.
