// Missions (#546): a ladder that teaches each AntHocNet mechanism on the
// default MANET-style worlds, plus one signature challenge per network family
// (#547). Missions are data (missions-data.js); this file is the small engine
// that runs them: questions, prediction rounds scored against the core's own
// forwarding probabilities, goals checked against core events, stars, hints,
// and a debrief that links to the doc page and the API symbol behind it.
import { MISSIONS } from './missions-data.js';
import { Ev } from './engine.js';

const $ = (id) => document.getElementById(id);
const STORE = 'ahn-missions-v1';

function loadProgress() {
  try { return JSON.parse(localStorage.getItem(STORE) || '{}'); } catch { return {}; }
}
function saveProgress(p) {
  try { localStorage.setItem(STORE, JSON.stringify(p)); } catch { /* best-effort */ }
}

export function initMissions(pg) {
  const progress = loadProgress();
  let active = null;

  function el(tag, attrs = {}, ...kids) {
    const e = document.createElement(tag);
    for (const [k, v] of Object.entries(attrs)) {
      if (k === 'class') e.className = v;
      else if (k.startsWith('on')) e.addEventListener(k.slice(2), v);
      else e.setAttribute(k, v);
    }
    for (const k of kids) e.append(k);
    return e;
  }

  function stars(n) { return '★'.repeat(n) + '☆'.repeat(3 - n); }

  // --- the mission list -------------------------------------------------------
  function showList() {
    active?.stop(true);
    active = null;
    $('missionTitle').textContent = 'Missions';
    const body = $('missionBody');
    body.replaceChildren();
    for (const group of ['Academy', 'World challenges']) {
      body.append(el('p', { class: 'small' }, el('b', {}, group)));
      const ul = el('ul', { class: 'missions' });
      MISSIONS.filter((m) => m.group === group).forEach((m) => {
        const got = progress[m.id] || 0;
        const btn = el('button', { class: 'bevel', type: 'button', onclick: () => start(m) },
          el('span', {}, `${m.n}. ${m.title}`),
          el('span', { class: 'stars', 'aria-label': `${got} of 3 stars` }, stars(got)));
        ul.append(el('li', {}, btn));
      });
      body.append(ul);
    }
    const total = MISSIONS.reduce((a, m) => a + (progress[m.id] || 0), 0);
    body.append(el('p', { class: 'muted small' }, `${total} / ${MISSIONS.length * 3} stars. Or just play: every tool works outside a mission too.`));
  }

  // --- running one mission ------------------------------------------------------
  async function start(m) {
    active?.stop();
    const body = $('missionBody');
    $('missionTitle').textContent = `Mission ${m.n}: ${m.title}`;
    const goal = el('p', { class: 'mission-goal' }, m.goal);
    const status = el('p', { class: 'small' }, '');
    const bar = el('div', { class: 'progress' }, el('span', { style: 'width:0%' }));
    const ask = el('div', {});
    let hintsUsed = 0;
    const hintBtn = el('button', { class: 'bevel', type: 'button' }, 'Hint');
    const hintText = el('p', { class: 'small muted' }, '');
    hintBtn.addEventListener('click', () => {
      if (hintsUsed < m.hints.length) hintText.textContent = m.hints[hintsUsed++];
      if (hintsUsed >= m.hints.length) hintBtn.disabled = true;
    });
    const back = el('button', { class: 'bevel', type: 'button', onclick: showList }, '← Missions');
    body.replaceChildren(el('p', {}, m.intro), goal, bar, status, ask,
      el('div', { class: 'choices' }, hintBtn, back), hintText);

    await pg.load(m.world, m.seed, { config: m.config || {} });
    if (m.config && Object.keys(m.config).length) {
      pg.toast(`Mission knob: ${Object.entries(m.config).map(([k, v]) => `${k} = ${v}`).join(', ')} (reset when you leave).`, 5000);
    }
    pg.setSpeed(m.speed ?? 0.25);
    if (m.tool) pg.setTool(m.tool);

    let done = false;
    const unsub = [];
    const timers = [];
    const ctx = {
      pg,
      get world() { return pg.world; },
      state: {},
      progress(frac, text) {
        bar.firstChild.style.width = `${Math.round(Math.max(0, Math.min(1, frac)) * 100)}%`;
        if (text !== undefined) status.textContent = text;
      },
      /** Show a question; resolves with the chosen option's value. */
      ask(question, options) {
        return new Promise((resolve) => {
          const row = el('div', { class: 'choices', role: 'group', 'aria-label': question });
          for (const o of options) {
            row.append(el('button', { class: 'bevel', type: 'button', onclick: () => { ask.replaceChildren(); resolve(o.value); } }, o.label));
          }
          ask.replaceChildren(el('p', {}, el('b', {}, question)), row);
          row.querySelector('button')?.focus({ preventScroll: true });
        });
      },
      say(text) { ask.replaceChildren(el('p', {}, text)); },
      on(fn) { const u = pg.on((e) => { if (!done && e.type !== 'reset') fn(e); }); unsub.push(u); return u; },
      /** Run fn every `ms` of wall time until the mission ends; returns a cancel. */
      every(ms, fn) {
        const t = setInterval(() => { if (!done) fn(); }, ms);
        timers.push(t);
        return () => clearInterval(t);
      },
      complete(score, debriefText) {
        if (done) return;
        done = true;
        const n = Math.max(1, Math.min(3, score - Math.max(0, hintsUsed - 1)));
        progress[m.id] = Math.max(progress[m.id] || 0, n);
        saveProgress(progress);
        bar.firstChild.style.width = '100%';
        pg.news(`Mission accomplished: “${m.title}”. ${stars(n)}`, true);
        const links = el('p', { class: 'small' });
        for (const [label, href] of m.links) {
          links.append(el('a', { href }, label + ' →'), ' ');
        }
        const next = MISSIONS.find((x) => x.n === m.n + 1 && x.group === m.group);
        ask.replaceChildren(
          el('p', {}, el('span', { class: 'stars', 'aria-label': `${n} of 3 stars` }, stars(n)), ' ', el('b', {}, 'Done.')),
          el('p', {}, debriefText || ''),
          el('p', {}, m.debrief), links,
          el('div', { class: 'choices' },
            next ? el('button', { class: 'bevel', type: 'button', onclick: () => start(next) }, `Next: ${next.title}`) : '',
            el('button', { class: 'bevel', type: 'button', onclick: showList }, 'All missions')));
      },
    };
    active = {
      /** Leave the mission; `reload` restores a mission knob to the defaults. */
      stop(reload = false) {
        done = true;
        unsub.forEach((u) => u());
        timers.forEach((t) => clearInterval(t));
        if (reload && ctx.state.knobbed) pg.load(pg.worldId, pg.seed);
      },
    };
    if (m.config && Object.keys(m.config).length) ctx.state.knobbed = true;
    m.run(ctx, Ev);
  }

  showList();
  return { showList, start };
}
