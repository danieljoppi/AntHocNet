// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/*
 * AOMDV as an arm of the comparison harness (ADR-0027, #768), compiled in
 * only when routing-bench is installed beside this module. The vendored
 * multipath baseline (#296); not in the default protocol list, it joins a
 * comparison when named.
 */

#include "ns3/aomdv-helper.h"
#include "ns3/routing-bench-arm.h"

namespace ns3 {
namespace {

class AomdvArm : public bench::Arm {
public:
    std::string Name() const override { return "aomdv"; }
    void InstallRouting(InternetStackHelper& internet, bench::RunContext&) override {
        internet.SetRoutingHelper(m_helper);
    }
    int64_t AssignStreams(bench::RunContext& run, int64_t stream) override {
        return m_helper.AssignStreams(run.nodes, stream);
    }

private:
    AomdvHelper m_helper;
};

Ptr<bench::Arm> MakeAomdvArm() { return Create<AomdvArm>(); }

}  // namespace

namespace bench {
void RegisterArms_aomdv() {
    RegisterArm("aomdv", "AOMDV, multipath AODV (Marina & Das 2001), vendored (#296)",
                &MakeAomdvArm);
}
}  // namespace bench
}  // namespace ns3
