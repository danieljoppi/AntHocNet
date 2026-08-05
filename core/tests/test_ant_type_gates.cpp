// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

// Per-ant-type gates and directed reactive discovery.
//
// Two things are asserted here, and they are different in kind.
//
// 1. THE GATES ARE INERT BY DEFAULT. enableReactive / enableRepair /
//    enableLinkFail all default true, so nothing about the shipped protocol
//    changes; the surrounding suite (23 tests) is the real evidence for that,
//    and this file only pins the "off" direction — each gate must actually
//    suppress the ant type it names, without breaking the correctness half it
//    is entangled with (pruning a dead neighbour, releasing buffered packets).
//
// 2. DIRECTED REACTIVE DISCOVERY DOES SOMETHING. [1] §3.1 broadcasts a reactive
//    forward ant wherever the node has no pheromone for the destination. But
//    the node may already hold a *virtual* pheromone gradient for it, diffused
//    through hello adverts (ADR-0007) — selectNextHop only blends that in for
//    proactive ants, so a reactive ant floods straight past it. With
//    enableDirectedReactive the ant follows the gradient instead.
//
//    The test that matters is not "it is cheaper" (that is a benchmark
//    question, on a real PHY, via the benchmark-results skill) but "the
//    mechanism engages and still finds the destination" — a directed ant that
//    walks into a dead end and never arrives would be a regression no overhead
//    number would excuse.
#include "test_support.h"
#include "testbench.h"

using namespace anthocnet;

namespace {

// A line 0-1-2-...-(n-1). Long enough that discovery is multi-hop, so the
// difference between flooding and steering is visible.
void buildLine(test::Testbench& tb, int n) {
    for (int i = 0; i + 1 < n; ++i) tb.linkUp(i, i + 1);
}

core::Config baseConfig() {
    core::Config cfg;
    // Keep the periodic machinery quiet unless a case needs it, so a counter
    // change is attributable to the gate under test.
    cfg.enableEvaporation = false;
    cfg.enableProactive = false;
    return cfg;
}

// --- 1. gates suppress what they name ---------------------------------------

void testReactiveGateSuppressesDiscovery() {
    for (bool enabled : {true, false}) {
        core::Config cfg = baseConfig();
        cfg.enableDiffusion = false;  // no other route source
        cfg.enableReactive = enabled;
        test::Testbench tb(5, cfg);
        buildLine(tb, 5);
        tb.runUntil(3.0);              // let hello establish neighbours
        tb.sendData(0, 4);
        tb.runUntil(10.0);

        if (enabled) {
            CHECK(tb.dataDelivered > 0);  // reactive on: the line must be discovered and delivered
        } else {
            CHECK(tb.dataDelivered == 0);  // reactive off: no discovery, so nothing can be delivered
            // The data must be *held*, not silently dropped — the gate removes
            // discovery, not the pending queue.
            CHECK(tb.pending(0, 4) > 0);  // reactive off: the packet must still be queued
        }
    }
}

void testLinkFailGateKeepsPruning() {
    // With the gate off a dead neighbour must still be pruned locally — only
    // the outbound notification disappears. Pruning is correctness; the note
    // is an optimisation for everyone else.
    core::Config cfg = baseConfig();
    cfg.enableLinkFail = false;
    test::Testbench tb(3, cfg);
    buildLine(tb, 3);
    tb.runUntil(3.0);
    tb.sendData(0, 2);
    tb.runUntil(8.0);
    CHECK(tb.dataDelivered > 0);  // route must form with linkfail notes off

    const std::uint64_t before = tb.node(0).controlPacketsSent();
    tb.linkDown(0, 1);
    tb.runUntil(20.0);  // past allowedHelloLoss * helloInterval
    // Node 0 must have dropped 1 from its table (correctness half kept)...
    CHECK(tb.node(0).table().bestRegular(2) <= cfg.minPheromone);  // the dead neighbour's routes must still be pruned
    // ...without emitting a LinkFail note for it.
    CHECK(tb.node(0).antsSent(core::AntType::LinkFail) == 0);  // linkfail off: no notification may be originated
    (void) before;
}

void testRepairGateSuppressesRepairAnts() {
    for (bool enabled : {true, false}) {
        core::Config cfg = baseConfig();
        cfg.enableRepair = enabled;
        // Detector D debounces at txFailureThreshold consecutive failures
        // (#19); this test is about the gate, not the debounce, so make one
        // failed unicast enough.
        cfg.txFailureThreshold = 1;
        test::Testbench tb(4, cfg);
        buildLine(tb, 4);
        tb.runUntil(3.0);
        tb.sendData(0, 3);
        tb.runUntil(8.0);
        tb.linkDown(1, 2);           // break the middle of an active path
        tb.sendData(0, 3);
        tb.runUntil(25.0);

        const std::uint64_t repairs =
            tb.node(0).antsSent(core::AntType::Repair) +
            tb.node(1).antsSent(core::AntType::Repair);
        if (enabled) {
            CHECK(repairs > 0);  // repair on: a broken active path must launch a repair ant
        } else {
            CHECK(repairs == 0);  // repair off: no repair ant may be launched
        }
    }
}

// --- 2. directed reactive discovery -----------------------------------------

// TWO PRECONDITIONS, both found by this test failing first.
//
// 1. Diffusion advertises only destinations a node already has pheromone for.
//    On a *cold* first discovery nobody knows the destination, so the virtual
//    table is empty and a directed ant floods exactly as an undirected one
//    would. Directed reactive discovery is therefore a **reconvergence /
//    known-destination** optimisation, not a cold-start one — the scenario
//    below establishes a gradient first, which is also the realistic case
//    (a destination other sessions already reach).
//
// 2. Adverts ride hellos only when enableProactive is also on
//    (ant_router_logic.cpp, "Diffusion adverts are gated (ADR-0007)"). So the
//    directed cases re-enable proactive, unlike the gate cases above.
void testDirectedReactiveEngagesAndStillDelivers() {
    core::Config cfg = baseConfig();
    cfg.enableProactive = true;
    cfg.enableDiffusion = true;
    cfg.enableDirectedReactive = true;

    test::Testbench tb(6, cfg);
    buildLine(tb, 6);
    tb.runUntil(3.0);
    // Node 4 reaches 5 (its direct neighbour), so pheromone for destination 5
    // exists somewhere; hello diffusion then walks that knowledge back down the
    // line, one hop per helloInterval.
    tb.sendData(4, 5);
    tb.runUntil(18.0);
    // Now a *distant* node discovers the same destination. Its regular table is
    // still empty for 5, but the diffused virtual table is not.
    tb.sendData(0, 5);
    tb.runUntil(30.0);

    std::uint64_t steers = 0;
    for (int i = 0; i < 6; ++i) steers += tb.node(i).directedSteers();

    CHECK(steers > 0);  // the diffusion gradient must steer at least one ant
    CHECK(tb.dataDelivered > 0);  // and steering must still reach the destination
}

void testDirectedReactiveOffLeavesNoSteers() {
    core::Config cfg = baseConfig();
    cfg.enableProactive = true;
    cfg.enableDiffusion = true;
    cfg.enableDirectedReactive = false;   // the shipped default

    test::Testbench tb(6, cfg);
    buildLine(tb, 6);
    tb.runUntil(3.0);
    tb.sendData(4, 5);          // same gradient-establishing shape as above
    tb.runUntil(18.0);
    tb.sendData(0, 5);
    tb.runUntil(30.0);

    std::uint64_t steers = 0;
    for (int i = 0; i < 6; ++i) steers += tb.node(i).directedSteers();
    CHECK(steers == 0);  // default off: no ant may be steered
    CHECK(tb.dataDelivered > 0);  // default path must still deliver
}

}  // namespace

int main() {
    testReactiveGateSuppressesDiscovery();
    testLinkFailGateKeepsPruning();
    testRepairGateSuppressesRepairAnts();
    testDirectedReactiveEngagesAndStillDelivers();
    testDirectedReactiveOffLeavesNoSteers();
    return RUN_TESTS();
}
