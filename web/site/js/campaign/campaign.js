// The campaign's screens (#566): the chapter map, a level's briefing, the
// in-level HUD with its device dock, and the debrief. The level engine
// (engine.js, #567) owns the rules; this file only shows them and turns the
// player's clicks and keys into engine calls. The map, the renderer and the
// frame loop are the game's own (app.js), so a level is the same world view
// the sandbox uses -- with a Plan phase in which the world is built but not
// yet running.
import { DEVICES, LevelRun, loadProgress, recordStars, isUnlocked, STEP } from './engine.js';
import { CHAPTERS, LEVELS, levelById } from './levels.js';
import { UPGRADES, upgradesFor, loadChoices, saveChoice, upgradeName } from './upgrades.js';
import { t, num, has, localized } from '../i18n.js';

/** A link label: a doc.* key, or an API name shown as is. */
const label = (l) => (has(l) ? t(l) : l);

const $ = (id) => document.getElementById(id);

/** Chapters the design promises next (learn-campaign.md §3), shown locked. */
const LATER = [
  { n: 6, ships: 'v2.4.0' }, { n: 7, ships: 'v2.4.0' }, { n: 8, ships: 'v2.4.0' },
].map((c) => localized(c, `chapter.${c.n}`, ['title', 'family']));

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
const starsEl = (n) => el('span', { class: 'stars', 'aria-label': t('missions.stars', { n }) }, starsText(n));

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
          'aria-label': t(open ? 'campaign.chipOpen' : 'campaign.chipLocked', { id: l.id, title: l.title, n }),
          onclick: () => openBriefing(l),
        }, el('span', { class: 'lvl' }, l.id), el('span', {}, l.title), open ? starsEl(n) : el('span', { class: 'lock', 'aria-hidden': 'true' }, '🔒')));
      }));
      return el('section', { class: 'chapter', 'aria-labelledby': `ch${c.n}` },
        el('h3', { id: `ch${c.n}` }, t('campaign.chapter', { n: c.n, title: c.title }), ' ', el('span', { class: 'muted small' }, `${c.family} · ${got} / ${ls.length * 3} ★`)),
        el('p', { class: 'small' }, c.blurb), chips);
    });
    const later = el('ul', { class: 'later' }, ...LATER.map((c) =>
      el('li', {}, el('b', {}, t('campaign.chapter', { n: c.n, title: c.title })), ' ' + t('campaign.arrives', { family: c.family, v: c.ships }))));
    show(t('campaign.title'),
      el('p', {}, t('campaign.intro') + ' ', el('b', {}, t('campaign.totalStars', { n: total, max: LEVELS.length * 3 }))),
      ...chapters, el('h3', {}, t('campaign.next')), later,
      el('div', { class: 'choices' },
        el('button', { type: 'button', class: 'bevel', onclick: openUpgrades }, t('campaign.upgrades')),
        el('button', { type: 'button', class: 'bevel', onclick: freePlay }, t('campaign.free'))));
  }

  // --- upgrades (#579): real gated mechanisms, earned by clearing a level ----------
  function openUpgrades() {
    progress = loadProgress();
    const cards = el('ul', { class: 'device-cards upgrades' }, ...UPGRADES.map((u) => {
      const open = (progress[u.unlock] || 0) > 0;
      return el('li', { class: 'window' },
        el('b', {}, upgradeName(u)), ' ', el('span', { class: 'chip' }, open ? t('campaign.upgradeOpen') : t('campaign.upgradeLocked', { id: u.unlock })),
        el('p', { class: 'small' }, t(`upgrade.${u.id}.what`)),
        el('p', { class: 'small' }, el('b', {}, t('campaign.upgradeMeasured') + ' '), t(`upgrade.${u.id}.measured`)),
        el('p', { class: 'small muted' }, t('campaign.upgradeHelps', { chapters: u.helps.join(', ') }) + ' · ',
          el('a', { href: `https://github.com/danieljoppi/AntHocNet/issues/${u.issue}` }, `#${u.issue}`)));
    }));
    show(t('campaign.upgrades'), el('p', {}, t('campaign.upgradesIntro')), cards,
      el('div', { class: 'choices' }, el('button', { type: 'button', class: 'bevel', onclick: openMap }, t('campaign.backMap'))));
  }

  function upgradeToggles(l) {
    const offered = upgradesFor(l, progress);
    if (!offered.length) return [];
    const chosen = new Set(loadChoices()[l.id] || []);
    return [el('h3', {}, t('campaign.upgrades')),
      el('ul', { class: 'goals upgrade-toggles' }, ...offered.map((u) => {
        const box = el('input', { type: 'checkbox', id: `up-${u.id}` });
        box.checked = chosen.has(u.id);
        box.addEventListener('change', () => {
          if (box.checked) chosen.add(u.id); else chosen.delete(u.id);
          saveChoice(l.id, [...chosen]);
        });
        return el('li', {}, box, ' ', el('label', { for: `up-${u.id}` }, el('b', {}, upgradeName(u)), ' — ', t(`upgrade.${u.id}.what`)));
      })),
      el('p', { class: 'small muted' }, t('campaign.upgradesNote'))];
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
          el('span', { class: 'chip' }, t('campaign.coins', { n: p.cost }) + (p.limit ? ' · ' + t('campaign.upTo', { n: p.limit }) : '')));
      }))
      : el('p', { class: 'small muted' }, t('campaign.nothingToBuy'));
    show(t('campaign.level', { id: l.id, title: l.title }),
      el('p', {}, l.story),
      el('h3', {}, t('campaign.goals')), el('ul', { class: 'goals' }, ...goals),
      el('p', { class: 'small' }, t('campaign.rules', { budget: l.budget, keep: l.stars?.budgetLeft ?? 0 })),
      el('h3', {}, t('campaign.devices')), cards,
      ...upgradeToggles(l),
      el('p', { class: 'small muted' }, t('campaign.planNote', { mechanism: l.mechanism })),
      el('div', { class: 'choices' },
        el('button', { type: 'button', class: 'bevel primary', onclick: () => startLevel(l) }, t('campaign.plan')),
        el('button', { type: 'button', class: 'bevel', onclick: openMap }, t('campaign.backMap'))));
  }

  // --- playing a level ----------------------------------------------------------------
  function spritesFor() {
    const out = l2sprites(level.world.devices.map((d) => d.class));
    for (let k = 0; k < (run.sats?.length || 0); k++) out.push(null);  // the shell (#578)
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
    const ups = upgradesFor(l, progress).map((u) => u.id).filter((id) => (loadChoices()[l.id] || []).includes(id));
    run = new LevelRun(pg.M, l, 1, { upgrades: ups });
    const chapter = CHAPTERS.find((c) => c.n === l.chapter);
    const read = l.debrief.links.find(([, h]) => h.startsWith('docs/') && !h.startsWith('docs/benchmarks/'));
    await pg.load(null, 1, {
      world: run.world, plan: true,
      meta: {
        title: t('campaign.level', { id: l.id, title: l.title }), sprite: 'phone', sprites: spritesFor(),
        blurb: ups.length ? `${l.story} ${t('campaign.upgradesOn', { list: ups.map((id) => upgradeName(UPGRADES.find((u) => u.id === id))).join(', ') })}` : l.story,
        honest: t('campaign.honest'),
        results: chapter.results,
        read: read ? { href: read[1], label: label(read[0]) } : null,
        headline: t('campaign.headline', { id: l.id, title: l.title }),
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
        title: t('campaign.dockTitle', { k: k + 1, label: d.label, range: d.range, cost: p.cost }),
        onclick: () => pick(picked === p.class ? null : p.class),
      }, el('kbd', { 'aria-hidden': 'true' }, String(k + 1)), el('b', {}, d.label), el('span', { class: 'small' }, `${d.range} m · ${p.cost}¢` + (p.limit ? ' · ' + t('campaign.left', { n: Math.max(0, left) }) : ''))));
    });
    dock.hidden = false;
  }

  function pick(cls) {
    // #578: a slot with a fixed site (a ground station's city, a satellite's
    // plane) is placed at once: there is nowhere on the globe to click.
    const fixed = cls && level.palette.find((p) => p.class === cls)?.spec;
    if (fixed && (DEVICES[cls].ground || DEVICES[cls].orbit)) {
      picked = cls;
      place(fixed.lon ?? fixed.raan ?? 0, fixed.lat ?? fixed.phase ?? 0);
      picked = null;
      buildDock();
      return;
    }
    picked = cls;
    pg.ghostRange = cls ? DEVICES[cls].range : 0;
    pg.onPlace = cls ? place : null;
    if (cls) {
      cursor = cursor || [level.world.area[0] / 2, level.world.area[1] / 2];
      pg.toast(t('campaign.placeHelp', { label: DEVICES[cls].label }), 4000);
    }
    buildDock();
  }

  function place(x, y) {
    try {
      run.place(picked, x, y);
      pg.renderer.meta.sprites = spritesFor();
      pg.rangeRings = run.started ? null : rings();
      pg.news(t('campaign.placed', { label: DEVICES[picked].label, n: run.budgetLeft }), true);
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
    const live = x.o.kind === 'deliver' && run.started ? ` (${Math.round((x.value || 0) * 100)} %)` : ''; // i18n-ok
    li.className = x.done ? 'done' : x.final ? 'missed' : '';
    li.firstChild.textContent = x.done ? '✓ ' : x.final ? '✕ ' : '○ ';
    li.lastChild.textContent = x.text + live;
  }
  function updateHud() {
    if (!hudRefs) return;
    hudRefs.budget.textContent = `${run.budgetLeft} ¢`;
    hudRefs.clock.textContent = `${Math.min(run.world.now(), level.duration).toFixed(0)} / ${level.duration} s`; // i18n-ok: numbers and a unit
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
    const goals = el('ul', { class: 'goals', 'aria-label': t('campaign.goals') }, ...goalItems);
    const quizEl = quiz ? el('div', { class: 'quiz', role: 'group', 'aria-label': quiz.o.question },
      el('p', {}, el('b', {}, quiz.o.question)),
      ...quiz.o.options.map((opt, j) => el('button', { type: 'button', class: 'bevel', onclick: () => {
        const right = run.answer(j);
        pg.toast(right ? t('campaign.right') : t('campaign.notQuite', { answer: quiz.o.options[quiz.o.answer] }), 6000);
        buildHud();
      } }, opt))) : null;
    const budget = el('span', { class: 'chip', title: t('campaign.budgetTitle') });
    const clock = el('span', { class: 'chip', title: t('campaign.clockTitle') });
    hudRefs = { budget, clock, goals: goalItems };
    hud.replaceChildren(
      el('div', { class: 'hud-top' },
        el('b', {}, `${level.id} ${level.title}`), budget, clock,
        run.started ? null : el('button', { type: 'button', class: 'bevel primary', onclick: go }, t('campaign.run')),
        el('button', { type: 'button', class: 'bevel', onclick: hint, disabled: run.hintsUsed >= level.hints.length }, t('campaign.hint')),
        el('button', { type: 'button', class: 'bevel', onclick: () => startLevel(level) }, t('campaign.retry')),
        el('button', { type: 'button', class: 'bevel', onclick: openMap }, t('campaign.map'))),
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
    pg.news(t('campaign.running'), true);
    buildHud();
  }

  function hint() {
    if (run.hintsUsed >= level.hints.length) return;
    pg.toast(level.hints[run.hintsUsed++], 7000);
    buildHud();
  }

  function tick() {
    if (!run) return;
    const now = run.world.now();
    if (run.started) {
      run.applyHazards(now);
      if (now - lastSample >= STEP) { run.sample(); lastSample = now; }
    }
    updateHud();
    if (run.started && now + 1e-9 >= level.duration) finish();
  }

  function finish() {
    pg.setSpeed(0);
    run.sample();
    const s = run.score();
    const earned = s.cleared && !(progress[level.id] > 0) ? UPGRADES.find((u) => u.unlock === level.id) : null;
    if (s.cleared) recordStars(progress, level.id, s.stars);
    const lv = level;
    const next = LEVELS[LEVELS.indexOf(lv) + 1];
    const nextOpen = next && isUnlocked(next, LEVELS, loadProgress());
    const rows = s.objectives.map((x) => el('li', { class: x.done ? 'done' : 'missed' },
      el('span', { 'aria-hidden': 'true' }, x.done ? '✓ ' : '✕ '), x.text,
      x.o.kind === 'deliver' ? ` — ${Math.round((x.value || 0) * 100)} %` : ''));
    const links = el('p', { class: 'small' }, ...lv.debrief.links.flatMap(([l, href]) => [el('a', { href }, label(l) + ' →'), ' ']));
    leaveLevel(true);
    show(t(s.cleared ? 'campaign.cleared' : 'campaign.notYet', { id: lv.id }),
      el('p', {}, starsEl(s.stars), ' ', el('b', {}, t(s.cleared ? 'campaign.wellRouted' : 'campaign.missed'))),
      el('ul', { class: 'goals' }, ...rows),
      el('p', { class: 'small' }, t('campaign.coinsLeft', { n: s.budgetLeft }) + (s.budgetStar ? ' ★' : '')
        + ' · ' + t('campaign.nrl', { x: Number.isFinite(s.nrl) ? num(s.nrl, 1) : '—' }) + (s.nrlStar ? ' ★' : '')
        + (run.hintsUsed ? ' · ' + t('campaign.hintsUsed', { n: run.hintsUsed }) : '')),
      el('h3', {}, t('campaign.whatYouSaw', { mechanism: lv.mechanism })), el('p', {}, lv.debrief.text), links,
      earned ? el('p', { class: 'window upgrade-earned' }, el('b', {}, t('campaign.upgradeEarned', { name: upgradeName(earned) })), ' ', t(`upgrade.${earned.id}.what`)) : null,
      el('div', { class: 'choices' },
        el('button', { type: 'button', class: 'bevel', onclick: () => startLevel(lv) }, t('campaign.retry')),
        nextOpen ? el('button', { type: 'button', class: 'bevel primary', onclick: () => openBriefing(next) }, t('campaign.nextLevel', { id: next.id, title: next.title })) : null,
        el('button', { type: 'button', class: 'bevel', onclick: openMap }, t('campaign.backMap'))));
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
