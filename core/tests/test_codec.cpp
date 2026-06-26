#include "anthocnet/core/ant_message.h"
#include "anthocnet/core/ant_message_codec.h"
#include "test_support.h"

using namespace anthocnet::core;

int main() {
    AntMessage m;
    m.type      = AntType::Proactive;
    m.direction = AntDirection::Down;
    m.src       = 3;
    m.dst       = 17;
    m.seqNum    = 70000;          // > 16 bits, exercises the widened field
    m.timeStart = 1.25;
    m.lifeAnt   = 2.0;
    m.broadcastBudget = 2;
    m.prevHop   = 4;
    m.hops      = 5;
    m.prevSINR  = 12.5;
    m.pheromone = 0.0123;
    m.visited   = {{3, 0.0}, {4, 0.01}, {7, 0.02}};
    m.history   = {{17, 0.05}};
    m.helloDests = {{8, 1.0}, {9, 0.5}};

    std::vector<std::uint8_t> bytes;
    codec::serialize(m, bytes);
    CHECK_EQ(bytes.size(), codec::serializedSize(m));

    AntMessage out;
    CHECK(codec::deserialize(bytes, out));

    CHECK(out.type == m.type);
    CHECK(out.direction == m.direction);
    CHECK_EQ(out.src, m.src);
    CHECK_EQ(out.dst, m.dst);
    CHECK_EQ(out.seqNum, m.seqNum);
    CHECK_NEAR(out.timeStart, m.timeStart, 1e-12);
    CHECK_NEAR(out.lifeAnt, m.lifeAnt, 1e-12);
    CHECK_EQ(out.broadcastBudget, m.broadcastBudget);
    CHECK_EQ(out.prevHop, m.prevHop);
    CHECK_EQ(out.hops, m.hops);
    CHECK_NEAR(out.prevSINR, m.prevSINR, 1e-12);
    CHECK_NEAR(out.pheromone, m.pheromone, 1e-12);

    CHECK_EQ(out.visited.size(), m.visited.size());
    for (std::size_t i = 0; i < m.visited.size(); ++i) {
        CHECK_EQ(out.visited[i].node, m.visited[i].node);
        CHECK_NEAR(out.visited[i].time, m.visited[i].time, 1e-12);
    }
    CHECK_EQ(out.history.size(), m.history.size());
    CHECK_EQ(out.helloDests.size(), m.helloDests.size());
    CHECK_EQ(out.helloDests[1].node, 9);
    CHECK_NEAR(out.helloDests[1].pheromone, 0.5, 1e-12);

    // Truncated buffers must be rejected, not read out of bounds.
    AntMessage bad;
    CHECK(!codec::deserialize(bytes.data(), bytes.size() - 1, bad));
    CHECK(!codec::deserialize(bytes.data(), 3, bad));

    // Item 12 — trust-boundary hardening on the untrusted decode path.

    // A frame whose offset-0 version byte is wrong is rejected up front.
    {
        std::vector<std::uint8_t> v = bytes;
        v[0] = static_cast<std::uint8_t>(codec::kWireVersion + 1);
        AntMessage out2;
        CHECK(!codec::deserialize(v, out2));
    }

    // An out-of-range type / direction byte is rejected.
    {
        std::vector<std::uint8_t> v = bytes;
        v[1] = 0x7F;  // not a valid AntType
        AntMessage out2;
        CHECK(!codec::deserialize(v, out2));
    }
    {
        std::vector<std::uint8_t> v = bytes;
        v[2] = 0x00;  // not a valid AntDirection
        AntMessage out2;
        CHECK(!codec::deserialize(v, out2));
    }

    // A count above the protocol cap is rejected even when the buffer backs it
    // (regression for golden rule #5 at the wire boundary).
    {
        AntMessage big;
        big.type      = AntType::Reactive;
        big.direction = AntDirection::Up;
        for (std::size_t i = 0; i <= codec::kMaxVisitedOnWire; ++i) {
            big.visited.push_back({static_cast<NodeAddress>(i), 0.0});
        }
        std::vector<std::uint8_t> v = codec::serialize(big);
        AntMessage out2;
        CHECK(!codec::deserialize(v, out2));
    }

    return RUN_TESTS();
}
