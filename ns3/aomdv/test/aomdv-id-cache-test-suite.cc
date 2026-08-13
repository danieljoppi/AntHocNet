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
#include "ns3/aomdv-id-cache.h"
#include "ns3/test.h"

// TestSuite/TestCase enums became scoped (enum class) in ns-3.42 and the
// unscoped aliases were removed in ns-3.47. AOMDV_NS3_SCOPED_TEST_ENUMS is
// defined by the module's CMakeLists for ns-3 >= 3.42 (same pattern as the
// anthocnet module's ANTHOCNET_NS3_SCOPED_TEST_ENUMS).
#ifdef AOMDV_NS3_SCOPED_TEST_ENUMS
#define AOMDV_TEST_TYPE_UNIT TestSuite::Type::UNIT
#define AOMDV_TEST_QUICK     TestCase::Duration::QUICK
#else
#define AOMDV_TEST_TYPE_UNIT UNIT
#define AOMDV_TEST_QUICK     TestCase::QUICK
#endif

namespace ns3 {
namespace aomdv {

/**
 * \ingroup aomdv
 * \defgroup aomdv-test AOMDV module tests
 */


/**
 * \ingroup aomdv-test
 * \ingroup tests
 *
 * \brief Unit test for id cache
 */
class IdCacheTest : public TestCase
{
public:
  IdCacheTest () : TestCase ("Id Cache"),
                   cache (Seconds (10))
  {
  }
  virtual void DoRun ();

private:
  /// Timeout test function #1
  void CheckTimeout1 ();
  /// Timeout test function #2
  void CheckTimeout2 ();
  /// Timeout test function #3
  void CheckTimeout3 ();

  /// ID cache
  IdCache cache;
};

void
IdCacheTest::DoRun ()
{
  NS_TEST_EXPECT_MSG_EQ (cache.GetLifeTime (), Seconds (10), "Lifetime");
  NS_TEST_EXPECT_MSG_EQ (cache.IsDuplicate (Ipv4Address ("1.2.3.4"), 3), false, "Unknown ID & address");
  NS_TEST_EXPECT_MSG_EQ (cache.IsDuplicate (Ipv4Address ("1.2.3.4"), 4), false, "Unknown ID");
  NS_TEST_EXPECT_MSG_EQ (cache.IsDuplicate (Ipv4Address ("4.3.2.1"), 3), false, "Unknown address");
  NS_TEST_EXPECT_MSG_EQ (cache.IsDuplicate (Ipv4Address ("1.2.3.4"), 3), true, "Known address & ID");
  cache.SetLifetime (Seconds (15));
  NS_TEST_EXPECT_MSG_EQ (cache.GetLifeTime (), Seconds (15), "New lifetime");
  cache.IsDuplicate (Ipv4Address ("1.1.1.1"), 4);
  cache.IsDuplicate (Ipv4Address ("1.1.1.1"), 4);
  cache.IsDuplicate (Ipv4Address ("2.2.2.2"), 5);
  cache.IsDuplicate (Ipv4Address ("3.3.3.3"), 6);
  NS_TEST_EXPECT_MSG_EQ (cache.GetSize (), 6, "trivial");

  Simulator::Schedule (Seconds (5), &IdCacheTest::CheckTimeout1, this);
  Simulator::Schedule (Seconds (11), &IdCacheTest::CheckTimeout2, this);
  Simulator::Schedule (Seconds (30), &IdCacheTest::CheckTimeout3, this);
  Simulator::Run ();
  Simulator::Destroy ();
}

void
IdCacheTest::CheckTimeout1 ()
{
  NS_TEST_EXPECT_MSG_EQ (cache.GetSize (), 6, "Nothing expire");
}

void
IdCacheTest::CheckTimeout2 ()
{
  NS_TEST_EXPECT_MSG_EQ (cache.GetSize (), 3, "3 records left");
}

void
IdCacheTest::CheckTimeout3 ()
{
  NS_TEST_EXPECT_MSG_EQ (cache.GetSize (), 0, "All records expire");
}

/**
 * \ingroup aomdv-test
 * \ingroup tests
 *
 * \brief Id Cache Test Suite
 */
class IdCacheTestSuite : public TestSuite
{
public:
  IdCacheTestSuite () : TestSuite ("aomdv-routing-id-cache", AOMDV_TEST_TYPE_UNIT)
  {
    AddTestCase (new IdCacheTest, AOMDV_TEST_QUICK);
  }
} g_idCacheTestSuite; ///< the test suite

}  // namespace aomdv
}  // namespace ns3
