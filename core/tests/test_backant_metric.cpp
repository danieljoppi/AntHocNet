// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

// Item 02 — the backward-ant pheromone (Eq.2) blends a real, correctly-scaled
// path-time estimate with the hop-count term. Regression for deviation D2,
// where forward ants stored cumulative time, the back ant summed those
// cumulatives, and a stray /1000 against millisecond hopTime made the time
// term ~6 orders of magnitude too small (pheromone == inverse hop count).
#include "anthocnet/core/ant_router_logic.h"
#include "anthocnet/core/config.h"
#include "test_support.h"

using namespace anthocnet::core;
using anthocnet::test::FakeClock;
using anthocnet::test::ScriptedRng;

namespace {

// Pheromone a back ant deposits for a retraced path of per-hop deltas (seconds).
// The deposit state is reconstructed from `history` (ADR-0009).
double fullPathPheromone(AntRouterLogic& router, const std::vector<double>& deltas) {
    AntMessage back;
    back.direction = AntDirection::Down;
    back.src = 5;  // the destination that originated the back ant
    back.dst = 0;
    for (std::size_t i = 0; i < deltas.size(); ++i) {
        back.history.push_back({static_cast<NodeAddress>(i + 1), deltas[i]});
    }
    return router.backAntPheromone(back);
}

}  // namespace

int main() {
    FakeClock clock;
    ScriptedRng rng({0.5});
    Config cfg;  // hopTimeSec = T_hop default (3 ms, 2007 thesis, #88)
    AntRouterLogic router(/*address*/ 0, cfg, clock, rng);

    // 0. T_hop default is the value from the primary source (#88): Ducatelle,
    //    PhD thesis, USI Lugano 2007 — "we kept thop on 0.003 sec". [1] (PPSN
    //    2004) defines the constant but states no number, so this was a
    //    provisional 50 ms until the thesis was checked. Pinned here because
    //    it scales every pheromone deposit: a silent edit changes all routing
    //    goodness values at once.
    CHECK_NEAR(Config{}.hopTimeSec, 0.003, 1e-12);

    // 1. Time influences pheromone: equal hop count, different per-hop times ->
    //    the faster path earns strictly higher pheromone. (Pre-fix they tied,
    //    because the time term vanished and only hop count mattered.)
    const double fast = fullPathPheromone(router, {0.01, 0.01, 0.01});  // 0.03 s
    const double slow = fullPathPheromone(router, {0.10, 0.10, 0.10});  // 0.30 s
    CHECK(fast > slow);

    // 2. Units sane: a 3-hop path at ~50 ms/hop yields tau^-1 in a plausible
    //    seconds band (not ~1e-4). Expected value is derived from the config's
    //    T_hop rather than a literal, so changing the default (#88 moved it
    //    from 50 ms to the thesis's 3 ms) cannot break this check spuriously:
    //    tau^-1 = (measured + h*hopTimeSec)/2.
    const double tau = fullPathPheromone(router, {0.05, 0.05, 0.05});
    const double expected = (0.15 + 3 * cfg.hopTimeSec) / 2.0;
    CHECK(1.0 / tau > 0.01);
    CHECK(1.0 / tau < 0.5);
    CHECK_NEAR(1.0 / tau, expected, 1e-9);

    // 3. Hop term still present: with ~zero measured time, tau ~= (h*hopTimeSec/2)^-1.
    const double tauHopOnly = fullPathPheromone(router, {1e-9, 1e-9, 1e-9});
    CHECK_NEAR(1.0 / tauHopOnly, 3 * cfg.hopTimeSec / 2.0, 1e-6);

    // 4. Forward stamping records per-hop deltas, not cumulative-since-source.
    {
        clock.set(0.0);
        AntMessage fwd = router.createForwardAnt(AntType::Reactive, 9);  // visited=[{0,0}]
        clock.set(0.02);
        router.stampForward(fwd, kInvalidAddress);  // delta 0.02
        clock.set(0.05);
        router.stampForward(fwd, kInvalidAddress);  // delta 0.03 (cumulative 0.05 - prior 0.02)
        CHECK_EQ(fwd.visited.size(), static_cast<std::size_t>(3));
        CHECK_NEAR(fwd.visited[1].time, 0.02, 1e-9);
        CHECK_NEAR(fwd.visited[2].time, 0.03, 1e-9);
    }

    // 5. #185, thesis eq. 4.2: the hop count is smoothed per (dest, next hop)
    //    when hopCountAlpha > 0, and the default (0) leaves deposits exactly as
    //    before. Checked against a reference router fed the pheromone it should
    //    deposit, so the gamma running average is the same on both sides.
    {
        const NodeAddress dest = 5, nbr = 1;
        const double T = 0.004;  // path time of every ant below
        auto classic = [&](double h) {
            LinkObservation o;
            o.hops = h;
            o.pathTime = T;
            o.hopTime = cfg.hopTimeSec;
            return ClassicMetric().pheromone(o);
        };
        auto back = [&](int hops, NodeAddress via) {
            AntMessage b;
            b.direction = AntDirection::Down;
            b.src = dest;
            b.prevHop = via;
            b.hops = hops;
            b.pathTime = T;
            b.pheromone = classic(hops);  // what computeBackAntState would set
            return b;
        };
        auto refDeposit = [&](AntRouterLogic& ref, double tau) {
            AntMessage b = back(0, nbr);
            b.pheromone = tau;  // reference router deposits exactly tau
            ref.reinforceFromBackAnt(b);
        };

        CHECK_EQ(Config().hopCountAlpha, 0.0);  // default: smoothing off

        // Default: the deposit is the ant's own hop count, as before #185.
        {
            AntRouterLogic plain(0, cfg, clock, rng), ref(0, cfg, clock, rng);
            plain.learnNeighbor(nbr);
            ref.learnNeighbor(nbr);
            plain.reinforceFromBackAnt(back(2, nbr));
            plain.reinforceFromBackAnt(back(6, nbr));
            refDeposit(ref, classic(2));
            refDeposit(ref, classic(6));
            CHECK_EQ(plain.table().getPheromoneRegular(dest, nbr),
                     ref.table().getPheromoneRegular(dest, nbr));
        }

        // alpha = 0.7: first ant seeds h = 2; second ant (h = 6) deposits with
        // h = 0.7*2 + 0.3*6 = 3.2, not 6.
        Config sm = cfg;
        sm.hopCountAlpha = 0.7;
        {
            AntRouterLogic smooth(0, sm, clock, rng), ref(0, cfg, clock, rng);
            smooth.learnNeighbor(nbr);
            ref.learnNeighbor(nbr);
            smooth.reinforceFromBackAnt(back(2, nbr));
            smooth.reinforceFromBackAnt(back(6, nbr));
            refDeposit(ref, classic(2));
            refDeposit(ref, classic(0.7 * 2 + 0.3 * 6));
            CHECK_NEAR(smooth.table().getPheromoneRegular(dest, nbr),
                       ref.table().getPheromoneRegular(dest, nbr), 1e-12);
            // ...and genuinely differs from the unsmoothed deposit.
            AntRouterLogic raw(0, cfg, clock, rng);
            raw.learnNeighbor(nbr);
            raw.reinforceFromBackAnt(back(2, nbr));
            raw.reinforceFromBackAnt(back(6, nbr));
            CHECK(smooth.table().getPheromoneRegular(dest, nbr) >
                  raw.table().getPheromoneRegular(dest, nbr));

            // Losing the neighbour clears its route (and, for boundedness, its
            // estimate): the next ant re-seeds at h = 6 exactly instead of
            // averaging with the stale 3.2 of a path that no longer exists.
            smooth.loseNeighbor(nbr);
            smooth.learnNeighbor(nbr);
            smooth.reinforceFromBackAnt(back(6, nbr));
            AntRouterLogic ref2(0, cfg, clock, rng);
            ref2.learnNeighbor(nbr);
            refDeposit(ref2, classic(6));
            CHECK_NEAR(smooth.table().getPheromoneRegular(dest, nbr),
                       ref2.table().getPheromoneRegular(dest, nbr), 1e-12);
        }
    }

    return RUN_TESTS();
}
