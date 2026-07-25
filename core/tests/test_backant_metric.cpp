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
        router.stampForward(fwd);  // delta 0.02
        clock.set(0.05);
        router.stampForward(fwd);  // delta 0.03 (cumulative 0.05 - prior 0.02)
        CHECK_EQ(fwd.visited.size(), static_cast<std::size_t>(3));
        CHECK_NEAR(fwd.visited[1].time, 0.02, 1e-9);
        CHECK_NEAR(fwd.visited[2].time, 0.03, 1e-9);
    }

    return RUN_TESTS();
}
