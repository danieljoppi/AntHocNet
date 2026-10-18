// Lab answer keys (#623): every number docs/teaching/ states as an answer is
// measured here, on the WASM core, at the seed the sheet names -- and the
// claim each key makes (A delivers more than B, C costs fewer ants than D) is
// checked. If a core change moves a number, this fails and the sheet is
// updated with it.
//
// Usage: node web/test/labs.mjs <assembled-site-root> [--print]
import fs from 'node:fs';
import path from 'node:path';
import { pathToFileURL } from 'node:url';

const root = process.argv[2];
if (!root) { console.error('usage: labs.mjs <site-root> [--print]'); process.exit(2); }
const url = (p) => pathToFileURL(path.resolve(root, p)).href;
const { default: createAntHocNet } = await import(url('anthocnet.js'));
const { LevelRun } = await import(url('js/campaign/engine.js'));
const { levelById } = await import(url('js/campaign/levels.js'));
const { useStrings } = await import(url('js/i18n.js'));
useStrings(JSON.parse(fs.readFileSync(path.join(root, 'i18n/en.json'), 'utf8')));
const M = await createAntHocNet();

const TX_DATA = 3, DROP = 5;

/** Run a world as the site's playground does, with Config overrides; measure. */
function run(world, seed, seconds, config = {}) {
  const w = new M.World(seed, world);
  for (const [k, v] of Object.entries(config)) w.setConfig(k, v);
  w.start();
  const hops = new Map();  // flow 0's source: next hop -> data packets sent to it
  let src = null, drops = 0;
  for (let t = 1; t <= seconds; t++) {
    w.advanceTo(t);
    if (src === null) src = w.flowStats()[0];
    const ev = w.drainEvents();
    for (let i = 0; i < ev.length; i += 7) {
      if (ev[i + 1] === TX_DATA && ev[i + 2] === src && ev[i + 4] === 0) hops.set(ev[i + 3], (hops.get(ev[i + 3]) || 0) + 1);
      if (ev[i + 1] === DROP) drops++;
    }
  }
  const fs_ = w.flowStats();
  let sent = 0, got = 0;
  for (let i = 0; i < fs_.length; i += 5) { sent += fs_[i + 2]; got += fs_[i + 3]; }
  const ants = w.antTransmissions();
  w.delete();
  const counts = [...hops.values()].sort((a, b) => b - a);
  const total = counts.reduce((a, b) => a + b, 0);
  return { pdr: sent ? got / sent : 0, delivered: got, ants, antsPerPkt: got ? ants / got : Infinity, drops,
           nextHops: counts.length, topShare: total ? counts[0] / total : 0 };
}

/** A campaign level's delivery, bucketed per `bin` seconds (for the timeline labs). */
function levelTimeline(id, bin, edit = (l) => l, par = true) {
  const r = new LevelRun(M, edit(levelById(id)), 1);
  if (par) r.applyPar();
  const out = [];
  let prev = { sent: 0, delivered: 0 };
  for (let t = bin; t <= r.level.duration + 1e-9; t += bin) {
    r.advance(t);
    const now = r.totalsAt(t, 'all');
    const s = now.sent - prev.sent, d = now.delivered - prev.delivered;
    out.push(s ? d / s : 0);
    prev = now;
  }
  r.delete();
  return out;
}

const pct = (x) => `${(100 * x).toFixed(1)} %`;
const results = [];
let failed = 0;
function claim(lab, text, ok, detail) {
  results.push(`${ok ? 'ok' : 'FAIL'}: lab ${lab} — ${text} (${detail})`);
  if (!ok) failed++;
}

// Lab 1: reactive vs proactive (manet, seed 6, 60 s) -- mission 7's world.
{
  const on = run('manet', 6, 60), off = run('manet', 6, 60, { enableProactive: 0 });
  claim(1, 'on the teaching radio, delivery is within 2 points either way', Math.abs(on.pdr - off.pdr) <= 0.02,
    `PDR on ${pct(on.pdr)}, off ${pct(off.pdr)}; ants on ${on.ants}, off ${off.ants}`);
  claim(1, 'proactive ants cost transmissions', on.ants > off.ants, `${on.ants} vs ${off.ants}`);
}

// Lab 2: overhead on a static mesh (mesh, seed 8, 120 s) -- quiet mode is the
// default since v2.3.0 (#571); the bench switches it off to see what it saves.
{
  const base = run('mesh', 8, 120), loud = run('mesh', 8, 120, { enableQuietMode: 0 });
  claim(2, 'quiet mode (the default) spends fewer ants per delivered packet than with it off', base.antsPerPkt < loud.antsPerPkt,
    `ants/packet off ${loud.antsPerPkt.toFixed(2)} -> default ${base.antsPerPkt.toFixed(2)}; PDR ${pct(loud.pdr)} -> ${pct(base.pdr)}`);
  claim(2, 'quiet mode keeps delivery within 2 points', base.pdr >= loud.pdr - 0.02, `${pct(loud.pdr)} -> ${pct(base.pdr)}`);
}

// Lab 3: VANET reconvergence (campaign 3.4: sixteen cars, ten park at 60 s).
{
  const tl = levelTimeline('3.4', 10);
  const dense = tl.slice(1, 6), sparse = tl.slice(6);
  const avg = (a) => a.reduce((x, y) => x + y, 0) / a.length;
  claim(3, 'with five roadside units, delivery still falls when the streets empty at 60 s', avg(sparse) < avg(dense),
    `per 10 s: ${tl.map((x) => Math.round(100 * x)).join(' ')} %; 10-60 s ${pct(avg(dense))}, after ${pct(avg(sparse))}`);
  const bare = levelTimeline('3.4', 10, undefined, false);
  claim(3, 'without roadside units the empty streets deliver less than with them', avg(bare.slice(6)) < avg(sparse),
    `no units, per 10 s: ${bare.map((x) => Math.round(100 * x)).join(' ')} %; 10-60 s ${pct(avg(bare.slice(1, 6)))}, after ${pct(avg(bare.slice(6)))}`);
}

// Lab 4: satellite handover and a failed link (campaign 5.3: three ISLs cut at 40 s).
{
  const tl = levelTimeline('5.3', 10);
  const uncut = levelTimeline('5.3', 10, (l) => ({ ...l, hazards: [] }));
  const period = uncut.slice(1, 6).every((x, i) => i + 7 >= uncut.length || Math.abs(x - uncut[i + 7]) <= 0.05);  // bin 0 is warm-up
  claim(4, 'after warm-up, delivery follows the orbit: it repeats every 60 s', period,
    `uncut, per 10 s: ${uncut.map((x) => Math.round(100 * x)).join(' ')} %`);
  const loss = (uncut[4] + uncut[5]) - (tl[4] + tl[5]);
  const back = Math.max(...tl.slice(7).map((x, i) => Math.abs(x - uncut[i + 7])));
  claim(4, 'the cut costs delivery at 40-60 s, then the ants route around it', loss > 0 && back <= 0.05,
    `cut, per 10 s: ${tl.map((x) => Math.round(100 * x)).join(' ')} %; 40-60 s ${Math.round(50 * loss)} points lower on average; after 70 s within ${Math.round(100 * back)} points of uncut`);
}

// Lab 5: stochastic multipath (mesh, seed 4, 120 s) -- mission 5's world, betaData via the bench.
{
  const soft = run('mesh', 4, 120, { betaData: 1 }), def = run('mesh', 4, 120), greedy = run('mesh', 4, 120, { betaData: 30 });
  claim(5, 'a higher betaData concentrates data on the best next hop', greedy.topShare >= def.topShare && def.topShare >= soft.topShare,
    `top next hop share: betaData 1 ${pct(soft.topShare)} (${soft.nextHops} hops), default ${pct(def.topShare)} (${def.nextHops}), 30 ${pct(greedy.topShare)} (${greedy.nextHops})`);
}

for (const r of results) console.log(r);
if (failed) { console.log(`labs: FAIL (${failed})`); process.exit(1); }
console.log(`labs: PASS (${results.length} claims)`);
