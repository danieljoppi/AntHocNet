# NS-2 / NS-3 cross-validation (retired)

> **Historical.** The NS-2 adapter was removed in v2.0.0
> ([#307](https://github.com/danieljoppi/AntHocNet/issues/307),
> [ADR-0023](adr/0023-one-core-one-simulator-adapter.md)), so there is no
> second simulator on `main` to cross-validate against. The full procedure —
> `ns3/tools/cross-check.sh` on the ns-3 side, an `ns2/tcl/` scenario and a
> trace-file PDR on the NS-2 side — is preserved at the
> [v1.9.0 tag](https://github.com/danieljoppi/AntHocNet/blob/v1.9.0/docs/cross-validation.md),
> the last release that ships both adapters.

What it was, for readers arriving from older pages:

- **A behavioural re-validation, never a bit-for-bit match.** Both adapters
  drove the same `core/`, but the two simulators ship different MAC/PHY models,
  queueing and timing, so absolute PDR and delay were never expected to agree.
  "Agreement" meant the same qualitative picture — routes discovered after the
  first data demand, non-zero delivery in a connected topology, delay growing
  with hop count. A large qualitative divergence would have meant an adapter
  bug.
- **It checked the adapters, not the algorithm.** The algorithm is pinned down
  independently of any simulator by the `core/` unit tests, which stay; so does
  the browser adapter's byte-identical decision-trace parity gate against the
  native core ([ADR-0021](adr/0021-the-browser-is-an-adapter.md)), which is the
  live check that the core has not drifted toward its one simulator.

## NS-3-only metrics

Several ns-3 benchmark columns never had an NS-2 counterpart, because they are
properties of ns-3's PHY/device models rather than of the shared algorithm:

- **Radio energy** (`energy_j`, `energy_per_pkt_j`, `energy_res_*_j`,
  `first_death_s`; #209) — ns-3's `BasicEnergySource` + `WifiRadioEnergyModel`.
- **Drop-cause breakdown** (`drop_*_pct`; #215) — read from ns-3's
  `FlowMonitor` and `WifiMac` traces; channel loss is a property of the ns-3
  PHY/channel model.
- **Route quality** (`path_hops_*`, `path_div_*`, `path_entropy_bits`,
  `jain_pkts`; #217) — ns-3 `Ipv4L3Protocol` / `WifiMac` hooks.

Their caveats live in [benchmarks/metrics.md](benchmarks/metrics.md).
