// Learn AntHocNet (#545): a city-builder for networks and ants. The WASM core
// (#544) runs the protocol; this file animates what it reports and turns the
// visitor's tools into adapter calls (move a node, switch it off, add a node
// or a flow). Nothing here chooses a route. Missions (#546) and worlds (#547)
// plug in through `playground`.
import { engine, events, Ev, antKind, KIND_LABEL, DropReason } from './engine.js';
import { IsoRenderer } from './iso.js';
import { WORLDS, worldById } from './worlds.js';
import { initMissions } from './missions.js';

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
  get renderer() { return R; },
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

function safeStore(op, key, value) {
  try {
    if (op === 'get') return localStorage.getItem(key);
    localStorage.setItem(key, value);
  } catch { /* storage blocked: run without it */ }
  return null;
}

// --- theme (day / night) ------------------------------------------------------------
function applyTheme(t) {
  if (t) document.documentElement.dataset.theme = t;
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
  if (playground.world) playground.world.delete();
  playground.worldId = worldById(worldId).id;
  playground.seed = seed;
  const w = new M.World(seed, playground.worldId);
  for (const [k, v] of Object.entries(opts.config || {})) w.setConfig(k, v);
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
  $('log').replaceChildren();
  R.setWorld({
    areaX: w.areaX(), areaY: w.areaY(), areaZ: w.areaZ(), channel: w.channel(),
    blocksX: w.blocksX(), blocksY: w.blocksY(), streetWidth: w.streetWidth(), range: w.range(),
    sprite: worldById(playground.worldId).sprite,
  });
  $('world').value = playground.worldId;
  $('seed').value = seed;
  describeWorld();
  fillWatch();
  setSpeed(worldById(playground.worldId).speed ?? 0.25); // a mission sets its own after this
  history.replaceState(null, '', `#${playground.worldId}?seed=${seed}`);
  news(worldById(playground.worldId).headline || 'A new network goes live.', true);
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
  const m = worldById(playground.worldId);
  $('mapTitle').textContent = m.title;
  $('worldTitle').textContent = 'World: ' + m.title;
  $('worldBlurb').textContent = m.blurb;
  const honest = $('worldHonest');
  honest.textContent = m.honest + ' Nothing measured here is a benchmark number. ';
  if (m.results) {
    const a = document.createElement('a');
    a.href = m.results.href;
    a.textContent = m.results.label + ' →';
    honest.append(a);
  }
}

function fillWatch() {
  const sel = $('watch');
  sel.replaceChildren();
  const seen = new Set();
  for (const f of playground.flows) {
    if (seen.has(f.dst)) continue;
    seen.add(f.dst);
    sel.append(new Option(`node ${f.dst} (D${f.id})`, f.dst));
  }
  sel.append(new Option('nothing', -1));
  setWatch(playground.flows.length ? playground.flows[0].dst : -1);
}

function setWatch(n) { playground.watch = Number(n); $('watch').value = String(playground.watch); }

function setSpeed(s) {
  playground.speed = Number(s);
  for (const b of document.querySelectorAll('[data-speed]')) {
    b.setAttribute('aria-pressed', String(Number(b.dataset.speed) === playground.speed));
  }
}

function setTool(t) {
  playground.tool = t;
  mapEl.dataset.tool = t;
  pendingFlowSrc = -1;
  ghost = null;
  for (const b of document.querySelectorAll('button[data-tool]')) b.setAttribute('aria-pressed', String(b.dataset.tool === t));
  const hint = {
    inspect: 'Inspect: click a node to read its routing table.',
    move: 'Move: drag a node to a new spot; drag the ground to pan.',
    build: 'Build: click the ground to put up a new node.',
    bulldoze: playground.worldId === 'satellite' ? 'Bulldoze: click a node to switch it off/on, or a link to cut it.' : 'Bulldoze: click a node to switch it off, again to switch it back on.',
    flow: 'Flow: click a source node, then a destination.',
  }[t];
  toast(hint, 2600);
}

function selectNode(i) { playground.selected = i; lastInspector = 0; }

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
  if (playground.flows.length >= MAX_FLOWS) { toast(`At most ${MAX_FLOWS} flows.`); return -1; }
  const w = playground.world;
  const id = w.addFlow(src, dst, 2, w.now(), 1e9);
  readFlows();
  const keep = playground.watch;
  fillWatch();
  setWatch(dst);
  if (keep >= 0 && keep !== dst) setWatch(dst);
  news(`New service: flow ${id} will carry two packets a second from node ${src} to node ${dst}. Ants are being sent to find the way.`, true);
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
      if (kind !== 'hello') st.ants++;
      flash.set(e.node, kind);
      flashUntil.set(e.node, wallNow + 260);
      const dur = visualDuration(e.v - e.t);
      if (e.peer < 0) {
        if (kind !== 'hello' || $('ovHello').checked) {
          anim.rings.push({ node: e.node, kind, radius: R.meta.range || 300, t0: wallNow, dur: Math.max(dur, 520) });
        }
        if (kind === 'linkfail') news(`Node ${e.node} warns its neighbours: a route through it just broke.`);
      } else {
        anim.flights.push({ from: e.node, to: e.peer, kind, t0: wallNow, dur });
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
        news(`Flow ${e.a} is open: the first packet reached node ${e.node} in ${(e.v * 1000).toFixed(0)} ms, along a path the ants found.`, true);
      } else if (st.delivered % 250 === 0) {
        news(`${st.delivered} packets delivered so far. The colony keeps the trails fresh.`);
      }
      log(e, 'data', 'data');
      break;
    case Ev.Drop:
      st.drops++;
      window10.push([e.t, 0]);
      anim.marks.push({ node: e.node, good: false, t0: wallNow, dur: 900 });
      news(`Packet lost at node ${e.node}: ${DropReason[e.peer] || 'dropped'}.`);
      log(e, 'linkfail', 'data');
      break;
    case Ev.TxFail:
      anim.marks.push({ node: e.node, good: false, t0: wallNow, dur: 900 });
      news(`Link ${e.node}–${e.peer} snapped: node ${e.node}'s radio got no answer. Repair is under way.`);
      log(e, 'linkfail', 'routes');
      break;
    case Ev.NodeDown:
      news(`Node ${e.node} goes dark. Its neighbours will notice when its hellos stop.`, true);
      log(e, null, 'routes');
      break;
    case Ev.NodeUp:
      news(`Node ${e.node} is back on the air and saying hello.`, true);
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

function describe(e) {
  const t = `t=${e.t.toFixed(3)}`;
  switch (e.kind) {
    case -1: return `${t}  ${e.text}`;
    case Ev.TxAnt: return `${t}  n${e.node} → ${e.peer < 0 ? 'all neighbours' : 'n' + e.peer}: ${KIND_LABEL[antKind(e.a, e.b)]}`;
    case Ev.TxData: return `${t}  n${e.node} → n${e.peer}: data packet (flow ${e.a} #${e.b})`;
    case Ev.Deliver: return `${t}  n${e.node}: delivered flow ${e.a} #${e.b} after ${(e.v * 1000).toFixed(1)} ms`;
    case Ev.Drop: return `${t}  n${e.node}: dropped flow ${e.a} #${e.b}: ${DropReason[e.peer] || 'dropped'}`;
    case Ev.Queue: return `${t}  n${e.node}: holding flow ${e.a} #${e.b}, no route to n${e.peer} yet`;
    case Ev.TxFail: return `${t}  n${e.node} → n${e.peer}: no answer (out of reach), link reported broken`;
    case Ev.RouteAdd: return e.a === e.peer ? `${t}  n${e.node}: learned neighbour n${e.peer}` : `${t}  n${e.node}: new pheromone toward n${e.a} via n${e.peer}`;
    case Ev.RouteDel: return e.a === e.peer ? `${t}  n${e.node}: lost neighbour n${e.peer}` : `${t}  n${e.node}: lost the route toward n${e.a} via n${e.peer}`;
    case Ev.NodeDown: return `${t}  n${e.node} switched off`;
    case Ev.NodeUp: return `${t}  n${e.node} switched on`;
    default: return `${t}  event ${e.kind}`;
  }
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
      const text = `Flow ${r.flow}'s strongest trail switched: now ${r.path.map((n) => 'n' + n).join(' → ')} (${r.path.length - 1} hops).`;
      news(text);
      log({ t: w.now(), kind: -1, text }, 'repair', 'routes');
    }
    if (key) routeKeys.set(r.flow, key);
  }
  routes = fresh;
}

function renderInspector(w) {
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
  const motion = playground.worldId === 'satellite' ? '' : v > 0.05 ? ` · <span class="chip">moving ${v.toFixed(1)} m/s</span>` : ' · <span class="chip">standing still</span>';
  p.innerHTML = `<strong>Node ${i}</strong> · ${up ? 'on the air' : 'switched off'}${motion} · ${w.pendingCount(i)} packet(s) waiting · routes to ${dests.length} node(s)`;
  frag.append(p);
  if (d >= 0 && d !== i) {
    const row = w.pheromone(i, d);
    const dist = w.distribution(i, d, -1);
    const prob = new Map();
    for (let k = 0; k < dist.length; k += 2) prob.set(dist[k], dist[k + 1]);
    const rows = [];
    for (let k = 0; k < row.length; k += 3) rows.push([row[k], row[k + 1], row[k + 2]]);
    rows.sort((a, b) => (prob.get(b[0]) || 0) - (prob.get(a[0]) || 0) || b[1] - a[1]);
    const t = document.createElement('table');
    t.className = 'ph';
    t.innerHTML = `<caption>Toward node ${d}, straight from the core's pheromone table</caption>
      <thead><tr><th>via</th><th>τ regular</th><th>τ virtual</th><th>next data packet</th></tr></thead>`;
    const tb = document.createElement('tbody');
    for (const [nb, reg, vir] of rows) {
      const pr = prob.get(nb) || 0;
      const tr = document.createElement('tr');
      tr.innerHTML = `<td>n${nb}</td><td>${reg ? reg.toFixed(2) : '—'}</td><td>${vir ? vir.toFixed(2) : '—'}</td>
        <td><span class="bar" style="width:${Math.round(pr * 56)}px"></span> ${(pr * 100).toFixed(pr > 0 && pr < 0.01 ? 2 : 0)}%</td>`;
      tb.append(tr);
    }
    t.append(tb);
    frag.append(t);
    const note = document.createElement('p');
    note.className = 'muted small';
    note.textContent = dist.length
      ? 'The last column is the core\'s own probability for the next data packet: pheromone raised to β = 20, normalised. The strongest trail wins almost always — almost.'
      : 'No pheromone toward this destination yet: a packet here would wait while a reactive ant searches.';
    frag.append(note);
  } else if (d === i) {
    frag.append(Object.assign(document.createElement('p'), { className: 'muted small', textContent: 'This is the destination being watched.' }));
  }
  body.replaceChildren(frag);
}

function updateStatus(w) {
  const t = w.now();
  const m = Math.floor(t / 60), s = (t - 60 * m).toFixed(2).padStart(5, '0');
  $('clock').textContent = `t ${m}:${s}`;
  let sent = 0;
  const fs = w.flowStats();
  for (let i = 0; i < fs.length; i += 5) sent += fs[i + 2];
  const st = playground.stats;
  $('stDelivered').textContent = `✓ ${st.delivered}/${sent}`;
  $('stDropped').textContent = `✕ ${st.drops}`;
  const ants = w.antTransmissions();
  $('stBudget').textContent = `ants ${ants}` + (st.delivered ? ` · ${(ants / st.delivered).toFixed(1)}/pkt` : '');
  $('stRoutes').textContent = `route switches ${routeChanges}`;
  window10 = window10.filter(([ts]) => ts > t - 10);
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
    if (playground.speed > 0) w.advanceTo(w.now() + (dt / 1000) * playground.speed);
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
      showLinks: $('ovLinks').checked, labels: $('ovLabels').checked,
      flights: anim.flights, rings: anim.rings, marks: anim.marks, flash,
      flows: playground.flows, selected: playground.selected, tool: playground.tool,
      hover, ghost,
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
  if (panButton || (tool === 'move' && i < 0) || (tool === 'inspect' && i < 0)) {
    drag = { pan: true, x: px, y: py, moved: false, clickEmpty: tool === 'inspect' && !panButton };
    return;
  }
  if (tool === 'inspect') { selectNode(i); return; }
  if (tool === 'move') { selectNode(i); drag = { node: i, x: px, y: py }; return; }
  if (tool === 'bulldoze') {
    if (i >= 0) { toggleNode(i); return; }
    if (playground.worldId === 'satellite') {
      const l = R.hitLink(pos, w.links(), px, py);
      if (l) {
        w.cutIslLink(l[0], l[1]);
        news(`Inter-satellite link ${l[0]}–${l[1]} cut. The ants will find the long way round.`, true);
        for (const fn of playground.listeners) fn({ type: 'cut', a: l[0], b: l[1] });
      }
    }
    return;
  }
  if (tool === 'build') {
    const [x, y] = R.unproject(px, py);
    if (playground.worldId === 'satellite') { toast('Satellites are launched, not built: pick another world to build.'); return; }
    if (!inField(x, y)) { toast('Build inside the field.'); return; }
    if (w.nodeCount() >= MAX_NODES) { toast(`The map holds at most ${MAX_NODES} nodes.`); return; }
    const z = playground.worldId === 'fanet' ? 150 : 0;
    const n = w.addNode(x, y, z);
    const m = mobilityFor(playground.worldId);
    if (m) w.setMobility(n, ...m);
    selectNode(n);
    news(`Node ${n} built and on the air. It will learn its neighbours from their hellos.`, true);
    return;
  }
  if (tool === 'flow') {
    if (i < 0) return;
    if (pendingFlowSrc < 0) { pendingFlowSrc = i; selectNode(i); toast(`Source: node ${i}. Now click the destination.`); return; }
    if (i === pendingFlowSrc) { toast('Pick a different node as the destination.'); return; }
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
    ghost = playground.tool === 'build' ? R.unproject(px, py) : null;
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
  toast(`Node ${i} switched ${up ? 'off' : 'on'}.`);
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
  if (ev.target.matches('input, select, textarea')) return;
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
  if (playground.speed > 0) setSpeed.last = playground.speed;
  setSpeed(0);
  const end = w.now() + 5;
  while (w.now() < end) {
    w.advanceTo(w.now() + 0.002);
    let found = false;
    const now = performance.now();
    for (const e of events(w.drainEvents())) {
      handle(e, now);
      if ((e.kind === Ev.TxAnt && antKind(e.a, e.b) !== 'hello') || e.kind === Ev.TxData) found = true;
    }
    if (found) return;
  }
}

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
$('reset').addEventListener('click', () => load(playground.worldId, playground.seed));
$('world').addEventListener('change', (e) => load(e.target.value, playground.seed));
$('seed').addEventListener('change', (e) => load(playground.worldId, Math.max(1, Number(e.target.value) || 1)));
$('share').addEventListener('click', async () => {
  try {
    await navigator.clipboard.writeText(location.href);
    toast('Link copied: same world, same seed, same run.');
  } catch {
    toast(location.href, 6000);
  }
});
new ResizeObserver(() => R.resize()).observe(mapEl);

function buildLegend() {
  const ul = $('legend');
  ul.replaceChildren();
  const items = [['route', 'strongest pheromone route'], ['reactive', 'reactive ant (searching)'], ['backward', 'backward ant (laying pheromone)'],
    ['proactive', 'proactive ant (scouting)'], ['repair', 'repair ant'], ['linkfail', 'link-failure notice'],
    ['data', 'data packet'], ['hello', 'hello (beacon)'], ['pheromone', 'pheromone trail']];
  for (const [k, label] of items) {
    const li = document.createElement('li');
    li.append(R.swatch(k), label);
    ul.append(li);
  }
}

// The front-page welcome card: shown until dismissed once (per browser).
function welcome(fresh) {
  const card = $('welcome');
  if (!fresh || safeStore('get', 'ahn-welcome') === 'seen') return;
  const close = () => { card.hidden = true; safeStore('set', 'ahn-welcome', 'seen'); };
  card.hidden = false;
  $('welcomeClose').addEventListener('click', close);
  $('welcomeExplore').addEventListener('click', () => { close(); mapEl.focus({ preventScroll: true }); });
  $('welcomePlay').addEventListener('click', () => {
    close();
    const first = document.querySelector('#missionBody .missions button');
    if (first) first.click();
    $('missionWin').scrollIntoView({ behavior: reduceMotion.matches ? 'auto' : 'smooth', block: 'nearest' });
  });
}

// --- boot ---------------------------------------------------------------------------------
function parseHash() {
  const m = /^#([a-z]+)(?:\?seed=(\d+))?/.exec(location.hash);
  return m ? { world: m[1], seed: Number(m[2] || 1) } : { world: 'manet', seed: 1 };
}

async function boot() {
  for (const w of WORLDS) $('world').append(new Option(w.title, w.id));
  const saved = safeStore('get', 'ahn-theme');
  applyTheme(saved === 'light' || saved === 'dark' ? saved : null);
  setSpeed(0.25);
  setTool('inspect');
  $('toast').hidden = true;
  const fresh = !location.hash; // a plain visit to the front page, not a shared run
  const h = parseHash();
  await load(h.world, h.seed);
  initMissions(playground);
  welcome(fresh);
  requestAnimationFrame(frame);
}
boot().catch((err) => {
  $('news').textContent = 'Could not start the WebAssembly core: ' + err;
  throw err;
});
