// Level test (#567): every campaign level, played from its data with its par
// solution on five seeds, must clear all its objectives -- so no level ships
// impossible -- and played with no action at all must not -- so no level ships
// already solved. Runs the WASM core in Node against an assembled site.
//
// Usage: node web/test/levels.mjs <assembled-site-root>   (web/build-site.sh's output)
import path from 'node:path';
import { pathToFileURL } from 'node:url';

const root = process.argv[2];
if (!root) { console.error('usage: levels.mjs <site-root>'); process.exit(2); }
const url = (p) => pathToFileURL(path.resolve(root, p)).href;
const { default: createAntHocNet } = await import(url('anthocnet.js'));
const { LevelRun } = await import(url('js/campaign/engine.js'));
const { LEVELS } = await import(url('js/campaign/levels.js'));
const M = await createAntHocNet();

const SEEDS = [1, 2, 3, 4, 5];
let failed = 0;
for (const level of LEVELS) {
  const results = [];
  for (const seed of SEEDS) {
    const run = new LevelRun(M, level, seed);
    run.applyPar();
    const s = run.runToEnd();
    results.push(s);
    run.delete();
  }
  const bad = results.map((s, i) => [SEEDS[i], s]).filter(([, s]) => !s.cleared);
  const idle = new LevelRun(M, level, 1);
  const idleScore = idle.runToEnd();
  idle.delete();
  const vals = results.map((s) => s.objectives.map((o) => (typeof o.value === 'number' ? o.value.toFixed(2) : o.value)).join('/')).join(' ');
  const stars = results.map((s) => s.stars).join('');
  if (bad.length) {
    failed++;
    console.log(`FAIL: ${level.id} ${level.title}: par does not clear on seed(s) ${bad.map(([s]) => s).join(', ')} [${vals}]`);
  } else if (idleScore.cleared) {
    failed++;
    console.log(`FAIL: ${level.id} ${level.title}: clears with no action at all`);
  } else {
    console.log(`ok: ${level.id} ${level.title} — par clears on seeds ${SEEDS.join(' ')} (stars ${stars}; objectives ${vals}); idle does not`);
  }
}
if (failed) { console.log(`levels: FAIL (${failed})`); process.exit(1); }
console.log(`levels: PASS (${LEVELS.length} levels × ${SEEDS.length} seeds)`);
