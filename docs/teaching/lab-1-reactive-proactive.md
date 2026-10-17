# Lab 1 — Reactive vs proactive route maintenance

**Goal.** Explain what proactive route sampling buys and what it costs, and
why the answer depends on the network.
**Time.** 45 min. **Site.** The MANET world, seed 6, and the tuning bench.

[← Classroom pack](README.md) · [Answer key](answer-keys.md#lab-1)

## Background (5 min)

AntHocNet is a hybrid protocol. It finds a route **reactively**: when a
source has data and no route, it floods forward ants. While a session runs,
it also sends **proactive** ants every few seconds to re-sample the path, so
the route follows nodes as they move. The switch for the second part is
`enableProactive` (on by default). See [ant types](../ant-types.md).

## 1. Predict (5 min)

Write down your answers before you run anything:
1. With proactive ants off, will delivery after 60 s be higher, lower, or
   the same? By how much?
2. Will the number of ant transmissions be higher, lower, or the same?

## 2. Run (15 min)

1. Open [`#manet?seed=6`](https://danieljoppi.github.io/AntHocNet/#manet?seed=6): 30 devices on a field,
   two thirds of them moving, with three calls between them.
2. Run to **t = 60 s** (use ▶▶▶ to speed up), then pause.
3. Record `✓` (delivered / sent) and `ants` from the status bar.
4. Open **Tuning bench → Change a protocol parameter** and set
   `enableProactive` to *off*. The world restarts with the change. A faint
   ghost of the same seed runs at the defaults beside it.
5. Run to **t = 60 s** again, pause, and record `✓` and `ants`. The
   bench's table shows your run's PDR next to the ghost's.

## 3. Explain (10 min)

1. Compare your results with your prediction. Which part surprised you?
2. Proactive ants cost transmissions. On this field, what did they buy?
3. The bench's *ns-3 line* shows the same change as an `anthocnet-compare`
   flag. What does it say?

## 4. Compare with ns-3 (10 min)

[configuration.md](../configuration.md) records a 7-point sweep of the
proactive interval (#248): the paper's MANET field, 20 seeds and 900 s per
point, with full 802.11 PHY/MAC.
1. Which setting did ns-3 measure as best on the MANET field? Find it in the
   `proactiveInterval` row.
2. Why is proactive sampling still **on** by default? Hint: read the same row
   and [network-regimes.md](../network-regimes.md).
