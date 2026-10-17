# Lab 4 — Satellites: handover and a failed link

**Goal.** See how a constellation's links change on a schedule, and how ant
routing repairs a failure on a regular grid.
**Time.** 60 min. **Site.** Campaign levels 5.1 and 5.3
([`#campaign?open=all`](https://danieljoppi.github.io/AntHocNet/#campaign?open=all)).

[← Classroom pack](README.md) · [Answer key](answer-keys.md#lab-4)

## Background (5 min)

In a low-Earth-orbit shell, each satellite links to four neighbours: two in
its own orbital plane and one in each adjacent plane (the "+grid"). A ground
station sees a satellite only while it is more than 25° above the horizon,
then **hands over** to the next one. Unlike a MANET, these changes follow a
schedule fixed by the orbits.

## 1. Predict (5 min)

1. The teaching shell is 8 planes × 8 satellites, with a 120 s orbit. Will
   delivery between two ground stations be steady, random, or periodic? If
   periodic, with what period?
2. In level 5.3, the three inter-satellite links the call uses fail at
   t = 40 s. What happens to delivery?

## 2. Run (25 min)

1. Open the classroom link and play **5.1 First contact**. Select a ground
   station, watch which satellite it talks to, and answer the quiz.
2. Play **5.3 The failed link**. Note the delivery shown every 10 s up to
   120 s, and answer the quiz.

## 3. Explain (15 min)

1. Delivery in 5.3 rises and falls on a cycle. Find the period from your
   notes. Why is it half the orbital period? Hint: think about the shell's
   symmetry.
2. How long did the dip after the failure last? What did the ants do in that
   time?
3. On a +grid, how many paths of equal hop count usually join two
   satellites? What does that mean for repair?

## 4. Compare with ns-3 (10 min)

The ns-3 ISL-grid failure cell ([isl-grid.md](../benchmarks/satellite/isl-grid.md))
cuts a link mid-flow and times the reconvergence. AntHocNet reconverges in
0.111 s, at the oracle's floor. AODV takes 0.268 s, and OLSR 4.245 s.
1. Why is OLSR so much slower to reconverge here?
2. AntHocNet's detection time is 0 on every seed. Which mechanism makes it
   instant on an ISL? Hint: the interface goes down.
