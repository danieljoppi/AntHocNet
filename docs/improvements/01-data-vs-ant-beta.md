# 01 — Wire the `beta` exponent; use a greedier β for data than for ants

- **Deviation:** D1
- **Priority:** P0 (single biggest performance lever)
- **Effort:** S
- **Layer:** `core/` (+ expose attributes in both adapters)
- **Depends on:** nothing

## Summary

The stochastic next-hop selection (Eq.1) is supposed to use an exponent `β` that
*differs between ants and data*: a small `β1` for ants (more exploratory) and a
**larger `β2 ≥ β1`** for data (greedy, concentrates traffic on the best paths).
Today the selection hard-codes `β = 1` for everything and ignores the configured
`beta` entirely. This makes data routing spread traffic almost uniformly across
all paths with any pheromone, which badly hurts delivery ratio.

## Spec reference

> Eq.1: `P_nd = (T_nd^i)^β / Σ_{j∈N_d^i} (T_nd^j)^β`, `β ≥ 1`.

> "Nodes in AntHocNet forward data stochastically according to the pheromone
> values. ... `P_nd` is calculated like for reactive forward ants, using
> equation 1. **However, a higher value for the exponent β is used in order to
> be greedy with respect to better paths.**" — [1], §3.4 (Stochastic data routing)

> "...`β2 ≥ β1`." — [1], Eq. for data routing.

Typical values from the literature: `β1 ≈ 2` (ants), `β2 ≈ 20` (data). Make both
configurable; defaults below.

## Current behaviour

`beta` is plumbed into `Config` and exposed as an NS-3 attribute, but selection
uses a file-local constant and never reads `Config::beta`:

```7:9:core/src/pheromone_table.cpp
namespace {
constexpr int kBeta = 1;  // default exponent; see note in nextNeighborNode.
}
```

```63:71:core/src/pheromone_table.cpp
double PheromoneTable::sumProbability(const PheromoneMap& table, NodeAddress dest) const {
    double sum = 0.0;
    for (NodeAddress neighbor : neighborTable_) {
        auto it = table.find({neighbor, dest});
        if (it == table.end()) continue;
        sum += std::pow(it->second, kBeta);
    }
    return sum;
}
```

`kBeta` is also used in `sumMaxProbability` (line 80) and `nextNeighborNode`
(line 109). The same selection is used for **data** (`lookup` → `nextNeighborNode(dest, false)`)
and for **reactive forward ants** (`selectNextHop` → `nextNeighborNode(dest, false)`),
so there is currently no way to be greedier for data.

`Config::beta` (`core/include/anthocnet/core/config.h:20`) defaults to `1` and is
unused by the table.

## Impact

With `β = 1`, `P_nd` is linear in pheromone: a path twice as good gets only twice
the traffic, and very poor paths still receive a meaningful share. Data is
sprayed over inferior routes → more loss, reordering, and congestion. This is the
most likely single cause of the low delivery ratio in `docs/benchmarks.md`
(AntHocNet 10% vs OLSR 34%).

## Required change

The selection function needs to know **which exponent to use**, because the same
function serves ants (β1) and data (β2). Plumb an explicit `beta` parameter down
from the call sites.

### 1. Config — two exponents

In `core/include/anthocnet/core/config.h`, replace the single `beta` with:

```cpp
double betaAnts = 2.0;   ///< BETA1: exponent for ant next-hop choice (exploratory).
double betaData = 20.0;  ///< BETA2: exponent for data next-hop choice (greedy). betaData >= betaAnts.
```

(Keep them `double`: Eq.1 permits non-integer exponents and `std::pow` is already
used.)

### 2. PheromoneTable — accept beta as an argument

In `core/src/pheromone_table.cpp` / its header, remove `kBeta` and thread `double beta`
through `sumProbability`, `sumMaxProbability`, and `nextNeighborNode`:

```cpp
NodeAddress PheromoneTable::nextNeighborNode(NodeAddress dest, bool isProactiveAnt,
                                             double beta, IRng& rng) const;
NodeAddress PheromoneTable::lookup(NodeAddress dest, double beta, IRng& rng) const;
```

Use `std::pow(weight, beta)` everywhere `std::pow(weight, kBeta)` appears.

### 3. AntRouterLogic — pass β1 for ants, β2 for data

In `core/src/ant_router_logic.cpp`:

- `selectNextHop(dest, proactive)` (used for forward ants, reactive + proactive)
  → call `table_.nextNeighborNode(dest, proactive, config_.betaAnts, rng_)`.
- `onDataPacket(dest)` → call `table_.lookup(dest, config_.betaData, rng_)`.

Note the NS-3 adapter calls `m_logic->selectNextHop(...)` directly in
`RouteOutput`/`RouteInput`/`FlushQueue` to route **data**. Add a dedicated data
lookup on the logic so adapters route data with β2:

```cpp
// AntRouterLogic
NodeAddress AntRouterLogic::nextHopForData(NodeAddress dest) {
    return table_.lookup(dest, config_.betaData, rng_);
}
```

Then change the NS-3 adapter's data paths (`anthocnet-routing-protocol.cc`
`RouteOutput`, `RouteInput`, `FlushQueue`) from `selectNextHop(ToCore(dst), false)`
to `m_logic->nextHopForData(ToCore(dst))`. (NS-2 routes data via
`onDataPacket`, which already goes through the core — no adapter change needed
there beyond confirming.)

### 4. Expose the two attributes in adapters

- **NS-3** (`anthocnet-routing-protocol.cc` `GetTypeId` + members): replace the
  single `Beta` attribute/`m_beta` with `BetaAnts` (default 2.0) and `BetaData`
  (default 20.0), `DoubleValue`, and set `m_config.betaAnts/.betaData` in
  `DoInitialize`/`NotifyInterfaceUp`.
- **NS-2** (`ns2/src/ahn_router.*`): add `bind("beta_ants_", ...)` and
  `bind("beta_data_", ...)`, copy into `config_` in `startProtocol`. Add defaults
  to `ns2/patch/fragments/ns-default.tcl.fragment`.

## Files to touch

- `core/include/anthocnet/core/config.h`
- `core/include/anthocnet/core/pheromone_table.h`
- `core/src/pheromone_table.cpp`
- `core/include/anthocnet/core/ant_router_logic.h`
- `core/src/ant_router_logic.cpp`
- `ns3/model/anthocnet-routing-protocol.{h,cc}`
- `ns2/src/ahn_router.{h,cc}`, `ns2/patch/fragments/ns-default.tcl.fragment`

## Acceptance criteria

Add `core/tests/test_beta_selection.cpp` (register in `core/tests/CMakeLists.txt`):

1. **Greedier β concentrates choice.** Build a table for one dest with two
   neighbours whose pheromones are `2.0` and `1.0`. Using a deterministic
   `ScriptedRng` sweep of `r ∈ {0.1,...,0.9}`, assert that with `betaData = 20`
   the better neighbour is chosen for (almost) all `r`, whereas with `beta = 1`
   it is chosen ~2/3 of the time. (i.e. the selection distribution changes with
   β.)
2. **Ants vs data use different exponents.** With `betaAnts=1`, `betaData=20`
   and the same table/RNG, `selectNextHop(dest,false)` and `nextHopForData(dest)`
   can return different next hops for the same `r`.
3. **`betaData` is actually read** (regression for D1): changing
   `Config::betaData` changes the result of `nextHopForData` for a fixed RNG
   sequence.
4. Existing `test_pheromone_table.cpp` updated for the new signatures; `make test`
   green.

## Risks / notes

- This changes the public signatures of `PheromoneTable::nextNeighborNode` /
  `lookup`. Update all call sites (NS-3 adapter calls `selectNextHop`/`lookup`).
- Very large `β2` with `std::pow` is fine for the small pheromone magnitudes used
  here, but guard against `0^β = 0` (already handled by `phSum == 0` early-out).
- This is a behaviour change only; **no wire-format change**, so codec/adapters
  headers are unaffected.
