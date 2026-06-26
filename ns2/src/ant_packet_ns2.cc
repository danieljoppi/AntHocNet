#include "anthocnet/ant_packet_ns2.h"

#include <algorithm>

#include "anthocnet/core/ant_message_codec.h"

int AntPacketHeader::offset_;

namespace anthocnet {
namespace ns2 {

using core::AntMessage;
using core::AntType;
using core::AntDirection;

core::AntMessage toMessage(const AntPacketHeader& h) {
    AntMessage m;
    m.type      = static_cast<AntType>(h.antType_);
    m.direction = static_cast<AntDirection>(h.antDirection_);
    m.src       = h.src_;
    m.dst       = h.dst_;
    m.seqNum    = h.seqNum_;
    m.timeStart = h.timeStart_;
    m.lifeAnt   = h.lifeAnt_;
    m.prevHop   = h.prevHop_;
    m.hops      = h.hops_;
    m.prevSINR  = h.prevSINR_;
    m.pheromone = h.pheromone_;

    m.visited.reserve(h.visitedCount_);
    for (uint16_t i = 0; i < h.visitedCount_; ++i)
        m.visited.push_back({h.visited_[i].node, h.visited_[i].time});
    m.history.reserve(h.historyCount_);
    for (uint16_t i = 0; i < h.historyCount_; ++i)
        m.history.push_back({h.history_[i].node, h.history_[i].time});
    m.helloDests.reserve(h.helloCount_);
    for (uint16_t i = 0; i < h.helloCount_; ++i)
        m.helloDests.push_back({h.hello_[i].node, h.hello_[i].pheromone});

    return m;
}

void fromMessage(const core::AntMessage& m, AntPacketHeader& h) {
    h.version_      = core::codec::kWireVersion;
    h.antType_      = static_cast<uint8_t>(m.type);
    h.antDirection_ = static_cast<uint8_t>(m.direction);
    h.src_          = m.src;
    h.dst_          = m.dst;
    h.seqNum_       = m.seqNum;
    h.timeStart_    = m.timeStart;
    h.lifeAnt_      = m.lifeAnt;
    h.prevHop_      = m.prevHop;
    h.hops_         = m.hops;
    h.prevSINR_     = m.prevSINR;
    h.pheromone_    = m.pheromone;

    const uint16_t nv = static_cast<uint16_t>(
        std::min<size_t>(m.visited.size(), AntPacketHeader::kMaxPath));
    h.visitedCount_ = nv;
    for (uint16_t i = 0; i < nv; ++i) {
        h.visited_[i].node = m.visited[i].node;
        h.visited_[i].time = m.visited[i].time;
    }

    const uint16_t nh = static_cast<uint16_t>(
        std::min<size_t>(m.history.size(), AntPacketHeader::kMaxPath));
    h.historyCount_ = nh;
    for (uint16_t i = 0; i < nh; ++i) {
        h.history_[i].node = m.history[i].node;
        h.history_[i].time = m.history[i].time;
    }

    const uint16_t nd = static_cast<uint16_t>(
        std::min<size_t>(m.helloDests.size(), AntPacketHeader::kMaxHello));
    h.helloCount_ = nd;
    for (uint16_t i = 0; i < nd; ++i) {
        h.hello_[i].node      = m.helloDests[i].node;
        h.hello_[i].pheromone = m.helloDests[i].pheromone;
    }
}

} // namespace ns2
} // namespace anthocnet
