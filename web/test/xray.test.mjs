// The X-ray's promise (#637): the fields the game shows for an ant are what a
// native build of the core's codec decodes from the same bytes.
//   1. run a world in the WASM core, number its TxAnt events as the page does,
//      and take a sample of transmissions from the X-ray ring (every ant type);
//   2. each sample's decoded type and direction match its TxAnt event, and its
//      byte ranges (web/site/js/xray.js segments) tile the frame exactly;
//   3. the native ahn-web-trace --decode, fed the same bytes, prints the same
//      fields, value for value;
//   4. an id the ring has dropped reads back empty.
// Usage: node web/test/xray.test.mjs   (after web/test/parity.sh has built
//        web/build/ahn-web-trace and web/build-wasm/anthocnet.js)
import path from 'node:path';
import { execFileSync } from 'node:child_process';
import { fileURLToPath, pathToFileURL } from 'node:url';

const repo = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../..');
const { default: createAntHocNet } = await import(pathToFileURL(path.join(repo, 'web/build-wasm/anthocnet.js')).href);
const { segments } = await import(pathToFileURL(path.join(repo, 'web/site/js/xray.js')).href);
const M = await createAntHocNet();
let failed = 0;
const check = (name, ok, detail = '') => { if (!ok) failed++; console.log(`${ok ? 'ok  ' : 'FAIL'} ${name}${ok ? '' : ': ' + detail}`); };

const samples = [];
for (const [world, seed, until] of [['manet', 1, 20], ['satellite', 2, 8], ['line', 1, 12]]) {
  const w = new M.World(seed, world);
  w.start();
  const tx = [];
  for (let k = 1; k * 0.1 <= until + 1e-9; k++) {
    w.advanceTo(k * 0.1);
    const f = w.drainEvents();
    for (let i = 0; i < f.length; i += 7) if (f[i + 1] === 1) tx.push({ id: tx.length, type: f[i + 4], dir: f[i + 5] });
  }
  // Every third of the last 500 (all still in the 512-deep ring).
  for (const e of tx.slice(-500).filter((_, k) => k % 3 === 0)) {
    const bytes = w.antBytes(e.id);
    const fields = JSON.parse(M.decodeAnt(bytes));
    samples.push({ world, e, bytes: Array.from(bytes), fields });
  }
  check(`${world}: ${tx.length} transmissions, an evicted id reads back empty`, tx.length > 600 ? w.antBytes(0).length === 0 : true);
  w.delete();
}

const types = new Set(samples.map((s) => s.e.type));
check(`samples cover ant types ${[...types].sort((a, b) => a - b).join(',')}`, types.has(1) && types.has(2) && samples.length >= 10, `${samples.length} samples`);
let tiled = 0, matched = 0;
for (const s of samples) {
  const f = s.fields;
  if (!f.ok || f.type !== s.e.type || f.direction !== s.e.dir || f.length !== s.bytes.length) {
    check(`${s.world} #${s.e.id}: decoded type/direction match its TxAnt`, false, JSON.stringify({ f, e: s.e }).slice(0, 200));
    continue;
  }
  const seg = segments(s.bytes);
  const contiguous = seg.every((x, k) => x.from === (k ? seg[k - 1].to : 0)) && seg.at(-1).to === s.bytes.length;
  const counts = ['visited', 'history', 'helloDests'].every((k) => seg.filter((x) => x.key === k).length === f[k].length);
  if (contiguous && counts) tiled++;
  else check(`${s.world} #${s.e.id}: byte ranges tile the frame`, false, JSON.stringify(seg.map((x) => [x.key, x.from, x.to])).slice(0, 200));
}
check(`byte ranges tile all ${samples.length} frames`, tiled === samples.length);

const hex = samples.map((s) => s.bytes.map((b) => b.toString(16).padStart(2, '0')).join('')).join('\n') + '\n';
const native = execFileSync(path.join(repo, 'web/build/ahn-web-trace'), ['--decode'], { input: hex, encoding: 'utf8' }).trim().split('\n').map((l) => JSON.parse(l));
samples.forEach((s, k) => {
  if (JSON.stringify(native[k]) === JSON.stringify(s.fields)) matched++;
  else check(`${s.world} #${s.e.id}: native decode equals the page's`, false, `${JSON.stringify(native[k]).slice(0, 120)} vs ${JSON.stringify(s.fields).slice(0, 120)}`);
});
check(`native codec reproduces the shown fields for all ${samples.length} samples`, matched === samples.length);

console.log(failed ? `xray: FAIL (${failed})` : 'xray: PASS');
process.exit(failed ? 1 : 0);
