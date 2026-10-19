# GPSR baseline module — provenance and port notes

Vendored GPSR (Greedy Perimeter Stateless Routing, Karp & Kung, MobiCom 2000)
baseline for the AntHocNet comparison harness —
[#296](https://github.com/danieljoppi/AntHocNet/issues/296) item 3, built to
the spike verdict recorded on that issue.

## Provenance

- **Source**: <https://github.com/dwosion/ns3.29-with-gpsr>, commit
  `15241ef715d52627ff7679a5fca6b6d15eaa8cd4`, path `ns-3.29/src/gpsr`
  (model, helper). The separate `ns-3.29/src/location-service` module was
  **not** vendored; its GOD service (~30 lines: a NodeList + MobilityModel
  scan) is inlined as `RoutingProtocol::GetGodPosition`. The seven
  `examples/gpsr-test*.cc` scenarios, the template `doc/gpsr.rst` and the
  stub test suite were not vendored either.
- **Lineage**: that tree is the ns-3.29 refresh of António Fonseca's 2011–12
  GPSR port (<https://codereview.appspot.com/5401042>); the helper files
  carry his GPLv2 headers (Copyright 2009 IITP RAS, authors Fonseca / Boyko,
  written after OlsrHelper).
- **License**: GPLv2. The vendored tree distributes the module inside a stock
  ns-3.29 tree whose `LICENSE` is GNU GPL v2; `gpsr-helper.{h,cc}` carry
  explicit GPLv2 notices; the model files (headerless in the source) are
  visibly derived from ns-3's GPLv2 `src/aodv` (deferred-route loopback
  machinery, request queue). Matches this repository's `GPL-2.0-only`.
- **Not used**: [PA-GPSR](https://github.com/CSVNetLab/PA-GPSR) publishes no
  license anywhere and therefore was not copied from — not one line. Its
  fixes were not merged; where this port fixes something PA-GPSR also fixed,
  the fix is re-derived (noted per file).

## Port changes (ns-3.29 → ns-3.36–3.48)

The three faults named by the #296 spike verdict:

1. **`TxErrHeader` → `DroppedMpdu`** (`gpsr.cc NotifyInterfaceUp/Down`,
   `NotifyTxError`; `gpsr-ptable.{h,cc}`): the vendored code subscribed the
   position table's callback to the WifiMac `TxErrHeader` trace, which ns-3
   removed — and the handler body was an empty stub. The port subscribes
   `RoutingProtocol::NotifyTxError` to the modern `DroppedMpdu` trace
   (tolerant connect, like the anthocnet adapter's detector D): a unicast
   frame dropped for `WIFI_MAC_DROP_REACHED_RETRY_LIMIT` names a dead
   neighbour, resolved MAC→IP by forward `ArpCache::Lookup` per known
   neighbour (`LookupInverse`'s signature drifts across versions), which is
   then removed from the position table — the MAC-feedback neighbour removal
   GPSR §3.2 specifies, implemented from the paper and the anthocnet
   adapter's pattern, not from PA-GPSR.
2. **`AssignStreams` added** (`gpsr.{h,cc}`, `gpsr-helper.{h,cc}`): the
   vendored code drew hello jitter from `UniformRandomVariable` objects
   constructed per call, whose stream numbers depend on construction order in
   the process — exactly the #352 failure class. The port uses one member RNG
   pinned by `RoutingProtocol::AssignStreams(int64_t)` and a
   `GpsrHelper::AssignStreams(NodeContainer, int64_t)` wrapper mirroring
   `AodvHelper`, so the harness's per-seed stream pinning covers the gpsr arm.
3. **FlowMonitor-safe position-header layering** (`gpsr.cc AddHeaders`,
   `Forwarding`, `RecoveryMode`, `SendPacketFromQueue`, `RouteInput`): the
   vendored down-target hack prepended `TypeHeader|PositionHeader` to the UDP
   datagram, producing `IP|GPSR|UDP` on the wire while `ip.protocol` still
   read 17. `Ipv4FlowClassifier` reads the first four bytes of the IP payload
   as ports, so data flows classified on position bytes that change as nodes
   move. The port strips the UDP header, adds the same GPSR headers beneath
   it, and puts the UDP header back (`IP|UDP|GPSR`): identical bytes on the
   wire, identical routing state and decisions, but the IP payload now starts
   with the real transport header, so FlowMonitor classifies data flows
   correctly and port-based accounting sees GPSR's port-666 hellos as
   control. ns-3's `UdpHeader` recomputes its length field from the buffer at
   serialize time; global checksums must stay disabled (the ns-3 default —
   the stored checksum is not refreshed). Only UDP is wrapped (the down
   target is only re-pointed for `UdpL4Protocol`, as in the source); non-UDP
   packets are forwarded greedily from GOD positions without per-packet
   recovery state, and dropped as routeless if greedy fails.

Mechanical/compile changes, each marked `Port change`/`Port fix` in place:

- C++17: `std::bind2nd`/`std::ptr_fun` → lambda (`gpsr-rqueue.cc`).
- Removed API: `Ipv4Address::IsEqual` → `==`; the two call sites also
  dereferenced the `end()` iterator when the address was absent
  (`gpsr-ptable.cc AddEntry`, `isNeighbour`).
- Version gates in `CMakeLists.txt`, mirroring the anthocnet module:
  `GPSR_NS3_ROUTEINPUT_BYVALUE` (RouteInput callbacks by value ≤ 3.36) and
  `GPSR_NS3_WIFI_QUEUE_ITEM` (WifiMacQueueItem vs WifiMpdu in the
  `DroppedMpdu` trace, ≤ 3.36).
- The `LocationServiceName` enum attribute is gone with the location-service
  module (GOD was the only implemented value; RLS printed "not yet
  implemented"). Sidesteps the `MakeEnumAccessor` template drift entirely.
- The first hello is scheduled in `Start ()`, not `SetIpv4 ()`
  ([#717](https://github.com/danieljoppi/AntHocNet/issues/717)): `SetIpv4`
  runs inside `InternetStackHelper::Install`, before the harness pins the
  stream, so its draw came from ns-3's process-global auto-stream counter and
  every GPSR run depended on the runs before it in the same process.
- `CheckQueueTimer` is constructed `Timer::CANCEL_ON_DESTROY` (the vendored
  default-constructed Timer asserts if still scheduled at teardown).
- `TypeHeader`'s default argument moved to the declaration;
  `GpsrHelper::Install(NodeContainer)` overload added (the global-container
  form mis-scopes when one process runs many simulations, as the comparison
  harness does).
- Wire formats (`gpsr-packet.{h,cc}`) are untouched: hello =
  1 B type + 16 B position; per-data-packet overhead = 1 B type + 53 B
  position header, exactly as in the source.

## Behaviour notes for the harness

- GPSR is geographic: position knowledge comes from the mobility model via
  the GOD location service, the same way the dwosion examples run it. The
  harness supplies nothing beyond installed `MobilityModel`s; no measurement
  hooks live in this module.
- `GpsrHelper::Install(nodes)` must run after
  `InternetStackHelper::Install` — it re-points the UDP down target that adds
  the per-packet position header.
- Hellos every 1 s ± 0.5 s jitter, TTL 1, UDP port 666; neighbour lifetime
  2 s; greedy next-hop, right-hand-rule recovery (`PerimeterMode` attribute
  present but, as in the source, the recovery path runs regardless).

## GPCR mode (#709) — fidelity sheet

`--protocols=gpcr` runs this module with `Gpcr=true`: Greedy Perimeter
Coordinator Routing, the street-grid answer to GPSR's failure at corners
(Lochert, Mauve, Füßler & Hartenstein, "Geographic routing in city scenarios",
ACM SIGMOBILE MC2R 9(1):69–72, 2005; the 2004 MobiCom poster of the same
title). It is the VANET family's junction-aware geographic comparator under
[ADR-0026](../../../docs/adr/0026-baselines-are-family-native.md). With
`Gpcr=false` (the default) nothing below runs and the gpsr arm is unchanged.

| element | the paper | this implementation |
|---|---|---|
| beacons, positions | position beacons; positions from a location service | the module's own: hellos every 1 s ± 0.5 s, GOD positions (as GPSR here) |
| coordinator role | "A coordinator broadcasts its role along with its position information" (§III.A) | one byte after the hello header, GPCR mode only |
| junction detection | §IV: two tests, neighbour tables (NT) and the correlation coefficient (CC); "GPCR simply uses the correlation coefficient" | CC: \|ρxy\| of the neighbours' positions; a coordinator iff \|ρxy\| < ε. Fewer than three neighbours, or a neighbour set on one axis-parallel line (σ = 0), reads as a street |
| ε | "a very large value ε = 0.?" | **0.9, attribute `GpcrCorrelationThreshold`.** The digit is illegible in both available copies (a Type3 math glyph with no usable mapping); 0.9 is the smallest one-digit reading of "very large" (maintainer decision 2026-10-19) |
| on a street | neighbours "whose positions approximate an extension of the line between the forwarding node's predecessor and the forwarding node itself" qualify; a qualified coordinator at random, else the farthest qualified neighbour (§III.A) | as written; "approximate" is a **±30° cone** around the predecessor→forwarder bearing, attribute `GpcrStreetConeDeg` (the paper gives no tolerance; repo choice, maintainer decision 2026-10-19). The random pick draws from the module's pinned RNG |
| at a coordinator | "the neighboring node with the largest progress towards the destination is chosen" (§III.A) | GPSR's greedy choice; a packet just originated (no predecessor) takes it too |
| local optimum | switch to the repair strategy | as GPSR here: the recovery state travels in the position header |
| repair | right-hand rule over streets at junctions: "the street that is the next one counter-clockwise from the street the packet has arrived on"; greedy-to-the-next-junction between them; back to greedy once closer to the destination than where repair began (§III.B) | the right-hand rule over a coordinator's neighbours (each stands on one of the streets meeting there); the street rule between junctions, the right-hand rule at a dead end; the module's existing "closer than the recovery point" switch back |
| not implemented | the NT test, NT AND/OR CC (§V: AND "outperforms the other approaches slightly but it does not come for free"), the future-work probing of street connectivity | — |

**Anchor.** The paper's headline trend is that GPCR delivers more than GPSR on
a city grid, at the cost of more hops ("This improvement in performance comes
at the expense of a higher average number of hops and a slight increase in
latency", §V). The `vanet-gpcr-vs-gpsr` anchor checks that direction on the
street grid.
