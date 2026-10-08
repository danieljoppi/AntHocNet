// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/**
 * leo-walker: a time-varying LEO constellation for the v2.0.0 satellite claim
 * (#192, #297) -- the constellation actually moves.
 *
 * The substrate is stock ns-3 (#193 decision): ns-3.48's
 * LeoCircularOrbitMobilityModel, installed as a Walker-delta shell by
 * LeoOrbitNodeHelper. This harness therefore builds only on ns-3 >= 3.48
 * (examples/CMakeLists.txt guards it on the header).
 *
 * What moves, and how:
 *  - Satellites fly circular orbits. Each keeps its +grid ISLs (two in-plane,
 *    two to the neighbouring planes), whose propagation delay is re-read from
 *    the satellites' positions every --delayUpdate seconds.
 *  - Ground stations at real city coordinates are served by ONE satellite at
 *    a time over a ground-satellite link (GSL). The GSL is re-assigned on a
 *    scheduler clock (default every 15 s at second 12, the reconfiguration
 *    clock measured on Starlink, WWW 2024) to the highest-elevation
 *    satellite, and forced off-clock if the serving satellite drops below
 *    --minElevation. Each station has one stable interface on its own CSMA
 *    segment, which every satellite ever visible from it also joins; only the
 *    serving satellite's device can send or receive on it. A handover flips
 *    the satellite side only, so the station keeps one address that never
 *    goes down -- the identity a routing protocol answers for (with one p2p
 *    link per candidate the station's address sat on a downed interface and
 *    AODV never replied to the route requests for it).
 *  - Links are gated at the device, never at IP, for every routing arm (see
 *    SetLink): a protocol learns of a handover or a failure only from its
 *    own signalling. The oracle arms alone also see Ipv4::SetDown.
 *  - An unplanned-failure overlay takes ISLs down and up independently
 *    (unavailability --islDown, mean outage --islMeanDown s), and an optional
 *    mass failure (--massFailAt, --massFailFrac) switches off a fraction of
 *    the satellites at once -- the storm case adaptive routing should win.
 *
 * Traffic runs between ground stations (#211: endpoints are on the ground, so
 * GSL handover is endpoint churn the routing must absorb).
 *
 * Output: the isl-grid / anthocnet-compare row format (PDR, delays, NRL, ...)
 * and ##RUN## per-seed rows, plus the handover metric family (#297 item 3):
 *   # handover   scheduled/forced GSL handovers, ISL failure events
 *   # outage     runs of >= 3 consecutive lost send attempts per flow (the
 *                sender's timeline), classified by the event that preceded
 *                them (startup / scheduled handover / unplanned failure /
 *                mass failure / other), with count, packets lost, median,
 *                90th percentile and max -- the classes are different claims
 *                and are never pooled
 *   # account    per flow: offered (send attempts) = delivered + outageLost +
 *                scatteredLost, with refused-at-source and duplicates shown
 *   # churn      hop-count changes per flow per minute (a lower bound on path
 *                changes: an equal-length reroute is invisible to it)
 *   # anchor     geometry checks: in-plane ISL length vs 2(R+h)sin(pi/S), and
 *                the orbital period vs 2*pi*sqrt(a^3/mu)
 *   # series     (--series) per-second one-way delay of flow 0 against the
 *                geodesic and fiber (2c/3) baselines, for RTT-over-time plots
 */

#include "ns3/applications-module.h"
#include "ns3/core-module.h"
#include "ns3/csma-module.h"
#include "ns3/flow-monitor-module.h"
#include "ns3/internet-module.h"
#include "ns3/ipv4-flow-classifier.h"
#include "ns3/ipv4-l3-protocol.h"
#include "ns3/mobility-module.h"
#include "ns3/network-module.h"
#include "ns3/point-to-point-module.h"

#include "ns3/aodv-module.h"
#include "ns3/olsr-module.h"
#include "ns3/oracle-module.h"
#include "ns3/anthocnet-helper.h"

#include "ns3/geocentric-constant-position-mobility-model.h"
#include "ns3/leo-circular-orbit-mobility-model.h"
#include "ns3/leo-orbit-node-helper.h"

#include <algorithm>
#include <cmath>
#include <iomanip>
#include <map>
#include <set>
#include <sstream>
#include <vector>

using namespace ns3;

namespace {

constexpr uint16_t kDataPort = 9;
constexpr double kLightSpeed = 299792458.0;
constexpr double kEarthRadiusM = 6371000.0;
constexpr double kMuEarth = 3.986004418e14;  // m^3/s^2
constexpr uint8_t kInitialTtl = 64;
// RNG stream pinning (#352/#517): same stride and application sub-block as
// isl-grid and anthocnet-compare; the failure schedule and the mass-failure
// draw live in the application sub-block so every arm sees the same events.
constexpr int64_t kStreamStride = 1000000;
constexpr int64_t kAppStreamOffset = kStreamStride - 10000;

struct City {
    const char* name;
    double lat, lon;
};
// Fixed city pairs (#297 item 1). London-Tokyo is the long pair where an ISL
// path beats terrestrial fiber; the others cross oceans of different widths.
const City kCities[] = {
    {"NewYork", 40.7128, -74.0060},   {"London", 51.5074, -0.1278},
    {"SaoPaulo", -23.5505, -46.6333}, {"Johannesburg", -26.2041, 28.0473},
    {"Tokyo", 35.6762, 139.6503},     {"Sydney", -33.8688, 151.2093},
};
const std::pair<int, int> kPairs[] = {{0, 1}, {1, 4}, {2, 3}, {4, 5}};
// --pairs=hypatia: the one city pair whose RTT range Hypatia publishes on
// Starlink's first shell (Kassing et al., IMC 2020, Fig. 13: Paris-Luanda
// varies between 85 and 117 ms over 200 s) -- the #297 item 5 calibration.
const City kHypatiaCities[] = {{"Paris", 48.8566, 2.3522}, {"Luanda", -8.8390, 13.2894}};
const std::pair<int, int> kHypatiaPairs[] = {{0, 1}};
// The stations and pairs in force (the default set unless --pairs=hypatia).
std::vector<City> g_cities(std::begin(kCities), std::end(kCities));
std::vector<std::pair<int, int>> g_pairs(std::begin(kPairs), std::end(kPairs));

struct Params {
    uint32_t planes = 12, sats = 12, phasing = 1;
    double altKm = 550, incDeg = 53;
    double simTime = 300;
    uint32_t runs = 1, firstRun = 1, nFlows = 4;
    std::string protocols = "anthocnet,aodv,olsr,oracle";
    std::string islRate = "10Mbps", gslRate = "10Mbps";
    double cbrBps = 2048;
    double minElevDeg = 25;
    double clock = 15, clockOffset = 12;
    double islDown = 0.0, islMeanDown = 2.0;
    double massFailAt = -1, massFailFrac = 0.1;
    double delayUpdate = 0.1;
    double oracleInterval = 0;  ///< oracle-delay re-solve period (s); 0 = --delayUpdate
    bool csv = false, series = false;
    std::string shell;
    std::string pairs = "default";
};

struct Result {
    std::string proto;
    uint64_t txPackets = 0, rxPackets = 0;
    double pdr = 0, meanDelayMs = 0, delay99Ms = 0, throughputKbps = 0;
    double nrl = 0, nrlBytes = 0, jitterMs = 0;
};

// --- per-run globals (the harness is single-threaded; reset in RunOne) ----------
uint64_t g_controlPkts = 0, g_controlBytes = 0;
std::vector<std::vector<double>> g_rxTimes;  // per flow: delivery times
std::vector<std::vector<int>> g_rxHops;      // per flow: hop count per delivery
std::vector<std::vector<double>> g_rxDelay;  // per flow: one-way delay per delivery
std::vector<std::pair<double, int>> g_events; // (time, kind): 1 scheduled HO, 2 forced HO, 3 ISL fail, 4 mass fail
std::vector<std::vector<int>> g_flowGs;      // per flow: its two ground-station indices
std::vector<int> g_eventGs;                  // per event: the ground station (handovers), else -1
std::vector<int> g_eventLink;                // per event: the ISL index (ISL failures), else -1
std::set<uint32_t> g_massVictimIds;          // node ids of the satellites the mass failure took
/// Forwarding path (node ids that forwarded it) of every data packet in
/// flight, by packet UID, and per flow (send time, path) of every delivered
/// one. An outage is blamed on an ISL failure or the mass failure only if it
/// touched the flow's last delivered path: with ~5 ISL failures a second
/// across a shell, "some failure in the last second" is always true and
/// would class every outage as unplanned.
std::map<uint64_t, std::vector<uint32_t>> g_pktPath;
std::vector<std::vector<std::pair<double, std::vector<uint32_t>>>> g_rxPath;
uint32_t g_scheduledHo = 0, g_forcedHo = 0, g_islFailures = 0;
uint32_t g_clockTicks = 0;                   // HandoverClock firings (coherence rule)
std::vector<std::set<uint32_t>> g_rxSeq;     // per flow: distinct sequence numbers received
std::vector<uint64_t> g_rxDup;               // per flow: duplicate deliveries
/// One send attempt by a flow's UdpClient: when, and the sequence number it
/// went out with, or -1 if the source's stack refused it (no route). UdpClient
/// itself counts and numbers only ACCEPTED sends -- GetTotalTx() and the
/// SeqTs sequence never see a refused one -- so an offered load read from the
/// client drops exactly the packets an arm refuses at its origin and inflates
/// that arm's PDR (the #464 / #510 defect class). Attempts are counted here
/// instead, from the client's Tx trace, which fires before every Send.
struct Attempt {
    double t;
    int64_t seq;
};
std::vector<std::vector<Attempt>> g_attempts;

void OnClientTx(uint32_t f, Ptr<UdpClient> c, Ptr<const Packet>) {
    const uint64_t before = c->GetTotalTx();
    g_attempts[f].push_back({Simulator::Now().GetSeconds(), -1});
    const size_t idx = g_attempts[f].size() - 1;
    // Send() has returned by the time this runs: TotalTx grew iff accepted.
    Simulator::ScheduleNow([f, c, before, idx] {
        if (c->GetTotalTx() > before) g_attempts[f][idx].seq = static_cast<int64_t>(before / 64);
    });
}

void CountControlTx(Ptr<const Packet> p, Ptr<Ipv4>, uint32_t) {
    // Ported from isl-grid (keep the two in step): overhead counted at the IP
    // layer. Only UDP is routing control here. A continuation fragment
    // (offset > 0) carries no UDP header -- OLSR's aggregates exceed the p2p
    // MTU on a few-hundred-node shell -- and counts as control, since data
    // packets (64 B) never fragment (#432).
    Ptr<Packet> c = p->Copy();
    Ipv4Header ip;
    if (c->RemoveHeader(ip) == 0) return;
    if (ip.GetProtocol() != 17) return;
    if (ip.GetFragmentOffset() != 0) {
        ++g_controlPkts;
        g_controlBytes += p->GetSize();
        return;
    }
    UdpHeader udp;
    if (c->PeekHeader(udp) == 0) return;
    if (udp.GetDestinationPort() != kDataPort) {
        ++g_controlPkts;
        g_controlBytes += p->GetSize();
    }
}

/// Elevation angle (degrees) of satellite position `sat` seen from ground `gs`.
double ElevationDeg(const Vector& gs, const Vector& sat) {
    const Vector d(sat.x - gs.x, sat.y - gs.y, sat.z - gs.z);
    const double dn = std::sqrt(d.x * d.x + d.y * d.y + d.z * d.z);
    const double gn = std::sqrt(gs.x * gs.x + gs.y * gs.y + gs.z * gs.z);
    const double s = (d.x * gs.x + d.y * gs.y + d.z * gs.z) / (dn * gn);
    return std::asin(std::max(-1.0, std::min(1.0, s))) * 180.0 / M_PI;
}

double Dist(const Vector& a, const Vector& b) {
    return std::sqrt((a.x - b.x) * (a.x - b.x) + (a.y - b.y) * (a.y - b.y) +
                     (a.z - b.z) * (a.z - b.z));
}

/// Great-circle distance between two ground points (m).
double GreatCircle(double lat1, double lon1, double lat2, double lon2) {
    const double r = M_PI / 180.0;
    const double a = std::sin((lat2 - lat1) * r / 2), b = std::sin((lon2 - lon1) * r / 2);
    const double h = a * a + std::cos(lat1 * r) * std::cos(lat2 * r) * b * b;
    return 2 * kEarthRadiusM * std::asin(std::sqrt(h));
}

/// An ErrorModel that drops every frame: a failed ISL goes silent.
class DropAll : public ErrorModel {
  public:
    static TypeId GetTypeId() {
        static TypeId tid = TypeId("ns3::LeoWalkerDropAll")
                                .SetParent<ErrorModel>()
                                .SetGroupName("Network")
                                .AddConstructor<DropAll>();
        return tid;
    }

  private:
    bool DoCorrupt(Ptr<Packet>) override { return true; }
    void DoReset() override {}
};
NS_OBJECT_ENSURE_REGISTERED(DropAll);

struct Link {
    uint32_t a, b;
    Ptr<Channel> channel;
    Ptr<Ipv4> ipA, ipB;
    uint32_t ifA, ifB;
    Ptr<NetDevice> devA, devB;
    bool up = true;
    bool satSideOnly = false;  ///< GSL: the station side is never gated
};

/// How a link change reaches the routing. Every arm gets the same physical
/// gate at the device: a down ISL drops every frame at both ends, a GSL to a
/// non-serving satellite has that satellite's CSMA device unable to send or
/// receive. IP interfaces stay up, so each protocol learns of the change only
/// from its own signalling (hello loss, failed forwarding) -- the realistic
/// case, and the same for all of them. The oracle arms additionally get
/// Ipv4::SetDown/SetUp, because reading link state directly IS the oracle's
/// bound. (Interface-down for every arm also crashed stock AODV: a hello or
/// RERR it had already scheduled, with up to 10 ms of jitter, on a socket
/// whose interface went down meanwhile hits the "Valid AODV source address
/// not found" assertion in LoopbackRoute.)
bool g_ipGate = false;
Ptr<DropAll> g_dropAll;

void SetLink(Link& l, bool up) {
    if (l.up == up) return;
    l.up = up;
    if (l.satSideOnly) {
        Ptr<CsmaNetDevice> d = DynamicCast<CsmaNetDevice>(l.devB);
        d->SetSendEnable(up);
        d->SetReceiveEnable(up);
    } else {
        DynamicCast<PointToPointNetDevice>(l.devA)->SetReceiveErrorModel(up ? nullptr : g_dropAll);
        DynamicCast<PointToPointNetDevice>(l.devB)->SetReceiveErrorModel(up ? nullptr : g_dropAll);
    }
    if (!g_ipGate) return;
    if (up) {
        if (!l.satSideOnly) l.ipA->SetUp(l.ifA);
        l.ipB->SetUp(l.ifB);
    } else {
        if (!l.satSideOnly) l.ipA->SetDown(l.ifA);
        l.ipB->SetDown(l.ifB);
    }
}

struct World {
    NodeContainer sats, ground;
    std::vector<Link> isls;
    // gsl[g] = links from ground station g to its candidate satellites
    std::vector<std::vector<Link>> gsl;
    std::vector<int> serving;  // per station: index into gsl[g], -1 none
    std::vector<bool> satUp;
};

/// Earth-centred (ECEF) position. Not MobilityModel::GetPosition(): for a
/// ground station (GeocentricConstantPositionMobilityModel) that returns
/// topocentric coordinates around a reference point, while the satellites'
/// LeoCircularOrbitMobilityModel returns ECEF -- mixing the two put every
/// station far from the meridian out of sight of the whole constellation.
Vector PosOf(Ptr<Node> n) {
    return n->GetObject<GeocentricConstantPositionMobilityModel>()->GetGeocentricPosition();
}

/// geo-greedy: the geographic comparator (#297 acceptance, baselines epic).
/// Each hop forwards to the up neighbour whose ECEF position is closest to the
/// destination node's, if strictly closer than itself (a ground station
/// always uplinks to its serving satellite); otherwise the packet is
/// dropped (a local minimum -- there is no perimeter mode: GPSR's face routing
/// planarises a 2-D graph, and a shell is not one). It is IDEALISED in the
/// same way the oracle is: positions are read from the mobility models (a
/// perfect location service) and link state from Ipv4::IsUp (it gets the
/// oracle's IP gate), so it sends no control traffic at all. It therefore
/// bounds what greedy position-based forwarding can do here from above, and
/// its losses are pure greedy dead ends, never stale beacons. On a
/// Walker-delta +grid those dead ends are structural, not rare: planes cross,
/// so a satellite can pass a few hundred km from the goal while every one of
/// its four ISL neighbours is farther (traced: 387 km from the goal, its
/// neighbours 2290-3180 km) -- the local minimum DRA-style grid routing
/// exists to avoid.
std::map<uint32_t, Ptr<Node>> g_addrToNode;  ///< every assigned address -> node
/// ground node id -> its serving satellite (null when unserved): the
/// location service also knows each station's access satellite, as LEO
/// geographic schemes assume (route to the satellite covering the
/// destination, then down) -- greedy towards the station itself dead-ends
/// at whichever satellite is nearest it but holds no GSL.
std::map<uint32_t, Ptr<Node>> g_servingSat;
uint64_t g_geoNoRouteOrigin = 0, g_geoNoRouteForward = 0;

class GeoGreedy : public Ipv4RoutingProtocol {
  public:
    static TypeId GetTypeId() {
        static TypeId tid = TypeId("ns3::LeoWalkerGeoGreedy")
                                .SetParent<Ipv4RoutingProtocol>()
                                .SetGroupName("Internet")
                                .AddConstructor<GeoGreedy>();
        return tid;
    }

    Ptr<Ipv4Route> RouteOutput(Ptr<Packet>, const Ipv4Header& header, Ptr<NetDevice>,
                               Socket::SocketErrno& sockerr) override {
        sockerr = Socket::ERROR_NOTERROR;
        const Ipv4Address dst = header.GetDestination();
        if (m_ipv4->GetInterfaceForAddress(dst) >= 0 || dst == Ipv4Address::GetLoopback()) {
            Ptr<Ipv4Route> r = Create<Ipv4Route>();
            r->SetDestination(dst);
            r->SetGateway(Ipv4Address::GetLoopback());
            r->SetSource(dst);
            r->SetOutputDevice(m_ipv4->GetNetDevice(0));
            return r;
        }
        Ptr<Ipv4Route> r = dst.IsBroadcast() || dst.IsMulticast() ? nullptr : Next(dst);
        if (!r) {
            ++g_geoNoRouteOrigin;
            sockerr = Socket::ERROR_NOROUTETOHOST;
        }
        return r;
    }

    bool RouteInput(Ptr<const Packet> p, const Ipv4Header& header, Ptr<const NetDevice> idev,
                    const UnicastForwardCallback& ucb, const MulticastForwardCallback&,
                    const LocalDeliverCallback& lcb, const ErrorCallback& ecb) override {
        const int32_t iif = m_ipv4->GetInterfaceForDevice(idev);
        if (iif < 0) return false;
        const Ipv4Address dst = header.GetDestination();
        if (m_ipv4->IsDestinationAddress(dst, static_cast<uint32_t>(iif))) {
            if (!lcb.IsNull()) lcb(p, header, static_cast<uint32_t>(iif));
            return true;
        }
        if (dst.IsMulticast()) return false;
        Ptr<Ipv4Route> r = Next(dst);
        if (r) {
            ucb(r, p, header);
        } else {
            ++g_geoNoRouteForward;
            ecb(p, header, Socket::ERROR_NOROUTETOHOST);
        }
        return true;
    }

    void NotifyInterfaceUp(uint32_t) override {}
    void NotifyInterfaceDown(uint32_t) override {}
    void NotifyAddAddress(uint32_t, Ipv4InterfaceAddress) override {}
    void NotifyRemoveAddress(uint32_t, Ipv4InterfaceAddress) override {}
    void SetIpv4(Ptr<Ipv4> ipv4) override { m_ipv4 = ipv4; }
    void PrintRoutingTable(Ptr<OutputStreamWrapper>, Time::Unit) const override {}

  private:
    /// The greedy step. Interfaces and channel devices are walked in index
    /// order and a tie keeps the first, so the choice is deterministic.
    Ptr<Ipv4Route> Next(Ipv4Address dst) const {
        auto it = g_addrToNode.find(dst.Get());
        if (it == g_addrToNode.end()) return nullptr;
        Ptr<Node> self = m_ipv4->GetObject<Node>();
        Ptr<Node> goal = it->second;
        auto sv = g_servingSat.find(goal->GetId());
        if (sv != g_servingSat.end()) {
            if (!sv->second) return nullptr;  // destination station unserved
            if (sv->second != self) goal = sv->second;
        }
        const Vector target = PosOf(goal);
        // A ground station's one up link is its uplink, not a routing choice:
        // it is always taken (from the ground, the serving satellite is
        // usually FARTHER from a distant destination than the station is, so
        // a strict greedy step would refuse every packet at its source).
        // Greedy applies in the space segment.
        const bool ground = !self->GetObject<LeoCircularOrbitMobilityModel>();
        double bestD = ground ? 1e300 : Dist(PosOf(self), target);
        Ptr<Ipv4Route> best;
        for (uint32_t i = 1; i < m_ipv4->GetNInterfaces(); ++i) {
            if (!m_ipv4->IsUp(i) || m_ipv4->GetNAddresses(i) == 0) continue;
            Ptr<NetDevice> dev = m_ipv4->GetNetDevice(i);
            Ptr<Channel> ch = dev->GetChannel();
            if (!ch) continue;
            for (std::size_t k = 0; k < ch->GetNDevices(); ++k) {
                Ptr<NetDevice> peer = ch->GetDevice(k);
                if (peer == dev) continue;
                Ptr<Ipv4> pIp = peer->GetNode()->GetObject<Ipv4>();
                const int32_t pIf = pIp->GetInterfaceForDevice(peer);
                if (pIf < 0 || !pIp->IsUp(static_cast<uint32_t>(pIf))) continue;
                const bool isDst = peer->GetNode() == it->second || peer->GetNode() == goal;
                const double d = isDst ? -1.0 : Dist(PosOf(peer->GetNode()), target);
                if (d < bestD) {
                    bestD = d;
                    best = Create<Ipv4Route>();
                    best->SetDestination(dst);
                    best->SetGateway(pIp->GetAddress(static_cast<uint32_t>(pIf), 0).GetLocal());
                    best->SetSource(m_ipv4->GetAddress(i, 0).GetLocal());
                    best->SetOutputDevice(dev);
                }
            }
        }
        return best;
    }

    Ptr<Ipv4> m_ipv4;
};
NS_OBJECT_ENSURE_REGISTERED(GeoGreedy);

class GeoGreedyHelper : public Ipv4RoutingHelper {
  public:
    GeoGreedyHelper* Copy() const override { return new GeoGreedyHelper(*this); }
    Ptr<Ipv4RoutingProtocol> Create(Ptr<Node>) const override { return CreateObject<GeoGreedy>(); }
};

void UpdateDelays(World* w, double every) {
    for (Link& l : w->isls) {
        const double d = Dist(PosOf(w->sats.Get(l.a)), PosOf(w->sats.Get(l.b)));
        l.channel->SetAttribute("Delay", TimeValue(Seconds(d / kLightSpeed)));
    }
    for (uint32_t g = 0; g < w->gsl.size(); ++g) {
        for (Link& l : w->gsl[g]) {
            if (!l.up) continue;
            const double d = Dist(PosOf(w->ground.Get(g)), PosOf(w->sats.Get(l.b)));
            l.channel->SetAttribute("Delay", TimeValue(Seconds(d / kLightSpeed)));
        }
    }
    Simulator::Schedule(Seconds(every), &UpdateDelays, w, every);
}

/// Best visible serving satellite for station g (index into gsl[g]), or -1.
int BestGsl(World* w, uint32_t g, double minElev) {
    const Vector gs = PosOf(w->ground.Get(g));
    int best = -1;
    double bestEl = minElev;
    for (uint32_t k = 0; k < w->gsl[g].size(); ++k) {
        const uint32_t s = w->gsl[g][k].b;
        if (!w->satUp[s]) continue;
        const double el = ElevationDeg(gs, PosOf(w->sats.Get(s)));
        if (el >= bestEl) {
            bestEl = el;
            best = static_cast<int>(k);
        }
    }
    return best;
}

void Handover(World* w, uint32_t g, int to, int kind) {
    const int from = w->serving[g];
    if (from == to) return;
    if (from >= 0) SetLink(w->gsl[g][from], false);
    if (to >= 0) SetLink(w->gsl[g][to], true);
    w->serving[g] = to;
    g_servingSat[w->ground.Get(g)->GetId()] = to >= 0 ? w->sats.Get(w->gsl[g][to].b) : nullptr;
    g_events.emplace_back(Simulator::Now().GetSeconds(), kind);
    g_eventGs.push_back(static_cast<int>(g));
    g_eventLink.push_back(-1);
    (kind == 1 ? g_scheduledHo : g_forcedHo)++;
}

void HandoverClock(World* w, const Params* P) {
    ++g_clockTicks;
    for (uint32_t g = 0; g < w->ground.GetN(); ++g) Handover(w, g, BestGsl(w, g, P->minElevDeg), 1);
    Simulator::Schedule(Seconds(P->clock), &HandoverClock, w, P);
}

/// Between clock ticks: if the serving satellite sets (or fails), hand over now.
void VisibilityWatch(World* w, const Params* P) {
    for (uint32_t g = 0; g < w->ground.GetN(); ++g) {
        const int k = w->serving[g];
        bool lost = k < 0;
        if (k >= 0) {
            const uint32_t s = w->gsl[g][k].b;
            lost = !w->satUp[s] ||
                   ElevationDeg(PosOf(w->ground.Get(g)), PosOf(w->sats.Get(s))) < P->minElevDeg;
        }
        if (lost) {
            const int best = BestGsl(w, g, P->minElevDeg);
            if (best != k) Handover(w, g, best, 2);
        }
    }
    Simulator::Schedule(Seconds(0.5), &VisibilityWatch, w, P);
}

void IslFail(World* w, uint32_t i, bool down, double meanDown, double meanUp,
             Ptr<ExponentialRandomVariable> downVar, Ptr<ExponentialRandomVariable> upVar) {
    Link& l = w->isls[i];
    if (down) {
        if (w->satUp[l.a] && w->satUp[l.b]) SetLink(l, false);
        g_events.emplace_back(Simulator::Now().GetSeconds(), 3);
        g_eventGs.push_back(-1);
        g_eventLink.push_back(static_cast<int>(i));
        ++g_islFailures;
        Simulator::Schedule(Seconds(downVar->GetValue(meanDown, 0)), &IslFail, w, i, false,
                            meanDown, meanUp, downVar, upVar);
    } else {
        if (w->satUp[l.a] && w->satUp[l.b]) SetLink(l, true);
        Simulator::Schedule(Seconds(upVar->GetValue(meanUp, 0)), &IslFail, w, i, true, meanDown,
                            meanUp, downVar, upVar);
    }
}

void MassFail(World* w, std::vector<uint32_t> victims) {
    for (uint32_t s : victims) {
        w->satUp[s] = false;
        g_massVictimIds.insert(w->sats.Get(s)->GetId());
    }
    for (Link& l : w->isls) {
        if (!w->satUp[l.a] || !w->satUp[l.b]) SetLink(l, false);
    }
    g_events.emplace_back(Simulator::Now().GetSeconds(), 4);
    g_eventGs.push_back(-1);
    g_eventLink.push_back(-1);
}

/// Per-delivery bookkeeping at the destination's IP layer: time, hop count
/// (initial TTL minus the arriving TTL), one-way delay (from the FlowMonitor-
/// independent timestamp the source wrote into the packet payload).
std::map<uint32_t, uint32_t> g_dstAddrToFlow;
void LocalDeliver(const Ipv4Header& ip, Ptr<const Packet> p, uint32_t) {
    auto it = g_dstAddrToFlow.find(ip.GetDestination().Get());
    if (it == g_dstAddrToFlow.end() || ip.GetProtocol() != 17) return;  // UDP only (not ICMP)
    Ptr<Packet> c = p->Copy();
    UdpHeader udp;
    if (!c->RemoveHeader(udp) || udp.GetDestinationPort() != kDataPort) return;
    SeqTsHeader ts;
    if (c->GetSize() < ts.GetSerializedSize()) return;
    c->RemoveHeader(ts);
    const uint32_t f = it->second;
    const double now = Simulator::Now().GetSeconds();
    g_rxTimes[f].push_back(now);
    g_rxHops[f].push_back(kInitialTtl - ip.GetTtl());
    g_rxDelay[f].push_back(now - ts.GetTs().GetSeconds());
    if (!g_rxSeq[f].insert(ts.GetSeq()).second) ++g_rxDup[f];
    auto path = g_pktPath.find(p->GetUid());
    g_rxPath[f].emplace_back(ts.GetTs().GetSeconds(),
                             path == g_pktPath.end() ? std::vector<uint32_t>{} : path->second);
    if (path != g_pktPath.end()) g_pktPath.erase(path);
}

/// Every forwarding hop of a data packet (UnicastForward at each node).
void OnForward(uint32_t node, const Ipv4Header& ip, Ptr<const Packet> p, uint32_t) {
    if (ip.GetProtocol() != 17 || !g_dstAddrToFlow.count(ip.GetDestination().Get())) return;
    g_pktPath[p->GetUid()].push_back(node);
}

/// Probe pass: build the shell and the stations alone, sample which
/// satellites each station sees above the minimum elevation at every second of
/// the run, and tear the probe down. Orbits are deterministic, so the real run
/// (a fresh shell from a fresh helper) flies exactly the same positions.
std::vector<std::set<uint32_t>> VisibleCandidates(const Params& P) {
    LeoOrbitNodeHelper orbit;
    NodeContainer sats = orbit.CreateNodesAndInstallMobility(
        LeoOrbitalShell(P.altKm, P.incDeg, P.planes, P.sats, P.phasing, 360.0));
    const uint32_t nGs = static_cast<uint32_t>(g_cities.size());
    std::vector<Vector> gs(nGs);
    for (uint32_t g = 0; g < nGs; ++g) {
        Ptr<GeocentricConstantPositionMobilityModel> m =
            CreateObject<GeocentricConstantPositionMobilityModel>();
        m->SetGeographicPosition(Vector(g_cities[g].lat, g_cities[g].lon, 0));
        gs[g] = m->GetGeocentricPosition();
    }
    std::vector<std::set<uint32_t>> cand(nGs);
    for (double t = 0; t <= P.simTime; t += 1.0) {
        Simulator::Schedule(Seconds(t), [&] {
            for (uint32_t s = 0; s < sats.GetN(); ++s) {
                const Vector sp = PosOf(sats.Get(s));
                for (uint32_t g = 0; g < nGs; ++g) {
                    if (ElevationDeg(gs[g], sp) >= P.minElevDeg) cand[g].insert(s);
                }
            }
        });
    }
    Simulator::Stop(Seconds(P.simTime + 0.5));
    Simulator::Run();
    Simulator::Destroy();
    return cand;
}

/// Geometry anchors (#237 discipline): checks a wrong substrate cannot pass.
///  - every satellite's distance from the Earth's centre is constant and the
///    same for all (a circular shell), and the in-plane neighbour distance
///    equals the chord 2 r sin(pi/S) for that radius;
///  - the shell is rigid: the in-plane chord is unchanged half an orbital
///    period later, where the period is 2 pi sqrt(r^3 / mu).
void Anchors(const Params& P) {
    LeoOrbitNodeHelper orbit;
    NodeContainer sats = orbit.CreateNodesAndInstallMobility(
        LeoOrbitalShell(P.altKm, P.incDeg, P.planes, P.sats, P.phasing, 360.0));
    double rMin = 1e30, rMax = 0, chordErr0 = 0, chordErrHalf = 0, r0 = 0, period = 0;
    auto sample = [&](double* chordErr) {
        for (uint32_t i = 0; i < sats.GetN(); ++i) {
            const Vector p = PosOf(sats.Get(i));
            const double r = std::sqrt(p.x * p.x + p.y * p.y + p.z * p.z);
            rMin = std::min(rMin, r);
            rMax = std::max(rMax, r);
        }
        r0 = rMax;
        const double chord = 2 * r0 * std::sin(M_PI / P.sats);
        for (uint32_t pl = 0; pl < P.planes; ++pl) {
            for (uint32_t s = 0; s < P.sats; ++s) {
                const double d = Dist(PosOf(sats.Get(pl * P.sats + s)),
                                      PosOf(sats.Get(pl * P.sats + (s + 1) % P.sats)));
                *chordErr = std::max(*chordErr, std::fabs(d - chord));
            }
        }
    };
    Simulator::Schedule(Seconds(0), [&] {
        sample(&chordErr0);
        period = 2 * M_PI * std::sqrt(r0 * r0 * r0 / kMuEarth);
        Simulator::Schedule(Seconds(period / 2), [&] { sample(&chordErrHalf); });
    });
    Simulator::Run();
    Simulator::Destroy();
    std::cout << std::fixed << std::setprecision(3) << "# anchor shell radiusKm=" << r0 / 1000
              << " altitudeKm(sphere)=" << (r0 - kEarthRadiusM) / 1000
              << " radiusSpreadM=" << (rMax - rMin)
              << " chordKm=" << 2 * r0 * std::sin(M_PI / P.sats) / 1000
              << " chordErrM(t=0)=" << chordErr0
              << " chordErrM(t=T/2)=" << chordErrHalf
              << " periodMin=" << period / 60 << "\n";
}

double Quantile(std::vector<double> v, double q) {
    if (v.empty()) return std::nan("");
    std::sort(v.begin(), v.end());
    return v[std::min(v.size() - 1, static_cast<size_t>(q * v.size()))];
}

Result RunOne(const std::string& proto, const Params& P, uint32_t seed,
             const std::vector<std::set<uint32_t>>& cand) {
    RngSeedManager::SetSeed(1);
    RngSeedManager::SetRun(seed);
    const int64_t streamBase = static_cast<int64_t>(seed) * kStreamStride;
    int64_t stream = streamBase;
    int64_t appStream = streamBase + kAppStreamOffset;
    g_controlPkts = g_controlBytes = 0;
    g_geoNoRouteOrigin = g_geoNoRouteForward = 0;
    g_addrToNode.clear();
    g_servingSat.clear();
    g_events.clear();
    g_eventGs.clear();
    g_eventLink.clear();
    g_massVictimIds.clear();
    g_pktPath.clear();
    g_scheduledHo = g_forcedHo = g_islFailures = 0;
    g_clockTicks = 0;
    g_dstAddrToFlow.clear();

    World w;
    LeoOrbitNodeHelper orbit;
    w.sats = orbit.CreateNodesAndInstallMobility(
        LeoOrbitalShell(P.altKm, P.incDeg, P.planes, P.sats, P.phasing, 360.0));
    const uint32_t nSat = w.sats.GetN();
    w.satUp.assign(nSat, true);
    const uint32_t nGs = static_cast<uint32_t>(g_cities.size());
    w.ground.Create(nGs);
    for (uint32_t g = 0; g < nGs; ++g) {
        Ptr<GeocentricConstantPositionMobilityModel> m =
            CreateObject<GeocentricConstantPositionMobilityModel>();
        m->SetGeographicPosition(Vector(g_cities[g].lat, g_cities[g].lon, 0));
        w.ground.Get(g)->AggregateObject(m);
    }

    // Routing on every node (satellites and stations alike), helpers hoisted so
    // AssignStreams can pin them (#352).
    NodeContainer all(w.sats, w.ground);
    InternetStackHelper internet;
    AntHocNetHelper ahn;
    AodvHelper aodv;
    OlsrHelper olsr;
    OracleHelper oracleHelper;
    GeoGreedyHelper geoHelper;
    if (proto == "anthocnet") internet.SetRoutingHelper(ahn);
    else if (proto == "aodv") internet.SetRoutingHelper(aodv);
    else if (proto == "olsr") internet.SetRoutingHelper(olsr);
    else if (proto == "oracle") internet.SetRoutingHelper(oracleHelper);
    else if (proto == "geo-greedy") internet.SetRoutingHelper(geoHelper);
    else if (proto == "oracle-delay") {
        // The latency bound: the oracle with propagation-delay edge weights.
        // Links of one hop count differ in length on a moving shell, so the
        // hop-count oracle is a delivery bound, not a delay bound (#297).
        oracleHelper.Set("Metric", StringValue("delay"));
        oracleHelper.Set("RecomputeInterval",
                         TimeValue(Seconds(P.oracleInterval > 0 ? P.oracleInterval : P.delayUpdate)));
        internet.SetRoutingHelper(oracleHelper);
    }
    else NS_ABORT_MSG("unknown protocol '" << proto << "' (anthocnet, aodv, olsr, oracle, oracle-delay, geo-greedy)");
    internet.Install(all);
    stream += internet.AssignStreams(all, stream);
    if (proto == "anthocnet") stream += ahn.AssignStreams(all, stream);
    else if (proto == "aodv") stream += aodv.AssignStreams(all, stream);
    else if (proto == "olsr") stream += olsr.AssignStreams(all, stream);
    else if (proto != "geo-greedy") stream += oracleHelper.AssignStreams(all, stream);  // oracle, oracle-delay: 0 streams
    NS_ABORT_MSG_IF(stream - streamBase >= kAppStreamOffset, "RNG stream budget exhausted (#352)");

    g_ipGate = proto == "oracle" || proto == "oracle-delay" || proto == "geo-greedy";
    g_dropAll = CreateObject<DropAll>();
    PointToPointHelper isl;
    isl.SetDeviceAttribute("DataRate", StringValue(P.islRate));
    Ipv4AddressHelper addr;
    addr.SetBase("10.0.0.0", "255.255.255.252");
    auto build = [&](PointToPointHelper& h, Ptr<Node> a, Ptr<Node> b, uint32_t ia, uint32_t ib) {
        NetDeviceContainer d = h.Install(a, b);
        Ipv4InterfaceContainer ifc = addr.Assign(d);
        addr.NewNetwork();
        Link l;
        l.a = ia;
        l.b = ib;
        l.channel = d.Get(0)->GetChannel();
        l.ipA = ifc.Get(0).first;
        l.ifA = ifc.Get(0).second;
        l.ipB = ifc.Get(1).first;
        l.ifB = ifc.Get(1).second;
        l.devA = d.Get(0);
        l.devB = d.Get(1);
        return l;
    };

    // +grid ISLs. Node i is plane i / S, slot i % S (LeoCircularOrbitAllocator
    // order). In-plane: slot s <-> s+1. Cross-plane: plane p slot s <-> plane
    // p+1 slot s; across the seam (last plane -> plane 0) the Walker phasing
    // shifts the slots, so the partner is the nearest plane-0 satellite at t=0.
    const uint32_t S = P.sats, Pn = P.planes;
    for (uint32_t p = 0; p < Pn; ++p) {
        for (uint32_t s = 0; s < S; ++s) {
            const uint32_t i = p * S + s;
            w.isls.push_back(build(isl, w.sats.Get(i), w.sats.Get(p * S + (s + 1) % S), i,
                                   p * S + (s + 1) % S));
            if (Pn < 2) continue;
            uint32_t j;
            if (p + 1 < Pn) {
                j = (p + 1) * S + s;
            } else {
                j = 0;
                double best = 1e30;
                for (uint32_t k = 0; k < S; ++k) {
                    const double d = Dist(PosOf(w.sats.Get(i)), PosOf(w.sats.Get(k)));
                    if (d < best) { best = d; j = k; }
                }
            }
            if (Pn == 2 && p == 1) continue;  // two planes: one cross link per slot
            w.isls.push_back(build(isl, w.sats.Get(i), w.sats.Get(j), i, j));
        }
    }

    // GSL candidates (from the probe pass in main -- it must run before any
    // run builds nodes, because Simulator::Destroy disposes every node in the
    // global NodeList): one link per (station, satellite ever visible), all
    // down until a handover raises it.
    w.gsl.resize(nGs);
    w.serving.assign(nGs, -1);
    CsmaHelper gsl;
    gsl.SetChannelAttribute("DataRate", StringValue(P.gslRate));
    for (uint32_t g = 0; g < nGs; ++g) {
        if (cand[g].empty()) continue;
        NodeContainer seg(w.ground.Get(g));
        for (uint32_t s : cand[g]) seg.Add(w.sats.Get(s));
        NetDeviceContainer d = gsl.Install(seg);
        // CSMA backoff draws randomness: pin it, or the auto-assigned streams
        // shift with every earlier run in this process and an arm's result
        // depends on which arms ran before it (#352).
        stream += gsl.AssignStreams(d, stream);
        Ipv4AddressHelper ga;
        std::ostringstream net;
        net << "10." << (200 + g) << ".0.0";
        ga.SetBase(net.str().c_str(), "255.255.0.0");
        Ipv4InterfaceContainer ifc = ga.Assign(d);
        uint32_t k = 1;
        for (uint32_t s : cand[g]) {
            Link l;
            l.a = g;
            l.b = s;
            l.channel = d.Get(0)->GetChannel();
            l.ipA = ifc.Get(0).first;
            l.ifA = ifc.Get(0).second;
            l.ipB = ifc.Get(k).first;
            l.ifB = ifc.Get(k).second;
            l.devA = d.Get(0);
            l.devB = d.Get(k);
            l.satSideOnly = true;
            ++k;
            SetLink(l, false);
            w.gsl[g].push_back(l);
        }
    }

    NS_ABORT_MSG_IF(stream - streamBase >= kAppStreamOffset, "RNG stream budget exhausted (#352)");

    // Every assigned address -> its node (geo-greedy's location service).
    for (uint32_t i = 0; i < all.GetN(); ++i) {
        Ptr<Ipv4> ip = all.Get(i)->GetObject<Ipv4>();
        for (uint32_t k = 1; k < ip->GetNInterfaces(); ++k) {
            for (uint32_t a = 0; a < ip->GetNAddresses(k); ++a) {
                g_addrToNode[ip->GetAddress(k, a).GetLocal().Get()] = all.Get(i);
            }
        }
    }

    // Overhead counted at the IP layer, as the other harnesses do.
    for (uint32_t i = 0; i < all.GetN(); ++i) {
        Ptr<Ipv4L3Protocol> l3 = all.Get(i)->GetObject<Ipv4L3Protocol>();
        if (l3) l3->TraceConnectWithoutContext("Tx", MakeCallback(&CountControlTx));
        if (l3) {
            l3->TraceConnectWithoutContext("UnicastForward",
                                           MakeBoundCallback(&OnForward, all.Get(i)->GetId()));
        }
    }

    // Dynamics: delays follow positions; the handover clock and the
    // visibility watch drive the GSLs; the failure overlay and the mass
    // failure draw from the application sub-block, so every arm sees the same
    // events on the same seed (#517).
    UpdateDelays(&w, P.delayUpdate);
    Simulator::Schedule(Seconds(0), [&w, &P] {
        for (uint32_t g = 0; g < w.ground.GetN(); ++g) {
            const int best = BestGsl(&w, g, P.minElevDeg);
            if (best >= 0) SetLink(w.gsl[g][best], true);
            w.serving[g] = best;
            g_servingSat[w.ground.Get(g)->GetId()] =
                best >= 0 ? w.sats.Get(w.gsl[g][best].b) : nullptr;
        }
    });
    const double firstTick = std::fmod(P.clockOffset, P.clock);
    Simulator::Schedule(Seconds(firstTick > 0 ? firstTick : P.clock), &HandoverClock, &w, &P);
    Simulator::Schedule(Seconds(0.5), &VisibilityWatch, &w, &P);
    if (P.islDown > 0) {
        const double meanUp = P.islMeanDown * (1 - P.islDown) / P.islDown;
        Ptr<ExponentialRandomVariable> downVar = CreateObject<ExponentialRandomVariable>();
        Ptr<ExponentialRandomVariable> upVar = CreateObject<ExponentialRandomVariable>();
        downVar->SetStream(appStream++);
        upVar->SetStream(appStream++);
        for (uint32_t i = 0; i < w.isls.size(); ++i) {
            Simulator::Schedule(Seconds(upVar->GetValue(meanUp, 0)), &IslFail, &w, i, true,
                                P.islMeanDown, meanUp, downVar, upVar);
        }
    }
    if (P.massFailAt > 0) {
        Ptr<UniformRandomVariable> pick = CreateObject<UniformRandomVariable>();
        pick->SetStream(appStream++);
        std::vector<uint32_t> victims;
        for (uint32_t s = 0; s < nSat; ++s) {
            if (pick->GetValue() < P.massFailFrac) victims.push_back(s);
        }
        Simulator::Schedule(Seconds(P.massFailAt), &MassFail, &w, victims);
    }

    // Flows between ground stations; each station is addressed by its first
    // GSL interface (its canonical address to the core, #218).
    std::ostringstream rate;
    rate << static_cast<uint64_t>(P.cbrBps) << "bps";
    Ptr<UniformRandomVariable> startVar = CreateObject<UniformRandomVariable>();
    startVar->SetAttribute("Min", DoubleValue(1.0));
    startVar->SetAttribute("Max", DoubleValue(5.0));
    startVar->SetStream(appStream++);
    const uint32_t nPairs = static_cast<uint32_t>(g_pairs.size());
    const uint32_t nFlows = std::min(P.nFlows, nPairs);
    g_rxTimes.assign(nFlows, {});
    g_rxHops.assign(nFlows, {});
    g_rxDelay.assign(nFlows, {});
    g_flowGs.assign(nFlows, {});
    g_rxSeq.assign(nFlows, {});
    g_rxDup.assign(nFlows, 0);
    g_attempts.assign(nFlows, {});
    g_rxPath.assign(nFlows, {});
    ApplicationContainer apps;
    for (uint32_t f = 0; f < nFlows; ++f) {
        const uint32_t src = g_pairs[f].first, dst = g_pairs[f].second;
        NS_ABORT_MSG_IF(w.gsl[src].empty() || w.gsl[dst].empty(),
                        "station " << g_cities[w.gsl[src].empty() ? src : dst].name
                        << " never sees a satellite above " << P.minElevDeg
                        << " deg: lower --minElevation or densify the shell");
        const Ipv4Address dstAddr = w.gsl[dst][0].ipA->GetAddress(w.gsl[dst][0].ifA, 0).GetLocal();
        g_dstAddrToFlow[dstAddr.Get()] = f;
        g_flowGs[f] = {static_cast<int>(src), static_cast<int>(dst)};
        // UdpClient stamps a SeqTsHeader into every packet, which gives the
        // per-delivery one-way delay without FlowMonitor's per-flow aggregation.
        const double interval = 64.0 * 8.0 / P.cbrBps;
        UdpClientHelper client(InetSocketAddress(dstAddr, kDataPort));
        client.SetAttribute("Interval", TimeValue(Seconds(interval)));
        client.SetAttribute("PacketSize", UintegerValue(64));
        client.SetAttribute("MaxPackets", UintegerValue(0));
        ApplicationContainer a = client.Install(w.ground.Get(src));
        a.Start(Seconds(startVar->GetValue()));
        Ptr<UdpClient> uc = DynamicCast<UdpClient>(a.Get(0));
        uc->TraceConnectWithoutContext("Tx", MakeBoundCallback(&OnClientTx, f, uc));
        a.Stop(Seconds(P.simTime - 1.0));
        apps.Add(a);
        UdpServerHelper server(kDataPort);
        ApplicationContainer srv = server.Install(w.ground.Get(dst));
        srv.Start(Seconds(0));
        Ptr<Ipv4L3Protocol> l3 = w.ground.Get(dst)->GetObject<Ipv4L3Protocol>();
        static std::set<uint32_t> hooked;
        if (f == 0) hooked.clear();
        if (!hooked.count(dst)) {
            l3->TraceConnectWithoutContext("LocalDeliver", MakeCallback(&LocalDeliver));
            hooked.insert(dst);
        }
    }
    NS_ABORT_MSG_IF(appStream - streamBase >= kStreamStride, "application RNG sub-block full (#517)");

    FlowMonitorHelper fmHelper;
    Ptr<FlowMonitor> monitor = fmHelper.InstallAll();
    Simulator::Stop(Seconds(P.simTime));
    Simulator::Run();

    monitor->CheckForLostPackets();
    Result r;
    r.proto = proto;
    double totalDelay = 0, totalRxBytes = 0, totalJitter = 0, binWidth = 0;
    uint64_t jitterSamples = 0;
    std::map<uint32_t, uint64_t> bins;
    Ptr<Ipv4FlowClassifier> classifier = DynamicCast<Ipv4FlowClassifier>(fmHelper.GetClassifier());
    for (auto& kv : monitor->GetFlowStats()) {
        if (classifier->FindFlow(kv.first).destinationPort != kDataPort) continue;
        r.txPackets += kv.second.txPackets;
        r.rxPackets += kv.second.rxPackets;
        totalDelay += kv.second.delaySum.GetSeconds();
        totalRxBytes += kv.second.rxBytes;
        totalJitter += kv.second.jitterSum.GetSeconds();
        if (kv.second.rxPackets > 0) jitterSamples += kv.second.rxPackets - 1;
        Histogram h = kv.second.delayHistogram;
        for (uint32_t b = 0; b < h.GetNBins(); ++b) {
            if (binWidth == 0) binWidth = h.GetBinWidth(b);
            bins[b] += h.GetBinCount(b);
        }
    }
    // Sends a station refused because its stack had no route at all (the
    // oracles and geo-greedy with no path, OLSR before convergence) never
    // reach FlowMonitor, and UdpClient does not count them either: the offered
    // load is the attempts counted from the client's Tx trace (OnClientTx).
    uint64_t offered = 0;
    for (const auto& a : g_attempts) offered += a.size();
    if (offered > r.txPackets) r.txPackets = offered;
    r.pdr = r.txPackets ? 100.0 * r.rxPackets / r.txPackets : 0;
    r.meanDelayMs = r.rxPackets ? 1000.0 * totalDelay / r.rxPackets : 0;
    r.throughputKbps = totalRxBytes * 8.0 / 1000.0 / P.simTime;
    r.nrl = r.rxPackets ? static_cast<double>(g_controlPkts) / r.rxPackets : 0;
    r.nrlBytes = totalRxBytes > 0 ? g_controlBytes / totalRxBytes : 0;
    r.jitterMs = jitterSamples ? 1000.0 * totalJitter / jitterSamples : 0;
    if (r.rxPackets && binWidth > 0) {
        const uint64_t target = static_cast<uint64_t>(0.99 * r.rxPackets);
        uint64_t cum = 0;
        for (const auto& b : bins) {
            cum += b.second;
            if (cum >= target) { r.delay99Ms = 1000.0 * (b.first + 1) * binWidth; break; }
        }
    }

    // --- handover metric family (#297 item 3) ---------------------------------
    std::cout << std::fixed << std::setprecision(3);
    std::cout << "# handover " << proto << " seed=" << seed << " scheduled=" << g_scheduledHo
              << " forced=" << g_forcedHo << " islFailures=" << g_islFailures
              << " ticks=" << g_clockTicks << "\n";
    const double interval = 64.0 * 8.0 / P.cbrBps;
    // Outages on the SENDER's timeline, from the sequence numbers UdpClient
    // stamps (the Starlink / LENS measurement convention: a run of lost
    // probes). An outage is a run of >= kOutageRun consecutive lost sequence
    // numbers; its duration is run x interval. The run that starts at a
    // flow's first packet is class "startup" (initial route acquisition, a
    // different claim from losing an established path); every other run is
    // classed by the most recent event in the 1 s before its first lost
    // packet was sent: a GSL handover at one of the flow's own stations
    // (scheduled or forced), an ISL failure, a mass failure, or "other".
    // Every offered packet is accounted for exactly once:
    //   offered = delivered + outageLost + scatteredLost
    // (# account per flow; scenario_check.py re-checks the identity).
    constexpr uint32_t kOutageRun = 3;
    std::map<std::string, std::vector<double>> outages;
    std::map<std::string, uint64_t> lostByClass;
    for (uint32_t f = 0; f < g_rxSeq.size(); ++f) {
        const auto& at = g_attempts[f];
        const uint64_t offeredF = at.size();
        auto lost = [&](uint64_t i) {
            return at[i].seq < 0 || !g_rxSeq[f].count(static_cast<uint32_t>(at[i].seq));
        };
        uint64_t outageLost = 0, scatteredLost = 0, refused = 0, delivered = 0;
        for (const Attempt& x : at) {
            refused += x.seq < 0;
            delivered += x.seq >= 0 && g_rxSeq[f].count(static_cast<uint32_t>(x.seq));
        }
        uint64_t k = 0;
        while (k < offeredF) {
            if (!lost(k)) { ++k; continue; }
            uint64_t e = k;
            while (e < offeredF && lost(e)) ++e;
            const uint64_t run = e - k;
            if (run < kOutageRun) {
                scatteredLost += run;
                k = e;
                continue;
            }
            outageLost += run;
            const double begin = at[k].t;
            std::string cls = k == 0 ? "startup" : "other";
            // The path the flow was using: that of the latest-sent delivered
            // packet sent before the outage began.
            const std::vector<uint32_t>* lastPath = nullptr;
            double lastSend = -1;
            for (const auto& rp : g_rxPath[f]) {
                if (rp.first < begin && rp.first > lastSend) {
                    lastSend = rp.first;
                    lastPath = &rp.second;
                }
            }
            auto onPath = [&](int kind, int ev) {
                if (!lastPath) return false;
                const auto& pth = *lastPath;
                if (kind == 4) {
                    for (uint32_t n : pth) if (g_massVictimIds.count(n)) return true;
                    return false;
                }
                const Link& l = w.isls[static_cast<size_t>(g_eventLink[ev])];
                const uint32_t a = w.sats.Get(l.a)->GetId(), b = w.sats.Get(l.b)->GetId();
                for (size_t h = 1; h < pth.size(); ++h) {
                    if ((pth[h - 1] == a && pth[h] == b) || (pth[h - 1] == b && pth[h] == a)) return true;
                }
                return false;
            };
            double bestT = -1;
            for (size_t ev = 0; k > 0 && ev < g_events.size(); ++ev) {
                const double et = g_events[ev].first;
                if (et < begin - 1.0 || et > begin + interval || et < bestT) continue;
                const int kind = g_events[ev].second;
                const int gs = g_eventGs[ev];
                if ((kind == 1 || kind == 2) && gs != g_flowGs[f][0] && gs != g_flowGs[f][1]) continue;
                if ((kind == 3 || kind == 4) && !onPath(kind, static_cast<int>(ev))) continue;
                bestT = et;
                cls = kind <= 2 ? "scheduled" : kind == 3 ? "unplanned" : "massfail";
            }
            outages[cls].push_back(static_cast<double>(run) * interval);
            lostByClass[cls] += run;
            k = e;
        }
        std::cout << "# account " << proto << " seed=" << seed << " flow=" << f
                  << " offered=" << offeredF << " refused=" << refused
                  << " delivered=" << delivered << " received=" << g_rxSeq[f].size()
                  << " dup=" << g_rxDup[f] << " outageLost=" << outageLost
                  << " scatteredLost=" << scatteredLost << "\n";
    }
    for (const char* cls : {"startup", "scheduled", "unplanned", "massfail", "other"}) {
        const auto& v = outages[cls];
        std::cout << "# outage " << proto << " seed=" << seed << " class=" << cls
                  << " n=" << v.size() << " lost=" << lostByClass[cls]
                  << " p50=" << Quantile(v, 0.5) << " p90=" << Quantile(v, 0.9)
                  << " max=" << (v.empty() ? std::nan("") : *std::max_element(v.begin(), v.end()))
                  << "\n";
    }
    for (uint32_t f = 0; f < g_rxHops.size(); ++f) {
        uint32_t changes = 0;
        for (size_t k = 1; k < g_rxHops[f].size(); ++k) changes += g_rxHops[f][k] != g_rxHops[f][k - 1];
        const double span = g_rxTimes[f].size() > 1 ? g_rxTimes[f].back() - g_rxTimes[f].front() : 0;
        double meanHops = 0;
        for (int h : g_rxHops[f]) meanHops += h;
        if (!g_rxHops[f].empty()) meanHops /= g_rxHops[f].size();
        std::cout << "# churn " << proto << " seed=" << seed << " flow=" << f << " "
                  << g_cities[g_pairs[f].first].name << "-" << g_cities[g_pairs[f].second].name
                  << " hopChangesPerMin=" << (span > 0 ? 60.0 * changes / span : 0)
                  << " meanHops=" << meanHops << " delivered=" << g_rxTimes[f].size() << "\n";
    }
    if (P.series && !g_rxTimes.empty()) {
        const City& a = g_cities[g_pairs[0].first];
        const City& b = g_cities[g_pairs[0].second];
        const double geo = GreatCircle(a.lat, a.lon, b.lat, b.lon);
        std::map<int, std::pair<double, int>> perSec;
        for (size_t k = 0; k < g_rxTimes[0].size(); ++k) {
            auto& e = perSec[static_cast<int>(g_rxTimes[0][k])];
            e.first += g_rxDelay[0][k];
            e.second++;
        }
        for (const auto& kv : perSec) {
            std::cout << "# series " << proto << " seed=" << seed << " t=" << kv.first
                      << " delayMs=" << 1000.0 * kv.second.first / kv.second.second
                      << " geodesicMs=" << 1000.0 * geo / kLightSpeed
                      << " fiberMs=" << 1000.0 * geo / (2.0 / 3.0 * kLightSpeed) << "\n";
        }
    }
    if (proto == "oracle" || proto == "oracle-delay") {
        NS_ABORT_MSG_IF(g_controlPkts != 0, "oracle arm transmitted control packets (#296)");
        Ptr<oracle::Topology> topo = oracleHelper.GetTopology();
        std::cout << "##ORACLE## " << seed << ' ' << proto << " mode=" << topo->GetMode()
                  << " approx=" << (topo->IsApproximate() ? 1 : 0)
                  << " nodes=" << topo->GetNodeCount() << " edges=" << topo->GetEdgeCount()
                  << " recomputes=" << topo->GetRecomputeCount()
                  << " changes=" << topo->GetTopologyChanges()
                  << " noRoute=" << topo->GetNoRouteCount() << "\n";
    }
    if (proto == "geo-greedy") {
        NS_ABORT_MSG_IF(g_controlPkts != 0, "geo-greedy transmitted control packets");
        std::cout << "# geo " << proto << " seed=" << seed
                  << " noRouteOrigin=" << g_geoNoRouteOrigin
                  << " noRouteForward=" << g_geoNoRouteForward << "\n";
    }
    Simulator::Destroy();
    return r;
}

}  // namespace

int main(int argc, char* argv[]) {
    Params P;
    CommandLine cmd(__FILE__);
    cmd.AddValue("planes", "orbital planes", P.planes);
    cmd.AddValue("sats", "satellites per plane", P.sats);
    cmd.AddValue("phasing", "Walker-delta phasing factor F", P.phasing);
    cmd.AddValue("altitude", "shell altitude (km)", P.altKm);
    cmd.AddValue("inclination", "inclination (degrees)", P.incDeg);
    cmd.AddValue("shell", "preset: 'starlink1' = 72 x 22 at 550 km, 53 deg (overrides the above)",
                 P.shell);
    cmd.AddValue("pairs",
                 "ground stations and flows: 'default' (six cities, four pairs) or 'hypatia' "
                 "(Paris-Luanda only: Hypatia's published Starlink-S1 RTT range, #297 calibration)",
                 P.pairs);
    cmd.AddValue("time", "simulated seconds", P.simTime);
    cmd.AddValue("runs", "seeds per protocol", P.runs);
    cmd.AddValue("firstRun", "first seed", P.firstRun);
    cmd.AddValue("flows", "ground-station flows (city pairs, max 4)", P.nFlows);
    cmd.AddValue("protocols", "comma list: anthocnet, aodv, olsr, oracle (hop bound), oracle-delay (latency bound), geo-greedy (idealised greedy geographic)", P.protocols);
    cmd.AddValue("islRate", "ISL data rate", P.islRate);
    cmd.AddValue("gslRate", "GSL data rate", P.gslRate);
    cmd.AddValue("cbrBps", "per-flow CBR rate (bit/s), 64 B packets", P.cbrBps);
    cmd.AddValue("minElevation", "minimum elevation for a GSL (degrees)", P.minElevDeg);
    cmd.AddValue("clock", "GSL reconfiguration clock (s)", P.clock);
    cmd.AddValue("clockOffset", "first reconfiguration (s past the clock)", P.clockOffset);
    cmd.AddValue("islDown", "ISL unavailability fraction of the failure overlay (0 = off)", P.islDown);
    cmd.AddValue("islMeanDown", "mean ISL outage (s)", P.islMeanDown);
    cmd.AddValue("massFailAt", "mass satellite failure at this time (s; <0 = off)", P.massFailAt);
    cmd.AddValue("massFailFrac", "fraction of satellites lost in the mass failure", P.massFailFrac);
    cmd.AddValue("delayUpdate", "propagation-delay refresh period (s)", P.delayUpdate);
    cmd.AddValue("oracleInterval",
                 "oracle-delay re-solve period (s; 0 = --delayUpdate). Its all-pairs solve "
                 "dominates the run time on a 1584-satellite shell; a longer period bounds "
                 "the oracle's staleness by that period",
                 P.oracleInterval);
    cmd.AddValue("series", "print the per-second delay series of flow 0", P.series);
    cmd.AddValue("csv", "machine-readable rows", P.csv);
    cmd.Parse(argc, argv);
    if (P.shell == "starlink1") {
        P.planes = 72; P.sats = 22; P.altKm = 550; P.incDeg = 53; P.phasing = 39;
    }
    NS_ABORT_MSG_IF(P.planes < 2 || P.sats < 3, "need >= 2 planes and >= 3 satellites per plane");
    if (P.pairs == "hypatia") {
        g_cities.assign(std::begin(kHypatiaCities), std::end(kHypatiaCities));
        g_pairs.assign(std::begin(kHypatiaPairs), std::end(kHypatiaPairs));
    } else {
        NS_ABORT_MSG_IF(P.pairs != "default", "--pairs must be 'default' or 'hypatia'");
    }

    std::vector<std::string> protos;
    {
        std::stringstream ss(P.protocols);
        std::string p;
        while (std::getline(ss, p, ',')) if (!p.empty()) protos.push_back(p);
    }
    std::cout << "##CONFIG## harness=leo-walker planes=" << P.planes << " sats=" << P.sats
              << " phasing=" << P.phasing << " altitude=" << P.altKm << " inclination=" << P.incDeg
              << " time=" << P.simTime << " runs=" << P.runs << " firstRun=" << P.firstRun
              << " flows=" << P.nFlows << " cbrBps=" << P.cbrBps << " minElevation=" << P.minElevDeg
              << " clock=" << P.clock << " clockOffset=" << P.clockOffset << " islDown=" << P.islDown
              << " islMeanDown=" << P.islMeanDown << " massFailAt=" << P.massFailAt
              << " massFailFrac=" << P.massFailFrac << " delayUpdate=" << P.delayUpdate
              << " oracleInterval=" << P.oracleInterval
              << " protocols=" << P.protocols
              << (P.pairs == "default" ? "" : " pairs=" + P.pairs) << "\n";
    Anchors(P);
    const std::vector<std::set<uint32_t>> cand = VisibleCandidates(P);
    {
        std::cout << "# visibility minElevation=" << P.minElevDeg;
        for (uint32_t g = 0; g < cand.size(); ++g) std::cout << ' ' << g_cities[g].name << '=' << cand[g].size();
        std::cout << "\n";
    }

    std::cout << std::left << std::setw(12) << "protocol" << std::right << std::setw(8) << "PDR%"
              << std::setw(11) << "delay(ms)" << std::setw(13) << "delay99(ms)" << std::setw(14)
              << "thrput(kbps)" << std::setw(9) << "NRL" << std::setw(11) << "NRLbytes"
              << std::setw(12) << "jitter(ms)" << "\n";
    for (const std::string& proto : protos) {
        Result sum;
        sum.proto = proto;
        for (uint32_t k = 0; k < P.runs; ++k) {
            const uint32_t seed = P.firstRun + k;
            Result r = RunOne(proto, P, seed, cand);
            std::cout << std::fixed << std::setprecision(2) << "##RUN## " << seed << ' ' << proto
                      << ' ' << r.pdr << ' ' << r.meanDelayMs << ' ' << r.delay99Ms << ' '
                      << r.throughputKbps << ' ' << r.nrl << ' ' << r.nrlBytes << ' '
                      << r.jitterMs << "\n";
            sum.pdr += r.pdr / P.runs;
            sum.meanDelayMs += r.meanDelayMs / P.runs;
            sum.delay99Ms += r.delay99Ms / P.runs;
            sum.throughputKbps += r.throughputKbps / P.runs;
            sum.nrl += r.nrl / P.runs;
            sum.nrlBytes += r.nrlBytes / P.runs;
            sum.jitterMs += r.jitterMs / P.runs;
        }
        std::cout << std::fixed << std::setprecision(2) << std::left << std::setw(12) << proto
                  << std::right << std::setw(8) << sum.pdr << std::setw(11) << sum.meanDelayMs
                  << std::setw(13) << sum.delay99Ms << std::setw(14) << sum.throughputKbps
                  << std::setw(9) << sum.nrl << std::setw(11) << sum.nrlBytes << std::setw(12)
                  << sum.jitterMs << "\n";
    }
    return 0;
}
