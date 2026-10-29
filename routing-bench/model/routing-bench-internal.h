// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

#ifndef ROUTING_BENCH_INTERNAL_H
#define ROUTING_BENCH_INTERNAL_H

/*
 * What the harness's two halves share (#767): routing-bench-run.cc builds,
 * runs and measures one (seed, arm) run (RunOne); routing-bench-harness.cc
 * parses the command line, drives the runs and prints the summary
 * (RunHarness). Not installed: a program built on the harness uses
 * ns3::bench::RunHarness and the arm registry (routing-bench-arm.h).
 */

#include "routing-bench-arm.h"

#include <cstdint>
#include <string>
#include <vector>

namespace routing_bench_detail {

using namespace ns3;

// #209 energy-model defaults; see the energy block in routing-bench-run.cc.
constexpr double kDefaultTxCurrentA = 0.380;
constexpr double kDefaultRxCurrentA = 0.313;
constexpr double kDefaultIdleCurrentA = 0.273;
constexpr double kDefaultVoltageV = 3.0;
constexpr double kDefaultEnergyJ = 5000.0;
// #217 path-diversity window (s); see the route-quality block in routing-bench-run.cc.
constexpr double kDefaultPathWindowS = 10.0;

// --diag / --qdiag: bound by the command line, read by the run's sinks.
extern bool g_diag;
extern bool g_qdiag;

struct Params {
    uint32_t nNodes;
    double simTime;
    double areaX, areaY;
    // #480: vertical extent of the field (m). 0 (the default, and what every
    // published number was measured under) keeps the harness planar and
    // byte-identical; > 0 places and moves nodes in a 3-D box for the FANET
    // family (#300). See the --areaZ refusals in main() for the arms that
    // cannot honour it.
    double areaZ;
    double speed;
    // #482: lower bound of the per-node speed draw U(speedMin, speed). 1 m/s
    // (the default, and what every published number used) keeps the draw
    // byte-identical; the FANET preset raises it to 10 m/s.
    double speedMin;
    double pause;
    double range;  // 0 => ns-3 default channel (log-distance)
    uint32_t nFlows;
    double cbrBps;
    // #521: the sources' OnOff off-phase (s). 0 (default) = constant bit rate,
    // as every page documents. Before #521 the harness left ns-3's default of
    // 1 s on / 1 s off, which halved the offered rate; --offTime=1 reproduces
    // that schedule exactly, for paired A/B against the pre-#521 corpus.
    double offTime;
    double startWindow;
    std::string propagation;  // "range" (disk, default) | "tworay" (two-ray ground, #24)
    std::string rateManager;  // "constant2" (paper's 2 Mbit/s radio, default) | ... (#51)
    std::string standard;     // "80211b" (default) | "80211a" (#708: the static mesh's radio)
    int32_t sink;             // >=0: all flows converge on this node (gateway
                              // hotspot, #71); <0: default i->(n-1-i) pairing.
    // #209 energy model (see the provenance block above main()).
    double energyJ;   // initial energy per node (J)
    double voltageV;  // supply voltage (V)
    double txCurrentA, rxCurrentA, idleCurrentA;
    // #217: window over which "distinct next hops used for a destination" is
    // counted (s). See the path-diversity block above main().
    double pathWindowS;
    // #61: mobility model. "rwp" (Random Waypoint, the default and the model
    // every published number was measured under) | "ssrwp" (steady-state RWP,
    // no speed-decay transient) | "gaussmarkov" (smooth correlated tracks).
    std::string mobility;
    // #63: transport. "udp" (CBR OnOff, the default and what every published
    // number was measured under) | "tcp" (saturating BulkSend). Read the
    // metric-semantics warning above the flow loop before quoting a TCP cell.
    std::string transport;
    // #488: the Manhattan grid (--mobility=manhattan) and the buildings of the
    // urban channel (--propagation=urban) share one geometry: blocksX x blocksY
    // blocks over areaX x areaY, streets on the block edges.
    uint32_t blocksX, blocksY;
    double streetWidth;
    std::string buildings;  // #580: explicit buildings for the urban channel
    // #639: replay a scene. --mobility=trace moves the nodes along an ns-2
    // movement trace (Ns2MobilityHelper); --flowsFile replaces the generated
    // i -> n-1-i pairing with explicit flows. --dumpTrace / --dumpFlows write
    // a generated run's movement and flows in those formats, so a run can be
    // replayed -- and the replay checked byte-identical against it.
    std::string traceFile;
    struct FlowSpec {
        uint32_t src, dst;
        double start, stop, bps;
    };
    std::vector<FlowSpec> flowList;
    std::string dumpTrace, dumpFlows;
    std::string vizTrace;  // #641: --vizTrace, the first anthocnet run as a replay
    double vizStep = 1.0;
    double seriesEvery = 0.0;  // #62: --seriesEvery, 0 = off
};

struct Result {
    std::string proto;
    uint64_t txPackets = 0;
    uint64_t rxPackets = 0;
    double pdr = 0.0;  // %
    double meanDelayMs = 0.0;
    double delay99Ms = 0.0;  // 99th pct over *delivered* packets
    double throughputKbps = 0.0;
    double nrl = 0.0;       // control pkts / delivered data pkts
    double nrlBytes = 0.0;  // #132: control bytes / delivered data bytes
    // #57 paper-parity / survivorship-safe QoS metrics:
    double jitterMs = 0.0;      // mean delay jitter (the paper's QoS metric)
    double jitterEq51Ms = 0.0;  // #89: the thesis's eq 5.1, a different quantity
    double dOff50Ms = -1.0;     // delay at the 50th pct of *offered* (sent)
    double dOff90Ms = -1.0;     // packets, undelivered = inf; -1 encodes inf
    // #308: the delivered-delay histogram this run's percentiles were read
    // from, retained so a *matched-delivery* percentile can be taken after all
    // protocols have run. delay99 compares tails over different-sized
    // delivered sets — AntHocNet delivers ~10 pp more than AODV — so part of
    // its worse tail may be the packets AODV never delivered at all. Answering
    // that needs one protocol's distribution queried at another's delivery
    // count, which is only possible once both exist.
    std::map<uint32_t, uint64_t> delayHist;  // bin index -> delivered count
    double delayBinWidth = 0.0;              // seconds; 0 when no deliveries
    // #308: (flow, seq) -> delay (s) for every delivered packet, so the tails
    // can be compared over the packets *every* protocol delivered rather than
    // over each protocol's own differently-sized delivered set.
    std::map<Address, std::map<uint32_t, double>> rxDelayBySeq;
    // #308 phase 2: the same keys carrying hop counts, so the common set can be
    // normalised by path length like-for-like.
    std::map<Address, std::map<uint32_t, uint32_t>> rxHopsBySeq;
    // #308 phase 2 step 4: pending-queue hold-time attribution, summed over
    // nodes. `holdValid` is false for every arm whose protocol has no measured
    // pending queue (AntHocNet has one) — see the ##HOLD## emission for why
    // absence, not zero, is the right representation there.
    std::vector<bench::HoldTime> hold;
    bool holdValid = false;
    // #209 energy:
    // #308 phase 2 step 3: channel occupancy summed over nodes (node-seconds).
    // -1 = not measured (the PHY State trace is only connected when the energy
    // model is on), which suppresses the ##AIR## row entirely.
    double airTxS = -1.0, airRxS = -1.0, airCcaS = -1.0;
    // #63: application bytes actually delivered, per second, summed over the
    // PacketSinks. Distinct from throughputKbps, which is FlowMonitor's
    // delivered *IP* bytes and therefore counts TCP retransmissions. On UDP the
    // two agree; on TCP their gap is the retransmission overhead, which is why
    // this is the TCP arm's headline rather than PDR.
    double goodputKbps = 0.0;
    double energyJ = 0.0;        // total consumed over all nodes (J)
    double energyPerPktJ = 0.0;  // energyJ / delivered data packets (J/pkt)
    double energyPerBitJ = 0.0;  // energyJ / delivered application bits (#294)
    uint64_t rxAppBytes = 0;     // application bytes at the PacketSinks (#63)
    double resMinJ = 0.0;        // residual energy across nodes: min / mean /
    double resMeanJ = 0.0;       // sample stddev (J) — the fairness spread
    double resSdJ = 0.0;
    double firstDeathS = -1.0;  // -1 = no node died (see OnPhyState)
    // #212 packet reordering (definitions in docs/benchmarks/metrics.md):
    double reorderRatio = 0.0;     // RFC 4737 Type-P-Reordered fraction, [0,1]
    double reorderRatioMax = 0.0;  // worst single flow's ratio, [0,1]
    double reorderExtMean = 0.0;   // mean reordering extent over reordered pkts
    double reorderExtMax = 0.0;    // max reordering extent, packets
    double reorderBufMax = 0.0;    // max reorder-buffer occupancy, packets
    // #215 drop causes, each as a % of *offered* (txPackets), so that
    // pdr + the five protocol-agnostic causes ≈ 100. Sentinel **-1 = not
    // applicable to this protocol** (emitted as a blank field, never a 0, so
    // "this protocol has no such cause" stays distinguishable from "measured
    // zero"); the three AntHocNet-only causes use it for every other arm.
    double dropRoutePct = 0.0;    // L3 route failure (no route / route error)
    double dropQueuePct = 0.0;    // interface/qdisc queue overflow; on the
                                  // dsdv/aodv arms also the protocol's own
                                  // pending-queue losses (#229, PqTrackTx)
    double dropMacPct = 0.0;      // MAC retry limit, terminal (not re-injected)
    double dropChanPct = 0.0;     // sent on the medium, never received
    double dropTtlPct = 0.0;      // IP TTL exhausted
    double dropSetupPct = -1.0;   // AntHocNet: pending-queue loss, never routed
    double dropReconvPct = -1.0;  // AntHocNet: pending-queue loss, route lost
    double dropRepairPct = -1.0;  // AntHocNet: DiscardPending after a failed repair
    double dropOtherPct = 0.0;    // L3 drops in none of the buckets above (diag)
    // #217 route quality. hops* are 0 when nothing was delivered and div*/
    // entropy are 0 when no data hop was ever acked, matching the `nrl` and
    // `energy_per_pkt_j` convention for an empty denominator.
    double hopsMean = 0.0;        // mean hop count over delivered data packets
    double hopsMax = 0.0;         // max hop count over delivered data packets
    double divUsed = 0.0;         // mean distinct *used* next hops per cell
    double divMax = 0.0;          // max distinct used next hops in any one cell
    double divEntropyBits = 0.0;  // mean Shannon entropy (bits) of the split
    double jain = 0.0;            // Jain's index over per-flow delivered packets
    // #294 item 4 route stability; ##ROUTE## is emitted only when routeValid
    // (UDP arms). setup* are -1 when no flow delivered or in converge mode,
    // where flows share one sink and there is no per-flow first delivery.
    bool routeValid = false;
    double setupMedS = -1.0;  // median per-flow first delivery - app start
    double setupMaxS = -1.0;  // worst flow's setup latency
    uint32_t flowsNoDelivery = 0;
    double pathChg = 0.0;        // fraction of consecutive delivered pairs whose path differs
    double pathLifeMedS = -1.0;  // median completed path lifetime (s); -1 = none completed
    uint64_t pathLifeN = 0;      // completed (uncensored) path runs
    double pathHopsMean = 0.0;   // mean path length over first deliveries
};

/// One run of `proto` on seed `seed`: build the world, run it, measure it.
Result RunOne(const std::string& proto, const Params& P, uint32_t seed);

}  // namespace routing_bench_detail

#endif  // ROUTING_BENCH_INTERNAL_H
