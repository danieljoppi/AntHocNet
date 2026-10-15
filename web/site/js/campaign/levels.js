// The campaign's levels (#567 format; chapters 1 and 2, #569 and #570). Each
// level is data: the devices already there, the calls to carry, what the player
// may add, what clears it, and a par solution the level test (web/test/levels.mjs)
// plays on five seeds so no level ships impossible. Distances are metres; a link
// needs both ends in range (phone 120, laptop 180, PC 250, router 300, repeater
// 200, home gateway 150). No number here is a benchmark: the debriefs link to
// the measured pages.
const DOC = 'docs/';
const RES = 'docs/benchmarks/';
const ARL = 'api/classanthocnet_1_1core_1_1AntRouterLogic.html';
const PT = 'api/classanthocnet_1_1core_1_1PheromoneTable.html';

export const CHAPTERS = [
  { n: 1, title: 'Ad hoc town', family: 'MANET', blurb: 'Phones, laptops and PCs talking directly: no routers, no infrastructure. Every device is a router.',
    results: { href: RES + 'grid/', label: 'MANET grid results' } },
  { n: 2, title: 'Neighbourhood mesh', family: 'static Wi-Fi mesh', blurb: 'Rooftop routers for a village. Nothing moves, so what do the ants keep doing?',
    results: { href: RES + 'static-mesh/', label: 'Static mesh results' } },
];

export const LEVELS = [
  // --- Chapter 1: Ad hoc town (MANET) ------------------------------------------
  {
    id: '1.1', chapter: 1, title: 'First hello', mechanism: 'hellos and neighbour tables',
    story: 'Ana and Ben stand on opposite sides of the square, phones in hand. Their phones reach 120 m; they are 220 m apart.',
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
    hints: ['Drag Ben (the phone on the right) towards Ana until the range rings overlap.', 'Their phones hear each other within 120 m.'],
    debrief: {
      text: 'Once a second each device says hello. A device that hears a hello adds the sender to its neighbour table, with a small pheromone entry for it; two missed hellos and it forgets.',
      links: [['How AntHocNet works', DOC + 'ant-colony-routing/'], ['AntRouterLogic::learnNeighbor', ARL]],
    },
    par: [{ move: 1, x: 190, y: 125 }],
  },
  {
    id: '1.2', chapter: 1, title: 'Across the street', mechanism: 'reactive forward ants, backward ants and pheromone',
    story: 'Two houses, 340 m apart, want a video call between their desktop PCs, which reach 250 m. You have one laptop to set down in between.',
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
    hints: ['A laptop reaches 180 m, and a link needs both ends to reach.', 'Put it in the middle of the street, within 180 m of both houses.'],
    debrief: {
      text: 'The first PC had never heard of the second, so it flooded a reactive forward ant. The copy that arrived turned into a backward ant and walked the same path home, laying pheromone on each hop. Data then follows the pheromone.',
      links: [['Ant types', DOC + 'ant-types/'], ['AntRouterLogic::onDataPacket', ARL]],
    },
    par: [{ class: 'laptop', x: 250, y: 150 }],
  },
  {
    id: '1.3', chapter: 1, title: 'Follow the scent', mechanism: 'pheromone^β next-hop choice',
    story: 'A call from the school PC to the library PC can go through either of two laptops. One path has been reinforced by many backward ants; the other only by a few.',
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
      { kind: 'quiz', question: 'Most of the school\'s packets go through the laptop with more pheromone. Why "most", and not "all"?',
        options: ['Each packet picks a neighbour at random, weighted by pheromone raised to a power β, so the stronger path wins most draws, not every one',
                  'Packets alternate between the laptops to share the load',
                  'The weaker laptop is only used when the stronger one is busy'],
        answer: 0 },
      { kind: 'deliver', flows: [0], ratio: 0.9, from: 10, to: 40 },
    ],
    stars: { budgetLeft: 0, maxNrl: 30 },
    hints: ['Pheromone sets the odds; it does not make the choice alone.', 'Look at the inspector: each neighbour shows its pheromone and its share of the draws.'],
    debrief: {
      text: 'Data picks a next hop with probability proportional to its pheromone raised to β (20 for data), so a modestly better path takes almost all the traffic while the other stays known. That is how AntHocNet keeps several paths alive at little cost.',
      links: [['The ACO model', DOC + 'ant-colony-routing/'], ['PheromoneTable::nextNeighborNode', PT]],
    },
    par: [{ answer: 0 }],
  },
  {
    id: '1.4', chapter: 1, title: 'The café', mechanism: 'proactive ants and the strongest route switching',
    story: 'The café\'s PC and the bakery\'s PC talk through whoever is walking by. People wander in and out; when nobody is in the middle, the call drops.',
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
    hints: ['A desktop PC never walks away.', 'Put it midway between the two shops: 240 m from each.'],
    debrief: {
      text: 'While the call runs, proactive forward ants keep sampling the paths, so when a walker carries a better route past, the strongest route switches to it, and back when they leave. The PC you added is the path that never leaves.',
      links: [['Ant types: proactive ants', DOC + 'ant-types/'], ['MANET grid results', RES + 'grid/']],
    },
    par: [{ class: 'pc', x: 300, y: 200 }],
  },
  {
    id: '1.5', chapter: 1, title: 'Two ways home', mechanism: 'multipath and repair',
    story: 'One laptop on a bench carries the whole call between the two houses. At t = 40 s its owner closes the lid.',
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
    hints: ['Before the lid closes, give the call a second way across.', 'A PC on the other side of the street, within reach of both houses.'],
    debrief: {
      text: 'With a second path, AntHocNet keeps pheromone on both. When the laptop disappears, the houses notice within two missed hellos and the traffic already has somewhere to go; a local repair ant or a link-failure notice fixes what is left.',
      links: [['Ant types: repair and link failure', DOC + 'ant-types/'], ['AntRouterLogic::onLinkFailure', ARL]],
    },
    par: [{ class: 'pc', x: 250, y: 250 }],
  },
  {
    id: '1.6', chapter: 1, title: 'Rush hour', mechanism: 'everything above, and the cost of ants',
    story: 'Three calls cross the town square at rush hour, and a crowd of phones walks through it. You can afford three PCs, but a cheap, quiet network earns more stars.',
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
    hints: ['The three calls all cross the middle of the square.', 'Every house is within 250 m of the centre: one PC there carries all three calls.'],
    debrief: {
      text: 'Every device you add is another router sending hellos and forwarding ants, so the network\'s overhead (ants per delivered packet) grows with it. AntHocNet\'s measured trade on the MANET grid is exactly this: delivery bought with control traffic.',
      links: [['MANET grid results', RES + 'grid/'], ['Metrics: NRL', RES + 'metrics/']],
    },
    par: [{ class: 'pc', x: 260, y: 180 }],
  },

  // --- Chapter 2: Neighbourhood mesh (static Wi-Fi mesh) ---------------------------
  {
    id: '2.1', chapter: 2, title: 'Rooftops', mechanism: 'routes found once on a topology that never moves',
    story: 'Four houses want to reach the village gateway in the square. Their home gateways reach 150 m; the square is 400 m away.',
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
    hints: ['A rooftop router reaches 300 m, but a home gateway only 150 m: the router must be near each house.', 'One router near each house, each within 300 m of the square.'],
    debrief: {
      text: 'On a mesh that never moves, the first backward ants find the routes and they stay found: delivery is near perfect from the first seconds.',
      links: [['Static mesh results', RES + 'static-mesh/'], ['Network regimes', DOC + 'network-regimes/']],
    },
    par: [
      { class: 'router', x: 170, y: 140 }, { class: 'router', x: 630, y: 140 },
      { class: 'router', x: 170, y: 360 }, { class: 'router', x: 630, y: 360 },
    ],
  },
  {
    id: '2.2', chapter: 2, title: 'Does it ever go quiet?', mechanism: 'the cost of proactive sampling on stable links',
    story: 'The village mesh is wired and every route is found. Nothing moves. Watch the ant counter.',
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
      { kind: 'quiz', question: 'Every route is found and nothing moves. Do the ants stop?',
        options: ['No: hellos and proactive ants keep flying at the same rate, whether or not anything changes',
                  'Yes: once every route is found, the network goes quiet',
                  'Only the hellos stop'],
        answer: 0 },
      { kind: 'deliver', flows: 'all', ratio: 0.95, from: 10, to: 60 },
    ],
    stars: { budgetLeft: 0, maxNrl: 1e9 },
    hints: ['Count the ants in the last ten seconds against the first ten.', 'AntHocNet samples on a timer, not on change.'],
    debrief: {
      text: 'AntHocNet sends hellos every second and proactive ants every ten seconds of a session, however stable the network is. On a static mesh that is pure overhead; a quiet mode that backs off on stable links is planned for v2.3.0 (#571) and will appear here as an upgrade.',
      links: [['Static mesh results', RES + 'static-mesh/'], ['Ant types', DOC + 'ant-types/']],
    },
    par: [{ answer: 0 }],
  },
  {
    id: '2.3', chapter: 2, title: 'Storm', mechanism: 'repair on a static network',
    story: 'The mesh carries two houses\' traffic to the square through one rooftop router. At t = 30 s, lightning takes it down.',
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
    hints: ['The west house only reaches the square through the router at the top-left.', 'A second router near the west house, on the other side, keeps a path warm.'],
    debrief: {
      text: 'When the router went down, its neighbours missed its hellos and dropped it; the second path you built already had pheromone, so the traffic moved over at once instead of waiting for a new flood.',
      links: [['Static mesh results', RES + 'static-mesh/'], ['AntRouterLogic::loseNeighbor', ARL]],
    },
    par: [{ class: 'router', x: 200, y: 260 }, { class: 'repeater', x: 520, y: 200 }],
  },
  {
    id: '2.4', chapter: 2, title: 'Wire the village', mechanism: 'multipath and the overhead score',
    story: 'Six houses, one village gateway, and a budget. Every house must reach the square; the fewer ants it takes, the better.',
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
    hints: ['Each corner house needs a router within 150 m, and that router within 300 m of the square.', 'The two middle houses are close enough for a repeater each.'],
    debrief: {
      text: 'A mesh is cheapest when each device has just enough neighbours: every extra router adds hellos and ant traffic for every route through it. The measured static-mesh results show AntHocNet delivering almost everything there, and paying for it in control traffic.',
      links: [['Static mesh results', RES + 'static-mesh/'], ['Metrics: NRL', RES + 'metrics/']],
    },
    par: [
      { class: 'router', x: 190, y: 170 }, { class: 'router', x: 710, y: 170 },
      { class: 'router', x: 190, y: 430 }, { class: 'router', x: 710, y: 430 },
      { class: 'repeater', x: 450, y: 170 }, { class: 'repeater', x: 450, y: 430 },
    ],
  },
];

export const levelById = (id) => LEVELS.find((l) => l.id === id);
