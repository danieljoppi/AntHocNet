// SPDX-License-Identifier: GPL-2.0-only
// Copyright (C) 2026 Daniel Henrique Joppi

#include "anthocnet-routing-protocol.h"
#include "anthocnet-packet.h"

#include "ns3/log.h"
#include "ns3/node.h"
#include "ns3/boolean.h"
#include "ns3/double.h"
#include "ns3/pointer.h"
#include "ns3/uinteger.h"
#include "ns3/inet-socket-address.h"
#include "ns3/udp-socket-factory.h"
#include "ns3/ipv4-route.h"
#include "ns3/simulator.h"
#include "ns3/trace-source-accessor.h"
#include "ns3/wifi-net-device.h"
#include "ns3/wifi-mac-queue.h"
#include "ns3/qos-utils.h"
#include "ns3/ipv4-interface.h"
#include "ns3/arp-cache.h"
#include "ns3/llc-snap-header.h"
#include "ns3/udp-header.h"

namespace ns3 {

NS_LOG_COMPONENT_DEFINE("AntHocNetRoutingProtocol");

namespace anthocnet {

using ::anthocnet::core::AntMessage;
using ::anthocnet::core::AntType;
using ::anthocnet::core::RouteAction;
using ::anthocnet::core::RouteDecision;
using ::anthocnet::core::NodeAddress;
using ::anthocnet::core::kInvalidAddress;

NS_OBJECT_ENSURE_REGISTERED(RoutingProtocol);

const uint16_t RoutingProtocol::ANT_PORT = 6900;

RoutingProtocol::RoutingProtocol()
    : m_started(false),
      m_queue(64, Seconds(3)),
      m_helloInterval(Seconds(1.0)),
      m_proactiveInterval(Seconds(10.0)),
      m_alpha(0.7),
      m_betaAnts(20.0),
      m_betaData(20.0),
      m_gamma(0.7),
      m_enableProactive(true),
      m_enableDiffusion(true),
      m_enableReactive(true),
      m_enableRepair(true),
      m_enableLinkFail(true),
      m_enableDirectedReactive(false),
      m_proactiveBroadcastProb(0.1),
      m_proactiveVirtualMargin(0.0),
      m_sessionTtl(5.0),
      m_txFailureThreshold(3),
      m_enableMacFailureDetector(true),
      m_repairWaitFactor(5.0),
      m_repairTimeout(1.0),
      m_hopTime(0.003),
      m_enableMultipath(true),
      m_antAcceptanceFactor(0.9),
      m_antAcceptanceFactorNewHop(2.0),
      m_linkfailNotifyInterval(5.0),
      m_queueTimeout(Seconds(3)),
      m_reconvHoldCap(Seconds(1.0)),
      m_repairHoldCap(Seconds(0)),
      m_reactiveRetryInterval(Seconds(0.25)),
      m_macServiceAlpha(0.7),
      m_lastAckTime(Seconds(0)),
      m_enableMacMetric(false) {}

RoutingProtocol::~RoutingProtocol() = default;

TypeId RoutingProtocol::GetTypeId() {
    static TypeId tid =
        TypeId("ns3::anthocnet::RoutingProtocol")
            .SetParent<Ipv4RoutingProtocol>()
            .SetGroupName("AntHocNet")
            .AddConstructor<RoutingProtocol>()
            .AddAttribute("HelloInterval", "Hello-ant beacon interval.",
                          TimeValue(Seconds(1.0)),
                          MakeTimeAccessor(&RoutingProtocol::m_helloInterval),
                          MakeTimeChecker())
            .AddAttribute("ProactiveInterval", "Proactive forward-ant interval.",
                          TimeValue(Seconds(10.0)),
                          MakeTimeAccessor(&RoutingProtocol::m_proactiveInterval),
                          MakeTimeChecker())
            .AddAttribute("Alpha", "Pheromone evaporation weight (ALFA).",
                          DoubleValue(0.7),
                          MakeDoubleAccessor(&RoutingProtocol::m_alpha),
                          MakeDoubleChecker<double>())
            .AddAttribute("BetaAnts", "Eq.1 exponent for ant next-hop choice (thesis beta1/beta2).",
                          DoubleValue(20.0),
                          MakeDoubleAccessor(&RoutingProtocol::m_betaAnts),
                          MakeDoubleChecker<double>())
            .AddAttribute("BetaData", "Eq.1 exponent for greedy data routing (thesis beta3).",
                          DoubleValue(20.0),
                          MakeDoubleAccessor(&RoutingProtocol::m_betaData),
                          MakeDoubleChecker<double>())
            .AddAttribute("Gamma", "Reinforcement weight (GAMA).",
                          DoubleValue(0.7),
                          MakeDoubleAccessor(&RoutingProtocol::m_gamma),
                          MakeDoubleChecker<double>())
            .AddAttribute("EnableProactive",
                          "Master switch for proactive ants + diffusion.",
                          BooleanValue(true),
                          MakeBooleanAccessor(&RoutingProtocol::m_enableProactive),
                          MakeBooleanChecker())
            .AddAttribute("EnableDiffusion",
                          "Hello pheromone adverts + virtual table.",
                          BooleanValue(true),
                          MakeBooleanAccessor(&RoutingProtocol::m_enableDiffusion),
                          MakeBooleanChecker())
            .AddAttribute("EnableReactive",
                          "Reactive forward ants ([1] §3.1 route discovery). Off "
                          "removes the only source of regular pheromone, so data "
                          "for an unknown destination stays queued — an ablation "
                          "switch, not an operating mode.",
                          BooleanValue(true),
                          MakeBooleanAccessor(&RoutingProtocol::m_enableReactive),
                          MakeBooleanChecker())
            .AddAttribute("EnableRepair",
                          "Local repair ants after a link break ([1] §3.5). Off "
                          "leaves reconvergence to a fresh reactive discovery.",
                          BooleanValue(true),
                          MakeBooleanAccessor(&RoutingProtocol::m_enableRepair),
                          MakeBooleanChecker())
            .AddAttribute("EnableLinkFail",
                          "Link-failure notifications ([1] §3.5). Off suppresses "
                          "only the outbound note; local pruning and the pending "
                          "queue release still run.",
                          BooleanValue(true),
                          MakeBooleanAccessor(&RoutingProtocol::m_enableLinkFail),
                          MakeBooleanChecker())
            .AddAttribute("EnableDirectedReactive",
                          "Steer a reactive forward ant along the diffused virtual "
                          "gradient (ADR-0007) instead of broadcasting, when the "
                          "regular table has no entry. Default off: this is the "
                          "A/B arm against stock [1] §3.1 flooding.",
                          BooleanValue(false),
                          MakeBooleanAccessor(&RoutingProtocol::m_enableDirectedReactive),
                          MakeBooleanChecker())
            .AddAttribute("ProactiveBroadcastProb",
                          "Per-hop explore-broadcast probability for proactive ants.",
                          DoubleValue(0.1),
                          MakeDoubleAccessor(&RoutingProtocol::m_proactiveBroadcastProb),
                          MakeDoubleChecker<double>())
            .AddAttribute("ProactiveVirtualMargin",
                          "Fraction by which the best virtual pheromone must "
                          "exceed the best regular pheromone before a proactive "
                          "forward ant is actually sent. Ducatelle 2007 thesis: "
                          "\"only if the best virtual pheromone is significantly "
                          "better (in our experiments: at least 10% better) than "
                          "the best regular pheromone, a proactive forward ant is "
                          "sent out\". 0 disables the gate (send every tick, "
                          "pre-#180 behaviour) and is the DEFAULT: the thesis's "
                          "0.10 was measured harmful (#180) because the gate "
                          "compares a bootstrapped virtual estimate against a "
                          "measured regular one, suppressing ~all maintenance and "
                          "tripling reactive rediscovery. Do not raise it without "
                          "re-deriving the condition first.",
                          DoubleValue(0.0),
                          MakeDoubleAccessor(&RoutingProtocol::m_proactiveVirtualMargin),
                          MakeDoubleChecker<double>(0.0))
            .AddAttribute("SessionTtl",
                          "Seconds a data session stays active for proactive probing.",
                          DoubleValue(5.0),
                          MakeDoubleAccessor(&RoutingProtocol::m_sessionTtl),
                          MakeDoubleChecker<double>())
            .AddAttribute("TxFailureThreshold",
                          "Consecutive MAC transmit-failures to the same next hop "
                          "before detector D treats the link as broken (issue #19 "
                          "debounce).",
                          UintegerValue(3),
                          MakeUintegerAccessor(&RoutingProtocol::m_txFailureThreshold),
                          MakeUintegerChecker<uint32_t>(1))
            .AddAttribute("EnableMacFailureDetector",
                          "Enable the WifiMac transmit-failure detector (ADR-0008 "
                          "detector D). The hello-timeout detector (A) always runs.",
                          BooleanValue(true),
                          MakeBooleanAccessor(&RoutingProtocol::m_enableMacFailureDetector),
                          MakeBooleanChecker())
            .AddAttribute("RepairWaitFactor",
                          "Local-repair wait as a multiple of the lost path's "
                          "estimated end-to-end delay ([1] section 3.5, D6).",
                          DoubleValue(5.0),
                          MakeDoubleAccessor(&RoutingProtocol::m_repairWaitFactor),
                          MakeDoubleChecker<double>())
            .AddAttribute("RepairTimeout",
                          "Flat local-repair wait (s) when the lost path has no "
                          "usable delay estimate.",
                          DoubleValue(1.0),
                          MakeDoubleAccessor(&RoutingProtocol::m_repairTimeout),
                          MakeDoubleChecker<double>())
            .AddAttribute("HopTime",
                          "Fixed unloaded-hop reference time T_hop (s): weights "
                          "hop count against measured delay in the goodness "
                          "(T_d + h*T_hop)/2, and is the A2 fallback service "
                          "time. Default 3 ms, the value from the 2007 "
                          "Ducatelle thesis (#88); it was a provisional 50 ms "
                          "before that source was checked.",
                          DoubleValue(0.003),
                          MakeDoubleAccessor(&RoutingProtocol::m_hopTime),
                          MakeDoubleChecker<double>(0.0))
            .AddAttribute("EnableMultipath",
                          "Multipath reactive setup (issue #96, [1] §3.1): admit "
                          "later same-generation reactive ants through the "
                          "AntAcceptanceFactor band instead of strict (src,seq) "
                          "dedup, laying down several good paths, and absorb "
                          "LinkFails while a usable alternate hop survives. "
                          "false = pre-#96 single-path setup.",
                          BooleanValue(true),
                          MakeBooleanAccessor(&RoutingProtocol::m_enableMultipath),
                          MakeBooleanChecker())
            .AddAttribute("AntAcceptanceFactor",
                          "Base multipath acceptance factor a1 (issue #96; [1] "
                          "§3.1 says 1.5, the 2007 thesis says its authors ran "
                          "0.9 — \"a1 is set quite low (to 0.9), in order to "
                          "only allow the best ants through\", lines 4655-4659, "
                          "which is the default on this #177 arm B branch). Used "
                          "only when EnableMultipath is on: a node forwards a "
                          "later same-generation reactive ant only if both its "
                          "hops and travel time are within this factor of the "
                          "best seen — unless its first hop is new, in which "
                          "case AntAcceptanceFactorNewHop applies. Higher admits "
                          "MORE copies (more multipath, up to a flood); no value "
                          "reproduces strict single-path dedup — use "
                          "EnableMultipath=false for that.",
                          DoubleValue(0.9),
                          MakeDoubleAccessor(&RoutingProtocol::m_antAcceptanceFactor),
                          // Lower bound relaxed from 1.0 for #177 arm B: a1 < 1
                          // is the thesis parameterisation, and is what makes
                          // the band suppress rather than admit.
                          MakeDoubleChecker<double>(0.0))
            .AddAttribute("AntAcceptanceFactorNewHop",
                          "Disjoint-path acceptance factor a2 (issue #177, 2007 "
                          "thesis lines 4667-4671: \"To boost the creation of "
                          "disjoint paths ... If this first hop is different "
                          "from those taken by previously accepted ants, we "
                          "apply a higher (less restrictive) acceptance factor "
                          "a2 ... (a2 was set to 2)\"). Applied in place of "
                          "AntAcceptanceFactor when the ant's first hop after "
                          "the source is one no previously accepted ant of that "
                          "route setup used. Keep >= AntAcceptanceFactor, or the "
                          "mechanism penalises disjointness instead of "
                          "rewarding it.",
                          DoubleValue(2.0),
                          MakeDoubleAccessor(&RoutingProtocol::m_antAcceptanceFactorNewHop),
                          MakeDoubleChecker<double>(0.0))
            .AddAttribute("LinkfailNotifyInterval",
                          "Minimum spacing (s) between LinkFail notifications "
                          "originated about the same destination (issue #20); "
                          "0 disables the cooldown.",
                          DoubleValue(5.0),
                          MakeDoubleAccessor(&RoutingProtocol::m_linkfailNotifyInterval),
                          MakeDoubleChecker<double>(0.0))
            .AddAttribute("QueueTimeout",
                          "How long a data packet may wait in the pending queue "
                          "for a route before being dropped (issue #21: the "
                          "paper's deliver-late vs discard trade; the #21 "
                          "frontier picked 3 s: delay99 7.6->2.1 s for "
                          "-2.4 pp PDR, still above AODV).",
                          TimeValue(Seconds(3)),
                          MakeTimeAccessor(&RoutingProtocol::m_queueTimeout),
                          MakeTimeChecker())
            .AddAttribute("ReconvHoldCap",
                          "Issue #21 lever L2 (multipath drop-vs-late trade): "
                          "cap the total time a RECONV-held data packet (waiting "
                          "for a lost route to re-form) may wait since it first "
                          "entered the queue, bounded by QueueTimeout. RECONV "
                          "holds carry 60-71% of the delay-tail mass (#21 "
                          "attribution); capping them below the 3 s timeout "
                          "truncates delay99/jitter at a PDR cost (aged-out "
                          "packets become drops). Default 1 s from the #103 A/B: "
                          "delay99 -37% / jitter -26% on the disk model and "
                          "delay/jitter near-parity with AODV on two-ray (the "
                          "paper PHY), for PDR cost within run-to-run noise. "
                          "0 = disabled (revert to QueueTimeout, pre-#103).",
                          TimeValue(Seconds(1.0)),
                          MakeTimeAccessor(&RoutingProtocol::m_reconvHoldCap),
                          MakeTimeChecker())
            .AddAttribute("RepairHoldCap",
                          "Issue #21 lever L2: same cap for REPAIR-held packets "
                          "(re-injected after a MAC transmit failure while local "
                          "repair runs). REPAIR holds are mostly near-zero already "
                          "(immediate flush when an alternate survives), so this "
                          "is secondary to ReconvHoldCap. 0 = disabled.",
                          TimeValue(Seconds(0)),
                          MakeTimeAccessor(&RoutingProtocol::m_repairHoldCap),
                          MakeTimeChecker())
            .AddAttribute("ReactiveRetryInterval",
                          "How often to re-flood a reactive forward ant for "
                          "destinations that still have data waiting in the "
                          "pending queue but no route (issue #21). The core's "
                          "data-driven retry only fires when a data packet "
                          "arrives (~1 pkt/s at paper CBR), so a lost first "
                          "re-discovery attempt otherwise waits a full second — "
                          "the reconvergence hold that dominates the delay/jitter "
                          "tail. This timer retries independently; 0 disables it "
                          "(pre-#21 behaviour).",
                          TimeValue(Seconds(0.25)),
                          MakeTimeAccessor(&RoutingProtocol::m_reactiveRetryInterval),
                          MakeTimeChecker())
            .AddAttribute("MacServiceAlpha",
                          "EWMA weight of the previous estimate when smoothing "
                          "the measured per-packet MAC service time (issue #68; "
                          "the paper-family smoothing coefficient, cf. #70).",
                          DoubleValue(0.7),
                          MakeDoubleAccessor(&RoutingProtocol::m_macServiceAlpha),
                          MakeDoubleChecker<double>(0.0, 1.0))
            .AddAttribute("EnableMacMetric",
                          "Congestion-aware per-hop cost (item 10/A2): forward ants "
                          "record (MAC-queue+1)*hop-time instead of wall-clock "
                          "transit, so paths shift off loaded nodes.",
                          BooleanValue(false),
                          MakeBooleanAccessor(&RoutingProtocol::m_enableMacMetric),
                          MakeBooleanChecker())
            .AddTraceSource("Tx",
                            "An ant control packet was put on the medium by this "
                            "node (type, direction, broadcast).",
                            MakeTraceSourceAccessor(&RoutingProtocol::m_txAntTrace),
                            "ns3::anthocnet::RoutingProtocol::AntTxCallback")
            .AddTraceSource("Rx",
                            "A non-duplicate ant control packet was received and "
                            "processed (type, direction).",
                            MakeTraceSourceAccessor(&RoutingProtocol::m_rxAntTrace),
                            "ns3::anthocnet::RoutingProtocol::AntRxCallback")
            .AddTraceSource("RouteChanged",
                            "A neighbour/route entry was added or removed "
                            "(dest, neighbour, added).",
                            MakeTraceSourceAccessor(&RoutingProtocol::m_routeChangedTrace),
                            "ns3::anthocnet::RoutingProtocol::RouteChangedCallback")
            .AddTraceSource("MacReinject",
                            "A MAC retry-limit-dropped data packet was "
                            "re-injected into the pending queue (#46/#386). "
                            "Fired once per re-injection, immediately before "
                            "Enqueue; the packet is the queued form (UDP "
                            "header + payload, no IP header).",
                            MakeTraceSourceAccessor(&RoutingProtocol::m_macReinjectTrace),
                            "ns3::anthocnet::RoutingProtocol::MacReinjectCallback");
    return tid;
}

// --- observability: forward core events to ns-3 trace sources (item 15) ------

void RoutingProtocol::onAntSent(::anthocnet::core::AntType type,
                                ::anthocnet::core::AntDirection dir, bool broadcast) {
    m_txAntTrace(static_cast<uint8_t>(type), static_cast<uint8_t>(dir), broadcast);
}

void RoutingProtocol::onAntReceived(::anthocnet::core::AntType type,
                                    ::anthocnet::core::AntDirection dir) {
    m_rxAntTrace(static_cast<uint8_t>(type), static_cast<uint8_t>(dir));
}

void RoutingProtocol::onRouteChanged(::anthocnet::core::NodeAddress dest,
                                     ::anthocnet::core::NodeAddress nb, bool added) {
    m_routeChangedTrace(static_cast<uint32_t>(dest), static_cast<uint32_t>(nb), added);
}

void RoutingProtocol::GetPheromoneDiag(Ipv4Address dest, Ipv4Address neighbor,
                                       double& regular, double& virt) const {
    regular = 0.0;
    virt = 0.0;
    if (!m_logic) return;
    const NodeAddress d = ToCore(dest);
    const NodeAddress n = ToCore(neighbor);
    regular = m_logic->table().getPheromoneRegular(d, n);
    virt = m_logic->table().getPheromoneVirtual(d, n);
}

// --- item 10/A2: MAC congestion signals (core::ILinkState) ------------------

int RoutingProtocol::macQueueLength(NodeAddress nextHop) const {
    // Wifi regime: packets backlogged at the wifi MAC across all access
    // categories — the queue a newly-forwarded packet would wait behind.
    // Summed over the per-AC txop queues (unified since ns-3.36, the CI-matrix
    // floor). Single radio: every next hop shares this one MAC queue, so the
    // per-next-hop parameter (#206) is ignored — and preferred where it
    // exists, keeping pre-#206 wifi behaviour byte-identical.
    if (m_wifiMac) {
        uint32_t total = 0;
        // AC_BE_NQOS is essential: a non-QoS mac (AdhocWifiMac, the MANET
        // default) keeps its single DCF queue under AC_BE_NQOS, not AC_BE —
        // without it GetTxopQueue returns nullptr and the backlog always reads
        // 0, so the whole A2 signal was silently absent (issue #73).
        for (AcIndex ac : {AC_BE_NQOS, AC_BE, AC_BK, AC_VI, AC_VO}) {
            Ptr<WifiMacQueue> q = m_wifiMac->GetTxopQueue(ac);
            if (q) total += q->GetNPackets();
        }
        return static_cast<int>(total);
    }
    // p2p/ISL regime (#206): the backlog lives in the per-interface device
    // transmit queue. A named next hop reads the one queue the packet would
    // wait in; kInvalidAddress means no single outgoing interface (broadcast,
    // or the path's terminal) — aggregate across them, per the ILinkState
    // contract.
    if (m_txQueues.empty()) return 0;
    if (nextHop == kInvalidAddress) {
        uint32_t total = 0;
        for (const auto& kv : m_txQueues) {
            if (kv.second.queue) total += kv.second.queue->GetNPackets();
        }
        return static_cast<int>(total);
    }
    if (m_socketAddresses.empty()) return 0;  // ResolveNextHop needs an iface
    Ipv4Address gateway;
    Ptr<NetDevice> dev;
    uint32_t iface = 0;
    ResolveNextHop(nextHop, gateway, dev, iface);
    const auto it = m_txQueues.find(iface);
    if (it == m_txQueues.end() || !it->second.queue) return 0;
    return static_cast<int>(it->second.queue->GetNPackets());
}

::anthocnet::core::Time RoutingProtocol::macServiceTime(NodeAddress nextHop) const {
    // Wifi regime (issue #68): EWMA of inter-ack spacing sampled while the MAC
    // queue stayed backlogged, so contention and retransmissions are included
    // but queue wait is not — (Q+1)*T̂_mac must not double-count the queue.
    // 0 until the first sample; the core then falls back to the unloaded
    // reference hop time (ILinkState contract).
    if (m_wifiMac || m_txQueues.empty()) return m_macServiceEwmaSec;
    // p2p/ISL regime (#206): per-interface inter-dequeue EWMA — serialisation
    // only, never propagation (an ISL's 3-18 ms is real delay but not
    // congestion; folding it in would swamp the signal's dynamic range).
    if (nextHop != kInvalidAddress) {
        if (m_socketAddresses.empty()) return 0.0;
        Ipv4Address gateway;
        Ptr<NetDevice> dev;
        uint32_t iface = 0;
        ResolveNextHop(nextHop, gateway, dev, iface);
        const auto it = m_txQueues.find(iface);
        return it != m_txQueues.end() ? it->second.ewmaSec : 0.0;
    }
    // Aggregate (broadcast / terminal): mean of the sampled interfaces, 0 (=
    // fall back to the unloaded reference) when none has a sample yet.
    double sum = 0.0;
    int n = 0;
    for (const auto& kv : m_txQueues) {
        if (kv.second.ewmaSec > 0.0) {
            sum += kv.second.ewmaSec;
            ++n;
        }
    }
    return n > 0 ? sum / n : 0.0;
}

void RoutingProtocol::TxDequeueTrace(RoutingProtocol* self, uint32_t interface,
                                     Ptr<const Packet> p) {
    self->NotifyTxDequeue(interface, p);
}

void RoutingProtocol::NotifyTxDequeue(uint32_t interface, Ptr<const Packet>) {
    // A valid pure-service sample is the spacing between two consecutive
    // dequeues during which the queue never emptied — the device pulls the
    // next packet the moment the previous one finishes serialising, so that
    // spacing IS the per-packet service time (and never includes propagation:
    // the sender does not wait for it). Mirrors NotifyAckedMpdu.
    auto it = m_txQueues.find(interface);
    if (it == m_txQueues.end()) return;
    TxQueueState& st = it->second;
    const Time now = Simulator::Now();
    if (st.backlogAtLastDequeue && st.lastDequeue.IsStrictlyPositive()) {
        const double sample = (now - st.lastDequeue).GetSeconds();
        if (sample > 0.0) {
            st.ewmaSec = st.ewmaSec > 0.0
                             ? m_macServiceAlpha * st.ewmaSec +
                                   (1.0 - m_macServiceAlpha) * sample
                             : sample;
        }
    }
    st.lastDequeue = now;
    st.backlogAtLastDequeue = st.queue && st.queue->GetNPackets() > 0;
}

void RoutingProtocol::NotifyAckedMpdu(Ptr<const AHN_WIFI_MPDU>) {
    // A valid pure-service sample is the spacing between two consecutive
    // successful transmissions during which the MAC never idled — i.e. the
    // queue was still non-empty at the previous ack.
    const Time now = Simulator::Now();
    if (m_backlogAtLastAck && m_lastAckTime.IsStrictlyPositive()) {
        const double sample = (now - m_lastAckTime).GetSeconds();
        if (sample > 0.0) {
            m_macServiceEwmaSec =
                m_macServiceEwmaSec > 0.0
                    ? m_macServiceAlpha * m_macServiceEwmaSec +
                          (1.0 - m_macServiceAlpha) * sample
                    : sample;
        }
    }
    m_lastAckTime = now;
    m_backlogAtLastAck = macQueueLength(kInvalidAddress) > 0;
}

// --- lifecycle --------------------------------------------------------------

void RoutingProtocol::SetIpv4(Ptr<Ipv4> ipv4) {
    NS_ASSERT(ipv4);
    m_ipv4 = ipv4;
}

void RoutingProtocol::DoInitialize() {
    m_config.alpha = m_alpha;
    m_config.betaAnts = m_betaAnts;
    m_config.betaData = m_betaData;
    m_config.gamma = m_gamma;
    m_config.enableProactive = m_enableProactive;
    m_config.enableDiffusion = m_enableDiffusion;
    m_config.enableReactive = m_enableReactive;
    m_config.enableRepair = m_enableRepair;
    m_config.enableLinkFail = m_enableLinkFail;
    m_config.enableDirectedReactive = m_enableDirectedReactive;
    m_config.proactiveBroadcastProb = m_proactiveBroadcastProb;
    m_config.proactiveVirtualMargin = m_proactiveVirtualMargin;
    m_config.sessionTtl = m_sessionTtl;
    m_config.helloInterval = m_helloInterval.GetSeconds();
    m_config.proactiveInterval = m_proactiveInterval.GetSeconds();
    m_config.txFailureThreshold = static_cast<int>(m_txFailureThreshold);
    m_config.repairWaitFactor = m_repairWaitFactor;
    m_config.repairTimeout = m_repairTimeout;
    m_config.hopTimeSec = m_hopTime;
    m_config.enableMultipath = m_enableMultipath;
    m_config.antAcceptanceFactor = m_antAcceptanceFactor;
    m_config.antAcceptanceFactorNewHop = m_antAcceptanceFactorNewHop;
    m_config.linkfailNotifyInterval = m_linkfailNotifyInterval;
    m_config.enableMacMetric = m_enableMacMetric;
    m_queue.SetTimeout(m_queueTimeout);  // attribute lands after construction (#21)
    // Issue #21 L2: per-reason hold caps (default 0 == disabled). SETUP stays
    // uncapped on QueueTimeout; only the tail-dominant RECONV/REPAIR holds cap.
    m_queue.SetHoldCap(HOLD_RECONV, m_reconvHoldCap);
    m_queue.SetHoldCap(HOLD_REPAIR, m_repairHoldCap);
    Ipv4RoutingProtocol::DoInitialize();
}

void RoutingProtocol::DoDispose() {
    m_ipv4 = nullptr;
    for (auto& kv : m_socketAddresses) {
        kv.first->Close();
    }
    m_socketAddresses.clear();
    for (auto& kv : m_socketSubnetBroadcast) {
        kv.first->Close();
    }
    m_socketSubnetBroadcast.clear();
    m_logic.reset();
    Ipv4RoutingProtocol::DoDispose();
}

void RoutingProtocol::Start() {
    if (m_started) return;
    m_started = true;

    m_helloTimer.SetFunction(&RoutingProtocol::HelloTimerExpire, this);
    m_proactiveTimer.SetFunction(&RoutingProtocol::ProactiveTimerExpire, this);
    m_helloTimer.Schedule(m_helloInterval);
    m_proactiveTimer.Schedule(m_proactiveInterval);

    // Issue #21: drive re-discovery for held data at a sub-second cadence
    // (0 disables). Off the data-packet path, so a broken route re-forms
    // without waiting for the next CBR packet to trigger the retry.
    if (m_reactiveRetryInterval.IsStrictlyPositive()) {
        m_reactiveRetryTimer.SetFunction(&RoutingProtocol::ReactiveRetryTimerExpire, this);
        m_reactiveRetryTimer.Schedule(m_reactiveRetryInterval);
    }
}

// --- interface notifications ------------------------------------------------

void RoutingProtocol::NotifyInterfaceUp(uint32_t interface) {
    Ptr<Ipv4L3Protocol> l3 = m_ipv4->GetObject<Ipv4L3Protocol>();
    if (l3->GetNAddresses(interface) == 0) return;
    Ipv4InterfaceAddress iface = m_ipv4->GetAddress(interface, 0);
    if (iface.GetLocal() == Ipv4Address("127.0.0.1")) return;

    // Create the core logic on the first real interface, keyed by its address.
    if (!m_logic) {
        m_config.alpha = m_alpha;
        m_config.betaAnts = m_betaAnts;
        m_config.betaData = m_betaData;
        m_config.gamma = m_gamma;
        m_config.enableProactive = m_enableProactive;
        m_config.enableDiffusion = m_enableDiffusion;
        m_config.enableReactive = m_enableReactive;
        m_config.enableRepair = m_enableRepair;
        m_config.enableLinkFail = m_enableLinkFail;
        m_config.enableDirectedReactive = m_enableDirectedReactive;
        m_config.proactiveBroadcastProb = m_proactiveBroadcastProb;
        m_config.proactiveVirtualMargin = m_proactiveVirtualMargin;
        m_config.sessionTtl = m_sessionTtl;
        m_config.helloInterval = m_helloInterval.GetSeconds();
        m_config.proactiveInterval = m_proactiveInterval.GetSeconds();
        m_config.txFailureThreshold = static_cast<int>(m_txFailureThreshold);
        m_config.repairWaitFactor = m_repairWaitFactor;
        m_config.repairTimeout = m_repairTimeout;
        m_config.hopTimeSec = m_hopTime;
        m_config.enableMultipath = m_enableMultipath;
        m_config.antAcceptanceFactor = m_antAcceptanceFactor;
        m_config.antAcceptanceFactorNewHop = m_antAcceptanceFactorNewHop;
        m_config.linkfailNotifyInterval = m_linkfailNotifyInterval;
        m_config.enableMacMetric = m_enableMacMetric;
        m_logic.reset(new ::anthocnet::core::AntRouterLogic(
            ToCore(iface.GetLocal()), m_config, m_clock, m_rng,
            /*metric*/ nullptr, /*linkState*/ this));
        m_logic->setObserver(this);  // fan core events to the trace sources
    }

    // One UDP socket per interface for ant control traffic.
    Ptr<Socket> socket = Socket::CreateSocket(GetObject<Node>(),
                                              UdpSocketFactory::GetTypeId());
    NS_ASSERT(socket);
    socket->SetRecvCallback(MakeCallback(&RoutingProtocol::RecvAnt, this));
    socket->BindToNetDevice(l3->GetNetDevice(interface));
    socket->Bind(InetSocketAddress(iface.GetLocal(), ANT_PORT));
    socket->SetAllowBroadcast(true);
    socket->SetIpRecvTtl(true);
    m_socketAddresses[socket] = iface;

    // Second socket bound to the subnet-broadcast address so this interface
    // actually receives the broadcast hello / forward ants.
    Ptr<Socket> bcast = Socket::CreateSocket(GetObject<Node>(),
                                             UdpSocketFactory::GetTypeId());
    NS_ASSERT(bcast);
    bcast->SetRecvCallback(MakeCallback(&RoutingProtocol::RecvAnt, this));
    bcast->BindToNetDevice(l3->GetNetDevice(interface));
    bcast->Bind(InetSocketAddress(iface.GetBroadcast(), ANT_PORT));
    bcast->SetAllowBroadcast(true);
    bcast->SetIpRecvTtl(true);
    m_socketSubnetBroadcast[bcast] = iface;

    // ADR-0008 detector D: subscribe to the WifiMac transmit-failure trace so a
    // failed unicast to a next hop is reported immediately (NS-2 parity). Only
    // wifi devices expose this; for others (e.g. SimpleNetDevice) detector A
    // (the hello-timeout maintenance tick) remains the sole, mandatory detector.
    // TraceConnect returns false if the source is absent on this ns-3 version,
    // which we tolerate — detection then falls back to detector A.
    Ptr<NetDevice> dev = l3->GetNetDevice(interface);
    Ptr<WifiNetDevice> wifi = dev ? dev->GetObject<WifiNetDevice>() : nullptr;
    if (wifi) {
        Ptr<WifiMac> wmac = wifi->GetMac();
        if (wmac) {
            wmac->TraceConnectWithoutContext(
                "DroppedMpdu", MakeCallback(&RoutingProtocol::NotifyTxError, this));
            // Issue #68: sample measured MAC service time on each success.
            wmac->TraceConnectWithoutContext(
                "AckedMpdu", MakeCallback(&RoutingProtocol::NotifyAckedMpdu, this));
            // Keep the first wifi MAC for the item-10/A2 queue-occupancy signal.
            if (!m_wifiMac) m_wifiMac = wmac;
        }
    }

    // #206 step 2: non-wifi devices (the p2p/ISL regime) carry their backlog
    // in the per-device transmit queue instead. Grab it through the generic
    // "TxQueue" attribute — PointToPointNetDevice, CsmaNetDevice and
    // SimpleNetDevice all expose one, so no device-specific module dependency
    // — and sample the service time from its "Dequeue" trace. Which regime a
    // node runs is decided by what the build's scenario instantiated: wifi
    // devices select the MAC reader above, queue-bearing devices select this
    // one. A device with neither (loopback) contributes no signal.
    if (!wifi && dev) {
        PointerValue txq;
        if (dev->GetAttributeFailSafe("TxQueue", txq)) {
            Ptr<Queue<Packet>> q = txq.Get<Queue<Packet>>();
            if (q) {
                m_txQueues[interface].queue = q;
                q->TraceConnectWithoutContext(
                    "Dequeue",
                    MakeBoundCallback(&RoutingProtocol::TxDequeueTrace, this, interface));
            }
        }
    }

    Start();
}

void RoutingProtocol::NotifyInterfaceDown(uint32_t interface) {
    Ipv4InterfaceAddress iface = m_ipv4->GetAddress(interface, 0);
    Ptr<Socket> socket = FindSocketWithInterfaceAddress(iface);
    if (socket) {
        socket->Close();
        m_socketAddresses.erase(socket);
    }
    for (auto it = m_socketSubnetBroadcast.begin(); it != m_socketSubnetBroadcast.end(); ++it) {
        if (it->second == iface) {
            it->first->Close();
            m_socketSubnetBroadcast.erase(it);
            break;
        }
    }

    // #206: stop reading a dead ISL's transmit queue — its residual backlog
    // must not keep inflating the aggregate congestion signal.
    m_txQueues.erase(interface);

    // ADR-0008 detector-D equivalent for non-wifi links (#260). A scripted ISL
    // break (Ipv4::SetDown, the stock ns-3 way to cut a point-to-point link)
    // surfaces here and nowhere else: a PointToPointNetDevice has no
    // retry-limit signal, never reports its link down, and a packet routed at
    // a down interface is dropped by Ipv4L3Protocol before any device trace
    // could fire. A real ISL terminal reports loss-of-light locally within
    // milliseconds, so treating this local event as a definitive transmit
    // failure is more faithful than waiting for the hello timeout (detector A,
    // which stays on as the mandatory backstop — e.g. for silent losses this
    // path never sees). Wifi devices keep their DroppedMpdu path (NotifyTxError,
    // byte-identical) and are excluded here; both fast paths share the
    // EnableMacFailureDetector ablation gate.
    if (!m_enableMacFailureDetector || !m_logic) return;
    Ptr<NetDevice> dev = m_ipv4->GetNetDevice(interface);
    if (dev && dev->GetObject<WifiNetDevice>()) return;
    auto nbIt = m_ifaceNeighbors.find(interface);
    if (nbIt == m_ifaceNeighbors.end()) return;  // cannot attribute a next hop: no-op
    const std::set<NodeAddress> lost = nbIt->second;
    m_ifaceNeighbors.erase(nbIt);
    for (NodeAddress nb : lost) {
        // Converge on the shared reportTxFailure seam (prune + LinkFail
        // notifications), like the wifi path. Its txFailureThreshold debounce
        // exists to filter transient per-frame collisions (issue #19); an
        // interface-down is not transient, so it counts as a full failure
        // streak — drive the seam to its threshold instead of bypassing it,
        // leaving core/ and the threshold's meaning untouched. No data packet
        // is in hand, so dataDest stays invalid: no repair ant here, and held
        // data re-routes through the normal reactive path.
        std::vector<RouteDecision> decisions = m_logic->reportTxFailure(nb, kInvalidAddress);
        for (int k = 1; k < m_config.txFailureThreshold && decisions.empty(); ++k) {
            decisions = m_logic->reportTxFailure(nb, kInvalidAddress);
        }
        ExecuteDecisions(decisions, kInvalidAddress);
    }
}

void RoutingProtocol::NotifyAddAddress(uint32_t, Ipv4InterfaceAddress) {}
void RoutingProtocol::NotifyRemoveAddress(uint32_t, Ipv4InterfaceAddress) {}

// --- routing ----------------------------------------------------------------

void RoutingProtocol::ResolveNextHop(NodeAddress next, Ipv4Address& gateway,
                                     Ptr<NetDevice>& dev, uint32_t& iface) const {
    const Ipv4Address nextIp = ToIpv4(next);

    // 1. Directly attached: the next hop is on one of our own subnets. Every
    //    single-interface topology takes this path, so the common case keeps
    //    exactly its pre-#203 gateway/device.
    for (const auto& kv : m_socketAddresses) {
        const Ipv4InterfaceAddress& addr = kv.second;
        if (addr.GetLocal().CombineMask(addr.GetMask()) ==
            nextIp.CombineMask(addr.GetMask())) {
            const int32_t i = m_ipv4->GetInterfaceForAddress(addr.GetLocal());
            if (i < 0) continue;
            gateway = nextIp;
            iface   = static_cast<uint32_t>(i);
            dev     = m_ipv4->GetNetDevice(iface);
            return;
        }
    }

    // 2. Multi-interface peer: the core named it by its canonical address,
    //    which sits on a subnet we are not attached to. Its hello told us which
    //    of our links actually reaches it, and at what address.
    std::map<Ipv4Address, PeerRoute>::const_iterator it = m_peerRoutes.find(nextIp);
    if (it != m_peerRoutes.end() && it->second.iface < m_ipv4->GetNInterfaces()) {
        gateway = it->second.linkLocal;
        iface   = it->second.iface;
        dev     = m_ipv4->GetNetDevice(iface);
        return;
    }

    // 3. Unknown next hop: degrade to the first interface exactly as before.
    gateway = nextIp;
    iface   = static_cast<uint32_t>(
        m_ipv4->GetInterfaceForAddress(m_socketAddresses.begin()->second.GetLocal()));
    dev = m_ipv4->GetNetDevice(iface);
}

Ptr<Ipv4Route> RoutingProtocol::LoopbackRoute(const Ipv4Header& header, Ptr<NetDevice> oif) const {
    Ptr<Ipv4Route> route = Create<Ipv4Route>();
    route->SetDestination(header.GetDestination());
    route->SetGateway(Ipv4Address("127.0.0.1"));
    // Pick a source address on an available interface.
    for (const auto& kv : m_socketAddresses) {
        Ipv4InterfaceAddress addr = kv.second;
        if (!oif || m_ipv4->GetInterfaceForDevice(oif) ==
                        (int) m_ipv4->GetInterfaceForAddress(addr.GetLocal())) {
            route->SetSource(addr.GetLocal());
            break;
        }
    }
    if (route->GetSource() == Ipv4Address()) {
        if (!m_socketAddresses.empty())
            route->SetSource(m_socketAddresses.begin()->second.GetLocal());
    }
    route->SetOutputDevice(m_ipv4->GetNetDevice(0));  // loopback device
    return route;
}

Ptr<Ipv4Route> RoutingProtocol::RouteOutput(Ptr<Packet> p, const Ipv4Header& header,
                                            Ptr<NetDevice> oif,
                                            Socket::SocketErrno& sockerr) {
    sockerr = Socket::ERROR_NOTERROR;
    if (!m_logic || m_socketAddresses.empty()) {
        sockerr = Socket::ERROR_NOROUTETOHOST;
        return nullptr;
    }

    Ipv4Address dst = header.GetDestination();
    // Locally-originated data: mark this destination as an active session so
    // proactive ants monitor its path (item 04).
    m_logic->noteDataSession(ToCore(dst));
    NodeAddress next = m_logic->nextHopForData(ToCore(dst));
    if (next != kInvalidAddress) {
        m_everRouted.insert(ToCore(dst));  // #21: this dest has been routed
        Ipv4Address gateway;
        Ptr<NetDevice> dev;
        uint32_t ifIdx;
        ResolveNextHop(next, gateway, dev, ifIdx);  // #203
        Ptr<Ipv4Route> route = Create<Ipv4Route>();
        route->SetDestination(dst);
        route->SetGateway(gateway);
        route->SetSource(m_ipv4->SourceAddressSelection(ifIdx, dst));
        route->SetOutputDevice(dev);
        return route;
    }

    // No route yet: bounce through loopback so RouteInput can queue it and we
    // launch a reactive forward ant.
    return LoopbackRoute(header, oif);
}

bool RoutingProtocol::RouteInput(Ptr<const Packet> p, const Ipv4Header& header,
                                 Ptr<const NetDevice> idev,
                                 AHN_RI_CB(UnicastForwardCallback) ucb,
                                 AHN_RI_CB(MulticastForwardCallback) mcb,
                                 AHN_RI_CB(LocalDeliverCallback) lcb,
                                 AHN_RI_CB(ErrorCallback) ecb) {
    if (!m_logic || m_socketAddresses.empty()) return false;

    // Ipv4L3Protocol passes the same bound callbacks on every call; cache them
    // so NotifyTxError can re-inject a MAC-dropped data packet (issue #46).
    m_cachedUcb = ucb;
    m_cachedEcb = ecb;

    Ipv4Address dst = header.GetDestination();

    // Locally destined?
    int32_t iif = m_ipv4->GetInterfaceForDevice(idev);
    if (m_ipv4->IsDestinationAddress(dst, iif)) {
        if (!lcb.IsNull()) lcb(p, header, iif);
        return true;
    }

    // Deferred (came back via loopback): queue and request a route.
    if (idev == m_ipv4->GetNetDevice(0)) {
        DeferredRouteOutput(p, header, ucb, ecb);
        return true;
    }

    // In-transit forwarding.
    // TODO(A1): pass the L2 previous hop to exclude it (loop suppression). NS-3
    // RouteInput does not expose it cleanly (the IP source is the origin, not the
    // prev hop), so exclusion is NS-2-only for now; NS-3 still relies on TTL.
    NodeAddress next = m_logic->nextHopForData(ToCore(dst));
    if (next != kInvalidAddress) {
        m_everRouted.insert(ToCore(dst));  // #21: this dest has been routed
        Ipv4Address gateway;
        Ptr<NetDevice> dev;
        uint32_t ifIdx;
        ResolveNextHop(next, gateway, dev, ifIdx);  // #203
        Ptr<Ipv4Route> route = Create<Ipv4Route>();
        route->SetDestination(dst);
        route->SetGateway(gateway);
        route->SetSource(header.GetSource());
        route->SetOutputDevice(dev);
        ucb(route, p, header);
        return true;
    }

    // No route: queue and emit a reactive forward ant.
    DeferredRouteOutput(p, header, ucb, ecb);
    return true;
}

void RoutingProtocol::DeferredRouteOutput(Ptr<const Packet> p, const Ipv4Header& header,
                                          UnicastForwardCallback ucb, ErrorCallback ecb) {
    QueueEntry entry;
    entry.packet = p;
    entry.header = header;
    entry.ucb = ucb;
    entry.ecb = ecb;
    // #21 attribution: a deferred packet is either a first-time reactive setup
    // (this dest was never routed) or a reconvergence wait (route was known and
    // lost). NotifyTxError's re-injection path tags its own entries HOLD_REPAIR.
    entry.holdReason = m_everRouted.count(ToCore(header.GetDestination()))
                           ? HOLD_RECONV : HOLD_SETUP;
    m_queue.Enqueue(entry);

    // Ask the core what to do; it returns Queue + a reactive forward ant.
    std::vector<RouteDecision> decisions = m_logic->onDataPacket(ToCore(header.GetDestination()));
    ExecuteDecisions(decisions, kInvalidAddress);
}

// --- ant I/O ----------------------------------------------------------------

void RoutingProtocol::SendAnt(const AntMessage& msg, Ipv4Address dest) {
    if (m_socketAddresses.empty()) return;
    Ptr<Packet> packet = Create<Packet>();
    AntHeader header(msg);
    packet->AddHeader(header);

    if (dest == Ipv4Address("255.255.255.255")) {
        for (auto& kv : m_socketAddresses) {
            kv.first->SendTo(packet->Copy(), 0,
                             InetSocketAddress(kv.second.GetBroadcast(), ANT_PORT));
        }
        return;
    }

    // Unicast: out of the interface that actually reaches this next hop, and
    // addressed to where it is reachable on that link (#203). A backward ant
    // retraces a path made of canonical addresses, so on a multi-interface node
    // the ant's next hop is routinely NOT on the subnet it must be sent over.
    Ipv4Address gateway;
    Ptr<NetDevice> dev;
    uint32_t ifIdx;
    ResolveNextHop(ToCore(dest), gateway, dev, ifIdx);
    for (auto& kv : m_socketAddresses) {
        if (m_ipv4->GetInterfaceForAddress(kv.second.GetLocal()) ==
            static_cast<int32_t>(ifIdx)) {
            kv.first->SendTo(packet->Copy(), 0, InetSocketAddress(gateway, ANT_PORT));
            return;
        }
    }
    m_socketAddresses.begin()->first->SendTo(packet->Copy(), 0,
                                             InetSocketAddress(gateway, ANT_PORT));
}

void RoutingProtocol::ExecuteDecisions(const std::vector<RouteDecision>& decisions,
                                       NodeAddress /*flushDest*/) {
    for (const RouteDecision& d : decisions) {
        switch (d.action) {
            case RouteAction::Unicast:
                SendAnt(d.message, ToIpv4(d.nextHop));
                break;
            case RouteAction::Broadcast:
                SendAnt(d.message, Ipv4Address("255.255.255.255"));
                break;
            case RouteAction::Deliver:
                // handled by caller (FlushQueue), nothing to send
                break;
            case RouteAction::DiscardPending:
                // Local repair timed out (D6): release the buffered packets.
                DiscardQueue(d.nextHop);
                break;
            case RouteAction::Queue:
            case RouteAction::Drop:
            case RouteAction::None:
                break;
        }
    }
}

void RoutingProtocol::RecvAnt(Ptr<Socket> socket) {
    Address sourceAddress;
    Ptr<Packet> packet = socket->RecvFrom(sourceAddress);
    InetSocketAddress inetSource = InetSocketAddress::ConvertFrom(sourceAddress);
    Ipv4Address sender = inetSource.GetIpv4();

    AntHeader header;
    packet->RemoveHeader(header);
    AntMessage incoming = header.Message();

    // #203: a hello carries both of the sender's names — `src` is how the core
    // will name it in pheromone tables and retraced ant paths, `sender` is where
    // it actually is on this link. They differ only when the peer is
    // multi-interface and reached us over something other than its first
    // interface, which is precisely the case ResolveNextHop needs help with.
    if (incoming.type == AntType::Hello && incoming.src != kInvalidAddress) {
        const Ipv4Address canonical = ToIpv4(incoming.src);
        // A hello arrives on the subnet-broadcast socket; check the unicast
        // map too so the mapping is still learned if that ever changes.
        bool known = false;
        Ipv4InterfaceAddress ifaceAddr;
        auto bit = m_socketSubnetBroadcast.find(socket);
        if (bit != m_socketSubnetBroadcast.end()) {
            ifaceAddr = bit->second;
            known = true;
        } else {
            auto uit = m_socketAddresses.find(socket);
            if (uit != m_socketAddresses.end()) {
                ifaceAddr = uit->second;
                known = true;
            }
        }
        const int32_t i =
            known ? m_ipv4->GetInterfaceForAddress(ifaceAddr.GetLocal()) : -1;
        if (i >= 0) {
            // #260: record both names the core may hold this neighbour under
            // (learnNeighbor sees the link-local prevHop on every ant and the
            // canonical src on hellos) so the non-wifi interface-down fast
            // path can attribute which next hops a link break severed.
            std::set<NodeAddress>& nbs = m_ifaceNeighbors[static_cast<uint32_t>(i)];
            nbs.insert(ToCore(sender));
            nbs.insert(incoming.src);
            if (canonical != sender) {
                PeerRoute pr;
                pr.iface = static_cast<uint32_t>(i);
                pr.linkLocal = sender;
                m_peerRoutes[canonical] = pr;
            }
        }
    }

    NodeAddress prevHop = ToCore(sender);
    std::vector<RouteDecision> decisions = m_logic->onReceiveAnt(incoming, prevHop);

    // A Deliver means a route to incoming.src was just discovered. And any
    // backward ant that traverses this node installs/refreshes a route toward
    // its origin (incoming.src) at EVERY retraced hop, not just at the data
    // source that gets the Deliver — so flush held packets here too (#21: the
    // reconv hold released only at the origin left intermediate-node queues
    // waiting for the 3 s purge). FlushQueue self-guards: it re-queues
    // anything whose route still doesn't resolve.
    bool flushed = false;
    for (const RouteDecision& d : decisions) {
        if (d.action == RouteAction::Deliver) {
            FlushQueue(incoming.src);
            flushed = true;
            break;
        }
    }
    if (!flushed && incoming.isBackward()) {
        FlushQueue(incoming.src);
    }
    ExecuteDecisions(decisions, incoming.src);
}

void RoutingProtocol::FlushQueue(NodeAddress coreDest) {
    Ipv4Address dst = ToIpv4(coreDest);
    std::vector<QueueEntry> pending;
    m_queue.DequeueAll(dst, pending);

    for (QueueEntry& e : pending) {
        NodeAddress next = m_logic->nextHopForData(coreDest);
        if (next == kInvalidAddress) {
            // Route vanished again; re-queue.
            m_queue.Enqueue(e);
            continue;
        }
        Ipv4Address gateway;
        Ptr<NetDevice> dev;
        uint32_t ifIdx;
        ResolveNextHop(next, gateway, dev, ifIdx);  // #203
        Ptr<Ipv4Route> route = Create<Ipv4Route>();
        route->SetDestination(dst);
        route->SetGateway(gateway);
        route->SetSource(e.header.GetSource());
        route->SetOutputDevice(dev);
        if (!e.ucb.IsNull()) {
            m_everRouted.insert(coreDest);      // #21: this dest has been routed
            m_queue.NoteDelivered(e);           // #21: attribute this packet's hold
            e.ucb(route, e.packet, e.header);
        }
    }
}

void RoutingProtocol::DiscardQueue(NodeAddress coreDest) {
    std::vector<QueueEntry> pending;
    m_queue.DequeueAll(ToIpv4(coreDest), pending);
    // #215: count the packets, not just the event — the core counts the events
    // (repairDiscards()), but only the adapter owns the queue and so knows how
    // many packets each expired repair released.
    m_repairDiscardedPackets += pending.size();
    for (QueueEntry& e : pending) {
        if (!e.ecb.IsNull()) e.ecb(e.packet, e.header, Socket::ERROR_NOROUTETOHOST);
    }
}

// --- timers -----------------------------------------------------------------

void RoutingProtocol::HelloTimerExpire() {
    if (m_logic) {
        // Liveness/maintenance tick first (ADR-0008 detector A) — the only way
        // NS-3 detects neighbour loss — then beacon a hello. The tick returns
        // LinkFail broadcasts and repair-timeout DiscardPending actions (D6).
        ExecuteDecisions(m_logic->onMaintenanceTick(), kInvalidAddress);
        AntMessage hello = m_logic->createHelloAnt();
        SendAnt(hello, Ipv4Address("255.255.255.255"));
    }
    m_helloTimer.Schedule(m_helloInterval);
}

void RoutingProtocol::ProactiveTimerExpire() {
    if (m_logic) {
        // One proactive ant per active data session (empty when proactive is
        // gated off or no session is active), each routed by combined pheromone.
        for (AntMessage& prfa : m_logic->createProactiveAnts()) {
            NodeAddress next = m_logic->selectNextHop(prfa.dst, /*proactive=*/true);
            if (next == kInvalidAddress) {
                SendAnt(prfa, Ipv4Address("255.255.255.255"));
            } else {
                SendAnt(prfa, ToIpv4(next));
            }
        }
    }
    m_proactiveTimer.Schedule(m_proactiveInterval);
}

void RoutingProtocol::ReactiveRetryTimerExpire() {
    // Issue #21: the reconvergence hold — data waiting for a broken route to
    // re-form — dominates the delay/jitter tail. The core only re-emits a
    // reactive ant when a data packet arrives (~1 pkt/s at paper CBR), so a
    // lost first attempt waits a full second. Re-flood discovery here, off the
    // data path, for every destination still holding data with no route. Bounded
    // by the pending queue: once a route forms the packets flush and the
    // destination stops being retried; unreachable destinations age out at
    // QueueTimeout. Mirrors the core's own reactive emission (createForwardAnt +
    // Broadcast), so the ant is the same bounded expanding-ring flood.
    if (m_logic) {
        for (Ipv4Address dst : m_queue.PendingDestinations()) {
            const NodeAddress coreDst = ToCore(dst);
            if (m_logic->nextHopForData(coreDst) == kInvalidAddress) {
                AntMessage refa = m_logic->createForwardAnt(AntType::Reactive, coreDst);
                SendAnt(refa, Ipv4Address("255.255.255.255"));
                // This emission bypasses the core's sendAnt (which fires the
                // observer), so surface it on the Tx trace ourselves to keep the
                // --diag antTx[reactive] tally honest. NRL is counted at the IP
                // layer, so the flood already shows there.
                onAntSent(AntType::Reactive, ::anthocnet::core::AntDirection::Up,
                          /*broadcast=*/true);
            } else {
                // #21 dead spot: a route re-formed without a Deliver or a
                // traversing backward ant (hello-learned neighbour, LinkFail
                // side effect) routes NEW packets fine while the held ones
                // rotted to the 3 s purge. Flush them on the retry cadence.
                FlushQueue(coreDst);
            }
        }
    }
    m_reactiveRetryTimer.Schedule(m_reactiveRetryInterval);
}

// --- MAC transmit-failure hook (ADR-0008 detector D) ------------------------

void RoutingProtocol::NotifyTxError(WifiMacDropReason reason, Ptr<const AHN_WIFI_MPDU> mpdu) {
    // Detector D is a latency optimisation over the mandatory hello-timeout
    // detector A (ADR-0008); it can be gated off for ablation (issue #46).
    if (!m_enableMacFailureDetector) return;
    if (!m_logic || m_socketAddresses.empty() || !mpdu) return;
    // Only a retry-limit drop is a real broken link; other drop reasons
    // (queue full, lifetime expiry) are congestion, not topology.
    if (reason != WIFI_MAC_DROP_REACHED_RETRY_LIMIT) return;

    const Mac48Address dstMac = mpdu->GetHeader().GetAddr1();
    if (dstMac.IsBroadcast() || dstMac.IsGroup()) return;  // no single next hop

    NodeAddress next;
    if (!MapMacToCore(dstMac, next)) return;  // unknown peer — nothing to prune

    // Peek the carried L3 packet: only a failed *data* packet triggers a repair
    // ant (ant control traffic is UDP to ANT_PORT — mirror NS-2, which repairs
    // only non-ant packets). dataDest stays kInvalidAddress if we can't parse it,
    // so we still prune the dead neighbour even when the payload is opaque.
    NodeAddress dataDest = kInvalidAddress;
    Ptr<Packet> pkt = mpdu->GetPacket()->Copy();
    Ipv4Header ipHeader;   // kept for re-injection (#46)
    bool haveData = false;
    LlcSnapHeader llc;
    if (pkt->GetSize() >= llc.GetSerializedSize()) {
        pkt->RemoveHeader(llc);
        if (llc.GetType() == 0x0800) {  // IPv4 EtherType
            Ipv4Header ip;
            if (pkt->GetSize() >= ip.GetSerializedSize()) {
                pkt->RemoveHeader(ip);
                bool isAnt = false;
                if (ip.GetProtocol() == 17) {  // UDP
                    UdpHeader udp;
                    if (pkt->GetSize() >= udp.GetSerializedSize()) {
                        pkt->PeekHeader(udp);
                        isAnt = (udp.GetDestinationPort() == ANT_PORT);
                    }
                }
                if (!isAnt) {
                    dataDest = ToCore(ip.GetDestination());
                    ipHeader = ip;
                    haveData = true;
                }
            }
        }
    }

    // Converge on the shared core path: prune + LinkFail notifications + (for
    // data) a bounded, counted repair ant. ExecuteDecisions broadcasts them.
    ExecuteDecisions(m_logic->reportTxFailure(next, dataDest), kInvalidAddress);

    // NS-2 parity (issue #46): re-inject the failed data packet through the
    // pending queue so it is retransmitted once a route exists, instead of
    // being lost with only the *route* recovering. The MAC trace fires without
    // the routing callbacks, so resume it with the ones cached from RouteInput;
    // queue entries hold the packet without its IP header, matching RouteInput's
    // convention. The immediate flush retries right away when an alternate
    // route survived the prune (FlushQueue re-queues if none did). The retry
    // costs one extra TTL decrement, like any real retransmission path.
    if (haveData && ipHeader.GetTtl() > 1 && !m_cachedUcb.IsNull()) {
        QueueEntry entry;
        entry.packet = pkt;
        entry.header = ipHeader;
        entry.ucb = m_cachedUcb;
        entry.ecb = m_cachedEcb;
        entry.holdReason = HOLD_REPAIR;  // #21: held during local repair (#46)
        ++m_macReinjectedPackets;        // #215: this MAC failure was not terminal
        // #386: same site as the counter, so a listener's event count and
        // MacReinjectedPackets() agree by construction (scenario_check asserts
        // events == reinjected on exactly that ground).
        m_macReinjectTrace(ipHeader, pkt);
        m_queue.Enqueue(entry);
        FlushQueue(dataDest);
    }
}

bool RoutingProtocol::MapMacToCore(const Mac48Address& mac, NodeAddress& out) const {
    if (!m_ipv4 || !m_logic) return false;
    Ptr<Ipv4L3Protocol> l3 = m_ipv4->GetObject<Ipv4L3Protocol>();
    if (!l3) return false;

    // Resolve the failed next-hop MAC to a core address by forward-looking each
    // known neighbour's IP in the per-interface ARP cache and matching its MAC.
    // We use the public Ipv4Interface::GetArpCache() + the stable 1:1 forward
    // Lookup(Ipv4Address) — ArpL3Protocol::FindCache is private and
    // ArpCache::LookupInverse's return type drifts across ns-3 versions.
    const auto& neighbors = m_logic->table().neighbors();
    for (uint32_t i = 0; i < l3->GetNInterfaces(); ++i) {
        Ptr<ArpCache> cache = l3->GetInterface(i)->GetArpCache();
        if (!cache) continue;
        for (NodeAddress nb : neighbors) {
            ArpCache::Entry* entry = cache->Lookup(ToIpv4(nb));
            if (!entry) continue;
            // An entry still resolving (WAIT_REPLY) carries no MAC yet; guard
            // ConvertFrom, which asserts on a non-48-bit address.
            const Address resolved = entry->GetMacAddress();
            if (Mac48Address::IsMatchingType(resolved) &&
                Mac48Address::ConvertFrom(resolved) == mac) {
                out = nb;
                return true;
            }
        }
    }
    return false;
}

// --- helpers ----------------------------------------------------------------

bool RoutingProtocol::IsMyOwnAddress(Ipv4Address src) const {
    for (const auto& kv : m_socketAddresses) {
        if (kv.second.GetLocal() == src) return true;
    }
    return false;
}

Ptr<Socket> RoutingProtocol::FindSocketWithInterfaceAddress(Ipv4InterfaceAddress addr) const {
    for (const auto& kv : m_socketAddresses) {
        if (kv.second == addr) return kv.first;
    }
    return nullptr;
}

int64_t RoutingProtocol::AssignStreams(int64_t stream) {
    m_rng.Stream()->SetStream(stream);
    return 1;
}

void RoutingProtocol::PrintRoutingTable(Ptr<OutputStreamWrapper> stream, Time::Unit) const {
    std::ostream* os = stream->GetStream();
    *os << "AntHocNet routing table for node "
        << (m_ipv4 ? m_ipv4->GetObject<Node>()->GetId() : 0) << "\n";
    if (m_logic) {
        const auto& table = m_logic->table();
        for (NodeAddress dest : table.regularDestinations()) {
            *os << "  dest " << ToIpv4(dest) << " neighbours:";
            for (NodeAddress nb : table.neighbors()) {
                double ph = table.getPheromoneRegular(dest, nb);
                if (ph > 0) *os << " " << ToIpv4(nb) << "(" << ph << ")";
            }
            *os << "\n";
        }
    }
}

} // namespace anthocnet
} // namespace ns3
