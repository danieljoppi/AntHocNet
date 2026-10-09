// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

#include "ahn_web/sim.h"

#include <algorithm>
#include <cmath>
#include <cstdio>
#include <limits>

#include "anthocnet/core/ant_message_codec.h"

namespace ahn_web {

namespace core = anthocnet::core;
using core::AntMessage;
using core::RouteAction;
using core::RouteDecision;
using core::kInvalidAddress;

namespace {

constexpr double kForever = 1e18;
constexpr double kLightSpeed = 299792458.0;

constexpr double kPi = 3.141592653589793;

std::uint64_t mixSeed(std::uint64_t seed, std::uint64_t node, std::uint64_t stream) {
    SplitMix64 m(seed ^ (node * 0x9E3779B97F4A7C15ULL) ^ (stream * 0xD1B54A32D192ED03ULL));
    m.next();
    return m.next();
}

double dist(const Vec3& a, const Vec3& b) {
    const double dx = a.x - b.x, dy = a.y - b.y, dz = a.z - b.z;
    return std::sqrt(dx * dx + dy * dy + dz * dz);  // sqrt is exactly rounded everywhere
}

/// Approximate standard normal with arithmetic only (Irwin-Hall, n = 12):
/// no libm transcendental, so native and WASM draw identical values.
double normal(SplitMix64& r) {
    double s = 0;
    for (int i = 0; i < 12; ++i) s += r.uniform();
    return s - 6.0;
}

}  // namespace

// --- SplitMix64 ---------------------------------------------------------------

std::uint64_t SplitMix64::next() {
    std::uint64_t z = (state_ += 0x9E3779B97F4A7C15ULL);
    z = (z ^ (z >> 30)) * 0xBF58476D1CE4E5B9ULL;
    z = (z ^ (z >> 27)) * 0x94D049BB133111EBULL;
    return z ^ (z >> 31);
}

double SplitMix64::uniform() {
    return static_cast<double>(next() >> 11) * (1.0 / 9007199254740992.0);
}

int SplitMix64::uniformInt(int n) {
    if (n <= 0) return 0;
    const int v = static_cast<int>(uniform() * n);
    return v < n ? v : n - 1;
}

// --- Node ---------------------------------------------------------------------

Node::Node(World& w, int id, std::uint64_t seed)
    : w_(w), id_(id), rng_(mixSeed(seed, id, 1)), timerRng_(mixSeed(seed, id, 2)),
      mobRng_(mixSeed(seed, id, 3)) {}

core::Time Node::now() const { return w_.now_; }

void Node::onRouteChanged(NodeAddress dest, NodeAddress nb, bool added) {
    w_.emit(w_.now_, added ? Ev::RouteAdd : Ev::RouteDel, id_, nb, dest, 0, 0);
}

// --- World: construction -------------------------------------------------------

World::World(std::uint64_t seed) : lossRng_(mixSeed(seed, 0, 4)), seed_(seed) {}

void World::setArea(double x, double y, double z) { area_ = Vec3{x, y, z}; }

void World::setDiskChannel(double range) {
    channel_ = ChannelKind::Disk;
    range_ = range;
}

void World::setUrbanChannel(double range, int blocksX, int blocksY, double streetWidth) {
    channel_ = ChannelKind::Urban;
    range_ = range;
    blocksX_ = blocksX;
    blocksY_ = blocksY;
    streetWidth_ = streetWidth;
}

void World::setIslChannel() { channel_ = ChannelKind::Isl; }

void World::addIslLink(int a, int b) { isl_.insert({std::min(a, b), std::max(a, b)}); }

void World::cutIslLink(int a, int b) { isl_.erase({std::min(a, b), std::max(a, b)}); }

int World::addNode(double x, double y, double z) {
    const int id = static_cast<int>(nodes_.size());
    nodes_.emplace_back(new Node(*this, id, seed_));
    Node& n = *nodes_.back();
    n.legs_.push_back(Leg{0, kForever, Vec3{x, y, z}, Vec3{x, y, z}});
    if (started_) {
        n.logic_.reset(new core::AntRouterLogic(id, config_, n, n));
        n.logic_->setObserver(&n);
        armTimers(n);
    }
    return id;
}

void World::setMobility(int node, const Mobility& m) {
    Node& n = *nodes_[node];
    n.mob_ = m;
    Vec3 p = n.legs_.front().p0;
    if (m.kind == MobilityKind::Manhattan) {
        // Snap to the nearest intersection of the street grid.
        const double bw = area_.x / blocksX_, bh = area_.y / blocksY_;
        p.x = std::round(p.x / bw) * bw;
        p.y = std::round(p.y / bh) * bh;
        p.z = 0;
    }
    if (m.kind == MobilityKind::Orbit) p = orbitPosition(m, Vec3{area_.x / 2, area_.y / 2, 0}, 0);
    n.legs_.assign(1, Leg{0, 0, p, p});
    n.gmSpeed_ = m.gmMeanSpeed;
    n.gmDir_ = Vec3{1, 0, 0};
    n.mhDir_ = n.mobRng_.uniformInt(4);
}

int World::addFlow(int src, int dst, double rate, double start, double stop) {
    Flow f;
    f.src = src;
    f.dst = dst;
    f.rate = rate;
    f.start = start;
    f.stop = stop;
    flows_.push_back(f);
    const int id = static_cast<int>(flows_.size()) - 1;
    if (started_) schedule(std::max(start, now_), [this, id] { flowTick(id); });
    return id;
}

void World::start() {
    if (started_) return;
    started_ = true;
    for (auto& np : nodes_) {
        Node& n = *np;
        n.logic_.reset(new core::AntRouterLogic(n.id_, config_, n, n));
        n.logic_->setObserver(&n);
        armTimers(n);
    }
    for (std::size_t f = 0; f < flows_.size(); ++f) {
        const int id = static_cast<int>(f);
        schedule(flows_[f].start, [this, id] { flowTick(id); });
    }
}

void World::armTimers(Node& n) {
    // #496: desynchronised first firings, as the ns-3 adapter does.
    const int id = n.id_;
    schedule(now_ + jittered(n, config_.helloInterval, true), [this, id] { helloTimer(id); });
    schedule(now_ + jittered(n, config_.proactiveInterval, true),
             [this, id] { proactiveTimer(id); });
    schedule(now_ + kRetryInterval, [this, id] { retryTimer(id); });
}

// --- event queue + log ------------------------------------------------------------

void World::schedule(double t, std::function<void()> fn) {
    events_.push(Scheduled{t, seq_++, std::move(fn)});
}

void World::emit(double t, Ev kind, int node, int peer, int a, int b, double v) {
    log_.push_back(LogEvent{t, kind, node, peer, a, b, v});
    if (kind == Ev::TxAnt) ++antTx_;
}

void World::advanceTo(double t) {
    if (!started_) start();
    while (!events_.empty() && events_.top().t <= t) {
        Scheduled s = events_.top();
        events_.pop();
        now_ = s.t;
        s.fn();
    }
    if (t > now_) now_ = t;
}

std::string World::formatEvent(const LogEvent& e) {
    char buf[160];
    std::snprintf(buf, sizeof buf, "%.9f %d %d %d %d %d %.9g", e.t, static_cast<int>(e.kind),
                  e.node, e.peer, e.a, e.b, e.v);
    return buf;
}

// --- mobility ----------------------------------------------------------------------

double detSin(double x) {
    // Reduce to [-pi, pi], fold to [-pi/2, pi/2], then the Taylor series to
    // x^19 (error < 1e-15 there). floor, +, -, *, / are exact-rounded IEEE.
    x -= 2 * kPi * std::floor(x / (2 * kPi) + 0.5);
    if (x > kPi / 2) x = kPi - x;
    else if (x < -kPi / 2) x = -kPi - x;
    const double x2 = x * x;
    double term = x, sum = x;
    for (int k = 1; k <= 9; ++k) {
        term *= -x2 / ((2.0 * k) * (2.0 * k + 1));
        sum += term;
    }
    return sum;
}

double detCos(double x) { return detSin(x + kPi / 2); }

Vec3 orbitPosition(const Mobility& m, const Vec3& c, double t) {
    const double u = m.orbitPhase + m.orbitRate * t;
    const double x = m.orbitRadius * detCos(u), y0 = m.orbitRadius * detSin(u);
    const double y = y0 * detCos(m.orbitInc), z = y0 * detSin(m.orbitInc);
    const double cr = detCos(m.orbitRaan), sr = detSin(m.orbitRaan);
    return Vec3{c.x + x * cr - y * sr, c.y + x * sr + y * cr, c.z + z};
}

void World::extendLegs(Node& n, double until) const {
    while (n.legs_.back().t1 < until) {
        const Leg& last = n.legs_.back();
        const double t0 = last.t1;
        const Vec3 p = last.p1;
        SplitMix64& r = n.mobRng_;
        switch (n.mob_.kind) {
            case MobilityKind::Static:
                n.legs_.push_back(Leg{t0, kForever, p, p});
                break;
            case MobilityKind::RandomWaypoint: {
                if (n.mob_.pause > 0 && !n.rwpPaused_) {
                    n.rwpPaused_ = true;
                    n.legs_.push_back(Leg{t0, t0 + n.mob_.pause, p, p});
                    break;
                }
                n.rwpPaused_ = false;
                Vec3 q{r.uniform() * area_.x, r.uniform() * area_.y,
                       area_.z > 0 ? r.uniform() * area_.z : 0.0};
                const double v = r.uniform(n.mob_.speedMin, n.mob_.speedMax);
                const double d = dist(p, q);
                n.legs_.push_back(Leg{t0, t0 + (v > 0 ? d / v : kForever), p, q});
                break;
            }
            case MobilityKind::GaussMarkov: {
                // One-second steps: speed and heading follow the Gauss-Markov
                // recursion; the heading is a vector renormalised with sqrt only.
                const double a = n.mob_.gmAlpha;
                const double s1 = std::sqrt(1 - a * a);
                n.gmSpeed_ = a * n.gmSpeed_ + (1 - a) * n.mob_.gmMeanSpeed +
                             s1 * 0.25 * n.mob_.gmMeanSpeed * normal(r);
                if (n.gmSpeed_ < 0) n.gmSpeed_ = 0;
                Vec3 d = n.gmDir_;
                d.x += s1 * 0.6 * normal(r);
                d.y += s1 * 0.6 * normal(r);
                d.z = n.mob_.threeD ? d.z + s1 * 0.3 * normal(r) : 0.0;
                double len = std::sqrt(d.x * d.x + d.y * d.y + d.z * d.z);
                if (len == 0) len = 1, d = Vec3{1, 0, 0};
                d = Vec3{d.x / len, d.y / len, d.z / len};
                Vec3 q{p.x + d.x * n.gmSpeed_, p.y + d.y * n.gmSpeed_, p.z + d.z * n.gmSpeed_};
                // Reflect off the field's walls.
                if (q.x < 0) q.x = -q.x, d.x = -d.x;
                if (q.x > area_.x) q.x = 2 * area_.x - q.x, d.x = -d.x;
                if (q.y < 0) q.y = -q.y, d.y = -d.y;
                if (q.y > area_.y) q.y = 2 * area_.y - q.y, d.y = -d.y;
                const double zmax = area_.z > 0 ? area_.z : 0.0;
                if (q.z < 0) q.z = -q.z, d.z = -d.z;
                if (q.z > zmax) q.z = 2 * zmax - q.z, d.z = -d.z;
                n.gmDir_ = d;
                n.legs_.push_back(Leg{t0, t0 + 1.0, p, q});
                break;
            }
            case MobilityKind::Orbit: {
                // Chords of the circle, 0.25 s each: at the teaching orbit's
                // ~3 deg/s the chord sags < 1 km below the arc.
                const Vec3 c{area_.x / 2, area_.y / 2, 0};
                n.legs_.push_back(Leg{t0, t0 + 0.25, p, orbitPosition(n.mob_, c, t0 + 0.25)});
                break;
            }
            case MobilityKind::Manhattan: {
                // Drive to an adjacent intersection: straight 0.5, left/right 0.25
                // each (the harness's turn probabilities); U-turn only at a dead end.
                static const int dx[4] = {1, 0, -1, 0}, dy[4] = {0, 1, 0, -1};
                const double bw = area_.x / blocksX_, bh = area_.y / blocksY_;
                const int ix = static_cast<int>(std::round(p.x / bw));
                const int iy = static_cast<int>(std::round(p.y / bh));
                auto ok = [&](int dir) {
                    const int nx = ix + dx[dir], ny = iy + dy[dir];
                    return nx >= 0 && nx <= blocksX_ && ny >= 0 && ny <= blocksY_;
                };
                const double u = r.uniform();
                int want = u < 0.5 ? n.mhDir_ : (u < 0.75 ? (n.mhDir_ + 1) % 4 : (n.mhDir_ + 3) % 4);
                const int order[4] = {want, (n.mhDir_ + 1) % 4, (n.mhDir_ + 3) % 4,
                                      (n.mhDir_ + 2) % 4};
                int dir = n.mhDir_;
                for (int k = 0; k < 4; ++k) {
                    if (ok(order[k])) {
                        dir = order[k];
                        break;
                    }
                }
                n.mhDir_ = dir;
                const Vec3 q{(ix + dx[dir]) * bw, (iy + dy[dir]) * bh, 0};
                const double v = r.uniform(n.mob_.speedMin, n.mob_.speedMax);
                n.legs_.push_back(Leg{t0, t0 + dist(p, q) / v, p, q});
                break;
            }
        }
    }
}

Vec3 World::positionAt(int node, double t) const {
    Node& n = *nodes_[node];
    extendLegs(n, t);
    // Legs are contiguous and sorted; find the one covering t.
    auto it = std::upper_bound(n.legs_.begin(), n.legs_.end(), t,
                               [](double tt, const Leg& l) { return tt < l.t1; });
    if (it == n.legs_.end()) it = n.legs_.end() - 1;
    const Leg& l = *it;
    if (l.t1 >= kForever || l.t1 <= l.t0) return l.p0;
    const double f = (t - l.t0) / (l.t1 - l.t0);
    return Vec3{l.p0.x + (l.p1.x - l.p0.x) * f, l.p0.y + (l.p1.y - l.p0.y) * f,
                l.p0.z + (l.p1.z - l.p0.z) * f};
}

void World::moveNode(int node, double x, double y, double z) {
    Node& n = *nodes_[node];
    n.mob_ = Mobility{};
    const Vec3 p{x, y, z};
    // Keep the past (in-flight events may still read it); pin from now on.
    extendLegs(n, now_);
    auto it = std::upper_bound(n.legs_.begin(), n.legs_.end(), now_,
                               [](double tt, const Leg& l) { return tt < l.t1; });
    if (it != n.legs_.end()) {
        n.legs_.erase(it + 1, n.legs_.end());
        Leg& cur = n.legs_.back();
        cur.p1 = positionAt(node, now_);
        cur.t1 = now_;
    }
    n.legs_.push_back(Leg{now_, kForever, p, p});
}

// --- radio ---------------------------------------------------------------------------

bool World::lineOfSight(const Vec3& a, const Vec3& b) const {
    // Buildings fill each block except a street of streetWidth around it:
    // block (i, j) holds the rectangle [i*bw + w/2, (i+1)*bw - w/2] x [...].
    const double bw = area_.x / blocksX_, bh = area_.y / blocksY_, h = streetWidth_ / 2;
    for (int i = 0; i < blocksX_; ++i) {
        for (int j = 0; j < blocksY_; ++j) {
            const double x0 = i * bw + h, x1 = (i + 1) * bw - h;
            const double y0 = j * bh + h, y1 = (j + 1) * bh - h;
            if (x1 <= x0 || y1 <= y0) continue;
            // Liang-Barsky clip of segment a->b against the rectangle.
            double t0 = 0, t1 = 1;
            const double ddx = b.x - a.x, ddy = b.y - a.y;
            const double p[4] = {-ddx, ddx, -ddy, ddy};
            const double q[4] = {a.x - x0, x1 - a.x, a.y - y0, y1 - a.y};
            bool inside = true;
            for (int k = 0; k < 4 && inside; ++k) {
                if (p[k] == 0) {
                    if (q[k] < 0) inside = false;
                } else {
                    const double r = q[k] / p[k];
                    if (p[k] < 0) {
                        if (r > t1) inside = false;
                        else if (r > t0) t0 = r;
                    } else {
                        if (r < t0) inside = false;
                        else if (r < t1) t1 = r;
                    }
                }
            }
            if (inside && t1 - t0 > 1e-9) return false;
        }
    }
    return true;
}

bool World::linkUpAt(int a, int b, double t) const {
    if (a == b || !nodes_[a]->up_ || !nodes_[b]->up_) return false;
    if (channel_ == ChannelKind::Isl) return isl_.count({std::min(a, b), std::max(a, b)}) > 0;
    const Vec3 pa = positionAt(a, t), pb = positionAt(b, t);
    if (dist(pa, pb) > range_) return false;
    return channel_ != ChannelKind::Urban || lineOfSight(pa, pb);
}

double World::propagation(int a, int b, double t) const {
    if (channel_ != ChannelKind::Isl) return 0;
    return dist(positionAt(a, t), positionAt(b, t)) / kLightSpeed;
}

double World::jittered(Node& n, double base, bool first) {
    const double scale = first ? n.timerRng_.uniform()
                               : n.timerRng_.uniform(1 - kTimerJitter, 1 + kTimerJitter);
    return base * scale;
}

// --- the adapter contract --------------------------------------------------------------

void World::execute(Node& n, const std::vector<RouteDecision>& ds) {
    for (const RouteDecision& d : ds) {
        switch (d.action) {
            case RouteAction::Unicast:
                sendAnt(n, d.message, d.nextHop);
                break;
            case RouteAction::Broadcast:
                sendAnt(n, d.message, -1);
                break;
            case RouteAction::DiscardPending:
                discardQueue(n, d.nextHop, DropReason::RepairDiscard);
                break;
            case RouteAction::Deliver:
            case RouteAction::Queue:
            case RouteAction::Drop:
            case RouteAction::None:
                break;
        }
    }
}

void World::sendAnt(Node& n, const AntMessage& m, int to) {
    if (!n.up_) return;
    std::vector<std::uint8_t> bytes = core::codec::serialize(m);
    const double start = std::max(now_, n.busyUntil_);
    const double dur = txDuration(bytes.size() + 28);
    n.busyUntil_ = start + dur;
    const int from = n.id_;
    const int type = static_cast<int>(m.type), dir = static_cast<int>(m.direction);
    if (to < 0) {
        emit(now_, Ev::TxAnt, from, -1, type, dir, start + dur);
        for (int j = 0; j < nodeCount(); ++j) {
            if (!linkUpAt(from, j, start)) continue;
            if (loss_ > 0 && lossRng_.uniform() < loss_) continue;
            const double at = start + dur + propagation(from, j, start);
            schedule(at, [this, j, from, bytes] { recvAnt(j, from, bytes); });
        }
        return;
    }
    if (linkUpAt(from, to, start) && !(loss_ > 0 && lossRng_.uniform() < loss_)) {
        const double at = start + dur + propagation(from, to, start);
        emit(now_, Ev::TxAnt, from, to, type, dir, at);
        schedule(at, [this, to, from, bytes] { recvAnt(to, from, bytes); });
        return;
    }
    // Unicast to a receiver out of reach: the MAC retries, then reports
    // failure (ADR-0008 detector D); the ant is lost.
    const double failAt = start + kMacRetries * dur;
    n.busyUntil_ = failAt;
    emit(now_, Ev::TxAnt, from, to, type, dir, failAt);
    schedule(failAt, [this, from, to] {
        Node& me = *nodes_[from];
        if (!me.up_) return;
        emit(now_, Ev::TxFail, from, to, 0, 0, 0);
        execute(me, me.logic_->reportTxFailure(to));
    });
}

void World::recvAnt(int node, int from, const std::vector<std::uint8_t>& bytes) {
    Node& n = *nodes_[node];
    if (!n.up_) return;
    AntMessage m;
    if (!core::codec::deserialize(bytes, m)) return;
    emit(now_, Ev::RxAnt, node, from, static_cast<int>(m.type), static_cast<int>(m.direction), 0);
    const std::vector<RouteDecision> ds = n.logic_->onReceiveAnt(m, from);
    // As the ns-3 adapter: a Deliver (route to m.src found) or any backward ant
    // through this node can release data held for m.src.
    bool flushed = false;
    for (const RouteDecision& d : ds) {
        if (d.action == RouteAction::Deliver) {
            flushQueue(n, m.src);
            flushed = true;
            break;
        }
    }
    if (!flushed && m.isBackward()) flushQueue(n, m.src);
    execute(n, ds);
}

void World::flowTick(int f) {
    Flow& fl = flows_[f];
    if (now_ > fl.stop) return;
    Node& src = *nodes_[fl.src];
    Node::Pending p{f, fl.sent++, fl.src, fl.dst, kTtl, 0, kInvalidAddress, now_, 0, 0, false};
    if (src.up_) {
        src.logic_->noteDataSession(fl.dst);
        routeData(src, p, kInvalidAddress);
    } else {
        emit(now_, Ev::Drop, fl.src, static_cast<int>(DropReason::NodeOff), f, p.seq, 0);
    }
    schedule(now_ + 1.0 / fl.rate, [this, f] { flowTick(f); });
}

void World::routeData(Node& n, Node::Pending p, int prevHop) {
    p.prev = prevHop;
    const NodeAddress next = n.logic_->nextHopForData(p.dst, prevHop);
    if (next != kInvalidAddress) {
        n.everRouted_.insert(p.dst);
        sendData(n, p, next);
        return;
    }
    p.reconv = n.everRouted_.count(p.dst) > 0;
    enqueue(n, p);
    execute(n, n.logic_->onDataPacket(p.dst));
}

void World::sendData(Node& n, Node::Pending p, int next) {
    if (--p.ttl <= 0) {
        emit(now_, Ev::Drop, n.id_, static_cast<int>(DropReason::Ttl), p.flow, p.seq, 0);
        return;
    }
    const double start = std::max(now_, n.busyUntil_);
    const double dur = txDuration(kDataBytes);
    n.busyUntil_ = start + dur;
    const int from = n.id_;
    if (linkUpAt(from, next, start) && !(loss_ > 0 && lossRng_.uniform() < loss_)) {
        const double at = start + dur + propagation(from, next, start);
        emit(now_, Ev::TxData, from, next, p.flow, p.seq, at);
        p.hops += 1;
        schedule(at, [this, next, from, p] { recvData(next, from, p); });
        return;
    }
    const double failAt = start + kMacRetries * dur;
    n.busyUntil_ = failAt;
    emit(now_, Ev::TxData, from, next, p.flow, p.seq, failAt);
    schedule(failAt, [this, from, next, p] {
        Node& me = *nodes_[from];
        if (!me.up_) {
            emit(now_, Ev::Drop, from, static_cast<int>(DropReason::NodeOff), p.flow, p.seq, 0);
            return;
        }
        emit(now_, Ev::TxFail, from, next, p.flow, p.seq, 0);
        execute(me, me.logic_->reportTxFailure(next, p.dst));
        routeData(me, p, p.prev);  // re-inject at this hop (issue #46)
    });
}

void World::recvData(int node, int from, Node::Pending p) {
    Node& n = *nodes_[node];
    if (!n.up_) {
        emit(now_, Ev::Drop, node, static_cast<int>(DropReason::NodeOff), p.flow, p.seq, 0);
        return;
    }
    if (p.dst == node) {
        Flow& f = flows_[p.flow];
        f.delivered += 1;
        f.delaySum += now_ - p.created;
        emit(now_, Ev::Deliver, node, from, p.flow, p.seq, now_ - p.created);
        return;
    }
    routeData(n, p, from);
}

void World::enqueue(Node& n, Node::Pending p) {
    purge(n);
    if (p.firstQueued == 0) p.firstQueued = now_;
    p.expire = now_ + kQueueTimeout;
    if (p.reconv && p.firstQueued + kReconvHoldCap < p.expire) p.expire = p.firstQueued + kReconvHoldCap;
    if (n.pending_.size() >= kQueueLen) {
        const Node::Pending old = n.pending_.front();
        n.pending_.pop_front();
        emit(now_, Ev::Drop, n.id_, static_cast<int>(DropReason::QueueTimeout), old.flow, old.seq, 0);
    }
    n.pending_.push_back(p);
    emit(now_, Ev::Queue, n.id_, p.dst, p.flow, p.seq, 0);
    const int id = n.id_;
    schedule(p.expire, [this, id] { purge(*nodes_[id]); });
}

void World::purge(Node& n) {
    std::deque<Node::Pending> kept;
    for (const Node::Pending& p : n.pending_) {
        if (p.expire > now_) {
            kept.push_back(p);
        } else {
            const DropReason why = p.reconv ? DropReason::HoldCap : DropReason::QueueTimeout;
            emit(now_, Ev::Drop, n.id_, static_cast<int>(why), p.flow, p.seq, 0);
        }
    }
    n.pending_.swap(kept);
}

void World::flushQueue(Node& n, NodeAddress dst) {
    purge(n);
    std::vector<Node::Pending> mine;
    std::deque<Node::Pending> kept;
    for (const Node::Pending& p : n.pending_) (p.dst == dst ? mine.push_back(p) : kept.push_back(p));
    n.pending_.swap(kept);
    for (Node::Pending& p : mine) {
        const NodeAddress next = n.logic_->nextHopForData(dst);
        if (next == kInvalidAddress) {
            enqueue(n, p);
            continue;
        }
        n.everRouted_.insert(dst);
        sendData(n, p, next);
    }
}

void World::discardQueue(Node& n, NodeAddress dst, DropReason why) {
    std::deque<Node::Pending> kept;
    for (const Node::Pending& p : n.pending_) {
        if (p.dst == dst) {
            emit(now_, Ev::Drop, n.id_, static_cast<int>(why), p.flow, p.seq, 0);
        } else {
            kept.push_back(p);
        }
    }
    n.pending_.swap(kept);
}

// --- timers ----------------------------------------------------------------------------

void World::helloTimer(int id) {
    Node& n = *nodes_[id];
    if (n.up_) {
        // Liveness tick first (ADR-0008 detector A), then beacon.
        execute(n, n.logic_->onMaintenanceTick());
        sendAnt(n, n.logic_->createHelloAnt(), -1);
    }
    schedule(now_ + jittered(n, config_.helloInterval, false), [this, id] { helloTimer(id); });
}

void World::proactiveTimer(int id) {
    Node& n = *nodes_[id];
    if (n.up_) {
        for (AntMessage& a : n.logic_->createProactiveAnts()) {
            const NodeAddress next = n.logic_->selectNextHop(a.dst, /*proactive=*/true);
            sendAnt(n, a, next == kInvalidAddress ? -1 : next);
        }
    }
    schedule(now_ + jittered(n, config_.proactiveInterval, false),
             [this, id] { proactiveTimer(id); });
}

void World::retryTimer(int id) {
    Node& n = *nodes_[id];
    if (n.up_) {
        purge(n);
        std::vector<NodeAddress> dests;
        for (const Node::Pending& p : n.pending_) {
            if (std::find(dests.begin(), dests.end(), p.dst) == dests.end()) dests.push_back(p.dst);
        }
        for (NodeAddress d : dests) {
            if (n.logic_->nextHopForData(d) == kInvalidAddress) {
                sendAnt(n, n.logic_->createForwardAnt(core::AntType::Reactive, d), -1);
            } else {
                flushQueue(n, d);
            }
        }
    }
    schedule(now_ + kRetryInterval, [this, id] { retryTimer(id); });
}

// --- interaction -----------------------------------------------------------------------

void World::setNodeUp(int node, bool up) {
    Node& n = *nodes_[node];
    if (n.up_ == up) return;
    n.up_ = up;
    emit(now_, up ? Ev::NodeUp : Ev::NodeDown, node, -1, 0, 0, 0);
    if (!up) {
        for (const Node::Pending& p : n.pending_) {
            emit(now_, Ev::Drop, node, static_cast<int>(DropReason::NodeOff), p.flow, p.seq, 0);
        }
        n.pending_.clear();
    }
}

}  // namespace ahn_web
