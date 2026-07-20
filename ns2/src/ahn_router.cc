/*
 * Implementation of the thin NS-2 AntHocNet agent. See ahn_router.h.
 */
#include "anthocnet/ahn_router.h"

#include <address.h>
#include <cmu-trace.h>  // DROP_RTR_* drop-reason strings (NO_ROUTE/TTL/QFULL/...)
#include <random.h>

#include "anthocnet/core/route_decision.h"

using anthocnet::core::AntMessage;
using anthocnet::core::AntType;
using anthocnet::core::RouteAction;
using anthocnet::core::RouteDecision;
using anthocnet::ns2::fromMessage;
using anthocnet::ns2::toMessage;

// --- NS-2 registrars --------------------------------------------------------

static class AntHocNetHeaderClass : public PacketHeaderClass {
public:
    AntHocNetHeaderClass()
        : PacketHeaderClass("PacketHeader/AntHocNet", sizeof(AntPacketHeader)) {
        bind_offset(&AntPacketHeader::offset_);
    }
} class_anthocnet_hdr;

static class AntHocNetAgentClass : public TclClass {
public:
    AntHocNetAgentClass() : TclClass("Agent/AntHocNet") {}
    TclObject* create(int argc, const char* const* argv) override {
        assert(argc == 5);
        return new AntHocNetAgent((nsaddr_t) Address::instance().str2addr(argv[4]));
    }
} class_anthocnet_agent;

// --- link-failure callback --------------------------------------------------

static void ahn_link_failed_callback(Packet* p, void* arg) {
    ((AntHocNetAgent*) arg)->linkFailed(p);
}

// --- construction -----------------------------------------------------------

AntHocNetAgent::AntHocNetAgent(nsaddr_t id)
    : Agent(PT_ANT),
      id_(id),
      logic_(nullptr),
      dmux_(nullptr),
      logtarget_(nullptr),
      ifqueue_(nullptr),
      hello_timer_(this),
      proactive_timer_(this),
      num_nodes_(0),
      num_nodes_x_(0),
      num_nodes_y_(0),
      r_factor_(1.0),
      timer_ant_(1.0),
      beta_ants_(1.0),
      beta_data_(2.0),
      enable_proactive_(1),
      enable_diffusion_(1),
      proactive_bcast_prob_(0.1),
      session_ttl_(5.0),
      tx_failure_threshold_(3),
      enable_mac_failure_detector_(1),
      repair_wait_factor_(5.0),
      repair_timeout_(1.0),
      enable_mac_metric_(0),
      queueCount_(0) {
    bind("num_nodes_", &num_nodes_);
    bind("num_nodes_x_", &num_nodes_x_);
    bind("num_nodes_y_", &num_nodes_y_);
    bind("r_factor_", &r_factor_);
    bind("timer_ant_", &timer_ant_);
    bind("beta_ants_", &beta_ants_);
    bind("beta_data_", &beta_data_);
    bind_bool("enable_proactive_", &enable_proactive_);
    bind_bool("enable_diffusion_", &enable_diffusion_);
    bind("proactive_bcast_prob_", &proactive_bcast_prob_);
    bind("session_ttl_", &session_ttl_);
    bind("tx_failure_threshold_", &tx_failure_threshold_);
    bind_bool("enable_mac_failure_detector_", &enable_mac_failure_detector_);
    bind("repair_wait_factor_", &repair_wait_factor_);
    bind("repair_timeout_", &repair_timeout_);
    bind_bool("enable_mac_metric_", &enable_mac_metric_);
}

AntHocNetAgent::~AntHocNetAgent() {
    delete logic_;
}

void AntHocNetAgent::startProtocol() {
    // Build the config from the tcl-bound parameters, then create the core
    // logic now that those values are populated.
    config_.helloInterval     = AHN_HELLO_INTERVAL;
    config_.proactiveInterval = AHN_PROACTIVE_INTERVAL;
    config_.networkDiameter   = AHN_NETWORK_DIAMETER;
    config_.lifeAnt           = AHN_LIFE_ANT;
    config_.betaAnts          = beta_ants_;
    config_.betaData          = beta_data_;
    config_.enableProactive   = enable_proactive_ != 0;
    config_.enableDiffusion   = enable_diffusion_ != 0;
    config_.proactiveBroadcastProb = proactive_bcast_prob_;
    config_.sessionTtl        = session_ttl_;
    config_.txFailureThreshold = tx_failure_threshold_;
    config_.repairWaitFactor  = repair_wait_factor_;
    config_.repairTimeout     = repair_timeout_;
    config_.enableMacMetric   = enable_mac_metric_ != 0;

    delete logic_;
    logic_ = new anthocnet::core::AntRouterLogic(id_, config_, clock_, rng_,
                                                 /*metric=*/nullptr,
                                                 /*linkState=*/this);

    hello_timer_.handle((Event*) 0);
    proactive_timer_.handle((Event*) 0);
}

// --- tcl command interface --------------------------------------------------

int AntHocNetAgent::command(int argc, const char* const* argv) {
    if (argc == 2) {
        if (strcasecmp(argv[1], "start") == 0) {
            startProtocol();
            return TCL_OK;
        }
        if (strcasecmp(argv[1], "stop") == 0) {
            return TCL_OK;
        }
    } else if (argc == 3) {
        if (strcmp(argv[1], "port-dmux") == 0) {
            dmux_ = (PortClassifier*) TclObject::lookup(argv[2]);
            return dmux_ ? TCL_OK : TCL_ERROR;
        }
        if (strcmp(argv[1], "log-target") == 0 || strcmp(argv[1], "tracetarget") == 0) {
            logtarget_ = (Trace*) TclObject::lookup(argv[2]);
            return logtarget_ ? TCL_OK : TCL_ERROR;
        }
        if (strcmp(argv[1], "if-queue") == 0) {
            // Interface queue between LL and MAC (the AODV wiring pattern),
            // handed over by create-ahn-agent for the A2 MAC metric.
            ifqueue_ = (Queue*) TclObject::lookup(argv[2]);
            return ifqueue_ ? TCL_OK : TCL_ERROR;
        }
    }
    return Agent::command(argc, argv);
}

// --- item 10/A2: MAC congestion signals (core::ILinkState) ------------------

int AntHocNetAgent::macQueueLength() const {
    // Packets backlogged in the interface queue between LL and MAC — those a
    // newly-forwarded packet would wait behind. Without the "if-queue" handle
    // the backlog reads 0, so the metric degrades to the unloaded hop time.
    return ifqueue_ ? ifqueue_->length() : 0;
}

anthocnet::core::Time AntHocNetAgent::macServiceTime() const {
    // Nominal per-packet MAC service time, matching the NS-3 adapter's current
    // pass: the congestion signal is the *measured queue occupancy*
    // (macQueueLength), so per-hop cost = (Q+1)*hopTime. A measured tx-time
    // EWMA (issue #68) has no clean hook in NS-2 — the MAC reports transmit
    // *failures* to the agent (xmit_failure_) but no per-packet success/timing
    // callback — so the nominal reference stays until one is plumbed (#69).
    return config_.hopTimeSec;
}

// --- receive ----------------------------------------------------------------

void AntHocNetAgent::recv(Packet* p, Handler*) {
    struct hdr_cmn* ch = HDR_CMN(p);
    struct hdr_ip* ih = HDR_IP(p);

    if ((int) ih->saddr() == id_) {
        if (ch->num_forwards() > 0) {
            drop(p, DROP_RTR_ROUTE_LOOP);
            return;
        }
        if (ch->num_forwards() == 0) {
            if (ch->ptype() != PT_TCP && ch->ptype() != PT_ACK) {
                ch->size() += IP_HDR_LEN;
            }
            if ((u_int32_t) ih->daddr() != IP_BROADCAST) {
                ih->ttl_ = AHN_NETWORK_DIAMETER;
            }
        }
    } else if (--ih->ttl_ == 0) {
        drop(p, DROP_RTR_TTL);
        return;
    }

    if (ch->ptype() == PT_ANT) {
        handleAnt(p);
    } else {
        handleData(p);
    }
}

void AntHocNetAgent::handleAnt(Packet* p) {
    if (!logic_) { Packet::free(p); return; }

    struct hdr_cmn* ch = HDR_CMN(p);
    const nsaddr_t prevHop = ch->prev_hop_;

    AntMessage incoming = toMessage(*HDR_AHN(p));
    std::vector<RouteDecision> decisions = logic_->onReceiveAnt(incoming, prevHop);

    for (const RouteDecision& d : decisions) {
        switch (d.action) {
            case RouteAction::Drop:
                drop(p, DROP_RTR_ROUTE_LOOP);
                return;  // p consumed
            case RouteAction::Deliver:
                // Route discovered: flush packets waiting on this destination.
                flushQueue(incoming.src);
                break;
            case RouteAction::Unicast:
                sendAnt(d.message, d.nextHop, /*broadcast=*/false);
                break;
            case RouteAction::Broadcast:
                sendAnt(d.message, anthocnet::core::kInvalidAddress, /*broadcast=*/true);
                break;
            case RouteAction::None:
            case RouteAction::Queue:
            case RouteAction::DiscardPending:  // maintenance-tick only
                break;
        }
    }

    Packet::free(p);  // the incoming ant has been consumed / re-emitted
}

void AntHocNetAgent::handleData(Packet* p) {
    if (!logic_) { drop(p, DROP_RTR_NO_ROUTE); return; }

    struct hdr_ip* ih = HDR_IP(p);
    const nsaddr_t dest = ih->daddr();

    // Locally-originated data marks an active session for proactive probing.
    if (ih->saddr() == id_) logic_->noteDataSession(dest);

    // Exclude the hop the packet just came from to suppress data loops (A1);
    // locally-originated packets have no previous hop.
    const nsaddr_t prevHop =
        (ih->saddr() == id_) ? anthocnet::core::kInvalidAddress
                             : static_cast<nsaddr_t>(HDR_CMN(p)->prev_hop_);
    std::vector<RouteDecision> decisions = logic_->onDataPacket(dest, prevHop);

    for (const RouteDecision& d : decisions) {
        switch (d.action) {
            case RouteAction::Unicast:
                forwardData(p, d.nextHop);
                return;  // p consumed
            case RouteAction::Queue:
                enqueue(p, dest);
                break;     // p retained
            case RouteAction::Broadcast:
                sendAnt(d.message, anthocnet::core::kInvalidAddress, /*broadcast=*/true);
                break;
            default:
                break;
        }
    }
}

// --- emission ---------------------------------------------------------------

Packet* AntHocNetAgent::makeAntPacket(const AntMessage& m) {
    Packet* p = Packet::alloc();
    struct hdr_cmn* ch = HDR_CMN(p);
    struct hdr_ip* ih = HDR_IP(p);
    AntPacketHeader* ah = HDR_AHN(p);

    fromMessage(m, *ah);

    ch->ptype() = PT_ANT;
    ch->size() = IP_HDR_LEN + ah->wireSize();
    ch->iface() = -2;
    ch->error() = 0;
    ch->prev_hop_ = id_;

    ih->saddr() = id_;
    ih->sport() = RT_PORT;
    ih->dport() = RT_PORT;
    return p;
}

void AntHocNetAgent::sendAnt(const AntMessage& m, nsaddr_t nextHop, bool broadcast) {
    Packet* p = makeAntPacket(m);
    struct hdr_cmn* ch = HDR_CMN(p);
    struct hdr_ip* ih = HDR_IP(p);

    ih->ttl_ = AHN_NETWORK_DIAMETER;

    if (broadcast) {
        ch->addr_type() = NS_AF_NONE;
        ih->daddr() = IP_BROADCAST;
        // Jitter broadcasts to avoid synchronised collisions.
        Scheduler::instance().schedule(target_, p, 0.01 * Random::uniform());
    } else {
        ch->next_hop() = nextHop;
        ch->addr_type() = NS_AF_INET;
        ih->daddr() = nextHop;
        Scheduler::instance().schedule(target_, p, 0.0);
    }
}

void AntHocNetAgent::forwardData(Packet* p, nsaddr_t nextHop) {
    struct hdr_cmn* ch = HDR_CMN(p);
    struct hdr_ip* ih = HDR_IP(p);

    if (ih->ttl_ == 0) {
        drop(p, DROP_RTR_TTL);
        return;
    }

    // Deliver locally if this node is the destination.
    if (ih->daddr() == id_) {
        if (dmux_) dmux_->recv(p, 0);
        else Packet::free(p);
        return;
    }

    ch->next_hop() = nextHop;
    ch->addr_type() = NS_AF_INET;
    ch->prev_hop_ = id_;
    ch->direction() = hdr_cmn::DOWN;
    ch->xmit_failure_ = ahn_link_failed_callback;
    ch->xmit_failure_data_ = (void*) this;

    Scheduler::instance().schedule(target_, p, 0.0);
}

// --- pending queue ----------------------------------------------------------

void AntHocNetAgent::enqueue(Packet* p, nsaddr_t dest) {
    // Bound the total queue (B1, parity with the NS-3 RequestQueue): when full,
    // drop the globally-oldest pending packet so memory can't grow without limit.
    if (queueCount_ >= AHN_QUEUE_MAX) {
        std::map<nsaddr_t, std::list<AhnQueued> >::iterator oldestList = queue_.end();
        double oldestTime = 0.0;
        for (std::map<nsaddr_t, std::list<AhnQueued> >::iterator it = queue_.begin();
             it != queue_.end(); ++it) {
            if (it->second.empty()) continue;  // front is the oldest in a FIFO list
            if (oldestList == queue_.end() || it->second.front().enqueued < oldestTime) {
                oldestList = it;
                oldestTime = it->second.front().enqueued;
            }
        }
        if (oldestList != queue_.end()) {
            Packet* old = oldestList->second.front().pkt;
            oldestList->second.pop_front();
            --queueCount_;
            if (oldestList->second.empty()) queue_.erase(oldestList);
            drop(old, DROP_RTR_QFULL);
        }
    }

    AhnQueued q;
    q.pkt = p;
    q.enqueued = Scheduler::instance().clock();
    queue_[dest].push_back(q);
    ++queueCount_;
}

void AntHocNetAgent::flushQueue(nsaddr_t dest) {
    std::map<nsaddr_t, std::list<AhnQueued> >::iterator it = queue_.find(dest);
    if (it == queue_.end()) return;

    std::list<AhnQueued> pending;
    pending.swap(it->second);
    queue_.erase(it);
    queueCount_ -= static_cast<int>(pending.size());

    for (std::list<AhnQueued>::iterator pit = pending.begin(); pit != pending.end(); ++pit) {
        handleData(pit->pkt);  // route now exists (or re-queues if it vanished)
    }
}

void AntHocNetAgent::discardQueue(nsaddr_t dest) {
    // Local repair timed out ([1] §3.5, D6): the paper discards the packets
    // buffered for the unreachable destination instead of delivering them at
    // huge delay once some route eventually reappears.
    std::map<nsaddr_t, std::list<AhnQueued> >::iterator it = queue_.find(dest);
    if (it == queue_.end()) return;

    std::list<AhnQueued> pending;
    pending.swap(it->second);
    queue_.erase(it);
    queueCount_ -= static_cast<int>(pending.size());

    for (std::list<AhnQueued>::iterator pit = pending.begin(); pit != pending.end(); ++pit) {
        drop(pit->pkt, DROP_RTR_NO_ROUTE);
    }
}

void AntHocNetAgent::purgeQueue() {
    const double now = Scheduler::instance().clock();
    for (std::map<nsaddr_t, std::list<AhnQueued> >::iterator it = queue_.begin();
         it != queue_.end();) {
        std::list<AhnQueued>& lst = it->second;
        for (std::list<AhnQueued>::iterator pit = lst.begin(); pit != lst.end();) {
            if (now - pit->enqueued >= AHN_QUEUE_TIMEOUT) {
                drop(pit->pkt, DROP_RTR_QTIMEOUT);
                pit = lst.erase(pit);
                --queueCount_;
            } else {
                ++pit;
            }
        }
        if (lst.empty()) queue_.erase(it++);
        else ++it;
    }
}

// --- link failure -----------------------------------------------------------

void AntHocNetAgent::linkFailed(Packet* p) {
    struct hdr_cmn* ch = HDR_CMN(p);
    struct hdr_ip* ih = HDR_IP(p);
    const nsaddr_t broken = ch->next_hop_;
    const bool isData = (ch->ptype() != PT_ANT);
    const nsaddr_t dest = ih->daddr();

    // MAC transmit-failure detector (ADR-0008 detector D): drop the dead
    // neighbour (emitting any LinkFail notifications) and, for a failed data
    // packet, broadcast a bounded local-repair ant toward the lost destination.
    // The core counts/bounds the repair ant; both adapters share this path.
    // Gated for the detector-D ablation (issue #46); the data re-enqueue below
    // stays either way — losing the detector must not also lose the packet.
    if (logic_ && enable_mac_failure_detector_) {
        for (const RouteDecision& d :
             logic_->reportTxFailure(broken,
                                     isData ? dest : anthocnet::core::kInvalidAddress)) {
            if (d.action == RouteAction::Broadcast) {
                sendAnt(d.message, anthocnet::core::kInvalidAddress, /*broadcast=*/true);
            }
        }
    }

    if (isData) {
        enqueue(p, dest);  // hold for retransmission once repair installs a route
    } else {
        Packet::free(p);
    }
}

// --- timer actions ----------------------------------------------------------

void AntHocNetAgent::sendHello() {
    if (!logic_) return;
    purgeQueue();  // expire pending packets that waited too long for a route (B1)
    // Liveness/maintenance tick (ADR-0008 detector A) before beaconing a hello.
    // The tick returns LinkFail broadcasts and, when a local repair waited past
    // its window with no backward ant, DiscardPending for that destination (D6).
    for (const RouteDecision& d : logic_->onMaintenanceTick()) {
        if (d.action == RouteAction::Broadcast) {
            sendAnt(d.message, anthocnet::core::kInvalidAddress, /*broadcast=*/true);
        } else if (d.action == RouteAction::DiscardPending) {
            discardQueue(d.nextHop);
        }
    }
    AntMessage hello = logic_->createHelloAnt();
    sendAnt(hello, anthocnet::core::kInvalidAddress, /*broadcast=*/true);
}

void AntHocNetAgent::sendProactive() {
    if (!logic_) return;
    // One proactive ant per active session (empty when gated off / idle).
    for (AntMessage& prfa : logic_->createProactiveAnts()) {
        nsaddr_t next = logic_->selectNextHop(prfa.dst, /*proactive=*/true);
        if (next == anthocnet::core::kInvalidAddress) {
            sendAnt(prfa, anthocnet::core::kInvalidAddress, /*broadcast=*/true);
        } else {
            sendAnt(prfa, next, /*broadcast=*/false);
        }
    }
}

// --- timers -----------------------------------------------------------------

void AhnHelloTimer::handle(Event*) {
    agent_->sendHello();
    double base = agent_->config_.helloInterval;
    double interval = 0.75 * base + 0.5 * base * Random::uniform();
    Scheduler::instance().schedule(this, &intr_, interval);
}

void AhnProactiveTimer::handle(Event*) {
    agent_->sendProactive();
    double base = agent_->config_.proactiveInterval;
    double interval = base + 1.5 * base * Random::uniform();
    Scheduler::instance().schedule(this, &intr_, interval);
}
