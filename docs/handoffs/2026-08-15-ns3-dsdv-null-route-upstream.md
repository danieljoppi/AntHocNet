# Handoff — Issue #434: verifying the stock ns-3 DSDV null-route crash before filing upstream

> **Purpose.** [#434](https://github.com/danieljoppi/AntHocNet/issues/434) is a
> handoff issue: everything needed to report the ns-3 DSDV null-route crash to
> nsnam was written up from the [#420](https://github.com/danieljoppi/AntHocNet/issues/420)
> investigation, with a §9 list of claims that were *explicitly unverified*.
> This page records the verification pass: what was checked against current
> `ns-3-dev` master, what held, what changed, and what the report must **not**
> claim. Per [ADR-0013](../adr/0013-track-bugs-and-findings-as-issues.md) the
> issue thread is the durable record; this file is the index + reproducible
> method.
>
> **Date:** 2026-08-15 · **Status:** #434 verified and corrected; not yet filed upstream.

## TL;DR

- The defect is **real, still in master, and reproduces on master** — #434's
  reproducer, byte counts and crash time all replay exactly.
- **§9.1 and §9.2 are now resolved**, both in #434's favour but with better
  detail than it had.
- **§9.3 — the claim #434 itself flagged as "the weakest link" — did not hold
  up.** It was not reproduced, and static analysis shows the mechanism it
  proposes is narrower than stated. **The upstream report must be re-worded.**
- **New result that changes the filing strategy:** the one-line fix in #434 §7
  stops the crash but leaves the network delivering **zero bytes**. It converts
  a loud crash into a silent black hole. Defect (b) is not optional polish; it
  is what makes DSDV *work* on a multi-interface node.
- Two of #434's supporting claims about sibling protocols are wrong and are
  the kind a maintainer disproves with one `grep`. Fix them before filing.

## What was verified, and how

Everything below was run against `ns-3-dev` master at commit
`b677fede0a664ecc4e80615c331dd7f07e58c1c0` (2026-08-14), built locally with
GCC 13.3, in two profiles:

| Profile | cmake flags | Purpose |
|---|---|---|
| `default` | `-DNS3_ASSERT=ON -DNS3_LOG=ON` | see the assert |
| `optimized` | `-DCMAKE_BUILD_TYPE=release -DNS3_ASSERT=OFF -DNS3_LOG=OFF` | see what users of `-opt` actually get |

Artifacts kept next to this page:

| File | What it is |
|---|---|
| [`ns3-dsdv-upstream/dsdv-multi-interface-crash.cc`](ns3-dsdv-upstream/dsdv-multi-interface-crash.cc) | #434 §6's reproducer, **repaired** — the inlined copy in the issue had its C++ template arguments eaten by HTML escaping (`std::vector`, `Ptr`, `GetObject`, `DynamicCast` all lost their `<...>`) and does not compile as pasted |
| [`ns3-dsdv-upstream/dsdv-single-interface-stress.cc`](ns3-dsdv-upstream/dsdv-single-interface-stress.cc) | new: single-interface wifi ad hoc harness built to test §9.3 |
| [`ns3-dsdv-upstream/0001-dsdv-guard-lookup.patch`](ns3-dsdv-upstream/0001-dsdv-guard-lookup.patch) | defect (a) fix; applies cleanly to master |
| [`ns3-dsdv-upstream/0002-dsdv-advertise-per-interface.patch`](ns3-dsdv-upstream/0002-dsdv-advertise-per-interface.patch) | defect (b) fix; applies on top of 0001 |

### The mechanism, confirmed line by line

Every line number #434 cites in `src/dsdv/model/dsdv-routing-protocol.cc` is
**exact on master**: the unchecked lookup at `:1161`, its send at `:1168`, the
forwarding callback at `:1195`, the *guarded* form of the same idiom eleven
lines earlier at `:330`, the `LoopbackRoute` multi-interface comment at
`:523-527`, next-hop-from-sender at `:619`, and the four hardcoded
`m_ipv4->GetAddress(1, 0)` sites at `:861`, `:862`, `:913`, `:916`.

`RoutingTableEntry`'s constructor (`dsdv-rtable.cc:33-54`) does
`m_ipv4Route = Create<Ipv4Route>()` unconditionally, so a default-constructed
entry yields a **non-null** `Ptr` holding a **null** `NetDevice`. The
`NS_ASSERT(route)` below the failed lookup therefore cannot fire, and
`Ipv4L3Protocol::SendRealOut`'s `if (!route)` guard cannot catch it either.
Confirmed.

**One correction:** #434 gives the internet-module assert as
`ipv4-l3-protocol.cc:937`. On master it is **`:960`**. The dsdv line numbers
have not drifted; this one has.

### MR !1652 — confirmed, and it is the best single argument

Fetched the diff. [!1652](https://gitlab.com/nsnam/ns-3-dev/-/merge_requests/1652)
(*"dsdv: Fix order of assert to avoid segmentation fault"*, merged 2023-09-14)
touches **exactly this function**, moves `NS_ASSERT(route)` above its first
use in both branches — and leaves `m_routingTable.LookupRoute(rt.GetNextHop(), newrt);`
unchecked on the line directly above. Its stated rationale is *"a segmentation
fault may be thrown if the pointer is null"*. Upstream arrived at this code
chasing a segfault and hardened an assert that provably cannot fire.

File history confirms the rest: the file was contributed 2010-12-21 by Hemanth
Narra (ResiliNets), and every commit after !1652 is cosmetic (SPDX headers,
Doxygen tag style, formatting).

### Reproduction on master

`default` profile, three-node point-to-point chain:

```
node 0 has 1 non-loopback interface(s): 10.1.1.1
node 1 has 2 non-loopback interface(s): 10.1.1.2 10.1.2.1
node 2 has 1 non-loopback interface(s): 10.1.2.2
sending from node 2 to 10.1.1.1
--- starting simulator ---
NS_ASSERT failed, cond="interface >= 0", +1.512000000s 2 file=.../src/internet/model/ipv4-l3-protocol.cc, line=960
```

Same simulated time `+1.512000000s` as #434 reported for ns-3.36 and ns-3.48.
Controls all match #434 §4/§6 **to the byte**:

| Variant | Result |
|---|---|
| `--protocol=aodv` | completes, 9728 B |
| `--protocol=olsr` | completes, 8512 B |
| `--protocol=rip` | completes, 9728 B |
| `--nNodes=2` (single-interface) | completes, 9728 B |
| `--csma=1` | **crashes**, same assert, same time |

### §9.2 — resolved: the `-opt` SIGSEGV is real

#434 could not test this (both its trees were assert-enabled) and rested the
claim on #503's Valgrind trace. Built `optimized` and ran the same reproducer:

```
EXIT=139            # SIGSEGV
stdout: ... --- starting simulator ---
stderr: 0 bytes
```

**Exit 139, stderr exactly zero bytes.** #434's most alarming claim — a bare
segfault with no message, no frame, nothing to search for — is confirmed
directly rather than inferred.

### §9.1 — resolved: #503 was answered, and that is *worse* for upstream

#434 could not read the thread (GitLab's notes API 401s anonymously) and asked
that it be checked before claiming it went unanswered. It is retrievable
without authentication from the page's JSON endpoint:

```bash
curl -s "https://gitlab.com/nsnam/ns-3-dev/-/issues/503/discussions.json"
```

**It was not ignored.** Twenty notes, three maintainers (Tommaso Pecorella,
Gabriel Ferreira, Tom Henderson) over three years. But every reply pushed the
reporter toward *their own* memory bugs — run Valgrind, run sanitizers, don't
mix the two, try ArchLinux. Pecorella did run `manet-routing-compare.cc` with
DSDV under Valgrind overnight and found nothing, which is exactly what you
would expect from a fault the reporter measured at **0.27 % of 7800 runs**.
DSDV was never examined. It was closed 2025-06-09 by Gabriel Ferreira with:

> I'm closing this, assuming it was fixed (heck, this is from ns-3.32).

No fix was ever made; the code is byte-identical today. It still carries
`module::internet` and `status::unconfirmed`.

**Framing consequence.** Do not tell the maintainers they ignored #503 — they
engaged repeatedly and in good faith. The accurate and much stronger statement
is that the report was closed on an *assumption* of a fix that never happened,
under a module label that pointed everyone away from the culprit. That is a
case for reopening, not a criticism.

## What did NOT hold up

### §9.3 — the single-interface claim should be dropped, not softened

#434 flags this as "the weakest link" and it is weaker than it looks.

**Empirically:** on a wifi ad hoc topology where every node has exactly one
non-loopback interface (so defect (b) is inert by construction), the fault was
not reproduced. Two sweeps of the harness, all delivering real traffic
(checked — an early version of the harness silently delivered 0 bytes in a
1500 m square and would have produced a meaningless clean sweep):

- **262 runs** hunting for the crash directly — 0 crashes.
- **75 runs** with the DSDV module *instrumented* to report every occurrence of
  the precondition rather than dying at the first — **0 events**, across five
  mobility/density regimes (speeds 20–80 m/s, 30–50 nodes, 60–300 s simulated,
  350–600 m squares).

This is nowhere near #503's scale (7800 runs of a 2400 s simulation), so it is
evidence of rarity, not proof of impossibility. It is, however, enough that we
cannot assert single-interface reachability in a report.

Instrumentation is the sharper instrument here: in stock ns-3 every
`DEFECT_A_TRIGGERED` line *is* a crash, so counting them over a whole run is
far more sensitive than waiting for one to land. On the multi-interface
reproducer it fires immediately and identifies the culprit exactly —
`nextHop=10.1.2.1`, the address n1 never advertises.

**Statically**, #434's proposed mechanism does not survive scrutiny.
`RoutingTable::Purge()` (`dsdv-rtable.cc:225-227`) erases a dependent `j` only
when `j.GetNextHop() == i.GetDestination() && i.GetHop() != j.GetHop()`, so a
survivor needs `i.GetHop() == j.GetHop()`. But `j`'s next hop is always set to
the *sender* of an update (`:619`), i.e. a one-hop neighbour, so `i` — the
neighbour's own entry — normally has hop 1 while its dependents have hop ≥ 2,
and the inequality erases them correctly. The survivor case needs the
neighbour's own entry to have been displaced to hop ≥ 2 by a longer path
first. Reachable in principle; not observed.

Note also that #503's reporter ran a custom contrib module that "select[ed]
destination addresses by converting the nodes src addresses to an int32 then
back into an IPv4Address" — a far more direct route to a next hop that does not
resolve than the Purge race.

**Recommendation.** Defect (a) does not need the single-interface claim, and
the claim is the one thing in the report a maintainer could disprove. Argue (a)
on correctness alone — *a failed lookup must never produce a send*, the guarded
form of the identical idiom is eleven lines above at `:330`, and the assert
meant to catch it is provably dead. Cite #503 as suggestive corroboration only,
and state plainly that we could not reproduce it on a single-interface topology.

### The sibling survey has two errors a maintainer will find by grepping

1. **"`src/dsr` uses the same hardcoded idiom at 5 sites."** On master there
   are **4**: `dsr-routing.cc:712` and `:1056` (`GetAddress(1, 0)`), plus
   `:492` and `:708` (`GetNetDevice(1)`).

2. **"only DSDV has the unchecked-lookup amplifier" is false.** AODV has
   roughly a dozen unchecked `LookupRoute` calls, its `RoutingTableEntry`
   constructor allocates its `Ipv4Route` unconditionally exactly like DSDV's,
   and at **`aodv-routing-protocol.cc:1720-1721`** the pattern is structurally
   identical to the bug being reported:

   ```cpp
   m_routingTable.LookupRoute(dst, toDst);
   SendPacketFromQueue(dst, toDst.GetRoute());
   ```

   The honest distinction is *local*, not categorical: AODV adds or updates the
   entry for `dst` a few lines above, so the lookup succeeds by construction,
   whereas DSDV looks up `rt.GetNextHop()` — a different key from anything it
   just inserted. AODV's is a latent smell; DSDV's is a live bug. But "it
   should always succeed" is precisely the reasoning that failed in DSDV.

   **This strengthens the filing rather than weakening it.** It makes #434 §7's
   "optional" hardening — have `SendRealOut` treat `interface < 0` as
   `DROP_NO_ROUTE` instead of asserting, mirroring the `!route` guard ten lines
   above — the *higher-leverage* fix, because it makes this class of bug fail
   safely for every routing protocol.

## The finding that changes the filing strategy

#434 §8 advises scoping the first report to defect (a) alone and offering (b)
as a follow-up. That advice is right for getting a fix merged, but it needs one
sentence added, because **the one-line fix does not make DSDV work**:

| Build | Outcome on the 3-node chain |
|---|---|
| stock master | assert (`default`) / SIGSEGV, empty stderr (`optimized`) |
| `+ 0001` (defect (a) only) | no crash — **0 bytes delivered** |
| `+ 0001 + 0002` (both) | **9728 bytes**, parity with AODV and RIP |

Fixing (a) alone turns a crash into a silent black hole: the packets stay
queued forever because n2's next hop `10.1.2.1` is an address n1 never
advertises. Verified again at 4- and 5-node chain lengths (9728 B each), and
the single-interface case is unaffected (9728 B), so 0002 does not regress the
configuration DSDV was written for.

So: still file (a) first — but say explicitly in the report that (a) is a
**memory-safety fix, not a functional one**, and that multi-interface DSDV
remains broken until (b) lands. Otherwise the likely outcome is that the
one-liner merges, the crash disappears, and the module quietly misroutes
forever.

`0002` is a demonstration that (b) is the functional blocker — it takes the
per-socket `iface` already in scope in both update loops instead of
`GetAddress(1, 0)`. It is deliberately the smallest change that proves the
point, **not** a finished design. OLSR's approach (RFC 3626 MID messages plus
an explicit `m_mainAddress`, giving a multi-interface node one canonical
identity) is the model, and upstream will likely want that instead.

## Why this survived sixteen years

Worth keeping alongside #434 §5's "smoke-test on the smallest topology that
preserves the property under test" lesson, because there is a second structural
reason:

`src/dsdv/test/dsdv-testcase.cc` contains exactly two test cases — a header
serialization round-trip and a routing-table unit test. **There is no
end-to-end test in the DSDV module at all**, so no topology is ever routed over
in CI. `src/dsdv/doc/dsdv.rst` has no Scope-and-Limitations section and does
not contain the word "interface". A module with no integration test and no
documented scope has no mechanism by which this could have been caught.

That is also the strongest argument for attaching a regression test to the MR:
the three-node chain above is a ~40-line test case, and it is the first
end-to-end coverage the module would have.

## Reproducing this verification

```bash
git clone --depth 1 https://gitlab.com/nsnam/ns-3-dev.git && cd ns-3-dev
cp <repo>/docs/handoffs/ns3-dsdv-upstream/dsdv-multi-interface-crash.cc scratch/

# assert profile — see the assert
./ns3 configure --enable-modules=dsdv,aodv,olsr,point-to-point,csma,applications \
    --disable-python --disable-examples --disable-tests --build-profile=default
./ns3 build && ./ns3 run dsdv-multi-interface-crash          # NS_ASSERT, exit 134

# optimized profile — see the bare SIGSEGV
./ns3 configure ... --build-profile=optimized
./ns3 build && ./build/scratch/ns3-dev-dsdv-multi-interface-crash-optimized
                                                              # exit 139, stderr empty

# the fixes
patch -p1 < <repo>/docs/handoffs/ns3-dsdv-upstream/0001-dsdv-guard-lookup.patch
./ns3 build && ./build/scratch/...-optimized                  # no crash, 0 bytes
patch -p1 < <repo>/docs/handoffs/ns3-dsdv-upstream/0002-dsdv-advertise-per-interface.patch
./ns3 build && ./build/scratch/...-optimized                  # 9728 bytes
```

## Still not done

1. **Not filed upstream.** That is #434's actual ask and it remains open.
2. **The ns-3 test suite was not run against either patch** — both local builds
   were configured `--disable-tests`. Run `./test.py -s routing-dsdv` (and the
   AODV/OLSR suites) before submitting an MR.
3. **DSR still not demonstrated to crash** (#434 §9.4) — idiom confirmed at 4
   sites, failure not shown. It is wifi-coupled and irrelevant to ISL work.
4. **`nix-vector-routing`, IPv6 routing and `mesh` still unexamined** (#434 §9.5).
5. **AODV `:1720` not proven unreachable** — argued from local context only. If
   it is reachable it is a second crash of the same family.
