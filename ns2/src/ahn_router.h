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
#include <queue.h>

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
#define AHN_QUEUE_MAX           64      // total pending packets cap (B1)
#define AHN_QUEUE_TIMEOUT       30.0    // seconds a packet may wait for a route

class AntHocNetAgent;

/// One pending data packet awaiting a route, with its enqueue time.
struct AhnQueued {
    Packet* pkt;
    double  enqueued;
};

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

// The agent is also a core ILinkState (item 10/A2): it supplies MAC congestion
// signals for the congestion-aware per-hop metric. Only meaningful when
// enable_mac_metric_ is set; the core queries these while stamping a forward ant.
class AntHocNetAgent : public Agent, public anthocnet::core::ILinkState {
    friend class AhnHelloTimer;
    friend class AhnProactiveTimer;

public:
    explicit AntHocNetAgent(nsaddr_t id);
    ~AntHocNetAgent() override;

    int command(int argc, const char* const* argv) override;
    void recv(Packet* p, Handler* h) override;

    void linkFailed(Packet* p);

    // core::ILinkState (item 10/A2)
    int macQueueLength() const override;
    anthocnet::core::Time macServiceTime() const override;

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
    void purgeQueue();  // drop entries older than AHN_QUEUE_TIMEOUT
    void discardQueue(nsaddr_t dest);  // repair wait expired ([1] §3.5, D6)

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
    Queue* ifqueue_;  // interface queue between LL and MAC ("if-queue" TCL command)

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
    int    tx_failure_threshold_;
    int    enable_mac_failure_detector_;  // detector D gate (issue #46)
    double repair_wait_factor_;
    double repair_timeout_;
    int    enable_mac_metric_;  // item 10/A2 congestion-aware metric gate (issue #69)

    std::map<nsaddr_t, std::list<AhnQueued> > queue_;
    int queueCount_;  // total pending packets across all destinations
};

#endif // ANTHOCNET_NS2_AHN_ROUTER_H
