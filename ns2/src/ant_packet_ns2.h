/*
 * NS-2 on-the-wire header for AntHocNet, bridged to the simulator-agnostic
 * core::AntMessage.
 *
 * NS-2 keeps packet headers in a pooled, byte-copied region, so the header
 * MUST be a trivially-copyable POD: no std::vector, no heap pointers (the
 * original ant_packet.h stored malloc'd AntTimeEntry** arrays here, which
 * leaked and double-freed on broadcast). We therefore use fixed-capacity
 * inline arrays and convert to/from the core value type at the edges.
 */
#ifndef ANTHOCNET_NS2_ANT_PACKET_NS2_H
#define ANTHOCNET_NS2_ANT_PACKET_NS2_H

#include <config.h>
#include <packet.h>

#include <cstdint>
#include <cstring>

#include "anthocnet/core/ant_message.h"

// Ant type / direction constants for the trace formatter and TCL side. They
// mirror core::AntType / core::AntDirection numeric values.
#define ANT_TYPE_HELLO     0x01
#define ANT_TYPE_REACTIVE  0x02
#define ANT_TYPE_PROACTIVE 0x04
#define ANT_TYPE_REPAIR    0x08
#define ANT_UP             0x11
#define ANT_DOWN           0x12

/// Access the AntHocNet header of a packet.
#define HDR_AHN(p) (AntPacketHeader::access(p))

struct AntHopPod {
    int32_t node;
    double  time;
};

struct AntHelloPod {
    int32_t node;
    double  pheromone;
};

/// POD packet header. Capacities bound the carried path/adverts (matching
/// core::Config::maxPathLength / hello fan-out).
struct AntPacketHeader {
    static const int kMaxPath  = 100;
    static const int kMaxHello = 10;

    uint8_t  version_;       ///< on-wire format version (core::codec::kWireVersion)
    uint8_t  antType_;
    uint8_t  antDirection_;
    int32_t  src_;
    int32_t  dst_;
    uint32_t seqNum_;
    double   timeStart_;
    double   lifeAnt_;
    int32_t  broadcastBudget_;
    // prevHop/hops/pathTime/pheromone are reconstructed locally (ADR-0009), not
    // carried on the wire.

    uint16_t visitedCount_;
    AntHopPod visited_[kMaxPath];
    uint16_t historyCount_;
    AntHopPod history_[kMaxPath];
    uint16_t helloCount_;
    AntHelloPod hello_[kMaxHello];

    // --- NS-2 PacketHeaderManager plumbing -------------------------------
    static int offset_;
    inline static int& offset() { return offset_; }
    inline static AntPacketHeader* access(const Packet* p) {
        return (AntPacketHeader*) p->access(offset_);
    }

    // --- trace-formatter accessors (used by cmu-trace patch) -------------
    uint8_t  antType()      const { return antType_; }
    uint8_t  antDirection() const { return antDirection_; }
    int32_t  src()          const { return src_; }
    int32_t  dst()          const { return dst_; }
    uint32_t seqNum()       const { return seqNum_; }
    double   timeStart()    const { return timeStart_; }
    int      pathLen()      const { return visitedCount_; }

    /// Simulated over-the-air size: the bytes core::codec would emit.
    int wireSize() const {
        return 1                                    // wire-version byte
             + 1 + 1 + 4 + 4 + 4 + 8 + 8 + 4        // fixed fields
             + 2 + 2 + 2                            // three counts
             + visitedCount_ * (4 + 8)
             + historyCount_ * (4 + 8)
             + helloCount_   * (4 + 8);
    }
};

namespace anthocnet {
namespace ns2 {

/// Decode the NS-2 header into a core message.
core::AntMessage toMessage(const AntPacketHeader& h);

/// Encode a core message into the NS-2 header (truncating to capacity).
void fromMessage(const core::AntMessage& m, AntPacketHeader& h);

} // namespace ns2
} // namespace anthocnet

#endif // ANTHOCNET_NS2_ANT_PACKET_NS2_H
