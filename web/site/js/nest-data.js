// The Nest (#635): the core's API as an ant-nest cross-section. Adapters on
// the surface, the ports of ports.h as tunnels, the components as chambers.
// Every public class/struct in core/include/anthocnet/core must appear in
// exactly one chamber -- tools/checks/check-site-links.py enforces it, so the
// map cannot fall behind the code. `events` names which event kinds from the
// running world light a chamber up (engine.js Ev): activity, not a profiler.
export const SURFACE = [
  { id: 'ns3', title: 'ns-3 module', cls: 'ns3::anthocnet::RoutingProtocol', x: 210, y: 36 },
  { id: 'web', title: 'Browser adapter (this game)', cls: 'ahn_web::World', x: 738, y: 36 },
];

export const CHAMBERS = [
  {
    id: 'tunnels', title: 'Tunnels: the ports', x: 474, y: 128, rx: 290, ry: 30,
    classes: ['IClock', 'IRng', 'ITimerScheduler', 'INeighborProvider', 'ILinkState', 'IRouterObserver'],
    blurb: 'Everything the core needs from a simulator, as small interfaces in ports.h: a clock, a random source, timers, the neighbour list, link state and an observer. An adapter implements them; the core never includes a simulator header.',
    events: ['TxAnt', 'RxAnt'],
  },
  {
    id: 'queen', title: 'Queen chamber', x: 474, y: 250, rx: 180, ry: 56,
    classes: ['AntRouterLogic', 'RouteDecision'],
    blurb: 'The protocol: every ant and every data packet goes through AntRouterLogic, which returns a RouteDecision (send, broadcast, drop, deliver) for the adapter to carry out. Pure logic, no I/O.',
    events: ['TxData', 'Deliver', 'Drop'],
  },
  {
    id: 'store', title: 'Pheromone store', x: 474, y: 420, rx: 160, ry: 52,
    classes: ['PheromoneTable', 'PheromoneEngine'],
    blurb: 'Each node\'s routing state: regular and virtual pheromone per (neighbour, destination), and the rules that deposit, diffuse and evaporate it.',
    events: ['RouteAdd', 'RouteDel'],
    live: true,
  },
  {
    id: 'gate', title: 'The gate', x: 196, y: 448, rx: 140, ry: 48,
    classes: ['AntMessage', 'AntHop', 'HelloDest'],
    blurb: 'What goes on the air: an ant as a plain value type, serialized by the codec into the canonical wire format (wire-format.md).',
    events: ['TxAnt'],
  },
  {
    id: 'senses', title: 'Senses', x: 752, y: 448, rx: 140, ry: 48,
    classes: ['ILinkMetric', 'ClassicMetric', 'LinkObservation'],
    blurb: 'How a link is judged: the metric registry and the classic hop + time metric the paper uses.',
    events: ['RxAnt'],
  },
  {
    id: 'memory', title: 'Memory', x: 474, y: 604, rx: 160, ry: 46,
    classes: ['AntHistoryTracker', 'GenerationTracker'],
    blurb: 'Which ants a node has already seen, so a flood stops and old generations are ignored.',
    events: ['RxAnt'],
  },
  {
    id: 'rules', title: 'Rule stone', x: 190, y: 640, rx: 120, ry: 42,
    classes: ['Config'],
    blurb: 'Every tunable with its default; each one\'s provenance is on the configuration page.',
    events: [],
  },
  {
    id: 'map', title: 'Map room', x: 770, y: 640, rx: 120, ry: 42,
    classes: ['ShortestPathGraph'],
    blurb: 'The shortest-path layer the oracle control is built on (a bound, not a competitor).',
    events: [],
  },
];
