// SPDX-License-Identifier: MIT OR GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

#include "anthocnet/core/ant_message.h"
#include "anthocnet/core/ant_message_codec.h"
#include "test_support.h"

using namespace anthocnet::core;

int main() {
    AntMessage m;
    m.type = AntType::Proactive;
    m.direction = AntDirection::Down;
    m.src = 3;
    m.dst = 17;
    m.seqNum = 70000;  // > 16 bits, exercises the widened field
    m.timeStart = 1.25;
    m.lifeAnt = 2.0;
    m.broadcastBudget = 2;
    m.visited = {{3, 0.0}, {4, 0.01}, {7, 0.02}};
    m.history = {{17, 0.05}};
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
    // prevHop/hops/pathTime/pheromone are no longer serialized (ADR-0009): a
    // freshly decoded ant leaves them at defaults for the core to fill.
    CHECK_EQ(out.prevHop, kInvalidAddress);
    CHECK_EQ(out.hops, 0);
    CHECK_NEAR(out.pheromone, 0.0, 1e-12);

    CHECK_EQ(out.visited.size(), m.visited.size());
    for (std::size_t i = 0; i < m.visited.size(); ++i) {
        CHECK_EQ(out.visited[i].node, m.visited[i].node);
        CHECK_NEAR(out.visited[i].time, m.visited[i].time, 1e-12);
    }
    CHECK_EQ(out.history.size(), m.history.size());
    CHECK_EQ(out.helloDests.size(), m.helloDests.size());
    CHECK_EQ(out.helloDests[1].node, 9);
    CHECK_NEAR(out.helloDests[1].pheromone, 0.5, 1e-12);

    // Item 02 wire slim (ADR-0009): the four transient fields left the fixed
    // prefix (-24 bytes). An empty-array ant is version(1) + fixed(34) +
    // counts(6) = 41 bytes. The version byte is 0x04 since ADR-0025, which
    // added the optional hello kinematics section and no other byte: a frame
    // without the section keeps its 0x03 length.
    {
        AntMessage empty;
        empty.type = AntType::Reactive;
        empty.direction = AntDirection::Up;
        CHECK_EQ(codec::serializedSize(empty), static_cast<std::size_t>(41));
        CHECK_EQ(codec::kWireVersion, static_cast<std::uint8_t>(0x04));
    }

    // ADR-0025 (#573): a hello's kinematics section round-trips at float32
    // precision and adds exactly kKinematicsSize bytes.
    AntMessage hello;
    hello.type = AntType::Hello;
    hello.direction = AntDirection::Up;
    hello.src = 5;
    hello.helloDests = {{8, 1.0}};
    const std::size_t plain = codec::serializedSize(hello);
    hello.hasKinematics = true;
    hello.kinematics = Kinematics{1250.5, -300.25, 550000.0, 20.0, -7.5, 0.0};
    std::vector<std::uint8_t> kbytes = codec::serialize(hello);
    CHECK_EQ(kbytes.size(), plain + codec::kKinematicsSize);
    CHECK_EQ(kbytes.size(), codec::serializedSize(hello));
    {
        AntMessage out2;
        CHECK(codec::deserialize(kbytes, out2));
        CHECK(out2.hasKinematics);
        CHECK_NEAR(out2.kinematics.x, 1250.5, 1e-3);
        CHECK_NEAR(out2.kinematics.y, -300.25, 1e-3);
        CHECK_NEAR(out2.kinematics.z, 550000.0, 0.05);  // float32 at 550 km
        CHECK_NEAR(out2.kinematics.vx, 20.0, 1e-6);
        CHECK_NEAR(out2.kinematics.vy, -7.5, 1e-6);
        CHECK_NEAR(out2.kinematics.vz, 0.0, 1e-6);
        CHECK_EQ(out2.helloDests.size(), static_cast<std::size_t>(1));
    }
    // A hello without the section decodes as absent, never as the origin.
    {
        AntMessage plainHello = hello;
        plainHello.hasKinematics = false;
        AntMessage out2;
        out2.hasKinematics = true;  // stale state must be cleared
        CHECK(codec::deserialize(codec::serialize(plainHello), out2));
        CHECK(!out2.hasKinematics);
    }
    // The section is validated, not trusted.
    {
        std::vector<std::uint8_t> v = kbytes;
        v[plain] = 0x00;  // wrong tag
        AntMessage out2;
        CHECK(!codec::deserialize(v, out2));
    }
    {
        AntMessage out2;  // truncated section
        CHECK(!codec::deserialize(kbytes.data(), kbytes.size() - 1, out2));
        CHECK(!codec::deserialize(kbytes.data(), plain + 1, out2));
    }
    {
        std::vector<std::uint8_t> v = kbytes;
        v.push_back(0x00);  // trailing byte after the section
        AntMessage out2;
        CHECK(!codec::deserialize(v, out2));
    }
    {
        std::vector<std::uint8_t> v = kbytes;
        // x := +inf (float32 0x7F800000, little-endian)
        v[plain + 1] = 0x00;
        v[plain + 2] = 0x00;
        v[plain + 3] = 0x80;
        v[plain + 4] = 0x7F;
        AntMessage out2;
        CHECK(!codec::deserialize(v, out2));
    }
    {
        // A section on anything but a hello is rejected.
        AntMessage fwd = hello;
        fwd.type = AntType::Reactive;
        AntMessage out2;
        CHECK(!codec::deserialize(codec::serialize(fwd), out2));
    }
    {
        // Bytes after the adverts that are not a section: rejected (0x03
        // decoders ignored them; 0x04 defines what may follow).
        std::vector<std::uint8_t> v = codec::serialize(m);
        v.push_back(codec::kKinematicsTag);
        AntMessage out2;
        CHECK(!codec::deserialize(v, out2));
    }

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
        big.type = AntType::Reactive;
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
