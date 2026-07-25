// Issue #143 — the name -> ILinkMetric registry. A known name resolves to the
// right instance, the same stable non-owning instance every time; an unknown
// name is a loud error rather than a quiet fall back to classic; and the
// default routing path is unaffected (no selection still means ClassicMetric,
// bit-for-bit).
#include <cmath>
#include <stdexcept>
#include <string>
#include <vector>

#include "anthocnet/core/ant_router_logic.h"
#include "anthocnet/core/link_metric_registry.h"
#include "test_support.h"

using namespace anthocnet::core;
using anthocnet::test::FakeClock;
using anthocnet::test::ScriptedRng;

namespace {

// Pheromone a back ant would deposit for a retraced path, via the router's
// metric (same shape as test_link_metric.cpp).
double walk(AntRouterLogic& r, const std::vector<double>& deltas) {
    AntMessage b;
    b.direction = AntDirection::Down;
    b.src = 5;
    for (std::size_t i = 0; i < deltas.size(); ++i) {
        b.history.push_back({static_cast<NodeAddress>(i + 1), deltas[i]});
    }
    return r.backAntPheromone(b);
}

}  // namespace

int main() {
    // 1. The canonical metric is registered under a stable name, and the name
    //    is exactly "classic" (it is adapter-facing configuration).
    CHECK(std::string(metrics::kClassic) == "classic");
    const ILinkMetric* classic = metrics::find(metrics::kClassic);
    CHECK(classic != nullptr);
    CHECK(dynamic_cast<const ClassicMetric*>(classic) != nullptr);

    // ...and it computes the Eq.2 formula, not merely some ILinkMetric.
    LinkObservation o;
    o.hops = 3;
    o.pathTime = 0.15;
    o.hopTime = 0.05;
    if (classic != nullptr) {
        CHECK_NEAR(classic->pheromone(o), ClassicMetric().pheromone(o), 1e-12);
        CHECK_NEAR(classic->pheromone(o), std::pow((0.15 + 3 * 0.05) / 2.0, -1.0), 1e-12);
    }

    // 2. Lookup is stable: every caller gets the same process-lifetime instance,
    //    which is what makes the non-owning raw pointer safe to hand to
    //    AntRouterLogic (and both accessors agree).
    CHECK(metrics::find("classic") == classic);
    CHECK(&metrics::get("classic") == classic);

    // 3. An unknown name is a loud error, never a silent ClassicMetric.
    CHECK(metrics::find("no-such-metric") == nullptr);
    CHECK(metrics::find("") == nullptr);
    CHECK(metrics::find("Classic") == nullptr);  // lookup is case-sensitive

    bool threw = false;
    try {
        metrics::get("no-such-metric");
        CHECK(false);  // must not reach here
    } catch (const std::invalid_argument& e) {
        threw = true;
        const std::string what = e.what();
        // The message names the offending value and the valid alternatives.
        CHECK(what.find("no-such-metric") != std::string::npos);
        CHECK(what.find("classic") != std::string::npos);
    }
    CHECK(threw);

    CHECK(metrics::registeredNames().find("classic") != std::string::npos);

    // 4. Default path unchanged: a router with no metric injected behaves
    //    exactly like one handed the registry's "classic".
    FakeClock clock;
    ScriptedRng rng({0.5});
    Config cfg;
    const std::vector<double> path = {0.05, 0.05, 0.05};  // hops=3, pathTime=0.15

    AntRouterLogic byDefault(/*addr*/ 0, cfg, clock, rng);
    AntRouterLogic selected(/*addr*/ 0, cfg, clock, rng, metrics::find(metrics::kClassic));
    CHECK_NEAR(walk(byDefault, path), walk(selected, path), 1e-12);
    // T_hop from the Config default (#88), not a literal.
    CHECK_NEAR(walk(byDefault, path), std::pow((0.15 + 3 * cfg.hopTimeSec) / 2.0, -1.0), 1e-12);

    return RUN_TESTS();
}
