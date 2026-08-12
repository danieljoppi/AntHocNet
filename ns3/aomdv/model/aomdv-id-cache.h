/* -*- Mode:C++; c-file-style:"gnu"; indent-tabs-mode:nil; -*- */
// SPDX-License-Identifier: GPL-2.0-only
/*
 * Vendored for AntHocNet (#296, baseline port): stock ns-3.36 src/aodv rebased
 * with the AOMDV delta from
 * https://github.com/CharithaS/Implementation-of-AOMDV-Routing-Protocol-in-ns-3
 * (commit 54594e24daf7688bdcdb6a696bf821a08fd2d06a, GPLv2). See
 * ns3/aomdv/README.md for full provenance and the list of adaptations.
 */
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
 * Based on
 *      NS-2 AOMDV model developed by the CMU/MONARCH group and optimized and
 *      tuned by Samir Das and Mahesh Marina, University of Cincinnati;
 *
 *      AOMDV-UU implementation by Erik Nordström of Uppsala University
 *      http://core.it.uu.se/core/index.php/AOMDV-UU
 *
 * Authors: Elena Buchatskaia <borovkovaes@iitp.ru>
 *          Pavel Boyko <boyko@iitp.ru>
 */

#ifndef AOMDV_ID_CACHE_H
#define AOMDV_ID_CACHE_H

#include "ns3/ipv4-address.h"
#include "ns3/simulator.h"
#include <vector>

namespace ns3 {
namespace aomdv {

/**
 * \ingroup aomdv
 * \brief Next-hop/last-hop pair describing one path of a multipath route
 * (AOMDV addition).
 */
class AOMDVRoute 
{
public:
  AOMDVRoute(Ipv4Address nextHop, Ipv4Address lastHop = 0) : m_nextHop (nextHop) , m_lastHop (lastHop) {}
  void SetNextHop (Ipv4Address nextHop) { m_nextHop = nextHop; }
  Ipv4Address GetNextHop () const { return m_nextHop; }
  void SetLastHop (Ipv4Address lastHop) { m_lastHop = lastHop; }
  Ipv4Address GetLastHop () const { return m_lastHop; }
private:
  Ipv4Address m_nextHop;
  Ipv4Address m_lastHop;
};

/**
 * \ingroup aomdv
 *
 * \brief Unique packets identification cache used for simple duplicate detection.
 */
class IdCache
{
public:
  /**
   * constructor
   * \param lifetime the lifetime for added entries
   */
  IdCache (Time lifetime) : m_lifetime (lifetime)
  {
  }
  /// Unique packet ID (AOMDV: extended with per-RREQ path bookkeeping)
  struct UniqueId
  {
    /// ID is supposed to be unique in single address context (e.g. sender address)
    Ipv4Address m_context;
    /// The id
    uint32_t m_id;
    /// When record will expire
    Time m_expire;
    /// AOMDV: advertised-path counter for this RREQ generation
    int count;
    std::vector<AOMDVRoute> m_reversePathList;     ///< AOMDV: reverse paths used for forwarding replies
    std::vector<AOMDVRoute> m_forwardPathList;     ///< AOMDV: forward paths advertised already
    void ReversePathInsert (Ipv4Address nextHop, Ipv4Address lastHop = 0);
    bool ReversePathLookup (Ipv4Address nextHop, AOMDVRoute & rt, Ipv4Address lastHop = 0);
    void ForwardPathInsert (Ipv4Address nextHop, Ipv4Address lastHop = 0);
    bool ForwardPathLookup (Ipv4Address nextHop, AOMDVRoute & rt, Ipv4Address lastHop = 0);
  };

  /**
   * Add entry (addr, id) to the cache (AOMDV).
   * \param addr the IP address
   * \param id the cache entry ID
   */
  void InsertId (Ipv4Address addr, uint32_t id);
  /**
   * Look up the cache entry for (addr, id) (AOMDV).
   * \param addr the IP address
   * \param id the cache entry ID
   * \returns the entry, or 0 if not present
   */
  struct UniqueId* GetId (Ipv4Address addr, uint32_t id);
  /**
   * Check that entry (addr, id) exists in cache. Add entry, if it doesn't exist.
   * \param addr the IP address
   * \param id the cache entry ID
   * \returns true if the pair exists
   */ 
  bool IsDuplicate (Ipv4Address addr, uint32_t id);
  /// Remove all expired entries
  void Purge ();
  /**
   * \returns number of entries in cache
   */
  uint32_t GetSize ();
  /**
   * Set lifetime for future added entries.
   * \param lifetime the lifetime for entries
   */
  void SetLifetime (Time lifetime)
  {
    m_lifetime = lifetime;
  }
  /**
   * Return lifetime for existing entries in cache
   * \returns thhe lifetime
   */
  Time GetLifeTime () const
  {
    return m_lifetime;
  }
private:
  /**
   * \brief IsExpired structure
   */
  struct IsExpired
  {
    /**
     * \brief Check if the entry is expired
     *
     * \param u UniqueId entry
     * \return true if expired, false otherwise
     */
    bool operator() (const struct UniqueId & u) const
    {
      return (u.m_expire < Simulator::Now ());
    }
  };
  /// Already seen IDs
  std::vector<UniqueId> m_idCache;
  /// Default lifetime for ID records
  Time m_lifetime;
};

}  // namespace aomdv
}  // namespace ns3

#endif /* AOMDV_ID_CACHE_H */
