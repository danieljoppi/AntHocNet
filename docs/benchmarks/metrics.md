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
