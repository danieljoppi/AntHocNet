# ADR-0010: Data forwarding — prev-hop-excluded stochastic, flow-stickiness gated

- **Status:** Accepted — implementation tracked in
  item 10 (A1)
- **Date:** 2026-06-25

## Context

Data packets are forwarded by an independent stochastic draw over regular
pheromone at **every** hop (`onDataPacket(dest)` → `table_.lookup(dest, rng_)`).
Two consequences:

- **No prev-hop exclusion** — a packet can be drawn back toward the neighbour it
  just arrived from, so transient routing loops are possible and only the IP TTL
  breaks them.
- **Per-packet reordering** — independent draws scatter a single flow across the
  path mesh, which is harmless for UDP/CBR (the benchmark traffic) but hurts TCP
  (dup-ACKs, spurious retransmits).

The spec spreads data stochastically over a mesh but assumes the pheromone
gradient is effectively loop-free, and real implementations additionally avoid
sending a packet back the way it came and damp per-packet flapping. Note the
overlap with `β_data` (item 01): a high
greedy `β_data` already concentrates data on the best path and only spreads when
pheromones are comparable, so per-packet reordering is naturally limited in the
paper's regime.

## Decision

- **Prev-hop exclusion is always on (not gated).** Thread the incoming neighbour
  into the core (`onDataPacket(dest, prevHop)` → `lookup(dest, …, exclude=prevHop)`)
  and skip it when forming the probability sum and selecting — **unless it is the
  only next hop with pheromone**, in which case forward to it anyway (no
  black-holes at leaf nodes). This is pure loop-safety, so it is unconditional.
- **Per-flow stickiness is config-gated, default OFF.** When enabled, a bounded
  `(src,dst) → next-hop` cache with hysteresis keeps a burst on one path; it is a
  **core** concern (routing policy, golden rule #2), bounded like the `(src,seq)`
  dedup history, and requires the adapter to pass the packet **src**
  (`onDataPacket(dest, prevHop, src)`). Default off because (1) high `β_data`
  already makes data ~sticky, (2) pure per-packet stochastic is the paper-faithful
  baseline the benchmarks should measure first, and (3) it only helps
  reorder-sensitive (TCP) traffic, which the current harness doesn't carry. It
  becomes another benchmark ablation knob (mirrors [ADR-0007](0007-proactive-diffusion-gated.md)).

## Alternatives considered

- **Stickiness on by default.** TCP-friendliness and smoother delay out of the
  box, but departs from the paper's pure-stochastic spreading and muddies the
  "canonical AntHocNet" story until a benchmark with reorder-sensitive traffic
  justifies it. Rejected as a default; available via the flag.
- **No prev-hop exclusion (rely on TTL).** Simplest, but accepts transient loops
  and the wasted transmissions they cause. Rejected — loop-safety is cheap and
  unconditional.

## Consequences

- The core data entry point gains `prevHop` (always) and `src` (when stickiness
  is compiled/used); both adapters supply them (NS-3 `RouteInput` `idev`→sender
  and origin; NS-2 `ch->prev_hop_` and `ih->saddr()`).
- Loop-safety no longer depends on TTL; the only-option fallback preserves
  reachability at leaf nodes.
- One more benchmark ablation axis (sticky vs pure-stochastic), consistent with
  the gate-and-measure pattern used for diffusion.
- No wire-format impact: prev-hop and flow identity are local forwarding inputs,
  not serialized ant fields (no `kWireVersion` bump — ADR-0006/0009).
