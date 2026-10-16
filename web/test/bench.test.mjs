// The tuning bench's two promises (#638), checked in Node against the real
// WASM core:
//   1. the ghost is a fair control: two worlds on one seed with one Config give
//      identical flow statistics however their advanceTo() calls are sliced
//      (the page advances the live world per frame and the ghost every 250 ms);
//   2. the line the bench copies is exactly the line CI runs through
//      anthocnet-compare (web/tools/config_fields.py ns3-args).
// Usage: node web/test/bench.test.mjs <assembled-site-root>
import fs from 'node:fs';
import path from 'node:path';
import { execFileSync } from 'node:child_process';
import { pathToFileURL } from 'node:url';

const root = process.argv[2];
if (!root) { console.error('usage: bench.test.mjs <site-root>'); process.exit(2); }
const url = (p) => pathToFileURL(path.resolve(root, p)).href;
const { default: createAntHocNet } = await import(url('anthocnet.js'));
const { ns3Line } = await import(url('js/bench.js'));
const M = await createAntHocNet();
let failed = 0;
const check = (name, ok, detail = '') => { if (!ok) failed++; console.log(`${ok ? 'ok  ' : 'FAIL'} ${name}${ok ? '' : ': ' + detail}`); };

// 1. Lockstep determinism, default and moved Config, on three worlds.
for (const [world, config] of [['manet', {}], ['mesh', { betaData: 5 }], ['fanet', { enableProactive: 0, helloInterval: 0.5 }]]) {
  const run = (slice) => {
    const w = new M.World(3, world);
    for (const [k, v] of Object.entries(config)) w.setConfig(k, v);
    w.start();
    for (let k = 1; k * slice < 40; k++) { w.advanceTo(k * slice); w.drainEvents(); }
    w.advanceTo(40);
    const out = Array.from(w.flowStats()).join(',') + ` ants=${w.antTransmissions()}`;
    w.delete();
    return out;
  };
  const a = run(1 / 60), b = run(0.25);
  check(`${world} ${JSON.stringify(config)}: per-frame and 250 ms slices agree`, a === b, `${a.slice(0, 80)} vs ${b.slice(0, 80)}`);
}

// 2. The copied line equals the line CI validates.
const meta = JSON.parse(fs.readFileSync(path.join(root, 'config-fields.json'), 'utf8'));
const moved = { bool: (d) => !d, time: (d) => d * 2, number: (d) => d / 2 };
const values = Object.fromEntries(meta.fields.map((f) => [f.key, moved[f.kind](f.default)]));
const py = execFileSync('python3', [path.join(path.dirname(new URL(import.meta.url).pathname), '../tools/config_fields.py'), 'ns3-args'], { encoding: 'utf8' }).trim();
check('the bench writes the line CI runs', ns3Line(meta, values) === py, `${ns3Line(meta, values)}\n   vs ${py}`);
check('no line when nothing moved', ns3Line(meta, {}) === '');

console.log(failed ? `bench: FAIL (${failed})` : 'bench: PASS');
process.exit(failed ? 1 : 0);
