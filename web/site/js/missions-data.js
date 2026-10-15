// The mission ladder (#546) and the world challenges (#547), as data plus a
// small `run` script each. Every score is computed from events the core and
// the adapter report; every prediction is scored against the core's own
// probabilities. No number here is a benchmark: the debriefs link to the
// measured results instead.
//
// Mission 8 and AODV (decision recorded on #546): the issue proposed beating
// AODV's delivery on the same seed. There is no AODV in the browser, and
// writing one would be a second implementation of something else, so the boss
// level scores the player's network against a delivery target instead.

import { localized, t, num } from './i18n.js';

const DOC = 'docs/';
const API = 'api/';
const PT = API + 'classanthocnet_1_1core_1_1PheromoneTable.html';
const ARL = API + 'classanthocnet_1_1core_1_1AntRouterLogic.html';

const flowStats = (w) => {
  const fs = w.flowStats();
  const out = [];
  for (let i = 0; i < fs.length; i += 5) out.push({ src: fs[i], dst: fs[i + 1], sent: fs[i + 2], delivered: fs[i + 3] });
  return out;
};
const totals = (w) => flowStats(w).reduce((a, f) => ({ sent: a.sent + f.sent, delivered: a.delivered + f.delivered }), { sent: 0, delivered: 0 });
const pct = (x) => `${num(100 * x)}%`;
const neighboursOf = (w, n, dest) => {
  const row = w.pheromone(n, dest);
  const out = [];
  for (let k = 0; k < row.length; k += 3) out.push({ nb: row[k], reg: row[k + 1] });
  return out;
};
/** Resolve once `pred()` holds (polled at 100 ms of wall time). */
const until = (ctx, pred) => new Promise((resolve) => {
  const cancel = ctx.every(100, () => { if (pred()) { cancel(); resolve(); } });
});
/** Measure a window of simulated time [t0, t1]: delivery over every flow. */
async function measure(ctx, t0, t1, label) {
  await until(ctx, () => ctx.world.now() >= t0);
  const a = totals(ctx.world);
  await new Promise((resolve) => {
    const cancel = ctx.every(200, () => {
      const now = ctx.world.now();
      ctx.progress((now - t0) / (t1 - t0), t('missions.window', { label, t: num(now, 1), t1 }));
      if (now >= t1) { cancel(); resolve(); }
    });
  });
  const b = totals(ctx.world);
  const sent = b.sent - a.sent, delivered = b.delivered - a.delivered;
  return { sent, delivered, ratio: sent ? delivered / sent : 0 };
}

// Each mission's words are in i18n/<lang>.json under mission.<id> (#622); a
// link label that is prose is a doc.* key, one that is an API name stays as is.
export const MISSIONS = [
  // --- Academy: one mechanism at a time -----------------------------------------
  {
    id: 'hello', n: 1, group: 'Academy', world: 'line', seed: 1, speed: 0.5, tool: 'move',
    links: [['doc.howItWorks', DOC + 'ant-colony-routing/'], ['AntRouterLogic::onMaintenanceTick', ARL]],
    run(ctx, Ev) {
      const pair = (e) => (e.node === 4 && e.peer === 5) || (e.node === 5 && e.peer === 4);
      ctx.progress(0, t('mission.hello.run.waiting'));
      ctx.on((e) => {
        if (e.kind === Ev.RouteDel && e.a === e.peer && pair(e) && !ctx.state.lost) {
          ctx.state.lost = true;
          ctx.progress(0.5, t('mission.hello.run.forgot'));
        } else if (ctx.state.lost && e.kind === Ev.RouteAdd && e.a === e.peer && pair(e)) {
          ctx.complete(3, t('mission.hello.run.done', { t: num(e.t, 2) }));
        }
      });
    },
  },
  {
    id: 'scouts', n: 2, group: 'Academy', world: 'line', seed: 1, speed: 0,
    links: [['doc.antTypes', DOC + 'ant-types/'], ['AntRouterLogic::onDataPacket', ARL]],
    async run(ctx, Ev) {
      const v = await ctx.ask(t('mission.scouts.run.q'), [1, 3, 5, 6].map((k) => ({ label: String(k), value: k })));
      ctx.state.right = v === 5;
      ctx.say(t(ctx.state.right ? 'mission.scouts.run.right' : 'mission.scouts.run.wrong'));
      ctx.pg.setSpeed(0.25);
      let reactive = 0;
      ctx.on((e) => {
        if (e.kind === Ev.TxAnt && e.a === 2) { reactive++; ctx.progress(Math.min(0.9, reactive / 12), t('mission.scouts.run.count', { n: reactive })); }
        if (e.kind === Ev.Deliver && e.a === 0) {
          ctx.complete(ctx.state.right ? 3 : 1, t('mission.scouts.run.done', { ms: num(e.v * 1000), n: reactive }));
        }
      });
    },
  },
  {
    id: 'way-back', n: 3, group: 'Academy', world: 'mesh', seed: 2, speed: 0,
    links: [['doc.pheromonePaper', DOC + 'fidelity/'], ['PheromoneEngine', API + 'classanthocnet_1_1core_1_1PheromoneEngine.html']],
    async run(ctx) {
      const w = ctx.world;
      w.advanceTo(1.6); // let the hellos introduce the neighbours
      ctx.pg.selectNode(0);
      ctx.pg.setWatch(24);
      const nbs = neighboursOf(w, 0, 24).map((x) => x.nb);
      const pick = await ctx.ask(t('mission.way-back.run.q'),
        nbs.map((nb) => ({ label: t('missions.node', { n: nb }), value: nb })));
      ctx.say(t('mission.way-back.run.picked', { n: pick }));
      ctx.pg.setSpeed(0.25);
      await until(ctx, () => flowStats(ctx.world)[0].delivered >= 5);
      const row = neighboursOf(ctx.world, 0, 24).sort((a, b) => b.reg - a.reg);
      const best = row[0].nb;
      ctx.complete(best === pick ? 3 : 1, t('mission.way-back.run.done', { n: best, tau: num(row[0].reg, 2) })
        + (best === pick ? '' : ' ' + t('mission.way-back.run.yours', { n: pick, tau: num(row.find((r) => r.nb === pick)?.reg || 0, 2) })));
    },
  },
  {
    id: 'scent', n: 4, group: 'Academy', world: 'mesh', seed: 3, speed: 0.5,
    links: [['doc.configBeta', DOC + 'configuration/'], ['PheromoneTable::nextHopDistribution', PT]],
    async run(ctx, Ev) {
      ctx.pg.selectNode(0);
      ctx.pg.setWatch(24);
      ctx.progress(0, t('mission.scent.run.waiting'));
      await until(ctx, () => flowStats(ctx.world)[0].delivered >= 5);
      let hits = 0, expected = 0;
      for (let round = 1; round <= 8; round++) {
        ctx.pg.setSpeed(0);
        const dist = ctx.world.distribution(0, 24, -1);
        const p = new Map();
        for (let k = 0; k < dist.length; k += 2) p.set(dist[k], dist[k + 1]);
        const options = neighboursOf(ctx.world, 0, 24).map((x) => ({ label: t('missions.node', { n: x.nb }), value: x.nb }));
        ctx.progress((round - 1) / 8, t('mission.scent.run.round', { r: round, hits }));
        const pick = await ctx.ask(t('mission.scent.run.q', { r: round }), options);
        expected += p.get(pick) || 0;
        ctx.pg.setSpeed(0.25);
        const went = await new Promise((resolve) => {
          const off = ctx.on((e) => { if (e.kind === Ev.TxData && e.node === 0 && e.a === 0) { off(); resolve(e.peer); } });
        });
        if (went === pick) hits++;
        ctx.say(t('mission.scent.run.went', { went, pw: pct(p.get(went) || 0), pick, pp: pct(p.get(pick) || 0) }));
        await new Promise((r) => setTimeout(r, 1200));
      }
      ctx.complete(hits >= 6 ? 3 : hits >= 4 ? 2 : 1, t('mission.scent.run.done', { hits, p: num(expected, 1) }));
    },
  },
  {
    id: 'two-roads', n: 5, group: 'Academy', world: 'mesh', seed: 4, speed: 1, tool: 'move',
    links: [['doc.howItWorks', DOC + 'ant-colony-routing/'], ['AntRouterLogic::nextHopForData', ARL]],
    run(ctx, Ev) {
      const seen = new Map();
      ctx.progress(0, t('mission.two-roads.run.watching'));
      ctx.on((e) => {
        if (e.kind !== Ev.TxData || e.a !== 0) return;
        const s = seen.get(e.node) || new Set();
        s.add(e.peer);
        seen.set(e.node, s);
        if (s.size >= 2) ctx.complete(3, t('mission.two-roads.run.done', { n: e.node, a: [...s][0], b: [...s][1] }));
      });
    },
  },
  {
    id: 'cut', n: 6, group: 'Academy', world: 'mesh', seed: 5, speed: 0.5, tool: 'bulldoze',
    links: [['doc.antTypesRepair', DOC + 'ant-types/'], ['AntRouterLogic::reportTxFailure', ARL]],
    run(ctx, Ev) {
      const carried = new Map();
      const f = ctx.pg.flows[0];
      ctx.progress(0, t('mission.cut.run.start'));
      ctx.on((e) => {
        if (e.kind === Ev.TxData && e.a === 0 && e.peer !== f.dst) carried.set(e.peer, e.t);
        if (e.kind === Ev.NodeDown && !ctx.state.cutAt) {
          const last = carried.get(e.node);
          if (last !== undefined && e.t - last < 2 && e.node !== f.src && e.node !== f.dst) {
            ctx.state.cutAt = e.t; ctx.state.lost = 0; ctx.state.back = null;
            ctx.progress(0.1, t('mission.cut.run.down', { n: e.node }));
          } else {
            ctx.pg.toast(t('mission.cut.run.wrong', { n: e.node }));
          }
        }
        if (ctx.state.cutAt !== undefined) {
          if (e.kind === Ev.Drop && e.a === 0) ctx.state.lost++;
          if (e.kind === Ev.Deliver && e.a === 0 && ctx.state.back === null && e.t > ctx.state.cutAt) ctx.state.back = e.t - ctx.state.cutAt;
          const el = e.t - ctx.state.cutAt;
          ctx.progress(0.1 + 0.9 * Math.min(1, el / 10), t('mission.cut.run.lost', { n: ctx.state.lost }));
          if (el >= 10) {
            const L = ctx.state.lost;
            ctx.complete(L <= 2 ? 3 : L <= 6 ? 2 : 1, ctx.state.back === null
              ? t('mission.cut.run.doneNever', { n: L })
              : t('mission.cut.run.done', { n: L, ms: num(ctx.state.back * 1000) }));
          }
        }
      });
    },
  },
  {
    id: 'fresh', n: 7, group: 'Academy', world: 'manet', seed: 6, speed: 5,
    links: [['doc.antTypesProactive', DOC + 'ant-types/'], ['AntRouterLogic::createProactiveAnts', ARL], ['doc.results', DOC + 'benchmarks/']],
    async run(ctx) {
      ctx.state.knobbed = true;
      await ctx.pg.load('manet', 6, { config: { enableProactive: 0 } });
      ctx.pg.setSpeed(5);
      ctx.pg.toast(t('mission.fresh.run.knob'), 4000);
      const ants0 = ctx.world.antTransmissions();
      const off = await measure(ctx, 0, 40, t('mission.fresh.run.off'));
      const antsOff = ctx.world.antTransmissions() - ants0;
      await ctx.pg.load('manet', 6);
      ctx.pg.setSpeed(5);
      const ants1 = ctx.world.antTransmissions();
      const on = await measure(ctx, 0, 40, t('mission.fresh.run.on'));
      const antsOn = ctx.world.antTransmissions() - ants1;
      ctx.complete(3, t('mission.fresh.run.done', { offP: pct(off.ratio), offA: antsOff, onP: pct(on.ratio), onA: antsOn }));
    },
  },
  {
    id: 'boss', n: 8, group: 'Academy', world: 'manet', seed: 7, speed: 1, tool: 'build',
    links: [['doc.manetOracle', DOC + 'benchmarks/grid/'], ['doc.methodology', DOC + 'benchmarks/methodology/']],
    async run(ctx) {
      const n0 = ctx.world.nodeCount();
      const r = await measure(ctx, 10, 70, t('missions.measuring'));
      const built = ctx.world.nodeCount() - n0;
      let score = r.ratio >= 0.95 ? 3 : r.ratio >= 0.9 ? 2 : 1;
      if (built > 4) score = 1;
      ctx.complete(score, t(built > 4 ? 'mission.boss.run.doneOver' : 'mission.boss.run.done', { p: pct(r.ratio), d: r.delivered, s: r.sent, n: built }));
    },
  },

  // --- World challenges: what is different about each family (#547) ---------------
  {
    id: 'mesh-quiet', n: 1, group: 'Worlds', world: 'mesh', seed: 8, speed: 5,
    links: [['doc.staticMesh', DOC + 'benchmarks/static-mesh/']],
    async run(ctx, Ev) {
      ctx.pg.setSpeed(0);
      const v = await ctx.ask(t('mission.mesh-quiet.run.q'), [{ label: t('mission.mesh-quiet.run.yes'), value: 'yes' }, { label: t('mission.mesh-quiet.run.no'), value: 'no' }]);
      ctx.pg.setSpeed(5);
      let ants = 0;
      ctx.on((e) => { if (e.kind === Ev.TxAnt && e.a !== 1 && e.t >= 20) ants++; });
      await measure(ctx, 20, 50, t('mission.mesh-quiet.run.counting'));
      ctx.complete(v === 'no' ? 3 : 1, t('mission.mesh-quiet.run.done', { n: ants }));
    },
  },
  {
    id: 'fanet-relay', n: 2, group: 'Worlds', world: 'fanet', seed: 9, speed: 1, tool: 'build',
    links: [['doc.fanet', DOC + 'benchmarks/scenarios/fanet/']],
    async run(ctx) {
      const n0 = ctx.world.nodeCount();
      const r = await measure(ctx, 5, 35, t('missions.measuring'));
      const built = ctx.world.nodeCount() - n0;
      let score = r.ratio >= 0.9 ? 3 : r.ratio >= 0.8 ? 2 : 1;
      if (built > 2) score = 1;
      ctx.complete(score, t('mission.fanet-relay.run.done', { p: pct(r.ratio), n: built }));
    },
  },
  {
    id: 'vanet-corner', n: 3, group: 'Worlds', world: 'vanet', seed: 10, speed: 0.5,
    links: [['doc.vanet', DOC + 'benchmarks/scenarios/vanet/']],
    run(ctx, Ev) {
      ctx.progress(0, t('mission.vanet-corner.run.waiting'));
      ctx.on(async (e) => {
        if (e.kind !== Ev.TxFail || ctx.state.asked) return;
        const pos = ctx.world.positions();
        if (pos[4 * e.peer + 3] <= 0) return;
        ctx.state.asked = true;
        ctx.pg.setSpeed(0);
        ctx.pg.selectNode(e.node);
        const d = Math.hypot(pos[4 * e.node] - pos[4 * e.peer], pos[4 * e.node + 1] - pos[4 * e.peer + 1]);
        const truth = d > ctx.world.range() ? 'far' : 'building';
        const v = await ctx.ask(t('mission.vanet-corner.run.q', { n: e.node, p: e.peer }), [
          { label: t('mission.vanet-corner.run.far'), value: 'far' }, { label: t('mission.vanet-corner.run.building'), value: 'building' }]);
        ctx.pg.setSpeed(0.5);
        ctx.complete(v === truth ? 3 : 1, t(truth === 'building' ? 'mission.vanet-corner.run.doneBuilding' : 'mission.vanet-corner.run.doneFar', { d: num(d), r: ctx.world.range() }));
      });
    },
  },
  {
    id: 'sat-failcell', n: 4, group: 'Worlds', world: 'satellite', seed: 11, speed: 0.25, tool: 'bulldoze',
    links: [['doc.satellite', DOC + 'benchmarks/satellite/isl-grid/']],
    run(ctx, Ev) {
      const used = new Map();
      ctx.progress(0, t('mission.sat-failcell.run.start'));
      ctx.on((e) => {
        if (e.kind === Ev.TxData && e.a === 0) used.set(`${Math.min(e.node, e.peer)}-${Math.max(e.node, e.peer)}`, e.t);
        if (e.type === 'cut' && ctx.state.cutAt === undefined) {
          const last = used.get(`${Math.min(e.a, e.b)}-${Math.max(e.a, e.b)}`);
          if (last !== undefined && ctx.world.now() - last < 1.5) {
            ctx.state.cutAt = ctx.world.now();
            ctx.progress(0.5, t('mission.sat-failcell.run.cut'));
          } else {
            ctx.pg.toast(t('mission.sat-failcell.run.wrong'));
          }
        }
        if (ctx.state.cutAt !== undefined && e.kind === Ev.Deliver && e.a === 0 && e.t > ctx.state.cutAt) {
          const ms = (e.t - ctx.state.cutAt) * 1000;
          ctx.complete(ms < 300 ? 3 : ms < 1000 ? 2 : 1, t('mission.sat-failcell.run.done', { ms: num(ms) }));
        }
      });
    },
  },
].map((m) => localized(m, `mission.${m.id}`, ['title', 'intro', 'goal', 'hints', 'debrief']));
