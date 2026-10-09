// The Workshop (#634): the Nest (#635) and the install quest (#636).
// The Nest reads the core's API from api/api-index.json (built from Doxygen's
// XML by web/shell/api_index.py) and lights its chambers from a running world.
// Presentation only: the world runs with default Config and nothing here
// changes it (golden rule 9).
import { engine, events, Ev } from './engine.js';
import { CHAMBERS, SURFACE } from './nest-data.js';
import { STEPS, parseDoctor } from './install-steps.js';
import { initPage } from '../shell/shell.js';

const $ = (id) => document.getElementById(id);
const NS = 'http://www.w3.org/2000/svg';
const store = {
  get(k) { try { return localStorage.getItem(k); } catch { return null; } },
  set(k, v) { try { localStorage.setItem(k, v); } catch { /* private mode */ } },
};
initPage();

// --- the Nest ------------------------------------------------------------------
const el = (tag, attrs = {}, text) => {
  const n = document.createElementNS(NS, tag);
  for (const [k, v] of Object.entries(attrs)) n.setAttribute(k, v);
  if (text !== undefined) n.textContent = text;
  return n;
};

// As many class names as fit the chamber's width (about 7 px per mono char).
function shortList(names, maxChars) {
  let out = names[0];
  for (const n of names.slice(1)) {
    if ((out + ' · ' + n).length > maxChars) return out + ' …';
    out += ' · ' + n;
  }
  return out;
}

function drawNest() {
  const svg = $('nest');
  svg.append(el('rect', { x: 0, y: 0, width: 948, height: 84, class: 'sky' }));
  svg.append(el('rect', { x: 0, y: 84, width: 948, height: 616, class: 'soil' }));
  svg.append(el('text', { x: 474, y: 22, class: 'label-sm', 'text-anchor': 'middle' }, 'SURFACE · the adapters'));
  // tunnels from the surface down through the chambers
  for (const d of ['M210 66 C 210 120, 330 150, 380 210', 'M738 66 C 738 120, 620 150, 568 210', 'M474 306 L 474 368',
    'M380 290 C 320 340, 250 370, 220 400', 'M568 290 C 630 340, 700 370, 730 400', 'M474 472 L 474 558', 'M300 470 C 360 520, 400 560, 410 590']) {
    svg.append(el('path', { d, class: 'tunnel' }));
  }
  for (const s of SURFACE) {
    const g = el('g', { class: 'surface' });
    g.append(el('rect', { x: s.x - 150, y: 30, width: 300, height: 46, rx: 12 }));
    g.append(el('text', { x: s.x, y: 50, 'text-anchor': 'middle', class: 'title' }, s.title));
    g.append(el('text', { x: s.x, y: 68, 'text-anchor': 'middle', class: 'cls' }, s.cls));
    svg.append(g);
  }
  for (const c of CHAMBERS) {
    const g = el('g', { class: 'chamber', tabindex: 0, role: 'button', 'data-id': c.id,
      'aria-label': `${c.title}: ${c.classes.join(', ')}` });
    g.append(el('ellipse', { cx: c.x, cy: c.y, rx: c.rx, ry: c.ry, class: 'glow' }));
    g.append(el('ellipse', { cx: c.x, cy: c.y, rx: c.rx, ry: c.ry, class: 'room' }));
    g.append(el('text', { x: c.x, y: c.y - (c.ry > 35 ? 6 : 2), 'text-anchor': 'middle', class: 'title' }, c.title));
    g.append(el('text', { x: c.x, y: c.y + (c.ry > 35 ? 16 : 14), 'text-anchor': 'middle', class: 'cls' },
      shortList(c.classes, Math.floor(c.rx / 4.4))));
    g.addEventListener('click', () => select(c.id));
    g.addEventListener('keydown', (e) => { if (e.key === 'Enter' || e.key === ' ') { e.preventDefault(); select(c.id); } });
    svg.append(g);
  }
}

let api = null;
fetch('api/api-index.json').then((r) => (r.ok ? r.json() : null)).then((j) => { api = j; }).catch(() => {});

let world = null;
let selected = null;

function select(id) {
  selected = id;
  for (const g of document.querySelectorAll('.chamber')) g.classList.toggle('on', g.dataset.id === id);
  const c = CHAMBERS.find((x) => x.id === id);
  $('chamberTitle').textContent = c.title;
  const body = $('chamberBody');
  body.replaceChildren();
  body.append(Object.assign(document.createElement('p'), { textContent: c.blurb }));
  const ul = document.createElement('ul');
  ul.className = 'ws-classes';
  for (const name of c.classes) {
    const info = api && api.classes[name];
    const li = document.createElement('li');
    const a = document.createElement('a');
    a.href = info ? `api/${info.url}` : 'api/';
    a.textContent = name;
    li.append(a);
    if (info) {
      const brief = info.brief;
      if (brief) li.append(Object.assign(document.createElement('span'), { textContent: ' — ' + brief }));
      const n = info.members.filter((m) => m.kind === 'function').length;
      if (n) li.append(Object.assign(document.createElement('small'), { textContent: ` ${n} public function${n > 1 ? 's' : ''}` }));
    }
    ul.append(li);
  }
  body.append(ul);
  if (c.live) {
    const p = document.createElement('p');
    p.className = 'ws-livevals';
    p.id = 'liveVals';
    body.append(p);
    showLive();
  }
}

// PheromoneTable, live: node 7's row toward its first destination.
function showLive() {
  const p = $('liveVals');
  if (!p || !world) return;
  const node = 7;
  const dests = Array.from(world.destinations(node));
  if (!dests.length) { p.textContent = `Live: node ${node} holds no pheromone yet.`; return; }
  const d = dests[0];
  const row = Array.from(world.pheromone(node, d));
  const parts = [];
  for (let i = 0; i < row.length; i += 3) parts.push(`via ${row[i]}: ${row[i + 1].toFixed(4)}`);
  p.textContent = `Live, getPheromoneRegular at node ${node} toward ${d}: ${parts.slice(0, 4).join(' · ')}`;
}

const heat = Object.fromEntries(CHAMBERS.map((c) => [c.id, 0]));
const KIND = Object.fromEntries(Object.entries(Ev).map(([k, v]) => [v, k]));

async function runWorld() {
  const M = await engine();
  world = new M.World(1, 'manet');
  world.start();
  $('nestLive').textContent = 'world: ad hoc, seed 1 · t 0:00';
  let last = performance.now();
  const reduce = matchMedia('(prefers-reduced-motion: reduce)').matches;
  const tick = (now) => {
    const dt = Math.min(0.1, (now - last) / 1000);
    last = now;
    world.advanceTo(world.now() + dt);
    for (const e of events(world.drainEvents())) {
      const k = KIND[e.kind];
      for (const c of CHAMBERS) if (c.events.includes(k)) heat[c.id] += 1;
    }
    for (const g of document.querySelectorAll('.chamber')) {
      const h = heat[g.dataset.id];
      g.style.setProperty('--heat', reduce ? 0 : Math.min(1, h / 30).toFixed(3));
      heat[g.dataset.id] = h * 0.92;
    }
    const t = world.now();
    $('nestLive').textContent = `world: ad hoc, seed 1 · t ${Math.floor(t / 60)}:${String(Math.floor(t % 60)).padStart(2, '0')}`;
    if (selected === 'store' && Math.floor(t * 2) !== Math.floor((t - dt) * 2)) showLive();
    requestAnimationFrame(tick);
  };
  requestAnimationFrame(tick);
}

// --- the install quest -------------------------------------------------------------
function renderQuest() {
  const text = store.get('ahn-quest') || '';
  const doctor = parseDoctor(text);
  const ol = $('questSteps');
  ol.replaceChildren();
  let done = 0;
  for (const s of STEPS) {
    const [state, note] = s.status(doctor, text);
    if (state === 'ok') done++;
    const li = document.createElement('li');
    li.className = `ws-step ${state}`;
    const icon = { ok: '✓', warn: '!', fail: '✗', todo: '○' }[state];
    li.innerHTML = '<span class="ws-icon" aria-hidden="true"></span><div><b></b> <code></code><p></p></div>';
    li.querySelector('.ws-icon').textContent = icon;
    li.querySelector('b').textContent = s.title;
    li.querySelector('code').textContent = s.cmd;
    li.querySelector('p').textContent = note;
    li.setAttribute('aria-label', `${s.title}: ${state === 'todo' ? 'to do' : state}. ${note}`);
    ol.append(li);
  }
  $('questScore').textContent = `${done} / ${STEPS.length}`;
}

$('questCheck').addEventListener('click', () => {
  const add = $('questPaste').value.trim();
  if (!add) return;
  // Keep what was pasted before: doctor output and test output come separately.
  const prev = store.get('ahn-quest') || '';
  const merged = /##DOCTOR## /.test(add) ? prev.split('\n').filter((l) => !l.startsWith('##DOCTOR## ')).join('\n') + '\n' + add : prev + '\n' + add;
  store.set('ahn-quest', merged);
  $('questPaste').value = '';
  renderQuest();
});
$('questReset').addEventListener('click', () => { store.set('ahn-quest', ''); renderQuest(); });

drawNest();
renderQuest();
runWorld().catch((err) => { $('nestLive').textContent = 'Could not start the WebAssembly core: ' + err; });
