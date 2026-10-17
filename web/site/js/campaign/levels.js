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
  { n: 3,
    results: { href: RES + 'scenarios/vanet/' } },
  { n: 4,
    results: { href: RES + 'scenarios/fanet/' } },
  { n: 5,
    results: { href: RES + 'satellite/leo-walker/' } },
].map((c) => {
  localized(c, `chapter.${c.n}`, ['title', 'family', 'blurb']);
  localized(c.results, `chapter.${c.n}.results`, ['label']);
  return c;
});

// Chapters 3-5 (#576-#578) build on the #575 adapter features.
const CITY = { area: [800, 800], channel: 'urban', range: 300, blocks: [4, 4], street: 20 };
const STREET = [0, 200, 400, 600, 800];
const car = (i, j) => ({ class: 'car', x: STREET[i], y: STREET[j] });
const FOREST = { area: [800, 800, 200], range: 300 };
const canopy = (x0, x1) => ({ poly: [x0, 0, x1, 0, x1, 800, x0, 800], factor: 0.5 });
const SKY = { area: [2.2e7, 2.2e7], channel: 'isl', shell: { planes: 8, slots: 8 } };
const station = (lat, lon) => ({ class: 'station', lat, lon });

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

  // --- Chapter 3: City streets (VANET, #576) --------------------------------------
  // The street grid of the vanet world: 4 x 4 blocks of 200 m, buildings cut
  // every link that leaves its street. Cars 300 m, roadside units 400 m.
  {
    id: '3.1', chapter: 3,
    world: { ...CITY, devices: [car(0, 2), car(2, 2), car(4, 2), car(2, 0)],
             flows: [{ src: 0, dst: 2, rate: 2, start: 3 }] },
    budget: 0, palette: [], duration: 60,
    objectives: [{ kind: 'quiz', answer: 0 }],
    stars: { budgetLeft: 0, maxNrl: 1e9 },
    debrief: { links: [['doc.vanet', RES + 'scenarios/vanet/'], ['doc.regimes', DOC + 'network-regimes/']] },
    par: [{ answer: 0 }],
  },
  {
    id: '3.2', chapter: 3,
    world: { ...CITY, devices: [car(0, 0), car(4, 4), car(4, 0), car(0, 4), car(1, 2), car(3, 2), car(2, 1), car(2, 3)],
             flows: [{ src: 0, dst: 1, rate: 2, start: 3 }, { src: 2, dst: 3, rate: 2, start: 4 }] },
    budget: 160, palette: [{ class: 'rsu', cost: 40, limit: 4 }], duration: 120,
    objectives: [{ kind: 'deliver', flows: 'all', ratio: 0.3, from: 20, to: 120 }],
    stars: { budgetLeft: 40, maxNrl: 60 },
    debrief: { links: [['doc.vanet', RES + 'scenarios/vanet/'], ['AntRouterLogic::learnNeighbor', ARL]] },
    par: [{ class: 'rsu', x: 200, y: 200 }, { class: 'rsu', x: 600, y: 600 }, { class: 'rsu', x: 600, y: 200 }, { class: 'rsu', x: 200, y: 600 }],
  },
  {
    id: '3.3', chapter: 3,
    world: { ...CITY, devices: [{ class: 'rsu', x: 0, y: 400 }, { class: 'rsu', x: 800, y: 400 },
                               { class: 'bus', x: 200, y: 200, route: [[200, 200], [600, 200], [600, 600], [200, 600]] }],
             flows: [{ src: 0, dst: 1, rate: 2, start: 3 }] },
    budget: 40, palette: [{ class: 'rsu', cost: 40, limit: 1 }], duration: 150,
    objectives: [{ kind: 'deliver', flows: [0], ratio: 0.8, from: 30, to: 150 }],
    stars: { budgetLeft: 0, maxNrl: 80 },
    debrief: { links: [['doc.vanet', RES + 'scenarios/vanet/'], ['doc.antTypesRepair', DOC + 'ant-types/#repair-ants']] },
    par: [{ class: 'rsu', x: 400, y: 400 }],
  },
  {
    id: '3.4', chapter: 3,
    world: { ...CITY, devices: [car(0, 0), car(4, 4), car(4, 0), car(0, 4), car(1, 1), car(3, 3), car(1, 3), car(3, 1),
                               car(2, 2), car(2, 0), car(2, 4), car(0, 2), car(4, 2), car(1, 2), car(3, 2), car(2, 1)],
             flows: [{ src: 0, dst: 1, rate: 2, start: 3 }, { src: 2, dst: 3, rate: 2, start: 4 }] },
    budget: 200, palette: [{ class: 'rsu', cost: 40, limit: 5 }], duration: 160,
    hazards: [4, 5, 6, 7, 8, 9, 10, 11, 12, 13].map((device) => ({ at: 60, do: 'down', device })),
    objectives: [
      { kind: 'deliver', flows: 'all', ratio: 0.5, from: 10, to: 60 },
      { kind: 'deliver', flows: 'all', ratio: 0.2, from: 70, to: 160 },
    ],
    stars: { budgetLeft: 0, maxNrl: 60 },
    debrief: { links: [['doc.vanet', RES + 'scenarios/vanet/'], ['doc.regimes', DOC + 'network-regimes/']] },
    par: [{ class: 'rsu', x: 200, y: 200 }, { class: 'rsu', x: 600, y: 600 }, { class: 'rsu', x: 600, y: 200 }, { class: 'rsu', x: 200, y: 600 }, { class: 'rsu', x: 400, y: 400 }],
  },
  // --- Chapter 4: Forest (FANET, #577) --------------------------------------------
  // Canopy halves any radio below 30 m inside it. Rangers 300 m on the ground;
  // relay drones 300 m, 120 m up, on batteries.
  {
    id: '4.1', chapter: 4,
    world: { ...FOREST, zones: [canopy(120, 380), canopy(420, 680)],
             devices: [{ class: 'ranger', x: 110, y: 400 }, { class: 'ranger', x: 690, y: 400 }],
             flows: [{ src: 0, dst: 1, rate: 2, start: 3 }] },
    budget: 30, palette: [{ class: 'ranger', cost: 30, limit: 1 }], duration: 60,
    objectives: [{ kind: 'deliver', flows: [0], ratio: 0.9, from: 10, to: 60 }],
    stars: { budgetLeft: 0, maxNrl: 30 },
    debrief: { links: [['doc.fanet', RES + 'scenarios/fanet/'], ['doc.regimes', DOC + 'network-regimes/']] },
    par: [{ class: 'ranger', x: 400, y: 400 }],
  },
  {
    id: '4.2', chapter: 4,
    world: { ...FOREST, zones: [canopy(150, 650)],
             devices: [{ class: 'ranger', x: 130, y: 400 }, { class: 'ranger', x: 670, y: 400 }],
             flows: [{ src: 0, dst: 1, rate: 2, start: 3 }] },
    budget: 50, palette: [{ class: 'drone', cost: 50, limit: 1, moves: false, spec: { battery: 75 } }], duration: 120,
    objectives: [{ kind: 'deliver', flows: [0], ratio: 0.85, from: 10, to: 80 }, { kind: 'quiz', answer: 0 }],
    stars: { budgetLeft: 0, maxNrl: 30 },
    debrief: { links: [['doc.fanet', RES + 'scenarios/fanet/'], ['doc.howItWorks', DOC + 'ant-colony-routing/']] },
    par: [{ class: 'drone', x: 400, y: 400 }, { answer: 0 }],
  },
  {
    id: '4.3', chapter: 4,
    world: { ...FOREST,
             devices: [{ class: 'ranger', x: 60, y: 60 }, { class: 'ranger', x: 740, y: 740 },
                       { class: 'drone', x: 300, y: 300 }, { class: 'drone', x: 500, y: 500 }],
             flows: [{ src: 0, dst: 1, rate: 2, start: 3 }] },
    budget: 150, palette: [{ class: 'drone', cost: 50, limit: 3, moves: false }], duration: 120,
    objectives: [{ kind: 'quiz', answer: 0 }, { kind: 'deliver', flows: [0], ratio: 0.8, from: 20, to: 120 }],
    stars: { budgetLeft: 0, maxNrl: 40 },
    debrief: { links: [['doc.fanet', RES + 'scenarios/fanet/'], ['doc.antTypesRepair', DOC + 'ant-types/#repair-ants']] },
    par: [{ answer: 0 }, { class: 'drone', x: 220, y: 220 }, { class: 'drone', x: 400, y: 400 }, { class: 'drone', x: 580, y: 580 }],
  },
  {
    id: '4.4', chapter: 4,
    world: { ...FOREST, zones: [canopy(200, 560)],
             devices: [{ class: 'ranger', x: 80, y: 400 },
                       { class: 'ranger', x: 680, y: 300, route: [[680, 300], [720, 600], [640, 700], [680, 300]], speed: 1.5 }],
             flows: [{ src: 1, dst: 0, rate: 2, start: 3 }] },
    budget: 150, palette: [{ class: 'drone', cost: 50, limit: 3, moves: false }], duration: 150,
    objectives: [{ kind: 'deliver', flows: [0], ratio: 0.8, from: 20, to: 150 }],
    stars: { budgetLeft: 0, maxNrl: 40 },
    debrief: { links: [['doc.fanet', RES + 'scenarios/fanet/'], ['doc.regimes', DOC + 'network-regimes/']] },
    par: [{ class: 'drone', x: 260, y: 400 }, { class: 'drone', x: 480, y: 430 }, { class: 'drone', x: 650, y: 500 }],
  },
  // --- Chapter 5: Orbit (satellite, #578) -----------------------------------------
  // The teaching shell (8 planes x 8, 1200 km, a 120 s orbit) and ground
  // stations that see satellites 25 deg above their horizon.
  {
    id: '5.1', chapter: 5,
    world: { ...SKY, devices: [station(48.9, 2.4), station(-8.8, 13.2)], flows: [{ src: 0, dst: 1, rate: 2, start: 3 }] },
    budget: 0, palette: [], duration: 90,
    objectives: [{ kind: 'connect', flow: 0, within: 15 }, { kind: 'quiz', answer: 0 }],
    stars: { budgetLeft: 0, maxNrl: 1e9 },
    debrief: { links: [['doc.satellite', RES + 'satellite/leo-walker/'], ['doc.regimes', DOC + 'network-regimes/']] },
    par: [{ answer: 0 }],
  },
  {
    id: '5.2', chapter: 5,
    world: { ...SKY, devices: [station(40.7, -74.0), station(38.7, -9.1)], flows: [{ src: 0, dst: 1, rate: 2, start: 3 }] },
    budget: 0, palette: [], duration: 90,
    objectives: [{ kind: 'quiz', answer: 0 }, { kind: 'deliver', flows: [0], ratio: 0.3, from: 10, to: 90 }],
    stars: { budgetLeft: 0, maxNrl: 1e9 },
    debrief: { links: [['doc.satellite', RES + 'satellite/isl-grid/'], ['doc.configBeta', DOC + 'configuration/']] },
    par: [{ answer: 0 }],
  },
  {
    id: '5.3', chapter: 5,
    world: { ...SKY, devices: [station(48.9, 2.4), station(-8.8, 13.2)], flows: [{ src: 0, dst: 1, rate: 2, start: 3 }] },
    budget: 0, palette: [], duration: 120,
    hazards: [{ at: 40, do: 'cut', a: 0, b: 1 }, { at: 40, do: 'cut', a: 0, b: 8 }, { at: 40, do: 'cut', a: 1, b: 2 }],
    objectives: [{ kind: 'quiz', answer: 0 }, { kind: 'deliver', flows: [0], ratio: 0.5, from: 50, to: 120 }],
    stars: { budgetLeft: 0, maxNrl: 1e9 },
    debrief: { links: [['doc.satellite', RES + 'satellite/isl-grid/'], ['AntRouterLogic::loseNeighbor', ARL]] },
    par: [{ answer: 0 }],
  },
  {
    id: '5.4', chapter: 5,
    world: { ...SKY, devices: [station(48.9, 2.4), station(-8.8, 13.2), station(40.7, -74.0), station(-23.5, -46.6)],
             flows: [{ src: 0, dst: 1, rate: 2, start: 3 }, { src: 2, dst: 3, rate: 2, start: 4 }] },
    budget: 0, palette: [], duration: 150,
    hazards: [{ at: 60, do: 'storm', every: 10, offset: 3 }],
    objectives: [{ kind: 'quiz', answer: 0 }, { kind: 'deliver', flows: 'all', ratio: 0.3, from: 70, to: 150 }],
    stars: { budgetLeft: 0, maxNrl: 1e9 },
    debrief: { links: [['doc.satellite', RES + 'satellite/leo-walker/'], ['doc.antTypesRepair', DOC + 'ant-types/#repair-ants']] },
    par: [{ answer: 0 }],
  },
  {
    id: '5.5', chapter: 5,
    world: { ...SKY, shell: { planes: 8, slots: 8, skip: [2] },
             devices: [station(48.9, 2.4), station(-8.8, 13.2)], flows: [{ src: 0, dst: 1, rate: 2, start: 3 }] },
    budget: 0, palette: [], duration: 90,
    objectives: [{ kind: 'quiz', answer: 0 }, { kind: 'deliver', flows: [0], ratio: 0.3, from: 10, to: 90 }],
    stars: { budgetLeft: 0, maxNrl: 1e9 },
    debrief: { links: [['doc.satellite', RES + 'satellite/leo-walker/'], ['doc.regimes', DOC + 'network-regimes/']] },
    par: [{ answer: 0 }],
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
