#sim-scn2-7.tcl 
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
set tracefd       [open sim-scn2-7-$val(rp)-trace.tr w]
set windowVsTime2 [open sim-scn2-7-$val(rp)-win-.tr w]
set namtrace      [open sim-scn2-7-$val(rp).nam w]

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
$node_(0) set X_ 2630 
$node_(0) set Y_ 20 
$node_(0) set Z_ 0.0 
$node_(1) set X_ 2775 
$node_(1) set Y_ 613 
$node_(1) set Z_ 0.0 
$node_(2) set X_ 407 
$node_(2) set Y_ 614 
$node_(2) set Z_ 0.0 
$node_(3) set X_ 2794 
$node_(3) set Y_ 2 
$node_(3) set Z_ 0.0 
$node_(4) set X_ 2153 
$node_(4) set Y_ 273 
$node_(4) set Z_ 0.0 
$node_(5) set X_ 1980 
$node_(5) set Y_ 383 
$node_(5) set Z_ 0.0 
$node_(6) set X_ 1569 
$node_(6) set Y_ 216 
$node_(6) set Z_ 0.0 
$node_(7) set X_ 1881 
$node_(7) set Y_ 976 
$node_(7) set Z_ 0.0 
$node_(8) set X_ 2875 
$node_(8) set Y_ 766 
$node_(8) set Z_ 0.0 
$node_(9) set X_ 373 
$node_(9) set Y_ 199 
$node_(9) set Z_ 0.0 
$node_(10) set X_ 2176 
$node_(10) set Y_ 912 
$node_(10) set Z_ 0.0 
$node_(11) set X_ 1623 
$node_(11) set Y_ 295 
$node_(11) set Z_ 0.0 
$node_(12) set X_ 1842 
$node_(12) set Y_ 912 
$node_(12) set Z_ 0.0 
$node_(13) set X_ 1530 
$node_(13) set Y_ 91 
$node_(13) set Z_ 0.0 
$node_(14) set X_ 136 
$node_(14) set Y_ 29 
$node_(14) set Z_ 0.0 
$node_(15) set X_ 507 
$node_(15) set Y_ 683 
$node_(15) set Z_ 0.0 
$node_(16) set X_ 518 
$node_(16) set Y_ 450 
$node_(16) set Z_ 0.0 
$node_(17) set X_ 1367 
$node_(17) set Y_ 504 
$node_(17) set Z_ 0.0 
$node_(18) set X_ 2395 
$node_(18) set Y_ 28 
$node_(18) set Z_ 0.0 
$node_(19) set X_ 2672 
$node_(19) set Y_ 8 
$node_(19) set Z_ 0.0 
$node_(20) set X_ 695 
$node_(20) set Y_ 711 
$node_(20) set Z_ 0.0 
$node_(21) set X_ 2231 
$node_(21) set Y_ 148 
$node_(21) set Z_ 0.0 
$node_(22) set X_ 1452 
$node_(22) set Y_ 462 
$node_(22) set Z_ 0.0 
$node_(23) set X_ 2494 
$node_(23) set Y_ 963 
$node_(23) set Z_ 0.0 
$node_(24) set X_ 2618 
$node_(24) set Y_ 3 
$node_(24) set Z_ 0.0 
$node_(25) set X_ 1330 
$node_(25) set Y_ 811 
$node_(25) set Z_ 0.0 
$node_(26) set X_ 566 
$node_(26) set Y_ 943 
$node_(26) set Z_ 0.0 
$node_(27) set X_ 193 
$node_(27) set Y_ 242 
$node_(27) set Z_ 0.0 
$node_(28) set X_ 222 
$node_(28) set Y_ 722 
$node_(28) set Z_ 0.0 
$node_(29) set X_ 1835 
$node_(29) set Y_ 43 
$node_(29) set Z_ 0.0 
$node_(30) set X_ 436 
$node_(30) set Y_ 337 
$node_(30) set Z_ 0.0 
$node_(31) set X_ 2703 
$node_(31) set Y_ 758 
$node_(31) set Z_ 0.0 
$node_(32) set X_ 2132 
$node_(32) set Y_ 986 
$node_(32) set Z_ 0.0 
$node_(33) set X_ 2746 
$node_(33) set Y_ 841 
$node_(33) set Z_ 0.0 
$node_(34) set X_ 1872 
$node_(34) set Y_ 625 
$node_(34) set Z_ 0.0 
$node_(35) set X_ 747 
$node_(35) set Y_ 654 
$node_(35) set Z_ 0.0 
$node_(36) set X_ 2831 
$node_(36) set Y_ 907 
$node_(36) set Z_ 0.0 
$node_(37) set X_ 2362 
$node_(37) set Y_ 742 
$node_(37) set Z_ 0.0 
$node_(38) set X_ 1745 
$node_(38) set Y_ 157 
$node_(38) set Z_ 0.0 
$node_(39) set X_ 844 
$node_(39) set Y_ 131 
$node_(39) set Z_ 0.0 
$node_(40) set X_ 147 
$node_(40) set Y_ 812 
$node_(40) set Z_ 0.0 
$node_(41) set X_ 2944 
$node_(41) set Y_ 957 
$node_(41) set Z_ 0.0 
$node_(42) set X_ 2242 
$node_(42) set Y_ 243 
$node_(42) set Z_ 0.0 
$node_(43) set X_ 2716 
$node_(43) set Y_ 364 
$node_(43) set Z_ 0.0 
$node_(44) set X_ 2961 
$node_(44) set Y_ 3 
$node_(44) set Z_ 0.0 
$node_(45) set X_ 1910 
$node_(45) set Y_ 450 
$node_(45) set Z_ 0.0 
$node_(46) set X_ 187 
$node_(46) set Y_ 289 
$node_(46) set Z_ 0.0 
$node_(47) set X_ 2294 
$node_(47) set Y_ 30 
$node_(47) set Z_ 0.0 
$node_(48) set X_ 789 
$node_(48) set Y_ 890 
$node_(48) set Z_ 0.0 
$node_(49) set X_ 654 
$node_(49) set Y_ 101 
$node_(49) set Z_ 0.0 
$node_(50) set X_ 1985 
$node_(50) set Y_ 940 
$node_(50) set Z_ 0.0 
$node_(51) set X_ 2309 
$node_(51) set Y_ 207 
$node_(51) set Z_ 0.0 
$ns at 0.0 "$node_(51) off" 
$ns at 165.0 "$node_(51) on" 
$node_(52) set X_ 2642 
$node_(52) set Y_ 570 
$node_(52) set Z_ 0.0 
$ns at 0.0 "$node_(52) off" 
$ns at 165.0 "$node_(52) on" 
$node_(53) set X_ 2829 
$node_(53) set Y_ 349 
$node_(53) set Z_ 0.0 
$ns at 0.0 "$node_(53) off" 
$ns at 165.0 "$node_(53) on" 
$node_(54) set X_ 2437 
$node_(54) set Y_ 939 
$node_(54) set Z_ 0.0 
$ns at 0.0 "$node_(54) off" 
$ns at 165.0 "$node_(54) on" 
$node_(55) set X_ 1165 
$node_(55) set Y_ 674 
$node_(55) set Z_ 0.0 
$ns at 0.0 "$node_(55) off" 
$ns at 165.0 "$node_(55) on" 
$node_(56) set X_ 1315 
$node_(56) set Y_ 198 
$node_(56) set Z_ 0.0 
$ns at 0.0 "$node_(56) off" 
$ns at 165.0 "$node_(56) on" 
$node_(57) set X_ 1682 
$node_(57) set Y_ 966 
$node_(57) set Z_ 0.0 
$ns at 0.0 "$node_(57) off" 
$ns at 165.0 "$node_(57) on" 
$node_(58) set X_ 1472 
$node_(58) set Y_ 647 
$node_(58) set Z_ 0.0 
$ns at 0.0 "$node_(58) off" 
$ns at 165.0 "$node_(58) on" 
$node_(59) set X_ 567 
$node_(59) set Y_ 869 
$node_(59) set Z_ 0.0 
$ns at 0.0 "$node_(59) off" 
$ns at 165.0 "$node_(59) on" 
$node_(60) set X_ 2001 
$node_(60) set Y_ 715 
$node_(60) set Z_ 0.0 
$ns at 0.0 "$node_(60) off" 
$ns at 165.0 "$node_(60) on" 
$node_(61) set X_ 1777 
$node_(61) set Y_ 835 
$node_(61) set Z_ 0.0 
$ns at 0.0 "$node_(61) off" 
$ns at 165.0 "$node_(61) on" 
$node_(62) set X_ 1570 
$node_(62) set Y_ 441 
$node_(62) set Z_ 0.0 
$ns at 0.0 "$node_(62) off" 
$ns at 165.0 "$node_(62) on" 
$node_(63) set X_ 1120 
$node_(63) set Y_ 44 
$node_(63) set Z_ 0.0 
$ns at 0.0 "$node_(63) off" 
$ns at 165.0 "$node_(63) on" 
$node_(64) set X_ 2896 
$node_(64) set Y_ 782 
$node_(64) set Z_ 0.0 
$ns at 0.0 "$node_(64) off" 
$ns at 165.0 "$node_(64) on" 
$node_(65) set X_ 1209 
$node_(65) set Y_ 913 
$node_(65) set Z_ 0.0 
$ns at 0.0 "$node_(65) off" 
$ns at 165.0 "$node_(65) on" 
$node_(66) set X_ 1388 
$node_(66) set Y_ 453 
$node_(66) set Z_ 0.0 
$ns at 0.0 "$node_(66) off" 
$ns at 165.0 "$node_(66) on" 
$node_(67) set X_ 860 
$node_(67) set Y_ 367 
$node_(67) set Z_ 0.0 
$ns at 0.0 "$node_(67) off" 
$ns at 165.0 "$node_(67) on" 
$node_(68) set X_ 2187 
$node_(68) set Y_ 986 
$node_(68) set Z_ 0.0 
$ns at 0.0 "$node_(68) off" 
$ns at 165.0 "$node_(68) on" 
$node_(69) set X_ 2131 
$node_(69) set Y_ 734 
$node_(69) set Z_ 0.0 
$ns at 0.0 "$node_(69) off" 
$ns at 165.0 "$node_(69) on" 
$node_(70) set X_ 1898 
$node_(70) set Y_ 333 
$node_(70) set Z_ 0.0 
$ns at 0.0 "$node_(70) off" 
$ns at 165.0 "$node_(70) on" 
$node_(71) set X_ 432 
$node_(71) set Y_ 996 
$node_(71) set Z_ 0.0 
$ns at 0.0 "$node_(71) off" 
$ns at 165.0 "$node_(71) on" 
$node_(72) set X_ 1575 
$node_(72) set Y_ 672 
$node_(72) set Z_ 0.0 
$ns at 0.0 "$node_(72) off" 
$ns at 165.0 "$node_(72) on" 
$node_(73) set X_ 1205 
$node_(73) set Y_ 124 
$node_(73) set Z_ 0.0 
$ns at 0.0 "$node_(73) off" 
$ns at 165.0 "$node_(73) on" 
$node_(74) set X_ 29 
$node_(74) set Y_ 27 
$node_(74) set Z_ 0.0 
$ns at 0.0 "$node_(74) off" 
$ns at 165.0 "$node_(74) on" 
$node_(75) set X_ 1384 
$node_(75) set Y_ 407 
$node_(75) set Z_ 0.0 
$ns at 0.0 "$node_(75) off" 
$ns at 330.0 "$node_(75) on" 
$node_(76) set X_ 1242 
$node_(76) set Y_ 948 
$node_(76) set Z_ 0.0 
$ns at 0.0 "$node_(76) off" 
$ns at 330.0 "$node_(76) on" 
$node_(77) set X_ 2287 
$node_(77) set Y_ 13 
$node_(77) set Z_ 0.0 
$ns at 0.0 "$node_(77) off" 
$ns at 330.0 "$node_(77) on" 
$node_(78) set X_ 2615 
$node_(78) set Y_ 743 
$node_(78) set Z_ 0.0 
$ns at 0.0 "$node_(78) off" 
$ns at 330.0 "$node_(78) on" 
$node_(79) set X_ 2787 
$node_(79) set Y_ 477 
$node_(79) set Z_ 0.0 
$ns at 0.0 "$node_(79) off" 
$ns at 330.0 "$node_(79) on" 
$node_(80) set X_ 2912 
$node_(80) set Y_ 738 
$node_(80) set Z_ 0.0 
$ns at 0.0 "$node_(80) off" 
$ns at 330.0 "$node_(80) on" 
$node_(81) set X_ 1474 
$node_(81) set Y_ 487 
$node_(81) set Z_ 0.0 
$ns at 0.0 "$node_(81) off" 
$ns at 330.0 "$node_(81) on" 
$node_(82) set X_ 1170 
$node_(82) set Y_ 588 
$node_(82) set Z_ 0.0 
$ns at 0.0 "$node_(82) off" 
$ns at 330.0 "$node_(82) on" 
$node_(83) set X_ 2150 
$node_(83) set Y_ 99 
$node_(83) set Z_ 0.0 
$ns at 0.0 "$node_(83) off" 
$ns at 330.0 "$node_(83) on" 
$node_(84) set X_ 2400 
$node_(84) set Y_ 930 
$node_(84) set Z_ 0.0 
$ns at 0.0 "$node_(84) off" 
$ns at 330.0 "$node_(84) on" 
$node_(85) set X_ 315 
$node_(85) set Y_ 477 
$node_(85) set Z_ 0.0 
$ns at 0.0 "$node_(85) off" 
$ns at 330.0 "$node_(85) on" 
$node_(86) set X_ 1754 
$node_(86) set Y_ 571 
$node_(86) set Z_ 0.0 
$ns at 0.0 "$node_(86) off" 
$ns at 330.0 "$node_(86) on" 
$node_(87) set X_ 1340 
$node_(87) set Y_ 361 
$node_(87) set Z_ 0.0 
$ns at 0.0 "$node_(87) off" 
$ns at 330.0 "$node_(87) on" 
$node_(88) set X_ 1817 
$node_(88) set Y_ 964 
$node_(88) set Z_ 0.0 
$ns at 0.0 "$node_(88) off" 
$ns at 330.0 "$node_(88) on" 
$node_(89) set X_ 1809 
$node_(89) set Y_ 730 
$node_(89) set Z_ 0.0 
$ns at 0.0 "$node_(89) off" 
$ns at 330.0 "$node_(89) on" 
$node_(90) set X_ 985 
$node_(90) set Y_ 926 
$node_(90) set Z_ 0.0 
$ns at 0.0 "$node_(90) off" 
$ns at 330.0 "$node_(90) on" 
$node_(91) set X_ 976 
$node_(91) set Y_ 533 
$node_(91) set Z_ 0.0 
$ns at 0.0 "$node_(91) off" 
$ns at 330.0 "$node_(91) on" 
$node_(92) set X_ 317 
$node_(92) set Y_ 452 
$node_(92) set Z_ 0.0 
$ns at 0.0 "$node_(92) off" 
$ns at 330.0 "$node_(92) on" 
$node_(93) set X_ 1498 
$node_(93) set Y_ 954 
$node_(93) set Z_ 0.0 
$ns at 0.0 "$node_(93) off" 
$ns at 330.0 "$node_(93) on" 
$node_(94) set X_ 946 
$node_(94) set Y_ 976 
$node_(94) set Z_ 0.0 
$ns at 0.0 "$node_(94) off" 
$ns at 330.0 "$node_(94) on" 
$node_(95) set X_ 512 
$node_(95) set Y_ 402 
$node_(95) set Z_ 0.0 
$ns at 0.0 "$node_(95) off" 
$ns at 330.0 "$node_(95) on" 
$node_(96) set X_ 1055 
$node_(96) set Y_ 642 
$node_(96) set Z_ 0.0 
$ns at 0.0 "$node_(96) off" 
$ns at 330.0 "$node_(96) on" 
$node_(97) set X_ 1778 
$node_(97) set Y_ 285 
$node_(97) set Z_ 0.0 
$ns at 0.0 "$node_(97) off" 
$ns at 330.0 "$node_(97) on" 
$node_(98) set X_ 529 
$node_(98) set Y_ 975 
$node_(98) set Z_ 0.0 
$ns at 0.0 "$node_(98) off" 
$ns at 330.0 "$node_(98) on" 
$node_(99) set X_ 967 
$node_(99) set Y_ 721 
$node_(99) set Z_ 0.0 
$ns at 0.0 "$node_(99) off" 
$ns at 330.0 "$node_(99) on" 
$node_(100) set X_ 741 
$node_(100) set Y_ 826 
$node_(100) set Z_ 0.0 
$ns at 0.0 "$node_(100) off" 
$ns at 495.0 "$node_(100) on" 
$node_(101) set X_ 234 
$node_(101) set Y_ 468 
$node_(101) set Z_ 0.0 
$ns at 0.0 "$node_(101) off" 
$ns at 495.0 "$node_(101) on" 
$node_(102) set X_ 497 
$node_(102) set Y_ 658 
$node_(102) set Z_ 0.0 
$ns at 0.0 "$node_(102) off" 
$ns at 495.0 "$node_(102) on" 
$node_(103) set X_ 2031 
$node_(103) set Y_ 786 
$node_(103) set Z_ 0.0 
$ns at 0.0 "$node_(103) off" 
$ns at 495.0 "$node_(103) on" 
$node_(104) set X_ 952 
$node_(104) set Y_ 7 
$node_(104) set Z_ 0.0 
$ns at 0.0 "$node_(104) off" 
$ns at 495.0 "$node_(104) on" 
$node_(105) set X_ 2622 
$node_(105) set Y_ 395 
$node_(105) set Z_ 0.0 
$ns at 0.0 "$node_(105) off" 
$ns at 495.0 "$node_(105) on" 
$node_(106) set X_ 275 
$node_(106) set Y_ 435 
$node_(106) set Z_ 0.0 
$ns at 0.0 "$node_(106) off" 
$ns at 495.0 "$node_(106) on" 
$node_(107) set X_ 994 
$node_(107) set Y_ 407 
$node_(107) set Z_ 0.0 
$ns at 0.0 "$node_(107) off" 
$ns at 495.0 "$node_(107) on" 
$node_(108) set X_ 109 
$node_(108) set Y_ 429 
$node_(108) set Z_ 0.0 
$ns at 0.0 "$node_(108) off" 
$ns at 495.0 "$node_(108) on" 
$node_(109) set X_ 810 
$node_(109) set Y_ 901 
$node_(109) set Z_ 0.0 
$ns at 0.0 "$node_(109) off" 
$ns at 495.0 "$node_(109) on" 
$node_(110) set X_ 1266 
$node_(110) set Y_ 448 
$node_(110) set Z_ 0.0 
$ns at 0.0 "$node_(110) off" 
$ns at 495.0 "$node_(110) on" 
$node_(111) set X_ 1727 
$node_(111) set Y_ 813 
$node_(111) set Z_ 0.0 
$ns at 0.0 "$node_(111) off" 
$ns at 495.0 "$node_(111) on" 
$node_(112) set X_ 763 
$node_(112) set Y_ 780 
$node_(112) set Z_ 0.0 
$ns at 0.0 "$node_(112) off" 
$ns at 495.0 "$node_(112) on" 
$node_(113) set X_ 783 
$node_(113) set Y_ 954 
$node_(113) set Z_ 0.0 
$ns at 0.0 "$node_(113) off" 
$ns at 495.0 "$node_(113) on" 
$node_(114) set X_ 2209 
$node_(114) set Y_ 948 
$node_(114) set Z_ 0.0 
$ns at 0.0 "$node_(114) off" 
$ns at 495.0 "$node_(114) on" 
$node_(115) set X_ 673 
$node_(115) set Y_ 231 
$node_(115) set Z_ 0.0 
$ns at 0.0 "$node_(115) off" 
$ns at 495.0 "$node_(115) on" 
$node_(116) set X_ 1587 
$node_(116) set Y_ 161 
$node_(116) set Z_ 0.0 
$ns at 0.0 "$node_(116) off" 
$ns at 495.0 "$node_(116) on" 
$node_(117) set X_ 552 
$node_(117) set Y_ 642 
$node_(117) set Z_ 0.0 
$ns at 0.0 "$node_(117) off" 
$ns at 495.0 "$node_(117) on" 
$node_(118) set X_ 2854 
$node_(118) set Y_ 692 
$node_(118) set Z_ 0.0 
$ns at 0.0 "$node_(118) off" 
$ns at 495.0 "$node_(118) on" 
$node_(119) set X_ 1565 
$node_(119) set Y_ 184 
$node_(119) set Z_ 0.0 
$ns at 0.0 "$node_(119) off" 
$ns at 495.0 "$node_(119) on" 
$node_(120) set X_ 1247 
$node_(120) set Y_ 153 
$node_(120) set Z_ 0.0 
$ns at 0.0 "$node_(120) off" 
$ns at 495.0 "$node_(120) on" 
$node_(121) set X_ 1546 
$node_(121) set Y_ 593 
$node_(121) set Z_ 0.0 
$ns at 0.0 "$node_(121) off" 
$ns at 495.0 "$node_(121) on" 
$node_(122) set X_ 2991 
$node_(122) set Y_ 322 
$node_(122) set Z_ 0.0 
$ns at 0.0 "$node_(122) off" 
$ns at 495.0 "$node_(122) on" 
$node_(123) set X_ 335 
$node_(123) set Y_ 762 
$node_(123) set Z_ 0.0 
$ns at 0.0 "$node_(123) off" 
$ns at 495.0 "$node_(123) on" 
$node_(124) set X_ 30 
$node_(124) set Y_ 566 
$node_(124) set Z_ 0.0 
$ns at 0.0 "$node_(124) off" 
$ns at 495.0 "$node_(124) on" 
$node_(125) set X_ 2842 
$node_(125) set Y_ 729 
$node_(125) set Z_ 0.0 
$ns at 0.0 "$node_(125) off" 
$ns at 660.0 "$node_(125) on" 
$node_(126) set X_ 2603 
$node_(126) set Y_ 938 
$node_(126) set Z_ 0.0 
$ns at 0.0 "$node_(126) off" 
$ns at 660.0 "$node_(126) on" 
$node_(127) set X_ 2429 
$node_(127) set Y_ 396 
$node_(127) set Z_ 0.0 
$ns at 0.0 "$node_(127) off" 
$ns at 660.0 "$node_(127) on" 
$node_(128) set X_ 904 
$node_(128) set Y_ 689 
$node_(128) set Z_ 0.0 
$ns at 0.0 "$node_(128) off" 
$ns at 660.0 "$node_(128) on" 
$node_(129) set X_ 306 
$node_(129) set Y_ 498 
$node_(129) set Z_ 0.0 
$ns at 0.0 "$node_(129) off" 
$ns at 660.0 "$node_(129) on" 
$node_(130) set X_ 668 
$node_(130) set Y_ 306 
$node_(130) set Z_ 0.0 
$ns at 0.0 "$node_(130) off" 
$ns at 660.0 "$node_(130) on" 
$node_(131) set X_ 494 
$node_(131) set Y_ 894 
$node_(131) set Z_ 0.0 
$ns at 0.0 "$node_(131) off" 
$ns at 660.0 "$node_(131) on" 
$node_(132) set X_ 388 
$node_(132) set Y_ 144 
$node_(132) set Z_ 0.0 
$ns at 0.0 "$node_(132) off" 
$ns at 660.0 "$node_(132) on" 
$node_(133) set X_ 1504 
$node_(133) set Y_ 971 
$node_(133) set Z_ 0.0 
$ns at 0.0 "$node_(133) off" 
$ns at 660.0 "$node_(133) on" 
$node_(134) set X_ 2902 
$node_(134) set Y_ 428 
$node_(134) set Z_ 0.0 
$ns at 0.0 "$node_(134) off" 
$ns at 660.0 "$node_(134) on" 
$node_(135) set X_ 150 
$node_(135) set Y_ 765 
$node_(135) set Z_ 0.0 
$ns at 0.0 "$node_(135) off" 
$ns at 660.0 "$node_(135) on" 
$node_(136) set X_ 2411 
$node_(136) set Y_ 652 
$node_(136) set Z_ 0.0 
$ns at 0.0 "$node_(136) off" 
$ns at 660.0 "$node_(136) on" 
$node_(137) set X_ 1954 
$node_(137) set Y_ 466 
$node_(137) set Z_ 0.0 
$ns at 0.0 "$node_(137) off" 
$ns at 660.0 "$node_(137) on" 
$node_(138) set X_ 1445 
$node_(138) set Y_ 415 
$node_(138) set Z_ 0.0 
$ns at 0.0 "$node_(138) off" 
$ns at 660.0 "$node_(138) on" 
$node_(139) set X_ 2313 
$node_(139) set Y_ 104 
$node_(139) set Z_ 0.0 
$ns at 0.0 "$node_(139) off" 
$ns at 660.0 "$node_(139) on" 
$node_(140) set X_ 2038 
$node_(140) set Y_ 322 
$node_(140) set Z_ 0.0 
$ns at 0.0 "$node_(140) off" 
$ns at 660.0 "$node_(140) on" 
$node_(141) set X_ 1069 
$node_(141) set Y_ 565 
$node_(141) set Z_ 0.0 
$ns at 0.0 "$node_(141) off" 
$ns at 660.0 "$node_(141) on" 
$node_(142) set X_ 1300 
$node_(142) set Y_ 883 
$node_(142) set Z_ 0.0 
$ns at 0.0 "$node_(142) off" 
$ns at 660.0 "$node_(142) on" 
$node_(143) set X_ 1281 
$node_(143) set Y_ 546 
$node_(143) set Z_ 0.0 
$ns at 0.0 "$node_(143) off" 
$ns at 660.0 "$node_(143) on" 
$node_(144) set X_ 735 
$node_(144) set Y_ 261 
$node_(144) set Z_ 0.0 
$ns at 0.0 "$node_(144) off" 
$ns at 660.0 "$node_(144) on" 
$node_(145) set X_ 1885 
$node_(145) set Y_ 705 
$node_(145) set Z_ 0.0 
$ns at 0.0 "$node_(145) off" 
$ns at 660.0 "$node_(145) on" 
$node_(146) set X_ 1018 
$node_(146) set Y_ 312 
$node_(146) set Z_ 0.0 
$ns at 0.0 "$node_(146) off" 
$ns at 660.0 "$node_(146) on" 
$node_(147) set X_ 1559 
$node_(147) set Y_ 73 
$node_(147) set Z_ 0.0 
$ns at 0.0 "$node_(147) off" 
$ns at 660.0 "$node_(147) on" 
$node_(148) set X_ 1556 
$node_(148) set Y_ 617 
$node_(148) set Z_ 0.0 
$ns at 0.0 "$node_(148) off" 
$ns at 660.0 "$node_(148) on" 
$node_(149) set X_ 2401 
$node_(149) set Y_ 701 
$node_(149) set Z_ 0.0 
$ns at 0.0 "$node_(149) off" 
$ns at 660.0 "$node_(149) on" 

# Generation of movements
$ns at 0.0 "$node_(0) setdest 934 98 1.0" 
$ns at 36.78324115289993 "$node_(0) setdest 2429 372 14.0" 
$ns at 188.61450656163254 "$node_(0) setdest 1966 230 10.0" 
$ns at 235.8745791368333 "$node_(0) setdest 414 464 1.0" 
$ns at 272.3593547954414 "$node_(0) setdest 757 826 16.0" 
$ns at 404.5265410704921 "$node_(0) setdest 2614 84 7.0" 
$ns at 492.6466310614694 "$node_(0) setdest 2695 955 11.0" 
$ns at 557.0165089320033 "$node_(0) setdest 1118 220 19.0" 
$ns at 747.0123475325695 "$node_(0) setdest 78 477 11.0" 
$ns at 876.8626818632774 "$node_(0) setdest 2145 773 3.0" 
$ns at 0.0 "$node_(1) setdest 1454 851 11.0" 
$ns at 101.64456797476093 "$node_(1) setdest 2279 852 9.0" 
$ns at 171.74072087944012 "$node_(1) setdest 918 105 8.0" 
$ns at 245.9283209264155 "$node_(1) setdest 459 47 4.0" 
$ns at 296.4624924968664 "$node_(1) setdest 1892 446 19.0" 
$ns at 454.25641625956996 "$node_(1) setdest 112 794 13.0" 
$ns at 602.4725429960122 "$node_(1) setdest 660 202 15.0" 
$ns at 695.2070307474122 "$node_(1) setdest 1603 134 9.0" 
$ns at 757.5728062601811 "$node_(1) setdest 689 58 5.0" 
$ns at 793.6894448066628 "$node_(1) setdest 874 478 18.0" 
$ns at 826.4698757018268 "$node_(1) setdest 519 795 3.0" 
$ns at 869.6063886053157 "$node_(1) setdest 1956 186 1.0" 
$ns at 0.0 "$node_(2) setdest 737 981 12.0" 
$ns at 67.2679305647217 "$node_(2) setdest 734 50 4.0" 
$ns at 133.65761783052463 "$node_(2) setdest 1320 337 19.0" 
$ns at 268.35250818249995 "$node_(2) setdest 124 21 8.0" 
$ns at 355.58753848666095 "$node_(2) setdest 380 713 10.0" 
$ns at 413.19595270534205 "$node_(2) setdest 575 749 11.0" 
$ns at 511.7764276125488 "$node_(2) setdest 74 904 2.0" 
$ns at 556.5452189508542 "$node_(2) setdest 524 780 12.0" 
$ns at 631.6318114115827 "$node_(2) setdest 2219 742 10.0" 
$ns at 693.0706686907967 "$node_(2) setdest 234 477 18.0" 
$ns at 827.9223757527396 "$node_(2) setdest 880 191 2.0" 
$ns at 871.3043499402869 "$node_(2) setdest 148 16 7.0" 
$ns at 0.0 "$node_(3) setdest 969 382 5.0" 
$ns at 48.448189620775565 "$node_(3) setdest 669 26 18.0" 
$ns at 187.38640873924308 "$node_(3) setdest 2618 811 11.0" 
$ns at 268.04942106577346 "$node_(3) setdest 2017 706 9.0" 
$ns at 354.21200282086977 "$node_(3) setdest 2873 152 3.0" 
$ns at 407.78672777700694 "$node_(3) setdest 567 502 4.0" 
$ns at 473.31808298115806 "$node_(3) setdest 962 388 1.0" 
$ns at 503.84523950826207 "$node_(3) setdest 2813 688 7.0" 
$ns at 546.7946082284968 "$node_(3) setdest 186 220 12.0" 
$ns at 688.5557042204211 "$node_(3) setdest 877 407 16.0" 
$ns at 795.5337115675288 "$node_(3) setdest 198 962 2.0" 
$ns at 839.4263872672504 "$node_(3) setdest 1194 31 12.0" 
$ns at 890.0802821950091 "$node_(3) setdest 1203 380 19.0" 
$ns at 0.0 "$node_(4) setdest 788 905 12.0" 
$ns at 119.79761217364693 "$node_(4) setdest 350 181 14.0" 
$ns at 156.0888096429092 "$node_(4) setdest 1296 817 13.0" 
$ns at 254.14659095241188 "$node_(4) setdest 355 99 16.0" 
$ns at 400.23845670239194 "$node_(4) setdest 1626 766 2.0" 
$ns at 436.6497507212278 "$node_(4) setdest 115 809 2.0" 
$ns at 474.3551562880139 "$node_(4) setdest 919 866 17.0" 
$ns at 548.2428081973169 "$node_(4) setdest 861 98 3.0" 
$ns at 603.8993316383014 "$node_(4) setdest 2200 476 9.0" 
$ns at 636.934568179702 "$node_(4) setdest 2108 21 17.0" 
$ns at 742.9458635422862 "$node_(4) setdest 1892 868 7.0" 
$ns at 797.2070884819669 "$node_(4) setdest 1441 991 15.0" 
$ns at 0.0 "$node_(5) setdest 2070 36 14.0" 
$ns at 79.87241551218645 "$node_(5) setdest 913 6 8.0" 
$ns at 138.02726455072354 "$node_(5) setdest 2128 460 18.0" 
$ns at 225.62430953040973 "$node_(5) setdest 2580 480 12.0" 
$ns at 372.3083511189668 "$node_(5) setdest 2253 926 3.0" 
$ns at 426.4517920517695 "$node_(5) setdest 446 373 13.0" 
$ns at 477.8304904724763 "$node_(5) setdest 855 713 13.0" 
$ns at 523.1034561901806 "$node_(5) setdest 861 591 8.0" 
$ns at 610.4614812297251 "$node_(5) setdest 1863 749 16.0" 
$ns at 776.1880740531367 "$node_(5) setdest 2124 849 7.0" 
$ns at 845.3458212424434 "$node_(5) setdest 536 553 2.0" 
$ns at 888.7815265049331 "$node_(5) setdest 2848 466 4.0" 
$ns at 0.0 "$node_(6) setdest 1186 53 10.0" 
$ns at 110.01405286472924 "$node_(6) setdest 1339 787 3.0" 
$ns at 143.05618967551334 "$node_(6) setdest 976 607 13.0" 
$ns at 268.3487478442603 "$node_(6) setdest 33 205 19.0" 
$ns at 435.30814387181147 "$node_(6) setdest 684 821 12.0" 
$ns at 489.1515572735872 "$node_(6) setdest 2754 969 17.0" 
$ns at 627.6524000408517 "$node_(6) setdest 2098 972 5.0" 
$ns at 679.1986271835732 "$node_(6) setdest 2339 259 8.0" 
$ns at 760.2534550453909 "$node_(6) setdest 433 148 10.0" 
$ns at 807.8646573903407 "$node_(6) setdest 1888 211 2.0" 
$ns at 844.0106163788022 "$node_(6) setdest 1924 411 5.0" 
$ns at 877.7749184486471 "$node_(6) setdest 2682 873 15.0" 
$ns at 0.0 "$node_(7) setdest 1505 584 16.0" 
$ns at 80.46810926683234 "$node_(7) setdest 529 273 1.0" 
$ns at 117.02194672998587 "$node_(7) setdest 218 478 16.0" 
$ns at 258.16854970154367 "$node_(7) setdest 92 83 17.0" 
$ns at 335.6981246100452 "$node_(7) setdest 1764 658 4.0" 
$ns at 385.53474241501124 "$node_(7) setdest 441 561 19.0" 
$ns at 486.1725914744011 "$node_(7) setdest 329 64 10.0" 
$ns at 597.5137348782471 "$node_(7) setdest 1892 755 17.0" 
$ns at 679.3168616389511 "$node_(7) setdest 2617 78 2.0" 
$ns at 713.8519453886088 "$node_(7) setdest 886 140 12.0" 
$ns at 760.0015564558311 "$node_(7) setdest 1709 870 20.0" 
$ns at 0.0 "$node_(8) setdest 438 187 10.0" 
$ns at 125.77564355920727 "$node_(8) setdest 1182 100 18.0" 
$ns at 330.18452520442867 "$node_(8) setdest 1455 538 7.0" 
$ns at 365.10777715799804 "$node_(8) setdest 2616 308 2.0" 
$ns at 404.21414969178323 "$node_(8) setdest 913 754 8.0" 
$ns at 450.1781677555047 "$node_(8) setdest 2402 583 19.0" 
$ns at 659.8228916444563 "$node_(8) setdest 2708 859 4.0" 
$ns at 702.8999744995793 "$node_(8) setdest 2504 328 16.0" 
$ns at 866.5164905104903 "$node_(8) setdest 2682 103 19.0" 
$ns at 0.0 "$node_(9) setdest 1578 215 8.0" 
$ns at 105.19945981531788 "$node_(9) setdest 117 692 14.0" 
$ns at 171.57082026473128 "$node_(9) setdest 2590 663 20.0" 
$ns at 331.4673846691761 "$node_(9) setdest 1710 404 18.0" 
$ns at 385.02801631598885 "$node_(9) setdest 1853 409 11.0" 
$ns at 479.18894574477775 "$node_(9) setdest 2824 324 8.0" 
$ns at 567.6989261394482 "$node_(9) setdest 114 15 8.0" 
$ns at 669.4339992246399 "$node_(9) setdest 528 147 14.0" 
$ns at 732.2557194734266 "$node_(9) setdest 2118 387 18.0" 
$ns at 875.3995586431113 "$node_(9) setdest 706 748 14.0" 
$ns at 0.0 "$node_(10) setdest 1773 648 8.0" 
$ns at 88.9351700729587 "$node_(10) setdest 269 993 1.0" 
$ns at 120.98768551683 "$node_(10) setdest 1851 928 5.0" 
$ns at 186.72702416423115 "$node_(10) setdest 1244 978 20.0" 
$ns at 389.77369172093 "$node_(10) setdest 843 925 13.0" 
$ns at 541.4759910241875 "$node_(10) setdest 258 173 4.0" 
$ns at 605.3943092121536 "$node_(10) setdest 398 300 18.0" 
$ns at 656.6570981302712 "$node_(10) setdest 2710 163 17.0" 
$ns at 698.3157805782205 "$node_(10) setdest 486 255 1.0" 
$ns at 733.8337079693237 "$node_(10) setdest 654 944 3.0" 
$ns at 782.8291622881037 "$node_(10) setdest 1182 862 4.0" 
$ns at 852.5099675319461 "$node_(10) setdest 1153 999 1.0" 
$ns at 885.3567778970355 "$node_(10) setdest 739 980 2.0" 
$ns at 0.0 "$node_(11) setdest 663 585 14.0" 
$ns at 162.19747338730568 "$node_(11) setdest 1341 848 4.0" 
$ns at 216.0086330919808 "$node_(11) setdest 2696 950 8.0" 
$ns at 275.4394763299791 "$node_(11) setdest 1686 675 16.0" 
$ns at 381.5149717478973 "$node_(11) setdest 2803 451 18.0" 
$ns at 445.2287464299509 "$node_(11) setdest 1313 820 15.0" 
$ns at 476.5133395160745 "$node_(11) setdest 650 752 10.0" 
$ns at 592.0405118008516 "$node_(11) setdest 313 383 19.0" 
$ns at 780.1156490226828 "$node_(11) setdest 723 582 11.0" 
$ns at 839.1990001948399 "$node_(11) setdest 2839 300 8.0" 
$ns at 0.0 "$node_(12) setdest 2921 744 4.0" 
$ns at 32.36328199675949 "$node_(12) setdest 551 269 2.0" 
$ns at 77.0830903935375 "$node_(12) setdest 90 350 5.0" 
$ns at 152.59743829849043 "$node_(12) setdest 2914 81 18.0" 
$ns at 257.0880377339466 "$node_(12) setdest 242 472 16.0" 
$ns at 330.67890708078914 "$node_(12) setdest 1995 209 11.0" 
$ns at 391.7825650016921 "$node_(12) setdest 2029 671 13.0" 
$ns at 472.7665307579076 "$node_(12) setdest 158 708 12.0" 
$ns at 618.0240862905159 "$node_(12) setdest 2701 117 8.0" 
$ns at 695.0932651955751 "$node_(12) setdest 1814 792 5.0" 
$ns at 773.1409392753782 "$node_(12) setdest 1622 255 7.0" 
$ns at 808.2444997079587 "$node_(12) setdest 131 636 8.0" 
$ns at 860.4325194492534 "$node_(12) setdest 2084 210 16.0" 
$ns at 0.0 "$node_(13) setdest 2342 261 17.0" 
$ns at 30.661797198762457 "$node_(13) setdest 2969 417 7.0" 
$ns at 84.27394539264688 "$node_(13) setdest 77 569 8.0" 
$ns at 145.56324728353195 "$node_(13) setdest 2526 151 8.0" 
$ns at 184.06913850713414 "$node_(13) setdest 1849 869 8.0" 
$ns at 292.39437523991836 "$node_(13) setdest 1299 935 4.0" 
$ns at 337.67470418695746 "$node_(13) setdest 2605 468 7.0" 
$ns at 416.8824631320639 "$node_(13) setdest 969 29 17.0" 
$ns at 523.5085461121287 "$node_(13) setdest 2 167 7.0" 
$ns at 561.6222410817355 "$node_(13) setdest 2653 453 8.0" 
$ns at 621.0867908146487 "$node_(13) setdest 2795 738 16.0" 
$ns at 670.7744633328385 "$node_(13) setdest 2928 248 10.0" 
$ns at 712.119648938731 "$node_(13) setdest 1504 716 3.0" 
$ns at 768.2762889428653 "$node_(13) setdest 1612 946 1.0" 
$ns at 802.6615534561282 "$node_(13) setdest 1250 91 18.0" 
$ns at 0.0 "$node_(14) setdest 71 442 15.0" 
$ns at 170.50986191945822 "$node_(14) setdest 1421 725 5.0" 
$ns at 212.35166026183953 "$node_(14) setdest 2593 727 3.0" 
$ns at 245.21722472106458 "$node_(14) setdest 2570 584 19.0" 
$ns at 312.79417001558545 "$node_(14) setdest 1096 203 4.0" 
$ns at 357.0203074119103 "$node_(14) setdest 1688 114 7.0" 
$ns at 406.31215170764017 "$node_(14) setdest 2199 509 10.0" 
$ns at 480.86234833180026 "$node_(14) setdest 769 335 10.0" 
$ns at 537.1896321392514 "$node_(14) setdest 434 103 13.0" 
$ns at 633.4955743265726 "$node_(14) setdest 305 504 13.0" 
$ns at 716.6576916348425 "$node_(14) setdest 130 15 3.0" 
$ns at 770.7827800346024 "$node_(14) setdest 1121 409 11.0" 
$ns at 849.791870502778 "$node_(14) setdest 242 518 1.0" 
$ns at 889.489382086984 "$node_(14) setdest 2706 634 18.0" 
$ns at 0.0 "$node_(15) setdest 1150 642 9.0" 
$ns at 44.94739432307871 "$node_(15) setdest 1934 385 18.0" 
$ns at 219.98485172340685 "$node_(15) setdest 217 755 17.0" 
$ns at 347.4210537306777 "$node_(15) setdest 2828 696 8.0" 
$ns at 399.4602736375463 "$node_(15) setdest 615 671 17.0" 
$ns at 435.8078538266959 "$node_(15) setdest 774 101 18.0" 
$ns at 551.2336367413471 "$node_(15) setdest 1716 974 18.0" 
$ns at 739.452618867075 "$node_(15) setdest 1343 109 3.0" 
$ns at 784.2728461092986 "$node_(15) setdest 59 535 14.0" 
$ns at 832.6871138076174 "$node_(15) setdest 2602 64 1.0" 
$ns at 869.7319302030824 "$node_(15) setdest 681 418 6.0" 
$ns at 0.0 "$node_(16) setdest 2593 208 13.0" 
$ns at 95.97736876978414 "$node_(16) setdest 337 632 12.0" 
$ns at 177.45442407793496 "$node_(16) setdest 1361 50 2.0" 
$ns at 225.66311769956084 "$node_(16) setdest 877 441 1.0" 
$ns at 260.0487841606424 "$node_(16) setdest 697 360 4.0" 
$ns at 312.84703959671117 "$node_(16) setdest 828 188 6.0" 
$ns at 348.80109070862 "$node_(16) setdest 2489 369 9.0" 
$ns at 396.7033536707803 "$node_(16) setdest 934 834 11.0" 
$ns at 433.7220857361828 "$node_(16) setdest 1343 14 6.0" 
$ns at 492.5563047353428 "$node_(16) setdest 199 677 1.0" 
$ns at 530.4253741242791 "$node_(16) setdest 866 310 7.0" 
$ns at 622.3828846917577 "$node_(16) setdest 1703 954 17.0" 
$ns at 708.6688559175744 "$node_(16) setdest 2769 167 18.0" 
$ns at 744.5738442456699 "$node_(16) setdest 221 284 15.0" 
$ns at 888.6806584497124 "$node_(16) setdest 2696 260 13.0" 
$ns at 0.0 "$node_(17) setdest 2417 156 20.0" 
$ns at 158.59588441163197 "$node_(17) setdest 420 757 19.0" 
$ns at 226.8749415441711 "$node_(17) setdest 2151 926 9.0" 
$ns at 295.2010571069505 "$node_(17) setdest 2822 4 14.0" 
$ns at 433.8987106724197 "$node_(17) setdest 2162 22 13.0" 
$ns at 556.4784763854879 "$node_(17) setdest 1794 492 10.0" 
$ns at 643.2958638524852 "$node_(17) setdest 168 320 17.0" 
$ns at 792.2316911387636 "$node_(17) setdest 2976 693 6.0" 
$ns at 831.0288886369747 "$node_(17) setdest 2153 893 8.0" 
$ns at 885.5265056132382 "$node_(17) setdest 1972 591 19.0" 
$ns at 0.0 "$node_(18) setdest 367 600 13.0" 
$ns at 127.55171383357275 "$node_(18) setdest 459 994 1.0" 
$ns at 159.52360811644095 "$node_(18) setdest 1325 202 16.0" 
$ns at 286.44753938901295 "$node_(18) setdest 2327 958 4.0" 
$ns at 335.5212348299343 "$node_(18) setdest 818 989 8.0" 
$ns at 413.50291355093725 "$node_(18) setdest 2761 910 14.0" 
$ns at 532.4575626569834 "$node_(18) setdest 1729 104 9.0" 
$ns at 623.2734402979453 "$node_(18) setdest 1919 284 18.0" 
$ns at 721.8563047587145 "$node_(18) setdest 173 22 19.0" 
$ns at 768.5896480411028 "$node_(18) setdest 604 783 1.0" 
$ns at 800.9353888541953 "$node_(18) setdest 1235 913 17.0" 
$ns at 0.0 "$node_(19) setdest 2078 567 8.0" 
$ns at 88.12092641411151 "$node_(19) setdest 343 812 10.0" 
$ns at 188.43273879221633 "$node_(19) setdest 2932 969 12.0" 
$ns at 250.75887848888706 "$node_(19) setdest 2046 835 16.0" 
$ns at 349.4288279648549 "$node_(19) setdest 1659 566 18.0" 
$ns at 532.5197758248939 "$node_(19) setdest 1725 876 6.0" 
$ns at 608.8565190327727 "$node_(19) setdest 324 684 16.0" 
$ns at 789.1365721419176 "$node_(19) setdest 521 503 5.0" 
$ns at 843.7457345815578 "$node_(19) setdest 2497 674 10.0" 
$ns at 899.1016868944612 "$node_(19) setdest 1493 9 14.0" 
$ns at 0.0 "$node_(20) setdest 2343 536 6.0" 
$ns at 46.80953359065762 "$node_(20) setdest 1804 816 5.0" 
$ns at 117.82131466190991 "$node_(20) setdest 2528 725 1.0" 
$ns at 154.75169146608587 "$node_(20) setdest 2441 707 1.0" 
$ns at 189.50526288718675 "$node_(20) setdest 326 225 9.0" 
$ns at 225.32925710965253 "$node_(20) setdest 764 571 6.0" 
$ns at 311.4230113456406 "$node_(20) setdest 2109 216 1.0" 
$ns at 346.5710074809801 "$node_(20) setdest 896 640 20.0" 
$ns at 531.7855895833886 "$node_(20) setdest 1092 920 19.0" 
$ns at 597.9724797560043 "$node_(20) setdest 2745 404 4.0" 
$ns at 645.9329670974394 "$node_(20) setdest 1010 462 14.0" 
$ns at 777.1779453355527 "$node_(20) setdest 176 680 10.0" 
$ns at 886.3341365962401 "$node_(20) setdest 1104 815 18.0" 
$ns at 0.0 "$node_(21) setdest 1616 527 20.0" 
$ns at 96.2083361609819 "$node_(21) setdest 2598 178 12.0" 
$ns at 160.91694875534762 "$node_(21) setdest 116 976 5.0" 
$ns at 223.03931846282742 "$node_(21) setdest 1544 356 19.0" 
$ns at 334.44835917321154 "$node_(21) setdest 645 769 7.0" 
$ns at 384.2334942563012 "$node_(21) setdest 2700 981 12.0" 
$ns at 437.9112640374807 "$node_(21) setdest 152 582 20.0" 
$ns at 481.927906603979 "$node_(21) setdest 2838 651 8.0" 
$ns at 535.2516159316414 "$node_(21) setdest 2664 415 8.0" 
$ns at 623.6164426229022 "$node_(21) setdest 646 323 12.0" 
$ns at 741.1964641382646 "$node_(21) setdest 2456 134 18.0" 
$ns at 802.0790191221549 "$node_(21) setdest 1104 544 20.0" 
$ns at 870.4959476571224 "$node_(21) setdest 1057 346 12.0" 
$ns at 0.0 "$node_(22) setdest 1009 345 1.0" 
$ns at 34.90413875298255 "$node_(22) setdest 1639 80 4.0" 
$ns at 84.82618079018567 "$node_(22) setdest 39 881 10.0" 
$ns at 171.5530785894819 "$node_(22) setdest 46 980 6.0" 
$ns at 241.80685875330693 "$node_(22) setdest 1511 162 16.0" 
$ns at 378.2470321262955 "$node_(22) setdest 1507 956 15.0" 
$ns at 410.69099916705846 "$node_(22) setdest 738 435 17.0" 
$ns at 536.4278346317863 "$node_(22) setdest 2796 517 7.0" 
$ns at 576.297917576877 "$node_(22) setdest 1628 70 17.0" 
$ns at 610.1706304712988 "$node_(22) setdest 380 222 13.0" 
$ns at 696.5312924663103 "$node_(22) setdest 946 18 1.0" 
$ns at 734.9411699702281 "$node_(22) setdest 1818 981 2.0" 
$ns at 771.5913015651829 "$node_(22) setdest 368 180 11.0" 
$ns at 818.2699477601105 "$node_(22) setdest 460 137 2.0" 
$ns at 855.9833976243634 "$node_(22) setdest 2247 265 17.0" 
$ns at 0.0 "$node_(23) setdest 188 562 17.0" 
$ns at 135.31768605030317 "$node_(23) setdest 2737 977 9.0" 
$ns at 204.6310733112183 "$node_(23) setdest 771 196 6.0" 
$ns at 293.94675029756 "$node_(23) setdest 2678 595 1.0" 
$ns at 326.1377970948449 "$node_(23) setdest 2071 764 12.0" 
$ns at 467.0619931333014 "$node_(23) setdest 391 307 13.0" 
$ns at 532.7222503545086 "$node_(23) setdest 2150 607 6.0" 
$ns at 577.9006080741452 "$node_(23) setdest 289 845 6.0" 
$ns at 626.5267905881237 "$node_(23) setdest 1055 847 1.0" 
$ns at 656.5416274071983 "$node_(23) setdest 2963 287 8.0" 
$ns at 688.4433717389524 "$node_(23) setdest 1793 331 18.0" 
$ns at 873.6396972163625 "$node_(23) setdest 126 82 10.0" 
$ns at 0.0 "$node_(24) setdest 794 76 14.0" 
$ns at 76.82816011724384 "$node_(24) setdest 1588 643 4.0" 
$ns at 114.81405637570916 "$node_(24) setdest 2869 159 2.0" 
$ns at 161.08757407833622 "$node_(24) setdest 2153 91 9.0" 
$ns at 262.94993487699327 "$node_(24) setdest 458 266 4.0" 
$ns at 298.8145208286699 "$node_(24) setdest 1093 973 12.0" 
$ns at 376.8762663158386 "$node_(24) setdest 1685 354 18.0" 
$ns at 483.07641847666474 "$node_(24) setdest 1605 41 10.0" 
$ns at 527.5939284784051 "$node_(24) setdest 495 133 14.0" 
$ns at 561.0104152772811 "$node_(24) setdest 2389 433 2.0" 
$ns at 600.5447506655793 "$node_(24) setdest 1913 331 17.0" 
$ns at 663.4380407168363 "$node_(24) setdest 277 818 4.0" 
$ns at 697.2834675043565 "$node_(24) setdest 193 937 12.0" 
$ns at 805.842469328481 "$node_(24) setdest 2532 357 14.0" 
$ns at 896.9213006033804 "$node_(24) setdest 376 896 4.0" 
$ns at 0.0 "$node_(25) setdest 246 545 4.0" 
$ns at 32.18960434332684 "$node_(25) setdest 563 938 3.0" 
$ns at 67.43069850661382 "$node_(25) setdest 1976 289 1.0" 
$ns at 103.32164906892734 "$node_(25) setdest 2890 533 9.0" 
$ns at 169.8936625983867 "$node_(25) setdest 2524 770 18.0" 
$ns at 230.30551292588729 "$node_(25) setdest 2022 141 11.0" 
$ns at 330.2558397578517 "$node_(25) setdest 2511 958 13.0" 
$ns at 416.0805267923411 "$node_(25) setdest 2665 243 15.0" 
$ns at 548.373743989858 "$node_(25) setdest 150 833 3.0" 
$ns at 593.9870013076888 "$node_(25) setdest 1387 849 3.0" 
$ns at 626.4026733699791 "$node_(25) setdest 373 663 19.0" 
$ns at 800.159571548551 "$node_(25) setdest 770 431 14.0" 
$ns at 0.0 "$node_(26) setdest 206 908 8.0" 
$ns at 94.15669946026574 "$node_(26) setdest 1676 514 7.0" 
$ns at 175.37769533066918 "$node_(26) setdest 53 593 11.0" 
$ns at 264.1385318365065 "$node_(26) setdest 1146 347 15.0" 
$ns at 401.28484104963115 "$node_(26) setdest 1281 221 8.0" 
$ns at 509.92779591983304 "$node_(26) setdest 220 392 8.0" 
$ns at 603.6923635675416 "$node_(26) setdest 2276 571 3.0" 
$ns at 663.3060778142451 "$node_(26) setdest 2691 574 3.0" 
$ns at 703.0926362699544 "$node_(26) setdest 2852 946 2.0" 
$ns at 742.3715170290578 "$node_(26) setdest 1586 493 1.0" 
$ns at 776.2217537956309 "$node_(26) setdest 676 723 15.0" 
$ns at 871.8423998088338 "$node_(26) setdest 1890 73 13.0" 
$ns at 0.0 "$node_(27) setdest 115 269 14.0" 
$ns at 60.50962281546578 "$node_(27) setdest 2798 336 18.0" 
$ns at 96.822281341806 "$node_(27) setdest 643 570 7.0" 
$ns at 153.29896939328347 "$node_(27) setdest 1514 272 14.0" 
$ns at 270.7057005938218 "$node_(27) setdest 1733 139 19.0" 
$ns at 380.8344350369286 "$node_(27) setdest 381 4 16.0" 
$ns at 468.55997853475685 "$node_(27) setdest 1860 53 5.0" 
$ns at 512.8376204917436 "$node_(27) setdest 2872 710 1.0" 
$ns at 545.9653895525983 "$node_(27) setdest 36 185 11.0" 
$ns at 584.1506648510435 "$node_(27) setdest 2703 3 16.0" 
$ns at 663.1746781372153 "$node_(27) setdest 25 976 11.0" 
$ns at 766.7763191160344 "$node_(27) setdest 1123 731 1.0" 
$ns at 802.8138422081483 "$node_(27) setdest 135 316 16.0" 
$ns at 849.5206845754092 "$node_(27) setdest 1128 410 5.0" 
$ns at 0.0 "$node_(28) setdest 250 380 6.0" 
$ns at 81.6528310247732 "$node_(28) setdest 149 726 18.0" 
$ns at 242.11621304107442 "$node_(28) setdest 1487 491 14.0" 
$ns at 337.2101724418483 "$node_(28) setdest 481 840 9.0" 
$ns at 395.96222078322035 "$node_(28) setdest 1652 341 4.0" 
$ns at 427.64861137669607 "$node_(28) setdest 482 430 16.0" 
$ns at 592.0003166243506 "$node_(28) setdest 2380 168 16.0" 
$ns at 736.8237090842053 "$node_(28) setdest 2319 696 5.0" 
$ns at 807.9764317403117 "$node_(28) setdest 2620 694 5.0" 
$ns at 838.417198058213 "$node_(28) setdest 792 768 4.0" 
$ns at 893.9764778051706 "$node_(28) setdest 1863 931 14.0" 
$ns at 0.0 "$node_(29) setdest 2508 234 13.0" 
$ns at 111.22180881802433 "$node_(29) setdest 1270 179 14.0" 
$ns at 165.704809023982 "$node_(29) setdest 2436 750 7.0" 
$ns at 251.26208558500795 "$node_(29) setdest 599 785 7.0" 
$ns at 288.8116976119311 "$node_(29) setdest 1617 918 15.0" 
$ns at 413.9811695460751 "$node_(29) setdest 1583 521 12.0" 
$ns at 481.7082293381008 "$node_(29) setdest 561 920 13.0" 
$ns at 612.1143981660473 "$node_(29) setdest 2161 636 1.0" 
$ns at 647.1086360188613 "$node_(29) setdest 2607 582 6.0" 
$ns at 707.7361013507355 "$node_(29) setdest 2723 932 7.0" 
$ns at 775.6441263392219 "$node_(29) setdest 2268 854 10.0" 
$ns at 857.7917200617337 "$node_(29) setdest 1255 440 1.0" 
$ns at 896.556965408807 "$node_(29) setdest 345 892 3.0" 
$ns at 0.0 "$node_(30) setdest 48 530 9.0" 
$ns at 32.616967728955714 "$node_(30) setdest 1336 209 11.0" 
$ns at 118.60475265822474 "$node_(30) setdest 2378 531 19.0" 
$ns at 279.20904691465955 "$node_(30) setdest 412 605 7.0" 
$ns at 319.54854466858535 "$node_(30) setdest 2291 201 19.0" 
$ns at 532.8975697324153 "$node_(30) setdest 1000 821 17.0" 
$ns at 670.1994269069371 "$node_(30) setdest 1414 625 19.0" 
$ns at 841.6483196180338 "$node_(30) setdest 2729 136 11.0" 
$ns at 0.0 "$node_(31) setdest 435 372 1.0" 
$ns at 32.47526653852653 "$node_(31) setdest 2294 358 7.0" 
$ns at 96.28313224559852 "$node_(31) setdest 656 998 7.0" 
$ns at 142.10485779946998 "$node_(31) setdest 2487 918 11.0" 
$ns at 280.60460593090085 "$node_(31) setdest 771 218 7.0" 
$ns at 339.8921147947064 "$node_(31) setdest 1447 20 1.0" 
$ns at 374.80412406385943 "$node_(31) setdest 1770 340 5.0" 
$ns at 413.1068517158044 "$node_(31) setdest 887 66 11.0" 
$ns at 451.39337495269 "$node_(31) setdest 630 788 12.0" 
$ns at 521.5144748369095 "$node_(31) setdest 840 792 16.0" 
$ns at 617.3536569983762 "$node_(31) setdest 2183 788 16.0" 
$ns at 796.5463497812968 "$node_(31) setdest 190 845 2.0" 
$ns at 834.5537986111999 "$node_(31) setdest 1315 566 15.0" 
$ns at 876.0997281986935 "$node_(31) setdest 2023 744 10.0" 
$ns at 0.0 "$node_(32) setdest 2415 627 20.0" 
$ns at 68.6970906518973 "$node_(32) setdest 2571 433 5.0" 
$ns at 128.12720844865484 "$node_(32) setdest 2698 949 10.0" 
$ns at 218.21045663061386 "$node_(32) setdest 284 890 2.0" 
$ns at 251.76629637359522 "$node_(32) setdest 1835 179 6.0" 
$ns at 334.1172903463622 "$node_(32) setdest 2290 490 1.0" 
$ns at 369.9505107946534 "$node_(32) setdest 2016 157 11.0" 
$ns at 468.12891109642976 "$node_(32) setdest 290 87 2.0" 
$ns at 512.8341691643786 "$node_(32) setdest 2361 356 1.0" 
$ns at 548.7446407396158 "$node_(32) setdest 2659 21 7.0" 
$ns at 585.7258261309138 "$node_(32) setdest 1341 63 14.0" 
$ns at 648.17317418928 "$node_(32) setdest 270 495 11.0" 
$ns at 696.2318593966007 "$node_(32) setdest 581 393 11.0" 
$ns at 737.2332340637009 "$node_(32) setdest 2332 50 3.0" 
$ns at 788.0511133678399 "$node_(32) setdest 1238 454 4.0" 
$ns at 849.3129538457039 "$node_(32) setdest 268 77 13.0" 
$ns at 883.1715341407419 "$node_(32) setdest 2818 261 12.0" 
$ns at 0.0 "$node_(33) setdest 394 584 14.0" 
$ns at 162.32757095153227 "$node_(33) setdest 109 216 1.0" 
$ns at 196.94893130209238 "$node_(33) setdest 2953 664 3.0" 
$ns at 251.99948307415013 "$node_(33) setdest 1624 250 3.0" 
$ns at 301.3784547501216 "$node_(33) setdest 758 386 19.0" 
$ns at 379.1746023855053 "$node_(33) setdest 708 944 13.0" 
$ns at 429.2219132441846 "$node_(33) setdest 2483 53 20.0" 
$ns at 471.45342798365243 "$node_(33) setdest 2208 229 9.0" 
$ns at 550.9250674929142 "$node_(33) setdest 2378 43 19.0" 
$ns at 721.264200021648 "$node_(33) setdest 1360 477 9.0" 
$ns at 751.6160335428433 "$node_(33) setdest 1933 676 15.0" 
$ns at 867.0884451954468 "$node_(33) setdest 1300 84 14.0" 
$ns at 0.0 "$node_(34) setdest 766 838 3.0" 
$ns at 53.45182965990257 "$node_(34) setdest 344 861 10.0" 
$ns at 107.3431434838354 "$node_(34) setdest 775 298 14.0" 
$ns at 259.103560972942 "$node_(34) setdest 943 830 19.0" 
$ns at 427.4393359478971 "$node_(34) setdest 2314 925 9.0" 
$ns at 515.156870894531 "$node_(34) setdest 2971 240 17.0" 
$ns at 668.0314320713271 "$node_(34) setdest 1927 285 5.0" 
$ns at 735.3383282134077 "$node_(34) setdest 1728 902 3.0" 
$ns at 777.008248650361 "$node_(34) setdest 1931 296 2.0" 
$ns at 821.2405427858289 "$node_(34) setdest 2843 164 2.0" 
$ns at 866.1932932198472 "$node_(34) setdest 849 914 2.0" 
$ns at 0.0 "$node_(35) setdest 948 112 3.0" 
$ns at 44.69315505243035 "$node_(35) setdest 490 59 10.0" 
$ns at 162.9614667243226 "$node_(35) setdest 1795 831 12.0" 
$ns at 260.7592901108774 "$node_(35) setdest 204 228 1.0" 
$ns at 291.4859224150615 "$node_(35) setdest 205 797 9.0" 
$ns at 405.86591418839663 "$node_(35) setdest 572 511 13.0" 
$ns at 502.8896293921874 "$node_(35) setdest 1018 753 4.0" 
$ns at 539.0891649251146 "$node_(35) setdest 578 957 4.0" 
$ns at 578.207162904607 "$node_(35) setdest 2930 628 15.0" 
$ns at 701.7072187087078 "$node_(35) setdest 31 513 16.0" 
$ns at 816.6480974170161 "$node_(35) setdest 873 347 2.0" 
$ns at 861.3267169847559 "$node_(35) setdest 1758 975 19.0" 
$ns at 0.0 "$node_(36) setdest 354 607 14.0" 
$ns at 63.04641687972543 "$node_(36) setdest 2863 668 7.0" 
$ns at 100.78900272462003 "$node_(36) setdest 1880 951 10.0" 
$ns at 180.78415394360448 "$node_(36) setdest 1062 815 7.0" 
$ns at 226.9861879136051 "$node_(36) setdest 1401 729 2.0" 
$ns at 268.28586119173457 "$node_(36) setdest 881 793 5.0" 
$ns at 323.9458868240997 "$node_(36) setdest 2396 765 10.0" 
$ns at 365.65581086456183 "$node_(36) setdest 2240 736 3.0" 
$ns at 408.0940959704637 "$node_(36) setdest 22 828 1.0" 
$ns at 445.9988102169632 "$node_(36) setdest 2704 201 11.0" 
$ns at 531.2129591461362 "$node_(36) setdest 474 222 15.0" 
$ns at 626.8606400425977 "$node_(36) setdest 424 836 11.0" 
$ns at 721.2913580647594 "$node_(36) setdest 1455 95 11.0" 
$ns at 780.2023360985839 "$node_(36) setdest 549 278 13.0" 
$ns at 0.0 "$node_(37) setdest 1409 281 1.0" 
$ns at 39.62714280836657 "$node_(37) setdest 1637 719 6.0" 
$ns at 129.62598620808308 "$node_(37) setdest 927 772 4.0" 
$ns at 170.41016898501545 "$node_(37) setdest 2336 862 4.0" 
$ns at 227.54947344504006 "$node_(37) setdest 2464 146 19.0" 
$ns at 360.35998876585046 "$node_(37) setdest 369 212 11.0" 
$ns at 467.6497534691864 "$node_(37) setdest 284 525 17.0" 
$ns at 547.1397490603933 "$node_(37) setdest 1599 921 2.0" 
$ns at 584.3070960182592 "$node_(37) setdest 1278 914 6.0" 
$ns at 662.6988331367704 "$node_(37) setdest 700 631 6.0" 
$ns at 710.1871248962099 "$node_(37) setdest 1056 984 2.0" 
$ns at 745.072017716081 "$node_(37) setdest 707 36 8.0" 
$ns at 835.7372980808018 "$node_(37) setdest 2467 643 17.0" 
$ns at 0.0 "$node_(38) setdest 1489 104 2.0" 
$ns at 40.848082181302495 "$node_(38) setdest 2455 971 5.0" 
$ns at 81.57382865847853 "$node_(38) setdest 1893 183 10.0" 
$ns at 117.20298865756922 "$node_(38) setdest 2894 354 13.0" 
$ns at 231.5182722289232 "$node_(38) setdest 1121 434 17.0" 
$ns at 329.24623205627773 "$node_(38) setdest 2810 896 19.0" 
$ns at 392.7766831191295 "$node_(38) setdest 588 311 17.0" 
$ns at 488.1000344484254 "$node_(38) setdest 2139 448 11.0" 
$ns at 593.7143751236842 "$node_(38) setdest 2310 25 19.0" 
$ns at 779.8347009556087 "$node_(38) setdest 2931 827 20.0" 
$ns at 850.3032140811819 "$node_(38) setdest 576 229 1.0" 
$ns at 885.7983039425064 "$node_(38) setdest 638 61 9.0" 
$ns at 0.0 "$node_(39) setdest 463 350 13.0" 
$ns at 31.200474004842793 "$node_(39) setdest 907 744 3.0" 
$ns at 80.96825143818802 "$node_(39) setdest 1439 291 17.0" 
$ns at 173.75321337562633 "$node_(39) setdest 2012 832 15.0" 
$ns at 305.99083899192465 "$node_(39) setdest 2102 470 17.0" 
$ns at 416.15046018615675 "$node_(39) setdest 842 460 7.0" 
$ns at 508.6496572234306 "$node_(39) setdest 1827 375 5.0" 
$ns at 544.5917265026475 "$node_(39) setdest 85 611 16.0" 
$ns at 648.1102829809732 "$node_(39) setdest 2842 114 10.0" 
$ns at 725.570631550989 "$node_(39) setdest 1022 725 20.0" 
$ns at 0.0 "$node_(40) setdest 2025 671 20.0" 
$ns at 148.45358518916282 "$node_(40) setdest 74 577 14.0" 
$ns at 192.13486270905764 "$node_(40) setdest 1431 795 6.0" 
$ns at 242.85815792899862 "$node_(40) setdest 2011 1 9.0" 
$ns at 318.5285586948374 "$node_(40) setdest 1340 770 5.0" 
$ns at 362.39545799637744 "$node_(40) setdest 471 297 2.0" 
$ns at 409.2086510078686 "$node_(40) setdest 349 486 16.0" 
$ns at 461.65692189964466 "$node_(40) setdest 191 411 1.0" 
$ns at 496.489422942047 "$node_(40) setdest 784 546 1.0" 
$ns at 527.9200947276872 "$node_(40) setdest 108 199 19.0" 
$ns at 629.1111789547897 "$node_(40) setdest 461 346 14.0" 
$ns at 683.9122080871485 "$node_(40) setdest 1224 376 12.0" 
$ns at 739.7139153882051 "$node_(40) setdest 575 347 4.0" 
$ns at 791.345241308595 "$node_(40) setdest 1898 978 15.0" 
$ns at 843.5742350753217 "$node_(40) setdest 235 994 9.0" 
$ns at 0.0 "$node_(41) setdest 956 409 4.0" 
$ns at 42.65651067657565 "$node_(41) setdest 2941 983 17.0" 
$ns at 194.79103885620253 "$node_(41) setdest 2774 423 13.0" 
$ns at 345.66449947348326 "$node_(41) setdest 1010 839 14.0" 
$ns at 486.14166847488417 "$node_(41) setdest 1251 601 20.0" 
$ns at 665.3613994412259 "$node_(41) setdest 739 14 18.0" 
$ns at 776.0381471368376 "$node_(41) setdest 1296 175 13.0" 
$ns at 819.6764309121804 "$node_(41) setdest 1834 952 18.0" 
$ns at 882.0306028364689 "$node_(41) setdest 2260 272 1.0" 
$ns at 0.0 "$node_(42) setdest 1376 840 19.0" 
$ns at 80.79569342465757 "$node_(42) setdest 449 906 4.0" 
$ns at 119.21787121359895 "$node_(42) setdest 351 995 19.0" 
$ns at 253.72763750726673 "$node_(42) setdest 2622 308 4.0" 
$ns at 294.01612354241536 "$node_(42) setdest 538 92 16.0" 
$ns at 457.1967691306934 "$node_(42) setdest 1130 424 13.0" 
$ns at 514.2962110406409 "$node_(42) setdest 1249 702 1.0" 
$ns at 551.4760567717528 "$node_(42) setdest 100 660 19.0" 
$ns at 743.1429539272905 "$node_(42) setdest 238 827 17.0" 
$ns at 0.0 "$node_(43) setdest 2806 209 15.0" 
$ns at 179.4656415984007 "$node_(43) setdest 770 410 15.0" 
$ns at 221.93461866311645 "$node_(43) setdest 148 536 12.0" 
$ns at 305.3436670764932 "$node_(43) setdest 658 14 6.0" 
$ns at 355.76433390417645 "$node_(43) setdest 866 869 16.0" 
$ns at 491.05567451986815 "$node_(43) setdest 2773 131 6.0" 
$ns at 533.149033433736 "$node_(43) setdest 917 752 17.0" 
$ns at 654.3858550491918 "$node_(43) setdest 314 831 1.0" 
$ns at 694.0449238702715 "$node_(43) setdest 151 23 6.0" 
$ns at 781.0829585945395 "$node_(43) setdest 1864 694 9.0" 
$ns at 831.2420473967962 "$node_(43) setdest 1191 769 5.0" 
$ns at 0.0 "$node_(44) setdest 15 259 19.0" 
$ns at 68.74164342060311 "$node_(44) setdest 1174 114 18.0" 
$ns at 194.38137217164538 "$node_(44) setdest 1073 417 18.0" 
$ns at 349.8783437645898 "$node_(44) setdest 2753 905 5.0" 
$ns at 388.5762272035108 "$node_(44) setdest 143 477 1.0" 
$ns at 424.4191635719396 "$node_(44) setdest 2511 642 19.0" 
$ns at 534.5623463937671 "$node_(44) setdest 2600 847 16.0" 
$ns at 601.1612638921022 "$node_(44) setdest 2691 218 18.0" 
$ns at 770.5774385032628 "$node_(44) setdest 1738 554 7.0" 
$ns at 818.7867545763626 "$node_(44) setdest 2893 324 8.0" 
$ns at 865.6607035957286 "$node_(44) setdest 115 38 1.0" 
$ns at 0.0 "$node_(45) setdest 1138 569 7.0" 
$ns at 30.90581728228228 "$node_(45) setdest 884 949 9.0" 
$ns at 74.82865054095662 "$node_(45) setdest 1464 685 5.0" 
$ns at 129.62113795838326 "$node_(45) setdest 1116 888 9.0" 
$ns at 180.49715788335504 "$node_(45) setdest 1936 360 5.0" 
$ns at 237.44442045250997 "$node_(45) setdest 1917 308 4.0" 
$ns at 276.32013016997746 "$node_(45) setdest 738 567 9.0" 
$ns at 311.84558313337686 "$node_(45) setdest 2848 25 6.0" 
$ns at 359.2934489609641 "$node_(45) setdest 1746 445 8.0" 
$ns at 456.31332421328506 "$node_(45) setdest 2930 58 2.0" 
$ns at 492.71204501390133 "$node_(45) setdest 1728 72 3.0" 
$ns at 531.6415328619513 "$node_(45) setdest 1276 738 17.0" 
$ns at 723.9357925890622 "$node_(45) setdest 2083 722 10.0" 
$ns at 774.3610043289393 "$node_(45) setdest 93 310 3.0" 
$ns at 810.3109468101534 "$node_(45) setdest 1764 420 9.0" 
$ns at 872.3423839777615 "$node_(45) setdest 1625 469 18.0" 
$ns at 0.0 "$node_(46) setdest 789 895 9.0" 
$ns at 93.50549335574803 "$node_(46) setdest 277 555 7.0" 
$ns at 130.37366694639692 "$node_(46) setdest 2494 246 15.0" 
$ns at 241.79948413296546 "$node_(46) setdest 1970 346 11.0" 
$ns at 344.6656953118022 "$node_(46) setdest 434 918 7.0" 
$ns at 418.9124435759477 "$node_(46) setdest 1494 668 10.0" 
$ns at 495.45202740187005 "$node_(46) setdest 2570 812 8.0" 
$ns at 561.6918851977947 "$node_(46) setdest 2389 274 15.0" 
$ns at 612.8631907341492 "$node_(46) setdest 2161 608 5.0" 
$ns at 689.671078016918 "$node_(46) setdest 2636 704 8.0" 
$ns at 741.9231761413056 "$node_(46) setdest 511 648 14.0" 
$ns at 819.4610045507997 "$node_(46) setdest 2174 72 8.0" 
$ns at 879.3184835086962 "$node_(46) setdest 1454 938 12.0" 
$ns at 0.0 "$node_(47) setdest 2032 3 19.0" 
$ns at 122.40424225621446 "$node_(47) setdest 262 124 17.0" 
$ns at 190.37369140293552 "$node_(47) setdest 1598 163 3.0" 
$ns at 231.35730445245912 "$node_(47) setdest 2344 507 7.0" 
$ns at 285.9008078257078 "$node_(47) setdest 1304 94 10.0" 
$ns at 322.42678152129946 "$node_(47) setdest 2922 439 12.0" 
$ns at 381.25115658357674 "$node_(47) setdest 748 316 8.0" 
$ns at 436.4979483024134 "$node_(47) setdest 549 679 19.0" 
$ns at 554.8496431276377 "$node_(47) setdest 1042 893 7.0" 
$ns at 597.6052998224304 "$node_(47) setdest 1165 541 2.0" 
$ns at 642.1358447289605 "$node_(47) setdest 2905 933 7.0" 
$ns at 725.7846866565048 "$node_(47) setdest 48 910 13.0" 
$ns at 854.7344011090029 "$node_(47) setdest 1778 712 15.0" 
$ns at 0.0 "$node_(48) setdest 1846 474 15.0" 
$ns at 111.48056334401953 "$node_(48) setdest 2994 396 6.0" 
$ns at 179.6731750840247 "$node_(48) setdest 1584 735 1.0" 
$ns at 216.46496883596916 "$node_(48) setdest 2775 561 2.0" 
$ns at 255.51374785177723 "$node_(48) setdest 281 646 10.0" 
$ns at 299.28865547483144 "$node_(48) setdest 1585 958 16.0" 
$ns at 425.9962202651234 "$node_(48) setdest 609 945 18.0" 
$ns at 583.804191897938 "$node_(48) setdest 121 254 13.0" 
$ns at 742.006775535795 "$node_(48) setdest 719 528 1.0" 
$ns at 780.454377892094 "$node_(48) setdest 957 683 1.0" 
$ns at 814.0507089246605 "$node_(48) setdest 2155 431 17.0" 
$ns at 0.0 "$node_(49) setdest 635 819 7.0" 
$ns at 96.16395511098496 "$node_(49) setdest 497 272 19.0" 
$ns at 301.84581286547166 "$node_(49) setdest 2716 946 3.0" 
$ns at 338.3505632782219 "$node_(49) setdest 142 207 16.0" 
$ns at 441.7914157374061 "$node_(49) setdest 2078 699 6.0" 
$ns at 527.0836295220878 "$node_(49) setdest 2373 765 10.0" 
$ns at 641.1448237972044 "$node_(49) setdest 2478 973 18.0" 
$ns at 777.8694327452769 "$node_(49) setdest 617 110 1.0" 
$ns at 808.5524349436341 "$node_(49) setdest 1174 265 1.0" 
$ns at 839.3330046720814 "$node_(49) setdest 2549 597 19.0" 
$ns at 0.0 "$node_(50) setdest 1106 942 1.0" 
$ns at 38.47570193886384 "$node_(50) setdest 433 672 1.0" 
$ns at 70.75978673875704 "$node_(50) setdest 942 122 16.0" 
$ns at 118.05660524129358 "$node_(50) setdest 873 466 7.0" 
$ns at 174.50210919626062 "$node_(50) setdest 1002 125 5.0" 
$ns at 253.8510434798628 "$node_(50) setdest 851 670 19.0" 
$ns at 342.05041613590896 "$node_(50) setdest 832 719 10.0" 
$ns at 402.8912495577091 "$node_(50) setdest 1727 498 11.0" 
$ns at 517.4294103821954 "$node_(50) setdest 971 587 11.0" 
$ns at 627.8275011559206 "$node_(50) setdest 588 854 16.0" 
$ns at 767.6759832962788 "$node_(50) setdest 1174 760 13.0" 
$ns at 832.1601314500825 "$node_(50) setdest 1101 2 20.0" 
$ns at 304.346607381967 "$node_(51) setdest 342 145 14.0" 
$ns at 378.2557094815953 "$node_(51) setdest 368 617 12.0" 
$ns at 459.1735499674755 "$node_(51) setdest 1432 223 6.0" 
$ns at 530.5088453471724 "$node_(51) setdest 762 337 15.0" 
$ns at 658.2713494690563 "$node_(51) setdest 96 55 19.0" 
$ns at 741.7182140648174 "$node_(51) setdest 2909 270 19.0" 
$ns at 785.1163496859882 "$node_(51) setdest 2681 757 9.0" 
$ns at 877.2426472227968 "$node_(51) setdest 2405 457 14.0" 
$ns at 200.03035576515282 "$node_(52) setdest 1345 621 8.0" 
$ns at 266.9240946839492 "$node_(52) setdest 2132 92 2.0" 
$ns at 298.20382774130275 "$node_(52) setdest 1918 444 14.0" 
$ns at 383.62880455107705 "$node_(52) setdest 131 175 4.0" 
$ns at 452.02567553501945 "$node_(52) setdest 2811 988 1.0" 
$ns at 486.3929015192755 "$node_(52) setdest 210 169 12.0" 
$ns at 528.5271755080149 "$node_(52) setdest 2990 49 5.0" 
$ns at 600.3310460361204 "$node_(52) setdest 705 368 1.0" 
$ns at 639.0282983747102 "$node_(52) setdest 1073 250 11.0" 
$ns at 720.4537634452004 "$node_(52) setdest 1555 94 2.0" 
$ns at 751.9386195105958 "$node_(52) setdest 40 850 15.0" 
$ns at 255.06700573075324 "$node_(53) setdest 874 458 3.0" 
$ns at 308.55690088775043 "$node_(53) setdest 2450 41 19.0" 
$ns at 499.7458345157547 "$node_(53) setdest 227 796 10.0" 
$ns at 621.8061874317655 "$node_(53) setdest 2372 521 4.0" 
$ns at 669.4838902676158 "$node_(53) setdest 2029 841 4.0" 
$ns at 712.5164538683166 "$node_(53) setdest 2208 919 13.0" 
$ns at 784.4821922187995 "$node_(53) setdest 1373 776 18.0" 
$ns at 869.3016051723258 "$node_(53) setdest 686 417 5.0" 
$ns at 186.05611758325554 "$node_(54) setdest 2581 544 3.0" 
$ns at 216.3201855152439 "$node_(54) setdest 815 859 3.0" 
$ns at 259.4497805045554 "$node_(54) setdest 462 186 14.0" 
$ns at 416.4267618587241 "$node_(54) setdest 113 822 6.0" 
$ns at 448.85505684226894 "$node_(54) setdest 1400 54 14.0" 
$ns at 527.2782351718338 "$node_(54) setdest 2440 304 14.0" 
$ns at 647.6864997136122 "$node_(54) setdest 653 184 18.0" 
$ns at 777.6474897663026 "$node_(54) setdest 2531 747 13.0" 
$ns at 894.6138700460918 "$node_(54) setdest 259 511 10.0" 
$ns at 185.5456556704265 "$node_(55) setdest 135 218 1.0" 
$ns at 225.25738847994847 "$node_(55) setdest 1214 615 13.0" 
$ns at 309.4597176166726 "$node_(55) setdest 2938 71 13.0" 
$ns at 391.8396122855721 "$node_(55) setdest 394 677 19.0" 
$ns at 559.8977473676434 "$node_(55) setdest 1428 708 3.0" 
$ns at 613.1686442943222 "$node_(55) setdest 1196 982 6.0" 
$ns at 675.4488320020708 "$node_(55) setdest 2302 554 9.0" 
$ns at 790.0003625048522 "$node_(55) setdest 833 245 5.0" 
$ns at 846.2028029173625 "$node_(55) setdest 1724 326 8.0" 
$ns at 183.0916023568965 "$node_(56) setdest 731 402 19.0" 
$ns at 260.5245956865816 "$node_(56) setdest 1516 783 11.0" 
$ns at 384.6642140266596 "$node_(56) setdest 861 869 11.0" 
$ns at 482.85304075037266 "$node_(56) setdest 1401 324 4.0" 
$ns at 531.5305874072831 "$node_(56) setdest 2539 822 11.0" 
$ns at 585.7918314423789 "$node_(56) setdest 436 641 7.0" 
$ns at 635.2606670214006 "$node_(56) setdest 817 238 7.0" 
$ns at 729.3149216834138 "$node_(56) setdest 569 383 8.0" 
$ns at 838.6206271303053 "$node_(56) setdest 2071 848 17.0" 
$ns at 202.5671382422838 "$node_(57) setdest 806 801 12.0" 
$ns at 289.2009669817426 "$node_(57) setdest 1099 271 14.0" 
$ns at 345.1760002106627 "$node_(57) setdest 950 480 8.0" 
$ns at 386.53998610826017 "$node_(57) setdest 663 677 17.0" 
$ns at 440.5045451342221 "$node_(57) setdest 94 839 1.0" 
$ns at 475.22872274423304 "$node_(57) setdest 2384 198 13.0" 
$ns at 505.61353499291425 "$node_(57) setdest 613 146 14.0" 
$ns at 579.2379222299014 "$node_(57) setdest 40 320 1.0" 
$ns at 609.9383508735762 "$node_(57) setdest 952 241 8.0" 
$ns at 692.3450871721726 "$node_(57) setdest 1759 147 16.0" 
$ns at 871.3643432987909 "$node_(57) setdest 1749 548 9.0" 
$ns at 183.35383936571392 "$node_(58) setdest 138 815 10.0" 
$ns at 232.34737735138233 "$node_(58) setdest 1035 290 10.0" 
$ns at 275.885326028378 "$node_(58) setdest 1318 607 18.0" 
$ns at 422.7299826717792 "$node_(58) setdest 910 279 11.0" 
$ns at 519.6755961902089 "$node_(58) setdest 971 24 3.0" 
$ns at 569.5828595587942 "$node_(58) setdest 336 314 18.0" 
$ns at 760.5407756367816 "$node_(58) setdest 2157 384 2.0" 
$ns at 803.667080765261 "$node_(58) setdest 1346 367 4.0" 
$ns at 846.3467579349159 "$node_(58) setdest 620 338 7.0" 
$ns at 246.53927913588527 "$node_(59) setdest 175 863 11.0" 
$ns at 292.593096471599 "$node_(59) setdest 2639 40 17.0" 
$ns at 349.4951137812205 "$node_(59) setdest 2133 911 4.0" 
$ns at 404.2675856449562 "$node_(59) setdest 2970 963 5.0" 
$ns at 441.74230844274075 "$node_(59) setdest 1208 716 2.0" 
$ns at 476.6301198753215 "$node_(59) setdest 293 179 5.0" 
$ns at 529.2869747685883 "$node_(59) setdest 2401 143 9.0" 
$ns at 560.6859687393833 "$node_(59) setdest 2120 732 12.0" 
$ns at 695.768771071183 "$node_(59) setdest 1946 672 10.0" 
$ns at 794.7490674628533 "$node_(59) setdest 129 342 4.0" 
$ns at 836.857538353724 "$node_(59) setdest 1687 26 13.0" 
$ns at 890.2349009035173 "$node_(59) setdest 914 723 2.0" 
$ns at 215.3255713722472 "$node_(60) setdest 680 766 13.0" 
$ns at 339.0011635941279 "$node_(60) setdest 2387 972 5.0" 
$ns at 371.63776229556254 "$node_(60) setdest 889 415 3.0" 
$ns at 413.4359584744906 "$node_(60) setdest 1682 14 20.0" 
$ns at 526.566466381792 "$node_(60) setdest 1170 270 12.0" 
$ns at 633.9267895777673 "$node_(60) setdest 1547 116 1.0" 
$ns at 672.3301404191265 "$node_(60) setdest 1566 342 15.0" 
$ns at 744.3598233616386 "$node_(60) setdest 541 715 5.0" 
$ns at 818.3223432603712 "$node_(60) setdest 2821 100 6.0" 
$ns at 276.5141989038727 "$node_(61) setdest 201 92 19.0" 
$ns at 364.86147066481425 "$node_(61) setdest 1109 849 18.0" 
$ns at 503.1911742769946 "$node_(61) setdest 250 631 9.0" 
$ns at 579.7756128919638 "$node_(61) setdest 2507 862 6.0" 
$ns at 649.5710349516719 "$node_(61) setdest 2004 53 19.0" 
$ns at 721.0589453815925 "$node_(61) setdest 2957 442 5.0" 
$ns at 795.2519374403727 "$node_(61) setdest 30 936 1.0" 
$ns at 831.9120720401014 "$node_(61) setdest 2515 573 16.0" 
$ns at 175.043396059265 "$node_(62) setdest 2694 601 5.0" 
$ns at 230.46827463868786 "$node_(62) setdest 96 138 16.0" 
$ns at 313.3346172714858 "$node_(62) setdest 1807 810 12.0" 
$ns at 449.46142043345503 "$node_(62) setdest 817 526 7.0" 
$ns at 505.7247851501769 "$node_(62) setdest 150 407 18.0" 
$ns at 584.1193600628252 "$node_(62) setdest 2816 979 1.0" 
$ns at 618.103963448074 "$node_(62) setdest 2114 774 11.0" 
$ns at 682.3695010578916 "$node_(62) setdest 2036 95 15.0" 
$ns at 775.5481869202481 "$node_(62) setdest 2303 348 6.0" 
$ns at 856.4788692360627 "$node_(62) setdest 1461 611 14.0" 
$ns at 239.62785687359894 "$node_(63) setdest 884 178 15.0" 
$ns at 327.80862294602014 "$node_(63) setdest 2889 132 18.0" 
$ns at 512.9150767807358 "$node_(63) setdest 1437 525 15.0" 
$ns at 664.4881365000946 "$node_(63) setdest 1988 670 5.0" 
$ns at 734.4594627568476 "$node_(63) setdest 953 686 15.0" 
$ns at 804.5225561860829 "$node_(63) setdest 1966 144 17.0" 
$ns at 893.3822418199637 "$node_(63) setdest 2249 348 13.0" 
$ns at 295.04794743807014 "$node_(64) setdest 901 549 6.0" 
$ns at 383.8032969917649 "$node_(64) setdest 2404 697 15.0" 
$ns at 514.57807823965 "$node_(64) setdest 1132 840 3.0" 
$ns at 565.1000640078962 "$node_(64) setdest 2034 891 6.0" 
$ns at 619.4625455698585 "$node_(64) setdest 2671 324 3.0" 
$ns at 676.9598934449448 "$node_(64) setdest 2857 349 7.0" 
$ns at 734.2262614478672 "$node_(64) setdest 712 809 19.0" 
$ns at 890.5044925009998 "$node_(64) setdest 2754 923 6.0" 
$ns at 182.7489055802048 "$node_(65) setdest 2502 756 18.0" 
$ns at 275.7017354446817 "$node_(65) setdest 4 671 5.0" 
$ns at 348.56459157535545 "$node_(65) setdest 114 421 1.0" 
$ns at 378.577989857191 "$node_(65) setdest 2664 959 1.0" 
$ns at 416.50166491876814 "$node_(65) setdest 1978 158 1.0" 
$ns at 451.5215964057514 "$node_(65) setdest 1161 911 8.0" 
$ns at 528.1011146616429 "$node_(65) setdest 1140 21 2.0" 
$ns at 569.717861642144 "$node_(65) setdest 1425 662 13.0" 
$ns at 709.739337209646 "$node_(65) setdest 502 519 8.0" 
$ns at 763.5856712405143 "$node_(65) setdest 1924 589 1.0" 
$ns at 795.3256283321663 "$node_(65) setdest 533 265 4.0" 
$ns at 843.8216909030156 "$node_(65) setdest 850 544 2.0" 
$ns at 887.327002127322 "$node_(65) setdest 467 119 17.0" 
$ns at 232.07918522544625 "$node_(66) setdest 1538 249 7.0" 
$ns at 281.83335800464 "$node_(66) setdest 1249 55 7.0" 
$ns at 318.49025318979994 "$node_(66) setdest 1440 812 3.0" 
$ns at 362.5447496708748 "$node_(66) setdest 2584 191 4.0" 
$ns at 400.6710030885618 "$node_(66) setdest 449 942 5.0" 
$ns at 442.37451847882255 "$node_(66) setdest 461 95 9.0" 
$ns at 486.81994423813217 "$node_(66) setdest 2257 739 19.0" 
$ns at 578.0200620388435 "$node_(66) setdest 1433 280 16.0" 
$ns at 742.792928206015 "$node_(66) setdest 692 158 6.0" 
$ns at 825.9546255054596 "$node_(66) setdest 2027 823 2.0" 
$ns at 863.1415138044446 "$node_(66) setdest 1254 170 11.0" 
$ns at 321.3764386987877 "$node_(67) setdest 150 449 17.0" 
$ns at 467.66816049946397 "$node_(67) setdest 2629 2 1.0" 
$ns at 505.1302482322905 "$node_(67) setdest 624 877 14.0" 
$ns at 593.3081038380883 "$node_(67) setdest 2533 759 19.0" 
$ns at 724.4665750343022 "$node_(67) setdest 2333 999 8.0" 
$ns at 789.7235128322964 "$node_(67) setdest 5 466 6.0" 
$ns at 837.5867499426389 "$node_(67) setdest 2442 281 5.0" 
$ns at 199.38429769561031 "$node_(68) setdest 958 419 4.0" 
$ns at 259.80642647689825 "$node_(68) setdest 1860 470 18.0" 
$ns at 451.7084809641981 "$node_(68) setdest 2869 252 16.0" 
$ns at 501.59341052517306 "$node_(68) setdest 2783 831 14.0" 
$ns at 618.0774997948131 "$node_(68) setdest 1525 886 4.0" 
$ns at 650.1015551369994 "$node_(68) setdest 1514 287 19.0" 
$ns at 692.4992072390098 "$node_(68) setdest 840 327 7.0" 
$ns at 752.3219144489874 "$node_(68) setdest 816 531 8.0" 
$ns at 797.3231565383444 "$node_(68) setdest 974 866 17.0" 
$ns at 324.89039271228717 "$node_(69) setdest 615 573 15.0" 
$ns at 364.7756608247851 "$node_(69) setdest 1942 705 1.0" 
$ns at 396.7545034151182 "$node_(69) setdest 971 348 6.0" 
$ns at 465.5639576563003 "$node_(69) setdest 1510 955 13.0" 
$ns at 547.8541288132494 "$node_(69) setdest 133 917 12.0" 
$ns at 684.0432761688738 "$node_(69) setdest 2128 152 20.0" 
$ns at 824.3650902382508 "$node_(69) setdest 1563 882 14.0" 
$ns at 190.26780030124755 "$node_(70) setdest 1984 782 20.0" 
$ns at 315.48310096792727 "$node_(70) setdest 1708 24 15.0" 
$ns at 449.40464216632796 "$node_(70) setdest 2808 327 7.0" 
$ns at 507.51423812409826 "$node_(70) setdest 2718 691 4.0" 
$ns at 547.7559721224359 "$node_(70) setdest 2333 96 14.0" 
$ns at 642.9344585843635 "$node_(70) setdest 1554 371 18.0" 
$ns at 690.9238760029541 "$node_(70) setdest 697 226 13.0" 
$ns at 785.6333519922673 "$node_(70) setdest 265 517 6.0" 
$ns at 834.870099418485 "$node_(70) setdest 2435 787 11.0" 
$ns at 207.9106150955626 "$node_(71) setdest 2972 695 4.0" 
$ns at 242.28192224029598 "$node_(71) setdest 1830 341 3.0" 
$ns at 292.780292705584 "$node_(71) setdest 107 279 12.0" 
$ns at 442.6962530853859 "$node_(71) setdest 1727 112 8.0" 
$ns at 534.5732478323946 "$node_(71) setdest 473 925 11.0" 
$ns at 617.8026243253382 "$node_(71) setdest 2073 507 6.0" 
$ns at 654.7919916806924 "$node_(71) setdest 974 682 17.0" 
$ns at 704.0662613770241 "$node_(71) setdest 897 94 16.0" 
$ns at 859.1705047643441 "$node_(71) setdest 1676 654 13.0" 
$ns at 209.37642997096893 "$node_(72) setdest 2314 98 18.0" 
$ns at 377.87695881630606 "$node_(72) setdest 7 159 16.0" 
$ns at 527.1412082506547 "$node_(72) setdest 2150 10 7.0" 
$ns at 624.924926429045 "$node_(72) setdest 1445 486 2.0" 
$ns at 665.3803174557049 "$node_(72) setdest 845 174 8.0" 
$ns at 752.0429098285565 "$node_(72) setdest 2205 144 4.0" 
$ns at 786.0274941234561 "$node_(72) setdest 360 807 18.0" 
$ns at 858.7202289775187 "$node_(72) setdest 1722 22 10.0" 
$ns at 202.9651139117745 "$node_(73) setdest 1490 969 9.0" 
$ns at 321.6078503289822 "$node_(73) setdest 2031 803 7.0" 
$ns at 405.9054656850996 "$node_(73) setdest 1921 991 20.0" 
$ns at 487.47070060901376 "$node_(73) setdest 1274 310 10.0" 
$ns at 564.8726161030976 "$node_(73) setdest 562 930 3.0" 
$ns at 602.3088421623635 "$node_(73) setdest 453 241 14.0" 
$ns at 721.7674195817573 "$node_(73) setdest 596 362 2.0" 
$ns at 766.9760840977581 "$node_(73) setdest 1223 454 14.0" 
$ns at 245.29868397068213 "$node_(74) setdest 800 759 2.0" 
$ns at 288.34956657015647 "$node_(74) setdest 2590 320 3.0" 
$ns at 330.0156764040568 "$node_(74) setdest 2959 258 18.0" 
$ns at 523.4478794292463 "$node_(74) setdest 1990 693 2.0" 
$ns at 564.4510414490956 "$node_(74) setdest 160 973 14.0" 
$ns at 687.617166862443 "$node_(74) setdest 457 270 4.0" 
$ns at 718.2810912542135 "$node_(74) setdest 2640 483 19.0" 
$ns at 764.3742042968356 "$node_(74) setdest 2651 81 3.0" 
$ns at 794.8783772688661 "$node_(74) setdest 841 25 4.0" 
$ns at 852.2860445655922 "$node_(74) setdest 2617 96 12.0" 
$ns at 371.7085795144802 "$node_(75) setdest 894 719 10.0" 
$ns at 449.14976195788074 "$node_(75) setdest 2964 418 5.0" 
$ns at 483.10975072422974 "$node_(75) setdest 2919 676 9.0" 
$ns at 571.9646957147086 "$node_(75) setdest 2020 270 4.0" 
$ns at 639.0810131823958 "$node_(75) setdest 1644 320 13.0" 
$ns at 726.5460348807095 "$node_(75) setdest 798 563 6.0" 
$ns at 759.5019197139671 "$node_(75) setdest 2830 577 8.0" 
$ns at 837.9613207556448 "$node_(75) setdest 745 795 1.0" 
$ns at 870.7267098093142 "$node_(75) setdest 2953 848 15.0" 
$ns at 386.5644977822695 "$node_(76) setdest 1086 564 11.0" 
$ns at 488.16305433231656 "$node_(76) setdest 251 97 11.0" 
$ns at 546.8116782172657 "$node_(76) setdest 576 431 18.0" 
$ns at 664.8777706423994 "$node_(76) setdest 606 480 9.0" 
$ns at 763.4865598040716 "$node_(76) setdest 120 935 7.0" 
$ns at 845.5173654146953 "$node_(76) setdest 2761 254 11.0" 
$ns at 387.0437601545709 "$node_(77) setdest 1205 874 11.0" 
$ns at 447.24870879761227 "$node_(77) setdest 496 704 3.0" 
$ns at 484.7084394188335 "$node_(77) setdest 1790 353 10.0" 
$ns at 559.5134348159704 "$node_(77) setdest 2006 282 11.0" 
$ns at 640.6776464776707 "$node_(77) setdest 453 208 12.0" 
$ns at 722.9872714605282 "$node_(77) setdest 513 246 12.0" 
$ns at 827.8031610942152 "$node_(77) setdest 2641 21 6.0" 
$ns at 885.5910773664199 "$node_(77) setdest 2866 566 6.0" 
$ns at 374.3721863343581 "$node_(78) setdest 1627 712 9.0" 
$ns at 437.3702129041026 "$node_(78) setdest 2360 538 15.0" 
$ns at 516.8083634679906 "$node_(78) setdest 1459 867 15.0" 
$ns at 619.9051771099034 "$node_(78) setdest 732 427 18.0" 
$ns at 650.1888293316582 "$node_(78) setdest 216 572 7.0" 
$ns at 739.0675403217757 "$node_(78) setdest 918 593 8.0" 
$ns at 804.628347261717 "$node_(78) setdest 2866 671 19.0" 
$ns at 899.4892913591939 "$node_(78) setdest 1066 696 5.0" 
$ns at 437.2463893944646 "$node_(79) setdest 324 500 11.0" 
$ns at 543.8780434205348 "$node_(79) setdest 2756 195 11.0" 
$ns at 623.9506396645602 "$node_(79) setdest 1558 447 14.0" 
$ns at 784.963383559523 "$node_(79) setdest 1146 488 10.0" 
$ns at 886.8368735916393 "$node_(79) setdest 57 817 9.0" 
$ns at 376.7052587297583 "$node_(80) setdest 1773 517 6.0" 
$ns at 439.8698838076756 "$node_(80) setdest 1812 87 7.0" 
$ns at 521.0557475222366 "$node_(80) setdest 2597 243 6.0" 
$ns at 576.9228643088583 "$node_(80) setdest 2332 125 16.0" 
$ns at 643.8351039600739 "$node_(80) setdest 1129 884 17.0" 
$ns at 754.8221272549603 "$node_(80) setdest 332 807 15.0" 
$ns at 893.3828347850714 "$node_(80) setdest 13 997 8.0" 
$ns at 342.91486061576285 "$node_(81) setdest 1837 270 12.0" 
$ns at 462.58005965476696 "$node_(81) setdest 2573 301 14.0" 
$ns at 598.3131762944979 "$node_(81) setdest 387 978 14.0" 
$ns at 674.8402553752713 "$node_(81) setdest 1647 578 15.0" 
$ns at 761.6043268467653 "$node_(81) setdest 2040 671 18.0" 
$ns at 390.50062159208403 "$node_(82) setdest 2962 962 13.0" 
$ns at 526.0584379028012 "$node_(82) setdest 622 32 16.0" 
$ns at 697.9796439586487 "$node_(82) setdest 1443 976 13.0" 
$ns at 743.4633800029346 "$node_(82) setdest 1354 357 13.0" 
$ns at 806.8143936529949 "$node_(82) setdest 1726 709 7.0" 
$ns at 843.3014804871033 "$node_(82) setdest 588 271 16.0" 
$ns at 362.2767428891955 "$node_(83) setdest 2924 410 16.0" 
$ns at 500.5943958366033 "$node_(83) setdest 347 109 4.0" 
$ns at 542.9725802758259 "$node_(83) setdest 2581 708 9.0" 
$ns at 617.2916222702382 "$node_(83) setdest 2630 563 16.0" 
$ns at 788.2745791853565 "$node_(83) setdest 1417 9 1.0" 
$ns at 821.4293246682262 "$node_(83) setdest 719 968 4.0" 
$ns at 855.6996849172605 "$node_(83) setdest 714 776 8.0" 
$ns at 897.7467246432595 "$node_(83) setdest 1771 260 1.0" 
$ns at 367.3001864569549 "$node_(84) setdest 2793 614 19.0" 
$ns at 465.4497619491776 "$node_(84) setdest 1104 830 16.0" 
$ns at 562.0248957891087 "$node_(84) setdest 2843 889 15.0" 
$ns at 602.1158697604194 "$node_(84) setdest 2689 556 10.0" 
$ns at 652.1928779808047 "$node_(84) setdest 834 778 14.0" 
$ns at 698.2392210905832 "$node_(84) setdest 2235 595 8.0" 
$ns at 767.918362151687 "$node_(84) setdest 851 699 3.0" 
$ns at 822.1439186770641 "$node_(84) setdest 2005 237 16.0" 
$ns at 882.1166867153144 "$node_(84) setdest 15 10 20.0" 
$ns at 363.627613426302 "$node_(85) setdest 1469 487 12.0" 
$ns at 413.5037388444904 "$node_(85) setdest 54 285 18.0" 
$ns at 544.27400567142 "$node_(85) setdest 1885 817 4.0" 
$ns at 590.657156827277 "$node_(85) setdest 561 714 6.0" 
$ns at 670.5845065633468 "$node_(85) setdest 400 459 10.0" 
$ns at 782.9838742654559 "$node_(85) setdest 1847 239 18.0" 
$ns at 344.51802916035535 "$node_(86) setdest 976 141 3.0" 
$ns at 397.52610162190376 "$node_(86) setdest 2714 93 6.0" 
$ns at 465.6455062485878 "$node_(86) setdest 871 593 12.0" 
$ns at 538.821186052065 "$node_(86) setdest 1154 922 7.0" 
$ns at 583.9209465427359 "$node_(86) setdest 1965 719 9.0" 
$ns at 616.2976422737186 "$node_(86) setdest 2366 984 10.0" 
$ns at 692.8915741657872 "$node_(86) setdest 1118 735 6.0" 
$ns at 728.4356133780269 "$node_(86) setdest 2016 489 11.0" 
$ns at 829.7880177344657 "$node_(86) setdest 16 1 5.0" 
$ns at 868.7849822818639 "$node_(86) setdest 180 717 3.0" 
$ns at 399.2066834282866 "$node_(87) setdest 2845 611 7.0" 
$ns at 487.0560364948768 "$node_(87) setdest 1859 891 7.0" 
$ns at 562.160934297318 "$node_(87) setdest 725 54 5.0" 
$ns at 620.8407296332464 "$node_(87) setdest 792 56 1.0" 
$ns at 660.8305747263975 "$node_(87) setdest 2477 174 14.0" 
$ns at 758.563800206032 "$node_(87) setdest 1706 627 10.0" 
$ns at 806.0561355559822 "$node_(87) setdest 687 30 16.0" 
$ns at 365.942740731969 "$node_(88) setdest 2399 571 19.0" 
$ns at 438.57912627545363 "$node_(88) setdest 2545 795 1.0" 
$ns at 473.4181884008275 "$node_(88) setdest 2495 170 4.0" 
$ns at 512.2994104781859 "$node_(88) setdest 2125 221 20.0" 
$ns at 576.5771530983696 "$node_(88) setdest 365 552 17.0" 
$ns at 625.077087230807 "$node_(88) setdest 2735 393 1.0" 
$ns at 663.5802333520628 "$node_(88) setdest 1455 140 14.0" 
$ns at 779.3980827062052 "$node_(88) setdest 1472 596 17.0" 
$ns at 382.0006149886886 "$node_(89) setdest 38 96 3.0" 
$ns at 427.13194223567757 "$node_(89) setdest 1484 94 13.0" 
$ns at 485.29409504721303 "$node_(89) setdest 1197 329 14.0" 
$ns at 603.053281796228 "$node_(89) setdest 808 225 20.0" 
$ns at 683.2271937725733 "$node_(89) setdest 2461 733 11.0" 
$ns at 792.5862343296575 "$node_(89) setdest 2845 308 5.0" 
$ns at 828.1586287191008 "$node_(89) setdest 2862 641 1.0" 
$ns at 867.5041614003356 "$node_(89) setdest 1039 907 17.0" 
$ns at 344.3640219967708 "$node_(90) setdest 83 245 13.0" 
$ns at 386.5771151646012 "$node_(90) setdest 2680 933 6.0" 
$ns at 443.24423024613156 "$node_(90) setdest 1144 423 5.0" 
$ns at 495.52625061272215 "$node_(90) setdest 952 444 3.0" 
$ns at 535.3094711855946 "$node_(90) setdest 2140 416 12.0" 
$ns at 603.9515261937288 "$node_(90) setdest 1742 519 6.0" 
$ns at 647.9522644255303 "$node_(90) setdest 754 382 15.0" 
$ns at 722.3807755237548 "$node_(90) setdest 66 676 3.0" 
$ns at 775.3996313166489 "$node_(90) setdest 2560 649 3.0" 
$ns at 809.2888264734047 "$node_(90) setdest 591 171 8.0" 
$ns at 879.0386886478782 "$node_(90) setdest 2262 929 18.0" 
$ns at 358.9921674963647 "$node_(91) setdest 992 51 5.0" 
$ns at 427.2709004053824 "$node_(91) setdest 31 368 10.0" 
$ns at 534.5210163661814 "$node_(91) setdest 2091 633 1.0" 
$ns at 565.9094016062426 "$node_(91) setdest 942 719 18.0" 
$ns at 604.0858056631389 "$node_(91) setdest 1438 477 2.0" 
$ns at 643.0626903725554 "$node_(91) setdest 388 934 9.0" 
$ns at 685.617171999675 "$node_(91) setdest 588 315 5.0" 
$ns at 725.2205934996481 "$node_(91) setdest 269 215 1.0" 
$ns at 761.2315967280578 "$node_(91) setdest 1073 210 19.0" 
$ns at 382.52111083843477 "$node_(92) setdest 88 714 11.0" 
$ns at 486.3487047847675 "$node_(92) setdest 2665 419 16.0" 
$ns at 583.9346279427617 "$node_(92) setdest 2909 435 14.0" 
$ns at 672.9505859392476 "$node_(92) setdest 3 677 13.0" 
$ns at 781.808604521206 "$node_(92) setdest 2567 296 19.0" 
$ns at 814.4673561479063 "$node_(92) setdest 2216 697 14.0" 
$ns at 878.9252198259986 "$node_(92) setdest 1124 335 20.0" 
$ns at 353.1582157338593 "$node_(93) setdest 299 709 17.0" 
$ns at 412.409409719101 "$node_(93) setdest 1294 92 18.0" 
$ns at 595.7166500785396 "$node_(93) setdest 384 345 14.0" 
$ns at 680.0873920928148 "$node_(93) setdest 1822 961 10.0" 
$ns at 750.8803636004849 "$node_(93) setdest 1801 318 6.0" 
$ns at 815.6612243852356 "$node_(93) setdest 2463 466 17.0" 
$ns at 894.3713443724982 "$node_(93) setdest 494 74 16.0" 
$ns at 373.69279749658654 "$node_(94) setdest 1403 993 16.0" 
$ns at 428.1145889858059 "$node_(94) setdest 340 65 1.0" 
$ns at 459.81946761062073 "$node_(94) setdest 571 186 13.0" 
$ns at 510.6843967477253 "$node_(94) setdest 2519 490 7.0" 
$ns at 560.976098185538 "$node_(94) setdest 690 986 11.0" 
$ns at 615.514521347028 "$node_(94) setdest 1064 599 18.0" 
$ns at 819.5109465589205 "$node_(94) setdest 1784 120 17.0" 
$ns at 335.5776054944665 "$node_(95) setdest 2119 867 2.0" 
$ns at 367.9139929439775 "$node_(95) setdest 1269 821 12.0" 
$ns at 408.7701698216664 "$node_(95) setdest 2070 103 8.0" 
$ns at 475.0385833623278 "$node_(95) setdest 607 355 3.0" 
$ns at 534.5929303273139 "$node_(95) setdest 1823 561 1.0" 
$ns at 570.2563043621035 "$node_(95) setdest 695 176 1.0" 
$ns at 608.9146361848508 "$node_(95) setdest 1127 320 8.0" 
$ns at 701.9242602921142 "$node_(95) setdest 2027 480 10.0" 
$ns at 764.7833597003143 "$node_(95) setdest 363 625 15.0" 
$ns at 899.7371607528363 "$node_(95) setdest 2571 821 15.0" 
$ns at 455.92515343190036 "$node_(96) setdest 611 820 4.0" 
$ns at 490.01023244188605 "$node_(96) setdest 1497 982 6.0" 
$ns at 571.2787376890304 "$node_(96) setdest 2208 673 1.0" 
$ns at 608.7657857037361 "$node_(96) setdest 225 44 5.0" 
$ns at 682.794362618257 "$node_(96) setdest 752 153 9.0" 
$ns at 768.3205405325883 "$node_(96) setdest 1693 601 8.0" 
$ns at 838.418814700751 "$node_(96) setdest 1793 371 12.0" 
$ns at 475.618963559843 "$node_(97) setdest 2650 721 4.0" 
$ns at 528.279881416856 "$node_(97) setdest 2472 128 8.0" 
$ns at 563.2202459004523 "$node_(97) setdest 1659 472 6.0" 
$ns at 626.8344264790776 "$node_(97) setdest 693 863 10.0" 
$ns at 670.1541566251145 "$node_(97) setdest 1598 648 8.0" 
$ns at 730.5553682937232 "$node_(97) setdest 2551 693 6.0" 
$ns at 813.8853839601474 "$node_(97) setdest 2329 359 10.0" 
$ns at 870.0208963020223 "$node_(97) setdest 341 557 19.0" 
$ns at 449.2593864967984 "$node_(98) setdest 2020 647 11.0" 
$ns at 529.1143391297672 "$node_(98) setdest 195 181 7.0" 
$ns at 578.0778118067856 "$node_(98) setdest 2865 622 4.0" 
$ns at 610.4463696494128 "$node_(98) setdest 1728 774 1.0" 
$ns at 641.0937558992266 "$node_(98) setdest 688 685 13.0" 
$ns at 761.0269115564377 "$node_(98) setdest 2994 517 4.0" 
$ns at 820.559958617356 "$node_(98) setdest 1172 871 11.0" 
$ns at 891.6581080751785 "$node_(98) setdest 2555 771 13.0" 
$ns at 336.34946320481714 "$node_(99) setdest 80 347 7.0" 
$ns at 383.5663841930865 "$node_(99) setdest 1374 422 12.0" 
$ns at 489.4472323267184 "$node_(99) setdest 868 885 15.0" 
$ns at 624.9750107917723 "$node_(99) setdest 882 545 16.0" 
$ns at 733.0472212342074 "$node_(99) setdest 475 881 10.0" 
$ns at 763.6357496948033 "$node_(99) setdest 1508 127 2.0" 
$ns at 810.1558806962562 "$node_(99) setdest 912 988 5.0" 
$ns at 876.1997673220417 "$node_(99) setdest 1709 188 15.0" 
$ns at 548.8083921762213 "$node_(100) setdest 2194 56 8.0" 
$ns at 631.6340928720447 "$node_(100) setdest 1787 827 8.0" 
$ns at 707.0757210006196 "$node_(100) setdest 756 230 6.0" 
$ns at 747.8162905123181 "$node_(100) setdest 2498 937 9.0" 
$ns at 794.6093536719652 "$node_(100) setdest 2062 333 14.0" 
$ns at 521.0288162689774 "$node_(101) setdest 426 711 18.0" 
$ns at 564.1291669734894 "$node_(101) setdest 2110 779 14.0" 
$ns at 725.6705239349569 "$node_(101) setdest 2140 53 4.0" 
$ns at 773.8717452188773 "$node_(101) setdest 1846 593 12.0" 
$ns at 865.6516048845224 "$node_(101) setdest 611 578 11.0" 
$ns at 596.5271027526304 "$node_(102) setdest 2116 89 17.0" 
$ns at 763.7349471235533 "$node_(102) setdest 1745 823 10.0" 
$ns at 851.5250563752684 "$node_(102) setdest 399 762 12.0" 
$ns at 513.3182443835461 "$node_(103) setdest 526 703 6.0" 
$ns at 559.3078086054371 "$node_(103) setdest 2221 308 7.0" 
$ns at 614.8031994548594 "$node_(103) setdest 2548 721 14.0" 
$ns at 725.1599316821433 "$node_(103) setdest 1358 704 17.0" 
$ns at 889.824267471805 "$node_(103) setdest 1632 221 8.0" 
$ns at 534.2615907244971 "$node_(104) setdest 228 587 6.0" 
$ns at 605.476376219895 "$node_(104) setdest 1005 245 15.0" 
$ns at 726.1154396785032 "$node_(104) setdest 98 453 12.0" 
$ns at 763.2559352429091 "$node_(104) setdest 1866 238 17.0" 
$ns at 566.2259981966341 "$node_(105) setdest 443 344 15.0" 
$ns at 662.7074192816638 "$node_(105) setdest 390 524 14.0" 
$ns at 738.0201081836676 "$node_(105) setdest 2983 315 14.0" 
$ns at 840.9804944052767 "$node_(105) setdest 987 331 12.0" 
$ns at 549.337812253244 "$node_(106) setdest 2555 824 1.0" 
$ns at 586.9569248411068 "$node_(106) setdest 1877 551 16.0" 
$ns at 756.5642409208126 "$node_(106) setdest 317 448 10.0" 
$ns at 885.262846130945 "$node_(106) setdest 337 859 12.0" 
$ns at 566.5889031792668 "$node_(107) setdest 1409 241 8.0" 
$ns at 658.1223358900296 "$node_(107) setdest 2030 363 19.0" 
$ns at 779.7265041507383 "$node_(107) setdest 431 457 9.0" 
$ns at 894.2734718115593 "$node_(107) setdest 1616 396 1.0" 
$ns at 517.7345228848237 "$node_(108) setdest 1474 627 17.0" 
$ns at 711.0218322608783 "$node_(108) setdest 795 333 7.0" 
$ns at 786.5638345401637 "$node_(108) setdest 301 881 20.0" 
$ns at 497.6569701512507 "$node_(109) setdest 1702 372 18.0" 
$ns at 547.3612075490305 "$node_(109) setdest 1376 574 10.0" 
$ns at 627.9796839018077 "$node_(109) setdest 2211 401 16.0" 
$ns at 730.5832902124546 "$node_(109) setdest 1789 921 14.0" 
$ns at 809.9495550981104 "$node_(109) setdest 273 552 5.0" 
$ns at 869.9160788203995 "$node_(109) setdest 541 144 10.0" 
$ns at 562.0607781244513 "$node_(110) setdest 1889 798 16.0" 
$ns at 638.912839245504 "$node_(110) setdest 2514 250 4.0" 
$ns at 695.639068763118 "$node_(110) setdest 1458 516 20.0" 
$ns at 639.7752315965375 "$node_(111) setdest 1328 114 13.0" 
$ns at 671.5709405571362 "$node_(111) setdest 2923 671 20.0" 
$ns at 852.7333805471944 "$node_(111) setdest 800 435 1.0" 
$ns at 892.3615544411751 "$node_(111) setdest 1635 233 4.0" 
$ns at 553.4102126798418 "$node_(112) setdest 2563 342 5.0" 
$ns at 584.4108604445581 "$node_(112) setdest 2576 373 18.0" 
$ns at 730.5763745896106 "$node_(112) setdest 1700 203 19.0" 
$ns at 506.17617558975513 "$node_(113) setdest 26 498 7.0" 
$ns at 578.1675020616449 "$node_(113) setdest 878 610 17.0" 
$ns at 686.9923627079593 "$node_(113) setdest 2835 799 10.0" 
$ns at 744.8899171240253 "$node_(113) setdest 2124 981 6.0" 
$ns at 807.7644940828662 "$node_(113) setdest 783 982 6.0" 
$ns at 872.6302121537419 "$node_(113) setdest 464 103 2.0" 
$ns at 576.254033037221 "$node_(114) setdest 1199 817 2.0" 
$ns at 618.7186328835161 "$node_(114) setdest 763 454 2.0" 
$ns at 664.1557770229047 "$node_(114) setdest 2616 588 13.0" 
$ns at 741.7284612651279 "$node_(114) setdest 1677 760 10.0" 
$ns at 861.4640457930483 "$node_(114) setdest 2011 692 2.0" 
$ns at 541.2340783110881 "$node_(115) setdest 808 667 10.0" 
$ns at 589.8712233752624 "$node_(115) setdest 2122 585 9.0" 
$ns at 680.5317867551083 "$node_(115) setdest 2857 761 1.0" 
$ns at 716.687913593555 "$node_(115) setdest 1436 356 7.0" 
$ns at 788.5610862277505 "$node_(115) setdest 613 953 2.0" 
$ns at 820.7220690350416 "$node_(115) setdest 1492 581 9.0" 
$ns at 565.4964136186616 "$node_(116) setdest 53 971 7.0" 
$ns at 665.0258159374748 "$node_(116) setdest 396 430 3.0" 
$ns at 697.4344762610871 "$node_(116) setdest 607 90 6.0" 
$ns at 740.1272130205452 "$node_(116) setdest 1195 190 20.0" 
$ns at 802.8967304948359 "$node_(116) setdest 540 646 19.0" 
$ns at 548.013261733763 "$node_(117) setdest 1203 728 18.0" 
$ns at 663.434690544081 "$node_(117) setdest 745 133 4.0" 
$ns at 723.5695311320192 "$node_(117) setdest 174 994 5.0" 
$ns at 789.2083026262935 "$node_(117) setdest 2215 600 4.0" 
$ns at 852.7556254887409 "$node_(117) setdest 1445 605 19.0" 
$ns at 522.8405213732716 "$node_(118) setdest 2574 806 10.0" 
$ns at 563.9712958623145 "$node_(118) setdest 361 404 15.0" 
$ns at 597.362966728843 "$node_(118) setdest 2046 819 4.0" 
$ns at 638.6220716091027 "$node_(118) setdest 78 590 9.0" 
$ns at 755.5020485415592 "$node_(118) setdest 2081 756 17.0" 
$ns at 896.1908097619706 "$node_(118) setdest 2589 731 13.0" 
$ns at 502.75437412415874 "$node_(119) setdest 2798 592 9.0" 
$ns at 592.8995262547902 "$node_(119) setdest 642 354 16.0" 
$ns at 719.8227075695473 "$node_(119) setdest 2708 303 10.0" 
$ns at 788.9491325856908 "$node_(119) setdest 511 415 15.0" 
$ns at 858.8787610891636 "$node_(119) setdest 816 14 11.0" 
$ns at 522.0079925876862 "$node_(120) setdest 1623 696 9.0" 
$ns at 637.1419743185273 "$node_(120) setdest 315 245 4.0" 
$ns at 683.4224812840062 "$node_(120) setdest 1170 423 13.0" 
$ns at 761.1038127611167 "$node_(120) setdest 2498 72 16.0" 
$ns at 818.8516748352883 "$node_(120) setdest 275 513 2.0" 
$ns at 858.498351867685 "$node_(120) setdest 1176 419 7.0" 
$ns at 563.2102065963975 "$node_(121) setdest 1701 15 12.0" 
$ns at 679.0208656904424 "$node_(121) setdest 1144 731 1.0" 
$ns at 709.4814343925242 "$node_(121) setdest 1705 423 2.0" 
$ns at 755.5588357955453 "$node_(121) setdest 363 258 16.0" 
$ns at 531.1340130690232 "$node_(122) setdest 2233 8 2.0" 
$ns at 563.4863458042835 "$node_(122) setdest 468 262 9.0" 
$ns at 666.9182620225139 "$node_(122) setdest 2877 346 11.0" 
$ns at 706.5322554523839 "$node_(122) setdest 1792 28 17.0" 
$ns at 845.9609264457551 "$node_(122) setdest 2145 948 10.0" 
$ns at 514.5466407857199 "$node_(123) setdest 684 113 19.0" 
$ns at 678.7048343137142 "$node_(123) setdest 1253 922 19.0" 
$ns at 808.2725803953601 "$node_(123) setdest 1977 177 5.0" 
$ns at 865.8846696511586 "$node_(123) setdest 1951 316 13.0" 
$ns at 529.913393829086 "$node_(124) setdest 1412 857 5.0" 
$ns at 605.7328642162215 "$node_(124) setdest 1243 382 1.0" 
$ns at 635.7798186626063 "$node_(124) setdest 660 673 18.0" 
$ns at 670.033914988645 "$node_(124) setdest 1166 441 5.0" 
$ns at 719.2790776606448 "$node_(124) setdest 2412 555 18.0" 
$ns at 678.8844542791927 "$node_(125) setdest 497 670 11.0" 
$ns at 769.7575116738527 "$node_(125) setdest 1006 882 19.0" 
$ns at 899.7483693620044 "$node_(125) setdest 2863 277 11.0" 
$ns at 703.5947158117342 "$node_(126) setdest 1822 737 1.0" 
$ns at 740.3139206382006 "$node_(126) setdest 2765 464 7.0" 
$ns at 810.2948438431247 "$node_(126) setdest 2957 965 14.0" 
$ns at 853.582476995926 "$node_(126) setdest 1093 295 17.0" 
$ns at 893.9680362515093 "$node_(126) setdest 1670 204 12.0" 
$ns at 678.8613511138175 "$node_(127) setdest 2484 543 20.0" 
$ns at 745.6591106510521 "$node_(127) setdest 2027 320 9.0" 
$ns at 838.8402570596737 "$node_(127) setdest 1824 550 1.0" 
$ns at 869.4219603996704 "$node_(127) setdest 848 289 19.0" 
$ns at 691.3790365548482 "$node_(128) setdest 527 766 14.0" 
$ns at 767.7013481779303 "$node_(128) setdest 680 267 13.0" 
$ns at 748.8272477037821 "$node_(129) setdest 188 951 2.0" 
$ns at 783.3632247990224 "$node_(129) setdest 512 738 15.0" 
$ns at 724.324292698772 "$node_(130) setdest 1393 888 4.0" 
$ns at 759.7762577331024 "$node_(130) setdest 483 372 15.0" 
$ns at 821.5250344283497 "$node_(131) setdest 334 204 18.0" 
$ns at 688.0805851490627 "$node_(132) setdest 898 10 16.0" 
$ns at 770.1448918830694 "$node_(132) setdest 1310 359 3.0" 
$ns at 808.6300536787985 "$node_(132) setdest 1441 473 14.0" 
$ns at 676.804141060697 "$node_(133) setdest 1733 406 9.0" 
$ns at 723.7442423431139 "$node_(133) setdest 446 476 17.0" 
$ns at 808.9587302791546 "$node_(133) setdest 2962 673 13.0" 
$ns at 681.7157247486338 "$node_(134) setdest 2136 430 15.0" 
$ns at 776.4949012291905 "$node_(134) setdest 1958 302 4.0" 
$ns at 828.4863831508264 "$node_(134) setdest 2729 137 7.0" 
$ns at 875.5231323994433 "$node_(134) setdest 2520 214 10.0" 
$ns at 688.3665579551357 "$node_(135) setdest 2505 54 8.0" 
$ns at 722.259983766785 "$node_(135) setdest 1817 573 15.0" 
$ns at 828.4299307688467 "$node_(135) setdest 1392 190 14.0" 
$ns at 683.6859256322424 "$node_(136) setdest 2805 720 4.0" 
$ns at 723.8431602378527 "$node_(136) setdest 2773 995 13.0" 
$ns at 755.0550624526767 "$node_(136) setdest 394 697 19.0" 
$ns at 725.9436172331259 "$node_(137) setdest 2109 581 9.0" 
$ns at 825.927001422094 "$node_(137) setdest 2966 485 18.0" 
$ns at 662.9475756980049 "$node_(138) setdest 671 514 11.0" 
$ns at 733.6184212990992 "$node_(138) setdest 487 985 14.0" 
$ns at 772.3172563232101 "$node_(138) setdest 2160 512 6.0" 
$ns at 810.091663637123 "$node_(138) setdest 2397 555 7.0" 
$ns at 864.9092497120021 "$node_(138) setdest 1844 421 18.0" 
$ns at 800.912692480061 "$node_(139) setdest 1611 285 2.0" 
$ns at 831.618030801539 "$node_(139) setdest 2187 186 15.0" 
$ns at 760.2975427617005 "$node_(140) setdest 1626 694 17.0" 
$ns at 801.8576836442709 "$node_(140) setdest 2103 350 9.0" 
$ns at 879.4560481118267 "$node_(140) setdest 147 376 3.0" 
$ns at 726.5898725710289 "$node_(141) setdest 2246 974 14.0" 
$ns at 795.8811259316732 "$node_(141) setdest 2372 668 4.0" 
$ns at 852.4269917771211 "$node_(141) setdest 2841 168 1.0" 
$ns at 887.8559189689862 "$node_(141) setdest 1106 597 12.0" 
$ns at 744.846103904737 "$node_(142) setdest 2265 536 11.0" 
$ns at 784.7068589751055 "$node_(142) setdest 2019 937 15.0" 
$ns at 819.9672220264371 "$node_(142) setdest 790 518 8.0" 
$ns at 868.7066305929986 "$node_(142) setdest 893 260 1.0" 
$ns at 761.9919201562645 "$node_(143) setdest 2500 855 2.0" 
$ns at 804.3727990122921 "$node_(143) setdest 1864 84 20.0" 
$ns at 879.4016503988178 "$node_(143) setdest 1522 556 18.0" 
$ns at 734.178554905143 "$node_(144) setdest 1878 91 18.0" 
$ns at 770.8772424819928 "$node_(144) setdest 1428 979 19.0" 
$ns at 699.7469318008356 "$node_(145) setdest 779 784 18.0" 
$ns at 756.4714525377706 "$node_(145) setdest 180 699 8.0" 
$ns at 861.0954919747987 "$node_(145) setdest 77 243 17.0" 
$ns at 732.5354444331522 "$node_(146) setdest 1743 925 16.0" 
$ns at 835.2499925715751 "$node_(146) setdest 2647 899 10.0" 
$ns at 709.8438490914692 "$node_(147) setdest 2978 110 10.0" 
$ns at 797.8283759831315 "$node_(147) setdest 1806 477 10.0" 
$ns at 702.3608201392948 "$node_(148) setdest 573 717 14.0" 
$ns at 837.1887200116632 "$node_(148) setdest 2424 465 6.0" 
$ns at 877.7103464401857 "$node_(148) setdest 29 52 19.0" 
$ns at 677.3466050754076 "$node_(149) setdest 1656 799 13.0" 
$ns at 753.1361428806155 "$node_(149) setdest 837 188 14.0" 
$ns at 884.2605448486306 "$node_(149) setdest 2191 422 14.0" 


#Set a TCP connection between node_(28) and node_(9)
set tcp_(0) [new Agent/TCP/Newreno]
$tcp_(0) set class_ 2
set sink_(0) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(0)
$ns attach-agent $node_(9) $sink_(0)
$ns connect $tcp_(0) $sink_(0)
set ftp_(0) [new Application/FTP]
$ftp_(0) attach-agent $tcp_(0)
$ns at 0.2 "$ftp_(0) start"
$ns at 180.0 "$ftp_(0) stop"

#Set a TCP connection between node_(14) and node_(33)
set tcp_(1) [new Agent/TCP/Newreno]
$tcp_(1) set class_ 2
set sink_(1) [new Agent/TCPSink]
$ns attach-agent $node_(14) $tcp_(1)
$ns attach-agent $node_(33) $sink_(1)
$ns connect $tcp_(1) $sink_(1)
set ftp_(1) [new Application/FTP]
$ftp_(1) attach-agent $tcp_(1)
$ns at 180.2 "$ftp_(1) start"
$ns at 360.0 "$ftp_(1) stop"

#Set a TCP connection between node_(35) and node_(41)
set tcp_(2) [new Agent/TCP/Newreno]
$tcp_(2) set class_ 2
set sink_(2) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(2)
$ns attach-agent $node_(41) $sink_(2)
$ns connect $tcp_(2) $sink_(2)
set ftp_(2) [new Application/FTP]
$ftp_(2) attach-agent $tcp_(2)
$ns at 360.2 "$ftp_(2) start"
$ns at 540.0 "$ftp_(2) stop"

#Set a TCP connection between node_(31) and node_(28)
set tcp_(3) [new Agent/TCP/Newreno]
$tcp_(3) set class_ 2
set sink_(3) [new Agent/TCPSink]
$ns attach-agent $node_(31) $tcp_(3)
$ns attach-agent $node_(28) $sink_(3)
$ns connect $tcp_(3) $sink_(3)
set ftp_(3) [new Application/FTP]
$ftp_(3) attach-agent $tcp_(3)
$ns at 540.2 "$ftp_(3) start"
$ns at 720.0 "$ftp_(3) stop"

#Set a TCP connection between node_(38) and node_(42)
set tcp_(4) [new Agent/TCP/Newreno]
$tcp_(4) set class_ 2
set sink_(4) [new Agent/TCPSink]
$ns attach-agent $node_(38) $tcp_(4)
$ns attach-agent $node_(42) $sink_(4)
$ns connect $tcp_(4) $sink_(4)
set ftp_(4) [new Application/FTP]
$ftp_(4) attach-agent $tcp_(4)
$ns at 720.2 "$ftp_(4) start"
$ns at 900.0 "$ftp_(4) stop"

#Set a TCP connection between node_(47) and node_(22)
set tcp_(5) [new Agent/TCP/Newreno]
$tcp_(5) set class_ 2
set sink_(5) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(5)
$ns attach-agent $node_(22) $sink_(5)
$ns connect $tcp_(5) $sink_(5)
set ftp_(5) [new Application/FTP]
$ftp_(5) attach-agent $tcp_(5)
$ns at 0.2 "$ftp_(5) start"
$ns at 180.0 "$ftp_(5) stop"

#Set a TCP connection between node_(36) and node_(40)
set tcp_(6) [new Agent/TCP/Newreno]
$tcp_(6) set class_ 2
set sink_(6) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(6)
$ns attach-agent $node_(40) $sink_(6)
$ns connect $tcp_(6) $sink_(6)
set ftp_(6) [new Application/FTP]
$ftp_(6) attach-agent $tcp_(6)
$ns at 180.2 "$ftp_(6) start"
$ns at 360.0 "$ftp_(6) stop"

#Set a TCP connection between node_(10) and node_(30)
set tcp_(7) [new Agent/TCP/Newreno]
$tcp_(7) set class_ 2
set sink_(7) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(7)
$ns attach-agent $node_(30) $sink_(7)
$ns connect $tcp_(7) $sink_(7)
set ftp_(7) [new Application/FTP]
$ftp_(7) attach-agent $tcp_(7)
$ns at 360.2 "$ftp_(7) start"
$ns at 540.0 "$ftp_(7) stop"

#Set a TCP connection between node_(0) and node_(33)
set tcp_(8) [new Agent/TCP/Newreno]
$tcp_(8) set class_ 2
set sink_(8) [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp_(8)
$ns attach-agent $node_(33) $sink_(8)
$ns connect $tcp_(8) $sink_(8)
set ftp_(8) [new Application/FTP]
$ftp_(8) attach-agent $tcp_(8)
$ns at 540.2 "$ftp_(8) start"
$ns at 720.0 "$ftp_(8) stop"

#Set a TCP connection between node_(46) and node_(8)
set tcp_(9) [new Agent/TCP/Newreno]
$tcp_(9) set class_ 2
set sink_(9) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(9)
$ns attach-agent $node_(8) $sink_(9)
$ns connect $tcp_(9) $sink_(9)
set ftp_(9) [new Application/FTP]
$ftp_(9) attach-agent $tcp_(9)
$ns at 720.2 "$ftp_(9) start"
$ns at 900.0 "$ftp_(9) stop"

#Set a TCP connection between node_(6) and node_(30)
set tcp_(10) [new Agent/TCP/Newreno]
$tcp_(10) set class_ 2
set sink_(10) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(10)
$ns attach-agent $node_(30) $sink_(10)
$ns connect $tcp_(10) $sink_(10)
set ftp_(10) [new Application/FTP]
$ftp_(10) attach-agent $tcp_(10)
$ns at 0.2 "$ftp_(10) start"
$ns at 180.0 "$ftp_(10) stop"

#Set a TCP connection between node_(14) and node_(35)
set tcp_(11) [new Agent/TCP/Newreno]
$tcp_(11) set class_ 2
set sink_(11) [new Agent/TCPSink]
$ns attach-agent $node_(14) $tcp_(11)
$ns attach-agent $node_(35) $sink_(11)
$ns connect $tcp_(11) $sink_(11)
set ftp_(11) [new Application/FTP]
$ftp_(11) attach-agent $tcp_(11)
$ns at 180.2 "$ftp_(11) start"
$ns at 360.0 "$ftp_(11) stop"

#Set a TCP connection between node_(38) and node_(22)
set tcp_(12) [new Agent/TCP/Newreno]
$tcp_(12) set class_ 2
set sink_(12) [new Agent/TCPSink]
$ns attach-agent $node_(38) $tcp_(12)
$ns attach-agent $node_(22) $sink_(12)
$ns connect $tcp_(12) $sink_(12)
set ftp_(12) [new Application/FTP]
$ftp_(12) attach-agent $tcp_(12)
$ns at 360.2 "$ftp_(12) start"
$ns at 540.0 "$ftp_(12) stop"

#Set a TCP connection between node_(49) and node_(42)
set tcp_(13) [new Agent/TCP/Newreno]
$tcp_(13) set class_ 2
set sink_(13) [new Agent/TCPSink]
$ns attach-agent $node_(49) $tcp_(13)
$ns attach-agent $node_(42) $sink_(13)
$ns connect $tcp_(13) $sink_(13)
set ftp_(13) [new Application/FTP]
$ftp_(13) attach-agent $tcp_(13)
$ns at 540.2 "$ftp_(13) start"
$ns at 720.0 "$ftp_(13) stop"

#Set a TCP connection between node_(33) and node_(45)
set tcp_(14) [new Agent/TCP/Newreno]
$tcp_(14) set class_ 2
set sink_(14) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(14)
$ns attach-agent $node_(45) $sink_(14)
$ns connect $tcp_(14) $sink_(14)
set ftp_(14) [new Application/FTP]
$ftp_(14) attach-agent $tcp_(14)
$ns at 720.2 "$ftp_(14) start"
$ns at 900.0 "$ftp_(14) stop"

#Set a TCP connection between node_(1) and node_(23)
set tcp_(15) [new Agent/TCP/Newreno]
$tcp_(15) set class_ 2
set sink_(15) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(15)
$ns attach-agent $node_(23) $sink_(15)
$ns connect $tcp_(15) $sink_(15)
set ftp_(15) [new Application/FTP]
$ftp_(15) attach-agent $tcp_(15)
$ns at 0.2 "$ftp_(15) start"
$ns at 180.0 "$ftp_(15) stop"

#Set a TCP connection between node_(20) and node_(44)
set tcp_(16) [new Agent/TCP/Newreno]
$tcp_(16) set class_ 2
set sink_(16) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(16)
$ns attach-agent $node_(44) $sink_(16)
$ns connect $tcp_(16) $sink_(16)
set ftp_(16) [new Application/FTP]
$ftp_(16) attach-agent $tcp_(16)
$ns at 180.2 "$ftp_(16) start"
$ns at 360.0 "$ftp_(16) stop"

#Set a TCP connection between node_(23) and node_(16)
set tcp_(17) [new Agent/TCP/Newreno]
$tcp_(17) set class_ 2
set sink_(17) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(17)
$ns attach-agent $node_(16) $sink_(17)
$ns connect $tcp_(17) $sink_(17)
set ftp_(17) [new Application/FTP]
$ftp_(17) attach-agent $tcp_(17)
$ns at 360.2 "$ftp_(17) start"
$ns at 540.0 "$ftp_(17) stop"

#Set a TCP connection between node_(26) and node_(33)
set tcp_(18) [new Agent/TCP/Newreno]
$tcp_(18) set class_ 2
set sink_(18) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(18)
$ns attach-agent $node_(33) $sink_(18)
$ns connect $tcp_(18) $sink_(18)
set ftp_(18) [new Application/FTP]
$ftp_(18) attach-agent $tcp_(18)
$ns at 540.2 "$ftp_(18) start"
$ns at 720.0 "$ftp_(18) stop"

#Set a TCP connection between node_(16) and node_(17)
set tcp_(19) [new Agent/TCP/Newreno]
$tcp_(19) set class_ 2
set sink_(19) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(19)
$ns attach-agent $node_(17) $sink_(19)
$ns connect $tcp_(19) $sink_(19)
set ftp_(19) [new Application/FTP]
$ftp_(19) attach-agent $tcp_(19)
$ns at 720.2 "$ftp_(19) start"
$ns at 900.0 "$ftp_(19) stop"

#Set a TCP connection between node_(49) and node_(41)
set tcp_(20) [new Agent/TCP/Newreno]
$tcp_(20) set class_ 2
set sink_(20) [new Agent/TCPSink]
$ns attach-agent $node_(49) $tcp_(20)
$ns attach-agent $node_(41) $sink_(20)
$ns connect $tcp_(20) $sink_(20)
set ftp_(20) [new Application/FTP]
$ftp_(20) attach-agent $tcp_(20)
$ns at 0.2 "$ftp_(20) start"
$ns at 180.0 "$ftp_(20) stop"

#Set a TCP connection between node_(49) and node_(26)
set tcp_(21) [new Agent/TCP/Newreno]
$tcp_(21) set class_ 2
set sink_(21) [new Agent/TCPSink]
$ns attach-agent $node_(49) $tcp_(21)
$ns attach-agent $node_(26) $sink_(21)
$ns connect $tcp_(21) $sink_(21)
set ftp_(21) [new Application/FTP]
$ftp_(21) attach-agent $tcp_(21)
$ns at 180.2 "$ftp_(21) start"
$ns at 360.0 "$ftp_(21) stop"

#Set a TCP connection between node_(45) and node_(18)
set tcp_(22) [new Agent/TCP/Newreno]
$tcp_(22) set class_ 2
set sink_(22) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(22)
$ns attach-agent $node_(18) $sink_(22)
$ns connect $tcp_(22) $sink_(22)
set ftp_(22) [new Application/FTP]
$ftp_(22) attach-agent $tcp_(22)
$ns at 360.2 "$ftp_(22) start"
$ns at 540.0 "$ftp_(22) stop"

#Set a TCP connection between node_(27) and node_(49)
set tcp_(23) [new Agent/TCP/Newreno]
$tcp_(23) set class_ 2
set sink_(23) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(23)
$ns attach-agent $node_(49) $sink_(23)
$ns connect $tcp_(23) $sink_(23)
set ftp_(23) [new Application/FTP]
$ftp_(23) attach-agent $tcp_(23)
$ns at 540.2 "$ftp_(23) start"
$ns at 720.0 "$ftp_(23) stop"

#Set a TCP connection between node_(43) and node_(27)
set tcp_(24) [new Agent/TCP/Newreno]
$tcp_(24) set class_ 2
set sink_(24) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(24)
$ns attach-agent $node_(27) $sink_(24)
$ns connect $tcp_(24) $sink_(24)
set ftp_(24) [new Application/FTP]
$ftp_(24) attach-agent $tcp_(24)
$ns at 720.2 "$ftp_(24) start"
$ns at 900.0 "$ftp_(24) stop"

#Set a TCP connection between node_(35) and node_(1)
set tcp_(25) [new Agent/TCP/Newreno]
$tcp_(25) set class_ 2
set sink_(25) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(25)
$ns attach-agent $node_(1) $sink_(25)
$ns connect $tcp_(25) $sink_(25)
set ftp_(25) [new Application/FTP]
$ftp_(25) attach-agent $tcp_(25)
$ns at 0.2 "$ftp_(25) start"
$ns at 180.0 "$ftp_(25) stop"

#Set a TCP connection between node_(21) and node_(36)
set tcp_(26) [new Agent/TCP/Newreno]
$tcp_(26) set class_ 2
set sink_(26) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(26)
$ns attach-agent $node_(36) $sink_(26)
$ns connect $tcp_(26) $sink_(26)
set ftp_(26) [new Application/FTP]
$ftp_(26) attach-agent $tcp_(26)
$ns at 180.2 "$ftp_(26) start"
$ns at 360.0 "$ftp_(26) stop"

#Set a TCP connection between node_(15) and node_(20)
set tcp_(27) [new Agent/TCP/Newreno]
$tcp_(27) set class_ 2
set sink_(27) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(27)
$ns attach-agent $node_(20) $sink_(27)
$ns connect $tcp_(27) $sink_(27)
set ftp_(27) [new Application/FTP]
$ftp_(27) attach-agent $tcp_(27)
$ns at 360.2 "$ftp_(27) start"
$ns at 540.0 "$ftp_(27) stop"

#Set a TCP connection between node_(45) and node_(37)
set tcp_(28) [new Agent/TCP/Newreno]
$tcp_(28) set class_ 2
set sink_(28) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(28)
$ns attach-agent $node_(37) $sink_(28)
$ns connect $tcp_(28) $sink_(28)
set ftp_(28) [new Application/FTP]
$ftp_(28) attach-agent $tcp_(28)
$ns at 540.2 "$ftp_(28) start"
$ns at 720.0 "$ftp_(28) stop"

#Set a TCP connection between node_(9) and node_(31)
set tcp_(29) [new Agent/TCP/Newreno]
$tcp_(29) set class_ 2
set sink_(29) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(29)
$ns attach-agent $node_(31) $sink_(29)
$ns connect $tcp_(29) $sink_(29)
set ftp_(29) [new Application/FTP]
$ftp_(29) attach-agent $tcp_(29)
$ns at 720.2 "$ftp_(29) start"
$ns at 900.0 "$ftp_(29) stop"

#Set a TCP connection between node_(44) and node_(16)
set tcp_(30) [new Agent/TCP/Newreno]
$tcp_(30) set class_ 2
set sink_(30) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(30)
$ns attach-agent $node_(16) $sink_(30)
$ns connect $tcp_(30) $sink_(30)
set ftp_(30) [new Application/FTP]
$ftp_(30) attach-agent $tcp_(30)
$ns at 0.2 "$ftp_(30) start"
$ns at 180.0 "$ftp_(30) stop"

#Set a TCP connection between node_(36) and node_(9)
set tcp_(31) [new Agent/TCP/Newreno]
$tcp_(31) set class_ 2
set sink_(31) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(31)
$ns attach-agent $node_(9) $sink_(31)
$ns connect $tcp_(31) $sink_(31)
set ftp_(31) [new Application/FTP]
$ftp_(31) attach-agent $tcp_(31)
$ns at 180.2 "$ftp_(31) start"
$ns at 360.0 "$ftp_(31) stop"

#Set a TCP connection between node_(21) and node_(8)
set tcp_(32) [new Agent/TCP/Newreno]
$tcp_(32) set class_ 2
set sink_(32) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(32)
$ns attach-agent $node_(8) $sink_(32)
$ns connect $tcp_(32) $sink_(32)
set ftp_(32) [new Application/FTP]
$ftp_(32) attach-agent $tcp_(32)
$ns at 360.2 "$ftp_(32) start"
$ns at 540.0 "$ftp_(32) stop"

#Set a TCP connection between node_(13) and node_(37)
set tcp_(33) [new Agent/TCP/Newreno]
$tcp_(33) set class_ 2
set sink_(33) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(33)
$ns attach-agent $node_(37) $sink_(33)
$ns connect $tcp_(33) $sink_(33)
set ftp_(33) [new Application/FTP]
$ftp_(33) attach-agent $tcp_(33)
$ns at 540.2 "$ftp_(33) start"
$ns at 720.0 "$ftp_(33) stop"

#Set a TCP connection between node_(47) and node_(32)
set tcp_(34) [new Agent/TCP/Newreno]
$tcp_(34) set class_ 2
set sink_(34) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(34)
$ns attach-agent $node_(32) $sink_(34)
$ns connect $tcp_(34) $sink_(34)
set ftp_(34) [new Application/FTP]
$ftp_(34) attach-agent $tcp_(34)
$ns at 720.2 "$ftp_(34) start"
$ns at 900.0 "$ftp_(34) stop"

#Set a TCP connection between node_(2) and node_(48)
set tcp_(35) [new Agent/TCP/Newreno]
$tcp_(35) set class_ 2
set sink_(35) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(35)
$ns attach-agent $node_(48) $sink_(35)
$ns connect $tcp_(35) $sink_(35)
set ftp_(35) [new Application/FTP]
$ftp_(35) attach-agent $tcp_(35)
$ns at 0.2 "$ftp_(35) start"
$ns at 180.0 "$ftp_(35) stop"

#Set a TCP connection between node_(22) and node_(28)
set tcp_(36) [new Agent/TCP/Newreno]
$tcp_(36) set class_ 2
set sink_(36) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(36)
$ns attach-agent $node_(28) $sink_(36)
$ns connect $tcp_(36) $sink_(36)
set ftp_(36) [new Application/FTP]
$ftp_(36) attach-agent $tcp_(36)
$ns at 180.2 "$ftp_(36) start"
$ns at 360.0 "$ftp_(36) stop"

#Set a TCP connection between node_(11) and node_(27)
set tcp_(37) [new Agent/TCP/Newreno]
$tcp_(37) set class_ 2
set sink_(37) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(37)
$ns attach-agent $node_(27) $sink_(37)
$ns connect $tcp_(37) $sink_(37)
set ftp_(37) [new Application/FTP]
$ftp_(37) attach-agent $tcp_(37)
$ns at 360.2 "$ftp_(37) start"
$ns at 540.0 "$ftp_(37) stop"

#Set a TCP connection between node_(7) and node_(18)
set tcp_(38) [new Agent/TCP/Newreno]
$tcp_(38) set class_ 2
set sink_(38) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(38)
$ns attach-agent $node_(18) $sink_(38)
$ns connect $tcp_(38) $sink_(38)
set ftp_(38) [new Application/FTP]
$ftp_(38) attach-agent $tcp_(38)
$ns at 540.2 "$ftp_(38) start"
$ns at 720.0 "$ftp_(38) stop"

#Set a TCP connection between node_(2) and node_(39)
set tcp_(39) [new Agent/TCP/Newreno]
$tcp_(39) set class_ 2
set sink_(39) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(39)
$ns attach-agent $node_(39) $sink_(39)
$ns connect $tcp_(39) $sink_(39)
set ftp_(39) [new Application/FTP]
$ftp_(39) attach-agent $tcp_(39)
$ns at 720.2 "$ftp_(39) start"
$ns at 900.0 "$ftp_(39) stop"

#Set a TCP connection between node_(15) and node_(24)
set tcp_(40) [new Agent/TCP/Newreno]
$tcp_(40) set class_ 2
set sink_(40) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(40)
$ns attach-agent $node_(24) $sink_(40)
$ns connect $tcp_(40) $sink_(40)
set ftp_(40) [new Application/FTP]
$ftp_(40) attach-agent $tcp_(40)
$ns at 0.2 "$ftp_(40) start"
$ns at 180.0 "$ftp_(40) stop"

#Set a TCP connection between node_(1) and node_(18)
set tcp_(41) [new Agent/TCP/Newreno]
$tcp_(41) set class_ 2
set sink_(41) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(41)
$ns attach-agent $node_(18) $sink_(41)
$ns connect $tcp_(41) $sink_(41)
set ftp_(41) [new Application/FTP]
$ftp_(41) attach-agent $tcp_(41)
$ns at 180.2 "$ftp_(41) start"
$ns at 360.0 "$ftp_(41) stop"

#Set a TCP connection between node_(18) and node_(4)
set tcp_(42) [new Agent/TCP/Newreno]
$tcp_(42) set class_ 2
set sink_(42) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(42)
$ns attach-agent $node_(4) $sink_(42)
$ns connect $tcp_(42) $sink_(42)
set ftp_(42) [new Application/FTP]
$ftp_(42) attach-agent $tcp_(42)
$ns at 360.2 "$ftp_(42) start"
$ns at 540.0 "$ftp_(42) stop"

#Set a TCP connection between node_(18) and node_(23)
set tcp_(43) [new Agent/TCP/Newreno]
$tcp_(43) set class_ 2
set sink_(43) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(43)
$ns attach-agent $node_(23) $sink_(43)
$ns connect $tcp_(43) $sink_(43)
set ftp_(43) [new Application/FTP]
$ftp_(43) attach-agent $tcp_(43)
$ns at 540.2 "$ftp_(43) start"
$ns at 720.0 "$ftp_(43) stop"

#Set a TCP connection between node_(42) and node_(36)
set tcp_(44) [new Agent/TCP/Newreno]
$tcp_(44) set class_ 2
set sink_(44) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(44)
$ns attach-agent $node_(36) $sink_(44)
$ns connect $tcp_(44) $sink_(44)
set ftp_(44) [new Application/FTP]
$ftp_(44) attach-agent $tcp_(44)
$ns at 720.2 "$ftp_(44) start"
$ns at 900.0 "$ftp_(44) stop"

#Set a TCP connection between node_(2) and node_(35)
set tcp_(45) [new Agent/TCP/Newreno]
$tcp_(45) set class_ 2
set sink_(45) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(45)
$ns attach-agent $node_(35) $sink_(45)
$ns connect $tcp_(45) $sink_(45)
set ftp_(45) [new Application/FTP]
$ftp_(45) attach-agent $tcp_(45)
$ns at 0.2 "$ftp_(45) start"
$ns at 180.0 "$ftp_(45) stop"

#Set a TCP connection between node_(6) and node_(9)
set tcp_(46) [new Agent/TCP/Newreno]
$tcp_(46) set class_ 2
set sink_(46) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(46)
$ns attach-agent $node_(9) $sink_(46)
$ns connect $tcp_(46) $sink_(46)
set ftp_(46) [new Application/FTP]
$ftp_(46) attach-agent $tcp_(46)
$ns at 180.2 "$ftp_(46) start"
$ns at 360.0 "$ftp_(46) stop"

#Set a TCP connection between node_(35) and node_(0)
set tcp_(47) [new Agent/TCP/Newreno]
$tcp_(47) set class_ 2
set sink_(47) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(47)
$ns attach-agent $node_(0) $sink_(47)
$ns connect $tcp_(47) $sink_(47)
set ftp_(47) [new Application/FTP]
$ftp_(47) attach-agent $tcp_(47)
$ns at 360.2 "$ftp_(47) start"
$ns at 540.0 "$ftp_(47) stop"

#Set a TCP connection between node_(27) and node_(38)
set tcp_(48) [new Agent/TCP/Newreno]
$tcp_(48) set class_ 2
set sink_(48) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(48)
$ns attach-agent $node_(38) $sink_(48)
$ns connect $tcp_(48) $sink_(48)
set ftp_(48) [new Application/FTP]
$ftp_(48) attach-agent $tcp_(48)
$ns at 540.2 "$ftp_(48) start"
$ns at 720.0 "$ftp_(48) stop"

#Set a TCP connection between node_(35) and node_(18)
set tcp_(49) [new Agent/TCP/Newreno]
$tcp_(49) set class_ 2
set sink_(49) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(49)
$ns attach-agent $node_(18) $sink_(49)
$ns connect $tcp_(49) $sink_(49)
set ftp_(49) [new Application/FTP]
$ftp_(49) attach-agent $tcp_(49)
$ns at 720.2 "$ftp_(49) start"
$ns at 900.0 "$ftp_(49) stop"

#Set a TCP connection between node_(38) and node_(43)
set tcp_(50) [new Agent/TCP/Newreno]
$tcp_(50) set class_ 2
set sink_(50) [new Agent/TCPSink]
$ns attach-agent $node_(38) $tcp_(50)
$ns attach-agent $node_(43) $sink_(50)
$ns connect $tcp_(50) $sink_(50)
set ftp_(50) [new Application/FTP]
$ftp_(50) attach-agent $tcp_(50)
$ns at 0.2 "$ftp_(50) start"
$ns at 180.0 "$ftp_(50) stop"

#Set a TCP connection between node_(23) and node_(29)
set tcp_(51) [new Agent/TCP/Newreno]
$tcp_(51) set class_ 2
set sink_(51) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(51)
$ns attach-agent $node_(29) $sink_(51)
$ns connect $tcp_(51) $sink_(51)
set ftp_(51) [new Application/FTP]
$ftp_(51) attach-agent $tcp_(51)
$ns at 180.2 "$ftp_(51) start"
$ns at 360.0 "$ftp_(51) stop"

#Set a TCP connection between node_(9) and node_(0)
set tcp_(52) [new Agent/TCP/Newreno]
$tcp_(52) set class_ 2
set sink_(52) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(52)
$ns attach-agent $node_(0) $sink_(52)
$ns connect $tcp_(52) $sink_(52)
set ftp_(52) [new Application/FTP]
$ftp_(52) attach-agent $tcp_(52)
$ns at 360.2 "$ftp_(52) start"
$ns at 540.0 "$ftp_(52) stop"

#Set a TCP connection between node_(13) and node_(29)
set tcp_(53) [new Agent/TCP/Newreno]
$tcp_(53) set class_ 2
set sink_(53) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(53)
$ns attach-agent $node_(29) $sink_(53)
$ns connect $tcp_(53) $sink_(53)
set ftp_(53) [new Application/FTP]
$ftp_(53) attach-agent $tcp_(53)
$ns at 540.2 "$ftp_(53) start"
$ns at 720.0 "$ftp_(53) stop"

#Set a TCP connection between node_(10) and node_(44)
set tcp_(54) [new Agent/TCP/Newreno]
$tcp_(54) set class_ 2
set sink_(54) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(54)
$ns attach-agent $node_(44) $sink_(54)
$ns connect $tcp_(54) $sink_(54)
set ftp_(54) [new Application/FTP]
$ftp_(54) attach-agent $tcp_(54)
$ns at 720.2 "$ftp_(54) start"
$ns at 900.0 "$ftp_(54) stop"

#Set a TCP connection between node_(9) and node_(26)
set tcp_(55) [new Agent/TCP/Newreno]
$tcp_(55) set class_ 2
set sink_(55) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(55)
$ns attach-agent $node_(26) $sink_(55)
$ns connect $tcp_(55) $sink_(55)
set ftp_(55) [new Application/FTP]
$ftp_(55) attach-agent $tcp_(55)
$ns at 0.2 "$ftp_(55) start"
$ns at 180.0 "$ftp_(55) stop"

#Set a TCP connection between node_(2) and node_(10)
set tcp_(56) [new Agent/TCP/Newreno]
$tcp_(56) set class_ 2
set sink_(56) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(56)
$ns attach-agent $node_(10) $sink_(56)
$ns connect $tcp_(56) $sink_(56)
set ftp_(56) [new Application/FTP]
$ftp_(56) attach-agent $tcp_(56)
$ns at 180.2 "$ftp_(56) start"
$ns at 360.0 "$ftp_(56) stop"

#Set a TCP connection between node_(41) and node_(6)
set tcp_(57) [new Agent/TCP/Newreno]
$tcp_(57) set class_ 2
set sink_(57) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(57)
$ns attach-agent $node_(6) $sink_(57)
$ns connect $tcp_(57) $sink_(57)
set ftp_(57) [new Application/FTP]
$ftp_(57) attach-agent $tcp_(57)
$ns at 360.2 "$ftp_(57) start"
$ns at 540.0 "$ftp_(57) stop"

#Set a TCP connection between node_(40) and node_(17)
set tcp_(58) [new Agent/TCP/Newreno]
$tcp_(58) set class_ 2
set sink_(58) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(58)
$ns attach-agent $node_(17) $sink_(58)
$ns connect $tcp_(58) $sink_(58)
set ftp_(58) [new Application/FTP]
$ftp_(58) attach-agent $tcp_(58)
$ns at 540.2 "$ftp_(58) start"
$ns at 720.0 "$ftp_(58) stop"

#Set a TCP connection between node_(15) and node_(9)
set tcp_(59) [new Agent/TCP/Newreno]
$tcp_(59) set class_ 2
set sink_(59) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(59)
$ns attach-agent $node_(9) $sink_(59)
$ns connect $tcp_(59) $sink_(59)
set ftp_(59) [new Application/FTP]
$ftp_(59) attach-agent $tcp_(59)
$ns at 720.2 "$ftp_(59) start"
$ns at 900.0 "$ftp_(59) stop"

#Set a TCP connection between node_(47) and node_(30)
set tcp_(60) [new Agent/TCP/Newreno]
$tcp_(60) set class_ 2
set sink_(60) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(60)
$ns attach-agent $node_(30) $sink_(60)
$ns connect $tcp_(60) $sink_(60)
set ftp_(60) [new Application/FTP]
$ftp_(60) attach-agent $tcp_(60)
$ns at 0.2 "$ftp_(60) start"
$ns at 180.0 "$ftp_(60) stop"

#Set a TCP connection between node_(40) and node_(15)
set tcp_(61) [new Agent/TCP/Newreno]
$tcp_(61) set class_ 2
set sink_(61) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(61)
$ns attach-agent $node_(15) $sink_(61)
$ns connect $tcp_(61) $sink_(61)
set ftp_(61) [new Application/FTP]
$ftp_(61) attach-agent $tcp_(61)
$ns at 180.2 "$ftp_(61) start"
$ns at 360.0 "$ftp_(61) stop"

#Set a TCP connection between node_(42) and node_(40)
set tcp_(62) [new Agent/TCP/Newreno]
$tcp_(62) set class_ 2
set sink_(62) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(62)
$ns attach-agent $node_(40) $sink_(62)
$ns connect $tcp_(62) $sink_(62)
set ftp_(62) [new Application/FTP]
$ftp_(62) attach-agent $tcp_(62)
$ns at 360.2 "$ftp_(62) start"
$ns at 540.0 "$ftp_(62) stop"

#Set a TCP connection between node_(45) and node_(5)
set tcp_(63) [new Agent/TCP/Newreno]
$tcp_(63) set class_ 2
set sink_(63) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(63)
$ns attach-agent $node_(5) $sink_(63)
$ns connect $tcp_(63) $sink_(63)
set ftp_(63) [new Application/FTP]
$ftp_(63) attach-agent $tcp_(63)
$ns at 540.2 "$ftp_(63) start"
$ns at 720.0 "$ftp_(63) stop"

#Set a TCP connection between node_(43) and node_(41)
set tcp_(64) [new Agent/TCP/Newreno]
$tcp_(64) set class_ 2
set sink_(64) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(64)
$ns attach-agent $node_(41) $sink_(64)
$ns connect $tcp_(64) $sink_(64)
set ftp_(64) [new Application/FTP]
$ftp_(64) attach-agent $tcp_(64)
$ns at 720.2 "$ftp_(64) start"
$ns at 900.0 "$ftp_(64) stop"

#Set a TCP connection between node_(26) and node_(2)
set tcp_(65) [new Agent/TCP/Newreno]
$tcp_(65) set class_ 2
set sink_(65) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(65)
$ns attach-agent $node_(2) $sink_(65)
$ns connect $tcp_(65) $sink_(65)
set ftp_(65) [new Application/FTP]
$ftp_(65) attach-agent $tcp_(65)
$ns at 0.2 "$ftp_(65) start"
$ns at 180.0 "$ftp_(65) stop"

#Set a TCP connection between node_(19) and node_(15)
set tcp_(66) [new Agent/TCP/Newreno]
$tcp_(66) set class_ 2
set sink_(66) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(66)
$ns attach-agent $node_(15) $sink_(66)
$ns connect $tcp_(66) $sink_(66)
set ftp_(66) [new Application/FTP]
$ftp_(66) attach-agent $tcp_(66)
$ns at 180.2 "$ftp_(66) start"
$ns at 360.0 "$ftp_(66) stop"

#Set a TCP connection between node_(49) and node_(22)
set tcp_(67) [new Agent/TCP/Newreno]
$tcp_(67) set class_ 2
set sink_(67) [new Agent/TCPSink]
$ns attach-agent $node_(49) $tcp_(67)
$ns attach-agent $node_(22) $sink_(67)
$ns connect $tcp_(67) $sink_(67)
set ftp_(67) [new Application/FTP]
$ftp_(67) attach-agent $tcp_(67)
$ns at 360.2 "$ftp_(67) start"
$ns at 540.0 "$ftp_(67) stop"

#Set a TCP connection between node_(19) and node_(16)
set tcp_(68) [new Agent/TCP/Newreno]
$tcp_(68) set class_ 2
set sink_(68) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(68)
$ns attach-agent $node_(16) $sink_(68)
$ns connect $tcp_(68) $sink_(68)
set ftp_(68) [new Application/FTP]
$ftp_(68) attach-agent $tcp_(68)
$ns at 540.2 "$ftp_(68) start"
$ns at 720.0 "$ftp_(68) stop"

#Set a TCP connection between node_(32) and node_(17)
set tcp_(69) [new Agent/TCP/Newreno]
$tcp_(69) set class_ 2
set sink_(69) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(69)
$ns attach-agent $node_(17) $sink_(69)
$ns connect $tcp_(69) $sink_(69)
set ftp_(69) [new Application/FTP]
$ftp_(69) attach-agent $tcp_(69)
$ns at 720.2 "$ftp_(69) start"
$ns at 900.0 "$ftp_(69) stop"

#Set a TCP connection between node_(44) and node_(35)
set tcp_(70) [new Agent/TCP/Newreno]
$tcp_(70) set class_ 2
set sink_(70) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(70)
$ns attach-agent $node_(35) $sink_(70)
$ns connect $tcp_(70) $sink_(70)
set ftp_(70) [new Application/FTP]
$ftp_(70) attach-agent $tcp_(70)
$ns at 0.2 "$ftp_(70) start"
$ns at 180.0 "$ftp_(70) stop"

#Set a TCP connection between node_(22) and node_(11)
set tcp_(71) [new Agent/TCP/Newreno]
$tcp_(71) set class_ 2
set sink_(71) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(71)
$ns attach-agent $node_(11) $sink_(71)
$ns connect $tcp_(71) $sink_(71)
set ftp_(71) [new Application/FTP]
$ftp_(71) attach-agent $tcp_(71)
$ns at 180.2 "$ftp_(71) start"
$ns at 360.0 "$ftp_(71) stop"

#Set a TCP connection between node_(48) and node_(16)
set tcp_(72) [new Agent/TCP/Newreno]
$tcp_(72) set class_ 2
set sink_(72) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(72)
$ns attach-agent $node_(16) $sink_(72)
$ns connect $tcp_(72) $sink_(72)
set ftp_(72) [new Application/FTP]
$ftp_(72) attach-agent $tcp_(72)
$ns at 360.2 "$ftp_(72) start"
$ns at 540.0 "$ftp_(72) stop"

#Set a TCP connection between node_(7) and node_(9)
set tcp_(73) [new Agent/TCP/Newreno]
$tcp_(73) set class_ 2
set sink_(73) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(73)
$ns attach-agent $node_(9) $sink_(73)
$ns connect $tcp_(73) $sink_(73)
set ftp_(73) [new Application/FTP]
$ftp_(73) attach-agent $tcp_(73)
$ns at 540.2 "$ftp_(73) start"
$ns at 720.0 "$ftp_(73) stop"

#Set a TCP connection between node_(14) and node_(39)
set tcp_(74) [new Agent/TCP/Newreno]
$tcp_(74) set class_ 2
set sink_(74) [new Agent/TCPSink]
$ns attach-agent $node_(14) $tcp_(74)
$ns attach-agent $node_(39) $sink_(74)
$ns connect $tcp_(74) $sink_(74)
set ftp_(74) [new Application/FTP]
$ftp_(74) attach-agent $tcp_(74)
$ns at 720.2 "$ftp_(74) start"
$ns at 900.0 "$ftp_(74) stop"

#Set a TCP connection between node_(1) and node_(25)
set tcp_(75) [new Agent/TCP/Newreno]
$tcp_(75) set class_ 2
set sink_(75) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(75)
$ns attach-agent $node_(25) $sink_(75)
$ns connect $tcp_(75) $sink_(75)
set ftp_(75) [new Application/FTP]
$ftp_(75) attach-agent $tcp_(75)
$ns at 0.2 "$ftp_(75) start"
$ns at 180.0 "$ftp_(75) stop"

#Set a TCP connection between node_(16) and node_(2)
set tcp_(76) [new Agent/TCP/Newreno]
$tcp_(76) set class_ 2
set sink_(76) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(76)
$ns attach-agent $node_(2) $sink_(76)
$ns connect $tcp_(76) $sink_(76)
set ftp_(76) [new Application/FTP]
$ftp_(76) attach-agent $tcp_(76)
$ns at 180.2 "$ftp_(76) start"
$ns at 360.0 "$ftp_(76) stop"

#Set a TCP connection between node_(19) and node_(6)
set tcp_(77) [new Agent/TCP/Newreno]
$tcp_(77) set class_ 2
set sink_(77) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(77)
$ns attach-agent $node_(6) $sink_(77)
$ns connect $tcp_(77) $sink_(77)
set ftp_(77) [new Application/FTP]
$ftp_(77) attach-agent $tcp_(77)
$ns at 360.2 "$ftp_(77) start"
$ns at 540.0 "$ftp_(77) stop"

#Set a TCP connection between node_(24) and node_(1)
set tcp_(78) [new Agent/TCP/Newreno]
$tcp_(78) set class_ 2
set sink_(78) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(78)
$ns attach-agent $node_(1) $sink_(78)
$ns connect $tcp_(78) $sink_(78)
set ftp_(78) [new Application/FTP]
$ftp_(78) attach-agent $tcp_(78)
$ns at 540.2 "$ftp_(78) start"
$ns at 720.0 "$ftp_(78) stop"

#Set a TCP connection between node_(36) and node_(9)
set tcp_(79) [new Agent/TCP/Newreno]
$tcp_(79) set class_ 2
set sink_(79) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(79)
$ns attach-agent $node_(9) $sink_(79)
$ns connect $tcp_(79) $sink_(79)
set ftp_(79) [new Application/FTP]
$ftp_(79) attach-agent $tcp_(79)
$ns at 720.2 "$ftp_(79) start"
$ns at 900.0 "$ftp_(79) stop"

#Set a TCP connection between node_(37) and node_(1)
set tcp_(80) [new Agent/TCP/Newreno]
$tcp_(80) set class_ 2
set sink_(80) [new Agent/TCPSink]
$ns attach-agent $node_(37) $tcp_(80)
$ns attach-agent $node_(1) $sink_(80)
$ns connect $tcp_(80) $sink_(80)
set ftp_(80) [new Application/FTP]
$ftp_(80) attach-agent $tcp_(80)
$ns at 0.2 "$ftp_(80) start"
$ns at 180.0 "$ftp_(80) stop"

#Set a TCP connection between node_(39) and node_(28)
set tcp_(81) [new Agent/TCP/Newreno]
$tcp_(81) set class_ 2
set sink_(81) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(81)
$ns attach-agent $node_(28) $sink_(81)
$ns connect $tcp_(81) $sink_(81)
set ftp_(81) [new Application/FTP]
$ftp_(81) attach-agent $tcp_(81)
$ns at 180.2 "$ftp_(81) start"
$ns at 360.0 "$ftp_(81) stop"

#Set a TCP connection between node_(16) and node_(28)
set tcp_(82) [new Agent/TCP/Newreno]
$tcp_(82) set class_ 2
set sink_(82) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(82)
$ns attach-agent $node_(28) $sink_(82)
$ns connect $tcp_(82) $sink_(82)
set ftp_(82) [new Application/FTP]
$ftp_(82) attach-agent $tcp_(82)
$ns at 360.2 "$ftp_(82) start"
$ns at 540.0 "$ftp_(82) stop"

#Set a TCP connection between node_(29) and node_(49)
set tcp_(83) [new Agent/TCP/Newreno]
$tcp_(83) set class_ 2
set sink_(83) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(83)
$ns attach-agent $node_(49) $sink_(83)
$ns connect $tcp_(83) $sink_(83)
set ftp_(83) [new Application/FTP]
$ftp_(83) attach-agent $tcp_(83)
$ns at 540.2 "$ftp_(83) start"
$ns at 720.0 "$ftp_(83) stop"

#Set a TCP connection between node_(22) and node_(36)
set tcp_(84) [new Agent/TCP/Newreno]
$tcp_(84) set class_ 2
set sink_(84) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(84)
$ns attach-agent $node_(36) $sink_(84)
$ns connect $tcp_(84) $sink_(84)
set ftp_(84) [new Application/FTP]
$ftp_(84) attach-agent $tcp_(84)
$ns at 720.2 "$ftp_(84) start"
$ns at 900.0 "$ftp_(84) stop"

#Set a TCP connection between node_(11) and node_(22)
set tcp_(85) [new Agent/TCP/Newreno]
$tcp_(85) set class_ 2
set sink_(85) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(85)
$ns attach-agent $node_(22) $sink_(85)
$ns connect $tcp_(85) $sink_(85)
set ftp_(85) [new Application/FTP]
$ftp_(85) attach-agent $tcp_(85)
$ns at 0.2 "$ftp_(85) start"
$ns at 180.0 "$ftp_(85) stop"

#Set a TCP connection between node_(0) and node_(17)
set tcp_(86) [new Agent/TCP/Newreno]
$tcp_(86) set class_ 2
set sink_(86) [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp_(86)
$ns attach-agent $node_(17) $sink_(86)
$ns connect $tcp_(86) $sink_(86)
set ftp_(86) [new Application/FTP]
$ftp_(86) attach-agent $tcp_(86)
$ns at 180.2 "$ftp_(86) start"
$ns at 360.0 "$ftp_(86) stop"

#Set a TCP connection between node_(19) and node_(45)
set tcp_(87) [new Agent/TCP/Newreno]
$tcp_(87) set class_ 2
set sink_(87) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(87)
$ns attach-agent $node_(45) $sink_(87)
$ns connect $tcp_(87) $sink_(87)
set ftp_(87) [new Application/FTP]
$ftp_(87) attach-agent $tcp_(87)
$ns at 360.2 "$ftp_(87) start"
$ns at 540.0 "$ftp_(87) stop"

#Set a TCP connection between node_(20) and node_(31)
set tcp_(88) [new Agent/TCP/Newreno]
$tcp_(88) set class_ 2
set sink_(88) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(88)
$ns attach-agent $node_(31) $sink_(88)
$ns connect $tcp_(88) $sink_(88)
set ftp_(88) [new Application/FTP]
$ftp_(88) attach-agent $tcp_(88)
$ns at 540.2 "$ftp_(88) start"
$ns at 720.0 "$ftp_(88) stop"

#Set a TCP connection between node_(46) and node_(20)
set tcp_(89) [new Agent/TCP/Newreno]
$tcp_(89) set class_ 2
set sink_(89) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(89)
$ns attach-agent $node_(20) $sink_(89)
$ns connect $tcp_(89) $sink_(89)
set ftp_(89) [new Application/FTP]
$ftp_(89) attach-agent $tcp_(89)
$ns at 720.2 "$ftp_(89) start"
$ns at 900.0 "$ftp_(89) stop"

#Set a TCP connection between node_(28) and node_(2)
set tcp_(90) [new Agent/TCP/Newreno]
$tcp_(90) set class_ 2
set sink_(90) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(90)
$ns attach-agent $node_(2) $sink_(90)
$ns connect $tcp_(90) $sink_(90)
set ftp_(90) [new Application/FTP]
$ftp_(90) attach-agent $tcp_(90)
$ns at 0.2 "$ftp_(90) start"
$ns at 180.0 "$ftp_(90) stop"

#Set a TCP connection between node_(10) and node_(17)
set tcp_(91) [new Agent/TCP/Newreno]
$tcp_(91) set class_ 2
set sink_(91) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(91)
$ns attach-agent $node_(17) $sink_(91)
$ns connect $tcp_(91) $sink_(91)
set ftp_(91) [new Application/FTP]
$ftp_(91) attach-agent $tcp_(91)
$ns at 180.2 "$ftp_(91) start"
$ns at 360.0 "$ftp_(91) stop"

#Set a TCP connection between node_(3) and node_(27)
set tcp_(92) [new Agent/TCP/Newreno]
$tcp_(92) set class_ 2
set sink_(92) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(92)
$ns attach-agent $node_(27) $sink_(92)
$ns connect $tcp_(92) $sink_(92)
set ftp_(92) [new Application/FTP]
$ftp_(92) attach-agent $tcp_(92)
$ns at 360.2 "$ftp_(92) start"
$ns at 540.0 "$ftp_(92) stop"

#Set a TCP connection between node_(47) and node_(11)
set tcp_(93) [new Agent/TCP/Newreno]
$tcp_(93) set class_ 2
set sink_(93) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(93)
$ns attach-agent $node_(11) $sink_(93)
$ns connect $tcp_(93) $sink_(93)
set ftp_(93) [new Application/FTP]
$ftp_(93) attach-agent $tcp_(93)
$ns at 540.2 "$ftp_(93) start"
$ns at 720.0 "$ftp_(93) stop"

#Set a TCP connection between node_(9) and node_(19)
set tcp_(94) [new Agent/TCP/Newreno]
$tcp_(94) set class_ 2
set sink_(94) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(94)
$ns attach-agent $node_(19) $sink_(94)
$ns connect $tcp_(94) $sink_(94)
set ftp_(94) [new Application/FTP]
$ftp_(94) attach-agent $tcp_(94)
$ns at 720.2 "$ftp_(94) start"
$ns at 900.0 "$ftp_(94) stop"

#Set a TCP connection between node_(42) and node_(17)
set tcp_(95) [new Agent/TCP/Newreno]
$tcp_(95) set class_ 2
set sink_(95) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(95)
$ns attach-agent $node_(17) $sink_(95)
$ns connect $tcp_(95) $sink_(95)
set ftp_(95) [new Application/FTP]
$ftp_(95) attach-agent $tcp_(95)
$ns at 0.2 "$ftp_(95) start"
$ns at 180.0 "$ftp_(95) stop"

#Set a TCP connection between node_(48) and node_(4)
set tcp_(96) [new Agent/TCP/Newreno]
$tcp_(96) set class_ 2
set sink_(96) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(96)
$ns attach-agent $node_(4) $sink_(96)
$ns connect $tcp_(96) $sink_(96)
set ftp_(96) [new Application/FTP]
$ftp_(96) attach-agent $tcp_(96)
$ns at 180.2 "$ftp_(96) start"
$ns at 360.0 "$ftp_(96) stop"

#Set a TCP connection between node_(40) and node_(39)
set tcp_(97) [new Agent/TCP/Newreno]
$tcp_(97) set class_ 2
set sink_(97) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(97)
$ns attach-agent $node_(39) $sink_(97)
$ns connect $tcp_(97) $sink_(97)
set ftp_(97) [new Application/FTP]
$ftp_(97) attach-agent $tcp_(97)
$ns at 360.2 "$ftp_(97) start"
$ns at 540.0 "$ftp_(97) stop"

#Set a TCP connection between node_(48) and node_(2)
set tcp_(98) [new Agent/TCP/Newreno]
$tcp_(98) set class_ 2
set sink_(98) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(98)
$ns attach-agent $node_(2) $sink_(98)
$ns connect $tcp_(98) $sink_(98)
set ftp_(98) [new Application/FTP]
$ftp_(98) attach-agent $tcp_(98)
$ns at 540.2 "$ftp_(98) start"
$ns at 720.0 "$ftp_(98) stop"

#Set a TCP connection between node_(9) and node_(6)
set tcp_(99) [new Agent/TCP/Newreno]
$tcp_(99) set class_ 2
set sink_(99) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(99)
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
