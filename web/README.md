# web/ — the browser adapter

The second adapter for the shared AntHocNet core, next to `ns3/` (a third,
`ns2/`, shipped through v1.9.0)
([ADR-0021](../docs/adr/0021-the-browser-is-an-adapter.md), [#544](https://github.com/danieljoppi/AntHocNet/issues/544)).
It compiles `core/` to WebAssembly so the learn site
([#542](https://github.com/danieljoppi/AntHocNet/issues/542)) teaches the
protocol by running **the** protocol, not a look-alike.

| path | what |
|---|---|
| `include/ahn_web/sim.h`, `src/sim.cpp` | the adapter + a small discrete-event teaching radio: clock, per-node RNG streams, hello/proactive/reactive-retry timers, pending queue, FIFO transmitter, mobility (static, random waypoint, Gauss–Markov 2-D/3-D, Manhattan, circular orbit), channels (disk, urban buildings, ISL) |
| `include/ahn_web/scenarios.h`, `src/scenarios.cpp` | one built-in world per family: `line`, `manet` (default), `mesh`, `fanet`, `vanet`, `satellite` |
| `src/bindings.cpp` | the Embind API the site's JavaScript calls (WASM build only) |
| `src/trace_main.cpp` | `ahn-web-trace`: runs every scenario and prints the full event log |
| `test/parity.sh` | the native-vs-WASM byte-identical trace gate (CI job `web-parity`) |
| `site/` | the learn site's front end (#545–#547): `index.html`, `css/learn.css`, and plain ES modules — `engine.js` (the WASM module + event vocabulary), `iso.js` (isometric city-builder renderer), `app.js` (tools, camera, status bar, news ticker, ant log, query window), `worlds.js`, `missions.js` + `missions-data.js` |
| `build-site.sh` | assembles `site/` + the WASM build into one servable directory, with content-hashed core URLs (used by `pages.yml` and CI) |
| `site-redirects.sh` | after the Pages build: stubs at the old docs URLs (`/<page>/` → `/docs/<page>/`) and at `/learn/` → `/` |
| `test/smoke.mjs` | the learn-site browser smoke (#548): every world, the shared protocol defaults (ADR-0019), a mission played to the end, axe-core day and night |

## Build

```sh
# native (the parity reference)
cmake -S web -B web/build && cmake --build web/build -j
web/build/ahn-web-trace 60 1 | head

# WebAssembly (needs an activated emsdk, pinned in ci.yml)
emcmake cmake -S web -B web/build-wasm && cmake --build web/build-wasm -j
#   -> web/build-wasm/anthocnet.{js,wasm}: the ES module the site loads
#   -> web/build-wasm/ahn-web-trace.js:    the parity runner (node)

web/test/parity.sh            # both builds, 4 seeds x 6 scenarios, cmp

# the learn site, served locally
web/build-site.sh                       # -> web/build-site/
python3 -m http.server -d web/build-site 8000   # open http://localhost:8000/
# browser smoke (playwright-core + axe-core installed in the working directory)
node web/test/smoke.mjs web/build-site
```

The live site is built by `.github/workflows/pages.yml` as the Pages front page
(`/`), with the docs at `/docs/` and the Doxygen API reference at `/api/`
(`api/Doxyfile`); old `/learn/` and docs URLs redirect (ADR-0021 amendment).

## Using the module

```js
import createAntHocNet from './anthocnet.js';
const M = await createAntHocNet();
const w = new M.World(42, 'manet');   // seed, built-in scenario
w.start();
w.advanceTo(10);                      // simulated seconds
w.positions();      // Float64Array [x, y, z, up, ...]
w.links();          // Int32Array [a, b, ...] current radio links
w.drainEvents();    // Float64Array [t, kind, node, peer, a, b, v, ...]
w.pheromone(0, 29); // Float64Array [neighbour, regular, virtual, ...]
w.moveNode(3, 500, 500, 0); w.setNodeUp(5, false);
w.setNodeRange(3, 120); w.nodeRange(3);   // device radio (#568)
w.delete();
```

Device classes (#568): `setNodeRange(node, metres)` gives a node its own
radio. On the disk and urban channels two nodes link iff they are within
`min(range_a, range_b)`; a node never given a range uses the world's, so the
built-in worlds other than `town` are unchanged. `town` (phones 120 m,
laptops 180 m, PCs 250 m) is the mixed-range world the parity gate covers.

Event kinds (`Ev` in `sim.h`, append-only): 1 TxAnt, 2 RxAnt, 3 TxData,
4 Deliver, 5 Drop, 6 RouteAdd, 7 RouteDel, 8 Queue, 9 TxFail, 10 NodeDown,
11 NodeUp.

## Campaign levels (#567)

A level is data in `web/site/js/campaign/levels.js`; the engine
(`web/site/js/campaign/engine.js`, no DOM) builds its world through the calls
above, runs it, applies its hazards and scores it from flow statistics,
Deliver events and the ant-transmission count, never from anything the page
computes about routes.

| field | meaning |
|---|---|
| `id`, `chapter`, `title`, `story`, `mechanism` | text; `mechanism` is what the debrief names |
| `world.area` `[x, y]`, `world.range` | the field (m) and the default radio |
| `world.devices` `[{ class, x, y, moves, draggable }]` | devices already there, addressed by index; `moves: false` keeps a mobile class still; `draggable` lets the player move it while planning |
| `world.flows` `[{ src, dst, rate, start }]` | the calls, by device index; `rate` in packets/s |
| `budget`, `palette` `[{ class, cost, limit, moves }]` | what the player may add, at what cost |
| `duration` | simulated seconds the level is scored over |
| `objectives` | `{ kind: 'deliver', flows, ratio, from, to }` (delivery over a window, `flows` = ids or `'all'`), `{ kind: 'connect', flow, within }` (first delivery by then), `{ kind: 'quiz', question, options, answer }` |
| `stars` `{ budgetLeft, maxNrl }` | star 1 = every objective; star 2 = budget left ≥ `budgetLeft`; star 3 = ants per delivered packet ≤ `maxNrl`; each hint used costs one |
| `hazards` `[{ at, do: 'down' / 'up' / 'move', device, to }]` | things that happen to the radio |
| `hints`, `debrief` `{ text, links }` | help and the closing card; links open in the in-game reader |
| `par` `[{ class, x, y } / { move, x, y } / { answer }]` | a solution; `web/test/levels.mjs` plays it on seeds 1-5 and requires a clear, and requires the level *not* to clear with no action |

Device classes (`DEVICES` in the engine): phone 120 m and walks, laptop 180 m
and moves now and then, desktop PC 250 m, rooftop router 300 m, repeater
200 m, home gateway 150 m; all static ones stay put. Progress (best stars per
level) lives in `localStorage` under `ahn-campaign-v1`, read and written in
try/catch. Chapters unlock 1 → 2 → 3, 4, 5 (any order) → 6-8 → 9; levels in
a chapter open in order.

```bash
web/build-site.sh && node web/test/levels.mjs web/build-site
```

## Rules

- **No routing logic here.** The adapter converts, executes and owns timers
  and the queue; every routing choice is the core's (`AGENTS.md` rule 2).
  An inspection need the core cannot answer becomes a const accessor in
  `core/` with a core test.
- **Determinism is load-bearing.** Draw randomness into named locals (C++
  argument evaluation order differs between GCC and clang), keep mobility to
  arithmetic and `sqrt`, and keep `-ffp-contract=off`. `parity.sh` fails on
  any divergence.
- **A teaching radio, not ns-3.** Nothing measured here is a benchmark
  number; the results pages are.
