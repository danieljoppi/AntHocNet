// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

#include "adaptive-packet.h"

#include <cstring>

namespace ns3 {
namespace adaptive {

NS_OBJECT_ENSURE_REGISTERED(ControlHeader);

TypeId ControlHeader::GetTypeId() {
    static TypeId tid = TypeId("ns3::adaptive::ControlHeader")
                            .SetParent<Header>()
                            .SetGroupName("Adaptive")
                            .AddConstructor<ControlHeader>();
    return tid;
}

TypeId ControlHeader::GetInstanceTypeId() const { return GetTypeId(); }

uint32_t ControlHeader::GetSerializedSize() const { return 24; }

void ControlHeader::Serialize(Buffer::Iterator i) const {
    i.WriteU8(type);
    i.WriteU8(hops);
    i.WriteU8(ttl);
    i.WriteU8(flags);
    i.WriteHtonU32(seq);
    i.WriteHtonU32(origin.Get());
    i.WriteHtonU32(target.Get());
    uint64_t bits = 0;
    static_assert(sizeof(bits) == sizeof(value), "double is 64-bit");
    std::memcpy(&bits, &value, sizeof(bits));
    i.WriteHtonU64(bits);
}

uint32_t ControlHeader::Deserialize(Buffer::Iterator start) {
    Buffer::Iterator i = start;
    type = i.ReadU8();
    hops = i.ReadU8();
    ttl = i.ReadU8();
    flags = i.ReadU8();
    seq = i.ReadNtohU32();
    origin = Ipv4Address(i.ReadNtohU32());
    target = Ipv4Address(i.ReadNtohU32());
    const uint64_t bits = i.ReadNtohU64();
    std::memcpy(&value, &bits, sizeof(bits));
    return i.GetDistanceFrom(start);
}

void ControlHeader::Print(std::ostream& os) const {
    os << "type=" << unsigned(type) << " hops=" << unsigned(hops) << " ttl=" << unsigned(ttl)
       << " seq=" << seq << " origin=" << origin << " target=" << target << " value=" << value;
}

}  // namespace adaptive
}  // namespace ns3
