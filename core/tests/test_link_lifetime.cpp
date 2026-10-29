// SPDX-License-Identifier: MIT OR GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

// #574: link-lifetime prediction. The link expiration time (Su, Lee and Gerla
// 2001) from two nodes' kinematics, the weight it becomes, and the next-hop
// discount: a neighbour about to leave range is chosen less, a neighbour with
// unknown kinematics is not discounted, and with the gate off the choice is
// exactly what it was.
#include <cmath>
#include <limits>

#include "anthocnet/core/ant_router_logic.h"
#include "anthocnet/core/config.h"
#include "anthocnet/core/link_lifetime.h"
#include "test_support.h"

using namespace anthocnet::core;
using anthocnet::test::FakeClock;
using anthocnet::test::ScriptedRng;

namespace {

class FakeKinematics : public IKinematics {
public:
    Kinematics k{0, 0, 0, 0, 0, 0};
    bool self(Kinematics& out) const override {
        out = k;
        return true;
    }
};

double probOf(const std::vector<std::pair<NodeAddress, double>>& dist, NodeAddress n) {
    for (const auto& e : dist)
        if (e.first == n) return e.second;
    return 0.0;
}

// A hello from `src` at (x, y) moving (vx, vy).
AntMessage helloFrom(NodeAddress src, double x, double y, double vx, double vy) {
    AntMessage h;
    h.type = AntType::Hello;
    h.direction = AntDirection::Up;
    h.src = src;
    h.seqNum = static_cast<std::uint32_t>(src);
    h.hasKinematics = true;
    h.kinematics = Kinematics{x, y, 0, vx, vy, 0};
    return h;
}

}  // namespace

int main() {
    const double inf = std::numeric_limits<double>::infinity();

    // 1. LET geometry.
    {
        // Same velocity: the distance never changes.
        CHECK_EQ(linkExpiryTime({0, 0, 0, 20, 0, 0}, {100, 0, 0, 20, 0, 0}, 250), inf);
        // Already out of range.
        CHECK_EQ(linkExpiryTime({0, 0, 0, 0, 0, 0}, {300, 0, 0, 0, 0, 0}, 250), 0.0);
        // Moving apart along x at 20 m/s relative, from 100 m: 150 m to go.
        CHECK_NEAR(linkExpiryTime({0, 0, 0, 0, 0, 0}, {100, 0, 0, 20, 0, 0}, 250), 7.5, 1e-9);
        // Approaching from 100 m at 20 m/s: passes through and leaves at
        // 350 m of relative travel.
        CHECK_NEAR(linkExpiryTime({0, 0, 0, 0, 0, 0}, {100, 0, 0, -20, 0, 0}, 250), 17.5, 1e-9);
        // Crossing street: perpendicular from the origin, sqrt(250^2)/20.
        CHECK_NEAR(linkExpiryTime({0, 0, 0, 0, 0, 0}, {0, 0, 0, 0, 20, 0}, 250), 12.5, 1e-9);
        // 3-D: climbing away at 10 m/s from 150 m below range.
        CHECK_NEAR(linkExpiryTime({0, 0, 0, 0, 0, 0}, {0, 0, 100, 0, 0, 10}, 250), 15.0, 1e-9);
    }

    // 2. The weight: 1 at or past the horizon, linear below, floored.
    CHECK_EQ(linkLifetimeWeight(inf, 3.0, 0.05), 1.0);
    CHECK_EQ(linkLifetimeWeight(3.0, 3.0, 0.05), 1.0);
    CHECK_NEAR(linkLifetimeWeight(1.5, 3.0, 0.05), 0.5, 1e-12);
    CHECK_NEAR(linkLifetimeWeight(0.0, 3.0, 0.05), 0.05, 1e-12);
    CHECK_EQ(linkLifetimeWeight(0.0, 0.0, 0.05), 1.0);  // no horizon: no discount

    // 3. The router. Node 1 at the origin, at rest; neighbour 2 drives with
    //    it (stable), neighbour 3 is 240 m away and leaving at 20 m/s (LET
    //    0.5 s), neighbour 4 never said where it is. Equal pheromone for 9.
    FakeClock clock;
    clock.set(5.0);
    FakeKinematics me;
    auto build = [&](bool on) {
        Config c;
        c.enableLinkLifetime = on;
        return c;
    };
    auto setup = [&](AntRouterLogic& r) {
        r.setKinematics(&me);
        r.onReceiveAnt(helloFrom(2, 50, 0, 0, 0), 2);
        r.onReceiveAnt(helloFrom(3, 240, 0, 20, 0), 3);
        AntMessage h4 = helloFrom(4, 0, 0, 0, 0);
        h4.hasKinematics = false;
        r.onReceiveAnt(h4, 4);
        for (NodeAddress n : {2, 3, 4}) r.table().setPheromoneRegular(9, n, 1.0);
    };
    ScriptedRng rng({0.5});

    {
        AntRouterLogic r(1, build(true), clock, rng);
        setup(r);
        CHECK_EQ(r.linkLifetimeWeight(2), 1.0);
        CHECK_NEAR(r.linkLifetimeWeight(3), 0.5 / 3.0, 1e-9);
        CHECK_EQ(r.linkLifetimeWeight(4), 1.0);  // unknown: absent, not discounted
        r.nextHopForData(9);                     // refreshes the weights
        auto d = r.table().nextHopDistribution(9, false, r.config().betaData);
        CHECK(probOf(d, 3) < probOf(d, 2) / 100.0);  // beta 20 makes 1/6 vanish
        CHECK_NEAR(probOf(d, 2), probOf(d, 4), 1e-12);
        // The gate implies sharing: the router stored what the hellos said.
        Kinematics k;
        CHECK(r.neighborKinematics(3, k));
    }

    // 4. Gate off: the same table gives the undiscounted distribution, and
    //    nothing was stored.
    {
        AntRouterLogic r(1, build(false), clock, rng);
        setup(r);
        r.nextHopForData(9);
        auto d = r.table().nextHopDistribution(9, false, r.config().betaData);
        CHECK_NEAR(probOf(d, 3), 1.0 / 3.0, 1e-12);
        CHECK_EQ(r.linkLifetimeWeight(3), 1.0);
        Kinematics k;
        CHECK(!r.neighborKinematics(3, k));
    }

    // 5. A node that does not know where it is discounts nothing.
    {
        AntRouterLogic r(1, build(true), clock, rng);
        setup(r);
        r.setKinematics(nullptr);
        CHECK_EQ(r.linkLifetimeWeight(3), 1.0);
    }

    return RUN_TESTS();
}
