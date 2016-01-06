#sim-scn2-0.tcl 
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
set tracefd       [open sim-scn2-0-$val(rp)-trace.tr w]
set windowVsTime2 [open sim-scn2-0-$val(rp)-win-.tr w]
set namtrace      [open sim-scn2-0-$val(rp).nam w]

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
$node_(0) set X_ 1640 
$node_(0) set Y_ 788 
$node_(0) set Z_ 0.0 
$node_(1) set X_ 403 
$node_(1) set Y_ 921 
$node_(1) set Z_ 0.0 
$node_(2) set X_ 890 
$node_(2) set Y_ 464 
$node_(2) set Z_ 0.0 
$node_(3) set X_ 2956 
$node_(3) set Y_ 271 
$node_(3) set Z_ 0.0 
$node_(4) set X_ 2874 
$node_(4) set Y_ 29 
$node_(4) set Z_ 0.0 
$node_(5) set X_ 1059 
$node_(5) set Y_ 339 
$node_(5) set Z_ 0.0 
$node_(6) set X_ 441 
$node_(6) set Y_ 718 
$node_(6) set Z_ 0.0 
$node_(7) set X_ 931 
$node_(7) set Y_ 464 
$node_(7) set Z_ 0.0 
$node_(8) set X_ 2669 
$node_(8) set Y_ 394 
$node_(8) set Z_ 0.0 
$node_(9) set X_ 1627 
$node_(9) set Y_ 25 
$node_(9) set Z_ 0.0 
$node_(10) set X_ 1371 
$node_(10) set Y_ 271 
$node_(10) set Z_ 0.0 
$node_(11) set X_ 1119 
$node_(11) set Y_ 544 
$node_(11) set Z_ 0.0 
$node_(12) set X_ 648 
$node_(12) set Y_ 511 
$node_(12) set Z_ 0.0 
$node_(13) set X_ 2518 
$node_(13) set Y_ 115 
$node_(13) set Z_ 0.0 
$node_(14) set X_ 1704 
$node_(14) set Y_ 667 
$node_(14) set Z_ 0.0 
$node_(15) set X_ 2237 
$node_(15) set Y_ 641 
$node_(15) set Z_ 0.0 
$node_(16) set X_ 2231 
$node_(16) set Y_ 503 
$node_(16) set Z_ 0.0 
$node_(17) set X_ 2650 
$node_(17) set Y_ 625 
$node_(17) set Z_ 0.0 
$node_(18) set X_ 868 
$node_(18) set Y_ 944 
$node_(18) set Z_ 0.0 
$node_(19) set X_ 2309 
$node_(19) set Y_ 668 
$node_(19) set Z_ 0.0 
$node_(20) set X_ 1749 
$node_(20) set Y_ 772 
$node_(20) set Z_ 0.0 
$node_(21) set X_ 954 
$node_(21) set Y_ 427 
$node_(21) set Z_ 0.0 
$node_(22) set X_ 1809 
$node_(22) set Y_ 207 
$node_(22) set Z_ 0.0 
$node_(23) set X_ 2498 
$node_(23) set Y_ 500 
$node_(23) set Z_ 0.0 
$node_(24) set X_ 1444 
$node_(24) set Y_ 720 
$node_(24) set Z_ 0.0 
$node_(25) set X_ 1780 
$node_(25) set Y_ 587 
$node_(25) set Z_ 0.0 
$node_(26) set X_ 231 
$node_(26) set Y_ 245 
$node_(26) set Z_ 0.0 
$node_(27) set X_ 282 
$node_(27) set Y_ 342 
$node_(27) set Z_ 0.0 
$node_(28) set X_ 2766 
$node_(28) set Y_ 453 
$node_(28) set Z_ 0.0 
$node_(29) set X_ 2020 
$node_(29) set Y_ 503 
$node_(29) set Z_ 0.0 
$node_(30) set X_ 1235 
$node_(30) set Y_ 919 
$node_(30) set Z_ 0.0 
$node_(31) set X_ 2683 
$node_(31) set Y_ 280 
$node_(31) set Z_ 0.0 
$node_(32) set X_ 111 
$node_(32) set Y_ 822 
$node_(32) set Z_ 0.0 
$node_(33) set X_ 1554 
$node_(33) set Y_ 447 
$node_(33) set Z_ 0.0 
$node_(34) set X_ 2382 
$node_(34) set Y_ 253 
$node_(34) set Z_ 0.0 
$node_(35) set X_ 1013 
$node_(35) set Y_ 299 
$node_(35) set Z_ 0.0 
$node_(36) set X_ 1907 
$node_(36) set Y_ 381 
$node_(36) set Z_ 0.0 
$node_(37) set X_ 1357 
$node_(37) set Y_ 431 
$node_(37) set Z_ 0.0 
$node_(38) set X_ 2965 
$node_(38) set Y_ 456 
$node_(38) set Z_ 0.0 
$node_(39) set X_ 2358 
$node_(39) set Y_ 282 
$node_(39) set Z_ 0.0 
$node_(40) set X_ 2696 
$node_(40) set Y_ 84 
$node_(40) set Z_ 0.0 
$node_(41) set X_ 2348 
$node_(41) set Y_ 535 
$node_(41) set Z_ 0.0 
$node_(42) set X_ 1007 
$node_(42) set Y_ 320 
$node_(42) set Z_ 0.0 
$node_(43) set X_ 759 
$node_(43) set Y_ 757 
$node_(43) set Z_ 0.0 
$node_(44) set X_ 1625 
$node_(44) set Y_ 810 
$node_(44) set Z_ 0.0 
$node_(45) set X_ 834 
$node_(45) set Y_ 86 
$node_(45) set Z_ 0.0 
$node_(46) set X_ 272 
$node_(46) set Y_ 707 
$node_(46) set Z_ 0.0 
$node_(47) set X_ 2811 
$node_(47) set Y_ 428 
$node_(47) set Z_ 0.0 
$node_(48) set X_ 1480 
$node_(48) set Y_ 47 
$node_(48) set Z_ 0.0 
$node_(49) set X_ 1121 
$node_(49) set Y_ 339 
$node_(49) set Z_ 0.0 
$node_(50) set X_ 2307 
$node_(50) set Y_ 77 
$node_(50) set Z_ 0.0 
$node_(51) set X_ 1130 
$node_(51) set Y_ 729 
$node_(51) set Z_ 0.0 
$ns at 0.0 "$node_(51) off" 
$ns at 165.0 "$node_(51) on" 
$node_(52) set X_ 1184 
$node_(52) set Y_ 322 
$node_(52) set Z_ 0.0 
$ns at 0.0 "$node_(52) off" 
$ns at 165.0 "$node_(52) on" 
$node_(53) set X_ 658 
$node_(53) set Y_ 554 
$node_(53) set Z_ 0.0 
$ns at 0.0 "$node_(53) off" 
$ns at 165.0 "$node_(53) on" 
$node_(54) set X_ 1307 
$node_(54) set Y_ 270 
$node_(54) set Z_ 0.0 
$ns at 0.0 "$node_(54) off" 
$ns at 165.0 "$node_(54) on" 
$node_(55) set X_ 2932 
$node_(55) set Y_ 952 
$node_(55) set Z_ 0.0 
$ns at 0.0 "$node_(55) off" 
$ns at 165.0 "$node_(55) on" 
$node_(56) set X_ 1402 
$node_(56) set Y_ 195 
$node_(56) set Z_ 0.0 
$ns at 0.0 "$node_(56) off" 
$ns at 165.0 "$node_(56) on" 
$node_(57) set X_ 2771 
$node_(57) set Y_ 605 
$node_(57) set Z_ 0.0 
$ns at 0.0 "$node_(57) off" 
$ns at 165.0 "$node_(57) on" 
$node_(58) set X_ 307 
$node_(58) set Y_ 993 
$node_(58) set Z_ 0.0 
$ns at 0.0 "$node_(58) off" 
$ns at 165.0 "$node_(58) on" 
$node_(59) set X_ 2648 
$node_(59) set Y_ 700 
$node_(59) set Z_ 0.0 
$ns at 0.0 "$node_(59) off" 
$ns at 165.0 "$node_(59) on" 
$node_(60) set X_ 1652 
$node_(60) set Y_ 917 
$node_(60) set Z_ 0.0 
$ns at 0.0 "$node_(60) off" 
$ns at 165.0 "$node_(60) on" 
$node_(61) set X_ 1859 
$node_(61) set Y_ 535 
$node_(61) set Z_ 0.0 
$ns at 0.0 "$node_(61) off" 
$ns at 165.0 "$node_(61) on" 
$node_(62) set X_ 2003 
$node_(62) set Y_ 722 
$node_(62) set Z_ 0.0 
$ns at 0.0 "$node_(62) off" 
$ns at 165.0 "$node_(62) on" 
$node_(63) set X_ 1334 
$node_(63) set Y_ 690 
$node_(63) set Z_ 0.0 
$ns at 0.0 "$node_(63) off" 
$ns at 165.0 "$node_(63) on" 
$node_(64) set X_ 1085 
$node_(64) set Y_ 69 
$node_(64) set Z_ 0.0 
$ns at 0.0 "$node_(64) off" 
$ns at 165.0 "$node_(64) on" 
$node_(65) set X_ 617 
$node_(65) set Y_ 676 
$node_(65) set Z_ 0.0 
$ns at 0.0 "$node_(65) off" 
$ns at 165.0 "$node_(65) on" 
$node_(66) set X_ 218 
$node_(66) set Y_ 979 
$node_(66) set Z_ 0.0 
$ns at 0.0 "$node_(66) off" 
$ns at 165.0 "$node_(66) on" 
$node_(67) set X_ 2303 
$node_(67) set Y_ 171 
$node_(67) set Z_ 0.0 
$ns at 0.0 "$node_(67) off" 
$ns at 165.0 "$node_(67) on" 
$node_(68) set X_ 826 
$node_(68) set Y_ 773 
$node_(68) set Z_ 0.0 
$ns at 0.0 "$node_(68) off" 
$ns at 165.0 "$node_(68) on" 
$node_(69) set X_ 2643 
$node_(69) set Y_ 247 
$node_(69) set Z_ 0.0 
$ns at 0.0 "$node_(69) off" 
$ns at 165.0 "$node_(69) on" 
$node_(70) set X_ 1781 
$node_(70) set Y_ 185 
$node_(70) set Z_ 0.0 
$ns at 0.0 "$node_(70) off" 
$ns at 165.0 "$node_(70) on" 
$node_(71) set X_ 222 
$node_(71) set Y_ 491 
$node_(71) set Z_ 0.0 
$ns at 0.0 "$node_(71) off" 
$ns at 165.0 "$node_(71) on" 
$node_(72) set X_ 538 
$node_(72) set Y_ 303 
$node_(72) set Z_ 0.0 
$ns at 0.0 "$node_(72) off" 
$ns at 165.0 "$node_(72) on" 
$node_(73) set X_ 2503 
$node_(73) set Y_ 571 
$node_(73) set Z_ 0.0 
$ns at 0.0 "$node_(73) off" 
$ns at 165.0 "$node_(73) on" 
$node_(74) set X_ 1368 
$node_(74) set Y_ 549 
$node_(74) set Z_ 0.0 
$ns at 0.0 "$node_(74) off" 
$ns at 165.0 "$node_(74) on" 
$node_(75) set X_ 2614 
$node_(75) set Y_ 558 
$node_(75) set Z_ 0.0 
$ns at 0.0 "$node_(75) off" 
$ns at 330.0 "$node_(75) on" 
$node_(76) set X_ 598 
$node_(76) set Y_ 182 
$node_(76) set Z_ 0.0 
$ns at 0.0 "$node_(76) off" 
$ns at 330.0 "$node_(76) on" 
$node_(77) set X_ 2115 
$node_(77) set Y_ 301 
$node_(77) set Z_ 0.0 
$ns at 0.0 "$node_(77) off" 
$ns at 330.0 "$node_(77) on" 
$node_(78) set X_ 566 
$node_(78) set Y_ 701 
$node_(78) set Z_ 0.0 
$ns at 0.0 "$node_(78) off" 
$ns at 330.0 "$node_(78) on" 
$node_(79) set X_ 507 
$node_(79) set Y_ 240 
$node_(79) set Z_ 0.0 
$ns at 0.0 "$node_(79) off" 
$ns at 330.0 "$node_(79) on" 
$node_(80) set X_ 1054 
$node_(80) set Y_ 87 
$node_(80) set Z_ 0.0 
$ns at 0.0 "$node_(80) off" 
$ns at 330.0 "$node_(80) on" 
$node_(81) set X_ 2016 
$node_(81) set Y_ 302 
$node_(81) set Z_ 0.0 
$ns at 0.0 "$node_(81) off" 
$ns at 330.0 "$node_(81) on" 
$node_(82) set X_ 1185 
$node_(82) set Y_ 27 
$node_(82) set Z_ 0.0 
$ns at 0.0 "$node_(82) off" 
$ns at 330.0 "$node_(82) on" 
$node_(83) set X_ 669 
$node_(83) set Y_ 957 
$node_(83) set Z_ 0.0 
$ns at 0.0 "$node_(83) off" 
$ns at 330.0 "$node_(83) on" 
$node_(84) set X_ 1250 
$node_(84) set Y_ 162 
$node_(84) set Z_ 0.0 
$ns at 0.0 "$node_(84) off" 
$ns at 330.0 "$node_(84) on" 
$node_(85) set X_ 877 
$node_(85) set Y_ 82 
$node_(85) set Z_ 0.0 
$ns at 0.0 "$node_(85) off" 
$ns at 330.0 "$node_(85) on" 
$node_(86) set X_ 2616 
$node_(86) set Y_ 904 
$node_(86) set Z_ 0.0 
$ns at 0.0 "$node_(86) off" 
$ns at 330.0 "$node_(86) on" 
$node_(87) set X_ 1665 
$node_(87) set Y_ 991 
$node_(87) set Z_ 0.0 
$ns at 0.0 "$node_(87) off" 
$ns at 330.0 "$node_(87) on" 
$node_(88) set X_ 1781 
$node_(88) set Y_ 552 
$node_(88) set Z_ 0.0 
$ns at 0.0 "$node_(88) off" 
$ns at 330.0 "$node_(88) on" 
$node_(89) set X_ 1335 
$node_(89) set Y_ 925 
$node_(89) set Z_ 0.0 
$ns at 0.0 "$node_(89) off" 
$ns at 330.0 "$node_(89) on" 
$node_(90) set X_ 737 
$node_(90) set Y_ 308 
$node_(90) set Z_ 0.0 
$ns at 0.0 "$node_(90) off" 
$ns at 330.0 "$node_(90) on" 
$node_(91) set X_ 681 
$node_(91) set Y_ 279 
$node_(91) set Z_ 0.0 
$ns at 0.0 "$node_(91) off" 
$ns at 330.0 "$node_(91) on" 
$node_(92) set X_ 2181 
$node_(92) set Y_ 249 
$node_(92) set Z_ 0.0 
$ns at 0.0 "$node_(92) off" 
$ns at 330.0 "$node_(92) on" 
$node_(93) set X_ 2996 
$node_(93) set Y_ 103 
$node_(93) set Z_ 0.0 
$ns at 0.0 "$node_(93) off" 
$ns at 330.0 "$node_(93) on" 
$node_(94) set X_ 1657 
$node_(94) set Y_ 489 
$node_(94) set Z_ 0.0 
$ns at 0.0 "$node_(94) off" 
$ns at 330.0 "$node_(94) on" 
$node_(95) set X_ 1849 
$node_(95) set Y_ 717 
$node_(95) set Z_ 0.0 
$ns at 0.0 "$node_(95) off" 
$ns at 330.0 "$node_(95) on" 
$node_(96) set X_ 483 
$node_(96) set Y_ 586 
$node_(96) set Z_ 0.0 
$ns at 0.0 "$node_(96) off" 
$ns at 330.0 "$node_(96) on" 
$node_(97) set X_ 192 
$node_(97) set Y_ 835 
$node_(97) set Z_ 0.0 
$ns at 0.0 "$node_(97) off" 
$ns at 330.0 "$node_(97) on" 
$node_(98) set X_ 1335 
$node_(98) set Y_ 671 
$node_(98) set Z_ 0.0 
$ns at 0.0 "$node_(98) off" 
$ns at 330.0 "$node_(98) on" 
$node_(99) set X_ 523 
$node_(99) set Y_ 237 
$node_(99) set Z_ 0.0 
$ns at 0.0 "$node_(99) off" 
$ns at 330.0 "$node_(99) on" 
$node_(100) set X_ 1573 
$node_(100) set Y_ 954 
$node_(100) set Z_ 0.0 
$ns at 0.0 "$node_(100) off" 
$ns at 495.0 "$node_(100) on" 
$node_(101) set X_ 2837 
$node_(101) set Y_ 861 
$node_(101) set Z_ 0.0 
$ns at 0.0 "$node_(101) off" 
$ns at 495.0 "$node_(101) on" 
$node_(102) set X_ 2823 
$node_(102) set Y_ 992 
$node_(102) set Z_ 0.0 
$ns at 0.0 "$node_(102) off" 
$ns at 495.0 "$node_(102) on" 
$node_(103) set X_ 2734 
$node_(103) set Y_ 173 
$node_(103) set Z_ 0.0 
$ns at 0.0 "$node_(103) off" 
$ns at 495.0 "$node_(103) on" 
$node_(104) set X_ 2978 
$node_(104) set Y_ 573 
$node_(104) set Z_ 0.0 
$ns at 0.0 "$node_(104) off" 
$ns at 495.0 "$node_(104) on" 
$node_(105) set X_ 461 
$node_(105) set Y_ 799 
$node_(105) set Z_ 0.0 
$ns at 0.0 "$node_(105) off" 
$ns at 495.0 "$node_(105) on" 
$node_(106) set X_ 2694 
$node_(106) set Y_ 136 
$node_(106) set Z_ 0.0 
$ns at 0.0 "$node_(106) off" 
$ns at 495.0 "$node_(106) on" 
$node_(107) set X_ 1770 
$node_(107) set Y_ 705 
$node_(107) set Z_ 0.0 
$ns at 0.0 "$node_(107) off" 
$ns at 495.0 "$node_(107) on" 
$node_(108) set X_ 2486 
$node_(108) set Y_ 410 
$node_(108) set Z_ 0.0 
$ns at 0.0 "$node_(108) off" 
$ns at 495.0 "$node_(108) on" 
$node_(109) set X_ 279 
$node_(109) set Y_ 668 
$node_(109) set Z_ 0.0 
$ns at 0.0 "$node_(109) off" 
$ns at 495.0 "$node_(109) on" 
$node_(110) set X_ 1907 
$node_(110) set Y_ 358 
$node_(110) set Z_ 0.0 
$ns at 0.0 "$node_(110) off" 
$ns at 495.0 "$node_(110) on" 
$node_(111) set X_ 2621 
$node_(111) set Y_ 370 
$node_(111) set Z_ 0.0 
$ns at 0.0 "$node_(111) off" 
$ns at 495.0 "$node_(111) on" 
$node_(112) set X_ 769 
$node_(112) set Y_ 558 
$node_(112) set Z_ 0.0 
$ns at 0.0 "$node_(112) off" 
$ns at 495.0 "$node_(112) on" 
$node_(113) set X_ 865 
$node_(113) set Y_ 220 
$node_(113) set Z_ 0.0 
$ns at 0.0 "$node_(113) off" 
$ns at 495.0 "$node_(113) on" 
$node_(114) set X_ 1150 
$node_(114) set Y_ 878 
$node_(114) set Z_ 0.0 
$ns at 0.0 "$node_(114) off" 
$ns at 495.0 "$node_(114) on" 
$node_(115) set X_ 2731 
$node_(115) set Y_ 938 
$node_(115) set Z_ 0.0 
$ns at 0.0 "$node_(115) off" 
$ns at 495.0 "$node_(115) on" 
$node_(116) set X_ 2886 
$node_(116) set Y_ 683 
$node_(116) set Z_ 0.0 
$ns at 0.0 "$node_(116) off" 
$ns at 495.0 "$node_(116) on" 
$node_(117) set X_ 791 
$node_(117) set Y_ 982 
$node_(117) set Z_ 0.0 
$ns at 0.0 "$node_(117) off" 
$ns at 495.0 "$node_(117) on" 
$node_(118) set X_ 1427 
$node_(118) set Y_ 821 
$node_(118) set Z_ 0.0 
$ns at 0.0 "$node_(118) off" 
$ns at 495.0 "$node_(118) on" 
$node_(119) set X_ 283 
$node_(119) set Y_ 161 
$node_(119) set Z_ 0.0 
$ns at 0.0 "$node_(119) off" 
$ns at 495.0 "$node_(119) on" 
$node_(120) set X_ 2348 
$node_(120) set Y_ 338 
$node_(120) set Z_ 0.0 
$ns at 0.0 "$node_(120) off" 
$ns at 495.0 "$node_(120) on" 
$node_(121) set X_ 1302 
$node_(121) set Y_ 149 
$node_(121) set Z_ 0.0 
$ns at 0.0 "$node_(121) off" 
$ns at 495.0 "$node_(121) on" 
$node_(122) set X_ 1437 
$node_(122) set Y_ 193 
$node_(122) set Z_ 0.0 
$ns at 0.0 "$node_(122) off" 
$ns at 495.0 "$node_(122) on" 
$node_(123) set X_ 2982 
$node_(123) set Y_ 154 
$node_(123) set Z_ 0.0 
$ns at 0.0 "$node_(123) off" 
$ns at 495.0 "$node_(123) on" 
$node_(124) set X_ 1112 
$node_(124) set Y_ 265 
$node_(124) set Z_ 0.0 
$ns at 0.0 "$node_(124) off" 
$ns at 495.0 "$node_(124) on" 
$node_(125) set X_ 1883 
$node_(125) set Y_ 719 
$node_(125) set Z_ 0.0 
$ns at 0.0 "$node_(125) off" 
$ns at 660.0 "$node_(125) on" 
$node_(126) set X_ 1990 
$node_(126) set Y_ 576 
$node_(126) set Z_ 0.0 
$ns at 0.0 "$node_(126) off" 
$ns at 660.0 "$node_(126) on" 
$node_(127) set X_ 2051 
$node_(127) set Y_ 450 
$node_(127) set Z_ 0.0 
$ns at 0.0 "$node_(127) off" 
$ns at 660.0 "$node_(127) on" 
$node_(128) set X_ 2694 
$node_(128) set Y_ 978 
$node_(128) set Z_ 0.0 
$ns at 0.0 "$node_(128) off" 
$ns at 660.0 "$node_(128) on" 
$node_(129) set X_ 295 
$node_(129) set Y_ 527 
$node_(129) set Z_ 0.0 
$ns at 0.0 "$node_(129) off" 
$ns at 660.0 "$node_(129) on" 
$node_(130) set X_ 1523 
$node_(130) set Y_ 508 
$node_(130) set Z_ 0.0 
$ns at 0.0 "$node_(130) off" 
$ns at 660.0 "$node_(130) on" 
$node_(131) set X_ 2892 
$node_(131) set Y_ 978 
$node_(131) set Z_ 0.0 
$ns at 0.0 "$node_(131) off" 
$ns at 660.0 "$node_(131) on" 
$node_(132) set X_ 271 
$node_(132) set Y_ 242 
$node_(132) set Z_ 0.0 
$ns at 0.0 "$node_(132) off" 
$ns at 660.0 "$node_(132) on" 
$node_(133) set X_ 431 
$node_(133) set Y_ 54 
$node_(133) set Z_ 0.0 
$ns at 0.0 "$node_(133) off" 
$ns at 660.0 "$node_(133) on" 
$node_(134) set X_ 468 
$node_(134) set Y_ 758 
$node_(134) set Z_ 0.0 
$ns at 0.0 "$node_(134) off" 
$ns at 660.0 "$node_(134) on" 
$node_(135) set X_ 655 
$node_(135) set Y_ 499 
$node_(135) set Z_ 0.0 
$ns at 0.0 "$node_(135) off" 
$ns at 660.0 "$node_(135) on" 
$node_(136) set X_ 446 
$node_(136) set Y_ 255 
$node_(136) set Z_ 0.0 
$ns at 0.0 "$node_(136) off" 
$ns at 660.0 "$node_(136) on" 
$node_(137) set X_ 2067 
$node_(137) set Y_ 173 
$node_(137) set Z_ 0.0 
$ns at 0.0 "$node_(137) off" 
$ns at 660.0 "$node_(137) on" 
$node_(138) set X_ 6 
$node_(138) set Y_ 947 
$node_(138) set Z_ 0.0 
$ns at 0.0 "$node_(138) off" 
$ns at 660.0 "$node_(138) on" 
$node_(139) set X_ 2644 
$node_(139) set Y_ 255 
$node_(139) set Z_ 0.0 
$ns at 0.0 "$node_(139) off" 
$ns at 660.0 "$node_(139) on" 
$node_(140) set X_ 1069 
$node_(140) set Y_ 634 
$node_(140) set Z_ 0.0 
$ns at 0.0 "$node_(140) off" 
$ns at 660.0 "$node_(140) on" 
$node_(141) set X_ 1369 
$node_(141) set Y_ 215 
$node_(141) set Z_ 0.0 
$ns at 0.0 "$node_(141) off" 
$ns at 660.0 "$node_(141) on" 
$node_(142) set X_ 2491 
$node_(142) set Y_ 221 
$node_(142) set Z_ 0.0 
$ns at 0.0 "$node_(142) off" 
$ns at 660.0 "$node_(142) on" 
$node_(143) set X_ 2307 
$node_(143) set Y_ 862 
$node_(143) set Z_ 0.0 
$ns at 0.0 "$node_(143) off" 
$ns at 660.0 "$node_(143) on" 
$node_(144) set X_ 1264 
$node_(144) set Y_ 525 
$node_(144) set Z_ 0.0 
$ns at 0.0 "$node_(144) off" 
$ns at 660.0 "$node_(144) on" 
$node_(145) set X_ 1726 
$node_(145) set Y_ 5 
$node_(145) set Z_ 0.0 
$ns at 0.0 "$node_(145) off" 
$ns at 660.0 "$node_(145) on" 
$node_(146) set X_ 563 
$node_(146) set Y_ 945 
$node_(146) set Z_ 0.0 
$ns at 0.0 "$node_(146) off" 
$ns at 660.0 "$node_(146) on" 
$node_(147) set X_ 2254 
$node_(147) set Y_ 717 
$node_(147) set Z_ 0.0 
$ns at 0.0 "$node_(147) off" 
$ns at 660.0 "$node_(147) on" 
$node_(148) set X_ 2576 
$node_(148) set Y_ 418 
$node_(148) set Z_ 0.0 
$ns at 0.0 "$node_(148) off" 
$ns at 660.0 "$node_(148) on" 
$node_(149) set X_ 2256 
$node_(149) set Y_ 759 
$node_(149) set Z_ 0.0 
$ns at 0.0 "$node_(149) off" 
$ns at 660.0 "$node_(149) on" 

# Generation of movements
$ns at 0.0 "$node_(0) setdest 2734 611 10.0" 
$ns at 72.41524366039164 "$node_(0) setdest 2873 517 7.0" 
$ns at 172.16597259318405 "$node_(0) setdest 2965 419 7.0" 
$ns at 204.0389107652151 "$node_(0) setdest 424 718 1.0" 
$ns at 242.45228470596646 "$node_(0) setdest 525 252 8.0" 
$ns at 276.9783042328111 "$node_(0) setdest 2289 556 17.0" 
$ns at 372.0256454944318 "$node_(0) setdest 146 979 9.0" 
$ns at 462.22338271641286 "$node_(0) setdest 1938 679 11.0" 
$ns at 598.8196354002935 "$node_(0) setdest 1256 319 10.0" 
$ns at 667.4081861790386 "$node_(0) setdest 2734 703 6.0" 
$ns at 732.9123810986158 "$node_(0) setdest 829 697 15.0" 
$ns at 795.4562735861958 "$node_(0) setdest 2702 509 5.0" 
$ns at 862.7967999642146 "$node_(0) setdest 2102 823 5.0" 
$ns at 0.0 "$node_(1) setdest 723 332 3.0" 
$ns at 42.68647125608505 "$node_(1) setdest 1219 930 4.0" 
$ns at 90.99555334445665 "$node_(1) setdest 1056 207 14.0" 
$ns at 136.08958614553757 "$node_(1) setdest 2551 894 10.0" 
$ns at 247.8045712084035 "$node_(1) setdest 2849 624 6.0" 
$ns at 335.36871282423124 "$node_(1) setdest 242 684 5.0" 
$ns at 409.3719008801999 "$node_(1) setdest 1031 453 1.0" 
$ns at 444.7164946943091 "$node_(1) setdest 2241 856 9.0" 
$ns at 514.8462095476509 "$node_(1) setdest 1743 490 17.0" 
$ns at 667.3896600788909 "$node_(1) setdest 2856 36 6.0" 
$ns at 699.0265870604796 "$node_(1) setdest 2212 188 6.0" 
$ns at 775.0441226809669 "$node_(1) setdest 2607 617 6.0" 
$ns at 814.3128903823008 "$node_(1) setdest 2715 422 2.0" 
$ns at 855.3780330310551 "$node_(1) setdest 908 106 1.0" 
$ns at 887.5039863715491 "$node_(1) setdest 2039 359 16.0" 
$ns at 0.0 "$node_(2) setdest 1838 849 17.0" 
$ns at 171.35847235766076 "$node_(2) setdest 589 766 4.0" 
$ns at 231.66911876958852 "$node_(2) setdest 2060 76 3.0" 
$ns at 264.6056116468852 "$node_(2) setdest 43 346 13.0" 
$ns at 368.6216897055913 "$node_(2) setdest 2633 476 1.0" 
$ns at 399.7079682005728 "$node_(2) setdest 1212 921 6.0" 
$ns at 487.15318434293204 "$node_(2) setdest 267 766 13.0" 
$ns at 599.7992062331275 "$node_(2) setdest 2505 561 16.0" 
$ns at 649.4103761065654 "$node_(2) setdest 1282 954 15.0" 
$ns at 817.6561569288265 "$node_(2) setdest 2148 970 19.0" 
$ns at 886.0983299550135 "$node_(2) setdest 316 254 17.0" 
$ns at 0.0 "$node_(3) setdest 2065 729 18.0" 
$ns at 81.03806827319931 "$node_(3) setdest 1541 862 9.0" 
$ns at 127.69489616488764 "$node_(3) setdest 65 224 19.0" 
$ns at 312.1777416567171 "$node_(3) setdest 1926 51 2.0" 
$ns at 344.7446419277885 "$node_(3) setdest 2750 332 14.0" 
$ns at 486.9103250862442 "$node_(3) setdest 823 287 12.0" 
$ns at 526.4983266807235 "$node_(3) setdest 2288 208 3.0" 
$ns at 570.3700346418303 "$node_(3) setdest 1899 327 11.0" 
$ns at 601.0533149833409 "$node_(3) setdest 1946 746 9.0" 
$ns at 647.9743206906319 "$node_(3) setdest 1194 509 10.0" 
$ns at 723.4282700703925 "$node_(3) setdest 2055 559 18.0" 
$ns at 0.0 "$node_(4) setdest 838 683 2.0" 
$ns at 46.19881008381675 "$node_(4) setdest 2793 539 12.0" 
$ns at 177.8139110856563 "$node_(4) setdest 1684 496 1.0" 
$ns at 216.20594943659046 "$node_(4) setdest 2941 357 14.0" 
$ns at 314.3525774553981 "$node_(4) setdest 920 984 12.0" 
$ns at 439.3017520611154 "$node_(4) setdest 1525 454 12.0" 
$ns at 551.5533126297071 "$node_(4) setdest 395 687 15.0" 
$ns at 667.5749594062515 "$node_(4) setdest 977 382 17.0" 
$ns at 704.2639806985217 "$node_(4) setdest 2227 728 16.0" 
$ns at 858.0613388052243 "$node_(4) setdest 2238 561 3.0" 
$ns at 0.0 "$node_(5) setdest 1931 583 7.0" 
$ns at 68.3037083512871 "$node_(5) setdest 943 790 14.0" 
$ns at 212.67651361650758 "$node_(5) setdest 2136 480 11.0" 
$ns at 312.850352484829 "$node_(5) setdest 590 92 5.0" 
$ns at 351.196820791977 "$node_(5) setdest 1627 643 11.0" 
$ns at 387.2028255798869 "$node_(5) setdest 2352 724 8.0" 
$ns at 482.6775051595472 "$node_(5) setdest 2271 847 3.0" 
$ns at 517.7661813461043 "$node_(5) setdest 934 444 1.0" 
$ns at 552.9792849916464 "$node_(5) setdest 2089 968 20.0" 
$ns at 635.3345841097425 "$node_(5) setdest 1614 345 1.0" 
$ns at 674.2237574367654 "$node_(5) setdest 504 510 13.0" 
$ns at 804.494173381234 "$node_(5) setdest 2393 867 20.0" 
$ns at 859.764197551403 "$node_(5) setdest 545 298 2.0" 
$ns at 0.0 "$node_(6) setdest 2885 790 6.0" 
$ns at 58.16566923805131 "$node_(6) setdest 2529 804 6.0" 
$ns at 120.39792748700728 "$node_(6) setdest 360 316 9.0" 
$ns at 216.00461784202395 "$node_(6) setdest 2504 805 8.0" 
$ns at 317.73332407722324 "$node_(6) setdest 96 554 11.0" 
$ns at 412.06687332959444 "$node_(6) setdest 480 345 4.0" 
$ns at 449.71856897692027 "$node_(6) setdest 1931 993 6.0" 
$ns at 511.18858634197323 "$node_(6) setdest 218 185 1.0" 
$ns at 549.2739558531077 "$node_(6) setdest 675 804 5.0" 
$ns at 607.7817204696403 "$node_(6) setdest 1118 219 12.0" 
$ns at 684.4354708421195 "$node_(6) setdest 2781 48 9.0" 
$ns at 731.5008497779045 "$node_(6) setdest 1464 553 20.0" 
$ns at 884.8260647379784 "$node_(6) setdest 2437 112 4.0" 
$ns at 0.0 "$node_(7) setdest 75 207 18.0" 
$ns at 188.54342848316548 "$node_(7) setdest 1962 974 5.0" 
$ns at 238.71415457692453 "$node_(7) setdest 2121 641 1.0" 
$ns at 271.94010437203315 "$node_(7) setdest 177 115 13.0" 
$ns at 375.525870924265 "$node_(7) setdest 2647 574 6.0" 
$ns at 408.0680418087978 "$node_(7) setdest 2143 163 10.0" 
$ns at 473.75665948641006 "$node_(7) setdest 65 791 13.0" 
$ns at 566.6168155698888 "$node_(7) setdest 2426 604 12.0" 
$ns at 676.8932598259461 "$node_(7) setdest 2661 901 11.0" 
$ns at 735.9002684893197 "$node_(7) setdest 2779 144 2.0" 
$ns at 780.9125035153936 "$node_(7) setdest 872 253 15.0" 
$ns at 0.0 "$node_(8) setdest 2910 538 14.0" 
$ns at 92.5638398727434 "$node_(8) setdest 1888 468 1.0" 
$ns at 129.61090682509132 "$node_(8) setdest 2718 998 8.0" 
$ns at 222.07158050300313 "$node_(8) setdest 1824 285 5.0" 
$ns at 269.63892514659005 "$node_(8) setdest 1177 478 12.0" 
$ns at 361.85001558719273 "$node_(8) setdest 2521 694 15.0" 
$ns at 528.778024760827 "$node_(8) setdest 1735 447 11.0" 
$ns at 626.2468258776923 "$node_(8) setdest 729 549 3.0" 
$ns at 667.0273969097634 "$node_(8) setdest 1918 958 15.0" 
$ns at 798.0650601553893 "$node_(8) setdest 1211 121 7.0" 
$ns at 884.3632351921024 "$node_(8) setdest 2507 117 17.0" 
$ns at 0.0 "$node_(9) setdest 1047 309 6.0" 
$ns at 30.710325858990227 "$node_(9) setdest 466 267 10.0" 
$ns at 137.5001556840187 "$node_(9) setdest 1156 448 6.0" 
$ns at 197.9856301355976 "$node_(9) setdest 2513 479 17.0" 
$ns at 306.67831569857645 "$node_(9) setdest 2825 936 15.0" 
$ns at 458.85492575758167 "$node_(9) setdest 980 175 19.0" 
$ns at 556.2914617941085 "$node_(9) setdest 1760 127 5.0" 
$ns at 615.0030794556874 "$node_(9) setdest 1379 969 3.0" 
$ns at 667.9710729578047 "$node_(9) setdest 1944 206 5.0" 
$ns at 727.4764676834258 "$node_(9) setdest 2814 64 20.0" 
$ns at 868.8806296511427 "$node_(9) setdest 336 995 6.0" 
$ns at 0.0 "$node_(10) setdest 1147 773 10.0" 
$ns at 110.87662111231175 "$node_(10) setdest 2167 901 10.0" 
$ns at 182.72650111638472 "$node_(10) setdest 1569 5 1.0" 
$ns at 219.46988630041028 "$node_(10) setdest 1382 465 9.0" 
$ns at 329.17151452235373 "$node_(10) setdest 979 801 11.0" 
$ns at 448.4551916320038 "$node_(10) setdest 2500 213 17.0" 
$ns at 510.7647478796707 "$node_(10) setdest 324 245 19.0" 
$ns at 546.8807517270928 "$node_(10) setdest 1905 769 1.0" 
$ns at 579.7719615538052 "$node_(10) setdest 2799 330 19.0" 
$ns at 621.7401649750627 "$node_(10) setdest 368 445 13.0" 
$ns at 687.1409318969318 "$node_(10) setdest 2562 629 12.0" 
$ns at 785.1358941578084 "$node_(10) setdest 2308 747 10.0" 
$ns at 848.1344085874363 "$node_(10) setdest 2366 821 14.0" 
$ns at 0.0 "$node_(11) setdest 85 521 8.0" 
$ns at 93.19222685756871 "$node_(11) setdest 264 443 18.0" 
$ns at 239.8901646944356 "$node_(11) setdest 2335 689 15.0" 
$ns at 343.62536796640586 "$node_(11) setdest 278 414 13.0" 
$ns at 458.6945066761571 "$node_(11) setdest 1146 782 18.0" 
$ns at 491.8936883392264 "$node_(11) setdest 701 188 4.0" 
$ns at 547.6836859827458 "$node_(11) setdest 1576 727 6.0" 
$ns at 610.859422286527 "$node_(11) setdest 1416 604 4.0" 
$ns at 676.4766774858028 "$node_(11) setdest 821 598 19.0" 
$ns at 780.1381234873513 "$node_(11) setdest 402 772 3.0" 
$ns at 831.7565591946912 "$node_(11) setdest 29 283 16.0" 
$ns at 0.0 "$node_(12) setdest 1314 580 8.0" 
$ns at 61.42131594396364 "$node_(12) setdest 561 275 1.0" 
$ns at 97.5015633897763 "$node_(12) setdest 804 637 4.0" 
$ns at 142.56494896917377 "$node_(12) setdest 217 55 1.0" 
$ns at 180.93130379983765 "$node_(12) setdest 2969 757 13.0" 
$ns at 268.9585204542472 "$node_(12) setdest 2705 755 2.0" 
$ns at 306.89452181782065 "$node_(12) setdest 1093 301 1.0" 
$ns at 339.15753134545463 "$node_(12) setdest 374 72 1.0" 
$ns at 370.83313898727965 "$node_(12) setdest 2579 965 15.0" 
$ns at 413.32554220108983 "$node_(12) setdest 2007 634 9.0" 
$ns at 472.8502035649604 "$node_(12) setdest 2721 838 8.0" 
$ns at 543.7833939791626 "$node_(12) setdest 1178 281 18.0" 
$ns at 741.7434424055098 "$node_(12) setdest 2722 830 13.0" 
$ns at 824.3410426116839 "$node_(12) setdest 465 961 10.0" 
$ns at 883.4855492817479 "$node_(12) setdest 111 775 5.0" 
$ns at 0.0 "$node_(13) setdest 548 199 7.0" 
$ns at 59.11101409868046 "$node_(13) setdest 460 821 20.0" 
$ns at 167.2310283608847 "$node_(13) setdest 1955 355 3.0" 
$ns at 199.1865083428269 "$node_(13) setdest 1047 915 8.0" 
$ns at 289.8225366675598 "$node_(13) setdest 2002 110 12.0" 
$ns at 337.48020247060595 "$node_(13) setdest 2883 476 8.0" 
$ns at 423.42427648240135 "$node_(13) setdest 185 911 6.0" 
$ns at 483.5558409360715 "$node_(13) setdest 239 591 16.0" 
$ns at 564.3590980997716 "$node_(13) setdest 2069 310 17.0" 
$ns at 651.6989953615813 "$node_(13) setdest 2583 304 2.0" 
$ns at 700.7629255316564 "$node_(13) setdest 442 414 19.0" 
$ns at 888.3865187046147 "$node_(13) setdest 582 844 16.0" 
$ns at 0.0 "$node_(14) setdest 260 909 14.0" 
$ns at 123.7055449996207 "$node_(14) setdest 1564 863 3.0" 
$ns at 154.13535645418546 "$node_(14) setdest 1665 348 2.0" 
$ns at 195.3646603148332 "$node_(14) setdest 2596 23 14.0" 
$ns at 349.0581787143062 "$node_(14) setdest 102 680 12.0" 
$ns at 493.75509006694983 "$node_(14) setdest 1084 510 1.0" 
$ns at 531.231211420324 "$node_(14) setdest 312 210 19.0" 
$ns at 660.9504475131971 "$node_(14) setdest 2541 312 15.0" 
$ns at 693.7465914938159 "$node_(14) setdest 2726 459 10.0" 
$ns at 739.6493554258293 "$node_(14) setdest 930 333 8.0" 
$ns at 831.4468139045632 "$node_(14) setdest 2543 623 20.0" 
$ns at 0.0 "$node_(15) setdest 730 690 10.0" 
$ns at 49.73827845449738 "$node_(15) setdest 514 596 8.0" 
$ns at 101.69415947121817 "$node_(15) setdest 631 757 5.0" 
$ns at 166.82952132990465 "$node_(15) setdest 1210 753 4.0" 
$ns at 235.5619999444069 "$node_(15) setdest 511 806 18.0" 
$ns at 415.30470294730975 "$node_(15) setdest 2307 961 3.0" 
$ns at 462.62800890337223 "$node_(15) setdest 1096 318 18.0" 
$ns at 560.0769794799344 "$node_(15) setdest 155 520 14.0" 
$ns at 658.3411391334744 "$node_(15) setdest 2447 287 11.0" 
$ns at 723.8577752871681 "$node_(15) setdest 1671 989 3.0" 
$ns at 775.8571430308457 "$node_(15) setdest 2197 125 11.0" 
$ns at 867.8883394836528 "$node_(15) setdest 319 114 13.0" 
$ns at 0.0 "$node_(16) setdest 1166 969 12.0" 
$ns at 84.91241167565147 "$node_(16) setdest 721 292 10.0" 
$ns at 141.97016632359748 "$node_(16) setdest 775 493 19.0" 
$ns at 302.979089993888 "$node_(16) setdest 156 315 9.0" 
$ns at 399.41352165207496 "$node_(16) setdest 1402 554 18.0" 
$ns at 437.7621415433207 "$node_(16) setdest 1000 309 15.0" 
$ns at 605.3967319366338 "$node_(16) setdest 2584 244 2.0" 
$ns at 635.5472169449558 "$node_(16) setdest 2857 109 8.0" 
$ns at 730.5057672117904 "$node_(16) setdest 721 194 1.0" 
$ns at 763.4776120715908 "$node_(16) setdest 1927 509 2.0" 
$ns at 799.5227577495832 "$node_(16) setdest 1674 197 7.0" 
$ns at 884.9658460164078 "$node_(16) setdest 1884 102 13.0" 
$ns at 0.0 "$node_(17) setdest 426 499 3.0" 
$ns at 42.85804246715476 "$node_(17) setdest 2288 656 9.0" 
$ns at 119.24814308032332 "$node_(17) setdest 694 324 15.0" 
$ns at 149.9812687164637 "$node_(17) setdest 311 247 3.0" 
$ns at 183.00842657039283 "$node_(17) setdest 1147 474 1.0" 
$ns at 213.21905233172825 "$node_(17) setdest 303 603 14.0" 
$ns at 248.41881358716927 "$node_(17) setdest 1643 86 4.0" 
$ns at 316.55572597210914 "$node_(17) setdest 2476 355 17.0" 
$ns at 377.90288442315386 "$node_(17) setdest 2618 875 14.0" 
$ns at 492.79174456957963 "$node_(17) setdest 2736 163 1.0" 
$ns at 528.054584111141 "$node_(17) setdest 1549 445 10.0" 
$ns at 601.727431931958 "$node_(17) setdest 436 922 16.0" 
$ns at 744.77264567902 "$node_(17) setdest 131 502 14.0" 
$ns at 0.0 "$node_(18) setdest 2575 505 6.0" 
$ns at 88.42357538050976 "$node_(18) setdest 575 49 17.0" 
$ns at 268.02745778904017 "$node_(18) setdest 1736 746 6.0" 
$ns at 331.2443356012546 "$node_(18) setdest 178 902 6.0" 
$ns at 411.90179966340145 "$node_(18) setdest 1764 623 10.0" 
$ns at 513.7516410070156 "$node_(18) setdest 69 95 7.0" 
$ns at 610.7679035021775 "$node_(18) setdest 988 852 10.0" 
$ns at 648.0908500125506 "$node_(18) setdest 2780 17 15.0" 
$ns at 821.9065030687086 "$node_(18) setdest 2495 340 8.0" 
$ns at 0.0 "$node_(19) setdest 1045 367 15.0" 
$ns at 60.404758725903434 "$node_(19) setdest 1749 213 7.0" 
$ns at 95.51088936179357 "$node_(19) setdest 2989 240 14.0" 
$ns at 242.650256337115 "$node_(19) setdest 1563 371 1.0" 
$ns at 276.0263428819606 "$node_(19) setdest 1591 950 9.0" 
$ns at 315.8383653359805 "$node_(19) setdest 222 775 17.0" 
$ns at 504.32533240685905 "$node_(19) setdest 1087 406 17.0" 
$ns at 695.6732040160375 "$node_(19) setdest 1271 934 11.0" 
$ns at 820.6283502292606 "$node_(19) setdest 718 123 15.0" 
$ns at 883.0357873316386 "$node_(19) setdest 1250 280 8.0" 
$ns at 0.0 "$node_(20) setdest 1956 212 14.0" 
$ns at 66.2964042551942 "$node_(20) setdest 2402 411 20.0" 
$ns at 109.14492727237885 "$node_(20) setdest 1140 918 4.0" 
$ns at 166.58453163174855 "$node_(20) setdest 2132 390 3.0" 
$ns at 198.75581376409394 "$node_(20) setdest 2140 550 20.0" 
$ns at 324.8076705577051 "$node_(20) setdest 1744 565 3.0" 
$ns at 369.18977882847753 "$node_(20) setdest 488 868 4.0" 
$ns at 433.8969859565956 "$node_(20) setdest 2737 618 16.0" 
$ns at 554.3891437689634 "$node_(20) setdest 2089 280 7.0" 
$ns at 624.3400697095193 "$node_(20) setdest 1677 798 10.0" 
$ns at 676.5544834593702 "$node_(20) setdest 2455 418 16.0" 
$ns at 762.3913397125966 "$node_(20) setdest 1437 548 11.0" 
$ns at 832.0091931312102 "$node_(20) setdest 81 922 12.0" 
$ns at 0.0 "$node_(21) setdest 318 972 7.0" 
$ns at 32.7867679118567 "$node_(21) setdest 1380 525 19.0" 
$ns at 252.30330746241032 "$node_(21) setdest 2339 868 9.0" 
$ns at 312.88270375137597 "$node_(21) setdest 2337 769 8.0" 
$ns at 348.0656035407953 "$node_(21) setdest 2720 268 17.0" 
$ns at 418.2163652393705 "$node_(21) setdest 1760 921 7.0" 
$ns at 482.46987915511323 "$node_(21) setdest 2330 697 9.0" 
$ns at 513.4334883662641 "$node_(21) setdest 2812 938 10.0" 
$ns at 584.5420511816584 "$node_(21) setdest 638 608 8.0" 
$ns at 691.1227076569908 "$node_(21) setdest 2198 558 3.0" 
$ns at 745.9255089082133 "$node_(21) setdest 1432 709 2.0" 
$ns at 784.0631127620005 "$node_(21) setdest 175 836 3.0" 
$ns at 819.2158104954772 "$node_(21) setdest 346 117 13.0" 
$ns at 893.4616213184669 "$node_(21) setdest 2286 732 9.0" 
$ns at 0.0 "$node_(22) setdest 1962 571 3.0" 
$ns at 33.24081885761441 "$node_(22) setdest 2464 556 8.0" 
$ns at 87.98785349571867 "$node_(22) setdest 1019 145 3.0" 
$ns at 118.78100582151998 "$node_(22) setdest 918 375 8.0" 
$ns at 204.60145692202653 "$node_(22) setdest 1005 169 6.0" 
$ns at 286.874033548289 "$node_(22) setdest 2938 699 6.0" 
$ns at 317.4958103177602 "$node_(22) setdest 165 331 14.0" 
$ns at 422.5074194993483 "$node_(22) setdest 2542 31 17.0" 
$ns at 513.072106390717 "$node_(22) setdest 1690 139 1.0" 
$ns at 546.8280621939874 "$node_(22) setdest 599 121 5.0" 
$ns at 619.2823720351096 "$node_(22) setdest 626 227 17.0" 
$ns at 650.4618256247593 "$node_(22) setdest 2840 997 1.0" 
$ns at 681.0882148493642 "$node_(22) setdest 2778 199 8.0" 
$ns at 757.5300892561629 "$node_(22) setdest 907 107 3.0" 
$ns at 793.2148385134633 "$node_(22) setdest 2629 966 11.0" 
$ns at 0.0 "$node_(23) setdest 343 155 15.0" 
$ns at 149.5563065588844 "$node_(23) setdest 1061 787 8.0" 
$ns at 195.3039101217006 "$node_(23) setdest 1174 467 9.0" 
$ns at 254.60627700049807 "$node_(23) setdest 400 480 19.0" 
$ns at 371.2927209238187 "$node_(23) setdest 2484 963 4.0" 
$ns at 430.2086940940387 "$node_(23) setdest 2064 488 3.0" 
$ns at 483.3552340208554 "$node_(23) setdest 1142 65 6.0" 
$ns at 564.9521554648719 "$node_(23) setdest 2837 777 1.0" 
$ns at 600.3402161175989 "$node_(23) setdest 576 136 16.0" 
$ns at 729.8790608844347 "$node_(23) setdest 1559 771 6.0" 
$ns at 813.0197776743152 "$node_(23) setdest 1248 265 13.0" 
$ns at 0.0 "$node_(24) setdest 1739 761 14.0" 
$ns at 143.78561331301373 "$node_(24) setdest 2235 493 5.0" 
$ns at 189.71445517638628 "$node_(24) setdest 2389 527 16.0" 
$ns at 374.19388528459285 "$node_(24) setdest 2068 809 3.0" 
$ns at 404.68041436676464 "$node_(24) setdest 93 102 8.0" 
$ns at 459.19362400038 "$node_(24) setdest 2725 487 19.0" 
$ns at 601.2750070473242 "$node_(24) setdest 2095 901 17.0" 
$ns at 666.4610201042614 "$node_(24) setdest 446 620 5.0" 
$ns at 702.9271217912058 "$node_(24) setdest 2925 666 8.0" 
$ns at 791.2296098609182 "$node_(24) setdest 1746 903 8.0" 
$ns at 826.6311970286213 "$node_(24) setdest 858 933 7.0" 
$ns at 864.5792148238597 "$node_(24) setdest 1809 27 1.0" 
$ns at 895.061388568992 "$node_(24) setdest 2204 985 20.0" 
$ns at 0.0 "$node_(25) setdest 1146 239 19.0" 
$ns at 148.74886298517544 "$node_(25) setdest 1245 491 13.0" 
$ns at 197.87241343410938 "$node_(25) setdest 2165 921 1.0" 
$ns at 237.24085089308988 "$node_(25) setdest 2305 286 7.0" 
$ns at 312.99022249168445 "$node_(25) setdest 78 259 15.0" 
$ns at 456.18666004413114 "$node_(25) setdest 1268 12 9.0" 
$ns at 575.4994849235998 "$node_(25) setdest 1277 334 5.0" 
$ns at 632.6524817670253 "$node_(25) setdest 537 562 2.0" 
$ns at 679.2669499063421 "$node_(25) setdest 1083 223 14.0" 
$ns at 769.8082868769176 "$node_(25) setdest 245 543 9.0" 
$ns at 883.9060891117874 "$node_(25) setdest 536 941 17.0" 
$ns at 0.0 "$node_(26) setdest 2218 207 11.0" 
$ns at 103.28956537478234 "$node_(26) setdest 1606 294 4.0" 
$ns at 172.13694935481496 "$node_(26) setdest 978 576 14.0" 
$ns at 321.0853619044387 "$node_(26) setdest 2000 995 18.0" 
$ns at 411.71085104153366 "$node_(26) setdest 2821 688 6.0" 
$ns at 457.7017638759199 "$node_(26) setdest 2449 613 4.0" 
$ns at 502.1810281518996 "$node_(26) setdest 731 196 2.0" 
$ns at 538.3766884931489 "$node_(26) setdest 1134 182 1.0" 
$ns at 568.8758099027413 "$node_(26) setdest 1672 773 9.0" 
$ns at 649.1867611773055 "$node_(26) setdest 1658 566 5.0" 
$ns at 709.3850266916035 "$node_(26) setdest 2524 14 6.0" 
$ns at 757.3561345850994 "$node_(26) setdest 1715 902 4.0" 
$ns at 820.0055009643165 "$node_(26) setdest 703 815 11.0" 
$ns at 877.9578386105629 "$node_(26) setdest 2341 706 7.0" 
$ns at 0.0 "$node_(27) setdest 229 417 16.0" 
$ns at 37.52974658009124 "$node_(27) setdest 437 477 7.0" 
$ns at 86.21567251646756 "$node_(27) setdest 1776 581 1.0" 
$ns at 117.91413658121999 "$node_(27) setdest 2920 871 5.0" 
$ns at 176.6463895982292 "$node_(27) setdest 1983 605 15.0" 
$ns at 276.87832257357314 "$node_(27) setdest 2694 790 17.0" 
$ns at 386.876231083021 "$node_(27) setdest 1051 128 2.0" 
$ns at 425.27722547485774 "$node_(27) setdest 1318 961 13.0" 
$ns at 474.1814442313797 "$node_(27) setdest 399 940 10.0" 
$ns at 576.5452192340944 "$node_(27) setdest 2038 837 1.0" 
$ns at 615.6379957375659 "$node_(27) setdest 2920 244 14.0" 
$ns at 780.8486845506195 "$node_(27) setdest 2578 903 15.0" 
$ns at 0.0 "$node_(28) setdest 2094 88 2.0" 
$ns at 37.78845035538872 "$node_(28) setdest 2837 720 18.0" 
$ns at 192.58178670141768 "$node_(28) setdest 1003 920 3.0" 
$ns at 223.48398110374603 "$node_(28) setdest 1417 285 6.0" 
$ns at 265.52228937502053 "$node_(28) setdest 1022 464 12.0" 
$ns at 384.4329068431843 "$node_(28) setdest 602 550 6.0" 
$ns at 445.2596365208921 "$node_(28) setdest 2697 392 8.0" 
$ns at 545.3253426090118 "$node_(28) setdest 1216 166 6.0" 
$ns at 609.8905510505432 "$node_(28) setdest 2117 479 4.0" 
$ns at 665.8858776094515 "$node_(28) setdest 2504 794 10.0" 
$ns at 779.2699013441488 "$node_(28) setdest 2780 220 3.0" 
$ns at 822.6842580562314 "$node_(28) setdest 1934 568 8.0" 
$ns at 873.414946579801 "$node_(28) setdest 744 89 1.0" 
$ns at 0.0 "$node_(29) setdest 2577 529 12.0" 
$ns at 128.14986571433388 "$node_(29) setdest 588 927 17.0" 
$ns at 221.71082239460657 "$node_(29) setdest 468 133 2.0" 
$ns at 267.26456877456496 "$node_(29) setdest 458 140 4.0" 
$ns at 308.6592293781682 "$node_(29) setdest 98 137 12.0" 
$ns at 398.5863520945633 "$node_(29) setdest 2231 680 2.0" 
$ns at 445.3754352144114 "$node_(29) setdest 1939 470 11.0" 
$ns at 542.2588980593549 "$node_(29) setdest 1569 15 4.0" 
$ns at 588.1154019725475 "$node_(29) setdest 2656 913 20.0" 
$ns at 755.4207934635217 "$node_(29) setdest 388 531 18.0" 
$ns at 0.0 "$node_(30) setdest 1411 661 9.0" 
$ns at 109.86415437765771 "$node_(30) setdest 1027 90 10.0" 
$ns at 232.23296117521704 "$node_(30) setdest 402 112 15.0" 
$ns at 278.22843290171414 "$node_(30) setdest 2142 699 5.0" 
$ns at 315.1494953889712 "$node_(30) setdest 551 458 14.0" 
$ns at 431.2090170588052 "$node_(30) setdest 2097 479 14.0" 
$ns at 551.106819779514 "$node_(30) setdest 2984 911 14.0" 
$ns at 621.5078765423752 "$node_(30) setdest 1386 415 9.0" 
$ns at 651.7627014107366 "$node_(30) setdest 713 647 20.0" 
$ns at 849.7404422553154 "$node_(30) setdest 2360 583 15.0" 
$ns at 0.0 "$node_(31) setdest 2664 801 11.0" 
$ns at 105.18609888252907 "$node_(31) setdest 2286 804 17.0" 
$ns at 177.1266078229727 "$node_(31) setdest 963 90 1.0" 
$ns at 210.53718979298526 "$node_(31) setdest 514 948 16.0" 
$ns at 278.07003465609097 "$node_(31) setdest 121 905 1.0" 
$ns at 313.30925470620195 "$node_(31) setdest 2293 330 9.0" 
$ns at 348.12738768582716 "$node_(31) setdest 2532 944 11.0" 
$ns at 410.0633373847597 "$node_(31) setdest 2484 914 3.0" 
$ns at 449.7645275043288 "$node_(31) setdest 1432 724 1.0" 
$ns at 488.9741788592431 "$node_(31) setdest 2230 282 12.0" 
$ns at 578.5215647111968 "$node_(31) setdest 210 554 10.0" 
$ns at 649.2940887749037 "$node_(31) setdest 1340 567 11.0" 
$ns at 762.1151176388234 "$node_(31) setdest 2747 799 8.0" 
$ns at 848.1190285330026 "$node_(31) setdest 2920 818 1.0" 
$ns at 882.5984598494038 "$node_(31) setdest 1164 520 15.0" 
$ns at 0.0 "$node_(32) setdest 1529 495 1.0" 
$ns at 31.226562619354628 "$node_(32) setdest 137 815 6.0" 
$ns at 89.71007102987858 "$node_(32) setdest 1887 56 12.0" 
$ns at 162.44771344299045 "$node_(32) setdest 696 449 2.0" 
$ns at 194.61545373696669 "$node_(32) setdest 1910 843 19.0" 
$ns at 409.5536916959961 "$node_(32) setdest 2130 613 14.0" 
$ns at 503.79305304754087 "$node_(32) setdest 607 718 6.0" 
$ns at 556.5918746498394 "$node_(32) setdest 436 869 13.0" 
$ns at 598.671030736589 "$node_(32) setdest 2100 168 19.0" 
$ns at 636.9613147045756 "$node_(32) setdest 1432 644 14.0" 
$ns at 739.3472207503364 "$node_(32) setdest 2820 821 8.0" 
$ns at 800.6190231779084 "$node_(32) setdest 1462 829 15.0" 
$ns at 0.0 "$node_(33) setdest 626 594 5.0" 
$ns at 61.98494114255183 "$node_(33) setdest 327 335 1.0" 
$ns at 101.51878179502108 "$node_(33) setdest 2403 922 14.0" 
$ns at 178.64122432158146 "$node_(33) setdest 859 672 12.0" 
$ns at 209.90660327786588 "$node_(33) setdest 1391 774 4.0" 
$ns at 264.64479178745495 "$node_(33) setdest 1271 892 20.0" 
$ns at 402.33588411548715 "$node_(33) setdest 1296 417 11.0" 
$ns at 483.8361477296055 "$node_(33) setdest 2211 481 12.0" 
$ns at 560.2830869552777 "$node_(33) setdest 2941 139 18.0" 
$ns at 677.3707965885096 "$node_(33) setdest 151 20 6.0" 
$ns at 723.8474041995522 "$node_(33) setdest 1994 379 7.0" 
$ns at 818.9990100900056 "$node_(33) setdest 2523 708 10.0" 
$ns at 0.0 "$node_(34) setdest 2049 969 13.0" 
$ns at 42.52720647576208 "$node_(34) setdest 1750 75 14.0" 
$ns at 128.4640423293658 "$node_(34) setdest 89 463 1.0" 
$ns at 160.63395791905936 "$node_(34) setdest 2081 467 18.0" 
$ns at 270.88756181238966 "$node_(34) setdest 1101 740 6.0" 
$ns at 330.6596896226858 "$node_(34) setdest 1876 137 13.0" 
$ns at 377.3219395652288 "$node_(34) setdest 2381 347 5.0" 
$ns at 456.543332193125 "$node_(34) setdest 2743 17 2.0" 
$ns at 486.8214490572256 "$node_(34) setdest 2794 293 3.0" 
$ns at 526.9974066367153 "$node_(34) setdest 688 514 20.0" 
$ns at 683.5391335543825 "$node_(34) setdest 35 236 6.0" 
$ns at 757.6746549390971 "$node_(34) setdest 2166 907 17.0" 
$ns at 801.0591261341527 "$node_(34) setdest 2640 292 2.0" 
$ns at 839.9875935881216 "$node_(34) setdest 700 168 11.0" 
$ns at 0.0 "$node_(35) setdest 309 905 13.0" 
$ns at 142.02165449409594 "$node_(35) setdest 461 309 15.0" 
$ns at 276.63093057156163 "$node_(35) setdest 1783 487 6.0" 
$ns at 364.6453905366733 "$node_(35) setdest 2966 565 12.0" 
$ns at 513.9111832231683 "$node_(35) setdest 1333 802 10.0" 
$ns at 598.8665490690375 "$node_(35) setdest 2790 16 4.0" 
$ns at 645.2006543711672 "$node_(35) setdest 2618 273 13.0" 
$ns at 760.1783264794674 "$node_(35) setdest 2955 458 11.0" 
$ns at 805.4435327839849 "$node_(35) setdest 1447 699 18.0" 
$ns at 844.7428053255938 "$node_(35) setdest 1388 625 7.0" 
$ns at 891.0580438434743 "$node_(35) setdest 725 60 10.0" 
$ns at 0.0 "$node_(36) setdest 2605 86 2.0" 
$ns at 35.28665203999204 "$node_(36) setdest 2602 392 11.0" 
$ns at 155.45893671079511 "$node_(36) setdest 1526 391 11.0" 
$ns at 203.71268320976864 "$node_(36) setdest 1611 929 13.0" 
$ns at 234.6569101487738 "$node_(36) setdest 1064 311 1.0" 
$ns at 268.36977212536624 "$node_(36) setdest 315 955 12.0" 
$ns at 298.5439992773691 "$node_(36) setdest 2903 252 10.0" 
$ns at 393.7870004462426 "$node_(36) setdest 752 105 10.0" 
$ns at 450.8180948049886 "$node_(36) setdest 1609 166 7.0" 
$ns at 501.98626541563425 "$node_(36) setdest 684 38 1.0" 
$ns at 539.9898459399603 "$node_(36) setdest 973 545 6.0" 
$ns at 603.3234495385334 "$node_(36) setdest 456 717 1.0" 
$ns at 635.694687743282 "$node_(36) setdest 255 342 11.0" 
$ns at 708.6592248618588 "$node_(36) setdest 2963 728 12.0" 
$ns at 762.5739406496818 "$node_(36) setdest 705 878 17.0" 
$ns at 811.3848905106871 "$node_(36) setdest 2028 369 12.0" 
$ns at 0.0 "$node_(37) setdest 2543 93 3.0" 
$ns at 40.357970898179 "$node_(37) setdest 195 447 2.0" 
$ns at 81.29568555693342 "$node_(37) setdest 2277 696 9.0" 
$ns at 144.44677331082175 "$node_(37) setdest 1741 3 8.0" 
$ns at 209.19264742564934 "$node_(37) setdest 1017 72 15.0" 
$ns at 370.75041521382934 "$node_(37) setdest 2402 411 13.0" 
$ns at 466.72078433289533 "$node_(37) setdest 2204 8 15.0" 
$ns at 590.6056869915558 "$node_(37) setdest 1122 570 19.0" 
$ns at 698.0433997339163 "$node_(37) setdest 1875 584 7.0" 
$ns at 767.2915977593372 "$node_(37) setdest 2833 134 7.0" 
$ns at 858.4827989990048 "$node_(37) setdest 2400 801 6.0" 
$ns at 0.0 "$node_(38) setdest 44 998 5.0" 
$ns at 71.07854264236573 "$node_(38) setdest 314 779 9.0" 
$ns at 140.3435248070016 "$node_(38) setdest 2777 487 5.0" 
$ns at 207.61089599333104 "$node_(38) setdest 1672 622 6.0" 
$ns at 241.7238474753389 "$node_(38) setdest 1122 962 3.0" 
$ns at 286.06706954027425 "$node_(38) setdest 2054 255 2.0" 
$ns at 333.0428004302719 "$node_(38) setdest 427 802 10.0" 
$ns at 419.4772593727905 "$node_(38) setdest 1147 842 13.0" 
$ns at 553.3427433212806 "$node_(38) setdest 2926 954 16.0" 
$ns at 707.1385965528327 "$node_(38) setdest 2542 598 4.0" 
$ns at 738.1721370844936 "$node_(38) setdest 2304 534 9.0" 
$ns at 815.1879088424525 "$node_(38) setdest 1139 89 11.0" 
$ns at 889.2386680915853 "$node_(38) setdest 1498 155 17.0" 
$ns at 0.0 "$node_(39) setdest 348 344 4.0" 
$ns at 65.7512988635952 "$node_(39) setdest 1745 969 17.0" 
$ns at 235.99207267627446 "$node_(39) setdest 2939 364 12.0" 
$ns at 321.5320075246758 "$node_(39) setdest 1673 606 16.0" 
$ns at 365.6597057034938 "$node_(39) setdest 1238 865 9.0" 
$ns at 452.54377023639415 "$node_(39) setdest 942 483 7.0" 
$ns at 505.02566669002965 "$node_(39) setdest 2045 327 13.0" 
$ns at 556.3760198111506 "$node_(39) setdest 722 181 7.0" 
$ns at 631.1593055763825 "$node_(39) setdest 2431 686 18.0" 
$ns at 744.9968494543069 "$node_(39) setdest 45 852 8.0" 
$ns at 854.7424518827106 "$node_(39) setdest 1328 260 19.0" 
$ns at 0.0 "$node_(40) setdest 2786 862 18.0" 
$ns at 121.0750993009831 "$node_(40) setdest 545 720 1.0" 
$ns at 153.04211936035736 "$node_(40) setdest 2823 118 7.0" 
$ns at 241.1648450082431 "$node_(40) setdest 628 211 16.0" 
$ns at 306.7582160227624 "$node_(40) setdest 2634 811 6.0" 
$ns at 376.04988692370193 "$node_(40) setdest 716 938 17.0" 
$ns at 571.3650473976492 "$node_(40) setdest 1379 496 11.0" 
$ns at 657.7051029251052 "$node_(40) setdest 280 806 1.0" 
$ns at 692.3276657170964 "$node_(40) setdest 221 748 20.0" 
$ns at 818.5477652161405 "$node_(40) setdest 1416 954 11.0" 
$ns at 0.0 "$node_(41) setdest 1433 837 5.0" 
$ns at 56.38166875354631 "$node_(41) setdest 2082 241 19.0" 
$ns at 228.30855616402098 "$node_(41) setdest 2557 125 15.0" 
$ns at 334.49703457801377 "$node_(41) setdest 1438 48 8.0" 
$ns at 385.36965396499585 "$node_(41) setdest 2649 149 19.0" 
$ns at 434.8662010263683 "$node_(41) setdest 189 950 10.0" 
$ns at 534.9982585956957 "$node_(41) setdest 2383 601 1.0" 
$ns at 567.0204003689952 "$node_(41) setdest 578 106 8.0" 
$ns at 601.5484568475591 "$node_(41) setdest 1539 651 17.0" 
$ns at 718.7563952050356 "$node_(41) setdest 2446 446 5.0" 
$ns at 771.6647512109771 "$node_(41) setdest 1162 325 12.0" 
$ns at 850.0110579642906 "$node_(41) setdest 1492 985 1.0" 
$ns at 886.7049651226818 "$node_(41) setdest 408 899 19.0" 
$ns at 0.0 "$node_(42) setdest 2653 844 3.0" 
$ns at 43.12812871026386 "$node_(42) setdest 2866 509 14.0" 
$ns at 193.8830276508937 "$node_(42) setdest 2241 814 17.0" 
$ns at 369.019081304859 "$node_(42) setdest 2869 442 12.0" 
$ns at 469.98798940690267 "$node_(42) setdest 1258 549 3.0" 
$ns at 503.41209267272916 "$node_(42) setdest 1087 808 3.0" 
$ns at 545.4834916023748 "$node_(42) setdest 2018 708 2.0" 
$ns at 582.0638322328882 "$node_(42) setdest 414 548 6.0" 
$ns at 667.8567578566106 "$node_(42) setdest 996 634 18.0" 
$ns at 746.8557266882432 "$node_(42) setdest 2942 2 1.0" 
$ns at 778.6605286299292 "$node_(42) setdest 557 415 7.0" 
$ns at 823.8257425088711 "$node_(42) setdest 2539 467 19.0" 
$ns at 0.0 "$node_(43) setdest 2948 379 5.0" 
$ns at 42.502377469437604 "$node_(43) setdest 1301 476 17.0" 
$ns at 169.9525201226009 "$node_(43) setdest 1732 390 17.0" 
$ns at 321.59887696462545 "$node_(43) setdest 935 748 14.0" 
$ns at 421.42829964799245 "$node_(43) setdest 1543 496 2.0" 
$ns at 464.861746808915 "$node_(43) setdest 1808 1 11.0" 
$ns at 513.5805453865202 "$node_(43) setdest 1830 788 4.0" 
$ns at 564.2187572407382 "$node_(43) setdest 1231 113 19.0" 
$ns at 598.2478870912202 "$node_(43) setdest 988 528 4.0" 
$ns at 634.9414553404165 "$node_(43) setdest 1223 313 8.0" 
$ns at 695.5008874045857 "$node_(43) setdest 17 893 11.0" 
$ns at 775.1364055593469 "$node_(43) setdest 802 373 17.0" 
$ns at 0.0 "$node_(44) setdest 636 919 18.0" 
$ns at 134.78715200102653 "$node_(44) setdest 2570 2 18.0" 
$ns at 193.93634164228644 "$node_(44) setdest 2479 460 5.0" 
$ns at 268.3539281144803 "$node_(44) setdest 1127 902 11.0" 
$ns at 381.4404892073303 "$node_(44) setdest 1786 266 18.0" 
$ns at 442.5794810711469 "$node_(44) setdest 2585 192 2.0" 
$ns at 479.3875684007018 "$node_(44) setdest 753 493 1.0" 
$ns at 512.951311039814 "$node_(44) setdest 2213 156 2.0" 
$ns at 551.9659776715312 "$node_(44) setdest 1414 242 9.0" 
$ns at 608.403712865085 "$node_(44) setdest 988 526 5.0" 
$ns at 642.0456966193663 "$node_(44) setdest 741 947 6.0" 
$ns at 726.8446542601025 "$node_(44) setdest 1579 748 14.0" 
$ns at 793.809589957635 "$node_(44) setdest 1340 700 16.0" 
$ns at 834.8169910332578 "$node_(44) setdest 49 951 11.0" 
$ns at 0.0 "$node_(45) setdest 1904 850 9.0" 
$ns at 97.61545952217112 "$node_(45) setdest 2288 566 13.0" 
$ns at 235.28853335358764 "$node_(45) setdest 1330 444 11.0" 
$ns at 326.31189049313286 "$node_(45) setdest 1970 805 18.0" 
$ns at 523.1988455131518 "$node_(45) setdest 141 358 3.0" 
$ns at 569.3953990441776 "$node_(45) setdest 1548 456 18.0" 
$ns at 756.5515646509672 "$node_(45) setdest 1628 187 12.0" 
$ns at 893.421924233085 "$node_(45) setdest 2574 704 3.0" 
$ns at 0.0 "$node_(46) setdest 853 233 5.0" 
$ns at 30.396616777497616 "$node_(46) setdest 368 937 5.0" 
$ns at 98.23732295020135 "$node_(46) setdest 1425 175 2.0" 
$ns at 146.95499848403 "$node_(46) setdest 806 729 4.0" 
$ns at 202.0303979687207 "$node_(46) setdest 1691 244 7.0" 
$ns at 250.46913930096503 "$node_(46) setdest 2772 483 19.0" 
$ns at 349.1438478345914 "$node_(46) setdest 759 993 8.0" 
$ns at 450.9456346826029 "$node_(46) setdest 1533 414 9.0" 
$ns at 522.7962039400351 "$node_(46) setdest 486 996 8.0" 
$ns at 580.9354327073478 "$node_(46) setdest 74 848 1.0" 
$ns at 619.447457975237 "$node_(46) setdest 1352 45 13.0" 
$ns at 707.238058266267 "$node_(46) setdest 1166 36 2.0" 
$ns at 756.6841212260141 "$node_(46) setdest 2860 691 3.0" 
$ns at 803.2535965450367 "$node_(46) setdest 1705 941 20.0" 
$ns at 0.0 "$node_(47) setdest 1873 207 9.0" 
$ns at 103.02024203065865 "$node_(47) setdest 2578 705 8.0" 
$ns at 183.95330661773664 "$node_(47) setdest 1028 300 17.0" 
$ns at 369.2186522968391 "$node_(47) setdest 108 756 13.0" 
$ns at 418.41262488594236 "$node_(47) setdest 1147 160 6.0" 
$ns at 471.75869310016583 "$node_(47) setdest 838 755 18.0" 
$ns at 669.5929852705935 "$node_(47) setdest 277 675 8.0" 
$ns at 741.5813168989318 "$node_(47) setdest 187 850 14.0" 
$ns at 856.39071218662 "$node_(47) setdest 1784 897 19.0" 
$ns at 0.0 "$node_(48) setdest 1255 934 19.0" 
$ns at 84.67308844627432 "$node_(48) setdest 1629 83 4.0" 
$ns at 115.88370333168534 "$node_(48) setdest 809 872 14.0" 
$ns at 259.53778090311994 "$node_(48) setdest 751 906 9.0" 
$ns at 333.91984938132595 "$node_(48) setdest 2220 899 16.0" 
$ns at 390.3967874358978 "$node_(48) setdest 2193 657 1.0" 
$ns at 429.1554523197381 "$node_(48) setdest 1878 645 19.0" 
$ns at 636.3501806226298 "$node_(48) setdest 1378 527 11.0" 
$ns at 748.2936127578378 "$node_(48) setdest 1372 505 16.0" 
$ns at 899.4116107817983 "$node_(48) setdest 2695 290 17.0" 
$ns at 0.0 "$node_(49) setdest 2453 293 10.0" 
$ns at 39.68316302046036 "$node_(49) setdest 286 988 7.0" 
$ns at 87.86122418406121 "$node_(49) setdest 2559 405 2.0" 
$ns at 133.65204410661352 "$node_(49) setdest 2692 434 12.0" 
$ns at 170.07676882695444 "$node_(49) setdest 435 929 7.0" 
$ns at 213.8268098271236 "$node_(49) setdest 1764 615 4.0" 
$ns at 250.802196800565 "$node_(49) setdest 1116 438 11.0" 
$ns at 384.9555444410284 "$node_(49) setdest 2976 343 1.0" 
$ns at 423.71413682879484 "$node_(49) setdest 1309 382 11.0" 
$ns at 514.3547671842979 "$node_(49) setdest 1070 716 12.0" 
$ns at 614.6183277917672 "$node_(49) setdest 2947 330 20.0" 
$ns at 725.1984928460854 "$node_(49) setdest 1651 233 7.0" 
$ns at 803.2298718231924 "$node_(49) setdest 1442 482 9.0" 
$ns at 0.0 "$node_(50) setdest 1168 644 11.0" 
$ns at 91.43829893872945 "$node_(50) setdest 918 186 19.0" 
$ns at 305.5666621585767 "$node_(50) setdest 403 865 13.0" 
$ns at 404.5033603144196 "$node_(50) setdest 1444 396 4.0" 
$ns at 453.59156212349086 "$node_(50) setdest 1398 537 17.0" 
$ns at 589.912717881484 "$node_(50) setdest 57 291 10.0" 
$ns at 655.3777231373375 "$node_(50) setdest 1448 65 18.0" 
$ns at 731.9773686647465 "$node_(50) setdest 86 510 19.0" 
$ns at 172.74809318093776 "$node_(51) setdest 274 367 11.0" 
$ns at 272.94310512767055 "$node_(51) setdest 2059 827 18.0" 
$ns at 466.0861740387608 "$node_(51) setdest 2638 158 12.0" 
$ns at 527.9063589309258 "$node_(51) setdest 1423 323 2.0" 
$ns at 558.7160048320002 "$node_(51) setdest 1587 153 2.0" 
$ns at 595.684746864782 "$node_(51) setdest 1160 507 17.0" 
$ns at 767.2811669620984 "$node_(51) setdest 81 761 11.0" 
$ns at 866.2766662345299 "$node_(51) setdest 2561 909 6.0" 
$ns at 276.4989170036898 "$node_(52) setdest 2090 625 3.0" 
$ns at 314.3017736610954 "$node_(52) setdest 380 242 15.0" 
$ns at 447.3408585391967 "$node_(52) setdest 2369 835 17.0" 
$ns at 630.9738142695802 "$node_(52) setdest 2819 516 14.0" 
$ns at 778.9378419036643 "$node_(52) setdest 2057 695 16.0" 
$ns at 172.23014759701215 "$node_(53) setdest 1092 922 19.0" 
$ns at 303.6914397943966 "$node_(53) setdest 2037 299 19.0" 
$ns at 382.02987242966 "$node_(53) setdest 2881 669 8.0" 
$ns at 453.5386448375119 "$node_(53) setdest 349 328 17.0" 
$ns at 498.8953728090514 "$node_(53) setdest 1148 679 1.0" 
$ns at 535.1826480077316 "$node_(53) setdest 978 458 14.0" 
$ns at 699.0933844085628 "$node_(53) setdest 2339 655 9.0" 
$ns at 769.4510817257147 "$node_(53) setdest 1128 224 19.0" 
$ns at 182.90678947747338 "$node_(54) setdest 2226 736 3.0" 
$ns at 230.30164997008944 "$node_(54) setdest 1566 826 8.0" 
$ns at 337.1976679250049 "$node_(54) setdest 2431 95 16.0" 
$ns at 488.22516644894495 "$node_(54) setdest 2135 885 16.0" 
$ns at 630.6232072892964 "$node_(54) setdest 423 605 12.0" 
$ns at 709.5060507630477 "$node_(54) setdest 1763 704 13.0" 
$ns at 810.4992928149754 "$node_(54) setdest 2353 267 15.0" 
$ns at 248.38821916549193 "$node_(55) setdest 2554 227 2.0" 
$ns at 285.95407349222467 "$node_(55) setdest 1440 969 9.0" 
$ns at 345.73069396098936 "$node_(55) setdest 201 357 14.0" 
$ns at 474.22132882398483 "$node_(55) setdest 1007 803 1.0" 
$ns at 507.47109903176477 "$node_(55) setdest 1423 966 2.0" 
$ns at 557.2080632934656 "$node_(55) setdest 1701 240 15.0" 
$ns at 679.199605114023 "$node_(55) setdest 2546 20 4.0" 
$ns at 729.4558759501954 "$node_(55) setdest 1940 563 16.0" 
$ns at 865.1007368365815 "$node_(55) setdest 2706 903 5.0" 
$ns at 169.22020267561135 "$node_(56) setdest 1619 937 16.0" 
$ns at 271.88651382669474 "$node_(56) setdest 2733 998 18.0" 
$ns at 472.24008734312326 "$node_(56) setdest 2717 225 3.0" 
$ns at 519.6032648102305 "$node_(56) setdest 2973 86 20.0" 
$ns at 692.713997189367 "$node_(56) setdest 586 196 16.0" 
$ns at 855.2258413007341 "$node_(56) setdest 721 259 3.0" 
$ns at 262.9598133466715 "$node_(57) setdest 2377 645 9.0" 
$ns at 296.7107991669364 "$node_(57) setdest 2405 359 15.0" 
$ns at 425.52876385638126 "$node_(57) setdest 738 90 16.0" 
$ns at 536.0798528032267 "$node_(57) setdest 1707 446 10.0" 
$ns at 567.7554893537996 "$node_(57) setdest 2552 492 6.0" 
$ns at 608.459123010228 "$node_(57) setdest 268 207 20.0" 
$ns at 679.7051094965475 "$node_(57) setdest 1998 197 13.0" 
$ns at 714.6233293197896 "$node_(57) setdest 1390 229 18.0" 
$ns at 817.172264875769 "$node_(57) setdest 724 907 12.0" 
$ns at 880.5763185138428 "$node_(57) setdest 1313 308 15.0" 
$ns at 200.73827186542835 "$node_(58) setdest 2115 529 6.0" 
$ns at 275.77381848235865 "$node_(58) setdest 8 875 20.0" 
$ns at 431.3306430687471 "$node_(58) setdest 2939 448 13.0" 
$ns at 465.19681867972207 "$node_(58) setdest 2209 299 2.0" 
$ns at 501.1124835333215 "$node_(58) setdest 1935 279 16.0" 
$ns at 674.9640722035863 "$node_(58) setdest 1904 850 15.0" 
$ns at 734.92338587029 "$node_(58) setdest 653 673 6.0" 
$ns at 815.3851721364913 "$node_(58) setdest 844 172 2.0" 
$ns at 859.1400459941474 "$node_(58) setdest 2060 973 15.0" 
$ns at 898.4595000026569 "$node_(58) setdest 441 362 15.0" 
$ns at 171.25807628523117 "$node_(59) setdest 704 223 3.0" 
$ns at 203.0448390112865 "$node_(59) setdest 1522 239 7.0" 
$ns at 293.59491178774636 "$node_(59) setdest 1439 106 20.0" 
$ns at 399.6696849023311 "$node_(59) setdest 243 154 13.0" 
$ns at 495.4318034850101 "$node_(59) setdest 2151 420 18.0" 
$ns at 541.7732768876498 "$node_(59) setdest 1309 229 1.0" 
$ns at 572.6304023748685 "$node_(59) setdest 766 148 11.0" 
$ns at 615.087040851843 "$node_(59) setdest 692 805 13.0" 
$ns at 693.34096653337 "$node_(59) setdest 1097 947 19.0" 
$ns at 791.1805931169233 "$node_(59) setdest 972 637 7.0" 
$ns at 865.5771249455937 "$node_(59) setdest 699 661 1.0" 
$ns at 203.51726621123942 "$node_(60) setdest 462 75 2.0" 
$ns at 243.8777210879481 "$node_(60) setdest 1627 7 1.0" 
$ns at 277.0260175000156 "$node_(60) setdest 2878 278 12.0" 
$ns at 318.3383202014321 "$node_(60) setdest 245 384 14.0" 
$ns at 443.85256742699306 "$node_(60) setdest 1448 166 3.0" 
$ns at 481.70470745165323 "$node_(60) setdest 2029 175 1.0" 
$ns at 514.8322823105641 "$node_(60) setdest 47 597 16.0" 
$ns at 701.7764701976002 "$node_(60) setdest 2553 167 2.0" 
$ns at 732.9714412073527 "$node_(60) setdest 1628 564 11.0" 
$ns at 821.8199281838794 "$node_(60) setdest 1477 476 7.0" 
$ns at 890.818309583849 "$node_(60) setdest 1072 919 13.0" 
$ns at 211.01880137699237 "$node_(61) setdest 1382 225 4.0" 
$ns at 262.7006042472783 "$node_(61) setdest 65 94 13.0" 
$ns at 400.28261682696206 "$node_(61) setdest 1700 485 2.0" 
$ns at 443.5437151510257 "$node_(61) setdest 2265 755 13.0" 
$ns at 494.88354409405656 "$node_(61) setdest 1631 777 3.0" 
$ns at 539.1759482434998 "$node_(61) setdest 383 291 18.0" 
$ns at 731.059492791333 "$node_(61) setdest 903 36 14.0" 
$ns at 816.2143897912331 "$node_(61) setdest 2874 906 9.0" 
$ns at 891.7252122111677 "$node_(61) setdest 2166 236 8.0" 
$ns at 168.56697269477934 "$node_(62) setdest 1927 284 3.0" 
$ns at 211.91684174959508 "$node_(62) setdest 644 419 14.0" 
$ns at 354.7803454193706 "$node_(62) setdest 1297 762 1.0" 
$ns at 390.53489497459117 "$node_(62) setdest 1636 358 19.0" 
$ns at 469.18074170031446 "$node_(62) setdest 2766 324 16.0" 
$ns at 601.4311527799623 "$node_(62) setdest 235 61 2.0" 
$ns at 639.365765152694 "$node_(62) setdest 2939 954 11.0" 
$ns at 761.9674683193061 "$node_(62) setdest 1180 924 1.0" 
$ns at 796.7254875302515 "$node_(62) setdest 642 996 10.0" 
$ns at 289.69242972248594 "$node_(63) setdest 116 596 10.0" 
$ns at 373.15967688639785 "$node_(63) setdest 2576 13 19.0" 
$ns at 406.3144709671633 "$node_(63) setdest 2699 266 13.0" 
$ns at 442.30220293785925 "$node_(63) setdest 1411 123 10.0" 
$ns at 492.42679010247235 "$node_(63) setdest 474 287 10.0" 
$ns at 558.8098554888676 "$node_(63) setdest 101 864 11.0" 
$ns at 685.0451051945848 "$node_(63) setdest 389 280 16.0" 
$ns at 834.7482551690457 "$node_(63) setdest 2917 666 20.0" 
$ns at 237.82568128263534 "$node_(64) setdest 184 913 6.0" 
$ns at 286.36420032909933 "$node_(64) setdest 2051 4 2.0" 
$ns at 319.8290464428966 "$node_(64) setdest 2517 886 6.0" 
$ns at 371.67218527852805 "$node_(64) setdest 348 500 9.0" 
$ns at 468.2980857730557 "$node_(64) setdest 2774 398 3.0" 
$ns at 502.73029562268727 "$node_(64) setdest 2781 183 16.0" 
$ns at 591.5527112485755 "$node_(64) setdest 2412 549 2.0" 
$ns at 627.1996195715951 "$node_(64) setdest 2272 103 13.0" 
$ns at 729.9495406152574 "$node_(64) setdest 95 667 11.0" 
$ns at 857.6656718083509 "$node_(64) setdest 147 967 1.0" 
$ns at 894.5279018132629 "$node_(64) setdest 1381 447 10.0" 
$ns at 167.80410069782533 "$node_(65) setdest 1743 805 14.0" 
$ns at 201.82618488277782 "$node_(65) setdest 2007 610 4.0" 
$ns at 254.42195453316987 "$node_(65) setdest 2964 928 1.0" 
$ns at 287.78574869584804 "$node_(65) setdest 1825 855 2.0" 
$ns at 320.5244602923005 "$node_(65) setdest 875 727 10.0" 
$ns at 380.57215345698785 "$node_(65) setdest 1985 814 3.0" 
$ns at 437.44399258778793 "$node_(65) setdest 2624 874 6.0" 
$ns at 515.2491512733972 "$node_(65) setdest 1556 802 3.0" 
$ns at 564.0614538686049 "$node_(65) setdest 1905 664 9.0" 
$ns at 624.4643859070895 "$node_(65) setdest 1061 144 13.0" 
$ns at 667.3501902200912 "$node_(65) setdest 1827 770 3.0" 
$ns at 705.1384707478836 "$node_(65) setdest 2409 349 9.0" 
$ns at 767.4995178642863 "$node_(65) setdest 280 698 19.0" 
$ns at 197.0519184808095 "$node_(66) setdest 1018 878 4.0" 
$ns at 259.9113415961725 "$node_(66) setdest 2747 734 4.0" 
$ns at 327.12659306254153 "$node_(66) setdest 2785 846 4.0" 
$ns at 394.20608541280353 "$node_(66) setdest 2735 272 4.0" 
$ns at 462.3201549979677 "$node_(66) setdest 2512 756 20.0" 
$ns at 659.0112648689426 "$node_(66) setdest 2242 98 20.0" 
$ns at 784.6878994253317 "$node_(66) setdest 434 773 3.0" 
$ns at 823.6819152583305 "$node_(66) setdest 529 871 12.0" 
$ns at 268.7708287278811 "$node_(67) setdest 1075 81 13.0" 
$ns at 303.94812737705587 "$node_(67) setdest 1173 861 12.0" 
$ns at 343.4044191019644 "$node_(67) setdest 179 290 7.0" 
$ns at 380.216094132686 "$node_(67) setdest 2010 752 11.0" 
$ns at 498.71358589897744 "$node_(67) setdest 2276 410 13.0" 
$ns at 612.0818677615803 "$node_(67) setdest 1453 158 2.0" 
$ns at 661.0655656540305 "$node_(67) setdest 83 227 5.0" 
$ns at 695.1575331118164 "$node_(67) setdest 1060 485 18.0" 
$ns at 737.3536755193999 "$node_(67) setdest 1272 641 4.0" 
$ns at 777.7008175768303 "$node_(67) setdest 294 318 19.0" 
$ns at 879.7653231158787 "$node_(67) setdest 1512 387 6.0" 
$ns at 180.06600023747396 "$node_(68) setdest 1424 644 6.0" 
$ns at 226.55915321287108 "$node_(68) setdest 2052 222 1.0" 
$ns at 264.8216216498636 "$node_(68) setdest 881 594 4.0" 
$ns at 316.9245477293391 "$node_(68) setdest 1873 99 6.0" 
$ns at 352.12691716427344 "$node_(68) setdest 2210 552 3.0" 
$ns at 412.08287931602877 "$node_(68) setdest 2042 222 2.0" 
$ns at 457.9528236824397 "$node_(68) setdest 1422 884 5.0" 
$ns at 524.3688257163464 "$node_(68) setdest 2744 731 18.0" 
$ns at 705.050296256746 "$node_(68) setdest 440 930 18.0" 
$ns at 866.4722316794114 "$node_(68) setdest 475 211 6.0" 
$ns at 899.6108876793036 "$node_(68) setdest 37 162 7.0" 
$ns at 310.22227266608473 "$node_(69) setdest 2122 404 1.0" 
$ns at 344.0589036109683 "$node_(69) setdest 1547 777 7.0" 
$ns at 374.37268323213726 "$node_(69) setdest 2077 713 17.0" 
$ns at 420.661550164605 "$node_(69) setdest 2783 399 15.0" 
$ns at 568.2281820959868 "$node_(69) setdest 2702 647 2.0" 
$ns at 602.3052702103753 "$node_(69) setdest 702 940 5.0" 
$ns at 673.864298640759 "$node_(69) setdest 1769 26 2.0" 
$ns at 715.9658160863288 "$node_(69) setdest 1538 605 8.0" 
$ns at 795.9559310830109 "$node_(69) setdest 2266 166 1.0" 
$ns at 829.8984679365062 "$node_(69) setdest 972 160 12.0" 
$ns at 295.61238453512595 "$node_(70) setdest 2517 6 8.0" 
$ns at 375.1581082339063 "$node_(70) setdest 1145 989 2.0" 
$ns at 418.6846312970468 "$node_(70) setdest 14 778 10.0" 
$ns at 476.9864642199683 "$node_(70) setdest 2430 147 4.0" 
$ns at 537.6031839610464 "$node_(70) setdest 1564 638 15.0" 
$ns at 662.5404799905838 "$node_(70) setdest 2236 563 17.0" 
$ns at 711.0915676163418 "$node_(70) setdest 1899 313 2.0" 
$ns at 748.4715768143542 "$node_(70) setdest 2221 804 15.0" 
$ns at 218.4156715797273 "$node_(71) setdest 1137 52 6.0" 
$ns at 287.1539628504986 "$node_(71) setdest 2047 162 16.0" 
$ns at 356.1766485090239 "$node_(71) setdest 1973 285 4.0" 
$ns at 396.5804779836703 "$node_(71) setdest 530 868 19.0" 
$ns at 427.893417449339 "$node_(71) setdest 402 183 3.0" 
$ns at 482.5490423283291 "$node_(71) setdest 564 58 9.0" 
$ns at 547.5279557479248 "$node_(71) setdest 276 733 7.0" 
$ns at 583.9835946256403 "$node_(71) setdest 1938 860 7.0" 
$ns at 636.3844307332316 "$node_(71) setdest 2230 247 15.0" 
$ns at 728.8502601192773 "$node_(71) setdest 2580 201 15.0" 
$ns at 192.20778794651108 "$node_(72) setdest 2937 641 5.0" 
$ns at 240.02383394240178 "$node_(72) setdest 2690 468 9.0" 
$ns at 297.47680832799415 "$node_(72) setdest 2065 977 19.0" 
$ns at 452.9568494631242 "$node_(72) setdest 11 468 17.0" 
$ns at 590.3314144319745 "$node_(72) setdest 2605 242 5.0" 
$ns at 624.6410810148669 "$node_(72) setdest 2515 503 10.0" 
$ns at 707.470930025633 "$node_(72) setdest 1843 908 8.0" 
$ns at 804.5726913806756 "$node_(72) setdest 1311 169 8.0" 
$ns at 876.9650751638317 "$node_(72) setdest 2809 593 9.0" 
$ns at 231.66721791115003 "$node_(73) setdest 583 135 16.0" 
$ns at 297.2299072063556 "$node_(73) setdest 2906 639 12.0" 
$ns at 429.6804171980642 "$node_(73) setdest 86 508 1.0" 
$ns at 465.4456557265576 "$node_(73) setdest 1274 878 2.0" 
$ns at 514.818884344941 "$node_(73) setdest 1242 419 5.0" 
$ns at 547.5478849446496 "$node_(73) setdest 2373 515 7.0" 
$ns at 647.3037184398341 "$node_(73) setdest 1960 538 3.0" 
$ns at 689.2976664190954 "$node_(73) setdest 2803 856 10.0" 
$ns at 812.9694664565232 "$node_(73) setdest 2535 891 14.0" 
$ns at 896.3506653020601 "$node_(73) setdest 1712 884 6.0" 
$ns at 171.51603125124709 "$node_(74) setdest 603 18 16.0" 
$ns at 346.22368933170833 "$node_(74) setdest 2836 821 1.0" 
$ns at 376.4139439255821 "$node_(74) setdest 1595 251 15.0" 
$ns at 472.6253387415764 "$node_(74) setdest 2460 274 15.0" 
$ns at 529.3476976887598 "$node_(74) setdest 1107 79 5.0" 
$ns at 591.3644367812612 "$node_(74) setdest 2914 262 1.0" 
$ns at 627.235734156947 "$node_(74) setdest 523 122 7.0" 
$ns at 706.5712454120879 "$node_(74) setdest 934 12 9.0" 
$ns at 752.0866658240777 "$node_(74) setdest 205 552 7.0" 
$ns at 791.931311096689 "$node_(74) setdest 1486 38 2.0" 
$ns at 837.5648760645496 "$node_(74) setdest 2057 561 3.0" 
$ns at 881.2288561105354 "$node_(74) setdest 125 209 9.0" 
$ns at 361.7687899840809 "$node_(75) setdest 1648 700 9.0" 
$ns at 409.25819067558075 "$node_(75) setdest 496 698 7.0" 
$ns at 494.17972726170007 "$node_(75) setdest 750 833 13.0" 
$ns at 620.1018084515127 "$node_(75) setdest 2227 8 1.0" 
$ns at 659.7153923062594 "$node_(75) setdest 1707 854 2.0" 
$ns at 690.3091499882602 "$node_(75) setdest 721 668 1.0" 
$ns at 722.8218015584118 "$node_(75) setdest 2453 259 5.0" 
$ns at 793.2300154351893 "$node_(75) setdest 1662 424 5.0" 
$ns at 871.6340000817816 "$node_(75) setdest 2118 123 6.0" 
$ns at 447.60593472280175 "$node_(76) setdest 696 221 14.0" 
$ns at 487.00817704754746 "$node_(76) setdest 1653 570 16.0" 
$ns at 651.0261220312691 "$node_(76) setdest 1393 951 9.0" 
$ns at 688.509098301397 "$node_(76) setdest 2576 837 9.0" 
$ns at 744.7754206471529 "$node_(76) setdest 1178 56 16.0" 
$ns at 812.9110820274284 "$node_(76) setdest 1033 249 16.0" 
$ns at 851.2135570338633 "$node_(76) setdest 35 189 9.0" 
$ns at 891.1406022321338 "$node_(76) setdest 123 904 16.0" 
$ns at 337.15501611632453 "$node_(77) setdest 402 803 4.0" 
$ns at 395.6510425477435 "$node_(77) setdest 2119 33 2.0" 
$ns at 443.0801675049295 "$node_(77) setdest 649 311 17.0" 
$ns at 474.221768183507 "$node_(77) setdest 2821 4 18.0" 
$ns at 568.8634544582459 "$node_(77) setdest 1784 213 2.0" 
$ns at 616.1878426010833 "$node_(77) setdest 2018 47 8.0" 
$ns at 724.4227183501482 "$node_(77) setdest 1245 474 3.0" 
$ns at 768.4143499286187 "$node_(77) setdest 2729 32 19.0" 
$ns at 367.69463626255686 "$node_(78) setdest 627 62 15.0" 
$ns at 444.6926130316003 "$node_(78) setdest 316 655 18.0" 
$ns at 581.265296863306 "$node_(78) setdest 2505 453 3.0" 
$ns at 630.9015323064465 "$node_(78) setdest 2488 546 1.0" 
$ns at 669.8762949750029 "$node_(78) setdest 2414 902 1.0" 
$ns at 704.5379904530404 "$node_(78) setdest 2813 328 20.0" 
$ns at 743.9273982569825 "$node_(78) setdest 2308 545 16.0" 
$ns at 888.1866699215818 "$node_(78) setdest 822 679 1.0" 
$ns at 331.6698771526921 "$node_(79) setdest 1479 2 1.0" 
$ns at 371.15219331344497 "$node_(79) setdest 2588 249 1.0" 
$ns at 410.3917750781545 "$node_(79) setdest 622 493 17.0" 
$ns at 484.9032747674303 "$node_(79) setdest 1487 749 13.0" 
$ns at 630.7962301391906 "$node_(79) setdest 597 869 16.0" 
$ns at 711.3905818075507 "$node_(79) setdest 1158 599 12.0" 
$ns at 828.989946184535 "$node_(79) setdest 1385 180 2.0" 
$ns at 869.7126468139561 "$node_(79) setdest 1082 134 15.0" 
$ns at 357.0744725661768 "$node_(80) setdest 1034 318 19.0" 
$ns at 434.5965131192769 "$node_(80) setdest 1741 950 6.0" 
$ns at 521.4997839483996 "$node_(80) setdest 1485 697 6.0" 
$ns at 560.5484421923496 "$node_(80) setdest 1753 646 19.0" 
$ns at 650.7340040158605 "$node_(80) setdest 479 846 9.0" 
$ns at 727.9438361754873 "$node_(80) setdest 2707 302 8.0" 
$ns at 806.9068653030135 "$node_(80) setdest 1863 762 19.0" 
$ns at 347.8670455848969 "$node_(81) setdest 2965 800 19.0" 
$ns at 415.83975284845917 "$node_(81) setdest 1546 975 19.0" 
$ns at 514.7825222995556 "$node_(81) setdest 929 885 1.0" 
$ns at 550.7654433194118 "$node_(81) setdest 1267 277 6.0" 
$ns at 631.929926622375 "$node_(81) setdest 1718 413 7.0" 
$ns at 716.4155404984898 "$node_(81) setdest 359 104 4.0" 
$ns at 779.9648329971243 "$node_(81) setdest 58 296 8.0" 
$ns at 810.5621809456063 "$node_(81) setdest 2025 148 5.0" 
$ns at 876.1008207180248 "$node_(81) setdest 2052 762 9.0" 
$ns at 435.86364402730493 "$node_(82) setdest 72 574 16.0" 
$ns at 512.591260030124 "$node_(82) setdest 824 498 17.0" 
$ns at 594.258620009503 "$node_(82) setdest 1405 513 15.0" 
$ns at 699.2722695636356 "$node_(82) setdest 1540 984 5.0" 
$ns at 767.0544257968046 "$node_(82) setdest 1920 923 3.0" 
$ns at 804.034838260241 "$node_(82) setdest 955 582 19.0" 
$ns at 348.58010637773634 "$node_(83) setdest 1153 647 15.0" 
$ns at 471.31732580303355 "$node_(83) setdest 646 174 14.0" 
$ns at 555.0989538695246 "$node_(83) setdest 1297 205 6.0" 
$ns at 588.3749647197405 "$node_(83) setdest 1568 312 3.0" 
$ns at 631.1532978595309 "$node_(83) setdest 365 629 4.0" 
$ns at 693.7219971633169 "$node_(83) setdest 1841 191 3.0" 
$ns at 725.310102189311 "$node_(83) setdest 752 215 9.0" 
$ns at 824.5555129698491 "$node_(83) setdest 1175 265 8.0" 
$ns at 364.42946845722037 "$node_(84) setdest 167 792 16.0" 
$ns at 552.3308975394593 "$node_(84) setdest 1994 895 3.0" 
$ns at 602.4466718592178 "$node_(84) setdest 1254 373 1.0" 
$ns at 639.5351797942691 "$node_(84) setdest 2517 934 10.0" 
$ns at 750.98066573247 "$node_(84) setdest 639 617 7.0" 
$ns at 837.7460291978824 "$node_(84) setdest 1771 791 7.0" 
$ns at 338.246206843306 "$node_(85) setdest 786 641 2.0" 
$ns at 375.70281183015993 "$node_(85) setdest 1084 153 1.0" 
$ns at 406.8663409940053 "$node_(85) setdest 2238 375 4.0" 
$ns at 457.30973647845786 "$node_(85) setdest 1281 940 20.0" 
$ns at 596.8392137306001 "$node_(85) setdest 1955 337 18.0" 
$ns at 777.2150364001568 "$node_(85) setdest 2778 215 19.0" 
$ns at 345.56072564552085 "$node_(86) setdest 1687 924 9.0" 
$ns at 432.12706715387515 "$node_(86) setdest 2994 13 11.0" 
$ns at 569.0128373198277 "$node_(86) setdest 2124 465 9.0" 
$ns at 615.083924919458 "$node_(86) setdest 2603 577 15.0" 
$ns at 775.6128541845642 "$node_(86) setdest 773 516 7.0" 
$ns at 809.2007702343589 "$node_(86) setdest 1987 974 13.0" 
$ns at 844.2105463235908 "$node_(86) setdest 282 5 19.0" 
$ns at 365.99345965929666 "$node_(87) setdest 1777 29 5.0" 
$ns at 433.4605867652968 "$node_(87) setdest 1350 777 13.0" 
$ns at 558.2592186775051 "$node_(87) setdest 1899 801 3.0" 
$ns at 609.1802110022843 "$node_(87) setdest 1079 69 7.0" 
$ns at 661.293382165543 "$node_(87) setdest 2368 895 3.0" 
$ns at 700.6611304698553 "$node_(87) setdest 49 617 1.0" 
$ns at 733.0053547616515 "$node_(87) setdest 2252 801 5.0" 
$ns at 775.4632526712663 "$node_(87) setdest 1499 852 4.0" 
$ns at 817.6287680948064 "$node_(87) setdest 1792 81 13.0" 
$ns at 890.7105438360022 "$node_(87) setdest 1029 77 1.0" 
$ns at 402.6797507436107 "$node_(88) setdest 2049 162 12.0" 
$ns at 499.0506519749757 "$node_(88) setdest 378 310 2.0" 
$ns at 544.6341557098448 "$node_(88) setdest 2318 849 11.0" 
$ns at 610.9470975806378 "$node_(88) setdest 1707 849 6.0" 
$ns at 655.7245807514138 "$node_(88) setdest 1409 571 18.0" 
$ns at 786.1753506724283 "$node_(88) setdest 2296 45 1.0" 
$ns at 816.1918471491505 "$node_(88) setdest 2474 455 15.0" 
$ns at 378.82955131134867 "$node_(89) setdest 2546 896 6.0" 
$ns at 429.5249201605728 "$node_(89) setdest 2596 12 10.0" 
$ns at 518.1557288331074 "$node_(89) setdest 2736 914 18.0" 
$ns at 586.6140249175166 "$node_(89) setdest 1259 555 12.0" 
$ns at 666.7426942316719 "$node_(89) setdest 556 775 3.0" 
$ns at 712.2295714414211 "$node_(89) setdest 1433 991 4.0" 
$ns at 775.4788605076938 "$node_(89) setdest 1702 600 13.0" 
$ns at 811.8853520271746 "$node_(89) setdest 197 246 6.0" 
$ns at 867.9012658205662 "$node_(89) setdest 1630 329 16.0" 
$ns at 505.24355269521345 "$node_(90) setdest 1061 102 3.0" 
$ns at 554.3841504831505 "$node_(90) setdest 1367 125 18.0" 
$ns at 584.4680379181539 "$node_(90) setdest 601 860 5.0" 
$ns at 615.2548646881885 "$node_(90) setdest 1379 596 1.0" 
$ns at 651.8717648858035 "$node_(90) setdest 533 550 5.0" 
$ns at 705.9448253343485 "$node_(90) setdest 632 932 11.0" 
$ns at 748.4065297509231 "$node_(90) setdest 764 286 1.0" 
$ns at 783.1586667783052 "$node_(90) setdest 31 238 18.0" 
$ns at 436.66986219162544 "$node_(91) setdest 1833 940 3.0" 
$ns at 466.9254741348442 "$node_(91) setdest 823 607 15.0" 
$ns at 527.6374561003568 "$node_(91) setdest 498 388 5.0" 
$ns at 601.5554144718938 "$node_(91) setdest 2132 523 12.0" 
$ns at 638.2236999471638 "$node_(91) setdest 2106 312 18.0" 
$ns at 722.2876591254035 "$node_(91) setdest 2173 179 15.0" 
$ns at 828.9025097463727 "$node_(91) setdest 692 910 20.0" 
$ns at 418.4898567285496 "$node_(92) setdest 34 441 14.0" 
$ns at 502.4472048285777 "$node_(92) setdest 1030 882 1.0" 
$ns at 536.9561974737458 "$node_(92) setdest 2864 694 16.0" 
$ns at 681.3799545833377 "$node_(92) setdest 2544 168 1.0" 
$ns at 712.2492972753422 "$node_(92) setdest 1330 777 4.0" 
$ns at 772.3910356870945 "$node_(92) setdest 1020 267 4.0" 
$ns at 839.225373485266 "$node_(92) setdest 1753 61 10.0" 
$ns at 503.81326645275186 "$node_(93) setdest 453 815 3.0" 
$ns at 561.6557487999215 "$node_(93) setdest 996 196 2.0" 
$ns at 598.8859783380897 "$node_(93) setdest 628 707 16.0" 
$ns at 746.6738842815961 "$node_(93) setdest 1975 447 5.0" 
$ns at 808.3004443041211 "$node_(93) setdest 2498 298 19.0" 
$ns at 373.0701973338025 "$node_(94) setdest 2745 402 13.0" 
$ns at 437.1845658529527 "$node_(94) setdest 2688 6 5.0" 
$ns at 503.6423353954252 "$node_(94) setdest 870 972 6.0" 
$ns at 560.2946792883996 "$node_(94) setdest 245 430 9.0" 
$ns at 655.1914480897665 "$node_(94) setdest 2557 282 14.0" 
$ns at 792.1504049311939 "$node_(94) setdest 2356 617 7.0" 
$ns at 827.8466518016538 "$node_(94) setdest 1472 658 16.0" 
$ns at 869.4138419948392 "$node_(94) setdest 2626 781 10.0" 
$ns at 332.7453144729514 "$node_(95) setdest 567 635 7.0" 
$ns at 401.57934859707007 "$node_(95) setdest 1744 92 9.0" 
$ns at 520.0444800833388 "$node_(95) setdest 2411 155 15.0" 
$ns at 627.24722565167 "$node_(95) setdest 2290 279 7.0" 
$ns at 713.0945239749469 "$node_(95) setdest 1992 523 12.0" 
$ns at 852.2888239613775 "$node_(95) setdest 606 61 6.0" 
$ns at 334.9924986875237 "$node_(96) setdest 2186 288 10.0" 
$ns at 369.03503767173834 "$node_(96) setdest 1981 922 2.0" 
$ns at 406.6942660376399 "$node_(96) setdest 2358 282 6.0" 
$ns at 457.7074737832865 "$node_(96) setdest 2386 441 11.0" 
$ns at 582.5764939976825 "$node_(96) setdest 1246 805 18.0" 
$ns at 734.5846896468637 "$node_(96) setdest 2630 56 7.0" 
$ns at 830.8827417352288 "$node_(96) setdest 2854 994 18.0" 
$ns at 871.9535257766295 "$node_(96) setdest 1199 970 9.0" 
$ns at 340.7562035353021 "$node_(97) setdest 222 342 4.0" 
$ns at 381.2497416537288 "$node_(97) setdest 2948 959 9.0" 
$ns at 467.9145278315394 "$node_(97) setdest 2592 8 14.0" 
$ns at 514.0707516194219 "$node_(97) setdest 2504 189 2.0" 
$ns at 549.8443310019329 "$node_(97) setdest 2986 221 11.0" 
$ns at 588.9467523572537 "$node_(97) setdest 202 880 14.0" 
$ns at 647.4632378572846 "$node_(97) setdest 2329 436 11.0" 
$ns at 724.4944182943896 "$node_(97) setdest 2582 355 5.0" 
$ns at 786.6195300605804 "$node_(97) setdest 723 386 14.0" 
$ns at 387.98066717200993 "$node_(98) setdest 2296 813 5.0" 
$ns at 441.1540202956987 "$node_(98) setdest 1403 218 15.0" 
$ns at 548.2250865986209 "$node_(98) setdest 329 494 1.0" 
$ns at 579.3327086154943 "$node_(98) setdest 1518 95 1.0" 
$ns at 615.8173696497976 "$node_(98) setdest 279 193 9.0" 
$ns at 721.9978943911583 "$node_(98) setdest 768 888 14.0" 
$ns at 774.3222665730815 "$node_(98) setdest 1278 71 18.0" 
$ns at 355.46775646766287 "$node_(99) setdest 2061 326 7.0" 
$ns at 436.0340003080085 "$node_(99) setdest 1475 831 10.0" 
$ns at 555.2715958539649 "$node_(99) setdest 2872 496 9.0" 
$ns at 655.621891325123 "$node_(99) setdest 2794 903 15.0" 
$ns at 736.3886367591718 "$node_(99) setdest 689 552 18.0" 
$ns at 515.5079857898584 "$node_(100) setdest 408 923 19.0" 
$ns at 615.7559500554211 "$node_(100) setdest 578 946 2.0" 
$ns at 658.7866248745124 "$node_(100) setdest 951 960 15.0" 
$ns at 798.3289344066841 "$node_(100) setdest 1698 92 15.0" 
$ns at 895.7823577068559 "$node_(100) setdest 2754 644 7.0" 
$ns at 495.5144482455258 "$node_(101) setdest 2464 366 1.0" 
$ns at 527.6329384991659 "$node_(101) setdest 1159 904 18.0" 
$ns at 562.7816144354027 "$node_(101) setdest 1605 430 2.0" 
$ns at 596.4422422505608 "$node_(101) setdest 433 627 16.0" 
$ns at 647.9320255804714 "$node_(101) setdest 594 393 2.0" 
$ns at 687.2187777021209 "$node_(101) setdest 1253 801 14.0" 
$ns at 812.5327040657388 "$node_(101) setdest 1330 906 2.0" 
$ns at 846.1811079647233 "$node_(101) setdest 2837 745 3.0" 
$ns at 899.4715898211339 "$node_(101) setdest 2382 1 12.0" 
$ns at 570.4320267781399 "$node_(102) setdest 1390 747 10.0" 
$ns at 677.5878272999752 "$node_(102) setdest 1645 595 11.0" 
$ns at 817.5022581022722 "$node_(102) setdest 722 584 16.0" 
$ns at 497.54377042416303 "$node_(103) setdest 2197 773 15.0" 
$ns at 666.0014845089112 "$node_(103) setdest 808 255 19.0" 
$ns at 719.3372906236425 "$node_(103) setdest 2097 66 16.0" 
$ns at 887.8246449494993 "$node_(103) setdest 177 287 10.0" 
$ns at 550.8127459248325 "$node_(104) setdest 421 550 20.0" 
$ns at 761.3482612356461 "$node_(104) setdest 2831 864 9.0" 
$ns at 865.1392852109568 "$node_(104) setdest 2625 135 10.0" 
$ns at 502.3274526520539 "$node_(105) setdest 1688 639 19.0" 
$ns at 591.0632132064691 "$node_(105) setdest 431 152 12.0" 
$ns at 639.0037942964299 "$node_(105) setdest 2005 695 1.0" 
$ns at 672.134491915844 "$node_(105) setdest 1712 48 5.0" 
$ns at 716.2250283873964 "$node_(105) setdest 833 256 12.0" 
$ns at 779.7586403056322 "$node_(105) setdest 2514 46 2.0" 
$ns at 824.6505708446707 "$node_(105) setdest 2505 823 8.0" 
$ns at 518.1216303053436 "$node_(106) setdest 986 426 8.0" 
$ns at 575.4033848868868 "$node_(106) setdest 2635 622 11.0" 
$ns at 612.821093709702 "$node_(106) setdest 960 564 1.0" 
$ns at 645.2444860481097 "$node_(106) setdest 508 767 6.0" 
$ns at 696.5947454517068 "$node_(106) setdest 771 300 14.0" 
$ns at 747.1926233822529 "$node_(106) setdest 646 501 7.0" 
$ns at 783.9530047830604 "$node_(106) setdest 2343 396 8.0" 
$ns at 891.3872917396052 "$node_(106) setdest 2138 73 3.0" 
$ns at 566.4091570707778 "$node_(107) setdest 2637 502 4.0" 
$ns at 634.2081039672 "$node_(107) setdest 2046 188 5.0" 
$ns at 682.4615397682566 "$node_(107) setdest 240 756 12.0" 
$ns at 765.9417039968293 "$node_(107) setdest 2204 736 3.0" 
$ns at 801.1906803553965 "$node_(107) setdest 1587 6 18.0" 
$ns at 507.8874290613804 "$node_(108) setdest 1923 910 10.0" 
$ns at 615.216970105436 "$node_(108) setdest 212 860 12.0" 
$ns at 696.8787185174888 "$node_(108) setdest 596 101 7.0" 
$ns at 775.0034618216775 "$node_(108) setdest 2182 465 19.0" 
$ns at 534.3895112693779 "$node_(109) setdest 1467 255 15.0" 
$ns at 613.1984494919127 "$node_(109) setdest 2256 652 5.0" 
$ns at 656.6374309343564 "$node_(109) setdest 168 534 5.0" 
$ns at 697.9720096565723 "$node_(109) setdest 975 39 9.0" 
$ns at 746.8282455743262 "$node_(109) setdest 745 920 6.0" 
$ns at 789.1870861341346 "$node_(109) setdest 806 149 1.0" 
$ns at 825.3292717713216 "$node_(109) setdest 736 109 15.0" 
$ns at 886.1678447882015 "$node_(109) setdest 123 381 1.0" 
$ns at 665.7565896809571 "$node_(110) setdest 1833 759 1.0" 
$ns at 700.8738845040466 "$node_(110) setdest 1106 957 15.0" 
$ns at 811.1596232767239 "$node_(110) setdest 1301 834 16.0" 
$ns at 522.1704479394793 "$node_(111) setdest 2433 260 18.0" 
$ns at 611.7160761643404 "$node_(111) setdest 2459 110 15.0" 
$ns at 644.4952296372586 "$node_(111) setdest 713 668 18.0" 
$ns at 691.036551274218 "$node_(111) setdest 1754 593 4.0" 
$ns at 722.1815194512419 "$node_(111) setdest 640 251 16.0" 
$ns at 886.5502666803786 "$node_(111) setdest 2127 435 4.0" 
$ns at 520.2668583216722 "$node_(112) setdest 2121 974 15.0" 
$ns at 615.0917284202236 "$node_(112) setdest 1995 713 10.0" 
$ns at 679.0656107513131 "$node_(112) setdest 2369 84 5.0" 
$ns at 739.9793827107065 "$node_(112) setdest 954 750 13.0" 
$ns at 832.246700537451 "$node_(112) setdest 776 329 1.0" 
$ns at 866.5999486227864 "$node_(112) setdest 2989 712 18.0" 
$ns at 517.56947599879 "$node_(113) setdest 672 740 4.0" 
$ns at 584.3444083818732 "$node_(113) setdest 2325 402 9.0" 
$ns at 649.2899954935531 "$node_(113) setdest 111 968 1.0" 
$ns at 684.449784275386 "$node_(113) setdest 974 486 8.0" 
$ns at 778.9194803196741 "$node_(113) setdest 527 471 10.0" 
$ns at 839.140024854165 "$node_(113) setdest 1549 193 5.0" 
$ns at 549.2778742856116 "$node_(114) setdest 1499 84 6.0" 
$ns at 591.1891570344008 "$node_(114) setdest 531 759 5.0" 
$ns at 622.0186057523159 "$node_(114) setdest 1290 803 13.0" 
$ns at 720.990416973375 "$node_(114) setdest 792 394 5.0" 
$ns at 752.4997280537564 "$node_(114) setdest 1343 677 16.0" 
$ns at 539.2183955829288 "$node_(115) setdest 2284 717 2.0" 
$ns at 587.6505880921402 "$node_(115) setdest 2333 250 19.0" 
$ns at 658.1519148300927 "$node_(115) setdest 2858 478 2.0" 
$ns at 706.1587545703156 "$node_(115) setdest 1239 180 13.0" 
$ns at 803.4003136700555 "$node_(115) setdest 1903 972 10.0" 
$ns at 891.8597196652504 "$node_(115) setdest 2882 279 1.0" 
$ns at 618.6009613587597 "$node_(116) setdest 1223 398 18.0" 
$ns at 702.9460665518142 "$node_(116) setdest 1926 612 18.0" 
$ns at 557.5935544927563 "$node_(117) setdest 979 690 19.0" 
$ns at 680.4288744900524 "$node_(117) setdest 2128 618 5.0" 
$ns at 751.044944685337 "$node_(117) setdest 2630 914 1.0" 
$ns at 790.2099051577342 "$node_(117) setdest 1338 269 16.0" 
$ns at 506.0464133307762 "$node_(118) setdest 2563 231 11.0" 
$ns at 545.1483797894064 "$node_(118) setdest 1128 399 9.0" 
$ns at 607.3670674099184 "$node_(118) setdest 2011 393 20.0" 
$ns at 759.549346154734 "$node_(118) setdest 906 27 3.0" 
$ns at 792.2361490650611 "$node_(118) setdest 522 689 17.0" 
$ns at 508.9336635438696 "$node_(119) setdest 2906 606 10.0" 
$ns at 568.9659255713091 "$node_(119) setdest 2779 358 1.0" 
$ns at 607.3203809840777 "$node_(119) setdest 2627 315 12.0" 
$ns at 747.8440542051932 "$node_(119) setdest 2037 251 5.0" 
$ns at 788.8418566529602 "$node_(119) setdest 470 677 11.0" 
$ns at 889.5299927391425 "$node_(119) setdest 846 923 19.0" 
$ns at 511.3549408207138 "$node_(120) setdest 1171 14 10.0" 
$ns at 607.7481428913314 "$node_(120) setdest 356 167 16.0" 
$ns at 687.8846167361952 "$node_(120) setdest 439 476 6.0" 
$ns at 740.3174060250127 "$node_(120) setdest 998 642 8.0" 
$ns at 844.0414734048427 "$node_(120) setdest 2345 236 16.0" 
$ns at 897.3500139715198 "$node_(120) setdest 902 752 12.0" 
$ns at 513.557856780467 "$node_(121) setdest 2628 207 12.0" 
$ns at 614.8418635650764 "$node_(121) setdest 17 987 14.0" 
$ns at 700.9708559336251 "$node_(121) setdest 2353 358 9.0" 
$ns at 803.0043837738945 "$node_(121) setdest 1909 912 12.0" 
$ns at 505.5121708361249 "$node_(122) setdest 2935 599 16.0" 
$ns at 651.4814576770741 "$node_(122) setdest 2074 224 15.0" 
$ns at 721.7294696454231 "$node_(122) setdest 2763 888 14.0" 
$ns at 824.0254996635936 "$node_(122) setdest 174 225 3.0" 
$ns at 857.4117281902991 "$node_(122) setdest 797 153 14.0" 
$ns at 524.9513209504886 "$node_(123) setdest 900 269 16.0" 
$ns at 649.1248977553573 "$node_(123) setdest 280 15 11.0" 
$ns at 773.7715630694258 "$node_(123) setdest 1254 774 14.0" 
$ns at 813.1689609902655 "$node_(123) setdest 1314 213 16.0" 
$ns at 556.2748232830862 "$node_(124) setdest 2774 580 15.0" 
$ns at 641.24360628978 "$node_(124) setdest 2488 580 7.0" 
$ns at 681.5487134691182 "$node_(124) setdest 384 114 4.0" 
$ns at 741.6888185396995 "$node_(124) setdest 1294 143 2.0" 
$ns at 789.6046272924638 "$node_(124) setdest 2629 67 17.0" 
$ns at 667.5267844394045 "$node_(125) setdest 2361 459 15.0" 
$ns at 834.1858685028778 "$node_(125) setdest 2250 133 3.0" 
$ns at 882.8783777291859 "$node_(125) setdest 2111 741 1.0" 
$ns at 686.6830049685469 "$node_(126) setdest 1775 19 9.0" 
$ns at 800.441497281772 "$node_(126) setdest 1373 453 15.0" 
$ns at 682.2054817386202 "$node_(127) setdest 1476 415 17.0" 
$ns at 728.5959700830973 "$node_(127) setdest 1609 318 18.0" 
$ns at 783.9373516795335 "$node_(127) setdest 2826 747 17.0" 
$ns at 892.6996356907853 "$node_(127) setdest 1493 616 9.0" 
$ns at 675.4004564680126 "$node_(128) setdest 2932 842 15.0" 
$ns at 742.7038670621807 "$node_(128) setdest 67 106 13.0" 
$ns at 865.5562998957456 "$node_(128) setdest 2140 10 15.0" 
$ns at 673.6069355972704 "$node_(129) setdest 2412 862 1.0" 
$ns at 711.4090443871935 "$node_(129) setdest 2316 88 15.0" 
$ns at 787.1440991360864 "$node_(129) setdest 2211 545 7.0" 
$ns at 824.8064563546887 "$node_(129) setdest 2940 816 3.0" 
$ns at 879.642441483288 "$node_(129) setdest 1783 700 13.0" 
$ns at 787.0589113193008 "$node_(130) setdest 1249 956 18.0" 
$ns at 745.9346948907552 "$node_(131) setdest 724 593 13.0" 
$ns at 861.1014947031667 "$node_(131) setdest 72 744 12.0" 
$ns at 674.3904022746186 "$node_(132) setdest 77 557 6.0" 
$ns at 736.1992617206437 "$node_(132) setdest 1558 437 20.0" 
$ns at 858.0484117062877 "$node_(132) setdest 2571 745 14.0" 
$ns at 720.8407378875457 "$node_(133) setdest 2953 998 17.0" 
$ns at 779.6466558833322 "$node_(133) setdest 932 759 18.0" 
$ns at 852.8218289435449 "$node_(133) setdest 490 389 15.0" 
$ns at 664.7738818019858 "$node_(134) setdest 1353 10 18.0" 
$ns at 831.8654526305393 "$node_(134) setdest 68 748 13.0" 
$ns at 694.4406737385935 "$node_(135) setdest 2467 117 5.0" 
$ns at 732.4990054086222 "$node_(135) setdest 2346 388 3.0" 
$ns at 773.2545489024225 "$node_(135) setdest 2325 594 11.0" 
$ns at 831.9393602989602 "$node_(135) setdest 393 385 7.0" 
$ns at 696.8287271006515 "$node_(136) setdest 1804 740 7.0" 
$ns at 766.525365264029 "$node_(136) setdest 2080 694 1.0" 
$ns at 803.5720345736454 "$node_(136) setdest 2935 38 12.0" 
$ns at 767.4241215999222 "$node_(137) setdest 282 725 13.0" 
$ns at 896.3739381511239 "$node_(137) setdest 1467 460 16.0" 
$ns at 710.2599233862683 "$node_(138) setdest 858 463 15.0" 
$ns at 859.2215739863256 "$node_(138) setdest 1955 255 1.0" 
$ns at 893.4060127785975 "$node_(138) setdest 1100 473 7.0" 
$ns at 665.7679168214339 "$node_(139) setdest 317 257 6.0" 
$ns at 735.6184229267412 "$node_(139) setdest 1623 40 2.0" 
$ns at 779.2678003964164 "$node_(139) setdest 2435 136 2.0" 
$ns at 819.5161244896743 "$node_(139) setdest 1621 939 16.0" 
$ns at 724.6964818071763 "$node_(140) setdest 1072 168 1.0" 
$ns at 759.0661673209258 "$node_(140) setdest 1908 236 9.0" 
$ns at 803.8547417515551 "$node_(140) setdest 1671 988 1.0" 
$ns at 837.7494381217664 "$node_(140) setdest 2000 290 2.0" 
$ns at 879.1873390396652 "$node_(140) setdest 1346 938 16.0" 
$ns at 684.8252050866467 "$node_(141) setdest 2286 703 11.0" 
$ns at 783.1924708960937 "$node_(141) setdest 401 628 5.0" 
$ns at 847.9772899638683 "$node_(141) setdest 1719 633 5.0" 
$ns at 891.5744146520027 "$node_(141) setdest 2888 105 1.0" 
$ns at 666.9955198811846 "$node_(142) setdest 2811 545 2.0" 
$ns at 714.2697914399479 "$node_(142) setdest 1403 532 6.0" 
$ns at 757.6938895863371 "$node_(142) setdest 1399 110 17.0" 
$ns at 825.1125537249978 "$node_(142) setdest 1816 343 11.0" 
$ns at 864.8012052426689 "$node_(142) setdest 1770 417 3.0" 
$ns at 676.4168117325358 "$node_(143) setdest 1471 266 8.0" 
$ns at 754.261994229873 "$node_(143) setdest 358 325 2.0" 
$ns at 797.3837424498308 "$node_(143) setdest 366 312 18.0" 
$ns at 695.2734951386082 "$node_(144) setdest 770 663 20.0" 
$ns at 842.2735529392005 "$node_(144) setdest 2005 877 2.0" 
$ns at 878.9459217116774 "$node_(144) setdest 177 816 7.0" 
$ns at 786.0058825337815 "$node_(145) setdest 385 738 15.0" 
$ns at 663.6794658360188 "$node_(146) setdest 2197 346 20.0" 
$ns at 770.6082035474676 "$node_(146) setdest 688 642 14.0" 
$ns at 865.2745245275148 "$node_(146) setdest 2500 147 13.0" 
$ns at 719.6206323271131 "$node_(147) setdest 469 123 3.0" 
$ns at 762.6752750655438 "$node_(147) setdest 1606 261 14.0" 
$ns at 810.2183655166284 "$node_(147) setdest 347 415 1.0" 
$ns at 844.4080228957652 "$node_(147) setdest 1700 356 17.0" 
$ns at 895.8519950961652 "$node_(147) setdest 1561 318 10.0" 
$ns at 697.1320329959932 "$node_(148) setdest 1936 391 18.0" 
$ns at 789.414501030517 "$node_(148) setdest 1946 134 3.0" 
$ns at 847.7401746286696 "$node_(148) setdest 2448 997 14.0" 
$ns at 702.4738942248354 "$node_(149) setdest 946 381 10.0" 
$ns at 780.1349287261526 "$node_(149) setdest 2653 464 12.0" 
$ns at 826.6180564711492 "$node_(149) setdest 979 474 4.0" 
$ns at 894.777730295558 "$node_(149) setdest 1417 852 13.0" 


#Set a TCP connection between node_(8) and node_(21)
set tcp_(0) [new Agent/TCP/Newreno]
$tcp_(0) set class_ 2
set sink_(0) [new Agent/TCPSink]
$ns attach-agent $node_(8) $tcp_(0)
$ns attach-agent $node_(21) $sink_(0)
$ns connect $tcp_(0) $sink_(0)
set ftp_(0) [new Application/FTP]
$ftp_(0) attach-agent $tcp_(0)
$ns at 0.2 "$ftp_(0) start"
$ns at 180.0 "$ftp_(0) stop"

#Set a TCP connection between node_(13) and node_(14)
set tcp_(1) [new Agent/TCP/Newreno]
$tcp_(1) set class_ 2
set sink_(1) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(1)
$ns attach-agent $node_(14) $sink_(1)
$ns connect $tcp_(1) $sink_(1)
set ftp_(1) [new Application/FTP]
$ftp_(1) attach-agent $tcp_(1)
$ns at 180.2 "$ftp_(1) start"
$ns at 360.0 "$ftp_(1) stop"

#Set a TCP connection between node_(23) and node_(40)
set tcp_(2) [new Agent/TCP/Newreno]
$tcp_(2) set class_ 2
set sink_(2) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(2)
$ns attach-agent $node_(40) $sink_(2)
$ns connect $tcp_(2) $sink_(2)
set ftp_(2) [new Application/FTP]
$ftp_(2) attach-agent $tcp_(2)
$ns at 360.2 "$ftp_(2) start"
$ns at 540.0 "$ftp_(2) stop"

#Set a TCP connection between node_(15) and node_(48)
set tcp_(3) [new Agent/TCP/Newreno]
$tcp_(3) set class_ 2
set sink_(3) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(3)
$ns attach-agent $node_(48) $sink_(3)
$ns connect $tcp_(3) $sink_(3)
set ftp_(3) [new Application/FTP]
$ftp_(3) attach-agent $tcp_(3)
$ns at 540.2 "$ftp_(3) start"
$ns at 720.0 "$ftp_(3) stop"

#Set a TCP connection between node_(46) and node_(39)
set tcp_(4) [new Agent/TCP/Newreno]
$tcp_(4) set class_ 2
set sink_(4) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(4)
$ns attach-agent $node_(39) $sink_(4)
$ns connect $tcp_(4) $sink_(4)
set ftp_(4) [new Application/FTP]
$ftp_(4) attach-agent $tcp_(4)
$ns at 720.2 "$ftp_(4) start"
$ns at 900.0 "$ftp_(4) stop"

#Set a TCP connection between node_(15) and node_(45)
set tcp_(5) [new Agent/TCP/Newreno]
$tcp_(5) set class_ 2
set sink_(5) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(5)
$ns attach-agent $node_(45) $sink_(5)
$ns connect $tcp_(5) $sink_(5)
set ftp_(5) [new Application/FTP]
$ftp_(5) attach-agent $tcp_(5)
$ns at 0.2 "$ftp_(5) start"
$ns at 180.0 "$ftp_(5) stop"

#Set a TCP connection between node_(19) and node_(14)
set tcp_(6) [new Agent/TCP/Newreno]
$tcp_(6) set class_ 2
set sink_(6) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(6)
$ns attach-agent $node_(14) $sink_(6)
$ns connect $tcp_(6) $sink_(6)
set ftp_(6) [new Application/FTP]
$ftp_(6) attach-agent $tcp_(6)
$ns at 180.2 "$ftp_(6) start"
$ns at 360.0 "$ftp_(6) stop"

#Set a TCP connection between node_(16) and node_(22)
set tcp_(7) [new Agent/TCP/Newreno]
$tcp_(7) set class_ 2
set sink_(7) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(7)
$ns attach-agent $node_(22) $sink_(7)
$ns connect $tcp_(7) $sink_(7)
set ftp_(7) [new Application/FTP]
$ftp_(7) attach-agent $tcp_(7)
$ns at 360.2 "$ftp_(7) start"
$ns at 540.0 "$ftp_(7) stop"

#Set a TCP connection between node_(44) and node_(0)
set tcp_(8) [new Agent/TCP/Newreno]
$tcp_(8) set class_ 2
set sink_(8) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(8)
$ns attach-agent $node_(0) $sink_(8)
$ns connect $tcp_(8) $sink_(8)
set ftp_(8) [new Application/FTP]
$ftp_(8) attach-agent $tcp_(8)
$ns at 540.2 "$ftp_(8) start"
$ns at 720.0 "$ftp_(8) stop"

#Set a TCP connection between node_(10) and node_(12)
set tcp_(9) [new Agent/TCP/Newreno]
$tcp_(9) set class_ 2
set sink_(9) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(9)
$ns attach-agent $node_(12) $sink_(9)
$ns connect $tcp_(9) $sink_(9)
set ftp_(9) [new Application/FTP]
$ftp_(9) attach-agent $tcp_(9)
$ns at 720.2 "$ftp_(9) start"
$ns at 900.0 "$ftp_(9) stop"

#Set a TCP connection between node_(0) and node_(11)
set tcp_(10) [new Agent/TCP/Newreno]
$tcp_(10) set class_ 2
set sink_(10) [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp_(10)
$ns attach-agent $node_(11) $sink_(10)
$ns connect $tcp_(10) $sink_(10)
set ftp_(10) [new Application/FTP]
$ftp_(10) attach-agent $tcp_(10)
$ns at 0.2 "$ftp_(10) start"
$ns at 180.0 "$ftp_(10) stop"

#Set a TCP connection between node_(10) and node_(45)
set tcp_(11) [new Agent/TCP/Newreno]
$tcp_(11) set class_ 2
set sink_(11) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(11)
$ns attach-agent $node_(45) $sink_(11)
$ns connect $tcp_(11) $sink_(11)
set ftp_(11) [new Application/FTP]
$ftp_(11) attach-agent $tcp_(11)
$ns at 180.2 "$ftp_(11) start"
$ns at 360.0 "$ftp_(11) stop"

#Set a TCP connection between node_(34) and node_(40)
set tcp_(12) [new Agent/TCP/Newreno]
$tcp_(12) set class_ 2
set sink_(12) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(12)
$ns attach-agent $node_(40) $sink_(12)
$ns connect $tcp_(12) $sink_(12)
set ftp_(12) [new Application/FTP]
$ftp_(12) attach-agent $tcp_(12)
$ns at 360.2 "$ftp_(12) start"
$ns at 540.0 "$ftp_(12) stop"

#Set a TCP connection between node_(13) and node_(9)
set tcp_(13) [new Agent/TCP/Newreno]
$tcp_(13) set class_ 2
set sink_(13) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(13)
$ns attach-agent $node_(9) $sink_(13)
$ns connect $tcp_(13) $sink_(13)
set ftp_(13) [new Application/FTP]
$ftp_(13) attach-agent $tcp_(13)
$ns at 540.2 "$ftp_(13) start"
$ns at 720.0 "$ftp_(13) stop"

#Set a TCP connection between node_(41) and node_(12)
set tcp_(14) [new Agent/TCP/Newreno]
$tcp_(14) set class_ 2
set sink_(14) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(14)
$ns attach-agent $node_(12) $sink_(14)
$ns connect $tcp_(14) $sink_(14)
set ftp_(14) [new Application/FTP]
$ftp_(14) attach-agent $tcp_(14)
$ns at 720.2 "$ftp_(14) start"
$ns at 900.0 "$ftp_(14) stop"

#Set a TCP connection between node_(0) and node_(48)
set tcp_(15) [new Agent/TCP/Newreno]
$tcp_(15) set class_ 2
set sink_(15) [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp_(15)
$ns attach-agent $node_(48) $sink_(15)
$ns connect $tcp_(15) $sink_(15)
set ftp_(15) [new Application/FTP]
$ftp_(15) attach-agent $tcp_(15)
$ns at 0.2 "$ftp_(15) start"
$ns at 180.0 "$ftp_(15) stop"

#Set a TCP connection between node_(25) and node_(15)
set tcp_(16) [new Agent/TCP/Newreno]
$tcp_(16) set class_ 2
set sink_(16) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(16)
$ns attach-agent $node_(15) $sink_(16)
$ns connect $tcp_(16) $sink_(16)
set ftp_(16) [new Application/FTP]
$ftp_(16) attach-agent $tcp_(16)
$ns at 180.2 "$ftp_(16) start"
$ns at 360.0 "$ftp_(16) stop"

#Set a TCP connection between node_(28) and node_(19)
set tcp_(17) [new Agent/TCP/Newreno]
$tcp_(17) set class_ 2
set sink_(17) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(17)
$ns attach-agent $node_(19) $sink_(17)
$ns connect $tcp_(17) $sink_(17)
set ftp_(17) [new Application/FTP]
$ftp_(17) attach-agent $tcp_(17)
$ns at 360.2 "$ftp_(17) start"
$ns at 540.0 "$ftp_(17) stop"

#Set a TCP connection between node_(6) and node_(17)
set tcp_(18) [new Agent/TCP/Newreno]
$tcp_(18) set class_ 2
set sink_(18) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(18)
$ns attach-agent $node_(17) $sink_(18)
$ns connect $tcp_(18) $sink_(18)
set ftp_(18) [new Application/FTP]
$ftp_(18) attach-agent $tcp_(18)
$ns at 540.2 "$ftp_(18) start"
$ns at 720.0 "$ftp_(18) stop"

#Set a TCP connection between node_(34) and node_(25)
set tcp_(19) [new Agent/TCP/Newreno]
$tcp_(19) set class_ 2
set sink_(19) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(19)
$ns attach-agent $node_(25) $sink_(19)
$ns connect $tcp_(19) $sink_(19)
set ftp_(19) [new Application/FTP]
$ftp_(19) attach-agent $tcp_(19)
$ns at 720.2 "$ftp_(19) start"
$ns at 900.0 "$ftp_(19) stop"

#Set a TCP connection between node_(16) and node_(8)
set tcp_(20) [new Agent/TCP/Newreno]
$tcp_(20) set class_ 2
set sink_(20) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(20)
$ns attach-agent $node_(8) $sink_(20)
$ns connect $tcp_(20) $sink_(20)
set ftp_(20) [new Application/FTP]
$ftp_(20) attach-agent $tcp_(20)
$ns at 0.2 "$ftp_(20) start"
$ns at 180.0 "$ftp_(20) stop"

#Set a TCP connection between node_(47) and node_(5)
set tcp_(21) [new Agent/TCP/Newreno]
$tcp_(21) set class_ 2
set sink_(21) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(21)
$ns attach-agent $node_(5) $sink_(21)
$ns connect $tcp_(21) $sink_(21)
set ftp_(21) [new Application/FTP]
$ftp_(21) attach-agent $tcp_(21)
$ns at 180.2 "$ftp_(21) start"
$ns at 360.0 "$ftp_(21) stop"

#Set a TCP connection between node_(17) and node_(20)
set tcp_(22) [new Agent/TCP/Newreno]
$tcp_(22) set class_ 2
set sink_(22) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(22)
$ns attach-agent $node_(20) $sink_(22)
$ns connect $tcp_(22) $sink_(22)
set ftp_(22) [new Application/FTP]
$ftp_(22) attach-agent $tcp_(22)
$ns at 360.2 "$ftp_(22) start"
$ns at 540.0 "$ftp_(22) stop"

#Set a TCP connection between node_(26) and node_(44)
set tcp_(23) [new Agent/TCP/Newreno]
$tcp_(23) set class_ 2
set sink_(23) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(23)
$ns attach-agent $node_(44) $sink_(23)
$ns connect $tcp_(23) $sink_(23)
set ftp_(23) [new Application/FTP]
$ftp_(23) attach-agent $tcp_(23)
$ns at 540.2 "$ftp_(23) start"
$ns at 720.0 "$ftp_(23) stop"

#Set a TCP connection between node_(36) and node_(3)
set tcp_(24) [new Agent/TCP/Newreno]
$tcp_(24) set class_ 2
set sink_(24) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(24)
$ns attach-agent $node_(3) $sink_(24)
$ns connect $tcp_(24) $sink_(24)
set ftp_(24) [new Application/FTP]
$ftp_(24) attach-agent $tcp_(24)
$ns at 720.2 "$ftp_(24) start"
$ns at 900.0 "$ftp_(24) stop"

#Set a TCP connection between node_(32) and node_(13)
set tcp_(25) [new Agent/TCP/Newreno]
$tcp_(25) set class_ 2
set sink_(25) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(25)
$ns attach-agent $node_(13) $sink_(25)
$ns connect $tcp_(25) $sink_(25)
set ftp_(25) [new Application/FTP]
$ftp_(25) attach-agent $tcp_(25)
$ns at 0.2 "$ftp_(25) start"
$ns at 180.0 "$ftp_(25) stop"

#Set a TCP connection between node_(2) and node_(3)
set tcp_(26) [new Agent/TCP/Newreno]
$tcp_(26) set class_ 2
set sink_(26) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(26)
$ns attach-agent $node_(3) $sink_(26)
$ns connect $tcp_(26) $sink_(26)
set ftp_(26) [new Application/FTP]
$ftp_(26) attach-agent $tcp_(26)
$ns at 180.2 "$ftp_(26) start"
$ns at 360.0 "$ftp_(26) stop"

#Set a TCP connection between node_(32) and node_(42)
set tcp_(27) [new Agent/TCP/Newreno]
$tcp_(27) set class_ 2
set sink_(27) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(27)
$ns attach-agent $node_(42) $sink_(27)
$ns connect $tcp_(27) $sink_(27)
set ftp_(27) [new Application/FTP]
$ftp_(27) attach-agent $tcp_(27)
$ns at 360.2 "$ftp_(27) start"
$ns at 540.0 "$ftp_(27) stop"

#Set a TCP connection between node_(40) and node_(37)
set tcp_(28) [new Agent/TCP/Newreno]
$tcp_(28) set class_ 2
set sink_(28) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(28)
$ns attach-agent $node_(37) $sink_(28)
$ns connect $tcp_(28) $sink_(28)
set ftp_(28) [new Application/FTP]
$ftp_(28) attach-agent $tcp_(28)
$ns at 540.2 "$ftp_(28) start"
$ns at 720.0 "$ftp_(28) stop"

#Set a TCP connection between node_(48) and node_(36)
set tcp_(29) [new Agent/TCP/Newreno]
$tcp_(29) set class_ 2
set sink_(29) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(29)
$ns attach-agent $node_(36) $sink_(29)
$ns connect $tcp_(29) $sink_(29)
set ftp_(29) [new Application/FTP]
$ftp_(29) attach-agent $tcp_(29)
$ns at 720.2 "$ftp_(29) start"
$ns at 900.0 "$ftp_(29) stop"

#Set a TCP connection between node_(25) and node_(20)
set tcp_(30) [new Agent/TCP/Newreno]
$tcp_(30) set class_ 2
set sink_(30) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(30)
$ns attach-agent $node_(20) $sink_(30)
$ns connect $tcp_(30) $sink_(30)
set ftp_(30) [new Application/FTP]
$ftp_(30) attach-agent $tcp_(30)
$ns at 0.2 "$ftp_(30) start"
$ns at 180.0 "$ftp_(30) stop"

#Set a TCP connection between node_(34) and node_(17)
set tcp_(31) [new Agent/TCP/Newreno]
$tcp_(31) set class_ 2
set sink_(31) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(31)
$ns attach-agent $node_(17) $sink_(31)
$ns connect $tcp_(31) $sink_(31)
set ftp_(31) [new Application/FTP]
$ftp_(31) attach-agent $tcp_(31)
$ns at 180.2 "$ftp_(31) start"
$ns at 360.0 "$ftp_(31) stop"

#Set a TCP connection between node_(11) and node_(23)
set tcp_(32) [new Agent/TCP/Newreno]
$tcp_(32) set class_ 2
set sink_(32) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(32)
$ns attach-agent $node_(23) $sink_(32)
$ns connect $tcp_(32) $sink_(32)
set ftp_(32) [new Application/FTP]
$ftp_(32) attach-agent $tcp_(32)
$ns at 360.2 "$ftp_(32) start"
$ns at 540.0 "$ftp_(32) stop"

#Set a TCP connection between node_(9) and node_(24)
set tcp_(33) [new Agent/TCP/Newreno]
$tcp_(33) set class_ 2
set sink_(33) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(33)
$ns attach-agent $node_(24) $sink_(33)
$ns connect $tcp_(33) $sink_(33)
set ftp_(33) [new Application/FTP]
$ftp_(33) attach-agent $tcp_(33)
$ns at 540.2 "$ftp_(33) start"
$ns at 720.0 "$ftp_(33) stop"

#Set a TCP connection between node_(32) and node_(21)
set tcp_(34) [new Agent/TCP/Newreno]
$tcp_(34) set class_ 2
set sink_(34) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(34)
$ns attach-agent $node_(21) $sink_(34)
$ns connect $tcp_(34) $sink_(34)
set ftp_(34) [new Application/FTP]
$ftp_(34) attach-agent $tcp_(34)
$ns at 720.2 "$ftp_(34) start"
$ns at 900.0 "$ftp_(34) stop"

#Set a TCP connection between node_(44) and node_(23)
set tcp_(35) [new Agent/TCP/Newreno]
$tcp_(35) set class_ 2
set sink_(35) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(35)
$ns attach-agent $node_(23) $sink_(35)
$ns connect $tcp_(35) $sink_(35)
set ftp_(35) [new Application/FTP]
$ftp_(35) attach-agent $tcp_(35)
$ns at 0.2 "$ftp_(35) start"
$ns at 180.0 "$ftp_(35) stop"

#Set a TCP connection between node_(33) and node_(34)
set tcp_(36) [new Agent/TCP/Newreno]
$tcp_(36) set class_ 2
set sink_(36) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(36)
$ns attach-agent $node_(34) $sink_(36)
$ns connect $tcp_(36) $sink_(36)
set ftp_(36) [new Application/FTP]
$ftp_(36) attach-agent $tcp_(36)
$ns at 180.2 "$ftp_(36) start"
$ns at 360.0 "$ftp_(36) stop"

#Set a TCP connection between node_(49) and node_(8)
set tcp_(37) [new Agent/TCP/Newreno]
$tcp_(37) set class_ 2
set sink_(37) [new Agent/TCPSink]
$ns attach-agent $node_(49) $tcp_(37)
$ns attach-agent $node_(8) $sink_(37)
$ns connect $tcp_(37) $sink_(37)
set ftp_(37) [new Application/FTP]
$ftp_(37) attach-agent $tcp_(37)
$ns at 360.2 "$ftp_(37) start"
$ns at 540.0 "$ftp_(37) stop"

#Set a TCP connection between node_(6) and node_(5)
set tcp_(38) [new Agent/TCP/Newreno]
$tcp_(38) set class_ 2
set sink_(38) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(38)
$ns attach-agent $node_(5) $sink_(38)
$ns connect $tcp_(38) $sink_(38)
set ftp_(38) [new Application/FTP]
$ftp_(38) attach-agent $tcp_(38)
$ns at 540.2 "$ftp_(38) start"
$ns at 720.0 "$ftp_(38) stop"

#Set a TCP connection between node_(23) and node_(43)
set tcp_(39) [new Agent/TCP/Newreno]
$tcp_(39) set class_ 2
set sink_(39) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(39)
$ns attach-agent $node_(43) $sink_(39)
$ns connect $tcp_(39) $sink_(39)
set ftp_(39) [new Application/FTP]
$ftp_(39) attach-agent $tcp_(39)
$ns at 720.2 "$ftp_(39) start"
$ns at 900.0 "$ftp_(39) stop"

#Set a TCP connection between node_(42) and node_(19)
set tcp_(40) [new Agent/TCP/Newreno]
$tcp_(40) set class_ 2
set sink_(40) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(40)
$ns attach-agent $node_(19) $sink_(40)
$ns connect $tcp_(40) $sink_(40)
set ftp_(40) [new Application/FTP]
$ftp_(40) attach-agent $tcp_(40)
$ns at 0.2 "$ftp_(40) start"
$ns at 180.0 "$ftp_(40) stop"

#Set a TCP connection between node_(21) and node_(23)
set tcp_(41) [new Agent/TCP/Newreno]
$tcp_(41) set class_ 2
set sink_(41) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(41)
$ns attach-agent $node_(23) $sink_(41)
$ns connect $tcp_(41) $sink_(41)
set ftp_(41) [new Application/FTP]
$ftp_(41) attach-agent $tcp_(41)
$ns at 180.2 "$ftp_(41) start"
$ns at 360.0 "$ftp_(41) stop"

#Set a TCP connection between node_(18) and node_(36)
set tcp_(42) [new Agent/TCP/Newreno]
$tcp_(42) set class_ 2
set sink_(42) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(42)
$ns attach-agent $node_(36) $sink_(42)
$ns connect $tcp_(42) $sink_(42)
set ftp_(42) [new Application/FTP]
$ftp_(42) attach-agent $tcp_(42)
$ns at 360.2 "$ftp_(42) start"
$ns at 540.0 "$ftp_(42) stop"

#Set a TCP connection between node_(39) and node_(48)
set tcp_(43) [new Agent/TCP/Newreno]
$tcp_(43) set class_ 2
set sink_(43) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(43)
$ns attach-agent $node_(48) $sink_(43)
$ns connect $tcp_(43) $sink_(43)
set ftp_(43) [new Application/FTP]
$ftp_(43) attach-agent $tcp_(43)
$ns at 540.2 "$ftp_(43) start"
$ns at 720.0 "$ftp_(43) stop"

#Set a TCP connection between node_(1) and node_(23)
set tcp_(44) [new Agent/TCP/Newreno]
$tcp_(44) set class_ 2
set sink_(44) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(44)
$ns attach-agent $node_(23) $sink_(44)
$ns connect $tcp_(44) $sink_(44)
set ftp_(44) [new Application/FTP]
$ftp_(44) attach-agent $tcp_(44)
$ns at 720.2 "$ftp_(44) start"
$ns at 900.0 "$ftp_(44) stop"

#Set a TCP connection between node_(5) and node_(8)
set tcp_(45) [new Agent/TCP/Newreno]
$tcp_(45) set class_ 2
set sink_(45) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(45)
$ns attach-agent $node_(8) $sink_(45)
$ns connect $tcp_(45) $sink_(45)
set ftp_(45) [new Application/FTP]
$ftp_(45) attach-agent $tcp_(45)
$ns at 0.2 "$ftp_(45) start"
$ns at 180.0 "$ftp_(45) stop"

#Set a TCP connection between node_(24) and node_(42)
set tcp_(46) [new Agent/TCP/Newreno]
$tcp_(46) set class_ 2
set sink_(46) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(46)
$ns attach-agent $node_(42) $sink_(46)
$ns connect $tcp_(46) $sink_(46)
set ftp_(46) [new Application/FTP]
$ftp_(46) attach-agent $tcp_(46)
$ns at 180.2 "$ftp_(46) start"
$ns at 360.0 "$ftp_(46) stop"

#Set a TCP connection between node_(38) and node_(25)
set tcp_(47) [new Agent/TCP/Newreno]
$tcp_(47) set class_ 2
set sink_(47) [new Agent/TCPSink]
$ns attach-agent $node_(38) $tcp_(47)
$ns attach-agent $node_(25) $sink_(47)
$ns connect $tcp_(47) $sink_(47)
set ftp_(47) [new Application/FTP]
$ftp_(47) attach-agent $tcp_(47)
$ns at 360.2 "$ftp_(47) start"
$ns at 540.0 "$ftp_(47) stop"

#Set a TCP connection between node_(38) and node_(23)
set tcp_(48) [new Agent/TCP/Newreno]
$tcp_(48) set class_ 2
set sink_(48) [new Agent/TCPSink]
$ns attach-agent $node_(38) $tcp_(48)
$ns attach-agent $node_(23) $sink_(48)
$ns connect $tcp_(48) $sink_(48)
set ftp_(48) [new Application/FTP]
$ftp_(48) attach-agent $tcp_(48)
$ns at 540.2 "$ftp_(48) start"
$ns at 720.0 "$ftp_(48) stop"

#Set a TCP connection between node_(9) and node_(34)
set tcp_(49) [new Agent/TCP/Newreno]
$tcp_(49) set class_ 2
set sink_(49) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(49)
$ns attach-agent $node_(34) $sink_(49)
$ns connect $tcp_(49) $sink_(49)
set ftp_(49) [new Application/FTP]
$ftp_(49) attach-agent $tcp_(49)
$ns at 720.2 "$ftp_(49) start"
$ns at 900.0 "$ftp_(49) stop"

#Set a TCP connection between node_(28) and node_(40)
set tcp_(50) [new Agent/TCP/Newreno]
$tcp_(50) set class_ 2
set sink_(50) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(50)
$ns attach-agent $node_(40) $sink_(50)
$ns connect $tcp_(50) $sink_(50)
set ftp_(50) [new Application/FTP]
$ftp_(50) attach-agent $tcp_(50)
$ns at 0.2 "$ftp_(50) start"
$ns at 180.0 "$ftp_(50) stop"

#Set a TCP connection between node_(36) and node_(41)
set tcp_(51) [new Agent/TCP/Newreno]
$tcp_(51) set class_ 2
set sink_(51) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(51)
$ns attach-agent $node_(41) $sink_(51)
$ns connect $tcp_(51) $sink_(51)
set ftp_(51) [new Application/FTP]
$ftp_(51) attach-agent $tcp_(51)
$ns at 180.2 "$ftp_(51) start"
$ns at 360.0 "$ftp_(51) stop"

#Set a TCP connection between node_(18) and node_(23)
set tcp_(52) [new Agent/TCP/Newreno]
$tcp_(52) set class_ 2
set sink_(52) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(52)
$ns attach-agent $node_(23) $sink_(52)
$ns connect $tcp_(52) $sink_(52)
set ftp_(52) [new Application/FTP]
$ftp_(52) attach-agent $tcp_(52)
$ns at 360.2 "$ftp_(52) start"
$ns at 540.0 "$ftp_(52) stop"

#Set a TCP connection between node_(15) and node_(37)
set tcp_(53) [new Agent/TCP/Newreno]
$tcp_(53) set class_ 2
set sink_(53) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(53)
$ns attach-agent $node_(37) $sink_(53)
$ns connect $tcp_(53) $sink_(53)
set ftp_(53) [new Application/FTP]
$ftp_(53) attach-agent $tcp_(53)
$ns at 540.2 "$ftp_(53) start"
$ns at 720.0 "$ftp_(53) stop"

#Set a TCP connection between node_(21) and node_(32)
set tcp_(54) [new Agent/TCP/Newreno]
$tcp_(54) set class_ 2
set sink_(54) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(54)
$ns attach-agent $node_(32) $sink_(54)
$ns connect $tcp_(54) $sink_(54)
set ftp_(54) [new Application/FTP]
$ftp_(54) attach-agent $tcp_(54)
$ns at 720.2 "$ftp_(54) start"
$ns at 900.0 "$ftp_(54) stop"

#Set a TCP connection between node_(7) and node_(4)
set tcp_(55) [new Agent/TCP/Newreno]
$tcp_(55) set class_ 2
set sink_(55) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(55)
$ns attach-agent $node_(4) $sink_(55)
$ns connect $tcp_(55) $sink_(55)
set ftp_(55) [new Application/FTP]
$ftp_(55) attach-agent $tcp_(55)
$ns at 0.2 "$ftp_(55) start"
$ns at 180.0 "$ftp_(55) stop"

#Set a TCP connection between node_(43) and node_(17)
set tcp_(56) [new Agent/TCP/Newreno]
$tcp_(56) set class_ 2
set sink_(56) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(56)
$ns attach-agent $node_(17) $sink_(56)
$ns connect $tcp_(56) $sink_(56)
set ftp_(56) [new Application/FTP]
$ftp_(56) attach-agent $tcp_(56)
$ns at 180.2 "$ftp_(56) start"
$ns at 360.0 "$ftp_(56) stop"

#Set a TCP connection between node_(27) and node_(9)
set tcp_(57) [new Agent/TCP/Newreno]
$tcp_(57) set class_ 2
set sink_(57) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(57)
$ns attach-agent $node_(9) $sink_(57)
$ns connect $tcp_(57) $sink_(57)
set ftp_(57) [new Application/FTP]
$ftp_(57) attach-agent $tcp_(57)
$ns at 360.2 "$ftp_(57) start"
$ns at 540.0 "$ftp_(57) stop"

#Set a TCP connection between node_(33) and node_(18)
set tcp_(58) [new Agent/TCP/Newreno]
$tcp_(58) set class_ 2
set sink_(58) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(58)
$ns attach-agent $node_(18) $sink_(58)
$ns connect $tcp_(58) $sink_(58)
set ftp_(58) [new Application/FTP]
$ftp_(58) attach-agent $tcp_(58)
$ns at 540.2 "$ftp_(58) start"
$ns at 720.0 "$ftp_(58) stop"

#Set a TCP connection between node_(31) and node_(2)
set tcp_(59) [new Agent/TCP/Newreno]
$tcp_(59) set class_ 2
set sink_(59) [new Agent/TCPSink]
$ns attach-agent $node_(31) $tcp_(59)
$ns attach-agent $node_(2) $sink_(59)
$ns connect $tcp_(59) $sink_(59)
set ftp_(59) [new Application/FTP]
$ftp_(59) attach-agent $tcp_(59)
$ns at 720.2 "$ftp_(59) start"
$ns at 900.0 "$ftp_(59) stop"

#Set a TCP connection between node_(7) and node_(39)
set tcp_(60) [new Agent/TCP/Newreno]
$tcp_(60) set class_ 2
set sink_(60) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(60)
$ns attach-agent $node_(39) $sink_(60)
$ns connect $tcp_(60) $sink_(60)
set ftp_(60) [new Application/FTP]
$ftp_(60) attach-agent $tcp_(60)
$ns at 0.2 "$ftp_(60) start"
$ns at 180.0 "$ftp_(60) stop"

#Set a TCP connection between node_(0) and node_(7)
set tcp_(61) [new Agent/TCP/Newreno]
$tcp_(61) set class_ 2
set sink_(61) [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp_(61)
$ns attach-agent $node_(7) $sink_(61)
$ns connect $tcp_(61) $sink_(61)
set ftp_(61) [new Application/FTP]
$ftp_(61) attach-agent $tcp_(61)
$ns at 180.2 "$ftp_(61) start"
$ns at 360.0 "$ftp_(61) stop"

#Set a TCP connection between node_(15) and node_(10)
set tcp_(62) [new Agent/TCP/Newreno]
$tcp_(62) set class_ 2
set sink_(62) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(62)
$ns attach-agent $node_(10) $sink_(62)
$ns connect $tcp_(62) $sink_(62)
set ftp_(62) [new Application/FTP]
$ftp_(62) attach-agent $tcp_(62)
$ns at 360.2 "$ftp_(62) start"
$ns at 540.0 "$ftp_(62) stop"

#Set a TCP connection between node_(37) and node_(30)
set tcp_(63) [new Agent/TCP/Newreno]
$tcp_(63) set class_ 2
set sink_(63) [new Agent/TCPSink]
$ns attach-agent $node_(37) $tcp_(63)
$ns attach-agent $node_(30) $sink_(63)
$ns connect $tcp_(63) $sink_(63)
set ftp_(63) [new Application/FTP]
$ftp_(63) attach-agent $tcp_(63)
$ns at 540.2 "$ftp_(63) start"
$ns at 720.0 "$ftp_(63) stop"

#Set a TCP connection between node_(44) and node_(45)
set tcp_(64) [new Agent/TCP/Newreno]
$tcp_(64) set class_ 2
set sink_(64) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(64)
$ns attach-agent $node_(45) $sink_(64)
$ns connect $tcp_(64) $sink_(64)
set ftp_(64) [new Application/FTP]
$ftp_(64) attach-agent $tcp_(64)
$ns at 720.2 "$ftp_(64) start"
$ns at 900.0 "$ftp_(64) stop"

#Set a TCP connection between node_(32) and node_(24)
set tcp_(65) [new Agent/TCP/Newreno]
$tcp_(65) set class_ 2
set sink_(65) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(65)
$ns attach-agent $node_(24) $sink_(65)
$ns connect $tcp_(65) $sink_(65)
set ftp_(65) [new Application/FTP]
$ftp_(65) attach-agent $tcp_(65)
$ns at 0.2 "$ftp_(65) start"
$ns at 180.0 "$ftp_(65) stop"

#Set a TCP connection between node_(39) and node_(34)
set tcp_(66) [new Agent/TCP/Newreno]
$tcp_(66) set class_ 2
set sink_(66) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(66)
$ns attach-agent $node_(34) $sink_(66)
$ns connect $tcp_(66) $sink_(66)
set ftp_(66) [new Application/FTP]
$ftp_(66) attach-agent $tcp_(66)
$ns at 180.2 "$ftp_(66) start"
$ns at 360.0 "$ftp_(66) stop"

#Set a TCP connection between node_(15) and node_(44)
set tcp_(67) [new Agent/TCP/Newreno]
$tcp_(67) set class_ 2
set sink_(67) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(67)
$ns attach-agent $node_(44) $sink_(67)
$ns connect $tcp_(67) $sink_(67)
set ftp_(67) [new Application/FTP]
$ftp_(67) attach-agent $tcp_(67)
$ns at 360.2 "$ftp_(67) start"
$ns at 540.0 "$ftp_(67) stop"

#Set a TCP connection between node_(4) and node_(15)
set tcp_(68) [new Agent/TCP/Newreno]
$tcp_(68) set class_ 2
set sink_(68) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(68)
$ns attach-agent $node_(15) $sink_(68)
$ns connect $tcp_(68) $sink_(68)
set ftp_(68) [new Application/FTP]
$ftp_(68) attach-agent $tcp_(68)
$ns at 540.2 "$ftp_(68) start"
$ns at 720.0 "$ftp_(68) stop"

#Set a TCP connection between node_(32) and node_(26)
set tcp_(69) [new Agent/TCP/Newreno]
$tcp_(69) set class_ 2
set sink_(69) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(69)
$ns attach-agent $node_(26) $sink_(69)
$ns connect $tcp_(69) $sink_(69)
set ftp_(69) [new Application/FTP]
$ftp_(69) attach-agent $tcp_(69)
$ns at 720.2 "$ftp_(69) start"
$ns at 900.0 "$ftp_(69) stop"

#Set a TCP connection between node_(40) and node_(41)
set tcp_(70) [new Agent/TCP/Newreno]
$tcp_(70) set class_ 2
set sink_(70) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(70)
$ns attach-agent $node_(41) $sink_(70)
$ns connect $tcp_(70) $sink_(70)
set ftp_(70) [new Application/FTP]
$ftp_(70) attach-agent $tcp_(70)
$ns at 0.2 "$ftp_(70) start"
$ns at 180.0 "$ftp_(70) stop"

#Set a TCP connection between node_(32) and node_(14)
set tcp_(71) [new Agent/TCP/Newreno]
$tcp_(71) set class_ 2
set sink_(71) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(71)
$ns attach-agent $node_(14) $sink_(71)
$ns connect $tcp_(71) $sink_(71)
set ftp_(71) [new Application/FTP]
$ftp_(71) attach-agent $tcp_(71)
$ns at 180.2 "$ftp_(71) start"
$ns at 360.0 "$ftp_(71) stop"

#Set a TCP connection between node_(39) and node_(35)
set tcp_(72) [new Agent/TCP/Newreno]
$tcp_(72) set class_ 2
set sink_(72) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(72)
$ns attach-agent $node_(35) $sink_(72)
$ns connect $tcp_(72) $sink_(72)
set ftp_(72) [new Application/FTP]
$ftp_(72) attach-agent $tcp_(72)
$ns at 360.2 "$ftp_(72) start"
$ns at 540.0 "$ftp_(72) stop"

#Set a TCP connection between node_(48) and node_(44)
set tcp_(73) [new Agent/TCP/Newreno]
$tcp_(73) set class_ 2
set sink_(73) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(73)
$ns attach-agent $node_(44) $sink_(73)
$ns connect $tcp_(73) $sink_(73)
set ftp_(73) [new Application/FTP]
$ftp_(73) attach-agent $tcp_(73)
$ns at 540.2 "$ftp_(73) start"
$ns at 720.0 "$ftp_(73) stop"

#Set a TCP connection between node_(15) and node_(46)
set tcp_(74) [new Agent/TCP/Newreno]
$tcp_(74) set class_ 2
set sink_(74) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(74)
$ns attach-agent $node_(46) $sink_(74)
$ns connect $tcp_(74) $sink_(74)
set ftp_(74) [new Application/FTP]
$ftp_(74) attach-agent $tcp_(74)
$ns at 720.2 "$ftp_(74) start"
$ns at 900.0 "$ftp_(74) stop"

#Set a TCP connection between node_(29) and node_(18)
set tcp_(75) [new Agent/TCP/Newreno]
$tcp_(75) set class_ 2
set sink_(75) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(75)
$ns attach-agent $node_(18) $sink_(75)
$ns connect $tcp_(75) $sink_(75)
set ftp_(75) [new Application/FTP]
$ftp_(75) attach-agent $tcp_(75)
$ns at 0.2 "$ftp_(75) start"
$ns at 180.0 "$ftp_(75) stop"

#Set a TCP connection between node_(3) and node_(19)
set tcp_(76) [new Agent/TCP/Newreno]
$tcp_(76) set class_ 2
set sink_(76) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(76)
$ns attach-agent $node_(19) $sink_(76)
$ns connect $tcp_(76) $sink_(76)
set ftp_(76) [new Application/FTP]
$ftp_(76) attach-agent $tcp_(76)
$ns at 180.2 "$ftp_(76) start"
$ns at 360.0 "$ftp_(76) stop"

#Set a TCP connection between node_(7) and node_(38)
set tcp_(77) [new Agent/TCP/Newreno]
$tcp_(77) set class_ 2
set sink_(77) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(77)
$ns attach-agent $node_(38) $sink_(77)
$ns connect $tcp_(77) $sink_(77)
set ftp_(77) [new Application/FTP]
$ftp_(77) attach-agent $tcp_(77)
$ns at 360.2 "$ftp_(77) start"
$ns at 540.0 "$ftp_(77) stop"

#Set a TCP connection between node_(32) and node_(13)
set tcp_(78) [new Agent/TCP/Newreno]
$tcp_(78) set class_ 2
set sink_(78) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(78)
$ns attach-agent $node_(13) $sink_(78)
$ns connect $tcp_(78) $sink_(78)
set ftp_(78) [new Application/FTP]
$ftp_(78) attach-agent $tcp_(78)
$ns at 540.2 "$ftp_(78) start"
$ns at 720.0 "$ftp_(78) stop"

#Set a TCP connection between node_(13) and node_(0)
set tcp_(79) [new Agent/TCP/Newreno]
$tcp_(79) set class_ 2
set sink_(79) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(79)
$ns attach-agent $node_(0) $sink_(79)
$ns connect $tcp_(79) $sink_(79)
set ftp_(79) [new Application/FTP]
$ftp_(79) attach-agent $tcp_(79)
$ns at 720.2 "$ftp_(79) start"
$ns at 900.0 "$ftp_(79) stop"

#Set a TCP connection between node_(4) and node_(40)
set tcp_(80) [new Agent/TCP/Newreno]
$tcp_(80) set class_ 2
set sink_(80) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(80)
$ns attach-agent $node_(40) $sink_(80)
$ns connect $tcp_(80) $sink_(80)
set ftp_(80) [new Application/FTP]
$ftp_(80) attach-agent $tcp_(80)
$ns at 0.2 "$ftp_(80) start"
$ns at 180.0 "$ftp_(80) stop"

#Set a TCP connection between node_(5) and node_(29)
set tcp_(81) [new Agent/TCP/Newreno]
$tcp_(81) set class_ 2
set sink_(81) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(81)
$ns attach-agent $node_(29) $sink_(81)
$ns connect $tcp_(81) $sink_(81)
set ftp_(81) [new Application/FTP]
$ftp_(81) attach-agent $tcp_(81)
$ns at 180.2 "$ftp_(81) start"
$ns at 360.0 "$ftp_(81) stop"

#Set a TCP connection between node_(5) and node_(15)
set tcp_(82) [new Agent/TCP/Newreno]
$tcp_(82) set class_ 2
set sink_(82) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(82)
$ns attach-agent $node_(15) $sink_(82)
$ns connect $tcp_(82) $sink_(82)
set ftp_(82) [new Application/FTP]
$ftp_(82) attach-agent $tcp_(82)
$ns at 360.2 "$ftp_(82) start"
$ns at 540.0 "$ftp_(82) stop"

#Set a TCP connection between node_(2) and node_(23)
set tcp_(83) [new Agent/TCP/Newreno]
$tcp_(83) set class_ 2
set sink_(83) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(83)
$ns attach-agent $node_(23) $sink_(83)
$ns connect $tcp_(83) $sink_(83)
set ftp_(83) [new Application/FTP]
$ftp_(83) attach-agent $tcp_(83)
$ns at 540.2 "$ftp_(83) start"
$ns at 720.0 "$ftp_(83) stop"

#Set a TCP connection between node_(48) and node_(46)
set tcp_(84) [new Agent/TCP/Newreno]
$tcp_(84) set class_ 2
set sink_(84) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(84)
$ns attach-agent $node_(46) $sink_(84)
$ns connect $tcp_(84) $sink_(84)
set ftp_(84) [new Application/FTP]
$ftp_(84) attach-agent $tcp_(84)
$ns at 720.2 "$ftp_(84) start"
$ns at 900.0 "$ftp_(84) stop"

#Set a TCP connection between node_(19) and node_(39)
set tcp_(85) [new Agent/TCP/Newreno]
$tcp_(85) set class_ 2
set sink_(85) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(85)
$ns attach-agent $node_(39) $sink_(85)
$ns connect $tcp_(85) $sink_(85)
set ftp_(85) [new Application/FTP]
$ftp_(85) attach-agent $tcp_(85)
$ns at 0.2 "$ftp_(85) start"
$ns at 180.0 "$ftp_(85) stop"

#Set a TCP connection between node_(7) and node_(41)
set tcp_(86) [new Agent/TCP/Newreno]
$tcp_(86) set class_ 2
set sink_(86) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(86)
$ns attach-agent $node_(41) $sink_(86)
$ns connect $tcp_(86) $sink_(86)
set ftp_(86) [new Application/FTP]
$ftp_(86) attach-agent $tcp_(86)
$ns at 180.2 "$ftp_(86) start"
$ns at 360.0 "$ftp_(86) stop"

#Set a TCP connection between node_(3) and node_(42)
set tcp_(87) [new Agent/TCP/Newreno]
$tcp_(87) set class_ 2
set sink_(87) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(87)
$ns attach-agent $node_(42) $sink_(87)
$ns connect $tcp_(87) $sink_(87)
set ftp_(87) [new Application/FTP]
$ftp_(87) attach-agent $tcp_(87)
$ns at 360.2 "$ftp_(87) start"
$ns at 540.0 "$ftp_(87) stop"

#Set a TCP connection between node_(43) and node_(13)
set tcp_(88) [new Agent/TCP/Newreno]
$tcp_(88) set class_ 2
set sink_(88) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(88)
$ns attach-agent $node_(13) $sink_(88)
$ns connect $tcp_(88) $sink_(88)
set ftp_(88) [new Application/FTP]
$ftp_(88) attach-agent $tcp_(88)
$ns at 540.2 "$ftp_(88) start"
$ns at 720.0 "$ftp_(88) stop"

#Set a TCP connection between node_(12) and node_(48)
set tcp_(89) [new Agent/TCP/Newreno]
$tcp_(89) set class_ 2
set sink_(89) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(89)
$ns attach-agent $node_(48) $sink_(89)
$ns connect $tcp_(89) $sink_(89)
set ftp_(89) [new Application/FTP]
$ftp_(89) attach-agent $tcp_(89)
$ns at 720.2 "$ftp_(89) start"
$ns at 900.0 "$ftp_(89) stop"

#Set a TCP connection between node_(11) and node_(8)
set tcp_(90) [new Agent/TCP/Newreno]
$tcp_(90) set class_ 2
set sink_(90) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(90)
$ns attach-agent $node_(8) $sink_(90)
$ns connect $tcp_(90) $sink_(90)
set ftp_(90) [new Application/FTP]
$ftp_(90) attach-agent $tcp_(90)
$ns at 0.2 "$ftp_(90) start"
$ns at 180.0 "$ftp_(90) stop"

#Set a TCP connection between node_(19) and node_(36)
set tcp_(91) [new Agent/TCP/Newreno]
$tcp_(91) set class_ 2
set sink_(91) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(91)
$ns attach-agent $node_(36) $sink_(91)
$ns connect $tcp_(91) $sink_(91)
set ftp_(91) [new Application/FTP]
$ftp_(91) attach-agent $tcp_(91)
$ns at 180.2 "$ftp_(91) start"
$ns at 360.0 "$ftp_(91) stop"

#Set a TCP connection between node_(47) and node_(15)
set tcp_(92) [new Agent/TCP/Newreno]
$tcp_(92) set class_ 2
set sink_(92) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(92)
$ns attach-agent $node_(15) $sink_(92)
$ns connect $tcp_(92) $sink_(92)
set ftp_(92) [new Application/FTP]
$ftp_(92) attach-agent $tcp_(92)
$ns at 360.2 "$ftp_(92) start"
$ns at 540.0 "$ftp_(92) stop"

#Set a TCP connection between node_(6) and node_(42)
set tcp_(93) [new Agent/TCP/Newreno]
$tcp_(93) set class_ 2
set sink_(93) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(93)
$ns attach-agent $node_(42) $sink_(93)
$ns connect $tcp_(93) $sink_(93)
set ftp_(93) [new Application/FTP]
$ftp_(93) attach-agent $tcp_(93)
$ns at 540.2 "$ftp_(93) start"
$ns at 720.0 "$ftp_(93) stop"

#Set a TCP connection between node_(6) and node_(21)
set tcp_(94) [new Agent/TCP/Newreno]
$tcp_(94) set class_ 2
set sink_(94) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(94)
$ns attach-agent $node_(21) $sink_(94)
$ns connect $tcp_(94) $sink_(94)
set ftp_(94) [new Application/FTP]
$ftp_(94) attach-agent $tcp_(94)
$ns at 720.2 "$ftp_(94) start"
$ns at 900.0 "$ftp_(94) stop"

#Set a TCP connection between node_(42) and node_(40)
set tcp_(95) [new Agent/TCP/Newreno]
$tcp_(95) set class_ 2
set sink_(95) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(95)
$ns attach-agent $node_(40) $sink_(95)
$ns connect $tcp_(95) $sink_(95)
set ftp_(95) [new Application/FTP]
$ftp_(95) attach-agent $tcp_(95)
$ns at 0.2 "$ftp_(95) start"
$ns at 180.0 "$ftp_(95) stop"

#Set a TCP connection between node_(31) and node_(15)
set tcp_(96) [new Agent/TCP/Newreno]
$tcp_(96) set class_ 2
set sink_(96) [new Agent/TCPSink]
$ns attach-agent $node_(31) $tcp_(96)
$ns attach-agent $node_(15) $sink_(96)
$ns connect $tcp_(96) $sink_(96)
set ftp_(96) [new Application/FTP]
$ftp_(96) attach-agent $tcp_(96)
$ns at 180.2 "$ftp_(96) start"
$ns at 360.0 "$ftp_(96) stop"

#Set a TCP connection between node_(10) and node_(41)
set tcp_(97) [new Agent/TCP/Newreno]
$tcp_(97) set class_ 2
set sink_(97) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(97)
$ns attach-agent $node_(41) $sink_(97)
$ns connect $tcp_(97) $sink_(97)
set ftp_(97) [new Application/FTP]
$ftp_(97) attach-agent $tcp_(97)
$ns at 360.2 "$ftp_(97) start"
$ns at 540.0 "$ftp_(97) stop"

#Set a TCP connection between node_(33) and node_(20)
set tcp_(98) [new Agent/TCP/Newreno]
$tcp_(98) set class_ 2
set sink_(98) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(98)
$ns attach-agent $node_(20) $sink_(98)
$ns connect $tcp_(98) $sink_(98)
set ftp_(98) [new Application/FTP]
$ftp_(98) attach-agent $tcp_(98)
$ns at 540.2 "$ftp_(98) start"
$ns at 720.0 "$ftp_(98) stop"

#Set a TCP connection between node_(43) and node_(1)
set tcp_(99) [new Agent/TCP/Newreno]
$tcp_(99) set class_ 2
set sink_(99) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(99)
$ns attach-agent $node_(1) $sink_(99)
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
