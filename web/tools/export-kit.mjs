// Build the learn site's ns-3 export kit (#640) for a built-in world, headless:
// the same web/site/js/kit.js the "Export to ns-3" button uses, on the WASM
// core in Node. CI runs one kit per world in the ns-3 image (ci.yml).
// Usage: node web/tools/export-kit.mjs <site-root> <world> <out-dir> [seconds=60] [seed=1]
import fs from 'node:fs';
import path from 'node:path';
import { pathToFileURL } from 'node:url';

const [root, world, out, secs = '60', seedArg = '1'] = process.argv.slice(2);
if (!root || !world || !out) { console.error('usage: export-kit.mjs <site-root> <world> <out-dir> [seconds] [seed]'); process.exit(2); }
const url = (p) => pathToFileURL(path.resolve(root, p)).href;
const { default: createAntHocNet } = await import(url('anthocnet.js'));
const { useStrings } = await import(url('js/i18n.js'));
useStrings(JSON.parse(fs.readFileSync(path.join(root, 'i18n/en.json'), 'utf8')));
const { KitRecorder, sceneFrom, buildKit } = await import(url('js/kit.js'));
const { worldById } = await import(url('js/worlds.js'));

const M = await createAntHocNet();
const seed = Number(seedArg);
const w = new M.World(seed, world);
w.start();
const rec = new KitRecorder();
rec.tick(w);
for (let k = 1; k * 0.1 <= Number(secs) + 1e-9; k++) { w.advanceTo(k * 0.1); w.drainEvents(); rec.tick(w); }
const meta = worldById(world);
const kit = buildKit(sceneFrom(w, rec, { worldId: world, seed, title: meta.title, results: meta.results, ranges: world === 'town' }));
fs.mkdirSync(out, { recursive: true });
for (const [name, text] of Object.entries(kit.files)) {
  fs.writeFileSync(path.join(out, name), text);
  if (name.endsWith('.sh')) fs.chmodSync(path.join(out, name), 0o755);
}
console.log(`kit: ${world} seed ${seed}, ${rec.samples.length} samples -> ${out} (${Object.keys(kit.files).join(', ')})`);
