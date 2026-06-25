#sim-scn3-0.tcl 
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
set val(nn)             800                        ;# number of mobilenodes
set val(rp)             [lindex $argv 0]                  ;# routing protocol
set val(x)              268328   			        ;# X dimension of topography
set val(y)              89443   					;# Y dimension of topography
set val(stop)			 900					   	    ;# time of simulation end
set opt(energymodel)    EnergyModel     	   ;# Energy mode on
set opt(initialenergy)  10000            	   ;# Initial energy in Joules

if { $val(rp) == "AntHocNet" } {
	set val(ifq)            CMUPriQueue
} else {
	set val(ifq)            Queue/DropTail/PriQueue
}

set ns		  [new Simulator]
set tracefd       [open sim-scn3-0-$val(rp)-trace.tr w]
set windowVsTime2 [open sim-scn3-0-$val(rp)-win-.tr w]
set namtrace      [open sim-scn3-0-$val(rp).nam w]

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
$node_(0) set X_ 1872 
$node_(0) set Y_ 202 
$node_(0) set Z_ 0.0 
$node_(1) set X_ 207 
$node_(1) set Y_ 28 
$node_(1) set Z_ 0.0 
$node_(2) set X_ 766 
$node_(2) set Y_ 208 
$node_(2) set Z_ 0.0 
$node_(3) set X_ 1959 
$node_(3) set Y_ 414 
$node_(3) set Z_ 0.0 
$node_(4) set X_ 1251 
$node_(4) set Y_ 790 
$node_(4) set Z_ 0.0 
$node_(5) set X_ 1369 
$node_(5) set Y_ 879 
$node_(5) set Z_ 0.0 
$node_(6) set X_ 871 
$node_(6) set Y_ 368 
$node_(6) set Z_ 0.0 
$node_(7) set X_ 1478 
$node_(7) set Y_ 550 
$node_(7) set Z_ 0.0 
$node_(8) set X_ 1735 
$node_(8) set Y_ 951 
$node_(8) set Z_ 0.0 
$node_(9) set X_ 1668 
$node_(9) set Y_ 250 
$node_(9) set Z_ 0.0 
$node_(10) set X_ 1691 
$node_(10) set Y_ 111 
$node_(10) set Z_ 0.0 
$node_(11) set X_ 681 
$node_(11) set Y_ 488 
$node_(11) set Z_ 0.0 
$node_(12) set X_ 2287 
$node_(12) set Y_ 788 
$node_(12) set Z_ 0.0 
$node_(13) set X_ 2354 
$node_(13) set Y_ 65 
$node_(13) set Z_ 0.0 
$node_(14) set X_ 96 
$node_(14) set Y_ 562 
$node_(14) set Z_ 0.0 
$node_(15) set X_ 1048 
$node_(15) set Y_ 832 
$node_(15) set Z_ 0.0 
$node_(16) set X_ 2136 
$node_(16) set Y_ 686 
$node_(16) set Z_ 0.0 
$node_(17) set X_ 1486 
$node_(17) set Y_ 152 
$node_(17) set Z_ 0.0 
$node_(18) set X_ 2226 
$node_(18) set Y_ 768 
$node_(18) set Z_ 0.0 
$node_(19) set X_ 1964 
$node_(19) set Y_ 972 
$node_(19) set Z_ 0.0 
$node_(20) set X_ 2196 
$node_(20) set Y_ 428 
$node_(20) set Z_ 0.0 
$node_(21) set X_ 2565 
$node_(21) set Y_ 267 
$node_(21) set Z_ 0.0 
$node_(22) set X_ 1947 
$node_(22) set Y_ 663 
$node_(22) set Z_ 0.0 
$node_(23) set X_ 2200 
$node_(23) set Y_ 768 
$node_(23) set Z_ 0.0 
$node_(24) set X_ 353 
$node_(24) set Y_ 924 
$node_(24) set Z_ 0.0 
$node_(25) set X_ 904 
$node_(25) set Y_ 546 
$node_(25) set Z_ 0.0 
$node_(26) set X_ 1004 
$node_(26) set Y_ 108 
$node_(26) set Z_ 0.0 
$node_(27) set X_ 1939 
$node_(27) set Y_ 26 
$node_(27) set Z_ 0.0 
$node_(28) set X_ 748 
$node_(28) set Y_ 770 
$node_(28) set Z_ 0.0 
$node_(29) set X_ 1800 
$node_(29) set Y_ 421 
$node_(29) set Z_ 0.0 
$node_(30) set X_ 2900 
$node_(30) set Y_ 852 
$node_(30) set Z_ 0.0 
$node_(31) set X_ 1291 
$node_(31) set Y_ 437 
$node_(31) set Z_ 0.0 
$node_(32) set X_ 926 
$node_(32) set Y_ 148 
$node_(32) set Z_ 0.0 
$node_(33) set X_ 2307 
$node_(33) set Y_ 312 
$node_(33) set Z_ 0.0 
$node_(34) set X_ 219 
$node_(34) set Y_ 542 
$node_(34) set Z_ 0.0 
$node_(35) set X_ 972 
$node_(35) set Y_ 909 
$node_(35) set Z_ 0.0 
$node_(36) set X_ 2473 
$node_(36) set Y_ 779 
$node_(36) set Z_ 0.0 
$node_(37) set X_ 1185 
$node_(37) set Y_ 643 
$node_(37) set Z_ 0.0 
$node_(38) set X_ 2920 
$node_(38) set Y_ 136 
$node_(38) set Z_ 0.0 
$node_(39) set X_ 2588 
$node_(39) set Y_ 461 
$node_(39) set Z_ 0.0 
$node_(40) set X_ 1509 
$node_(40) set Y_ 949 
$node_(40) set Z_ 0.0 
$node_(41) set X_ 308 
$node_(41) set Y_ 977 
$node_(41) set Z_ 0.0 
$node_(42) set X_ 2809 
$node_(42) set Y_ 331 
$node_(42) set Z_ 0.0 
$node_(43) set X_ 698 
$node_(43) set Y_ 116 
$node_(43) set Z_ 0.0 
$node_(44) set X_ 157 
$node_(44) set Y_ 814 
$node_(44) set Z_ 0.0 
$node_(45) set X_ 620 
$node_(45) set Y_ 325 
$node_(45) set Z_ 0.0 
$node_(46) set X_ 1228 
$node_(46) set Y_ 880 
$node_(46) set Z_ 0.0 
$node_(47) set X_ 1597 
$node_(47) set Y_ 454 
$node_(47) set Z_ 0.0 
$node_(48) set X_ 2872 
$node_(48) set Y_ 501 
$node_(48) set Z_ 0.0 
$node_(49) set X_ 2420 
$node_(49) set Y_ 937 
$node_(49) set Z_ 0.0 
$node_(50) set X_ 2669 
$node_(50) set Y_ 903 
$node_(50) set Z_ 0.0 
$node_(51) set X_ 2508 
$node_(51) set Y_ 770 
$node_(51) set Z_ 0.0 
$node_(52) set X_ 1228 
$node_(52) set Y_ 715 
$node_(52) set Z_ 0.0 
$node_(53) set X_ 2556 
$node_(53) set Y_ 110 
$node_(53) set Z_ 0.0 
$node_(54) set X_ 836 
$node_(54) set Y_ 550 
$node_(54) set Z_ 0.0 
$node_(55) set X_ 597 
$node_(55) set Y_ 993 
$node_(55) set Z_ 0.0 
$node_(56) set X_ 2557 
$node_(56) set Y_ 869 
$node_(56) set Z_ 0.0 
$node_(57) set X_ 2820 
$node_(57) set Y_ 828 
$node_(57) set Z_ 0.0 
$node_(58) set X_ 2389 
$node_(58) set Y_ 643 
$node_(58) set Z_ 0.0 
$node_(59) set X_ 14 
$node_(59) set Y_ 801 
$node_(59) set Z_ 0.0 
$node_(60) set X_ 2548 
$node_(60) set Y_ 954 
$node_(60) set Z_ 0.0 
$node_(61) set X_ 2618 
$node_(61) set Y_ 276 
$node_(61) set Z_ 0.0 
$node_(62) set X_ 2364 
$node_(62) set Y_ 154 
$node_(62) set Z_ 0.0 
$node_(63) set X_ 891 
$node_(63) set Y_ 613 
$node_(63) set Z_ 0.0 
$node_(64) set X_ 682 
$node_(64) set Y_ 645 
$node_(64) set Z_ 0.0 
$node_(65) set X_ 706 
$node_(65) set Y_ 536 
$node_(65) set Z_ 0.0 
$node_(66) set X_ 25 
$node_(66) set Y_ 624 
$node_(66) set Z_ 0.0 
$node_(67) set X_ 2965 
$node_(67) set Y_ 375 
$node_(67) set Z_ 0.0 
$node_(68) set X_ 2115 
$node_(68) set Y_ 385 
$node_(68) set Z_ 0.0 
$node_(69) set X_ 1568 
$node_(69) set Y_ 7 
$node_(69) set Z_ 0.0 
$node_(70) set X_ 634 
$node_(70) set Y_ 901 
$node_(70) set Z_ 0.0 
$node_(71) set X_ 281 
$node_(71) set Y_ 318 
$node_(71) set Z_ 0.0 
$node_(72) set X_ 1403 
$node_(72) set Y_ 424 
$node_(72) set Z_ 0.0 
$node_(73) set X_ 1735 
$node_(73) set Y_ 357 
$node_(73) set Z_ 0.0 
$node_(74) set X_ 390 
$node_(74) set Y_ 802 
$node_(74) set Z_ 0.0 
$node_(75) set X_ 1140 
$node_(75) set Y_ 114 
$node_(75) set Z_ 0.0 
$node_(76) set X_ 1156 
$node_(76) set Y_ 66 
$node_(76) set Z_ 0.0 
$node_(77) set X_ 1101 
$node_(77) set Y_ 57 
$node_(77) set Z_ 0.0 
$node_(78) set X_ 538 
$node_(78) set Y_ 560 
$node_(78) set Z_ 0.0 
$node_(79) set X_ 242 
$node_(79) set Y_ 112 
$node_(79) set Z_ 0.0 
$node_(80) set X_ 2526 
$node_(80) set Y_ 601 
$node_(80) set Z_ 0.0 
$node_(81) set X_ 1059 
$node_(81) set Y_ 794 
$node_(81) set Z_ 0.0 
$node_(82) set X_ 1377 
$node_(82) set Y_ 174 
$node_(82) set Z_ 0.0 
$node_(83) set X_ 1695 
$node_(83) set Y_ 565 
$node_(83) set Z_ 0.0 
$node_(84) set X_ 1127 
$node_(84) set Y_ 665 
$node_(84) set Z_ 0.0 
$node_(85) set X_ 2990 
$node_(85) set Y_ 315 
$node_(85) set Z_ 0.0 
$node_(86) set X_ 2689 
$node_(86) set Y_ 27 
$node_(86) set Z_ 0.0 
$node_(87) set X_ 327 
$node_(87) set Y_ 47 
$node_(87) set Z_ 0.0 
$node_(88) set X_ 1769 
$node_(88) set Y_ 14 
$node_(88) set Z_ 0.0 
$node_(89) set X_ 447 
$node_(89) set Y_ 507 
$node_(89) set Z_ 0.0 
$node_(90) set X_ 1808 
$node_(90) set Y_ 378 
$node_(90) set Z_ 0.0 
$node_(91) set X_ 487 
$node_(91) set Y_ 454 
$node_(91) set Z_ 0.0 
$node_(92) set X_ 121 
$node_(92) set Y_ 951 
$node_(92) set Z_ 0.0 
$node_(93) set X_ 1062 
$node_(93) set Y_ 759 
$node_(93) set Z_ 0.0 
$node_(94) set X_ 2345 
$node_(94) set Y_ 599 
$node_(94) set Z_ 0.0 
$node_(95) set X_ 2273 
$node_(95) set Y_ 300 
$node_(95) set Z_ 0.0 
$node_(96) set X_ 181 
$node_(96) set Y_ 902 
$node_(96) set Z_ 0.0 
$node_(97) set X_ 1002 
$node_(97) set Y_ 905 
$node_(97) set Z_ 0.0 
$node_(98) set X_ 2309 
$node_(98) set Y_ 265 
$node_(98) set Z_ 0.0 
$node_(99) set X_ 2852 
$node_(99) set Y_ 201 
$node_(99) set Z_ 0.0 
$node_(100) set X_ 2168 
$node_(100) set Y_ 861 
$node_(100) set Z_ 0.0 
$node_(101) set X_ 524 
$node_(101) set Y_ 308 
$node_(101) set Z_ 0.0 
$ns at 0.0 "$node_(101) off" 
$ns at 100.0 "$node_(101) on" 
$node_(102) set X_ 111 
$node_(102) set Y_ 460 
$node_(102) set Z_ 0.0 
$ns at 0.0 "$node_(102) off" 
$ns at 100.0 "$node_(102) on" 
$node_(103) set X_ 1333 
$node_(103) set Y_ 754 
$node_(103) set Z_ 0.0 
$ns at 0.0 "$node_(103) off" 
$ns at 100.0 "$node_(103) on" 
$node_(104) set X_ 1209 
$node_(104) set Y_ 712 
$node_(104) set Z_ 0.0 
$ns at 0.0 "$node_(104) off" 
$ns at 100.0 "$node_(104) on" 
$node_(105) set X_ 2954 
$node_(105) set Y_ 875 
$node_(105) set Z_ 0.0 
$ns at 0.0 "$node_(105) off" 
$ns at 100.0 "$node_(105) on" 
$node_(106) set X_ 717 
$node_(106) set Y_ 920 
$node_(106) set Z_ 0.0 
$ns at 0.0 "$node_(106) off" 
$ns at 100.0 "$node_(106) on" 
$node_(107) set X_ 2351 
$node_(107) set Y_ 206 
$node_(107) set Z_ 0.0 
$ns at 0.0 "$node_(107) off" 
$ns at 100.0 "$node_(107) on" 
$node_(108) set X_ 1944 
$node_(108) set Y_ 655 
$node_(108) set Z_ 0.0 
$ns at 0.0 "$node_(108) off" 
$ns at 100.0 "$node_(108) on" 
$node_(109) set X_ 118 
$node_(109) set Y_ 64 
$node_(109) set Z_ 0.0 
$ns at 0.0 "$node_(109) off" 
$ns at 100.0 "$node_(109) on" 
$node_(110) set X_ 1920 
$node_(110) set Y_ 864 
$node_(110) set Z_ 0.0 
$ns at 0.0 "$node_(110) off" 
$ns at 100.0 "$node_(110) on" 
$node_(111) set X_ 2314 
$node_(111) set Y_ 615 
$node_(111) set Z_ 0.0 
$ns at 0.0 "$node_(111) off" 
$ns at 100.0 "$node_(111) on" 
$node_(112) set X_ 918 
$node_(112) set Y_ 227 
$node_(112) set Z_ 0.0 
$ns at 0.0 "$node_(112) off" 
$ns at 100.0 "$node_(112) on" 
$node_(113) set X_ 2065 
$node_(113) set Y_ 170 
$node_(113) set Z_ 0.0 
$ns at 0.0 "$node_(113) off" 
$ns at 100.0 "$node_(113) on" 
$node_(114) set X_ 1507 
$node_(114) set Y_ 641 
$node_(114) set Z_ 0.0 
$ns at 0.0 "$node_(114) off" 
$ns at 100.0 "$node_(114) on" 
$node_(115) set X_ 2985 
$node_(115) set Y_ 409 
$node_(115) set Z_ 0.0 
$ns at 0.0 "$node_(115) off" 
$ns at 100.0 "$node_(115) on" 
$node_(116) set X_ 382 
$node_(116) set Y_ 653 
$node_(116) set Z_ 0.0 
$ns at 0.0 "$node_(116) off" 
$ns at 100.0 "$node_(116) on" 
$node_(117) set X_ 1624 
$node_(117) set Y_ 458 
$node_(117) set Z_ 0.0 
$ns at 0.0 "$node_(117) off" 
$ns at 100.0 "$node_(117) on" 
$node_(118) set X_ 789 
$node_(118) set Y_ 537 
$node_(118) set Z_ 0.0 
$ns at 0.0 "$node_(118) off" 
$ns at 100.0 "$node_(118) on" 
$node_(119) set X_ 1838 
$node_(119) set Y_ 535 
$node_(119) set Z_ 0.0 
$ns at 0.0 "$node_(119) off" 
$ns at 100.0 "$node_(119) on" 
$node_(120) set X_ 870 
$node_(120) set Y_ 527 
$node_(120) set Z_ 0.0 
$ns at 0.0 "$node_(120) off" 
$ns at 100.0 "$node_(120) on" 
$node_(121) set X_ 2102 
$node_(121) set Y_ 927 
$node_(121) set Z_ 0.0 
$ns at 0.0 "$node_(121) off" 
$ns at 100.0 "$node_(121) on" 
$node_(122) set X_ 1755 
$node_(122) set Y_ 378 
$node_(122) set Z_ 0.0 
$ns at 0.0 "$node_(122) off" 
$ns at 100.0 "$node_(122) on" 
$node_(123) set X_ 2371 
$node_(123) set Y_ 612 
$node_(123) set Z_ 0.0 
$ns at 0.0 "$node_(123) off" 
$ns at 100.0 "$node_(123) on" 
$node_(124) set X_ 1683 
$node_(124) set Y_ 46 
$node_(124) set Z_ 0.0 
$ns at 0.0 "$node_(124) off" 
$ns at 100.0 "$node_(124) on" 
$node_(125) set X_ 197 
$node_(125) set Y_ 774 
$node_(125) set Z_ 0.0 
$ns at 0.0 "$node_(125) off" 
$ns at 100.0 "$node_(125) on" 
$node_(126) set X_ 1854 
$node_(126) set Y_ 774 
$node_(126) set Z_ 0.0 
$ns at 0.0 "$node_(126) off" 
$ns at 100.0 "$node_(126) on" 
$node_(127) set X_ 1310 
$node_(127) set Y_ 765 
$node_(127) set Z_ 0.0 
$ns at 0.0 "$node_(127) off" 
$ns at 100.0 "$node_(127) on" 
$node_(128) set X_ 142 
$node_(128) set Y_ 291 
$node_(128) set Z_ 0.0 
$ns at 0.0 "$node_(128) off" 
$ns at 100.0 "$node_(128) on" 
$node_(129) set X_ 2912 
$node_(129) set Y_ 837 
$node_(129) set Z_ 0.0 
$ns at 0.0 "$node_(129) off" 
$ns at 100.0 "$node_(129) on" 
$node_(130) set X_ 121 
$node_(130) set Y_ 126 
$node_(130) set Z_ 0.0 
$ns at 0.0 "$node_(130) off" 
$ns at 100.0 "$node_(130) on" 
$node_(131) set X_ 382 
$node_(131) set Y_ 78 
$node_(131) set Z_ 0.0 
$ns at 0.0 "$node_(131) off" 
$ns at 100.0 "$node_(131) on" 
$node_(132) set X_ 2231 
$node_(132) set Y_ 301 
$node_(132) set Z_ 0.0 
$ns at 0.0 "$node_(132) off" 
$ns at 100.0 "$node_(132) on" 
$node_(133) set X_ 2050 
$node_(133) set Y_ 587 
$node_(133) set Z_ 0.0 
$ns at 0.0 "$node_(133) off" 
$ns at 100.0 "$node_(133) on" 
$node_(134) set X_ 2184 
$node_(134) set Y_ 754 
$node_(134) set Z_ 0.0 
$ns at 0.0 "$node_(134) off" 
$ns at 100.0 "$node_(134) on" 
$node_(135) set X_ 1105 
$node_(135) set Y_ 820 
$node_(135) set Z_ 0.0 
$ns at 0.0 "$node_(135) off" 
$ns at 100.0 "$node_(135) on" 
$node_(136) set X_ 1010 
$node_(136) set Y_ 916 
$node_(136) set Z_ 0.0 
$ns at 0.0 "$node_(136) off" 
$ns at 100.0 "$node_(136) on" 
$node_(137) set X_ 1585 
$node_(137) set Y_ 461 
$node_(137) set Z_ 0.0 
$ns at 0.0 "$node_(137) off" 
$ns at 100.0 "$node_(137) on" 
$node_(138) set X_ 361 
$node_(138) set Y_ 773 
$node_(138) set Z_ 0.0 
$ns at 0.0 "$node_(138) off" 
$ns at 100.0 "$node_(138) on" 
$node_(139) set X_ 1755 
$node_(139) set Y_ 895 
$node_(139) set Z_ 0.0 
$ns at 0.0 "$node_(139) off" 
$ns at 100.0 "$node_(139) on" 
$node_(140) set X_ 2909 
$node_(140) set Y_ 637 
$node_(140) set Z_ 0.0 
$ns at 0.0 "$node_(140) off" 
$ns at 100.0 "$node_(140) on" 
$node_(141) set X_ 1972 
$node_(141) set Y_ 582 
$node_(141) set Z_ 0.0 
$ns at 0.0 "$node_(141) off" 
$ns at 100.0 "$node_(141) on" 
$node_(142) set X_ 1868 
$node_(142) set Y_ 554 
$node_(142) set Z_ 0.0 
$ns at 0.0 "$node_(142) off" 
$ns at 100.0 "$node_(142) on" 
$node_(143) set X_ 1471 
$node_(143) set Y_ 167 
$node_(143) set Z_ 0.0 
$ns at 0.0 "$node_(143) off" 
$ns at 100.0 "$node_(143) on" 
$node_(144) set X_ 2779 
$node_(144) set Y_ 983 
$node_(144) set Z_ 0.0 
$ns at 0.0 "$node_(144) off" 
$ns at 100.0 "$node_(144) on" 
$node_(145) set X_ 2207 
$node_(145) set Y_ 185 
$node_(145) set Z_ 0.0 
$ns at 0.0 "$node_(145) off" 
$ns at 100.0 "$node_(145) on" 
$node_(146) set X_ 1870 
$node_(146) set Y_ 914 
$node_(146) set Z_ 0.0 
$ns at 0.0 "$node_(146) off" 
$ns at 100.0 "$node_(146) on" 
$node_(147) set X_ 2160 
$node_(147) set Y_ 609 
$node_(147) set Z_ 0.0 
$ns at 0.0 "$node_(147) off" 
$ns at 100.0 "$node_(147) on" 
$node_(148) set X_ 1321 
$node_(148) set Y_ 92 
$node_(148) set Z_ 0.0 
$ns at 0.0 "$node_(148) off" 
$ns at 100.0 "$node_(148) on" 
$node_(149) set X_ 187 
$node_(149) set Y_ 273 
$node_(149) set Z_ 0.0 
$ns at 0.0 "$node_(149) off" 
$ns at 100.0 "$node_(149) on" 
$node_(150) set X_ 2882 
$node_(150) set Y_ 374 
$node_(150) set Z_ 0.0 
$ns at 0.0 "$node_(150) off" 
$ns at 100.0 "$node_(150) on" 
$node_(151) set X_ 2646 
$node_(151) set Y_ 432 
$node_(151) set Z_ 0.0 
$ns at 0.0 "$node_(151) off" 
$ns at 100.0 "$node_(151) on" 
$node_(152) set X_ 264 
$node_(152) set Y_ 546 
$node_(152) set Z_ 0.0 
$ns at 0.0 "$node_(152) off" 
$ns at 100.0 "$node_(152) on" 
$node_(153) set X_ 2697 
$node_(153) set Y_ 326 
$node_(153) set Z_ 0.0 
$ns at 0.0 "$node_(153) off" 
$ns at 100.0 "$node_(153) on" 
$node_(154) set X_ 2750 
$node_(154) set Y_ 111 
$node_(154) set Z_ 0.0 
$ns at 0.0 "$node_(154) off" 
$ns at 100.0 "$node_(154) on" 
$node_(155) set X_ 1241 
$node_(155) set Y_ 631 
$node_(155) set Z_ 0.0 
$ns at 0.0 "$node_(155) off" 
$ns at 100.0 "$node_(155) on" 
$node_(156) set X_ 1409 
$node_(156) set Y_ 665 
$node_(156) set Z_ 0.0 
$ns at 0.0 "$node_(156) off" 
$ns at 100.0 "$node_(156) on" 
$node_(157) set X_ 53 
$node_(157) set Y_ 111 
$node_(157) set Z_ 0.0 
$ns at 0.0 "$node_(157) off" 
$ns at 100.0 "$node_(157) on" 
$node_(158) set X_ 233 
$node_(158) set Y_ 467 
$node_(158) set Z_ 0.0 
$ns at 0.0 "$node_(158) off" 
$ns at 100.0 "$node_(158) on" 
$node_(159) set X_ 2684 
$node_(159) set Y_ 626 
$node_(159) set Z_ 0.0 
$ns at 0.0 "$node_(159) off" 
$ns at 100.0 "$node_(159) on" 
$node_(160) set X_ 423 
$node_(160) set Y_ 754 
$node_(160) set Z_ 0.0 
$ns at 0.0 "$node_(160) off" 
$ns at 100.0 "$node_(160) on" 
$node_(161) set X_ 2244 
$node_(161) set Y_ 875 
$node_(161) set Z_ 0.0 
$ns at 0.0 "$node_(161) off" 
$ns at 100.0 "$node_(161) on" 
$node_(162) set X_ 1903 
$node_(162) set Y_ 118 
$node_(162) set Z_ 0.0 
$ns at 0.0 "$node_(162) off" 
$ns at 100.0 "$node_(162) on" 
$node_(163) set X_ 2111 
$node_(163) set Y_ 909 
$node_(163) set Z_ 0.0 
$ns at 0.0 "$node_(163) off" 
$ns at 100.0 "$node_(163) on" 
$node_(164) set X_ 2981 
$node_(164) set Y_ 43 
$node_(164) set Z_ 0.0 
$ns at 0.0 "$node_(164) off" 
$ns at 100.0 "$node_(164) on" 
$node_(165) set X_ 101 
$node_(165) set Y_ 498 
$node_(165) set Z_ 0.0 
$ns at 0.0 "$node_(165) off" 
$ns at 100.0 "$node_(165) on" 
$node_(166) set X_ 2883 
$node_(166) set Y_ 280 
$node_(166) set Z_ 0.0 
$ns at 0.0 "$node_(166) off" 
$ns at 100.0 "$node_(166) on" 
$node_(167) set X_ 508 
$node_(167) set Y_ 893 
$node_(167) set Z_ 0.0 
$ns at 0.0 "$node_(167) off" 
$ns at 100.0 "$node_(167) on" 
$node_(168) set X_ 1652 
$node_(168) set Y_ 309 
$node_(168) set Z_ 0.0 
$ns at 0.0 "$node_(168) off" 
$ns at 100.0 "$node_(168) on" 
$node_(169) set X_ 826 
$node_(169) set Y_ 389 
$node_(169) set Z_ 0.0 
$ns at 0.0 "$node_(169) off" 
$ns at 100.0 "$node_(169) on" 
$node_(170) set X_ 1655 
$node_(170) set Y_ 558 
$node_(170) set Z_ 0.0 
$ns at 0.0 "$node_(170) off" 
$ns at 100.0 "$node_(170) on" 
$node_(171) set X_ 1821 
$node_(171) set Y_ 371 
$node_(171) set Z_ 0.0 
$ns at 0.0 "$node_(171) off" 
$ns at 100.0 "$node_(171) on" 
$node_(172) set X_ 2635 
$node_(172) set Y_ 413 
$node_(172) set Z_ 0.0 
$ns at 0.0 "$node_(172) off" 
$ns at 100.0 "$node_(172) on" 
$node_(173) set X_ 2917 
$node_(173) set Y_ 182 
$node_(173) set Z_ 0.0 
$ns at 0.0 "$node_(173) off" 
$ns at 100.0 "$node_(173) on" 
$node_(174) set X_ 1942 
$node_(174) set Y_ 296 
$node_(174) set Z_ 0.0 
$ns at 0.0 "$node_(174) off" 
$ns at 100.0 "$node_(174) on" 
$node_(175) set X_ 2663 
$node_(175) set Y_ 273 
$node_(175) set Z_ 0.0 
$ns at 0.0 "$node_(175) off" 
$ns at 100.0 "$node_(175) on" 
$node_(176) set X_ 217 
$node_(176) set Y_ 252 
$node_(176) set Z_ 0.0 
$ns at 0.0 "$node_(176) off" 
$ns at 100.0 "$node_(176) on" 
$node_(177) set X_ 1321 
$node_(177) set Y_ 531 
$node_(177) set Z_ 0.0 
$ns at 0.0 "$node_(177) off" 
$ns at 100.0 "$node_(177) on" 
$node_(178) set X_ 405 
$node_(178) set Y_ 559 
$node_(178) set Z_ 0.0 
$ns at 0.0 "$node_(178) off" 
$ns at 100.0 "$node_(178) on" 
$node_(179) set X_ 1291 
$node_(179) set Y_ 639 
$node_(179) set Z_ 0.0 
$ns at 0.0 "$node_(179) off" 
$ns at 100.0 "$node_(179) on" 
$node_(180) set X_ 1587 
$node_(180) set Y_ 849 
$node_(180) set Z_ 0.0 
$ns at 0.0 "$node_(180) off" 
$ns at 100.0 "$node_(180) on" 
$node_(181) set X_ 354 
$node_(181) set Y_ 557 
$node_(181) set Z_ 0.0 
$ns at 0.0 "$node_(181) off" 
$ns at 100.0 "$node_(181) on" 
$node_(182) set X_ 1651 
$node_(182) set Y_ 87 
$node_(182) set Z_ 0.0 
$ns at 0.0 "$node_(182) off" 
$ns at 100.0 "$node_(182) on" 
$node_(183) set X_ 2300 
$node_(183) set Y_ 989 
$node_(183) set Z_ 0.0 
$ns at 0.0 "$node_(183) off" 
$ns at 100.0 "$node_(183) on" 
$node_(184) set X_ 1352 
$node_(184) set Y_ 583 
$node_(184) set Z_ 0.0 
$ns at 0.0 "$node_(184) off" 
$ns at 100.0 "$node_(184) on" 
$node_(185) set X_ 708 
$node_(185) set Y_ 747 
$node_(185) set Z_ 0.0 
$ns at 0.0 "$node_(185) off" 
$ns at 100.0 "$node_(185) on" 
$node_(186) set X_ 804 
$node_(186) set Y_ 852 
$node_(186) set Z_ 0.0 
$ns at 0.0 "$node_(186) off" 
$ns at 100.0 "$node_(186) on" 
$node_(187) set X_ 204 
$node_(187) set Y_ 511 
$node_(187) set Z_ 0.0 
$ns at 0.0 "$node_(187) off" 
$ns at 100.0 "$node_(187) on" 
$node_(188) set X_ 906 
$node_(188) set Y_ 787 
$node_(188) set Z_ 0.0 
$ns at 0.0 "$node_(188) off" 
$ns at 100.0 "$node_(188) on" 
$node_(189) set X_ 2598 
$node_(189) set Y_ 351 
$node_(189) set Z_ 0.0 
$ns at 0.0 "$node_(189) off" 
$ns at 100.0 "$node_(189) on" 
$node_(190) set X_ 629 
$node_(190) set Y_ 74 
$node_(190) set Z_ 0.0 
$ns at 0.0 "$node_(190) off" 
$ns at 100.0 "$node_(190) on" 
$node_(191) set X_ 857 
$node_(191) set Y_ 750 
$node_(191) set Z_ 0.0 
$ns at 0.0 "$node_(191) off" 
$ns at 100.0 "$node_(191) on" 
$node_(192) set X_ 499 
$node_(192) set Y_ 212 
$node_(192) set Z_ 0.0 
$ns at 0.0 "$node_(192) off" 
$ns at 100.0 "$node_(192) on" 
$node_(193) set X_ 1861 
$node_(193) set Y_ 590 
$node_(193) set Z_ 0.0 
$ns at 0.0 "$node_(193) off" 
$ns at 100.0 "$node_(193) on" 
$node_(194) set X_ 1958 
$node_(194) set Y_ 813 
$node_(194) set Z_ 0.0 
$ns at 0.0 "$node_(194) off" 
$ns at 100.0 "$node_(194) on" 
$node_(195) set X_ 2367 
$node_(195) set Y_ 712 
$node_(195) set Z_ 0.0 
$ns at 0.0 "$node_(195) off" 
$ns at 100.0 "$node_(195) on" 
$node_(196) set X_ 642 
$node_(196) set Y_ 82 
$node_(196) set Z_ 0.0 
$ns at 0.0 "$node_(196) off" 
$ns at 100.0 "$node_(196) on" 
$node_(197) set X_ 1562 
$node_(197) set Y_ 209 
$node_(197) set Z_ 0.0 
$ns at 0.0 "$node_(197) off" 
$ns at 100.0 "$node_(197) on" 
$node_(198) set X_ 2909 
$node_(198) set Y_ 493 
$node_(198) set Z_ 0.0 
$ns at 0.0 "$node_(198) off" 
$ns at 100.0 "$node_(198) on" 
$node_(199) set X_ 1973 
$node_(199) set Y_ 576 
$node_(199) set Z_ 0.0 
$ns at 0.0 "$node_(199) off" 
$ns at 100.0 "$node_(199) on" 
$node_(200) set X_ 2209 
$node_(200) set Y_ 744 
$node_(200) set Z_ 0.0 
$ns at 0.0 "$node_(200) off" 
$ns at 200.0 "$node_(200) on" 
$node_(201) set X_ 2424 
$node_(201) set Y_ 193 
$node_(201) set Z_ 0.0 
$ns at 0.0 "$node_(201) off" 
$ns at 200.0 "$node_(201) on" 
$node_(202) set X_ 1158 
$node_(202) set Y_ 978 
$node_(202) set Z_ 0.0 
$ns at 0.0 "$node_(202) off" 
$ns at 200.0 "$node_(202) on" 
$node_(203) set X_ 37 
$node_(203) set Y_ 417 
$node_(203) set Z_ 0.0 
$ns at 0.0 "$node_(203) off" 
$ns at 200.0 "$node_(203) on" 
$node_(204) set X_ 1365 
$node_(204) set Y_ 140 
$node_(204) set Z_ 0.0 
$ns at 0.0 "$node_(204) off" 
$ns at 200.0 "$node_(204) on" 
$node_(205) set X_ 2125 
$node_(205) set Y_ 680 
$node_(205) set Z_ 0.0 
$ns at 0.0 "$node_(205) off" 
$ns at 200.0 "$node_(205) on" 
$node_(206) set X_ 242 
$node_(206) set Y_ 67 
$node_(206) set Z_ 0.0 
$ns at 0.0 "$node_(206) off" 
$ns at 200.0 "$node_(206) on" 
$node_(207) set X_ 103 
$node_(207) set Y_ 642 
$node_(207) set Z_ 0.0 
$ns at 0.0 "$node_(207) off" 
$ns at 200.0 "$node_(207) on" 
$node_(208) set X_ 188 
$node_(208) set Y_ 593 
$node_(208) set Z_ 0.0 
$ns at 0.0 "$node_(208) off" 
$ns at 200.0 "$node_(208) on" 
$node_(209) set X_ 1288 
$node_(209) set Y_ 384 
$node_(209) set Z_ 0.0 
$ns at 0.0 "$node_(209) off" 
$ns at 200.0 "$node_(209) on" 
$node_(210) set X_ 646 
$node_(210) set Y_ 503 
$node_(210) set Z_ 0.0 
$ns at 0.0 "$node_(210) off" 
$ns at 200.0 "$node_(210) on" 
$node_(211) set X_ 1707 
$node_(211) set Y_ 40 
$node_(211) set Z_ 0.0 
$ns at 0.0 "$node_(211) off" 
$ns at 200.0 "$node_(211) on" 
$node_(212) set X_ 602 
$node_(212) set Y_ 644 
$node_(212) set Z_ 0.0 
$ns at 0.0 "$node_(212) off" 
$ns at 200.0 "$node_(212) on" 
$node_(213) set X_ 2711 
$node_(213) set Y_ 80 
$node_(213) set Z_ 0.0 
$ns at 0.0 "$node_(213) off" 
$ns at 200.0 "$node_(213) on" 
$node_(214) set X_ 2184 
$node_(214) set Y_ 888 
$node_(214) set Z_ 0.0 
$ns at 0.0 "$node_(214) off" 
$ns at 200.0 "$node_(214) on" 
$node_(215) set X_ 1354 
$node_(215) set Y_ 640 
$node_(215) set Z_ 0.0 
$ns at 0.0 "$node_(215) off" 
$ns at 200.0 "$node_(215) on" 
$node_(216) set X_ 1001 
$node_(216) set Y_ 931 
$node_(216) set Z_ 0.0 
$ns at 0.0 "$node_(216) off" 
$ns at 200.0 "$node_(216) on" 
$node_(217) set X_ 148 
$node_(217) set Y_ 938 
$node_(217) set Z_ 0.0 
$ns at 0.0 "$node_(217) off" 
$ns at 200.0 "$node_(217) on" 
$node_(218) set X_ 2892 
$node_(218) set Y_ 86 
$node_(218) set Z_ 0.0 
$ns at 0.0 "$node_(218) off" 
$ns at 200.0 "$node_(218) on" 
$node_(219) set X_ 2869 
$node_(219) set Y_ 796 
$node_(219) set Z_ 0.0 
$ns at 0.0 "$node_(219) off" 
$ns at 200.0 "$node_(219) on" 
$node_(220) set X_ 677 
$node_(220) set Y_ 348 
$node_(220) set Z_ 0.0 
$ns at 0.0 "$node_(220) off" 
$ns at 200.0 "$node_(220) on" 
$node_(221) set X_ 1705 
$node_(221) set Y_ 770 
$node_(221) set Z_ 0.0 
$ns at 0.0 "$node_(221) off" 
$ns at 200.0 "$node_(221) on" 
$node_(222) set X_ 1459 
$node_(222) set Y_ 4 
$node_(222) set Z_ 0.0 
$ns at 0.0 "$node_(222) off" 
$ns at 200.0 "$node_(222) on" 
$node_(223) set X_ 35 
$node_(223) set Y_ 165 
$node_(223) set Z_ 0.0 
$ns at 0.0 "$node_(223) off" 
$ns at 200.0 "$node_(223) on" 
$node_(224) set X_ 2925 
$node_(224) set Y_ 967 
$node_(224) set Z_ 0.0 
$ns at 0.0 "$node_(224) off" 
$ns at 200.0 "$node_(224) on" 
$node_(225) set X_ 1652 
$node_(225) set Y_ 487 
$node_(225) set Z_ 0.0 
$ns at 0.0 "$node_(225) off" 
$ns at 200.0 "$node_(225) on" 
$node_(226) set X_ 1917 
$node_(226) set Y_ 845 
$node_(226) set Z_ 0.0 
$ns at 0.0 "$node_(226) off" 
$ns at 200.0 "$node_(226) on" 
$node_(227) set X_ 223 
$node_(227) set Y_ 529 
$node_(227) set Z_ 0.0 
$ns at 0.0 "$node_(227) off" 
$ns at 200.0 "$node_(227) on" 
$node_(228) set X_ 2453 
$node_(228) set Y_ 467 
$node_(228) set Z_ 0.0 
$ns at 0.0 "$node_(228) off" 
$ns at 200.0 "$node_(228) on" 
$node_(229) set X_ 1214 
$node_(229) set Y_ 314 
$node_(229) set Z_ 0.0 
$ns at 0.0 "$node_(229) off" 
$ns at 200.0 "$node_(229) on" 
$node_(230) set X_ 2102 
$node_(230) set Y_ 212 
$node_(230) set Z_ 0.0 
$ns at 0.0 "$node_(230) off" 
$ns at 200.0 "$node_(230) on" 
$node_(231) set X_ 2422 
$node_(231) set Y_ 610 
$node_(231) set Z_ 0.0 
$ns at 0.0 "$node_(231) off" 
$ns at 200.0 "$node_(231) on" 
$node_(232) set X_ 455 
$node_(232) set Y_ 58 
$node_(232) set Z_ 0.0 
$ns at 0.0 "$node_(232) off" 
$ns at 200.0 "$node_(232) on" 
$node_(233) set X_ 2646 
$node_(233) set Y_ 567 
$node_(233) set Z_ 0.0 
$ns at 0.0 "$node_(233) off" 
$ns at 200.0 "$node_(233) on" 
$node_(234) set X_ 2128 
$node_(234) set Y_ 656 
$node_(234) set Z_ 0.0 
$ns at 0.0 "$node_(234) off" 
$ns at 200.0 "$node_(234) on" 
$node_(235) set X_ 2872 
$node_(235) set Y_ 316 
$node_(235) set Z_ 0.0 
$ns at 0.0 "$node_(235) off" 
$ns at 200.0 "$node_(235) on" 
$node_(236) set X_ 1480 
$node_(236) set Y_ 135 
$node_(236) set Z_ 0.0 
$ns at 0.0 "$node_(236) off" 
$ns at 200.0 "$node_(236) on" 
$node_(237) set X_ 661 
$node_(237) set Y_ 39 
$node_(237) set Z_ 0.0 
$ns at 0.0 "$node_(237) off" 
$ns at 200.0 "$node_(237) on" 
$node_(238) set X_ 869 
$node_(238) set Y_ 560 
$node_(238) set Z_ 0.0 
$ns at 0.0 "$node_(238) off" 
$ns at 200.0 "$node_(238) on" 
$node_(239) set X_ 235 
$node_(239) set Y_ 97 
$node_(239) set Z_ 0.0 
$ns at 0.0 "$node_(239) off" 
$ns at 200.0 "$node_(239) on" 
$node_(240) set X_ 962 
$node_(240) set Y_ 154 
$node_(240) set Z_ 0.0 
$ns at 0.0 "$node_(240) off" 
$ns at 200.0 "$node_(240) on" 
$node_(241) set X_ 2000 
$node_(241) set Y_ 305 
$node_(241) set Z_ 0.0 
$ns at 0.0 "$node_(241) off" 
$ns at 200.0 "$node_(241) on" 
$node_(242) set X_ 190 
$node_(242) set Y_ 441 
$node_(242) set Z_ 0.0 
$ns at 0.0 "$node_(242) off" 
$ns at 200.0 "$node_(242) on" 
$node_(243) set X_ 2965 
$node_(243) set Y_ 330 
$node_(243) set Z_ 0.0 
$ns at 0.0 "$node_(243) off" 
$ns at 200.0 "$node_(243) on" 
$node_(244) set X_ 38 
$node_(244) set Y_ 460 
$node_(244) set Z_ 0.0 
$ns at 0.0 "$node_(244) off" 
$ns at 200.0 "$node_(244) on" 
$node_(245) set X_ 2726 
$node_(245) set Y_ 483 
$node_(245) set Z_ 0.0 
$ns at 0.0 "$node_(245) off" 
$ns at 200.0 "$node_(245) on" 
$node_(246) set X_ 1438 
$node_(246) set Y_ 57 
$node_(246) set Z_ 0.0 
$ns at 0.0 "$node_(246) off" 
$ns at 200.0 "$node_(246) on" 
$node_(247) set X_ 338 
$node_(247) set Y_ 911 
$node_(247) set Z_ 0.0 
$ns at 0.0 "$node_(247) off" 
$ns at 200.0 "$node_(247) on" 
$node_(248) set X_ 1009 
$node_(248) set Y_ 73 
$node_(248) set Z_ 0.0 
$ns at 0.0 "$node_(248) off" 
$ns at 200.0 "$node_(248) on" 
$node_(249) set X_ 529 
$node_(249) set Y_ 263 
$node_(249) set Z_ 0.0 
$ns at 0.0 "$node_(249) off" 
$ns at 200.0 "$node_(249) on" 
$node_(250) set X_ 420 
$node_(250) set Y_ 921 
$node_(250) set Z_ 0.0 
$ns at 0.0 "$node_(250) off" 
$ns at 200.0 "$node_(250) on" 
$node_(251) set X_ 311 
$node_(251) set Y_ 482 
$node_(251) set Z_ 0.0 
$ns at 0.0 "$node_(251) off" 
$ns at 200.0 "$node_(251) on" 
$node_(252) set X_ 591 
$node_(252) set Y_ 648 
$node_(252) set Z_ 0.0 
$ns at 0.0 "$node_(252) off" 
$ns at 200.0 "$node_(252) on" 
$node_(253) set X_ 119 
$node_(253) set Y_ 248 
$node_(253) set Z_ 0.0 
$ns at 0.0 "$node_(253) off" 
$ns at 200.0 "$node_(253) on" 
$node_(254) set X_ 2880 
$node_(254) set Y_ 87 
$node_(254) set Z_ 0.0 
$ns at 0.0 "$node_(254) off" 
$ns at 200.0 "$node_(254) on" 
$node_(255) set X_ 1141 
$node_(255) set Y_ 965 
$node_(255) set Z_ 0.0 
$ns at 0.0 "$node_(255) off" 
$ns at 200.0 "$node_(255) on" 
$node_(256) set X_ 1805 
$node_(256) set Y_ 111 
$node_(256) set Z_ 0.0 
$ns at 0.0 "$node_(256) off" 
$ns at 200.0 "$node_(256) on" 
$node_(257) set X_ 502 
$node_(257) set Y_ 914 
$node_(257) set Z_ 0.0 
$ns at 0.0 "$node_(257) off" 
$ns at 200.0 "$node_(257) on" 
$node_(258) set X_ 2212 
$node_(258) set Y_ 321 
$node_(258) set Z_ 0.0 
$ns at 0.0 "$node_(258) off" 
$ns at 200.0 "$node_(258) on" 
$node_(259) set X_ 1461 
$node_(259) set Y_ 331 
$node_(259) set Z_ 0.0 
$ns at 0.0 "$node_(259) off" 
$ns at 200.0 "$node_(259) on" 
$node_(260) set X_ 135 
$node_(260) set Y_ 715 
$node_(260) set Z_ 0.0 
$ns at 0.0 "$node_(260) off" 
$ns at 200.0 "$node_(260) on" 
$node_(261) set X_ 1703 
$node_(261) set Y_ 734 
$node_(261) set Z_ 0.0 
$ns at 0.0 "$node_(261) off" 
$ns at 200.0 "$node_(261) on" 
$node_(262) set X_ 2907 
$node_(262) set Y_ 29 
$node_(262) set Z_ 0.0 
$ns at 0.0 "$node_(262) off" 
$ns at 200.0 "$node_(262) on" 
$node_(263) set X_ 1230 
$node_(263) set Y_ 779 
$node_(263) set Z_ 0.0 
$ns at 0.0 "$node_(263) off" 
$ns at 200.0 "$node_(263) on" 
$node_(264) set X_ 2330 
$node_(264) set Y_ 478 
$node_(264) set Z_ 0.0 
$ns at 0.0 "$node_(264) off" 
$ns at 200.0 "$node_(264) on" 
$node_(265) set X_ 245 
$node_(265) set Y_ 270 
$node_(265) set Z_ 0.0 
$ns at 0.0 "$node_(265) off" 
$ns at 200.0 "$node_(265) on" 
$node_(266) set X_ 2986 
$node_(266) set Y_ 535 
$node_(266) set Z_ 0.0 
$ns at 0.0 "$node_(266) off" 
$ns at 200.0 "$node_(266) on" 
$node_(267) set X_ 753 
$node_(267) set Y_ 756 
$node_(267) set Z_ 0.0 
$ns at 0.0 "$node_(267) off" 
$ns at 200.0 "$node_(267) on" 
$node_(268) set X_ 1957 
$node_(268) set Y_ 282 
$node_(268) set Z_ 0.0 
$ns at 0.0 "$node_(268) off" 
$ns at 200.0 "$node_(268) on" 
$node_(269) set X_ 445 
$node_(269) set Y_ 281 
$node_(269) set Z_ 0.0 
$ns at 0.0 "$node_(269) off" 
$ns at 200.0 "$node_(269) on" 
$node_(270) set X_ 2401 
$node_(270) set Y_ 593 
$node_(270) set Z_ 0.0 
$ns at 0.0 "$node_(270) off" 
$ns at 200.0 "$node_(270) on" 
$node_(271) set X_ 2702 
$node_(271) set Y_ 480 
$node_(271) set Z_ 0.0 
$ns at 0.0 "$node_(271) off" 
$ns at 200.0 "$node_(271) on" 
$node_(272) set X_ 1597 
$node_(272) set Y_ 73 
$node_(272) set Z_ 0.0 
$ns at 0.0 "$node_(272) off" 
$ns at 200.0 "$node_(272) on" 
$node_(273) set X_ 326 
$node_(273) set Y_ 153 
$node_(273) set Z_ 0.0 
$ns at 0.0 "$node_(273) off" 
$ns at 200.0 "$node_(273) on" 
$node_(274) set X_ 168 
$node_(274) set Y_ 242 
$node_(274) set Z_ 0.0 
$ns at 0.0 "$node_(274) off" 
$ns at 200.0 "$node_(274) on" 
$node_(275) set X_ 1815 
$node_(275) set Y_ 909 
$node_(275) set Z_ 0.0 
$ns at 0.0 "$node_(275) off" 
$ns at 200.0 "$node_(275) on" 
$node_(276) set X_ 1285 
$node_(276) set Y_ 949 
$node_(276) set Z_ 0.0 
$ns at 0.0 "$node_(276) off" 
$ns at 200.0 "$node_(276) on" 
$node_(277) set X_ 1716 
$node_(277) set Y_ 195 
$node_(277) set Z_ 0.0 
$ns at 0.0 "$node_(277) off" 
$ns at 200.0 "$node_(277) on" 
$node_(278) set X_ 714 
$node_(278) set Y_ 350 
$node_(278) set Z_ 0.0 
$ns at 0.0 "$node_(278) off" 
$ns at 200.0 "$node_(278) on" 
$node_(279) set X_ 1719 
$node_(279) set Y_ 319 
$node_(279) set Z_ 0.0 
$ns at 0.0 "$node_(279) off" 
$ns at 200.0 "$node_(279) on" 
$node_(280) set X_ 2575 
$node_(280) set Y_ 85 
$node_(280) set Z_ 0.0 
$ns at 0.0 "$node_(280) off" 
$ns at 200.0 "$node_(280) on" 
$node_(281) set X_ 1835 
$node_(281) set Y_ 608 
$node_(281) set Z_ 0.0 
$ns at 0.0 "$node_(281) off" 
$ns at 200.0 "$node_(281) on" 
$node_(282) set X_ 2692 
$node_(282) set Y_ 489 
$node_(282) set Z_ 0.0 
$ns at 0.0 "$node_(282) off" 
$ns at 200.0 "$node_(282) on" 
$node_(283) set X_ 45 
$node_(283) set Y_ 927 
$node_(283) set Z_ 0.0 
$ns at 0.0 "$node_(283) off" 
$ns at 200.0 "$node_(283) on" 
$node_(284) set X_ 354 
$node_(284) set Y_ 755 
$node_(284) set Z_ 0.0 
$ns at 0.0 "$node_(284) off" 
$ns at 200.0 "$node_(284) on" 
$node_(285) set X_ 2428 
$node_(285) set Y_ 174 
$node_(285) set Z_ 0.0 
$ns at 0.0 "$node_(285) off" 
$ns at 200.0 "$node_(285) on" 
$node_(286) set X_ 1255 
$node_(286) set Y_ 979 
$node_(286) set Z_ 0.0 
$ns at 0.0 "$node_(286) off" 
$ns at 200.0 "$node_(286) on" 
$node_(287) set X_ 781 
$node_(287) set Y_ 217 
$node_(287) set Z_ 0.0 
$ns at 0.0 "$node_(287) off" 
$ns at 200.0 "$node_(287) on" 
$node_(288) set X_ 1263 
$node_(288) set Y_ 933 
$node_(288) set Z_ 0.0 
$ns at 0.0 "$node_(288) off" 
$ns at 200.0 "$node_(288) on" 
$node_(289) set X_ 1258 
$node_(289) set Y_ 965 
$node_(289) set Z_ 0.0 
$ns at 0.0 "$node_(289) off" 
$ns at 200.0 "$node_(289) on" 
$node_(290) set X_ 2539 
$node_(290) set Y_ 225 
$node_(290) set Z_ 0.0 
$ns at 0.0 "$node_(290) off" 
$ns at 200.0 "$node_(290) on" 
$node_(291) set X_ 2545 
$node_(291) set Y_ 923 
$node_(291) set Z_ 0.0 
$ns at 0.0 "$node_(291) off" 
$ns at 200.0 "$node_(291) on" 
$node_(292) set X_ 365 
$node_(292) set Y_ 213 
$node_(292) set Z_ 0.0 
$ns at 0.0 "$node_(292) off" 
$ns at 200.0 "$node_(292) on" 
$node_(293) set X_ 510 
$node_(293) set Y_ 628 
$node_(293) set Z_ 0.0 
$ns at 0.0 "$node_(293) off" 
$ns at 200.0 "$node_(293) on" 
$node_(294) set X_ 1846 
$node_(294) set Y_ 716 
$node_(294) set Z_ 0.0 
$ns at 0.0 "$node_(294) off" 
$ns at 200.0 "$node_(294) on" 
$node_(295) set X_ 2202 
$node_(295) set Y_ 815 
$node_(295) set Z_ 0.0 
$ns at 0.0 "$node_(295) off" 
$ns at 200.0 "$node_(295) on" 
$node_(296) set X_ 1411 
$node_(296) set Y_ 31 
$node_(296) set Z_ 0.0 
$ns at 0.0 "$node_(296) off" 
$ns at 200.0 "$node_(296) on" 
$node_(297) set X_ 1428 
$node_(297) set Y_ 40 
$node_(297) set Z_ 0.0 
$ns at 0.0 "$node_(297) off" 
$ns at 200.0 "$node_(297) on" 
$node_(298) set X_ 788 
$node_(298) set Y_ 287 
$node_(298) set Z_ 0.0 
$ns at 0.0 "$node_(298) off" 
$ns at 200.0 "$node_(298) on" 
$node_(299) set X_ 25 
$node_(299) set Y_ 737 
$node_(299) set Z_ 0.0 
$ns at 0.0 "$node_(299) off" 
$ns at 200.0 "$node_(299) on" 
$node_(300) set X_ 1845 
$node_(300) set Y_ 436 
$node_(300) set Z_ 0.0 
$ns at 0.0 "$node_(300) off" 
$ns at 300.0 "$node_(300) on" 
$node_(301) set X_ 224 
$node_(301) set Y_ 390 
$node_(301) set Z_ 0.0 
$ns at 0.0 "$node_(301) off" 
$ns at 300.0 "$node_(301) on" 
$node_(302) set X_ 1357 
$node_(302) set Y_ 513 
$node_(302) set Z_ 0.0 
$ns at 0.0 "$node_(302) off" 
$ns at 300.0 "$node_(302) on" 
$node_(303) set X_ 2315 
$node_(303) set Y_ 557 
$node_(303) set Z_ 0.0 
$ns at 0.0 "$node_(303) off" 
$ns at 300.0 "$node_(303) on" 
$node_(304) set X_ 2400 
$node_(304) set Y_ 889 
$node_(304) set Z_ 0.0 
$ns at 0.0 "$node_(304) off" 
$ns at 300.0 "$node_(304) on" 
$node_(305) set X_ 1082 
$node_(305) set Y_ 986 
$node_(305) set Z_ 0.0 
$ns at 0.0 "$node_(305) off" 
$ns at 300.0 "$node_(305) on" 
$node_(306) set X_ 2711 
$node_(306) set Y_ 355 
$node_(306) set Z_ 0.0 
$ns at 0.0 "$node_(306) off" 
$ns at 300.0 "$node_(306) on" 
$node_(307) set X_ 176 
$node_(307) set Y_ 964 
$node_(307) set Z_ 0.0 
$ns at 0.0 "$node_(307) off" 
$ns at 300.0 "$node_(307) on" 
$node_(308) set X_ 2920 
$node_(308) set Y_ 837 
$node_(308) set Z_ 0.0 
$ns at 0.0 "$node_(308) off" 
$ns at 300.0 "$node_(308) on" 
$node_(309) set X_ 2819 
$node_(309) set Y_ 330 
$node_(309) set Z_ 0.0 
$ns at 0.0 "$node_(309) off" 
$ns at 300.0 "$node_(309) on" 
$node_(310) set X_ 122 
$node_(310) set Y_ 403 
$node_(310) set Z_ 0.0 
$ns at 0.0 "$node_(310) off" 
$ns at 300.0 "$node_(310) on" 
$node_(311) set X_ 2879 
$node_(311) set Y_ 287 
$node_(311) set Z_ 0.0 
$ns at 0.0 "$node_(311) off" 
$ns at 300.0 "$node_(311) on" 
$node_(312) set X_ 772 
$node_(312) set Y_ 43 
$node_(312) set Z_ 0.0 
$ns at 0.0 "$node_(312) off" 
$ns at 300.0 "$node_(312) on" 
$node_(313) set X_ 492 
$node_(313) set Y_ 285 
$node_(313) set Z_ 0.0 
$ns at 0.0 "$node_(313) off" 
$ns at 300.0 "$node_(313) on" 
$node_(314) set X_ 1384 
$node_(314) set Y_ 355 
$node_(314) set Z_ 0.0 
$ns at 0.0 "$node_(314) off" 
$ns at 300.0 "$node_(314) on" 
$node_(315) set X_ 994 
$node_(315) set Y_ 750 
$node_(315) set Z_ 0.0 
$ns at 0.0 "$node_(315) off" 
$ns at 300.0 "$node_(315) on" 
$node_(316) set X_ 2977 
$node_(316) set Y_ 916 
$node_(316) set Z_ 0.0 
$ns at 0.0 "$node_(316) off" 
$ns at 300.0 "$node_(316) on" 
$node_(317) set X_ 2032 
$node_(317) set Y_ 352 
$node_(317) set Z_ 0.0 
$ns at 0.0 "$node_(317) off" 
$ns at 300.0 "$node_(317) on" 
$node_(318) set X_ 1629 
$node_(318) set Y_ 569 
$node_(318) set Z_ 0.0 
$ns at 0.0 "$node_(318) off" 
$ns at 300.0 "$node_(318) on" 
$node_(319) set X_ 2214 
$node_(319) set Y_ 864 
$node_(319) set Z_ 0.0 
$ns at 0.0 "$node_(319) off" 
$ns at 300.0 "$node_(319) on" 
$node_(320) set X_ 912 
$node_(320) set Y_ 323 
$node_(320) set Z_ 0.0 
$ns at 0.0 "$node_(320) off" 
$ns at 300.0 "$node_(320) on" 
$node_(321) set X_ 699 
$node_(321) set Y_ 387 
$node_(321) set Z_ 0.0 
$ns at 0.0 "$node_(321) off" 
$ns at 300.0 "$node_(321) on" 
$node_(322) set X_ 2332 
$node_(322) set Y_ 822 
$node_(322) set Z_ 0.0 
$ns at 0.0 "$node_(322) off" 
$ns at 300.0 "$node_(322) on" 
$node_(323) set X_ 1585 
$node_(323) set Y_ 852 
$node_(323) set Z_ 0.0 
$ns at 0.0 "$node_(323) off" 
$ns at 300.0 "$node_(323) on" 
$node_(324) set X_ 1238 
$node_(324) set Y_ 629 
$node_(324) set Z_ 0.0 
$ns at 0.0 "$node_(324) off" 
$ns at 300.0 "$node_(324) on" 
$node_(325) set X_ 921 
$node_(325) set Y_ 293 
$node_(325) set Z_ 0.0 
$ns at 0.0 "$node_(325) off" 
$ns at 300.0 "$node_(325) on" 
$node_(326) set X_ 1986 
$node_(326) set Y_ 626 
$node_(326) set Z_ 0.0 
$ns at 0.0 "$node_(326) off" 
$ns at 300.0 "$node_(326) on" 
$node_(327) set X_ 537 
$node_(327) set Y_ 304 
$node_(327) set Z_ 0.0 
$ns at 0.0 "$node_(327) off" 
$ns at 300.0 "$node_(327) on" 
$node_(328) set X_ 381 
$node_(328) set Y_ 946 
$node_(328) set Z_ 0.0 
$ns at 0.0 "$node_(328) off" 
$ns at 300.0 "$node_(328) on" 
$node_(329) set X_ 829 
$node_(329) set Y_ 490 
$node_(329) set Z_ 0.0 
$ns at 0.0 "$node_(329) off" 
$ns at 300.0 "$node_(329) on" 
$node_(330) set X_ 693 
$node_(330) set Y_ 720 
$node_(330) set Z_ 0.0 
$ns at 0.0 "$node_(330) off" 
$ns at 300.0 "$node_(330) on" 
$node_(331) set X_ 928 
$node_(331) set Y_ 477 
$node_(331) set Z_ 0.0 
$ns at 0.0 "$node_(331) off" 
$ns at 300.0 "$node_(331) on" 
$node_(332) set X_ 733 
$node_(332) set Y_ 835 
$node_(332) set Z_ 0.0 
$ns at 0.0 "$node_(332) off" 
$ns at 300.0 "$node_(332) on" 
$node_(333) set X_ 540 
$node_(333) set Y_ 217 
$node_(333) set Z_ 0.0 
$ns at 0.0 "$node_(333) off" 
$ns at 300.0 "$node_(333) on" 
$node_(334) set X_ 1671 
$node_(334) set Y_ 603 
$node_(334) set Z_ 0.0 
$ns at 0.0 "$node_(334) off" 
$ns at 300.0 "$node_(334) on" 
$node_(335) set X_ 23 
$node_(335) set Y_ 927 
$node_(335) set Z_ 0.0 
$ns at 0.0 "$node_(335) off" 
$ns at 300.0 "$node_(335) on" 
$node_(336) set X_ 2404 
$node_(336) set Y_ 945 
$node_(336) set Z_ 0.0 
$ns at 0.0 "$node_(336) off" 
$ns at 300.0 "$node_(336) on" 
$node_(337) set X_ 1003 
$node_(337) set Y_ 967 
$node_(337) set Z_ 0.0 
$ns at 0.0 "$node_(337) off" 
$ns at 300.0 "$node_(337) on" 
$node_(338) set X_ 2421 
$node_(338) set Y_ 217 
$node_(338) set Z_ 0.0 
$ns at 0.0 "$node_(338) off" 
$ns at 300.0 "$node_(338) on" 
$node_(339) set X_ 1095 
$node_(339) set Y_ 380 
$node_(339) set Z_ 0.0 
$ns at 0.0 "$node_(339) off" 
$ns at 300.0 "$node_(339) on" 
$node_(340) set X_ 1176 
$node_(340) set Y_ 329 
$node_(340) set Z_ 0.0 
$ns at 0.0 "$node_(340) off" 
$ns at 300.0 "$node_(340) on" 
$node_(341) set X_ 958 
$node_(341) set Y_ 599 
$node_(341) set Z_ 0.0 
$ns at 0.0 "$node_(341) off" 
$ns at 300.0 "$node_(341) on" 
$node_(342) set X_ 2052 
$node_(342) set Y_ 141 
$node_(342) set Z_ 0.0 
$ns at 0.0 "$node_(342) off" 
$ns at 300.0 "$node_(342) on" 
$node_(343) set X_ 1077 
$node_(343) set Y_ 41 
$node_(343) set Z_ 0.0 
$ns at 0.0 "$node_(343) off" 
$ns at 300.0 "$node_(343) on" 
$node_(344) set X_ 10 
$node_(344) set Y_ 429 
$node_(344) set Z_ 0.0 
$ns at 0.0 "$node_(344) off" 
$ns at 300.0 "$node_(344) on" 
$node_(345) set X_ 331 
$node_(345) set Y_ 939 
$node_(345) set Z_ 0.0 
$ns at 0.0 "$node_(345) off" 
$ns at 300.0 "$node_(345) on" 
$node_(346) set X_ 1006 
$node_(346) set Y_ 921 
$node_(346) set Z_ 0.0 
$ns at 0.0 "$node_(346) off" 
$ns at 300.0 "$node_(346) on" 
$node_(347) set X_ 1453 
$node_(347) set Y_ 744 
$node_(347) set Z_ 0.0 
$ns at 0.0 "$node_(347) off" 
$ns at 300.0 "$node_(347) on" 
$node_(348) set X_ 240 
$node_(348) set Y_ 957 
$node_(348) set Z_ 0.0 
$ns at 0.0 "$node_(348) off" 
$ns at 300.0 "$node_(348) on" 
$node_(349) set X_ 1108 
$node_(349) set Y_ 907 
$node_(349) set Z_ 0.0 
$ns at 0.0 "$node_(349) off" 
$ns at 300.0 "$node_(349) on" 
$node_(350) set X_ 187 
$node_(350) set Y_ 386 
$node_(350) set Z_ 0.0 
$ns at 0.0 "$node_(350) off" 
$ns at 300.0 "$node_(350) on" 
$node_(351) set X_ 2321 
$node_(351) set Y_ 636 
$node_(351) set Z_ 0.0 
$ns at 0.0 "$node_(351) off" 
$ns at 300.0 "$node_(351) on" 
$node_(352) set X_ 2320 
$node_(352) set Y_ 177 
$node_(352) set Z_ 0.0 
$ns at 0.0 "$node_(352) off" 
$ns at 300.0 "$node_(352) on" 
$node_(353) set X_ 505 
$node_(353) set Y_ 489 
$node_(353) set Z_ 0.0 
$ns at 0.0 "$node_(353) off" 
$ns at 300.0 "$node_(353) on" 
$node_(354) set X_ 1228 
$node_(354) set Y_ 71 
$node_(354) set Z_ 0.0 
$ns at 0.0 "$node_(354) off" 
$ns at 300.0 "$node_(354) on" 
$node_(355) set X_ 313 
$node_(355) set Y_ 315 
$node_(355) set Z_ 0.0 
$ns at 0.0 "$node_(355) off" 
$ns at 300.0 "$node_(355) on" 
$node_(356) set X_ 1740 
$node_(356) set Y_ 309 
$node_(356) set Z_ 0.0 
$ns at 0.0 "$node_(356) off" 
$ns at 300.0 "$node_(356) on" 
$node_(357) set X_ 1991 
$node_(357) set Y_ 79 
$node_(357) set Z_ 0.0 
$ns at 0.0 "$node_(357) off" 
$ns at 300.0 "$node_(357) on" 
$node_(358) set X_ 1404 
$node_(358) set Y_ 104 
$node_(358) set Z_ 0.0 
$ns at 0.0 "$node_(358) off" 
$ns at 300.0 "$node_(358) on" 
$node_(359) set X_ 2797 
$node_(359) set Y_ 593 
$node_(359) set Z_ 0.0 
$ns at 0.0 "$node_(359) off" 
$ns at 300.0 "$node_(359) on" 
$node_(360) set X_ 2495 
$node_(360) set Y_ 59 
$node_(360) set Z_ 0.0 
$ns at 0.0 "$node_(360) off" 
$ns at 300.0 "$node_(360) on" 
$node_(361) set X_ 1473 
$node_(361) set Y_ 23 
$node_(361) set Z_ 0.0 
$ns at 0.0 "$node_(361) off" 
$ns at 300.0 "$node_(361) on" 
$node_(362) set X_ 1432 
$node_(362) set Y_ 183 
$node_(362) set Z_ 0.0 
$ns at 0.0 "$node_(362) off" 
$ns at 300.0 "$node_(362) on" 
$node_(363) set X_ 2558 
$node_(363) set Y_ 318 
$node_(363) set Z_ 0.0 
$ns at 0.0 "$node_(363) off" 
$ns at 300.0 "$node_(363) on" 
$node_(364) set X_ 2215 
$node_(364) set Y_ 498 
$node_(364) set Z_ 0.0 
$ns at 0.0 "$node_(364) off" 
$ns at 300.0 "$node_(364) on" 
$node_(365) set X_ 2702 
$node_(365) set Y_ 388 
$node_(365) set Z_ 0.0 
$ns at 0.0 "$node_(365) off" 
$ns at 300.0 "$node_(365) on" 
$node_(366) set X_ 153 
$node_(366) set Y_ 487 
$node_(366) set Z_ 0.0 
$ns at 0.0 "$node_(366) off" 
$ns at 300.0 "$node_(366) on" 
$node_(367) set X_ 1881 
$node_(367) set Y_ 925 
$node_(367) set Z_ 0.0 
$ns at 0.0 "$node_(367) off" 
$ns at 300.0 "$node_(367) on" 
$node_(368) set X_ 2831 
$node_(368) set Y_ 794 
$node_(368) set Z_ 0.0 
$ns at 0.0 "$node_(368) off" 
$ns at 300.0 "$node_(368) on" 
$node_(369) set X_ 2707 
$node_(369) set Y_ 274 
$node_(369) set Z_ 0.0 
$ns at 0.0 "$node_(369) off" 
$ns at 300.0 "$node_(369) on" 
$node_(370) set X_ 1840 
$node_(370) set Y_ 656 
$node_(370) set Z_ 0.0 
$ns at 0.0 "$node_(370) off" 
$ns at 300.0 "$node_(370) on" 
$node_(371) set X_ 1726 
$node_(371) set Y_ 640 
$node_(371) set Z_ 0.0 
$ns at 0.0 "$node_(371) off" 
$ns at 300.0 "$node_(371) on" 
$node_(372) set X_ 2410 
$node_(372) set Y_ 520 
$node_(372) set Z_ 0.0 
$ns at 0.0 "$node_(372) off" 
$ns at 300.0 "$node_(372) on" 
$node_(373) set X_ 2814 
$node_(373) set Y_ 213 
$node_(373) set Z_ 0.0 
$ns at 0.0 "$node_(373) off" 
$ns at 300.0 "$node_(373) on" 
$node_(374) set X_ 2639 
$node_(374) set Y_ 180 
$node_(374) set Z_ 0.0 
$ns at 0.0 "$node_(374) off" 
$ns at 300.0 "$node_(374) on" 
$node_(375) set X_ 1420 
$node_(375) set Y_ 527 
$node_(375) set Z_ 0.0 
$ns at 0.0 "$node_(375) off" 
$ns at 300.0 "$node_(375) on" 
$node_(376) set X_ 2505 
$node_(376) set Y_ 539 
$node_(376) set Z_ 0.0 
$ns at 0.0 "$node_(376) off" 
$ns at 300.0 "$node_(376) on" 
$node_(377) set X_ 2563 
$node_(377) set Y_ 454 
$node_(377) set Z_ 0.0 
$ns at 0.0 "$node_(377) off" 
$ns at 300.0 "$node_(377) on" 
$node_(378) set X_ 1377 
$node_(378) set Y_ 834 
$node_(378) set Z_ 0.0 
$ns at 0.0 "$node_(378) off" 
$ns at 300.0 "$node_(378) on" 
$node_(379) set X_ 1064 
$node_(379) set Y_ 778 
$node_(379) set Z_ 0.0 
$ns at 0.0 "$node_(379) off" 
$ns at 300.0 "$node_(379) on" 
$node_(380) set X_ 169 
$node_(380) set Y_ 696 
$node_(380) set Z_ 0.0 
$ns at 0.0 "$node_(380) off" 
$ns at 300.0 "$node_(380) on" 
$node_(381) set X_ 584 
$node_(381) set Y_ 194 
$node_(381) set Z_ 0.0 
$ns at 0.0 "$node_(381) off" 
$ns at 300.0 "$node_(381) on" 
$node_(382) set X_ 2735 
$node_(382) set Y_ 3 
$node_(382) set Z_ 0.0 
$ns at 0.0 "$node_(382) off" 
$ns at 300.0 "$node_(382) on" 
$node_(383) set X_ 2573 
$node_(383) set Y_ 951 
$node_(383) set Z_ 0.0 
$ns at 0.0 "$node_(383) off" 
$ns at 300.0 "$node_(383) on" 
$node_(384) set X_ 479 
$node_(384) set Y_ 809 
$node_(384) set Z_ 0.0 
$ns at 0.0 "$node_(384) off" 
$ns at 300.0 "$node_(384) on" 
$node_(385) set X_ 226 
$node_(385) set Y_ 43 
$node_(385) set Z_ 0.0 
$ns at 0.0 "$node_(385) off" 
$ns at 300.0 "$node_(385) on" 
$node_(386) set X_ 2539 
$node_(386) set Y_ 23 
$node_(386) set Z_ 0.0 
$ns at 0.0 "$node_(386) off" 
$ns at 300.0 "$node_(386) on" 
$node_(387) set X_ 44 
$node_(387) set Y_ 59 
$node_(387) set Z_ 0.0 
$ns at 0.0 "$node_(387) off" 
$ns at 300.0 "$node_(387) on" 
$node_(388) set X_ 2218 
$node_(388) set Y_ 695 
$node_(388) set Z_ 0.0 
$ns at 0.0 "$node_(388) off" 
$ns at 300.0 "$node_(388) on" 
$node_(389) set X_ 516 
$node_(389) set Y_ 287 
$node_(389) set Z_ 0.0 
$ns at 0.0 "$node_(389) off" 
$ns at 300.0 "$node_(389) on" 
$node_(390) set X_ 2663 
$node_(390) set Y_ 893 
$node_(390) set Z_ 0.0 
$ns at 0.0 "$node_(390) off" 
$ns at 300.0 "$node_(390) on" 
$node_(391) set X_ 1877 
$node_(391) set Y_ 698 
$node_(391) set Z_ 0.0 
$ns at 0.0 "$node_(391) off" 
$ns at 300.0 "$node_(391) on" 
$node_(392) set X_ 52 
$node_(392) set Y_ 226 
$node_(392) set Z_ 0.0 
$ns at 0.0 "$node_(392) off" 
$ns at 300.0 "$node_(392) on" 
$node_(393) set X_ 1746 
$node_(393) set Y_ 733 
$node_(393) set Z_ 0.0 
$ns at 0.0 "$node_(393) off" 
$ns at 300.0 "$node_(393) on" 
$node_(394) set X_ 1778 
$node_(394) set Y_ 973 
$node_(394) set Z_ 0.0 
$ns at 0.0 "$node_(394) off" 
$ns at 300.0 "$node_(394) on" 
$node_(395) set X_ 1842 
$node_(395) set Y_ 634 
$node_(395) set Z_ 0.0 
$ns at 0.0 "$node_(395) off" 
$ns at 300.0 "$node_(395) on" 
$node_(396) set X_ 2361 
$node_(396) set Y_ 640 
$node_(396) set Z_ 0.0 
$ns at 0.0 "$node_(396) off" 
$ns at 300.0 "$node_(396) on" 
$node_(397) set X_ 1748 
$node_(397) set Y_ 210 
$node_(397) set Z_ 0.0 
$ns at 0.0 "$node_(397) off" 
$ns at 300.0 "$node_(397) on" 
$node_(398) set X_ 1964 
$node_(398) set Y_ 540 
$node_(398) set Z_ 0.0 
$ns at 0.0 "$node_(398) off" 
$ns at 300.0 "$node_(398) on" 
$node_(399) set X_ 19 
$node_(399) set Y_ 531 
$node_(399) set Z_ 0.0 
$ns at 0.0 "$node_(399) off" 
$ns at 300.0 "$node_(399) on" 
$node_(400) set X_ 1563 
$node_(400) set Y_ 610 
$node_(400) set Z_ 0.0 
$ns at 0.0 "$node_(400) off" 
$ns at 400.0 "$node_(400) on" 
$node_(401) set X_ 1668 
$node_(401) set Y_ 5 
$node_(401) set Z_ 0.0 
$ns at 0.0 "$node_(401) off" 
$ns at 400.0 "$node_(401) on" 
$node_(402) set X_ 2915 
$node_(402) set Y_ 301 
$node_(402) set Z_ 0.0 
$ns at 0.0 "$node_(402) off" 
$ns at 400.0 "$node_(402) on" 
$node_(403) set X_ 1290 
$node_(403) set Y_ 735 
$node_(403) set Z_ 0.0 
$ns at 0.0 "$node_(403) off" 
$ns at 400.0 "$node_(403) on" 
$node_(404) set X_ 2573 
$node_(404) set Y_ 797 
$node_(404) set Z_ 0.0 
$ns at 0.0 "$node_(404) off" 
$ns at 400.0 "$node_(404) on" 
$node_(405) set X_ 1792 
$node_(405) set Y_ 791 
$node_(405) set Z_ 0.0 
$ns at 0.0 "$node_(405) off" 
$ns at 400.0 "$node_(405) on" 
$node_(406) set X_ 1237 
$node_(406) set Y_ 238 
$node_(406) set Z_ 0.0 
$ns at 0.0 "$node_(406) off" 
$ns at 400.0 "$node_(406) on" 
$node_(407) set X_ 833 
$node_(407) set Y_ 306 
$node_(407) set Z_ 0.0 
$ns at 0.0 "$node_(407) off" 
$ns at 400.0 "$node_(407) on" 
$node_(408) set X_ 2755 
$node_(408) set Y_ 889 
$node_(408) set Z_ 0.0 
$ns at 0.0 "$node_(408) off" 
$ns at 400.0 "$node_(408) on" 
$node_(409) set X_ 1745 
$node_(409) set Y_ 862 
$node_(409) set Z_ 0.0 
$ns at 0.0 "$node_(409) off" 
$ns at 400.0 "$node_(409) on" 
$node_(410) set X_ 1088 
$node_(410) set Y_ 391 
$node_(410) set Z_ 0.0 
$ns at 0.0 "$node_(410) off" 
$ns at 400.0 "$node_(410) on" 
$node_(411) set X_ 2781 
$node_(411) set Y_ 704 
$node_(411) set Z_ 0.0 
$ns at 0.0 "$node_(411) off" 
$ns at 400.0 "$node_(411) on" 
$node_(412) set X_ 497 
$node_(412) set Y_ 344 
$node_(412) set Z_ 0.0 
$ns at 0.0 "$node_(412) off" 
$ns at 400.0 "$node_(412) on" 
$node_(413) set X_ 2105 
$node_(413) set Y_ 699 
$node_(413) set Z_ 0.0 
$ns at 0.0 "$node_(413) off" 
$ns at 400.0 "$node_(413) on" 
$node_(414) set X_ 1156 
$node_(414) set Y_ 444 
$node_(414) set Z_ 0.0 
$ns at 0.0 "$node_(414) off" 
$ns at 400.0 "$node_(414) on" 
$node_(415) set X_ 2000 
$node_(415) set Y_ 825 
$node_(415) set Z_ 0.0 
$ns at 0.0 "$node_(415) off" 
$ns at 400.0 "$node_(415) on" 
$node_(416) set X_ 2279 
$node_(416) set Y_ 351 
$node_(416) set Z_ 0.0 
$ns at 0.0 "$node_(416) off" 
$ns at 400.0 "$node_(416) on" 
$node_(417) set X_ 2250 
$node_(417) set Y_ 198 
$node_(417) set Z_ 0.0 
$ns at 0.0 "$node_(417) off" 
$ns at 400.0 "$node_(417) on" 
$node_(418) set X_ 1718 
$node_(418) set Y_ 235 
$node_(418) set Z_ 0.0 
$ns at 0.0 "$node_(418) off" 
$ns at 400.0 "$node_(418) on" 
$node_(419) set X_ 648 
$node_(419) set Y_ 294 
$node_(419) set Z_ 0.0 
$ns at 0.0 "$node_(419) off" 
$ns at 400.0 "$node_(419) on" 
$node_(420) set X_ 1843 
$node_(420) set Y_ 722 
$node_(420) set Z_ 0.0 
$ns at 0.0 "$node_(420) off" 
$ns at 400.0 "$node_(420) on" 
$node_(421) set X_ 2004 
$node_(421) set Y_ 80 
$node_(421) set Z_ 0.0 
$ns at 0.0 "$node_(421) off" 
$ns at 400.0 "$node_(421) on" 
$node_(422) set X_ 1273 
$node_(422) set Y_ 536 
$node_(422) set Z_ 0.0 
$ns at 0.0 "$node_(422) off" 
$ns at 400.0 "$node_(422) on" 
$node_(423) set X_ 2972 
$node_(423) set Y_ 206 
$node_(423) set Z_ 0.0 
$ns at 0.0 "$node_(423) off" 
$ns at 400.0 "$node_(423) on" 
$node_(424) set X_ 1859 
$node_(424) set Y_ 723 
$node_(424) set Z_ 0.0 
$ns at 0.0 "$node_(424) off" 
$ns at 400.0 "$node_(424) on" 
$node_(425) set X_ 367 
$node_(425) set Y_ 314 
$node_(425) set Z_ 0.0 
$ns at 0.0 "$node_(425) off" 
$ns at 400.0 "$node_(425) on" 
$node_(426) set X_ 1009 
$node_(426) set Y_ 739 
$node_(426) set Z_ 0.0 
$ns at 0.0 "$node_(426) off" 
$ns at 400.0 "$node_(426) on" 
$node_(427) set X_ 1505 
$node_(427) set Y_ 734 
$node_(427) set Z_ 0.0 
$ns at 0.0 "$node_(427) off" 
$ns at 400.0 "$node_(427) on" 
$node_(428) set X_ 2186 
$node_(428) set Y_ 71 
$node_(428) set Z_ 0.0 
$ns at 0.0 "$node_(428) off" 
$ns at 400.0 "$node_(428) on" 
$node_(429) set X_ 420 
$node_(429) set Y_ 579 
$node_(429) set Z_ 0.0 
$ns at 0.0 "$node_(429) off" 
$ns at 400.0 "$node_(429) on" 
$node_(430) set X_ 83 
$node_(430) set Y_ 287 
$node_(430) set Z_ 0.0 
$ns at 0.0 "$node_(430) off" 
$ns at 400.0 "$node_(430) on" 
$node_(431) set X_ 1609 
$node_(431) set Y_ 274 
$node_(431) set Z_ 0.0 
$ns at 0.0 "$node_(431) off" 
$ns at 400.0 "$node_(431) on" 
$node_(432) set X_ 2610 
$node_(432) set Y_ 586 
$node_(432) set Z_ 0.0 
$ns at 0.0 "$node_(432) off" 
$ns at 400.0 "$node_(432) on" 
$node_(433) set X_ 180 
$node_(433) set Y_ 81 
$node_(433) set Z_ 0.0 
$ns at 0.0 "$node_(433) off" 
$ns at 400.0 "$node_(433) on" 
$node_(434) set X_ 1472 
$node_(434) set Y_ 985 
$node_(434) set Z_ 0.0 
$ns at 0.0 "$node_(434) off" 
$ns at 400.0 "$node_(434) on" 
$node_(435) set X_ 50 
$node_(435) set Y_ 69 
$node_(435) set Z_ 0.0 
$ns at 0.0 "$node_(435) off" 
$ns at 400.0 "$node_(435) on" 
$node_(436) set X_ 2677 
$node_(436) set Y_ 246 
$node_(436) set Z_ 0.0 
$ns at 0.0 "$node_(436) off" 
$ns at 400.0 "$node_(436) on" 
$node_(437) set X_ 992 
$node_(437) set Y_ 267 
$node_(437) set Z_ 0.0 
$ns at 0.0 "$node_(437) off" 
$ns at 400.0 "$node_(437) on" 
$node_(438) set X_ 882 
$node_(438) set Y_ 540 
$node_(438) set Z_ 0.0 
$ns at 0.0 "$node_(438) off" 
$ns at 400.0 "$node_(438) on" 
$node_(439) set X_ 2025 
$node_(439) set Y_ 469 
$node_(439) set Z_ 0.0 
$ns at 0.0 "$node_(439) off" 
$ns at 400.0 "$node_(439) on" 
$node_(440) set X_ 2998 
$node_(440) set Y_ 616 
$node_(440) set Z_ 0.0 
$ns at 0.0 "$node_(440) off" 
$ns at 400.0 "$node_(440) on" 
$node_(441) set X_ 2748 
$node_(441) set Y_ 245 
$node_(441) set Z_ 0.0 
$ns at 0.0 "$node_(441) off" 
$ns at 400.0 "$node_(441) on" 
$node_(442) set X_ 975 
$node_(442) set Y_ 947 
$node_(442) set Z_ 0.0 
$ns at 0.0 "$node_(442) off" 
$ns at 400.0 "$node_(442) on" 
$node_(443) set X_ 2840 
$node_(443) set Y_ 267 
$node_(443) set Z_ 0.0 
$ns at 0.0 "$node_(443) off" 
$ns at 400.0 "$node_(443) on" 
$node_(444) set X_ 1139 
$node_(444) set Y_ 912 
$node_(444) set Z_ 0.0 
$ns at 0.0 "$node_(444) off" 
$ns at 400.0 "$node_(444) on" 
$node_(445) set X_ 1000 
$node_(445) set Y_ 952 
$node_(445) set Z_ 0.0 
$ns at 0.0 "$node_(445) off" 
$ns at 400.0 "$node_(445) on" 
$node_(446) set X_ 891 
$node_(446) set Y_ 592 
$node_(446) set Z_ 0.0 
$ns at 0.0 "$node_(446) off" 
$ns at 400.0 "$node_(446) on" 
$node_(447) set X_ 2159 
$node_(447) set Y_ 779 
$node_(447) set Z_ 0.0 
$ns at 0.0 "$node_(447) off" 
$ns at 400.0 "$node_(447) on" 
$node_(448) set X_ 2968 
$node_(448) set Y_ 162 
$node_(448) set Z_ 0.0 
$ns at 0.0 "$node_(448) off" 
$ns at 400.0 "$node_(448) on" 
$node_(449) set X_ 1773 
$node_(449) set Y_ 376 
$node_(449) set Z_ 0.0 
$ns at 0.0 "$node_(449) off" 
$ns at 400.0 "$node_(449) on" 
$node_(450) set X_ 1828 
$node_(450) set Y_ 169 
$node_(450) set Z_ 0.0 
$ns at 0.0 "$node_(450) off" 
$ns at 400.0 "$node_(450) on" 
$node_(451) set X_ 2521 
$node_(451) set Y_ 596 
$node_(451) set Z_ 0.0 
$ns at 0.0 "$node_(451) off" 
$ns at 400.0 "$node_(451) on" 
$node_(452) set X_ 2085 
$node_(452) set Y_ 228 
$node_(452) set Z_ 0.0 
$ns at 0.0 "$node_(452) off" 
$ns at 400.0 "$node_(452) on" 
$node_(453) set X_ 1638 
$node_(453) set Y_ 387 
$node_(453) set Z_ 0.0 
$ns at 0.0 "$node_(453) off" 
$ns at 400.0 "$node_(453) on" 
$node_(454) set X_ 1166 
$node_(454) set Y_ 789 
$node_(454) set Z_ 0.0 
$ns at 0.0 "$node_(454) off" 
$ns at 400.0 "$node_(454) on" 
$node_(455) set X_ 1550 
$node_(455) set Y_ 187 
$node_(455) set Z_ 0.0 
$ns at 0.0 "$node_(455) off" 
$ns at 400.0 "$node_(455) on" 
$node_(456) set X_ 708 
$node_(456) set Y_ 656 
$node_(456) set Z_ 0.0 
$ns at 0.0 "$node_(456) off" 
$ns at 400.0 "$node_(456) on" 
$node_(457) set X_ 1353 
$node_(457) set Y_ 964 
$node_(457) set Z_ 0.0 
$ns at 0.0 "$node_(457) off" 
$ns at 400.0 "$node_(457) on" 
$node_(458) set X_ 2385 
$node_(458) set Y_ 893 
$node_(458) set Z_ 0.0 
$ns at 0.0 "$node_(458) off" 
$ns at 400.0 "$node_(458) on" 
$node_(459) set X_ 34 
$node_(459) set Y_ 771 
$node_(459) set Z_ 0.0 
$ns at 0.0 "$node_(459) off" 
$ns at 400.0 "$node_(459) on" 
$node_(460) set X_ 2121 
$node_(460) set Y_ 606 
$node_(460) set Z_ 0.0 
$ns at 0.0 "$node_(460) off" 
$ns at 400.0 "$node_(460) on" 
$node_(461) set X_ 2129 
$node_(461) set Y_ 882 
$node_(461) set Z_ 0.0 
$ns at 0.0 "$node_(461) off" 
$ns at 400.0 "$node_(461) on" 
$node_(462) set X_ 2776 
$node_(462) set Y_ 819 
$node_(462) set Z_ 0.0 
$ns at 0.0 "$node_(462) off" 
$ns at 400.0 "$node_(462) on" 
$node_(463) set X_ 836 
$node_(463) set Y_ 141 
$node_(463) set Z_ 0.0 
$ns at 0.0 "$node_(463) off" 
$ns at 400.0 "$node_(463) on" 
$node_(464) set X_ 1579 
$node_(464) set Y_ 350 
$node_(464) set Z_ 0.0 
$ns at 0.0 "$node_(464) off" 
$ns at 400.0 "$node_(464) on" 
$node_(465) set X_ 331 
$node_(465) set Y_ 156 
$node_(465) set Z_ 0.0 
$ns at 0.0 "$node_(465) off" 
$ns at 400.0 "$node_(465) on" 
$node_(466) set X_ 2680 
$node_(466) set Y_ 154 
$node_(466) set Z_ 0.0 
$ns at 0.0 "$node_(466) off" 
$ns at 400.0 "$node_(466) on" 
$node_(467) set X_ 1275 
$node_(467) set Y_ 366 
$node_(467) set Z_ 0.0 
$ns at 0.0 "$node_(467) off" 
$ns at 400.0 "$node_(467) on" 
$node_(468) set X_ 265 
$node_(468) set Y_ 59 
$node_(468) set Z_ 0.0 
$ns at 0.0 "$node_(468) off" 
$ns at 400.0 "$node_(468) on" 
$node_(469) set X_ 176 
$node_(469) set Y_ 793 
$node_(469) set Z_ 0.0 
$ns at 0.0 "$node_(469) off" 
$ns at 400.0 "$node_(469) on" 
$node_(470) set X_ 2767 
$node_(470) set Y_ 220 
$node_(470) set Z_ 0.0 
$ns at 0.0 "$node_(470) off" 
$ns at 400.0 "$node_(470) on" 
$node_(471) set X_ 461 
$node_(471) set Y_ 539 
$node_(471) set Z_ 0.0 
$ns at 0.0 "$node_(471) off" 
$ns at 400.0 "$node_(471) on" 
$node_(472) set X_ 1691 
$node_(472) set Y_ 894 
$node_(472) set Z_ 0.0 
$ns at 0.0 "$node_(472) off" 
$ns at 400.0 "$node_(472) on" 
$node_(473) set X_ 1727 
$node_(473) set Y_ 644 
$node_(473) set Z_ 0.0 
$ns at 0.0 "$node_(473) off" 
$ns at 400.0 "$node_(473) on" 
$node_(474) set X_ 1587 
$node_(474) set Y_ 321 
$node_(474) set Z_ 0.0 
$ns at 0.0 "$node_(474) off" 
$ns at 400.0 "$node_(474) on" 
$node_(475) set X_ 1726 
$node_(475) set Y_ 5 
$node_(475) set Z_ 0.0 
$ns at 0.0 "$node_(475) off" 
$ns at 400.0 "$node_(475) on" 
$node_(476) set X_ 1656 
$node_(476) set Y_ 621 
$node_(476) set Z_ 0.0 
$ns at 0.0 "$node_(476) off" 
$ns at 400.0 "$node_(476) on" 
$node_(477) set X_ 255 
$node_(477) set Y_ 425 
$node_(477) set Z_ 0.0 
$ns at 0.0 "$node_(477) off" 
$ns at 400.0 "$node_(477) on" 
$node_(478) set X_ 399 
$node_(478) set Y_ 594 
$node_(478) set Z_ 0.0 
$ns at 0.0 "$node_(478) off" 
$ns at 400.0 "$node_(478) on" 
$node_(479) set X_ 104 
$node_(479) set Y_ 741 
$node_(479) set Z_ 0.0 
$ns at 0.0 "$node_(479) off" 
$ns at 400.0 "$node_(479) on" 
$node_(480) set X_ 1628 
$node_(480) set Y_ 237 
$node_(480) set Z_ 0.0 
$ns at 0.0 "$node_(480) off" 
$ns at 400.0 "$node_(480) on" 
$node_(481) set X_ 765 
$node_(481) set Y_ 189 
$node_(481) set Z_ 0.0 
$ns at 0.0 "$node_(481) off" 
$ns at 400.0 "$node_(481) on" 
$node_(482) set X_ 2014 
$node_(482) set Y_ 603 
$node_(482) set Z_ 0.0 
$ns at 0.0 "$node_(482) off" 
$ns at 400.0 "$node_(482) on" 
$node_(483) set X_ 2551 
$node_(483) set Y_ 815 
$node_(483) set Z_ 0.0 
$ns at 0.0 "$node_(483) off" 
$ns at 400.0 "$node_(483) on" 
$node_(484) set X_ 1178 
$node_(484) set Y_ 361 
$node_(484) set Z_ 0.0 
$ns at 0.0 "$node_(484) off" 
$ns at 400.0 "$node_(484) on" 
$node_(485) set X_ 1251 
$node_(485) set Y_ 812 
$node_(485) set Z_ 0.0 
$ns at 0.0 "$node_(485) off" 
$ns at 400.0 "$node_(485) on" 
$node_(486) set X_ 161 
$node_(486) set Y_ 21 
$node_(486) set Z_ 0.0 
$ns at 0.0 "$node_(486) off" 
$ns at 400.0 "$node_(486) on" 
$node_(487) set X_ 314 
$node_(487) set Y_ 95 
$node_(487) set Z_ 0.0 
$ns at 0.0 "$node_(487) off" 
$ns at 400.0 "$node_(487) on" 
$node_(488) set X_ 834 
$node_(488) set Y_ 362 
$node_(488) set Z_ 0.0 
$ns at 0.0 "$node_(488) off" 
$ns at 400.0 "$node_(488) on" 
$node_(489) set X_ 989 
$node_(489) set Y_ 293 
$node_(489) set Z_ 0.0 
$ns at 0.0 "$node_(489) off" 
$ns at 400.0 "$node_(489) on" 
$node_(490) set X_ 1611 
$node_(490) set Y_ 11 
$node_(490) set Z_ 0.0 
$ns at 0.0 "$node_(490) off" 
$ns at 400.0 "$node_(490) on" 
$node_(491) set X_ 2657 
$node_(491) set Y_ 647 
$node_(491) set Z_ 0.0 
$ns at 0.0 "$node_(491) off" 
$ns at 400.0 "$node_(491) on" 
$node_(492) set X_ 2476 
$node_(492) set Y_ 472 
$node_(492) set Z_ 0.0 
$ns at 0.0 "$node_(492) off" 
$ns at 400.0 "$node_(492) on" 
$node_(493) set X_ 926 
$node_(493) set Y_ 906 
$node_(493) set Z_ 0.0 
$ns at 0.0 "$node_(493) off" 
$ns at 400.0 "$node_(493) on" 
$node_(494) set X_ 1062 
$node_(494) set Y_ 191 
$node_(494) set Z_ 0.0 
$ns at 0.0 "$node_(494) off" 
$ns at 400.0 "$node_(494) on" 
$node_(495) set X_ 1865 
$node_(495) set Y_ 480 
$node_(495) set Z_ 0.0 
$ns at 0.0 "$node_(495) off" 
$ns at 400.0 "$node_(495) on" 
$node_(496) set X_ 1144 
$node_(496) set Y_ 362 
$node_(496) set Z_ 0.0 
$ns at 0.0 "$node_(496) off" 
$ns at 400.0 "$node_(496) on" 
$node_(497) set X_ 2968 
$node_(497) set Y_ 523 
$node_(497) set Z_ 0.0 
$ns at 0.0 "$node_(497) off" 
$ns at 400.0 "$node_(497) on" 
$node_(498) set X_ 523 
$node_(498) set Y_ 270 
$node_(498) set Z_ 0.0 
$ns at 0.0 "$node_(498) off" 
$ns at 400.0 "$node_(498) on" 
$node_(499) set X_ 1213 
$node_(499) set Y_ 576 
$node_(499) set Z_ 0.0 
$ns at 0.0 "$node_(499) off" 
$ns at 400.0 "$node_(499) on" 
$node_(500) set X_ 1879 
$node_(500) set Y_ 940 
$node_(500) set Z_ 0.0 
$ns at 0.0 "$node_(500) off" 
$ns at 500.0 "$node_(500) on" 
$node_(501) set X_ 736 
$node_(501) set Y_ 649 
$node_(501) set Z_ 0.0 
$ns at 0.0 "$node_(501) off" 
$ns at 500.0 "$node_(501) on" 
$node_(502) set X_ 705 
$node_(502) set Y_ 735 
$node_(502) set Z_ 0.0 
$ns at 0.0 "$node_(502) off" 
$ns at 500.0 "$node_(502) on" 
$node_(503) set X_ 1329 
$node_(503) set Y_ 378 
$node_(503) set Z_ 0.0 
$ns at 0.0 "$node_(503) off" 
$ns at 500.0 "$node_(503) on" 
$node_(504) set X_ 2970 
$node_(504) set Y_ 331 
$node_(504) set Z_ 0.0 
$ns at 0.0 "$node_(504) off" 
$ns at 500.0 "$node_(504) on" 
$node_(505) set X_ 88 
$node_(505) set Y_ 966 
$node_(505) set Z_ 0.0 
$ns at 0.0 "$node_(505) off" 
$ns at 500.0 "$node_(505) on" 
$node_(506) set X_ 653 
$node_(506) set Y_ 198 
$node_(506) set Z_ 0.0 
$ns at 0.0 "$node_(506) off" 
$ns at 500.0 "$node_(506) on" 
$node_(507) set X_ 145 
$node_(507) set Y_ 160 
$node_(507) set Z_ 0.0 
$ns at 0.0 "$node_(507) off" 
$ns at 500.0 "$node_(507) on" 
$node_(508) set X_ 1726 
$node_(508) set Y_ 303 
$node_(508) set Z_ 0.0 
$ns at 0.0 "$node_(508) off" 
$ns at 500.0 "$node_(508) on" 
$node_(509) set X_ 478 
$node_(509) set Y_ 447 
$node_(509) set Z_ 0.0 
$ns at 0.0 "$node_(509) off" 
$ns at 500.0 "$node_(509) on" 
$node_(510) set X_ 628 
$node_(510) set Y_ 265 
$node_(510) set Z_ 0.0 
$ns at 0.0 "$node_(510) off" 
$ns at 500.0 "$node_(510) on" 
$node_(511) set X_ 2356 
$node_(511) set Y_ 957 
$node_(511) set Z_ 0.0 
$ns at 0.0 "$node_(511) off" 
$ns at 500.0 "$node_(511) on" 
$node_(512) set X_ 1642 
$node_(512) set Y_ 606 
$node_(512) set Z_ 0.0 
$ns at 0.0 "$node_(512) off" 
$ns at 500.0 "$node_(512) on" 
$node_(513) set X_ 941 
$node_(513) set Y_ 336 
$node_(513) set Z_ 0.0 
$ns at 0.0 "$node_(513) off" 
$ns at 500.0 "$node_(513) on" 
$node_(514) set X_ 965 
$node_(514) set Y_ 38 
$node_(514) set Z_ 0.0 
$ns at 0.0 "$node_(514) off" 
$ns at 500.0 "$node_(514) on" 
$node_(515) set X_ 2086 
$node_(515) set Y_ 976 
$node_(515) set Z_ 0.0 
$ns at 0.0 "$node_(515) off" 
$ns at 500.0 "$node_(515) on" 
$node_(516) set X_ 591 
$node_(516) set Y_ 983 
$node_(516) set Z_ 0.0 
$ns at 0.0 "$node_(516) off" 
$ns at 500.0 "$node_(516) on" 
$node_(517) set X_ 2288 
$node_(517) set Y_ 537 
$node_(517) set Z_ 0.0 
$ns at 0.0 "$node_(517) off" 
$ns at 500.0 "$node_(517) on" 
$node_(518) set X_ 2433 
$node_(518) set Y_ 622 
$node_(518) set Z_ 0.0 
$ns at 0.0 "$node_(518) off" 
$ns at 500.0 "$node_(518) on" 
$node_(519) set X_ 2177 
$node_(519) set Y_ 675 
$node_(519) set Z_ 0.0 
$ns at 0.0 "$node_(519) off" 
$ns at 500.0 "$node_(519) on" 
$node_(520) set X_ 394 
$node_(520) set Y_ 824 
$node_(520) set Z_ 0.0 
$ns at 0.0 "$node_(520) off" 
$ns at 500.0 "$node_(520) on" 
$node_(521) set X_ 1797 
$node_(521) set Y_ 230 
$node_(521) set Z_ 0.0 
$ns at 0.0 "$node_(521) off" 
$ns at 500.0 "$node_(521) on" 
$node_(522) set X_ 2308 
$node_(522) set Y_ 242 
$node_(522) set Z_ 0.0 
$ns at 0.0 "$node_(522) off" 
$ns at 500.0 "$node_(522) on" 
$node_(523) set X_ 2299 
$node_(523) set Y_ 920 
$node_(523) set Z_ 0.0 
$ns at 0.0 "$node_(523) off" 
$ns at 500.0 "$node_(523) on" 
$node_(524) set X_ 913 
$node_(524) set Y_ 709 
$node_(524) set Z_ 0.0 
$ns at 0.0 "$node_(524) off" 
$ns at 500.0 "$node_(524) on" 
$node_(525) set X_ 1470 
$node_(525) set Y_ 746 
$node_(525) set Z_ 0.0 
$ns at 0.0 "$node_(525) off" 
$ns at 500.0 "$node_(525) on" 
$node_(526) set X_ 2187 
$node_(526) set Y_ 832 
$node_(526) set Z_ 0.0 
$ns at 0.0 "$node_(526) off" 
$ns at 500.0 "$node_(526) on" 
$node_(527) set X_ 2812 
$node_(527) set Y_ 909 
$node_(527) set Z_ 0.0 
$ns at 0.0 "$node_(527) off" 
$ns at 500.0 "$node_(527) on" 
$node_(528) set X_ 2512 
$node_(528) set Y_ 327 
$node_(528) set Z_ 0.0 
$ns at 0.0 "$node_(528) off" 
$ns at 500.0 "$node_(528) on" 
$node_(529) set X_ 667 
$node_(529) set Y_ 18 
$node_(529) set Z_ 0.0 
$ns at 0.0 "$node_(529) off" 
$ns at 500.0 "$node_(529) on" 
$node_(530) set X_ 2269 
$node_(530) set Y_ 220 
$node_(530) set Z_ 0.0 
$ns at 0.0 "$node_(530) off" 
$ns at 500.0 "$node_(530) on" 
$node_(531) set X_ 56 
$node_(531) set Y_ 781 
$node_(531) set Z_ 0.0 
$ns at 0.0 "$node_(531) off" 
$ns at 500.0 "$node_(531) on" 
$node_(532) set X_ 2531 
$node_(532) set Y_ 512 
$node_(532) set Z_ 0.0 
$ns at 0.0 "$node_(532) off" 
$ns at 500.0 "$node_(532) on" 
$node_(533) set X_ 1665 
$node_(533) set Y_ 146 
$node_(533) set Z_ 0.0 
$ns at 0.0 "$node_(533) off" 
$ns at 500.0 "$node_(533) on" 
$node_(534) set X_ 2601 
$node_(534) set Y_ 263 
$node_(534) set Z_ 0.0 
$ns at 0.0 "$node_(534) off" 
$ns at 500.0 "$node_(534) on" 
$node_(535) set X_ 507 
$node_(535) set Y_ 94 
$node_(535) set Z_ 0.0 
$ns at 0.0 "$node_(535) off" 
$ns at 500.0 "$node_(535) on" 
$node_(536) set X_ 2127 
$node_(536) set Y_ 381 
$node_(536) set Z_ 0.0 
$ns at 0.0 "$node_(536) off" 
$ns at 500.0 "$node_(536) on" 
$node_(537) set X_ 461 
$node_(537) set Y_ 885 
$node_(537) set Z_ 0.0 
$ns at 0.0 "$node_(537) off" 
$ns at 500.0 "$node_(537) on" 
$node_(538) set X_ 2553 
$node_(538) set Y_ 543 
$node_(538) set Z_ 0.0 
$ns at 0.0 "$node_(538) off" 
$ns at 500.0 "$node_(538) on" 
$node_(539) set X_ 989 
$node_(539) set Y_ 583 
$node_(539) set Z_ 0.0 
$ns at 0.0 "$node_(539) off" 
$ns at 500.0 "$node_(539) on" 
$node_(540) set X_ 1612 
$node_(540) set Y_ 812 
$node_(540) set Z_ 0.0 
$ns at 0.0 "$node_(540) off" 
$ns at 500.0 "$node_(540) on" 
$node_(541) set X_ 1870 
$node_(541) set Y_ 105 
$node_(541) set Z_ 0.0 
$ns at 0.0 "$node_(541) off" 
$ns at 500.0 "$node_(541) on" 
$node_(542) set X_ 2485 
$node_(542) set Y_ 500 
$node_(542) set Z_ 0.0 
$ns at 0.0 "$node_(542) off" 
$ns at 500.0 "$node_(542) on" 
$node_(543) set X_ 2868 
$node_(543) set Y_ 892 
$node_(543) set Z_ 0.0 
$ns at 0.0 "$node_(543) off" 
$ns at 500.0 "$node_(543) on" 
$node_(544) set X_ 2160 
$node_(544) set Y_ 748 
$node_(544) set Z_ 0.0 
$ns at 0.0 "$node_(544) off" 
$ns at 500.0 "$node_(544) on" 
$node_(545) set X_ 2731 
$node_(545) set Y_ 517 
$node_(545) set Z_ 0.0 
$ns at 0.0 "$node_(545) off" 
$ns at 500.0 "$node_(545) on" 
$node_(546) set X_ 392 
$node_(546) set Y_ 99 
$node_(546) set Z_ 0.0 
$ns at 0.0 "$node_(546) off" 
$ns at 500.0 "$node_(546) on" 
$node_(547) set X_ 2906 
$node_(547) set Y_ 194 
$node_(547) set Z_ 0.0 
$ns at 0.0 "$node_(547) off" 
$ns at 500.0 "$node_(547) on" 
$node_(548) set X_ 2493 
$node_(548) set Y_ 79 
$node_(548) set Z_ 0.0 
$ns at 0.0 "$node_(548) off" 
$ns at 500.0 "$node_(548) on" 
$node_(549) set X_ 1782 
$node_(549) set Y_ 230 
$node_(549) set Z_ 0.0 
$ns at 0.0 "$node_(549) off" 
$ns at 500.0 "$node_(549) on" 
$node_(550) set X_ 985 
$node_(550) set Y_ 414 
$node_(550) set Z_ 0.0 
$ns at 0.0 "$node_(550) off" 
$ns at 500.0 "$node_(550) on" 
$node_(551) set X_ 227 
$node_(551) set Y_ 874 
$node_(551) set Z_ 0.0 
$ns at 0.0 "$node_(551) off" 
$ns at 500.0 "$node_(551) on" 
$node_(552) set X_ 929 
$node_(552) set Y_ 69 
$node_(552) set Z_ 0.0 
$ns at 0.0 "$node_(552) off" 
$ns at 500.0 "$node_(552) on" 
$node_(553) set X_ 2503 
$node_(553) set Y_ 925 
$node_(553) set Z_ 0.0 
$ns at 0.0 "$node_(553) off" 
$ns at 500.0 "$node_(553) on" 
$node_(554) set X_ 1480 
$node_(554) set Y_ 715 
$node_(554) set Z_ 0.0 
$ns at 0.0 "$node_(554) off" 
$ns at 500.0 "$node_(554) on" 
$node_(555) set X_ 2562 
$node_(555) set Y_ 710 
$node_(555) set Z_ 0.0 
$ns at 0.0 "$node_(555) off" 
$ns at 500.0 "$node_(555) on" 
$node_(556) set X_ 1915 
$node_(556) set Y_ 584 
$node_(556) set Z_ 0.0 
$ns at 0.0 "$node_(556) off" 
$ns at 500.0 "$node_(556) on" 
$node_(557) set X_ 2995 
$node_(557) set Y_ 707 
$node_(557) set Z_ 0.0 
$ns at 0.0 "$node_(557) off" 
$ns at 500.0 "$node_(557) on" 
$node_(558) set X_ 89 
$node_(558) set Y_ 951 
$node_(558) set Z_ 0.0 
$ns at 0.0 "$node_(558) off" 
$ns at 500.0 "$node_(558) on" 
$node_(559) set X_ 712 
$node_(559) set Y_ 220 
$node_(559) set Z_ 0.0 
$ns at 0.0 "$node_(559) off" 
$ns at 500.0 "$node_(559) on" 
$node_(560) set X_ 2895 
$node_(560) set Y_ 597 
$node_(560) set Z_ 0.0 
$ns at 0.0 "$node_(560) off" 
$ns at 500.0 "$node_(560) on" 
$node_(561) set X_ 701 
$node_(561) set Y_ 927 
$node_(561) set Z_ 0.0 
$ns at 0.0 "$node_(561) off" 
$ns at 500.0 "$node_(561) on" 
$node_(562) set X_ 1934 
$node_(562) set Y_ 723 
$node_(562) set Z_ 0.0 
$ns at 0.0 "$node_(562) off" 
$ns at 500.0 "$node_(562) on" 
$node_(563) set X_ 912 
$node_(563) set Y_ 102 
$node_(563) set Z_ 0.0 
$ns at 0.0 "$node_(563) off" 
$ns at 500.0 "$node_(563) on" 
$node_(564) set X_ 1168 
$node_(564) set Y_ 722 
$node_(564) set Z_ 0.0 
$ns at 0.0 "$node_(564) off" 
$ns at 500.0 "$node_(564) on" 
$node_(565) set X_ 1526 
$node_(565) set Y_ 535 
$node_(565) set Z_ 0.0 
$ns at 0.0 "$node_(565) off" 
$ns at 500.0 "$node_(565) on" 
$node_(566) set X_ 921 
$node_(566) set Y_ 116 
$node_(566) set Z_ 0.0 
$ns at 0.0 "$node_(566) off" 
$ns at 500.0 "$node_(566) on" 
$node_(567) set X_ 1535 
$node_(567) set Y_ 945 
$node_(567) set Z_ 0.0 
$ns at 0.0 "$node_(567) off" 
$ns at 500.0 "$node_(567) on" 
$node_(568) set X_ 1070 
$node_(568) set Y_ 748 
$node_(568) set Z_ 0.0 
$ns at 0.0 "$node_(568) off" 
$ns at 500.0 "$node_(568) on" 
$node_(569) set X_ 2664 
$node_(569) set Y_ 756 
$node_(569) set Z_ 0.0 
$ns at 0.0 "$node_(569) off" 
$ns at 500.0 "$node_(569) on" 
$node_(570) set X_ 783 
$node_(570) set Y_ 1000 
$node_(570) set Z_ 0.0 
$ns at 0.0 "$node_(570) off" 
$ns at 500.0 "$node_(570) on" 
$node_(571) set X_ 2310 
$node_(571) set Y_ 638 
$node_(571) set Z_ 0.0 
$ns at 0.0 "$node_(571) off" 
$ns at 500.0 "$node_(571) on" 
$node_(572) set X_ 2633 
$node_(572) set Y_ 426 
$node_(572) set Z_ 0.0 
$ns at 0.0 "$node_(572) off" 
$ns at 500.0 "$node_(572) on" 
$node_(573) set X_ 193 
$node_(573) set Y_ 149 
$node_(573) set Z_ 0.0 
$ns at 0.0 "$node_(573) off" 
$ns at 500.0 "$node_(573) on" 
$node_(574) set X_ 1307 
$node_(574) set Y_ 673 
$node_(574) set Z_ 0.0 
$ns at 0.0 "$node_(574) off" 
$ns at 500.0 "$node_(574) on" 
$node_(575) set X_ 2995 
$node_(575) set Y_ 142 
$node_(575) set Z_ 0.0 
$ns at 0.0 "$node_(575) off" 
$ns at 500.0 "$node_(575) on" 
$node_(576) set X_ 1572 
$node_(576) set Y_ 992 
$node_(576) set Z_ 0.0 
$ns at 0.0 "$node_(576) off" 
$ns at 500.0 "$node_(576) on" 
$node_(577) set X_ 1246 
$node_(577) set Y_ 332 
$node_(577) set Z_ 0.0 
$ns at 0.0 "$node_(577) off" 
$ns at 500.0 "$node_(577) on" 
$node_(578) set X_ 2489 
$node_(578) set Y_ 948 
$node_(578) set Z_ 0.0 
$ns at 0.0 "$node_(578) off" 
$ns at 500.0 "$node_(578) on" 
$node_(579) set X_ 187 
$node_(579) set Y_ 572 
$node_(579) set Z_ 0.0 
$ns at 0.0 "$node_(579) off" 
$ns at 500.0 "$node_(579) on" 
$node_(580) set X_ 1227 
$node_(580) set Y_ 160 
$node_(580) set Z_ 0.0 
$ns at 0.0 "$node_(580) off" 
$ns at 500.0 "$node_(580) on" 
$node_(581) set X_ 317 
$node_(581) set Y_ 950 
$node_(581) set Z_ 0.0 
$ns at 0.0 "$node_(581) off" 
$ns at 500.0 "$node_(581) on" 
$node_(582) set X_ 2111 
$node_(582) set Y_ 49 
$node_(582) set Z_ 0.0 
$ns at 0.0 "$node_(582) off" 
$ns at 500.0 "$node_(582) on" 
$node_(583) set X_ 698 
$node_(583) set Y_ 740 
$node_(583) set Z_ 0.0 
$ns at 0.0 "$node_(583) off" 
$ns at 500.0 "$node_(583) on" 
$node_(584) set X_ 1836 
$node_(584) set Y_ 578 
$node_(584) set Z_ 0.0 
$ns at 0.0 "$node_(584) off" 
$ns at 500.0 "$node_(584) on" 
$node_(585) set X_ 9 
$node_(585) set Y_ 661 
$node_(585) set Z_ 0.0 
$ns at 0.0 "$node_(585) off" 
$ns at 500.0 "$node_(585) on" 
$node_(586) set X_ 1986 
$node_(586) set Y_ 942 
$node_(586) set Z_ 0.0 
$ns at 0.0 "$node_(586) off" 
$ns at 500.0 "$node_(586) on" 
$node_(587) set X_ 1688 
$node_(587) set Y_ 604 
$node_(587) set Z_ 0.0 
$ns at 0.0 "$node_(587) off" 
$ns at 500.0 "$node_(587) on" 
$node_(588) set X_ 2251 
$node_(588) set Y_ 991 
$node_(588) set Z_ 0.0 
$ns at 0.0 "$node_(588) off" 
$ns at 500.0 "$node_(588) on" 
$node_(589) set X_ 1282 
$node_(589) set Y_ 214 
$node_(589) set Z_ 0.0 
$ns at 0.0 "$node_(589) off" 
$ns at 500.0 "$node_(589) on" 
$node_(590) set X_ 2865 
$node_(590) set Y_ 942 
$node_(590) set Z_ 0.0 
$ns at 0.0 "$node_(590) off" 
$ns at 500.0 "$node_(590) on" 
$node_(591) set X_ 2484 
$node_(591) set Y_ 287 
$node_(591) set Z_ 0.0 
$ns at 0.0 "$node_(591) off" 
$ns at 500.0 "$node_(591) on" 
$node_(592) set X_ 1976 
$node_(592) set Y_ 581 
$node_(592) set Z_ 0.0 
$ns at 0.0 "$node_(592) off" 
$ns at 500.0 "$node_(592) on" 
$node_(593) set X_ 12 
$node_(593) set Y_ 894 
$node_(593) set Z_ 0.0 
$ns at 0.0 "$node_(593) off" 
$ns at 500.0 "$node_(593) on" 
$node_(594) set X_ 1757 
$node_(594) set Y_ 732 
$node_(594) set Z_ 0.0 
$ns at 0.0 "$node_(594) off" 
$ns at 500.0 "$node_(594) on" 
$node_(595) set X_ 2771 
$node_(595) set Y_ 603 
$node_(595) set Z_ 0.0 
$ns at 0.0 "$node_(595) off" 
$ns at 500.0 "$node_(595) on" 
$node_(596) set X_ 1143 
$node_(596) set Y_ 247 
$node_(596) set Z_ 0.0 
$ns at 0.0 "$node_(596) off" 
$ns at 500.0 "$node_(596) on" 
$node_(597) set X_ 419 
$node_(597) set Y_ 911 
$node_(597) set Z_ 0.0 
$ns at 0.0 "$node_(597) off" 
$ns at 500.0 "$node_(597) on" 
$node_(598) set X_ 159 
$node_(598) set Y_ 141 
$node_(598) set Z_ 0.0 
$ns at 0.0 "$node_(598) off" 
$ns at 500.0 "$node_(598) on" 
$node_(599) set X_ 2582 
$node_(599) set Y_ 250 
$node_(599) set Z_ 0.0 
$ns at 0.0 "$node_(599) off" 
$ns at 500.0 "$node_(599) on" 
$node_(600) set X_ 2800 
$node_(600) set Y_ 790 
$node_(600) set Z_ 0.0 
$ns at 0.0 "$node_(600) off" 
$ns at 600.0 "$node_(600) on" 
$node_(601) set X_ 2674 
$node_(601) set Y_ 516 
$node_(601) set Z_ 0.0 
$ns at 0.0 "$node_(601) off" 
$ns at 600.0 "$node_(601) on" 
$node_(602) set X_ 2430 
$node_(602) set Y_ 302 
$node_(602) set Z_ 0.0 
$ns at 0.0 "$node_(602) off" 
$ns at 600.0 "$node_(602) on" 
$node_(603) set X_ 2282 
$node_(603) set Y_ 113 
$node_(603) set Z_ 0.0 
$ns at 0.0 "$node_(603) off" 
$ns at 600.0 "$node_(603) on" 
$node_(604) set X_ 1628 
$node_(604) set Y_ 258 
$node_(604) set Z_ 0.0 
$ns at 0.0 "$node_(604) off" 
$ns at 600.0 "$node_(604) on" 
$node_(605) set X_ 738 
$node_(605) set Y_ 904 
$node_(605) set Z_ 0.0 
$ns at 0.0 "$node_(605) off" 
$ns at 600.0 "$node_(605) on" 
$node_(606) set X_ 2323 
$node_(606) set Y_ 51 
$node_(606) set Z_ 0.0 
$ns at 0.0 "$node_(606) off" 
$ns at 600.0 "$node_(606) on" 
$node_(607) set X_ 1467 
$node_(607) set Y_ 337 
$node_(607) set Z_ 0.0 
$ns at 0.0 "$node_(607) off" 
$ns at 600.0 "$node_(607) on" 
$node_(608) set X_ 971 
$node_(608) set Y_ 927 
$node_(608) set Z_ 0.0 
$ns at 0.0 "$node_(608) off" 
$ns at 600.0 "$node_(608) on" 
$node_(609) set X_ 246 
$node_(609) set Y_ 194 
$node_(609) set Z_ 0.0 
$ns at 0.0 "$node_(609) off" 
$ns at 600.0 "$node_(609) on" 
$node_(610) set X_ 1404 
$node_(610) set Y_ 682 
$node_(610) set Z_ 0.0 
$ns at 0.0 "$node_(610) off" 
$ns at 600.0 "$node_(610) on" 
$node_(611) set X_ 2476 
$node_(611) set Y_ 114 
$node_(611) set Z_ 0.0 
$ns at 0.0 "$node_(611) off" 
$ns at 600.0 "$node_(611) on" 
$node_(612) set X_ 1774 
$node_(612) set Y_ 671 
$node_(612) set Z_ 0.0 
$ns at 0.0 "$node_(612) off" 
$ns at 600.0 "$node_(612) on" 
$node_(613) set X_ 1000 
$node_(613) set Y_ 55 
$node_(613) set Z_ 0.0 
$ns at 0.0 "$node_(613) off" 
$ns at 600.0 "$node_(613) on" 
$node_(614) set X_ 1872 
$node_(614) set Y_ 422 
$node_(614) set Z_ 0.0 
$ns at 0.0 "$node_(614) off" 
$ns at 600.0 "$node_(614) on" 
$node_(615) set X_ 936 
$node_(615) set Y_ 336 
$node_(615) set Z_ 0.0 
$ns at 0.0 "$node_(615) off" 
$ns at 600.0 "$node_(615) on" 
$node_(616) set X_ 834 
$node_(616) set Y_ 692 
$node_(616) set Z_ 0.0 
$ns at 0.0 "$node_(616) off" 
$ns at 600.0 "$node_(616) on" 
$node_(617) set X_ 361 
$node_(617) set Y_ 757 
$node_(617) set Z_ 0.0 
$ns at 0.0 "$node_(617) off" 
$ns at 600.0 "$node_(617) on" 
$node_(618) set X_ 1005 
$node_(618) set Y_ 228 
$node_(618) set Z_ 0.0 
$ns at 0.0 "$node_(618) off" 
$ns at 600.0 "$node_(618) on" 
$node_(619) set X_ 526 
$node_(619) set Y_ 564 
$node_(619) set Z_ 0.0 
$ns at 0.0 "$node_(619) off" 
$ns at 600.0 "$node_(619) on" 
$node_(620) set X_ 450 
$node_(620) set Y_ 860 
$node_(620) set Z_ 0.0 
$ns at 0.0 "$node_(620) off" 
$ns at 600.0 "$node_(620) on" 
$node_(621) set X_ 2626 
$node_(621) set Y_ 716 
$node_(621) set Z_ 0.0 
$ns at 0.0 "$node_(621) off" 
$ns at 600.0 "$node_(621) on" 
$node_(622) set X_ 246 
$node_(622) set Y_ 792 
$node_(622) set Z_ 0.0 
$ns at 0.0 "$node_(622) off" 
$ns at 600.0 "$node_(622) on" 
$node_(623) set X_ 2906 
$node_(623) set Y_ 972 
$node_(623) set Z_ 0.0 
$ns at 0.0 "$node_(623) off" 
$ns at 600.0 "$node_(623) on" 
$node_(624) set X_ 2380 
$node_(624) set Y_ 148 
$node_(624) set Z_ 0.0 
$ns at 0.0 "$node_(624) off" 
$ns at 600.0 "$node_(624) on" 
$node_(625) set X_ 2173 
$node_(625) set Y_ 826 
$node_(625) set Z_ 0.0 
$ns at 0.0 "$node_(625) off" 
$ns at 600.0 "$node_(625) on" 
$node_(626) set X_ 666 
$node_(626) set Y_ 845 
$node_(626) set Z_ 0.0 
$ns at 0.0 "$node_(626) off" 
$ns at 600.0 "$node_(626) on" 
$node_(627) set X_ 2477 
$node_(627) set Y_ 200 
$node_(627) set Z_ 0.0 
$ns at 0.0 "$node_(627) off" 
$ns at 600.0 "$node_(627) on" 
$node_(628) set X_ 1685 
$node_(628) set Y_ 903 
$node_(628) set Z_ 0.0 
$ns at 0.0 "$node_(628) off" 
$ns at 600.0 "$node_(628) on" 
$node_(629) set X_ 1948 
$node_(629) set Y_ 122 
$node_(629) set Z_ 0.0 
$ns at 0.0 "$node_(629) off" 
$ns at 600.0 "$node_(629) on" 
$node_(630) set X_ 2306 
$node_(630) set Y_ 131 
$node_(630) set Z_ 0.0 
$ns at 0.0 "$node_(630) off" 
$ns at 600.0 "$node_(630) on" 
$node_(631) set X_ 1416 
$node_(631) set Y_ 289 
$node_(631) set Z_ 0.0 
$ns at 0.0 "$node_(631) off" 
$ns at 600.0 "$node_(631) on" 
$node_(632) set X_ 2874 
$node_(632) set Y_ 933 
$node_(632) set Z_ 0.0 
$ns at 0.0 "$node_(632) off" 
$ns at 600.0 "$node_(632) on" 
$node_(633) set X_ 594 
$node_(633) set Y_ 592 
$node_(633) set Z_ 0.0 
$ns at 0.0 "$node_(633) off" 
$ns at 600.0 "$node_(633) on" 
$node_(634) set X_ 1635 
$node_(634) set Y_ 676 
$node_(634) set Z_ 0.0 
$ns at 0.0 "$node_(634) off" 
$ns at 600.0 "$node_(634) on" 
$node_(635) set X_ 1174 
$node_(635) set Y_ 121 
$node_(635) set Z_ 0.0 
$ns at 0.0 "$node_(635) off" 
$ns at 600.0 "$node_(635) on" 
$node_(636) set X_ 431 
$node_(636) set Y_ 657 
$node_(636) set Z_ 0.0 
$ns at 0.0 "$node_(636) off" 
$ns at 600.0 "$node_(636) on" 
$node_(637) set X_ 2295 
$node_(637) set Y_ 171 
$node_(637) set Z_ 0.0 
$ns at 0.0 "$node_(637) off" 
$ns at 600.0 "$node_(637) on" 
$node_(638) set X_ 128 
$node_(638) set Y_ 192 
$node_(638) set Z_ 0.0 
$ns at 0.0 "$node_(638) off" 
$ns at 600.0 "$node_(638) on" 
$node_(639) set X_ 2350 
$node_(639) set Y_ 47 
$node_(639) set Z_ 0.0 
$ns at 0.0 "$node_(639) off" 
$ns at 600.0 "$node_(639) on" 
$node_(640) set X_ 1629 
$node_(640) set Y_ 804 
$node_(640) set Z_ 0.0 
$ns at 0.0 "$node_(640) off" 
$ns at 600.0 "$node_(640) on" 
$node_(641) set X_ 2114 
$node_(641) set Y_ 231 
$node_(641) set Z_ 0.0 
$ns at 0.0 "$node_(641) off" 
$ns at 600.0 "$node_(641) on" 
$node_(642) set X_ 1710 
$node_(642) set Y_ 750 
$node_(642) set Z_ 0.0 
$ns at 0.0 "$node_(642) off" 
$ns at 600.0 "$node_(642) on" 
$node_(643) set X_ 655 
$node_(643) set Y_ 625 
$node_(643) set Z_ 0.0 
$ns at 0.0 "$node_(643) off" 
$ns at 600.0 "$node_(643) on" 
$node_(644) set X_ 2227 
$node_(644) set Y_ 399 
$node_(644) set Z_ 0.0 
$ns at 0.0 "$node_(644) off" 
$ns at 600.0 "$node_(644) on" 
$node_(645) set X_ 2427 
$node_(645) set Y_ 108 
$node_(645) set Z_ 0.0 
$ns at 0.0 "$node_(645) off" 
$ns at 600.0 "$node_(645) on" 
$node_(646) set X_ 1559 
$node_(646) set Y_ 74 
$node_(646) set Z_ 0.0 
$ns at 0.0 "$node_(646) off" 
$ns at 600.0 "$node_(646) on" 
$node_(647) set X_ 372 
$node_(647) set Y_ 639 
$node_(647) set Z_ 0.0 
$ns at 0.0 "$node_(647) off" 
$ns at 600.0 "$node_(647) on" 
$node_(648) set X_ 435 
$node_(648) set Y_ 17 
$node_(648) set Z_ 0.0 
$ns at 0.0 "$node_(648) off" 
$ns at 600.0 "$node_(648) on" 
$node_(649) set X_ 2714 
$node_(649) set Y_ 472 
$node_(649) set Z_ 0.0 
$ns at 0.0 "$node_(649) off" 
$ns at 600.0 "$node_(649) on" 
$node_(650) set X_ 2507 
$node_(650) set Y_ 76 
$node_(650) set Z_ 0.0 
$ns at 0.0 "$node_(650) off" 
$ns at 600.0 "$node_(650) on" 
$node_(651) set X_ 1509 
$node_(651) set Y_ 833 
$node_(651) set Z_ 0.0 
$ns at 0.0 "$node_(651) off" 
$ns at 600.0 "$node_(651) on" 
$node_(652) set X_ 266 
$node_(652) set Y_ 562 
$node_(652) set Z_ 0.0 
$ns at 0.0 "$node_(652) off" 
$ns at 600.0 "$node_(652) on" 
$node_(653) set X_ 1805 
$node_(653) set Y_ 593 
$node_(653) set Z_ 0.0 
$ns at 0.0 "$node_(653) off" 
$ns at 600.0 "$node_(653) on" 
$node_(654) set X_ 59 
$node_(654) set Y_ 487 
$node_(654) set Z_ 0.0 
$ns at 0.0 "$node_(654) off" 
$ns at 600.0 "$node_(654) on" 
$node_(655) set X_ 1580 
$node_(655) set Y_ 30 
$node_(655) set Z_ 0.0 
$ns at 0.0 "$node_(655) off" 
$ns at 600.0 "$node_(655) on" 
$node_(656) set X_ 1139 
$node_(656) set Y_ 34 
$node_(656) set Z_ 0.0 
$ns at 0.0 "$node_(656) off" 
$ns at 600.0 "$node_(656) on" 
$node_(657) set X_ 1366 
$node_(657) set Y_ 797 
$node_(657) set Z_ 0.0 
$ns at 0.0 "$node_(657) off" 
$ns at 600.0 "$node_(657) on" 
$node_(658) set X_ 744 
$node_(658) set Y_ 707 
$node_(658) set Z_ 0.0 
$ns at 0.0 "$node_(658) off" 
$ns at 600.0 "$node_(658) on" 
$node_(659) set X_ 2692 
$node_(659) set Y_ 568 
$node_(659) set Z_ 0.0 
$ns at 0.0 "$node_(659) off" 
$ns at 600.0 "$node_(659) on" 
$node_(660) set X_ 1364 
$node_(660) set Y_ 47 
$node_(660) set Z_ 0.0 
$ns at 0.0 "$node_(660) off" 
$ns at 600.0 "$node_(660) on" 
$node_(661) set X_ 194 
$node_(661) set Y_ 671 
$node_(661) set Z_ 0.0 
$ns at 0.0 "$node_(661) off" 
$ns at 600.0 "$node_(661) on" 
$node_(662) set X_ 1319 
$node_(662) set Y_ 228 
$node_(662) set Z_ 0.0 
$ns at 0.0 "$node_(662) off" 
$ns at 600.0 "$node_(662) on" 
$node_(663) set X_ 371 
$node_(663) set Y_ 214 
$node_(663) set Z_ 0.0 
$ns at 0.0 "$node_(663) off" 
$ns at 600.0 "$node_(663) on" 
$node_(664) set X_ 1876 
$node_(664) set Y_ 67 
$node_(664) set Z_ 0.0 
$ns at 0.0 "$node_(664) off" 
$ns at 600.0 "$node_(664) on" 
$node_(665) set X_ 2627 
$node_(665) set Y_ 804 
$node_(665) set Z_ 0.0 
$ns at 0.0 "$node_(665) off" 
$ns at 600.0 "$node_(665) on" 
$node_(666) set X_ 1063 
$node_(666) set Y_ 251 
$node_(666) set Z_ 0.0 
$ns at 0.0 "$node_(666) off" 
$ns at 600.0 "$node_(666) on" 
$node_(667) set X_ 319 
$node_(667) set Y_ 10 
$node_(667) set Z_ 0.0 
$ns at 0.0 "$node_(667) off" 
$ns at 600.0 "$node_(667) on" 
$node_(668) set X_ 333 
$node_(668) set Y_ 617 
$node_(668) set Z_ 0.0 
$ns at 0.0 "$node_(668) off" 
$ns at 600.0 "$node_(668) on" 
$node_(669) set X_ 2121 
$node_(669) set Y_ 135 
$node_(669) set Z_ 0.0 
$ns at 0.0 "$node_(669) off" 
$ns at 600.0 "$node_(669) on" 
$node_(670) set X_ 151 
$node_(670) set Y_ 359 
$node_(670) set Z_ 0.0 
$ns at 0.0 "$node_(670) off" 
$ns at 600.0 "$node_(670) on" 
$node_(671) set X_ 2022 
$node_(671) set Y_ 688 
$node_(671) set Z_ 0.0 
$ns at 0.0 "$node_(671) off" 
$ns at 600.0 "$node_(671) on" 
$node_(672) set X_ 2460 
$node_(672) set Y_ 946 
$node_(672) set Z_ 0.0 
$ns at 0.0 "$node_(672) off" 
$ns at 600.0 "$node_(672) on" 
$node_(673) set X_ 820 
$node_(673) set Y_ 193 
$node_(673) set Z_ 0.0 
$ns at 0.0 "$node_(673) off" 
$ns at 600.0 "$node_(673) on" 
$node_(674) set X_ 872 
$node_(674) set Y_ 348 
$node_(674) set Z_ 0.0 
$ns at 0.0 "$node_(674) off" 
$ns at 600.0 "$node_(674) on" 
$node_(675) set X_ 2910 
$node_(675) set Y_ 622 
$node_(675) set Z_ 0.0 
$ns at 0.0 "$node_(675) off" 
$ns at 600.0 "$node_(675) on" 
$node_(676) set X_ 252 
$node_(676) set Y_ 874 
$node_(676) set Z_ 0.0 
$ns at 0.0 "$node_(676) off" 
$ns at 600.0 "$node_(676) on" 
$node_(677) set X_ 656 
$node_(677) set Y_ 782 
$node_(677) set Z_ 0.0 
$ns at 0.0 "$node_(677) off" 
$ns at 600.0 "$node_(677) on" 
$node_(678) set X_ 2162 
$node_(678) set Y_ 599 
$node_(678) set Z_ 0.0 
$ns at 0.0 "$node_(678) off" 
$ns at 600.0 "$node_(678) on" 
$node_(679) set X_ 2485 
$node_(679) set Y_ 451 
$node_(679) set Z_ 0.0 
$ns at 0.0 "$node_(679) off" 
$ns at 600.0 "$node_(679) on" 
$node_(680) set X_ 2414 
$node_(680) set Y_ 833 
$node_(680) set Z_ 0.0 
$ns at 0.0 "$node_(680) off" 
$ns at 600.0 "$node_(680) on" 
$node_(681) set X_ 1305 
$node_(681) set Y_ 917 
$node_(681) set Z_ 0.0 
$ns at 0.0 "$node_(681) off" 
$ns at 600.0 "$node_(681) on" 
$node_(682) set X_ 2722 
$node_(682) set Y_ 591 
$node_(682) set Z_ 0.0 
$ns at 0.0 "$node_(682) off" 
$ns at 600.0 "$node_(682) on" 
$node_(683) set X_ 1611 
$node_(683) set Y_ 840 
$node_(683) set Z_ 0.0 
$ns at 0.0 "$node_(683) off" 
$ns at 600.0 "$node_(683) on" 
$node_(684) set X_ 2146 
$node_(684) set Y_ 318 
$node_(684) set Z_ 0.0 
$ns at 0.0 "$node_(684) off" 
$ns at 600.0 "$node_(684) on" 
$node_(685) set X_ 2046 
$node_(685) set Y_ 62 
$node_(685) set Z_ 0.0 
$ns at 0.0 "$node_(685) off" 
$ns at 600.0 "$node_(685) on" 
$node_(686) set X_ 1702 
$node_(686) set Y_ 415 
$node_(686) set Z_ 0.0 
$ns at 0.0 "$node_(686) off" 
$ns at 600.0 "$node_(686) on" 
$node_(687) set X_ 1900 
$node_(687) set Y_ 18 
$node_(687) set Z_ 0.0 
$ns at 0.0 "$node_(687) off" 
$ns at 600.0 "$node_(687) on" 
$node_(688) set X_ 2166 
$node_(688) set Y_ 251 
$node_(688) set Z_ 0.0 
$ns at 0.0 "$node_(688) off" 
$ns at 600.0 "$node_(688) on" 
$node_(689) set X_ 2341 
$node_(689) set Y_ 961 
$node_(689) set Z_ 0.0 
$ns at 0.0 "$node_(689) off" 
$ns at 600.0 "$node_(689) on" 
$node_(690) set X_ 1703 
$node_(690) set Y_ 420 
$node_(690) set Z_ 0.0 
$ns at 0.0 "$node_(690) off" 
$ns at 600.0 "$node_(690) on" 
$node_(691) set X_ 1869 
$node_(691) set Y_ 41 
$node_(691) set Z_ 0.0 
$ns at 0.0 "$node_(691) off" 
$ns at 600.0 "$node_(691) on" 
$node_(692) set X_ 1563 
$node_(692) set Y_ 988 
$node_(692) set Z_ 0.0 
$ns at 0.0 "$node_(692) off" 
$ns at 600.0 "$node_(692) on" 
$node_(693) set X_ 2683 
$node_(693) set Y_ 627 
$node_(693) set Z_ 0.0 
$ns at 0.0 "$node_(693) off" 
$ns at 600.0 "$node_(693) on" 
$node_(694) set X_ 1592 
$node_(694) set Y_ 329 
$node_(694) set Z_ 0.0 
$ns at 0.0 "$node_(694) off" 
$ns at 600.0 "$node_(694) on" 
$node_(695) set X_ 2316 
$node_(695) set Y_ 954 
$node_(695) set Z_ 0.0 
$ns at 0.0 "$node_(695) off" 
$ns at 600.0 "$node_(695) on" 
$node_(696) set X_ 2887 
$node_(696) set Y_ 960 
$node_(696) set Z_ 0.0 
$ns at 0.0 "$node_(696) off" 
$ns at 600.0 "$node_(696) on" 
$node_(697) set X_ 2036 
$node_(697) set Y_ 277 
$node_(697) set Z_ 0.0 
$ns at 0.0 "$node_(697) off" 
$ns at 600.0 "$node_(697) on" 
$node_(698) set X_ 374 
$node_(698) set Y_ 463 
$node_(698) set Z_ 0.0 
$ns at 0.0 "$node_(698) off" 
$ns at 600.0 "$node_(698) on" 
$node_(699) set X_ 1081 
$node_(699) set Y_ 268 
$node_(699) set Z_ 0.0 
$ns at 0.0 "$node_(699) off" 
$ns at 600.0 "$node_(699) on" 
$node_(700) set X_ 2556 
$node_(700) set Y_ 186 
$node_(700) set Z_ 0.0 
$ns at 0.0 "$node_(700) off" 
$ns at 700.0 "$node_(700) on" 
$node_(701) set X_ 909 
$node_(701) set Y_ 272 
$node_(701) set Z_ 0.0 
$ns at 0.0 "$node_(701) off" 
$ns at 700.0 "$node_(701) on" 
$node_(702) set X_ 1124 
$node_(702) set Y_ 921 
$node_(702) set Z_ 0.0 
$ns at 0.0 "$node_(702) off" 
$ns at 700.0 "$node_(702) on" 
$node_(703) set X_ 138 
$node_(703) set Y_ 432 
$node_(703) set Z_ 0.0 
$ns at 0.0 "$node_(703) off" 
$ns at 700.0 "$node_(703) on" 
$node_(704) set X_ 490 
$node_(704) set Y_ 153 
$node_(704) set Z_ 0.0 
$ns at 0.0 "$node_(704) off" 
$ns at 700.0 "$node_(704) on" 
$node_(705) set X_ 1888 
$node_(705) set Y_ 359 
$node_(705) set Z_ 0.0 
$ns at 0.0 "$node_(705) off" 
$ns at 700.0 "$node_(705) on" 
$node_(706) set X_ 1714 
$node_(706) set Y_ 833 
$node_(706) set Z_ 0.0 
$ns at 0.0 "$node_(706) off" 
$ns at 700.0 "$node_(706) on" 
$node_(707) set X_ 703 
$node_(707) set Y_ 237 
$node_(707) set Z_ 0.0 
$ns at 0.0 "$node_(707) off" 
$ns at 700.0 "$node_(707) on" 
$node_(708) set X_ 2565 
$node_(708) set Y_ 783 
$node_(708) set Z_ 0.0 
$ns at 0.0 "$node_(708) off" 
$ns at 700.0 "$node_(708) on" 
$node_(709) set X_ 170 
$node_(709) set Y_ 766 
$node_(709) set Z_ 0.0 
$ns at 0.0 "$node_(709) off" 
$ns at 700.0 "$node_(709) on" 
$node_(710) set X_ 1843 
$node_(710) set Y_ 50 
$node_(710) set Z_ 0.0 
$ns at 0.0 "$node_(710) off" 
$ns at 700.0 "$node_(710) on" 
$node_(711) set X_ 1778 
$node_(711) set Y_ 304 
$node_(711) set Z_ 0.0 
$ns at 0.0 "$node_(711) off" 
$ns at 700.0 "$node_(711) on" 
$node_(712) set X_ 2273 
$node_(712) set Y_ 496 
$node_(712) set Z_ 0.0 
$ns at 0.0 "$node_(712) off" 
$ns at 700.0 "$node_(712) on" 
$node_(713) set X_ 2420 
$node_(713) set Y_ 957 
$node_(713) set Z_ 0.0 
$ns at 0.0 "$node_(713) off" 
$ns at 700.0 "$node_(713) on" 
$node_(714) set X_ 2606 
$node_(714) set Y_ 888 
$node_(714) set Z_ 0.0 
$ns at 0.0 "$node_(714) off" 
$ns at 700.0 "$node_(714) on" 
$node_(715) set X_ 327 
$node_(715) set Y_ 109 
$node_(715) set Z_ 0.0 
$ns at 0.0 "$node_(715) off" 
$ns at 700.0 "$node_(715) on" 
$node_(716) set X_ 704 
$node_(716) set Y_ 601 
$node_(716) set Z_ 0.0 
$ns at 0.0 "$node_(716) off" 
$ns at 700.0 "$node_(716) on" 
$node_(717) set X_ 2000 
$node_(717) set Y_ 83 
$node_(717) set Z_ 0.0 
$ns at 0.0 "$node_(717) off" 
$ns at 700.0 "$node_(717) on" 
$node_(718) set X_ 2607 
$node_(718) set Y_ 778 
$node_(718) set Z_ 0.0 
$ns at 0.0 "$node_(718) off" 
$ns at 700.0 "$node_(718) on" 
$node_(719) set X_ 1023 
$node_(719) set Y_ 196 
$node_(719) set Z_ 0.0 
$ns at 0.0 "$node_(719) off" 
$ns at 700.0 "$node_(719) on" 
$node_(720) set X_ 1720 
$node_(720) set Y_ 488 
$node_(720) set Z_ 0.0 
$ns at 0.0 "$node_(720) off" 
$ns at 700.0 "$node_(720) on" 
$node_(721) set X_ 1392 
$node_(721) set Y_ 449 
$node_(721) set Z_ 0.0 
$ns at 0.0 "$node_(721) off" 
$ns at 700.0 "$node_(721) on" 
$node_(722) set X_ 1350 
$node_(722) set Y_ 948 
$node_(722) set Z_ 0.0 
$ns at 0.0 "$node_(722) off" 
$ns at 700.0 "$node_(722) on" 
$node_(723) set X_ 2219 
$node_(723) set Y_ 526 
$node_(723) set Z_ 0.0 
$ns at 0.0 "$node_(723) off" 
$ns at 700.0 "$node_(723) on" 
$node_(724) set X_ 947 
$node_(724) set Y_ 388 
$node_(724) set Z_ 0.0 
$ns at 0.0 "$node_(724) off" 
$ns at 700.0 "$node_(724) on" 
$node_(725) set X_ 2351 
$node_(725) set Y_ 529 
$node_(725) set Z_ 0.0 
$ns at 0.0 "$node_(725) off" 
$ns at 700.0 "$node_(725) on" 
$node_(726) set X_ 420 
$node_(726) set Y_ 495 
$node_(726) set Z_ 0.0 
$ns at 0.0 "$node_(726) off" 
$ns at 700.0 "$node_(726) on" 
$node_(727) set X_ 625 
$node_(727) set Y_ 120 
$node_(727) set Z_ 0.0 
$ns at 0.0 "$node_(727) off" 
$ns at 700.0 "$node_(727) on" 
$node_(728) set X_ 2951 
$node_(728) set Y_ 660 
$node_(728) set Z_ 0.0 
$ns at 0.0 "$node_(728) off" 
$ns at 700.0 "$node_(728) on" 
$node_(729) set X_ 2120 
$node_(729) set Y_ 345 
$node_(729) set Z_ 0.0 
$ns at 0.0 "$node_(729) off" 
$ns at 700.0 "$node_(729) on" 
$node_(730) set X_ 2691 
$node_(730) set Y_ 458 
$node_(730) set Z_ 0.0 
$ns at 0.0 "$node_(730) off" 
$ns at 700.0 "$node_(730) on" 
$node_(731) set X_ 824 
$node_(731) set Y_ 428 
$node_(731) set Z_ 0.0 
$ns at 0.0 "$node_(731) off" 
$ns at 700.0 "$node_(731) on" 
$node_(732) set X_ 2721 
$node_(732) set Y_ 867 
$node_(732) set Z_ 0.0 
$ns at 0.0 "$node_(732) off" 
$ns at 700.0 "$node_(732) on" 
$node_(733) set X_ 1758 
$node_(733) set Y_ 255 
$node_(733) set Z_ 0.0 
$ns at 0.0 "$node_(733) off" 
$ns at 700.0 "$node_(733) on" 
$node_(734) set X_ 1547 
$node_(734) set Y_ 760 
$node_(734) set Z_ 0.0 
$ns at 0.0 "$node_(734) off" 
$ns at 700.0 "$node_(734) on" 
$node_(735) set X_ 1600 
$node_(735) set Y_ 108 
$node_(735) set Z_ 0.0 
$ns at 0.0 "$node_(735) off" 
$ns at 700.0 "$node_(735) on" 
$node_(736) set X_ 329 
$node_(736) set Y_ 108 
$node_(736) set Z_ 0.0 
$ns at 0.0 "$node_(736) off" 
$ns at 700.0 "$node_(736) on" 
$node_(737) set X_ 374 
$node_(737) set Y_ 442 
$node_(737) set Z_ 0.0 
$ns at 0.0 "$node_(737) off" 
$ns at 700.0 "$node_(737) on" 
$node_(738) set X_ 890 
$node_(738) set Y_ 126 
$node_(738) set Z_ 0.0 
$ns at 0.0 "$node_(738) off" 
$ns at 700.0 "$node_(738) on" 
$node_(739) set X_ 737 
$node_(739) set Y_ 127 
$node_(739) set Z_ 0.0 
$ns at 0.0 "$node_(739) off" 
$ns at 700.0 "$node_(739) on" 
$node_(740) set X_ 1396 
$node_(740) set Y_ 368 
$node_(740) set Z_ 0.0 
$ns at 0.0 "$node_(740) off" 
$ns at 700.0 "$node_(740) on" 
$node_(741) set X_ 853 
$node_(741) set Y_ 674 
$node_(741) set Z_ 0.0 
$ns at 0.0 "$node_(741) off" 
$ns at 700.0 "$node_(741) on" 
$node_(742) set X_ 2401 
$node_(742) set Y_ 347 
$node_(742) set Z_ 0.0 
$ns at 0.0 "$node_(742) off" 
$ns at 700.0 "$node_(742) on" 
$node_(743) set X_ 738 
$node_(743) set Y_ 366 
$node_(743) set Z_ 0.0 
$ns at 0.0 "$node_(743) off" 
$ns at 700.0 "$node_(743) on" 
$node_(744) set X_ 1716 
$node_(744) set Y_ 850 
$node_(744) set Z_ 0.0 
$ns at 0.0 "$node_(744) off" 
$ns at 700.0 "$node_(744) on" 
$node_(745) set X_ 2363 
$node_(745) set Y_ 119 
$node_(745) set Z_ 0.0 
$ns at 0.0 "$node_(745) off" 
$ns at 700.0 "$node_(745) on" 
$node_(746) set X_ 2315 
$node_(746) set Y_ 502 
$node_(746) set Z_ 0.0 
$ns at 0.0 "$node_(746) off" 
$ns at 700.0 "$node_(746) on" 
$node_(747) set X_ 1635 
$node_(747) set Y_ 159 
$node_(747) set Z_ 0.0 
$ns at 0.0 "$node_(747) off" 
$ns at 700.0 "$node_(747) on" 
$node_(748) set X_ 183 
$node_(748) set Y_ 545 
$node_(748) set Z_ 0.0 
$ns at 0.0 "$node_(748) off" 
$ns at 700.0 "$node_(748) on" 
$node_(749) set X_ 706 
$node_(749) set Y_ 268 
$node_(749) set Z_ 0.0 
$ns at 0.0 "$node_(749) off" 
$ns at 700.0 "$node_(749) on" 
$node_(750) set X_ 1712 
$node_(750) set Y_ 993 
$node_(750) set Z_ 0.0 
$ns at 0.0 "$node_(750) off" 
$ns at 700.0 "$node_(750) on" 
$node_(751) set X_ 837 
$node_(751) set Y_ 439 
$node_(751) set Z_ 0.0 
$ns at 0.0 "$node_(751) off" 
$ns at 700.0 "$node_(751) on" 
$node_(752) set X_ 876 
$node_(752) set Y_ 522 
$node_(752) set Z_ 0.0 
$ns at 0.0 "$node_(752) off" 
$ns at 700.0 "$node_(752) on" 
$node_(753) set X_ 323 
$node_(753) set Y_ 283 
$node_(753) set Z_ 0.0 
$ns at 0.0 "$node_(753) off" 
$ns at 700.0 "$node_(753) on" 
$node_(754) set X_ 2053 
$node_(754) set Y_ 521 
$node_(754) set Z_ 0.0 
$ns at 0.0 "$node_(754) off" 
$ns at 700.0 "$node_(754) on" 
$node_(755) set X_ 2681 
$node_(755) set Y_ 406 
$node_(755) set Z_ 0.0 
$ns at 0.0 "$node_(755) off" 
$ns at 700.0 "$node_(755) on" 
$node_(756) set X_ 1927 
$node_(756) set Y_ 673 
$node_(756) set Z_ 0.0 
$ns at 0.0 "$node_(756) off" 
$ns at 700.0 "$node_(756) on" 
$node_(757) set X_ 516 
$node_(757) set Y_ 290 
$node_(757) set Z_ 0.0 
$ns at 0.0 "$node_(757) off" 
$ns at 700.0 "$node_(757) on" 
$node_(758) set X_ 474 
$node_(758) set Y_ 355 
$node_(758) set Z_ 0.0 
$ns at 0.0 "$node_(758) off" 
$ns at 700.0 "$node_(758) on" 
$node_(759) set X_ 2146 
$node_(759) set Y_ 912 
$node_(759) set Z_ 0.0 
$ns at 0.0 "$node_(759) off" 
$ns at 700.0 "$node_(759) on" 
$node_(760) set X_ 2545 
$node_(760) set Y_ 906 
$node_(760) set Z_ 0.0 
$ns at 0.0 "$node_(760) off" 
$ns at 700.0 "$node_(760) on" 
$node_(761) set X_ 183 
$node_(761) set Y_ 454 
$node_(761) set Z_ 0.0 
$ns at 0.0 "$node_(761) off" 
$ns at 700.0 "$node_(761) on" 
$node_(762) set X_ 66 
$node_(762) set Y_ 506 
$node_(762) set Z_ 0.0 
$ns at 0.0 "$node_(762) off" 
$ns at 700.0 "$node_(762) on" 
$node_(763) set X_ 883 
$node_(763) set Y_ 978 
$node_(763) set Z_ 0.0 
$ns at 0.0 "$node_(763) off" 
$ns at 700.0 "$node_(763) on" 
$node_(764) set X_ 312 
$node_(764) set Y_ 25 
$node_(764) set Z_ 0.0 
$ns at 0.0 "$node_(764) off" 
$ns at 700.0 "$node_(764) on" 
$node_(765) set X_ 138 
$node_(765) set Y_ 858 
$node_(765) set Z_ 0.0 
$ns at 0.0 "$node_(765) off" 
$ns at 700.0 "$node_(765) on" 
$node_(766) set X_ 163 
$node_(766) set Y_ 682 
$node_(766) set Z_ 0.0 
$ns at 0.0 "$node_(766) off" 
$ns at 700.0 "$node_(766) on" 
$node_(767) set X_ 523 
$node_(767) set Y_ 112 
$node_(767) set Z_ 0.0 
$ns at 0.0 "$node_(767) off" 
$ns at 700.0 "$node_(767) on" 
$node_(768) set X_ 2636 
$node_(768) set Y_ 782 
$node_(768) set Z_ 0.0 
$ns at 0.0 "$node_(768) off" 
$ns at 700.0 "$node_(768) on" 
$node_(769) set X_ 822 
$node_(769) set Y_ 497 
$node_(769) set Z_ 0.0 
$ns at 0.0 "$node_(769) off" 
$ns at 700.0 "$node_(769) on" 
$node_(770) set X_ 1355 
$node_(770) set Y_ 121 
$node_(770) set Z_ 0.0 
$ns at 0.0 "$node_(770) off" 
$ns at 700.0 "$node_(770) on" 
$node_(771) set X_ 2926 
$node_(771) set Y_ 376 
$node_(771) set Z_ 0.0 
$ns at 0.0 "$node_(771) off" 
$ns at 700.0 "$node_(771) on" 
$node_(772) set X_ 1958 
$node_(772) set Y_ 838 
$node_(772) set Z_ 0.0 
$ns at 0.0 "$node_(772) off" 
$ns at 700.0 "$node_(772) on" 
$node_(773) set X_ 2950 
$node_(773) set Y_ 948 
$node_(773) set Z_ 0.0 
$ns at 0.0 "$node_(773) off" 
$ns at 700.0 "$node_(773) on" 
$node_(774) set X_ 741 
$node_(774) set Y_ 681 
$node_(774) set Z_ 0.0 
$ns at 0.0 "$node_(774) off" 
$ns at 700.0 "$node_(774) on" 
$node_(775) set X_ 2813 
$node_(775) set Y_ 345 
$node_(775) set Z_ 0.0 
$ns at 0.0 "$node_(775) off" 
$ns at 700.0 "$node_(775) on" 
$node_(776) set X_ 111 
$node_(776) set Y_ 626 
$node_(776) set Z_ 0.0 
$ns at 0.0 "$node_(776) off" 
$ns at 700.0 "$node_(776) on" 
$node_(777) set X_ 1425 
$node_(777) set Y_ 496 
$node_(777) set Z_ 0.0 
$ns at 0.0 "$node_(777) off" 
$ns at 700.0 "$node_(777) on" 
$node_(778) set X_ 1666 
$node_(778) set Y_ 785 
$node_(778) set Z_ 0.0 
$ns at 0.0 "$node_(778) off" 
$ns at 700.0 "$node_(778) on" 
$node_(779) set X_ 966 
$node_(779) set Y_ 420 
$node_(779) set Z_ 0.0 
$ns at 0.0 "$node_(779) off" 
$ns at 700.0 "$node_(779) on" 
$node_(780) set X_ 2929 
$node_(780) set Y_ 352 
$node_(780) set Z_ 0.0 
$ns at 0.0 "$node_(780) off" 
$ns at 700.0 "$node_(780) on" 
$node_(781) set X_ 2558 
$node_(781) set Y_ 783 
$node_(781) set Z_ 0.0 
$ns at 0.0 "$node_(781) off" 
$ns at 700.0 "$node_(781) on" 
$node_(782) set X_ 2929 
$node_(782) set Y_ 100 
$node_(782) set Z_ 0.0 
$ns at 0.0 "$node_(782) off" 
$ns at 700.0 "$node_(782) on" 
$node_(783) set X_ 930 
$node_(783) set Y_ 141 
$node_(783) set Z_ 0.0 
$ns at 0.0 "$node_(783) off" 
$ns at 700.0 "$node_(783) on" 
$node_(784) set X_ 2994 
$node_(784) set Y_ 623 
$node_(784) set Z_ 0.0 
$ns at 0.0 "$node_(784) off" 
$ns at 700.0 "$node_(784) on" 
$node_(785) set X_ 2417 
$node_(785) set Y_ 278 
$node_(785) set Z_ 0.0 
$ns at 0.0 "$node_(785) off" 
$ns at 700.0 "$node_(785) on" 
$node_(786) set X_ 2217 
$node_(786) set Y_ 45 
$node_(786) set Z_ 0.0 
$ns at 0.0 "$node_(786) off" 
$ns at 700.0 "$node_(786) on" 
$node_(787) set X_ 888 
$node_(787) set Y_ 444 
$node_(787) set Z_ 0.0 
$ns at 0.0 "$node_(787) off" 
$ns at 700.0 "$node_(787) on" 
$node_(788) set X_ 2136 
$node_(788) set Y_ 436 
$node_(788) set Z_ 0.0 
$ns at 0.0 "$node_(788) off" 
$ns at 700.0 "$node_(788) on" 
$node_(789) set X_ 2847 
$node_(789) set Y_ 108 
$node_(789) set Z_ 0.0 
$ns at 0.0 "$node_(789) off" 
$ns at 700.0 "$node_(789) on" 
$node_(790) set X_ 1261 
$node_(790) set Y_ 513 
$node_(790) set Z_ 0.0 
$ns at 0.0 "$node_(790) off" 
$ns at 700.0 "$node_(790) on" 
$node_(791) set X_ 2166 
$node_(791) set Y_ 27 
$node_(791) set Z_ 0.0 
$ns at 0.0 "$node_(791) off" 
$ns at 700.0 "$node_(791) on" 
$node_(792) set X_ 47 
$node_(792) set Y_ 526 
$node_(792) set Z_ 0.0 
$ns at 0.0 "$node_(792) off" 
$ns at 700.0 "$node_(792) on" 
$node_(793) set X_ 1494 
$node_(793) set Y_ 72 
$node_(793) set Z_ 0.0 
$ns at 0.0 "$node_(793) off" 
$ns at 700.0 "$node_(793) on" 
$node_(794) set X_ 953 
$node_(794) set Y_ 399 
$node_(794) set Z_ 0.0 
$ns at 0.0 "$node_(794) off" 
$ns at 700.0 "$node_(794) on" 
$node_(795) set X_ 2528 
$node_(795) set Y_ 261 
$node_(795) set Z_ 0.0 
$ns at 0.0 "$node_(795) off" 
$ns at 700.0 "$node_(795) on" 
$node_(796) set X_ 2152 
$node_(796) set Y_ 299 
$node_(796) set Z_ 0.0 
$ns at 0.0 "$node_(796) off" 
$ns at 700.0 "$node_(796) on" 
$node_(797) set X_ 864 
$node_(797) set Y_ 865 
$node_(797) set Z_ 0.0 
$ns at 0.0 "$node_(797) off" 
$ns at 700.0 "$node_(797) on" 
$node_(798) set X_ 2421 
$node_(798) set Y_ 815 
$node_(798) set Z_ 0.0 
$ns at 0.0 "$node_(798) off" 
$ns at 700.0 "$node_(798) on" 
$node_(799) set X_ 210 
$node_(799) set Y_ 312 
$node_(799) set Z_ 0.0 
$ns at 0.0 "$node_(799) off" 
$ns at 700.0 "$node_(799) on" 

# Generation of movements
$ns at 0.0 "$node_(0) setdest 50190 26705 8.0" 
$ns at 96.16302966976139 "$node_(0) setdest 26148 2728 16.0" 
$ns at 190.91786862867633 "$node_(0) setdest 85753 34616 1.0" 
$ns at 228.58786815225204 "$node_(0) setdest 60185 41113 16.0" 
$ns at 322.90358867608364 "$node_(0) setdest 52794 46829 19.0" 
$ns at 477.9246842572926 "$node_(0) setdest 43416 22835 14.0" 
$ns at 526.1825826028057 "$node_(0) setdest 60537 49142 9.0" 
$ns at 579.3012631726398 "$node_(0) setdest 47434 13213 4.0" 
$ns at 614.1219578343262 "$node_(0) setdest 169469 74142 16.0" 
$ns at 795.9430250367179 "$node_(0) setdest 245503 45209 8.0" 
$ns at 881.3379090657916 "$node_(0) setdest 79786 75686 2.0" 
$ns at 0.0 "$node_(1) setdest 82349 30181 9.0" 
$ns at 80.52311986527769 "$node_(1) setdest 38230 26990 2.0" 
$ns at 122.40979084815277 "$node_(1) setdest 21253 27320 20.0" 
$ns at 230.1199247472664 "$node_(1) setdest 83500 44714 14.0" 
$ns at 396.90136439555647 "$node_(1) setdest 186542 1361 1.0" 
$ns at 436.43787909530835 "$node_(1) setdest 22073 4025 7.0" 
$ns at 528.5641209653968 "$node_(1) setdest 89265 5329 2.0" 
$ns at 576.0508987867493 "$node_(1) setdest 66771 41294 13.0" 
$ns at 729.5581697542775 "$node_(1) setdest 145646 1341 11.0" 
$ns at 764.9278255025694 "$node_(1) setdest 34534 24206 19.0" 
$ns at 899.8484491136846 "$node_(1) setdest 242886 29807 10.0" 
$ns at 0.0 "$node_(2) setdest 92313 4041 19.0" 
$ns at 160.322672212305 "$node_(2) setdest 46056 31799 4.0" 
$ns at 211.39409110109975 "$node_(2) setdest 80112 44674 3.0" 
$ns at 253.97881771531846 "$node_(2) setdest 82778 20512 9.0" 
$ns at 319.9095104379451 "$node_(2) setdest 146165 2849 8.0" 
$ns at 394.0529051417667 "$node_(2) setdest 132862 28562 13.0" 
$ns at 543.8685195617003 "$node_(2) setdest 114417 8815 17.0" 
$ns at 616.1823992125848 "$node_(2) setdest 223356 74606 1.0" 
$ns at 647.5950708141803 "$node_(2) setdest 104969 40579 1.0" 
$ns at 684.7397247309176 "$node_(2) setdest 85353 25466 5.0" 
$ns at 743.0857381351665 "$node_(2) setdest 212793 60049 1.0" 
$ns at 775.0280250101348 "$node_(2) setdest 28757 29621 1.0" 
$ns at 810.9709125928861 "$node_(2) setdest 68796 58773 7.0" 
$ns at 0.0 "$node_(3) setdest 62143 13110 6.0" 
$ns at 33.61192666526906 "$node_(3) setdest 81005 22644 9.0" 
$ns at 100.84576208518641 "$node_(3) setdest 18939 2416 10.0" 
$ns at 166.0430981456775 "$node_(3) setdest 115322 21863 5.0" 
$ns at 213.16240828083866 "$node_(3) setdest 81739 3120 17.0" 
$ns at 370.24556868127115 "$node_(3) setdest 179049 58945 7.0" 
$ns at 422.9859025350681 "$node_(3) setdest 178966 1097 7.0" 
$ns at 516.8357971081964 "$node_(3) setdest 181329 41689 1.0" 
$ns at 548.2451181994412 "$node_(3) setdest 112964 68651 1.0" 
$ns at 585.5177413198898 "$node_(3) setdest 168231 68965 10.0" 
$ns at 615.8968514305475 "$node_(3) setdest 158931 39131 7.0" 
$ns at 707.3453025838508 "$node_(3) setdest 188810 63127 5.0" 
$ns at 753.6707217489908 "$node_(3) setdest 91346 18780 20.0" 
$ns at 0.0 "$node_(4) setdest 22687 31586 5.0" 
$ns at 41.452239622750994 "$node_(4) setdest 26491 21903 1.0" 
$ns at 75.73154214015966 "$node_(4) setdest 15034 8788 3.0" 
$ns at 115.82922765573451 "$node_(4) setdest 64500 14400 20.0" 
$ns at 221.38373531142923 "$node_(4) setdest 99156 24618 10.0" 
$ns at 318.3836571914344 "$node_(4) setdest 23708 14242 9.0" 
$ns at 398.53879859269557 "$node_(4) setdest 143658 19518 8.0" 
$ns at 482.86841281967236 "$node_(4) setdest 106202 59652 11.0" 
$ns at 547.422603306257 "$node_(4) setdest 105531 4100 1.0" 
$ns at 584.6203565474683 "$node_(4) setdest 226252 7609 3.0" 
$ns at 632.2119069178908 "$node_(4) setdest 137185 61045 5.0" 
$ns at 688.4717523725044 "$node_(4) setdest 138657 6557 5.0" 
$ns at 754.3877419342163 "$node_(4) setdest 48652 37564 20.0" 
$ns at 878.9249717697514 "$node_(4) setdest 171436 40141 17.0" 
$ns at 0.0 "$node_(5) setdest 13360 14873 18.0" 
$ns at 155.33065131533522 "$node_(5) setdest 41324 10585 2.0" 
$ns at 199.1437625510918 "$node_(5) setdest 36331 18769 2.0" 
$ns at 236.06807524236046 "$node_(5) setdest 102257 40 14.0" 
$ns at 293.9130124078801 "$node_(5) setdest 117477 28686 13.0" 
$ns at 394.8858472815377 "$node_(5) setdest 154067 49454 4.0" 
$ns at 425.5551197957895 "$node_(5) setdest 5743 3494 12.0" 
$ns at 557.2585584189069 "$node_(5) setdest 108088 34516 6.0" 
$ns at 611.9819191187981 "$node_(5) setdest 145557 16677 13.0" 
$ns at 672.6805974097812 "$node_(5) setdest 239798 23761 1.0" 
$ns at 710.7602206952083 "$node_(5) setdest 132995 16923 12.0" 
$ns at 858.9016887828736 "$node_(5) setdest 213072 88266 14.0" 
$ns at 0.0 "$node_(6) setdest 64580 5578 20.0" 
$ns at 211.60523072450155 "$node_(6) setdest 90672 15493 6.0" 
$ns at 281.30386610997215 "$node_(6) setdest 35804 5938 3.0" 
$ns at 335.9443079688147 "$node_(6) setdest 52676 16965 12.0" 
$ns at 373.3704581025533 "$node_(6) setdest 87426 47493 1.0" 
$ns at 405.8431660755458 "$node_(6) setdest 110794 15218 17.0" 
$ns at 578.7370649313445 "$node_(6) setdest 126427 17034 19.0" 
$ns at 737.6741649036416 "$node_(6) setdest 104940 42309 2.0" 
$ns at 779.620572442893 "$node_(6) setdest 244868 82782 9.0" 
$ns at 894.576581198215 "$node_(6) setdest 138193 66812 16.0" 
$ns at 0.0 "$node_(7) setdest 12657 26567 14.0" 
$ns at 96.91028444171893 "$node_(7) setdest 67755 14378 6.0" 
$ns at 175.4160267501934 "$node_(7) setdest 98251 15272 1.0" 
$ns at 210.88561628600587 "$node_(7) setdest 68003 31451 10.0" 
$ns at 317.5697936088332 "$node_(7) setdest 1838 6586 18.0" 
$ns at 479.16855098141207 "$node_(7) setdest 46395 11628 7.0" 
$ns at 531.0739006305814 "$node_(7) setdest 11463 62863 13.0" 
$ns at 588.7497254059239 "$node_(7) setdest 163412 58855 5.0" 
$ns at 631.5982262111745 "$node_(7) setdest 87890 68320 9.0" 
$ns at 722.2445135417014 "$node_(7) setdest 157506 47432 15.0" 
$ns at 792.7715542387925 "$node_(7) setdest 251685 34288 15.0" 
$ns at 0.0 "$node_(8) setdest 64792 26621 10.0" 
$ns at 35.37301843066983 "$node_(8) setdest 41495 24419 15.0" 
$ns at 71.97263256907526 "$node_(8) setdest 28674 8583 16.0" 
$ns at 115.75268949673674 "$node_(8) setdest 15163 26028 16.0" 
$ns at 170.3850993024932 "$node_(8) setdest 95964 36618 11.0" 
$ns at 214.11592936074547 "$node_(8) setdest 103400 11162 9.0" 
$ns at 244.50077607963792 "$node_(8) setdest 57113 34663 7.0" 
$ns at 336.6504742653051 "$node_(8) setdest 131582 39994 18.0" 
$ns at 374.7122178753229 "$node_(8) setdest 83541 55707 15.0" 
$ns at 493.38785784337745 "$node_(8) setdest 162722 63890 17.0" 
$ns at 644.0170199141623 "$node_(8) setdest 193574 48817 14.0" 
$ns at 711.4843052124706 "$node_(8) setdest 34683 6072 14.0" 
$ns at 880.0204902809195 "$node_(8) setdest 127686 10904 19.0" 
$ns at 0.0 "$node_(9) setdest 57032 19128 14.0" 
$ns at 32.63460450497901 "$node_(9) setdest 1773 2173 19.0" 
$ns at 213.96109404946668 "$node_(9) setdest 45242 11992 16.0" 
$ns at 360.1315439441936 "$node_(9) setdest 85341 52536 19.0" 
$ns at 556.7124041892112 "$node_(9) setdest 61047 76582 1.0" 
$ns at 595.2247542332423 "$node_(9) setdest 190405 45205 5.0" 
$ns at 665.5864918751922 "$node_(9) setdest 111233 64529 8.0" 
$ns at 765.8803363422825 "$node_(9) setdest 257081 88327 16.0" 
$ns at 819.6144402559423 "$node_(9) setdest 36694 68788 7.0" 
$ns at 897.7271247309986 "$node_(9) setdest 73083 86520 14.0" 
$ns at 0.0 "$node_(10) setdest 16562 23435 11.0" 
$ns at 136.5701861024337 "$node_(10) setdest 90018 14843 2.0" 
$ns at 175.57445180506556 "$node_(10) setdest 85159 17274 2.0" 
$ns at 219.8590937872861 "$node_(10) setdest 20121 13750 2.0" 
$ns at 249.87740526647553 "$node_(10) setdest 2301 13055 3.0" 
$ns at 289.4855157401827 "$node_(10) setdest 5282 25252 14.0" 
$ns at 362.14084864415895 "$node_(10) setdest 71384 30691 9.0" 
$ns at 402.55454379131766 "$node_(10) setdest 127057 27779 1.0" 
$ns at 437.35829798276467 "$node_(10) setdest 22465 52224 6.0" 
$ns at 488.8871571064774 "$node_(10) setdest 45649 40578 8.0" 
$ns at 565.13700443452 "$node_(10) setdest 97951 56313 7.0" 
$ns at 595.5976480616634 "$node_(10) setdest 204453 27489 13.0" 
$ns at 689.0171124408215 "$node_(10) setdest 121271 79191 1.0" 
$ns at 727.0822257919671 "$node_(10) setdest 141553 14326 1.0" 
$ns at 761.2271426513303 "$node_(10) setdest 14745 38563 17.0" 
$ns at 878.2283102371363 "$node_(10) setdest 59476 6314 17.0" 
$ns at 0.0 "$node_(11) setdest 92002 14448 1.0" 
$ns at 32.70466157083752 "$node_(11) setdest 27521 12692 2.0" 
$ns at 66.4715052745845 "$node_(11) setdest 58734 17432 14.0" 
$ns at 165.04821132709793 "$node_(11) setdest 102827 20119 7.0" 
$ns at 229.8718281447812 "$node_(11) setdest 78787 41880 11.0" 
$ns at 339.74676397169816 "$node_(11) setdest 125504 23919 13.0" 
$ns at 496.80852678333974 "$node_(11) setdest 190858 34060 20.0" 
$ns at 607.0134637989445 "$node_(11) setdest 146124 37521 17.0" 
$ns at 667.0287511046604 "$node_(11) setdest 148801 33684 9.0" 
$ns at 732.593826923634 "$node_(11) setdest 239051 35217 1.0" 
$ns at 763.1403001949403 "$node_(11) setdest 150606 17599 18.0" 
$ns at 0.0 "$node_(12) setdest 5305 16809 8.0" 
$ns at 57.73254103793029 "$node_(12) setdest 84515 17481 1.0" 
$ns at 92.9102240533515 "$node_(12) setdest 74460 19681 15.0" 
$ns at 257.9055237491446 "$node_(12) setdest 21959 12150 10.0" 
$ns at 297.15587765635803 "$node_(12) setdest 113711 507 15.0" 
$ns at 388.67854499815246 "$node_(12) setdest 44017 5656 18.0" 
$ns at 512.2075291877454 "$node_(12) setdest 199817 20854 1.0" 
$ns at 544.5204376883955 "$node_(12) setdest 10442 66211 16.0" 
$ns at 676.5878612824469 "$node_(12) setdest 130323 3998 8.0" 
$ns at 721.5181672426019 "$node_(12) setdest 179042 52404 7.0" 
$ns at 756.6448648326974 "$node_(12) setdest 153506 66707 18.0" 
$ns at 886.5956479089537 "$node_(12) setdest 61998 63433 14.0" 
$ns at 0.0 "$node_(13) setdest 92377 18925 14.0" 
$ns at 122.51672177705349 "$node_(13) setdest 7536 21427 1.0" 
$ns at 158.05754582505915 "$node_(13) setdest 58129 4935 15.0" 
$ns at 298.69319837287014 "$node_(13) setdest 120215 20028 7.0" 
$ns at 392.4617665121757 "$node_(13) setdest 140052 31592 18.0" 
$ns at 422.48960544186343 "$node_(13) setdest 61484 14419 2.0" 
$ns at 460.3076380939542 "$node_(13) setdest 203755 23607 17.0" 
$ns at 506.0324203628774 "$node_(13) setdest 195667 34422 7.0" 
$ns at 576.6914272161719 "$node_(13) setdest 164795 77378 18.0" 
$ns at 668.187249260313 "$node_(13) setdest 23219 32303 9.0" 
$ns at 771.1625105431905 "$node_(13) setdest 203714 76958 13.0" 
$ns at 865.1748165806497 "$node_(13) setdest 197044 3641 4.0" 
$ns at 0.0 "$node_(14) setdest 60860 7412 1.0" 
$ns at 38.485638545656414 "$node_(14) setdest 36532 19567 14.0" 
$ns at 135.5398152795597 "$node_(14) setdest 2291 16726 16.0" 
$ns at 324.96859612991506 "$node_(14) setdest 73782 46321 17.0" 
$ns at 457.9539326621998 "$node_(14) setdest 205201 12028 1.0" 
$ns at 493.31865184341314 "$node_(14) setdest 12943 4815 7.0" 
$ns at 560.5839065596025 "$node_(14) setdest 89357 13623 10.0" 
$ns at 640.472497870444 "$node_(14) setdest 125606 28330 7.0" 
$ns at 678.5689362383779 "$node_(14) setdest 73138 41066 2.0" 
$ns at 715.9454873255627 "$node_(14) setdest 161487 37662 1.0" 
$ns at 751.0332448033419 "$node_(14) setdest 180986 39843 12.0" 
$ns at 888.6863098956902 "$node_(14) setdest 18306 30206 12.0" 
$ns at 0.0 "$node_(15) setdest 5906 30133 16.0" 
$ns at 49.5419885258352 "$node_(15) setdest 87722 1136 17.0" 
$ns at 193.39542205121498 "$node_(15) setdest 17393 13707 15.0" 
$ns at 265.2273637306962 "$node_(15) setdest 19766 40030 2.0" 
$ns at 298.8062105105596 "$node_(15) setdest 151015 37903 9.0" 
$ns at 375.66281459643807 "$node_(15) setdest 165689 13546 3.0" 
$ns at 412.20902126124946 "$node_(15) setdest 96614 49110 14.0" 
$ns at 530.3195507900812 "$node_(15) setdest 171399 38051 7.0" 
$ns at 591.107995328637 "$node_(15) setdest 49749 76579 4.0" 
$ns at 626.726216164227 "$node_(15) setdest 79123 10565 8.0" 
$ns at 729.5981106547451 "$node_(15) setdest 161666 29504 7.0" 
$ns at 798.6279119788117 "$node_(15) setdest 83374 80470 6.0" 
$ns at 852.1608942848546 "$node_(15) setdest 56685 88524 7.0" 
$ns at 0.0 "$node_(16) setdest 6521 29843 4.0" 
$ns at 52.59647042272669 "$node_(16) setdest 86394 20554 18.0" 
$ns at 180.22371200838228 "$node_(16) setdest 63315 2610 6.0" 
$ns at 210.54326375379236 "$node_(16) setdest 61744 39716 12.0" 
$ns at 290.98035085910413 "$node_(16) setdest 82174 4159 9.0" 
$ns at 407.2959244989194 "$node_(16) setdest 24728 47211 19.0" 
$ns at 474.92265635654707 "$node_(16) setdest 94544 45759 15.0" 
$ns at 537.1644067893128 "$node_(16) setdest 179531 4129 17.0" 
$ns at 635.7694027624624 "$node_(16) setdest 205872 12593 1.0" 
$ns at 672.0661752731738 "$node_(16) setdest 99087 61512 14.0" 
$ns at 710.3635628851271 "$node_(16) setdest 224433 67660 2.0" 
$ns at 742.4429709496909 "$node_(16) setdest 204915 54411 4.0" 
$ns at 790.4317167658095 "$node_(16) setdest 52909 89070 2.0" 
$ns at 821.6504434163926 "$node_(16) setdest 85124 87974 19.0" 
$ns at 0.0 "$node_(17) setdest 22368 20461 19.0" 
$ns at 168.22831267161644 "$node_(17) setdest 37600 6214 17.0" 
$ns at 349.7401491577996 "$node_(17) setdest 55119 4698 6.0" 
$ns at 425.9244039313669 "$node_(17) setdest 39723 37912 8.0" 
$ns at 494.8575660509104 "$node_(17) setdest 94232 36130 2.0" 
$ns at 526.50867052423 "$node_(17) setdest 145934 23455 16.0" 
$ns at 636.1747417238028 "$node_(17) setdest 33660 23034 12.0" 
$ns at 760.3867257783874 "$node_(17) setdest 183495 54059 6.0" 
$ns at 794.1992731098118 "$node_(17) setdest 241003 54547 1.0" 
$ns at 831.4200024881839 "$node_(17) setdest 210073 29773 7.0" 
$ns at 0.0 "$node_(18) setdest 68754 2204 10.0" 
$ns at 32.20945114851574 "$node_(18) setdest 17360 9933 4.0" 
$ns at 65.17994948686888 "$node_(18) setdest 74175 14585 1.0" 
$ns at 100.31772186386083 "$node_(18) setdest 50353 30508 18.0" 
$ns at 308.0495365414723 "$node_(18) setdest 89228 39276 11.0" 
$ns at 343.5834461288339 "$node_(18) setdest 153292 23310 3.0" 
$ns at 392.0444904611201 "$node_(18) setdest 101787 42402 1.0" 
$ns at 422.477701259377 "$node_(18) setdest 137382 9236 6.0" 
$ns at 486.21605935032335 "$node_(18) setdest 180419 22083 20.0" 
$ns at 667.5836195196222 "$node_(18) setdest 206707 26060 14.0" 
$ns at 742.99974359597 "$node_(18) setdest 216377 45385 17.0" 
$ns at 800.550584327343 "$node_(18) setdest 204625 65039 18.0" 
$ns at 851.4364106212957 "$node_(18) setdest 240366 58308 8.0" 
$ns at 0.0 "$node_(19) setdest 67787 681 19.0" 
$ns at 182.31981972868508 "$node_(19) setdest 103395 1145 5.0" 
$ns at 221.2879254658294 "$node_(19) setdest 14712 12643 6.0" 
$ns at 302.852370404069 "$node_(19) setdest 72481 44000 1.0" 
$ns at 338.65702438219154 "$node_(19) setdest 109569 26889 10.0" 
$ns at 423.8203967832701 "$node_(19) setdest 36008 30819 11.0" 
$ns at 475.7536314768002 "$node_(19) setdest 196019 25510 7.0" 
$ns at 556.7897774586725 "$node_(19) setdest 18320 56886 15.0" 
$ns at 669.2437559638543 "$node_(19) setdest 150576 38133 15.0" 
$ns at 840.7856413166867 "$node_(19) setdest 165543 73515 19.0" 
$ns at 890.2620218699878 "$node_(19) setdest 98693 61669 16.0" 
$ns at 0.0 "$node_(20) setdest 80532 16585 10.0" 
$ns at 78.92037941818586 "$node_(20) setdest 83028 18199 6.0" 
$ns at 150.45832645749957 "$node_(20) setdest 43590 17471 1.0" 
$ns at 187.1694701338037 "$node_(20) setdest 12048 37585 1.0" 
$ns at 221.5827617401343 "$node_(20) setdest 88116 29423 1.0" 
$ns at 252.85428991400119 "$node_(20) setdest 50082 14375 14.0" 
$ns at 332.9183168902638 "$node_(20) setdest 101488 16070 10.0" 
$ns at 398.92821846578204 "$node_(20) setdest 73051 53711 6.0" 
$ns at 477.348290228035 "$node_(20) setdest 210558 63608 16.0" 
$ns at 550.9208298393532 "$node_(20) setdest 20049 55640 15.0" 
$ns at 635.5342931937802 "$node_(20) setdest 148058 36605 3.0" 
$ns at 671.8873477988295 "$node_(20) setdest 132955 24517 14.0" 
$ns at 703.1585518635461 "$node_(20) setdest 113093 21075 8.0" 
$ns at 792.267680460232 "$node_(20) setdest 43801 60620 1.0" 
$ns at 822.6674795450602 "$node_(20) setdest 59310 13340 8.0" 
$ns at 885.8939948483942 "$node_(20) setdest 212588 29076 4.0" 
$ns at 0.0 "$node_(21) setdest 52151 15647 10.0" 
$ns at 46.54836401117142 "$node_(21) setdest 48525 11351 4.0" 
$ns at 83.57328798104967 "$node_(21) setdest 29493 2867 16.0" 
$ns at 115.31855695002943 "$node_(21) setdest 58812 5261 12.0" 
$ns at 259.59381336061176 "$node_(21) setdest 58317 44192 17.0" 
$ns at 328.57077746236394 "$node_(21) setdest 139870 6646 16.0" 
$ns at 454.81805813061436 "$node_(21) setdest 87258 14926 15.0" 
$ns at 520.5286438439889 "$node_(21) setdest 106319 39192 10.0" 
$ns at 603.2596284312285 "$node_(21) setdest 92715 75053 17.0" 
$ns at 761.4402480294802 "$node_(21) setdest 76408 29521 5.0" 
$ns at 805.7408381722042 "$node_(21) setdest 161017 269 2.0" 
$ns at 836.3191824233094 "$node_(21) setdest 1096 57971 12.0" 
$ns at 0.0 "$node_(22) setdest 38475 20547 10.0" 
$ns at 51.29381780208585 "$node_(22) setdest 34176 29340 11.0" 
$ns at 131.02713566433306 "$node_(22) setdest 55828 9538 2.0" 
$ns at 163.94062729748458 "$node_(22) setdest 65763 39897 20.0" 
$ns at 359.56290451803227 "$node_(22) setdest 59312 17295 8.0" 
$ns at 399.6614806157919 "$node_(22) setdest 11587 13507 11.0" 
$ns at 453.24922170893143 "$node_(22) setdest 70668 62285 8.0" 
$ns at 520.2758861555801 "$node_(22) setdest 924 23678 3.0" 
$ns at 560.6407480036822 "$node_(22) setdest 22494 75073 12.0" 
$ns at 692.9789922057437 "$node_(22) setdest 55471 27459 10.0" 
$ns at 746.4921253512543 "$node_(22) setdest 175212 31911 4.0" 
$ns at 812.2446946286451 "$node_(22) setdest 225522 81047 11.0" 
$ns at 0.0 "$node_(23) setdest 85260 3251 8.0" 
$ns at 52.14745687858848 "$node_(23) setdest 82080 29959 5.0" 
$ns at 127.13263490578453 "$node_(23) setdest 63352 2249 5.0" 
$ns at 180.2409265349662 "$node_(23) setdest 37920 6745 4.0" 
$ns at 240.3278250872248 "$node_(23) setdest 127289 39824 18.0" 
$ns at 430.280668683775 "$node_(23) setdest 185366 43089 15.0" 
$ns at 537.1064520669275 "$node_(23) setdest 129651 66255 8.0" 
$ns at 568.4898988260287 "$node_(23) setdest 5205 71238 16.0" 
$ns at 730.7512545017473 "$node_(23) setdest 199244 49743 6.0" 
$ns at 806.3609153759862 "$node_(23) setdest 51052 60964 4.0" 
$ns at 836.7545324432745 "$node_(23) setdest 25762 54504 17.0" 
$ns at 882.8564909762006 "$node_(23) setdest 201694 46251 12.0" 
$ns at 0.0 "$node_(24) setdest 30814 25330 7.0" 
$ns at 94.05927309881912 "$node_(24) setdest 86145 30206 17.0" 
$ns at 242.6478095860786 "$node_(24) setdest 101209 27657 19.0" 
$ns at 352.612714226547 "$node_(24) setdest 81856 50985 1.0" 
$ns at 385.9399546148838 "$node_(24) setdest 19924 17681 11.0" 
$ns at 481.22283367375246 "$node_(24) setdest 73481 62590 15.0" 
$ns at 586.4689817939413 "$node_(24) setdest 162397 37355 10.0" 
$ns at 672.7093774554412 "$node_(24) setdest 184777 64452 6.0" 
$ns at 752.7272107516909 "$node_(24) setdest 133894 82756 1.0" 
$ns at 791.8320702082226 "$node_(24) setdest 1149 41027 11.0" 
$ns at 848.5623994415062 "$node_(24) setdest 265494 11378 18.0" 
$ns at 0.0 "$node_(25) setdest 16533 1036 4.0" 
$ns at 53.953805713288446 "$node_(25) setdest 9730 8927 11.0" 
$ns at 129.09653219251777 "$node_(25) setdest 5631 22203 11.0" 
$ns at 206.423846071817 "$node_(25) setdest 87386 6276 13.0" 
$ns at 323.1436043775661 "$node_(25) setdest 63092 45565 6.0" 
$ns at 358.710331033859 "$node_(25) setdest 184676 9491 3.0" 
$ns at 389.1465046454349 "$node_(25) setdest 35924 52037 2.0" 
$ns at 420.5859498161003 "$node_(25) setdest 141046 22369 16.0" 
$ns at 583.7091559421146 "$node_(25) setdest 24437 73950 7.0" 
$ns at 638.1835027255889 "$node_(25) setdest 37677 59711 1.0" 
$ns at 676.824318839868 "$node_(25) setdest 80121 46702 18.0" 
$ns at 708.3943655151646 "$node_(25) setdest 245322 21816 13.0" 
$ns at 806.8178099584366 "$node_(25) setdest 87775 11324 13.0" 
$ns at 0.0 "$node_(26) setdest 4292 3160 12.0" 
$ns at 96.85982976878064 "$node_(26) setdest 75350 7337 3.0" 
$ns at 134.79392722904237 "$node_(26) setdest 36830 24189 4.0" 
$ns at 177.44430340453405 "$node_(26) setdest 15000 16043 4.0" 
$ns at 230.7496316886576 "$node_(26) setdest 128431 29397 7.0" 
$ns at 280.3978921707827 "$node_(26) setdest 78687 942 20.0" 
$ns at 493.92007831983375 "$node_(26) setdest 117660 53736 8.0" 
$ns at 567.0688073301689 "$node_(26) setdest 137817 58238 11.0" 
$ns at 606.5994059131799 "$node_(26) setdest 145227 35790 11.0" 
$ns at 673.623144003427 "$node_(26) setdest 70547 75806 14.0" 
$ns at 842.4332710531456 "$node_(26) setdest 233707 3793 16.0" 
$ns at 0.0 "$node_(27) setdest 61818 8144 3.0" 
$ns at 54.460972862227536 "$node_(27) setdest 85543 17326 14.0" 
$ns at 163.22400001910307 "$node_(27) setdest 80880 39688 15.0" 
$ns at 322.90181585856664 "$node_(27) setdest 60703 3084 15.0" 
$ns at 443.31013395025366 "$node_(27) setdest 145294 56697 18.0" 
$ns at 559.8302597943276 "$node_(27) setdest 70376 43501 5.0" 
$ns at 597.2132066750506 "$node_(27) setdest 50276 64370 9.0" 
$ns at 690.1828804340627 "$node_(27) setdest 148948 81125 9.0" 
$ns at 733.3901576538793 "$node_(27) setdest 135009 78093 1.0" 
$ns at 769.2141640682567 "$node_(27) setdest 225877 84342 11.0" 
$ns at 836.8062105789963 "$node_(27) setdest 17647 51722 15.0" 
$ns at 0.0 "$node_(28) setdest 2040 18433 9.0" 
$ns at 81.85893467466332 "$node_(28) setdest 37643 16116 2.0" 
$ns at 112.95501993843465 "$node_(28) setdest 63262 5910 7.0" 
$ns at 182.1734620129697 "$node_(28) setdest 66408 33137 11.0" 
$ns at 272.20235005992345 "$node_(28) setdest 89074 31213 18.0" 
$ns at 372.6769777252 "$node_(28) setdest 185144 14683 1.0" 
$ns at 404.5012325690501 "$node_(28) setdest 189525 43486 9.0" 
$ns at 468.9706889439538 "$node_(28) setdest 85084 49946 3.0" 
$ns at 527.3363773652948 "$node_(28) setdest 101625 38902 1.0" 
$ns at 567.3228404205915 "$node_(28) setdest 154886 17037 1.0" 
$ns at 600.1785967055448 "$node_(28) setdest 202122 51481 2.0" 
$ns at 649.1297058694976 "$node_(28) setdest 189075 27063 1.0" 
$ns at 679.9412820967311 "$node_(28) setdest 167684 41322 1.0" 
$ns at 717.3141983188227 "$node_(28) setdest 213007 8979 16.0" 
$ns at 855.3648372067915 "$node_(28) setdest 43383 60047 2.0" 
$ns at 890.1127624777281 "$node_(28) setdest 107251 85171 8.0" 
$ns at 0.0 "$node_(29) setdest 7931 30312 12.0" 
$ns at 36.44492707575059 "$node_(29) setdest 28006 15946 2.0" 
$ns at 74.00449217739114 "$node_(29) setdest 42393 5849 3.0" 
$ns at 126.93410634279742 "$node_(29) setdest 37433 26264 2.0" 
$ns at 160.66975509238088 "$node_(29) setdest 69354 29408 12.0" 
$ns at 228.82477908043919 "$node_(29) setdest 34070 18506 10.0" 
$ns at 271.74563932181957 "$node_(29) setdest 21141 42661 13.0" 
$ns at 320.66648556660937 "$node_(29) setdest 75348 9139 18.0" 
$ns at 434.79856915848774 "$node_(29) setdest 152691 54476 12.0" 
$ns at 559.0883696517178 "$node_(29) setdest 163632 8257 1.0" 
$ns at 590.463898696913 "$node_(29) setdest 88983 29197 9.0" 
$ns at 627.2397681897343 "$node_(29) setdest 222883 42684 9.0" 
$ns at 680.3935061649617 "$node_(29) setdest 27262 10853 9.0" 
$ns at 728.8233113488536 "$node_(29) setdest 72683 79658 19.0" 
$ns at 781.1608393902211 "$node_(29) setdest 107443 8033 19.0" 
$ns at 847.4291465279961 "$node_(29) setdest 48112 65098 14.0" 
$ns at 0.0 "$node_(30) setdest 70695 27739 14.0" 
$ns at 109.18650915370888 "$node_(30) setdest 40494 22366 9.0" 
$ns at 147.50742192880568 "$node_(30) setdest 40784 4218 5.0" 
$ns at 194.17987135451892 "$node_(30) setdest 127646 2289 14.0" 
$ns at 313.18039718135196 "$node_(30) setdest 11053 14764 16.0" 
$ns at 422.7241318678756 "$node_(30) setdest 17058 48191 1.0" 
$ns at 457.386652349204 "$node_(30) setdest 25897 23270 16.0" 
$ns at 599.8728055784592 "$node_(30) setdest 50412 11307 18.0" 
$ns at 790.2958547941786 "$node_(30) setdest 240296 85234 16.0" 
$ns at 0.0 "$node_(31) setdest 73054 26614 17.0" 
$ns at 177.13890844034975 "$node_(31) setdest 90456 30694 12.0" 
$ns at 256.1447184218877 "$node_(31) setdest 1963 15141 4.0" 
$ns at 298.0757760019112 "$node_(31) setdest 192 6281 10.0" 
$ns at 394.4216560348077 "$node_(31) setdest 21232 42159 5.0" 
$ns at 436.9516689515253 "$node_(31) setdest 52307 35866 10.0" 
$ns at 558.0633309247505 "$node_(31) setdest 87935 71401 20.0" 
$ns at 628.0298864219309 "$node_(31) setdest 32347 29146 7.0" 
$ns at 723.1050921385744 "$node_(31) setdest 181972 5778 16.0" 
$ns at 880.5215124184963 "$node_(31) setdest 95019 83377 20.0" 
$ns at 0.0 "$node_(32) setdest 66528 1862 5.0" 
$ns at 69.43275586097488 "$node_(32) setdest 12581 585 3.0" 
$ns at 103.38933533063094 "$node_(32) setdest 63686 2101 8.0" 
$ns at 136.7880502215398 "$node_(32) setdest 11624 5374 7.0" 
$ns at 226.08144920145793 "$node_(32) setdest 130310 29150 11.0" 
$ns at 347.3593626958831 "$node_(32) setdest 83359 2102 1.0" 
$ns at 383.16303371241713 "$node_(32) setdest 24373 24798 11.0" 
$ns at 502.63299907408685 "$node_(32) setdest 196659 477 5.0" 
$ns at 557.118474812002 "$node_(32) setdest 110057 65738 3.0" 
$ns at 599.2002407263525 "$node_(32) setdest 41308 41689 6.0" 
$ns at 637.0738054431672 "$node_(32) setdest 169344 76155 2.0" 
$ns at 675.2215427057172 "$node_(32) setdest 224794 83630 6.0" 
$ns at 735.1553825209496 "$node_(32) setdest 100980 32225 2.0" 
$ns at 768.4139110220298 "$node_(32) setdest 183414 84677 11.0" 
$ns at 808.7191625060617 "$node_(32) setdest 19836 82745 16.0" 
$ns at 0.0 "$node_(33) setdest 36727 3498 12.0" 
$ns at 38.76728334084475 "$node_(33) setdest 85426 21993 1.0" 
$ns at 74.99813037199416 "$node_(33) setdest 45209 18094 19.0" 
$ns at 253.52356723474145 "$node_(33) setdest 152131 19370 15.0" 
$ns at 381.24458788085 "$node_(33) setdest 140771 54644 6.0" 
$ns at 424.0954552692957 "$node_(33) setdest 4967 14541 8.0" 
$ns at 530.3965085207302 "$node_(33) setdest 161022 69835 12.0" 
$ns at 585.6243381346192 "$node_(33) setdest 133090 63008 9.0" 
$ns at 682.778282244105 "$node_(33) setdest 208937 48888 6.0" 
$ns at 738.802447757309 "$node_(33) setdest 36219 40149 8.0" 
$ns at 833.0925017952851 "$node_(33) setdest 99971 66895 19.0" 
$ns at 0.0 "$node_(34) setdest 82668 18148 9.0" 
$ns at 103.679332141713 "$node_(34) setdest 86803 6878 16.0" 
$ns at 190.19029043753943 "$node_(34) setdest 32737 9372 17.0" 
$ns at 328.8524646088772 "$node_(34) setdest 39003 51435 7.0" 
$ns at 361.7969177365636 "$node_(34) setdest 88256 25437 2.0" 
$ns at 408.0276056940541 "$node_(34) setdest 53576 14765 18.0" 
$ns at 563.8542857116786 "$node_(34) setdest 158506 30589 6.0" 
$ns at 600.1007461147888 "$node_(34) setdest 195881 4612 12.0" 
$ns at 662.4012250952793 "$node_(34) setdest 170047 24512 13.0" 
$ns at 814.2997536126172 "$node_(34) setdest 58239 9913 13.0" 
$ns at 869.3018397822455 "$node_(34) setdest 228640 33047 1.0" 
$ns at 0.0 "$node_(35) setdest 27431 23192 1.0" 
$ns at 32.884706800169695 "$node_(35) setdest 55174 20725 9.0" 
$ns at 130.9636343697195 "$node_(35) setdest 70695 28584 10.0" 
$ns at 244.2407414901726 "$node_(35) setdest 37443 30294 14.0" 
$ns at 368.7024479300892 "$node_(35) setdest 71756 47795 1.0" 
$ns at 399.9142450648995 "$node_(35) setdest 141468 28900 8.0" 
$ns at 471.4476111498326 "$node_(35) setdest 146709 27672 19.0" 
$ns at 516.1492901688239 "$node_(35) setdest 135861 9428 15.0" 
$ns at 615.2102116157382 "$node_(35) setdest 59783 75127 10.0" 
$ns at 715.3905236864341 "$node_(35) setdest 38570 68996 18.0" 
$ns at 796.591513397261 "$node_(35) setdest 143616 27467 15.0" 
$ns at 888.6272306028791 "$node_(35) setdest 56960 52726 18.0" 
$ns at 0.0 "$node_(36) setdest 10640 15086 9.0" 
$ns at 82.74466721753907 "$node_(36) setdest 76158 19064 12.0" 
$ns at 149.06961443548812 "$node_(36) setdest 53666 4847 8.0" 
$ns at 245.2212740535846 "$node_(36) setdest 32406 40678 6.0" 
$ns at 285.2859630672889 "$node_(36) setdest 67618 37110 16.0" 
$ns at 443.81235126578326 "$node_(36) setdest 90197 23301 16.0" 
$ns at 501.08184802985136 "$node_(36) setdest 178267 6725 2.0" 
$ns at 544.3462137490162 "$node_(36) setdest 157864 45966 7.0" 
$ns at 576.9195798660356 "$node_(36) setdest 46911 49896 5.0" 
$ns at 624.5952396010999 "$node_(36) setdest 43630 31192 15.0" 
$ns at 692.6841462775749 "$node_(36) setdest 111034 36637 16.0" 
$ns at 784.3605651348828 "$node_(36) setdest 61398 84785 14.0" 
$ns at 853.8278633053651 "$node_(36) setdest 255873 29319 1.0" 
$ns at 892.3164568197695 "$node_(36) setdest 218476 10793 9.0" 
$ns at 0.0 "$node_(37) setdest 51168 5880 17.0" 
$ns at 153.2429310543007 "$node_(37) setdest 113553 5193 18.0" 
$ns at 226.78252420697558 "$node_(37) setdest 61367 4246 8.0" 
$ns at 320.7544599906961 "$node_(37) setdest 63600 25041 13.0" 
$ns at 456.25553681527083 "$node_(37) setdest 157615 12990 19.0" 
$ns at 624.4042033499659 "$node_(37) setdest 108149 34515 9.0" 
$ns at 658.453251732502 "$node_(37) setdest 68253 8130 7.0" 
$ns at 691.600393713003 "$node_(37) setdest 143646 59402 16.0" 
$ns at 794.2967598879075 "$node_(37) setdest 72263 30292 10.0" 
$ns at 843.479340828734 "$node_(37) setdest 46471 63897 14.0" 
$ns at 0.0 "$node_(38) setdest 21040 30759 6.0" 
$ns at 79.66350237536699 "$node_(38) setdest 77904 10752 14.0" 
$ns at 163.48902802772778 "$node_(38) setdest 53627 19079 6.0" 
$ns at 193.99484474549166 "$node_(38) setdest 94279 40428 11.0" 
$ns at 277.7659495406933 "$node_(38) setdest 73388 20812 4.0" 
$ns at 308.3410317977915 "$node_(38) setdest 114615 12515 19.0" 
$ns at 453.6424443900766 "$node_(38) setdest 157602 69200 8.0" 
$ns at 554.4393980060925 "$node_(38) setdest 66297 48224 5.0" 
$ns at 630.5965816327403 "$node_(38) setdest 116393 66880 10.0" 
$ns at 756.4971789996573 "$node_(38) setdest 236320 79732 2.0" 
$ns at 788.4738031685582 "$node_(38) setdest 214045 67104 16.0" 
$ns at 0.0 "$node_(39) setdest 40708 23247 10.0" 
$ns at 79.45917808796777 "$node_(39) setdest 407 17423 4.0" 
$ns at 129.94161209422634 "$node_(39) setdest 32698 4766 8.0" 
$ns at 169.58815938055375 "$node_(39) setdest 42403 12194 17.0" 
$ns at 349.5172711473164 "$node_(39) setdest 20272 38391 17.0" 
$ns at 547.647513685437 "$node_(39) setdest 72815 12999 4.0" 
$ns at 604.5906155954985 "$node_(39) setdest 49361 59065 12.0" 
$ns at 730.0015389497095 "$node_(39) setdest 242889 82489 15.0" 
$ns at 850.0506856936345 "$node_(39) setdest 259867 10541 17.0" 
$ns at 897.4484701079991 "$node_(39) setdest 247646 87491 14.0" 
$ns at 0.0 "$node_(40) setdest 74619 15896 2.0" 
$ns at 39.153741822030476 "$node_(40) setdest 76358 14364 16.0" 
$ns at 196.36416918579238 "$node_(40) setdest 98169 43544 13.0" 
$ns at 240.98868645342512 "$node_(40) setdest 63068 36622 11.0" 
$ns at 271.1169455389068 "$node_(40) setdest 41972 11445 5.0" 
$ns at 314.87124897146526 "$node_(40) setdest 4648 8932 6.0" 
$ns at 345.9277053282323 "$node_(40) setdest 136206 5727 18.0" 
$ns at 388.6350255628955 "$node_(40) setdest 168264 18052 1.0" 
$ns at 426.81243017093846 "$node_(40) setdest 109129 17751 19.0" 
$ns at 577.2671341020672 "$node_(40) setdest 128618 30884 16.0" 
$ns at 655.2247750540992 "$node_(40) setdest 58198 30155 5.0" 
$ns at 685.8171637371065 "$node_(40) setdest 38908 797 6.0" 
$ns at 737.5346738499479 "$node_(40) setdest 6869 11290 10.0" 
$ns at 847.4455796968784 "$node_(40) setdest 235684 63443 14.0" 
$ns at 0.0 "$node_(41) setdest 28591 30911 9.0" 
$ns at 91.73267671198545 "$node_(41) setdest 75086 27359 13.0" 
$ns at 217.7787213259066 "$node_(41) setdest 127827 5382 14.0" 
$ns at 295.5163619271682 "$node_(41) setdest 123421 24566 3.0" 
$ns at 352.8979789201284 "$node_(41) setdest 8785 41594 18.0" 
$ns at 438.13002150965326 "$node_(41) setdest 67177 31011 19.0" 
$ns at 593.0404893689072 "$node_(41) setdest 37286 29998 16.0" 
$ns at 756.3168405637862 "$node_(41) setdest 37394 80556 6.0" 
$ns at 822.4053606192974 "$node_(41) setdest 82705 76489 6.0" 
$ns at 0.0 "$node_(42) setdest 47281 20272 1.0" 
$ns at 35.95956470104396 "$node_(42) setdest 48674 6817 13.0" 
$ns at 107.30942989706914 "$node_(42) setdest 94832 15442 3.0" 
$ns at 137.92456478593164 "$node_(42) setdest 35289 24353 10.0" 
$ns at 188.26611855946243 "$node_(42) setdest 11466 39233 15.0" 
$ns at 309.9357887637462 "$node_(42) setdest 30835 16385 18.0" 
$ns at 348.05421556714714 "$node_(42) setdest 57162 30765 7.0" 
$ns at 403.2969114145859 "$node_(42) setdest 95235 34720 5.0" 
$ns at 445.87621557280113 "$node_(42) setdest 159381 5111 5.0" 
$ns at 490.4870228736829 "$node_(42) setdest 23833 34469 6.0" 
$ns at 578.9561844075895 "$node_(42) setdest 30397 20931 19.0" 
$ns at 638.900140380659 "$node_(42) setdest 210079 14896 14.0" 
$ns at 728.8479837704672 "$node_(42) setdest 14963 25551 5.0" 
$ns at 776.826649170829 "$node_(42) setdest 21151 43313 17.0" 
$ns at 0.0 "$node_(43) setdest 37741 503 12.0" 
$ns at 108.07142516846557 "$node_(43) setdest 58220 21168 3.0" 
$ns at 144.11194705147227 "$node_(43) setdest 82975 14506 19.0" 
$ns at 251.5807033624168 "$node_(43) setdest 5021 175 9.0" 
$ns at 305.1066548183876 "$node_(43) setdest 44999 54170 7.0" 
$ns at 372.54746508033196 "$node_(43) setdest 153572 46797 18.0" 
$ns at 476.9078933942186 "$node_(43) setdest 118562 22379 2.0" 
$ns at 512.7675782919845 "$node_(43) setdest 5689 62267 5.0" 
$ns at 563.9259403341401 "$node_(43) setdest 54132 22127 9.0" 
$ns at 648.7551483915556 "$node_(43) setdest 12102 76118 13.0" 
$ns at 700.3561129083722 "$node_(43) setdest 98197 30829 2.0" 
$ns at 743.6668498329686 "$node_(43) setdest 96004 53971 2.0" 
$ns at 789.5473017047302 "$node_(43) setdest 46327 9599 18.0" 
$ns at 0.0 "$node_(44) setdest 90162 16801 5.0" 
$ns at 66.49644075496079 "$node_(44) setdest 53849 31521 16.0" 
$ns at 119.88214189130093 "$node_(44) setdest 45882 1406 6.0" 
$ns at 174.63438405947235 "$node_(44) setdest 105876 24265 19.0" 
$ns at 240.13150919627302 "$node_(44) setdest 100840 765 8.0" 
$ns at 347.43561462699006 "$node_(44) setdest 109165 26609 5.0" 
$ns at 409.8054343960399 "$node_(44) setdest 147784 1860 9.0" 
$ns at 459.9341833762492 "$node_(44) setdest 159782 30459 7.0" 
$ns at 500.7874866962625 "$node_(44) setdest 76036 15473 2.0" 
$ns at 546.284190993425 "$node_(44) setdest 32204 25785 1.0" 
$ns at 579.6770114419913 "$node_(44) setdest 103772 53789 15.0" 
$ns at 755.3519233328341 "$node_(44) setdest 50153 72239 15.0" 
$ns at 0.0 "$node_(45) setdest 25755 29078 9.0" 
$ns at 35.175951049606226 "$node_(45) setdest 43549 18379 8.0" 
$ns at 125.9449544413348 "$node_(45) setdest 22541 21362 4.0" 
$ns at 190.33489040575816 "$node_(45) setdest 126259 19374 7.0" 
$ns at 252.27675836555565 "$node_(45) setdest 157353 25765 2.0" 
$ns at 296.3370445329625 "$node_(45) setdest 14658 459 6.0" 
$ns at 360.4609173190559 "$node_(45) setdest 188653 31955 11.0" 
$ns at 443.97523119607683 "$node_(45) setdest 32944 57013 8.0" 
$ns at 492.64020537481196 "$node_(45) setdest 30566 39724 20.0" 
$ns at 540.7512279624241 "$node_(45) setdest 60602 55334 3.0" 
$ns at 584.2167934399611 "$node_(45) setdest 80102 32888 18.0" 
$ns at 711.7766880517236 "$node_(45) setdest 182883 69612 5.0" 
$ns at 787.8318566948317 "$node_(45) setdest 144454 62694 15.0" 
$ns at 0.0 "$node_(46) setdest 71062 30791 3.0" 
$ns at 49.4374282995077 "$node_(46) setdest 6929 4801 1.0" 
$ns at 87.24720261526713 "$node_(46) setdest 77417 20375 16.0" 
$ns at 244.557918519143 "$node_(46) setdest 63560 40122 6.0" 
$ns at 317.805782750214 "$node_(46) setdest 148685 4814 1.0" 
$ns at 354.48544159206153 "$node_(46) setdest 126291 6874 14.0" 
$ns at 491.22109625340784 "$node_(46) setdest 104480 29209 5.0" 
$ns at 562.0628629122198 "$node_(46) setdest 227961 4162 11.0" 
$ns at 700.1153105207161 "$node_(46) setdest 55737 75434 14.0" 
$ns at 813.8466879769104 "$node_(46) setdest 142943 53950 5.0" 
$ns at 886.8047432212581 "$node_(46) setdest 118767 27417 2.0" 
$ns at 0.0 "$node_(47) setdest 74500 17926 16.0" 
$ns at 136.84292429078175 "$node_(47) setdest 7811 4052 2.0" 
$ns at 178.67908608026409 "$node_(47) setdest 54503 21007 9.0" 
$ns at 212.03667758430365 "$node_(47) setdest 75279 4746 16.0" 
$ns at 323.18788272867545 "$node_(47) setdest 119868 34612 5.0" 
$ns at 370.6803229117483 "$node_(47) setdest 132853 26315 7.0" 
$ns at 469.92055647856154 "$node_(47) setdest 87620 47114 13.0" 
$ns at 617.5375310506057 "$node_(47) setdest 194237 23905 10.0" 
$ns at 729.6851331539611 "$node_(47) setdest 30802 63284 11.0" 
$ns at 762.4058615860355 "$node_(47) setdest 159335 16073 14.0" 
$ns at 874.0339155358953 "$node_(47) setdest 86978 29369 18.0" 
$ns at 0.0 "$node_(48) setdest 3007 9802 7.0" 
$ns at 81.13227530245493 "$node_(48) setdest 48861 30991 9.0" 
$ns at 133.87710937735747 "$node_(48) setdest 10117 24085 13.0" 
$ns at 232.84308818403568 "$node_(48) setdest 64356 34890 17.0" 
$ns at 352.5454305480318 "$node_(48) setdest 128033 10840 18.0" 
$ns at 453.37858546957364 "$node_(48) setdest 84381 21353 20.0" 
$ns at 647.032462535895 "$node_(48) setdest 111517 33091 11.0" 
$ns at 721.9165876137814 "$node_(48) setdest 223294 242 3.0" 
$ns at 779.5284382157049 "$node_(48) setdest 224877 41815 3.0" 
$ns at 813.3631626703736 "$node_(48) setdest 88453 72909 5.0" 
$ns at 863.8432719557159 "$node_(48) setdest 261797 61820 14.0" 
$ns at 0.0 "$node_(49) setdest 981 1889 16.0" 
$ns at 71.7811867119247 "$node_(49) setdest 21560 22651 18.0" 
$ns at 168.0644721611897 "$node_(49) setdest 132643 2109 15.0" 
$ns at 320.73859671883685 "$node_(49) setdest 90532 26082 4.0" 
$ns at 378.8400427066374 "$node_(49) setdest 132220 61875 7.0" 
$ns at 446.06571865211663 "$node_(49) setdest 12861 56363 7.0" 
$ns at 477.58524016507545 "$node_(49) setdest 137849 621 15.0" 
$ns at 530.9252173277965 "$node_(49) setdest 123557 42679 6.0" 
$ns at 614.5686494188349 "$node_(49) setdest 193099 45685 6.0" 
$ns at 663.0939827891154 "$node_(49) setdest 73387 43119 2.0" 
$ns at 707.4175703023992 "$node_(49) setdest 147742 37575 18.0" 
$ns at 844.5732452761275 "$node_(49) setdest 38108 10361 9.0" 
$ns at 0.0 "$node_(50) setdest 11865 26096 17.0" 
$ns at 148.7091602052902 "$node_(50) setdest 50240 26497 11.0" 
$ns at 227.55872226141742 "$node_(50) setdest 122118 36579 12.0" 
$ns at 272.77501351348957 "$node_(50) setdest 53085 51018 1.0" 
$ns at 309.2734865983537 "$node_(50) setdest 98892 53069 4.0" 
$ns at 360.93603296892184 "$node_(50) setdest 74541 37430 14.0" 
$ns at 404.98246735477363 "$node_(50) setdest 57788 27518 7.0" 
$ns at 493.40687601281513 "$node_(50) setdest 24953 23448 7.0" 
$ns at 532.8910584105503 "$node_(50) setdest 52953 26072 6.0" 
$ns at 586.2403827170632 "$node_(50) setdest 132629 64639 5.0" 
$ns at 636.9809619884911 "$node_(50) setdest 52794 28409 6.0" 
$ns at 678.6721221373886 "$node_(50) setdest 86412 65162 17.0" 
$ns at 768.9843767727768 "$node_(50) setdest 94904 9253 15.0" 
$ns at 0.0 "$node_(51) setdest 20629 11695 1.0" 
$ns at 37.79478042818145 "$node_(51) setdest 546 16094 11.0" 
$ns at 165.83902956096816 "$node_(51) setdest 17005 25400 3.0" 
$ns at 213.3957903473326 "$node_(51) setdest 425 4802 3.0" 
$ns at 245.80980248503184 "$node_(51) setdest 19392 11299 18.0" 
$ns at 360.39609153696875 "$node_(51) setdest 70680 23899 10.0" 
$ns at 455.54783586163285 "$node_(51) setdest 89825 57192 12.0" 
$ns at 488.9047629254923 "$node_(51) setdest 58097 17784 7.0" 
$ns at 527.0585510174695 "$node_(51) setdest 66448 61870 19.0" 
$ns at 701.7440608623054 "$node_(51) setdest 231517 8994 8.0" 
$ns at 779.9046883258688 "$node_(51) setdest 28877 21565 12.0" 
$ns at 0.0 "$node_(52) setdest 55668 27898 9.0" 
$ns at 108.9445268448889 "$node_(52) setdest 12099 4249 1.0" 
$ns at 143.34432463448377 "$node_(52) setdest 94581 4868 9.0" 
$ns at 231.23753735625758 "$node_(52) setdest 13205 17052 4.0" 
$ns at 286.156258227804 "$node_(52) setdest 122003 17349 3.0" 
$ns at 316.50083027160264 "$node_(52) setdest 4620 10099 13.0" 
$ns at 373.37361205412 "$node_(52) setdest 93773 13095 8.0" 
$ns at 430.9033044191576 "$node_(52) setdest 8098 31722 15.0" 
$ns at 539.8476393627768 "$node_(52) setdest 27817 56262 14.0" 
$ns at 693.7630855707894 "$node_(52) setdest 222641 22334 10.0" 
$ns at 771.6000397039058 "$node_(52) setdest 27904 72358 15.0" 
$ns at 0.0 "$node_(53) setdest 4502 29747 13.0" 
$ns at 77.90719859334692 "$node_(53) setdest 58674 12412 10.0" 
$ns at 202.06705903083204 "$node_(53) setdest 94334 5673 15.0" 
$ns at 244.2415567425839 "$node_(53) setdest 62959 8040 3.0" 
$ns at 284.6020073240722 "$node_(53) setdest 158308 13530 10.0" 
$ns at 351.88699908111084 "$node_(53) setdest 115263 24058 8.0" 
$ns at 448.54224502138607 "$node_(53) setdest 18666 32146 8.0" 
$ns at 505.71325165658004 "$node_(53) setdest 164040 53030 13.0" 
$ns at 594.0448493635162 "$node_(53) setdest 167084 50626 14.0" 
$ns at 674.3644911628239 "$node_(53) setdest 194727 46486 19.0" 
$ns at 860.3738511520353 "$node_(53) setdest 30813 20856 8.0" 
$ns at 895.1713151581151 "$node_(53) setdest 67717 80516 19.0" 
$ns at 0.0 "$node_(54) setdest 19476 12173 19.0" 
$ns at 51.53892710631131 "$node_(54) setdest 93826 581 3.0" 
$ns at 109.89955260196379 "$node_(54) setdest 77076 11448 13.0" 
$ns at 257.91394327425536 "$node_(54) setdest 22101 22350 20.0" 
$ns at 335.90150958670097 "$node_(54) setdest 34788 16235 6.0" 
$ns at 389.74356117440266 "$node_(54) setdest 168788 57580 4.0" 
$ns at 438.3090257533245 "$node_(54) setdest 31823 59212 19.0" 
$ns at 597.6287556562738 "$node_(54) setdest 117080 7871 16.0" 
$ns at 770.8053686105784 "$node_(54) setdest 244862 30874 11.0" 
$ns at 812.7813458115603 "$node_(54) setdest 177577 54542 13.0" 
$ns at 850.932177278834 "$node_(54) setdest 207412 71807 9.0" 
$ns at 0.0 "$node_(55) setdest 56048 6966 2.0" 
$ns at 32.80883042375854 "$node_(55) setdest 38344 12437 15.0" 
$ns at 75.06399898637387 "$node_(55) setdest 44795 27912 13.0" 
$ns at 148.1946735000493 "$node_(55) setdest 79366 669 12.0" 
$ns at 267.75733698368265 "$node_(55) setdest 162363 53817 9.0" 
$ns at 337.01158452105915 "$node_(55) setdest 130329 46166 15.0" 
$ns at 371.8513763298595 "$node_(55) setdest 16318 31116 12.0" 
$ns at 403.71587645625016 "$node_(55) setdest 186683 22230 8.0" 
$ns at 455.17166603393173 "$node_(55) setdest 62056 60870 9.0" 
$ns at 560.6549688937786 "$node_(55) setdest 77838 46744 17.0" 
$ns at 616.2050117342988 "$node_(55) setdest 37028 59138 18.0" 
$ns at 741.4408573447591 "$node_(55) setdest 90087 27251 13.0" 
$ns at 898.7597960011831 "$node_(55) setdest 180421 5656 19.0" 
$ns at 0.0 "$node_(56) setdest 11733 28176 16.0" 
$ns at 163.45522384742634 "$node_(56) setdest 94859 27206 19.0" 
$ns at 240.09456113689868 "$node_(56) setdest 70680 17895 6.0" 
$ns at 313.937792010062 "$node_(56) setdest 141459 39574 11.0" 
$ns at 424.82380196702127 "$node_(56) setdest 157929 22722 9.0" 
$ns at 461.1546696946907 "$node_(56) setdest 52266 35590 12.0" 
$ns at 497.421244030781 "$node_(56) setdest 143662 48811 8.0" 
$ns at 601.3629047180422 "$node_(56) setdest 17482 22615 8.0" 
$ns at 650.1180071480015 "$node_(56) setdest 1046 5278 19.0" 
$ns at 862.2148569381947 "$node_(56) setdest 31298 82949 8.0" 
$ns at 0.0 "$node_(57) setdest 59606 24904 20.0" 
$ns at 39.47400781945107 "$node_(57) setdest 34293 20501 13.0" 
$ns at 86.06253228473818 "$node_(57) setdest 37413 23833 18.0" 
$ns at 274.3169320912332 "$node_(57) setdest 77932 41404 13.0" 
$ns at 341.42677568441457 "$node_(57) setdest 21612 8663 20.0" 
$ns at 391.6832288699327 "$node_(57) setdest 164164 25402 12.0" 
$ns at 445.03983581238333 "$node_(57) setdest 163745 373 11.0" 
$ns at 563.9797103952833 "$node_(57) setdest 107834 8641 3.0" 
$ns at 619.235753914542 "$node_(57) setdest 227118 48341 12.0" 
$ns at 700.1569056319777 "$node_(57) setdest 132527 76352 17.0" 
$ns at 839.650631677509 "$node_(57) setdest 85464 60634 5.0" 
$ns at 883.4082179436269 "$node_(57) setdest 17653 15405 11.0" 
$ns at 0.0 "$node_(58) setdest 38102 13464 1.0" 
$ns at 34.096411618843256 "$node_(58) setdest 67316 16322 9.0" 
$ns at 92.90839654378502 "$node_(58) setdest 20098 6395 18.0" 
$ns at 206.24743339990846 "$node_(58) setdest 15709 19509 16.0" 
$ns at 275.702811016611 "$node_(58) setdest 48101 20111 16.0" 
$ns at 404.46004030346546 "$node_(58) setdest 44753 28642 3.0" 
$ns at 462.3340013802469 "$node_(58) setdest 17341 14807 10.0" 
$ns at 588.16668703483 "$node_(58) setdest 2701 73146 18.0" 
$ns at 634.8215510995511 "$node_(58) setdest 162568 42043 15.0" 
$ns at 781.9542009259051 "$node_(58) setdest 100033 614 7.0" 
$ns at 866.9427093758197 "$node_(58) setdest 174532 87962 18.0" 
$ns at 0.0 "$node_(59) setdest 54395 30317 14.0" 
$ns at 169.8717705748972 "$node_(59) setdest 18829 6546 9.0" 
$ns at 218.71323488338868 "$node_(59) setdest 30299 15697 10.0" 
$ns at 306.4662368911608 "$node_(59) setdest 159448 13653 15.0" 
$ns at 369.68043187524677 "$node_(59) setdest 115085 37908 7.0" 
$ns at 424.1291301488012 "$node_(59) setdest 40226 54540 1.0" 
$ns at 454.9508864166966 "$node_(59) setdest 13857 42359 17.0" 
$ns at 595.7822022368459 "$node_(59) setdest 28248 61372 4.0" 
$ns at 662.5547251878619 "$node_(59) setdest 155962 78401 9.0" 
$ns at 753.6122678255896 "$node_(59) setdest 173 30280 14.0" 
$ns at 803.2180301080188 "$node_(59) setdest 20831 50514 19.0" 
$ns at 893.8307889284448 "$node_(59) setdest 257554 36676 3.0" 
$ns at 0.0 "$node_(60) setdest 22344 1380 17.0" 
$ns at 102.4332300029783 "$node_(60) setdest 75186 7633 1.0" 
$ns at 135.1294917594244 "$node_(60) setdest 3993 23030 10.0" 
$ns at 232.768712955139 "$node_(60) setdest 55793 31109 10.0" 
$ns at 282.38557705268204 "$node_(60) setdest 123495 27341 10.0" 
$ns at 358.1244139752648 "$node_(60) setdest 111187 24859 18.0" 
$ns at 475.0666241549389 "$node_(60) setdest 91982 64290 10.0" 
$ns at 550.3529757108477 "$node_(60) setdest 196299 11886 20.0" 
$ns at 763.5975431400698 "$node_(60) setdest 109980 76595 14.0" 
$ns at 0.0 "$node_(61) setdest 85773 15514 4.0" 
$ns at 61.66459070312944 "$node_(61) setdest 42808 4647 4.0" 
$ns at 106.52522495263997 "$node_(61) setdest 87919 4646 3.0" 
$ns at 148.7937283767697 "$node_(61) setdest 77565 17761 6.0" 
$ns at 207.26788196165236 "$node_(61) setdest 54754 40564 1.0" 
$ns at 242.01433825026464 "$node_(61) setdest 63372 12885 10.0" 
$ns at 325.26068064394394 "$node_(61) setdest 101640 9750 9.0" 
$ns at 419.4999203772739 "$node_(61) setdest 10119 52727 9.0" 
$ns at 520.1200819741199 "$node_(61) setdest 172153 5286 19.0" 
$ns at 596.1206094495251 "$node_(61) setdest 100554 60475 9.0" 
$ns at 654.4795554148182 "$node_(61) setdest 164489 83593 2.0" 
$ns at 694.4612926544349 "$node_(61) setdest 237799 83555 7.0" 
$ns at 756.4078810265139 "$node_(61) setdest 159745 85020 11.0" 
$ns at 873.56329431915 "$node_(61) setdest 169668 15707 19.0" 
$ns at 0.0 "$node_(62) setdest 9836 1795 11.0" 
$ns at 113.00467073492175 "$node_(62) setdest 3631 24751 11.0" 
$ns at 169.1083565158737 "$node_(62) setdest 3166 2817 20.0" 
$ns at 251.9045438272762 "$node_(62) setdest 76722 45729 3.0" 
$ns at 303.19362906117533 "$node_(62) setdest 76446 42031 14.0" 
$ns at 421.12189101972456 "$node_(62) setdest 133635 3868 20.0" 
$ns at 568.9537493726073 "$node_(62) setdest 223108 49708 1.0" 
$ns at 599.7811534235668 "$node_(62) setdest 136053 26905 18.0" 
$ns at 786.4577590571622 "$node_(62) setdest 223031 11186 10.0" 
$ns at 0.0 "$node_(63) setdest 92190 17875 14.0" 
$ns at 113.42192056092236 "$node_(63) setdest 93510 10398 2.0" 
$ns at 157.46865846569932 "$node_(63) setdest 130582 6748 9.0" 
$ns at 204.7400002624612 "$node_(63) setdest 78818 6331 7.0" 
$ns at 279.7652488250453 "$node_(63) setdest 81862 2490 15.0" 
$ns at 405.9506425539443 "$node_(63) setdest 60018 61477 8.0" 
$ns at 495.1697499731769 "$node_(63) setdest 97784 60961 14.0" 
$ns at 548.5827377992473 "$node_(63) setdest 36231 43704 19.0" 
$ns at 659.4895433535311 "$node_(63) setdest 58182 32799 1.0" 
$ns at 693.0504107513506 "$node_(63) setdest 5537 33 11.0" 
$ns at 723.9115183184443 "$node_(63) setdest 39919 68000 19.0" 
$ns at 0.0 "$node_(64) setdest 35614 23690 17.0" 
$ns at 164.91302657119797 "$node_(64) setdest 33086 9503 14.0" 
$ns at 241.81272586187788 "$node_(64) setdest 6266 39419 9.0" 
$ns at 355.97299603239924 "$node_(64) setdest 60458 18549 1.0" 
$ns at 392.0313232103643 "$node_(64) setdest 134847 3708 17.0" 
$ns at 472.3147034598783 "$node_(64) setdest 53732 25907 14.0" 
$ns at 519.4679261617503 "$node_(64) setdest 112062 11372 9.0" 
$ns at 629.5658112150404 "$node_(64) setdest 27340 270 2.0" 
$ns at 674.4775088469952 "$node_(64) setdest 77699 14033 8.0" 
$ns at 760.1397552834292 "$node_(64) setdest 76720 85563 10.0" 
$ns at 887.0360403759214 "$node_(64) setdest 246919 52203 6.0" 
$ns at 0.0 "$node_(65) setdest 82803 6646 17.0" 
$ns at 34.879019716295886 "$node_(65) setdest 84194 28299 6.0" 
$ns at 114.06327361363472 "$node_(65) setdest 6103 8803 19.0" 
$ns at 306.63942113341284 "$node_(65) setdest 67945 43717 15.0" 
$ns at 369.71330485390564 "$node_(65) setdest 33702 7059 1.0" 
$ns at 400.1943789736179 "$node_(65) setdest 47914 11885 10.0" 
$ns at 485.15642466498184 "$node_(65) setdest 112949 15877 16.0" 
$ns at 561.5322808314047 "$node_(65) setdest 37038 10936 8.0" 
$ns at 624.9642462277689 "$node_(65) setdest 108253 70451 17.0" 
$ns at 806.2389777865723 "$node_(65) setdest 232367 34704 19.0" 
$ns at 0.0 "$node_(66) setdest 6854 20511 19.0" 
$ns at 100.10602010110998 "$node_(66) setdest 75231 182 19.0" 
$ns at 165.55949678332416 "$node_(66) setdest 67222 3913 6.0" 
$ns at 211.74266674032003 "$node_(66) setdest 127974 14572 10.0" 
$ns at 302.1598756001015 "$node_(66) setdest 146832 10095 6.0" 
$ns at 369.03858896879103 "$node_(66) setdest 143776 18387 14.0" 
$ns at 494.3899794954213 "$node_(66) setdest 61881 28073 15.0" 
$ns at 627.8000701525049 "$node_(66) setdest 155501 58079 2.0" 
$ns at 676.457625385571 "$node_(66) setdest 25043 1871 10.0" 
$ns at 714.0569962434811 "$node_(66) setdest 233543 36176 15.0" 
$ns at 848.2082116123593 "$node_(66) setdest 250150 4467 2.0" 
$ns at 880.4517015491297 "$node_(66) setdest 215988 52413 20.0" 
$ns at 0.0 "$node_(67) setdest 88126 4563 7.0" 
$ns at 44.187653070948215 "$node_(67) setdest 4482 16387 19.0" 
$ns at 119.56418914557219 "$node_(67) setdest 82511 19562 5.0" 
$ns at 182.47083629499588 "$node_(67) setdest 74871 23727 18.0" 
$ns at 309.9486149358444 "$node_(67) setdest 110284 28114 5.0" 
$ns at 389.31657536458715 "$node_(67) setdest 81649 62137 1.0" 
$ns at 419.5358392548775 "$node_(67) setdest 18301 9011 13.0" 
$ns at 555.9969782833108 "$node_(67) setdest 196097 36701 15.0" 
$ns at 601.3333326031391 "$node_(67) setdest 176944 55928 11.0" 
$ns at 727.8799347624889 "$node_(67) setdest 129384 32133 8.0" 
$ns at 783.1618281369098 "$node_(67) setdest 206127 84262 5.0" 
$ns at 847.7655625633976 "$node_(67) setdest 177516 22950 16.0" 
$ns at 0.0 "$node_(68) setdest 52020 18897 17.0" 
$ns at 192.84693641188153 "$node_(68) setdest 91271 34267 10.0" 
$ns at 295.1493534447046 "$node_(68) setdest 122968 35049 3.0" 
$ns at 347.1911728867722 "$node_(68) setdest 1700 14156 15.0" 
$ns at 524.4886915391477 "$node_(68) setdest 50600 18615 19.0" 
$ns at 725.4723979543204 "$node_(68) setdest 219185 8232 13.0" 
$ns at 798.8219778395909 "$node_(68) setdest 155062 79459 14.0" 
$ns at 0.0 "$node_(69) setdest 81244 10058 3.0" 
$ns at 34.317858587148564 "$node_(69) setdest 49048 4987 2.0" 
$ns at 67.99385484124065 "$node_(69) setdest 51569 9485 11.0" 
$ns at 183.80461619410917 "$node_(69) setdest 49751 13628 4.0" 
$ns at 218.41035435387366 "$node_(69) setdest 87281 21710 11.0" 
$ns at 316.2274856164375 "$node_(69) setdest 56397 27978 18.0" 
$ns at 362.08697634687945 "$node_(69) setdest 70558 21894 20.0" 
$ns at 529.308271317306 "$node_(69) setdest 28818 7999 14.0" 
$ns at 590.5730485503152 "$node_(69) setdest 208424 8254 7.0" 
$ns at 639.7745160418945 "$node_(69) setdest 98252 60158 1.0" 
$ns at 679.2689199175366 "$node_(69) setdest 75658 79993 12.0" 
$ns at 710.1955394978091 "$node_(69) setdest 5887 83128 12.0" 
$ns at 762.5371181383972 "$node_(69) setdest 72996 66138 19.0" 
$ns at 837.7486671314138 "$node_(69) setdest 229498 46832 4.0" 
$ns at 875.4156483074562 "$node_(69) setdest 99424 32419 9.0" 
$ns at 0.0 "$node_(70) setdest 94769 20177 16.0" 
$ns at 150.00238438183294 "$node_(70) setdest 106671 18018 20.0" 
$ns at 229.24711267318557 "$node_(70) setdest 61369 12588 15.0" 
$ns at 352.9526122348155 "$node_(70) setdest 160394 41970 19.0" 
$ns at 517.0740439153525 "$node_(70) setdest 93611 36319 3.0" 
$ns at 560.6887431312803 "$node_(70) setdest 127483 50876 13.0" 
$ns at 613.1100493372924 "$node_(70) setdest 60972 65495 20.0" 
$ns at 745.6503413834187 "$node_(70) setdest 38581 21548 14.0" 
$ns at 813.154415308947 "$node_(70) setdest 44958 29738 8.0" 
$ns at 844.7418852832205 "$node_(70) setdest 120816 1317 3.0" 
$ns at 880.3130037619511 "$node_(70) setdest 186416 48087 4.0" 
$ns at 0.0 "$node_(71) setdest 11348 27131 19.0" 
$ns at 137.0454709990866 "$node_(71) setdest 36370 23058 16.0" 
$ns at 209.2244143635085 "$node_(71) setdest 77166 8426 8.0" 
$ns at 243.71576424098845 "$node_(71) setdest 123585 41343 11.0" 
$ns at 359.30018829671417 "$node_(71) setdest 189463 37454 20.0" 
$ns at 521.8730041473757 "$node_(71) setdest 12529 45586 18.0" 
$ns at 556.1196464787328 "$node_(71) setdest 122962 51458 8.0" 
$ns at 594.5457896885389 "$node_(71) setdest 203785 38162 9.0" 
$ns at 655.4147394943154 "$node_(71) setdest 204211 57016 12.0" 
$ns at 782.7391909113711 "$node_(71) setdest 62106 82094 6.0" 
$ns at 849.3534496450854 "$node_(71) setdest 99999 10043 7.0" 
$ns at 0.0 "$node_(72) setdest 44435 24702 19.0" 
$ns at 79.66126498598214 "$node_(72) setdest 46700 6415 1.0" 
$ns at 109.97515109107441 "$node_(72) setdest 69412 18448 7.0" 
$ns at 159.20502647757309 "$node_(72) setdest 79915 5641 9.0" 
$ns at 278.7591960543665 "$node_(72) setdest 74064 25756 14.0" 
$ns at 312.4546936385586 "$node_(72) setdest 49978 23743 5.0" 
$ns at 373.7069373718152 "$node_(72) setdest 159104 23863 13.0" 
$ns at 429.32366777853883 "$node_(72) setdest 121994 50365 15.0" 
$ns at 580.7691828478453 "$node_(72) setdest 112044 71894 17.0" 
$ns at 637.1690887677881 "$node_(72) setdest 23109 21438 12.0" 
$ns at 674.8789958932689 "$node_(72) setdest 89838 79415 1.0" 
$ns at 709.8178685495518 "$node_(72) setdest 123184 51428 11.0" 
$ns at 757.7491982062986 "$node_(72) setdest 228976 63873 6.0" 
$ns at 826.4095700391288 "$node_(72) setdest 227549 24195 16.0" 
$ns at 0.0 "$node_(73) setdest 59542 8903 2.0" 
$ns at 44.91400294817366 "$node_(73) setdest 73395 6673 10.0" 
$ns at 169.2605519246363 "$node_(73) setdest 52718 24099 3.0" 
$ns at 205.06125978079035 "$node_(73) setdest 131420 30287 4.0" 
$ns at 248.9155981473361 "$node_(73) setdest 127236 36496 17.0" 
$ns at 371.32832630477463 "$node_(73) setdest 182617 26694 20.0" 
$ns at 566.6061812572547 "$node_(73) setdest 11327 14100 8.0" 
$ns at 652.5875489290665 "$node_(73) setdest 6070 13089 15.0" 
$ns at 765.6787041973878 "$node_(73) setdest 252291 70420 6.0" 
$ns at 829.0183640034179 "$node_(73) setdest 24963 17178 12.0" 
$ns at 0.0 "$node_(74) setdest 61164 27399 1.0" 
$ns at 35.221703574379724 "$node_(74) setdest 5141 16408 16.0" 
$ns at 206.83324778172747 "$node_(74) setdest 43626 11753 6.0" 
$ns at 273.596752325074 "$node_(74) setdest 89645 44132 12.0" 
$ns at 417.858236649423 "$node_(74) setdest 59533 37296 1.0" 
$ns at 447.99281347517933 "$node_(74) setdest 80877 3972 17.0" 
$ns at 627.2734289856738 "$node_(74) setdest 147581 30264 18.0" 
$ns at 713.761355603276 "$node_(74) setdest 94102 79741 1.0" 
$ns at 747.3651961315388 "$node_(74) setdest 26659 76354 19.0" 
$ns at 0.0 "$node_(75) setdest 30794 31388 3.0" 
$ns at 56.65529800320814 "$node_(75) setdest 32805 11204 4.0" 
$ns at 112.69752166085323 "$node_(75) setdest 65610 3992 19.0" 
$ns at 208.82489473715088 "$node_(75) setdest 36791 31515 12.0" 
$ns at 295.35561082519285 "$node_(75) setdest 99394 22941 18.0" 
$ns at 459.2564811282584 "$node_(75) setdest 198717 37719 16.0" 
$ns at 513.9044101010574 "$node_(75) setdest 125911 59993 16.0" 
$ns at 678.9434212296519 "$node_(75) setdest 183699 29015 13.0" 
$ns at 798.137730948647 "$node_(75) setdest 117777 39447 19.0" 
$ns at 0.0 "$node_(76) setdest 35726 11801 11.0" 
$ns at 35.93081276798513 "$node_(76) setdest 14112 7426 6.0" 
$ns at 66.11696862685966 "$node_(76) setdest 18125 28161 7.0" 
$ns at 97.53864941617717 "$node_(76) setdest 24677 25673 12.0" 
$ns at 230.0485439833268 "$node_(76) setdest 71683 20544 16.0" 
$ns at 414.73031094264087 "$node_(76) setdest 176174 24394 10.0" 
$ns at 448.2534687867248 "$node_(76) setdest 89772 42689 5.0" 
$ns at 489.66844214760425 "$node_(76) setdest 108124 48343 17.0" 
$ns at 612.4504345204315 "$node_(76) setdest 3814 23334 7.0" 
$ns at 684.2203647761743 "$node_(76) setdest 148515 9304 5.0" 
$ns at 748.1604336030302 "$node_(76) setdest 124607 75329 9.0" 
$ns at 860.7630430380938 "$node_(76) setdest 183478 83827 1.0" 
$ns at 896.0379699191571 "$node_(76) setdest 249495 28713 16.0" 
$ns at 0.0 "$node_(77) setdest 1856 15451 8.0" 
$ns at 95.50874634897541 "$node_(77) setdest 41693 20828 17.0" 
$ns at 290.32472727763485 "$node_(77) setdest 29767 32423 19.0" 
$ns at 343.9883940836733 "$node_(77) setdest 11556 30166 4.0" 
$ns at 398.7686716656853 "$node_(77) setdest 95154 47509 9.0" 
$ns at 496.24016577247886 "$node_(77) setdest 123032 65139 16.0" 
$ns at 562.4607536909426 "$node_(77) setdest 105006 61873 1.0" 
$ns at 600.9663978738731 "$node_(77) setdest 8641 41509 6.0" 
$ns at 658.654811633884 "$node_(77) setdest 118352 796 19.0" 
$ns at 799.2189416707976 "$node_(77) setdest 83081 87985 3.0" 
$ns at 857.7972043475704 "$node_(77) setdest 254011 81802 5.0" 
$ns at 0.0 "$node_(78) setdest 73350 29917 11.0" 
$ns at 80.77423512810051 "$node_(78) setdest 28033 9627 8.0" 
$ns at 134.312953595835 "$node_(78) setdest 78241 27439 16.0" 
$ns at 254.23364622462586 "$node_(78) setdest 60295 8702 20.0" 
$ns at 300.7055275835148 "$node_(78) setdest 5034 21520 2.0" 
$ns at 350.5693316143657 "$node_(78) setdest 115588 31136 2.0" 
$ns at 399.1601328352696 "$node_(78) setdest 188328 11355 12.0" 
$ns at 443.0746232468056 "$node_(78) setdest 135853 22300 17.0" 
$ns at 606.1104822446856 "$node_(78) setdest 61167 73965 15.0" 
$ns at 658.014497591766 "$node_(78) setdest 177495 38664 18.0" 
$ns at 766.4399596554481 "$node_(78) setdest 239745 82836 10.0" 
$ns at 805.5313273930468 "$node_(78) setdest 174541 21346 19.0" 
$ns at 893.8704885961116 "$node_(78) setdest 118976 81306 1.0" 
$ns at 0.0 "$node_(79) setdest 45747 5847 9.0" 
$ns at 88.57066405400968 "$node_(79) setdest 51118 24914 11.0" 
$ns at 219.26725213354354 "$node_(79) setdest 84921 39567 14.0" 
$ns at 285.1050221608597 "$node_(79) setdest 50249 9307 19.0" 
$ns at 374.8190028077221 "$node_(79) setdest 78929 5988 5.0" 
$ns at 451.46370643587505 "$node_(79) setdest 56157 24631 16.0" 
$ns at 605.728974460181 "$node_(79) setdest 89528 51756 16.0" 
$ns at 689.712513270608 "$node_(79) setdest 129596 78272 7.0" 
$ns at 736.9682857201293 "$node_(79) setdest 30107 25272 1.0" 
$ns at 776.3127371071671 "$node_(79) setdest 80898 69907 14.0" 
$ns at 833.8234851181495 "$node_(79) setdest 38234 30637 10.0" 
$ns at 878.9490208201822 "$node_(79) setdest 71634 3594 9.0" 
$ns at 0.0 "$node_(80) setdest 87984 4407 1.0" 
$ns at 30.210452894210682 "$node_(80) setdest 1796 15675 9.0" 
$ns at 139.15664995108804 "$node_(80) setdest 19716 21714 15.0" 
$ns at 299.36990987410303 "$node_(80) setdest 130884 28180 2.0" 
$ns at 348.68047544085994 "$node_(80) setdest 5973 29472 15.0" 
$ns at 503.9112760516447 "$node_(80) setdest 73692 16546 19.0" 
$ns at 594.0205477256222 "$node_(80) setdest 71620 18236 16.0" 
$ns at 672.362657650163 "$node_(80) setdest 84602 71320 7.0" 
$ns at 710.5729676689217 "$node_(80) setdest 176378 61758 6.0" 
$ns at 770.7283432309907 "$node_(80) setdest 234676 11897 10.0" 
$ns at 869.9168057845543 "$node_(80) setdest 67274 53011 5.0" 
$ns at 0.0 "$node_(81) setdest 93544 15346 16.0" 
$ns at 122.35977632390521 "$node_(81) setdest 93434 26230 4.0" 
$ns at 191.87164367771342 "$node_(81) setdest 15861 10621 6.0" 
$ns at 252.82645005969366 "$node_(81) setdest 62400 45250 8.0" 
$ns at 362.6696114989365 "$node_(81) setdest 839 60889 2.0" 
$ns at 393.4276162881441 "$node_(81) setdest 102216 39544 7.0" 
$ns at 429.5879670457217 "$node_(81) setdest 90006 61509 13.0" 
$ns at 532.2201303574653 "$node_(81) setdest 71064 31422 17.0" 
$ns at 611.3041513340122 "$node_(81) setdest 9386 26410 3.0" 
$ns at 646.3747144410813 "$node_(81) setdest 223871 28472 1.0" 
$ns at 682.1362082886069 "$node_(81) setdest 85762 6076 1.0" 
$ns at 717.5550226847009 "$node_(81) setdest 153153 38132 19.0" 
$ns at 797.3983264830995 "$node_(81) setdest 209017 24844 16.0" 
$ns at 0.0 "$node_(82) setdest 18781 24187 14.0" 
$ns at 168.1280552486053 "$node_(82) setdest 123604 20922 11.0" 
$ns at 209.2592402066689 "$node_(82) setdest 55351 428 13.0" 
$ns at 350.7351560671551 "$node_(82) setdest 98149 21170 15.0" 
$ns at 473.86538207005066 "$node_(82) setdest 99478 60910 9.0" 
$ns at 552.9945665022535 "$node_(82) setdest 44757 48566 9.0" 
$ns at 629.6942950120049 "$node_(82) setdest 75132 9213 19.0" 
$ns at 732.0235094176202 "$node_(82) setdest 41623 82524 8.0" 
$ns at 794.4226179543173 "$node_(82) setdest 77372 21370 6.0" 
$ns at 869.2713359931836 "$node_(82) setdest 151548 76724 9.0" 
$ns at 0.0 "$node_(83) setdest 24527 30549 12.0" 
$ns at 70.9107522921771 "$node_(83) setdest 16624 26449 16.0" 
$ns at 167.32341653679123 "$node_(83) setdest 373 2246 8.0" 
$ns at 203.0656297600194 "$node_(83) setdest 94462 2872 7.0" 
$ns at 238.07077614455045 "$node_(83) setdest 31016 12930 19.0" 
$ns at 397.14701467498236 "$node_(83) setdest 168684 34210 6.0" 
$ns at 447.00249373074263 "$node_(83) setdest 74591 24334 16.0" 
$ns at 533.013876558582 "$node_(83) setdest 7823 32567 17.0" 
$ns at 625.5281639318508 "$node_(83) setdest 96126 27244 10.0" 
$ns at 744.8326050209532 "$node_(83) setdest 206359 78544 10.0" 
$ns at 844.4083416902301 "$node_(83) setdest 221410 41707 1.0" 
$ns at 877.1412685870656 "$node_(83) setdest 115005 66449 1.0" 
$ns at 0.0 "$node_(84) setdest 126 31425 12.0" 
$ns at 96.42419446895674 "$node_(84) setdest 34636 28108 1.0" 
$ns at 131.91396236319798 "$node_(84) setdest 42763 5778 14.0" 
$ns at 238.24812851629412 "$node_(84) setdest 72222 9723 3.0" 
$ns at 282.9634560320681 "$node_(84) setdest 61892 14504 15.0" 
$ns at 420.92995173025054 "$node_(84) setdest 78558 19876 6.0" 
$ns at 485.63407169798256 "$node_(84) setdest 203689 31650 13.0" 
$ns at 539.0802469939733 "$node_(84) setdest 74073 27267 16.0" 
$ns at 630.5335684006842 "$node_(84) setdest 17259 10796 15.0" 
$ns at 772.3860637638322 "$node_(84) setdest 114474 85329 8.0" 
$ns at 825.7504768696152 "$node_(84) setdest 103260 79965 15.0" 
$ns at 0.0 "$node_(85) setdest 35545 15395 6.0" 
$ns at 49.83243365802617 "$node_(85) setdest 4427 25744 19.0" 
$ns at 266.44720663958935 "$node_(85) setdest 66311 17587 15.0" 
$ns at 402.86863486991143 "$node_(85) setdest 85547 25326 19.0" 
$ns at 613.2159387456733 "$node_(85) setdest 9417 38548 3.0" 
$ns at 657.9645953456964 "$node_(85) setdest 183436 7277 2.0" 
$ns at 705.4407215287788 "$node_(85) setdest 74295 30805 17.0" 
$ns at 747.7774022824689 "$node_(85) setdest 246944 79342 13.0" 
$ns at 825.6440111216245 "$node_(85) setdest 199242 7899 1.0" 
$ns at 859.5982833913496 "$node_(85) setdest 111501 28529 3.0" 
$ns at 0.0 "$node_(86) setdest 32133 11382 4.0" 
$ns at 33.03908993163008 "$node_(86) setdest 81946 9873 1.0" 
$ns at 66.32077323046661 "$node_(86) setdest 7599 1145 12.0" 
$ns at 200.00800259636372 "$node_(86) setdest 54943 21334 4.0" 
$ns at 238.40021419854455 "$node_(86) setdest 108541 20237 17.0" 
$ns at 288.28948409849846 "$node_(86) setdest 5133 4459 3.0" 
$ns at 345.9390436346888 "$node_(86) setdest 125794 32667 4.0" 
$ns at 384.371142929534 "$node_(86) setdest 96825 48057 16.0" 
$ns at 479.0087103057389 "$node_(86) setdest 150929 33957 6.0" 
$ns at 512.9091302708537 "$node_(86) setdest 9354 36351 2.0" 
$ns at 550.380427470363 "$node_(86) setdest 164829 25501 17.0" 
$ns at 615.5395860220416 "$node_(86) setdest 63664 23616 6.0" 
$ns at 688.007019531531 "$node_(86) setdest 223006 37559 18.0" 
$ns at 727.0887592245539 "$node_(86) setdest 171969 60492 2.0" 
$ns at 764.1015478252391 "$node_(86) setdest 209481 79127 10.0" 
$ns at 825.8408255194638 "$node_(86) setdest 157112 42769 10.0" 
$ns at 884.95892215862 "$node_(86) setdest 15138 21172 1.0" 
$ns at 0.0 "$node_(87) setdest 11423 21937 11.0" 
$ns at 75.69855277045635 "$node_(87) setdest 70643 7724 15.0" 
$ns at 211.85309513362512 "$node_(87) setdest 4057 10986 10.0" 
$ns at 270.0932776069529 "$node_(87) setdest 44011 84 8.0" 
$ns at 366.5950296428019 "$node_(87) setdest 20554 40120 17.0" 
$ns at 417.8298891108341 "$node_(87) setdest 165872 58153 4.0" 
$ns at 468.5534694580154 "$node_(87) setdest 119990 8962 15.0" 
$ns at 592.4974769074965 "$node_(87) setdest 69547 61646 17.0" 
$ns at 718.8882417544218 "$node_(87) setdest 190668 13208 12.0" 
$ns at 781.7004856015392 "$node_(87) setdest 198230 54342 19.0" 
$ns at 0.0 "$node_(88) setdest 94326 7266 19.0" 
$ns at 94.0543885388118 "$node_(88) setdest 44101 28089 20.0" 
$ns at 311.165861593693 "$node_(88) setdest 57197 43596 6.0" 
$ns at 387.99302167730264 "$node_(88) setdest 126738 50859 5.0" 
$ns at 436.74399793968905 "$node_(88) setdest 139914 55010 18.0" 
$ns at 583.0206409024798 "$node_(88) setdest 82663 22636 1.0" 
$ns at 621.928954519882 "$node_(88) setdest 156138 26740 1.0" 
$ns at 659.1548212795227 "$node_(88) setdest 98305 73040 12.0" 
$ns at 788.6751306253968 "$node_(88) setdest 109816 23965 18.0" 
$ns at 0.0 "$node_(89) setdest 495 63 4.0" 
$ns at 61.67077402900683 "$node_(89) setdest 44217 17243 9.0" 
$ns at 92.59896651959664 "$node_(89) setdest 33715 2302 15.0" 
$ns at 266.0912684259671 "$node_(89) setdest 113751 45640 8.0" 
$ns at 313.05000343934023 "$node_(89) setdest 161008 23830 10.0" 
$ns at 375.85458139606726 "$node_(89) setdest 69334 37249 10.0" 
$ns at 426.7703674090425 "$node_(89) setdest 40183 2586 8.0" 
$ns at 483.66869415366705 "$node_(89) setdest 2748 37220 2.0" 
$ns at 530.9697864196424 "$node_(89) setdest 190097 41177 4.0" 
$ns at 579.5812943035794 "$node_(89) setdest 213393 74705 17.0" 
$ns at 610.5034176374454 "$node_(89) setdest 229524 18143 11.0" 
$ns at 732.3188250668924 "$node_(89) setdest 130190 67353 10.0" 
$ns at 808.7629927498441 "$node_(89) setdest 231551 32616 13.0" 
$ns at 0.0 "$node_(90) setdest 14358 4096 11.0" 
$ns at 119.8099943886971 "$node_(90) setdest 40527 26154 14.0" 
$ns at 257.28074476023255 "$node_(90) setdest 140516 35714 10.0" 
$ns at 371.71713786248466 "$node_(90) setdest 66412 44075 15.0" 
$ns at 490.66465563661444 "$node_(90) setdest 39205 36619 20.0" 
$ns at 529.7487153077269 "$node_(90) setdest 2141 40023 19.0" 
$ns at 622.7308425909782 "$node_(90) setdest 56844 14328 14.0" 
$ns at 754.2608479575042 "$node_(90) setdest 263489 67861 10.0" 
$ns at 851.7488758320522 "$node_(90) setdest 106985 33747 12.0" 
$ns at 0.0 "$node_(91) setdest 13913 2587 4.0" 
$ns at 62.173907735080086 "$node_(91) setdest 34629 11001 20.0" 
$ns at 116.70358859050825 "$node_(91) setdest 71923 30758 13.0" 
$ns at 220.51618731984564 "$node_(91) setdest 87179 42041 20.0" 
$ns at 318.40809689370224 "$node_(91) setdest 7840 8672 1.0" 
$ns at 348.5759459581515 "$node_(91) setdest 87055 10148 5.0" 
$ns at 411.13612987302326 "$node_(91) setdest 37629 11950 6.0" 
$ns at 469.87661864322536 "$node_(91) setdest 8329 30075 3.0" 
$ns at 513.574113371345 "$node_(91) setdest 163512 32433 8.0" 
$ns at 590.9248073062759 "$node_(91) setdest 155345 15329 15.0" 
$ns at 654.2923423852238 "$node_(91) setdest 229455 48327 5.0" 
$ns at 732.9558163785973 "$node_(91) setdest 183557 31233 12.0" 
$ns at 777.0010870986521 "$node_(91) setdest 252748 18601 18.0" 
$ns at 888.8910143531622 "$node_(91) setdest 163196 25100 15.0" 
$ns at 0.0 "$node_(92) setdest 10096 23004 18.0" 
$ns at 39.84236520640203 "$node_(92) setdest 30583 25676 16.0" 
$ns at 75.22222207653277 "$node_(92) setdest 61973 10549 19.0" 
$ns at 126.63225989380354 "$node_(92) setdest 14768 23478 10.0" 
$ns at 214.14057272882292 "$node_(92) setdest 65460 20217 4.0" 
$ns at 254.8682082151221 "$node_(92) setdest 42927 41363 9.0" 
$ns at 372.06375563220865 "$node_(92) setdest 6911 35557 8.0" 
$ns at 418.22199262815985 "$node_(92) setdest 91141 57448 9.0" 
$ns at 490.6629191105652 "$node_(92) setdest 28072 56789 20.0" 
$ns at 584.783287990298 "$node_(92) setdest 190530 41327 10.0" 
$ns at 664.9281820945433 "$node_(92) setdest 2955 81472 9.0" 
$ns at 767.6590361930872 "$node_(92) setdest 79998 71854 4.0" 
$ns at 829.617140760361 "$node_(92) setdest 200938 70675 12.0" 
$ns at 0.0 "$node_(93) setdest 10927 14436 7.0" 
$ns at 60.62475251371961 "$node_(93) setdest 67669 16217 15.0" 
$ns at 98.51924162094453 "$node_(93) setdest 33755 13237 6.0" 
$ns at 142.60903019403852 "$node_(93) setdest 83712 9744 1.0" 
$ns at 182.0219154689291 "$node_(93) setdest 91383 13738 1.0" 
$ns at 215.68074457002126 "$node_(93) setdest 11988 42778 9.0" 
$ns at 286.2325528921761 "$node_(93) setdest 117723 3243 19.0" 
$ns at 359.52906777863114 "$node_(93) setdest 102430 48779 1.0" 
$ns at 395.4776329916322 "$node_(93) setdest 17505 10679 2.0" 
$ns at 442.6470365107189 "$node_(93) setdest 34006 53130 20.0" 
$ns at 580.1352537703478 "$node_(93) setdest 80271 21271 11.0" 
$ns at 660.4859281889401 "$node_(93) setdest 186215 79853 19.0" 
$ns at 716.446021934615 "$node_(93) setdest 34519 6982 8.0" 
$ns at 811.623310666143 "$node_(93) setdest 151709 74996 14.0" 
$ns at 878.7955508856214 "$node_(93) setdest 133468 77858 2.0" 
$ns at 0.0 "$node_(94) setdest 47506 17120 13.0" 
$ns at 105.56610866957634 "$node_(94) setdest 4276 1339 10.0" 
$ns at 180.65018363979456 "$node_(94) setdest 67298 4760 1.0" 
$ns at 217.34839102942016 "$node_(94) setdest 54181 22491 11.0" 
$ns at 304.78908136362855 "$node_(94) setdest 118907 48202 10.0" 
$ns at 408.9363799319951 "$node_(94) setdest 48910 51163 19.0" 
$ns at 521.3059086925715 "$node_(94) setdest 45990 5242 10.0" 
$ns at 581.662053536498 "$node_(94) setdest 176965 27476 15.0" 
$ns at 691.6330522075625 "$node_(94) setdest 136046 37213 7.0" 
$ns at 755.627489705383 "$node_(94) setdest 69651 6560 10.0" 
$ns at 851.4408562845139 "$node_(94) setdest 240066 17965 10.0" 
$ns at 0.0 "$node_(95) setdest 49500 12442 13.0" 
$ns at 70.95887849879952 "$node_(95) setdest 53756 15992 9.0" 
$ns at 147.3242073960026 "$node_(95) setdest 90368 13886 15.0" 
$ns at 203.04724640519382 "$node_(95) setdest 111244 8281 14.0" 
$ns at 241.80501048399393 "$node_(95) setdest 64452 31832 3.0" 
$ns at 299.07677203904325 "$node_(95) setdest 93391 27671 6.0" 
$ns at 338.75236635227066 "$node_(95) setdest 13952 40643 12.0" 
$ns at 457.44917836717684 "$node_(95) setdest 54226 9367 9.0" 
$ns at 539.440895841707 "$node_(95) setdest 35743 31803 14.0" 
$ns at 587.8553224704507 "$node_(95) setdest 19688 49664 10.0" 
$ns at 687.9725298032495 "$node_(95) setdest 57602 16808 5.0" 
$ns at 745.8331259837221 "$node_(95) setdest 89815 14995 8.0" 
$ns at 804.6039625329007 "$node_(95) setdest 145974 71469 18.0" 
$ns at 887.8533742831371 "$node_(95) setdest 121383 14086 19.0" 
$ns at 0.0 "$node_(96) setdest 77161 28470 13.0" 
$ns at 109.1358333430155 "$node_(96) setdest 90197 2359 11.0" 
$ns at 141.11182481430203 "$node_(96) setdest 93360 18636 5.0" 
$ns at 212.52878669920915 "$node_(96) setdest 102657 37637 3.0" 
$ns at 267.62634907733104 "$node_(96) setdest 114686 5775 18.0" 
$ns at 327.24564175446005 "$node_(96) setdest 55720 11986 10.0" 
$ns at 402.575958879568 "$node_(96) setdest 14841 60497 19.0" 
$ns at 485.61200423120346 "$node_(96) setdest 54762 16186 15.0" 
$ns at 641.2120640805445 "$node_(96) setdest 188263 70426 17.0" 
$ns at 829.0924776773815 "$node_(96) setdest 228515 58923 11.0" 
$ns at 0.0 "$node_(97) setdest 68497 18769 13.0" 
$ns at 59.532904156442 "$node_(97) setdest 58562 451 16.0" 
$ns at 219.41243319178375 "$node_(97) setdest 43473 31787 12.0" 
$ns at 288.8234505237201 "$node_(97) setdest 90587 29600 15.0" 
$ns at 381.14768665828086 "$node_(97) setdest 2291 5197 19.0" 
$ns at 521.3470933322642 "$node_(97) setdest 151670 12069 18.0" 
$ns at 676.5998141148816 "$node_(97) setdest 224248 2250 14.0" 
$ns at 769.3987076044971 "$node_(97) setdest 166669 46381 11.0" 
$ns at 0.0 "$node_(98) setdest 41865 25554 16.0" 
$ns at 152.87546819400836 "$node_(98) setdest 36390 12287 2.0" 
$ns at 186.47133872192754 "$node_(98) setdest 58408 6017 11.0" 
$ns at 228.6415679928423 "$node_(98) setdest 124228 27872 2.0" 
$ns at 273.7146069013716 "$node_(98) setdest 147100 52413 19.0" 
$ns at 366.9999684512695 "$node_(98) setdest 178522 34114 9.0" 
$ns at 456.48131269095217 "$node_(98) setdest 204505 3266 17.0" 
$ns at 587.8624640470898 "$node_(98) setdest 58028 6473 6.0" 
$ns at 642.8867382740771 "$node_(98) setdest 220531 7211 13.0" 
$ns at 726.4752562890874 "$node_(98) setdest 81920 4472 20.0" 
$ns at 899.7215617300919 "$node_(98) setdest 261886 28323 6.0" 
$ns at 0.0 "$node_(99) setdest 67251 19236 19.0" 
$ns at 83.73023473968232 "$node_(99) setdest 91575 25934 6.0" 
$ns at 150.63233610064063 "$node_(99) setdest 55859 32575 9.0" 
$ns at 234.15132877896826 "$node_(99) setdest 118805 8152 8.0" 
$ns at 289.71300796596097 "$node_(99) setdest 138256 34147 1.0" 
$ns at 323.74886512156456 "$node_(99) setdest 80956 1275 11.0" 
$ns at 441.3416190783046 "$node_(99) setdest 180275 28593 3.0" 
$ns at 478.19686585688186 "$node_(99) setdest 2411 37618 4.0" 
$ns at 546.4634102283201 "$node_(99) setdest 184858 68395 4.0" 
$ns at 586.3663392834782 "$node_(99) setdest 108116 15057 16.0" 
$ns at 652.0144043417944 "$node_(99) setdest 52173 79432 13.0" 
$ns at 716.4299079585811 "$node_(99) setdest 154082 17606 5.0" 
$ns at 755.2128600130528 "$node_(99) setdest 174420 48453 18.0" 
$ns at 0.0 "$node_(100) setdest 94265 15124 2.0" 
$ns at 42.69580906522556 "$node_(100) setdest 97472 38018 11.0" 
$ns at 140.409777862172 "$node_(100) setdest 45829 4842 16.0" 
$ns at 325.75439798152394 "$node_(100) setdest 126762 23087 1.0" 
$ns at 362.6981712030215 "$node_(100) setdest 40007 60791 2.0" 
$ns at 406.73683650609917 "$node_(100) setdest 83791 29326 5.0" 
$ns at 438.17776352493763 "$node_(100) setdest 109580 53992 19.0" 
$ns at 596.1225008200306 "$node_(100) setdest 84890 71248 12.0" 
$ns at 681.7555605332012 "$node_(100) setdest 196857 53742 1.0" 
$ns at 715.493625085223 "$node_(100) setdest 189453 63680 13.0" 
$ns at 768.5673823669431 "$node_(100) setdest 57385 59300 19.0" 
$ns at 833.9038377353895 "$node_(100) setdest 17316 9932 1.0" 
$ns at 864.8375079895355 "$node_(100) setdest 109462 61337 5.0" 
$ns at 176.14810165038307 "$node_(101) setdest 41216 18806 9.0" 
$ns at 283.8335456087908 "$node_(101) setdest 106644 17031 4.0" 
$ns at 341.65206835742913 "$node_(101) setdest 157874 19472 16.0" 
$ns at 386.74014634791985 "$node_(101) setdest 189381 59410 5.0" 
$ns at 425.4864142236089 "$node_(101) setdest 30808 58034 10.0" 
$ns at 509.03044545882506 "$node_(101) setdest 183524 942 2.0" 
$ns at 543.2417026585857 "$node_(101) setdest 152707 13605 16.0" 
$ns at 592.3656493551823 "$node_(101) setdest 146585 62336 6.0" 
$ns at 627.0072879228348 "$node_(101) setdest 73378 53653 12.0" 
$ns at 678.3780743065607 "$node_(101) setdest 231184 65606 8.0" 
$ns at 748.6819688341435 "$node_(101) setdest 41440 76374 15.0" 
$ns at 878.490972997369 "$node_(101) setdest 236708 65839 5.0" 
$ns at 101.73314573317788 "$node_(102) setdest 55488 12322 14.0" 
$ns at 222.32082612328392 "$node_(102) setdest 120709 44083 4.0" 
$ns at 279.86225302387084 "$node_(102) setdest 37488 3429 5.0" 
$ns at 336.0979093573237 "$node_(102) setdest 65015 11946 12.0" 
$ns at 482.24923540663053 "$node_(102) setdest 208434 15208 3.0" 
$ns at 516.6800021527583 "$node_(102) setdest 30483 49935 19.0" 
$ns at 628.344621355612 "$node_(102) setdest 117698 21420 4.0" 
$ns at 696.206370454325 "$node_(102) setdest 114901 68405 5.0" 
$ns at 732.4743217636556 "$node_(102) setdest 196666 28909 18.0" 
$ns at 768.0068856812625 "$node_(102) setdest 250909 34106 13.0" 
$ns at 819.6245394717935 "$node_(102) setdest 43251 82416 6.0" 
$ns at 887.0582581349685 "$node_(102) setdest 98613 75601 18.0" 
$ns at 114.85607159631282 "$node_(103) setdest 88164 14684 7.0" 
$ns at 183.21872235515337 "$node_(103) setdest 39349 36781 12.0" 
$ns at 314.93087090956277 "$node_(103) setdest 118827 7274 2.0" 
$ns at 350.58918162628595 "$node_(103) setdest 48569 38747 17.0" 
$ns at 505.37033319083446 "$node_(103) setdest 3395 51127 17.0" 
$ns at 677.6746291639838 "$node_(103) setdest 88746 24807 6.0" 
$ns at 743.7706211290543 "$node_(103) setdest 187695 3806 12.0" 
$ns at 791.9861174318023 "$node_(103) setdest 124586 39031 6.0" 
$ns at 834.9275290055347 "$node_(103) setdest 38655 70820 1.0" 
$ns at 871.8522273104758 "$node_(103) setdest 91218 24302 1.0" 
$ns at 265.2016912517463 "$node_(104) setdest 7504 40480 5.0" 
$ns at 336.68768668116496 "$node_(104) setdest 139744 21383 10.0" 
$ns at 465.9228316545416 "$node_(104) setdest 115052 2593 1.0" 
$ns at 496.02201359814876 "$node_(104) setdest 10588 70180 19.0" 
$ns at 539.4382440697473 "$node_(104) setdest 182069 2548 8.0" 
$ns at 576.2423870737751 "$node_(104) setdest 95058 65375 6.0" 
$ns at 634.5121889327131 "$node_(104) setdest 54744 32179 7.0" 
$ns at 704.6969893084554 "$node_(104) setdest 103373 49730 19.0" 
$ns at 779.4514351904862 "$node_(104) setdest 163525 41330 4.0" 
$ns at 810.1273783570703 "$node_(104) setdest 114908 83804 6.0" 
$ns at 898.5958419285596 "$node_(104) setdest 186732 35304 5.0" 
$ns at 130.7926606686209 "$node_(105) setdest 62294 7589 4.0" 
$ns at 178.10658676626673 "$node_(105) setdest 37274 40532 19.0" 
$ns at 368.40988692167076 "$node_(105) setdest 35455 12948 7.0" 
$ns at 422.3333803159375 "$node_(105) setdest 176123 46029 16.0" 
$ns at 540.2292833828461 "$node_(105) setdest 203406 54564 2.0" 
$ns at 587.6711047643204 "$node_(105) setdest 152837 18756 11.0" 
$ns at 625.4735268399857 "$node_(105) setdest 25603 56750 2.0" 
$ns at 665.6329352737445 "$node_(105) setdest 185330 13877 3.0" 
$ns at 699.4906840329332 "$node_(105) setdest 24062 69767 11.0" 
$ns at 785.8953887468992 "$node_(105) setdest 13101 1724 10.0" 
$ns at 816.4200788700908 "$node_(105) setdest 33507 56842 10.0" 
$ns at 848.1447100128707 "$node_(105) setdest 7219 43419 13.0" 
$ns at 888.7626526994346 "$node_(105) setdest 48608 71938 7.0" 
$ns at 144.10374887353024 "$node_(106) setdest 35065 20614 2.0" 
$ns at 176.10375069685242 "$node_(106) setdest 41964 17244 4.0" 
$ns at 215.63705547144264 "$node_(106) setdest 39951 16010 14.0" 
$ns at 336.3613408720971 "$node_(106) setdest 164100 20519 5.0" 
$ns at 374.93632943506464 "$node_(106) setdest 180511 16386 18.0" 
$ns at 472.9214219577997 "$node_(106) setdest 186917 57421 19.0" 
$ns at 580.2990750916293 "$node_(106) setdest 95865 47702 10.0" 
$ns at 677.7663019188411 "$node_(106) setdest 212189 72684 15.0" 
$ns at 738.3455478776406 "$node_(106) setdest 193590 39268 12.0" 
$ns at 856.847332668124 "$node_(106) setdest 14079 45886 13.0" 
$ns at 205.08833490222528 "$node_(107) setdest 47055 247 4.0" 
$ns at 248.46223666308654 "$node_(107) setdest 120581 12753 8.0" 
$ns at 310.5623361153834 "$node_(107) setdest 152524 40168 10.0" 
$ns at 363.72204804845427 "$node_(107) setdest 89885 46802 2.0" 
$ns at 407.77290035658393 "$node_(107) setdest 7269 47228 20.0" 
$ns at 603.894907083758 "$node_(107) setdest 65142 50596 7.0" 
$ns at 697.2225502360272 "$node_(107) setdest 220927 51130 2.0" 
$ns at 728.8327637792518 "$node_(107) setdest 91243 52886 14.0" 
$ns at 837.7411790939918 "$node_(107) setdest 259404 39238 13.0" 
$ns at 135.1269342420452 "$node_(108) setdest 53253 6702 2.0" 
$ns at 166.9106201983219 "$node_(108) setdest 1915 31296 7.0" 
$ns at 204.03808912120653 "$node_(108) setdest 2143 34112 7.0" 
$ns at 265.5787247575479 "$node_(108) setdest 110657 56 16.0" 
$ns at 398.7873208489383 "$node_(108) setdest 17557 1313 15.0" 
$ns at 573.1864692950202 "$node_(108) setdest 178474 58467 3.0" 
$ns at 608.5587397600302 "$node_(108) setdest 139275 30451 7.0" 
$ns at 657.0483204895849 "$node_(108) setdest 234815 14940 20.0" 
$ns at 843.3365459635214 "$node_(108) setdest 248200 34929 1.0" 
$ns at 879.5896560345077 "$node_(108) setdest 261315 72687 18.0" 
$ns at 139.20699611948652 "$node_(109) setdest 67421 11964 3.0" 
$ns at 192.23657987618452 "$node_(109) setdest 126342 5713 1.0" 
$ns at 228.2711210750362 "$node_(109) setdest 113182 36678 16.0" 
$ns at 319.60019749003817 "$node_(109) setdest 140569 52312 3.0" 
$ns at 354.1230364802451 "$node_(109) setdest 153835 19845 6.0" 
$ns at 430.6208387110342 "$node_(109) setdest 106987 22831 7.0" 
$ns at 488.28620394760344 "$node_(109) setdest 41632 1335 2.0" 
$ns at 527.5787689797141 "$node_(109) setdest 155005 44655 18.0" 
$ns at 640.3908807133508 "$node_(109) setdest 159010 60999 6.0" 
$ns at 700.5460155155127 "$node_(109) setdest 213637 35381 1.0" 
$ns at 737.6985924220921 "$node_(109) setdest 105863 24095 1.0" 
$ns at 769.0467402794952 "$node_(109) setdest 246050 38337 17.0" 
$ns at 865.1554802838203 "$node_(109) setdest 119191 72114 11.0" 
$ns at 120.69566829378904 "$node_(110) setdest 58978 22515 18.0" 
$ns at 280.9048030830736 "$node_(110) setdest 17489 14493 1.0" 
$ns at 313.61750698580784 "$node_(110) setdest 136791 45394 6.0" 
$ns at 389.14773154030775 "$node_(110) setdest 156124 51333 16.0" 
$ns at 499.0712724165732 "$node_(110) setdest 68075 13866 15.0" 
$ns at 545.9121941608801 "$node_(110) setdest 145885 50566 1.0" 
$ns at 580.6383709709829 "$node_(110) setdest 103786 74467 6.0" 
$ns at 620.5289054886317 "$node_(110) setdest 178627 46491 4.0" 
$ns at 688.365642331341 "$node_(110) setdest 70874 32679 12.0" 
$ns at 789.8972380554071 "$node_(110) setdest 90923 14404 17.0" 
$ns at 132.0731535899767 "$node_(111) setdest 35323 29947 7.0" 
$ns at 189.15905266362654 "$node_(111) setdest 39718 39958 14.0" 
$ns at 245.99027469064174 "$node_(111) setdest 65235 20960 19.0" 
$ns at 447.4615334273028 "$node_(111) setdest 126678 35249 10.0" 
$ns at 492.6351980422261 "$node_(111) setdest 207181 42876 1.0" 
$ns at 525.2720555494571 "$node_(111) setdest 169298 47773 8.0" 
$ns at 567.4538496109408 "$node_(111) setdest 147804 15805 18.0" 
$ns at 644.932690261324 "$node_(111) setdest 166004 70135 15.0" 
$ns at 713.7239344851613 "$node_(111) setdest 117380 51837 16.0" 
$ns at 882.260690683663 "$node_(111) setdest 55449 23398 7.0" 
$ns at 197.28723336158902 "$node_(112) setdest 29768 44710 16.0" 
$ns at 248.40802169520504 "$node_(112) setdest 40565 16666 11.0" 
$ns at 365.93462143911233 "$node_(112) setdest 83395 13711 17.0" 
$ns at 400.348542075958 "$node_(112) setdest 109329 1509 2.0" 
$ns at 438.5558733680016 "$node_(112) setdest 130658 6744 4.0" 
$ns at 483.86149944204504 "$node_(112) setdest 54434 44553 2.0" 
$ns at 518.0643940399588 "$node_(112) setdest 49330 59478 13.0" 
$ns at 616.0770344919288 "$node_(112) setdest 24856 50942 6.0" 
$ns at 691.9164852527595 "$node_(112) setdest 2314 5263 2.0" 
$ns at 732.8697157554386 "$node_(112) setdest 195566 79077 13.0" 
$ns at 886.0198682809294 "$node_(112) setdest 160629 10698 19.0" 
$ns at 171.5198748020624 "$node_(113) setdest 92183 22482 3.0" 
$ns at 202.67010990803428 "$node_(113) setdest 126324 38745 8.0" 
$ns at 240.35351174944017 "$node_(113) setdest 31598 10234 16.0" 
$ns at 375.3238159054698 "$node_(113) setdest 169552 8789 7.0" 
$ns at 457.17926767322876 "$node_(113) setdest 171535 10759 7.0" 
$ns at 540.6478739336716 "$node_(113) setdest 37405 27118 20.0" 
$ns at 608.2004416751334 "$node_(113) setdest 179420 34541 8.0" 
$ns at 652.1010687781097 "$node_(113) setdest 193067 15037 1.0" 
$ns at 689.9479751460636 "$node_(113) setdest 79016 62056 3.0" 
$ns at 743.7149552650753 "$node_(113) setdest 238916 57619 18.0" 
$ns at 779.8798208411997 "$node_(113) setdest 134970 59419 7.0" 
$ns at 849.8087247048848 "$node_(113) setdest 58390 15928 12.0" 
$ns at 123.71592093112366 "$node_(114) setdest 86072 20446 8.0" 
$ns at 167.84528189753328 "$node_(114) setdest 67535 21670 9.0" 
$ns at 225.08344606703085 "$node_(114) setdest 128618 31744 11.0" 
$ns at 316.0194068882687 "$node_(114) setdest 93233 51032 18.0" 
$ns at 363.2862733806211 "$node_(114) setdest 88749 58256 3.0" 
$ns at 416.1682771115995 "$node_(114) setdest 94185 62107 14.0" 
$ns at 542.5254681579096 "$node_(114) setdest 178586 5005 12.0" 
$ns at 640.4683638150698 "$node_(114) setdest 148803 49773 11.0" 
$ns at 681.0121884870165 "$node_(114) setdest 180052 80277 20.0" 
$ns at 861.7158493484148 "$node_(114) setdest 105746 22987 16.0" 
$ns at 894.5619467786596 "$node_(114) setdest 174435 65406 19.0" 
$ns at 144.82894016127756 "$node_(115) setdest 77474 10959 11.0" 
$ns at 198.95145591264694 "$node_(115) setdest 35196 16589 3.0" 
$ns at 247.7955275295151 "$node_(115) setdest 108404 36162 6.0" 
$ns at 325.19945606932765 "$node_(115) setdest 114689 24390 8.0" 
$ns at 401.26800854336136 "$node_(115) setdest 160853 403 9.0" 
$ns at 467.74210315385653 "$node_(115) setdest 152276 59201 15.0" 
$ns at 575.2260542035006 "$node_(115) setdest 4026 22234 1.0" 
$ns at 609.1997337898275 "$node_(115) setdest 94989 50091 13.0" 
$ns at 735.6681597971696 "$node_(115) setdest 80158 10191 2.0" 
$ns at 780.8435120859091 "$node_(115) setdest 148984 76755 13.0" 
$ns at 877.5855423962364 "$node_(115) setdest 177713 42755 4.0" 
$ns at 107.40166897135515 "$node_(116) setdest 40316 28257 3.0" 
$ns at 140.38301174523002 "$node_(116) setdest 84511 13840 16.0" 
$ns at 324.5154211870544 "$node_(116) setdest 44366 30718 16.0" 
$ns at 382.49101312813707 "$node_(116) setdest 49709 44880 11.0" 
$ns at 475.0334064168304 "$node_(116) setdest 13153 4368 9.0" 
$ns at 538.100916455055 "$node_(116) setdest 184871 59478 2.0" 
$ns at 577.8976159336785 "$node_(116) setdest 10719 55523 19.0" 
$ns at 736.5837033626606 "$node_(116) setdest 97726 1137 13.0" 
$ns at 824.9397715305471 "$node_(116) setdest 151660 78014 17.0" 
$ns at 214.31008051900355 "$node_(117) setdest 102012 32394 4.0" 
$ns at 245.75093173997016 "$node_(117) setdest 30539 35350 3.0" 
$ns at 280.7021033074377 "$node_(117) setdest 105074 12122 8.0" 
$ns at 333.79677627044356 "$node_(117) setdest 73208 15051 18.0" 
$ns at 401.9493799766691 "$node_(117) setdest 188653 22418 17.0" 
$ns at 496.60292249112615 "$node_(117) setdest 88561 9540 12.0" 
$ns at 601.1618321291313 "$node_(117) setdest 149000 70631 4.0" 
$ns at 650.013700442069 "$node_(117) setdest 62535 22542 2.0" 
$ns at 691.3968754687304 "$node_(117) setdest 152758 45075 17.0" 
$ns at 858.7460415115486 "$node_(117) setdest 2679 72087 14.0" 
$ns at 107.40997694279028 "$node_(118) setdest 420 12749 7.0" 
$ns at 178.3472798585292 "$node_(118) setdest 116705 15502 6.0" 
$ns at 243.52212071523587 "$node_(118) setdest 93946 28376 19.0" 
$ns at 307.4866961408797 "$node_(118) setdest 121804 16519 4.0" 
$ns at 351.8838407077876 "$node_(118) setdest 71692 8858 7.0" 
$ns at 388.89563312391994 "$node_(118) setdest 167878 52867 17.0" 
$ns at 553.6917212677205 "$node_(118) setdest 132436 69373 9.0" 
$ns at 600.0015823297416 "$node_(118) setdest 130611 64027 6.0" 
$ns at 663.1004952536405 "$node_(118) setdest 14302 24353 20.0" 
$ns at 707.0002716139523 "$node_(118) setdest 12409 9482 9.0" 
$ns at 792.6606514911989 "$node_(118) setdest 121314 7885 1.0" 
$ns at 826.6943308136302 "$node_(118) setdest 8089 45780 15.0" 
$ns at 149.80603152717475 "$node_(119) setdest 9200 5375 19.0" 
$ns at 342.13611839355053 "$node_(119) setdest 50580 21509 9.0" 
$ns at 391.81066873346754 "$node_(119) setdest 38353 54993 16.0" 
$ns at 459.9272022950325 "$node_(119) setdest 151752 44198 18.0" 
$ns at 616.8686707420845 "$node_(119) setdest 8081 3545 12.0" 
$ns at 683.5200154178763 "$node_(119) setdest 47794 51408 16.0" 
$ns at 803.3888979810423 "$node_(119) setdest 49088 45161 15.0" 
$ns at 175.4347070790463 "$node_(120) setdest 118862 17477 1.0" 
$ns at 213.12967886315897 "$node_(120) setdest 87893 13730 14.0" 
$ns at 275.0659601221046 "$node_(120) setdest 135183 880 9.0" 
$ns at 348.47511684506765 "$node_(120) setdest 100980 7537 13.0" 
$ns at 379.7935357760395 "$node_(120) setdest 40457 39219 10.0" 
$ns at 491.41816634145437 "$node_(120) setdest 137566 52562 17.0" 
$ns at 571.4075014749858 "$node_(120) setdest 160501 3305 18.0" 
$ns at 641.9442930735008 "$node_(120) setdest 209518 59127 7.0" 
$ns at 699.7888837976418 "$node_(120) setdest 163297 46083 13.0" 
$ns at 827.4713022242855 "$node_(120) setdest 57146 7953 18.0" 
$ns at 164.71620320602688 "$node_(121) setdest 101294 9965 3.0" 
$ns at 201.23366647159042 "$node_(121) setdest 107913 28338 14.0" 
$ns at 237.12433187078253 "$node_(121) setdest 29446 7496 19.0" 
$ns at 292.4952845542002 "$node_(121) setdest 63779 40991 12.0" 
$ns at 328.648090208855 "$node_(121) setdest 108266 43913 1.0" 
$ns at 360.5245131730924 "$node_(121) setdest 6652 46217 4.0" 
$ns at 391.6564862611602 "$node_(121) setdest 41626 31093 13.0" 
$ns at 534.4345027304444 "$node_(121) setdest 66980 61804 16.0" 
$ns at 627.3320254117466 "$node_(121) setdest 5441 4908 6.0" 
$ns at 708.7867359616838 "$node_(121) setdest 86190 78861 9.0" 
$ns at 762.2231363467079 "$node_(121) setdest 176375 33719 14.0" 
$ns at 803.4564104536344 "$node_(121) setdest 143984 37392 7.0" 
$ns at 876.6182688746926 "$node_(121) setdest 212670 85929 11.0" 
$ns at 261.7056843056687 "$node_(122) setdest 118664 39939 1.0" 
$ns at 295.45357543915367 "$node_(122) setdest 40749 42326 11.0" 
$ns at 411.3410010897677 "$node_(122) setdest 108121 20909 1.0" 
$ns at 442.14271650621976 "$node_(122) setdest 130786 29095 5.0" 
$ns at 493.2265872431106 "$node_(122) setdest 52821 47171 17.0" 
$ns at 540.9887209822947 "$node_(122) setdest 183399 23711 12.0" 
$ns at 578.0915939813269 "$node_(122) setdest 110660 68870 4.0" 
$ns at 629.5331923288167 "$node_(122) setdest 199425 4339 18.0" 
$ns at 767.1497858458996 "$node_(122) setdest 213467 14351 3.0" 
$ns at 809.4769105414515 "$node_(122) setdest 125261 76381 17.0" 
$ns at 861.269752900889 "$node_(122) setdest 68506 6082 10.0" 
$ns at 120.80834475599003 "$node_(123) setdest 10888 7019 15.0" 
$ns at 184.09417087905132 "$node_(123) setdest 24983 35726 5.0" 
$ns at 261.11522879915776 "$node_(123) setdest 150041 49858 4.0" 
$ns at 295.8161446782503 "$node_(123) setdest 88321 6998 12.0" 
$ns at 379.49759575740813 "$node_(123) setdest 91553 58209 8.0" 
$ns at 426.4340941095311 "$node_(123) setdest 136416 24154 14.0" 
$ns at 567.3317435956678 "$node_(123) setdest 171354 69034 3.0" 
$ns at 598.4816458644796 "$node_(123) setdest 9534 53478 17.0" 
$ns at 738.877583711622 "$node_(123) setdest 80769 67743 10.0" 
$ns at 868.2934900720632 "$node_(123) setdest 103276 10333 15.0" 
$ns at 122.61601076871499 "$node_(124) setdest 61718 15779 12.0" 
$ns at 221.33860941037818 "$node_(124) setdest 67425 14099 19.0" 
$ns at 362.5929944403543 "$node_(124) setdest 92375 60325 7.0" 
$ns at 414.94558265853055 "$node_(124) setdest 50923 6920 12.0" 
$ns at 517.8427670560014 "$node_(124) setdest 161319 70041 12.0" 
$ns at 587.5678576058428 "$node_(124) setdest 189996 44690 10.0" 
$ns at 681.2604178660993 "$node_(124) setdest 118263 43133 9.0" 
$ns at 768.8261424889457 "$node_(124) setdest 116587 31291 10.0" 
$ns at 807.0076947900784 "$node_(124) setdest 18832 17020 13.0" 
$ns at 858.9344991744337 "$node_(124) setdest 35967 22300 2.0" 
$ns at 217.47551102622003 "$node_(125) setdest 96669 33939 7.0" 
$ns at 294.9596513565659 "$node_(125) setdest 25690 28507 19.0" 
$ns at 375.7409197269774 "$node_(125) setdest 144632 9253 16.0" 
$ns at 540.9347420478075 "$node_(125) setdest 203011 20523 8.0" 
$ns at 624.7789653139047 "$node_(125) setdest 58200 40160 13.0" 
$ns at 655.9112822315147 "$node_(125) setdest 30249 56941 3.0" 
$ns at 703.6782141268416 "$node_(125) setdest 226238 18327 4.0" 
$ns at 759.6415444316222 "$node_(125) setdest 175281 12934 14.0" 
$ns at 814.8035142755244 "$node_(125) setdest 263159 53506 5.0" 
$ns at 861.357764959483 "$node_(125) setdest 112628 1637 11.0" 
$ns at 899.0845141424026 "$node_(125) setdest 86644 83847 8.0" 
$ns at 180.63207183061698 "$node_(126) setdest 87112 30981 11.0" 
$ns at 247.28067214893923 "$node_(126) setdest 96451 2236 11.0" 
$ns at 356.4286708487047 "$node_(126) setdest 169008 63007 5.0" 
$ns at 388.3108586709476 "$node_(126) setdest 55301 32501 16.0" 
$ns at 436.6169120003573 "$node_(126) setdest 61877 37236 17.0" 
$ns at 623.2056758309525 "$node_(126) setdest 171340 42355 16.0" 
$ns at 717.793751338584 "$node_(126) setdest 186564 82476 14.0" 
$ns at 841.3191301971042 "$node_(126) setdest 100408 19495 15.0" 
$ns at 121.39054099285964 "$node_(127) setdest 70901 31275 8.0" 
$ns at 183.33597640800912 "$node_(127) setdest 33553 23270 19.0" 
$ns at 351.32615714684766 "$node_(127) setdest 17661 4955 12.0" 
$ns at 426.98747824271766 "$node_(127) setdest 62381 20132 6.0" 
$ns at 500.2139629505196 "$node_(127) setdest 15304 59195 7.0" 
$ns at 569.8731795913271 "$node_(127) setdest 215903 65404 2.0" 
$ns at 616.6894642565754 "$node_(127) setdest 51426 12041 13.0" 
$ns at 668.0790037780632 "$node_(127) setdest 236201 78771 1.0" 
$ns at 702.4918003759948 "$node_(127) setdest 115670 59008 1.0" 
$ns at 740.6428516994766 "$node_(127) setdest 193098 74987 6.0" 
$ns at 780.5616861587971 "$node_(127) setdest 109591 38076 17.0" 
$ns at 891.3921526455547 "$node_(127) setdest 92936 8745 11.0" 
$ns at 220.20013999122907 "$node_(128) setdest 28479 22426 12.0" 
$ns at 331.80807339948433 "$node_(128) setdest 141309 48404 3.0" 
$ns at 390.4821013264408 "$node_(128) setdest 140075 6554 11.0" 
$ns at 431.81725721800836 "$node_(128) setdest 189264 46592 11.0" 
$ns at 541.8680722515077 "$node_(128) setdest 93060 32828 13.0" 
$ns at 608.16408469501 "$node_(128) setdest 8162 48023 8.0" 
$ns at 645.8716034999107 "$node_(128) setdest 89873 54692 5.0" 
$ns at 720.7401145382626 "$node_(128) setdest 77594 982 14.0" 
$ns at 871.0693090476216 "$node_(128) setdest 186241 8573 3.0" 
$ns at 121.45184634429049 "$node_(129) setdest 41808 19277 17.0" 
$ns at 224.90232467910306 "$node_(129) setdest 50658 9461 14.0" 
$ns at 360.67479986944073 "$node_(129) setdest 110513 11531 13.0" 
$ns at 429.11265041221446 "$node_(129) setdest 120131 42652 20.0" 
$ns at 511.4728614895261 "$node_(129) setdest 160756 47163 14.0" 
$ns at 624.9123092868123 "$node_(129) setdest 117777 34625 8.0" 
$ns at 701.6411561639834 "$node_(129) setdest 66523 57664 11.0" 
$ns at 813.2864552646474 "$node_(129) setdest 48480 3606 11.0" 
$ns at 899.0532520970947 "$node_(129) setdest 64585 63541 6.0" 
$ns at 153.07935969012016 "$node_(130) setdest 25614 33109 1.0" 
$ns at 187.0864022260217 "$node_(130) setdest 90731 31722 15.0" 
$ns at 277.9379595493283 "$node_(130) setdest 124511 42381 5.0" 
$ns at 325.99500820025435 "$node_(130) setdest 12034 3175 14.0" 
$ns at 376.7999307438571 "$node_(130) setdest 33731 59396 4.0" 
$ns at 417.76571088396406 "$node_(130) setdest 145096 24052 2.0" 
$ns at 458.34195227211444 "$node_(130) setdest 29683 42279 16.0" 
$ns at 594.1095405546403 "$node_(130) setdest 137052 57039 9.0" 
$ns at 636.5374867001851 "$node_(130) setdest 232280 68377 4.0" 
$ns at 669.046687832079 "$node_(130) setdest 113211 27006 9.0" 
$ns at 762.6987502969484 "$node_(130) setdest 149162 36885 19.0" 
$ns at 197.88117711099105 "$node_(131) setdest 113985 7708 4.0" 
$ns at 247.28000987847517 "$node_(131) setdest 12328 16138 18.0" 
$ns at 395.13993041731044 "$node_(131) setdest 130530 50531 1.0" 
$ns at 431.5926197159371 "$node_(131) setdest 6669 519 19.0" 
$ns at 473.76381569663306 "$node_(131) setdest 181219 53409 9.0" 
$ns at 525.6731034788185 "$node_(131) setdest 13290 57549 1.0" 
$ns at 564.2793869443485 "$node_(131) setdest 48511 10652 16.0" 
$ns at 619.9955074741508 "$node_(131) setdest 2662 66868 18.0" 
$ns at 747.7227347520569 "$node_(131) setdest 34588 8311 10.0" 
$ns at 791.2243736626245 "$node_(131) setdest 161110 79995 2.0" 
$ns at 826.2534552902135 "$node_(131) setdest 15783 11951 7.0" 
$ns at 877.7659989122172 "$node_(131) setdest 233036 32421 2.0" 
$ns at 102.51393967512544 "$node_(132) setdest 30613 1990 3.0" 
$ns at 136.2008181673255 "$node_(132) setdest 2351 29359 4.0" 
$ns at 202.89760942569256 "$node_(132) setdest 84279 30184 10.0" 
$ns at 273.4995182187584 "$node_(132) setdest 44377 22615 7.0" 
$ns at 348.9961639095298 "$node_(132) setdest 151469 46014 8.0" 
$ns at 446.2490511545494 "$node_(132) setdest 22477 18365 4.0" 
$ns at 505.52604042642514 "$node_(132) setdest 17358 45140 3.0" 
$ns at 540.4083495279641 "$node_(132) setdest 137537 9637 15.0" 
$ns at 623.5776202002496 "$node_(132) setdest 124394 44571 14.0" 
$ns at 767.1363670938124 "$node_(132) setdest 68889 34806 14.0" 
$ns at 825.6831959473656 "$node_(132) setdest 116894 39711 18.0" 
$ns at 140.15843229068054 "$node_(133) setdest 70401 20598 13.0" 
$ns at 260.7354316655906 "$node_(133) setdest 62806 1563 1.0" 
$ns at 297.8637688721612 "$node_(133) setdest 120321 38962 17.0" 
$ns at 383.52933940788057 "$node_(133) setdest 101190 49071 16.0" 
$ns at 421.45175672539614 "$node_(133) setdest 8368 12565 10.0" 
$ns at 509.13415781630385 "$node_(133) setdest 20752 47614 8.0" 
$ns at 603.5210081803041 "$node_(133) setdest 25204 16238 11.0" 
$ns at 671.9017057765323 "$node_(133) setdest 53207 33772 9.0" 
$ns at 777.7285526188418 "$node_(133) setdest 102382 32871 15.0" 
$ns at 108.43167481378862 "$node_(134) setdest 62706 21355 9.0" 
$ns at 168.67856372321654 "$node_(134) setdest 129380 24682 13.0" 
$ns at 298.3066202862857 "$node_(134) setdest 99486 44430 14.0" 
$ns at 439.8860045458159 "$node_(134) setdest 80236 2238 8.0" 
$ns at 536.2953585541002 "$node_(134) setdest 194230 60456 10.0" 
$ns at 581.6437699942697 "$node_(134) setdest 83667 57718 3.0" 
$ns at 624.3517948268727 "$node_(134) setdest 205129 52965 19.0" 
$ns at 700.4077147438404 "$node_(134) setdest 185449 27425 18.0" 
$ns at 845.4025531102332 "$node_(134) setdest 70439 46971 13.0" 
$ns at 161.51208078796276 "$node_(135) setdest 95490 21384 7.0" 
$ns at 258.4658657929396 "$node_(135) setdest 4704 26655 4.0" 
$ns at 298.2924874204898 "$node_(135) setdest 123532 29250 14.0" 
$ns at 444.2415683204236 "$node_(135) setdest 104910 32528 4.0" 
$ns at 488.16991747620784 "$node_(135) setdest 62916 51068 12.0" 
$ns at 616.8215105684694 "$node_(135) setdest 139632 69035 2.0" 
$ns at 658.2055650715953 "$node_(135) setdest 64449 59393 5.0" 
$ns at 693.3069450786969 "$node_(135) setdest 56252 7433 13.0" 
$ns at 790.0249824381849 "$node_(135) setdest 95728 52057 8.0" 
$ns at 888.366138607584 "$node_(135) setdest 26876 35792 16.0" 
$ns at 176.6092255099031 "$node_(136) setdest 14232 30181 10.0" 
$ns at 251.83283354512236 "$node_(136) setdest 92455 31639 5.0" 
$ns at 285.428351531437 "$node_(136) setdest 56764 18618 6.0" 
$ns at 371.3302541130097 "$node_(136) setdest 130980 10494 19.0" 
$ns at 519.3662865123697 "$node_(136) setdest 197817 49470 8.0" 
$ns at 586.3518895049197 "$node_(136) setdest 170739 52437 16.0" 
$ns at 658.2364232623144 "$node_(136) setdest 22813 77144 2.0" 
$ns at 706.5863751353979 "$node_(136) setdest 165764 28080 5.0" 
$ns at 764.3868063008482 "$node_(136) setdest 255971 39008 3.0" 
$ns at 797.975939472238 "$node_(136) setdest 137600 74288 6.0" 
$ns at 885.969889742945 "$node_(136) setdest 135134 64060 1.0" 
$ns at 123.12166568009687 "$node_(137) setdest 93614 11080 8.0" 
$ns at 179.38647273339276 "$node_(137) setdest 73232 40671 1.0" 
$ns at 218.54821170787943 "$node_(137) setdest 93382 1405 3.0" 
$ns at 275.95173914623865 "$node_(137) setdest 143095 31797 8.0" 
$ns at 341.2449540941127 "$node_(137) setdest 155829 43854 20.0" 
$ns at 440.54218782128834 "$node_(137) setdest 55930 39961 16.0" 
$ns at 534.3132387032147 "$node_(137) setdest 24702 17109 10.0" 
$ns at 612.8691933354925 "$node_(137) setdest 212559 50163 17.0" 
$ns at 780.5252657500391 "$node_(137) setdest 266359 80106 13.0" 
$ns at 811.1187460434248 "$node_(137) setdest 206981 70013 11.0" 
$ns at 888.4515573771668 "$node_(137) setdest 37428 44841 6.0" 
$ns at 130.01576461041037 "$node_(138) setdest 6492 9586 1.0" 
$ns at 167.79428552190038 "$node_(138) setdest 15401 4489 15.0" 
$ns at 243.64839181486246 "$node_(138) setdest 48474 15225 2.0" 
$ns at 290.6797272270331 "$node_(138) setdest 79473 10729 4.0" 
$ns at 332.1626491600166 "$node_(138) setdest 133829 16847 8.0" 
$ns at 398.8204040507585 "$node_(138) setdest 90496 13169 1.0" 
$ns at 435.64274642621876 "$node_(138) setdest 153580 12449 16.0" 
$ns at 574.578082867212 "$node_(138) setdest 12988 591 7.0" 
$ns at 652.3488174258033 "$node_(138) setdest 246834 83332 14.0" 
$ns at 771.0164039436752 "$node_(138) setdest 114656 76134 12.0" 
$ns at 809.7617272124014 "$node_(138) setdest 204512 3292 7.0" 
$ns at 857.0734575821153 "$node_(138) setdest 255067 23229 9.0" 
$ns at 115.95265135341516 "$node_(139) setdest 20856 18857 8.0" 
$ns at 160.14835594108808 "$node_(139) setdest 87836 21397 10.0" 
$ns at 206.92011710231498 "$node_(139) setdest 74043 25466 16.0" 
$ns at 371.8974747725413 "$node_(139) setdest 128592 52620 11.0" 
$ns at 432.24849721018495 "$node_(139) setdest 1717 10274 1.0" 
$ns at 465.0782804204306 "$node_(139) setdest 173386 55943 10.0" 
$ns at 500.23599728018223 "$node_(139) setdest 185600 27078 1.0" 
$ns at 532.7432085073648 "$node_(139) setdest 12993 68405 2.0" 
$ns at 567.7715271264465 "$node_(139) setdest 120873 69485 1.0" 
$ns at 607.3832221024122 "$node_(139) setdest 10879 347 13.0" 
$ns at 648.2603526334302 "$node_(139) setdest 131958 755 12.0" 
$ns at 716.9128335796604 "$node_(139) setdest 105126 1268 12.0" 
$ns at 765.9725609785378 "$node_(139) setdest 166493 55221 9.0" 
$ns at 828.7911805842004 "$node_(139) setdest 136406 68434 2.0" 
$ns at 865.1440771998708 "$node_(139) setdest 236124 89021 17.0" 
$ns at 190.71556420513684 "$node_(140) setdest 110387 13518 3.0" 
$ns at 225.68213562971584 "$node_(140) setdest 94693 35199 14.0" 
$ns at 371.42196521440144 "$node_(140) setdest 120887 32923 20.0" 
$ns at 438.75357073935555 "$node_(140) setdest 29025 28138 13.0" 
$ns at 487.02584052797715 "$node_(140) setdest 162461 17846 14.0" 
$ns at 526.0906297223939 "$node_(140) setdest 185654 6756 1.0" 
$ns at 556.3901450407523 "$node_(140) setdest 89543 48498 6.0" 
$ns at 644.6247285938784 "$node_(140) setdest 89417 68805 16.0" 
$ns at 818.1438331740317 "$node_(140) setdest 72022 5876 20.0" 
$ns at 856.0087534133172 "$node_(140) setdest 99100 41300 3.0" 
$ns at 886.588744394343 "$node_(140) setdest 136280 33828 9.0" 
$ns at 202.11624923765035 "$node_(141) setdest 129138 23801 12.0" 
$ns at 320.1599815292866 "$node_(141) setdest 27335 19421 13.0" 
$ns at 419.19748792743957 "$node_(141) setdest 130553 52608 13.0" 
$ns at 511.5322675745813 "$node_(141) setdest 118204 47104 12.0" 
$ns at 646.5290109662876 "$node_(141) setdest 183526 41890 17.0" 
$ns at 808.3542079950315 "$node_(141) setdest 107318 48392 4.0" 
$ns at 845.8455196176336 "$node_(141) setdest 164668 77840 7.0" 
$ns at 880.1235853992924 "$node_(141) setdest 51765 20679 3.0" 
$ns at 108.60498365653721 "$node_(142) setdest 17212 16461 11.0" 
$ns at 188.55267785372808 "$node_(142) setdest 25864 4595 5.0" 
$ns at 233.04411978323566 "$node_(142) setdest 50293 26133 6.0" 
$ns at 307.66437408907336 "$node_(142) setdest 21469 8080 20.0" 
$ns at 515.2013475069126 "$node_(142) setdest 9516 55945 5.0" 
$ns at 560.780514726927 "$node_(142) setdest 184215 20990 10.0" 
$ns at 645.7411036645376 "$node_(142) setdest 63796 20028 18.0" 
$ns at 815.0497600027256 "$node_(142) setdest 3156 37660 11.0" 
$ns at 851.99526592318 "$node_(142) setdest 258603 39242 19.0" 
$ns at 140.78276469419455 "$node_(143) setdest 44652 1087 9.0" 
$ns at 249.069308063432 "$node_(143) setdest 130847 36608 14.0" 
$ns at 343.75637919703786 "$node_(143) setdest 33571 17579 18.0" 
$ns at 398.7121355518358 "$node_(143) setdest 62006 8806 4.0" 
$ns at 462.2331625686606 "$node_(143) setdest 117994 8712 1.0" 
$ns at 502.0172404297261 "$node_(143) setdest 51064 48999 7.0" 
$ns at 591.88730526146 "$node_(143) setdest 133176 5452 12.0" 
$ns at 709.8642642117111 "$node_(143) setdest 98796 38476 2.0" 
$ns at 757.5479442597374 "$node_(143) setdest 241210 44660 13.0" 
$ns at 844.9121949579466 "$node_(143) setdest 18296 44360 16.0" 
$ns at 125.2191269977736 "$node_(144) setdest 78150 23757 4.0" 
$ns at 183.01203329793154 "$node_(144) setdest 34354 12255 14.0" 
$ns at 274.5704544409263 "$node_(144) setdest 100387 30442 1.0" 
$ns at 307.74512350783596 "$node_(144) setdest 75057 43265 1.0" 
$ns at 346.37385056137566 "$node_(144) setdest 26670 7434 17.0" 
$ns at 504.82891735048315 "$node_(144) setdest 128866 22180 19.0" 
$ns at 568.1467348888359 "$node_(144) setdest 172331 59927 17.0" 
$ns at 674.2361300808061 "$node_(144) setdest 76311 38735 6.0" 
$ns at 724.2650108882195 "$node_(144) setdest 146297 39813 11.0" 
$ns at 798.5376891937021 "$node_(144) setdest 81121 2422 12.0" 
$ns at 877.2867243254653 "$node_(144) setdest 161557 23258 2.0" 
$ns at 113.15399556012397 "$node_(145) setdest 31249 13529 2.0" 
$ns at 157.322833543297 "$node_(145) setdest 21549 16940 2.0" 
$ns at 199.4851261660055 "$node_(145) setdest 118798 8724 11.0" 
$ns at 315.1875728683529 "$node_(145) setdest 32908 47781 4.0" 
$ns at 381.0143620148384 "$node_(145) setdest 86719 2688 7.0" 
$ns at 429.62374057726134 "$node_(145) setdest 102828 60711 11.0" 
$ns at 491.6771760138327 "$node_(145) setdest 172860 35735 11.0" 
$ns at 587.1386553120683 "$node_(145) setdest 227390 20950 8.0" 
$ns at 641.1375308094221 "$node_(145) setdest 114440 56499 6.0" 
$ns at 714.0386835567568 "$node_(145) setdest 138200 29516 13.0" 
$ns at 855.7151875000357 "$node_(145) setdest 187987 24443 2.0" 
$ns at 191.22004059653472 "$node_(146) setdest 7660 12091 18.0" 
$ns at 223.95304298418438 "$node_(146) setdest 101313 21726 16.0" 
$ns at 295.4911186015121 "$node_(146) setdest 22131 51382 12.0" 
$ns at 368.63313063045473 "$node_(146) setdest 166948 22960 16.0" 
$ns at 404.71585315815946 "$node_(146) setdest 115586 44476 19.0" 
$ns at 616.7847574174757 "$node_(146) setdest 36826 61088 3.0" 
$ns at 660.8563076059352 "$node_(146) setdest 43313 46686 2.0" 
$ns at 702.8731575937622 "$node_(146) setdest 193946 68872 19.0" 
$ns at 827.9406083491366 "$node_(146) setdest 92856 27078 1.0" 
$ns at 863.3814909386234 "$node_(146) setdest 117516 25090 8.0" 
$ns at 181.4676340545485 "$node_(147) setdest 95698 37850 19.0" 
$ns at 371.7081990983108 "$node_(147) setdest 52035 918 18.0" 
$ns at 470.0299531808067 "$node_(147) setdest 52474 38880 10.0" 
$ns at 521.1708574020046 "$node_(147) setdest 184625 14903 7.0" 
$ns at 568.0447169688631 "$node_(147) setdest 111242 22063 14.0" 
$ns at 681.1680897838529 "$node_(147) setdest 58447 59118 15.0" 
$ns at 753.3215938991998 "$node_(147) setdest 29510 78626 5.0" 
$ns at 791.6214708803449 "$node_(147) setdest 156023 62372 3.0" 
$ns at 847.1931419282021 "$node_(147) setdest 147280 77953 10.0" 
$ns at 881.8276522995366 "$node_(147) setdest 247276 13498 3.0" 
$ns at 124.5186874648671 "$node_(148) setdest 6970 26637 2.0" 
$ns at 167.597766197611 "$node_(148) setdest 11182 5022 5.0" 
$ns at 222.83710334723585 "$node_(148) setdest 78439 27118 17.0" 
$ns at 301.74416043276045 "$node_(148) setdest 70390 20069 8.0" 
$ns at 369.48578118237623 "$node_(148) setdest 10651 19350 14.0" 
$ns at 439.3461848527985 "$node_(148) setdest 96492 33707 19.0" 
$ns at 533.4062316274128 "$node_(148) setdest 171050 52085 5.0" 
$ns at 568.8719106084001 "$node_(148) setdest 70789 46991 15.0" 
$ns at 697.4598087315442 "$node_(148) setdest 76835 53006 16.0" 
$ns at 744.1154788481488 "$node_(148) setdest 140290 77224 2.0" 
$ns at 776.0309482637388 "$node_(148) setdest 70438 76220 2.0" 
$ns at 814.4589439932857 "$node_(148) setdest 230240 44018 18.0" 
$ns at 133.17954112213283 "$node_(149) setdest 4595 22927 18.0" 
$ns at 199.4357224066666 "$node_(149) setdest 129437 26833 8.0" 
$ns at 237.57959429278733 "$node_(149) setdest 105787 33545 15.0" 
$ns at 300.03828332114495 "$node_(149) setdest 100159 18009 10.0" 
$ns at 370.98989203364147 "$node_(149) setdest 165414 45667 11.0" 
$ns at 412.99853067042534 "$node_(149) setdest 67430 19517 4.0" 
$ns at 478.6568241700656 "$node_(149) setdest 23930 20049 12.0" 
$ns at 596.6932659759378 "$node_(149) setdest 60998 23269 16.0" 
$ns at 654.5272757907439 "$node_(149) setdest 104213 63084 9.0" 
$ns at 730.6101862973828 "$node_(149) setdest 9315 41893 11.0" 
$ns at 813.9704416121389 "$node_(149) setdest 63922 61918 19.0" 
$ns at 131.75810573138673 "$node_(150) setdest 82520 6192 11.0" 
$ns at 163.81627019241003 "$node_(150) setdest 30642 37402 13.0" 
$ns at 319.13534568375746 "$node_(150) setdest 28241 36960 4.0" 
$ns at 383.10492110253017 "$node_(150) setdest 61275 43373 14.0" 
$ns at 440.0005741625087 "$node_(150) setdest 157781 9316 12.0" 
$ns at 532.0064066690379 "$node_(150) setdest 56714 49372 15.0" 
$ns at 651.2538701440802 "$node_(150) setdest 87277 3324 3.0" 
$ns at 682.9801562716315 "$node_(150) setdest 83672 37463 3.0" 
$ns at 716.5235342244246 "$node_(150) setdest 246316 1598 16.0" 
$ns at 864.6809448799007 "$node_(150) setdest 177871 20955 2.0" 
$ns at 103.32168376563536 "$node_(151) setdest 4938 18840 2.0" 
$ns at 139.37917715891953 "$node_(151) setdest 30836 5925 10.0" 
$ns at 225.65575177341157 "$node_(151) setdest 86824 39133 9.0" 
$ns at 267.69078690237563 "$node_(151) setdest 125127 44392 16.0" 
$ns at 337.6024346488229 "$node_(151) setdest 150892 47853 13.0" 
$ns at 427.6781266624819 "$node_(151) setdest 115126 10871 18.0" 
$ns at 598.1254852984018 "$node_(151) setdest 93892 30086 16.0" 
$ns at 781.435909317064 "$node_(151) setdest 214587 1745 4.0" 
$ns at 831.0235027196929 "$node_(151) setdest 211710 15028 13.0" 
$ns at 111.87355940097522 "$node_(152) setdest 50951 10887 6.0" 
$ns at 198.40167161438794 "$node_(152) setdest 110767 41438 2.0" 
$ns at 229.38220107148902 "$node_(152) setdest 79657 41499 15.0" 
$ns at 305.5934567236272 "$node_(152) setdest 1075 30519 4.0" 
$ns at 363.9810809316938 "$node_(152) setdest 91050 55353 6.0" 
$ns at 419.9389047428738 "$node_(152) setdest 130216 47479 16.0" 
$ns at 558.4909416020878 "$node_(152) setdest 187022 20467 18.0" 
$ns at 760.9835117645903 "$node_(152) setdest 66238 33156 18.0" 
$ns at 118.55480791912149 "$node_(153) setdest 50306 8539 19.0" 
$ns at 231.5142129043113 "$node_(153) setdest 77172 9288 12.0" 
$ns at 284.48738999715533 "$node_(153) setdest 79977 31753 11.0" 
$ns at 365.16412766635835 "$node_(153) setdest 140587 21701 8.0" 
$ns at 398.7595304775155 "$node_(153) setdest 108595 26659 18.0" 
$ns at 566.3358597719388 "$node_(153) setdest 21705 60476 8.0" 
$ns at 627.6418000525479 "$node_(153) setdest 147172 58108 10.0" 
$ns at 741.1311623021426 "$node_(153) setdest 148707 14080 16.0" 
$ns at 780.5541441759112 "$node_(153) setdest 221519 52968 7.0" 
$ns at 825.1003693282441 "$node_(153) setdest 251846 33834 5.0" 
$ns at 895.4767606887887 "$node_(153) setdest 244851 81773 9.0" 
$ns at 143.54925131057774 "$node_(154) setdest 37564 30656 12.0" 
$ns at 174.29726899524923 "$node_(154) setdest 124873 33744 5.0" 
$ns at 251.56187332827307 "$node_(154) setdest 30657 19700 18.0" 
$ns at 366.69312193224084 "$node_(154) setdest 23570 47944 3.0" 
$ns at 413.5832586279341 "$node_(154) setdest 146344 19144 14.0" 
$ns at 547.6583113441814 "$node_(154) setdest 190125 69065 18.0" 
$ns at 698.6960794010362 "$node_(154) setdest 21284 70394 1.0" 
$ns at 733.0156503908053 "$node_(154) setdest 104890 544 9.0" 
$ns at 826.40254032507 "$node_(154) setdest 145368 88037 2.0" 
$ns at 873.6872854595783 "$node_(154) setdest 44794 65209 13.0" 
$ns at 142.63451865684488 "$node_(155) setdest 16286 14598 17.0" 
$ns at 314.7420885401509 "$node_(155) setdest 124067 31437 17.0" 
$ns at 490.62261259170543 "$node_(155) setdest 1888 32193 4.0" 
$ns at 555.9994674988668 "$node_(155) setdest 159776 26920 2.0" 
$ns at 601.5085065783162 "$node_(155) setdest 74808 37329 6.0" 
$ns at 658.7126543078988 "$node_(155) setdest 176712 56075 12.0" 
$ns at 727.9826173558122 "$node_(155) setdest 134479 62705 19.0" 
$ns at 209.3947721548957 "$node_(156) setdest 15436 20042 2.0" 
$ns at 257.216906227389 "$node_(156) setdest 9894 9969 16.0" 
$ns at 366.7684177391365 "$node_(156) setdest 67675 44357 3.0" 
$ns at 420.0768484749517 "$node_(156) setdest 113785 58837 1.0" 
$ns at 452.97206964211944 "$node_(156) setdest 74087 52457 6.0" 
$ns at 491.67403075918793 "$node_(156) setdest 120521 34955 13.0" 
$ns at 593.750936389603 "$node_(156) setdest 124097 37385 18.0" 
$ns at 697.175783365321 "$node_(156) setdest 161750 16796 19.0" 
$ns at 824.176919082593 "$node_(156) setdest 243067 78576 10.0" 
$ns at 212.7783148372031 "$node_(157) setdest 73013 547 16.0" 
$ns at 243.56622860643841 "$node_(157) setdest 63869 10045 9.0" 
$ns at 306.4767666537303 "$node_(157) setdest 20114 8682 6.0" 
$ns at 353.4663508848232 "$node_(157) setdest 69297 8488 13.0" 
$ns at 414.8067795800204 "$node_(157) setdest 10679 25286 12.0" 
$ns at 546.6526525410211 "$node_(157) setdest 142683 48744 12.0" 
$ns at 649.8746187863792 "$node_(157) setdest 186123 22317 1.0" 
$ns at 684.1076443414203 "$node_(157) setdest 14284 49059 5.0" 
$ns at 720.6693531958036 "$node_(157) setdest 159472 53393 11.0" 
$ns at 785.241604253013 "$node_(157) setdest 250974 61262 8.0" 
$ns at 877.6303803325255 "$node_(157) setdest 162756 85105 18.0" 
$ns at 120.98775631369666 "$node_(158) setdest 58009 9816 2.0" 
$ns at 154.74188119986775 "$node_(158) setdest 15054 1967 6.0" 
$ns at 220.48215718946693 "$node_(158) setdest 110436 21480 3.0" 
$ns at 259.7535210327036 "$node_(158) setdest 961 2574 12.0" 
$ns at 341.5815586169123 "$node_(158) setdest 150957 11433 14.0" 
$ns at 403.84986554616626 "$node_(158) setdest 41075 24918 9.0" 
$ns at 453.31938477976917 "$node_(158) setdest 173046 67815 14.0" 
$ns at 518.7026789152283 "$node_(158) setdest 49574 29465 18.0" 
$ns at 583.1813774350753 "$node_(158) setdest 203234 43953 4.0" 
$ns at 624.6217464525743 "$node_(158) setdest 199701 37855 3.0" 
$ns at 677.7635400866532 "$node_(158) setdest 193996 46964 14.0" 
$ns at 785.6827855238989 "$node_(158) setdest 36797 75319 11.0" 
$ns at 243.1503684430615 "$node_(159) setdest 33505 43305 6.0" 
$ns at 279.42499869584367 "$node_(159) setdest 160852 36421 2.0" 
$ns at 314.4105453299676 "$node_(159) setdest 156423 29241 17.0" 
$ns at 406.93415489576523 "$node_(159) setdest 99204 15600 12.0" 
$ns at 454.052816616331 "$node_(159) setdest 2521 26102 13.0" 
$ns at 546.4027388955055 "$node_(159) setdest 172779 19461 18.0" 
$ns at 716.5652415229156 "$node_(159) setdest 88315 47172 19.0" 
$ns at 835.9781440222296 "$node_(159) setdest 29956 38494 17.0" 
$ns at 155.79107213389992 "$node_(160) setdest 130336 34071 14.0" 
$ns at 242.03398772499946 "$node_(160) setdest 90719 23464 11.0" 
$ns at 352.21698074333653 "$node_(160) setdest 93181 4874 13.0" 
$ns at 450.57569778330054 "$node_(160) setdest 45621 32891 17.0" 
$ns at 608.6684525775831 "$node_(160) setdest 196908 7296 9.0" 
$ns at 713.449231419349 "$node_(160) setdest 243020 29215 3.0" 
$ns at 763.9381625862281 "$node_(160) setdest 242836 57392 11.0" 
$ns at 863.54541407321 "$node_(160) setdest 57117 23539 17.0" 
$ns at 893.8189647272477 "$node_(160) setdest 233536 44106 16.0" 
$ns at 195.56371922660605 "$node_(161) setdest 128395 36678 13.0" 
$ns at 322.128738966561 "$node_(161) setdest 118420 14661 8.0" 
$ns at 426.3025247950716 "$node_(161) setdest 24960 46110 1.0" 
$ns at 461.10213009138675 "$node_(161) setdest 56873 69849 7.0" 
$ns at 534.9084340597702 "$node_(161) setdest 209309 9296 9.0" 
$ns at 623.196259735244 "$node_(161) setdest 108507 74204 20.0" 
$ns at 757.140907790764 "$node_(161) setdest 161353 20466 6.0" 
$ns at 796.9970459229885 "$node_(161) setdest 119148 65664 8.0" 
$ns at 858.1433286249124 "$node_(161) setdest 6657 15312 8.0" 
$ns at 147.37792166392063 "$node_(162) setdest 62811 16685 15.0" 
$ns at 208.67571575510578 "$node_(162) setdest 84297 17515 20.0" 
$ns at 308.36831695896944 "$node_(162) setdest 125730 51779 1.0" 
$ns at 342.3359571278903 "$node_(162) setdest 103072 1459 1.0" 
$ns at 379.05262449458905 "$node_(162) setdest 45119 46547 3.0" 
$ns at 430.551315596073 "$node_(162) setdest 87614 24950 10.0" 
$ns at 538.765167348549 "$node_(162) setdest 44665 26660 10.0" 
$ns at 633.5657832730266 "$node_(162) setdest 30650 71888 16.0" 
$ns at 786.3519503149948 "$node_(162) setdest 25011 14956 9.0" 
$ns at 829.0451352045903 "$node_(162) setdest 20280 44298 5.0" 
$ns at 867.1566633446217 "$node_(162) setdest 16517 46822 20.0" 
$ns at 108.23106148386358 "$node_(163) setdest 86221 15707 16.0" 
$ns at 297.1609177515922 "$node_(163) setdest 107819 34262 7.0" 
$ns at 330.03675386185114 "$node_(163) setdest 138870 35445 9.0" 
$ns at 395.57462389056667 "$node_(163) setdest 155048 61518 14.0" 
$ns at 466.8456494707324 "$node_(163) setdest 201926 48836 11.0" 
$ns at 570.7584521924911 "$node_(163) setdest 223120 37854 17.0" 
$ns at 621.8111373042508 "$node_(163) setdest 37780 56804 8.0" 
$ns at 688.8364979722124 "$node_(163) setdest 22217 65652 10.0" 
$ns at 724.2014126187267 "$node_(163) setdest 229742 42158 3.0" 
$ns at 780.1648349944219 "$node_(163) setdest 29054 62294 13.0" 
$ns at 846.1266778995681 "$node_(163) setdest 31913 83011 11.0" 
$ns at 897.3007599120631 "$node_(163) setdest 40915 66791 8.0" 
$ns at 202.96444657580338 "$node_(164) setdest 133651 6964 3.0" 
$ns at 234.57972927617413 "$node_(164) setdest 25134 926 15.0" 
$ns at 367.74608644272956 "$node_(164) setdest 145931 8725 12.0" 
$ns at 411.6993981493684 "$node_(164) setdest 102918 43951 11.0" 
$ns at 522.0122913995241 "$node_(164) setdest 89764 33518 10.0" 
$ns at 553.3123561927307 "$node_(164) setdest 160465 37742 14.0" 
$ns at 698.7545132294724 "$node_(164) setdest 165983 49788 18.0" 
$ns at 816.1463044591736 "$node_(164) setdest 190981 27975 19.0" 
$ns at 123.49332035193899 "$node_(165) setdest 16226 13452 10.0" 
$ns at 241.0067490672809 "$node_(165) setdest 84707 34480 6.0" 
$ns at 299.05280952640544 "$node_(165) setdest 52833 38866 5.0" 
$ns at 334.79938143171654 "$node_(165) setdest 48809 37522 7.0" 
$ns at 397.29280608224474 "$node_(165) setdest 136000 100 11.0" 
$ns at 459.31869356262956 "$node_(165) setdest 117161 7492 2.0" 
$ns at 503.3469252998639 "$node_(165) setdest 192029 27578 19.0" 
$ns at 624.9869077654074 "$node_(165) setdest 126470 8478 13.0" 
$ns at 770.5177968618766 "$node_(165) setdest 147935 66080 12.0" 
$ns at 824.0916141455327 "$node_(165) setdest 241991 63684 12.0" 
$ns at 147.11682460274343 "$node_(166) setdest 30408 4855 1.0" 
$ns at 178.73826745525386 "$node_(166) setdest 125200 19530 4.0" 
$ns at 233.55519574904463 "$node_(166) setdest 70063 23953 4.0" 
$ns at 287.8995342899843 "$node_(166) setdest 76060 47254 11.0" 
$ns at 421.34336188070967 "$node_(166) setdest 175111 31921 6.0" 
$ns at 476.14294636479826 "$node_(166) setdest 63793 62434 17.0" 
$ns at 664.3442365497482 "$node_(166) setdest 88735 18645 4.0" 
$ns at 732.3933629354685 "$node_(166) setdest 70118 77238 2.0" 
$ns at 782.0784172733584 "$node_(166) setdest 45593 46220 14.0" 
$ns at 161.987461517833 "$node_(167) setdest 100218 30616 13.0" 
$ns at 254.2667692164968 "$node_(167) setdest 98698 21386 20.0" 
$ns at 323.368715833842 "$node_(167) setdest 89558 38540 5.0" 
$ns at 372.83577978777174 "$node_(167) setdest 109839 42745 3.0" 
$ns at 420.9305529170538 "$node_(167) setdest 185084 41800 6.0" 
$ns at 477.9009620212234 "$node_(167) setdest 209381 3678 3.0" 
$ns at 534.6320159053579 "$node_(167) setdest 190821 57855 7.0" 
$ns at 633.1432671892959 "$node_(167) setdest 198327 71913 3.0" 
$ns at 684.0697524112343 "$node_(167) setdest 219696 18833 2.0" 
$ns at 721.4798562580409 "$node_(167) setdest 62431 57663 8.0" 
$ns at 773.9079136358243 "$node_(167) setdest 186643 28996 14.0" 
$ns at 162.5431836183732 "$node_(168) setdest 15584 40372 1.0" 
$ns at 196.6524395307971 "$node_(168) setdest 100487 1624 10.0" 
$ns at 293.2508489813015 "$node_(168) setdest 122024 41522 8.0" 
$ns at 382.55374971755896 "$node_(168) setdest 88247 27722 9.0" 
$ns at 453.1884717537261 "$node_(168) setdest 195502 25622 18.0" 
$ns at 575.633923330272 "$node_(168) setdest 103503 19424 4.0" 
$ns at 638.6122048197248 "$node_(168) setdest 4059 61242 17.0" 
$ns at 689.3738993067664 "$node_(168) setdest 187214 30566 7.0" 
$ns at 780.4935920028656 "$node_(168) setdest 67755 29733 10.0" 
$ns at 882.3071900647345 "$node_(168) setdest 157251 23756 4.0" 
$ns at 186.79409303140525 "$node_(169) setdest 79372 27187 2.0" 
$ns at 219.41989884837054 "$node_(169) setdest 131928 35302 19.0" 
$ns at 386.00834536881786 "$node_(169) setdest 6811 45030 12.0" 
$ns at 477.64995086396095 "$node_(169) setdest 20638 25534 3.0" 
$ns at 526.2688682739038 "$node_(169) setdest 87448 58271 1.0" 
$ns at 560.0813394670379 "$node_(169) setdest 29494 70820 7.0" 
$ns at 590.6277838545086 "$node_(169) setdest 213581 20631 8.0" 
$ns at 685.5118967890647 "$node_(169) setdest 63418 59155 8.0" 
$ns at 762.682975519015 "$node_(169) setdest 185253 74724 18.0" 
$ns at 157.30034981718686 "$node_(170) setdest 27483 12644 17.0" 
$ns at 274.0863684650447 "$node_(170) setdest 121649 11321 9.0" 
$ns at 337.7625917077025 "$node_(170) setdest 29181 21173 15.0" 
$ns at 413.68675198073504 "$node_(170) setdest 162183 4342 4.0" 
$ns at 469.09398144213225 "$node_(170) setdest 193328 43502 7.0" 
$ns at 508.79599493443106 "$node_(170) setdest 83285 2274 4.0" 
$ns at 562.5331200632424 "$node_(170) setdest 35568 37823 15.0" 
$ns at 726.5500056025215 "$node_(170) setdest 108417 75476 17.0" 
$ns at 787.5821531487209 "$node_(170) setdest 168318 69050 14.0" 
$ns at 198.00825410431472 "$node_(171) setdest 45332 28024 16.0" 
$ns at 301.73881047913596 "$node_(171) setdest 78176 35639 5.0" 
$ns at 350.05536410370286 "$node_(171) setdest 189159 15157 8.0" 
$ns at 422.96807787580747 "$node_(171) setdest 150724 2140 7.0" 
$ns at 476.21237942045906 "$node_(171) setdest 108442 69839 13.0" 
$ns at 577.0180745475769 "$node_(171) setdest 190370 27134 16.0" 
$ns at 672.1957505508747 "$node_(171) setdest 79134 36451 1.0" 
$ns at 708.4629254590482 "$node_(171) setdest 47444 15694 11.0" 
$ns at 839.9543250245335 "$node_(171) setdest 184513 54763 18.0" 
$ns at 176.28236068724846 "$node_(172) setdest 109796 32923 16.0" 
$ns at 234.83439410927986 "$node_(172) setdest 80210 35376 7.0" 
$ns at 290.37707498579994 "$node_(172) setdest 30944 36410 10.0" 
$ns at 343.5026778373914 "$node_(172) setdest 77249 22959 3.0" 
$ns at 399.84196688735136 "$node_(172) setdest 112259 58673 6.0" 
$ns at 482.19290358038876 "$node_(172) setdest 168522 27432 6.0" 
$ns at 524.464120041622 "$node_(172) setdest 81410 32485 9.0" 
$ns at 571.6470097623833 "$node_(172) setdest 58327 37636 15.0" 
$ns at 609.968040662553 "$node_(172) setdest 182801 30454 9.0" 
$ns at 717.8421798007995 "$node_(172) setdest 29080 74335 3.0" 
$ns at 773.9719289700245 "$node_(172) setdest 89543 47427 17.0" 
$ns at 815.5714310631674 "$node_(172) setdest 220482 7652 6.0" 
$ns at 113.97276636420463 "$node_(173) setdest 31978 24293 18.0" 
$ns at 258.41524443740127 "$node_(173) setdest 48486 15424 9.0" 
$ns at 351.9520819508962 "$node_(173) setdest 61457 61621 16.0" 
$ns at 386.0507208748315 "$node_(173) setdest 47667 22300 4.0" 
$ns at 430.2538736585888 "$node_(173) setdest 44635 14980 20.0" 
$ns at 519.5481465434706 "$node_(173) setdest 181912 7758 16.0" 
$ns at 709.0569694900415 "$node_(173) setdest 167358 81624 18.0" 
$ns at 757.7949984084165 "$node_(173) setdest 913 26533 16.0" 
$ns at 102.90577299753276 "$node_(174) setdest 59335 7239 15.0" 
$ns at 172.8176945339431 "$node_(174) setdest 79067 10763 12.0" 
$ns at 261.2513621238236 "$node_(174) setdest 1497 47445 14.0" 
$ns at 381.6868822547019 "$node_(174) setdest 112897 5090 13.0" 
$ns at 526.0290641974937 "$node_(174) setdest 11530 55815 15.0" 
$ns at 691.0864945041703 "$node_(174) setdest 66289 71891 17.0" 
$ns at 812.2928961817338 "$node_(174) setdest 126423 55462 4.0" 
$ns at 846.7212886285985 "$node_(174) setdest 178374 37904 16.0" 
$ns at 131.51067097503386 "$node_(175) setdest 47644 1986 13.0" 
$ns at 268.98438257399334 "$node_(175) setdest 73283 35481 13.0" 
$ns at 370.44715376831954 "$node_(175) setdest 112219 19695 11.0" 
$ns at 491.07106329187644 "$node_(175) setdest 95838 56610 10.0" 
$ns at 595.4412967183655 "$node_(175) setdest 201668 20630 14.0" 
$ns at 743.0140976623347 "$node_(175) setdest 239427 62259 10.0" 
$ns at 848.4720894274092 "$node_(175) setdest 206003 69369 1.0" 
$ns at 887.9131856156763 "$node_(175) setdest 11258 40553 5.0" 
$ns at 170.6044143524356 "$node_(176) setdest 22855 34066 16.0" 
$ns at 207.0851052418098 "$node_(176) setdest 62679 884 4.0" 
$ns at 262.15586410744123 "$node_(176) setdest 153130 8435 9.0" 
$ns at 317.3616560760254 "$node_(176) setdest 104980 9322 12.0" 
$ns at 385.6003207220225 "$node_(176) setdest 134216 34717 13.0" 
$ns at 524.665036344072 "$node_(176) setdest 72449 36621 6.0" 
$ns at 605.3060559853869 "$node_(176) setdest 150493 4611 17.0" 
$ns at 650.3448181517269 "$node_(176) setdest 229525 3614 2.0" 
$ns at 688.3967421932005 "$node_(176) setdest 174647 81125 7.0" 
$ns at 766.3402814428883 "$node_(176) setdest 92214 73362 7.0" 
$ns at 837.321539513038 "$node_(176) setdest 162720 37092 6.0" 
$ns at 875.8198713930241 "$node_(176) setdest 141898 44606 1.0" 
$ns at 143.6846420606421 "$node_(177) setdest 8342 27902 6.0" 
$ns at 179.08130088360474 "$node_(177) setdest 26967 255 2.0" 
$ns at 220.1163941633734 "$node_(177) setdest 32537 42015 7.0" 
$ns at 310.4272197722568 "$node_(177) setdest 93177 11291 15.0" 
$ns at 405.1978940130109 "$node_(177) setdest 48508 13021 14.0" 
$ns at 510.4591195510316 "$node_(177) setdest 32386 17623 12.0" 
$ns at 644.7773043364695 "$node_(177) setdest 141021 48224 16.0" 
$ns at 704.8640286614935 "$node_(177) setdest 117424 77422 15.0" 
$ns at 853.3089712377016 "$node_(177) setdest 195725 62958 9.0" 
$ns at 102.83507037945552 "$node_(178) setdest 64689 8895 7.0" 
$ns at 169.03232870211446 "$node_(178) setdest 27981 4320 15.0" 
$ns at 213.25943261034718 "$node_(178) setdest 77146 23815 5.0" 
$ns at 274.7930950163777 "$node_(178) setdest 134794 35451 9.0" 
$ns at 379.98526370546995 "$node_(178) setdest 78791 2735 19.0" 
$ns at 580.3213761982912 "$node_(178) setdest 150091 12751 18.0" 
$ns at 773.2077606873108 "$node_(178) setdest 77325 1919 17.0" 
$ns at 882.6224242484502 "$node_(178) setdest 125375 6357 1.0" 
$ns at 131.36207362491575 "$node_(179) setdest 32840 27409 10.0" 
$ns at 180.4426399647629 "$node_(179) setdest 9962 23015 12.0" 
$ns at 239.90161454054635 "$node_(179) setdest 9484 18783 4.0" 
$ns at 276.31755211171867 "$node_(179) setdest 61336 28816 7.0" 
$ns at 329.05331563444713 "$node_(179) setdest 83954 54606 17.0" 
$ns at 486.33589885991785 "$node_(179) setdest 206758 37350 8.0" 
$ns at 548.1711780257885 "$node_(179) setdest 73703 7337 12.0" 
$ns at 669.8157922757209 "$node_(179) setdest 28419 21593 20.0" 
$ns at 716.8439665406715 "$node_(179) setdest 197850 60348 5.0" 
$ns at 761.2285781723666 "$node_(179) setdest 79262 4330 19.0" 
$ns at 111.94202539968204 "$node_(180) setdest 55329 29720 8.0" 
$ns at 192.2438541654256 "$node_(180) setdest 73375 33028 15.0" 
$ns at 293.2458964661322 "$node_(180) setdest 39709 10556 1.0" 
$ns at 332.0996553365678 "$node_(180) setdest 145365 48488 10.0" 
$ns at 454.9488253049176 "$node_(180) setdest 112726 21987 7.0" 
$ns at 485.7411186189549 "$node_(180) setdest 109043 64404 3.0" 
$ns at 537.4948072418138 "$node_(180) setdest 46235 42020 6.0" 
$ns at 622.0518243379122 "$node_(180) setdest 231132 33263 8.0" 
$ns at 725.7357825946583 "$node_(180) setdest 126962 73270 13.0" 
$ns at 834.5894633791924 "$node_(180) setdest 254245 47461 17.0" 
$ns at 128.99752694541547 "$node_(181) setdest 28442 20225 18.0" 
$ns at 213.13237209456676 "$node_(181) setdest 74641 35909 8.0" 
$ns at 300.50502238650506 "$node_(181) setdest 68064 33158 17.0" 
$ns at 390.27517661010074 "$node_(181) setdest 107233 60982 13.0" 
$ns at 522.0518158838266 "$node_(181) setdest 102977 43157 6.0" 
$ns at 566.9158243686878 "$node_(181) setdest 186107 65119 9.0" 
$ns at 620.7270285896228 "$node_(181) setdest 173800 250 16.0" 
$ns at 799.7996368391887 "$node_(181) setdest 216236 46211 17.0" 
$ns at 126.76776613833032 "$node_(182) setdest 93611 28935 3.0" 
$ns at 182.96627341318913 "$node_(182) setdest 23422 11875 2.0" 
$ns at 227.65989260938818 "$node_(182) setdest 75068 29565 6.0" 
$ns at 276.28595962938306 "$node_(182) setdest 97899 35496 12.0" 
$ns at 373.04653898678725 "$node_(182) setdest 30277 49826 15.0" 
$ns at 542.9354726398986 "$node_(182) setdest 91564 51399 3.0" 
$ns at 595.9210160480983 "$node_(182) setdest 17098 59641 2.0" 
$ns at 645.2432705147587 "$node_(182) setdest 173498 37883 13.0" 
$ns at 715.6862652240371 "$node_(182) setdest 75389 52399 2.0" 
$ns at 757.3099129435818 "$node_(182) setdest 239686 15842 2.0" 
$ns at 792.5614028117324 "$node_(182) setdest 240860 6944 19.0" 
$ns at 152.09089856589617 "$node_(183) setdest 88204 39975 13.0" 
$ns at 265.80280572219476 "$node_(183) setdest 117922 35900 12.0" 
$ns at 340.84791637539405 "$node_(183) setdest 151035 47066 16.0" 
$ns at 391.51639089696755 "$node_(183) setdest 69306 28817 12.0" 
$ns at 466.5286498928466 "$node_(183) setdest 118547 62393 15.0" 
$ns at 644.5269526463355 "$node_(183) setdest 172157 16941 7.0" 
$ns at 716.0736179992009 "$node_(183) setdest 139510 34219 16.0" 
$ns at 804.7483875772562 "$node_(183) setdest 241144 16577 18.0" 
$ns at 198.05815087003202 "$node_(184) setdest 57362 22589 7.0" 
$ns at 259.66432236559297 "$node_(184) setdest 18904 14321 1.0" 
$ns at 290.5560749347045 "$node_(184) setdest 57984 12041 7.0" 
$ns at 363.6235463924045 "$node_(184) setdest 189142 3107 8.0" 
$ns at 421.59450962843647 "$node_(184) setdest 64216 25680 1.0" 
$ns at 460.7687903384284 "$node_(184) setdest 27958 68243 19.0" 
$ns at 548.0167951145396 "$node_(184) setdest 143142 19232 15.0" 
$ns at 707.297804887377 "$node_(184) setdest 106820 73508 19.0" 
$ns at 835.5723505801111 "$node_(184) setdest 2282 70266 20.0" 
$ns at 102.75258912788726 "$node_(185) setdest 7075 8108 2.0" 
$ns at 151.8366432054239 "$node_(185) setdest 25492 37647 1.0" 
$ns at 189.11254301387342 "$node_(185) setdest 61764 42086 14.0" 
$ns at 349.50755030984715 "$node_(185) setdest 154021 37229 17.0" 
$ns at 443.9583450979527 "$node_(185) setdest 153394 21784 18.0" 
$ns at 613.290721869316 "$node_(185) setdest 106815 28098 14.0" 
$ns at 678.6460017048691 "$node_(185) setdest 159314 74080 10.0" 
$ns at 787.0116964038971 "$node_(185) setdest 96420 46112 7.0" 
$ns at 838.8101597599343 "$node_(185) setdest 238540 23561 2.0" 
$ns at 876.5857745425759 "$node_(185) setdest 50047 22303 1.0" 
$ns at 110.91333957733855 "$node_(186) setdest 83605 20141 15.0" 
$ns at 277.85079150704775 "$node_(186) setdest 35411 39667 17.0" 
$ns at 373.8956472552603 "$node_(186) setdest 33333 62953 6.0" 
$ns at 404.12504904322265 "$node_(186) setdest 62659 26579 20.0" 
$ns at 596.4524667713065 "$node_(186) setdest 182994 26358 7.0" 
$ns at 687.1044306671007 "$node_(186) setdest 29130 41090 19.0" 
$ns at 824.6291170881593 "$node_(186) setdest 130896 55832 20.0" 
$ns at 885.8882225912345 "$node_(186) setdest 81555 1032 19.0" 
$ns at 132.89828816757415 "$node_(187) setdest 17966 5600 13.0" 
$ns at 238.9646177351416 "$node_(187) setdest 125364 26073 1.0" 
$ns at 274.45178987159784 "$node_(187) setdest 114468 28224 19.0" 
$ns at 477.64710959617133 "$node_(187) setdest 153335 70221 4.0" 
$ns at 534.4525131123701 "$node_(187) setdest 147986 61605 8.0" 
$ns at 628.0505593940882 "$node_(187) setdest 174000 7241 5.0" 
$ns at 693.7537966160353 "$node_(187) setdest 73451 33988 1.0" 
$ns at 730.752685396233 "$node_(187) setdest 223714 82526 6.0" 
$ns at 791.8526048786002 "$node_(187) setdest 2630 8766 12.0" 
$ns at 136.04667675572318 "$node_(188) setdest 3922 28161 16.0" 
$ns at 263.49068729385505 "$node_(188) setdest 97968 33349 17.0" 
$ns at 378.1396472293925 "$node_(188) setdest 148060 52787 10.0" 
$ns at 498.5273380398419 "$node_(188) setdest 44319 35215 8.0" 
$ns at 543.1176059277159 "$node_(188) setdest 208730 12446 6.0" 
$ns at 629.5483439929001 "$node_(188) setdest 17058 39155 16.0" 
$ns at 732.5933321612127 "$node_(188) setdest 18560 78582 20.0" 
$ns at 839.5684558955934 "$node_(188) setdest 133415 37080 5.0" 
$ns at 886.0910074118036 "$node_(188) setdest 175421 12007 14.0" 
$ns at 102.5258751072408 "$node_(189) setdest 70347 21684 13.0" 
$ns at 237.767966154563 "$node_(189) setdest 1133 9960 17.0" 
$ns at 386.682230967299 "$node_(189) setdest 99355 42964 10.0" 
$ns at 485.2957799347406 "$node_(189) setdest 106375 7516 13.0" 
$ns at 519.2528706634037 "$node_(189) setdest 122120 11331 1.0" 
$ns at 556.5418000940965 "$node_(189) setdest 198507 47807 6.0" 
$ns at 635.7510214221334 "$node_(189) setdest 134277 51970 18.0" 
$ns at 777.6343192159575 "$node_(189) setdest 240559 32057 16.0" 
$ns at 142.2443761368471 "$node_(190) setdest 12398 1525 1.0" 
$ns at 172.63664576845352 "$node_(190) setdest 51968 38604 3.0" 
$ns at 230.307130765838 "$node_(190) setdest 100401 22334 16.0" 
$ns at 326.6811238982826 "$node_(190) setdest 151005 20824 4.0" 
$ns at 363.7071776670084 "$node_(190) setdest 186631 8677 19.0" 
$ns at 468.140120404381 "$node_(190) setdest 176879 36678 14.0" 
$ns at 549.203323648887 "$node_(190) setdest 209607 13675 13.0" 
$ns at 597.2392440099727 "$node_(190) setdest 88737 43311 6.0" 
$ns at 668.287796569337 "$node_(190) setdest 105733 27404 12.0" 
$ns at 715.2021113567141 "$node_(190) setdest 242783 18628 14.0" 
$ns at 748.1559007785157 "$node_(190) setdest 237124 50687 9.0" 
$ns at 784.5273808239093 "$node_(190) setdest 256219 19533 2.0" 
$ns at 828.567764296333 "$node_(190) setdest 164162 46525 1.0" 
$ns at 863.7324942921715 "$node_(190) setdest 85701 26305 4.0" 
$ns at 135.24602870971427 "$node_(191) setdest 44514 20656 5.0" 
$ns at 182.25138569749927 "$node_(191) setdest 7854 40562 7.0" 
$ns at 276.58348002158175 "$node_(191) setdest 135867 46642 12.0" 
$ns at 348.01246322919354 "$node_(191) setdest 136976 40796 16.0" 
$ns at 531.990180613601 "$node_(191) setdest 211726 38015 7.0" 
$ns at 576.2250317643181 "$node_(191) setdest 139856 45134 17.0" 
$ns at 685.8141171671573 "$node_(191) setdest 153553 54253 13.0" 
$ns at 777.7986059776341 "$node_(191) setdest 12281 37574 14.0" 
$ns at 822.8453445770035 "$node_(191) setdest 43596 82816 13.0" 
$ns at 112.9911433842989 "$node_(192) setdest 34414 14575 10.0" 
$ns at 197.58820277875725 "$node_(192) setdest 119852 8373 15.0" 
$ns at 284.1130964965139 "$node_(192) setdest 56262 19701 20.0" 
$ns at 435.53505466498945 "$node_(192) setdest 32340 10788 4.0" 
$ns at 468.6736584956951 "$node_(192) setdest 92511 20469 1.0" 
$ns at 504.66922364791407 "$node_(192) setdest 156488 68796 3.0" 
$ns at 550.3556998176132 "$node_(192) setdest 219404 67532 15.0" 
$ns at 695.3562647769714 "$node_(192) setdest 242091 49454 2.0" 
$ns at 727.357758742022 "$node_(192) setdest 60137 15474 8.0" 
$ns at 794.7947101368329 "$node_(192) setdest 196068 72332 16.0" 
$ns at 170.44690687905575 "$node_(193) setdest 94883 26820 12.0" 
$ns at 234.5661707540002 "$node_(193) setdest 26584 11848 1.0" 
$ns at 271.2163445588618 "$node_(193) setdest 77521 4854 14.0" 
$ns at 325.3998925562977 "$node_(193) setdest 89470 32122 7.0" 
$ns at 400.11444854871473 "$node_(193) setdest 79357 18776 13.0" 
$ns at 549.4110112632213 "$node_(193) setdest 47851 21136 16.0" 
$ns at 664.7624285280797 "$node_(193) setdest 247818 37634 17.0" 
$ns at 749.2633563215745 "$node_(193) setdest 17357 64614 8.0" 
$ns at 780.816715842903 "$node_(193) setdest 104256 29757 6.0" 
$ns at 812.3228833289802 "$node_(193) setdest 12506 68771 17.0" 
$ns at 865.2764709363151 "$node_(193) setdest 90366 31283 19.0" 
$ns at 113.83938154598414 "$node_(194) setdest 43238 13402 1.0" 
$ns at 149.68207660149437 "$node_(194) setdest 13217 7377 5.0" 
$ns at 221.17550923233708 "$node_(194) setdest 66444 22121 2.0" 
$ns at 268.4351449271231 "$node_(194) setdest 94551 27312 17.0" 
$ns at 306.6092660186059 "$node_(194) setdest 142460 12712 16.0" 
$ns at 367.2667316092443 "$node_(194) setdest 106303 22175 1.0" 
$ns at 406.1144064321224 "$node_(194) setdest 108154 45405 16.0" 
$ns at 463.13668517860793 "$node_(194) setdest 29536 33523 4.0" 
$ns at 504.37864015434985 "$node_(194) setdest 74630 20320 10.0" 
$ns at 610.1964165410373 "$node_(194) setdest 7851 3328 7.0" 
$ns at 647.5225999344048 "$node_(194) setdest 77221 56313 14.0" 
$ns at 756.1188843438409 "$node_(194) setdest 195175 60365 11.0" 
$ns at 814.0186319023455 "$node_(194) setdest 94847 60022 14.0" 
$ns at 863.6458675843533 "$node_(194) setdest 76887 54567 8.0" 
$ns at 125.19796857973648 "$node_(195) setdest 35498 3231 18.0" 
$ns at 253.48117690038617 "$node_(195) setdest 94759 42298 3.0" 
$ns at 300.96677277809226 "$node_(195) setdest 26627 14231 1.0" 
$ns at 334.251209481341 "$node_(195) setdest 125593 43760 8.0" 
$ns at 379.0400297381324 "$node_(195) setdest 18890 52301 4.0" 
$ns at 418.2574048869242 "$node_(195) setdest 104959 35692 9.0" 
$ns at 477.39453516071126 "$node_(195) setdest 158213 45251 16.0" 
$ns at 570.2810558875617 "$node_(195) setdest 62474 20569 1.0" 
$ns at 601.6077199227392 "$node_(195) setdest 28364 58130 5.0" 
$ns at 678.7262574437004 "$node_(195) setdest 96163 28354 14.0" 
$ns at 843.9408681010441 "$node_(195) setdest 78170 40393 2.0" 
$ns at 884.1696137199613 "$node_(195) setdest 63899 37385 6.0" 
$ns at 114.89510160462132 "$node_(196) setdest 42373 20403 2.0" 
$ns at 150.84010960944494 "$node_(196) setdest 99201 42898 19.0" 
$ns at 343.61350985527616 "$node_(196) setdest 9761 18312 10.0" 
$ns at 398.20532140997756 "$node_(196) setdest 99550 12300 1.0" 
$ns at 436.3704030970654 "$node_(196) setdest 53517 44146 14.0" 
$ns at 574.018930669921 "$node_(196) setdest 43445 11679 7.0" 
$ns at 622.4321280926479 "$node_(196) setdest 7615 33906 18.0" 
$ns at 758.4488155094909 "$node_(196) setdest 3187 40428 20.0" 
$ns at 826.0131101263602 "$node_(196) setdest 165891 42403 15.0" 
$ns at 211.89543898648122 "$node_(197) setdest 55931 31832 10.0" 
$ns at 333.7291649610404 "$node_(197) setdest 25527 9088 5.0" 
$ns at 406.20638452879405 "$node_(197) setdest 781 9791 19.0" 
$ns at 566.7884058071008 "$node_(197) setdest 174579 39329 11.0" 
$ns at 696.5618235618699 "$node_(197) setdest 239633 71891 10.0" 
$ns at 823.1312527794303 "$node_(197) setdest 242270 73201 2.0" 
$ns at 860.5942624899004 "$node_(197) setdest 258587 488 14.0" 
$ns at 237.7744140494543 "$node_(198) setdest 35772 7140 2.0" 
$ns at 279.6680614378886 "$node_(198) setdest 2419 43902 18.0" 
$ns at 453.77166951991444 "$node_(198) setdest 169866 62545 1.0" 
$ns at 487.94537861536037 "$node_(198) setdest 63290 46932 4.0" 
$ns at 552.8509842806179 "$node_(198) setdest 171933 9686 5.0" 
$ns at 624.040929009296 "$node_(198) setdest 148561 15280 18.0" 
$ns at 683.642401212927 "$node_(198) setdest 35666 26358 1.0" 
$ns at 717.2564561102309 "$node_(198) setdest 148438 5934 1.0" 
$ns at 752.8733919277121 "$node_(198) setdest 56042 62481 13.0" 
$ns at 879.3349117753254 "$node_(198) setdest 202516 3676 13.0" 
$ns at 125.74293052939557 "$node_(199) setdest 90601 28191 7.0" 
$ns at 157.4546352741633 "$node_(199) setdest 8887 10977 4.0" 
$ns at 226.97526809610923 "$node_(199) setdest 14212 42683 9.0" 
$ns at 267.08410747755215 "$node_(199) setdest 73306 32302 17.0" 
$ns at 335.67827935980483 "$node_(199) setdest 119600 22607 4.0" 
$ns at 380.38099237831096 "$node_(199) setdest 82785 3591 14.0" 
$ns at 418.6858446421168 "$node_(199) setdest 112767 45481 14.0" 
$ns at 561.5543827468548 "$node_(199) setdest 87209 27173 4.0" 
$ns at 621.1443163777235 "$node_(199) setdest 64370 9285 11.0" 
$ns at 706.0129526331505 "$node_(199) setdest 249894 9584 5.0" 
$ns at 782.5453927545173 "$node_(199) setdest 78179 76268 14.0" 
$ns at 830.8771988154042 "$node_(199) setdest 254475 59750 4.0" 
$ns at 887.8002595495416 "$node_(199) setdest 106121 40685 1.0" 
$ns at 295.8854155449426 "$node_(200) setdest 110361 7050 3.0" 
$ns at 331.0958745214087 "$node_(200) setdest 98298 33381 3.0" 
$ns at 367.3336019232183 "$node_(200) setdest 35387 34259 10.0" 
$ns at 463.7022302638561 "$node_(200) setdest 7204 8750 19.0" 
$ns at 593.2736596066885 "$node_(200) setdest 73803 34670 19.0" 
$ns at 714.5187104272865 "$node_(200) setdest 21186 11460 13.0" 
$ns at 780.0071753177654 "$node_(200) setdest 96985 28309 6.0" 
$ns at 826.7503699782861 "$node_(200) setdest 93326 20505 4.0" 
$ns at 876.3817383517501 "$node_(200) setdest 42714 24124 10.0" 
$ns at 227.38779779487533 "$node_(201) setdest 133133 42305 1.0" 
$ns at 261.6588576503783 "$node_(201) setdest 28596 24181 4.0" 
$ns at 300.0693053903254 "$node_(201) setdest 20290 35076 12.0" 
$ns at 445.09723028846116 "$node_(201) setdest 131693 30550 3.0" 
$ns at 478.8427577136892 "$node_(201) setdest 56660 35262 10.0" 
$ns at 587.7308631356549 "$node_(201) setdest 29657 12942 13.0" 
$ns at 734.3311950367068 "$node_(201) setdest 5910 23385 17.0" 
$ns at 218.8344503427523 "$node_(202) setdest 85951 18031 20.0" 
$ns at 300.2977108323369 "$node_(202) setdest 101140 40820 5.0" 
$ns at 333.8697905618825 "$node_(202) setdest 116742 16603 18.0" 
$ns at 521.5663423910628 "$node_(202) setdest 68657 39724 4.0" 
$ns at 586.6635688904387 "$node_(202) setdest 110027 10460 16.0" 
$ns at 682.6125705417978 "$node_(202) setdest 126146 3819 10.0" 
$ns at 739.2598456796369 "$node_(202) setdest 24245 5799 12.0" 
$ns at 886.1396666283232 "$node_(202) setdest 6019 21317 9.0" 
$ns at 223.0068134819286 "$node_(203) setdest 57708 31423 17.0" 
$ns at 254.22073844281346 "$node_(203) setdest 79927 26918 13.0" 
$ns at 300.4658162707276 "$node_(203) setdest 26058 2749 2.0" 
$ns at 337.8087357085565 "$node_(203) setdest 51212 40207 5.0" 
$ns at 401.99493593713964 "$node_(203) setdest 276 25105 14.0" 
$ns at 521.3436532488257 "$node_(203) setdest 33704 25599 7.0" 
$ns at 562.6099408137661 "$node_(203) setdest 114057 9223 18.0" 
$ns at 732.2976946726726 "$node_(203) setdest 18306 38286 17.0" 
$ns at 213.60735739927608 "$node_(204) setdest 45186 6075 4.0" 
$ns at 258.20789819179026 "$node_(204) setdest 2932 43349 18.0" 
$ns at 335.37752563185666 "$node_(204) setdest 61192 17161 10.0" 
$ns at 382.33210139810905 "$node_(204) setdest 16950 525 2.0" 
$ns at 421.6864759167731 "$node_(204) setdest 18448 28356 9.0" 
$ns at 483.4664926792718 "$node_(204) setdest 24848 10723 4.0" 
$ns at 543.0866986978575 "$node_(204) setdest 86200 43213 8.0" 
$ns at 630.0768940082572 "$node_(204) setdest 105855 35733 8.0" 
$ns at 730.4020118709809 "$node_(204) setdest 11156 43760 10.0" 
$ns at 851.2350283612286 "$node_(204) setdest 121595 1620 9.0" 
$ns at 350.796602376039 "$node_(205) setdest 4456 42455 6.0" 
$ns at 396.80957328077795 "$node_(205) setdest 75426 34673 8.0" 
$ns at 429.10613561381797 "$node_(205) setdest 22369 35028 14.0" 
$ns at 507.49552345414594 "$node_(205) setdest 14565 37396 7.0" 
$ns at 588.4463502907103 "$node_(205) setdest 50993 370 1.0" 
$ns at 627.1483390856305 "$node_(205) setdest 27392 33390 10.0" 
$ns at 746.2098317273268 "$node_(205) setdest 37589 10909 6.0" 
$ns at 810.2450915140518 "$node_(205) setdest 98221 14012 4.0" 
$ns at 857.9573360580575 "$node_(205) setdest 103953 36368 14.0" 
$ns at 242.06861304747622 "$node_(206) setdest 69153 1656 4.0" 
$ns at 288.09406839244406 "$node_(206) setdest 67203 8502 2.0" 
$ns at 333.1389008483073 "$node_(206) setdest 125186 35205 5.0" 
$ns at 397.5186873800579 "$node_(206) setdest 66469 15527 3.0" 
$ns at 442.3221399008313 "$node_(206) setdest 133161 16998 5.0" 
$ns at 475.9056552334628 "$node_(206) setdest 120648 1496 12.0" 
$ns at 519.0831257468942 "$node_(206) setdest 45479 27346 5.0" 
$ns at 566.355627140795 "$node_(206) setdest 134071 13280 4.0" 
$ns at 633.3245291749397 "$node_(206) setdest 99526 37894 4.0" 
$ns at 668.203740248437 "$node_(206) setdest 75784 17257 9.0" 
$ns at 732.2433216454377 "$node_(206) setdest 18559 29646 7.0" 
$ns at 809.2112982091862 "$node_(206) setdest 46331 14496 17.0" 
$ns at 219.36440152282978 "$node_(207) setdest 91215 44666 6.0" 
$ns at 253.8285239333863 "$node_(207) setdest 118136 30185 8.0" 
$ns at 291.8259364750259 "$node_(207) setdest 91129 30808 16.0" 
$ns at 330.6337919817358 "$node_(207) setdest 75010 23516 10.0" 
$ns at 413.1822911919586 "$node_(207) setdest 124739 11849 5.0" 
$ns at 457.5991493892507 "$node_(207) setdest 100150 10445 6.0" 
$ns at 517.1144121086008 "$node_(207) setdest 97706 12097 4.0" 
$ns at 554.1271374217129 "$node_(207) setdest 39754 32233 8.0" 
$ns at 651.4188603144016 "$node_(207) setdest 59694 14234 1.0" 
$ns at 683.0150892601404 "$node_(207) setdest 67621 2581 14.0" 
$ns at 804.3590551684924 "$node_(207) setdest 20858 132 10.0" 
$ns at 872.5468051617333 "$node_(207) setdest 16865 32947 19.0" 
$ns at 260.3901704825006 "$node_(208) setdest 93414 31645 3.0" 
$ns at 314.3805346937211 "$node_(208) setdest 66930 40892 1.0" 
$ns at 345.9717542008363 "$node_(208) setdest 66691 44278 5.0" 
$ns at 396.8994312804751 "$node_(208) setdest 57486 18897 20.0" 
$ns at 597.0975556315185 "$node_(208) setdest 537 7293 5.0" 
$ns at 637.8649316576142 "$node_(208) setdest 46817 29080 10.0" 
$ns at 692.2346399955395 "$node_(208) setdest 133030 18026 19.0" 
$ns at 772.67374256124 "$node_(208) setdest 105865 147 16.0" 
$ns at 241.92744352616495 "$node_(209) setdest 42783 29542 10.0" 
$ns at 278.7193380721403 "$node_(209) setdest 69762 5054 10.0" 
$ns at 323.2364059088536 "$node_(209) setdest 18019 43539 19.0" 
$ns at 513.1253833323098 "$node_(209) setdest 90933 6732 15.0" 
$ns at 609.1703030060445 "$node_(209) setdest 26340 34373 9.0" 
$ns at 685.6109547163542 "$node_(209) setdest 61067 13266 18.0" 
$ns at 887.9102554546209 "$node_(209) setdest 54989 1294 8.0" 
$ns at 236.2222609196523 "$node_(210) setdest 81541 4542 13.0" 
$ns at 359.6243313463349 "$node_(210) setdest 10417 4768 16.0" 
$ns at 496.4896788566126 "$node_(210) setdest 38996 37580 19.0" 
$ns at 694.8847999381558 "$node_(210) setdest 96278 10677 14.0" 
$ns at 851.0600618708736 "$node_(210) setdest 126812 7307 19.0" 
$ns at 240.58834654729526 "$node_(211) setdest 124472 9251 13.0" 
$ns at 311.9141111398733 "$node_(211) setdest 23874 24760 20.0" 
$ns at 363.92022182485186 "$node_(211) setdest 85197 21178 11.0" 
$ns at 452.0715100726766 "$node_(211) setdest 59880 20684 1.0" 
$ns at 487.2249200142999 "$node_(211) setdest 21361 33241 13.0" 
$ns at 599.2986203414328 "$node_(211) setdest 109712 24648 3.0" 
$ns at 643.7199317645307 "$node_(211) setdest 38114 41632 6.0" 
$ns at 724.24666986549 "$node_(211) setdest 95913 3123 11.0" 
$ns at 816.1331641375388 "$node_(211) setdest 11819 4493 18.0" 
$ns at 302.668608419596 "$node_(212) setdest 34856 12711 3.0" 
$ns at 337.437489928119 "$node_(212) setdest 86275 42910 3.0" 
$ns at 388.1374031699136 "$node_(212) setdest 81214 32793 11.0" 
$ns at 434.58419660322227 "$node_(212) setdest 71682 1024 7.0" 
$ns at 473.4199739400587 "$node_(212) setdest 83116 7703 1.0" 
$ns at 509.8904680791166 "$node_(212) setdest 45914 22049 6.0" 
$ns at 562.1932382962627 "$node_(212) setdest 62684 27438 16.0" 
$ns at 641.0361511492366 "$node_(212) setdest 49517 40461 7.0" 
$ns at 724.6412370221591 "$node_(212) setdest 49080 24145 1.0" 
$ns at 759.2280711295937 "$node_(212) setdest 30854 19493 3.0" 
$ns at 790.1175995989091 "$node_(212) setdest 26896 41300 9.0" 
$ns at 855.6627685522956 "$node_(212) setdest 84308 22305 8.0" 
$ns at 291.6309978599502 "$node_(213) setdest 62608 20663 15.0" 
$ns at 400.51560794582866 "$node_(213) setdest 22647 6934 13.0" 
$ns at 534.6119232921806 "$node_(213) setdest 7689 12640 1.0" 
$ns at 571.4604865483042 "$node_(213) setdest 21677 40339 7.0" 
$ns at 657.8437949912419 "$node_(213) setdest 34323 1629 20.0" 
$ns at 710.9806967344524 "$node_(213) setdest 9793 17555 17.0" 
$ns at 855.3526726635446 "$node_(213) setdest 8159 25812 4.0" 
$ns at 342.31262784829266 "$node_(214) setdest 17491 2953 7.0" 
$ns at 423.9222988064602 "$node_(214) setdest 83503 3933 19.0" 
$ns at 571.9285181464062 "$node_(214) setdest 83225 17849 9.0" 
$ns at 689.1135045438446 "$node_(214) setdest 129919 42825 13.0" 
$ns at 795.1556221921591 "$node_(214) setdest 109224 23285 3.0" 
$ns at 849.4396280333622 "$node_(214) setdest 129617 22792 16.0" 
$ns at 218.27295937124603 "$node_(215) setdest 41527 31344 9.0" 
$ns at 338.2705297161653 "$node_(215) setdest 83561 20395 3.0" 
$ns at 368.5429161426646 "$node_(215) setdest 21864 12841 15.0" 
$ns at 529.1407978199949 "$node_(215) setdest 85203 39730 14.0" 
$ns at 567.0664948691325 "$node_(215) setdest 49605 26672 12.0" 
$ns at 691.8544994747966 "$node_(215) setdest 5820 44221 8.0" 
$ns at 779.4976892109465 "$node_(215) setdest 109469 34732 16.0" 
$ns at 853.626432624111 "$node_(215) setdest 129483 9016 9.0" 
$ns at 298.82197859018015 "$node_(216) setdest 23371 22110 14.0" 
$ns at 332.9884241380624 "$node_(216) setdest 10463 18385 5.0" 
$ns at 411.31829662552167 "$node_(216) setdest 93001 41661 8.0" 
$ns at 446.4310396814352 "$node_(216) setdest 124860 30685 18.0" 
$ns at 588.6390862045914 "$node_(216) setdest 122300 32160 5.0" 
$ns at 632.734329106987 "$node_(216) setdest 90730 20097 6.0" 
$ns at 685.9715179961247 "$node_(216) setdest 107288 39249 18.0" 
$ns at 884.3580862802729 "$node_(216) setdest 86162 42079 4.0" 
$ns at 228.07515014339913 "$node_(217) setdest 70012 16966 9.0" 
$ns at 313.23747690468383 "$node_(217) setdest 15008 37042 13.0" 
$ns at 423.76508916499625 "$node_(217) setdest 59748 22366 2.0" 
$ns at 467.55874185735996 "$node_(217) setdest 8428 38619 4.0" 
$ns at 523.0865967497849 "$node_(217) setdest 19052 24410 12.0" 
$ns at 565.4356875964957 "$node_(217) setdest 65992 34030 3.0" 
$ns at 620.9669537926264 "$node_(217) setdest 41293 21199 20.0" 
$ns at 821.8900971876535 "$node_(217) setdest 110189 11474 17.0" 
$ns at 278.76433607871195 "$node_(218) setdest 22320 36596 13.0" 
$ns at 341.0177217805251 "$node_(218) setdest 72551 33462 18.0" 
$ns at 480.07353789516816 "$node_(218) setdest 90392 5298 6.0" 
$ns at 510.78529307771015 "$node_(218) setdest 15547 33977 20.0" 
$ns at 661.6314024249848 "$node_(218) setdest 96582 5060 3.0" 
$ns at 719.7806499080614 "$node_(218) setdest 107951 18264 2.0" 
$ns at 757.3165754529853 "$node_(218) setdest 49510 27057 6.0" 
$ns at 845.9306195996105 "$node_(218) setdest 102919 7659 4.0" 
$ns at 898.249113619179 "$node_(218) setdest 50627 4221 13.0" 
$ns at 207.91186712333902 "$node_(219) setdest 43511 27754 5.0" 
$ns at 241.61942294365835 "$node_(219) setdest 122073 6673 17.0" 
$ns at 370.96100889669464 "$node_(219) setdest 55046 23135 17.0" 
$ns at 410.2270255426129 "$node_(219) setdest 33684 7362 5.0" 
$ns at 447.26984998913576 "$node_(219) setdest 5010 42019 8.0" 
$ns at 479.3246206827932 "$node_(219) setdest 79249 11368 18.0" 
$ns at 678.1910071683524 "$node_(219) setdest 74468 36657 8.0" 
$ns at 766.1797993398275 "$node_(219) setdest 56292 16741 8.0" 
$ns at 804.0202112421634 "$node_(219) setdest 19708 4467 6.0" 
$ns at 882.2031526323149 "$node_(219) setdest 79517 27525 1.0" 
$ns at 271.5482869475368 "$node_(220) setdest 23466 22795 17.0" 
$ns at 334.3945776275006 "$node_(220) setdest 72973 15827 8.0" 
$ns at 433.3234395961571 "$node_(220) setdest 49193 5311 10.0" 
$ns at 500.15977730491784 "$node_(220) setdest 111963 24990 5.0" 
$ns at 553.0240159074059 "$node_(220) setdest 42330 1723 11.0" 
$ns at 640.8517550410457 "$node_(220) setdest 107554 32958 8.0" 
$ns at 737.4307535287649 "$node_(220) setdest 3018 43806 15.0" 
$ns at 844.3207363739803 "$node_(220) setdest 12202 24862 7.0" 
$ns at 277.44407049043014 "$node_(221) setdest 124550 43282 4.0" 
$ns at 341.55762256749165 "$node_(221) setdest 104348 2763 13.0" 
$ns at 385.29329918173494 "$node_(221) setdest 83493 1039 2.0" 
$ns at 425.01700531817954 "$node_(221) setdest 62518 7659 12.0" 
$ns at 550.9161147622783 "$node_(221) setdest 12225 19592 5.0" 
$ns at 617.1797776415542 "$node_(221) setdest 67010 20185 10.0" 
$ns at 666.0935321647244 "$node_(221) setdest 131715 5146 4.0" 
$ns at 735.4741369326001 "$node_(221) setdest 108202 3167 19.0" 
$ns at 819.9311829803269 "$node_(221) setdest 123636 12027 15.0" 
$ns at 207.55941573053002 "$node_(222) setdest 73422 23049 15.0" 
$ns at 352.21170437498586 "$node_(222) setdest 59940 33789 2.0" 
$ns at 387.906159169499 "$node_(222) setdest 105599 1195 7.0" 
$ns at 457.92759895273156 "$node_(222) setdest 50632 17774 17.0" 
$ns at 647.7566564178305 "$node_(222) setdest 116709 7221 9.0" 
$ns at 747.529284059974 "$node_(222) setdest 91917 16211 17.0" 
$ns at 868.3952197783751 "$node_(222) setdest 59626 34771 2.0" 
$ns at 284.02355416191523 "$node_(223) setdest 61138 13301 13.0" 
$ns at 342.105283385555 "$node_(223) setdest 56591 27037 18.0" 
$ns at 529.2727772004455 "$node_(223) setdest 82889 38664 20.0" 
$ns at 588.2628880537136 "$node_(223) setdest 98994 43307 13.0" 
$ns at 682.5670110946145 "$node_(223) setdest 48008 24233 13.0" 
$ns at 821.1226899510339 "$node_(223) setdest 76379 8361 16.0" 
$ns at 216.90606175412037 "$node_(224) setdest 129230 10150 18.0" 
$ns at 413.566665428208 "$node_(224) setdest 116133 30964 6.0" 
$ns at 459.9855116316338 "$node_(224) setdest 61041 1051 2.0" 
$ns at 503.71736065996197 "$node_(224) setdest 57491 8290 8.0" 
$ns at 556.3556397795612 "$node_(224) setdest 85333 4828 6.0" 
$ns at 588.3726201000836 "$node_(224) setdest 49879 12470 15.0" 
$ns at 639.4780661692384 "$node_(224) setdest 51597 38532 11.0" 
$ns at 722.6716258515238 "$node_(224) setdest 34361 19462 2.0" 
$ns at 755.6104740774246 "$node_(224) setdest 72923 17520 7.0" 
$ns at 842.84139264436 "$node_(224) setdest 65326 39319 11.0" 
$ns at 874.206049084282 "$node_(224) setdest 18858 41552 7.0" 
$ns at 228.27121001634634 "$node_(225) setdest 124470 39298 3.0" 
$ns at 276.02751083756385 "$node_(225) setdest 118627 32982 13.0" 
$ns at 373.4142234028172 "$node_(225) setdest 12891 29283 13.0" 
$ns at 505.4803534658554 "$node_(225) setdest 94099 6617 1.0" 
$ns at 543.9607052216029 "$node_(225) setdest 110258 40400 9.0" 
$ns at 619.4267081322813 "$node_(225) setdest 71576 2687 1.0" 
$ns at 649.6561925987961 "$node_(225) setdest 44986 33086 17.0" 
$ns at 732.2112269700187 "$node_(225) setdest 117712 9439 19.0" 
$ns at 831.0810559417723 "$node_(225) setdest 40526 27269 8.0" 
$ns at 868.447261994165 "$node_(225) setdest 106975 26073 6.0" 
$ns at 232.64169563732568 "$node_(226) setdest 85903 15592 5.0" 
$ns at 263.5927429024166 "$node_(226) setdest 104485 37281 5.0" 
$ns at 323.43663722952516 "$node_(226) setdest 115571 41807 15.0" 
$ns at 441.53109296632607 "$node_(226) setdest 118245 35088 6.0" 
$ns at 509.67110140314225 "$node_(226) setdest 20000 29765 1.0" 
$ns at 543.376740610607 "$node_(226) setdest 46547 15490 3.0" 
$ns at 587.3198377388826 "$node_(226) setdest 79604 3089 8.0" 
$ns at 690.2896586385042 "$node_(226) setdest 91327 36745 2.0" 
$ns at 738.9533353826702 "$node_(226) setdest 15764 42035 8.0" 
$ns at 821.9115219888645 "$node_(226) setdest 97398 17902 3.0" 
$ns at 879.2583572187123 "$node_(226) setdest 43806 17402 7.0" 
$ns at 279.34072390137464 "$node_(227) setdest 2699 14347 6.0" 
$ns at 353.33584916430954 "$node_(227) setdest 92397 4116 3.0" 
$ns at 388.9242941423229 "$node_(227) setdest 59254 9220 4.0" 
$ns at 453.5808719282596 "$node_(227) setdest 114469 4337 3.0" 
$ns at 503.600706423965 "$node_(227) setdest 43935 31542 5.0" 
$ns at 563.5914841926394 "$node_(227) setdest 93417 16565 7.0" 
$ns at 607.797693519194 "$node_(227) setdest 52351 23523 8.0" 
$ns at 645.8317295940739 "$node_(227) setdest 78780 2644 17.0" 
$ns at 749.5310421405007 "$node_(227) setdest 53259 12872 3.0" 
$ns at 789.3914166862304 "$node_(227) setdest 60112 23229 8.0" 
$ns at 850.6612931699575 "$node_(227) setdest 28291 2752 15.0" 
$ns at 202.5125372637424 "$node_(228) setdest 82519 27348 4.0" 
$ns at 234.88416359642522 "$node_(228) setdest 40591 2444 17.0" 
$ns at 292.30119346159995 "$node_(228) setdest 98381 4264 18.0" 
$ns at 479.679057712123 "$node_(228) setdest 8454 19822 6.0" 
$ns at 523.0326924907654 "$node_(228) setdest 129305 26776 2.0" 
$ns at 553.4427831208877 "$node_(228) setdest 44301 35612 6.0" 
$ns at 641.0731695020756 "$node_(228) setdest 109747 14328 9.0" 
$ns at 713.2889116761146 "$node_(228) setdest 43685 30710 19.0" 
$ns at 766.2646879824531 "$node_(228) setdest 3497 39164 10.0" 
$ns at 888.3127526643185 "$node_(228) setdest 95324 17994 16.0" 
$ns at 235.34352719771294 "$node_(229) setdest 109477 40584 7.0" 
$ns at 268.89884969029544 "$node_(229) setdest 41624 35792 9.0" 
$ns at 313.4550880215798 "$node_(229) setdest 41176 28344 15.0" 
$ns at 363.1911116054284 "$node_(229) setdest 90592 6281 16.0" 
$ns at 418.02885184270497 "$node_(229) setdest 39698 10075 1.0" 
$ns at 455.04207140125703 "$node_(229) setdest 107929 17108 5.0" 
$ns at 501.85855870344767 "$node_(229) setdest 81983 41687 17.0" 
$ns at 642.249531939754 "$node_(229) setdest 89743 4982 20.0" 
$ns at 778.2731827653039 "$node_(229) setdest 108051 15360 6.0" 
$ns at 848.3135697092515 "$node_(229) setdest 57191 8805 12.0" 
$ns at 896.9368933666942 "$node_(229) setdest 7724 29011 6.0" 
$ns at 258.812738618838 "$node_(230) setdest 123639 30901 19.0" 
$ns at 317.3368866774721 "$node_(230) setdest 132246 25634 15.0" 
$ns at 378.71399796834106 "$node_(230) setdest 10472 9206 12.0" 
$ns at 456.4752642844473 "$node_(230) setdest 95601 40640 4.0" 
$ns at 491.3777036947809 "$node_(230) setdest 3420 12033 13.0" 
$ns at 646.4386952491353 "$node_(230) setdest 50282 25801 4.0" 
$ns at 682.5953230539352 "$node_(230) setdest 97213 21979 3.0" 
$ns at 727.3571740505441 "$node_(230) setdest 104371 20014 17.0" 
$ns at 835.2369563769123 "$node_(230) setdest 46799 12819 19.0" 
$ns at 203.35403929278908 "$node_(231) setdest 72978 22579 17.0" 
$ns at 286.2534170699154 "$node_(231) setdest 130592 32015 9.0" 
$ns at 373.64069565094053 "$node_(231) setdest 15907 6413 2.0" 
$ns at 417.26123984248153 "$node_(231) setdest 126690 32657 17.0" 
$ns at 572.7270111503478 "$node_(231) setdest 10816 16749 13.0" 
$ns at 721.1742007014104 "$node_(231) setdest 35571 25722 12.0" 
$ns at 822.7060162051066 "$node_(231) setdest 685 41391 3.0" 
$ns at 859.1234161514418 "$node_(231) setdest 72141 2918 20.0" 
$ns at 263.25988619166367 "$node_(232) setdest 82339 9432 12.0" 
$ns at 316.73023201435194 "$node_(232) setdest 108294 17729 12.0" 
$ns at 453.7881707596492 "$node_(232) setdest 65068 28753 8.0" 
$ns at 533.9476548304042 "$node_(232) setdest 26983 18408 3.0" 
$ns at 575.3690098197582 "$node_(232) setdest 39337 582 12.0" 
$ns at 671.9321555292751 "$node_(232) setdest 60827 32203 15.0" 
$ns at 714.3119401053958 "$node_(232) setdest 10383 2537 19.0" 
$ns at 863.3526012675146 "$node_(232) setdest 49989 27603 16.0" 
$ns at 205.74239514676185 "$node_(233) setdest 67523 32590 10.0" 
$ns at 295.57680199896527 "$node_(233) setdest 116934 43959 1.0" 
$ns at 332.99864672436865 "$node_(233) setdest 54756 24108 13.0" 
$ns at 373.64970526645385 "$node_(233) setdest 28940 28239 10.0" 
$ns at 478.3777774109194 "$node_(233) setdest 4590 1428 5.0" 
$ns at 552.3280762779303 "$node_(233) setdest 58136 25874 1.0" 
$ns at 582.6426957131197 "$node_(233) setdest 124330 14072 1.0" 
$ns at 615.4755613868605 "$node_(233) setdest 57371 32912 16.0" 
$ns at 753.9997437056904 "$node_(233) setdest 83115 10886 12.0" 
$ns at 849.420368131976 "$node_(233) setdest 83769 18049 6.0" 
$ns at 204.3549194383845 "$node_(234) setdest 124207 441 11.0" 
$ns at 297.23826585248133 "$node_(234) setdest 123482 13274 17.0" 
$ns at 371.672858039441 "$node_(234) setdest 122206 5532 14.0" 
$ns at 415.8877398960665 "$node_(234) setdest 86483 16586 6.0" 
$ns at 498.8270947077733 "$node_(234) setdest 32462 37161 2.0" 
$ns at 533.5941866779968 "$node_(234) setdest 27070 32367 7.0" 
$ns at 584.1419649882073 "$node_(234) setdest 58455 8125 9.0" 
$ns at 665.8460440061372 "$node_(234) setdest 125069 30151 5.0" 
$ns at 723.3352855113874 "$node_(234) setdest 45008 32144 8.0" 
$ns at 782.1701296529205 "$node_(234) setdest 8762 22945 10.0" 
$ns at 236.6149658660292 "$node_(235) setdest 119124 9251 11.0" 
$ns at 328.8484707808808 "$node_(235) setdest 11718 19556 4.0" 
$ns at 385.61954734574664 "$node_(235) setdest 38133 38547 16.0" 
$ns at 516.9928287278922 "$node_(235) setdest 3566 18825 19.0" 
$ns at 658.5467812584205 "$node_(235) setdest 90756 21881 8.0" 
$ns at 733.6461710678403 "$node_(235) setdest 77394 23127 1.0" 
$ns at 771.5970794387425 "$node_(235) setdest 111181 28611 3.0" 
$ns at 803.9356528682163 "$node_(235) setdest 77994 519 1.0" 
$ns at 838.4814921367251 "$node_(235) setdest 82160 30772 15.0" 
$ns at 254.1301644915523 "$node_(236) setdest 19202 28194 18.0" 
$ns at 306.8898729717853 "$node_(236) setdest 96553 19990 6.0" 
$ns at 378.4984340336527 "$node_(236) setdest 55158 14962 19.0" 
$ns at 533.3872737380384 "$node_(236) setdest 6383 25673 10.0" 
$ns at 593.6884308608171 "$node_(236) setdest 98251 36096 6.0" 
$ns at 665.6529132464875 "$node_(236) setdest 88359 25711 13.0" 
$ns at 788.7173997236563 "$node_(236) setdest 41560 31819 2.0" 
$ns at 827.7337812413264 "$node_(236) setdest 97104 43334 2.0" 
$ns at 875.1040550360908 "$node_(236) setdest 33490 8602 1.0" 
$ns at 228.96409752921068 "$node_(237) setdest 58873 13607 8.0" 
$ns at 277.01845222991983 "$node_(237) setdest 4864 911 20.0" 
$ns at 366.4780751919676 "$node_(237) setdest 60075 3414 15.0" 
$ns at 513.0700129064162 "$node_(237) setdest 93864 30603 10.0" 
$ns at 545.0494353010106 "$node_(237) setdest 29484 6239 15.0" 
$ns at 636.9964938329545 "$node_(237) setdest 19639 870 19.0" 
$ns at 846.2310515555777 "$node_(237) setdest 117929 33113 1.0" 
$ns at 879.6869188860346 "$node_(237) setdest 115970 2586 2.0" 
$ns at 294.79854834887686 "$node_(238) setdest 108942 37470 10.0" 
$ns at 375.14333156949533 "$node_(238) setdest 106950 23051 6.0" 
$ns at 420.6906576251396 "$node_(238) setdest 61611 12754 15.0" 
$ns at 551.5747486783612 "$node_(238) setdest 117989 15531 7.0" 
$ns at 609.7008952276941 "$node_(238) setdest 53194 31957 19.0" 
$ns at 692.9849361698023 "$node_(238) setdest 86412 19728 15.0" 
$ns at 768.2587446379638 "$node_(238) setdest 115161 33701 12.0" 
$ns at 888.0352298026174 "$node_(238) setdest 46926 18712 12.0" 
$ns at 209.5161057236549 "$node_(239) setdest 110809 44664 18.0" 
$ns at 258.6981547483805 "$node_(239) setdest 43126 27444 18.0" 
$ns at 332.97045587552606 "$node_(239) setdest 112387 25533 13.0" 
$ns at 405.59015106293117 "$node_(239) setdest 90860 3561 14.0" 
$ns at 503.9017673830471 "$node_(239) setdest 30163 19707 7.0" 
$ns at 585.3340576354097 "$node_(239) setdest 87778 40886 6.0" 
$ns at 668.9317560164463 "$node_(239) setdest 58874 42060 16.0" 
$ns at 792.135186946324 "$node_(239) setdest 66997 30799 4.0" 
$ns at 860.1281687558344 "$node_(239) setdest 30517 33917 7.0" 
$ns at 894.5446262072126 "$node_(239) setdest 91331 27337 10.0" 
$ns at 212.38594606145674 "$node_(240) setdest 126955 21677 12.0" 
$ns at 311.15797049364335 "$node_(240) setdest 32901 44272 4.0" 
$ns at 356.0151823886292 "$node_(240) setdest 36240 10807 4.0" 
$ns at 394.42096768770875 "$node_(240) setdest 56018 31772 17.0" 
$ns at 538.3893159939794 "$node_(240) setdest 46209 42763 1.0" 
$ns at 569.343575961984 "$node_(240) setdest 73178 10145 16.0" 
$ns at 734.3015048255954 "$node_(240) setdest 132667 7215 3.0" 
$ns at 784.2232805034782 "$node_(240) setdest 1397 41200 3.0" 
$ns at 825.1447884066058 "$node_(240) setdest 34275 27368 13.0" 
$ns at 328.2997564450951 "$node_(241) setdest 92630 37269 5.0" 
$ns at 380.19659593504207 "$node_(241) setdest 43966 18 2.0" 
$ns at 416.4691845136469 "$node_(241) setdest 29025 42220 4.0" 
$ns at 471.93084858236574 "$node_(241) setdest 115757 13468 16.0" 
$ns at 567.6385001832864 "$node_(241) setdest 120202 18024 16.0" 
$ns at 732.5344127607005 "$node_(241) setdest 44268 4064 4.0" 
$ns at 775.3725117040565 "$node_(241) setdest 86888 12970 7.0" 
$ns at 870.4999591330591 "$node_(241) setdest 40962 40884 6.0" 
$ns at 273.3334054956529 "$node_(242) setdest 56426 2053 5.0" 
$ns at 308.0162255955655 "$node_(242) setdest 76898 706 12.0" 
$ns at 378.38410376250295 "$node_(242) setdest 12597 30474 5.0" 
$ns at 449.7800990736959 "$node_(242) setdest 79286 17313 15.0" 
$ns at 608.3441532388041 "$node_(242) setdest 132629 18920 4.0" 
$ns at 676.2085910844628 "$node_(242) setdest 44130 21466 17.0" 
$ns at 724.764587598811 "$node_(242) setdest 122736 12735 1.0" 
$ns at 756.6788957273111 "$node_(242) setdest 82097 15792 14.0" 
$ns at 805.1827405717386 "$node_(242) setdest 109355 7906 17.0" 
$ns at 863.7647687956313 "$node_(242) setdest 123912 20036 17.0" 
$ns at 294.3020982750294 "$node_(243) setdest 105349 19467 16.0" 
$ns at 343.2298102254928 "$node_(243) setdest 121783 14311 6.0" 
$ns at 382.0792820967805 "$node_(243) setdest 133844 37629 15.0" 
$ns at 510.70270850607994 "$node_(243) setdest 69680 24601 10.0" 
$ns at 621.9105884477781 "$node_(243) setdest 110081 15886 15.0" 
$ns at 773.7953006854957 "$node_(243) setdest 48653 8971 11.0" 
$ns at 218.79394608601623 "$node_(244) setdest 2820 34071 3.0" 
$ns at 268.88894836221243 "$node_(244) setdest 91167 36570 12.0" 
$ns at 337.3418982725452 "$node_(244) setdest 11809 18793 10.0" 
$ns at 408.63912574672645 "$node_(244) setdest 16552 12862 11.0" 
$ns at 532.6902447364059 "$node_(244) setdest 79060 30735 10.0" 
$ns at 627.582667178035 "$node_(244) setdest 69254 23684 1.0" 
$ns at 667.1467350425045 "$node_(244) setdest 79294 28308 17.0" 
$ns at 714.0527899617674 "$node_(244) setdest 25577 35651 3.0" 
$ns at 766.3651573002821 "$node_(244) setdest 82489 28681 2.0" 
$ns at 809.4866142785247 "$node_(244) setdest 119811 17225 10.0" 
$ns at 205.41239831319754 "$node_(245) setdest 26026 11362 9.0" 
$ns at 248.56588972747443 "$node_(245) setdest 91611 17904 15.0" 
$ns at 405.70189480197246 "$node_(245) setdest 98752 24260 2.0" 
$ns at 451.7108261372409 "$node_(245) setdest 38198 29967 15.0" 
$ns at 498.1262562682317 "$node_(245) setdest 36869 20379 4.0" 
$ns at 547.4607780744057 "$node_(245) setdest 21242 33649 4.0" 
$ns at 585.5388708858735 "$node_(245) setdest 96722 12030 1.0" 
$ns at 623.1311198721446 "$node_(245) setdest 20999 17652 12.0" 
$ns at 697.9951463451882 "$node_(245) setdest 85871 19395 16.0" 
$ns at 755.3829865651078 "$node_(245) setdest 86730 31307 1.0" 
$ns at 793.9997274227082 "$node_(245) setdest 123093 1082 12.0" 
$ns at 844.1944986807258 "$node_(245) setdest 38569 10064 13.0" 
$ns at 885.4928295707019 "$node_(245) setdest 73093 662 3.0" 
$ns at 289.2274185049776 "$node_(246) setdest 110776 9569 1.0" 
$ns at 324.0913706565036 "$node_(246) setdest 36543 39287 11.0" 
$ns at 455.6921253713223 "$node_(246) setdest 89898 21762 3.0" 
$ns at 501.4436895019268 "$node_(246) setdest 47160 39275 18.0" 
$ns at 663.5696098721917 "$node_(246) setdest 65054 42894 4.0" 
$ns at 705.6333896140906 "$node_(246) setdest 56696 18229 13.0" 
$ns at 771.9415779582566 "$node_(246) setdest 46982 43046 19.0" 
$ns at 242.57987882364583 "$node_(247) setdest 102088 32792 12.0" 
$ns at 382.64661779712833 "$node_(247) setdest 51665 33254 9.0" 
$ns at 468.58828300294715 "$node_(247) setdest 91927 39827 13.0" 
$ns at 572.3792566384333 "$node_(247) setdest 85285 1761 13.0" 
$ns at 658.565671014702 "$node_(247) setdest 19690 43119 14.0" 
$ns at 808.7917074052083 "$node_(247) setdest 68896 15931 2.0" 
$ns at 844.7318886453811 "$node_(247) setdest 77893 24602 13.0" 
$ns at 215.43481461334494 "$node_(248) setdest 97145 18339 2.0" 
$ns at 257.59120106092587 "$node_(248) setdest 87163 5152 14.0" 
$ns at 334.911909865419 "$node_(248) setdest 87201 39565 14.0" 
$ns at 395.70785160751745 "$node_(248) setdest 363 2331 4.0" 
$ns at 426.63134896039435 "$node_(248) setdest 52801 15688 3.0" 
$ns at 458.9757572696644 "$node_(248) setdest 118638 20282 11.0" 
$ns at 541.0310126103731 "$node_(248) setdest 44367 27181 6.0" 
$ns at 594.1792024148205 "$node_(248) setdest 116388 25850 5.0" 
$ns at 663.7881085150239 "$node_(248) setdest 5787 773 10.0" 
$ns at 697.2575359521362 "$node_(248) setdest 108660 9307 5.0" 
$ns at 745.8837589271884 "$node_(248) setdest 114450 37406 8.0" 
$ns at 831.3827747493751 "$node_(248) setdest 90795 4080 18.0" 
$ns at 865.7518596328351 "$node_(248) setdest 61171 41149 20.0" 
$ns at 329.36104809649584 "$node_(249) setdest 76714 40512 18.0" 
$ns at 479.0834862359542 "$node_(249) setdest 43964 7106 19.0" 
$ns at 637.634289515982 "$node_(249) setdest 83432 33202 19.0" 
$ns at 772.5346308189489 "$node_(249) setdest 77699 993 5.0" 
$ns at 803.7514481147697 "$node_(249) setdest 87666 982 1.0" 
$ns at 838.8995200293804 "$node_(249) setdest 111339 34679 12.0" 
$ns at 869.9032988489562 "$node_(249) setdest 50006 23751 9.0" 
$ns at 239.00011975692468 "$node_(250) setdest 129022 32698 6.0" 
$ns at 293.73964764442945 "$node_(250) setdest 69964 33174 19.0" 
$ns at 468.8758239124652 "$node_(250) setdest 107881 24474 2.0" 
$ns at 509.857313785308 "$node_(250) setdest 107348 34624 12.0" 
$ns at 588.2135421331136 "$node_(250) setdest 105261 32784 15.0" 
$ns at 687.8104659034574 "$node_(250) setdest 130632 38435 12.0" 
$ns at 754.3903228735976 "$node_(250) setdest 116979 20205 1.0" 
$ns at 785.0453976549895 "$node_(250) setdest 4296 44322 18.0" 
$ns at 867.4372789739978 "$node_(250) setdest 39120 27430 5.0" 
$ns at 233.42160910227173 "$node_(251) setdest 20994 29719 1.0" 
$ns at 263.5995782649322 "$node_(251) setdest 52226 29681 12.0" 
$ns at 402.9190898267474 "$node_(251) setdest 128965 27648 5.0" 
$ns at 472.7834590682842 "$node_(251) setdest 100794 33097 15.0" 
$ns at 570.6744489315355 "$node_(251) setdest 40017 16295 4.0" 
$ns at 635.3339211703799 "$node_(251) setdest 67448 14191 5.0" 
$ns at 673.6962104972306 "$node_(251) setdest 92085 35707 1.0" 
$ns at 707.5532959197125 "$node_(251) setdest 47072 20996 10.0" 
$ns at 760.8689153914037 "$node_(251) setdest 113885 22854 16.0" 
$ns at 214.67922124645776 "$node_(252) setdest 36546 42494 2.0" 
$ns at 262.67510475337076 "$node_(252) setdest 5523 11517 10.0" 
$ns at 299.6645124815567 "$node_(252) setdest 6463 12796 14.0" 
$ns at 447.9305978044028 "$node_(252) setdest 96183 5470 7.0" 
$ns at 546.7651403513976 "$node_(252) setdest 104324 24060 6.0" 
$ns at 633.6847771075842 "$node_(252) setdest 15570 13369 3.0" 
$ns at 679.9149619888169 "$node_(252) setdest 131035 37775 7.0" 
$ns at 750.9802122992837 "$node_(252) setdest 73358 27677 6.0" 
$ns at 784.0834260079824 "$node_(252) setdest 5469 16228 11.0" 
$ns at 848.8210272329056 "$node_(252) setdest 20062 28157 14.0" 
$ns at 894.1968050385778 "$node_(252) setdest 16602 27829 18.0" 
$ns at 287.63643582866064 "$node_(253) setdest 47862 40887 16.0" 
$ns at 376.4269890919933 "$node_(253) setdest 10215 29171 1.0" 
$ns at 409.22534231399027 "$node_(253) setdest 33699 6272 19.0" 
$ns at 492.058798342557 "$node_(253) setdest 102861 16787 2.0" 
$ns at 529.0017388558806 "$node_(253) setdest 86413 35579 11.0" 
$ns at 635.8736644466628 "$node_(253) setdest 42012 17003 1.0" 
$ns at 666.8501821179581 "$node_(253) setdest 102265 7798 6.0" 
$ns at 723.5469941369536 "$node_(253) setdest 78491 21877 9.0" 
$ns at 758.9029069981171 "$node_(253) setdest 29442 33716 6.0" 
$ns at 797.5920875672082 "$node_(253) setdest 81790 27990 16.0" 
$ns at 890.1671851596043 "$node_(253) setdest 15075 22368 12.0" 
$ns at 314.45836597382953 "$node_(254) setdest 24766 5937 6.0" 
$ns at 379.78141587493815 "$node_(254) setdest 73968 33251 10.0" 
$ns at 460.3374151904295 "$node_(254) setdest 130781 34147 15.0" 
$ns at 629.7840191875789 "$node_(254) setdest 78618 35320 6.0" 
$ns at 673.3052447619963 "$node_(254) setdest 50745 5436 19.0" 
$ns at 814.211719341607 "$node_(254) setdest 13664 43773 3.0" 
$ns at 849.2964116478616 "$node_(254) setdest 89131 2473 15.0" 
$ns at 266.6774381498024 "$node_(255) setdest 85539 25100 8.0" 
$ns at 299.0135274011634 "$node_(255) setdest 110055 40638 17.0" 
$ns at 375.6093281092003 "$node_(255) setdest 128568 608 4.0" 
$ns at 431.4678173247394 "$node_(255) setdest 63163 42194 3.0" 
$ns at 466.54481429556665 "$node_(255) setdest 70928 34627 1.0" 
$ns at 501.504280484342 "$node_(255) setdest 2469 30190 20.0" 
$ns at 549.8622988503839 "$node_(255) setdest 57202 12012 3.0" 
$ns at 589.4347960781924 "$node_(255) setdest 12538 19865 15.0" 
$ns at 745.0270036756327 "$node_(255) setdest 88935 16457 8.0" 
$ns at 784.8726687218556 "$node_(255) setdest 76672 40626 16.0" 
$ns at 215.08168464325672 "$node_(256) setdest 58180 27114 12.0" 
$ns at 340.04102603241626 "$node_(256) setdest 15011 29614 15.0" 
$ns at 447.06529828350983 "$node_(256) setdest 88170 44 13.0" 
$ns at 591.2634991024872 "$node_(256) setdest 80963 9768 18.0" 
$ns at 664.6862219018464 "$node_(256) setdest 129623 8846 6.0" 
$ns at 718.6082410749264 "$node_(256) setdest 124297 37316 18.0" 
$ns at 766.1444837048817 "$node_(256) setdest 134092 34954 10.0" 
$ns at 877.5560822705628 "$node_(256) setdest 21544 20547 13.0" 
$ns at 316.06871899163775 "$node_(257) setdest 6820 33406 13.0" 
$ns at 408.0713751106314 "$node_(257) setdest 10941 30485 9.0" 
$ns at 510.2473383369961 "$node_(257) setdest 76991 29482 9.0" 
$ns at 564.9940812584633 "$node_(257) setdest 30718 42115 17.0" 
$ns at 724.4884300805209 "$node_(257) setdest 94737 21211 10.0" 
$ns at 755.0688411002465 "$node_(257) setdest 2656 2064 4.0" 
$ns at 791.8998908121309 "$node_(257) setdest 14971 33355 9.0" 
$ns at 872.837242919841 "$node_(257) setdest 30115 42368 17.0" 
$ns at 235.3734660997249 "$node_(258) setdest 52001 9448 8.0" 
$ns at 294.9758916877887 "$node_(258) setdest 116267 21775 7.0" 
$ns at 351.9893703275714 "$node_(258) setdest 45916 29274 15.0" 
$ns at 403.24860259341233 "$node_(258) setdest 64447 521 19.0" 
$ns at 596.150342617381 "$node_(258) setdest 53906 1593 11.0" 
$ns at 731.3386908838464 "$node_(258) setdest 64429 34124 2.0" 
$ns at 765.9279813726798 "$node_(258) setdest 40536 40135 11.0" 
$ns at 846.7112201242185 "$node_(258) setdest 9535 8363 19.0" 
$ns at 896.572124952284 "$node_(258) setdest 98711 35979 15.0" 
$ns at 254.988576045743 "$node_(259) setdest 108738 18993 20.0" 
$ns at 419.1504789520245 "$node_(259) setdest 134029 1272 15.0" 
$ns at 516.1460427191288 "$node_(259) setdest 83135 36346 12.0" 
$ns at 592.3175722027131 "$node_(259) setdest 125095 41167 4.0" 
$ns at 629.0709415640964 "$node_(259) setdest 45925 9992 6.0" 
$ns at 714.0381648934823 "$node_(259) setdest 131170 1685 1.0" 
$ns at 745.5726492088054 "$node_(259) setdest 66 5671 16.0" 
$ns at 777.7347937058214 "$node_(259) setdest 27980 29187 15.0" 
$ns at 852.134737824056 "$node_(259) setdest 48501 35927 4.0" 
$ns at 299.10286542705774 "$node_(260) setdest 67673 24487 18.0" 
$ns at 417.4405433953983 "$node_(260) setdest 54585 15850 19.0" 
$ns at 514.1693985844764 "$node_(260) setdest 87393 25065 7.0" 
$ns at 545.146178841661 "$node_(260) setdest 66627 5925 17.0" 
$ns at 583.2493846357119 "$node_(260) setdest 40432 21760 19.0" 
$ns at 774.3737785815017 "$node_(260) setdest 53111 41272 5.0" 
$ns at 819.5359113304322 "$node_(260) setdest 11676 38493 2.0" 
$ns at 850.5952764171896 "$node_(260) setdest 5951 5433 4.0" 
$ns at 887.7683542387215 "$node_(260) setdest 54121 24193 18.0" 
$ns at 250.58309963467303 "$node_(261) setdest 109466 3414 11.0" 
$ns at 355.4796228674563 "$node_(261) setdest 101368 13700 14.0" 
$ns at 471.5917504976825 "$node_(261) setdest 96698 39854 7.0" 
$ns at 542.4556163222683 "$node_(261) setdest 73006 22325 1.0" 
$ns at 577.8086858825176 "$node_(261) setdest 122625 15920 12.0" 
$ns at 666.9184487686259 "$node_(261) setdest 109116 3086 8.0" 
$ns at 700.3947517637034 "$node_(261) setdest 10563 21637 9.0" 
$ns at 794.887951493339 "$node_(261) setdest 56015 2600 12.0" 
$ns at 876.7285630415704 "$node_(261) setdest 71311 11060 14.0" 
$ns at 220.8910401745702 "$node_(262) setdest 58316 9897 5.0" 
$ns at 292.5478909080219 "$node_(262) setdest 107390 43752 13.0" 
$ns at 439.33435626057735 "$node_(262) setdest 65818 355 6.0" 
$ns at 470.49024201077 "$node_(262) setdest 92448 20018 8.0" 
$ns at 504.4268971815818 "$node_(262) setdest 15534 23701 7.0" 
$ns at 592.5468807785472 "$node_(262) setdest 8888 19596 14.0" 
$ns at 671.0356144887534 "$node_(262) setdest 81510 15952 16.0" 
$ns at 811.5977596014196 "$node_(262) setdest 103098 4574 6.0" 
$ns at 874.410656448189 "$node_(262) setdest 12092 31063 11.0" 
$ns at 238.25474260378755 "$node_(263) setdest 112119 28714 9.0" 
$ns at 340.5810070785912 "$node_(263) setdest 51162 42164 9.0" 
$ns at 446.0639201206144 "$node_(263) setdest 89389 30274 17.0" 
$ns at 478.36638095730075 "$node_(263) setdest 73683 40670 3.0" 
$ns at 532.1863161673191 "$node_(263) setdest 35112 21885 1.0" 
$ns at 565.0189848335283 "$node_(263) setdest 133294 42470 5.0" 
$ns at 619.189539007659 "$node_(263) setdest 25675 41128 19.0" 
$ns at 774.1982882904414 "$node_(263) setdest 42229 44267 6.0" 
$ns at 813.4866086802186 "$node_(263) setdest 72288 40688 19.0" 
$ns at 256.99748128905424 "$node_(264) setdest 96800 37138 1.0" 
$ns at 294.8879917545924 "$node_(264) setdest 53745 12785 12.0" 
$ns at 435.287559272679 "$node_(264) setdest 51113 42026 17.0" 
$ns at 593.4532716238976 "$node_(264) setdest 22292 10807 19.0" 
$ns at 625.716009872451 "$node_(264) setdest 31343 36228 19.0" 
$ns at 817.2559324862784 "$node_(264) setdest 101356 32425 7.0" 
$ns at 867.8493060388715 "$node_(264) setdest 87824 10405 9.0" 
$ns at 234.7516294665475 "$node_(265) setdest 131931 26715 4.0" 
$ns at 283.1600690071057 "$node_(265) setdest 41987 39790 19.0" 
$ns at 385.16433098861813 "$node_(265) setdest 46170 42275 9.0" 
$ns at 504.5122846797887 "$node_(265) setdest 88085 32052 17.0" 
$ns at 558.9756517438308 "$node_(265) setdest 15624 37997 5.0" 
$ns at 597.4640929026297 "$node_(265) setdest 110360 10711 13.0" 
$ns at 716.3695470944078 "$node_(265) setdest 42474 3215 10.0" 
$ns at 843.846713504613 "$node_(265) setdest 111497 16187 5.0" 
$ns at 882.675121474845 "$node_(265) setdest 71349 39688 9.0" 
$ns at 232.5197585767976 "$node_(266) setdest 27365 16508 15.0" 
$ns at 327.8533035175509 "$node_(266) setdest 131968 38707 16.0" 
$ns at 367.1749283293446 "$node_(266) setdest 108065 33313 18.0" 
$ns at 574.951462069455 "$node_(266) setdest 70137 8259 8.0" 
$ns at 609.8987820448822 "$node_(266) setdest 109494 14243 1.0" 
$ns at 649.4125793737106 "$node_(266) setdest 75338 8277 1.0" 
$ns at 680.4085729558658 "$node_(266) setdest 52947 11252 14.0" 
$ns at 843.2140941560635 "$node_(266) setdest 49322 2149 6.0" 
$ns at 217.6105599830785 "$node_(267) setdest 62734 7272 15.0" 
$ns at 347.336936249512 "$node_(267) setdest 48330 5414 15.0" 
$ns at 449.29683577785227 "$node_(267) setdest 99145 10841 13.0" 
$ns at 540.1349697253011 "$node_(267) setdest 61635 29891 14.0" 
$ns at 613.4166934802745 "$node_(267) setdest 29134 37965 17.0" 
$ns at 783.3015954091074 "$node_(267) setdest 2873 6650 6.0" 
$ns at 825.024519929107 "$node_(267) setdest 82941 38569 13.0" 
$ns at 230.0296160812451 "$node_(268) setdest 11575 35087 4.0" 
$ns at 262.79299972772424 "$node_(268) setdest 13156 7453 6.0" 
$ns at 343.4641585545411 "$node_(268) setdest 22351 8539 17.0" 
$ns at 421.397378519976 "$node_(268) setdest 121520 21912 19.0" 
$ns at 558.78482588147 "$node_(268) setdest 12876 16595 16.0" 
$ns at 675.7758613521586 "$node_(268) setdest 71936 12757 3.0" 
$ns at 712.7698286602439 "$node_(268) setdest 57831 30559 1.0" 
$ns at 743.1703334110158 "$node_(268) setdest 66045 41607 9.0" 
$ns at 775.0634070274693 "$node_(268) setdest 15753 37106 2.0" 
$ns at 808.9617994938195 "$node_(268) setdest 114111 4207 6.0" 
$ns at 841.4057589409076 "$node_(268) setdest 110801 35455 12.0" 
$ns at 215.57041783540893 "$node_(269) setdest 63141 3702 10.0" 
$ns at 335.240403559303 "$node_(269) setdest 55572 7762 10.0" 
$ns at 445.50548372314415 "$node_(269) setdest 87124 37200 10.0" 
$ns at 522.1497575159533 "$node_(269) setdest 100137 30386 7.0" 
$ns at 599.5869260889025 "$node_(269) setdest 100532 10370 6.0" 
$ns at 679.1448662027908 "$node_(269) setdest 119118 13766 10.0" 
$ns at 725.2818778981358 "$node_(269) setdest 134023 7555 11.0" 
$ns at 802.4671578302806 "$node_(269) setdest 18862 37883 2.0" 
$ns at 833.8451107568767 "$node_(269) setdest 33663 30665 18.0" 
$ns at 338.4863067901307 "$node_(270) setdest 118827 34239 16.0" 
$ns at 395.1617847193809 "$node_(270) setdest 64962 23412 1.0" 
$ns at 431.6488979833766 "$node_(270) setdest 77372 29725 13.0" 
$ns at 486.9641095540252 "$node_(270) setdest 10816 33280 5.0" 
$ns at 547.9268993444812 "$node_(270) setdest 90887 32852 7.0" 
$ns at 632.0502942728068 "$node_(270) setdest 71318 38616 14.0" 
$ns at 665.7887320613402 "$node_(270) setdest 57742 22512 2.0" 
$ns at 713.7986766582926 "$node_(270) setdest 81037 8691 2.0" 
$ns at 755.7084998463337 "$node_(270) setdest 98122 14316 20.0" 
$ns at 873.9645790297794 "$node_(270) setdest 72618 13830 3.0" 
$ns at 205.31288461023053 "$node_(271) setdest 6503 28531 7.0" 
$ns at 268.72204000587243 "$node_(271) setdest 129647 21133 10.0" 
$ns at 309.07037263867346 "$node_(271) setdest 65957 40652 17.0" 
$ns at 471.656762403904 "$node_(271) setdest 62986 19307 18.0" 
$ns at 680.7966706959756 "$node_(271) setdest 36558 24007 1.0" 
$ns at 716.8206399145864 "$node_(271) setdest 109695 32436 13.0" 
$ns at 843.4133180354601 "$node_(271) setdest 132512 35496 3.0" 
$ns at 201.73686645237223 "$node_(272) setdest 4407 39422 17.0" 
$ns at 263.7097823228748 "$node_(272) setdest 65971 13526 11.0" 
$ns at 401.60278419260663 "$node_(272) setdest 94472 44358 18.0" 
$ns at 473.8088544012239 "$node_(272) setdest 102050 9602 3.0" 
$ns at 509.04441200711386 "$node_(272) setdest 16304 33243 8.0" 
$ns at 544.8127270000566 "$node_(272) setdest 25116 14485 15.0" 
$ns at 617.0491964251337 "$node_(272) setdest 130482 40928 4.0" 
$ns at 670.3167724846966 "$node_(272) setdest 115161 10544 10.0" 
$ns at 757.6412510900459 "$node_(272) setdest 98397 19738 10.0" 
$ns at 837.6671400197995 "$node_(272) setdest 112433 42306 3.0" 
$ns at 894.13491514483 "$node_(272) setdest 36614 22365 1.0" 
$ns at 313.0094722297249 "$node_(273) setdest 92150 4805 8.0" 
$ns at 392.82404512711906 "$node_(273) setdest 99306 25306 1.0" 
$ns at 425.89130252221867 "$node_(273) setdest 87004 3728 18.0" 
$ns at 526.8960807844954 "$node_(273) setdest 44162 5794 1.0" 
$ns at 566.7403871947461 "$node_(273) setdest 82239 9005 1.0" 
$ns at 602.6599392611962 "$node_(273) setdest 102487 6786 20.0" 
$ns at 670.9639780911424 "$node_(273) setdest 82130 31387 10.0" 
$ns at 788.4441628954881 "$node_(273) setdest 102442 6575 6.0" 
$ns at 845.1884980667814 "$node_(273) setdest 117569 10752 6.0" 
$ns at 250.0007108519707 "$node_(274) setdest 85684 29093 4.0" 
$ns at 283.8648358564748 "$node_(274) setdest 73158 429 15.0" 
$ns at 364.9108188099457 "$node_(274) setdest 19733 21497 12.0" 
$ns at 486.3854458081106 "$node_(274) setdest 73411 20738 19.0" 
$ns at 533.008596463404 "$node_(274) setdest 81792 17004 15.0" 
$ns at 621.6204044838164 "$node_(274) setdest 63436 29909 8.0" 
$ns at 668.263075689461 "$node_(274) setdest 63931 32231 1.0" 
$ns at 702.3521442474207 "$node_(274) setdest 82973 11721 3.0" 
$ns at 749.8986744305241 "$node_(274) setdest 7869 24038 16.0" 
$ns at 255.53513248570164 "$node_(275) setdest 17095 27248 4.0" 
$ns at 308.47814419797635 "$node_(275) setdest 48303 16826 7.0" 
$ns at 353.34986464980227 "$node_(275) setdest 46618 33479 16.0" 
$ns at 534.9718837768287 "$node_(275) setdest 23515 1492 2.0" 
$ns at 574.825396168975 "$node_(275) setdest 126583 34093 7.0" 
$ns at 659.6169437107764 "$node_(275) setdest 58524 30287 3.0" 
$ns at 690.116353525604 "$node_(275) setdest 78296 5113 17.0" 
$ns at 815.0805104959429 "$node_(275) setdest 132057 13060 20.0" 
$ns at 300.37059525131514 "$node_(276) setdest 14588 31265 2.0" 
$ns at 342.1116398253072 "$node_(276) setdest 129676 3448 6.0" 
$ns at 396.9746494873531 "$node_(276) setdest 72835 34014 3.0" 
$ns at 430.4772917455171 "$node_(276) setdest 64881 35730 12.0" 
$ns at 531.762948307094 "$node_(276) setdest 102298 42057 1.0" 
$ns at 571.0057818354768 "$node_(276) setdest 71908 16647 19.0" 
$ns at 696.6281079737712 "$node_(276) setdest 99574 8861 15.0" 
$ns at 727.6644869207648 "$node_(276) setdest 3565 7730 7.0" 
$ns at 804.09399090533 "$node_(276) setdest 55964 44704 13.0" 
$ns at 890.7922712341358 "$node_(276) setdest 89776 8469 16.0" 
$ns at 310.82856597674254 "$node_(277) setdest 28595 34663 8.0" 
$ns at 363.2428115191207 "$node_(277) setdest 21609 15943 9.0" 
$ns at 408.6923108084892 "$node_(277) setdest 95803 19247 9.0" 
$ns at 518.8687986351887 "$node_(277) setdest 115303 14085 18.0" 
$ns at 612.2762819869458 "$node_(277) setdest 49502 12262 13.0" 
$ns at 708.6651709274779 "$node_(277) setdest 58276 8837 6.0" 
$ns at 759.3162521693159 "$node_(277) setdest 118929 12617 16.0" 
$ns at 804.225836204107 "$node_(277) setdest 93813 6410 4.0" 
$ns at 850.8489116984516 "$node_(277) setdest 114175 15659 3.0" 
$ns at 896.2542716563322 "$node_(277) setdest 86262 38087 14.0" 
$ns at 286.0749717628621 "$node_(278) setdest 131246 27336 2.0" 
$ns at 324.3949826962351 "$node_(278) setdest 17000 26152 8.0" 
$ns at 393.0328930262666 "$node_(278) setdest 33734 15781 19.0" 
$ns at 598.9272470547506 "$node_(278) setdest 121328 40348 13.0" 
$ns at 650.9516631368111 "$node_(278) setdest 23275 15692 9.0" 
$ns at 756.4023116560261 "$node_(278) setdest 23011 9527 4.0" 
$ns at 791.8633723845428 "$node_(278) setdest 123641 29600 14.0" 
$ns at 836.1204360960817 "$node_(278) setdest 49091 12601 15.0" 
$ns at 899.6258393976678 "$node_(278) setdest 16776 6641 6.0" 
$ns at 294.8074724877771 "$node_(279) setdest 109268 21869 6.0" 
$ns at 368.173675661647 "$node_(279) setdest 100188 36058 15.0" 
$ns at 503.56900676429785 "$node_(279) setdest 54803 14485 16.0" 
$ns at 547.0483451889098 "$node_(279) setdest 10767 3283 20.0" 
$ns at 689.1325551883981 "$node_(279) setdest 4176 24590 3.0" 
$ns at 738.0388280332738 "$node_(279) setdest 25266 28255 14.0" 
$ns at 870.5489015030407 "$node_(279) setdest 120216 34530 10.0" 
$ns at 241.20767065543674 "$node_(280) setdest 26640 29664 19.0" 
$ns at 294.0272558492685 "$node_(280) setdest 25005 13079 19.0" 
$ns at 463.98941293645544 "$node_(280) setdest 82753 16219 18.0" 
$ns at 503.02343713080245 "$node_(280) setdest 52013 40452 15.0" 
$ns at 621.0618871552568 "$node_(280) setdest 54382 9819 11.0" 
$ns at 743.7519017094544 "$node_(280) setdest 61695 22814 5.0" 
$ns at 794.0097366211181 "$node_(280) setdest 124291 43170 7.0" 
$ns at 886.3124931938194 "$node_(280) setdest 110709 4151 9.0" 
$ns at 295.5188007545442 "$node_(281) setdest 9685 38910 15.0" 
$ns at 351.7094077183174 "$node_(281) setdest 60392 24698 19.0" 
$ns at 488.8001543340505 "$node_(281) setdest 101784 29739 13.0" 
$ns at 538.0975476883784 "$node_(281) setdest 11186 15512 13.0" 
$ns at 626.6536915380052 "$node_(281) setdest 129522 23418 9.0" 
$ns at 737.0125712062292 "$node_(281) setdest 70514 4209 5.0" 
$ns at 789.7047770359786 "$node_(281) setdest 132164 5787 11.0" 
$ns at 229.3767852457749 "$node_(282) setdest 71194 21491 7.0" 
$ns at 261.29111827304376 "$node_(282) setdest 33385 35114 14.0" 
$ns at 366.6216309937109 "$node_(282) setdest 95679 32072 4.0" 
$ns at 399.5838367085886 "$node_(282) setdest 71077 5056 6.0" 
$ns at 485.6988050013832 "$node_(282) setdest 66617 31213 5.0" 
$ns at 553.1912010600271 "$node_(282) setdest 10030 32738 17.0" 
$ns at 656.9647122898965 "$node_(282) setdest 54949 41805 12.0" 
$ns at 788.5169204479387 "$node_(282) setdest 52951 8175 3.0" 
$ns at 825.3083744489038 "$node_(282) setdest 49493 23000 12.0" 
$ns at 244.90775144197062 "$node_(283) setdest 52844 27919 8.0" 
$ns at 305.1127169312402 "$node_(283) setdest 2122 6478 17.0" 
$ns at 389.2967385174349 "$node_(283) setdest 117289 38757 18.0" 
$ns at 526.2881321693486 "$node_(283) setdest 70286 25494 4.0" 
$ns at 587.6064304522466 "$node_(283) setdest 9685 6374 18.0" 
$ns at 644.8130276086006 "$node_(283) setdest 91202 38465 2.0" 
$ns at 679.1947427639327 "$node_(283) setdest 111662 18202 5.0" 
$ns at 747.8925855643014 "$node_(283) setdest 33193 12804 18.0" 
$ns at 211.83345379925703 "$node_(284) setdest 32565 8724 10.0" 
$ns at 333.01921613050934 "$node_(284) setdest 87222 39538 10.0" 
$ns at 435.76483858271945 "$node_(284) setdest 123304 10911 6.0" 
$ns at 519.3838865658324 "$node_(284) setdest 37928 39974 17.0" 
$ns at 644.3318043136345 "$node_(284) setdest 129884 1897 6.0" 
$ns at 717.8169616788923 "$node_(284) setdest 102822 43011 1.0" 
$ns at 748.7951115583555 "$node_(284) setdest 102130 11990 14.0" 
$ns at 820.3511892826111 "$node_(284) setdest 111617 27659 18.0" 
$ns at 274.19978576360654 "$node_(285) setdest 8266 2225 14.0" 
$ns at 311.59979856169315 "$node_(285) setdest 133612 35853 1.0" 
$ns at 347.55271361342363 "$node_(285) setdest 124237 35187 7.0" 
$ns at 412.1992999251367 "$node_(285) setdest 47309 18915 13.0" 
$ns at 496.45615630281975 "$node_(285) setdest 72869 36484 14.0" 
$ns at 583.4500221547119 "$node_(285) setdest 101911 37422 2.0" 
$ns at 618.4042893892996 "$node_(285) setdest 115032 28154 18.0" 
$ns at 807.4490264379987 "$node_(285) setdest 133522 30252 17.0" 
$ns at 885.6487454163118 "$node_(285) setdest 80506 18100 6.0" 
$ns at 227.66640976901124 "$node_(286) setdest 104117 21108 9.0" 
$ns at 305.4605399928383 "$node_(286) setdest 58381 32159 7.0" 
$ns at 404.95946222972833 "$node_(286) setdest 114564 14252 14.0" 
$ns at 504.3039864725341 "$node_(286) setdest 123629 20080 19.0" 
$ns at 645.8438144954916 "$node_(286) setdest 121222 3329 18.0" 
$ns at 775.3698491920491 "$node_(286) setdest 108705 22835 13.0" 
$ns at 834.5738514223212 "$node_(286) setdest 121635 22606 15.0" 
$ns at 291.4836261110455 "$node_(287) setdest 98922 7092 13.0" 
$ns at 400.85303769725715 "$node_(287) setdest 12975 24381 4.0" 
$ns at 458.28088845468966 "$node_(287) setdest 41143 18399 1.0" 
$ns at 489.6946644418452 "$node_(287) setdest 38544 17734 10.0" 
$ns at 617.452689496128 "$node_(287) setdest 78517 27533 17.0" 
$ns at 792.3843450567434 "$node_(287) setdest 49977 26831 17.0" 
$ns at 264.5541116782024 "$node_(288) setdest 48442 37318 3.0" 
$ns at 315.1399806675764 "$node_(288) setdest 35964 30086 5.0" 
$ns at 350.9526535585657 "$node_(288) setdest 82026 36148 16.0" 
$ns at 484.3177197575915 "$node_(288) setdest 120928 37832 16.0" 
$ns at 587.9809079408559 "$node_(288) setdest 51749 661 17.0" 
$ns at 676.7816539449927 "$node_(288) setdest 80078 1452 15.0" 
$ns at 838.5460168350476 "$node_(288) setdest 1202 23258 18.0" 
$ns at 343.6604548458595 "$node_(289) setdest 77988 2045 9.0" 
$ns at 439.35518702514037 "$node_(289) setdest 61276 192 20.0" 
$ns at 639.3294704871179 "$node_(289) setdest 57 995 7.0" 
$ns at 672.9106200700451 "$node_(289) setdest 40527 30764 13.0" 
$ns at 703.9214041047456 "$node_(289) setdest 90857 112 8.0" 
$ns at 811.8341704349907 "$node_(289) setdest 105780 5394 7.0" 
$ns at 231.18435630462108 "$node_(290) setdest 69778 36228 6.0" 
$ns at 282.8022069699984 "$node_(290) setdest 11271 8530 18.0" 
$ns at 442.0916254709835 "$node_(290) setdest 118038 3489 16.0" 
$ns at 606.0734748058107 "$node_(290) setdest 15304 44308 11.0" 
$ns at 649.6629628218445 "$node_(290) setdest 1013 43908 4.0" 
$ns at 692.4622386440677 "$node_(290) setdest 29606 28788 19.0" 
$ns at 264.0972334022664 "$node_(291) setdest 33665 43363 12.0" 
$ns at 355.0403618130922 "$node_(291) setdest 103408 36691 9.0" 
$ns at 440.2864266917077 "$node_(291) setdest 69512 7852 7.0" 
$ns at 522.0275166701224 "$node_(291) setdest 41060 18998 17.0" 
$ns at 714.1744840617299 "$node_(291) setdest 122649 7240 4.0" 
$ns at 780.5309712983438 "$node_(291) setdest 99157 16280 13.0" 
$ns at 267.8947145945898 "$node_(292) setdest 78060 35079 6.0" 
$ns at 327.84896395639754 "$node_(292) setdest 122872 5383 3.0" 
$ns at 360.55501932328656 "$node_(292) setdest 20738 18874 10.0" 
$ns at 391.15472837441655 "$node_(292) setdest 43389 1848 8.0" 
$ns at 476.70519210182977 "$node_(292) setdest 127671 39987 4.0" 
$ns at 523.6853821300765 "$node_(292) setdest 120001 12752 1.0" 
$ns at 559.9605345547461 "$node_(292) setdest 63158 20874 5.0" 
$ns at 599.3129579353654 "$node_(292) setdest 9449 24185 3.0" 
$ns at 634.1421916558016 "$node_(292) setdest 5315 18269 16.0" 
$ns at 798.9423986248478 "$node_(292) setdest 128916 21511 12.0" 
$ns at 277.16246817997023 "$node_(293) setdest 538 24847 6.0" 
$ns at 333.39050307505823 "$node_(293) setdest 67644 2204 13.0" 
$ns at 487.61341138979964 "$node_(293) setdest 31273 10436 5.0" 
$ns at 558.6327762910292 "$node_(293) setdest 24474 27071 2.0" 
$ns at 597.230877519211 "$node_(293) setdest 88084 39897 6.0" 
$ns at 667.8516547750086 "$node_(293) setdest 86961 4368 17.0" 
$ns at 772.3750558452867 "$node_(293) setdest 117664 20722 8.0" 
$ns at 828.8328225359755 "$node_(293) setdest 107095 42292 1.0" 
$ns at 860.3256957109032 "$node_(293) setdest 55789 35255 14.0" 
$ns at 276.0221316211743 "$node_(294) setdest 36177 14863 14.0" 
$ns at 391.81294734991866 "$node_(294) setdest 8241 44484 9.0" 
$ns at 477.82368279196555 "$node_(294) setdest 46673 21473 4.0" 
$ns at 532.4387385477077 "$node_(294) setdest 17499 39219 15.0" 
$ns at 629.5522697159471 "$node_(294) setdest 63698 39190 7.0" 
$ns at 678.9291710481705 "$node_(294) setdest 105808 35367 20.0" 
$ns at 842.3686359968121 "$node_(294) setdest 63874 9393 20.0" 
$ns at 266.88288143466247 "$node_(295) setdest 109616 1725 5.0" 
$ns at 329.28831303250945 "$node_(295) setdest 36240 29554 16.0" 
$ns at 484.41518651150386 "$node_(295) setdest 82050 22759 20.0" 
$ns at 534.6222649086787 "$node_(295) setdest 105002 39505 9.0" 
$ns at 574.567452182434 "$node_(295) setdest 29606 32856 8.0" 
$ns at 673.9576286151713 "$node_(295) setdest 121648 24363 11.0" 
$ns at 809.8497302809313 "$node_(295) setdest 37376 25900 8.0" 
$ns at 853.1800083757024 "$node_(295) setdest 29972 39014 8.0" 
$ns at 272.35418080896545 "$node_(296) setdest 41447 9314 4.0" 
$ns at 335.265519448616 "$node_(296) setdest 2718 41601 6.0" 
$ns at 416.45862571932025 "$node_(296) setdest 22885 25848 5.0" 
$ns at 467.33119699749335 "$node_(296) setdest 54907 39118 8.0" 
$ns at 517.2004109901471 "$node_(296) setdest 88998 18770 12.0" 
$ns at 557.5484387823982 "$node_(296) setdest 15782 20730 4.0" 
$ns at 627.5313689352736 "$node_(296) setdest 96852 37714 4.0" 
$ns at 694.4652203532112 "$node_(296) setdest 125920 15133 15.0" 
$ns at 872.3219207430424 "$node_(296) setdest 130408 30417 5.0" 
$ns at 240.41255515017275 "$node_(297) setdest 122084 44038 1.0" 
$ns at 277.01407028469754 "$node_(297) setdest 65847 27402 8.0" 
$ns at 377.6864134802273 "$node_(297) setdest 41355 36586 20.0" 
$ns at 604.9986990116614 "$node_(297) setdest 102243 8318 5.0" 
$ns at 679.0447880532525 "$node_(297) setdest 89914 28808 14.0" 
$ns at 789.2222377468655 "$node_(297) setdest 5200 1805 10.0" 
$ns at 882.6533720935647 "$node_(297) setdest 70551 17575 16.0" 
$ns at 238.7024187181766 "$node_(298) setdest 42857 40394 4.0" 
$ns at 301.06412040253406 "$node_(298) setdest 133825 1586 2.0" 
$ns at 334.8174221602485 "$node_(298) setdest 96629 16626 6.0" 
$ns at 394.79432005405465 "$node_(298) setdest 23947 11328 4.0" 
$ns at 435.71969146020666 "$node_(298) setdest 68684 40956 4.0" 
$ns at 504.74800991794575 "$node_(298) setdest 75849 41000 3.0" 
$ns at 552.8618096000384 "$node_(298) setdest 128206 196 7.0" 
$ns at 613.7262202022525 "$node_(298) setdest 113452 16221 4.0" 
$ns at 654.8077410029956 "$node_(298) setdest 126471 44121 15.0" 
$ns at 688.9321591526616 "$node_(298) setdest 69366 29560 19.0" 
$ns at 859.873862030252 "$node_(298) setdest 23078 29143 1.0" 
$ns at 894.376709028371 "$node_(298) setdest 92081 33470 14.0" 
$ns at 208.85322864184866 "$node_(299) setdest 101292 12725 15.0" 
$ns at 290.5205728577512 "$node_(299) setdest 109445 42057 3.0" 
$ns at 322.09999850737114 "$node_(299) setdest 16425 25404 13.0" 
$ns at 467.31509372484913 "$node_(299) setdest 26980 16620 13.0" 
$ns at 563.7276266352364 "$node_(299) setdest 53456 37762 18.0" 
$ns at 666.1032550369637 "$node_(299) setdest 22948 41749 13.0" 
$ns at 819.6529975504732 "$node_(299) setdest 71363 37585 12.0" 
$ns at 304.9097706896137 "$node_(300) setdest 85984 23450 8.0" 
$ns at 348.5539596085769 "$node_(300) setdest 31815 22517 1.0" 
$ns at 386.0971527264057 "$node_(300) setdest 105422 1961 1.0" 
$ns at 422.77434220615856 "$node_(300) setdest 127402 8361 12.0" 
$ns at 481.5268270471189 "$node_(300) setdest 118395 20043 17.0" 
$ns at 637.1368095743929 "$node_(300) setdest 131820 10103 9.0" 
$ns at 692.7664575893571 "$node_(300) setdest 22351 38507 17.0" 
$ns at 821.4150657928541 "$node_(300) setdest 2183 2904 3.0" 
$ns at 868.7020622968203 "$node_(300) setdest 111525 36397 3.0" 
$ns at 319.91393868283194 "$node_(301) setdest 78081 27557 13.0" 
$ns at 455.1847515412923 "$node_(301) setdest 27366 3692 9.0" 
$ns at 532.5063239615281 "$node_(301) setdest 96216 22894 19.0" 
$ns at 727.1630788755214 "$node_(301) setdest 25995 18070 15.0" 
$ns at 853.7832218412394 "$node_(301) setdest 120266 28025 7.0" 
$ns at 381.3512825379762 "$node_(302) setdest 26464 25247 10.0" 
$ns at 479.6195755008349 "$node_(302) setdest 84672 40346 16.0" 
$ns at 615.8482524868699 "$node_(302) setdest 124237 14349 12.0" 
$ns at 756.1863631294096 "$node_(302) setdest 84091 35652 10.0" 
$ns at 790.365223731709 "$node_(302) setdest 6969 24292 4.0" 
$ns at 836.1591463366707 "$node_(302) setdest 32106 41712 7.0" 
$ns at 881.9208628512981 "$node_(302) setdest 2915 18419 17.0" 
$ns at 326.3154888261355 "$node_(303) setdest 83742 39700 3.0" 
$ns at 361.4353899572757 "$node_(303) setdest 95713 36005 14.0" 
$ns at 432.16239197320397 "$node_(303) setdest 101462 16933 18.0" 
$ns at 591.2140657782172 "$node_(303) setdest 19479 12391 19.0" 
$ns at 677.3852087592188 "$node_(303) setdest 101694 3322 9.0" 
$ns at 774.3778301563593 "$node_(303) setdest 97268 44330 5.0" 
$ns at 829.5935795080238 "$node_(303) setdest 91393 19006 6.0" 
$ns at 888.6227764114664 "$node_(303) setdest 32903 26870 12.0" 
$ns at 326.90296799154936 "$node_(304) setdest 103364 26227 17.0" 
$ns at 435.3346591327983 "$node_(304) setdest 122094 20262 11.0" 
$ns at 566.9576522125199 "$node_(304) setdest 113165 30487 3.0" 
$ns at 625.839116793878 "$node_(304) setdest 88544 40336 11.0" 
$ns at 732.6748273245673 "$node_(304) setdest 24359 30306 4.0" 
$ns at 773.4094188644901 "$node_(304) setdest 50692 11947 14.0" 
$ns at 407.65460414903197 "$node_(305) setdest 34268 27505 2.0" 
$ns at 439.44601032620113 "$node_(305) setdest 58637 26782 9.0" 
$ns at 505.64806818805494 "$node_(305) setdest 20522 16206 3.0" 
$ns at 562.6535335743459 "$node_(305) setdest 65233 42609 15.0" 
$ns at 673.1693911370219 "$node_(305) setdest 23591 19807 3.0" 
$ns at 710.8847121151978 "$node_(305) setdest 20574 41019 19.0" 
$ns at 797.1940243549554 "$node_(305) setdest 32703 16467 9.0" 
$ns at 887.7292175270649 "$node_(305) setdest 106471 22029 8.0" 
$ns at 460.9401244479493 "$node_(306) setdest 114561 31536 13.0" 
$ns at 537.79977884728 "$node_(306) setdest 27451 514 10.0" 
$ns at 650.0070670486195 "$node_(306) setdest 99151 23304 16.0" 
$ns at 807.4445443084564 "$node_(306) setdest 27512 17495 19.0" 
$ns at 408.74532703546447 "$node_(307) setdest 18107 26061 10.0" 
$ns at 450.1140798279572 "$node_(307) setdest 33 15899 1.0" 
$ns at 487.81478366615613 "$node_(307) setdest 72894 37623 9.0" 
$ns at 588.1377790931094 "$node_(307) setdest 120920 825 12.0" 
$ns at 656.478967279263 "$node_(307) setdest 51028 13565 19.0" 
$ns at 717.7699158608052 "$node_(307) setdest 96943 21500 17.0" 
$ns at 857.9204990700295 "$node_(307) setdest 75323 23559 12.0" 
$ns at 324.6750599043959 "$node_(308) setdest 57613 33098 9.0" 
$ns at 414.66361225157004 "$node_(308) setdest 93410 44427 17.0" 
$ns at 456.4048692941978 "$node_(308) setdest 39475 15658 2.0" 
$ns at 501.5804164305348 "$node_(308) setdest 65008 29975 16.0" 
$ns at 597.286536523114 "$node_(308) setdest 9797 25108 3.0" 
$ns at 634.1474408347209 "$node_(308) setdest 114302 23576 14.0" 
$ns at 799.4681124734469 "$node_(308) setdest 42548 40327 18.0" 
$ns at 872.9879794385647 "$node_(308) setdest 7241 35830 11.0" 
$ns at 403.54604003283805 "$node_(309) setdest 48564 153 8.0" 
$ns at 467.3157376219247 "$node_(309) setdest 95156 39931 6.0" 
$ns at 505.6987565728946 "$node_(309) setdest 70148 20678 14.0" 
$ns at 595.0025292055 "$node_(309) setdest 85937 35990 11.0" 
$ns at 676.5422624327595 "$node_(309) setdest 60476 38543 1.0" 
$ns at 711.6768290061747 "$node_(309) setdest 117910 26500 11.0" 
$ns at 829.121060971771 "$node_(309) setdest 13513 44023 5.0" 
$ns at 355.66618364663077 "$node_(310) setdest 14126 37074 2.0" 
$ns at 400.05886470852596 "$node_(310) setdest 66605 30389 14.0" 
$ns at 549.1903390800926 "$node_(310) setdest 11610 19893 18.0" 
$ns at 683.436428292877 "$node_(310) setdest 86796 11316 7.0" 
$ns at 767.9094195539225 "$node_(310) setdest 107997 33618 8.0" 
$ns at 864.7229392366045 "$node_(310) setdest 56299 24560 19.0" 
$ns at 428.99635914755754 "$node_(311) setdest 105955 42147 7.0" 
$ns at 471.6988930141556 "$node_(311) setdest 106466 4052 4.0" 
$ns at 502.5880328693619 "$node_(311) setdest 84729 41361 8.0" 
$ns at 590.6299435871191 "$node_(311) setdest 112098 39410 19.0" 
$ns at 656.6955623514784 "$node_(311) setdest 103032 25717 5.0" 
$ns at 713.4115816209328 "$node_(311) setdest 124991 21440 4.0" 
$ns at 778.0963585788694 "$node_(311) setdest 69600 41752 17.0" 
$ns at 310.52368236217666 "$node_(312) setdest 28939 30861 14.0" 
$ns at 464.3333839835656 "$node_(312) setdest 53829 36548 17.0" 
$ns at 649.3227724939545 "$node_(312) setdest 13682 489 15.0" 
$ns at 725.551451469668 "$node_(312) setdest 66096 21760 4.0" 
$ns at 764.654550527053 "$node_(312) setdest 84338 24522 6.0" 
$ns at 794.9280970738374 "$node_(312) setdest 120659 33507 5.0" 
$ns at 834.5140071215902 "$node_(312) setdest 122903 25218 3.0" 
$ns at 891.5678891829509 "$node_(312) setdest 15076 31465 6.0" 
$ns at 305.09957909262334 "$node_(313) setdest 7012 10843 10.0" 
$ns at 350.58070721226176 "$node_(313) setdest 110635 4990 7.0" 
$ns at 426.2179001037852 "$node_(313) setdest 97087 8056 12.0" 
$ns at 467.9163179816453 "$node_(313) setdest 25886 35484 17.0" 
$ns at 635.9554338077184 "$node_(313) setdest 47124 33297 16.0" 
$ns at 806.4499376130593 "$node_(313) setdest 133304 18596 3.0" 
$ns at 838.9313598337292 "$node_(313) setdest 44968 4609 14.0" 
$ns at 896.1005926895037 "$node_(313) setdest 62100 10627 16.0" 
$ns at 318.71562204813273 "$node_(314) setdest 92248 5188 9.0" 
$ns at 350.12695053867805 "$node_(314) setdest 30778 1775 12.0" 
$ns at 401.1827864344975 "$node_(314) setdest 71598 18560 18.0" 
$ns at 440.00721758739434 "$node_(314) setdest 89892 37845 11.0" 
$ns at 561.7558378419039 "$node_(314) setdest 83887 27493 5.0" 
$ns at 611.4181778083704 "$node_(314) setdest 12927 8610 15.0" 
$ns at 709.8067484168431 "$node_(314) setdest 123098 14513 1.0" 
$ns at 740.8363522703222 "$node_(314) setdest 24025 28459 3.0" 
$ns at 791.6044733613132 "$node_(314) setdest 54379 32588 1.0" 
$ns at 823.7692775137939 "$node_(314) setdest 16736 28202 8.0" 
$ns at 879.6088190981885 "$node_(314) setdest 105679 13509 4.0" 
$ns at 339.0359180388665 "$node_(315) setdest 68685 34739 10.0" 
$ns at 442.84628010589273 "$node_(315) setdest 93554 18888 15.0" 
$ns at 578.6161416001742 "$node_(315) setdest 10723 9256 14.0" 
$ns at 648.8500458463664 "$node_(315) setdest 33499 28808 7.0" 
$ns at 689.8943063578348 "$node_(315) setdest 100051 30288 13.0" 
$ns at 764.4262680098692 "$node_(315) setdest 8171 18170 20.0" 
$ns at 309.1278573615574 "$node_(316) setdest 31416 13988 3.0" 
$ns at 355.44979847271827 "$node_(316) setdest 91539 44454 12.0" 
$ns at 443.10901147721404 "$node_(316) setdest 98527 26238 11.0" 
$ns at 558.1850162239409 "$node_(316) setdest 1390 21285 16.0" 
$ns at 682.1628399400831 "$node_(316) setdest 98110 2138 20.0" 
$ns at 804.4428953220856 "$node_(316) setdest 74489 23771 8.0" 
$ns at 895.0520022746875 "$node_(316) setdest 16799 43071 11.0" 
$ns at 325.05388930310204 "$node_(317) setdest 23046 41025 1.0" 
$ns at 360.699321060158 "$node_(317) setdest 25721 16858 5.0" 
$ns at 423.90861806536304 "$node_(317) setdest 78806 28661 19.0" 
$ns at 557.9286048701953 "$node_(317) setdest 113719 19912 6.0" 
$ns at 603.5797597636746 "$node_(317) setdest 41852 1809 8.0" 
$ns at 692.2314146961869 "$node_(317) setdest 122607 40774 11.0" 
$ns at 748.448117965546 "$node_(317) setdest 124848 38273 3.0" 
$ns at 785.0766495950106 "$node_(317) setdest 13516 33980 19.0" 
$ns at 379.87025633321764 "$node_(318) setdest 128930 21059 12.0" 
$ns at 469.89167918649764 "$node_(318) setdest 34592 25064 13.0" 
$ns at 530.8434310263015 "$node_(318) setdest 119864 24538 12.0" 
$ns at 667.059892292363 "$node_(318) setdest 106036 3044 13.0" 
$ns at 784.0413404920832 "$node_(318) setdest 15452 22800 6.0" 
$ns at 851.5923320870716 "$node_(318) setdest 4255 29258 13.0" 
$ns at 883.5427723617339 "$node_(318) setdest 72837 42264 3.0" 
$ns at 471.947345355243 "$node_(319) setdest 86821 9565 6.0" 
$ns at 528.5486732389327 "$node_(319) setdest 59135 43380 6.0" 
$ns at 615.4102114392416 "$node_(319) setdest 23963 31220 19.0" 
$ns at 805.9171233631772 "$node_(319) setdest 11619 13825 14.0" 
$ns at 366.7666725601054 "$node_(320) setdest 60454 36692 8.0" 
$ns at 468.4073785517975 "$node_(320) setdest 1614 40768 1.0" 
$ns at 505.8271760098491 "$node_(320) setdest 45152 11352 1.0" 
$ns at 542.0502561114299 "$node_(320) setdest 97875 1256 1.0" 
$ns at 573.370690175538 "$node_(320) setdest 2696 38978 4.0" 
$ns at 616.3070292984745 "$node_(320) setdest 34307 25407 18.0" 
$ns at 726.086029312537 "$node_(320) setdest 92810 28285 10.0" 
$ns at 844.7964391414182 "$node_(320) setdest 34417 2831 13.0" 
$ns at 438.2193835299876 "$node_(321) setdest 100091 21931 1.0" 
$ns at 477.62622395040654 "$node_(321) setdest 55490 8047 4.0" 
$ns at 535.1344739799051 "$node_(321) setdest 83393 22536 9.0" 
$ns at 606.8485720701656 "$node_(321) setdest 10807 44148 12.0" 
$ns at 732.1269958209107 "$node_(321) setdest 32495 41621 4.0" 
$ns at 793.0231744965786 "$node_(321) setdest 98028 42531 4.0" 
$ns at 829.512495404231 "$node_(321) setdest 46467 9415 16.0" 
$ns at 302.53629564886114 "$node_(322) setdest 119071 32750 11.0" 
$ns at 388.70070868338297 "$node_(322) setdest 84513 36949 13.0" 
$ns at 455.6425519985 "$node_(322) setdest 52812 17049 7.0" 
$ns at 517.2634013214492 "$node_(322) setdest 25021 25032 20.0" 
$ns at 617.5218770357654 "$node_(322) setdest 101272 26894 9.0" 
$ns at 676.2541483496769 "$node_(322) setdest 17856 22523 9.0" 
$ns at 750.2663844376469 "$node_(322) setdest 83350 39877 6.0" 
$ns at 802.9551312138742 "$node_(322) setdest 90518 15359 1.0" 
$ns at 837.2991105611881 "$node_(322) setdest 121643 4326 4.0" 
$ns at 895.3479101198251 "$node_(322) setdest 104128 28335 15.0" 
$ns at 386.0765572517586 "$node_(323) setdest 57413 32120 16.0" 
$ns at 515.5614688485059 "$node_(323) setdest 74091 25887 20.0" 
$ns at 745.2938821124328 "$node_(323) setdest 35033 10970 7.0" 
$ns at 803.532592335088 "$node_(323) setdest 29101 15671 17.0" 
$ns at 393.6389196568555 "$node_(324) setdest 101397 4274 13.0" 
$ns at 486.4055128348797 "$node_(324) setdest 35906 16160 5.0" 
$ns at 558.048589573798 "$node_(324) setdest 133524 43805 18.0" 
$ns at 630.5094567395363 "$node_(324) setdest 57049 15199 15.0" 
$ns at 767.8554984707471 "$node_(324) setdest 100077 10375 6.0" 
$ns at 810.5694187390749 "$node_(324) setdest 131451 22691 12.0" 
$ns at 331.63218166815255 "$node_(325) setdest 39723 21895 11.0" 
$ns at 420.6002826458536 "$node_(325) setdest 114085 16685 10.0" 
$ns at 482.67066954629416 "$node_(325) setdest 87636 38729 5.0" 
$ns at 530.917984851515 "$node_(325) setdest 133156 1126 14.0" 
$ns at 649.8939082627513 "$node_(325) setdest 99159 19212 13.0" 
$ns at 754.9628407533928 "$node_(325) setdest 71273 9922 9.0" 
$ns at 845.1893228199046 "$node_(325) setdest 19500 15593 19.0" 
$ns at 316.58748724836806 "$node_(326) setdest 121828 2778 1.0" 
$ns at 350.77993736015947 "$node_(326) setdest 96700 36235 7.0" 
$ns at 424.4615134371735 "$node_(326) setdest 133031 36049 17.0" 
$ns at 582.237369274537 "$node_(326) setdest 10805 26815 8.0" 
$ns at 663.2494866304637 "$node_(326) setdest 115572 26042 13.0" 
$ns at 809.4113019696501 "$node_(326) setdest 125869 5057 19.0" 
$ns at 416.50935810366394 "$node_(327) setdest 77121 10913 11.0" 
$ns at 485.83705352859363 "$node_(327) setdest 36769 13841 19.0" 
$ns at 620.8672052166612 "$node_(327) setdest 95411 11906 11.0" 
$ns at 670.7696979034854 "$node_(327) setdest 58344 5681 7.0" 
$ns at 716.4374254678195 "$node_(327) setdest 64310 30401 11.0" 
$ns at 799.1869051507265 "$node_(327) setdest 55562 35287 3.0" 
$ns at 829.4417842555588 "$node_(327) setdest 102900 41339 3.0" 
$ns at 861.4353065160441 "$node_(327) setdest 121584 42426 7.0" 
$ns at 347.30868136005097 "$node_(328) setdest 129600 6930 13.0" 
$ns at 467.3160394738404 "$node_(328) setdest 105838 26133 3.0" 
$ns at 499.70021808356495 "$node_(328) setdest 35084 38151 4.0" 
$ns at 537.8986638198967 "$node_(328) setdest 78419 16701 1.0" 
$ns at 568.505611253792 "$node_(328) setdest 77706 8569 4.0" 
$ns at 612.2978378174873 "$node_(328) setdest 61043 6086 5.0" 
$ns at 686.1147946140974 "$node_(328) setdest 37218 40903 11.0" 
$ns at 758.9375995584999 "$node_(328) setdest 71795 17956 3.0" 
$ns at 803.2913206191449 "$node_(328) setdest 22903 12061 4.0" 
$ns at 861.6341974225653 "$node_(328) setdest 8211 41954 14.0" 
$ns at 365.67560155054457 "$node_(329) setdest 50453 8628 14.0" 
$ns at 473.9135672059134 "$node_(329) setdest 88921 1619 12.0" 
$ns at 551.671610339565 "$node_(329) setdest 9250 32341 3.0" 
$ns at 602.2126325715423 "$node_(329) setdest 53423 10313 2.0" 
$ns at 636.7327907133908 "$node_(329) setdest 75847 22193 1.0" 
$ns at 672.4881010695985 "$node_(329) setdest 127918 38371 1.0" 
$ns at 708.8029295896669 "$node_(329) setdest 61065 4144 10.0" 
$ns at 755.3427833527571 "$node_(329) setdest 132870 5372 9.0" 
$ns at 812.2634133016229 "$node_(329) setdest 13702 42209 16.0" 
$ns at 887.1450825642397 "$node_(329) setdest 93681 36183 7.0" 
$ns at 324.054952068872 "$node_(330) setdest 48107 22632 1.0" 
$ns at 361.2178198257222 "$node_(330) setdest 29110 35217 11.0" 
$ns at 429.2345305735937 "$node_(330) setdest 100826 13903 6.0" 
$ns at 477.0574053801513 "$node_(330) setdest 40973 38913 5.0" 
$ns at 516.9153161348262 "$node_(330) setdest 17962 26622 7.0" 
$ns at 582.5016318979776 "$node_(330) setdest 2176 31771 5.0" 
$ns at 643.5028145627687 "$node_(330) setdest 25196 28258 18.0" 
$ns at 726.3478380054253 "$node_(330) setdest 58675 446 3.0" 
$ns at 759.6658995299051 "$node_(330) setdest 28334 22793 4.0" 
$ns at 813.3490449610694 "$node_(330) setdest 29497 10006 15.0" 
$ns at 856.0912008170479 "$node_(330) setdest 47189 27624 4.0" 
$ns at 899.8622232976368 "$node_(330) setdest 89157 36500 11.0" 
$ns at 388.8434995827381 "$node_(331) setdest 94546 20394 8.0" 
$ns at 474.66126673499497 "$node_(331) setdest 121290 14794 6.0" 
$ns at 557.630229215187 "$node_(331) setdest 86308 15033 17.0" 
$ns at 617.3492165419145 "$node_(331) setdest 99015 8793 3.0" 
$ns at 668.6503290745302 "$node_(331) setdest 57882 10818 4.0" 
$ns at 711.7904684155212 "$node_(331) setdest 33482 3351 7.0" 
$ns at 811.3969607801888 "$node_(331) setdest 113099 36369 3.0" 
$ns at 868.5507677945739 "$node_(331) setdest 48742 14978 5.0" 
$ns at 899.3464760775632 "$node_(331) setdest 56264 29179 6.0" 
$ns at 319.4514693324189 "$node_(332) setdest 59417 19703 9.0" 
$ns at 399.06183132318824 "$node_(332) setdest 107333 18749 3.0" 
$ns at 450.2520249726201 "$node_(332) setdest 11012 10685 14.0" 
$ns at 566.210788417673 "$node_(332) setdest 31538 1340 13.0" 
$ns at 697.6947358646242 "$node_(332) setdest 59010 27782 16.0" 
$ns at 788.8736263730614 "$node_(332) setdest 123356 12341 8.0" 
$ns at 869.8962038158186 "$node_(332) setdest 42447 35687 1.0" 
$ns at 362.56017158839313 "$node_(333) setdest 108275 35346 4.0" 
$ns at 419.19610736997583 "$node_(333) setdest 129168 707 10.0" 
$ns at 526.2565908745031 "$node_(333) setdest 110647 5381 20.0" 
$ns at 742.6223966306135 "$node_(333) setdest 42612 16564 16.0" 
$ns at 845.3402607715017 "$node_(333) setdest 12594 23059 18.0" 
$ns at 303.13938450898775 "$node_(334) setdest 36423 99 19.0" 
$ns at 424.01442117844596 "$node_(334) setdest 1638 41017 13.0" 
$ns at 493.883132566018 "$node_(334) setdest 8589 4711 9.0" 
$ns at 612.533804603681 "$node_(334) setdest 108598 24601 1.0" 
$ns at 648.904725901476 "$node_(334) setdest 4648 26156 13.0" 
$ns at 702.628937695438 "$node_(334) setdest 61400 21270 8.0" 
$ns at 788.8807708992756 "$node_(334) setdest 37624 39346 16.0" 
$ns at 304.32097548786595 "$node_(335) setdest 36988 37838 3.0" 
$ns at 353.8129095802925 "$node_(335) setdest 113328 3904 10.0" 
$ns at 449.3163767899317 "$node_(335) setdest 13826 39804 4.0" 
$ns at 498.91463103550154 "$node_(335) setdest 112361 13897 9.0" 
$ns at 576.7695700273409 "$node_(335) setdest 82986 11618 13.0" 
$ns at 673.0632890906899 "$node_(335) setdest 36977 19962 11.0" 
$ns at 804.6017833603037 "$node_(335) setdest 9984 10397 13.0" 
$ns at 319.1544430960015 "$node_(336) setdest 41553 12165 8.0" 
$ns at 358.9374006580931 "$node_(336) setdest 109270 14304 5.0" 
$ns at 420.2480208344764 "$node_(336) setdest 121545 29613 1.0" 
$ns at 456.6445429458149 "$node_(336) setdest 11363 25964 9.0" 
$ns at 569.7250929965624 "$node_(336) setdest 39612 4894 16.0" 
$ns at 670.4642051216515 "$node_(336) setdest 41342 38001 11.0" 
$ns at 722.9995249954151 "$node_(336) setdest 82298 2634 14.0" 
$ns at 821.574775305835 "$node_(336) setdest 41477 30375 11.0" 
$ns at 347.46603063510986 "$node_(337) setdest 18197 35183 7.0" 
$ns at 381.5470869663045 "$node_(337) setdest 58709 10898 19.0" 
$ns at 484.05082531089386 "$node_(337) setdest 19940 34535 7.0" 
$ns at 569.338986440863 "$node_(337) setdest 101837 31172 4.0" 
$ns at 623.8369559463484 "$node_(337) setdest 39209 24927 20.0" 
$ns at 796.3849519628471 "$node_(337) setdest 25325 8296 20.0" 
$ns at 420.8680323839668 "$node_(338) setdest 8862 40252 9.0" 
$ns at 468.7374358674076 "$node_(338) setdest 41343 9649 6.0" 
$ns at 525.0832233979211 "$node_(338) setdest 66610 40423 16.0" 
$ns at 641.5596953390348 "$node_(338) setdest 52708 44640 10.0" 
$ns at 761.4678727004266 "$node_(338) setdest 34675 6397 7.0" 
$ns at 820.4688314870131 "$node_(338) setdest 114811 37423 14.0" 
$ns at 368.83225782464496 "$node_(339) setdest 73963 19989 7.0" 
$ns at 456.48152622223097 "$node_(339) setdest 70317 26372 19.0" 
$ns at 545.7433127799417 "$node_(339) setdest 29607 39257 19.0" 
$ns at 726.4283279559877 "$node_(339) setdest 7317 28432 14.0" 
$ns at 839.7635392423181 "$node_(339) setdest 27680 35856 6.0" 
$ns at 893.410759988883 "$node_(339) setdest 129782 24330 1.0" 
$ns at 305.04222290995386 "$node_(340) setdest 17847 44120 4.0" 
$ns at 347.126095861719 "$node_(340) setdest 109079 38167 12.0" 
$ns at 459.19262175021845 "$node_(340) setdest 93209 12038 8.0" 
$ns at 516.0161662694438 "$node_(340) setdest 45631 21142 13.0" 
$ns at 580.6640495048431 "$node_(340) setdest 98670 14264 9.0" 
$ns at 662.8948049135953 "$node_(340) setdest 57079 24171 17.0" 
$ns at 714.4588136075876 "$node_(340) setdest 118475 10339 1.0" 
$ns at 745.4968824435133 "$node_(340) setdest 118307 42471 4.0" 
$ns at 807.4099951922615 "$node_(340) setdest 18017 23984 15.0" 
$ns at 864.7189977855036 "$node_(340) setdest 82422 14907 1.0" 
$ns at 894.8483023399976 "$node_(340) setdest 105881 227 4.0" 
$ns at 305.0341518696021 "$node_(341) setdest 81019 15766 17.0" 
$ns at 346.91671007862215 "$node_(341) setdest 89870 19135 17.0" 
$ns at 443.21001920069557 "$node_(341) setdest 19617 41776 8.0" 
$ns at 493.8014557256238 "$node_(341) setdest 9691 37197 4.0" 
$ns at 563.7116857396312 "$node_(341) setdest 44574 3555 18.0" 
$ns at 618.4144179323615 "$node_(341) setdest 5618 42207 6.0" 
$ns at 703.0939395073209 "$node_(341) setdest 80079 41147 16.0" 
$ns at 740.1422395673063 "$node_(341) setdest 107400 15838 18.0" 
$ns at 850.6267123199193 "$node_(341) setdest 68995 14555 14.0" 
$ns at 327.7526874859994 "$node_(342) setdest 6073 40418 12.0" 
$ns at 364.17962895343044 "$node_(342) setdest 94279 21569 2.0" 
$ns at 395.7264102849052 "$node_(342) setdest 62173 7090 14.0" 
$ns at 472.8541753082273 "$node_(342) setdest 67600 35024 10.0" 
$ns at 583.1986161658592 "$node_(342) setdest 25320 34314 19.0" 
$ns at 730.9063839216074 "$node_(342) setdest 109820 24592 18.0" 
$ns at 302.1898946983507 "$node_(343) setdest 56309 34358 9.0" 
$ns at 374.7608123863021 "$node_(343) setdest 62070 39129 15.0" 
$ns at 510.8491979869008 "$node_(343) setdest 78097 19403 17.0" 
$ns at 660.9892047354226 "$node_(343) setdest 90456 7670 19.0" 
$ns at 867.8569388887693 "$node_(343) setdest 119869 29925 12.0" 
$ns at 320.51441568286276 "$node_(344) setdest 67947 25059 14.0" 
$ns at 400.90147670034065 "$node_(344) setdest 70214 24352 5.0" 
$ns at 448.7992065956282 "$node_(344) setdest 58371 7181 6.0" 
$ns at 534.0749800265462 "$node_(344) setdest 113519 17920 1.0" 
$ns at 564.8822076354875 "$node_(344) setdest 19713 24407 5.0" 
$ns at 622.286801517852 "$node_(344) setdest 73806 23043 11.0" 
$ns at 734.2951097626867 "$node_(344) setdest 31930 948 14.0" 
$ns at 794.2186890982791 "$node_(344) setdest 66368 26938 9.0" 
$ns at 449.0701700441035 "$node_(345) setdest 67240 41468 15.0" 
$ns at 608.4655879473986 "$node_(345) setdest 52580 37712 4.0" 
$ns at 649.1797866781087 "$node_(345) setdest 46829 25304 16.0" 
$ns at 778.7990191584902 "$node_(345) setdest 20729 37852 18.0" 
$ns at 417.7610019118931 "$node_(346) setdest 46140 29906 1.0" 
$ns at 451.8599065330789 "$node_(346) setdest 69352 15419 3.0" 
$ns at 509.0585687774507 "$node_(346) setdest 48107 13478 3.0" 
$ns at 542.86442249297 "$node_(346) setdest 54407 6701 15.0" 
$ns at 608.3528119736941 "$node_(346) setdest 128238 34700 18.0" 
$ns at 687.1424574740554 "$node_(346) setdest 113543 7797 13.0" 
$ns at 768.2826946177137 "$node_(346) setdest 12577 8107 18.0" 
$ns at 404.4580406389946 "$node_(347) setdest 121966 5039 6.0" 
$ns at 447.11891835868937 "$node_(347) setdest 104375 32381 3.0" 
$ns at 489.09651138351495 "$node_(347) setdest 88186 8446 1.0" 
$ns at 519.1104975882306 "$node_(347) setdest 35306 5959 1.0" 
$ns at 557.6320133274385 "$node_(347) setdest 43148 13546 2.0" 
$ns at 597.4208487303575 "$node_(347) setdest 38637 18193 16.0" 
$ns at 727.7068347042198 "$node_(347) setdest 83372 24046 13.0" 
$ns at 833.762056067433 "$node_(347) setdest 110363 40978 9.0" 
$ns at 407.1229495527441 "$node_(348) setdest 29877 33189 5.0" 
$ns at 457.17834521749535 "$node_(348) setdest 40737 629 4.0" 
$ns at 512.7191683686021 "$node_(348) setdest 128604 13619 5.0" 
$ns at 589.1488880214649 "$node_(348) setdest 7964 28373 6.0" 
$ns at 673.7693215728289 "$node_(348) setdest 47682 472 6.0" 
$ns at 743.7450001039379 "$node_(348) setdest 33251 1939 9.0" 
$ns at 849.032700386973 "$node_(348) setdest 69340 38591 5.0" 
$ns at 394.6248201587896 "$node_(349) setdest 78544 19735 4.0" 
$ns at 462.72956726473365 "$node_(349) setdest 91831 5945 3.0" 
$ns at 510.45687117960597 "$node_(349) setdest 104625 26578 6.0" 
$ns at 578.5988433741962 "$node_(349) setdest 34464 19212 15.0" 
$ns at 687.2404618542339 "$node_(349) setdest 76546 24064 10.0" 
$ns at 729.8189101983957 "$node_(349) setdest 82729 29227 8.0" 
$ns at 803.1665118735352 "$node_(349) setdest 115175 32940 10.0" 
$ns at 886.0025857764516 "$node_(349) setdest 113200 12394 6.0" 
$ns at 326.7246344575494 "$node_(350) setdest 106403 5470 12.0" 
$ns at 386.49272698233403 "$node_(350) setdest 125584 43030 11.0" 
$ns at 425.46732137532695 "$node_(350) setdest 61810 42256 16.0" 
$ns at 613.0262012024964 "$node_(350) setdest 91781 36519 11.0" 
$ns at 719.5488349170635 "$node_(350) setdest 17740 9202 9.0" 
$ns at 813.154641317406 "$node_(350) setdest 77032 21512 6.0" 
$ns at 849.8332064629811 "$node_(350) setdest 121105 17555 12.0" 
$ns at 422.57059665277046 "$node_(351) setdest 27666 32023 7.0" 
$ns at 505.1392574830943 "$node_(351) setdest 16870 22058 17.0" 
$ns at 633.8214675522037 "$node_(351) setdest 13829 14787 8.0" 
$ns at 686.3347555445523 "$node_(351) setdest 20025 38662 15.0" 
$ns at 789.8988140554316 "$node_(351) setdest 103366 22966 7.0" 
$ns at 845.2508307934482 "$node_(351) setdest 120153 27585 9.0" 
$ns at 333.0719044163058 "$node_(352) setdest 86696 5015 3.0" 
$ns at 380.8096209493485 "$node_(352) setdest 9035 37994 12.0" 
$ns at 501.339031244861 "$node_(352) setdest 17840 3729 9.0" 
$ns at 612.8550274410476 "$node_(352) setdest 46320 20898 12.0" 
$ns at 684.8632959106737 "$node_(352) setdest 250 15945 18.0" 
$ns at 815.5043304413942 "$node_(352) setdest 49588 17172 15.0" 
$ns at 340.81420663594275 "$node_(353) setdest 72442 40398 20.0" 
$ns at 371.3678528264005 "$node_(353) setdest 13939 7167 13.0" 
$ns at 409.7652754508069 "$node_(353) setdest 94264 10603 8.0" 
$ns at 446.38494121349987 "$node_(353) setdest 115541 36430 8.0" 
$ns at 542.5775045134769 "$node_(353) setdest 107863 43081 5.0" 
$ns at 584.1645952377075 "$node_(353) setdest 103057 4822 2.0" 
$ns at 625.3796353621136 "$node_(353) setdest 62462 24710 12.0" 
$ns at 694.6165578756184 "$node_(353) setdest 113904 17092 19.0" 
$ns at 804.5474227529265 "$node_(353) setdest 74448 31795 5.0" 
$ns at 855.1263893912891 "$node_(353) setdest 35880 14381 3.0" 
$ns at 327.0964008842885 "$node_(354) setdest 130087 9874 14.0" 
$ns at 471.6190779935682 "$node_(354) setdest 110660 2649 1.0" 
$ns at 505.79450838351073 "$node_(354) setdest 75056 21932 16.0" 
$ns at 603.2433864470984 "$node_(354) setdest 37016 27560 6.0" 
$ns at 675.6928232357686 "$node_(354) setdest 56308 1884 6.0" 
$ns at 761.928067405234 "$node_(354) setdest 115829 21779 16.0" 
$ns at 869.8266352556631 "$node_(354) setdest 113051 39081 5.0" 
$ns at 315.742857539176 "$node_(355) setdest 118490 27286 5.0" 
$ns at 392.9424469501112 "$node_(355) setdest 127398 1901 17.0" 
$ns at 480.5135374670035 "$node_(355) setdest 110120 10850 14.0" 
$ns at 511.64795576635686 "$node_(355) setdest 111422 21783 20.0" 
$ns at 632.2783931063461 "$node_(355) setdest 69582 16146 18.0" 
$ns at 699.597562701246 "$node_(355) setdest 107111 22702 5.0" 
$ns at 733.6073602890406 "$node_(355) setdest 112839 7680 8.0" 
$ns at 816.1693843867984 "$node_(355) setdest 18859 15313 9.0" 
$ns at 881.2415161625988 "$node_(355) setdest 24629 9418 12.0" 
$ns at 359.39032529351306 "$node_(356) setdest 40700 15002 8.0" 
$ns at 433.16621591685885 "$node_(356) setdest 122459 39231 3.0" 
$ns at 486.15889053232286 "$node_(356) setdest 10180 37650 13.0" 
$ns at 591.0231211982613 "$node_(356) setdest 59245 20657 3.0" 
$ns at 637.7012824879066 "$node_(356) setdest 132319 18939 8.0" 
$ns at 728.2025083054803 "$node_(356) setdest 88330 35855 5.0" 
$ns at 795.566226364474 "$node_(356) setdest 128972 37968 5.0" 
$ns at 838.7452784897288 "$node_(356) setdest 23513 29783 10.0" 
$ns at 878.0112587882131 "$node_(356) setdest 9844 17175 18.0" 
$ns at 326.0889814397107 "$node_(357) setdest 66530 8691 15.0" 
$ns at 384.33963598544403 "$node_(357) setdest 122916 14725 3.0" 
$ns at 424.7503560572928 "$node_(357) setdest 102006 15697 3.0" 
$ns at 466.1334363082599 "$node_(357) setdest 52281 5761 13.0" 
$ns at 523.3352709524844 "$node_(357) setdest 112243 24440 3.0" 
$ns at 564.5023435310621 "$node_(357) setdest 55698 993 16.0" 
$ns at 632.4061221431361 "$node_(357) setdest 4493 6629 15.0" 
$ns at 779.9442373054562 "$node_(357) setdest 12099 42504 16.0" 
$ns at 862.8766108070022 "$node_(357) setdest 69842 28892 13.0" 
$ns at 463.44195181902813 "$node_(358) setdest 6745 42894 4.0" 
$ns at 518.0501280860539 "$node_(358) setdest 90545 42111 14.0" 
$ns at 608.5048908957889 "$node_(358) setdest 17590 21590 15.0" 
$ns at 714.8841408365612 "$node_(358) setdest 83742 28215 2.0" 
$ns at 751.9043869575387 "$node_(358) setdest 2038 16190 19.0" 
$ns at 822.2532826761502 "$node_(358) setdest 47671 10267 2.0" 
$ns at 869.252686481886 "$node_(358) setdest 90110 19926 12.0" 
$ns at 301.9820068174443 "$node_(359) setdest 49566 34350 3.0" 
$ns at 348.6134694838098 "$node_(359) setdest 71480 34613 17.0" 
$ns at 461.52010412388995 "$node_(359) setdest 117087 16066 17.0" 
$ns at 507.8834340301885 "$node_(359) setdest 131535 20236 4.0" 
$ns at 552.3417732151506 "$node_(359) setdest 114941 10891 16.0" 
$ns at 591.625750389032 "$node_(359) setdest 98898 14422 19.0" 
$ns at 810.3710729347602 "$node_(359) setdest 55559 34188 6.0" 
$ns at 858.2214492747124 "$node_(359) setdest 124530 1386 9.0" 
$ns at 342.7069715270083 "$node_(360) setdest 109293 32025 1.0" 
$ns at 382.3112357198169 "$node_(360) setdest 22236 19092 11.0" 
$ns at 511.16837326879335 "$node_(360) setdest 33677 28988 4.0" 
$ns at 570.3172906743323 "$node_(360) setdest 77053 30424 5.0" 
$ns at 618.3055511401928 "$node_(360) setdest 38515 2590 5.0" 
$ns at 671.6433428136074 "$node_(360) setdest 84755 11540 1.0" 
$ns at 703.7040862893231 "$node_(360) setdest 131531 30787 12.0" 
$ns at 806.9595770579762 "$node_(360) setdest 95000 44074 1.0" 
$ns at 842.4563134614732 "$node_(360) setdest 102282 20916 9.0" 
$ns at 423.405344382322 "$node_(361) setdest 70648 2948 3.0" 
$ns at 468.0291084778717 "$node_(361) setdest 125928 18620 10.0" 
$ns at 569.9698694567974 "$node_(361) setdest 36944 12088 9.0" 
$ns at 651.6162758823343 "$node_(361) setdest 25537 3307 12.0" 
$ns at 778.0896809488871 "$node_(361) setdest 3010 26080 6.0" 
$ns at 817.8017567448161 "$node_(361) setdest 104951 8919 3.0" 
$ns at 853.3206972536888 "$node_(361) setdest 7365 40382 5.0" 
$ns at 326.86316304724994 "$node_(362) setdest 132311 4386 3.0" 
$ns at 383.6838752204159 "$node_(362) setdest 104984 26178 1.0" 
$ns at 417.12279494867016 "$node_(362) setdest 49329 34192 13.0" 
$ns at 521.743813676628 "$node_(362) setdest 133250 30985 13.0" 
$ns at 622.3033115867147 "$node_(362) setdest 56241 43846 16.0" 
$ns at 738.3600913977882 "$node_(362) setdest 13884 15832 18.0" 
$ns at 807.992151602357 "$node_(362) setdest 90286 1695 15.0" 
$ns at 843.4048915259496 "$node_(362) setdest 130354 32340 16.0" 
$ns at 317.3821072360379 "$node_(363) setdest 118135 16279 1.0" 
$ns at 356.5776462184804 "$node_(363) setdest 25068 10805 13.0" 
$ns at 482.89177383415506 "$node_(363) setdest 99832 8189 2.0" 
$ns at 528.4444489892209 "$node_(363) setdest 21418 11451 10.0" 
$ns at 645.8792150983915 "$node_(363) setdest 11728 44691 8.0" 
$ns at 708.4102974265525 "$node_(363) setdest 122960 4197 19.0" 
$ns at 757.833790931901 "$node_(363) setdest 27197 41321 1.0" 
$ns at 795.3794852366447 "$node_(363) setdest 122798 18847 20.0" 
$ns at 336.9250590986843 "$node_(364) setdest 17682 10335 17.0" 
$ns at 434.9139729851497 "$node_(364) setdest 107831 24925 12.0" 
$ns at 553.3732610825492 "$node_(364) setdest 14663 10932 12.0" 
$ns at 591.6548298351769 "$node_(364) setdest 80135 44511 1.0" 
$ns at 628.4965707316245 "$node_(364) setdest 127359 34920 16.0" 
$ns at 746.2183684796969 "$node_(364) setdest 67347 44165 11.0" 
$ns at 837.8871428811341 "$node_(364) setdest 6960 32742 5.0" 
$ns at 348.27613477490934 "$node_(365) setdest 4734 7839 6.0" 
$ns at 391.0164946415164 "$node_(365) setdest 88858 19741 2.0" 
$ns at 436.71623626874464 "$node_(365) setdest 92400 28092 5.0" 
$ns at 501.1049819418106 "$node_(365) setdest 71254 36772 8.0" 
$ns at 547.2050033692834 "$node_(365) setdest 72861 40038 18.0" 
$ns at 610.2045740180879 "$node_(365) setdest 86338 41831 5.0" 
$ns at 683.1086783606362 "$node_(365) setdest 113277 14526 19.0" 
$ns at 885.0710659774745 "$node_(365) setdest 107771 26762 1.0" 
$ns at 352.2069435679894 "$node_(366) setdest 106089 23174 13.0" 
$ns at 460.02842068149545 "$node_(366) setdest 24236 27256 1.0" 
$ns at 494.5386482562267 "$node_(366) setdest 18122 3219 5.0" 
$ns at 542.5394030597862 "$node_(366) setdest 16051 10056 19.0" 
$ns at 712.5642401958503 "$node_(366) setdest 64286 22400 18.0" 
$ns at 794.0821379736767 "$node_(366) setdest 51174 18190 10.0" 
$ns at 457.8897625368169 "$node_(367) setdest 65459 1459 7.0" 
$ns at 523.3275102806765 "$node_(367) setdest 118847 35399 19.0" 
$ns at 593.9616046542343 "$node_(367) setdest 96610 31845 14.0" 
$ns at 669.9714870217772 "$node_(367) setdest 48159 36013 17.0" 
$ns at 827.5651217095938 "$node_(367) setdest 22269 33470 3.0" 
$ns at 873.2293964361596 "$node_(367) setdest 784 809 17.0" 
$ns at 365.55451043218153 "$node_(368) setdest 55478 35403 5.0" 
$ns at 402.22618113564835 "$node_(368) setdest 8694 907 11.0" 
$ns at 511.1505216993977 "$node_(368) setdest 126435 19095 19.0" 
$ns at 657.1513431777596 "$node_(368) setdest 17402 13439 4.0" 
$ns at 701.2232140714746 "$node_(368) setdest 32537 14447 3.0" 
$ns at 749.0717364879945 "$node_(368) setdest 12897 25366 16.0" 
$ns at 824.3528118628769 "$node_(368) setdest 51960 28859 14.0" 
$ns at 368.42902437140333 "$node_(369) setdest 64759 27892 9.0" 
$ns at 418.89381545635877 "$node_(369) setdest 1412 14955 5.0" 
$ns at 479.68820976038626 "$node_(369) setdest 42565 2450 2.0" 
$ns at 518.4268368164147 "$node_(369) setdest 20666 14772 13.0" 
$ns at 659.246513637848 "$node_(369) setdest 102502 40409 17.0" 
$ns at 795.3787277867125 "$node_(369) setdest 14224 23731 3.0" 
$ns at 835.1575878557474 "$node_(369) setdest 83473 27166 1.0" 
$ns at 867.3264693597721 "$node_(369) setdest 101907 24985 1.0" 
$ns at 336.7595930227639 "$node_(370) setdest 127134 30699 20.0" 
$ns at 448.5166610132802 "$node_(370) setdest 48260 4314 1.0" 
$ns at 486.52221398685697 "$node_(370) setdest 29920 35158 9.0" 
$ns at 543.5634364605437 "$node_(370) setdest 26239 21989 3.0" 
$ns at 589.2297638275173 "$node_(370) setdest 47385 11281 2.0" 
$ns at 626.0154241840812 "$node_(370) setdest 34597 43912 11.0" 
$ns at 761.12417031263 "$node_(370) setdest 86996 32616 8.0" 
$ns at 858.5165649247185 "$node_(370) setdest 65807 42424 17.0" 
$ns at 314.46491040756086 "$node_(371) setdest 22301 35270 9.0" 
$ns at 387.84797318679296 "$node_(371) setdest 42827 3917 3.0" 
$ns at 442.1307549953148 "$node_(371) setdest 30278 14932 8.0" 
$ns at 529.9536087247973 "$node_(371) setdest 69770 17595 6.0" 
$ns at 591.2474045603506 "$node_(371) setdest 81588 13741 20.0" 
$ns at 663.1843761435032 "$node_(371) setdest 110197 6467 1.0" 
$ns at 700.5845306676578 "$node_(371) setdest 46842 27946 17.0" 
$ns at 863.6058386894747 "$node_(371) setdest 95802 31431 1.0" 
$ns at 895.8530664622486 "$node_(371) setdest 65685 42123 12.0" 
$ns at 314.70090063449635 "$node_(372) setdest 133005 19854 9.0" 
$ns at 406.2721391951859 "$node_(372) setdest 11623 13193 17.0" 
$ns at 502.44024171565934 "$node_(372) setdest 78201 10236 1.0" 
$ns at 533.970496739232 "$node_(372) setdest 117004 12017 2.0" 
$ns at 575.7044756982589 "$node_(372) setdest 126706 43270 9.0" 
$ns at 688.5969281463321 "$node_(372) setdest 108149 22647 2.0" 
$ns at 722.1396294879884 "$node_(372) setdest 122097 37775 4.0" 
$ns at 790.9837657076705 "$node_(372) setdest 119523 21889 7.0" 
$ns at 853.8806839079231 "$node_(372) setdest 94729 42657 1.0" 
$ns at 887.3758038242338 "$node_(372) setdest 100783 17290 11.0" 
$ns at 336.14440229648153 "$node_(373) setdest 120581 23420 4.0" 
$ns at 397.60489385831227 "$node_(373) setdest 127956 34359 11.0" 
$ns at 451.37839418386574 "$node_(373) setdest 56442 20236 17.0" 
$ns at 617.6560406527927 "$node_(373) setdest 87511 5494 19.0" 
$ns at 736.1371154972261 "$node_(373) setdest 118144 42371 6.0" 
$ns at 817.1525565583867 "$node_(373) setdest 84842 34423 4.0" 
$ns at 862.4134976836283 "$node_(373) setdest 18406 2637 15.0" 
$ns at 315.76426983495963 "$node_(374) setdest 97858 25245 12.0" 
$ns at 363.7373710461939 "$node_(374) setdest 107752 10647 5.0" 
$ns at 433.08221551626036 "$node_(374) setdest 102003 16633 18.0" 
$ns at 473.96773772040706 "$node_(374) setdest 63933 20172 9.0" 
$ns at 506.16585198623045 "$node_(374) setdest 82084 42351 3.0" 
$ns at 564.7725198832588 "$node_(374) setdest 11645 40901 3.0" 
$ns at 594.8432750960908 "$node_(374) setdest 20118 40888 7.0" 
$ns at 669.4179190281981 "$node_(374) setdest 71081 24638 18.0" 
$ns at 868.8847000321886 "$node_(374) setdest 93215 39988 19.0" 
$ns at 354.64709078440774 "$node_(375) setdest 2887 6745 12.0" 
$ns at 492.1251886654852 "$node_(375) setdest 22115 6999 1.0" 
$ns at 525.4525532666518 "$node_(375) setdest 83231 6660 9.0" 
$ns at 559.4472691495874 "$node_(375) setdest 48874 26282 15.0" 
$ns at 640.8476823999697 "$node_(375) setdest 69208 8746 20.0" 
$ns at 697.3579810238793 "$node_(375) setdest 109375 15088 6.0" 
$ns at 762.8766923027995 "$node_(375) setdest 66985 32311 9.0" 
$ns at 880.634049676248 "$node_(375) setdest 36552 2266 7.0" 
$ns at 351.0198953211667 "$node_(376) setdest 73777 8317 10.0" 
$ns at 406.3297498554835 "$node_(376) setdest 102499 16819 15.0" 
$ns at 443.08536676538256 "$node_(376) setdest 119737 23429 10.0" 
$ns at 562.53396032103 "$node_(376) setdest 111993 8316 19.0" 
$ns at 600.5872468098707 "$node_(376) setdest 50930 16265 17.0" 
$ns at 653.8423058082659 "$node_(376) setdest 87605 32621 1.0" 
$ns at 684.3547241337097 "$node_(376) setdest 63596 25595 9.0" 
$ns at 753.993000666065 "$node_(376) setdest 96906 6134 11.0" 
$ns at 880.4524951611277 "$node_(376) setdest 8812 21102 1.0" 
$ns at 410.1883227511928 "$node_(377) setdest 25398 11512 8.0" 
$ns at 509.0690067649289 "$node_(377) setdest 103844 11116 13.0" 
$ns at 599.2976310644679 "$node_(377) setdest 16201 5246 15.0" 
$ns at 683.7617691004327 "$node_(377) setdest 124777 23257 5.0" 
$ns at 728.2212827295543 "$node_(377) setdest 10979 37140 7.0" 
$ns at 763.2464873951079 "$node_(377) setdest 104991 32439 6.0" 
$ns at 834.3839679107616 "$node_(377) setdest 122669 41836 8.0" 
$ns at 887.191470255291 "$node_(377) setdest 11893 12236 17.0" 
$ns at 323.8915755135197 "$node_(378) setdest 123177 769 17.0" 
$ns at 513.6268504710324 "$node_(378) setdest 12260 31765 11.0" 
$ns at 581.5813945591711 "$node_(378) setdest 98533 6023 4.0" 
$ns at 617.971625895449 "$node_(378) setdest 60751 8794 8.0" 
$ns at 699.2963505369396 "$node_(378) setdest 88020 43540 11.0" 
$ns at 820.8660412961692 "$node_(378) setdest 71265 10043 19.0" 
$ns at 897.0736654052427 "$node_(378) setdest 111433 5635 3.0" 
$ns at 304.6741386949441 "$node_(379) setdest 127808 3424 3.0" 
$ns at 359.8453666014367 "$node_(379) setdest 58967 21854 6.0" 
$ns at 445.9666958862853 "$node_(379) setdest 35366 36144 9.0" 
$ns at 535.171423833842 "$node_(379) setdest 97336 31105 8.0" 
$ns at 613.6085259562032 "$node_(379) setdest 128289 38161 1.0" 
$ns at 646.3951116736865 "$node_(379) setdest 77426 39492 5.0" 
$ns at 687.8088897094588 "$node_(379) setdest 49131 41526 9.0" 
$ns at 752.1256888441911 "$node_(379) setdest 79182 10140 14.0" 
$ns at 850.7646697819972 "$node_(379) setdest 29627 42094 18.0" 
$ns at 335.7733543248677 "$node_(380) setdest 48324 13257 8.0" 
$ns at 410.6789298197962 "$node_(380) setdest 79880 35079 13.0" 
$ns at 445.28129884461924 "$node_(380) setdest 14875 29646 12.0" 
$ns at 518.0744082275459 "$node_(380) setdest 20935 41839 9.0" 
$ns at 625.9407573645785 "$node_(380) setdest 75577 25210 8.0" 
$ns at 666.7979249801501 "$node_(380) setdest 11459 10732 2.0" 
$ns at 710.0515721517324 "$node_(380) setdest 102694 31516 19.0" 
$ns at 818.2793847552323 "$node_(380) setdest 74053 34170 1.0" 
$ns at 851.4266585924513 "$node_(380) setdest 15843 4851 14.0" 
$ns at 374.57934199570167 "$node_(381) setdest 68400 1099 18.0" 
$ns at 513.3017755321056 "$node_(381) setdest 65039 2482 9.0" 
$ns at 631.3124618905521 "$node_(381) setdest 58005 2601 4.0" 
$ns at 690.3098216418044 "$node_(381) setdest 15499 40039 6.0" 
$ns at 772.6526396749517 "$node_(381) setdest 30485 2443 14.0" 
$ns at 830.264740729858 "$node_(381) setdest 77362 12136 11.0" 
$ns at 869.85553662314 "$node_(381) setdest 3257 19535 14.0" 
$ns at 397.6179321005385 "$node_(382) setdest 67042 37058 1.0" 
$ns at 435.80446196221465 "$node_(382) setdest 122432 26659 18.0" 
$ns at 522.2281885029857 "$node_(382) setdest 76681 14130 11.0" 
$ns at 598.908956742625 "$node_(382) setdest 3461 20075 1.0" 
$ns at 637.84405672283 "$node_(382) setdest 6984 31223 16.0" 
$ns at 827.2359616296225 "$node_(382) setdest 11811 34534 3.0" 
$ns at 882.8814058335173 "$node_(382) setdest 34906 14000 4.0" 
$ns at 338.44691832519476 "$node_(383) setdest 17150 3726 11.0" 
$ns at 415.66938978651456 "$node_(383) setdest 76495 34993 14.0" 
$ns at 548.6845285691886 "$node_(383) setdest 83273 13826 3.0" 
$ns at 583.1589109078287 "$node_(383) setdest 63949 26373 5.0" 
$ns at 628.2975094741058 "$node_(383) setdest 34172 24612 19.0" 
$ns at 659.1150724588128 "$node_(383) setdest 5121 6015 14.0" 
$ns at 692.6064795611892 "$node_(383) setdest 44433 21176 10.0" 
$ns at 773.8060836385789 "$node_(383) setdest 115934 12188 18.0" 
$ns at 424.56959388016327 "$node_(384) setdest 26463 37550 5.0" 
$ns at 498.8106043633877 "$node_(384) setdest 2100 32864 17.0" 
$ns at 567.9252793124999 "$node_(384) setdest 25114 5979 2.0" 
$ns at 605.4523746066852 "$node_(384) setdest 110898 13196 18.0" 
$ns at 716.5321279766987 "$node_(384) setdest 68603 34838 12.0" 
$ns at 773.2610788233773 "$node_(384) setdest 8411 30290 10.0" 
$ns at 857.1021137910416 "$node_(384) setdest 17066 13819 8.0" 
$ns at 417.7914916206582 "$node_(385) setdest 99769 32887 3.0" 
$ns at 473.285359085984 "$node_(385) setdest 61818 6812 12.0" 
$ns at 597.0791244477147 "$node_(385) setdest 86432 20766 1.0" 
$ns at 633.426521674213 "$node_(385) setdest 72695 25950 5.0" 
$ns at 672.7931662860882 "$node_(385) setdest 38841 12593 18.0" 
$ns at 774.453290764346 "$node_(385) setdest 1820 42741 9.0" 
$ns at 890.5800558767071 "$node_(385) setdest 88088 12257 20.0" 
$ns at 326.5927953324183 "$node_(386) setdest 4493 38025 12.0" 
$ns at 392.6123011967821 "$node_(386) setdest 123495 37528 9.0" 
$ns at 506.6941801645157 "$node_(386) setdest 115206 13081 13.0" 
$ns at 541.5204669013843 "$node_(386) setdest 3024 39109 14.0" 
$ns at 598.1411997561248 "$node_(386) setdest 133159 43397 3.0" 
$ns at 642.5821464826429 "$node_(386) setdest 49065 26436 3.0" 
$ns at 692.8912007375682 "$node_(386) setdest 5581 43244 1.0" 
$ns at 728.0040215202669 "$node_(386) setdest 65079 18833 12.0" 
$ns at 823.3371519166888 "$node_(386) setdest 119488 41676 1.0" 
$ns at 860.1612806689762 "$node_(386) setdest 60379 23069 2.0" 
$ns at 318.0253918051028 "$node_(387) setdest 1971 11677 19.0" 
$ns at 524.8539287623493 "$node_(387) setdest 2181 12067 4.0" 
$ns at 560.1361830072161 "$node_(387) setdest 41193 32063 13.0" 
$ns at 617.5655863387015 "$node_(387) setdest 123335 31177 15.0" 
$ns at 657.1099016183716 "$node_(387) setdest 111857 16850 16.0" 
$ns at 830.9380895254693 "$node_(387) setdest 48101 43607 2.0" 
$ns at 862.1741887781263 "$node_(387) setdest 21811 21438 5.0" 
$ns at 898.2632404554574 "$node_(387) setdest 129896 22974 1.0" 
$ns at 358.36905421332585 "$node_(388) setdest 32016 28388 6.0" 
$ns at 419.3794200075718 "$node_(388) setdest 66136 21392 10.0" 
$ns at 497.5375009349632 "$node_(388) setdest 109412 1087 16.0" 
$ns at 532.9453333223211 "$node_(388) setdest 17350 36638 19.0" 
$ns at 596.1055252557377 "$node_(388) setdest 43048 36742 1.0" 
$ns at 630.029139260402 "$node_(388) setdest 67401 12862 4.0" 
$ns at 683.1148941980648 "$node_(388) setdest 56415 33366 16.0" 
$ns at 793.8717107093003 "$node_(388) setdest 106476 4569 2.0" 
$ns at 843.4453047138264 "$node_(388) setdest 47978 4594 9.0" 
$ns at 412.13031005407083 "$node_(389) setdest 26091 14382 10.0" 
$ns at 500.309673774173 "$node_(389) setdest 111024 5066 12.0" 
$ns at 576.660459962859 "$node_(389) setdest 119423 39006 20.0" 
$ns at 625.0736675162769 "$node_(389) setdest 128262 39562 1.0" 
$ns at 660.0922582431596 "$node_(389) setdest 29535 41205 10.0" 
$ns at 765.5394523399009 "$node_(389) setdest 113583 10163 15.0" 
$ns at 820.5629366526241 "$node_(389) setdest 3291 24473 20.0" 
$ns at 321.1397337324627 "$node_(390) setdest 92686 11109 10.0" 
$ns at 430.5087251974636 "$node_(390) setdest 107279 11219 15.0" 
$ns at 464.12117693222234 "$node_(390) setdest 38641 21613 6.0" 
$ns at 498.97052328955056 "$node_(390) setdest 110787 1951 2.0" 
$ns at 531.9775275916957 "$node_(390) setdest 65632 39188 12.0" 
$ns at 562.5619655985688 "$node_(390) setdest 29637 24438 1.0" 
$ns at 594.3348860691453 "$node_(390) setdest 65907 9115 1.0" 
$ns at 628.1423467291914 "$node_(390) setdest 100087 20596 16.0" 
$ns at 761.5366299823831 "$node_(390) setdest 84193 33866 2.0" 
$ns at 808.1080829025105 "$node_(390) setdest 2221 24399 16.0" 
$ns at 380.27773270131155 "$node_(391) setdest 94450 22266 17.0" 
$ns at 547.7926467367693 "$node_(391) setdest 78962 10098 4.0" 
$ns at 598.2410324609771 "$node_(391) setdest 16307 27101 9.0" 
$ns at 692.8950389694082 "$node_(391) setdest 35606 33133 19.0" 
$ns at 822.0126511374416 "$node_(391) setdest 69883 35944 5.0" 
$ns at 882.3538303571667 "$node_(391) setdest 5689 41936 10.0" 
$ns at 312.0155902162309 "$node_(392) setdest 87851 5836 11.0" 
$ns at 359.6007867481318 "$node_(392) setdest 78274 20483 11.0" 
$ns at 472.4901285286625 "$node_(392) setdest 100421 10066 7.0" 
$ns at 527.1739306934555 "$node_(392) setdest 69838 12687 10.0" 
$ns at 619.8810753123004 "$node_(392) setdest 104509 8779 2.0" 
$ns at 664.4569376614614 "$node_(392) setdest 4977 19785 14.0" 
$ns at 797.2492237513242 "$node_(392) setdest 38354 32202 12.0" 
$ns at 868.0294750791516 "$node_(392) setdest 121796 29671 5.0" 
$ns at 329.15517420455564 "$node_(393) setdest 98436 36605 12.0" 
$ns at 404.6582426292985 "$node_(393) setdest 49245 24272 7.0" 
$ns at 484.896197634326 "$node_(393) setdest 45616 35662 10.0" 
$ns at 560.6067140040691 "$node_(393) setdest 71348 34466 11.0" 
$ns at 594.0683431830827 "$node_(393) setdest 22929 6425 7.0" 
$ns at 649.2965870124451 "$node_(393) setdest 84784 39455 15.0" 
$ns at 775.4774269918272 "$node_(393) setdest 96792 35549 1.0" 
$ns at 807.3745415926246 "$node_(393) setdest 2956 24336 2.0" 
$ns at 855.4953966559057 "$node_(393) setdest 73637 7973 6.0" 
$ns at 894.454964771229 "$node_(393) setdest 42051 23968 16.0" 
$ns at 345.7722151142816 "$node_(394) setdest 17386 10624 20.0" 
$ns at 420.753893494474 "$node_(394) setdest 114280 41196 5.0" 
$ns at 451.90988583612597 "$node_(394) setdest 125293 29345 10.0" 
$ns at 517.9808022063776 "$node_(394) setdest 20115 22931 1.0" 
$ns at 549.1073765865917 "$node_(394) setdest 49236 11628 18.0" 
$ns at 731.7562823222854 "$node_(394) setdest 31736 42993 18.0" 
$ns at 832.314236038745 "$node_(394) setdest 18120 18465 8.0" 
$ns at 871.4771676833868 "$node_(394) setdest 84007 42040 16.0" 
$ns at 356.7723949814914 "$node_(395) setdest 40437 28509 7.0" 
$ns at 404.74284618516833 "$node_(395) setdest 47025 6840 6.0" 
$ns at 449.8842740812794 "$node_(395) setdest 108183 31200 7.0" 
$ns at 527.2376700489817 "$node_(395) setdest 66140 31425 17.0" 
$ns at 678.6200739523451 "$node_(395) setdest 20427 30945 19.0" 
$ns at 729.4580730410283 "$node_(395) setdest 75957 6991 5.0" 
$ns at 783.816488754171 "$node_(395) setdest 101452 40191 6.0" 
$ns at 834.7839336900602 "$node_(395) setdest 8028 32929 5.0" 
$ns at 302.8458634773699 "$node_(396) setdest 12356 42058 12.0" 
$ns at 379.4747953236857 "$node_(396) setdest 117720 40015 1.0" 
$ns at 417.8743253460993 "$node_(396) setdest 120897 26499 13.0" 
$ns at 470.25061806816586 "$node_(396) setdest 30345 6376 1.0" 
$ns at 504.37065188268497 "$node_(396) setdest 34609 12387 5.0" 
$ns at 537.1222741264141 "$node_(396) setdest 13917 34073 3.0" 
$ns at 569.7687009771977 "$node_(396) setdest 49186 3410 7.0" 
$ns at 626.4809712070853 "$node_(396) setdest 123792 17555 10.0" 
$ns at 673.2725703496161 "$node_(396) setdest 68246 27590 16.0" 
$ns at 764.333798181003 "$node_(396) setdest 118328 39142 8.0" 
$ns at 801.294897921873 "$node_(396) setdest 121521 16488 3.0" 
$ns at 833.9549402446438 "$node_(396) setdest 21349 43141 6.0" 
$ns at 869.2860679852462 "$node_(396) setdest 77125 10596 4.0" 
$ns at 323.36700471537165 "$node_(397) setdest 102426 40145 4.0" 
$ns at 379.7398542285572 "$node_(397) setdest 17081 42718 7.0" 
$ns at 451.17556885147906 "$node_(397) setdest 105274 29158 2.0" 
$ns at 499.53203268950847 "$node_(397) setdest 95229 36637 4.0" 
$ns at 542.8308847201106 "$node_(397) setdest 74532 205 19.0" 
$ns at 626.0284115440711 "$node_(397) setdest 9783 36532 5.0" 
$ns at 685.3916300871261 "$node_(397) setdest 86835 18459 13.0" 
$ns at 805.3182087350049 "$node_(397) setdest 94252 21767 15.0" 
$ns at 322.7965113582949 "$node_(398) setdest 70851 3296 3.0" 
$ns at 380.5285505485687 "$node_(398) setdest 54315 1472 13.0" 
$ns at 450.0458076250916 "$node_(398) setdest 11058 33480 3.0" 
$ns at 493.4958532900358 "$node_(398) setdest 127765 17655 1.0" 
$ns at 524.9794836612076 "$node_(398) setdest 109005 4521 19.0" 
$ns at 744.3117947070484 "$node_(398) setdest 37912 12702 13.0" 
$ns at 804.7362622363846 "$node_(398) setdest 68334 20249 15.0" 
$ns at 877.8896871057622 "$node_(398) setdest 29500 19981 3.0" 
$ns at 440.9483519514931 "$node_(399) setdest 80121 12533 18.0" 
$ns at 554.4246355560506 "$node_(399) setdest 16691 17009 1.0" 
$ns at 591.1902539620875 "$node_(399) setdest 70710 7022 14.0" 
$ns at 653.1428350458534 "$node_(399) setdest 64047 13588 5.0" 
$ns at 704.6909943705132 "$node_(399) setdest 119166 17206 19.0" 
$ns at 479.201389891081 "$node_(400) setdest 57833 10462 5.0" 
$ns at 533.7164890085597 "$node_(400) setdest 79591 25457 10.0" 
$ns at 611.7524366012226 "$node_(400) setdest 6430 31847 6.0" 
$ns at 673.3362020552806 "$node_(400) setdest 44008 38655 2.0" 
$ns at 708.2471817228413 "$node_(400) setdest 8385 23150 11.0" 
$ns at 747.5668729763854 "$node_(400) setdest 3428 8293 18.0" 
$ns at 889.0225924105165 "$node_(400) setdest 46230 36346 16.0" 
$ns at 454.42241261539095 "$node_(401) setdest 82951 7280 2.0" 
$ns at 498.27515360779415 "$node_(401) setdest 120915 13321 16.0" 
$ns at 606.3415437497741 "$node_(401) setdest 132614 6587 3.0" 
$ns at 656.6140491183274 "$node_(401) setdest 92477 6312 17.0" 
$ns at 855.193108331281 "$node_(401) setdest 97744 26220 2.0" 
$ns at 409.79666971798775 "$node_(402) setdest 102873 43590 8.0" 
$ns at 468.1628548394519 "$node_(402) setdest 119174 14879 20.0" 
$ns at 510.4134655442155 "$node_(402) setdest 62394 4694 1.0" 
$ns at 550.3306496493567 "$node_(402) setdest 39654 1249 15.0" 
$ns at 659.2443171690803 "$node_(402) setdest 74480 42427 10.0" 
$ns at 737.6814104517439 "$node_(402) setdest 2041 38752 19.0" 
$ns at 821.1158159675152 "$node_(402) setdest 954 23463 14.0" 
$ns at 854.8014529517284 "$node_(402) setdest 19381 17651 6.0" 
$ns at 886.9487600812367 "$node_(402) setdest 130289 22121 3.0" 
$ns at 496.0633470329233 "$node_(403) setdest 73438 24946 5.0" 
$ns at 550.7734536114925 "$node_(403) setdest 34874 2632 13.0" 
$ns at 628.8705444433783 "$node_(403) setdest 54521 27554 13.0" 
$ns at 729.1544219595534 "$node_(403) setdest 104048 12077 15.0" 
$ns at 881.9090307160595 "$node_(403) setdest 95589 1967 19.0" 
$ns at 488.28601920343067 "$node_(404) setdest 101365 34330 14.0" 
$ns at 624.3775680034489 "$node_(404) setdest 87884 19072 9.0" 
$ns at 679.9846452396453 "$node_(404) setdest 110486 10308 8.0" 
$ns at 789.2035568424104 "$node_(404) setdest 962 43780 17.0" 
$ns at 534.4231344342908 "$node_(405) setdest 9574 32507 9.0" 
$ns at 649.119575569466 "$node_(405) setdest 102342 42409 8.0" 
$ns at 734.6790407787049 "$node_(405) setdest 94060 34997 16.0" 
$ns at 418.5456404735987 "$node_(406) setdest 122427 6980 17.0" 
$ns at 449.2779172867793 "$node_(406) setdest 68673 17809 10.0" 
$ns at 519.1859862860266 "$node_(406) setdest 32597 41691 1.0" 
$ns at 550.0323790569483 "$node_(406) setdest 121764 29178 6.0" 
$ns at 631.4168890770206 "$node_(406) setdest 1954 37346 10.0" 
$ns at 697.9658752557375 "$node_(406) setdest 1416 33523 14.0" 
$ns at 767.039476553055 "$node_(406) setdest 37504 24961 15.0" 
$ns at 469.1298909495557 "$node_(407) setdest 25425 36174 19.0" 
$ns at 684.5100820949997 "$node_(407) setdest 40641 40474 19.0" 
$ns at 888.1772035841223 "$node_(407) setdest 43575 7395 17.0" 
$ns at 426.53030821733535 "$node_(408) setdest 497 455 18.0" 
$ns at 625.6787225657397 "$node_(408) setdest 42017 36931 7.0" 
$ns at 677.3590497660223 "$node_(408) setdest 90628 43656 7.0" 
$ns at 736.7601534626465 "$node_(408) setdest 22907 24894 7.0" 
$ns at 776.1870248709994 "$node_(408) setdest 76580 5249 8.0" 
$ns at 853.2372589157908 "$node_(408) setdest 70464 32679 15.0" 
$ns at 487.22279983504393 "$node_(409) setdest 44827 43743 11.0" 
$ns at 517.811389783567 "$node_(409) setdest 92624 37144 18.0" 
$ns at 707.7834669295814 "$node_(409) setdest 2914 634 11.0" 
$ns at 768.5031456685366 "$node_(409) setdest 133587 8358 16.0" 
$ns at 851.2236973543012 "$node_(409) setdest 45911 41031 10.0" 
$ns at 479.61655265695504 "$node_(410) setdest 127282 6190 11.0" 
$ns at 555.7516207075815 "$node_(410) setdest 9952 37496 14.0" 
$ns at 673.5119057571204 "$node_(410) setdest 120584 39612 16.0" 
$ns at 811.4206890228536 "$node_(410) setdest 133047 30106 19.0" 
$ns at 440.7253517191261 "$node_(411) setdest 84548 32832 1.0" 
$ns at 471.43888129385226 "$node_(411) setdest 80678 5465 16.0" 
$ns at 616.610870956227 "$node_(411) setdest 32033 11571 13.0" 
$ns at 668.3796187443169 "$node_(411) setdest 11020 27137 20.0" 
$ns at 824.8189998369498 "$node_(411) setdest 131082 19835 2.0" 
$ns at 871.2560729541631 "$node_(411) setdest 64174 2215 5.0" 
$ns at 434.5977335967741 "$node_(412) setdest 85568 40895 5.0" 
$ns at 493.22248284606917 "$node_(412) setdest 95379 23750 1.0" 
$ns at 530.1044280364013 "$node_(412) setdest 98658 12509 20.0" 
$ns at 754.2364032622896 "$node_(412) setdest 84635 15755 15.0" 
$ns at 424.60464266760545 "$node_(413) setdest 127588 44556 10.0" 
$ns at 527.3646307946249 "$node_(413) setdest 29017 4436 11.0" 
$ns at 652.6541775122746 "$node_(413) setdest 116011 12739 2.0" 
$ns at 690.987420578152 "$node_(413) setdest 17880 32982 3.0" 
$ns at 732.7900370781412 "$node_(413) setdest 121606 6680 7.0" 
$ns at 832.025708662572 "$node_(413) setdest 13391 751 13.0" 
$ns at 885.5005882986446 "$node_(413) setdest 55773 38141 16.0" 
$ns at 407.67363489293496 "$node_(414) setdest 28268 9887 2.0" 
$ns at 438.8550401567557 "$node_(414) setdest 60563 37524 19.0" 
$ns at 597.3475880209232 "$node_(414) setdest 20220 33679 3.0" 
$ns at 634.0916678672628 "$node_(414) setdest 98728 26020 14.0" 
$ns at 701.4489701568077 "$node_(414) setdest 29544 6530 5.0" 
$ns at 749.7565748898817 "$node_(414) setdest 119372 19902 1.0" 
$ns at 782.03734911591 "$node_(414) setdest 106239 33884 1.0" 
$ns at 818.3796826806145 "$node_(414) setdest 28903 7442 4.0" 
$ns at 864.669904647235 "$node_(414) setdest 17495 1253 9.0" 
$ns at 407.2760909020934 "$node_(415) setdest 29420 32035 13.0" 
$ns at 548.634917128712 "$node_(415) setdest 106770 9291 19.0" 
$ns at 605.0583562018386 "$node_(415) setdest 92816 44669 3.0" 
$ns at 656.6777766604513 "$node_(415) setdest 99513 27026 15.0" 
$ns at 811.7015654441768 "$node_(415) setdest 35545 13898 13.0" 
$ns at 896.3802894319109 "$node_(415) setdest 81417 9826 17.0" 
$ns at 429.1712949697916 "$node_(416) setdest 32763 39962 10.0" 
$ns at 543.3294663436894 "$node_(416) setdest 119006 11106 7.0" 
$ns at 584.1358936928274 "$node_(416) setdest 93888 33324 16.0" 
$ns at 755.8933833580026 "$node_(416) setdest 70848 312 9.0" 
$ns at 847.4129714022484 "$node_(416) setdest 134122 17457 12.0" 
$ns at 454.8375581336398 "$node_(417) setdest 37174 39255 3.0" 
$ns at 500.6617457161193 "$node_(417) setdest 54858 12786 17.0" 
$ns at 642.1709770602079 "$node_(417) setdest 51025 14867 8.0" 
$ns at 706.6241850177124 "$node_(417) setdest 10559 28343 12.0" 
$ns at 818.217185681515 "$node_(417) setdest 36674 15988 8.0" 
$ns at 418.100862988887 "$node_(418) setdest 28824 12542 16.0" 
$ns at 465.4988991457906 "$node_(418) setdest 89908 24260 7.0" 
$ns at 535.7567560464269 "$node_(418) setdest 115180 17522 6.0" 
$ns at 571.8110837867613 "$node_(418) setdest 57837 11709 1.0" 
$ns at 606.0038007290327 "$node_(418) setdest 108161 18907 1.0" 
$ns at 643.0426321561074 "$node_(418) setdest 684 33449 17.0" 
$ns at 828.1009901087123 "$node_(418) setdest 88495 11544 15.0" 
$ns at 414.00604104898787 "$node_(419) setdest 57441 19067 12.0" 
$ns at 451.3334602278447 "$node_(419) setdest 86422 15415 13.0" 
$ns at 562.0857792570993 "$node_(419) setdest 120718 7481 2.0" 
$ns at 596.177326267129 "$node_(419) setdest 57520 35876 14.0" 
$ns at 759.02710740216 "$node_(419) setdest 72898 29729 19.0" 
$ns at 409.2182720613206 "$node_(420) setdest 57233 1338 20.0" 
$ns at 616.8976632955136 "$node_(420) setdest 107637 32122 7.0" 
$ns at 708.6952971575075 "$node_(420) setdest 6714 2823 2.0" 
$ns at 744.417874566285 "$node_(420) setdest 68421 22804 9.0" 
$ns at 801.3183759882791 "$node_(420) setdest 33690 14678 16.0" 
$ns at 451.552747226473 "$node_(421) setdest 131355 31587 6.0" 
$ns at 539.4953129019972 "$node_(421) setdest 97025 23349 15.0" 
$ns at 638.333315613917 "$node_(421) setdest 5237 42951 4.0" 
$ns at 687.7728001710057 "$node_(421) setdest 17374 8517 19.0" 
$ns at 850.4787918520942 "$node_(421) setdest 114465 20583 6.0" 
$ns at 437.20098218420617 "$node_(422) setdest 74864 31131 1.0" 
$ns at 469.711673588364 "$node_(422) setdest 126363 3818 1.0" 
$ns at 506.339150579479 "$node_(422) setdest 18827 30204 8.0" 
$ns at 573.6823985748333 "$node_(422) setdest 132258 7807 17.0" 
$ns at 756.600218214671 "$node_(422) setdest 91683 18655 16.0" 
$ns at 828.3462467432852 "$node_(422) setdest 73699 10673 20.0" 
$ns at 429.9432803705801 "$node_(423) setdest 116826 15787 10.0" 
$ns at 527.2448567603781 "$node_(423) setdest 76843 14863 13.0" 
$ns at 626.4532549457863 "$node_(423) setdest 79158 23861 6.0" 
$ns at 707.5270664974024 "$node_(423) setdest 20967 32973 6.0" 
$ns at 780.4205660717569 "$node_(423) setdest 15946 37301 13.0" 
$ns at 875.3638365901545 "$node_(423) setdest 36465 39345 9.0" 
$ns at 403.92596967861016 "$node_(424) setdest 97174 38426 15.0" 
$ns at 488.47604275188917 "$node_(424) setdest 101549 5218 13.0" 
$ns at 546.7582890076703 "$node_(424) setdest 118716 38428 14.0" 
$ns at 580.0956301884943 "$node_(424) setdest 93921 17491 10.0" 
$ns at 691.536500456119 "$node_(424) setdest 43119 37335 12.0" 
$ns at 798.1061133436582 "$node_(424) setdest 60827 11685 8.0" 
$ns at 886.0352550779767 "$node_(424) setdest 84935 29258 14.0" 
$ns at 451.3722456829287 "$node_(425) setdest 19621 20199 19.0" 
$ns at 503.21396543832213 "$node_(425) setdest 104501 8619 14.0" 
$ns at 560.3150558118805 "$node_(425) setdest 97954 39964 2.0" 
$ns at 592.2560246589693 "$node_(425) setdest 133423 37730 8.0" 
$ns at 684.6392486337688 "$node_(425) setdest 112429 5706 15.0" 
$ns at 722.3761171970864 "$node_(425) setdest 28842 29773 1.0" 
$ns at 759.646122012087 "$node_(425) setdest 70391 25250 1.0" 
$ns at 796.4480460865595 "$node_(425) setdest 125349 43500 4.0" 
$ns at 857.6624210281066 "$node_(425) setdest 128944 2201 12.0" 
$ns at 502.30552854948064 "$node_(426) setdest 34508 41983 10.0" 
$ns at 619.0365097958044 "$node_(426) setdest 41756 6124 18.0" 
$ns at 682.157425947552 "$node_(426) setdest 13457 17935 20.0" 
$ns at 770.7995448092815 "$node_(426) setdest 32666 5572 13.0" 
$ns at 889.1220648553048 "$node_(426) setdest 549 16321 20.0" 
$ns at 439.72037081353807 "$node_(427) setdest 101733 41229 14.0" 
$ns at 487.3212884008596 "$node_(427) setdest 17544 39275 14.0" 
$ns at 618.5353984485351 "$node_(427) setdest 107874 36514 15.0" 
$ns at 662.75495097933 "$node_(427) setdest 108262 3131 2.0" 
$ns at 696.8492037423796 "$node_(427) setdest 54736 35615 11.0" 
$ns at 782.1219495961424 "$node_(427) setdest 132643 6623 3.0" 
$ns at 833.4031973365227 "$node_(427) setdest 6092 16141 17.0" 
$ns at 871.6248693492809 "$node_(427) setdest 9037 4868 18.0" 
$ns at 426.8431755859359 "$node_(428) setdest 26455 23269 1.0" 
$ns at 459.91128308331247 "$node_(428) setdest 76600 38944 6.0" 
$ns at 517.5967695126782 "$node_(428) setdest 46365 30197 9.0" 
$ns at 601.5729805417092 "$node_(428) setdest 43622 5672 11.0" 
$ns at 686.3614596911353 "$node_(428) setdest 103589 16896 1.0" 
$ns at 720.3801228290693 "$node_(428) setdest 116414 4601 2.0" 
$ns at 751.7970851959666 "$node_(428) setdest 97097 42986 3.0" 
$ns at 800.4464450883645 "$node_(428) setdest 29183 38868 4.0" 
$ns at 863.59275428235 "$node_(428) setdest 43632 37778 3.0" 
$ns at 421.8910694976476 "$node_(429) setdest 45483 11579 7.0" 
$ns at 464.61083050010495 "$node_(429) setdest 70633 17549 7.0" 
$ns at 552.4765230743047 "$node_(429) setdest 19759 24248 7.0" 
$ns at 607.1072531755905 "$node_(429) setdest 4095 64 12.0" 
$ns at 690.7945276679357 "$node_(429) setdest 16724 22800 2.0" 
$ns at 727.4716289421456 "$node_(429) setdest 118605 15586 10.0" 
$ns at 833.0112430236 "$node_(429) setdest 118707 25778 17.0" 
$ns at 410.8447053246727 "$node_(430) setdest 27296 7419 17.0" 
$ns at 459.30955394190175 "$node_(430) setdest 109375 19040 3.0" 
$ns at 490.8260073220432 "$node_(430) setdest 23594 21816 18.0" 
$ns at 607.5257856676666 "$node_(430) setdest 62410 9529 11.0" 
$ns at 715.6414739128141 "$node_(430) setdest 75704 32456 7.0" 
$ns at 757.956251977512 "$node_(430) setdest 95050 34889 12.0" 
$ns at 796.6175923412205 "$node_(430) setdest 11226 36075 4.0" 
$ns at 852.513565617832 "$node_(430) setdest 54350 6487 3.0" 
$ns at 896.7997050327039 "$node_(430) setdest 131938 17191 17.0" 
$ns at 447.01509000416155 "$node_(431) setdest 64252 29775 1.0" 
$ns at 484.78807996866203 "$node_(431) setdest 54356 34727 1.0" 
$ns at 517.7214987438193 "$node_(431) setdest 121379 15709 13.0" 
$ns at 673.3883393778434 "$node_(431) setdest 37669 35560 11.0" 
$ns at 759.568496675497 "$node_(431) setdest 118940 24933 5.0" 
$ns at 817.138861330535 "$node_(431) setdest 2254 2775 1.0" 
$ns at 854.4529942452253 "$node_(431) setdest 74652 32169 4.0" 
$ns at 449.0630324103581 "$node_(432) setdest 89881 31546 10.0" 
$ns at 574.9363368424281 "$node_(432) setdest 32971 23322 18.0" 
$ns at 700.1723858576436 "$node_(432) setdest 131976 39237 13.0" 
$ns at 848.607365135777 "$node_(432) setdest 123144 37239 5.0" 
$ns at 401.71373842231765 "$node_(433) setdest 65525 22117 14.0" 
$ns at 506.12419135555695 "$node_(433) setdest 8115 37977 12.0" 
$ns at 617.5994291159992 "$node_(433) setdest 19786 37860 3.0" 
$ns at 648.3054305138843 "$node_(433) setdest 103078 42933 5.0" 
$ns at 717.4003668905946 "$node_(433) setdest 26914 22655 11.0" 
$ns at 832.8005138380106 "$node_(433) setdest 14136 17535 19.0" 
$ns at 502.41786042312947 "$node_(434) setdest 120333 15693 20.0" 
$ns at 617.6451971817717 "$node_(434) setdest 89105 10480 13.0" 
$ns at 770.2618301278026 "$node_(434) setdest 7444 3165 1.0" 
$ns at 800.6436793845539 "$node_(434) setdest 93374 35778 13.0" 
$ns at 475.0958632878536 "$node_(435) setdest 44085 28368 14.0" 
$ns at 540.1164683799975 "$node_(435) setdest 28639 16654 9.0" 
$ns at 583.1185028432775 "$node_(435) setdest 43569 9593 5.0" 
$ns at 639.3875488474392 "$node_(435) setdest 25051 8337 10.0" 
$ns at 762.4449134426417 "$node_(435) setdest 36751 31257 7.0" 
$ns at 800.2082634342646 "$node_(435) setdest 98284 43623 13.0" 
$ns at 883.7592050020776 "$node_(435) setdest 76545 21804 1.0" 
$ns at 467.4121036780875 "$node_(436) setdest 83987 39840 13.0" 
$ns at 500.53257872551217 "$node_(436) setdest 105602 33550 4.0" 
$ns at 544.6927080339394 "$node_(436) setdest 70911 36458 11.0" 
$ns at 597.3107761364274 "$node_(436) setdest 17820 36722 16.0" 
$ns at 769.9569346034525 "$node_(436) setdest 8015 43331 5.0" 
$ns at 810.7028546612692 "$node_(436) setdest 90800 29533 11.0" 
$ns at 416.66599891083695 "$node_(437) setdest 108979 5369 10.0" 
$ns at 526.7507202581832 "$node_(437) setdest 76684 44686 9.0" 
$ns at 643.3252234759657 "$node_(437) setdest 85058 27750 18.0" 
$ns at 688.8429858165789 "$node_(437) setdest 93640 21527 13.0" 
$ns at 829.4332499036476 "$node_(437) setdest 24805 14382 1.0" 
$ns at 865.6069563703201 "$node_(437) setdest 68957 14491 4.0" 
$ns at 447.7674410903651 "$node_(438) setdest 68624 14922 10.0" 
$ns at 551.6688170288285 "$node_(438) setdest 84553 6809 3.0" 
$ns at 594.533222277735 "$node_(438) setdest 12814 31153 8.0" 
$ns at 628.0840766329909 "$node_(438) setdest 98999 9209 10.0" 
$ns at 709.8656126102376 "$node_(438) setdest 5393 43211 9.0" 
$ns at 750.3181544523823 "$node_(438) setdest 607 38441 19.0" 
$ns at 833.1420059927922 "$node_(438) setdest 43784 5331 11.0" 
$ns at 431.71861832484876 "$node_(439) setdest 3624 44410 10.0" 
$ns at 551.0618362312832 "$node_(439) setdest 28904 37588 13.0" 
$ns at 664.774879185532 "$node_(439) setdest 3127 39360 7.0" 
$ns at 700.4470581289955 "$node_(439) setdest 130928 18663 8.0" 
$ns at 804.0181944754379 "$node_(439) setdest 75854 32974 8.0" 
$ns at 877.7895798636313 "$node_(439) setdest 129410 30730 10.0" 
$ns at 452.4023450527171 "$node_(440) setdest 94262 2739 3.0" 
$ns at 491.6817951531367 "$node_(440) setdest 32418 12070 18.0" 
$ns at 532.6959058248274 "$node_(440) setdest 74426 41286 3.0" 
$ns at 590.737315693504 "$node_(440) setdest 36080 3223 9.0" 
$ns at 645.5512604085658 "$node_(440) setdest 92243 29628 11.0" 
$ns at 768.1010464311819 "$node_(440) setdest 59748 9580 16.0" 
$ns at 494.7696569906227 "$node_(441) setdest 133225 10356 5.0" 
$ns at 565.2629206347297 "$node_(441) setdest 81445 4530 6.0" 
$ns at 600.2484846320322 "$node_(441) setdest 67547 37624 11.0" 
$ns at 738.8235123546765 "$node_(441) setdest 112423 31515 6.0" 
$ns at 771.8216865227555 "$node_(441) setdest 97859 17430 9.0" 
$ns at 861.9703947145995 "$node_(441) setdest 34918 41801 12.0" 
$ns at 475.68267837729 "$node_(442) setdest 3711 29948 17.0" 
$ns at 672.9778269912025 "$node_(442) setdest 39381 14951 10.0" 
$ns at 788.0957872075061 "$node_(442) setdest 113239 13905 15.0" 
$ns at 832.7896889506276 "$node_(442) setdest 121487 13870 5.0" 
$ns at 884.1640572102436 "$node_(442) setdest 1676 3555 15.0" 
$ns at 527.4017458910762 "$node_(443) setdest 64382 5408 11.0" 
$ns at 576.3134388743481 "$node_(443) setdest 122263 25331 12.0" 
$ns at 707.9380044994828 "$node_(443) setdest 50133 40053 19.0" 
$ns at 769.8892835218957 "$node_(443) setdest 14524 39805 18.0" 
$ns at 452.93730052025353 "$node_(444) setdest 51811 15201 5.0" 
$ns at 530.330216301933 "$node_(444) setdest 70278 28506 5.0" 
$ns at 590.7336853093469 "$node_(444) setdest 69159 10783 9.0" 
$ns at 633.1621797754352 "$node_(444) setdest 58127 33914 1.0" 
$ns at 670.7638859842297 "$node_(444) setdest 102443 28841 14.0" 
$ns at 790.0998381232392 "$node_(444) setdest 81886 24533 7.0" 
$ns at 825.8233918405849 "$node_(444) setdest 131702 12702 4.0" 
$ns at 868.8180207950606 "$node_(444) setdest 35897 5606 2.0" 
$ns at 433.19892368103126 "$node_(445) setdest 81221 27926 3.0" 
$ns at 480.13475428972407 "$node_(445) setdest 3442 41163 13.0" 
$ns at 583.9166252697627 "$node_(445) setdest 7808 23658 20.0" 
$ns at 711.374848182547 "$node_(445) setdest 35356 22157 3.0" 
$ns at 752.5925233277994 "$node_(445) setdest 101643 43800 15.0" 
$ns at 871.2519080626305 "$node_(445) setdest 128817 21856 18.0" 
$ns at 444.35016676623127 "$node_(446) setdest 32254 9778 9.0" 
$ns at 503.03225480464994 "$node_(446) setdest 99692 31036 3.0" 
$ns at 551.7126622455595 "$node_(446) setdest 7628 31959 4.0" 
$ns at 611.0202381860977 "$node_(446) setdest 40007 42007 11.0" 
$ns at 647.3251528666365 "$node_(446) setdest 83730 15175 9.0" 
$ns at 716.6454898540162 "$node_(446) setdest 133536 1321 8.0" 
$ns at 757.266775138187 "$node_(446) setdest 11223 37762 16.0" 
$ns at 791.9625572882404 "$node_(446) setdest 18594 8299 3.0" 
$ns at 849.0320161569985 "$node_(446) setdest 25336 41269 10.0" 
$ns at 423.0445889426648 "$node_(447) setdest 69194 23040 13.0" 
$ns at 528.7010801716737 "$node_(447) setdest 112712 9349 18.0" 
$ns at 618.2202081318646 "$node_(447) setdest 80365 15236 8.0" 
$ns at 678.1462486407717 "$node_(447) setdest 48385 30079 16.0" 
$ns at 827.8582360967627 "$node_(447) setdest 123859 943 16.0" 
$ns at 437.3271518291761 "$node_(448) setdest 68289 10367 4.0" 
$ns at 477.8369550728065 "$node_(448) setdest 123357 27649 5.0" 
$ns at 536.1994492148706 "$node_(448) setdest 65742 28381 1.0" 
$ns at 572.7762724955139 "$node_(448) setdest 99482 6027 16.0" 
$ns at 714.9123179272736 "$node_(448) setdest 12264 8600 5.0" 
$ns at 752.5494126309165 "$node_(448) setdest 32945 28176 17.0" 
$ns at 400.96215746269075 "$node_(449) setdest 109713 17965 18.0" 
$ns at 581.294748386656 "$node_(449) setdest 88897 39607 11.0" 
$ns at 664.2548526319679 "$node_(449) setdest 80686 41056 10.0" 
$ns at 768.2629408971095 "$node_(449) setdest 67599 36560 5.0" 
$ns at 841.2226635085184 "$node_(449) setdest 118274 15574 1.0" 
$ns at 874.369622107638 "$node_(449) setdest 14259 9277 12.0" 
$ns at 432.28524373834676 "$node_(450) setdest 133347 32959 17.0" 
$ns at 529.3430043984996 "$node_(450) setdest 15146 39479 1.0" 
$ns at 568.1268624999764 "$node_(450) setdest 70954 14931 5.0" 
$ns at 640.0263124903013 "$node_(450) setdest 33504 20270 4.0" 
$ns at 709.4107086399612 "$node_(450) setdest 78083 13344 12.0" 
$ns at 811.0523395096214 "$node_(450) setdest 18119 2727 5.0" 
$ns at 887.0741067760157 "$node_(450) setdest 96900 14356 18.0" 
$ns at 406.5788569574386 "$node_(451) setdest 92091 26402 9.0" 
$ns at 458.8222127092208 "$node_(451) setdest 98247 12141 17.0" 
$ns at 554.9546403900931 "$node_(451) setdest 109582 34943 11.0" 
$ns at 689.4399361509746 "$node_(451) setdest 48582 23390 20.0" 
$ns at 885.2190517916545 "$node_(451) setdest 1947 1419 17.0" 
$ns at 435.518232011583 "$node_(452) setdest 48926 38072 18.0" 
$ns at 602.8196552369284 "$node_(452) setdest 127599 8594 4.0" 
$ns at 671.8303189651792 "$node_(452) setdest 60334 13558 16.0" 
$ns at 859.5892376687718 "$node_(452) setdest 30530 35031 16.0" 
$ns at 453.8226047123508 "$node_(453) setdest 19027 4351 4.0" 
$ns at 507.16983980210944 "$node_(453) setdest 44661 23527 1.0" 
$ns at 537.3767588673161 "$node_(453) setdest 48199 3844 4.0" 
$ns at 580.5869259652559 "$node_(453) setdest 52993 14374 3.0" 
$ns at 612.4767723897053 "$node_(453) setdest 67041 29678 20.0" 
$ns at 827.4897845908469 "$node_(453) setdest 102579 30322 13.0" 
$ns at 424.77190614149123 "$node_(454) setdest 66149 17328 3.0" 
$ns at 459.71186729146126 "$node_(454) setdest 91372 21912 3.0" 
$ns at 493.4942064588519 "$node_(454) setdest 62114 6945 4.0" 
$ns at 537.8861437663252 "$node_(454) setdest 86207 31538 16.0" 
$ns at 639.1053734976105 "$node_(454) setdest 121217 36617 18.0" 
$ns at 692.7959613938102 "$node_(454) setdest 12410 29570 2.0" 
$ns at 725.26269144047 "$node_(454) setdest 76173 33164 11.0" 
$ns at 810.239298472596 "$node_(454) setdest 66693 9089 9.0" 
$ns at 853.6075547160535 "$node_(454) setdest 31733 31044 4.0" 
$ns at 419.0616966776028 "$node_(455) setdest 16652 25242 9.0" 
$ns at 507.33434580399233 "$node_(455) setdest 23772 29897 1.0" 
$ns at 546.9700426716959 "$node_(455) setdest 76369 9511 10.0" 
$ns at 583.3990091304582 "$node_(455) setdest 122605 34937 4.0" 
$ns at 633.9642653548815 "$node_(455) setdest 133765 27259 3.0" 
$ns at 677.9263601110747 "$node_(455) setdest 7475 41497 11.0" 
$ns at 814.7839743512252 "$node_(455) setdest 123053 17683 19.0" 
$ns at 458.9621464421178 "$node_(456) setdest 112770 26851 3.0" 
$ns at 498.5851413948901 "$node_(456) setdest 47226 8262 14.0" 
$ns at 554.0426429869115 "$node_(456) setdest 4120 31654 17.0" 
$ns at 605.4250029698197 "$node_(456) setdest 36512 35660 1.0" 
$ns at 644.3546142399132 "$node_(456) setdest 91438 29339 17.0" 
$ns at 784.8730434939981 "$node_(456) setdest 34724 35568 15.0" 
$ns at 887.2584246844804 "$node_(456) setdest 103094 25810 15.0" 
$ns at 518.9787128739875 "$node_(457) setdest 105996 30874 5.0" 
$ns at 578.9193701738553 "$node_(457) setdest 23100 31331 10.0" 
$ns at 660.0584996840105 "$node_(457) setdest 46266 14254 16.0" 
$ns at 793.7457465699412 "$node_(457) setdest 74793 37807 17.0" 
$ns at 829.552864914066 "$node_(457) setdest 49778 25760 8.0" 
$ns at 437.4409478553168 "$node_(458) setdest 70743 7179 15.0" 
$ns at 552.8808680711797 "$node_(458) setdest 25686 32414 14.0" 
$ns at 659.8043468601041 "$node_(458) setdest 79595 42501 19.0" 
$ns at 847.5709779063861 "$node_(458) setdest 99770 19418 16.0" 
$ns at 421.61681552516495 "$node_(459) setdest 22398 10688 4.0" 
$ns at 465.89308205604357 "$node_(459) setdest 96454 43810 7.0" 
$ns at 551.0002340179112 "$node_(459) setdest 127205 19341 14.0" 
$ns at 614.1432962497041 "$node_(459) setdest 61445 17188 12.0" 
$ns at 708.965379358788 "$node_(459) setdest 83914 28954 18.0" 
$ns at 829.6735663171823 "$node_(459) setdest 81775 18673 13.0" 
$ns at 431.3055328042811 "$node_(460) setdest 126946 37372 10.0" 
$ns at 526.6054526475314 "$node_(460) setdest 112666 6567 13.0" 
$ns at 598.8525916826783 "$node_(460) setdest 25045 9975 12.0" 
$ns at 663.1801591054834 "$node_(460) setdest 75716 19726 5.0" 
$ns at 705.7539710335235 "$node_(460) setdest 77735 31884 10.0" 
$ns at 825.8669134536127 "$node_(460) setdest 23222 27881 18.0" 
$ns at 876.3208281296197 "$node_(460) setdest 92680 15888 2.0" 
$ns at 425.8887837121283 "$node_(461) setdest 114473 14747 12.0" 
$ns at 518.9840576245915 "$node_(461) setdest 76666 16894 14.0" 
$ns at 577.667270296119 "$node_(461) setdest 94935 6062 19.0" 
$ns at 737.6487043745112 "$node_(461) setdest 123511 22159 14.0" 
$ns at 774.9327741001943 "$node_(461) setdest 65614 241 17.0" 
$ns at 896.154427245791 "$node_(461) setdest 53836 15898 19.0" 
$ns at 510.20758339348714 "$node_(462) setdest 17459 23897 1.0" 
$ns at 541.3194776163098 "$node_(462) setdest 13196 40372 12.0" 
$ns at 635.4982197656213 "$node_(462) setdest 42396 28367 16.0" 
$ns at 785.6270751079237 "$node_(462) setdest 97428 14746 13.0" 
$ns at 874.7026502442769 "$node_(462) setdest 52218 40215 1.0" 
$ns at 434.1945083409049 "$node_(463) setdest 67967 20742 17.0" 
$ns at 526.7078628287352 "$node_(463) setdest 85886 41309 11.0" 
$ns at 595.2283683151031 "$node_(463) setdest 121904 34290 1.0" 
$ns at 633.6448963086137 "$node_(463) setdest 112803 1156 6.0" 
$ns at 715.2931354411131 "$node_(463) setdest 8315 23584 3.0" 
$ns at 760.3465688136399 "$node_(463) setdest 65604 15285 13.0" 
$ns at 856.9773300506013 "$node_(463) setdest 11984 5743 2.0" 
$ns at 891.1021791869981 "$node_(463) setdest 15967 33866 16.0" 
$ns at 450.73971650645683 "$node_(464) setdest 105933 37559 3.0" 
$ns at 496.5435547013905 "$node_(464) setdest 123032 44599 1.0" 
$ns at 530.4082303461511 "$node_(464) setdest 118979 34096 1.0" 
$ns at 569.0414022789982 "$node_(464) setdest 51105 25073 1.0" 
$ns at 603.0541153334473 "$node_(464) setdest 113933 4522 2.0" 
$ns at 633.9105869006879 "$node_(464) setdest 106350 39903 11.0" 
$ns at 768.0366566329001 "$node_(464) setdest 69382 39736 9.0" 
$ns at 816.6196818883486 "$node_(464) setdest 69081 30613 14.0" 
$ns at 420.05370275691917 "$node_(465) setdest 96597 16078 2.0" 
$ns at 450.4747390269465 "$node_(465) setdest 47133 41583 12.0" 
$ns at 566.9939305442487 "$node_(465) setdest 92246 6812 8.0" 
$ns at 641.3249179936184 "$node_(465) setdest 127376 32348 7.0" 
$ns at 698.0935039979098 "$node_(465) setdest 2958 13236 17.0" 
$ns at 766.2183871070386 "$node_(465) setdest 68766 4469 13.0" 
$ns at 433.80592387953436 "$node_(466) setdest 125763 43121 10.0" 
$ns at 533.854234112579 "$node_(466) setdest 67659 43841 17.0" 
$ns at 590.2779349409489 "$node_(466) setdest 88928 15517 8.0" 
$ns at 696.1068597977418 "$node_(466) setdest 89669 9034 11.0" 
$ns at 778.3432441599579 "$node_(466) setdest 36867 23442 13.0" 
$ns at 882.1862671055517 "$node_(466) setdest 110096 4966 8.0" 
$ns at 460.1230198201208 "$node_(467) setdest 19431 25771 8.0" 
$ns at 533.1219614271494 "$node_(467) setdest 98208 16135 4.0" 
$ns at 597.2102613222651 "$node_(467) setdest 89103 37783 4.0" 
$ns at 664.8926208856592 "$node_(467) setdest 12906 39155 1.0" 
$ns at 699.3466058343702 "$node_(467) setdest 49756 42011 3.0" 
$ns at 749.5577845313145 "$node_(467) setdest 26921 22961 7.0" 
$ns at 843.2835823177168 "$node_(467) setdest 49183 31485 4.0" 
$ns at 875.8896813843783 "$node_(467) setdest 43319 44456 11.0" 
$ns at 431.8007940847367 "$node_(468) setdest 100384 12418 15.0" 
$ns at 570.0673798982313 "$node_(468) setdest 92511 36338 10.0" 
$ns at 656.4422590265375 "$node_(468) setdest 66466 16234 5.0" 
$ns at 688.3544457499646 "$node_(468) setdest 39223 34928 14.0" 
$ns at 771.604966011352 "$node_(468) setdest 45443 33726 10.0" 
$ns at 895.4851695134125 "$node_(468) setdest 111454 42828 8.0" 
$ns at 428.57808445351884 "$node_(469) setdest 26252 13238 15.0" 
$ns at 527.8555805185541 "$node_(469) setdest 6969 37256 4.0" 
$ns at 587.6829764858494 "$node_(469) setdest 17568 5139 9.0" 
$ns at 674.5298712307119 "$node_(469) setdest 39377 14169 9.0" 
$ns at 783.3890394988309 "$node_(469) setdest 65783 42843 16.0" 
$ns at 434.80833392116017 "$node_(470) setdest 81586 40468 16.0" 
$ns at 530.701080086518 "$node_(470) setdest 55293 1173 7.0" 
$ns at 599.726217761605 "$node_(470) setdest 96308 26491 4.0" 
$ns at 648.759104659293 "$node_(470) setdest 102741 3440 10.0" 
$ns at 690.3614063065571 "$node_(470) setdest 125638 42253 6.0" 
$ns at 773.4345511300959 "$node_(470) setdest 45189 37137 1.0" 
$ns at 807.7655959249053 "$node_(470) setdest 45684 43171 20.0" 
$ns at 427.7298664501393 "$node_(471) setdest 75369 13425 5.0" 
$ns at 471.17389597613084 "$node_(471) setdest 65995 23013 5.0" 
$ns at 506.3093736442199 "$node_(471) setdest 41056 19584 20.0" 
$ns at 563.2366947070034 "$node_(471) setdest 129153 33200 7.0" 
$ns at 604.653064405368 "$node_(471) setdest 31676 17096 13.0" 
$ns at 642.991283371808 "$node_(471) setdest 24085 27149 7.0" 
$ns at 723.4937414788467 "$node_(471) setdest 126527 15893 20.0" 
$ns at 866.7389369631462 "$node_(471) setdest 130389 22389 3.0" 
$ns at 444.2166746779182 "$node_(472) setdest 34869 41690 10.0" 
$ns at 534.1342739315627 "$node_(472) setdest 30105 36531 1.0" 
$ns at 565.6597568192359 "$node_(472) setdest 76889 23601 11.0" 
$ns at 607.2172483838183 "$node_(472) setdest 128370 14006 3.0" 
$ns at 657.438300803085 "$node_(472) setdest 106123 30457 4.0" 
$ns at 712.8825374869235 "$node_(472) setdest 107436 41734 6.0" 
$ns at 800.2861874069846 "$node_(472) setdest 120435 13214 14.0" 
$ns at 417.9030434884406 "$node_(473) setdest 129485 4486 11.0" 
$ns at 515.8796894263515 "$node_(473) setdest 127814 40878 13.0" 
$ns at 546.5886349653601 "$node_(473) setdest 71642 1970 11.0" 
$ns at 615.190314306594 "$node_(473) setdest 31604 36506 1.0" 
$ns at 648.7488542336823 "$node_(473) setdest 2156 1855 12.0" 
$ns at 706.532336395511 "$node_(473) setdest 107537 6268 9.0" 
$ns at 760.5616260493804 "$node_(473) setdest 65188 22038 9.0" 
$ns at 817.3421695922389 "$node_(473) setdest 130562 41060 14.0" 
$ns at 491.74645848274236 "$node_(474) setdest 74637 8949 5.0" 
$ns at 546.5636221640735 "$node_(474) setdest 23493 22460 4.0" 
$ns at 599.869473557063 "$node_(474) setdest 93000 4027 5.0" 
$ns at 636.2812175580265 "$node_(474) setdest 82535 41540 11.0" 
$ns at 762.3001446939925 "$node_(474) setdest 24253 31246 14.0" 
$ns at 826.4060004863693 "$node_(474) setdest 130321 25869 12.0" 
$ns at 898.804738740699 "$node_(474) setdest 16212 40098 9.0" 
$ns at 409.8125840276761 "$node_(475) setdest 118221 42284 7.0" 
$ns at 475.3852597765788 "$node_(475) setdest 85760 11341 11.0" 
$ns at 576.6052006064975 "$node_(475) setdest 38568 24876 3.0" 
$ns at 631.4634413791332 "$node_(475) setdest 96891 21433 17.0" 
$ns at 663.0210269126408 "$node_(475) setdest 63241 20355 20.0" 
$ns at 885.0666668634651 "$node_(475) setdest 13060 16586 6.0" 
$ns at 493.41389877526876 "$node_(476) setdest 61516 40698 13.0" 
$ns at 548.298394385081 "$node_(476) setdest 47161 14904 3.0" 
$ns at 596.8699815704665 "$node_(476) setdest 85898 1216 2.0" 
$ns at 642.0646379572535 "$node_(476) setdest 99521 22073 12.0" 
$ns at 748.1650643130357 "$node_(476) setdest 51576 7231 20.0" 
$ns at 787.8925741615161 "$node_(476) setdest 315 6250 9.0" 
$ns at 825.782208636832 "$node_(476) setdest 27291 35012 7.0" 
$ns at 882.2570486428003 "$node_(476) setdest 34278 33209 6.0" 
$ns at 424.7845941454726 "$node_(477) setdest 65619 42206 10.0" 
$ns at 460.522543034692 "$node_(477) setdest 30281 26966 7.0" 
$ns at 537.5855619677578 "$node_(477) setdest 38174 8848 9.0" 
$ns at 657.2404988748195 "$node_(477) setdest 89347 26179 11.0" 
$ns at 781.4231466728219 "$node_(477) setdest 14383 5297 4.0" 
$ns at 850.7464714893805 "$node_(477) setdest 362 4777 19.0" 
$ns at 459.6069229442753 "$node_(478) setdest 94531 7478 1.0" 
$ns at 496.5197644057576 "$node_(478) setdest 111399 38243 18.0" 
$ns at 683.9641905122188 "$node_(478) setdest 103749 1941 7.0" 
$ns at 753.8164365922813 "$node_(478) setdest 114966 11343 1.0" 
$ns at 787.637639451563 "$node_(478) setdest 97289 18372 9.0" 
$ns at 840.4064060408382 "$node_(478) setdest 37741 5576 6.0" 
$ns at 883.8473729621211 "$node_(478) setdest 35058 36563 1.0" 
$ns at 413.9386940791775 "$node_(479) setdest 84051 3281 6.0" 
$ns at 495.3900740994707 "$node_(479) setdest 58067 21704 20.0" 
$ns at 543.4846641889932 "$node_(479) setdest 63810 18263 11.0" 
$ns at 664.3931164983458 "$node_(479) setdest 18479 5762 18.0" 
$ns at 702.8304083790522 "$node_(479) setdest 24589 3040 7.0" 
$ns at 777.9168235301134 "$node_(479) setdest 71286 29702 17.0" 
$ns at 865.5213934048887 "$node_(479) setdest 1509 3742 1.0" 
$ns at 488.2953139214138 "$node_(480) setdest 8808 37286 15.0" 
$ns at 627.3857269638152 "$node_(480) setdest 10141 39076 13.0" 
$ns at 750.6050528054627 "$node_(480) setdest 129952 25071 18.0" 
$ns at 431.3777092939464 "$node_(481) setdest 44677 22518 4.0" 
$ns at 496.2355911200731 "$node_(481) setdest 48768 20540 16.0" 
$ns at 538.4314069852078 "$node_(481) setdest 15643 13650 18.0" 
$ns at 646.8175600284155 "$node_(481) setdest 102765 30540 20.0" 
$ns at 844.7857209458347 "$node_(481) setdest 42244 37784 19.0" 
$ns at 427.28564983500473 "$node_(482) setdest 39709 11136 8.0" 
$ns at 488.93060208784567 "$node_(482) setdest 112053 40611 18.0" 
$ns at 570.3530227368633 "$node_(482) setdest 129832 2805 3.0" 
$ns at 610.5256115166053 "$node_(482) setdest 122929 34720 2.0" 
$ns at 657.3764883700713 "$node_(482) setdest 6356 15884 6.0" 
$ns at 735.2952388522389 "$node_(482) setdest 13295 7461 6.0" 
$ns at 808.9639893486969 "$node_(482) setdest 126383 32316 19.0" 
$ns at 405.6562383334473 "$node_(483) setdest 101782 29490 9.0" 
$ns at 511.89510785943315 "$node_(483) setdest 78730 14158 1.0" 
$ns at 550.0630509503594 "$node_(483) setdest 33193 13981 15.0" 
$ns at 702.5992063351134 "$node_(483) setdest 9197 17088 12.0" 
$ns at 836.1416657222119 "$node_(483) setdest 41689 3297 11.0" 
$ns at 896.9286203025134 "$node_(483) setdest 42119 2020 15.0" 
$ns at 459.6999999188615 "$node_(484) setdest 27230 12387 7.0" 
$ns at 527.5243258596454 "$node_(484) setdest 21918 33213 16.0" 
$ns at 563.9595243618821 "$node_(484) setdest 49949 7311 1.0" 
$ns at 594.4310039854973 "$node_(484) setdest 339 35799 18.0" 
$ns at 636.2839395727719 "$node_(484) setdest 88374 16798 18.0" 
$ns at 830.5436830289528 "$node_(484) setdest 99986 20064 12.0" 
$ns at 400.31505163139536 "$node_(485) setdest 112368 8365 2.0" 
$ns at 447.71629790105766 "$node_(485) setdest 122598 13504 12.0" 
$ns at 510.3410074200787 "$node_(485) setdest 116250 38970 8.0" 
$ns at 565.8362985774602 "$node_(485) setdest 83744 4120 10.0" 
$ns at 661.6568268786723 "$node_(485) setdest 20893 183 2.0" 
$ns at 697.0869963797915 "$node_(485) setdest 111434 11500 19.0" 
$ns at 461.91307387129905 "$node_(486) setdest 42731 41390 20.0" 
$ns at 617.8404350810789 "$node_(486) setdest 12877 40647 4.0" 
$ns at 680.6630483790547 "$node_(486) setdest 27583 14154 12.0" 
$ns at 721.8383637863161 "$node_(486) setdest 24857 43708 3.0" 
$ns at 771.950170880712 "$node_(486) setdest 100642 34604 14.0" 
$ns at 831.5600835424108 "$node_(486) setdest 114720 24242 6.0" 
$ns at 420.1323485309738 "$node_(487) setdest 114057 23105 2.0" 
$ns at 463.29780688730386 "$node_(487) setdest 73300 33390 15.0" 
$ns at 638.702338835793 "$node_(487) setdest 100197 8359 9.0" 
$ns at 698.0250740486566 "$node_(487) setdest 41431 11610 7.0" 
$ns at 751.7398818937852 "$node_(487) setdest 80796 36648 1.0" 
$ns at 787.2349032829624 "$node_(487) setdest 123609 16590 7.0" 
$ns at 823.7803144185364 "$node_(487) setdest 33503 20629 2.0" 
$ns at 873.5506886472239 "$node_(487) setdest 112746 29396 13.0" 
$ns at 426.8632213987207 "$node_(488) setdest 65263 39485 10.0" 
$ns at 458.5445915072363 "$node_(488) setdest 81151 16777 13.0" 
$ns at 491.36839779993034 "$node_(488) setdest 54095 9868 1.0" 
$ns at 530.3175355235958 "$node_(488) setdest 67756 9360 4.0" 
$ns at 592.5630219309692 "$node_(488) setdest 113481 38329 19.0" 
$ns at 756.2881464972733 "$node_(488) setdest 80229 8888 2.0" 
$ns at 796.4151678243044 "$node_(488) setdest 55619 33511 7.0" 
$ns at 859.2120417750164 "$node_(488) setdest 47464 43839 13.0" 
$ns at 435.0706089292133 "$node_(489) setdest 127435 10436 6.0" 
$ns at 491.1931435306306 "$node_(489) setdest 43603 22786 13.0" 
$ns at 611.1475332058643 "$node_(489) setdest 34409 873 4.0" 
$ns at 679.7003389681059 "$node_(489) setdest 8090 31855 16.0" 
$ns at 779.8550747631108 "$node_(489) setdest 111890 25463 12.0" 
$ns at 879.2344409095267 "$node_(489) setdest 72311 24706 5.0" 
$ns at 422.4456637040278 "$node_(490) setdest 45093 38833 16.0" 
$ns at 459.2498825701481 "$node_(490) setdest 116801 17194 8.0" 
$ns at 506.3664169161311 "$node_(490) setdest 4350 3171 19.0" 
$ns at 581.0284308772898 "$node_(490) setdest 129699 43932 14.0" 
$ns at 624.405407927902 "$node_(490) setdest 132995 7788 16.0" 
$ns at 670.5757593623828 "$node_(490) setdest 38776 37754 10.0" 
$ns at 715.6840173498736 "$node_(490) setdest 120876 34201 7.0" 
$ns at 781.2292352914541 "$node_(490) setdest 32187 43896 3.0" 
$ns at 813.6085792239128 "$node_(490) setdest 45822 42541 10.0" 
$ns at 869.7240925611836 "$node_(490) setdest 97034 17258 10.0" 
$ns at 430.73203752227073 "$node_(491) setdest 91906 19493 12.0" 
$ns at 560.8978839139294 "$node_(491) setdest 10766 29413 19.0" 
$ns at 637.6592270647963 "$node_(491) setdest 62791 15998 18.0" 
$ns at 694.5334883649039 "$node_(491) setdest 128588 32557 8.0" 
$ns at 771.7447967773527 "$node_(491) setdest 74505 24421 2.0" 
$ns at 806.5088796495613 "$node_(491) setdest 119976 40779 16.0" 
$ns at 891.4397048099127 "$node_(491) setdest 116120 21791 7.0" 
$ns at 570.7998536149639 "$node_(492) setdest 79587 7631 11.0" 
$ns at 679.6256236102108 "$node_(492) setdest 29060 21766 10.0" 
$ns at 731.4953838895175 "$node_(492) setdest 74879 19298 5.0" 
$ns at 767.5594708363918 "$node_(492) setdest 5501 8750 19.0" 
$ns at 442.3860345031337 "$node_(493) setdest 11282 37694 1.0" 
$ns at 478.37527951737724 "$node_(493) setdest 15928 31377 16.0" 
$ns at 616.5044907790082 "$node_(493) setdest 7484 40406 4.0" 
$ns at 678.5536481305062 "$node_(493) setdest 67893 35038 19.0" 
$ns at 861.1600153061647 "$node_(493) setdest 12169 32839 17.0" 
$ns at 467.3905419185791 "$node_(494) setdest 129534 38647 3.0" 
$ns at 523.6753187119788 "$node_(494) setdest 69977 4792 6.0" 
$ns at 613.2674685791299 "$node_(494) setdest 52897 20934 6.0" 
$ns at 643.8476714675695 "$node_(494) setdest 102411 1881 15.0" 
$ns at 811.4466067641837 "$node_(494) setdest 113289 13577 18.0" 
$ns at 430.62612776139326 "$node_(495) setdest 108437 26199 8.0" 
$ns at 492.425236578362 "$node_(495) setdest 99434 40412 14.0" 
$ns at 596.8861995417943 "$node_(495) setdest 8355 25015 12.0" 
$ns at 681.9917446367796 "$node_(495) setdest 25864 22051 16.0" 
$ns at 782.1163443214463 "$node_(495) setdest 68836 10461 13.0" 
$ns at 870.3463639201735 "$node_(495) setdest 27426 22177 10.0" 
$ns at 437.1757347814092 "$node_(496) setdest 89659 32646 1.0" 
$ns at 474.44033615526365 "$node_(496) setdest 49849 12027 15.0" 
$ns at 562.9956941838878 "$node_(496) setdest 95808 7289 15.0" 
$ns at 741.718440939577 "$node_(496) setdest 119765 44592 7.0" 
$ns at 821.1484675412534 "$node_(496) setdest 28634 18735 1.0" 
$ns at 853.2444048413113 "$node_(496) setdest 87256 11063 4.0" 
$ns at 410.95387490451617 "$node_(497) setdest 62756 36395 17.0" 
$ns at 577.7206695607614 "$node_(497) setdest 48837 26281 3.0" 
$ns at 610.15361174231 "$node_(497) setdest 25692 2445 3.0" 
$ns at 656.7202082334722 "$node_(497) setdest 78071 12921 5.0" 
$ns at 711.5988157330563 "$node_(497) setdest 79261 37062 10.0" 
$ns at 831.0582388923132 "$node_(497) setdest 26185 31351 1.0" 
$ns at 862.8875751926456 "$node_(497) setdest 3986 3023 13.0" 
$ns at 473.3954170723172 "$node_(498) setdest 108363 30514 14.0" 
$ns at 537.4415103194757 "$node_(498) setdest 16579 28162 12.0" 
$ns at 646.0514604559046 "$node_(498) setdest 108515 30850 1.0" 
$ns at 677.7819894814118 "$node_(498) setdest 103495 25626 4.0" 
$ns at 714.9856962539598 "$node_(498) setdest 28932 39647 1.0" 
$ns at 745.1074197514167 "$node_(498) setdest 36071 2576 3.0" 
$ns at 778.7715142634102 "$node_(498) setdest 28763 13558 2.0" 
$ns at 813.1621401290239 "$node_(498) setdest 76269 21065 3.0" 
$ns at 851.7618568925562 "$node_(498) setdest 39990 14749 13.0" 
$ns at 424.2661681214538 "$node_(499) setdest 96317 36005 14.0" 
$ns at 472.14876842708514 "$node_(499) setdest 24866 35130 4.0" 
$ns at 532.0475175567822 "$node_(499) setdest 92336 11564 20.0" 
$ns at 701.7448008063125 "$node_(499) setdest 116482 27936 1.0" 
$ns at 739.9602164781471 "$node_(499) setdest 27871 22429 12.0" 
$ns at 811.1446099385563 "$node_(499) setdest 42598 16506 18.0" 
$ns at 869.78439587102 "$node_(499) setdest 33679 1652 14.0" 
$ns at 506.81811728235505 "$node_(500) setdest 23784 10547 14.0" 
$ns at 553.5004406680764 "$node_(500) setdest 19316 44478 7.0" 
$ns at 585.5520616739221 "$node_(500) setdest 111139 20779 19.0" 
$ns at 621.5409623883382 "$node_(500) setdest 133284 12251 1.0" 
$ns at 656.9184031641013 "$node_(500) setdest 43524 14492 5.0" 
$ns at 692.7696494485886 "$node_(500) setdest 89152 37275 17.0" 
$ns at 756.8949487774944 "$node_(500) setdest 120534 31779 15.0" 
$ns at 820.5054119344757 "$node_(500) setdest 60563 34838 3.0" 
$ns at 880.2289742010288 "$node_(500) setdest 108243 22738 6.0" 
$ns at 602.9259097007752 "$node_(501) setdest 66142 6141 17.0" 
$ns at 668.866608135014 "$node_(501) setdest 132079 19047 1.0" 
$ns at 708.2100925041588 "$node_(501) setdest 12657 2964 14.0" 
$ns at 749.4602506294543 "$node_(501) setdest 45942 13154 19.0" 
$ns at 836.6281243199006 "$node_(501) setdest 82839 32899 7.0" 
$ns at 539.4660452564806 "$node_(502) setdest 102298 27535 17.0" 
$ns at 658.6506858266006 "$node_(502) setdest 1472 12098 9.0" 
$ns at 719.2774319066286 "$node_(502) setdest 51257 5075 9.0" 
$ns at 751.470503184343 "$node_(502) setdest 20882 43545 3.0" 
$ns at 810.1168141493841 "$node_(502) setdest 133674 12686 6.0" 
$ns at 842.9778593577278 "$node_(502) setdest 77004 42924 19.0" 
$ns at 549.7290912859388 "$node_(503) setdest 94295 30564 1.0" 
$ns at 581.0598675922511 "$node_(503) setdest 61281 38954 4.0" 
$ns at 641.9097602887267 "$node_(503) setdest 6657 27007 15.0" 
$ns at 711.0080061457535 "$node_(503) setdest 12960 18274 5.0" 
$ns at 777.5500210798539 "$node_(503) setdest 19947 26471 4.0" 
$ns at 828.3526342953136 "$node_(503) setdest 16736 41038 5.0" 
$ns at 899.8210082337589 "$node_(503) setdest 107424 40914 1.0" 
$ns at 515.8480606049975 "$node_(504) setdest 22530 35918 15.0" 
$ns at 592.823340108607 "$node_(504) setdest 4595 38382 12.0" 
$ns at 683.2600714937382 "$node_(504) setdest 111296 13134 4.0" 
$ns at 720.100029596512 "$node_(504) setdest 56239 7828 12.0" 
$ns at 822.3527356820006 "$node_(504) setdest 44810 13503 18.0" 
$ns at 539.6403095379949 "$node_(505) setdest 51967 25942 8.0" 
$ns at 629.267903844595 "$node_(505) setdest 101328 11483 10.0" 
$ns at 694.2403201906775 "$node_(505) setdest 77404 7892 12.0" 
$ns at 745.7649818774709 "$node_(505) setdest 133951 14832 13.0" 
$ns at 794.5080958312687 "$node_(505) setdest 70713 5109 8.0" 
$ns at 890.5966026049077 "$node_(505) setdest 109316 20379 1.0" 
$ns at 635.3200981282183 "$node_(506) setdest 80303 954 10.0" 
$ns at 739.2776456406295 "$node_(506) setdest 93478 36818 11.0" 
$ns at 770.04996348044 "$node_(506) setdest 113627 1057 15.0" 
$ns at 878.1156463980276 "$node_(506) setdest 133485 38855 8.0" 
$ns at 515.3115372309478 "$node_(507) setdest 47974 43759 6.0" 
$ns at 593.391191660948 "$node_(507) setdest 23182 44274 16.0" 
$ns at 733.5130187558798 "$node_(507) setdest 29632 9200 13.0" 
$ns at 856.6009497806716 "$node_(507) setdest 92893 3433 14.0" 
$ns at 511.0066262021081 "$node_(508) setdest 57552 30013 9.0" 
$ns at 597.660139039347 "$node_(508) setdest 69432 37912 9.0" 
$ns at 662.8407416431361 "$node_(508) setdest 32099 6963 3.0" 
$ns at 715.0557503607529 "$node_(508) setdest 24435 1607 15.0" 
$ns at 840.9068916285178 "$node_(508) setdest 12987 31311 8.0" 
$ns at 880.0143122907182 "$node_(508) setdest 45677 42006 4.0" 
$ns at 514.9550470561722 "$node_(509) setdest 29570 33802 14.0" 
$ns at 666.0277586400332 "$node_(509) setdest 44061 14304 7.0" 
$ns at 725.7873215187476 "$node_(509) setdest 75758 23647 7.0" 
$ns at 768.3642575793598 "$node_(509) setdest 38291 9632 1.0" 
$ns at 806.3924980935356 "$node_(509) setdest 117085 22190 3.0" 
$ns at 863.1218967100964 "$node_(509) setdest 108279 8871 14.0" 
$ns at 603.5522456827335 "$node_(510) setdest 59421 29855 10.0" 
$ns at 721.2315256967328 "$node_(510) setdest 13697 7279 9.0" 
$ns at 788.3445642513235 "$node_(510) setdest 57088 13973 8.0" 
$ns at 833.1212756273 "$node_(510) setdest 85259 1729 12.0" 
$ns at 888.4005444331822 "$node_(510) setdest 37394 15441 16.0" 
$ns at 671.1831372999151 "$node_(511) setdest 9642 18454 7.0" 
$ns at 710.810320940206 "$node_(511) setdest 108845 19578 10.0" 
$ns at 821.9113774792717 "$node_(511) setdest 80340 27107 11.0" 
$ns at 613.032054521846 "$node_(512) setdest 78704 43004 14.0" 
$ns at 766.1534499629724 "$node_(512) setdest 94192 13300 3.0" 
$ns at 801.6411187663742 "$node_(512) setdest 19743 16147 3.0" 
$ns at 850.227589735512 "$node_(512) setdest 54733 31943 7.0" 
$ns at 515.2377948002472 "$node_(513) setdest 104648 28359 15.0" 
$ns at 635.9771428732278 "$node_(513) setdest 80106 39157 13.0" 
$ns at 668.8258809048127 "$node_(513) setdest 103013 28403 19.0" 
$ns at 850.0835848981501 "$node_(513) setdest 75912 25916 19.0" 
$ns at 535.3605303586897 "$node_(514) setdest 110246 36962 1.0" 
$ns at 569.0493194836641 "$node_(514) setdest 81576 28201 10.0" 
$ns at 645.8224768805605 "$node_(514) setdest 72807 2949 10.0" 
$ns at 765.6672312982886 "$node_(514) setdest 17571 19434 11.0" 
$ns at 859.647926729132 "$node_(514) setdest 77172 16253 1.0" 
$ns at 893.0739516915464 "$node_(514) setdest 2766 8701 12.0" 
$ns at 593.5798688474008 "$node_(515) setdest 28581 6938 2.0" 
$ns at 632.9196794929366 "$node_(515) setdest 80585 6683 7.0" 
$ns at 684.0332754502746 "$node_(515) setdest 28343 10381 2.0" 
$ns at 726.6463727205221 "$node_(515) setdest 48819 23849 15.0" 
$ns at 863.954318910118 "$node_(515) setdest 129895 13746 9.0" 
$ns at 541.1136742675687 "$node_(516) setdest 61693 6890 5.0" 
$ns at 604.3461133829672 "$node_(516) setdest 72141 40089 17.0" 
$ns at 799.8694589419301 "$node_(516) setdest 90529 41949 11.0" 
$ns at 862.4154228166146 "$node_(516) setdest 114116 21357 10.0" 
$ns at 602.9268585895968 "$node_(517) setdest 30110 18072 4.0" 
$ns at 645.3426299240153 "$node_(517) setdest 4869 33056 15.0" 
$ns at 733.1335793036749 "$node_(517) setdest 23223 44243 8.0" 
$ns at 784.0655743306636 "$node_(517) setdest 62008 7587 10.0" 
$ns at 823.2832833857814 "$node_(517) setdest 4951 18931 14.0" 
$ns at 861.3976629202813 "$node_(517) setdest 81453 38078 14.0" 
$ns at 525.5861637808262 "$node_(518) setdest 72797 11859 11.0" 
$ns at 655.3640489570816 "$node_(518) setdest 60700 34717 11.0" 
$ns at 737.6732823390413 "$node_(518) setdest 60477 20053 16.0" 
$ns at 788.4917604836745 "$node_(518) setdest 55409 27332 13.0" 
$ns at 500.5868145316557 "$node_(519) setdest 114635 43880 16.0" 
$ns at 586.0728864303669 "$node_(519) setdest 53280 17329 3.0" 
$ns at 623.2945170255232 "$node_(519) setdest 131185 6957 8.0" 
$ns at 733.2799838511223 "$node_(519) setdest 77370 1688 9.0" 
$ns at 825.5803454551772 "$node_(519) setdest 27596 24691 11.0" 
$ns at 502.37050233712637 "$node_(520) setdest 26697 44493 7.0" 
$ns at 554.0255011740553 "$node_(520) setdest 70723 2489 7.0" 
$ns at 634.0520147260663 "$node_(520) setdest 112457 29921 10.0" 
$ns at 749.0546423332022 "$node_(520) setdest 5707 22564 18.0" 
$ns at 897.3533934028019 "$node_(520) setdest 29246 9771 14.0" 
$ns at 562.6935286945203 "$node_(521) setdest 95920 7474 14.0" 
$ns at 702.4226764325056 "$node_(521) setdest 9226 4828 11.0" 
$ns at 833.0371032526297 "$node_(521) setdest 68264 13230 12.0" 
$ns at 878.275371664981 "$node_(521) setdest 116899 4021 13.0" 
$ns at 534.4541397057424 "$node_(522) setdest 120514 17662 20.0" 
$ns at 670.4122884635292 "$node_(522) setdest 110132 33258 8.0" 
$ns at 729.7017178744643 "$node_(522) setdest 81353 23686 7.0" 
$ns at 792.7915358951539 "$node_(522) setdest 31673 10747 7.0" 
$ns at 823.5281052517564 "$node_(522) setdest 64362 32232 18.0" 
$ns at 555.9433257274737 "$node_(523) setdest 62516 9666 16.0" 
$ns at 592.459052397431 "$node_(523) setdest 11656 29727 17.0" 
$ns at 691.09947968804 "$node_(523) setdest 114036 40327 4.0" 
$ns at 733.3124891782588 "$node_(523) setdest 42896 18866 6.0" 
$ns at 783.163691293125 "$node_(523) setdest 115502 43350 7.0" 
$ns at 867.2137760012503 "$node_(523) setdest 113755 16483 5.0" 
$ns at 557.3253585091371 "$node_(524) setdest 108239 18878 14.0" 
$ns at 707.1191102436546 "$node_(524) setdest 68728 31267 14.0" 
$ns at 799.7144532711785 "$node_(524) setdest 3730 28201 9.0" 
$ns at 866.5106107648496 "$node_(524) setdest 39057 40791 10.0" 
$ns at 515.2049364815616 "$node_(525) setdest 115976 7114 2.0" 
$ns at 561.395486824788 "$node_(525) setdest 133848 34153 13.0" 
$ns at 627.4651759403724 "$node_(525) setdest 37997 33038 8.0" 
$ns at 720.5820465075324 "$node_(525) setdest 74517 39460 18.0" 
$ns at 895.3324409484019 "$node_(525) setdest 29402 33458 8.0" 
$ns at 592.8255700172278 "$node_(526) setdest 67558 37347 12.0" 
$ns at 629.5924290325534 "$node_(526) setdest 70751 11982 7.0" 
$ns at 680.7288446267326 "$node_(526) setdest 55389 10174 9.0" 
$ns at 781.1188844019098 "$node_(526) setdest 79421 29981 10.0" 
$ns at 880.9828642817149 "$node_(526) setdest 203 13366 3.0" 
$ns at 509.5062228187296 "$node_(527) setdest 41064 26894 18.0" 
$ns at 684.5495763290397 "$node_(527) setdest 126624 16125 3.0" 
$ns at 724.7898355535195 "$node_(527) setdest 78310 22706 12.0" 
$ns at 758.1213326330719 "$node_(527) setdest 93938 4027 4.0" 
$ns at 792.906344914446 "$node_(527) setdest 41913 19894 9.0" 
$ns at 868.7393162868922 "$node_(527) setdest 108817 27842 1.0" 
$ns at 551.64216972076 "$node_(528) setdest 62237 35592 4.0" 
$ns at 616.4114872334209 "$node_(528) setdest 18991 13964 19.0" 
$ns at 709.9977258421096 "$node_(528) setdest 27855 4210 9.0" 
$ns at 744.1534710124877 "$node_(528) setdest 34299 37144 5.0" 
$ns at 798.8246836222494 "$node_(528) setdest 90890 16478 10.0" 
$ns at 830.0624752413814 "$node_(528) setdest 35946 27601 11.0" 
$ns at 865.2230022855998 "$node_(528) setdest 113256 17250 19.0" 
$ns at 560.5695547941999 "$node_(529) setdest 85035 21742 4.0" 
$ns at 622.0895827292369 "$node_(529) setdest 8481 12074 2.0" 
$ns at 668.4398986127255 "$node_(529) setdest 676 41589 7.0" 
$ns at 730.7320034216748 "$node_(529) setdest 73922 1458 3.0" 
$ns at 769.7796600300026 "$node_(529) setdest 62464 8480 8.0" 
$ns at 813.224936719004 "$node_(529) setdest 45764 40185 4.0" 
$ns at 856.2843582237251 "$node_(529) setdest 38306 33636 7.0" 
$ns at 599.4898866025546 "$node_(530) setdest 61607 41439 14.0" 
$ns at 744.4556712234369 "$node_(530) setdest 47253 38879 17.0" 
$ns at 531.3629612652566 "$node_(531) setdest 6148 20022 8.0" 
$ns at 634.6934865353845 "$node_(531) setdest 72527 36190 14.0" 
$ns at 779.0668734107951 "$node_(531) setdest 133590 34059 6.0" 
$ns at 831.0526321949104 "$node_(531) setdest 26060 16058 10.0" 
$ns at 606.3751099552522 "$node_(532) setdest 52087 13394 2.0" 
$ns at 641.1442003923626 "$node_(532) setdest 133129 108 14.0" 
$ns at 709.6897533576215 "$node_(532) setdest 132057 40628 14.0" 
$ns at 750.7626754565229 "$node_(532) setdest 115234 29804 15.0" 
$ns at 815.5606799581246 "$node_(532) setdest 118511 6256 8.0" 
$ns at 504.3217041884912 "$node_(533) setdest 14123 20867 4.0" 
$ns at 544.0326929068557 "$node_(533) setdest 22919 25820 4.0" 
$ns at 594.3435430155251 "$node_(533) setdest 127569 29967 16.0" 
$ns at 644.8372075814798 "$node_(533) setdest 21864 9452 19.0" 
$ns at 859.9117306069659 "$node_(533) setdest 63889 30470 2.0" 
$ns at 893.4837752126891 "$node_(533) setdest 57534 32734 9.0" 
$ns at 523.477199420097 "$node_(534) setdest 108060 112 18.0" 
$ns at 721.189315256615 "$node_(534) setdest 96985 19136 9.0" 
$ns at 821.8928087564944 "$node_(534) setdest 93120 43240 6.0" 
$ns at 867.9287721874463 "$node_(534) setdest 99419 1309 11.0" 
$ns at 514.2539146877396 "$node_(535) setdest 62275 18983 16.0" 
$ns at 640.0122477248211 "$node_(535) setdest 104093 37292 4.0" 
$ns at 696.6386122218141 "$node_(535) setdest 1015 11867 17.0" 
$ns at 756.8897725835072 "$node_(535) setdest 12044 43274 14.0" 
$ns at 809.1881801669911 "$node_(535) setdest 101393 37534 20.0" 
$ns at 553.3588056801368 "$node_(536) setdest 35866 2457 19.0" 
$ns at 749.9677329194835 "$node_(536) setdest 59236 28169 12.0" 
$ns at 858.4247693419042 "$node_(536) setdest 41066 2444 19.0" 
$ns at 537.3199654338208 "$node_(537) setdest 24239 20400 11.0" 
$ns at 603.1826186887513 "$node_(537) setdest 24373 35976 7.0" 
$ns at 645.4144296120178 "$node_(537) setdest 110527 40149 15.0" 
$ns at 761.3654675242997 "$node_(537) setdest 89264 24585 14.0" 
$ns at 801.2993794676116 "$node_(537) setdest 68268 43044 16.0" 
$ns at 856.3840992044904 "$node_(537) setdest 86310 11938 1.0" 
$ns at 889.7695756654587 "$node_(537) setdest 45520 9436 4.0" 
$ns at 554.8771664210412 "$node_(538) setdest 79533 42851 13.0" 
$ns at 668.5968810839322 "$node_(538) setdest 111587 96 16.0" 
$ns at 840.3274305119422 "$node_(538) setdest 36851 36805 17.0" 
$ns at 554.2180028791637 "$node_(539) setdest 55951 19224 18.0" 
$ns at 669.2436122157642 "$node_(539) setdest 126379 34736 1.0" 
$ns at 701.8913309718293 "$node_(539) setdest 19593 25465 1.0" 
$ns at 733.913936386672 "$node_(539) setdest 38694 23441 4.0" 
$ns at 785.8381231016652 "$node_(539) setdest 12060 9187 11.0" 
$ns at 824.3478959990144 "$node_(539) setdest 48155 7704 10.0" 
$ns at 893.1495895335363 "$node_(539) setdest 84668 8349 4.0" 
$ns at 566.865810653357 "$node_(540) setdest 13574 36431 8.0" 
$ns at 638.288844392667 "$node_(540) setdest 49962 10830 5.0" 
$ns at 672.440473193894 "$node_(540) setdest 63938 19298 13.0" 
$ns at 739.3738654793035 "$node_(540) setdest 110022 16307 18.0" 
$ns at 501.08126324030303 "$node_(541) setdest 96384 32557 2.0" 
$ns at 547.7579899140773 "$node_(541) setdest 50297 10372 5.0" 
$ns at 605.1486989956979 "$node_(541) setdest 17085 4760 18.0" 
$ns at 787.4968345331549 "$node_(541) setdest 5886 30212 16.0" 
$ns at 854.1612203223561 "$node_(541) setdest 89905 41364 1.0" 
$ns at 887.8801584580394 "$node_(541) setdest 26747 38441 9.0" 
$ns at 612.4454790714681 "$node_(542) setdest 48317 26832 1.0" 
$ns at 643.5401820326226 "$node_(542) setdest 27004 42513 8.0" 
$ns at 727.0870750572369 "$node_(542) setdest 78631 13013 10.0" 
$ns at 815.2697225417913 "$node_(542) setdest 24150 43354 4.0" 
$ns at 870.970260268525 "$node_(542) setdest 11369 13578 20.0" 
$ns at 542.3274808097626 "$node_(543) setdest 3958 36579 20.0" 
$ns at 740.0125528028283 "$node_(543) setdest 85950 26928 12.0" 
$ns at 805.9211444467526 "$node_(543) setdest 113802 35734 16.0" 
$ns at 873.2696075147692 "$node_(543) setdest 35837 8127 10.0" 
$ns at 574.5466751910166 "$node_(544) setdest 79159 19885 10.0" 
$ns at 659.8758320495557 "$node_(544) setdest 109668 5428 15.0" 
$ns at 735.6779495772716 "$node_(544) setdest 58111 16098 12.0" 
$ns at 766.3274353814093 "$node_(544) setdest 22376 32138 12.0" 
$ns at 869.8636626086396 "$node_(544) setdest 26468 42001 1.0" 
$ns at 534.0818233463008 "$node_(545) setdest 47146 32283 9.0" 
$ns at 601.4050423807519 "$node_(545) setdest 99208 41969 3.0" 
$ns at 660.7741267875369 "$node_(545) setdest 122161 664 4.0" 
$ns at 713.9112199896128 "$node_(545) setdest 89664 44144 1.0" 
$ns at 744.9800782624201 "$node_(545) setdest 88797 98 7.0" 
$ns at 843.2042737352053 "$node_(545) setdest 102080 16958 19.0" 
$ns at 543.9789757763695 "$node_(546) setdest 55936 500 15.0" 
$ns at 628.6991920926904 "$node_(546) setdest 50924 16390 2.0" 
$ns at 668.7578675460521 "$node_(546) setdest 7216 26900 1.0" 
$ns at 702.7375551675805 "$node_(546) setdest 23341 423 4.0" 
$ns at 768.2427146272126 "$node_(546) setdest 69544 6897 15.0" 
$ns at 885.8537872980551 "$node_(546) setdest 107297 29315 1.0" 
$ns at 530.2689151624802 "$node_(547) setdest 113054 24093 2.0" 
$ns at 580.1411103711266 "$node_(547) setdest 92234 6522 12.0" 
$ns at 675.559110223982 "$node_(547) setdest 50474 39456 1.0" 
$ns at 706.8709447153118 "$node_(547) setdest 71084 41051 8.0" 
$ns at 741.0177858787733 "$node_(547) setdest 128608 32366 19.0" 
$ns at 844.3419278261764 "$node_(547) setdest 72596 22440 17.0" 
$ns at 507.3636922859625 "$node_(548) setdest 47886 19403 18.0" 
$ns at 660.9909243291168 "$node_(548) setdest 35036 11483 7.0" 
$ns at 755.9717394370323 "$node_(548) setdest 92802 26918 6.0" 
$ns at 826.7612163130943 "$node_(548) setdest 118256 39169 12.0" 
$ns at 897.4181934240619 "$node_(548) setdest 75924 20841 15.0" 
$ns at 504.47259444799164 "$node_(549) setdest 98564 22198 20.0" 
$ns at 640.0478812466997 "$node_(549) setdest 31354 9666 20.0" 
$ns at 759.2529245141008 "$node_(549) setdest 11918 19839 1.0" 
$ns at 794.0339634153837 "$node_(549) setdest 497 20710 2.0" 
$ns at 833.0083841893726 "$node_(549) setdest 108113 42517 19.0" 
$ns at 505.9079614192984 "$node_(550) setdest 101902 37227 18.0" 
$ns at 542.3699167869275 "$node_(550) setdest 128104 9187 12.0" 
$ns at 649.011452831895 "$node_(550) setdest 54694 9940 7.0" 
$ns at 681.0582296460086 "$node_(550) setdest 13363 25736 1.0" 
$ns at 718.9287436952308 "$node_(550) setdest 31478 15697 19.0" 
$ns at 842.7814627042949 "$node_(550) setdest 29715 3738 11.0" 
$ns at 516.1096051395882 "$node_(551) setdest 64956 12017 12.0" 
$ns at 564.1559632838157 "$node_(551) setdest 99886 31495 17.0" 
$ns at 672.0018138472233 "$node_(551) setdest 117374 25292 17.0" 
$ns at 821.297362247327 "$node_(551) setdest 37481 15848 1.0" 
$ns at 854.5665150110763 "$node_(551) setdest 84846 30130 11.0" 
$ns at 500.3197657487604 "$node_(552) setdest 52642 35932 2.0" 
$ns at 549.1390178828759 "$node_(552) setdest 81895 21420 2.0" 
$ns at 586.2119753940939 "$node_(552) setdest 104196 21540 12.0" 
$ns at 622.6094458903381 "$node_(552) setdest 126779 22136 5.0" 
$ns at 655.0783529132137 "$node_(552) setdest 46773 26868 5.0" 
$ns at 720.6937495469765 "$node_(552) setdest 60768 26740 8.0" 
$ns at 791.3306482062353 "$node_(552) setdest 61019 18887 13.0" 
$ns at 822.8333141447074 "$node_(552) setdest 125394 4840 6.0" 
$ns at 578.4171709749609 "$node_(553) setdest 106979 23226 6.0" 
$ns at 660.1496251362836 "$node_(553) setdest 82716 8452 16.0" 
$ns at 796.7849853811479 "$node_(553) setdest 58915 17573 18.0" 
$ns at 862.7909086370146 "$node_(553) setdest 36299 34427 13.0" 
$ns at 527.7010160778078 "$node_(554) setdest 111135 24919 17.0" 
$ns at 628.6108341635863 "$node_(554) setdest 32988 10150 3.0" 
$ns at 666.0735592221777 "$node_(554) setdest 8053 8606 19.0" 
$ns at 804.0510697314076 "$node_(554) setdest 94508 32739 1.0" 
$ns at 843.6846437216387 "$node_(554) setdest 4216 34845 13.0" 
$ns at 547.4153473508649 "$node_(555) setdest 65282 10794 12.0" 
$ns at 691.64746385077 "$node_(555) setdest 95530 10062 12.0" 
$ns at 829.9218991809146 "$node_(555) setdest 64110 11354 3.0" 
$ns at 877.3008344460658 "$node_(555) setdest 39591 4894 14.0" 
$ns at 535.6232828468071 "$node_(556) setdest 85707 38922 15.0" 
$ns at 677.2365848421632 "$node_(556) setdest 118754 35520 19.0" 
$ns at 812.5977747503723 "$node_(556) setdest 127292 32842 14.0" 
$ns at 572.5390674603968 "$node_(557) setdest 103981 36142 12.0" 
$ns at 618.3055303962102 "$node_(557) setdest 38176 6275 17.0" 
$ns at 737.5983160536479 "$node_(557) setdest 20809 29221 3.0" 
$ns at 796.4770254633218 "$node_(557) setdest 24600 30756 9.0" 
$ns at 855.5432595840965 "$node_(557) setdest 76677 21789 15.0" 
$ns at 544.4168138345124 "$node_(558) setdest 40274 24259 1.0" 
$ns at 580.3711524640886 "$node_(558) setdest 63473 16827 7.0" 
$ns at 672.685695704172 "$node_(558) setdest 44599 30561 14.0" 
$ns at 747.0549914178372 "$node_(558) setdest 71592 10735 11.0" 
$ns at 873.8474064009846 "$node_(558) setdest 21557 6750 16.0" 
$ns at 583.6421340783295 "$node_(559) setdest 37495 10686 9.0" 
$ns at 686.4952373751933 "$node_(559) setdest 111609 16952 12.0" 
$ns at 776.6076406723985 "$node_(559) setdest 94714 10007 5.0" 
$ns at 819.2556936869076 "$node_(559) setdest 110002 40899 9.0" 
$ns at 868.2488553999722 "$node_(559) setdest 72958 15292 1.0" 
$ns at 535.7008409549901 "$node_(560) setdest 82182 15572 6.0" 
$ns at 604.6669658133178 "$node_(560) setdest 90097 42025 5.0" 
$ns at 663.4726129304586 "$node_(560) setdest 49696 10864 1.0" 
$ns at 696.9202162656536 "$node_(560) setdest 120210 20943 11.0" 
$ns at 805.6802295444185 "$node_(560) setdest 67359 589 13.0" 
$ns at 521.0472061624346 "$node_(561) setdest 28330 36489 16.0" 
$ns at 597.7363558154395 "$node_(561) setdest 110110 31725 19.0" 
$ns at 777.8986082421316 "$node_(561) setdest 92899 1594 19.0" 
$ns at 500.4449265890658 "$node_(562) setdest 35379 32575 3.0" 
$ns at 537.2216562371607 "$node_(562) setdest 75998 4869 5.0" 
$ns at 573.9788880831394 "$node_(562) setdest 45214 33111 19.0" 
$ns at 652.7942628119732 "$node_(562) setdest 132441 8735 1.0" 
$ns at 690.5140399571953 "$node_(562) setdest 71 38065 8.0" 
$ns at 755.3484856435837 "$node_(562) setdest 24237 5866 19.0" 
$ns at 845.3699168606873 "$node_(562) setdest 116181 13052 17.0" 
$ns at 595.4796303820963 "$node_(563) setdest 22376 28398 17.0" 
$ns at 738.8477953136256 "$node_(563) setdest 82931 22630 18.0" 
$ns at 504.60007169315156 "$node_(564) setdest 29129 32367 7.0" 
$ns at 585.3652599230752 "$node_(564) setdest 48579 14103 7.0" 
$ns at 617.4794274218398 "$node_(564) setdest 24359 31850 6.0" 
$ns at 676.8220891072269 "$node_(564) setdest 97633 17949 18.0" 
$ns at 866.5013807342715 "$node_(564) setdest 64416 38207 13.0" 
$ns at 528.3813201361137 "$node_(565) setdest 79928 14353 9.0" 
$ns at 600.1441842955313 "$node_(565) setdest 31994 19541 17.0" 
$ns at 643.4263544899603 "$node_(565) setdest 33106 40485 14.0" 
$ns at 735.5515914597287 "$node_(565) setdest 85503 26924 15.0" 
$ns at 828.8192303092142 "$node_(565) setdest 10747 39734 5.0" 
$ns at 859.0570313565797 "$node_(565) setdest 75370 7145 14.0" 
$ns at 537.3640610523937 "$node_(566) setdest 44508 7272 16.0" 
$ns at 668.5502111492655 "$node_(566) setdest 68816 15594 2.0" 
$ns at 710.55915634619 "$node_(566) setdest 109816 32084 8.0" 
$ns at 769.468171721721 "$node_(566) setdest 123950 11104 17.0" 
$ns at 589.4336048966571 "$node_(567) setdest 103869 8766 17.0" 
$ns at 699.5532679281035 "$node_(567) setdest 36994 28433 11.0" 
$ns at 752.1208113602219 "$node_(567) setdest 122905 8594 8.0" 
$ns at 843.1921176776207 "$node_(567) setdest 55339 20824 10.0" 
$ns at 618.7766138430156 "$node_(568) setdest 21556 43568 11.0" 
$ns at 741.0461554632233 "$node_(568) setdest 130112 38916 6.0" 
$ns at 775.5814809307157 "$node_(568) setdest 106702 44525 6.0" 
$ns at 858.117413735813 "$node_(568) setdest 7466 11366 14.0" 
$ns at 541.9525314121543 "$node_(569) setdest 130280 39959 2.0" 
$ns at 581.5847259881484 "$node_(569) setdest 54025 4099 2.0" 
$ns at 630.1402424897759 "$node_(569) setdest 38623 35631 13.0" 
$ns at 682.8509999512855 "$node_(569) setdest 87710 30709 18.0" 
$ns at 724.8029201151506 "$node_(569) setdest 17088 28408 13.0" 
$ns at 863.1617930199566 "$node_(569) setdest 84781 41414 13.0" 
$ns at 585.380776944301 "$node_(570) setdest 117812 28376 2.0" 
$ns at 617.9299803081851 "$node_(570) setdest 87505 30233 8.0" 
$ns at 716.6427711218323 "$node_(570) setdest 89107 23310 10.0" 
$ns at 800.7196512715562 "$node_(570) setdest 87478 2723 5.0" 
$ns at 849.932444924576 "$node_(570) setdest 98023 24256 13.0" 
$ns at 580.8883689020905 "$node_(571) setdest 12921 42740 8.0" 
$ns at 676.5790821208304 "$node_(571) setdest 88033 9818 3.0" 
$ns at 730.9889299277834 "$node_(571) setdest 29639 1454 10.0" 
$ns at 762.7466534009868 "$node_(571) setdest 14899 12577 17.0" 
$ns at 532.455329360386 "$node_(572) setdest 4838 28616 1.0" 
$ns at 568.7203419336139 "$node_(572) setdest 63491 365 17.0" 
$ns at 691.985674838702 "$node_(572) setdest 98347 18887 16.0" 
$ns at 845.0210739648799 "$node_(572) setdest 3290 34606 1.0" 
$ns at 881.1472877839253 "$node_(572) setdest 126493 34675 14.0" 
$ns at 594.8309240331873 "$node_(573) setdest 127329 18720 14.0" 
$ns at 661.4263185350017 "$node_(573) setdest 75282 28788 13.0" 
$ns at 750.2096374983676 "$node_(573) setdest 6831 43150 4.0" 
$ns at 809.6762095097672 "$node_(573) setdest 9292 18767 7.0" 
$ns at 857.9416785959302 "$node_(573) setdest 127885 3119 1.0" 
$ns at 897.7142687784079 "$node_(573) setdest 43607 9228 19.0" 
$ns at 548.4072908907398 "$node_(574) setdest 128945 15186 7.0" 
$ns at 623.3471462205611 "$node_(574) setdest 78710 18990 10.0" 
$ns at 660.0249787065354 "$node_(574) setdest 96639 16411 16.0" 
$ns at 799.3197077106612 "$node_(574) setdest 13740 41274 10.0" 
$ns at 513.3688339841846 "$node_(575) setdest 77462 33900 9.0" 
$ns at 552.328114798304 "$node_(575) setdest 11124 25791 10.0" 
$ns at 591.3292457054104 "$node_(575) setdest 92973 22130 15.0" 
$ns at 621.6737066078582 "$node_(575) setdest 40424 17786 15.0" 
$ns at 770.1407252167432 "$node_(575) setdest 77232 37598 18.0" 
$ns at 821.3485012677045 "$node_(575) setdest 82109 11637 14.0" 
$ns at 894.9894385985897 "$node_(575) setdest 92736 28911 17.0" 
$ns at 569.9311635395466 "$node_(576) setdest 28606 16023 12.0" 
$ns at 610.914487033174 "$node_(576) setdest 32614 42136 6.0" 
$ns at 642.1118236204408 "$node_(576) setdest 8052 34953 16.0" 
$ns at 828.2095934923731 "$node_(576) setdest 93751 43449 2.0" 
$ns at 860.1273216508199 "$node_(576) setdest 1687 26823 9.0" 
$ns at 546.7958063039101 "$node_(577) setdest 23941 29307 15.0" 
$ns at 678.4470023513941 "$node_(577) setdest 80598 20286 5.0" 
$ns at 710.0876280459102 "$node_(577) setdest 121704 5022 2.0" 
$ns at 745.6944698844572 "$node_(577) setdest 131647 42908 18.0" 
$ns at 861.5192987374882 "$node_(577) setdest 99704 23891 4.0" 
$ns at 643.9764177340212 "$node_(578) setdest 55241 869 12.0" 
$ns at 730.257934373348 "$node_(578) setdest 48126 18528 12.0" 
$ns at 870.3295409305581 "$node_(578) setdest 21399 30439 19.0" 
$ns at 603.1443705619644 "$node_(579) setdest 107099 10682 10.0" 
$ns at 681.1342784283253 "$node_(579) setdest 113668 21101 6.0" 
$ns at 743.9316134803329 "$node_(579) setdest 95606 28482 11.0" 
$ns at 837.8014536275228 "$node_(579) setdest 30482 22236 15.0" 
$ns at 582.8025598565807 "$node_(580) setdest 76080 31664 11.0" 
$ns at 630.7179056271339 "$node_(580) setdest 122662 22676 2.0" 
$ns at 664.740767580924 "$node_(580) setdest 12873 20461 6.0" 
$ns at 747.8953086327549 "$node_(580) setdest 71119 20502 14.0" 
$ns at 882.3878563065396 "$node_(580) setdest 132398 570 18.0" 
$ns at 522.7394141321844 "$node_(581) setdest 51660 17794 14.0" 
$ns at 650.7642960057949 "$node_(581) setdest 94637 8680 9.0" 
$ns at 766.1500210327334 "$node_(581) setdest 5149 18831 5.0" 
$ns at 829.6973871047853 "$node_(581) setdest 84160 1773 2.0" 
$ns at 874.3653501299777 "$node_(581) setdest 113444 12378 12.0" 
$ns at 532.441570364919 "$node_(582) setdest 108031 13321 4.0" 
$ns at 576.9614021483665 "$node_(582) setdest 99056 39431 15.0" 
$ns at 630.3399343749389 "$node_(582) setdest 90722 27490 4.0" 
$ns at 677.9295608325205 "$node_(582) setdest 2247 38818 15.0" 
$ns at 788.849047910786 "$node_(582) setdest 87758 16603 10.0" 
$ns at 888.3043561276106 "$node_(582) setdest 84033 4140 17.0" 
$ns at 532.8353506357109 "$node_(583) setdest 100203 36812 10.0" 
$ns at 651.5852691677663 "$node_(583) setdest 109207 21996 17.0" 
$ns at 682.0033804657168 "$node_(583) setdest 75591 39889 16.0" 
$ns at 811.3245429506678 "$node_(583) setdest 86027 3885 1.0" 
$ns at 850.236581395068 "$node_(583) setdest 132847 10078 2.0" 
$ns at 881.4622923592236 "$node_(583) setdest 27865 31353 13.0" 
$ns at 558.5103244524895 "$node_(584) setdest 49195 17857 8.0" 
$ns at 642.470556352153 "$node_(584) setdest 81687 30122 16.0" 
$ns at 813.5929036550185 "$node_(584) setdest 82329 21744 5.0" 
$ns at 853.78602021297 "$node_(584) setdest 15906 38164 4.0" 
$ns at 891.5715120645087 "$node_(584) setdest 9933 24101 6.0" 
$ns at 546.745881225428 "$node_(585) setdest 83001 21895 17.0" 
$ns at 727.6707225753471 "$node_(585) setdest 92944 26429 8.0" 
$ns at 779.6440070817713 "$node_(585) setdest 89862 25968 13.0" 
$ns at 880.8545461233534 "$node_(585) setdest 10529 38399 20.0" 
$ns at 547.404328925455 "$node_(586) setdest 24532 36866 4.0" 
$ns at 581.2959209690357 "$node_(586) setdest 120606 3523 15.0" 
$ns at 708.7458217777822 "$node_(586) setdest 15406 15143 11.0" 
$ns at 787.8842912315146 "$node_(586) setdest 37347 43867 10.0" 
$ns at 894.12436047718 "$node_(586) setdest 24670 23113 15.0" 
$ns at 517.4819834528195 "$node_(587) setdest 51075 25002 15.0" 
$ns at 548.2524350994534 "$node_(587) setdest 110956 11555 10.0" 
$ns at 596.5490815335146 "$node_(587) setdest 70784 17390 9.0" 
$ns at 626.806509347396 "$node_(587) setdest 87031 40795 20.0" 
$ns at 794.2993996420264 "$node_(587) setdest 33791 36721 16.0" 
$ns at 532.2100327203412 "$node_(588) setdest 63797 17291 5.0" 
$ns at 592.0830535277528 "$node_(588) setdest 97704 25558 19.0" 
$ns at 632.8894912057598 "$node_(588) setdest 61042 44464 1.0" 
$ns at 672.5951376308288 "$node_(588) setdest 59814 18402 9.0" 
$ns at 770.6519009031853 "$node_(588) setdest 69452 20367 10.0" 
$ns at 832.3210783219045 "$node_(588) setdest 71939 23444 18.0" 
$ns at 516.2093809405587 "$node_(589) setdest 59161 11179 17.0" 
$ns at 552.5001126643274 "$node_(589) setdest 45130 23396 6.0" 
$ns at 601.7595420572766 "$node_(589) setdest 27052 4320 18.0" 
$ns at 718.7101944599907 "$node_(589) setdest 6619 30024 18.0" 
$ns at 853.2477812804141 "$node_(589) setdest 115906 31031 9.0" 
$ns at 656.6163783964802 "$node_(590) setdest 111789 18675 4.0" 
$ns at 721.5636949309483 "$node_(590) setdest 24369 4839 17.0" 
$ns at 765.6175586614773 "$node_(590) setdest 25207 7143 15.0" 
$ns at 598.5636590892319 "$node_(591) setdest 3491 34048 10.0" 
$ns at 682.5193849097727 "$node_(591) setdest 45426 29948 10.0" 
$ns at 741.6490876454402 "$node_(591) setdest 14085 9854 17.0" 
$ns at 791.1722717081223 "$node_(591) setdest 15264 6695 9.0" 
$ns at 836.0772112589628 "$node_(591) setdest 39466 11232 4.0" 
$ns at 894.0162071452215 "$node_(591) setdest 133938 31987 17.0" 
$ns at 528.8634515612323 "$node_(592) setdest 107893 19130 10.0" 
$ns at 564.2572897977124 "$node_(592) setdest 94885 7762 3.0" 
$ns at 609.5748890239626 "$node_(592) setdest 115001 15649 4.0" 
$ns at 670.7515479969632 "$node_(592) setdest 28958 28726 16.0" 
$ns at 842.9427798390998 "$node_(592) setdest 111598 10753 10.0" 
$ns at 898.5543476783141 "$node_(592) setdest 84974 11053 11.0" 
$ns at 583.3420169915215 "$node_(593) setdest 94253 21879 19.0" 
$ns at 697.2376163059101 "$node_(593) setdest 39271 34647 5.0" 
$ns at 756.4958783205317 "$node_(593) setdest 29073 26065 16.0" 
$ns at 584.174441376813 "$node_(594) setdest 81219 35391 4.0" 
$ns at 627.0185153130863 "$node_(594) setdest 4792 39376 14.0" 
$ns at 666.4546568400831 "$node_(594) setdest 112956 40734 13.0" 
$ns at 815.4813195588348 "$node_(594) setdest 27716 13772 4.0" 
$ns at 861.4138052717572 "$node_(594) setdest 72468 18244 7.0" 
$ns at 548.7731545086363 "$node_(595) setdest 133442 3239 1.0" 
$ns at 584.3877580103184 "$node_(595) setdest 123382 36154 7.0" 
$ns at 670.1630475509766 "$node_(595) setdest 122714 43142 9.0" 
$ns at 713.0622697112503 "$node_(595) setdest 73604 5186 6.0" 
$ns at 763.8788364165999 "$node_(595) setdest 22214 29261 15.0" 
$ns at 838.2089908369853 "$node_(595) setdest 34632 35451 13.0" 
$ns at 536.9099322464795 "$node_(596) setdest 1119 33754 14.0" 
$ns at 616.307117891756 "$node_(596) setdest 128243 20477 12.0" 
$ns at 715.235860197032 "$node_(596) setdest 49137 19751 13.0" 
$ns at 754.7360044665503 "$node_(596) setdest 37581 14548 4.0" 
$ns at 809.6437203565447 "$node_(596) setdest 130357 11537 10.0" 
$ns at 876.815205970757 "$node_(596) setdest 120445 29647 1.0" 
$ns at 557.3608482060463 "$node_(597) setdest 63092 39681 16.0" 
$ns at 675.6263806262047 "$node_(597) setdest 60012 26683 6.0" 
$ns at 751.276836738266 "$node_(597) setdest 103133 15989 18.0" 
$ns at 846.1019424157497 "$node_(597) setdest 87043 23408 17.0" 
$ns at 893.2682696901335 "$node_(597) setdest 55384 34139 13.0" 
$ns at 649.3982315936792 "$node_(598) setdest 53325 18163 11.0" 
$ns at 759.7268519856348 "$node_(598) setdest 55760 33818 19.0" 
$ns at 527.9614197652002 "$node_(599) setdest 22514 28290 5.0" 
$ns at 605.3016504531034 "$node_(599) setdest 56594 9784 1.0" 
$ns at 636.9370045257131 "$node_(599) setdest 20680 8569 1.0" 
$ns at 673.4396391257219 "$node_(599) setdest 11042 35469 19.0" 
$ns at 886.3090693626876 "$node_(599) setdest 40701 32195 10.0" 
$ns at 631.5430551235094 "$node_(600) setdest 129338 4545 5.0" 
$ns at 698.5533073238581 "$node_(600) setdest 375 9139 3.0" 
$ns at 732.6628277788279 "$node_(600) setdest 9122 35219 7.0" 
$ns at 765.8838877682642 "$node_(600) setdest 11921 1008 8.0" 
$ns at 829.478247819778 "$node_(600) setdest 114050 5330 7.0" 
$ns at 601.0486790937903 "$node_(601) setdest 81266 42653 7.0" 
$ns at 678.2940489852205 "$node_(601) setdest 69641 33822 7.0" 
$ns at 746.9120792675018 "$node_(601) setdest 60398 4978 12.0" 
$ns at 807.8013807845281 "$node_(601) setdest 122978 11994 12.0" 
$ns at 895.4901689914884 "$node_(601) setdest 16106 43178 13.0" 
$ns at 670.1220028083904 "$node_(602) setdest 24542 10734 5.0" 
$ns at 746.7665843944236 "$node_(602) setdest 57500 3236 14.0" 
$ns at 846.9515606599421 "$node_(602) setdest 129199 39714 6.0" 
$ns at 642.7765036733505 "$node_(603) setdest 117068 27520 5.0" 
$ns at 719.5467349616508 "$node_(603) setdest 53217 25523 9.0" 
$ns at 759.6441572838173 "$node_(603) setdest 77809 10556 20.0" 
$ns at 859.1962171614756 "$node_(603) setdest 113044 32149 1.0" 
$ns at 890.2050073232547 "$node_(603) setdest 77416 14520 15.0" 
$ns at 630.0975985053999 "$node_(604) setdest 130970 5929 3.0" 
$ns at 681.9690138686448 "$node_(604) setdest 42205 33106 12.0" 
$ns at 823.0876842204941 "$node_(604) setdest 23717 10815 6.0" 
$ns at 898.7797166689991 "$node_(604) setdest 82604 696 19.0" 
$ns at 688.6638008800298 "$node_(605) setdest 37155 16664 10.0" 
$ns at 727.9699147073195 "$node_(605) setdest 11521 36351 13.0" 
$ns at 817.2138927824068 "$node_(605) setdest 71855 43669 15.0" 
$ns at 868.5416340673692 "$node_(605) setdest 25584 26797 14.0" 
$ns at 665.033584038628 "$node_(606) setdest 113556 13325 3.0" 
$ns at 704.9706977387763 "$node_(606) setdest 66568 2442 2.0" 
$ns at 754.3068163725632 "$node_(606) setdest 59559 27627 5.0" 
$ns at 809.1373356917788 "$node_(606) setdest 132707 36408 17.0" 
$ns at 697.3657587735056 "$node_(607) setdest 82367 32831 13.0" 
$ns at 784.0653795469303 "$node_(607) setdest 51992 43435 15.0" 
$ns at 601.780026873383 "$node_(608) setdest 113007 20753 20.0" 
$ns at 705.313495071641 "$node_(608) setdest 128899 16322 18.0" 
$ns at 869.4839831257773 "$node_(608) setdest 40327 27300 2.0" 
$ns at 605.3487674151894 "$node_(609) setdest 52617 10972 19.0" 
$ns at 710.6470171846112 "$node_(609) setdest 94232 13844 6.0" 
$ns at 788.8936555952766 "$node_(609) setdest 724 38052 1.0" 
$ns at 828.7929374231579 "$node_(609) setdest 119638 30488 6.0" 
$ns at 879.0970688064307 "$node_(609) setdest 32864 6725 17.0" 
$ns at 689.2278468264869 "$node_(610) setdest 133870 29156 13.0" 
$ns at 741.0469464011563 "$node_(610) setdest 34099 4432 5.0" 
$ns at 819.2090079753943 "$node_(610) setdest 16181 36049 4.0" 
$ns at 888.844469484714 "$node_(610) setdest 63113 35239 16.0" 
$ns at 633.2507290390055 "$node_(611) setdest 96634 38302 13.0" 
$ns at 777.1380908694441 "$node_(611) setdest 126753 28727 6.0" 
$ns at 858.8684279410782 "$node_(611) setdest 47834 38779 4.0" 
$ns at 898.3137784219412 "$node_(611) setdest 106332 39344 13.0" 
$ns at 640.0603913099899 "$node_(612) setdest 72275 42852 16.0" 
$ns at 680.5070205250746 "$node_(612) setdest 110331 6907 14.0" 
$ns at 798.985844574264 "$node_(612) setdest 99591 40591 14.0" 
$ns at 615.0456001957481 "$node_(613) setdest 112891 34802 14.0" 
$ns at 692.7366722288047 "$node_(613) setdest 46596 38790 6.0" 
$ns at 741.7110770570121 "$node_(613) setdest 118634 41025 17.0" 
$ns at 787.1471505437978 "$node_(613) setdest 70511 39091 14.0" 
$ns at 828.2381725873547 "$node_(613) setdest 97667 40013 15.0" 
$ns at 686.5370723776624 "$node_(614) setdest 90832 24124 1.0" 
$ns at 720.6430092692476 "$node_(614) setdest 68626 31789 8.0" 
$ns at 815.132414543092 "$node_(614) setdest 2858 138 7.0" 
$ns at 662.1551654119573 "$node_(615) setdest 47113 24638 1.0" 
$ns at 697.7961413894952 "$node_(615) setdest 126185 2807 8.0" 
$ns at 794.3543030348553 "$node_(615) setdest 26175 28258 13.0" 
$ns at 880.8967399586414 "$node_(615) setdest 78422 6042 8.0" 
$ns at 629.3814722569973 "$node_(616) setdest 45232 21399 16.0" 
$ns at 783.373972970827 "$node_(616) setdest 67601 30698 2.0" 
$ns at 833.1246373174397 "$node_(616) setdest 120464 37897 14.0" 
$ns at 613.229240645677 "$node_(617) setdest 12434 17076 14.0" 
$ns at 670.424899658399 "$node_(617) setdest 75736 27762 9.0" 
$ns at 710.0944526944429 "$node_(617) setdest 60092 156 18.0" 
$ns at 833.9775422544119 "$node_(617) setdest 93298 18735 7.0" 
$ns at 880.4440268791093 "$node_(617) setdest 94813 24955 6.0" 
$ns at 665.7948243975761 "$node_(618) setdest 25852 1242 14.0" 
$ns at 812.9426729211689 "$node_(618) setdest 122721 34340 13.0" 
$ns at 639.4978763047377 "$node_(619) setdest 236 30449 6.0" 
$ns at 669.9894673610843 "$node_(619) setdest 97282 39344 19.0" 
$ns at 821.8309098774056 "$node_(619) setdest 63077 15326 5.0" 
$ns at 887.0438717272203 "$node_(619) setdest 52330 21984 6.0" 
$ns at 617.3790646105083 "$node_(620) setdest 55412 21634 19.0" 
$ns at 671.0891267599584 "$node_(620) setdest 59742 15692 13.0" 
$ns at 753.7661625829915 "$node_(620) setdest 118312 40165 14.0" 
$ns at 803.9092534936492 "$node_(620) setdest 73113 20555 6.0" 
$ns at 889.0751812092715 "$node_(620) setdest 5334 5788 14.0" 
$ns at 662.3909876231139 "$node_(621) setdest 72561 12801 14.0" 
$ns at 773.695629738749 "$node_(621) setdest 36977 14038 11.0" 
$ns at 891.2308514613027 "$node_(621) setdest 2858 10480 6.0" 
$ns at 610.3306653535554 "$node_(622) setdest 88660 42807 4.0" 
$ns at 669.7700925317049 "$node_(622) setdest 33328 148 18.0" 
$ns at 827.0417613625268 "$node_(622) setdest 64493 2125 10.0" 
$ns at 688.0635239522927 "$node_(623) setdest 58231 33961 15.0" 
$ns at 784.7833442992101 "$node_(623) setdest 36981 29258 19.0" 
$ns at 649.4467398476195 "$node_(624) setdest 97710 10858 9.0" 
$ns at 742.9280232870452 "$node_(624) setdest 67217 16397 11.0" 
$ns at 787.9330995379695 "$node_(624) setdest 62779 43928 14.0" 
$ns at 612.3407756750228 "$node_(625) setdest 72414 37085 9.0" 
$ns at 668.9158887121301 "$node_(625) setdest 25788 6002 16.0" 
$ns at 840.4444053217586 "$node_(625) setdest 126323 37369 15.0" 
$ns at 876.5071278075753 "$node_(625) setdest 59022 2337 20.0" 
$ns at 744.3753338508061 "$node_(626) setdest 24778 14504 8.0" 
$ns at 799.7845562835632 "$node_(626) setdest 105634 44376 15.0" 
$ns at 851.048426979542 "$node_(626) setdest 59559 2644 16.0" 
$ns at 648.4736223715482 "$node_(627) setdest 119121 5598 5.0" 
$ns at 715.6151275694289 "$node_(627) setdest 52515 19304 1.0" 
$ns at 752.3062750078993 "$node_(627) setdest 73069 31792 13.0" 
$ns at 823.1846175971193 "$node_(627) setdest 107706 34223 16.0" 
$ns at 641.0583861546127 "$node_(628) setdest 75789 21499 14.0" 
$ns at 712.0645993938058 "$node_(628) setdest 32299 37928 11.0" 
$ns at 779.2418455322279 "$node_(628) setdest 105998 28000 19.0" 
$ns at 602.9639829183877 "$node_(629) setdest 53965 41262 7.0" 
$ns at 698.6041029609527 "$node_(629) setdest 122286 6344 3.0" 
$ns at 740.3922100762328 "$node_(629) setdest 73519 2769 4.0" 
$ns at 791.0998430275517 "$node_(629) setdest 126196 1899 10.0" 
$ns at 856.8431180690395 "$node_(629) setdest 43996 1364 3.0" 
$ns at 635.2337768227432 "$node_(630) setdest 106279 38826 14.0" 
$ns at 781.3618186310316 "$node_(630) setdest 128324 39165 7.0" 
$ns at 874.9257905869551 "$node_(630) setdest 8270 4523 11.0" 
$ns at 608.387616843029 "$node_(631) setdest 79031 6866 11.0" 
$ns at 659.4606712715608 "$node_(631) setdest 15369 23286 1.0" 
$ns at 693.0807493231405 "$node_(631) setdest 55361 9895 11.0" 
$ns at 723.3080013777809 "$node_(631) setdest 79614 20597 5.0" 
$ns at 767.1121622706337 "$node_(631) setdest 55731 34348 7.0" 
$ns at 812.4754648180784 "$node_(631) setdest 58976 15529 10.0" 
$ns at 891.318604234533 "$node_(631) setdest 52922 41703 2.0" 
$ns at 607.7030098265448 "$node_(632) setdest 37062 7364 14.0" 
$ns at 637.8658503162658 "$node_(632) setdest 67005 35826 13.0" 
$ns at 703.0587484773064 "$node_(632) setdest 73760 33959 9.0" 
$ns at 755.4055259667779 "$node_(632) setdest 39601 14628 3.0" 
$ns at 808.0510308120043 "$node_(632) setdest 50332 26093 13.0" 
$ns at 676.8163759788613 "$node_(633) setdest 126822 31627 15.0" 
$ns at 801.9550805485862 "$node_(633) setdest 110724 15121 5.0" 
$ns at 880.3940095783474 "$node_(633) setdest 58286 17011 14.0" 
$ns at 645.2507552436788 "$node_(634) setdest 93956 22424 7.0" 
$ns at 705.3013986719861 "$node_(634) setdest 87928 13278 7.0" 
$ns at 785.8514131713462 "$node_(634) setdest 57940 6236 7.0" 
$ns at 878.207136058473 "$node_(634) setdest 18978 23837 17.0" 
$ns at 620.5428552186679 "$node_(635) setdest 81943 38450 12.0" 
$ns at 738.0799314856414 "$node_(635) setdest 111628 23055 4.0" 
$ns at 799.5067336385159 "$node_(635) setdest 5176 32623 11.0" 
$ns at 650.5868460002677 "$node_(636) setdest 92898 701 1.0" 
$ns at 683.2897055978432 "$node_(636) setdest 62943 44229 8.0" 
$ns at 760.7918486120849 "$node_(636) setdest 124458 35185 10.0" 
$ns at 831.8382952800853 "$node_(636) setdest 83054 34506 9.0" 
$ns at 867.3672835879551 "$node_(636) setdest 28416 16203 15.0" 
$ns at 607.5801877204128 "$node_(637) setdest 57810 43679 12.0" 
$ns at 664.9736852278841 "$node_(637) setdest 8132 12454 9.0" 
$ns at 740.4795696332479 "$node_(637) setdest 133725 28627 9.0" 
$ns at 789.6458236440448 "$node_(637) setdest 49149 28659 19.0" 
$ns at 722.4814787585553 "$node_(638) setdest 100852 30494 5.0" 
$ns at 798.3888101093418 "$node_(638) setdest 59295 25358 1.0" 
$ns at 831.4435101424964 "$node_(638) setdest 132351 38659 16.0" 
$ns at 613.6271736305177 "$node_(639) setdest 79920 23493 16.0" 
$ns at 737.7669293920678 "$node_(639) setdest 111741 7805 13.0" 
$ns at 843.7885164767948 "$node_(639) setdest 125992 15760 12.0" 
$ns at 892.8425106312891 "$node_(639) setdest 725 11772 19.0" 
$ns at 601.4162303009653 "$node_(640) setdest 108338 28807 14.0" 
$ns at 708.5361263830582 "$node_(640) setdest 99949 38161 17.0" 
$ns at 863.1438532371785 "$node_(640) setdest 74179 42764 16.0" 
$ns at 723.0809041720797 "$node_(641) setdest 113167 37084 14.0" 
$ns at 888.7375309409811 "$node_(641) setdest 37267 37688 15.0" 
$ns at 666.2534196611831 "$node_(642) setdest 33323 5715 5.0" 
$ns at 709.0402167348761 "$node_(642) setdest 126773 8194 16.0" 
$ns at 760.7601458878333 "$node_(642) setdest 95038 16073 19.0" 
$ns at 713.8278933587596 "$node_(643) setdest 30273 14809 9.0" 
$ns at 766.6181891515765 "$node_(643) setdest 62593 28629 19.0" 
$ns at 606.127033318901 "$node_(644) setdest 6939 4345 15.0" 
$ns at 662.3369760038521 "$node_(644) setdest 30919 35408 12.0" 
$ns at 781.3617688322145 "$node_(644) setdest 68886 23763 19.0" 
$ns at 682.6300574790981 "$node_(645) setdest 45591 14518 4.0" 
$ns at 714.458330837343 "$node_(645) setdest 48007 29817 1.0" 
$ns at 748.74119065274 "$node_(645) setdest 1943 5236 2.0" 
$ns at 787.5998446796311 "$node_(645) setdest 119397 25860 19.0" 
$ns at 609.632276631424 "$node_(646) setdest 26557 27757 12.0" 
$ns at 660.5011033309687 "$node_(646) setdest 13096 30612 2.0" 
$ns at 708.0671135574049 "$node_(646) setdest 122761 42338 15.0" 
$ns at 761.2105106650392 "$node_(646) setdest 97541 4328 1.0" 
$ns at 795.8355434932239 "$node_(646) setdest 42025 13947 11.0" 
$ns at 683.1946451776237 "$node_(647) setdest 15794 5059 17.0" 
$ns at 715.3165703740658 "$node_(647) setdest 71854 8797 11.0" 
$ns at 837.8336210674328 "$node_(647) setdest 34590 12620 7.0" 
$ns at 674.486036039413 "$node_(648) setdest 43425 16918 5.0" 
$ns at 716.9436968906945 "$node_(648) setdest 76432 18956 8.0" 
$ns at 793.9067490828654 "$node_(648) setdest 10647 31798 15.0" 
$ns at 689.4464168028458 "$node_(649) setdest 65021 22081 9.0" 
$ns at 783.4908931610742 "$node_(649) setdest 107867 22494 9.0" 
$ns at 837.7681646534963 "$node_(649) setdest 105163 15768 13.0" 
$ns at 661.5086714933668 "$node_(650) setdest 52952 22235 3.0" 
$ns at 707.3349960400029 "$node_(650) setdest 72160 27303 9.0" 
$ns at 824.4867034895572 "$node_(650) setdest 62666 9682 20.0" 
$ns at 870.9970487046222 "$node_(650) setdest 89297 39676 14.0" 
$ns at 751.5550061140452 "$node_(651) setdest 78238 43514 1.0" 
$ns at 786.899492688505 "$node_(651) setdest 11076 12509 3.0" 
$ns at 829.6483014367592 "$node_(651) setdest 8319 20509 12.0" 
$ns at 899.478570807923 "$node_(651) setdest 39234 444 9.0" 
$ns at 697.9127740174494 "$node_(652) setdest 17113 23823 6.0" 
$ns at 743.7096717709584 "$node_(652) setdest 113270 41132 8.0" 
$ns at 787.5621360519293 "$node_(652) setdest 134074 43873 11.0" 
$ns at 842.8390581347409 "$node_(652) setdest 77554 43955 19.0" 
$ns at 610.6540185523238 "$node_(653) setdest 91444 23708 17.0" 
$ns at 741.4893144392969 "$node_(653) setdest 33766 41242 1.0" 
$ns at 778.3542676162407 "$node_(653) setdest 124668 2627 7.0" 
$ns at 813.3482834577619 "$node_(653) setdest 9860 7640 2.0" 
$ns at 849.2414959029095 "$node_(653) setdest 61774 33762 13.0" 
$ns at 642.6578891025247 "$node_(654) setdest 86081 17041 14.0" 
$ns at 698.4981218570814 "$node_(654) setdest 123768 16344 3.0" 
$ns at 738.9115525057999 "$node_(654) setdest 60015 24739 3.0" 
$ns at 769.2279716828214 "$node_(654) setdest 107449 23890 16.0" 
$ns at 888.6352582629879 "$node_(654) setdest 46167 12189 18.0" 
$ns at 726.6228060646138 "$node_(655) setdest 101911 33718 5.0" 
$ns at 781.2751128093556 "$node_(655) setdest 21782 28906 1.0" 
$ns at 818.6773164741082 "$node_(655) setdest 23131 43524 15.0" 
$ns at 772.3403666060563 "$node_(656) setdest 38545 13537 6.0" 
$ns at 844.716465943128 "$node_(656) setdest 30746 19218 5.0" 
$ns at 702.6927116754752 "$node_(657) setdest 45468 4434 15.0" 
$ns at 814.352517007412 "$node_(657) setdest 25814 27841 15.0" 
$ns at 857.290218950194 "$node_(657) setdest 18262 40418 10.0" 
$ns at 600.1376732500294 "$node_(658) setdest 5726 4889 6.0" 
$ns at 635.4167197705531 "$node_(658) setdest 68226 43925 8.0" 
$ns at 674.2760603549013 "$node_(658) setdest 1948 27263 2.0" 
$ns at 718.5170145144396 "$node_(658) setdest 97244 42965 9.0" 
$ns at 817.5572307050427 "$node_(658) setdest 7537 44058 2.0" 
$ns at 851.7576879196691 "$node_(658) setdest 101311 7290 20.0" 
$ns at 606.6814149583079 "$node_(659) setdest 5309 4212 14.0" 
$ns at 762.1349262779335 "$node_(659) setdest 72993 15851 8.0" 
$ns at 860.996481031292 "$node_(659) setdest 102568 37224 8.0" 
$ns at 651.8972576969867 "$node_(660) setdest 38142 7643 7.0" 
$ns at 693.5549991746824 "$node_(660) setdest 55838 3458 17.0" 
$ns at 892.899017061925 "$node_(660) setdest 61321 31843 10.0" 
$ns at 606.798516712863 "$node_(661) setdest 51613 6566 1.0" 
$ns at 645.9615404550871 "$node_(661) setdest 63143 9815 3.0" 
$ns at 694.4801548996812 "$node_(661) setdest 74304 27879 10.0" 
$ns at 778.5019929424054 "$node_(661) setdest 42139 8932 13.0" 
$ns at 822.7288211533694 "$node_(661) setdest 20803 16710 9.0" 
$ns at 646.282775717266 "$node_(662) setdest 41592 24552 9.0" 
$ns at 682.71409943317 "$node_(662) setdest 123895 6978 5.0" 
$ns at 737.4355670437333 "$node_(662) setdest 84611 21626 20.0" 
$ns at 631.452029346295 "$node_(663) setdest 111030 32373 14.0" 
$ns at 785.2314880651769 "$node_(663) setdest 77778 4852 15.0" 
$ns at 660.7598153382281 "$node_(664) setdest 29888 29399 9.0" 
$ns at 780.0658431239023 "$node_(664) setdest 104630 42017 20.0" 
$ns at 862.8422033373915 "$node_(664) setdest 126912 41112 7.0" 
$ns at 677.1545495117788 "$node_(665) setdest 48004 21268 4.0" 
$ns at 712.441180886688 "$node_(665) setdest 22072 13036 12.0" 
$ns at 844.6220333879653 "$node_(665) setdest 69695 42300 1.0" 
$ns at 880.9905256420711 "$node_(665) setdest 5920 23164 12.0" 
$ns at 671.4489222382308 "$node_(666) setdest 128187 25651 11.0" 
$ns at 772.2296969542975 "$node_(666) setdest 51678 38791 9.0" 
$ns at 850.2404941519287 "$node_(666) setdest 38896 12492 3.0" 
$ns at 891.8265708266765 "$node_(666) setdest 67434 29416 13.0" 
$ns at 604.5962420191441 "$node_(667) setdest 81692 5479 19.0" 
$ns at 800.5985700282365 "$node_(667) setdest 87687 1335 1.0" 
$ns at 833.3681607773642 "$node_(667) setdest 76175 25778 18.0" 
$ns at 728.1301107055547 "$node_(668) setdest 50119 28360 2.0" 
$ns at 774.0973292414486 "$node_(668) setdest 28721 29073 10.0" 
$ns at 891.8785958569194 "$node_(668) setdest 91919 37118 3.0" 
$ns at 658.3768763852343 "$node_(669) setdest 127443 3175 14.0" 
$ns at 796.2961782086293 "$node_(669) setdest 60033 23846 15.0" 
$ns at 840.3641249400941 "$node_(669) setdest 69151 17107 13.0" 
$ns at 647.5712484243721 "$node_(670) setdest 19517 23863 16.0" 
$ns at 791.9957834899842 "$node_(670) setdest 129304 14388 4.0" 
$ns at 852.162104756326 "$node_(670) setdest 55777 34883 3.0" 
$ns at 640.4941805215285 "$node_(671) setdest 2727 6952 18.0" 
$ns at 794.1459203920991 "$node_(671) setdest 51414 40049 17.0" 
$ns at 684.432950416183 "$node_(672) setdest 89470 28321 9.0" 
$ns at 720.0949535886012 "$node_(672) setdest 5582 36004 15.0" 
$ns at 863.4459901644643 "$node_(672) setdest 4051 44302 13.0" 
$ns at 641.5626628441474 "$node_(673) setdest 4747 27792 14.0" 
$ns at 709.3881055652288 "$node_(673) setdest 113555 1259 19.0" 
$ns at 635.276713440981 "$node_(674) setdest 112944 8765 11.0" 
$ns at 765.863439421197 "$node_(674) setdest 71035 28877 19.0" 
$ns at 603.4251628203352 "$node_(675) setdest 59932 27411 9.0" 
$ns at 690.487714286289 "$node_(675) setdest 24223 24252 6.0" 
$ns at 721.7295827096406 "$node_(675) setdest 80665 43493 4.0" 
$ns at 762.0534004431845 "$node_(675) setdest 119856 4517 7.0" 
$ns at 834.276563832238 "$node_(675) setdest 123125 14082 10.0" 
$ns at 632.3054348944625 "$node_(676) setdest 106666 20613 1.0" 
$ns at 670.5014551620255 "$node_(676) setdest 101947 37593 19.0" 
$ns at 765.8731210378907 "$node_(676) setdest 49894 44359 8.0" 
$ns at 851.7632738749082 "$node_(676) setdest 90714 8660 13.0" 
$ns at 662.5240031097877 "$node_(677) setdest 74346 28332 9.0" 
$ns at 771.1839101198842 "$node_(677) setdest 128955 28811 4.0" 
$ns at 823.4785497745809 "$node_(677) setdest 6154 9988 5.0" 
$ns at 885.6026516345886 "$node_(677) setdest 133606 41864 9.0" 
$ns at 687.0799595217298 "$node_(678) setdest 71290 16391 16.0" 
$ns at 750.563386373839 "$node_(678) setdest 91278 34978 5.0" 
$ns at 796.9877114223837 "$node_(678) setdest 28719 40638 6.0" 
$ns at 882.9835040505388 "$node_(678) setdest 106176 19079 15.0" 
$ns at 760.1062824888754 "$node_(679) setdest 117080 37195 8.0" 
$ns at 834.7492974110095 "$node_(679) setdest 106662 22215 15.0" 
$ns at 779.6745117417486 "$node_(680) setdest 100130 24651 9.0" 
$ns at 846.9828473927099 "$node_(680) setdest 95082 32075 6.0" 
$ns at 604.1756809857392 "$node_(681) setdest 42469 28076 15.0" 
$ns at 719.9732883426219 "$node_(681) setdest 22631 31145 7.0" 
$ns at 773.8692532040143 "$node_(681) setdest 3892 4872 16.0" 
$ns at 888.394449705972 "$node_(681) setdest 41101 9493 7.0" 
$ns at 625.3459722823451 "$node_(682) setdest 107201 41224 10.0" 
$ns at 754.5185977475979 "$node_(682) setdest 43387 40220 18.0" 
$ns at 825.3050292140127 "$node_(682) setdest 270 12253 5.0" 
$ns at 861.4410900078218 "$node_(682) setdest 108758 20286 17.0" 
$ns at 897.6305213898099 "$node_(682) setdest 52449 41095 17.0" 
$ns at 639.485840883624 "$node_(683) setdest 78693 37806 2.0" 
$ns at 683.6101674984326 "$node_(683) setdest 53735 25388 8.0" 
$ns at 773.8816904896281 "$node_(683) setdest 59627 25597 13.0" 
$ns at 620.6509504182486 "$node_(684) setdest 82597 2798 19.0" 
$ns at 701.4621821382622 "$node_(684) setdest 120579 24770 9.0" 
$ns at 816.5699775783787 "$node_(684) setdest 129073 33667 12.0" 
$ns at 863.9756088269199 "$node_(684) setdest 44622 40904 8.0" 
$ns at 616.0876069494248 "$node_(685) setdest 8034 1956 7.0" 
$ns at 647.8516430269086 "$node_(685) setdest 61140 23669 20.0" 
$ns at 694.9441651110659 "$node_(685) setdest 43199 19288 18.0" 
$ns at 881.3009821325938 "$node_(685) setdest 117007 20759 9.0" 
$ns at 614.3809933430472 "$node_(686) setdest 65025 13851 12.0" 
$ns at 649.2112417630937 "$node_(686) setdest 46926 35515 10.0" 
$ns at 680.1751453487116 "$node_(686) setdest 126771 9864 11.0" 
$ns at 712.4817519239533 "$node_(686) setdest 118480 19022 13.0" 
$ns at 838.5535302288056 "$node_(686) setdest 49517 20000 15.0" 
$ns at 687.2480905027154 "$node_(687) setdest 14035 19630 6.0" 
$ns at 764.1490182772372 "$node_(687) setdest 43621 24200 7.0" 
$ns at 841.8265290097261 "$node_(687) setdest 4027 14114 14.0" 
$ns at 651.5098592468623 "$node_(688) setdest 31610 44278 19.0" 
$ns at 702.7127036814079 "$node_(688) setdest 94298 10502 5.0" 
$ns at 747.9812165114282 "$node_(688) setdest 63754 11363 19.0" 
$ns at 646.3186879710264 "$node_(689) setdest 36404 19027 9.0" 
$ns at 682.0243234198341 "$node_(689) setdest 77691 9662 14.0" 
$ns at 739.0165882933534 "$node_(689) setdest 30310 20903 19.0" 
$ns at 826.7891270971479 "$node_(689) setdest 71061 11720 12.0" 
$ns at 697.77007937424 "$node_(690) setdest 97536 29567 15.0" 
$ns at 803.2378989418974 "$node_(690) setdest 56510 16694 2.0" 
$ns at 849.3533510191778 "$node_(690) setdest 33663 35779 17.0" 
$ns at 606.4107385420847 "$node_(691) setdest 128835 15825 7.0" 
$ns at 701.1366216767127 "$node_(691) setdest 82996 20677 17.0" 
$ns at 861.9836311395571 "$node_(691) setdest 30778 16141 1.0" 
$ns at 659.6715754200668 "$node_(692) setdest 87123 24246 20.0" 
$ns at 749.7445858292783 "$node_(692) setdest 97756 33223 5.0" 
$ns at 812.3802153070229 "$node_(692) setdest 36231 26694 9.0" 
$ns at 883.4172754951552 "$node_(692) setdest 55875 35777 13.0" 
$ns at 616.1478363092151 "$node_(693) setdest 26983 5264 1.0" 
$ns at 651.4713345397424 "$node_(693) setdest 119182 11697 7.0" 
$ns at 697.9605732857141 "$node_(693) setdest 19423 37840 15.0" 
$ns at 800.4470381370446 "$node_(693) setdest 91978 34357 20.0" 
$ns at 616.0252535968025 "$node_(694) setdest 20303 27490 7.0" 
$ns at 715.9665402456307 "$node_(694) setdest 55259 26194 12.0" 
$ns at 806.1264659766899 "$node_(694) setdest 107954 40699 7.0" 
$ns at 646.0351184937856 "$node_(695) setdest 44527 2700 19.0" 
$ns at 764.9613675353847 "$node_(695) setdest 62286 13142 6.0" 
$ns at 805.7196850118166 "$node_(695) setdest 25212 16156 7.0" 
$ns at 841.9479745538686 "$node_(695) setdest 117026 26653 9.0" 
$ns at 885.3693563773282 "$node_(695) setdest 102055 8915 6.0" 
$ns at 664.1400831693525 "$node_(696) setdest 55765 13455 11.0" 
$ns at 731.4284921621156 "$node_(696) setdest 79036 21608 13.0" 
$ns at 777.8306314846201 "$node_(696) setdest 66000 290 11.0" 
$ns at 720.3230132825829 "$node_(697) setdest 75725 29875 17.0" 
$ns at 769.616184686389 "$node_(697) setdest 25803 29456 8.0" 
$ns at 825.8073660520173 "$node_(697) setdest 78673 43297 14.0" 
$ns at 610.1650756137853 "$node_(698) setdest 77719 30820 12.0" 
$ns at 643.6981751790928 "$node_(698) setdest 102204 9986 14.0" 
$ns at 680.253479824039 "$node_(698) setdest 103456 7759 16.0" 
$ns at 740.0072619219773 "$node_(698) setdest 111016 523 5.0" 
$ns at 810.8585748064079 "$node_(698) setdest 24740 25227 18.0" 
$ns at 866.4776170122742 "$node_(698) setdest 107807 44039 11.0" 
$ns at 640.2180449333164 "$node_(699) setdest 128405 8407 10.0" 
$ns at 722.2533040445956 "$node_(699) setdest 104517 7777 11.0" 
$ns at 802.963411941066 "$node_(699) setdest 28010 37251 15.0" 
$ns at 861.2239220615747 "$node_(699) setdest 17394 4975 5.0" 
$ns at 793.54528731558 "$node_(700) setdest 11548 41950 10.0" 
$ns at 834.0020122787008 "$node_(700) setdest 30436 31741 11.0" 
$ns at 875.0203550823296 "$node_(700) setdest 101471 30696 1.0" 
$ns at 721.8769049162805 "$node_(701) setdest 18925 23224 14.0" 
$ns at 882.3213940231578 "$node_(701) setdest 33131 19342 18.0" 
$ns at 773.2062013721934 "$node_(702) setdest 95312 25651 16.0" 
$ns at 774.9999765757393 "$node_(703) setdest 101009 2049 15.0" 
$ns at 822.8148556113842 "$node_(703) setdest 114186 29859 19.0" 
$ns at 703.9734679455679 "$node_(704) setdest 100137 23485 18.0" 
$ns at 897.1360117253191 "$node_(704) setdest 102943 16971 3.0" 
$ns at 711.4938548234288 "$node_(705) setdest 33118 6336 8.0" 
$ns at 742.6246130813981 "$node_(705) setdest 110252 33243 20.0" 
$ns at 702.0265048930751 "$node_(706) setdest 13433 36905 10.0" 
$ns at 781.4880618118581 "$node_(706) setdest 16366 28457 1.0" 
$ns at 821.3969252453235 "$node_(706) setdest 18843 43525 12.0" 
$ns at 747.3030112146597 "$node_(707) setdest 25085 31518 15.0" 
$ns at 781.6673839228049 "$node_(707) setdest 5899 20785 10.0" 
$ns at 883.7033534106322 "$node_(707) setdest 52212 21314 16.0" 
$ns at 727.7523612528265 "$node_(708) setdest 4605 25375 2.0" 
$ns at 776.4322939961767 "$node_(708) setdest 20679 24517 7.0" 
$ns at 809.8674268471216 "$node_(708) setdest 96454 17 11.0" 
$ns at 791.7636587165525 "$node_(709) setdest 35303 22118 12.0" 
$ns at 832.5315661265704 "$node_(709) setdest 39231 6735 9.0" 
$ns at 841.0136132460945 "$node_(710) setdest 118705 34168 19.0" 
$ns at 820.3224638140412 "$node_(711) setdest 103712 24284 5.0" 
$ns at 882.644659590438 "$node_(711) setdest 51220 714 3.0" 
$ns at 726.2372913993833 "$node_(713) setdest 69540 41051 1.0" 
$ns at 758.1003166283308 "$node_(713) setdest 13437 19552 15.0" 
$ns at 833.8265078870372 "$node_(713) setdest 56109 20483 19.0" 
$ns at 731.7621160776885 "$node_(714) setdest 125728 31959 14.0" 
$ns at 836.1687476540989 "$node_(714) setdest 127733 4050 12.0" 
$ns at 732.0716184311277 "$node_(715) setdest 65505 6945 2.0" 
$ns at 764.5509190111821 "$node_(715) setdest 74016 5052 19.0" 
$ns at 897.1934501607118 "$node_(715) setdest 117516 7149 5.0" 
$ns at 782.2971690910064 "$node_(716) setdest 6481 1443 9.0" 
$ns at 807.7185377600023 "$node_(717) setdest 46515 6605 5.0" 
$ns at 848.5824301656617 "$node_(717) setdest 4816 18165 10.0" 
$ns at 819.9598100923287 "$node_(718) setdest 24554 22496 19.0" 
$ns at 749.8655159667209 "$node_(719) setdest 38044 14681 9.0" 
$ns at 794.4670323583416 "$node_(719) setdest 94681 20967 15.0" 
$ns at 831.1093699457333 "$node_(720) setdest 39082 3352 1.0" 
$ns at 864.3651033303223 "$node_(720) setdest 130724 8384 12.0" 
$ns at 766.5914066977218 "$node_(721) setdest 57633 21290 18.0" 
$ns at 814.6960385119703 "$node_(722) setdest 92834 44059 14.0" 
$ns at 711.5131214315697 "$node_(723) setdest 49361 11013 10.0" 
$ns at 827.260213956059 "$node_(723) setdest 16780 21149 2.0" 
$ns at 872.3676797364839 "$node_(723) setdest 123296 4263 9.0" 
$ns at 758.720570910144 "$node_(724) setdest 63627 13927 17.0" 
$ns at 765.2537627765082 "$node_(725) setdest 5369 13458 3.0" 
$ns at 800.066604630543 "$node_(725) setdest 65612 41455 2.0" 
$ns at 845.4124470730023 "$node_(725) setdest 114436 3898 13.0" 
$ns at 737.3170564902247 "$node_(726) setdest 34294 23708 20.0" 
$ns at 713.7111221135004 "$node_(727) setdest 128380 34971 7.0" 
$ns at 796.6371097993302 "$node_(727) setdest 41276 971 13.0" 
$ns at 831.8023264755475 "$node_(727) setdest 115602 15432 9.0" 
$ns at 703.9639599760153 "$node_(728) setdest 113281 8319 3.0" 
$ns at 742.556614411118 "$node_(728) setdest 116684 3588 11.0" 
$ns at 773.7890255689101 "$node_(728) setdest 39018 40473 1.0" 
$ns at 805.1617580405865 "$node_(728) setdest 105688 8905 9.0" 
$ns at 884.4972737837304 "$node_(728) setdest 25884 10970 13.0" 
$ns at 826.8123624082299 "$node_(729) setdest 25259 16509 3.0" 
$ns at 869.9168065541014 "$node_(729) setdest 68154 142 18.0" 
$ns at 707.0846887665608 "$node_(730) setdest 98610 40581 6.0" 
$ns at 773.0339617498023 "$node_(730) setdest 84335 24723 4.0" 
$ns at 829.4778560756926 "$node_(730) setdest 18004 13506 11.0" 
$ns at 773.3677430179332 "$node_(731) setdest 26039 29665 9.0" 
$ns at 846.3991619299061 "$node_(731) setdest 115170 19141 14.0" 
$ns at 771.440153226051 "$node_(732) setdest 98576 21511 6.0" 
$ns at 803.4521797609993 "$node_(732) setdest 773 39514 13.0" 
$ns at 887.1413117919352 "$node_(732) setdest 30935 27912 11.0" 
$ns at 715.0848706682132 "$node_(733) setdest 85212 19073 20.0" 
$ns at 823.8074942852905 "$node_(733) setdest 114759 43769 9.0" 
$ns at 882.253012429752 "$node_(733) setdest 47589 22928 3.0" 
$ns at 705.112857456751 "$node_(734) setdest 87733 44414 9.0" 
$ns at 791.3012117605904 "$node_(734) setdest 23847 18410 8.0" 
$ns at 882.2367474274333 "$node_(734) setdest 54262 31929 1.0" 
$ns at 756.979094533843 "$node_(735) setdest 20908 4333 18.0" 
$ns at 713.9896520898842 "$node_(736) setdest 31980 23952 9.0" 
$ns at 774.7246525516668 "$node_(736) setdest 58890 10797 19.0" 
$ns at 748.8164463246364 "$node_(737) setdest 103558 16582 1.0" 
$ns at 783.9462148716462 "$node_(737) setdest 33000 19037 11.0" 
$ns at 790.2289647056732 "$node_(738) setdest 20775 43026 5.0" 
$ns at 821.0480311789582 "$node_(738) setdest 101531 12608 4.0" 
$ns at 874.4177170033263 "$node_(738) setdest 71601 26586 11.0" 
$ns at 705.6693898320158 "$node_(739) setdest 103438 16840 9.0" 
$ns at 822.2124543025843 "$node_(739) setdest 10368 34602 17.0" 
$ns at 710.9142405914014 "$node_(740) setdest 125510 30166 19.0" 
$ns at 762.1231623246221 "$node_(740) setdest 112093 7693 3.0" 
$ns at 818.9076184047938 "$node_(740) setdest 101915 11288 17.0" 
$ns at 849.4890459810505 "$node_(740) setdest 105685 18662 19.0" 
$ns at 895.5005735036966 "$node_(740) setdest 61049 22540 18.0" 
$ns at 755.4816213171002 "$node_(741) setdest 91050 6843 6.0" 
$ns at 788.1869561570029 "$node_(741) setdest 2936 6535 8.0" 
$ns at 849.3821844551455 "$node_(741) setdest 235 36317 17.0" 
$ns at 747.5365558588165 "$node_(742) setdest 34824 37937 19.0" 
$ns at 783.5094620894652 "$node_(742) setdest 99675 17568 16.0" 
$ns at 856.7525703704439 "$node_(742) setdest 1667 5298 13.0" 
$ns at 734.1708264125422 "$node_(743) setdest 109060 4798 13.0" 
$ns at 808.0896423022925 "$node_(743) setdest 118169 12308 9.0" 
$ns at 882.8371315216212 "$node_(743) setdest 50253 20244 3.0" 
$ns at 812.8100695420102 "$node_(744) setdest 15130 1342 1.0" 
$ns at 851.5763208743758 "$node_(744) setdest 90815 15309 6.0" 
$ns at 755.4164450433215 "$node_(745) setdest 4538 27143 5.0" 
$ns at 807.2895157523757 "$node_(745) setdest 63089 6936 15.0" 
$ns at 866.6997579312391 "$node_(745) setdest 17620 33190 14.0" 
$ns at 735.2254464201026 "$node_(746) setdest 14534 32560 10.0" 
$ns at 778.9915547687351 "$node_(746) setdest 11463 16277 13.0" 
$ns at 854.0638344767083 "$node_(746) setdest 81016 35317 7.0" 
$ns at 740.9467635751555 "$node_(747) setdest 3264 26218 12.0" 
$ns at 829.4740590978525 "$node_(747) setdest 6121 31900 2.0" 
$ns at 873.92058661384 "$node_(747) setdest 57735 22057 15.0" 
$ns at 716.1903147383098 "$node_(748) setdest 8588 8073 4.0" 
$ns at 763.3147990901272 "$node_(748) setdest 17253 28354 12.0" 
$ns at 841.163178494933 "$node_(748) setdest 49465 9412 11.0" 
$ns at 734.5224686591205 "$node_(749) setdest 19959 42538 17.0" 
$ns at 793.9847486882301 "$node_(749) setdest 42793 25926 2.0" 
$ns at 842.6695358685002 "$node_(749) setdest 52014 19181 15.0" 
$ns at 730.5855796197575 "$node_(750) setdest 46089 15116 9.0" 
$ns at 777.9153005512727 "$node_(750) setdest 43353 21060 5.0" 
$ns at 808.6841852881442 "$node_(750) setdest 132247 28600 13.0" 
$ns at 846.6899194650118 "$node_(750) setdest 70344 27934 14.0" 
$ns at 886.9396444072811 "$node_(750) setdest 1664 30010 6.0" 
$ns at 719.9782167344598 "$node_(751) setdest 112566 43696 5.0" 
$ns at 751.5638710125146 "$node_(751) setdest 35152 9780 13.0" 
$ns at 745.3686067546506 "$node_(752) setdest 99147 1554 11.0" 
$ns at 865.0190687045424 "$node_(752) setdest 14236 21948 12.0" 
$ns at 702.9721400674407 "$node_(753) setdest 127444 3039 7.0" 
$ns at 764.5134663067687 "$node_(753) setdest 54006 39165 18.0" 
$ns at 739.4623922050365 "$node_(754) setdest 22555 5327 11.0" 
$ns at 785.5062827533952 "$node_(754) setdest 50851 20308 10.0" 
$ns at 854.9797170264899 "$node_(754) setdest 79533 10596 11.0" 
$ns at 719.7383884594663 "$node_(755) setdest 88866 13142 12.0" 
$ns at 863.3844496787325 "$node_(755) setdest 87644 13738 16.0" 
$ns at 783.4830705797973 "$node_(756) setdest 40897 36977 3.0" 
$ns at 832.66350792992 "$node_(756) setdest 70088 25964 1.0" 
$ns at 865.8484576981048 "$node_(756) setdest 45927 2266 6.0" 
$ns at 744.2202363946565 "$node_(757) setdest 39329 14429 18.0" 
$ns at 774.4226694025159 "$node_(757) setdest 107603 20643 10.0" 
$ns at 851.2462619790452 "$node_(757) setdest 18670 18953 6.0" 
$ns at 887.4254176761583 "$node_(757) setdest 61966 37890 8.0" 
$ns at 718.4684601602567 "$node_(758) setdest 4852 41645 8.0" 
$ns at 757.6760913977192 "$node_(758) setdest 42514 38891 6.0" 
$ns at 788.2093316172721 "$node_(758) setdest 111348 20567 16.0" 
$ns at 894.2417935257297 "$node_(758) setdest 112129 10135 6.0" 
$ns at 703.41246271829 "$node_(759) setdest 70927 11037 5.0" 
$ns at 775.9087496916701 "$node_(759) setdest 30239 7328 14.0" 
$ns at 810.278533815534 "$node_(759) setdest 124381 35942 6.0" 
$ns at 868.1533607218647 "$node_(759) setdest 64721 10775 4.0" 
$ns at 719.9980357869395 "$node_(760) setdest 56293 19356 11.0" 
$ns at 767.1524442372526 "$node_(760) setdest 3033 35768 15.0" 
$ns at 700.5746484967838 "$node_(761) setdest 18234 14869 11.0" 
$ns at 812.235125372903 "$node_(761) setdest 9816 12997 16.0" 
$ns at 775.0356267292789 "$node_(762) setdest 21651 30407 19.0" 
$ns at 889.4165635479883 "$node_(762) setdest 71925 9076 13.0" 
$ns at 735.7035490224536 "$node_(763) setdest 49803 37828 12.0" 
$ns at 802.2667009740402 "$node_(763) setdest 71003 25089 7.0" 
$ns at 898.6768800594012 "$node_(763) setdest 17680 3411 5.0" 
$ns at 741.8870933795262 "$node_(764) setdest 81414 40682 19.0" 
$ns at 758.8843582833449 "$node_(765) setdest 1006 27602 8.0" 
$ns at 829.5208342549223 "$node_(765) setdest 105659 38818 19.0" 
$ns at 880.6212523114525 "$node_(765) setdest 39321 2381 5.0" 
$ns at 700.8666823175671 "$node_(766) setdest 66711 38750 7.0" 
$ns at 763.0545650841418 "$node_(766) setdest 71791 13812 15.0" 
$ns at 848.8900719353213 "$node_(766) setdest 31068 17935 6.0" 
$ns at 783.179249328177 "$node_(767) setdest 8410 26664 18.0" 
$ns at 845.8063203598033 "$node_(767) setdest 44682 10807 9.0" 
$ns at 892.6561763884953 "$node_(767) setdest 103789 44685 11.0" 
$ns at 729.6832020477865 "$node_(768) setdest 114493 36263 15.0" 
$ns at 761.5528824265061 "$node_(768) setdest 44797 29539 16.0" 
$ns at 806.1529696941915 "$node_(768) setdest 52003 26014 12.0" 
$ns at 855.7132746187988 "$node_(768) setdest 51705 24705 15.0" 
$ns at 724.5244575367791 "$node_(769) setdest 38546 12720 6.0" 
$ns at 801.1172339503271 "$node_(769) setdest 89690 10259 3.0" 
$ns at 832.665662923645 "$node_(769) setdest 88503 36327 13.0" 
$ns at 863.0748353169097 "$node_(769) setdest 26253 27313 19.0" 
$ns at 726.4602864084351 "$node_(770) setdest 21922 12597 7.0" 
$ns at 794.0667255816301 "$node_(770) setdest 38694 38692 16.0" 
$ns at 737.0996376850003 "$node_(771) setdest 127547 15818 11.0" 
$ns at 827.2286153166307 "$node_(771) setdest 29635 1286 17.0" 
$ns at 895.5482861612288 "$node_(771) setdest 34291 33456 6.0" 
$ns at 700.3803204226094 "$node_(772) setdest 33113 23337 14.0" 
$ns at 848.187536913771 "$node_(772) setdest 131573 31484 5.0" 
$ns at 727.4845248745783 "$node_(773) setdest 131928 6120 17.0" 
$ns at 834.7190824833909 "$node_(774) setdest 40340 22834 9.0" 
$ns at 871.4339182982429 "$node_(774) setdest 56120 32053 2.0" 
$ns at 715.6158412327043 "$node_(775) setdest 4376 4427 15.0" 
$ns at 778.8776958907199 "$node_(775) setdest 18980 38151 3.0" 
$ns at 814.2953137881102 "$node_(775) setdest 66867 15311 13.0" 
$ns at 728.248728040606 "$node_(776) setdest 2917 25990 13.0" 
$ns at 884.4029507098736 "$node_(776) setdest 17881 25882 1.0" 
$ns at 813.8041831582501 "$node_(777) setdest 89464 7418 7.0" 
$ns at 864.642478406129 "$node_(777) setdest 6981 32538 15.0" 
$ns at 720.7865528471522 "$node_(778) setdest 83621 22269 7.0" 
$ns at 798.3369023626665 "$node_(778) setdest 116223 26244 7.0" 
$ns at 887.1084301484852 "$node_(778) setdest 99225 9419 19.0" 
$ns at 750.9929087187946 "$node_(779) setdest 115561 507 8.0" 
$ns at 842.8679485773256 "$node_(779) setdest 54638 39600 8.0" 
$ns at 880.5244766373795 "$node_(779) setdest 81821 13542 1.0" 
$ns at 707.5652102078753 "$node_(780) setdest 70486 1009 15.0" 
$ns at 840.8480440086498 "$node_(780) setdest 41042 39900 7.0" 
$ns at 736.5550265828325 "$node_(781) setdest 28024 30630 1.0" 
$ns at 774.7816189936807 "$node_(781) setdest 125486 34013 11.0" 
$ns at 832.3349148119532 "$node_(781) setdest 36798 36537 13.0" 
$ns at 801.6681702178105 "$node_(782) setdest 114658 43833 19.0" 
$ns at 854.0993351451743 "$node_(782) setdest 1625 17863 12.0" 
$ns at 741.3243225722589 "$node_(783) setdest 14688 10142 1.0" 
$ns at 776.8987049699176 "$node_(783) setdest 116574 38487 6.0" 
$ns at 808.4460741938782 "$node_(783) setdest 103321 3404 5.0" 
$ns at 857.5314001421033 "$node_(783) setdest 122522 35649 20.0" 
$ns at 885.1052777651277 "$node_(784) setdest 82820 2866 13.0" 
$ns at 734.8040345844162 "$node_(785) setdest 42207 12741 20.0" 
$ns at 885.8274628241754 "$node_(785) setdest 54280 17688 14.0" 
$ns at 731.6335319896444 "$node_(786) setdest 56330 31028 10.0" 
$ns at 858.0852173718321 "$node_(786) setdest 52147 32741 8.0" 
$ns at 797.1434373724837 "$node_(787) setdest 62354 26946 6.0" 
$ns at 849.1418803381617 "$node_(787) setdest 85750 25088 12.0" 
$ns at 773.6937527646477 "$node_(788) setdest 35460 18061 15.0" 
$ns at 761.9901434263944 "$node_(789) setdest 68436 11999 8.0" 
$ns at 837.6295542379502 "$node_(789) setdest 43139 42829 10.0" 
$ns at 718.114030619194 "$node_(790) setdest 28282 27852 16.0" 
$ns at 888.4840765402125 "$node_(790) setdest 53748 5697 12.0" 
$ns at 728.2851321940408 "$node_(791) setdest 109607 34469 5.0" 
$ns at 771.6298631482133 "$node_(791) setdest 61277 43560 5.0" 
$ns at 807.8603912704399 "$node_(791) setdest 90641 19976 2.0" 
$ns at 839.3526053467414 "$node_(791) setdest 119215 26451 18.0" 
$ns at 700.6719183737932 "$node_(792) setdest 109644 4659 13.0" 
$ns at 764.3920778523773 "$node_(792) setdest 90145 13960 1.0" 
$ns at 795.5832337829368 "$node_(792) setdest 41983 20727 15.0" 
$ns at 861.0996108947628 "$node_(792) setdest 73674 17879 9.0" 
$ns at 781.3304093515003 "$node_(793) setdest 73351 35968 1.0" 
$ns at 817.0492695324438 "$node_(793) setdest 108998 22528 15.0" 
$ns at 883.4939637985761 "$node_(793) setdest 66220 13287 16.0" 
$ns at 769.6727353556582 "$node_(794) setdest 78496 865 9.0" 
$ns at 879.0571341456267 "$node_(794) setdest 54162 13290 16.0" 
$ns at 772.3324070484471 "$node_(795) setdest 15329 1037 14.0" 
$ns at 726.0736744981479 "$node_(796) setdest 133723 7447 4.0" 
$ns at 776.5824739055469 "$node_(796) setdest 125694 27185 17.0" 
$ns at 857.9384106452496 "$node_(796) setdest 93600 6075 7.0" 
$ns at 894.301231639929 "$node_(796) setdest 80360 18846 16.0" 
$ns at 702.9845732483941 "$node_(797) setdest 37601 11927 20.0" 
$ns at 831.344918259198 "$node_(797) setdest 91318 25298 5.0" 
$ns at 874.5574186383376 "$node_(797) setdest 83458 24871 1.0" 
$ns at 741.0930913248615 "$node_(798) setdest 74978 18490 6.0" 
$ns at 823.782800673495 "$node_(798) setdest 123990 1296 17.0" 
$ns at 706.1058799488459 "$node_(799) setdest 27709 19474 17.0" 
$ns at 787.5159095560434 "$node_(799) setdest 91693 19281 2.0" 
$ns at 836.597994522643 "$node_(799) setdest 107783 36230 18.0" 


#Set a TCP connection between node_(15) and node_(25)
set tcp_(0) [new Agent/TCP/Newreno]
$tcp_(0) set class_ 2
set sink_(0) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(0)
$ns attach-agent $node_(25) $sink_(0)
$ns connect $tcp_(0) $sink_(0)
set ftp_(0) [new Application/FTP]
$ftp_(0) attach-agent $tcp_(0)
$ns at 0.2 "$ftp_(0) start"
$ns at 180.0 "$ftp_(0) stop"

#Set a TCP connection between node_(94) and node_(42)
set tcp_(1) [new Agent/TCP/Newreno]
$tcp_(1) set class_ 2
set sink_(1) [new Agent/TCPSink]
$ns attach-agent $node_(94) $tcp_(1)
$ns attach-agent $node_(42) $sink_(1)
$ns connect $tcp_(1) $sink_(1)
set ftp_(1) [new Application/FTP]
$ftp_(1) attach-agent $tcp_(1)
$ns at 180.2 "$ftp_(1) start"
$ns at 360.0 "$ftp_(1) stop"

#Set a TCP connection between node_(59) and node_(82)
set tcp_(2) [new Agent/TCP/Newreno]
$tcp_(2) set class_ 2
set sink_(2) [new Agent/TCPSink]
$ns attach-agent $node_(59) $tcp_(2)
$ns attach-agent $node_(82) $sink_(2)
$ns connect $tcp_(2) $sink_(2)
set ftp_(2) [new Application/FTP]
$ftp_(2) attach-agent $tcp_(2)
$ns at 360.2 "$ftp_(2) start"
$ns at 540.0 "$ftp_(2) stop"

#Set a TCP connection between node_(70) and node_(0)
set tcp_(3) [new Agent/TCP/Newreno]
$tcp_(3) set class_ 2
set sink_(3) [new Agent/TCPSink]
$ns attach-agent $node_(70) $tcp_(3)
$ns attach-agent $node_(0) $sink_(3)
$ns connect $tcp_(3) $sink_(3)
set ftp_(3) [new Application/FTP]
$ftp_(3) attach-agent $tcp_(3)
$ns at 540.2 "$ftp_(3) start"
$ns at 720.0 "$ftp_(3) stop"

#Set a TCP connection between node_(5) and node_(28)
set tcp_(4) [new Agent/TCP/Newreno]
$tcp_(4) set class_ 2
set sink_(4) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(4)
$ns attach-agent $node_(28) $sink_(4)
$ns connect $tcp_(4) $sink_(4)
set ftp_(4) [new Application/FTP]
$ftp_(4) attach-agent $tcp_(4)
$ns at 720.2 "$ftp_(4) start"
$ns at 900.0 "$ftp_(4) stop"

#Set a TCP connection between node_(33) and node_(41)
set tcp_(5) [new Agent/TCP/Newreno]
$tcp_(5) set class_ 2
set sink_(5) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(5)
$ns attach-agent $node_(41) $sink_(5)
$ns connect $tcp_(5) $sink_(5)
set ftp_(5) [new Application/FTP]
$ftp_(5) attach-agent $tcp_(5)
$ns at 0.2 "$ftp_(5) start"
$ns at 180.0 "$ftp_(5) stop"

#Set a TCP connection between node_(12) and node_(87)
set tcp_(6) [new Agent/TCP/Newreno]
$tcp_(6) set class_ 2
set sink_(6) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(6)
$ns attach-agent $node_(87) $sink_(6)
$ns connect $tcp_(6) $sink_(6)
set ftp_(6) [new Application/FTP]
$ftp_(6) attach-agent $tcp_(6)
$ns at 180.2 "$ftp_(6) start"
$ns at 360.0 "$ftp_(6) stop"

#Set a TCP connection between node_(21) and node_(86)
set tcp_(7) [new Agent/TCP/Newreno]
$tcp_(7) set class_ 2
set sink_(7) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(7)
$ns attach-agent $node_(86) $sink_(7)
$ns connect $tcp_(7) $sink_(7)
set ftp_(7) [new Application/FTP]
$ftp_(7) attach-agent $tcp_(7)
$ns at 360.2 "$ftp_(7) start"
$ns at 540.0 "$ftp_(7) stop"

#Set a TCP connection between node_(72) and node_(10)
set tcp_(8) [new Agent/TCP/Newreno]
$tcp_(8) set class_ 2
set sink_(8) [new Agent/TCPSink]
$ns attach-agent $node_(72) $tcp_(8)
$ns attach-agent $node_(10) $sink_(8)
$ns connect $tcp_(8) $sink_(8)
set ftp_(8) [new Application/FTP]
$ftp_(8) attach-agent $tcp_(8)
$ns at 540.2 "$ftp_(8) start"
$ns at 720.0 "$ftp_(8) stop"

#Set a TCP connection between node_(63) and node_(61)
set tcp_(9) [new Agent/TCP/Newreno]
$tcp_(9) set class_ 2
set sink_(9) [new Agent/TCPSink]
$ns attach-agent $node_(63) $tcp_(9)
$ns attach-agent $node_(61) $sink_(9)
$ns connect $tcp_(9) $sink_(9)
set ftp_(9) [new Application/FTP]
$ftp_(9) attach-agent $tcp_(9)
$ns at 720.2 "$ftp_(9) start"
$ns at 900.0 "$ftp_(9) stop"

#Set a TCP connection between node_(21) and node_(11)
set tcp_(10) [new Agent/TCP/Newreno]
$tcp_(10) set class_ 2
set sink_(10) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(10)
$ns attach-agent $node_(11) $sink_(10)
$ns connect $tcp_(10) $sink_(10)
set ftp_(10) [new Application/FTP]
$ftp_(10) attach-agent $tcp_(10)
$ns at 0.2 "$ftp_(10) start"
$ns at 180.0 "$ftp_(10) stop"

#Set a TCP connection between node_(4) and node_(97)
set tcp_(11) [new Agent/TCP/Newreno]
$tcp_(11) set class_ 2
set sink_(11) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(11)
$ns attach-agent $node_(97) $sink_(11)
$ns connect $tcp_(11) $sink_(11)
set ftp_(11) [new Application/FTP]
$ftp_(11) attach-agent $tcp_(11)
$ns at 180.2 "$ftp_(11) start"
$ns at 360.0 "$ftp_(11) stop"

#Set a TCP connection between node_(43) and node_(7)
set tcp_(12) [new Agent/TCP/Newreno]
$tcp_(12) set class_ 2
set sink_(12) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(12)
$ns attach-agent $node_(7) $sink_(12)
$ns connect $tcp_(12) $sink_(12)
set ftp_(12) [new Application/FTP]
$ftp_(12) attach-agent $tcp_(12)
$ns at 360.2 "$ftp_(12) start"
$ns at 540.0 "$ftp_(12) stop"

#Set a TCP connection between node_(79) and node_(0)
set tcp_(13) [new Agent/TCP/Newreno]
$tcp_(13) set class_ 2
set sink_(13) [new Agent/TCPSink]
$ns attach-agent $node_(79) $tcp_(13)
$ns attach-agent $node_(0) $sink_(13)
$ns connect $tcp_(13) $sink_(13)
set ftp_(13) [new Application/FTP]
$ftp_(13) attach-agent $tcp_(13)
$ns at 540.2 "$ftp_(13) start"
$ns at 720.0 "$ftp_(13) stop"

#Set a TCP connection between node_(90) and node_(10)
set tcp_(14) [new Agent/TCP/Newreno]
$tcp_(14) set class_ 2
set sink_(14) [new Agent/TCPSink]
$ns attach-agent $node_(90) $tcp_(14)
$ns attach-agent $node_(10) $sink_(14)
$ns connect $tcp_(14) $sink_(14)
set ftp_(14) [new Application/FTP]
$ftp_(14) attach-agent $tcp_(14)
$ns at 720.2 "$ftp_(14) start"
$ns at 900.0 "$ftp_(14) stop"

#Set a TCP connection between node_(44) and node_(80)
set tcp_(15) [new Agent/TCP/Newreno]
$tcp_(15) set class_ 2
set sink_(15) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(15)
$ns attach-agent $node_(80) $sink_(15)
$ns connect $tcp_(15) $sink_(15)
set ftp_(15) [new Application/FTP]
$ftp_(15) attach-agent $tcp_(15)
$ns at 0.2 "$ftp_(15) start"
$ns at 180.0 "$ftp_(15) stop"

#Set a TCP connection between node_(29) and node_(43)
set tcp_(16) [new Agent/TCP/Newreno]
$tcp_(16) set class_ 2
set sink_(16) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(16)
$ns attach-agent $node_(43) $sink_(16)
$ns connect $tcp_(16) $sink_(16)
set ftp_(16) [new Application/FTP]
$ftp_(16) attach-agent $tcp_(16)
$ns at 180.2 "$ftp_(16) start"
$ns at 360.0 "$ftp_(16) stop"

#Set a TCP connection between node_(5) and node_(72)
set tcp_(17) [new Agent/TCP/Newreno]
$tcp_(17) set class_ 2
set sink_(17) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(17)
$ns attach-agent $node_(72) $sink_(17)
$ns connect $tcp_(17) $sink_(17)
set ftp_(17) [new Application/FTP]
$ftp_(17) attach-agent $tcp_(17)
$ns at 360.2 "$ftp_(17) start"
$ns at 540.0 "$ftp_(17) stop"

#Set a TCP connection between node_(64) and node_(92)
set tcp_(18) [new Agent/TCP/Newreno]
$tcp_(18) set class_ 2
set sink_(18) [new Agent/TCPSink]
$ns attach-agent $node_(64) $tcp_(18)
$ns attach-agent $node_(92) $sink_(18)
$ns connect $tcp_(18) $sink_(18)
set ftp_(18) [new Application/FTP]
$ftp_(18) attach-agent $tcp_(18)
$ns at 540.2 "$ftp_(18) start"
$ns at 720.0 "$ftp_(18) stop"

#Set a TCP connection between node_(68) and node_(64)
set tcp_(19) [new Agent/TCP/Newreno]
$tcp_(19) set class_ 2
set sink_(19) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(19)
$ns attach-agent $node_(64) $sink_(19)
$ns connect $tcp_(19) $sink_(19)
set ftp_(19) [new Application/FTP]
$ftp_(19) attach-agent $tcp_(19)
$ns at 720.2 "$ftp_(19) start"
$ns at 900.0 "$ftp_(19) stop"

#Set a TCP connection between node_(16) and node_(61)
set tcp_(20) [new Agent/TCP/Newreno]
$tcp_(20) set class_ 2
set sink_(20) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(20)
$ns attach-agent $node_(61) $sink_(20)
$ns connect $tcp_(20) $sink_(20)
set ftp_(20) [new Application/FTP]
$ftp_(20) attach-agent $tcp_(20)
$ns at 0.2 "$ftp_(20) start"
$ns at 180.0 "$ftp_(20) stop"

#Set a TCP connection between node_(43) and node_(8)
set tcp_(21) [new Agent/TCP/Newreno]
$tcp_(21) set class_ 2
set sink_(21) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(21)
$ns attach-agent $node_(8) $sink_(21)
$ns connect $tcp_(21) $sink_(21)
set ftp_(21) [new Application/FTP]
$ftp_(21) attach-agent $tcp_(21)
$ns at 180.2 "$ftp_(21) start"
$ns at 360.0 "$ftp_(21) stop"

#Set a TCP connection between node_(71) and node_(45)
set tcp_(22) [new Agent/TCP/Newreno]
$tcp_(22) set class_ 2
set sink_(22) [new Agent/TCPSink]
$ns attach-agent $node_(71) $tcp_(22)
$ns attach-agent $node_(45) $sink_(22)
$ns connect $tcp_(22) $sink_(22)
set ftp_(22) [new Application/FTP]
$ftp_(22) attach-agent $tcp_(22)
$ns at 360.2 "$ftp_(22) start"
$ns at 540.0 "$ftp_(22) stop"

#Set a TCP connection between node_(17) and node_(39)
set tcp_(23) [new Agent/TCP/Newreno]
$tcp_(23) set class_ 2
set sink_(23) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(23)
$ns attach-agent $node_(39) $sink_(23)
$ns connect $tcp_(23) $sink_(23)
set ftp_(23) [new Application/FTP]
$ftp_(23) attach-agent $tcp_(23)
$ns at 540.2 "$ftp_(23) start"
$ns at 720.0 "$ftp_(23) stop"

#Set a TCP connection between node_(4) and node_(82)
set tcp_(24) [new Agent/TCP/Newreno]
$tcp_(24) set class_ 2
set sink_(24) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(24)
$ns attach-agent $node_(82) $sink_(24)
$ns connect $tcp_(24) $sink_(24)
set ftp_(24) [new Application/FTP]
$ftp_(24) attach-agent $tcp_(24)
$ns at 720.2 "$ftp_(24) start"
$ns at 900.0 "$ftp_(24) stop"

#Set a TCP connection between node_(5) and node_(76)
set tcp_(25) [new Agent/TCP/Newreno]
$tcp_(25) set class_ 2
set sink_(25) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(25)
$ns attach-agent $node_(76) $sink_(25)
$ns connect $tcp_(25) $sink_(25)
set ftp_(25) [new Application/FTP]
$ftp_(25) attach-agent $tcp_(25)
$ns at 0.2 "$ftp_(25) start"
$ns at 180.0 "$ftp_(25) stop"

#Set a TCP connection between node_(34) and node_(42)
set tcp_(26) [new Agent/TCP/Newreno]
$tcp_(26) set class_ 2
set sink_(26) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(26)
$ns attach-agent $node_(42) $sink_(26)
$ns connect $tcp_(26) $sink_(26)
set ftp_(26) [new Application/FTP]
$ftp_(26) attach-agent $tcp_(26)
$ns at 180.2 "$ftp_(26) start"
$ns at 360.0 "$ftp_(26) stop"

#Set a TCP connection between node_(7) and node_(9)
set tcp_(27) [new Agent/TCP/Newreno]
$tcp_(27) set class_ 2
set sink_(27) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(27)
$ns attach-agent $node_(9) $sink_(27)
$ns connect $tcp_(27) $sink_(27)
set ftp_(27) [new Application/FTP]
$ftp_(27) attach-agent $tcp_(27)
$ns at 360.2 "$ftp_(27) start"
$ns at 540.0 "$ftp_(27) stop"

#Set a TCP connection between node_(96) and node_(53)
set tcp_(28) [new Agent/TCP/Newreno]
$tcp_(28) set class_ 2
set sink_(28) [new Agent/TCPSink]
$ns attach-agent $node_(96) $tcp_(28)
$ns attach-agent $node_(53) $sink_(28)
$ns connect $tcp_(28) $sink_(28)
set ftp_(28) [new Application/FTP]
$ftp_(28) attach-agent $tcp_(28)
$ns at 540.2 "$ftp_(28) start"
$ns at 720.0 "$ftp_(28) stop"

#Set a TCP connection between node_(31) and node_(73)
set tcp_(29) [new Agent/TCP/Newreno]
$tcp_(29) set class_ 2
set sink_(29) [new Agent/TCPSink]
$ns attach-agent $node_(31) $tcp_(29)
$ns attach-agent $node_(73) $sink_(29)
$ns connect $tcp_(29) $sink_(29)
set ftp_(29) [new Application/FTP]
$ftp_(29) attach-agent $tcp_(29)
$ns at 720.2 "$ftp_(29) start"
$ns at 900.0 "$ftp_(29) stop"

#Set a TCP connection between node_(97) and node_(67)
set tcp_(30) [new Agent/TCP/Newreno]
$tcp_(30) set class_ 2
set sink_(30) [new Agent/TCPSink]
$ns attach-agent $node_(97) $tcp_(30)
$ns attach-agent $node_(67) $sink_(30)
$ns connect $tcp_(30) $sink_(30)
set ftp_(30) [new Application/FTP]
$ftp_(30) attach-agent $tcp_(30)
$ns at 0.2 "$ftp_(30) start"
$ns at 180.0 "$ftp_(30) stop"

#Set a TCP connection between node_(37) and node_(13)
set tcp_(31) [new Agent/TCP/Newreno]
$tcp_(31) set class_ 2
set sink_(31) [new Agent/TCPSink]
$ns attach-agent $node_(37) $tcp_(31)
$ns attach-agent $node_(13) $sink_(31)
$ns connect $tcp_(31) $sink_(31)
set ftp_(31) [new Application/FTP]
$ftp_(31) attach-agent $tcp_(31)
$ns at 180.2 "$ftp_(31) start"
$ns at 360.0 "$ftp_(31) stop"

#Set a TCP connection between node_(68) and node_(49)
set tcp_(32) [new Agent/TCP/Newreno]
$tcp_(32) set class_ 2
set sink_(32) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(32)
$ns attach-agent $node_(49) $sink_(32)
$ns connect $tcp_(32) $sink_(32)
set ftp_(32) [new Application/FTP]
$ftp_(32) attach-agent $tcp_(32)
$ns at 360.2 "$ftp_(32) start"
$ns at 540.0 "$ftp_(32) stop"

#Set a TCP connection between node_(72) and node_(99)
set tcp_(33) [new Agent/TCP/Newreno]
$tcp_(33) set class_ 2
set sink_(33) [new Agent/TCPSink]
$ns attach-agent $node_(72) $tcp_(33)
$ns attach-agent $node_(99) $sink_(33)
$ns connect $tcp_(33) $sink_(33)
set ftp_(33) [new Application/FTP]
$ftp_(33) attach-agent $tcp_(33)
$ns at 540.2 "$ftp_(33) start"
$ns at 720.0 "$ftp_(33) stop"

#Set a TCP connection between node_(66) and node_(79)
set tcp_(34) [new Agent/TCP/Newreno]
$tcp_(34) set class_ 2
set sink_(34) [new Agent/TCPSink]
$ns attach-agent $node_(66) $tcp_(34)
$ns attach-agent $node_(79) $sink_(34)
$ns connect $tcp_(34) $sink_(34)
set ftp_(34) [new Application/FTP]
$ftp_(34) attach-agent $tcp_(34)
$ns at 720.2 "$ftp_(34) start"
$ns at 900.0 "$ftp_(34) stop"

#Set a TCP connection between node_(34) and node_(27)
set tcp_(35) [new Agent/TCP/Newreno]
$tcp_(35) set class_ 2
set sink_(35) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(35)
$ns attach-agent $node_(27) $sink_(35)
$ns connect $tcp_(35) $sink_(35)
set ftp_(35) [new Application/FTP]
$ftp_(35) attach-agent $tcp_(35)
$ns at 0.2 "$ftp_(35) start"
$ns at 180.0 "$ftp_(35) stop"

#Set a TCP connection between node_(43) and node_(36)
set tcp_(36) [new Agent/TCP/Newreno]
$tcp_(36) set class_ 2
set sink_(36) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(36)
$ns attach-agent $node_(36) $sink_(36)
$ns connect $tcp_(36) $sink_(36)
set ftp_(36) [new Application/FTP]
$ftp_(36) attach-agent $tcp_(36)
$ns at 180.2 "$ftp_(36) start"
$ns at 360.0 "$ftp_(36) stop"

#Set a TCP connection between node_(97) and node_(45)
set tcp_(37) [new Agent/TCP/Newreno]
$tcp_(37) set class_ 2
set sink_(37) [new Agent/TCPSink]
$ns attach-agent $node_(97) $tcp_(37)
$ns attach-agent $node_(45) $sink_(37)
$ns connect $tcp_(37) $sink_(37)
set ftp_(37) [new Application/FTP]
$ftp_(37) attach-agent $tcp_(37)
$ns at 360.2 "$ftp_(37) start"
$ns at 540.0 "$ftp_(37) stop"

#Set a TCP connection between node_(46) and node_(75)
set tcp_(38) [new Agent/TCP/Newreno]
$tcp_(38) set class_ 2
set sink_(38) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(38)
$ns attach-agent $node_(75) $sink_(38)
$ns connect $tcp_(38) $sink_(38)
set ftp_(38) [new Application/FTP]
$ftp_(38) attach-agent $tcp_(38)
$ns at 540.2 "$ftp_(38) start"
$ns at 720.0 "$ftp_(38) stop"

#Set a TCP connection between node_(95) and node_(92)
set tcp_(39) [new Agent/TCP/Newreno]
$tcp_(39) set class_ 2
set sink_(39) [new Agent/TCPSink]
$ns attach-agent $node_(95) $tcp_(39)
$ns attach-agent $node_(92) $sink_(39)
$ns connect $tcp_(39) $sink_(39)
set ftp_(39) [new Application/FTP]
$ftp_(39) attach-agent $tcp_(39)
$ns at 720.2 "$ftp_(39) start"
$ns at 900.0 "$ftp_(39) stop"

#Set a TCP connection between node_(61) and node_(15)
set tcp_(40) [new Agent/TCP/Newreno]
$tcp_(40) set class_ 2
set sink_(40) [new Agent/TCPSink]
$ns attach-agent $node_(61) $tcp_(40)
$ns attach-agent $node_(15) $sink_(40)
$ns connect $tcp_(40) $sink_(40)
set ftp_(40) [new Application/FTP]
$ftp_(40) attach-agent $tcp_(40)
$ns at 0.2 "$ftp_(40) start"
$ns at 180.0 "$ftp_(40) stop"

#Set a TCP connection between node_(30) and node_(58)
set tcp_(41) [new Agent/TCP/Newreno]
$tcp_(41) set class_ 2
set sink_(41) [new Agent/TCPSink]
$ns attach-agent $node_(30) $tcp_(41)
$ns attach-agent $node_(58) $sink_(41)
$ns connect $tcp_(41) $sink_(41)
set ftp_(41) [new Application/FTP]
$ftp_(41) attach-agent $tcp_(41)
$ns at 180.2 "$ftp_(41) start"
$ns at 360.0 "$ftp_(41) stop"

#Set a TCP connection between node_(38) and node_(49)
set tcp_(42) [new Agent/TCP/Newreno]
$tcp_(42) set class_ 2
set sink_(42) [new Agent/TCPSink]
$ns attach-agent $node_(38) $tcp_(42)
$ns attach-agent $node_(49) $sink_(42)
$ns connect $tcp_(42) $sink_(42)
set ftp_(42) [new Application/FTP]
$ftp_(42) attach-agent $tcp_(42)
$ns at 360.2 "$ftp_(42) start"
$ns at 540.0 "$ftp_(42) stop"

#Set a TCP connection between node_(85) and node_(37)
set tcp_(43) [new Agent/TCP/Newreno]
$tcp_(43) set class_ 2
set sink_(43) [new Agent/TCPSink]
$ns attach-agent $node_(85) $tcp_(43)
$ns attach-agent $node_(37) $sink_(43)
$ns connect $tcp_(43) $sink_(43)
set ftp_(43) [new Application/FTP]
$ftp_(43) attach-agent $tcp_(43)
$ns at 540.2 "$ftp_(43) start"
$ns at 720.0 "$ftp_(43) stop"

#Set a TCP connection between node_(41) and node_(92)
set tcp_(44) [new Agent/TCP/Newreno]
$tcp_(44) set class_ 2
set sink_(44) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(44)
$ns attach-agent $node_(92) $sink_(44)
$ns connect $tcp_(44) $sink_(44)
set ftp_(44) [new Application/FTP]
$ftp_(44) attach-agent $tcp_(44)
$ns at 720.2 "$ftp_(44) start"
$ns at 900.0 "$ftp_(44) stop"

#Set a TCP connection between node_(53) and node_(39)
set tcp_(45) [new Agent/TCP/Newreno]
$tcp_(45) set class_ 2
set sink_(45) [new Agent/TCPSink]
$ns attach-agent $node_(53) $tcp_(45)
$ns attach-agent $node_(39) $sink_(45)
$ns connect $tcp_(45) $sink_(45)
set ftp_(45) [new Application/FTP]
$ftp_(45) attach-agent $tcp_(45)
$ns at 0.2 "$ftp_(45) start"
$ns at 180.0 "$ftp_(45) stop"

#Set a TCP connection between node_(35) and node_(49)
set tcp_(46) [new Agent/TCP/Newreno]
$tcp_(46) set class_ 2
set sink_(46) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(46)
$ns attach-agent $node_(49) $sink_(46)
$ns connect $tcp_(46) $sink_(46)
set ftp_(46) [new Application/FTP]
$ftp_(46) attach-agent $tcp_(46)
$ns at 180.2 "$ftp_(46) start"
$ns at 360.0 "$ftp_(46) stop"

#Set a TCP connection between node_(75) and node_(82)
set tcp_(47) [new Agent/TCP/Newreno]
$tcp_(47) set class_ 2
set sink_(47) [new Agent/TCPSink]
$ns attach-agent $node_(75) $tcp_(47)
$ns attach-agent $node_(82) $sink_(47)
$ns connect $tcp_(47) $sink_(47)
set ftp_(47) [new Application/FTP]
$ftp_(47) attach-agent $tcp_(47)
$ns at 360.2 "$ftp_(47) start"
$ns at 540.0 "$ftp_(47) stop"

#Set a TCP connection between node_(28) and node_(60)
set tcp_(48) [new Agent/TCP/Newreno]
$tcp_(48) set class_ 2
set sink_(48) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(48)
$ns attach-agent $node_(60) $sink_(48)
$ns connect $tcp_(48) $sink_(48)
set ftp_(48) [new Application/FTP]
$ftp_(48) attach-agent $tcp_(48)
$ns at 540.2 "$ftp_(48) start"
$ns at 720.0 "$ftp_(48) stop"

#Set a TCP connection between node_(13) and node_(16)
set tcp_(49) [new Agent/TCP/Newreno]
$tcp_(49) set class_ 2
set sink_(49) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(49)
$ns attach-agent $node_(16) $sink_(49)
$ns connect $tcp_(49) $sink_(49)
set ftp_(49) [new Application/FTP]
$ftp_(49) attach-agent $tcp_(49)
$ns at 720.2 "$ftp_(49) start"
$ns at 900.0 "$ftp_(49) stop"

#Set a TCP connection between node_(3) and node_(69)
set tcp_(50) [new Agent/TCP/Newreno]
$tcp_(50) set class_ 2
set sink_(50) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(50)
$ns attach-agent $node_(69) $sink_(50)
$ns connect $tcp_(50) $sink_(50)
set ftp_(50) [new Application/FTP]
$ftp_(50) attach-agent $tcp_(50)
$ns at 0.2 "$ftp_(50) start"
$ns at 180.0 "$ftp_(50) stop"

#Set a TCP connection between node_(39) and node_(54)
set tcp_(51) [new Agent/TCP/Newreno]
$tcp_(51) set class_ 2
set sink_(51) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(51)
$ns attach-agent $node_(54) $sink_(51)
$ns connect $tcp_(51) $sink_(51)
set ftp_(51) [new Application/FTP]
$ftp_(51) attach-agent $tcp_(51)
$ns at 180.2 "$ftp_(51) start"
$ns at 360.0 "$ftp_(51) stop"

#Set a TCP connection between node_(11) and node_(67)
set tcp_(52) [new Agent/TCP/Newreno]
$tcp_(52) set class_ 2
set sink_(52) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(52)
$ns attach-agent $node_(67) $sink_(52)
$ns connect $tcp_(52) $sink_(52)
set ftp_(52) [new Application/FTP]
$ftp_(52) attach-agent $tcp_(52)
$ns at 360.2 "$ftp_(52) start"
$ns at 540.0 "$ftp_(52) stop"

#Set a TCP connection between node_(19) and node_(79)
set tcp_(53) [new Agent/TCP/Newreno]
$tcp_(53) set class_ 2
set sink_(53) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(53)
$ns attach-agent $node_(79) $sink_(53)
$ns connect $tcp_(53) $sink_(53)
set ftp_(53) [new Application/FTP]
$ftp_(53) attach-agent $tcp_(53)
$ns at 540.2 "$ftp_(53) start"
$ns at 720.0 "$ftp_(53) stop"

#Set a TCP connection between node_(56) and node_(48)
set tcp_(54) [new Agent/TCP/Newreno]
$tcp_(54) set class_ 2
set sink_(54) [new Agent/TCPSink]
$ns attach-agent $node_(56) $tcp_(54)
$ns attach-agent $node_(48) $sink_(54)
$ns connect $tcp_(54) $sink_(54)
set ftp_(54) [new Application/FTP]
$ftp_(54) attach-agent $tcp_(54)
$ns at 720.2 "$ftp_(54) start"
$ns at 900.0 "$ftp_(54) stop"

#Set a TCP connection between node_(52) and node_(42)
set tcp_(55) [new Agent/TCP/Newreno]
$tcp_(55) set class_ 2
set sink_(55) [new Agent/TCPSink]
$ns attach-agent $node_(52) $tcp_(55)
$ns attach-agent $node_(42) $sink_(55)
$ns connect $tcp_(55) $sink_(55)
set ftp_(55) [new Application/FTP]
$ftp_(55) attach-agent $tcp_(55)
$ns at 0.2 "$ftp_(55) start"
$ns at 180.0 "$ftp_(55) stop"

#Set a TCP connection between node_(45) and node_(31)
set tcp_(56) [new Agent/TCP/Newreno]
$tcp_(56) set class_ 2
set sink_(56) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(56)
$ns attach-agent $node_(31) $sink_(56)
$ns connect $tcp_(56) $sink_(56)
set ftp_(56) [new Application/FTP]
$ftp_(56) attach-agent $tcp_(56)
$ns at 180.2 "$ftp_(56) start"
$ns at 360.0 "$ftp_(56) stop"

#Set a TCP connection between node_(32) and node_(78)
set tcp_(57) [new Agent/TCP/Newreno]
$tcp_(57) set class_ 2
set sink_(57) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(57)
$ns attach-agent $node_(78) $sink_(57)
$ns connect $tcp_(57) $sink_(57)
set ftp_(57) [new Application/FTP]
$ftp_(57) attach-agent $tcp_(57)
$ns at 360.2 "$ftp_(57) start"
$ns at 540.0 "$ftp_(57) stop"

#Set a TCP connection between node_(72) and node_(40)
set tcp_(58) [new Agent/TCP/Newreno]
$tcp_(58) set class_ 2
set sink_(58) [new Agent/TCPSink]
$ns attach-agent $node_(72) $tcp_(58)
$ns attach-agent $node_(40) $sink_(58)
$ns connect $tcp_(58) $sink_(58)
set ftp_(58) [new Application/FTP]
$ftp_(58) attach-agent $tcp_(58)
$ns at 540.2 "$ftp_(58) start"
$ns at 720.0 "$ftp_(58) stop"

#Set a TCP connection between node_(50) and node_(69)
set tcp_(59) [new Agent/TCP/Newreno]
$tcp_(59) set class_ 2
set sink_(59) [new Agent/TCPSink]
$ns attach-agent $node_(50) $tcp_(59)
$ns attach-agent $node_(69) $sink_(59)
$ns connect $tcp_(59) $sink_(59)
set ftp_(59) [new Application/FTP]
$ftp_(59) attach-agent $tcp_(59)
$ns at 720.2 "$ftp_(59) start"
$ns at 900.0 "$ftp_(59) stop"

#Set a TCP connection between node_(9) and node_(16)
set tcp_(60) [new Agent/TCP/Newreno]
$tcp_(60) set class_ 2
set sink_(60) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(60)
$ns attach-agent $node_(16) $sink_(60)
$ns connect $tcp_(60) $sink_(60)
set ftp_(60) [new Application/FTP]
$ftp_(60) attach-agent $tcp_(60)
$ns at 0.2 "$ftp_(60) start"
$ns at 180.0 "$ftp_(60) stop"

#Set a TCP connection between node_(63) and node_(13)
set tcp_(61) [new Agent/TCP/Newreno]
$tcp_(61) set class_ 2
set sink_(61) [new Agent/TCPSink]
$ns attach-agent $node_(63) $tcp_(61)
$ns attach-agent $node_(13) $sink_(61)
$ns connect $tcp_(61) $sink_(61)
set ftp_(61) [new Application/FTP]
$ftp_(61) attach-agent $tcp_(61)
$ns at 180.2 "$ftp_(61) start"
$ns at 360.0 "$ftp_(61) stop"

#Set a TCP connection between node_(72) and node_(0)
set tcp_(62) [new Agent/TCP/Newreno]
$tcp_(62) set class_ 2
set sink_(62) [new Agent/TCPSink]
$ns attach-agent $node_(72) $tcp_(62)
$ns attach-agent $node_(0) $sink_(62)
$ns connect $tcp_(62) $sink_(62)
set ftp_(62) [new Application/FTP]
$ftp_(62) attach-agent $tcp_(62)
$ns at 360.2 "$ftp_(62) start"
$ns at 540.0 "$ftp_(62) stop"

#Set a TCP connection between node_(40) and node_(69)
set tcp_(63) [new Agent/TCP/Newreno]
$tcp_(63) set class_ 2
set sink_(63) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(63)
$ns attach-agent $node_(69) $sink_(63)
$ns connect $tcp_(63) $sink_(63)
set ftp_(63) [new Application/FTP]
$ftp_(63) attach-agent $tcp_(63)
$ns at 540.2 "$ftp_(63) start"
$ns at 720.0 "$ftp_(63) stop"

#Set a TCP connection between node_(75) and node_(61)
set tcp_(64) [new Agent/TCP/Newreno]
$tcp_(64) set class_ 2
set sink_(64) [new Agent/TCPSink]
$ns attach-agent $node_(75) $tcp_(64)
$ns attach-agent $node_(61) $sink_(64)
$ns connect $tcp_(64) $sink_(64)
set ftp_(64) [new Application/FTP]
$ftp_(64) attach-agent $tcp_(64)
$ns at 720.2 "$ftp_(64) start"
$ns at 900.0 "$ftp_(64) stop"

#Set a TCP connection between node_(52) and node_(77)
set tcp_(65) [new Agent/TCP/Newreno]
$tcp_(65) set class_ 2
set sink_(65) [new Agent/TCPSink]
$ns attach-agent $node_(52) $tcp_(65)
$ns attach-agent $node_(77) $sink_(65)
$ns connect $tcp_(65) $sink_(65)
set ftp_(65) [new Application/FTP]
$ftp_(65) attach-agent $tcp_(65)
$ns at 0.2 "$ftp_(65) start"
$ns at 180.0 "$ftp_(65) stop"

#Set a TCP connection between node_(95) and node_(82)
set tcp_(66) [new Agent/TCP/Newreno]
$tcp_(66) set class_ 2
set sink_(66) [new Agent/TCPSink]
$ns attach-agent $node_(95) $tcp_(66)
$ns attach-agent $node_(82) $sink_(66)
$ns connect $tcp_(66) $sink_(66)
set ftp_(66) [new Application/FTP]
$ftp_(66) attach-agent $tcp_(66)
$ns at 180.2 "$ftp_(66) start"
$ns at 360.0 "$ftp_(66) stop"

#Set a TCP connection between node_(76) and node_(89)
set tcp_(67) [new Agent/TCP/Newreno]
$tcp_(67) set class_ 2
set sink_(67) [new Agent/TCPSink]
$ns attach-agent $node_(76) $tcp_(67)
$ns attach-agent $node_(89) $sink_(67)
$ns connect $tcp_(67) $sink_(67)
set ftp_(67) [new Application/FTP]
$ftp_(67) attach-agent $tcp_(67)
$ns at 360.2 "$ftp_(67) start"
$ns at 540.0 "$ftp_(67) stop"

#Set a TCP connection between node_(92) and node_(56)
set tcp_(68) [new Agent/TCP/Newreno]
$tcp_(68) set class_ 2
set sink_(68) [new Agent/TCPSink]
$ns attach-agent $node_(92) $tcp_(68)
$ns attach-agent $node_(56) $sink_(68)
$ns connect $tcp_(68) $sink_(68)
set ftp_(68) [new Application/FTP]
$ftp_(68) attach-agent $tcp_(68)
$ns at 540.2 "$ftp_(68) start"
$ns at 720.0 "$ftp_(68) stop"

#Set a TCP connection between node_(76) and node_(28)
set tcp_(69) [new Agent/TCP/Newreno]
$tcp_(69) set class_ 2
set sink_(69) [new Agent/TCPSink]
$ns attach-agent $node_(76) $tcp_(69)
$ns attach-agent $node_(28) $sink_(69)
$ns connect $tcp_(69) $sink_(69)
set ftp_(69) [new Application/FTP]
$ftp_(69) attach-agent $tcp_(69)
$ns at 720.2 "$ftp_(69) start"
$ns at 900.0 "$ftp_(69) stop"

#Set a TCP connection between node_(31) and node_(46)
set tcp_(70) [new Agent/TCP/Newreno]
$tcp_(70) set class_ 2
set sink_(70) [new Agent/TCPSink]
$ns attach-agent $node_(31) $tcp_(70)
$ns attach-agent $node_(46) $sink_(70)
$ns connect $tcp_(70) $sink_(70)
set ftp_(70) [new Application/FTP]
$ftp_(70) attach-agent $tcp_(70)
$ns at 0.2 "$ftp_(70) start"
$ns at 180.0 "$ftp_(70) stop"

#Set a TCP connection between node_(43) and node_(52)
set tcp_(71) [new Agent/TCP/Newreno]
$tcp_(71) set class_ 2
set sink_(71) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(71)
$ns attach-agent $node_(52) $sink_(71)
$ns connect $tcp_(71) $sink_(71)
set ftp_(71) [new Application/FTP]
$ftp_(71) attach-agent $tcp_(71)
$ns at 180.2 "$ftp_(71) start"
$ns at 360.0 "$ftp_(71) stop"

#Set a TCP connection between node_(96) and node_(93)
set tcp_(72) [new Agent/TCP/Newreno]
$tcp_(72) set class_ 2
set sink_(72) [new Agent/TCPSink]
$ns attach-agent $node_(96) $tcp_(72)
$ns attach-agent $node_(93) $sink_(72)
$ns connect $tcp_(72) $sink_(72)
set ftp_(72) [new Application/FTP]
$ftp_(72) attach-agent $tcp_(72)
$ns at 360.2 "$ftp_(72) start"
$ns at 540.0 "$ftp_(72) stop"

#Set a TCP connection between node_(24) and node_(92)
set tcp_(73) [new Agent/TCP/Newreno]
$tcp_(73) set class_ 2
set sink_(73) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(73)
$ns attach-agent $node_(92) $sink_(73)
$ns connect $tcp_(73) $sink_(73)
set ftp_(73) [new Application/FTP]
$ftp_(73) attach-agent $tcp_(73)
$ns at 540.2 "$ftp_(73) start"
$ns at 720.0 "$ftp_(73) stop"

#Set a TCP connection between node_(73) and node_(40)
set tcp_(74) [new Agent/TCP/Newreno]
$tcp_(74) set class_ 2
set sink_(74) [new Agent/TCPSink]
$ns attach-agent $node_(73) $tcp_(74)
$ns attach-agent $node_(40) $sink_(74)
$ns connect $tcp_(74) $sink_(74)
set ftp_(74) [new Application/FTP]
$ftp_(74) attach-agent $tcp_(74)
$ns at 720.2 "$ftp_(74) start"
$ns at 900.0 "$ftp_(74) stop"

#Set a TCP connection between node_(11) and node_(66)
set tcp_(75) [new Agent/TCP/Newreno]
$tcp_(75) set class_ 2
set sink_(75) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(75)
$ns attach-agent $node_(66) $sink_(75)
$ns connect $tcp_(75) $sink_(75)
set ftp_(75) [new Application/FTP]
$ftp_(75) attach-agent $tcp_(75)
$ns at 0.2 "$ftp_(75) start"
$ns at 180.0 "$ftp_(75) stop"

#Set a TCP connection between node_(87) and node_(35)
set tcp_(76) [new Agent/TCP/Newreno]
$tcp_(76) set class_ 2
set sink_(76) [new Agent/TCPSink]
$ns attach-agent $node_(87) $tcp_(76)
$ns attach-agent $node_(35) $sink_(76)
$ns connect $tcp_(76) $sink_(76)
set ftp_(76) [new Application/FTP]
$ftp_(76) attach-agent $tcp_(76)
$ns at 180.2 "$ftp_(76) start"
$ns at 360.0 "$ftp_(76) stop"

#Set a TCP connection between node_(28) and node_(40)
set tcp_(77) [new Agent/TCP/Newreno]
$tcp_(77) set class_ 2
set sink_(77) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(77)
$ns attach-agent $node_(40) $sink_(77)
$ns connect $tcp_(77) $sink_(77)
set ftp_(77) [new Application/FTP]
$ftp_(77) attach-agent $tcp_(77)
$ns at 360.2 "$ftp_(77) start"
$ns at 540.0 "$ftp_(77) stop"

#Set a TCP connection between node_(46) and node_(71)
set tcp_(78) [new Agent/TCP/Newreno]
$tcp_(78) set class_ 2
set sink_(78) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(78)
$ns attach-agent $node_(71) $sink_(78)
$ns connect $tcp_(78) $sink_(78)
set ftp_(78) [new Application/FTP]
$ftp_(78) attach-agent $tcp_(78)
$ns at 540.2 "$ftp_(78) start"
$ns at 720.0 "$ftp_(78) stop"

#Set a TCP connection between node_(46) and node_(45)
set tcp_(79) [new Agent/TCP/Newreno]
$tcp_(79) set class_ 2
set sink_(79) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(79)
$ns attach-agent $node_(45) $sink_(79)
$ns connect $tcp_(79) $sink_(79)
set ftp_(79) [new Application/FTP]
$ftp_(79) attach-agent $tcp_(79)
$ns at 720.2 "$ftp_(79) start"
$ns at 900.0 "$ftp_(79) stop"

#Set a TCP connection between node_(69) and node_(73)
set tcp_(80) [new Agent/TCP/Newreno]
$tcp_(80) set class_ 2
set sink_(80) [new Agent/TCPSink]
$ns attach-agent $node_(69) $tcp_(80)
$ns attach-agent $node_(73) $sink_(80)
$ns connect $tcp_(80) $sink_(80)
set ftp_(80) [new Application/FTP]
$ftp_(80) attach-agent $tcp_(80)
$ns at 0.2 "$ftp_(80) start"
$ns at 180.0 "$ftp_(80) stop"

#Set a TCP connection between node_(34) and node_(68)
set tcp_(81) [new Agent/TCP/Newreno]
$tcp_(81) set class_ 2
set sink_(81) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(81)
$ns attach-agent $node_(68) $sink_(81)
$ns connect $tcp_(81) $sink_(81)
set ftp_(81) [new Application/FTP]
$ftp_(81) attach-agent $tcp_(81)
$ns at 180.2 "$ftp_(81) start"
$ns at 360.0 "$ftp_(81) stop"

#Set a TCP connection between node_(69) and node_(11)
set tcp_(82) [new Agent/TCP/Newreno]
$tcp_(82) set class_ 2
set sink_(82) [new Agent/TCPSink]
$ns attach-agent $node_(69) $tcp_(82)
$ns attach-agent $node_(11) $sink_(82)
$ns connect $tcp_(82) $sink_(82)
set ftp_(82) [new Application/FTP]
$ftp_(82) attach-agent $tcp_(82)
$ns at 360.2 "$ftp_(82) start"
$ns at 540.0 "$ftp_(82) stop"

#Set a TCP connection between node_(1) and node_(86)
set tcp_(83) [new Agent/TCP/Newreno]
$tcp_(83) set class_ 2
set sink_(83) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(83)
$ns attach-agent $node_(86) $sink_(83)
$ns connect $tcp_(83) $sink_(83)
set ftp_(83) [new Application/FTP]
$ftp_(83) attach-agent $tcp_(83)
$ns at 540.2 "$ftp_(83) start"
$ns at 720.0 "$ftp_(83) stop"

#Set a TCP connection between node_(9) and node_(90)
set tcp_(84) [new Agent/TCP/Newreno]
$tcp_(84) set class_ 2
set sink_(84) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(84)
$ns attach-agent $node_(90) $sink_(84)
$ns connect $tcp_(84) $sink_(84)
set ftp_(84) [new Application/FTP]
$ftp_(84) attach-agent $tcp_(84)
$ns at 720.2 "$ftp_(84) start"
$ns at 900.0 "$ftp_(84) stop"

#Set a TCP connection between node_(68) and node_(98)
set tcp_(85) [new Agent/TCP/Newreno]
$tcp_(85) set class_ 2
set sink_(85) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(85)
$ns attach-agent $node_(98) $sink_(85)
$ns connect $tcp_(85) $sink_(85)
set ftp_(85) [new Application/FTP]
$ftp_(85) attach-agent $tcp_(85)
$ns at 0.2 "$ftp_(85) start"
$ns at 180.0 "$ftp_(85) stop"

#Set a TCP connection between node_(1) and node_(84)
set tcp_(86) [new Agent/TCP/Newreno]
$tcp_(86) set class_ 2
set sink_(86) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(86)
$ns attach-agent $node_(84) $sink_(86)
$ns connect $tcp_(86) $sink_(86)
set ftp_(86) [new Application/FTP]
$ftp_(86) attach-agent $tcp_(86)
$ns at 180.2 "$ftp_(86) start"
$ns at 360.0 "$ftp_(86) stop"

#Set a TCP connection between node_(12) and node_(29)
set tcp_(87) [new Agent/TCP/Newreno]
$tcp_(87) set class_ 2
set sink_(87) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(87)
$ns attach-agent $node_(29) $sink_(87)
$ns connect $tcp_(87) $sink_(87)
set ftp_(87) [new Application/FTP]
$ftp_(87) attach-agent $tcp_(87)
$ns at 360.2 "$ftp_(87) start"
$ns at 540.0 "$ftp_(87) stop"

#Set a TCP connection between node_(79) and node_(33)
set tcp_(88) [new Agent/TCP/Newreno]
$tcp_(88) set class_ 2
set sink_(88) [new Agent/TCPSink]
$ns attach-agent $node_(79) $tcp_(88)
$ns attach-agent $node_(33) $sink_(88)
$ns connect $tcp_(88) $sink_(88)
set ftp_(88) [new Application/FTP]
$ftp_(88) attach-agent $tcp_(88)
$ns at 540.2 "$ftp_(88) start"
$ns at 720.0 "$ftp_(88) stop"

#Set a TCP connection between node_(11) and node_(64)
set tcp_(89) [new Agent/TCP/Newreno]
$tcp_(89) set class_ 2
set sink_(89) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(89)
$ns attach-agent $node_(64) $sink_(89)
$ns connect $tcp_(89) $sink_(89)
set ftp_(89) [new Application/FTP]
$ftp_(89) attach-agent $tcp_(89)
$ns at 720.2 "$ftp_(89) start"
$ns at 900.0 "$ftp_(89) stop"

#Set a TCP connection between node_(59) and node_(40)
set tcp_(90) [new Agent/TCP/Newreno]
$tcp_(90) set class_ 2
set sink_(90) [new Agent/TCPSink]
$ns attach-agent $node_(59) $tcp_(90)
$ns attach-agent $node_(40) $sink_(90)
$ns connect $tcp_(90) $sink_(90)
set ftp_(90) [new Application/FTP]
$ftp_(90) attach-agent $tcp_(90)
$ns at 0.2 "$ftp_(90) start"
$ns at 180.0 "$ftp_(90) stop"

#Set a TCP connection between node_(81) and node_(62)
set tcp_(91) [new Agent/TCP/Newreno]
$tcp_(91) set class_ 2
set sink_(91) [new Agent/TCPSink]
$ns attach-agent $node_(81) $tcp_(91)
$ns attach-agent $node_(62) $sink_(91)
$ns connect $tcp_(91) $sink_(91)
set ftp_(91) [new Application/FTP]
$ftp_(91) attach-agent $tcp_(91)
$ns at 180.2 "$ftp_(91) start"
$ns at 360.0 "$ftp_(91) stop"

#Set a TCP connection between node_(87) and node_(44)
set tcp_(92) [new Agent/TCP/Newreno]
$tcp_(92) set class_ 2
set sink_(92) [new Agent/TCPSink]
$ns attach-agent $node_(87) $tcp_(92)
$ns attach-agent $node_(44) $sink_(92)
$ns connect $tcp_(92) $sink_(92)
set ftp_(92) [new Application/FTP]
$ftp_(92) attach-agent $tcp_(92)
$ns at 360.2 "$ftp_(92) start"
$ns at 540.0 "$ftp_(92) stop"

#Set a TCP connection between node_(6) and node_(48)
set tcp_(93) [new Agent/TCP/Newreno]
$tcp_(93) set class_ 2
set sink_(93) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(93)
$ns attach-agent $node_(48) $sink_(93)
$ns connect $tcp_(93) $sink_(93)
set ftp_(93) [new Application/FTP]
$ftp_(93) attach-agent $tcp_(93)
$ns at 540.2 "$ftp_(93) start"
$ns at 720.0 "$ftp_(93) stop"

#Set a TCP connection between node_(11) and node_(98)
set tcp_(94) [new Agent/TCP/Newreno]
$tcp_(94) set class_ 2
set sink_(94) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(94)
$ns attach-agent $node_(98) $sink_(94)
$ns connect $tcp_(94) $sink_(94)
set ftp_(94) [new Application/FTP]
$ftp_(94) attach-agent $tcp_(94)
$ns at 720.2 "$ftp_(94) start"
$ns at 900.0 "$ftp_(94) stop"

#Set a TCP connection between node_(24) and node_(92)
set tcp_(95) [new Agent/TCP/Newreno]
$tcp_(95) set class_ 2
set sink_(95) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(95)
$ns attach-agent $node_(92) $sink_(95)
$ns connect $tcp_(95) $sink_(95)
set ftp_(95) [new Application/FTP]
$ftp_(95) attach-agent $tcp_(95)
$ns at 0.2 "$ftp_(95) start"
$ns at 180.0 "$ftp_(95) stop"

#Set a TCP connection between node_(8) and node_(50)
set tcp_(96) [new Agent/TCP/Newreno]
$tcp_(96) set class_ 2
set sink_(96) [new Agent/TCPSink]
$ns attach-agent $node_(8) $tcp_(96)
$ns attach-agent $node_(50) $sink_(96)
$ns connect $tcp_(96) $sink_(96)
set ftp_(96) [new Application/FTP]
$ftp_(96) attach-agent $tcp_(96)
$ns at 180.2 "$ftp_(96) start"
$ns at 360.0 "$ftp_(96) stop"

#Set a TCP connection between node_(46) and node_(96)
set tcp_(97) [new Agent/TCP/Newreno]
$tcp_(97) set class_ 2
set sink_(97) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(97)
$ns attach-agent $node_(96) $sink_(97)
$ns connect $tcp_(97) $sink_(97)
set ftp_(97) [new Application/FTP]
$ftp_(97) attach-agent $tcp_(97)
$ns at 360.2 "$ftp_(97) start"
$ns at 540.0 "$ftp_(97) stop"

#Set a TCP connection between node_(80) and node_(38)
set tcp_(98) [new Agent/TCP/Newreno]
$tcp_(98) set class_ 2
set sink_(98) [new Agent/TCPSink]
$ns attach-agent $node_(80) $tcp_(98)
$ns attach-agent $node_(38) $sink_(98)
$ns connect $tcp_(98) $sink_(98)
set ftp_(98) [new Application/FTP]
$ftp_(98) attach-agent $tcp_(98)
$ns at 540.2 "$ftp_(98) start"
$ns at 720.0 "$ftp_(98) stop"

#Set a TCP connection between node_(93) and node_(66)
set tcp_(99) [new Agent/TCP/Newreno]
$tcp_(99) set class_ 2
set sink_(99) [new Agent/TCPSink]
$ns attach-agent $node_(93) $tcp_(99)
$ns attach-agent $node_(66) $sink_(99)
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
