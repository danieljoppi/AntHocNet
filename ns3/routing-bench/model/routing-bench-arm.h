// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

#ifndef ROUTING_BENCH_ARM_H
#define ROUTING_BENCH_ARM_H

/**
 * The arm contract of the protocol-agnostic comparison harness (ADR-0027,
 * #766). An arm is one routing protocol the harness can run. It is created
 * fresh for every (seed, arm) run, so no state leaks from one run into the
 * next, and the harness calls its hooks in the fixed order ADR-0027 §2 lists.
 * Every hook but the first three is optional and does nothing by default.
 *
 * This step carries the hooks the stock arms need. The rest of the contract
 * (devices, post-stack wiring, traces, diagnostics, self-checks) arrives with
 * the extraction (#767), at the call points the ADR fixes.
 */

#include "ns3/internet-stack-helper.h"
#include "ns3/node-container.h"
#include "ns3/simple-ref-count.h"

#include <cstdint>
#include <map>
#include <string>
#include <vector>

namespace ns3 {
namespace bench {

/// What one run gives an arm: its nodes and its seed.
struct RunContext {
    NodeContainer nodes;
    uint32_t seed = 0;
};

/// A run's tallies before the marker lines are printed. An arm whose
/// protocol refuses sends at the source adds them back here (#510).
struct RunCounts {
    uint64_t txPackets = 0;  ///< offered data packets
    uint64_t dropRoute = 0;  ///< of those, lost for want of a route
};

class Arm : public SimpleRefCount<Arm> {
public:
    virtual ~Arm() = default;
    /// The `--protocols` token.
    virtual std::string Name() const = 0;
    /// Set the routing helper on the stack before `Install`.
    virtual void InstallRouting(InternetStackHelper& internet, RunContext& run) = 0;
    /// Pin the installed protocol's random streams from `stream`; return the
    /// number taken (#352). An arm that draws nothing returns 0.
    virtual int64_t AssignStreams(RunContext& run, int64_t stream) = 0;
    /// Correct the run's tallies, e.g. for packets refused at the source.
    virtual void AdjustCounts(RunContext& run, RunCounts& counts) {}
};

using ArmFactory = Ptr<Arm> (*)();

/// A name → factory table. The harness uses the process-wide one below; a
/// local instance lets the test suite exercise the rules.
class ArmRegistry {
public:
    /// Add an arm. Returns false, and changes nothing, if the name is empty,
    /// already taken, or the factory is null.
    bool Add(const std::string& name, const std::string& summary, ArmFactory make);
    /// A fresh arm for `name`, or a null pointer if no arm has that name.
    Ptr<Arm> Make(const std::string& name) const;
    bool Has(const std::string& name) const;
    /// The registered names, sorted.
    std::vector<std::string> Names() const;
    std::string Summary(const std::string& name) const;

private:
    struct Entry {
        std::string summary;
        ArmFactory make;
    };
    std::map<std::string, Entry> m_arms;
};

/// The process-wide registry the harness reads.
ArmRegistry& Registry();

/// Add an arm to the process-wide registry; aborts on a duplicate or empty
/// name, so two modules can never silently claim one `--protocols` token.
void RegisterArm(const std::string& name, const std::string& summary, ArmFactory make);

}  // namespace bench
}  // namespace ns3

#endif  // ROUTING_BENCH_ARM_H
