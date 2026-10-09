// Browser smoke for the learn site (#548). Serves an assembled site and, in
// headless Chromium:
//   1. opens every world, runs it, and requires no console errors and at
//      least one backward ant and one delivered packet in the event stream;
//   2. plays mission 2 ("Send the scouts") to completion with scripted input;
//   3. runs axe-core on the front page as a first visit sees it (the hub up
//      over the default world) and fails on serious or critical violations;
//   3b. the site shell (#626): the hub's buttons and #play, the one top bar
//      on every docs page (axe on each one, from mkdocs' sitemap, day and
//      night), the game, a docs page and the Workshop on a phone,
//      with its five places, and -- when the docs and API are assembled in
//      (web/build-pages.sh) -- the bar, the Try-it rail and axe on a docs
//      page and an API page, day and night;
//   4. checks the default world is mixed (some phones walk, some stand still)
//      and that every satellite moves along its orbit.
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
const types = { '.html': 'text/html', '.js': 'text/javascript', '.css': 'text/css', '.wasm': 'application/wasm', '.json': 'application/json', '.png': 'image/png', '.svg': 'image/svg+xml', '.woff2': 'font/woff2' };
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
  if (await p.locator('#hub').isHidden()) fail(`front page (${scheme}): hub not shown on a first visit`);
  await p.addScriptTag({ content: axeSource });
  const result = await p.evaluate(async () => (await window.axe.run(document, { resultTypes: ['violations'] })).violations
    .filter((v) => v.impact === 'serious' || v.impact === 'critical')
    .map((v) => `${v.id} (${v.impact}): ${v.nodes.slice(0, 3).map((n) => n.target.join(' ')).join('; ')}`));
  if (result.length) fail(`axe (${scheme}): ${result.join(' | ')}`);
  else console.log(`ok: axe (${scheme}) — no serious or critical violations`);
  await p.close();
}

// 3b. The site shell (#626/#627/#628/#629/#632).
{
  const p = await browser.newPage({ viewport: { width: 1280, height: 860 } });
  const errors = [];
  p.on('pageerror', (e) => errors.push(e.message));
  await p.goto(base);
  const places = await p.locator('.ahn-bar .ahn-place').allTextContents();
  if (places.map((t) => t.trim()).join('|') !== 'Play|Field guide|Lab|Workshop|Archive') fail(`top bar places: ${places}`);
  await p.getByRole('button', { name: 'Free play' }).click();
  if (await p.locator('#hub').isVisible()) fail('hub: Free play did not close it');
  await p.goto(base + '#play');
  await p.waitForTimeout(500);
  if (await p.locator('#hub').isVisible()) fail('hub: #play should open the game directly');
  if (errors.length) fail(`shell: console errors: ${errors.join(' | ')}`);
  else console.log('ok: hub opens on a first visit, closes on Free play, #play skips it; top bar has the five places');
  await p.close();
}
if (fs.existsSync(path.join(root, 'docs', 'index.html'))) {
  const surfaces = [
    ['docs page', 'docs/benchmarks/scenarios/vanet/', 'lab'],
    ['place page', 'docs/places/workshop/', 'shop'],
    ['API page', 'api/classanthocnet_1_1core_1_1PheromoneTable.html', 'shop'],
  ];
  for (const scheme of ['light', 'dark']) {
    for (const [name, url, place] of surfaces) {
      const p = await browser.newPage({ viewport: { width: 1280, height: 860 }, colorScheme: scheme });
      const errors = [];
      p.on('pageerror', (e) => errors.push(e.message));
      await p.goto(base + url);
      await p.waitForTimeout(400);
      const current = await p.locator('.ahn-bar .ahn-place[aria-current="page"]').getAttribute('data-place').catch(() => null);
      if (current !== place) fail(`${name}: active place ${current}, expected ${place}`);
      if (name === 'docs page') {
        const href = await p.locator('.ahn-try a').first().getAttribute('href');
        if (!href || !href.endsWith('#vanet?seed=1')) fail(`docs page: Try-it link ${href}`);
      }
      await p.addScriptTag({ content: axeSource });
      const result = await p.evaluate(async () => (await window.axe.run(document, { resultTypes: ['violations'] })).violations
        .filter((v) => v.impact === 'serious' || v.impact === 'critical')
        .map((v) => `${v.id} (${v.impact}): ${v.nodes.slice(0, 3).map((n) => n.target.join(' ')).join('; ')}`));
      if (result.length) fail(`axe ${name} (${scheme}): ${result.join(' | ')}`);
      if (errors.length) fail(`${name} (${scheme}): page errors: ${errors.join(' | ')}`);
      if (!result.length && !errors.length) console.log(`ok: ${name} (${scheme}) — top bar on ${place}, axe clean`);
      await p.close();
    }
  }
  // Every docs page (#626): from mkdocs' sitemap, each one loads without a
  // page error, carries the top bar, and passes axe (serious/critical), day
  // and night (the night palette is a separate set of colours to get wrong).
  const xml = fs.readFileSync(path.join(root, 'docs', 'sitemap.xml'), 'utf8');
  const urls = [...xml.matchAll(/<loc>([^<]+)<\/loc>/g)].map((m) => new URL(m[1]).pathname.replace(/^\/AntHocNet\//, ''));
  for (const scheme of ['light', 'dark']) {
    const p = await browser.newPage({ viewport: { width: 1280, height: 860 }, colorScheme: scheme });
    let errorsHere = [];
    p.on('pageerror', (e) => errorsHere.push(e.message));
    await p.addInitScript({ content: axeSource });
    let bad = 0;
    for (const u of urls) {
      errorsHere = [];
      await p.goto(base + u, { waitUntil: 'load' });
      const bar = await p.locator('.ahn-bar').count();
      const result = await p.evaluate(async () => (await window.axe.run(document, { resultTypes: ['violations'] })).violations
        .filter((v) => v.impact === 'serious' || v.impact === 'critical').map((v) => v.id + ': ' + v.nodes.slice(0, 2).map((n) => n.target.join(' ')).join('; ')));
      // Material loads mermaid from a CDN; whether the CDN answered is not
      // what this checks (and CI must not fail on a CDN hiccup).
      const own = errorsHere.filter((e) => !/^Invalid script: https?:\/\//.test(e));
      const problems = [...(bar ? [] : ['no top bar']), ...result, ...own.map((e) => 'page error: ' + e)];
      if (problems.length) { bad++; fail(`docs ${u} (${scheme}): ${problems.join(' | ')}`); }
    }
    await p.close();
    if (!bad) console.log(`ok: all ${urls.length} docs pages (${scheme}) — top bar, no page errors, axe clean`);
  }
  // The in-game reader (#630): '?' opens the world's Field guide page over the
  // running world; the clock keeps advancing; a docs link stays in the reader;
  // search from the bar opens a hit in the reader; axe passes with it open.
  {
    const p = await browser.newPage({ viewport: { width: 1280, height: 860 } });
    const errors = [];
    p.on('pageerror', (e) => errors.push(e.message));
    await p.goto(base + '#vanet?seed=1');
    await p.waitForFunction(() => document.getElementById('clock')?.textContent.includes('t 0:0'), null, { timeout: 15000 });
    await p.locator('#map').focus();
    await p.keyboard.press('?');
    await p.locator('#reader h1').first().waitFor({ timeout: 10000 });
    const h1 = (await p.locator('#reader h1').first().textContent()).trim();
    const t0 = await p.evaluate(async () => (await import('./js/app.js')).playground.world.now());
    await p.waitForTimeout(1500);
    const t1 = await p.evaluate(async () => (await import('./js/app.js')).playground.world.now());
    if (!(t1 > t0)) fail(`reader: the world stopped while reading (${t0} -> ${t1})`);
    // A link to another docs page (not an anchor on this one).
    const link = p.locator('#readerBody a[href*="/docs/"]:not([data-anchor])').filter({ hasNotText: /^$/ })
      .and(p.locator(`#readerBody a:not([href^="${await p.locator('#readerOut').getAttribute('href')}"])`)).first();
    if (await link.count()) {
      const before = await p.locator('#readerOut').getAttribute('href');
      await link.click();
      await p.waitForFunction((b) => document.getElementById('readerOut').href !== b, before, { timeout: 10000 });
      if (!(await p.locator('#reader').isVisible())) fail('reader: a docs link left the reader');
    }
    await p.addScriptTag({ content: axeSource });
    const result = await p.evaluate(async () => (await window.axe.run(document, { resultTypes: ['violations'] })).violations
      .filter((v) => v.impact === 'serious' || v.impact === 'critical').map((v) => v.id + ': ' + v.nodes.slice(0, 2).map((n) => n.target.join(' ')).join('; ')));
    if (result.length) fail(`axe with the reader open: ${result.join(' | ')}`);
    await p.keyboard.press('Escape');
    await p.fill('#ahn-q', 'repair ant');
    await p.locator('#ahn-results a').first().waitFor({ timeout: 5000 });
    await p.locator('#ahn-results a').first().click();
    await p.locator('#reader h1').first().waitFor({ timeout: 10000 });
    if (!p.url().includes('#vanet')) fail(`reader: search left the game (${p.url()})`);
    if (errors.length) fail(`reader: page errors: ${errors.join(' | ')}`);
    else if (!result.length) console.log(`ok: reader — "?" opened "${h1}" over a running world (t ${t0.toFixed(1)} -> ${t1.toFixed(1)} s), links and search stay in the game, axe clean`);
    await p.close();
  }
  // The Workshop (#634): the Nest draws every chamber, a chamber shows its
  // classes from the API index, the quest ticks steps from pasted doctor output.
  for (const scheme of ['light', 'dark']) {
    const p = await browser.newPage({ viewport: { width: 1280, height: 860 }, colorScheme: scheme });
    const errors = [];
    p.on('pageerror', (e) => errors.push(e.message));
    await p.goto(base + 'workshop.html');
    await p.waitForFunction(() => /t \d+:\d\d/.test(document.getElementById('nestLive').textContent), null, { timeout: 15000 });
    const chambers = await p.locator('#nest .chamber').count();
    await p.waitForFunction(() => fetch('api/api-index.json').then((r) => r.ok));
    await p.locator('#nest .chamber[data-id="store"]').click();
    await p.locator('#chamberBody .ws-classes a', { hasText: 'PheromoneTable' }).waitFor();
    const href = await p.locator('#chamberBody .ws-classes a', { hasText: 'PheromoneTable' }).getAttribute('href');
    await p.fill('#questPaste', '##DOCTOR## v=1 ns3=3.42 cmake=3.28.3 cxx=g++-13.3.0 python=3.11.15 contrib=writable module=installed baselines=aomdv:ok,gpsr:ok,oracle:ok built=yes verdict=ok');
    await p.click('#questCheck');
    const score = (await p.locator('#questScore').textContent()).trim();
    if (chambers !== 8) fail(`workshop: ${chambers} chambers drawn, expected 8`);
    if (!href || !href.endsWith('classanthocnet_1_1core_1_1PheromoneTable.html')) fail(`workshop: PheromoneTable link ${href}`);
    if (score !== '4 / 5') fail(`workshop: quest score ${score} after a full doctor line, expected 4 / 5`);
    const current = await p.locator('.ahn-bar .ahn-place[aria-current="page"]').getAttribute('data-place').catch(() => null);
    if (current !== 'shop') fail(`workshop: active place ${current}`);
    await p.addScriptTag({ content: axeSource });
    const result = await p.evaluate(async () => (await window.axe.run(document, { resultTypes: ['violations'] })).violations
      .filter((v) => v.impact === 'serious' || v.impact === 'critical').map((v) => v.id + ': ' + v.nodes.slice(0, 2).map((n) => n.target.join(' ')).join('; ')));
    if (result.length) fail(`axe workshop (${scheme}): ${result.join(' | ')}`);
    if (errors.length) fail(`workshop (${scheme}): page errors: ${errors.join(' | ')}`);
    if (!result.length && !errors.length) console.log(`ok: workshop (${scheme}) — ${chambers} chambers, PheromoneTable from the API index, quest ${score}, axe clean`);
    await p.close();
  }
  // On a phone (#627's 720 px breakpoint): the game, a docs page and the
  // Workshop keep the top bar, never scroll sideways, and pass axe.
  for (const [name, url] of [['game', '#play'], ['docs page', 'docs/benchmarks/scenarios/vanet/'], ['workshop', 'workshop.html']]) {
    const p = await browser.newPage({ viewport: { width: 390, height: 844 }, isMobile: true, hasTouch: true });
    const errors = [];
    p.on('pageerror', (e) => errors.push(e.message));
    await p.goto(base + url);
    await p.waitForTimeout(600);
    const bar = await p.locator('.ahn-bar').isVisible().catch(() => false);
    const over = await p.evaluate(() => document.documentElement.scrollWidth - document.documentElement.clientWidth);
    await p.addScriptTag({ content: axeSource });
    const result = await p.evaluate(async () => (await window.axe.run(document, { resultTypes: ['violations'] })).violations
      .filter((v) => v.impact === 'serious' || v.impact === 'critical').map((v) => v.id + ': ' + v.nodes.slice(0, 2).map((n) => n.target.join(' ')).join('; ')));
    const own = errors.filter((e) => !/^Invalid script: https?:\/\//.test(e));
    const problems = [...(bar ? [] : ['no visible top bar']), ...(over > 1 ? [`scrolls sideways by ${over} px`] : []), ...result, ...own.map((e) => 'page error: ' + e)];
    if (problems.length) fail(`phone ${name}: ${problems.join(' | ')}`);
    else console.log(`ok: phone ${name} — top bar, no sideways scroll, axe clean`);
    await p.close();
  }
  // Search from the bar finds a page and shows its place.
  const p = await browser.newPage();
  await p.goto(base + 'docs/');
  await p.fill('#ahn-q', 'pheromone evaporation');
  await p.locator('#ahn-results a').first().waitFor({ timeout: 5000 });
  console.log(`ok: search — first hit "${(await p.locator('#ahn-results a').first().textContent()).trim().slice(0, 60)}"`);
  await p.close();
} else {
  console.log('skip: docs/API not assembled (web/build-site.sh only); web/build-pages.sh adds them');
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
{
  const { p, errors } = await page('#satellite?seed=1');
  await p.waitForFunction(() => document.getElementById('clock')?.textContent.includes('t 0:0'), null, { timeout: 15000 });
  const orbit = await p.evaluate(async () => {
    const { playground } = await import('./js/app.js');
    playground.setSpeed(0);
    const w = playground.world;
    const a = Array.from(w.positions());
    w.advanceTo(w.now() + 10);
    const b = Array.from(w.positions());
    let moved = 0, n = a.length / 4, rMin = Infinity, rMax = 0;
    const cx = w.areaX() / 2, cy = w.areaY() / 2;
    for (let i = 0; i < n; i++) {
      if (Math.hypot(a[4 * i] - b[4 * i], a[4 * i + 1] - b[4 * i + 1], a[4 * i + 2] - b[4 * i + 2]) > 1e5) moved++;
      const r = Math.hypot(b[4 * i] - cx, b[4 * i + 1] - cy, b[4 * i + 2]);
      rMin = Math.min(rMin, r); rMax = Math.max(rMax, r);
    }
    return { n, moved, rMin, rMax };
  });
  if (errors.length) fail(`orbits: console errors: ${errors.join(' | ')}`);
  // Chords of the circle sit a little inside it: allow 0.1 % below the radius.
  if (orbit.moved !== orbit.n || orbit.rMax > 7.5711e6 || orbit.rMin < 7.563e6) fail(`satellite: expected all on 7571 km orbits and moving, got ${JSON.stringify(orbit)}`);
  else console.log(`ok: satellite — all ${orbit.n} moved >100 km in 10 s on their 7571 km orbits`);
  await p.close();
}

await browser.close();
server.close();
if (failed) { console.log(`learn smoke: FAIL (${failed})`); process.exit(1); }
console.log('learn smoke: PASS');
