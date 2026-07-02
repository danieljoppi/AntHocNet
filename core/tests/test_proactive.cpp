// Item 04 — proactive ants target active sessions and explore via a per-hop
// broadcast probability. Regression for deviation D4 (random-destination /
// fixed-timer proactive ants with no exploratory broadcast), plus the
// broadcast-budget cap (issue #45): a proactive ant that exhausts
// proactiveMaxBroadcasts is dropped on a route gap instead of flooding.
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

    // 7. Proactive ants originate with a bounded broadcast budget (issue #45).
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        Config cfg;
        AntRouterLogic router(/*addr*/ 0, cfg, clock, rng);
        router.noteDataSession(5);
        std::vector<AntMessage> ants = router.createProactiveAnts();
        CHECK_EQ(ants.size(), static_cast<std::size_t>(1));
        CHECK_EQ(ants[0].broadcastBudget, cfg.proactiveMaxBroadcasts);
    }

    // 8. Budget accounting on a route gap: each hop with no route decrements;
    //    a budget-exhausted proactive ant is dropped, not re-broadcast.
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        Config cfg;
        AntMessage ant = inTransit(AntType::Proactive, 3, 9);
        ant.broadcastBudget = 1;

        AntRouterLogic hop1(/*addr*/ 4, cfg, clock, rng);  // no route to 9
        auto d1 = hop1.onReceiveAnt(ant, /*prevHop*/ 3);
        CHECK_EQ(d1.size(), static_cast<std::size_t>(1));
        CHECK(d1[0].action == RouteAction::Broadcast);
        CHECK_EQ(d1[0].message.broadcastBudget, 0);

        AntRouterLogic hop2(/*addr*/ 5, cfg, clock, rng);  // no route either
        auto d2 = hop2.onReceiveAnt(d1[0].message, /*prevHop*/ 4);
        CHECK_EQ(d2.size(), static_cast<std::size_t>(1));
        CHECK(d2[0].action == RouteAction::Drop);
    }

    // 9. A budget-exhausted proactive ant that still HAS a route keeps
    //    following pheromone (the explore branch is skipped, never a drop).
    {
        FakeClock clock;
        ScriptedRng rng({0.05});  // < proactiveBroadcastProb: would explore
        Config cfg;
        AntRouterLogic router(/*addr*/ 4, cfg, clock, rng);
        router.table().setPheromoneRegular(9, 5, 0.8);
        AntMessage ant = inTransit(AntType::Proactive, 3, 9);
        ant.broadcastBudget = 0;
        auto d = router.onReceiveAnt(ant, /*prevHop*/ 3);
        CHECK_EQ(d.size(), static_cast<std::size_t>(1));
        CHECK(d[0].action == RouteAction::Unicast);
        CHECK_EQ(d[0].nextHop, 5);
    }

    return RUN_TESTS();
}
