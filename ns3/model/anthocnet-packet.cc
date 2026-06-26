#include "anthocnet-packet.h"

#include "ns3/type-id.h"

#include <cstring>

#include "anthocnet/core/ant_message_codec.h"

namespace ns3 {
namespace anthocnet {

namespace {

uint64_t DoubleToBits(double v) {
    uint64_t bits;
    std::memcpy(&bits, &v, sizeof(bits));
    return bits;
}

double BitsToDouble(uint64_t bits) {
    double v;
    std::memcpy(&v, &bits, sizeof(v));
    return v;
}

constexpr uint32_t kHopSize = 4 + 8;     // int32 node + double time
constexpr uint32_t kHelloSize = 4 + 8;   // int32 node + double pheromone
// prevHop/hops/pathTime/pheromone are reconstructed locally (ADR-0009), not sent.
constexpr uint32_t kFixedSize = 1 + 1 + 4 + 4 + 4 + 8 + 8 + 4;
constexpr uint32_t kCounts = 2 + 2 + 2;

} // namespace

NS_OBJECT_ENSURE_REGISTERED(AntHeader);

TypeId AntHeader::GetTypeId() {
    static TypeId tid = TypeId("ns3::anthocnet::AntHeader")
                            .SetParent<Header>()
                            .SetGroupName("AntHocNet")
                            .AddConstructor<AntHeader>();
    return tid;
}

TypeId AntHeader::GetInstanceTypeId() const {
    return GetTypeId();
}

uint32_t AntHeader::GetSerializedSize() const {
    return 1 /*version*/ + kFixedSize + kCounts +
           static_cast<uint32_t>(m_message.visited.size()) * kHopSize +
           static_cast<uint32_t>(m_message.history.size()) * kHopSize +
           static_cast<uint32_t>(m_message.helloDests.size()) * kHelloSize;
}

void AntHeader::Serialize(Buffer::Iterator i) const {
    const auto& m = m_message;
    i.WriteU8(::anthocnet::core::codec::kWireVersion);
    i.WriteU8(static_cast<uint8_t>(m.type));
    i.WriteU8(static_cast<uint8_t>(m.direction));
    i.WriteU32(static_cast<uint32_t>(m.src));
    i.WriteU32(static_cast<uint32_t>(m.dst));
    i.WriteU32(m.seqNum);
    i.WriteU64(DoubleToBits(m.timeStart));
    i.WriteU64(DoubleToBits(m.lifeAnt));
    i.WriteU32(static_cast<uint32_t>(m.broadcastBudget));

    i.WriteU16(static_cast<uint16_t>(m.visited.size()));
    for (const auto& h : m.visited) {
        i.WriteU32(static_cast<uint32_t>(h.node));
        i.WriteU64(DoubleToBits(h.time));
    }
    i.WriteU16(static_cast<uint16_t>(m.history.size()));
    for (const auto& h : m.history) {
        i.WriteU32(static_cast<uint32_t>(h.node));
        i.WriteU64(DoubleToBits(h.time));
    }
    i.WriteU16(static_cast<uint16_t>(m.helloDests.size()));
    for (const auto& d : m.helloDests) {
        i.WriteU32(static_cast<uint32_t>(d.node));
        i.WriteU64(DoubleToBits(d.pheromone));
    }
}

uint32_t AntHeader::Deserialize(Buffer::Iterator start) {
    Buffer::Iterator i = start;
    auto& m = m_message;
    i.ReadU8();  // wire-version byte (self-generated packets are trusted)
    m.type      = static_cast<::anthocnet::core::AntType>(i.ReadU8());
    m.direction = static_cast<::anthocnet::core::AntDirection>(i.ReadU8());
    m.src       = static_cast<int32_t>(i.ReadU32());
    m.dst       = static_cast<int32_t>(i.ReadU32());
    m.seqNum    = i.ReadU32();
    m.timeStart = BitsToDouble(i.ReadU64());
    m.lifeAnt   = BitsToDouble(i.ReadU64());
    m.broadcastBudget = static_cast<int>(i.ReadU32());

    const uint16_t nv = i.ReadU16();
    m.visited.resize(nv);
    for (auto& h : m.visited) { h.node = static_cast<int32_t>(i.ReadU32()); h.time = BitsToDouble(i.ReadU64()); }
    const uint16_t nh = i.ReadU16();
    m.history.resize(nh);
    for (auto& h : m.history) { h.node = static_cast<int32_t>(i.ReadU32()); h.time = BitsToDouble(i.ReadU64()); }
    const uint16_t nd = i.ReadU16();
    m.helloDests.resize(nd);
    for (auto& d : m.helloDests) { d.node = static_cast<int32_t>(i.ReadU32()); d.pheromone = BitsToDouble(i.ReadU64()); }

    return i.GetDistanceFrom(start);
}

void AntHeader::Print(std::ostream& os) const {
    os << "AntHocNet type=" << static_cast<int>(m_message.type)
       << " dir=" << static_cast<int>(m_message.direction)
       << " src=" << m_message.src << " dst=" << m_message.dst
       << " seq=" << m_message.seqNum
       << " path=" << m_message.visited.size();
}

} // namespace anthocnet
} // namespace ns3
