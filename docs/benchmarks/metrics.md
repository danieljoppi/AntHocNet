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
- **jitter** (`jitter_ms`) — mean delay jitter over delivered packets
  (FlowMonitor `jitterSum` / (rx−1)), ms. Accumulates
  `|delay_i − delay_{i−1}|`, where `delay = arrival − send`.
- **jitterEq51** (`jitter_eq51_ms`) — the **thesis's** delay jitter, eq 5.1,
  ms. **This is a different quantity from `jitter_ms`, not a variant of it**
  ([#89](https://github.com/danieljoppi/AntHocNet/issues/89)):

  ```
  eq 5.1:       Σ |(t_i − t_{i−1}) − (t_{i−1} − t_{i−2})|      normalised by (n−2)
  jitter_ms:    Σ |delay_i − delay_{i−1}|                       normalised by (n−1)
  ```

  Eq 5.1 contains **no send times at all** — it measures how far each
  inter-arrival gap falls from the *previous gap*, where `jitter_ms` measures
  how far each packet's *delay* falls from the previous packet's. Under a
  perfectly periodic source the two differ by one further differencing step,
  which for iid arrival noise inflates eq 5.1 by roughly √2 in scale. There is
  no constant with which to convert one into the other.

  Three properties of the source formula that the implementation had to decide
  and therefore records here:

  - The thesis writes eq 5.1 as a bare **sum**, though every figure caption
    calls it "average delay jitter". A sum scales with packets delivered, so the
    worse-delivering protocol would score better arithmetically — the same
    survivorship trap the offered-load percentiles exist to dodge. We normalise.
  - The normaliser is **(n−2)** per flow: the sum's first well-defined term is
    at `i = 3`. (The thesis writes `i = 2` but references `t_{i−2}` — an
    off-by-one in the source.) Flows with fewer than 3 arrivals contribute
    nothing.
  - It is computed in **arrival order, not sequence order**. The thesis says
    "the time of arrival of the *i*th packet", so a reordered packet
    legitimately registers as jitter. Do not sort by sequence number to
    "fix" this; that would silently change the metric.

  **Which to cite:** paper-parity claims ("reproduces the thesis's jitter
  result") must cite `jitter_eq51_ms`. Cross-protocol comparisons may cite
  either, as long as one is used consistently — both are measured identically
  across all arms on identical realisations. A large divergence between the two
  columns is itself informative: it says the arrival process is bursty in a way
  the delay distribution alone does not show.
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

## Drop causes (#215, NS-3 only)

PDR says how many packets went missing. These columns say **why**, as a
percentage of *offered* (sent) packets, so that

```
pdr_pct + drop_route_pct + drop_queue_pct + drop_mac_pct
        + drop_chan_pct  + drop_ttl_pct   ≈ 100
```

Every offered packet is accounted for exactly once: it was delivered, or it
died of one of five causes. That identity is what makes the breakdown readable
— a cause is a *share of the loss*, not a free-floating counter — and
`scenario_check.py results` enforces it (see *Why the identity must close*).

The five causes are measured **identically for all four protocols**, so a
column means the same thing in the AntHocNet arm and in the AODV arm:

- **drop_route_pct** — the routing layer gave up: no route was ever found, or
  the route it was waiting on did not come back in time. Measured from
  FlowMonitor's per-flow drop reasons (`DROP_NO_ROUTE` + `DROP_ROUTE_ERROR`),
  i.e. from the protocol's own error callback, whichever protocol raised it.
- **drop_queue_pct** — the packet was overtaken by congestion at the
  *interface*: the device transmit queue or the traffic-control queue disc was
  full (`DROP_QUEUE` + `DROP_QUEUE_DISC`). This is the "network is drowning in
  its own traffic" signal, not a routing failure.
- **drop_mac_pct** — the link broke under the packet: 802.11 exhausted its
  retry limit on the unicast (`WIFI_MAC_DROP_REACHED_RETRY_LIMIT` on the
  `WifiMac` `DroppedMpdu` trace — the same signal AntHocNet's ADR-0008 detector
  D uses). **Terminal failures only**: AntHocNet re-injects a MAC-dropped data
  packet into its pending queue (#46), and a re-injected packet is not lost —
  its real fate is counted wherever it finally ends up — so re-injections are
  subtracted here rather than counted twice.
- **drop_chan_pct** — sent and never received. Counted as the difference
  between data IP packets handed to a real interface and data IP packets that
  arrived at the next hop's IP layer (the `Ipv4L3Protocol` `Tx`/`Rx` traces,
  the same counting point as NRL), minus the MAC and interface-queue drops
  already attributed above. What remains is genuine on-air loss: collisions,
  capture, a next hop that moved out of range mid-frame, ARP failures. **This
  one can only come from the simulator** — it is the gap between "we sent it"
  and "it arrived", which `core/` by construction cannot see (golden rule 1).
- **drop_ttl_pct** — the IP TTL reached zero (`DROP_TTL_EXPIRE`): the packet
  was forwarded in a loop or along a path longer than the TTL allows. Note this
  is the *IP* TTL on data packets; `Config::maxPathLength` is the analogous
  ceiling on *ants* and does not appear here (ants are control traffic, counted
  by NRL).

Three further columns split `drop_route_pct` for AntHocNet. They are a
**sub-breakdown of that column, not extra causes** — adding them into the
identity would double-count — and they are **blank, never `0`, for the other
protocols**, because the mechanisms simply do not exist there. Blank means "not
applicable"; `0` would mean "applicable and never fired", and the two must stay
distinguishable:

- **drop_setup_pct** — held in the pending queue for a destination this node
  had **never** routed to, and aged out at `QueueTimeout` (or was evicted when
  the queue filled). This is the true *no route* case: discovery never
  succeeded.
- **drop_reconv_pct** — same exit, but for a destination this node **had**
  routed to: a route existed, was lost, and did not return within
  `QueueTimeout`. Reconvergence loss, not discovery failure. Packets
  re-injected after a MAC failure and then aged out land here too — they were
  also waiting for a route that had existed.
- **drop_repair_pct** — released by `DiscardPending` after a **local repair
  timed out** (the paper's §3.5, decision D6). The core counts the repair events
  (`AntRouterLogic::repairDiscards()`); the NS-3 adapter owns the queue and so
  counts the packets.

### Which causes are protocol behaviour, not faults

This is the part that matters when reading a table. Not every drop is a bug.

| Cause | Reading |
|-------|---------|
| **drop_repair_pct** | **Expected, deliberate behaviour.** The AntHocNet paper (§3.4 link failures / §3.5 local repair) chooses to discard the packets buffered behind a failed local repair rather than hold them indefinitely: it trades a slice of PDR for a **bounded delay tail**. A non-zero repair-discard share is the protocol working as specified, and #21's `RepairHoldCap`/`ReconvHoldCap` levers move packets *deliberately* between this column and the delay tail. Read it against `delay99_ms`/`jitter_ms`, never on its own. |
| **drop_reconv_pct** | **Expected under mobility**, in proportion to how fast links break. It is the direct cost of reactive re-discovery; a *rising* share as `pause` falls is the protocol responding to mobility, not degrading. It becomes a finding only when it dominates on a **static** field. |
| **drop_setup_pct** | Expected during the start-up transient and for genuinely unreachable destinations (a partitioned field — `scenario_check.py preflight` warns about those before the run). A large steady-state share means discovery is failing: that is #169's signature. |
| **drop_chan_pct** | **PHY/scenario property, not a protocol property**, up to the control traffic the protocol puts on the air. All four arms share a channel, so compare the column *across* arms: the protocol with the higher share is the one filling the medium. A collapse dominated by this column is [#173](https://github.com/danieljoppi/AntHocNet/issues/173)'s exact signature — and having it as a column is why #215 exists at all, since #173 cost a benchmark campaign, a testbench reproduction and a code audit to reach that same conclusion. |
| **drop_queue_pct** | Congestion, same reading as `drop_chan_pct`: offered load (or control overhead) exceeding what the interface can drain. Cross-check against `--qdiag` and `preflight`'s offered-load fraction. |
| **drop_mac_pct** | Link breakage. Expected under mobility; a high share at low speed points at the PHY setup (`--rateManager`, #51) rather than at routing. |
| **drop_ttl_pct** | **Always a fault signal.** Data should not loop. Anything materially above zero means forwarding loops — read it with `EnableMultipath` and the A1 loop-suppression caveat in the NS-3 adapter. |

### Why the identity must close

The five protocol-agnostic causes come from **three independent books**:
FlowMonitor's per-flow drop reasons, the `Ipv4L3Protocol` `Tx`/`Rx` hop
tallies, and the `WifiMac` retry-limit verdicts. Nothing forces them to agree,
which is what makes their sum a real check rather than an accounting tautology.
`scenario_check.py results` therefore treats a mismatch as a harness
regression, in the same class as the #51 anchor floors:

- **WARN** past 1 percentage point, **FAIL** past 5.
- The tolerance exists for one legitimate residual: data still sitting in a
  routing protocol's pending queue when the run stops. A packet waits there at
  most `QueueTimeout` (3 s), so the residual is bounded by 3 s of offered
  traffic — ≈0.3 % of a 900 s paper run, ≈2.5 % of the 120 s `--quick` preset.
  5 pp leaves plenty of room for that while still catching a #173-scale
  misattribution (tens of pp).
- A negative share in any cause also FAILs: it means two causes are counting
  the same packet.

If the check fails, **do not read the breakdown** — one of the three books is
wrong (a drop path that fires no error callback, a trace hook that did not
connect on this ns-3 release, a cause counted twice) and every per-cause
conclusion is unsafe until it is fixed.

**The three AntHocNet-only columns are a sub-breakdown of `drop_route_pct`, not
causes on top of it.** `drop_setup_pct + drop_reconv_pct + drop_repair_pct`
partitions `drop_route_pct`: all three exit paths end in the same L3 error
callback, so the parent already contains them. Adding them to the identity
double-counts route failures and manufactures a ~156 % total out of a correct
breakdown — a mistake made once while reading these very columns
([#229](https://github.com/danieljoppi/AntHocNet/issues/229)). The identity has
**five** terms plus PDR. `scenario_check.py` cross-checks the partition
separately (WARN if the three do not reconstruct their parent within 1 pp).

#### What is measurable, per protocol

`drop_queue_pct` comes from `Ipv4FlowProbe`'s `DROP_QUEUE` / `DROP_QUEUE_DISC`
reasons, which observe the **interface and qdisc queues only**. A routing
protocol's own pending queue — the buffer holding packets awaiting a route — is
invisible to them unless the protocol reports its discards through an L3 error
callback.

| Protocol | Routing-layer pending-queue drops |
|---|---|
| **anthocnet** | **Counted.** They run through the error callback, so they land in `DROP_NO_ROUTE` and hence in `drop_route_pct` (further split by the three sub-columns above). This is why AntHocNet's identity closes to within 0.06 pp on every scenario. |
| **aodv** | Counted, same mechanism. |
| **olsr** | Not applicable — OLSR is proactive and does not buffer awaiting a route. |
| **dsdv** | **Not counted.** ns-3's `dsdv::PacketQueue` sheds on `MaxQueueLen` / `MaxQueueTime` without an error callback, so those packets are offered, never delivered, and attributed to no cause. `drop_queue_pct` reads a confident `0.00` on all six scenarios. |

The consequence is bounded but real: it costs **11.46 pp** of the DSDV identity
at `dense-small` (the most congested scenario, so the most buffering) and
≤ 0.73 pp elsewhere. **Do not include DSDV in a cross-protocol drop-cause
comparison** until [#229](https://github.com/danieljoppi/AntHocNet/issues/229)
closes. DSDV's aggregate metrics — PDR, delay, NRL — never depended on the
breakdown and are unaffected.

### Caveats

- **NS-3 only.** The NS-2 adapter has no equivalent instrumentation; see
  [cross-validation.md](../cross-validation.md).
- The human table prints these on a `# drops` line (like `# energy`) rather
  than widening the fixed-width table; the CSV carries all eight columns.
- `# drops` also prints `other=`, the L3 drops in none of the five buckets
  (bad checksum, interface down, fragment timeout — structurally zero in this
  harness). If it is ever non-zero it is the reason the identity misses.

## Route quality: path length, path diversity, fairness (#217, NS-3 only)

AntHocNet's defining property is that it lays and maintains **multiple paths**,
and until #217 the harness measured nothing about paths. These columns are
produced protocol-agnostically from NS-3's own traces for **all four
protocols** — the single-path baselines are the instrumentation's self-check,
not a blank column.

- **path_hops_mean / path_hops_max** — mean and maximum hop count *actually
  traversed by delivered data packets*, where one hop is one transmission (a
  packet delivered to a neighbour is 1 hop). This is what settles whether
  AntHocNet's delay advantage comes from **shorter** paths or from better path
  **selection**: compare `path_hops_mean` alongside `delay_ms`. 0 when nothing
  was delivered (the `nrl` convention).

  *Definition and source.* Taken from the IP TTL observed at the destination's
  `Ipv4L3Protocol` `LocalDeliver` trace — one call per packet handed to the
  local transport, i.e. exactly the packets PDR counts — as
  `hops = (initial TTL − TTL at delivery) + 1`. The initial TTL is NS-3's
  `Ipv4L3Protocol::DefaultTtl` default of 64 (unchanged across the 3.36–3.48 CI
  matrix; nothing in the harness sets a `SocketIpTtlTag`). Every real forwarding
  hop passes through `Ipv4L3Protocol::IpForward`, which decrements the TTL
  exactly once. This is numerically the same quantity as FlowMonitor's
  `FlowStats::timesForwarded + 1` — which accumulates only over delivered
  packets — but observed per packet rather than per flow, which is what makes
  the **maximum** available at all: FlowMonitor exposes only the sum.

- **path_div_used** — **used** path diversity: the mean number of *distinct next
  hops that actually carried a data packet* for a destination, per (node,
  destination) pair, within one `path_div_window_s` window, averaged over the
  cells that carried data. **path_div_max** is the largest such count seen in
  any one cell.

  *Used, not available — and the distinction is the point.* Pheromone entries
  above `minPheromone` are the paths the table makes **available**; a table full
  of pheromone that data never uses would read as diversity that does not
  exist. What is reported here is **usage**: a next hop counts only when a data
  frame it carried was acknowledged.

  *Why a window.* Diversity is *concurrency*. Over a whole run a single-path
  protocol also touches several next hops for one destination — sequentially, as
  routes break and are rediscovered — so a whole-run distinct count would credit
  AODV with multipath it does not have. Counting per window separates
  concurrent spreading from sequential replacement. **Expect the baselines
  (AODV/OLSR/DSDV) to read ≈1**; the residual excess above 1 is route churn
  inside one window, not spreading, and it grows with mobility. A baseline
  reading well above 1, or AntHocNet reading exactly 1, is an instrumentation
  or protocol regression.

  *Source.* The `WifiMac` `AckedMpdu` trace: it fires at the transmitter for
  every unicast MPDU the next hop acknowledged, and the 802.11 header's `Addr1`
  **is** the next hop. It is the only address-bearing transmit hook NS-3 offers
  uniformly to all four protocols (the `Ipv4L3Protocol` traces do not carry the
  gateway), and "acknowledged" makes "carried" literal — a frame the next hop
  never received is not a path that was used. The AntHocNet adapter already
  depends on this trace across the whole CI matrix (#68).

- **path_entropy_bits** — mean Shannon entropy (bits) of the per-next-hop packet
  split within a cell, averaged over the same cells as `path_div_used`. **0 =
  single path**; 1 bit = an even two-way split; it is bounded above by
  log2(`path_div_max`). Reported because the count alone cannot distinguish a
  genuine 50/50 split from 999 packets down one next hop and 1 down another.

- **path_div_window_s** — the window (s) the diversity columns are counted over
  (`--pathWindowS`, default **10 s**), carried in the CSV because it *defines*
  what the diversity number means. Provenance: a repo choice, not a paper value.
  It must be long enough to hold several packets of a flow (the paper base
  scenario offers 1 packet/s per flow, so 10 s ≈ 10 packets) and short enough
  that a single-path protocol rarely replaces a route inside it. Comparisons
  across different window settings are meaningless — check the column matches
  before differencing two runs.

- **jain_pkts** — **Jain's fairness index** over the per-flow delivered-packet
  counts, `J = (Σxᵢ)² / (n·Σxᵢ²)`. `J = 1` when every flow is served equally,
  `J = 1/n` at maximum unfairness (one flow gets everything). `heavy-load` runs
  40 flows and the rest of the table reports only aggregates, so without this
  one starved flow is invisible. This is where stochastic spreading should beat
  single-path protocols.

  *Population.* `n` is the number of source applications actually installed, so
  a flow so starved that not one of its packets ever reached the IP layer — its
  socket send failed for want of a route, which FlowMonitor never records —
  still counts as a **zero** rather than vanishing from the index. (That is a
  deliberate divergence from PDR's denominator, which counts only packets
  FlowMonitor saw offered.)

  *One index, two readings.* Computed over delivered **packet counts**; because
  every flow in this harness sends the same 64-byte payload, the per-flow
  throughput vector is a scalar multiple of the packet-count vector and Jain's
  index is scale-invariant, so the same number is also the throughput-based
  index. If the harness ever gains per-flow packet sizes, the two separate and
  a second column is needed.

### Caveats (route quality)

> **`path_div_*` and `path_entropy_bits` are not publishable at the current
> default window.** The single-path baselines are this metric's self-check, and
> they fail it. OLSR installs exactly one route per destination and so must read
> `path_div_used` ≈ 1.000; on the first full campaign it read **1.428** at
> `heavy-load`, 1.383 at `high-mobility` and 1.344 at `paper-base`. AntHocNet's
> whole range (1.225–1.512) sits *inside* OLSR's.
>
> The cause is the window, not the counter: `path_div_window_s` defaults to
> **10 s**, which is longer than a route survives under mobility, so a single
> route being *replaced* is counted as two concurrent paths. `sparse-static` is
> the control that proves it — the only scenario with no route churn, and the
> only one where the baseline reads ≈ 1 (olsr 1.004) and the separation from
> AntHocNet (1.225) is real.
>
> **The window was swept, and no value works.** Five single points on the
> paper-base knobs, identical config, `--pathWindowS` the only variable:
>
> | window | anthocnet | aodv | olsr | dsdv |
> |---:|---:|---:|---:|---:|
> | 0.5 s | 1.001 | 1.000 | 1.000 | 1.000 |
> | 1.0 s | 1.001 | 1.000 | 1.000 | 1.000 |
> | 2.0 s | 1.002 | 1.002 | 1.000 | 1.001 |
> | 5.0 s | 1.147 | 1.157 | **1.164** | 1.066 |
> | 10.0 s | 1.291 | 1.311 | **1.327** | 1.167 |
>
> Below 2 s every protocol reads ≈ 1.000 — AntHocNet included, so there is no
> signal to have. At 5 s and above the baselines are already past 1.05 **and
> OLSR outranks AntHocNet**. There is no window in between: at 2 s AntHocNet
> ties AODV to three decimals.
>
> **Root cause: the metric is sample-starved at the paper's traffic rate, not
> merely mis-windowed.** A (node, destination, window) cell can only report
> diversity above 1 if at least two packets land in it, so packets-per-cell is
> bounded by `pktPerSec × window` — 1 × 2 s = 2 at paper-base, the bare floor,
> where a cell can only ever read 1.0 or 2.0. Shortening the window to escape
> route churn starves the sample; lengthening it to gather samples lets churn
> dominate. The two bounds cross, which is why the sweep has no solution.
>
> `kDefaultPathWindowS` is therefore **left at 10 s** — no other value is
> better at the paper's 1 pkt/s, and moving it would imply the problem was
> solved. A 900 s re-sweep (w ∈ {2,4,6,10}, runs 30649042555/30649049794/
> 30649059276/30599510462) reproduced the table above point for point.
>
> **Resolution (#230, owner-approved): a dedicated diversity-measurement
> cell.** Raising the offered rate feeds the cells instead of shrinking the
> window past the churn bound: at `--cbrBps=4096 --pathWindowS=2` (8 pkt/s →
> 16 packets per cell; run 30650903707, 900 s) AntHocNet separates from every
> baseline — `divUsed` **1.229** vs aodv 1.133 / olsr 1.090 / dsdv 1.046,
> `entropyBits` 0.163 vs ≤ 0.093, `divMax` 7 vs ≤ 6. Concurrent spreading is
> real and was sample-starved at 1 pkt/s.
>
> Rules for using the cell:
>
> 1. **All `path_div_*`/`path_entropy_bits` claims come from this cell only**
>    (`cbrBps=4096`, `pathWindowS=2`), which is its own load regime (8× the
>    paper rate) and must be labeled as such — never mixed into the headline
>    paper cell, whose diversity columns remain unquotable.
> 2. **Report diversity as excess over the in-run single-path floor**, not as
>    an absolute: at 8 pkt/s even a churn-free window catches AODV's route
>    replacement landing packets on two routes inside one window (measured
>    floor 1.133), so the honest figure is AntHocNet − AODV in the same run
>    (today: **+0.096 used-paths, +0.070 entropy bits**). No (rate, window)
>    pair drives the floor to 1.0 while keeping the cells fed.
> 3. `scenario_check.py` enforces the split: the absolute 1.10 single-path
>    bound applies whenever `path_div_window_s > 2`; at the cell's window it
>    relaxes to a 1.50 sanity ceiling (a baseline above that means the window
>    is not churn-free at the offered rate and the cell is unreadable).
>
> The per-packet-pair concurrency counter remains the clean long-term
> instrument that would retire the floor comparison; #230 keeps it as the
> follow-up. `path_hops_*` and `jain_pkts` are unaffected by all of this and
> readable from any cell.

- **Reactive protocols read one hop high on route-discovery packets.** A
  protocol with no route yet bounces the packet through the loopback device to
  reach `RouteInput` (AODV and this adapter both do); the packet then leaves via
  `IpForward`, costing one TTL decrement that no radio carried. Those packets
  report one hop too many, so `path_hops_mean` for `anthocnet`/`aodv` is a
  slight over-estimate, bounded by (route discoveries)/(delivered packets) — a
  fraction of a percent in the paper scenario, larger where routes break often.
  FlowMonitor's `timesForwarded` counts the same bounce, so this is a property
  of the loopback idiom, not of the TTL route to the number.
- **Diversity is measured on acknowledged unicasts only.** Broadcast frames are
  never acknowledged; that is correct here (routing control must not count as a
  used data path) but it also means a protocol that delivered data over
  broadcast would read 0. None of the four does.
- **Diversity aggregates over every relay, not just sources.** A cell is a
  (node, destination, window) triple, so a node forwarding for one destination
  in a window contributes a 1 whatever the source is doing. That is the
  intended reading — AntHocNet spreads at every hop — but it means the mean is
  diluted by relays that saw only one packet in a window.
- **NS-3 only.** The NS-2 adapter has no equivalent instrumentation; see
  [cross-validation.md](../cross-validation.md).

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

#### What the self-check actually returned

The floor half passes: on the stable-field scenarios (`sparse-static`,
`paper-base`) every single-path baseline reads **exactly 0.0000** at 93–100 %
PDR. Loss is correctly *not* counted as reordering and the sequence plumbing is
sound.

The discrimination half fails. Pooled over the six scenarios, `reorder_ratio`
reads **anthocnet max 0.0208** against **aodv max 0.0243** — AntHocNet does not
exceed the single-path control. At `dense-small` it is inverted outright:

| | reorder_ratio | reorder_extent_mean | reorder_buf_max |
|---|---:|---:|---:|
| anthocnet | 0.0030 | 5.49 | **151.0** |
| aodv | **0.0243** | **45.80** | 22.6 |

**Why: `reorder_ratio` and `reorder_extent_*` measure route flapping, not
concurrent paths.** RFC 4737 tags *every* subsequent lower-sequence arrival
after one early packet. On the arrival order `1, 10, 2, 3, 4, 5`, packets 2–5
are each `Type-P-Reordered` with extents 1, 2, 3, 4 — a mean extent of 2.5 from
a **single** displacement. That is RFC-correct and the implementation is right;
it simply makes the statistic a function of how often a route switches
*forward*. AODV re-discovers constantly under `dense-small` congestion, and each
re-discovery onto a shorter path is one such event. The fingerprint is a mean
extent above the buffer high-water mark (45.80 vs 22.6) — impossible unless few
displacements are tagging long runs behind them, and now a `scenario_check.py`
WARN.

**`reorder_buf_max` is the honest multipath signal.** It is the receiver-side
buffer depth concurrent paths actually impose, and it separates AntHocNet from
every baseline on **6 of 6** scenarios (anthocnet 12.6–973.8, baselines
0.0–22.6, largest in every scenario). Prefer it. Quote `reorder_ratio` or
`reorder_extent_*` only alongside the caveat above —
[#230](https://github.com/danieljoppi/AntHocNet/issues/230) tracks the
documentation and check work.

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
