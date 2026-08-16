/* -*- Mode:C++; c-file-style:"gnu"; indent-tabs-mode:nil; -*- */
// SPDX-License-Identifier: GPL-2.0-only
// Copyright (c) 2011 António Fonseca <afonseca@tagus.inesc-id.pt> (original ns-3 GPSR port)
// Copyright (C) 2026 Daniel Henrique Joppi (ns-3.36–3.48 port for AntHocNet #296)
/*
 * GPSR. Vendored from https://github.com/dwosion/ns3.29-with-gpsr
 * commit 15241ef715d52627ff7679a5fca6b6d15eaa8cd4, path ns-3.29/src/gpsr.
 * Provenance and the list of port changes: ns3/gpsr/README.md and gpsr.h.
 */
#define NS_LOG_APPEND_CONTEXT                                           \
  if (m_ipv4) { std::clog << "[node " << m_ipv4->GetObject<Node> ()->GetId () << "] "; }

#include "gpsr.h"
#include "ns3/log.h"
#include "ns3/boolean.h"
#include "ns3/random-variable-stream.h"
#include "ns3/inet-socket-address.h"
#include "ns3/trace-source-accessor.h"
#include "ns3/udp-socket-factory.h"
#include "ns3/udp-l4-protocol.h"
#include "ns3/wifi-net-device.h"
#include "ns3/arp-cache.h"
#include "ns3/node-list.h"
#include "ns3/double.h"
#include "ns3/uinteger.h"
#include <algorithm>
#include <limits>

namespace ns3 {
NS_LOG_COMPONENT_DEFINE ("GpsrRoutingProtocol");
namespace gpsr {



struct DeferredRouteOutputTag : public Tag
{
  /// Positive if output device is fixed in RouteOutput
  uint32_t m_isCallFromL3;

  DeferredRouteOutputTag () : Tag (),
                              m_isCallFromL3 (0)
  {
  }

  static TypeId GetTypeId ()
  {
    static TypeId tid = TypeId ("ns3::gpsr::DeferredRouteOutputTag").SetParent<Tag> ();
    return tid;
  }

  TypeId  GetInstanceTypeId () const
  {
    return GetTypeId ();
  }

  uint32_t GetSerializedSize () const
  {
    return sizeof(uint32_t);
  }

  void  Serialize (TagBuffer i) const
  {
    i.WriteU32 (m_isCallFromL3);
  }

  void  Deserialize (TagBuffer i)
  {
    m_isCallFromL3 = i.ReadU32 ();
  }

  void  Print (std::ostream &os) const
  {
    os << "DeferredRouteOutputTag: m_isCallFromL3 = " << m_isCallFromL3;
  }
};



/********** Miscellaneous constants **********/

/// Maximum allowed jitter.
#define GPSR_MAXJITTER          (HelloInterval.GetSeconds () / 2)



NS_OBJECT_ENSURE_REGISTERED (RoutingProtocol);

/// UDP Port for GPSR control traffic, not defined by IANA yet
const uint32_t RoutingProtocol::GPSR_PORT = 666;

RoutingProtocol::RoutingProtocol ()
  : HelloInterval (Seconds (1)),
    MaxQueueLen (64),
    MaxQueueTime (Seconds (30)),
    m_queue (MaxQueueLen, MaxQueueTime),
    HelloIntervalTimer (Timer::CANCEL_ON_DESTROY),
    CheckQueueTimer (Timer::CANCEL_ON_DESTROY),
    PerimeterMode (false)
{
  m_neighbors = PositionTable ();
  // #352 (port change): one member RNG, pinnable via AssignStreams, replaces
  // the vendored per-call UniformRandomVariable constructions.
  m_uniformRandomVariable = CreateObject<UniformRandomVariable> ();
}

TypeId
RoutingProtocol::GetTypeId (void)
{
  static TypeId tid = TypeId ("ns3::gpsr::RoutingProtocol")
    .SetParent<Ipv4RoutingProtocol> ()
    .AddConstructor<RoutingProtocol> ()
    .AddAttribute ("HelloInterval", "HELLO messages emission interval.",
                   TimeValue (Seconds (1)),
                   MakeTimeAccessor (&RoutingProtocol::HelloInterval),
                   MakeTimeChecker ())
    // Port change: the vendored LocationServiceName enum attribute is gone —
    // GOD (the only implemented value) is inlined; see GetGodPosition.
    .AddAttribute ("PerimeterMode", "Indicates if PerimeterMode is enabled",
                   BooleanValue (false),
                   MakeBooleanAccessor (&RoutingProtocol::PerimeterMode),
                   MakeBooleanChecker ())
  ;
  return tid;
}

RoutingProtocol::~RoutingProtocol ()
{
}

void
RoutingProtocol::DoDispose ()
{
  m_ipv4 = 0;
  m_downTarget = IpL4Protocol::DownTargetCallback ();
  Ipv4RoutingProtocol::DoDispose ();
}

int64_t
RoutingProtocol::AssignStreams (int64_t stream)
{
  NS_LOG_FUNCTION (this << stream);
  m_uniformRandomVariable->SetStream (stream);
  return 1;
}

Vector
RoutingProtocol::GetGodPosition (Ipv4Address adr) const
{
  // GOD location service, inlined (port change; the vendored tree's
  // GodLocationService::GetPosition did this same NodeList scan).
  for (NodeList::Iterator i = NodeList::Begin (); i != NodeList::End (); i++)
    {
      Ptr<Node> node = *i;
      Ptr<Ipv4> ipv4 = node->GetObject<Ipv4> ();
      if (ipv4 && ipv4->GetNInterfaces () > 1
          && ipv4->GetAddress (1, 0).GetLocal () == adr)
        {
          Ptr<MobilityModel> mm = node->GetObject<MobilityModel> ();
          if (mm)
            {
              return mm->GetPosition ();
            }
        }
    }
  return PositionTable::GetInvalidPosition ();
}

bool
RoutingProtocol::StripTransport (Ptr<Packet> p, uint8_t protocol, UdpHeader &udp) const
{
  // Only UDP is wrapped by the down-target hook (GpsrHelper::Install re-points
  // UdpL4Protocol alone), so only UDP carries GPSR headers beneath it.
  if (protocol != UdpL4Protocol::PROT_NUMBER)
    {
      return false;
    }
  if (p->GetSize () < 8)
    {
      return false;
    }
  p->RemoveHeader (udp);
  return true;
}

void
RoutingProtocol::RestoreTransport (Ptr<Packet> p, const UdpHeader &udp, bool stripped) const
{
  if (stripped)
    {
      // Re-serialization recomputes the UDP length from the buffer, so the
      // header stays consistent after the GPSR headers beneath it changed
      // size or content. Checksums must stay globally disabled (ns-3
      // default): the stored checksum is not refreshed here.
      p->AddHeader (udp);
    }
}

bool RoutingProtocol::RouteInput (Ptr<const Packet> p, const Ipv4Header &header, Ptr<const NetDevice> idev,
                                  GPSR_RI_CB (UnicastForwardCallback) ucb, GPSR_RI_CB (MulticastForwardCallback) mcb,
                                  GPSR_RI_CB (LocalDeliverCallback) lcb, GPSR_RI_CB (ErrorCallback) ecb)
{

NS_LOG_FUNCTION (this << p->GetUid () << header.GetDestination () << idev->GetAddress ());
  if (m_socketAddresses.empty ())
    {
      NS_LOG_LOGIC ("No gpsr interfaces");
      return false;
    }
  NS_ASSERT (m_ipv4);
  NS_ASSERT (p);
  // Check if input device supports IP
  NS_ASSERT (m_ipv4->GetInterfaceForDevice (idev) >= 0);
  int32_t iif = m_ipv4->GetInterfaceForDevice (idev);
  Ipv4Address dst = header.GetDestination ();
  Ipv4Address origin = header.GetSource ();

  DeferredRouteOutputTag tag; //FIXME since I have to check if it's in origin for it to work it means I'm not taking some tag out...
  if (p->PeekPacketTag (tag) && IsMyOwnAddress (origin))
    {
      Ptr<Packet> packet = p->Copy (); //FIXME ja estou a abusar de tirar tags
      packet->RemovePacketTag(tag);
      DeferredRouteOutput (packet, header, ucb, ecb);
      return true;
    }



  if (m_ipv4->IsDestinationAddress (dst, iif))
    {

      Ptr<Packet> packet = p->Copy ();
      // Fault-3 rework: the GPSR headers now sit *beneath* the UDP header
      // (IP|UDP|GPSR); peel the UDP header off, strip them, put it back, so
      // the application receives the datagram it was sent.
      UdpHeader udpHeader;
      const bool hasUdp = StripTransport (packet, header.GetProtocol (), udpHeader);
      if (hasUdp && packet->GetSize () >= 1)
        {
          TypeHeader tHeader (GPSRTYPE_POS);
          packet->RemoveHeader (tHeader);
          if (!tHeader.IsValid ())
            {
              NS_LOG_DEBUG ("GPSR message " << packet->GetUid () << " with unknown type received: " << tHeader.Get () << ". Ignored");
              return false;
            }

          if (tHeader.Get () == GPSRTYPE_POS)
            {
              PositionHeader phdr;
              packet->RemoveHeader (phdr);
            }
          RestoreTransport (packet, udpHeader, hasUdp);
        }
      else
        {
          RestoreTransport (packet, udpHeader, hasUdp);
        }

      if (dst != m_ipv4->GetAddress (1, 0).GetBroadcast ())
        {
          NS_LOG_LOGIC ("Unicast local delivery to " << dst);
        }
      else
        {
//          NS_LOG_LOGIC ("Broadcast local delivery to " << dst);
        }

      lcb (packet, header, iif);
      return true;
    }


  return Forwarding (p, header, ucb, ecb);
}


void
RoutingProtocol::DeferredRouteOutput (Ptr<const Packet> p, const Ipv4Header & header,
                                      UnicastForwardCallback ucb, ErrorCallback ecb)
{
  NS_LOG_FUNCTION (this << p << header);
  NS_ASSERT (p && p != Ptr<Packet> ());

  if (m_queue.GetSize () == 0)
    {
      CheckQueueTimer.Cancel ();
      CheckQueueTimer.Schedule (Time ("500ms"));
    }

  QueueEntry newEntry (p, header, ucb, ecb);
  bool result = m_queue.Enqueue (newEntry);


  m_queuedAddresses.insert (m_queuedAddresses.begin (), header.GetDestination ());
  m_queuedAddresses.unique ();

  if (result)
    {
      NS_LOG_LOGIC ("Add packet " << p->GetUid () << " to queue. Protocol " << (uint16_t) header.GetProtocol ());

    }

}

void
RoutingProtocol::CheckQueue ()
{

  CheckQueueTimer.Cancel ();

  std::list<Ipv4Address> toRemove;

  for (std::list<Ipv4Address>::iterator i = m_queuedAddresses.begin (); i != m_queuedAddresses.end (); ++i)
    {
      if (SendPacketFromQueue (*i))
        {
          //Insert in a list to remove later
          toRemove.insert (toRemove.begin (), *i);
        }
    }

  //remove all that are on the list
  for (std::list<Ipv4Address>::iterator i = toRemove.begin (); i != toRemove.end (); ++i)
    {
      m_queuedAddresses.remove (*i);
    }

  if (!m_queuedAddresses.empty ()) //Only need to schedule if the queue is not empty
    {
      CheckQueueTimer.Schedule (Time ("500ms"));
    }
}

bool
RoutingProtocol::SendPacketFromQueue (Ipv4Address dst)
{
  NS_LOG_FUNCTION (this);
  bool recovery = false;
  QueueEntry queueEntry;

  // GOD location service (port change): a position always exists for a known
  // address and there is never a pending lookup, so the vendored IsInSearch /
  // HasPosition gates collapse; only an unknown destination drops the queue.
  if (CalculateDistance (GetGodPosition (dst), PositionTable::GetInvalidPosition ()) == 0)
    {
      m_queue.DropPacketWithDst (dst);
      NS_LOG_LOGIC ("Location Service did not find dst. Drop packet to " << dst);
      return true;
    }

  Vector myPos;

  Ptr<MobilityModel> MM = m_ipv4->GetObject<MobilityModel> ();
  myPos.x = MM->GetPosition ().x;
  myPos.y = MM->GetPosition ().y;
  Ipv4Address nextHop;

  if(m_neighbors.isNeighbour (dst))
    {
      nextHop = dst;
    }
  else{
    Vector dstPos = GetGodPosition (dst);
    nextHop = m_neighbors.BestNeighbor (dstPos, myPos);
    if (nextHop == Ipv4Address::GetZero ())
      {
        NS_LOG_LOGIC ("Fallback to recovery-mode. Packets to " << dst);
        recovery = true;
      }
    if(recovery)
      {

        Vector Position;
        uint32_t updated = 0;

        while(m_queue.Dequeue (dst, queueEntry))
          {
            Ptr<Packet> p = ConstCast<Packet> (queueEntry.GetPacket ());
            UnicastForwardCallback ucb = queueEntry.GetUnicastForwardCallback ();
            Ipv4Header header = queueEntry.GetIpv4Header ();

            // Fault-3 rework: the GPSR headers sit beneath the UDP header.
            UdpHeader udpHeader;
            const bool hasUdp = StripTransport (p, header.GetProtocol (), udpHeader);
            if (!hasUdp || p->GetSize () < 1)
              {
                // No GPSR headers were ever added (non-UDP packet): recovery
                // state cannot travel with it; drop it as routeless.
                RestoreTransport (p, udpHeader, hasUdp);
                queueEntry.GetErrorCallback () (p, header, Socket::ERROR_NOROUTETOHOST);
                continue;
              }
            TypeHeader tHeader (GPSRTYPE_POS);
            p->RemoveHeader (tHeader);
            if (!tHeader.IsValid ())
              {
                NS_LOG_DEBUG ("GPSR message " << p->GetUid () << " with unknown type received: " << tHeader.Get () << ". Drop");
                return false;     // drop
              }
            if (tHeader.Get () == GPSRTYPE_POS)
              {
                PositionHeader hdr;
                p->RemoveHeader (hdr);
                Position.x = hdr.GetDstPosx ();
                Position.y = hdr.GetDstPosy ();
                updated = hdr.GetUpdated ();
              }

            PositionHeader posHeader (Position.x, Position.y,  updated, myPos.x, myPos.y, (uint8_t) 1, Position.x, Position.y);
            p->AddHeader (posHeader); //enters in recovery with last edge from Dst
            p->AddHeader (tHeader);
            RestoreTransport (p, udpHeader, hasUdp);

            RecoveryMode(dst, p, ucb, header);
          }
        return true;
      }
  }
  Ptr<Ipv4Route> route = Create<Ipv4Route> ();
  route->SetDestination (dst);
  route->SetGateway (nextHop);

  // FIXME: Does not work for multiple interfaces
  route->SetOutputDevice (m_ipv4->GetNetDevice (1));

  while (m_queue.Dequeue (dst, queueEntry))
    {
      DeferredRouteOutputTag tag;
      Ptr<Packet> p = ConstCast<Packet> (queueEntry.GetPacket ());

      UnicastForwardCallback ucb = queueEntry.GetUnicastForwardCallback ();
      Ipv4Header header = queueEntry.GetIpv4Header ();

      if (header.GetSource () == Ipv4Address ("102.102.102.102"))
        {
          route->SetSource (m_ipv4->GetAddress (1, 0).GetLocal ());
          header.SetSource (m_ipv4->GetAddress (1, 0).GetLocal ());
        }
      else
        {
          route->SetSource (header.GetSource ());
        }
      ucb (route, p, header);
    }
  return true;
}


void
RoutingProtocol::RecoveryMode(Ipv4Address dst, Ptr<Packet> p, UnicastForwardCallback ucb, Ipv4Header header){

  Vector Position;
  Vector previousHop;
  uint32_t updated = 0;
  uint64_t positionX;
  uint64_t positionY;
  Vector myPos;
  Vector recPos;

  Ptr<MobilityModel> MM = m_ipv4->GetObject<MobilityModel> ();
  positionX = MM->GetPosition ().x;
  positionY = MM->GetPosition ().y;
  myPos.x = positionX;
  myPos.y = positionY;

  // Fault-3 rework: the GPSR headers sit beneath the UDP header. RecoveryMode
  // is only ever entered with a GPSR-headered (UDP) packet — Forwarding and
  // SendPacketFromQueue route non-UDP packets greedily or drop them.
  UdpHeader udpHeader;
  const bool hasUdp = StripTransport (p, header.GetProtocol (), udpHeader);
  if (!hasUdp)
    {
      NS_LOG_DEBUG ("RecoveryMode without a transport-wrapped GPSR packet " << p->GetUid () << ". Drop");
      return;     // drop
    }

  TypeHeader tHeader (GPSRTYPE_POS);
  p->RemoveHeader (tHeader);
  if (!tHeader.IsValid ())
    {
      NS_LOG_DEBUG ("GPSR message " << p->GetUid () << " with unknown type received: " << tHeader.Get () << ". Drop");
      return;     // drop
    }
  if (tHeader.Get () == GPSRTYPE_POS)
    {
      PositionHeader hdr;
      p->RemoveHeader (hdr);
      Position.x = hdr.GetDstPosx ();
      Position.y = hdr.GetDstPosy ();
      updated = hdr.GetUpdated ();
      recPos.x = hdr.GetRecPosx ();
      recPos.y = hdr.GetRecPosy ();
      previousHop.x = hdr.GetLastPosx ();
      previousHop.y = hdr.GetLastPosy ();
   }

  PositionHeader posHeader (Position.x, Position.y,  updated, recPos.x, recPos.y, (uint8_t) 1, myPos.x, myPos.y);
  p->AddHeader (posHeader);
  p->AddHeader (tHeader);
  RestoreTransport (p, udpHeader, hasUdp);



  Ipv4Address nextHop = m_neighbors.BestAngle (previousHop, myPos);
  if (nextHop == Ipv4Address::GetZero ())
    {
      return;
    }

  Ptr<Ipv4Route> route = Create<Ipv4Route> ();
  route->SetDestination (dst);
  route->SetGateway (nextHop);

  // FIXME: Does not work for multiple interfaces
  route->SetOutputDevice (m_ipv4->GetNetDevice (1));
  route->SetSource (header.GetSource ());

  NS_LOG_LOGIC (route->GetOutputDevice () << " forwarding in Recovery to " << dst << " through " << route->GetGateway () << " packet " << p->GetUid ());
  ucb (route, p, header);
  return;
}


void
RoutingProtocol::NotifyInterfaceUp (uint32_t interface)
{
  NS_LOG_FUNCTION (this << m_ipv4->GetAddress (interface, 0).GetLocal ());
  Ptr<Ipv4L3Protocol> l3 = m_ipv4->GetObject<Ipv4L3Protocol> ();
  if (l3->GetNAddresses (interface) > 1)
    {
      NS_LOG_WARN ("GPSR does not work with more then one address per each interface.");
    }
  Ipv4InterfaceAddress iface = l3->GetAddress (interface, 0);
  if (iface.GetLocal () == Ipv4Address ("127.0.0.1"))
    {
      return;
    }

  // Create a socket to listen only on this interface
  Ptr<Socket> socket = Socket::CreateSocket (GetObject<Node> (),
                                             UdpSocketFactory::GetTypeId ());
  NS_ASSERT (socket);
  socket->SetRecvCallback (MakeCallback (&RoutingProtocol::RecvGPSR, this));
  socket->Bind (InetSocketAddress (Ipv4Address::GetAny (), GPSR_PORT));
  socket->BindToNetDevice (l3->GetNetDevice (interface));
  socket->SetAllowBroadcast (true);
  socket->SetAttribute ("IpTtl", UintegerValue (1));
  m_socketAddresses.insert (std::make_pair (socket, iface));


  // Allow neighbor manager use this interface for layer 2 feedback if possible
  // Fault-1 rework: subscribe to the modern WifiMac "DroppedMpdu" trace (the
  // vendored "TxErrHeader" trace was removed from ns-3). TraceConnect returns
  // false if the source is absent on this ns-3 release; tolerated — neighbour
  // liveness then rests on the hello-lifetime purge alone.
  Ptr<NetDevice> dev = m_ipv4->GetNetDevice (m_ipv4->GetInterfaceForAddress (iface.GetLocal ()));
  Ptr<WifiNetDevice> wifi = dev->GetObject<WifiNetDevice> ();
  if (!wifi)
    {
      return;
    }
  Ptr<WifiMac> mac = wifi->GetMac ();
  if (!mac)
    {
      return;
    }

  mac->TraceConnectWithoutContext ("DroppedMpdu",
                                   MakeCallback (&RoutingProtocol::NotifyTxError, this));

}


void
RoutingProtocol::NotifyTxError (WifiMacDropReason reason, Ptr<const GPSR_WIFI_MPDU> mpdu)
{
  if (!m_ipv4 || m_socketAddresses.empty () || !mpdu)
    {
      return;
    }
  // Only a retry-limit drop is a real broken link; other drop reasons
  // (queue full, lifetime expiry) are congestion, not topology.
  if (reason != WIFI_MAC_DROP_REACHED_RETRY_LIMIT)
    {
      return;
    }
  const Mac48Address dstMac = mpdu->GetHeader ().GetAddr1 ();
  if (dstMac.IsBroadcast () || dstMac.IsGroup ())
    {
      return;   // no single next hop failed
    }
  Ptr<Ipv4L3Protocol> l3 = m_ipv4->GetObject<Ipv4L3Protocol> ();
  if (!l3)
    {
      return;
    }
  // Resolve the failed next-hop MAC to an IP by forward-looking each known
  // neighbour in the per-interface ARP caches (ArpCache::LookupInverse's
  // return type drifts across ns-3 versions; forward Lookup is stable).
  std::vector<Ipv4Address> neighbours = m_neighbors.GetKnownNeighbors ();
  for (uint32_t i = 0; i < l3->GetNInterfaces (); ++i)
    {
      Ptr<ArpCache> cache = l3->GetInterface (i)->GetArpCache ();
      if (!cache)
        {
          continue;
        }
      for (std::vector<Ipv4Address>::const_iterator nb = neighbours.begin ();
           nb != neighbours.end (); ++nb)
        {
          ArpCache::Entry *entry = cache->Lookup (*nb);
          if (entry == 0)
            {
              continue;
            }
          // An entry still resolving carries no MAC yet; guard ConvertFrom,
          // which asserts on a non-48-bit address.
          const Address resolved = entry->GetMacAddress ();
          if (Mac48Address::IsMatchingType (resolved)
              && Mac48Address::ConvertFrom (resolved) == dstMac)
            {
              NS_LOG_LOGIC ("MAC tx failure to neighbour " << *nb << "; removing from position table");
              m_neighbors.DeleteEntry (*nb);
              return;
            }
        }
    }
}


void
RoutingProtocol::RecvGPSR (Ptr<Socket> socket)
{
  NS_LOG_FUNCTION (this << socket);
  Address sourceAddress;
  Ptr<Packet> packet = socket->RecvFrom (sourceAddress);

  TypeHeader tHeader (GPSRTYPE_HELLO);
  packet->RemoveHeader (tHeader);
  if (!tHeader.IsValid ())
    {
      NS_LOG_DEBUG ("GPSR message " << packet->GetUid () << " with unknown type received: " << tHeader.Get () << ". Ignored");
      return;
    }

  HelloHeader hdr;
  packet->RemoveHeader (hdr);
  Vector Position;
  Position.x = hdr.GetOriginPosx ();
  Position.y = hdr.GetOriginPosy ();
  InetSocketAddress inetSourceAddr = InetSocketAddress::ConvertFrom (sourceAddress);
  Ipv4Address sender = inetSourceAddr.GetIpv4 ();
  Ipv4Address receiver = m_socketAddresses[socket].GetLocal ();

  UpdateRouteToNeighbor (sender, receiver, Position);

}


void
RoutingProtocol::UpdateRouteToNeighbor (Ipv4Address sender, Ipv4Address receiver, Vector Pos)
{
  m_neighbors.AddEntry (sender, Pos);

}



void
RoutingProtocol::NotifyInterfaceDown (uint32_t interface)
{
  NS_LOG_FUNCTION (this << m_ipv4->GetAddress (interface, 0).GetLocal ());

  // Disable layer 2 link state monitoring (if possible)
  Ptr<Ipv4L3Protocol> l3 = m_ipv4->GetObject<Ipv4L3Protocol> ();
  Ptr<NetDevice> dev = l3->GetNetDevice (interface);
  Ptr<WifiNetDevice> wifi = dev->GetObject<WifiNetDevice> ();
  if (wifi)
    {
      Ptr<WifiMac> mac = wifi->GetMac ();
      if (mac)
        {
          mac->TraceDisconnectWithoutContext ("DroppedMpdu",
                                              MakeCallback (&RoutingProtocol::NotifyTxError, this));
        }
    }

  // Close socket
  Ptr<Socket> socket = FindSocketWithInterfaceAddress (m_ipv4->GetAddress (interface, 0));
  NS_ASSERT (socket);
  socket->Close ();
  m_socketAddresses.erase (socket);
  if (m_socketAddresses.empty ())
    {
      NS_LOG_LOGIC ("No gpsr interfaces");
      m_neighbors.Clear ();
      return;
    }
}


Ptr<Socket>
RoutingProtocol::FindSocketWithInterfaceAddress (Ipv4InterfaceAddress addr ) const
{
  NS_LOG_FUNCTION (this << addr);
  for (std::map<Ptr<Socket>, Ipv4InterfaceAddress>::const_iterator j =
         m_socketAddresses.begin (); j != m_socketAddresses.end (); ++j)
    {
      Ptr<Socket> socket = j->first;
      Ipv4InterfaceAddress iface = j->second;
      if (iface == addr)
        {
          return socket;
        }
    }
  Ptr<Socket> socket;
  return socket;
}



void RoutingProtocol::NotifyAddAddress (uint32_t interface, Ipv4InterfaceAddress address)
{
  NS_LOG_FUNCTION (this << " interface " << interface << " address " << address);
  Ptr<Ipv4L3Protocol> l3 = m_ipv4->GetObject<Ipv4L3Protocol> ();
  if (!l3->IsUp (interface))
    {
      return;
    }
  if (l3->GetNAddresses ((interface) == 1))
    {
      Ipv4InterfaceAddress iface = l3->GetAddress (interface, 0);
      Ptr<Socket> socket = FindSocketWithInterfaceAddress (iface);
      if (!socket)
        {
          if (iface.GetLocal () == Ipv4Address ("127.0.0.1"))
            {
              return;
            }
          // Create a socket to listen only on this interface
          Ptr<Socket> socket = Socket::CreateSocket (GetObject<Node> (),
                                                     UdpSocketFactory::GetTypeId ());
          NS_ASSERT (socket);
          socket->SetRecvCallback (MakeCallback (&RoutingProtocol::RecvGPSR,this));
          socket->BindToNetDevice (l3->GetNetDevice (interface));
          // Bind to any IP address so that broadcasts can be received
          socket->Bind (InetSocketAddress (Ipv4Address::GetAny (), GPSR_PORT));
          socket->SetAllowBroadcast (true);
          m_socketAddresses.insert (std::make_pair (socket, iface));

          Ptr<NetDevice> dev = m_ipv4->GetNetDevice (m_ipv4->GetInterfaceForAddress (iface.GetLocal ()));
        }
    }
  else
    {
      NS_LOG_LOGIC ("GPSR does not work with more then one address per each interface. Ignore added address");
    }
}

void
RoutingProtocol::NotifyRemoveAddress (uint32_t i, Ipv4InterfaceAddress address)
{
  NS_LOG_FUNCTION (this);
  Ptr<Socket> socket = FindSocketWithInterfaceAddress (address);
  if (socket)
    {

      m_socketAddresses.erase (socket);
      Ptr<Ipv4L3Protocol> l3 = m_ipv4->GetObject<Ipv4L3Protocol> ();
      if (l3->GetNAddresses (i))
        {
          Ipv4InterfaceAddress iface = l3->GetAddress (i, 0);
          // Create a socket to listen only on this interface
          Ptr<Socket> socket = Socket::CreateSocket (GetObject<Node> (),
                                                     UdpSocketFactory::GetTypeId ());
          NS_ASSERT (socket);
          socket->SetRecvCallback (MakeCallback (&RoutingProtocol::RecvGPSR, this));
          // Bind to any IP address so that broadcasts can be received
          socket->Bind (InetSocketAddress (Ipv4Address::GetAny (), GPSR_PORT));
          socket->SetAllowBroadcast (true);
          m_socketAddresses.insert (std::make_pair (socket, iface));

          // Add local broadcast record to the routing table
          Ptr<NetDevice> dev = m_ipv4->GetNetDevice (m_ipv4->GetInterfaceForAddress (iface.GetLocal ()));

        }
      if (m_socketAddresses.empty ())
        {
          NS_LOG_LOGIC ("No gpsr interfaces");
          m_neighbors.Clear ();
          return;
        }
    }
  else
    {
      NS_LOG_LOGIC ("Remove address not participating in GPSR operation");
    }
}

void
RoutingProtocol::SetIpv4 (Ptr<Ipv4> ipv4)
{
  NS_ASSERT (ipv4);
  NS_ASSERT (!m_ipv4);

  m_ipv4 = ipv4;

  HelloIntervalTimer.SetFunction (&RoutingProtocol::HelloTimerExpire, this);
  // First hello cannot be in the past: jitter in [0, GPSR_MAXJITTER].
  // #352 (port change): drawn from the pinned member RNG.
  HelloIntervalTimer.Schedule (Seconds (m_uniformRandomVariable->GetValue (0.0, GPSR_MAXJITTER)));

  //Schedule only when it has packets on queue
  CheckQueueTimer.SetFunction (&RoutingProtocol::CheckQueue, this);

  Simulator::ScheduleNow (&RoutingProtocol::Start, this);
}

void
RoutingProtocol::HelloTimerExpire ()
{
  SendHello ();
  HelloIntervalTimer.Cancel ();
  // #352 (port change): jitter in [-GPSR_MAXJITTER, GPSR_MAXJITTER] from the
  // pinned member RNG.
  HelloIntervalTimer.Schedule (HelloInterval
                               + Seconds (m_uniformRandomVariable->GetValue (-1 * GPSR_MAXJITTER,
                                                                             GPSR_MAXJITTER)));
}

void
RoutingProtocol::SendHello ()
{
  NS_LOG_FUNCTION (this);
  double positionX;
  double positionY;

  Ptr<MobilityModel> MM = m_ipv4->GetObject<MobilityModel> ();

  positionX = MM->GetPosition ().x;
  positionY = MM->GetPosition ().y;

  for (std::map<Ptr<Socket>, Ipv4InterfaceAddress>::const_iterator j = m_socketAddresses.begin (); j != m_socketAddresses.end (); ++j)
    {
      Ptr<Socket> socket = j->first;
      Ipv4InterfaceAddress iface = j->second;
      HelloHeader helloHeader (((uint64_t) positionX),((uint64_t) positionY));

      Ptr<Packet> packet = Create<Packet> ();
      packet->AddHeader (helloHeader);
      TypeHeader tHeader (GPSRTYPE_HELLO);
      packet->AddHeader (tHeader);
      // Send to all-hosts broadcast if on /32 addr, subnet-directed otherwise
      Ipv4Address destination;
      if (iface.GetMask () == Ipv4Mask::GetOnes ())
        {
          destination = Ipv4Address ("255.255.255.255");
        }
      else
        {
          destination = iface.GetBroadcast ();
        }
      socket->SendTo (packet, 0, InetSocketAddress (destination, GPSR_PORT));

    }
}

bool
RoutingProtocol::IsMyOwnAddress (Ipv4Address src)
{
  NS_LOG_FUNCTION (this << src);
  for (std::map<Ptr<Socket>, Ipv4InterfaceAddress>::const_iterator j =
         m_socketAddresses.begin (); j != m_socketAddresses.end (); ++j)
    {
      Ipv4InterfaceAddress iface = j->second;
      if (src == iface.GetLocal ())
        {
          return true;
        }
    }
  return false;
}




void
RoutingProtocol::Start ()
{
  NS_LOG_FUNCTION (this);
  m_queuedAddresses.clear ();

  // Port change: the location-service switch is gone — GOD (the only
  // implemented service) is inlined as GetGodPosition.
}

Ptr<Ipv4Route>
RoutingProtocol::LoopbackRoute (const Ipv4Header & hdr, Ptr<NetDevice> oif)
{
  NS_LOG_FUNCTION (this << hdr);
  m_lo = m_ipv4->GetNetDevice (0);
  NS_ASSERT (m_lo);
  Ptr<Ipv4Route> rt = Create<Ipv4Route> ();
  rt->SetDestination (hdr.GetDestination ());

  std::map<Ptr<Socket>, Ipv4InterfaceAddress>::const_iterator j = m_socketAddresses.begin ();
  if (oif)
    {
      // Iterate to find an address on the oif device
      for (j = m_socketAddresses.begin (); j != m_socketAddresses.end (); ++j)
        {
          Ipv4Address addr = j->second.GetLocal ();
          int32_t interface = m_ipv4->GetInterfaceForAddress (addr);
          if (oif == m_ipv4->GetNetDevice (static_cast<uint32_t> (interface)))
            {
              rt->SetSource (addr);
              break;
            }
        }
    }
  else
    {
      rt->SetSource (j->second.GetLocal ());
    }
  NS_ASSERT_MSG (rt->GetSource () != Ipv4Address (), "Valid GPSR source address not found");
  rt->SetGateway (Ipv4Address ("127.0.0.1"));
  rt->SetOutputDevice (m_lo);
  return rt;
}


int
RoutingProtocol::GetProtocolNumber (void) const
{
  return GPSR_PORT;
}

void
RoutingProtocol::AddHeaders (Ptr<Packet> p, Ipv4Address source, Ipv4Address destination, uint8_t protocol, Ptr<Ipv4Route> route)
{

  NS_LOG_FUNCTION (this << " source " << source << " destination " << destination);

  Vector myPos;
  Ptr<MobilityModel> MM = m_ipv4->GetObject<MobilityModel> ();
  myPos.x = MM->GetPosition ().x;
  myPos.y = MM->GetPosition ().y;

  Ipv4Address nextHop;

  if(m_neighbors.isNeighbour (destination))
    {
      nextHop = destination;
    }
  else
    {
      nextHop = m_neighbors.BestNeighbor (GetGodPosition (destination), myPos);
    }

  uint16_t positionX = 0;
  uint16_t positionY = 0;
  uint32_t hdrTime = 0;

  if(destination != m_ipv4->GetAddress (1, 0).GetBroadcast ())
    {
      positionX = GetGodPosition (destination).x;
      positionY = GetGodPosition (destination).y;
      hdrTime = (uint32_t) Simulator::Now ().GetSeconds ();
    }

  // Fault-3 rework: the vendored code prepended the GPSR headers to the
  // packet as handed down by UDP, producing IP|GPSR|UDP on the wire while
  // ip.protocol still read 17 — FlowMonitor's Ipv4FlowClassifier then read
  // the first four bytes of the IP payload (position bytes, changing per
  // packet) as UDP ports and misclassified every data flow. Layer the same
  // headers *beneath* the UDP header instead (IP|UDP|GPSR): identical bytes
  // on the wire and identical routing state, but the IP payload now starts
  // with the real transport header, so FlowMonitor classifies data flows
  // correctly and port-based control/data accounting sees GPSR's port 666
  // hellos. Non-UDP packets (the down target is only re-pointed for UDP)
  // pass through untouched and are forwarded greedily without recovery
  // state — see Forwarding.
  UdpHeader udpHeader;
  const bool hasUdp = StripTransport (p, protocol, udpHeader);
  if (hasUdp)
    {
      PositionHeader posHeader (positionX, positionY,  hdrTime, (uint64_t) 0,(uint64_t) 0, (uint8_t) 0, myPos.x, myPos.y);
      p->AddHeader (posHeader);
      TypeHeader tHeader (GPSRTYPE_POS);
      p->AddHeader (tHeader);
      RestoreTransport (p, udpHeader, hasUdp);
    }

  m_downTarget (p, source, destination, protocol, route);

}

bool
RoutingProtocol::Forwarding (Ptr<const Packet> packet, const Ipv4Header & header,
                             UnicastForwardCallback ucb, ErrorCallback ecb)
{
  Ptr<Packet> p = packet->Copy ();
  NS_LOG_FUNCTION (this);
  Ipv4Address dst = header.GetDestination ();
  Ipv4Address origin = header.GetSource ();


  m_neighbors.Purge ();

  uint32_t updated = 0;
  Vector Position;
  Vector RecPosition;
  uint8_t inRec = 0;

  // Fault-3 rework: the GPSR headers sit beneath the UDP header; peel the UDP
  // header off before reading them. Non-UDP packets carry no GPSR headers
  // (see AddHeaders) and are forwarded greedily from GOD positions alone.
  UdpHeader udpHeader;
  const bool hasUdp = StripTransport (p, header.GetProtocol (), udpHeader);
  bool hasGpsrHeader = false;

  TypeHeader tHeader (GPSRTYPE_POS);
  PositionHeader hdr;
  if (hasUdp && p->GetSize () >= 1)
    {
      p->RemoveHeader (tHeader);
      if (!tHeader.IsValid ())
        {
          NS_LOG_DEBUG ("GPSR message " << p->GetUid () << " with unknown type received: " << tHeader.Get () << ". Drop");
          return false;     // drop
        }
      if (tHeader.Get () == GPSRTYPE_POS)
        {

          p->RemoveHeader (hdr);
          Position.x = hdr.GetDstPosx ();
          Position.y = hdr.GetDstPosy ();
          updated = hdr.GetUpdated ();
          RecPosition.x = hdr.GetRecPosx ();
          RecPosition.y = hdr.GetRecPosy ();
          inRec = hdr.GetInRec ();
          hasGpsrHeader = true;
        }
    }

  Vector myPos;
  Ptr<MobilityModel> MM = m_ipv4->GetObject<MobilityModel> ();
  myPos.x = MM->GetPosition ().x;
  myPos.y = MM->GetPosition ().y;

  if(inRec == 1 && CalculateDistance (myPos, Position) < CalculateDistance (RecPosition, Position)){
    inRec = 0;
    hdr.SetInRec(0);
  NS_LOG_LOGIC ("No longer in Recovery to " << dst << " in " << myPos);
  }

  if(inRec){
    p->AddHeader (hdr);
    p->AddHeader (tHeader); //put headers back so that the RecoveryMode is compatible with Forwarding and SendFromQueue
    RestoreTransport (p, udpHeader, hasUdp);
    RecoveryMode (dst, p, ucb, header);
    return true;
  }



  // GOD location service (port change): this node always has the freshest
  // destination position, so the header's carried estimate is refreshed
  // unconditionally (the vendored GetEntryUpdateTime returned Now () for GOD,
  // making its "is mine newer" check always true).
  Position.x = GetGodPosition (dst).x;
  Position.y = GetGodPosition (dst).y;
  updated = (uint32_t) Simulator::Now ().GetSeconds ();


  Ipv4Address nextHop;

/*  if(m_neighbors.isNeighbour (dst))
    {
      nextHop = dst;
    }
  else
    {
*/
      nextHop = m_neighbors.BestNeighbor (Position, myPos);
      if (nextHop != Ipv4Address::GetZero ())
        {
          if (hasGpsrHeader)
            {
              PositionHeader posHeader (Position.x, Position.y,  updated, (uint64_t) 0, (uint64_t) 0, (uint8_t) 0, myPos.x, myPos.y);
              p->AddHeader (posHeader);
              p->AddHeader (tHeader);
            }
          RestoreTransport (p, udpHeader, hasUdp);


          Ptr<Ipv4Route> route = Create<Ipv4Route> ();
          route->SetDestination (dst);
          route->SetSource (header.GetSource ());
          route->SetGateway (nextHop);

          // FIXME: Does not work for multiple interfaces
          route->SetOutputDevice (m_ipv4->GetNetDevice (1));
          route->SetDestination (header.GetDestination ());
          NS_ASSERT (route);
          NS_LOG_DEBUG ("Exist route to " << route->GetDestination () << " from interface " << route->GetOutputDevice ());


          NS_LOG_LOGIC (route->GetOutputDevice () << " forwarding to " << dst << " from " << origin << " through " << route->GetGateway () << " packet " << p->GetUid ());

          ucb (route, p, header);
          return true;
        }
//    }
  if (!hasGpsrHeader)
    {
      // Greedy failed and there is no position header to carry recovery
      // state (non-UDP packet): nothing GPSR can do — report no route.
      NS_LOG_LOGIC ("Greedy failed for headerless packet to " << dst << ". Drop");
      return false;
    }
  hdr.SetInRec(1);
  hdr.SetRecPosx (myPos.x);
  hdr.SetRecPosy (myPos.y);
  hdr.SetLastPosx (Position.x); //when entering Recovery, the first edge is the Dst
  hdr.SetLastPosy (Position.y);


  p->AddHeader (hdr);
  p->AddHeader (tHeader);
  RestoreTransport (p, udpHeader, hasUdp);
  NS_LOG_LOGIC ("Entering recovery-mode to " << dst << " in " << m_ipv4->GetAddress (1, 0).GetLocal ());

  RecoveryMode (dst, p, ucb, header);
  return true;
}



void
RoutingProtocol::SetDownTarget (IpL4Protocol::DownTargetCallback callback)
{
  m_downTarget = callback;
}


IpL4Protocol::DownTargetCallback
RoutingProtocol::GetDownTarget (void) const
{
  return m_downTarget;
}




Ptr<Ipv4Route>
RoutingProtocol::RouteOutput (Ptr<Packet> p, const Ipv4Header &header,
                              Ptr<NetDevice> oif, Socket::SocketErrno &sockerr)
{
  NS_LOG_FUNCTION (this << header << (oif ? oif->GetIfIndex () : 0));

  if (!p)
    {
      return LoopbackRoute (header, oif);     // later
    }
  if (m_socketAddresses.empty ())
    {
      sockerr = Socket::ERROR_NOROUTETOHOST;
      NS_LOG_LOGIC ("No gpsr interfaces");
      Ptr<Ipv4Route> route;
      return route;
    }
  sockerr = Socket::ERROR_NOTERROR;
  Ptr<Ipv4Route> route = Create<Ipv4Route> ();
  Ipv4Address dst = header.GetDestination ();

  // Port fix (#425): broadcasts — GPSR's own hellos first among them — must
  // never go through greedy forwarding. On a subnet-masked interface the
  // hello destination is the subnet-directed broadcast, which UdpSocketImpl
  // resolves through this RouteOutput (the socket is bound to ANY); the
  // greedy lookup below then defers it to the loopback queue, where
  // SendPacketFromQueue drops it (no GOD position exists for a broadcast
  // address). Hellos need neighbours and neighbours need hellos, so the
  // protocol deadlocks silently at cold start: 45k hellos counted at L3 (the
  // loopback Tx) with a byte-silent medium. Hand broadcasts straight to the
  // interface instead, as AODV's broadcast routing-table entry does.
  if (dst.IsBroadcast () || dst == m_ipv4->GetAddress (1, 0).GetBroadcast ())
    {
      route->SetDestination (dst);
      route->SetSource (m_ipv4->GetAddress (1, 0).GetLocal ());
      route->SetGateway (dst);
      // FIXME: Does not work for multiple interfaces
      route->SetOutputDevice (m_ipv4->GetNetDevice (1));
      if (oif && route->GetOutputDevice () != oif)
        {
          NS_LOG_DEBUG ("Output device doesn't match. Dropped.");
          sockerr = Socket::ERROR_NOROUTETOHOST;
          return Ptr<Ipv4Route> ();
        }
      return route;
    }

  Vector dstPos = Vector (1, 0, 0);

  if (!(dst == m_ipv4->GetAddress (1, 0).GetBroadcast ()))
    {
      dstPos = GetGodPosition (dst);
    }

  // GOD location service (port change): the vendored defer-while-in-search
  // branch collapses — a position lookup never pends, so deferral happens
  // only through the no-greedy-neighbour path below.

  Vector myPos;
  Ptr<MobilityModel> MM = m_ipv4->GetObject<MobilityModel> ();
  myPos.x = MM->GetPosition ().x;
  myPos.y = MM->GetPosition ().y;


  Ipv4Address nextHop;

  if(m_neighbors.isNeighbour (dst))
    {
      nextHop = dst;
    }
  else
    {
      nextHop = m_neighbors.BestNeighbor (dstPos, myPos);
    }


  if (nextHop != Ipv4Address::GetZero ())
    {
      NS_LOG_DEBUG ("Destination: " << dst);

      route->SetDestination (dst);
      if (header.GetSource () == Ipv4Address ("102.102.102.102"))
        {
          route->SetSource (m_ipv4->GetAddress (1, 0).GetLocal ());
        }
      else
        {
          route->SetSource (header.GetSource ());
        }
      route->SetGateway (nextHop);
      route->SetOutputDevice (m_ipv4->GetNetDevice (m_ipv4->GetInterfaceForAddress (route->GetSource ())));
      route->SetDestination (header.GetDestination ());
      NS_ASSERT (route);
      NS_LOG_DEBUG ("Exist route to " << route->GetDestination () << " from interface " << route->GetSource ());
      if (oif && route->GetOutputDevice () != oif)
        {
          NS_LOG_DEBUG ("Output device doesn't match. Dropped.");
          sockerr = Socket::ERROR_NOROUTETOHOST;
          return Ptr<Ipv4Route> ();
        }
      return route;
    }
  else
    {
      DeferredRouteOutputTag tag;
      if (!p->PeekPacketTag (tag))
        {
          p->AddPacketTag (tag);
        }
      return LoopbackRoute (header, oif);     //in RouteInput the recovery-mode is called
    }

}


}
}
