// Item 05a — hello-timeout neighbour detection (ADR-0008 detector A): the
// portable, simulator-agnostic liveness path and the only detector NS-3 has.
// A neighbour not heard from within helloInterval*allowedHelloLoss is expired
// on the maintenance tick and its pheromone removed.
//
// LinkFail notification and bounded repair (criteria 2-4) land with item 05b's
// wire pass; this file covers detection.
#include "anthocnet/core/ant_router_logic.h"
#include "anthocnet/core/config.h"
#include "test_support.h"

using namespace anthocnet::core;
using anthocnet::test::FakeClock;
using anthocnet::test::ScriptedRng;

int main() {
    Config cfg;  // helloInterval = 1.0, allowedHelloLoss = 2 -> maxIdle = 2.0

    // 1. A silent neighbour is expired after maxIdle, along with its pheromone.
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 0, cfg, clock, rng);
        router.learnNeighbor(5);
        CHECK_EQ(router.table().numNeighbors(), static_cast<std::size_t>(1));

        clock.advance(cfg.helloInterval * cfg.allowedHelloLoss + 0.1);
        router.onMaintenanceTick();
        CHECK_EQ(router.table().numNeighbors(), static_cast<std::size_t>(0));
        CHECK_NEAR(router.table().getPheromoneRegular(5, 5), 0.0, 1e-12);
    }

    // 2. A neighbour heard from within the window survives the tick.
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 0, cfg, clock, rng);
        router.learnNeighbor(5);

        clock.advance(cfg.helloInterval);          // < maxIdle
        router.onMaintenanceTick();
        CHECK_EQ(router.table().numNeighbors(), static_cast<std::size_t>(1));
    }

    // 3. Reception refreshes last-seen, deferring expiry.
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 0, cfg, clock, rng);
        router.learnNeighbor(5);

        clock.advance(1.5);
        router.learnNeighbor(5);                   // refresh
        clock.advance(1.0);                        // 1.0 since refresh < maxIdle
        router.onMaintenanceTick();
        CHECK_EQ(router.table().numNeighbors(), static_cast<std::size_t>(1));

        clock.advance(cfg.helloInterval * cfg.allowedHelloLoss + 0.1);
        router.onMaintenanceTick();
        CHECK_EQ(router.table().numNeighbors(), static_cast<std::size_t>(0));
    }

    return RUN_TESTS();
}
