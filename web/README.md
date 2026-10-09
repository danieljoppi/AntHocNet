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
w.delete();
```

Event kinds (`Ev` in `sim.h`, append-only): 1 TxAnt, 2 RxAnt, 3 TxData,
4 Deliver, 5 Drop, 6 RouteAdd, 7 RouteDel, 8 Queue, 9 TxFail, 10 NodeDown,
11 NodeUp.

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
