// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

// #181: the SINR link metric (Ducatelle 2007 thesis, eq. 4.11) and the
// ILinkQuality port it reads. Each link costs 1 above SINR_c and c_const at or
// below it; a route costs the sum; pheromone is the inverse. Each node puts its
// own estimate of the link a backward ant came over into that hop (§4.2.2).
#include <cmath>
#include <limits>
#include <map>

#include "anthocnet/core/ant_router_logic.h"
#include "anthocnet/core/config.h"
#include "anthocnet/core/link_metric_registry.h"
#include "test_support.h"

using namespace anthocnet::core;
using anthocnet::test::FakeClock;
using anthocnet::test::ScriptedRng;

namespace {

// Scripted per-neighbour SINR; unknown neighbours have no sample (NaN).
class FakeLinkQuality : public ILinkQuality {
public:
    std::map<NodeAddress, double> sinr;
    double sinrDbFrom(NodeAddress n) const override {
        auto it = sinr.find(n);
        return it == sinr.end() ? std::numeric_limits<double>::quiet_NaN() : it->second;
    }
};

}  // namespace

int main() {
    const double nan = std::numeric_limits<double>::quiet_NaN();
    const Config cfg;

    // 1. Eq. 4.11: 1 above SINR_c, c_const at or below it, NaN = no sample = good.
    CHECK_EQ(sinrLinkCost(25.0, 17.0, 3.0), 1.0);
    CHECK_EQ(sinrLinkCost(17.01, 17.0, 3.0), 1.0);
    CHECK_EQ(sinrLinkCost(17.0, 17.0, 3.0), 3.0);  // "if SINR <= SINR_c"
    CHECK_EQ(sinrLinkCost(4.0, 17.0, 3.0), 3.0);
    CHECK_EQ(sinrLinkCost(nan, 17.0, 3.0), 1.0);

    // 2. Registered under "sinr", asks for link quality; classic does not.
    const ILinkMetric* sinr = metrics::find(metrics::kSinr);
    CHECK(sinr != nullptr);
    CHECK(sinr->usesLinkQuality());
    CHECK(!metrics::get(metrics::kClassic).usesLinkQuality());
    CHECK(metrics::registeredNames().find("sinr") != std::string::npos);

    // 3. Pheromone is the inverse of the summed link costs (eq. 4.3), never
    //    above the inverse hop count.
    {
        LinkObservation o;
        o.hops = 3;
        o.pathTime = 5.0;  // 1 + 1 + 3
        CHECK_NEAR(sinr->pheromone(o), 0.2, 1e-12);
        o.pathTime = 0.004;  // stray time values cannot beat the hop count
        CHECK_NEAR(sinr->pheromone(o), 1.0 / 3.0, 1e-12);
    }

    // 4. The backward ant: node 0 receives a back ant over neighbour 7. Its
    //    own estimate of the link to 7 (SINR 10 dB -> cost 3) replaces that
    //    hop's value; the hops further on keep what upstream nodes wrote.
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        FakeLinkQuality lq;
        lq.sinr[7] = 10.0;
        AntRouterLogic router(/*address*/ 0, cfg, clock, rng, sinr, nullptr, &lq);
        router.learnNeighbor(7);

        AntMessage back;
        back.type = AntType::Reactive;
        back.direction = AntDirection::Down;
        back.src = 9;  // the destination that answered
        back.dst = 0;  // back at the origin after this hop
        back.seqNum = 1;
        back.history.push_back({9, 1.0});    // link 8 -> 9, written at node 8
        back.history.push_back({8, 1.0});    // link 7 -> 8, written at node 7
        back.history.push_back({7, 0.002});  // link 0 -> 7: still a wall-clock delta
        router.onReceiveAnt(back, 7);
        // Route 0 -> 7 -> 8 -> 9 costs 3 + 1 + 1 = 5, so the deposit is 1/5.
        AntMessage probe = back;
        probe.history.back().time = 3.0;
        CHECK_NEAR(router.backAntPheromone(probe), 0.2, 1e-12);
        CHECK(router.table().getPheromoneRegular(9, 7) > 0.0);

        // A good link to the same neighbour: the same route now costs 3.
        FakeLinkQuality good;
        good.sinr[7] = 30.0;
        AntRouterLogic r2(0, cfg, clock, rng, sinr, nullptr, &good);
        r2.learnNeighbor(7);
        AntMessage b2 = back;
        r2.onReceiveAnt(b2, 7);
        CHECK(r2.table().getPheromoneRegular(9, 7) > router.table().getPheromoneRegular(9, 7));
    }

    // 5. Neighbour refresh: the 1-hop entry is the inverse of the link cost.
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        FakeLinkQuality lq;
        lq.sinr[4] = 30.0;  // good -> cost 1
        lq.sinr[5] = 5.0;   // bad  -> cost 3
        AntRouterLogic router(0, cfg, clock, rng, sinr, nullptr, &lq);
        router.learnNeighbor(4);
        router.learnNeighbor(5);
        router.learnNeighbor(6);  // no sample -> good -> cost 1
        CHECK(router.table().getPheromoneRegular(4, 4) > router.table().getPheromoneRegular(5, 5));
        CHECK_NEAR(router.table().getPheromoneRegular(4, 4),
                   router.table().getPheromoneRegular(6, 6), 1e-12);
    }

    // 6. No port injected: every link is good, so the metric is hop count.
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        AntRouterLogic router(0, cfg, clock, rng, sinr);
        CHECK_EQ(router.linkCost(3), 1.0);
    }

    // 7. Classic is untouched: one hop still costs the unloaded T_hop.
    {
        FakeClock clock;
        ScriptedRng rng({0.5});
        FakeLinkQuality lq;
        lq.sinr[3] = 0.0;
        AntRouterLogic router(0, cfg, clock, rng, nullptr, nullptr, &lq);
        CHECK_EQ(router.linkCost(3), cfg.hopTimeSec);
    }

    return RUN_TESTS();
}
