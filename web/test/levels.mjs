// Level test (#567): every campaign level, played from its data with its par
// solution on five seeds, must clear all its objectives -- so no level ships
// impossible -- and played with no action at all must not -- so no level ships
// already solved. Runs the WASM core in Node against an assembled site.
//
// Usage: node web/test/levels.mjs <assembled-site-root>   (web/build-site.sh's output)
import fs from 'node:fs';
import path from 'node:path';
import { pathToFileURL } from 'node:url';

const root = process.argv[2];
if (!root) { console.error('usage: levels.mjs <site-root>'); process.exit(2); }
const url = (p) => pathToFileURL(path.resolve(root, p)).href;
const { default: createAntHocNet } = await import(url('anthocnet.js'));
const { LevelRun } = await import(url('js/campaign/engine.js'));
const { LEVELS } = await import(url('js/campaign/levels.js'));
const { UPGRADES } = await import(url('js/campaign/upgrades.js'));
const { useStrings } = await import(url('js/i18n.js'));
useStrings(JSON.parse(fs.readFileSync(path.join(root, 'i18n/en.json'), 'utf8')));
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
// Upgrades (#579): each must reach the core -- its Config keys read back set,
// its metric found (applyUpgrades throws otherwise). Whether it changes the
// level that earns it is reported, not required: on a one-path level a
// mechanism that ranks next hops has nothing to rank.
const KEYS = { quiet: ['enableQuietMode'], lookahead: ['shareKinematics', 'enableLinkLifetime'], longhaul: ['hopTimeSec'], battery: [] };
for (const u of UPGRADES) {
  const level = LEVELS.find((l) => l.id === u.unlock);
  const play = (ups) => {
    const run = new LevelRun(M, level, 1, { upgrades: ups });
    const keys = Object.fromEntries((KEYS[u.id] || []).map((k) => [k, run.world.getConfig(k)]));
    run.applyPar();
    const s = run.runToEnd();
    const out = `${run.world.antTransmissions()}/${s.objectives.map((o) => o.value).join('/')}`;
    run.delete();
    return { out, keys };
  };
  let off, on;
  try { off = play([]); on = play([u.id]); } catch (e) { failed++; console.log(`FAIL: upgrade ${u.id}: ${e.message}`); continue; }
  const unset = Object.keys(on.keys).filter((k) => on.keys[k] === off.keys[k]);
  if (!(u.id in KEYS) || unset.length) { failed++; console.log(`FAIL: upgrade ${u.id} does not reach the core (${unset.join(', ') || 'no key list'})`); continue; }
  console.log(`ok: upgrade ${u.id} reaches the core; on ${level.id} ants/objectives ${off.out} -> ${on.out}${off.out === on.out ? ' (one path: nothing to rank)' : ''}`);
}
if (failed) { console.log(`levels: FAIL (${failed})`); process.exit(1); }
console.log(`levels: PASS (${LEVELS.length} levels × ${SEEDS.length} seeds)`);
