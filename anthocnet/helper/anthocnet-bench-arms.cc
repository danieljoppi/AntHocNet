// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/*
 * AntHocNet as an arm of the comparison harness (ADR-0027, #768): compiled
 * into the anthocnet module only when routing-bench is installed and enabled
 * beside it, and registered by routing-compare's generated start-up call.
 * Everything the harness used to special-case for AntHocNet lives here: the
 * energy probe (#145), the re-injection identity (#386), the ant tallies
 * (--diag), the pending-queue causes and hold times (#215, #308), the --diag
 * fields and the replay (#641).
 */

#include "ns3/anthocnet-helper.h"
#include "ns3/anthocnet-routing-protocol.h"
#include "ns3/anthocnet-viz-trace.h"
#include "ns3/ipv4-flow-classifier.h"
#include "ns3/routing-bench-arm.h"

#include <iomanip>
#include <ostream>

namespace ns3 {
namespace anthocnet {
namespace {

// #641: the one recorded run of --vizTrace in the process.
vizt::VizTrace g_viz;

// The pending-queue hold attribution summed over the run's nodes (#308).
HoldStats SumHoldStats(const bench::RunContext& run) {
    HoldStats h{};
    for (uint32_t i = 0; i < run.nodes.GetN(); ++i) {
        Ptr<Ipv4> ip = run.nodes.Get(i)->GetObject<Ipv4>();
        if (!ip) continue;
        Ptr<RoutingProtocol> ahn = DynamicCast<RoutingProtocol>(ip->GetRoutingProtocol());
        if (!ahn) continue;
        const HoldStats& s = ahn->HoldTimeStats();
        for (uint8_t hr = 0; hr < kHoldReasons; ++hr) {
            h.deliveredCount[hr] += s.deliveredCount[hr];
            h.deliveredSumS[hr] += s.deliveredSumS[hr];
            if (s.deliveredMaxS[hr] > h.deliveredMaxS[hr])
                h.deliveredMaxS[hr] = s.deliveredMaxS[hr];
            h.droppedCount[hr] += s.droppedCount[hr];
            h.droppedSumS[hr] += s.droppedSumS[hr];
        }
    }
    return h;
}

class AntHocNetArm : public bench::Arm {
public:
    std::string Name() const override { return "anthocnet"; }
    void InstallRouting(InternetStackHelper& internet, bench::RunContext&) override {
        internet.SetRoutingHelper(m_helper);
    }
    int64_t AssignStreams(bench::RunContext& run, int64_t stream) override {
        return m_helper.AssignStreams(run.nodes, stream);
    }
    // #145: the energy metric reads each node's battery through this probe.
    // Only with energy accounting on; elsewhere the metric sees "unknown" and
    // degrades to hop count.
    void AfterStack(bench::RunContext& run) override {
        if (run.energyJ <= 0.0 || !run.residualEnergy) return;
        for (uint32_t i = 0; i < run.nodes.GetN(); ++i) {
            Ptr<RoutingProtocol> ahn = DynamicCast<RoutingProtocol>(
                run.nodes.Get(i)->GetObject<Ipv4>()->GetRoutingProtocol());
            if (ahn) ahn->SetEnergyProbe(MakeBoundCallback(&EnergyProbe, run.residualEnergy, i));
        }
    }
    // #386: the re-injection identity, UDP only (under TCP the SeqTs identity
    // does not exist). The EnableMacFailureDetector=false arm keeps the hooks:
    // its trace never fires, so every field reads a *measured* zero, which is
    // what lets scenario_check assert the detector-off control as a number.
    // --diag: per-type ant tallies from AntHocNet's own trace sources (item 15).
    void ConnectTraces(bench::RunContext& run, bench::Measurement& m) override {
        if (run.transport != "tcp") m.TrackReinjectionIdentity();
        if (!run.diag) return;
        for (uint32_t i = 0; i < run.nodes.GetN(); ++i) {
            Ptr<Ipv4> ip = run.nodes.Get(i)->GetObject<Ipv4>();
            if (!ip) continue;
            Ptr<Ipv4RoutingProtocol> rp = ip->GetRoutingProtocol();
            if (!rp) continue;
            rp->TraceConnectWithoutContext("Tx",
                                           MakeCallback(&bench::Measurement::TypedControlTx, &m));
            rp->TraceConnectWithoutContext("Rx",
                                           MakeCallback(&bench::Measurement::TypedControlRx, &m));
        }
    }
    // #641: the first AntHocNet run of the process, sampled for the replay.
    bool StartReplay(bench::RunContext& run, const bench::ReplayRequest& req,
                     Ptr<FlowMonitor> monitor, Ptr<FlowClassifier> classifier) override {
        if (g_viz.Done()) return false;
        g_viz.Start(req.path, "\"harness\":\"anthocnet-compare\"," + req.header, run.nodes, monitor,
                    DynamicCast<Ipv4FlowClassifier>(classifier), req.dataPort, req.step,
                    run.simTime, 1.0);
        return true;
    }
    void FinishReplay(uint64_t tx, uint64_t rx, double pdr) override { g_viz.Finish(tx, rx, pdr); }
    // The pending queue and the local-repair discard exist in no other arm
    // (elsewhere they stay at the -1 "not applicable" sentinel). A packet
    // re-injected after a MAC failure (#46) and then aged out was still
    // waiting for a route that had existed and did not come back -- the
    // reconvergence cause, not a separate one.
    void FillDropDetail(bench::RunContext& run, bench::DropDetail& d) override {
        d.holdCauses = true;
        d.ownReinjected = true;
        for (uint32_t i = 0; i < run.nodes.GetN(); ++i) {
            Ptr<Ipv4> ip = run.nodes.Get(i)->GetObject<Ipv4>();
            if (!ip) continue;
            Ptr<RoutingProtocol> ahn = DynamicCast<RoutingProtocol>(ip->GetRoutingProtocol());
            if (!ahn) continue;
            const HoldStats& s = ahn->HoldTimeStats();
            d.holdSetup += s.droppedCount[HOLD_SETUP];
            d.holdReconv += s.droppedCount[HOLD_RECONV] + s.droppedCount[HOLD_REPAIR];
            d.repairPkts += ahn->RepairDiscardedPackets();
            d.reinjected += ahn->MacReinjectedPackets();
        }
    }
    // #308 phase 2 step 4: the hold-time attribution, gathered on every run,
    // not just under --diag, for ##HOLD##.
    bool CollectHoldTimes(bench::RunContext& run, std::vector<bench::HoldTime>& hold) override {
        bool any = false;
        for (uint32_t i = 0; i < run.nodes.GetN() && !any; ++i) {
            Ptr<Ipv4> ip = run.nodes.Get(i)->GetObject<Ipv4>();
            any = ip && DynamicCast<RoutingProtocol>(ip->GetRoutingProtocol());
        }
        if (!any) return false;
        const HoldStats h = SumHoldStats(run);
        hold.assign(kHoldReasons, bench::HoldTime());
        for (uint8_t hr = 0; hr < kHoldReasons; ++hr) {
            hold[hr].deliveredCount = h.deliveredCount[hr];
            hold[hr].deliveredSumS = h.deliveredSumS[hr];
            hold[hr].deliveredMaxS = h.deliveredMaxS[hr];
        }
        return true;
    }
    void AppendDiag(bench::RunContext& run, const bench::Measurement& m,
                    std::ostream& out) override {
        out << " antTx[hello=" << m.TypedControlTxCount(0x01)
            << ",reactive=" << m.TypedControlTxCount(0x02)
            << ",proactive=" << m.TypedControlTxCount(0x04)
            << ",repair=" << m.TypedControlTxCount(0x08)
            << ",linkfail=" << m.TypedControlTxCount(0x10) << "]"
            << " antRx[hello=" << m.TypedControlRxCount(0x01)
            << ",reactive=" << m.TypedControlRxCount(0x02)
            << ",proactive=" << m.TypedControlRxCount(0x04)
            << ",repair=" << m.TypedControlRxCount(0x08)
            << ",linkfail=" << m.TypedControlRxCount(0x10) << "]";
        // Issue #20: origin vs propagation split of the linkfail volume
        // (origins = antTx[linkfail] - linkfailProp; budgetDrop counts
        // propagations suppressed by the inherited broadcastBudget).
        uint64_t lfProp = 0, lfBudget = 0, lfSuppressed = 0;
        // Reactive ants steered by the diffusion gradient instead of
        // broadcast (EnableDirectedReactive). Always 0 with the default
        // gate off; on an enabled arm it is the "did the mechanism engage"
        // number to read *before* comparing NRL between the two arms.
        uint64_t steers = 0;
        for (uint32_t i = 0; i < run.nodes.GetN(); ++i) {
            Ptr<Ipv4> ip = run.nodes.Get(i)->GetObject<Ipv4>();
            if (!ip) continue;
            Ptr<RoutingProtocol> ahn = DynamicCast<RoutingProtocol>(ip->GetRoutingProtocol());
            if (!ahn) continue;
            lfProp += ahn->LinkfailPropagations();
            lfBudget += ahn->LinkfailBudgetDrops();
            lfSuppressed += ahn->LinkfailOriginsSuppressed();
            steers += ahn->DirectedSteers();
        }
        out << " linkfailProp=" << lfProp << " linkfailBudgetDrop=" << lfBudget
            << " linkfailOrigSuppressed=" << lfSuppressed << " directedSteers=" << steers;

        // Issue #133: pheromone-table size gauge at end of run. Per node
        // the table grows with destinations x neighbours (regular +
        // virtual) and only evaporation / link-failure removal shrink it,
        // so avg/max across nodes is the growth observable for long runs
        // (notably the enableEvaporation=false ablation).
        uint64_t ptRegSum = 0, ptRegMax = 0, ptVirSum = 0, ptVirMax = 0;
        uint32_t ptNodes = 0;
        for (uint32_t i = 0; i < run.nodes.GetN(); ++i) {
            Ptr<Ipv4> ip = run.nodes.Get(i)->GetObject<Ipv4>();
            if (!ip) continue;
            Ptr<RoutingProtocol> ahn = DynamicCast<RoutingProtocol>(ip->GetRoutingProtocol());
            if (!ahn) continue;
            ++ptNodes;
            const uint64_t reg = ahn->PtableEntriesRegular();
            const uint64_t vir = ahn->PtableEntriesVirtual();
            ptRegSum += reg;
            ptVirSum += vir;
            if (reg > ptRegMax) ptRegMax = reg;
            if (vir > ptVirMax) ptVirMax = vir;
        }
        out << " ptable[regAvg=" << (ptNodes ? static_cast<double>(ptRegSum) / ptNodes : 0.0)
            << ",regMax=" << ptRegMax
            << ",virAvg=" << (ptNodes ? static_cast<double>(ptVirSum) / ptNodes : 0.0)
            << ",virMax=" << ptVirMax << "]";

        // Issue #21: pending-queue hold-time attribution. dOff50 is ~3 ms
        // (#88) so the delay/jitter gap vs AODV is carried by queue-held
        // packets; this splits the delivered hold time (and the aged-out
        // drops) across the setup / reconvergence / repair hold paths so
        // the dominant one can be attacked. Summed across nodes.
        const HoldStats hs = SumHoldStats(run);  // the same sum as ##HOLD## (#308)
        // #215: the repair-discard cause from both sides — the core's
        // simulator-agnostic event count (how many local repairs expired)
        // and the adapter's packet count (how much data each released).
        uint64_t repairEvents = 0, repairPkts = 0, macReinjected = 0;
        for (uint32_t i = 0; i < run.nodes.GetN(); ++i) {
            Ptr<Ipv4> ip = run.nodes.Get(i)->GetObject<Ipv4>();
            if (!ip) continue;
            Ptr<RoutingProtocol> ahn = DynamicCast<RoutingProtocol>(ip->GetRoutingProtocol());
            if (!ahn) continue;
            repairEvents += ahn->RepairDiscards();
            repairPkts += ahn->RepairDiscardedPackets();
            macReinjected += ahn->MacReinjectedPackets();
        }
        static const char* kReasonName[3] = {"setup", "reconv", "repair"};
        out << " hold[";
        for (uint8_t r = 0; r < kHoldReasons; ++r) {
            const double meanMs =
                hs.deliveredCount[r] ? 1000.0 * hs.deliveredSumS[r] / hs.deliveredCount[r] : 0.0;
            out << (r ? " " : "") << kReasonName[r] << "=" << hs.deliveredCount[r] << "/"
                << std::setprecision(1) << meanMs << "ms/max" << std::setprecision(1)
                << 1000.0 * hs.deliveredMaxS[r] << "ms";
        }
        out << "] holdDrop[";
        for (uint8_t r = 0; r < kHoldReasons; ++r) {
            out << (r ? " " : "") << kReasonName[r] << "=" << hs.droppedCount[r];
        }
        out << "]" << " repairDiscard=" << repairEvents << "ev/" << repairPkts
            << "pkt macReinject=" << macReinjected;
    }

private:
    static double EnergyProbe(double (*residual)(uint32_t), uint32_t node) {
        return residual(node);
    }
    AntHocNetHelper m_helper;
};

Ptr<bench::Arm> MakeAntHocNetArm() { return Create<AntHocNetArm>(); }

// Every AntHocNet attribute at its *effective* value. ns-3 routes
// `--ns3::anthocnet::RoutingProtocol::X=Y` through Config::SetDefault, which
// rewrites the TypeId's stored initial value -- so reading it back here
// reports overrides and compiled defaults alike, and any lever a future sweep
// adds is carried without touching this code. Printed whether or not the arm
// is listed: the row is provenance for this project's own knobs.
void DumpConfig(std::ostream& out) {
    TypeId tid = RoutingProtocol::GetTypeId();
    // std::size_t rather than decltype(GetAttributeN()): the return type
    // changed from uint32_t to std::size_t across the ns-3 versions in the
    // matrix, and both convert to std::size_t without a sign-compare warning.
    const std::size_t nAttr = tid.GetAttributeN();
    for (std::size_t a = 0; a < nAttr; ++a) {
        const TypeId::AttributeInformation info = tid.GetAttribute(a);
        if (!info.initialValue || !info.checker) continue;
        out << "##CONFIG## attr " << info.name << '='
            << info.initialValue->SerializeToString(info.checker) << '\n';
    }
}

}  // namespace
}  // namespace anthocnet

namespace bench {
void RegisterArms_anthocnet() {
    RegisterArm("anthocnet", "AntHocNet (Di Caro, Ducatelle & Gambardella 2004), this project",
                &anthocnet::MakeAntHocNetArm);
    Registry().AddConfigDump(&anthocnet::DumpConfig);
}
}  // namespace bench
}  // namespace ns3
