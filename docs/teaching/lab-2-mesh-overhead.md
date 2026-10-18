# Lab 2 — Why a static mesh costs more control traffic than OLSR

**Goal.** Measure routing overhead as *ants per delivered packet*. Explain
why a protocol built for change keeps paying for it on a network that does
not change. Switch off the mechanism that backs off, and measure what it saves.
**Time.** 45 min. **Site.** The mesh world, seed 8, and the tuning bench.

[← Classroom pack](README.md) · [Answer key](answer-keys.md#lab-2)

## Background (5 min)

**Normalized routing load (NRL)** counts control transmissions per delivered
data packet. On the ns-3 static mesh, OLSR delivers 99.82 % at NRL 1.78.
AntHocNet delivers 99.34 % at NRL 4.51 ([static-mesh.md](../benchmarks/static-mesh.md)).
AntHocNet keeps sampling routes that never change. **Quiet mode**
(`enableQuietMode`, [#571](https://github.com/danieljoppi/AntHocNet/issues/571))
backs proactive ants off while a destination's best route stays the same.
It is on by default since v2.3.0. Before that, every route was probed every
10 s whether or not anything changed.

## 1. Predict (5 min)

1. In the browser mesh, about how many ant transmissions per delivered
   packet do you expect after 120 s: under 1, about 5, or over 20?
2. With quiet mode switched off, will that number rise? Will delivery change?

## 2. Run (15 min)

1. Open [`#mesh?seed=8`](https://danieljoppi.github.io/AntHocNet/#mesh?seed=8): rooftop routers that never
   move.
2. Run to **t = 120 s** and pause. Record `✓` and `ants`, then compute
   ants ÷ delivered. This is the default: quiet mode on.
3. In the tuning bench, set `enableQuietMode` to *off*. Run to **t = 120 s**
   again and record the same numbers.

## 3. Explain (10 min)

1. By what fraction does quiet mode cut ants per packet (off → on)? Did delivery change?
2. Quiet mode backs off only while a route stays the same. What would
   happen on a network where routes keep changing?
3. Quiet mode still sends **some** proactive ants. Why not stop them all?

## 4. Compare with ns-3 (10 min)

The v2.3.0 campaign measured quiet mode on every network family, paired per
seed against the v2.2.0 defaults ([v2.3.0-campaign.md](../benchmarks/v2.3.0-campaign.md#results)),
and its result moved the default on. Find the static-mesh row, and say
whether quiet mode closed the gap to OLSR's NRL.
