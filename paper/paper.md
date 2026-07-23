---
title: 'AntHocNet: An open, simulator-agnostic implementation of ant-colony routing for mobile ad-hoc networks'
tags:
  - MANET
  - routing protocol
  - ant colony optimization
  - swarm intelligence
  - network simulation
  - ns-3
  - ns-2
  - C++
authors:
  - name: Daniel Henrique Joppi
    affiliation: 1
affiliations:
  - name: Independent researcher
    index: 1
date: 23 July 2026
bibliography: paper.bib
---

# Summary

AntHocNet [@anthocnet2004] is a hybrid, multipath routing protocol for mobile
ad-hoc networks (MANETs) built on ideas from ant colony optimization (ACO):
lightweight "ant" control packets lay and follow artificial *pheromone* trails,
so that routes are discovered reactively, maintained proactively, and repaired
locally as the network topology changes. This software is an open, tested,
**simulator-agnostic** implementation of AntHocNet. The routing algorithm is
written once as a portable C++ core that has no dependency on any simulator ---
it obtains time, randomness, neighbours, and deferred work through four narrow
interfaces ("ports") and returns *decisions* rather than performing input or
output. Thin adapters then install that same core onto two widely used network
simulators: an idempotent source patch for **NS-2** and a native
`Ipv4RoutingProtocol` module for **NS-3**. The core is covered by unit and
randomized property tests; continuous integration builds the NS-3 module across
ns-3.36--3.48 and compiles the NS-2 adapter against ns-2.34/2.35, each running
an end-to-end delivery smoke test. Prebuilt simulator container images and a
scripted benchmark harness make the reported comparisons reproducible, and the
project is versioned and citable.

# Statement of need

Although AntHocNet is a well-known ant-based MANET routing protocol, no
maintained, openly available implementation existed, and independently
reproducing its results was difficult: the original was evaluated in a
commercial simulator, ant-routing implementations are scarce, and outcomes
depend on simulator- and physical-layer details that are seldom reported in
full. Mainstream simulators reflect this gap --- NS-3, for example, ships AODV
[@aodv], OLSR, and DSDV but no ACO-based routing protocol.

This software addresses that need. Its ports-and-adapters design lets the
*same* algorithm run on two simulators --- a rare capability that turns
cross-simulator behaviour into something one can re-validate rather than
re-implement --- and its containerized harness reproduces the protocol's
headline advantages over AODV in packet delivery ratio and routing overhead.
It is intended for networking and swarm-intelligence researchers who need a
tested, reproducible ACO-routing baseline or an experimentation platform, and
for educators teaching nature-inspired networking. Because the algorithm core
is isolated from simulator specifics, it is also a foundation for porting the
protocol to further simulators and for controlled studies of how routing
behaviour depends on the underlying MAC/PHY models.

# State of the field

Ant-based routing began with wired-network algorithms such as ABC [@abc] and
AntNet [@antnet], which sample paths with ant-like agents and bias routing
toward better paths via pheromone. Adaptations to MANETs (e.g., ARA and PERA)
reduced ant overhead but lost much of the proactive sampling that makes these
methods adaptive; AntHocNet restored it in a hybrid, multipath design.
Open, maintained, and *tested* implementations of these protocols remain rare,
and implementations that run one algorithm unchanged across multiple simulators
are rarer still --- which is the gap this software fills.

# Acknowledgements

The AntHocNet algorithm is due to Di Caro, Ducatelle, and Gambardella
[@anthocnet2004]. <!-- TODO: funding acknowledgements, if any. -->

# References
