// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

/**
 * The browser adapter (#544, ADR-0021): an adapter for the shared AntHocNet
 * core, next to the ns-3 one (and NS-2's, through v1.9.0). It owns what an adapter owns -- the
 * clock, the RNGs, the timers, the pending-packet queue, a radio -- and
 * carries out the RouteDecisions the core returns. It never decides a route.
 *
 * The radio is a *teaching* model: unit disk (optionally cut by buildings,
 * or a fixed ISL adjacency), a FIFO transmitter per node with a fixed bit
 * rate, and a MAC transmit-failure report when a unicast's receiver is out of
 * range. It is not ns-3 and nothing measured on it is a benchmark number.
 *
 * Everything here is plain C++14 on top of core/, so the same sources build
 * natively and with Emscripten; the native-vs-WASM decision-trace parity test
 * (web/test/parity.sh) holds the two builds byte-identical.
 */
#ifndef AHN_WEB_SIM_H
#define AHN_WEB_SIM_H

#include <cstdint>
#include <deque>
#include <functional>
#include <map>
#include <memory>
#include <queue>
#include <set>
#include <string>
#include <vector>

#include "anthocnet/core/ant_router_logic.h"
#include "anthocnet/core/config.h"
#include "anthocnet/core/ports.h"

namespace ahn_web {

using anthocnet::core::NodeAddress;

/// SplitMix64: tiny, portable, and bit-identical on every platform (integer
/// arithmetic only; the double is an exact 53-bit scaling).
class SplitMix64 {
public:
    /// A stream starting from `seed` (every seed is valid).
    explicit SplitMix64(std::uint64_t seed) : state_(seed) {}
    /// Next raw 64-bit value.
    std::uint64_t next();
    /// Uniform double in [0, 1), from the top 53 bits.
    double uniform();
    /// Uniform double in [lo, hi).
    double uniform(double lo, double hi) { return lo + (hi - lo) * uniform(); }
    /// Uniform integer in [0, n); 0 when n <= 0.
    int uniformInt(int n);

private:
    std::uint64_t state_;
};

/// A position in metres (z = altitude; 0 on planar worlds).
struct Vec3 {
    double x = 0;  ///< east
    double y = 0;  ///< north
    double z = 0;  ///< up
};

/// One straight leg of a node's trajectory: p0 at t0 to p1 at t1.
struct Leg {
    double t0;  ///< start time (s)
    double t1;  ///< end time (s); 1e18 = forever
    Vec3 p0;    ///< position at t0
    Vec3 p1;    ///< position at t1 (linear in between)
};

/// How a node moves. Values are part of the JS API (setMobility's `kind`).
enum class MobilityKind {
    Static,          ///< never moves (until dragged)
    RandomWaypoint,  ///< straight legs to uniform waypoints, optional pause
    GaussMarkov,     ///< correlated speed and heading, 1 s steps, optionally 3-D
    Manhattan,       ///< street grid: straight 0.5, left/right 0.25 at each corner
    Orbit,           ///< circular orbit around the field's centre (satellites)
};

/// A node's mobility model and its parameters.
struct Mobility {
    MobilityKind kind = MobilityKind::Static;  ///< which model
    double speedMin = 1;      ///< RWP / Manhattan: leg speed lower bound (m/s)
    double speedMax = 10;     ///< RWP / Manhattan: leg speed upper bound (m/s)
    double pause = 0;         ///< RWP: pause at each waypoint (s)
    double gmMeanSpeed = 10;  ///< Gauss-Markov: mean speed (m/s)
    double gmAlpha = 0.85;    ///< Gauss-Markov: memory (0 = random walk, 1 = straight line)
    bool threeD = false;      ///< Gauss-Markov: also move in z
    double orbitRadius = 0;   ///< Orbit: distance from the field's centre (m)
    double orbitInc = 0;      ///< Orbit: inclination (rad)
    double orbitRaan = 0;     ///< Orbit: right ascension of the ascending node (rad)
    double orbitPhase = 0;    ///< Orbit: argument of latitude at t = 0 (rad)
    double orbitRate = 0;     ///< Orbit: angular speed (rad/s)
};

/// sin / cos from arithmetic only (range reduction + Taylor series), so the
/// native and WASM builds compute bit-identical orbits: libm's transcendental
/// functions are not guaranteed to round the same on both.
double detSin(double x);
double detCos(double x);

/// Where an Orbit puts a node at time t (centre = the field's centre, z = 0).
Vec3 orbitPosition(const Mobility& m, const Vec3& centre, double t);

/// Which link rule the teaching radio uses.
enum class ChannelKind {
    Disk,   ///< linked iff within range()
    Urban,  ///< within range() and no building on the line of sight
    Isl,    ///< linked iff an inter-satellite link was added (and not cut)
};

/// Event kinds of the log the front end animates and the parity test diffs.
/// Append only: the JS front end and the trace format index these numerically.
enum class Ev : int {
    TxAnt = 1,       ///< node -> peer (-1 = broadcast); a=AntType, b=dir, v=arrival time
    RxAnt = 2,       ///< node received from peer; a=AntType, b=dir
    TxData = 3,      ///< node -> peer; a=flow, b=seq, v=arrival time
    Deliver = 4,     ///< node = destination; a=flow, b=seq, v=end-to-end delay
    Drop = 5,        ///< node; a=flow, b=seq, peer=DropReason
    RouteAdd = 6,    ///< node; peer=next hop, a=destination
    RouteDel = 7,    ///< node; peer=next hop, a=destination
    Queue = 8,       ///< node; a=flow, b=seq, peer=destination
    TxFail = 9,      ///< node -> peer unicast failed (out of range)
    NodeDown = 10,   ///< node switched off
    NodeUp = 11,     ///< node switched on
};

/// Why a data packet was lost (the `peer` field of an Ev::Drop event).
enum class DropReason : int {
    Ttl = 1,            ///< hop limit reached (a loop)
    QueueTimeout = 2,   ///< waited QueueTimeout (3 s) for a route, or queue full
    HoldCap = 3,        ///< a reconvergence hold outlived ReconvHoldCap (200 ms)
    RepairDiscard = 4,  ///< a local repair expired: the core's DiscardPending
    NodeOff = 5,        ///< the holding or receiving node was switched off
};

/// One entry of the event log (see Ev for what each field means per kind).
struct LogEvent {
    double t;   ///< simulated time (s)
    Ev kind;    ///< what happened
    int node;   ///< where it happened
    int peer;   ///< the other node, -1 for broadcast, or a DropReason
    int a;      ///< kind-specific (AntType, flow, destination)
    int b;      ///< kind-specific (AntDirection, sequence number)
    double v;   ///< kind-specific (arrival time, end-to-end delay)
};

/// A constant-bit-rate data flow and its running totals.
struct Flow {
    int src;             ///< source node
    int dst;             ///< destination node
    double rate;         ///< packets per second
    double start;        ///< first packet (s)
    double stop;         ///< no packets after this (s)
    int sent = 0;        ///< packets originated
    int delivered = 0;   ///< packets that reached dst
    double delaySum = 0; ///< sum of end-to-end delays of delivered packets (s)
};

class World;

/// One AntHocNet node: the core logic plus the adapter state around it.
class Node : public anthocnet::core::IClock,
             public anthocnet::core::IRng,
             public anthocnet::core::IRouterObserver {
public:
    /// Created by World::addNode(); `seed` derives the node's streams.
    Node(World& w, int id, std::uint64_t seed);

    /// IClock: the world's simulated time.
    anthocnet::core::Time now() const override;
    /// IRng: this node's own stream (independent of every other node's).
    double uniform() override { return rng_.uniform(); }
    /// IRng: uniform integer in [0, n).
    int uniformInt(int n) override { return rng_.uniformInt(n); }

    /// IRouterObserver: report-only -- route changes feed the event log.
    void onRouteChanged(NodeAddress dest, NodeAddress nb, bool added) override;

    /// This node's address (its index in the World).
    int id() const { return id_; }
    /// The core state machine (valid after World::start()).
    anthocnet::core::AntRouterLogic& logic() { return *logic_; }
    /// The core state machine, read-only (inspection).
    const anthocnet::core::AntRouterLogic& logic() const { return *logic_; }

private:
    friend class World;
    /// A data packet, in flight or held in the pending queue.
    struct Pending {
        int flow, seq, src, dst, ttl, hops;
        NodeAddress prev;  ///< previous hop (A1 loop exclusion; re-injection)
        double created, firstQueued, expire;
        bool reconv;       ///< held while a known route re-forms (#21 HOLD_RECONV)
    };

    World& w_;
    int id_;
    SplitMix64 rng_;       ///< the core's IRng
    SplitMix64 timerRng_;  ///< adapter timer jitter (as ns-3's m_timerRng)
    // Mobility is generated lazily but from a per-node stream, so a node's
    // trajectory never depends on when (or whether) another node was queried.
    mutable SplitMix64 mobRng_;
    mutable double gmSpeed_ = 0;
    mutable Vec3 gmDir_{1, 0, 0};
    mutable int mhDir_ = 0;
    mutable bool rwpPaused_ = false;
    std::unique_ptr<anthocnet::core::AntRouterLogic> logic_;
    bool up_ = true;
    double busyUntil_ = 0;  ///< FIFO transmitter
    std::deque<Pending> pending_;
    std::set<NodeAddress> everRouted_;
    Mobility mob_;
    mutable std::vector<Leg> legs_;
};

/// The whole simulation: nodes, radio, mobility, traffic and the event queue.
class World {
public:
    /// An empty world; `seed` derives every random stream in it.
    explicit World(std::uint64_t seed);

    // --- scenario construction (before start()) ---------------------------
    /// Field size in metres (z > 0 enables altitude).
    void setArea(double x, double y, double z);
    /// Unit-disk links of radius `range` metres.
    void setDiskChannel(double range);
    /// Unit disk cut by the buildings of a blocksX x blocksY street grid.
    void setUrbanChannel(double range, int blocksX, int blocksY, double streetWidth);
    /// Links only where addIslLink() says, delay tracking distance.
    void setIslChannel();
    /// Add an inter-satellite link (ChannelKind::Isl).
    void addIslLink(int a, int b);
    /// Transmitter bit rate (default 2 Mbit/s).
    void setBitrate(double bps) { bitrate_ = bps; }
    /// Independent per-reception loss probability (default 0).
    void setLossProbability(double p) { loss_ = p; }
    /// Add a node at (x, y, z); returns its address.
    int addNode(double x, double y, double z);
    /// Give `node` a mobility model (Manhattan snaps it to an intersection).
    void setMobility(int node, const Mobility& m);
    /// Add a CBR flow; returns its index.
    int addFlow(int src, int dst, double rate, double start, double stop);
    /// The protocol Config every node is built with -- the core defaults.
    /// Worlds never change it (ADR-0019); a mission's labelled knob may.
    anthocnet::core::Config& config() { return config_; }

    /// Build the nodes' core logic and arm their timers and the flows.
    void start();

    // --- running ----------------------------------------------------------
    /// Process every event up to simulated time `t` (starts if needed).
    void advanceTo(double t);
    /// Current simulated time (s).
    double now() const { return now_; }
    /// The seed this world was built from.
    std::uint64_t seed() const { return seed_; }

    // --- interaction (any time) -------------------------------------------
    /// Drag `node` to (x, y, z) and pin it there (it stops moving).
    void moveNode(int node, double x, double y, double z);
    /// Switch `node` off (its held packets are dropped) or back on.
    void setNodeUp(int node, bool up);
    /// Remove an inter-satellite link.
    void cutIslLink(int a, int b);

    // --- inspection (read-only) -------------------------------------------
    /// Number of nodes.
    int nodeCount() const { return static_cast<int>(nodes_.size()); }
    /// Where `node` is now.
    Vec3 position(int node) const { return positionAt(node, now_); }
    /// Whether `node` is switched on.
    bool nodeUp(int node) const { return nodes_[node]->up_; }
    /// Whether a and b can hear each other now.
    bool linkUp(int a, int b) const { return linkUpAt(a, b, now_); }
    /// Node `i` (for read-only inspection of its core state).
    const Node& node(int i) const { return *nodes_[i]; }
    /// The flows and their running totals.
    const std::vector<Flow>& flows() const { return flows_; }
    /// Data packets `node` holds waiting for a route.
    int pendingCount(int node) const { return static_cast<int>(nodes_[node]->pending_.size()); }
    /// Events since the last clearLog().
    const std::vector<LogEvent>& log() const { return log_; }
    /// Forget the logged events (the front end drains them every frame).
    void clearLog() { log_.clear(); }
    /// Ant transmissions so far (control overhead).
    std::uint64_t antTransmissions() const { return antTx_; }
    /// Street grid blocks along x (Urban).
    int urbanBlocksX() const { return blocksX_; }
    /// Street grid blocks along y (Urban).
    int urbanBlocksY() const { return blocksY_; }
    /// Street width in metres (Urban).
    double streetWidth() const { return streetWidth_; }
    /// Radio range in metres (Disk, Urban).
    double range() const { return range_; }
    /// The link rule in use.
    ChannelKind channel() const { return channel_; }
    /// Field size in metres.
    Vec3 area() const { return area_; }

    /// One trace line per logged event (the parity format).
    static std::string formatEvent(const LogEvent& e);

private:
    friend class Node;
    struct Scheduled {
        double t;
        std::uint64_t seq;
        std::function<void()> fn;
    };
    struct Later {
        bool operator()(const Scheduled& a, const Scheduled& b) const {
            return a.t > b.t || (a.t == b.t && a.seq > b.seq);
        }
    };

    void schedule(double t, std::function<void()> fn);
    void emit(double t, Ev kind, int node, int peer, int a, int b, double v);

    // mobility
    void extendLegs(Node& n, double until) const;
    void armTimers(Node& n);
    Vec3 positionAt(int node, double t) const;
    bool linkUpAt(int a, int b, double t) const;
    bool lineOfSight(const Vec3& a, const Vec3& b) const;

    // timers
    void helloTimer(int node);
    void proactiveTimer(int node);
    void retryTimer(int node);
    void flowTick(int flow);
    double jittered(Node& n, double base, bool first);

    // the adapter contract
    void execute(Node& n, const std::vector<anthocnet::core::RouteDecision>& ds);
    void sendAnt(Node& n, const anthocnet::core::AntMessage& m, int to);
    void recvAnt(int node, int from, const std::vector<std::uint8_t>& bytes);
    void routeData(Node& n, Node::Pending p, int prevHop);
    void sendData(Node& n, Node::Pending p, int next);
    void recvData(int node, int from, Node::Pending p);
    void enqueue(Node& n, Node::Pending p);
    void flushQueue(Node& n, NodeAddress dst);
    void discardQueue(Node& n, NodeAddress dst, DropReason why);
    void purge(Node& n);
    double txDuration(std::size_t bytes) const { return bytes * 8.0 / bitrate_; }
    double propagation(int a, int b, double t) const;

    SplitMix64 lossRng_;     ///< channel loss draws only
    std::uint64_t seed_;
    anthocnet::core::Config config_;
    Vec3 area_{1000, 1000, 0};
    ChannelKind channel_ = ChannelKind::Disk;
    double range_ = 250;
    int blocksX_ = 4, blocksY_ = 4;
    double streetWidth_ = 20;
    std::set<std::pair<int, int>> isl_;
    double bitrate_ = 2e6;
    double loss_ = 0;
    std::vector<std::unique_ptr<Node>> nodes_;
    std::vector<Flow> flows_;
    std::priority_queue<Scheduled, std::vector<Scheduled>, Later> events_;
    std::uint64_t seq_ = 0;
    double now_ = 0;
    bool started_ = false;
    std::vector<LogEvent> log_;
    std::uint64_t antTx_ = 0;

    // adapter constants: the ns-3 attribute defaults (anthocnet-routing-protocol.cc)
    static constexpr double kTimerJitter = 0.05;      // TimerJitter
    static constexpr double kQueueTimeout = 3.0;      // QueueTimeout
    static constexpr double kReconvHoldCap = 0.2;     // ReconvHoldCap
    static constexpr double kRetryInterval = 0.25;    // ReactiveRetryInterval
    static constexpr std::size_t kQueueLen = 64;      // RequestQueue maxLen
    static constexpr int kTtl = 64;
    static constexpr std::size_t kDataBytes = 64 + 28;  // payload + IP/UDP
    static constexpr int kMacRetries = 7;             // failure known after 7 tries
};

}  // namespace ahn_web

#endif  // AHN_WEB_SIM_H
