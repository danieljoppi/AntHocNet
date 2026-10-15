// The campaign's levels (#567 format; chapters 1 and 2, #569 and #570). Each
// level is data: the devices already there, the calls to carry, what the player
// may add, what clears it, and a par solution the level test (web/test/levels.mjs)
// plays on five seeds so no level ships impossible. Distances are metres; a link
// needs both ends in range (phone 120, laptop 180, PC 250, router 300, repeater
// 200, home gateway 150). No number here is a benchmark: the debriefs link to
// the measured pages.
import { localized, t } from '../i18n.js';

const DOC = 'docs/';
const RES = 'docs/benchmarks/';
const ARL = 'api/classanthocnet_1_1core_1_1AntRouterLogic.html';
const PT = 'api/classanthocnet_1_1core_1_1PheromoneTable.html';

// Words live in i18n/<lang>.json (#622): chapter.<n> and level.<id with _>;
// a quiz is level.<id>.quiz<k>; prose link labels are doc.* keys.
export const CHAPTERS = [
  { n: 1,
    results: { href: RES + 'grid/' } },
  { n: 2,
    results: { href: RES + 'static-mesh/' } },
].map((c) => {
  localized(c, `chapter.${c.n}`, ['title', 'family', 'blurb']);
  localized(c.results, `chapter.${c.n}.results`, ['label']);
  return c;
});

export const LEVELS = [
  // --- Chapter 1: Ad hoc town (MANET) ------------------------------------------
  {
    id: '1.1', chapter: 1,
    world: {
      area: [400, 250],
      devices: [
        { class: 'phone', x: 90, y: 125, moves: false },
        { class: 'phone', x: 310, y: 125, moves: false, draggable: true },
      ],
      flows: [{ src: 0, dst: 1, rate: 2, start: 2 }],
    },
    budget: 0, palette: [], duration: 30,
    objectives: [
      { kind: 'connect', flow: 0, within: 10 },
      { kind: 'deliver', flows: [0], ratio: 0.9, from: 5, to: 30 },
    ],
    stars: { budgetLeft: 0, maxNrl: 20 },
    debrief: {
      links: [['doc.howItWorks', DOC + 'ant-colony-routing/'], ['AntRouterLogic::learnNeighbor', ARL]],
    },
    par: [{ move: 1, x: 190, y: 125 }],
  },
  {
    id: '1.2', chapter: 1,
    world: {
      area: [500, 300],
      devices: [
        { class: 'pc', x: 80, y: 150 },
        { class: 'pc', x: 420, y: 150 },
      ],
      flows: [{ src: 0, dst: 1, rate: 2, start: 2 }],
    },
    budget: 30, palette: [{ class: 'laptop', cost: 30, limit: 1, moves: false }], duration: 60,
    objectives: [
      { kind: 'connect', flow: 0, within: 15 },
      { kind: 'deliver', flows: [0], ratio: 0.9, from: 10, to: 60 },
    ],
    stars: { budgetLeft: 0, maxNrl: 15 },
    debrief: {
      links: [['doc.antTypes', DOC + 'ant-types/'], ['AntRouterLogic::onDataPacket', ARL]],
    },
    par: [{ class: 'laptop', x: 250, y: 150 }],
  },
  {
    id: '1.3', chapter: 1,
    world: {
      area: [500, 350],
      devices: [
        { class: 'pc', x: 110, y: 175 },
        { class: 'laptop', x: 250, y: 110, moves: false },
        { class: 'laptop', x: 250, y: 240, moves: false },
        { class: 'pc', x: 390, y: 175 },
      ],
      flows: [{ src: 0, dst: 3, rate: 2, start: 2 }],
    },
    budget: 0, palette: [], duration: 40,
    objectives: [
      { kind: 'quiz', answer: 0 },
      { kind: 'deliver', flows: [0], ratio: 0.9, from: 10, to: 40 },
    ],
    stars: { budgetLeft: 0, maxNrl: 30 },
    debrief: {
      links: [['doc.acoModel', DOC + 'ant-colony-routing/'], ['PheromoneTable::nextNeighborNode', PT]],
    },
    par: [{ answer: 0 }],
  },
  {
    id: '1.4', chapter: 1,
    world: {
      area: [600, 400],
      devices: [
        { class: 'pc', x: 60, y: 200 },
        { class: 'pc', x: 540, y: 200 },
        { class: 'phone', x: 200, y: 120 }, { class: 'phone', x: 300, y: 260 },
        { class: 'phone', x: 380, y: 140 }, { class: 'phone', x: 260, y: 200 },
        { class: 'phone', x: 160, y: 300 }, { class: 'phone', x: 440, y: 290 },
      ],
      flows: [{ src: 0, dst: 1, rate: 2, start: 2 }],
    },
    budget: 40, palette: [{ class: 'pc', cost: 40, limit: 1 }], duration: 90,
    objectives: [
      { kind: 'deliver', flows: [0], ratio: 0.85, from: 20, to: 90 },
    ],
    stars: { budgetLeft: 0, maxNrl: 25 },
    debrief: {
      links: [['doc.antTypesProactiveAnts', DOC + 'ant-types/'], ['doc.manetGrid', RES + 'grid/']],
    },
    par: [{ class: 'pc', x: 300, y: 200 }],
  },
  {
    id: '1.5', chapter: 1,
    world: {
      area: [500, 360],
      devices: [
        { class: 'pc', x: 80, y: 180 },
        { class: 'pc', x: 420, y: 180 },
        { class: 'laptop', x: 250, y: 110, moves: false },
      ],
      flows: [{ src: 0, dst: 1, rate: 2, start: 2 }],
    },
    budget: 40, palette: [{ class: 'pc', cost: 40, limit: 1 }], duration: 90,
    hazards: [{ at: 40, do: 'down', device: 2 }],
    objectives: [
      { kind: 'deliver', flows: [0], ratio: 0.9, from: 10, to: 40 },
      { kind: 'deliver', flows: [0], ratio: 0.8, from: 45, to: 90 },
    ],
    stars: { budgetLeft: 0, maxNrl: 20 },
    debrief: {
      links: [['doc.antTypesRepair', DOC + 'ant-types/'], ['AntRouterLogic::onLinkFailure', ARL]],
    },
    par: [{ class: 'pc', x: 250, y: 250 }],
  },
  {
    id: '1.6', chapter: 1,
    world: {
      area: [520, 360],
      devices: [
        { class: 'pc', x: 50, y: 50 }, { class: 'pc', x: 470, y: 310 },
        { class: 'pc', x: 50, y: 310 }, { class: 'pc', x: 470, y: 50 },
        { class: 'pc', x: 260, y: 20 }, { class: 'pc', x: 260, y: 340 },
        { class: 'phone', x: 150, y: 140 }, { class: 'phone', x: 220, y: 220 },
        { class: 'phone', x: 330, y: 160 }, { class: 'phone', x: 380, y: 250 },
        { class: 'phone', x: 120, y: 250 }, { class: 'phone', x: 300, y: 100 },
        { class: 'phone', x: 200, y: 300 }, { class: 'phone', x: 430, y: 150 },
      ],
      flows: [
        { src: 0, dst: 1, rate: 2, start: 2 },
        { src: 2, dst: 3, rate: 2, start: 3 },
        { src: 4, dst: 5, rate: 2, start: 4 },
      ],
    },
    budget: 120, palette: [{ class: 'pc', cost: 40, limit: 3 }, { class: 'laptop', cost: 25, limit: 3 }], duration: 120,
    objectives: [
      { kind: 'deliver', flows: 'all', ratio: 0.9, from: 20, to: 120 },
    ],
    stars: { budgetLeft: 60, maxNrl: 12 },
    debrief: {
      links: [['doc.manetGrid', RES + 'grid/'], ['doc.metricsNrl', RES + 'metrics/']],
    },
    par: [{ class: 'pc', x: 260, y: 180 }],
  },

  // --- Chapter 2: Neighbourhood mesh (static Wi-Fi mesh) ---------------------------
  {
    id: '2.1', chapter: 2,
    world: {
      area: [800, 500],
      devices: [
        { class: 'router', x: 400, y: 250 },
        { class: 'gateway', x: 60, y: 60 }, { class: 'gateway', x: 740, y: 60 },
        { class: 'gateway', x: 60, y: 440 }, { class: 'gateway', x: 740, y: 440 },
      ],
      flows: [
        { src: 1, dst: 0, rate: 1, start: 2 }, { src: 2, dst: 0, rate: 1, start: 3 },
        { src: 3, dst: 0, rate: 1, start: 4 }, { src: 4, dst: 0, rate: 1, start: 5 },
      ],
    },
    budget: 160, palette: [{ class: 'router', cost: 40, limit: 4 }, { class: 'repeater', cost: 20, limit: 4 }], duration: 60,
    objectives: [{ kind: 'deliver', flows: 'all', ratio: 0.9, from: 15, to: 60 }],
    stars: { budgetLeft: 0, maxNrl: 30 },
    debrief: {
      links: [['doc.staticMesh', RES + 'static-mesh/'], ['doc.regimes', DOC + 'network-regimes/']],
    },
    par: [
      { class: 'router', x: 170, y: 140 }, { class: 'router', x: 630, y: 140 },
      { class: 'router', x: 170, y: 360 }, { class: 'router', x: 630, y: 360 },
    ],
  },
  {
    id: '2.2', chapter: 2,
    world: {
      area: [700, 400],
      devices: [
        { class: 'router', x: 350, y: 200 },
        { class: 'router', x: 100, y: 100 }, { class: 'router', x: 600, y: 100 },
        { class: 'router', x: 100, y: 300 }, { class: 'router', x: 600, y: 300 },
      ],
      flows: [{ src: 1, dst: 4, rate: 1, start: 2 }, { src: 2, dst: 3, rate: 1, start: 3 }],
    },
    budget: 0, palette: [], duration: 60,
    objectives: [
      { kind: 'quiz', answer: 0 },
      { kind: 'deliver', flows: 'all', ratio: 0.95, from: 10, to: 60 },
    ],
    stars: { budgetLeft: 0, maxNrl: 1e9 },
    debrief: {
      links: [['doc.staticMesh', RES + 'static-mesh/'], ['doc.antTypes', DOC + 'ant-types/']],
    },
    par: [{ answer: 0 }],
  },
  {
    id: '2.3', chapter: 2,
    world: {
      area: [700, 400],
      devices: [
        { class: 'router', x: 350, y: 200 },
        { class: 'gateway', x: 80, y: 200 }, { class: 'gateway', x: 620, y: 200 },
        { class: 'router', x: 200, y: 140 },
      ],
      flows: [{ src: 1, dst: 0, rate: 1, start: 2 }, { src: 2, dst: 0, rate: 1, start: 3 }],
    },
    budget: 80, palette: [{ class: 'router', cost: 40, limit: 2 }, { class: 'repeater', cost: 20, limit: 2 }], duration: 80,
    hazards: [{ at: 30, do: 'down', device: 3 }],
    objectives: [
      { kind: 'deliver', flows: 'all', ratio: 0.85, from: 35, to: 80 },
    ],
    stars: { budgetLeft: 20, maxNrl: 40 },
    debrief: {
      links: [['doc.staticMesh', RES + 'static-mesh/'], ['AntRouterLogic::loseNeighbor', ARL]],
    },
    par: [{ class: 'router', x: 200, y: 260 }, { class: 'repeater', x: 520, y: 200 }],
  },
  {
    id: '2.4', chapter: 2,
    world: {
      area: [900, 600],
      devices: [
        { class: 'router', x: 450, y: 300 },
        { class: 'gateway', x: 80, y: 80 }, { class: 'gateway', x: 450, y: 60 }, { class: 'gateway', x: 820, y: 80 },
        { class: 'gateway', x: 80, y: 520 }, { class: 'gateway', x: 450, y: 540 }, { class: 'gateway', x: 820, y: 520 },
      ],
      flows: [1, 2, 3, 4, 5, 6].map((h, i) => ({ src: h, dst: 0, rate: 1, start: 2 + i })),
    },
    budget: 240, palette: [{ class: 'router', cost: 40, limit: 6 }, { class: 'repeater', cost: 20, limit: 6 }], duration: 90,
    objectives: [{ kind: 'deliver', flows: 'all', ratio: 0.9, from: 20, to: 90 }],
    stars: { budgetLeft: 40, maxNrl: 40 },
    debrief: {
      links: [['doc.staticMesh', RES + 'static-mesh/'], ['doc.metricsNrl', RES + 'metrics/']],
    },
    par: [
      { class: 'router', x: 190, y: 170 }, { class: 'router', x: 710, y: 170 },
      { class: 'router', x: 190, y: 430 }, { class: 'router', x: 710, y: 430 },
      { class: 'repeater', x: 450, y: 170 }, { class: 'repeater', x: 450, y: 430 },
    ],
  },
].map((l) => {
  const key = `level.${l.id.replace('.', '_')}`;
  localized(l, key, ['title', 'mechanism', 'story', 'hints']);
  Object.defineProperty(l.debrief, 'text', { get: () => t(`${key}.debrief`), enumerable: true });
  let k = 0;
  for (const o of l.objectives) if (o.kind === 'quiz') localized(o, `${key}.quiz${++k}`, ['question', 'options']);
  return l;
});

export const levelById = (id) => LEVELS.find((l) => l.id === id);
