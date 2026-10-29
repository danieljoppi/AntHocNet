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
#include "ns3/arp-cache.h"
#include "ns3/ipv4-interface.h"
#include "ns3/ipv4-l3-protocol.h"
#include "ns3/mesh-helper.h"
#include "ns3/mesh-point-device.h"
#include "ns3/olsr-helper.h"
#include "ns3/qos-txop.h"
#include "ns3/txop.h"
#include "ns3/wifi-mac.h"
#include "ns3/wifi-mac-queue.h"
#include "ns3/wifi-net-device.h"
#include "ns3/routing-bench-arm.h"
#include "ns3/source-refusal-counter.h"

#include <ostream>

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
    // #229: pending-queue conservation, UDP only (the SeqTs key does not
    // exist under TCP).
    void ConnectTraces(RunContext& run, Measurement& m) override {
        if (run.transport != "tcp") m.TrackPendingQueue();
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
    // #229: as for aodv; dsdv's queue sheds packets with no signal at all.
    void ConnectTraces(RunContext& run, Measurement& m) override {
        if (run.transport != "tcp") m.TrackPendingQueue();
    }

private:
    DsdvHelper m_dsdv;
};

// #708: IEEE 802.11s path selection, the static mesh's native comparator
// (ADR-0026). Path selection is the mesh's, below IP: each node is one mesh
// point (stock Dot11sStack) on the same standard, PHY, channel and rate
// manager as every other arm, one interface on one channel, and IP sees the
// whole mesh as one link. IP only needs the on-link route to the one /16 the
// mesh point carries, which static routing installs for the interface.
class HwmpArm : public Arm {
public:
    std::string Name() const override { return "hwmp"; }
    void Validate(const RunContext& scenario) const override {
        NS_ABORT_MSG_IF(scenario.standard != "80211a",
                        "--protocols includes hwmp: stock ns-3 802.11s tunes its mesh interfaces "
                        "to 5 GHz channel 100, so it needs --standard=80211a (#708)");
    }
    bool ProvidesDevices() const override { return true; }
    NetDeviceContainer InstallDevices(RunContext& run, const DeviceRequest& req,
                                      NetDeviceContainer& radios) override {
        m_mesh.SetStandard(req.standard);
        m_mesh.SetStackInstaller("ns3::Dot11sStack");
        m_mesh.SetMacType();
        m_mesh.SetSpreadInterfaceChannels(MeshHelper::ZERO_CHANNEL);
        m_mesh.SetNumberOfInterfaces(1);
        // MeshHelper's own default manager is ARF, so "ideal" is named here
        // to match the WifiHelper default every other arm runs.
        m_mesh.SetRemoteStationManager("ns3::IdealWifiManager");
        ApplyRateManager(m_mesh, run.rateManager, run.standard);
        m_devices = m_mesh.Install(*req.phy, run.nodes);
        for (uint32_t i = 0; i < m_devices.GetN(); ++i) {
            radios.Add(DynamicCast<MeshPointDevice>(m_devices.Get(i))->GetInterfaces().at(0));
        }
        return m_devices;
    }
    // MeshHelper::AssignStreams covers the PHY, MAC and Txop variables
    // through each mesh point's interfaces, plus HWMP's and the peering
    // protocol's own jitter.
    int64_t AssignDeviceStreams(RunContext&, int64_t stream) override {
        return m_mesh.AssignStreams(m_devices, stream);
    }
    void InstallRouting(InternetStackHelper& internet, RunContext&) override {
        internet.SetRoutingHelper(m_static);
    }
    // Static routing draws nothing, and HWMP's streams were taken with the
    // mesh devices: a measured zero, as for the oracle.
    int64_t AssignStreams(RunContext&, int64_t) override { return 0; }
    // HWMP's control, counted where its frames are queued: path selection
    // and peering go to the VO (unicast) and BK (broadcast) queues, beacons
    // to the non-QoS Txop; data to BE, for the mesh hop count.
    void ConnectTraces(RunContext& run, Measurement& m) override {
        for (uint32_t i = 0; i < run.radios.GetN(); ++i) {
            Ptr<WifiNetDevice> w = run.radios.Get(i)->GetObject<WifiNetDevice>();
            Ptr<WifiMac> wmac = w ? w->GetMac() : nullptr;
            if (!wmac) continue;
            for (AcIndex ac : {AC_VO, AC_BK}) {
                wmac->GetQosTxop(ac)->GetWifiMacQueue()->TraceConnectWithoutContext(
                    "Enqueue", MakeCallback(&Measurement::MeshManagementEnqueue, &m));
            }
            wmac->GetTxop()->GetWifiMacQueue()->TraceConnectWithoutContext(
                "Enqueue", MakeCallback(&Measurement::MeshManagementEnqueue, &m));
            wmac->GetQosTxop(AC_BE)->GetWifiMacQueue()->TraceConnectWithoutContext(
                "Enqueue", MakeCallback(&Measurement::MeshDataEnqueue, &m).Bind(i));
        }
    }
    // IP sees the whole mesh as one link, so every destination is
    // ARP-resolved across the mesh. That resolution is IP's, not path
    // selection's: a request sent while the peer links are still forming
    // fails its three tries and ns-3's ArpCache then holds the destination
    // dead for DeadTimeout (100 s), during which HWMP is never even asked for
    // a path (measured: one flow at 0 % PDR with zero PREQs). The caches are
    // filled up front instead, every mesh point's address as a permanent
    // entry, so the arm measures HWMP and not ARP.
    void AfterAddresses(RunContext& run, const Ipv4InterfaceContainer& ifs) override {
        for (uint32_t i = 0; i < run.nodes.GetN(); ++i) {
            Ptr<Ipv4L3Protocol> l3 = run.nodes.Get(i)->GetObject<Ipv4L3Protocol>();
            Ptr<ArpCache> arp =
                l3->GetInterface(l3->GetInterfaceForDevice(run.devices.Get(i)))->GetArpCache();
            for (uint32_t j = 0; j < run.nodes.GetN(); ++j) {
                if (j == i) continue;
                ArpCache::Entry* e = arp->Add(ifs.GetAddress(j));
                e->SetMacAddress(run.devices.Get(j)->GetAddress());
                e->MarkPermanent();
            }
        }
    }
    // The mesh's link maintenance, which NRL does not count, so a reader can
    // see its size beside the path selection.
    void EmitRunNote(RunContext& run, const Measurement& m, std::ostream& out) override {
        if (!run.diag) return;
        out << "# hwmp " << Name() << " seed=" << run.seed
            << " pathSelFrames=" << m.ControlPackets() << " pathSelBytes=" << m.ControlBytes()
            << " peeringFrames=" << m.MeshPeeringFrames() << " beacons=" << m.MeshBeacons() << '\n';
    }

private:
    MeshHelper m_mesh;
    NetDeviceContainer m_devices;
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
