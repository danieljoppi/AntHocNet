// The campaign's screens (#566): the chapter map, a level's briefing, the
// in-level HUD with its device dock, and the debrief. The level engine
// (engine.js, #567) owns the rules; this file only shows them and turns the
// player's clicks and keys into engine calls. The map, the renderer and the
// frame loop are the game's own (app.js), so a level is the same world view
// the sandbox uses -- with a Plan phase in which the world is built but not
// yet running.
import { DEVICES, LevelRun, loadProgress, recordStars, isUnlocked, STEP } from './engine.js';
import { CHAPTERS, LEVELS, levelById } from './levels.js';

const $ = (id) => document.getElementById(id);

/** Chapters the design promises next (learn-campaign.md §3), shown locked. */
const LATER = [
  { n: 3, title: 'City streets', family: 'VANET', ships: 'v2.3.0' },
  { n: 4, title: 'Forest', family: 'FANET', ships: 'v2.3.0' },
  { n: 5, title: 'Orbit', family: 'satellites', ships: 'v2.3.0' },
  { n: 6, title: 'Disaster zone', family: 'emergency response', ships: 'v2.4.0' },
  { n: 7, title: 'Contested zone', family: 'tactical radio', ships: 'v2.4.0' },
  { n: 8, title: 'Sky to space', family: 'space-air-ground', ships: 'v2.4.0' },
];

function el(tag, attrs = {}, ...kids) {
  const e = document.createElement(tag);
  for (const [k, v] of Object.entries(attrs)) {
    if (v === undefined || v === null || v === false) continue;
    if (k === 'class') e.className = v;
    else if (k.startsWith('on')) e.addEventListener(k.slice(2), v);
    else e.setAttribute(k, v === true ? '' : v);
  }
  for (const k of kids) if (k !== null && k !== undefined && k !== false) e.append(k);
  return e;
}
const starsText = (n) => '★'.repeat(n) + '☆'.repeat(3 - n);
const starsEl = (n) => el('span', { class: 'stars', 'aria-label': `${n} of 3 stars` }, starsText(n));

export function initCampaign(pg) {
  const sheet = $('campaign');
  const hud = $('hud');
  const dock = $('dock');
  let progress = loadProgress();
  let run = null;        // the LevelRun being played
  let level = null;
  let picked = null;     // the palette class picked for placement
  let cursor = null;     // keyboard placement cursor (field metres)
  let timer = null;
  let unsub = null;
  let lastSample = 0;

  // --- the overlay sheet (map, briefing, debrief) ----------------------------------
  function show(title, ...body) {
    sheet.replaceChildren(el('div', { class: 'sheet-card window', role: 'dialog', 'aria-modal': 'false', 'aria-labelledby': 'campTitle' },
      el('div', { class: 'titlebar', id: 'campTitle' }, title), el('div', { class: 'body' }, ...body)));
    sheet.hidden = false;
    sheet.querySelector('button, a')?.focus({ preventScroll: true });
  }
  function hideSheet() { sheet.hidden = true; }

  function openMap() {
    leaveLevel();
    progress = loadProgress();
    const total = LEVELS.reduce((a, l) => a + (progress[l.id] || 0), 0);
    const chapters = CHAPTERS.map((c) => {
      const ls = LEVELS.filter((l) => l.chapter === c.n);
      const got = ls.reduce((a, l) => a + (progress[l.id] || 0), 0);
      const chips = el('ol', { class: 'chips' }, ...ls.map((l) => {
        const open = isUnlocked(l, LEVELS, progress);
        const n = progress[l.id] || 0;
        return el('li', {}, el('button', {
          type: 'button', class: `chip-btn bevel${n ? ' done' : ''}`, disabled: !open,
          'aria-label': `Level ${l.id}, ${l.title}: ${open ? `${n} of 3 stars` : 'locked'}`,
          onclick: () => openBriefing(l),
        }, el('span', { class: 'lvl' }, l.id), el('span', {}, l.title), open ? starsEl(n) : el('span', { class: 'lock', 'aria-hidden': 'true' }, '🔒')));
      }));
      return el('section', { class: 'chapter', 'aria-labelledby': `ch${c.n}` },
        el('h3', { id: `ch${c.n}` }, `Chapter ${c.n}: ${c.title}`, ' ', el('span', { class: 'muted small' }, `${c.family} · ${got} / ${ls.length * 3} ★`)),
        el('p', { class: 'small' }, c.blurb), chips);
    });
    const later = el('ul', { class: 'later' }, ...LATER.map((c) =>
      el('li', {}, el('b', {}, `Chapter ${c.n}: ${c.title}`), ` (${c.family}) arrives in ${c.ships}.`)));
    show('Campaign',
      el('p', {}, 'Each chapter is one kind of network. Fix what is broken with the devices on offer; the real AntHocNet core does the routing. ', el('b', {}, `${total} / ${LEVELS.length * 3} stars.`)),
      ...chapters, el('h3', {}, 'Coming next'), later,
      el('div', { class: 'choices' },
        el('button', { type: 'button', class: 'bevel', onclick: freePlay }, 'Free play')));
  }

  function openBriefing(l) {
    leaveLevel();
    const probe = new LevelRun(pg.M, l, 1);
    const goals = probe.objectives().map((o) => el('li', {}, o.text));
    probe.delete();
    const cards = l.palette.length
      ? el('ul', { class: 'device-cards' }, ...l.palette.map((p) => {
        const d = DEVICES[p.class];
        return el('li', { class: 'window' }, el('b', {}, d.label), el('span', { class: 'small' }, ` ${d.range} m · ${d.note}`),
          el('span', { class: 'chip' }, `${p.cost} coins${p.limit ? ` · up to ${p.limit}` : ''}`));
      }))
      : el('p', { class: 'small muted' }, 'Nothing to buy in this level: use what is on the map.');
    show(`Level ${l.id}: ${l.title}`,
      el('p', {}, l.story),
      el('h3', {}, 'Goals'), el('ul', { class: 'goals' }, ...goals),
      el('p', { class: 'small' }, `Budget: ${l.budget} coins. Stars: one for the goals, one for keeping ${l.stars?.budgetLeft ?? 0} coins, one for a quiet network (few ants per delivered packet). A hint costs a star.`),
      el('h3', {}, 'Devices'), cards,
      el('p', { class: 'small muted' }, `You start paused, in the Plan phase: place devices, then press Run. Teaches: ${l.mechanism}.`),
      el('div', { class: 'choices' },
        el('button', { type: 'button', class: 'bevel primary', onclick: () => startLevel(l) }, '▶ Plan'),
        el('button', { type: 'button', class: 'bevel', onclick: openMap }, '← Map')));
  }

  // --- playing a level ----------------------------------------------------------------
  function spritesFor() {
    const out = l2sprites(level.world.devices.map((d) => d.class));
    for (const p of run.placed) out.push(DEVICES[p.class].sprite);
    return out;
  }
  const l2sprites = (classes) => classes.map((c) => DEVICES[c].sprite);
  function rings() {
    const r = level.world.devices.map((d, i) => [run.ids[i], DEVICES[d.class].range]);
    for (const p of run.placed) r.push([p.id, DEVICES[p.class].range]);
    return r;
  }

  async function startLevel(l) {
    leaveLevel();
    hideSheet();
    level = l;
    run = new LevelRun(pg.M, l, 1);
    const chapter = CHAPTERS.find((c) => c.n === l.chapter);
    const read = l.debrief.links.find(([, h]) => h.startsWith('docs/') && !h.startsWith('docs/benchmarks/'));
    await pg.load(null, 1, {
      world: run.world, plan: true,
      meta: {
        title: `Level ${l.id}: ${l.title}`, sprite: 'phone', sprites: spritesFor(),
        blurb: l.story,
        honest: 'Teaching radio: unit disk with a range per device class, 2 Mbit/s, no collisions.',
        results: chapter.results,
        read: read ? { href: read[1], label: read[0] } : null,
        headline: `Level ${l.id}: ${l.title}. Plan your network, then press Run.`,
      },
    });
    pg.restart = () => startLevel(l);
    pg.canMove = (i) => !run.started && (i >= l.world.devices.length || !!l.world.devices[i]?.draggable);
    pg.rangeRings = rings();
    unsub = pg.on((e) => { if (e.type === undefined) run.observe(e); });
    buildDock();
    buildHud();
    document.body.classList.add('in-level');
    timer = setInterval(tick, 200);
    $('map').focus({ preventScroll: true });
  }

  function buildDock() {
    dock.replaceChildren();
    if (!run || !level || !level.palette.length) { dock.hidden = true; return; }
    level.palette.forEach((p, k) => {
      const d = DEVICES[p.class];
      const used = run.placed.filter((x) => x.class === p.class).length;
      const left = p.limit ? p.limit - used : Infinity;
      const afford = run.budgetLeft >= p.cost && left > 0;
      dock.append(el('button', {
        type: 'button', class: 'bevel dock-btn', 'aria-pressed': String(picked === p.class), disabled: !afford,
        title: `${k + 1}: ${d.label}, ${d.range} m, ${p.cost} coins`,
        onclick: () => pick(picked === p.class ? null : p.class),
      }, el('kbd', { 'aria-hidden': 'true' }, String(k + 1)), el('b', {}, d.label), el('span', { class: 'small' }, `${d.range} m · ${p.cost}¢${p.limit ? ` · ${Math.max(0, left)} left` : ''}`)));
    });
    dock.hidden = false;
  }

  function pick(cls) {
    picked = cls;
    pg.ghostRange = cls ? DEVICES[cls].range : 0;
    pg.onPlace = cls ? place : null;
    if (cls) {
      cursor = cursor || [level.world.area[0] / 2, level.world.area[1] / 2];
      pg.toast(`${DEVICES[cls].label}: click the map, or move the cursor with the arrow keys and press Enter.`, 4000);
    }
    buildDock();
  }

  function place(x, y) {
    try {
      run.place(picked, x, y);
      pg.renderer.meta.sprites = spritesFor();
      pg.rangeRings = run.started ? null : rings();
      pg.news(`${DEVICES[picked].label} placed. ${run.budgetLeft} coins left.`, true);
      const slot = level.palette.find((p) => p.class === picked);
      if (run.budgetLeft < slot.cost || (slot.limit && run.placed.filter((p) => p.class === picked).length >= slot.limit)) pick(null);
      else buildDock();
      buildHud();
    } catch (err) {
      pg.toast(err.message);
    }
  }

  // The HUD is rebuilt only when its controls change (start, place, answer,
  // hint); tick() updates its numbers in place, so focus never jumps.
  let hudRefs = null;
  function goalLine(li, x) {
    const live = x.o.kind === 'deliver' && run.started ? ` (${Math.round((x.value || 0) * 100)} %)` : '';
    li.className = x.done ? 'done' : x.final ? 'missed' : '';
    li.firstChild.textContent = x.done ? '✓ ' : x.final ? '✕ ' : '○ ';
    li.lastChild.textContent = x.text + live;
  }
  function updateHud() {
    if (!hudRefs) return;
    hudRefs.budget.textContent = `${run.budgetLeft} ¢`;
    hudRefs.clock.textContent = `${Math.min(run.world.now(), level.duration).toFixed(0)} / ${level.duration} s`;
    run.objectives().forEach((x, k) => goalLine(hudRefs.goals[k], x));
  }
  function buildHud() {
    const objs = run.objectives();
    const quiz = level.objectives.map((o, i) => ({ o, i })).find(({ o, i }) => o.kind === 'quiz' && !(i in run.answers));
    const goalItems = objs.map((x) => {
      const li = el('li', {}, el('span', { 'aria-hidden': 'true' }), el('span', {}));
      goalLine(li, x);
      return li;
    });
    const goals = el('ul', { class: 'goals', 'aria-label': 'Goals' }, ...goalItems);
    const quizEl = quiz ? el('div', { class: 'quiz', role: 'group', 'aria-label': quiz.o.question },
      el('p', {}, el('b', {}, quiz.o.question)),
      ...quiz.o.options.map((opt, j) => el('button', { type: 'button', class: 'bevel', onclick: () => {
        const right = run.answer(j);
        pg.toast(right ? 'Right.' : `Not quite: ${quiz.o.options[quiz.o.answer]}.`, 6000);
        buildHud();
      } }, opt))) : null;
    const budget = el('span', { class: 'chip', title: 'Coins left to spend' });
    const clock = el('span', { class: 'chip', title: 'Simulated time / level length' });
    hudRefs = { budget, clock, goals: goalItems };
    hud.replaceChildren(
      el('div', { class: 'hud-top' },
        el('b', {}, `${level.id} ${level.title}`), budget, clock,
        run.started ? null : el('button', { type: 'button', class: 'bevel primary', onclick: go }, '▶ Run'),
        el('button', { type: 'button', class: 'bevel', onclick: hint, disabled: run.hintsUsed >= level.hints.length }, `Hint (−★)`),
        el('button', { type: 'button', class: 'bevel', onclick: () => startLevel(level) }, 'Retry'),
        el('button', { type: 'button', class: 'bevel', onclick: openMap }, 'Map')),
      goals, ...(quizEl ? [quizEl] : []));
    hud.hidden = false;
    updateHud();
  }

  function go() {
    if (run.started) return;
    run.start();
    pg.planning = false;
    pg.rangeRings = null;
    pg.canMove = () => false;  // Adapt by adding devices; positions are set
    pg.setSpeed(level.speed ?? 2);
    lastSample = run.world.now();
    pg.news('Running. Watch the ants find the way.', true);
    buildHud();
  }

  function hint() {
    if (run.hintsUsed >= level.hints.length) return;
    pg.toast(level.hints[run.hintsUsed++], 7000);
    buildHud();
  }

  function tick() {
    if (!run) return;
    const t = run.world.now();
    if (run.started) {
      run.applyHazards(t);
      if (t - lastSample >= STEP) { run.sample(); lastSample = t; }
    }
    updateHud();
    if (run.started && t + 1e-9 >= level.duration) finish();
  }

  function finish() {
    pg.setSpeed(0);
    run.sample();
    const s = run.score();
    if (s.cleared) recordStars(progress, level.id, s.stars);
    const lv = level;
    const next = LEVELS[LEVELS.indexOf(lv) + 1];
    const nextOpen = next && isUnlocked(next, LEVELS, loadProgress());
    const rows = s.objectives.map((x) => el('li', { class: x.done ? 'done' : 'missed' },
      el('span', { 'aria-hidden': 'true' }, x.done ? '✓ ' : '✕ '), x.text,
      x.o.kind === 'deliver' ? ` — ${Math.round((x.value || 0) * 100)} %` : ''));
    const links = el('p', { class: 'small' }, ...lv.debrief.links.flatMap(([label, href]) => [el('a', { href }, label + ' →'), ' ']));
    leaveLevel(true);
    show(s.cleared ? `Level ${lv.id} cleared` : `Level ${lv.id}: not yet`,
      el('p', {}, starsEl(s.stars), ' ', el('b', {}, s.cleared ? 'Well routed.' : 'Not every goal was met. Try another placement.')),
      el('ul', { class: 'goals' }, ...rows),
      el('p', { class: 'small' }, `Coins left: ${s.budgetLeft}${s.budgetStar ? ' ★' : ''} · ants per delivered packet: ${Number.isFinite(s.nrl) ? s.nrl.toFixed(1) : '—'}${s.nrlStar ? ' ★' : ''}${run.hintsUsed ? ` · hints used: ${run.hintsUsed}` : ''}`),
      el('h3', {}, `What you saw: ${lv.mechanism}`), el('p', {}, lv.debrief.text), links,
      el('div', { class: 'choices' },
        el('button', { type: 'button', class: 'bevel', onclick: () => startLevel(lv) }, 'Retry'),
        nextOpen ? el('button', { type: 'button', class: 'bevel primary', onclick: () => openBriefing(next) }, `Next: ${next.id} ${next.title}`) : null,
        el('button', { type: 'button', class: 'bevel', onclick: openMap }, '← Map')));
  }

  /** Leave the level (keep the world on screen when `keepWorld`). */
  function leaveLevel(keepWorld = false) {
    if (timer) clearInterval(timer);
    timer = null;
    if (unsub) unsub();
    unsub = null;
    pick(null);
    hud.hidden = true;
    dock.hidden = true;
    document.body.classList.remove('in-level');
    pg.rangeRings = null;
    pg.canMove = null;
    pg.restart = null;
    hudRefs = null;
    if (!keepWorld) run = null;
  }

  async function freePlay() {
    leaveLevel();
    hideSheet();
    await pg.load('manet', 1);
    history.replaceState(null, '', '#manet?seed=1');
  }

  // Keyboard placement (#566): number keys pick a device from the dock, arrows
  // move the placement cursor, Enter places. Only while a level runs.
  $('map').addEventListener('keydown', (ev) => {
    if (!run || !level || sheet.hidden === false) return;
    const k = Number(ev.key);
    if (k >= 1 && k <= level.palette.length) {
      const slot = level.palette[k - 1];
      pick(picked === slot.class ? null : slot.class);
      ev.preventDefault(); ev.stopImmediatePropagation();
      return;
    }
    if (!picked) return;
    const step = ev.shiftKey ? 50 : 10;
    const mv = { ArrowLeft: [-step, 0], ArrowRight: [step, 0], ArrowUp: [0, -step], ArrowDown: [0, step] }[ev.key];
    if (mv) {
      cursor = [Math.max(0, Math.min(level.world.area[0], cursor[0] + mv[0])), Math.max(0, Math.min(level.world.area[1], cursor[1] + mv[1]))];
      pg.ghostAt?.(cursor);
      ev.preventDefault(); ev.stopImmediatePropagation();
    } else if (ev.key === 'Enter') {
      place(cursor[0], cursor[1]);
      ev.preventDefault(); ev.stopImmediatePropagation();
    } else if (ev.key === 'Escape') {
      pick(null);
      ev.preventDefault(); ev.stopImmediatePropagation();
    }
  }, true);

  sheet.addEventListener('keydown', (e) => { if (e.key === 'Escape' && !run) hideSheet(); });
  addEventListener('hashchange', () => { if (location.hash === '#campaign') openMap(); });

  function hasProgress() { return Object.keys(loadProgress()).length > 0; }
  function continueLevel() {
    const p = loadProgress();
    return LEVELS.find((l) => isUnlocked(l, LEVELS, p) && !p[l.id]) || LEVELS[LEVELS.length - 1];
  }

  return { openMap, openBriefing, startLevel, freePlay, hasProgress, continueLevel, levelById, get run() { return run; } };
}
