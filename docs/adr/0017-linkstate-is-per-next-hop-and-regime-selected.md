# ADR-0017: The congestion signal is per-next-hop, and its implementation is selected by what the build instantiates

- **Status:** Accepted — owner decision recorded on
  [#206](https://github.com/danieljoppi/AntHocNet/issues/206) (2026-07-31);
  shipped by the #206 step-1/step-2 PRs
- **Date:** 2026-08-01

## Context

The item-10/A2 congestion-aware metric ([1] §3.2, #55/#67) makes a forward ant
record each node's expected send time from queue occupancy, so path cost
reflects sustained load. The NS-3 adapter sourced that signal exclusively from
the wifi MAC (`if (!m_wifiMac) return 0;`): on any other device the signal was
0 and `EnableMacMetric` silently inert.

That mattered because the satellite track's defensible research claim is
**congestion adaptivity** — LEO topology is deterministic and precomputable,
congestion is not (#202's prior-art survey found the whole ACO-on-LEO field
converged on exactly this framing). An ISL is a `PointToPointNetDevice`; a
congestion metric that returns 0 on every ISL removes the mechanism the claim
rests on, and made #216's "congestion the precomputed control cannot see" cell
meaningless rather than negative.

Two design questions had to be settled before generalising the source:

1. **Per-interface vs per-node.** `m_wifiMac` is one MAC; a satellite has one
   queue per ISL, and the A2 metric exists to choose *between* next hops. A
   node-wide signal raises the cost of every candidate equally — on a
   four-ISL satellite it steers identically to no metric at all, silently.
2. **Where to sample.** The A2 cost was stamped into the ant *before*
   next-hop selection: at the moment of sampling there was nothing to sample
   for. Invisible on wifi (one queue), fatal on multi-interface nodes.

## Decision

1. **`ILinkState` queries name the next hop.** `macQueueLength(nextHop)` /
   `macServiceTime(nextHop)`, with the contract in `ports.h`:
   `nextHop == kInvalidAddress` means "no single outgoing interface —
   aggregate across interfaces". Wifi is the degenerate case (one radio, one
   queue) and ignores the parameter, byte-identical to before.
2. **The stamp moves to where the interface is known** (option C on #206):
   the unicast branch stamps with its chosen next hop; broadcast and
   destination branches stamp `kInvalidAddress` — a flooding ant genuinely
   goes out every interface, so its cost genuinely is node-wide, and the
   terminal node keeps its own contribution in the backward ant's path time.
3. **Units: congestion is queue depth × service time, propagation excluded.**
   An ISL's 3–18 ms propagation is real delay (the wall-clock transit path
   already prices it) but it is constant and load-independent; folding it into
   `T̂` would swamp the signal's dynamic range and produce a metric that
   measures distance — which the deterministic control already optimises. The
   non-wifi service time is therefore sampled as **inter-dequeue spacing while
   the transmit queue stays backlogged** (the transmitter-side analogue of the
   wifi inter-ack EWMA, #68), which excludes propagation by construction — the
   sender never waits for it.
4. **One core, regime-selected readers — chosen by what the build
   instantiates.** The core consumes `ILinkState` and never learns what a
   device is (golden rule 1). The adapter carries two readers: the wifi MAC
   reader (MANET regime) and the per-device transmit-queue reader (p2p/ISL
   regime, via the generic `TxQueue` attribute that `PointToPointNetDevice`,
   `CsmaNetDevice` and `SimpleNetDevice` all expose — no device-specific
   module dependency). Which reader a node uses is decided by the devices its
   build's scenario instantiated: wifi devices select the MAC reader, queue-
   bearing devices select the queue reader; wifi is preferred where both
   exist. This is the owner's stated architecture — *the networking-type
   decision is relayed in the configuration build; the protocol implementation
   shares the same algorithm, but the MANET and satellite build compilations
   differ* — and it extends [ADR-0015](0015-satellite-substrate-lives-in-the-image.md)'s
   axis (one protocol build, regime-specific images/substrates) to the
   congestion signal. It is **not** a runtime protocol switch and not a second
   core.

## Alternatives considered

- **Per-node signal, generalised source only.** Non-functional on
  multi-interface nodes, not merely imprecise — see Context. Worse, it *looks*
  fixed: it changes the signature, passes CI, and leaves the ISL case
  measuring the wrong thing. Rejected on #206 ("option B").
- **Keep stamp-before-selection, aggregate always.** Same failure with less
  code churn. Rejected for the same reason.
- **A runtime attribute selecting the reader.** Adds a knob whose correct
  value is always derivable from the device type; a wrong setting silently
  zeroes the signal — the exact failure class #206 fixes. Rejected.
- **Deriving p2p service time from the `DataRate` attribute.** Deterministic
  and propagation-free, but wrong for heterogeneous packet sizes (ants are
  ~64 B, data ~1000 B) and unavailable on devices without the attribute; the
  measured EWMA handles both and mirrors the shipped wifi design. Rejected as
  the primary source (it remains a sanity cross-check in review).

## Consequences

- `EnableMacMetric` now produces a real, per-next-hop signal on p2p/ISL and
  `SimpleNetDevice` topologies; the #216 congestion cell (asymmetric load over
  equal-length paths) is unblocked and is the acceptance measurement for the
  satellite claim.
- Core control flow changed on the forward-ant hot path (stamp after
  selection). Pinned by core tests (per-next-hop unicast stamp, aggregate
  broadcast/destination stamps, destination's own contribution) and an ns-3
  suite case asserting the signal *discriminates* between a loaded and an idle
  next hop on a multi-interface relay.
- Wire format untouched; no `kWireVersion` bump (stamps are computed at the
  same simulation time as before — costs are byte-identical on wifi).
- The NS-2 adapter keeps its single interface queue (degenerate case, #69
  remains the sibling gap for a measured NS-2 service time).
- `m_txQueues` cleanup rides `NotifyInterfaceDown`, so a dead ISL's residual
  backlog cannot inflate the aggregate signal (#260's fast path already fires
  there).

## References

[#206](https://github.com/danieljoppi/AntHocNet/issues/206) (decisions and
blocker analysis), #194/#202/#216 (the satellite claim this enables), #55/#67/#68
(A2 metric as shipped), #260 (interface-down fast path), ADR-0015 (the
one-build-per-regime axis this extends), `core/include/anthocnet/core/ports.h`,
`ns3/model/anthocnet-routing-protocol.cc`.
