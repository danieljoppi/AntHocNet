// ns-3 replay (#641): a real ns-3 run, recorded by a harness's --vizTrace
// (ns3/anthocnet/examples/viz-trace.h), drawn by the game's own renderer.
// Nothing here simulates: positions are interpolated between the recorded
// samples, routes are the strongest next hops ns-3's pheromone tables held at
// each sample, and the delivery counters are the run's FlowMonitor books.
import { IsoRenderer } from './iso.js';
import { initPage } from '../shell/shell.js';
import { initI18n, t, num } from './i18n.js';

const $ = (id) => document.getElementById(id);
const DOC = 'docs/benchmarks/';
/** The published family cells with a recorded run (results/replay/<id>.jsonl). */
const CELLS = [
  { id: 'manet', sprite: 'phone', page: DOC + 'grid/' },
  { id: 'mesh', sprite: 'tower', page: DOC + 'static-mesh/' },
  { id: 'fanet', sprite: 'phone', page: DOC + 'scenarios/fanet/' },
  { id: 'vanet', sprite: 'phone', page: DOC + 'scenarios/vanet/' },
  { id: 'isl', sprite: 'tower', page: DOC + 'satellite/isl-grid/' },
  { id: 'leo', sprite: 'tower', page: DOC + 'satellite/leo-walker/' },
];
const EARTH_FIELD = 2.2e7;  // the game's space worlds: Earth's centre mid-field
const GRID_FIELD = 1000;    // the isl-grid torus laid out flat

let trace = null, R = null, playing = true, speed = 20, simT = 0, lastWall = 0;

/** Parse the JSON-lines trace into a header, the steps and the end books. */
function parse(text) {
  const lines = text.split('\n').filter(Boolean).map((l) => JSON.parse(l));
  const header = lines[0];
  if (header.kind !== 'header' || header.v !== 1) throw new Error('not a v1 replay trace'); // i18n-ok: a file error
  const end = lines.find((l) => l.kind === 'end') || null;
  return { header, steps: lines.filter((l) => l.t !== undefined), end };
}

/** Node positions as the renderer takes them: [x, y, z, up] per node. */
function layout(h, step, next, a) {
  const n = h.nodes, out = new Float64Array(4 * n);
  if (h.layout === 'grid') {
    const gap = GRID_FIELD / Math.max(h.rows, h.cols);
    for (let i = 0; i < n; i++) {
      out[4 * i] = gap * (0.5 + (i % h.cols));
      out[4 * i + 1] = gap * (0.5 + Math.floor(i / h.cols));
      out[4 * i + 3] = 1;
    }
    return out;
  }
  const off = h.coords === 'ecef' ? EARTH_FIELD / 2 : 0;
  for (let i = 0; i < n; i++) {
    const p = step.p[i], q = next ? next.p[i] : p;
    for (let k = 0; k < 3; k++) out[4 * i + k] = (p[k] + (q[k] - p[k]) * a) * h.scale + (k < 2 ? off : 0);
    out[4 * i + 3] = 1;
  }
  return out;
}

function meta(h, cell) {
  if (h.layout === 'grid') return { areaX: GRID_FIELD, areaY: GRID_FIELD, areaZ: 0, channel: 0, range: 0, sprite: cell.sprite };
  if (h.coords === 'ecef') return { areaX: EARTH_FIELD, areaY: EARTH_FIELD, areaZ: 0, channel: 2, range: 0, sprite: cell.sprite };
  const [x, y, z] = h.area;
  const urban = h.propagation === 'urban';
  return {
    areaX: x, areaY: y, areaZ: z, channel: urban ? 1 : 0, range: h.range,
    blocksX: h.blocks?.[0] || 0, blocksY: h.blocks?.[1] || 0, streetWidth: h.street || 0,
    zones: [], sprite: cell.sprite,
  };
}

/** Links to draw: the torus wiring, or who is in disk range (open fields only). */
function links(h, pos) {
  const out = [];
  if (h.layout === 'grid') {
    const { rows, cols } = h;
    for (let r = 0; r < rows; r++) {
      for (let c = 0; c < cols; c++) {
        const i = r * cols + c;
        if (c + 1 < cols || h.torus) out.push(i, r * cols + ((c + 1) % cols));
        if (r + 1 < rows || h.torus) out.push(i, ((r + 1) % rows) * cols + c);
      }
    }
    return out;
  }
  if (h.coords === 'ecef' || h.propagation === 'urban' || !(h.range > 0)) return out;
  const r2 = h.range * h.range, n = h.nodes;
  for (let a = 0; a < n; a++) {
    for (let b = a + 1; b < n; b++) {
      const dx = pos[4 * a] - pos[4 * b], dy = pos[4 * a + 1] - pos[4 * b + 1], dz = pos[4 * a + 2] - pos[4 * b + 2];
      if (dx * dx + dy * dy + dz * dz <= r2) out.push(a, b);
    }
  }
  return out;
}

function stepAt(time) {
  const S = trace.steps;
  let lo = 0, hi = S.length - 1;
  if (time <= S[0].t) return 0;
  while (lo < hi) {
    const mid = (lo + hi + 1) >> 1;
    if (S[mid].t <= time) lo = mid; else hi = mid - 1;
  }
  return lo;
}

function frame(wall) {
  if (!trace) return;
  const dt = lastWall ? (wall - lastWall) / 1000 : 0;
  lastWall = wall;
  const S = trace.steps, h = trace.header;
  const tMax = S[S.length - 1].t;
  if (playing) {
    simT = Math.min(tMax, simT + dt * speed);
    if (simT >= tMax) setPlaying(false);
    $('rpTime').value = simT;
  }
  const k = stepAt(simT), cur = S[k], nxt = S[k + 1];
  const a = nxt ? Math.max(0, Math.min(1, (simT - cur.t) / (nxt.t - cur.t))) : 0;
  const pos = layout(h, cur, nxt, a);
  const routes = cur.paths.map((r, i) => ({ flow: i, path: r.p, complete: r.p[r.p.length - 1] === r.f[1], changedAt: -1e9 }));
  const flows = cur.paths.map((r, i) => ({ id: i, src: r.f[0], dst: r.f[1] }));
  R.draw({
    time: wall, simNow: simT, positions: pos, routes, links: links(h, pos), pheromone: null,
    showLinks: true, labels: false, flights: [], rings: [], marks: [], flash: new Map(),
    flows, selected: -1, tool: 'inspect', hover: null, ghost: null, ghostRange: 0, rangeRings: null,
  });
  const pdr = cur.tx ? (100 * cur.rx) / cur.tx : 0;
  $('rpStats').textContent = t('replay.stats', {
    t: num(simT, 1), T: num(tMax, 0), pdr: num(pdr, 1), rx: cur.rx, tx: cur.tx,
    ants: cur.ants, step: num(h.step, 1), route: cur.drop.route, queue: cur.drop.queue,
  });
  requestAnimationFrame(frame);
}

function setPlaying(on) {
  playing = on;
  $('rpPlay').textContent = t(on ? 'replay.pause' : 'replay.play');
}

async function load(cell) {
  trace = null;
  const about = $('rpAbout');
  about.replaceChildren(Object.assign(document.createElement('p'), { textContent: t('replay.loading') }));
  let text;
  try {
    const r = await fetch(`replay/${cell.id}.jsonl`);
    if (!r.ok) throw new Error(String(r.status));
    text = await r.text();
  } catch {
    about.replaceChildren(Object.assign(document.createElement('p'), { textContent: t('replay.missing') }));
    return;
  }
  trace = parse(text);
  const h = trace.header;
  R.setWorld(meta(h, cell));
  const tMax = trace.steps[trace.steps.length - 1].t;
  Object.assign($('rpTime'), { max: tMax, value: 0 });
  simT = 0;
  lastWall = 0;
  setPlaying(true);
  const p = (text2) => Object.assign(document.createElement('p'), { textContent: text2 });
  const link = Object.assign(document.createElement('a'), { href: cell.page, textContent: t('replay.page') });
  about.replaceChildren(
    p(t(`replay.cells.${cell.id}`)),
    p(t('replay.facts', { harness: h.harness, seed: h.seed, nodes: h.nodes, step: num(h.step, 1) })),
    p(trace.end ? t('replay.books', { pdr: num(trace.end.pdr, 2), rx: trace.end.rx, tx: trace.end.tx }) : t('replay.noEnd')),
    p(t('replay.honest')),
    link);
  requestAnimationFrame(frame);
}

await initI18n();
initPage();
R = new IsoRenderer($('rpView'));
addEventListener('resize', () => R.resize());
const pick = $('rpCell');
for (const c of CELLS) pick.append(new Option(t(`replay.names.${c.id}`), c.id));
const want = CELLS.find((c) => c.id === location.hash.slice(1)) || CELLS[0];
pick.value = want.id;
pick.addEventListener('change', () => {
  history.replaceState(null, '', `#${pick.value}`);
  load(CELLS.find((c) => c.id === pick.value));
});
$('rpPlay').addEventListener('click', () => {
  if (!playing && trace && simT >= trace.steps[trace.steps.length - 1].t) simT = 0;
  setPlaying(!playing);
});
$('rpTime').addEventListener('input', (e) => { simT = Number(e.target.value); });
$('rpSpeed').addEventListener('change', (e) => { speed = Number(e.target.value); });
load(want);
