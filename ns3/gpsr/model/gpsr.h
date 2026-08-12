/* -*- Mode:C++; c-file-style:"gnu"; indent-tabs-mode:nil; -*- */
// SPDX-License-Identifier: GPL-2.0-only
// Copyright (c) 2011 António Fonseca <afonseca@tagus.inesc-id.pt> (original ns-3 GPSR port)
// Copyright (C) 2026 Daniel Henrique Joppi (ns-3.36–3.48 port for AntHocNet #296)
/*
 * GPSR (Greedy Perimeter Stateless Routing, Karp & Kung, MobiCom 2000).
 *
 * Vendored baseline for the AntHocNet comparison harness (#296 item 3) from
 * https://github.com/dwosion/ns3.29-with-gpsr
 * commit 15241ef715d52627ff7679a5fca6b6d15eaa8cd4, path ns-3.29/src/gpsr —
 * the Fonseca GPSR lineage (https://codereview.appspot.com/5401042), GPLv2.
 * Full provenance and the list of port changes: ns3/gpsr/README.md.
 *
 * Port changes in this file:
 *  - inlined the GOD location service (NodeList + MobilityModel scan) so the
 *    separate location-service module is not vendored; the LocationServiceName
 *    attribute (GOD was the only implemented value) is gone with it;
 *  - AssignStreams() added (#352 stream pinning);
 *  - NotifyTxError() added: the removed WifiMac "TxErrHeader" trace is
 *    replaced by the modern "DroppedMpdu" MAC-failure path;
 *  - the down-target position-header hack now keeps the UDP header on top of
 *    the IP payload (IP|UDP|GPSR instead of IP|GPSR|UDP) so FlowMonitor's
 *    Ipv4FlowClassifier reads real ports — see AddHeaders in gpsr.cc.
 */
#ifndef GPSR_H
#define GPSR_H

#include "gpsr-ptable.h"
#include "ns3/node.h"
#include "gpsr-packet.h"
#include "ns3/ipv4-routing-protocol.h"
#include "ns3/ipv4-interface.h"
#include "ns3/ipv4-l3-protocol.h"
#include "ns3/ip-l4-protocol.h"
#include "ns3/mobility-model.h"
#include "gpsr-rqueue.h"

#include "ns3/ipv4-header.h"
#include "ns3/ipv4-address.h"
#include "ns3/ipv4-route.h"
#include "ns3/udp-header.h"
#include "ns3/random-variable-stream.h"
#include "ns3/wifi-mac.h"

#include <map>
#include <complex>

// ns-3 renamed WifiMacQueueItem -> WifiMpdu (and wifi-mac-queue-item.h ->
// wifi-mpdu.h) in ns-3.37; the WifiMac "DroppedMpdu" trace carries this type.
// GPSR_NS3_WIFI_QUEUE_ITEM is defined by the module's CMakeLists for
// ns-3 <= 3.36; default to the modern name. Same pattern as the anthocnet
// module's ANTHOCNET_NS3_WIFI_QUEUE_ITEM gate.
#ifdef GPSR_NS3_WIFI_QUEUE_ITEM
#include "ns3/wifi-mac-queue-item.h"
#define GPSR_WIFI_MPDU ns3::WifiMacQueueItem
#else
#include "ns3/wifi-mpdu.h"
#define GPSR_WIFI_MPDU ns3::WifiMpdu
#endif

// ns-3 changed Ipv4RoutingProtocol::RouteInput's forwarding-callback parameters
// from by-value (<= ns-3.36) to const-reference (ns-3.37+). The override must
// match exactly or the class stays abstract. GPSR_NS3_ROUTEINPUT_BYVALUE is
// defined by the module's CMakeLists for ns-3 <= 3.36; default to const-ref.
#ifdef GPSR_NS3_ROUTEINPUT_BYVALUE
#define GPSR_RI_CB(T) T
#else
#define GPSR_RI_CB(T) const T&
#endif

namespace ns3 {
namespace gpsr {
/**
 * \ingroup gpsr
 *
 * \brief GPSR routing protocol
 */
class RoutingProtocol : public Ipv4RoutingProtocol
{
public:
  static TypeId GetTypeId (void);
  static const uint32_t GPSR_PORT;

  /// c-tor
  RoutingProtocol ();
  virtual ~RoutingProtocol ();
  virtual void DoDispose ();


  ///\name From Ipv4RoutingProtocol
  //
  //
  Ptr<Ipv4Route> RouteOutput (Ptr<Packet> p, const Ipv4Header &header, Ptr<NetDevice> oif, Socket::SocketErrno &sockerr);
  bool RouteInput (Ptr<const Packet> p, const Ipv4Header &header, Ptr<const NetDevice> idev,
                   GPSR_RI_CB (UnicastForwardCallback) ucb, GPSR_RI_CB (MulticastForwardCallback) mcb,
                   GPSR_RI_CB (LocalDeliverCallback) lcb, GPSR_RI_CB (ErrorCallback) ecb);
  virtual void NotifyInterfaceUp (uint32_t interface);
  int GetProtocolNumber (void) const;
  virtual void AddHeaders (Ptr<Packet> p, Ipv4Address source, Ipv4Address destination, uint8_t protocol, Ptr<Ipv4Route> route);
  virtual void NotifyInterfaceDown (uint32_t interface);
  virtual void NotifyAddAddress (uint32_t interface, Ipv4InterfaceAddress address);
  virtual void NotifyRemoveAddress (uint32_t interface, Ipv4InterfaceAddress address);
  virtual void SetIpv4 (Ptr<Ipv4> ipv4);
  virtual void RecvGPSR (Ptr<Socket> socket);
  virtual void UpdateRouteToNeighbor (Ipv4Address sender, Ipv4Address receiver, Vector Pos);
  virtual void SendHello ();
  virtual bool IsMyOwnAddress (Ipv4Address src);

  Ptr<Ipv4> m_ipv4;
  /// Raw socket per each IP interface, map socket -> iface address (IP + mask)
  std::map< Ptr<Socket>, Ipv4InterfaceAddress > m_socketAddresses;
  /// Loopback device used to defer RREQ until packet will be fully formed
  Ptr<NetDevice> m_lo;

  /// Broadcast ID
  uint32_t m_requestId;
  /// Request sequence number
  uint32_t m_seqNo;



  /// Number of RREQs used for RREQ rate control
  uint16_t m_rreqCount;
  Time HelloInterval;

  void SetDownTarget (IpL4Protocol::DownTargetCallback callback);
  IpL4Protocol::DownTargetCallback GetDownTarget (void) const;

  /**
   * #352 stream pinning (port addition): fix the stream numbers of this
   * protocol's random variables (the hello jitter) so a run's realisation is
   * a function of the seed alone. Mirrors aodv/olsr::RoutingProtocol.
   * \return the number of stream indices assigned (1)
   */
  int64_t AssignStreams (int64_t stream);

  virtual void PrintRoutingTable (ns3::Ptr<ns3::OutputStreamWrapper>, Time::Unit unit = Time::S) const
  {
    return;
  }

private:
  /// Start protocol operation
  void Start ();
  /// Queue packet and send route request
  void DeferredRouteOutput (Ptr<const Packet> p, const Ipv4Header & header, UnicastForwardCallback ucb, ErrorCallback ecb);
  /// If route exists and valid, forward packet.
  void HelloTimerExpire ();

  /// Queue packet and send route request
  Ptr<Ipv4Route> LoopbackRoute (const Ipv4Header & header, Ptr<NetDevice> oif);

  /// If route exists and valid, forward packet.
  bool Forwarding (Ptr<const Packet> p, const Ipv4Header & header, UnicastForwardCallback ucb, ErrorCallback ecb);

  /// Find socket with local interface address iface
  Ptr<Socket> FindSocketWithInterfaceAddress (Ipv4InterfaceAddress iface) const;

  //Check packet from deffered route output queue and send if position is already available
//returns true if the IP should be erased from the list (was sent/droped)
  bool SendPacketFromQueue (Ipv4Address dst);

  //Calls SendPacketFromQueue and re-schedules
  void CheckQueue ();

  void RecoveryMode(Ipv4Address dst, Ptr<Packet> p, UnicastForwardCallback ucb, Ipv4Header header);

  /**
   * GOD location service, inlined (port change): every node reads any node's
   * true position straight from its MobilityModel via the NodeList — exactly
   * what the vendored tree's separate location-service module did, without
   * carrying that module. Returns (-1,-1,0) for an unknown address.
   */
  Vector GetGodPosition (Ipv4Address adr) const;

  /**
   * Fault-3 rework helpers (port addition). GPSR carries a per-packet
   * position header on data packets. The vendored code injected it *above*
   * the transport header (wire: IP|GPSR|UDP) via the re-pointed UDP down
   * target, which breaks FlowMonitor: Ipv4FlowClassifier reads the first four
   * bytes of the IP payload as ports, so every data packet classified on
   * position bytes that change as nodes move. The port keeps the same bytes
   * on the wire but layers them IP|UDP|GPSR: StripTransport removes the UDP
   * header when the IP protocol is UDP (the only transport the down-target
   * hook wraps), the GPSR headers are edited beneath it, and RestoreTransport
   * puts the same UDP header back (ns-3's UdpHeader recomputes its length
   * field from the buffer at serialize time). Requires the default
   * ChecksumEnabled=false (re-adding does not refresh a stored checksum).
   * \return true iff the UDP header was removed (protocol was UDP and the
   *         packet was long enough)
   */
  bool StripTransport (Ptr<Packet> p, uint8_t protocol, UdpHeader &udp) const;
  void RestoreTransport (Ptr<Packet> p, const UdpHeader &udp, bool stripped) const;

  /**
   * Fault-1 rework (port addition): the vendored code subscribed
   * PositionTable's callback to the WifiMac "TxErrHeader" trace, which ns-3
   * removed; the handler body was an empty stub besides. This is the modern
   * "DroppedMpdu" MAC-failure path: a unicast frame dropped for
   * WIFI_MAC_DROP_REACHED_RETRY_LIMIT names a dead neighbour, which is
   * resolved MAC->IP through the ARP caches (forward Lookup per known
   * neighbour — ArpCache::LookupInverse's signature drifts across ns-3
   * versions) and removed from the position table, per GPSR §3.2 (Karp &
   * Kung 2000: MAC-layer feedback removes unreachable neighbours).
   */
  void NotifyTxError (WifiMacDropReason reason, Ptr<const GPSR_WIFI_MPDU> mpdu);

  uint32_t MaxQueueLen;                  ///< The maximum number of packets that we allow a routing protocol to buffer.
  Time MaxQueueTime;                     ///< The maximum period of time that a routing protocol is allowed to buffer a packet for.
  RequestQueue m_queue;

  Timer HelloIntervalTimer;
  Timer CheckQueueTimer;
  PositionTable m_neighbors;
  bool PerimeterMode;
  std::list<Ipv4Address> m_queuedAddresses;

  /// #352 (port addition): one pinnable RNG for the hello jitter instead of
  /// the vendored per-call UniformRandomVariable constructions, whose stream
  /// numbers depended on how many draws preceded them in the process.
  Ptr<UniformRandomVariable> m_uniformRandomVariable;

  IpL4Protocol::DownTargetCallback m_downTarget;



};
}
}
#endif /* GPSRROUTINGPROTOCOL_H */
