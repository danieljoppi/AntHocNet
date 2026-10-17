# Lab 3 — VANET: buildings, corners and reconvergence

**Goal.** See why cars in a city lose routes, and why fixed infrastructure
helps. Then read the measured gap between AntHocNet and a protocol that
knows the topology.
**Time.** 60 min. **Site.** Campaign levels 3.1 and 3.4
([`#campaign?open=all`](https://danieljoppi.github.io/AntHocNet/#campaign?open=all)).

[← Classroom pack](README.md) · [Answer key](answer-keys.md#lab-3)

## Background (5 min)

In a street grid, buildings block the radio at every corner. Two cars a few
metres apart lose their link the moment one turns into a side street. A
route that worked a second ago is gone, and the protocol must find another.
This is **reconvergence**, and it is VANET's largest measured loss
([vanet.md](../benchmarks/scenarios/vanet.md)).

## 1. Predict (5 min)

1. Level 3.1 has four cars and one call. What ends the call: distance or
   something else?
2. Level 3.4 has sixteen cars, and ten of them park and switch off at 60 s.
   Sketch the delivery you expect over 160 s, without any roadside units.
3. Now sketch it with five roadside units: four near the corners and one at
   the centre.

## 2. Run (25 min)

1. Open the classroom link and play **3.1 Around the corner**. Follow car 1
   and watch its links as it reaches a corner. Answer the quiz.
2. Play **3.4 Traffic jam** without placing anything: press *Run*. Every
   10 s, note the delivery percentage shown for each call.
3. *Retry* 3.4. Place roadside units at (200, 200), (600, 200), (200, 600),
   (600, 600) and (400, 400), then run it again and note the same numbers.

## 3. Explain (15 min)

1. In 3.1, why does the call drop although the cars stay well inside radio
   range?
2. In 3.4, compare delivery before and after 60 s, with and without the
   units. What do fixed units give the ants that cars cannot?
3. Even with units, delivery after 60 s is lower than before. Why?

## 4. Compare with ns-3 (10 min)

On the ns-3 VANET main cell (20 seeds, 900 s), AntHocNet delivers
**42.1 %**. An oracle that always knows the shortest current path delivers
**81.7 %** on the same field ([vanet.md](../benchmarks/scenarios/vanet.md)).
1. The oracle shows the network is connected most of the time. Where does
   the other ~40 % go?
2. Link-lifetime prediction ([#574](https://github.com/danieljoppi/AntHocNet/issues/574),
   the *Look-ahead* upgrade) discounts a next hop whose link is about to
   break. Why could a prediction based only on distance and speed miss a
   break at a corner?
