#sim-scn2-1.tcl 
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
set tracefd       [open sim-scn2-1-$val(rp)-trace.tr w]
set windowVsTime2 [open sim-scn2-1-$val(rp)-win-.tr w]
set namtrace      [open sim-scn2-1-$val(rp).nam w]

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
$node_(0) set X_ 2932 
$node_(0) set Y_ 894 
$node_(0) set Z_ 0.0 
$node_(1) set X_ 2781 
$node_(1) set Y_ 624 
$node_(1) set Z_ 0.0 
$node_(2) set X_ 1009 
$node_(2) set Y_ 903 
$node_(2) set Z_ 0.0 
$node_(3) set X_ 1352 
$node_(3) set Y_ 931 
$node_(3) set Z_ 0.0 
$node_(4) set X_ 1008 
$node_(4) set Y_ 517 
$node_(4) set Z_ 0.0 
$node_(5) set X_ 1084 
$node_(5) set Y_ 663 
$node_(5) set Z_ 0.0 
$node_(6) set X_ 1394 
$node_(6) set Y_ 404 
$node_(6) set Z_ 0.0 
$node_(7) set X_ 645 
$node_(7) set Y_ 585 
$node_(7) set Z_ 0.0 
$node_(8) set X_ 2750 
$node_(8) set Y_ 400 
$node_(8) set Z_ 0.0 
$node_(9) set X_ 2170 
$node_(9) set Y_ 965 
$node_(9) set Z_ 0.0 
$node_(10) set X_ 617 
$node_(10) set Y_ 181 
$node_(10) set Z_ 0.0 
$node_(11) set X_ 2942 
$node_(11) set Y_ 175 
$node_(11) set Z_ 0.0 
$node_(12) set X_ 2312 
$node_(12) set Y_ 762 
$node_(12) set Z_ 0.0 
$node_(13) set X_ 2184 
$node_(13) set Y_ 599 
$node_(13) set Z_ 0.0 
$node_(14) set X_ 1777 
$node_(14) set Y_ 38 
$node_(14) set Z_ 0.0 
$node_(15) set X_ 1507 
$node_(15) set Y_ 341 
$node_(15) set Z_ 0.0 
$node_(16) set X_ 847 
$node_(16) set Y_ 10 
$node_(16) set Z_ 0.0 
$node_(17) set X_ 553 
$node_(17) set Y_ 6 
$node_(17) set Z_ 0.0 
$node_(18) set X_ 757 
$node_(18) set Y_ 652 
$node_(18) set Z_ 0.0 
$node_(19) set X_ 868 
$node_(19) set Y_ 919 
$node_(19) set Z_ 0.0 
$node_(20) set X_ 981 
$node_(20) set Y_ 592 
$node_(20) set Z_ 0.0 
$node_(21) set X_ 953 
$node_(21) set Y_ 738 
$node_(21) set Z_ 0.0 
$node_(22) set X_ 1854 
$node_(22) set Y_ 924 
$node_(22) set Z_ 0.0 
$node_(23) set X_ 1891 
$node_(23) set Y_ 364 
$node_(23) set Z_ 0.0 
$node_(24) set X_ 1662 
$node_(24) set Y_ 493 
$node_(24) set Z_ 0.0 
$node_(25) set X_ 1788 
$node_(25) set Y_ 408 
$node_(25) set Z_ 0.0 
$node_(26) set X_ 2141 
$node_(26) set Y_ 937 
$node_(26) set Z_ 0.0 
$node_(27) set X_ 669 
$node_(27) set Y_ 253 
$node_(27) set Z_ 0.0 
$node_(28) set X_ 1538 
$node_(28) set Y_ 627 
$node_(28) set Z_ 0.0 
$node_(29) set X_ 225 
$node_(29) set Y_ 920 
$node_(29) set Z_ 0.0 
$node_(30) set X_ 2559 
$node_(30) set Y_ 393 
$node_(30) set Z_ 0.0 
$node_(31) set X_ 164 
$node_(31) set Y_ 549 
$node_(31) set Z_ 0.0 
$node_(32) set X_ 1693 
$node_(32) set Y_ 594 
$node_(32) set Z_ 0.0 
$node_(33) set X_ 1610 
$node_(33) set Y_ 255 
$node_(33) set Z_ 0.0 
$node_(34) set X_ 2478 
$node_(34) set Y_ 639 
$node_(34) set Z_ 0.0 
$node_(35) set X_ 1278 
$node_(35) set Y_ 560 
$node_(35) set Z_ 0.0 
$node_(36) set X_ 2411 
$node_(36) set Y_ 566 
$node_(36) set Z_ 0.0 
$node_(37) set X_ 2806 
$node_(37) set Y_ 381 
$node_(37) set Z_ 0.0 
$node_(38) set X_ 1228 
$node_(38) set Y_ 644 
$node_(38) set Z_ 0.0 
$node_(39) set X_ 797 
$node_(39) set Y_ 751 
$node_(39) set Z_ 0.0 
$node_(40) set X_ 1290 
$node_(40) set Y_ 261 
$node_(40) set Z_ 0.0 
$node_(41) set X_ 2781 
$node_(41) set Y_ 91 
$node_(41) set Z_ 0.0 
$node_(42) set X_ 850 
$node_(42) set Y_ 543 
$node_(42) set Z_ 0.0 
$node_(43) set X_ 373 
$node_(43) set Y_ 855 
$node_(43) set Z_ 0.0 
$node_(44) set X_ 869 
$node_(44) set Y_ 269 
$node_(44) set Z_ 0.0 
$node_(45) set X_ 1485 
$node_(45) set Y_ 797 
$node_(45) set Z_ 0.0 
$node_(46) set X_ 2052 
$node_(46) set Y_ 612 
$node_(46) set Z_ 0.0 
$node_(47) set X_ 1507 
$node_(47) set Y_ 946 
$node_(47) set Z_ 0.0 
$node_(48) set X_ 1605 
$node_(48) set Y_ 204 
$node_(48) set Z_ 0.0 
$node_(49) set X_ 2840 
$node_(49) set Y_ 611 
$node_(49) set Z_ 0.0 
$node_(50) set X_ 1126 
$node_(50) set Y_ 778 
$node_(50) set Z_ 0.0 
$node_(51) set X_ 1184 
$node_(51) set Y_ 398 
$node_(51) set Z_ 0.0 
$ns at 0.0 "$node_(51) off" 
$ns at 165.0 "$node_(51) on" 
$node_(52) set X_ 1853 
$node_(52) set Y_ 420 
$node_(52) set Z_ 0.0 
$ns at 0.0 "$node_(52) off" 
$ns at 165.0 "$node_(52) on" 
$node_(53) set X_ 2390 
$node_(53) set Y_ 236 
$node_(53) set Z_ 0.0 
$ns at 0.0 "$node_(53) off" 
$ns at 165.0 "$node_(53) on" 
$node_(54) set X_ 2317 
$node_(54) set Y_ 46 
$node_(54) set Z_ 0.0 
$ns at 0.0 "$node_(54) off" 
$ns at 165.0 "$node_(54) on" 
$node_(55) set X_ 619 
$node_(55) set Y_ 919 
$node_(55) set Z_ 0.0 
$ns at 0.0 "$node_(55) off" 
$ns at 165.0 "$node_(55) on" 
$node_(56) set X_ 190 
$node_(56) set Y_ 291 
$node_(56) set Z_ 0.0 
$ns at 0.0 "$node_(56) off" 
$ns at 165.0 "$node_(56) on" 
$node_(57) set X_ 933 
$node_(57) set Y_ 487 
$node_(57) set Z_ 0.0 
$ns at 0.0 "$node_(57) off" 
$ns at 165.0 "$node_(57) on" 
$node_(58) set X_ 894 
$node_(58) set Y_ 431 
$node_(58) set Z_ 0.0 
$ns at 0.0 "$node_(58) off" 
$ns at 165.0 "$node_(58) on" 
$node_(59) set X_ 1280 
$node_(59) set Y_ 72 
$node_(59) set Z_ 0.0 
$ns at 0.0 "$node_(59) off" 
$ns at 165.0 "$node_(59) on" 
$node_(60) set X_ 2222 
$node_(60) set Y_ 277 
$node_(60) set Z_ 0.0 
$ns at 0.0 "$node_(60) off" 
$ns at 165.0 "$node_(60) on" 
$node_(61) set X_ 2175 
$node_(61) set Y_ 489 
$node_(61) set Z_ 0.0 
$ns at 0.0 "$node_(61) off" 
$ns at 165.0 "$node_(61) on" 
$node_(62) set X_ 911 
$node_(62) set Y_ 288 
$node_(62) set Z_ 0.0 
$ns at 0.0 "$node_(62) off" 
$ns at 165.0 "$node_(62) on" 
$node_(63) set X_ 2136 
$node_(63) set Y_ 965 
$node_(63) set Z_ 0.0 
$ns at 0.0 "$node_(63) off" 
$ns at 165.0 "$node_(63) on" 
$node_(64) set X_ 1749 
$node_(64) set Y_ 274 
$node_(64) set Z_ 0.0 
$ns at 0.0 "$node_(64) off" 
$ns at 165.0 "$node_(64) on" 
$node_(65) set X_ 1237 
$node_(65) set Y_ 841 
$node_(65) set Z_ 0.0 
$ns at 0.0 "$node_(65) off" 
$ns at 165.0 "$node_(65) on" 
$node_(66) set X_ 421 
$node_(66) set Y_ 123 
$node_(66) set Z_ 0.0 
$ns at 0.0 "$node_(66) off" 
$ns at 165.0 "$node_(66) on" 
$node_(67) set X_ 804 
$node_(67) set Y_ 36 
$node_(67) set Z_ 0.0 
$ns at 0.0 "$node_(67) off" 
$ns at 165.0 "$node_(67) on" 
$node_(68) set X_ 2887 
$node_(68) set Y_ 994 
$node_(68) set Z_ 0.0 
$ns at 0.0 "$node_(68) off" 
$ns at 165.0 "$node_(68) on" 
$node_(69) set X_ 1551 
$node_(69) set Y_ 311 
$node_(69) set Z_ 0.0 
$ns at 0.0 "$node_(69) off" 
$ns at 165.0 "$node_(69) on" 
$node_(70) set X_ 614 
$node_(70) set Y_ 269 
$node_(70) set Z_ 0.0 
$ns at 0.0 "$node_(70) off" 
$ns at 165.0 "$node_(70) on" 
$node_(71) set X_ 2029 
$node_(71) set Y_ 110 
$node_(71) set Z_ 0.0 
$ns at 0.0 "$node_(71) off" 
$ns at 165.0 "$node_(71) on" 
$node_(72) set X_ 546 
$node_(72) set Y_ 340 
$node_(72) set Z_ 0.0 
$ns at 0.0 "$node_(72) off" 
$ns at 165.0 "$node_(72) on" 
$node_(73) set X_ 2475 
$node_(73) set Y_ 861 
$node_(73) set Z_ 0.0 
$ns at 0.0 "$node_(73) off" 
$ns at 165.0 "$node_(73) on" 
$node_(74) set X_ 149 
$node_(74) set Y_ 37 
$node_(74) set Z_ 0.0 
$ns at 0.0 "$node_(74) off" 
$ns at 165.0 "$node_(74) on" 
$node_(75) set X_ 1687 
$node_(75) set Y_ 144 
$node_(75) set Z_ 0.0 
$ns at 0.0 "$node_(75) off" 
$ns at 330.0 "$node_(75) on" 
$node_(76) set X_ 2360 
$node_(76) set Y_ 40 
$node_(76) set Z_ 0.0 
$ns at 0.0 "$node_(76) off" 
$ns at 330.0 "$node_(76) on" 
$node_(77) set X_ 2662 
$node_(77) set Y_ 42 
$node_(77) set Z_ 0.0 
$ns at 0.0 "$node_(77) off" 
$ns at 330.0 "$node_(77) on" 
$node_(78) set X_ 2663 
$node_(78) set Y_ 197 
$node_(78) set Z_ 0.0 
$ns at 0.0 "$node_(78) off" 
$ns at 330.0 "$node_(78) on" 
$node_(79) set X_ 2238 
$node_(79) set Y_ 355 
$node_(79) set Z_ 0.0 
$ns at 0.0 "$node_(79) off" 
$ns at 330.0 "$node_(79) on" 
$node_(80) set X_ 1959 
$node_(80) set Y_ 7 
$node_(80) set Z_ 0.0 
$ns at 0.0 "$node_(80) off" 
$ns at 330.0 "$node_(80) on" 
$node_(81) set X_ 2020 
$node_(81) set Y_ 70 
$node_(81) set Z_ 0.0 
$ns at 0.0 "$node_(81) off" 
$ns at 330.0 "$node_(81) on" 
$node_(82) set X_ 206 
$node_(82) set Y_ 909 
$node_(82) set Z_ 0.0 
$ns at 0.0 "$node_(82) off" 
$ns at 330.0 "$node_(82) on" 
$node_(83) set X_ 2317 
$node_(83) set Y_ 634 
$node_(83) set Z_ 0.0 
$ns at 0.0 "$node_(83) off" 
$ns at 330.0 "$node_(83) on" 
$node_(84) set X_ 195 
$node_(84) set Y_ 184 
$node_(84) set Z_ 0.0 
$ns at 0.0 "$node_(84) off" 
$ns at 330.0 "$node_(84) on" 
$node_(85) set X_ 791 
$node_(85) set Y_ 134 
$node_(85) set Z_ 0.0 
$ns at 0.0 "$node_(85) off" 
$ns at 330.0 "$node_(85) on" 
$node_(86) set X_ 1096 
$node_(86) set Y_ 468 
$node_(86) set Z_ 0.0 
$ns at 0.0 "$node_(86) off" 
$ns at 330.0 "$node_(86) on" 
$node_(87) set X_ 2892 
$node_(87) set Y_ 439 
$node_(87) set Z_ 0.0 
$ns at 0.0 "$node_(87) off" 
$ns at 330.0 "$node_(87) on" 
$node_(88) set X_ 691 
$node_(88) set Y_ 841 
$node_(88) set Z_ 0.0 
$ns at 0.0 "$node_(88) off" 
$ns at 330.0 "$node_(88) on" 
$node_(89) set X_ 1086 
$node_(89) set Y_ 727 
$node_(89) set Z_ 0.0 
$ns at 0.0 "$node_(89) off" 
$ns at 330.0 "$node_(89) on" 
$node_(90) set X_ 451 
$node_(90) set Y_ 471 
$node_(90) set Z_ 0.0 
$ns at 0.0 "$node_(90) off" 
$ns at 330.0 "$node_(90) on" 
$node_(91) set X_ 1179 
$node_(91) set Y_ 587 
$node_(91) set Z_ 0.0 
$ns at 0.0 "$node_(91) off" 
$ns at 330.0 "$node_(91) on" 
$node_(92) set X_ 2841 
$node_(92) set Y_ 576 
$node_(92) set Z_ 0.0 
$ns at 0.0 "$node_(92) off" 
$ns at 330.0 "$node_(92) on" 
$node_(93) set X_ 1911 
$node_(93) set Y_ 65 
$node_(93) set Z_ 0.0 
$ns at 0.0 "$node_(93) off" 
$ns at 330.0 "$node_(93) on" 
$node_(94) set X_ 2373 
$node_(94) set Y_ 274 
$node_(94) set Z_ 0.0 
$ns at 0.0 "$node_(94) off" 
$ns at 330.0 "$node_(94) on" 
$node_(95) set X_ 1240 
$node_(95) set Y_ 616 
$node_(95) set Z_ 0.0 
$ns at 0.0 "$node_(95) off" 
$ns at 330.0 "$node_(95) on" 
$node_(96) set X_ 1129 
$node_(96) set Y_ 509 
$node_(96) set Z_ 0.0 
$ns at 0.0 "$node_(96) off" 
$ns at 330.0 "$node_(96) on" 
$node_(97) set X_ 512 
$node_(97) set Y_ 882 
$node_(97) set Z_ 0.0 
$ns at 0.0 "$node_(97) off" 
$ns at 330.0 "$node_(97) on" 
$node_(98) set X_ 2551 
$node_(98) set Y_ 851 
$node_(98) set Z_ 0.0 
$ns at 0.0 "$node_(98) off" 
$ns at 330.0 "$node_(98) on" 
$node_(99) set X_ 1955 
$node_(99) set Y_ 655 
$node_(99) set Z_ 0.0 
$ns at 0.0 "$node_(99) off" 
$ns at 330.0 "$node_(99) on" 
$node_(100) set X_ 388 
$node_(100) set Y_ 398 
$node_(100) set Z_ 0.0 
$ns at 0.0 "$node_(100) off" 
$ns at 495.0 "$node_(100) on" 
$node_(101) set X_ 1580 
$node_(101) set Y_ 154 
$node_(101) set Z_ 0.0 
$ns at 0.0 "$node_(101) off" 
$ns at 495.0 "$node_(101) on" 
$node_(102) set X_ 2771 
$node_(102) set Y_ 420 
$node_(102) set Z_ 0.0 
$ns at 0.0 "$node_(102) off" 
$ns at 495.0 "$node_(102) on" 
$node_(103) set X_ 1798 
$node_(103) set Y_ 959 
$node_(103) set Z_ 0.0 
$ns at 0.0 "$node_(103) off" 
$ns at 495.0 "$node_(103) on" 
$node_(104) set X_ 364 
$node_(104) set Y_ 668 
$node_(104) set Z_ 0.0 
$ns at 0.0 "$node_(104) off" 
$ns at 495.0 "$node_(104) on" 
$node_(105) set X_ 638 
$node_(105) set Y_ 569 
$node_(105) set Z_ 0.0 
$ns at 0.0 "$node_(105) off" 
$ns at 495.0 "$node_(105) on" 
$node_(106) set X_ 574 
$node_(106) set Y_ 437 
$node_(106) set Z_ 0.0 
$ns at 0.0 "$node_(106) off" 
$ns at 495.0 "$node_(106) on" 
$node_(107) set X_ 595 
$node_(107) set Y_ 560 
$node_(107) set Z_ 0.0 
$ns at 0.0 "$node_(107) off" 
$ns at 495.0 "$node_(107) on" 
$node_(108) set X_ 2724 
$node_(108) set Y_ 605 
$node_(108) set Z_ 0.0 
$ns at 0.0 "$node_(108) off" 
$ns at 495.0 "$node_(108) on" 
$node_(109) set X_ 1666 
$node_(109) set Y_ 762 
$node_(109) set Z_ 0.0 
$ns at 0.0 "$node_(109) off" 
$ns at 495.0 "$node_(109) on" 
$node_(110) set X_ 64 
$node_(110) set Y_ 850 
$node_(110) set Z_ 0.0 
$ns at 0.0 "$node_(110) off" 
$ns at 495.0 "$node_(110) on" 
$node_(111) set X_ 214 
$node_(111) set Y_ 680 
$node_(111) set Z_ 0.0 
$ns at 0.0 "$node_(111) off" 
$ns at 495.0 "$node_(111) on" 
$node_(112) set X_ 1352 
$node_(112) set Y_ 177 
$node_(112) set Z_ 0.0 
$ns at 0.0 "$node_(112) off" 
$ns at 495.0 "$node_(112) on" 
$node_(113) set X_ 764 
$node_(113) set Y_ 651 
$node_(113) set Z_ 0.0 
$ns at 0.0 "$node_(113) off" 
$ns at 495.0 "$node_(113) on" 
$node_(114) set X_ 618 
$node_(114) set Y_ 687 
$node_(114) set Z_ 0.0 
$ns at 0.0 "$node_(114) off" 
$ns at 495.0 "$node_(114) on" 
$node_(115) set X_ 846 
$node_(115) set Y_ 861 
$node_(115) set Z_ 0.0 
$ns at 0.0 "$node_(115) off" 
$ns at 495.0 "$node_(115) on" 
$node_(116) set X_ 1585 
$node_(116) set Y_ 248 
$node_(116) set Z_ 0.0 
$ns at 0.0 "$node_(116) off" 
$ns at 495.0 "$node_(116) on" 
$node_(117) set X_ 421 
$node_(117) set Y_ 396 
$node_(117) set Z_ 0.0 
$ns at 0.0 "$node_(117) off" 
$ns at 495.0 "$node_(117) on" 
$node_(118) set X_ 1973 
$node_(118) set Y_ 378 
$node_(118) set Z_ 0.0 
$ns at 0.0 "$node_(118) off" 
$ns at 495.0 "$node_(118) on" 
$node_(119) set X_ 2342 
$node_(119) set Y_ 966 
$node_(119) set Z_ 0.0 
$ns at 0.0 "$node_(119) off" 
$ns at 495.0 "$node_(119) on" 
$node_(120) set X_ 733 
$node_(120) set Y_ 150 
$node_(120) set Z_ 0.0 
$ns at 0.0 "$node_(120) off" 
$ns at 495.0 "$node_(120) on" 
$node_(121) set X_ 2702 
$node_(121) set Y_ 802 
$node_(121) set Z_ 0.0 
$ns at 0.0 "$node_(121) off" 
$ns at 495.0 "$node_(121) on" 
$node_(122) set X_ 1966 
$node_(122) set Y_ 403 
$node_(122) set Z_ 0.0 
$ns at 0.0 "$node_(122) off" 
$ns at 495.0 "$node_(122) on" 
$node_(123) set X_ 2751 
$node_(123) set Y_ 490 
$node_(123) set Z_ 0.0 
$ns at 0.0 "$node_(123) off" 
$ns at 495.0 "$node_(123) on" 
$node_(124) set X_ 1019 
$node_(124) set Y_ 873 
$node_(124) set Z_ 0.0 
$ns at 0.0 "$node_(124) off" 
$ns at 495.0 "$node_(124) on" 
$node_(125) set X_ 2389 
$node_(125) set Y_ 204 
$node_(125) set Z_ 0.0 
$ns at 0.0 "$node_(125) off" 
$ns at 660.0 "$node_(125) on" 
$node_(126) set X_ 2895 
$node_(126) set Y_ 129 
$node_(126) set Z_ 0.0 
$ns at 0.0 "$node_(126) off" 
$ns at 660.0 "$node_(126) on" 
$node_(127) set X_ 2035 
$node_(127) set Y_ 846 
$node_(127) set Z_ 0.0 
$ns at 0.0 "$node_(127) off" 
$ns at 660.0 "$node_(127) on" 
$node_(128) set X_ 806 
$node_(128) set Y_ 337 
$node_(128) set Z_ 0.0 
$ns at 0.0 "$node_(128) off" 
$ns at 660.0 "$node_(128) on" 
$node_(129) set X_ 1923 
$node_(129) set Y_ 139 
$node_(129) set Z_ 0.0 
$ns at 0.0 "$node_(129) off" 
$ns at 660.0 "$node_(129) on" 
$node_(130) set X_ 1265 
$node_(130) set Y_ 966 
$node_(130) set Z_ 0.0 
$ns at 0.0 "$node_(130) off" 
$ns at 660.0 "$node_(130) on" 
$node_(131) set X_ 1608 
$node_(131) set Y_ 562 
$node_(131) set Z_ 0.0 
$ns at 0.0 "$node_(131) off" 
$ns at 660.0 "$node_(131) on" 
$node_(132) set X_ 739 
$node_(132) set Y_ 509 
$node_(132) set Z_ 0.0 
$ns at 0.0 "$node_(132) off" 
$ns at 660.0 "$node_(132) on" 
$node_(133) set X_ 1658 
$node_(133) set Y_ 362 
$node_(133) set Z_ 0.0 
$ns at 0.0 "$node_(133) off" 
$ns at 660.0 "$node_(133) on" 
$node_(134) set X_ 2411 
$node_(134) set Y_ 182 
$node_(134) set Z_ 0.0 
$ns at 0.0 "$node_(134) off" 
$ns at 660.0 "$node_(134) on" 
$node_(135) set X_ 154 
$node_(135) set Y_ 561 
$node_(135) set Z_ 0.0 
$ns at 0.0 "$node_(135) off" 
$ns at 660.0 "$node_(135) on" 
$node_(136) set X_ 2151 
$node_(136) set Y_ 334 
$node_(136) set Z_ 0.0 
$ns at 0.0 "$node_(136) off" 
$ns at 660.0 "$node_(136) on" 
$node_(137) set X_ 786 
$node_(137) set Y_ 994 
$node_(137) set Z_ 0.0 
$ns at 0.0 "$node_(137) off" 
$ns at 660.0 "$node_(137) on" 
$node_(138) set X_ 236 
$node_(138) set Y_ 16 
$node_(138) set Z_ 0.0 
$ns at 0.0 "$node_(138) off" 
$ns at 660.0 "$node_(138) on" 
$node_(139) set X_ 1902 
$node_(139) set Y_ 946 
$node_(139) set Z_ 0.0 
$ns at 0.0 "$node_(139) off" 
$ns at 660.0 "$node_(139) on" 
$node_(140) set X_ 2890 
$node_(140) set Y_ 731 
$node_(140) set Z_ 0.0 
$ns at 0.0 "$node_(140) off" 
$ns at 660.0 "$node_(140) on" 
$node_(141) set X_ 2947 
$node_(141) set Y_ 863 
$node_(141) set Z_ 0.0 
$ns at 0.0 "$node_(141) off" 
$ns at 660.0 "$node_(141) on" 
$node_(142) set X_ 1073 
$node_(142) set Y_ 924 
$node_(142) set Z_ 0.0 
$ns at 0.0 "$node_(142) off" 
$ns at 660.0 "$node_(142) on" 
$node_(143) set X_ 286 
$node_(143) set Y_ 969 
$node_(143) set Z_ 0.0 
$ns at 0.0 "$node_(143) off" 
$ns at 660.0 "$node_(143) on" 
$node_(144) set X_ 2401 
$node_(144) set Y_ 133 
$node_(144) set Z_ 0.0 
$ns at 0.0 "$node_(144) off" 
$ns at 660.0 "$node_(144) on" 
$node_(145) set X_ 363 
$node_(145) set Y_ 335 
$node_(145) set Z_ 0.0 
$ns at 0.0 "$node_(145) off" 
$ns at 660.0 "$node_(145) on" 
$node_(146) set X_ 408 
$node_(146) set Y_ 100 
$node_(146) set Z_ 0.0 
$ns at 0.0 "$node_(146) off" 
$ns at 660.0 "$node_(146) on" 
$node_(147) set X_ 2689 
$node_(147) set Y_ 114 
$node_(147) set Z_ 0.0 
$ns at 0.0 "$node_(147) off" 
$ns at 660.0 "$node_(147) on" 
$node_(148) set X_ 1712 
$node_(148) set Y_ 314 
$node_(148) set Z_ 0.0 
$ns at 0.0 "$node_(148) off" 
$ns at 660.0 "$node_(148) on" 
$node_(149) set X_ 1039 
$node_(149) set Y_ 189 
$node_(149) set Z_ 0.0 
$ns at 0.0 "$node_(149) off" 
$ns at 660.0 "$node_(149) on" 

# Generation of movements
$ns at 0.0 "$node_(0) setdest 1962 611 5.0" 
$ns at 52.95721258983765 "$node_(0) setdest 2677 495 16.0" 
$ns at 135.45357838431806 "$node_(0) setdest 1382 773 6.0" 
$ns at 210.78809011611918 "$node_(0) setdest 2607 957 7.0" 
$ns at 268.04662352185426 "$node_(0) setdest 1530 633 13.0" 
$ns at 413.77033500444304 "$node_(0) setdest 2161 662 10.0" 
$ns at 498.2489784317637 "$node_(0) setdest 1123 654 16.0" 
$ns at 634.1973453944074 "$node_(0) setdest 108 604 1.0" 
$ns at 664.6591558816814 "$node_(0) setdest 1216 991 11.0" 
$ns at 699.9566795162172 "$node_(0) setdest 337 899 4.0" 
$ns at 742.6223380693327 "$node_(0) setdest 2776 943 16.0" 
$ns at 833.6664888519301 "$node_(0) setdest 249 832 3.0" 
$ns at 882.7828499402801 "$node_(0) setdest 2340 474 17.0" 
$ns at 0.0 "$node_(1) setdest 2369 365 18.0" 
$ns at 161.50941042226137 "$node_(1) setdest 2512 890 7.0" 
$ns at 201.39876839976426 "$node_(1) setdest 1842 832 19.0" 
$ns at 381.96651289270613 "$node_(1) setdest 776 52 5.0" 
$ns at 446.9619015810281 "$node_(1) setdest 2143 820 4.0" 
$ns at 507.79886302266635 "$node_(1) setdest 1899 730 2.0" 
$ns at 548.645099096854 "$node_(1) setdest 1153 466 5.0" 
$ns at 625.9148017772944 "$node_(1) setdest 895 967 14.0" 
$ns at 765.7562904008469 "$node_(1) setdest 1454 663 1.0" 
$ns at 796.8079705204415 "$node_(1) setdest 1306 562 1.0" 
$ns at 832.023379819293 "$node_(1) setdest 476 909 16.0" 
$ns at 0.0 "$node_(2) setdest 2300 36 18.0" 
$ns at 89.14776998375794 "$node_(2) setdest 852 798 17.0" 
$ns at 121.66877914172832 "$node_(2) setdest 2825 697 15.0" 
$ns at 164.3032512211613 "$node_(2) setdest 1120 372 3.0" 
$ns at 214.2545809050189 "$node_(2) setdest 2820 662 11.0" 
$ns at 331.02787957665487 "$node_(2) setdest 2631 842 1.0" 
$ns at 370.7320176252399 "$node_(2) setdest 228 957 17.0" 
$ns at 452.7286734366303 "$node_(2) setdest 288 406 17.0" 
$ns at 567.9189742910214 "$node_(2) setdest 1299 49 14.0" 
$ns at 626.016159232691 "$node_(2) setdest 483 153 9.0" 
$ns at 687.6130929907534 "$node_(2) setdest 2449 433 12.0" 
$ns at 730.0372855381803 "$node_(2) setdest 2365 292 19.0" 
$ns at 0.0 "$node_(3) setdest 1647 125 3.0" 
$ns at 38.14896885624729 "$node_(3) setdest 2292 197 11.0" 
$ns at 157.11609923277086 "$node_(3) setdest 2095 195 17.0" 
$ns at 234.18522298806812 "$node_(3) setdest 1105 5 19.0" 
$ns at 264.9399891981189 "$node_(3) setdest 1682 672 11.0" 
$ns at 404.33273442641575 "$node_(3) setdest 585 748 10.0" 
$ns at 512.0373619000017 "$node_(3) setdest 1478 470 1.0" 
$ns at 545.2224678346082 "$node_(3) setdest 220 272 19.0" 
$ns at 712.8717182410874 "$node_(3) setdest 1237 165 1.0" 
$ns at 745.6726706772641 "$node_(3) setdest 143 414 12.0" 
$ns at 850.561079799699 "$node_(3) setdest 1683 765 11.0" 
$ns at 0.0 "$node_(4) setdest 1877 197 7.0" 
$ns at 67.35728272955718 "$node_(4) setdest 1053 814 5.0" 
$ns at 102.8389604394226 "$node_(4) setdest 2247 3 8.0" 
$ns at 208.8867320894202 "$node_(4) setdest 1158 456 14.0" 
$ns at 335.70216255852336 "$node_(4) setdest 586 986 1.0" 
$ns at 366.5296088539409 "$node_(4) setdest 2947 318 17.0" 
$ns at 516.605128205788 "$node_(4) setdest 1097 211 7.0" 
$ns at 583.8560213924812 "$node_(4) setdest 2331 327 19.0" 
$ns at 716.5821794183316 "$node_(4) setdest 2005 235 5.0" 
$ns at 793.66825720263 "$node_(4) setdest 755 821 11.0" 
$ns at 848.6161652147933 "$node_(4) setdest 2864 154 8.0" 
$ns at 0.0 "$node_(5) setdest 761 572 12.0" 
$ns at 66.14046411033414 "$node_(5) setdest 2134 316 17.0" 
$ns at 214.48221181040495 "$node_(5) setdest 2555 578 12.0" 
$ns at 301.1120013718007 "$node_(5) setdest 2910 222 14.0" 
$ns at 415.3804549517557 "$node_(5) setdest 303 749 10.0" 
$ns at 447.4860398173435 "$node_(5) setdest 419 332 20.0" 
$ns at 665.1025025844007 "$node_(5) setdest 1667 830 16.0" 
$ns at 713.8470335184008 "$node_(5) setdest 652 770 5.0" 
$ns at 744.8074434313991 "$node_(5) setdest 1817 198 7.0" 
$ns at 807.3011717900174 "$node_(5) setdest 259 169 16.0" 
$ns at 0.0 "$node_(6) setdest 2928 379 1.0" 
$ns at 39.625182357508315 "$node_(6) setdest 2576 140 3.0" 
$ns at 98.00536025107516 "$node_(6) setdest 2892 407 12.0" 
$ns at 164.9077972351663 "$node_(6) setdest 1405 112 1.0" 
$ns at 199.85307953478264 "$node_(6) setdest 750 379 3.0" 
$ns at 250.9124065080013 "$node_(6) setdest 2913 514 9.0" 
$ns at 346.1420362874861 "$node_(6) setdest 1099 839 8.0" 
$ns at 384.7592729987097 "$node_(6) setdest 780 559 8.0" 
$ns at 452.3394963299929 "$node_(6) setdest 446 825 12.0" 
$ns at 567.8316014986713 "$node_(6) setdest 460 100 6.0" 
$ns at 601.5319538715091 "$node_(6) setdest 2281 722 2.0" 
$ns at 642.2812217581582 "$node_(6) setdest 181 309 19.0" 
$ns at 766.8915218269132 "$node_(6) setdest 344 259 4.0" 
$ns at 811.3806520537396 "$node_(6) setdest 2051 153 5.0" 
$ns at 865.4092525867501 "$node_(6) setdest 2354 286 6.0" 
$ns at 0.0 "$node_(7) setdest 1396 931 1.0" 
$ns at 33.79603756370161 "$node_(7) setdest 2170 173 12.0" 
$ns at 104.49649285892502 "$node_(7) setdest 2191 321 17.0" 
$ns at 206.16695822655225 "$node_(7) setdest 1152 962 5.0" 
$ns at 279.18977179371524 "$node_(7) setdest 2222 720 13.0" 
$ns at 394.16734280440784 "$node_(7) setdest 211 625 7.0" 
$ns at 459.03482608465856 "$node_(7) setdest 332 827 16.0" 
$ns at 566.5020899737892 "$node_(7) setdest 1787 40 1.0" 
$ns at 602.2881387293554 "$node_(7) setdest 882 732 17.0" 
$ns at 776.8599621292433 "$node_(7) setdest 1762 562 4.0" 
$ns at 835.9805607199063 "$node_(7) setdest 304 988 16.0" 
$ns at 0.0 "$node_(8) setdest 44 280 15.0" 
$ns at 170.2958167744686 "$node_(8) setdest 1345 403 19.0" 
$ns at 321.66614110214675 "$node_(8) setdest 2334 348 20.0" 
$ns at 419.39224145877074 "$node_(8) setdest 2403 554 5.0" 
$ns at 481.3191612415049 "$node_(8) setdest 1297 981 18.0" 
$ns at 540.1831602268596 "$node_(8) setdest 49 244 15.0" 
$ns at 625.4278583741002 "$node_(8) setdest 1160 998 3.0" 
$ns at 669.4260473283736 "$node_(8) setdest 1624 394 2.0" 
$ns at 718.1642292014027 "$node_(8) setdest 460 9 3.0" 
$ns at 768.4779232343351 "$node_(8) setdest 527 127 5.0" 
$ns at 823.7514556034567 "$node_(8) setdest 1460 624 11.0" 
$ns at 853.8836517058228 "$node_(8) setdest 2555 999 13.0" 
$ns at 0.0 "$node_(9) setdest 1457 282 8.0" 
$ns at 48.04014605570806 "$node_(9) setdest 437 649 18.0" 
$ns at 161.70584214699048 "$node_(9) setdest 2996 582 15.0" 
$ns at 271.1314352417547 "$node_(9) setdest 1412 329 18.0" 
$ns at 432.91813795621385 "$node_(9) setdest 2726 209 11.0" 
$ns at 490.9018691035671 "$node_(9) setdest 488 74 15.0" 
$ns at 571.0440927691213 "$node_(9) setdest 398 832 20.0" 
$ns at 761.2800096083379 "$node_(9) setdest 2739 484 9.0" 
$ns at 798.7855771083917 "$node_(9) setdest 1248 586 10.0" 
$ns at 837.160205539692 "$node_(9) setdest 776 364 9.0" 
$ns at 0.0 "$node_(10) setdest 768 996 10.0" 
$ns at 51.275867139203186 "$node_(10) setdest 250 712 1.0" 
$ns at 91.10545878043638 "$node_(10) setdest 1601 456 4.0" 
$ns at 134.54798791555615 "$node_(10) setdest 1016 787 9.0" 
$ns at 176.92424047973668 "$node_(10) setdest 2065 635 7.0" 
$ns at 263.72568007134254 "$node_(10) setdest 1328 249 16.0" 
$ns at 357.6005224913505 "$node_(10) setdest 1545 416 4.0" 
$ns at 393.10144308599496 "$node_(10) setdest 182 610 6.0" 
$ns at 463.1472545978062 "$node_(10) setdest 2760 227 15.0" 
$ns at 540.9196664734826 "$node_(10) setdest 680 485 18.0" 
$ns at 688.1769485342404 "$node_(10) setdest 633 890 1.0" 
$ns at 724.0626620854947 "$node_(10) setdest 44 372 17.0" 
$ns at 756.1875134270637 "$node_(10) setdest 2279 345 18.0" 
$ns at 0.0 "$node_(11) setdest 634 969 18.0" 
$ns at 137.66126774460878 "$node_(11) setdest 348 852 4.0" 
$ns at 167.82398230968863 "$node_(11) setdest 2112 240 6.0" 
$ns at 246.96590659809803 "$node_(11) setdest 2713 556 4.0" 
$ns at 300.5427207078652 "$node_(11) setdest 1600 745 20.0" 
$ns at 424.54082704213187 "$node_(11) setdest 269 509 10.0" 
$ns at 496.83683161863826 "$node_(11) setdest 2478 948 16.0" 
$ns at 614.0255959525277 "$node_(11) setdest 1311 519 2.0" 
$ns at 657.0147614322021 "$node_(11) setdest 172 514 8.0" 
$ns at 754.8053588305628 "$node_(11) setdest 765 443 18.0" 
$ns at 0.0 "$node_(12) setdest 1065 813 12.0" 
$ns at 83.62747785432245 "$node_(12) setdest 2248 786 9.0" 
$ns at 149.04408276776246 "$node_(12) setdest 2396 136 12.0" 
$ns at 212.91268973812697 "$node_(12) setdest 1713 709 13.0" 
$ns at 371.86289571380354 "$node_(12) setdest 2774 344 4.0" 
$ns at 420.3500995258181 "$node_(12) setdest 1173 823 3.0" 
$ns at 478.7520929581148 "$node_(12) setdest 2674 960 7.0" 
$ns at 513.2755691455576 "$node_(12) setdest 1747 383 13.0" 
$ns at 569.3842617734563 "$node_(12) setdest 36 919 7.0" 
$ns at 633.3241923346764 "$node_(12) setdest 1032 724 8.0" 
$ns at 716.0037117654164 "$node_(12) setdest 1837 485 19.0" 
$ns at 866.4167905458052 "$node_(12) setdest 2534 81 17.0" 
$ns at 0.0 "$node_(13) setdest 1265 55 14.0" 
$ns at 105.12768983598492 "$node_(13) setdest 669 139 11.0" 
$ns at 164.0038822218062 "$node_(13) setdest 2855 856 7.0" 
$ns at 203.35510527842905 "$node_(13) setdest 1572 923 4.0" 
$ns at 250.8820238905674 "$node_(13) setdest 1715 755 12.0" 
$ns at 320.7413376069526 "$node_(13) setdest 2705 910 5.0" 
$ns at 353.56186219026864 "$node_(13) setdest 712 690 20.0" 
$ns at 506.14572201267066 "$node_(13) setdest 2025 457 14.0" 
$ns at 590.0557082964486 "$node_(13) setdest 237 438 16.0" 
$ns at 738.2904464817977 "$node_(13) setdest 192 913 5.0" 
$ns at 798.3336156657037 "$node_(13) setdest 925 733 16.0" 
$ns at 887.5345340753333 "$node_(13) setdest 2075 44 11.0" 
$ns at 0.0 "$node_(14) setdest 441 950 10.0" 
$ns at 93.1789809709033 "$node_(14) setdest 547 604 8.0" 
$ns at 158.2383478710994 "$node_(14) setdest 2220 856 8.0" 
$ns at 263.5781088401447 "$node_(14) setdest 1311 197 13.0" 
$ns at 384.1313277693455 "$node_(14) setdest 758 162 18.0" 
$ns at 529.6091615619897 "$node_(14) setdest 1264 773 11.0" 
$ns at 595.9983612390109 "$node_(14) setdest 1857 870 8.0" 
$ns at 644.9884875650465 "$node_(14) setdest 1635 376 14.0" 
$ns at 681.7859300611838 "$node_(14) setdest 1906 641 8.0" 
$ns at 735.6879591671834 "$node_(14) setdest 2899 11 15.0" 
$ns at 843.4550014554923 "$node_(14) setdest 1110 687 14.0" 
$ns at 0.0 "$node_(15) setdest 1207 742 12.0" 
$ns at 85.36696469044644 "$node_(15) setdest 255 912 6.0" 
$ns at 119.66654292678379 "$node_(15) setdest 838 376 16.0" 
$ns at 229.00929256950596 "$node_(15) setdest 399 302 3.0" 
$ns at 268.3936490362756 "$node_(15) setdest 906 366 5.0" 
$ns at 306.56460502724264 "$node_(15) setdest 1603 795 18.0" 
$ns at 480.2987907241046 "$node_(15) setdest 2336 769 6.0" 
$ns at 558.8710105992968 "$node_(15) setdest 572 118 17.0" 
$ns at 758.7814672362701 "$node_(15) setdest 828 399 11.0" 
$ns at 815.9065958001477 "$node_(15) setdest 2840 333 5.0" 
$ns at 846.6517357613573 "$node_(15) setdest 1340 519 15.0" 
$ns at 0.0 "$node_(16) setdest 2842 88 7.0" 
$ns at 65.19935948849773 "$node_(16) setdest 303 695 11.0" 
$ns at 115.00601629432822 "$node_(16) setdest 30 790 11.0" 
$ns at 219.27059450527656 "$node_(16) setdest 2586 673 2.0" 
$ns at 265.403559253312 "$node_(16) setdest 2875 207 17.0" 
$ns at 407.2464729289956 "$node_(16) setdest 2946 392 18.0" 
$ns at 544.037029911287 "$node_(16) setdest 386 238 16.0" 
$ns at 696.9912479803488 "$node_(16) setdest 469 494 17.0" 
$ns at 775.5476379527889 "$node_(16) setdest 1530 820 18.0" 
$ns at 897.2157492791274 "$node_(16) setdest 1232 951 12.0" 
$ns at 0.0 "$node_(17) setdest 646 232 19.0" 
$ns at 92.64602996766196 "$node_(17) setdest 1202 664 16.0" 
$ns at 190.183786004462 "$node_(17) setdest 754 272 14.0" 
$ns at 284.11942569853767 "$node_(17) setdest 2099 152 16.0" 
$ns at 436.31505079909493 "$node_(17) setdest 2359 51 5.0" 
$ns at 483.53792768562437 "$node_(17) setdest 2737 697 2.0" 
$ns at 526.6595567964791 "$node_(17) setdest 1127 387 19.0" 
$ns at 660.1940946283422 "$node_(17) setdest 2076 546 2.0" 
$ns at 698.2506897562567 "$node_(17) setdest 2566 39 3.0" 
$ns at 729.7122972540828 "$node_(17) setdest 2981 55 15.0" 
$ns at 860.2153382057406 "$node_(17) setdest 2557 277 13.0" 
$ns at 0.0 "$node_(18) setdest 447 863 15.0" 
$ns at 140.7603137724915 "$node_(18) setdest 389 512 8.0" 
$ns at 180.61973290832805 "$node_(18) setdest 1771 479 14.0" 
$ns at 255.758251431042 "$node_(18) setdest 634 987 15.0" 
$ns at 330.6888972042459 "$node_(18) setdest 928 883 10.0" 
$ns at 398.85835342777597 "$node_(18) setdest 18 760 10.0" 
$ns at 457.08300679798316 "$node_(18) setdest 1139 15 13.0" 
$ns at 565.1878036509177 "$node_(18) setdest 1128 470 11.0" 
$ns at 695.686925284595 "$node_(18) setdest 385 254 7.0" 
$ns at 758.1035013232653 "$node_(18) setdest 2602 624 14.0" 
$ns at 894.0474949580595 "$node_(18) setdest 2353 259 13.0" 
$ns at 0.0 "$node_(19) setdest 149 392 12.0" 
$ns at 48.668036345228685 "$node_(19) setdest 2072 778 13.0" 
$ns at 117.9214406628583 "$node_(19) setdest 544 154 4.0" 
$ns at 154.8162625840744 "$node_(19) setdest 1227 300 3.0" 
$ns at 199.3903775681936 "$node_(19) setdest 449 273 18.0" 
$ns at 355.953848046007 "$node_(19) setdest 898 645 12.0" 
$ns at 427.46584979867225 "$node_(19) setdest 2694 855 17.0" 
$ns at 512.166058466909 "$node_(19) setdest 1221 876 12.0" 
$ns at 609.7764295465049 "$node_(19) setdest 2385 458 6.0" 
$ns at 679.0150304770258 "$node_(19) setdest 2221 129 10.0" 
$ns at 797.0085910038526 "$node_(19) setdest 1952 10 17.0" 
$ns at 883.3572956357517 "$node_(19) setdest 805 233 6.0" 
$ns at 0.0 "$node_(20) setdest 1029 417 5.0" 
$ns at 71.36556429824886 "$node_(20) setdest 670 239 2.0" 
$ns at 101.45528675750818 "$node_(20) setdest 761 588 10.0" 
$ns at 203.7878258454748 "$node_(20) setdest 1612 196 3.0" 
$ns at 238.67330827502846 "$node_(20) setdest 2933 887 16.0" 
$ns at 302.286825992498 "$node_(20) setdest 1495 830 2.0" 
$ns at 339.9610469710182 "$node_(20) setdest 18 230 10.0" 
$ns at 457.0120217150113 "$node_(20) setdest 2862 939 7.0" 
$ns at 498.61274149540026 "$node_(20) setdest 1045 332 18.0" 
$ns at 537.202386811484 "$node_(20) setdest 1943 666 16.0" 
$ns at 609.2534423971665 "$node_(20) setdest 873 823 5.0" 
$ns at 656.6514360366905 "$node_(20) setdest 1561 971 5.0" 
$ns at 710.4929124694563 "$node_(20) setdest 2278 245 16.0" 
$ns at 753.1930954338364 "$node_(20) setdest 161 946 13.0" 
$ns at 816.3586125276244 "$node_(20) setdest 2940 148 8.0" 
$ns at 0.0 "$node_(21) setdest 2986 822 17.0" 
$ns at 160.72618141821275 "$node_(21) setdest 1231 781 3.0" 
$ns at 203.25822029535067 "$node_(21) setdest 126 781 16.0" 
$ns at 297.02948917500134 "$node_(21) setdest 404 121 3.0" 
$ns at 356.04110395589646 "$node_(21) setdest 941 942 15.0" 
$ns at 506.0756236945981 "$node_(21) setdest 563 218 1.0" 
$ns at 541.8088800613067 "$node_(21) setdest 2108 131 7.0" 
$ns at 640.539127976928 "$node_(21) setdest 1536 105 1.0" 
$ns at 679.9932117907001 "$node_(21) setdest 1288 299 15.0" 
$ns at 719.3296575974601 "$node_(21) setdest 1517 753 1.0" 
$ns at 750.5634601332494 "$node_(21) setdest 1151 701 9.0" 
$ns at 838.1652515444717 "$node_(21) setdest 1106 811 17.0" 
$ns at 0.0 "$node_(22) setdest 265 197 11.0" 
$ns at 134.29573962132054 "$node_(22) setdest 2103 129 11.0" 
$ns at 222.06946544372377 "$node_(22) setdest 1088 292 17.0" 
$ns at 289.39500803859437 "$node_(22) setdest 200 279 1.0" 
$ns at 328.9069206527583 "$node_(22) setdest 69 783 7.0" 
$ns at 424.7025362166725 "$node_(22) setdest 1421 595 4.0" 
$ns at 477.6686035702237 "$node_(22) setdest 583 106 14.0" 
$ns at 635.510896689119 "$node_(22) setdest 2939 439 12.0" 
$ns at 709.7078994125014 "$node_(22) setdest 228 778 12.0" 
$ns at 777.562161523408 "$node_(22) setdest 2650 699 5.0" 
$ns at 807.860055535436 "$node_(22) setdest 696 514 7.0" 
$ns at 849.329374136626 "$node_(22) setdest 603 757 16.0" 
$ns at 892.6783667742383 "$node_(22) setdest 2243 909 13.0" 
$ns at 0.0 "$node_(23) setdest 1182 407 5.0" 
$ns at 67.19163147270248 "$node_(23) setdest 2480 778 16.0" 
$ns at 231.393623922562 "$node_(23) setdest 1649 464 5.0" 
$ns at 273.7610896522674 "$node_(23) setdest 2006 539 6.0" 
$ns at 314.945304680955 "$node_(23) setdest 1409 61 15.0" 
$ns at 388.4322609222225 "$node_(23) setdest 2103 226 17.0" 
$ns at 447.7416778341679 "$node_(23) setdest 1144 860 1.0" 
$ns at 478.95162936653537 "$node_(23) setdest 1507 21 14.0" 
$ns at 628.2995737436569 "$node_(23) setdest 661 669 4.0" 
$ns at 688.7522206169442 "$node_(23) setdest 2998 396 1.0" 
$ns at 728.5467812063574 "$node_(23) setdest 2090 211 12.0" 
$ns at 863.0969076547121 "$node_(23) setdest 2300 246 9.0" 
$ns at 0.0 "$node_(24) setdest 1801 21 11.0" 
$ns at 37.77827615637465 "$node_(24) setdest 1540 620 10.0" 
$ns at 131.4856777596394 "$node_(24) setdest 155 719 13.0" 
$ns at 260.4530178899871 "$node_(24) setdest 264 903 17.0" 
$ns at 384.9881656214239 "$node_(24) setdest 1968 141 19.0" 
$ns at 557.7589419711273 "$node_(24) setdest 1751 582 1.0" 
$ns at 591.1268370864491 "$node_(24) setdest 2306 74 13.0" 
$ns at 651.7329130836538 "$node_(24) setdest 1130 942 17.0" 
$ns at 788.9096718491774 "$node_(24) setdest 977 572 5.0" 
$ns at 865.2633646248088 "$node_(24) setdest 532 319 12.0" 
$ns at 0.0 "$node_(25) setdest 2848 99 16.0" 
$ns at 93.77103738443066 "$node_(25) setdest 1290 755 4.0" 
$ns at 155.80155260535412 "$node_(25) setdest 862 991 13.0" 
$ns at 306.14675784052497 "$node_(25) setdest 1921 192 18.0" 
$ns at 353.8417397542695 "$node_(25) setdest 2358 961 14.0" 
$ns at 438.4523257283869 "$node_(25) setdest 1385 548 12.0" 
$ns at 529.0505099033121 "$node_(25) setdest 1085 656 1.0" 
$ns at 559.4368124836681 "$node_(25) setdest 1881 300 6.0" 
$ns at 628.7456291756731 "$node_(25) setdest 2025 478 9.0" 
$ns at 672.4508031251487 "$node_(25) setdest 161 432 10.0" 
$ns at 724.2770203986205 "$node_(25) setdest 2885 186 11.0" 
$ns at 855.8489292611991 "$node_(25) setdest 2113 863 19.0" 
$ns at 0.0 "$node_(26) setdest 1897 997 2.0" 
$ns at 31.869143217707983 "$node_(26) setdest 116 718 11.0" 
$ns at 155.9383684306566 "$node_(26) setdest 284 176 17.0" 
$ns at 211.73447276619294 "$node_(26) setdest 399 57 2.0" 
$ns at 251.96515411354346 "$node_(26) setdest 1521 366 1.0" 
$ns at 283.4187225277096 "$node_(26) setdest 2415 919 4.0" 
$ns at 321.0795744638494 "$node_(26) setdest 1251 134 10.0" 
$ns at 391.27006665286115 "$node_(26) setdest 968 804 14.0" 
$ns at 525.7721080628811 "$node_(26) setdest 1495 475 13.0" 
$ns at 648.7555888620649 "$node_(26) setdest 1584 953 1.0" 
$ns at 686.811926439789 "$node_(26) setdest 2507 262 3.0" 
$ns at 740.6715337411138 "$node_(26) setdest 1392 26 3.0" 
$ns at 798.3953219315208 "$node_(26) setdest 1414 887 4.0" 
$ns at 829.69756701455 "$node_(26) setdest 2483 66 13.0" 
$ns at 864.7966289004771 "$node_(26) setdest 492 563 19.0" 
$ns at 0.0 "$node_(27) setdest 2515 843 13.0" 
$ns at 51.0273649738685 "$node_(27) setdest 1722 52 4.0" 
$ns at 96.62283978874362 "$node_(27) setdest 1054 949 15.0" 
$ns at 198.28662648754363 "$node_(27) setdest 978 780 8.0" 
$ns at 288.01850695140547 "$node_(27) setdest 894 248 1.0" 
$ns at 320.88346793365093 "$node_(27) setdest 1971 598 1.0" 
$ns at 358.67118870313067 "$node_(27) setdest 2351 569 17.0" 
$ns at 465.2343750325972 "$node_(27) setdest 1839 666 12.0" 
$ns at 593.4650687765501 "$node_(27) setdest 1286 718 19.0" 
$ns at 677.1868036860395 "$node_(27) setdest 2972 205 4.0" 
$ns at 723.9789665909336 "$node_(27) setdest 2341 208 14.0" 
$ns at 760.8810314651175 "$node_(27) setdest 1473 94 11.0" 
$ns at 873.0731367858964 "$node_(27) setdest 2648 295 18.0" 
$ns at 0.0 "$node_(28) setdest 2356 568 10.0" 
$ns at 98.73582057926232 "$node_(28) setdest 988 201 18.0" 
$ns at 159.13027368379744 "$node_(28) setdest 1369 486 13.0" 
$ns at 316.6801830382818 "$node_(28) setdest 1171 622 19.0" 
$ns at 381.4497052976475 "$node_(28) setdest 39 928 18.0" 
$ns at 578.6404215966157 "$node_(28) setdest 108 894 2.0" 
$ns at 609.9191321962021 "$node_(28) setdest 1339 85 1.0" 
$ns at 644.6037687964018 "$node_(28) setdest 2841 431 9.0" 
$ns at 732.179198330549 "$node_(28) setdest 78 703 18.0" 
$ns at 884.2997148460244 "$node_(28) setdest 2511 294 12.0" 
$ns at 0.0 "$node_(29) setdest 890 554 9.0" 
$ns at 30.45365625071704 "$node_(29) setdest 2026 997 18.0" 
$ns at 214.2603929976784 "$node_(29) setdest 1446 682 13.0" 
$ns at 343.7759353470865 "$node_(29) setdest 1909 939 13.0" 
$ns at 502.5844849945281 "$node_(29) setdest 2257 406 14.0" 
$ns at 634.4701554350656 "$node_(29) setdest 2588 38 11.0" 
$ns at 745.7395156452584 "$node_(29) setdest 193 319 2.0" 
$ns at 792.0849534586157 "$node_(29) setdest 1110 467 2.0" 
$ns at 834.7906616854578 "$node_(29) setdest 1583 774 19.0" 
$ns at 0.0 "$node_(30) setdest 2032 580 7.0" 
$ns at 79.32639982096595 "$node_(30) setdest 1522 595 3.0" 
$ns at 129.0163619453052 "$node_(30) setdest 2987 398 11.0" 
$ns at 162.78227645034002 "$node_(30) setdest 2755 999 4.0" 
$ns at 230.94407086192808 "$node_(30) setdest 166 279 2.0" 
$ns at 280.9093625597232 "$node_(30) setdest 1259 970 7.0" 
$ns at 317.3832675404406 "$node_(30) setdest 2718 615 20.0" 
$ns at 508.70173940236333 "$node_(30) setdest 1391 567 17.0" 
$ns at 691.236898588443 "$node_(30) setdest 806 693 4.0" 
$ns at 733.3792928718468 "$node_(30) setdest 1229 914 12.0" 
$ns at 836.4807146393416 "$node_(30) setdest 818 60 18.0" 
$ns at 0.0 "$node_(31) setdest 476 858 11.0" 
$ns at 129.4154806201051 "$node_(31) setdest 1994 22 17.0" 
$ns at 178.99222026321928 "$node_(31) setdest 36 521 17.0" 
$ns at 284.5533810579899 "$node_(31) setdest 2431 133 17.0" 
$ns at 357.2421023996494 "$node_(31) setdest 2157 251 16.0" 
$ns at 430.4332528429864 "$node_(31) setdest 254 791 11.0" 
$ns at 502.3232733080566 "$node_(31) setdest 2739 704 8.0" 
$ns at 577.6473914034874 "$node_(31) setdest 1411 298 15.0" 
$ns at 693.1828045361174 "$node_(31) setdest 1187 39 1.0" 
$ns at 729.4496818855687 "$node_(31) setdest 1368 5 14.0" 
$ns at 887.3362273345343 "$node_(31) setdest 2938 474 6.0" 
$ns at 0.0 "$node_(32) setdest 1678 399 6.0" 
$ns at 30.344052115645407 "$node_(32) setdest 2518 687 13.0" 
$ns at 118.09925961998968 "$node_(32) setdest 184 251 9.0" 
$ns at 154.64947271716136 "$node_(32) setdest 1760 798 12.0" 
$ns at 221.7210214516887 "$node_(32) setdest 2348 180 3.0" 
$ns at 279.7041068008282 "$node_(32) setdest 1552 924 4.0" 
$ns at 336.96915745009323 "$node_(32) setdest 2948 259 2.0" 
$ns at 371.2928564571457 "$node_(32) setdest 2239 543 1.0" 
$ns at 409.4828483186345 "$node_(32) setdest 2145 511 8.0" 
$ns at 481.05657768935123 "$node_(32) setdest 540 159 9.0" 
$ns at 518.2752853398646 "$node_(32) setdest 665 422 1.0" 
$ns at 552.4708210415065 "$node_(32) setdest 1614 998 7.0" 
$ns at 625.036601399017 "$node_(32) setdest 585 824 15.0" 
$ns at 733.1583579280374 "$node_(32) setdest 2638 735 4.0" 
$ns at 787.253392743308 "$node_(32) setdest 2986 772 19.0" 
$ns at 0.0 "$node_(33) setdest 1018 480 14.0" 
$ns at 63.025637178377764 "$node_(33) setdest 444 259 2.0" 
$ns at 94.80586182269101 "$node_(33) setdest 110 515 4.0" 
$ns at 145.37839653157113 "$node_(33) setdest 2128 913 1.0" 
$ns at 176.49923637808422 "$node_(33) setdest 1068 523 13.0" 
$ns at 288.4501326471732 "$node_(33) setdest 995 6 7.0" 
$ns at 325.97382887294907 "$node_(33) setdest 186 295 8.0" 
$ns at 405.0517194815719 "$node_(33) setdest 312 412 11.0" 
$ns at 501.48879896587334 "$node_(33) setdest 2867 148 5.0" 
$ns at 547.7365933202266 "$node_(33) setdest 1532 366 3.0" 
$ns at 593.9754172020253 "$node_(33) setdest 74 556 3.0" 
$ns at 626.9921878991131 "$node_(33) setdest 235 143 20.0" 
$ns at 754.8369868812231 "$node_(33) setdest 902 714 12.0" 
$ns at 855.6572863113702 "$node_(33) setdest 1663 13 17.0" 
$ns at 0.0 "$node_(34) setdest 2622 42 7.0" 
$ns at 71.72216176093806 "$node_(34) setdest 2068 94 14.0" 
$ns at 196.71567737079957 "$node_(34) setdest 2342 851 1.0" 
$ns at 236.3164100929671 "$node_(34) setdest 2886 963 1.0" 
$ns at 268.0172490953193 "$node_(34) setdest 2131 673 5.0" 
$ns at 338.0747935244268 "$node_(34) setdest 2479 129 12.0" 
$ns at 462.2512446092639 "$node_(34) setdest 2245 979 4.0" 
$ns at 518.3704553053495 "$node_(34) setdest 937 752 8.0" 
$ns at 559.6652400789328 "$node_(34) setdest 1824 290 11.0" 
$ns at 623.0561290046674 "$node_(34) setdest 189 201 7.0" 
$ns at 704.194947503382 "$node_(34) setdest 164 903 20.0" 
$ns at 811.5570330901401 "$node_(34) setdest 422 322 7.0" 
$ns at 0.0 "$node_(35) setdest 1465 731 14.0" 
$ns at 33.82897269169272 "$node_(35) setdest 547 533 10.0" 
$ns at 126.29910666742327 "$node_(35) setdest 2650 995 7.0" 
$ns at 162.52643310975526 "$node_(35) setdest 2219 107 19.0" 
$ns at 351.20947388282815 "$node_(35) setdest 1633 743 1.0" 
$ns at 389.4870972621808 "$node_(35) setdest 2640 248 5.0" 
$ns at 439.9366034895071 "$node_(35) setdest 1170 456 17.0" 
$ns at 470.0574157829178 "$node_(35) setdest 1164 839 7.0" 
$ns at 557.3854923570024 "$node_(35) setdest 2143 214 6.0" 
$ns at 631.202986248483 "$node_(35) setdest 426 958 17.0" 
$ns at 792.7681938788651 "$node_(35) setdest 1916 160 7.0" 
$ns at 870.0982359368285 "$node_(35) setdest 1510 544 14.0" 
$ns at 0.0 "$node_(36) setdest 2125 257 19.0" 
$ns at 89.73852467209386 "$node_(36) setdest 2395 809 20.0" 
$ns at 288.571232241743 "$node_(36) setdest 1020 578 6.0" 
$ns at 341.1084310537261 "$node_(36) setdest 667 264 14.0" 
$ns at 464.55055808100224 "$node_(36) setdest 249 605 3.0" 
$ns at 516.8047791369952 "$node_(36) setdest 2261 486 14.0" 
$ns at 565.5120619166433 "$node_(36) setdest 2673 290 1.0" 
$ns at 599.0497395171833 "$node_(36) setdest 2713 968 9.0" 
$ns at 664.099938056602 "$node_(36) setdest 2615 854 5.0" 
$ns at 740.5558294222544 "$node_(36) setdest 1175 676 4.0" 
$ns at 781.3510373307665 "$node_(36) setdest 644 573 16.0" 
$ns at 898.0722493031902 "$node_(36) setdest 189 184 14.0" 
$ns at 0.0 "$node_(37) setdest 776 29 12.0" 
$ns at 73.82928187312781 "$node_(37) setdest 1968 479 3.0" 
$ns at 133.47757035766392 "$node_(37) setdest 2703 573 18.0" 
$ns at 186.08745947506097 "$node_(37) setdest 670 828 1.0" 
$ns at 221.6133214558322 "$node_(37) setdest 2432 984 16.0" 
$ns at 263.31943581812806 "$node_(37) setdest 927 288 1.0" 
$ns at 302.2743301542236 "$node_(37) setdest 446 560 8.0" 
$ns at 373.4972045753144 "$node_(37) setdest 609 750 4.0" 
$ns at 408.04895321745306 "$node_(37) setdest 2264 137 10.0" 
$ns at 459.6773841482871 "$node_(37) setdest 2587 617 3.0" 
$ns at 504.7567106894701 "$node_(37) setdest 20 765 17.0" 
$ns at 571.0178842625857 "$node_(37) setdest 965 477 15.0" 
$ns at 683.782921989596 "$node_(37) setdest 2427 35 17.0" 
$ns at 858.1695099870841 "$node_(37) setdest 2061 392 1.0" 
$ns at 888.4490586456843 "$node_(37) setdest 1256 297 19.0" 
$ns at 0.0 "$node_(38) setdest 100 666 13.0" 
$ns at 136.54516514599118 "$node_(38) setdest 192 248 12.0" 
$ns at 204.1972465554398 "$node_(38) setdest 2391 195 3.0" 
$ns at 248.26422788916494 "$node_(38) setdest 1696 644 16.0" 
$ns at 351.807030450251 "$node_(38) setdest 1465 773 20.0" 
$ns at 495.40201629693036 "$node_(38) setdest 1241 101 11.0" 
$ns at 610.9519448664008 "$node_(38) setdest 2431 967 18.0" 
$ns at 720.8584023271487 "$node_(38) setdest 33 255 8.0" 
$ns at 813.9627136082677 "$node_(38) setdest 1549 414 9.0" 
$ns at 0.0 "$node_(39) setdest 115 733 6.0" 
$ns at 55.23052639014985 "$node_(39) setdest 1750 667 10.0" 
$ns at 115.59889491699171 "$node_(39) setdest 441 706 14.0" 
$ns at 283.06942548934785 "$node_(39) setdest 1618 943 2.0" 
$ns at 315.0943496143133 "$node_(39) setdest 1316 991 14.0" 
$ns at 451.7156964500176 "$node_(39) setdest 70 390 16.0" 
$ns at 483.6040577108691 "$node_(39) setdest 1317 946 11.0" 
$ns at 546.5455718738556 "$node_(39) setdest 2727 736 9.0" 
$ns at 643.9902419160335 "$node_(39) setdest 1557 654 12.0" 
$ns at 750.0847822240828 "$node_(39) setdest 1731 438 9.0" 
$ns at 806.6509032470574 "$node_(39) setdest 2924 122 17.0" 
$ns at 849.4489126190764 "$node_(39) setdest 502 681 14.0" 
$ns at 0.0 "$node_(40) setdest 666 491 18.0" 
$ns at 84.55616355628644 "$node_(40) setdest 2673 855 3.0" 
$ns at 131.47063564361974 "$node_(40) setdest 2430 494 18.0" 
$ns at 313.48311211852103 "$node_(40) setdest 2212 371 14.0" 
$ns at 404.11886810383845 "$node_(40) setdest 646 650 7.0" 
$ns at 450.0672714948596 "$node_(40) setdest 462 911 5.0" 
$ns at 485.07617264849677 "$node_(40) setdest 1858 929 9.0" 
$ns at 548.0107077469628 "$node_(40) setdest 1612 511 19.0" 
$ns at 753.1514472156566 "$node_(40) setdest 384 880 17.0" 
$ns at 0.0 "$node_(41) setdest 1829 47 16.0" 
$ns at 32.894257333980086 "$node_(41) setdest 429 467 16.0" 
$ns at 69.11415483490651 "$node_(41) setdest 60 28 12.0" 
$ns at 124.99672519021925 "$node_(41) setdest 2509 80 11.0" 
$ns at 236.5414409269494 "$node_(41) setdest 2242 778 8.0" 
$ns at 305.8337175934139 "$node_(41) setdest 2819 487 7.0" 
$ns at 350.85604980889656 "$node_(41) setdest 417 389 10.0" 
$ns at 389.90836524680526 "$node_(41) setdest 912 690 2.0" 
$ns at 422.05940575124055 "$node_(41) setdest 2006 52 12.0" 
$ns at 542.1448635932417 "$node_(41) setdest 2808 943 15.0" 
$ns at 707.4973040182523 "$node_(41) setdest 2223 626 5.0" 
$ns at 772.4254763279532 "$node_(41) setdest 1408 404 6.0" 
$ns at 821.7148820581122 "$node_(41) setdest 392 565 8.0" 
$ns at 879.98124028504 "$node_(41) setdest 832 180 1.0" 
$ns at 0.0 "$node_(42) setdest 2648 565 20.0" 
$ns at 211.6729271002137 "$node_(42) setdest 2055 721 11.0" 
$ns at 330.99962757396304 "$node_(42) setdest 2284 534 3.0" 
$ns at 367.5339506471994 "$node_(42) setdest 2949 843 6.0" 
$ns at 405.8094171613565 "$node_(42) setdest 1723 768 13.0" 
$ns at 522.1367567732125 "$node_(42) setdest 629 825 9.0" 
$ns at 580.3392621119007 "$node_(42) setdest 2869 427 10.0" 
$ns at 703.5144079322031 "$node_(42) setdest 2691 358 17.0" 
$ns at 881.5786096698446 "$node_(42) setdest 1346 681 14.0" 
$ns at 0.0 "$node_(43) setdest 743 301 17.0" 
$ns at 53.62584861923254 "$node_(43) setdest 2839 149 13.0" 
$ns at 191.21611050515844 "$node_(43) setdest 1328 502 11.0" 
$ns at 293.8259870970628 "$node_(43) setdest 2569 480 2.0" 
$ns at 329.0244169891591 "$node_(43) setdest 125 175 6.0" 
$ns at 365.07425459461274 "$node_(43) setdest 1627 190 19.0" 
$ns at 457.4619754802074 "$node_(43) setdest 2036 548 13.0" 
$ns at 513.7510220949772 "$node_(43) setdest 2659 136 9.0" 
$ns at 622.3402470144807 "$node_(43) setdest 1547 799 12.0" 
$ns at 721.0498050161538 "$node_(43) setdest 173 218 9.0" 
$ns at 756.6785135671286 "$node_(43) setdest 462 498 16.0" 
$ns at 846.3845511202321 "$node_(43) setdest 2435 183 13.0" 
$ns at 0.0 "$node_(44) setdest 2904 53 8.0" 
$ns at 45.801520351048225 "$node_(44) setdest 2716 646 4.0" 
$ns at 85.76325327449106 "$node_(44) setdest 189 896 12.0" 
$ns at 199.19372743334029 "$node_(44) setdest 1388 688 19.0" 
$ns at 293.2021029561389 "$node_(44) setdest 946 391 18.0" 
$ns at 456.58852690513646 "$node_(44) setdest 1105 641 2.0" 
$ns at 503.6132971655701 "$node_(44) setdest 614 721 9.0" 
$ns at 551.5779183392701 "$node_(44) setdest 72 934 17.0" 
$ns at 686.7041943770214 "$node_(44) setdest 1167 213 17.0" 
$ns at 816.5938127349882 "$node_(44) setdest 150 98 14.0" 
$ns at 846.6978844464293 "$node_(44) setdest 718 869 18.0" 
$ns at 0.0 "$node_(45) setdest 2280 309 20.0" 
$ns at 120.4282501800254 "$node_(45) setdest 2339 70 6.0" 
$ns at 173.3605835457116 "$node_(45) setdest 1494 70 12.0" 
$ns at 226.24254486626594 "$node_(45) setdest 2245 705 20.0" 
$ns at 327.9130864982958 "$node_(45) setdest 486 901 19.0" 
$ns at 484.2284187608433 "$node_(45) setdest 2202 202 17.0" 
$ns at 568.0420301530269 "$node_(45) setdest 1510 152 13.0" 
$ns at 694.0457735923213 "$node_(45) setdest 1776 209 8.0" 
$ns at 796.2168698338238 "$node_(45) setdest 78 298 5.0" 
$ns at 864.7732354693994 "$node_(45) setdest 1808 908 14.0" 
$ns at 0.0 "$node_(46) setdest 1731 327 17.0" 
$ns at 33.10014631717324 "$node_(46) setdest 216 198 14.0" 
$ns at 188.13663101987663 "$node_(46) setdest 2855 98 2.0" 
$ns at 218.7047623693 "$node_(46) setdest 1017 246 3.0" 
$ns at 258.6681149646776 "$node_(46) setdest 303 763 1.0" 
$ns at 298.29302386475956 "$node_(46) setdest 1172 129 19.0" 
$ns at 451.41458253001224 "$node_(46) setdest 2314 628 5.0" 
$ns at 481.95187664048154 "$node_(46) setdest 1639 570 17.0" 
$ns at 533.6357431224408 "$node_(46) setdest 1969 72 6.0" 
$ns at 583.6587860973478 "$node_(46) setdest 2741 990 18.0" 
$ns at 694.7896521741511 "$node_(46) setdest 1201 364 17.0" 
$ns at 759.2399508316818 "$node_(46) setdest 1737 390 8.0" 
$ns at 835.2373999996244 "$node_(46) setdest 75 524 2.0" 
$ns at 870.5412978832034 "$node_(46) setdest 2198 765 4.0" 
$ns at 0.0 "$node_(47) setdest 1855 562 7.0" 
$ns at 37.85551943621455 "$node_(47) setdest 578 76 19.0" 
$ns at 153.03852407567808 "$node_(47) setdest 1107 721 4.0" 
$ns at 205.89750548383398 "$node_(47) setdest 86 989 7.0" 
$ns at 257.55784295501616 "$node_(47) setdest 812 596 3.0" 
$ns at 299.6746793402381 "$node_(47) setdest 738 884 20.0" 
$ns at 393.60246708886893 "$node_(47) setdest 260 220 3.0" 
$ns at 433.4534386480424 "$node_(47) setdest 2208 876 13.0" 
$ns at 574.9012855936189 "$node_(47) setdest 1202 502 10.0" 
$ns at 659.9686030107478 "$node_(47) setdest 2854 817 5.0" 
$ns at 707.8021485256189 "$node_(47) setdest 2522 620 13.0" 
$ns at 766.7211828757999 "$node_(47) setdest 25 541 16.0" 
$ns at 0.0 "$node_(48) setdest 2411 229 4.0" 
$ns at 50.236910598839586 "$node_(48) setdest 539 822 14.0" 
$ns at 187.37667064207253 "$node_(48) setdest 799 609 18.0" 
$ns at 248.00377038540753 "$node_(48) setdest 2946 792 15.0" 
$ns at 364.82172627078944 "$node_(48) setdest 1531 100 10.0" 
$ns at 484.2899766422672 "$node_(48) setdest 938 812 8.0" 
$ns at 544.3886046361062 "$node_(48) setdest 2554 457 2.0" 
$ns at 588.5140357759076 "$node_(48) setdest 1039 13 19.0" 
$ns at 641.3537745494568 "$node_(48) setdest 2078 971 17.0" 
$ns at 709.520739225901 "$node_(48) setdest 443 27 6.0" 
$ns at 792.1121842294755 "$node_(48) setdest 1490 477 3.0" 
$ns at 841.3767053193052 "$node_(48) setdest 621 620 15.0" 
$ns at 0.0 "$node_(49) setdest 1494 611 8.0" 
$ns at 79.26929588211257 "$node_(49) setdest 1060 223 14.0" 
$ns at 135.21147637665047 "$node_(49) setdest 740 935 2.0" 
$ns at 175.07710863199196 "$node_(49) setdest 2271 611 13.0" 
$ns at 275.3818588770551 "$node_(49) setdest 921 778 2.0" 
$ns at 316.42202531645967 "$node_(49) setdest 2924 194 12.0" 
$ns at 403.3333777332921 "$node_(49) setdest 2102 925 16.0" 
$ns at 461.5720850051281 "$node_(49) setdest 733 686 4.0" 
$ns at 509.69398891242895 "$node_(49) setdest 2759 505 3.0" 
$ns at 544.1473443674054 "$node_(49) setdest 1472 122 11.0" 
$ns at 610.7335169403697 "$node_(49) setdest 1793 692 5.0" 
$ns at 664.5659500765335 "$node_(49) setdest 2226 460 3.0" 
$ns at 694.7517858623369 "$node_(49) setdest 495 93 19.0" 
$ns at 808.7128283257941 "$node_(49) setdest 2766 271 15.0" 
$ns at 0.0 "$node_(50) setdest 230 919 11.0" 
$ns at 116.11842355333982 "$node_(50) setdest 655 244 1.0" 
$ns at 152.1156999601764 "$node_(50) setdest 1313 316 10.0" 
$ns at 201.997232076309 "$node_(50) setdest 1466 496 10.0" 
$ns at 252.30930880651186 "$node_(50) setdest 342 467 13.0" 
$ns at 359.5835125492032 "$node_(50) setdest 1225 926 18.0" 
$ns at 412.36642317583255 "$node_(50) setdest 1978 322 9.0" 
$ns at 509.27101264642096 "$node_(50) setdest 958 102 8.0" 
$ns at 618.4040915836033 "$node_(50) setdest 1906 75 17.0" 
$ns at 698.6807051921737 "$node_(50) setdest 2957 418 17.0" 
$ns at 785.0190839600245 "$node_(50) setdest 501 753 9.0" 
$ns at 842.4796665450951 "$node_(50) setdest 2135 516 2.0" 
$ns at 877.158225932468 "$node_(50) setdest 2412 518 1.0" 
$ns at 324.86592338427005 "$node_(51) setdest 2480 409 9.0" 
$ns at 393.0292796414635 "$node_(51) setdest 828 58 2.0" 
$ns at 435.9654471947224 "$node_(51) setdest 1889 47 10.0" 
$ns at 503.9649218412794 "$node_(51) setdest 2655 298 19.0" 
$ns at 665.4745123056274 "$node_(51) setdest 2671 93 2.0" 
$ns at 711.6374163254021 "$node_(51) setdest 1740 606 17.0" 
$ns at 879.9986176839299 "$node_(51) setdest 1933 447 20.0" 
$ns at 169.47443288483228 "$node_(52) setdest 1171 940 14.0" 
$ns at 317.23946284451813 "$node_(52) setdest 2499 607 1.0" 
$ns at 348.28176188059456 "$node_(52) setdest 1721 410 15.0" 
$ns at 502.7840476673806 "$node_(52) setdest 1338 364 5.0" 
$ns at 576.3464062500287 "$node_(52) setdest 2403 167 7.0" 
$ns at 621.0298532207952 "$node_(52) setdest 508 131 19.0" 
$ns at 778.5174562318348 "$node_(52) setdest 2204 357 7.0" 
$ns at 834.7692025515603 "$node_(52) setdest 2841 221 5.0" 
$ns at 873.5335259084236 "$node_(52) setdest 2652 960 6.0" 
$ns at 304.8237988442283 "$node_(53) setdest 1073 554 15.0" 
$ns at 421.3921411696471 "$node_(53) setdest 2900 4 11.0" 
$ns at 479.3161981710335 "$node_(53) setdest 2749 220 1.0" 
$ns at 516.6659196780327 "$node_(53) setdest 1830 840 16.0" 
$ns at 630.79378622862 "$node_(53) setdest 1025 119 11.0" 
$ns at 748.6335664992671 "$node_(53) setdest 1554 590 5.0" 
$ns at 809.1829404658896 "$node_(53) setdest 2742 24 16.0" 
$ns at 195.14890892390346 "$node_(54) setdest 549 75 15.0" 
$ns at 240.47072888190863 "$node_(54) setdest 399 525 20.0" 
$ns at 273.3041325798066 "$node_(54) setdest 1240 394 7.0" 
$ns at 304.5370109920166 "$node_(54) setdest 589 330 8.0" 
$ns at 411.21941291995745 "$node_(54) setdest 654 289 14.0" 
$ns at 544.6183847344402 "$node_(54) setdest 1886 583 15.0" 
$ns at 638.9395801790729 "$node_(54) setdest 2533 809 10.0" 
$ns at 725.9915217824396 "$node_(54) setdest 1178 240 19.0" 
$ns at 815.4614118749588 "$node_(54) setdest 2391 1 10.0" 
$ns at 186.59386731092368 "$node_(55) setdest 2934 559 5.0" 
$ns at 244.84421564575032 "$node_(55) setdest 1847 328 17.0" 
$ns at 395.50171836294066 "$node_(55) setdest 2315 958 19.0" 
$ns at 577.3144043632348 "$node_(55) setdest 2349 460 7.0" 
$ns at 676.3009052455566 "$node_(55) setdest 1571 637 1.0" 
$ns at 712.1158491309365 "$node_(55) setdest 1307 257 3.0" 
$ns at 762.8183099281548 "$node_(55) setdest 2146 189 14.0" 
$ns at 888.123960469753 "$node_(55) setdest 2034 951 3.0" 
$ns at 199.0461961511136 "$node_(56) setdest 2373 440 9.0" 
$ns at 286.66546155521075 "$node_(56) setdest 579 214 20.0" 
$ns at 340.8272365025026 "$node_(56) setdest 1370 590 12.0" 
$ns at 487.9562195545653 "$node_(56) setdest 1478 4 8.0" 
$ns at 589.0803063755704 "$node_(56) setdest 967 776 7.0" 
$ns at 647.191881457698 "$node_(56) setdest 1390 371 11.0" 
$ns at 766.9319547004113 "$node_(56) setdest 2126 911 4.0" 
$ns at 798.9215703839267 "$node_(56) setdest 2537 745 1.0" 
$ns at 831.0675340076863 "$node_(56) setdest 1989 414 14.0" 
$ns at 863.076685262898 "$node_(56) setdest 188 720 11.0" 
$ns at 187.6729296076674 "$node_(57) setdest 1020 976 13.0" 
$ns at 244.04768972659338 "$node_(57) setdest 487 627 8.0" 
$ns at 284.60163103121675 "$node_(57) setdest 1840 279 14.0" 
$ns at 350.695035513905 "$node_(57) setdest 644 920 9.0" 
$ns at 381.69676791164517 "$node_(57) setdest 189 91 1.0" 
$ns at 420.8124640304179 "$node_(57) setdest 2066 631 9.0" 
$ns at 534.4499574567704 "$node_(57) setdest 1868 171 11.0" 
$ns at 604.4855878991533 "$node_(57) setdest 716 36 17.0" 
$ns at 773.4070690624544 "$node_(57) setdest 384 649 3.0" 
$ns at 804.6960272085233 "$node_(57) setdest 1799 766 19.0" 
$ns at 848.7543501867796 "$node_(57) setdest 2697 106 13.0" 
$ns at 884.3380440854493 "$node_(57) setdest 1165 6 6.0" 
$ns at 304.84371924030734 "$node_(58) setdest 875 90 14.0" 
$ns at 455.0654951905291 "$node_(58) setdest 908 947 1.0" 
$ns at 485.4736917061645 "$node_(58) setdest 215 795 2.0" 
$ns at 523.3963326872475 "$node_(58) setdest 1481 534 18.0" 
$ns at 625.9817555141998 "$node_(58) setdest 1465 645 18.0" 
$ns at 729.747440779674 "$node_(58) setdest 1586 972 10.0" 
$ns at 801.7870024991173 "$node_(58) setdest 2683 782 12.0" 
$ns at 189.5119472506663 "$node_(59) setdest 98 554 9.0" 
$ns at 309.0066072001173 "$node_(59) setdest 1674 756 7.0" 
$ns at 354.30820159673004 "$node_(59) setdest 1855 697 19.0" 
$ns at 402.2086672671183 "$node_(59) setdest 753 221 20.0" 
$ns at 595.3146432183426 "$node_(59) setdest 31 580 5.0" 
$ns at 640.9489793746664 "$node_(59) setdest 1302 435 12.0" 
$ns at 773.72327884584 "$node_(59) setdest 616 108 1.0" 
$ns at 807.3222951379886 "$node_(59) setdest 1684 136 8.0" 
$ns at 839.5840325577136 "$node_(59) setdest 1807 231 10.0" 
$ns at 198.66004619356062 "$node_(60) setdest 36 977 5.0" 
$ns at 274.6570423314722 "$node_(60) setdest 2896 928 19.0" 
$ns at 320.25877376714334 "$node_(60) setdest 855 500 12.0" 
$ns at 411.43869948718503 "$node_(60) setdest 33 904 16.0" 
$ns at 543.6937405223836 "$node_(60) setdest 628 763 12.0" 
$ns at 690.9399287497799 "$node_(60) setdest 958 121 7.0" 
$ns at 745.9951521970786 "$node_(60) setdest 1851 852 10.0" 
$ns at 788.5270444984417 "$node_(60) setdest 1317 791 4.0" 
$ns at 828.2337367326736 "$node_(60) setdest 410 890 2.0" 
$ns at 861.5719412261241 "$node_(60) setdest 2043 602 8.0" 
$ns at 221.07066690008833 "$node_(61) setdest 439 645 9.0" 
$ns at 257.1289032177607 "$node_(61) setdest 134 621 1.0" 
$ns at 294.46957943142337 "$node_(61) setdest 1042 332 11.0" 
$ns at 367.48175361453644 "$node_(61) setdest 1205 278 3.0" 
$ns at 422.6385607977819 "$node_(61) setdest 675 480 10.0" 
$ns at 503.4846620000169 "$node_(61) setdest 2709 657 2.0" 
$ns at 545.8194204529227 "$node_(61) setdest 1213 299 8.0" 
$ns at 610.1544891236404 "$node_(61) setdest 2030 673 14.0" 
$ns at 662.2839590047795 "$node_(61) setdest 2175 604 11.0" 
$ns at 705.7727383736249 "$node_(61) setdest 2641 563 5.0" 
$ns at 752.1092199703706 "$node_(61) setdest 1816 186 4.0" 
$ns at 803.4519322461816 "$node_(61) setdest 25 860 3.0" 
$ns at 840.9643746859472 "$node_(61) setdest 2067 419 14.0" 
$ns at 171.29734294542453 "$node_(62) setdest 2114 136 11.0" 
$ns at 298.09690094074506 "$node_(62) setdest 2641 701 9.0" 
$ns at 338.61235147498166 "$node_(62) setdest 1839 146 3.0" 
$ns at 369.3086841701651 "$node_(62) setdest 2944 694 6.0" 
$ns at 416.5772272204133 "$node_(62) setdest 2419 734 13.0" 
$ns at 470.7538672235503 "$node_(62) setdest 962 403 6.0" 
$ns at 523.5464364363991 "$node_(62) setdest 266 703 6.0" 
$ns at 580.4946245721701 "$node_(62) setdest 1672 155 17.0" 
$ns at 617.3754294742595 "$node_(62) setdest 904 388 16.0" 
$ns at 764.6506884829901 "$node_(62) setdest 1131 295 3.0" 
$ns at 804.5438688037339 "$node_(62) setdest 543 650 4.0" 
$ns at 846.849227287247 "$node_(62) setdest 2638 115 18.0" 
$ns at 172.4150571205109 "$node_(63) setdest 2837 241 6.0" 
$ns at 207.9124634548703 "$node_(63) setdest 1446 5 13.0" 
$ns at 302.7568036808053 "$node_(63) setdest 2828 173 16.0" 
$ns at 473.02063050352854 "$node_(63) setdest 2767 422 17.0" 
$ns at 620.9863391372651 "$node_(63) setdest 2649 337 10.0" 
$ns at 716.0269815608149 "$node_(63) setdest 468 957 12.0" 
$ns at 858.2579834274815 "$node_(63) setdest 2135 295 14.0" 
$ns at 246.62720718772786 "$node_(64) setdest 95 39 4.0" 
$ns at 316.38085529949785 "$node_(64) setdest 1268 50 1.0" 
$ns at 346.483296189459 "$node_(64) setdest 1615 867 5.0" 
$ns at 395.4979515224398 "$node_(64) setdest 563 547 8.0" 
$ns at 504.083491918817 "$node_(64) setdest 822 416 6.0" 
$ns at 541.0132740187165 "$node_(64) setdest 2239 181 2.0" 
$ns at 588.9959840145511 "$node_(64) setdest 459 673 18.0" 
$ns at 688.9270757537759 "$node_(64) setdest 2238 460 8.0" 
$ns at 751.9632398670287 "$node_(64) setdest 1488 693 19.0" 
$ns at 800.9781535168277 "$node_(64) setdest 1462 598 18.0" 
$ns at 217.23093772453387 "$node_(65) setdest 501 440 18.0" 
$ns at 368.05342897115105 "$node_(65) setdest 2019 6 10.0" 
$ns at 448.4836435082689 "$node_(65) setdest 464 535 3.0" 
$ns at 506.672106545805 "$node_(65) setdest 1912 607 6.0" 
$ns at 572.8631476494187 "$node_(65) setdest 554 694 15.0" 
$ns at 616.4715333467216 "$node_(65) setdest 937 367 2.0" 
$ns at 658.2849721130483 "$node_(65) setdest 2328 598 1.0" 
$ns at 690.3933395722089 "$node_(65) setdest 1485 752 1.0" 
$ns at 721.9534451885963 "$node_(65) setdest 1089 816 1.0" 
$ns at 753.3856009072117 "$node_(65) setdest 895 209 19.0" 
$ns at 799.8570678079244 "$node_(65) setdest 534 235 12.0" 
$ns at 846.2406252948314 "$node_(65) setdest 689 878 9.0" 
$ns at 204.20324973339322 "$node_(66) setdest 2364 433 11.0" 
$ns at 305.6813958494241 "$node_(66) setdest 717 916 19.0" 
$ns at 388.353016866924 "$node_(66) setdest 1091 814 4.0" 
$ns at 453.6776727158157 "$node_(66) setdest 2894 714 11.0" 
$ns at 498.42230675555334 "$node_(66) setdest 2602 329 2.0" 
$ns at 538.4258065180136 "$node_(66) setdest 952 426 20.0" 
$ns at 628.4166426027579 "$node_(66) setdest 1084 114 20.0" 
$ns at 783.3544169693181 "$node_(66) setdest 1101 934 10.0" 
$ns at 866.917769013264 "$node_(66) setdest 2000 700 1.0" 
$ns at 899.5080009523657 "$node_(66) setdest 2293 438 6.0" 
$ns at 172.79031348000535 "$node_(67) setdest 2119 8 14.0" 
$ns at 276.4929818177119 "$node_(67) setdest 1694 871 7.0" 
$ns at 356.0039754356188 "$node_(67) setdest 1422 739 15.0" 
$ns at 445.45791777957055 "$node_(67) setdest 323 610 13.0" 
$ns at 580.6298269368353 "$node_(67) setdest 714 714 4.0" 
$ns at 618.4071387489084 "$node_(67) setdest 661 28 9.0" 
$ns at 662.4032864255445 "$node_(67) setdest 305 301 2.0" 
$ns at 702.6602280886063 "$node_(67) setdest 1556 426 4.0" 
$ns at 737.1409556930778 "$node_(67) setdest 1734 479 2.0" 
$ns at 782.647125770963 "$node_(67) setdest 1812 104 19.0" 
$ns at 202.46899305359432 "$node_(68) setdest 2967 37 18.0" 
$ns at 267.4234728528143 "$node_(68) setdest 2998 693 7.0" 
$ns at 334.8575958145408 "$node_(68) setdest 2796 519 5.0" 
$ns at 407.99634582181716 "$node_(68) setdest 1904 179 16.0" 
$ns at 567.8925733166709 "$node_(68) setdest 659 768 5.0" 
$ns at 610.8541817063483 "$node_(68) setdest 1839 316 11.0" 
$ns at 651.4440506172037 "$node_(68) setdest 1518 509 7.0" 
$ns at 749.2379877205237 "$node_(68) setdest 2966 577 9.0" 
$ns at 831.2358179376128 "$node_(68) setdest 1100 428 7.0" 
$ns at 199.17265522418342 "$node_(69) setdest 2733 270 10.0" 
$ns at 275.9202514306928 "$node_(69) setdest 434 661 4.0" 
$ns at 327.70341105375513 "$node_(69) setdest 2305 317 15.0" 
$ns at 497.8311052115009 "$node_(69) setdest 247 245 6.0" 
$ns at 562.6911974421145 "$node_(69) setdest 779 394 15.0" 
$ns at 626.9947945642149 "$node_(69) setdest 1852 757 14.0" 
$ns at 751.0375137898307 "$node_(69) setdest 848 972 5.0" 
$ns at 818.7868890357478 "$node_(69) setdest 1329 83 15.0" 
$ns at 280.8346154574021 "$node_(70) setdest 2418 584 11.0" 
$ns at 359.8562043005736 "$node_(70) setdest 2720 126 20.0" 
$ns at 423.73021991432233 "$node_(70) setdest 2839 762 8.0" 
$ns at 519.5886852516848 "$node_(70) setdest 298 116 4.0" 
$ns at 569.8629438403747 "$node_(70) setdest 2222 160 2.0" 
$ns at 609.6656314587439 "$node_(70) setdest 2240 314 1.0" 
$ns at 640.1638631173275 "$node_(70) setdest 1472 76 9.0" 
$ns at 684.4115051409088 "$node_(70) setdest 2436 108 6.0" 
$ns at 753.4930708359757 "$node_(70) setdest 1625 703 2.0" 
$ns at 790.1887363928055 "$node_(70) setdest 417 483 19.0" 
$ns at 165.42673284846677 "$node_(71) setdest 514 441 1.0" 
$ns at 195.9089089265072 "$node_(71) setdest 52 39 13.0" 
$ns at 340.6456506161556 "$node_(71) setdest 635 729 16.0" 
$ns at 511.1882013770732 "$node_(71) setdest 2671 62 11.0" 
$ns at 544.185799188243 "$node_(71) setdest 2759 99 11.0" 
$ns at 637.3340111200084 "$node_(71) setdest 2100 84 6.0" 
$ns at 680.1404587210295 "$node_(71) setdest 36 619 15.0" 
$ns at 842.1865407093317 "$node_(71) setdest 2044 180 11.0" 
$ns at 311.8795821472877 "$node_(72) setdest 1945 777 17.0" 
$ns at 488.73974609507695 "$node_(72) setdest 1914 483 15.0" 
$ns at 603.3629100671208 "$node_(72) setdest 2087 309 13.0" 
$ns at 637.6783264047978 "$node_(72) setdest 2053 881 12.0" 
$ns at 683.3575510075477 "$node_(72) setdest 2937 290 7.0" 
$ns at 723.4570413308854 "$node_(72) setdest 453 281 18.0" 
$ns at 884.7678502040382 "$node_(72) setdest 1701 90 3.0" 
$ns at 237.6841552012994 "$node_(73) setdest 506 46 2.0" 
$ns at 271.01855812414493 "$node_(73) setdest 1643 939 14.0" 
$ns at 386.9048743820625 "$node_(73) setdest 354 601 3.0" 
$ns at 425.9991963461574 "$node_(73) setdest 1461 266 5.0" 
$ns at 486.7026496909122 "$node_(73) setdest 2221 655 5.0" 
$ns at 552.981891810861 "$node_(73) setdest 1119 872 4.0" 
$ns at 587.5991038479875 "$node_(73) setdest 927 855 1.0" 
$ns at 619.0065446496916 "$node_(73) setdest 2084 959 19.0" 
$ns at 741.3019783882892 "$node_(73) setdest 1382 278 1.0" 
$ns at 772.2255623717223 "$node_(73) setdest 1819 175 9.0" 
$ns at 840.8118739890695 "$node_(73) setdest 2363 358 1.0" 
$ns at 876.7846183931007 "$node_(73) setdest 212 527 15.0" 
$ns at 194.70544812349095 "$node_(74) setdest 675 403 15.0" 
$ns at 276.704418746 "$node_(74) setdest 81 952 4.0" 
$ns at 345.7402790744994 "$node_(74) setdest 1010 784 5.0" 
$ns at 392.17503920765853 "$node_(74) setdest 325 326 19.0" 
$ns at 466.6144838885143 "$node_(74) setdest 872 541 9.0" 
$ns at 505.41880687758413 "$node_(74) setdest 2259 475 8.0" 
$ns at 591.921629114593 "$node_(74) setdest 2713 807 16.0" 
$ns at 742.2924125431332 "$node_(74) setdest 2246 540 19.0" 
$ns at 868.0287005315632 "$node_(74) setdest 1797 642 1.0" 
$ns at 354.6390065207168 "$node_(75) setdest 1831 606 11.0" 
$ns at 386.97783452973965 "$node_(75) setdest 52 383 3.0" 
$ns at 427.0484117241463 "$node_(75) setdest 2765 770 5.0" 
$ns at 489.5701987082829 "$node_(75) setdest 336 358 5.0" 
$ns at 537.8918080780641 "$node_(75) setdest 527 640 3.0" 
$ns at 583.6668393121996 "$node_(75) setdest 110 317 9.0" 
$ns at 643.4766229566332 "$node_(75) setdest 21 443 3.0" 
$ns at 676.3945401389956 "$node_(75) setdest 1349 68 9.0" 
$ns at 752.5427313495359 "$node_(75) setdest 1483 329 6.0" 
$ns at 824.8462902435506 "$node_(75) setdest 712 126 1.0" 
$ns at 861.0421248800742 "$node_(75) setdest 1557 621 17.0" 
$ns at 350.6950755419935 "$node_(76) setdest 505 528 12.0" 
$ns at 399.74142107585175 "$node_(76) setdest 15 867 6.0" 
$ns at 451.5442326322411 "$node_(76) setdest 299 234 11.0" 
$ns at 506.6648566528762 "$node_(76) setdest 586 316 3.0" 
$ns at 543.2954855190085 "$node_(76) setdest 1024 984 14.0" 
$ns at 642.8904864935605 "$node_(76) setdest 821 764 5.0" 
$ns at 677.8442187514854 "$node_(76) setdest 454 448 7.0" 
$ns at 714.5064038733389 "$node_(76) setdest 2321 942 13.0" 
$ns at 797.4731530928318 "$node_(76) setdest 1727 350 5.0" 
$ns at 866.6961955292238 "$node_(76) setdest 1631 68 3.0" 
$ns at 343.3113842946724 "$node_(77) setdest 2490 377 3.0" 
$ns at 378.17038413179256 "$node_(77) setdest 2103 861 8.0" 
$ns at 471.5895897416955 "$node_(77) setdest 2440 283 16.0" 
$ns at 512.7436134525195 "$node_(77) setdest 2438 979 5.0" 
$ns at 579.0605718752563 "$node_(77) setdest 2238 55 14.0" 
$ns at 730.1714782140336 "$node_(77) setdest 535 91 2.0" 
$ns at 775.4344096956266 "$node_(77) setdest 2903 437 17.0" 
$ns at 872.4579408228391 "$node_(77) setdest 378 12 3.0" 
$ns at 393.63931453607785 "$node_(78) setdest 978 812 5.0" 
$ns at 438.23379789103217 "$node_(78) setdest 2885 300 17.0" 
$ns at 558.3481627079345 "$node_(78) setdest 1277 216 20.0" 
$ns at 681.5262307281465 "$node_(78) setdest 2524 44 19.0" 
$ns at 870.4136357792329 "$node_(78) setdest 2705 898 1.0" 
$ns at 407.1413420116491 "$node_(79) setdest 556 461 6.0" 
$ns at 442.7828257098603 "$node_(79) setdest 2433 531 7.0" 
$ns at 479.3308982711271 "$node_(79) setdest 1206 328 15.0" 
$ns at 522.3225511748341 "$node_(79) setdest 961 566 1.0" 
$ns at 555.0575361635695 "$node_(79) setdest 1353 589 9.0" 
$ns at 588.9039531266397 "$node_(79) setdest 417 266 11.0" 
$ns at 683.2937009462026 "$node_(79) setdest 1732 895 4.0" 
$ns at 715.1476008095852 "$node_(79) setdest 2553 824 19.0" 
$ns at 818.6797529050792 "$node_(79) setdest 1923 37 12.0" 
$ns at 368.6888699588194 "$node_(80) setdest 971 735 14.0" 
$ns at 480.0096669020219 "$node_(80) setdest 122 499 15.0" 
$ns at 513.417752945803 "$node_(80) setdest 1178 236 15.0" 
$ns at 601.1580715162894 "$node_(80) setdest 1664 800 15.0" 
$ns at 776.4845019109018 "$node_(80) setdest 1790 172 11.0" 
$ns at 460.09793432309584 "$node_(81) setdest 273 246 1.0" 
$ns at 496.037783046556 "$node_(81) setdest 2464 520 10.0" 
$ns at 589.5785940721486 "$node_(81) setdest 2222 684 2.0" 
$ns at 630.4970387192485 "$node_(81) setdest 1107 915 5.0" 
$ns at 695.2952430092719 "$node_(81) setdest 1800 861 11.0" 
$ns at 829.3572265817761 "$node_(81) setdest 2030 148 13.0" 
$ns at 424.9265019750702 "$node_(82) setdest 828 967 16.0" 
$ns at 611.8958341218404 "$node_(82) setdest 1905 375 11.0" 
$ns at 720.9348950046605 "$node_(82) setdest 1753 699 9.0" 
$ns at 789.9067854025029 "$node_(82) setdest 2661 197 5.0" 
$ns at 869.2899665276357 "$node_(82) setdest 1497 352 6.0" 
$ns at 446.63401489531867 "$node_(83) setdest 2109 512 11.0" 
$ns at 536.1074616988567 "$node_(83) setdest 1812 347 8.0" 
$ns at 639.4893935853211 "$node_(83) setdest 2169 440 4.0" 
$ns at 676.6239801526755 "$node_(83) setdest 1162 428 14.0" 
$ns at 824.350712072714 "$node_(83) setdest 776 291 15.0" 
$ns at 392.9518111360296 "$node_(84) setdest 1261 596 9.0" 
$ns at 433.49181520230957 "$node_(84) setdest 2203 424 14.0" 
$ns at 466.88691475886685 "$node_(84) setdest 1154 553 19.0" 
$ns at 579.9499010429123 "$node_(84) setdest 2699 985 9.0" 
$ns at 679.4926664203831 "$node_(84) setdest 2694 811 8.0" 
$ns at 789.2850699563304 "$node_(84) setdest 1116 189 8.0" 
$ns at 852.7881743604797 "$node_(84) setdest 1566 525 19.0" 
$ns at 340.91064076493234 "$node_(85) setdest 2656 656 14.0" 
$ns at 431.1111458363132 "$node_(85) setdest 716 934 19.0" 
$ns at 557.2471258138494 "$node_(85) setdest 624 79 19.0" 
$ns at 689.2506209889192 "$node_(85) setdest 536 863 5.0" 
$ns at 763.6103423151169 "$node_(85) setdest 953 61 11.0" 
$ns at 813.6512682023424 "$node_(85) setdest 2874 548 11.0" 
$ns at 860.1119423966294 "$node_(85) setdest 2272 259 18.0" 
$ns at 895.5014048743951 "$node_(85) setdest 2444 484 11.0" 
$ns at 346.4382651218368 "$node_(86) setdest 678 620 1.0" 
$ns at 378.4188630901371 "$node_(86) setdest 770 42 6.0" 
$ns at 436.4663389997528 "$node_(86) setdest 103 161 8.0" 
$ns at 486.5983785898169 "$node_(86) setdest 1993 920 17.0" 
$ns at 603.8778065922047 "$node_(86) setdest 375 919 10.0" 
$ns at 635.2768561110045 "$node_(86) setdest 2021 427 5.0" 
$ns at 695.5302715388829 "$node_(86) setdest 800 323 8.0" 
$ns at 775.4395660156976 "$node_(86) setdest 131 739 7.0" 
$ns at 842.4779885832959 "$node_(86) setdest 1791 262 9.0" 
$ns at 398.0938986875077 "$node_(87) setdest 2000 763 1.0" 
$ns at 428.714816430895 "$node_(87) setdest 2082 480 18.0" 
$ns at 545.0531703904408 "$node_(87) setdest 2460 744 10.0" 
$ns at 616.9259418064798 "$node_(87) setdest 2671 445 10.0" 
$ns at 670.4918782858167 "$node_(87) setdest 2847 466 12.0" 
$ns at 718.4521696902683 "$node_(87) setdest 2991 365 5.0" 
$ns at 773.3425169644388 "$node_(87) setdest 2803 538 11.0" 
$ns at 883.5940043223627 "$node_(87) setdest 1840 480 17.0" 
$ns at 427.2373241211294 "$node_(88) setdest 1382 146 1.0" 
$ns at 463.82079698646345 "$node_(88) setdest 2113 434 14.0" 
$ns at 505.83787859473057 "$node_(88) setdest 2279 671 8.0" 
$ns at 550.0253888619256 "$node_(88) setdest 1156 855 11.0" 
$ns at 640.9374789379024 "$node_(88) setdest 1440 20 9.0" 
$ns at 736.6180303492172 "$node_(88) setdest 1951 825 6.0" 
$ns at 786.8726725937202 "$node_(88) setdest 958 627 18.0" 
$ns at 334.9568261738061 "$node_(89) setdest 2854 328 1.0" 
$ns at 374.8315962275894 "$node_(89) setdest 1778 521 20.0" 
$ns at 551.0504020400438 "$node_(89) setdest 2163 419 1.0" 
$ns at 588.1720271834829 "$node_(89) setdest 2923 423 15.0" 
$ns at 727.738956354121 "$node_(89) setdest 838 175 3.0" 
$ns at 785.5905508387693 "$node_(89) setdest 2201 141 1.0" 
$ns at 817.7236010733207 "$node_(89) setdest 643 614 5.0" 
$ns at 855.0989245213644 "$node_(89) setdest 2816 764 3.0" 
$ns at 892.731889678299 "$node_(89) setdest 2403 871 10.0" 
$ns at 334.6538560724272 "$node_(90) setdest 1168 908 12.0" 
$ns at 391.7994274116845 "$node_(90) setdest 2652 994 15.0" 
$ns at 506.7463887638082 "$node_(90) setdest 471 103 15.0" 
$ns at 594.9309708289417 "$node_(90) setdest 217 433 4.0" 
$ns at 638.3718221279574 "$node_(90) setdest 510 423 7.0" 
$ns at 699.8424391026016 "$node_(90) setdest 1895 841 3.0" 
$ns at 749.6999254133173 "$node_(90) setdest 2516 442 10.0" 
$ns at 836.2895507313319 "$node_(90) setdest 2227 792 17.0" 
$ns at 369.12396552934786 "$node_(91) setdest 2316 383 2.0" 
$ns at 406.5419752010753 "$node_(91) setdest 1624 563 2.0" 
$ns at 442.73241061007894 "$node_(91) setdest 1118 869 9.0" 
$ns at 487.1560963669253 "$node_(91) setdest 996 960 19.0" 
$ns at 528.0687975149676 "$node_(91) setdest 1275 54 7.0" 
$ns at 592.6367787599206 "$node_(91) setdest 948 62 3.0" 
$ns at 639.5894994794321 "$node_(91) setdest 103 387 11.0" 
$ns at 721.037971960372 "$node_(91) setdest 1621 491 11.0" 
$ns at 828.1175828950358 "$node_(91) setdest 2032 386 1.0" 
$ns at 866.5970884707447 "$node_(91) setdest 1032 233 16.0" 
$ns at 392.4107966310348 "$node_(92) setdest 49 125 2.0" 
$ns at 436.17323431178306 "$node_(92) setdest 2637 888 17.0" 
$ns at 586.9074852976539 "$node_(92) setdest 2599 720 12.0" 
$ns at 721.4339312543011 "$node_(92) setdest 1410 406 2.0" 
$ns at 766.7624752383425 "$node_(92) setdest 1763 762 8.0" 
$ns at 811.548032039449 "$node_(92) setdest 688 293 8.0" 
$ns at 393.72379083806686 "$node_(93) setdest 274 762 7.0" 
$ns at 447.1462162955096 "$node_(93) setdest 2104 915 19.0" 
$ns at 521.507780588783 "$node_(93) setdest 674 646 9.0" 
$ns at 583.937600023519 "$node_(93) setdest 2450 260 3.0" 
$ns at 616.5100291433333 "$node_(93) setdest 1313 318 16.0" 
$ns at 700.6884861909705 "$node_(93) setdest 1741 179 20.0" 
$ns at 877.8434971707916 "$node_(93) setdest 788 523 7.0" 
$ns at 332.02780785017956 "$node_(94) setdest 2197 39 14.0" 
$ns at 441.9147090068614 "$node_(94) setdest 2626 272 1.0" 
$ns at 481.89051678106466 "$node_(94) setdest 210 277 1.0" 
$ns at 520.0749751405953 "$node_(94) setdest 1267 236 19.0" 
$ns at 704.4362725900172 "$node_(94) setdest 2694 59 2.0" 
$ns at 746.5613727594457 "$node_(94) setdest 1403 91 20.0" 
$ns at 331.98659658026804 "$node_(95) setdest 2905 316 8.0" 
$ns at 406.78070496435225 "$node_(95) setdest 2494 419 10.0" 
$ns at 508.29330328097313 "$node_(95) setdest 143 299 12.0" 
$ns at 607.2808771847556 "$node_(95) setdest 2476 3 3.0" 
$ns at 653.9338737480819 "$node_(95) setdest 2732 764 18.0" 
$ns at 730.2695861631278 "$node_(95) setdest 1731 167 8.0" 
$ns at 834.8288012804646 "$node_(95) setdest 2873 415 18.0" 
$ns at 401.3766900972091 "$node_(96) setdest 1523 93 16.0" 
$ns at 487.83293740371846 "$node_(96) setdest 2685 861 12.0" 
$ns at 526.7618636343236 "$node_(96) setdest 2454 233 16.0" 
$ns at 675.7632244775523 "$node_(96) setdest 2926 895 11.0" 
$ns at 741.3576707658366 "$node_(96) setdest 2603 915 6.0" 
$ns at 818.4442558340489 "$node_(96) setdest 2949 319 1.0" 
$ns at 856.9272960489513 "$node_(96) setdest 1059 908 2.0" 
$ns at 896.941447368075 "$node_(96) setdest 2214 805 7.0" 
$ns at 440.99950279627643 "$node_(97) setdest 2538 62 1.0" 
$ns at 476.5200756676936 "$node_(97) setdest 496 619 18.0" 
$ns at 633.9827262205167 "$node_(97) setdest 1629 548 14.0" 
$ns at 801.7988094711073 "$node_(97) setdest 1247 772 20.0" 
$ns at 335.79984039580734 "$node_(98) setdest 1366 846 16.0" 
$ns at 478.9113325215233 "$node_(98) setdest 370 419 17.0" 
$ns at 537.6389189215204 "$node_(98) setdest 499 978 1.0" 
$ns at 570.0618774738447 "$node_(98) setdest 982 687 5.0" 
$ns at 611.3905818571477 "$node_(98) setdest 2134 603 8.0" 
$ns at 671.0493188717974 "$node_(98) setdest 1186 612 1.0" 
$ns at 701.3544010243108 "$node_(98) setdest 2625 346 3.0" 
$ns at 735.6336693390646 "$node_(98) setdest 704 807 1.0" 
$ns at 769.1978246828894 "$node_(98) setdest 246 8 19.0" 
$ns at 816.2917781449562 "$node_(98) setdest 300 447 2.0" 
$ns at 848.5304511676195 "$node_(98) setdest 1602 655 1.0" 
$ns at 888.411717537533 "$node_(98) setdest 159 359 3.0" 
$ns at 349.3899794567652 "$node_(99) setdest 439 390 1.0" 
$ns at 379.93852663131906 "$node_(99) setdest 396 498 4.0" 
$ns at 420.04918120560194 "$node_(99) setdest 2513 718 14.0" 
$ns at 500.00915894590247 "$node_(99) setdest 2588 953 1.0" 
$ns at 539.4617038453048 "$node_(99) setdest 1470 260 13.0" 
$ns at 645.3988624671038 "$node_(99) setdest 1733 884 7.0" 
$ns at 704.8015236827562 "$node_(99) setdest 1676 669 13.0" 
$ns at 743.7695323854797 "$node_(99) setdest 886 415 6.0" 
$ns at 778.9524223193947 "$node_(99) setdest 2681 20 5.0" 
$ns at 854.7604811408844 "$node_(99) setdest 1674 474 5.0" 
$ns at 896.6580158924894 "$node_(99) setdest 727 832 8.0" 
$ns at 530.2188972122563 "$node_(100) setdest 129 666 6.0" 
$ns at 615.3442538091656 "$node_(100) setdest 132 976 13.0" 
$ns at 764.6084946618241 "$node_(100) setdest 2167 432 8.0" 
$ns at 832.1099631618714 "$node_(100) setdest 1804 61 13.0" 
$ns at 551.8618244395401 "$node_(101) setdest 1632 987 20.0" 
$ns at 763.6185927772317 "$node_(101) setdest 168 540 14.0" 
$ns at 804.1554069831594 "$node_(101) setdest 825 932 10.0" 
$ns at 590.5921984393826 "$node_(102) setdest 1134 40 8.0" 
$ns at 640.5637875716499 "$node_(102) setdest 2517 947 15.0" 
$ns at 795.9524085260684 "$node_(102) setdest 634 194 9.0" 
$ns at 557.5768714859546 "$node_(103) setdest 459 658 17.0" 
$ns at 731.5370441155528 "$node_(103) setdest 1817 272 17.0" 
$ns at 582.795155803092 "$node_(104) setdest 1096 925 2.0" 
$ns at 631.8425021023287 "$node_(104) setdest 2479 743 6.0" 
$ns at 665.0299838590666 "$node_(104) setdest 421 52 9.0" 
$ns at 779.9531153226001 "$node_(104) setdest 1271 116 9.0" 
$ns at 887.6050335791766 "$node_(104) setdest 2754 901 6.0" 
$ns at 547.245662081931 "$node_(105) setdest 1570 186 1.0" 
$ns at 585.8327015340222 "$node_(105) setdest 342 648 4.0" 
$ns at 650.0749705008812 "$node_(105) setdest 2670 639 12.0" 
$ns at 694.1077906716616 "$node_(105) setdest 193 43 5.0" 
$ns at 741.4268260051973 "$node_(105) setdest 1795 359 13.0" 
$ns at 787.6866839285348 "$node_(105) setdest 2595 778 17.0" 
$ns at 821.7435469515926 "$node_(105) setdest 443 156 19.0" 
$ns at 527.220810943453 "$node_(106) setdest 2805 865 17.0" 
$ns at 672.9104384862843 "$node_(106) setdest 2348 269 10.0" 
$ns at 704.230546803404 "$node_(106) setdest 720 436 15.0" 
$ns at 875.3569101436092 "$node_(106) setdest 2110 396 12.0" 
$ns at 544.0334144656595 "$node_(107) setdest 1866 365 19.0" 
$ns at 576.54630746708 "$node_(107) setdest 45 58 14.0" 
$ns at 674.2642073680489 "$node_(107) setdest 2691 56 12.0" 
$ns at 759.7204450868137 "$node_(107) setdest 389 554 13.0" 
$ns at 878.2229484260849 "$node_(107) setdest 2823 716 12.0" 
$ns at 524.1085232871535 "$node_(108) setdest 1012 997 7.0" 
$ns at 617.7605141531883 "$node_(108) setdest 1624 803 17.0" 
$ns at 786.065085693332 "$node_(108) setdest 1051 586 16.0" 
$ns at 522.0429423507819 "$node_(109) setdest 287 466 15.0" 
$ns at 564.3477373153412 "$node_(109) setdest 136 132 12.0" 
$ns at 598.8334317555865 "$node_(109) setdest 905 388 14.0" 
$ns at 670.0358029280721 "$node_(109) setdest 418 935 6.0" 
$ns at 756.5522323265955 "$node_(109) setdest 2938 761 17.0" 
$ns at 537.8036993172069 "$node_(110) setdest 1527 670 7.0" 
$ns at 585.5215037479496 "$node_(110) setdest 575 931 10.0" 
$ns at 636.3259631937141 "$node_(110) setdest 585 199 16.0" 
$ns at 696.0379397012173 "$node_(110) setdest 379 726 6.0" 
$ns at 756.2160694863372 "$node_(110) setdest 1193 980 17.0" 
$ns at 534.8386099600004 "$node_(111) setdest 1331 879 14.0" 
$ns at 573.5038406468752 "$node_(111) setdest 1058 329 3.0" 
$ns at 616.1502724115306 "$node_(111) setdest 1293 593 7.0" 
$ns at 663.9734191615127 "$node_(111) setdest 96 990 18.0" 
$ns at 742.2730420428312 "$node_(111) setdest 1271 86 17.0" 
$ns at 841.6216988539472 "$node_(111) setdest 693 489 10.0" 
$ns at 589.5298466751698 "$node_(112) setdest 2304 786 16.0" 
$ns at 686.8081299209096 "$node_(112) setdest 2159 821 4.0" 
$ns at 732.3868733939623 "$node_(112) setdest 2874 690 16.0" 
$ns at 875.4419695404974 "$node_(112) setdest 2602 19 6.0" 
$ns at 528.4829056820458 "$node_(113) setdest 2927 709 13.0" 
$ns at 561.1450682852081 "$node_(113) setdest 668 953 13.0" 
$ns at 658.6785836968934 "$node_(113) setdest 1239 690 3.0" 
$ns at 695.1686106541829 "$node_(113) setdest 2228 773 20.0" 
$ns at 855.7141878899756 "$node_(113) setdest 1558 508 9.0" 
$ns at 593.2885185967252 "$node_(114) setdest 273 63 17.0" 
$ns at 678.8038526425808 "$node_(114) setdest 2155 100 19.0" 
$ns at 872.9708447639118 "$node_(114) setdest 390 59 12.0" 
$ns at 631.5184336997909 "$node_(115) setdest 2055 615 4.0" 
$ns at 678.1280884252947 "$node_(115) setdest 1669 288 10.0" 
$ns at 794.8887489268602 "$node_(115) setdest 1437 116 20.0" 
$ns at 525.3084601040318 "$node_(116) setdest 1506 233 11.0" 
$ns at 653.2202424285049 "$node_(116) setdest 579 198 13.0" 
$ns at 793.4922353648265 "$node_(116) setdest 2379 940 5.0" 
$ns at 828.6980089522995 "$node_(116) setdest 2918 330 12.0" 
$ns at 639.2626151373292 "$node_(117) setdest 709 447 12.0" 
$ns at 692.6418450489982 "$node_(117) setdest 1521 60 4.0" 
$ns at 739.9582612392343 "$node_(117) setdest 2660 807 1.0" 
$ns at 770.5741587731685 "$node_(117) setdest 685 396 7.0" 
$ns at 803.316889774402 "$node_(117) setdest 586 463 16.0" 
$ns at 542.2818610742721 "$node_(118) setdest 818 684 4.0" 
$ns at 583.9337480780696 "$node_(118) setdest 1791 96 5.0" 
$ns at 631.7358587595538 "$node_(118) setdest 1230 450 7.0" 
$ns at 719.3099601178585 "$node_(118) setdest 425 915 6.0" 
$ns at 782.6196032662591 "$node_(118) setdest 2585 985 11.0" 
$ns at 895.6518177660832 "$node_(118) setdest 1832 767 13.0" 
$ns at 546.5194668068241 "$node_(119) setdest 2250 825 9.0" 
$ns at 616.0981908935836 "$node_(119) setdest 1902 134 14.0" 
$ns at 717.0364625645716 "$node_(119) setdest 2342 226 17.0" 
$ns at 781.5447195656529 "$node_(119) setdest 2741 911 14.0" 
$ns at 878.3023512683111 "$node_(119) setdest 1773 401 7.0" 
$ns at 596.3191750254205 "$node_(120) setdest 2777 618 1.0" 
$ns at 627.207827655225 "$node_(120) setdest 1982 340 8.0" 
$ns at 729.1551824583755 "$node_(120) setdest 950 577 12.0" 
$ns at 761.0105226735358 "$node_(120) setdest 2295 728 16.0" 
$ns at 565.6326756822352 "$node_(121) setdest 1449 174 8.0" 
$ns at 643.2243310752878 "$node_(121) setdest 1720 585 11.0" 
$ns at 688.3878456795821 "$node_(121) setdest 1174 677 6.0" 
$ns at 723.6528069240994 "$node_(121) setdest 855 292 10.0" 
$ns at 775.7675402708396 "$node_(121) setdest 324 161 19.0" 
$ns at 576.236101715992 "$node_(122) setdest 54 549 5.0" 
$ns at 606.4829882383851 "$node_(122) setdest 2951 854 5.0" 
$ns at 684.4389610692801 "$node_(122) setdest 2543 199 15.0" 
$ns at 734.9062486313502 "$node_(122) setdest 224 637 3.0" 
$ns at 780.7494661464114 "$node_(122) setdest 1239 977 10.0" 
$ns at 896.0395080781057 "$node_(122) setdest 2357 773 5.0" 
$ns at 538.1580857200142 "$node_(123) setdest 342 845 2.0" 
$ns at 584.5340020064301 "$node_(123) setdest 1024 639 4.0" 
$ns at 648.9275758110902 "$node_(123) setdest 2719 312 18.0" 
$ns at 841.1769178939413 "$node_(123) setdest 1652 984 18.0" 
$ns at 590.7772708136933 "$node_(124) setdest 618 813 7.0" 
$ns at 647.1809030062115 "$node_(124) setdest 1369 623 15.0" 
$ns at 749.0961016747992 "$node_(124) setdest 1990 831 9.0" 
$ns at 824.0587328046013 "$node_(124) setdest 1135 125 6.0" 
$ns at 878.3815323480992 "$node_(124) setdest 1875 523 4.0" 
$ns at 702.1699833645706 "$node_(125) setdest 1317 36 17.0" 
$ns at 830.9729004681279 "$node_(125) setdest 703 986 16.0" 
$ns at 720.8205810023087 "$node_(126) setdest 2470 18 13.0" 
$ns at 793.6011007508145 "$node_(126) setdest 570 463 4.0" 
$ns at 847.6123607139039 "$node_(126) setdest 1429 703 1.0" 
$ns at 885.6302002456738 "$node_(126) setdest 2608 425 2.0" 
$ns at 698.3661955662874 "$node_(127) setdest 2894 734 8.0" 
$ns at 765.1753368091393 "$node_(127) setdest 430 484 13.0" 
$ns at 832.1901465920121 "$node_(127) setdest 2925 86 1.0" 
$ns at 871.3660763102524 "$node_(127) setdest 1050 379 17.0" 
$ns at 738.8760201765865 "$node_(128) setdest 902 513 13.0" 
$ns at 871.3073509595556 "$node_(128) setdest 1055 151 15.0" 
$ns at 662.0485890353975 "$node_(129) setdest 2087 220 2.0" 
$ns at 695.7416977613368 "$node_(129) setdest 2691 971 2.0" 
$ns at 738.6664515744059 "$node_(129) setdest 2087 167 15.0" 
$ns at 806.1005867703905 "$node_(129) setdest 1886 802 17.0" 
$ns at 894.796920768739 "$node_(129) setdest 2469 281 15.0" 
$ns at 741.2974443035789 "$node_(130) setdest 2951 340 8.0" 
$ns at 781.7817482266753 "$node_(130) setdest 536 163 1.0" 
$ns at 814.8134679448975 "$node_(130) setdest 1861 321 7.0" 
$ns at 899.3075512469462 "$node_(130) setdest 519 433 3.0" 
$ns at 669.7483486058633 "$node_(131) setdest 162 324 2.0" 
$ns at 711.4486800893294 "$node_(131) setdest 170 571 11.0" 
$ns at 843.4517159337854 "$node_(131) setdest 1695 211 14.0" 
$ns at 719.7371156083351 "$node_(132) setdest 2444 581 19.0" 
$ns at 816.568988911555 "$node_(132) setdest 25 196 11.0" 
$ns at 852.2046727866473 "$node_(132) setdest 2505 145 11.0" 
$ns at 754.9441809922723 "$node_(133) setdest 1815 258 3.0" 
$ns at 805.5101247779087 "$node_(133) setdest 2564 526 1.0" 
$ns at 840.5210644402098 "$node_(133) setdest 2501 393 17.0" 
$ns at 865.4111364890331 "$node_(134) setdest 2246 863 1.0" 
$ns at 899.0731461199857 "$node_(134) setdest 1919 535 18.0" 
$ns at 694.1436542018646 "$node_(135) setdest 2280 404 13.0" 
$ns at 731.2667276613264 "$node_(135) setdest 569 372 15.0" 
$ns at 855.1864630995434 "$node_(135) setdest 2901 703 16.0" 
$ns at 843.2810727528322 "$node_(136) setdest 1385 185 6.0" 
$ns at 899.3967831280004 "$node_(136) setdest 2405 161 18.0" 
$ns at 705.5493237531791 "$node_(137) setdest 732 611 13.0" 
$ns at 769.5393637924169 "$node_(137) setdest 2670 178 11.0" 
$ns at 856.4885112985037 "$node_(137) setdest 189 59 9.0" 
$ns at 698.2059383227831 "$node_(138) setdest 1769 520 7.0" 
$ns at 769.3299682448793 "$node_(138) setdest 75 832 1.0" 
$ns at 800.1363776399621 "$node_(138) setdest 673 137 18.0" 
$ns at 834.0492252079976 "$node_(138) setdest 2813 304 5.0" 
$ns at 873.3685750609457 "$node_(138) setdest 509 651 19.0" 
$ns at 663.5357587384291 "$node_(139) setdest 1785 33 2.0" 
$ns at 696.801550693777 "$node_(139) setdest 2232 707 20.0" 
$ns at 777.5614427183415 "$node_(139) setdest 1982 456 19.0" 
$ns at 809.5264889013664 "$node_(139) setdest 2161 290 17.0" 
$ns at 688.2679957747528 "$node_(140) setdest 204 453 13.0" 
$ns at 804.1867392178938 "$node_(140) setdest 424 288 2.0" 
$ns at 846.4538772300531 "$node_(140) setdest 1376 644 15.0" 
$ns at 675.3891462634482 "$node_(141) setdest 3 938 11.0" 
$ns at 810.4160638249685 "$node_(141) setdest 2394 672 18.0" 
$ns at 683.2150991050003 "$node_(142) setdest 1268 274 1.0" 
$ns at 719.9210037151712 "$node_(142) setdest 718 13 1.0" 
$ns at 750.4109555758741 "$node_(142) setdest 2368 234 9.0" 
$ns at 858.18599409957 "$node_(142) setdest 106 342 1.0" 
$ns at 891.0105638008741 "$node_(142) setdest 72 761 13.0" 
$ns at 672.7600546592689 "$node_(143) setdest 358 83 6.0" 
$ns at 743.0707276639841 "$node_(143) setdest 2838 481 1.0" 
$ns at 776.2922766842802 "$node_(143) setdest 1402 761 3.0" 
$ns at 826.9796274521199 "$node_(143) setdest 238 66 5.0" 
$ns at 879.8444145115527 "$node_(143) setdest 1418 332 20.0" 
$ns at 699.2596249682124 "$node_(144) setdest 1965 107 11.0" 
$ns at 799.6798982631517 "$node_(144) setdest 2212 283 4.0" 
$ns at 848.201193953417 "$node_(144) setdest 1904 151 1.0" 
$ns at 886.2877239765502 "$node_(144) setdest 327 687 12.0" 
$ns at 706.605703490738 "$node_(145) setdest 1558 5 17.0" 
$ns at 779.1867692597873 "$node_(145) setdest 2461 672 18.0" 
$ns at 664.987974554936 "$node_(146) setdest 665 820 13.0" 
$ns at 740.7974836683069 "$node_(146) setdest 2206 662 7.0" 
$ns at 782.953560084071 "$node_(146) setdest 437 712 4.0" 
$ns at 838.7922350330502 "$node_(146) setdest 2821 217 4.0" 
$ns at 693.1210653374402 "$node_(147) setdest 1765 805 4.0" 
$ns at 759.3920972801316 "$node_(147) setdest 1105 987 7.0" 
$ns at 830.0647044628829 "$node_(147) setdest 385 731 12.0" 
$ns at 693.0140804120686 "$node_(148) setdest 931 536 15.0" 
$ns at 796.088487643466 "$node_(148) setdest 2215 23 19.0" 
$ns at 673.0435991885013 "$node_(149) setdest 1820 610 17.0" 
$ns at 872.7387053992147 "$node_(149) setdest 2092 828 2.0" 


#Set a TCP connection between node_(5) and node_(40)
set tcp_(0) [new Agent/TCP/Newreno]
$tcp_(0) set class_ 2
set sink_(0) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(0)
$ns attach-agent $node_(40) $sink_(0)
$ns connect $tcp_(0) $sink_(0)
set ftp_(0) [new Application/FTP]
$ftp_(0) attach-agent $tcp_(0)
$ns at 0.2 "$ftp_(0) start"
$ns at 180.0 "$ftp_(0) stop"

#Set a TCP connection between node_(9) and node_(44)
set tcp_(1) [new Agent/TCP/Newreno]
$tcp_(1) set class_ 2
set sink_(1) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(1)
$ns attach-agent $node_(44) $sink_(1)
$ns connect $tcp_(1) $sink_(1)
set ftp_(1) [new Application/FTP]
$ftp_(1) attach-agent $tcp_(1)
$ns at 180.2 "$ftp_(1) start"
$ns at 360.0 "$ftp_(1) stop"

#Set a TCP connection between node_(2) and node_(37)
set tcp_(2) [new Agent/TCP/Newreno]
$tcp_(2) set class_ 2
set sink_(2) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(2)
$ns attach-agent $node_(37) $sink_(2)
$ns connect $tcp_(2) $sink_(2)
set ftp_(2) [new Application/FTP]
$ftp_(2) attach-agent $tcp_(2)
$ns at 360.2 "$ftp_(2) start"
$ns at 540.0 "$ftp_(2) stop"

#Set a TCP connection between node_(41) and node_(7)
set tcp_(3) [new Agent/TCP/Newreno]
$tcp_(3) set class_ 2
set sink_(3) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(3)
$ns attach-agent $node_(7) $sink_(3)
$ns connect $tcp_(3) $sink_(3)
set ftp_(3) [new Application/FTP]
$ftp_(3) attach-agent $tcp_(3)
$ns at 540.2 "$ftp_(3) start"
$ns at 720.0 "$ftp_(3) stop"

#Set a TCP connection between node_(46) and node_(14)
set tcp_(4) [new Agent/TCP/Newreno]
$tcp_(4) set class_ 2
set sink_(4) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(4)
$ns attach-agent $node_(14) $sink_(4)
$ns connect $tcp_(4) $sink_(4)
set ftp_(4) [new Application/FTP]
$ftp_(4) attach-agent $tcp_(4)
$ns at 720.2 "$ftp_(4) start"
$ns at 900.0 "$ftp_(4) stop"

#Set a TCP connection between node_(41) and node_(34)
set tcp_(5) [new Agent/TCP/Newreno]
$tcp_(5) set class_ 2
set sink_(5) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(5)
$ns attach-agent $node_(34) $sink_(5)
$ns connect $tcp_(5) $sink_(5)
set ftp_(5) [new Application/FTP]
$ftp_(5) attach-agent $tcp_(5)
$ns at 0.2 "$ftp_(5) start"
$ns at 180.0 "$ftp_(5) stop"

#Set a TCP connection between node_(25) and node_(10)
set tcp_(6) [new Agent/TCP/Newreno]
$tcp_(6) set class_ 2
set sink_(6) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(6)
$ns attach-agent $node_(10) $sink_(6)
$ns connect $tcp_(6) $sink_(6)
set ftp_(6) [new Application/FTP]
$ftp_(6) attach-agent $tcp_(6)
$ns at 180.2 "$ftp_(6) start"
$ns at 360.0 "$ftp_(6) stop"

#Set a TCP connection between node_(45) and node_(34)
set tcp_(7) [new Agent/TCP/Newreno]
$tcp_(7) set class_ 2
set sink_(7) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(7)
$ns attach-agent $node_(34) $sink_(7)
$ns connect $tcp_(7) $sink_(7)
set ftp_(7) [new Application/FTP]
$ftp_(7) attach-agent $tcp_(7)
$ns at 360.2 "$ftp_(7) start"
$ns at 540.0 "$ftp_(7) stop"

#Set a TCP connection between node_(21) and node_(19)
set tcp_(8) [new Agent/TCP/Newreno]
$tcp_(8) set class_ 2
set sink_(8) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(8)
$ns attach-agent $node_(19) $sink_(8)
$ns connect $tcp_(8) $sink_(8)
set ftp_(8) [new Application/FTP]
$ftp_(8) attach-agent $tcp_(8)
$ns at 540.2 "$ftp_(8) start"
$ns at 720.0 "$ftp_(8) stop"

#Set a TCP connection between node_(1) and node_(15)
set tcp_(9) [new Agent/TCP/Newreno]
$tcp_(9) set class_ 2
set sink_(9) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(9)
$ns attach-agent $node_(15) $sink_(9)
$ns connect $tcp_(9) $sink_(9)
set ftp_(9) [new Application/FTP]
$ftp_(9) attach-agent $tcp_(9)
$ns at 720.2 "$ftp_(9) start"
$ns at 900.0 "$ftp_(9) stop"

#Set a TCP connection between node_(47) and node_(45)
set tcp_(10) [new Agent/TCP/Newreno]
$tcp_(10) set class_ 2
set sink_(10) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(10)
$ns attach-agent $node_(45) $sink_(10)
$ns connect $tcp_(10) $sink_(10)
set ftp_(10) [new Application/FTP]
$ftp_(10) attach-agent $tcp_(10)
$ns at 0.2 "$ftp_(10) start"
$ns at 180.0 "$ftp_(10) stop"

#Set a TCP connection between node_(30) and node_(34)
set tcp_(11) [new Agent/TCP/Newreno]
$tcp_(11) set class_ 2
set sink_(11) [new Agent/TCPSink]
$ns attach-agent $node_(30) $tcp_(11)
$ns attach-agent $node_(34) $sink_(11)
$ns connect $tcp_(11) $sink_(11)
set ftp_(11) [new Application/FTP]
$ftp_(11) attach-agent $tcp_(11)
$ns at 180.2 "$ftp_(11) start"
$ns at 360.0 "$ftp_(11) stop"

#Set a TCP connection between node_(36) and node_(45)
set tcp_(12) [new Agent/TCP/Newreno]
$tcp_(12) set class_ 2
set sink_(12) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(12)
$ns attach-agent $node_(45) $sink_(12)
$ns connect $tcp_(12) $sink_(12)
set ftp_(12) [new Application/FTP]
$ftp_(12) attach-agent $tcp_(12)
$ns at 360.2 "$ftp_(12) start"
$ns at 540.0 "$ftp_(12) stop"

#Set a TCP connection between node_(46) and node_(1)
set tcp_(13) [new Agent/TCP/Newreno]
$tcp_(13) set class_ 2
set sink_(13) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(13)
$ns attach-agent $node_(1) $sink_(13)
$ns connect $tcp_(13) $sink_(13)
set ftp_(13) [new Application/FTP]
$ftp_(13) attach-agent $tcp_(13)
$ns at 540.2 "$ftp_(13) start"
$ns at 720.0 "$ftp_(13) stop"

#Set a TCP connection between node_(11) and node_(28)
set tcp_(14) [new Agent/TCP/Newreno]
$tcp_(14) set class_ 2
set sink_(14) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(14)
$ns attach-agent $node_(28) $sink_(14)
$ns connect $tcp_(14) $sink_(14)
set ftp_(14) [new Application/FTP]
$ftp_(14) attach-agent $tcp_(14)
$ns at 720.2 "$ftp_(14) start"
$ns at 900.0 "$ftp_(14) stop"

#Set a TCP connection between node_(13) and node_(32)
set tcp_(15) [new Agent/TCP/Newreno]
$tcp_(15) set class_ 2
set sink_(15) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(15)
$ns attach-agent $node_(32) $sink_(15)
$ns connect $tcp_(15) $sink_(15)
set ftp_(15) [new Application/FTP]
$ftp_(15) attach-agent $tcp_(15)
$ns at 0.2 "$ftp_(15) start"
$ns at 180.0 "$ftp_(15) stop"

#Set a TCP connection between node_(4) and node_(23)
set tcp_(16) [new Agent/TCP/Newreno]
$tcp_(16) set class_ 2
set sink_(16) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(16)
$ns attach-agent $node_(23) $sink_(16)
$ns connect $tcp_(16) $sink_(16)
set ftp_(16) [new Application/FTP]
$ftp_(16) attach-agent $tcp_(16)
$ns at 180.2 "$ftp_(16) start"
$ns at 360.0 "$ftp_(16) stop"

#Set a TCP connection between node_(41) and node_(11)
set tcp_(17) [new Agent/TCP/Newreno]
$tcp_(17) set class_ 2
set sink_(17) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(17)
$ns attach-agent $node_(11) $sink_(17)
$ns connect $tcp_(17) $sink_(17)
set ftp_(17) [new Application/FTP]
$ftp_(17) attach-agent $tcp_(17)
$ns at 360.2 "$ftp_(17) start"
$ns at 540.0 "$ftp_(17) stop"

#Set a TCP connection between node_(35) and node_(21)
set tcp_(18) [new Agent/TCP/Newreno]
$tcp_(18) set class_ 2
set sink_(18) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(18)
$ns attach-agent $node_(21) $sink_(18)
$ns connect $tcp_(18) $sink_(18)
set ftp_(18) [new Application/FTP]
$ftp_(18) attach-agent $tcp_(18)
$ns at 540.2 "$ftp_(18) start"
$ns at 720.0 "$ftp_(18) stop"

#Set a TCP connection between node_(18) and node_(21)
set tcp_(19) [new Agent/TCP/Newreno]
$tcp_(19) set class_ 2
set sink_(19) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(19)
$ns attach-agent $node_(21) $sink_(19)
$ns connect $tcp_(19) $sink_(19)
set ftp_(19) [new Application/FTP]
$ftp_(19) attach-agent $tcp_(19)
$ns at 720.2 "$ftp_(19) start"
$ns at 900.0 "$ftp_(19) stop"

#Set a TCP connection between node_(43) and node_(5)
set tcp_(20) [new Agent/TCP/Newreno]
$tcp_(20) set class_ 2
set sink_(20) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(20)
$ns attach-agent $node_(5) $sink_(20)
$ns connect $tcp_(20) $sink_(20)
set ftp_(20) [new Application/FTP]
$ftp_(20) attach-agent $tcp_(20)
$ns at 0.2 "$ftp_(20) start"
$ns at 180.0 "$ftp_(20) stop"

#Set a TCP connection between node_(14) and node_(48)
set tcp_(21) [new Agent/TCP/Newreno]
$tcp_(21) set class_ 2
set sink_(21) [new Agent/TCPSink]
$ns attach-agent $node_(14) $tcp_(21)
$ns attach-agent $node_(48) $sink_(21)
$ns connect $tcp_(21) $sink_(21)
set ftp_(21) [new Application/FTP]
$ftp_(21) attach-agent $tcp_(21)
$ns at 180.2 "$ftp_(21) start"
$ns at 360.0 "$ftp_(21) stop"

#Set a TCP connection between node_(28) and node_(32)
set tcp_(22) [new Agent/TCP/Newreno]
$tcp_(22) set class_ 2
set sink_(22) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(22)
$ns attach-agent $node_(32) $sink_(22)
$ns connect $tcp_(22) $sink_(22)
set ftp_(22) [new Application/FTP]
$ftp_(22) attach-agent $tcp_(22)
$ns at 360.2 "$ftp_(22) start"
$ns at 540.0 "$ftp_(22) stop"

#Set a TCP connection between node_(33) and node_(25)
set tcp_(23) [new Agent/TCP/Newreno]
$tcp_(23) set class_ 2
set sink_(23) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(23)
$ns attach-agent $node_(25) $sink_(23)
$ns connect $tcp_(23) $sink_(23)
set ftp_(23) [new Application/FTP]
$ftp_(23) attach-agent $tcp_(23)
$ns at 540.2 "$ftp_(23) start"
$ns at 720.0 "$ftp_(23) stop"

#Set a TCP connection between node_(4) and node_(31)
set tcp_(24) [new Agent/TCP/Newreno]
$tcp_(24) set class_ 2
set sink_(24) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(24)
$ns attach-agent $node_(31) $sink_(24)
$ns connect $tcp_(24) $sink_(24)
set ftp_(24) [new Application/FTP]
$ftp_(24) attach-agent $tcp_(24)
$ns at 720.2 "$ftp_(24) start"
$ns at 900.0 "$ftp_(24) stop"

#Set a TCP connection between node_(9) and node_(18)
set tcp_(25) [new Agent/TCP/Newreno]
$tcp_(25) set class_ 2
set sink_(25) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(25)
$ns attach-agent $node_(18) $sink_(25)
$ns connect $tcp_(25) $sink_(25)
set ftp_(25) [new Application/FTP]
$ftp_(25) attach-agent $tcp_(25)
$ns at 0.2 "$ftp_(25) start"
$ns at 180.0 "$ftp_(25) stop"

#Set a TCP connection between node_(43) and node_(17)
set tcp_(26) [new Agent/TCP/Newreno]
$tcp_(26) set class_ 2
set sink_(26) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(26)
$ns attach-agent $node_(17) $sink_(26)
$ns connect $tcp_(26) $sink_(26)
set ftp_(26) [new Application/FTP]
$ftp_(26) attach-agent $tcp_(26)
$ns at 180.2 "$ftp_(26) start"
$ns at 360.0 "$ftp_(26) stop"

#Set a TCP connection between node_(35) and node_(18)
set tcp_(27) [new Agent/TCP/Newreno]
$tcp_(27) set class_ 2
set sink_(27) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(27)
$ns attach-agent $node_(18) $sink_(27)
$ns connect $tcp_(27) $sink_(27)
set ftp_(27) [new Application/FTP]
$ftp_(27) attach-agent $tcp_(27)
$ns at 360.2 "$ftp_(27) start"
$ns at 540.0 "$ftp_(27) stop"

#Set a TCP connection between node_(35) and node_(39)
set tcp_(28) [new Agent/TCP/Newreno]
$tcp_(28) set class_ 2
set sink_(28) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(28)
$ns attach-agent $node_(39) $sink_(28)
$ns connect $tcp_(28) $sink_(28)
set ftp_(28) [new Application/FTP]
$ftp_(28) attach-agent $tcp_(28)
$ns at 540.2 "$ftp_(28) start"
$ns at 720.0 "$ftp_(28) stop"

#Set a TCP connection between node_(41) and node_(6)
set tcp_(29) [new Agent/TCP/Newreno]
$tcp_(29) set class_ 2
set sink_(29) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(29)
$ns attach-agent $node_(6) $sink_(29)
$ns connect $tcp_(29) $sink_(29)
set ftp_(29) [new Application/FTP]
$ftp_(29) attach-agent $tcp_(29)
$ns at 720.2 "$ftp_(29) start"
$ns at 900.0 "$ftp_(29) stop"

#Set a TCP connection between node_(2) and node_(18)
set tcp_(30) [new Agent/TCP/Newreno]
$tcp_(30) set class_ 2
set sink_(30) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(30)
$ns attach-agent $node_(18) $sink_(30)
$ns connect $tcp_(30) $sink_(30)
set ftp_(30) [new Application/FTP]
$ftp_(30) attach-agent $tcp_(30)
$ns at 0.2 "$ftp_(30) start"
$ns at 180.0 "$ftp_(30) stop"

#Set a TCP connection between node_(21) and node_(0)
set tcp_(31) [new Agent/TCP/Newreno]
$tcp_(31) set class_ 2
set sink_(31) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(31)
$ns attach-agent $node_(0) $sink_(31)
$ns connect $tcp_(31) $sink_(31)
set ftp_(31) [new Application/FTP]
$ftp_(31) attach-agent $tcp_(31)
$ns at 180.2 "$ftp_(31) start"
$ns at 360.0 "$ftp_(31) stop"

#Set a TCP connection between node_(15) and node_(18)
set tcp_(32) [new Agent/TCP/Newreno]
$tcp_(32) set class_ 2
set sink_(32) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(32)
$ns attach-agent $node_(18) $sink_(32)
$ns connect $tcp_(32) $sink_(32)
set ftp_(32) [new Application/FTP]
$ftp_(32) attach-agent $tcp_(32)
$ns at 360.2 "$ftp_(32) start"
$ns at 540.0 "$ftp_(32) stop"

#Set a TCP connection between node_(29) and node_(5)
set tcp_(33) [new Agent/TCP/Newreno]
$tcp_(33) set class_ 2
set sink_(33) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(33)
$ns attach-agent $node_(5) $sink_(33)
$ns connect $tcp_(33) $sink_(33)
set ftp_(33) [new Application/FTP]
$ftp_(33) attach-agent $tcp_(33)
$ns at 540.2 "$ftp_(33) start"
$ns at 720.0 "$ftp_(33) stop"

#Set a TCP connection between node_(41) and node_(25)
set tcp_(34) [new Agent/TCP/Newreno]
$tcp_(34) set class_ 2
set sink_(34) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(34)
$ns attach-agent $node_(25) $sink_(34)
$ns connect $tcp_(34) $sink_(34)
set ftp_(34) [new Application/FTP]
$ftp_(34) attach-agent $tcp_(34)
$ns at 720.2 "$ftp_(34) start"
$ns at 900.0 "$ftp_(34) stop"

#Set a TCP connection between node_(34) and node_(28)
set tcp_(35) [new Agent/TCP/Newreno]
$tcp_(35) set class_ 2
set sink_(35) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(35)
$ns attach-agent $node_(28) $sink_(35)
$ns connect $tcp_(35) $sink_(35)
set ftp_(35) [new Application/FTP]
$ftp_(35) attach-agent $tcp_(35)
$ns at 0.2 "$ftp_(35) start"
$ns at 180.0 "$ftp_(35) stop"

#Set a TCP connection between node_(36) and node_(24)
set tcp_(36) [new Agent/TCP/Newreno]
$tcp_(36) set class_ 2
set sink_(36) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(36)
$ns attach-agent $node_(24) $sink_(36)
$ns connect $tcp_(36) $sink_(36)
set ftp_(36) [new Application/FTP]
$ftp_(36) attach-agent $tcp_(36)
$ns at 180.2 "$ftp_(36) start"
$ns at 360.0 "$ftp_(36) stop"

#Set a TCP connection between node_(3) and node_(36)
set tcp_(37) [new Agent/TCP/Newreno]
$tcp_(37) set class_ 2
set sink_(37) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(37)
$ns attach-agent $node_(36) $sink_(37)
$ns connect $tcp_(37) $sink_(37)
set ftp_(37) [new Application/FTP]
$ftp_(37) attach-agent $tcp_(37)
$ns at 360.2 "$ftp_(37) start"
$ns at 540.0 "$ftp_(37) stop"

#Set a TCP connection between node_(47) and node_(10)
set tcp_(38) [new Agent/TCP/Newreno]
$tcp_(38) set class_ 2
set sink_(38) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(38)
$ns attach-agent $node_(10) $sink_(38)
$ns connect $tcp_(38) $sink_(38)
set ftp_(38) [new Application/FTP]
$ftp_(38) attach-agent $tcp_(38)
$ns at 540.2 "$ftp_(38) start"
$ns at 720.0 "$ftp_(38) stop"

#Set a TCP connection between node_(2) and node_(23)
set tcp_(39) [new Agent/TCP/Newreno]
$tcp_(39) set class_ 2
set sink_(39) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(39)
$ns attach-agent $node_(23) $sink_(39)
$ns connect $tcp_(39) $sink_(39)
set ftp_(39) [new Application/FTP]
$ftp_(39) attach-agent $tcp_(39)
$ns at 720.2 "$ftp_(39) start"
$ns at 900.0 "$ftp_(39) stop"

#Set a TCP connection between node_(6) and node_(13)
set tcp_(40) [new Agent/TCP/Newreno]
$tcp_(40) set class_ 2
set sink_(40) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(40)
$ns attach-agent $node_(13) $sink_(40)
$ns connect $tcp_(40) $sink_(40)
set ftp_(40) [new Application/FTP]
$ftp_(40) attach-agent $tcp_(40)
$ns at 0.2 "$ftp_(40) start"
$ns at 180.0 "$ftp_(40) stop"

#Set a TCP connection between node_(1) and node_(2)
set tcp_(41) [new Agent/TCP/Newreno]
$tcp_(41) set class_ 2
set sink_(41) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(41)
$ns attach-agent $node_(2) $sink_(41)
$ns connect $tcp_(41) $sink_(41)
set ftp_(41) [new Application/FTP]
$ftp_(41) attach-agent $tcp_(41)
$ns at 180.2 "$ftp_(41) start"
$ns at 360.0 "$ftp_(41) stop"

#Set a TCP connection between node_(25) and node_(40)
set tcp_(42) [new Agent/TCP/Newreno]
$tcp_(42) set class_ 2
set sink_(42) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(42)
$ns attach-agent $node_(40) $sink_(42)
$ns connect $tcp_(42) $sink_(42)
set ftp_(42) [new Application/FTP]
$ftp_(42) attach-agent $tcp_(42)
$ns at 360.2 "$ftp_(42) start"
$ns at 540.0 "$ftp_(42) stop"

#Set a TCP connection between node_(12) and node_(4)
set tcp_(43) [new Agent/TCP/Newreno]
$tcp_(43) set class_ 2
set sink_(43) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(43)
$ns attach-agent $node_(4) $sink_(43)
$ns connect $tcp_(43) $sink_(43)
set ftp_(43) [new Application/FTP]
$ftp_(43) attach-agent $tcp_(43)
$ns at 540.2 "$ftp_(43) start"
$ns at 720.0 "$ftp_(43) stop"

#Set a TCP connection between node_(15) and node_(22)
set tcp_(44) [new Agent/TCP/Newreno]
$tcp_(44) set class_ 2
set sink_(44) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(44)
$ns attach-agent $node_(22) $sink_(44)
$ns connect $tcp_(44) $sink_(44)
set ftp_(44) [new Application/FTP]
$ftp_(44) attach-agent $tcp_(44)
$ns at 720.2 "$ftp_(44) start"
$ns at 900.0 "$ftp_(44) stop"

#Set a TCP connection between node_(32) and node_(48)
set tcp_(45) [new Agent/TCP/Newreno]
$tcp_(45) set class_ 2
set sink_(45) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(45)
$ns attach-agent $node_(48) $sink_(45)
$ns connect $tcp_(45) $sink_(45)
set ftp_(45) [new Application/FTP]
$ftp_(45) attach-agent $tcp_(45)
$ns at 0.2 "$ftp_(45) start"
$ns at 180.0 "$ftp_(45) stop"

#Set a TCP connection between node_(39) and node_(3)
set tcp_(46) [new Agent/TCP/Newreno]
$tcp_(46) set class_ 2
set sink_(46) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(46)
$ns attach-agent $node_(3) $sink_(46)
$ns connect $tcp_(46) $sink_(46)
set ftp_(46) [new Application/FTP]
$ftp_(46) attach-agent $tcp_(46)
$ns at 180.2 "$ftp_(46) start"
$ns at 360.0 "$ftp_(46) stop"

#Set a TCP connection between node_(48) and node_(45)
set tcp_(47) [new Agent/TCP/Newreno]
$tcp_(47) set class_ 2
set sink_(47) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(47)
$ns attach-agent $node_(45) $sink_(47)
$ns connect $tcp_(47) $sink_(47)
set ftp_(47) [new Application/FTP]
$ftp_(47) attach-agent $tcp_(47)
$ns at 360.2 "$ftp_(47) start"
$ns at 540.0 "$ftp_(47) stop"

#Set a TCP connection between node_(48) and node_(31)
set tcp_(48) [new Agent/TCP/Newreno]
$tcp_(48) set class_ 2
set sink_(48) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(48)
$ns attach-agent $node_(31) $sink_(48)
$ns connect $tcp_(48) $sink_(48)
set ftp_(48) [new Application/FTP]
$ftp_(48) attach-agent $tcp_(48)
$ns at 540.2 "$ftp_(48) start"
$ns at 720.0 "$ftp_(48) stop"

#Set a TCP connection between node_(19) and node_(29)
set tcp_(49) [new Agent/TCP/Newreno]
$tcp_(49) set class_ 2
set sink_(49) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(49)
$ns attach-agent $node_(29) $sink_(49)
$ns connect $tcp_(49) $sink_(49)
set ftp_(49) [new Application/FTP]
$ftp_(49) attach-agent $tcp_(49)
$ns at 720.2 "$ftp_(49) start"
$ns at 900.0 "$ftp_(49) stop"

#Set a TCP connection between node_(47) and node_(33)
set tcp_(50) [new Agent/TCP/Newreno]
$tcp_(50) set class_ 2
set sink_(50) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(50)
$ns attach-agent $node_(33) $sink_(50)
$ns connect $tcp_(50) $sink_(50)
set ftp_(50) [new Application/FTP]
$ftp_(50) attach-agent $tcp_(50)
$ns at 0.2 "$ftp_(50) start"
$ns at 180.0 "$ftp_(50) stop"

#Set a TCP connection between node_(48) and node_(42)
set tcp_(51) [new Agent/TCP/Newreno]
$tcp_(51) set class_ 2
set sink_(51) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(51)
$ns attach-agent $node_(42) $sink_(51)
$ns connect $tcp_(51) $sink_(51)
set ftp_(51) [new Application/FTP]
$ftp_(51) attach-agent $tcp_(51)
$ns at 180.2 "$ftp_(51) start"
$ns at 360.0 "$ftp_(51) stop"

#Set a TCP connection between node_(27) and node_(37)
set tcp_(52) [new Agent/TCP/Newreno]
$tcp_(52) set class_ 2
set sink_(52) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(52)
$ns attach-agent $node_(37) $sink_(52)
$ns connect $tcp_(52) $sink_(52)
set ftp_(52) [new Application/FTP]
$ftp_(52) attach-agent $tcp_(52)
$ns at 360.2 "$ftp_(52) start"
$ns at 540.0 "$ftp_(52) stop"

#Set a TCP connection between node_(5) and node_(9)
set tcp_(53) [new Agent/TCP/Newreno]
$tcp_(53) set class_ 2
set sink_(53) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(53)
$ns attach-agent $node_(9) $sink_(53)
$ns connect $tcp_(53) $sink_(53)
set ftp_(53) [new Application/FTP]
$ftp_(53) attach-agent $tcp_(53)
$ns at 540.2 "$ftp_(53) start"
$ns at 720.0 "$ftp_(53) stop"

#Set a TCP connection between node_(1) and node_(31)
set tcp_(54) [new Agent/TCP/Newreno]
$tcp_(54) set class_ 2
set sink_(54) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(54)
$ns attach-agent $node_(31) $sink_(54)
$ns connect $tcp_(54) $sink_(54)
set ftp_(54) [new Application/FTP]
$ftp_(54) attach-agent $tcp_(54)
$ns at 720.2 "$ftp_(54) start"
$ns at 900.0 "$ftp_(54) stop"

#Set a TCP connection between node_(40) and node_(45)
set tcp_(55) [new Agent/TCP/Newreno]
$tcp_(55) set class_ 2
set sink_(55) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(55)
$ns attach-agent $node_(45) $sink_(55)
$ns connect $tcp_(55) $sink_(55)
set ftp_(55) [new Application/FTP]
$ftp_(55) attach-agent $tcp_(55)
$ns at 0.2 "$ftp_(55) start"
$ns at 180.0 "$ftp_(55) stop"

#Set a TCP connection between node_(46) and node_(35)
set tcp_(56) [new Agent/TCP/Newreno]
$tcp_(56) set class_ 2
set sink_(56) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(56)
$ns attach-agent $node_(35) $sink_(56)
$ns connect $tcp_(56) $sink_(56)
set ftp_(56) [new Application/FTP]
$ftp_(56) attach-agent $tcp_(56)
$ns at 180.2 "$ftp_(56) start"
$ns at 360.0 "$ftp_(56) stop"

#Set a TCP connection between node_(11) and node_(26)
set tcp_(57) [new Agent/TCP/Newreno]
$tcp_(57) set class_ 2
set sink_(57) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(57)
$ns attach-agent $node_(26) $sink_(57)
$ns connect $tcp_(57) $sink_(57)
set ftp_(57) [new Application/FTP]
$ftp_(57) attach-agent $tcp_(57)
$ns at 360.2 "$ftp_(57) start"
$ns at 540.0 "$ftp_(57) stop"

#Set a TCP connection between node_(23) and node_(29)
set tcp_(58) [new Agent/TCP/Newreno]
$tcp_(58) set class_ 2
set sink_(58) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(58)
$ns attach-agent $node_(29) $sink_(58)
$ns connect $tcp_(58) $sink_(58)
set ftp_(58) [new Application/FTP]
$ftp_(58) attach-agent $tcp_(58)
$ns at 540.2 "$ftp_(58) start"
$ns at 720.0 "$ftp_(58) stop"

#Set a TCP connection between node_(40) and node_(49)
set tcp_(59) [new Agent/TCP/Newreno]
$tcp_(59) set class_ 2
set sink_(59) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(59)
$ns attach-agent $node_(49) $sink_(59)
$ns connect $tcp_(59) $sink_(59)
set ftp_(59) [new Application/FTP]
$ftp_(59) attach-agent $tcp_(59)
$ns at 720.2 "$ftp_(59) start"
$ns at 900.0 "$ftp_(59) stop"

#Set a TCP connection between node_(0) and node_(19)
set tcp_(60) [new Agent/TCP/Newreno]
$tcp_(60) set class_ 2
set sink_(60) [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp_(60)
$ns attach-agent $node_(19) $sink_(60)
$ns connect $tcp_(60) $sink_(60)
set ftp_(60) [new Application/FTP]
$ftp_(60) attach-agent $tcp_(60)
$ns at 0.2 "$ftp_(60) start"
$ns at 180.0 "$ftp_(60) stop"

#Set a TCP connection between node_(20) and node_(17)
set tcp_(61) [new Agent/TCP/Newreno]
$tcp_(61) set class_ 2
set sink_(61) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(61)
$ns attach-agent $node_(17) $sink_(61)
$ns connect $tcp_(61) $sink_(61)
set ftp_(61) [new Application/FTP]
$ftp_(61) attach-agent $tcp_(61)
$ns at 180.2 "$ftp_(61) start"
$ns at 360.0 "$ftp_(61) stop"

#Set a TCP connection between node_(47) and node_(45)
set tcp_(62) [new Agent/TCP/Newreno]
$tcp_(62) set class_ 2
set sink_(62) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(62)
$ns attach-agent $node_(45) $sink_(62)
$ns connect $tcp_(62) $sink_(62)
set ftp_(62) [new Application/FTP]
$ftp_(62) attach-agent $tcp_(62)
$ns at 360.2 "$ftp_(62) start"
$ns at 540.0 "$ftp_(62) stop"

#Set a TCP connection between node_(30) and node_(29)
set tcp_(63) [new Agent/TCP/Newreno]
$tcp_(63) set class_ 2
set sink_(63) [new Agent/TCPSink]
$ns attach-agent $node_(30) $tcp_(63)
$ns attach-agent $node_(29) $sink_(63)
$ns connect $tcp_(63) $sink_(63)
set ftp_(63) [new Application/FTP]
$ftp_(63) attach-agent $tcp_(63)
$ns at 540.2 "$ftp_(63) start"
$ns at 720.0 "$ftp_(63) stop"

#Set a TCP connection between node_(40) and node_(33)
set tcp_(64) [new Agent/TCP/Newreno]
$tcp_(64) set class_ 2
set sink_(64) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(64)
$ns attach-agent $node_(33) $sink_(64)
$ns connect $tcp_(64) $sink_(64)
set ftp_(64) [new Application/FTP]
$ftp_(64) attach-agent $tcp_(64)
$ns at 720.2 "$ftp_(64) start"
$ns at 900.0 "$ftp_(64) stop"

#Set a TCP connection between node_(45) and node_(11)
set tcp_(65) [new Agent/TCP/Newreno]
$tcp_(65) set class_ 2
set sink_(65) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(65)
$ns attach-agent $node_(11) $sink_(65)
$ns connect $tcp_(65) $sink_(65)
set ftp_(65) [new Application/FTP]
$ftp_(65) attach-agent $tcp_(65)
$ns at 0.2 "$ftp_(65) start"
$ns at 180.0 "$ftp_(65) stop"

#Set a TCP connection between node_(46) and node_(36)
set tcp_(66) [new Agent/TCP/Newreno]
$tcp_(66) set class_ 2
set sink_(66) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(66)
$ns attach-agent $node_(36) $sink_(66)
$ns connect $tcp_(66) $sink_(66)
set ftp_(66) [new Application/FTP]
$ftp_(66) attach-agent $tcp_(66)
$ns at 180.2 "$ftp_(66) start"
$ns at 360.0 "$ftp_(66) stop"

#Set a TCP connection between node_(17) and node_(19)
set tcp_(67) [new Agent/TCP/Newreno]
$tcp_(67) set class_ 2
set sink_(67) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(67)
$ns attach-agent $node_(19) $sink_(67)
$ns connect $tcp_(67) $sink_(67)
set ftp_(67) [new Application/FTP]
$ftp_(67) attach-agent $tcp_(67)
$ns at 360.2 "$ftp_(67) start"
$ns at 540.0 "$ftp_(67) stop"

#Set a TCP connection between node_(49) and node_(6)
set tcp_(68) [new Agent/TCP/Newreno]
$tcp_(68) set class_ 2
set sink_(68) [new Agent/TCPSink]
$ns attach-agent $node_(49) $tcp_(68)
$ns attach-agent $node_(6) $sink_(68)
$ns connect $tcp_(68) $sink_(68)
set ftp_(68) [new Application/FTP]
$ftp_(68) attach-agent $tcp_(68)
$ns at 540.2 "$ftp_(68) start"
$ns at 720.0 "$ftp_(68) stop"

#Set a TCP connection between node_(20) and node_(39)
set tcp_(69) [new Agent/TCP/Newreno]
$tcp_(69) set class_ 2
set sink_(69) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(69)
$ns attach-agent $node_(39) $sink_(69)
$ns connect $tcp_(69) $sink_(69)
set ftp_(69) [new Application/FTP]
$ftp_(69) attach-agent $tcp_(69)
$ns at 720.2 "$ftp_(69) start"
$ns at 900.0 "$ftp_(69) stop"

#Set a TCP connection between node_(14) and node_(18)
set tcp_(70) [new Agent/TCP/Newreno]
$tcp_(70) set class_ 2
set sink_(70) [new Agent/TCPSink]
$ns attach-agent $node_(14) $tcp_(70)
$ns attach-agent $node_(18) $sink_(70)
$ns connect $tcp_(70) $sink_(70)
set ftp_(70) [new Application/FTP]
$ftp_(70) attach-agent $tcp_(70)
$ns at 0.2 "$ftp_(70) start"
$ns at 180.0 "$ftp_(70) stop"

#Set a TCP connection between node_(35) and node_(10)
set tcp_(71) [new Agent/TCP/Newreno]
$tcp_(71) set class_ 2
set sink_(71) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(71)
$ns attach-agent $node_(10) $sink_(71)
$ns connect $tcp_(71) $sink_(71)
set ftp_(71) [new Application/FTP]
$ftp_(71) attach-agent $tcp_(71)
$ns at 180.2 "$ftp_(71) start"
$ns at 360.0 "$ftp_(71) stop"

#Set a TCP connection between node_(32) and node_(15)
set tcp_(72) [new Agent/TCP/Newreno]
$tcp_(72) set class_ 2
set sink_(72) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(72)
$ns attach-agent $node_(15) $sink_(72)
$ns connect $tcp_(72) $sink_(72)
set ftp_(72) [new Application/FTP]
$ftp_(72) attach-agent $tcp_(72)
$ns at 360.2 "$ftp_(72) start"
$ns at 540.0 "$ftp_(72) stop"

#Set a TCP connection between node_(0) and node_(20)
set tcp_(73) [new Agent/TCP/Newreno]
$tcp_(73) set class_ 2
set sink_(73) [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp_(73)
$ns attach-agent $node_(20) $sink_(73)
$ns connect $tcp_(73) $sink_(73)
set ftp_(73) [new Application/FTP]
$ftp_(73) attach-agent $tcp_(73)
$ns at 540.2 "$ftp_(73) start"
$ns at 720.0 "$ftp_(73) stop"

#Set a TCP connection between node_(0) and node_(7)
set tcp_(74) [new Agent/TCP/Newreno]
$tcp_(74) set class_ 2
set sink_(74) [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp_(74)
$ns attach-agent $node_(7) $sink_(74)
$ns connect $tcp_(74) $sink_(74)
set ftp_(74) [new Application/FTP]
$ftp_(74) attach-agent $tcp_(74)
$ns at 720.2 "$ftp_(74) start"
$ns at 900.0 "$ftp_(74) stop"

#Set a TCP connection between node_(26) and node_(17)
set tcp_(75) [new Agent/TCP/Newreno]
$tcp_(75) set class_ 2
set sink_(75) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(75)
$ns attach-agent $node_(17) $sink_(75)
$ns connect $tcp_(75) $sink_(75)
set ftp_(75) [new Application/FTP]
$ftp_(75) attach-agent $tcp_(75)
$ns at 0.2 "$ftp_(75) start"
$ns at 180.0 "$ftp_(75) stop"

#Set a TCP connection between node_(33) and node_(9)
set tcp_(76) [new Agent/TCP/Newreno]
$tcp_(76) set class_ 2
set sink_(76) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(76)
$ns attach-agent $node_(9) $sink_(76)
$ns connect $tcp_(76) $sink_(76)
set ftp_(76) [new Application/FTP]
$ftp_(76) attach-agent $tcp_(76)
$ns at 180.2 "$ftp_(76) start"
$ns at 360.0 "$ftp_(76) stop"

#Set a TCP connection between node_(35) and node_(46)
set tcp_(77) [new Agent/TCP/Newreno]
$tcp_(77) set class_ 2
set sink_(77) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(77)
$ns attach-agent $node_(46) $sink_(77)
$ns connect $tcp_(77) $sink_(77)
set ftp_(77) [new Application/FTP]
$ftp_(77) attach-agent $tcp_(77)
$ns at 360.2 "$ftp_(77) start"
$ns at 540.0 "$ftp_(77) stop"

#Set a TCP connection between node_(27) and node_(17)
set tcp_(78) [new Agent/TCP/Newreno]
$tcp_(78) set class_ 2
set sink_(78) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(78)
$ns attach-agent $node_(17) $sink_(78)
$ns connect $tcp_(78) $sink_(78)
set ftp_(78) [new Application/FTP]
$ftp_(78) attach-agent $tcp_(78)
$ns at 540.2 "$ftp_(78) start"
$ns at 720.0 "$ftp_(78) stop"

#Set a TCP connection between node_(21) and node_(1)
set tcp_(79) [new Agent/TCP/Newreno]
$tcp_(79) set class_ 2
set sink_(79) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(79)
$ns attach-agent $node_(1) $sink_(79)
$ns connect $tcp_(79) $sink_(79)
set ftp_(79) [new Application/FTP]
$ftp_(79) attach-agent $tcp_(79)
$ns at 720.2 "$ftp_(79) start"
$ns at 900.0 "$ftp_(79) stop"

#Set a TCP connection between node_(37) and node_(9)
set tcp_(80) [new Agent/TCP/Newreno]
$tcp_(80) set class_ 2
set sink_(80) [new Agent/TCPSink]
$ns attach-agent $node_(37) $tcp_(80)
$ns attach-agent $node_(9) $sink_(80)
$ns connect $tcp_(80) $sink_(80)
set ftp_(80) [new Application/FTP]
$ftp_(80) attach-agent $tcp_(80)
$ns at 0.2 "$ftp_(80) start"
$ns at 180.0 "$ftp_(80) stop"

#Set a TCP connection between node_(35) and node_(0)
set tcp_(81) [new Agent/TCP/Newreno]
$tcp_(81) set class_ 2
set sink_(81) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(81)
$ns attach-agent $node_(0) $sink_(81)
$ns connect $tcp_(81) $sink_(81)
set ftp_(81) [new Application/FTP]
$ftp_(81) attach-agent $tcp_(81)
$ns at 180.2 "$ftp_(81) start"
$ns at 360.0 "$ftp_(81) stop"

#Set a TCP connection between node_(19) and node_(35)
set tcp_(82) [new Agent/TCP/Newreno]
$tcp_(82) set class_ 2
set sink_(82) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(82)
$ns attach-agent $node_(35) $sink_(82)
$ns connect $tcp_(82) $sink_(82)
set ftp_(82) [new Application/FTP]
$ftp_(82) attach-agent $tcp_(82)
$ns at 360.2 "$ftp_(82) start"
$ns at 540.0 "$ftp_(82) stop"

#Set a TCP connection between node_(43) and node_(35)
set tcp_(83) [new Agent/TCP/Newreno]
$tcp_(83) set class_ 2
set sink_(83) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(83)
$ns attach-agent $node_(35) $sink_(83)
$ns connect $tcp_(83) $sink_(83)
set ftp_(83) [new Application/FTP]
$ftp_(83) attach-agent $tcp_(83)
$ns at 540.2 "$ftp_(83) start"
$ns at 720.0 "$ftp_(83) stop"

#Set a TCP connection between node_(1) and node_(48)
set tcp_(84) [new Agent/TCP/Newreno]
$tcp_(84) set class_ 2
set sink_(84) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(84)
$ns attach-agent $node_(48) $sink_(84)
$ns connect $tcp_(84) $sink_(84)
set ftp_(84) [new Application/FTP]
$ftp_(84) attach-agent $tcp_(84)
$ns at 720.2 "$ftp_(84) start"
$ns at 900.0 "$ftp_(84) stop"

#Set a TCP connection between node_(1) and node_(15)
set tcp_(85) [new Agent/TCP/Newreno]
$tcp_(85) set class_ 2
set sink_(85) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(85)
$ns attach-agent $node_(15) $sink_(85)
$ns connect $tcp_(85) $sink_(85)
set ftp_(85) [new Application/FTP]
$ftp_(85) attach-agent $tcp_(85)
$ns at 0.2 "$ftp_(85) start"
$ns at 180.0 "$ftp_(85) stop"

#Set a TCP connection between node_(40) and node_(38)
set tcp_(86) [new Agent/TCP/Newreno]
$tcp_(86) set class_ 2
set sink_(86) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(86)
$ns attach-agent $node_(38) $sink_(86)
$ns connect $tcp_(86) $sink_(86)
set ftp_(86) [new Application/FTP]
$ftp_(86) attach-agent $tcp_(86)
$ns at 180.2 "$ftp_(86) start"
$ns at 360.0 "$ftp_(86) stop"

#Set a TCP connection between node_(28) and node_(5)
set tcp_(87) [new Agent/TCP/Newreno]
$tcp_(87) set class_ 2
set sink_(87) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(87)
$ns attach-agent $node_(5) $sink_(87)
$ns connect $tcp_(87) $sink_(87)
set ftp_(87) [new Application/FTP]
$ftp_(87) attach-agent $tcp_(87)
$ns at 360.2 "$ftp_(87) start"
$ns at 540.0 "$ftp_(87) stop"

#Set a TCP connection between node_(18) and node_(35)
set tcp_(88) [new Agent/TCP/Newreno]
$tcp_(88) set class_ 2
set sink_(88) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(88)
$ns attach-agent $node_(35) $sink_(88)
$ns connect $tcp_(88) $sink_(88)
set ftp_(88) [new Application/FTP]
$ftp_(88) attach-agent $tcp_(88)
$ns at 540.2 "$ftp_(88) start"
$ns at 720.0 "$ftp_(88) stop"

#Set a TCP connection between node_(32) and node_(42)
set tcp_(89) [new Agent/TCP/Newreno]
$tcp_(89) set class_ 2
set sink_(89) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(89)
$ns attach-agent $node_(42) $sink_(89)
$ns connect $tcp_(89) $sink_(89)
set ftp_(89) [new Application/FTP]
$ftp_(89) attach-agent $tcp_(89)
$ns at 720.2 "$ftp_(89) start"
$ns at 900.0 "$ftp_(89) stop"

#Set a TCP connection between node_(15) and node_(1)
set tcp_(90) [new Agent/TCP/Newreno]
$tcp_(90) set class_ 2
set sink_(90) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(90)
$ns attach-agent $node_(1) $sink_(90)
$ns connect $tcp_(90) $sink_(90)
set ftp_(90) [new Application/FTP]
$ftp_(90) attach-agent $tcp_(90)
$ns at 0.2 "$ftp_(90) start"
$ns at 180.0 "$ftp_(90) stop"

#Set a TCP connection between node_(44) and node_(43)
set tcp_(91) [new Agent/TCP/Newreno]
$tcp_(91) set class_ 2
set sink_(91) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(91)
$ns attach-agent $node_(43) $sink_(91)
$ns connect $tcp_(91) $sink_(91)
set ftp_(91) [new Application/FTP]
$ftp_(91) attach-agent $tcp_(91)
$ns at 180.2 "$ftp_(91) start"
$ns at 360.0 "$ftp_(91) stop"

#Set a TCP connection between node_(42) and node_(20)
set tcp_(92) [new Agent/TCP/Newreno]
$tcp_(92) set class_ 2
set sink_(92) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(92)
$ns attach-agent $node_(20) $sink_(92)
$ns connect $tcp_(92) $sink_(92)
set ftp_(92) [new Application/FTP]
$ftp_(92) attach-agent $tcp_(92)
$ns at 360.2 "$ftp_(92) start"
$ns at 540.0 "$ftp_(92) stop"

#Set a TCP connection between node_(5) and node_(25)
set tcp_(93) [new Agent/TCP/Newreno]
$tcp_(93) set class_ 2
set sink_(93) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(93)
$ns attach-agent $node_(25) $sink_(93)
$ns connect $tcp_(93) $sink_(93)
set ftp_(93) [new Application/FTP]
$ftp_(93) attach-agent $tcp_(93)
$ns at 540.2 "$ftp_(93) start"
$ns at 720.0 "$ftp_(93) stop"

#Set a TCP connection between node_(33) and node_(31)
set tcp_(94) [new Agent/TCP/Newreno]
$tcp_(94) set class_ 2
set sink_(94) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(94)
$ns attach-agent $node_(31) $sink_(94)
$ns connect $tcp_(94) $sink_(94)
set ftp_(94) [new Application/FTP]
$ftp_(94) attach-agent $tcp_(94)
$ns at 720.2 "$ftp_(94) start"
$ns at 900.0 "$ftp_(94) stop"

#Set a TCP connection between node_(11) and node_(27)
set tcp_(95) [new Agent/TCP/Newreno]
$tcp_(95) set class_ 2
set sink_(95) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(95)
$ns attach-agent $node_(27) $sink_(95)
$ns connect $tcp_(95) $sink_(95)
set ftp_(95) [new Application/FTP]
$ftp_(95) attach-agent $tcp_(95)
$ns at 0.2 "$ftp_(95) start"
$ns at 180.0 "$ftp_(95) stop"

#Set a TCP connection between node_(47) and node_(38)
set tcp_(96) [new Agent/TCP/Newreno]
$tcp_(96) set class_ 2
set sink_(96) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(96)
$ns attach-agent $node_(38) $sink_(96)
$ns connect $tcp_(96) $sink_(96)
set ftp_(96) [new Application/FTP]
$ftp_(96) attach-agent $tcp_(96)
$ns at 180.2 "$ftp_(96) start"
$ns at 360.0 "$ftp_(96) stop"

#Set a TCP connection between node_(6) and node_(43)
set tcp_(97) [new Agent/TCP/Newreno]
$tcp_(97) set class_ 2
set sink_(97) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(97)
$ns attach-agent $node_(43) $sink_(97)
$ns connect $tcp_(97) $sink_(97)
set ftp_(97) [new Application/FTP]
$ftp_(97) attach-agent $tcp_(97)
$ns at 360.2 "$ftp_(97) start"
$ns at 540.0 "$ftp_(97) stop"

#Set a TCP connection between node_(7) and node_(45)
set tcp_(98) [new Agent/TCP/Newreno]
$tcp_(98) set class_ 2
set sink_(98) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(98)
$ns attach-agent $node_(45) $sink_(98)
$ns connect $tcp_(98) $sink_(98)
set ftp_(98) [new Application/FTP]
$ftp_(98) attach-agent $tcp_(98)
$ns at 540.2 "$ftp_(98) start"
$ns at 720.0 "$ftp_(98) stop"

#Set a TCP connection between node_(11) and node_(8)
set tcp_(99) [new Agent/TCP/Newreno]
$tcp_(99) set class_ 2
set sink_(99) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(99)
$ns attach-agent $node_(8) $sink_(99)
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
