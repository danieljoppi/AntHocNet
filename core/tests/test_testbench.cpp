/*
 * Smoke scenario for the discrete-event testbench (issue #154): two nodes and
 * a link that goes down and comes back.
 *
 * This proves the harness itself works end to end — event queue, FakeClock,
 * hello/maintenance timers, ideal-MAC adjacency, and adapter-equivalent
 * execution of the RouteDecisions (Unicast / Broadcast / Queue / Deliver).
 * The actual trend regressions (repair vs re-flood, bounded storms, diffusion,
 * evaporation-off sanity) are issue #155 and are deliberately not asserted here.
 */
#include "anthocnet/core/config.h"
#include "test_support.h"
#include "testbench.h"

using namespace anthocnet::core;
using anthocnet::test::Testbench;

int main() {
    Config cfg;
    Testbench tb(/*numNodes*/ 2, cfg);
    tb.linkUp(0, 1);

    // A 1 pkt/s CBR stream from node 0 to node 1 for 30 s.
    for (int i = 0; i < 30; ++i) {
        tb.at(0.5 + i, [&tb] { tb.sendData(0, /*dest*/ 1); });
    }

    // The scripted topology: the link drops at t=10 and returns at t=20.
    tb.at(10.0, [&tb] { tb.linkDown(0, 1); });
    tb.at(20.0, [&tb] { tb.linkUp(0, 1); });

    int deliveredBeforeBreak = 0;
    int deliveredDuringBreak = 0;

    tb.at(9.9, [&] {
        deliveredBeforeBreak = tb.dataDelivered;
        // Route discovery converged over the ideal MAC.
        CHECK_EQ(tb.node(0).nextHopForData(1), 1);
    });

    tb.at(15.0, [&] {
        deliveredDuringBreak = tb.dataDelivered;
        // The maintenance tick expired the unreachable neighbour ...
        CHECK_EQ(tb.node(0).table().numNeighbors(), static_cast<std::size_t>(0));
        CHECK_EQ(tb.node(0).nextHopForData(1), kInvalidAddress);
        // ... and the data with nowhere to go was executed as Queue.
        CHECK(tb.pending(0, 1) > 0);
    });

    tb.runUntil(30.0);

    // Delivery happened while the link was up, stopped while it was down, and
    // resumed once the link (and hence route discovery) came back.
    CHECK(deliveredBeforeBreak > 0);
    CHECK_EQ(deliveredDuringBreak, deliveredBeforeBreak);
    CHECK(tb.dataDelivered > deliveredDuringBreak);
    CHECK_EQ(tb.node(0).nextHopForData(1), 1);
    // The ideal MAC is lossless, so control traffic exists but stays bounded.
    CHECK(tb.controlSent() > 0);

    return RUN_TESTS();
}
