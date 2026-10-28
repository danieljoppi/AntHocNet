// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/**
 * Shared ns-3 plumbing for the v2.5.0 adaptive-routing comparator arms (#563):
 * ARA (#586), Termite (#587) and tabular Q-routing (#588).
 *
 * This file holds no routing policy. It is what every per-hop, table-driven
 * arm needs from ns-3 and nothing else:
 *
 * - one UDP control socket per interface (unicast + subnet broadcast), on a
 *   port each arm chooses, so the harnesses count the arm's control traffic
 *   the way they count every other arm's (UDP not to the data port);
 * - the AODV-style deferred route: a packet with no next hop is bounced
 *   through loopback, held in a bounded per-node queue with its forwarding
 *   callbacks, and released when the arm learns a route (or dropped through
 *   the error callback, which FlowMonitor books as a route drop);
 * - the previous hop of every data packet (PrevHopTag, below), which each of
 *   the three papers reads and ns-3's RouteInput does not expose;
 * - a data packet ARP drops because its next hop never answered (the
 *   neighbour left) is the same link failure seen one layer earlier, and is
 *   recovered and re-routed the same way;
 * - MAC transmit failure (WifiMac "DroppedMpdu", retry limit) resolved to the
 *   failed neighbour's IP, with the dropped data packet recovered so the arm
 *   can re-route it — ARA §3.3 and Termite's route repair both resend a
 *   packet on a remaining link — counted for the harness's drop book.
 *
 * Each arm implements the policy hooks: SelectNextHop, the per-hop learning
 * (OnDataReceived / OnDataForwarded), discovery, control messages and the
 * reaction to a failed link.
 */
#ifndef ADAPTIVE_ROUTING_BASE_H
#define ADAPTIVE_ROUTING_BASE_H

#include "ns3/ipv4-interface-address.h"
#include "ns3/ipv4-l3-protocol.h"
#include "ns3/ipv4-routing-protocol.h"
#include "ns3/net-device.h"
#include "ns3/node.h"
#include "ns3/random-variable-stream.h"
#include "ns3/socket.h"
#include "ns3/tag.h"
#include "ns3/timer.h"
#include "ns3/traced-callback.h"
#include "ns3/wifi-mac.h"

#include <deque>
#include <map>
#include <set>

// ns-3 changed Ipv4RoutingProtocol::RouteInput's forwarding-callback parameters
// from by-value (<= ns-3.36) to const-reference (ns-3.37+), and renamed
// WifiMacQueueItem to WifiMpdu in the same release. The module's CMakeLists
// defines ADAPTIVE_NS3_ROUTEINPUT_BYVALUE for <= 3.36, but that definition is
// directory-scoped; an out-of-module includer (anthocnet-compare) probes the
// ns3/wifi-mpdu.h header instead, the gpsr/oracle pattern.
#if defined(ADAPTIVE_NS3_ROUTEINPUT_BYVALUE) || !__has_include("ns3/wifi-mpdu.h")
#define ADAPTIVE_RI_CB(T) T
#include "ns3/wifi-mac-queue-item.h"
#define ADAPTIVE_WIFI_MPDU ns3::WifiMacQueueItem
#else
#define ADAPTIVE_RI_CB(T) const T&
#include "ns3/wifi-mpdu.h"
#define ADAPTIVE_WIFI_MPDU ns3::WifiMpdu
#endif

namespace ns3 {
namespace adaptive {

/**
 * The IP address of the node that last transmitted this data packet.
 *
 * Every arm here learns per neighbour from data traffic (ARA §3.2: "the next
 * hop vj increases the pheromone value of the entry (vS, vi)"; Termite: the
 * pheromone of the link a packet arrived on; Q-routing: the estimate is sent
 * back to the sender). A real implementation reads the sender from the link
 * layer's source address. ns-3's RouteInput passes the incoming device but not
 * that address, so the sender stamps itself here before each transmission. A
 * packet tag is simulator metadata: it adds no bytes on the air, exactly like
 * the MAC source address it stands in for, which the frame carries anyway.
 */
class PrevHopTag : public Tag {
public:
    PrevHopTag() = default;
    PrevHopTag(Ipv4Address sender, Ipv4Address upstream, Ipv4Address next)
        : m_addr(sender), m_upstream(upstream), m_next(next) {}

    static TypeId GetTypeId();
    TypeId GetInstanceTypeId() const override;
    uint32_t GetSerializedSize() const override;
    void Serialize(TagBuffer i) const override;
    void Deserialize(TagBuffer i) override;
    void Print(std::ostream& os) const override;

    Ipv4Address Get() const { return m_addr; }

    /// The hop before the sender (Ipv4Address() at the source): lets a node
    /// that recovers its own packet from a MAC drop still send it back.
    Ipv4Address Upstream() const { return m_upstream; }

    /// The neighbour the sender handed the packet to: names the failed link
    /// when ARP drops the packet before it reaches the MAC.
    Ipv4Address Next() const { return m_next; }

private:
    Ipv4Address m_addr;
    Ipv4Address m_upstream;
    Ipv4Address m_next;
};

/**
 * A one-bit in-band flag on a data packet (ARA's DUPLICATE_ERROR and route
 * backtracking, §3.2–3.3: the packet itself travels back to the previous
 * node). The papers give no header format; the flag rides as a tag so the data
 * packet's bytes stay the application's, and the harness's flow accounting
 * reads it unchanged.
 */
class BacktrackTag : public Tag {
public:
    static TypeId GetTypeId();
    TypeId GetInstanceTypeId() const override;
    uint32_t GetSerializedSize() const override;
    void Serialize(TagBuffer i) const override;
    void Deserialize(TagBuffer i) override;
    void Print(std::ostream& os) const override;
};

class RoutingBase : public Ipv4RoutingProtocol {
public:
    static TypeId GetTypeId();
    RoutingBase();
    ~RoutingBase() override;

    /// Pins this arm's randomness (#352); returns the streams used.
    virtual int64_t AssignStreams(int64_t stream);

    /// Data packets recovered from a MAC retry-limit drop and re-routed: the
    /// harness's drop book subtracts them from the MAC column (#215).
    uint64_t MacReinjectedPackets() const { return m_macReinjected; }

    /// Data packets recovered from an ARP drop (the next hop never answered)
    /// and re-routed; the harness nets them out of the channel column.
    uint64_t ArpReinjectedPackets() const { return m_arpReinjected; }

    /// Fired for every packet recovered from a MAC drop (IP header, L4
    /// packet), so a harness can count the ones it classifies as data.
    typedef void (*MacReinjectCallback)(const Ipv4Header& header, Ptr<const Packet> packet);

    // Ipv4RoutingProtocol
    Ptr<Ipv4Route> RouteOutput(Ptr<Packet> p, const Ipv4Header& header, Ptr<NetDevice> oif,
                               Socket::SocketErrno& sockerr) override;
    bool RouteInput(Ptr<const Packet> p, const Ipv4Header& header, Ptr<const NetDevice> idev,
                    ADAPTIVE_RI_CB(UnicastForwardCallback) ucb,
                    ADAPTIVE_RI_CB(MulticastForwardCallback) mcb,
                    ADAPTIVE_RI_CB(LocalDeliverCallback) lcb,
                    ADAPTIVE_RI_CB(ErrorCallback) ecb) override;
    void NotifyInterfaceUp(uint32_t interface) override;
    void NotifyInterfaceDown(uint32_t interface) override;
    void NotifyAddAddress(uint32_t interface, Ipv4InterfaceAddress address) override;
    void NotifyRemoveAddress(uint32_t interface, Ipv4InterfaceAddress address) override;
    void SetIpv4(Ptr<Ipv4> ipv4) override;
    void PrintRoutingTable(Ptr<OutputStreamWrapper> stream,
                           Time::Unit unit = Time::S) const override;

protected:
    void DoInitialize() override;
    void DoDispose() override;

    // --- policy hooks (each arm) ---------------------------------------------

    /// The UDP port this arm's control messages use.
    virtual uint16_t ControlPort() const = 0;

    /**
     * Next hop for a data packet to `dst` that arrived from `prev`
     * (Ipv4Address() for a packet this node originates). Return
     * Ipv4Address() when the arm has no usable next hop.
     */
    virtual Ipv4Address SelectNextHop(Ipv4Address dst, Ipv4Address src, Ipv4Address prev,
                                      Ptr<const Packet> p) = 0;

    /**
     * A data packet from `src` arrived over the link from neighbour `prev`
     * (every hop, including the destination). Return false to discard it
     * (e.g. ARA's duplicate detection); the arm has then dealt with it.
     */
    virtual bool OnDataReceived(Ptr<const Packet> p, const Ipv4Header& header, Ipv4Address prev,
                                bool backtracked) = 0;

    /// A data packet to `dst` is being handed to neighbour `next`.
    virtual void OnDataForwarded(Ptr<const Packet> p, const Ipv4Header& header, Ipv4Address next) {}

    /**
     * A data packet to `dst` could not be routed at an intermediate node.
     * Return true if the arm disposed of it (e.g. sent it back); false lets
     * the base hold it in the queue and call StartDiscovery like at a source.
     */
    virtual bool OnNoRouteInTransit(Ptr<const Packet> p, const Ipv4Header& header, Ipv4Address prev,
                                    UnicastForwardCallback ucb, ErrorCallback ecb) {
        return false;
    }

    /// The queue holds data for `dst` and no route exists: look for one.
    virtual void StartDiscovery(Ipv4Address dst) = 0;

    /// A control message arrived from one-hop neighbour `from`.
    virtual void RecvControl(Ptr<Packet> p, Ipv4Address from, Ipv4Address receiver) = 0;

    /// The MAC gave up on a unicast to `neighbor`.
    virtual void OnLinkFailure(Ipv4Address neighbor) = 0;

    /// Neighbours the MAC-failure resolver may match against.
    virtual std::set<Ipv4Address> KnownNeighbors() const = 0;

    // --- services for the arms ----------------------------------------------

    /// One-hop broadcast of a control message on every interface.
    void BroadcastControl(Ptr<Packet> p);
    /// Broadcast after a uniform [0, maxJitter) delay (flood de-synchronisation).
    void BroadcastControlJittered(Ptr<Packet> p, Time maxJitter);
    /// One-hop unicast of a control message to a neighbour.
    void UnicastControl(Ptr<Packet> p, Ipv4Address neighbor);

    /// Forward a data packet to `next` (stamps the previous-hop tag).
    void ForwardData(Ptr<const Packet> p, const Ipv4Header& header, Ipv4Address next,
                     UnicastForwardCallback ucb, bool backtrack);

    /// Release every queued packet to `dst` that now has a next hop.
    void FlushQueue(Ipv4Address dst);
    /// FlushQueue for every destination with held packets.
    void FlushAll();
    /// Drop every queued packet to `dst` through its error callback.
    void DropQueued(Ipv4Address dst);
    bool HasQueued(Ipv4Address dst) const;

    Ipv4Address MainAddress() const;
    bool IsMyAddress(Ipv4Address a) const;
    Ptr<UniformRandomVariable> Rng() const { return m_rng; }

    /// The forwarding callback of the RouteInput call in progress.
    UnicastForwardCallback LastUcb() const { return m_cachedUcb; }

    uint32_t m_maxQueueLen;
    Time m_maxQueueTime;

private:
    struct QueueEntry {
        Ptr<const Packet> packet;
        Ipv4Header header;
        UnicastForwardCallback ucb;
        ErrorCallback ecb;
        Time expire;
    };

    Ptr<Ipv4Route> LoopbackRoute(const Ipv4Header& header, Ptr<NetDevice> oif) const;
    Ptr<Ipv4Route> DirectRoute(Ipv4Address dst, Ipv4Address next, Ipv4Address src) const;
    void Enqueue(Ptr<const Packet> p, const Ipv4Header& header, UnicastForwardCallback ucb,
                 ErrorCallback ecb);
    void PurgeQueue();
    void RecvSocket(Ptr<Socket> socket);
    void NotifyTxError(WifiMacDropReason reason, Ptr<const ADAPTIVE_WIFI_MPDU> mpdu);
    void NotifyArpDrop(Ptr<const Packet> packet);
    /// Route a recovered data packet again (alternative link, back, or hold).
    void Reroute(Ptr<Packet> pkt, const Ipv4Header& ip);
    bool MapMacToIp(const Mac48Address& mac, Ipv4Address& out) const;
    int32_t InterfaceTowards(Ipv4Address next) const;

    Ptr<Ipv4> m_ipv4;
    Ptr<NetDevice> m_lo;
    std::map<Ptr<Socket>, Ipv4InterfaceAddress> m_sockets;
    std::map<Ptr<Socket>, Ipv4InterfaceAddress> m_bcastSockets;
    std::deque<QueueEntry> m_queue;
    Timer m_purgeTimer;
    Ptr<UniformRandomVariable> m_rng;
    /// Set across a control SendTo, so RouteOutput answers with a one-hop
    /// route to the neighbour rather than consulting the data policy.
    Ipv4Address m_directTo;
    UnicastForwardCallback m_cachedUcb;
    ErrorCallback m_cachedEcb;
    uint64_t m_macReinjected;
    uint64_t m_arpReinjected;
    bool m_arpHooked;
    TracedCallback<const Ipv4Header&, Ptr<const Packet>> m_macReinjectTrace;
    TracedCallback<const Ipv4Header&, Ptr<const Packet>> m_arpReinjectTrace;
};

}  // namespace adaptive
}  // namespace ns3

#endif  // ADAPTIVE_ROUTING_BASE_H
