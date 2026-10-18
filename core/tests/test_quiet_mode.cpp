// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

// #571 quiet mode: a destination whose best next hop and pheromone do not
// change backs its proactive ants off geometrically, up to a cap; a route
// change, a lost neighbour or a new one wakes it; with the gate off every
// round sends, exactly as before. Since v2.3.0 the gate is on by default.
#include <vector>

#include "anthocnet/core/ant_router_logic.h"
#include "anthocnet/core/config.h"
#include "test_support.h"

using namespace anthocnet::core;
using anthocnet::test::FakeClock;
using anthocnet::test::ScriptedRng;

namespace {

Config quiet(bool on) {
    Config c;
    c.enableQuietMode = on;
    c.enableDiffusion = false;  // keep the emission gate out of the way
    c.sessionTtl = 1e9;
    return c;
}

// Which of `rounds` proactive rounds sent an ant toward 9.
std::vector<int> pattern(AntRouterLogic& r, int rounds) {
    std::vector<int> sent;
    for (int i = 0; i < rounds; ++i) sent.push_back(r.createProactiveAnts().empty() ? 0 : 1);
    return sent;
}

}  // namespace

int main() {
    FakeClock clock;
    ScriptedRng rng({0.5});

    // 0. The shipped default is on (v2.3.0 campaign, #571).
    CHECK(Config{}.enableQuietMode);

    // 1. Gate off: one ant every round.
    {
        AntRouterLogic r(1, quiet(false), clock, rng);
        r.table().setPheromoneRegular(9, 2, 1.0);
        r.noteDataSession(9);
        CHECK(pattern(r, 6) == std::vector<int>({1, 1, 1, 1, 1, 1}));
    }

    // 2. Gate on, a stable route: back-off 1, 2, 4, 8, 8 ... rounds.
    //    Round 1 has no history (sends); round 2 is stable once (back-off 2:
    //    skip); round 3 sends; then 4 rounds apart, then the cap of 8.
    {
        AntRouterLogic r(1, quiet(true), clock, rng);
        r.table().setPheromoneRegular(9, 2, 1.0);
        r.noteDataSession(9);
        const std::vector<int> p = pattern(r, 24);
        int sent = 0;
        for (int v : p) sent += v;
        CHECK(p[0] == 1);
        CHECK(sent < 8);  // vs 24 with the gate off
        // The tail is spaced by the cap.
        std::vector<int> at;
        for (int i = 0; i < 24; ++i)
            if (p[i]) at.push_back(i);
        CHECK(at.size() >= 3);
        CHECK_EQ(at[at.size() - 1] - at[at.size() - 2], 8);
    }

    // 3. A changed best next hop wakes the destination at once.
    {
        AntRouterLogic r(1, quiet(true), clock, rng);
        r.table().setPheromoneRegular(9, 2, 1.0);
        r.noteDataSession(9);
        pattern(r, 12);                            // well into the back-off
        r.table().setPheromoneRegular(9, 3, 5.0);  // a better route appears
        CHECK(!r.createProactiveAnts().empty());
    }

    // 4. A pheromone change beyond the tolerance wakes it; within, it does not.
    {
        AntRouterLogic r(1, quiet(true), clock, rng);
        r.table().setPheromoneRegular(9, 2, 1.0);
        r.noteDataSession(9);
        pattern(r, 12);
        r.table().setPheromoneRegular(9, 2, 1.1);  // +10 %: still the same route
        CHECK(r.createProactiveAnts().empty());    // the back-off holds
        r.table().setPheromoneRegular(9, 2, 2.0);  // +80 %: changed
        CHECK(!r.createProactiveAnts().empty());
    }

    // 5. Losing a neighbour, or learning a new one, wakes every destination.
    {
        AntRouterLogic r(1, quiet(true), clock, rng);
        r.learnNeighbor(2);
        r.learnNeighbor(4);
        r.table().setPheromoneRegular(9, 2, 1.0);
        r.noteDataSession(9);
        pattern(r, 12);
        r.loseNeighbor(4);
        CHECK(!r.createProactiveAnts().empty());
        pattern(r, 12);
        r.learnNeighbor(5);
        CHECK(!r.createProactiveAnts().empty());
    }

    return RUN_TESTS();
}
