// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/*
 * The oracle control as an arm of the comparison harness (ADR-0027, #768),
 * compiled in only when routing-bench is installed beside this module.
 *
 * The `oracle` arm (#296 item 1, #216) is the global-knowledge shortest-path
 * CONTROL: Dijkstra over the ground-truth topology, zero control traffic, zero
 * discovery latency. It is an upper bound, not a competitor. See README.md
 * for what "ground truth" means per propagation model.
 */

#include "ns3/abort.h"
#include "ns3/nstime.h"
#include "ns3/config.h"
#include "ns3/oracle-helper.h"
#include "ns3/oracle-topology.h"
#include "ns3/routing-bench-arm.h"

#include <iomanip>
#include <ostream>

namespace ns3 {
namespace oracle {
namespace {

class OracleArm : public bench::Arm {
public:
    std::string Name() const override { return "oracle"; }
    // #506: the oracle re-derives its graph every RecomputeInterval (1 s by
    // default). At FANET closing speeds (up to 60 m/s) a 1 s-old graph routes
    // over links that have already broken, and the oracle stops being a
    // delivery bound -- measured: 88.89 % vs AntHocNet's 94.41 % on the main
    // cell, 7.89 % MAC drops. At 100 ms it is above every arm on every seed
    // (#506, both cells, 20 seeds). The oracle is the measuring instrument,
    // not a protocol under test, so this is not the per-family protocol
    // default ADR-0019 forbids. An explicit
    // --ns3::oracle::Topology::RecomputeInterval=... on the command line
    // still wins; no other scenario is touched.
    // #488: the same instrument rule for VANET. Measured on the
    // vanet-building anchor cell (one 280 m block, 20 vehicles, urban): at the
    // 1 s default the oracle delivered 48.3 % against AODV's 50.5 % on 10
    // vehicles -- a 1 s-old graph misses every corner a vehicle has just
    // turned. At 100 ms it delivers 99.6 % on the anchor cell.
    // #580: the disaster scene's links open and close at building walls as
    // responders walk in and out, the VANET corner case on foot.
    void Configure(const bench::RunContext& scenario) override {
        if (scenario.scenario != "fanet" && scenario.scenario != "vanet" &&
            scenario.scenario != "disaster") {
            return;
        }
        for (const std::string& a : scenario.args) {
            if (a.find("oracle::Topology::RecomputeInterval") != std::string::npos) return;
        }
        Config::SetDefault("ns3::oracle::Topology::RecomputeInterval",
                           TimeValue(MilliSeconds(100)));
    }
    // #506: the recompute cadence, when it is not the 1 s default. Printed
    // only off-default so every existing oracle cell's ##CONFIG## block stays
    // byte-identical; a FANET cell records its 100 ms here.
    void EmitConfig(std::ostream& out) const override {
        TypeId otid = Topology::GetTypeId();
        const std::size_t nO = otid.GetAttributeN();
        for (std::size_t a = 0; a < nO; ++a) {
            const TypeId::AttributeInformation info = otid.GetAttribute(a);
            if (info.name != "RecomputeInterval") continue;
            if (!info.initialValue || !info.checker) break;
            const std::string v = info.initialValue->SerializeToString(info.checker);
            if (v != "+1e+09ns") {
                out << "##CONFIG## attr ns3::oracle::Topology::"
                       "RecomputeInterval="
                    << v << '\n';
            }
            break;
        }
    }
    // #296/#431: the oracle derives its adjacency from the installed objects
    // on every channel the harness configures -- the disk channel's own
    // MaxRange (exact), the two-ray decode radius at the PHY's decode
    // threshold, or the Nakagami closed-form median radius at that same
    // threshold (both flagged approx=1). LinkRangeM is deliberately NOT set:
    // pinning it to --range was what held the fading cells to a 300 m disk
    // the radios outreach by 40 % (#431's measured hop violation). To force a
    // radius, pass --ns3::oracle::Topology::LinkRangeM=<m>. On a channel the
    // oracle cannot derive, it still aborts rather than guess.
    void InstallRouting(InternetStackHelper& internet, bench::RunContext&) override {
        internet.SetRoutingHelper(m_helper);
    }
    // Pinned through the same path as every other arm even though the oracle
    // draws nothing: the count it returns is 0, and taking it makes that a
    // measured zero rather than a gap in the #352 coverage.
    int64_t AssignStreams(bench::RunContext& run, int64_t stream) override {
        return m_helper.AssignStreams(run.nodes, stream);
    }
    // #464: the oracle refuses a locally originated send outright when its
    // graph holds no path. The RouteInput half of the topology's noRoute
    // counter is NOT added: those packets were already in flight, FlowMonitor
    // counted them, and the error callback already books them under
    // DROP_ROUTE_ERROR -- adding them here would double-count.
    void AdjustCounts(bench::RunContext&, bench::RunCounts& c) override {
        Ptr<Topology> topo = m_helper.GetTopology();
        if (!topo) return;
        c.txPackets += topo->GetNoRouteOriginCount();
        c.dropRoute += topo->GetNoRouteOriginCount();
    }
    // #296 item 1 (b): the topology it routed on is reported, not guessed at
    // afterwards: which adjacency rule was in force, whether that rule is
    // exact for this channel, and how often it was re-solved. `approx=1`
    // marks a cell whose oracle is an approximation (fading), which is what
    // scenario_check reads to refuse to treat it as exact.
    void EmitDiagnostics(bench::RunContext& run, const bench::Measurement&, double nrl,
                         std::ostream& out) override {
        Ptr<Topology> topo = m_helper.GetTopology();
        out << "##ORACLE## " << run.seed << ' ' << Name() << " mode=" << topo->GetMode()
            << " approx=" << (topo->IsApproximate() ? 1 : 0) << " nodes=" << topo->GetNodeCount()
            << " edges=" << topo->GetEdgeCount() << " recomputes=" << topo->GetRecomputeCount()
            << " changes=" << topo->GetTopologyChanges() << " range=" << std::fixed
            << std::setprecision(1) << topo->GetLinkRange() << " noRoute="
            << topo->GetNoRouteCount()
            // #464: appended, never inserted -- the split between the two
            // failure paths, so the accounting can be audited rather than
            // inferred. noRouteOrigin is folded into the offered count and
            // the route column; noRouteForward was already booked.
            << " noRouteOrigin=" << topo->GetNoRouteOriginCount()
            << " noRouteFwd=" << topo->GetNoRouteForwardCount() << " nrl=" << std::fixed
            << std::setprecision(2) << nrl << "\n";
    }
    // #296 item 1 (a): zero control traffic. The oracle opens no socket and
    // sends nothing; if this ever fires, something in the arm started talking
    // and its NRL stopped being an upper-bound reference point. NS_ABORT, not
    // NS_ASSERT, so it holds in the optimized builds the campaign uses.
    void Check(bench::RunContext&, const bench::Measurement& m) override {
        NS_ABORT_MSG_IF(m.ControlPackets() != 0 || m.ControlBytes() != 0,
                        "oracle arm transmitted "
                            << m.ControlPackets() << " control packets (" << m.ControlBytes()
                            << " B): the control is supposed to put NOTHING on "
                               "the wire, so its NRL is no longer an upper-bound reference (#296)");
    }

private:
    // Per run, like every arm: the helper owns this run's ground-truth graph,
    // so a fresh one per run is what stops run N inheriting run N-1's nodes.
    OracleHelper m_helper;
};

Ptr<bench::Arm> MakeOracleArm() { return Create<OracleArm>(); }

}  // namespace
}  // namespace oracle

namespace bench {
void RegisterArms_oracle() {
    RegisterArm("oracle", "shortest-path ground truth, the upper-bound control (#296)",
                &oracle::MakeOracleArm);
}
}  // namespace bench
}  // namespace ns3
