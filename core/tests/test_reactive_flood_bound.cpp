// Reactive discovery must stay bounded in a *dense* graph (#169 follow-up).
//
// PR #170 removed the reactive broadcast budget because, implemented as a
// counter carried on the ant and decremented at every broadcast, it was a *hop
// limit on discovery*: destinations more than ~5 hops away were never found.
// That diagnosis holds. The question this test answers is what is left bounding
// the flood afterwards, because #96 had already routed reactive forward ants
// around the other bound:
//
//   onReceiveAnt(): with enableMultipath (default on) a *reactive forward* ant
//   is admitted by GenerationTracker::accept() and never touches history_, so
//   strict (src,seq) duplicate suppression does not apply to it. The acceptance
//   band admits rather than suppresses — a later same-generation copy is
//   forwarded whenever it is within antAcceptanceFactor of the best so far.
//
// A line topology (test_reactive_hop_reach.cpp) cannot show this: with two
// neighbours per node there is nothing to multiply. A fully-connected mesh
// cannot either — the destination is a direct neighbour, so discovery never
// runs. It needs a graph that is dense *and* has a distant destination, which
// is what a grid gives: interior degree 8, corner-to-corner 4 hops.
#include "test_support.h"
#include "testbench.h"

using namespace anthocnet;

namespace {

// Reactive ants put on the medium while node 0 discovers the opposite corner
// of a `side` x `side` grid (8-connected: orthogonal + diagonal neighbours).
std::uint64_t discoveryCost(int side, int reactiveBudget, bool multipath) {
    core::Config cfg;
    cfg.reactiveMaxBroadcasts = reactiveBudget;
    cfg.enableMultipath = multipath;
    // Isolate reactive discovery from the periodic mechanisms.
    cfg.enableEvaporation = false;
    cfg.enableProactive = false;
    cfg.enableDiffusion = false;

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

    // Establish neighbours, then measure a window containing no hello tick —
    // otherwise n beacons per second swamp the counter and every configuration
    // reads alike.
    tb.runUntil(cfg.helloInterval * 3.5);
    std::uint64_t before = 0;
    for (int i = 0; i < n; ++i) before += tb.node(i).antsSent(core::AntType::Reactive);

    tb.sendData(0, n - 1);
    tb.runUntil(cfg.helloInterval * 3.9);   // discovery takes ms; next hello at 4.0

    std::uint64_t after = 0;
    for (int i = 0; i < n; ++i) after += tb.node(i).antsSent(core::AntType::Reactive);
    return after - before;
}

}  // namespace

int main() {
    const core::Config def;

    // The invariant, at the *default* configuration: one discovery costs O(n)
    // control packets, because each node puts a given generation on the medium
    // at most reactiveMaxBroadcasts times. Checked as the grid grows, since the
    // defect was combinatorial — a single size could pass by luck.
    std::printf("8-connected grid, one discovery corner to corner:\n"
                "%-6s %-7s %14s %14s %14s\n",
                "side", "nodes", "default", "budget=-1", "multipath=off");
    for (int side = 3; side <= 7; ++side) {
        const int n = side * side;
        const std::uint64_t dflt      = discoveryCost(side, def.reactiveMaxBroadcasts, true);
        const std::uint64_t unbounded = discoveryCost(side, -1, true);
        const std::uint64_t dedup     = discoveryCost(side, -1, false);
        std::printf("%-6d %-7d %14llu %14llu %14llu\n", side, n,
                    static_cast<unsigned long long>(dflt),
                    static_cast<unsigned long long>(unbounded),
                    static_cast<unsigned long long>(dedup));

        // 8n is generous headroom: the per-node bound allows
        // reactiveMaxBroadcasts broadcasts each, and the count also includes
        // unicast forwards along established pheromone (which do not flood).
        // The point is that it stays a small multiple of n as the grid grows —
        // at 7x7 the unbounded column is 614n.
        CHECK(dflt <= 8 * static_cast<std::uint64_t>(n));
        // Strict dedup bounds it too, and always did — the defect was that
        // reactive forward ants under multipath never reach that branch.
        CHECK(dedup <= 4 * static_cast<std::uint64_t>(n));
    }

    // The default must be a finite per-node bound. `-1` is retained for
    // sensitivity experiments and genuinely is unbounded — that column is
    // printed above as the contrast, deliberately not asserted on.
    CHECK(def.reactiveMaxBroadcasts > 0);
    return RUN_TESTS();
}
