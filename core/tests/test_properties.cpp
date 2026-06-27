// Property / invariant tests (item 13, D2): assert algebraic invariants over
// many randomized inputs, complementing the worked single cases in the other
// suites. Pure and simulator-free, so they run on every `make test`.
//
// Input randomness uses a seeded std::mt19937 (deterministic, reproducible);
// the core's own stochastic choices still come through the IRng port.
#include <algorithm>
#include <cstdint>
#include <random>
#include <set>

#include "anthocnet/core/ant_history.h"
#include "anthocnet/core/ant_message.h"
#include "anthocnet/core/ant_message_codec.h"
#include "anthocnet/core/config.h"
#include "anthocnet/core/pheromone_engine.h"
#include "anthocnet/core/pheromone_table.h"
#include "test_support.h"

using namespace anthocnet::core;
using anthocnet::test::ScriptedRng;

namespace {

double unit(std::mt19937& g) {
    return std::uniform_real_distribution<double>(0.0, 1.0)(g);
}

// --- Selection is a valid distribution -------------------------------------
// Every stochastic next-hop is a neighbour that actually holds pheromone for
// the destination; `exclude` is honoured unless it is the only option.
void propSelection(std::mt19937& g) {
    for (int iter = 0; iter < 200; ++iter) {
        PheromoneTable table;
        const NodeAddress dest = 100;
        const int n = 1 + static_cast<int>(g() % 6);
        std::set<NodeAddress> withPheromone;
        for (int k = 0; k < n; ++k) {
            const NodeAddress nb = static_cast<NodeAddress>(1 + k);
            table.setPheromoneRegular(dest, nb, 0.01 + 0.99 * unit(g));
            withPheromone.insert(nb);
        }
        const double beta = 1.0 + 3.0 * unit(g);
        for (int draw = 0; draw < 40; ++draw) {
            ScriptedRng rng({unit(g)});
            const NodeAddress hop = table.lookup(dest, beta, rng);
            CHECK(hop != kInvalidAddress);                 // a route exists
            CHECK(withPheromone.count(hop) == 1);          // and it bears pheromone
            CHECK(table.getPheromoneRegular(dest, hop) > 0.0);
        }
    }

    // prev-hop exclusion (A1): never the excluded neighbour while an alternative
    // exists; falls back to it only when it is the sole route.
    PheromoneTable t;
    t.setPheromoneRegular(5, 1, 0.5);
    t.setPheromoneRegular(5, 2, 0.5);
    for (int draw = 0; draw < 40; ++draw) {
        ScriptedRng rng({unit(g)});
        CHECK_EQ(t.lookup(5, 1.0, rng, /*exclude=*/1), 2);
    }
    t.removePheromoneRegular(5, 2);
    ScriptedRng only({0.5});
    CHECK_EQ(t.lookup(5, 1.0, only, /*exclude=*/1), 1);  // only option wins
}

// --- Evaporation is non-increasing and converges to a prune ----------------
void propEvaporation(std::mt19937& g) {
    for (int i = 0; i < 500; ++i) {
        Config c;
        c.alpha = unit(g);  // [0, 1]
        PheromoneEngine e(c);
        const double v = 1000.0 * unit(g);
        const double ev = e.evaporate(v);
        CHECK(ev <= v + 1e-9);   // never grows
        CHECK(ev >= -1e-9);      // never negative
    }

    // An un-reinforced link decays monotonically and is pruned in bounded steps.
    Config cfg;  // alpha 0.7, minPheromone 1e-5, evaporationInterval 1.0
    PheromoneEngine eng(cfg);
    PheromoneTable table;
    table.setPheromoneRegular(7, 3, 1.0);
    double prev = table.getPheromoneRegular(7, 3);
    int steps = 0;
    const int kMaxSteps = 1000;
    while (table.getPheromoneRegular(7, 3) > 0.0 && steps < kMaxSteps) {
        eng.evaporateAll(table, cfg.evaporationInterval);
        const double cur = table.getPheromoneRegular(7, 3);  // 0 once pruned
        if (cur > 0.0) {
            CHECK(cur <= prev + 1e-12);
            prev = cur;
        }
        ++steps;
    }
    CHECK(steps < kMaxSteps);                          // converged
    CHECK_EQ(table.getPheromoneRegular(7, 3), 0.0);    // link pruned
}

// --- Reinforce is a convex combination (contraction toward the update) -----
void propReinforce(std::mt19937& g) {
    for (int i = 0; i < 1000; ++i) {
        Config c;
        c.gamma = unit(g);  // [0, 1]
        PheromoneEngine e(c);
        const double v = 100.0 * unit(g);
        const double u = 100.0 * unit(g);
        const double r = e.reinforce(v, u);
        CHECK(r >= std::min(v, u) - 1e-9);
        CHECK(r <= std::max(v, u) + 1e-9);
    }
}

// --- Codec round-trips any valid message -----------------------------------
void propCodecRoundTrip(std::mt19937& g) {
    const AntType types[] = {AntType::Hello, AntType::Reactive, AntType::Proactive,
                             AntType::Repair, AntType::LinkFail};
    for (int iter = 0; iter < 300; ++iter) {
        AntMessage m;
        m.type      = types[g() % 5];
        m.direction = (g() % 2) ? AntDirection::Up : AntDirection::Down;
        m.src       = static_cast<NodeAddress>(g());
        m.dst       = static_cast<NodeAddress>(g());
        m.seqNum    = g();
        m.timeStart = 1000.0 * unit(g);
        m.lifeAnt   = 100.0 * unit(g);
        m.broadcastBudget = static_cast<int>(g() % 10) - 1;  // [-1, 8]

        const int nv = static_cast<int>(g() % (codec::kMaxVisitedOnWire + 1));
        for (int k = 0; k < nv; ++k)
            m.visited.push_back({static_cast<NodeAddress>(g()), 100.0 * unit(g)});
        const int nh = static_cast<int>(g() % (codec::kMaxHistoryOnWire + 1));
        for (int k = 0; k < nh; ++k)
            m.history.push_back({static_cast<NodeAddress>(g()), 100.0 * unit(g)});
        const int nd = static_cast<int>(g() % (codec::kMaxHelloOnWire + 1));
        for (int k = 0; k < nd; ++k)
            m.helloDests.push_back({static_cast<NodeAddress>(g()), unit(g)});

        std::vector<std::uint8_t> bytes;
        codec::serialize(m, bytes);
        CHECK_EQ(bytes.size(), codec::serializedSize(m));

        AntMessage out;
        CHECK(codec::deserialize(bytes, out));
        CHECK(out.type == m.type);
        CHECK(out.direction == m.direction);
        CHECK_EQ(out.src, m.src);
        CHECK_EQ(out.dst, m.dst);
        CHECK_EQ(out.seqNum, m.seqNum);
        CHECK_NEAR(out.timeStart, m.timeStart, 1e-9);
        CHECK_NEAR(out.lifeAnt, m.lifeAnt, 1e-9);
        CHECK_EQ(out.broadcastBudget, m.broadcastBudget);
        CHECK_EQ(out.visited.size(), m.visited.size());
        CHECK_EQ(out.history.size(), m.history.size());
        CHECK_EQ(out.helloDests.size(), m.helloDests.size());
        for (std::size_t i = 0; i < m.visited.size(); ++i) {
            CHECK_EQ(out.visited[i].node, m.visited[i].node);
            CHECK_NEAR(out.visited[i].time, m.visited[i].time, 1e-9);
        }
        for (std::size_t i = 0; i < m.helloDests.size(); ++i) {
            CHECK_EQ(out.helloDests[i].node, m.helloDests[i].node);
            CHECK_NEAR(out.helloDests[i].pheromone, m.helloDests[i].pheromone, 1e-9);
        }
    }
}

// --- Dedup history stays bounded and evicts FIFO ---------------------------
void propDedupBound() {
    const std::size_t cap = 8;
    AntHistoryTracker tracker(cap);
    const std::uint32_t total = 3 * static_cast<std::uint32_t>(cap);
    for (std::uint32_t i = 0; i < total; ++i) {
        CHECK(tracker.record(/*src=*/1, i));        // each (src,seq) is new
        CHECK(tracker.size() <= cap);               // never exceeds the cap
    }
    // Only the most recent `cap` insertions survive (oldest evicted first).
    for (std::uint32_t i = 0; i < total; ++i) {
        CHECK_EQ(tracker.seen(1, i), i >= total - cap);
    }
    // Re-recording a present key is a no-op that reports "already seen".
    const std::size_t before = tracker.size();
    CHECK(!tracker.record(1, total - 1));
    CHECK_EQ(tracker.size(), before);
}

}  // namespace

int main() {
    std::mt19937 g(0xA17C0DEu);
    propSelection(g);
    propEvaporation(g);
    propReinforce(g);
    propCodecRoundTrip(g);
    propDedupBound();
    return RUN_TESTS();
}
