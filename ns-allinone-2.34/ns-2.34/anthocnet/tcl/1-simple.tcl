# wrls1.tcl
# A 3-node example for ad-hoc simulation with DSDV

# Define options
set val(chan)           Channel/WirelessChannel    ;# channel type
set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)          Phy/WirelessPhy            ;# network interface type
set val(mac)            Mac/802_11                 ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq
set val(nn)             7                          ;# number of mobilenodes
set val(rp)             AntHocNet                  ;# routing protocol
set val(x)              500   			   ;# X dimension of topography
set val(y)              400   			   ;# Y dimension of topography  
set val(stop)		450			   ;# time of simulation end
set opt(energymodel)    EnergyModel     	   ;# Energy mode on
set opt(initialenergy)  10000            	   ;# Initial energy in Joules

set ns		  [new Simulator]
set tracefd       [open simple-ant.tr w]
set windowVsTime2 [open win-simple-ant.tr w] 
set namtrace      [open simple-wrls.nam w]    

$ns trace-all $tracefd
$ns namtrace-all-wireless $namtrace $val(x) $val(y)

# set up topography object
set topo       [new Topography]

$topo load_flatgrid $val(x) $val(y)

set god_ [create-god $val(nn)]

#
#  Create nn mobilenodes [$val(nn)] and attach them to the channel. 
#

# configure the nodes
$ns node-config -adhocRouting $val(rp) \
		 -llType $val(ll) \
		 -macType $val(mac) \
		 -ifqType $val(ifq) \
		 -ifqLen $val(ifqlen) \
		 -antType $val(ant) \
		 -propType $val(prop) \
		 -phyType $val(netif) \
		 -channelType $val(chan) \
		 -topoInstance $topo \
		 -agentTrace ON \
		 -routerTrace ON \
		 -macTrace OFF \
		 -energyModel $opt(energymodel) \
		 -idlePower 1.0 \
		 -rxPower 0.01 \
		 -txPower 0.01 \
  		 -sleepPower 0.000001 \
  		 -transitionPower 0.2 \
  		 -transitionTime 0.005 \
		 -initialEnergy $opt(initialenergy) \
		 -movementTrace ON
		 
for {set i 0} {$i < $val(nn) } { incr i } {
	set node_($i) [$ns node]
	$god_ new_node $node_($i)
}

# Provide initial location of mobilenodes
$node_(0) set X_ 5.0
$node_(0) set Y_ 5.0
$node_(0) set Z_ 0.0

$node_(1) set X_ 490.0
$node_(1) set Y_ 285.0
$node_(1) set Z_ 0.0

$node_(2) set X_ 150.0
$node_(2) set Y_ 240.0
$node_(2) set Z_ 0.0

$node_(3) set X_ 250.0
$node_(3) set Y_ 240.0
$node_(3) set Z_ 0.0

$node_(4) set X_ 50.0
$node_(4) set Y_ 80.0
$node_(4) set Z_ 0.0

$node_(5) set X_ 360.0
$node_(5) set Y_ 280.0
$node_(5) set Z_ 0.0


$node_(6) set X_ 230.0
$node_(6) set Y_ 200.0
$node_(6) set Z_ 0.0
$ns at 0.0 "$node_(6) off"
$ns at 80.0 "$node_(6) on"


# Generation of movements
$ns at 10.0 "$node_(0) setdest 250.0 250.0 3.0"
$ns at 15.0 "$node_(1) setdest 45.0 285.0 5.0"
$ns at 100.0 "$node_(0) setdest 1480.0 300.0 5.0" 
$ns at 110.0 "$node_(6) setdest 1480.0 150.0 5.0" 
$ns at 100.0 "$node_(1) setdest 1480.0 1.0 5.0" 
$ns at 10.0 "$node_(5) setdest 85.0 285.0 5.0"
$ns at 60.0 "$node_(3) setdest 5.0 285.0 5.0"
$ns at 105.0 "$node_(5) setdest 480.0 350 5.0"
$ns at 100.0 "$node_(1) setdest 1480.0 150.0 5.0" 

set val(x)              1500   			   ;# X dimension of topography


$ns at 15.0 "$topo load_flatgrid $val(x) $val(y)"

# Set a TCP connection between node_(0) and node_(1)
set tcp [new Agent/TCP/Newreno]
$tcp set class_ 2
set sink [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp
$ns attach-agent $node_(1) $sink
$ns connect $tcp $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns at 10.0 "$ftp start" 

# Printing the window size
proc plotWindow {tcpSource file} {
global ns
set time 0.01
set now [$ns now]
set cwnd [$tcpSource set cwnd_]
puts $file "$now $cwnd"
$ns at [expr $now+$time] "plotWindow $tcpSource $file" }
$ns at 10.1 "plotWindow $tcp $windowVsTime2"  

# Define node initial position in nam
for {set i 0} {$i < $val(nn)} { incr i } {
# 30 defines the node size for nam
$ns initial_node_pos $node_($i) 30
}

# Telling nodes when the simulation ends
for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "$node_($i) reset";
}

# ending nam and the simulation 
$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "stop"
$ns at 450.01 "puts \"end simulation\" ; $ns halt"
proc stop {} {
    global ns tracefd namtrace
    $ns flush-trace
    close $tracefd
    close $namtrace
}

$ns run


