// SPDX-License-Identifier: MIT OR GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

// #572 adaptive evaporation: a destination's decay follows its route churn.
// A stable best next hop decays at the slowest permitted rate, one that keeps
// changing at the fastest; with the gate off, every destination decays at the
// fixed rate, exactly as before.
#include <cmath>

#include "anthocnet/core/ant_router_logic.h"
#include "anthocnet/core/config.h"
#include "anthocnet/core/pheromone_engine.h"
#include "test_support.h"

using namespace anthocnet::core;
using anthocnet::test::FakeClock;
using anthocnet::test::ScriptedRng;

namespace {

Config adaptive(bool on) {
    Config c;
    c.enableAdaptiveEvaporation = on;
    c.allowedHelloLoss = 1000;  // keep neighbours alive without hellos
    return c;
}

}  // namespace

int main() {
    // 1. The engine: a multiplier m ages a destination as if m x dt passed;
    //    destinations without one age at the fixed rate.
    {
        Config c;
        PheromoneEngine engine(c);
        PheromoneTable t;
        t.setPheromoneRegular(7, 1, 1.0);
        t.setPheromoneRegular(8, 1, 1.0);
        std::map<NodeAddress, double> m{{7, 2.0}};
        engine.evaporateAll(t, 1.0, &m);
        CHECK_NEAR(t.getPheromoneRegular(7, 1), std::pow(c.alpha, 2.0), 1e-12);
        CHECK_NEAR(t.getPheromoneRegular(8, 1), c.alpha, 1e-12);
    }

    // 2. A stable route settles at the slowest decay; a flapping one at the
    //    fastest.
    FakeClock clock;
    ScriptedRng rng({0.5});
    {
        AntRouterLogic r(1, adaptive(true), clock, rng);
        r.learnNeighbor(2);
        r.learnNeighbor(3);
        for (int i = 0; i < 60; ++i) {
            // dest 7: always via 2. dest 8: best hop alternates every tick.
            r.table().setPheromoneRegular(7, 2, 1.0);
            r.table().setPheromoneRegular(8, 2, i % 2 ? 1.0 : 0.1);
            r.table().setPheromoneRegular(8, 3, i % 2 ? 0.1 : 1.0);
            clock.advance(1.0);
            r.onMaintenanceTick();
        }
        CHECK_NEAR(r.evaporationMultiplier(7), r.config().adaptiveEvapMin, 1e-12);
        CHECK_NEAR(r.evaporationMultiplier(8), r.config().adaptiveEvapMax, 1e-12);
    }

    // 3. Gate off: no multiplier, the fixed rate everywhere.
    {
        AntRouterLogic r(1, adaptive(false), clock, rng);
        r.learnNeighbor(2);
        r.learnNeighbor(3);
        for (int i = 0; i < 10; ++i) {
            r.table().setPheromoneRegular(8, 2, i % 2 ? 1.0 : 0.1);
            r.table().setPheromoneRegular(8, 3, i % 2 ? 0.1 : 1.0);
            clock.advance(1.0);
            r.onMaintenanceTick();
        }
        CHECK_EQ(r.evaporationMultiplier(8), 1.0);
    }

    // 4. The churn estimate does not depend on the tick period: the same
    //    one-change-per-10 s pattern ticked every 1 s or every 0.5 s reads
    //    near the reference churn, so a multiplier near 1.
    for (double dt : {1.0, 0.5}) {
        AntRouterLogic r(1, adaptive(true), clock, rng);
        r.learnNeighbor(2);
        r.learnNeighbor(3);
        const int ticks = static_cast<int>(400 / dt);
        for (int i = 0; i < ticks; ++i) {
            const bool via2 = static_cast<int>(i * dt / 10.0) % 2 == 0;
            r.table().setPheromoneRegular(8, 2, via2 ? 1.0 : 0.1);
            r.table().setPheromoneRegular(8, 3, via2 ? 0.1 : 1.0);
            clock.advance(dt);
            r.onMaintenanceTick();
        }
        const double m = r.evaporationMultiplier(8);
        CHECK(m > 0.4 && m < 2.0);
    }

    return RUN_TESTS();
}
