# 09 — Landscape of public AntHocNet implementations + project positioning

- **Deviation:** — (presentation / positioning, not a protocol bug)
- **Priority:** P2 (high value-for-effort: the project is built well but presents
  as a third of what it is)
- **Effort:** S
- **Layer:** repo metadata, `README.md`, `.gitattributes`, `docs/`
- **Depends on:** nothing

## Summary

The code and internal docs of this repo are the strongest in the public
AntHocNet field, but the GitHub "shopfront" still reflects the old 2016 NS-2-only
project, so visitors see far less than what exists. This item (a) records the
competitive landscape for positioning, and (b) lists concrete, low-effort fixes
to make the project present as well as it is engineered.

## The public AntHocNet landscape (as of 2026-06)

Six public implementations exist. Verified by GitHub search + inspecting each
repo's tree/README.

| Repo | Platform | What it is | Algorithm | Maintained | Presentation |
|---|---|---|---|---|---|
| **danieljoppi/AntHocNet** (this) | NS-2 + NS-3 | Portable, **tested** C++ core + two thin adapters | Canonical (with the gaps in items 01–06) | **Yes (2026)** | Strong internal docs; weak GitHub shopfront |
| **Sawchord/anthocnet** | NS-3 (waf) | Native ns-3 module, Bachelor thesis | **Fuzzy-logic variant** (fuzzylite FIS) | No (2017) | Build-only README; per-dir file docs; no design/results |
| **netcom-augsburg/contiki-ng-anthocnet** | **Contiki-NG (real IoT OS)** | Embedded port, ICMPv6 ant signaling, RPL alternative | Canonical-ish, embedded | **Yes (2026)** | One-line README (title only) |
| **jgera/ns-2.35-with-anthocnet** | NS-2.35 | Whole vendored `ns-allinone` tree | Legacy (the lineage with the back-ant defect) | No (2016) | env-setup README; the anti-pattern this repo replaces |
| **alessandrolugari/...-Netlogo** | NetLogo | Educational agent sim (UNIMORE DAI course) | Canonical, conceptual | No (2022) | **Excellent**: documents every variable + presentation |
| **martinellop/ant-net** | NetLogo | Educational/visual sim (UNIMORE DAI course) | Canonical, conceptual | No (2024) | **Excellent**: demo GIF + video + screenshots |

### What each is doing (technical)

- **Sawchord** — the only other "serious" simulator implementation. Full native
  ns-3 module: a fuzzy inference system (`model/anthocnet-fis.*` wrapping
  fuzzylite 6, `Eval(in1,in2) → quality`) computes pheromone from two link
  metrics, plus a multi-interface routing table (`anthocnet-rtable`), a
  per-destination packet cache (`anthocnet-pcache`), a traffic/stats monitor
  (`anthocnet-stat`), and a sim database/app for evaluation. **More complete on
  maintenance than this repo, but it is a *modified* (fuzzy) algorithm, fused
  into ns-3 (not portable), on waf + a fuzzylite submodule (heavy build).**
- **Contiki-NG (Augsburg)** — the most novel: AntHocNet on real low-power
  IoT/6LoWPAN motes (Cooja/hardware) as an RPL alternative for mobility. Ant
  control rides ICMPv6 (`AntHocNet/anthocnet-icmpv6.c`), real pheromone table
  (`anthocnet-pheromone.*`), `-conf.h`/`-types.h`. Only one targeting embedded
  systems rather than a simulator. Recent and active.
- **jgera** — a checked-in `ns-allinone-2.35` tree with AntHocNet preinstalled;
  the "forked simulator" anti-pattern this repo's design (ADR-0005, anchor patch)
  exists to eliminate.
- **NetLogo (both)** — educational agent sims; not deployable routing, but they
  faithfully model reactive/proactive ants, `Thop`, MAC travel-time estimate,
  proactive sending rate, and link failures, and they are the **best at
  explaining the algorithm visually**.

### Field-level pattern

The simulator/embedded repos have **strong code, weak presentation**
(Sawchord, Contiki, jgera); the NetLogo repos have **weak code, strong
presentation**. **This repo is the only one with both strong engineering *and*
strong internal docs** (CONTEXT, architecture, ADRs, porting-notes, CI, unit
tests, auto-generated benchmarks, dual-simulator portability). On substance it
leads the field — the only thing missing is the storefront.

## Positioning statement (use in README / abstract)

> The only AntHocNet implementation maintained as a **single, simulator-agnostic,
> unit-tested algorithm core** that installs onto **both NS-2 (idempotent source
> patch) and NS-3 (native module)** — no vendored simulator tree, with CI and
> reproducible AODV/OLSR/DSDV(/DSR) benchmarks.

Differentiators vs each peer:
- vs **Sawchord** — canonical algorithm (not a fuzzy variant), portable core,
  modern build, **tested + CI**; Sawchord is unmaintained and waf/fuzzylite-bound.
- vs **Contiki-NG port** — dual-simulator evaluation + docs; complementary, not
  competing (different layer). Worth cross-linking.
- vs **jgera / SourceForge** — not a forked simulator; reversible patch + a clean
  core; the back-ant defect of that lineage is fixed here.
- vs **NetLogo** — a real routing protocol, not a teaching toy (but borrow their
  visual presentation).

## Required change (presentation fixes)

Verified current GitHub state of `danieljoppi/AntHocNet`: `default_branch: main`,
`archived: false`, `description: "AntHocNet implementation in NS-2"`,
`topics: []`, `language: Tcl`. All of the following are surface-level and cheap.

### 1. Fix the GitHub repo metadata (no code change)

- **Description** → something like:
  *"AntHocNet (ant-colony MANET routing) as a portable, tested C++ core with NS-2
  and NS-3 adapters."*
- **Topics** → `manet`, `ant-colony-optimization`, `aco`, `routing-protocol`,
  `ns-3`, `ns-2`, `mobile-ad-hoc-network`, `cpp`, `swarm-intelligence`.
- Can be done via `gh` (if installed/authed):
  ```bash
  gh repo edit danieljoppi/AntHocNet \
    --description "AntHocNet (ant-colony MANET routing) as a portable, tested C++ core with NS-2 and NS-3 adapters." \
    --add-topic manet --add-topic ant-colony-optimization --add-topic aco \
    --add-topic routing-protocol --add-topic ns-3 --add-topic ns-2 \
    --add-topic mobile-ad-hoc-network --add-topic cpp --add-topic swarm-intelligence
  ```
  (Otherwise set them in the GitHub UI "About" panel.)

### 2. Fix language detection → C++ (`.gitattributes`)

GitHub Linguist counts the 30+ `ns2/tcl/scenario*/sim-*.tcl` files and the patch
fragments as the bulk of the repo, so it labels the project **Tcl**. Add a
`.gitattributes` at the repo root:

```gitattributes
# Make GitHub Linguist reflect that this is a C++ project.
ns2/tcl/**           linguist-vendored
ns2/patch/fragments/** linguist-vendored
docs/**              linguist-documentation
*.tcl                linguist-detectable=false
```

(Adjust so the example/scenario Tcl and patch fragments don't dominate; verify on
GitHub after pushing that the language bar shows C++ first.)

### 3. Strengthen the README top

- Add a one-line **positioning statement** (above) right under the title.
- Surface the **benchmark table** (currently only in `docs/benchmarks.md`) or link
  it prominently.
- Add a **"Compared to other implementations"** section (condense the table
  above) so visitors immediately see how this differs from Sawchord / Contiki /
  the NetLogo sims. Link out to them.

### 4. Add at least one visual

The NetLogo repos prove a single image massively improves comprehension. Add to
the README one of:
- a topology + pheromone-table diagram (reactive setup → backward ant → mesh), or
- a benchmark bar chart (PDR/delay/NRL vs AODV/OLSR/DSDV — from item 08), or
- an ASCII/Mermaid sequence of the decision flow (already described in
  `docs/architecture.md`; render it).

Store under `docs/img/` and embed with a relative path.

### 5. SourceForge mirror

If the SourceForge project is still linked, update its status from "Pre-Alpha"
and point it at the GitHub repo, or drop the link.

## Files to touch

- GitHub repo settings (description, topics) — via `gh` or UI.
- `.gitattributes` (new, repo root).
- `README.md` (positioning line, comparison section, surfaced benchmark, image).
- `docs/img/` (new diagram or chart asset).

## Acceptance criteria

1. GitHub "About" shows the new description + topics; repo is discoverable under
   `manet` / `ant-colony-optimization`.
2. The GitHub language bar shows **C++** as the primary language.
3. README opens with the positioning statement and contains a
   "Compared to other implementations" section linking the peer repos.
4. At least one diagram/chart renders in the README.
5. No stale "NS-2 only" / "Pre-Alpha" framing remains.

## Risks / notes

- Pure presentation — zero behavioural risk. Safe to do independently of items
  01–08.
- Don't overstate maturity: keep the honest caveats already in `CONTEXT.md §8`
  (no full sim in CI, cross-sim parity not guaranteed). The goal is accurate
  positioning, not hype.
- Cross-linking the Contiki-NG port (different layer, complementary) is good
  citizenship and signals awareness of the field.
