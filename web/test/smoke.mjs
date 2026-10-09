// Browser smoke for the learn site (#548). Serves an assembled site and, in
// headless Chromium:
//   1. opens every world, runs it, and requires no console errors and at
//      least one backward ant and one delivered packet in the event stream;
//   2. plays mission 2 ("Send the scouts") to completion with scripted input;
//   3. runs axe-core on the front page as a first visit sees it (welcome
//      card up, default world) and fails on serious or critical violations;
//   4. checks the default world is mixed: some phones walk, some stand still.
//
// Usage: node web/test/smoke.mjs <assembled-site-root>   (web/build-site.sh's output)
// Env:   CHROMIUM=/path/to/chrome (default: Playwright's pre-installed one)
// Needs: playwright-core and axe-core resolvable from the working directory
//        (CI installs both, pinned, with npm in a scratch directory).
import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';
import { createRequire } from 'node:module';

const root = process.argv[2];
if (!root) { console.error('usage: smoke.mjs <site-root>'); process.exit(2); }
const require = createRequire(path.join(process.cwd(), 'noop.js'));
const { chromium } = require('playwright-core');
const axeSource = fs.readFileSync(require.resolve('axe-core/axe.min.js'), 'utf8');
const types = { '.html': 'text/html', '.js': 'text/javascript', '.css': 'text/css', '.wasm': 'application/wasm' };
const server = http.createServer((req, res) => {
  let p = decodeURIComponent(req.url.split('?')[0].split('#')[0]);
  if (p.endsWith('/')) p += 'index.html';
  const f = path.join(root, p);
  if (!f.startsWith(path.resolve(root)) || !fs.existsSync(f)) { res.writeHead(404); res.end(); return; }
  res.writeHead(200, { 'content-type': types[path.extname(f)] || 'application/octet-stream' });
  fs.createReadStream(f).pipe(res);
}).listen(0);
const port = server.address().port;
const base = `http://127.0.0.1:${port}/`;

// CHROMIUM wins; else the pre-installed dev-container browser if present;
// else whatever `playwright install chromium` put in Playwright's cache (CI).
const preinstalled = '/opt/pw-browsers/chromium-1194/chrome-linux/chrome';
const executablePath = process.env.CHROMIUM || (fs.existsSync(preinstalled) ? preinstalled : undefined);
const browser = await chromium.launch({ executablePath });
let failed = 0;
const fail = (msg) => { console.log('FAIL: ' + msg); failed++; };

async function page(hash) {
  const p = await browser.newPage({ viewport: { width: 1280, height: 860 } });
  const errors = [];
  p.on('console', (m) => { if (m.type() === 'error') errors.push(m.text()); });
  p.on('pageerror', (e) => errors.push(e.message));
  await p.goto(base + hash);
  return { p, errors };
}

// 1. Every world runs and the core does its job in it.
for (const world of ['line', 'manet', 'mesh', 'fanet', 'vanet', 'satellite']) {
  const { p, errors } = await page(`#${world}?seed=1`);
  await p.waitForFunction(() => document.getElementById('clock')?.textContent.includes('t 0:0'), null, { timeout: 15000 });
  // Count kinds from the event stream: subscribe through the playground hook.
  const counts = await p.evaluate(async () => {
    const { playground } = await import('./js/app.js');
    const c = { backward: 0, deliver: 0 };
    playground.on((e) => {
      if (e.kind === 1 && e.b === 18) c.backward++;
      if (e.kind === 4) c.deliver++;
    });
    playground.setSpeed(20);
    await new Promise((r) => setTimeout(r, 6000));
    return c;
  });
  if (errors.length) fail(`${world}: console errors: ${errors.join(' | ')}`);
  if (counts.backward < 1) fail(`${world}: no backward ant in 6 s at 20x`);
  if (counts.deliver < 1) fail(`${world}: no delivered packet in 6 s at 20x`);
  if (!errors.length && counts.backward && counts.deliver) {
    console.log(`ok: ${world} — ${counts.backward} backward ants, ${counts.deliver} deliveries, no console errors`);
  }
  await p.close();
}

// 1b. ADR-0019: a world changes the scenario, never the protocol defaults.
{
  const { p } = await page('#manet?seed=1');
  await p.waitForFunction(() => document.getElementById('clock')?.textContent.includes('t 0:0'), null, { timeout: 15000 });
  const configs = await p.evaluate(async () => {
    const { playground } = await import('./js/app.js');
    const keys = ['betaData', 'betaAnts', 'alpha', 'helloInterval', 'proactiveInterval', 'enableProactive', 'enableMultipath', 'enableRepair'];
    const out = {};
    for (const world of playground.M.scenarios()) {
      const w = new playground.M.World(1, world);
      out[world] = keys.map((k) => `${k}=${w.getConfig(k)}`).join(' ');
      w.delete();
    }
    return out;
  });
  const distinct = new Set(Object.values(configs));
  if (distinct.size !== 1) fail(`worlds differ in protocol config: ${JSON.stringify(configs)}`);
  else console.log(`ok: all ${Object.keys(configs).length} worlds run the same protocol defaults (${[...distinct][0]})`);
  await p.close();
}

// 2. Play mission 2 to the end.
{
  const { p, errors } = await page('#line?seed=1');
  await p.getByRole('button', { name: /2\. Send the scouts/ }).click();
  await p.getByRole('button', { name: '5', exact: true }).click({ timeout: 15000 });
  await p.getByText('Done.').waitFor({ timeout: 60000 });
  const stars = await p.locator('#missionBody .stars').first().getAttribute('aria-label');
  if (errors.length) fail(`mission 2: console errors: ${errors.join(' | ')}`);
  else console.log(`ok: mission 2 completed (${stars})`);
  await p.close();
}

// 3. Accessibility: no serious or critical axe violations (day and night).
for (const scheme of ['light', 'dark']) {
  const p = await browser.newPage({ viewport: { width: 1280, height: 860 }, colorScheme: scheme });
  await p.goto(base);
  await p.waitForTimeout(2500);
  if (await p.locator('#welcome').isHidden()) fail(`front page (${scheme}): welcome card not shown on a first visit`);
  await p.addScriptTag({ content: axeSource });
  const result = await p.evaluate(async () => (await window.axe.run(document, { resultTypes: ['violations'] })).violations
    .filter((v) => v.impact === 'serious' || v.impact === 'critical')
    .map((v) => `${v.id} (${v.impact}): ${v.nodes.slice(0, 3).map((n) => n.target.join(' ')).join('; ')}`));
  if (result.length) fail(`axe (${scheme}): ${result.join(' | ')}`);
  else console.log(`ok: axe (${scheme}) — no serious or critical violations`);
  await p.close();
}

// 4. The default ad hoc world mixes walking and standing phones (#542 follow-up).
{
  const { p, errors } = await page('#manet?seed=1');
  await p.waitForFunction(() => document.getElementById('clock')?.textContent.includes('t 0:0'), null, { timeout: 15000 });
  const moved = await p.evaluate(async () => {
    const { playground } = await import('./js/app.js');
    playground.setSpeed(0);
    const w = playground.world;
    const a = Array.from(w.positions());
    w.advanceTo(w.now() + 20);
    const b = Array.from(w.positions());
    let walk = 0, still = 0;
    for (let i = 0; i < a.length / 4; i++) (Math.hypot(a[4 * i] - b[4 * i], a[4 * i + 1] - b[4 * i + 1]) > 1e-9 ? walk++ : still++);
    return { walk, still };
  });
  if (errors.length) fail(`mixed mobility: console errors: ${errors.join(' | ')}`);
  if (!moved.walk || moved.still < 10) fail(`manet: expected walkers and >= 10 still phones, got ${JSON.stringify(moved)}`);
  else console.log(`ok: manet — ${moved.walk} phones moved in 20 s, ${moved.still} stood still`);
  await p.close();
}

await browser.close();
server.close();
if (failed) { console.log(`learn smoke: FAIL (${failed})`); process.exit(1); }
console.log('learn smoke: PASS');
