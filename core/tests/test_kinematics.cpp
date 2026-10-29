// SPDX-License-Identifier: MIT OR GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

// #573, ADR-0025: the IKinematics port and the hello kinematics section. A
// node's own position enters through the port; a neighbour's only through its
// hello. Unknown is absent, never the origin, and with the gate off nothing on
// the wire or in the table changes.
#include "anthocnet/core/ant_message_codec.h"
#include "anthocnet/core/ant_router_logic.h"
#include "anthocnet/core/config.h"
#include "test_support.h"

using namespace anthocnet::core;
using anthocnet::test::FakeClock;
using anthocnet::test::ScriptedRng;

namespace {

class FakeKinematics : public IKinematics {
public:
    bool known = true;
    Kinematics k{100.0, 200.0, 0.0, 10.0, -5.0, 0.0};
    bool self(Kinematics& out) const override {
        if (!known) return false;
        out = k;
        return true;
    }
};

Config gated(bool on) {
    Config c;
    c.shareKinematics = on;
    return c;
}

}  // namespace

int main() {
    FakeClock clock;
    ScriptedRng rng({0.5});
    FakeKinematics port;

    // 1. Gate off (the default): the port is never read and no hello carries
    //    a section, so every hello keeps its pre-ADR-0025 length.
    {
        CHECK(!Config{}.shareKinematics);
        AntRouterLogic node(1, gated(false), clock, rng);
        node.setKinematics(&port);
        CHECK(!node.createHelloAnt().hasKinematics);
    }

    // 2. Gate on and the position known: the hello carries it.
    {
        AntRouterLogic node(1, gated(true), clock, rng);
        node.setKinematics(&port);
        AntMessage h = node.createHelloAnt();
        CHECK(h.hasKinematics);
        CHECK_NEAR(h.kinematics.x, 100.0, 1e-12);
        CHECK_NEAR(h.kinematics.vy, -5.0, 1e-12);
    }

    // 3. Gate on, but no port or an unknown position: no section. Absent is
    //    never sent as zeros.
    {
        AntRouterLogic noPort(1, gated(true), clock, rng);
        CHECK(!noPort.createHelloAnt().hasKinematics);
        FakeKinematics lost;
        lost.known = false;
        AntRouterLogic node(1, gated(true), clock, rng);
        node.setKinematics(&lost);
        CHECK(!node.createHelloAnt().hasKinematics);
    }

    // 4. A value float32 cannot carry is not sent, so receivers never reject
    //    the hello (and lose liveness) over a bad position.
    {
        FakeKinematics far;
        far.k.x = 1e39;
        AntRouterLogic node(1, gated(true), clock, rng);
        node.setKinematics(&far);
        AntMessage h = node.createHelloAnt();
        CHECK(!h.hasKinematics);
        AntMessage out;
        CHECK(codec::deserialize(codec::serialize(h), out));
    }

    // 5. The receiver keeps what the hello said and extrapolates it: p + v*dt.
    clock.set(10.0);
    AntRouterLogic sender(2, gated(true), clock, rng);
    sender.setKinematics(&port);
    AntRouterLogic rx(1, gated(true), clock, rng);
    Kinematics k;
    CHECK(!rx.neighborKinematics(2, k));  // nothing heard yet
    rx.onReceiveAnt(sender.createHelloAnt(), 2);
    CHECK(rx.neighborKinematics(2, k));
    CHECK_NEAR(k.x, 100.0, 1e-12);
    clock.set(12.0);
    CHECK(rx.neighborKinematics(2, k));
    CHECK_NEAR(k.x, 120.0, 1e-9);  // 100 + 10 m/s * 2 s
    CHECK_NEAR(k.y, 190.0, 1e-9);  // 200 - 5 m/s * 2 s
    CHECK_NEAR(k.vx, 10.0, 1e-12);

    // 6. A later hello with no section clears the entry: a neighbour that
    //    stops knowing its position stops being predicted.
    {
        AntMessage h = sender.createHelloAnt();
        h.hasKinematics = false;
        rx.onReceiveAnt(h, 2);
        CHECK(!rx.neighborKinematics(2, k));
    }

    // 7. Losing the neighbour drops its entry.
    rx.onReceiveAnt(sender.createHelloAnt(), 2);
    CHECK(rx.neighborKinematics(2, k));
    rx.loseNeighbor(2);
    CHECK(!rx.neighborKinematics(2, k));

    // 8. With the gate off at the receiver, a section on the wire is ignored.
    {
        AntRouterLogic off(1, gated(false), clock, rng);
        off.onReceiveAnt(sender.createHelloAnt(), 2);
        CHECK(!off.neighborKinematics(2, k));
    }

    return RUN_TESTS();
}
