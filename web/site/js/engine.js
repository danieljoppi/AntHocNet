// The WebAssembly core and the vocabulary of its event log (#544, #545).
// The numeric codes mirror web/include/ahn_web/sim.h (Ev, DropReason) and
// core/include/anthocnet/core/ant_message.h (AntType, AntDirection).
import createAntHocNet from '../anthocnet.js';

export const Ev = Object.freeze({
  TxAnt: 1, RxAnt: 2, TxData: 3, Deliver: 4, Drop: 5, RouteAdd: 6,
  RouteDel: 7, Queue: 8, TxFail: 9, NodeDown: 10, NodeUp: 11,
});
export const AntType = Object.freeze({ Hello: 1, Reactive: 2, Proactive: 4, Repair: 8, LinkFail: 16 });
export const Dir = Object.freeze({ Forward: 17, Backward: 18 });
/** Drop reason code -> its i18n key (the text is in i18n/<lang>.json). */
export const DropReason = Object.freeze({
  1: 'engine.drop.1', 2: 'engine.drop.2', 3: 'engine.drop.3', 4: 'engine.drop.4', 5: 'engine.drop.5',
});

/** Which glyph/colour family an ant transmission belongs to. */
export function antKind(type, dir) {
  if (type === AntType.Hello) return 'hello';
  if (type === AntType.LinkFail) return 'linkfail';
  if (dir === Dir.Backward) return 'backward';
  if (type === AntType.Proactive) return 'proactive';
  if (type === AntType.Repair) return 'repair';
  return 'reactive';
}

let modulePromise = null;
/** The compiled core, loaded once. */
export function engine() {
  if (!modulePromise) modulePromise = createAntHocNet();
  return modulePromise;
}

/** Flat Float64Array event log -> objects. */
export function* events(flat) {
  for (let i = 0; i < flat.length; i += 7) {
    yield { t: flat[i], kind: flat[i + 1], node: flat[i + 2], peer: flat[i + 3],
            a: flat[i + 4], b: flat[i + 5], v: flat[i + 6] };
  }
}
