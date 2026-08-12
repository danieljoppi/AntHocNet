/* -*- Mode:C++; c-file-style:"gnu"; indent-tabs-mode:nil; -*- */
/*
 * Copyright (c) 2009 IITP RAS
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation;
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 * Authors: António Fonseca <afonseca@tagus.inesc-id.pt>, written after OlsrHelper by Mathieu Lacage <mathieu.lacage@sophia.inria.fr>
 */
// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi (ns-3.36–3.48 port for AntHocNet #296)
/*
 * Vendored from https://github.com/dwosion/ns3.29-with-gpsr
 * commit 15241ef715d52627ff7679a5fca6b6d15eaa8cd4, path ns-3.29/src/gpsr.
 * Port changes: see gpsr-helper.h and ns3/gpsr/README.md.
 */
#include "gpsr-helper.h"
#include "ns3/gpsr.h"
#include "ns3/node-list.h"
#include "ns3/names.h"
#include "ns3/ipv4-list-routing.h"
#include "ns3/node-container.h"
#include "ns3/callback.h"
#include "ns3/udp-l4-protocol.h"

namespace ns3 {

GpsrHelper::GpsrHelper ()
  : Ipv4RoutingHelper ()
{
  m_agentFactory.SetTypeId ("ns3::gpsr::RoutingProtocol");
}

GpsrHelper*
GpsrHelper::Copy (void) const
{
  return new GpsrHelper (*this);
}

Ptr<Ipv4RoutingProtocol>
GpsrHelper::Create (Ptr<Node> node) const
{
  Ptr<gpsr::RoutingProtocol> gpsr = m_agentFactory.Create<gpsr::RoutingProtocol> ();
  node->AggregateObject (gpsr);
  return gpsr;
}

void
GpsrHelper::Set (std::string name, const AttributeValue &value)
{
  m_agentFactory.Set (name, value);
}


void
GpsrHelper::Install (NodeContainer c) const
{
  for (NodeContainer::Iterator i = c.Begin (); i != c.End (); ++i)
    {
      Ptr<Node> node = (*i);
      Ptr<UdpL4Protocol> udp = node->GetObject<UdpL4Protocol> ();
      Ptr<gpsr::RoutingProtocol> gpsr = node->GetObject<gpsr::RoutingProtocol> ();
      gpsr->SetDownTarget (udp->GetDownTarget ());
      udp->SetDownTarget (MakeCallback(&gpsr::RoutingProtocol::AddHeaders, gpsr));
    }


}

void
GpsrHelper::Install (void) const
{
  Install (NodeContainer::GetGlobal ());
}

int64_t
GpsrHelper::AssignStreams (NodeContainer c, int64_t stream)
{
  // #352 (port addition): mirror AodvHelper::AssignStreams.
  int64_t currentStream = stream;
  for (NodeContainer::Iterator i = c.Begin (); i != c.End (); ++i)
    {
      Ptr<Node> node = *i;
      Ptr<Ipv4> ipv4 = node->GetObject<Ipv4> ();
      NS_ASSERT_MSG (ipv4, "GpsrHelper::AssignStreams(): node has no Ipv4");
      Ptr<gpsr::RoutingProtocol> gpsr =
        DynamicCast<gpsr::RoutingProtocol> (ipv4->GetRoutingProtocol ());
      if (gpsr)
        {
          currentStream += gpsr->AssignStreams (currentStream);
        }
    }
  return (currentStream - stream);
}

}
