// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/**
 * ahn-web-trace: run every built-in scenario for a fixed time and print the
 * full event log -- every ant and data transmission, reception, route change,
 * queue and drop, with simulated time. The parity gate (web/test/parity.sh)
 * builds this natively and with Emscripten and requires byte-identical output:
 * the browser runs the same core, deciding the same things, as native.
 *
 * Usage: ahn-web-trace [seconds=60] [seed=1]
 *        ahn-web-trace --decode   (hex ant bytes per stdin line -> the X-ray's
 *                                  JSON, #637; web/test/xray.test.mjs)
 */
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <iostream>
#include <vector>
#include <string>

#include "ahn_web/scenarios.h"
#include "ahn_web/sim.h"
#include "ahn_web/xray.h"

int main(int argc, char** argv) {
    if (argc > 1 && std::strcmp(argv[1], "--decode") == 0) {
        std::string line;
        while (std::getline(std::cin, line)) {
            std::vector<std::uint8_t> bytes;
            for (std::size_t i = 0; i + 1 < line.size(); i += 2) {
                bytes.push_back(static_cast<std::uint8_t>(
                    std::strtoul(line.substr(i, 2).c_str(), nullptr, 16)));
            }
            std::printf("%s\n", ahn_web::antJson(bytes).c_str());
        }
        return 0;
    }
    const double seconds = argc > 1 ? std::strtod(argv[1], nullptr) : 60.0;
    const unsigned long long seed = argc > 2 ? std::strtoull(argv[2], nullptr, 10) : 1ULL;
    for (const std::string& name : ahn_web::scenarioNames()) {
        ahn_web::World w(seed);
        ahn_web::buildScenario(w, name);
        w.start();
        std::printf("## scenario %s seed=%llu nodes=%d\n", name.c_str(), seed, w.nodeCount());
        // Exercise the interaction paths too: half way through, switch a node
        // off, drag another, then bring the first back.
        const double half = seconds / 2;
        w.advanceTo(half);
        w.setNodeUp(1, false);
        const ahn_web::Vec3 p = w.position(2);
        w.moveNode(2, p.x + 120, p.y, p.z);
        w.advanceTo(half + seconds / 4);
        w.setNodeUp(1, true);
        w.advanceTo(seconds);
        for (const ahn_web::LogEvent& e : w.log()) {
            std::printf("%s\n", ahn_web::World::formatEvent(e).c_str());
        }
        for (std::size_t f = 0; f < w.flows().size(); ++f) {
            const ahn_web::Flow& fl = w.flows()[f];
            std::printf("# flow %zu %d->%d sent=%d delivered=%d delaySum=%.9g\n", f, fl.src, fl.dst,
                        fl.sent, fl.delivered, fl.delaySum);
        }
    }
    return 0;
}
