// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

// EXPERIMENT (#180 root cause) — not a regression test.
//
// The recorded root cause on #180 concluded that in ns-3 "the rate wins", i.e.
// #188's NRL rise is *more proactive ants* because the gate must pass often
// there. That conclusion rests on an inference the same comment flags as
// unmeasured: "less proactive maintenance -> more reactive traffic ... inferred
// from the ns-3 data, not directly measured".
//
// It also sits badly with the ns-3 signature itself:
//   * PDR FELL 5.0-6.4 pp and delay99 ROSE 9-11 ms on the load-sensitive cells.
//     More proactive maintenance does not do that; less does.
//   * NRL rose +50% on sparse-static — and measurement 1 showed the gate blocks
//     ~100% in sparse/line topologies, so under "the rate wins" the rate
//     increase should not have materialised there at all.
//
// Competing hypothesis: the gate STARVES maintenance, routes go stale, and the
// extra control traffic is REACTIVE rediscovery, not proactive emission.
//
// The earlier testbench pass could not see this because it never broke an
// active path — with a static graph, stale routes never cost anything. This
// scenario adds churn on a route that has an alternative, which is the only
// condition under which maintenance can pay for itself.
#include "test_support.h"
#include "testbench.h"

#include <cstdio>

using namespace anthocnet;

namespace {

struct Counts {
    std::uint64_t proactive = 0, reactive = 0, repair = 0, linkfail = 0, hello = 0;
    std::uint64_t delivered = 0;
    std::uint64_t control() const { return proactive + reactive + repair + linkfail + hello; }
};

// 4x4 grid: enough path diversity that the gate CAN pass (measurement 3 found
// ~10% of pairs qualify on a 5x5), unlike the 6-hop line where it never can.
int id(int r, int c) { return r * 4 + c; }

Counts run(double margin, double interval, bool churn) {
    core::Config cfg;
    cfg.proactiveVirtualMargin = margin;
    cfg.proactiveInterval = interval;
    cfg.enableProactive = true;
    cfg.enableDiffusion = true;

    test::Testbench tb(16, cfg);
    for (int r = 0; r < 4; ++r) {
        for (int c = 0; c < 4; ++c) {
            if (c + 1 < 4) tb.linkUp(id(r, c), id(r, c + 1));
            if (r + 1 < 4) tb.linkUp(id(r, c), id(r + 1, c));
        }
    }

    // A session across the diagonal, offered steadily so route staleness has
    // something to damage.
    for (int t = 5; t < 120; t += 2) {
        tb.at(static_cast<core::Time>(t), [&tb] { tb.sendData(id(0, 0), id(3, 3)); });
    }

    if (churn) {
        // Break and restore links ON the likely primary path, repeatedly. Each
        // break invalidates whatever route is in use; maintenance either has an
        // alternative ready or discovery has to run again.
        for (int t = 20; t < 120; t += 10) {
            const int k = (t / 10) % 3;
            tb.at(static_cast<core::Time>(t), [&tb, k] {
                tb.linkDown(id(k, k), id(k, k + 1));
            });
            tb.at(static_cast<core::Time>(t + 4), [&tb, k] {
                tb.linkUp(id(k, k), id(k, k + 1));
            });
        }
    }

    tb.runUntil(125.0);

    Counts n;
    for (int i = 0; i < 16; ++i) {
        n.proactive += tb.node(i).antsSent(core::AntType::Proactive);
        n.reactive  += tb.node(i).antsSent(core::AntType::Reactive);
        n.repair    += tb.node(i).antsSent(core::AntType::Repair);
        n.linkfail  += tb.node(i).antsSent(core::AntType::LinkFail);
        n.hello     += tb.node(i).antsSent(core::AntType::Hello);
    }
    n.delivered = tb.dataDelivered;
    return n;
}

void report(const char* label, const Counts& c) {
    std::printf("%-28s proact=%5llu reactive=%5llu repair=%4llu linkfail=%4llu "
                "hello=%6llu | control=%6llu delivered=%4llu\n",
                label,
                (unsigned long long) c.proactive, (unsigned long long) c.reactive,
                (unsigned long long) c.repair, (unsigned long long) c.linkfail,
                (unsigned long long) c.hello,
                (unsigned long long) c.control(), (unsigned long long) c.delivered);
}

}  // namespace

int main() {
    for (bool churn : {false, true}) {
        std::printf("\n=== churn=%s ===\n", churn ? "YES (active path breaks)" : "no (static graph)");
        report("main    (gate off, 10s)", run(0.00, 10.0, churn));
        report("gate ON only     (10s)", run(0.10, 10.0, churn));
        report("rate ONLY(gate off, 2s)", run(0.00, 2.0, churn));
        report("#188    (gate on,   2s)", run(0.10, 2.0, churn));
    }
    return 0;
}
