# Answer keys

For teachers. Every number here was measured by
[`web/test/labs.mjs`](https://github.com/danieljoppi/AntHocNet/blob/main/web/test/labs.mjs)
on the site's WebAssembly core, at the seed each sheet names. A student who
pauses a second early or late sees the last digit move, not the answer.

[← Classroom pack](README.md)

## Lab 1

[Sheet](lab-1-reactive-proactive.md). MANET world, seed 6, at t = 60 s.

| run | delivered | ant transmissions |
|---|---|---|
| defaults (proactive on) | 89.0 % | 5559 |
| `enableProactive` off | 89.0 % | 5210 |

- **Prediction 1:** delivery is the same. Most students predict a drop.
  That surprise is the lesson.
- **Prediction 2:** proactive ants cost about 6 % more transmissions here
  (5559 vs 5210).
- **Explain 2:** on this field and seed, nothing measurable. The reactive
  repair (link-failure notices and repair ants) already keeps up with
  walking-to-cycling speeds on the teaching radio.
- **Explain 3:** `--ns3::anthocnet::RoutingProtocol::EnableProactive=false`.
- **Compare 1:** proactive **off** is the measured MANET optimum: 97.2 % PDR
  at NRL 31.73, against 94.9 % / 40.51 at the 10 s default (#248).
- **Compare 2:** the default must serve every regime. On satellite
  constellations, sampling is what tracks the scheduled link changes (#192).
  A regime-specific setting is a configuration choice, not a new default
  ([network-regimes.md](../network-regimes.md)).

## Lab 2

[Sheet](lab-2-mesh-overhead.md). Mesh world, seed 8, at t = 120 s.

| run | delivered | ants per delivered packet |
|---|---|---|
| defaults | 99.6 % | 5.21 |
| `enableQuietMode` on | 99.6 % | 5.09 |

- **Prediction 1:** about 5, close to the ns-3 static mesh's 4.51.
- **Explain 1:** about 2 % fewer ants per packet in 120 s, with delivery
  unchanged. The saving is small because hellos and the initial route
  discovery dominate a short run. Quiet mode only thins the proactive
  share, and only once a route has held for a few rounds.
- **Explain 2:** it rarely engages. Every route change resets the back-off.
- **Explain 3:** a fully silent node would only notice a better route, or a
  failure the hellos miss, when data is lost. The back-off is capped (8
  rounds) so sampling never stops.
- **Compare:** fill this in from the campaign's static-mesh row once it is
  published. Until then, "pending" is the correct answer.

## Lab 3

[Sheet](lab-3-vanet-reconvergence.md). Campaign level 3.4, seed 1.
Delivery of all calls per 10-s interval, 0–160 s:

| run | 0–60 s, per 10 s | 60–160 s, per 10 s | mean 10–60 s | mean after 60 s |
|---|---|---|---|---|
| no roadside units | 0 0 0 23 0 50 | 30 0 3 5 50 8 0 0 0 0 | 14.5 % | 9.5 % |
| five units (par) | 0 33 50 73 90 100 | 100 23 40 50 85 57 0 0 35 5 | 69.0 % | 39.5 % |

- **3.1 quiz:** the buildings on the corner block the line of sight. The
  cars are still within range.
- **Explain 2:** the units never move, so a car's link to one lasts as long
  as the car is on one of that unit's two streets. That gives the ants
  stable anchors.
- **Explain 3:** after 60 s only six cars remain. Some calls' endpoints are
  out of reach of every unit for long stretches, so no route exists at all.
  The `0 0` intervals are partitions, not routing failures.
- **Compare 1:** reconvergence. Routes break at corners faster than new ones
  are found and confirmed. 36 % of all traffic is lost to it on the ns-3
  cell ([vanet.md](../benchmarks/scenarios/vanet.md)).
- **Compare 2:** a corner break is not a distance event. The two cars can be
  approaching each other when a building cuts the link. A predictor that
  sees only position and velocity predicts a long-lived link. That is the
  hypothesis recorded on #574 after its screen.

## Lab 4

[Sheet](lab-4-satellite-handover.md). Campaign level 5.3, seed 1. Delivery
per 10-s interval, 0–120 s:

| run | per 10 s |
|---|---|
| the level (3 links cut at 40 s) | 60 75 65 45 70 60 40 75 70 45 75 65 |
| the same run, nothing cut | 60 75 65 45 75 70 40 75 65 45 75 70 |

- **5.1 quiz:** each satellite sinks below 25°, and the station hands over
  to the next one rising.
- **Prediction 1 and Explain 1:** periodic. After the first interval the
  pattern repeats every **60 s**, half the 120 s orbit. Halfway round, every
  satellite has moved to where its counterpart on the far side of the plane
  was, so the geometry the stations see repeats.
- **Explain 2:** about 20 s: the cut costs 5–10 points in the 40–60 s
  intervals. The node at the cut learns of it from its failed sends, and its link-failure notices tell the nodes upstream. The ants then
  re-weight the trails through the parallel paths, which already carry
  pheromone. After 70 s delivery is within 5 points of the uncut run.
- **Explain 3:** usually several. Between two satellites *a* planes and *b*
  slots apart, there are C(a + b, a) shortest staircase paths. Repair is a
  choice among paths the ants already know, not a new discovery.
- **5.3 quiz:** it pauses briefly, then the ants find another path through
  the grid.
- **Compare 1:** OLSR learns of the failure through periodic topology
  control messages, then recomputes. Its reconvergence is paced by those
  intervals, not by the link.
- **Compare 2:** the interface-down fast path. When a point-to-point ISL
  fails, its interface goes down, and the adapter reports the neighbour lost
  at that instant.

## Lab 5

[Sheet](lab-5-multipath.md). Mesh world, seed 4, at t = 120 s. The first
call's source, data packets per next hop:

| `betaData` | next hops used | share of the busiest |
|---|---|---|
| 1 | 3 | 94.5 % |
| 20 (default) | 1 | 100 % |
| 30 | 1 | 100 % |

- **Predictions:** at β = 1 the source spreads, but only a little. One trail
  is far stronger than the others, and τ¹ still favours it. At 20 and 30,
  it uses one next hop.
- **Explain 2:** more paths spread load and survive a single failure. The
  cost is packets arriving out of order and some taking longer paths, so
  delay and its tail grow.
- **Explain 3:** the thesis favours delay and in-order delivery. Multipath
  stays available, and the forwarding rule uses it when trails are close in
  strength.
- **Compare:** `heavy-load`, on delay99: −192.50 ms [−210.65, −174.40] when
  β₃ = 20 was adopted (#179).
