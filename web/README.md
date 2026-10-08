# web/ — the browser adapter

The third adapter for the shared AntHocNet core, next to `ns3/` and `ns2/`
([ADR-0021](../docs/adr/0021-the-browser-is-an-adapter.md), [#544](https://github.com/danieljoppi/AntHocNet/issues/544)).
It compiles `core/` to WebAssembly so the learn site
([#542](https://github.com/danieljoppi/AntHocNet/issues/542)) teaches the
protocol by running **the** protocol, not a look-alike.

| path | what |
|---|---|
| `include/ahn_web/sim.h`, `src/sim.cpp` | the adapter + a small discrete-event teaching radio: clock, per-node RNG streams, hello/proactive/reactive-retry timers, pending queue, FIFO transmitter, mobility (static, random waypoint, Gauss–Markov 2-D/3-D, Manhattan), channels (disk, urban buildings, ISL) |
| `include/ahn_web/scenarios.h`, `src/scenarios.cpp` | one built-in world per family: `line`, `manet` (default), `mesh`, `fanet`, `vanet`, `satellite` |
| `src/bindings.cpp` | the Embind API the site's JavaScript calls (WASM build only) |
| `src/trace_main.cpp` | `ahn-web-trace`: runs every scenario and prints the full event log |
| `test/parity.sh` | the native-vs-WASM byte-identical trace gate (CI job `web-parity`) |

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
```

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
