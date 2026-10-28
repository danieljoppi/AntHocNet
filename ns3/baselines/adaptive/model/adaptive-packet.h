// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/**
 * The control message of the adaptive arms: one fixed 24-byte layout for the
 * discovery ants of ARA (FANT, BANT), Termite (RREQ, RREP, HELLO) and the
 * Q-routing hello and estimate feedback. Each arm uses only the fields it
 * needs; the layout is the arm's own (it never shares a port or a wire with
 * AntHocNet, whose format is core/ant_message_codec).
 *
 *   0  type     u8
 *   1  hops     u8    hops travelled so far
 *   2  ttl      u8    remaining hops (random walks, floods)
 *   3  flags    u8
 *   4  seq      u32   per-origin sequence number
 *   8  origin   u32   the node that created the message
 *  12  target   u32   the node it is looking for / about
 *  16  value    f64   Q-routing: the estimate t = min_z Q_y(d, z), seconds
 *
 * ARA §3.5 says its ants carry "only a unique sequence number" besides the
 * addresses; the hop count is what the receiving node needs for the initial
 * pheromone (§3.1). The value field rides on every message so all arms pay
 * the same, small, per-message cost; it is 8 of the 24 bytes.
 */
#ifndef ADAPTIVE_PACKET_H
#define ADAPTIVE_PACKET_H

#include "ns3/header.h"
#include "ns3/ipv4-address.h"

namespace ns3 {
namespace adaptive {

enum MessageType : uint8_t {
    ARA_FANT = 1,
    ARA_BANT = 2,
    TERMITE_RREQ = 10,
    TERMITE_RREP = 11,
    TERMITE_HELLO = 12,
    QR_HELLO = 20,
    QR_ESTIMATE = 21,
};

class ControlHeader : public Header {
public:
    static TypeId GetTypeId();
    TypeId GetInstanceTypeId() const override;
    uint32_t GetSerializedSize() const override;
    void Serialize(Buffer::Iterator start) const override;
    uint32_t Deserialize(Buffer::Iterator start) override;
    void Print(std::ostream& os) const override;

    uint8_t type = 0;
    uint8_t hops = 0;
    uint8_t ttl = 0;
    uint8_t flags = 0;
    uint32_t seq = 0;
    Ipv4Address origin;
    Ipv4Address target;
    double value = 0.0;
};

}  // namespace adaptive
}  // namespace ns3

#endif  // ADAPTIVE_PACKET_H
