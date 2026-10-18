// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/*
 * NS-3 test suite for AntHocNet:
 *   1. AntHeader serialize/deserialize round-trip (the riskiest adapter seam).
 *   2. A deterministic multi-hop delivery test over SimpleNetDevices (no wifi
 *      randomness): a 3-node line 0-1-2 with the 0<->2 link black-listed, so a
 *      packet from 0 to 2 must be routed through 1. This guards the actual
 *      routing path (hello, neighbour learning, reactive discovery, forwarding
 *      and delivery), not just packet encoding.
 */
#include "ns3/test.h"
#include "ns3/packet.h"
#include "ns3/simulator.h"
#include "ns3/rng-seed-manager.h"
#include "ns3/node-container.h"
#include "ns3/simple-net-device.h"
#include "ns3/simple-channel.h"
#include "ns3/simple-net-device-helper.h"
#include "ns3/internet-stack-helper.h"
#include "ns3/ipv4-address-helper.h"
#include "ns3/socket.h"
#include "ns3/udp-socket-factory.h"
#include "ns3/inet-socket-address.h"

#include "ns3/wifi-helper.h"
#include "ns3/yans-wifi-helper.h"
#include "ns3/wifi-mac-helper.h"
#include "ns3/mobility-helper.h"
#include "ns3/mobility-model.h"
#include "ns3/constant-position-mobility-model.h"
#include "ns3/position-allocator.h"
#include "ns3/vector.h"
#include "ns3/double.h"
#include "ns3/data-rate.h"
#include "ns3/ipv4.h"
#include "ns3/ipv4-l3-protocol.h"
#include "ns3/uinteger.h"

#include "ns3/anthocnet-packet.h"
#include "anthocnet/core/ant_message_codec.h"
#include "ns3/anthocnet-helper.h"
#include "ns3/anthocnet-routing-protocol.h"

using namespace ns3;
using ::anthocnet::core::AntDirection;
using ::anthocnet::core::AntMessage;
using ::anthocnet::core::AntType;

class AntHeaderRoundTripTestCase : public TestCase {
public:
    AntHeaderRoundTripTestCase() : TestCase("AntHeader serialize/deserialize round-trip") {}

    void DoRun() override {
        AntMessage m;
        m.type = AntType::Proactive;
        m.direction = AntDirection::Down;
        m.src = 3;
        m.dst = 17;
        m.seqNum = 70000;  // > 16 bits
        m.timeStart = 1.25;
        m.lifeAnt = 2.0;
        m.broadcastBudget = 2;
        m.visited = {{3, 0.0}, {4, 0.01}, {7, 0.02}};
        m.history = {{17, 0.05}};
        m.helloDests = {{8, 1.0}, {9, 0.5}};

        Ptr<Packet> packet = Create<Packet>();
        ns3::anthocnet::AntHeader out(m);
        packet->AddHeader(out);

        ns3::anthocnet::AntHeader in;
        packet->RemoveHeader(in);
        const AntMessage& r = in.Message();

        NS_TEST_ASSERT_MSG_EQ(static_cast<int>(r.type), static_cast<int>(AntType::Proactive),
                              "type");
        NS_TEST_ASSERT_MSG_EQ(static_cast<int>(r.direction), static_cast<int>(AntDirection::Down),
                              "direction");
        NS_TEST_ASSERT_MSG_EQ(r.src, 3, "src");
        NS_TEST_ASSERT_MSG_EQ(r.dst, 17, "dst");
        NS_TEST_ASSERT_MSG_EQ(r.seqNum, 70000u, "seqNum");
        NS_TEST_ASSERT_MSG_EQ_TOL(r.timeStart, 1.25, 1e-9, "timeStart");
        NS_TEST_ASSERT_MSG_EQ(r.broadcastBudget, 2, "broadcastBudget");
        NS_TEST_ASSERT_MSG_EQ(r.visited.size(), 3u, "visited size");
        NS_TEST_ASSERT_MSG_EQ(r.visited[2].node, 7, "visited node");
        NS_TEST_ASSERT_MSG_EQ_TOL(r.visited[1].time, 0.01, 1e-9, "visited time");
        NS_TEST_ASSERT_MSG_EQ(r.history.size(), 1u, "history size");
        NS_TEST_ASSERT_MSG_EQ(r.helloDests.size(), 2u, "hello size");
        NS_TEST_ASSERT_MSG_EQ(r.helloDests[1].node, 9, "hello node");
        NS_TEST_ASSERT_MSG_EQ_TOL(r.helloDests[1].pheromone, 0.5, 1e-9, "hello ph");
    }
};

// ADR-0025 (#573): the hello's optional kinematics section survives the ns-3
// header, a hello without it decodes as absent, and the header length moves
// by exactly the section's 25 bytes.
class AntHeaderKinematicsTestCase : public TestCase {
public:
    AntHeaderKinematicsTestCase()
        : TestCase("AntHeader carries the optional hello kinematics section") {}

    void DoRun() override {
        AntMessage m;
        m.type = AntType::Hello;
        m.direction = ::anthocnet::core::AntDirection::Up;
        m.src = 4;
        m.helloDests = {{8, 1.0}};
        const uint32_t plain = ns3::anthocnet::AntHeader(m).GetSerializedSize();

        m.hasKinematics = true;
        m.kinematics = ::anthocnet::core::Kinematics{1250.5, -300.25, 0.0, 20.0, -7.5, 0.0};
        ns3::anthocnet::AntHeader out(m);
        NS_TEST_ASSERT_MSG_EQ(out.GetSerializedSize(),
                              plain + ::anthocnet::core::codec::kKinematicsSize, "section size");
        Ptr<Packet> packet = Create<Packet>();
        packet->AddHeader(out);
        ns3::anthocnet::AntHeader in;
        packet->RemoveHeader(in);
        const AntMessage& r = in.Message();
        NS_TEST_ASSERT_MSG_EQ(r.hasKinematics, true, "section present");
        NS_TEST_ASSERT_MSG_EQ_TOL(r.kinematics.x, 1250.5, 1e-3, "x");
        NS_TEST_ASSERT_MSG_EQ_TOL(r.kinematics.vy, -7.5, 1e-6, "vy");
        NS_TEST_ASSERT_MSG_EQ(r.helloDests.size(), 1u, "adverts intact");

        m.hasKinematics = false;
        Ptr<Packet> bare = Create<Packet>();
        bare->AddHeader(ns3::anthocnet::AntHeader(m));
        ns3::anthocnet::AntHeader in2;
        bare->RemoveHeader(in2);
        NS_TEST_ASSERT_MSG_EQ(in2.Message().hasKinematics, false, "absent, not the origin");
    }
};

// Deterministic multi-hop delivery over SimpleNetDevices.
class AntHocNetDeliveryTestCase : public TestCase {
public:
    AntHocNetDeliveryTestCase() : TestCase("Multi-hop delivery over a 3-node line"), m_rxBytes(0) {}

    void DoRun() override {
        RngSeedManager::SetSeed(1);
        RngSeedManager::SetRun(1);

        NodeContainer nodes;
        nodes.Create(3);

        // Shared SimpleChannel; black-list the 0<->2 link so 0 and 2 are not
        // direct neighbours and traffic must traverse node 1.
        Ptr<SimpleChannel> channel = CreateObject<SimpleChannel>();
        SimpleNetDeviceHelper devHelper;
        NetDeviceContainer devices = devHelper.Install(nodes, channel);
        Ptr<SimpleNetDevice> d0 = DynamicCast<SimpleNetDevice>(devices.Get(0));
        Ptr<SimpleNetDevice> d2 = DynamicCast<SimpleNetDevice>(devices.Get(2));
        channel->BlackList(d0, d2);
        channel->BlackList(d2, d0);

        AntHocNetHelper anthocnet;
        InternetStackHelper internet;
        internet.SetRoutingHelper(anthocnet);
        internet.Install(nodes);

        Ipv4AddressHelper address;
        address.SetBase("10.1.0.0", "255.255.255.0");
        Ipv4InterfaceContainer ifs = address.Assign(devices);

        const uint16_t port = 9;

        // Receiver on node 2 counts bytes.
        Ptr<Socket> rx = Socket::CreateSocket(nodes.Get(2), UdpSocketFactory::GetTypeId());
        rx->Bind(InetSocketAddress(Ipv4Address::GetAny(), port));
        rx->SetRecvCallback(MakeCallback(&AntHocNetDeliveryTestCase::Receive, this));

        // Sender on node 0 -> node 2, after routes have a chance to form.
        Ptr<Socket> tx = Socket::CreateSocket(nodes.Get(0), UdpSocketFactory::GetTypeId());
        tx->Connect(InetSocketAddress(ifs.GetAddress(2), port));
        for (double t = 10.0; t < 18.0; t += 0.5) {
            Simulator::Schedule(Seconds(t), &AntHocNetDeliveryTestCase::Send, this, tx);
        }

        Simulator::Stop(Seconds(20.0));
        Simulator::Run();
        Simulator::Destroy();

        NS_TEST_ASSERT_MSG_GT(m_rxBytes, 0u, "node 2 received no data over the 2-hop path");
    }

private:
    void Send(Ptr<Socket> s) { s->Send(Create<Packet>(64)); }
    void Receive(Ptr<Socket> s) {
        Ptr<Packet> p;
        while ((p = s->Recv())) m_rxBytes += p->GetSize();
    }
    uint32_t m_rxBytes;
};

// Issue #203 — delivery across a node with MORE THAN ONE interface.
//
// Same 3-node line as above, but built from two separate channels on two
// separate subnets, so the middle node has two interfaces:
//
//     0 (10.1.1.1) --- (10.1.1.2) 1 (10.1.2.1) --- (10.1.2.2) 2
//
// This is the satellite/ISL shape (#192, #194) and it fails before #203: the
// data path derived its output device from m_socketAddresses.begin(), so node 1
// forwarded packets for 10.1.2.2 back out of its 10.1.1.0/24 device, and
// backward ants unicast to a canonical address that is not on the link they
// were sent over.
class MultiInterfaceDeliveryTestCase : public TestCase {
public:
    MultiInterfaceDeliveryTestCase()
        : TestCase("Multi-hop delivery through a multi-interface node (#203)"), m_rxBytes(0) {}

    void DoRun() override {
        RngSeedManager::SetSeed(1);
        RngSeedManager::SetRun(1);

        NodeContainer nodes;
        nodes.Create(3);

        // Two point-to-point-style links, each its own channel: 0<->1 and 1<->2.
        // Node 1 therefore holds one device (and one subnet) per link, and 0 and
        // 2 share no medium at all.
        NodeContainer leftPair(nodes.Get(0), nodes.Get(1));
        NodeContainer rightPair(nodes.Get(1), nodes.Get(2));
        SimpleNetDeviceHelper devHelper;
        NetDeviceContainer leftDevs = devHelper.Install(leftPair, CreateObject<SimpleChannel>());
        NetDeviceContainer rightDevs = devHelper.Install(rightPair, CreateObject<SimpleChannel>());

        AntHocNetHelper anthocnet;
        InternetStackHelper internet;
        internet.SetRoutingHelper(anthocnet);
        internet.Install(nodes);

        Ipv4AddressHelper address;
        address.SetBase("10.1.1.0", "255.255.255.0");
        Ipv4InterfaceContainer leftIfs = address.Assign(leftDevs);
        address.SetBase("10.1.2.0", "255.255.255.0");
        Ipv4InterfaceContainer rightIfs = address.Assign(rightDevs);

        const uint16_t port = 9;

        Ptr<Socket> rx = Socket::CreateSocket(nodes.Get(2), UdpSocketFactory::GetTypeId());
        rx->Bind(InetSocketAddress(Ipv4Address::GetAny(), port));
        rx->SetRecvCallback(MakeCallback(&MultiInterfaceDeliveryTestCase::Receive, this));

        // Node 0 -> node 2's address, which lives on the far subnet and is only
        // reachable through node 1's second interface.
        Ptr<Socket> tx = Socket::CreateSocket(nodes.Get(0), UdpSocketFactory::GetTypeId());
        tx->Connect(InetSocketAddress(rightIfs.GetAddress(1), port));
        for (double t = 10.0; t < 18.0; t += 0.5) {
            Simulator::Schedule(Seconds(t), &MultiInterfaceDeliveryTestCase::Send, this, tx);
        }

        Simulator::Stop(Seconds(20.0));
        Simulator::Run();
        Simulator::Destroy();

        NS_TEST_ASSERT_MSG_GT(m_rxBytes, 0u,
                              "node 2 received no data across the multi-interface relay");
    }

private:
    void Send(Ptr<Socket> s) { s->Send(Create<Packet>(64)); }
    void Receive(Ptr<Socket> s) {
        Ptr<Packet> p;
        while ((p = s->Recv())) m_rxBytes += p->GetSize();
    }
    uint32_t m_rxBytes;
};

// #204 — hellos on point-to-point links every N ticks, liveness from the up
// interface in between.
//
// The #203 relay with both links in point-to-point mode. Run once sending a
// hello every tick (P2pHelloEvery=1) and once every 5th tick: delivery must
// hold in both (the peer map #203 needs is learned from the hellos still sent,
// and no neighbour expires between them), and the relay must transmit fewer
// packets with the throttle.
class P2pHelloThrottleTestCase : public TestCase {
public:
    P2pHelloThrottleTestCase()
        : TestCase("Point-to-point hello throttle keeps delivery, sends less (#204)") {}

    void DoRun() override {
        uint32_t rx1 = 0, rx5 = 0, tx1 = 0, tx5 = 0;
        RunOnce(1, rx1, tx1);
        RunOnce(5, rx5, tx5);
        NS_TEST_ASSERT_MSG_GT(rx1, 0u, "no delivery with a hello every tick");
        NS_TEST_ASSERT_MSG_GT(rx5, 0u, "no delivery with a hello every 5th tick");
        NS_TEST_ASSERT_MSG_EQ(rx5, rx1, "the throttle lost data on a stable line");
        NS_TEST_ASSERT_MSG_LT(tx5, tx1, "the throttle did not reduce the relay's transmissions");
    }

private:
    void RunOnce(uint32_t every, uint32_t& rxBytes, uint32_t& relayTx) {
        RngSeedManager::SetSeed(1);
        RngSeedManager::SetRun(1);
        m_rx = 0;
        m_tx = 0;
        NodeContainer nodes;
        nodes.Create(3);
        SimpleNetDeviceHelper devHelper;
        devHelper.SetNetDevicePointToPointMode(true);
        NetDeviceContainer leftDevs = devHelper.Install(NodeContainer(nodes.Get(0), nodes.Get(1)),
                                                        CreateObject<SimpleChannel>());
        NetDeviceContainer rightDevs = devHelper.Install(NodeContainer(nodes.Get(1), nodes.Get(2)),
                                                         CreateObject<SimpleChannel>());
        AntHocNetHelper anthocnet;
        anthocnet.Set("P2pHelloEvery", UintegerValue(every));
        InternetStackHelper internet;
        internet.SetRoutingHelper(anthocnet);
        internet.Install(nodes);
        Ipv4AddressHelper address;
        address.SetBase("10.1.1.0", "255.255.255.0");
        address.Assign(leftDevs);
        address.SetBase("10.1.2.0", "255.255.255.0");
        Ipv4InterfaceContainer rightIfs = address.Assign(rightDevs);
        nodes.Get(1)->GetObject<Ipv4L3Protocol>()->TraceConnectWithoutContext(
            "Tx", MakeCallback(&P2pHelloThrottleTestCase::CountTx, this));

        const uint16_t port = 9;
        Ptr<Socket> rx = Socket::CreateSocket(nodes.Get(2), UdpSocketFactory::GetTypeId());
        rx->Bind(InetSocketAddress(Ipv4Address::GetAny(), port));
        rx->SetRecvCallback(MakeCallback(&P2pHelloThrottleTestCase::Receive, this));
        Ptr<Socket> tx = Socket::CreateSocket(nodes.Get(0), UdpSocketFactory::GetTypeId());
        tx->Connect(InetSocketAddress(rightIfs.GetAddress(1), port));
        for (double t = 10.0; t < 28.0; t += 0.5) {
            Simulator::Schedule(Seconds(t), &P2pHelloThrottleTestCase::Send, tx);
        }
        Simulator::Stop(Seconds(30.0));
        Simulator::Run();
        Simulator::Destroy();
        rxBytes = m_rx;
        relayTx = m_tx;
    }
    static void Send(Ptr<Socket> s) { s->Send(Create<Packet>(64)); }
    void Receive(Ptr<Socket> s) {
        Ptr<Packet> p;
        while ((p = s->Recv())) m_rx += p->GetSize();
    }
    void CountTx(Ptr<const Packet>, Ptr<Ipv4>, uint32_t) { ++m_tx; }
    uint32_t m_rx = 0;
    uint32_t m_tx = 0;
};

// #641 — StrongestNextHop, the read-only query --vizTrace draws routes with.
//
// On a three-node point-to-point line the only route from node 0 to node 2 is
// through node 1, so once data has flowed the strongest next hop node 0 holds
// toward node 2 must be node 1's address on their shared link. Before the
// protocol starts, the query answers 0.0.0.0 rather than guessing.
class StrongestNextHopTestCase : public TestCase {
public:
    StrongestNextHopTestCase()
        : TestCase("StrongestNextHop names the route the pheromone holds (#641)") {}

    void DoRun() override {
        using ns3::anthocnet::RoutingProtocol;
        RngSeedManager::SetSeed(1);
        RngSeedManager::SetRun(1);
        NodeContainer nodes;
        nodes.Create(3);
        SimpleNetDeviceHelper devHelper;
        devHelper.SetNetDevicePointToPointMode(true);
        NetDeviceContainer leftDevs = devHelper.Install(NodeContainer(nodes.Get(0), nodes.Get(1)),
                                                        CreateObject<SimpleChannel>());
        NetDeviceContainer rightDevs = devHelper.Install(NodeContainer(nodes.Get(1), nodes.Get(2)),
                                                         CreateObject<SimpleChannel>());
        AntHocNetHelper anthocnet;
        InternetStackHelper internet;
        internet.SetRoutingHelper(anthocnet);
        internet.Install(nodes);
        Ipv4AddressHelper address;
        address.SetBase("10.1.1.0", "255.255.255.0");
        Ipv4InterfaceContainer leftIfs = address.Assign(leftDevs);
        address.SetBase("10.1.2.0", "255.255.255.0");
        Ipv4InterfaceContainer rightIfs = address.Assign(rightDevs);
        Ptr<RoutingProtocol> rp0 =
            DynamicCast<RoutingProtocol>(nodes.Get(0)->GetObject<Ipv4>()->GetRoutingProtocol());
        NS_TEST_ASSERT_MSG_NE(rp0, nullptr, "node 0 runs AntHocNet");
        const Ipv4Address dest = rightIfs.GetAddress(1);
        const Ipv4Address relay = leftIfs.GetAddress(1);  // read before Destroy
        NS_TEST_ASSERT_MSG_EQ(rp0->StrongestNextHop(dest), Ipv4Address(),
                              "a query before the protocol starts answers 0.0.0.0");

        const uint16_t port = 9;
        Ptr<Socket> rx = Socket::CreateSocket(nodes.Get(2), UdpSocketFactory::GetTypeId());
        rx->Bind(InetSocketAddress(Ipv4Address::GetAny(), port));
        Ptr<Socket> tx = Socket::CreateSocket(nodes.Get(0), UdpSocketFactory::GetTypeId());
        tx->Connect(InetSocketAddress(dest, port));
        for (double t = 5.0; t < 15.0; t += 0.5) {
            Simulator::Schedule(Seconds(t), &StrongestNextHopTestCase::Send, tx);
        }
        Ipv4Address seen;
        Simulator::Schedule(Seconds(15.0), [&]() { seen = rp0->StrongestNextHop(dest); });
        Simulator::Stop(Seconds(16.0));
        Simulator::Run();
        Simulator::Destroy();
        NS_TEST_ASSERT_MSG_EQ(seen, relay, "node 0's strongest next hop toward node 2 is node 1");
    }

private:
    static void Send(Ptr<Socket> s) { s->Send(Create<Packet>(64)); }
};

// #206 — the per-next-hop congestion signal on non-wifi devices.
//
// The same multi-interface relay shape as the #203 test (one SimpleNetDevice
// per link, so node 1 has one transmit queue per neighbour), with the relay's
// egress toward node 2 slowed to 32 kb/s so a data burst backlogs that queue
// while the queue toward node 0 stays idle. The ILinkState surface must then
// DISCRIMINATE: a positive backlog and a sampled service time toward the
// loaded next hop, (near-)nothing toward the idle one, and an aggregate at
// least as large as any single queue. A node-wide signal cannot pass this —
// it would read the same value for both hops, which is exactly the silent
// failure #206 exists to prevent.
class PerHopCongestionSignalTestCase : public TestCase {
public:
    PerHopCongestionSignalTestCase()
        : TestCase("Per-next-hop congestion signal on non-wifi devices (#206)"),
          m_qLoaded(0),
          m_qIdle(0),
          m_qAggregate(0),
          m_tLoaded(0.0),
          m_tIdle(0.0) {}

    void DoRun() override {
        using ns3::anthocnet::RoutingProtocol;
        RngSeedManager::SetSeed(1);
        RngSeedManager::SetRun(1);

        NodeContainer nodes;
        nodes.Create(3);

        NodeContainer leftPair(nodes.Get(0), nodes.Get(1));
        NodeContainer rightPair(nodes.Get(1), nodes.Get(2));
        SimpleNetDeviceHelper devHelper;
        NetDeviceContainer leftDevs = devHelper.Install(leftPair, CreateObject<SimpleChannel>());
        NetDeviceContainer rightDevs = devHelper.Install(rightPair, CreateObject<SimpleChannel>());

        // Slow the relay's egress toward node 2. The left link keeps the
        // default infinite rate, so its queue drains instantly and stays idle.
        Ptr<SimpleNetDevice> relayRight = DynamicCast<SimpleNetDevice>(rightDevs.Get(0));
        relayRight->SetAttribute("DataRate", DataRateValue(DataRate("32kbps")));

        AntHocNetHelper anthocnet;
        InternetStackHelper internet;
        internet.SetRoutingHelper(anthocnet);
        internet.Install(nodes);

        Ipv4AddressHelper address;
        address.SetBase("10.1.1.0", "255.255.255.0");
        Ipv4InterfaceContainer leftIfs = address.Assign(leftDevs);
        address.SetBase("10.1.2.0", "255.255.255.0");
        Ipv4InterfaceContainer rightIfs = address.Assign(rightDevs);

        const uint16_t port = 9;
        Ptr<Socket> rx = Socket::CreateSocket(nodes.Get(2), UdpSocketFactory::GetTypeId());
        rx->Bind(InetSocketAddress(Ipv4Address::GetAny(), port));
        rx->SetRecvCallback(MakeCallback(&PerHopCongestionSignalTestCase::Drain, this));

        // A sustained 1000-byte burst from node 0: at 32 kb/s the relay drains
        // ~4 pkt/s, so sending 40/s from t=10 guarantees a deep backlog toward
        // node 2 at the probe time.
        Ptr<Socket> tx = Socket::CreateSocket(nodes.Get(0), UdpSocketFactory::GetTypeId());
        tx->Connect(InetSocketAddress(rightIfs.GetAddress(1), port));
        for (double t = 10.0; t < 14.0; t += 0.025) {
            Simulator::Schedule(Seconds(t), &PerHopCongestionSignalTestCase::Send, this, tx);
        }

        Simulator::Schedule(Seconds(13.0), &PerHopCongestionSignalTestCase::Probe, this,
                            nodes.Get(1), RoutingProtocol::ToCore(rightIfs.GetAddress(1)),
                            RoutingProtocol::ToCore(leftIfs.GetAddress(0)));

        Simulator::Stop(Seconds(15.0));
        Simulator::Run();
        Simulator::Destroy();

        NS_TEST_ASSERT_MSG_GT(m_qLoaded, 0, "no backlog read toward the loaded next hop");
        // The instant-drain queue can momentarily hold the packet being
        // serialised within a timestep; anything beyond that is a real backlog
        // and breaks the discrimination this test pins.
        NS_TEST_ASSERT_MSG_LT(m_qIdle, 2, "backlog read toward the idle next hop");
        NS_TEST_ASSERT_MSG_GT(m_qLoaded, m_qIdle, "signal does not discriminate between next hops");
        NS_TEST_ASSERT_MSG_GT_OR_EQ(m_qAggregate, m_qLoaded,
                                    "aggregate smaller than a single queue");
        // Service time toward the loaded hop: sampled (positive) and at the
        // serialisation scale — 1000 B at 32 kb/s is 0.25 s; ants are smaller.
        // A value near an ISL's propagation delay would mean the decomposition
        // folded propagation in, which it must not.
        NS_TEST_ASSERT_MSG_GT(m_tLoaded, 0.0, "no service-time sample toward the loaded next hop");
        NS_TEST_ASSERT_MSG_LT(m_tLoaded, 1.0, "service time off the serialisation scale");
        NS_TEST_ASSERT_MSG_EQ(m_tIdle, 0.0, "service-time sample on the never-backlogged link");
    }

private:
    void Send(Ptr<Socket> s) { s->Send(Create<Packet>(1000)); }
    void Drain(Ptr<Socket> s) {
        Ptr<Packet> p;
        while ((p = s->Recv())) {
        }
    }
    void Probe(Ptr<Node> relay, ::anthocnet::core::NodeAddress towardLoaded,
               ::anthocnet::core::NodeAddress towardIdle) {
        Ptr<ns3::anthocnet::RoutingProtocol> rp =
            relay->GetObject<ns3::anthocnet::RoutingProtocol>();
        NS_TEST_ASSERT_MSG_EQ((rp != nullptr), true, "relay has no AntHocNet protocol");
        if (!rp) return;
        m_qLoaded = rp->macQueueLength(towardLoaded);
        m_qIdle = rp->macQueueLength(towardIdle);
        m_qAggregate = rp->macQueueLength(::anthocnet::core::kInvalidAddress);
        m_tLoaded = rp->macServiceTime(towardLoaded);
        m_tIdle = rp->macServiceTime(towardIdle);
    }

    int m_qLoaded;
    int m_qIdle;
    int m_qAggregate;
    double m_tLoaded;
    double m_tIdle;
};

// B3 — address mapping never aliases the core's kInvalidAddress sentinel.
class AddressMappingTestCase : public TestCase {
public:
    AddressMappingTestCase() : TestCase("ToCore/ToIpv4 address mapping (B3)") {}

    void DoRun() override {
        using ns3::anthocnet::RoutingProtocol;
        const ::anthocnet::core::NodeAddress invalid = ::anthocnet::core::kInvalidAddress;

        // The limited broadcast must never collide with "no route" (-1).
        NS_TEST_ASSERT_MSG_NE(RoutingProtocol::ToCore(Ipv4Address("255.255.255.255")), invalid,
                              "broadcast aliases kInvalidAddress");

        // MSB-set / arbitrary unicast addresses round-trip without aliasing it.
        const char* addrs[] = {"128.0.0.1", "200.1.2.3", "10.1.0.5", "192.168.1.1"};
        for (const char* s : addrs) {
            Ipv4Address a(s);
            ::anthocnet::core::NodeAddress core = RoutingProtocol::ToCore(a);
            NS_TEST_ASSERT_MSG_NE(core, invalid, "unicast aliases kInvalidAddress");
            NS_TEST_ASSERT_MSG_EQ(RoutingProtocol::ToIpv4(core), a, "round-trip");
        }
    }
};

// Repair ant fires on a MAC transmit-failure (ADR-0008 detector D, issue #19).
// Two adhoc-wifi nodes within range establish a data session; the receiver is
// then moved out of range so the sender's unicasts fail after the retry limit.
// The WifiMac "DroppedMpdu" trace must drive a bounded repair ant, observed via
// the protocol's "Tx" trace (type == Repair). SimpleNetDevice has no such
// failure model, so this case requires real wifi.
class RepairAntOnLinkBreakTestCase : public TestCase {
public:
    RepairAntOnLinkBreakTestCase()
        : TestCase("Repair ant fires on MAC tx-failure (detector D)"), m_repairAnts(0) {}

    void DoRun() override {
        RngSeedManager::SetSeed(1);
        RngSeedManager::SetRun(1);

        NodeContainer nodes;
        nodes.Create(2);

        // Disk connectivity model so the link is purely a function of distance.
        WifiHelper wifi;
        wifi.SetStandard(WIFI_STANDARD_80211b);
        YansWifiChannelHelper channel;
        channel.SetPropagationDelay("ns3::ConstantSpeedPropagationDelayModel");
        channel.AddPropagationLoss("ns3::RangePropagationLossModel", "MaxRange",
                                   DoubleValue(120.0));
        YansWifiPhyHelper phy;
        phy.SetChannel(channel.Create());
        WifiMacHelper mac;
        mac.SetType("ns3::AdhocWifiMac");
        NetDeviceContainer devices = wifi.Install(phy, mac, nodes);

        // Node 0 at the origin, node 1 in range (60 m < 120 m).
        MobilityHelper mobility;
        Ptr<ListPositionAllocator> pos = CreateObject<ListPositionAllocator>();
        pos->Add(Vector(0.0, 0.0, 0.0));
        pos->Add(Vector(60.0, 0.0, 0.0));
        mobility.SetPositionAllocator(pos);
        mobility.SetMobilityModel("ns3::ConstantPositionMobilityModel");
        mobility.Install(nodes);

        AntHocNetHelper anthocnet;
        InternetStackHelper internet;
        internet.SetRoutingHelper(anthocnet);
        internet.Install(nodes);

        Ipv4AddressHelper address;
        address.SetBase("10.1.0.0", "255.255.255.0");
        Ipv4InterfaceContainer ifs = address.Assign(devices);

        // Count repair ants put on the medium across both nodes (item-15 Tx trace).
        for (uint32_t i = 0; i < nodes.GetN(); ++i) {
            Ptr<Ipv4> ipv4 = nodes.Get(i)->GetObject<Ipv4>();
            Ptr<ns3::anthocnet::RoutingProtocol> rp =
                DynamicCast<ns3::anthocnet::RoutingProtocol>(ipv4->GetRoutingProtocol());
            if (rp) {
                rp->TraceConnectWithoutContext(
                    "Tx", MakeCallback(&RepairAntOnLinkBreakTestCase::CountTx, this));
            }
        }

        const uint16_t port = 9;
        Ptr<Socket> rx = Socket::CreateSocket(nodes.Get(1), UdpSocketFactory::GetTypeId());
        rx->Bind(InetSocketAddress(Ipv4Address::GetAny(), port));

        Ptr<Socket> tx = Socket::CreateSocket(nodes.Get(0), UdpSocketFactory::GetTypeId());
        tx->Connect(InetSocketAddress(ifs.GetAddress(1), port));
        // Send densely so a live session exists before the break and, after it,
        // detector D reaches Config::txFailureThreshold consecutive MAC drops
        // (the #19 debounce) well before detector A's hello-timeout (~2 s) would
        // evict the moved node — otherwise A removes it first and D never fires
        // the repair. The simulation is deterministic (fixed seed/run), so this
        // ordering is stable across ns-3 versions.
        for (double t = 5.0; t < 28.0; t += 0.1) {
            Simulator::Schedule(Seconds(t), &RepairAntOnLinkBreakTestCase::Send, this, tx);
        }

        // Break the link at t=15 s: move node 1 far out of range.
        Simulator::Schedule(Seconds(15.0), &RepairAntOnLinkBreakTestCase::MoveAway, this,
                            nodes.Get(1));

        Simulator::Stop(Seconds(30.0));
        Simulator::Run();
        Simulator::Destroy();

        NS_TEST_ASSERT_MSG_GT(m_repairAnts, 0u,
                              "no repair ant was sent after the induced link break");
    }

private:
    void Send(Ptr<Socket> s) { s->Send(Create<Packet>(64)); }
    void MoveAway(Ptr<Node> n) {
        n->GetObject<MobilityModel>()->SetPosition(Vector(5000.0, 0.0, 0.0));
    }
    void CountTx(uint8_t type, uint8_t /*dir*/, bool /*broadcast*/) {
        if (type == static_cast<uint8_t>(AntType::Repair)) ++m_repairAnts;
    }
    uint32_t m_repairAnts;
};

// ns-3 made the TestSuite/TestCase enums scoped in ns-3.42 (enum class Type /
// Duration) and removed the deprecated unscoped aliases in ns-3.47. So the
// scoped form is required from 3.47, the unscoped form is the only one before
// 3.42, and 3.42–3.46 accept both. ANTHOCNET_NS3_SCOPED_TEST_ENUMS is defined
// by the module's CMakeLists for ns-3 >= 3.42.
#ifdef ANTHOCNET_NS3_SCOPED_TEST_ENUMS
#define AHN_TEST_TYPE_UNIT TestSuite::Type::UNIT
#define AHN_TEST_QUICK TestCase::Duration::QUICK
#else
#define AHN_TEST_TYPE_UNIT UNIT
#define AHN_TEST_QUICK TestCase::QUICK
#endif

class AntHocNetTestSuite : public TestSuite {
public:
    AntHocNetTestSuite() : TestSuite("anthocnet", AHN_TEST_TYPE_UNIT) {
        AddTestCase(new AntHeaderRoundTripTestCase(), AHN_TEST_QUICK);
        AddTestCase(new AntHeaderKinematicsTestCase(), AHN_TEST_QUICK);
        AddTestCase(new AddressMappingTestCase(), AHN_TEST_QUICK);
        AddTestCase(new AntHocNetDeliveryTestCase(), AHN_TEST_QUICK);
        AddTestCase(new MultiInterfaceDeliveryTestCase(), AHN_TEST_QUICK);
        AddTestCase(new P2pHelloThrottleTestCase(), AHN_TEST_QUICK);
        AddTestCase(new StrongestNextHopTestCase(), AHN_TEST_QUICK);
        AddTestCase(new PerHopCongestionSignalTestCase(), AHN_TEST_QUICK);
        AddTestCase(new RepairAntOnLinkBreakTestCase(), AHN_TEST_QUICK);
    }
};

static AntHocNetTestSuite g_antHocNetTestSuite;
