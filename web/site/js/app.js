// Learn AntHocNet (#545): a city-builder for networks and ants. The WASM core
// (#544) runs the protocol; this file animates what it reports and turns the
// visitor's tools into adapter calls (move a node, switch it off, add a node
// or a flow). Nothing here chooses a route. Missions (#546) and worlds (#547)
// plug in through `playground`.
import { engine, events, Ev, antKind, DropReason } from './engine.js';
import { IsoRenderer } from './iso.js';
import { WORLDS, worldById } from './worlds.js';
import { initMissions } from './missions.js';
import { initCampaign } from './campaign/campaign.js';
import { initBench } from './bench.js';
import { renderAnt } from './xray.js';
import { KitRecorder, sceneFrom, buildKit, zip } from './kit.js';
import { initSearch } from '../shell/shell.js';
import { openReader, interceptDocsLinks } from './reader.js';
import { initI18n, t, num, LANGS, currentLang, setLang } from './i18n.js';

const $ = (id) => document.getElementById(id);
const reduceMotion = window.matchMedia('(prefers-reduced-motion: reduce)');
const MAX_NODES = 80;
const MAX_FLOWS = 8;

/** Shared state + hooks; missions.js reads and drives it. */
export const playground = {
  M: null, world: null, worldId: 'manet', seed: 1, speed: 0.25, tool: 'inspect',
  selected: -1, watch: -1, flows: [], listeners: new Set(),
  stats: { delivered: 0, drops: 0, ants: 0 },
  /** Subscribe to every core event (and {type:'reset'}); returns an unsubscribe. */
  on(fn) { this.listeners.add(fn); return () => this.listeners.delete(fn); },
  load, toast, news, setSpeed, setTool, selectNode, setWatch, addFlow,
  /** Campaign (#566): while true the world is built but not started (Plan). */
  planning: false,
  /** Campaign: a click on empty ground calls this with field metres, if set. */
  onPlace: null,
  /** Campaign: which nodes Move may drag (null = all). */
  canMove: null,
  /** Campaign: show the placement ghost at field metres (keyboard cursor). */
  ghostAt(p) { ghost = p; },
  get renderer() { return R; },
  /** X-ray (#637): the ant transmission shown in the Query window, or -1. */
  xray: -1,
  showAnt: (id) => showAnt(id),
  /** Tuning bench (#638): { world, routes } of the default-Config ghost, or null. */
  ghostRun: null,
  /** Each flow's strongest pheromone route in world `w` (the flows are the same). */
  strongestRoutes: (w) => strongestRoutes(w),
};

const view = $('view');
const mapEl = $('map');
const R = new IsoRenderer(view);
const anim = { flights: [], rings: [], marks: [] };
const flash = new Map();      // node -> ant kind, while its antenna light is lit
const flashUntil = new Map(); // node -> wall-clock ms
let window10 = [];            // [simTime, delivered?] for the health meter
let logItems = [];
let lastFrame = 0;
let lastInspector = 0;
let pendingFlowSrc = -1;
let ghost = null;
let hover = -1;
let routes = [];              // each flow's strongest-pheromone route, for the map
let routeKeys = new Map();    // flow id -> the route last seen ("0-4-9"), to spot a switch
let routeChanges = 0;
let antSeq = 0;               // X-ray (#637): the id of the next TxAnt, as World.antBytes counts
let nodeAnts = new Map();     // node -> its last few ant transmissions [{ id, kind }]
const kitRec = new KitRecorder(); // #640: where every node was, for the ns-3 export
let apiIndex;                 // api/api-index.json (null if absent), for the X-ray's member links

function safeStore(op, key, value) {
  try {
    if (op === 'get') return localStorage.getItem(key);
    localStorage.setItem(key, value);
  } catch { /* storage blocked: run without it */ }
  return null;
}

// --- theme (day / night) ------------------------------------------------------------
function applyTheme(theme) {
  if (theme) document.documentElement.dataset.theme = theme;
  else delete document.documentElement.dataset.theme;
  R.refreshColors();
  buildLegend();
  $('theme').textContent = R.colors.night ? '☀' : '☾';
}
$('theme').addEventListener('click', () => {
  const next = R.colors.night ? 'light' : 'dark';
  safeStore('set', 'ahn-theme', next);
  applyTheme(next);
});
matchMedia('(prefers-color-scheme: dark)').addEventListener('change', () => applyTheme(document.documentElement.dataset.theme));

// --- world lifecycle ---------------------------------------------------------------
async function load(worldId, seed, opts = {}) {
  const M = playground.M || (playground.M = await engine());
  if (playground.world && playground.world !== opts.world) playground.world.delete();
  playground.custom = opts.meta || null;
  playground.worldId = opts.meta ? 'level' : worldById(worldId).id;
  playground.seed = seed;
  playground.planning = !!opts.plan;
  playground.onPlace = null;
  playground.canMove = null;
  // A campaign level brings its own world, built by the level engine (#567).
  const w = opts.world || new M.World(seed, playground.worldId);
  for (const [k, v] of Object.entries(opts.config || {})) w.setConfig(k, v);
  // A planning level starts too, so the map can read every node's tables;
  // `planning` keeps its clock at zero until the player presses Run.
  w.start();
  playground.world = w;
  readFlows();
  playground.stats = { delivered: 0, drops: 0, ants: 0 };
  playground.selected = -1;
  pendingFlowSrc = -1;
  anim.flights = []; anim.rings = []; anim.marks = [];
  window10 = [];
  logItems = [];
  routes = []; routeKeys = new Map(); routeChanges = 0;
  antSeq = 0; nodeAnts = new Map(); playground.xray = -1;
  kitRec.reset(); playground.edited = false;
  $('log').replaceChildren();
  R.setWorld({
    areaX: w.areaX(), areaY: w.areaY(), areaZ: w.areaZ(), channel: w.channel(),
    blocksX: w.blocksX(), blocksY: w.blocksY(), streetWidth: w.streetWidth(), range: w.range(),
    zones: Array.from(w.zones()),
    sprite: opts.meta ? opts.meta.sprite : worldById(playground.worldId).sprite,
    sprites: opts.meta ? opts.meta.sprites : null,
  });
  if (!opts.meta) $('world').value = playground.worldId;
  $('seed').value = seed;
  describeWorld();
  fillWatch();
  setSpeed(opts.meta ? 0 : (worldById(playground.worldId).speed ?? 0.25)); // a mission sets its own after this
  if (!opts.meta) history.replaceState(null, '', `#${playground.worldId}?seed=${seed}`);
  news(opts.meta ? opts.meta.headline : (worldById(playground.worldId).headline || t('app.newNetwork')), true);
  for (const fn of playground.listeners) fn({ type: 'reset' });
}

function readFlows() {
  const fs = playground.world.flowStats();
  playground.flows = [];
  for (let i = 0; i < fs.length; i += 5) {
    playground.flows.push({ id: i / 5, src: fs[i], dst: fs[i + 1], sent: fs[i + 2], delivered: fs[i + 3], delaySum: fs[i + 4] });
  }
}

function describeWorld() {
  const m = playground.custom || worldById(playground.worldId);
  $('mapTitle').textContent = m.title;
  $('worldTitle').textContent = t('app.worldTitle', { title: m.title });
  $('worldBlurb').textContent = m.blurb;
  const honest = $('worldHonest');
  honest.textContent = m.honest + ' ' + t('app.notBenchmark') + ' ';
  if (m.results) {
    const a = document.createElement('a');
    a.href = m.results.href;
    a.textContent = m.results.label + ' →';
    honest.append(a);
  }
  if (m.read) {
    // The Field guide page this world illustrates; opens in the reader (#630).
    const a = document.createElement('a');
    a.href = m.read.href;
    a.textContent = t('app.fieldGuide', { label: m.read.label });
    honest.append(' ', a);
  }
}

function fillWatch() {
  const sel = $('watch');
  sel.replaceChildren();
  const seen = new Set();
  for (const f of playground.flows) {
    if (seen.has(f.dst)) continue;
    seen.add(f.dst);
    sel.append(new Option(t('app.watchNode', { n: f.dst, id: f.id }), f.dst));
  }
  sel.append(new Option(t('app.watchNothing'), -1));
  setWatch(playground.flows.length ? playground.flows[0].dst : -1);
}

function setWatch(n) { playground.watch = Number(n); $('watch').value = String(playground.watch); }

function setSpeed(s) {
  playground.speed = Number(s);
  for (const b of document.querySelectorAll('[data-speed]')) {
    b.setAttribute('aria-pressed', String(Number(b.dataset.speed) === playground.speed));
  }
}

function setTool(t0) {
  playground.tool = t0;
  mapEl.dataset.tool = t0;
  pendingFlowSrc = -1;
  ghost = null;
  for (const b of document.querySelectorAll('button[data-tool]')) b.setAttribute('aria-pressed', String(b.dataset.tool === t0));
  toast(t(`app.toolHint.${t0 === 'bulldoze' && playground.worldId === 'satellite' ? 'bulldozeSat' : t0}`), 2600);
}

function selectNode(i) { playground.selected = i; playground.xray = -1; lastInspector = 0; }

function toast(msg, ms = 3500) {
  const t = $('toast');
  t.textContent = msg;
  t.hidden = false;
  clearTimeout(toast.timer);
  toast.timer = setTimeout(() => { t.hidden = true; }, ms);
}

/** The news ticker: rate-limited so a headline stays readable. */
let newsAt = 0;
function news(text, force = false) {
  const now = performance.now();
  if (!force && now - newsAt < 3500) return;
  newsAt = now;
  $('news').textContent = text;
}

function addFlow(src, dst) {
  if (playground.flows.length >= MAX_FLOWS) { toast(t('app.maxFlows', { n: MAX_FLOWS })); return -1; }
  const w = playground.world;
  const id = w.addFlow(src, dst, 2, w.now(), 1e9);
  playground.edited = true;
  readFlows();
  const keep = playground.watch;
  fillWatch();
  setWatch(dst);
  if (keep >= 0 && keep !== dst) setWatch(dst);
  news(t('app.news.newFlow', { id, src, dst }), true);
  return id;
}

// --- events -> animation, news, log ------------------------------------------------
function visualDuration(simSeconds) {
  if (reduceMotion.matches) return 0;
  return Math.min(900, Math.max(260, (simSeconds / Math.max(playground.speed, 0.05)) * 1000));
}

const firstDelivery = new Set();
function handle(e, wallNow) {
  const st = playground.stats;
  switch (e.kind) {
    case Ev.TxAnt: {
      const kind = antKind(e.a, e.b);
      const antId = antSeq++;
      const mine = nodeAnts.get(e.node) || [];
      mine.push({ id: antId, kind });
      if (mine.length > 4) mine.shift();
      nodeAnts.set(e.node, mine);
      if (kind !== 'hello') st.ants++;
      flash.set(e.node, kind);
      flashUntil.set(e.node, wallNow + 260);
      const dur = visualDuration(e.v - e.t);
      if (e.peer < 0) {
        if (kind !== 'hello' || $('ovHello').checked) {
          anim.rings.push({ node: e.node, kind, radius: R.meta.range || 300, t0: wallNow, dur: Math.max(dur, 520), antId });
        }
        if (kind === 'linkfail') news(t('app.news.linkfail', { n: e.node }));
      } else {
        anim.flights.push({ from: e.node, to: e.peer, kind, t0: wallNow, dur, antId });
      }
      log(e, kind, kind === 'hello' ? 'hello' : 'ants');
      break;
    }
    case Ev.TxData:
      anim.flights.push({ from: e.node, to: e.peer, kind: 'data', t0: wallNow, dur: visualDuration(e.v - e.t) });
      log(e, 'data', 'data');
      break;
    case Ev.Deliver:
      st.delivered++;
      window10.push([e.t, 1]);
      anim.marks.push({ node: e.node, good: true, t0: wallNow, dur: 900 });
      if (!firstDelivery.has(e.a)) {
        firstDelivery.add(e.a);
        news(t('app.news.firstDelivery', { id: e.a, n: e.node, ms: num(e.v * 1000) }), true);
      } else if (st.delivered % 250 === 0) {
        news(t('app.news.delivered', { n: num(st.delivered) }));
      }
      log(e, 'data', 'data');
      break;
    case Ev.Drop:
      st.drops++;
      window10.push([e.t, 0]);
      anim.marks.push({ node: e.node, good: false, t0: wallNow, dur: 900 });
      news(t('app.news.drop', { n: e.node, why: dropReason(e.peer) }));
      log(e, 'linkfail', 'data');
      break;
    case Ev.TxFail:
      anim.marks.push({ node: e.node, good: false, t0: wallNow, dur: 900 });
      news(t('app.news.txfail', { n: e.node, p: e.peer }));
      log(e, 'linkfail', 'routes');
      break;
    case Ev.NodeDown:
      news(t('app.news.down', { n: e.node }), true);
      log(e, null, 'routes');
      break;
    case Ev.NodeUp:
      news(t('app.news.up', { n: e.node }), true);
      log(e, null, 'routes');
      break;
    case Ev.RouteAdd: case Ev.RouteDel:
      log(e, null, 'routes');
      break;
    case Ev.Queue:
      log(e, 'data', 'data');
      break;
    default:
      break;
  }
  for (const fn of playground.listeners) fn(e);
}

const dropReason = (r) => t(DropReason[r] || 'engine.drop.other');

function describe(e) {
  const v = { n: e.node, p: e.peer, a: e.a, b: e.b };
  let line;
  switch (e.kind) {
    case -1: line = e.text; break;
    case Ev.TxAnt: line = t(e.peer < 0 ? 'app.log.txAntAll' : 'app.log.txAnt', { ...v, kind: t(`engine.kind.${antKind(e.a, e.b)}`) }); break;
    case Ev.TxData: line = t('app.log.txData', v); break;
    case Ev.Deliver: line = t('app.log.deliver', { ...v, ms: num(e.v * 1000, 1) }); break;
    case Ev.Drop: line = t('app.log.drop', { ...v, why: dropReason(e.peer) }); break;
    case Ev.Queue: line = t('app.log.queue', v); break;
    case Ev.TxFail: line = t('app.log.txFail', v); break;
    case Ev.RouteAdd: line = t(e.a === e.peer ? 'app.log.nbAdd' : 'app.log.routeAdd', v); break;
    case Ev.RouteDel: line = t(e.a === e.peer ? 'app.log.nbDel' : 'app.log.routeDel', v); break;
    case Ev.NodeDown: line = t('app.log.down', v); break;
    case Ev.NodeUp: line = t('app.log.up', v); break;
    default: line = t('app.log.other', { k: e.kind }); break;
  }
  return `t=${e.t.toFixed(3)}  ${line}`;
}

function log(e, kind, cls) {
  const box = { hello: $('logHello'), data: $('logData'), ants: $('logAnts'), routes: $('logRoutes') }[cls];
  if (box && !box.checked) return;
  logItems.push({ text: describe(e), kind });
}

function flushLog() {
  if (!logItems.length) return;
  const ol = $('log');
  const atBottom = ol.scrollTop + ol.clientHeight >= ol.scrollHeight - 8;
  const frag = document.createDocumentFragment();
  for (const it of logItems.slice(-200)) {
    const li = document.createElement('li');
    if (it.kind) {
      const sw = document.createElement('span');
      sw.className = 'sw';
      sw.style.background = R.colors[it.kind];
      li.append(sw);
    }
    li.append(it.text);
    frag.append(li);
  }
  logItems = [];
  ol.append(frag);
  while (ol.childElementCount > 400) ol.firstElementChild.remove();
  if (atBottom) ol.scrollTop = ol.scrollHeight;
}

// --- query window --------------------------------------------------------------------
function pheromoneEdges(w) {
  const d = playground.watch;
  if (d < 0 || !$('ovPheromone').checked) return null;
  const out = [];
  for (let n = 0; n < w.nodeCount(); n++) {
    if (n === d) continue;
    const row = w.pheromone(n, d);
    let sum = 0;
    for (let k = 0; k < row.length; k += 3) sum += row[k + 1];
    if (sum <= 0) continue;
    for (let k = 0; k < row.length; k += 3) if (row[k + 1] > 0) out.push({ from: n, to: row[k], share: row[k + 1] / sum });
  }
  return out;
}

/**
 * Each flow's strongest route as the pheromone table stands now: from the
 * source, follow the neighbour with the most regular pheromone toward the
 * destination, hop by hop. This reads the core's table (PheromoneTable via
 * the adapter); it is what the trails say, not a route the core is forced to
 * take -- data still picks next hops at random, weighted by pheromone^beta.
 */
function strongestRoutes(w) {
  const out = [];
  for (const f of playground.flows) {
    const path = [f.src];
    const seen = new Set(path);
    let cur = f.src;
    while (cur !== f.dst && path.length < 40) {
      const row = w.pheromone(cur, f.dst);
      let best = -1, bestTau = 0;
      for (let k = 0; k < row.length; k += 3) if (row[k + 1] > bestTau) { bestTau = row[k + 1]; best = row[k]; }
      if (best < 0 || seen.has(best)) break;
      path.push(best); seen.add(best); cur = best;
    }
    out.push({ flow: f.id, path, complete: cur === f.dst });
  }
  return out;
}

function updateRoutes(w, wallNow) {
  const fresh = strongestRoutes(w);
  for (const r of fresh) {
    const key = r.complete ? r.path.join('-') : null;
    const prev = routeKeys.get(r.flow);
    const old = routes.find((o) => o.flow === r.flow);
    r.changedAt = old ? old.changedAt : -1e9;
    if (key && prev && key !== prev) {
      routeChanges++;
      r.changedAt = wallNow;
      const text = t('app.news.routeSwitch', { id: r.flow, path: r.path.map((n) => 'n' + n).join(' → '), hops: r.path.length - 1 });
      news(text);
      log({ t: w.now(), kind: -1, text }, 'repair', 'routes');
    }
    if (key) routeKeys.set(r.flow, key);
  }
  routes = fresh;
}

/** The API page of `cls`::`member` (from api/api-index.json when built), for the X-ray's headers. */
function apiHref(cls, member) {
  const info = apiIndex && apiIndex.classes[cls];
  if (!info) return `api/classanthocnet_1_1core_1_1${cls}.html`;
  const m = member && info.members.find((x) => x.name === member && x.anchor);
  return `api/${info.url}${m ? '#' + m.anchor : ''}`;
}
const apiTh = (label, cls, member) => `<th><a href="${apiHref(cls, member)}" data-cls="${cls}" data-member="${member}" title="${cls}::${member}">${label}</a></th>`;

/** Open `cls`::`member` in the reader, at the member once the API index is read. */
async function openMember(cls, member) {
  if (apiIndex === undefined) {
    apiIndex = await fetch('api/api-index.json').then((r) => (r.ok ? r.json() : null)).catch(() => null);
  }
  openReader(apiHref(cls, member), `${cls}::${member}`);
}

/** X-ray of ant transmission `id` (#637) in the Query window. */
function showAnt(id) {
  playground.xray = id;
  $('inspHint').hidden = true;
  const box = document.createElement('div');
  renderAnt(playground.M, playground.world, id, box, (href, title) => openReader(href, title));
  const back = Object.assign(document.createElement('button'), { type: 'button', className: 'bevel', textContent: t('xray.back') });
  back.addEventListener('click', () => { playground.xray = -1; lastInspector = 0; });
  box.append(back);
  $('inspBody').replaceChildren(box);
}

function renderInspector(w) {
  if (playground.xray >= 0) return;
  const i = playground.selected;
  const body = $('inspBody');
  if (i < 0) { body.replaceChildren(); $('inspHint').hidden = false; return; }
  $('inspHint').hidden = true;
  const d = playground.watch;
  const up = w.positions()[4 * i + 3] > 0;
  const dests = Array.from(w.destinations(i));
  const frag = document.createDocumentFragment();
  const p = document.createElement('p');
  const v = R.speedOf(i);
  const motion = playground.worldId === 'satellite' ? '' : ` · <span class="chip">${v > 0.05 ? t('app.insp.moving', { v: num(v, 1) }) : t('app.insp.still')}</span>`;
  p.innerHTML = `<strong>${t('app.insp.node', { n: i })}</strong> · ${t(up ? 'app.insp.on' : 'app.insp.off')}${motion} · ${t('app.insp.summary', { q: w.pendingCount(i), d: dests.length })}`;
  frag.append(p);
  if (d >= 0 && d !== i) {
    const row = w.pheromone(i, d);
    const dist = w.distribution(i, d, -1);
    const prob = new Map();
    for (let k = 0; k < dist.length; k += 2) prob.set(dist[k], dist[k + 1]);
    const rows = [];
    for (let k = 0; k < row.length; k += 3) rows.push([row[k], row[k + 1], row[k + 2]]);
    rows.sort((a, b) => (prob.get(b[0]) || 0) - (prob.get(a[0]) || 0) || b[1] - a[1]);
    const tbl = document.createElement('table');
    tbl.className = 'ph';
    tbl.innerHTML = `<caption>${t('app.insp.caption', { d })}</caption>
      <thead><tr><th>${t('app.insp.via')}</th>${apiTh(t('app.insp.reg'), 'PheromoneTable', 'getPheromoneRegular')}${apiTh(t('app.insp.vir'), 'PheromoneTable', 'getPheromoneVirtual')}${apiTh(t('app.insp.next'), 'PheromoneTable', 'nextHopDistribution')}</tr></thead>`;
    tbl.querySelectorAll('a[data-member]').forEach((a) => a.addEventListener('click', (e) => { e.preventDefault(); openMember(a.dataset.cls, a.dataset.member); }));
    const tb = document.createElement('tbody');
    for (const [nb, reg, vir] of rows) {
      const pr = prob.get(nb) || 0;
      const tr = document.createElement('tr');
      tr.innerHTML = `<td>n${nb}</td><td>${reg ? num(reg, 2) : '—'}</td><td>${vir ? num(vir, 2) : '—'}</td>
        <td><span class="bar" style="width:${Math.round(pr * 56)}px"></span> ${num(pr * 100, pr > 0 && pr < 0.01 ? 2 : 0)}%</td>`;
      tb.append(tr);
    }
    tbl.append(tb);
    frag.append(tbl);
    const note = document.createElement('p');
    note.className = 'muted small';
    note.textContent = dist.length
      ? t('app.insp.noteDist')
      : t('app.insp.noteNone');
    frag.append(note);
  } else if (d === i) {
    frag.append(Object.assign(document.createElement('p'), { className: 'muted small', textContent: t('app.insp.watched') }));
  }
  // X-ray (#637): this node's last few ant transmissions, as bytes.
  const recent = (nodeAnts.get(i) || []).slice().reverse();
  if (recent.length) {
    const p2 = document.createElement('p');
    p2.className = 'small';
    p2.append(t('xray.recent') + ' ');
    for (const r of recent) {
      const b = Object.assign(document.createElement('button'), { type: 'button', className: 'bevel chip-btn', textContent: `#${r.id} ${t(`engine.kind.${r.kind}`)}` });
      b.addEventListener('click', () => { setSpeed(0); showAnt(r.id); });
      p2.append(b, ' ');
    }
    frag.append(p2);
  }
  body.replaceChildren(frag);
}

function updateStatus(w) {
  const now = w.now();
  const m = Math.floor(now / 60), s = (now - 60 * m).toFixed(2).padStart(5, '0');
  $('clock').textContent = `t ${m}:${s}`;
  let sent = 0;
  const fs = w.flowStats();
  for (let i = 0; i < fs.length; i += 5) sent += fs[i + 2];
  const st = playground.stats;
  $('stDelivered').textContent = `✓ ${st.delivered}/${sent}`;
  $('stDropped').textContent = `✕ ${st.drops}`;
  const ants = w.antTransmissions();
  $('stBudget').textContent = t('app.st.ants', { n: ants }) + (st.delivered ? ' · ' + t('app.st.perPkt', { x: num(ants / st.delivered, 1) }) : '');
  $('stRoutes').textContent = t('app.st.routes', { n: routeChanges });
  window10 = window10.filter(([ts]) => ts > now - 10);
  if (window10.length) {
    const ok = window10.reduce((a, [, g]) => a + g, 0) / window10.length;
    $('healthBar').style.width = `${Math.round(ok * 100)}%`;
    $('health').textContent = `${Math.round(ok * 100)}%`;
  } else {
    $('healthBar').style.width = '0';
    $('health').textContent = '—';
  }
}

// --- frame loop ----------------------------------------------------------------------
function frame(ts) {
  const w = playground.world;
  if (w) {
    const dt = Math.min(100, ts - (lastFrame || ts));
    lastFrame = ts;
    if (playground.speed > 0 && !playground.planning) w.advanceTo(w.now() + (dt / 1000) * playground.speed);
    kitRec.tick(w);
    for (const e of events(w.drainEvents())) handle(e, ts);
    const prog = (list) => list.filter((a) => {
      a.progress = a.dur ? (ts - a.t0) / a.dur : 1;
      return a.progress < 1;
    });
    anim.flights = prog(anim.flights).slice(-400);
    anim.rings = prog(anim.rings).slice(-200);
    anim.marks = prog(anim.marks).slice(-200);
    for (const [n, until] of flashUntil) if (until < ts) { flashUntil.delete(n); flash.delete(n); }
    R.draw({
      time: ts, simNow: w.now(), positions: w.positions(),
      routes: $('ovRoute').checked ? routes : null, links: w.links(), pheromone: pheromoneEdges(w),
      ghostRoutes: $('ovRoute').checked && playground.ghostRun ? playground.ghostRun.routes : null,
      showLinks: $('ovLinks').checked, labels: $('ovLabels').checked,
      flights: anim.flights, rings: anim.rings, marks: anim.marks, flash,
      flows: playground.flows, selected: playground.selected, tool: playground.tool,
      hover, ghost, ghostRange: playground.ghostRange || 0, rangeRings: playground.rangeRings || null,
    });
    if (ts - lastInspector > 300) { updateRoutes(w, ts); renderInspector(w); updateStatus(w); lastInspector = ts; }
    flushLog();
  }
  requestAnimationFrame(frame);
}

// --- tools on the map ----------------------------------------------------------------
const pointers = new Map();
let drag = null;
let pinch = null;

function local(ev) {
  const r = view.getBoundingClientRect();
  return [ev.clientX - r.left, ev.clientY - r.top];
}

function inField(x, y) {
  return x >= 0 && y >= 0 && x <= R.meta.areaX && y <= R.meta.areaY;
}

function mobilityFor(world) {
  // New nodes move like the world's own (ADR-0019: the scenario's mobility).
  // The ad hoc world mixes walkers and phones that stay put; a phone the
  // player places is a relay, so it stays where it was put.
  switch (world) {
    case 'fanet': return [2, 20, 0.85, 0, true];
    case 'vanet': return [3, 10, 20, 0, false];
    default: return null;
  }
}

view.addEventListener('pointerdown', (ev) => {
  const w = playground.world;
  if (!w) return;
  view.setPointerCapture(ev.pointerId);
  const [px, py] = local(ev);
  pointers.set(ev.pointerId, [px, py]);
  if (pointers.size === 2) {
    const [a, b] = [...pointers.values()];
    pinch = { d: Math.hypot(a[0] - b[0], a[1] - b[1]), zoom: R.zoom };
    drag = null;
    return;
  }
  const pos = w.positions();
  const i = R.hit(pos, px, py);
  const panButton = ev.button === 1 || ev.button === 2;
  const tool = playground.tool;
  // X-ray (#637): a click or tap on an ant in flight pauses and shows its bytes.
  if (tool === 'inspect' && i < 0 && !panButton) {
    const f = R.hitFlight(pos, anim.flights, px, py);
    if (f) { setSpeed(0); showAnt(f.antId); return; }
  }
  if (panButton || (tool === 'move' && i < 0) || (tool === 'inspect' && i < 0)) {
    drag = { pan: true, x: px, y: py, moved: false, clickEmpty: tool === 'inspect' && !panButton };
    return;
  }
  if (playground.onPlace && i < 0) {
    const [x, y] = R.unproject(px, py);
    if (inField(x, y)) playground.onPlace(x, y);
    else toast(t('app.toast.placeInside'));
    return;
  }
  if (tool === 'inspect') { selectNode(i); return; }
  if (tool === 'move') {
    if (playground.canMove && !playground.canMove(i)) { selectNode(i); toast(t('app.toast.staysPut')); return; }
    selectNode(i); drag = { node: i, x: px, y: py }; return;
  }
  if (tool === 'bulldoze') {
    if (i >= 0) { toggleNode(i); return; }
    if (playground.worldId === 'satellite') {
      const l = R.hitLink(pos, w.links(), px, py);
      if (l) {
        w.cutIslLink(l[0], l[1]);
        news(t('app.news.islCut', { a: l[0], b: l[1] }), true);
        for (const fn of playground.listeners) fn({ type: 'cut', a: l[0], b: l[1] });
      }
    }
    return;
  }
  if (tool === 'build') {
    const [x, y] = R.unproject(px, py);
    if (playground.worldId === 'satellite') { toast(t('app.toast.noBuildSat')); return; }
    if (!inField(x, y)) { toast(t('app.toast.buildInside')); return; }
    if (w.nodeCount() >= MAX_NODES) { toast(t('app.toast.maxNodes', { n: MAX_NODES })); return; }
    const z = playground.worldId === 'fanet' ? 150 : 0;
    const n = w.addNode(x, y, z);
    playground.edited = true;
    const m = mobilityFor(playground.worldId);
    if (m) w.setMobility(n, ...m);
    selectNode(n);
    news(t('app.news.built', { n }), true);
    return;
  }
  if (tool === 'flow') {
    if (i < 0) return;
    if (pendingFlowSrc < 0) { pendingFlowSrc = i; selectNode(i); toast(t('app.toast.source', { n: i })); return; }
    if (i === pendingFlowSrc) { toast(t('app.toast.sameNode')); return; }
    addFlow(pendingFlowSrc, i);
    pendingFlowSrc = -1;
  }
});

view.addEventListener('pointermove', (ev) => {
  const w = playground.world;
  if (!w) return;
  const [px, py] = local(ev);
  if (pointers.has(ev.pointerId)) pointers.set(ev.pointerId, [px, py]);
  if (pinch && pointers.size === 2) {
    const [a, b] = [...pointers.values()];
    const d = Math.hypot(a[0] - b[0], a[1] - b[1]);
    R.zoomAt((a[0] + b[0]) / 2, (a[1] + b[1]) / 2, (pinch.zoom * d / pinch.d) / R.zoom);
    return;
  }
  if (!drag) {
    const pos = w.positions();
    hover = R.hit(pos, px, py);
    ghost = playground.tool === 'build' || playground.onPlace ? R.unproject(px, py) : null;
    if (ghost && !inField(...ghost)) ghost = null;
    return;
  }
  if (drag.pan) {
    if (Math.hypot(px - drag.x, py - drag.y) > 3) drag.moved = true;
    R.pan(px - drag.x, py - drag.y);
    drag.x = px; drag.y = py;
    return;
  }
  const [x, y] = R.unproject(px, py);
  const m = R.meta;
  const pos = w.positions();
  w.moveNode(drag.node, Math.max(0, Math.min(m.areaX, x)), Math.max(0, Math.min(m.areaY, y)), pos[4 * drag.node + 2]);
  playground.edited = true;
});

function endPointer(ev) {
  pointers.delete(ev.pointerId);
  if (pointers.size < 2) pinch = null;
  if (drag && drag.pan && drag.clickEmpty && !drag.moved) selectNode(-1);
  drag = null;
}
view.addEventListener('pointerup', endPointer);
view.addEventListener('pointercancel', endPointer);
view.addEventListener('contextmenu', (ev) => ev.preventDefault());
view.addEventListener('wheel', (ev) => {
  ev.preventDefault();
  const [px, py] = local(ev);
  R.zoomAt(px, py, ev.deltaY < 0 ? 1.15 : 1 / 1.15);
}, { passive: false });

function toggleNode(i) {
  const w = playground.world;
  const up = w.positions()[4 * i + 3] > 0;
  w.setNodeUp(i, !up);
  playground.edited = true;
  toast(t(up ? 'app.toast.switchedOff' : 'app.toast.switchedOn', { n: i }));
}

mapEl.addEventListener('keydown', (ev) => {
  const w = playground.world;
  if (!w) return;
  const n = w.nodeCount();
  const i = playground.selected;
  const step = { ArrowLeft: [-1, 0], ArrowRight: [1, 0], ArrowUp: [0, -1], ArrowDown: [0, 1] }[ev.key];
  if (ev.key === ']') selectNode((i + 1) % n);
  else if (ev.key === '[') selectNode((i - 1 + n) % n);
  else if (ev.key === 'o' && i >= 0) toggleNode(i);
  else if (step && i >= 0) {
    const pos = w.positions();
    const d = Math.max(R.meta.areaX, R.meta.areaY) / 40;
    w.moveNode(i, Math.max(0, Math.min(R.meta.areaX, pos[4 * i] + step[0] * d)),
      Math.max(0, Math.min(R.meta.areaY, pos[4 * i + 1] + step[1] * d)), pos[4 * i + 2]);
  } else if (step) R.pan(-step[0] * 40, -step[1] * 40);
  else if (ev.key === 'Enter' && i >= 0 && playground.tool === 'flow') view.dispatchEvent(new PointerEvent('pointerdown'));
  else return;
  ev.preventDefault();
});

document.addEventListener('keydown', (ev) => {
  if (ev.target.matches('input, select, textarea') || ev.target.closest('#reader')) return;
  if (ev.key === '?') {
    // Read about what you are watching (#630): the world's Field guide page.
    const m = playground.custom || worldById(playground.worldId);
    if (m.read) openReader(m.read.href, m.read.label);
    ev.preventDefault();
    return;
  }
  const tools = ['inspect', 'move', 'build', 'bulldoze', 'flow'];
  if (ev.key >= '1' && ev.key <= '5') setTool(tools[Number(ev.key) - 1]);
  else if (ev.key === ' ' && !ev.target.matches('button')) setSpeed(playground.speed > 0 ? 0 : (setSpeed.last || 0.25));
  else if (ev.key === '.') stepToTraffic();
  else if (ev.key === 'q' || ev.key === 'Q') R.rotateView(-1);
  else if (ev.key === 'e' || ev.key === 'E') R.rotateView(1);
  else if (ev.key === '+' || ev.key === '=') R.zoomAt(R.w / 2, R.h / 2, 1.2);
  else if (ev.key === '-') R.zoomAt(R.w / 2, R.h / 2, 1 / 1.2);
  else if (ev.key === '0') R.resetView();
  else return;
  ev.preventDefault();
});

function stepToTraffic() {
  // Pause, then advance in small slices until an ant (not a hello) or a
  // packet goes on the air.
  const w = playground.world;
  if (playground.planning) { toast(t('app.toast.pressRun')); return; }
  if (playground.speed > 0) setSpeed.last = playground.speed;
  setSpeed(0);
  const end = w.now() + 5;
  while (w.now() < end) {
    w.advanceTo(w.now() + 0.002);
    kitRec.tick(w);
    let found = false;
    const now = performance.now();
    for (const e of events(w.drainEvents())) {
      handle(e, now);
      if ((e.kind === Ev.TxAnt && antKind(e.a, e.b) !== 'hello') || e.kind === Ev.TxData) found = true;
    }
    if (found) return;
  }
}

// --- take it to ns-3 (#640) ----------------------------------------------------------------
function currentKit() {
  const w = playground.world;
  if (!w || kitRec.samples.length < 4) { toast(t('kit.none')); return null; }
  const m = playground.custom || worldById(playground.worldId);
  return buildKit(sceneFrom(w, kitRec, {
    worldId: playground.worldId, seed: playground.seed, title: m.title, results: m.results,
    custom: !!playground.custom || playground.edited, ranges: playground.worldId === 'town' || playground.worldId === 'level',
    attrs: playground.bench ? playground.bench.line() : '',
  }));
}
$('kitExport').addEventListener('click', () => {
  const kit = currentKit();
  if (!kit) return;
  const name = `anthocnet-${playground.worldId}-seed${playground.seed}-ns3`;
  const url = URL.createObjectURL(new Blob([zip(kit.files, name)], { type: 'application/zip' }));
  const a = Object.assign(document.createElement('a'), { href: url, download: `${name}.zip` });
  document.body.append(a);
  a.click();
  a.remove();
  setTimeout(() => URL.revokeObjectURL(url), 10000);
  toast(t('kit.saved', { file: `${name}.zip` }), 5000);
});
$('kitCopy').addEventListener('click', async () => {
  const kit = currentKit();
  if (!kit) return;
  const cmd = kit.command.replace(/\$KIT\//g, '');
  try { await navigator.clipboard.writeText(cmd); toast(t('kit.copied'), 4000); } catch { toast(cmd, 8000); }
});

// --- chrome -----------------------------------------------------------------------------
for (const b of document.querySelectorAll('[data-speed]')) {
  b.addEventListener('click', () => {
    const s = Number(b.dataset.speed);
    if (s > 0) setSpeed.last = s;
    setSpeed(s);
  });
}
for (const b of document.querySelectorAll('button[data-tool]')) b.addEventListener('click', () => setTool(b.dataset.tool));
$('step').addEventListener('click', stepToTraffic);
$('rotL').addEventListener('click', () => R.rotateView(-1));
$('rotR').addEventListener('click', () => R.rotateView(1));
$('zoomIn').addEventListener('click', () => R.zoomAt(R.w / 2, R.h / 2, 1.25));
$('zoomOut').addEventListener('click', () => R.zoomAt(R.w / 2, R.h / 2, 1 / 1.25));
$('center').addEventListener('click', () => R.resetView());
$('watch').addEventListener('change', (e) => setWatch(e.target.value));
$('reset').addEventListener('click', () => (playground.custom && playground.restart ? playground.restart() : load(playground.worldId, playground.seed)));
$('world').addEventListener('change', (e) => load(e.target.value, playground.seed));
$('seed').addEventListener('change', (e) => load(playground.worldId, Math.max(1, Number(e.target.value) || 1)));
$('share').addEventListener('click', async () => {
  try {
    await navigator.clipboard.writeText(location.href);
    toast(t('app.toast.copied'));
  } catch {
    toast(location.href, 6000);
  }
});
new ResizeObserver(() => R.resize()).observe(mapEl);

function buildLegend() {
  const ul = $('legend');
  ul.replaceChildren();
  const items = ['route', 'reactive', 'backward', 'proactive', 'repair', 'linkfail', 'data', 'hello', 'pheromone'];
  for (const k of items) {
    const li = document.createElement('li');
    li.append(R.swatch(k), t(`app.legend.${k}`));
    ul.append(li);
  }
}

// The hub (#628): the site's home, over the running world. A plain visit to
// the front page shows it; the top bar's Play (#play), a shared world link or
// "Free play" goes straight to the game. The brand link (./) brings it back.
function hub(fresh) {
  const card = $('hub');
  const close = () => { card.hidden = true; document.body.classList.remove('hub-open'); };
  const open = () => { card.hidden = false; document.body.classList.add('hub-open'); $('hubCampaign').focus({ preventScroll: true }); };
  $('hubFree').addEventListener('click', () => { close(); mapEl.focus({ preventScroll: true }); });
  // The campaign (#566): the hub's main action; Continue resumes where the
  // player left off.
  $('hubCampaign').addEventListener('click', () => { close(); playground.campaign.openMap(); });
  const cont = $('hubContinue');
  if (playground.campaign.hasProgress()) {
    const next = playground.campaign.continueLevel();
    cont.hidden = false;
    cont.textContent = t('app.continue', { id: next.id, title: next.title });
    cont.addEventListener('click', () => { close(); playground.campaign.openBriefing(next); });
  }
  $('hubMission').addEventListener('click', () => {
    close();
    const first = document.querySelector('#missionBody .missions button');
    if (first) first.click();
    $('missionWin').scrollIntoView({ behavior: reduceMotion.matches ? 'auto' : 'smooth', block: 'nearest' });
  });
  card.addEventListener('keydown', (e) => { if (e.key === 'Escape') close(); });
  addEventListener('hashchange', () => { if (location.hash === '#play') close(); });
  if (fresh) open(); else close();
}

// --- boot ---------------------------------------------------------------------------------
function parseHash() {
  const m = /^#([a-z]+)(?:\?seed=(\d+))?/.exec(location.hash === '#play' || location.hash.startsWith('#campaign') ? '' : location.hash);
  return m ? { world: m[1], seed: Number(m[2] || 1) } : { world: 'manet', seed: 1 };
}

async function boot() {
  await initI18n();
  for (const [code, name] of Object.entries(LANGS)) $('lang').append(new Option(name, code));
  $('lang').value = currentLang();
  $('lang').addEventListener('change', (e) => setLang(e.target.value));
  for (const w of WORLDS) $('world').append(new Option(w.title, w.id));
  const saved = safeStore('get', 'ahn-theme');
  applyTheme(saved === 'light' || saved === 'dark' ? saved : null);
  setSpeed(0.25);
  setTool('inspect');
  $('toast').hidden = true;
  const fresh = !location.hash; // a plain visit to the front page, not a shared run
  const wantCampaign = location.hash.startsWith('#campaign');  // #campaign?open=all: the classroom link (#623)
  const h = parseHash();
  await load(h.world, h.seed);
  playground.campaign = initCampaign(playground);
  initMissions(playground);
  playground.bench = await initBench(playground);
  hub(fresh);
  if (wantCampaign) playground.campaign.openMap();
  initSearch((location, title) => openReader('docs/' + location, title));
  interceptDocsLinks(document.body);
  requestAnimationFrame(frame);
}
boot().catch((err) => {
  $('news').textContent = t('app.bootFail', { err });
  throw err;
});
