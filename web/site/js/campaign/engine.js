// The campaign engine (#567). A level is data (levels.js); this file builds its
// world through the WASM adapter's own calls, runs it, applies its hazards, and
// scores it from what the core and the adapter report -- flow statistics, the
// delivery events and the ant-transmission count. No DOM here, so the level
// test (web/test/levels.mjs) plays every level's par solution headless, and
// the game UI (campaign.js) drives the very same runner frame by frame.
//
// Level schema (web/README.md documents it):
//   id, chapter, title, story, mechanism       -- text
//   world: { area: [x, y], range,               -- the field and default radio
//            devices: [{ class, x, y, moves, draggable }],  pre-placed, 0..n-1
//            flows: [{ src, dst, rate, start }] }  device indices
//   budget, palette: [{ class, cost, limit, moves }]  what the player may place
//                                                (moves: false = set down still)
//   duration                                     -- simulated seconds scored
//   objectives: [{ kind: 'deliver', flows, ratio, from, to }
//              | { kind: 'connect', flow, within }
//              | { kind: 'quiz', question, options, answer }]  (answer: index)
//   stars: { budgetLeft, maxNrl }                -- the 2nd and 3rd star
//   hazards: [{ at, do: 'down' | 'up' | 'move', device, to: [x, y] }]
//   hints: [..], debrief: { text, links: [[label, href]] }
//   par: [{ class, x, y } | { move, x, y } | { answer }]  -- clears the level

/** Device classes (#568): a radio range, a mobility and a sprite. */
export const DEVICES = Object.freeze({
  phone:    { label: 'Phone', range: 120, sprite: 'phone', moves: { kind: 1, min: 1, max: 2, pause: 10 },
              note: 'carried at walking pace; short range' },
  laptop:   { label: 'Laptop', range: 180, sprite: 'laptop', moves: { kind: 1, min: 1, max: 1.5, pause: 60 },
              note: 'moved now and then' },
  pc:       { label: 'Desktop PC', range: 250, sprite: 'pc', moves: null, note: 'static, indoors' },
  router:   { label: 'Rooftop router', range: 300, sprite: 'tower', moves: null, note: 'static, on a roof' },
  repeater: { label: 'Repeater', range: 200, sprite: 'tower', moves: null, note: 'static, cheap, short reach' },
  gateway:  { label: 'Home gateway', range: 150, sprite: 'pc', moves: null, note: 'static, indoors' },
});

/** Seconds of simulated time per runner step (hazards and samples land on it). */
export const STEP = 0.25;

/** Check a placement against the level's palette and budget. */
export function validatePlacements(level, placements) {
  const errors = [];
  let cost = 0;
  const used = {};
  for (const p of placements) {
    const slot = level.palette.find((s) => s.class === p.class);
    if (!slot) { errors.push(`${p.class} is not on offer in this level`); continue; }
    used[p.class] = (used[p.class] || 0) + 1;
    if (slot.limit && used[p.class] > slot.limit) errors.push(`at most ${slot.limit} × ${DEVICES[p.class].label}`);
    cost += slot.cost;
    const [ax, ay] = level.world.area;
    if (p.x < 0 || p.y < 0 || p.x > ax || p.y > ay) errors.push(`${DEVICES[p.class].label} placed outside the map`);
  }
  if (cost > level.budget) errors.push(`over budget: ${cost} of ${level.budget}`);
  return { cost, errors };
}

/** Add one device to a world; returns its node id. */
export function addDevice(w, cls, x, y, moves = true) {
  const d = DEVICES[cls];
  if (!d) throw new Error(`unknown device class ${cls}`);
  const id = w.addNode(x, y, 0);
  w.setNodeRange(id, d.range);
  if (moves && d.moves) w.setMobility(id, d.moves.kind, d.moves.min, d.moves.max, d.moves.pause, false);
  return id;
}

/** Build a level's world (not started): its devices, then its flows. */
export function buildWorld(M, level, seed) {
  const w = new M.World(seed, '');
  const [ax, ay] = level.world.area;
  w.setArea(ax, ay, 0);
  w.setDiskChannel(level.world.range ?? 250);
  const ids = level.world.devices.map((d) => addDevice(w, d.class, d.x, d.y, d.moves !== false));
  for (const f of level.world.flows) w.addFlow(ids[f.src], ids[f.dst], f.rate ?? 2, f.start ?? 2, 1e9);
  return { world: w, ids };
}

const flowTotals = (w) => {
  const fs = w.flowStats();
  const out = [];
  for (let i = 0; i < fs.length; i += 5) out.push({ sent: fs[i + 2], delivered: fs[i + 3] });
  return out;
};

/**
 * One play of a level. The UI calls place() during the plan phase, start(),
 * then advance(t) every frame; the test calls runToEnd(). Objectives are
 * read from flow statistics sampled on the STEP grid and from Deliver events.
 */
export class LevelRun {
  constructor(M, level, seed, { world } = {}) {
    this.level = level;
    this.seed = seed;
    const built = world ? { world, ids: [] } : buildWorld(M, level, seed);
    this.world = built.world;
    this.ids = built.ids;
    this.placed = [];
    this.hintsUsed = 0;
    this.samples = [];          // [t, per-flow {sent, delivered}]
    this.firstDelivery = {};    // flow -> simulated time of its first delivery
    this.hazardsDone = new Set();
    this.answers = {};          // objective index -> chosen option
    this.started = false;
    this.ended = false;
  }

  /** Plan phase: place a device from the palette. Returns its node id or throws. */
  place(cls, x, y) {
    const { errors } = validatePlacements(this.level, [...this.placed, { class: cls, x, y }]);
    if (errors.length) throw new Error(errors[0]);
    const slot = this.level.palette.find((p) => p.class === cls);
    const id = addDevice(this.world, cls, x, y, slot.moves !== false);
    this.placed.push({ class: cls, x, y, id });
    return id;
  }

  /** Plan phase: move a pre-placed device the level marks draggable. */
  move(device, x, y) {
    const d = this.level.world.devices[device];
    if (!d || !d.draggable) throw new Error('that device stays where it is');
    if (this.started) throw new Error('devices are moved while planning');
    const [ax, ay] = this.level.world.area;
    this.world.moveNode(this.ids[device], Math.max(0, Math.min(ax, x)), Math.max(0, Math.min(ay, y)), 0);
  }

  /** Answer a quiz objective (the first unanswered one); returns whether it was right. */
  answer(choice) {
    const q = this.level.objectives.find((o) => o.kind === 'quiz' && !(this.level.objectives.indexOf(o) in this.answers));
    if (!q) return false;
    this.answers[this.level.objectives.indexOf(q)] = choice;
    return choice === q.answer;
  }

  /** Apply a par solution (the level test, and the 'show me' button). */
  applyPar() {
    for (const p of this.level.par) {
      if ('answer' in p) this.answer(p.answer);
      else if ('move' in p) this.move(p.move, p.x, p.y);
      else this.place(p.class, p.x, p.y);
    }
  }

  /** Budget spent and left. */
  get spent() { return validatePlacements(this.level, this.placed).cost; }
  get budgetLeft() { return this.level.budget - this.spent; }

  start() {
    if (this.started) return;
    this.world.start();
    this.started = true;
    this.sample();
  }

  /** Feed the run the core's events (the UI already drains them). */
  observe(e) {
    if (e.kind === 4 && !(e.a in this.firstDelivery)) this.firstDelivery[e.a] = e.t;
  }

  sample() { this.samples.push([this.world.now(), flowTotals(this.world)]); }

  applyHazards(t) {
    (this.level.hazards || []).forEach((h, i) => {
      if (this.hazardsDone.has(i) || h.at > t) return;
      this.hazardsDone.add(i);
      const node = h.device < this.ids.length ? this.ids[h.device] : h.device;
      if (h.do === 'down') this.world.setNodeUp(node, false);
      else if (h.do === 'up') this.world.setNodeUp(node, true);
      else if (h.do === 'move') this.world.moveNode(node, h.to[0], h.to[1], 0);
    });
  }

  /** Advance to simulated time t on the STEP grid; returns the events seen. */
  advance(t, onEvent) {
    if (!this.started) this.start();
    const end = Math.min(t, this.level.duration);
    const seen = [];
    while (this.world.now() + 1e-9 < end) {
      const next = Math.min(end, (Math.floor(this.world.now() / STEP + 1e-9) + 1) * STEP);
      this.applyHazards(next);
      this.world.advanceTo(next);
      const flat = this.world.drainEvents();
      for (let i = 0; i < flat.length; i += 7) {
        const e = { t: flat[i], kind: flat[i + 1], node: flat[i + 2], peer: flat[i + 3], a: flat[i + 4], b: flat[i + 5], v: flat[i + 6] };
        this.observe(e);
        if (onEvent) onEvent(e);
        seen.push(e);
      }
      this.sample();
    }
    if (this.world.now() + 1e-9 >= this.level.duration) this.ended = true;
    return seen;
  }

  runToEnd() { this.advance(this.level.duration); return this.score(); }

  /** Totals of the flows in `which` ('all' or ids) at the sample nearest t. */
  totalsAt(t, which) {
    let best = this.samples[0];
    for (const s of this.samples) if (s[0] <= t + 1e-9) best = s;
    const fl = best[1];
    const ids = which === 'all' || which === undefined ? fl.map((_, i) => i) : which;
    return ids.reduce((a, i) => ({ sent: a.sent + (fl[i]?.sent || 0), delivered: a.delivered + (fl[i]?.delivered || 0) }), { sent: 0, delivered: 0 });
  }

  /** Each objective's state now: { text, done, value }. */
  objectives() {
    const now = this.world.now();
    return this.level.objectives.map((o) => {
      if (o.kind === 'deliver') {
        const a = this.totalsAt(o.from ?? 0, o.flows);
        const b = this.totalsAt(Math.min(now, o.to ?? this.level.duration), o.flows);
        const sent = b.sent - a.sent, got = b.delivered - a.delivered;
        const ratio = sent ? got / sent : 0;
        const over = now + 1e-9 >= (o.to ?? this.level.duration);
        return { o, value: ratio, done: over && ratio >= o.ratio, final: over,
                 text: `Deliver ${Math.round(o.ratio * 100)} % ${o.flows === 'all' || !o.flows ? 'of all calls' : 'of call ' + o.flows.map((f) => f + 1).join(' and ')} from t = ${o.from ?? 0} to ${o.to ?? this.level.duration} s` };
      }
      if (o.kind === 'quiz') {
        const i = this.level.objectives.indexOf(o);
        const chosen = this.answers[i];
        return { o, value: chosen, done: chosen === o.answer, final: chosen !== undefined, text: o.question };
      }
      if (o.kind === 'connect') {
        const t = this.firstDelivery[o.flow];
        const done = t !== undefined && t <= o.within;
        return { o, value: t, done, final: done || now >= o.within,
                 text: `Connect call ${o.flow + 1} within ${o.within} s` };
      }
      throw new Error(`unknown objective ${o.kind}`);
    });
  }

  /** Routing overhead: ant transmissions per delivered packet. */
  nrl() {
    const d = this.totalsAt(this.world.now(), 'all').delivered;
    return d ? this.world.antTransmissions() / d : Infinity;
  }

  /** Stars: 1 for every objective, +1 for budget left, +1 for a quiet network, -1 per hint. */
  score() {
    const objs = this.objectives();
    const cleared = objs.every((x) => x.done);
    const s = this.level.stars || {};
    const budgetStar = this.budgetLeft >= (s.budgetLeft ?? 0);
    const nrlStar = this.nrl() <= (s.maxNrl ?? Infinity);
    const stars = cleared ? Math.max(1, 1 + (budgetStar ? 1 : 0) + (nrlStar ? 1 : 0) - this.hintsUsed) : 0;
    return { cleared, stars, objectives: objs, budgetLeft: this.budgetLeft, nrl: this.nrl(), budgetStar, nrlStar };
  }

  delete() { this.world.delete(); }
}

// --- progress (per browser) -------------------------------------------------------
const STORE = 'ahn-campaign-v1';

export function loadProgress() {
  try { return JSON.parse(localStorage.getItem(STORE) || '{}'); } catch { return {}; }
}
export function saveProgress(p) {
  try { localStorage.setItem(STORE, JSON.stringify(p)); } catch { /* storage blocked: play without it */ }
}
export function recordStars(progress, levelId, stars) {
  progress[levelId] = Math.max(progress[levelId] || 0, stars);
  saveProgress(progress);
}

/**
 * Unlocking (learn-campaign.md §3): levels in a chapter open in order;
 * chapter 2 opens when chapter 1 is cleared; 3, 4 and 5 together after 2;
 * 6-8 after 5; 9 after 8.
 */
export const CHAPTER_REQUIRES = { 1: [], 2: [1], 3: [2], 4: [2], 5: [2], 6: [5], 7: [5], 8: [5], 9: [8] };

export function chapterCleared(chapter, levels, progress) {
  const ls = levels.filter((l) => l.chapter === chapter);
  return ls.length > 0 && ls.every((l) => (progress[l.id] || 0) > 0);
}

export function isUnlocked(level, levels, progress) {
  if (!(CHAPTER_REQUIRES[level.chapter] || []).every((c) => chapterCleared(c, levels, progress))) return false;
  const ls = levels.filter((l) => l.chapter === level.chapter);
  const i = ls.indexOf(level);
  return i <= 0 || (progress[ls[i - 1].id] || 0) > 0;
}
