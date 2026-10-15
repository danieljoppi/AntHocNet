// Post-deploy smoke against the live site (#647). Every other page test
// serves the built tree at `/`; GitHub Pages serves it under /AntHocNet/, so
// root-absolute links, the 404 page, the search index paths and the CDN's
// caching only show up live. After pages.yml deploys, this:
//   0. waits until the live engine.js imports the core this build made (the
//      WASM content hash from web/build-site.sh), so it tests the new deploy
//      and not the CDN's cached copy of the old one;
//   1. opens the game, runs it at full speed and requires the HUD's delivered
//      counter to leave zero, with no page error;
//   2. opens a docs page, an API page and the Workshop: top bar, no page error;
//   3. opens a URL that does not exist: HTTP 404, and the 404 page carries the
//      top bar with a home link under the base path.
//
// Usage: node web/test/live-smoke.mjs <base-url> [<core-version-hash>]
//   e.g. node web/test/live-smoke.mjs https://danieljoppi.github.io/AntHocNet/ 3f2a9c...
// Env:   CHROMIUM=/path/to/chrome (default: Playwright's own)
// Needs: playwright-core resolvable from the working directory.
import path from 'node:path';
import { createRequire } from 'node:module';

const base = process.argv[2];
const want = process.argv[3];
if (!base || !base.endsWith('/')) { console.error('usage: live-smoke.mjs <base-url ending in /> [core-hash]'); process.exit(2); }
const require = createRequire(path.join(process.cwd(), 'noop.js'));
const { chromium } = require('playwright-core');
let failed = 0;
const fail = (msg) => { console.log('FAIL: ' + msg); failed++; };

// 0. The new deploy, not a cached old one (Pages caches for 10 minutes).
if (want) {
  const deadline = Date.now() + 15 * 60 * 1000;
  let seen = '';
  for (;;) {
    const r = await fetch(base + 'js/engine.js?nocache=' + Date.now(), { cache: 'no-store' }).catch(() => null);
    seen = r && r.ok ? ((await r.text()).match(/anthocnet\.js\?v=([0-9a-f]+)/) || [])[1] || '' : '';
    if (seen === want) break;
    if (Date.now() > deadline) { fail(`live engine.js still imports core ${seen || '(none)'}, expected ${want} after 15 min`); break; }
    await new Promise((r) => setTimeout(r, 20000));
  }
  if (seen === want) console.log(`ok: live engine.js imports core ${want}`);
}

const browser = await chromium.launch({ executablePath: process.env.CHROMIUM || undefined });
// Material loads mermaid from a CDN; a CDN hiccup is not this site's error.
const own = (errors) => errors.filter((e) => !/^Invalid script: https?:\/\//.test(e));

// 1. The game runs and delivers.
{
  const p = await browser.newPage({ viewport: { width: 1280, height: 860 } });
  const errors = [];
  p.on('pageerror', (e) => errors.push(e.message));
  await p.goto(base + '#manet?seed=1');
  await p.waitForFunction(() => document.getElementById('clock')?.textContent.includes('t 0:0'), null, { timeout: 30000 })
    .catch(() => fail('game: the world clock never started'));
  // Read the HUD as a visitor would: the fastest speed, then the delivered
  // counter ("✓ delivered/sent") must leave zero.
  await p.locator('.speeds button').last().click().catch(() => {});
  await p.waitForFunction(() => /✓ [1-9]/.test(document.getElementById('stDelivered')?.textContent || ''), null, { timeout: 30000 })
    .catch(() => {});
  const hud = (await p.locator('#stDelivered').textContent().catch(() => '')) || '';
  const deliveries = Number((hud.match(/✓ (\d+)/) || [])[1] || 0);
  if (!deliveries) fail(`game: no delivered packet within 30 s (HUD "${hud}")`);
  if (own(errors).length) fail(`game: page errors: ${own(errors).join(' | ')}`);
  if (deliveries && !own(errors).length) console.log(`ok: game — ${deliveries} deliveries, no page errors`);
  await p.close();
}

// 2. A docs page, an API page and the Workshop carry the top bar.
for (const [name, url] of [
  ['docs page', 'docs/benchmarks/scenarios/vanet/'],
  ['API page', 'api/classanthocnet_1_1core_1_1PheromoneTable.html'],
  ['Workshop', 'workshop.html'],
]) {
  const p = await browser.newPage({ viewport: { width: 1280, height: 860 } });
  const errors = [];
  p.on('pageerror', (e) => errors.push(e.message));
  const r = await p.goto(base + url, { waitUntil: 'load' });
  const bar = await p.locator('.ahn-bar').isVisible().catch(() => false);
  const problems = [...(r && r.ok() ? [] : [`HTTP ${r ? r.status() : '?'}`]), ...(bar ? [] : ['no top bar']), ...own(errors).map((e) => 'page error: ' + e)];
  if (problems.length) fail(`${name} (${url}): ${problems.join(' | ')}`);
  else console.log(`ok: ${name} — top bar, no page errors`);
  await p.close();
}

// 3. A missing URL gets the 404 page, with the top bar and a home link under
//    the base path (root-absolute links are what break when the base is wrong).
{
  const p = await browser.newPage();
  const r = await p.goto(base + 'no-such-page-' + Date.now() + '/');
  const bar = await p.locator('.ahn-bar').isVisible().catch(() => false);
  const home = await p.locator('.ahn-bar a').first().getAttribute('href').catch(() => null);
  const basePath = new URL(base).pathname;
  const homeOk = home && new URL(home, p.url()).pathname === basePath;
  if (!r || r.status() !== 404) fail(`404 page: HTTP ${r ? r.status() : '?'}, expected 404`);
  else if (!bar || !homeOk) fail(`404 page: top bar ${bar ? 'shown' : 'missing'}, home link ${home}`);
  else console.log(`ok: 404 page — status 404, top bar, home link -> ${basePath}`);
  await p.close();
}

await browser.close();
if (failed) { console.log(`live smoke: FAIL (${failed})`); process.exit(1); }
console.log('live smoke: PASS');
