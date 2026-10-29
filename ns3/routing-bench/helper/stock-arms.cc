// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

#include "stock-arms.h"

#include "ns3/abort.h"
#include "ns3/aodv-helper.h"
#include "ns3/dsdv-helper.h"
#include "ns3/dsdv-routing-protocol.h"
#include "ns3/ipv4-list-routing-helper.h"
#include "ns3/ipv4-static-routing-helper.h"
#include "ns3/ipv4.h"
#include "ns3/olsr-helper.h"
#include "ns3/routing-bench-arm.h"
#include "ns3/source-refusal-counter.h"

namespace ns3 {
namespace bench {
namespace {

class AodvArm : public Arm {
public:
    std::string Name() const override { return "aodv"; }
    void InstallRouting(InternetStackHelper& internet, RunContext&) override {
        internet.SetRoutingHelper(m_aodv);
    }
    int64_t AssignStreams(RunContext& run, int64_t stream) override {
        return m_aodv.AssignStreams(run.nodes, stream);
    }

private:
    AodvHelper m_aodv;
};

// #510: OLSR behind a list router whose fallback counts the origin's refused
// sends; AdjustCounts puts them back into the offered load.
class OlsrArm : public Arm {
public:
    std::string Name() const override { return "olsr"; }
    void InstallRouting(InternetStackHelper& internet, RunContext&) override {
        m_list.Add(m_olsr, 10);
        m_list.Add(m_refusals, -10);
        internet.SetRoutingHelper(m_list);
    }
    int64_t AssignStreams(RunContext& run, int64_t stream) override {
        return m_olsr.AssignStreams(run.nodes, stream);
    }
    void AdjustCounts(RunContext&, RunCounts& counts) override {
        counts.txPackets += m_refusals.Refused();
        counts.dropRoute += m_refusals.Refused();
    }

private:
    OlsrHelper m_olsr;
    Ipv4ListRoutingHelper m_list;
    SourceRefusalCounterHelper m_refusals;
};

// #352: DsdvHelper is the one stock helper with no AssignStreams() wrapper
// anywhere in the 3.36-3.48 matrix, while dsdv::RoutingProtocol declares
// AssignStreams(int64_t) in every one of those versions. So reach the
// installed protocol objects through the nodes and do what the missing
// wrapper would do. DSDV cannot be left unpinned: its numbers must stay
// byte-identical across generations for a comparison to be attributable.
class DsdvArm : public Arm {
public:
    std::string Name() const override { return "dsdv"; }
    void InstallRouting(InternetStackHelper& internet, RunContext&) override {
        internet.SetRoutingHelper(m_dsdv);
    }
    int64_t AssignStreams(RunContext& run, int64_t stream) override {
        int64_t used = 0;
        for (auto it = run.nodes.Begin(); it != run.nodes.End(); ++it) {
            Ptr<Ipv4> ipv4 = (*it)->GetObject<Ipv4>();
            NS_ABORT_MSG_IF(!ipv4, "node has no IPv4 stack; cannot pin dsdv streams");
            Ptr<dsdv::RoutingProtocol> dsdv =
                DynamicCast<dsdv::RoutingProtocol>(ipv4->GetRoutingProtocol());
            NS_ABORT_MSG_IF(!dsdv, "expected dsdv::RoutingProtocol on this node (#352)");
            used += dsdv->AssignStreams(stream + used);
        }
        return used;
    }

private:
    DsdvHelper m_dsdv;
};

// #708: path selection is the mesh's, below IP. IP only needs the on-link
// route to the one /16 the mesh point carries, which static routing installs
// for the interface; ARP resolves over the mesh. Static routing draws nothing,
// and HWMP's streams are taken with the mesh devices: a measured zero.
class HwmpArm : public Arm {
public:
    std::string Name() const override { return "hwmp"; }
    void InstallRouting(InternetStackHelper& internet, RunContext&) override {
        internet.SetRoutingHelper(m_static);
    }
    int64_t AssignStreams(RunContext&, int64_t) override { return 0; }

private:
    Ipv4StaticRoutingHelper m_static;
};

Ptr<Arm> MakeAodvArm() { return Create<AodvArm>(); }
Ptr<Arm> MakeOlsrArm() { return Create<OlsrArm>(); }
Ptr<Arm> MakeDsdvArm() { return Create<DsdvArm>(); }
Ptr<Arm> MakeHwmpArm() { return Create<HwmpArm>(); }

}  // namespace

void RegisterStockArms() {
    RegisterArm("aodv", "AODV (stock ns-3)", &MakeAodvArm);
    RegisterArm("olsr", "OLSR (stock ns-3), source refusals counted (#510)", &MakeOlsrArm);
    RegisterArm("dsdv", "DSDV (stock ns-3)", &MakeDsdvArm);
    RegisterArm("hwmp", "802.11s HWMP path selection (stock ns-3 mesh, #708)", &MakeHwmpArm);
}

}  // namespace bench
}  // namespace ns3
