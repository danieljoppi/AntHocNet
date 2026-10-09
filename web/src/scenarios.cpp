// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

#include "ahn_web/scenarios.h"

namespace ahn_web {

namespace {

/// Placement draws come from their own stream so they never shift a node's
/// core, timer or mobility stream.
SplitMix64 placement(const World& w) { return SplitMix64(w.seed() ^ 0x5CE4A21Full); }

// Every draw below goes into a named local before use: C++ leaves the order of
// function-argument evaluation unspecified (GCC and clang differ), so
// addNode(r.uniform(), r.uniform(), ...) would place nodes differently natively
// and in WASM. The parity gate caught exactly that.

void line(World& w) {
    // The first mission's world: six static nodes, each hearing only its
    // neighbours, one flow end to end.
    w.setArea(1100, 300, 0);
    w.setDiskChannel(250);
    for (int i = 0; i < 6; ++i) w.addNode(50 + i * 200.0, 150, 0);
    w.addFlow(0, 5, 2, 2, 1e9);
}

void manet(World& w) {
    // The default ad hoc world: phones on an open field. Two in three are
    // carried (random waypoint); every third one stays put, so the map shows
    // a MANET as it is -- some devices walking through, some standing still.
    SplitMix64 r = placement(w);
    w.setArea(1000, 1000, 0);
    w.setDiskChannel(250);
    Mobility m;
    m.kind = MobilityKind::RandomWaypoint;
    m.speedMin = 2;
    m.speedMax = 10;
    m.pause = 5;
    for (int i = 0; i < 30; ++i) {
        const double x = r.uniform() * 1000, y = r.uniform() * 1000;
        const int n = w.addNode(x, y, 0);
        if (i % 3 != 2) w.setMobility(n, m);
    }
    w.addFlow(0, 29, 2, 5, 1e9);
    w.addFlow(7, 18, 2, 6, 1e9);
    w.addFlow(12, 3, 2, 7, 1e9);
}

void mesh(World& w) {
    // Static Wi-Fi mesh: a jittered grid, nothing moves.
    SplitMix64 r = placement(w);
    w.setArea(1000, 1000, 0);
    w.setDiskChannel(250);
    for (int i = 0; i < 5; ++i)
        for (int j = 0; j < 5; ++j)
        {
            const double dx = (r.uniform() - 0.5) * 60, dy = (r.uniform() - 0.5) * 60;
            w.addNode(140 + i * 180 + dx, 140 + j * 180 + dy, 0);
        }
    w.addFlow(0, 24, 2, 3, 1e9);
    w.addFlow(4, 20, 2, 4, 1e9);
    w.addFlow(12, 2, 2, 5, 1e9);
}

void fanet(World& w) {
    // UAV swarm: 3-D Gauss-Markov at FANET speeds.
    SplitMix64 r = placement(w);
    w.setArea(1000, 1000, 300);
    w.setDiskChannel(300);
    Mobility m;
    m.kind = MobilityKind::GaussMarkov;
    m.gmMeanSpeed = 20;
    m.gmAlpha = 0.85;
    m.threeD = true;
    for (int i = 0; i < 20; ++i) {
        const double x = r.uniform() * 1000, y = r.uniform() * 1000, z = 50 + r.uniform() * 200;
        const int n = w.addNode(x, y, z);
        w.setMobility(n, m);
    }
    w.addFlow(0, 19, 2, 5, 1e9);
    w.addFlow(5, 14, 2, 6, 1e9);
    w.addFlow(9, 2, 2, 7, 1e9);
}

void vanet(World& w) {
    // Vehicles on a Manhattan street grid; buildings cut the radio.
    SplitMix64 r = placement(w);
    w.setArea(800, 800, 0);
    w.setUrbanChannel(300, 4, 4, 20);
    Mobility m;
    m.kind = MobilityKind::Manhattan;
    m.speedMin = 10;
    m.speedMax = 20;
    for (int i = 0; i < 30; ++i) {
        const double x = r.uniform() * 800, y = r.uniform() * 800;
        const int n = w.addNode(x, y, 0);
        if (i % 3 != 2) w.setMobility(n, m);
    }
    w.addFlow(0, 29, 2, 5, 1e9);
    w.addFlow(8, 21, 2, 6, 1e9);
    w.addFlow(15, 4, 2, 7, 1e9);
}

void satellite(World& w) {
    // The isl-grid snapshot: a 6 x 6 +grid torus, links fixed, delay tracking
    // distance (1000 km spacing, so ~3.3 ms a hop).
    const int k = 6;
    const double s = 1.0e6;
    w.setArea(k * s, k * s, 0);
    w.setIslChannel();
    for (int i = 0; i < k; ++i)
        for (int j = 0; j < k; ++j) w.addNode((i + 0.5) * s, (j + 0.5) * s, 0);
    for (int i = 0; i < k; ++i) {
        for (int j = 0; j < k; ++j) {
            const int id = i * k + j;
            w.addIslLink(id, ((i + 1) % k) * k + j);
            w.addIslLink(id, i * k + (j + 1) % k);
        }
    }
    w.addFlow(0, 21, 4, 3, 1e9);
    w.addFlow(5, 30, 4, 4, 1e9);
    w.addFlow(14, 35, 4, 5, 1e9);
}

}  // namespace

std::vector<std::string> scenarioNames() {
    return {"line", "manet", "mesh", "fanet", "vanet", "satellite"};
}

bool buildScenario(World& w, const std::string& name) {
    if (name == "line") line(w);
    else if (name == "manet") manet(w);
    else if (name == "mesh") mesh(w);
    else if (name == "fanet") fanet(w);
    else if (name == "vanet") vanet(w);
    else if (name == "satellite") satellite(w);
    else return false;
    return true;
}

}  // namespace ahn_web
