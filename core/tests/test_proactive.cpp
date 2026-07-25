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

    // --- thesis emission gate (issue #180) ---------------------------------
    // "only if the best virtual pheromone is significantly better (in our
    // experiments: at least 10% better) than the best regular pheromone, a
    // proactive forward ant is sent out" (Ducatelle 2007, lines 4084-4088).
    // Note setPheromoneVirtual() does not register the neighbour (unlike the
    // regular setter), and best*/next-hop selection iterate the neighbour set,
    // so the virtual neighbour is added explicitly below.

    // 10. Gate blocks: virtual is better, but by less than the 10% margin.
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        Config cfg;  // proactiveVirtualMargin = 0.10
        AntRouterLogic router(/*addr*/ 0, cfg, clock, rng);
        router.table().setPheromoneRegular(/*dest*/ 5, /*neighbor*/ 1, 1.0);
        router.table().addNeighbor(2);
        router.table().setPheromoneVirtual(/*dest*/ 5, /*neighbor*/ 2, 1.05);
        router.noteDataSession(5);
        CHECK(!router.shouldSendProactive(5));
        CHECK(router.createProactiveAnts().empty());
        CHECK_EQ(router.antsSent(AntType::Proactive), static_cast<std::uint64_t>(0));

        // The session is not consumed by a blocked tick: once diffusion turns
        // up pheromone that does clear the margin, the next tick emits.
        router.table().setPheromoneVirtual(5, 2, 1.5);
        std::vector<AntMessage> ants = router.createProactiveAnts();
        CHECK_EQ(ants.size(), static_cast<std::size_t>(1));
        CHECK_EQ(ants[0].dst, 5);
    }

    // 11. Gate passes: exactly 10% better clears it (the thesis's "at least").
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        Config cfg;
        AntRouterLogic router(/*addr*/ 0, cfg, clock, rng);
        router.table().setPheromoneRegular(/*dest*/ 5, /*neighbor*/ 1, 1.0);
        router.table().addNeighbor(2);
        router.table().setPheromoneVirtual(/*dest*/ 5, /*neighbor*/ 2, 1.10);
        router.noteDataSession(5);
        CHECK(router.shouldSendProactive(5));
        std::vector<AntMessage> ants = router.createProactiveAnts();
        CHECK_EQ(ants.size(), static_cast<std::size_t>(1));
        CHECK(ants[0].type == AntType::Proactive);
        CHECK_EQ(router.antsSent(AntType::Proactive), static_cast<std::uint64_t>(1));
    }

    // 12. Margin 0 = gate off = pre-#180 behaviour: emit unconditionally, even
    //     with a good regular route and no virtual pheromone at all.
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        Config cfg;
        cfg.proactiveVirtualMargin = 0.0;
        AntRouterLogic router(/*addr*/ 0, cfg, clock, rng);
        router.table().setPheromoneRegular(/*dest*/ 5, /*neighbor*/ 1, 1.0);
        router.noteDataSession(5);
        CHECK(router.shouldSendProactive(5));
        CHECK_EQ(router.createProactiveAnts().size(), static_cast<std::size_t>(1));
    }

    // 13. Boundary A — no regular route at all: always emit. Data is flowing to
    //     a destination we cannot route to, so this is the ant that matters
    //     most; the gate must never suppress it.
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        Config cfg;
        AntRouterLogic router(/*addr*/ 0, cfg, clock, rng);
        router.noteDataSession(5);  // empty table: no regular, no virtual
        CHECK(router.shouldSendProactive(5));
        CHECK_EQ(router.createProactiveAnts().size(), static_cast<std::size_t>(1));
    }

    // 14. Boundary B — a regular route exists but there is no virtual pheromone
    //     for the destination: suppress. "conditional to the availability of
    //     good new virtual pheromone" — there is none, so nothing to check.
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        Config cfg;
        AntRouterLogic router(/*addr*/ 0, cfg, clock, rng);
        router.table().setPheromoneRegular(/*dest*/ 5, /*neighbor*/ 1, 0.8);
        router.noteDataSession(5);
        CHECK(!router.shouldSendProactive(5));
        CHECK(router.createProactiveAnts().empty());
    }

    // 15. Diffusion off keeps its documented meaning ("proactive ants without
    //     virtual-pheromone guidance"), not "no proactive ants": with an empty
    //     virtual table by construction, the gate does not apply.
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        Config cfg;
        cfg.enableDiffusion = false;
        AntRouterLogic router(/*addr*/ 0, cfg, clock, rng);
        router.table().setPheromoneRegular(/*dest*/ 5, /*neighbor*/ 1, 0.8);
        router.noteDataSession(5);
        CHECK(router.shouldSendProactive(5));
        CHECK_EQ(router.createProactiveAnts().size(), static_cast<std::size_t>(1));
    }

    return RUN_TESTS();
}
