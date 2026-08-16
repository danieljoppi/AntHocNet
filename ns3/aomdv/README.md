# AOMDV baseline module — provenance and license

Vendored multipath on-demand baseline for the [#296](https://github.com/danieljoppi/AntHocNet/issues/296)
oracle-phase comparison (epic item 2). This module is a **baseline for the
benchmark harness only** — it is not part of the AntHocNet protocol, carries no
AntHocNet measurement hooks, and follows the layout/build conventions of the
`anthocnet` contrib module next door.

## Construction (write-minimal port, per the #296 spike verdict)

The port is **stock ns-3.36 `src/aodv` rebased with the AOMDV delta** from the
CharithaS fork, exactly as the
[feasibility spike](https://github.com/danieljoppi/AntHocNet/issues/296#issuecomment-5245550798)
prescribed:

- **Base**: `src/aodv` at tag `ns-3.36` of
  https://github.com/nsnam/ns-3-dev-git (GPLv2, Copyright IITP RAS 2009).
- **AOMDV delta**: `src/aomdv` of
  https://github.com/CharithaS/Implementation-of-AOMDV-Routing-Protocol-in-ns-3
  at commit `54594e24daf7688bdcdb6a696bf821a08fd2d06a` (2017-06-17, the fork's
  HEAD; an ns-3.26 tree). The delta was computed as (stock ns-3.26 aodv → fork
  aomdv) after normalising the mechanical `aodv→aomdv` rename, then re-applied
  onto stock ns-3.36 aodv by three-way merge (~1,540 changed delta lines,
  concentrated in `routing-protocol` and `rtable` — matching the spike's
  measured ~1,250-line estimate).
- **Helper and id-cache test**: stock ns-3.36 `aodv-helper` /
  `aodv-id-cache-test-suite` mechanically renamed (the fork ships neither).
  `AomdvHelper::AssignStreams` and `aomdv::RoutingProtocol::AssignStreams` are
  inherited from the stock base, so the harness's #352 RNG stream pinning works
  on this arm like on stock aodv.

## License verdict

**GPLv2 throughout — compatible with ns-3 (GPLv2) and this vendoring.**
Evidence:

- The CharithaS repository is a full ns-3.26 tree carrying ns-3's root
  `LICENSE` (GNU GPL v2).
- Every `src/aomdv` source file carries the GPLv2 header of its stock aodv
  parent (Copyright 2009 IITP RAS; authors Buchatskaia/Boyko), with the model
  provenance lines: NS-2 AOMDV by the CMU/MONARCH group, tuned by Samir Das and
  Mahesh Marina (University of Cincinnati); AOMDV-UU by Erik Nordström
  (Uppsala University).
- The stock ns-3.36 aodv base is GPLv2 (same headers).

All original copyright headers are preserved in the vendored files.

## What was changed relative to the fork (and why)

- **`TxErrHeader` → `DroppedMpdu`**: the fork's ns-3.26 MAC-failure hook used
  the removed `TxErrHeader` trace; the rebase inherits stock ns-3.36's
  `DroppedMpdu` + `WifiMacQueueItem` path for free (the spike's known API fix).
- **Cross-version gates** for the CI matrix (ns-3.36/3.41/3.42/3.47/3.48),
  mirroring the anthocnet module's macros: `AOMDV_NS3_ROUTEINPUT_BYVALUE`
  (RouteInput callbacks by-value ≤3.36, const-ref 3.37+),
  `AOMDV_NS3_WIFI_QUEUE_ITEM` (`WifiMacQueueItem`→`WifiMpdu` rename in 3.37),
  `AOMDV_NS3_SCOPED_TEST_ENUMS` (scoped TestSuite/TestCase enums 3.42+).
- **3.36-base behaviours kept over fork regressions**: the fork (being
  3.26-based) predates several stock aodv fixes; the rebase keeps the 3.36 side
  wherever the fork's difference was not AOMDV semantics — notably the
  `(IsAlive() || IsPermanent())` ARP-entry check in `aomdv-neighbor.cc`, the
  socket bind order in `NotifyInterfaceUp`, and the AODV-port broadcast
  short-circuit in `RouteInput`.
- **Two trivial leak fixes** in `aomdv-id-cache.cc` (`new AOMDVRoute` +
  `push_back(*route)` → value `push_back`), behaviour-identical.
- **Nine fork defects fixed** (the fork is a 2017 course assignment,
  single squashed commit, no example or validation; these made it structurally
  unable to route — the value-semantics port lost ns-2's pointer-aliased
  routing table, the same defect class as CONTEXT.md §6 items 1–2):
  1. `RoutingTableEntry`'s constructor accepted `dst` but never stored it —
     `m_dst` stayed default-initialized, breaking the destination-keyed table
     and every path's `Ipv4Route` destination. Fixed with `m_dst (dst)` in the
     init list (`aomdv-rtable.cc`).
  2. Paths were inserted into **local copies** after `AddRoute`/`Update`/
     `LookupRoute` (which copy), so no table entry ever carried a path and
     `PathFind()` dereferenced `begin()` of an empty vector (UB). Fixed
     mechanically at each site — `PathInsert` before `AddRoute` for fresh
     entries, one `m_routingTable.Update (…)` after each mutated looked-up
     copy (`RecvRequest`/`RecvReply`) — every site carries a
     `// Vendoring fix (#296)` comment; no routing logic was changed.
  3. `UpdateRouteToNeighbor` read an uninitialized `bool validPath` when the
     neighbor entry had no matching path; now initialized to `false`.
  4. `PathInsert` returned `&path` — the address of the function-local copy,
     dead on return — so every caller that kept the pointer
     (`RecvRequest`/`RecvReply`) wrote through a dangling stack address. GCC
     proves it (`-Wreturn-local-addr`) and the matrix's ASan leg would report
     stack-use-after-return. Now returns `&m_pathList.back ()`, the element
     actually stored (`aomdv-rtable.cc`), which is what ns-2 AOMDV returned.
  5. `RecvReply`'s same-sequence-number branch wrote
     `if (forwardPath == toDst.PathLookupDisjoint (…))` where its own sibling
     in `RecvRequest` — and ns-2 AOMDV — assigns. `forwardPath` is still
     `NULL` at that point, so the branch was entered exactly when the lookup
     found *nothing* and then dereferenced `NULL` (GCC proves it:
     `-Wnonnull`), and did nothing at all when a disjoint path did exist.
     Restored to the assignment form.
  6. `SendRequest`'s fresh-entry branch never set the hop count. Stock aodv
     passes `/*hop=*/ ttl` to the `RoutingTableEntry` ctor; the fork's AOMDV
     ctor has no hop parameter, so `m_lastHopCount` kept its `INFINITY2`
     default, the expanding-ring search read that back as "already at
     NetDiameter", and `ScheduleRreqRetry` tripped stock's
     `NS_ABORT_MSG_UNLESS (rt.GetRreqCnt () > 0)` on the *first* route
     discovery. Now `SetLastHopCount (ttl)`, mirroring the existing-entry
     branch alongside it.
  7. Sockets were configured with `SetAttribute ("IpTtl", UintegerValue (1))`
     (an ns-3.26-era artefact) where stock ns-3.36 aodv calls
     `SetIpRecvTtl (true)` — 5 sites. With `IpTtl` set, `UdpSocketImpl` adds
     its *own* `SocketIpTtlTag` to a packet that `SendRequest` had already
     tagged, tripping "cannot add the same kind of tag twice". Restored to the
     3.36 base's call, per the "keep the 3.36 side where the fork's difference
     is not AOMDV semantics" rule above.
  8. `PathFind ()` dereferenced `begin ()` unconditionally, so on a pathless
     entry it returned `&*end ()` — UB, and in practice a null `Path*` that the
     ~30 `PathFind ()->` call sites dereferenced. ns-2 AOMDV's `path_find ()`
     returns `NULL` on an empty list; restored. The one site that legitimately
     meets a pathless entry — `RecvRequest`'s RREP-loop drop, which looks up a
     destination that may only have `SendRequest`'s pathless `IN_SEARCH`
     placeholder — is now guarded (no path means no next hop, so there is no
     loop to drop; stock aodv falls through there for the same reason).
  9. `RecvRequest`'s fresh-reverse-route branch built the route in a local
     `newEntry` and dropped it: `toOrigin`, which the rest of the function
     reads (`SendReply`, the node-disjoint `SetFirstHop`), stayed
     default-constructed and pathless. It now adopts the entry just stored and
     re-points `reversePath` into `toOrigin`'s own path list — `reversePath`
     pointed into `newEntry`, which dies at the end of that block. Same defect
     class as items 2 and 4.
  10. `RecvReply`'s forwarding gate queried the RREQ-id cache with the RREP's
     *destination* while both insert sites key it by the RREQ *origin*, so
     the lookup always missed at a relay and the `"Impossible! drop."` guard
     discarded **every forwarded RREP** — multi-hop replies never reached the
     originator. Now queried by `rrepHeader.GetOrigin ()` (#416).
  11. `RecvReply`'s existing-entry branch inserted the forward path with
     `nextHop = rrepHeader.GetOrigin ()` — the RREQ originator, i.e. the node
     *behind* us (or this node itself, at the originator) — where the
     new-entry branch (and the fork's own commented-out constructor call)
     correctly uses `sender`. The same origin-for-sender swap sat in the
     equal-seqno branch's `PathLookupDisjoint`/`PathNewDisjoint`/`PathInsert`
     triple; all keyed on `sender` now (#416).
  12. Stock aodv's RREP acceptance rule (i) — *update when the stored seqno is
     invalid* — was present only as a comment. Without it, `SendRequest`'s
     `IN_SEARCH` placeholder (`seqNo 0`, `validSeqNo false`) could never be
     converted by an RREP whose `dstSeqno` is also 0, and a pure-sink
     destination never increments its seqno — so **every multi-hop discovery
     toward a sink died** in the branch chain's final `return`. Restored as a
     disjunct on the newer-seqno branch, which now also stamps
     `SetValidSeqNo (true)` (#416).
  13. `RecvReply`'s new-forward-route branch had the item-9 defect on the
     forward side: the path went into `newEntry`/the table while the
     forwarding block read the stale pathless local `toDst` and dereferenced
     `toDst.PathFind ()` — a deterministic segfault at any RREP relay once
     item 10 let RREPs relay at all (the item-10 bug was *masking* this one).
     Adopts the stored entry, as item 9 does (#416).
  14. Three `PathFind ()` dereferences reachable with a pathless entry on
     ordinary traffic are now guarded (skip/drop instead of crash): the
     data-forwarding reverse-route lifetime refresh (lookup result was
     discarded outright), the node-disjoint `SetFirstHop` on the RREQ
     propagate path, and `SendReply`'s reverse-path sends. The remaining
     `PathFind ()->` sites are audited but unguarded — the full site-by-site
     verdict table lives in
     [#416](https://github.com/danieljoppi/AntHocNet/issues/416) (#416).
- **Fork semantics kept as-is** (faithful port, not a rewrite): the RREP
  forwarding path does not carry/decrement the `SocketIpTtlTag` (the fork
  dropped stock's TTL bookkeeping there), node-disjoint path computation is the
  compiled-in policy (`AOMDV_NODE_DISJOINT_PATHS`; the link-disjoint variant is
  present but compiled out, as in the fork and AOMDV-UU), and the AOMDV bounds
  (`AOMDV_MAX_PATHS 3`, `AOMDV_PRIM_ALT_PATH_LENGTH_DIFF 1`) are the fork's.
- Wire format: RREQ grows a `firstHop` field (23→27 bytes), RREP grows
  `requestID` + `firstHop` (19→27 bytes) — as in the fork; AOMDV RREQ/RREP are
  therefore **not** interoperable with stock aodv's (they are different
  protocols on the same UDP port 654).

## Runtime status — multi-hop routes on a wired chain; wifi smoke revalidation pending

**The multi-hop root cause is found and fixed (items 10–13), but the arm is
not cleared for campaigns until the wifi smoke below is re-run.**

History: the arm used to deliver **PDR 0.0 % with 86 % route drops**
(ns-3.48, `anthocnet-compare`, 25 nodes / 300 m / 4 flows / 40 s / 5 m·s⁻¹)
against 16 % PDR for stock `aodv`, with only one-hop discovery working. The
[#416 audit](https://github.com/danieljoppi/AntHocNet/issues/416) traced that
to three separable RREP-handling defects (items 10–12) plus a crash the first
of them was masking (item 13), and demonstrated recovery on an N-node
point-to-point chain oracle against ns-3-dev master: stock fork = 1-hop
delivers / 2-hop **livelocks the simulator** (queue-overflow → ICMP-no-route →
loopback re-entry cycle, simulated clock pinned); with items 10–13 = byte
parity with stock `aodv` (9728 B) at every chain length tested (2–6 nodes,
1–5 hops), including a bidirectional-flow variant that previously segfaulted.
The full fix-by-fix ladder and per-site audit table are in #416.

Still open before scheduling the arm:

- **Re-run the wifi smoke** (`anthocnet-compare`, the 25-node scenario above)
  and update this section with its PDR — the chain oracle is
  necessary-not-sufficient evidence.
- The audited-but-unguarded `PathFind ()->` sites (verdict table in #416):
  most need an interface-down/address-removal event, which no current
  scenario scripts for aomdv, but they are one topology change away.
- Known-inert machinery, documented in #416: the RREP-ACK timer is armed but
  never scheduled (unidirectional-link blacklisting does nothing), and the
  originator's RREQ retry timer is never cancelled on success (spurious
  rediscoveries).

- No benchmark numbers — measurement is phase 3 of the
  [v1.5.0 campaign](../../docs/benchmarks/v1.5.0-campaign.md); acceptance is
  directional agreement with Marina & Das 2001 (fewer route discoveries, lower
  delay under mobility vs AODV), to be checked when the campaign measures it.
- No attributes, traces or hooks beyond what the vendored delta needs; the
  harness measures this arm exactly as it measures the stock baselines.
- No regression/chain test port (only the id-cache unit test came along;
  run it manually with `./test.py -s aomdv-routing-id-cache` on ns-3.42+ —
  note CI's `--filter-module-examples-and-tests=anthocnet` deliberately skips
  aomdv tests).
