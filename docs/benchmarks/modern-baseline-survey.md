# Modern deployed baselines — the ns-3 availability survey

**The question:** the 2026 literature review behind
[#296](https://github.com/danieljoppi/AntHocNet/issues/296) observed that
testbed-era MANET comparisons centre on OLSR vs BATMAN-adv vs Babel, and that a
comparison set of AODV/OLSR/DSDV alone increasingly reads as a strawman set.
Item 4 of that epic asks whether one of those **modern deployed** protocols can
join this harness, and sets the acceptance bar at *deciding deliberately and
recording why*. This page is that record: the survey, its evidence, the
decision, and the conditions that would reverse it.

[← Benchmark index](../benchmarks.md) · [Methodology](methodology.md) ·
[Baselines framing](methodology.md#baselines-what-each-arm-is-for-296) ·
[Roadmap](../roadmap.md)

> **Verdict (2026-08-13): write the threat-to-validity paragraph, do not write
> the code — but the "why not" is *timing*, not absence.** No modern deployed
> link-state or distance-vector protocol has a maintained, currently-building
> ns-3 implementation today. But upstream ns-3 opened a draft `manet` module in
> June 2026 whose stated plan includes **an OLSRv2 model and a B.A.T.M.A.N.
> model**, and a complete-looking OLSRv2 module already exists on an *archival*
> NIST research branch. So the decision carries an explicit
> [revisit trigger](#what-would-reverse-this-decision) rather than a flat
> "unavailable", and the threat-to-validity paragraph is written to be retired,
> not defended.

## Why the survey had to be honest rather than quick

[#414](https://github.com/danieljoppi/AntHocNet/pull/414) is the reason this
page exists in this form. The AOMDV spike vendored a third-party port, fixed
nine defects in it, got it compiling **clean on all five ns-3 versions in the CI
matrix** — and then measured **0 % PDR** against stock AODV's 16 % on an
identical scenario. A port that compiles is not a baseline that works, and the
distance between those two states was nine defects and a smoke run.

That result sets the evidentiary bar for item 4. "Somebody published an ns-3
module for it" is not evidence that an arm is feasible; the questions that
matter are *who maintains it*, *against which ns-3 version*, *is it validated
against anything*, and *what would this project have to repair before the
number it produces could be published*. The sections below answer those
questions per protocol, with the source for each answer.

## Method, and what it could not check

Checked on **2026-08-13**:

- **Stock ns-3 content** — direct probes of module directories on the
  `nsnam/ns-3-dev-git` GitHub mirror's `master` branch (a read-only mirror of
  the canonical `gitlab.com/nsnam/ns-3-dev`), plus the module's own
  documentation source (`src/<module>/doc/*.rst`).
- **Upstream trajectory** — the ns-3 GitLab REST API, for merge requests and
  issues matching each protocol name (all states).
- **Third-party ports** — repository contents and commit history via GitHub.

**What this could not check, stated because it bounds the verdict.** The ns-3
web properties are unreachable from these sessions: `www.nsnam.org` (wiki,
rendered model library), `apps.nsnam.org` (**the ns-3 App Store — the canonical
index of contributed modules**), `dl.acm.org`, `net.in.tum.de` and
`groups.google.com` all return an egress-proxy block. So:

- The App Store catalogue was **not** browsed directly; its coverage here rests
  on search results and on the absence of any upstream issue/MR pointing at such
  a module. The same caveat was recorded in the
  [original spike](https://github.com/danieljoppi/AntHocNet/issues/296#issuecomment-5245550798)
  — *two minutes of human browsing would close it*, and that remains true.
- Two papers below are cited from their metadata and from the ns-3 merge request
  that references them, not from their full text.

Everything else on this page was read from a primary source and is quoted or
linked as such.

## What stock ns-3 ships

Probing `src/<module>/CMakeLists.txt` on `ns-3-dev` `master`:

| module | present? | note |
|---|---|---|
| `aodv`, `olsr`, `dsdv`, `dsr` | ✅ | the classical set — this project's [replication anchors](methodology.md#replication-anchors--aodv--olsr--dsdv) are three of these |
| `mesh` | ✅ | IEEE 802.11s: peering management + **HWMP**. See [below](#the-second-thing-the-epic-did-not-predict-80211s-hwmp-is-already-in-stock-ns-3) |
| `babel`, `batman`, `batmand`, `olsrv2`, `nhdp` | ❌ (404) | no modern deployed L3 protocol |
| `aomdv`, `gpsr` | ❌ (404) | why both are vendored here at all ([#414](https://github.com/danieljoppi/AntHocNet/pull/414), [#412](https://github.com/danieljoppi/AntHocNet/pull/412)) |

And the ns-3 OLSR model's own documentation is explicit about its vintage:

> The implementation is based on OLSR Version 1 (RFC 3626) and it is *not*
> compliant with OLSR Version 2 (RFC 7181) or any of the Version 2 extensions.
>
> — [`src/olsr/doc/olsr.rst`](https://raw.githubusercontent.com/nsnam/ns-3-dev-git/master/src/olsr/doc/olsr.rst)

That file's *Scope and Limitations* also records two gaps worth carrying into
the [anchors' quality-risk statement](methodology.md#replication-anchors--aodv--olsr--dsdv):
the model does not respond to interface up/down notifications, and — unlike the
NS-2 original it was ported from — "does not yet support MAC layer feedback as
described in RFC 3626".

## Babel (RFC 8966)

| question | answer | source |
|---|---|---|
| Upstream ns-3 module? | **No** — `src/babel` absent from `ns-3-dev` master | direct probe, 2026-08-13 |
| Upstream work in progress? | **No** — zero merge requests and zero issues matching "babel" in the ns-3 GitLab project, any state | ns-3 GitLab API, 2026-08-13 |
| Maintained contrib module? | **None found** | searches returned no repository |
| Academic port? | **One paper**, no located code | von Ehren, Andre & Wiedner, *An Implementation of the Babel Routing Protocol for ns-3*, TUM Seminar IITM proceedings NET-2022-01-1 (2022), <https://www.net.in.tum.de/fileadmin/TUM/NET/NET-2022-01-1/NET-2022-01-1_15.pdf> |

The paper describes a new `babel` module — example scenario, helper, protocol
implementation, structured after ns-3's `olsr` — written because Babel had no
prior ns-3 implementation. Its PDF host is egress-blocked from these sessions,
so that description comes from the search index rather than from the text, and
**no public repository for the implementation was located**. A single-author
seminar-paper module with no released code, no maintainer and no stated ns-3
version is not a candidate arm; it is a lead for someone with web access to
follow up, and it is recorded here as such rather than as a negative result.

Babel itself is not in doubt — RFC 8966 (2021), with two production
implementations (`babeld`, the reference; and BIRD's). The gap is entirely on
the simulator side.

## BATMAN / batman-adv

| question | answer | source |
|---|---|---|
| Upstream ns-3 module? | **No** — `src/batman`, `src/batmand` absent | direct probe, 2026-08-13 |
| Upstream work in progress? | **No** open MR or issue matching "batman" | ns-3 GitLab API, 2026-08-13 — but see [`manet` module](#the-thing-the-epic-did-not-predict-upstream-ns-3-is-building-a-manet-module-now), whose plan names one |
| Past ns-3 effort? | **NSOC 2020 project, targeted batman-adv for Freifunk, paused incomplete** | ns-3 wiki `NSOC2020Routing` (page itself egress-blocked; status read from the search summary — second-hand, flagged) |
| Third-party port? | **BATSEN** (`npowell3/BATSEN`), ns-3.25, **last commit 2018-05-11**, 5 commits total | <https://github.com/npowell3/BATSEN> |

Two facts disqualify BATSEN as a modern-deployed baseline even before its age is
considered.

**It is the wrong protocol.** Its own header states it is "based on the BATMAND
module and modified for BATMAND-0.3.2", implementing
`draft-openmesh-b-a-t-m-a-n-00` — the 2008 *daemon*-era BATMAN, two protocol
generations before what is deployed. The Linux kernel's own documentation draws
exactly this line:

> Unlike the batman daemon, which exchanges information using UDP packets and
> sets routing tables, batman-advanced operates on ISO/OSI Layer 2 only and uses
> and routes (or better: bridges) Ethernet Frames.
>
> — [`Documentation/networking/batman-adv.rst`](https://raw.githubusercontent.com/torvalds/linux/master/Documentation/networking/batman-adv.rst)

**And the deployed protocol is structurally incompatible with the harness's arm
shape.** batman-adv is a layer-2 kernel module (`net/batman-adv`; its Kconfig builds the
BATMAN V protocol — ELP + OGMv2 + a throughput metric — in by default alongside
BATMAN IV), so it is not an `Ipv4RoutingProtocol` at all. Every arm in `anthocnet-compare` is installed
through `InternetStackHelper::SetRoutingHelper`, and the overhead metrics
(`nrl`, `nrl_bytes`) count routing-control traffic at the IP layer. A layer-2
mesh protocol would need a different install path *and* a different overhead
counting point, which means its overhead column would not be comparable with the
other arms' — the exact failure mode the [metrics](metrics.md) page warns about
for TCP.

## OLSRv2 (RFC 7181) — the near miss

This is the one that nearly changed the recommendation, and the detail is
recorded because the next person to ask this question should start here.

| question | answer | source |
|---|---|---|
| Upstream ns-3 module? | **No** — `src/olsrv2` absent from `ns-3-dev` master; the stock `olsr` model states it is not RFC 7181 compliant | direct probe + `olsr.rst`, 2026-08-13 |
| Does an ns-3 OLSRv2 implementation exist at all? | **Yes** — `src/olsrv2` on `usnistgov/psc-ns3`, branch `icns3-2025-nhdp` | <https://github.com/usnistgov/psc-ns3/tree/icns3-2025-nhdp> |
| Base ns-3 version | **ns-3.43** (inside this project's 3.36–3.48 matrix) | branch README |
| Size | **~7,330 lines** across 9 model/helper files, plus a companion `src/nhdp` of **~1,915 lines** | line counts, 2026-08-13 |
| Tests | **5 suites** declared: regression, hello-regression, TC-regression, header, routing-protocol, plus a bug-780 case | `src/olsrv2/CMakeLists.txt` |
| Licence | **GPL-2.0-only**, headers inherited from ns-3's `olsr` (Ros / Carneiro) — matches this repo | `olsrv2-routing-protocol.h` |
| `AssignStreams`? | **Yes** (`RoutingProtocol::AssignStreams`) — the [#352](https://github.com/danieljoppi/AntHocNet/issues/352) stream-pinning requirement is met | `olsrv2-routing-protocol.{h,cc}` |
| Maintained? | **No.** The branch is *by its authors' own statement* archival | branch README |

The README says it plainly:

> This branch is intended to be archival only. Some updated version of NHDP is
> likely to be contributed to ns-3-dev in the future.

The branch exists to reproduce the figures of Black & Henderson, *A Neighborhood
Discovery Protocol (NHDP) Model for ns-3*, Proceedings of the 2025 International
Conference on ns-3 ([doi:10.1145/3747204.3747218](https://dl.acm.org/doi/10.1145/3747204.3747218);
paywalled and egress-blocked here — cited from its metadata and from the ns-3
merge request that references it). The branch was **last updated 2025-04-30**;
`psc-ns3`'s own default branch was last updated **2024-01-10** and contains
neither `nhdp` nor `olsrv2` (both probe 404 on `master`, `main`, `psc-dev` and
`psc-ns3.43`).

So this module is: complete-looking, correctly licensed, harness-compatible in
the one respect that usually breaks ports (RNG stream pinning), and **not
maintained by anyone**, on a branch its authors have labelled archival, with the
protocol itself (as opposed to its NHDP substrate) not the subject of the paper
the branch supports and therefore of unknown validation status. Adopting it
would mean this project becomes the maintainer of a ~9,200-line RFC 7181
implementation across five ns-3 versions — the AOMDV situation, at four times
the size, with a *newer* base and better hygiene but the same structural
position: a third-party research port with no upstream to diff against.

## The thing the epic did not predict: upstream ns-3 is building a `manet` module now

The epic's premise was that item 4's likely outcome is a threat-to-validity
paragraph *because nothing exists*. The survey found something different: the
gap is being closed upstream, in the open, right now.

**MR !2887 — "Draft: manet: Add manet module and NHDP model"**
(<https://gitlab.com/nsnam/ns-3-dev/-/merge_requests/2887>), author Tom
Henderson, opened **2026-06-03**, last updated 2026-06-12, still **open and
draft** as of 2026-08-13. It proposes a new `manet` module seeded with an RFC
6130 NHDP model ("an evolution of the model described in" the ICNS3 2025 paper
above), and states the plan for populating it:

> - Move PacketBB from src/network/utils here
> - Move `src/olsr`, `src/aodv`, `src/dsr`, `src/dsdv` here
> - Add AODVv2 model from [this paper](https://dl.acm.org/doi/10.1145/3747204.3747219) here, when ready
> - **Add an OLSRv2 model**
> - **Add a B.A.T.M.A.N. model**

**MR !2975 — "Draft: Proposed new RFC5444 (PacketBB) API"**
(<https://gitlab.com/nsnam/ns-3-dev/-/merge_requests/2975>), same author, opened
**2026-08-04** — nine days before this survey — reworks the RFC 5444 message
encoding that NHDP and OLSRv2 both sit on. Its own description says it is "just
an API proposal (no implementation yet)".

Neither is merged. Both are drafts by a single ns-3 maintainer, on a track whose
prior art (the 2025 NHDP paper) took a year to reach a draft MR. Nothing here is
a schedule this project can plan a campaign around — but it is decisive for the
*shape* of the decision: writing our own OLSRv2 or BATMAN arm now would be
building, unmaintained and alone, the thing upstream intends to ship
maintained. That is the worst possible time to start.

## The second thing the epic did not predict: 802.11s HWMP is already in stock ns-3

The epic named Babel, BATMAN-adv and OLSRv2. It did not name the one *deployed*
mesh routing protocol that ns-3 already ships and maintains: **HWMP**, the
Hybrid Wireless Mesh Protocol of IEEE 802.11s, in `src/mesh`.

It has a real claim to the "modern deployed" slot. The Linux kernel implements
802.11s including HWMP in `net/mac80211` (`mesh_hwmp.c`, originally open80211s,
with copyright lines running to 2026), so it is deployed in every Linux mesh
device; and ns-3's model is maintained upstream, was updated to the 802.11s-2012
packet formats in ns-3.23, and claims "Linux kernel mac80211 layer compatible
message formats" plus a custom Wireshark dissector
([`src/mesh/doc/source/mesh-design.rst`](https://raw.githubusercontent.com/nsnam/ns-3-dev-git/master/src/mesh/doc/source/mesh-design.rst)).

Three things stop it from being a drop-in arm, and they are the reasons it is
recorded here rather than scheduled:

1. **Wrong layer for this harness.** `MeshPointDevice` is a layer-2 net device
   installed by `MeshHelper` at the device layer; it is not an
   `Ipv4RoutingProtocol` and cannot be installed through the
   `InternetStackHelper::SetRoutingHelper` path every existing arm uses. The
   change is to the harness's topology construction, not to a `--protocols`
   switch.
2. **Its overhead is not counted where the other arms' overhead is counted.**
   HWMP's PREQ/PREP/PERR are 802.11 management frames, not IP packets, so
   `nrl` / `nrl_bytes` — IP-layer counters — would read **zero** for an HWMP arm
   while it is in fact sending control traffic. A protocol whose overhead metric
   is structurally zero is worse than no arm: it is a wrong number with a
   plausible shape.
3. **A known model gap that would bias the comparison against it.** The ns-3
   model's own *Unsupported features* list includes "Path maintenance (sending
   PREQ proactively before a path expires)", and the design doc spells out the
   consequence: "active routes may time out and need to be rebuilt, causing
   packet loss". Under mobility — precisely this project's regime — that gap
   penalises HWMP for a model limitation rather than a protocol property.

None of these is fatal; all three are work, and item (2) is measurement work of
the kind [#229/#230](https://github.com/danieljoppi/AntHocNet/issues/229) taught
this project to take seriously. It is the strongest candidate the survey found
for a *future* modern arm, and it is written down here so the next attempt does
not start from the epic's three-name list.

## The decision

**Write the paragraph, not the code — with a named trigger for revisiting.**

Reasoning, in the order that decided it:

1. **No option available today is both maintained and buildable on this matrix.**
   Babel has no located code; BATMAN's only ns-3 artefact is a 2018, ns-3.25,
   wrong-generation daemon port; OLSRv2's only implementation is archival by its
   authors' own statement and depends on a second archival module.
2. **The AOMDV evidence is direct and recent.** A vendored port that compiled
   clean on five ns-3 versions still delivered 0 % PDR, and only a smoke run
   distinguished "builds" from "routes"
   ([#414](https://github.com/danieljoppi/AntHocNet/pull/414)). Every candidate
   here is a third-party research port of the same species. Shipping a second
   broken arm — or worse, one broken *subtly* enough to produce plausible
   numbers — would damage the comparison more than the missing arm does.
3. **Upstream intends to ship OLSRv2 and BATMAN models** (MR !2887). Adopting an
   archival port now maximises the maintenance we take on at exactly the moment
   it is most likely to be superseded.
4. **The honest limitation is cheap and the reader can price it.** A stated
   threat to validity costs a paragraph and lets a reviewer weight the results
   correctly. A silently-broken modern arm costs the credibility of every number
   on the page.

The paragraph itself lives with the rest of the baseline framing, in
[methodology.md](methodology.md#the-resulting-threat-to-validity).

**What was explicitly *not* decided:** that a modern baseline is unnecessary. It
is necessary, and its absence is the largest single weakness in this project's
comparison set. This is a decision about *when*, made on evidence about *what
exists*, and it is written to be overturned.

## What would reverse this decision

Any one of these, in decreasing order of likelihood:

| trigger | what to do | how to check |
|---|---|---|
| **ns-3 MR !2887 merges** and a `manet` module lands with an OLSRv2 or B.A.T.M.A.N. model | Adopt it as an upstream module — the same standing as `aodv`/`olsr`/`dsdv`, no vendoring, no maintenance burden. This is the outcome this decision is waiting for. | <https://gitlab.com/nsnam/ns-3-dev/-/merge_requests/2887> |
| **NHDP + OLSRv2 are contributed to `ns-3-dev`** by any route (the branch README says an updated NHDP "is likely to be contributed") | Same as above; OLSRv2 is the highest-value modern arm because it is the direct RFC 7181 successor to a protocol already in the comparison set, which makes the pairing a controlled contrast rather than a new axis. | probe `src/olsrv2` and `src/nhdp` on `ns-3-dev` master |
| **A maintained contrib module appears in the ns-3 App Store** for any of the three | Evaluate to the [#414](https://github.com/danieljoppi/AntHocNet/pull/414) bar: build on all five matrix versions, `AssignStreams` present, and a **smoke run with non-zero multi-hop PDR before anything else** | <https://apps.nsnam.org/> — *not checkable from agent sessions; needs a human* |
| **The harness grows layer-2 arm support** (device-layer install + a link-layer control-traffic counter) | 802.11s HWMP becomes the cheapest modern arm available, since the model is already in stock ns-3 and maintained | this repo |
| **Someone releases the TUM Babel module** | Evaluate to the same bar; expect it to be a first-release research module, i.e. the AOMDV risk profile | search for a repository; the paper's authors are the contact |

The cheap standing check is two probes and one API query — the commands are in
[Method](#method-and-what-it-could-not-check) — and it is worth re-running at
the start of any campaign that will publish a baseline comparison.

## Sources

| # | source | what it establishes |
|---|---|---|
| 1 | [`ns-3-dev-git/src/olsr/doc/olsr.rst`](https://raw.githubusercontent.com/nsnam/ns-3-dev-git/master/src/olsr/doc/olsr.rst) | ns-3's OLSR is RFC 3626, explicitly *not* RFC 7181; its scope/limitation list |
| 2 | `ns-3-dev-git` `src/` module probes (2026-08-13) | no `babel`/`batman`/`batmand`/`olsrv2`/`nhdp`/`aomdv`/`gpsr` upstream; `aodv`/`olsr`/`dsdv`/`dsr`/`mesh` present |
| 3 | [ns-3 GitLab MR !2887](https://gitlab.com/nsnam/ns-3-dev/-/merge_requests/2887) (opened 2026-06-03, draft) | upstream `manet` module + NHDP; plan names OLSRv2 and B.A.T.M.A.N. models |
| 4 | [ns-3 GitLab MR !2975](https://gitlab.com/nsnam/ns-3-dev/-/merge_requests/2975) (opened 2026-08-04, draft) | RFC 5444 API rework — the encoding NHDP/OLSRv2 depend on; API proposal only |
| 5 | [`usnistgov/psc-ns3` @ `icns3-2025-nhdp`](https://github.com/usnistgov/psc-ns3/tree/icns3-2025-nhdp) | an ns-3.43 OLSRv2 (~7.3k lines) + NHDP (~1.9k lines), GPL-2.0-only, `AssignStreams` present, branch "archival only", last updated 2025-04-30 |
| 6 | Black & Henderson, *A Neighborhood Discovery Protocol (NHDP) Model for ns-3*, ICNS3 2025, [doi:10.1145/3747204.3747218](https://dl.acm.org/doi/10.1145/3747204.3747218) | the paper that branch supports (metadata only — paywalled and egress-blocked) |
| 7 | [`npowell3/BATSEN`](https://github.com/npowell3/BATSEN) + its `batmand-routing-protocol.cc` header | ns-3.25 BATMAN port, `draft-openmesh-b-a-t-m-a-n-00` / BATMAND-0.3.2 lineage, last commit 2018-05-11 |
| 8 | [Linux `Documentation/networking/batman-adv.rst`](https://raw.githubusercontent.com/torvalds/linux/master/Documentation/networking/batman-adv.rst) and [`net/batman-adv/Kconfig`](https://raw.githubusercontent.com/torvalds/linux/master/net/batman-adv/Kconfig) | batman-adv is layer 2 and distinct from the batman daemon; BATMAN V is the current generation |
| 9 | [`ns-3-dev-git/src/mesh/doc/source/mesh-design.rst`](https://raw.githubusercontent.com/nsnam/ns-3-dev-git/master/src/mesh/doc/source/mesh-design.rst) | 802.11s HWMP in stock ns-3: supported features, mac80211-compatible formats, and the missing path maintenance |
| 10 | [Linux `net/mac80211/mesh_hwmp.c`](https://raw.githubusercontent.com/torvalds/linux/master/net/mac80211/mesh_hwmp.c) | HWMP is deployed and maintained in the Linux kernel (copyright to 2026) |
| 11 | von Ehren, Andre & Wiedner, *An Implementation of the Babel Routing Protocol for ns-3*, TUM NET-2022-01-1 (2022), <https://www.net.in.tum.de/fileadmin/TUM/NET/NET-2022-01-1/NET-2022-01-1_15.pdf> | the only located Babel-for-ns-3 work; no released code found (host egress-blocked) |
| 12 | ns-3 GitLab issues/MR search for "babel", "batman" (2026-08-13) | zero upstream tickets for either |
| 13 | ns-3 wiki `NSOC2020Routing` | a batman-adv-for-ns-3 project existed and is paused/incomplete (**second-hand**: page egress-blocked, read from search summary) |
| 14 | [#414](https://github.com/danieljoppi/AntHocNet/pull/414) · [`ns3/aomdv/README.md`](../../ns3/aomdv/README.md) | the local evidence that a compiling third-party port is not a working arm |

Refs [#296](https://github.com/danieljoppi/AntHocNet/issues/296)
([item 4](https://github.com/danieljoppi/AntHocNet/issues/296#issuecomment-5275396168)),
[#412](https://github.com/danieljoppi/AntHocNet/pull/412),
[#414](https://github.com/danieljoppi/AntHocNet/pull/414),
[#415](https://github.com/danieljoppi/AntHocNet/issues/415).
