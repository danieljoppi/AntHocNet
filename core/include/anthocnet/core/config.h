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

    /// Eq.1 exponents for the stochastic next-hop choice. Ants explore with a
    /// small exponent; data is greedy with a larger one (betaData >= betaAnts).
    /// [1] uses pheromone^2 for data (§3.2 "the square ... to be more greedy")
    /// and unsquared pheromone for proactive ants (§3.3) — verified against the
    /// paper (docs/publications/papers/2004-ppsn-anthocnet.md) and A/B'd on the
    /// paper regime with multipath on (#70: performance-neutral vs the legacy
    /// 20/2, slightly better delay/jitter). The legacy constants BETA1=2/
    /// BETA2=20 had no basis in [1].
    double betaAnts = 1.0;   ///< exponent for ant next-hop choice ([1] §3.3, unsquared).
    double betaData = 2.0;   ///< exponent for data next-hop choice ([1] §3.2, squared).

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
    /// behaviour for the ablation. See `createProactiveAnts()` for the two
    /// boundary cases (no virtual pheromone; no regular route at all).
    double proactiveVirtualMargin = 0.10;

    /// Timer intervals (seconds).
    double helloInterval     = 1.0;
    /// Proactive forward-ant period per active session. **2.0 s is the thesis's
    /// measured optimum, not its stated default** — the thesis normally clocks
    /// proactive ants at `t_hello` (1 s) but its §5.3.3 sweep over
    /// 0.5/1/2/5/10/20/50 s reports *"Sending one ant every 2 s almost always
    /// gives the best performance"* (lines 6619-6621). Only affordable together
    /// with `proactiveVirtualMargin` (#180).
    double proactiveInterval = 2.0;
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
    int reactiveMaxBroadcasts = 2;
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
    double antAcceptanceFactor = 1.5;
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
