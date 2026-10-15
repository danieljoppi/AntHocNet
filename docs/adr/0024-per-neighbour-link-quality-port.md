# ADR-0024: A per-neighbour link-quality port for the SINR metric

- **Status:** Accepted
- **Date:** 2026-10-15
- **Decides:** [#181](https://github.com/danieljoppi/AntHocNet/issues/181)
  (the SINR link metric) and [#144](https://github.com/danieljoppi/AntHocNet/issues/144)
  (selecting a metric from ns-3).

## Context

Every headline result in the 2007 thesis was produced with an SINR link metric
(eq. 4.11): a link costs 1 when its signal-to-interference-and-noise ratio is
above SINR_c = 17 dB and c_const = 3 otherwise, a route costs the sum, and the
pheromone is the inverse (eq. 4.3). This repository shipped only the classic
delay + hops metric, which the thesis benchmarks as worse.

SINR is a property of **one link**: what this node hears from neighbour *j*.
The core's only adapter-fed signal port, `ILinkState`, is node-scoped (this
node's MAC queue and service time) and has no way to say which neighbour a
value belongs to. The July 2026 scoping on #181 found this first: the metric is
a new port, not a new formula.

The thesis also says *where* each link's cost enters (§4.2.2): "the reactive
backward ant reads at each node *i* the local estimate *c_i^n* of the cost to go
from *i* to the next hop *n* that the ant is coming from". Per ADR-0009 the
backward ant carries its path (`history`, one scalar per hop) and every node
recomputes the deposit from it.

## Decision

1. **A new port, `ILinkQuality`** (`core/.../ports.h`), separate from
   `ILinkState`: `double sinrDbFrom(NodeAddress neighbor) const`, returning NaN
   when there is no sample. "No sample" counts as a good link, so a neighbour
   is never penalised before it has been heard from, and an adapter that does
   not implement the port degrades the SINR metric to plain hop count.
2. **The metric says whether it needs it.** `ILinkMetric::usesLinkQuality()`
   (default false). `SinrMetric` (registry name `"sinr"`) returns true and
   computes `1 / max(sum of hop costs, hops)`. The constants are `Config`
   fields, `sinrCriticalDb = 17` and `sinrPenaltyCost = 3`, quoted from the
   thesis.
3. **Where the cost enters, when the metric asks for link quality:**
   - **Backward ants:** a node receiving a backward ant replaces the per-hop
     value of the hop the ant just came over (`history.back()`) with its own
     link cost to that neighbour, before computing the deposit. This is the
     thesis's c_i^n. Nodes further upstream read the corrected value, so the
     retraced path sums each node's estimate of its own downstream link.
   - **One-hop entries:** the per-reception 1-hop refresh (#279) uses the same
     link cost.
   - **Diffusion and link-failure bootstraps:** they add one hop of cost to an
     advertised pheromone. They add the link cost instead of `T_hop`.
4. **No wire change.** The per-hop scalar ADR-0009 put on the wire is already
   "one scalar cost per hop". Under the SINR metric it carries link costs on
   the way back instead of wall-clock deltas. `kWireVersion` stays at 0x03.
   Forward ants are untouched, including the multipath acceptance test, which
   still compares wall-clock travel.
5. **Classic stays byte-identical.** With a metric that does not use link
   quality, every new code path returns the old value: `T_hop` for one hop,
   and no overwrite. The port is not consulted.
6. **ns-3 feeds it from the PHY.**
   - The adapter subscribes to each wifi PHY's `MonitorSnifferRx` trace, only
     when the selected metric uses link quality, so classic runs pay nothing.
     It reads signal − noise in dB: ns-3 computes that noise from the
     interference-aware SNR, so the difference is the SINR.
   - Matching a frame to its neighbour: the adapter keeps a small window of
     (packet UID, SINR) and, when the socket hands up an ant, looks the UID up
     and stores the SINR under the ant's sender.
   - The trace's argument list is taken from
     `WifiPhy::MonitorSnifferRxCallback`, not spelled out, because it has
     changed across the supported ns-3 range.
   - The metric is chosen by the new `LinkMetric` attribute, resolved through
     the core registry. An unknown name is a fatal configuration error
     (#144). The default is `classic`.

## Consequences

- The SINR metric is available to A/B in the v2.2.0 campaign (#565). Per
  ADR-0019 it becomes the default only if it helps in every family; otherwise
  it ships selectable and off.
- Non-wifi links (the point-to-point satellite ISLs) have no PHY SINR. Under
  the SINR metric they read "no sample", so every ISL counts as one hop. That
  is the right answer for links with no fading, and it is stated on the
  satellite pages if the campaign reports SINR results there.
- The browser adapter does not implement the port. The game keeps the classic
  default, and the WASM parity gate is unaffected.
- A future link-quality metric (ETX, a fuzzy or energy metric, #145) reuses the
  same port and the same backward-ant hook, through `usesLinkQuality()`.
