# AntHocNet API reference {#mainpage}

The code behind [the documentation](https://danieljoppi.github.io/AntHocNet/): one simulator-independent
algorithm core, and the adapters that run it.

| Layer | Where | Start at |
|---|---|---|
| **Core** — the protocol, no simulator headers | `core/include/anthocnet/core/` | `anthocnet::core::AntRouterLogic` (the per-node state machine), `anthocnet::core::RouteDecision` (what it asks an adapter to do), `ports.h` (the only window on time, randomness and neighbours) |
| Pheromone state | same | `anthocnet::core::PheromoneTable`, `anthocnet::core::PheromoneEngine`, `anthocnet::core::ILinkMetric` |
| Ants on the wire | same | `anthocnet::core::AntMessage`, `ant_message_codec.h` ([wire format](https://danieljoppi.github.io/AntHocNet/wire-format/)) |
| Configuration | same | `anthocnet::core::Config` — every default traces to a source or a measurement ([configuration](https://danieljoppi.github.io/AntHocNet/configuration/)) |
| **ns-3 adapter** | `ns3/model/`, `ns3/helper/` | `ns3::anthocnet::RoutingProtocol`, `ns3::AntHocNetHelper` |
| **Browser adapter** — the learn site's simulation ([ADR-0021](https://danieljoppi.github.io/AntHocNet/adr/0021-the-browser-is-an-adapter/)) | `web/include/ahn_web/` | `ahn_web::World`, `ahn_web::Node` |

How the pieces fit — the adapter contract, and why time and randomness only
arrive through ports — is in [Architecture](https://danieljoppi.github.io/AntHocNet/architecture/) and
[Software layers](https://danieljoppi.github.io/AntHocNet/software-layers/). The golden rules every change keeps are
in [`AGENTS.md`](https://github.com/danieljoppi/AntHocNet/blob/main/AGENTS.md).
