# ADR-0021: The browser is an adapter — the teaching site runs `core/` as WebAssembly

- **Status:** Accepted — governs the learn site ([#542](https://github.com/danieljoppi/AntHocNet/issues/542));
  implemented by [#544](https://github.com/danieljoppi/AntHocNet/issues/544)
- **Date:** 2026-10-08

## Context

v2.0.0 adds an interactive, game-like teaching site (`/learn/`) to the Pages
docs (#542). It animates ants, pheromone, multipath and repair on a canvas
and scores the player against the protocol's own choices. Something has to
*run* the protocol in the browser, and there are two ways to get it there:

1. **A JavaScript model** written for the site: an "AntHocNet-like"
   simulation, tuned to animate nicely.
2. **The real core**, compiled to WebAssembly, driven by a browser adapter.

The project's identity is the paper-faithful reference implementation:
[`fidelity.md`](../fidelity.md) ledgers every deviation from the 2004–2007
sources, and every published number traces to one implementation. Two
`AGENTS.md` golden rules bear on the choice directly:

- **Rule 1:** `core/` never includes a simulator header. Time, randomness,
  neighbours and timers come in through `ports.h`. In practice `core/`
  includes only the C++ standard library.
- **Rule 2:** adapters must not reimplement routing logic. An adapter
  converts messages, executes `RouteDecision`s, and owns timers and the
  pending queue. Behaviour belongs in `core/`.

## Decision

**The browser is a third adapter.** The learn site runs `core/` compiled
with Emscripten. A browser adapter (`web/`) plays the role the NS-2 and NS-3
adapters play: it owns the clock, the RNG streams, the hello / proactive /
reactive-retry timers (with the ns-3 adapter's jitter and defaults), the
pending-packet queue (3 s timeout, 200 ms reconvergence hold cap) and a radio.
It carries out the core's `RouteDecision`s and nothing else. The teaching UI
reads the core's state (pheromone table, neighbours, observer events) and
never recomputes a routing choice.

The radio is a *teaching* model, stated as such on every page:
- a unit disk, optionally cut by buildings (VANET) or replaced by a fixed ISL
  adjacency with distance-tracked delay (satellite);
- a FIFO transmitter per node at 2 Mbit/s;
- a MAC transmit-failure report after 7 attempts when a unicast's receiver is
  out of reach (ADR-0008 detector D).

Nothing measured on it is a benchmark number.

**Parity is a CI gate, not an assumption.** The same `web/` sources build
natively and as WASM. `web/test/parity.sh` runs every built-in scenario for
several seeds in both builds and requires **byte-identical decision traces**:
every ant and data transmission, reception, route change, queue entry and
drop, with simulated time. To keep that achievable, the adapter:
- uses a portable integer RNG (SplitMix64) with one stream per node and
  purpose (core, timers, mobility, placement, loss);
- generates mobility with arithmetic and `sqrt` only, because `sqrt` is
  correctly rounded everywhere and libm transcendentals are not guaranteed to
  match across glibc and musl;
- compiles with `-ffp-contract=off`;
- never relies on function-argument evaluation order. The gate caught exactly
  this on its first run: GCC and clang evaluate `f(r(), r())` in opposite
  orders, so the scenario placement swapped x and y.

The core's own `std::pow` (pheromone weighting, evaporation) proved
bit-identical between glibc and Emscripten's musl on every trace so far: both
ship the same optimized-routines implementation. If a toolchain update ever
breaks that, the gate fails rather than the game silently drifting.

## Alternatives

- **A JavaScript model.** Rejected.
  - It is a second implementation of the algorithm, the thing rule 2
    forbids, and it would drift: every fidelity fix (#179, #180, #185, …)
    would need porting by hand, with nothing checking it.
  - "It is only for teaching" makes it worse. A learner would come away
    with a model of something other than what the benchmarks measured.
- **Run ns-3 in the browser.** Out of scope: ns-3 is far too large, and its
  radio realism is not what a teaching page needs. The results pages already
  carry the measured numbers.
- **Server-side simulation.** Rejected. The site is static GitHub Pages, with
  no backend (#542 ground rules).

## Consequences

- A fidelity fix in `core/` reaches the game with no extra work, the next
  time the site builds.
- `web/` joins `core/`, `ns3/` and `ns2/` as an adapter directory.
  - The golden rules apply to it.
  - The parity job guards it in `ci.yml`.
  - emsdk is pinned to exact versions in CI and in the Pages build.
- **Fixed-at-time-of-writing adapter constants** (`kQueueTimeout`,
  `kReconvHoldCap`, `kRetryInterval`, `kTimerJitter`) mirror the ns-3
  attribute defaults. If those change, change `web/include/ahn_web/sim.h` too.
  A mismatch changes the game's behaviour, not any published number.
- **Inspection-only API gaps** (for example, the forwarding probability
  distribution a mission scores predictions against) are added to `core/` as
  const accessors with a core test, never computed in the adapter.

## Amendment (2026-10-09): the game is the front page

The maintainer moved the learn site from `/learn/` to the Pages root, so the
first thing a visitor meets is the protocol running, not a page about it.

- **Layout:** `/` is the game, `/docs/` the mkdocs site (`site_url` changed
  with it), `/api/` the Doxygen reference. `pages.yml` builds the game first
  (`web/build-site.sh` empties its output directory), then the docs into
  `site/docs/`, then the API reference.
- **Old URLs keep working.** `web/site-redirects.sh` writes a stub at every
  old docs path (`/<page>/` → `/docs/<page>/`, query and hash carried over)
  and at `/learn/` → `/`, and copies the docs' 404 page to the root. It
  refuses to overwrite a game file, so a docs page can never shadow the game.
- **The default world shows mobility.** The MANET world's nodes are phones;
  every third one stays put and the rest walk (random waypoint, unchanged
  speeds). A phone the player places is a static relay. The renderer infers
  speed and heading from successive positions (presentation only, nothing
  feeds back into the adapter) and draws footprints and a heading chevron,
  so movement is visible at teaching speeds. The smoke test checks the mix.
- Every other world's node is drawn as the device it stands for: mesh
  routers on poles, cars oriented along the street, quadcopters, satellites
  with solar wings. Decoration only; the identity colours of ants and
  packets are unchanged.
