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

#include <cstdint>
#include <vector>

namespace ns3 {
namespace anthocnet {

/// Why a data packet is sitting in the pending queue — used to attribute the
/// delay tail (issue #21) to the dominant hold path. SETUP = first reactive
/// discovery for a destination this node has never yet routed to; RECONV =
/// re-discovery after a previously-known route was lost; REPAIR = re-injected
/// after a MAC transmit failure while a local repair runs (#46).
enum HoldReason : uint8_t { HOLD_SETUP = 0, HOLD_RECONV = 1, HOLD_REPAIR = 2 };
constexpr uint8_t kHoldReasons = 3;

/// Per-reason hold-time accounting over a run (issue #21 tail attribution).
/// The #88 sweep showed the median offered packet delivers in ~3 ms (dOff50):
/// the mean/jitter gap vs AODV is carried entirely by queue-held packets, so
/// which reason accumulates the most *delivered* hold time is the dominant
/// cause of the tail. `dropped*` counts packets that aged out at QueueTimeout
/// (a PDR loss rather than a delay, but the same hold mechanic).
struct HoldStats
{
    uint64_t deliveredCount[kHoldReasons] = {0, 0, 0};
    double   deliveredSumS[kHoldReasons]  = {0.0, 0.0, 0.0};
    double   deliveredMaxS[kHoldReasons]  = {0.0, 0.0, 0.0};
    uint64_t droppedCount[kHoldReasons]   = {0, 0, 0};
    double   droppedSumS[kHoldReasons]    = {0.0, 0.0, 0.0};
};

/// One queued packet plus the callbacks needed to resume it once a route
/// appears (or to error it when it expires).
struct QueueEntry
{
    Ptr<const Packet> packet;
    Ipv4Header header;
    Ipv4RoutingProtocol::UnicastForwardCallback ucb;
    Ipv4RoutingProtocol::ErrorCallback ecb;
    Time expire;
    // #21 hold-time attribution: time this packet first entered the queue
    // (preserved across re-queues so the total wait is measured, not the last
    // leg) and why it is waiting.
    Time enqueueFirst;
    uint8_t holdReason = HOLD_SETUP;
};

class RequestQueue
{
public:
    RequestQueue(uint32_t maxLen, Time timeout) : m_maxLen(maxLen), m_timeout(timeout) {}

    /// Change the hold timeout (issue #21: the QueueTimeout attribute is
    /// applied after construction, in RoutingProtocol::DoInitialize).
    void SetTimeout(Time timeout) { m_timeout = timeout; }

    /// Enqueue, dropping the oldest entry if at capacity. Returns false if the
    /// packet could not be queued.
    bool Enqueue(QueueEntry& entry);

    /// Move all entries for `dst` out of the queue into `out`.
    void DequeueAll(Ipv4Address dst, std::vector<QueueEntry>& out);

    /// Drop expired entries (firing their error callbacks).
    void Purge();

    uint32_t Size();

    /// Distinct destinations with at least one packet still waiting (issue #21:
    /// the reactive-retry timer re-floods discovery only for these). Purges
    /// expired entries first, so an aged-out destination is not retried.
    std::vector<Ipv4Address> PendingDestinations();

    /// Record a packet leaving the queue by *delivery* (the adapter forwarded
    /// it once a route appeared): attributes its total hold time to its reason
    /// (issue #21). Call once per packet, just before invoking its ucb.
    void NoteDelivered(const QueueEntry& e);

    /// Read-only hold-time attribution accumulated over the run (issue #21).
    const HoldStats& Stats() const { return m_stats; }

private:
    static Ipv4Address Dst(const QueueEntry& e) { return e.header.GetDestination(); }

    std::vector<QueueEntry> m_queue;
    uint32_t m_maxLen;
    Time m_timeout;
    HoldStats m_stats;
};

} // namespace anthocnet
} // namespace ns3

#endif // ANTHOCNET_RQUEUE_H
