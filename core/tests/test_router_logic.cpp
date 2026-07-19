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
        Config sp = cfg;
        sp.enableMultipath = false;  // #96 gate off: single-path setup
        FakeClock clock;
        clock.set(1.0);
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 9, sp, clock, rng);

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
        // The back ant carries the retraced path in `history` (the deposit
        // pheromone is reconstructed from it at each receiver, not carried).
        CHECK(!decisions[0].message.history.empty());

        // The previous hop was learned as a neighbour.
        CHECK(router.table().numNeighbors() >= 1u);

        // #96 gate off: ANY same-generation copy — even one the multipath
        // filter would admit — is dropped by strict (src,seq) dedup
        // (pre-#96 single-path setup).
        AntMessage worse = fwd;
        worse.visited = {{3, 0.0}, {5, 0.005}, {6, 0.005}};  // comparable 3-hop path
        auto dropped = router.onReceiveAnt(worse, 6);
        CHECK_EQ(dropped.size(), static_cast<std::size_t>(1));
        CHECK(dropped[0].action == RouteAction::Drop);
    }

    // --- #96 multipath: a comparable second path of a generation is admitted --
    {
        Config mp = cfg;
        mp.enableMultipath = true;
        mp.antAcceptanceFactor = 1.5;
        FakeClock clock;
        clock.set(1.0);
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 9, mp, clock, rng);  // we are the dest

        // First ant of the generation: 2 hops, admitted -> backward ant.
        AntMessage a;
        a.type = AntType::Reactive;
        a.src = 3;
        a.dst = 9;
        a.seqNum = 42;
        a.visited = {{3, 0.0}, {4, 0.01}};
        auto first = router.onReceiveAnt(a, 4);
        CHECK_EQ(first.size(), static_cast<std::size_t>(1));
        CHECK(first[0].action == RouteAction::Unicast);  // back ant for path 1

        // A second copy of the SAME generation via a comparable alternate path
        // (3 hops, within 1.5x of the 2-hop best) is admitted -> a second back
        // ant, laying down the alternate path (multipath).
        AntMessage b;
        b.type = AntType::Reactive;
        b.src = 3;
        b.dst = 9;
        b.seqNum = 42;                       // same generation
        // 3 hops (<= 1.5*2) and total time 0.01 (<= 1.5*0.01): within the band.
        b.visited = {{3, 0.0}, {5, 0.005}, {6, 0.005}};
        auto second = router.onReceiveAnt(b, 6);
        CHECK_EQ(second.size(), static_cast<std::size_t>(1));
        CHECK(second[0].action == RouteAction::Unicast);  // back ant for path 2

        // A third copy via a much *worse* path (outside the 1.5x hop/time band
        // of the best seen) is dropped even with multipath on.
        AntMessage c;
        c.type = AntType::Reactive;
        c.src = 3;
        c.dst = 9;
        c.seqNum = 42;                       // same generation
        c.visited = {{3, 0.0}, {5, 0.05}, {6, 0.05}, {7, 0.05}};  // 4 hops vs 2
        auto dropped = router.onReceiveAnt(c, 7);
        CHECK_EQ(dropped.size(), static_cast<std::size_t>(1));
        CHECK(dropped[0].action == RouteAction::Drop);
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

    // --- 6.2: a forward ant past the hop cap is dropped -------------------
    {
        Config capCfg = cfg;
        capCfg.maxPathLength = 3;  // small cap for the test
        FakeClock clock;
        ScriptedRng rng({0.5});
        AntRouterLogic router(/*addr*/ 4, capCfg, clock, rng);

        // Already traversed maxPathLength hops before reaching us: dropped.
        AntMessage overCap;
        overCap.type = AntType::Reactive;
        overCap.src = 3;
        overCap.dst = 9;  // not us, so the drop is the hop cap, not delivery
        overCap.seqNum = 11;
        overCap.visited = {{3, 0.0}, {5, 0.0}, {6, 0.0}};  // size 3 == cap
        auto dropped = router.onReceiveAnt(overCap, 6);
        CHECK_EQ(dropped.size(), static_cast<std::size_t>(1));
        CHECK(dropped[0].action == RouteAction::Drop);

        // One hop below the cap: forwarded (broadcast, no route), not dropped.
        AntMessage underCap;
        underCap.type = AntType::Reactive;
        underCap.src = 3;
        underCap.dst = 9;
        underCap.seqNum = 12;
        underCap.visited = {{3, 0.0}, {5, 0.0}};  // size 2 < cap
        auto forwarded = router.onReceiveAnt(underCap, 5);
        CHECK_EQ(forwarded.size(), static_cast<std::size_t>(1));
        CHECK(forwarded[0].action == RouteAction::Broadcast);
    }

    return RUN_TESTS();
}
