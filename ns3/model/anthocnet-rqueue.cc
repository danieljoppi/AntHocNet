#include "anthocnet-rqueue.h"

#include "ns3/simulator.h"
#include "ns3/socket.h"

#include <algorithm>

namespace ns3 {
namespace anthocnet {

bool RequestQueue::Enqueue(QueueEntry& entry) {
    Purge();
    entry.expire = Simulator::Now() + m_timeout;
    if (m_queue.size() >= m_maxLen) {
        // Drop the oldest to make room.
        m_queue.erase(m_queue.begin());
    }
    m_queue.push_back(entry);
    return true;
}

void RequestQueue::DequeueAll(Ipv4Address dst, std::vector<QueueEntry>& out) {
    Purge();
    std::vector<QueueEntry> kept;
    kept.reserve(m_queue.size());
    for (QueueEntry& e : m_queue) {
        if (Dst(e) == dst) {
            out.push_back(e);
        } else {
            kept.push_back(e);
        }
    }
    m_queue.swap(kept);
}

void RequestQueue::Purge() {
    const Time now = Simulator::Now();
    std::vector<QueueEntry> kept;
    kept.reserve(m_queue.size());
    for (QueueEntry& e : m_queue) {
        if (e.expire > now) {
            kept.push_back(e);
        } else if (!e.ecb.IsNull()) {
            e.ecb(e.packet, e.header, Socket::ERROR_NOROUTETOHOST);
        }
    }
    m_queue.swap(kept);
}

uint32_t RequestQueue::Size() {
    Purge();
    return static_cast<uint32_t>(m_queue.size());
}

} // namespace anthocnet
} // namespace ns3
