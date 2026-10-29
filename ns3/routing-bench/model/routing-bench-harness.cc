// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/*
 * The comparison harness (ADR-0027): routing-compare, and its alias
 * anthocnet-compare. It names no protocol: every arm reaches it through the
 * registry (routing-bench-arm.h), the stock ns-3 arms from this module and
 * every other arm from its own module. Written as the AntHocNet comparison,
 * whence the paper's metrics below.
 *
 * Runs the SAME mobile-ad-hoc scenario (identical node layout, mobility and
 * CBR traffic, driven from the same RNG run) under each routing protocol and
 * reports the metrics from the AntHocNet paper [1, §4]: packet-delivery ratio,
 * mean and 99th-percentile end-to-end delay, throughput, and normalized routing
 * load (NRL = routing-control packets transmitted / data packets delivered;
 * nrl_bytes is the byte-level counterpart, control bytes / delivered data
 * bytes, #132), plus radio energy (#209): total joules consumed, joules per
 * delivered packet, the residual-energy spread across nodes and the
 * first-node-death time, integrated from the PHY's own State trace with the
 * same currents on every node for every protocol (leak-free per #256),
 * plus packet reordering (#212): the RFC 4737 out-of-order
 * delivery ratio, the reordering extent (mean/max) and the reorder-buffer
 * occupancy needed to restore order, measured per flow at the sink and then
 * aggregated,
 * and a per-cause drop
 * breakdown (#215): why the packets PDR is missing went missing — L3 route
 * failure, interface-queue overflow, MAC retry exhaustion, channel loss and TTL
 * expiry, measured identically for all four protocols and summing with PDR to
 * ~100% of offered packets,
 * and route quality
 * (#217): the hop count actually traversed by delivered packets, the number of
 * distinct next hops that actually *carried* data per destination (the direct
 * measurement of multipath), and Jain's fairness index across the flows.
 * Fair comparison: the RNG run is reset before each protocol so every protocol
 * sees the identical mobility/traffic realisation, and NRL is counted uniformly
 * for every protocol from the IP layer.
 *
 * --scenario=paper reproduces the paper's base scenario (50 nodes in a
 * 1500x300 m area, random-waypoint at 20 m/s with 30 s pause, 20 CBR sources of
 * one 64-byte packet/s, 300 m range, 900 s). Override individual knobs to sweep
 * (e.g. --scenario=paper --areaX=2500, or --scenario=paper --pause=0).
 *
 * [1] Di Caro, Ducatelle, Gambardella, "AntHocNet: an ant-based hybrid routing
 *     algorithm for mobile ad hoc networks", PPSN VIII, 2004.
 *
 * The `oracle` arm (#296 item 1, #216) is the global-knowledge shortest-path
 * CONTROL: Dijkstra over the ground-truth topology, zero control traffic, zero
 * discovery latency. It is off by default and only runs when it is named in
 * --protocols; it is an upper bound, not a competitor. See ns3/baselines/oracle/README.md
 * for what "ground truth" means per propagation model.
 *
 * The `hwmp` arm (#708) is IEEE 802.11s path selection, the static mesh's
 * native comparator (ADR-0026). It routes at layer 2: each node is one mesh
 * point (stock ns-3 `mesh` module, Dot11sStack) on the same PHY, channel and
 * rate manager as every other arm, and IP sees the whole mesh as one link.
 *
 * Requires the stock aodv, olsr, dsdv, mesh (#708) and flow-monitor modules;
 * the arm modules installed beside it register theirs. Build, then e.g.:
 *   ./ns3 run "routing-compare --scenario=paper --runs=5"
 */
#include "ns3/core-module.h"
#include "ns3/network-module.h"
#include "ns3/mobility-module.h"
#include "ns3/wifi-module.h"
#include "ns3/internet-module.h"
#include "ns3/applications-module.h"
#include "ns3/flow-monitor-module.h"
#include "ns3/ipv4-flow-classifier.h"
#include "ns3/ipv4-l3-protocol.h"
#include "ns3/tcp-header.h"
#include "ns3/udp-header.h"
// #212: the application-level sequence number the reordering metrics key on.
// Part of the applications module (already included above) since ns-3.31, so it
// is available across the whole CI matrix (3.36-3.48).
#include "ns3/seq-ts-size-header.h"
// #215 drop causes: Ipv4FlowProbe::DropReason indexes FlowStats::packetsDropped;
// LlcSnapHeader is what a wifi MPDU carries above the MAC header.
#include "ns3/ipv4-flow-probe.h"
// #217 path diversity: the WifiMac "AckedMpdu" trace carries the MPDU whose
// 802.11 header names the next hop; above that MAC header a wifi frame carries
// an LLC/SNAP header before the IP header.
#include "ns3/llc-snap-header.h"
#include "ns3/propagation-module.h"

// #708: IEEE 802.11s's mesh control header, stripped from data frames on an
// arm that brings mesh devices.
#include "ns3/mesh-module.h"

#include <algorithm>
#include <cmath>
#include <cstdint>
#include <fstream>
#include <iomanip>
#include <iterator>
#include <map>
#include <numeric>
#include <set>
#include <sstream>
#include <utility>
#include <vector>

#include "routing-bench-internal.h"

using namespace ns3;
using namespace routing_bench_detail;

namespace {

// The arms named in --protocols that the registry knows, in order. An unknown
// name is skipped here; RunOne aborts on it (#448).
std::vector<Ptr<bench::Arm>> ListedArms(const std::string& protocols) {
    std::vector<Ptr<bench::Arm>> arms;
    std::stringstream ss(protocols);
    std::string item;
    while (std::getline(ss, item, ',')) {
        Ptr<bench::Arm> a = item.empty() ? nullptr : bench::Registry().Make(item);
        if (a) arms.push_back(a);
    }
    return arms;
}

}  // namespace

int ns3::bench::RunHarness(int argc, char* argv[], const std::string& program) {
    // Sentinels (<0 / 0) mean "unset" so a preset or the legacy defaults fill in.
    std::string scenario;
    int32_t nNodes = 0;
    double simTime = -1, area = -1, areaX = -1, areaY = -1, areaZ = -1;
    double speed = -1, speedMin = -1, pause = -1, range = -1, cbrBps = -1;
    double offTime = 0.0;               // #521
    uint32_t blocksX = 0, blocksY = 0;  // #488 grid; 0 = preset (4 vanet, else 5)
    double streetWidth = 20.0;          // #488
    std::string buildings;              // #580
    int32_t nFlows = 0;
    int32_t sink = -1;
    uint32_t runs = 0;  // 0 = unset; resolved below (preset-dependent, #58)
    // #126: first RNG run of this invocation. Runs cover
    // firstRun..firstRun+runs-1, so one point's 20 seeds can be split across
    // dispatches that each fit the hosted-runner job ceiling (the 162/200-node
    // scale points exceed it at 20 seeds even on the -opt image). SetRun(s)
    // semantics are unchanged — the ##RUN##/##MATCH##/##COMMON## rows carry
    // the TRUE seed, so downstream per-seed pairing keeps working across
    // split dispatches. Default 1 keeps every existing invocation identical.
    uint32_t firstRun = 1;
    bool csv = false;
    // The default comparison, minus any arm not installed beside the harness.
    std::string protocols;
    for (const char* d : {"anthocnet", "aodv", "olsr", "dsdv"}) {
        if (bench::Registry().Has(d)) protocols += (protocols.empty() ? "" : ",") + std::string(d);
    }
    std::string armList;
    for (const std::string& n : bench::Registry().Names()) {
        armList += (armList.empty() ? "" : ",") + n;
    }

    CommandLine cmd(program);
    cmd.AddValue("scenario",
                 "Preset: 'paper' (Broch/CMU calibration field), "
                 "'thesis' (AntHocNet's own evaluation field, "
                 "Ducatelle PhD 2007 §5.1.3 — #58), 'fanet' "
                 "(3-D Gauss-Markov UAV field, #482; provenance in "
                 "docs/benchmarks/scenarios/fanet.md) or 'vanet' "
                 "(Manhattan street grid with urban building "
                 "shadowing, #488; provenance in "
                 "docs/benchmarks/scenarios/vanet.md)",
                 scenario);
    cmd.AddValue("nNodes", "Number of nodes", nNodes);
    cmd.AddValue("time", "Simulation time (s)", simTime);
    cmd.AddValue("area", "Square area side (m); shorthand for areaX=areaY", area);
    cmd.AddValue("areaX", "Area width (m)", areaX);
    cmd.AddValue("areaY", "Area height (m)", areaY);
    cmd.AddValue("areaZ",
                 "Field altitude extent (m), #480. 0 (default; 300 "
                 "for --scenario=fanet) = the "
                 "planar field every published number used; > 0 "
                 "places and moves nodes in a 3-D box (FANET, #300). "
                 "Refused with tworay/nakagami (ground-reflection "
                 "model), ssrwp (planar-only in ns-3) and the gpsr "
                 "arm (2-D headers and planarization)",
                 areaZ);
    cmd.AddValue("speed", "Max node speed (m/s)", speed);
    cmd.AddValue("speedMin",
                 "Min node speed (m/s): speeds are drawn "
                 "U(speedMin, speed). Default 1 (10 for "
                 "--scenario=fanet, #482)",
                 speedMin);
    cmd.AddValue("pause", "Random-waypoint pause time (s)", pause);
    cmd.AddValue("range", "Transmission range (m); 0 = ns-3 default channel", range);
    cmd.AddValue("flows", "Number of CBR flows", nFlows);
    cmd.AddValue("cbrBps", "Per-flow CBR rate (bits/s)", cbrBps);
    cmd.AddValue("offTime",
                 "Source off-phase in s (#521). 0 (default) = "
                 "constant bit rate; 1 = the pre-#521 schedule "
                 "(ns-3's default 1 s on / 1 s off, half the "
                 "stated rate), for paired A/B only",
                 offTime);
    cmd.AddValue("sink",
                 "If >=0, all flows converge on this node (gateway "
                 "hotspot, #71) instead of i->(n-1-i) pairing",
                 sink);
    cmd.AddValue("runs",
                 "Number of RNG runs to average (seeds 1..runs); unset "
                 "= 1, or 20 for --scenario=thesis (#58)",
                 runs);
    cmd.AddValue("firstRun",
                 "First RNG run (seed) of this invocation; runs "
                 "cover firstRun..firstRun+runs-1, so a point's "
                 "seeds can split across dispatches (#126)",
                 firstRun);
    cmd.AddValue("csv", "Emit machine-readable CSV instead of a table", csv);
    cmd.AddValue("protocols",
                 // ADR-0027 (#768): the arm list comes from the registry. The
                 // "Comma-separated list (a,b,c)" shape is what check-arm-delivery.sh
                 // reads out of --PrintHelp (#435).
                 "Comma-separated list (" + armList +
                     "). `oracle` is the #296 global-knowledge shortest-path CONTROL "
                     "(upper bound, zero control traffic), off unless named.",
                 protocols);
    cmd.AddValue("diag", "Emit per-run '# diag' lines (ant tallies, first delivery)", g_diag);
    cmd.AddValue("qdiag",
                 "Emit per-run '# qdiag' lines: per-node MAC queue depth "
                 "distribution (meanQ/maxQ/pctNonzero) — does A2 have a "
                 "signal? (#73)",
                 g_qdiag);
    std::string mobilityModel;  // "" = preset default: gaussmarkov for fanet, else rwp
    std::string transport = "udp";
    std::string propagation;  // "" = preset default: urban for vanet, else range
    cmd.AddValue("transport",
                 "Transport (#63): 'udp' (CBR OnOff, default — what every "
                 "published number was measured under) | 'tcp' (saturating "
                 "BulkSend). A TCP cell is its own regime: pdr/thrput/nrl "
                 "change meaning and the reorder columns go absent; read "
                 "##GOODPUT##.",
                 transport);
    std::string traceFile, flowsFile, dumpTrace, dumpFlows, vizTrace;
    double vizStep = 1.0;
    double seriesEvery = 0.0;
    cmd.AddValue("traceFile",
                 "#639: with --mobility=trace, the ns-2 movement trace to "
                 "replay ($node_(i) set X_/Y_/Z_, $ns_ at t \"$node_(i) "
                 "setdest x y speed\"); nNodes is taken from it",
                 traceFile);
    cmd.AddValue("flowsFile",
                 "#639: explicit flows, one 'src dst start stop cbrBps' "
                 "per line ('#' comments); replaces the generated "
                 "i -> n-1-i pairing and --flows",
                 flowsFile);
    cmd.AddValue("dumpTrace",
                 "#639: write the first run's node movement to this file "
                 "as an ns-2 trace (2-D fields only)",
                 dumpTrace);
    cmd.AddValue("vizTrace",
                 "#641: write the first anthocnet run as a replay trace (JSON "
                 "lines: positions, data books, strongest routes per step) for "
                 "the learn site's ns-3 replay",
                 vizTrace);
    cmd.AddValue("vizStep", "#641: --vizTrace sampling interval (s)", vizStep);
    cmd.AddValue("seriesEvery",
                 "#62: with --diag, sample routing control, AntHocNet ant "
                 "transmissions and per-flow deliveries every S seconds and "
                 "print them as '# series' lines (0 = off)",
                 seriesEvery);
    cmd.AddValue("dumpFlows",
                 "#639: write the first run's generated flows to this "
                 "file in --flowsFile format",
                 dumpFlows);
    cmd.AddValue("mobility",
                 "Mobility model (#61): 'rwp' (Random Waypoint, default — the "
                 "model every published number was measured under) | 'ssrwp' "
                 "(steady-state RWP, no speed-decay transient) | 'gaussmarkov' "
                 "(smooth correlated tracks; --pause is inert under it) | "
                 "'manhattan' (#488: vehicles on a --blocksX x --blocksY street "
                 "grid, Bai et al. 2003; --pause is inert under it) | 'trace' "
                 "(#639: replay --traceFile)",
                 mobilityModel);
    cmd.AddValue("blocksX",
                 "Manhattan grid / urban channel: blocks along x "
                 "(#488; streets on the block edges). Default 5 "
                 "(4 for --scenario=vanet)",
                 blocksX);
    cmd.AddValue("blocksY",
                 "Manhattan grid / urban channel: blocks along y "
                 "(#488). Default 5 (4 for --scenario=vanet)",
                 blocksY);
    cmd.AddValue("streetWidth",
                 "Urban channel: street width (m); buildings are "
                 "the blocks inset by half of it (#488)",
                 streetWidth);
    cmd.AddValue("buildings",
                 "#580: with --propagation=urban, explicit buildings "
                 "'xmin,ymin,xmax,ymax;...' (m) in place of the street grid's "
                 "blocks (the disaster scene; tools/bench/disaster_scene.py)",
                 buildings);
    cmd.AddValue("propagation",
                 "Propagation loss model: 'range' (disk) | 'tworay' (#24) | "
                 "'nakagami' (#60: the same two-ray path loss plus Nakagami-m "
                 "fading, so tworay-vs-nakagami isolates fading alone) | "
                 "'urban' (#488: the same two-ray path loss plus building "
                 "shadowing over the Manhattan grid's blocks, Sommer et al. "
                 "2011; requires --mobility=manhattan). "
                 "--range is inert under tworay, nakagami and urban.",
                 propagation);
    std::string rateManager = "constant2";
    cmd.AddValue("rateManager",
                 "Rate control: constant1|constant2|constant5|constant11 (fixed "
                 "DSSS rate; default constant2, the paper's radio) | constant6 "
                 "(fixed OFDM 6 Mbit/s, --standard=80211a only, #708) | arf | ideal "
                 "(ns-3 default; loses ~50% single-hop, #51)",
                 rateManager);
    std::string standard = "80211b";
    cmd.AddValue("standard",
                 "Radio: 80211b (default, 2.4 GHz DSSS) | 80211a (5 GHz OFDM; "
                 "needs --propagation=range and --rateManager=constant6|arf|ideal). "
                 "80211a is the static-mesh cell's radio, the band stock ns-3 "
                 "802.11s runs on, and the hwmp arm requires it (#708)",
                 standard);
    // #209 energy model. Defaults and their provenance: see the kDefault*
    // block above. Overridable because they are modelling choices, not
    // measurements of this scenario's radio.
    double energyJ = kDefaultEnergyJ;
    double voltageV = kDefaultVoltageV;
    double txCurrentA = kDefaultTxCurrentA;
    double rxCurrentA = kDefaultRxCurrentA;
    double idleCurrentA = kDefaultIdleCurrentA;
    cmd.AddValue("energyJ",
                 "Initial energy per node (J); default 5000 is sized "
                 "so no node dies in a 900 s run (#209). 0 disables "
                 "energy accounting; energy columns then read 0",
                 energyJ);
    cmd.AddValue("voltageV", "Energy-source supply voltage (V)", voltageV);
    cmd.AddValue("txCurrentA", "Radio transmit current (A)", txCurrentA);
    cmd.AddValue("rxCurrentA", "Radio receive current (A)", rxCurrentA);
    cmd.AddValue("idleCurrentA",
                 "Radio idle current (A); also applied to the "
                 "CCA-busy and switching states",
                 idleCurrentA);
    // #217: the window over which concurrently-used next hops are counted.
    // Carried into the CSV (path_div_window_s) because it defines what the
    // diversity number means — see the path-diversity block above main().
    double pathWindowS = kDefaultPathWindowS;
    cmd.AddValue("pathWindowS",
                 "Window (s) over which distinct next hops used "
                 "for a destination are counted as concurrent "
                 "paths (#217); default 10",
                 pathWindowS);
    cmd.Parse(argc, argv);

    // 'paper' = the Broch/CMU MobiCom'98 field (the literature *calibration*
    // anchor, #24). 'thesis' = AntHocNet's own evaluation field, read from
    // Ducatelle, "Adaptive Routing in Ad Hoc Wireless Multi-hop Networks"
    // (PhD thesis, 2007) **§5.1.3** — quoted values, no longer reconstructed
    // (#58). Fidelity claims run on 'thesis', calibration on 'paper'.
    //
    //   nodes        100
    //   area         2400 x 800 m   ("move in a rectangular area of 2400 x 800m²")
    //   mobility     RWP, speed U[0,10] m/s, pause 30 s  ("a minimum and maximum
    //                speed of respectively 0 and 10 m/s, and a pause time of 30 s")
    //   duration     900 s, repeated 20 times  ("Each experiment has a duration
    //                of 900 s, and is repeated 20 times")
    //   traffic      20 UDP sessions, 4 x 64-byte packets/s = 2048 bps  ("Each
    //                session generates 4 packets of 64 bytes per second")
    //   start window uniform in [0, 180] s
    //   radio        802.11 DCF at 2 Mbit/s; range 250 m  ("The estimated radio
    //                range is 250 m")
    //
    // Before #58's PDF pass this preset carried five wrong constants (3000x1000 m,
    // 20 m/s, 512 bps, 300 m range, 5 runs), all inherited from 'paper' or from a
    // secondary-source reconstruction. Provenance is spelled out inline on
    // purpose: unsourced numbers caused #88, #169 and #173.
    //
    // Two axes are deliberately NOT forced by the preset:
    //  - **propagation**: the thesis uses a **two-ray** model; this harness
    //    defaults to the `range` disk model (the #24 calibration disentangler,
    //    a global default we do not change per-preset). Pass
    //    `--propagation=tworay` to match §5.1.3.
    //  - **repetitions**: `--runs` defaults to 20 for this preset only (see
    //    below), but any explicit `--runs=N` wins — and run-scenarios.py and
    //    both benchmark workflows always pass one. Reproducing a thesis figure
    //    through those means setting runs=20 there.
    // See docs/benchmarks/methodology.md ("Reproducing a thesis run").
    // #482: refuse an unknown preset rather than silently running the legacy
    // defaults under a label that claims otherwise (a typo'd "fanet" would
    // otherwise produce a planar 20-node RWP run tagged scenario=fanet).
    NS_ABORT_MSG_UNLESS(scenario.empty() || scenario == "paper" || scenario == "thesis" ||
                            scenario == "fanet" || scenario == "vanet" || scenario == "disaster",
                        "unknown --scenario='"
                            << scenario
                            << "' (expected paper|thesis|fanet|vanet|disaster, or omit it)");
    const bool thesis = (scenario == "thesis");
    const bool paper = (scenario == "paper") || thesis;
    // #482 FANET preset (family #300). Scenario knobs ONLY (ADR-0019): no
    // protocol attribute is touched here. Each value and its source is
    // tabulated in docs/benchmarks/scenarios/fanet.md; in short:
    //   nodes     30                   Biomo, Kunz & St-Hilaire 2015 (30 UAVs);
    //                                  inside the #298 envelope (20-40)
    //   field     1000 x 1000 x 300 m  #298 envelope; a 3-D box as in
    //                                  Makkar et al. 2018 (ns-3, 3-D GM cube)
    //   range     350 m disk           chosen for density: mean degree 7.2
    //                                  clears 2 ln(30) = 6.8 (#481 preflight);
    //                                  250 m (the sparse cell) is 3.5
    //   mobility  Gauss-Markov         Makkar 2018; Yang et al. 2024 (Sci Rep
    //                                  14:15632); the #298 survey standard
    //   speed     U(10, 30) m/s        #298 envelope (10-30 m/s); below the
    //                                  fixed-wing 50-60 m/s of Biomo 2015
    //   traffic   10 CBR flows, 4 x 64 B/s (2048 bps), start in [0, 180] s
    //                                  low-rate telemetry; per-flow rate is the
    //                                  thesis's (Ducatelle 2007 §5.1.3)
    //   time      900 s                the paper/thesis horizon
    const bool fanet = (scenario == "fanet");
    // #488 VANET preset (family #301). Scenario knobs ONLY (ADR-0019). Each
    // value and its source is tabulated in docs/benchmarks/scenarios/vanet.md; in short:
    //   field     800 x 800 m, 4 x 4 blocks of 200 m
    //                                  Bai & Helmy's Manhattan setup is 1000 x
    //                                  1000 m (IMPORTANT, INFOCOM 2003); shrunk
    //                                  so the urban channel is connected at an
    //                                  affordable vehicle count (block size: a
    //                                  recorded assumption, see vanet.md)
    //   vehicles  100                  chosen for density: #488 preflight's
    //                                  road-network degree 9.6 clears
    //                                  2 ln(100) = 9.2 under the buildings
    //   mobility  manhattan            Bai & Helmy 2003 (turns 0.5/0.25/0.25)
    //   speed     U(10, 20) m/s        36-72 km/h urban; inside #298's 10-40
    //   channel   urban                two-ray + Sommer et al. 2011 shadowing
    //   traffic   20 CBR flows, 4 x 64 B/s (2048 bps), start in [0, 180] s
    //                                  Bai & Helmy 2003 (20 CBR sources,
    //                                  4 pkt/s, 64 B)
    //   time      900 s                Bai & Helmy 2003; the paper horizon
    const bool vanet = (scenario == "vanet");
    // #580 disaster preset (family axis III). Scenario knobs ONLY (ADR-0019).
    // The scene is generated, not built in: tools/bench/disaster_scene.py
    // writes the movement trace (the Aschenbruck et al. 2007 disaster-area
    // model's zones and roles), the flows and the building list, and the
    // preset replays them on the urban channel with those buildings, so
    // indoor responders are shadowed by the walls between them and the
    // outside. Values and sources: docs/benchmarks/scenarios/disaster.md.
    const bool disaster = (scenario == "disaster");
    // #58: the thesis averages 20 repetitions; everything else keeps the
    // historical default of 1. Explicit --runs=N always overrides.
    if (runs < 1) runs = thesis ? 20 : 1;
    Params P;
    P.nNodes = nNodes > 0 ? static_cast<uint32_t>(nNodes)
                          : (thesis  ? 100
                             : paper ? 50
                             : fanet ? 30
                             : vanet ? 100
                                     : 20);
    P.simTime = simTime >= 0 ? simTime : ((paper || fanet || vanet || disaster) ? 900.0 : 40.0);
    P.areaX = areaX >= 0 ? areaX
                         : (area >= 0 ? area
                                      : (thesis     ? 2400.0
                                         : paper    ? 1500.0
                                         : fanet    ? 1000.0
                                         : vanet    ? 800.0
                                         : disaster ? 1000.0
                                                    : 300.0));
    P.areaY = areaY >= 0 ? areaY
                         : (area >= 0 ? area
                                      : (thesis     ? 800.0
                                         : paper    ? 300.0
                                         : fanet    ? 1000.0
                                         : vanet    ? 800.0
                                         : disaster ? 500.0
                                                    : 300.0));
    // -1 = unset (the preset decides); an explicit --areaZ=0 forces planar.
    NS_ABORT_MSG_UNLESS(areaZ >= 0.0 || areaZ == -1.0,
                        "--areaZ must be >= 0 (got " << areaZ << ")");
    P.areaZ = areaZ >= 0 ? areaZ : (fanet ? 300.0 : 0.0);
    P.speed = speed >= 0 ? speed
                         : (thesis  ? 10.0
                            : paper ? 20.0
                            : fanet ? 30.0
                            : vanet ? 20.0
                                    : 5.0);
    P.speedMin = speedMin >= 0 ? speedMin : ((fanet || vanet) ? 10.0 : 1.0);
    NS_ABORT_MSG_UNLESS(P.speedMin <= P.speed,
                        "--speedMin=" << P.speedMin << " exceeds the max speed " << P.speed
                                      << ": U(speedMin, speed) would be empty (#482)");
    P.pause = pause >= 0 ? pause : (paper ? 30.0 : (fanet || vanet) ? 0.0 : 1.0);
    P.range = range >= 0 ? range : (thesis ? 250.0 : paper ? 300.0 : fanet ? 350.0 : 0.0);
    P.nFlows = nFlows > 0 ? static_cast<uint32_t>(nFlows)
                          : ((paper || vanet) ? 20
                             : fanet          ? 10
                                              : 5);
    P.cbrBps = cbrBps >= 0 ? cbrBps
                           : ((thesis || fanet || vanet) ? 2048.0
                              : paper                    ? 512.0
                                                         : 8000.0);
    P.offTime = offTime;
    P.startWindow = (paper || fanet || vanet) ? 180.0 : 5.0;
    if (mobilityModel.empty()) {
        mobilityModel = fanet ? "gaussmarkov" : vanet ? "manhattan" : disaster ? "trace" : "rwp";
    }
    if (blocksX == 0) blocksX = vanet ? 4 : 5;
    if (blocksY == 0) blocksY = vanet ? 4 : 5;
    // #506/#488/#580: per-family settings of the arms' measuring
    // instruments (the oracle's recompute cadence), never protocol defaults
    // (ADR-0019); each listed arm applies its own.
    {
        bench::RunContext scen;
        scen.scenario = scenario;
        for (int k = 1; k < argc; ++k) scen.args.emplace_back(argv[k]);
        for (const Ptr<bench::Arm>& a : ListedArms(protocols)) a->Configure(scen);
    }
    // An explicitly empty --propagation= has always meant "the default", and
    // scenario-matrix.yml documents its blank input that way; normalise it
    // rather than letting the guard below reject a working dispatch.
    if (propagation.empty()) propagation = (vanet || disaster) ? "urban" : "range";
    P.propagation = propagation;
    NS_ABORT_MSG_UNLESS(propagation == "range" || propagation == "tworay" ||
                            propagation == "nakagami" || propagation == "urban",
                        "unknown --propagation='"
                            << propagation
                            << "' (expected range|tworay|nakagami|urban). Refusing rather "
                               "than falling through to a default channel: the "
                               "silent fallback would produce a plausible run of "
                               "the wrong channel (#60).");
    P.mobility = mobilityModel;
    P.transport = transport;
    NS_ABORT_MSG_UNLESS(transport == "udp" || transport == "tcp",
                        "unknown --transport='"
                            << transport
                            << "' (expected udp|tcp). Refusing rather than "
                               "defaulting to udp: a typo would silently produce a "
                               "UDP run labelled as a TCP one (#63).");
    NS_ABORT_MSG_UNLESS(
        mobilityModel == "rwp" || mobilityModel == "ssrwp" || mobilityModel == "gaussmarkov" ||
            mobilityModel == "manhattan" || mobilityModel == "trace",
        "unknown --mobility='"
            << mobilityModel
            << "' (expected rwp|ssrwp|gaussmarkov|manhattan|trace). Refusing rather "
               "than silently falling back to rwp: a typo would "
               "otherwise produce a plausible run of the wrong "
               "model (#61).");
    // #480: arms that cannot honour a 3-D field are refused, never silently
    // flattened. A planar fallback would produce a plausible FANET-labelled
    // run of the wrong geometry -- the same failure class as the unknown-arm
    // refusals above.
    if (P.areaZ > 0.0) {
        NS_ABORT_MSG_UNLESS(
            propagation == "range",
            "--propagation=" << propagation << " with --areaZ=" << P.areaZ
                             << ": two-ray ground reflection (and the "
                                "nakagami arm stacked on it) assumes 1.5 m antennas "
                                "over a ground plane, which is meaningless between "
                                "aircraft. Use the disk ('range') channel; a 3-D "
                                "fading arm is future work (#480, #60).");
        NS_ABORT_MSG_UNLESS(mobilityModel != "ssrwp",
                            "--mobility=ssrwp with --areaZ="
                                << P.areaZ
                                << ": ns-3's SteadyStateRandomWaypointMobilityModel "
                                   "is planar (a fixed Z), so it would silently "
                                   "flatten the field. Use rwp or gaussmarkov (#480).");
    }
    // #488: the street grid both the Manhattan model and the urban buildings
    // live on. Refusals, never silent fallbacks: each would otherwise produce a
    // plausible run of the wrong geometry.
    P.blocksX = blocksX;
    P.blocksY = blocksY;
    P.streetWidth = streetWidth;
    P.buildings = buildings;
    NS_ABORT_MSG_IF(!buildings.empty() && propagation != "urban",
                    "--buildings needs --propagation=urban: the buildings are its "
                    "obstacle shadowing (#580)");
    if (disaster) {
        NS_ABORT_MSG_UNLESS(mobilityModel == "trace" && !traceFile.empty() && !flowsFile.empty() &&
                                !buildings.empty(),
                            "--scenario=disaster replays a generated scene: pass the "
                            "--traceFile, --flowsFile and --buildings that "
                            "tools/bench/disaster_scene.py gen writes (#580)");
    }
    NS_ABORT_MSG_UNLESS(blocksX >= 1 && blocksY >= 1, "--blocksX/--blocksY must be >= 1 (#488)");
    if (mobilityModel == "manhattan") {
        NS_ABORT_MSG_UNLESS(P.areaZ == 0.0, "--mobility=manhattan with --areaZ="
                                                << P.areaZ << ": a street grid is planar (#488)");
        NS_ABORT_MSG_UNLESS(P.speedMin > 0.0,
                            "--mobility=manhattan needs --speedMin > 0: each leg's "
                            "duration is its length over a speed drawn "
                            "U(speedMin, speed) (#488)");
    }
    if (propagation == "urban") {
        // A replayed trace (#639) is trusted to keep its vehicles on the same
        // street grid: the learn site's VANET export (#640) drives the very
        // blocks this channel builds (area / blocks, streetWidth).
        NS_ABORT_MSG_UNLESS(mobilityModel == "manhattan" || mobilityModel == "trace",
                            "--propagation=urban needs --mobility=manhattan (or a "
                            "--mobility=trace that drives the same streets): the "
                            "buildings are the street grid's blocks, and vehicles "
                            "off the streets would sit inside them (#488)");
        NS_ABORT_MSG_UNLESS(
            !buildings.empty() ||
                (streetWidth > 0.0 && streetWidth < std::min(P.areaX / blocksX, P.areaY / blocksY)),
            "--streetWidth=" << streetWidth
                             << " must be > 0 and "
                                "narrower than a block ("
                             << P.areaX / blocksX << " x " << P.areaY / blocksY << " m) (#488)");
    }
    // #708: the radio, checked against the channel and rate it is paired with.
    NS_ABORT_MSG_UNLESS(standard == "80211b" || standard == "80211a",
                        "--standard must be 80211b or 80211a, got '" << standard << "'");
    if (standard == "80211a") {
        // The two-ray family is parameterised at 2.4 GHz (Frequency=2.4e9 in
        // RunOne); only the disk is frequency-free.
        NS_ABORT_MSG_UNLESS(propagation == "range" && P.range > 0.0,
                            "--standard=80211a needs --propagation=range with --range > 0: "
                            "the other channels are set at 2.4 GHz or depend on frequency (#708)");
        NS_ABORT_MSG_UNLESS(
            rateManager == "constant6" || rateManager == "arf" || rateManager == "ideal",
            "--standard=80211a needs --rateManager=constant6|arf|ideal; '"
                << rateManager << "' is a DSSS (802.11b) rate (#708)");
    } else {
        NS_ABORT_MSG_IF(rateManager == "constant6",
                        "--rateManager=constant6 is an OFDM rate: it needs --standard=80211a");
    }
    P.standard = standard;
    P.rateManager = rateManager;
    P.sink = sink;
    P.energyJ = energyJ;
    P.voltageV = voltageV;
    P.txCurrentA = txCurrentA;
    P.rxCurrentA = rxCurrentA;
    P.idleCurrentA = idleCurrentA;
    P.pathWindowS = pathWindowS > 0.0 ? pathWindowS : kDefaultPathWindowS;
    // #639: a replayed scene. The trace names its nodes, so it sets nNodes
    // (an explicit, different --nNodes is refused); the flow file is checked
    // against that node count and the run window before anything runs, so a
    // bad file fails here with its line number, never mid-run.
    P.traceFile = traceFile;
    P.dumpTrace = dumpTrace;
    P.vizTrace = vizTrace;
    P.vizStep = vizStep;
    NS_ABORT_MSG_UNLESS(seriesEvery >= 0.0, "--seriesEvery must be >= 0 (#62)");
    NS_ABORT_MSG_IF(seriesEvery > 0.0 && !g_diag,
                    "--seriesEvery needs --diag: the ant tallies it samples are --diag's (#62)");
    P.seriesEvery = seriesEvery;
    P.dumpFlows = dumpFlows;
    if (P.mobility == "trace") {
        NS_ABORT_MSG_IF(traceFile.empty(),
                        "--mobility=trace needs --traceFile=<ns-2 trace> (#639)");
        std::ifstream tf(traceFile);
        NS_ABORT_MSG_UNLESS(tf, "--traceFile='" << traceFile << "' cannot be opened (#639)");
        std::string line;
        int64_t maxId = -1;
        uint32_t lineNo = 0;
        while (std::getline(tf, line)) {
            ++lineNo;
            for (std::size_t at = line.find("$node_("); at != std::string::npos;
                 at = line.find("$node_(", at + 1)) {
                const std::size_t close = line.find(')', at);
                NS_ABORT_MSG_IF(close == std::string::npos,
                                traceFile << ":" << lineNo << ": unterminated $node_( (#639)");
                const std::string id = line.substr(at + 7, close - at - 7);
                NS_ABORT_MSG_UNLESS(
                    !id.empty() && id.find_first_not_of("0123456789") == std::string::npos,
                    traceFile << ":" << lineNo << ": node id '" << id
                              << "' is not a non-negative integer (#639)");
                maxId = std::max<int64_t>(maxId, std::stoll(id));
            }
        }
        NS_ABORT_MSG_IF(maxId < 0, "--traceFile='" << traceFile << "' names no $node_(i) (#639)");
        bool explicitN = false;
        for (int k = 1; k < argc; ++k) {
            if (std::string(argv[k]).rfind("--nNodes=", 0) == 0) explicitN = true;
        }
        NS_ABORT_MSG_IF(
            explicitN && P.nNodes != static_cast<uint32_t>(maxId + 1),
            "--nNodes=" << P.nNodes << " but the trace names " << maxId + 1 << " nodes (#639)");
        P.nNodes = static_cast<uint32_t>(maxId + 1);
    }
    NS_ABORT_MSG_IF(!dumpTrace.empty() && P.areaZ > 0.0,
                    "--dumpTrace writes ns-2 setdest, which is 2-D; refusing a 3-D field (#639)");
    if (!flowsFile.empty()) {
        NS_ABORT_MSG_IF(P.sink >= 0,
                        "--flowsFile and --sink both choose the flows; use one (#639)");
        std::ifstream ff(flowsFile);
        NS_ABORT_MSG_UNLESS(ff, "--flowsFile='" << flowsFile << "' cannot be opened (#639)");
        std::string line;
        uint32_t lineNo = 0;
        while (std::getline(ff, line)) {
            ++lineNo;
            const std::size_t hash = line.find('#');
            if (hash != std::string::npos) line.erase(hash);
            if (line.find_first_not_of(" \t\r") == std::string::npos) continue;
            std::istringstream ls(line);
            long long src = -1, dst = -1;
            double start = -1, stop = -1, bps = -1;
            std::string extra;
            NS_ABORT_MSG_UNLESS(
                (ls >> src >> dst >> start >> stop >> bps) && !(ls >> extra),
                flowsFile << ":" << lineNo << ": expected 'src dst start stop cbrBps' (#639)");
            NS_ABORT_MSG_UNLESS(src >= 0 && dst >= 0 && src < static_cast<long long>(P.nNodes) &&
                                    dst < static_cast<long long>(P.nNodes) && src != dst,
                                flowsFile << ":" << lineNo
                                          << ": node ids must be distinct and in [0, " << P.nNodes
                                          << ") (#639)");
            NS_ABORT_MSG_UNLESS(start >= 0.0 && start < stop && start < P.simTime && bps > 0.0,
                                flowsFile << ":" << lineNo
                                          << ": need 0 <= start < stop, start < --time="
                                          << P.simTime << " and cbrBps > 0 (#639)");
            P.flowList.push_back(
                {static_cast<uint32_t>(src), static_cast<uint32_t>(dst), start, stop, bps});
        }
        NS_ABORT_MSG_IF(P.flowList.empty(),
                        "--flowsFile='" << flowsFile << "' lists no flows (#639)");
        P.nFlows = static_cast<uint32_t>(P.flowList.size());
    }

    // 1 ms delay bins for the 99th-percentile computation.
    Config::SetDefault("ns3::FlowMonitor::DelayBinWidth", DoubleValue(0.001));

    std::vector<std::string> list;
    std::stringstream ss(protocols);
    std::string item;
    while (std::getline(ss, item, ',')) {
        if (!item.empty()) list.push_back(item);
    }
    // Each listed arm refuses a configuration it cannot run honestly (a planar
    // GPSR on a 3-D field, #480; 802.11s off 802.11a, #708).
    {
        bench::RunContext scen;
        scen.scenario = scenario;
        scen.standard = P.standard;
        scen.areaZ = P.areaZ;
        for (const Ptr<bench::Arm>& a : ListedArms(protocols)) a->Validate(scen);
    }

    // Each protocol: mean over runs (every protocol sees the same seed set).
    // #28: also sample stddev across runs (0 when runs==1) so published numbers
    // carry dispersion. Offered-load percentiles use -1 as "infinite": any
    // infinite run makes the aggregate infinite (monotone-honest, like the
    // metric itself).
    struct Agg {
        double pdr = 0, delay = 0, delay99 = 0, thrput = 0, nrl = 0;
        double nrlBytes = 0;  // #132
        double jitter = 0, dOff50 = 0, dOff90 = 0;
        double jitterEq51 = 0;  // #89
        double pdrSq = 0, delaySq = 0, delay99Sq = 0, nrlSq = 0, nrlBytesSq = 0;
        bool off50Inf = false, off90Inf = false;
        double pdrSd = 0, delaySd = 0, delay99Sd = 0, nrlSd = 0, nrlBytesSd = 0;
        // #209: energy means across runs. firstDeath is averaged over the runs
        // that actually saw a death (deathRuns); -1 when no run did.
        double energy = 0, energyPerPkt = 0;
        double resMin = 0, resMean = 0, resSd = 0;
        double firstDeath = 0;
        uint32_t deathRuns = 0;
        // #212 reordering. The *Max fields are averaged across runs like every
        // other column: a mean of per-run maxima, not a max over runs.
        double reordRatio = 0, reordRatioMax = 0;
        double reordExtMean = 0, reordExtMax = 0, reordBufMax = 0;
        // #215: drop-cause means across runs. dropNa latches when a cause does
        // not apply to this protocol, so the mean stays the -1 "not applicable"
        // sentinel and is emitted blank rather than as a measured 0.
        double dropRoute = 0, dropQueue = 0, dropMac = 0, dropChan = 0, dropTtl = 0;
        double dropSetup = 0, dropReconv = 0, dropRepair = 0, dropOther = 0;
        bool dropNa = false;
        // #217: route-quality means across runs. hopsMax/divMax are averaged
        // like every other column rather than maxed, so they stay comparable
        // with the per-run rows and with the mean columns beside them.
        double hopsMean = 0, hopsMax = 0;
        double divUsed = 0, divMax = 0, divEntropy = 0, jain = 0;
    };
    std::vector<Agg> agg(list.size());
    // #308: per (protocol, run), enough of the delivered-delay distribution to
    // re-take a percentile at another protocol's delivery count. Protocols run
    // outermost, so the comparison is only possible after the whole grid exists.
    struct MatchCell {
        std::map<uint32_t, uint64_t> hist;
        double binWidth = 0.0;
        uint64_t rx = 0;
        double delay99Ms = 0.0;
        std::map<Address, std::map<uint32_t, double>> bySeq;        // #308
        std::map<Address, std::map<uint32_t, uint32_t>> hopsBySeq;  // #308 phase 2
    };
    // #308/#369: record what this invocation actually ran, in the compact
    // block, before any result row. A benchmark number is only reproducible if
    // the configuration behind it is recoverable, and until now it was not:
    // the effective knobs lived solely in the workflow's command echo, which
    // sits ~900 lines above the cheap tail and vanishes entirely if the run is
    // cancelled before it finishes. Three hold-cap ablation arms were lost
    // exactly that way -- cancelled before pickup, logs since expired, and the
    // `--ns3::...::ReconvHoldCap=` values they were dispatched with are simply
    // gone. Emitting them here makes the run self-describing.
    //
    // Deliberately `key=value` rather than positional fields, unlike ##RUN##:
    // a mis-read position in a provenance row would misattribute a whole
    // campaign, and there is no `# stddev` cross-check to catch it the way
    // there is for the metric columns.
    std::cout << "##CONFIG## scenario=" << scenario << " nNodes=" << P.nNodes
              << " time=" << P.simTime << " runs=" << runs << " firstRun=" << firstRun
              << " areaX=" << P.areaX << " areaY=" << P.areaY;
    // #480: only a 3-D field names its z extent, so every planar run's
    // ##CONFIG## row stays byte-identical to the published corpus.
    if (P.areaZ > 0.0) std::cout << " areaZ=" << P.areaZ;
    std::cout << " speed=" << P.speed;
    // #482: like areaZ, only a non-default floor is named, keeping every
    // existing ##CONFIG## row byte-identical.
    if (P.speedMin != 1.0) std::cout << " speedMin=" << P.speedMin;
    std::cout << " pause=" << P.pause << " range=" << P.range << " propagation=" << P.propagation
              << " mobility=" << P.mobility;
    // #488: the grid geometry, named only when a grid is in use, so every
    // other row stays byte-identical.
    if (P.mobility == "manhattan" || (P.propagation == "urban" && P.buildings.empty())) {
        std::cout << " blocksX=" << P.blocksX << " blocksY=" << P.blocksY;
    }
    if (P.propagation == "urban" && P.buildings.empty()) {
        std::cout << " streetWidth=" << P.streetWidth;
    }
    // #580: explicit buildings, named only when given.
    if (!P.buildings.empty()) std::cout << " buildings=" << P.buildings;
    // #639: a replayed scene names its files; other rows stay byte-identical.
    if (!P.traceFile.empty()) std::cout << " traceFile=" << P.traceFile;
    if (!P.flowList.empty()) std::cout << " flowsFile=" << flowsFile;
    std::cout << " transport=" << P.transport << " flows=" << P.nFlows << " cbrBps="
              << P.cbrBps
              // #521: always named, so a post-fix row is distinguishable
              // from the pre-#521 corpus, whose rows lack the key.
              << " offTime=" << P.offTime << " rateManager=" << P.rateManager;
    // #708: named only off the default, so 802.11b rows stay byte-identical.
    if (P.standard != "80211b") std::cout << " standard=" << P.standard;
    std::cout << " protocols=" << protocols << '\n';
    // Module-level ##CONFIG## lines (AntHocNet's attributes at their effective
    // values), then those of each listed arm (the oracle's recompute cadence
    // off its default).
    for (bench::ConfigDump dump : bench::Registry().ConfigDumps()) dump(std::cout);
    for (const Ptr<bench::Arm>& a : ListedArms(protocols)) a->EmitConfig(std::cout);
    // #63: on a TCP run, the congestion-control variant IS part of the
    // configuration -- ns-3's default has changed across releases, so a cell
    // that does not record it is not reproducible against a future image.
    if (P.transport == "tcp") {
        TypeId tcpTid;
        if (TypeId::LookupByNameFailSafe("ns3::TcpL4Protocol", &tcpTid)) {
            const std::size_t nT = tcpTid.GetAttributeN();
            for (std::size_t a = 0; a < nT; ++a) {
                const TypeId::AttributeInformation info = tcpTid.GetAttribute(a);
                if (info.name != "SocketType") continue;
                if (!info.initialValue || !info.checker) break;
                std::cout << "##CONFIG## attr ns3::TcpL4Protocol::SocketType="
                          << info.initialValue->SerializeToString(info.checker) << '\n';
                break;
            }
        }
    }
    std::vector<std::vector<MatchCell>> matchGrid(list.size(), std::vector<MatchCell>(runs));
    for (std::size_t i = 0; i < list.size(); ++i) {
        for (uint32_t s = firstRun; s < firstRun + runs; ++s) {
            Result r = RunOne(list[i], P, s);
            MatchCell& mc = matchGrid[i][s - firstRun];
            mc.hist = r.delayHist;
            mc.binWidth = r.delayBinWidth;
            mc.rx = r.rxPackets;
            mc.delay99Ms = r.delay99Ms;
            mc.bySeq = r.rxDelayBySeq;
            mc.hopsBySeq = r.rxHopsBySeq;
            // #128: per-run (per-seed) row for paired statistics. Every
            // protocol sees the identical RNG realisation per run, so
            // downstream can pair rows by run number (per-seed deltas, sign
            // tests) — far more powerful at small `runs` than the unpaired
            // mean±sd. Same field order/precision as the final table and the
            // workflow's ##BENCH## re-emit; dOff percentiles print "inf" like
            // the table when -1 (infinite).
            std::cout << std::fixed << "##RUN## " << s << ' ' << list[i] << ' '
                      << std::setprecision(1) << r.pdr << ' ' << std::setprecision(1)
                      << r.meanDelayMs << ' ' << std::setprecision(1) << r.delay99Ms << ' '
                      << std::setprecision(2) << r.throughputKbps << ' ' << std::setprecision(2)
                      << r.nrl << ' ' << std::setprecision(2) << r.jitterMs;
            for (double v : {r.dOff50Ms, r.dOff90Ms}) {
                if (v < 0)
                    std::cout << " inf";
                else
                    std::cout << ' ' << std::setprecision(1) << v;
            }
            // #132: keep the per-run row field-aligned with the mean row, so
            // paired per-seed statistics cover nrl_bytes too.
            std::cout << ' ' << std::setprecision(4) << r.nrlBytes;
            std::cout << "\n";
            // #308 phase 2 step 3: channel occupancy, per run so it pairs on
            // identical seeds like every other per-seed row. Its own marker
            // rather than extra ##RUN## columns, for the reason ##MATCH## and
            // ##COMMON## have their own: the ##RUN## field order is consumed
            // positionally, so appending there would shift downstream mappings.
            // Reported as a fraction of node-time rather than raw seconds so
            // the number does not silently depend on --nNodes or --time:
            // busyPct is what one node saw the medium occupied, on average.
            // #308 phase 2 step 4: pending-queue hold time, per run so it pairs
            // on identical seeds. Emitted ONLY for a protocol that actually has
            // the instrumentation — i.e. AntHocNet. AODV also queues packets
            // during route discovery (aodv::RequestQueue) and OLSR/DSDV do not
            // queue at all, but none of them is measured here, so printing a row
            // of zeros for them would assert "this protocol never held a packet"
            // when the truth is "nobody looked". Absence is the honest encoding,
            // and it is the same rule ##AIR## follows for --energyJ=0.
            if (r.holdValid) {
                std::cout << std::fixed << "##HOLD## " << s << ' ' << list[i];
                for (std::size_t hr = 0; hr < r.hold.size(); ++hr) {
                    const double meanMs =
                        r.hold[hr].deliveredCount
                            ? 1000.0 * r.hold[hr].deliveredSumS / r.hold[hr].deliveredCount
                            : 0.0;
                    std::cout << ' ' << r.hold[hr].deliveredCount << ' ' << std::setprecision(2)
                              << meanMs << ' ' << std::setprecision(2)
                              << 1000.0 * r.hold[hr].deliveredMaxS;
                }
                std::cout << "\n";
            }
            if (r.airTxS >= 0.0) {
                const double nodeSeconds = static_cast<double>(P.nNodes) * P.simTime;
                const double busy = r.airTxS + r.airRxS + r.airCcaS;
                std::cout << std::fixed << "##AIR## " << s << ' ' << list[i] << ' '
                          << std::setprecision(3) << r.airTxS << ' ' << std::setprecision(3)
                          << r.airRxS << ' ' << std::setprecision(3) << r.airCcaS << ' '
                          << std::setprecision(4)
                          << (nodeSeconds > 0.0 ? 100.0 * busy / nodeSeconds : 0.0) << "\n";
                // #294 item 3 / #483: the energy family per seed, so it pairs
                // and carries a CI like every other per-seed row. Until now it
                // was only printed as a mean over runs ('# energy', the CSV),
                // which no interval can be built from. Same gate as ##AIR##
                // (both need the energy model on, #270): absent, not zero,
                // under --energyJ=0.
                std::cout << "##ENERGY## " << s << ' ' << list[i] << ' ' << std::setprecision(3)
                          << r.energyJ << ' ' << std::setprecision(6) << r.energyPerPktJ << ' '
                          << std::scientific << std::setprecision(4) << r.energyPerBitJ
                          << std::fixed << ' ' << std::setprecision(3) << r.resSdJ << "\n";
            }
            // #63: application bytes delivered per second, from the
            // PacketSinks. Emitted on every run, not only TCP ones: on UDP it
            // should track the thrput column, and that agreement is the
            // cross-check that the metric is wired correctly. On TCP the gap
            // between the two is the retransmission overhead, and ##GOODPUT##
            // -- not pdr, not thrput -- is the cell's headline.
            std::cout << std::fixed << "##GOODPUT## " << s << ' ' << list[i] << ' '
                      << std::setprecision(3) << r.goodputKbps << "\n";
            // #294 item 4: route stability per seed. UDP arms only — absent,
            // not zero, under TCP, where the (flow, seq) path identity does
            // not exist (the #382 rule).
            if (r.routeValid) {
                std::cout << std::fixed << "##ROUTE## " << s << ' ' << list[i] << ' '
                          << std::setprecision(4) << r.setupMedS << ' ' << std::setprecision(4)
                          << r.setupMaxS << ' ' << r.flowsNoDelivery << ' ' << std::setprecision(5)
                          << r.pathChg << ' ' << std::setprecision(3) << r.pathLifeMedS << ' '
                          << r.pathLifeN << ' ' << std::setprecision(4) << r.pathHopsMean << ' '
                          << std::setprecision(4) << r.hopsMean << "\n";
            }
            agg[i].pdr += r.pdr;
            agg[i].delay += r.meanDelayMs;
            agg[i].delay99 += r.delay99Ms;
            agg[i].thrput += r.throughputKbps;
            agg[i].nrl += r.nrl;
            agg[i].nrlBytes += r.nrlBytes;
            agg[i].jitter += r.jitterMs;
            agg[i].jitterEq51 += r.jitterEq51Ms;  // #89
            agg[i].pdrSq += r.pdr * r.pdr;
            agg[i].delaySq += r.meanDelayMs * r.meanDelayMs;
            agg[i].delay99Sq += r.delay99Ms * r.delay99Ms;
            agg[i].nrlSq += r.nrl * r.nrl;
            agg[i].nrlBytesSq += r.nrlBytes * r.nrlBytes;
            if (r.dOff50Ms < 0)
                agg[i].off50Inf = true;
            else
                agg[i].dOff50 += r.dOff50Ms;
            if (r.dOff90Ms < 0)
                agg[i].off90Inf = true;
            else
                agg[i].dOff90 += r.dOff90Ms;
            agg[i].energy += r.energyJ;
            agg[i].energyPerPkt += r.energyPerPktJ;
            agg[i].resMin += r.resMinJ;
            agg[i].resMean += r.resMeanJ;
            agg[i].resSd += r.resSdJ;
            if (r.firstDeathS >= 0.0) {
                agg[i].firstDeath += r.firstDeathS;
                ++agg[i].deathRuns;
            }
            agg[i].reordRatio += r.reorderRatio;
            agg[i].reordRatioMax += r.reorderRatioMax;
            agg[i].reordExtMean += r.reorderExtMean;
            agg[i].reordExtMax += r.reorderExtMax;
            agg[i].reordBufMax += r.reorderBufMax;
            agg[i].dropRoute += r.dropRoutePct;
            agg[i].dropQueue += r.dropQueuePct;
            agg[i].dropMac += r.dropMacPct;
            agg[i].dropChan += r.dropChanPct;
            agg[i].dropTtl += r.dropTtlPct;
            agg[i].dropOther += r.dropOtherPct;
            if (r.dropSetupPct < 0.0) {
                agg[i].dropNa = true;  // #215: cause not applicable to this arm
            } else {
                agg[i].dropSetup += r.dropSetupPct;
                agg[i].dropReconv += r.dropReconvPct;
                agg[i].dropRepair += r.dropRepairPct;
            }
            agg[i].hopsMean += r.hopsMean;
            agg[i].hopsMax += r.hopsMax;
            agg[i].divUsed += r.divUsed;
            agg[i].divMax += r.divMax;
            agg[i].divEntropy += r.divEntropyBits;
            agg[i].jain += r.jain;
        }
        agg[i].pdr /= runs;
        agg[i].delay /= runs;
        agg[i].delay99 /= runs;
        agg[i].thrput /= runs;
        agg[i].nrl /= runs;
        agg[i].nrlBytes /= runs;
        agg[i].jitter /= runs;
        agg[i].jitterEq51 /= runs;  // #89
        agg[i].dOff50 = agg[i].off50Inf ? -1.0 : agg[i].dOff50 / runs;
        agg[i].dOff90 = agg[i].off90Inf ? -1.0 : agg[i].dOff90 / runs;
        agg[i].energy /= runs;
        agg[i].energyPerPkt /= runs;
        agg[i].resMin /= runs;
        agg[i].resMean /= runs;
        agg[i].resSd /= runs;
        agg[i].firstDeath = agg[i].deathRuns ? agg[i].firstDeath / agg[i].deathRuns : -1.0;
        agg[i].reordRatio /= runs;
        agg[i].reordRatioMax /= runs;
        agg[i].reordExtMean /= runs;
        agg[i].reordExtMax /= runs;
        agg[i].reordBufMax /= runs;
        agg[i].dropRoute /= runs;
        agg[i].dropQueue /= runs;
        agg[i].dropMac /= runs;
        agg[i].dropChan /= runs;
        agg[i].dropTtl /= runs;
        agg[i].dropOther /= runs;
        if (agg[i].dropNa) {
            agg[i].dropSetup = agg[i].dropReconv = agg[i].dropRepair = -1.0;
        } else {
            agg[i].dropSetup /= runs;
            agg[i].dropReconv /= runs;
            agg[i].dropRepair /= runs;
        }
        agg[i].hopsMean /= runs;
        agg[i].hopsMax /= runs;
        agg[i].divUsed /= runs;
        agg[i].divMax /= runs;
        agg[i].divEntropy /= runs;
        agg[i].jain /= runs;
        if (runs > 1) {
            auto sd = [runs](double sum, double sumSq) {
                const double mean = sum / runs;
                const double var = (sumSq - runs * mean * mean) / (runs - 1);
                return var > 0.0 ? std::sqrt(var) : 0.0;
            };
            agg[i].pdrSd = sd(agg[i].pdr * runs, agg[i].pdrSq);
            agg[i].delaySd = sd(agg[i].delay * runs, agg[i].delaySq);
            agg[i].delay99Sd = sd(agg[i].delay99 * runs, agg[i].delay99Sq);
            agg[i].nrlSd = sd(agg[i].nrl * runs, agg[i].nrlSq);
            agg[i].nrlBytesSd = sd(agg[i].nrlBytes * runs, agg[i].nrlBytesSq);
        }
    }

    // -----------------------------------------------------------------------
    // #308: matched-delivery 99th-percentile delay.
    //
    // delay99 compares tails over delivered sets of different sizes. AntHocNet
    // delivers ~10 pp more than AODV, and some of that surplus is exactly the
    // packets that waited through a reconvergence — so part of its worse tail
    // may be the packets AODV never delivered at all rather than slower
    // service of the packets both carry.
    //
    // Per run, take the smallest delivered count across the protocols
    // (`rxMin`) and re-read every protocol's 99th percentile at that *absolute*
    // count: the delay below which 0.99*rxMin of its packets arrived. For the
    // protocol that delivered fewest this is its own delay99; for the others it
    // is the tail of their fastest rxMin packets.
    //
    // Read it in one direction only. If the gap persists after truncation, the
    // delivery surplus cannot account for it — that is conclusive. If the gap
    // closes, it is *consistent with* the surplus explaining the tail but does
    // not establish it, because truncating the slowest packets assumes the
    // surplus is the slow ones rather than showing it. Treat a closing gap as
    // grounds for the per-packet attribution in #308's phase 1, not as its
    // answer.
    //
    // Emitted as ##MATCH## rather than extra ##RUN## columns: the ##RUN##
    // field order is consumed positionally by bench_parse.py and by the CI
    // campaign scripts, and appending to it would silently shift their mapping.
    {
        auto quantileAt = [](const MatchCell& c, uint64_t targetCount) {
            if (c.binWidth <= 0.0 || targetCount == 0) return -1.0;
            uint64_t cum = 0;
            for (const auto& kv : c.hist) {
                cum += kv.second;
                if (cum >= targetCount) return 1000.0 * (kv.first + 0.5) * c.binWidth;
            }
            return -1.0;  // fewer deliveries than the target: undefined here
        };
        for (uint32_t s = firstRun; s < firstRun + runs; ++s) {
            uint64_t rxMin = 0;
            bool have = false;
            for (std::size_t i = 0; i < list.size(); ++i) {
                const uint64_t rx = matchGrid[i][s - firstRun].rx;
                if (!have || rx < rxMin) {
                    rxMin = rx;
                    have = true;
                }
            }
            if (!have || rxMin == 0) continue;
            const uint64_t target = static_cast<uint64_t>(0.99 * rxMin);
            for (std::size_t i = 0; i < list.size(); ++i) {
                const MatchCell& c = matchGrid[i][s - firstRun];
                const double matched = quantileAt(c, target);
                std::cout << std::fixed << "##MATCH## " << s << ' ' << list[i] << ' ' << c.rx << ' '
                          << rxMin << ' ' << std::setprecision(1) << c.delay99Ms << ' ';
                if (matched < 0)
                    std::cout << "na";
                else
                    std::cout << std::setprecision(1) << matched;
                std::cout << "\n";
            }
        }
    }

    // -----------------------------------------------------------------------
    // #308 phase 1: like-for-like tail over the packets EVERY protocol carried.
    //
    // ##MATCH## above bounds the survivorship confound but cannot remove it: it
    // truncates by *rank*, which assumes the surplus deliveries are the slowest
    // ones. Keying by packet identity removes the assumption entirely. Intersect
    // the delivered (flow, seq) sets across protocols and report each protocol's
    // tail over that common set — same packets, same seeds, both delivered, so
    // no population difference remains to confound the comparison.
    //
    // The surplus tail is reported beside it, because that is the hypothesis
    // ##MATCH## could only assume: if a protocol's extra deliveries really are
    // its slow ones, its surplus tail is far above its common tail.
    //
    // Cross-protocol keying relies on the (source IP, source port) of a flow
    // being identical across protocols in the same run. It is — the topology,
    // addressing and application construction are identical and seeded
    // identically, only the routing protocol differs — but it is an assumption
    // the output makes checkable rather than hidden: nCommon collapsing toward
    // zero means the keys did not line up, which no real routing difference
    // could cause.
    {
        auto pct = [](std::vector<double>& v, double q) {
            if (v.empty()) return -1.0;
            std::sort(v.begin(), v.end());
            std::size_t i = static_cast<std::size_t>(q * v.size());
            if (i >= v.size()) i = v.size() - 1;
            return 1000.0 * v[i];
        };
        for (uint32_t s = firstRun; s < firstRun + runs; ++s) {
            // Keys delivered by every protocol this run.
            std::set<std::pair<Address, uint32_t>> common;
            bool first = true;
            for (std::size_t i = 0; i < list.size(); ++i) {
                std::set<std::pair<Address, uint32_t>> mine;
                for (const auto& f : matchGrid[i][s - firstRun].bySeq)
                    for (const auto& kv : f.second) mine.insert({f.first, kv.first});
                if (first) {
                    common = mine;
                    first = false;
                    continue;
                }
                std::set<std::pair<Address, uint32_t>> both;
                std::set_intersection(common.begin(), common.end(), mine.begin(), mine.end(),
                                      std::inserter(both, both.begin()));
                common.swap(both);
            }
            if (common.empty()) continue;
            for (std::size_t i = 0; i < list.size(); ++i) {
                std::vector<double> inCommon, surplus;
                std::size_t nSelf = 0;
                for (const auto& f : matchGrid[i][s - firstRun].bySeq) {
                    for (const auto& kv : f.second) {
                        ++nSelf;
                        if (common.count({f.first, kv.first}))
                            inCommon.push_back(kv.second);
                        else
                            surplus.push_back(kv.second);
                    }
                }
                // #308 phase 2: the same split over hop counts. Averaged over
                // exactly the packets whose delays produced meanCommon, so
                // meanCommon / hopsCommon is a per-hop cost on one population
                // instead of a quotient of two differently-sized ones.
                uint64_t hopSumC = 0, hopNC = 0, hopSumS = 0, hopNS = 0;
                for (const auto& f : matchGrid[i][s - firstRun].hopsBySeq) {
                    for (const auto& kv : f.second) {
                        if (common.count({f.first, kv.first})) {
                            hopSumC += kv.second;
                            ++hopNC;
                        } else {
                            hopSumS += kv.second;
                            ++hopNS;
                        }
                    }
                }
                const double p99c = pct(inCommon, 0.99);
                const double meanc =
                    inCommon.empty()
                        ? -1.0
                        : 1000.0 * std::accumulate(inCommon.begin(), inCommon.end(), 0.0) /
                              inCommon.size();
                const double p99s = pct(surplus, 0.99);
                const double hopsc = hopNC ? static_cast<double>(hopSumC) / hopNC : -1.0;
                const double hopss = hopNS ? static_cast<double>(hopSumS) / hopNS : -1.0;
                std::cout << std::fixed << "##COMMON## " << s << ' ' << list[i] << ' ' << nSelf
                          << ' ' << common.size() << ' ' << std::setprecision(1) << p99c << ' '
                          << std::setprecision(1) << meanc << ' ';
                if (p99s < 0)
                    std::cout << "na";
                else
                    std::cout << std::setprecision(1) << p99s;
                // Appended, never inserted: the fields above are consumed
                // positionally by the issue-thread tooling and docs/benchmarks.
                std::cout << ' ';
                if (hopsc < 0)
                    std::cout << "na";
                else
                    std::cout << std::setprecision(3) << hopsc;
                std::cout << ' ';
                if (hopss < 0)
                    std::cout << "na";
                else
                    std::cout << std::setprecision(3) << hopss;
                std::cout << "\n";
            }
        }
    }

    if (csv) {
        // Field order through throughput_kbps is stable (downstream parsers rely
        // on it); later columns are append-only (consumers read by header name):
        // delay99_ms/nrl, then #57 jitter + offered-load percentiles (-1 = inf),
        // then #28 per-metric sample stddev across runs (0 when runs==1), then
        // #132 nrl_bytes (control bytes / delivered data bytes), then #209
        // energy (total consumed, per delivered packet, residual spread across
        // nodes, the initial energy the run was configured with, and the
        // first-node-death time with -1 = no node died), then #212
        // reordering (out-of-order ratio pooled over flows and for the worst
        // single flow, reordering extent mean/max, reorder-buffer occupancy),
        // then #215's drop-cause breakdown: the five protocol-agnostic
        // causes (which sum with pdr_pct to ~100), then the three AntHocNet-only
        // ones, which are a sub-breakdown of drop_route_pct and are **blank**
        // for the other protocols (blank = the cause does not exist there;
        // 0 would mean it exists and never fired), then #217 route
        // quality (hop count of delivered packets, *used* next-hop diversity
        // and the entropy of that split, the window those are counted over,
        // and Jain's fairness index across flows).
        std::cout << "protocol,runs,nNodes,area,speed,flows,pdr_pct,delay_ms,"
                     "throughput_kbps,delay99_ms,nrl,jitter_ms,delay_off50_ms,"
                     "delay_off90_ms,pdr_sd,delay_sd,delay99_sd,nrl_sd,"
                     "nrl_bytes,energy_j,energy_per_pkt_j,energy_res_min_j,"
                     "energy_res_mean_j,energy_res_sd_j,energy_init_j,"
                     "first_death_s,reorder_ratio,reorder_ratio_max,"
                     "reorder_extent_mean,reorder_extent_max,"
                     "reorder_buf_max,drop_route_pct,drop_queue_pct,"
                     "drop_mac_pct,"
                     "drop_chan_pct,drop_ttl_pct,drop_setup_pct,"
                     "drop_reconv_pct,drop_repair_pct,"
                     "path_hops_mean,path_hops_max,"
                     "path_div_used,path_div_max,path_entropy_bits,"
                     "path_div_window_s,jain_pkts,jitter_eq51_ms\n";
        std::cout << std::fixed;
        // Blank, not zero, when a cause does not apply to this protocol (#215).
        auto optPct = [](double v) {
            std::ostringstream o;
            if (v >= 0.0) o << std::fixed << std::setprecision(3) << v;
            return o.str();
        };
        for (std::size_t i = 0; i < list.size(); ++i) {
            std::cout << list[i] << ',' << runs << ',' << P.nNodes << ',' << std::setprecision(0)
                      << P.areaX << ',' << std::setprecision(0) << P.speed << ',' << P.nFlows << ','
                      << std::setprecision(1) << agg[i].pdr << ',' << std::setprecision(1)
                      << agg[i].delay << ',' << std::setprecision(2) << agg[i].thrput << ','
                      << std::setprecision(1) << agg[i].delay99 << ',' << std::setprecision(3)
                      << agg[i].nrl << ',' << std::setprecision(2) << agg[i].jitter << ','
                      << std::setprecision(1) << agg[i].dOff50 << ',' << std::setprecision(1)
                      << agg[i].dOff90 << ',' << std::setprecision(2) << agg[i].pdrSd << ','
                      << std::setprecision(1) << agg[i].delaySd << ',' << std::setprecision(1)
                      << agg[i].delay99Sd << ',' << std::setprecision(3) << agg[i].nrlSd << ','
                      << std::setprecision(3) << agg[i].nrlBytes << ',' << std::setprecision(2)
                      << agg[i].energy << ',' << std::setprecision(4) << agg[i].energyPerPkt << ','
                      << std::setprecision(2) << agg[i].resMin << ',' << std::setprecision(2)
                      << agg[i].resMean << ',' << std::setprecision(3) << agg[i].resSd << ','
                      << std::setprecision(2) << P.energyJ << ',' << std::setprecision(1)
                      << agg[i].firstDeath << ',' << std::setprecision(4) << agg[i].reordRatio
                      << ',' << std::setprecision(4) << agg[i].reordRatioMax << ','
                      << std::setprecision(2) << agg[i].reordExtMean << ',' << std::setprecision(2)
                      << agg[i].reordExtMax << ',' << std::setprecision(2) << agg[i].reordBufMax
                      << ',' << std::setprecision(3) << agg[i].dropRoute << ','
                      << std::setprecision(3) << agg[i].dropQueue << ',' << std::setprecision(3)
                      << agg[i].dropMac << ',' << std::setprecision(3) << agg[i].dropChan << ','
                      << std::setprecision(3) << agg[i].dropTtl << ',' << optPct(agg[i].dropSetup)
                      << ',' << optPct(agg[i].dropReconv) << ',' << optPct(agg[i].dropRepair) << ','
                      << std::setprecision(2) << agg[i].hopsMean << ',' << std::setprecision(1)
                      << agg[i].hopsMax << ',' << std::setprecision(3) << agg[i].divUsed << ','
                      << std::setprecision(1) << agg[i].divMax << ',' << std::setprecision(3)
                      << agg[i].divEntropy << ',' << std::setprecision(1) << P.pathWindowS << ','
                      << std::setprecision(4) << agg[i].jain
                      << ','
                      // #89: appended last — the CSV is append-only and
                      // consumers read by header name.
                      << std::setprecision(2) << agg[i].jitterEq51 << '\n';
        }
        return 0;
    }

    std::cout << "AntHocNet protocol comparison (mean of " << runs << " run(s))\n"
              << "  nodes=" << P.nNodes << " time=" << P.simTime << "s area=" << P.areaX << "x"
              << P.areaY << "m maxSpeed=" << P.speed << "m/s pause=" << P.pause
              << "s flows=" << P.nFlows << (P.sink >= 0 ? " sink=" + std::to_string(P.sink) : "")
              << "\n\n";
    // First six fields (proto..NRL) are position-stable: the workflows' compact
    // ##BENCH## re-emit and bench_parse.py read them by position. The #57 QoS
    // columns (jitter, offered-load 90th pct) are appended to the right, then
    // #132 nrl_bytes (control bytes / delivered data bytes), then #209's two
    // headline energy columns. paper-benchmark.yml's ##BENCH## awk re-emits
    // fields $1..$10, so anything from nrlBytes rightwards is table-only —
    // appending here cannot disturb it. The remaining #209 numbers (residual
    // spread, first death) go on the '# energy' lines below, the way #28's
    // dispersion does, rather than widening the fixed-width table further.
    // #217 appends two more headline columns (mean hop count, Jain's fairness);
    // used-next-hop diversity and its entropy go on the '# paths' lines.
    std::cout << std::left << std::setw(12) << "protocol" << std::right << std::setw(8) << "PDR%"
              << std::setw(11) << "delay(ms)" << std::setw(13) << "delay99(ms)" << std::setw(13)
              << "thrput(kbps)" << std::setw(8) << "NRL" << std::setw(12) << "jitter(ms)"
              << std::setw(12) << "dOff50(ms)" << std::setw(12) << "dOff90(ms)" << std::setw(12)
              << "nrlBytes" << std::setw(12) << "energy(J)" << std::setw(12) << "J/pkt"
              << std::setw(12) << "hops" << std::setw(12)
              << "jain"
              // #89: eq 5.1 sits next to the FlowMonitor jitter it is NOT
              // interchangeable with; see docs/benchmarks/metrics.md.
              << std::setw(13) << "jitterEq51" << "\n";
    std::cout << std::string(174, '-') << "\n";
    // #741: each value carries its own leading space (width - 1 after it), so
    // the bytes are unchanged while a value fits, and a value that fills its
    // field (NRL >= 10^4) still stays a separate whitespace-split column.
    for (std::size_t i = 0; i < list.size(); ++i) {
        std::cout << std::left << std::setw(12) << list[i] << std::right << std::fixed << " "
                  << std::setw(7) << std::setprecision(1) << agg[i].pdr << " " << std::setw(10)
                  << std::setprecision(1) << agg[i].delay << " " << std::setw(12)
                  << std::setprecision(1) << agg[i].delay99 << " " << std::setw(12)
                  << std::setprecision(2) << agg[i].thrput << " " << std::setw(7)
                  << std::setprecision(2) << agg[i].nrl << " " << std::setw(11)
                  << std::setprecision(2) << agg[i].jitter;
        for (double v : {agg[i].dOff50, agg[i].dOff90}) {
            if (v < 0)
                std::cout << " " << std::setw(11) << "inf";
            else
                std::cout << " " << std::setw(11) << std::setprecision(1) << v;
        }
        std::cout << " " << std::setw(11) << std::setprecision(3) << agg[i].nrlBytes << " "
                  << std::setw(11) << std::setprecision(1) << agg[i].energy << " " << std::setw(11)
                  << std::setprecision(4) << agg[i].energyPerPkt << " " << std::setw(11)
                  << std::setprecision(2) << agg[i].hopsMean << " " << std::setw(11)
                  << std::setprecision(4) << agg[i].jain << " " << std::setw(12)
                  << std::setprecision(2) << agg[i].jitterEq51 << "\n";
    }
    // #217 path detail: used-path diversity (distinct next hops that actually
    // carried data for a destination, within a --pathWindowS window), the
    // entropy of that split, and the longest delivered path. divUsed ~1 with
    // entropy ~0 is a single-path protocol — the expected reading for aodv,
    // olsr and dsdv, and the instrumentation's self-check.
    for (std::size_t i = 0; i < list.size(); ++i) {
        std::cout << std::fixed << "# paths " << list[i] << " divUsed=" << std::setprecision(3)
                  << agg[i].divUsed << " divMax=" << std::setprecision(1) << agg[i].divMax
                  << " entropyBits=" << std::setprecision(3) << agg[i].divEntropy
                  << " windowS=" << std::setprecision(1) << P.pathWindowS
                  << " hopsMean=" << std::setprecision(2) << agg[i].hopsMean
                  << " hopsMax=" << std::setprecision(1) << agg[i].hopsMax << "\n";
    }
    // #209 energy detail: residual-energy spread across nodes (the fairness
    // signal — a protocol that funnels traffic through one relay drains it
    // first) and the first-node-death time (-1 = no node died, the expected
    // case at the default --energyJ). '# ' prefix keeps these off the
    // CSV/##BENCH## paths, same as the '# stddev' lines.
    for (std::size_t i = 0; i < list.size(); ++i) {
        std::cout << std::fixed << "# energy " << list[i] << " initJ=" << std::setprecision(1)
                  << P.energyJ << " resMinJ=" << std::setprecision(1) << agg[i].resMin
                  << " resMeanJ=" << std::setprecision(1) << agg[i].resMean
                  << " resSdJ=" << std::setprecision(3) << agg[i].resSd
                  << " firstDeathS=" << std::setprecision(1) << agg[i].firstDeath << "\n";
    }
    // #215 drop causes: why the packets PDR is missing went missing, as a % of
    // offered. `sum` is pdr + the five protocol-agnostic causes and should read
    // ~100; `other` and the gap between `sum` and 100 are the diagnostic
    // handles when it does not (unbucketed L3 drop reasons, and packets still
    // held in a pending queue when the run stopped). setup/reconv/repair are
    // AntHocNet's sub-breakdown of `route` and print as "-" elsewhere. '# '
    // prefix keeps the line off the CSV/##BENCH## paths, like '# energy'.
    auto opt = [](double v) {
        std::ostringstream o;
        if (v < 0.0)
            o << "-";
        else
            o << std::fixed << std::setprecision(2) << v;
        return o.str();
    };
    for (std::size_t i = 0; i < list.size(); ++i) {
        const double sum = agg[i].pdr + agg[i].dropRoute + agg[i].dropQueue + agg[i].dropMac +
                           agg[i].dropChan + agg[i].dropTtl;
        std::cout << std::fixed << std::setprecision(2) << "# drops " << list[i]
                  << " pdr=" << agg[i].pdr << " route=" << agg[i].dropRoute
                  << " queue=" << agg[i].dropQueue << " mac=" << agg[i].dropMac
                  << " chan=" << agg[i].dropChan << " ttl=" << agg[i].dropTtl << " sum=" << sum
                  << " other=" << agg[i].dropOther << " [route: setup=" << opt(agg[i].dropSetup)
                  << " reconv=" << opt(agg[i].dropReconv) << " repair=" << opt(agg[i].dropRepair)
                  << "]\n";
    }
    // #28 dispersion: '# ' prefix keeps these out of the CSV/##BENCH## paths.
    if (runs > 1) {
        for (std::size_t i = 0; i < list.size(); ++i) {
            std::cout << std::fixed << "# stddev " << list[i] << " pdr=" << std::setprecision(2)
                      << agg[i].pdrSd << " delay=" << std::setprecision(1) << agg[i].delaySd
                      << " delay99=" << std::setprecision(1) << agg[i].delay99Sd
                      << " nrl=" << std::setprecision(3) << agg[i].nrlSd
                      << " nrl_bytes=" << std::setprecision(3) << agg[i].nrlBytesSd << "\n";
        }
    }
    // #212 packet reordering. Deliberately a '# ' line rather than five more
    // fixed-width table columns: the table's field *positions* are a parsing
    // contract (bench_parse.py and the workflows' ##BENCH## awk read the left
    // columns by position), and reordering is a diagnostic of the multipath
    // mechanism rather than a headline comparison number. The CSV carries all
    // five columns by name. Expect ~0 for AODV/OLSR/DSDV and for AntHocNet with
    // EnableMultipath=false; a non-zero AntHocNet figure is the stochastic
    // multipath working as designed, not a fault (docs/benchmarks/metrics.md).
    //
    // #63: NOT emitted at all under TCP. RecordRxSeq is deliberately not
    // connected there (a SeqTsSizeHeader cannot be parsed off a byte stream),
    // so these accumulators never receive a sample and the line would print
    // all-zeros — asserting "no reordering occurred" when the truth is "nobody
    // measured". That is precisely the claim ##HOLD## and ##AIR## refuse to
    // make, and a probe caught this printing 0.0000 on a TCP cell after the
    // hook was already correctly skipped: disconnecting the source is only
    // half of encoding absence, the emission has to go too.
    if (P.transport != "tcp") {
        for (std::size_t i = 0; i < list.size(); ++i) {
            std::cout << std::fixed << "# reorder " << list[i] << " ratio=" << std::setprecision(4)
                      << agg[i].reordRatio << " ratioWorstFlow=" << std::setprecision(4)
                      << agg[i].reordRatioMax << " extentMean=" << std::setprecision(2)
                      << agg[i].reordExtMean << " extentMax=" << std::setprecision(2)
                      << agg[i].reordExtMax << " bufMax=" << std::setprecision(2)
                      << agg[i].reordBufMax << "\n";
        }
    }
    return 0;
}
