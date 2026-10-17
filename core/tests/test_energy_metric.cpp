// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

// #145: the energy-aware metric. A hop costs 1 / residual energy of the node
// that forwards over it (floored); a route costs the sum; the pheromone is
// the inverse. Unknown energy costs 1, so the metric degrades to hop count.
// Each node prices only its own hop, so nothing new travels on the wire.
#include <cmath>
#include <limits>

#include "anthocnet/core/ant_router_logic.h"
#include "anthocnet/core/config.h"
#include "anthocnet/core/link_metric_registry.h"
#include "test_support.h"

using namespace anthocnet::core;
using anthocnet::test::FakeClock;
using anthocnet::test::ScriptedRng;

namespace {

class FakeEnergy : public IEnergy {
public:
    double e = 1.0;
    double residualEnergyFraction() const override { return e; }
};

}  // namespace

int main() {
    const double nan = std::numeric_limits<double>::quiet_NaN();

    // 1. Registered, asks for link quality; the hop cost is 1 / e, floored.
    const ILinkMetric* energy = metrics::find(metrics::kEnergy);
    CHECK(energy != nullptr);
    CHECK(energy->usesLinkQuality());
    CHECK(metrics::registeredNames().find("energy") != std::string::npos);
    HopSignals s;
    s.residualEnergy = 1.0;
    CHECK_NEAR(energy->hopCost(s), 1.0, 1e-12);
    s.residualEnergy = 0.25;
    CHECK_NEAR(energy->hopCost(s), 4.0, 1e-12);
    s.residualEnergy = 0.0;  // empty: the floor caps the cost
    CHECK_NEAR(energy->hopCost(s), 1.0 / s.energyFloor, 1e-9);
    s.residualEnergy = nan;  // unknown: no evidence against the link
    CHECK_NEAR(energy->hopCost(s), 1.0, 1e-12);

    // 2. The SINR metric still prices hops by SINR through the same hook.
    {
        HopSignals q;
        q.sinrDb = 10.0;
        q.residualEnergy = 0.1;  // ignored by SINR
        CHECK_NEAR(metrics::get(metrics::kSinr).hopCost(q), q.sinrPenaltyCost, 1e-12);
    }

    // 3. In the router: a drained node's one-hop entries are worth less, and
    //    a node with no energy model behaves as hop count.
    FakeClock clock;
    ScriptedRng rng({0.5});
    const Config cfg;
    FakeEnergy battery;
    {
        AntRouterLogic full(1, cfg, clock, rng, energy);
        full.setEnergy(&battery);
        full.learnNeighbor(2);
        battery.e = 0.5;
        AntRouterLogic half(1, cfg, clock, rng, energy);
        half.setEnergy(&battery);
        half.learnNeighbor(2);
        AntRouterLogic unknown(1, cfg, clock, rng, energy);
        unknown.learnNeighbor(2);
        CHECK_NEAR(half.linkCost(2), 2.0, 1e-12);
        CHECK_NEAR(unknown.linkCost(2), 1.0, 1e-12);
        CHECK(half.table().getPheromoneRegular(2, 2) < full.table().getPheromoneRegular(2, 2));
        CHECK_NEAR(unknown.table().getPheromoneRegular(2, 2),
                   full.table().getPheromoneRegular(2, 2), 1e-12);
    }

    // 4. The classic metric never reads the port.
    {
        battery.e = 0.01;
        AntRouterLogic classic(1, cfg, clock, rng);
        classic.setEnergy(&battery);
        CHECK_NEAR(classic.linkCost(2), cfg.hopTimeSec, 1e-15);
    }

    return RUN_TESTS();
}
