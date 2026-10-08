// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/**
 * Embind surface of the browser adapter: what the learn site's JavaScript may
 * call. Construction, running, interaction, and *read-only* inspection of the
 * core's state. Nothing here computes a route; it reports what the core holds.
 */
#include <emscripten/bind.h>
#include <emscripten/val.h>

#include "ahn_web/scenarios.h"
#include "ahn_web/sim.h"

using namespace emscripten;
using ahn_web::World;

namespace {

/// Positions as a flat [x, y, z, up, ...] Float64Array copy.
val positions(const World& w) {
    std::vector<double> out;
    out.reserve(w.nodeCount() * 4);
    for (int i = 0; i < w.nodeCount(); ++i) {
        const ahn_web::Vec3 p = w.position(i);
        out.push_back(p.x);
        out.push_back(p.y);
        out.push_back(p.z);
        out.push_back(w.nodeUp(i) ? 1 : 0);
    }
    return val::global("Float64Array").new_(typed_memory_view(out.size(), out.data()));
}

/// Drain the event log as a flat [t, kind, node, peer, a, b, v, ...] array.
val drainEvents(World& w) {
    std::vector<double> out;
    out.reserve(w.log().size() * 7);
    for (const ahn_web::LogEvent& e : w.log()) {
        out.push_back(e.t);
        out.push_back(static_cast<double>(e.kind));
        out.push_back(e.node);
        out.push_back(e.peer);
        out.push_back(e.a);
        out.push_back(e.b);
        out.push_back(e.v);
    }
    w.clearLog();
    return val::global("Float64Array").new_(typed_memory_view(out.size(), out.data()));
}

/// Current radio links as a flat [a, b, ...] Int32Array (a < b).
val links(const World& w) {
    std::vector<int> out;
    for (int a = 0; a < w.nodeCount(); ++a)
        for (int b = a + 1; b < w.nodeCount(); ++b)
            if (w.linkUp(a, b)) {
                out.push_back(a);
                out.push_back(b);
            }
    return val::global("Int32Array").new_(typed_memory_view(out.size(), out.data()));
}

/// Node `n`'s pheromone row for `dest`: flat [neighbour, regular, virtual, ...]
/// straight from the core's PheromoneTable (no recomputation).
val pheromone(const World& w, int n, int dest) {
    const auto& t = w.node(n).logic().table();
    std::vector<double> out;
    for (int nb : t.neighbors()) {
        out.push_back(nb);
        out.push_back(t.getPheromoneRegular(dest, nb));
        out.push_back(t.getPheromoneVirtual(dest, nb));
    }
    return val::global("Float64Array").new_(typed_memory_view(out.size(), out.data()));
}

/// The distribution node `n`'s core samples a *data* next hop for `dest`
/// from (betaData, `prevHop` excluded per A1): flat [neighbour, p, ...].
/// Straight from PheromoneTable::nextHopDistribution -- no recomputation.
val distribution(const World& w, int n, int dest, int prevHop) {
    const auto& logic = w.node(n).logic();
    std::vector<double> out;
    for (const auto& e : logic.table().nextHopDistribution(dest, false, logic.config().betaData,
                                                           prevHop)) {
        out.push_back(e.first);
        out.push_back(e.second);
    }
    return val::global("Float64Array").new_(typed_memory_view(out.size(), out.data()));
}

/// Destinations node `n` holds regular pheromone for.
val destinations(const World& w, int n) {
    std::vector<int> out(w.node(n).logic().table().regularDestinations().begin(),
                         w.node(n).logic().table().regularDestinations().end());
    return val::global("Int32Array").new_(typed_memory_view(out.size(), out.data()));
}

/// Flow stats as a flat [src, dst, sent, delivered, delaySum, ...] array.
val flowStats(const World& w) {
    std::vector<double> out;
    for (const ahn_web::Flow& f : w.flows()) {
        out.push_back(f.src);
        out.push_back(f.dst);
        out.push_back(f.sent);
        out.push_back(f.delivered);
        out.push_back(f.delaySum);
    }
    return val::global("Float64Array").new_(typed_memory_view(out.size(), out.data()));
}

World* makeWorld(double seed, const std::string& scenario) {
    World* w = new World(static_cast<std::uint64_t>(seed));
    if (!scenario.empty() && !ahn_web::buildScenario(*w, scenario)) {
        delete w;
        return nullptr;
    }
    return w;
}

void setMobility(World& w, int node, int kind, double a, double b, double c, bool threeD) {
    ahn_web::Mobility m;
    m.kind = static_cast<ahn_web::MobilityKind>(kind);
    if (m.kind == ahn_web::MobilityKind::GaussMarkov) {
        m.gmMeanSpeed = a;
        m.gmAlpha = b;
        m.threeD = threeD;
    } else {
        m.speedMin = a;
        m.speedMax = b;
        m.pause = c;
    }
    w.setMobility(node, m);
}

void setConfig(World& w, const std::string& key, double v) {
    // Mission-scoped knobs only (ADR-0019: worlds never change these).
    auto& c = w.config();
    if (key == "betaData") c.betaData = v;
    else if (key == "betaAnts") c.betaAnts = v;
    else if (key == "alpha") c.alpha = v;
    else if (key == "helloInterval") c.helloInterval = v;
    else if (key == "proactiveInterval") c.proactiveInterval = v;
    else if (key == "enableProactive") c.enableProactive = v != 0;
    else if (key == "enableMultipath") c.enableMultipath = v != 0;
    else if (key == "enableRepair") c.enableRepair = v != 0;
}

double getConfig(World& w, const std::string& key) {
    const auto& c = w.config();
    if (key == "betaData") return c.betaData;
    if (key == "betaAnts") return c.betaAnts;
    if (key == "alpha") return c.alpha;
    if (key == "helloInterval") return c.helloInterval;
    if (key == "proactiveInterval") return c.proactiveInterval;
    if (key == "enableProactive") return c.enableProactive;
    if (key == "enableMultipath") return c.enableMultipath;
    if (key == "enableRepair") return c.enableRepair;
    return 0;
}

val scenarioList() {
    val arr = val::array();
    for (const std::string& s : ahn_web::scenarioNames()) arr.call<void>("push", s);
    return arr;
}

}  // namespace

EMSCRIPTEN_BINDINGS(anthocnet) {
    function("scenarios", &scenarioList);
    class_<World>("World")
        .constructor(&makeWorld, allow_raw_pointers())
        .function("setArea", &World::setArea)
        .function("setDiskChannel", &World::setDiskChannel)
        .function("setUrbanChannel", &World::setUrbanChannel)
        .function("setIslChannel", &World::setIslChannel)
        .function("addIslLink", &World::addIslLink)
        .function("cutIslLink", &World::cutIslLink)
        .function("addNode", &World::addNode)
        .function("setMobility", &setMobility)
        .function("addFlow", &World::addFlow)
        .function("setConfig", &setConfig)
        .function("getConfig", &getConfig)
        .function("start", &World::start)
        .function("advanceTo", &World::advanceTo)
        .function("now", &World::now)
        .function("moveNode", &World::moveNode)
        .function("setNodeUp", &World::setNodeUp)
        .function("nodeCount", &World::nodeCount)
        .function("pendingCount", &World::pendingCount)
        .function("antTransmissions", &World::antTransmissions)
        .function("range", &World::range)
        .function("channel", optional_override([](const World& w) { return static_cast<int>(w.channel()); }))
        .function("blocksX", &World::urbanBlocksX)
        .function("blocksY", &World::urbanBlocksY)
        .function("streetWidth", &World::streetWidth)
        .function("areaX", optional_override([](const World& w) { return w.area().x; }))
        .function("areaY", optional_override([](const World& w) { return w.area().y; }))
        .function("areaZ", optional_override([](const World& w) { return w.area().z; }))
        .function("positions", &positions)
        .function("links", &links)
        .function("drainEvents", &drainEvents)
        .function("pheromone", &pheromone)
        .function("destinations", &destinations)
        .function("distribution", &distribution)
        .function("flowStats", &flowStats);
}
