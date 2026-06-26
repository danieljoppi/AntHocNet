// Item 06 — time-proportional evaporation is gated and driven by the tick
// (6.1, ADR-0012), and reactive forward ants are rate-limited per destination
// (6.3, [1] §4.2).
#include "anthocnet/core/ant_router_logic.h"
#include "anthocnet/core/config.h"
#include "test_support.h"

using namespace anthocnet::core;
using anthocnet::test::FakeClock;
using anthocnet::test::ScriptedRng;

namespace {

int countBroadcasts(const std::vector<RouteDecision>& ds) {
    int n = 0;
    for (const RouteDecision& d : ds) {
        if (d.action == RouteAction::Broadcast) ++n;
    }
    return n;
}

}  // namespace

int main() {
    // 6.3 — one reactive ant per destination per reactiveRetryInterval.
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        Config cfg;  // reactiveRetryInterval = 1.0
        AntRouterLogic router(/*addr*/ 0, cfg, clock, rng);

        CHECK_EQ(countBroadcasts(router.onDataPacket(9)), 1);  // first: launch
        CHECK_EQ(countBroadcasts(router.onDataPacket(9)), 0);  // within window: suppressed
        CHECK_EQ(countBroadcasts(router.onDataPacket(9)), 0);

        clock.advance(cfg.reactiveRetryInterval + 0.01);
        CHECK_EQ(countBroadcasts(router.onDataPacket(9)), 1);  // window elapsed: relaunch

        // The data packet is always queued regardless of the ant rate.
        auto ds = router.onDataPacket(9);
        bool queued = false;
        for (const RouteDecision& d : ds) {
            if (d.action == RouteAction::Queue) queued = true;
        }
        CHECK(queued);
    }

    // 6.1 — evaporation on the tick, gated. Use dt below the neighbour-expiry
    // window so only aging (not expiry) is exercised.
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        Config cfg;  // helloInterval=1, allowedHelloLoss=2 -> maxIdle=2; interval=1
        AntRouterLogic router(/*addr*/ 0, cfg, clock, rng);
        router.learnNeighbor(5);
        router.table().setPheromoneRegular(9, 5, 0.8);

        clock.advance(1.0);              // < maxIdle, == evaporationInterval
        router.onMaintenanceTick();
        CHECK_NEAR(router.table().getPheromoneRegular(9, 5), 0.8 * 0.7, 1e-9);
    }
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        Config cfg;
        cfg.enableEvaporation = false;
        AntRouterLogic router(/*addr*/ 0, cfg, clock, rng);
        router.learnNeighbor(5);
        router.table().setPheromoneRegular(9, 5, 0.8);

        clock.advance(1.0);
        router.onMaintenanceTick();
        CHECK_NEAR(router.table().getPheromoneRegular(9, 5), 0.8, 1e-12);  // gated off
    }

    return RUN_TESTS();
}
