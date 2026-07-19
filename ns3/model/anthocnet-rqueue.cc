#include "anthocnet-rqueue.h"

#include "ns3/simulator.h"
#include "ns3/socket.h"

#include <algorithm>

namespace ns3 {
namespace anthocnet {

bool RequestQueue::Enqueue(QueueEntry& entry) {
    Purge();
    // Preserve the first-enqueue timestamp across re-queues (FlushQueue puts an
    // entry back when its route vanishes again) so the #21 hold time measures
    // the whole wait, not just the last leg.
    if (entry.enqueueFirst.IsZero()) entry.enqueueFirst = Simulator::Now();
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
        } else {
            // Aged out at QueueTimeout (#21): attribute the lost hold to its
            // reason before firing the error callback.
            const uint8_t r = e.holdReason < kHoldReasons ? e.holdReason : HOLD_SETUP;
            m_stats.droppedCount[r] += 1;
            m_stats.droppedSumS[r] += (now - e.enqueueFirst).GetSeconds();
            if (!e.ecb.IsNull()) {
                e.ecb(e.packet, e.header, Socket::ERROR_NOROUTETOHOST);
            }
        }
    }
    m_queue.swap(kept);
}

std::vector<Ipv4Address> RequestQueue::PendingDestinations() {
    Purge();
    std::vector<Ipv4Address> dests;
    for (const QueueEntry& e : m_queue) {
        const Ipv4Address d = Dst(e);
        if (std::find(dests.begin(), dests.end(), d) == dests.end()) {
            dests.push_back(d);
        }
    }
    return dests;
}

void RequestQueue::NoteDelivered(const QueueEntry& e) {
    const uint8_t r = e.holdReason < kHoldReasons ? e.holdReason : HOLD_SETUP;
    const double hold = (Simulator::Now() - e.enqueueFirst).GetSeconds();
    m_stats.deliveredCount[r] += 1;
    m_stats.deliveredSumS[r] += hold;
    if (hold > m_stats.deliveredMaxS[r]) m_stats.deliveredMaxS[r] = hold;
}

uint32_t RequestQueue::Size() {
    Purge();
    return static_cast<uint32_t>(m_queue.size());
}

} // namespace anthocnet
} // namespace ns3
