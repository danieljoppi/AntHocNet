// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

// Issue #296 item 1 / #216 — the Dijkstra + first-hop layer behind the oracle
// control arm, checked against hand-built graphs whose shortest paths are
// known a priori (that is the whole point of a control: its answer is known
// before the code runs, so the code can be wrong and be caught).
//
// Four graphs:
//   1. a diamond with a tail and an isolated node — unit weights, one
//      deliberate equal-cost tie, one genuinely unreachable node;
//   2. the same shape with a weight that breaks the tie the other way;
//   3. a directed pair, to prove edges are one-way unless added both ways;
//   4. a 3x3 +Grid torus — the satellite suite's topology, where EVERY
//      distance is a known closed form (Manhattan distance on a torus) and
//      almost every path is a tie, so the canonical tie-break is exercised
//      at scale rather than in one hand-picked spot.
#include <cmath>
#include <stdexcept>
#include <vector>

#include "anthocnet/core/shortest_path.h"
#include "test_support.h"

using anthocnet::core::ShortestPathGraph;

namespace {

void addBoth(ShortestPathGraph& g, int a, int b, double w = 1.0) {
    g.addEdge(a, b, w);
    g.addEdge(b, a, w);
}

// Graph 1/2 shape:
//
//     1 ----- 3 ----- 5
//    /       /
//   0 ----- 2            4 (isolated)
//
// Unit weights: 0->3 is a tie (via 1 or via 2, both cost 2).
ShortestPathGraph diamond(double edge01) {
    ShortestPathGraph g(6);
    addBoth(g, 0, 1, edge01);
    addBoth(g, 1, 3);
    addBoth(g, 3, 5);
    addBoth(g, 0, 2);
    addBoth(g, 2, 3);
    return g;
}

}  // namespace

int main() {
    // --- 1. unit weights: distances and the canonical tie-break -------------
    {
        ShortestPathGraph g = diamond(1.0);
        CHECK(g.nodeCount() == 6);
        CHECK(g.edgeCount() == 10);  // five undirected links, both directions
        g.computeFrom(0);
        CHECK(g.source() == 0);
        CHECK(g.distanceTo(0) == 0.0);
        CHECK(g.distanceTo(1) == 1.0);
        CHECK(g.distanceTo(2) == 1.0);
        CHECK(g.distanceTo(3) == 2.0);
        CHECK(g.distanceTo(5) == 3.0);
        // A node with no path is unreachable, not "very far".
        CHECK(g.distanceTo(4) == ShortestPathGraph::unreachable());
        CHECK(g.firstHopTo(4) == ShortestPathGraph::kNoNode);
        // First hops. 0->3 costs 2 through either 1 or 2; the documented
        // tie-break takes the smaller first hop, so it is 1 — and 5, reached
        // only through 3, inherits it.
        CHECK(g.firstHopTo(1) == 1);
        CHECK(g.firstHopTo(2) == 2);
        CHECK(g.firstHopTo(3) == 1);
        CHECK(g.firstHopTo(5) == 1);
        // A node needs no first hop to reach itself.
        CHECK(g.firstHopTo(0) == ShortestPathGraph::kNoNode);

        // From the far end, symmetric by construction: 5 reaches 0 in 3 hops,
        // and its only first hop is 3.
        g.computeFrom(5);
        CHECK(g.distanceTo(0) == 3.0);
        CHECK(g.firstHopTo(0) == 3);
        CHECK(g.distanceTo(4) == ShortestPathGraph::unreachable());

        // Out-of-range queries answer "no path" rather than reading past the
        // end (the oracle asks about every ns-3 node id it knows).
        CHECK(g.distanceTo(6) == ShortestPathGraph::unreachable());
        CHECK(g.firstHopTo(-1) == ShortestPathGraph::kNoNode);
    }

    // --- 2. weights, not hop counts: the tie is broken the other way --------
    {
        // Make 0-1 cost 5. Now 0->3 costs 2 via node 2 (0-2-3) and 6 via 1,
        // so the first hop flips to 2 — and so does 5's, and node 1 itself is
        // now reached through 2 as well (0-2-3-1 costs 3 < 5).
        ShortestPathGraph g = diamond(5.0);
        g.computeFrom(0);
        CHECK(g.distanceTo(1) == 3.0);
        CHECK(g.distanceTo(2) == 1.0);
        CHECK(g.distanceTo(3) == 2.0);
        CHECK(g.distanceTo(5) == 3.0);
        CHECK(g.firstHopTo(1) == 2);
        CHECK(g.firstHopTo(3) == 2);
        CHECK(g.firstHopTo(5) == 2);
    }

    // --- 3. edges are directed -----------------------------------------------
    {
        ShortestPathGraph g(2);
        g.addEdge(0, 1, 1.0);
        g.computeFrom(0);
        CHECK(g.distanceTo(1) == 1.0);
        CHECK(g.firstHopTo(1) == 1);
        g.computeFrom(1);
        CHECK(g.distanceTo(0) == ShortestPathGraph::unreachable());
        CHECK(g.firstHopTo(0) == ShortestPathGraph::kNoNode);
    }

    // --- 4. the +Grid torus: every distance known in closed form -------------
    {
        // 3x3 +Grid torus, node id = r*3 + c, each node linked to its four
        // wrap-around neighbours. On a torus the hop distance between (r0,c0)
        // and (r1,c1) is the wrapped Manhattan distance, which for size 3 is
        // min(|dr|, 3-|dr|) + min(|dc|, 3-|dc|).
        const int k = 3;
        ShortestPathGraph g(k * k);
        for (int r = 0; r < k; ++r) {
            for (int c = 0; c < k; ++c) {
                const int id = r * k + c;
                g.addEdge(id, ((r + 1) % k) * k + c, 1.0);  // south
                g.addEdge(id, r * k + (c + 1) % k, 1.0);    // east
                g.addEdge(id, ((r + k - 1) % k) * k + c, 1.0);
                g.addEdge(id, r * k + (c + k - 1) % k, 1.0);
            }
        }
        CHECK(g.edgeCount() == static_cast<std::size_t>(4 * k * k));
        for (int s = 0; s < k * k; ++s) {
            g.computeFrom(s);
            for (int d = 0; d < k * k; ++d) {
                const int dr = std::abs(s / k - d / k);
                const int dc = std::abs(s % k - d % k);
                const double expect = (dr < k - dr ? dr : k - dr) + (dc < k - dc ? dc : k - dc);
                CHECK(g.distanceTo(d) == expect);
                if (s == d) {
                    CHECK(g.firstHopTo(d) == ShortestPathGraph::kNoNode);
                } else {
                    // Whatever the tie-break picks, it must be a real
                    // neighbour of s that is one hop closer to d — the
                    // property a routing table actually needs.
                    const int hop = g.firstHopTo(d);
                    CHECK(hop != ShortestPathGraph::kNoNode);
                    CHECK(g.distanceTo(hop) == 1.0);
                    ShortestPathGraph h = g;  // copy: recompute from the hop
                    h.computeFrom(hop);
                    CHECK(h.distanceTo(d) == expect - 1.0);
                }
            }
        }
        // Determinism is part of the contract: the same edge set computed
        // twice gives the same table, whatever the tie-break chose.
        ShortestPathGraph again = g;
        g.computeFrom(0);
        again.computeFrom(0);
        for (int d = 0; d < k * k; ++d) {
            CHECK(again.firstHopTo(d) == g.firstHopTo(d));
        }
    }

    // --- 5. caller bugs are loud, not silently wrong -------------------------
    {
        ShortestPathGraph g(2);
        bool threw = false;
        try {
            g.addEdge(0, 7, 1.0);
        } catch (const std::invalid_argument&) {
            threw = true;
        }
        CHECK(threw);
        threw = false;
        try {
            g.addEdge(0, 1, -1.0);
        } catch (const std::invalid_argument&) {
            threw = true;
        }
        CHECK(threw);
        threw = false;
        try {
            g.computeFrom(9);
        } catch (const std::invalid_argument&) {
            threw = true;
        }
        CHECK(threw);
    }

    return RUN_TESTS();
}
