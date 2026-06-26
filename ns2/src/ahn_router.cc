/*
 * Implementation of the thin NS-2 AntHocNet agent. See ahn_router.h.
 */
#include "anthocnet/ahn_router.h"

#include <address.h>
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
      hello_timer_(this),
      proactive_timer_(this),
      num_nodes_(0),
      num_nodes_x_(0),
      num_nodes_y_(0),
      r_factor_(1.0),
      timer_ant_(1.0),
      beta_ants_(2.0),
      beta_data_(20.0),
      enable_proactive_(1),
      enable_diffusion_(1),
      proactive_bcast_prob_(0.1),
      session_ttl_(5.0) {
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

    delete logic_;
    logic_ = new anthocnet::core::AntRouterLogic(id_, config_, clock_, rng_);

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
    }
    return Agent::command(argc, argv);
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

    std::vector<RouteDecision> decisions = logic_->onDataPacket(dest);

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
    queue_[dest].push_back(p);
}

void AntHocNetAgent::flushQueue(nsaddr_t dest) {
    std::map<nsaddr_t, std::list<Packet*> >::iterator it = queue_.find(dest);
    if (it == queue_.end()) return;

    std::list<Packet*> pending;
    pending.swap(it->second);
    queue_.erase(it);

    for (std::list<Packet*>::iterator pit = pending.begin(); pit != pending.end(); ++pit) {
        handleData(*pit);  // route now exists (or re-queues if it vanished)
    }
}

// --- link failure -----------------------------------------------------------

void AntHocNetAgent::linkFailed(Packet* p) {
    struct hdr_cmn* ch = HDR_CMN(p);
    struct hdr_ip* ih = HDR_IP(p);
    const nsaddr_t broken = ch->next_hop_;

    if (logic_) logic_->loseNeighbor(broken);

    if (ch->ptype() != PT_ANT) {
        const nsaddr_t dest = ih->daddr();
        enqueue(p, dest);
        if (logic_) {
            AntMessage rrfa = logic_->createForwardAnt(AntType::Repair, dest);
            rrfa.lifeAnt = AHN_LIFE_ANT;
            sendAnt(rrfa, anthocnet::core::kInvalidAddress, /*broadcast=*/true);
        }
    } else {
        Packet::free(p);
    }
}

// --- timer actions ----------------------------------------------------------

void AntHocNetAgent::sendHello() {
    if (!logic_) return;
    // Liveness/maintenance tick (ADR-0008 detector A) before beaconing a hello.
    for (const RouteDecision& d : logic_->onMaintenanceTick()) {
        if (d.action == RouteAction::Broadcast) {
            sendAnt(d.message, anthocnet::core::kInvalidAddress, /*broadcast=*/true);
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
