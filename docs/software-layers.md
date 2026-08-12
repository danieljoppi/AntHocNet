# Software layers and per-regime function support

How the one implementation is stacked, which ant mechanisms each configuration
switch gates, and what is live, inert, or planned in each network regime. This
is the visual companion to [`architecture.md`](architecture.md) (the core/adapter
split in detail) and [`network-regimes.md`](network-regimes.md) §6 (the
mechanism × regime table in prose). The rule everything below obeys: **one
binary, one attribute set — regimes and families change the *evaluation*, not
the protocol.**

Three diagrams, because one would be unreadable: (1) the software stack, (2) the
ant mechanisms and the switches that gate them, (3) what runs in each regime.

## 1. The software stack

Bottom-up: the simulator-agnostic algorithm, the ports that keep it I/O-free,
the per-simulator adapters, and the harnesses that drive scenarios. Nothing in
`core/` includes a simulator header; no adapter reimplements routing logic.

```mermaid
flowchart TB
    subgraph HARNESS["Harnesses & scenarios (ns3/examples)"]
        direction LR
        H1["anthocnet-compare<br/>--scenario=paper / thesis<br/>MANET fields"]
        H2["isl-grid<br/>+Grid torus<br/>satellite ISL"]
        H3["manet-baselines<br/>stock-only control"]
        H4["run-scenarios.py<br/>taxonomy + sweeps"]
    end

    subgraph ADAPT["Adapters (thin — no routing logic)"]
        direction LR
        subgraph NS3["ns3/ contrib module"]
            A3["RoutingProtocol : Ipv4RoutingProtocol<br/>AntHeader : ns3::Header<br/>Ns3Clock / Ns3Rng<br/><b>~30 attributes</b> (the config surface)"]
        end
        subgraph NS2["ns2/ source patch"]
            A2["AntHocNetAgent : Agent<br/>AntPacketHeader (POD)<br/>Ns2Clock / Ns2Rng<br/>TCL binds"]
        end
    end

    subgraph PORTS["Ports (adapters implement, core consumes)"]
        direction LR
        P1["IClock"]
        P2["IRng"]
        P3["INeighborProvider"]
        P4["ITimerScheduler"]
    end

    subgraph CORE["core/ — simulator-agnostic C++"]
        direction TB
        C1["<b>AntRouterLogic</b> — pure: onReceiveAnt / onDataPacket → RouteDecision"]
        C2["PheromoneTable · PheromoneEngine<br/>(evaporate / reinforce / updateRegular / updateVirtual)"]
        C3["AntHistoryTracker — (src,seqNum) dedup, FIFO-capped"]
        C4["AntMessage (POD) · VisitedPath · AntMessageCodec (LE wire)"]
        C5["ILinkMetric seam — ClassicMetric (default)<br/>registry: name → instance"]
        C1 --- C2 --- C3 --- C4 --- C5
    end

    HARNESS --> ADAPT
    ADAPT --> PORTS
    PORTS --> CORE
    A3 -. "attributes set core flags" .-> C1

    style CORE fill:#e2f0ed,stroke:#0f7f70,stroke-width:2px
    style C5 fill:#fff3d4,stroke:#c48f00
    style PORTS fill:#eef,stroke:#5b4fc4
```

The **`ILinkMetric` seam** (highlighted) is the designed extension point:
`ClassicMetric` is the paper's Eq.2 default; energy-aware and fuzzy-composite
metrics (#145/#146) and the future trust factor (#302) plug in here without the
core learning about them. The **~30 ns-3 attributes** are the entire
configuration surface — the next diagram groups them by the mechanism they gate.

## 2. Ant mechanisms and their configuration gates

Every AntHocNet mechanism is an ant family plus the switch that turns it on and
the knobs that tune it. Defaults are the shipped values
([`configuration.md`](configuration.md) has provenance for each). **Master
switches** gate whole mechanisms; **tuning knobs** shape them.

```mermaid
flowchart LR
    subgraph DISC["Route discovery"]
        R1["<b>Reactive forward ants</b><br/>flood to find an unknown route<br/>gate: EnableReactive (on)"]
        R2["Directed reactive<br/>steer one ant along the gradient<br/>gate: EnableDirectedReactive (off — A/B arm)"]
        R3["Multipath acceptance band<br/>admit later good ants → disjoint paths<br/>gate: EnableMultipath (on) · a1=0.9 a2=2.0"]
    end

    subgraph MAINT["Maintenance & improvement"]
        M1["<b>Proactive forward ants</b><br/>refresh/improve active paths (10 s)<br/>gate: EnableProactive (on)"]
        M2["Diffusion — virtual pheromone<br/>hello adverts build the virtual table<br/>gate: EnableDiffusion (on)"]
        M3["Emission gate<br/>send only if virtual ≥ regular + margin<br/>ProactiveVirtualMargin (0 = off, per #180)"]
    end

    subgraph NBR["Neighbour & failure"]
        N1["<b>Hello beacons</b> (1 Hz)<br/>neighbour discovery + advert carrier<br/>HelloInterval"]
        N2["Detector A — hello timeout<br/>always on"]
        N3["Detector D — Wi-Fi MAC tx-failure<br/>gate: EnableMacFailureDetector (on)"]
        N4["<b>Repair ants</b> + link-fail notes<br/>gate: EnableRepair (on) · EnableLinkFail (on)"]
    end

    subgraph COST["Cost / congestion metric"]
        K1["ClassicMetric — delay+hops (default)"]
        K2["A2 congestion metric<br/>(MAC-queue+1)·hop-time<br/>gate: EnableMacMetric (off)"]
        K3["timing: HopTime 3 ms · QueueTimeout 3 s<br/>ReconvHoldCap 200 ms · ReactiveRetryInterval 0.25 s"]
    end

    R1 --> M1 --> N1
    R1 -. alternative .-> R2
    R1 --> R3
    M1 --> M2 --> M3
    N1 --> N2 & N3 --> N4
    K1 -. alternative .-> K2

    style R1 fill:#e2f0ed,stroke:#0f7f70
    style M1 fill:#e2f0ed,stroke:#0f7f70
    style N1 fill:#e2f0ed,stroke:#0f7f70
    style R2 fill:#fff3d4,stroke:#c48f00
    style K2 fill:#fff3d4,stroke:#c48f00
```

Green = on by default (the paper-faithful protocol). Amber = default-off A/B
arms you opt into with an attribute. Everything is one `--ns3::anthocnet::RoutingProtocol::<Attr>=<v>`
away; the harnesses set none of these themselves (#177).

## 3. What runs in each regime

Same stack, same switches — but a mechanism can be **live**, **redundant**
(runs, pays a cost, buys nothing), **inert** (physically cannot fire), or
**planned**. The full argument per row is
[`network-regimes.md`](network-regimes.md) §6; this is the map.

```mermaid
flowchart TB
    subgraph LEGEND[" "]
        direction LR
        L1["● live"]:::live
        L2["◐ redundant"]:::redu
        L3["○ inert"]:::inert
        L4["◇ planned"]:::plan
    end

    subgraph MANET["MANET — Wi-Fi broadcast (supported)"]
        direction TB
        MA["● reactive discovery — the design regime"]:::live
        MB["● proactive + diffusion"]:::live
        MC["● hello — sole neighbour discovery"]:::live
        MD["● multipath · repair · link-fail"]:::live
        ME["● detector A + D (Wi-Fi MAC)"]:::live
        MF["◐ A2 metric — available, off by default"]:::redu
    end

    subgraph SAT["Satellite ISL — p2p +Grid (supported, static)"]
        direction TB
        SA["● reactive discovery — but geometry already knows the graph"]:::live
        SB["● proactive + diffusion — carries the gradient"]:::live
        SC["◐ hello — peer is fixed & known: NRL 12.18 for nothing (#204)"]:::redu
        SD["● multipath — equal corridors; repair only on unscheduled cut"]:::live
        SE["○ detector D — no Wi-Fi MAC on a p2p ISL (#206)"]:::inert
        SF["○ A2 metric — no MAC queue to read (#206/#292)"]:::inert
        SG["◇ timing profile mis-sized — propagation-dominated (#205)"]:::plan
    end

    subgraph FAM["FANET / VANET — mobility families (planned)"]
        direction TB
        FA["◇ 3D Gauss-Markov (FANET) / Manhattan+SUMO (VANET) — #300 / #301"]:::plan
        FB["● all MANET mechanisms transfer unchanged (same Wi-Fi stack)"]:::live
        FC["◇ knob watchlist: hello rate, hold caps, a1/a2 vs churn — A/B only"]:::plan
    end

    subgraph SEC["Security profile — orthogonal to regime (v3.0.0)"]
        direction TB
        XA["◇ trust factor via the ILinkMetric seam — #302"]:::plan
        XB["◇ authenticated ants (kWireVersion bump) — EnableSecurity off by default"]:::plan
    end

    MANET --> SAT --> FAM --> SEC

    classDef live fill:#e2f0ed,stroke:#0f7f70,stroke-width:1.5px;
    classDef redu fill:#fff3d4,stroke:#c48f00,stroke-width:1.5px;
    classDef inert fill:#f6dede,stroke:#c0392b,stroke-width:1.5px;
    classDef plan fill:#eee,stroke:#888,stroke-dasharray:4 3;
```

Reading it column-wise gives each regime's honest one-liner. **MANET:**
everything live — the protocol is in its design regime. **Satellite:** the
discovery half runs but answers a solved problem, hello pays for nothing, the
two Wi-Fi-coupled mechanisms (detector D, A2) are inert, and the timing is
mis-sized — while the multipath/load half faces the real problem
([#192](https://github.com/danieljoppi/AntHocNet/issues/192) research
programme). **FANET/VANET:** no protocol change — the entire Wi-Fi mechanism set
transfers; the work is mobility models, presets, anchors, and a knob *watchlist*
resolved by measurement, not pre-tuning
([#300](https://github.com/danieljoppi/AntHocNet/issues/300)/[#301](https://github.com/danieljoppi/AntHocNet/issues/301)).
**Security:** orthogonal to all of them — it enters through the `ILinkMetric`
seam and an authenticated-ant wire field, default-off and byte-identical when
off ([#302](https://github.com/danieljoppi/AntHocNet/issues/302)).

## See also

- [`architecture.md`](architecture.md) — the core/adapter split and decision flow in detail.
- [`network-regimes.md`](network-regimes.md) — why the regimes differ (§1–§5) and the mechanism × regime table (§6).
- [`configuration.md`](configuration.md) — every attribute, its default, its provenance, and the calibration loop.
- [README “Supported network regimes”](../README.md#supported-network-regimes) — the family and side-by-side comparison tables.
