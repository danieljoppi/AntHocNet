// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

#ifndef ROUTING_BENCH_ARM_H
#define ROUTING_BENCH_ARM_H

/**
 * The arm contract of the protocol-agnostic comparison harness (ADR-0027).
 * An arm is one routing protocol the harness can run. It is created fresh for
 * every (seed, arm) run, so no state leaks from one run into the next, and
 * the harness calls its hooks in the fixed order ADR-0027 §2 lists. Every
 * hook but the first three is optional and does nothing by default.
 *
 * Arms reach the harness's measurement through `Measurement`: the sinks an
 * arm may connect its protocol's trace sources to, and the opt-in books
 * (re-injection identity, pending-queue conservation) whose lines are printed
 * only for the arms that ask for them (#382: absence, not zero).
 */

#include "ns3/flow-classifier.h"
#include "ns3/flow-monitor.h"
#include "ns3/internet-stack-helper.h"
#include "ns3/ipv4-header.h"
#include "ns3/ipv4-interface-container.h"
#include "ns3/ipv4-l3-protocol.h"
#include "ns3/net-device-container.h"
#include "ns3/node-container.h"
#include "ns3/packet.h"
#include "ns3/simple-ref-count.h"
#include "ns3/string.h"
#include "ns3/yans-wifi-helper.h"

#include <cstdint>
#include <map>
#include <ostream>
#include <string>
#include <vector>

// WifiMacQueueItem was renamed to WifiMpdu (wifi-mac-queue-item.h ->
// wifi-mpdu.h) in ns-3.37; the WifiMac "DroppedMpdu"/"AckedMpdu" traces and
// the MAC queues' "Enqueue" trace carry this type. Decided by the header's
// presence, not a compile definition: arm modules include this header too,
// and a definition would be scoped to routing-bench's own directory.
#if !__has_include("ns3/wifi-mpdu.h")
#include "ns3/wifi-mac-queue-item.h"
#define BENCH_WIFI_MPDU ns3::WifiMacQueueItem
#else
#include "ns3/wifi-mpdu.h"
#define BENCH_WIFI_MPDU ns3::WifiMpdu
#endif

namespace ns3 {
namespace bench {

/// What one run gives an arm.
struct RunContext {
    NodeContainer nodes;
    NetDeviceContainer devices;  ///< what IP is bound to (set before InstallRouting)
    NetDeviceContainer radios;   ///< the wifi interfaces (== devices off a mesh)
    uint32_t seed = 0;
    std::string transport;  ///< "udp" or "tcp"
    std::string standard;   ///< "80211b" or "80211a"
    std::string rateManager;
    double simTime = 0.0;
    double areaX = 0.0, areaY = 0.0, areaZ = 0.0;
    double energyJ = 0.0;  ///< 0: energy accounting off
    /// Residual battery fraction of node i (valid when energyJ > 0).
    double (*residualEnergy)(uint32_t) = nullptr;
    bool diag = false;              ///< --diag
    bool qdiag = false;             ///< --qdiag
    std::string scenario;           ///< --scenario (Configure, Validate)
    std::vector<std::string> args;  ///< the command line (Configure)
};

/// A run's tallies before the marker lines are printed. An arm whose
/// protocol refuses sends at the source adds them back here (#510, #466).
struct RunCounts {
    uint64_t txPackets = 0;  ///< offered data packets
    uint64_t dropRoute = 0;  ///< of those, lost for want of a route
};

/// The drop-book detail only some protocols can report (#215, #308).
struct DropDetail {
    bool holdCauses = false;     ///< the protocol has a pending queue it measures
    uint64_t holdSetup = 0;      ///< aged out of the pending queue, never routed
    uint64_t holdReconv = 0;     ///< aged out after the route was lost
    uint64_t repairPkts = 0;     ///< discarded after a failed local repair
    bool ownReinjected = false;  ///< the protocol counts its own MAC re-injections
    uint64_t reinjected = 0;     ///< data packets re-routed after a MAC drop
};

/// Pending-queue hold times by hold reason (#308), for ##HOLD##.
struct HoldTime {
    uint64_t deliveredCount = 0;
    double deliveredSumS = 0.0;
    double deliveredMaxS = 0.0;
};

/// The run's replay request (--vizTrace, #641).
struct ReplayRequest {
    std::string path;    ///< --vizTrace
    std::string header;  ///< the scenario part of the replay header (JSON fields)
    double step = 0.0;   ///< --vizStep
    uint16_t dataPort = 0;
};

/// Device installation for an arm that brings its own devices (802.11s).
struct DeviceRequest {
    YansWifiPhyHelper* phy = nullptr;
    WifiStandard standard;
};

/**
 * #51/#708: put the run's rate manager on any helper with
 * SetRemoteStationManager (WifiHelper, MeshHelper), so a mesh arm gets the
 * identical radio. The ns-3 default (IdealWifiManager) oscillates 1<->11
 * Mbps and loses every second unicast to retry exhaustion (DSSS 11 Mbps never
 * delivers in this setup), halving PDR for every protocol. Default is the
 * paper's fixed 2 Mbit/s radio; --rateManager reaches the alternatives.
 */
template <typename Helper>
void ApplyRateManager(Helper& helper, const std::string& rateManager, const std::string& standard) {
    if (rateManager == "arf") {
        helper.SetRemoteStationManager("ns3::ArfWifiManager");
    } else if (rateManager.rfind("constant", 0) == 0) {
        std::string rate = rateManager == "constant1"   ? "DsssRate1Mbps"
                           : rateManager == "constant2" ? "DsssRate2Mbps"
                           : rateManager == "constant5" ? "DsssRate5_5Mbps"
                           : rateManager == "constant6" ? "OfdmRate6Mbps"  // #708, 11a
                                                        : "DsssRate11Mbps";
        // 802.11a's lowest (basic) rate carries control, as DSSS 1 Mbit/s
        // does on 802.11b.
        helper.SetRemoteStationManager(
            "ns3::ConstantRateWifiManager", "DataMode", StringValue(rate), "ControlMode",
            StringValue(standard == "80211a" ? "OfdmRate6Mbps" : "DsssRate1Mbps"));
    }  // "ideal": keep the WifiHelper default
}

/**
 * The harness's measurement, as far as an arm may touch it. Every sink has a
 * trace-source signature, so an arm connects it with
 * MakeCallback(&Measurement::X, &m).
 */
class Measurement {
public:
    virtual ~Measurement() = default;
    /// Routing-control packets and bytes counted this run (NRL's numerator).
    virtual uint64_t ControlPackets() const = 0;
    virtual uint64_t ControlBytes() const = 0;
    /// Data bytes delivered this run (FlowMonitor rxBytes, nrl_bytes'
    /// denominator); valid from EmitRunNote on (#808).
    virtual double DeliveredDataBytes() const = 0;

    /// #386: track what MAC re-injected data packets then do, and emit
    /// ##REINJ## for this run. Connects the given node's routing protocol's
    /// "MacReinject" and "MacReinjectSkip" traces and the node's L3 "Drop".
    virtual void TrackReinjectionIdentity() = 0;
    /// #563: count data packets a protocol re-routes after a MAC or an ARP
    /// drop, to net them out of the drop book's mac column.
    virtual void MacReinjectedData(const Ipv4Header& ip, Ptr<const Packet> p) = 0;
    virtual void ArpReinjectedData(const Ipv4Header& ip, Ptr<const Packet> p) = 0;
    virtual uint64_t ReinjectedData() const = 0;
    /// #761: book every data packet's terminal fate, not its loss events, for
    /// a protocol that re-routes after a MAC or an ARP drop (UDP only: the
    /// (flow, seq) key does not exist under TCP). The drop book's mac, route,
    /// ttl and chan columns then count packets, and ##DROPID## gains the fate
    /// partition.
    virtual void TrackPacketFate() = 0;
    /// #229: pending-queue conservation (pqSilent/pqEcb on ##DROPID##).
    virtual void TrackPendingQueue() = 0;
    /// #708: 802.11s frames, counted where they are queued.
    virtual void MeshManagementEnqueue(Ptr<const BENCH_WIFI_MPDU> mpdu) = 0;
    virtual void MeshDataEnqueue(uint32_t node, Ptr<const BENCH_WIFI_MPDU> mpdu) = 0;
    virtual uint64_t MeshPeeringFrames() const = 0;
    virtual uint64_t MeshBeacons() const = 0;
    /// Control messages by type byte, under --diag (AntHocNet's ant "Tx"/"Rx"
    /// trace signatures); also the `ant=` field of the --seriesEvery samples.
    virtual void TypedControlTx(uint8_t type, uint8_t dir, bool broadcast) = 0;
    virtual void TypedControlRx(uint8_t type, uint8_t dir) = 0;
    virtual uint64_t TypedControlTxCount(uint8_t type) const = 0;
    virtual uint64_t TypedControlRxCount(uint8_t type) const = 0;
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

    /// Per-family settings of the arm's measuring instrument (never a
    /// protocol default, ADR-0019). Called once per listed arm while the
    /// scenario is resolved.
    virtual void Configure(const RunContext& scenario) {}
    /// Refuse a configuration the arm cannot run honestly. Called once per
    /// listed arm before any run.
    virtual void Validate(const RunContext& scenario) const {}
    /// ##CONFIG## lines this arm adds when it is listed.
    virtual void EmitConfig(std::ostream& out) const {}

    /// True if the arm installs its own devices instead of ad-hoc Wi-Fi.
    virtual bool ProvidesDevices() const { return false; }
    /// Install the devices; `radios` receives the wifi interfaces.
    virtual NetDeviceContainer InstallDevices(RunContext& run, const DeviceRequest& req,
                                              NetDeviceContainer& radios) {
        return NetDeviceContainer();
    }
    /// Pin the provided devices' streams from `stream`; return the count.
    virtual int64_t AssignDeviceStreams(RunContext& run, int64_t stream) { return 0; }

    /// After the internet stack is installed (post-stack wiring).
    virtual void AfterStack(RunContext& run) {}
    /// Connect protocol traces to the harness's measurement.
    virtual void ConnectTraces(RunContext& run, Measurement& m) {}
    /// After the IPv4 addresses are assigned.
    virtual void AfterAddresses(RunContext& run, const Ipv4InterfaceContainer& ifs) {}
    /// Start recording the replay (--vizTrace); true if this run records.
    virtual bool StartReplay(RunContext& run, const ReplayRequest& req, Ptr<FlowMonitor> monitor,
                             Ptr<FlowClassifier> classifier) {
        return false;
    }
    virtual void FinishReplay(uint64_t tx, uint64_t rx, double pdr) {}

    /// Correct the run's tallies, e.g. for packets refused at the source.
    virtual void AdjustCounts(RunContext& run, RunCounts& counts) {}
    /// A per-run note printed after the counts (e.g. `# hwmp`).
    virtual void EmitRunNote(RunContext& run, const Measurement& m, std::ostream& out) {}
    /// The drop-book detail this protocol can report.
    virtual void FillDropDetail(RunContext& run, DropDetail& d) {}
    /// Pending-queue hold times by reason; false if the protocol has none.
    virtual bool CollectHoldTimes(RunContext& run, std::vector<HoldTime>& hold) { return false; }
    /// Fields appended to the `# diag` line.
    virtual void AppendDiag(RunContext& run, const Measurement& m, std::ostream& out) {}
    /// Diagnostics after the markers (e.g. ##ORACLE##).
    virtual void EmitDiagnostics(RunContext& run, const Measurement& m, double nrl,
                                 std::ostream& out) {}
    /// Abort on a broken invariant of the arm.
    virtual void Check(RunContext& run, const Measurement& m) {}
};

using ArmFactory = Ptr<Arm> (*)();
/// Module-level ##CONFIG## lines, printed whether or not the arm is listed.
using ConfigDump = void (*)(std::ostream&);

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
    void AddConfigDump(ConfigDump dump) { m_dumps.push_back(dump); }
    const std::vector<ConfigDump>& ConfigDumps() const { return m_dumps; }

private:
    struct Entry {
        std::string summary;
        ArmFactory make;
    };
    std::map<std::string, Entry> m_arms;
    std::vector<ConfigDump> m_dumps;
};

/// The process-wide registry the harness reads.
ArmRegistry& Registry();

/// Add an arm to the process-wide registry; aborts on a duplicate or empty
/// name, so two modules can never silently claim one `--protocols` token.
void RegisterArm(const std::string& name, const std::string& summary, ArmFactory make);

/// Run the comparison harness over the registered arms. `program` names it
/// in --PrintHelp (`routing-compare`, or its alias `anthocnet-compare`).
int RunHarness(int argc, char* argv[], const std::string& program);

}  // namespace bench
}  // namespace ns3

#endif  // ROUTING_BENCH_ARM_H
