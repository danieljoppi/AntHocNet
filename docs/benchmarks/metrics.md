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
