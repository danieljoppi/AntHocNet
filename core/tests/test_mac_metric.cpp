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

// Scriptable MAC signals for the node under test.
struct FakeLinkState : ILinkState {
    int    q    = 0;
    double tmac = 0.0;
    int  macQueueLength() const override { return q; }
    Time macServiceTime() const override { return tmac; }
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
        r.stampForward(a);
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
        r.stampForward(a);
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
        r.stampForward(a);
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
        r.stampForward(a);
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
        r.stampForward(a);
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
            r.stampForward(a);
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

    return RUN_TESTS();
}
