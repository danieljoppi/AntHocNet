# Minimal static AntHocNet end-to-end smoke for CI.
#
# Three nodes in a line: 0--1--2, spaced so 0<->1 and 1<->2 are in radio range
# (~200 m) but 0<->2 is not (~400 m). A CBR/UDP flow from node 0 to node 2 can
# only be delivered if AntHocNet discovers and uses the 2-hop route through
# node 1. Static topology, ~30 s — a loose "the protocol routes data" gate, not
# a performance test. The driver counts received CBR packets at the agent layer
# in ci-smoke.tr and fails if none were delivered.

set val(chan)   Channel/WirelessChannel
set val(prop)   Propagation/TwoRayGround
set val(netif)  Phy/WirelessPhy
set val(mac)    Mac/802_11
set val(ifq)    Queue/DropTail/PriQueue
set val(ll)     LL
set val(ant)    Antenna/OmniAntenna
set val(ifqlen) 50
set val(nn)     3
set val(rp)     AntHocNet
set val(x)      600
set val(y)      200
set val(stop)   30

set ns       [new Simulator]
set tracefd  [open ci-smoke.tr w]
$ns trace-all $tracefd

set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)
create-god $val(nn)

# One shared channel so every node hears the medium.
set chan_ [new $val(chan)]

$ns node-config -adhocRouting $val(rp) \
    -llType $val(ll) -macType $val(mac) -ifqType $val(ifq) -ifqLen $val(ifqlen) \
    -antType $val(ant) -propType $val(prop) -phyType $val(netif) \
    -topoInstance $topo -channel $chan_ \
    -agentTrace ON -routerTrace ON -macTrace OFF -movementTrace OFF

for {set i 0} {$i < $val(nn)} {incr i} {
    set node_($i) [$ns node]
    $node_($i) random-motion 0
}

# Static line; 0<->2 is out of range, forcing a route through node 1.
$node_(0) set X_ 0.0;   $node_(0) set Y_ 100.0; $node_(0) set Z_ 0.0
$node_(1) set X_ 200.0; $node_(1) set Y_ 100.0; $node_(1) set Z_ 0.0
$node_(2) set X_ 400.0; $node_(2) set Y_ 100.0; $node_(2) set Z_ 0.0

# CBR/UDP from node 0 to node 2, after a short route-warmup window.
set udp  [new Agent/UDP]
set null [new Agent/Null]
$ns attach-agent $node_(0) $udp
$ns attach-agent $node_(2) $null
$ns connect $udp $null
set cbr [new Application/Traffic/CBR]
$cbr set packetSize_ 512
$cbr set interval_   0.25
$cbr attach-agent $udp
$ns at 5.0  "$cbr start"
$ns at 28.0 "$cbr stop"

for {set i 0} {$i < $val(nn)} {incr i} {
    $ns at $val(stop) "$node_($i) reset"
}
$ns at $val(stop) "stop"
proc stop {} {
    global ns tracefd
    $ns flush-trace
    close $tracefd
    $ns halt
}
$ns run
