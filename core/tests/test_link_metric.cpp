// Item 16 — the pheromone formula is a pluggable ILinkMetric. The default
// ClassicMetric reproduces the post-item-02 Eq.2 inline formula exactly, and a
// custom metric can be injected without editing AntRouterLogic decision code.
#include <cmath>
#include <vector>

#include "anthocnet/core/ant_router_logic.h"
#include "anthocnet/core/link_metric.h"
#include "test_support.h"

using namespace anthocnet::core;
using anthocnet::test::FakeClock;
using anthocnet::test::ScriptedRng;

namespace {

// A stub metric proving the seam works (ignores the observation).
struct ConstMetric : ILinkMetric {
    double v;
    explicit ConstMetric(double x) : v(x) {}
    double pheromone(const LinkObservation&) const override { return v; }
};

// Walk a backward ant over per-hop deltas and return the full-path pheromone.
double walk(AntRouterLogic& r, const std::vector<double>& deltas) {
    AntMessage b;
    b.direction = AntDirection::Down;
    b.src = 5;
    for (std::size_t i = 0; i < deltas.size(); ++i) {
        b.visited.push_back({static_cast<NodeAddress>(i + 1), deltas[i]});
    }
    NodeAddress n;
    do {
        n = r.advanceBackAnt(b);
    } while (n != kInvalidAddress);
    return b.pheromone;
}

}  // namespace

int main() {
    // 1. ClassicMetric is exactly the Eq.2 formula.
    ClassicMetric classic;
    LinkObservation o;
    o.hops = 3;
    o.pathTime = 0.15;
    o.hopTime = 0.05;
    CHECK_NEAR(classic.pheromone(o), std::pow((0.15 + 3 * 0.05) / 2.0, -1.0), 1e-12);

    FakeClock clock;
    ScriptedRng rng({0.5});
    Config cfg;

    // 2. With no metric injected, advanceBackAnt uses ClassicMetric (regression
    //    against the post-item-02 inline formula).
    {
        AntRouterLogic r(/*addr*/ 0, cfg, clock, rng);
        const double ph = walk(r, {0.05, 0.05, 0.05});  // hops=3, pathTime=0.15
        CHECK_NEAR(ph, std::pow((0.15 + 3 * 0.05) / 2.0, -1.0), 1e-12);
    }

    // 3. A custom metric changes the deposit, with no edit to the state machine.
    {
        ConstMetric stub(42.0);
        AntRouterLogic r(/*addr*/ 0, cfg, clock, rng, &stub);
        CHECK_NEAR(walk(r, {0.05, 0.05, 0.05}), 42.0, 1e-12);
    }

    return RUN_TESTS();
}
