# Lab 5 — Stochastic multipath and the pheromone exponent β

**Goal.** See that AntHocNet forwards data stochastically over several next
hops, and how one parameter, β, moves it from spreading to single-path.
**Time.** 45 min. **Site.** The mesh world, seed 4, and the tuning bench.

[← Classroom pack](README.md) · [Answer key](answer-keys.md#lab-5)

## Background (5 min)

A node forwards a data packet to neighbour *n* with probability proportional
to τₙ^β, where τₙ is the pheromone toward the destination through *n*
([ant colony routing](../ant-colony-routing.md)). The data exponent is
`betaData`. The default is 20, the thesis's β₃
([configuration.md](../configuration.md)). Mission 5 of the Academy, *Two
roads*, shows the split on this world.

## 1. Predict (5 min)

1. At β = 1, will the first call's source use one next hop or several?
2. At β = 20 (the default)? At β = 30?

## 2. Run (20 min)

1. Open [`#mesh?seed=4`](https://danieljoppi.github.io/AntHocNet/#mesh?seed=4). Select the first call's
   source and turn on the *pheromone* overlay. Run to **t = 120 s**.
2. Watch which neighbours the source's data goes to. The *strongest route*
   overlay draws the best next hop, and the *pheromone* overlay draws every
   trail the source can choose from.
3. In the tuning bench, set `betaData` to **1** and repeat. Then set it to
   **30** and repeat.

## 3. Explain (10 min)

1. How many different next hops did the source use at each β?
2. Spreading uses more paths. Name one benefit and one cost. Hint:
   reordering and delay.
3. The thesis keeps β₃ at 20. What does that choice say about its authors'
   priorities?

## 4. Compare with ns-3 (5 min)

Read the `betaData` row of [configuration.md](../configuration.md). Which
scenario showed the largest effect of β = 20, and on which metric?
