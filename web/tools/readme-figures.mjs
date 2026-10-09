// Regenerates the two README figures from the real game (docs/images/
// readme-how-it-routes.png, readme-network-types.png). Serves an assembled
// site, captures frames in headless Chromium (three steps of the line world,
// one frame per network world), then composes them with readme-figures.html.
// The learn-site skill has the procedure; this lives under web/ (not .claude/)
// because committed docs depend on it (ADR-0014 amendment).
//
// Usage: node web/tools/readme-figures.mjs <site-root> <out-dir>
//   (playwright-core resolved from cwd, like web/test/smoke.mjs)
import http from 'node:http'; import fs from 'node:fs'; import path from 'node:path'; import os from 'node:os';
import { createRequire } from 'node:module';
const require = createRequire(path.join(process.cwd(), 'noop.js'));
const { chromium } = require('playwright-core');
const [root, out] = process.argv.slice(2);
if (!root || !out) { console.error('usage: readme-figures.mjs <site-root> <out-dir>'); process.exit(2); }
const here = path.dirname(new URL(import.meta.url).pathname);
const frames = fs.mkdtempSync(path.join(os.tmpdir(), 'ahn-fig-'));
const types = { '.html': 'text/html', '.js': 'text/javascript', '.css': 'text/css', '.wasm': 'application/wasm' };
const server = http.createServer((req, res) => { let p = decodeURIComponent(req.url.split('?')[0]); if (p.endsWith('/')) p += 'index.html';
  const f = path.join(root, p); if (!fs.existsSync(f)) { res.writeHead(404); res.end(); return; }
  res.writeHead(200, { 'content-type': types[path.extname(f)] || 'application/octet-stream' }); fs.createReadStream(f).pipe(res); }).listen(0);
const base = `http://127.0.0.1:${server.address().port}/`;
const preinstalled = '/opt/pw-browsers/chromium-1194/chrome-linux/chrome';
const b = await chromium.launch({ executablePath: process.env.CHROMIUM || (fs.existsSync(preinstalled) ? preinstalled : undefined) });
const errs = [];
async function open(hash, scheme = 'light') {
  const p = await b.newPage({ viewport: { width: 1280, height: 860 }, colorScheme: scheme, deviceScaleFactor: 1.5 });
  p.on('pageerror', (e) => errs.push(e.message));
  await p.goto(base + hash);
  await p.waitForFunction(() => document.getElementById('clock')?.textContent.includes('t 0:0'));
  await p.addStyleTag({ content: '.toast,.mapwin>.titlebar{display:none!important}' });
  return p;
}
// 1. the three steps, on the line world (6 phones in a row, one flow 0 -> 5)
{
  const p = await open('#line?seed=1');
  await p.evaluate(async () => {
    const { playground } = await import('./js/app.js');
    window.__pg = playground; playground.setSpeed(0); playground.world.advanceTo(1.995);
    const { antKind } = await import('./js/engine.js');
    window.__seen = { reactive: 0, backward: 0, deliver: 0, txdata: 0 };
    playground.on((e) => { if (e.kind === 1) { const k = antKind(e.a, e.b); if (k === 'reactive') window.__seen.reactive++; if (k === 'backward') window.__seen.backward++; } if (e.kind === 4) window.__seen.deliver++; if (e.kind === 3) window.__seen.txdata++; });
  });
  const until = async (key, n, speed) => { await p.evaluate((s) => window.__pg.setSpeed(s), speed); await p.waitForFunction(([k, m]) => window.__seen[k] >= m, [key, n], { timeout: 60000 }); };
  const clip = await p.evaluate(() => {
    const R = window.__pg.renderer, m = document.getElementById('map').getBoundingClientRect();
    const pts = [[0, 0], [1100, 0], [1100, 300], [0, 300]].map(([x, y]) => R.project(x, y, 0));
    const xs = pts.map((q) => q[0]), ys = pts.map((q) => q[1]);
    const y0 = Math.min(...ys) - 70, y1 = Math.max(...ys) + 30;
    return { x: m.left + 4, y: m.top + Math.max(0, y0), width: m.width - 8, height: Math.min(m.height, y1) - Math.max(0, y0) };
  });
  const shot = (n) => p.screenshot({ path: `${frames}/step${n}.png`, clip });
  await until('reactive', 2, 0.01); await p.waitForTimeout(150); await p.evaluate(() => window.__pg.setSpeed(0)); await shot(1);
  await until('backward', 2, 0.02); await p.waitForTimeout(150); await p.evaluate(() => window.__pg.setSpeed(0)); await shot(2);
  await until('deliver', 6, 0.25);
  await p.evaluate(() => { window.__seen.txdata = 0; });
  await until('txdata', 3, 0.03); await p.waitForTimeout(150); await p.evaluate(() => window.__pg.setSpeed(0)); await shot(3);
  await p.close();
}
// 2. every network type
for (const [w, scheme, wait] of [['manet', 'light', 6000], ['mesh', 'light', 5000], ['vanet', 'light', 6000], ['fanet', 'dark', 6000], ['satellite', 'dark', 6000]]) {
  const p = await open(`#${w}?seed=1`, scheme);
  await p.waitForTimeout(wait);
  await p.locator('#map').screenshot({ path: `${frames}/world-${w}.png` });
  await p.close();
}
// 3. compose: the campaign tile is the committed mockup capture.
fs.copyFileSync(path.join(here, '..', '..', 'docs', 'images', 'learn-campaign-map.png'), path.join(frames, 'campaign.png'));
fs.copyFileSync(path.join(here, 'readme-figures.html'), path.join(frames, 'compose.html'));
{
  const p = await b.newPage({ viewport: { width: 1500, height: 900 }, deviceScaleFactor: 1 });
  for (const [f, name] of [['steps', 'readme-how-it-routes.png'], ['types', 'readme-network-types.png']]) {
    await p.goto(`file://${frames}/compose.html?f=${f}`); await p.waitForTimeout(300);
    await p.locator(`#${f}`).screenshot({ path: `${out}/${name}` });
  }
}
await b.close(); server.close();
if (errs.length) { console.error('page errors:', errs); process.exit(1); }
console.log(`wrote ${out}/readme-how-it-routes.png and ${out}/readme-network-types.png`);
