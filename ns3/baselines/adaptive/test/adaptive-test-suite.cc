// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/**
 * Unit tests for the adaptive comparator module (#563): the pheromone table's
 * two decay laws, the proportional draw, Termite's forwarding weight, the
 * Q-routing update and the control header's round trip. Every expected value
 * is hand-computed from the stated formula, never from the code under test.
 */

#include "ns3/adaptive-packet.h"
#include "ns3/adaptive-tables.h"
#include "ns3/packet.h"
#include "ns3/test.h"

#include <cmath>

// TestSuite/TestCase enums became scoped (enum class) in ns-3.42 and the
// unscoped aliases were removed in ns-3.47 (the oracle module's pattern).
#ifdef ADAPTIVE_NS3_SCOPED_TEST_ENUMS
#define ADAPTIVE_TEST_TYPE_UNIT TestSuite::Type::UNIT
#define ADAPTIVE_TEST_QUICK TestCase::Duration::QUICK
#else
#define ADAPTIVE_TEST_TYPE_UNIT UNIT
#define ADAPTIVE_TEST_QUICK TestCase::QUICK
#endif

namespace ns3 {
namespace adaptive {

class PheromoneDecayTest : public TestCase {
public:
    PheromoneDecayTest()
        : TestCase("pheromone table: ARA geometric and Termite exponential decay") {}

private:
    void DoRun() override {
        // ARA eq. 2 with q = 0.1 per 1 s: 1.0 -> 0.9 after 1 s, 0.81 after 2 s,
        // 0.9^0.5 = 0.948683 after half a period.
        PheromoneTable<int> ara;
        ara.Configure(PheromoneTable<int>::Decay::Geometric, 0.1, 1.0, 0.01);
        ara.Add(7, 1, 1.0, 0.0);
        NS_TEST_ASSERT_MSG_EQ_TOL(ara.Get(7, 1, 0.5), 0.948683, 1e-6, "half period");
        NS_TEST_ASSERT_MSG_EQ_TOL(ara.Get(7, 1, 2.0), 0.81, 1e-9, "two periods");
        // Deposits add on the decayed value: 0.81 + 0.1 = 0.91 at t = 2.
        ara.Add(7, 1, 0.1, 2.0);
        NS_TEST_ASSERT_MSG_EQ_TOL(ara.Get(7, 1, 2.0), 0.91, 1e-9, "deposit");
        // Below the floor the trail is gone: 0.91 * 0.9^dt < 0.01 for
        // dt > ln(0.01/0.91)/ln(0.9) = 42.81 s, i.e. after t = 44.81 s.
        NS_TEST_ASSERT_MSG_EQ(ara.HasRoute(7, 44.5), true, "alive at 44.5 s");
        NS_TEST_ASSERT_MSG_EQ(ara.HasRoute(7, 45.0), false, "evaporated at 45 s");
        NS_TEST_ASSERT_MSG_EQ(ara.Size(), 0u, "pruned on read");

        // Termite: P e^{-tau dt}, tau = 1/s: 2.0 -> 2 e^{-1.5} = 0.446260.
        PheromoneTable<int> termite;
        termite.Configure(PheromoneTable<int>::Decay::Exponential, 1.0, 1.0, 1e-9);
        termite.Add(3, 2, 2.0, 10.0);
        NS_TEST_ASSERT_MSG_EQ_TOL(termite.Get(3, 2, 11.5), 0.446260, 1e-6, "exponential");

        // A discovery ant never lowers a trail; it raises a weaker one.
        termite.SetAtLeast(3, 2, 0.1, 11.5);
        NS_TEST_ASSERT_MSG_EQ_TOL(termite.Get(3, 2, 11.5), 0.446260, 1e-6, "not lowered");
        termite.SetAtLeast(3, 2, 0.9, 11.5);
        NS_TEST_ASSERT_MSG_EQ_TOL(termite.Get(3, 2, 11.5), 0.9, 1e-12, "raised");

        // A lost neighbour leaves every destination's row.
        termite.Add(4, 2, 1.0, 11.5);
        termite.Add(4, 5, 1.0, 11.5);
        termite.EraseNeighbor(2);
        NS_TEST_ASSERT_MSG_EQ(termite.Neighbors().count(2), 0u, "neighbour erased");
        NS_TEST_ASSERT_MSG_EQ(termite.Neighbors().count(5), 1u, "others kept");
    }
};

class BoundedTableTest : public TestCase {
public:
    BoundedTableTest() : TestCase("Termite bounded table: initial, floor, ceiling, pruning") {}

private:
    void DoRun() override {
        // Table 4.1: tau = 0.105, initial 1, floor 0.1, ceiling 10000.
        BoundedPheromoneTable<int> t;
        t.Configure(0.105, 1.0, 0.1, 10000.0);
        // A packet from source 9 over neighbour 2: new row and column at the
        // initial value, then gamma = 1 on (9, 2) -> 2.
        t.Deposit(9, 2, 1.0, 0.0);
        NS_TEST_ASSERT_MSG_EQ_TOL(t.Get(9, 2, 0.0), 2.0, 1e-12, "initial + gamma");
        // A second neighbour joins: its cell for the known destination starts
        // at the initial value.
        t.AddNeighbor(3, 0.0);
        NS_TEST_ASSERT_MSG_EQ_TOL(t.Get(9, 3, 0.0), 1.0, 1e-12, "new row at initial");
        // 2 e^{-0.105 * 10} = 2 e^{-1.05} = 0.699875.
        NS_TEST_ASSERT_MSG_EQ_TOL(t.Get(9, 2, 10.0), 0.699875, 1e-6, "decay");
        // 1 e^{-0.105 * 30} = 0.0429 < 0.1: held at the floor.
        NS_TEST_ASSERT_MSG_EQ_TOL(t.Get(9, 3, 30.0), 0.1, 1e-12, "floor");
        // The ceiling caps a deposit.
        t.Deposit(9, 3, 1e6, 30.0);
        NS_TEST_ASSERT_MSG_EQ_TOL(t.Get(9, 3, 30.0), 10000.0, 1e-9, "ceiling");
        // At t = 300 every cell is at the floor: neighbour 2 (row decayed) is
        // pruned; 3 too; destination 9 then goes once no neighbour holds it.
        auto gone = t.Prune(300.0);
        NS_TEST_ASSERT_MSG_EQ(gone.size(), 2u, "both rows decayed");
        NS_TEST_ASSERT_MSG_EQ(t.HasNeighbor(2), false, "row 2 removed");
        t.Prune(301.0);
        NS_TEST_ASSERT_MSG_EQ(t.HasDestination(9), false, "column 9 removed");
        // A lost link removes the row at once.
        t.Deposit(5, 4, 1.0, 400.0);
        t.RemoveNeighbor(4);
        NS_TEST_ASSERT_MSG_EQ(t.HasNeighbor(4), false, "link loss");
    }
};

class SelectionTest : public TestCase {
public:
    SelectionTest() : TestCase("proportional draw, Termite weight, Q-routing update") {}

private:
    void DoRun() override {
        // Weights 1, 3: the cumulative split is [0, 0.25) -> 0, [0.25, 1) -> 1.
        const std::vector<double> w{1.0, 3.0};
        NS_TEST_ASSERT_MSG_EQ(PickProportional(w, 0.0), 0, "lower edge");
        NS_TEST_ASSERT_MSG_EQ(PickProportional(w, 0.2499), 0, "below the split");
        NS_TEST_ASSERT_MSG_EQ(PickProportional(w, 0.25), 1, "at the split");
        NS_TEST_ASSERT_MSG_EQ(PickProportional(w, 0.999999), 1, "upper edge");
        NS_TEST_ASSERT_MSG_EQ(PickProportional({0.0, 0.0}, 0.5), -1, "no weight");
        NS_TEST_ASSERT_MSG_EQ(PickProportional({0.0, 2.0, 0.0}, 0.0), 1, "zeros skipped");

        // (P + K)^F: (0.5 + 0.1)^2 = 0.36; F = 0 makes every neighbour equal.
        NS_TEST_ASSERT_MSG_EQ_TOL(TermiteWeight(0.5, 0.1, 2.0), 0.36, 1e-12, "weight");
        NS_TEST_ASSERT_MSG_EQ_TOL(TermiteWeight(7.0, 0.0, 0.0), 1.0, 1e-12, "F = 0");

        // Q + eta (q + s + t - Q): 1.0 + 0.5 (0.002 + 0.003 + 0.4 - 1.0) = 0.7025.
        NS_TEST_ASSERT_MSG_EQ_TOL(QUpdate(1.0, 0.5, 0.002, 0.003, 0.4), 0.7025, 1e-12, "update");
        // eta = 1 replaces the estimate outright; eta = 0 never learns.
        NS_TEST_ASSERT_MSG_EQ_TOL(QUpdate(1.0, 1.0, 0.0, 0.01, 0.2), 0.21, 1e-12, "eta 1");
        NS_TEST_ASSERT_MSG_EQ_TOL(QUpdate(1.0, 0.0, 0.0, 0.01, 0.2), 1.0, 1e-12, "eta 0");
    }
};

class HeaderTest : public TestCase {
public:
    HeaderTest() : TestCase("control header round trip") {}

private:
    void DoRun() override {
        ControlHeader h;
        h.type = TERMITE_RREQ;
        h.hops = 9;
        h.ttl = 55;
        h.flags = 0xa5;
        h.seq = 0xdeadbeef;
        h.origin = Ipv4Address("10.1.0.3");
        h.target = Ipv4Address("10.1.0.14");
        h.value = 0.0123456789;
        Ptr<Packet> p = Create<Packet>();
        p->AddHeader(h);
        NS_TEST_ASSERT_MSG_EQ(p->GetSize(), 24u, "24 bytes on the wire");
        ControlHeader r;
        p->RemoveHeader(r);
        NS_TEST_ASSERT_MSG_EQ(unsigned(r.type), unsigned(TERMITE_RREQ), "type");
        NS_TEST_ASSERT_MSG_EQ(unsigned(r.hops), 9u, "hops");
        NS_TEST_ASSERT_MSG_EQ(unsigned(r.ttl), 55u, "ttl");
        NS_TEST_ASSERT_MSG_EQ(unsigned(r.flags), 0xa5u, "flags");
        NS_TEST_ASSERT_MSG_EQ(r.seq, 0xdeadbeefu, "seq");
        NS_TEST_ASSERT_MSG_EQ(r.origin, Ipv4Address("10.1.0.3"), "origin");
        NS_TEST_ASSERT_MSG_EQ(r.target, Ipv4Address("10.1.0.14"), "target");
        NS_TEST_ASSERT_MSG_EQ(r.value, 0.0123456789, "value bit-exact");
    }
};

class AdaptiveTestSuite : public TestSuite {
public:
    AdaptiveTestSuite() : TestSuite("adaptive", ADAPTIVE_TEST_TYPE_UNIT) {
        AddTestCase(new PheromoneDecayTest, ADAPTIVE_TEST_QUICK);
        AddTestCase(new BoundedTableTest, ADAPTIVE_TEST_QUICK);
        AddTestCase(new SelectionTest, ADAPTIVE_TEST_QUICK);
        AddTestCase(new HeaderTest, ADAPTIVE_TEST_QUICK);
    }
};

static AdaptiveTestSuite g_adaptiveTestSuite;

}  // namespace adaptive
}  // namespace ns3
