// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

// PheromoneTable::nextHopDistribution (#546): the read-only view of the
// distribution nextNeighborNode() samples. The learn site scores a player's
// next-hop prediction against it, so it must be *exactly* the sampler's
// distribution -- checked here by driving the sampler with every r on a grid
// and requiring it to land in the interval the distribution assigns.

#include <cmath>

#include "anthocnet/core/pheromone_table.h"
#include "test_support.h"

using namespace anthocnet::core;
using anthocnet::test::ScriptedRng;

namespace {

/// Which neighbour the cumulative distribution assigns to draw r.
NodeAddress pickFromDistribution(const std::vector<std::pair<NodeAddress, double>>& d, double r) {
    NodeAddress chosen = kInvalidAddress;
    for (const auto& e : d) {
        chosen = e.first;
        r -= e.second;
        if (r <= 0.0) break;
    }
    return chosen;
}

double total(const std::vector<std::pair<NodeAddress, double>>& d) {
    double s = 0;
    for (const auto& e : d) s += e.second;
    return s;
}

}  // namespace

int main() {
    PheromoneTable t;
    t.addNeighbor(1);
    t.addNeighbor(2);
    t.addNeighbor(3);
    t.setPheromoneRegular(9, 1, 1.0);
    t.setPheromoneRegular(9, 2, 2.0);
    // neighbour 3 has no pheromone toward 9.

    // beta = 2: weights 1 and 4 -> 0.2 / 0.8; neighbour 3 absent.
    auto d = t.nextHopDistribution(9, false, 2.0);
    CHECK_EQ(d.size(), static_cast<std::size_t>(2));
    CHECK_EQ(d[0].first, 1);
    CHECK_EQ(d[1].first, 2);
    CHECK(std::fabs(d[0].second - 0.2) < 1e-12);
    CHECK(std::fabs(d[1].second - 0.8) < 1e-12);
    CHECK(std::fabs(total(d) - 1.0) < 1e-12);

    // It is the sampler's distribution: for every draw r the sampler lands
    // where the cumulative distribution says, at several betas.
    for (double beta : {1.0, 2.0, 20.0}) {
        const auto dist = t.nextHopDistribution(9, false, beta);
        for (int k = 1; k < 1000; ++k) {
            const double r = k / 1000.0;
            ScriptedRng rng({r});
            CHECK_EQ(t.lookup(9, beta, rng), pickFromDistribution(dist, r));
        }
    }

    // Excluding the previous hop renormalises over the rest...
    d = t.nextHopDistribution(9, false, 2.0, /*exclude=*/2);
    CHECK_EQ(d.size(), static_cast<std::size_t>(1));
    CHECK_EQ(d[0].first, 1);
    CHECK(std::fabs(d[0].second - 1.0) < 1e-12);

    // ...and falls back to it when it is the only option (A1), as the sampler does.
    PheromoneTable only;
    only.addNeighbor(5);
    only.setPheromoneRegular(9, 5, 3.0);
    d = only.nextHopDistribution(9, false, 20.0, /*exclude=*/5);
    CHECK_EQ(d.size(), static_cast<std::size_t>(1));
    CHECK_EQ(d[0].first, 5);
    {
        ScriptedRng rng({0.5});
        CHECK_EQ(only.lookup(9, 20.0, rng, /*exclude=*/5), 5);
    }

    // Unknown destination: no route, empty distribution.
    CHECK(t.nextHopDistribution(42, false, 2.0).empty());

    // Proactive ants blend in virtual pheromone (max of the two per link) and
    // may route toward a virtual-only destination.
    t.setPheromoneVirtual(9, 3, 1.5);
    t.setPheromoneVirtual(11, 1, 1.0);
    d = t.nextHopDistribution(9, true, 1.0);
    CHECK_EQ(d.size(), static_cast<std::size_t>(3));
    CHECK(std::fabs(d[2].second - 1.5 / 4.5) < 1e-12);
    CHECK(t.nextHopDistribution(11, false, 1.0).empty());
    CHECK_EQ(t.nextHopDistribution(11, true, 1.0).size(), static_cast<std::size_t>(1));
    for (int k = 1; k < 1000; ++k) {
        const double r = k / 1000.0;
        ScriptedRng rng({r});
        CHECK_EQ(t.nextNeighborNode(9, true, 1.0, rng), pickFromDistribution(d, r));
    }

    return RUN_TESTS();
}
