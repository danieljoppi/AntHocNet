// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

// EXPERIMENT (#263 sizing) — not a regression test.
//
// #263: hello adverts carry {dest, bestRegular(dest)} with no awareness of who
// receives them, so when the sender's best route to `dest` runs through a
// receiver, that receiver bootstraps a virtual entry pointing back the way it
// came — its own path, reflected. The #180 investigation (2026-07-30, on the
// OLD aging clock) measured reflection as the cause of all 3 genuine virtual
// mis-steers on a 4x4 grid and of most of an 8.4 % "virtual argmax moves
// farther" share in the regular-absent case (the case directed steering and
// proactive guidance actually consult virtual for).
//
// #263's own recommended order: land #262 (the aging clock) first, re-run the
// probe, then size the fix — the fix proposed (split horizon via a next-hop
// identity on every advert) is a wire-format change (kWireVersion bump, both
// adapter headers), so it should be sized on current code, not on the old
// clock's numbers.
//
// Method: the #180/#262 probe's testbench scenarios (hellos + proactively
// refreshed data sessions, 41 snapshots t = 5.3..105.3 s), plus a 4x4 torus
// for the ISL regime #263 flags as systematically exposed. At every snapshot,
// for every (node i, dest d != i) holding virtual pheromone:
//   * vArg = argmax over neighbours of virtual(d, nb);
//   * hop distances by BFS on the static topology;
//   * "farther"   = dist(vArg, d) > dist(i, d)  (a wasted hop at least);
//   * "reflected" = vArg's own best REGULAR next hop toward d is i itself.
// Split by whether i holds regular pheromone for d (regular-absent is the
// harmful case: it is when steering consults virtual at all).
#include "test_support.h"
#include "testbench.h"

#include <algorithm>
#include <cstdio>
#include <map>
#include <queue>
#include <set>
#include <utility>
#include <vector>

using namespace anthocnet;

namespace {

struct Scenario {
    const char* name;
    int numNodes;
    std::vector<std::pair<int, int>> links;
    std::vector<std::pair<int, int>> sessions;  // (source, dest)
};

Scenario makeLine() {
    Scenario s{"line-8", 8, {}, {{0, 7}, {7, 0}}};
    for (int i = 0; i + 1 < 8; ++i) s.links.push_back({i, i + 1});
    return s;
}

Scenario makeGrid(bool torus) {
    auto id = [](int r, int c) { return r * 4 + c; };
    Scenario s{torus ? "torus-4x4 (ISL-like)" : "grid-4x4 (#180 case)", 16, {}, {}};
    for (int r = 0; r < 4; ++r) {
        for (int c = 0; c < 4; ++c) {
            if (c + 1 < 4 || torus) s.links.push_back({id(r, c), id(r, (c + 1) % 4)});
            if (r + 1 < 4 || torus) s.links.push_back({id(r, c), id((r + 1) % 4, c)});
        }
    }
    s.sessions = {{id(0, 0), id(3, 3)}, {id(3, 3), id(0, 0)},
                  {id(0, 3), id(3, 0)}, {id(3, 0), id(0, 3)}};
    return s;
}

struct Counts {
    std::uint64_t total = 0, farther = 0, fartherReflected = 0, reflected = 0, closer = 0;
    // Regular-present only: what a PROACTIVE ant actually follows. Its next-hop
    // choice blends max(regular, virtual) per neighbour (PheromoneTable::
    // nextNeighborNode), so a reflected virtual value only misroutes it when it
    // beats the real forward route's regular pheromone.
    std::uint64_t blendFarther = 0, blendReflected = 0;
    // Regular-absent "farther" cases that are NOT reflections: split by
    // snapshot time (route-formation transient vs steady state) and by whether
    // vArg itself still holds a regular route to d (a stale advert otherwise).
    std::uint64_t fartherEarly = 0, fartherVargNoRoute = 0;
};

core::NodeAddress argmaxRegular(const core::PheromoneTable& t, core::NodeAddress d,
                                double floor) {
    core::NodeAddress best = core::kInvalidAddress;
    double bv = floor;
    for (core::NodeAddress nb : t.neighbors()) {
        const double r = t.getPheromoneRegular(d, nb);
        if (r > bv) { bv = r; best = nb; }
    }
    return best;
}

void run(const Scenario& sc) {
    core::Config cfg;
    cfg.enableProactive = true;
    cfg.enableDiffusion = true;

    test::Testbench tb(sc.numNodes, cfg);
    std::vector<std::vector<int>> adj(static_cast<std::size_t>(sc.numNodes));
    for (const auto& l : sc.links) {
        tb.linkUp(l.first, l.second);
        adj[static_cast<std::size_t>(l.first)].push_back(l.second);
        adj[static_cast<std::size_t>(l.second)].push_back(l.first);
    }
    // All-pairs hop distance on the static topology.
    std::vector<std::vector<int>> dist(static_cast<std::size_t>(sc.numNodes));
    for (int s = 0; s < sc.numNodes; ++s) {
        auto& d = dist[static_cast<std::size_t>(s)];
        d.assign(static_cast<std::size_t>(sc.numNodes), -1);
        std::queue<int> q;
        d[static_cast<std::size_t>(s)] = 0;
        q.push(s);
        while (!q.empty()) {
            const int u = q.front();
            q.pop();
            for (int v : adj[static_cast<std::size_t>(u)]) {
                if (d[static_cast<std::size_t>(v)] < 0) {
                    d[static_cast<std::size_t>(v)] = d[static_cast<std::size_t>(u)] + 1;
                    q.push(v);
                }
            }
        }
    }

    for (const auto& sess : sc.sessions) {
        for (int t = 5; t < 105; t += 2) {
            tb.at(static_cast<core::Time>(t),
                  [&tb, sess] { tb.sendData(sess.first, sess.second); });
        }
    }

    Counts regAbsent, regPresent;
    for (int k = 0; k <= 40; ++k) {
        const double t = 5.3 + 2.5 * k;
        tb.at(t, [&, t] {
            for (int i = 0; i < sc.numNodes; ++i) {
                const core::PheromoneTable& table = tb.node(i).table();
                for (core::NodeAddress d : table.virtualDestinations()) {
                    if (d == static_cast<core::NodeAddress>(i) || d < 0 || d >= sc.numNodes)
                        continue;
                    core::NodeAddress vArg = core::kInvalidAddress;
                    double bv = cfg.minPheromone;
                    for (core::NodeAddress nb : table.neighbors()) {
                        const double v = table.getPheromoneVirtual(d, nb);
                        if (v > bv) { bv = v; vArg = nb; }
                    }
                    if (vArg == core::kInvalidAddress) continue;
                    const int di = dist[static_cast<std::size_t>(d)][static_cast<std::size_t>(i)];
                    const int dn = dist[static_cast<std::size_t>(d)][static_cast<std::size_t>(vArg)];
                    const bool reflected =
                        argmaxRegular(tb.node(static_cast<int>(vArg)).table(), d,
                                      cfg.minPheromone) == static_cast<core::NodeAddress>(i);
                    Counts& c = table.bestRegular(d) > cfg.minPheromone ? regPresent : regAbsent;
                    ++c.total;
                    if (dn > di) {
                        ++c.farther;
                        if (reflected) ++c.fartherReflected;
                        if (t < 20.0) ++c.fartherEarly;
                        if (tb.node(static_cast<int>(vArg)).table().bestRegular(d) <=
                            cfg.minPheromone)
                            ++c.fartherVargNoRoute;
                    }
                    if (dn < di) ++c.closer;
                    if (reflected) ++c.reflected;
                    if (&c == &regPresent) {
                        core::NodeAddress bArg = core::kInvalidAddress;
                        double bb = cfg.minPheromone;
                        for (core::NodeAddress nb : table.neighbors()) {
                            const double m = std::max(table.getPheromoneRegular(d, nb),
                                                      table.getPheromoneVirtual(d, nb));
                            if (m > bb) { bb = m; bArg = nb; }
                        }
                        if (bArg != core::kInvalidAddress) {
                            const int db = dist[static_cast<std::size_t>(d)]
                                               [static_cast<std::size_t>(bArg)];
                            if (db > di) ++c.blendFarther;
                            if (argmaxRegular(tb.node(static_cast<int>(bArg)).table(), d,
                                              cfg.minPheromone) ==
                                static_cast<core::NodeAddress>(i))
                                ++c.blendReflected;
                        }
                    }
                }
            }
        });
    }
    tb.runUntil(106.0);

    auto pct = [](std::uint64_t a, std::uint64_t b) {
        return b ? 100.0 * static_cast<double>(a) / static_cast<double>(b) : 0.0;
    };
    std::printf("\n=== %s ===\n", sc.name);
    for (const auto& row : {std::make_pair("regular-absent ", &regAbsent),
                            std::make_pair("regular-present", &regPresent)}) {
        const Counts& c = *row.second;
        std::printf("  %s  n=%6llu  closer=%5.1f%%  farther=%5.1f%%  "
                    "reflected=%5.1f%%  farther&reflected=%5.1f%% (%llu of %llu farther)\n",
                    row.first, (unsigned long long) c.total, pct(c.closer, c.total),
                    pct(c.farther, c.total), pct(c.reflected, c.total),
                    pct(c.fartherReflected, c.total),
                    (unsigned long long) c.fartherReflected, (unsigned long long) c.farther);
    }
    std::printf("  regular-absent farther cases: %llu at t<20s (formation transient), "
                "%llu where vArg holds no regular route to d (stale advert)\n",
                (unsigned long long) regAbsent.fartherEarly,
                (unsigned long long) regAbsent.fartherVargNoRoute);
    std::printf("  proactive blend max(r,v), regular-present: argmax farther=%5.1f%%  "
                "argmax reflected=%5.1f%%\n",
                pct(regPresent.blendFarther, regPresent.total),
                pct(regPresent.blendReflected, regPresent.total));
}

}  // namespace

int main() {
    std::printf("advert-reflection sizing (#263) on current code "
                "(#262 aging clock, #472 advert cap k = %zu)\n",
                core::Config().maxHelloAdverts);
    std::printf("old-clock reference (#180): regular-absent 'virtual argmax moves farther' "
                "= 8.4%% on grid-4x4; reflection caused all 3 genuine mis-steers\n");
    for (const Scenario& sc : {makeLine(), makeGrid(false), makeGrid(true)}) run(sc);
    return 0;
}
