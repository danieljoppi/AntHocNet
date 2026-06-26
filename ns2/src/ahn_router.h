/*
 * Thin NS-2 Agent adapter for AntHocNet.
 *
 * All routing intelligence lives in core::AntRouterLogic. This agent only:
 *   - converts NS-2 Packets <-> core::AntMessage,
 *   - turns the returned RouteDecisions into scheduler sends,
 *   - drives the periodic hello / proactive / maintenance timers,
 *   - holds the pending-packet queue.
 */
#ifndef ANTHOCNET_NS2_AHN_ROUTER_H
#define ANTHOCNET_NS2_AHN_ROUTER_H

#include <agent.h>
#include <packet.h>
#include <ip.h>
#include <trace.h>
#include <timer-handler.h>
#include <classifier-port.h>

#include <list>
#include <map>

#include "anthocnet/core/ant_router_logic.h"
#include "anthocnet/core/config.h"
#include "anthocnet/ahn_adapters.h"
#include "anthocnet/ant_packet_ns2.h"

#define AHN_HELLO_INTERVAL      1.0
#define AHN_PROACTIVE_INTERVAL  10.0
#define AHN_NETWORK_DIAMETER    30
#define AHN_LIFE_ANT            2.0

class AntHocNetAgent;

/// Periodic hello-ant beacon.
class AhnHelloTimer : public Handler {
public:
    explicit AhnHelloTimer(AntHocNetAgent* a) : agent_(a) {}
    void handle(Event*) override;
private:
    AntHocNetAgent* agent_;
    Event intr_;
};

/// Periodic proactive forward-ant generation.
class AhnProactiveTimer : public Handler {
public:
    explicit AhnProactiveTimer(AntHocNetAgent* a) : agent_(a) {}
    void handle(Event*) override;
private:
    AntHocNetAgent* agent_;
    Event intr_;
};

class AntHocNetAgent : public Agent {
    friend class AhnHelloTimer;
    friend class AhnProactiveTimer;

public:
    explicit AntHocNetAgent(nsaddr_t id);
    ~AntHocNetAgent() override;

    int command(int argc, const char* const* argv) override;
    void recv(Packet* p, Handler* h) override;

    void linkFailed(Packet* p);

protected:
    // packet paths
    void handleAnt(Packet* p);
    void handleData(Packet* p);

    // emission
    Packet* makeAntPacket(const anthocnet::core::AntMessage& m);
    void sendAnt(const anthocnet::core::AntMessage& m, nsaddr_t nextHop, bool broadcast);
    void forwardData(Packet* p, nsaddr_t nextHop);

    // pending queue
    void enqueue(Packet* p, nsaddr_t dest);
    void flushQueue(nsaddr_t dest);

    // timer actions
    void sendHello();
    void sendProactive();

    void startProtocol();

private:
    nsaddr_t id_;
    anthocnet::core::Config config_;
    anthocnet::ns2::Ns2Clock clock_;
    anthocnet::ns2::Ns2Rng rng_;
    anthocnet::core::AntRouterLogic* logic_;

    PortClassifier* dmux_;
    Trace* logtarget_;

    AhnHelloTimer hello_timer_;
    AhnProactiveTimer proactive_timer_;

    // tcl-bound parameters (see ns-default.tcl)
    int num_nodes_;
    int num_nodes_x_;
    int num_nodes_y_;
    double r_factor_;
    double timer_ant_;
    double beta_ants_;
    double beta_data_;
    int    enable_proactive_;
    int    enable_diffusion_;
    double proactive_bcast_prob_;
    double session_ttl_;

    std::map<nsaddr_t, std::list<Packet*> > queue_;
};

#endif // ANTHOCNET_NS2_AHN_ROUTER_H
