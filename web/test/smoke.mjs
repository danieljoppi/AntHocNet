// Browser smoke for the learn site (#548). Serves an assembled site and, in
// headless Chromium:
//   1. opens every world, runs it, and requires no console errors and at
//      least one backward ant and one delivered packet in the event stream;
//   2. plays mission 2 ("Send the scouts") to completion with scripted input,
//      and again in Portuguese (2b, #622); the tuning bench (2c, #638); the X-ray on touch (2d, #637); the ns-3 export (2e, #640);
//   3. runs axe-core on the front page as a first visit sees it (the hub up
//      over the default world) and fails on serious or critical violations;
//   3b. the site shell (#626): the hub's buttons and #play, the one top bar
//      on every docs page (axe on each one, from mkdocs' sitemap, day and
//      night), the game, a docs page and the Workshop on a phone,
//      with its five places, and -- when the docs and API are assembled in
//      (web/build-pages.sh) -- the bar, the Try-it rail and axe on a docs
//      page and an API page, day and night; axe on one API page per Doxygen
//      template (#645); and old URLs landing on their new page with the query
//      and hash intact (#648);
//   4. checks the default world is mixed (some phones walk, some stand still)
//      and that every satellite moves along its orbit;
//   5. goes offline after one visit and requires the game to reload and
//      deliver from the service worker's cache (#624).
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
const types = { '.html': 'text/html', '.js': 'text/javascript', '.css': 'text/css', '.wasm': 'application/wasm', '.json': 'application/json', '.png': 'image/png', '.svg': 'image/svg+xml', '.woff2': 'font/woff2', '.webmanifest': 'application/manifest+json' };
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
for (const world of ['line', 'manet', 'town', 'mesh', 'fanet', 'vanet', 'satellite']) {
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

// 2b. Portuguese (#622): a viewer who picked pt-BR gets the page in it --
//     <html lang>, the chrome, a world that delivers, a mission played to the
//     end in Portuguese -- and axe finds nothing serious there either.
{
  const p = await browser.newPage({ viewport: { width: 1280, height: 860 } });
  const errors = [];
  p.on('pageerror', (e) => errors.push(e.message));
  await p.addInitScript(() => { try { localStorage.setItem('ahn-lang', 'pt-BR'); } catch { /* none */ } });
  await p.goto(base + '#line?seed=1');
  // The clock's text is in the static page; the mission list is drawn by boot.
  await p.locator('#missionBody .missions button').first().waitFor({ timeout: 15000 });
  const lang = await p.evaluate(() => document.documentElement.lang);
  const tools = (await p.locator('.toolbox .titlebar').first().textContent()).trim();
  if (lang !== 'pt-BR' || tools !== 'Ferramentas') fail(`pt-BR: lang=${lang}, tools title "${tools}"`);
  await p.getByRole('button', { name: /2\. Mande as batedoras/ }).click();
  await p.getByRole('button', { name: '5', exact: true }).click({ timeout: 15000 });
  await p.getByText('Pronto.').waitFor({ timeout: 60000 }).catch(() => fail('pt-BR: mission 2 did not finish'));
  const debrief = (await p.locator('#missionBody').textContent()) || '';
  if (!/Foram 5 saltos/.test(debrief)) fail(`pt-BR: mission debrief not in Portuguese: ${debrief.slice(0, 120)}`);
  await p.addScriptTag({ content: axeSource });
  const result = await p.evaluate(async () => (await window.axe.run(document, { resultTypes: ['violations'] })).violations
    .filter((v) => v.impact === 'serious' || v.impact === 'critical')
    .map((v) => `${v.id} (${v.impact}): ${v.nodes.slice(0, 3).map((n) => n.target.join(' ')).join('; ')}`));
  if (result.length) fail(`axe (pt-BR): ${result.join(' | ')}`);
  if (errors.length) fail(`pt-BR: page errors: ${errors.join(' | ')}`);
  if (!result.length && !errors.length && lang === 'pt-BR') console.log('ok: pt-BR — chrome, mission 2 played to the end, axe clean');
  await p.close();
}

// 2c. The tuning bench (#638): every exposed field shows its doc, default,
//     provenance and attribute; moving one restarts the world with a ghost
//     beside it and writes the ns-3 line; axe is clean with the bench open.
{
  const { p, errors } = await page('#mesh?seed=2');
  await p.waitForFunction(() => document.getElementById('clock')?.textContent.includes('t 0:0'), null, { timeout: 15000 });
  await p.locator('#benchWin summary').click();
  const rows = await p.locator('#benchBody .bench-row').count();
  const attrs = await p.locator('#benchBody .bench-row p code').count();
  if (rows < 8 || attrs < rows) fail(`bench: ${rows} rows, ${attrs} attributes`);
  await p.locator('#bench-betaData').evaluate((el) => { el.value = '10'; el.dispatchEvent(new Event('change')); });
  await p.locator('.speeds button').last().click();
  await p.waitForFunction(() => document.querySelectorAll('#benchBody .bench-stats tbody tr').length === 2, null, { timeout: 15000 })
    .catch(() => fail('bench: the ghost comparison never appeared'));
  const line = (await p.locator('#benchBody .bench-line').textContent()).trim();
  if (line !== '--ns3::anthocnet::RoutingProtocol::BetaData=10') fail(`bench: ns-3 line "${line}"`);
  await p.addScriptTag({ content: axeSource });
  const result = await p.evaluate(async () => (await window.axe.run(document, { resultTypes: ['violations'] })).violations
    .filter((v) => v.impact === 'serious' || v.impact === 'critical')
    .map((v) => `${v.id} (${v.impact}): ${v.nodes.slice(0, 3).map((n) => n.target.join(' ')).join('; ')}`));
  if (result.length) fail(`axe (bench open): ${result.join(' | ')}`);
  if (errors.length) fail(`bench: console errors: ${errors.join(' | ')}`);
  if (!result.length && !errors.length && line.endsWith('BetaData=10')) console.log(`ok: tuning bench — ${rows} fields, ghost running, line "${line}", axe clean`);
  await p.close();
}

// 2d. The X-ray (#637), on a touch screen: select a node from the keyboard,
//     tap one of its recent ants -- the world pauses and the Query window
//     shows the ant's fields and its bytes, coloured per field -- axe clean.
{
  const p = await browser.newPage({ viewport: { width: 1280, height: 860 }, hasTouch: true });
  const errors = [];
  p.on('pageerror', (e) => errors.push(e.message));
  await p.goto(base + '#line?seed=1');
  await p.locator('#missionBody .missions button').first().waitFor({ timeout: 15000 });
  await p.locator('.speeds button').last().click();
  await p.waitForTimeout(3000);
  await p.locator('#map').focus();
  await p.keyboard.press(']');
  const chip = p.locator('#inspBody button.chip-btn').first();
  await chip.waitFor({ timeout: 15000 }).catch(() => fail('x-ray: no recent ants listed for node 0'));
  await chip.tap();
  const spans = await p.locator('#inspBody .xray-bytes .xr').count().catch(() => 0);
  const fields = await p.locator('#inspBody .xray-fields tbody tr').count().catch(() => 0);
  const paused = await p.locator('.speeds button[data-speed="0"]').getAttribute('aria-pressed');
  if (spans < 9 || fields < 9 || paused !== 'true') fail(`x-ray: ${spans} byte ranges, ${fields} fields, paused=${paused}`);
  await p.addScriptTag({ content: axeSource });
  const result = await p.evaluate(async () => (await window.axe.run(document, { resultTypes: ['violations'] })).violations
    .filter((v) => v.impact === 'serious' || v.impact === 'critical')
    .map((v) => `${v.id} (${v.impact}): ${v.nodes.slice(0, 3).map((n) => n.target.join(' ')).join('; ')}`));
  if (result.length) fail(`axe (x-ray): ${result.join(' | ')}`);
  if (errors.length) fail(`x-ray: page errors: ${errors.join(' | ')}`);
  if (spans >= 9 && !result.length && !errors.length) console.log(`ok: x-ray — tap paused the world, ${fields} fields, ${spans} byte ranges, axe clean`);
  await p.close();
}

// 2e. Take it to ns-3 (#640): after a few seconds of a world, "Export to
//     ns-3" downloads a zip holding the four kit files, built in the page.
{
  const { p, errors } = await page('#manet?seed=1');
  await p.locator('#missionBody .missions button').first().waitFor({ timeout: 15000 });
  await p.locator('.speeds button').last().click();
  await p.waitForTimeout(4000);
  const [download] = await Promise.all([p.waitForEvent('download', { timeout: 15000 }), p.locator('#kitExport').click()]);
  const file = await download.path();
  const bytes = fs.readFileSync(file);
  const names = [];
  for (let i = 0; i + 30 < bytes.length; i++) {
    if (bytes.readUInt32LE(i) === 0x04034b50) names.push(bytes.subarray(i + 30, i + 30 + bytes.readUInt16LE(i + 26)).toString());
  }
  const want = ['mobility.ns_movements', 'flows.txt', 'run.sh', 'README.md'];
  const ok = want.every((n) => names.some((x) => x.endsWith('/' + n)));
  if (!ok || !download.suggestedFilename().endsWith('.zip')) fail(`export: ${download.suggestedFilename()} holds ${names.join(', ')}`);
  if (errors.length) fail(`export: console errors: ${errors.join(' | ')}`);
  if (ok && !errors.length) console.log(`ok: export — ${download.suggestedFilename()} with ${names.length} files`);
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
    ['docs page', 'docs/benchmarks/scenarios/vanet/', 'lab', 'AntHocNet › Lab › Scenarios › Scenario: vanet'],
    ['place page', 'docs/places/workshop/', 'shop', 'AntHocNet › Workshop'],
    ['API page', 'api/classanthocnet_1_1core_1_1PheromoneTable.html', 'shop',
      'AntHocNet › Workshop › API reference › anthocnet::core::PheromoneTable Class Reference'],
  ];
  for (const scheme of ['light', 'dark']) {
    for (const [name, url, place, trail] of surfaces) {
      const p = await browser.newPage({ viewport: { width: 1280, height: 860 }, colorScheme: scheme });
      const errors = [];
      p.on('pageerror', (e) => errors.push(e.message));
      await p.goto(base + url);
      await p.waitForTimeout(400);
      const current = await p.locator('.ahn-bar .ahn-place[aria-current="page"]').getAttribute('data-place').catch(() => null);
      if (current !== place) fail(`${name}: active place ${current}, expected ${place}`);
      // The breadcrumb (#652): the trail from the site root, the page last.
      const got = (await p.locator('.ahn-crumb li').allTextContents()).map((t) => t.trim()).join(' › ');
      if (got !== trail) fail(`${name}: breadcrumb "${got}", expected "${trail}"`);
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
      const crumb = await p.locator('.ahn-crumb [aria-current="page"]').count();
      const result = await p.evaluate(async () => (await window.axe.run(document, { resultTypes: ['violations'] })).violations
        .filter((v) => v.impact === 'serious' || v.impact === 'critical').map((v) => v.id + ': ' + v.nodes.slice(0, 2).map((n) => n.target.join(' ')).join('; ')));
      // Material loads mermaid from a CDN; whether the CDN answered is not
      // what this checks (and CI must not fail on a CDN hiccup).
      const own = errorsHere.filter((e) => !/^Invalid script: https?:\/\//.test(e));
      const problems = [...(bar ? [] : ['no top bar']), ...(crumb === 1 ? [] : ['no breadcrumb']), ...result, ...own.map((e) => 'page error: ' + e)];
      if (problems.length) { bad++; fail(`docs ${u} (${scheme}): ${problems.join(' | ')}`); }
    }
    await p.close();
    if (!bad) console.log(`ok: all ${urls.length} docs pages (${scheme}) — top bar, breadcrumb, no page errors, axe clean`);
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
  // A sample of API reference pages, one per Doxygen template (#645).
  // web/shell/api.css restyles Doxygen's output, so a template it misses
  // regresses without the one class page above noticing.
  const apiSample = ['api/index.html', 'api/annotated.html', 'api/classes.html', 'api/files.html', 'api/namespaces.html',
    'api/classanthocnet_1_1core_1_1AntRouterLogic.html', 'api/structanthocnet_1_1core_1_1AntMessage.html',
    'api/structanthocnet_1_1core_1_1ClassicMetric.html',
    'api/ant__message__codec_8h.html', 'api/ant__message__codec_8h_source.html'];
  for (const scheme of ['light', 'dark']) {
    const p = await browser.newPage({ viewport: { width: 1280, height: 860 }, colorScheme: scheme });
    let errorsHere = [];
    p.on('pageerror', (e) => errorsHere.push(e.message));
    await p.addInitScript({ content: axeSource });
    let bad = 0;
    for (const u of apiSample) {
      errorsHere = [];
      await p.goto(base + u, { waitUntil: 'load' });
      const bar = await p.locator('.ahn-bar').count();
      const crumb = await p.locator('.ahn-crumb [aria-current="page"]').count();
      const result = await p.evaluate(async () => (await window.axe.run(document, { resultTypes: ['violations'] })).violations
        .filter((v) => v.impact === 'serious' || v.impact === 'critical').map((v) => v.id + ': ' + v.nodes.slice(0, 2).map((n) => n.target.join(' ')).join('; ')));
      const problems = [...(bar ? [] : ['no top bar']), ...(crumb === 1 ? [] : ['no breadcrumb']), ...result, ...errorsHere.map((e) => 'page error: ' + e)];
      if (problems.length) { bad++; fail(`${u} (${scheme}): ${problems.join(' | ')}`); }
    }
    await p.close();
    if (!bad) console.log(`ok: ${apiSample.length} API templates (${scheme}) — top bar, breadcrumb, no page errors, axe clean`);
  }
  // Old URLs (#648): the stubs web/site-redirects.sh writes must land on the
  // new page with the query and the hash intact, so deep links in papers,
  // issues and Zenodo records keep pointing at the same place.
  for (const [from, wantPath, wantSearch, wantHash] of [
    ['learn/#vanet?seed=3', '/', '', '#vanet?seed=3'],
    ['benchmarks/grid/?from=paper#what-it-varies', '/docs/benchmarks/grid/', '?from=paper', '#what-it-varies'],
    ['adr/', '/docs/adr/', '', ''],
  ]) {
    const p = await browser.newPage();
    await p.goto(base + from);
    await p.waitForURL((u) => u.pathname === wantPath, { timeout: 10000 }).catch(() => {});
    const u = new URL(p.url());
    if (u.pathname !== wantPath || u.search !== wantSearch || u.hash !== wantHash) {
      fail(`redirect ${from}: landed on ${u.pathname}${u.search}${u.hash}, expected ${wantPath}${wantSearch}${wantHash}`);
    } else {
      console.log(`ok: redirect ${from} -> ${wantPath}${wantSearch}${wantHash}`);
    }
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

// 3c. The campaign (#566/#567/#569): the chapter map, a briefing, the Plan
//     phase with the device dock, a run, and the debrief -- level 1.2 played to
//     the end through the UI, with axe (serious/critical) on every screen, day
//     and night.
for (const scheme of ['light', 'dark']) {
  const p = await browser.newPage({ viewport: { width: 1280, height: 860 }, colorScheme: scheme });
  const errors = [];
  p.on('pageerror', (e) => errors.push(e.message));
  await p.addInitScript(() => { try { localStorage.setItem('ahn-campaign-v1', JSON.stringify({ '1.1': 3 })); } catch { /* none */ } });
  await p.addInitScript({ content: axeSource });
  const axe = async (what) => {
    const v = await p.evaluate(async () => (await window.axe.run(document, { resultTypes: ['violations'] })).violations
      .filter((x) => x.impact === 'serious' || x.impact === 'critical').map((x) => x.id + ': ' + x.nodes.slice(0, 2).map((n) => n.target.join(' ')).join('; ')));
    if (v.length) fail(`campaign ${what} (${scheme}): ${v.join(' | ')}`);
    return v.length;
  };
  await p.goto(base + '#campaign');
  await p.locator('#campaign .chip-btn', { hasText: 'Across the street' }).waitFor({ timeout: 15000 });
  let bad = await axe('map');
  if (await p.locator('#campaign .chip-btn', { hasText: 'Follow the scent' }).isEnabled()) fail(`campaign (${scheme}): 1.3 should be locked until 1.2 is cleared`);
  await p.locator('#campaign .chip-btn', { hasText: 'Across the street' }).click();
  await p.locator('#campaign button', { hasText: 'Plan' }).waitFor();
  bad += await axe('briefing');
  await p.locator('#campaign button', { hasText: 'Plan' }).click();
  await p.locator('#hud button', { hasText: 'Run' }).waitFor();
  await p.locator('#dock .dock-btn').first().click();
  bad += await axe('plan phase');
  // Place the laptop where the par solution does (a pixel click depends on the view).
  await p.evaluate(async () => { const { playground } = await import('./js/app.js'); playground.onPlace(250, 150); });
  await p.locator('#hud button', { hasText: 'Run' }).click();
  await p.evaluate(async () => { const { playground } = await import('./js/app.js'); playground.setSpeed(20); });
  await p.locator('#campTitle', { hasText: 'cleared' }).waitFor({ timeout: 30000 }).catch(() => fail(`campaign (${scheme}): level 1.2 did not clear`));
  bad += await axe('debrief');
  const stars = await p.evaluate(() => JSON.parse(localStorage.getItem('ahn-campaign-v1') || '{}')['1.2'] || 0);
  if (!stars) fail(`campaign (${scheme}): no stars recorded for 1.2`);
  if (errors.length) fail(`campaign (${scheme}): page errors: ${errors.join(' | ')}`);
  else if (!bad && stars) console.log(`ok: campaign (${scheme}) — map, briefing, plan, run, debrief; 1.2 cleared with ${stars} stars; axe clean`);
  await p.close();
}

// 5b. Upgrades (#579): the screen lists every upgrade, earned ones open; a
//     briefing offers an earned upgrade as a toggle that is remembered.
{
  const p = await browser.newPage({ viewport: { width: 1280, height: 860 } });
  const errors = [];
  p.on('pageerror', (e) => errors.push(e.message));
  const cleared = Object.fromEntries(['1.1', '1.2', '1.3', '1.4', '1.5', '1.6', '2.1', '2.2'].map((id) => [id, 3]));
  await p.addInitScript((c) => { try { localStorage.setItem('ahn-campaign-v1', JSON.stringify(c)); } catch { /* none */ } }, cleared);
  await p.addInitScript({ content: axeSource });
  await p.goto(base + '#campaign');
  await p.locator('#campaign button', { hasText: 'Upgrades' }).click();
  await p.locator('#campaign .upgrades li').first().waitFor({ timeout: 15000 });
  const cards = await p.locator('#campaign .upgrades li').count();
  const earned = await p.locator('#campaign .upgrades li', { hasText: 'earned' }).count();
  const v = await p.evaluate(async () => (await window.axe.run(document, { resultTypes: ['violations'] })).violations
    .filter((x) => x.impact === 'serious' || x.impact === 'critical').map((x) => x.id));
  if (v.length) fail(`upgrades screen: axe ${v.join(' | ')}`);
  await p.locator('#campaign button', { hasText: '← Map' }).click();
  await p.locator('#campaign .chip-btn[aria-label^="Level 2.3,"]').click();
  const box = p.locator('#up-quiet');
  await box.check();
  const saved = await p.evaluate(() => JSON.parse(localStorage.getItem('ahn-upgrades-v1') || '{}')['2.3'] || []);
  if (cards !== 4 || earned !== 1) fail(`upgrades screen: ${cards} cards, ${earned} earned (want 4, 1)`);
  else if (!saved.includes('quiet')) fail(`upgrades: the briefing toggle was not saved (${JSON.stringify(saved)})`);
  else if (errors.length) fail(`upgrades: page errors: ${errors.join(' | ')}`);
  else if (!v.length) console.log('ok: upgrades — 4 cards, quiet mode earned by 2.2, toggled on in the 2.3 briefing, axe clean');
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

// 5. Offline (#624): after one visit the service worker has the game shell, so
//    with the network off the game reloads and a world still delivers, and the
//    Workshop opens.
{
  const ctx = await browser.newContext({ viewport: { width: 1280, height: 860 } });
  const p = await ctx.newPage();
  const errors = [];
  p.on('pageerror', (e) => errors.push(e.message));
  await p.goto(base + '#manet?seed=1');
  const build = await p.evaluate(async () => {
    const reg = await navigator.serviceWorker.ready;
    const keys = await caches.keys();
    return reg.active ? keys.find((k) => k.startsWith('ahn-game-')) || '' : '';
  });
  await ctx.setOffline(true);
  await p.reload();
  await p.waitForFunction(() => document.getElementById('clock')?.textContent.includes('t 0:0'), null, { timeout: 15000 })
    .catch(() => fail('offline: the game did not start with the network off'));
  const delivered = await p.evaluate(async () => {
    const { playground } = await import('./js/app.js');
    let n = 0;
    playground.on((e) => { if (e.kind === 4) n++; });
    playground.setSpeed(20);
    await new Promise((r) => setTimeout(r, 6000));
    return n;
  }).catch((e) => { fail(`offline: ${e.message}`); return 0; });
  const shop = await p.goto(base + 'workshop.html').then((r) => r && r.ok()).catch(() => false);
  if (!build) fail('offline: no service worker cache after the first visit');
  else if (!delivered) fail('offline: the world delivered nothing with the network off');
  else if (!shop) fail('offline: the Workshop did not open with the network off');
  else if (errors.length) fail(`offline: page errors: ${errors.join(' | ')}`);
  else console.log(`ok: offline — ${build} cached, the game reloads and delivers (${delivered}) and the Workshop opens with the network off`);
  await ctx.close();
}

await browser.close();
server.close();
if (failed) { console.log(`learn smoke: FAIL (${failed})`); process.exit(1); }
console.log('learn smoke: PASS');
