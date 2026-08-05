// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

// Item 10/A2 (#55) — congestion-aware per-hop cost. With the MAC metric enabled
// and an ILinkState injected, a forward ant records (Q_mac+1)*T̂_mac at each node
// instead of its own wall-clock transit delta, so the summed path time T̂_d
// reflects sustained MAC load and data shifts off congested nodes. Default off
// (no ILinkState) preserves the item-02 wall-clock behaviour.
#include "anthocnet/core/ant_router_logic.h"
#include "anthocnet/core/config.h"
#include "anthocnet/core/link_metric.h"
#include "anthocnet/core/ports.h"
#include "test_support.h"

using namespace anthocnet::core;
using anthocnet::test::FakeClock;
using anthocnet::test::ScriptedRng;

namespace {

// Scriptable MAC signals for the node under test. Records every next hop the
// core queries so the per-next-hop contract (#206) is pinnable: unicast stamps
// must name the chosen next hop, broadcast/destination stamps must pass
// kInvalidAddress (= "no single outgoing interface, aggregate").
struct FakeLinkState : ILinkState {
    int    q    = 0;
    double tmac = 0.0;
    mutable std::vector<NodeAddress> queried;
    int macQueueLength(NodeAddress nextHop) const override {
        queried.push_back(nextHop);
        return q;
    }
    Time macServiceTime(NodeAddress nextHop) const override {
        queried.push_back(nextHop);
        return tmac;
    }
};

// An in-transit forward ant that has just left `src` heading to `dst`.
AntMessage inTransit(NodeAddress src, NodeAddress dst) {
    AntMessage a;
    a.type      = AntType::Reactive;
    a.direction = AntDirection::Up;
    a.src       = src;
    a.dst       = dst;
    a.seqNum    = 1;
    a.timeStart = 0.0;
    a.visited   = {{src, 0.0}};
    return a;
}

}  // namespace

int main() {
    // 1. Default (no ILinkState / gate off): the wall-clock delta is recorded,
    //    exactly as before this change.
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        Config cfg;  // enableMacMetric = false
        AntRouterLogic r(/*addr*/ 1, cfg, clock, rng);
        AntMessage a = inTransit(/*src*/ 0, /*dst*/ 9);
        clock.advance(0.3);
        r.stampForward(a, /*nextHop*/ 5);
        CHECK_EQ(a.visited.size(), static_cast<std::size_t>(2));
        CHECK_NEAR(a.visited.back().time, 0.3, 1e-9);
    }

    // 2. MAC metric on: records (Q+1)*T̂_mac and ignores wall-clock entirely.
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        Config cfg;
        cfg.enableMacMetric = true;
        FakeLinkState ls;
        ls.q = 3;
        ls.tmac = 0.02;
        AntRouterLogic r(1, cfg, clock, rng, /*metric*/ nullptr, &ls);
        AntMessage a = inTransit(0, 9);
        clock.advance(5.0);  // large wall-clock: must not leak into the cost
        r.stampForward(a, /*nextHop*/ 5);
        CHECK_NEAR(a.visited.back().time, (3 + 1) * 0.02, 1e-9);  // 0.08
    }

    // 3. Empty queue degrades to the plain smoothed service time.
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        Config cfg;
        cfg.enableMacMetric = true;
        FakeLinkState ls;
        ls.q = 0;
        ls.tmac = 0.02;
        AntRouterLogic r(1, cfg, clock, rng, nullptr, &ls);
        AntMessage a = inTransit(0, 9);
        r.stampForward(a, /*nextHop*/ 5);
        CHECK_NEAR(a.visited.back().time, 0.02, 1e-9);
    }

    // 4. No MAC sample yet (T̂_mac <= 0): fall back to the unloaded reference hop
    //    time rather than a zero-cost hop.
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        Config cfg;
        cfg.enableMacMetric = true;
        FakeLinkState ls;
        ls.q = 5;
        ls.tmac = 0.0;  // no sample observed
        AntRouterLogic r(1, cfg, clock, rng, nullptr, &ls);
        AntMessage a = inTransit(0, 9);
        r.stampForward(a, /*nextHop*/ 5);
        CHECK_NEAR(a.visited.back().time, cfg.hopTimeSec, 1e-9);
    }

    // 5. A negative queue length is clamped to 0 (defensive).
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        Config cfg;
        cfg.enableMacMetric = true;
        FakeLinkState ls;
        ls.q = -7;
        ls.tmac = 0.02;
        AntRouterLogic r(1, cfg, clock, rng, nullptr, &ls);
        AntMessage a = inTransit(0, 9);
        r.stampForward(a, /*nextHop*/ 5);
        CHECK_NEAR(a.visited.back().time, 0.02, 1e-9);  // (0+1)*0.02
    }

    // 6. Effect: a congested relay raises the summed path time, which lowers the
    //    pheromone ClassicMetric deposits (monotone-decreasing in path time), so
    //    the congested path becomes less preferred.
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        Config cfg;
        cfg.enableMacMetric = true;

        auto relayPathTime = [&](int q, double tmac) {
            FakeLinkState ls;
            ls.q = q;
            ls.tmac = tmac;
            AntRouterLogic r(1, cfg, clock, rng, nullptr, &ls);
            AntMessage a = inTransit(0, 9);
            r.stampForward(a, /*nextHop*/ 5);
            double t = 0.0;
            for (const AntHop& h : a.visited) t += h.time;
            return t;
        };
        const double idle = relayPathTime(0, 0.02);  // 0.02
        const double busy = relayPathTime(8, 0.02);  // 0.18
        CHECK(busy > idle);

        ClassicMetric m;
        LinkObservation oIdle;
        oIdle.hops = 1;
        oIdle.hopTime = cfg.hopTimeSec;
        oIdle.pathTime = idle;
        LinkObservation oBusy;
        oBusy.hops = 1;
        oBusy.hopTime = cfg.hopTimeSec;
        oBusy.pathTime = busy;
        CHECK(m.pheromone(oBusy) < m.pheromone(oIdle));
    }

    // 7. Per-next-hop contract through the real receive path (#206): the stamp
    //    happens where the outgoing interface is known, so the congestion
    //    signal is read for the queue the ant will actually wait in.
    {
        Config cfg;
        cfg.enableMacMetric = true;

        // 7a. Unicast: a routed forward ant stamps with its chosen next hop.
        {
            FakeClock clock;
            ScriptedRng rng({0.99});  // stay on the unicast branch (no proactive broadcast)
            FakeLinkState ls;
            ls.q = 2;
            ls.tmac = 0.02;
            AntRouterLogic r(/*addr*/ 1, cfg, clock, rng, nullptr, &ls);
            r.table().setPheromoneRegular(/*dest*/ 9, /*neighbor*/ 5, 0.9);
            AntMessage a = inTransit(/*src*/ 3, /*dst*/ 9);
            auto decisions = r.onReceiveAnt(a, /*prevHop*/ 3);
            CHECK_EQ(decisions.size(), static_cast<std::size_t>(1));
            CHECK(decisions[0].action == RouteAction::Unicast);
            CHECK_EQ(decisions[0].nextHop, 5);
            CHECK(!ls.queried.empty());
            for (NodeAddress qh : ls.queried) CHECK_EQ(qh, 5);
            CHECK_NEAR(decisions[0].message.visited.back().time, (2 + 1) * 0.02, 1e-9);
        }

        // 7b. Broadcast (no route): no single outgoing interface — the stamp
        //     queries kInvalidAddress, the aggregate-across-interfaces contract.
        {
            FakeClock clock;
            ScriptedRng rng({0.99});
            FakeLinkState ls;
            ls.q = 2;
            ls.tmac = 0.02;
            AntRouterLogic r(1, cfg, clock, rng, nullptr, &ls);
            AntMessage a = inTransit(3, 9);  // no pheromone for 9 anywhere
            auto decisions = r.onReceiveAnt(a, 3);
            CHECK_EQ(decisions.size(), static_cast<std::size_t>(1));
            CHECK(decisions[0].action == RouteAction::Broadcast);
            CHECK(!ls.queried.empty());
            for (NodeAddress qh : ls.queried) CHECK_EQ(qh, kInvalidAddress);
        }

        // 7c. Destination: the terminal node still contributes its own cost to
        //     the backward ant's path time (aggregate — it forwards nowhere).
        {
            FakeClock clock;
            ScriptedRng rng({0.99});
            FakeLinkState ls;
            ls.q = 2;
            ls.tmac = 0.02;
            AntRouterLogic r(/*addr*/ 9, cfg, clock, rng, nullptr, &ls);
            AntMessage a = inTransit(3, /*dst*/ 9);
            a.visited = {{3, 0.0}, {4, 0.01}};
            auto decisions = r.onReceiveAnt(a, /*prevHop*/ 4);
            CHECK_EQ(decisions.size(), static_cast<std::size_t>(1));
            CHECK(decisions[0].action == RouteAction::Unicast);  // backward ant home
            CHECK(!ls.queried.empty());
            for (NodeAddress qh : ls.queried) CHECK_EQ(qh, kInvalidAddress);
            // The destination's own stamp is on the retraced path: after
            // advanceBackAnt moved node 9 onto history, its cost is there.
            CHECK_EQ(decisions[0].message.history.size(), static_cast<std::size_t>(1));
            CHECK_EQ(decisions[0].message.history.back().node, 9);
            CHECK_NEAR(decisions[0].message.history.back().time, (2 + 1) * 0.02, 1e-9);
        }
    }

    return RUN_TESTS();
}
