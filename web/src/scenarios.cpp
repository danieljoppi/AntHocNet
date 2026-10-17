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
    // carried (random waypoint, 3-15 m/s: walking to cycling); every third
    // one stays put, so the map shows a MANET as it is -- some devices moving
    // through, some standing still.
    SplitMix64 r = placement(w);
    w.setArea(1000, 1000, 0);
    w.setDiskChannel(250);
    Mobility m;
    m.kind = MobilityKind::RandomWaypoint;
    m.speedMin = 3;  // walking to cycling
    m.speedMax = 15;
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
        for (int j = 0; j < 5; ++j) {
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
    // A Walker-delta constellation that actually orbits: 8 planes of 8
    // satellites, 1200 km up, 53 deg inclination, planes 45 deg apart in RAAN,
    // phasing F = 1. Satellites in one plane share an orbit; each plane is a
    // different orbit. The +grid links are fixed (ahead / behind in the plane,
    // same slot in the next plane, wrapping like a torus); their delay follows
    // the real, changing distance. The teaching orbit takes 120 s, ~55x faster
    // than a real 1200 km orbit (109 min), so the motion is visible.
    constexpr int kPlanes = 8, kSlots = 8;
    constexpr double kPi = 3.141592653589793;
    constexpr double kEarth = 6.371e6, kAlt = 1.2e6;
    w.setArea(2.2e7, 2.2e7, 0);  // the Earth's centre is the field's centre
    w.setIslChannel();
    Mobility m;
    m.kind = MobilityKind::Orbit;
    m.orbitRadius = kEarth + kAlt;
    m.orbitInc = 53 * kPi / 180;
    m.orbitRate = 2 * kPi / 120;
    for (int p = 0; p < kPlanes; ++p) {
        for (int s = 0; s < kSlots; ++s) {
            m.orbitRaan = p * 2 * kPi / kPlanes;
            m.orbitPhase = s * 2 * kPi / kSlots + p * 2 * kPi / (kPlanes * kSlots);
            const int n = w.addNode(0, 0, 0);
            w.setMobility(n, m);  // places it on its orbit
        }
    }
    for (int p = 0; p < kPlanes; ++p) {
        for (int s = 0; s < kSlots; ++s) {
            const int id = p * kSlots + s;
            w.addIslLink(id, p * kSlots + (s + 1) % kSlots);
            w.addIslLink(id, ((p + 1) % kPlanes) * kSlots + s);
        }
    }
    w.addFlow(0, 36, 4, 3, 1e9);
    w.addFlow(5, 50, 4, 4, 1e9);
    w.addFlow(18, 61, 4, 5, 1e9);
}

void town(World& w) {
    // Ad hoc town (#568, campaign chapter 1): devices with different radios.
    // Phones are carried at walking pace and reach least; laptops move now and
    // then; desktop PCs stay put indoors and reach furthest. A link needs both
    // ends in range, so a phone next to a PC still only reaches 120 m.
    SplitMix64 r = placement(w);
    w.setArea(600, 450, 0);
    w.setDiskChannel(250);
    Mobility walk;
    walk.kind = MobilityKind::RandomWaypoint;
    walk.speedMin = 1;  // strolling to walking
    walk.speedMax = 2;
    walk.pause = 10;
    Mobility carry = walk;
    carry.speedMin = 1;
    carry.speedMax = 1.5;
    carry.pause = 60;  // a laptop sits on a table most of the time
    for (int i = 0; i < 30; ++i) {
        const double x = r.uniform() * 600, y = r.uniform() * 450;
        const int n = w.addNode(x, y, 0);
        if (i % 4 == 3) {  // desktop PC
            w.setNodeRange(n, 250);
        } else if (i % 4 == 2) {  // laptop
            w.setNodeRange(n, 180);
            w.setMobility(n, carry);
        } else {  // phone
            w.setNodeRange(n, 120);
            w.setMobility(n, walk);
        }
    }
    w.addFlow(0, 29, 2, 5, 1e9);
    w.addFlow(5, 16, 2, 6, 1e9);
}

void city(World& w) {
    // City streets (#576, chapter 3; #575 features): the vanet street grid
    // with three kinds of device. Cars drive the Manhattan grid; a bus runs a
    // fixed line round the outer ring of blocks; roadside units stand at four
    // inner intersections and reach further than a car.
    SplitMix64 r = placement(w);
    w.setArea(800, 800, 0);
    w.setUrbanChannel(300, 4, 4, 20);
    Mobility car;
    car.kind = MobilityKind::Manhattan;
    car.speedMin = 10;
    car.speedMax = 20;
    for (int i = 0; i < 20; ++i) {
        const double x = r.uniform() * 800, y = r.uniform() * 800;
        w.setMobility(w.addNode(x, y, 0), car);
    }
    Mobility bus;
    bus.kind = MobilityKind::Route;
    bus.speedMin = 8;
    bus.route = {Vec3{200, 200, 0}, Vec3{600, 200, 0}, Vec3{600, 600, 0}, Vec3{200, 600, 0}};
    w.setMobility(w.addNode(200, 200, 0), bus);
    // Roadside units at four inner intersections (the 4 x 4 grid's are 200 m
    // apart).
    const double rsuAt[4][2] = {{200, 400}, {400, 200}, {600, 400}, {400, 600}};
    for (const auto& at : rsuAt) w.setNodeRange(w.addNode(at[0], at[1], 0), 400);
    w.addFlow(0, 19, 2, 5, 1e9);
    w.addFlow(20, 7, 2, 6, 1e9);
}

void forest(World& w) {
    // Forest (#577, chapter 4; #575 features): a 3-D field over two canopy
    // patches that halve any radio inside them. Ranger radios and sensor
    // posts stand on the ground; relay drones fly overhead on batteries
    // small enough that the first runs out after about a minute and the
    // last after about six.
    SplitMix64 r = placement(w);
    w.setArea(800, 800, 200);
    w.setDiskChannel(300);
    w.addAttenuationZone({80, 80, 360, 80, 360, 720, 80, 720}, 0.5);
    w.addAttenuationZone({480, 240, 760, 240, 760, 560, 480, 560}, 0.5);
    for (int i = 0; i < 10; ++i) {  // ranger radios and sensor posts
        const double x = r.uniform() * 800, y = r.uniform() * 800;
        w.setNodeRange(w.addNode(x, y, 0), i % 2 ? 250 : 350);
    }
    Mobility drone;
    drone.kind = MobilityKind::GaussMarkov;
    drone.gmMeanSpeed = 15;
    drone.gmAlpha = 0.85;
    drone.threeD = true;
    for (int i = 0; i < 10; ++i) {
        const double x = r.uniform() * 800, y = r.uniform() * 800, z = 80 + r.uniform() * 100;
        const int d = w.addNode(x, y, z);
        w.setMobility(d, drone);
        w.setBattery(d, 50.0 + 25.0 * i);  // ~60-340 s at the idle draw
    }
    w.addFlow(0, 9, 2, 5, 1e9);
    w.addFlow(3, 6, 2, 6, 1e9);
}

void orbit(World& w) {
    // Orbit (#578, chapter 5; #575 features): the satellite world's shell
    // with four ground stations on the Earth's surface. A station links to
    // the satellites at least 25 deg above its horizon, so its links come
    // and go as the shell turns: handovers. Two flows cross the shell from
    // station to station.
    constexpr int kPlanes = 8, kSlots = 8;
    constexpr double kPi = 3.141592653589793;
    constexpr double kEarth = 6.371e6, kAlt = 1.2e6;
    w.setArea(2.2e7, 2.2e7, 0);
    w.setIslChannel();
    Mobility m;
    m.kind = MobilityKind::Orbit;
    m.orbitRadius = kEarth + kAlt;
    m.orbitInc = 53 * kPi / 180;
    m.orbitRate = 2 * kPi / 120;
    for (int p = 0; p < kPlanes; ++p) {
        for (int s = 0; s < kSlots; ++s) {
            m.orbitRaan = p * 2 * kPi / kPlanes;
            m.orbitPhase = s * 2 * kPi / kSlots + p * 2 * kPi / (kPlanes * kSlots);
            w.setMobility(w.addNode(0, 0, 0), m);
        }
    }
    for (int p = 0; p < kPlanes; ++p) {
        for (int s = 0; s < kSlots; ++s) {
            const int id = p * kSlots + s;
            w.addIslLink(id, p * kSlots + (s + 1) % kSlots);
            w.addIslLink(id, ((p + 1) % kPlanes) * kSlots + s);
        }
    }
    // Ground stations at (latitude, longitude) in degrees, on the sphere.
    const double sites[4][2] = {{48.9, 2.4}, {-8.8, 13.2}, {40.7, -74.0}, {-23.5, -46.6}};
    const double cx = 1.1e7, cy = 1.1e7;
    int gs[4];
    for (int i = 0; i < 4; ++i) {
        const double lat = sites[i][0] * kPi / 180, lon = sites[i][1] * kPi / 180;
        const double cl = detCos(lat);
        gs[i] = w.addNode(cx + kEarth * cl * detCos(lon), cy + kEarth * cl * detSin(lon),
                          kEarth * detSin(lat));
        w.setGroundStation(gs[i], 25);
    }
    w.addFlow(gs[0], gs[1], 4, 3, 1e9);
    w.addFlow(gs[2], gs[3], 4, 4, 1e9);
}

}  // namespace

std::vector<std::string> scenarioNames() {
    return {"line",  "manet",     "town", "mesh",   "fanet",
            "vanet", "satellite", "city", "forest", "orbit"};
}

bool buildScenario(World& w, const std::string& name) {
    if (name == "line")
        line(w);
    else if (name == "manet")
        manet(w);
    else if (name == "town")
        town(w);
    else if (name == "mesh")
        mesh(w);
    else if (name == "fanet")
        fanet(w);
    else if (name == "vanet")
        vanet(w);
    else if (name == "satellite")
        satellite(w);
    else if (name == "city")
        city(w);
    else if (name == "forest")
        forest(w);
    else if (name == "orbit")
        orbit(w);
    else
        return false;
    return true;
}

}  // namespace ahn_web
