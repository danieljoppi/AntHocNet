/*
 * Coverage for the proactive-ant, repair-ant and virtual-pheromone paths,
 * complementing the reactive-path coverage in test_router_logic.cpp.
 */
#include "anthocnet/core/ant_router_logic.h"
#include "test_support.h"

using namespace anthocnet::core;
using anthocnet::test::FakeClock;
using anthocnet::test::ScriptedRng;

int main() {
    Config cfg;

    // --- virtual pheromone changes proactive routing ----------------------
    // Destination 9 is reachable via a weak regular link (neighbour 2) and a
    // strong virtual link (neighbour 3). A reactive lookup uses only the
    // regular table (-> 2); a proactive lookup blends in the virtual table and
    // prefers neighbour 3.
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 1, cfg, clock, rng);
        router.table().setPheromoneRegular(/*dest*/ 9, /*neighbor*/ 2, 0.5);
        // The virtual setter doesn't register the neighbour (only the regular
        // one does), so add neighbour 3 explicitly as link detection would.
        router.table().addNeighbor(3);
        router.table().setPheromoneVirtual(/*dest*/ 9, /*neighbor*/ 3, 0.9);

        CHECK_EQ(router.selectNextHop(9, /*proactive=*/false), 2);
        CHECK_EQ(router.selectNextHop(9, /*proactive=*/true), 3);
    }

    // --- a hello ant builds virtual pheromone that then routes proactively -
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 1, cfg, clock, rng);

        // Give dest 9 a regular link so it is a known destination, plus learn
        // neighbour 3 directly.
        router.table().setPheromoneRegular(9, 2, 0.2);
        router.learnNeighbor(3);

        AntMessage hello;
        hello.type = AntType::Hello;
        hello.direction = AntDirection::Up;
        hello.src = 3;
        hello.seqNum = 1;
        hello.helloDests = {{9, 1.0}};   // neighbour 3 advertises a path to 9

        auto decisions = router.onReceiveAnt(hello, 3);
        CHECK(decisions.empty());                          // hello is consumed
        CHECK(router.table().getPheromoneVirtual(9, 3) > 0.0);
    }

    // --- proactive forward ant reaching its destination spawns a back ant --
    {
        FakeClock clock;
        clock.set(1.0);
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 9, cfg, clock, rng);

        AntMessage fwd;
        fwd.type = AntType::Proactive;
        fwd.direction = AntDirection::Up;
        fwd.src = 3;
        fwd.dst = 9;
        fwd.seqNum = 1;
        fwd.timeStart = 0.0;
        fwd.visited = {{3, 0.0}, {4, 0.01}};

        auto d = router.onReceiveAnt(fwd, /*prevHop*/ 4);
        CHECK_EQ(d.size(), static_cast<std::size_t>(1));
        CHECK(d[0].action == RouteAction::Unicast);
        CHECK_EQ(d[0].nextHop, 4);
        CHECK(d[0].message.direction == AntDirection::Down);
        CHECK(d[0].message.type == AntType::Proactive);
    }

    // --- repair forward ant in transit with no route broadcasts -----------
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 4, cfg, clock, rng);

        AntMessage rrfa;
        rrfa.type = AntType::Repair;
        rrfa.direction = AntDirection::Up;
        rrfa.src = 3;
        rrfa.dst = 9;
        rrfa.seqNum = 5;
        rrfa.lifeAnt = 2.0;
        rrfa.visited = {{3, 0.0}};

        auto d = router.onReceiveAnt(rrfa, 3);
        CHECK_EQ(d.size(), static_cast<std::size_t>(1));
        CHECK(d[0].action == RouteAction::Broadcast);
        CHECK_EQ(d[0].message.visited.back().node, 4);   // stamped self
    }

    // --- repair forward ant reaching its destination spawns a back ant ----
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 9, cfg, clock, rng);

        AntMessage rrfa;
        rrfa.type = AntType::Repair;
        rrfa.direction = AntDirection::Up;
        rrfa.src = 3;
        rrfa.dst = 9;
        rrfa.seqNum = 6;
        rrfa.visited = {{3, 0.0}, {4, 0.01}};

        auto d = router.onReceiveAnt(rrfa, 4);
        CHECK_EQ(d.size(), static_cast<std::size_t>(1));
        CHECK(d[0].action == RouteAction::Unicast);
        CHECK_EQ(d[0].nextHop, 4);
        CHECK(d[0].message.type == AntType::Repair);
        CHECK(d[0].message.direction == AntDirection::Down);
    }

    return RUN_TESTS();
}
