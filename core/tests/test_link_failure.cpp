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
        // Issue #20: the re-broadcast is counted as a propagation, not an origin.
        CHECK_EQ(router.linkfailPropagations(), static_cast<std::uint64_t>(1));
        CHECK_EQ(router.linkfailBudgetDrops(), static_cast<std::uint64_t>(0));

        // Same situation but the inherited budget is exhausted: the propagation
        // is suppressed and counted as a budget drop.
        router.table().setPheromoneRegular(9, 5, 0.8);
        AntMessage spent = note;
        spent.seqNum = 2;
        spent.broadcastBudget = 0;
        auto decs2 = router.onReceiveAnt(spent, /*prevHop*/ 5);
        bool rebroadcast = false;
        for (const auto& d : decs2) {
            if (d.action == RouteAction::Broadcast) rebroadcast = true;
        }
        CHECK(!rebroadcast);
        CHECK_EQ(router.linkfailPropagations(), static_cast<std::uint64_t>(1));
        CHECK_EQ(router.linkfailBudgetDrops(), static_cast<std::uint64_t>(1));
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

    // 7. reportTxFailure (detector D): once the consecutive-failure threshold is
    //    reached, losing the data next hop prunes it, emits a LinkFail
    //    notification, and broadcasts a counted bounded Repair ant toward the
    //    failed data destination (no alternate path survives).
    {
        Config cfg1 = cfg; cfg1.txFailureThreshold = 1;  // act on the first failure
        FakeClock clock;
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 0, cfg1, clock, rng);
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
                CHECK_EQ(d.message.broadcastBudget, cfg1.repairMaxBroadcasts - 1);
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
        Config cfg1 = cfg; cfg1.txFailureThreshold = 1;
        FakeClock clock;
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 0, cfg1, clock, rng);
        router.learnNeighbor(5);

        auto decs = router.reportTxFailure(/*next*/ 5);
        for (const RouteDecision& d : decs) {
            CHECK(d.message.type != AntType::Repair);
        }
        CHECK_EQ(router.antsSent(AntType::Repair), static_cast<std::uint64_t>(0));
        CHECK_EQ(router.table().numNeighbors(), static_cast<std::size_t>(0));
    }

    // 9. Debounce (issue #19): failures below the threshold do NOT evict, and a
    //    reception in between resets the streak so transient drops are absorbed.
    {
        Config cfg3 = cfg; cfg3.txFailureThreshold = 3;
        FakeClock clock;
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 0, cfg3, clock, rng);
        router.learnNeighbor(5);

        CHECK(router.reportTxFailure(5, 9).empty());   // 1
        CHECK(router.reportTxFailure(5, 9).empty());   // 2 (still < 3)
        CHECK_EQ(router.table().numNeighbors(), static_cast<std::size_t>(1));

        router.learnNeighbor(5);                       // reception resets the streak
        CHECK(router.reportTxFailure(5, 9).empty());   // 1 again
        CHECK(router.reportTxFailure(5, 9).empty());   // 2
        CHECK_EQ(router.table().numNeighbors(), static_cast<std::size_t>(1));

        router.reportTxFailure(5, 9);                  // 3 -> evict
        CHECK_EQ(router.table().numNeighbors(), static_cast<std::size_t>(0));
    }

    // 10. Repair guard ([1] §3.5 "no other path available"): if a route to the
    //     destination survives via another neighbour, no repair ant is sent.
    {
        Config cfg1 = cfg; cfg1.txFailureThreshold = 1;
        FakeClock clock;
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 0, cfg1, clock, rng);
        router.learnNeighbor(5);
        router.learnNeighbor(6);
        router.table().setPheromoneRegular(/*dest*/ 9, /*neighbor*/ 5, 0.8);
        router.table().setPheromoneRegular(/*dest*/ 9, /*neighbor*/ 6, 0.5);  // alternate

        router.reportTxFailure(/*next*/ 5, /*dataDest*/ 9);  // lose 5, but 6 remains
        CHECK_EQ(router.antsSent(AntType::Repair), static_cast<std::uint64_t>(0));
        CHECK(router.table().getPheromoneRegular(9, 6) > 0.0);  // alternate intact
    }

    // 11. Repair wait/discard ([1] §3.5, D6): a repair that gets no backward
    //     ant within repairWaitFactor × the lost path's delay estimate makes
    //     the maintenance tick emit DiscardPending for the destination plus a
    //     LinkFail notification.
    {
        Config cfg1 = cfg; cfg1.txFailureThreshold = 1;
        FakeClock clock;
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 0, cfg1, clock, rng);
        router.learnNeighbor(5);
        router.table().setPheromoneRegular(/*dest*/ 9, /*neighbor*/ 5, 0.8);

        router.reportTxFailure(/*next*/ 5, /*dataDest*/ 9);  // launches the repair
        CHECK_EQ(router.antsSent(AntType::Repair), static_cast<std::uint64_t>(1));

        // Before the deadline (5 × 1/0.8 = 6.25 s) nothing fires.
        clock.advance(1.0);
        for (const RouteDecision& d : router.onMaintenanceTick()) {
            CHECK(d.action != RouteAction::DiscardPending);
        }

        // Past the deadline, still no route: discard + notify.
        clock.advance(cfg1.repairWaitFactor / 0.8);
        bool discard = false, notified = false;
        for (const RouteDecision& d : router.onMaintenanceTick()) {
            if (d.action == RouteAction::DiscardPending) {
                discard = true;
                CHECK_EQ(d.nextHop, static_cast<NodeAddress>(9));
            }
            if (d.action == RouteAction::Broadcast && d.message.type == AntType::LinkFail) {
                for (const HelloDest& a : d.message.helloDests) {
                    if (a.node == 9) { notified = true; CHECK_NEAR(a.pheromone, 0.0, 1e-12); }
                }
            }
        }
        CHECK(discard);
        CHECK(notified);

        // The deadline is one-shot: a later tick does not re-fire it.
        clock.advance(1.0);
        for (const RouteDecision& d : router.onMaintenanceTick()) {
            CHECK(d.action != RouteAction::DiscardPending);
        }
    }

    // 12. A backward ant from the destination within the window cancels the
    //     pending discard (the repair succeeded).
    {
        Config cfg1 = cfg; cfg1.txFailureThreshold = 1;
        FakeClock clock;
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 0, cfg1, clock, rng);
        router.learnNeighbor(5);
        router.table().setPheromoneRegular(/*dest*/ 9, /*neighbor*/ 5, 0.8);
        router.reportTxFailure(/*next*/ 5, /*dataDest*/ 9);

        AntMessage back;  // backward repair ant retracing 9 -> 0
        back.type = AntType::Repair;
        back.direction = AntDirection::Down;
        back.src = 9;
        back.dst = 0;
        back.seqNum = 7;
        back.visited = {{0, 0.0}};
        back.history = {{9, 0.05}};
        auto decs = router.onReceiveAnt(back, /*prevHop*/ 9);
        CHECK_EQ(decs.size(), static_cast<std::size_t>(1));
        CHECK(decs[0].action == RouteAction::Deliver);  // route to 9 restored

        clock.advance(cfg1.repairWaitFactor / 0.8 + 1.0);  // well past the deadline
        for (const RouteDecision& d : router.onMaintenanceTick()) {
            CHECK(d.action != RouteAction::DiscardPending);
        }
    }

    // 13. A route restored by other means (reactive ant, diffusion) also
    //     defuses the deadline: it lapses without a discard or notification.
    {
        Config cfg1 = cfg; cfg1.txFailureThreshold = 1;
        FakeClock clock;
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 0, cfg1, clock, rng);
        router.learnNeighbor(5);
        router.table().setPheromoneRegular(/*dest*/ 9, /*neighbor*/ 5, 0.8);
        router.reportTxFailure(/*next*/ 5, /*dataDest*/ 9);

        router.table().setPheromoneRegular(9, 6, 0.5);  // route reappeared via 6
        clock.advance(cfg1.repairWaitFactor / 0.8 + 1.0);
        CHECK(router.onMaintenanceTick().empty());
    }

    // 14. Issue #20: per-destination origin cooldown — a flapping link does not
    //     re-originate a LinkFail for the same destination within
    //     linkfailNotifyInterval; it resumes once the window elapses.
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 0, cfg, clock, rng);  // interval = 1.0 default
        auto hasLinkFail = [](const std::vector<RouteDecision>& decs) {
            for (const RouteDecision& d : decs) {
                if (d.action == RouteAction::Broadcast &&
                    d.message.type == AntType::LinkFail) return true;
            }
            return false;
        };

        router.table().setPheromoneRegular(9, 5, 0.8);
        CHECK(hasLinkFail(router.reportNeighborLoss(5)));  // first loss notifies

        router.table().setPheromoneRegular(9, 5, 0.8);     // flap: route re-forms
        clock.advance(0.4);                                // inside the window
        CHECK(!hasLinkFail(router.reportNeighborLoss(5)));
        CHECK_EQ(router.linkfailOriginsSuppressed(), static_cast<std::uint64_t>(1));

        router.table().setPheromoneRegular(9, 5, 0.8);     // flap again
        clock.advance(cfg.linkfailNotifyInterval + 0.1);   // window elapsed
        CHECK(hasLinkFail(router.reportNeighborLoss(5)));

        // interval = 0 disables the cooldown entirely.
        Config cfg0 = cfg;
        cfg0.linkfailNotifyInterval = 0.0;
        FakeClock clock0;
        ScriptedRng rng0({0.5});
        AntRouterLogic router0(/*addr*/ 0, cfg0, clock0, rng0);
        router0.table().setPheromoneRegular(9, 5, 0.8);
        CHECK(hasLinkFail(router0.reportNeighborLoss(5)));
        router0.table().setPheromoneRegular(9, 5, 0.8);
        CHECK(hasLinkFail(router0.reportNeighborLoss(5)));  // immediate repeat allowed
        CHECK_EQ(router0.linkfailOriginsSuppressed(), static_cast<std::uint64_t>(0));
    }

    // 15. #96 multipath churn bound: with multipath on, losing the best hop
    //     while a usable alternate next-hop survives originates NO LinkFail
    //     (the alternate carries the data); losing the last path still does.
    //     A received LinkFail is likewise absorbed, not re-flooded, when an
    //     alternate survives. Gate off keeps the pre-#96 notifications.
    {
        Config mp = cfg;
        mp.enableMultipath = true;
        auto hasLinkFail = [](const std::vector<RouteDecision>& decs) {
            for (const RouteDecision& d : decs) {
                if (d.action == RouteAction::Broadcast &&
                    d.message.type == AntType::LinkFail) return true;
            }
            return false;
        };

        FakeClock clock;
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 0, mp, clock, rng);
        router.table().setPheromoneRegular(9, 5, 0.8);  // best path via 5
        router.table().setPheromoneRegular(9, 6, 0.5);  // usable alternate via 6
        CHECK(!hasLinkFail(router.reportNeighborLoss(5)));  // alternate -> suppressed
        CHECK_EQ(router.linkfailOriginsSuppressed(), static_cast<std::uint64_t>(1));

        clock.advance(mp.linkfailNotifyInterval + 0.1);  // outside the #20 cooldown
        CHECK(hasLinkFail(router.reportNeighborLoss(6)));   // last path -> notify

        // Gate off, same topology: losing the best hop notifies (pre-#96).
        FakeClock clockOff;
        ScriptedRng rngOff({0.5});
        AntRouterLogic routerOff(/*addr*/ 0, cfg, clockOff, rngOff);
        routerOff.table().setPheromoneRegular(9, 5, 0.8);
        routerOff.table().setPheromoneRegular(9, 6, 0.5);
        CHECK(hasLinkFail(routerOff.reportNeighborLoss(5)));

        // Propagation side: a LinkFail that degrades our best but leaves a
        // usable alternate is applied yet absorbed with multipath on.
        FakeClock clockP;
        ScriptedRng rngP({0.5});
        AntRouterLogic routerP(/*addr*/ 0, mp, clockP, rngP);
        routerP.table().setPheromoneRegular(9, 5, 0.8);  // best via reporter 5
        routerP.table().setPheromoneRegular(9, 6, 0.5);  // alternate via 6

        AntMessage note;
        note.type = AntType::LinkFail;
        note.direction = AntDirection::Up;
        note.src = 5;
        note.seqNum = 1;
        note.broadcastBudget = 2;
        note.helloDests = {{9, 0.0}};
        auto decs = routerP.onReceiveAnt(note, /*prevHop*/ 5);
        CHECK(!hasLinkFail(decs));  // absorbed: 6 still carries the data
        CHECK_NEAR(routerP.table().getPheromoneRegular(9, 5), 0.0, 1e-12);  // applied

        // Losing the alternate too (a second note, now the last path) re-floods.
        AntMessage note2 = note;
        note2.src = 6;
        note2.seqNum = 2;
        auto decs2 = routerP.onReceiveAnt(note2, /*prevHop*/ 6);
        CHECK(hasLinkFail(decs2));
    }

    return RUN_TESTS();
}
