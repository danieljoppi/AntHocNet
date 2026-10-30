// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/*
 * The adaptive comparators as arms of the comparison harness (ADR-0027,
 * #768), compiled in only when routing-bench is installed beside this module:
 * ARA (#586), Termite (#587) and tabular Q-routing (#588), each written from
 * its paper, and BeeAdHoc (#589, v2.7.0), written from the PG 460 report
 * (README.md has the fidelity sheets).
 */

#include "ns3/adaptive-helper.h"
#include "ns3/adaptive-routing-base.h"
#include "ns3/beeadhoc-routing-protocol.h"
#include "ns3/ipv4.h"
#include "ns3/routing-bench-arm.h"

#include <algorithm>

namespace ns3 {
namespace adaptive {
namespace {

class AdaptiveArm : public bench::Arm {
public:
    AdaptiveArm(const std::string& name, const std::string& type) : m_name(name), m_helper(type) {}
    std::string Name() const override { return m_name; }
    void InstallRouting(InternetStackHelper& internet, bench::RunContext&) override {
        internet.SetRoutingHelper(m_helper);
    }
    int64_t AssignStreams(bench::RunContext& run, int64_t stream) override {
        return m_helper.AssignStreams(run.nodes, stream);
    }
    // v2.5.0 (#563): each packet the arm re-routes after a MAC or an ARP drop
    // is reported, and the drop book nets the data ones out of the mac column.
    void ConnectTraces(bench::RunContext& run, bench::Measurement& m) override {
        for (uint32_t i = 0; i < run.nodes.GetN(); ++i) {
            Ptr<RoutingBase> rb =
                DynamicCast<RoutingBase>(run.nodes.Get(i)->GetObject<Ipv4>()->GetRoutingProtocol());
            if (!rb) continue;
            rb->TraceConnectWithoutContext(
                "MacReinject", MakeCallback(&bench::Measurement::MacReinjectedData, &m));
            rb->TraceConnectWithoutContext(
                "ArpReinject", MakeCallback(&bench::Measurement::ArpReinjectedData, &m));
        }
        // #761: a re-routed packet can be lost on several hops, so its drops
        // are booked per packet (its terminal fate), not per event.
        if (run.transport != "tcp") m.TrackPacketFate();
    }
    // #805: how long data waited in RoutingBase's hold queue, by reason, in
    // ##HOLD##'s setup / reconv / repair columns (AntHocNet's marker).
    bool CollectHoldTimes(bench::RunContext& run, std::vector<bench::HoldTime>& hold) override {
        hold.assign(RoutingBase::HOLD_REASONS, bench::HoldTime());
        bool any = false;
        for (uint32_t i = 0; i < run.nodes.GetN(); ++i) {
            Ptr<RoutingBase> rb =
                DynamicCast<RoutingBase>(run.nodes.Get(i)->GetObject<Ipv4>()->GetRoutingProtocol());
            if (!rb) continue;
            any = true;
            for (int r = 0; r < RoutingBase::HOLD_REASONS; ++r) {
                const RoutingBase::HoldStats& h = rb->Hold(static_cast<RoutingBase::HoldReason>(r));
                hold[r].deliveredCount += h.count;
                hold[r].deliveredSumS += h.sumS;
                hold[r].deliveredMaxS = std::max(hold[r].deliveredMaxS, h.maxS);
            }
        }
        return any;
    }

private:
    std::string m_name;
    AdaptiveHelper m_helper;
};

// BeeAdHoc rates routes by each hop's battery (Listing 13.7): it reads the
// harness's energy accounting through a probe, the anthocnet arm's pattern
// (#145, #801). Off with --energyJ=0.
class BeeAdHocArm : public AdaptiveArm {
public:
    BeeAdHocArm() : AdaptiveArm("beeadhoc", "ns3::adaptive::BeeAdHocRoutingProtocol") {}
    void AfterStack(bench::RunContext& run) override {
        if (run.energyJ <= 0.0 || !run.residualEnergy) return;
        for (uint32_t i = 0; i < run.nodes.GetN(); ++i) {
            Ptr<BeeAdHocRoutingProtocol> bee = DynamicCast<BeeAdHocRoutingProtocol>(
                run.nodes.Get(i)->GetObject<Ipv4>()->GetRoutingProtocol());
            if (bee) bee->SetEnergyProbe(MakeBoundCallback(&EnergyProbe, run.residualEnergy, i));
        }
    }

private:
    static double EnergyProbe(double (*residual)(uint32_t), uint32_t node) {
        return residual(node);
    }
};

Ptr<bench::Arm> MakeAraArm() {
    return Create<AdaptiveArm>("ara", "ns3::adaptive::AraRoutingProtocol");
}
Ptr<bench::Arm> MakeTermiteArm() {
    return Create<AdaptiveArm>("termite", "ns3::adaptive::TermiteRoutingProtocol");
}
Ptr<bench::Arm> MakeQRoutingArm() {
    return Create<AdaptiveArm>("qrouting", "ns3::adaptive::QRoutingProtocol");
}

Ptr<bench::Arm> MakeBeeAdHocArm() { return Create<BeeAdHocArm>(); }

}  // namespace
}  // namespace adaptive

namespace bench {
void RegisterArms_adaptive() {
    RegisterArm("ara", "ARA (Gunes et al. 2002), purely reactive ACO (#586)",
                &adaptive::MakeAraArm);
    RegisterArm("termite", "Termite (Roth & Wicker 2003), stigmergic (#587)",
                &adaptive::MakeTermiteArm);
    RegisterArm("qrouting", "tabular Q-routing (Boyan & Littman 1994) (#588)",
                &adaptive::MakeQRoutingArm);
    RegisterArm("beeadhoc", "BeeAdHoc (Wedde et al. 2005), bee-inspired source routing (#589)",
                &adaptive::MakeBeeAdHocArm);
}
}  // namespace bench
}  // namespace ns3
