// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/**
 * Installs the oracle shortest-path control arm (#296 item 1, #216).
 *
 * Use it exactly like AodvHelper:
 *
 *     OracleHelper oracle;
 *     InternetStackHelper internet;
 *     internet.SetRoutingHelper(oracle);
 *     internet.Install(nodes);
 *
 * The helper owns the one oracle::Topology every installed node shares, and
 * hands the same pointer to each protocol instance. That is why the helper
 * must be a per-simulation object: a harness that builds many scenarios in one
 * process (both of this repo's do) constructs a fresh OracleHelper per run, so
 * each run gets its own graph and cannot inherit the previous run's nodes.
 */
#ifndef ORACLE_HELPER_H
#define ORACLE_HELPER_H

#include "ns3/oracle-topology.h"

#include "ns3/ipv4-routing-helper.h"
#include "ns3/node-container.h"
#include "ns3/object-factory.h"

namespace ns3
{

class OracleHelper : public Ipv4RoutingHelper
{
  public:
    OracleHelper();

    OracleHelper* Copy() const override;
    Ptr<Ipv4RoutingProtocol> Create(Ptr<Node> node) const override;

    /// Forwarded to the shared oracle::Topology (e.g. "RecomputeInterval").
    void Set(const std::string& name, const AttributeValue& value);

    /**
     * Always returns 0: the oracle draws no random numbers. Present so the
     * harnesses can pin every arm through the same #352 code path and record
     * a measured zero rather than an absence.
     */
    int64_t AssignStreams(NodeContainer c, int64_t stream);

    /// The graph shared by this helper's nodes — the harnesses read its
    /// diagnostics (mode, edge count, recomputes) after the run.
    Ptr<oracle::Topology> GetTopology() const;

  private:
    Ptr<oracle::Topology> m_topology;
};

} // namespace ns3

#endif // ORACLE_HELPER_H
