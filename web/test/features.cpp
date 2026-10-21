// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/**
 * ahn-web-features (#582): checks the link rules of the scenario features the
 * chapter 6-8 worlds use -- jamming zones (still and moving), scripted node
 * events and the Mixed ground/air/space channel -- on tiny hand-built worlds.
 * parity.sh runs it natively and in WASM; it exits non-zero on a failure.
 */
#include <cstdio>

#include "ahn_web/sim.h"

using namespace ahn_web;

static int bad = 0;
#define CHECK(c, msg)                       \
    do {                                    \
        if (!(c)) {                         \
            std::printf("FAIL: %s\n", msg); \
            bad = 1;                        \
        } else {                            \
            std::printf("ok: %s\n", msg);   \
        }                                   \
    } while (0)
int main() {
    {  // static jammer between two nodes; a crossing link and an end inside
        World w(1);
        w.setArea(1000, 1000, 0);
        w.setDiskChannel(300);
        w.addNode(100, 500, 0);
        w.addNode(350, 500, 0);
        w.addNode(200, 500, 0);
        w.addNode(100, 300, 0);
        w.addJammingZone({200, 450, 260, 450, 260, 550, 200, 550}, 10, 20);
        w.start();
        w.advanceTo(5);
        CHECK(w.linkUp(0, 1), "before: crossing link up");
        w.advanceTo(15);
        CHECK(!w.linkUp(0, 1), "active: crossing link jammed");
        CHECK(!w.linkUp(0, 2), "active: end inside jammed");
        CHECK(w.linkUp(0, 3), "active: link clear of the zone up");
        w.advanceTo(25);
        CHECK(w.linkUp(0, 1) && w.linkUp(0, 2), "after until: links back");
    }
    {  // moving zone: a front that reaches node 1 later
        World w(1);
        w.setArea(1000, 1000, 0);
        w.setDiskChannel(300);
        w.addNode(400, 500, 0);
        w.addNode(450, 500, 0);
        w.addJammingZone({0, 0, 50, 0, 50, 1000, 0, 1000}, 0, 1e18, 10, 0);
        w.start();
        w.advanceTo(20);
        CHECK(w.linkUp(0, 1), "front at x 200-250: up");
        w.advanceTo(37);
        CHECK(!w.linkUp(0, 1), "front at x 370-420: jammed");
        w.advanceTo(60);
        CHECK(w.linkUp(0, 1), "front passed (x 600-650): up");
        std::vector<double> z = w.jamZonesFlat();
        CHECK(z.size() == 9 && z[1] == 600 && z[3] == 650, "jamZonesFlat moves with the front");
    }
    {  // scripted events
        World w(1);
        w.setArea(1000, 1000, 0);
        w.setDiskChannel(300);
        w.addNode(100, 100, 0);
        w.addNode(200, 100, 0);
        w.scheduleNodeUp(1, 5, false);
        w.scheduleNodeUp(1, 8, true);
        w.start();
        w.advanceTo(4.99);
        CHECK(w.nodeUp(1), "up before 5 s");
        w.advanceTo(5);
        CHECK(!w.nodeUp(1), "down at 5 s");
        w.advanceTo(8);
        CHECK(w.nodeUp(1), "up again at 8 s");
    }
    {  // mixed: sat-sat by ISL only, sat-station by elevation, ground pairs by disk
        World w(1);
        w.setArea(2.2e7, 2.2e7, 0);
        w.setMixedChannel(5e4);
        const double c = 1.1e7, R = 6.371e6;
        int g = w.addNode(c + R, c, 0);
        w.setGroundStation(g, 25);  // station on the equator at lon 0
        int h = w.addNode(c + R + 2e4, c, 0);
        w.setNodeRange(h, 4.5e5);              // a HAPS straight above
        int r = w.addNode(c + R, c + 3e4, 0);  // a radio 30 km away
        int s1 = w.addNode(c + R + 1.2e6, c, 0);
        w.setSatellite(s1);  // satellite at zenith
        int s2 = w.addNode(c + R + 1.2e6, c + 2e5, 0);
        w.setSatellite(s2);
        int s3 = w.addNode(c - R - 1.2e6, c, 0);
        w.setSatellite(s3);  // the far side
        w.addIslLink(s1, s3);
        w.start();
        CHECK(w.linkUp(g, s1), "station sees the zenith satellite");
        CHECK(!w.linkUp(g, s3), "station does not see the far side");
        CHECK(!w.linkUp(h, s1), "a non-station never links to a satellite");
        CHECK(w.linkUp(s1, s3) && !w.linkUp(s1, s2),
              "satellites link by ISL only, not by distance");
        CHECK(w.linkUp(g, h) && w.linkUp(g, r) && w.linkUp(h, r),
              "ground and air link by the disk rule");
        CHECK(w.channel() == ChannelKind::Mixed, "channel is Mixed");
    }
    return bad;
}
