/*
 * Pending-packet queue for AntHocNet (NS-3), following the aodv-rqueue
 * pattern: data packets with no known route are held here until a backward
 * ant installs one, with a per-entry lifetime and a global size cap.
 */
#ifndef ANTHOCNET_RQUEUE_H
#define ANTHOCNET_RQUEUE_H

#include "ns3/ipv4-routing-protocol.h"
#include "ns3/ipv4-header.h"
#include "ns3/packet.h"
#include "ns3/nstime.h"

#include <vector>

namespace ns3 {
namespace anthocnet {

/// One queued packet plus the callbacks needed to resume it once a route
/// appears (or to error it when it expires).
struct QueueEntry
{
    Ptr<const Packet> packet;
    Ipv4Header header;
    Ipv4RoutingProtocol::UnicastForwardCallback ucb;
    Ipv4RoutingProtocol::ErrorCallback ecb;
    Time expire;
};

class RequestQueue
{
public:
    RequestQueue(uint32_t maxLen, Time timeout) : m_maxLen(maxLen), m_timeout(timeout) {}

    /// Enqueue, dropping the oldest entry if at capacity. Returns false if the
    /// packet could not be queued.
    bool Enqueue(QueueEntry& entry);

    /// Move all entries for `dst` out of the queue into `out`.
    void DequeueAll(Ipv4Address dst, std::vector<QueueEntry>& out);

    /// Drop expired entries (firing their error callbacks).
    void Purge();

    uint32_t Size();

private:
    static Ipv4Address Dst(const QueueEntry& e) { return e.header.GetDestination(); }

    std::vector<QueueEntry> m_queue;
    uint32_t m_maxLen;
    Time m_timeout;
};

} // namespace anthocnet
} // namespace ns3

#endif // ANTHOCNET_RQUEUE_H
