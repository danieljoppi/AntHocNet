// EXPERIMENT (#180 gate re-derivation / #262 guardrail) — not a regression test.
//
// Re-runs the virtual/regular-pheromone uniformity probe from the #180
// investigation (issue comment of 2026-07-30) on the NEW aging clock landed by
// #262 (4d1cbc1): virtual pheromone now ages in evaporateAll on the identical
// alpha^(dt/evaporationInterval) factor as regular, and hello receipt only
// reinforces.
//
// The old clock evaporated the whole virtual table x0.7 on every RECEIVED
// hello (~0.7^degree per second), which depressed virtual pheromone
// degree-dependently — measured on the old clock: median v/r 0.49 for the same
// (dest, neighbour) pair, 1.18 at degree-1 falling to 0.28 at degree-3/4, and
// swinging 0.0557 -> 11968 across snapshots with the 10 s proactive-refresh
// phase. That made the thesis's emission gate (bestVirtual >= 1.10 x
// bestRegular, Ducatelle 2007 lines 4084-4088) structurally unsatisfiable:
// pass rate 1.9-3.8% on a 4x4 grid, 0% on a line (#188's measured failure).
//
// Prediction under the new clock: v/r becomes degree-independent and
// phase-stable; the residual offset is the gamma-ramp (a fresh advert
// reinforces in at (1-gamma)=0.3 of its value) plus the one-hop bootstrap
// cost (advert A lands as 1/(1/A + hopTimeSec)). Analytically, with both
// tables on decay factor f = alpha^(1/evaporationInterval) per second and a
// bootstrap B refreshed every hello:
//   - constant B:  v* = (1-gamma)B / (1 - gamma*f)          = 0.588 B here;
//   - B decaying in phase with regular (B = B0 f^t):  v(t) -> B0 f^t = B(t),
//     i.e. the gamma-ramp penalty cancels entirely in the shared-decay phase.
// So steady v/r should sit between ~0.59x and ~1.0x of the bootstrap-to-
// regular ratio, independent of node degree and far tighter across the
// proactive-refresh phase than the old clock's 5-orders-of-magnitude swing.
//
// Method (reconstructing the original probe): drive the core testbench with
// hellos + proactively-refreshing data flows on three static topologies
// covering the degree range — an 8-node line (degree 1-2), a 4x4 grid
// (degree 2-4), and a 9-node star (hub degree 8) — and take 41 snapshots
// (t = 5.3 .. 105.3 s, step 2.5 s, offset off the timer ticks) of every
// matched (node, dest, neighbour) triple holding BOTH virtual and regular
// pheromone. Record v/r with node degree and snapshot time; then report the
// distribution, the per-pair spread across snapshot phase, and the pass rate
// of the emission gate bestVirtual >= k x bestRegular over a k grid — the
// empirical basis for re-deriving the gate condition on #180.
//
// Regime scoping (#248): MANET guidance is proactive-off, so the gate's
// payoff surface is the satellite regime; this probe measures the mechanism,
// not a MANET benchmark.
#include "test_support.h"
#include "testbench.h"

#include <algorithm>
#include <cstdio>
#include <map>
#include <set>
#include <string>
#include <tuple>
#include <utility>
#include <vector>

using namespace anthocnet;

namespace {

struct Sample {
    double t = 0.0;
    int node = 0;
    core::NodeAddress dest = core::kInvalidAddress;
    core::NodeAddress nb = core::kInvalidAddress;
    int degree = 0;
    double ratio = 0.0;  // virtual / regular for the same (dest, neighbour)
};

double percentile(std::vector<double> v, double p) {
    if (v.empty()) return 0.0;
    std::sort(v.begin(), v.end());
    const double idx = p * static_cast<double>(v.size() - 1);
    const std::size_t lo = static_cast<std::size_t>(idx);
    const std::size_t hi = (lo + 1 < v.size()) ? lo + 1 : lo;
    const double frac = idx - static_cast<double>(lo);
    return v[lo] * (1.0 - frac) + v[hi] * frac;
}

struct Scenario {
    const char* name;
    int numNodes;
    std::vector<std::pair<int, int>> links;
    std::vector<std::pair<int, int>> sessions;  // (source, dest)
};

Scenario makeLine() {
    Scenario s{"line-8 (degree 1-2)", 8, {}, {{0, 7}, {7, 0}}};
    for (int i = 0; i + 1 < 8; ++i) s.links.push_back({i, i + 1});
    return s;
}

Scenario makeGrid() {
    auto id = [](int r, int c) { return r * 4 + c; };
    Scenario s{"grid-4x4 (degree 2-4)", 16, {}, {}};
    for (int r = 0; r < 4; ++r) {
        for (int c = 0; c < 4; ++c) {
            if (c + 1 < 4) s.links.push_back({id(r, c), id(r, c + 1)});
            if (r + 1 < 4) s.links.push_back({id(r, c), id(r + 1, c)});
        }
    }
    s.sessions = {{id(0, 0), id(3, 3)}, {id(3, 3), id(0, 0)},
                  {id(0, 3), id(3, 0)}, {id(3, 0), id(0, 3)}};
    return s;
}

Scenario makeStar() {
    Scenario s{"star-9 (hub degree 8)", 9, {}, {{1, 5}, {2, 6}, {3, 7}, {4, 8}}};
    for (int leaf = 1; leaf <= 8; ++leaf) s.links.push_back({0, leaf});
    return s;
}

// Gate margins to sweep: bestVirtual >= k * bestRegular. 1.10 is the thesis's
// literal condition (1 + proactiveVirtualMargin at the 10% margin).
const double kGateK[] = {0.50, 0.60, 0.70, 0.80, 0.90, 0.95, 1.00, 1.05, 1.10, 1.20, 1.50};
constexpr int kNumGateK = static_cast<int>(sizeof(kGateK) / sizeof(kGateK[0]));

struct ScenarioResult {
    std::vector<Sample> samples;
    // Cross-neighbour spread max/min of v/r within one (node, dest) at one
    // snapshot, over (node, dest) with >= 2 matched neighbours.
    std::vector<double> crossNbSpread;
    // Gate pass counts per k: all (node, dest, snapshot) with a regular route,
    // and the subset where (node, dest) is an actual session (source, dest) —
    // the sites createProactiveAnts() really gates.
    std::uint64_t gatePassAll[kNumGateK] = {};
    std::uint64_t gateTotalAll = 0;
    std::uint64_t gatePassSrc[kNumGateK] = {};
    std::uint64_t gateTotalSrc = 0;
    // The quantity the gate actually tests, bestVirtual/bestRegular, sampled
    // at every gate site above (its distribution is what a margin k slices).
    std::vector<double> gateRatioAll;
    std::vector<double> gateRatioSrc;
};

ScenarioResult runScenario(const Scenario& sc) {
    core::Config cfg;
    cfg.enableProactive = true;
    cfg.enableDiffusion = true;
    // proactiveInterval stays at the default 10 s: the 10 s refresh sawtooth is
    // exactly the phase the probe must expose (the old clock swung v/r
    // 0.0557 -> 11968 across it).

    test::Testbench tb(sc.numNodes, cfg);
    std::map<int, int> degree;
    for (const auto& l : sc.links) {
        tb.linkUp(l.first, l.second);
        ++degree[l.first];
        ++degree[l.second];
    }

    // Offered traffic: every session sends a data packet every 2 s for 100 s,
    // keeping the sessions active (sessionTtl 5 s) so proactive refresh runs.
    for (const auto& sess : sc.sessions) {
        for (int t = 5; t < 105; t += 2) {
            tb.at(static_cast<core::Time>(t),
                  [&tb, sess] { tb.sendData(sess.first, sess.second); });
        }
    }

    std::set<std::pair<int, core::NodeAddress>> sessionPairs;
    for (const auto& sess : sc.sessions) {
        sessionPairs.insert({sess.first, static_cast<core::NodeAddress>(sess.second)});
    }

    ScenarioResult res;
    // 41 snapshots, t = 5.3 .. 105.3 step 2.5 s — offset off the whole-second
    // hello/proactive ticks, and sampling 4 phases of the 10 s proactive cycle.
    for (int k = 0; k <= 40; ++k) {
        const double t = 5.3 + 2.5 * k;
        tb.at(t, [&, t] {
            for (int i = 0; i < sc.numNodes; ++i) {
                const core::PheromoneTable& table = tb.node(i).table();
                // Matched (dest, neighbour) pairs holding BOTH pheromones.
                for (core::NodeAddress d : table.virtualDestinations()) {
                    if (d == static_cast<core::NodeAddress>(i)) continue;
                    for (core::NodeAddress nb : table.neighbors()) {
                        const double v = table.getPheromoneVirtual(d, nb);
                        const double r = table.getPheromoneRegular(d, nb);
                        if (v <= cfg.minPheromone || r <= cfg.minPheromone) continue;
                        res.samples.push_back({t, i, d, nb, degree[i], v / r});
                    }
                }
                // Cross-neighbour spread within one (node, dest).
                for (core::NodeAddress d : table.virtualDestinations()) {
                    if (d == static_cast<core::NodeAddress>(i)) continue;
                    double lo = 0.0, hi = 0.0;
                    int matched = 0;
                    for (core::NodeAddress nb : table.neighbors()) {
                        const double v = table.getPheromoneVirtual(d, nb);
                        const double r = table.getPheromoneRegular(d, nb);
                        if (v <= cfg.minPheromone || r <= cfg.minPheromone) continue;
                        const double ratio = v / r;
                        if (matched == 0) { lo = hi = ratio; }
                        else { lo = std::min(lo, ratio); hi = std::max(hi, ratio); }
                        ++matched;
                    }
                    if (matched >= 2) res.crossNbSpread.push_back(hi / lo);
                }
                // Gate sweep over every (node, dest) with a regular route.
                std::set<core::NodeAddress> dests(table.regularDestinations().begin(),
                                                  table.regularDestinations().end());
                for (core::NodeAddress d : dests) {
                    if (d == static_cast<core::NodeAddress>(i)) continue;
                    const double bestR = table.bestRegular(d);
                    if (bestR <= cfg.minPheromone) continue;
                    const double bestV = table.bestVirtual(d);
                    const bool isSrc = sessionPairs.count({i, d}) != 0;
                    ++res.gateTotalAll;
                    res.gateRatioAll.push_back(bestV / bestR);
                    if (isSrc) {
                        ++res.gateTotalSrc;
                        res.gateRatioSrc.push_back(bestV / bestR);
                    }
                    for (int m = 0; m < kNumGateK; ++m) {
                        if (bestV >= kGateK[m] * bestR) {
                            ++res.gatePassAll[m];
                            if (isSrc) ++res.gatePassSrc[m];
                        }
                    }
                }
            }
        });
    }

    tb.runUntil(106.0);
    return res;
}

void report(const Scenario& sc, const ScenarioResult& res, std::vector<double>& allRatios) {
    std::printf("\n=== scenario: %s ===\n", sc.name);
    std::printf("snapshots: 41 (t=5.3..105.3 step 2.5s), sessions: %d, matched samples: %d\n",
                static_cast<int>(sc.sessions.size()), static_cast<int>(res.samples.size()));

    std::vector<double> ratios;
    std::map<int, std::vector<double>> byDegree;
    std::map<std::tuple<int, core::NodeAddress, core::NodeAddress>, std::vector<double>> byPair;
    for (const Sample& s : res.samples) {
        ratios.push_back(s.ratio);
        allRatios.push_back(s.ratio);
        byDegree[s.degree].push_back(s.ratio);
        byPair[std::make_tuple(s.node, s.dest, s.nb)].push_back(s.ratio);
    }

    std::printf("v/r percentiles: p10=%.4f p25=%.4f p50=%.4f p75=%.4f p90=%.4f  min=%.4f max=%.4f\n",
                percentile(ratios, 0.10), percentile(ratios, 0.25), percentile(ratios, 0.50),
                percentile(ratios, 0.75), percentile(ratios, 0.90),
                percentile(ratios, 0.0), percentile(ratios, 1.0));

    std::printf("by node degree:\n");
    for (const auto& kv : byDegree) {
        std::printf("  deg=%d  n=%5d  median=%.4f  p10=%.4f  p90=%.4f\n",
                    kv.first, static_cast<int>(kv.second.size()),
                    percentile(kv.second, 0.50), percentile(kv.second, 0.10),
                    percentile(kv.second, 0.90));
    }

    // Per-pair spread across snapshot phase: max/min and IQR-ratio (p75/p25)
    // of v/r within one (node, dest, neighbour) across its snapshots.
    // Restricted to t >= 20 s so the route-formation transient (first reactive
    // discovery + first advert propagation) does not masquerade as phase swing.
    std::map<std::tuple<int, core::NodeAddress, core::NodeAddress>, std::vector<double>> byPairSteady;
    for (const Sample& s : res.samples) {
        if (s.t >= 20.0) byPairSteady[std::make_tuple(s.node, s.dest, s.nb)].push_back(s.ratio);
    }
    std::vector<double> spreads, iqrs;
    for (const auto& kv : byPairSteady) {
        if (kv.second.size() < 8) continue;  // need enough phases to mean anything
        spreads.push_back(percentile(kv.second, 1.0) / percentile(kv.second, 0.0));
        iqrs.push_back(percentile(kv.second, 0.75) / percentile(kv.second, 0.25));
    }
    std::printf("per-pair phase spread (t>=20s, pairs with >=8 snaps: %d):\n",
                static_cast<int>(spreads.size()));
    std::printf("  max/min : median=%.4f  p90=%.4f  max=%.4f\n",
                percentile(spreads, 0.50), percentile(spreads, 0.90),
                percentile(spreads, 1.0));
    std::printf("  p75/p25 : median=%.4f  p90=%.4f  max=%.4f\n",
                percentile(iqrs, 0.50), percentile(iqrs, 0.90),
                percentile(iqrs, 1.0));

    std::printf("cross-neighbour spread within (node,dest) at one snapshot (n=%d): median=%.4f p90=%.4f\n",
                static_cast<int>(res.crossNbSpread.size()),
                percentile(res.crossNbSpread, 0.50), percentile(res.crossNbSpread, 0.90));

    std::printf("gate-site ratio bestVirtual/bestRegular:\n");
    std::printf("  all pairs with route     p10=%.4f p25=%.4f p50=%.4f p75=%.4f p90=%.4f max=%.4f\n",
                percentile(res.gateRatioAll, 0.10), percentile(res.gateRatioAll, 0.25),
                percentile(res.gateRatioAll, 0.50), percentile(res.gateRatioAll, 0.75),
                percentile(res.gateRatioAll, 0.90), percentile(res.gateRatioAll, 1.0));
    std::printf("  session (src,dest) only  p10=%.4f p25=%.4f p50=%.4f p75=%.4f p90=%.4f max=%.4f\n",
                percentile(res.gateRatioSrc, 0.10), percentile(res.gateRatioSrc, 0.25),
                percentile(res.gateRatioSrc, 0.50), percentile(res.gateRatioSrc, 0.75),
                percentile(res.gateRatioSrc, 0.90), percentile(res.gateRatioSrc, 1.0));
    std::printf("gate pass rate, bestVirtual >= k * bestRegular:\n");
    std::printf("  %-26s", "k =");
    for (int m = 0; m < kNumGateK; ++m) std::printf("  %5.2f", kGateK[m]);
    std::printf("\n  %-26s", "all pairs with route");
    for (int m = 0; m < kNumGateK; ++m) {
        std::printf("  %4.1f%%", res.gateTotalAll
                                     ? 100.0 * static_cast<double>(res.gatePassAll[m]) /
                                           static_cast<double>(res.gateTotalAll)
                                     : 0.0);
    }
    std::printf("  (n=%llu)\n  %-26s", (unsigned long long) res.gateTotalAll,
                "session (src,dest) only");
    for (int m = 0; m < kNumGateK; ++m) {
        std::printf("  %4.1f%%", res.gateTotalSrc
                                     ? 100.0 * static_cast<double>(res.gatePassSrc[m]) /
                                           static_cast<double>(res.gateTotalSrc)
                                     : 0.0);
    }
    std::printf("  (n=%llu)\n", (unsigned long long) res.gateTotalSrc);
}

}  // namespace

int main() {
    std::printf("uniformity probe on the #262 aging clock "
                "(virtual ages in evaporateAll, same alpha^(dt/interval) as regular)\n");
    std::printf("old-clock reference (#180, 2026-07-30 comment): median v/r 0.49; "
                "deg1 1.18 / deg2 0.54-0.61 / deg3 0.28-0.40 / deg4 0.28-0.41; "
                "per-entry phase swing 0.0557 -> 11968\n");

    std::vector<double> allRatios;
    for (const Scenario& sc : {makeLine(), makeGrid(), makeStar()}) {
        report(sc, runScenario(sc), allRatios);
    }

    std::printf("\n=== overall (all scenarios pooled, n=%d) ===\n",
                static_cast<int>(allRatios.size()));
    std::printf("v/r percentiles: p10=%.4f p25=%.4f p50=%.4f p75=%.4f p90=%.4f\n",
                percentile(allRatios, 0.10), percentile(allRatios, 0.25),
                percentile(allRatios, 0.50), percentile(allRatios, 0.75),
                percentile(allRatios, 0.90));
    return 0;
}
