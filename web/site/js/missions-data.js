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

const DOC = '../';
const API = '../api/';
const PT = API + 'classanthocnet_1_1core_1_1PheromoneTable.html';
const ARL = API + 'classanthocnet_1_1core_1_1AntRouterLogic.html';

const flowStats = (w) => {
  const fs = w.flowStats();
  const out = [];
  for (let i = 0; i < fs.length; i += 5) out.push({ src: fs[i], dst: fs[i + 1], sent: fs[i + 2], delivered: fs[i + 3] });
  return out;
};
const totals = (w) => flowStats(w).reduce((a, f) => ({ sent: a.sent + f.sent, delivered: a.delivered + f.delivered }), { sent: 0, delivered: 0 });
const pct = (x) => `${(100 * x).toFixed(0)}%`;
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
      const t = ctx.world.now();
      ctx.progress((t - t0) / (t1 - t0), `${label}: t = ${t.toFixed(1)} of ${t1} s`);
      if (t >= t1) { cancel(); resolve(); }
    });
  });
  const b = totals(ctx.world);
  const sent = b.sent - a.sent, delivered = b.delivered - a.delivered;
  return { sent, delivered, ratio: sent ? delivered / sent : 0 };
}

export const MISSIONS = [
  // --- Academy: one mechanism at a time -----------------------------------------
  {
    id: 'hello', n: 1, group: 'Academy', title: 'Hello, neighbours', world: 'line', seed: 1, speed: 0.5, tool: 'move',
    intro: 'Every node says hello once a second. A node that misses two of a neighbour\'s hellos in a row forgets that neighbour.',
    goal: 'Drag node 5 away from node 4 until node 4 forgets it, then bring it back until they are neighbours again.',
    hints: ['The radio reaches 250 m: drag node 5 well clear of node 4.', 'Forgetting takes about two seconds of simulated time; watch the log for "lost neighbour".'],
    debrief: 'Hellos are how a node learns who it can talk to; the core seeds a small pheromone entry for every new neighbour and drops all of them when the neighbour goes quiet (ADR-0008, detector A).',
    links: [['How AntHocNet works', DOC + 'ant-colony-routing/'], ['AntRouterLogic::onMaintenanceTick', ARL]],
    run(ctx, Ev) {
      const pair = (e) => (e.node === 4 && e.peer === 5) || (e.node === 5 && e.peer === 4);
      ctx.progress(0, 'Waiting for node 4 to forget node 5…');
      ctx.on((e) => {
        if (e.kind === Ev.RouteDel && e.a === e.peer && pair(e) && !ctx.state.lost) {
          ctx.state.lost = true;
          ctx.progress(0.5, 'Node 4 forgot node 5. Now bring node 5 back.');
        } else if (ctx.state.lost && e.kind === Ev.RouteAdd && e.a === e.peer && pair(e)) {
          ctx.complete(3, `They met again at t = ${e.t.toFixed(2)} s: one hello was enough.`);
        }
      });
    },
  },
  {
    id: 'scouts', n: 2, group: 'Academy', title: 'Send the scouts', world: 'line', seed: 1, speed: 0,
    intro: 'Node 0 starts sending to node 5 at t = 2 s, but it has never heard of node 5. Before any data moves, it broadcasts a reactive forward ant, which every node rebroadcasts until one reaches node 5.',
    goal: 'Predict how many hops the successful ant travels, then watch it happen.',
    hints: ['Each node only hears its immediate neighbours.', 'Count the gaps between node 0 and node 5.'],
    debrief: 'Reactive forward ants flood outward, each remembering the path it took. The first one to arrive turns into a backward ant and walks the same path home.',
    links: [['Ant types', DOC + 'ant-types/'], ['AntRouterLogic::onDataPacket', ARL]],
    async run(ctx, Ev) {
      const v = await ctx.ask('How many hops from node 0 to node 5?', [1, 3, 5, 6].map((k) => ({ label: String(k), value: k })));
      ctx.state.right = v === 5;
      ctx.say(ctx.state.right ? 'Right. Watch the orange ants fan out.' : 'Let\'s see: watch the orange ants fan out.');
      ctx.pg.setSpeed(0.25);
      let reactive = 0;
      ctx.on((e) => {
        if (e.kind === Ev.TxAnt && e.a === 2) { reactive++; ctx.progress(Math.min(0.9, reactive / 12), `${reactive} reactive ant transmissions so far`); }
        if (e.kind === Ev.Deliver && e.a === 0) {
          ctx.complete(ctx.state.right ? 3 : 1, `It took 5 hops. The first packet arrived ${(e.v * 1000).toFixed(0)} ms after it was sent, after ${reactive} reactive ant transmissions.`);
        }
      });
    },
  },
  {
    id: 'way-back', n: 3, group: 'Academy', title: 'The way back', world: 'mesh', seed: 2, speed: 0,
    intro: 'When a forward ant reaches its destination, a backward ant retraces its path. At each hop it deposits pheromone on the link it came from, more for a faster path.',
    goal: 'Node 0 is about to look for node 24. Predict which of its neighbours ends up with the most pheromone toward node 24.',
    hints: ['Look at where node 24 is on the map.', 'Fewer hops and less queueing means more pheromone.'],
    debrief: 'The deposit is the inverse of the path\'s estimated time, averaged into the old value (γ = 0.7). Over time the best link accumulates the most.',
    links: [['Pheromone and the paper', DOC + 'fidelity/'], ['PheromoneEngine', API + 'classanthocnet_1_1core_1_1PheromoneEngine.html']],
    async run(ctx) {
      const w = ctx.world;
      w.advanceTo(1.6); // let the hellos introduce the neighbours
      ctx.pg.selectNode(0);
      ctx.pg.setWatch(24);
      const nbs = neighboursOf(w, 0, 24).map((x) => x.nb);
      const pick = await ctx.ask('Which neighbour of node 0 will carry the most pheromone toward node 24?',
        nbs.map((nb) => ({ label: `node ${nb}`, value: nb })));
      ctx.say(`You picked node ${pick}. Watch the blue trail grow from node 0.`);
      ctx.pg.setSpeed(0.25);
      await until(ctx, () => flowStats(ctx.world)[0].delivered >= 5);
      const row = neighboursOf(ctx.world, 0, 24).sort((a, b) => b.reg - a.reg);
      const best = row[0].nb;
      ctx.complete(best === pick ? 3 : 1, `Node ${best} holds the most (τ = ${row[0].reg.toFixed(2)}).${best === pick ? '' : ` Node ${pick} holds ${(row.find((r) => r.nb === pick)?.reg || 0).toFixed(2)}.`}`);
    },
  },
  {
    id: 'scent', n: 4, group: 'Academy', title: 'Follow the scent', world: 'mesh', seed: 3, speed: 0.5,
    intro: 'A data packet does not follow one fixed route. Each node picks a next hop at random, weighted by pheromone raised to the power β = 20, so the best trail wins most of the time, but not always.',
    goal: 'Predict node 0\'s next hop for eight data packets. You score against the core\'s own probabilities.',
    hints: ['Use Inspect on node 0: its table shows the exact probability of each choice.', 'Picking the most likely neighbour every time is the best strategy, but even that can miss.'],
    debrief: 'This is the stochastic routing rule (the paper\'s Eq. 1). The power β = 20 makes it nearly greedy; a smaller β would spread traffic more evenly across paths.',
    links: [['Configuration: β', DOC + 'configuration/'], ['PheromoneTable::nextHopDistribution', PT]],
    async run(ctx, Ev) {
      ctx.pg.selectNode(0);
      ctx.pg.setWatch(24);
      ctx.progress(0, 'Waiting for the route to form…');
      await until(ctx, () => flowStats(ctx.world)[0].delivered >= 5);
      let hits = 0, expected = 0;
      for (let round = 1; round <= 8; round++) {
        ctx.pg.setSpeed(0);
        const dist = ctx.world.distribution(0, 24, -1);
        const p = new Map();
        for (let k = 0; k < dist.length; k += 2) p.set(dist[k], dist[k + 1]);
        const options = neighboursOf(ctx.world, 0, 24).map((x) => ({ label: `node ${x.nb}`, value: x.nb }));
        ctx.progress((round - 1) / 8, `Round ${round} of 8: ${hits} right so far`);
        const pick = await ctx.ask(`Packet ${round}: where will node 0 send it?`, options);
        expected += p.get(pick) || 0;
        ctx.pg.setSpeed(0.25);
        const went = await new Promise((resolve) => {
          const off = ctx.on((e) => { if (e.kind === Ev.TxData && e.node === 0 && e.a === 0) { off(); resolve(e.peer); } });
        });
        if (went === pick) hits++;
        ctx.say(`It went to node ${went} (p = ${pct(p.get(went) || 0)}). You picked node ${pick} (p = ${pct(p.get(pick) || 0)}).`);
        await new Promise((r) => setTimeout(r, 1200));
      }
      ctx.complete(hits >= 6 ? 3 : hits >= 4 ? 2 : 1, `${hits} of 8 right. Your picks' combined probability was ${expected.toFixed(1)} of a possible 8.`);
    },
  },
  {
    id: 'two-roads', n: 5, group: 'Academy', title: 'Two roads', world: 'mesh', seed: 4, speed: 1, tool: 'move',
    intro: 'Because the choice is random, traffic can split over several paths at once. That is multipath routing, and it is AntHocNet\'s headline feature.',
    goal: 'Catch any node sending flow 0\'s packets to two different neighbours.',
    hints: ['Splits happen where two links have similar pheromone.', 'Drag a node so two paths are equally short.'],
    debrief: 'Multipath spreads load and gives a ready backup when a link breaks. The core only keeps a second path if its ants were nearly as good (the acceptance factor, #96).',
    links: [['How AntHocNet works', DOC + 'ant-colony-routing/'], ['AntRouterLogic::nextHopForData', ARL]],
    run(ctx, Ev) {
      const seen = new Map();
      ctx.progress(0, 'Watching every hop of flow 0…');
      ctx.on((e) => {
        if (e.kind !== Ev.TxData || e.a !== 0) return;
        const s = seen.get(e.node) || new Set();
        s.add(e.peer);
        seen.set(e.node, s);
        if (s.size >= 2) ctx.complete(3, `Node ${e.node} has sent flow 0 to nodes ${[...s].join(' and ')}: two roads at once.`);
      });
    },
  },
  {
    id: 'cut', n: 6, group: 'Academy', title: 'Cut the cable', world: 'mesh', seed: 5, speed: 0.5, tool: 'bulldoze',
    intro: 'Links break. The node that notices sends a link-failure notice, and repair ants look for another way while held packets wait.',
    goal: 'Bulldoze a node that is carrying flow 0, then see how many packets the network loses in the next 10 s.',
    hints: ['Watch for the purple crates of flow 0 and pick a node in the middle of their path.', 'Fewer losses earn more stars; luck in where you cut matters too.'],
    debrief: 'Local repair and multipath keep losses low: often a second trail already exists, and the packets switch to it within a hello period.',
    links: [['Ant types: repair and link failure', DOC + 'ant-types/'], ['AntRouterLogic::reportTxFailure', ARL]],
    run(ctx, Ev) {
      const carried = new Map();
      const f = ctx.pg.flows[0];
      ctx.progress(0, 'Bulldoze a node on flow 0\'s path.');
      ctx.on((e) => {
        if (e.kind === Ev.TxData && e.a === 0 && e.peer !== f.dst) carried.set(e.peer, e.t);
        if (e.kind === Ev.NodeDown && !ctx.state.cutAt) {
          const last = carried.get(e.node);
          if (last !== undefined && e.t - last < 2 && e.node !== f.src && e.node !== f.dst) {
            ctx.state.cutAt = e.t; ctx.state.lost = 0; ctx.state.back = null;
            ctx.progress(0.1, `Node ${e.node} is down. Counting losses for 10 s…`);
          } else {
            ctx.pg.toast(`Node ${e.node} was not carrying flow 0. Bulldoze it again to switch it back on, then pick another.`);
          }
        }
        if (ctx.state.cutAt !== undefined) {
          if (e.kind === Ev.Drop && e.a === 0) ctx.state.lost++;
          if (e.kind === Ev.Deliver && e.a === 0 && ctx.state.back === null && e.t > ctx.state.cutAt) ctx.state.back = e.t - ctx.state.cutAt;
          const el = e.t - ctx.state.cutAt;
          ctx.progress(0.1 + 0.9 * Math.min(1, el / 10), `${ctx.state.lost} packet(s) lost so far`);
          if (el >= 10) {
            const L = ctx.state.lost;
            ctx.complete(L <= 2 ? 3 : L <= 6 ? 2 : 1, `Flow 0 lost ${L} packet(s); the next delivery came ${ctx.state.back === null ? 'never (the flow is cut off)' : `${(ctx.state.back * 1000).toFixed(0)} ms`} after the cut.`);
          }
        }
      });
    },
  },
  {
    id: 'fresh', n: 7, group: 'Academy', title: 'Keep it fresh', world: 'manet', seed: 6, speed: 5,
    intro: 'Proactive ants re-check a route while it is in use, so the trail follows the nodes as they move. This mission turns them off for one run (a labelled mission knob) and compares.',
    goal: 'Watch 40 s with proactive ants off, then 40 s with them on.',
    hints: ['Just watch: the mission runs both halves for you.'],
    debrief: 'Proactive sampling costs ants, but on a moving network it finds better routes before the old ones break. On the teaching radio the difference is small and seed-dependent; the measured ablations are on the results pages.',
    links: [['Ant types: proactive', DOC + 'ant-types/'], ['AntRouterLogic::createProactiveAnts', ARL], ['Measured results', DOC + 'benchmarks/']],
    async run(ctx) {
      ctx.state.knobbed = true;
      await ctx.pg.load('manet', 6, { config: { enableProactive: 0 } });
      ctx.pg.setSpeed(5);
      ctx.pg.toast('Mission knob: enableProactive = 0 for this half.', 4000);
      const ants0 = ctx.world.antTransmissions();
      const off = await measure(ctx, 0, 40, 'Proactive off');
      const antsOff = ctx.world.antTransmissions() - ants0;
      await ctx.pg.load('manet', 6);
      ctx.pg.setSpeed(5);
      const ants1 = ctx.world.antTransmissions();
      const on = await measure(ctx, 0, 40, 'Proactive on (default)');
      const antsOn = ctx.world.antTransmissions() - ants1;
      ctx.complete(3, `Off: ${pct(off.ratio)} delivered, ${antsOff} ant transmissions. On: ${pct(on.ratio)} delivered, ${antsOn} ant transmissions. Same seed, same movement.`);
    },
  },
  {
    id: 'boss', n: 8, group: 'Academy', title: 'Run the city', world: 'manet', seed: 7, speed: 1, tool: 'build',
    intro: 'Three flows cross a moving network that is not always connected. You are the network planner.',
    goal: 'From t = 10 s to t = 70 s, deliver at least 95% of all packets. You may build up to 4 towers.',
    hints: ['Watch where packets are dropped (✕) and build a tower to bridge that gap.', 'A tower in a crowded middle area helps every flow.'],
    debrief: 'Partitions, not routing, cap delivery on sparse mobile networks: no protocol can cross a gap with no radio in it. That is why the measured results include an oracle that knows the whole topology.',
    links: [['MANET results with the oracle', DOC + 'benchmarks/grid/'], ['Methodology', DOC + 'benchmarks/methodology/']],
    async run(ctx) {
      const n0 = ctx.world.nodeCount();
      const r = await measure(ctx, 10, 70, 'Measuring');
      const built = ctx.world.nodeCount() - n0;
      let score = r.ratio >= 0.95 ? 3 : r.ratio >= 0.9 ? 2 : 1;
      if (built > 4) score = 1;
      ctx.complete(score, `${pct(r.ratio)} delivered (${r.delivered} of ${r.sent}) with ${built} tower(s) built${built > 4 ? ' — over the limit of 4' : ''}.`);
    },
  },

  // --- World challenges: what is different about each family (#547) ---------------
  {
    id: 'mesh-quiet', n: 1, group: 'World challenges', title: 'Mesh: does it ever go quiet?', world: 'mesh', seed: 8, speed: 5,
    intro: 'In a static mesh nothing moves and no link ever breaks.',
    goal: 'Once every route is found, does AntHocNet stop sending ants?',
    hints: ['Proactive ants run on a timer while data flows.'],
    debrief: 'No: proactive ants and hellos keep sampling links that will never change. On the measured static mesh that is why OLSR and DSDV edge out AntHocNet, with lower overhead.',
    links: [['Static mesh results', DOC + 'benchmarks/static-mesh/']],
    async run(ctx, Ev) {
      ctx.pg.setSpeed(0);
      const v = await ctx.ask('Will the ants stop once the routes are found?', [{ label: 'Yes, nothing changes', value: 'yes' }, { label: 'No, they keep sampling', value: 'no' }]);
      ctx.pg.setSpeed(5);
      let ants = 0;
      ctx.on((e) => { if (e.kind === Ev.TxAnt && e.a !== 1 && e.t >= 20) ants++; });
      await measure(ctx, 20, 50, 'Counting ants after t = 20 s');
      ctx.complete(v === 'no' ? 3 : 1, `From t = 20 to 50 s, with every route long established: ${ants} ant transmissions (not counting hellos).`);
    },
  },
  {
    id: 'fanet-relay', n: 2, group: 'World challenges', title: 'FANET: faster than the tables', world: 'fanet', seed: 9, speed: 1, tool: 'build',
    intro: 'Drones at 20 m/s keep links for seconds, not minutes.',
    goal: 'Keep delivery at 80% or more from t = 5 to t = 35 s. You may launch up to 2 relay drones.',
    hints: ['Launch relays where the swarm thins out between a source and its destination.'],
    debrief: 'Fast, three-dimensional movement is where AntHocNet measured strongest: its ants re-sample faster than a table protocol\'s update cycle, and OLSR\'s delivery collapses.',
    links: [['FANET results', DOC + 'benchmarks/scenarios/fanet/']],
    async run(ctx) {
      const n0 = ctx.world.nodeCount();
      const r = await measure(ctx, 5, 35, 'Measuring');
      const built = ctx.world.nodeCount() - n0;
      let score = r.ratio >= 0.9 ? 3 : r.ratio >= 0.8 ? 2 : 1;
      if (built > 2) score = 1;
      ctx.complete(score, `${pct(r.ratio)} delivered with ${built} relay(s).`);
    },
  },
  {
    id: 'vanet-corner', n: 3, group: 'World challenges', title: 'VANET: around the corner', world: 'vanet', seed: 10, speed: 0.5,
    intro: 'Buildings block the radio. Two cars a block apart can be well within range and still unable to hear each other.',
    goal: 'Wait for a transmission to fail, then say why it failed.',
    hints: ['Look at whether a building stands between the two cars.'],
    debrief: 'On the street grid, links die at corners, not at the edge of radio range. That is why AntHocNet loses so much traffic to reconvergence there (#537), and why its overhead advantage reverses.',
    links: [['VANET results', DOC + 'benchmarks/scenarios/vanet/']],
    run(ctx, Ev) {
      ctx.progress(0, 'Waiting for a failed transmission…');
      ctx.on(async (e) => {
        if (e.kind !== Ev.TxFail || ctx.state.asked) return;
        const pos = ctx.world.positions();
        if (pos[4 * e.peer + 3] <= 0) return;
        ctx.state.asked = true;
        ctx.pg.setSpeed(0);
        ctx.pg.selectNode(e.node);
        const d = Math.hypot(pos[4 * e.node] - pos[4 * e.peer], pos[4 * e.node + 1] - pos[4 * e.peer + 1]);
        const truth = d > ctx.world.range() ? 'far' : 'building';
        const v = await ctx.ask(`Node ${e.node} just failed to reach node ${e.peer}. Why?`, [
          { label: 'They drove too far apart', value: 'far' }, { label: 'A building is in the way', value: 'building' }]);
        ctx.pg.setSpeed(0.5);
        ctx.complete(v === truth ? 3 : 1, `They were ${d.toFixed(0)} m apart with a ${ctx.world.range()} m radio: ${truth === 'building' ? 'in range, so a building cut the link' : 'simply out of range'}.`);
      });
    },
  },
  {
    id: 'sat-failcell', n: 4, group: 'World challenges', title: 'Satellites: the failed link', world: 'satellite', seed: 11, speed: 0.25, tool: 'bulldoze',
    intro: 'Inter-satellite links are fixed and predictable, until one fails.',
    goal: 'Cut an inter-satellite link that flow 0 is using, and time how long until its packets get through again.',
    hints: ['Watch flow 0\'s purple crates, then click the link they ride with Bulldoze.'],
    debrief: 'On the measured ISL grid AntHocNet re-converges in about 0.125 s, within 11 ms of an oracle that knows the topology instantly.',
    links: [['Satellite results', DOC + 'benchmarks/satellite/isl-grid/']],
    run(ctx, Ev) {
      const used = new Map();
      ctx.progress(0, 'Cut a link flow 0 is using.');
      ctx.on((e) => {
        if (e.kind === Ev.TxData && e.a === 0) used.set(`${Math.min(e.node, e.peer)}-${Math.max(e.node, e.peer)}`, e.t);
        if (e.type === 'cut' && ctx.state.cutAt === undefined) {
          const last = used.get(`${Math.min(e.a, e.b)}-${Math.max(e.a, e.b)}`);
          if (last !== undefined && ctx.world.now() - last < 1.5) {
            ctx.state.cutAt = ctx.world.now();
            ctx.progress(0.5, 'Link cut. Timing the recovery…');
          } else {
            ctx.pg.toast('Flow 0 was not using that link. Try one its packets ride.');
          }
        }
        if (ctx.state.cutAt !== undefined && e.kind === Ev.Deliver && e.a === 0 && e.t > ctx.state.cutAt) {
          const ms = (e.t - ctx.state.cutAt) * 1000;
          ctx.complete(ms < 300 ? 3 : ms < 1000 ? 2 : 1, `Flow 0 was delivering again ${ms.toFixed(0)} ms after the cut.`);
        }
      });
    },
  },
];
