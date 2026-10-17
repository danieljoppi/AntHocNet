// The Nest (#635): the core's API as an ant-nest cross-section. Adapters on
// the surface, the ports of ports.h as tunnels, the components as chambers.
// Every public class/struct in core/include/anthocnet/core must appear in
// exactly one chamber -- tools/checks/check-site-links.py enforces it, so the
// map cannot fall behind the code. `events` names which event kinds from the
// running world light a chamber up (engine.js Ev): activity, not a profiler.
import { localized } from './i18n.js';

// Titles and blurbs are i18n keys nest.surface.<id> / nest.chamber.<id> (#622).
export const SURFACE = [
  { id: 'ns3', cls: 'ns3::anthocnet::RoutingProtocol', x: 210, y: 36 },
  { id: 'web', cls: 'ahn_web::World', x: 738, y: 36 },
].map((x) => localized(x, `nest.surface.${x.id}`, ['title']));

export const CHAMBERS = [
  {
    id: 'tunnels', x: 474, y: 128, rx: 290, ry: 30,
    classes: ['IClock', 'IRng', 'ITimerScheduler', 'INeighborProvider', 'ILinkState', 'ILinkQuality', 'IKinematics', 'IRouterObserver'],
    events: ['TxAnt', 'RxAnt'],
  },
  {
    id: 'queen', x: 474, y: 250, rx: 180, ry: 56,
    classes: ['AntRouterLogic', 'RouteDecision'],
    events: ['TxData', 'Deliver', 'Drop'],
  },
  {
    id: 'store', x: 474, y: 420, rx: 160, ry: 52,
    classes: ['PheromoneTable', 'PheromoneEngine'],
    events: ['RouteAdd', 'RouteDel'],
    live: true,
  },
  {
    id: 'gate', x: 196, y: 448, rx: 140, ry: 48,
    classes: ['AntMessage', 'AntHop', 'HelloDest', 'Kinematics'],
    events: ['TxAnt'],
  },
  {
    id: 'senses', x: 752, y: 448, rx: 140, ry: 48,
    classes: ['ILinkMetric', 'ClassicMetric', 'SinrMetric', 'LinkObservation'],
    events: ['RxAnt'],
  },
  {
    id: 'memory', x: 474, y: 604, rx: 160, ry: 46,
    classes: ['AntHistoryTracker', 'GenerationTracker'],
    events: ['RxAnt'],
  },
  {
    id: 'rules', x: 190, y: 640, rx: 120, ry: 42,
    classes: ['Config'],
    events: [],
  },
  {
    id: 'map', x: 770, y: 640, rx: 120, ry: 42,
    classes: ['ShortestPathGraph'],
    events: [],
  },
].map((x) => localized(x, `nest.chamber.${x.id}`, ['title', 'blurb']));
