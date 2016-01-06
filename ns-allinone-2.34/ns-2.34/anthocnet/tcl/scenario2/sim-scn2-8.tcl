#sim-scn2-8.tcl 
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
set tracefd       [open sim-scn2-8-$val(rp)-trace.tr w]
set windowVsTime2 [open sim-scn2-8-$val(rp)-win-.tr w]
set namtrace      [open sim-scn2-8-$val(rp).nam w]

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
$node_(0) set X_ 547 
$node_(0) set Y_ 192 
$node_(0) set Z_ 0.0 
$node_(1) set X_ 1152 
$node_(1) set Y_ 891 
$node_(1) set Z_ 0.0 
$node_(2) set X_ 98 
$node_(2) set Y_ 62 
$node_(2) set Z_ 0.0 
$node_(3) set X_ 710 
$node_(3) set Y_ 385 
$node_(3) set Z_ 0.0 
$node_(4) set X_ 2780 
$node_(4) set Y_ 216 
$node_(4) set Z_ 0.0 
$node_(5) set X_ 331 
$node_(5) set Y_ 584 
$node_(5) set Z_ 0.0 
$node_(6) set X_ 951 
$node_(6) set Y_ 738 
$node_(6) set Z_ 0.0 
$node_(7) set X_ 1222 
$node_(7) set Y_ 191 
$node_(7) set Z_ 0.0 
$node_(8) set X_ 424 
$node_(8) set Y_ 299 
$node_(8) set Z_ 0.0 
$node_(9) set X_ 2592 
$node_(9) set Y_ 145 
$node_(9) set Z_ 0.0 
$node_(10) set X_ 490 
$node_(10) set Y_ 129 
$node_(10) set Z_ 0.0 
$node_(11) set X_ 1049 
$node_(11) set Y_ 729 
$node_(11) set Z_ 0.0 
$node_(12) set X_ 1660 
$node_(12) set Y_ 507 
$node_(12) set Z_ 0.0 
$node_(13) set X_ 808 
$node_(13) set Y_ 610 
$node_(13) set Z_ 0.0 
$node_(14) set X_ 1075 
$node_(14) set Y_ 685 
$node_(14) set Z_ 0.0 
$node_(15) set X_ 590 
$node_(15) set Y_ 794 
$node_(15) set Z_ 0.0 
$node_(16) set X_ 1569 
$node_(16) set Y_ 372 
$node_(16) set Z_ 0.0 
$node_(17) set X_ 246 
$node_(17) set Y_ 455 
$node_(17) set Z_ 0.0 
$node_(18) set X_ 2296 
$node_(18) set Y_ 950 
$node_(18) set Z_ 0.0 
$node_(19) set X_ 664 
$node_(19) set Y_ 66 
$node_(19) set Z_ 0.0 
$node_(20) set X_ 2778 
$node_(20) set Y_ 670 
$node_(20) set Z_ 0.0 
$node_(21) set X_ 597 
$node_(21) set Y_ 52 
$node_(21) set Z_ 0.0 
$node_(22) set X_ 1122 
$node_(22) set Y_ 923 
$node_(22) set Z_ 0.0 
$node_(23) set X_ 517 
$node_(23) set Y_ 471 
$node_(23) set Z_ 0.0 
$node_(24) set X_ 2018 
$node_(24) set Y_ 544 
$node_(24) set Z_ 0.0 
$node_(25) set X_ 606 
$node_(25) set Y_ 821 
$node_(25) set Z_ 0.0 
$node_(26) set X_ 2975 
$node_(26) set Y_ 798 
$node_(26) set Z_ 0.0 
$node_(27) set X_ 2433 
$node_(27) set Y_ 175 
$node_(27) set Z_ 0.0 
$node_(28) set X_ 2052 
$node_(28) set Y_ 355 
$node_(28) set Z_ 0.0 
$node_(29) set X_ 1746 
$node_(29) set Y_ 265 
$node_(29) set Z_ 0.0 
$node_(30) set X_ 94 
$node_(30) set Y_ 72 
$node_(30) set Z_ 0.0 
$node_(31) set X_ 1264 
$node_(31) set Y_ 16 
$node_(31) set Z_ 0.0 
$node_(32) set X_ 1262 
$node_(32) set Y_ 861 
$node_(32) set Z_ 0.0 
$node_(33) set X_ 107 
$node_(33) set Y_ 311 
$node_(33) set Z_ 0.0 
$node_(34) set X_ 321 
$node_(34) set Y_ 261 
$node_(34) set Z_ 0.0 
$node_(35) set X_ 921 
$node_(35) set Y_ 420 
$node_(35) set Z_ 0.0 
$node_(36) set X_ 850 
$node_(36) set Y_ 589 
$node_(36) set Z_ 0.0 
$node_(37) set X_ 1450 
$node_(37) set Y_ 631 
$node_(37) set Z_ 0.0 
$node_(38) set X_ 1172 
$node_(38) set Y_ 709 
$node_(38) set Z_ 0.0 
$node_(39) set X_ 1649 
$node_(39) set Y_ 108 
$node_(39) set Z_ 0.0 
$node_(40) set X_ 1432 
$node_(40) set Y_ 518 
$node_(40) set Z_ 0.0 
$node_(41) set X_ 2089 
$node_(41) set Y_ 869 
$node_(41) set Z_ 0.0 
$node_(42) set X_ 2818 
$node_(42) set Y_ 232 
$node_(42) set Z_ 0.0 
$node_(43) set X_ 1638 
$node_(43) set Y_ 138 
$node_(43) set Z_ 0.0 
$node_(44) set X_ 498 
$node_(44) set Y_ 428 
$node_(44) set Z_ 0.0 
$node_(45) set X_ 2058 
$node_(45) set Y_ 949 
$node_(45) set Z_ 0.0 
$node_(46) set X_ 1342 
$node_(46) set Y_ 581 
$node_(46) set Z_ 0.0 
$node_(47) set X_ 278 
$node_(47) set Y_ 88 
$node_(47) set Z_ 0.0 
$node_(48) set X_ 4 
$node_(48) set Y_ 540 
$node_(48) set Z_ 0.0 
$node_(49) set X_ 724 
$node_(49) set Y_ 893 
$node_(49) set Z_ 0.0 
$node_(50) set X_ 404 
$node_(50) set Y_ 970 
$node_(50) set Z_ 0.0 
$node_(51) set X_ 124 
$node_(51) set Y_ 427 
$node_(51) set Z_ 0.0 
$ns at 0.0 "$node_(51) off" 
$ns at 165.0 "$node_(51) on" 
$node_(52) set X_ 1067 
$node_(52) set Y_ 302 
$node_(52) set Z_ 0.0 
$ns at 0.0 "$node_(52) off" 
$ns at 165.0 "$node_(52) on" 
$node_(53) set X_ 796 
$node_(53) set Y_ 823 
$node_(53) set Z_ 0.0 
$ns at 0.0 "$node_(53) off" 
$ns at 165.0 "$node_(53) on" 
$node_(54) set X_ 2170 
$node_(54) set Y_ 147 
$node_(54) set Z_ 0.0 
$ns at 0.0 "$node_(54) off" 
$ns at 165.0 "$node_(54) on" 
$node_(55) set X_ 2366 
$node_(55) set Y_ 378 
$node_(55) set Z_ 0.0 
$ns at 0.0 "$node_(55) off" 
$ns at 165.0 "$node_(55) on" 
$node_(56) set X_ 2538 
$node_(56) set Y_ 431 
$node_(56) set Z_ 0.0 
$ns at 0.0 "$node_(56) off" 
$ns at 165.0 "$node_(56) on" 
$node_(57) set X_ 2407 
$node_(57) set Y_ 75 
$node_(57) set Z_ 0.0 
$ns at 0.0 "$node_(57) off" 
$ns at 165.0 "$node_(57) on" 
$node_(58) set X_ 2137 
$node_(58) set Y_ 753 
$node_(58) set Z_ 0.0 
$ns at 0.0 "$node_(58) off" 
$ns at 165.0 "$node_(58) on" 
$node_(59) set X_ 380 
$node_(59) set Y_ 822 
$node_(59) set Z_ 0.0 
$ns at 0.0 "$node_(59) off" 
$ns at 165.0 "$node_(59) on" 
$node_(60) set X_ 2929 
$node_(60) set Y_ 584 
$node_(60) set Z_ 0.0 
$ns at 0.0 "$node_(60) off" 
$ns at 165.0 "$node_(60) on" 
$node_(61) set X_ 2702 
$node_(61) set Y_ 589 
$node_(61) set Z_ 0.0 
$ns at 0.0 "$node_(61) off" 
$ns at 165.0 "$node_(61) on" 
$node_(62) set X_ 1228 
$node_(62) set Y_ 958 
$node_(62) set Z_ 0.0 
$ns at 0.0 "$node_(62) off" 
$ns at 165.0 "$node_(62) on" 
$node_(63) set X_ 649 
$node_(63) set Y_ 43 
$node_(63) set Z_ 0.0 
$ns at 0.0 "$node_(63) off" 
$ns at 165.0 "$node_(63) on" 
$node_(64) set X_ 2940 
$node_(64) set Y_ 269 
$node_(64) set Z_ 0.0 
$ns at 0.0 "$node_(64) off" 
$ns at 165.0 "$node_(64) on" 
$node_(65) set X_ 2117 
$node_(65) set Y_ 22 
$node_(65) set Z_ 0.0 
$ns at 0.0 "$node_(65) off" 
$ns at 165.0 "$node_(65) on" 
$node_(66) set X_ 1259 
$node_(66) set Y_ 606 
$node_(66) set Z_ 0.0 
$ns at 0.0 "$node_(66) off" 
$ns at 165.0 "$node_(66) on" 
$node_(67) set X_ 2135 
$node_(67) set Y_ 369 
$node_(67) set Z_ 0.0 
$ns at 0.0 "$node_(67) off" 
$ns at 165.0 "$node_(67) on" 
$node_(68) set X_ 601 
$node_(68) set Y_ 849 
$node_(68) set Z_ 0.0 
$ns at 0.0 "$node_(68) off" 
$ns at 165.0 "$node_(68) on" 
$node_(69) set X_ 1280 
$node_(69) set Y_ 244 
$node_(69) set Z_ 0.0 
$ns at 0.0 "$node_(69) off" 
$ns at 165.0 "$node_(69) on" 
$node_(70) set X_ 1678 
$node_(70) set Y_ 366 
$node_(70) set Z_ 0.0 
$ns at 0.0 "$node_(70) off" 
$ns at 165.0 "$node_(70) on" 
$node_(71) set X_ 887 
$node_(71) set Y_ 2 
$node_(71) set Z_ 0.0 
$ns at 0.0 "$node_(71) off" 
$ns at 165.0 "$node_(71) on" 
$node_(72) set X_ 1750 
$node_(72) set Y_ 769 
$node_(72) set Z_ 0.0 
$ns at 0.0 "$node_(72) off" 
$ns at 165.0 "$node_(72) on" 
$node_(73) set X_ 229 
$node_(73) set Y_ 139 
$node_(73) set Z_ 0.0 
$ns at 0.0 "$node_(73) off" 
$ns at 165.0 "$node_(73) on" 
$node_(74) set X_ 1166 
$node_(74) set Y_ 616 
$node_(74) set Z_ 0.0 
$ns at 0.0 "$node_(74) off" 
$ns at 165.0 "$node_(74) on" 
$node_(75) set X_ 462 
$node_(75) set Y_ 594 
$node_(75) set Z_ 0.0 
$ns at 0.0 "$node_(75) off" 
$ns at 330.0 "$node_(75) on" 
$node_(76) set X_ 361 
$node_(76) set Y_ 353 
$node_(76) set Z_ 0.0 
$ns at 0.0 "$node_(76) off" 
$ns at 330.0 "$node_(76) on" 
$node_(77) set X_ 361 
$node_(77) set Y_ 909 
$node_(77) set Z_ 0.0 
$ns at 0.0 "$node_(77) off" 
$ns at 330.0 "$node_(77) on" 
$node_(78) set X_ 2502 
$node_(78) set Y_ 64 
$node_(78) set Z_ 0.0 
$ns at 0.0 "$node_(78) off" 
$ns at 330.0 "$node_(78) on" 
$node_(79) set X_ 457 
$node_(79) set Y_ 374 
$node_(79) set Z_ 0.0 
$ns at 0.0 "$node_(79) off" 
$ns at 330.0 "$node_(79) on" 
$node_(80) set X_ 964 
$node_(80) set Y_ 797 
$node_(80) set Z_ 0.0 
$ns at 0.0 "$node_(80) off" 
$ns at 330.0 "$node_(80) on" 
$node_(81) set X_ 1310 
$node_(81) set Y_ 280 
$node_(81) set Z_ 0.0 
$ns at 0.0 "$node_(81) off" 
$ns at 330.0 "$node_(81) on" 
$node_(82) set X_ 1781 
$node_(82) set Y_ 326 
$node_(82) set Z_ 0.0 
$ns at 0.0 "$node_(82) off" 
$ns at 330.0 "$node_(82) on" 
$node_(83) set X_ 2218 
$node_(83) set Y_ 861 
$node_(83) set Z_ 0.0 
$ns at 0.0 "$node_(83) off" 
$ns at 330.0 "$node_(83) on" 
$node_(84) set X_ 142 
$node_(84) set Y_ 213 
$node_(84) set Z_ 0.0 
$ns at 0.0 "$node_(84) off" 
$ns at 330.0 "$node_(84) on" 
$node_(85) set X_ 689 
$node_(85) set Y_ 304 
$node_(85) set Z_ 0.0 
$ns at 0.0 "$node_(85) off" 
$ns at 330.0 "$node_(85) on" 
$node_(86) set X_ 889 
$node_(86) set Y_ 963 
$node_(86) set Z_ 0.0 
$ns at 0.0 "$node_(86) off" 
$ns at 330.0 "$node_(86) on" 
$node_(87) set X_ 2529 
$node_(87) set Y_ 482 
$node_(87) set Z_ 0.0 
$ns at 0.0 "$node_(87) off" 
$ns at 330.0 "$node_(87) on" 
$node_(88) set X_ 876 
$node_(88) set Y_ 842 
$node_(88) set Z_ 0.0 
$ns at 0.0 "$node_(88) off" 
$ns at 330.0 "$node_(88) on" 
$node_(89) set X_ 2363 
$node_(89) set Y_ 677 
$node_(89) set Z_ 0.0 
$ns at 0.0 "$node_(89) off" 
$ns at 330.0 "$node_(89) on" 
$node_(90) set X_ 1827 
$node_(90) set Y_ 711 
$node_(90) set Z_ 0.0 
$ns at 0.0 "$node_(90) off" 
$ns at 330.0 "$node_(90) on" 
$node_(91) set X_ 841 
$node_(91) set Y_ 634 
$node_(91) set Z_ 0.0 
$ns at 0.0 "$node_(91) off" 
$ns at 330.0 "$node_(91) on" 
$node_(92) set X_ 2201 
$node_(92) set Y_ 795 
$node_(92) set Z_ 0.0 
$ns at 0.0 "$node_(92) off" 
$ns at 330.0 "$node_(92) on" 
$node_(93) set X_ 714 
$node_(93) set Y_ 743 
$node_(93) set Z_ 0.0 
$ns at 0.0 "$node_(93) off" 
$ns at 330.0 "$node_(93) on" 
$node_(94) set X_ 2273 
$node_(94) set Y_ 891 
$node_(94) set Z_ 0.0 
$ns at 0.0 "$node_(94) off" 
$ns at 330.0 "$node_(94) on" 
$node_(95) set X_ 1347 
$node_(95) set Y_ 992 
$node_(95) set Z_ 0.0 
$ns at 0.0 "$node_(95) off" 
$ns at 330.0 "$node_(95) on" 
$node_(96) set X_ 452 
$node_(96) set Y_ 942 
$node_(96) set Z_ 0.0 
$ns at 0.0 "$node_(96) off" 
$ns at 330.0 "$node_(96) on" 
$node_(97) set X_ 2047 
$node_(97) set Y_ 627 
$node_(97) set Z_ 0.0 
$ns at 0.0 "$node_(97) off" 
$ns at 330.0 "$node_(97) on" 
$node_(98) set X_ 502 
$node_(98) set Y_ 239 
$node_(98) set Z_ 0.0 
$ns at 0.0 "$node_(98) off" 
$ns at 330.0 "$node_(98) on" 
$node_(99) set X_ 973 
$node_(99) set Y_ 124 
$node_(99) set Z_ 0.0 
$ns at 0.0 "$node_(99) off" 
$ns at 330.0 "$node_(99) on" 
$node_(100) set X_ 70 
$node_(100) set Y_ 806 
$node_(100) set Z_ 0.0 
$ns at 0.0 "$node_(100) off" 
$ns at 495.0 "$node_(100) on" 
$node_(101) set X_ 1106 
$node_(101) set Y_ 149 
$node_(101) set Z_ 0.0 
$ns at 0.0 "$node_(101) off" 
$ns at 495.0 "$node_(101) on" 
$node_(102) set X_ 521 
$node_(102) set Y_ 639 
$node_(102) set Z_ 0.0 
$ns at 0.0 "$node_(102) off" 
$ns at 495.0 "$node_(102) on" 
$node_(103) set X_ 80 
$node_(103) set Y_ 697 
$node_(103) set Z_ 0.0 
$ns at 0.0 "$node_(103) off" 
$ns at 495.0 "$node_(103) on" 
$node_(104) set X_ 2731 
$node_(104) set Y_ 575 
$node_(104) set Z_ 0.0 
$ns at 0.0 "$node_(104) off" 
$ns at 495.0 "$node_(104) on" 
$node_(105) set X_ 2355 
$node_(105) set Y_ 463 
$node_(105) set Z_ 0.0 
$ns at 0.0 "$node_(105) off" 
$ns at 495.0 "$node_(105) on" 
$node_(106) set X_ 60 
$node_(106) set Y_ 511 
$node_(106) set Z_ 0.0 
$ns at 0.0 "$node_(106) off" 
$ns at 495.0 "$node_(106) on" 
$node_(107) set X_ 1435 
$node_(107) set Y_ 838 
$node_(107) set Z_ 0.0 
$ns at 0.0 "$node_(107) off" 
$ns at 495.0 "$node_(107) on" 
$node_(108) set X_ 1283 
$node_(108) set Y_ 602 
$node_(108) set Z_ 0.0 
$ns at 0.0 "$node_(108) off" 
$ns at 495.0 "$node_(108) on" 
$node_(109) set X_ 2477 
$node_(109) set Y_ 591 
$node_(109) set Z_ 0.0 
$ns at 0.0 "$node_(109) off" 
$ns at 495.0 "$node_(109) on" 
$node_(110) set X_ 1775 
$node_(110) set Y_ 824 
$node_(110) set Z_ 0.0 
$ns at 0.0 "$node_(110) off" 
$ns at 495.0 "$node_(110) on" 
$node_(111) set X_ 2781 
$node_(111) set Y_ 449 
$node_(111) set Z_ 0.0 
$ns at 0.0 "$node_(111) off" 
$ns at 495.0 "$node_(111) on" 
$node_(112) set X_ 2748 
$node_(112) set Y_ 1000 
$node_(112) set Z_ 0.0 
$ns at 0.0 "$node_(112) off" 
$ns at 495.0 "$node_(112) on" 
$node_(113) set X_ 1260 
$node_(113) set Y_ 277 
$node_(113) set Z_ 0.0 
$ns at 0.0 "$node_(113) off" 
$ns at 495.0 "$node_(113) on" 
$node_(114) set X_ 1789 
$node_(114) set Y_ 985 
$node_(114) set Z_ 0.0 
$ns at 0.0 "$node_(114) off" 
$ns at 495.0 "$node_(114) on" 
$node_(115) set X_ 1029 
$node_(115) set Y_ 517 
$node_(115) set Z_ 0.0 
$ns at 0.0 "$node_(115) off" 
$ns at 495.0 "$node_(115) on" 
$node_(116) set X_ 375 
$node_(116) set Y_ 194 
$node_(116) set Z_ 0.0 
$ns at 0.0 "$node_(116) off" 
$ns at 495.0 "$node_(116) on" 
$node_(117) set X_ 820 
$node_(117) set Y_ 838 
$node_(117) set Z_ 0.0 
$ns at 0.0 "$node_(117) off" 
$ns at 495.0 "$node_(117) on" 
$node_(118) set X_ 449 
$node_(118) set Y_ 91 
$node_(118) set Z_ 0.0 
$ns at 0.0 "$node_(118) off" 
$ns at 495.0 "$node_(118) on" 
$node_(119) set X_ 2923 
$node_(119) set Y_ 736 
$node_(119) set Z_ 0.0 
$ns at 0.0 "$node_(119) off" 
$ns at 495.0 "$node_(119) on" 
$node_(120) set X_ 1495 
$node_(120) set Y_ 555 
$node_(120) set Z_ 0.0 
$ns at 0.0 "$node_(120) off" 
$ns at 495.0 "$node_(120) on" 
$node_(121) set X_ 1826 
$node_(121) set Y_ 931 
$node_(121) set Z_ 0.0 
$ns at 0.0 "$node_(121) off" 
$ns at 495.0 "$node_(121) on" 
$node_(122) set X_ 2899 
$node_(122) set Y_ 277 
$node_(122) set Z_ 0.0 
$ns at 0.0 "$node_(122) off" 
$ns at 495.0 "$node_(122) on" 
$node_(123) set X_ 1691 
$node_(123) set Y_ 973 
$node_(123) set Z_ 0.0 
$ns at 0.0 "$node_(123) off" 
$ns at 495.0 "$node_(123) on" 
$node_(124) set X_ 2670 
$node_(124) set Y_ 462 
$node_(124) set Z_ 0.0 
$ns at 0.0 "$node_(124) off" 
$ns at 495.0 "$node_(124) on" 
$node_(125) set X_ 173 
$node_(125) set Y_ 431 
$node_(125) set Z_ 0.0 
$ns at 0.0 "$node_(125) off" 
$ns at 660.0 "$node_(125) on" 
$node_(126) set X_ 1875 
$node_(126) set Y_ 151 
$node_(126) set Z_ 0.0 
$ns at 0.0 "$node_(126) off" 
$ns at 660.0 "$node_(126) on" 
$node_(127) set X_ 33 
$node_(127) set Y_ 399 
$node_(127) set Z_ 0.0 
$ns at 0.0 "$node_(127) off" 
$ns at 660.0 "$node_(127) on" 
$node_(128) set X_ 2395 
$node_(128) set Y_ 419 
$node_(128) set Z_ 0.0 
$ns at 0.0 "$node_(128) off" 
$ns at 660.0 "$node_(128) on" 
$node_(129) set X_ 284 
$node_(129) set Y_ 820 
$node_(129) set Z_ 0.0 
$ns at 0.0 "$node_(129) off" 
$ns at 660.0 "$node_(129) on" 
$node_(130) set X_ 1802 
$node_(130) set Y_ 555 
$node_(130) set Z_ 0.0 
$ns at 0.0 "$node_(130) off" 
$ns at 660.0 "$node_(130) on" 
$node_(131) set X_ 1475 
$node_(131) set Y_ 316 
$node_(131) set Z_ 0.0 
$ns at 0.0 "$node_(131) off" 
$ns at 660.0 "$node_(131) on" 
$node_(132) set X_ 1330 
$node_(132) set Y_ 83 
$node_(132) set Z_ 0.0 
$ns at 0.0 "$node_(132) off" 
$ns at 660.0 "$node_(132) on" 
$node_(133) set X_ 1977 
$node_(133) set Y_ 781 
$node_(133) set Z_ 0.0 
$ns at 0.0 "$node_(133) off" 
$ns at 660.0 "$node_(133) on" 
$node_(134) set X_ 101 
$node_(134) set Y_ 143 
$node_(134) set Z_ 0.0 
$ns at 0.0 "$node_(134) off" 
$ns at 660.0 "$node_(134) on" 
$node_(135) set X_ 911 
$node_(135) set Y_ 997 
$node_(135) set Z_ 0.0 
$ns at 0.0 "$node_(135) off" 
$ns at 660.0 "$node_(135) on" 
$node_(136) set X_ 820 
$node_(136) set Y_ 322 
$node_(136) set Z_ 0.0 
$ns at 0.0 "$node_(136) off" 
$ns at 660.0 "$node_(136) on" 
$node_(137) set X_ 2569 
$node_(137) set Y_ 918 
$node_(137) set Z_ 0.0 
$ns at 0.0 "$node_(137) off" 
$ns at 660.0 "$node_(137) on" 
$node_(138) set X_ 1302 
$node_(138) set Y_ 503 
$node_(138) set Z_ 0.0 
$ns at 0.0 "$node_(138) off" 
$ns at 660.0 "$node_(138) on" 
$node_(139) set X_ 2887 
$node_(139) set Y_ 79 
$node_(139) set Z_ 0.0 
$ns at 0.0 "$node_(139) off" 
$ns at 660.0 "$node_(139) on" 
$node_(140) set X_ 2199 
$node_(140) set Y_ 658 
$node_(140) set Z_ 0.0 
$ns at 0.0 "$node_(140) off" 
$ns at 660.0 "$node_(140) on" 
$node_(141) set X_ 2670 
$node_(141) set Y_ 777 
$node_(141) set Z_ 0.0 
$ns at 0.0 "$node_(141) off" 
$ns at 660.0 "$node_(141) on" 
$node_(142) set X_ 2345 
$node_(142) set Y_ 831 
$node_(142) set Z_ 0.0 
$ns at 0.0 "$node_(142) off" 
$ns at 660.0 "$node_(142) on" 
$node_(143) set X_ 940 
$node_(143) set Y_ 316 
$node_(143) set Z_ 0.0 
$ns at 0.0 "$node_(143) off" 
$ns at 660.0 "$node_(143) on" 
$node_(144) set X_ 1120 
$node_(144) set Y_ 718 
$node_(144) set Z_ 0.0 
$ns at 0.0 "$node_(144) off" 
$ns at 660.0 "$node_(144) on" 
$node_(145) set X_ 1829 
$node_(145) set Y_ 590 
$node_(145) set Z_ 0.0 
$ns at 0.0 "$node_(145) off" 
$ns at 660.0 "$node_(145) on" 
$node_(146) set X_ 2188 
$node_(146) set Y_ 372 
$node_(146) set Z_ 0.0 
$ns at 0.0 "$node_(146) off" 
$ns at 660.0 "$node_(146) on" 
$node_(147) set X_ 2047 
$node_(147) set Y_ 739 
$node_(147) set Z_ 0.0 
$ns at 0.0 "$node_(147) off" 
$ns at 660.0 "$node_(147) on" 
$node_(148) set X_ 1909 
$node_(148) set Y_ 550 
$node_(148) set Z_ 0.0 
$ns at 0.0 "$node_(148) off" 
$ns at 660.0 "$node_(148) on" 
$node_(149) set X_ 984 
$node_(149) set Y_ 425 
$node_(149) set Z_ 0.0 
$ns at 0.0 "$node_(149) off" 
$ns at 660.0 "$node_(149) on" 

# Generation of movements
$ns at 0.0 "$node_(0) setdest 2596 137 7.0" 
$ns at 66.62276073138679 "$node_(0) setdest 2691 914 16.0" 
$ns at 203.05283514904966 "$node_(0) setdest 724 618 15.0" 
$ns at 251.62820262279945 "$node_(0) setdest 1775 928 10.0" 
$ns at 380.7998139444525 "$node_(0) setdest 1874 501 9.0" 
$ns at 452.3383372797581 "$node_(0) setdest 1565 654 11.0" 
$ns at 514.5922459154374 "$node_(0) setdest 543 611 14.0" 
$ns at 576.3719106928992 "$node_(0) setdest 1960 520 4.0" 
$ns at 613.784899446319 "$node_(0) setdest 1634 574 10.0" 
$ns at 703.3225582556059 "$node_(0) setdest 29 662 5.0" 
$ns at 736.3084468979494 "$node_(0) setdest 1447 938 17.0" 
$ns at 0.0 "$node_(1) setdest 1420 571 18.0" 
$ns at 181.35555385960228 "$node_(1) setdest 1831 744 4.0" 
$ns at 215.18314593307474 "$node_(1) setdest 1773 642 15.0" 
$ns at 376.5649909461917 "$node_(1) setdest 2606 777 1.0" 
$ns at 416.29202308584337 "$node_(1) setdest 2126 505 15.0" 
$ns at 541.2844026796424 "$node_(1) setdest 2133 995 4.0" 
$ns at 594.1546871070105 "$node_(1) setdest 57 233 12.0" 
$ns at 640.5273784485305 "$node_(1) setdest 657 864 13.0" 
$ns at 696.6849976906769 "$node_(1) setdest 1064 804 19.0" 
$ns at 785.1016870280833 "$node_(1) setdest 1782 596 14.0" 
$ns at 0.0 "$node_(2) setdest 2420 424 17.0" 
$ns at 140.0456852958343 "$node_(2) setdest 2213 530 4.0" 
$ns at 197.8977821551558 "$node_(2) setdest 1513 579 4.0" 
$ns at 265.02172968465345 "$node_(2) setdest 2620 124 12.0" 
$ns at 412.5647005537637 "$node_(2) setdest 402 923 8.0" 
$ns at 508.3918226660381 "$node_(2) setdest 1267 332 16.0" 
$ns at 567.5457830321136 "$node_(2) setdest 97 367 11.0" 
$ns at 668.957745986431 "$node_(2) setdest 1753 316 3.0" 
$ns at 726.7623201767952 "$node_(2) setdest 2801 987 11.0" 
$ns at 828.5195905925241 "$node_(2) setdest 1003 758 17.0" 
$ns at 0.0 "$node_(3) setdest 2116 613 17.0" 
$ns at 115.50941882731763 "$node_(3) setdest 2375 254 16.0" 
$ns at 282.3865360474432 "$node_(3) setdest 1955 203 15.0" 
$ns at 452.8614511189777 "$node_(3) setdest 503 516 1.0" 
$ns at 483.41112306894183 "$node_(3) setdest 658 380 19.0" 
$ns at 648.0216581637754 "$node_(3) setdest 2245 389 12.0" 
$ns at 689.4346004395444 "$node_(3) setdest 556 734 12.0" 
$ns at 754.6028037335261 "$node_(3) setdest 1866 907 13.0" 
$ns at 787.7324493157022 "$node_(3) setdest 1984 753 14.0" 
$ns at 0.0 "$node_(4) setdest 313 884 10.0" 
$ns at 63.68532334538542 "$node_(4) setdest 1483 512 3.0" 
$ns at 106.65033965535474 "$node_(4) setdest 221 775 13.0" 
$ns at 262.8292809988335 "$node_(4) setdest 2689 453 8.0" 
$ns at 330.5824108727587 "$node_(4) setdest 2001 799 1.0" 
$ns at 369.3475028445246 "$node_(4) setdest 1165 900 8.0" 
$ns at 415.4372615230005 "$node_(4) setdest 147 550 4.0" 
$ns at 454.19072722462215 "$node_(4) setdest 1147 157 17.0" 
$ns at 560.9545165917308 "$node_(4) setdest 630 606 13.0" 
$ns at 656.2281775145449 "$node_(4) setdest 2981 300 17.0" 
$ns at 839.0283697356966 "$node_(4) setdest 2992 855 18.0" 
$ns at 0.0 "$node_(5) setdest 2724 33 8.0" 
$ns at 100.39641873219557 "$node_(5) setdest 2515 534 14.0" 
$ns at 204.04250985242336 "$node_(5) setdest 1170 224 15.0" 
$ns at 287.98641696658524 "$node_(5) setdest 2597 217 19.0" 
$ns at 485.0559153072651 "$node_(5) setdest 2281 971 5.0" 
$ns at 551.1052657648767 "$node_(5) setdest 1189 247 3.0" 
$ns at 594.9582659836717 "$node_(5) setdest 2786 323 1.0" 
$ns at 628.0258637792848 "$node_(5) setdest 2923 339 18.0" 
$ns at 734.0185340955363 "$node_(5) setdest 2438 23 9.0" 
$ns at 843.7970906438551 "$node_(5) setdest 1303 353 14.0" 
$ns at 0.0 "$node_(6) setdest 2166 867 18.0" 
$ns at 115.55359668250252 "$node_(6) setdest 2077 469 16.0" 
$ns at 272.8149889160023 "$node_(6) setdest 133 562 4.0" 
$ns at 310.06302410291215 "$node_(6) setdest 661 250 10.0" 
$ns at 409.9880211836416 "$node_(6) setdest 2434 188 8.0" 
$ns at 440.358946978027 "$node_(6) setdest 1241 345 10.0" 
$ns at 531.1045255573649 "$node_(6) setdest 2942 628 15.0" 
$ns at 676.3222587393599 "$node_(6) setdest 915 797 17.0" 
$ns at 731.2316957404729 "$node_(6) setdest 1531 578 11.0" 
$ns at 827.2883999009769 "$node_(6) setdest 1008 221 12.0" 
$ns at 881.9770595193985 "$node_(6) setdest 1690 1 14.0" 
$ns at 0.0 "$node_(7) setdest 414 319 17.0" 
$ns at 142.48392897126624 "$node_(7) setdest 1267 144 4.0" 
$ns at 211.14654372511782 "$node_(7) setdest 1613 480 11.0" 
$ns at 317.1494913661402 "$node_(7) setdest 2830 467 16.0" 
$ns at 456.6432024385049 "$node_(7) setdest 699 451 12.0" 
$ns at 543.2723721109403 "$node_(7) setdest 1909 117 13.0" 
$ns at 573.9729540583958 "$node_(7) setdest 2574 321 5.0" 
$ns at 620.2829563022074 "$node_(7) setdest 2102 795 9.0" 
$ns at 702.9268360680521 "$node_(7) setdest 1155 301 19.0" 
$ns at 847.053341483958 "$node_(7) setdest 1790 128 4.0" 
$ns at 888.620265015742 "$node_(7) setdest 228 38 14.0" 
$ns at 0.0 "$node_(8) setdest 2973 927 6.0" 
$ns at 59.18931397417419 "$node_(8) setdest 1315 459 14.0" 
$ns at 97.02059298217759 "$node_(8) setdest 447 924 18.0" 
$ns at 180.99002632791417 "$node_(8) setdest 2675 372 12.0" 
$ns at 226.35482307344267 "$node_(8) setdest 349 864 13.0" 
$ns at 320.85526449790314 "$node_(8) setdest 315 326 20.0" 
$ns at 483.49912853037614 "$node_(8) setdest 786 59 1.0" 
$ns at 522.8858650843872 "$node_(8) setdest 622 450 14.0" 
$ns at 670.2622929048844 "$node_(8) setdest 67 771 6.0" 
$ns at 746.921387265464 "$node_(8) setdest 1002 284 9.0" 
$ns at 780.7866016095303 "$node_(8) setdest 2775 32 18.0" 
$ns at 0.0 "$node_(9) setdest 629 807 20.0" 
$ns at 103.26056287812177 "$node_(9) setdest 666 777 14.0" 
$ns at 224.64104483036203 "$node_(9) setdest 2193 193 18.0" 
$ns at 296.48693685467674 "$node_(9) setdest 2165 383 19.0" 
$ns at 468.5951997414335 "$node_(9) setdest 2257 986 17.0" 
$ns at 623.0451484754773 "$node_(9) setdest 1929 994 17.0" 
$ns at 690.808400071217 "$node_(9) setdest 1591 722 15.0" 
$ns at 788.698144503051 "$node_(9) setdest 1739 245 4.0" 
$ns at 825.8378355013479 "$node_(9) setdest 1622 219 18.0" 
$ns at 0.0 "$node_(10) setdest 2711 232 6.0" 
$ns at 30.375483993479968 "$node_(10) setdest 1845 12 16.0" 
$ns at 143.34672443093012 "$node_(10) setdest 581 862 12.0" 
$ns at 252.9745832007404 "$node_(10) setdest 1845 700 1.0" 
$ns at 290.37355634988774 "$node_(10) setdest 1539 930 6.0" 
$ns at 326.6773915988555 "$node_(10) setdest 272 168 1.0" 
$ns at 360.6343696510121 "$node_(10) setdest 1887 549 1.0" 
$ns at 393.4361523904587 "$node_(10) setdest 1913 929 17.0" 
$ns at 425.3152245320559 "$node_(10) setdest 1489 787 12.0" 
$ns at 500.6471043664757 "$node_(10) setdest 2722 87 10.0" 
$ns at 570.5905199589332 "$node_(10) setdest 1785 624 4.0" 
$ns at 610.3086039541142 "$node_(10) setdest 1429 640 7.0" 
$ns at 668.5479168132218 "$node_(10) setdest 2842 606 11.0" 
$ns at 714.1602923949026 "$node_(10) setdest 104 120 12.0" 
$ns at 808.9622053957933 "$node_(10) setdest 2701 786 19.0" 
$ns at 896.0576731767525 "$node_(10) setdest 1784 817 8.0" 
$ns at 0.0 "$node_(11) setdest 18 840 1.0" 
$ns at 38.92141057358871 "$node_(11) setdest 2058 56 17.0" 
$ns at 155.89842683576262 "$node_(11) setdest 1736 455 14.0" 
$ns at 242.08922343552285 "$node_(11) setdest 2207 287 16.0" 
$ns at 430.6115890987823 "$node_(11) setdest 2288 351 3.0" 
$ns at 476.7570808404042 "$node_(11) setdest 283 951 9.0" 
$ns at 581.1068418821976 "$node_(11) setdest 582 569 11.0" 
$ns at 625.3452502226613 "$node_(11) setdest 1243 394 14.0" 
$ns at 767.6822672574635 "$node_(11) setdest 1756 866 14.0" 
$ns at 890.4698193515057 "$node_(11) setdest 1015 279 11.0" 
$ns at 0.0 "$node_(12) setdest 2458 339 14.0" 
$ns at 87.2601371252754 "$node_(12) setdest 2111 262 7.0" 
$ns at 127.76295665990763 "$node_(12) setdest 1132 651 11.0" 
$ns at 190.62936621373296 "$node_(12) setdest 2159 918 17.0" 
$ns at 294.2625906517749 "$node_(12) setdest 578 455 5.0" 
$ns at 373.22209414301506 "$node_(12) setdest 2478 130 2.0" 
$ns at 412.4795375642196 "$node_(12) setdest 766 890 18.0" 
$ns at 573.1748131590914 "$node_(12) setdest 570 472 19.0" 
$ns at 615.3926071731826 "$node_(12) setdest 1648 259 2.0" 
$ns at 648.1541810385745 "$node_(12) setdest 133 277 3.0" 
$ns at 702.5331802575303 "$node_(12) setdest 477 258 20.0" 
$ns at 890.0915015741818 "$node_(12) setdest 993 421 8.0" 
$ns at 0.0 "$node_(13) setdest 1877 362 6.0" 
$ns at 45.374719959394184 "$node_(13) setdest 1056 26 1.0" 
$ns at 81.72636355453339 "$node_(13) setdest 2642 225 2.0" 
$ns at 116.2494180480683 "$node_(13) setdest 1151 601 7.0" 
$ns at 208.43830812099122 "$node_(13) setdest 1036 234 6.0" 
$ns at 272.03154155056836 "$node_(13) setdest 1402 330 5.0" 
$ns at 319.3583187562448 "$node_(13) setdest 74 543 7.0" 
$ns at 387.01229099483464 "$node_(13) setdest 2481 522 12.0" 
$ns at 424.76361379274226 "$node_(13) setdest 2029 236 15.0" 
$ns at 557.2830767211433 "$node_(13) setdest 1875 441 5.0" 
$ns at 604.9679442400952 "$node_(13) setdest 1175 454 13.0" 
$ns at 745.3675791289809 "$node_(13) setdest 33 15 9.0" 
$ns at 833.2152420507972 "$node_(13) setdest 495 619 10.0" 
$ns at 0.0 "$node_(14) setdest 2014 159 1.0" 
$ns at 39.59662451669977 "$node_(14) setdest 863 103 7.0" 
$ns at 91.3032459851251 "$node_(14) setdest 1011 706 5.0" 
$ns at 162.94108355419075 "$node_(14) setdest 1940 974 9.0" 
$ns at 253.433240721995 "$node_(14) setdest 2871 167 19.0" 
$ns at 409.4447942487533 "$node_(14) setdest 779 655 9.0" 
$ns at 485.19461456144296 "$node_(14) setdest 1474 834 4.0" 
$ns at 549.967091156089 "$node_(14) setdest 1894 644 8.0" 
$ns at 627.5414359162951 "$node_(14) setdest 1604 942 12.0" 
$ns at 699.9222808379957 "$node_(14) setdest 2272 621 18.0" 
$ns at 802.4759067503604 "$node_(14) setdest 682 889 5.0" 
$ns at 837.0239617822671 "$node_(14) setdest 2597 589 4.0" 
$ns at 0.0 "$node_(15) setdest 463 754 14.0" 
$ns at 155.59824125961754 "$node_(15) setdest 658 889 1.0" 
$ns at 188.3764279428891 "$node_(15) setdest 603 590 6.0" 
$ns at 258.1942539335761 "$node_(15) setdest 1710 211 20.0" 
$ns at 412.0490228138893 "$node_(15) setdest 1680 244 15.0" 
$ns at 535.7680437102259 "$node_(15) setdest 262 967 17.0" 
$ns at 601.9728387301014 "$node_(15) setdest 1066 687 19.0" 
$ns at 717.2260035053582 "$node_(15) setdest 2556 632 3.0" 
$ns at 759.3341211660486 "$node_(15) setdest 1763 85 6.0" 
$ns at 801.6826384865658 "$node_(15) setdest 729 926 2.0" 
$ns at 843.2416598592519 "$node_(15) setdest 1066 109 3.0" 
$ns at 888.7100182799538 "$node_(15) setdest 2387 936 14.0" 
$ns at 0.0 "$node_(16) setdest 1692 223 12.0" 
$ns at 80.6556864470895 "$node_(16) setdest 1122 559 18.0" 
$ns at 118.36477168407151 "$node_(16) setdest 1726 926 3.0" 
$ns at 172.3346774363667 "$node_(16) setdest 2176 860 17.0" 
$ns at 246.49900560129936 "$node_(16) setdest 1520 202 14.0" 
$ns at 323.3885259843389 "$node_(16) setdest 2290 233 14.0" 
$ns at 438.71365817983053 "$node_(16) setdest 408 656 8.0" 
$ns at 500.741547038793 "$node_(16) setdest 443 447 17.0" 
$ns at 551.3939643671341 "$node_(16) setdest 1867 74 10.0" 
$ns at 615.9939126660242 "$node_(16) setdest 17 967 15.0" 
$ns at 670.3262693474638 "$node_(16) setdest 1478 402 16.0" 
$ns at 705.8010838769208 "$node_(16) setdest 2600 154 19.0" 
$ns at 811.4875984184921 "$node_(16) setdest 1829 381 14.0" 
$ns at 0.0 "$node_(17) setdest 446 199 5.0" 
$ns at 31.907191354035636 "$node_(17) setdest 218 316 12.0" 
$ns at 76.18003523557827 "$node_(17) setdest 2329 920 20.0" 
$ns at 161.39712475533088 "$node_(17) setdest 780 733 15.0" 
$ns at 281.9580120037451 "$node_(17) setdest 2283 771 12.0" 
$ns at 325.9711600646907 "$node_(17) setdest 1404 900 1.0" 
$ns at 356.0901557632498 "$node_(17) setdest 2487 688 11.0" 
$ns at 386.5085059819853 "$node_(17) setdest 2579 455 8.0" 
$ns at 451.19293536021576 "$node_(17) setdest 1275 620 11.0" 
$ns at 583.4253641221154 "$node_(17) setdest 2017 635 7.0" 
$ns at 675.6774371575165 "$node_(17) setdest 2035 882 2.0" 
$ns at 724.6889903016167 "$node_(17) setdest 2684 827 5.0" 
$ns at 800.3157524140511 "$node_(17) setdest 471 667 14.0" 
$ns at 870.6085493205803 "$node_(17) setdest 2622 450 18.0" 
$ns at 0.0 "$node_(18) setdest 1499 349 13.0" 
$ns at 86.09830560750927 "$node_(18) setdest 1658 394 3.0" 
$ns at 127.37139191994527 "$node_(18) setdest 752 429 4.0" 
$ns at 194.68244632523846 "$node_(18) setdest 895 508 3.0" 
$ns at 230.29394998472645 "$node_(18) setdest 1453 248 9.0" 
$ns at 332.6014808623189 "$node_(18) setdest 1589 872 13.0" 
$ns at 447.4575137395784 "$node_(18) setdest 147 821 9.0" 
$ns at 540.6214653078896 "$node_(18) setdest 1796 844 19.0" 
$ns at 759.7769511808569 "$node_(18) setdest 1535 406 1.0" 
$ns at 793.0751467676882 "$node_(18) setdest 1902 124 15.0" 
$ns at 881.6446814299403 "$node_(18) setdest 418 679 18.0" 
$ns at 0.0 "$node_(19) setdest 906 315 4.0" 
$ns at 63.4476045422327 "$node_(19) setdest 1483 620 4.0" 
$ns at 106.07844543276519 "$node_(19) setdest 2084 726 6.0" 
$ns at 152.34968179327487 "$node_(19) setdest 1433 479 8.0" 
$ns at 189.56038459655386 "$node_(19) setdest 2403 399 16.0" 
$ns at 337.13232820769946 "$node_(19) setdest 2709 428 19.0" 
$ns at 369.40955810499446 "$node_(19) setdest 800 608 13.0" 
$ns at 480.6060443352449 "$node_(19) setdest 2802 773 7.0" 
$ns at 556.2950631286703 "$node_(19) setdest 1204 311 17.0" 
$ns at 645.8069245454869 "$node_(19) setdest 2889 828 15.0" 
$ns at 794.095342940589 "$node_(19) setdest 1920 287 8.0" 
$ns at 898.8573606080047 "$node_(19) setdest 2306 822 16.0" 
$ns at 0.0 "$node_(20) setdest 2747 965 16.0" 
$ns at 88.36602637800353 "$node_(20) setdest 89 454 15.0" 
$ns at 130.1245687810347 "$node_(20) setdest 1944 168 18.0" 
$ns at 293.3806672396168 "$node_(20) setdest 1591 946 10.0" 
$ns at 398.4276683789372 "$node_(20) setdest 933 259 17.0" 
$ns at 517.1902725760499 "$node_(20) setdest 1912 722 15.0" 
$ns at 635.6414700919688 "$node_(20) setdest 2332 443 19.0" 
$ns at 747.8209970651736 "$node_(20) setdest 2645 72 5.0" 
$ns at 795.13433667533 "$node_(20) setdest 2721 194 7.0" 
$ns at 881.5631134769276 "$node_(20) setdest 2177 411 1.0" 
$ns at 0.0 "$node_(21) setdest 233 59 15.0" 
$ns at 96.50075111652927 "$node_(21) setdest 2551 996 12.0" 
$ns at 227.54099675069284 "$node_(21) setdest 1868 325 5.0" 
$ns at 270.8786616594581 "$node_(21) setdest 1624 222 6.0" 
$ns at 339.9237696522199 "$node_(21) setdest 1120 275 10.0" 
$ns at 403.0639361227154 "$node_(21) setdest 22 849 10.0" 
$ns at 456.74392159498285 "$node_(21) setdest 2327 47 1.0" 
$ns at 496.64001054944913 "$node_(21) setdest 2144 782 10.0" 
$ns at 594.9545083579774 "$node_(21) setdest 824 299 1.0" 
$ns at 627.5668158381835 "$node_(21) setdest 201 267 16.0" 
$ns at 660.1859006018129 "$node_(21) setdest 2801 208 2.0" 
$ns at 704.3869878172845 "$node_(21) setdest 40 608 2.0" 
$ns at 738.6777749636299 "$node_(21) setdest 1474 506 20.0" 
$ns at 844.1067571335285 "$node_(21) setdest 1254 776 17.0" 
$ns at 876.8597277954156 "$node_(21) setdest 938 560 5.0" 
$ns at 0.0 "$node_(22) setdest 813 528 3.0" 
$ns at 58.68597703688103 "$node_(22) setdest 2834 739 8.0" 
$ns at 134.42429513587842 "$node_(22) setdest 228 877 1.0" 
$ns at 167.46682550160529 "$node_(22) setdest 688 535 19.0" 
$ns at 298.3055550673188 "$node_(22) setdest 2975 62 5.0" 
$ns at 369.89651568542934 "$node_(22) setdest 551 197 10.0" 
$ns at 414.77928322710204 "$node_(22) setdest 1694 340 9.0" 
$ns at 497.2738961994317 "$node_(22) setdest 310 858 2.0" 
$ns at 545.3032724381607 "$node_(22) setdest 392 254 2.0" 
$ns at 576.8441109096467 "$node_(22) setdest 1793 392 20.0" 
$ns at 783.0583536542679 "$node_(22) setdest 663 205 3.0" 
$ns at 831.4337551787011 "$node_(22) setdest 1530 491 20.0" 
$ns at 0.0 "$node_(23) setdest 1652 466 20.0" 
$ns at 151.70142321884632 "$node_(23) setdest 2804 703 13.0" 
$ns at 306.7526186875437 "$node_(23) setdest 1280 992 19.0" 
$ns at 365.0772043453919 "$node_(23) setdest 2352 412 12.0" 
$ns at 423.1835475451509 "$node_(23) setdest 1959 629 10.0" 
$ns at 469.4267520824593 "$node_(23) setdest 1846 4 8.0" 
$ns at 527.6118740551569 "$node_(23) setdest 799 615 17.0" 
$ns at 712.1009807398804 "$node_(23) setdest 2019 715 2.0" 
$ns at 753.6360875159382 "$node_(23) setdest 2059 446 17.0" 
$ns at 0.0 "$node_(24) setdest 1058 873 7.0" 
$ns at 31.51687174945061 "$node_(24) setdest 329 507 10.0" 
$ns at 66.1595038953158 "$node_(24) setdest 1634 558 11.0" 
$ns at 118.10508874412801 "$node_(24) setdest 691 58 20.0" 
$ns at 267.8286780862724 "$node_(24) setdest 1704 886 16.0" 
$ns at 391.2131047473001 "$node_(24) setdest 1864 446 13.0" 
$ns at 506.4826687898755 "$node_(24) setdest 1924 429 10.0" 
$ns at 585.4553875087827 "$node_(24) setdest 1062 662 3.0" 
$ns at 617.6112185914045 "$node_(24) setdest 336 494 2.0" 
$ns at 664.1372061543135 "$node_(24) setdest 2084 593 17.0" 
$ns at 828.3520680067938 "$node_(24) setdest 2660 256 14.0" 
$ns at 0.0 "$node_(25) setdest 2855 593 15.0" 
$ns at 92.01112500848896 "$node_(25) setdest 2347 981 6.0" 
$ns at 160.21561150942475 "$node_(25) setdest 2440 235 11.0" 
$ns at 244.8649693387182 "$node_(25) setdest 2233 834 4.0" 
$ns at 298.34334128649175 "$node_(25) setdest 2259 354 8.0" 
$ns at 365.9161752848718 "$node_(25) setdest 438 999 10.0" 
$ns at 477.9612279505447 "$node_(25) setdest 1009 740 18.0" 
$ns at 576.972729799295 "$node_(25) setdest 1875 104 4.0" 
$ns at 645.2445016102032 "$node_(25) setdest 1533 110 18.0" 
$ns at 836.9274361031198 "$node_(25) setdest 477 195 11.0" 
$ns at 0.0 "$node_(26) setdest 635 206 19.0" 
$ns at 65.85594871678282 "$node_(26) setdest 1040 742 6.0" 
$ns at 106.19407012567636 "$node_(26) setdest 2589 138 4.0" 
$ns at 163.92508099501373 "$node_(26) setdest 269 411 2.0" 
$ns at 199.8939097791116 "$node_(26) setdest 1836 335 4.0" 
$ns at 265.24260848288236 "$node_(26) setdest 432 600 16.0" 
$ns at 385.9151394400005 "$node_(26) setdest 1111 726 14.0" 
$ns at 483.1500105043583 "$node_(26) setdest 720 971 15.0" 
$ns at 616.9505231107037 "$node_(26) setdest 3 996 1.0" 
$ns at 654.8298999041134 "$node_(26) setdest 2188 465 16.0" 
$ns at 748.3655751423875 "$node_(26) setdest 693 46 10.0" 
$ns at 786.4000836750826 "$node_(26) setdest 2912 547 4.0" 
$ns at 838.7040957711152 "$node_(26) setdest 361 12 2.0" 
$ns at 872.8265437595035 "$node_(26) setdest 2711 656 2.0" 
$ns at 0.0 "$node_(27) setdest 511 464 11.0" 
$ns at 122.87825279013289 "$node_(27) setdest 1575 111 16.0" 
$ns at 295.2243495282588 "$node_(27) setdest 1217 638 11.0" 
$ns at 334.50702059866137 "$node_(27) setdest 657 954 9.0" 
$ns at 396.0972204279122 "$node_(27) setdest 20 824 19.0" 
$ns at 474.74959102441755 "$node_(27) setdest 460 466 11.0" 
$ns at 537.923986300303 "$node_(27) setdest 986 261 13.0" 
$ns at 592.0923231552268 "$node_(27) setdest 576 359 7.0" 
$ns at 682.9907327517143 "$node_(27) setdest 1174 176 17.0" 
$ns at 764.8890071993644 "$node_(27) setdest 120 858 10.0" 
$ns at 805.5576519472104 "$node_(27) setdest 488 795 2.0" 
$ns at 841.2805764484999 "$node_(27) setdest 1702 186 1.0" 
$ns at 875.3086042890334 "$node_(27) setdest 685 472 5.0" 
$ns at 0.0 "$node_(28) setdest 1589 172 7.0" 
$ns at 50.55938353731865 "$node_(28) setdest 2023 287 5.0" 
$ns at 124.93865480582802 "$node_(28) setdest 397 985 2.0" 
$ns at 163.91111875339158 "$node_(28) setdest 793 711 5.0" 
$ns at 215.39703489047025 "$node_(28) setdest 463 213 10.0" 
$ns at 335.0797851024775 "$node_(28) setdest 734 236 14.0" 
$ns at 498.64452677622734 "$node_(28) setdest 1746 801 16.0" 
$ns at 655.243044037438 "$node_(28) setdest 1080 43 8.0" 
$ns at 696.7980031527744 "$node_(28) setdest 2889 561 9.0" 
$ns at 750.2196009845309 "$node_(28) setdest 2731 109 6.0" 
$ns at 790.085317268297 "$node_(28) setdest 2809 260 4.0" 
$ns at 826.022827487986 "$node_(28) setdest 2798 334 5.0" 
$ns at 0.0 "$node_(29) setdest 1945 516 16.0" 
$ns at 141.5553889809911 "$node_(29) setdest 2507 573 17.0" 
$ns at 203.20661001265123 "$node_(29) setdest 17 991 5.0" 
$ns at 256.49814391535665 "$node_(29) setdest 231 681 9.0" 
$ns at 355.6982967582717 "$node_(29) setdest 2937 622 1.0" 
$ns at 386.1358907846834 "$node_(29) setdest 2118 926 1.0" 
$ns at 420.8165631356625 "$node_(29) setdest 1229 876 8.0" 
$ns at 479.23695115993627 "$node_(29) setdest 2586 393 14.0" 
$ns at 604.1151686502182 "$node_(29) setdest 87 269 7.0" 
$ns at 676.5844248835675 "$node_(29) setdest 1657 241 2.0" 
$ns at 707.6366296029296 "$node_(29) setdest 1937 636 20.0" 
$ns at 773.1728176094672 "$node_(29) setdest 905 919 3.0" 
$ns at 810.664971133745 "$node_(29) setdest 2129 888 6.0" 
$ns at 841.0517067770611 "$node_(29) setdest 1485 715 15.0" 
$ns at 0.0 "$node_(30) setdest 2123 249 16.0" 
$ns at 73.30598108476708 "$node_(30) setdest 1509 241 20.0" 
$ns at 161.8580301123328 "$node_(30) setdest 301 213 3.0" 
$ns at 204.2820071111464 "$node_(30) setdest 2757 725 16.0" 
$ns at 279.0468834489212 "$node_(30) setdest 2267 695 18.0" 
$ns at 456.7034123584227 "$node_(30) setdest 1470 221 8.0" 
$ns at 535.1841295954158 "$node_(30) setdest 252 137 8.0" 
$ns at 619.8570965423497 "$node_(30) setdest 1719 93 4.0" 
$ns at 672.3129423912009 "$node_(30) setdest 1015 537 10.0" 
$ns at 790.0951852785981 "$node_(30) setdest 605 403 6.0" 
$ns at 853.0038265975331 "$node_(30) setdest 2335 648 17.0" 
$ns at 0.0 "$node_(31) setdest 274 50 7.0" 
$ns at 42.96285970031889 "$node_(31) setdest 1989 837 16.0" 
$ns at 76.24074373551295 "$node_(31) setdest 504 778 3.0" 
$ns at 132.54198652593612 "$node_(31) setdest 816 341 16.0" 
$ns at 272.3058884193672 "$node_(31) setdest 1344 421 7.0" 
$ns at 304.56042535962257 "$node_(31) setdest 1256 898 2.0" 
$ns at 337.70625899154834 "$node_(31) setdest 1080 996 20.0" 
$ns at 438.1310573635336 "$node_(31) setdest 477 16 18.0" 
$ns at 512.8232139377672 "$node_(31) setdest 2488 503 5.0" 
$ns at 585.918318616153 "$node_(31) setdest 1951 339 18.0" 
$ns at 792.1402592896746 "$node_(31) setdest 2151 549 12.0" 
$ns at 896.2870190420994 "$node_(31) setdest 1126 864 18.0" 
$ns at 0.0 "$node_(32) setdest 1315 161 4.0" 
$ns at 40.44791225443777 "$node_(32) setdest 540 5 11.0" 
$ns at 131.26050395173564 "$node_(32) setdest 2544 397 6.0" 
$ns at 211.97876117721486 "$node_(32) setdest 2508 721 10.0" 
$ns at 247.75113437463895 "$node_(32) setdest 2163 622 16.0" 
$ns at 375.8600724741111 "$node_(32) setdest 255 211 1.0" 
$ns at 411.4757988119963 "$node_(32) setdest 1233 560 9.0" 
$ns at 499.9511124389327 "$node_(32) setdest 1115 918 12.0" 
$ns at 609.7307495747914 "$node_(32) setdest 1562 483 2.0" 
$ns at 651.4363943631794 "$node_(32) setdest 2163 810 2.0" 
$ns at 695.181980343131 "$node_(32) setdest 1994 162 11.0" 
$ns at 810.5448118484912 "$node_(32) setdest 1405 204 1.0" 
$ns at 841.9163734504576 "$node_(32) setdest 1969 423 19.0" 
$ns at 0.0 "$node_(33) setdest 2398 597 11.0" 
$ns at 100.35097130411927 "$node_(33) setdest 2103 439 9.0" 
$ns at 135.1728781492427 "$node_(33) setdest 917 257 9.0" 
$ns at 243.91366791439305 "$node_(33) setdest 1287 120 20.0" 
$ns at 283.3427178112919 "$node_(33) setdest 42 552 1.0" 
$ns at 316.6253842021761 "$node_(33) setdest 2545 195 1.0" 
$ns at 347.8330791360395 "$node_(33) setdest 1791 270 15.0" 
$ns at 512.8866232704164 "$node_(33) setdest 1654 882 2.0" 
$ns at 562.099386176719 "$node_(33) setdest 2159 402 1.0" 
$ns at 598.9079197249313 "$node_(33) setdest 2261 221 12.0" 
$ns at 679.1953764175759 "$node_(33) setdest 2194 130 17.0" 
$ns at 783.145201236666 "$node_(33) setdest 12 475 5.0" 
$ns at 860.8857012481772 "$node_(33) setdest 479 25 13.0" 
$ns at 0.0 "$node_(34) setdest 1917 169 20.0" 
$ns at 221.3121349730006 "$node_(34) setdest 2138 665 13.0" 
$ns at 364.5472612969332 "$node_(34) setdest 960 669 16.0" 
$ns at 494.5881495041152 "$node_(34) setdest 2239 184 18.0" 
$ns at 630.9147648716541 "$node_(34) setdest 704 384 16.0" 
$ns at 715.4956266134341 "$node_(34) setdest 1215 484 13.0" 
$ns at 828.3789910989403 "$node_(34) setdest 2372 979 10.0" 
$ns at 0.0 "$node_(35) setdest 2674 89 15.0" 
$ns at 100.46083878755793 "$node_(35) setdest 2664 191 16.0" 
$ns at 223.74703573931873 "$node_(35) setdest 1720 895 12.0" 
$ns at 309.08870482428097 "$node_(35) setdest 301 127 18.0" 
$ns at 360.77003274784994 "$node_(35) setdest 2655 294 8.0" 
$ns at 454.9695797149996 "$node_(35) setdest 1041 144 11.0" 
$ns at 503.35381282974583 "$node_(35) setdest 684 407 18.0" 
$ns at 627.1694092315383 "$node_(35) setdest 2661 696 19.0" 
$ns at 804.1826232951784 "$node_(35) setdest 991 429 19.0" 
$ns at 0.0 "$node_(36) setdest 2163 725 9.0" 
$ns at 110.50748681514668 "$node_(36) setdest 2312 309 16.0" 
$ns at 300.40211433934564 "$node_(36) setdest 2179 504 12.0" 
$ns at 338.6632121530313 "$node_(36) setdest 1873 259 15.0" 
$ns at 461.4520968615563 "$node_(36) setdest 348 4 11.0" 
$ns at 600.7785498332529 "$node_(36) setdest 1314 836 16.0" 
$ns at 714.6181297540476 "$node_(36) setdest 131 178 10.0" 
$ns at 761.0087696160572 "$node_(36) setdest 2974 575 20.0" 
$ns at 884.3764456100325 "$node_(36) setdest 1341 757 8.0" 
$ns at 0.0 "$node_(37) setdest 1648 417 6.0" 
$ns at 30.539239298768926 "$node_(37) setdest 1355 435 8.0" 
$ns at 73.38948403048319 "$node_(37) setdest 1703 423 12.0" 
$ns at 199.52885759680828 "$node_(37) setdest 2776 541 6.0" 
$ns at 284.4126894831603 "$node_(37) setdest 158 502 20.0" 
$ns at 391.7878495382417 "$node_(37) setdest 35 575 17.0" 
$ns at 562.3351305338645 "$node_(37) setdest 108 158 5.0" 
$ns at 608.9787558381026 "$node_(37) setdest 2165 219 8.0" 
$ns at 647.4330802541255 "$node_(37) setdest 2618 472 1.0" 
$ns at 684.8011629374807 "$node_(37) setdest 2771 673 10.0" 
$ns at 748.6175991124433 "$node_(37) setdest 936 833 19.0" 
$ns at 857.0840929464944 "$node_(37) setdest 914 454 11.0" 
$ns at 0.0 "$node_(38) setdest 1680 132 4.0" 
$ns at 42.2752193164542 "$node_(38) setdest 422 989 1.0" 
$ns at 77.68074932105002 "$node_(38) setdest 2338 424 11.0" 
$ns at 211.00735841392185 "$node_(38) setdest 2870 651 18.0" 
$ns at 351.8955327476846 "$node_(38) setdest 2221 288 17.0" 
$ns at 540.1721946936738 "$node_(38) setdest 1223 71 5.0" 
$ns at 581.6988385606886 "$node_(38) setdest 1734 378 15.0" 
$ns at 747.939488165492 "$node_(38) setdest 2890 858 7.0" 
$ns at 821.8511722796209 "$node_(38) setdest 2591 900 16.0" 
$ns at 0.0 "$node_(39) setdest 686 80 18.0" 
$ns at 202.14343007651482 "$node_(39) setdest 1328 2 10.0" 
$ns at 243.22731086442298 "$node_(39) setdest 2944 127 8.0" 
$ns at 315.3849893258167 "$node_(39) setdest 2269 322 1.0" 
$ns at 354.0827923680182 "$node_(39) setdest 777 811 18.0" 
$ns at 534.9427586721008 "$node_(39) setdest 1771 176 8.0" 
$ns at 602.8232172304265 "$node_(39) setdest 237 827 19.0" 
$ns at 692.119182737421 "$node_(39) setdest 1417 124 2.0" 
$ns at 723.2602661743937 "$node_(39) setdest 1863 925 5.0" 
$ns at 798.6358217150896 "$node_(39) setdest 483 908 7.0" 
$ns at 866.6757807965079 "$node_(39) setdest 2865 420 5.0" 
$ns at 898.5386546484453 "$node_(39) setdest 2838 994 16.0" 
$ns at 0.0 "$node_(40) setdest 1945 890 18.0" 
$ns at 114.08559173436336 "$node_(40) setdest 2121 211 2.0" 
$ns at 156.450388528159 "$node_(40) setdest 2496 188 11.0" 
$ns at 199.7826595355561 "$node_(40) setdest 2834 221 6.0" 
$ns at 256.29514805422946 "$node_(40) setdest 1669 123 16.0" 
$ns at 441.3823057970702 "$node_(40) setdest 707 816 2.0" 
$ns at 471.7898278462079 "$node_(40) setdest 1578 422 12.0" 
$ns at 552.5273983589457 "$node_(40) setdest 2470 265 7.0" 
$ns at 628.8983490653048 "$node_(40) setdest 1603 846 18.0" 
$ns at 823.4735612910191 "$node_(40) setdest 898 221 9.0" 
$ns at 854.9068932586574 "$node_(40) setdest 575 564 4.0" 
$ns at 0.0 "$node_(41) setdest 1739 904 5.0" 
$ns at 32.48828103438685 "$node_(41) setdest 2306 148 19.0" 
$ns at 113.49199537401117 "$node_(41) setdest 1920 565 18.0" 
$ns at 301.53517134993194 "$node_(41) setdest 732 812 16.0" 
$ns at 356.9308130129743 "$node_(41) setdest 2127 463 18.0" 
$ns at 472.74985195949375 "$node_(41) setdest 2662 746 10.0" 
$ns at 592.8790192629161 "$node_(41) setdest 2645 839 14.0" 
$ns at 706.1419584999772 "$node_(41) setdest 2862 671 12.0" 
$ns at 852.5281589678518 "$node_(41) setdest 1082 631 3.0" 
$ns at 894.7757400648574 "$node_(41) setdest 1000 963 18.0" 
$ns at 0.0 "$node_(42) setdest 2325 925 9.0" 
$ns at 94.94093263747193 "$node_(42) setdest 666 976 13.0" 
$ns at 162.8123516983694 "$node_(42) setdest 888 354 1.0" 
$ns at 200.4430780619383 "$node_(42) setdest 489 410 1.0" 
$ns at 238.0366901154374 "$node_(42) setdest 1477 973 14.0" 
$ns at 391.0096695956836 "$node_(42) setdest 78 857 7.0" 
$ns at 439.04382915346343 "$node_(42) setdest 438 310 11.0" 
$ns at 542.8449003972823 "$node_(42) setdest 2303 870 6.0" 
$ns at 599.8778195574367 "$node_(42) setdest 1420 606 1.0" 
$ns at 633.787155194233 "$node_(42) setdest 137 176 6.0" 
$ns at 667.4021606808167 "$node_(42) setdest 1408 472 12.0" 
$ns at 772.2310379245603 "$node_(42) setdest 79 898 9.0" 
$ns at 834.9844695057734 "$node_(42) setdest 967 454 6.0" 
$ns at 899.5999796689234 "$node_(42) setdest 2888 902 19.0" 
$ns at 0.0 "$node_(43) setdest 340 245 12.0" 
$ns at 92.4868479293409 "$node_(43) setdest 1134 619 13.0" 
$ns at 139.44883985075458 "$node_(43) setdest 763 526 11.0" 
$ns at 188.86963883171325 "$node_(43) setdest 2806 968 2.0" 
$ns at 234.28072800261893 "$node_(43) setdest 1117 691 5.0" 
$ns at 269.79546956260407 "$node_(43) setdest 975 240 19.0" 
$ns at 360.4280072804314 "$node_(43) setdest 1785 914 9.0" 
$ns at 428.9142641340865 "$node_(43) setdest 2257 57 19.0" 
$ns at 621.9437230347285 "$node_(43) setdest 1351 335 14.0" 
$ns at 697.2091483772386 "$node_(43) setdest 2577 764 9.0" 
$ns at 728.1847363066418 "$node_(43) setdest 2486 320 15.0" 
$ns at 800.9640563253865 "$node_(43) setdest 472 872 2.0" 
$ns at 849.2585953420953 "$node_(43) setdest 2168 51 18.0" 
$ns at 879.8635721131615 "$node_(43) setdest 939 416 2.0" 
$ns at 0.0 "$node_(44) setdest 2093 929 15.0" 
$ns at 72.85916450534364 "$node_(44) setdest 2563 340 5.0" 
$ns at 115.29571327510148 "$node_(44) setdest 895 531 20.0" 
$ns at 251.37484933677052 "$node_(44) setdest 426 270 6.0" 
$ns at 333.5321454720825 "$node_(44) setdest 2562 102 17.0" 
$ns at 458.0171280748035 "$node_(44) setdest 2054 290 4.0" 
$ns at 509.8087745059294 "$node_(44) setdest 1149 835 19.0" 
$ns at 699.2807185303508 "$node_(44) setdest 374 589 1.0" 
$ns at 731.2698002688219 "$node_(44) setdest 1678 407 15.0" 
$ns at 831.0652731929197 "$node_(44) setdest 1451 79 13.0" 
$ns at 0.0 "$node_(45) setdest 2832 528 16.0" 
$ns at 83.27199287381725 "$node_(45) setdest 1485 368 6.0" 
$ns at 121.81396333285197 "$node_(45) setdest 2817 480 11.0" 
$ns at 198.59268290976922 "$node_(45) setdest 327 677 5.0" 
$ns at 273.31115035923995 "$node_(45) setdest 524 891 20.0" 
$ns at 341.2094731303048 "$node_(45) setdest 1493 586 6.0" 
$ns at 379.3986897956051 "$node_(45) setdest 847 222 12.0" 
$ns at 449.0061124437183 "$node_(45) setdest 444 709 18.0" 
$ns at 617.2106252478346 "$node_(45) setdest 784 722 9.0" 
$ns at 698.0298546387526 "$node_(45) setdest 2607 664 15.0" 
$ns at 800.7920966407216 "$node_(45) setdest 2697 820 17.0" 
$ns at 855.3248368677135 "$node_(45) setdest 2400 956 12.0" 
$ns at 0.0 "$node_(46) setdest 2844 210 13.0" 
$ns at 54.469611803680436 "$node_(46) setdest 2239 629 2.0" 
$ns at 95.86548861697094 "$node_(46) setdest 63 106 12.0" 
$ns at 141.96654154552536 "$node_(46) setdest 1299 810 15.0" 
$ns at 247.1605787164665 "$node_(46) setdest 1216 404 3.0" 
$ns at 302.8156632643285 "$node_(46) setdest 1496 492 1.0" 
$ns at 338.6204317940688 "$node_(46) setdest 780 752 9.0" 
$ns at 390.5152827340525 "$node_(46) setdest 955 190 16.0" 
$ns at 432.83080299745814 "$node_(46) setdest 2694 750 15.0" 
$ns at 509.52479601774985 "$node_(46) setdest 2961 318 3.0" 
$ns at 547.4778578262451 "$node_(46) setdest 337 784 3.0" 
$ns at 580.8707601005758 "$node_(46) setdest 119 408 2.0" 
$ns at 623.5103885023555 "$node_(46) setdest 2260 218 11.0" 
$ns at 657.1879404676009 "$node_(46) setdest 2247 524 17.0" 
$ns at 721.0517082039512 "$node_(46) setdest 45 942 11.0" 
$ns at 778.3245436147552 "$node_(46) setdest 230 501 15.0" 
$ns at 865.9046085573164 "$node_(46) setdest 397 510 16.0" 
$ns at 0.0 "$node_(47) setdest 1829 861 1.0" 
$ns at 30.748245141163384 "$node_(47) setdest 1365 362 19.0" 
$ns at 217.38048162032098 "$node_(47) setdest 207 513 1.0" 
$ns at 255.8781086047257 "$node_(47) setdest 294 852 16.0" 
$ns at 410.8403402414298 "$node_(47) setdest 650 623 13.0" 
$ns at 507.0192569684335 "$node_(47) setdest 1880 96 7.0" 
$ns at 582.1919591671272 "$node_(47) setdest 748 238 15.0" 
$ns at 665.0156813366475 "$node_(47) setdest 1466 858 10.0" 
$ns at 791.0469464712743 "$node_(47) setdest 10 553 13.0" 
$ns at 0.0 "$node_(48) setdest 423 964 12.0" 
$ns at 118.62025771664588 "$node_(48) setdest 1678 918 4.0" 
$ns at 180.3882073510958 "$node_(48) setdest 266 994 20.0" 
$ns at 317.47246606482724 "$node_(48) setdest 228 954 7.0" 
$ns at 391.89820558862533 "$node_(48) setdest 854 231 7.0" 
$ns at 428.86771072886484 "$node_(48) setdest 2804 397 19.0" 
$ns at 497.72564150706944 "$node_(48) setdest 1806 104 16.0" 
$ns at 631.6632965153419 "$node_(48) setdest 1583 514 7.0" 
$ns at 713.1331738523198 "$node_(48) setdest 999 624 4.0" 
$ns at 746.3204209716577 "$node_(48) setdest 815 237 5.0" 
$ns at 803.8997377546269 "$node_(48) setdest 2776 534 6.0" 
$ns at 872.5049966293436 "$node_(48) setdest 2035 335 1.0" 
$ns at 0.0 "$node_(49) setdest 1226 179 14.0" 
$ns at 158.4748245404816 "$node_(49) setdest 1697 286 7.0" 
$ns at 211.40890530696555 "$node_(49) setdest 667 326 15.0" 
$ns at 255.8937483867102 "$node_(49) setdest 2216 666 9.0" 
$ns at 320.3347643887188 "$node_(49) setdest 1189 417 4.0" 
$ns at 387.00269901748436 "$node_(49) setdest 2180 204 5.0" 
$ns at 437.10409462449485 "$node_(49) setdest 898 6 4.0" 
$ns at 497.6784877837844 "$node_(49) setdest 1207 847 10.0" 
$ns at 599.9167295777783 "$node_(49) setdest 1212 357 13.0" 
$ns at 729.4197898989066 "$node_(49) setdest 1714 450 12.0" 
$ns at 836.7337138213501 "$node_(49) setdest 2343 444 7.0" 
$ns at 0.0 "$node_(50) setdest 2584 962 1.0" 
$ns at 38.56940777634826 "$node_(50) setdest 833 853 16.0" 
$ns at 149.1642309325801 "$node_(50) setdest 1470 217 1.0" 
$ns at 187.3292502356222 "$node_(50) setdest 1762 299 4.0" 
$ns at 238.26865000313626 "$node_(50) setdest 2250 690 5.0" 
$ns at 280.94458119376367 "$node_(50) setdest 1999 775 9.0" 
$ns at 367.9186156393919 "$node_(50) setdest 865 836 5.0" 
$ns at 409.6894758088025 "$node_(50) setdest 630 548 14.0" 
$ns at 573.359700893936 "$node_(50) setdest 1538 873 4.0" 
$ns at 621.7492383337355 "$node_(50) setdest 409 509 8.0" 
$ns at 721.4377260279178 "$node_(50) setdest 2125 127 2.0" 
$ns at 765.5163888311137 "$node_(50) setdest 877 597 3.0" 
$ns at 807.9743218631093 "$node_(50) setdest 2092 288 11.0" 
$ns at 204.91254216732503 "$node_(51) setdest 665 922 3.0" 
$ns at 254.9001714062665 "$node_(51) setdest 2690 287 2.0" 
$ns at 303.06543128172495 "$node_(51) setdest 2212 586 16.0" 
$ns at 486.13857026333187 "$node_(51) setdest 877 647 4.0" 
$ns at 549.5848529078463 "$node_(51) setdest 925 174 6.0" 
$ns at 612.9943236438435 "$node_(51) setdest 2858 840 12.0" 
$ns at 743.5698929196885 "$node_(51) setdest 1666 612 19.0" 
$ns at 171.6415897088445 "$node_(52) setdest 2919 844 13.0" 
$ns at 325.8591627755987 "$node_(52) setdest 19 902 13.0" 
$ns at 367.6479978560038 "$node_(52) setdest 1507 961 13.0" 
$ns at 469.8656869647996 "$node_(52) setdest 2928 765 18.0" 
$ns at 573.4211154326442 "$node_(52) setdest 2424 388 15.0" 
$ns at 738.5759249192507 "$node_(52) setdest 2066 18 5.0" 
$ns at 816.0532135377468 "$node_(52) setdest 2703 852 3.0" 
$ns at 863.0585718878203 "$node_(52) setdest 1681 26 19.0" 
$ns at 894.8505369246811 "$node_(52) setdest 1637 282 8.0" 
$ns at 172.67167755157988 "$node_(53) setdest 947 469 11.0" 
$ns at 230.75872802953478 "$node_(53) setdest 740 590 15.0" 
$ns at 343.7615308248645 "$node_(53) setdest 2288 105 5.0" 
$ns at 390.521784749512 "$node_(53) setdest 1530 702 4.0" 
$ns at 444.00872956749055 "$node_(53) setdest 70 93 15.0" 
$ns at 562.542894045479 "$node_(53) setdest 573 65 9.0" 
$ns at 592.9696350008196 "$node_(53) setdest 1345 219 13.0" 
$ns at 665.321592977085 "$node_(53) setdest 1700 256 10.0" 
$ns at 716.0162473650174 "$node_(53) setdest 260 559 7.0" 
$ns at 806.12277544859 "$node_(53) setdest 876 575 7.0" 
$ns at 895.0112850641652 "$node_(53) setdest 317 237 11.0" 
$ns at 205.11195460471828 "$node_(54) setdest 2449 868 4.0" 
$ns at 248.4785053257107 "$node_(54) setdest 412 128 3.0" 
$ns at 294.4217470459752 "$node_(54) setdest 1659 565 8.0" 
$ns at 363.79382666064265 "$node_(54) setdest 2248 696 17.0" 
$ns at 439.550950119223 "$node_(54) setdest 1890 508 16.0" 
$ns at 527.2556989939576 "$node_(54) setdest 1316 407 19.0" 
$ns at 616.8521428953246 "$node_(54) setdest 1739 474 12.0" 
$ns at 689.099729288376 "$node_(54) setdest 2031 228 7.0" 
$ns at 775.33522539688 "$node_(54) setdest 1327 602 15.0" 
$ns at 272.9909220183698 "$node_(55) setdest 1009 929 19.0" 
$ns at 354.07731221620395 "$node_(55) setdest 1588 714 8.0" 
$ns at 446.30804439324606 "$node_(55) setdest 812 155 3.0" 
$ns at 500.4774012115562 "$node_(55) setdest 377 839 6.0" 
$ns at 567.8961648099186 "$node_(55) setdest 668 346 5.0" 
$ns at 636.7803780013236 "$node_(55) setdest 1612 711 15.0" 
$ns at 752.4156183572039 "$node_(55) setdest 1847 374 18.0" 
$ns at 810.1685720992782 "$node_(55) setdest 2775 344 1.0" 
$ns at 844.4869531846865 "$node_(55) setdest 2795 629 13.0" 
$ns at 181.59740105432138 "$node_(56) setdest 2919 364 4.0" 
$ns at 215.70893210403221 "$node_(56) setdest 1807 891 9.0" 
$ns at 329.74502702412866 "$node_(56) setdest 749 762 9.0" 
$ns at 384.0434061361316 "$node_(56) setdest 2077 603 10.0" 
$ns at 428.5014912203976 "$node_(56) setdest 1805 213 8.0" 
$ns at 531.0718898321486 "$node_(56) setdest 2626 94 9.0" 
$ns at 610.6408533041406 "$node_(56) setdest 1498 992 4.0" 
$ns at 648.1019394315371 "$node_(56) setdest 492 829 4.0" 
$ns at 704.5455328730812 "$node_(56) setdest 2922 738 14.0" 
$ns at 798.8610602081171 "$node_(56) setdest 1153 127 19.0" 
$ns at 234.4965184396701 "$node_(57) setdest 148 981 9.0" 
$ns at 328.30678825341056 "$node_(57) setdest 2065 94 10.0" 
$ns at 394.52161891450737 "$node_(57) setdest 2830 325 18.0" 
$ns at 461.1656256339303 "$node_(57) setdest 1733 44 9.0" 
$ns at 542.5309853212411 "$node_(57) setdest 2016 496 8.0" 
$ns at 620.6972009359949 "$node_(57) setdest 1245 438 1.0" 
$ns at 653.21894269786 "$node_(57) setdest 1612 757 5.0" 
$ns at 730.1757357536732 "$node_(57) setdest 1175 302 4.0" 
$ns at 776.1676341774908 "$node_(57) setdest 982 194 14.0" 
$ns at 224.08458587262697 "$node_(58) setdest 187 693 4.0" 
$ns at 260.4325837349938 "$node_(58) setdest 1328 16 11.0" 
$ns at 338.100982984388 "$node_(58) setdest 244 710 6.0" 
$ns at 414.0899655675777 "$node_(58) setdest 2231 512 1.0" 
$ns at 447.0388703292575 "$node_(58) setdest 1170 205 17.0" 
$ns at 545.0817344361527 "$node_(58) setdest 541 789 5.0" 
$ns at 587.6623080029 "$node_(58) setdest 1779 948 18.0" 
$ns at 693.7334771754812 "$node_(58) setdest 2449 17 17.0" 
$ns at 739.4141056905185 "$node_(58) setdest 264 613 18.0" 
$ns at 884.5065711739387 "$node_(58) setdest 2536 990 12.0" 
$ns at 343.88052018702166 "$node_(59) setdest 1740 326 17.0" 
$ns at 498.9919011839854 "$node_(59) setdest 816 497 6.0" 
$ns at 538.8088189309863 "$node_(59) setdest 1912 720 10.0" 
$ns at 646.1900673869131 "$node_(59) setdest 2728 555 12.0" 
$ns at 771.070649840809 "$node_(59) setdest 682 146 15.0" 
$ns at 899.4233800367344 "$node_(59) setdest 745 120 19.0" 
$ns at 191.03527815132222 "$node_(60) setdest 1859 807 1.0" 
$ns at 222.29128807545624 "$node_(60) setdest 319 809 14.0" 
$ns at 318.20717766396206 "$node_(60) setdest 764 766 3.0" 
$ns at 378.1180346206605 "$node_(60) setdest 770 669 20.0" 
$ns at 433.0575852483285 "$node_(60) setdest 2387 235 15.0" 
$ns at 610.4836839605007 "$node_(60) setdest 1455 701 8.0" 
$ns at 647.8669840486466 "$node_(60) setdest 1039 837 17.0" 
$ns at 760.8424071726074 "$node_(60) setdest 1162 147 14.0" 
$ns at 852.3078759969776 "$node_(60) setdest 1928 208 3.0" 
$ns at 240.1785030956853 "$node_(61) setdest 1871 657 1.0" 
$ns at 275.90548016455847 "$node_(61) setdest 1385 831 5.0" 
$ns at 318.5341445060763 "$node_(61) setdest 34 940 3.0" 
$ns at 357.66028640672255 "$node_(61) setdest 2709 229 6.0" 
$ns at 428.6519337153165 "$node_(61) setdest 518 875 13.0" 
$ns at 508.9618618081211 "$node_(61) setdest 2891 727 20.0" 
$ns at 573.5319637827943 "$node_(61) setdest 626 590 4.0" 
$ns at 615.5572830848398 "$node_(61) setdest 2563 919 1.0" 
$ns at 655.214164189909 "$node_(61) setdest 2126 727 12.0" 
$ns at 731.8021920791236 "$node_(61) setdest 560 434 6.0" 
$ns at 775.8492752538061 "$node_(61) setdest 174 148 2.0" 
$ns at 808.966901475065 "$node_(61) setdest 2426 555 16.0" 
$ns at 234.6425459512471 "$node_(62) setdest 1528 487 13.0" 
$ns at 347.13144358418685 "$node_(62) setdest 322 785 10.0" 
$ns at 407.184798179702 "$node_(62) setdest 1749 829 6.0" 
$ns at 446.45071747511224 "$node_(62) setdest 2052 214 19.0" 
$ns at 597.0354390114578 "$node_(62) setdest 1595 906 10.0" 
$ns at 630.1523507365688 "$node_(62) setdest 2103 871 9.0" 
$ns at 680.7123934227187 "$node_(62) setdest 2112 627 2.0" 
$ns at 730.2314658703732 "$node_(62) setdest 786 340 13.0" 
$ns at 829.6135460660178 "$node_(62) setdest 387 653 11.0" 
$ns at 186.02807407712507 "$node_(63) setdest 2283 694 3.0" 
$ns at 238.76099919030244 "$node_(63) setdest 1596 359 13.0" 
$ns at 386.150268157067 "$node_(63) setdest 773 484 10.0" 
$ns at 442.6774908951514 "$node_(63) setdest 1091 437 17.0" 
$ns at 557.9646550406671 "$node_(63) setdest 1858 326 13.0" 
$ns at 643.5572732823251 "$node_(63) setdest 475 980 15.0" 
$ns at 815.8534876985908 "$node_(63) setdest 817 290 10.0" 
$ns at 206.45340552860608 "$node_(64) setdest 2498 157 6.0" 
$ns at 252.3119321261242 "$node_(64) setdest 2409 775 19.0" 
$ns at 347.8313189103781 "$node_(64) setdest 2815 650 19.0" 
$ns at 496.34733658732193 "$node_(64) setdest 65 489 6.0" 
$ns at 551.4041615801302 "$node_(64) setdest 1262 879 8.0" 
$ns at 610.7825173170281 "$node_(64) setdest 907 100 17.0" 
$ns at 642.3032014966378 "$node_(64) setdest 441 727 19.0" 
$ns at 722.6565329070254 "$node_(64) setdest 719 383 18.0" 
$ns at 875.8416039247102 "$node_(64) setdest 1979 789 6.0" 
$ns at 281.486258899233 "$node_(65) setdest 2052 376 1.0" 
$ns at 314.7073839520294 "$node_(65) setdest 2717 138 4.0" 
$ns at 358.69130151518976 "$node_(65) setdest 518 668 13.0" 
$ns at 422.773802902942 "$node_(65) setdest 2825 892 1.0" 
$ns at 460.13568248500627 "$node_(65) setdest 1177 973 10.0" 
$ns at 502.007453690253 "$node_(65) setdest 1303 564 12.0" 
$ns at 619.5101719315792 "$node_(65) setdest 2941 609 16.0" 
$ns at 735.325956430288 "$node_(65) setdest 1505 559 18.0" 
$ns at 880.9070187884922 "$node_(65) setdest 2826 607 18.0" 
$ns at 311.2772674362974 "$node_(66) setdest 1435 528 9.0" 
$ns at 370.7446051323757 "$node_(66) setdest 2043 673 6.0" 
$ns at 420.9473081568578 "$node_(66) setdest 281 551 7.0" 
$ns at 451.13106389735515 "$node_(66) setdest 678 33 17.0" 
$ns at 526.4262952594759 "$node_(66) setdest 504 386 4.0" 
$ns at 572.8994758136605 "$node_(66) setdest 2832 283 12.0" 
$ns at 687.8893496684202 "$node_(66) setdest 1992 825 6.0" 
$ns at 745.5989092805332 "$node_(66) setdest 1550 298 18.0" 
$ns at 183.92539380886473 "$node_(67) setdest 1679 94 3.0" 
$ns at 214.44056383842008 "$node_(67) setdest 2157 108 16.0" 
$ns at 324.8175880406296 "$node_(67) setdest 1481 990 4.0" 
$ns at 382.23630963692375 "$node_(67) setdest 1724 921 17.0" 
$ns at 571.919684422885 "$node_(67) setdest 2155 872 20.0" 
$ns at 626.3351963951275 "$node_(67) setdest 246 303 1.0" 
$ns at 660.0857217444124 "$node_(67) setdest 1870 226 14.0" 
$ns at 702.6299176423992 "$node_(67) setdest 1443 435 6.0" 
$ns at 741.3184915840794 "$node_(67) setdest 2282 416 15.0" 
$ns at 776.9905667421529 "$node_(67) setdest 896 18 9.0" 
$ns at 847.989358548775 "$node_(67) setdest 2352 499 14.0" 
$ns at 187.56570942920033 "$node_(68) setdest 2401 432 16.0" 
$ns at 336.2254825727959 "$node_(68) setdest 1866 394 12.0" 
$ns at 484.94265425809493 "$node_(68) setdest 2907 21 11.0" 
$ns at 600.2290138741682 "$node_(68) setdest 2672 272 7.0" 
$ns at 631.7819770899414 "$node_(68) setdest 1275 241 15.0" 
$ns at 752.4363335395612 "$node_(68) setdest 2354 371 7.0" 
$ns at 815.9888683411675 "$node_(68) setdest 2585 774 8.0" 
$ns at 198.78530662459875 "$node_(69) setdest 2235 91 4.0" 
$ns at 256.46200966356815 "$node_(69) setdest 864 757 11.0" 
$ns at 364.6379430230438 "$node_(69) setdest 198 220 7.0" 
$ns at 408.84633452149615 "$node_(69) setdest 2941 690 14.0" 
$ns at 444.4821378157752 "$node_(69) setdest 1538 865 8.0" 
$ns at 510.4095242919466 "$node_(69) setdest 1173 39 10.0" 
$ns at 594.0374165767363 "$node_(69) setdest 1554 260 16.0" 
$ns at 699.9182357210864 "$node_(69) setdest 1675 545 10.0" 
$ns at 750.0395607425728 "$node_(69) setdest 465 709 3.0" 
$ns at 790.6759270176647 "$node_(69) setdest 15 788 15.0" 
$ns at 884.695909614262 "$node_(69) setdest 2752 395 4.0" 
$ns at 189.3369479952916 "$node_(70) setdest 2997 835 12.0" 
$ns at 317.66618794777827 "$node_(70) setdest 571 336 15.0" 
$ns at 474.2878536017365 "$node_(70) setdest 1832 450 14.0" 
$ns at 569.4501024427915 "$node_(70) setdest 344 659 12.0" 
$ns at 634.7229030772635 "$node_(70) setdest 931 207 8.0" 
$ns at 726.3943937714821 "$node_(70) setdest 202 74 10.0" 
$ns at 813.0699023765292 "$node_(70) setdest 293 164 8.0" 
$ns at 870.8149595342545 "$node_(70) setdest 2577 363 8.0" 
$ns at 204.1282054071843 "$node_(71) setdest 1289 610 3.0" 
$ns at 259.07154277505316 "$node_(71) setdest 1544 609 14.0" 
$ns at 373.08811568273825 "$node_(71) setdest 1559 129 6.0" 
$ns at 420.73290282758995 "$node_(71) setdest 1174 542 13.0" 
$ns at 569.7092531445534 "$node_(71) setdest 2267 698 14.0" 
$ns at 610.7861721608273 "$node_(71) setdest 2346 20 11.0" 
$ns at 665.3274368242735 "$node_(71) setdest 1818 169 3.0" 
$ns at 709.9244615714841 "$node_(71) setdest 1037 563 12.0" 
$ns at 811.9357513401438 "$node_(71) setdest 2224 233 14.0" 
$ns at 861.4330775331839 "$node_(71) setdest 293 601 15.0" 
$ns at 207.21744912859907 "$node_(72) setdest 1216 851 9.0" 
$ns at 280.56509015592974 "$node_(72) setdest 2425 9 11.0" 
$ns at 353.8653385202753 "$node_(72) setdest 2059 122 12.0" 
$ns at 418.61551409360175 "$node_(72) setdest 929 225 8.0" 
$ns at 506.9927932556244 "$node_(72) setdest 1133 241 16.0" 
$ns at 552.5937882404551 "$node_(72) setdest 1541 599 3.0" 
$ns at 609.822205487563 "$node_(72) setdest 1152 877 7.0" 
$ns at 655.8890584342498 "$node_(72) setdest 438 899 10.0" 
$ns at 767.7497488411159 "$node_(72) setdest 381 641 18.0" 
$ns at 843.5158073195231 "$node_(72) setdest 1387 41 10.0" 
$ns at 180.01379283828044 "$node_(73) setdest 2578 382 7.0" 
$ns at 237.20872527068008 "$node_(73) setdest 1113 874 15.0" 
$ns at 392.2013811318294 "$node_(73) setdest 1793 53 14.0" 
$ns at 550.5481952814985 "$node_(73) setdest 1787 867 9.0" 
$ns at 658.595712013108 "$node_(73) setdest 591 354 15.0" 
$ns at 757.0678151267191 "$node_(73) setdest 856 446 6.0" 
$ns at 823.3374748616791 "$node_(73) setdest 2326 686 3.0" 
$ns at 862.4300979838855 "$node_(73) setdest 1584 648 13.0" 
$ns at 254.09757813675026 "$node_(74) setdest 2902 53 19.0" 
$ns at 284.80323311828823 "$node_(74) setdest 354 399 14.0" 
$ns at 344.31506695980323 "$node_(74) setdest 2745 548 7.0" 
$ns at 376.1162499655852 "$node_(74) setdest 2456 520 4.0" 
$ns at 437.2126758369361 "$node_(74) setdest 1969 96 5.0" 
$ns at 477.09468118826663 "$node_(74) setdest 160 357 4.0" 
$ns at 519.7800728940116 "$node_(74) setdest 2203 216 9.0" 
$ns at 611.0859976957041 "$node_(74) setdest 2041 924 17.0" 
$ns at 733.234750346783 "$node_(74) setdest 1225 250 2.0" 
$ns at 777.977858528724 "$node_(74) setdest 1707 636 3.0" 
$ns at 820.5683033631916 "$node_(74) setdest 1970 224 12.0" 
$ns at 449.572783126618 "$node_(75) setdest 1356 168 11.0" 
$ns at 490.0521264625749 "$node_(75) setdest 1857 258 11.0" 
$ns at 571.2308809738323 "$node_(75) setdest 2256 483 2.0" 
$ns at 607.7340336408057 "$node_(75) setdest 2207 166 11.0" 
$ns at 667.0450341813562 "$node_(75) setdest 285 565 1.0" 
$ns at 706.0563871109679 "$node_(75) setdest 1413 671 14.0" 
$ns at 824.6069366636879 "$node_(75) setdest 1743 890 6.0" 
$ns at 440.3861409234082 "$node_(76) setdest 1373 602 9.0" 
$ns at 523.8498186570947 "$node_(76) setdest 1599 925 4.0" 
$ns at 578.260228421285 "$node_(76) setdest 2757 273 15.0" 
$ns at 709.0328620267082 "$node_(76) setdest 1898 749 17.0" 
$ns at 847.7391843422077 "$node_(76) setdest 131 692 4.0" 
$ns at 885.6092262127328 "$node_(76) setdest 951 399 16.0" 
$ns at 380.57363286793145 "$node_(77) setdest 600 943 18.0" 
$ns at 576.6530873027655 "$node_(77) setdest 1768 442 19.0" 
$ns at 680.4960348389315 "$node_(77) setdest 2521 482 5.0" 
$ns at 734.0351736814043 "$node_(77) setdest 1154 395 12.0" 
$ns at 773.4769594072085 "$node_(77) setdest 1350 218 1.0" 
$ns at 812.4369368798799 "$node_(77) setdest 2699 439 11.0" 
$ns at 895.8724348509597 "$node_(77) setdest 1275 225 1.0" 
$ns at 510.80187629098697 "$node_(78) setdest 833 871 16.0" 
$ns at 696.2318360320601 "$node_(78) setdest 2155 759 20.0" 
$ns at 352.0816370175187 "$node_(79) setdest 1949 197 13.0" 
$ns at 444.18839940155374 "$node_(79) setdest 2531 354 17.0" 
$ns at 567.2373688713942 "$node_(79) setdest 570 651 10.0" 
$ns at 598.5892631326662 "$node_(79) setdest 2068 648 1.0" 
$ns at 636.2723895259896 "$node_(79) setdest 333 948 3.0" 
$ns at 687.1902573496584 "$node_(79) setdest 1245 931 7.0" 
$ns at 769.8680635727709 "$node_(79) setdest 450 513 16.0" 
$ns at 816.2440421574995 "$node_(79) setdest 70 50 8.0" 
$ns at 889.2144781457234 "$node_(79) setdest 2617 988 15.0" 
$ns at 404.28915182583694 "$node_(80) setdest 1910 24 5.0" 
$ns at 476.206840558011 "$node_(80) setdest 2124 145 19.0" 
$ns at 692.7445588892506 "$node_(80) setdest 2706 699 14.0" 
$ns at 834.0276370871073 "$node_(80) setdest 1954 649 5.0" 
$ns at 880.3839564759734 "$node_(80) setdest 2694 636 9.0" 
$ns at 444.58899282623753 "$node_(81) setdest 1472 818 4.0" 
$ns at 475.9628561801708 "$node_(81) setdest 1978 622 20.0" 
$ns at 553.2172290990845 "$node_(81) setdest 2358 389 17.0" 
$ns at 675.8623905381602 "$node_(81) setdest 2735 351 1.0" 
$ns at 715.0975085333383 "$node_(81) setdest 1357 5 18.0" 
$ns at 866.8379300680258 "$node_(81) setdest 2341 663 18.0" 
$ns at 361.89573533595757 "$node_(82) setdest 2507 344 13.0" 
$ns at 441.9322420328722 "$node_(82) setdest 1069 927 18.0" 
$ns at 590.9305117032548 "$node_(82) setdest 1745 795 9.0" 
$ns at 688.7857011181625 "$node_(82) setdest 1899 604 13.0" 
$ns at 770.9402013817104 "$node_(82) setdest 2695 279 8.0" 
$ns at 831.2736674563691 "$node_(82) setdest 2143 292 15.0" 
$ns at 373.446365800796 "$node_(83) setdest 515 442 13.0" 
$ns at 417.89567464451034 "$node_(83) setdest 838 822 9.0" 
$ns at 468.8119626148834 "$node_(83) setdest 2686 719 9.0" 
$ns at 503.0799962026174 "$node_(83) setdest 1322 830 19.0" 
$ns at 709.5295728173619 "$node_(83) setdest 2055 229 4.0" 
$ns at 742.9951945072329 "$node_(83) setdest 2053 92 18.0" 
$ns at 789.8521003022514 "$node_(83) setdest 1309 416 11.0" 
$ns at 362.79021512075906 "$node_(84) setdest 2759 837 1.0" 
$ns at 402.6709900306997 "$node_(84) setdest 2330 285 16.0" 
$ns at 466.84471725590714 "$node_(84) setdest 1041 98 19.0" 
$ns at 501.91755847760516 "$node_(84) setdest 1143 457 8.0" 
$ns at 609.8962294203094 "$node_(84) setdest 2672 929 5.0" 
$ns at 687.0383482099335 "$node_(84) setdest 1986 559 10.0" 
$ns at 723.8890757683006 "$node_(84) setdest 2420 654 1.0" 
$ns at 758.0311674622527 "$node_(84) setdest 2613 239 12.0" 
$ns at 826.7909615934741 "$node_(84) setdest 2601 913 3.0" 
$ns at 871.6688883589366 "$node_(84) setdest 232 544 1.0" 
$ns at 378.1315391825641 "$node_(85) setdest 2820 128 10.0" 
$ns at 430.683390817247 "$node_(85) setdest 2644 882 2.0" 
$ns at 464.869774399556 "$node_(85) setdest 2184 109 9.0" 
$ns at 537.0915909599921 "$node_(85) setdest 2004 597 17.0" 
$ns at 608.8399612198358 "$node_(85) setdest 2551 897 10.0" 
$ns at 650.7266140538075 "$node_(85) setdest 1218 224 16.0" 
$ns at 826.2397079915928 "$node_(85) setdest 558 301 3.0" 
$ns at 857.6930368810567 "$node_(85) setdest 750 74 10.0" 
$ns at 422.76766724111746 "$node_(86) setdest 2961 361 9.0" 
$ns at 492.5662441868286 "$node_(86) setdest 1481 482 19.0" 
$ns at 542.4827372131708 "$node_(86) setdest 1683 447 4.0" 
$ns at 596.5282873654801 "$node_(86) setdest 1347 84 16.0" 
$ns at 755.8352697088282 "$node_(86) setdest 1181 960 16.0" 
$ns at 814.4370182448347 "$node_(86) setdest 2716 925 9.0" 
$ns at 375.9476247649296 "$node_(87) setdest 2368 502 18.0" 
$ns at 540.7034403106135 "$node_(87) setdest 445 950 9.0" 
$ns at 591.5531161388756 "$node_(87) setdest 1414 699 17.0" 
$ns at 746.5309911785738 "$node_(87) setdest 386 118 5.0" 
$ns at 804.8607711387222 "$node_(87) setdest 188 858 10.0" 
$ns at 371.66114893301335 "$node_(88) setdest 506 573 18.0" 
$ns at 451.6285255995428 "$node_(88) setdest 2142 916 10.0" 
$ns at 509.44987156546165 "$node_(88) setdest 2010 955 6.0" 
$ns at 542.425038648697 "$node_(88) setdest 1513 77 17.0" 
$ns at 720.1759107793782 "$node_(88) setdest 1921 891 12.0" 
$ns at 756.530043012344 "$node_(88) setdest 2997 939 7.0" 
$ns at 813.2207896495114 "$node_(88) setdest 210 492 12.0" 
$ns at 409.19053441156916 "$node_(89) setdest 2690 192 4.0" 
$ns at 452.34958739798344 "$node_(89) setdest 58 328 17.0" 
$ns at 588.7777708523689 "$node_(89) setdest 849 894 12.0" 
$ns at 678.7566597690998 "$node_(89) setdest 1762 675 18.0" 
$ns at 837.892889228085 "$node_(89) setdest 113 41 10.0" 
$ns at 884.8692182752555 "$node_(89) setdest 657 745 10.0" 
$ns at 365.433264606292 "$node_(90) setdest 43 176 17.0" 
$ns at 439.87562599473983 "$node_(90) setdest 682 23 2.0" 
$ns at 478.50906304155825 "$node_(90) setdest 990 420 13.0" 
$ns at 590.8232003141392 "$node_(90) setdest 741 778 4.0" 
$ns at 649.2907251654107 "$node_(90) setdest 2907 359 2.0" 
$ns at 689.2249254968599 "$node_(90) setdest 1763 209 4.0" 
$ns at 738.4281310751304 "$node_(90) setdest 2711 630 4.0" 
$ns at 796.5386005401626 "$node_(90) setdest 857 996 19.0" 
$ns at 384.725614061223 "$node_(91) setdest 2557 420 5.0" 
$ns at 435.5579651312367 "$node_(91) setdest 1694 407 3.0" 
$ns at 481.78345759917016 "$node_(91) setdest 798 983 18.0" 
$ns at 558.2779100444545 "$node_(91) setdest 2429 925 19.0" 
$ns at 625.5803527729469 "$node_(91) setdest 1516 376 19.0" 
$ns at 720.6445985616488 "$node_(91) setdest 1532 290 13.0" 
$ns at 879.1732263159777 "$node_(91) setdest 2703 409 5.0" 
$ns at 373.23536460752604 "$node_(92) setdest 1058 234 14.0" 
$ns at 463.9813669862677 "$node_(92) setdest 718 119 14.0" 
$ns at 506.37795185535424 "$node_(92) setdest 1798 873 17.0" 
$ns at 681.4530038641662 "$node_(92) setdest 1544 248 15.0" 
$ns at 769.5342885662881 "$node_(92) setdest 1617 961 2.0" 
$ns at 801.8705639574633 "$node_(92) setdest 1979 851 6.0" 
$ns at 889.9912351744108 "$node_(92) setdest 2179 452 7.0" 
$ns at 397.7198632105616 "$node_(93) setdest 1023 796 5.0" 
$ns at 470.0592582697033 "$node_(93) setdest 1850 357 14.0" 
$ns at 552.9463606262453 "$node_(93) setdest 2878 710 10.0" 
$ns at 632.9882634210167 "$node_(93) setdest 1526 105 7.0" 
$ns at 697.7653887170773 "$node_(93) setdest 2003 232 2.0" 
$ns at 729.8226472394633 "$node_(93) setdest 2281 537 19.0" 
$ns at 877.9677977573405 "$node_(93) setdest 2914 568 5.0" 
$ns at 331.74095845975415 "$node_(94) setdest 425 502 15.0" 
$ns at 425.1945768257274 "$node_(94) setdest 2142 516 9.0" 
$ns at 518.9829220069904 "$node_(94) setdest 1518 193 1.0" 
$ns at 556.6231629141741 "$node_(94) setdest 2515 785 13.0" 
$ns at 611.0207258219542 "$node_(94) setdest 1376 529 3.0" 
$ns at 653.7482930892385 "$node_(94) setdest 1686 739 11.0" 
$ns at 778.8096038560808 "$node_(94) setdest 781 243 12.0" 
$ns at 877.414942996611 "$node_(94) setdest 2549 665 19.0" 
$ns at 460.1075996881739 "$node_(95) setdest 271 139 7.0" 
$ns at 532.8747887060096 "$node_(95) setdest 481 151 18.0" 
$ns at 681.8798726388654 "$node_(95) setdest 55 316 15.0" 
$ns at 726.2810838391454 "$node_(95) setdest 2378 628 3.0" 
$ns at 774.2291403685903 "$node_(95) setdest 2164 87 17.0" 
$ns at 804.8858776182095 "$node_(95) setdest 2396 402 11.0" 
$ns at 841.7960380408306 "$node_(95) setdest 2604 310 14.0" 
$ns at 899.0625461037516 "$node_(95) setdest 1473 783 6.0" 
$ns at 457.5672131825937 "$node_(96) setdest 1387 902 6.0" 
$ns at 527.055320332992 "$node_(96) setdest 1244 917 8.0" 
$ns at 586.2235485922024 "$node_(96) setdest 902 315 14.0" 
$ns at 712.932718347055 "$node_(96) setdest 1543 681 6.0" 
$ns at 747.064836367788 "$node_(96) setdest 2057 322 2.0" 
$ns at 784.7351003938139 "$node_(96) setdest 783 444 6.0" 
$ns at 834.7674003461772 "$node_(96) setdest 2596 295 14.0" 
$ns at 359.9957561706601 "$node_(97) setdest 355 821 1.0" 
$ns at 392.46354614608174 "$node_(97) setdest 2053 677 8.0" 
$ns at 461.19529375239074 "$node_(97) setdest 483 162 16.0" 
$ns at 617.8451521610764 "$node_(97) setdest 1627 348 12.0" 
$ns at 701.3239322206002 "$node_(97) setdest 1784 609 6.0" 
$ns at 747.5016200298047 "$node_(97) setdest 1646 158 7.0" 
$ns at 821.1512863867503 "$node_(97) setdest 2300 332 11.0" 
$ns at 870.1162954640267 "$node_(97) setdest 2328 637 12.0" 
$ns at 343.20597968969787 "$node_(98) setdest 911 957 1.0" 
$ns at 378.44464852904366 "$node_(98) setdest 2852 350 18.0" 
$ns at 586.2394047856003 "$node_(98) setdest 1752 75 14.0" 
$ns at 745.8248750816073 "$node_(98) setdest 2483 36 19.0" 
$ns at 376.47868805272526 "$node_(99) setdest 117 855 19.0" 
$ns at 472.50293925673265 "$node_(99) setdest 1778 780 17.0" 
$ns at 523.2256682307639 "$node_(99) setdest 1579 476 10.0" 
$ns at 611.0464138433363 "$node_(99) setdest 727 620 9.0" 
$ns at 715.171989459811 "$node_(99) setdest 664 307 12.0" 
$ns at 837.8732161591959 "$node_(99) setdest 1792 108 15.0" 
$ns at 870.3204097703983 "$node_(99) setdest 2308 967 13.0" 
$ns at 516.1725006109865 "$node_(100) setdest 699 105 3.0" 
$ns at 555.4028225491855 "$node_(100) setdest 2924 549 2.0" 
$ns at 591.2789018406073 "$node_(100) setdest 876 191 7.0" 
$ns at 631.5633824054682 "$node_(100) setdest 1003 817 12.0" 
$ns at 678.6232896596217 "$node_(100) setdest 1858 84 19.0" 
$ns at 710.232101368322 "$node_(100) setdest 1552 422 8.0" 
$ns at 774.7553295383938 "$node_(100) setdest 506 492 1.0" 
$ns at 810.2042191107789 "$node_(100) setdest 1337 628 7.0" 
$ns at 882.3505780584298 "$node_(100) setdest 79 821 1.0" 
$ns at 526.3467131490897 "$node_(101) setdest 2090 95 15.0" 
$ns at 560.9677162692344 "$node_(101) setdest 1318 112 4.0" 
$ns at 624.8420970233462 "$node_(101) setdest 1194 689 12.0" 
$ns at 705.3917877155465 "$node_(101) setdest 1364 477 12.0" 
$ns at 840.7653247895206 "$node_(101) setdest 2078 424 19.0" 
$ns at 884.3559595530794 "$node_(101) setdest 1195 642 18.0" 
$ns at 510.1695790590528 "$node_(102) setdest 1914 148 1.0" 
$ns at 544.3835373207983 "$node_(102) setdest 509 223 12.0" 
$ns at 666.9024710650572 "$node_(102) setdest 1422 690 10.0" 
$ns at 711.172075932391 "$node_(102) setdest 2613 339 5.0" 
$ns at 762.7371662846472 "$node_(102) setdest 799 640 6.0" 
$ns at 808.7079818573416 "$node_(102) setdest 1598 797 18.0" 
$ns at 560.9882831269665 "$node_(103) setdest 1667 765 1.0" 
$ns at 598.4889418649411 "$node_(103) setdest 2823 932 3.0" 
$ns at 630.270414832273 "$node_(103) setdest 1939 685 3.0" 
$ns at 681.4434568222397 "$node_(103) setdest 455 699 14.0" 
$ns at 739.5919519239907 "$node_(103) setdest 1754 471 4.0" 
$ns at 794.0080912050789 "$node_(103) setdest 951 958 13.0" 
$ns at 502.1953384122909 "$node_(104) setdest 2230 650 3.0" 
$ns at 547.0668599626366 "$node_(104) setdest 2494 942 19.0" 
$ns at 679.2265206603878 "$node_(104) setdest 2310 164 1.0" 
$ns at 710.7831826044822 "$node_(104) setdest 2824 856 13.0" 
$ns at 817.5881890962836 "$node_(104) setdest 292 312 13.0" 
$ns at 521.1790098714515 "$node_(105) setdest 2731 406 14.0" 
$ns at 663.320894577304 "$node_(105) setdest 1397 382 13.0" 
$ns at 764.978937143918 "$node_(105) setdest 515 589 18.0" 
$ns at 797.5228037397599 "$node_(105) setdest 2574 314 10.0" 
$ns at 845.7627297946075 "$node_(105) setdest 1296 178 1.0" 
$ns at 880.5293106598257 "$node_(105) setdest 566 577 12.0" 
$ns at 525.6070357108935 "$node_(106) setdest 1149 661 5.0" 
$ns at 582.8997137043806 "$node_(106) setdest 561 842 2.0" 
$ns at 632.7913526033592 "$node_(106) setdest 2000 889 8.0" 
$ns at 673.0530579309461 "$node_(106) setdest 1758 135 9.0" 
$ns at 748.7958310702061 "$node_(106) setdest 831 895 16.0" 
$ns at 536.744556247205 "$node_(107) setdest 2268 800 10.0" 
$ns at 632.9360517677343 "$node_(107) setdest 1702 146 3.0" 
$ns at 670.1486833091682 "$node_(107) setdest 1443 792 12.0" 
$ns at 748.3791261298861 "$node_(107) setdest 1378 931 4.0" 
$ns at 813.1855406319992 "$node_(107) setdest 1580 277 6.0" 
$ns at 851.891494798223 "$node_(107) setdest 1673 356 15.0" 
$ns at 615.5131744999273 "$node_(108) setdest 766 464 1.0" 
$ns at 645.6302088901891 "$node_(108) setdest 1364 162 4.0" 
$ns at 687.8756182921557 "$node_(108) setdest 1789 135 1.0" 
$ns at 719.0618461365864 "$node_(108) setdest 2683 611 18.0" 
$ns at 749.4645888225455 "$node_(108) setdest 2422 650 9.0" 
$ns at 824.3553558716537 "$node_(108) setdest 440 242 14.0" 
$ns at 503.155382793409 "$node_(109) setdest 1940 548 15.0" 
$ns at 551.7956247469275 "$node_(109) setdest 2743 349 10.0" 
$ns at 606.5407335636227 "$node_(109) setdest 832 893 2.0" 
$ns at 636.9738427256563 "$node_(109) setdest 890 774 16.0" 
$ns at 757.3845895243808 "$node_(109) setdest 2436 750 20.0" 
$ns at 810.1665145455365 "$node_(109) setdest 2567 229 10.0" 
$ns at 890.1289845795432 "$node_(109) setdest 2337 42 14.0" 
$ns at 537.908291562417 "$node_(110) setdest 2813 688 4.0" 
$ns at 589.5806878262247 "$node_(110) setdest 2054 176 13.0" 
$ns at 693.8553430631991 "$node_(110) setdest 1719 842 7.0" 
$ns at 770.9916219244186 "$node_(110) setdest 1331 892 8.0" 
$ns at 861.2679945510719 "$node_(110) setdest 2052 401 9.0" 
$ns at 496.02971862266827 "$node_(111) setdest 2839 771 13.0" 
$ns at 605.3736501393612 "$node_(111) setdest 1505 656 19.0" 
$ns at 741.9272915805398 "$node_(111) setdest 327 780 10.0" 
$ns at 861.3415634395915 "$node_(111) setdest 1372 875 18.0" 
$ns at 534.9049783321716 "$node_(112) setdest 2951 768 6.0" 
$ns at 585.6809331797452 "$node_(112) setdest 65 922 19.0" 
$ns at 688.9793268889343 "$node_(112) setdest 659 623 6.0" 
$ns at 758.9659572601496 "$node_(112) setdest 2224 487 18.0" 
$ns at 826.6150023839954 "$node_(112) setdest 1249 558 5.0" 
$ns at 894.0056578283846 "$node_(112) setdest 1183 165 15.0" 
$ns at 507.78055937667756 "$node_(113) setdest 551 627 10.0" 
$ns at 570.7289084007949 "$node_(113) setdest 2838 774 5.0" 
$ns at 647.860189403394 "$node_(113) setdest 1235 428 1.0" 
$ns at 678.03895308813 "$node_(113) setdest 107 18 19.0" 
$ns at 742.2481786775365 "$node_(113) setdest 2725 661 9.0" 
$ns at 842.0261891481528 "$node_(113) setdest 97 701 16.0" 
$ns at 898.6580799874097 "$node_(113) setdest 1884 559 18.0" 
$ns at 585.9495453411499 "$node_(114) setdest 2067 393 15.0" 
$ns at 651.353550948309 "$node_(114) setdest 1220 956 14.0" 
$ns at 732.3958361235495 "$node_(114) setdest 710 711 18.0" 
$ns at 568.2538590183055 "$node_(115) setdest 1068 334 12.0" 
$ns at 700.2513348469607 "$node_(115) setdest 739 506 12.0" 
$ns at 848.7322113644307 "$node_(115) setdest 1556 178 17.0" 
$ns at 540.691957653473 "$node_(116) setdest 2369 872 11.0" 
$ns at 638.0172594897334 "$node_(116) setdest 2474 962 10.0" 
$ns at 727.2727058577452 "$node_(116) setdest 2427 497 3.0" 
$ns at 768.6437933590006 "$node_(116) setdest 1773 126 12.0" 
$ns at 898.3853647038784 "$node_(116) setdest 2259 782 19.0" 
$ns at 606.300038370084 "$node_(117) setdest 1393 405 9.0" 
$ns at 681.9890302668459 "$node_(117) setdest 2727 785 11.0" 
$ns at 818.9788474267725 "$node_(117) setdest 2622 917 3.0" 
$ns at 876.6502081763792 "$node_(117) setdest 1376 568 17.0" 
$ns at 556.6954377864018 "$node_(118) setdest 2223 596 10.0" 
$ns at 623.7803527899215 "$node_(118) setdest 1161 841 11.0" 
$ns at 702.6529957128637 "$node_(118) setdest 2377 712 2.0" 
$ns at 750.9532354016991 "$node_(118) setdest 881 523 8.0" 
$ns at 855.6205206339796 "$node_(118) setdest 1427 766 6.0" 
$ns at 629.8715345955422 "$node_(119) setdest 2882 135 13.0" 
$ns at 777.555022964452 "$node_(119) setdest 1633 209 1.0" 
$ns at 810.6295835446498 "$node_(119) setdest 2139 918 5.0" 
$ns at 842.3682004805183 "$node_(119) setdest 2690 646 12.0" 
$ns at 562.0358206967775 "$node_(120) setdest 1934 332 19.0" 
$ns at 724.43447433381 "$node_(120) setdest 2434 12 5.0" 
$ns at 766.0692856289013 "$node_(120) setdest 1888 562 10.0" 
$ns at 878.4281271312628 "$node_(120) setdest 1714 411 16.0" 
$ns at 539.6151308442334 "$node_(121) setdest 1819 575 9.0" 
$ns at 612.7560624159154 "$node_(121) setdest 2652 697 14.0" 
$ns at 700.8769689001151 "$node_(121) setdest 1554 733 11.0" 
$ns at 765.4319166297048 "$node_(121) setdest 1849 439 8.0" 
$ns at 836.3636080624962 "$node_(121) setdest 2327 852 10.0" 
$ns at 542.8769440950599 "$node_(122) setdest 2065 302 1.0" 
$ns at 575.6926220158489 "$node_(122) setdest 657 518 8.0" 
$ns at 629.3311798391851 "$node_(122) setdest 983 527 16.0" 
$ns at 770.0992064823905 "$node_(122) setdest 2581 978 12.0" 
$ns at 850.3012542754875 "$node_(122) setdest 678 314 4.0" 
$ns at 544.8112457610432 "$node_(123) setdest 221 901 14.0" 
$ns at 708.1150192895891 "$node_(123) setdest 619 900 19.0" 
$ns at 780.3060150441809 "$node_(123) setdest 871 357 12.0" 
$ns at 864.3750817795404 "$node_(123) setdest 947 232 19.0" 
$ns at 516.9905971222854 "$node_(124) setdest 95 467 4.0" 
$ns at 578.3518726478651 "$node_(124) setdest 2344 844 2.0" 
$ns at 619.9307346437095 "$node_(124) setdest 1375 438 18.0" 
$ns at 707.5238492999791 "$node_(124) setdest 2115 1 4.0" 
$ns at 770.7907754685726 "$node_(124) setdest 2267 230 2.0" 
$ns at 806.5299850889083 "$node_(124) setdest 1669 929 14.0" 
$ns at 682.1595339776753 "$node_(125) setdest 861 845 19.0" 
$ns at 781.2514476947331 "$node_(125) setdest 2768 575 10.0" 
$ns at 826.6627015041718 "$node_(125) setdest 2199 844 20.0" 
$ns at 842.4651070455914 "$node_(126) setdest 2153 818 16.0" 
$ns at 874.965082457593 "$node_(126) setdest 2301 561 10.0" 
$ns at 678.5566027744411 "$node_(127) setdest 229 699 2.0" 
$ns at 722.284022577793 "$node_(127) setdest 778 462 10.0" 
$ns at 815.0239740228296 "$node_(127) setdest 995 185 8.0" 
$ns at 857.3625116016385 "$node_(127) setdest 1620 971 16.0" 
$ns at 837.3729649801653 "$node_(128) setdest 773 288 6.0" 
$ns at 885.6057301791612 "$node_(128) setdest 1357 233 4.0" 
$ns at 680.5417722534213 "$node_(129) setdest 908 412 5.0" 
$ns at 751.8878706697747 "$node_(129) setdest 319 359 12.0" 
$ns at 842.161324345684 "$node_(129) setdest 1119 80 7.0" 
$ns at 887.1897157069467 "$node_(129) setdest 1727 622 3.0" 
$ns at 741.8694082676116 "$node_(130) setdest 1186 109 6.0" 
$ns at 828.2164047932837 "$node_(130) setdest 2185 197 3.0" 
$ns at 884.1387762786206 "$node_(130) setdest 1973 459 20.0" 
$ns at 698.4804148466475 "$node_(131) setdest 923 235 8.0" 
$ns at 736.5443879951387 "$node_(131) setdest 754 10 3.0" 
$ns at 782.7679893141913 "$node_(131) setdest 171 99 4.0" 
$ns at 829.2758360084404 "$node_(131) setdest 2240 921 1.0" 
$ns at 862.9612683876982 "$node_(131) setdest 2593 481 1.0" 
$ns at 895.3213616939104 "$node_(131) setdest 2368 13 14.0" 
$ns at 669.8458211451116 "$node_(132) setdest 2337 290 11.0" 
$ns at 765.5010069760343 "$node_(132) setdest 1785 760 5.0" 
$ns at 802.1989684971368 "$node_(132) setdest 110 984 16.0" 
$ns at 697.3375601160883 "$node_(133) setdest 1029 81 3.0" 
$ns at 737.7310310584613 "$node_(133) setdest 912 488 16.0" 
$ns at 664.1045709541145 "$node_(134) setdest 2616 232 13.0" 
$ns at 705.4211186939393 "$node_(134) setdest 2376 410 3.0" 
$ns at 738.7402803109609 "$node_(134) setdest 322 587 16.0" 
$ns at 838.7833423827312 "$node_(134) setdest 2841 243 18.0" 
$ns at 731.8537876188961 "$node_(135) setdest 1338 154 17.0" 
$ns at 896.3376297426204 "$node_(135) setdest 983 361 16.0" 
$ns at 674.7472718675606 "$node_(136) setdest 1085 186 14.0" 
$ns at 794.6142565009623 "$node_(136) setdest 2843 511 5.0" 
$ns at 859.670041792249 "$node_(136) setdest 2176 447 1.0" 
$ns at 890.1963102063049 "$node_(136) setdest 928 609 5.0" 
$ns at 701.9247451402365 "$node_(137) setdest 1970 989 6.0" 
$ns at 737.0496672218063 "$node_(137) setdest 2163 707 7.0" 
$ns at 824.4824685811056 "$node_(137) setdest 1615 956 13.0" 
$ns at 723.6579311644252 "$node_(138) setdest 579 24 6.0" 
$ns at 769.4128049138988 "$node_(138) setdest 524 821 2.0" 
$ns at 814.3100846258866 "$node_(138) setdest 2079 402 18.0" 
$ns at 720.3471767856645 "$node_(139) setdest 1150 169 11.0" 
$ns at 792.1007729504842 "$node_(139) setdest 1057 239 4.0" 
$ns at 838.3271372356326 "$node_(139) setdest 1423 917 1.0" 
$ns at 877.2067140022968 "$node_(139) setdest 1403 732 18.0" 
$ns at 839.5260832873848 "$node_(140) setdest 2251 93 7.0" 
$ns at 881.9788609410183 "$node_(140) setdest 2443 37 11.0" 
$ns at 676.0587765141985 "$node_(141) setdest 2337 696 2.0" 
$ns at 706.9878460892382 "$node_(141) setdest 1236 192 6.0" 
$ns at 746.595518939032 "$node_(141) setdest 1389 85 9.0" 
$ns at 840.4874017339596 "$node_(141) setdest 1948 473 10.0" 
$ns at 898.5169375791941 "$node_(141) setdest 1777 762 1.0" 
$ns at 731.9647529821605 "$node_(142) setdest 151 214 14.0" 
$ns at 766.2582659249806 "$node_(142) setdest 2847 774 8.0" 
$ns at 805.1623386402154 "$node_(142) setdest 1760 506 12.0" 
$ns at 759.0444064296896 "$node_(143) setdest 1826 322 13.0" 
$ns at 879.6914741934139 "$node_(143) setdest 2827 635 6.0" 
$ns at 703.1376546420452 "$node_(144) setdest 2538 406 5.0" 
$ns at 742.6981675053642 "$node_(144) setdest 1577 278 6.0" 
$ns at 822.4670891167076 "$node_(144) setdest 1981 468 6.0" 
$ns at 857.7622534776667 "$node_(144) setdest 348 460 14.0" 
$ns at 707.7306873663417 "$node_(145) setdest 1490 495 13.0" 
$ns at 831.7979378816726 "$node_(145) setdest 2001 19 18.0" 
$ns at 785.2620188610871 "$node_(146) setdest 2226 396 7.0" 
$ns at 843.9675767753375 "$node_(146) setdest 2869 59 18.0" 
$ns at 695.2659701551564 "$node_(147) setdest 9 143 6.0" 
$ns at 756.2708685272194 "$node_(147) setdest 2979 636 12.0" 
$ns at 886.0169725491592 "$node_(147) setdest 1881 799 17.0" 
$ns at 689.5489157856246 "$node_(148) setdest 262 598 13.0" 
$ns at 792.4999094320365 "$node_(148) setdest 278 162 8.0" 
$ns at 845.4719955146305 "$node_(148) setdest 43 610 10.0" 
$ns at 688.4698456858002 "$node_(149) setdest 163 220 12.0" 
$ns at 744.9696899623318 "$node_(149) setdest 934 561 7.0" 
$ns at 817.6137866240924 "$node_(149) setdest 1571 732 2.0" 
$ns at 866.2726601226035 "$node_(149) setdest 1928 869 8.0" 


#Set a TCP connection between node_(44) and node_(26)
set tcp_(0) [new Agent/TCP/Newreno]
$tcp_(0) set class_ 2
set sink_(0) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(0)
$ns attach-agent $node_(26) $sink_(0)
$ns connect $tcp_(0) $sink_(0)
set ftp_(0) [new Application/FTP]
$ftp_(0) attach-agent $tcp_(0)
$ns at 0.2 "$ftp_(0) start"
$ns at 180.0 "$ftp_(0) stop"

#Set a TCP connection between node_(20) and node_(47)
set tcp_(1) [new Agent/TCP/Newreno]
$tcp_(1) set class_ 2
set sink_(1) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(1)
$ns attach-agent $node_(47) $sink_(1)
$ns connect $tcp_(1) $sink_(1)
set ftp_(1) [new Application/FTP]
$ftp_(1) attach-agent $tcp_(1)
$ns at 180.2 "$ftp_(1) start"
$ns at 360.0 "$ftp_(1) stop"

#Set a TCP connection between node_(7) and node_(2)
set tcp_(2) [new Agent/TCP/Newreno]
$tcp_(2) set class_ 2
set sink_(2) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(2)
$ns attach-agent $node_(2) $sink_(2)
$ns connect $tcp_(2) $sink_(2)
set ftp_(2) [new Application/FTP]
$ftp_(2) attach-agent $tcp_(2)
$ns at 360.2 "$ftp_(2) start"
$ns at 540.0 "$ftp_(2) stop"

#Set a TCP connection between node_(45) and node_(2)
set tcp_(3) [new Agent/TCP/Newreno]
$tcp_(3) set class_ 2
set sink_(3) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(3)
$ns attach-agent $node_(2) $sink_(3)
$ns connect $tcp_(3) $sink_(3)
set ftp_(3) [new Application/FTP]
$ftp_(3) attach-agent $tcp_(3)
$ns at 540.2 "$ftp_(3) start"
$ns at 720.0 "$ftp_(3) stop"

#Set a TCP connection between node_(32) and node_(30)
set tcp_(4) [new Agent/TCP/Newreno]
$tcp_(4) set class_ 2
set sink_(4) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(4)
$ns attach-agent $node_(30) $sink_(4)
$ns connect $tcp_(4) $sink_(4)
set ftp_(4) [new Application/FTP]
$ftp_(4) attach-agent $tcp_(4)
$ns at 720.2 "$ftp_(4) start"
$ns at 900.0 "$ftp_(4) stop"

#Set a TCP connection between node_(34) and node_(47)
set tcp_(5) [new Agent/TCP/Newreno]
$tcp_(5) set class_ 2
set sink_(5) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(5)
$ns attach-agent $node_(47) $sink_(5)
$ns connect $tcp_(5) $sink_(5)
set ftp_(5) [new Application/FTP]
$ftp_(5) attach-agent $tcp_(5)
$ns at 0.2 "$ftp_(5) start"
$ns at 180.0 "$ftp_(5) stop"

#Set a TCP connection between node_(21) and node_(40)
set tcp_(6) [new Agent/TCP/Newreno]
$tcp_(6) set class_ 2
set sink_(6) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(6)
$ns attach-agent $node_(40) $sink_(6)
$ns connect $tcp_(6) $sink_(6)
set ftp_(6) [new Application/FTP]
$ftp_(6) attach-agent $tcp_(6)
$ns at 180.2 "$ftp_(6) start"
$ns at 360.0 "$ftp_(6) stop"

#Set a TCP connection between node_(15) and node_(38)
set tcp_(7) [new Agent/TCP/Newreno]
$tcp_(7) set class_ 2
set sink_(7) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(7)
$ns attach-agent $node_(38) $sink_(7)
$ns connect $tcp_(7) $sink_(7)
set ftp_(7) [new Application/FTP]
$ftp_(7) attach-agent $tcp_(7)
$ns at 360.2 "$ftp_(7) start"
$ns at 540.0 "$ftp_(7) stop"

#Set a TCP connection between node_(16) and node_(2)
set tcp_(8) [new Agent/TCP/Newreno]
$tcp_(8) set class_ 2
set sink_(8) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(8)
$ns attach-agent $node_(2) $sink_(8)
$ns connect $tcp_(8) $sink_(8)
set ftp_(8) [new Application/FTP]
$ftp_(8) attach-agent $tcp_(8)
$ns at 540.2 "$ftp_(8) start"
$ns at 720.0 "$ftp_(8) stop"

#Set a TCP connection between node_(2) and node_(14)
set tcp_(9) [new Agent/TCP/Newreno]
$tcp_(9) set class_ 2
set sink_(9) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(9)
$ns attach-agent $node_(14) $sink_(9)
$ns connect $tcp_(9) $sink_(9)
set ftp_(9) [new Application/FTP]
$ftp_(9) attach-agent $tcp_(9)
$ns at 720.2 "$ftp_(9) start"
$ns at 900.0 "$ftp_(9) stop"

#Set a TCP connection between node_(45) and node_(10)
set tcp_(10) [new Agent/TCP/Newreno]
$tcp_(10) set class_ 2
set sink_(10) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(10)
$ns attach-agent $node_(10) $sink_(10)
$ns connect $tcp_(10) $sink_(10)
set ftp_(10) [new Application/FTP]
$ftp_(10) attach-agent $tcp_(10)
$ns at 0.2 "$ftp_(10) start"
$ns at 180.0 "$ftp_(10) stop"

#Set a TCP connection between node_(33) and node_(2)
set tcp_(11) [new Agent/TCP/Newreno]
$tcp_(11) set class_ 2
set sink_(11) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(11)
$ns attach-agent $node_(2) $sink_(11)
$ns connect $tcp_(11) $sink_(11)
set ftp_(11) [new Application/FTP]
$ftp_(11) attach-agent $tcp_(11)
$ns at 180.2 "$ftp_(11) start"
$ns at 360.0 "$ftp_(11) stop"

#Set a TCP connection between node_(5) and node_(32)
set tcp_(12) [new Agent/TCP/Newreno]
$tcp_(12) set class_ 2
set sink_(12) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(12)
$ns attach-agent $node_(32) $sink_(12)
$ns connect $tcp_(12) $sink_(12)
set ftp_(12) [new Application/FTP]
$ftp_(12) attach-agent $tcp_(12)
$ns at 360.2 "$ftp_(12) start"
$ns at 540.0 "$ftp_(12) stop"

#Set a TCP connection between node_(29) and node_(34)
set tcp_(13) [new Agent/TCP/Newreno]
$tcp_(13) set class_ 2
set sink_(13) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(13)
$ns attach-agent $node_(34) $sink_(13)
$ns connect $tcp_(13) $sink_(13)
set ftp_(13) [new Application/FTP]
$ftp_(13) attach-agent $tcp_(13)
$ns at 540.2 "$ftp_(13) start"
$ns at 720.0 "$ftp_(13) stop"

#Set a TCP connection between node_(32) and node_(20)
set tcp_(14) [new Agent/TCP/Newreno]
$tcp_(14) set class_ 2
set sink_(14) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(14)
$ns attach-agent $node_(20) $sink_(14)
$ns connect $tcp_(14) $sink_(14)
set ftp_(14) [new Application/FTP]
$ftp_(14) attach-agent $tcp_(14)
$ns at 720.2 "$ftp_(14) start"
$ns at 900.0 "$ftp_(14) stop"

#Set a TCP connection between node_(4) and node_(35)
set tcp_(15) [new Agent/TCP/Newreno]
$tcp_(15) set class_ 2
set sink_(15) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(15)
$ns attach-agent $node_(35) $sink_(15)
$ns connect $tcp_(15) $sink_(15)
set ftp_(15) [new Application/FTP]
$ftp_(15) attach-agent $tcp_(15)
$ns at 0.2 "$ftp_(15) start"
$ns at 180.0 "$ftp_(15) stop"

#Set a TCP connection between node_(15) and node_(31)
set tcp_(16) [new Agent/TCP/Newreno]
$tcp_(16) set class_ 2
set sink_(16) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(16)
$ns attach-agent $node_(31) $sink_(16)
$ns connect $tcp_(16) $sink_(16)
set ftp_(16) [new Application/FTP]
$ftp_(16) attach-agent $tcp_(16)
$ns at 180.2 "$ftp_(16) start"
$ns at 360.0 "$ftp_(16) stop"

#Set a TCP connection between node_(5) and node_(16)
set tcp_(17) [new Agent/TCP/Newreno]
$tcp_(17) set class_ 2
set sink_(17) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(17)
$ns attach-agent $node_(16) $sink_(17)
$ns connect $tcp_(17) $sink_(17)
set ftp_(17) [new Application/FTP]
$ftp_(17) attach-agent $tcp_(17)
$ns at 360.2 "$ftp_(17) start"
$ns at 540.0 "$ftp_(17) stop"

#Set a TCP connection between node_(18) and node_(44)
set tcp_(18) [new Agent/TCP/Newreno]
$tcp_(18) set class_ 2
set sink_(18) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(18)
$ns attach-agent $node_(44) $sink_(18)
$ns connect $tcp_(18) $sink_(18)
set ftp_(18) [new Application/FTP]
$ftp_(18) attach-agent $tcp_(18)
$ns at 540.2 "$ftp_(18) start"
$ns at 720.0 "$ftp_(18) stop"

#Set a TCP connection between node_(47) and node_(21)
set tcp_(19) [new Agent/TCP/Newreno]
$tcp_(19) set class_ 2
set sink_(19) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(19)
$ns attach-agent $node_(21) $sink_(19)
$ns connect $tcp_(19) $sink_(19)
set ftp_(19) [new Application/FTP]
$ftp_(19) attach-agent $tcp_(19)
$ns at 720.2 "$ftp_(19) start"
$ns at 900.0 "$ftp_(19) stop"

#Set a TCP connection between node_(3) and node_(18)
set tcp_(20) [new Agent/TCP/Newreno]
$tcp_(20) set class_ 2
set sink_(20) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(20)
$ns attach-agent $node_(18) $sink_(20)
$ns connect $tcp_(20) $sink_(20)
set ftp_(20) [new Application/FTP]
$ftp_(20) attach-agent $tcp_(20)
$ns at 0.2 "$ftp_(20) start"
$ns at 180.0 "$ftp_(20) stop"

#Set a TCP connection between node_(39) and node_(10)
set tcp_(21) [new Agent/TCP/Newreno]
$tcp_(21) set class_ 2
set sink_(21) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(21)
$ns attach-agent $node_(10) $sink_(21)
$ns connect $tcp_(21) $sink_(21)
set ftp_(21) [new Application/FTP]
$ftp_(21) attach-agent $tcp_(21)
$ns at 180.2 "$ftp_(21) start"
$ns at 360.0 "$ftp_(21) stop"

#Set a TCP connection between node_(38) and node_(23)
set tcp_(22) [new Agent/TCP/Newreno]
$tcp_(22) set class_ 2
set sink_(22) [new Agent/TCPSink]
$ns attach-agent $node_(38) $tcp_(22)
$ns attach-agent $node_(23) $sink_(22)
$ns connect $tcp_(22) $sink_(22)
set ftp_(22) [new Application/FTP]
$ftp_(22) attach-agent $tcp_(22)
$ns at 360.2 "$ftp_(22) start"
$ns at 540.0 "$ftp_(22) stop"

#Set a TCP connection between node_(29) and node_(47)
set tcp_(23) [new Agent/TCP/Newreno]
$tcp_(23) set class_ 2
set sink_(23) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(23)
$ns attach-agent $node_(47) $sink_(23)
$ns connect $tcp_(23) $sink_(23)
set ftp_(23) [new Application/FTP]
$ftp_(23) attach-agent $tcp_(23)
$ns at 540.2 "$ftp_(23) start"
$ns at 720.0 "$ftp_(23) stop"

#Set a TCP connection between node_(48) and node_(46)
set tcp_(24) [new Agent/TCP/Newreno]
$tcp_(24) set class_ 2
set sink_(24) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(24)
$ns attach-agent $node_(46) $sink_(24)
$ns connect $tcp_(24) $sink_(24)
set ftp_(24) [new Application/FTP]
$ftp_(24) attach-agent $tcp_(24)
$ns at 720.2 "$ftp_(24) start"
$ns at 900.0 "$ftp_(24) stop"

#Set a TCP connection between node_(1) and node_(7)
set tcp_(25) [new Agent/TCP/Newreno]
$tcp_(25) set class_ 2
set sink_(25) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(25)
$ns attach-agent $node_(7) $sink_(25)
$ns connect $tcp_(25) $sink_(25)
set ftp_(25) [new Application/FTP]
$ftp_(25) attach-agent $tcp_(25)
$ns at 0.2 "$ftp_(25) start"
$ns at 180.0 "$ftp_(25) stop"

#Set a TCP connection between node_(35) and node_(16)
set tcp_(26) [new Agent/TCP/Newreno]
$tcp_(26) set class_ 2
set sink_(26) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(26)
$ns attach-agent $node_(16) $sink_(26)
$ns connect $tcp_(26) $sink_(26)
set ftp_(26) [new Application/FTP]
$ftp_(26) attach-agent $tcp_(26)
$ns at 180.2 "$ftp_(26) start"
$ns at 360.0 "$ftp_(26) stop"

#Set a TCP connection between node_(43) and node_(32)
set tcp_(27) [new Agent/TCP/Newreno]
$tcp_(27) set class_ 2
set sink_(27) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(27)
$ns attach-agent $node_(32) $sink_(27)
$ns connect $tcp_(27) $sink_(27)
set ftp_(27) [new Application/FTP]
$ftp_(27) attach-agent $tcp_(27)
$ns at 360.2 "$ftp_(27) start"
$ns at 540.0 "$ftp_(27) stop"

#Set a TCP connection between node_(34) and node_(36)
set tcp_(28) [new Agent/TCP/Newreno]
$tcp_(28) set class_ 2
set sink_(28) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(28)
$ns attach-agent $node_(36) $sink_(28)
$ns connect $tcp_(28) $sink_(28)
set ftp_(28) [new Application/FTP]
$ftp_(28) attach-agent $tcp_(28)
$ns at 540.2 "$ftp_(28) start"
$ns at 720.0 "$ftp_(28) stop"

#Set a TCP connection between node_(3) and node_(39)
set tcp_(29) [new Agent/TCP/Newreno]
$tcp_(29) set class_ 2
set sink_(29) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(29)
$ns attach-agent $node_(39) $sink_(29)
$ns connect $tcp_(29) $sink_(29)
set ftp_(29) [new Application/FTP]
$ftp_(29) attach-agent $tcp_(29)
$ns at 720.2 "$ftp_(29) start"
$ns at 900.0 "$ftp_(29) stop"

#Set a TCP connection between node_(19) and node_(47)
set tcp_(30) [new Agent/TCP/Newreno]
$tcp_(30) set class_ 2
set sink_(30) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(30)
$ns attach-agent $node_(47) $sink_(30)
$ns connect $tcp_(30) $sink_(30)
set ftp_(30) [new Application/FTP]
$ftp_(30) attach-agent $tcp_(30)
$ns at 0.2 "$ftp_(30) start"
$ns at 180.0 "$ftp_(30) stop"

#Set a TCP connection between node_(20) and node_(18)
set tcp_(31) [new Agent/TCP/Newreno]
$tcp_(31) set class_ 2
set sink_(31) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(31)
$ns attach-agent $node_(18) $sink_(31)
$ns connect $tcp_(31) $sink_(31)
set ftp_(31) [new Application/FTP]
$ftp_(31) attach-agent $tcp_(31)
$ns at 180.2 "$ftp_(31) start"
$ns at 360.0 "$ftp_(31) stop"

#Set a TCP connection between node_(24) and node_(22)
set tcp_(32) [new Agent/TCP/Newreno]
$tcp_(32) set class_ 2
set sink_(32) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(32)
$ns attach-agent $node_(22) $sink_(32)
$ns connect $tcp_(32) $sink_(32)
set ftp_(32) [new Application/FTP]
$ftp_(32) attach-agent $tcp_(32)
$ns at 360.2 "$ftp_(32) start"
$ns at 540.0 "$ftp_(32) stop"

#Set a TCP connection between node_(43) and node_(0)
set tcp_(33) [new Agent/TCP/Newreno]
$tcp_(33) set class_ 2
set sink_(33) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(33)
$ns attach-agent $node_(0) $sink_(33)
$ns connect $tcp_(33) $sink_(33)
set ftp_(33) [new Application/FTP]
$ftp_(33) attach-agent $tcp_(33)
$ns at 540.2 "$ftp_(33) start"
$ns at 720.0 "$ftp_(33) stop"

#Set a TCP connection between node_(13) and node_(23)
set tcp_(34) [new Agent/TCP/Newreno]
$tcp_(34) set class_ 2
set sink_(34) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(34)
$ns attach-agent $node_(23) $sink_(34)
$ns connect $tcp_(34) $sink_(34)
set ftp_(34) [new Application/FTP]
$ftp_(34) attach-agent $tcp_(34)
$ns at 720.2 "$ftp_(34) start"
$ns at 900.0 "$ftp_(34) stop"

#Set a TCP connection between node_(7) and node_(33)
set tcp_(35) [new Agent/TCP/Newreno]
$tcp_(35) set class_ 2
set sink_(35) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(35)
$ns attach-agent $node_(33) $sink_(35)
$ns connect $tcp_(35) $sink_(35)
set ftp_(35) [new Application/FTP]
$ftp_(35) attach-agent $tcp_(35)
$ns at 0.2 "$ftp_(35) start"
$ns at 180.0 "$ftp_(35) stop"

#Set a TCP connection between node_(26) and node_(8)
set tcp_(36) [new Agent/TCP/Newreno]
$tcp_(36) set class_ 2
set sink_(36) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(36)
$ns attach-agent $node_(8) $sink_(36)
$ns connect $tcp_(36) $sink_(36)
set ftp_(36) [new Application/FTP]
$ftp_(36) attach-agent $tcp_(36)
$ns at 180.2 "$ftp_(36) start"
$ns at 360.0 "$ftp_(36) stop"

#Set a TCP connection between node_(9) and node_(33)
set tcp_(37) [new Agent/TCP/Newreno]
$tcp_(37) set class_ 2
set sink_(37) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(37)
$ns attach-agent $node_(33) $sink_(37)
$ns connect $tcp_(37) $sink_(37)
set ftp_(37) [new Application/FTP]
$ftp_(37) attach-agent $tcp_(37)
$ns at 360.2 "$ftp_(37) start"
$ns at 540.0 "$ftp_(37) stop"

#Set a TCP connection between node_(43) and node_(47)
set tcp_(38) [new Agent/TCP/Newreno]
$tcp_(38) set class_ 2
set sink_(38) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(38)
$ns attach-agent $node_(47) $sink_(38)
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

#Set a TCP connection between node_(48) and node_(15)
set tcp_(40) [new Agent/TCP/Newreno]
$tcp_(40) set class_ 2
set sink_(40) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(40)
$ns attach-agent $node_(15) $sink_(40)
$ns connect $tcp_(40) $sink_(40)
set ftp_(40) [new Application/FTP]
$ftp_(40) attach-agent $tcp_(40)
$ns at 0.2 "$ftp_(40) start"
$ns at 180.0 "$ftp_(40) stop"

#Set a TCP connection between node_(13) and node_(38)
set tcp_(41) [new Agent/TCP/Newreno]
$tcp_(41) set class_ 2
set sink_(41) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(41)
$ns attach-agent $node_(38) $sink_(41)
$ns connect $tcp_(41) $sink_(41)
set ftp_(41) [new Application/FTP]
$ftp_(41) attach-agent $tcp_(41)
$ns at 180.2 "$ftp_(41) start"
$ns at 360.0 "$ftp_(41) stop"

#Set a TCP connection between node_(2) and node_(17)
set tcp_(42) [new Agent/TCP/Newreno]
$tcp_(42) set class_ 2
set sink_(42) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(42)
$ns attach-agent $node_(17) $sink_(42)
$ns connect $tcp_(42) $sink_(42)
set ftp_(42) [new Application/FTP]
$ftp_(42) attach-agent $tcp_(42)
$ns at 360.2 "$ftp_(42) start"
$ns at 540.0 "$ftp_(42) stop"

#Set a TCP connection between node_(2) and node_(46)
set tcp_(43) [new Agent/TCP/Newreno]
$tcp_(43) set class_ 2
set sink_(43) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(43)
$ns attach-agent $node_(46) $sink_(43)
$ns connect $tcp_(43) $sink_(43)
set ftp_(43) [new Application/FTP]
$ftp_(43) attach-agent $tcp_(43)
$ns at 540.2 "$ftp_(43) start"
$ns at 720.0 "$ftp_(43) stop"

#Set a TCP connection between node_(40) and node_(34)
set tcp_(44) [new Agent/TCP/Newreno]
$tcp_(44) set class_ 2
set sink_(44) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(44)
$ns attach-agent $node_(34) $sink_(44)
$ns connect $tcp_(44) $sink_(44)
set ftp_(44) [new Application/FTP]
$ftp_(44) attach-agent $tcp_(44)
$ns at 720.2 "$ftp_(44) start"
$ns at 900.0 "$ftp_(44) stop"

#Set a TCP connection between node_(17) and node_(15)
set tcp_(45) [new Agent/TCP/Newreno]
$tcp_(45) set class_ 2
set sink_(45) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(45)
$ns attach-agent $node_(15) $sink_(45)
$ns connect $tcp_(45) $sink_(45)
set ftp_(45) [new Application/FTP]
$ftp_(45) attach-agent $tcp_(45)
$ns at 0.2 "$ftp_(45) start"
$ns at 180.0 "$ftp_(45) stop"

#Set a TCP connection between node_(1) and node_(39)
set tcp_(46) [new Agent/TCP/Newreno]
$tcp_(46) set class_ 2
set sink_(46) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(46)
$ns attach-agent $node_(39) $sink_(46)
$ns connect $tcp_(46) $sink_(46)
set ftp_(46) [new Application/FTP]
$ftp_(46) attach-agent $tcp_(46)
$ns at 180.2 "$ftp_(46) start"
$ns at 360.0 "$ftp_(46) stop"

#Set a TCP connection between node_(10) and node_(20)
set tcp_(47) [new Agent/TCP/Newreno]
$tcp_(47) set class_ 2
set sink_(47) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(47)
$ns attach-agent $node_(20) $sink_(47)
$ns connect $tcp_(47) $sink_(47)
set ftp_(47) [new Application/FTP]
$ftp_(47) attach-agent $tcp_(47)
$ns at 360.2 "$ftp_(47) start"
$ns at 540.0 "$ftp_(47) stop"

#Set a TCP connection between node_(4) and node_(26)
set tcp_(48) [new Agent/TCP/Newreno]
$tcp_(48) set class_ 2
set sink_(48) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(48)
$ns attach-agent $node_(26) $sink_(48)
$ns connect $tcp_(48) $sink_(48)
set ftp_(48) [new Application/FTP]
$ftp_(48) attach-agent $tcp_(48)
$ns at 540.2 "$ftp_(48) start"
$ns at 720.0 "$ftp_(48) stop"

#Set a TCP connection between node_(42) and node_(8)
set tcp_(49) [new Agent/TCP/Newreno]
$tcp_(49) set class_ 2
set sink_(49) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(49)
$ns attach-agent $node_(8) $sink_(49)
$ns connect $tcp_(49) $sink_(49)
set ftp_(49) [new Application/FTP]
$ftp_(49) attach-agent $tcp_(49)
$ns at 720.2 "$ftp_(49) start"
$ns at 900.0 "$ftp_(49) stop"

#Set a TCP connection between node_(22) and node_(15)
set tcp_(50) [new Agent/TCP/Newreno]
$tcp_(50) set class_ 2
set sink_(50) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(50)
$ns attach-agent $node_(15) $sink_(50)
$ns connect $tcp_(50) $sink_(50)
set ftp_(50) [new Application/FTP]
$ftp_(50) attach-agent $tcp_(50)
$ns at 0.2 "$ftp_(50) start"
$ns at 180.0 "$ftp_(50) stop"

#Set a TCP connection between node_(18) and node_(3)
set tcp_(51) [new Agent/TCP/Newreno]
$tcp_(51) set class_ 2
set sink_(51) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(51)
$ns attach-agent $node_(3) $sink_(51)
$ns connect $tcp_(51) $sink_(51)
set ftp_(51) [new Application/FTP]
$ftp_(51) attach-agent $tcp_(51)
$ns at 180.2 "$ftp_(51) start"
$ns at 360.0 "$ftp_(51) stop"

#Set a TCP connection between node_(6) and node_(18)
set tcp_(52) [new Agent/TCP/Newreno]
$tcp_(52) set class_ 2
set sink_(52) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(52)
$ns attach-agent $node_(18) $sink_(52)
$ns connect $tcp_(52) $sink_(52)
set ftp_(52) [new Application/FTP]
$ftp_(52) attach-agent $tcp_(52)
$ns at 360.2 "$ftp_(52) start"
$ns at 540.0 "$ftp_(52) stop"

#Set a TCP connection between node_(8) and node_(24)
set tcp_(53) [new Agent/TCP/Newreno]
$tcp_(53) set class_ 2
set sink_(53) [new Agent/TCPSink]
$ns attach-agent $node_(8) $tcp_(53)
$ns attach-agent $node_(24) $sink_(53)
$ns connect $tcp_(53) $sink_(53)
set ftp_(53) [new Application/FTP]
$ftp_(53) attach-agent $tcp_(53)
$ns at 540.2 "$ftp_(53) start"
$ns at 720.0 "$ftp_(53) stop"

#Set a TCP connection between node_(16) and node_(44)
set tcp_(54) [new Agent/TCP/Newreno]
$tcp_(54) set class_ 2
set sink_(54) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(54)
$ns attach-agent $node_(44) $sink_(54)
$ns connect $tcp_(54) $sink_(54)
set ftp_(54) [new Application/FTP]
$ftp_(54) attach-agent $tcp_(54)
$ns at 720.2 "$ftp_(54) start"
$ns at 900.0 "$ftp_(54) stop"

#Set a TCP connection between node_(6) and node_(34)
set tcp_(55) [new Agent/TCP/Newreno]
$tcp_(55) set class_ 2
set sink_(55) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(55)
$ns attach-agent $node_(34) $sink_(55)
$ns connect $tcp_(55) $sink_(55)
set ftp_(55) [new Application/FTP]
$ftp_(55) attach-agent $tcp_(55)
$ns at 0.2 "$ftp_(55) start"
$ns at 180.0 "$ftp_(55) stop"

#Set a TCP connection between node_(1) and node_(14)
set tcp_(56) [new Agent/TCP/Newreno]
$tcp_(56) set class_ 2
set sink_(56) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(56)
$ns attach-agent $node_(14) $sink_(56)
$ns connect $tcp_(56) $sink_(56)
set ftp_(56) [new Application/FTP]
$ftp_(56) attach-agent $tcp_(56)
$ns at 180.2 "$ftp_(56) start"
$ns at 360.0 "$ftp_(56) stop"

#Set a TCP connection between node_(28) and node_(44)
set tcp_(57) [new Agent/TCP/Newreno]
$tcp_(57) set class_ 2
set sink_(57) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(57)
$ns attach-agent $node_(44) $sink_(57)
$ns connect $tcp_(57) $sink_(57)
set ftp_(57) [new Application/FTP]
$ftp_(57) attach-agent $tcp_(57)
$ns at 360.2 "$ftp_(57) start"
$ns at 540.0 "$ftp_(57) stop"

#Set a TCP connection between node_(42) and node_(16)
set tcp_(58) [new Agent/TCP/Newreno]
$tcp_(58) set class_ 2
set sink_(58) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(58)
$ns attach-agent $node_(16) $sink_(58)
$ns connect $tcp_(58) $sink_(58)
set ftp_(58) [new Application/FTP]
$ftp_(58) attach-agent $tcp_(58)
$ns at 540.2 "$ftp_(58) start"
$ns at 720.0 "$ftp_(58) stop"

#Set a TCP connection between node_(10) and node_(25)
set tcp_(59) [new Agent/TCP/Newreno]
$tcp_(59) set class_ 2
set sink_(59) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(59)
$ns attach-agent $node_(25) $sink_(59)
$ns connect $tcp_(59) $sink_(59)
set ftp_(59) [new Application/FTP]
$ftp_(59) attach-agent $tcp_(59)
$ns at 720.2 "$ftp_(59) start"
$ns at 900.0 "$ftp_(59) stop"

#Set a TCP connection between node_(6) and node_(38)
set tcp_(60) [new Agent/TCP/Newreno]
$tcp_(60) set class_ 2
set sink_(60) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(60)
$ns attach-agent $node_(38) $sink_(60)
$ns connect $tcp_(60) $sink_(60)
set ftp_(60) [new Application/FTP]
$ftp_(60) attach-agent $tcp_(60)
$ns at 0.2 "$ftp_(60) start"
$ns at 180.0 "$ftp_(60) stop"

#Set a TCP connection between node_(28) and node_(19)
set tcp_(61) [new Agent/TCP/Newreno]
$tcp_(61) set class_ 2
set sink_(61) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(61)
$ns attach-agent $node_(19) $sink_(61)
$ns connect $tcp_(61) $sink_(61)
set ftp_(61) [new Application/FTP]
$ftp_(61) attach-agent $tcp_(61)
$ns at 180.2 "$ftp_(61) start"
$ns at 360.0 "$ftp_(61) stop"

#Set a TCP connection between node_(48) and node_(36)
set tcp_(62) [new Agent/TCP/Newreno]
$tcp_(62) set class_ 2
set sink_(62) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(62)
$ns attach-agent $node_(36) $sink_(62)
$ns connect $tcp_(62) $sink_(62)
set ftp_(62) [new Application/FTP]
$ftp_(62) attach-agent $tcp_(62)
$ns at 360.2 "$ftp_(62) start"
$ns at 540.0 "$ftp_(62) stop"

#Set a TCP connection between node_(1) and node_(18)
set tcp_(63) [new Agent/TCP/Newreno]
$tcp_(63) set class_ 2
set sink_(63) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(63)
$ns attach-agent $node_(18) $sink_(63)
$ns connect $tcp_(63) $sink_(63)
set ftp_(63) [new Application/FTP]
$ftp_(63) attach-agent $tcp_(63)
$ns at 540.2 "$ftp_(63) start"
$ns at 720.0 "$ftp_(63) stop"

#Set a TCP connection between node_(29) and node_(14)
set tcp_(64) [new Agent/TCP/Newreno]
$tcp_(64) set class_ 2
set sink_(64) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(64)
$ns attach-agent $node_(14) $sink_(64)
$ns connect $tcp_(64) $sink_(64)
set ftp_(64) [new Application/FTP]
$ftp_(64) attach-agent $tcp_(64)
$ns at 720.2 "$ftp_(64) start"
$ns at 900.0 "$ftp_(64) stop"

#Set a TCP connection between node_(40) and node_(13)
set tcp_(65) [new Agent/TCP/Newreno]
$tcp_(65) set class_ 2
set sink_(65) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(65)
$ns attach-agent $node_(13) $sink_(65)
$ns connect $tcp_(65) $sink_(65)
set ftp_(65) [new Application/FTP]
$ftp_(65) attach-agent $tcp_(65)
$ns at 0.2 "$ftp_(65) start"
$ns at 180.0 "$ftp_(65) stop"

#Set a TCP connection between node_(24) and node_(8)
set tcp_(66) [new Agent/TCP/Newreno]
$tcp_(66) set class_ 2
set sink_(66) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(66)
$ns attach-agent $node_(8) $sink_(66)
$ns connect $tcp_(66) $sink_(66)
set ftp_(66) [new Application/FTP]
$ftp_(66) attach-agent $tcp_(66)
$ns at 180.2 "$ftp_(66) start"
$ns at 360.0 "$ftp_(66) stop"

#Set a TCP connection between node_(23) and node_(14)
set tcp_(67) [new Agent/TCP/Newreno]
$tcp_(67) set class_ 2
set sink_(67) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(67)
$ns attach-agent $node_(14) $sink_(67)
$ns connect $tcp_(67) $sink_(67)
set ftp_(67) [new Application/FTP]
$ftp_(67) attach-agent $tcp_(67)
$ns at 360.2 "$ftp_(67) start"
$ns at 540.0 "$ftp_(67) stop"

#Set a TCP connection between node_(16) and node_(6)
set tcp_(68) [new Agent/TCP/Newreno]
$tcp_(68) set class_ 2
set sink_(68) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(68)
$ns attach-agent $node_(6) $sink_(68)
$ns connect $tcp_(68) $sink_(68)
set ftp_(68) [new Application/FTP]
$ftp_(68) attach-agent $tcp_(68)
$ns at 540.2 "$ftp_(68) start"
$ns at 720.0 "$ftp_(68) stop"

#Set a TCP connection between node_(4) and node_(49)
set tcp_(69) [new Agent/TCP/Newreno]
$tcp_(69) set class_ 2
set sink_(69) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(69)
$ns attach-agent $node_(49) $sink_(69)
$ns connect $tcp_(69) $sink_(69)
set ftp_(69) [new Application/FTP]
$ftp_(69) attach-agent $tcp_(69)
$ns at 720.2 "$ftp_(69) start"
$ns at 900.0 "$ftp_(69) stop"

#Set a TCP connection between node_(22) and node_(1)
set tcp_(70) [new Agent/TCP/Newreno]
$tcp_(70) set class_ 2
set sink_(70) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(70)
$ns attach-agent $node_(1) $sink_(70)
$ns connect $tcp_(70) $sink_(70)
set ftp_(70) [new Application/FTP]
$ftp_(70) attach-agent $tcp_(70)
$ns at 0.2 "$ftp_(70) start"
$ns at 180.0 "$ftp_(70) stop"

#Set a TCP connection between node_(25) and node_(39)
set tcp_(71) [new Agent/TCP/Newreno]
$tcp_(71) set class_ 2
set sink_(71) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(71)
$ns attach-agent $node_(39) $sink_(71)
$ns connect $tcp_(71) $sink_(71)
set ftp_(71) [new Application/FTP]
$ftp_(71) attach-agent $tcp_(71)
$ns at 180.2 "$ftp_(71) start"
$ns at 360.0 "$ftp_(71) stop"

#Set a TCP connection between node_(21) and node_(14)
set tcp_(72) [new Agent/TCP/Newreno]
$tcp_(72) set class_ 2
set sink_(72) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(72)
$ns attach-agent $node_(14) $sink_(72)
$ns connect $tcp_(72) $sink_(72)
set ftp_(72) [new Application/FTP]
$ftp_(72) attach-agent $tcp_(72)
$ns at 360.2 "$ftp_(72) start"
$ns at 540.0 "$ftp_(72) stop"

#Set a TCP connection between node_(19) and node_(5)
set tcp_(73) [new Agent/TCP/Newreno]
$tcp_(73) set class_ 2
set sink_(73) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(73)
$ns attach-agent $node_(5) $sink_(73)
$ns connect $tcp_(73) $sink_(73)
set ftp_(73) [new Application/FTP]
$ftp_(73) attach-agent $tcp_(73)
$ns at 540.2 "$ftp_(73) start"
$ns at 720.0 "$ftp_(73) stop"

#Set a TCP connection between node_(12) and node_(8)
set tcp_(74) [new Agent/TCP/Newreno]
$tcp_(74) set class_ 2
set sink_(74) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(74)
$ns attach-agent $node_(8) $sink_(74)
$ns connect $tcp_(74) $sink_(74)
set ftp_(74) [new Application/FTP]
$ftp_(74) attach-agent $tcp_(74)
$ns at 720.2 "$ftp_(74) start"
$ns at 900.0 "$ftp_(74) stop"

#Set a TCP connection between node_(38) and node_(40)
set tcp_(75) [new Agent/TCP/Newreno]
$tcp_(75) set class_ 2
set sink_(75) [new Agent/TCPSink]
$ns attach-agent $node_(38) $tcp_(75)
$ns attach-agent $node_(40) $sink_(75)
$ns connect $tcp_(75) $sink_(75)
set ftp_(75) [new Application/FTP]
$ftp_(75) attach-agent $tcp_(75)
$ns at 0.2 "$ftp_(75) start"
$ns at 180.0 "$ftp_(75) stop"

#Set a TCP connection between node_(24) and node_(27)
set tcp_(76) [new Agent/TCP/Newreno]
$tcp_(76) set class_ 2
set sink_(76) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(76)
$ns attach-agent $node_(27) $sink_(76)
$ns connect $tcp_(76) $sink_(76)
set ftp_(76) [new Application/FTP]
$ftp_(76) attach-agent $tcp_(76)
$ns at 180.2 "$ftp_(76) start"
$ns at 360.0 "$ftp_(76) stop"

#Set a TCP connection between node_(47) and node_(21)
set tcp_(77) [new Agent/TCP/Newreno]
$tcp_(77) set class_ 2
set sink_(77) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(77)
$ns attach-agent $node_(21) $sink_(77)
$ns connect $tcp_(77) $sink_(77)
set ftp_(77) [new Application/FTP]
$ftp_(77) attach-agent $tcp_(77)
$ns at 360.2 "$ftp_(77) start"
$ns at 540.0 "$ftp_(77) stop"

#Set a TCP connection between node_(12) and node_(33)
set tcp_(78) [new Agent/TCP/Newreno]
$tcp_(78) set class_ 2
set sink_(78) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(78)
$ns attach-agent $node_(33) $sink_(78)
$ns connect $tcp_(78) $sink_(78)
set ftp_(78) [new Application/FTP]
$ftp_(78) attach-agent $tcp_(78)
$ns at 540.2 "$ftp_(78) start"
$ns at 720.0 "$ftp_(78) stop"

#Set a TCP connection between node_(0) and node_(49)
set tcp_(79) [new Agent/TCP/Newreno]
$tcp_(79) set class_ 2
set sink_(79) [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp_(79)
$ns attach-agent $node_(49) $sink_(79)
$ns connect $tcp_(79) $sink_(79)
set ftp_(79) [new Application/FTP]
$ftp_(79) attach-agent $tcp_(79)
$ns at 720.2 "$ftp_(79) start"
$ns at 900.0 "$ftp_(79) stop"

#Set a TCP connection between node_(3) and node_(36)
set tcp_(80) [new Agent/TCP/Newreno]
$tcp_(80) set class_ 2
set sink_(80) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(80)
$ns attach-agent $node_(36) $sink_(80)
$ns connect $tcp_(80) $sink_(80)
set ftp_(80) [new Application/FTP]
$ftp_(80) attach-agent $tcp_(80)
$ns at 0.2 "$ftp_(80) start"
$ns at 180.0 "$ftp_(80) stop"

#Set a TCP connection between node_(29) and node_(8)
set tcp_(81) [new Agent/TCP/Newreno]
$tcp_(81) set class_ 2
set sink_(81) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(81)
$ns attach-agent $node_(8) $sink_(81)
$ns connect $tcp_(81) $sink_(81)
set ftp_(81) [new Application/FTP]
$ftp_(81) attach-agent $tcp_(81)
$ns at 180.2 "$ftp_(81) start"
$ns at 360.0 "$ftp_(81) stop"

#Set a TCP connection between node_(5) and node_(0)
set tcp_(82) [new Agent/TCP/Newreno]
$tcp_(82) set class_ 2
set sink_(82) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(82)
$ns attach-agent $node_(0) $sink_(82)
$ns connect $tcp_(82) $sink_(82)
set ftp_(82) [new Application/FTP]
$ftp_(82) attach-agent $tcp_(82)
$ns at 360.2 "$ftp_(82) start"
$ns at 540.0 "$ftp_(82) stop"

#Set a TCP connection between node_(0) and node_(35)
set tcp_(83) [new Agent/TCP/Newreno]
$tcp_(83) set class_ 2
set sink_(83) [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp_(83)
$ns attach-agent $node_(35) $sink_(83)
$ns connect $tcp_(83) $sink_(83)
set ftp_(83) [new Application/FTP]
$ftp_(83) attach-agent $tcp_(83)
$ns at 540.2 "$ftp_(83) start"
$ns at 720.0 "$ftp_(83) stop"

#Set a TCP connection between node_(6) and node_(48)
set tcp_(84) [new Agent/TCP/Newreno]
$tcp_(84) set class_ 2
set sink_(84) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(84)
$ns attach-agent $node_(48) $sink_(84)
$ns connect $tcp_(84) $sink_(84)
set ftp_(84) [new Application/FTP]
$ftp_(84) attach-agent $tcp_(84)
$ns at 720.2 "$ftp_(84) start"
$ns at 900.0 "$ftp_(84) stop"

#Set a TCP connection between node_(39) and node_(43)
set tcp_(85) [new Agent/TCP/Newreno]
$tcp_(85) set class_ 2
set sink_(85) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(85)
$ns attach-agent $node_(43) $sink_(85)
$ns connect $tcp_(85) $sink_(85)
set ftp_(85) [new Application/FTP]
$ftp_(85) attach-agent $tcp_(85)
$ns at 0.2 "$ftp_(85) start"
$ns at 180.0 "$ftp_(85) stop"

#Set a TCP connection between node_(18) and node_(42)
set tcp_(86) [new Agent/TCP/Newreno]
$tcp_(86) set class_ 2
set sink_(86) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(86)
$ns attach-agent $node_(42) $sink_(86)
$ns connect $tcp_(86) $sink_(86)
set ftp_(86) [new Application/FTP]
$ftp_(86) attach-agent $tcp_(86)
$ns at 180.2 "$ftp_(86) start"
$ns at 360.0 "$ftp_(86) stop"

#Set a TCP connection between node_(34) and node_(10)
set tcp_(87) [new Agent/TCP/Newreno]
$tcp_(87) set class_ 2
set sink_(87) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(87)
$ns attach-agent $node_(10) $sink_(87)
$ns connect $tcp_(87) $sink_(87)
set ftp_(87) [new Application/FTP]
$ftp_(87) attach-agent $tcp_(87)
$ns at 360.2 "$ftp_(87) start"
$ns at 540.0 "$ftp_(87) stop"

#Set a TCP connection between node_(24) and node_(39)
set tcp_(88) [new Agent/TCP/Newreno]
$tcp_(88) set class_ 2
set sink_(88) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(88)
$ns attach-agent $node_(39) $sink_(88)
$ns connect $tcp_(88) $sink_(88)
set ftp_(88) [new Application/FTP]
$ftp_(88) attach-agent $tcp_(88)
$ns at 540.2 "$ftp_(88) start"
$ns at 720.0 "$ftp_(88) stop"

#Set a TCP connection between node_(3) and node_(19)
set tcp_(89) [new Agent/TCP/Newreno]
$tcp_(89) set class_ 2
set sink_(89) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(89)
$ns attach-agent $node_(19) $sink_(89)
$ns connect $tcp_(89) $sink_(89)
set ftp_(89) [new Application/FTP]
$ftp_(89) attach-agent $tcp_(89)
$ns at 720.2 "$ftp_(89) start"
$ns at 900.0 "$ftp_(89) stop"

#Set a TCP connection between node_(42) and node_(9)
set tcp_(90) [new Agent/TCP/Newreno]
$tcp_(90) set class_ 2
set sink_(90) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(90)
$ns attach-agent $node_(9) $sink_(90)
$ns connect $tcp_(90) $sink_(90)
set ftp_(90) [new Application/FTP]
$ftp_(90) attach-agent $tcp_(90)
$ns at 0.2 "$ftp_(90) start"
$ns at 180.0 "$ftp_(90) stop"

#Set a TCP connection between node_(34) and node_(24)
set tcp_(91) [new Agent/TCP/Newreno]
$tcp_(91) set class_ 2
set sink_(91) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(91)
$ns attach-agent $node_(24) $sink_(91)
$ns connect $tcp_(91) $sink_(91)
set ftp_(91) [new Application/FTP]
$ftp_(91) attach-agent $tcp_(91)
$ns at 180.2 "$ftp_(91) start"
$ns at 360.0 "$ftp_(91) stop"

#Set a TCP connection between node_(5) and node_(46)
set tcp_(92) [new Agent/TCP/Newreno]
$tcp_(92) set class_ 2
set sink_(92) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(92)
$ns attach-agent $node_(46) $sink_(92)
$ns connect $tcp_(92) $sink_(92)
set ftp_(92) [new Application/FTP]
$ftp_(92) attach-agent $tcp_(92)
$ns at 360.2 "$ftp_(92) start"
$ns at 540.0 "$ftp_(92) stop"

#Set a TCP connection between node_(10) and node_(8)
set tcp_(93) [new Agent/TCP/Newreno]
$tcp_(93) set class_ 2
set sink_(93) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(93)
$ns attach-agent $node_(8) $sink_(93)
$ns connect $tcp_(93) $sink_(93)
set ftp_(93) [new Application/FTP]
$ftp_(93) attach-agent $tcp_(93)
$ns at 540.2 "$ftp_(93) start"
$ns at 720.0 "$ftp_(93) stop"

#Set a TCP connection between node_(1) and node_(0)
set tcp_(94) [new Agent/TCP/Newreno]
$tcp_(94) set class_ 2
set sink_(94) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(94)
$ns attach-agent $node_(0) $sink_(94)
$ns connect $tcp_(94) $sink_(94)
set ftp_(94) [new Application/FTP]
$ftp_(94) attach-agent $tcp_(94)
$ns at 720.2 "$ftp_(94) start"
$ns at 900.0 "$ftp_(94) stop"

#Set a TCP connection between node_(0) and node_(15)
set tcp_(95) [new Agent/TCP/Newreno]
$tcp_(95) set class_ 2
set sink_(95) [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp_(95)
$ns attach-agent $node_(15) $sink_(95)
$ns connect $tcp_(95) $sink_(95)
set ftp_(95) [new Application/FTP]
$ftp_(95) attach-agent $tcp_(95)
$ns at 0.2 "$ftp_(95) start"
$ns at 180.0 "$ftp_(95) stop"

#Set a TCP connection between node_(32) and node_(21)
set tcp_(96) [new Agent/TCP/Newreno]
$tcp_(96) set class_ 2
set sink_(96) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(96)
$ns attach-agent $node_(21) $sink_(96)
$ns connect $tcp_(96) $sink_(96)
set ftp_(96) [new Application/FTP]
$ftp_(96) attach-agent $tcp_(96)
$ns at 180.2 "$ftp_(96) start"
$ns at 360.0 "$ftp_(96) stop"

#Set a TCP connection between node_(16) and node_(25)
set tcp_(97) [new Agent/TCP/Newreno]
$tcp_(97) set class_ 2
set sink_(97) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(97)
$ns attach-agent $node_(25) $sink_(97)
$ns connect $tcp_(97) $sink_(97)
set ftp_(97) [new Application/FTP]
$ftp_(97) attach-agent $tcp_(97)
$ns at 360.2 "$ftp_(97) start"
$ns at 540.0 "$ftp_(97) stop"

#Set a TCP connection between node_(32) and node_(6)
set tcp_(98) [new Agent/TCP/Newreno]
$tcp_(98) set class_ 2
set sink_(98) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(98)
$ns attach-agent $node_(6) $sink_(98)
$ns connect $tcp_(98) $sink_(98)
set ftp_(98) [new Application/FTP]
$ftp_(98) attach-agent $tcp_(98)
$ns at 540.2 "$ftp_(98) start"
$ns at 720.0 "$ftp_(98) stop"

#Set a TCP connection between node_(26) and node_(36)
set tcp_(99) [new Agent/TCP/Newreno]
$tcp_(99) set class_ 2
set sink_(99) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(99)
$ns attach-agent $node_(36) $sink_(99)
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
