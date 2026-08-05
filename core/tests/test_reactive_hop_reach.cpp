// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

// Reactive discovery must not be hop-limited (#169).
//
// A reactive forward ant broadcasts at every node that has no pheromone for
// the destination, so a finite `reactiveMaxBroadcasts` is really a *hop limit
// on route discovery*. With the old default of 2, any destination more than
// ~5 hops away was never discovered at all — not degraded, never found. That
// is what made sparse/static fields look like an AntHocNet weakness: in the
// pause sweep (areaX=2500, long paths) delivery fell to 59.9% while AODV rose
// to 98.9%, and AntHocNet did *better* under mobility only because motion
// intermittently brought far pairs within reach.
//
// The sources bound the flood by duplicate suppression, maxPathLength and the
// acceptance band — never by a broadcast count (2007 thesis: "each
// intermediate node receiving a copy of the reactive forward ant forwards it
// … via broadcasting otherwise … subsequent copies are destroyed"). The
// 2-broadcast rule belongs to *proactive* ants ([1] §3.3).
//
// Runs on the #154 testbench: a static line of N nodes, links never torn down,
// one flow end to end. No simulator, deterministic, milliseconds.
#include "test_support.h"
#include "testbench.h"

using namespace anthocnet;

namespace {

// Deliveries over a static `hops`-hop line with the given broadcast budget.
// Returns {delivered, offered}.
struct Outcome {
    int delivered;
    int offered;
};

Outcome runLine(int hops, int reactiveBudget) {
    core::Config cfg;
    cfg.reactiveMaxBroadcasts = reactiveBudget;
    // Isolate discovery: evaporation is a separate mechanism (ADR-0012).
    cfg.enableEvaporation = false;

    const int n = hops + 1;
    test::Testbench tb(n, cfg);
    for (int i = 0; i + 1 < n; ++i) tb.linkUp(i, i + 1);

    int offered = 0;
    for (core::Time t = 5.0; t < 60.0; t += 1.0) {
        tb.at(t, [&tb, &offered, n] {
            ++offered;
            tb.sendData(0, n - 1);
        });
    }
    tb.runUntil(60.0);
    return {tb.dataDelivered, offered};
}

}  // namespace

int main() {
    // 1. The default must discover long paths. 9 hops is comfortably beyond the
    //    ~5-hop ceiling the old budget imposed, and well inside maxPathLength.
    //    Allow a startup allowance for the initial reactive setup.
    {
        const Outcome o = runLine(/*hops=*/9, core::Config{}.reactiveMaxBroadcasts);
        CHECK(o.offered > 50);
        CHECK(o.delivered >= o.offered - 5);
    }

    // 2. Short paths keep working — the fix must not regress the easy case.
    {
        const Outcome o = runLine(/*hops=*/3, core::Config{}.reactiveMaxBroadcasts);
        CHECK(o.delivered >= o.offered - 5);
    }

    // 3. The value is now a *per-node, per-generation* broadcast count, not a
    //    per-path budget, so a finite value no longer truncates discovery: 9
    //    hops still deliver at 2 (#173 changed the unit — see config.h). Under
    //    the old per-path semantics this same call delivered 0, which is the
    //    regression #169 fixed and this pins against reintroduction.
    {
        const Outcome capped = runLine(/*hops=*/9, /*reactiveBudget=*/2);
        CHECK(capped.delivered >= capped.offered - 5);
    }

    // 4. Reach must not depend on the bound at all. A per-node count cannot be
    //    a hop limit, so tightening it to 1 must still deliver over 9 hops —
    //    the property that distinguishes the #173 bound from the #169 one.
    {
        const Outcome tight = runLine(/*hops=*/9, /*reactiveBudget=*/1);
        CHECK(tight.delivered >= tight.offered - 5);
    }

    return RUN_TESTS();
}
