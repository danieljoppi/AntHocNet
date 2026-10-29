# Adaptive-routing comparator module — provenance and fidelity sheets

The v2.5.0 comparators ([#563](https://github.com/danieljoppi/AntHocNet/issues/563)):
one ns-3 module, `contrib/adaptive`, holding three arms of the
`anthocnet-compare` harness. Each is **written from its paper**. None is a
port: no maintained ns-3 implementation of any of them exists.

To use the module on its own, or to write another arm on its `RoutingBase`,
see the user guide [`docs/comparison-harness.md`](../../../docs/comparison-harness.md):
the base class's hooks and services, how to wire an arm into the harness, and the
three gates before an arm's numbers count.

| arm | protocol | family | issue |
|---|---|---|---|
| `ara` | ARA, Güneş, Sorges, Bouazizi, IWAHN 2002 | swarm (reactive ACO) | [#586](https://github.com/danieljoppi/AntHocNet/issues/586) |
| `termite` | Termite, Roth & Wicker, GLOBECOM 2003 / Roth 2005 | stigmergic | [#587](https://github.com/danieljoppi/AntHocNet/issues/587) |
| `qrouting` | Q-routing, Boyan & Littman, NIPS 6 (1994) | learned (tabular) | [#588](https://github.com/danieljoppi/AntHocNet/issues/588) |

The three are one module because they share all of their ns-3 plumbing
(`model/adaptive-routing-base.{h,cc}`), and none of it is routing policy. Each
arm is its own class, with its own TypeId, attributes and UDP port. None
shares code with the AntHocNet adapter or `core/`. The #244 ablation
(AntHocNet with proactive and repair ants off) complements `ara`. It is never
reported as ARA.

Before any arm's numbers count, it must clear three gates (AGENTS.md
"conventions"): this fidelity sheet, the per-PR delivery smoke
(`tools/checks/check-arm-delivery.sh`, #439), and an anchor reproducing its own
paper's headline trend. The anchors are pre-registered and run separately;
their verdicts land on each arm's issue and on the v2.5.0 comparator page.

## Shared plumbing (all three arms)

| What | How | Why |
|---|---|---|
| Control traffic | One UDP socket per interface (unicast plus subnet broadcast), TTL 1, ports 5541 / 5542 / 5543 | The harnesses count routing control as UDP not addressed to the data port, the same rule as every other arm |
| No route yet | The packet is bounced through loopback and held with its forwarding callbacks: 64 packets, 30 s (ns-3 AODV's defaults); dropped through the error callback, which FlowMonitor books as a route drop | The AODV pattern, so held-packet loss lands in the same drop column for every arm |
| Previous hop | The sender stamps a `PrevHopTag` (its address and its upstream) on every data packet | All three papers learn per neighbour from data. A real node reads the sender from the link-layer source address, which ns-3's `RouteInput` does not expose. A tag adds no bytes, like the MAC address it stands in for |
| Link failure | WifiMac `DroppedMpdu` at the retry limit, resolved to the neighbour's IP through the ARP cache | ARA §3.3 ("missing acknowledgement"), Termite's lost neighbour. Same detector as the AntHocNet adapter's ADR-0008 detector D |
| The packet under a failed link | Recovered from the MPDU and re-routed by the arm, counted as `reinjected` so the harness's drop book nets it out of the MAC column | ARA §3.3 and Termite both resend on a remaining link |
| Randomness | One `UniformRandomVariable` per node, pinned by `AdaptiveHelper::AssignStreams` | #352 seed independence |

## ARA — fidelity sheet

Source: M. Güneş, U. Sorges, I. Bouazizi, *ARA – The Ant-Colony Based Routing
Algorithm for MANETs*, Proc. ICPP Workshop on Ad Hoc Networks (IWAHN 2002),
pp. 79–85. Full text read (7 pp.). Section numbers below are the paper's.

| Paper | Implementation | Status |
|---|---|---|
| §3.1 FANT flooded from the source, unique sequence number, duplicates (source + seq) destroyed | Same; relays jittered by U[0, 10 ms) | as written (jitter: implementation detail, AODV's) |
| §3.1 a node seeing a FANT for the first time records (source, previous node, φ = f(hops)) | φ raised to at least `1/hops` | **f not given**: inverse hop count, so the shorter trail is the stronger |
| §3.1 destination answers with a BANT that "has the same task" toward the destination | The BANT retraces the FANT's path: each node remembers the neighbour its first FANT copy came from, and the BANT, carrying the FANT's sequence number, is unicast back hop by hop, setting φ toward the destination at each hop | **path not stated in the 2002 paper**: the ARA reviews read it as "sent back along the path it came" (Arif & Rani 2012), and Roth 2005 §3.5.2 describes ARA's backward ant as returned along the forward path. A first implementation flooded the BANT; its duplicate copies laid backward trails and looped |
| §3.2 data relayed toward D over j adds Δφ to (D, j); the receiver adds Δφ to (S, previous hop) | Same, at every hop including the destination | as written |
| eq. 2 evaporation φ := (1 − q)·φ, applied periodically | Same law, evaluated continuously (lazily, on read) | **q, period not given**: q = 0.1 per 1 s |
| Δφ | 0.1 | **not given** |
| A route has evaporated | φ < 0.01 (a 1-hop trail with no data lasts ~44 s, a 10-hop one ~22 s) | **not given** |
| §3.2 duplicate data packet (source + seq) → DUPLICATE_ERROR flag, sent back, previous node deactivates the link | Key (source, destination, IP identification). The packet is sent back carrying a `BacktrackTag`; the receiver erases (D, sender) and routes it again | as written; the flag rides as a tag (the paper gives no format) |
| §3.3 missing acknowledgement → φ = 0 for that link, alternative link, else back to the previous node, backtracking toward the source; the source re-discovers | Same; a MAC failure erases the neighbour for every destination. A next hop that never answers ARP (it left before any frame reached the MAC) is the same failure one layer earlier and is handled the same way | as written. Without the ARP case a one-seed 20 m/s paper run lost 52 % of packets with no MAC drop at all: trails learned from broadcast ants carry no ARP entry |
| next hop ∝ φ (§2.2, §3.4 "multi-path") | Proportional draw. **Not straight back to the previous hop while another trail exists** | **deviation**: the paper only says loops are caught by duplicate detection. Returning to the previous hop is a certain duplicate error, which costs a hop to learn |
| Discovery retries | FANT re-sent after 2.8 s, doubling, 2 retries, then the held packets are dropped | **not given**: ns-3 AODV's NetTraversalTime / RreqRetries, so the two reactive arms wait alike |
| §3.4 sleep mode | not implemented | out of scope (a power feature) |

Anchor scenario (§4.1–4.2): 50 nodes, 802.11, 1500 m × 300 m, random waypoint
up to 10 m/s, 900 s, pause {0, 30, 60, 120, 300, 600, 900} s, 10 CBR
connections, ns-2. Headline trend against AODV: at high mobility (pause
0–100 s), ARA delivers more than AODV (> 95 % vs below 95 %) at lower
routing overhead in bits. At low mobility, ARA's overhead is slightly above
AODV's.

## Termite — fidelity sheet

Source: M. H. Roth, *Termite: A Swarm Intelligent Routing Algorithm for Mobile
Wireless Ad-Hoc Networks*, PhD dissertation, Cornell University, 2005,
chapter 4 (supplied by the maintainer; `papers` library). Section and table
numbers below are the dissertation's. The GLOBECOM 2003 paper (Roth & Wicker)
is the same algorithm's first report and was not obtained.

| Dissertation | Implementation | Status |
|---|---|---|
| §4.2.2 every packet arriving at i from r with source s: P(r, s) ← P(r, s) + γ | Same, for data, every control type and overheard packets | as written |
| γ | 1 | **not in Table 4.1**: equal to the initial pheromone |
| decay P ← P·e^{−(t − t_last)·τ}, τ = 0.105 per 1 s period | Same law, evaluated continuously | as written (Table 4.1) |
| §4.2.4 initial pheromone 1, floor 0.1, ceiling 10000: a new destination's column and a new neighbour's row start at the initial value; no cell below the floor or above the ceiling | Same (`BoundedPheromoneTable`) | as written (Table 4.1) |
| §4.2.3 a destination is forgotten when its column has decayed to the floor; a neighbour when its row has; a lost neighbour's row is removed at once | Same, checked every second; a lost neighbour is a MAC retry-limit drop or an unanswered ARP | as written |
| eq. 4.3 p(n, d) = (P(n,d) + K)^F / Σ_{j ∈ N − r} (P(j,d) + K)^F, never back to the arrival link | Same | as written |
| K | 0 | as written (§4.2.5 "nominal value of K is zero") |
| F | 10 | **not in Table 4.1**: §5.4 finds high sensitivities best, and §7.3 runs F = 10 |
| §4.2.6 unknown destination: buffer, send RREQs on a uniform random walk (never back to the arrival link, pheromone ignored); a node with any pheromone for the destination replies; no reply within the rreq timeout → the buffered packets are dropped | Same: 2 RREQs per request, rreq timeout 2 s, TTL 32 | as written (Table 4.1) |
| RREP's source is the requested destination, routed to the requester by eq. 4.3 | Same | as written |
| hello only while isolated, every hello period, until a reply; every hearer replies | Same: hello period 1 s, replies jittered by U[0, 10 ms) | as written (jitter: implementation detail) |
| seed: a short random walk advertising its origin | Every 30 s per node, TTL 4, phase drawn uniformly at start | as written (Table 4.1) |
| neighbours gained by overhearing | Promiscuous reception of data (via its `PrevHopTag`) and control | as written |
| data TTL 32 | the harness's IP TTL (64) | **deviation**: the data TTL belongs to the traffic generator, which every arm shares |
| control packets at high priority (slides) | one MAC queue | **deviation** |
| §4.4.1 traffic: every data packet is acknowledged by its destination | the harness's traffic, one-way CBR in the families | **not a protocol choice, but it matters**: with one-way traffic a sink never sends, so the trail toward it comes only from route replies and seeds, and decays to the floor in about 22 s. Data then random-walks to its TTL. On the 16-node static smoke Termite delivers 19.6 % this way, against 85.6 % for an earlier version that kept sinks known with a periodic hello the dissertation does not have. The anchor uses acknowledged (TCP) traffic, as Roth's did |

Anchor (§7.3, the comparison with AODV; that chapter's ReTermite adds a
pheromone repel term R and its own constants): 100 nodes, 2200 × 600 m,
802.11b at 2 Mbit/s, 250 m range, random waypoint with zero pause, speeds
1/5/10/20 m/s, 600 s, 10 flows, each packet acknowledged. Trend: ReTermite
delivers at least 95 % and AODV at least 90 %; ReTermite degrades more
gracefully with speed. This arm is chapter-4 Termite with Table 4.1
constants, so it is held to the qualitative trend, not to ReTermite's
numbers.

## Q-routing — fidelity sheet

Source: J. A. Boyan, M. L. Littman, *Packet Routing in Dynamically Changing
Networks: A Reinforcement Learning Approach*, NIPS 6 (1994), pp. 671–678.
Full text read.

| Paper | Implementation | Status |
|---|---|---|
| Q_x(d, y): estimated delivery time from x to d via neighbour y, x's queueing included | A table per (destination, neighbour), in seconds | as written |
| upon sending P to y, x gets back t = min_z Q_y(d, z) | y sends a one-hop `QR_ESTIMATE` control message for every data packet it receives (t = 0 at the destination) | **deviation in cost**: the paper's estimate is free. Here it is a real transmission per data hop, which the harness counts as overhead |
| ΔQ = η (q + s + t − Q), η "usually 0.5" | η = 0.5 | as written |
| q (queue time at x) + s (transmission time) | Measured at x from handing the packet to the MAC until its 802.11 acknowledgement (`AckedMpdu`). This includes MAC retries. If the ack is not matched, the measurement runs until the estimate arrives | as written, measured locally |
| greedy policy (smallest Q) | Same; ties broken uniformly at random | as written ("full echo" and random exploration are §3.2 variants, not compared) |
| initial Q | 1 s for an untried (d, y); 0 when y is d. Greedy keeps a route that works and tries an unknown neighbour only when every known one is worse | **not given**: an optimistic 0 was tried first. With it, every node reports t = 0 while any neighbour is untried, so no gradient toward the destination forms (67.7 % on the delivery smoke, against 99.3 % at 1 s) |
| links known in advance (wired) | Hello every 1 s; a neighbour not heard for 3 s, or failed at the MAC, leaves the table with its column | **addition** forced by the medium |
| no route discovery | None: a node with no neighbour holds the packet until a hello arrives | as written |

Anchor (§3): on a static, irregular topology under low load, Q-routing learns
to route about as well as shortest paths. Under high load it beats shortest
paths, which congests the central nodes. The anchor runs the repo's static
mesh against the oracle arm (global shortest path) at low and high offered
load.

## ns-3 version notes

`CMakeLists.txt` defines `ADAPTIVE_NS3_ROUTEINPUT_BYVALUE` (ns-3 ≤ 3.36:
`RouteInput` callbacks by value, `WifiMacQueueItem`) and
`ADAPTIVE_NS3_SCOPED_TEST_ENUMS` (≥ 3.42), the gpsr/oracle pattern. The
public header falls back to probing `ns3/wifi-mpdu.h` for out-of-module
includers. The unit tests (`./test.py -s adaptive`) check the table
arithmetic, the selection rules and the header round trip against
hand-computed values.
