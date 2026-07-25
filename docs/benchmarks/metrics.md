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

**Caveat on the published AntHocNet delay/jitter figures.** Every number
currently on the scenario and sweep pages was measured with the provisional
`T_hop = 50 ms`; [#88](https://github.com/danieljoppi/AntHocNet/issues/88)
(PR #167, in flight) takes it to 3 ms, so the delay-derived metrics above must
be re-measured once it lands. See [docs/fidelity.md](../fidelity.md).
