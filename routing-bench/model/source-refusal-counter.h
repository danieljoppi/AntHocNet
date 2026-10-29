// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

#ifndef ROUTING_BENCH_SOURCE_REFUSAL_COUNTER_H
#define ROUTING_BENCH_SOURCE_REFUSAL_COUNTER_H

/**
 * #510: data sends the origin refused for want of a route. Stock ns-3 OLSR
 * returns a null route from RouteOutput when the source has no table entry;
 * the UDP send then fails before Ipv4L3Protocol::Send, so FlowMonitor never
 * counts the packet as transmitted, and on ns-3.42 OnOff caches it and
 * retries the same packet at the next tick, generating nothing new. PDR was
 * therefore computed over "the ticks OLSR had a route for" -- the defect #464
 * found for the oracle, which #466 fixed with the oracle's own noRouteOrigin
 * counter. OLSR has no such counter, so this one supplies it: installed at the
 * lowest priority of an Ipv4ListRouting behind OLSR, it is consulted only when
 * OLSR has already refused, and it counts that refusal and refuses too. One
 * count per refused tick, the same unit as the oracle's noRouteOrigin.
 *
 * Moved here from anthocnet-compare.cc (#766); the count now lives in the
 * helper's shared tally instead of a file-scope global, so each run's arm
 * owns its own.
 */

#include "ns3/ipv4-routing-helper.h"

#include <cstdint>
#include <memory>

namespace ns3 {
namespace bench {

// The counter itself (an Ipv4RoutingProtocol that refuses and counts) is
// defined in the .cc: its RouteInput signature changed across ns-3 releases,
// and the compile definition that selects it is scoped to this module, while
// this header is included from others.

/// Creates counters that all add to one tally, read back with Refused().
class SourceRefusalCounterHelper : public Ipv4RoutingHelper {
public:
    SourceRefusalCounterHelper() : m_tally(std::make_shared<uint64_t>(0)) {}
    SourceRefusalCounterHelper* Copy() const override {
        return new SourceRefusalCounterHelper(*this);
    }
    Ptr<Ipv4RoutingProtocol> Create(Ptr<Node>) const override;
    uint64_t Refused() const { return *m_tally; }

private:
    std::shared_ptr<uint64_t> m_tally;  // shared by every Copy()
};

}  // namespace bench
}  // namespace ns3

#endif  // ROUTING_BENCH_SOURCE_REFUSAL_COUNTER_H
