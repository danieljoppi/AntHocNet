// The two-factor reactive acceptance band (#177 arm B).
//
// `main` implements the 2004 reactive setup with ONE acceptance factor
// (antAcceptanceFactor = 1.5, [1] §3.1) and bounds the resulting flood with a
// per-(node, generation) broadcast count (#174). The 2007 Ducatelle thesis
// describes the same mechanism but states the parameterisation its authors
// actually ran, and it is a *pair* of factors — a low base factor and a higher
// one reserved for ants that arrived over a new first hop:
//
//   "If the number of hops and travel time of a newly received ant are both
//    within an acceptance factor a1 of those of the best previously received
//    ant of the same route setup, the new ant is accepted and forwarded;
//    otherwise, it is discarded. a1 is set quite low (to 0.9), in order to only
//    allow the best ants through and avoid too much proliferation of forward
//    ants in the network."                        -- 2007 thesis, lines 4655-4659
//
//   "To boost the creation of disjoint paths, a different mechanism is applied,
//    which takes into account the first hop taken by each ant. If this first hop
//    is different from those taken by previously accepted ants, we apply a
//    higher (less restrictive) acceptance factor a2 than in the case the first
//    hop was already seen before (a2 was set to 2)."
//                                                 -- 2007 thesis, lines 4667-4671
//
// a1 < 1 changes the band's character completely: it *suppresses* (a later ant
// must beat the incumbent by ~10% on both metrics) where 1.5 *admitted*. That is
// why this branch can also set reactiveMaxBroadcasts = -1 — the question it
// exists to answer is whether the band alone bounds the flood.
//
// This test pins the four properties that distinguish arm B from what ships:
//   1. a repeat first hop is judged against a1, so an ant that 1.5 would have
//      forwarded is now dropped;
//   2. a new first hop is judged against a2, so the same-shaped ant IS
//      forwarded — the disjoint-path boost;
//   3. one discovery still costs O(n) ants as the 8-connected grid grows,
//      with no broadcast bound in force;
//   4. reach is unaffected: a 9-hop line still delivers.
#include "test_support.h"
#include "testbench.h"

using namespace anthocnet;

namespace {

// A reactive forward ant of generation (3, 42) heading for node 9, having
// travelled `path` since leaving its source. `path` is source-first, exactly as
// AntRouterLogic builds `visited` (createAnt pushes the source, each forwarder
// appends itself), so path[1] is the ant's first hop.
core::AntMessage forwardAnt(std::vector<core::AntHop> path) {
    core::AntMessage m;
    m.type      = core::AntType::Reactive;
    m.direction = core::AntDirection::Up;
    m.src       = 3;
    m.dst       = 9;
    m.seqNum    = 42;
    m.timeStart = 0.0;
    m.visited   = std::move(path);
    return m;
}

// Feed node 9 (the destination) the generation's best ant — 2 hops via first hop
// 4, travel time 0.010 — then a second ant of the same generation, and report
// whether the second one was accepted. Accepted means "a backward ant was sent";
// rejected means Drop. Doing this at the destination makes the outcome a single
// unambiguous decision, with no pheromone state or next-hop draw in the way.
bool secondAntAccepted(const core::Config& cfg, std::vector<core::AntHop> second) {
    test::FakeClock clock;
    clock.set(1.0);
    test::ScriptedRng rng({0.5});
    core::AntRouterLogic router(/*addr*/ 9, cfg, clock, rng);

    const core::AntMessage best = forwardAnt({{3, 0.0}, {4, 0.010}});
    auto first = router.onReceiveAnt(best, /*prevHop*/ 4);
    CHECK_EQ(first.size(), static_cast<std::size_t>(1));
    CHECK(first[0].action == core::RouteAction::Unicast);  // back ant, admitted

    const core::NodeAddress prev = second.back().node;
    auto decisions = router.onReceiveAnt(forwardAnt(std::move(second)), prev);
    CHECK_EQ(decisions.size(), static_cast<std::size_t>(1));
    return decisions[0].action != core::RouteAction::Drop;
}

// Reactive ants put on the medium while node 0 discovers the opposite corner of
// a `side` x `side` 8-connected grid. Same construction as
// test_reactive_flood_bound.cpp — a graph that is dense *and* has a distant
// destination is the only shape in which the flood can multiply.
std::uint64_t discoveryCost(int side, const core::Config& base) {
    core::Config cfg = base;
    // Isolate reactive discovery from the periodic mechanisms.
    cfg.enableEvaporation = false;
    cfg.enableProactive   = false;
    cfg.enableDiffusion   = false;

    const int n = side * side;
    test::Testbench tb(n, cfg);
    auto id = [side](int r, int c) { return r * side + c; };
    for (int r = 0; r < side; ++r) {
        for (int c = 0; c < side; ++c) {
            for (int dr = -1; dr <= 1; ++dr) {
                for (int dc = -1; dc <= 1; ++dc) {
                    const int nr = r + dr, nc = c + dc;
                    if ((dr == 0 && dc == 0) || nr < 0 || nc < 0 ||
                        nr >= side || nc >= side) continue;
                    tb.linkUp(id(r, c), id(nr, nc));
                }
            }
        }
    }

    // Establish neighbours, then measure a window containing no hello tick.
    tb.runUntil(cfg.helloInterval * 3.5);
    std::uint64_t before = 0;
    for (int i = 0; i < n; ++i) before += tb.node(i).antsSent(core::AntType::Reactive);

    tb.sendData(0, n - 1);
    tb.runUntil(cfg.helloInterval * 3.9);   // discovery takes ms; next hello at 4.0

    std::uint64_t after = 0;
    for (int i = 0; i < n; ++i) after += tb.node(i).antsSent(core::AntType::Reactive);
    return after - before;
}

// Deliveries over a static `hops`-hop line at the branch defaults.
struct Outcome { int delivered; int offered; };

Outcome runLine(int hops) {
    core::Config cfg;
    cfg.enableEvaporation = false;   // isolate discovery (ADR-0012)

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
    const core::Config def;

    // The branch's premise, asserted so a silent default drift cannot make the
    // rest of this file test something else.
    CHECK(def.enableMultipath);
    CHECK_NEAR(def.antAcceptanceFactor, 0.9, 1e-12);
    CHECK_NEAR(def.antAcceptanceFactorNewHop, 2.0, 1e-12);

    // A second ant, 3 hops and 0.012 s against a best of 2 hops / 0.010 s. It is
    // *inside* the 1.5 band on both metrics (3 <= 3.0, 0.012 <= 0.015) and
    // outside the 0.9 one (3 > 1.8), so it separates a1 from what ships.
    const std::vector<core::AntHop> viaSeenHop{{3, 0.0}, {4, 0.006}, {5, 0.006}};
    const std::vector<core::AntHop> viaNewHop {{3, 0.0}, {5, 0.006}, {6, 0.006}};

    // 1. Repeat first hop (4, the same one the best ant used) -> judged against
    //    a1 = 0.9 and dropped, where the shipped single factor of 1.5 forwards
    //    it. This is the "only allow the best ants through" half of the design.
    {
        CHECK(!secondAntAccepted(def, viaSeenHop));

        core::Config shipped = def;   // what main does with the same two ants
        shipped.antAcceptanceFactor       = 1.5;
        shipped.antAcceptanceFactorNewHop = 1.5;
        CHECK(secondAntAccepted(shipped, viaSeenHop));
    }

    // 2. New first hop (5, unused by any accepted ant of this generation) ->
    //    judged against a2 = 2.0 and forwarded, though a1 would have dropped it
    //    (it is the identical hop count and travel time as case 1). This is the
    //    disjoint-path boost, and the first hop is the only thing that differs.
    {
        CHECK(secondAntAccepted(def, viaNewHop));

        core::Config noBoost = def;   // a2 pulled down to a1: the boost is gone
        noBoost.antAcceptanceFactorNewHop = def.antAcceptanceFactor;
        CHECK(!secondAntAccepted(noBoost, viaNewHop));
    }

    // 2b. a2 relaxes the band, it does not disable it: a new first hop reached
    //     over a path far outside even the 2.0 band is still dropped.
    {
        const std::vector<core::AntHop> farViaNewHop{
            {3, 0.0}, {5, 0.02}, {6, 0.02}, {7, 0.02}, {8, 0.02}, {10, 0.02}};
        CHECK(!secondAntAccepted(def, farViaNewHop));
    }

    // 3. The band alone bounds the flood. No broadcast bound is in force at the
    //    branch default (reactiveMaxBroadcasts = -1), so anything printed in the
    //    "arm B" column is the two-factor band's doing. The contrast column is
    //    the same run with the single 1.5 factor, i.e. #173's unbounded case.
    CHECK(def.reactiveMaxBroadcasts < 0);
    std::printf("8-connected grid, one discovery corner to corner, no broadcast bound:\n"
                "%-6s %-7s %14s %14s\n", "side", "nodes", "arm B (0.9/2.0)", "single 1.5");
    for (int side = 3; side <= 7; ++side) {
        const int n = side * side;

        core::Config single = def;
        single.antAcceptanceFactor       = 1.5;
        single.antAcceptanceFactorNewHop = 1.5;

        const std::uint64_t armB = discoveryCost(side, def);
        const std::uint64_t one  = discoveryCost(side, single);
        std::printf("%-6d %-7d %14llu %14llu\n", side, n,
                    static_cast<unsigned long long>(armB),
                    static_cast<unsigned long long>(one));

        // O(n) as the grid grows. 8n is generous headroom and matches the bound
        // test_reactive_flood_bound.cpp applies to the shipped per-node count;
        // the point is that the multiple does not grow with n (the single-1.5
        // column reaches 614n at 7x7).
        CHECK(armB <= 8 * static_cast<std::uint64_t>(n));
    }

    // 4. Suppressing harder must not cost reach. 9 hops is well beyond the ~5
    //    the old per-path budget allowed (#169) and inside maxPathLength; the
    //    allowance covers the initial reactive setup, as in
    //    test_reactive_hop_reach.cpp.
    {
        const Outcome o = runLine(/*hops=*/9);
        CHECK(o.offered > 50);
        CHECK(o.delivered >= o.offered - 5);
    }
    {
        const Outcome o = runLine(/*hops=*/3);
        CHECK(o.delivered >= o.offered - 5);
    }

    return RUN_TESTS();
}
