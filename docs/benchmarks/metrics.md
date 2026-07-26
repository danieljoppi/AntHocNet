# Benchmark metrics

What each column of every benchmark table means, and what it is *not* safe to
conclude from it. Part of the [benchmark index](../benchmarks.md); the harness,
build profiles and validation anchors are in [methodology.md](methodology.md).

AntHocNet measured against the standard NS-3 MANET routing protocols
(**AODV**, **OLSR**, **DSDV**) on an identical scenario — same node layout,
mobility and traffic, driven from the same RNG runs so every protocol sees the
same realisations. Metrics come from an NS-3 `FlowMonitor`:

- **PDR** — packet-delivery ratio (received / sent), %, over the CBR data flows.
- **mean delay** — average end-to-end delay of delivered packets, ms.
- **99th-percentile delay** — tail of the delivered-packet delay distribution.
  Caveat (#57/#54): across protocols with very different PDR this is
  survivorship-confounded — the extra packets a protocol delivers are precisely
  the hard/late ones — so prefer the offered-load percentiles for cross-protocol
  tail claims.
- **jitter** — mean delay jitter over delivered packets (FlowMonitor
  `jitterSum`), ms. The original paper's QoS metric (avg delay + jitter).
- **dOff90** (`delay_off50_ms`/`delay_off90_ms` in the CSV) — delay at the
  50th/90th percentile of *offered* (sent) packets, counting an undelivered
  packet as infinite delay (`inf` / `-1` in the CSV when less than that fraction
  arrived). Monotone-honest: dropping hard packets cannot improve it.
- **throughput** — application bytes delivered per second, kbps.
- **NRL** — normalized routing load: routing-control packets transmitted (each
  hop) per data packet delivered, counted uniformly at the IP layer.
- **nrl_bytes** — byte-normalized routing load: routing-control *bytes*
  transmitted (each hop, same IP-layer counting point as NRL) per data byte
  delivered. Complements packet-count NRL, which flatters protocols that send
  fewer, larger messages — an AntHocNet ant carries its visited path (up to
  `maxPathLength` addresses) while an AODV RREQ is small and fixed. The measured
  packet-vs-byte comparison run is tracked in #132.

## Energy (#209, NS-3 only)

Radio energy comes from an ns-3 `BasicEnergySource` on every node plus a
`WifiRadioEnergyModel` on every wifi device, installed **identically for all
four protocols** from the same parameters, so the joule columns are comparable
across arms exactly the way PDR and NRL are.

- **energy_j** — total energy consumed over the run, summed over all nodes, J.
- **energy_per_pkt_j** — `energy_j` / data packets delivered, **J per delivered
  packet**. The efficiency figure, and the one that stays comparable across
  protocols sitting at different PDRs: every node's radio is powered for the
  same wall-clock time whatever the protocol does, so total joules alone mostly
  measures the run length, while joules-per-delivered-packet prices the control
  airtime that NRL counts. 0 when nothing was delivered (same convention as
  NRL).
- **energy_res_min_j / energy_res_mean_j / energy_res_sd_j** — residual energy
  across nodes at end of run: minimum, mean, and sample stddev, J. This is
  where routing *fairness* shows up — a protocol that funnels every flow
  through the same relay drains that node first and partitions the network
  early, which PDR and delay cannot see. Read the **spread** (`sd`, and
  `mean − min`), not the absolute level.
- **energy_init_j** — the initial per-node energy the run was configured with
  (`--energyJ`), carried in the CSV so `residual ≤ initial` is checkable
  downstream (`scenario_check.py results`).
- **first_death_s** — sim time at which the first node's energy source raised
  ns-3's depletion event, s. **Sentinel `-1` = no node died.** Note the ns-3
  semantics: `BasicEnergySource` raises depletion at
  `BasicEnergyLowBatteryThreshold` (10 % of initial energy remaining), not at
  literally zero, after which `WifiRadioEnergyModel` draws no further current —
  so "death" means "battery exhausted for routing purposes". Averaged over the
  runs that saw a death; `-1` when no run did.

### Parameters and their provenance

`--energyJ` (initial energy per node) defaults to **5000 J**, deliberately
sized so that **no node dies in a normal run**: a dying node makes PDR
energy-limited and silently changes the meaning of every other metric in the
taxonomy. Upper bound on one node's draw is the transmit current for the whole
run (0.380 A × 3.0 V = 1.14 W), so the longest scenario the harness runs
(900 s — `--scenario=paper` and `=thesis`) cannot consume more than 1026 J per
node; the realistic idle-dominated draw is ≈0.82 W, i.e. ≈740 J. 5000 J is
≈4.9× that hard bound while remaining a physically plausible cell
(5000 J / 3.0 V = 463 mAh). Raise it for longer runs; lower it to provoke node
deaths deliberately.

The radio currents are ns-3's `WifiRadioEnergyModel` defaults, **restated
explicitly rather than inherited silently** (the [configuration.md](../configuration.md)
provenance rule — unsourced defaults caused #88, #169 and #173) and overridable
with `--txCurrentA` / `--rxCurrentA` / `--idleCurrentA` / `--voltageV`:

| Parameter | Default | Source |
|-----------|---------|--------|
| `--txCurrentA` | 0.380 A | P_tx = 1.14 W at 0 dBm ÷ 3.0 V |
| `--rxCurrentA` | 0.313 A | P_rx = 0.94 W ÷ 3.0 V |
| `--idleCurrentA` | 0.273 A | P_idle = 0.82 W ÷ 3.0 V (also applied to the CCA-busy and switching states, as ns-3 does) |
| `--voltageV` | 3.0 V | `BasicEnergySource` default supply voltage |
| (sleep) | 0.033 A | P_sleep = 0.10 W ÷ 3.0 V; never reached — `AdhocWifiMac` has no power-save state here |

The powers are measurements of a **single-antenna 802.11n NIC** reported in
D. Halperin, B. Greenstein, A. Sheth, D. Wetherall, *"Demystifying 802.11n
power consumption"*, HotPower'10 — the citation ns-3 itself gives in
`src/wifi/model/wifi-radio-energy-model.h`. The values are unchanged across
every ns-3 release the CI matrix covers (3.36–3.48).

### Caveats

- **Energy is model-dependent and not comparable across PHY configurations.**
  The numbers are a function of the radio currents, the supply voltage and the
  PHY/rate/propagation setup, not of the routing protocol alone. Compare energy
  columns only between arms of the *same* harness configuration; never against
  another paper's joules, and never across `--propagation` or `--rateManager`
  settings.
- **The modelled NIC is 802.11n; this harness runs 802.11b DCF at 2 Mbit/s**
  (#51). Absolute joules are therefore an internally consistent yardstick
  across the four protocols, not a measurement of the paper's radio.
- **Idle current is 72 % of transmit current**, so the constant always-on draw
  dominates the absolute totals and the residual *level*. The
  routing-attributable component is the *difference* between arms — read deltas
  and the residual spread, not the absolute joule figure.
- **NS-3 only.** The NS-2 adapter has no energy instrumentation; see
  [cross-validation.md](../cross-validation.md).

## Packet reordering (#212, NS-3 only)

Stochastic multipath forwarding delivers packets out of order **by
construction**: AntHocNet picks the next hop per packet, pheromone-weighted,
across several paths of differing delay, so a packet sent later on a shorter
path can overtake one sent earlier on a longer one.
[configuration.md](../configuration.md) already names this as the cost of a low
`betaData` ("lower = more spread — and more reordering"); these columns measure
it. **Read a non-zero AntHocNet figure as the mechanism working as designed, not
as a fault.** It is a trade, not a defect: what it buys is the load spreading and
the route redundancy that the PDR and NRL columns report. The number that
matters is whether the reordering an application would feel is worth those
gains — which is exactly the question [#179](https://github.com/danieljoppi/AntHocNet/issues/179) (`betaData` 2 → the thesis's 20)
has to answer, and could not before this metric existed.

`FlowMonitor` reports per-flow counts and delays, never per-packet order, so
these come from an application-level sequence number instead: the ns-3
`OnOffApplication` sources set `EnableSeqTsSizeHeader`, and every `PacketSink`
reads the sequence number off each delivered datagram. **Packet size is
unchanged** — ns-3 builds the 20-byte `SeqTsSizeHeader` *inside* the configured
64-byte `PacketSize`, so the datagram is still 64 bytes on the wire and no
existing PDR / delay / throughput / NRL number moves.

Metrics are computed **per flow** (keyed by the source socket address, so the
`--sink` converge mode's shared sink still separates flows) and only then
aggregated. A single badly-spread flow is the interesting case and a pooled
number alone would hide it, hence the worst-flow column.

- **reorder_ratio** — out-of-order delivery ratio, pooled over all data flows:
  reordered packets / received packets, in [0,1].
- **reorder_ratio_max** — the same ratio for the **worst single flow**.
- **reorder_extent_mean / reorder_extent_max** — reordering extent over the
  reordered packets, in packets: mean, and the largest seen.
- **reorder_buf_max** — the largest reorder-buffer occupancy, in packets, that a
  receiver would need to hand the delivered packets up in sequence order.

### The exact definitions used

"Reordering" has several non-equivalent definitions in the literature, so the
choice is stated here rather than left implicit. All three follow
[RFC 4737](https://www.rfc-editor.org/rfc/rfc4737) (*Packet Reordering
Metrics*), applied to the receive stream of one flow at the sink:

1. **Reordered / out-of-order** — RFC 4737's `Type-P-Reordered` singleton.
   Maintain `NextExp`, the largest sequence number seen so far plus one. An
   arriving packet with sequence number `s` is **reordered iff `s < NextExp`**;
   when it is not, `NextExp` advances to `s + 1`, and when it is, `NextExp` is
   left alone. `NextExp` never decreases, which is what makes the criterion
   order-preserving. Equivalently — and this is how issue #212 words it — a
   packet counts as reordered when its sequence number is below the running
   maximum for that flow.
   **Loss is not reordering**: a lost packet merely makes `NextExp` jump, and
   the packets that follow are still in order. This matters here, because the
   harness runs at PDRs well below 100 %.
2. **Reordering extent** — RFC 4737's `Type-P-Packet-Reordering-Extent`, the
   position-distance form: for a reordered packet received at position `i` with
   sequence number `s`, the extent is `i − min{ j < i : seq[j] > s }`, i.e. the
   number of positions back, **in the received stream**, to the earliest packet
   received that has a larger sequence number. It is ≥ 1 for every reordered
   packet by construction. This is what distinguishes "one straggler" (a large
   extent on a handful of packets) from "systematically interleaved" (a small
   extent on many). RFC 4737 notes that this position-distance form *tends to
   overestimate* the receiver storage actually needed to restore order — which
   is precisely why the next metric is carried alongside it.
3. **Reorder-buffer occupancy** — the high-water mark of a receiver buffer that
   releases packets in sequence order, defined **over the packets that actually
   arrived**. On each arrival the packet is buffered, then the longest complete
   prefix of the flow's delivered-packet sequence is released; the metric is the
   largest number held at once. Defining it over arrivals rather than over the
   sent sequence is deliberate: a buffer that waits for the literal next
   sequence number stalls forever on the first lost packet, so at this harness's
   PDRs it would measure loss rather than reordering.

Duplicates are not handled specially: `OnOffApplication` emits each sequence
number once and IP-layer unicast forwarding does not duplicate, so a flow's
received sequence numbers are unique.

### Instrumentation self-check

Two arms should read ≈ 0 and are the reason to believe the AntHocNet number:

- **AODV, OLSR and DSDV** are single-path — one next hop per destination at a
  time — so the only reordering they can produce is the incidental kind around a
  route change. This is the control a reviewer will look for first.
- **AntHocNet with `--ns3::anthocnet::RoutingProtocol::EnableMultipath=false`**
  collapses to a single next hop and should likewise fall to ≈ 0. That is a free
  validation of the instrumentation itself: if it does not, the metric is
  measuring something other than multipath spreading.

Neither is expected to be exactly zero — a route change can hand consecutive
packets to paths of different length under any protocol — but both should be
small next to the multipath figure.

### Caveats

- **The `*_max` columns are averaged over the RNG runs** like every other
  column: they are a mean of per-run maxima, not a maximum over runs.
- **Reordering is traffic-pattern dependent.** At the paper's 1 packet/s per
  flow, consecutive packets are 1 s apart and only a path-delay difference of
  that order can reorder them; a denser source reorders far more readily at the
  same routing behaviour. Compare these columns only between arms of the same
  scenario, never across scenarios with different `cbrBps` or `flows`.
- **The reported figures are CSV columns; the human table prints them on a
  `# reorder` line** rather than as table columns, because the table's field
  positions are a parsing contract for `bench_parse.py` and the workflows'
  `##BENCH##` re-emit.
- **NS-3 only.** The NS-2 adapter has no equivalent instrumentation.

Aggregates are means over the RNG runs; the CSV also carries per-metric sample
stddev across runs (`pdr_sd`, `delay_sd`, `delay99_sd`, `nrl_sd`), which the
charts render as error bars, and the human table prints as `# stddev` lines.

**Caveat — the scenario and sweep pages are two different vintages.** Two
protocol defaults were corrected on 2026-07-25. The **scenario** pages are
regenerated on every merge and already include both; the **sweep** pages come
from the manual campaign workflow and do not:

- [#88](https://github.com/danieljoppi/AntHocNet/issues/88) (PR #167, merged):
  `T_hop` 50 ms → **3 ms**, the value stated in the 2007 thesis. It scales the
  hop-count term of every pheromone deposit, so it moves all delay-derived
  metrics. Measured effect on the pause sweep: mean delay −7…−16 %, jitter
  −8…−17 %, delay99 −8…−12 % under mobility, at flat PDR and NRL
  ([#88 measurement](https://github.com/danieljoppi/AntHocNet/issues/88#issuecomment-5079151172)).
- [#169](https://github.com/danieljoppi/AntHocNet/issues/169) (PR #170, merged):
  `reactiveMaxBroadcasts` 2 → **unbounded**. The finite budget was a *hop limit
  on route discovery* — destinations more than ~5 hops away were never found —
  so it affects **PDR and NRL**, not just the delay columns.

So: read a **sweep** page as the pre-fix behaviour, pending re-measurement. Read
a **scenario** page as current — with one exception, because #169's fix exposed
a third defect: [#173](https://github.com/danieljoppi/AntHocNet/issues/173) (P1,
**open**) leaves reactive forward ants bounded neither by a broadcast budget nor
by `(src,seq)` duplicate suppression, so discovery floods combinatorially in
dense graphs. That inflates **NRL** and depresses **PDR** on `large-scale` and
`heavy-load` specifically.

See [docs/fidelity.md](../fidelity.md) and
[configuration.md](../configuration.md) for the provenance of these values.
