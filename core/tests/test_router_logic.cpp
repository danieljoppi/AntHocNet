#include "anthocnet/core/ant_router_logic.h"
#include "test_support.h"

using namespace anthocnet::core;
using anthocnet::test::FakeClock;
using anthocnet::test::ScriptedRng;

int main() {
    Config cfg;

    // --- data packet with no route: queue + reactive forward ant ----------
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 1, cfg, clock, rng);

        auto decisions = router.onDataPacket(/*dest*/ 9);
        CHECK_EQ(decisions.size(), static_cast<std::size_t>(2));
        CHECK(decisions[0].action == RouteAction::Queue);
        CHECK(decisions[1].action == RouteAction::Broadcast);
        CHECK(decisions[1].hasMessage);
        CHECK(decisions[1].message.type == AntType::Reactive);
        CHECK(decisions[1].message.direction == AntDirection::Up);
        CHECK_EQ(decisions[1].message.src, 1);
        CHECK_EQ(decisions[1].message.dst, 9);
    }

    // --- data packet with a known route: unicast --------------------------
    {
        FakeClock clock;
        ScriptedRng rng({0.01});
        AntRouterLogic router(/*addr*/ 1, cfg, clock, rng);
        router.table().setPheromoneRegular(/*dest*/ 9, /*neighbor*/ 5, 0.9);

        auto decisions = router.onDataPacket(9);
        CHECK_EQ(decisions.size(), static_cast<std::size_t>(1));
        CHECK(decisions[0].action == RouteAction::Unicast);
        CHECK_EQ(decisions[0].nextHop, 5);
        CHECK(!decisions[0].hasMessage);  // route the original data, no ant
    }

    // --- forward ant reaches its destination: spawn backward ant ----------
    {
        FakeClock clock;
        clock.set(1.0);
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 9, cfg, clock, rng);

        AntMessage fwd;
        fwd.type = AntType::Reactive;
        fwd.direction = AntDirection::Up;
        fwd.src = 3;
        fwd.dst = 9;
        fwd.seqNum = 1;
        fwd.timeStart = 0.0;
        fwd.visited = {{3, 0.0}, {4, 0.01}};

        auto decisions = router.onReceiveAnt(fwd, /*prevHop*/ 4);
        CHECK_EQ(decisions.size(), static_cast<std::size_t>(1));
        CHECK(decisions[0].action == RouteAction::Unicast);
        CHECK_EQ(decisions[0].nextHop, 4);  // back toward the path
        CHECK(decisions[0].message.direction == AntDirection::Down);
        CHECK_EQ(decisions[0].message.src, 9);
        CHECK_EQ(decisions[0].message.dst, 3);
        CHECK(decisions[0].message.pheromone > 0.0);

        // The previous hop was learned as a neighbour.
        CHECK(router.table().numNeighbors() >= 1u);

        // A duplicate of the same ant is dropped.
        auto dup = router.onReceiveAnt(fwd, 4);
        CHECK_EQ(dup.size(), static_cast<std::size_t>(1));
        CHECK(dup[0].action == RouteAction::Drop);
    }

    // --- forward ant in transit with no route: broadcast ------------------
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 4, cfg, clock, rng);

        AntMessage fwd;
        fwd.type = AntType::Reactive;
        fwd.src = 3;
        fwd.dst = 9;
        fwd.seqNum = 7;
        fwd.visited = {{3, 0.0}};

        auto decisions = router.onReceiveAnt(fwd, 3);
        CHECK_EQ(decisions.size(), static_cast<std::size_t>(1));
        CHECK(decisions[0].action == RouteAction::Broadcast);
        // This node appended itself to the visited stack before forwarding.
        CHECK_EQ(decisions[0].message.visited.size(), static_cast<std::size_t>(2));
        CHECK_EQ(decisions[0].message.visited.back().node, 4);
    }

    // --- hello ant is consumed and teaches a virtual route ----------------
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 1, cfg, clock, rng);

        AntMessage hello;
        hello.type = AntType::Hello;
        hello.direction = AntDirection::Up;
        hello.src = 2;
        hello.seqNum = 1;
        hello.helloDests = {{9, 1.0}};

        auto decisions = router.onReceiveAnt(hello, 2);
        CHECK(decisions.empty());  // consumed locally
        CHECK(router.table().numNeighbors() >= 1u);
        CHECK(router.table().getPheromoneVirtual(9, 2) > 0.0);
    }

    return RUN_TESTS();
}
