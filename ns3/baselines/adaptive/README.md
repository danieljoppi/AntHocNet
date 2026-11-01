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
| `beeadhoc` | BeeAdHoc, Wedde, Farooq et al., GECCO 2005; written from the authors' PG 460 report (2006) | swarm (bee-inspired, source routing) | [#589](https://github.com/danieljoppi/AntHocNet/issues/589) (v2.7.0) |

The four are one module because they share all of their ns-3 plumbing
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

## Shared plumbing (all four arms)

| What | How | Why |
|---|---|---|
| Control traffic | One UDP socket per interface (unicast plus subnet broadcast), TTL 1, ports 5541 / 5542 / 5543 / 5544 | The harnesses count routing control as UDP not addressed to the data port, the same rule as every other arm |
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

## BeeAdHoc — fidelity sheet

Source: H. F. Wedde, M. Farooq (instructors) et al., *BeeAdHoc: an Efficient,
Secure and Scalable Routing Framework for Mobile AdHoc Networks*, Project Group
460 final report, University of Dortmund, 2006 (open:
[hdl 2003/22405](https://hdl.handle.net/2003/22405)). The report describes
three versions: the ns-2 simulation (ch. 3), a formal multi-agent model with
swarms (ch. 4), and a Linux kernel module (ch. 12–13). The arm follows the
**Linux module**, the only one the report specifies down to its data
structures, constants (§14.3.2) and listings. The GECCO 2005 paper
(DOI 10.1145/1068009.1068034) was not available; nothing below rests on it.

| Report | Implementation | Status |
|---|---|---|
| §12.1.2 strict source routing: the source writes the whole route into the packet; intermediate nodes follow it | A `BeeRouteTrailer` (route, 24-bit info field, an optional piggybacked forager) on every data packet; the destination strips it before local delivery | as written; **a trailer, not an IP option**: the application header stays first, so the harness classifies flows unchanged. Its bytes (4 per node + 3 + 2) are on the air, so `nrl_bytes` pays for them |
| a packet this node originates (implementation, not the report) | Never routed in `RouteOutput`: the base bounces it through loopback, AODV's deferred-route pattern, and `OnLoopedBack` puts the trailer onto IP's own copy and sends it on at once when a forager exists (no hold-queue slot); otherwise it is held for a scout | **#800 fix**: adding the trailer to the application's packet changed the size the socket returned, so ns-3's `OnOffApplication` re-sent the same packet; above one packet per on-period this delivered duplicates and inflated PDR (2–3× on the first anchor dispatch). 512 bit/s cells were unaffected (byte-identical before and after) |
| §12.1.2 longest route 10 hops (40 bytes of IP options) | `MaxHops` 10 | as written |
| §12.1.2 / Listing 13.7 each forwarding host shifts the 24-bit info field left 3 bits and writes its 3-bit battery level | Same, at every intermediate hop; the battery is the harness's energy accounting (`--energyJ`), read through an energy probe (#801) | as written. **Bins**: the listing gives ≤ 9 % → 0, (9, 14] → 1 and > 65 % → 7 and elides the rest; levels 2–6 split (14, 65] into five equal bins of 10.2 % (**interpolation**). **Accounting only**: a node at 0 % keeps transmitting (`docs/benchmarks/metrics.md`). At the default 5000 J no node falls below about 79 % in a 900 s run, so every level reads 7; lower `--energyJ` to exercise the rating. With `--energyJ=0` every node reports 7 |
| §12.1.3 INPUT chain: every delivered packet is a forager that can find its way back to its source | The destination stores the reversed route as a 'foreign' forager for the source | as written |
| Listing 13.15 rating: direct neighbour `MAX_DANCES`, else ((MAXHOPS − (len − 1)) · min · avg + 1) / 44 | Same, integer arithmetic; `len` read as links and the values as the intermediate hops'; capped at `MAX_DANCES` (`CapDances`, default on) | **`len` in links: settled** by the §13.4 `/proc` dump (Listing 13.19): a 4-link route `29 28 30 25` rates 7 at full battery, and the dump shows 5–6 after one or two dances (#807). **Values: one short.** The dump's `Info: fff` carries 4 values for 3 intermediate nodes, so one endpoint also writes its level; which one the report does not say. Inert while every level reads 7 (#801); to settle before an energy anchor (#800). **The cap: unresolved.** The listing does not cap, which would rate a 2-hop route (10) above a direct link (8); `CapDances=false` is the listing as printed, measured in #806 |
| Listing 13.17 a random forager; still dancing (dances left, younger than `FORAGER_DANCETIME`) → copied, dances − 1; otherwise used up; older than `FORAGER_LIFETIME` → discarded unless the last | Same (`ForagerStore::Take`) | as written; lifetime 2 s, dance time 2 s, max dances 8 (§14.3.2) |
| §13.7.1 'own' foragers are used first, 'foreign' ones when none are left | Same | as written |
| §13.7.1 with two-way traffic the foragers ride home on the reply traffic | One foreign forager piggybacked per data packet toward its owner | **one per packet is a repository choice**: the report says only that they are piggybacked |
| §13.7.2 Listing 13.30: a swarm leaves when foreign foragers > `SWARMSIZE` and own < `SWARMSIZE_OWN` | Same; `SWARMSIZE` (20) foragers in one source-routed packet, unpacked at home with routes reversed | as written (20, 11) |
| §13.5 scout: broadcast, each node appends itself, a seen list of (source, destination, id), the destination reverses the route and unicasts the scout back (mode 2), the source turns it into a forager | Same; relays jittered by U[0, 10 ms) (§3.4 adds a random delay, no value given) | as written; seen list 30 entries (`SCOUTLISTLENGTH`); jitter **not given** |
| §13.5 expanding ring search: no scout back within `SCOUTRESENDRATE` → another scout with a new id and a wider TTL | Resend after 500 ms, TTL 2 → 4 → 8 → 10, two rounds at 10, then the held packets are dropped | 500 ms as written (500 jiffies at HZ = 1000); **initial TTL, growth and the give-up are not given** |
| `IPT_BEEADHOC_ARRAYSIZE`, `MAXAGE` (forager array size, garbage collection) | 64 foragers per destination and kind; no separate age-out (the lifetime rule discards on use) | **not given** |
| three forager types (energy, delay, throughput) | one (energy) | **deviation**: the Linux module collects only energy (§13.3) |
| a failed next link | The packet is dropped (booked as a route drop); every forager over that link is removed (`RemoveForagersOnLinkFailure`, default on); the source picks another route for its own packet | **no salvage is described**; the removal is a repository choice, measured in #806 (on the smoke cell, #805's `##HOLD##` puts 93–95 % of the arm's delay in source re-scouting) |
| ns-2 dance floor, packers, swarm leader / recruiter (ch. 3–4) | not implemented | the Linux module replaces them with the forager array and the swarm trigger |
| BeeGuard / security (ch. 8–11) | not implemented | out of scope here; v3.2.0's BeeSec/BeeAIS arms build on this one |

Delivery smoke (ns-3.42, `--scenario=paper --nNodes=20 --time=60`):
UDP, two seeds, PDR 93.4 % (AODV 90.7 %), drop book sum 100.00; TCP, one
seed, 95.5 % (AODV 94.0 %), sum 100.01.

Sensitivity of the repository choices (#806, pre-registered in
`tools/bench/campaigns/v2.7.0-beeadhoc-sensitivity.yaml`, generation `v270b`):
`grid-rwp-tworay`, 50 nodes, 900 s, seeds 1–10, each arm paired by seed with
the defaults (PDR 95.04 %, mean delay 52.8 ms, NRL 10.64). An effect counts
when its paired 95 % CI excludes zero (marked \*).

| arm (one change) | dPDR (pp) | d mean delay (ms) | d NRL |
|---|---|---|---|
| first scout at TTL 10, no expanding ring (`InitialScoutTtl=10`) | −0.75 [−1.41, −0.09]\* | **−28.5 [−29.9, −27.1]\*** | +4.31 [+3.78, +4.85]\* |
| give up after one round at full TTL (`MaxRoundsAtMaxTtl=1`) | −0.27 [−0.89, +0.35] | −2.4 [−4.6, −0.1]\* | +0.07 [−0.51, +0.65] |
| give up after four rounds (`MaxRoundsAtMaxTtl=4`) | +0.13 [−0.44, +0.70] | +2.1 [−0.3, +4.5] | 0.00 [−0.48, +0.48] |
| keep foragers on a failed link (`RemoveForagersOnLinkFailure=false`) | +0.14 [−0.34, +0.62] | −0.6 [−2.5, +1.2] | −0.21 [−0.60, +0.18] |
| uncapped rating (`CapDances=false`) | identical: the cap never binds | | |

**The expanding ring's starting TTL decides the arm's delay.** With it, the
mean delay is 52.8 ms; without it, 24.3 ms (the source's `reconv` hold falls
from 156 to 49 ms), at +4.3 control packets per delivered packet. For scale,
on the same cell and seeds AODV's committed rows read 36.1 ms and NRL 33.4,
so the choice flips BeeAdHoc's delay ranking against AODV. The report
specifies an expanding ring search (§13.5) but not its starting TTL, so the
default stays, and any comparison must report both settings with this table.
The other choices move nothing that matters (giveup1's −2.4 ms is real but
small).

Anchor (#800, pre-registered in `tools/bench/campaigns/v2.7.0-beeadhoc-anchor.yaml`,
generation `v270a`): on the source we hold, PG 460 ch. 7, the AntHocNet
scalability setup (100 nodes, 3000 × 1000 m, 900 s, 20 flows at 4 packets/s,
RWP 0–10 m/s, pause 1–1000 s), against AODV and DSDV (no DSR arm), 10 seeds,
in both ring settings. Gate: BeeAdHoc's NRL below both at ≥ 4 of 5 pause times
(§7.2.5, also GECCO's headline); energy, delay, PDR and throughput reported.
Deviation: 64-byte data packets instead of 512 (same packet rate). A miss
ships the arm as an infeasibility verdict. Re-checking against the GECCO 2005
paper itself, once in hand, is #815.

## ns-3 version notes

`CMakeLists.txt` defines `ADAPTIVE_NS3_ROUTEINPUT_BYVALUE` (ns-3 ≤ 3.36:
`RouteInput` callbacks by value, `WifiMacQueueItem`) and
`ADAPTIVE_NS3_SCOPED_TEST_ENUMS` (≥ 3.42), the gpsr/oracle pattern. The
public header falls back to probing `ns3/wifi-mpdu.h` for out-of-module
includers. The unit tests (`./test.py -s adaptive`) check the table
arithmetic, the selection rules and the header round trip against
hand-computed values, and BeeAdHoc's route rating, forager store and packet
formats the same way.
