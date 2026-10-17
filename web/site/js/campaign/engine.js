// The campaign engine (#567). A level is data (levels.js); this file builds its
// world through the WASM adapter's own calls, runs it, applies its hazards, and
// scores it from what the core and the adapter report -- flow statistics, the
// delivery events and the ant-transmission count. No DOM here, so the level
// test (web/test/levels.mjs) plays every level's par solution headless, and
// the game UI (campaign.js) drives the very same runner frame by frame.
//
// Level schema (web/README.md documents it):
//   id, chapter, title, story, mechanism       -- text
//   world: { area: [x, y, z?], range,           -- the field and default radio
//            channel: 'disk' | 'urban' | 'isl',  -- urban: blocks [bx, by], street
//            zones: [{ poly: [x0, y0, ...], factor }],   canopy (#575)
//            shell: { planes, slots, inc, period },      satellites (isl, #575)
//            devices: [{ class, x, y, z, lat, lon, route, battery, moves, draggable }],
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

import { localized, t } from '../i18n.js';

/** Device classes (#568): a radio range, a mobility and a sprite. */
/** Their label and note are i18n keys device.<class>.{label,note} (#622). */
export const DEVICES = Object.freeze(Object.fromEntries(Object.entries({
  phone:    { range: 120, sprite: 'phone', moves: { kind: 1, min: 1, max: 2, pause: 10 } },
  laptop:   { range: 180, sprite: 'laptop', moves: { kind: 1, min: 1, max: 1.5, pause: 60 } },
  pc:       { range: 250, sprite: 'pc', moves: null },
  router:   { range: 300, sprite: 'tower', moves: null },
  repeater: { range: 200, sprite: 'tower', moves: null },
  gateway:  { range: 150, sprite: 'pc', moves: null },
  // Chapters 3-5 (#576-#578). A car drives the street grid (Manhattan); a
  // bus follows its device's route; a roadside unit stands at a corner.
  car:      { range: 300, sprite: 'car', moves: { kind: 3, min: 10, max: 20, pause: 0 } },
  bus:      { range: 300, sprite: 'car', moves: null, route: 8 },
  rsu:      { range: 400, sprite: 'tower', moves: null },
  // A relay drone flies a 3-D Gauss-Markov path on a battery; rangers and
  // sensor posts stand on the forest floor.
  drone:    { range: 300, sprite: 'drone', moves: { kind: 2, min: 15, max: 0.85, pause: 0, threeD: true }, z: 120, battery: 300 },
  ranger:   { range: 300, sprite: 'phone', moves: null },
  sensor:   { range: 150, sprite: 'tower', moves: null },
  // A ground station on the globe links to satellites 25 deg above its
  // horizon; a satellite is placed on an orbit (its plane by RAAN).
  station:  { range: 0, sprite: 'tower', moves: null, ground: 25 },
  dish:     { range: 0, sprite: 'tower', moves: null, ground: 60 },  // a small dish: sees only near-zenith satellites
  satellite:{ range: 0, sprite: 'satellite', moves: null, orbit: true },
}).map(([k, d]) => [k, localized(d, `device.${k}`, ['label', 'note'])])));

/** Seconds of simulated time per runner step (hazards and samples land on it). */
export const STEP = 0.25;

/** Check a placement against the level's palette and budget. */
export function validatePlacements(level, placements) {
  const errors = [];
  let cost = 0;
  const used = {};
  for (const p of placements) {
    const slot = level.palette.find((s) => s.class === p.class);
    if (!slot) { errors.push(t('campaign.err.notOffered', { cls: p.class })); continue; }
    used[p.class] = (used[p.class] || 0) + 1;
    if (slot.limit && used[p.class] > slot.limit) errors.push(t('campaign.err.limit', { n: slot.limit, label: DEVICES[p.class].label }));
    cost += slot.cost;
    const [ax, ay] = level.world.area;
    const sited = DEVICES[p.class]?.ground || DEVICES[p.class]?.orbit;  // placed by site, not by (x, y)
    if (!sited && (p.x < 0 || p.y < 0 || p.x > ax || p.y > ay)) errors.push(t('campaign.err.outside', { label: DEVICES[p.class].label }));
  }
  if (cost > level.budget) errors.push(t('campaign.err.budget', { cost, budget: level.budget }));
  return { cost, errors };
}

// The Earth's radius and the teaching shell (the satellite world's): orbits
// take `period` seconds, ~55x faster than real ones, so the motion shows.
const EARTH = 6.371e6;
const SHELL_ALT = 1.2e6;

/** A point on the Earth's surface, in the field frame (centre = field centre). */
export function surface(w, lat, lon) {
  const r = Math.PI / 180, cx = w.areaX() / 2, cy = w.areaY() / 2;
  return [cx + EARTH * Math.cos(lat * r) * Math.cos(lon * r), cy + EARTH * Math.cos(lat * r) * Math.sin(lon * r), EARTH * Math.sin(lat * r)];
}

/**
 * Add one device to a world; returns its node id. `spec` carries what a class
 * needs beyond (x, y): z, a route, a battery, (lat, lon) for a ground
 * station, (raan, phase) for a satellite.
 */
export function addDevice(w, cls, x, y, moves = true, spec = {}) {
  const d = DEVICES[cls];
  if (!d) throw new Error(`unknown device class ${cls}`); // i18n-ok: a programming error, not player text
  let id;
  if (d.ground) {
    const [sx, sy, sz] = surface(w, spec.lat ?? y, spec.lon ?? x);
    id = w.addNode(sx, sy, sz);
    w.setGroundStation(id, d.ground);
    return id;
  }
  if (d.orbit) {
    id = w.addNode(0, 0, 0);
    w.setOrbit(id, EARTH + SHELL_ALT, spec.inc ?? 53, spec.raan ?? x, spec.phase ?? y, spec.period ?? 120);
    return id;
  }
  id = w.addNode(x, y, spec.z ?? d.z ?? 0);
  if (d.range) w.setNodeRange(id, d.range);
  if (spec.route) w.setRoute(id, spec.route.flatMap(([px, py]) => [px, py, 0]), spec.speed ?? d.route);
  else if (moves && d.moves) w.setMobility(id, d.moves.kind, d.moves.min, d.moves.max, d.moves.pause, !!d.moves.threeD);
  const battery = spec.battery ?? d.battery;
  if (battery) w.setBattery(id, battery);
  return id;
}

/** The teaching shell: planes x slots satellites on the +grid, as the satellite world. */
function buildShell(w, shell) {
  const { planes, slots } = shell;
  const ids = [];
  const skip = new Set(shell.skip || []);  // a plane left empty: a coverage gap
  for (let p = 0; p < planes; p++) {
    for (let s = 0; s < slots; s++) {
      const id = w.addNode(0, 0, 0);
      if (skip.has(p)) w.setNodeUp(id, false);
      w.setOrbit(id, EARTH + SHELL_ALT, shell.inc ?? 53, p * 360 / planes, s * 360 / slots + p * 360 / (planes * slots), shell.period ?? 120);
      ids.push(id);
    }
  }
  for (let p = 0; p < planes; p++) {
    for (let s = 0; s < slots; s++) {
      w.addIslLink(ids[p * slots + s], ids[p * slots + (s + 1) % slots]);
      if (planes > 1) w.addIslLink(ids[p * slots + s], ids[((p + 1) % planes) * slots + s]);
    }
  }
  return ids;
}

/** Build a level's world (not started): its field, devices, then its flows. */
export function buildWorld(M, level, seed) {
  const w = new M.World(seed, '');
  const lw = level.world;
  const [ax, ay, az = 0] = lw.area;
  w.setArea(ax, ay, az);
  if (lw.channel === 'urban') w.setUrbanChannel(lw.range ?? 300, lw.blocks?.[0] ?? 4, lw.blocks?.[1] ?? 4, lw.street ?? 20);
  else if (lw.channel === 'isl') w.setIslChannel();
  else w.setDiskChannel(lw.range ?? 250);
  for (const z of lw.zones || []) w.addAttenuationZone(z.poly, z.factor, z.top ?? 30);
  const ids = lw.devices.map((d) => addDevice(w, d.class, d.x, d.y, d.moves !== false, d));
  // Satellites come after the devices, so device indices (flows, hazards)
  // stay the level's own; hazards address a satellite as 'sat:k'.
  const sats = lw.shell ? buildShell(w, lw.shell) : [];
  for (const f of lw.flows) w.addFlow(ids[f.src], ids[f.dst], f.rate ?? 2, f.start ?? 2, 1e9);
  return { world: w, ids, sats };
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
    const built = world ? { world, ids: [], sats: [] } : buildWorld(M, level, seed);
    this.world = built.world;
    this.ids = built.ids;
    this.sats = built.sats;
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
    const id = addDevice(this.world, cls, x, y, slot.moves !== false, slot.spec || {});
    this.placed.push({ class: cls, x, y, id });
    return id;
  }

  /** Plan phase: move a pre-placed device the level marks draggable. */
  move(device, x, y) {
    const d = this.level.world.devices[device];
    if (!d || !d.draggable) throw new Error(t('campaign.err.fixed'));
    if (this.started) throw new Error(t('campaign.err.planning'));
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
      const node = typeof h.device === 'string' && h.device.startsWith('sat:')
        ? this.sats[Number(h.device.slice(4))]
        : h.device < this.ids.length ? this.ids[h.device] : h.device;
      if (h.do === 'down') this.world.setNodeUp(node, false);
      else if (h.do === 'up') this.world.setNodeUp(node, true);
      else if (h.do === 'move') this.world.moveNode(node, h.to[0], h.to[1], 0);
      else if (h.do === 'cut') this.world.cutIslLink(this.sats[h.a], this.sats[h.b]);
      else if (h.do === 'storm') {
        // A solar storm: every k-th satellite fails (deterministic, no draw).
        for (let s = h.offset ?? 0; s < this.sats.length; s += h.every) this.world.setNodeUp(this.sats[s], false);
      }
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
    if (!this.samples.length) return { sent: 0, delivered: 0 };  // not started yet
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
                 text: o.flows === 'all' || !o.flows
                   ? t('campaign.obj.deliverAll', { p: Math.round(o.ratio * 100), from: o.from ?? 0, to: o.to ?? this.level.duration })
                   : t('campaign.obj.deliver', { p: Math.round(o.ratio * 100), calls: o.flows.map((f) => f + 1).join(t('campaign.and')), from: o.from ?? 0, to: o.to ?? this.level.duration }) };
      }
      if (o.kind === 'quiz') {
        const i = this.level.objectives.indexOf(o);
        const chosen = this.answers[i];
        return { o, value: chosen, done: chosen === o.answer, final: chosen !== undefined, text: o.question };
      }
      if (o.kind === 'connect') {
        const first = this.firstDelivery[o.flow];
        const done = first !== undefined && first <= o.within;
        return { o, value: first, done, final: done || now >= o.within,
                 text: t('campaign.obj.connect', { call: o.flow + 1, s: o.within }) };
      }
      throw new Error(`unknown objective ${o.kind}`); // i18n-ok: a programming error
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
