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

#include "ns3/anthocnet-packet.h"
#include "ns3/anthocnet-helper.h"
#include "ns3/anthocnet-routing-protocol.h"

using namespace ns3;
using ::anthocnet::core::AntMessage;
using ::anthocnet::core::AntType;
using ::anthocnet::core::AntDirection;

class AntHeaderRoundTripTestCase : public TestCase
{
public:
    AntHeaderRoundTripTestCase() : TestCase("AntHeader serialize/deserialize round-trip") {}

    void DoRun() override {
        AntMessage m;
        m.type = AntType::Proactive;
        m.direction = AntDirection::Down;
        m.src = 3;
        m.dst = 17;
        m.seqNum = 70000;       // > 16 bits
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

        NS_TEST_ASSERT_MSG_EQ(static_cast<int>(r.type),
                              static_cast<int>(AntType::Proactive), "type");
        NS_TEST_ASSERT_MSG_EQ(static_cast<int>(r.direction),
                              static_cast<int>(AntDirection::Down), "direction");
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

// Deterministic multi-hop delivery over SimpleNetDevices.
class AntHocNetDeliveryTestCase : public TestCase
{
public:
    AntHocNetDeliveryTestCase()
        : TestCase("Multi-hop delivery over a 3-node line"), m_rxBytes(0) {}

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

        NS_TEST_ASSERT_MSG_GT(m_rxBytes, 0u,
                              "node 2 received no data over the 2-hop path");
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
class MultiInterfaceDeliveryTestCase : public TestCase
{
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
class PerHopCongestionSignalTestCase : public TestCase
{
public:
    PerHopCongestionSignalTestCase()
        : TestCase("Per-next-hop congestion signal on non-wifi devices (#206)"),
          m_qLoaded(0), m_qIdle(0), m_qAggregate(0), m_tLoaded(0.0), m_tIdle(0.0) {}

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
                            nodes.Get(1),
                            RoutingProtocol::ToCore(rightIfs.GetAddress(1)),
                            RoutingProtocol::ToCore(leftIfs.GetAddress(0)));

        Simulator::Stop(Seconds(15.0));
        Simulator::Run();
        Simulator::Destroy();

        NS_TEST_ASSERT_MSG_GT(m_qLoaded, 0,
                              "no backlog read toward the loaded next hop");
        // The instant-drain queue can momentarily hold the packet being
        // serialised within a timestep; anything beyond that is a real backlog
        // and breaks the discrimination this test pins.
        NS_TEST_ASSERT_MSG_LT(m_qIdle, 2,
                              "backlog read toward the idle next hop");
        NS_TEST_ASSERT_MSG_GT(m_qLoaded, m_qIdle,
                              "signal does not discriminate between next hops");
        NS_TEST_ASSERT_MSG_GT_OR_EQ(m_qAggregate, m_qLoaded,
                                    "aggregate smaller than a single queue");
        // Service time toward the loaded hop: sampled (positive) and at the
        // serialisation scale — 1000 B at 32 kb/s is 0.25 s; ants are smaller.
        // A value near an ISL's propagation delay would mean the decomposition
        // folded propagation in, which it must not.
        NS_TEST_ASSERT_MSG_GT(m_tLoaded, 0.0,
                              "no service-time sample toward the loaded next hop");
        NS_TEST_ASSERT_MSG_LT(m_tLoaded, 1.0,
                              "service time off the serialisation scale");
        NS_TEST_ASSERT_MSG_EQ(m_tIdle, 0.0,
                              "service-time sample on the never-backlogged link");
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
        m_qLoaded    = rp->macQueueLength(towardLoaded);
        m_qIdle      = rp->macQueueLength(towardIdle);
        m_qAggregate = rp->macQueueLength(::anthocnet::core::kInvalidAddress);
        m_tLoaded    = rp->macServiceTime(towardLoaded);
        m_tIdle      = rp->macServiceTime(towardIdle);
    }

    int m_qLoaded;
    int m_qIdle;
    int m_qAggregate;
    double m_tLoaded;
    double m_tIdle;
};

// B3 — address mapping never aliases the core's kInvalidAddress sentinel.
class AddressMappingTestCase : public TestCase
{
public:
    AddressMappingTestCase() : TestCase("ToCore/ToIpv4 address mapping (B3)") {}

    void DoRun() override {
        using ns3::anthocnet::RoutingProtocol;
        const ::anthocnet::core::NodeAddress invalid = ::anthocnet::core::kInvalidAddress;

        // The limited broadcast must never collide with "no route" (-1).
        NS_TEST_ASSERT_MSG_NE(RoutingProtocol::ToCore(Ipv4Address("255.255.255.255")),
                              invalid, "broadcast aliases kInvalidAddress");

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
class RepairAntOnLinkBreakTestCase : public TestCase
{
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
        channel.AddPropagationLoss("ns3::RangePropagationLossModel",
                                   "MaxRange", DoubleValue(120.0));
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
#define AHN_TEST_QUICK     TestCase::Duration::QUICK
#else
#define AHN_TEST_TYPE_UNIT UNIT
#define AHN_TEST_QUICK     TestCase::QUICK
#endif

class AntHocNetTestSuite : public TestSuite
{
public:
    AntHocNetTestSuite() : TestSuite("anthocnet", AHN_TEST_TYPE_UNIT) {
        AddTestCase(new AntHeaderRoundTripTestCase(), AHN_TEST_QUICK);
        AddTestCase(new AddressMappingTestCase(), AHN_TEST_QUICK);
        AddTestCase(new AntHocNetDeliveryTestCase(), AHN_TEST_QUICK);
        AddTestCase(new MultiInterfaceDeliveryTestCase(), AHN_TEST_QUICK);
        AddTestCase(new PerHopCongestionSignalTestCase(), AHN_TEST_QUICK);
        AddTestCase(new RepairAntOnLinkBreakTestCase(), AHN_TEST_QUICK);
    }
};

static AntHocNetTestSuite g_antHocNetTestSuite;
