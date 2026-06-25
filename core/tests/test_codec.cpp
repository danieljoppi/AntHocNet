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

    return RUN_TESTS();
}
