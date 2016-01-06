#sim-scn2-4.tcl 
# ad-hoc simulation with AntHocNet 

# Define options
set val(chan)           Channel/WirelessChannel    ;# channel type
set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)          Phy/WirelessPhy            ;# network interface type
set val(mac)            Mac/802_11                 ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         64                         ;# max packet in ifq
set val(nn)             150                        ;# number of mobilenodes
set val(rp)             [lindex $argv 0]                  ;# routing protocol
set val(x)              3000   			        ;# X dimension of topography
set val(y)              1000   					;# Y dimension of topography
set val(stop)			 900					   	    ;# time of simulation end
set opt(energymodel)    EnergyModel     	   ;# Energy mode on
set opt(initialenergy)  10000            	   ;# Initial energy in Joules

if { $val(rp) == "AntHocNet" } {
	set val(ifq)            CMUPriQueue
} else {
	set val(ifq)            Queue/DropTail/PriQueue
}

set ns		  [new Simulator]
set tracefd       [open sim-scn2-4-$val(rp)-trace.tr w]
set windowVsTime2 [open sim-scn2-4-$val(rp)-win-.tr w]
set namtrace      [open sim-scn2-4-$val(rp).nam w]

$ns trace-all $tracefd
$ns namtrace-all-wireless $namtrace $val(x) $val(y)

# set up topography object
set topo       [new Topography]

$topo load_flatgrid $val(x) $val(y)

create-god $val(nn)

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
}

# Provide initial location of mobilenodes
$node_(0) set X_ 720 
$node_(0) set Y_ 676 
$node_(0) set Z_ 0.0 
$node_(1) set X_ 148 
$node_(1) set Y_ 839 
$node_(1) set Z_ 0.0 
$node_(2) set X_ 481 
$node_(2) set Y_ 391 
$node_(2) set Z_ 0.0 
$node_(3) set X_ 178 
$node_(3) set Y_ 655 
$node_(3) set Z_ 0.0 
$node_(4) set X_ 60 
$node_(4) set Y_ 382 
$node_(4) set Z_ 0.0 
$node_(5) set X_ 1223 
$node_(5) set Y_ 479 
$node_(5) set Z_ 0.0 
$node_(6) set X_ 160 
$node_(6) set Y_ 31 
$node_(6) set Z_ 0.0 
$node_(7) set X_ 2467 
$node_(7) set Y_ 975 
$node_(7) set Z_ 0.0 
$node_(8) set X_ 2391 
$node_(8) set Y_ 690 
$node_(8) set Z_ 0.0 
$node_(9) set X_ 1343 
$node_(9) set Y_ 647 
$node_(9) set Z_ 0.0 
$node_(10) set X_ 1780 
$node_(10) set Y_ 867 
$node_(10) set Z_ 0.0 
$node_(11) set X_ 102 
$node_(11) set Y_ 258 
$node_(11) set Z_ 0.0 
$node_(12) set X_ 774 
$node_(12) set Y_ 713 
$node_(12) set Z_ 0.0 
$node_(13) set X_ 350 
$node_(13) set Y_ 881 
$node_(13) set Z_ 0.0 
$node_(14) set X_ 1615 
$node_(14) set Y_ 683 
$node_(14) set Z_ 0.0 
$node_(15) set X_ 481 
$node_(15) set Y_ 294 
$node_(15) set Z_ 0.0 
$node_(16) set X_ 2390 
$node_(16) set Y_ 567 
$node_(16) set Z_ 0.0 
$node_(17) set X_ 890 
$node_(17) set Y_ 691 
$node_(17) set Z_ 0.0 
$node_(18) set X_ 273 
$node_(18) set Y_ 576 
$node_(18) set Z_ 0.0 
$node_(19) set X_ 1000 
$node_(19) set Y_ 642 
$node_(19) set Z_ 0.0 
$node_(20) set X_ 1309 
$node_(20) set Y_ 803 
$node_(20) set Z_ 0.0 
$node_(21) set X_ 503 
$node_(21) set Y_ 798 
$node_(21) set Z_ 0.0 
$node_(22) set X_ 1754 
$node_(22) set Y_ 167 
$node_(22) set Z_ 0.0 
$node_(23) set X_ 1827 
$node_(23) set Y_ 107 
$node_(23) set Z_ 0.0 
$node_(24) set X_ 266 
$node_(24) set Y_ 907 
$node_(24) set Z_ 0.0 
$node_(25) set X_ 2625 
$node_(25) set Y_ 187 
$node_(25) set Z_ 0.0 
$node_(26) set X_ 2328 
$node_(26) set Y_ 799 
$node_(26) set Z_ 0.0 
$node_(27) set X_ 2143 
$node_(27) set Y_ 96 
$node_(27) set Z_ 0.0 
$node_(28) set X_ 11 
$node_(28) set Y_ 517 
$node_(28) set Z_ 0.0 
$node_(29) set X_ 541 
$node_(29) set Y_ 911 
$node_(29) set Z_ 0.0 
$node_(30) set X_ 702 
$node_(30) set Y_ 3 
$node_(30) set Z_ 0.0 
$node_(31) set X_ 1741 
$node_(31) set Y_ 436 
$node_(31) set Z_ 0.0 
$node_(32) set X_ 1593 
$node_(32) set Y_ 259 
$node_(32) set Z_ 0.0 
$node_(33) set X_ 40 
$node_(33) set Y_ 874 
$node_(33) set Z_ 0.0 
$node_(34) set X_ 1682 
$node_(34) set Y_ 734 
$node_(34) set Z_ 0.0 
$node_(35) set X_ 635 
$node_(35) set Y_ 478 
$node_(35) set Z_ 0.0 
$node_(36) set X_ 1644 
$node_(36) set Y_ 334 
$node_(36) set Z_ 0.0 
$node_(37) set X_ 338 
$node_(37) set Y_ 39 
$node_(37) set Z_ 0.0 
$node_(38) set X_ 1305 
$node_(38) set Y_ 161 
$node_(38) set Z_ 0.0 
$node_(39) set X_ 2098 
$node_(39) set Y_ 583 
$node_(39) set Z_ 0.0 
$node_(40) set X_ 532 
$node_(40) set Y_ 260 
$node_(40) set Z_ 0.0 
$node_(41) set X_ 508 
$node_(41) set Y_ 765 
$node_(41) set Z_ 0.0 
$node_(42) set X_ 2144 
$node_(42) set Y_ 24 
$node_(42) set Z_ 0.0 
$node_(43) set X_ 1256 
$node_(43) set Y_ 306 
$node_(43) set Z_ 0.0 
$node_(44) set X_ 1946 
$node_(44) set Y_ 415 
$node_(44) set Z_ 0.0 
$node_(45) set X_ 474 
$node_(45) set Y_ 238 
$node_(45) set Z_ 0.0 
$node_(46) set X_ 265 
$node_(46) set Y_ 831 
$node_(46) set Z_ 0.0 
$node_(47) set X_ 2165 
$node_(47) set Y_ 876 
$node_(47) set Z_ 0.0 
$node_(48) set X_ 1265 
$node_(48) set Y_ 264 
$node_(48) set Z_ 0.0 
$node_(49) set X_ 2323 
$node_(49) set Y_ 202 
$node_(49) set Z_ 0.0 
$node_(50) set X_ 37 
$node_(50) set Y_ 404 
$node_(50) set Z_ 0.0 
$node_(51) set X_ 2003 
$node_(51) set Y_ 784 
$node_(51) set Z_ 0.0 
$ns at 0.0 "$node_(51) off" 
$ns at 165.0 "$node_(51) on" 
$node_(52) set X_ 2810 
$node_(52) set Y_ 425 
$node_(52) set Z_ 0.0 
$ns at 0.0 "$node_(52) off" 
$ns at 165.0 "$node_(52) on" 
$node_(53) set X_ 488 
$node_(53) set Y_ 438 
$node_(53) set Z_ 0.0 
$ns at 0.0 "$node_(53) off" 
$ns at 165.0 "$node_(53) on" 
$node_(54) set X_ 2773 
$node_(54) set Y_ 564 
$node_(54) set Z_ 0.0 
$ns at 0.0 "$node_(54) off" 
$ns at 165.0 "$node_(54) on" 
$node_(55) set X_ 1794 
$node_(55) set Y_ 590 
$node_(55) set Z_ 0.0 
$ns at 0.0 "$node_(55) off" 
$ns at 165.0 "$node_(55) on" 
$node_(56) set X_ 1794 
$node_(56) set Y_ 966 
$node_(56) set Z_ 0.0 
$ns at 0.0 "$node_(56) off" 
$ns at 165.0 "$node_(56) on" 
$node_(57) set X_ 1045 
$node_(57) set Y_ 712 
$node_(57) set Z_ 0.0 
$ns at 0.0 "$node_(57) off" 
$ns at 165.0 "$node_(57) on" 
$node_(58) set X_ 2898 
$node_(58) set Y_ 953 
$node_(58) set Z_ 0.0 
$ns at 0.0 "$node_(58) off" 
$ns at 165.0 "$node_(58) on" 
$node_(59) set X_ 1807 
$node_(59) set Y_ 245 
$node_(59) set Z_ 0.0 
$ns at 0.0 "$node_(59) off" 
$ns at 165.0 "$node_(59) on" 
$node_(60) set X_ 2588 
$node_(60) set Y_ 576 
$node_(60) set Z_ 0.0 
$ns at 0.0 "$node_(60) off" 
$ns at 165.0 "$node_(60) on" 
$node_(61) set X_ 193 
$node_(61) set Y_ 139 
$node_(61) set Z_ 0.0 
$ns at 0.0 "$node_(61) off" 
$ns at 165.0 "$node_(61) on" 
$node_(62) set X_ 2137 
$node_(62) set Y_ 274 
$node_(62) set Z_ 0.0 
$ns at 0.0 "$node_(62) off" 
$ns at 165.0 "$node_(62) on" 
$node_(63) set X_ 542 
$node_(63) set Y_ 545 
$node_(63) set Z_ 0.0 
$ns at 0.0 "$node_(63) off" 
$ns at 165.0 "$node_(63) on" 
$node_(64) set X_ 1618 
$node_(64) set Y_ 504 
$node_(64) set Z_ 0.0 
$ns at 0.0 "$node_(64) off" 
$ns at 165.0 "$node_(64) on" 
$node_(65) set X_ 2652 
$node_(65) set Y_ 167 
$node_(65) set Z_ 0.0 
$ns at 0.0 "$node_(65) off" 
$ns at 165.0 "$node_(65) on" 
$node_(66) set X_ 1908 
$node_(66) set Y_ 468 
$node_(66) set Z_ 0.0 
$ns at 0.0 "$node_(66) off" 
$ns at 165.0 "$node_(66) on" 
$node_(67) set X_ 1939 
$node_(67) set Y_ 523 
$node_(67) set Z_ 0.0 
$ns at 0.0 "$node_(67) off" 
$ns at 165.0 "$node_(67) on" 
$node_(68) set X_ 2008 
$node_(68) set Y_ 417 
$node_(68) set Z_ 0.0 
$ns at 0.0 "$node_(68) off" 
$ns at 165.0 "$node_(68) on" 
$node_(69) set X_ 2544 
$node_(69) set Y_ 656 
$node_(69) set Z_ 0.0 
$ns at 0.0 "$node_(69) off" 
$ns at 165.0 "$node_(69) on" 
$node_(70) set X_ 907 
$node_(70) set Y_ 596 
$node_(70) set Z_ 0.0 
$ns at 0.0 "$node_(70) off" 
$ns at 165.0 "$node_(70) on" 
$node_(71) set X_ 234 
$node_(71) set Y_ 876 
$node_(71) set Z_ 0.0 
$ns at 0.0 "$node_(71) off" 
$ns at 165.0 "$node_(71) on" 
$node_(72) set X_ 1777 
$node_(72) set Y_ 557 
$node_(72) set Z_ 0.0 
$ns at 0.0 "$node_(72) off" 
$ns at 165.0 "$node_(72) on" 
$node_(73) set X_ 5 
$node_(73) set Y_ 735 
$node_(73) set Z_ 0.0 
$ns at 0.0 "$node_(73) off" 
$ns at 165.0 "$node_(73) on" 
$node_(74) set X_ 1584 
$node_(74) set Y_ 444 
$node_(74) set Z_ 0.0 
$ns at 0.0 "$node_(74) off" 
$ns at 165.0 "$node_(74) on" 
$node_(75) set X_ 2593 
$node_(75) set Y_ 754 
$node_(75) set Z_ 0.0 
$ns at 0.0 "$node_(75) off" 
$ns at 330.0 "$node_(75) on" 
$node_(76) set X_ 219 
$node_(76) set Y_ 863 
$node_(76) set Z_ 0.0 
$ns at 0.0 "$node_(76) off" 
$ns at 330.0 "$node_(76) on" 
$node_(77) set X_ 1571 
$node_(77) set Y_ 413 
$node_(77) set Z_ 0.0 
$ns at 0.0 "$node_(77) off" 
$ns at 330.0 "$node_(77) on" 
$node_(78) set X_ 2993 
$node_(78) set Y_ 120 
$node_(78) set Z_ 0.0 
$ns at 0.0 "$node_(78) off" 
$ns at 330.0 "$node_(78) on" 
$node_(79) set X_ 447 
$node_(79) set Y_ 487 
$node_(79) set Z_ 0.0 
$ns at 0.0 "$node_(79) off" 
$ns at 330.0 "$node_(79) on" 
$node_(80) set X_ 1768 
$node_(80) set Y_ 928 
$node_(80) set Z_ 0.0 
$ns at 0.0 "$node_(80) off" 
$ns at 330.0 "$node_(80) on" 
$node_(81) set X_ 1117 
$node_(81) set Y_ 141 
$node_(81) set Z_ 0.0 
$ns at 0.0 "$node_(81) off" 
$ns at 330.0 "$node_(81) on" 
$node_(82) set X_ 206 
$node_(82) set Y_ 171 
$node_(82) set Z_ 0.0 
$ns at 0.0 "$node_(82) off" 
$ns at 330.0 "$node_(82) on" 
$node_(83) set X_ 2159 
$node_(83) set Y_ 97 
$node_(83) set Z_ 0.0 
$ns at 0.0 "$node_(83) off" 
$ns at 330.0 "$node_(83) on" 
$node_(84) set X_ 460 
$node_(84) set Y_ 959 
$node_(84) set Z_ 0.0 
$ns at 0.0 "$node_(84) off" 
$ns at 330.0 "$node_(84) on" 
$node_(85) set X_ 1862 
$node_(85) set Y_ 788 
$node_(85) set Z_ 0.0 
$ns at 0.0 "$node_(85) off" 
$ns at 330.0 "$node_(85) on" 
$node_(86) set X_ 2283 
$node_(86) set Y_ 976 
$node_(86) set Z_ 0.0 
$ns at 0.0 "$node_(86) off" 
$ns at 330.0 "$node_(86) on" 
$node_(87) set X_ 442 
$node_(87) set Y_ 666 
$node_(87) set Z_ 0.0 
$ns at 0.0 "$node_(87) off" 
$ns at 330.0 "$node_(87) on" 
$node_(88) set X_ 832 
$node_(88) set Y_ 115 
$node_(88) set Z_ 0.0 
$ns at 0.0 "$node_(88) off" 
$ns at 330.0 "$node_(88) on" 
$node_(89) set X_ 2734 
$node_(89) set Y_ 728 
$node_(89) set Z_ 0.0 
$ns at 0.0 "$node_(89) off" 
$ns at 330.0 "$node_(89) on" 
$node_(90) set X_ 494 
$node_(90) set Y_ 446 
$node_(90) set Z_ 0.0 
$ns at 0.0 "$node_(90) off" 
$ns at 330.0 "$node_(90) on" 
$node_(91) set X_ 674 
$node_(91) set Y_ 886 
$node_(91) set Z_ 0.0 
$ns at 0.0 "$node_(91) off" 
$ns at 330.0 "$node_(91) on" 
$node_(92) set X_ 2836 
$node_(92) set Y_ 884 
$node_(92) set Z_ 0.0 
$ns at 0.0 "$node_(92) off" 
$ns at 330.0 "$node_(92) on" 
$node_(93) set X_ 2113 
$node_(93) set Y_ 12 
$node_(93) set Z_ 0.0 
$ns at 0.0 "$node_(93) off" 
$ns at 330.0 "$node_(93) on" 
$node_(94) set X_ 2258 
$node_(94) set Y_ 293 
$node_(94) set Z_ 0.0 
$ns at 0.0 "$node_(94) off" 
$ns at 330.0 "$node_(94) on" 
$node_(95) set X_ 14 
$node_(95) set Y_ 393 
$node_(95) set Z_ 0.0 
$ns at 0.0 "$node_(95) off" 
$ns at 330.0 "$node_(95) on" 
$node_(96) set X_ 2115 
$node_(96) set Y_ 374 
$node_(96) set Z_ 0.0 
$ns at 0.0 "$node_(96) off" 
$ns at 330.0 "$node_(96) on" 
$node_(97) set X_ 726 
$node_(97) set Y_ 813 
$node_(97) set Z_ 0.0 
$ns at 0.0 "$node_(97) off" 
$ns at 330.0 "$node_(97) on" 
$node_(98) set X_ 1032 
$node_(98) set Y_ 392 
$node_(98) set Z_ 0.0 
$ns at 0.0 "$node_(98) off" 
$ns at 330.0 "$node_(98) on" 
$node_(99) set X_ 2964 
$node_(99) set Y_ 701 
$node_(99) set Z_ 0.0 
$ns at 0.0 "$node_(99) off" 
$ns at 330.0 "$node_(99) on" 
$node_(100) set X_ 733 
$node_(100) set Y_ 692 
$node_(100) set Z_ 0.0 
$ns at 0.0 "$node_(100) off" 
$ns at 495.0 "$node_(100) on" 
$node_(101) set X_ 1235 
$node_(101) set Y_ 615 
$node_(101) set Z_ 0.0 
$ns at 0.0 "$node_(101) off" 
$ns at 495.0 "$node_(101) on" 
$node_(102) set X_ 2094 
$node_(102) set Y_ 9 
$node_(102) set Z_ 0.0 
$ns at 0.0 "$node_(102) off" 
$ns at 495.0 "$node_(102) on" 
$node_(103) set X_ 793 
$node_(103) set Y_ 815 
$node_(103) set Z_ 0.0 
$ns at 0.0 "$node_(103) off" 
$ns at 495.0 "$node_(103) on" 
$node_(104) set X_ 195 
$node_(104) set Y_ 765 
$node_(104) set Z_ 0.0 
$ns at 0.0 "$node_(104) off" 
$ns at 495.0 "$node_(104) on" 
$node_(105) set X_ 2778 
$node_(105) set Y_ 848 
$node_(105) set Z_ 0.0 
$ns at 0.0 "$node_(105) off" 
$ns at 495.0 "$node_(105) on" 
$node_(106) set X_ 2940 
$node_(106) set Y_ 898 
$node_(106) set Z_ 0.0 
$ns at 0.0 "$node_(106) off" 
$ns at 495.0 "$node_(106) on" 
$node_(107) set X_ 1961 
$node_(107) set Y_ 874 
$node_(107) set Z_ 0.0 
$ns at 0.0 "$node_(107) off" 
$ns at 495.0 "$node_(107) on" 
$node_(108) set X_ 342 
$node_(108) set Y_ 293 
$node_(108) set Z_ 0.0 
$ns at 0.0 "$node_(108) off" 
$ns at 495.0 "$node_(108) on" 
$node_(109) set X_ 1511 
$node_(109) set Y_ 923 
$node_(109) set Z_ 0.0 
$ns at 0.0 "$node_(109) off" 
$ns at 495.0 "$node_(109) on" 
$node_(110) set X_ 1774 
$node_(110) set Y_ 559 
$node_(110) set Z_ 0.0 
$ns at 0.0 "$node_(110) off" 
$ns at 495.0 "$node_(110) on" 
$node_(111) set X_ 459 
$node_(111) set Y_ 390 
$node_(111) set Z_ 0.0 
$ns at 0.0 "$node_(111) off" 
$ns at 495.0 "$node_(111) on" 
$node_(112) set X_ 1481 
$node_(112) set Y_ 689 
$node_(112) set Z_ 0.0 
$ns at 0.0 "$node_(112) off" 
$ns at 495.0 "$node_(112) on" 
$node_(113) set X_ 2901 
$node_(113) set Y_ 882 
$node_(113) set Z_ 0.0 
$ns at 0.0 "$node_(113) off" 
$ns at 495.0 "$node_(113) on" 
$node_(114) set X_ 283 
$node_(114) set Y_ 164 
$node_(114) set Z_ 0.0 
$ns at 0.0 "$node_(114) off" 
$ns at 495.0 "$node_(114) on" 
$node_(115) set X_ 707 
$node_(115) set Y_ 915 
$node_(115) set Z_ 0.0 
$ns at 0.0 "$node_(115) off" 
$ns at 495.0 "$node_(115) on" 
$node_(116) set X_ 1807 
$node_(116) set Y_ 173 
$node_(116) set Z_ 0.0 
$ns at 0.0 "$node_(116) off" 
$ns at 495.0 "$node_(116) on" 
$node_(117) set X_ 1327 
$node_(117) set Y_ 109 
$node_(117) set Z_ 0.0 
$ns at 0.0 "$node_(117) off" 
$ns at 495.0 "$node_(117) on" 
$node_(118) set X_ 684 
$node_(118) set Y_ 915 
$node_(118) set Z_ 0.0 
$ns at 0.0 "$node_(118) off" 
$ns at 495.0 "$node_(118) on" 
$node_(119) set X_ 2411 
$node_(119) set Y_ 226 
$node_(119) set Z_ 0.0 
$ns at 0.0 "$node_(119) off" 
$ns at 495.0 "$node_(119) on" 
$node_(120) set X_ 990 
$node_(120) set Y_ 413 
$node_(120) set Z_ 0.0 
$ns at 0.0 "$node_(120) off" 
$ns at 495.0 "$node_(120) on" 
$node_(121) set X_ 243 
$node_(121) set Y_ 823 
$node_(121) set Z_ 0.0 
$ns at 0.0 "$node_(121) off" 
$ns at 495.0 "$node_(121) on" 
$node_(122) set X_ 738 
$node_(122) set Y_ 869 
$node_(122) set Z_ 0.0 
$ns at 0.0 "$node_(122) off" 
$ns at 495.0 "$node_(122) on" 
$node_(123) set X_ 2546 
$node_(123) set Y_ 361 
$node_(123) set Z_ 0.0 
$ns at 0.0 "$node_(123) off" 
$ns at 495.0 "$node_(123) on" 
$node_(124) set X_ 496 
$node_(124) set Y_ 346 
$node_(124) set Z_ 0.0 
$ns at 0.0 "$node_(124) off" 
$ns at 495.0 "$node_(124) on" 
$node_(125) set X_ 2946 
$node_(125) set Y_ 294 
$node_(125) set Z_ 0.0 
$ns at 0.0 "$node_(125) off" 
$ns at 660.0 "$node_(125) on" 
$node_(126) set X_ 212 
$node_(126) set Y_ 490 
$node_(126) set Z_ 0.0 
$ns at 0.0 "$node_(126) off" 
$ns at 660.0 "$node_(126) on" 
$node_(127) set X_ 351 
$node_(127) set Y_ 73 
$node_(127) set Z_ 0.0 
$ns at 0.0 "$node_(127) off" 
$ns at 660.0 "$node_(127) on" 
$node_(128) set X_ 986 
$node_(128) set Y_ 85 
$node_(128) set Z_ 0.0 
$ns at 0.0 "$node_(128) off" 
$ns at 660.0 "$node_(128) on" 
$node_(129) set X_ 713 
$node_(129) set Y_ 1 
$node_(129) set Z_ 0.0 
$ns at 0.0 "$node_(129) off" 
$ns at 660.0 "$node_(129) on" 
$node_(130) set X_ 2996 
$node_(130) set Y_ 444 
$node_(130) set Z_ 0.0 
$ns at 0.0 "$node_(130) off" 
$ns at 660.0 "$node_(130) on" 
$node_(131) set X_ 995 
$node_(131) set Y_ 558 
$node_(131) set Z_ 0.0 
$ns at 0.0 "$node_(131) off" 
$ns at 660.0 "$node_(131) on" 
$node_(132) set X_ 892 
$node_(132) set Y_ 53 
$node_(132) set Z_ 0.0 
$ns at 0.0 "$node_(132) off" 
$ns at 660.0 "$node_(132) on" 
$node_(133) set X_ 850 
$node_(133) set Y_ 191 
$node_(133) set Z_ 0.0 
$ns at 0.0 "$node_(133) off" 
$ns at 660.0 "$node_(133) on" 
$node_(134) set X_ 2840 
$node_(134) set Y_ 415 
$node_(134) set Z_ 0.0 
$ns at 0.0 "$node_(134) off" 
$ns at 660.0 "$node_(134) on" 
$node_(135) set X_ 2317 
$node_(135) set Y_ 510 
$node_(135) set Z_ 0.0 
$ns at 0.0 "$node_(135) off" 
$ns at 660.0 "$node_(135) on" 
$node_(136) set X_ 993 
$node_(136) set Y_ 734 
$node_(136) set Z_ 0.0 
$ns at 0.0 "$node_(136) off" 
$ns at 660.0 "$node_(136) on" 
$node_(137) set X_ 2913 
$node_(137) set Y_ 529 
$node_(137) set Z_ 0.0 
$ns at 0.0 "$node_(137) off" 
$ns at 660.0 "$node_(137) on" 
$node_(138) set X_ 1423 
$node_(138) set Y_ 960 
$node_(138) set Z_ 0.0 
$ns at 0.0 "$node_(138) off" 
$ns at 660.0 "$node_(138) on" 
$node_(139) set X_ 795 
$node_(139) set Y_ 866 
$node_(139) set Z_ 0.0 
$ns at 0.0 "$node_(139) off" 
$ns at 660.0 "$node_(139) on" 
$node_(140) set X_ 2603 
$node_(140) set Y_ 694 
$node_(140) set Z_ 0.0 
$ns at 0.0 "$node_(140) off" 
$ns at 660.0 "$node_(140) on" 
$node_(141) set X_ 142 
$node_(141) set Y_ 815 
$node_(141) set Z_ 0.0 
$ns at 0.0 "$node_(141) off" 
$ns at 660.0 "$node_(141) on" 
$node_(142) set X_ 234 
$node_(142) set Y_ 665 
$node_(142) set Z_ 0.0 
$ns at 0.0 "$node_(142) off" 
$ns at 660.0 "$node_(142) on" 
$node_(143) set X_ 2637 
$node_(143) set Y_ 794 
$node_(143) set Z_ 0.0 
$ns at 0.0 "$node_(143) off" 
$ns at 660.0 "$node_(143) on" 
$node_(144) set X_ 2683 
$node_(144) set Y_ 760 
$node_(144) set Z_ 0.0 
$ns at 0.0 "$node_(144) off" 
$ns at 660.0 "$node_(144) on" 
$node_(145) set X_ 2877 
$node_(145) set Y_ 969 
$node_(145) set Z_ 0.0 
$ns at 0.0 "$node_(145) off" 
$ns at 660.0 "$node_(145) on" 
$node_(146) set X_ 1453 
$node_(146) set Y_ 134 
$node_(146) set Z_ 0.0 
$ns at 0.0 "$node_(146) off" 
$ns at 660.0 "$node_(146) on" 
$node_(147) set X_ 2656 
$node_(147) set Y_ 784 
$node_(147) set Z_ 0.0 
$ns at 0.0 "$node_(147) off" 
$ns at 660.0 "$node_(147) on" 
$node_(148) set X_ 1998 
$node_(148) set Y_ 502 
$node_(148) set Z_ 0.0 
$ns at 0.0 "$node_(148) off" 
$ns at 660.0 "$node_(148) on" 
$node_(149) set X_ 494 
$node_(149) set Y_ 730 
$node_(149) set Z_ 0.0 
$ns at 0.0 "$node_(149) off" 
$ns at 660.0 "$node_(149) on" 

# Generation of movements
$ns at 0.0 "$node_(0) setdest 2827 563 16.0" 
$ns at 173.1430614337923 "$node_(0) setdest 1130 414 7.0" 
$ns at 258.9536388040276 "$node_(0) setdest 2235 942 8.0" 
$ns at 330.01020832481396 "$node_(0) setdest 1960 445 8.0" 
$ns at 388.1145706181774 "$node_(0) setdest 1406 133 9.0" 
$ns at 435.85589359406623 "$node_(0) setdest 2939 760 10.0" 
$ns at 482.9303050080514 "$node_(0) setdest 2027 352 3.0" 
$ns at 525.8766199429552 "$node_(0) setdest 1258 886 11.0" 
$ns at 644.191823904833 "$node_(0) setdest 180 830 5.0" 
$ns at 693.5214409867508 "$node_(0) setdest 740 637 2.0" 
$ns at 733.3429027875167 "$node_(0) setdest 835 661 6.0" 
$ns at 763.6636868522479 "$node_(0) setdest 1050 458 13.0" 
$ns at 0.0 "$node_(1) setdest 2864 119 16.0" 
$ns at 30.749484353966814 "$node_(1) setdest 1565 93 4.0" 
$ns at 71.70808948877757 "$node_(1) setdest 1791 954 3.0" 
$ns at 120.34051243091022 "$node_(1) setdest 2993 697 17.0" 
$ns at 184.0601543720699 "$node_(1) setdest 1238 434 17.0" 
$ns at 245.2323510988337 "$node_(1) setdest 2580 824 4.0" 
$ns at 307.9023694029983 "$node_(1) setdest 788 173 7.0" 
$ns at 397.0159730376256 "$node_(1) setdest 488 899 19.0" 
$ns at 486.8847498463708 "$node_(1) setdest 723 983 16.0" 
$ns at 525.5659204709041 "$node_(1) setdest 2702 91 1.0" 
$ns at 557.2389998498057 "$node_(1) setdest 1858 299 4.0" 
$ns at 611.4496967030435 "$node_(1) setdest 534 725 15.0" 
$ns at 666.9910058719755 "$node_(1) setdest 434 928 6.0" 
$ns at 717.0159062836598 "$node_(1) setdest 580 625 4.0" 
$ns at 782.7658591899049 "$node_(1) setdest 2786 147 6.0" 
$ns at 861.2254772381204 "$node_(1) setdest 2712 39 7.0" 
$ns at 0.0 "$node_(2) setdest 1244 425 14.0" 
$ns at 111.74499942375336 "$node_(2) setdest 1449 29 16.0" 
$ns at 166.5261107541553 "$node_(2) setdest 489 276 6.0" 
$ns at 248.5254525989334 "$node_(2) setdest 2788 487 2.0" 
$ns at 287.39894644862073 "$node_(2) setdest 1333 26 5.0" 
$ns at 349.8532031867187 "$node_(2) setdest 1353 156 16.0" 
$ns at 471.28679592366467 "$node_(2) setdest 2622 508 12.0" 
$ns at 581.6984254434861 "$node_(2) setdest 1431 311 2.0" 
$ns at 616.3453680874176 "$node_(2) setdest 1743 948 12.0" 
$ns at 738.567407344891 "$node_(2) setdest 1246 987 3.0" 
$ns at 780.5136172803805 "$node_(2) setdest 1943 570 8.0" 
$ns at 847.8353294451068 "$node_(2) setdest 1562 905 17.0" 
$ns at 0.0 "$node_(3) setdest 2421 695 11.0" 
$ns at 125.08579693567971 "$node_(3) setdest 1452 488 17.0" 
$ns at 239.51247017441992 "$node_(3) setdest 1917 334 16.0" 
$ns at 298.11885984801313 "$node_(3) setdest 1817 608 9.0" 
$ns at 366.89784012120344 "$node_(3) setdest 2259 561 8.0" 
$ns at 437.383192322926 "$node_(3) setdest 2008 963 4.0" 
$ns at 491.727039500366 "$node_(3) setdest 2073 186 4.0" 
$ns at 547.4669203417907 "$node_(3) setdest 2630 231 13.0" 
$ns at 698.2389266194178 "$node_(3) setdest 1639 479 12.0" 
$ns at 734.1920471938431 "$node_(3) setdest 1372 388 3.0" 
$ns at 777.1139364034884 "$node_(3) setdest 1597 997 10.0" 
$ns at 834.7301904635664 "$node_(3) setdest 2448 834 11.0" 
$ns at 889.4286003499889 "$node_(3) setdest 2962 743 17.0" 
$ns at 0.0 "$node_(4) setdest 1002 239 6.0" 
$ns at 89.37231878570435 "$node_(4) setdest 1681 215 16.0" 
$ns at 225.32506016533608 "$node_(4) setdest 551 224 2.0" 
$ns at 265.11810669899376 "$node_(4) setdest 1679 89 7.0" 
$ns at 314.0525367007574 "$node_(4) setdest 2311 305 6.0" 
$ns at 393.0942664352839 "$node_(4) setdest 2114 564 3.0" 
$ns at 440.30508244951136 "$node_(4) setdest 2007 710 13.0" 
$ns at 512.1579998980027 "$node_(4) setdest 2319 643 18.0" 
$ns at 598.5959927999364 "$node_(4) setdest 485 993 19.0" 
$ns at 710.1216459477448 "$node_(4) setdest 2618 860 6.0" 
$ns at 794.8349625264301 "$node_(4) setdest 2239 578 16.0" 
$ns at 0.0 "$node_(5) setdest 1012 230 18.0" 
$ns at 119.99722879601329 "$node_(5) setdest 678 615 16.0" 
$ns at 245.93659778342385 "$node_(5) setdest 1429 440 12.0" 
$ns at 285.00280605163346 "$node_(5) setdest 721 820 8.0" 
$ns at 366.47621482418805 "$node_(5) setdest 2007 545 4.0" 
$ns at 411.2600823634614 "$node_(5) setdest 1079 168 2.0" 
$ns at 460.1044242517501 "$node_(5) setdest 1632 702 10.0" 
$ns at 515.6092746458988 "$node_(5) setdest 286 594 2.0" 
$ns at 561.4048050592075 "$node_(5) setdest 686 691 18.0" 
$ns at 731.6669566405981 "$node_(5) setdest 1345 104 8.0" 
$ns at 784.6657869001594 "$node_(5) setdest 2730 263 7.0" 
$ns at 825.3215812484246 "$node_(5) setdest 2562 920 16.0" 
$ns at 887.4471919729519 "$node_(5) setdest 576 573 1.0" 
$ns at 0.0 "$node_(6) setdest 1910 581 13.0" 
$ns at 77.22340214611324 "$node_(6) setdest 2971 223 8.0" 
$ns at 157.30914897449657 "$node_(6) setdest 1026 117 16.0" 
$ns at 200.97476958353528 "$node_(6) setdest 2856 670 3.0" 
$ns at 249.83714514852326 "$node_(6) setdest 1659 711 17.0" 
$ns at 326.6211720395084 "$node_(6) setdest 1912 50 13.0" 
$ns at 455.9618891844564 "$node_(6) setdest 182 482 15.0" 
$ns at 520.0583544236385 "$node_(6) setdest 2860 650 11.0" 
$ns at 558.7492065060135 "$node_(6) setdest 1483 289 3.0" 
$ns at 597.3959092962288 "$node_(6) setdest 1733 574 7.0" 
$ns at 688.9865932863426 "$node_(6) setdest 2356 700 6.0" 
$ns at 770.2341670991962 "$node_(6) setdest 1077 365 20.0" 
$ns at 0.0 "$node_(7) setdest 195 516 11.0" 
$ns at 74.95249419244988 "$node_(7) setdest 2801 594 3.0" 
$ns at 133.01401066926886 "$node_(7) setdest 2615 500 15.0" 
$ns at 246.64809437085069 "$node_(7) setdest 144 702 14.0" 
$ns at 351.1481481904026 "$node_(7) setdest 2320 205 18.0" 
$ns at 429.24921723753414 "$node_(7) setdest 968 600 16.0" 
$ns at 601.728517785663 "$node_(7) setdest 2308 41 20.0" 
$ns at 784.5741531622457 "$node_(7) setdest 1341 800 12.0" 
$ns at 0.0 "$node_(8) setdest 263 980 18.0" 
$ns at 174.50170909499937 "$node_(8) setdest 131 107 11.0" 
$ns at 256.98823313477953 "$node_(8) setdest 721 544 16.0" 
$ns at 328.15558654408494 "$node_(8) setdest 2073 125 5.0" 
$ns at 388.3170431507284 "$node_(8) setdest 1337 961 20.0" 
$ns at 467.6881782418472 "$node_(8) setdest 2524 105 3.0" 
$ns at 524.6823670599541 "$node_(8) setdest 2365 655 10.0" 
$ns at 579.5724074376498 "$node_(8) setdest 1862 914 19.0" 
$ns at 728.906691682718 "$node_(8) setdest 2170 435 8.0" 
$ns at 831.6206429278537 "$node_(8) setdest 2267 118 16.0" 
$ns at 0.0 "$node_(9) setdest 2375 55 11.0" 
$ns at 85.36817705505784 "$node_(9) setdest 319 482 8.0" 
$ns at 137.37393241416976 "$node_(9) setdest 1979 21 2.0" 
$ns at 172.6248574219812 "$node_(9) setdest 1653 378 20.0" 
$ns at 225.83814104689293 "$node_(9) setdest 2533 800 16.0" 
$ns at 257.6127504655068 "$node_(9) setdest 622 888 10.0" 
$ns at 381.66372457539 "$node_(9) setdest 2219 818 15.0" 
$ns at 536.4947980817637 "$node_(9) setdest 685 615 2.0" 
$ns at 585.3989828939667 "$node_(9) setdest 2416 903 14.0" 
$ns at 715.2890250506736 "$node_(9) setdest 1989 470 18.0" 
$ns at 849.452238516805 "$node_(9) setdest 99 47 18.0" 
$ns at 0.0 "$node_(10) setdest 358 958 8.0" 
$ns at 75.00764697316941 "$node_(10) setdest 158 656 3.0" 
$ns at 128.35953018571982 "$node_(10) setdest 648 734 12.0" 
$ns at 219.05088123974176 "$node_(10) setdest 1472 670 1.0" 
$ns at 258.04040306014906 "$node_(10) setdest 191 445 17.0" 
$ns at 363.3162693889226 "$node_(10) setdest 1339 187 19.0" 
$ns at 569.3285209620935 "$node_(10) setdest 794 122 8.0" 
$ns at 669.6820296694933 "$node_(10) setdest 593 512 9.0" 
$ns at 780.0028270239761 "$node_(10) setdest 496 658 13.0" 
$ns at 832.9345882129984 "$node_(10) setdest 1495 753 8.0" 
$ns at 887.5697465648677 "$node_(10) setdest 1059 125 18.0" 
$ns at 0.0 "$node_(11) setdest 253 364 11.0" 
$ns at 82.14428156225912 "$node_(11) setdest 1904 957 1.0" 
$ns at 118.65219440083521 "$node_(11) setdest 742 283 10.0" 
$ns at 191.785449528406 "$node_(11) setdest 2958 271 2.0" 
$ns at 230.04742751089736 "$node_(11) setdest 1779 567 20.0" 
$ns at 410.70230498914873 "$node_(11) setdest 627 837 3.0" 
$ns at 445.40619211050995 "$node_(11) setdest 1032 644 14.0" 
$ns at 565.1823937618411 "$node_(11) setdest 851 475 3.0" 
$ns at 621.3960622333185 "$node_(11) setdest 2408 603 13.0" 
$ns at 655.0740786092808 "$node_(11) setdest 1975 895 9.0" 
$ns at 767.9666548733732 "$node_(11) setdest 2518 154 14.0" 
$ns at 888.7295662574586 "$node_(11) setdest 2883 250 10.0" 
$ns at 0.0 "$node_(12) setdest 1532 152 17.0" 
$ns at 77.2826664306749 "$node_(12) setdest 2614 914 11.0" 
$ns at 169.32952343579265 "$node_(12) setdest 552 833 19.0" 
$ns at 315.0748109672729 "$node_(12) setdest 434 279 16.0" 
$ns at 380.3477298553894 "$node_(12) setdest 2311 156 13.0" 
$ns at 469.61032701634167 "$node_(12) setdest 68 551 18.0" 
$ns at 676.7971583704713 "$node_(12) setdest 2798 892 20.0" 
$ns at 758.3447787871312 "$node_(12) setdest 1560 857 12.0" 
$ns at 841.3546015128687 "$node_(12) setdest 1162 360 19.0" 
$ns at 887.0279554775603 "$node_(12) setdest 976 148 2.0" 
$ns at 0.0 "$node_(13) setdest 1961 954 6.0" 
$ns at 65.20387339776234 "$node_(13) setdest 923 690 19.0" 
$ns at 281.4012817754563 "$node_(13) setdest 2616 846 11.0" 
$ns at 381.97999330861694 "$node_(13) setdest 2582 152 17.0" 
$ns at 484.11593090954784 "$node_(13) setdest 1649 526 2.0" 
$ns at 525.7245859868344 "$node_(13) setdest 1734 560 2.0" 
$ns at 557.4430074154047 "$node_(13) setdest 1048 55 16.0" 
$ns at 631.4369590675998 "$node_(13) setdest 2986 648 9.0" 
$ns at 710.6523711621679 "$node_(13) setdest 848 195 2.0" 
$ns at 750.6116958280194 "$node_(13) setdest 1172 355 18.0" 
$ns at 794.7916434753901 "$node_(13) setdest 2773 793 7.0" 
$ns at 844.2885114103663 "$node_(13) setdest 2628 509 20.0" 
$ns at 0.0 "$node_(14) setdest 1518 74 12.0" 
$ns at 54.893763389080235 "$node_(14) setdest 818 957 2.0" 
$ns at 86.56798110894297 "$node_(14) setdest 21 733 19.0" 
$ns at 287.51005906329726 "$node_(14) setdest 1525 653 7.0" 
$ns at 347.9838676529036 "$node_(14) setdest 1813 976 15.0" 
$ns at 388.61969821567885 "$node_(14) setdest 1566 497 13.0" 
$ns at 541.4756027824469 "$node_(14) setdest 277 898 3.0" 
$ns at 599.5258342850017 "$node_(14) setdest 2753 917 10.0" 
$ns at 691.8432573963164 "$node_(14) setdest 422 840 5.0" 
$ns at 765.8420885276948 "$node_(14) setdest 2552 478 18.0" 
$ns at 0.0 "$node_(15) setdest 1494 637 4.0" 
$ns at 55.1503071422802 "$node_(15) setdest 2676 46 19.0" 
$ns at 146.70297779838876 "$node_(15) setdest 1529 877 4.0" 
$ns at 190.3985925930135 "$node_(15) setdest 2557 249 8.0" 
$ns at 293.99530054612757 "$node_(15) setdest 1677 586 1.0" 
$ns at 327.7189294067354 "$node_(15) setdest 2419 292 3.0" 
$ns at 374.9696766002038 "$node_(15) setdest 896 972 8.0" 
$ns at 454.50799758477143 "$node_(15) setdest 2422 354 2.0" 
$ns at 504.470293682561 "$node_(15) setdest 2342 122 13.0" 
$ns at 626.0576732803966 "$node_(15) setdest 85 127 4.0" 
$ns at 668.3464285505537 "$node_(15) setdest 2566 811 8.0" 
$ns at 731.3841256006011 "$node_(15) setdest 952 235 20.0" 
$ns at 0.0 "$node_(16) setdest 1336 796 13.0" 
$ns at 44.57688095236668 "$node_(16) setdest 1225 572 19.0" 
$ns at 262.0466219722608 "$node_(16) setdest 1688 257 13.0" 
$ns at 305.8677534097276 "$node_(16) setdest 817 812 19.0" 
$ns at 520.7415529293742 "$node_(16) setdest 540 268 10.0" 
$ns at 563.9444994430785 "$node_(16) setdest 1049 634 10.0" 
$ns at 612.182190346607 "$node_(16) setdest 961 455 3.0" 
$ns at 655.7359085757125 "$node_(16) setdest 1952 405 4.0" 
$ns at 699.414153526583 "$node_(16) setdest 2934 217 16.0" 
$ns at 769.9695915962463 "$node_(16) setdest 2885 362 15.0" 
$ns at 883.8793623515643 "$node_(16) setdest 2202 179 18.0" 
$ns at 0.0 "$node_(17) setdest 1946 543 18.0" 
$ns at 73.27025606132469 "$node_(17) setdest 538 747 4.0" 
$ns at 108.1266647240266 "$node_(17) setdest 2379 12 9.0" 
$ns at 209.9538715980477 "$node_(17) setdest 1532 923 2.0" 
$ns at 258.9831918952525 "$node_(17) setdest 1939 117 13.0" 
$ns at 319.7067190693318 "$node_(17) setdest 2725 779 4.0" 
$ns at 371.3290691175585 "$node_(17) setdest 1951 828 13.0" 
$ns at 523.3819962624627 "$node_(17) setdest 1689 218 7.0" 
$ns at 579.7888640574616 "$node_(17) setdest 1501 407 10.0" 
$ns at 634.416247608824 "$node_(17) setdest 1397 932 5.0" 
$ns at 703.4277035264491 "$node_(17) setdest 2990 936 5.0" 
$ns at 766.0769986836538 "$node_(17) setdest 953 697 5.0" 
$ns at 807.7256275722452 "$node_(17) setdest 2017 470 11.0" 
$ns at 0.0 "$node_(18) setdest 546 392 15.0" 
$ns at 131.9930334802122 "$node_(18) setdest 1293 846 14.0" 
$ns at 293.43480725437314 "$node_(18) setdest 2199 399 1.0" 
$ns at 330.852298753899 "$node_(18) setdest 2067 389 10.0" 
$ns at 402.7041731259374 "$node_(18) setdest 670 268 15.0" 
$ns at 441.08723715070715 "$node_(18) setdest 2260 77 18.0" 
$ns at 605.0788285774506 "$node_(18) setdest 1570 801 1.0" 
$ns at 637.0840881766522 "$node_(18) setdest 1296 888 4.0" 
$ns at 690.0648013917735 "$node_(18) setdest 2573 937 13.0" 
$ns at 838.1036921096551 "$node_(18) setdest 320 390 1.0" 
$ns at 868.2525963724548 "$node_(18) setdest 269 100 12.0" 
$ns at 0.0 "$node_(19) setdest 2288 809 1.0" 
$ns at 34.52906088470851 "$node_(19) setdest 2031 881 9.0" 
$ns at 148.04907113978723 "$node_(19) setdest 2123 128 19.0" 
$ns at 304.75959163579364 "$node_(19) setdest 1972 226 20.0" 
$ns at 404.0526113961595 "$node_(19) setdest 2931 952 1.0" 
$ns at 436.9917861653274 "$node_(19) setdest 828 502 8.0" 
$ns at 531.6449534999687 "$node_(19) setdest 1958 185 3.0" 
$ns at 591.2778739557666 "$node_(19) setdest 368 97 1.0" 
$ns at 622.8423730139488 "$node_(19) setdest 1780 779 8.0" 
$ns at 720.7849867489358 "$node_(19) setdest 2664 443 17.0" 
$ns at 895.4179459925958 "$node_(19) setdest 928 71 8.0" 
$ns at 0.0 "$node_(20) setdest 310 611 15.0" 
$ns at 30.920266796089102 "$node_(20) setdest 2914 483 20.0" 
$ns at 82.51381659599465 "$node_(20) setdest 1435 874 8.0" 
$ns at 142.79417060014717 "$node_(20) setdest 2373 602 6.0" 
$ns at 173.83228439592915 "$node_(20) setdest 2095 873 2.0" 
$ns at 208.9033524324628 "$node_(20) setdest 793 913 17.0" 
$ns at 357.51129345439625 "$node_(20) setdest 2385 289 19.0" 
$ns at 472.14257514571943 "$node_(20) setdest 31 698 17.0" 
$ns at 623.1278743280202 "$node_(20) setdest 1363 167 5.0" 
$ns at 696.2663764769732 "$node_(20) setdest 606 875 13.0" 
$ns at 786.3573138466719 "$node_(20) setdest 2626 276 2.0" 
$ns at 823.3366040960221 "$node_(20) setdest 2452 797 9.0" 
$ns at 0.0 "$node_(21) setdest 118 161 8.0" 
$ns at 90.29159639143961 "$node_(21) setdest 623 282 13.0" 
$ns at 213.17867472344156 "$node_(21) setdest 1532 780 18.0" 
$ns at 322.82783982518447 "$node_(21) setdest 2153 381 17.0" 
$ns at 420.35376935692506 "$node_(21) setdest 365 854 16.0" 
$ns at 562.7338861897083 "$node_(21) setdest 1031 679 4.0" 
$ns at 619.3516976282492 "$node_(21) setdest 501 357 10.0" 
$ns at 724.2320452415823 "$node_(21) setdest 2023 114 5.0" 
$ns at 762.8471381538232 "$node_(21) setdest 2876 756 9.0" 
$ns at 819.2011439428039 "$node_(21) setdest 1779 624 8.0" 
$ns at 891.4883507086791 "$node_(21) setdest 2593 915 18.0" 
$ns at 0.0 "$node_(22) setdest 1474 96 12.0" 
$ns at 148.51227072065123 "$node_(22) setdest 568 810 1.0" 
$ns at 182.69839587621382 "$node_(22) setdest 2910 435 7.0" 
$ns at 268.7395070968954 "$node_(22) setdest 1533 435 12.0" 
$ns at 385.61561886886 "$node_(22) setdest 833 727 4.0" 
$ns at 438.6144581866639 "$node_(22) setdest 1013 556 11.0" 
$ns at 560.5776674364482 "$node_(22) setdest 2893 801 13.0" 
$ns at 618.8336633690092 "$node_(22) setdest 589 198 10.0" 
$ns at 700.5580392797342 "$node_(22) setdest 1488 688 19.0" 
$ns at 786.2884644020537 "$node_(22) setdest 1560 23 19.0" 
$ns at 867.1473215035592 "$node_(22) setdest 2449 755 10.0" 
$ns at 0.0 "$node_(23) setdest 2823 980 9.0" 
$ns at 84.4026468570715 "$node_(23) setdest 274 534 8.0" 
$ns at 137.2813771750969 "$node_(23) setdest 2582 872 13.0" 
$ns at 239.683329514287 "$node_(23) setdest 381 510 16.0" 
$ns at 284.55926544811877 "$node_(23) setdest 1206 751 4.0" 
$ns at 337.9314310434513 "$node_(23) setdest 604 396 7.0" 
$ns at 407.4045154928446 "$node_(23) setdest 342 264 6.0" 
$ns at 459.795958761359 "$node_(23) setdest 882 658 5.0" 
$ns at 504.13923779445696 "$node_(23) setdest 111 356 1.0" 
$ns at 536.3571632743123 "$node_(23) setdest 2856 306 1.0" 
$ns at 571.502502410262 "$node_(23) setdest 2984 977 2.0" 
$ns at 620.8591658864971 "$node_(23) setdest 861 236 3.0" 
$ns at 673.0136421653385 "$node_(23) setdest 674 681 19.0" 
$ns at 829.8027634396742 "$node_(23) setdest 2494 622 6.0" 
$ns at 879.9989212111334 "$node_(23) setdest 2140 258 19.0" 
$ns at 0.0 "$node_(24) setdest 751 149 2.0" 
$ns at 37.511903599037254 "$node_(24) setdest 2528 813 1.0" 
$ns at 72.2742056509729 "$node_(24) setdest 439 81 15.0" 
$ns at 237.36234305664433 "$node_(24) setdest 663 908 6.0" 
$ns at 285.33191788183194 "$node_(24) setdest 1315 463 1.0" 
$ns at 318.27094862364686 "$node_(24) setdest 2404 687 11.0" 
$ns at 450.50307825770665 "$node_(24) setdest 192 951 4.0" 
$ns at 501.90364723836944 "$node_(24) setdest 1978 114 1.0" 
$ns at 541.5479073270631 "$node_(24) setdest 2953 55 9.0" 
$ns at 611.4819638537892 "$node_(24) setdest 108 720 19.0" 
$ns at 670.8013213139834 "$node_(24) setdest 2198 808 11.0" 
$ns at 727.0385123329876 "$node_(24) setdest 1552 514 11.0" 
$ns at 771.4565561294907 "$node_(24) setdest 2999 132 19.0" 
$ns at 0.0 "$node_(25) setdest 1366 933 10.0" 
$ns at 84.72983021681488 "$node_(25) setdest 2952 421 1.0" 
$ns at 122.90684824590544 "$node_(25) setdest 2995 1 10.0" 
$ns at 160.74994599813647 "$node_(25) setdest 1520 109 14.0" 
$ns at 311.51504133280685 "$node_(25) setdest 1040 62 7.0" 
$ns at 411.24669845301173 "$node_(25) setdest 360 247 13.0" 
$ns at 499.8436785790534 "$node_(25) setdest 267 765 5.0" 
$ns at 543.3431562273981 "$node_(25) setdest 2108 350 15.0" 
$ns at 715.2967902927596 "$node_(25) setdest 2220 158 12.0" 
$ns at 793.7622616233386 "$node_(25) setdest 840 46 13.0" 
$ns at 846.7511961216162 "$node_(25) setdest 2518 75 1.0" 
$ns at 881.4033247012298 "$node_(25) setdest 164 279 18.0" 
$ns at 0.0 "$node_(26) setdest 678 173 18.0" 
$ns at 32.322841263690876 "$node_(26) setdest 2671 106 3.0" 
$ns at 86.66346409883609 "$node_(26) setdest 1048 298 5.0" 
$ns at 160.75350785401858 "$node_(26) setdest 2190 344 3.0" 
$ns at 196.26194847937046 "$node_(26) setdest 2202 39 17.0" 
$ns at 231.42532801233347 "$node_(26) setdest 2089 583 1.0" 
$ns at 269.2936755780735 "$node_(26) setdest 2878 655 20.0" 
$ns at 481.0402329374473 "$node_(26) setdest 2561 354 6.0" 
$ns at 532.3299606228243 "$node_(26) setdest 2296 728 14.0" 
$ns at 569.8908409905932 "$node_(26) setdest 2626 448 18.0" 
$ns at 675.443737116879 "$node_(26) setdest 457 220 16.0" 
$ns at 844.6583630260643 "$node_(26) setdest 308 673 20.0" 
$ns at 0.0 "$node_(27) setdest 1753 808 8.0" 
$ns at 93.90694194183911 "$node_(27) setdest 2199 557 3.0" 
$ns at 126.99624048051693 "$node_(27) setdest 1979 651 17.0" 
$ns at 214.7399649729719 "$node_(27) setdest 388 778 7.0" 
$ns at 281.19996774327973 "$node_(27) setdest 2597 981 16.0" 
$ns at 411.1521580737345 "$node_(27) setdest 1444 327 1.0" 
$ns at 450.39447389129714 "$node_(27) setdest 824 163 4.0" 
$ns at 500.6486320784116 "$node_(27) setdest 953 685 15.0" 
$ns at 555.0982210613586 "$node_(27) setdest 901 115 12.0" 
$ns at 628.8405310792547 "$node_(27) setdest 1790 528 12.0" 
$ns at 684.0469085593933 "$node_(27) setdest 2622 240 12.0" 
$ns at 724.8828434977121 "$node_(27) setdest 1115 730 1.0" 
$ns at 757.8362204138965 "$node_(27) setdest 1968 257 7.0" 
$ns at 854.5708778092707 "$node_(27) setdest 791 687 8.0" 
$ns at 0.0 "$node_(28) setdest 435 581 3.0" 
$ns at 39.296177080709754 "$node_(28) setdest 707 223 9.0" 
$ns at 101.95755263077564 "$node_(28) setdest 2393 142 15.0" 
$ns at 185.694038028305 "$node_(28) setdest 1196 610 1.0" 
$ns at 219.90395695949854 "$node_(28) setdest 1567 791 15.0" 
$ns at 309.81172098344143 "$node_(28) setdest 2540 458 5.0" 
$ns at 370.6306281149806 "$node_(28) setdest 487 686 10.0" 
$ns at 431.5144531902976 "$node_(28) setdest 2261 508 4.0" 
$ns at 463.56915450678997 "$node_(28) setdest 2483 303 3.0" 
$ns at 498.89731886710473 "$node_(28) setdest 658 587 14.0" 
$ns at 610.6473849940645 "$node_(28) setdest 577 968 13.0" 
$ns at 683.3899551461491 "$node_(28) setdest 1822 247 8.0" 
$ns at 723.4292515944516 "$node_(28) setdest 360 45 3.0" 
$ns at 758.4408151859407 "$node_(28) setdest 1081 863 9.0" 
$ns at 853.1353202177911 "$node_(28) setdest 679 199 15.0" 
$ns at 0.0 "$node_(29) setdest 1595 202 5.0" 
$ns at 66.40325525229804 "$node_(29) setdest 755 339 2.0" 
$ns at 111.6846103311855 "$node_(29) setdest 1559 738 2.0" 
$ns at 156.14144515841878 "$node_(29) setdest 1035 182 16.0" 
$ns at 335.7857565543287 "$node_(29) setdest 2241 230 12.0" 
$ns at 472.4241209388607 "$node_(29) setdest 1896 542 10.0" 
$ns at 598.3916376910307 "$node_(29) setdest 808 331 13.0" 
$ns at 634.2949813350983 "$node_(29) setdest 2027 761 14.0" 
$ns at 668.8738893470818 "$node_(29) setdest 1662 255 2.0" 
$ns at 710.9988316337823 "$node_(29) setdest 2086 926 6.0" 
$ns at 747.6716856866395 "$node_(29) setdest 2747 758 15.0" 
$ns at 786.4621048526095 "$node_(29) setdest 1962 751 8.0" 
$ns at 847.6261365492835 "$node_(29) setdest 1049 966 9.0" 
$ns at 0.0 "$node_(30) setdest 1743 293 17.0" 
$ns at 75.00919933372586 "$node_(30) setdest 2236 818 16.0" 
$ns at 170.2662178048969 "$node_(30) setdest 2224 866 20.0" 
$ns at 299.84043587687677 "$node_(30) setdest 2180 128 12.0" 
$ns at 411.85232809820775 "$node_(30) setdest 1545 831 16.0" 
$ns at 526.3838913549339 "$node_(30) setdest 1800 557 4.0" 
$ns at 557.9237420401048 "$node_(30) setdest 301 128 2.0" 
$ns at 590.894910593667 "$node_(30) setdest 458 4 17.0" 
$ns at 632.8266628935366 "$node_(30) setdest 1209 710 9.0" 
$ns at 752.4510297345911 "$node_(30) setdest 861 179 2.0" 
$ns at 790.4117605924199 "$node_(30) setdest 2181 271 2.0" 
$ns at 831.7757798153058 "$node_(30) setdest 2196 396 14.0" 
$ns at 875.4783527989708 "$node_(30) setdest 382 908 9.0" 
$ns at 0.0 "$node_(31) setdest 953 833 8.0" 
$ns at 55.14100265230752 "$node_(31) setdest 1622 622 11.0" 
$ns at 179.38225466453687 "$node_(31) setdest 1653 797 2.0" 
$ns at 227.0517714854424 "$node_(31) setdest 161 785 12.0" 
$ns at 286.7266308667802 "$node_(31) setdest 1448 755 12.0" 
$ns at 322.61793813525094 "$node_(31) setdest 2786 987 3.0" 
$ns at 359.3948352807535 "$node_(31) setdest 309 151 9.0" 
$ns at 443.59277314464816 "$node_(31) setdest 725 892 18.0" 
$ns at 505.17236527164744 "$node_(31) setdest 2263 279 5.0" 
$ns at 536.5839216912277 "$node_(31) setdest 755 9 10.0" 
$ns at 620.423929484811 "$node_(31) setdest 892 733 11.0" 
$ns at 704.6019401910908 "$node_(31) setdest 2596 513 4.0" 
$ns at 746.5758874666466 "$node_(31) setdest 72 205 10.0" 
$ns at 851.2337156472854 "$node_(31) setdest 2409 522 2.0" 
$ns at 894.1931383848254 "$node_(31) setdest 1647 640 7.0" 
$ns at 0.0 "$node_(32) setdest 1018 456 11.0" 
$ns at 115.75234527617356 "$node_(32) setdest 516 38 17.0" 
$ns at 205.15944582767142 "$node_(32) setdest 2175 396 20.0" 
$ns at 243.18062152740558 "$node_(32) setdest 1353 396 12.0" 
$ns at 341.45503554714 "$node_(32) setdest 1958 569 7.0" 
$ns at 432.55518015921757 "$node_(32) setdest 2902 585 2.0" 
$ns at 470.34670059181025 "$node_(32) setdest 1158 363 18.0" 
$ns at 549.6007251109074 "$node_(32) setdest 1589 166 16.0" 
$ns at 668.3398787760779 "$node_(32) setdest 1224 510 9.0" 
$ns at 762.3878451130395 "$node_(32) setdest 899 416 15.0" 
$ns at 831.3632473339434 "$node_(32) setdest 2127 339 19.0" 
$ns at 0.0 "$node_(33) setdest 1738 92 18.0" 
$ns at 174.2819908700953 "$node_(33) setdest 211 238 16.0" 
$ns at 305.7581016433161 "$node_(33) setdest 740 689 4.0" 
$ns at 367.8319363114298 "$node_(33) setdest 2888 724 13.0" 
$ns at 413.64914323675754 "$node_(33) setdest 246 231 17.0" 
$ns at 501.87408392240854 "$node_(33) setdest 2762 756 1.0" 
$ns at 537.532147601762 "$node_(33) setdest 1405 838 14.0" 
$ns at 650.1702804203369 "$node_(33) setdest 1514 203 16.0" 
$ns at 745.0456512487941 "$node_(33) setdest 621 618 9.0" 
$ns at 842.0968004121787 "$node_(33) setdest 654 587 10.0" 
$ns at 0.0 "$node_(34) setdest 1312 625 4.0" 
$ns at 45.71800889952096 "$node_(34) setdest 2958 526 13.0" 
$ns at 122.23611530900467 "$node_(34) setdest 2683 931 6.0" 
$ns at 188.06167161425128 "$node_(34) setdest 204 487 12.0" 
$ns at 305.9983069402977 "$node_(34) setdest 2999 54 5.0" 
$ns at 351.33714960713974 "$node_(34) setdest 1527 779 11.0" 
$ns at 442.384181419927 "$node_(34) setdest 1552 282 14.0" 
$ns at 600.9607193829627 "$node_(34) setdest 1494 897 8.0" 
$ns at 702.413827515873 "$node_(34) setdest 2302 651 14.0" 
$ns at 742.1281964092732 "$node_(34) setdest 735 643 7.0" 
$ns at 779.98277404303 "$node_(34) setdest 1895 605 1.0" 
$ns at 819.9563325798672 "$node_(34) setdest 720 638 7.0" 
$ns at 852.0489659772779 "$node_(34) setdest 2533 600 3.0" 
$ns at 883.4474721967113 "$node_(34) setdest 23 146 1.0" 
$ns at 0.0 "$node_(35) setdest 904 175 20.0" 
$ns at 60.790131319413575 "$node_(35) setdest 2162 336 10.0" 
$ns at 140.31153415639614 "$node_(35) setdest 1145 256 15.0" 
$ns at 229.67089259177433 "$node_(35) setdest 852 391 3.0" 
$ns at 276.06949520261225 "$node_(35) setdest 1534 725 6.0" 
$ns at 361.77421559740264 "$node_(35) setdest 2271 91 13.0" 
$ns at 467.2670007268491 "$node_(35) setdest 1406 505 5.0" 
$ns at 542.4892948881873 "$node_(35) setdest 664 787 8.0" 
$ns at 594.6523827196713 "$node_(35) setdest 476 689 2.0" 
$ns at 628.5642992279053 "$node_(35) setdest 1385 885 5.0" 
$ns at 671.2564392721498 "$node_(35) setdest 2559 497 11.0" 
$ns at 701.8882345534291 "$node_(35) setdest 218 261 6.0" 
$ns at 742.2079995840026 "$node_(35) setdest 383 47 18.0" 
$ns at 899.1407285225573 "$node_(35) setdest 2556 224 4.0" 
$ns at 0.0 "$node_(36) setdest 2980 246 13.0" 
$ns at 90.89669655562315 "$node_(36) setdest 1794 954 16.0" 
$ns at 163.0256252929409 "$node_(36) setdest 2841 292 8.0" 
$ns at 236.8373404095617 "$node_(36) setdest 2006 521 18.0" 
$ns at 426.39329404852174 "$node_(36) setdest 2837 578 19.0" 
$ns at 506.46560382679706 "$node_(36) setdest 2770 916 13.0" 
$ns at 590.5140905973063 "$node_(36) setdest 1583 3 15.0" 
$ns at 627.4166344242107 "$node_(36) setdest 2702 715 19.0" 
$ns at 752.28704992349 "$node_(36) setdest 1740 962 19.0" 
$ns at 802.5052448328362 "$node_(36) setdest 1070 279 9.0" 
$ns at 893.6002076684865 "$node_(36) setdest 1451 541 11.0" 
$ns at 0.0 "$node_(37) setdest 1550 634 13.0" 
$ns at 73.57149873672586 "$node_(37) setdest 1886 685 10.0" 
$ns at 121.0403204061343 "$node_(37) setdest 1982 426 19.0" 
$ns at 234.48856703532775 "$node_(37) setdest 1606 348 10.0" 
$ns at 344.1218515097094 "$node_(37) setdest 2712 590 1.0" 
$ns at 374.7743681746166 "$node_(37) setdest 209 908 20.0" 
$ns at 505.17047022197926 "$node_(37) setdest 848 642 19.0" 
$ns at 701.2300581749677 "$node_(37) setdest 1482 362 12.0" 
$ns at 832.4874920586617 "$node_(37) setdest 1545 714 5.0" 
$ns at 863.5880787309068 "$node_(37) setdest 1012 68 12.0" 
$ns at 0.0 "$node_(38) setdest 124 758 16.0" 
$ns at 62.78112326434062 "$node_(38) setdest 984 53 20.0" 
$ns at 273.2294217904616 "$node_(38) setdest 657 531 16.0" 
$ns at 429.78578579660166 "$node_(38) setdest 2611 162 8.0" 
$ns at 495.0392766693588 "$node_(38) setdest 2312 282 10.0" 
$ns at 550.3270663912341 "$node_(38) setdest 2439 562 15.0" 
$ns at 690.7359236394162 "$node_(38) setdest 2591 270 15.0" 
$ns at 773.7620484350596 "$node_(38) setdest 1461 375 2.0" 
$ns at 811.8317999360811 "$node_(38) setdest 1265 515 19.0" 
$ns at 0.0 "$node_(39) setdest 783 456 18.0" 
$ns at 144.15316311384015 "$node_(39) setdest 1622 420 8.0" 
$ns at 196.57725219709573 "$node_(39) setdest 285 587 1.0" 
$ns at 235.03776869037972 "$node_(39) setdest 356 163 2.0" 
$ns at 269.35042403770547 "$node_(39) setdest 2505 604 4.0" 
$ns at 310.64008761256554 "$node_(39) setdest 182 11 17.0" 
$ns at 421.5073154210596 "$node_(39) setdest 703 234 17.0" 
$ns at 560.2770261440686 "$node_(39) setdest 2030 927 9.0" 
$ns at 677.9154933801592 "$node_(39) setdest 2828 652 17.0" 
$ns at 718.2114848541272 "$node_(39) setdest 401 147 8.0" 
$ns at 826.0284023801069 "$node_(39) setdest 2846 36 2.0" 
$ns at 857.3461656671489 "$node_(39) setdest 216 590 1.0" 
$ns at 890.8550384130691 "$node_(39) setdest 642 627 9.0" 
$ns at 0.0 "$node_(40) setdest 2271 270 13.0" 
$ns at 66.26587213003876 "$node_(40) setdest 1475 87 16.0" 
$ns at 246.52920628327848 "$node_(40) setdest 1113 88 5.0" 
$ns at 277.2694098166489 "$node_(40) setdest 1680 141 16.0" 
$ns at 430.6904231231985 "$node_(40) setdest 937 660 12.0" 
$ns at 553.481777316162 "$node_(40) setdest 1097 809 17.0" 
$ns at 652.8846972709787 "$node_(40) setdest 1852 69 12.0" 
$ns at 788.2583904033529 "$node_(40) setdest 2440 717 8.0" 
$ns at 864.7433686258743 "$node_(40) setdest 2593 683 17.0" 
$ns at 0.0 "$node_(41) setdest 566 272 4.0" 
$ns at 67.25466277883513 "$node_(41) setdest 524 445 9.0" 
$ns at 165.52331318151843 "$node_(41) setdest 1359 723 8.0" 
$ns at 263.6721590262307 "$node_(41) setdest 521 265 11.0" 
$ns at 396.2417782157868 "$node_(41) setdest 2696 367 5.0" 
$ns at 472.62514856468215 "$node_(41) setdest 81 424 4.0" 
$ns at 516.2258192175616 "$node_(41) setdest 2720 424 8.0" 
$ns at 611.0307218572408 "$node_(41) setdest 2732 116 2.0" 
$ns at 660.8631199708536 "$node_(41) setdest 2356 357 18.0" 
$ns at 799.7011876386046 "$node_(41) setdest 1605 540 17.0" 
$ns at 0.0 "$node_(42) setdest 2822 643 17.0" 
$ns at 48.035203953708645 "$node_(42) setdest 1737 181 11.0" 
$ns at 97.40749251168933 "$node_(42) setdest 2569 281 8.0" 
$ns at 164.306462422301 "$node_(42) setdest 456 162 6.0" 
$ns at 227.00119504123333 "$node_(42) setdest 1882 538 16.0" 
$ns at 271.8785233744274 "$node_(42) setdest 1940 839 3.0" 
$ns at 330.3072825223103 "$node_(42) setdest 104 723 6.0" 
$ns at 418.3022934183962 "$node_(42) setdest 1781 999 17.0" 
$ns at 572.0618843592142 "$node_(42) setdest 1190 989 18.0" 
$ns at 697.5785833838058 "$node_(42) setdest 1150 336 16.0" 
$ns at 741.2245463293102 "$node_(42) setdest 2068 447 8.0" 
$ns at 844.4069397762573 "$node_(42) setdest 2902 86 10.0" 
$ns at 0.0 "$node_(43) setdest 2009 104 8.0" 
$ns at 47.27141788064425 "$node_(43) setdest 2710 956 8.0" 
$ns at 112.29204237554914 "$node_(43) setdest 2986 395 3.0" 
$ns at 170.94952749644708 "$node_(43) setdest 1069 766 15.0" 
$ns at 290.4906203270033 "$node_(43) setdest 1720 334 4.0" 
$ns at 322.0203788092172 "$node_(43) setdest 2756 427 19.0" 
$ns at 489.98273922923136 "$node_(43) setdest 1888 544 10.0" 
$ns at 599.8788452903352 "$node_(43) setdest 1092 156 12.0" 
$ns at 647.7965641698361 "$node_(43) setdest 713 698 9.0" 
$ns at 764.335768634454 "$node_(43) setdest 2091 78 3.0" 
$ns at 821.261862128534 "$node_(43) setdest 883 129 19.0" 
$ns at 0.0 "$node_(44) setdest 335 600 13.0" 
$ns at 74.17236235481974 "$node_(44) setdest 530 633 14.0" 
$ns at 164.56024961253553 "$node_(44) setdest 2177 215 7.0" 
$ns at 231.64077658324078 "$node_(44) setdest 1731 735 9.0" 
$ns at 263.02907627674585 "$node_(44) setdest 586 612 3.0" 
$ns at 307.27811982260846 "$node_(44) setdest 741 942 18.0" 
$ns at 464.72312560256574 "$node_(44) setdest 1758 254 12.0" 
$ns at 589.0611846131418 "$node_(44) setdest 1919 740 2.0" 
$ns at 627.7541262285026 "$node_(44) setdest 300 808 16.0" 
$ns at 723.7768560438986 "$node_(44) setdest 2080 369 12.0" 
$ns at 828.8728873047162 "$node_(44) setdest 1598 78 16.0" 
$ns at 0.0 "$node_(45) setdest 717 634 17.0" 
$ns at 181.7982702909402 "$node_(45) setdest 1707 328 4.0" 
$ns at 213.02525513314967 "$node_(45) setdest 2320 278 12.0" 
$ns at 276.310486781643 "$node_(45) setdest 837 145 15.0" 
$ns at 357.5118164812968 "$node_(45) setdest 1749 690 20.0" 
$ns at 418.3972259637612 "$node_(45) setdest 1297 239 13.0" 
$ns at 512.967565183617 "$node_(45) setdest 1393 950 5.0" 
$ns at 549.1926092034096 "$node_(45) setdest 1472 818 16.0" 
$ns at 611.8193604818179 "$node_(45) setdest 1546 507 10.0" 
$ns at 689.1674009489136 "$node_(45) setdest 1174 434 8.0" 
$ns at 786.2522674118686 "$node_(45) setdest 2261 989 4.0" 
$ns at 817.6213077332745 "$node_(45) setdest 1464 451 20.0" 
$ns at 0.0 "$node_(46) setdest 1600 915 13.0" 
$ns at 99.07002089360088 "$node_(46) setdest 779 518 15.0" 
$ns at 176.41082112733596 "$node_(46) setdest 31 349 7.0" 
$ns at 258.2796829599913 "$node_(46) setdest 1955 703 14.0" 
$ns at 313.5616267862169 "$node_(46) setdest 415 736 17.0" 
$ns at 351.79896902675364 "$node_(46) setdest 487 177 3.0" 
$ns at 384.51889335933475 "$node_(46) setdest 2811 466 15.0" 
$ns at 449.683533044902 "$node_(46) setdest 115 590 6.0" 
$ns at 514.1529053891621 "$node_(46) setdest 53 916 3.0" 
$ns at 561.3439433636776 "$node_(46) setdest 574 541 8.0" 
$ns at 647.5747023931314 "$node_(46) setdest 1823 6 15.0" 
$ns at 763.5365499057796 "$node_(46) setdest 2105 779 20.0" 
$ns at 801.9258499457006 "$node_(46) setdest 1677 520 19.0" 
$ns at 0.0 "$node_(47) setdest 55 34 20.0" 
$ns at 198.26304887065368 "$node_(47) setdest 249 731 4.0" 
$ns at 253.21122011021134 "$node_(47) setdest 667 620 7.0" 
$ns at 347.2360244047695 "$node_(47) setdest 586 85 1.0" 
$ns at 386.5828225383067 "$node_(47) setdest 2893 210 20.0" 
$ns at 600.4384686778596 "$node_(47) setdest 337 970 20.0" 
$ns at 675.746437985475 "$node_(47) setdest 2826 415 11.0" 
$ns at 814.8945605850805 "$node_(47) setdest 256 840 9.0" 
$ns at 895.3748516321007 "$node_(47) setdest 80 79 12.0" 
$ns at 0.0 "$node_(48) setdest 1240 210 10.0" 
$ns at 58.624820291232645 "$node_(48) setdest 1223 422 8.0" 
$ns at 129.06670891543038 "$node_(48) setdest 1862 291 1.0" 
$ns at 164.86447161686368 "$node_(48) setdest 1087 424 4.0" 
$ns at 203.67046592574815 "$node_(48) setdest 110 295 8.0" 
$ns at 256.7645087808113 "$node_(48) setdest 1561 107 6.0" 
$ns at 294.5671152786664 "$node_(48) setdest 811 663 1.0" 
$ns at 331.09915002130464 "$node_(48) setdest 2188 597 13.0" 
$ns at 396.37419893855406 "$node_(48) setdest 935 746 8.0" 
$ns at 485.84516966692325 "$node_(48) setdest 2678 121 13.0" 
$ns at 587.4608292339985 "$node_(48) setdest 763 713 18.0" 
$ns at 741.9217853095943 "$node_(48) setdest 1153 318 13.0" 
$ns at 859.3939674050596 "$node_(48) setdest 2621 686 8.0" 
$ns at 893.5526873010239 "$node_(48) setdest 2737 530 8.0" 
$ns at 0.0 "$node_(49) setdest 1648 399 2.0" 
$ns at 47.43806115162416 "$node_(49) setdest 2812 947 19.0" 
$ns at 96.87497949152227 "$node_(49) setdest 821 879 8.0" 
$ns at 151.0510388765799 "$node_(49) setdest 40 767 17.0" 
$ns at 319.1484452689515 "$node_(49) setdest 2183 921 17.0" 
$ns at 490.8522779943721 "$node_(49) setdest 1991 753 17.0" 
$ns at 558.960180344768 "$node_(49) setdest 2013 392 1.0" 
$ns at 593.8380278167846 "$node_(49) setdest 1961 839 2.0" 
$ns at 641.0950759228149 "$node_(49) setdest 382 614 4.0" 
$ns at 692.985286147114 "$node_(49) setdest 2321 674 4.0" 
$ns at 757.77375456806 "$node_(49) setdest 320 358 15.0" 
$ns at 885.8972446602252 "$node_(49) setdest 1499 259 2.0" 
$ns at 0.0 "$node_(50) setdest 2563 214 19.0" 
$ns at 98.74070852573801 "$node_(50) setdest 412 54 5.0" 
$ns at 129.61900956174014 "$node_(50) setdest 2577 358 13.0" 
$ns at 220.69972630746437 "$node_(50) setdest 960 222 10.0" 
$ns at 255.22557251523716 "$node_(50) setdest 352 983 14.0" 
$ns at 386.8235119138594 "$node_(50) setdest 2906 880 10.0" 
$ns at 424.3357147864262 "$node_(50) setdest 1145 917 19.0" 
$ns at 591.846901760066 "$node_(50) setdest 246 523 15.0" 
$ns at 636.6103856709476 "$node_(50) setdest 1180 197 14.0" 
$ns at 678.4929318351035 "$node_(50) setdest 2893 999 13.0" 
$ns at 833.3878124842099 "$node_(50) setdest 972 612 2.0" 
$ns at 868.3487291607466 "$node_(50) setdest 2280 701 19.0" 
$ns at 262.4231724394106 "$node_(51) setdest 1041 938 18.0" 
$ns at 333.7249321181125 "$node_(51) setdest 185 616 3.0" 
$ns at 368.9936655705856 "$node_(51) setdest 2085 62 16.0" 
$ns at 485.8494152946449 "$node_(51) setdest 2198 918 17.0" 
$ns at 545.0806311729144 "$node_(51) setdest 1728 182 4.0" 
$ns at 576.8511684717951 "$node_(51) setdest 2698 935 10.0" 
$ns at 639.3806372611887 "$node_(51) setdest 2701 827 11.0" 
$ns at 733.3375947498363 "$node_(51) setdest 2407 498 9.0" 
$ns at 828.1972015291262 "$node_(51) setdest 2537 15 19.0" 
$ns at 867.5299532076422 "$node_(51) setdest 2393 445 1.0" 
$ns at 209.52612161347406 "$node_(52) setdest 2567 759 9.0" 
$ns at 268.39246552976425 "$node_(52) setdest 586 546 5.0" 
$ns at 310.6622240168349 "$node_(52) setdest 827 312 3.0" 
$ns at 347.7986656103625 "$node_(52) setdest 1357 338 3.0" 
$ns at 401.7917956078527 "$node_(52) setdest 1343 320 5.0" 
$ns at 465.86733359279117 "$node_(52) setdest 816 213 6.0" 
$ns at 507.19812903424116 "$node_(52) setdest 2368 71 15.0" 
$ns at 558.5994653301439 "$node_(52) setdest 1986 19 3.0" 
$ns at 601.9674506502829 "$node_(52) setdest 460 267 15.0" 
$ns at 770.6092388747636 "$node_(52) setdest 2809 31 1.0" 
$ns at 805.4967664703219 "$node_(52) setdest 1872 239 1.0" 
$ns at 842.2789630580398 "$node_(52) setdest 613 185 19.0" 
$ns at 263.47538502714144 "$node_(53) setdest 691 82 18.0" 
$ns at 455.99246065790385 "$node_(53) setdest 2556 312 2.0" 
$ns at 486.10857360326736 "$node_(53) setdest 2164 79 19.0" 
$ns at 664.955509525329 "$node_(53) setdest 1768 739 15.0" 
$ns at 841.1566829476903 "$node_(53) setdest 2603 687 13.0" 
$ns at 178.20456925740012 "$node_(54) setdest 1843 218 5.0" 
$ns at 230.18464356765665 "$node_(54) setdest 2453 561 12.0" 
$ns at 280.79670417811724 "$node_(54) setdest 2176 694 11.0" 
$ns at 347.0857815352325 "$node_(54) setdest 2975 164 6.0" 
$ns at 400.47703991342706 "$node_(54) setdest 1816 131 15.0" 
$ns at 551.2929470290393 "$node_(54) setdest 1647 723 17.0" 
$ns at 738.0878123800724 "$node_(54) setdest 810 583 1.0" 
$ns at 775.0772330610185 "$node_(54) setdest 2572 593 19.0" 
$ns at 811.2417494003352 "$node_(54) setdest 1818 801 8.0" 
$ns at 298.7587330789881 "$node_(55) setdest 919 481 8.0" 
$ns at 332.95323261356225 "$node_(55) setdest 2624 518 1.0" 
$ns at 371.65941751955376 "$node_(55) setdest 2089 139 5.0" 
$ns at 449.8721186184711 "$node_(55) setdest 1334 59 19.0" 
$ns at 569.7088671683149 "$node_(55) setdest 1078 428 11.0" 
$ns at 611.2060364869693 "$node_(55) setdest 754 408 5.0" 
$ns at 671.29840593352 "$node_(55) setdest 952 14 19.0" 
$ns at 847.9722211817112 "$node_(55) setdest 2710 43 14.0" 
$ns at 899.9629452893901 "$node_(55) setdest 75 841 8.0" 
$ns at 189.9924038895697 "$node_(56) setdest 1958 163 7.0" 
$ns at 222.26048083090933 "$node_(56) setdest 1688 453 12.0" 
$ns at 294.6308369519445 "$node_(56) setdest 1395 632 8.0" 
$ns at 352.1083690390051 "$node_(56) setdest 419 702 19.0" 
$ns at 436.51981658972824 "$node_(56) setdest 1469 244 19.0" 
$ns at 541.1806420187585 "$node_(56) setdest 1856 7 2.0" 
$ns at 585.520142952017 "$node_(56) setdest 1263 670 5.0" 
$ns at 639.0051420076559 "$node_(56) setdest 1707 929 15.0" 
$ns at 757.1921274550234 "$node_(56) setdest 974 873 12.0" 
$ns at 865.788611552371 "$node_(56) setdest 118 549 8.0" 
$ns at 196.2913690503671 "$node_(57) setdest 1391 164 10.0" 
$ns at 231.28807439734467 "$node_(57) setdest 2001 83 10.0" 
$ns at 312.92147976572954 "$node_(57) setdest 1851 95 5.0" 
$ns at 347.8958221765587 "$node_(57) setdest 1406 620 15.0" 
$ns at 500.81968106606996 "$node_(57) setdest 1608 316 10.0" 
$ns at 598.1346749104846 "$node_(57) setdest 1817 421 7.0" 
$ns at 686.3379835308042 "$node_(57) setdest 521 992 11.0" 
$ns at 733.0198856666881 "$node_(57) setdest 2187 37 1.0" 
$ns at 764.3547378474385 "$node_(57) setdest 1900 226 11.0" 
$ns at 857.3240639875789 "$node_(57) setdest 1370 658 19.0" 
$ns at 269.9385502689734 "$node_(58) setdest 845 472 6.0" 
$ns at 300.7373048435024 "$node_(58) setdest 49 632 19.0" 
$ns at 439.87183178263643 "$node_(58) setdest 2063 981 7.0" 
$ns at 511.55402456070294 "$node_(58) setdest 10 780 18.0" 
$ns at 623.6310202918291 "$node_(58) setdest 2233 160 12.0" 
$ns at 703.946497806236 "$node_(58) setdest 2773 878 15.0" 
$ns at 866.729733715565 "$node_(58) setdest 2934 544 19.0" 
$ns at 166.6119330368162 "$node_(59) setdest 2328 567 2.0" 
$ns at 211.41091745775356 "$node_(59) setdest 974 633 3.0" 
$ns at 266.03704080611703 "$node_(59) setdest 2922 11 5.0" 
$ns at 303.45279828274886 "$node_(59) setdest 2972 11 13.0" 
$ns at 461.543119583839 "$node_(59) setdest 554 930 4.0" 
$ns at 504.5713677451166 "$node_(59) setdest 535 583 11.0" 
$ns at 535.9613767071132 "$node_(59) setdest 119 79 4.0" 
$ns at 579.9394482240319 "$node_(59) setdest 1084 696 4.0" 
$ns at 638.3051385807207 "$node_(59) setdest 923 676 11.0" 
$ns at 728.9786287041038 "$node_(59) setdest 1487 853 6.0" 
$ns at 808.0266349330468 "$node_(59) setdest 2523 300 10.0" 
$ns at 202.27295462826572 "$node_(60) setdest 2924 692 5.0" 
$ns at 254.17614239248675 "$node_(60) setdest 599 69 14.0" 
$ns at 392.9578487011869 "$node_(60) setdest 2926 329 17.0" 
$ns at 464.61028403539876 "$node_(60) setdest 1118 965 17.0" 
$ns at 526.9467872047687 "$node_(60) setdest 1112 419 8.0" 
$ns at 623.4887786387171 "$node_(60) setdest 1703 528 2.0" 
$ns at 669.8446855033918 "$node_(60) setdest 2936 221 20.0" 
$ns at 699.915086842231 "$node_(60) setdest 1335 893 15.0" 
$ns at 859.5635822907527 "$node_(60) setdest 1192 816 10.0" 
$ns at 184.96361167368528 "$node_(61) setdest 2212 728 12.0" 
$ns at 228.36656774493628 "$node_(61) setdest 2112 132 14.0" 
$ns at 341.09278539917733 "$node_(61) setdest 2586 437 6.0" 
$ns at 414.16677437950483 "$node_(61) setdest 1008 619 2.0" 
$ns at 464.04048933986354 "$node_(61) setdest 2876 395 14.0" 
$ns at 566.2749405807947 "$node_(61) setdest 1328 207 10.0" 
$ns at 617.1839382515204 "$node_(61) setdest 510 658 13.0" 
$ns at 680.6248614279472 "$node_(61) setdest 1281 197 13.0" 
$ns at 717.3021535912817 "$node_(61) setdest 285 544 10.0" 
$ns at 808.713159737474 "$node_(61) setdest 2728 203 10.0" 
$ns at 264.86503698736374 "$node_(62) setdest 2320 451 16.0" 
$ns at 390.5825231854711 "$node_(62) setdest 2899 327 16.0" 
$ns at 578.3813918464058 "$node_(62) setdest 1943 570 12.0" 
$ns at 633.022991337021 "$node_(62) setdest 697 514 6.0" 
$ns at 702.3368335854907 "$node_(62) setdest 1155 909 2.0" 
$ns at 747.2714317989096 "$node_(62) setdest 1022 621 14.0" 
$ns at 787.8964594994864 "$node_(62) setdest 2173 385 17.0" 
$ns at 191.02916046887023 "$node_(63) setdest 953 190 12.0" 
$ns at 282.67959492403895 "$node_(63) setdest 1349 746 9.0" 
$ns at 395.46630035099366 "$node_(63) setdest 267 482 9.0" 
$ns at 471.65759433217323 "$node_(63) setdest 2978 146 18.0" 
$ns at 645.2936118458244 "$node_(63) setdest 2325 547 10.0" 
$ns at 687.4803686883898 "$node_(63) setdest 2393 175 6.0" 
$ns at 736.0942258888533 "$node_(63) setdest 657 376 16.0" 
$ns at 791.3398511794734 "$node_(63) setdest 2205 507 5.0" 
$ns at 828.682786118902 "$node_(63) setdest 1711 801 19.0" 
$ns at 291.5282547169219 "$node_(64) setdest 2368 572 13.0" 
$ns at 349.88177516911793 "$node_(64) setdest 783 119 9.0" 
$ns at 398.106273648042 "$node_(64) setdest 710 612 2.0" 
$ns at 445.95797715946134 "$node_(64) setdest 469 176 14.0" 
$ns at 566.7182741316338 "$node_(64) setdest 46 54 19.0" 
$ns at 658.6255980006557 "$node_(64) setdest 2530 361 8.0" 
$ns at 711.0929999430809 "$node_(64) setdest 2688 14 6.0" 
$ns at 755.7541666122055 "$node_(64) setdest 183 604 15.0" 
$ns at 878.4039749937386 "$node_(64) setdest 2117 442 4.0" 
$ns at 271.74679212144474 "$node_(65) setdest 250 550 1.0" 
$ns at 303.9802112417 "$node_(65) setdest 1890 859 13.0" 
$ns at 452.7066041849926 "$node_(65) setdest 2170 610 10.0" 
$ns at 556.2015018610506 "$node_(65) setdest 1857 863 19.0" 
$ns at 749.3072828519889 "$node_(65) setdest 2896 592 7.0" 
$ns at 827.3682132079076 "$node_(65) setdest 636 290 5.0" 
$ns at 870.3174015610059 "$node_(65) setdest 1767 411 8.0" 
$ns at 195.76037294949342 "$node_(66) setdest 256 922 6.0" 
$ns at 244.572836110624 "$node_(66) setdest 30 254 5.0" 
$ns at 284.1021334072018 "$node_(66) setdest 2008 124 2.0" 
$ns at 324.12642320053703 "$node_(66) setdest 2035 653 11.0" 
$ns at 418.81842263376984 "$node_(66) setdest 1626 621 8.0" 
$ns at 527.2755646081692 "$node_(66) setdest 1408 573 18.0" 
$ns at 637.6325872551314 "$node_(66) setdest 2204 708 12.0" 
$ns at 720.2565455464638 "$node_(66) setdest 1062 1 4.0" 
$ns at 775.9052810461914 "$node_(66) setdest 1505 929 6.0" 
$ns at 846.9516796322388 "$node_(66) setdest 1998 238 11.0" 
$ns at 890.9246723625666 "$node_(66) setdest 19 425 20.0" 
$ns at 194.65339081528634 "$node_(67) setdest 23 922 4.0" 
$ns at 250.14426605427474 "$node_(67) setdest 2269 724 1.0" 
$ns at 283.79080738973664 "$node_(67) setdest 2745 193 10.0" 
$ns at 394.1637208217402 "$node_(67) setdest 2027 936 18.0" 
$ns at 588.7068987022604 "$node_(67) setdest 1832 101 15.0" 
$ns at 675.2635444078526 "$node_(67) setdest 1254 173 15.0" 
$ns at 714.5702938107144 "$node_(67) setdest 2790 736 1.0" 
$ns at 751.61173902374 "$node_(67) setdest 1302 796 1.0" 
$ns at 786.7705130855111 "$node_(67) setdest 2378 192 20.0" 
$ns at 889.2640452373907 "$node_(67) setdest 616 726 17.0" 
$ns at 223.48186516418127 "$node_(68) setdest 1559 172 3.0" 
$ns at 257.91986754866775 "$node_(68) setdest 953 113 13.0" 
$ns at 293.05001560438 "$node_(68) setdest 2339 534 19.0" 
$ns at 509.9069274829326 "$node_(68) setdest 921 932 14.0" 
$ns at 571.365004318009 "$node_(68) setdest 940 191 8.0" 
$ns at 645.2778238437598 "$node_(68) setdest 676 834 11.0" 
$ns at 750.1925281690322 "$node_(68) setdest 2687 324 17.0" 
$ns at 879.6641680851651 "$node_(68) setdest 1805 700 2.0" 
$ns at 185.1326702367943 "$node_(69) setdest 2369 354 20.0" 
$ns at 400.7678532343906 "$node_(69) setdest 1682 339 10.0" 
$ns at 453.1070895001363 "$node_(69) setdest 1779 389 9.0" 
$ns at 546.7352224064164 "$node_(69) setdest 2841 435 3.0" 
$ns at 585.1944342180885 "$node_(69) setdest 2013 485 1.0" 
$ns at 615.387176855536 "$node_(69) setdest 2875 485 9.0" 
$ns at 668.0635487633024 "$node_(69) setdest 1336 64 17.0" 
$ns at 717.8875224310453 "$node_(69) setdest 2319 753 11.0" 
$ns at 828.5393994040217 "$node_(69) setdest 2753 637 6.0" 
$ns at 891.8936201067169 "$node_(69) setdest 234 964 12.0" 
$ns at 191.53236301321087 "$node_(70) setdest 2419 490 9.0" 
$ns at 290.3076272591944 "$node_(70) setdest 1365 692 12.0" 
$ns at 421.25649461154154 "$node_(70) setdest 883 711 3.0" 
$ns at 452.18271757225995 "$node_(70) setdest 1378 725 17.0" 
$ns at 540.5711791410384 "$node_(70) setdest 1666 723 4.0" 
$ns at 575.2018290405981 "$node_(70) setdest 2857 768 11.0" 
$ns at 665.8377001984961 "$node_(70) setdest 1955 612 19.0" 
$ns at 784.9596522582516 "$node_(70) setdest 1441 469 17.0" 
$ns at 827.1539764371454 "$node_(70) setdest 1558 192 4.0" 
$ns at 873.6666969326425 "$node_(70) setdest 2261 619 15.0" 
$ns at 262.1035299800636 "$node_(71) setdest 2266 100 4.0" 
$ns at 322.64827662821045 "$node_(71) setdest 992 869 3.0" 
$ns at 358.5913795565348 "$node_(71) setdest 1940 874 1.0" 
$ns at 392.2678482337002 "$node_(71) setdest 2018 759 5.0" 
$ns at 429.3824112702989 "$node_(71) setdest 153 1 17.0" 
$ns at 590.8467845055786 "$node_(71) setdest 1615 508 15.0" 
$ns at 677.9567015362913 "$node_(71) setdest 200 879 4.0" 
$ns at 716.7164980977257 "$node_(71) setdest 2697 209 12.0" 
$ns at 801.7379794003565 "$node_(71) setdest 606 945 11.0" 
$ns at 862.5232018731161 "$node_(71) setdest 343 38 20.0" 
$ns at 221.662115841776 "$node_(72) setdest 1388 743 20.0" 
$ns at 401.1374062259888 "$node_(72) setdest 1682 743 12.0" 
$ns at 482.03161788730034 "$node_(72) setdest 525 931 8.0" 
$ns at 574.9646355430513 "$node_(72) setdest 973 938 8.0" 
$ns at 626.498036053853 "$node_(72) setdest 551 796 17.0" 
$ns at 721.196634977849 "$node_(72) setdest 1794 9 5.0" 
$ns at 758.835208648543 "$node_(72) setdest 902 364 4.0" 
$ns at 809.7580870297834 "$node_(72) setdest 911 984 10.0" 
$ns at 881.3586251714155 "$node_(72) setdest 1987 574 19.0" 
$ns at 306.5722836939691 "$node_(73) setdest 236 691 13.0" 
$ns at 425.55829616717614 "$node_(73) setdest 2127 360 18.0" 
$ns at 504.12634700570896 "$node_(73) setdest 890 659 2.0" 
$ns at 550.5225211269747 "$node_(73) setdest 503 645 9.0" 
$ns at 665.3127841711811 "$node_(73) setdest 31 110 7.0" 
$ns at 764.3117840400078 "$node_(73) setdest 2165 682 8.0" 
$ns at 844.5404670413843 "$node_(73) setdest 2235 610 8.0" 
$ns at 180.98617319274877 "$node_(74) setdest 517 75 14.0" 
$ns at 342.204335787073 "$node_(74) setdest 2381 651 1.0" 
$ns at 374.9557762529418 "$node_(74) setdest 2659 416 12.0" 
$ns at 435.26453687014293 "$node_(74) setdest 2229 115 13.0" 
$ns at 558.737606154422 "$node_(74) setdest 2264 428 12.0" 
$ns at 608.7708625397082 "$node_(74) setdest 2540 114 12.0" 
$ns at 652.3020431053637 "$node_(74) setdest 2301 328 11.0" 
$ns at 764.6519034827792 "$node_(74) setdest 2879 278 9.0" 
$ns at 865.2201020575114 "$node_(74) setdest 1272 314 8.0" 
$ns at 334.9497586513214 "$node_(75) setdest 1762 673 8.0" 
$ns at 432.04155270461285 "$node_(75) setdest 901 382 7.0" 
$ns at 462.7592505504911 "$node_(75) setdest 2711 878 19.0" 
$ns at 541.0497102145716 "$node_(75) setdest 2373 730 9.0" 
$ns at 633.4937517079179 "$node_(75) setdest 2122 387 7.0" 
$ns at 665.2522722887265 "$node_(75) setdest 2897 856 16.0" 
$ns at 781.2282044720872 "$node_(75) setdest 899 625 9.0" 
$ns at 887.9582395227789 "$node_(75) setdest 487 215 18.0" 
$ns at 338.7766395155782 "$node_(76) setdest 2932 308 3.0" 
$ns at 379.8621209715622 "$node_(76) setdest 1791 76 14.0" 
$ns at 500.2873338237916 "$node_(76) setdest 2001 438 8.0" 
$ns at 561.3464783680799 "$node_(76) setdest 1408 636 8.0" 
$ns at 648.1765702473009 "$node_(76) setdest 446 188 1.0" 
$ns at 683.2175418139236 "$node_(76) setdest 1463 946 5.0" 
$ns at 757.5755025471864 "$node_(76) setdest 2283 572 2.0" 
$ns at 807.4043617085789 "$node_(76) setdest 345 269 9.0" 
$ns at 488.914570067795 "$node_(77) setdest 2931 246 15.0" 
$ns at 598.8688579756105 "$node_(77) setdest 1371 552 3.0" 
$ns at 658.7166908607426 "$node_(77) setdest 1784 618 17.0" 
$ns at 725.1391226885933 "$node_(77) setdest 1896 75 8.0" 
$ns at 780.3858000820777 "$node_(77) setdest 1690 451 10.0" 
$ns at 831.2993864577127 "$node_(77) setdest 1981 945 5.0" 
$ns at 874.5744148042754 "$node_(77) setdest 2013 867 19.0" 
$ns at 439.39342186070564 "$node_(78) setdest 31 526 5.0" 
$ns at 518.5480883582584 "$node_(78) setdest 1214 211 16.0" 
$ns at 618.8726366516837 "$node_(78) setdest 2935 153 6.0" 
$ns at 695.8355433973848 "$node_(78) setdest 439 509 5.0" 
$ns at 739.2573679847369 "$node_(78) setdest 1668 850 8.0" 
$ns at 822.1048998368835 "$node_(78) setdest 2357 650 14.0" 
$ns at 343.29742473711207 "$node_(79) setdest 1524 351 12.0" 
$ns at 418.4978270886844 "$node_(79) setdest 1873 270 18.0" 
$ns at 603.4428072401288 "$node_(79) setdest 2435 330 11.0" 
$ns at 673.2224775655086 "$node_(79) setdest 1274 538 2.0" 
$ns at 714.1989889615961 "$node_(79) setdest 1612 226 13.0" 
$ns at 866.8714417495347 "$node_(79) setdest 2194 614 2.0" 
$ns at 428.44484435045905 "$node_(80) setdest 545 543 7.0" 
$ns at 464.37638453936904 "$node_(80) setdest 2359 229 9.0" 
$ns at 544.4300520752427 "$node_(80) setdest 495 941 8.0" 
$ns at 580.2231102395239 "$node_(80) setdest 1646 268 11.0" 
$ns at 639.5748128631153 "$node_(80) setdest 519 932 17.0" 
$ns at 787.979513321293 "$node_(80) setdest 1451 69 17.0" 
$ns at 842.0662663620831 "$node_(80) setdest 103 836 8.0" 
$ns at 348.58208782025247 "$node_(81) setdest 2524 974 9.0" 
$ns at 435.55696026679107 "$node_(81) setdest 2614 857 3.0" 
$ns at 479.98879753058134 "$node_(81) setdest 1645 118 9.0" 
$ns at 515.6530707429991 "$node_(81) setdest 2359 476 8.0" 
$ns at 575.6274535866839 "$node_(81) setdest 1638 912 2.0" 
$ns at 613.6992405505719 "$node_(81) setdest 612 348 16.0" 
$ns at 762.4746486289031 "$node_(81) setdest 83 213 15.0" 
$ns at 801.2162087836628 "$node_(81) setdest 2091 168 5.0" 
$ns at 877.6504993999259 "$node_(81) setdest 1207 648 16.0" 
$ns at 335.7686292156361 "$node_(82) setdest 2056 231 15.0" 
$ns at 416.21723140102586 "$node_(82) setdest 1520 265 16.0" 
$ns at 474.10418285037184 "$node_(82) setdest 2054 939 16.0" 
$ns at 657.1269018953229 "$node_(82) setdest 1650 423 2.0" 
$ns at 700.9303070039192 "$node_(82) setdest 27 217 16.0" 
$ns at 742.0144183533362 "$node_(82) setdest 821 250 19.0" 
$ns at 775.4200032799974 "$node_(82) setdest 2448 238 17.0" 
$ns at 810.1672413173895 "$node_(82) setdest 1429 169 8.0" 
$ns at 388.650577448945 "$node_(83) setdest 2641 13 5.0" 
$ns at 420.9979004656352 "$node_(83) setdest 330 370 2.0" 
$ns at 455.5177468332738 "$node_(83) setdest 2107 609 10.0" 
$ns at 525.3118810785522 "$node_(83) setdest 642 601 17.0" 
$ns at 569.4619718645005 "$node_(83) setdest 1715 384 11.0" 
$ns at 638.5570343163765 "$node_(83) setdest 2398 634 10.0" 
$ns at 755.4738370986314 "$node_(83) setdest 2360 591 12.0" 
$ns at 869.0566989661747 "$node_(83) setdest 1592 424 4.0" 
$ns at 392.83424967714575 "$node_(84) setdest 2047 542 18.0" 
$ns at 457.36295063213936 "$node_(84) setdest 1954 734 10.0" 
$ns at 569.0586744721687 "$node_(84) setdest 977 54 3.0" 
$ns at 601.5826572485448 "$node_(84) setdest 1796 45 16.0" 
$ns at 758.713613123947 "$node_(84) setdest 2469 100 20.0" 
$ns at 816.0503882204649 "$node_(84) setdest 1819 189 5.0" 
$ns at 880.4760231988371 "$node_(84) setdest 518 83 14.0" 
$ns at 365.7402964800972 "$node_(85) setdest 2513 473 8.0" 
$ns at 407.91822267991506 "$node_(85) setdest 2882 28 1.0" 
$ns at 445.5340371272704 "$node_(85) setdest 922 910 7.0" 
$ns at 541.1713421127289 "$node_(85) setdest 2236 815 11.0" 
$ns at 594.3792933918353 "$node_(85) setdest 794 141 17.0" 
$ns at 683.0849451544406 "$node_(85) setdest 1062 807 12.0" 
$ns at 802.2283817734176 "$node_(85) setdest 501 411 14.0" 
$ns at 392.8009252475365 "$node_(86) setdest 10 800 11.0" 
$ns at 471.70393756977677 "$node_(86) setdest 856 393 3.0" 
$ns at 517.8481800597376 "$node_(86) setdest 2884 706 2.0" 
$ns at 549.2546081332324 "$node_(86) setdest 1226 342 8.0" 
$ns at 613.3943421890165 "$node_(86) setdest 2588 929 14.0" 
$ns at 700.8363932675576 "$node_(86) setdest 1341 399 20.0" 
$ns at 772.9029609095926 "$node_(86) setdest 234 652 4.0" 
$ns at 825.93903751508 "$node_(86) setdest 264 262 2.0" 
$ns at 862.1856166320638 "$node_(86) setdest 1449 459 7.0" 
$ns at 388.0462804985366 "$node_(87) setdest 1978 392 17.0" 
$ns at 563.77605843017 "$node_(87) setdest 974 385 9.0" 
$ns at 641.62884478389 "$node_(87) setdest 1293 198 1.0" 
$ns at 676.9170945266072 "$node_(87) setdest 2860 259 14.0" 
$ns at 843.5272094992682 "$node_(87) setdest 1215 476 6.0" 
$ns at 897.0001200099576 "$node_(87) setdest 1965 448 1.0" 
$ns at 350.5920482701737 "$node_(88) setdest 746 618 16.0" 
$ns at 512.7517019732172 "$node_(88) setdest 274 221 8.0" 
$ns at 549.012378842291 "$node_(88) setdest 172 427 19.0" 
$ns at 733.6394289837067 "$node_(88) setdest 2398 989 6.0" 
$ns at 813.9831182723491 "$node_(88) setdest 1841 880 18.0" 
$ns at 336.20315286428803 "$node_(89) setdest 87 889 17.0" 
$ns at 366.44527858051845 "$node_(89) setdest 915 386 10.0" 
$ns at 456.6481065826069 "$node_(89) setdest 2448 536 18.0" 
$ns at 592.6770292330162 "$node_(89) setdest 1525 237 13.0" 
$ns at 698.7899513362265 "$node_(89) setdest 587 209 6.0" 
$ns at 748.1806003126178 "$node_(89) setdest 1531 376 14.0" 
$ns at 895.6035059511282 "$node_(89) setdest 2811 771 18.0" 
$ns at 448.09277564976645 "$node_(90) setdest 333 516 8.0" 
$ns at 540.6397244913825 "$node_(90) setdest 1891 148 13.0" 
$ns at 651.3910669155397 "$node_(90) setdest 229 714 13.0" 
$ns at 687.7648077307239 "$node_(90) setdest 916 764 6.0" 
$ns at 727.1667687542569 "$node_(90) setdest 2229 479 15.0" 
$ns at 789.4010174796454 "$node_(90) setdest 97 606 5.0" 
$ns at 866.0578489142871 "$node_(90) setdest 429 346 14.0" 
$ns at 483.7794985112895 "$node_(91) setdest 2508 872 13.0" 
$ns at 604.8367935792113 "$node_(91) setdest 2636 413 14.0" 
$ns at 681.842064046088 "$node_(91) setdest 1330 438 3.0" 
$ns at 722.8676146272841 "$node_(91) setdest 1633 705 2.0" 
$ns at 754.2566340735482 "$node_(91) setdest 2481 761 10.0" 
$ns at 847.881027144866 "$node_(91) setdest 2146 704 12.0" 
$ns at 894.5468016690586 "$node_(91) setdest 721 32 12.0" 
$ns at 338.378905103184 "$node_(92) setdest 2219 475 16.0" 
$ns at 379.090398910039 "$node_(92) setdest 2444 201 2.0" 
$ns at 412.804843043415 "$node_(92) setdest 914 532 10.0" 
$ns at 462.8978565980333 "$node_(92) setdest 1147 564 1.0" 
$ns at 499.920316404234 "$node_(92) setdest 697 88 11.0" 
$ns at 530.2294429429026 "$node_(92) setdest 2233 795 16.0" 
$ns at 590.4599103348008 "$node_(92) setdest 2796 917 12.0" 
$ns at 695.396984942001 "$node_(92) setdest 2846 19 15.0" 
$ns at 859.2462433163348 "$node_(92) setdest 784 851 16.0" 
$ns at 334.12476821373684 "$node_(93) setdest 1721 130 10.0" 
$ns at 400.6830579223125 "$node_(93) setdest 1808 977 2.0" 
$ns at 439.09527420105155 "$node_(93) setdest 502 73 12.0" 
$ns at 496.24354000681774 "$node_(93) setdest 2706 525 10.0" 
$ns at 561.2298750435908 "$node_(93) setdest 1728 392 18.0" 
$ns at 688.787571511865 "$node_(93) setdest 2603 544 3.0" 
$ns at 739.4517557709052 "$node_(93) setdest 93 616 10.0" 
$ns at 843.618097333027 "$node_(93) setdest 2363 549 16.0" 
$ns at 342.0866984141957 "$node_(94) setdest 2953 726 17.0" 
$ns at 373.94334740316276 "$node_(94) setdest 2903 689 13.0" 
$ns at 470.46770605377935 "$node_(94) setdest 2007 709 14.0" 
$ns at 600.6533106382491 "$node_(94) setdest 1220 469 4.0" 
$ns at 639.3710234125849 "$node_(94) setdest 1575 855 12.0" 
$ns at 784.0779938735839 "$node_(94) setdest 1175 361 16.0" 
$ns at 491.4629042063519 "$node_(95) setdest 1316 660 4.0" 
$ns at 545.1125350790343 "$node_(95) setdest 2354 210 4.0" 
$ns at 611.8118436697027 "$node_(95) setdest 1045 158 1.0" 
$ns at 642.0803968313136 "$node_(95) setdest 1665 126 16.0" 
$ns at 756.90169073745 "$node_(95) setdest 1686 809 18.0" 
$ns at 427.76839210568573 "$node_(96) setdest 982 265 7.0" 
$ns at 470.81163591797895 "$node_(96) setdest 2460 292 14.0" 
$ns at 505.7932128719776 "$node_(96) setdest 2386 170 19.0" 
$ns at 681.5680857175308 "$node_(96) setdest 1870 241 1.0" 
$ns at 719.2149961012968 "$node_(96) setdest 2055 935 7.0" 
$ns at 806.6489789206981 "$node_(96) setdest 1353 417 19.0" 
$ns at 354.04731595145915 "$node_(97) setdest 2916 885 8.0" 
$ns at 390.97953332596734 "$node_(97) setdest 1625 597 9.0" 
$ns at 459.6389064013634 "$node_(97) setdest 1249 83 7.0" 
$ns at 519.4918122052645 "$node_(97) setdest 651 912 5.0" 
$ns at 565.1533911359055 "$node_(97) setdest 1574 219 12.0" 
$ns at 712.0929844549519 "$node_(97) setdest 633 975 18.0" 
$ns at 843.1167940379903 "$node_(97) setdest 2761 806 16.0" 
$ns at 896.1290275046869 "$node_(97) setdest 1256 855 16.0" 
$ns at 409.80570124444534 "$node_(98) setdest 616 698 9.0" 
$ns at 525.4342406392874 "$node_(98) setdest 2651 478 11.0" 
$ns at 599.8114591772076 "$node_(98) setdest 1531 381 17.0" 
$ns at 670.4562041914235 "$node_(98) setdest 1853 810 8.0" 
$ns at 726.7860688630911 "$node_(98) setdest 1682 684 8.0" 
$ns at 818.0689168336081 "$node_(98) setdest 430 381 17.0" 
$ns at 863.4524403916058 "$node_(98) setdest 2705 374 8.0" 
$ns at 374.27861281208345 "$node_(99) setdest 930 273 18.0" 
$ns at 563.7472649508799 "$node_(99) setdest 476 81 12.0" 
$ns at 598.8759086130672 "$node_(99) setdest 1747 920 8.0" 
$ns at 630.6927706631373 "$node_(99) setdest 323 516 17.0" 
$ns at 769.8283421319207 "$node_(99) setdest 480 132 20.0" 
$ns at 848.1895933967133 "$node_(99) setdest 949 893 17.0" 
$ns at 514.7658122999441 "$node_(100) setdest 363 300 8.0" 
$ns at 598.003281221861 "$node_(100) setdest 352 844 11.0" 
$ns at 727.2781305125557 "$node_(100) setdest 1009 927 1.0" 
$ns at 762.073960669134 "$node_(100) setdest 1049 855 10.0" 
$ns at 794.7805048986376 "$node_(100) setdest 2196 98 17.0" 
$ns at 864.5262056966413 "$node_(100) setdest 2706 509 3.0" 
$ns at 517.9771419648034 "$node_(101) setdest 2458 170 2.0" 
$ns at 550.9658011788423 "$node_(101) setdest 594 782 8.0" 
$ns at 652.4189324063698 "$node_(101) setdest 1636 708 5.0" 
$ns at 689.8512831445281 "$node_(101) setdest 2165 264 8.0" 
$ns at 784.7329504442237 "$node_(101) setdest 2683 884 19.0" 
$ns at 869.3019081987323 "$node_(101) setdest 888 810 10.0" 
$ns at 552.791483927365 "$node_(102) setdest 111 826 9.0" 
$ns at 654.5173119745762 "$node_(102) setdest 1858 947 20.0" 
$ns at 789.898600622086 "$node_(102) setdest 2606 451 9.0" 
$ns at 847.2755911983178 "$node_(102) setdest 571 90 2.0" 
$ns at 887.1661724680393 "$node_(102) setdest 2361 536 16.0" 
$ns at 499.94725641095556 "$node_(103) setdest 526 876 3.0" 
$ns at 553.490738643525 "$node_(103) setdest 1713 806 8.0" 
$ns at 603.7586480323781 "$node_(103) setdest 965 811 1.0" 
$ns at 639.4637515711152 "$node_(103) setdest 2747 968 16.0" 
$ns at 700.7133269263535 "$node_(103) setdest 456 326 6.0" 
$ns at 752.435242799839 "$node_(103) setdest 1558 929 17.0" 
$ns at 878.1694992709727 "$node_(103) setdest 501 915 14.0" 
$ns at 638.2246779164693 "$node_(104) setdest 397 661 19.0" 
$ns at 701.7221190491689 "$node_(104) setdest 757 479 17.0" 
$ns at 820.1273932873022 "$node_(104) setdest 839 995 2.0" 
$ns at 861.8586155908824 "$node_(104) setdest 1272 60 15.0" 
$ns at 500.3342881982549 "$node_(105) setdest 2187 54 5.0" 
$ns at 568.2423787241524 "$node_(105) setdest 1338 395 13.0" 
$ns at 625.349901428453 "$node_(105) setdest 989 711 11.0" 
$ns at 732.3521314349601 "$node_(105) setdest 2030 564 19.0" 
$ns at 834.9235859131421 "$node_(105) setdest 2386 210 5.0" 
$ns at 876.7866640145639 "$node_(105) setdest 2311 428 17.0" 
$ns at 613.5411514398356 "$node_(106) setdest 2865 436 10.0" 
$ns at 682.1199095525661 "$node_(106) setdest 539 678 12.0" 
$ns at 816.700859650346 "$node_(106) setdest 2752 611 18.0" 
$ns at 572.1125980342667 "$node_(107) setdest 325 150 15.0" 
$ns at 667.9180671357633 "$node_(107) setdest 2870 454 14.0" 
$ns at 817.1059739501899 "$node_(107) setdest 2758 45 2.0" 
$ns at 847.1139966463093 "$node_(107) setdest 489 495 1.0" 
$ns at 882.2529115498295 "$node_(107) setdest 343 906 15.0" 
$ns at 586.9668013874555 "$node_(108) setdest 1444 709 4.0" 
$ns at 655.0303786578835 "$node_(108) setdest 2593 47 1.0" 
$ns at 694.6798280490971 "$node_(108) setdest 67 49 10.0" 
$ns at 818.6454839203313 "$node_(108) setdest 929 104 18.0" 
$ns at 503.34561335804676 "$node_(109) setdest 1182 691 6.0" 
$ns at 545.5124874395111 "$node_(109) setdest 400 207 15.0" 
$ns at 586.792302876922 "$node_(109) setdest 1169 531 14.0" 
$ns at 732.4020217784937 "$node_(109) setdest 2339 625 20.0" 
$ns at 504.7895075209915 "$node_(110) setdest 146 45 7.0" 
$ns at 603.2353423155904 "$node_(110) setdest 352 878 16.0" 
$ns at 745.6948467264739 "$node_(110) setdest 888 132 16.0" 
$ns at 776.8593461503682 "$node_(110) setdest 2271 876 6.0" 
$ns at 832.9411104213218 "$node_(110) setdest 100 40 2.0" 
$ns at 871.8017433414587 "$node_(110) setdest 1093 454 1.0" 
$ns at 504.0903321084215 "$node_(111) setdest 2652 682 6.0" 
$ns at 556.148030986579 "$node_(111) setdest 1272 83 18.0" 
$ns at 653.6197243184923 "$node_(111) setdest 351 244 15.0" 
$ns at 726.0244115698187 "$node_(111) setdest 1818 849 13.0" 
$ns at 769.7328691352861 "$node_(111) setdest 2770 936 16.0" 
$ns at 544.5465885716284 "$node_(112) setdest 1601 337 14.0" 
$ns at 609.6990862709142 "$node_(112) setdest 1003 947 4.0" 
$ns at 670.2267504189812 "$node_(112) setdest 607 752 10.0" 
$ns at 715.7146770782022 "$node_(112) setdest 1346 550 14.0" 
$ns at 795.3588815978837 "$node_(112) setdest 2534 680 13.0" 
$ns at 558.290357883333 "$node_(113) setdest 2838 264 1.0" 
$ns at 588.9356104966366 "$node_(113) setdest 305 166 16.0" 
$ns at 671.0787278618249 "$node_(113) setdest 234 118 12.0" 
$ns at 731.2823761756227 "$node_(113) setdest 648 101 3.0" 
$ns at 771.4251635373121 "$node_(113) setdest 1950 279 18.0" 
$ns at 851.1365061070503 "$node_(113) setdest 159 732 17.0" 
$ns at 572.1134130285667 "$node_(114) setdest 2245 556 9.0" 
$ns at 680.4942667180109 "$node_(114) setdest 1327 988 2.0" 
$ns at 730.24544376534 "$node_(114) setdest 1346 406 1.0" 
$ns at 767.3220916559735 "$node_(114) setdest 2995 943 15.0" 
$ns at 882.6623032370272 "$node_(114) setdest 2064 509 5.0" 
$ns at 519.3677645668282 "$node_(115) setdest 1955 443 9.0" 
$ns at 606.7108617833694 "$node_(115) setdest 286 77 12.0" 
$ns at 666.1126493207736 "$node_(115) setdest 2363 495 1.0" 
$ns at 699.7306815167251 "$node_(115) setdest 1874 862 4.0" 
$ns at 744.210556203218 "$node_(115) setdest 2562 861 6.0" 
$ns at 781.0189283790187 "$node_(115) setdest 274 295 2.0" 
$ns at 818.2487651441314 "$node_(115) setdest 1798 371 4.0" 
$ns at 849.2217326003938 "$node_(115) setdest 211 164 1.0" 
$ns at 886.870936560043 "$node_(115) setdest 188 913 1.0" 
$ns at 515.1459754636679 "$node_(116) setdest 113 685 9.0" 
$ns at 585.8246980851749 "$node_(116) setdest 2856 757 13.0" 
$ns at 636.4061317660296 "$node_(116) setdest 2090 327 19.0" 
$ns at 789.6089667404929 "$node_(116) setdest 2810 206 6.0" 
$ns at 869.9348270071665 "$node_(116) setdest 2593 302 12.0" 
$ns at 503.24580862408965 "$node_(117) setdest 2705 934 4.0" 
$ns at 537.9996495970483 "$node_(117) setdest 424 209 10.0" 
$ns at 613.3046623928358 "$node_(117) setdest 1747 164 1.0" 
$ns at 644.3148151734113 "$node_(117) setdest 1888 497 2.0" 
$ns at 683.6802759175665 "$node_(117) setdest 1486 392 11.0" 
$ns at 742.4625087066528 "$node_(117) setdest 661 455 8.0" 
$ns at 798.8190949120601 "$node_(117) setdest 1873 147 12.0" 
$ns at 866.1073880474537 "$node_(117) setdest 1981 389 1.0" 
$ns at 499.7913379609469 "$node_(118) setdest 1402 721 4.0" 
$ns at 550.3845425035236 "$node_(118) setdest 1998 120 12.0" 
$ns at 680.2968031884105 "$node_(118) setdest 2494 746 18.0" 
$ns at 885.2915877097514 "$node_(118) setdest 1365 979 12.0" 
$ns at 599.4862376432886 "$node_(119) setdest 1237 696 9.0" 
$ns at 715.5315482926245 "$node_(119) setdest 279 324 17.0" 
$ns at 790.5805810081897 "$node_(119) setdest 1502 841 16.0" 
$ns at 881.9651759679589 "$node_(119) setdest 396 340 5.0" 
$ns at 523.3863602764685 "$node_(120) setdest 1694 442 20.0" 
$ns at 571.5756537768341 "$node_(120) setdest 1755 430 3.0" 
$ns at 609.4923043117091 "$node_(120) setdest 1179 501 5.0" 
$ns at 658.700248760685 "$node_(120) setdest 505 234 10.0" 
$ns at 726.2428327225931 "$node_(120) setdest 1350 200 7.0" 
$ns at 772.9416420613153 "$node_(120) setdest 344 836 3.0" 
$ns at 819.0640139570575 "$node_(120) setdest 2960 35 13.0" 
$ns at 862.0269102963231 "$node_(120) setdest 1571 904 3.0" 
$ns at 497.1121826456088 "$node_(121) setdest 182 366 4.0" 
$ns at 546.2426308987702 "$node_(121) setdest 1506 995 18.0" 
$ns at 580.1280500917167 "$node_(121) setdest 2912 28 15.0" 
$ns at 735.8690016653122 "$node_(121) setdest 965 336 7.0" 
$ns at 792.344373818987 "$node_(121) setdest 1543 501 6.0" 
$ns at 824.0380225656274 "$node_(121) setdest 467 399 9.0" 
$ns at 896.1329855313655 "$node_(121) setdest 1281 600 16.0" 
$ns at 496.9310864344838 "$node_(122) setdest 937 400 17.0" 
$ns at 605.3234317920089 "$node_(122) setdest 2723 25 5.0" 
$ns at 637.0082320965324 "$node_(122) setdest 2806 243 10.0" 
$ns at 746.5216125210429 "$node_(122) setdest 187 159 12.0" 
$ns at 789.333277620484 "$node_(122) setdest 1892 859 4.0" 
$ns at 858.1111912845688 "$node_(122) setdest 849 308 6.0" 
$ns at 557.5488010223116 "$node_(123) setdest 1348 637 16.0" 
$ns at 624.9518570431239 "$node_(123) setdest 108 890 7.0" 
$ns at 700.9556176935613 "$node_(123) setdest 1554 422 3.0" 
$ns at 739.688308330735 "$node_(123) setdest 1860 169 6.0" 
$ns at 800.5924564717361 "$node_(123) setdest 419 323 8.0" 
$ns at 831.3994514259023 "$node_(123) setdest 467 25 11.0" 
$ns at 605.4805874034173 "$node_(124) setdest 2714 406 2.0" 
$ns at 642.151855073465 "$node_(124) setdest 617 652 2.0" 
$ns at 686.9414077540812 "$node_(124) setdest 2185 131 14.0" 
$ns at 773.995755402573 "$node_(124) setdest 730 115 15.0" 
$ns at 831.7130375223708 "$node_(125) setdest 594 6 4.0" 
$ns at 886.9934386900233 "$node_(125) setdest 2025 463 1.0" 
$ns at 672.1049093978432 "$node_(126) setdest 1848 927 2.0" 
$ns at 719.6944323976516 "$node_(126) setdest 1491 861 7.0" 
$ns at 806.7308511879403 "$node_(126) setdest 2635 606 10.0" 
$ns at 866.251787332465 "$node_(126) setdest 1890 712 7.0" 
$ns at 678.2267335408683 "$node_(127) setdest 2101 711 3.0" 
$ns at 720.6086304306474 "$node_(127) setdest 238 798 5.0" 
$ns at 791.1490181109041 "$node_(127) setdest 74 458 3.0" 
$ns at 848.0926791808259 "$node_(127) setdest 1953 727 8.0" 
$ns at 673.7161627720636 "$node_(128) setdest 1197 524 15.0" 
$ns at 838.2808280503209 "$node_(128) setdest 1598 850 9.0" 
$ns at 677.7280242617162 "$node_(129) setdest 2859 648 4.0" 
$ns at 741.1056944838114 "$node_(129) setdest 2762 924 1.0" 
$ns at 772.5173631294372 "$node_(129) setdest 776 47 8.0" 
$ns at 858.0697237078259 "$node_(129) setdest 1063 907 12.0" 
$ns at 768.1337331698605 "$node_(130) setdest 1974 679 12.0" 
$ns at 886.1479240121441 "$node_(130) setdest 1678 824 13.0" 
$ns at 661.5910333048373 "$node_(131) setdest 1596 345 14.0" 
$ns at 722.346644567971 "$node_(131) setdest 300 694 2.0" 
$ns at 764.3659494333459 "$node_(131) setdest 638 196 5.0" 
$ns at 796.1205789484487 "$node_(131) setdest 392 359 11.0" 
$ns at 898.641380376755 "$node_(131) setdest 2858 299 12.0" 
$ns at 749.0074224378264 "$node_(132) setdest 1554 383 2.0" 
$ns at 781.3508728974307 "$node_(132) setdest 895 857 18.0" 
$ns at 855.2930722939747 "$node_(132) setdest 288 939 19.0" 
$ns at 677.421023608214 "$node_(133) setdest 1838 893 7.0" 
$ns at 769.8822427182486 "$node_(133) setdest 1327 405 2.0" 
$ns at 804.5522818182998 "$node_(133) setdest 2191 829 11.0" 
$ns at 744.0701565253789 "$node_(134) setdest 907 704 19.0" 
$ns at 815.5039701257191 "$node_(134) setdest 2804 111 12.0" 
$ns at 677.3019396108286 "$node_(135) setdest 915 447 14.0" 
$ns at 797.7958123392117 "$node_(135) setdest 2676 336 9.0" 
$ns at 853.1103659439984 "$node_(135) setdest 2308 140 18.0" 
$ns at 893.9290480229076 "$node_(135) setdest 2960 133 1.0" 
$ns at 680.4951463207807 "$node_(136) setdest 461 739 18.0" 
$ns at 728.1539513446979 "$node_(136) setdest 2965 984 18.0" 
$ns at 852.8227718387478 "$node_(136) setdest 557 187 13.0" 
$ns at 718.8964548768488 "$node_(137) setdest 2773 102 14.0" 
$ns at 781.5624528621655 "$node_(137) setdest 832 509 14.0" 
$ns at 821.6842809938504 "$node_(137) setdest 1227 978 15.0" 
$ns at 839.1463359042477 "$node_(138) setdest 1847 840 7.0" 
$ns at 791.1703732794745 "$node_(139) setdest 2951 173 5.0" 
$ns at 849.5122178787777 "$node_(139) setdest 325 833 19.0" 
$ns at 737.9402307325074 "$node_(140) setdest 1612 789 1.0" 
$ns at 776.4631212632881 "$node_(140) setdest 1250 903 7.0" 
$ns at 839.2382118130002 "$node_(140) setdest 171 20 13.0" 
$ns at 666.6493261345341 "$node_(141) setdest 2285 467 6.0" 
$ns at 733.1371619291006 "$node_(141) setdest 2327 174 8.0" 
$ns at 827.8452116527435 "$node_(141) setdest 2969 98 12.0" 
$ns at 703.5275701695583 "$node_(142) setdest 2181 502 7.0" 
$ns at 748.9919711071032 "$node_(142) setdest 2159 578 8.0" 
$ns at 785.1898416849424 "$node_(142) setdest 1716 440 13.0" 
$ns at 870.7343027797781 "$node_(142) setdest 2093 83 17.0" 
$ns at 752.6537342189417 "$node_(143) setdest 290 289 10.0" 
$ns at 817.2447690913067 "$node_(143) setdest 2935 56 16.0" 
$ns at 755.2785335264862 "$node_(144) setdest 364 23 11.0" 
$ns at 852.9903841257837 "$node_(144) setdest 1487 79 2.0" 
$ns at 890.1542584667004 "$node_(144) setdest 2944 610 10.0" 
$ns at 673.8223526431959 "$node_(145) setdest 505 540 18.0" 
$ns at 848.9879718522081 "$node_(145) setdest 868 758 13.0" 
$ns at 732.8919131216336 "$node_(146) setdest 2748 991 11.0" 
$ns at 845.9802065939016 "$node_(146) setdest 1581 357 1.0" 
$ns at 877.5716020000682 "$node_(146) setdest 1026 763 10.0" 
$ns at 660.0577344944903 "$node_(147) setdest 2454 461 18.0" 
$ns at 820.7989207402321 "$node_(147) setdest 2220 139 5.0" 
$ns at 856.5645224581543 "$node_(147) setdest 1272 800 11.0" 
$ns at 690.6673026967845 "$node_(148) setdest 1581 787 18.0" 
$ns at 821.4587759091611 "$node_(148) setdest 2257 490 4.0" 
$ns at 879.3542585092866 "$node_(148) setdest 2502 33 7.0" 
$ns at 675.9015260294938 "$node_(149) setdest 1279 949 2.0" 
$ns at 722.6998915254593 "$node_(149) setdest 1057 116 1.0" 
$ns at 762.671562822308 "$node_(149) setdest 2999 231 19.0" 
$ns at 802.035035119435 "$node_(149) setdest 1712 998 8.0" 
$ns at 896.1231733263812 "$node_(149) setdest 2304 155 1.0" 


#Set a TCP connection between node_(2) and node_(13)
set tcp_(0) [new Agent/TCP/Newreno]
$tcp_(0) set class_ 2
set sink_(0) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(0)
$ns attach-agent $node_(13) $sink_(0)
$ns connect $tcp_(0) $sink_(0)
set ftp_(0) [new Application/FTP]
$ftp_(0) attach-agent $tcp_(0)
$ns at 0.2 "$ftp_(0) start"
$ns at 180.0 "$ftp_(0) stop"

#Set a TCP connection between node_(9) and node_(17)
set tcp_(1) [new Agent/TCP/Newreno]
$tcp_(1) set class_ 2
set sink_(1) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(1)
$ns attach-agent $node_(17) $sink_(1)
$ns connect $tcp_(1) $sink_(1)
set ftp_(1) [new Application/FTP]
$ftp_(1) attach-agent $tcp_(1)
$ns at 180.2 "$ftp_(1) start"
$ns at 360.0 "$ftp_(1) stop"

#Set a TCP connection between node_(46) and node_(40)
set tcp_(2) [new Agent/TCP/Newreno]
$tcp_(2) set class_ 2
set sink_(2) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(2)
$ns attach-agent $node_(40) $sink_(2)
$ns connect $tcp_(2) $sink_(2)
set ftp_(2) [new Application/FTP]
$ftp_(2) attach-agent $tcp_(2)
$ns at 360.2 "$ftp_(2) start"
$ns at 540.0 "$ftp_(2) stop"

#Set a TCP connection between node_(9) and node_(46)
set tcp_(3) [new Agent/TCP/Newreno]
$tcp_(3) set class_ 2
set sink_(3) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(3)
$ns attach-agent $node_(46) $sink_(3)
$ns connect $tcp_(3) $sink_(3)
set ftp_(3) [new Application/FTP]
$ftp_(3) attach-agent $tcp_(3)
$ns at 540.2 "$ftp_(3) start"
$ns at 720.0 "$ftp_(3) stop"

#Set a TCP connection between node_(22) and node_(11)
set tcp_(4) [new Agent/TCP/Newreno]
$tcp_(4) set class_ 2
set sink_(4) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(4)
$ns attach-agent $node_(11) $sink_(4)
$ns connect $tcp_(4) $sink_(4)
set ftp_(4) [new Application/FTP]
$ftp_(4) attach-agent $tcp_(4)
$ns at 720.2 "$ftp_(4) start"
$ns at 900.0 "$ftp_(4) stop"

#Set a TCP connection between node_(0) and node_(5)
set tcp_(5) [new Agent/TCP/Newreno]
$tcp_(5) set class_ 2
set sink_(5) [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp_(5)
$ns attach-agent $node_(5) $sink_(5)
$ns connect $tcp_(5) $sink_(5)
set ftp_(5) [new Application/FTP]
$ftp_(5) attach-agent $tcp_(5)
$ns at 0.2 "$ftp_(5) start"
$ns at 180.0 "$ftp_(5) stop"

#Set a TCP connection between node_(20) and node_(5)
set tcp_(6) [new Agent/TCP/Newreno]
$tcp_(6) set class_ 2
set sink_(6) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(6)
$ns attach-agent $node_(5) $sink_(6)
$ns connect $tcp_(6) $sink_(6)
set ftp_(6) [new Application/FTP]
$ftp_(6) attach-agent $tcp_(6)
$ns at 180.2 "$ftp_(6) start"
$ns at 360.0 "$ftp_(6) stop"

#Set a TCP connection between node_(25) and node_(44)
set tcp_(7) [new Agent/TCP/Newreno]
$tcp_(7) set class_ 2
set sink_(7) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(7)
$ns attach-agent $node_(44) $sink_(7)
$ns connect $tcp_(7) $sink_(7)
set ftp_(7) [new Application/FTP]
$ftp_(7) attach-agent $tcp_(7)
$ns at 360.2 "$ftp_(7) start"
$ns at 540.0 "$ftp_(7) stop"

#Set a TCP connection between node_(9) and node_(32)
set tcp_(8) [new Agent/TCP/Newreno]
$tcp_(8) set class_ 2
set sink_(8) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(8)
$ns attach-agent $node_(32) $sink_(8)
$ns connect $tcp_(8) $sink_(8)
set ftp_(8) [new Application/FTP]
$ftp_(8) attach-agent $tcp_(8)
$ns at 540.2 "$ftp_(8) start"
$ns at 720.0 "$ftp_(8) stop"

#Set a TCP connection between node_(14) and node_(23)
set tcp_(9) [new Agent/TCP/Newreno]
$tcp_(9) set class_ 2
set sink_(9) [new Agent/TCPSink]
$ns attach-agent $node_(14) $tcp_(9)
$ns attach-agent $node_(23) $sink_(9)
$ns connect $tcp_(9) $sink_(9)
set ftp_(9) [new Application/FTP]
$ftp_(9) attach-agent $tcp_(9)
$ns at 720.2 "$ftp_(9) start"
$ns at 900.0 "$ftp_(9) stop"

#Set a TCP connection between node_(19) and node_(21)
set tcp_(10) [new Agent/TCP/Newreno]
$tcp_(10) set class_ 2
set sink_(10) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(10)
$ns attach-agent $node_(21) $sink_(10)
$ns connect $tcp_(10) $sink_(10)
set ftp_(10) [new Application/FTP]
$ftp_(10) attach-agent $tcp_(10)
$ns at 0.2 "$ftp_(10) start"
$ns at 180.0 "$ftp_(10) stop"

#Set a TCP connection between node_(8) and node_(41)
set tcp_(11) [new Agent/TCP/Newreno]
$tcp_(11) set class_ 2
set sink_(11) [new Agent/TCPSink]
$ns attach-agent $node_(8) $tcp_(11)
$ns attach-agent $node_(41) $sink_(11)
$ns connect $tcp_(11) $sink_(11)
set ftp_(11) [new Application/FTP]
$ftp_(11) attach-agent $tcp_(11)
$ns at 180.2 "$ftp_(11) start"
$ns at 360.0 "$ftp_(11) stop"

#Set a TCP connection between node_(25) and node_(45)
set tcp_(12) [new Agent/TCP/Newreno]
$tcp_(12) set class_ 2
set sink_(12) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(12)
$ns attach-agent $node_(45) $sink_(12)
$ns connect $tcp_(12) $sink_(12)
set ftp_(12) [new Application/FTP]
$ftp_(12) attach-agent $tcp_(12)
$ns at 360.2 "$ftp_(12) start"
$ns at 540.0 "$ftp_(12) stop"

#Set a TCP connection between node_(3) and node_(21)
set tcp_(13) [new Agent/TCP/Newreno]
$tcp_(13) set class_ 2
set sink_(13) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(13)
$ns attach-agent $node_(21) $sink_(13)
$ns connect $tcp_(13) $sink_(13)
set ftp_(13) [new Application/FTP]
$ftp_(13) attach-agent $tcp_(13)
$ns at 540.2 "$ftp_(13) start"
$ns at 720.0 "$ftp_(13) stop"

#Set a TCP connection between node_(33) and node_(30)
set tcp_(14) [new Agent/TCP/Newreno]
$tcp_(14) set class_ 2
set sink_(14) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(14)
$ns attach-agent $node_(30) $sink_(14)
$ns connect $tcp_(14) $sink_(14)
set ftp_(14) [new Application/FTP]
$ftp_(14) attach-agent $tcp_(14)
$ns at 720.2 "$ftp_(14) start"
$ns at 900.0 "$ftp_(14) stop"

#Set a TCP connection between node_(23) and node_(19)
set tcp_(15) [new Agent/TCP/Newreno]
$tcp_(15) set class_ 2
set sink_(15) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(15)
$ns attach-agent $node_(19) $sink_(15)
$ns connect $tcp_(15) $sink_(15)
set ftp_(15) [new Application/FTP]
$ftp_(15) attach-agent $tcp_(15)
$ns at 0.2 "$ftp_(15) start"
$ns at 180.0 "$ftp_(15) stop"

#Set a TCP connection between node_(45) and node_(32)
set tcp_(16) [new Agent/TCP/Newreno]
$tcp_(16) set class_ 2
set sink_(16) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(16)
$ns attach-agent $node_(32) $sink_(16)
$ns connect $tcp_(16) $sink_(16)
set ftp_(16) [new Application/FTP]
$ftp_(16) attach-agent $tcp_(16)
$ns at 180.2 "$ftp_(16) start"
$ns at 360.0 "$ftp_(16) stop"

#Set a TCP connection between node_(37) and node_(28)
set tcp_(17) [new Agent/TCP/Newreno]
$tcp_(17) set class_ 2
set sink_(17) [new Agent/TCPSink]
$ns attach-agent $node_(37) $tcp_(17)
$ns attach-agent $node_(28) $sink_(17)
$ns connect $tcp_(17) $sink_(17)
set ftp_(17) [new Application/FTP]
$ftp_(17) attach-agent $tcp_(17)
$ns at 360.2 "$ftp_(17) start"
$ns at 540.0 "$ftp_(17) stop"

#Set a TCP connection between node_(4) and node_(19)
set tcp_(18) [new Agent/TCP/Newreno]
$tcp_(18) set class_ 2
set sink_(18) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(18)
$ns attach-agent $node_(19) $sink_(18)
$ns connect $tcp_(18) $sink_(18)
set ftp_(18) [new Application/FTP]
$ftp_(18) attach-agent $tcp_(18)
$ns at 540.2 "$ftp_(18) start"
$ns at 720.0 "$ftp_(18) stop"

#Set a TCP connection between node_(46) and node_(42)
set tcp_(19) [new Agent/TCP/Newreno]
$tcp_(19) set class_ 2
set sink_(19) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(19)
$ns attach-agent $node_(42) $sink_(19)
$ns connect $tcp_(19) $sink_(19)
set ftp_(19) [new Application/FTP]
$ftp_(19) attach-agent $tcp_(19)
$ns at 720.2 "$ftp_(19) start"
$ns at 900.0 "$ftp_(19) stop"

#Set a TCP connection between node_(21) and node_(13)
set tcp_(20) [new Agent/TCP/Newreno]
$tcp_(20) set class_ 2
set sink_(20) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(20)
$ns attach-agent $node_(13) $sink_(20)
$ns connect $tcp_(20) $sink_(20)
set ftp_(20) [new Application/FTP]
$ftp_(20) attach-agent $tcp_(20)
$ns at 0.2 "$ftp_(20) start"
$ns at 180.0 "$ftp_(20) stop"

#Set a TCP connection between node_(5) and node_(41)
set tcp_(21) [new Agent/TCP/Newreno]
$tcp_(21) set class_ 2
set sink_(21) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(21)
$ns attach-agent $node_(41) $sink_(21)
$ns connect $tcp_(21) $sink_(21)
set ftp_(21) [new Application/FTP]
$ftp_(21) attach-agent $tcp_(21)
$ns at 180.2 "$ftp_(21) start"
$ns at 360.0 "$ftp_(21) stop"

#Set a TCP connection between node_(25) and node_(37)
set tcp_(22) [new Agent/TCP/Newreno]
$tcp_(22) set class_ 2
set sink_(22) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(22)
$ns attach-agent $node_(37) $sink_(22)
$ns connect $tcp_(22) $sink_(22)
set ftp_(22) [new Application/FTP]
$ftp_(22) attach-agent $tcp_(22)
$ns at 360.2 "$ftp_(22) start"
$ns at 540.0 "$ftp_(22) stop"

#Set a TCP connection between node_(4) and node_(33)
set tcp_(23) [new Agent/TCP/Newreno]
$tcp_(23) set class_ 2
set sink_(23) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(23)
$ns attach-agent $node_(33) $sink_(23)
$ns connect $tcp_(23) $sink_(23)
set ftp_(23) [new Application/FTP]
$ftp_(23) attach-agent $tcp_(23)
$ns at 540.2 "$ftp_(23) start"
$ns at 720.0 "$ftp_(23) stop"

#Set a TCP connection between node_(7) and node_(37)
set tcp_(24) [new Agent/TCP/Newreno]
$tcp_(24) set class_ 2
set sink_(24) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(24)
$ns attach-agent $node_(37) $sink_(24)
$ns connect $tcp_(24) $sink_(24)
set ftp_(24) [new Application/FTP]
$ftp_(24) attach-agent $tcp_(24)
$ns at 720.2 "$ftp_(24) start"
$ns at 900.0 "$ftp_(24) stop"

#Set a TCP connection between node_(49) and node_(32)
set tcp_(25) [new Agent/TCP/Newreno]
$tcp_(25) set class_ 2
set sink_(25) [new Agent/TCPSink]
$ns attach-agent $node_(49) $tcp_(25)
$ns attach-agent $node_(32) $sink_(25)
$ns connect $tcp_(25) $sink_(25)
set ftp_(25) [new Application/FTP]
$ftp_(25) attach-agent $tcp_(25)
$ns at 0.2 "$ftp_(25) start"
$ns at 180.0 "$ftp_(25) stop"

#Set a TCP connection between node_(41) and node_(2)
set tcp_(26) [new Agent/TCP/Newreno]
$tcp_(26) set class_ 2
set sink_(26) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(26)
$ns attach-agent $node_(2) $sink_(26)
$ns connect $tcp_(26) $sink_(26)
set ftp_(26) [new Application/FTP]
$ftp_(26) attach-agent $tcp_(26)
$ns at 180.2 "$ftp_(26) start"
$ns at 360.0 "$ftp_(26) stop"

#Set a TCP connection between node_(13) and node_(1)
set tcp_(27) [new Agent/TCP/Newreno]
$tcp_(27) set class_ 2
set sink_(27) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(27)
$ns attach-agent $node_(1) $sink_(27)
$ns connect $tcp_(27) $sink_(27)
set ftp_(27) [new Application/FTP]
$ftp_(27) attach-agent $tcp_(27)
$ns at 360.2 "$ftp_(27) start"
$ns at 540.0 "$ftp_(27) stop"

#Set a TCP connection between node_(28) and node_(33)
set tcp_(28) [new Agent/TCP/Newreno]
$tcp_(28) set class_ 2
set sink_(28) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(28)
$ns attach-agent $node_(33) $sink_(28)
$ns connect $tcp_(28) $sink_(28)
set ftp_(28) [new Application/FTP]
$ftp_(28) attach-agent $tcp_(28)
$ns at 540.2 "$ftp_(28) start"
$ns at 720.0 "$ftp_(28) stop"

#Set a TCP connection between node_(31) and node_(5)
set tcp_(29) [new Agent/TCP/Newreno]
$tcp_(29) set class_ 2
set sink_(29) [new Agent/TCPSink]
$ns attach-agent $node_(31) $tcp_(29)
$ns attach-agent $node_(5) $sink_(29)
$ns connect $tcp_(29) $sink_(29)
set ftp_(29) [new Application/FTP]
$ftp_(29) attach-agent $tcp_(29)
$ns at 720.2 "$ftp_(29) start"
$ns at 900.0 "$ftp_(29) stop"

#Set a TCP connection between node_(11) and node_(3)
set tcp_(30) [new Agent/TCP/Newreno]
$tcp_(30) set class_ 2
set sink_(30) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(30)
$ns attach-agent $node_(3) $sink_(30)
$ns connect $tcp_(30) $sink_(30)
set ftp_(30) [new Application/FTP]
$ftp_(30) attach-agent $tcp_(30)
$ns at 0.2 "$ftp_(30) start"
$ns at 180.0 "$ftp_(30) stop"

#Set a TCP connection between node_(48) and node_(20)
set tcp_(31) [new Agent/TCP/Newreno]
$tcp_(31) set class_ 2
set sink_(31) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(31)
$ns attach-agent $node_(20) $sink_(31)
$ns connect $tcp_(31) $sink_(31)
set ftp_(31) [new Application/FTP]
$ftp_(31) attach-agent $tcp_(31)
$ns at 180.2 "$ftp_(31) start"
$ns at 360.0 "$ftp_(31) stop"

#Set a TCP connection between node_(22) and node_(3)
set tcp_(32) [new Agent/TCP/Newreno]
$tcp_(32) set class_ 2
set sink_(32) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(32)
$ns attach-agent $node_(3) $sink_(32)
$ns connect $tcp_(32) $sink_(32)
set ftp_(32) [new Application/FTP]
$ftp_(32) attach-agent $tcp_(32)
$ns at 360.2 "$ftp_(32) start"
$ns at 540.0 "$ftp_(32) stop"

#Set a TCP connection between node_(27) and node_(36)
set tcp_(33) [new Agent/TCP/Newreno]
$tcp_(33) set class_ 2
set sink_(33) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(33)
$ns attach-agent $node_(36) $sink_(33)
$ns connect $tcp_(33) $sink_(33)
set ftp_(33) [new Application/FTP]
$ftp_(33) attach-agent $tcp_(33)
$ns at 540.2 "$ftp_(33) start"
$ns at 720.0 "$ftp_(33) stop"

#Set a TCP connection between node_(35) and node_(21)
set tcp_(34) [new Agent/TCP/Newreno]
$tcp_(34) set class_ 2
set sink_(34) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(34)
$ns attach-agent $node_(21) $sink_(34)
$ns connect $tcp_(34) $sink_(34)
set ftp_(34) [new Application/FTP]
$ftp_(34) attach-agent $tcp_(34)
$ns at 720.2 "$ftp_(34) start"
$ns at 900.0 "$ftp_(34) stop"

#Set a TCP connection between node_(8) and node_(11)
set tcp_(35) [new Agent/TCP/Newreno]
$tcp_(35) set class_ 2
set sink_(35) [new Agent/TCPSink]
$ns attach-agent $node_(8) $tcp_(35)
$ns attach-agent $node_(11) $sink_(35)
$ns connect $tcp_(35) $sink_(35)
set ftp_(35) [new Application/FTP]
$ftp_(35) attach-agent $tcp_(35)
$ns at 0.2 "$ftp_(35) start"
$ns at 180.0 "$ftp_(35) stop"

#Set a TCP connection between node_(45) and node_(47)
set tcp_(36) [new Agent/TCP/Newreno]
$tcp_(36) set class_ 2
set sink_(36) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(36)
$ns attach-agent $node_(47) $sink_(36)
$ns connect $tcp_(36) $sink_(36)
set ftp_(36) [new Application/FTP]
$ftp_(36) attach-agent $tcp_(36)
$ns at 180.2 "$ftp_(36) start"
$ns at 360.0 "$ftp_(36) stop"

#Set a TCP connection between node_(18) and node_(10)
set tcp_(37) [new Agent/TCP/Newreno]
$tcp_(37) set class_ 2
set sink_(37) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(37)
$ns attach-agent $node_(10) $sink_(37)
$ns connect $tcp_(37) $sink_(37)
set ftp_(37) [new Application/FTP]
$ftp_(37) attach-agent $tcp_(37)
$ns at 360.2 "$ftp_(37) start"
$ns at 540.0 "$ftp_(37) stop"

#Set a TCP connection between node_(18) and node_(10)
set tcp_(38) [new Agent/TCP/Newreno]
$tcp_(38) set class_ 2
set sink_(38) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(38)
$ns attach-agent $node_(10) $sink_(38)
$ns connect $tcp_(38) $sink_(38)
set ftp_(38) [new Application/FTP]
$ftp_(38) attach-agent $tcp_(38)
$ns at 540.2 "$ftp_(38) start"
$ns at 720.0 "$ftp_(38) stop"

#Set a TCP connection between node_(32) and node_(14)
set tcp_(39) [new Agent/TCP/Newreno]
$tcp_(39) set class_ 2
set sink_(39) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(39)
$ns attach-agent $node_(14) $sink_(39)
$ns connect $tcp_(39) $sink_(39)
set ftp_(39) [new Application/FTP]
$ftp_(39) attach-agent $tcp_(39)
$ns at 720.2 "$ftp_(39) start"
$ns at 900.0 "$ftp_(39) stop"

#Set a TCP connection between node_(32) and node_(2)
set tcp_(40) [new Agent/TCP/Newreno]
$tcp_(40) set class_ 2
set sink_(40) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(40)
$ns attach-agent $node_(2) $sink_(40)
$ns connect $tcp_(40) $sink_(40)
set ftp_(40) [new Application/FTP]
$ftp_(40) attach-agent $tcp_(40)
$ns at 0.2 "$ftp_(40) start"
$ns at 180.0 "$ftp_(40) stop"

#Set a TCP connection between node_(10) and node_(5)
set tcp_(41) [new Agent/TCP/Newreno]
$tcp_(41) set class_ 2
set sink_(41) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(41)
$ns attach-agent $node_(5) $sink_(41)
$ns connect $tcp_(41) $sink_(41)
set ftp_(41) [new Application/FTP]
$ftp_(41) attach-agent $tcp_(41)
$ns at 180.2 "$ftp_(41) start"
$ns at 360.0 "$ftp_(41) stop"

#Set a TCP connection between node_(38) and node_(37)
set tcp_(42) [new Agent/TCP/Newreno]
$tcp_(42) set class_ 2
set sink_(42) [new Agent/TCPSink]
$ns attach-agent $node_(38) $tcp_(42)
$ns attach-agent $node_(37) $sink_(42)
$ns connect $tcp_(42) $sink_(42)
set ftp_(42) [new Application/FTP]
$ftp_(42) attach-agent $tcp_(42)
$ns at 360.2 "$ftp_(42) start"
$ns at 540.0 "$ftp_(42) stop"

#Set a TCP connection between node_(45) and node_(42)
set tcp_(43) [new Agent/TCP/Newreno]
$tcp_(43) set class_ 2
set sink_(43) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(43)
$ns attach-agent $node_(42) $sink_(43)
$ns connect $tcp_(43) $sink_(43)
set ftp_(43) [new Application/FTP]
$ftp_(43) attach-agent $tcp_(43)
$ns at 540.2 "$ftp_(43) start"
$ns at 720.0 "$ftp_(43) stop"

#Set a TCP connection between node_(36) and node_(25)
set tcp_(44) [new Agent/TCP/Newreno]
$tcp_(44) set class_ 2
set sink_(44) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(44)
$ns attach-agent $node_(25) $sink_(44)
$ns connect $tcp_(44) $sink_(44)
set ftp_(44) [new Application/FTP]
$ftp_(44) attach-agent $tcp_(44)
$ns at 720.2 "$ftp_(44) start"
$ns at 900.0 "$ftp_(44) stop"

#Set a TCP connection between node_(45) and node_(47)
set tcp_(45) [new Agent/TCP/Newreno]
$tcp_(45) set class_ 2
set sink_(45) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(45)
$ns attach-agent $node_(47) $sink_(45)
$ns connect $tcp_(45) $sink_(45)
set ftp_(45) [new Application/FTP]
$ftp_(45) attach-agent $tcp_(45)
$ns at 0.2 "$ftp_(45) start"
$ns at 180.0 "$ftp_(45) stop"

#Set a TCP connection between node_(36) and node_(26)
set tcp_(46) [new Agent/TCP/Newreno]
$tcp_(46) set class_ 2
set sink_(46) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(46)
$ns attach-agent $node_(26) $sink_(46)
$ns connect $tcp_(46) $sink_(46)
set ftp_(46) [new Application/FTP]
$ftp_(46) attach-agent $tcp_(46)
$ns at 180.2 "$ftp_(46) start"
$ns at 360.0 "$ftp_(46) stop"

#Set a TCP connection between node_(23) and node_(25)
set tcp_(47) [new Agent/TCP/Newreno]
$tcp_(47) set class_ 2
set sink_(47) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(47)
$ns attach-agent $node_(25) $sink_(47)
$ns connect $tcp_(47) $sink_(47)
set ftp_(47) [new Application/FTP]
$ftp_(47) attach-agent $tcp_(47)
$ns at 360.2 "$ftp_(47) start"
$ns at 540.0 "$ftp_(47) stop"

#Set a TCP connection between node_(37) and node_(22)
set tcp_(48) [new Agent/TCP/Newreno]
$tcp_(48) set class_ 2
set sink_(48) [new Agent/TCPSink]
$ns attach-agent $node_(37) $tcp_(48)
$ns attach-agent $node_(22) $sink_(48)
$ns connect $tcp_(48) $sink_(48)
set ftp_(48) [new Application/FTP]
$ftp_(48) attach-agent $tcp_(48)
$ns at 540.2 "$ftp_(48) start"
$ns at 720.0 "$ftp_(48) stop"

#Set a TCP connection between node_(18) and node_(33)
set tcp_(49) [new Agent/TCP/Newreno]
$tcp_(49) set class_ 2
set sink_(49) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(49)
$ns attach-agent $node_(33) $sink_(49)
$ns connect $tcp_(49) $sink_(49)
set ftp_(49) [new Application/FTP]
$ftp_(49) attach-agent $tcp_(49)
$ns at 720.2 "$ftp_(49) start"
$ns at 900.0 "$ftp_(49) stop"

#Set a TCP connection between node_(47) and node_(15)
set tcp_(50) [new Agent/TCP/Newreno]
$tcp_(50) set class_ 2
set sink_(50) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(50)
$ns attach-agent $node_(15) $sink_(50)
$ns connect $tcp_(50) $sink_(50)
set ftp_(50) [new Application/FTP]
$ftp_(50) attach-agent $tcp_(50)
$ns at 0.2 "$ftp_(50) start"
$ns at 180.0 "$ftp_(50) stop"

#Set a TCP connection between node_(37) and node_(14)
set tcp_(51) [new Agent/TCP/Newreno]
$tcp_(51) set class_ 2
set sink_(51) [new Agent/TCPSink]
$ns attach-agent $node_(37) $tcp_(51)
$ns attach-agent $node_(14) $sink_(51)
$ns connect $tcp_(51) $sink_(51)
set ftp_(51) [new Application/FTP]
$ftp_(51) attach-agent $tcp_(51)
$ns at 180.2 "$ftp_(51) start"
$ns at 360.0 "$ftp_(51) stop"

#Set a TCP connection between node_(41) and node_(40)
set tcp_(52) [new Agent/TCP/Newreno]
$tcp_(52) set class_ 2
set sink_(52) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(52)
$ns attach-agent $node_(40) $sink_(52)
$ns connect $tcp_(52) $sink_(52)
set ftp_(52) [new Application/FTP]
$ftp_(52) attach-agent $tcp_(52)
$ns at 360.2 "$ftp_(52) start"
$ns at 540.0 "$ftp_(52) stop"

#Set a TCP connection between node_(5) and node_(31)
set tcp_(53) [new Agent/TCP/Newreno]
$tcp_(53) set class_ 2
set sink_(53) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(53)
$ns attach-agent $node_(31) $sink_(53)
$ns connect $tcp_(53) $sink_(53)
set ftp_(53) [new Application/FTP]
$ftp_(53) attach-agent $tcp_(53)
$ns at 540.2 "$ftp_(53) start"
$ns at 720.0 "$ftp_(53) stop"

#Set a TCP connection between node_(13) and node_(21)
set tcp_(54) [new Agent/TCP/Newreno]
$tcp_(54) set class_ 2
set sink_(54) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(54)
$ns attach-agent $node_(21) $sink_(54)
$ns connect $tcp_(54) $sink_(54)
set ftp_(54) [new Application/FTP]
$ftp_(54) attach-agent $tcp_(54)
$ns at 720.2 "$ftp_(54) start"
$ns at 900.0 "$ftp_(54) stop"

#Set a TCP connection between node_(10) and node_(42)
set tcp_(55) [new Agent/TCP/Newreno]
$tcp_(55) set class_ 2
set sink_(55) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(55)
$ns attach-agent $node_(42) $sink_(55)
$ns connect $tcp_(55) $sink_(55)
set ftp_(55) [new Application/FTP]
$ftp_(55) attach-agent $tcp_(55)
$ns at 0.2 "$ftp_(55) start"
$ns at 180.0 "$ftp_(55) stop"

#Set a TCP connection between node_(44) and node_(22)
set tcp_(56) [new Agent/TCP/Newreno]
$tcp_(56) set class_ 2
set sink_(56) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(56)
$ns attach-agent $node_(22) $sink_(56)
$ns connect $tcp_(56) $sink_(56)
set ftp_(56) [new Application/FTP]
$ftp_(56) attach-agent $tcp_(56)
$ns at 180.2 "$ftp_(56) start"
$ns at 360.0 "$ftp_(56) stop"

#Set a TCP connection between node_(6) and node_(26)
set tcp_(57) [new Agent/TCP/Newreno]
$tcp_(57) set class_ 2
set sink_(57) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(57)
$ns attach-agent $node_(26) $sink_(57)
$ns connect $tcp_(57) $sink_(57)
set ftp_(57) [new Application/FTP]
$ftp_(57) attach-agent $tcp_(57)
$ns at 360.2 "$ftp_(57) start"
$ns at 540.0 "$ftp_(57) stop"

#Set a TCP connection between node_(4) and node_(29)
set tcp_(58) [new Agent/TCP/Newreno]
$tcp_(58) set class_ 2
set sink_(58) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(58)
$ns attach-agent $node_(29) $sink_(58)
$ns connect $tcp_(58) $sink_(58)
set ftp_(58) [new Application/FTP]
$ftp_(58) attach-agent $tcp_(58)
$ns at 540.2 "$ftp_(58) start"
$ns at 720.0 "$ftp_(58) stop"

#Set a TCP connection between node_(34) and node_(28)
set tcp_(59) [new Agent/TCP/Newreno]
$tcp_(59) set class_ 2
set sink_(59) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(59)
$ns attach-agent $node_(28) $sink_(59)
$ns connect $tcp_(59) $sink_(59)
set ftp_(59) [new Application/FTP]
$ftp_(59) attach-agent $tcp_(59)
$ns at 720.2 "$ftp_(59) start"
$ns at 900.0 "$ftp_(59) stop"

#Set a TCP connection between node_(45) and node_(34)
set tcp_(60) [new Agent/TCP/Newreno]
$tcp_(60) set class_ 2
set sink_(60) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(60)
$ns attach-agent $node_(34) $sink_(60)
$ns connect $tcp_(60) $sink_(60)
set ftp_(60) [new Application/FTP]
$ftp_(60) attach-agent $tcp_(60)
$ns at 0.2 "$ftp_(60) start"
$ns at 180.0 "$ftp_(60) stop"

#Set a TCP connection between node_(11) and node_(21)
set tcp_(61) [new Agent/TCP/Newreno]
$tcp_(61) set class_ 2
set sink_(61) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(61)
$ns attach-agent $node_(21) $sink_(61)
$ns connect $tcp_(61) $sink_(61)
set ftp_(61) [new Application/FTP]
$ftp_(61) attach-agent $tcp_(61)
$ns at 180.2 "$ftp_(61) start"
$ns at 360.0 "$ftp_(61) stop"

#Set a TCP connection between node_(31) and node_(34)
set tcp_(62) [new Agent/TCP/Newreno]
$tcp_(62) set class_ 2
set sink_(62) [new Agent/TCPSink]
$ns attach-agent $node_(31) $tcp_(62)
$ns attach-agent $node_(34) $sink_(62)
$ns connect $tcp_(62) $sink_(62)
set ftp_(62) [new Application/FTP]
$ftp_(62) attach-agent $tcp_(62)
$ns at 360.2 "$ftp_(62) start"
$ns at 540.0 "$ftp_(62) stop"

#Set a TCP connection between node_(8) and node_(43)
set tcp_(63) [new Agent/TCP/Newreno]
$tcp_(63) set class_ 2
set sink_(63) [new Agent/TCPSink]
$ns attach-agent $node_(8) $tcp_(63)
$ns attach-agent $node_(43) $sink_(63)
$ns connect $tcp_(63) $sink_(63)
set ftp_(63) [new Application/FTP]
$ftp_(63) attach-agent $tcp_(63)
$ns at 540.2 "$ftp_(63) start"
$ns at 720.0 "$ftp_(63) stop"

#Set a TCP connection between node_(37) and node_(48)
set tcp_(64) [new Agent/TCP/Newreno]
$tcp_(64) set class_ 2
set sink_(64) [new Agent/TCPSink]
$ns attach-agent $node_(37) $tcp_(64)
$ns attach-agent $node_(48) $sink_(64)
$ns connect $tcp_(64) $sink_(64)
set ftp_(64) [new Application/FTP]
$ftp_(64) attach-agent $tcp_(64)
$ns at 720.2 "$ftp_(64) start"
$ns at 900.0 "$ftp_(64) stop"

#Set a TCP connection between node_(45) and node_(0)
set tcp_(65) [new Agent/TCP/Newreno]
$tcp_(65) set class_ 2
set sink_(65) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(65)
$ns attach-agent $node_(0) $sink_(65)
$ns connect $tcp_(65) $sink_(65)
set ftp_(65) [new Application/FTP]
$ftp_(65) attach-agent $tcp_(65)
$ns at 0.2 "$ftp_(65) start"
$ns at 180.0 "$ftp_(65) stop"

#Set a TCP connection between node_(44) and node_(26)
set tcp_(66) [new Agent/TCP/Newreno]
$tcp_(66) set class_ 2
set sink_(66) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(66)
$ns attach-agent $node_(26) $sink_(66)
$ns connect $tcp_(66) $sink_(66)
set ftp_(66) [new Application/FTP]
$ftp_(66) attach-agent $tcp_(66)
$ns at 180.2 "$ftp_(66) start"
$ns at 360.0 "$ftp_(66) stop"

#Set a TCP connection between node_(21) and node_(37)
set tcp_(67) [new Agent/TCP/Newreno]
$tcp_(67) set class_ 2
set sink_(67) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(67)
$ns attach-agent $node_(37) $sink_(67)
$ns connect $tcp_(67) $sink_(67)
set ftp_(67) [new Application/FTP]
$ftp_(67) attach-agent $tcp_(67)
$ns at 360.2 "$ftp_(67) start"
$ns at 540.0 "$ftp_(67) stop"

#Set a TCP connection between node_(7) and node_(43)
set tcp_(68) [new Agent/TCP/Newreno]
$tcp_(68) set class_ 2
set sink_(68) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(68)
$ns attach-agent $node_(43) $sink_(68)
$ns connect $tcp_(68) $sink_(68)
set ftp_(68) [new Application/FTP]
$ftp_(68) attach-agent $tcp_(68)
$ns at 540.2 "$ftp_(68) start"
$ns at 720.0 "$ftp_(68) stop"

#Set a TCP connection between node_(27) and node_(12)
set tcp_(69) [new Agent/TCP/Newreno]
$tcp_(69) set class_ 2
set sink_(69) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(69)
$ns attach-agent $node_(12) $sink_(69)
$ns connect $tcp_(69) $sink_(69)
set ftp_(69) [new Application/FTP]
$ftp_(69) attach-agent $tcp_(69)
$ns at 720.2 "$ftp_(69) start"
$ns at 900.0 "$ftp_(69) stop"

#Set a TCP connection between node_(31) and node_(33)
set tcp_(70) [new Agent/TCP/Newreno]
$tcp_(70) set class_ 2
set sink_(70) [new Agent/TCPSink]
$ns attach-agent $node_(31) $tcp_(70)
$ns attach-agent $node_(33) $sink_(70)
$ns connect $tcp_(70) $sink_(70)
set ftp_(70) [new Application/FTP]
$ftp_(70) attach-agent $tcp_(70)
$ns at 0.2 "$ftp_(70) start"
$ns at 180.0 "$ftp_(70) stop"

#Set a TCP connection between node_(12) and node_(3)
set tcp_(71) [new Agent/TCP/Newreno]
$tcp_(71) set class_ 2
set sink_(71) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(71)
$ns attach-agent $node_(3) $sink_(71)
$ns connect $tcp_(71) $sink_(71)
set ftp_(71) [new Application/FTP]
$ftp_(71) attach-agent $tcp_(71)
$ns at 180.2 "$ftp_(71) start"
$ns at 360.0 "$ftp_(71) stop"

#Set a TCP connection between node_(5) and node_(39)
set tcp_(72) [new Agent/TCP/Newreno]
$tcp_(72) set class_ 2
set sink_(72) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(72)
$ns attach-agent $node_(39) $sink_(72)
$ns connect $tcp_(72) $sink_(72)
set ftp_(72) [new Application/FTP]
$ftp_(72) attach-agent $tcp_(72)
$ns at 360.2 "$ftp_(72) start"
$ns at 540.0 "$ftp_(72) stop"

#Set a TCP connection between node_(33) and node_(15)
set tcp_(73) [new Agent/TCP/Newreno]
$tcp_(73) set class_ 2
set sink_(73) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(73)
$ns attach-agent $node_(15) $sink_(73)
$ns connect $tcp_(73) $sink_(73)
set ftp_(73) [new Application/FTP]
$ftp_(73) attach-agent $tcp_(73)
$ns at 540.2 "$ftp_(73) start"
$ns at 720.0 "$ftp_(73) stop"

#Set a TCP connection between node_(6) and node_(2)
set tcp_(74) [new Agent/TCP/Newreno]
$tcp_(74) set class_ 2
set sink_(74) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(74)
$ns attach-agent $node_(2) $sink_(74)
$ns connect $tcp_(74) $sink_(74)
set ftp_(74) [new Application/FTP]
$ftp_(74) attach-agent $tcp_(74)
$ns at 720.2 "$ftp_(74) start"
$ns at 900.0 "$ftp_(74) stop"

#Set a TCP connection between node_(37) and node_(47)
set tcp_(75) [new Agent/TCP/Newreno]
$tcp_(75) set class_ 2
set sink_(75) [new Agent/TCPSink]
$ns attach-agent $node_(37) $tcp_(75)
$ns attach-agent $node_(47) $sink_(75)
$ns connect $tcp_(75) $sink_(75)
set ftp_(75) [new Application/FTP]
$ftp_(75) attach-agent $tcp_(75)
$ns at 0.2 "$ftp_(75) start"
$ns at 180.0 "$ftp_(75) stop"

#Set a TCP connection between node_(25) and node_(18)
set tcp_(76) [new Agent/TCP/Newreno]
$tcp_(76) set class_ 2
set sink_(76) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(76)
$ns attach-agent $node_(18) $sink_(76)
$ns connect $tcp_(76) $sink_(76)
set ftp_(76) [new Application/FTP]
$ftp_(76) attach-agent $tcp_(76)
$ns at 180.2 "$ftp_(76) start"
$ns at 360.0 "$ftp_(76) stop"

#Set a TCP connection between node_(3) and node_(29)
set tcp_(77) [new Agent/TCP/Newreno]
$tcp_(77) set class_ 2
set sink_(77) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(77)
$ns attach-agent $node_(29) $sink_(77)
$ns connect $tcp_(77) $sink_(77)
set ftp_(77) [new Application/FTP]
$ftp_(77) attach-agent $tcp_(77)
$ns at 360.2 "$ftp_(77) start"
$ns at 540.0 "$ftp_(77) stop"

#Set a TCP connection between node_(44) and node_(2)
set tcp_(78) [new Agent/TCP/Newreno]
$tcp_(78) set class_ 2
set sink_(78) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(78)
$ns attach-agent $node_(2) $sink_(78)
$ns connect $tcp_(78) $sink_(78)
set ftp_(78) [new Application/FTP]
$ftp_(78) attach-agent $tcp_(78)
$ns at 540.2 "$ftp_(78) start"
$ns at 720.0 "$ftp_(78) stop"

#Set a TCP connection between node_(7) and node_(15)
set tcp_(79) [new Agent/TCP/Newreno]
$tcp_(79) set class_ 2
set sink_(79) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(79)
$ns attach-agent $node_(15) $sink_(79)
$ns connect $tcp_(79) $sink_(79)
set ftp_(79) [new Application/FTP]
$ftp_(79) attach-agent $tcp_(79)
$ns at 720.2 "$ftp_(79) start"
$ns at 900.0 "$ftp_(79) stop"

#Set a TCP connection between node_(19) and node_(9)
set tcp_(80) [new Agent/TCP/Newreno]
$tcp_(80) set class_ 2
set sink_(80) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(80)
$ns attach-agent $node_(9) $sink_(80)
$ns connect $tcp_(80) $sink_(80)
set ftp_(80) [new Application/FTP]
$ftp_(80) attach-agent $tcp_(80)
$ns at 0.2 "$ftp_(80) start"
$ns at 180.0 "$ftp_(80) stop"

#Set a TCP connection between node_(9) and node_(41)
set tcp_(81) [new Agent/TCP/Newreno]
$tcp_(81) set class_ 2
set sink_(81) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(81)
$ns attach-agent $node_(41) $sink_(81)
$ns connect $tcp_(81) $sink_(81)
set ftp_(81) [new Application/FTP]
$ftp_(81) attach-agent $tcp_(81)
$ns at 180.2 "$ftp_(81) start"
$ns at 360.0 "$ftp_(81) stop"

#Set a TCP connection between node_(23) and node_(45)
set tcp_(82) [new Agent/TCP/Newreno]
$tcp_(82) set class_ 2
set sink_(82) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(82)
$ns attach-agent $node_(45) $sink_(82)
$ns connect $tcp_(82) $sink_(82)
set ftp_(82) [new Application/FTP]
$ftp_(82) attach-agent $tcp_(82)
$ns at 360.2 "$ftp_(82) start"
$ns at 540.0 "$ftp_(82) stop"

#Set a TCP connection between node_(36) and node_(2)
set tcp_(83) [new Agent/TCP/Newreno]
$tcp_(83) set class_ 2
set sink_(83) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(83)
$ns attach-agent $node_(2) $sink_(83)
$ns connect $tcp_(83) $sink_(83)
set ftp_(83) [new Application/FTP]
$ftp_(83) attach-agent $tcp_(83)
$ns at 540.2 "$ftp_(83) start"
$ns at 720.0 "$ftp_(83) stop"

#Set a TCP connection between node_(28) and node_(6)
set tcp_(84) [new Agent/TCP/Newreno]
$tcp_(84) set class_ 2
set sink_(84) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(84)
$ns attach-agent $node_(6) $sink_(84)
$ns connect $tcp_(84) $sink_(84)
set ftp_(84) [new Application/FTP]
$ftp_(84) attach-agent $tcp_(84)
$ns at 720.2 "$ftp_(84) start"
$ns at 900.0 "$ftp_(84) stop"

#Set a TCP connection between node_(46) and node_(28)
set tcp_(85) [new Agent/TCP/Newreno]
$tcp_(85) set class_ 2
set sink_(85) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(85)
$ns attach-agent $node_(28) $sink_(85)
$ns connect $tcp_(85) $sink_(85)
set ftp_(85) [new Application/FTP]
$ftp_(85) attach-agent $tcp_(85)
$ns at 0.2 "$ftp_(85) start"
$ns at 180.0 "$ftp_(85) stop"

#Set a TCP connection between node_(31) and node_(35)
set tcp_(86) [new Agent/TCP/Newreno]
$tcp_(86) set class_ 2
set sink_(86) [new Agent/TCPSink]
$ns attach-agent $node_(31) $tcp_(86)
$ns attach-agent $node_(35) $sink_(86)
$ns connect $tcp_(86) $sink_(86)
set ftp_(86) [new Application/FTP]
$ftp_(86) attach-agent $tcp_(86)
$ns at 180.2 "$ftp_(86) start"
$ns at 360.0 "$ftp_(86) stop"

#Set a TCP connection between node_(27) and node_(2)
set tcp_(87) [new Agent/TCP/Newreno]
$tcp_(87) set class_ 2
set sink_(87) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(87)
$ns attach-agent $node_(2) $sink_(87)
$ns connect $tcp_(87) $sink_(87)
set ftp_(87) [new Application/FTP]
$ftp_(87) attach-agent $tcp_(87)
$ns at 360.2 "$ftp_(87) start"
$ns at 540.0 "$ftp_(87) stop"

#Set a TCP connection between node_(40) and node_(20)
set tcp_(88) [new Agent/TCP/Newreno]
$tcp_(88) set class_ 2
set sink_(88) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(88)
$ns attach-agent $node_(20) $sink_(88)
$ns connect $tcp_(88) $sink_(88)
set ftp_(88) [new Application/FTP]
$ftp_(88) attach-agent $tcp_(88)
$ns at 540.2 "$ftp_(88) start"
$ns at 720.0 "$ftp_(88) stop"

#Set a TCP connection between node_(6) and node_(4)
set tcp_(89) [new Agent/TCP/Newreno]
$tcp_(89) set class_ 2
set sink_(89) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(89)
$ns attach-agent $node_(4) $sink_(89)
$ns connect $tcp_(89) $sink_(89)
set ftp_(89) [new Application/FTP]
$ftp_(89) attach-agent $tcp_(89)
$ns at 720.2 "$ftp_(89) start"
$ns at 900.0 "$ftp_(89) stop"

#Set a TCP connection between node_(21) and node_(10)
set tcp_(90) [new Agent/TCP/Newreno]
$tcp_(90) set class_ 2
set sink_(90) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(90)
$ns attach-agent $node_(10) $sink_(90)
$ns connect $tcp_(90) $sink_(90)
set ftp_(90) [new Application/FTP]
$ftp_(90) attach-agent $tcp_(90)
$ns at 0.2 "$ftp_(90) start"
$ns at 180.0 "$ftp_(90) stop"

#Set a TCP connection between node_(20) and node_(16)
set tcp_(91) [new Agent/TCP/Newreno]
$tcp_(91) set class_ 2
set sink_(91) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(91)
$ns attach-agent $node_(16) $sink_(91)
$ns connect $tcp_(91) $sink_(91)
set ftp_(91) [new Application/FTP]
$ftp_(91) attach-agent $tcp_(91)
$ns at 180.2 "$ftp_(91) start"
$ns at 360.0 "$ftp_(91) stop"

#Set a TCP connection between node_(31) and node_(25)
set tcp_(92) [new Agent/TCP/Newreno]
$tcp_(92) set class_ 2
set sink_(92) [new Agent/TCPSink]
$ns attach-agent $node_(31) $tcp_(92)
$ns attach-agent $node_(25) $sink_(92)
$ns connect $tcp_(92) $sink_(92)
set ftp_(92) [new Application/FTP]
$ftp_(92) attach-agent $tcp_(92)
$ns at 360.2 "$ftp_(92) start"
$ns at 540.0 "$ftp_(92) stop"

#Set a TCP connection between node_(21) and node_(25)
set tcp_(93) [new Agent/TCP/Newreno]
$tcp_(93) set class_ 2
set sink_(93) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(93)
$ns attach-agent $node_(25) $sink_(93)
$ns connect $tcp_(93) $sink_(93)
set ftp_(93) [new Application/FTP]
$ftp_(93) attach-agent $tcp_(93)
$ns at 540.2 "$ftp_(93) start"
$ns at 720.0 "$ftp_(93) stop"

#Set a TCP connection between node_(5) and node_(27)
set tcp_(94) [new Agent/TCP/Newreno]
$tcp_(94) set class_ 2
set sink_(94) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(94)
$ns attach-agent $node_(27) $sink_(94)
$ns connect $tcp_(94) $sink_(94)
set ftp_(94) [new Application/FTP]
$ftp_(94) attach-agent $tcp_(94)
$ns at 720.2 "$ftp_(94) start"
$ns at 900.0 "$ftp_(94) stop"

#Set a TCP connection between node_(6) and node_(26)
set tcp_(95) [new Agent/TCP/Newreno]
$tcp_(95) set class_ 2
set sink_(95) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(95)
$ns attach-agent $node_(26) $sink_(95)
$ns connect $tcp_(95) $sink_(95)
set ftp_(95) [new Application/FTP]
$ftp_(95) attach-agent $tcp_(95)
$ns at 0.2 "$ftp_(95) start"
$ns at 180.0 "$ftp_(95) stop"

#Set a TCP connection between node_(45) and node_(6)
set tcp_(96) [new Agent/TCP/Newreno]
$tcp_(96) set class_ 2
set sink_(96) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(96)
$ns attach-agent $node_(6) $sink_(96)
$ns connect $tcp_(96) $sink_(96)
set ftp_(96) [new Application/FTP]
$ftp_(96) attach-agent $tcp_(96)
$ns at 180.2 "$ftp_(96) start"
$ns at 360.0 "$ftp_(96) stop"

#Set a TCP connection between node_(33) and node_(8)
set tcp_(97) [new Agent/TCP/Newreno]
$tcp_(97) set class_ 2
set sink_(97) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(97)
$ns attach-agent $node_(8) $sink_(97)
$ns connect $tcp_(97) $sink_(97)
set ftp_(97) [new Application/FTP]
$ftp_(97) attach-agent $tcp_(97)
$ns at 360.2 "$ftp_(97) start"
$ns at 540.0 "$ftp_(97) stop"

#Set a TCP connection between node_(5) and node_(8)
set tcp_(98) [new Agent/TCP/Newreno]
$tcp_(98) set class_ 2
set sink_(98) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(98)
$ns attach-agent $node_(8) $sink_(98)
$ns connect $tcp_(98) $sink_(98)
set ftp_(98) [new Application/FTP]
$ftp_(98) attach-agent $tcp_(98)
$ns at 540.2 "$ftp_(98) start"
$ns at 720.0 "$ftp_(98) stop"

#Set a TCP connection between node_(27) and node_(6)
set tcp_(99) [new Agent/TCP/Newreno]
$tcp_(99) set class_ 2
set sink_(99) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(99)
$ns attach-agent $node_(6) $sink_(99)
$ns connect $tcp_(99) $sink_(99)
set ftp_(99) [new Application/FTP]
$ftp_(99) attach-agent $tcp_(99)
$ns at 720.2 "$ftp_(99) start"
$ns at 900.0 "$ftp_(99) stop"

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
$ns at 900.01 "puts \"end simulation\" ; $ns halt" 
proc stop {} { 
    global ns tracefd namtrace 
    $ns flush-trace 
    close $tracefd 
    close $namtrace 
} 

$ns run 
