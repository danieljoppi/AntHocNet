// Item 04 — proactive ants target active sessions and explore via a per-hop
// broadcast probability. Regression for deviation D4 (random-destination /
// fixed-timer proactive ants with no exploratory broadcast).
//
// Note: the broadcast-budget cap (acceptance criterion 5) needs an on-wire
// AntMessage::broadcastBudget field, which is added with item 05's wire pass;
// it is not exercised here.
#include "anthocnet/core/ant_router_logic.h"
#include "anthocnet/core/config.h"
#include "test_support.h"

using namespace anthocnet::core;
using anthocnet::test::FakeClock;
using anthocnet::test::ScriptedRng;

namespace {

// An in-transit forward ant of the given type arriving at `router` from prevHop.
AntMessage inTransit(AntType type, NodeAddress src, NodeAddress dst) {
    AntMessage a;
    a.type = type;
    a.direction = AntDirection::Up;
    a.src = src;
    a.dst = dst;
    a.seqNum = 1;
    a.visited = {{src, 0.0}};
    return a;
}

}  // namespace

int main() {
    // 1. Only active destinations are probed.
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        Config cfg;
        AntRouterLogic router(/*addr*/ 0, cfg, clock, rng);
        router.noteDataSession(/*d1*/ 5);
        // d2 (7) never had data sent to it.
        std::vector<AntMessage> ants = router.createProactiveAnts();
        CHECK_EQ(ants.size(), static_cast<std::size_t>(1));
        CHECK_EQ(ants[0].dst, 5);
        CHECK(ants[0].type == AntType::Proactive);
    }

    // 2. Session expiry: no ants once sessionTtl has elapsed with no new data.
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        Config cfg;  // sessionTtl = 5.0
        AntRouterLogic router(/*addr*/ 0, cfg, clock, rng);
        router.noteDataSession(5);
        clock.advance(cfg.sessionTtl + 1.0);
        CHECK(router.createProactiveAnts().empty());
    }

    // 3. Per-hop exploratory broadcast for a proactive ant that HAS a route.
    //    rng < prob -> Broadcast; rng >= prob -> Unicast. (selectNextHop draws
    //    one uniform first, the broadcast test draws the next — ScriptedRng
    //    loops a single value so both draws are equal.)
    {
        FakeClock clock;
        Config cfg;
        {
            ScriptedRng rng({0.05});  // < 0.1
            AntRouterLogic router(/*addr*/ 4, cfg, clock, rng);
            router.table().setPheromoneRegular(/*dest*/ 9, /*neighbor*/ 5, 0.8);
            auto d = router.onReceiveAnt(inTransit(AntType::Proactive, 3, 9), /*prevHop*/ 3);
            CHECK_EQ(d.size(), static_cast<std::size_t>(1));
            CHECK(d[0].action == RouteAction::Broadcast);
        }
        {
            ScriptedRng rng({0.5});  // >= 0.1
            AntRouterLogic router(/*addr*/ 4, cfg, clock, rng);
            router.table().setPheromoneRegular(9, 5, 0.8);
            auto d = router.onReceiveAnt(inTransit(AntType::Proactive, 3, 9), 3);
            CHECK_EQ(d.size(), static_cast<std::size_t>(1));
            CHECK(d[0].action == RouteAction::Unicast);
            CHECK_EQ(d[0].nextHop, 5);
        }
    }

    // 4. Reactive ants never take the exploratory broadcast when a route exists.
    {
        FakeClock clock;
        ScriptedRng rng({0.05});  // would broadcast a proactive ant
        Config cfg;
        AntRouterLogic router(/*addr*/ 4, cfg, clock, rng);
        router.table().setPheromoneRegular(9, 5, 0.8);
        auto d = router.onReceiveAnt(inTransit(AntType::Reactive, 3, 9), 3);
        CHECK_EQ(d.size(), static_cast<std::size_t>(1));
        CHECK(d[0].action == RouteAction::Unicast);
    }

    // 6. Gate off => no proactive ants, and an in-transit proactive ant with a
    //    route is unicast (never explores). Data routing is unaffected.
    {
        FakeClock clock;
        ScriptedRng rng({0.05});
        Config cfg;
        cfg.enableProactive = false;
        AntRouterLogic router(/*addr*/ 4, cfg, clock, rng);
        router.noteDataSession(5);
        CHECK(router.createProactiveAnts().empty());

        router.table().setPheromoneRegular(9, 5, 0.8);
        auto d = router.onReceiveAnt(inTransit(AntType::Proactive, 3, 9), 3);
        CHECK_EQ(d.size(), static_cast<std::size_t>(1));
        CHECK(d[0].action == RouteAction::Unicast);
    }

    return RUN_TESTS();
}
