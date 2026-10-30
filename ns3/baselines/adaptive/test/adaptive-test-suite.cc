// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/**
 * Unit tests for the adaptive comparator module (#563): the pheromone table's
 * two decay laws, the proportional draw, Termite's forwarding weight, the
 * Q-routing update and the control header's round trip; BeeAdHoc's route
 * rating, forager store and packet formats (#589). Every expected value is
 * hand-computed from the stated formula, never from the code under test.
 */

#include "ns3/adaptive-packet.h"
#include "ns3/adaptive-tables.h"
#include "ns3/beeadhoc-routing-protocol.h"
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

class BeeRatingTest : public TestCase {
public:
    BeeRatingTest() : TestCase("BeeAdHoc route rating (PG 460 Listing 13.15)") {}

private:
    void DoRun() override {
        // ((maxHops - (hops - 1)) * min * avg + 1) / 44, integer, capped at 8.
        NS_TEST_ASSERT_MSG_EQ(BeeDances(1, {}, 10, 8), 8u, "direct neighbour: maximum");
        NS_TEST_ASSERT_MSG_EQ(BeeDances(2, {7}, 10, 8), 8u, "(9*49+1)/44 = 10, capped at 8");
        NS_TEST_ASSERT_MSG_EQ(BeeDances(3, {7, 7}, 10, 8), 8u, "(8*49+1)/44 = 8");
        NS_TEST_ASSERT_MSG_EQ(BeeDances(5, {7, 7, 7, 7}, 10, 8), 6u, "(6*49+1)/44 = 6");
        NS_TEST_ASSERT_MSG_EQ(BeeDances(10, std::vector<uint8_t>(9, 7), 10, 8), 1u,
                              "(1*49+1)/44 = 1");
        NS_TEST_ASSERT_MSG_EQ(BeeDances(4, {7, 3, 5}, 10, 8), 2u, "min 3, avg 5: 106/44 = 2");
        NS_TEST_ASSERT_MSG_EQ(BeeDances(4, {7, 0, 7}, 10, 8), 0u, "an empty battery: 1/44 = 0");
        NS_TEST_ASSERT_MSG_EQ(BeeDances(12, std::vector<uint8_t>(11, 7), 10, 8), 0u,
                              "longer than MaxHops");
    }
};

class ForagerStoreTest : public TestCase {
public:
    ForagerStoreTest() : TestCase("BeeAdHoc forager store (PG 460 Listings 13.16, 13.17)") {}

private:
    typedef ForagerStore<int>::Forager F;

    static F Route(std::vector<int> path) {
        F f;
        f.path = path;
        f.levels.assign(path.size() > 2 ? path.size() - 2 : 0, 7);
        return f;
    }

    void DoRun() override {
        auto first = [](uint32_t) { return 0u; };
        ForagerStore<int> s;
        s.Configure(3, 2.0, 2.0, 10, 8);
        F out;

        NS_TEST_ASSERT_MSG_EQ(s.Put(9, Route({1}), false, 0.0), false, "a route needs two nodes");
        NS_TEST_ASSERT_MSG_EQ(s.Take(9, 0.0, first, out), false, "nothing stored");

        // A dancing forager is copied; an old one is used up, kept if last.
        s.Put(9, Route({1, 9}), false, 0.0);
        NS_TEST_ASSERT_MSG_EQ(s.Take(9, 1.0, first, out), true, "dancing");
        NS_TEST_ASSERT_MSG_EQ(out.dances, 7u, "one of its 8 dances spent");
        NS_TEST_ASSERT_MSG_EQ(s.Count(9, false), 1u, "a dance copies the forager");
        NS_TEST_ASSERT_MSG_EQ(s.Take(9, 2.5, first, out), true, "past the dance time");
        NS_TEST_ASSERT_MSG_EQ(s.Count(9, false), 0u, "used up");
        NS_TEST_ASSERT_MSG_EQ(s.Take(9, 2.5, first, out), false, "none left");

        // Past the lifetime: discarded unless it is the last one.
        s.Put(9, Route({1, 5, 9}), false, 0.0);
        s.Put(9, Route({1, 6, 9}), false, 0.0);
        NS_TEST_ASSERT_MSG_EQ(s.Take(9, 3.0, first, out), true, "the last is kept");
        NS_TEST_ASSERT_MSG_EQ(out.path[1], 6, "the expired first draw was discarded");
        NS_TEST_ASSERT_MSG_EQ(s.Count(9, false), 0u, "both gone");

        // Own before foreign (§13.7.1).
        s.Put(9, Route({1, 7, 9}), true, 0.0);
        s.Put(9, Route({1, 5, 9}), false, 0.0);
        NS_TEST_ASSERT_MSG_EQ(s.Take(9, 0.5, first, out), true, "a forager");
        NS_TEST_ASSERT_MSG_EQ(out.path[1], 5, "own first");

        // Bounded arrays, a swarm's cargo, a failed link.
        s.Put(9, Route({1, 8, 9}), true, 0.0);
        s.Put(9, Route({1, 4, 9}), true, 0.0);
        NS_TEST_ASSERT_MSG_EQ(s.Put(9, Route({1, 3, 9}), true, 0.0), false, "array full");
        NS_TEST_ASSERT_MSG_EQ(s.Count(9, true), 3u, "three foreign");
        NS_TEST_ASSERT_MSG_EQ(s.TakeForeign(9, 2).size(), 2u, "a swarm takes two");
        NS_TEST_ASSERT_MSG_EQ(s.Count(9, true), 1u, "one foreign left");
        NS_TEST_ASSERT_MSG_EQ(s.FirstHops().count(5), 1u, "neighbour 5 known");
        s.RemoveLink(1, 5);
        NS_TEST_ASSERT_MSG_EQ(s.Count(9, false), 0u, "the route over 1->5 is gone");
        NS_TEST_ASSERT_MSG_EQ(s.FirstHops().count(5), 0u, "neighbour 5 forgotten");
    }
};

class BeePacketTest : public TestCase {
public:
    BeePacketTest() : TestCase("BeeAdHoc source route trailer and control header") {}

private:
    void DoRun() override {
        const Ipv4Address a("10.1.0.1");
        const Ipv4Address b("10.1.0.2");
        const Ipv4Address c("10.1.0.3");

        BeeRouteTrailer t;
        t.path = {a, b, c};
        t.info = 0x123456;
        t.piggy = {c, b};
        t.piggyInfo = 7;
        Ptr<Packet> p = Create<Packet>(10);
        p->AddTrailer(t);
        // 3 * 4 + 3 + 2 * 4 + 3 + 2 = 28 bytes after the 10-byte payload.
        NS_TEST_ASSERT_MSG_EQ(p->GetSize(), 38u, "trailer bytes on the wire");
        BeeRouteTrailer r;
        p->RemoveTrailer(r);
        NS_TEST_ASSERT_MSG_EQ(p->GetSize(), 10u, "payload restored");
        NS_TEST_ASSERT_MSG_EQ(r.path.size(), 3u, "path length");
        NS_TEST_ASSERT_MSG_EQ(r.path[1], b, "path order");
        NS_TEST_ASSERT_MSG_EQ(r.info, 0x123456u, "info");
        NS_TEST_ASSERT_MSG_EQ(r.piggy.size(), 2u, "piggy length");
        NS_TEST_ASSERT_MSG_EQ(r.piggy[0], c, "piggy order");
        NS_TEST_ASSERT_MSG_EQ(r.piggyInfo, 7u, "piggy info");

        BeeControlHeader h;
        h.type = BeeControlHeader::SWARM;
        h.ttl = 4;
        h.id = 0xcafe;
        h.src = c;
        h.dst = a;
        h.path = {c, a};
        h.levels = {5};
        h.cargo.push_back({{c, b, a}, {6}});
        Ptr<Packet> q = Create<Packet>();
        q->AddHeader(h);
        // 14 fixed + (1 + 8) path + (1 + 1) levels + 1 count + (1 + 12 + 1 + 1) cargo
        NS_TEST_ASSERT_MSG_EQ(q->GetSize(), 41u, "control bytes on the wire");
        BeeControlHeader g;
        q->RemoveHeader(g);
        NS_TEST_ASSERT_MSG_EQ(unsigned(g.type), unsigned(BeeControlHeader::SWARM), "type");
        NS_TEST_ASSERT_MSG_EQ(unsigned(g.ttl), 4u, "ttl");
        NS_TEST_ASSERT_MSG_EQ(g.id, 0xcafeu, "id");
        NS_TEST_ASSERT_MSG_EQ(g.src, c, "src");
        NS_TEST_ASSERT_MSG_EQ(g.dst, a, "dst");
        NS_TEST_ASSERT_MSG_EQ(g.path.size(), 2u, "path");
        NS_TEST_ASSERT_MSG_EQ(unsigned(g.levels[0]), 5u, "levels");
        NS_TEST_ASSERT_MSG_EQ(g.cargo.size(), 1u, "cargo");
        NS_TEST_ASSERT_MSG_EQ(g.cargo[0].path[1], b, "cargo path");
        NS_TEST_ASSERT_MSG_EQ(unsigned(g.cargo[0].levels[0]), 6u, "cargo levels");
    }
};

class AdaptiveTestSuite : public TestSuite {
public:
    AdaptiveTestSuite() : TestSuite("adaptive", ADAPTIVE_TEST_TYPE_UNIT) {
        AddTestCase(new PheromoneDecayTest, ADAPTIVE_TEST_QUICK);
        AddTestCase(new BoundedTableTest, ADAPTIVE_TEST_QUICK);
        AddTestCase(new SelectionTest, ADAPTIVE_TEST_QUICK);
        AddTestCase(new HeaderTest, ADAPTIVE_TEST_QUICK);
        AddTestCase(new BeeRatingTest, ADAPTIVE_TEST_QUICK);
        AddTestCase(new ForagerStoreTest, ADAPTIVE_TEST_QUICK);
        AddTestCase(new BeePacketTest, ADAPTIVE_TEST_QUICK);
    }
};

static AdaptiveTestSuite g_adaptiveTestSuite;

}  // namespace adaptive
}  // namespace ns3
