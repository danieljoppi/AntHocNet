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

#include "ns3/anthocnet-packet.h"
#include "ns3/anthocnet-helper.h"

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
        m.prevHop = 4;
        m.hops = 5;
        m.prevSINR = 12.5;
        m.pheromone = 0.0123;
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
        NS_TEST_ASSERT_MSG_EQ(r.hops, 5, "hops");
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

class AntHocNetTestSuite : public TestSuite
{
public:
    AntHocNetTestSuite() : TestSuite("anthocnet", Type::UNIT) {
        AddTestCase(new AntHeaderRoundTripTestCase(), TestCase::Duration::QUICK);
        AddTestCase(new AntHocNetDeliveryTestCase(), TestCase::Duration::QUICK);
    }
};

static AntHocNetTestSuite g_antHocNetTestSuite;
