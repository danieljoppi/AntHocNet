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

    // 4. Losing the only path to a dest emits a LinkFail notification (new best 0).
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 0, cfg, clock, rng);
        router.learnNeighbor(5);
        router.table().setPheromoneRegular(/*dest*/ 9, /*neighbor*/ 5, 0.8);

        clock.advance(cfg.helloInterval * cfg.allowedHelloLoss + 0.1);
        auto decs = router.onMaintenanceTick();
        bool found = false;
        for (const RouteDecision& d : decs) {
            if (d.action == RouteAction::Broadcast && d.message.type == AntType::LinkFail) {
                for (const HelloDest& a : d.message.helloDests) {
                    if (a.node == 9) { found = true; CHECK_NEAR(a.pheromone, 0.0, 1e-12); }
                }
            }
        }
        CHECK(found);
    }

    // 5. A node receiving a LinkFail that costs it its only path propagates it;
    //    one with a surviving better path absorbs it.
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 0, cfg, clock, rng);
        router.table().setPheromoneRegular(9, 5, 0.8);  // only path to 9 via 5

        AntMessage note;
        note.type = AntType::LinkFail;
        note.direction = AntDirection::Up;
        note.src = 5;
        note.seqNum = 1;
        note.broadcastBudget = 2;
        note.helloDests = {{9, 0.0}};

        auto decs = router.onReceiveAnt(note, /*prevHop*/ 5);
        CHECK_EQ(decs.size(), static_cast<std::size_t>(1));
        CHECK(decs[0].action == RouteAction::Broadcast);
        CHECK(decs[0].message.type == AntType::LinkFail);
        CHECK_NEAR(router.table().getPheromoneRegular(9, 5), 0.0, 1e-12);
    }
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 0, cfg, clock, rng);
        router.table().setPheromoneRegular(9, 5, 0.3);  // reporter's (worse) path
        router.table().setPheromoneRegular(9, 6, 0.9);  // a better surviving path

        AntMessage note;
        note.type = AntType::LinkFail;
        note.direction = AntDirection::Up;
        note.src = 5;
        note.seqNum = 1;
        note.broadcastBudget = 2;
        note.helloDests = {{9, 0.0}};

        auto decs = router.onReceiveAnt(note, /*prevHop*/ 5);
        CHECK(decs.empty());  // best path (via 6) intact -> absorbed
    }

    // 6. A repair ant with broadcastBudget = 2 is broadcast at most twice across
    //    nodes (no route anywhere), then dropped on the third.
    {
        AntMessage rep;
        rep.type = AntType::Repair;
        rep.direction = AntDirection::Up;
        rep.src = 3;
        rep.dst = 99;
        rep.seqNum = 1;
        rep.broadcastBudget = 2;
        rep.visited = {{3, 0.0}};

        auto step = [&](AntMessage ant, NodeAddress addr, NodeAddress prevHop) {
            FakeClock clock;
            ScriptedRng rng({0.5});
            AntRouterLogic node(addr, cfg, clock, rng);
            return node.onReceiveAnt(ant, prevHop);
        };

        auto d1 = step(rep, 11, 3);
        CHECK_EQ(d1.size(), static_cast<std::size_t>(1));
        CHECK(d1[0].action == RouteAction::Broadcast);
        CHECK_EQ(d1[0].message.broadcastBudget, 1);

        auto d2 = step(d1[0].message, 12, 11);
        CHECK(d2[0].action == RouteAction::Broadcast);
        CHECK_EQ(d2[0].message.broadcastBudget, 0);

        auto d3 = step(d2[0].message, 13, 12);
        CHECK(d3[0].action == RouteAction::Drop);
    }

    // 7. reportTxFailure (detector D): losing the data next hop prunes it, emits
    //    a LinkFail notification, and broadcasts a counted bounded Repair ant
    //    toward the failed data destination.
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 0, cfg, clock, rng);
        router.learnNeighbor(5);
        router.table().setPheromoneRegular(/*dest*/ 9, /*neighbor*/ 5, 0.8);

        auto decs = router.reportTxFailure(/*next*/ 5, /*dataDest*/ 9);

        bool linkFail = false, repair = false;
        for (const RouteDecision& d : decs) {
            if (d.action != RouteAction::Broadcast) continue;
            if (d.message.type == AntType::LinkFail) linkFail = true;
            if (d.message.type == AntType::Repair) {
                repair = true;
                CHECK_EQ(d.message.dst, static_cast<NodeAddress>(9));
                CHECK_EQ(d.message.broadcastBudget, cfg.repairMaxBroadcasts - 1);
            }
        }
        CHECK(linkFail);
        CHECK(repair);
        CHECK_EQ(router.antsSent(AntType::Repair), static_cast<std::uint64_t>(1));
        CHECK_NEAR(router.table().getPheromoneRegular(9, 5), 0.0, 1e-12);
    }

    // 8. reportTxFailure for a failed *ant* (no dataDest) cleans up but sends no
    //    repair ant.
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 0, cfg, clock, rng);
        router.learnNeighbor(5);

        auto decs = router.reportTxFailure(/*next*/ 5);
        for (const RouteDecision& d : decs) {
            CHECK(d.message.type != AntType::Repair);
        }
        CHECK_EQ(router.antsSent(AntType::Repair), static_cast<std::uint64_t>(0));
        CHECK_EQ(router.table().numNeighbors(), static_cast<std::size_t>(0));
    }

    return RUN_TESTS();
}
