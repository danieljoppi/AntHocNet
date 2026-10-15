// The tuning bench (#638): change one of the Config fields the adapter
// exposes, watch what it does against a ghost run, and take the change to ns-3.
// Each field's doc comment, default, provenance and ns-3 attribute come from
// config-fields.json, generated at build time from config.h and
// configuration.md (web/tools/config_fields.py), so the bench cannot drift
// from the docs. The ghost is a second World on the same seed at the default
// Config, advanced in lockstep with the one on screen; its strongest routes
// are drawn faint under the live ones. Presentation and Config only: the
// bench sets the same mission-scoped knobs the missions do (golden rule 8).
import { t, num } from './i18n.js';

/** Slider ranges (presentation only; the defaults come from the data). */
const RANGE = {
  betaData: [1, 40, 1], betaAnts: [1, 40, 1], alpha: [0.05, 0.99, 0.01],
  helloInterval: [0.25, 5, 0.25], proactiveInterval: [1, 60, 1],
};

/** One field's value as an ns-3 attribute value (web/tools/config_fields.py). */
export function ns3Value(f, v) {
  if (f.kind === 'bool') return v ? 'true' : 'false';
  if (f.kind === 'time') return `${Math.round(v * 1000)}ms`;
  return String(Number(v.toPrecision(6)));
}

/** The command-line flags for every field moved off its default. */
export function ns3Line(meta, values) {
  return meta.fields.filter((f) => f.key in values && values[f.key] !== f.default)
    .map((f) => `${meta.prefix}${f.attr}=${ns3Value(f, values[f.key])}`).join(' ');
}

const totals = (w) => {
  const fs = w.flowStats();
  let sent = 0, got = 0, delay = 0;
  for (let i = 0; i < fs.length; i += 5) { sent += fs[i + 2]; got += fs[i + 3]; delay += fs[i + 4]; }
  return { sent, got, pdr: sent ? got / sent : 0, delayMs: got ? (1000 * delay) / got : 0 };
};

export async function initBench(pg) {
  const body = document.getElementById('benchBody');
  let meta;
  try {
    const r = await fetch('config-fields.json');
    if (!r.ok) throw new Error(`HTTP ${r.status}`);
    meta = await r.json();
  } catch {
    body.textContent = t('bench.unavailable');
    return null;
  }
  let values = {};
  let ours = false;   // the next world reset is the bench's own
  let timer = null;

  const el = (tag, attrs = {}, ...kids) => {
    const e = document.createElement(tag);
    for (const [k, v] of Object.entries(attrs)) {
      if (k === 'class') e.className = v;
      else if (k.startsWith('on')) e.addEventListener(k.slice(2), v);
      else e.setAttribute(k, v);
    }
    for (const k of kids) if (k !== null && k !== undefined) e.append(k);
    return e;
  };
  const shown = (f, v) => (f.kind === 'bool' ? t(v ? 'bench.on' : 'bench.off')
    : f.kind === 'time' ? `${num(v, v < 1 ? 2 : 0)} s` : num(v, Number.isInteger(v) ? 0 : 2));

  const stats = el('div', { class: 'bench-stats', 'aria-live': 'polite' });
  const line = el('code', { class: 'bench-line' });
  const copy = el('button', { type: 'button', class: 'bevel', onclick: async () => {
    try { await navigator.clipboard.writeText(line.textContent); pg.toast(t('bench.copied')); } catch { pg.toast(line.textContent, 6000); }
  } }, t('bench.copy'));
  const reset = el('button', { type: 'button', class: 'bevel', onclick: () => { values = {}; render(); apply(); } }, t('bench.reset'));
  const rows = el('div', { class: 'bench-rows' });

  function render() {
    rows.replaceChildren(...meta.fields.map((f) => {
      const v = f.key in values ? values[f.key] : f.default;
      const id = `bench-${f.key}`;
      const out = el('output', { for: id }, shown(f, v));
      let input;
      if (f.kind === 'bool') {
        input = el('input', { type: 'checkbox', id });
        input.checked = !!v;
        input.addEventListener('change', () => { values[f.key] = input.checked; out.textContent = shown(f, input.checked); apply(); });
      } else {
        const [lo, hi, step] = RANGE[f.key] || [f.default / 4, f.default * 4, f.default / 20];
        input = el('input', { type: 'range', id, min: lo, max: hi, step });
        input.value = v;
        input.addEventListener('input', () => { out.textContent = shown(f, Number(input.value)); });
        input.addEventListener('change', () => { values[f.key] = Number(input.value); apply(); });
      }
      const badges = el('span', { class: 'bench-badges' },
        ...f.provenance.map((p) => el('span', { class: `chip prov-${p}`, title: t(`bench.provTitle.${p}`) }, t(`bench.prov.${p}`))));
      return el('div', { class: `bench-row${f.key in values && values[f.key] !== f.default ? ' moved' : ''}` },
        el('label', { for: id }, el('code', {}, f.key)), input, out,
        el('p', { class: 'small muted' }, f.doc, ' ',
          el('span', {}, t('bench.default', { v: shown(f, f.default) })), ' ', badges, ' ',
          el('span', {}, t('bench.attr'), ' ', el('code', {}, f.attr))));
    }));
  }

  function showStats() {
    const g = pg.ghostRun;
    if (!g) { stats.replaceChildren(el('p', { class: 'small muted' }, t('bench.noGhost'))); return; }
    const a = totals(pg.world), b = totals(g.world);
    const row = (name, x) => el('tr', {}, el('th', { scope: 'row' }, name),
      el('td', {}, `${num(100 * x.pdr, 1)} %`), el('td', {}, `${num(x.delayMs, 1)} ms`), el('td', {}, `${x.got}/${x.sent}`));
    stats.replaceChildren(el('table', { class: 'ph' },
      el('thead', {}, el('tr', {}, el('th', {}, ''), el('th', {}, t('bench.pdr')), el('th', {}, t('bench.delay')), el('th', {}, t('bench.packets')))),
      el('tbody', {}, row(t('bench.yours'), a), row(t('bench.ghost'), b))),
      el('p', { class: 'small muted' }, t('bench.ghostNote')));
  }

  function stopGhost() {
    if (timer) clearInterval(timer);
    timer = null;
    if (pg.ghostRun) pg.ghostRun.world.delete();
    pg.ghostRun = null;
  }

  async function apply() {
    if (pg.custom) { pg.toast(t('bench.notInLevel')); return; }
    const moved = meta.fields.filter((f) => f.key in values && values[f.key] !== f.default);
    const config = Object.fromEntries(moved.map((f) => [f.key, f.kind === 'bool' ? Number(values[f.key]) : values[f.key]]));
    stopGhost();
    ours = true;
    await pg.load(pg.worldId, pg.seed, { config });
    if (moved.length) {
      const w = new pg.M.World(pg.seed, pg.worldId);
      w.start();
      pg.ghostRun = { world: w, routes: [] };
      timer = setInterval(() => {
        const g = pg.ghostRun;
        if (!g || !pg.world) return;
        g.world.advanceTo(pg.world.now());
        g.world.drainEvents();
        g.routes = pg.strongestRoutes(g.world);
        showStats();
      }, 250);
    }
    line.textContent = ns3Line(meta, values) || t('bench.noChange');
    render();
    showStats();
  }

  // Any other world load (the world menu, a mission, a level) ends the
  // experiment: the bench goes back to the defaults.
  pg.on((e) => {
    if (e.type !== 'reset') return;
    if (ours) { ours = false; return; }
    stopGhost();
    values = {};
    render();
    line.textContent = t('bench.noChange');
    showStats();
  });

  body.replaceChildren(
    el('p', { class: 'small' }, t('bench.intro')), rows,
    el('h3', { class: 'small' }, t('bench.compare')), stats,
    el('h3', { class: 'small' }, t('bench.ns3')), el('p', { class: 'small muted' }, t('bench.ns3Note')),
    el('pre', { class: 'bench-pre', tabindex: '0' }, line),
    el('div', { class: 'choices' }, copy, reset));
  render();
  line.textContent = t('bench.noChange');
  showStats();
  return { meta, apply, line: () => ns3Line(meta, values), get values() { return values; }, set(key, v) { values[key] = v; render(); return apply(); } };
}
