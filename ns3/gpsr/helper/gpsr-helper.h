/* -*- Mode:C++; c-file-style:"gnu"; indent-tabs-mode:nil; -*- */
// SPDX-License-Identifier: GPL-2.0-only
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
 * Authors: Pavel Boyko <boyko@iitp.ru>, written after OlsrHelper by Mathieu Lacage <mathieu.lacage@sophia.inria.fr>
 */
// Copyright (C) 2026 Daniel Henrique Joppi (ns-3.36–3.48 port for AntHocNet #296)
/*
 * Vendored from https://github.com/dwosion/ns3.29-with-gpsr
 * commit 15241ef715d52627ff7679a5fca6b6d15eaa8cd4, path ns-3.29/src/gpsr.
 * Port changes: Install(NodeContainer) overload (the global-container form
 * mis-scopes when several simulations run in one process) and AssignStreams
 * (#352 stream pinning, mirroring AodvHelper). See ns3/gpsr/README.md.
 */
#ifndef GPSRHELPER_H_
#define GPSRHELPER_H_

#include "ns3/object-factory.h"
#include "ns3/node.h"
#include "ns3/node-container.h"
#include "ns3/ipv4-routing-helper.h"

namespace ns3 {
/**
 * \ingroup gpsr
 * \brief Helper class that adds GPSR routing to nodes.
 */
class GpsrHelper : public Ipv4RoutingHelper
{
public:
  GpsrHelper ();

  /**
   * \internal
   * \returns pointer to clone of this OlsrHelper
   *
   * This method is mainly for internal use by the other helpers;
   * clients are expected to free the dynamic memory allocated by this method
   */
  GpsrHelper* Copy (void) const;

  /**
   * \param node the node on which the routing protocol will run
   * \returns a newly-created routing protocol
   *
   * This method will be called by ns3::InternetStackHelper::Install
   *
   * TODO: support installing GPSR on the subset of all available IP interfaces
   */
  virtual Ptr<Ipv4RoutingProtocol> Create (Ptr<Node> node) const;
  /**
   * \param name the name of the attribute to set
   * \param value the value of the attribute to set.
   *
   * This method controls the attributes of ns3::gpsr::RoutingProtocol
   */
  void Set (std::string name, const AttributeValue &value);

  /**
   * Re-point the UDP down target of every node in c to
   * gpsr::RoutingProtocol::AddHeaders, so data packets carry the GPSR
   * position header. Must run after InternetStackHelper::Install. Port
   * overload: the vendored no-argument form acted on
   * NodeContainer::GetGlobal(), which mis-scopes when one process runs many
   * simulations (the comparison harness does); it is kept, delegating here.
   */
  void Install (NodeContainer c) const;
  void Install (void) const;

  /**
   * #352 stream pinning (port addition, after AodvHelper::AssignStreams):
   * assign fixed stream numbers to the gpsr protocols installed on the nodes
   * in c.
   * \return the number of stream indices assigned
   */
  int64_t AssignStreams (NodeContainer c, int64_t stream);

private:
  ObjectFactory m_agentFactory;
};

}
#endif /* GPSRHELPER_H_ */
