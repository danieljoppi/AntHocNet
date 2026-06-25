/*
 * NS-3 test suite for AntHocNet. Exercises the AntHeader serialize/deserialize
 * round-trip (the riskiest adapter seam) without needing a full simulation.
 */
#include "ns3/test.h"
#include "ns3/packet.h"

#include "ns3/anthocnet-packet.h"

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
        anthocnet::AntHeader out(m);
        packet->AddHeader(out);

        anthocnet::AntHeader in;
        packet->RemoveHeader(in);
        const AntMessage& r = in.Message();

        NS_TEST_ASSERT_MSG_EQ(r.type == AntType::Proactive, true, "type");
        NS_TEST_ASSERT_MSG_EQ(r.direction == AntDirection::Down, true, "direction");
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

class AntHocNetTestSuite : public TestSuite
{
public:
    AntHocNetTestSuite() : TestSuite("anthocnet", Type::UNIT) {
        AddTestCase(new AntHeaderRoundTripTestCase(), TestCase::Duration::QUICK);
    }
};

static AntHocNetTestSuite g_antHocNetTestSuite;
