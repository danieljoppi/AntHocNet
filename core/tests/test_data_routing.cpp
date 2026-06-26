// Item 10 — data-loop suppression via prev-hop exclusion (A1) and the reactive
// forward-ant broadcast cap (A3).
#include "anthocnet/core/ant_router_logic.h"
#include "anthocnet/core/config.h"
#include "test_support.h"

using namespace anthocnet::core;
using anthocnet::test::FakeClock;
using anthocnet::test::ScriptedRng;

int main() {
    Config cfg;

    // A1.1 — a packet from neighbour 5 is not sent back to 5 while another hop
    // with pheromone exists; the only surviving candidate (6) is chosen for any r.
    {
        FakeClock clock;
        ScriptedRng rng({0.05, 0.5, 0.95});
        AntRouterLogic router(/*addr*/ 0, cfg, clock, rng);
        router.table().setPheromoneRegular(/*dest*/ 9, /*neighbor*/ 5, 0.8);
        router.table().setPheromoneRegular(/*dest*/ 9, /*neighbor*/ 6, 0.5);
        for (int i = 0; i < 3; ++i) {
            CHECK_EQ(router.nextHopForData(9, /*prevHop*/ 5), 6);
        }
    }

    // A1.2 — "only option" fallback: if the excluded hop is the sole route, the
    // packet still forwards (no black hole).
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 0, cfg, clock, rng);
        router.table().setPheromoneRegular(9, 5, 0.8);
        CHECK_EQ(router.nextHopForData(9, /*prevHop*/ 5), 5);
    }

    // A1.3 — data still ignores virtual pheromone with exclusion in play.
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 0, cfg, clock, rng);
        router.table().addNeighbor(7);
        router.table().setPheromoneVirtual(9, 7, 0.5);
        CHECK_EQ(router.nextHopForData(9, /*prevHop*/ kInvalidAddress), kInvalidAddress);
    }

    // A3 — a reactive forward ant gets broadcastBudget == reactiveMaxBroadcasts
    // and is broadcast at most that many times in a pheromone-free region.
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        AntRouterLogic origin(/*addr*/ 1, cfg, clock, rng);
        AntMessage refa = origin.createForwardAnt(AntType::Reactive, /*dest*/ 99);
        CHECK_EQ(refa.broadcastBudget, cfg.reactiveMaxBroadcasts);

        auto step = [&](AntMessage ant, NodeAddress addr, NodeAddress prevHop) {
            FakeClock c;
            ScriptedRng r({0.5});
            AntRouterLogic node(addr, cfg, c, r);
            return node.onReceiveAnt(ant, prevHop);
        };
        refa.visited = {{1, 0.0}};
        auto d1 = step(refa, 11, 1);
        CHECK(d1[0].action == RouteAction::Broadcast);
        CHECK_EQ(d1[0].message.broadcastBudget, 1);
        auto d2 = step(d1[0].message, 12, 11);
        CHECK(d2[0].action == RouteAction::Broadcast);
        CHECK_EQ(d2[0].message.broadcastBudget, 0);
        auto d3 = step(d2[0].message, 13, 12);
        CHECK(d3[0].action == RouteAction::Drop);
    }

    return RUN_TESTS();
}
