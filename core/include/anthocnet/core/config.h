// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/**
 * Tunable AntHocNet parameters.
 *
 * These were compile-time constants in AntHocNetUtils (ALFA/BETA/GAMA/...).
 * Promoting them to a value type lets each adapter expose them as TCL binds
 * (NS-2) or TypeId attributes (NS-3) without touching the algorithm code.
 * The defaults reproduce the original constants.
 */
#ifndef ANTHOCNET_CORE_CONFIG_H
#define ANTHOCNET_CORE_CONFIG_H

#include <cstddef>

namespace anthocnet {
namespace core {

struct Config {
    /// Pheromone reinforcement / evaporation weights.
    double alpha = 0.7;  ///< ALFA: evaporation retains alpha of the value.
    double gamma = 0.7;  ///< GAMA: weight of the old value when reinforcing.

    /// Eq.1 exponents for the stochastic next-hop choice, from the primary
    /// source (#179): Ducatelle, *Adaptive Routing in Ad Hoc Wireless Multi-hop
    /// Networks*, PhD thesis, USI Lugano, 2007 — beta1 (reactive ants, eq 4.1)
    /// "we keep beta1 relatively high, on 20"; beta2 (proactive ants, eq 4.5)
    /// "normally kept on 20"; beta3 (data, eq 4.6) "we normally keep beta3
    /// on 20". All three are 20, so ants and data share one value here.
    ///
    /// This is a deliberate departure from [1] (PPSN 2004), which gives no
    /// absolute values but does state a *ratio*: data uses pheromone squared
    /// (§3.2 "the square ... to be more greedy") while ants use it unsquared
    /// (§3.3 "not squared, so that they sample the paths more evenly"). At the
    /// thesis values that asymmetry disappears. The thesis reaches exploration
    /// by other means — proactive ants route on max(regular, virtual) pheromone
    /// and carry a per-node broadcast probability — rather than by a lower
    /// exponent. Same precedent as hopTimeSec (#88): the thesis supplies numbers
    /// the paper omits, and its numbers win where the two disagree.
    ///
    /// Measured, not merely sourced (#179): a 20-seed x 900 s A/B over the six
    /// discrete scenarios, paired per seed, moved 5 of 6 to PAIRED-IMPROVED with
    /// no scenario regressing — PDR +0.50..+3.23 pp and routing load -9.7..-16.7%
    /// where significant. Only dense-small is neutral. The full table, the
    /// controls and the one adverse signal are on #179.
    ///
    /// betaAnts conflates the thesis's beta1 (reactive) and beta2 (proactive),
    /// which the thesis parameterises separately. They coincide at 20, so the
    /// conflation is harmless *here*; it stops being harmless if we ever want a
    /// value the thesis does not have — the thesis itself sweeps beta2 alone in
    /// chapter 5. Split the field before deviating per ant type, not after.
    double betaAnts = 20.0;  ///< exponent for ant next-hop choice (thesis beta1/beta2).
    double betaData = 20.0;  ///< exponent for data next-hop choice (thesis beta3).

    /// Per-hop time estimate used by the back-ant pheromone formula (Eq.2):
    /// the time to take one hop in unloaded conditions. In seconds, matching
    /// IClock, so it is comparable in magnitude to the measured path time.
    /// Value from the primary source (#88): Ducatelle, *Adaptive Routing in Ad
    /// Hoc Wireless Multi-hop Networks*, PhD thesis, USI Lugano, 2007 — "we
    /// kept thop on 0.003 sec". [1] (PPSN 2004) defines the constant but gives
    /// no number, which is why this was a provisional 50 ms until 2026-07-25.
    double hopTimeSec = 0.003;  ///< T_hop = 3 ms (2007 thesis)

    /// Congestion-aware per-hop cost (item 10/A2, [1] §3.2): when on and an
    /// ILinkState is injected, a forward ant records each node's expected
    /// send time (Q_mac+1)*T̂_mac instead of its own wall-clock transit delta,
    /// so the path-time term T̂_d reflects sustained MAC load. Gated + default
    /// off so the simpler item-02 metric stays the shipped default until a
    /// benchmark justifies the switch.
    bool enableMacMetric = false;

    /// Links whose pheromone drops below this are pruned.
    double minPheromone = 0.00001;  ///< MIN_PHEROMONE

    /// Time-proportional evaporation (ADR-0012): a secondary safety net, the
    /// only source of aging (reinforcement no longer ages competitors). Each
    /// tick ages every regular link by alpha^(dt/evaporationInterval). Gated so
    /// item 08 can run the paper-faithful "running-average only" ablation.
    bool   enableEvaporation   = true;
    double evaporationInterval = 1.0;  ///< reference interval (s) for the decay.

    /// At most one reactive forward ant per destination per this window, so a
    /// stream of packets to an unreachable destination doesn't flood ants
    /// ([1] §4.2).
    double reactiveRetryInterval = 1.0;

    /// Proactive / diffusion subsystem (ADR-0007), config-gated so the
    /// benchmark ablation (item 08) can justify the shipped default.
    bool enableProactive = true;   ///< master: proactive ants + diffusion.
    bool enableDiffusion = true;   ///< hello pheromone adverts + virtual table.

    /// Per-ant-type gates, completing the ablation surface the other
    /// `enable*` flags already provide. **All default true: turning none of
    /// them off reproduces current behaviour exactly.** They exist so the
    /// question "which ant types earn their keep in regime X?" is a
    /// measurement rather than an argument — the same discipline that chose
    /// the multipath and A2 defaults.
    ///
    /// There is deliberately **no** hello gate: ADR-0008 makes the
    /// hello-timeout detector the one mandatory liveness path, and hello also
    /// carries the diffusion adverts (`enableDiffusion`) and, on
    /// multi-interface adapters, the canonical→link-local peer mapping. Use
    /// `helloInterval` to make it cheaper; do not remove it.
    ///
    /// Note `enableReactive = false` removes the only source of *regular*
    /// pheromone in the default configuration, so routes never form unless
    /// something else installs them — which is exactly the interaction
    /// `enableDirectedReactive` + `enableDiffusion` is there to test.
    bool enableReactive = true;  ///< reactive forward ants (route discovery).
    bool enableRepair   = true;  ///< local repair ants after a link break ([1] §3.5).
    bool enableLinkFail = true;  ///< link-failure notifications ([1] §3.5).

    /// Directed reactive discovery (default **off** — an explicit deviation
    /// from [1] §3.1, kept behind a gate until a benchmark justifies it).
    ///
    /// [1] broadcasts a reactive forward ant wherever the current node has no
    /// pheromone for the destination. That is the right move when nothing is
    /// known — but it ignores information the protocol has already collected:
    /// the **virtual** pheromone table, built from hello diffusion adverts
    /// (ADR-0007), frequently holds a usable gradient toward a destination for
    /// which no *regular* pheromone exists yet. `selectNextHop` only blends the
    /// virtual table in for proactive ants, so a reactive ant floods past it.
    ///
    /// With this on, a reactive forward ant consults the virtual table before
    /// falling back to broadcast, and unicasts along it when it finds one. The
    /// flood becomes a directed walk wherever diffusion has reached, and stays
    /// a flood everywhere else.
    ///
    /// Deliberately **not** position- or topology-specific: the gradient is
    /// the protocol's own, so this behaves identically on a MANET and on a
    /// satellite ISL mesh, and needs neither GPS (cf. LAR/GPSR) nor an orbital
    /// model. Nothing new travels on the wire — the virtual table is local
    /// state — so this costs no `kWireVersion` bump.
    ///
    /// Risk to measure, not assume: a stale or wrong gradient sends the ant
    /// down a dead end where a flood would have found a path, trading overhead
    /// for discovery latency and possibly for delivery.
    bool enableDirectedReactive = false;

    /// Per-hop probability that an in-transit proactive forward ant is broadcast
    /// to explore for new paths rather than unicast along pheromone ([1] §3.3).
    double proactiveBroadcastProb = 0.1;
    /// A destination stays an "active session" (and is probed by proactive ants)
    /// for this many seconds after the last locally-originated data packet to it.
    double sessionTtl = 5.0;

    /// Emission gate for proactive forward ants (issue #180). The proactive
    /// timer *considers* one ant per active session; this is the fraction by
    /// which the best **virtual** pheromone for that destination must exceed the
    /// best **regular** pheromone before the ant is actually sent.
    ///
    /// Ducatelle 2007 thesis (lines 4084-4088): *"In order to improve
    /// efficiency, the actual sending of a proactive forward ant is conditional
    /// to the availability of good new virtual pheromone: only if the best
    /// virtual pheromone is significantly better (in our experiments: at least
    /// 10% better) than the best regular pheromone, a proactive forward ant is
    /// sent out."*
    ///
    /// Expressed as a **margin** (0.10 = "at least 10% better"), not as a 1.10
    /// ratio, so that `0` reads unambiguously as "no margin required" — i.e. the
    /// gate is off and every considered ant is sent, reproducing pre-#180
    /// behaviour for the ablation. See `shouldSendProactive()` for the
    /// boundary cases (no virtual pheromone; no regular route at all).
    ///
    /// **The comparison is per-link, not the thesis's literal best-vs-best**
    /// (ADR-0018, the #180 re-derivation): pass iff some neighbour's virtual
    /// pheromone beats the regular pheromone on that SAME link by the margin,
    /// with a hint on an unsampled link passing trivially. The scalar
    /// best-vs-best form compares estimators of different paths; its ratio has
    /// a structural ceiling tau(h-1)/tau(h) ~ h/(h-1) (measured byte-exact by
    /// `exp_uniformity_probe`), so any fixed margin m silently disables the
    /// gate for destinations farther than 1 + 1/m hops — on the old, corrupted
    /// clocks this was measured as pass rates of 0-3.8 % and, when forced on,
    /// +36-68 % NRL / -5 to -6.4 pp PDR (PR #188). The per-link ratio is
    /// degree- and hop-independent (probe: centred 0.97-1.06).
    ///
    /// **Defaults to 0 (gate OFF).** The re-derived shape makes a non-zero
    /// margin *meaningful* (probe-measured: m in 0.2-0.5 selects the genuine
    /// anomaly tail rather than a phase/hop artefact); adopting one as default
    /// is a benchmark decision on the regime that keeps proactive on (#248:
    /// satellite), owned by #180's A/B record.
    /// `core/tests/exp_gate_cascade.cpp` reproduces the historical failure.
    double proactiveVirtualMargin = 0.0;

    /// Timer intervals (seconds).
    double helloInterval     = 1.0;
    /// Proactive forward-ant period per active session. 10.0 is the
    /// long-standing repo value with no recorded source (#182); the thesis's
    /// §5.3.3 measured optimum is 2 s, but adopting it is #248's sweep to
    /// decide — PR #252 accidentally shipped 2.0 here while claiming not to,
    /// which the per-merge refresh measured as NRL ×4.7 / PDR −12 pp at
    /// paper-base (#254). Do not change this default without that A/B.
    double proactiveInterval = 10.0;
    double lifeAnt           = 2.0;

    /// A neighbour is presumed gone after this many missed hellos
    /// (maxIdle = helloInterval * allowedHelloLoss), per [1] §3.5.
    int allowedHelloLoss = 2;

    /// Max times a repair / link-failure ant may be (re)broadcast before being
    /// dropped, so local repair and failure notifications can't storm ([1] §3.5).
    int repairMaxBroadcasts = 2;

    /// Minimum spacing (s) between LinkFail notifications this node originates
    /// about the same destination. Under link flapping (evict -> hello
    /// re-learn -> evict) every cycle re-broadcast a fresh note about the same
    /// destinations, making origins ~98% of linkfail volume (issue #20).
    /// The #20 sweep picked 5.0: 1 s misses the ~3+ s flap cycle (no effect),
    /// 10 s starts costing PDR/delay. 0 disables the cooldown (the original
    /// spec has no rate limit).
    double linkfailNotifyInterval = 5.0;
    /// Consecutive MAC transmit-failures to the same next hop (with no reception
    /// from it in between) before the adapter's fast-path detector (ADR-0008
    /// detector D) treats the link as broken. Debounces transient congestion
    /// drops: a single retry-limit drop in a dense/contended network is usually a
    /// collision, not a topology change, and evicting the neighbour on it
    /// destroys valid routes and triggers rediscovery floods (issue #19).
    int txFailureThreshold = 3;
    /// Max times **one node** may broadcast **one reactive generation**
    /// `(src, seqNum)`. `-1` = unbounded. Default 2.
    ///
    /// **The unit of this field changed in #173 — read this before comparing it
    /// to an older run or an older sweep.** It used to be a budget carried on
    /// the ant and decremented at every hop, i.e. per *ant path*; it is now a
    /// counter held at each node per generation. Same name, same default,
    /// different meaning — the `alpha`/ADR-0012 trap, so it is spelled out
    /// here (see `docs/configuration.md`).
    ///
    /// Why per node. A reactive forward ant broadcasts wherever there is no
    /// pheromone for the destination, so a *per-path* budget is a hop limit on
    /// discovery: at 2, destinations more than ~5 hops away were permanently
    /// undiscoverable (#169), which is what made sparse/static fields look like
    /// an AntHocNet weakness. A *per-node* count does not limit reach at all —
    /// the ant may still travel arbitrarily far, each node along the way simply
    /// does not re-broadcast the same generation indefinitely.
    ///
    /// Why a bound is needed at all, given the sources describe none. The 2007
    /// thesis bounds proliferation by duplicate suppression ("subsequent copies
    /// are destroyed"), `maxPathLength` and the `antAcceptanceFactor` band. But
    /// with `enableMultipath` on (the default) a reactive forward ant is
    /// admitted by the acceptance band *instead of* `(src,seq)` duplicate
    /// suppression, and the band admits rather than suppresses. Removing the
    /// per-path budget in #169 therefore left no bound: one discovery on a
    /// 7x7 grid cost 30,090 ants, and ns-3 `large-scale` fell to 21.7% PDR at
    /// NRL 3071 (#173). This restores duplicate suppression's *intent* for the
    /// one ant type that bypasses it.
    ///
    /// **Default is now `-1` (unbounded), as of #177.** The two-factor band
    /// below (a1=0.9 / a2=2.0) bounds the flood on its own — one discovery on a
    /// 7x7 grid costs 154 ants with no count in force, ~3.1n and flat in n — so
    /// the per-node counter is no longer load-bearing, and leaving it on cost
    /// delivery in dense graphs (heavy-load +1.8 pp, large-scale +4.7 pp at
    /// 11.6%/25.6% less overhead once removed). Kept configurable for
    /// sensitivity experiments; any finite value still bounds re-broadcasts
    /// per (node, generation).
    int reactiveMaxBroadcasts = -1;
    /// Multipath reactive setup ([1] §3.1, issue #96): when on, a *later*
    /// reactive forward ant of an already-seen generation is forwarded if it
    /// passes the antAcceptanceFactor band below, laying down *multiple* good
    /// paths — and losing a best hop that leaves a usable alternate is absorbed
    /// instead of flooding a LinkFail (the churn bound; without it multipath
    /// regressed PDR on the ns-3 disk-model harness, #96 round 1). When off,
    /// every ant type uses strict (src,seq) dedup — only the first-arriving
    /// copy propagates (single-path setup). Default on: with the churn bound,
    /// multipath beat single-path on every headline metric in the paper regime
    /// (PDR 92.3 vs 89.4, delay/jitter/NRL all no worse; #96 round 2).
    bool enableMultipath = true;
    /// Multipath acceptance factor ([1] §3.1, "empirically set to 1.5"), used
    /// only when enableMultipath is on: a later same-generation reactive
    /// forward ant is forwarded only if both its hop count and its travel time
    /// are within this factor of the best ant of that generation seen so far.
    /// *Higher* admits *more* copies (more multipath, up to a flood); 1.0 still
    /// admits equal-metric copies, so no factor value reproduces strict
    /// single-path dedup — that is what enableMultipath=false is for.
    ///
    /// **Default is 0.9, not the 1.5 of [1] §3.1, as of #177.** The 2007
    /// Ducatelle thesis describes the same mechanism
    /// but states the value its authors actually ran, and it is *below* 1.0:
    ///
    ///   "If the number of hops and travel time of a newly received ant are
    ///    both within an acceptance factor a1 of those of the best previously
    ///    received ant of the same route setup, the new ant is accepted and
    ///    forwarded; otherwise, it is discarded. a1 is set quite low (to 0.9),
    ///    in order to only allow the best ants through and avoid too much
    ///    proliferation of forward ants in the network."
    ///                                    -- 2007 thesis, lines 4655-4659
    ///
    /// So a1 < 1 is deliberate: a later ant must be *strictly better* than the
    /// generation's best by ~10% on **both** metrics to be forwarded, which is
    /// what makes the band a suppressor rather than an admitter. This is the
    /// same field and the same meaning as on `main` — only the default moves —
    /// so it is not the #173 "unit changed under the name" trap.
    double antAcceptanceFactor = 0.9;
    /// Disjoint-path acceptance factor **a2** — the less restrictive factor
    /// applied when a reactive forward ant's *first hop* (the node it travelled
    /// to immediately after the source) has **not** been seen among the ants
    /// this node already accepted for that `(src, seqNum)` generation:
    ///
    ///   "To boost the creation of disjoint paths, a different mechanism is
    ///    applied, which takes into account the first hop taken by each ant. If
    ///    this first hop is different from those taken by previously accepted
    ///    ants, we apply a higher (less restrictive) acceptance factor a2 than
    ///    in the case the first hop was already seen before (a2 was set to 2)."
    ///                                    -- 2007 thesis, lines 4667-4671
    ///
    /// A new first hop is evidence that the ant arrived over a genuinely
    /// *disjoint* branch of the network, which is worth a path even when its
    /// metrics are worse than the incumbent's; a repeat first hop is a likely
    /// near-copy of a path already laid, so it must clear `antAcceptanceFactor`
    /// (a1). Used only when `enableMultipath` is on. Set below a1 and this
    /// mechanism inverts — it would penalise disjointness — so keep a2 >= a1.
    ///
    /// New field, deliberately not folded into `antAcceptanceFactor`: silently
    /// redefining an existing field's meaning is the #173 defect this repo has
    /// already paid for once (see `docs/configuration.md` §2).
    double antAcceptanceFactorNewHop = 2.0;
    /// Max times a proactive forward ant may be (re)broadcast — covering both the
    /// per-hop exploratory broadcast ([1] §3.3) and a route gap en route. Proactive
    /// ants monitor known paths; an unbounded budget let them flood any region of
    /// missing routes, amplifying route churn into control storms (issue #45).
    int proactiveMaxBroadcasts = 2;

    /// Local repair wait ([1] §3.5): after launching a repair ant, wait
    /// repairWaitFactor × the estimated end-to-end delay of the lost path for a
    /// backward repair ant; if none arrives, discard the buffered packets for
    /// that destination and send a link-failure notification (spec D6). The
    /// paper sets the factor empirically to 5.
    double repairWaitFactor = 5.0;
    /// Flat repair wait (seconds) used when the lost path has no usable delay
    /// estimate (e.g. its pheromone was already gone).
    double repairTimeout = 1.0;

    /// Conservative upper bound on path length for the expanding-ring search.
    int networkDiameter = 30;

    /// Bound the visited-node stack carried in a packet, and the (src,seq)
    /// dedup history, so a long-running simulation cannot grow them without
    /// limit (a latent issue in the original fixed-size malloc arrays).
    std::size_t maxPathLength = 100;
    std::size_t maxHistory    = 4096;
};

} // namespace core
} // namespace anthocnet

#endif // ANTHOCNET_CORE_CONFIG_H
