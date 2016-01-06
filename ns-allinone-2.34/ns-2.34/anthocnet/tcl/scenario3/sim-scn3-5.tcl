#sim-scn3-5.tcl 
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
set tracefd       [open sim-scn3-5-$val(rp)-trace.tr w]
set windowVsTime2 [open sim-scn3-5-$val(rp)-win-.tr w]
set namtrace      [open sim-scn3-5-$val(rp).nam w]

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
$node_(0) set X_ 2716 
$node_(0) set Y_ 414 
$node_(0) set Z_ 0.0 
$node_(1) set X_ 710 
$node_(1) set Y_ 890 
$node_(1) set Z_ 0.0 
$node_(2) set X_ 2118 
$node_(2) set Y_ 191 
$node_(2) set Z_ 0.0 
$node_(3) set X_ 256 
$node_(3) set Y_ 557 
$node_(3) set Z_ 0.0 
$node_(4) set X_ 1455 
$node_(4) set Y_ 152 
$node_(4) set Z_ 0.0 
$node_(5) set X_ 2639 
$node_(5) set Y_ 955 
$node_(5) set Z_ 0.0 
$node_(6) set X_ 1334 
$node_(6) set Y_ 728 
$node_(6) set Z_ 0.0 
$node_(7) set X_ 518 
$node_(7) set Y_ 573 
$node_(7) set Z_ 0.0 
$node_(8) set X_ 1324 
$node_(8) set Y_ 711 
$node_(8) set Z_ 0.0 
$node_(9) set X_ 706 
$node_(9) set Y_ 714 
$node_(9) set Z_ 0.0 
$node_(10) set X_ 1721 
$node_(10) set Y_ 426 
$node_(10) set Z_ 0.0 
$node_(11) set X_ 1871 
$node_(11) set Y_ 222 
$node_(11) set Z_ 0.0 
$node_(12) set X_ 2791 
$node_(12) set Y_ 103 
$node_(12) set Z_ 0.0 
$node_(13) set X_ 2425 
$node_(13) set Y_ 149 
$node_(13) set Z_ 0.0 
$node_(14) set X_ 167 
$node_(14) set Y_ 177 
$node_(14) set Z_ 0.0 
$node_(15) set X_ 2533 
$node_(15) set Y_ 492 
$node_(15) set Z_ 0.0 
$node_(16) set X_ 1942 
$node_(16) set Y_ 680 
$node_(16) set Z_ 0.0 
$node_(17) set X_ 2516 
$node_(17) set Y_ 495 
$node_(17) set Z_ 0.0 
$node_(18) set X_ 2500 
$node_(18) set Y_ 511 
$node_(18) set Z_ 0.0 
$node_(19) set X_ 438 
$node_(19) set Y_ 123 
$node_(19) set Z_ 0.0 
$node_(20) set X_ 432 
$node_(20) set Y_ 114 
$node_(20) set Z_ 0.0 
$node_(21) set X_ 2425 
$node_(21) set Y_ 979 
$node_(21) set Z_ 0.0 
$node_(22) set X_ 2834 
$node_(22) set Y_ 46 
$node_(22) set Z_ 0.0 
$node_(23) set X_ 2230 
$node_(23) set Y_ 341 
$node_(23) set Z_ 0.0 
$node_(24) set X_ 2021 
$node_(24) set Y_ 945 
$node_(24) set Z_ 0.0 
$node_(25) set X_ 1725 
$node_(25) set Y_ 9 
$node_(25) set Z_ 0.0 
$node_(26) set X_ 2067 
$node_(26) set Y_ 685 
$node_(26) set Z_ 0.0 
$node_(27) set X_ 2449 
$node_(27) set Y_ 350 
$node_(27) set Z_ 0.0 
$node_(28) set X_ 2776 
$node_(28) set Y_ 865 
$node_(28) set Z_ 0.0 
$node_(29) set X_ 916 
$node_(29) set Y_ 245 
$node_(29) set Z_ 0.0 
$node_(30) set X_ 2496 
$node_(30) set Y_ 330 
$node_(30) set Z_ 0.0 
$node_(31) set X_ 1271 
$node_(31) set Y_ 671 
$node_(31) set Z_ 0.0 
$node_(32) set X_ 790 
$node_(32) set Y_ 124 
$node_(32) set Z_ 0.0 
$node_(33) set X_ 1909 
$node_(33) set Y_ 279 
$node_(33) set Z_ 0.0 
$node_(34) set X_ 282 
$node_(34) set Y_ 133 
$node_(34) set Z_ 0.0 
$node_(35) set X_ 986 
$node_(35) set Y_ 651 
$node_(35) set Z_ 0.0 
$node_(36) set X_ 990 
$node_(36) set Y_ 687 
$node_(36) set Z_ 0.0 
$node_(37) set X_ 2215 
$node_(37) set Y_ 878 
$node_(37) set Z_ 0.0 
$node_(38) set X_ 1200 
$node_(38) set Y_ 552 
$node_(38) set Z_ 0.0 
$node_(39) set X_ 97 
$node_(39) set Y_ 734 
$node_(39) set Z_ 0.0 
$node_(40) set X_ 394 
$node_(40) set Y_ 74 
$node_(40) set Z_ 0.0 
$node_(41) set X_ 624 
$node_(41) set Y_ 984 
$node_(41) set Z_ 0.0 
$node_(42) set X_ 1910 
$node_(42) set Y_ 736 
$node_(42) set Z_ 0.0 
$node_(43) set X_ 1706 
$node_(43) set Y_ 314 
$node_(43) set Z_ 0.0 
$node_(44) set X_ 2892 
$node_(44) set Y_ 981 
$node_(44) set Z_ 0.0 
$node_(45) set X_ 2889 
$node_(45) set Y_ 946 
$node_(45) set Z_ 0.0 
$node_(46) set X_ 2716 
$node_(46) set Y_ 4 
$node_(46) set Z_ 0.0 
$node_(47) set X_ 2573 
$node_(47) set Y_ 266 
$node_(47) set Z_ 0.0 
$node_(48) set X_ 2396 
$node_(48) set Y_ 117 
$node_(48) set Z_ 0.0 
$node_(49) set X_ 1708 
$node_(49) set Y_ 677 
$node_(49) set Z_ 0.0 
$node_(50) set X_ 1508 
$node_(50) set Y_ 437 
$node_(50) set Z_ 0.0 
$node_(51) set X_ 2019 
$node_(51) set Y_ 472 
$node_(51) set Z_ 0.0 
$node_(52) set X_ 2955 
$node_(52) set Y_ 877 
$node_(52) set Z_ 0.0 
$node_(53) set X_ 2017 
$node_(53) set Y_ 702 
$node_(53) set Z_ 0.0 
$node_(54) set X_ 372 
$node_(54) set Y_ 861 
$node_(54) set Z_ 0.0 
$node_(55) set X_ 1561 
$node_(55) set Y_ 939 
$node_(55) set Z_ 0.0 
$node_(56) set X_ 1158 
$node_(56) set Y_ 755 
$node_(56) set Z_ 0.0 
$node_(57) set X_ 1383 
$node_(57) set Y_ 299 
$node_(57) set Z_ 0.0 
$node_(58) set X_ 72 
$node_(58) set Y_ 724 
$node_(58) set Z_ 0.0 
$node_(59) set X_ 2939 
$node_(59) set Y_ 331 
$node_(59) set Z_ 0.0 
$node_(60) set X_ 936 
$node_(60) set Y_ 637 
$node_(60) set Z_ 0.0 
$node_(61) set X_ 1015 
$node_(61) set Y_ 190 
$node_(61) set Z_ 0.0 
$node_(62) set X_ 375 
$node_(62) set Y_ 656 
$node_(62) set Z_ 0.0 
$node_(63) set X_ 933 
$node_(63) set Y_ 998 
$node_(63) set Z_ 0.0 
$node_(64) set X_ 2586 
$node_(64) set Y_ 376 
$node_(64) set Z_ 0.0 
$node_(65) set X_ 676 
$node_(65) set Y_ 495 
$node_(65) set Z_ 0.0 
$node_(66) set X_ 925 
$node_(66) set Y_ 716 
$node_(66) set Z_ 0.0 
$node_(67) set X_ 1126 
$node_(67) set Y_ 835 
$node_(67) set Z_ 0.0 
$node_(68) set X_ 1618 
$node_(68) set Y_ 285 
$node_(68) set Z_ 0.0 
$node_(69) set X_ 520 
$node_(69) set Y_ 897 
$node_(69) set Z_ 0.0 
$node_(70) set X_ 1141 
$node_(70) set Y_ 610 
$node_(70) set Z_ 0.0 
$node_(71) set X_ 514 
$node_(71) set Y_ 564 
$node_(71) set Z_ 0.0 
$node_(72) set X_ 754 
$node_(72) set Y_ 448 
$node_(72) set Z_ 0.0 
$node_(73) set X_ 639 
$node_(73) set Y_ 234 
$node_(73) set Z_ 0.0 
$node_(74) set X_ 1349 
$node_(74) set Y_ 376 
$node_(74) set Z_ 0.0 
$node_(75) set X_ 1612 
$node_(75) set Y_ 243 
$node_(75) set Z_ 0.0 
$node_(76) set X_ 180 
$node_(76) set Y_ 988 
$node_(76) set Z_ 0.0 
$node_(77) set X_ 1830 
$node_(77) set Y_ 964 
$node_(77) set Z_ 0.0 
$node_(78) set X_ 2110 
$node_(78) set Y_ 338 
$node_(78) set Z_ 0.0 
$node_(79) set X_ 2462 
$node_(79) set Y_ 121 
$node_(79) set Z_ 0.0 
$node_(80) set X_ 887 
$node_(80) set Y_ 698 
$node_(80) set Z_ 0.0 
$node_(81) set X_ 2884 
$node_(81) set Y_ 226 
$node_(81) set Z_ 0.0 
$node_(82) set X_ 2467 
$node_(82) set Y_ 322 
$node_(82) set Z_ 0.0 
$node_(83) set X_ 1702 
$node_(83) set Y_ 138 
$node_(83) set Z_ 0.0 
$node_(84) set X_ 2684 
$node_(84) set Y_ 663 
$node_(84) set Z_ 0.0 
$node_(85) set X_ 2401 
$node_(85) set Y_ 435 
$node_(85) set Z_ 0.0 
$node_(86) set X_ 1563 
$node_(86) set Y_ 410 
$node_(86) set Z_ 0.0 
$node_(87) set X_ 1576 
$node_(87) set Y_ 674 
$node_(87) set Z_ 0.0 
$node_(88) set X_ 232 
$node_(88) set Y_ 784 
$node_(88) set Z_ 0.0 
$node_(89) set X_ 1924 
$node_(89) set Y_ 638 
$node_(89) set Z_ 0.0 
$node_(90) set X_ 2865 
$node_(90) set Y_ 766 
$node_(90) set Z_ 0.0 
$node_(91) set X_ 1570 
$node_(91) set Y_ 366 
$node_(91) set Z_ 0.0 
$node_(92) set X_ 2185 
$node_(92) set Y_ 333 
$node_(92) set Z_ 0.0 
$node_(93) set X_ 1912 
$node_(93) set Y_ 69 
$node_(93) set Z_ 0.0 
$node_(94) set X_ 2933 
$node_(94) set Y_ 278 
$node_(94) set Z_ 0.0 
$node_(95) set X_ 42 
$node_(95) set Y_ 84 
$node_(95) set Z_ 0.0 
$node_(96) set X_ 281 
$node_(96) set Y_ 951 
$node_(96) set Z_ 0.0 
$node_(97) set X_ 826 
$node_(97) set Y_ 620 
$node_(97) set Z_ 0.0 
$node_(98) set X_ 1472 
$node_(98) set Y_ 59 
$node_(98) set Z_ 0.0 
$node_(99) set X_ 1030 
$node_(99) set Y_ 393 
$node_(99) set Z_ 0.0 
$node_(100) set X_ 1963 
$node_(100) set Y_ 714 
$node_(100) set Z_ 0.0 
$node_(101) set X_ 2374 
$node_(101) set Y_ 194 
$node_(101) set Z_ 0.0 
$ns at 0.0 "$node_(101) off" 
$ns at 100.0 "$node_(101) on" 
$node_(102) set X_ 1115 
$node_(102) set Y_ 63 
$node_(102) set Z_ 0.0 
$ns at 0.0 "$node_(102) off" 
$ns at 100.0 "$node_(102) on" 
$node_(103) set X_ 113 
$node_(103) set Y_ 80 
$node_(103) set Z_ 0.0 
$ns at 0.0 "$node_(103) off" 
$ns at 100.0 "$node_(103) on" 
$node_(104) set X_ 883 
$node_(104) set Y_ 178 
$node_(104) set Z_ 0.0 
$ns at 0.0 "$node_(104) off" 
$ns at 100.0 "$node_(104) on" 
$node_(105) set X_ 664 
$node_(105) set Y_ 119 
$node_(105) set Z_ 0.0 
$ns at 0.0 "$node_(105) off" 
$ns at 100.0 "$node_(105) on" 
$node_(106) set X_ 2169 
$node_(106) set Y_ 344 
$node_(106) set Z_ 0.0 
$ns at 0.0 "$node_(106) off" 
$ns at 100.0 "$node_(106) on" 
$node_(107) set X_ 1996 
$node_(107) set Y_ 592 
$node_(107) set Z_ 0.0 
$ns at 0.0 "$node_(107) off" 
$ns at 100.0 "$node_(107) on" 
$node_(108) set X_ 372 
$node_(108) set Y_ 542 
$node_(108) set Z_ 0.0 
$ns at 0.0 "$node_(108) off" 
$ns at 100.0 "$node_(108) on" 
$node_(109) set X_ 814 
$node_(109) set Y_ 118 
$node_(109) set Z_ 0.0 
$ns at 0.0 "$node_(109) off" 
$ns at 100.0 "$node_(109) on" 
$node_(110) set X_ 1268 
$node_(110) set Y_ 712 
$node_(110) set Z_ 0.0 
$ns at 0.0 "$node_(110) off" 
$ns at 100.0 "$node_(110) on" 
$node_(111) set X_ 217 
$node_(111) set Y_ 444 
$node_(111) set Z_ 0.0 
$ns at 0.0 "$node_(111) off" 
$ns at 100.0 "$node_(111) on" 
$node_(112) set X_ 1713 
$node_(112) set Y_ 314 
$node_(112) set Z_ 0.0 
$ns at 0.0 "$node_(112) off" 
$ns at 100.0 "$node_(112) on" 
$node_(113) set X_ 1290 
$node_(113) set Y_ 504 
$node_(113) set Z_ 0.0 
$ns at 0.0 "$node_(113) off" 
$ns at 100.0 "$node_(113) on" 
$node_(114) set X_ 663 
$node_(114) set Y_ 834 
$node_(114) set Z_ 0.0 
$ns at 0.0 "$node_(114) off" 
$ns at 100.0 "$node_(114) on" 
$node_(115) set X_ 121 
$node_(115) set Y_ 955 
$node_(115) set Z_ 0.0 
$ns at 0.0 "$node_(115) off" 
$ns at 100.0 "$node_(115) on" 
$node_(116) set X_ 1815 
$node_(116) set Y_ 143 
$node_(116) set Z_ 0.0 
$ns at 0.0 "$node_(116) off" 
$ns at 100.0 "$node_(116) on" 
$node_(117) set X_ 3000 
$node_(117) set Y_ 587 
$node_(117) set Z_ 0.0 
$ns at 0.0 "$node_(117) off" 
$ns at 100.0 "$node_(117) on" 
$node_(118) set X_ 2615 
$node_(118) set Y_ 12 
$node_(118) set Z_ 0.0 
$ns at 0.0 "$node_(118) off" 
$ns at 100.0 "$node_(118) on" 
$node_(119) set X_ 2010 
$node_(119) set Y_ 874 
$node_(119) set Z_ 0.0 
$ns at 0.0 "$node_(119) off" 
$ns at 100.0 "$node_(119) on" 
$node_(120) set X_ 620 
$node_(120) set Y_ 696 
$node_(120) set Z_ 0.0 
$ns at 0.0 "$node_(120) off" 
$ns at 100.0 "$node_(120) on" 
$node_(121) set X_ 2911 
$node_(121) set Y_ 485 
$node_(121) set Z_ 0.0 
$ns at 0.0 "$node_(121) off" 
$ns at 100.0 "$node_(121) on" 
$node_(122) set X_ 90 
$node_(122) set Y_ 196 
$node_(122) set Z_ 0.0 
$ns at 0.0 "$node_(122) off" 
$ns at 100.0 "$node_(122) on" 
$node_(123) set X_ 123 
$node_(123) set Y_ 734 
$node_(123) set Z_ 0.0 
$ns at 0.0 "$node_(123) off" 
$ns at 100.0 "$node_(123) on" 
$node_(124) set X_ 1339 
$node_(124) set Y_ 732 
$node_(124) set Z_ 0.0 
$ns at 0.0 "$node_(124) off" 
$ns at 100.0 "$node_(124) on" 
$node_(125) set X_ 2740 
$node_(125) set Y_ 795 
$node_(125) set Z_ 0.0 
$ns at 0.0 "$node_(125) off" 
$ns at 100.0 "$node_(125) on" 
$node_(126) set X_ 2741 
$node_(126) set Y_ 969 
$node_(126) set Z_ 0.0 
$ns at 0.0 "$node_(126) off" 
$ns at 100.0 "$node_(126) on" 
$node_(127) set X_ 2846 
$node_(127) set Y_ 23 
$node_(127) set Z_ 0.0 
$ns at 0.0 "$node_(127) off" 
$ns at 100.0 "$node_(127) on" 
$node_(128) set X_ 2347 
$node_(128) set Y_ 765 
$node_(128) set Z_ 0.0 
$ns at 0.0 "$node_(128) off" 
$ns at 100.0 "$node_(128) on" 
$node_(129) set X_ 970 
$node_(129) set Y_ 841 
$node_(129) set Z_ 0.0 
$ns at 0.0 "$node_(129) off" 
$ns at 100.0 "$node_(129) on" 
$node_(130) set X_ 2874 
$node_(130) set Y_ 548 
$node_(130) set Z_ 0.0 
$ns at 0.0 "$node_(130) off" 
$ns at 100.0 "$node_(130) on" 
$node_(131) set X_ 2295 
$node_(131) set Y_ 497 
$node_(131) set Z_ 0.0 
$ns at 0.0 "$node_(131) off" 
$ns at 100.0 "$node_(131) on" 
$node_(132) set X_ 1346 
$node_(132) set Y_ 960 
$node_(132) set Z_ 0.0 
$ns at 0.0 "$node_(132) off" 
$ns at 100.0 "$node_(132) on" 
$node_(133) set X_ 233 
$node_(133) set Y_ 445 
$node_(133) set Z_ 0.0 
$ns at 0.0 "$node_(133) off" 
$ns at 100.0 "$node_(133) on" 
$node_(134) set X_ 2881 
$node_(134) set Y_ 52 
$node_(134) set Z_ 0.0 
$ns at 0.0 "$node_(134) off" 
$ns at 100.0 "$node_(134) on" 
$node_(135) set X_ 2197 
$node_(135) set Y_ 213 
$node_(135) set Z_ 0.0 
$ns at 0.0 "$node_(135) off" 
$ns at 100.0 "$node_(135) on" 
$node_(136) set X_ 112 
$node_(136) set Y_ 162 
$node_(136) set Z_ 0.0 
$ns at 0.0 "$node_(136) off" 
$ns at 100.0 "$node_(136) on" 
$node_(137) set X_ 2841 
$node_(137) set Y_ 438 
$node_(137) set Z_ 0.0 
$ns at 0.0 "$node_(137) off" 
$ns at 100.0 "$node_(137) on" 
$node_(138) set X_ 1333 
$node_(138) set Y_ 573 
$node_(138) set Z_ 0.0 
$ns at 0.0 "$node_(138) off" 
$ns at 100.0 "$node_(138) on" 
$node_(139) set X_ 693 
$node_(139) set Y_ 127 
$node_(139) set Z_ 0.0 
$ns at 0.0 "$node_(139) off" 
$ns at 100.0 "$node_(139) on" 
$node_(140) set X_ 1933 
$node_(140) set Y_ 193 
$node_(140) set Z_ 0.0 
$ns at 0.0 "$node_(140) off" 
$ns at 100.0 "$node_(140) on" 
$node_(141) set X_ 975 
$node_(141) set Y_ 359 
$node_(141) set Z_ 0.0 
$ns at 0.0 "$node_(141) off" 
$ns at 100.0 "$node_(141) on" 
$node_(142) set X_ 716 
$node_(142) set Y_ 801 
$node_(142) set Z_ 0.0 
$ns at 0.0 "$node_(142) off" 
$ns at 100.0 "$node_(142) on" 
$node_(143) set X_ 2495 
$node_(143) set Y_ 324 
$node_(143) set Z_ 0.0 
$ns at 0.0 "$node_(143) off" 
$ns at 100.0 "$node_(143) on" 
$node_(144) set X_ 574 
$node_(144) set Y_ 820 
$node_(144) set Z_ 0.0 
$ns at 0.0 "$node_(144) off" 
$ns at 100.0 "$node_(144) on" 
$node_(145) set X_ 1831 
$node_(145) set Y_ 56 
$node_(145) set Z_ 0.0 
$ns at 0.0 "$node_(145) off" 
$ns at 100.0 "$node_(145) on" 
$node_(146) set X_ 1522 
$node_(146) set Y_ 243 
$node_(146) set Z_ 0.0 
$ns at 0.0 "$node_(146) off" 
$ns at 100.0 "$node_(146) on" 
$node_(147) set X_ 517 
$node_(147) set Y_ 229 
$node_(147) set Z_ 0.0 
$ns at 0.0 "$node_(147) off" 
$ns at 100.0 "$node_(147) on" 
$node_(148) set X_ 2350 
$node_(148) set Y_ 32 
$node_(148) set Z_ 0.0 
$ns at 0.0 "$node_(148) off" 
$ns at 100.0 "$node_(148) on" 
$node_(149) set X_ 2731 
$node_(149) set Y_ 142 
$node_(149) set Z_ 0.0 
$ns at 0.0 "$node_(149) off" 
$ns at 100.0 "$node_(149) on" 
$node_(150) set X_ 2148 
$node_(150) set Y_ 290 
$node_(150) set Z_ 0.0 
$ns at 0.0 "$node_(150) off" 
$ns at 100.0 "$node_(150) on" 
$node_(151) set X_ 2916 
$node_(151) set Y_ 360 
$node_(151) set Z_ 0.0 
$ns at 0.0 "$node_(151) off" 
$ns at 100.0 "$node_(151) on" 
$node_(152) set X_ 661 
$node_(152) set Y_ 533 
$node_(152) set Z_ 0.0 
$ns at 0.0 "$node_(152) off" 
$ns at 100.0 "$node_(152) on" 
$node_(153) set X_ 2990 
$node_(153) set Y_ 515 
$node_(153) set Z_ 0.0 
$ns at 0.0 "$node_(153) off" 
$ns at 100.0 "$node_(153) on" 
$node_(154) set X_ 833 
$node_(154) set Y_ 658 
$node_(154) set Z_ 0.0 
$ns at 0.0 "$node_(154) off" 
$ns at 100.0 "$node_(154) on" 
$node_(155) set X_ 2167 
$node_(155) set Y_ 476 
$node_(155) set Z_ 0.0 
$ns at 0.0 "$node_(155) off" 
$ns at 100.0 "$node_(155) on" 
$node_(156) set X_ 71 
$node_(156) set Y_ 570 
$node_(156) set Z_ 0.0 
$ns at 0.0 "$node_(156) off" 
$ns at 100.0 "$node_(156) on" 
$node_(157) set X_ 2061 
$node_(157) set Y_ 396 
$node_(157) set Z_ 0.0 
$ns at 0.0 "$node_(157) off" 
$ns at 100.0 "$node_(157) on" 
$node_(158) set X_ 2587 
$node_(158) set Y_ 968 
$node_(158) set Z_ 0.0 
$ns at 0.0 "$node_(158) off" 
$ns at 100.0 "$node_(158) on" 
$node_(159) set X_ 2590 
$node_(159) set Y_ 188 
$node_(159) set Z_ 0.0 
$ns at 0.0 "$node_(159) off" 
$ns at 100.0 "$node_(159) on" 
$node_(160) set X_ 1770 
$node_(160) set Y_ 525 
$node_(160) set Z_ 0.0 
$ns at 0.0 "$node_(160) off" 
$ns at 100.0 "$node_(160) on" 
$node_(161) set X_ 231 
$node_(161) set Y_ 599 
$node_(161) set Z_ 0.0 
$ns at 0.0 "$node_(161) off" 
$ns at 100.0 "$node_(161) on" 
$node_(162) set X_ 1834 
$node_(162) set Y_ 497 
$node_(162) set Z_ 0.0 
$ns at 0.0 "$node_(162) off" 
$ns at 100.0 "$node_(162) on" 
$node_(163) set X_ 1484 
$node_(163) set Y_ 373 
$node_(163) set Z_ 0.0 
$ns at 0.0 "$node_(163) off" 
$ns at 100.0 "$node_(163) on" 
$node_(164) set X_ 1005 
$node_(164) set Y_ 885 
$node_(164) set Z_ 0.0 
$ns at 0.0 "$node_(164) off" 
$ns at 100.0 "$node_(164) on" 
$node_(165) set X_ 905 
$node_(165) set Y_ 980 
$node_(165) set Z_ 0.0 
$ns at 0.0 "$node_(165) off" 
$ns at 100.0 "$node_(165) on" 
$node_(166) set X_ 2226 
$node_(166) set Y_ 350 
$node_(166) set Z_ 0.0 
$ns at 0.0 "$node_(166) off" 
$ns at 100.0 "$node_(166) on" 
$node_(167) set X_ 2750 
$node_(167) set Y_ 962 
$node_(167) set Z_ 0.0 
$ns at 0.0 "$node_(167) off" 
$ns at 100.0 "$node_(167) on" 
$node_(168) set X_ 2840 
$node_(168) set Y_ 501 
$node_(168) set Z_ 0.0 
$ns at 0.0 "$node_(168) off" 
$ns at 100.0 "$node_(168) on" 
$node_(169) set X_ 2252 
$node_(169) set Y_ 283 
$node_(169) set Z_ 0.0 
$ns at 0.0 "$node_(169) off" 
$ns at 100.0 "$node_(169) on" 
$node_(170) set X_ 855 
$node_(170) set Y_ 586 
$node_(170) set Z_ 0.0 
$ns at 0.0 "$node_(170) off" 
$ns at 100.0 "$node_(170) on" 
$node_(171) set X_ 1683 
$node_(171) set Y_ 953 
$node_(171) set Z_ 0.0 
$ns at 0.0 "$node_(171) off" 
$ns at 100.0 "$node_(171) on" 
$node_(172) set X_ 305 
$node_(172) set Y_ 280 
$node_(172) set Z_ 0.0 
$ns at 0.0 "$node_(172) off" 
$ns at 100.0 "$node_(172) on" 
$node_(173) set X_ 2729 
$node_(173) set Y_ 828 
$node_(173) set Z_ 0.0 
$ns at 0.0 "$node_(173) off" 
$ns at 100.0 "$node_(173) on" 
$node_(174) set X_ 2812 
$node_(174) set Y_ 74 
$node_(174) set Z_ 0.0 
$ns at 0.0 "$node_(174) off" 
$ns at 100.0 "$node_(174) on" 
$node_(175) set X_ 311 
$node_(175) set Y_ 708 
$node_(175) set Z_ 0.0 
$ns at 0.0 "$node_(175) off" 
$ns at 100.0 "$node_(175) on" 
$node_(176) set X_ 798 
$node_(176) set Y_ 691 
$node_(176) set Z_ 0.0 
$ns at 0.0 "$node_(176) off" 
$ns at 100.0 "$node_(176) on" 
$node_(177) set X_ 780 
$node_(177) set Y_ 762 
$node_(177) set Z_ 0.0 
$ns at 0.0 "$node_(177) off" 
$ns at 100.0 "$node_(177) on" 
$node_(178) set X_ 823 
$node_(178) set Y_ 72 
$node_(178) set Z_ 0.0 
$ns at 0.0 "$node_(178) off" 
$ns at 100.0 "$node_(178) on" 
$node_(179) set X_ 2455 
$node_(179) set Y_ 890 
$node_(179) set Z_ 0.0 
$ns at 0.0 "$node_(179) off" 
$ns at 100.0 "$node_(179) on" 
$node_(180) set X_ 1317 
$node_(180) set Y_ 751 
$node_(180) set Z_ 0.0 
$ns at 0.0 "$node_(180) off" 
$ns at 100.0 "$node_(180) on" 
$node_(181) set X_ 2725 
$node_(181) set Y_ 814 
$node_(181) set Z_ 0.0 
$ns at 0.0 "$node_(181) off" 
$ns at 100.0 "$node_(181) on" 
$node_(182) set X_ 2417 
$node_(182) set Y_ 831 
$node_(182) set Z_ 0.0 
$ns at 0.0 "$node_(182) off" 
$ns at 100.0 "$node_(182) on" 
$node_(183) set X_ 1388 
$node_(183) set Y_ 597 
$node_(183) set Z_ 0.0 
$ns at 0.0 "$node_(183) off" 
$ns at 100.0 "$node_(183) on" 
$node_(184) set X_ 2870 
$node_(184) set Y_ 370 
$node_(184) set Z_ 0.0 
$ns at 0.0 "$node_(184) off" 
$ns at 100.0 "$node_(184) on" 
$node_(185) set X_ 2612 
$node_(185) set Y_ 778 
$node_(185) set Z_ 0.0 
$ns at 0.0 "$node_(185) off" 
$ns at 100.0 "$node_(185) on" 
$node_(186) set X_ 1842 
$node_(186) set Y_ 717 
$node_(186) set Z_ 0.0 
$ns at 0.0 "$node_(186) off" 
$ns at 100.0 "$node_(186) on" 
$node_(187) set X_ 770 
$node_(187) set Y_ 548 
$node_(187) set Z_ 0.0 
$ns at 0.0 "$node_(187) off" 
$ns at 100.0 "$node_(187) on" 
$node_(188) set X_ 2141 
$node_(188) set Y_ 199 
$node_(188) set Z_ 0.0 
$ns at 0.0 "$node_(188) off" 
$ns at 100.0 "$node_(188) on" 
$node_(189) set X_ 576 
$node_(189) set Y_ 167 
$node_(189) set Z_ 0.0 
$ns at 0.0 "$node_(189) off" 
$ns at 100.0 "$node_(189) on" 
$node_(190) set X_ 1702 
$node_(190) set Y_ 643 
$node_(190) set Z_ 0.0 
$ns at 0.0 "$node_(190) off" 
$ns at 100.0 "$node_(190) on" 
$node_(191) set X_ 2241 
$node_(191) set Y_ 388 
$node_(191) set Z_ 0.0 
$ns at 0.0 "$node_(191) off" 
$ns at 100.0 "$node_(191) on" 
$node_(192) set X_ 1270 
$node_(192) set Y_ 387 
$node_(192) set Z_ 0.0 
$ns at 0.0 "$node_(192) off" 
$ns at 100.0 "$node_(192) on" 
$node_(193) set X_ 965 
$node_(193) set Y_ 750 
$node_(193) set Z_ 0.0 
$ns at 0.0 "$node_(193) off" 
$ns at 100.0 "$node_(193) on" 
$node_(194) set X_ 1016 
$node_(194) set Y_ 805 
$node_(194) set Z_ 0.0 
$ns at 0.0 "$node_(194) off" 
$ns at 100.0 "$node_(194) on" 
$node_(195) set X_ 1843 
$node_(195) set Y_ 449 
$node_(195) set Z_ 0.0 
$ns at 0.0 "$node_(195) off" 
$ns at 100.0 "$node_(195) on" 
$node_(196) set X_ 2315 
$node_(196) set Y_ 878 
$node_(196) set Z_ 0.0 
$ns at 0.0 "$node_(196) off" 
$ns at 100.0 "$node_(196) on" 
$node_(197) set X_ 1272 
$node_(197) set Y_ 937 
$node_(197) set Z_ 0.0 
$ns at 0.0 "$node_(197) off" 
$ns at 100.0 "$node_(197) on" 
$node_(198) set X_ 2177 
$node_(198) set Y_ 18 
$node_(198) set Z_ 0.0 
$ns at 0.0 "$node_(198) off" 
$ns at 100.0 "$node_(198) on" 
$node_(199) set X_ 2155 
$node_(199) set Y_ 549 
$node_(199) set Z_ 0.0 
$ns at 0.0 "$node_(199) off" 
$ns at 100.0 "$node_(199) on" 
$node_(200) set X_ 1755 
$node_(200) set Y_ 160 
$node_(200) set Z_ 0.0 
$ns at 0.0 "$node_(200) off" 
$ns at 200.0 "$node_(200) on" 
$node_(201) set X_ 1643 
$node_(201) set Y_ 202 
$node_(201) set Z_ 0.0 
$ns at 0.0 "$node_(201) off" 
$ns at 200.0 "$node_(201) on" 
$node_(202) set X_ 20 
$node_(202) set Y_ 154 
$node_(202) set Z_ 0.0 
$ns at 0.0 "$node_(202) off" 
$ns at 200.0 "$node_(202) on" 
$node_(203) set X_ 2805 
$node_(203) set Y_ 667 
$node_(203) set Z_ 0.0 
$ns at 0.0 "$node_(203) off" 
$ns at 200.0 "$node_(203) on" 
$node_(204) set X_ 1115 
$node_(204) set Y_ 583 
$node_(204) set Z_ 0.0 
$ns at 0.0 "$node_(204) off" 
$ns at 200.0 "$node_(204) on" 
$node_(205) set X_ 2493 
$node_(205) set Y_ 16 
$node_(205) set Z_ 0.0 
$ns at 0.0 "$node_(205) off" 
$ns at 200.0 "$node_(205) on" 
$node_(206) set X_ 960 
$node_(206) set Y_ 458 
$node_(206) set Z_ 0.0 
$ns at 0.0 "$node_(206) off" 
$ns at 200.0 "$node_(206) on" 
$node_(207) set X_ 1760 
$node_(207) set Y_ 555 
$node_(207) set Z_ 0.0 
$ns at 0.0 "$node_(207) off" 
$ns at 200.0 "$node_(207) on" 
$node_(208) set X_ 2552 
$node_(208) set Y_ 677 
$node_(208) set Z_ 0.0 
$ns at 0.0 "$node_(208) off" 
$ns at 200.0 "$node_(208) on" 
$node_(209) set X_ 506 
$node_(209) set Y_ 994 
$node_(209) set Z_ 0.0 
$ns at 0.0 "$node_(209) off" 
$ns at 200.0 "$node_(209) on" 
$node_(210) set X_ 923 
$node_(210) set Y_ 756 
$node_(210) set Z_ 0.0 
$ns at 0.0 "$node_(210) off" 
$ns at 200.0 "$node_(210) on" 
$node_(211) set X_ 1542 
$node_(211) set Y_ 653 
$node_(211) set Z_ 0.0 
$ns at 0.0 "$node_(211) off" 
$ns at 200.0 "$node_(211) on" 
$node_(212) set X_ 991 
$node_(212) set Y_ 76 
$node_(212) set Z_ 0.0 
$ns at 0.0 "$node_(212) off" 
$ns at 200.0 "$node_(212) on" 
$node_(213) set X_ 43 
$node_(213) set Y_ 204 
$node_(213) set Z_ 0.0 
$ns at 0.0 "$node_(213) off" 
$ns at 200.0 "$node_(213) on" 
$node_(214) set X_ 1529 
$node_(214) set Y_ 837 
$node_(214) set Z_ 0.0 
$ns at 0.0 "$node_(214) off" 
$ns at 200.0 "$node_(214) on" 
$node_(215) set X_ 277 
$node_(215) set Y_ 854 
$node_(215) set Z_ 0.0 
$ns at 0.0 "$node_(215) off" 
$ns at 200.0 "$node_(215) on" 
$node_(216) set X_ 161 
$node_(216) set Y_ 975 
$node_(216) set Z_ 0.0 
$ns at 0.0 "$node_(216) off" 
$ns at 200.0 "$node_(216) on" 
$node_(217) set X_ 746 
$node_(217) set Y_ 858 
$node_(217) set Z_ 0.0 
$ns at 0.0 "$node_(217) off" 
$ns at 200.0 "$node_(217) on" 
$node_(218) set X_ 745 
$node_(218) set Y_ 514 
$node_(218) set Z_ 0.0 
$ns at 0.0 "$node_(218) off" 
$ns at 200.0 "$node_(218) on" 
$node_(219) set X_ 2225 
$node_(219) set Y_ 979 
$node_(219) set Z_ 0.0 
$ns at 0.0 "$node_(219) off" 
$ns at 200.0 "$node_(219) on" 
$node_(220) set X_ 2605 
$node_(220) set Y_ 246 
$node_(220) set Z_ 0.0 
$ns at 0.0 "$node_(220) off" 
$ns at 200.0 "$node_(220) on" 
$node_(221) set X_ 847 
$node_(221) set Y_ 830 
$node_(221) set Z_ 0.0 
$ns at 0.0 "$node_(221) off" 
$ns at 200.0 "$node_(221) on" 
$node_(222) set X_ 2970 
$node_(222) set Y_ 141 
$node_(222) set Z_ 0.0 
$ns at 0.0 "$node_(222) off" 
$ns at 200.0 "$node_(222) on" 
$node_(223) set X_ 2199 
$node_(223) set Y_ 21 
$node_(223) set Z_ 0.0 
$ns at 0.0 "$node_(223) off" 
$ns at 200.0 "$node_(223) on" 
$node_(224) set X_ 2520 
$node_(224) set Y_ 611 
$node_(224) set Z_ 0.0 
$ns at 0.0 "$node_(224) off" 
$ns at 200.0 "$node_(224) on" 
$node_(225) set X_ 2480 
$node_(225) set Y_ 722 
$node_(225) set Z_ 0.0 
$ns at 0.0 "$node_(225) off" 
$ns at 200.0 "$node_(225) on" 
$node_(226) set X_ 1270 
$node_(226) set Y_ 605 
$node_(226) set Z_ 0.0 
$ns at 0.0 "$node_(226) off" 
$ns at 200.0 "$node_(226) on" 
$node_(227) set X_ 1020 
$node_(227) set Y_ 513 
$node_(227) set Z_ 0.0 
$ns at 0.0 "$node_(227) off" 
$ns at 200.0 "$node_(227) on" 
$node_(228) set X_ 2003 
$node_(228) set Y_ 518 
$node_(228) set Z_ 0.0 
$ns at 0.0 "$node_(228) off" 
$ns at 200.0 "$node_(228) on" 
$node_(229) set X_ 5 
$node_(229) set Y_ 418 
$node_(229) set Z_ 0.0 
$ns at 0.0 "$node_(229) off" 
$ns at 200.0 "$node_(229) on" 
$node_(230) set X_ 2225 
$node_(230) set Y_ 66 
$node_(230) set Z_ 0.0 
$ns at 0.0 "$node_(230) off" 
$ns at 200.0 "$node_(230) on" 
$node_(231) set X_ 1911 
$node_(231) set Y_ 578 
$node_(231) set Z_ 0.0 
$ns at 0.0 "$node_(231) off" 
$ns at 200.0 "$node_(231) on" 
$node_(232) set X_ 51 
$node_(232) set Y_ 620 
$node_(232) set Z_ 0.0 
$ns at 0.0 "$node_(232) off" 
$ns at 200.0 "$node_(232) on" 
$node_(233) set X_ 2140 
$node_(233) set Y_ 350 
$node_(233) set Z_ 0.0 
$ns at 0.0 "$node_(233) off" 
$ns at 200.0 "$node_(233) on" 
$node_(234) set X_ 2604 
$node_(234) set Y_ 950 
$node_(234) set Z_ 0.0 
$ns at 0.0 "$node_(234) off" 
$ns at 200.0 "$node_(234) on" 
$node_(235) set X_ 1485 
$node_(235) set Y_ 517 
$node_(235) set Z_ 0.0 
$ns at 0.0 "$node_(235) off" 
$ns at 200.0 "$node_(235) on" 
$node_(236) set X_ 404 
$node_(236) set Y_ 986 
$node_(236) set Z_ 0.0 
$ns at 0.0 "$node_(236) off" 
$ns at 200.0 "$node_(236) on" 
$node_(237) set X_ 1406 
$node_(237) set Y_ 915 
$node_(237) set Z_ 0.0 
$ns at 0.0 "$node_(237) off" 
$ns at 200.0 "$node_(237) on" 
$node_(238) set X_ 1832 
$node_(238) set Y_ 988 
$node_(238) set Z_ 0.0 
$ns at 0.0 "$node_(238) off" 
$ns at 200.0 "$node_(238) on" 
$node_(239) set X_ 1733 
$node_(239) set Y_ 994 
$node_(239) set Z_ 0.0 
$ns at 0.0 "$node_(239) off" 
$ns at 200.0 "$node_(239) on" 
$node_(240) set X_ 1068 
$node_(240) set Y_ 462 
$node_(240) set Z_ 0.0 
$ns at 0.0 "$node_(240) off" 
$ns at 200.0 "$node_(240) on" 
$node_(241) set X_ 184 
$node_(241) set Y_ 772 
$node_(241) set Z_ 0.0 
$ns at 0.0 "$node_(241) off" 
$ns at 200.0 "$node_(241) on" 
$node_(242) set X_ 2971 
$node_(242) set Y_ 296 
$node_(242) set Z_ 0.0 
$ns at 0.0 "$node_(242) off" 
$ns at 200.0 "$node_(242) on" 
$node_(243) set X_ 1147 
$node_(243) set Y_ 171 
$node_(243) set Z_ 0.0 
$ns at 0.0 "$node_(243) off" 
$ns at 200.0 "$node_(243) on" 
$node_(244) set X_ 1110 
$node_(244) set Y_ 797 
$node_(244) set Z_ 0.0 
$ns at 0.0 "$node_(244) off" 
$ns at 200.0 "$node_(244) on" 
$node_(245) set X_ 2398 
$node_(245) set Y_ 955 
$node_(245) set Z_ 0.0 
$ns at 0.0 "$node_(245) off" 
$ns at 200.0 "$node_(245) on" 
$node_(246) set X_ 662 
$node_(246) set Y_ 788 
$node_(246) set Z_ 0.0 
$ns at 0.0 "$node_(246) off" 
$ns at 200.0 "$node_(246) on" 
$node_(247) set X_ 1910 
$node_(247) set Y_ 359 
$node_(247) set Z_ 0.0 
$ns at 0.0 "$node_(247) off" 
$ns at 200.0 "$node_(247) on" 
$node_(248) set X_ 1064 
$node_(248) set Y_ 460 
$node_(248) set Z_ 0.0 
$ns at 0.0 "$node_(248) off" 
$ns at 200.0 "$node_(248) on" 
$node_(249) set X_ 604 
$node_(249) set Y_ 21 
$node_(249) set Z_ 0.0 
$ns at 0.0 "$node_(249) off" 
$ns at 200.0 "$node_(249) on" 
$node_(250) set X_ 267 
$node_(250) set Y_ 419 
$node_(250) set Z_ 0.0 
$ns at 0.0 "$node_(250) off" 
$ns at 200.0 "$node_(250) on" 
$node_(251) set X_ 1768 
$node_(251) set Y_ 25 
$node_(251) set Z_ 0.0 
$ns at 0.0 "$node_(251) off" 
$ns at 200.0 "$node_(251) on" 
$node_(252) set X_ 1039 
$node_(252) set Y_ 264 
$node_(252) set Z_ 0.0 
$ns at 0.0 "$node_(252) off" 
$ns at 200.0 "$node_(252) on" 
$node_(253) set X_ 1019 
$node_(253) set Y_ 688 
$node_(253) set Z_ 0.0 
$ns at 0.0 "$node_(253) off" 
$ns at 200.0 "$node_(253) on" 
$node_(254) set X_ 2153 
$node_(254) set Y_ 49 
$node_(254) set Z_ 0.0 
$ns at 0.0 "$node_(254) off" 
$ns at 200.0 "$node_(254) on" 
$node_(255) set X_ 26 
$node_(255) set Y_ 237 
$node_(255) set Z_ 0.0 
$ns at 0.0 "$node_(255) off" 
$ns at 200.0 "$node_(255) on" 
$node_(256) set X_ 1364 
$node_(256) set Y_ 218 
$node_(256) set Z_ 0.0 
$ns at 0.0 "$node_(256) off" 
$ns at 200.0 "$node_(256) on" 
$node_(257) set X_ 752 
$node_(257) set Y_ 666 
$node_(257) set Z_ 0.0 
$ns at 0.0 "$node_(257) off" 
$ns at 200.0 "$node_(257) on" 
$node_(258) set X_ 2852 
$node_(258) set Y_ 931 
$node_(258) set Z_ 0.0 
$ns at 0.0 "$node_(258) off" 
$ns at 200.0 "$node_(258) on" 
$node_(259) set X_ 2785 
$node_(259) set Y_ 874 
$node_(259) set Z_ 0.0 
$ns at 0.0 "$node_(259) off" 
$ns at 200.0 "$node_(259) on" 
$node_(260) set X_ 2373 
$node_(260) set Y_ 224 
$node_(260) set Z_ 0.0 
$ns at 0.0 "$node_(260) off" 
$ns at 200.0 "$node_(260) on" 
$node_(261) set X_ 287 
$node_(261) set Y_ 647 
$node_(261) set Z_ 0.0 
$ns at 0.0 "$node_(261) off" 
$ns at 200.0 "$node_(261) on" 
$node_(262) set X_ 2541 
$node_(262) set Y_ 105 
$node_(262) set Z_ 0.0 
$ns at 0.0 "$node_(262) off" 
$ns at 200.0 "$node_(262) on" 
$node_(263) set X_ 1352 
$node_(263) set Y_ 190 
$node_(263) set Z_ 0.0 
$ns at 0.0 "$node_(263) off" 
$ns at 200.0 "$node_(263) on" 
$node_(264) set X_ 649 
$node_(264) set Y_ 538 
$node_(264) set Z_ 0.0 
$ns at 0.0 "$node_(264) off" 
$ns at 200.0 "$node_(264) on" 
$node_(265) set X_ 2969 
$node_(265) set Y_ 649 
$node_(265) set Z_ 0.0 
$ns at 0.0 "$node_(265) off" 
$ns at 200.0 "$node_(265) on" 
$node_(266) set X_ 88 
$node_(266) set Y_ 206 
$node_(266) set Z_ 0.0 
$ns at 0.0 "$node_(266) off" 
$ns at 200.0 "$node_(266) on" 
$node_(267) set X_ 447 
$node_(267) set Y_ 558 
$node_(267) set Z_ 0.0 
$ns at 0.0 "$node_(267) off" 
$ns at 200.0 "$node_(267) on" 
$node_(268) set X_ 838 
$node_(268) set Y_ 128 
$node_(268) set Z_ 0.0 
$ns at 0.0 "$node_(268) off" 
$ns at 200.0 "$node_(268) on" 
$node_(269) set X_ 2045 
$node_(269) set Y_ 178 
$node_(269) set Z_ 0.0 
$ns at 0.0 "$node_(269) off" 
$ns at 200.0 "$node_(269) on" 
$node_(270) set X_ 2584 
$node_(270) set Y_ 465 
$node_(270) set Z_ 0.0 
$ns at 0.0 "$node_(270) off" 
$ns at 200.0 "$node_(270) on" 
$node_(271) set X_ 2635 
$node_(271) set Y_ 481 
$node_(271) set Z_ 0.0 
$ns at 0.0 "$node_(271) off" 
$ns at 200.0 "$node_(271) on" 
$node_(272) set X_ 2856 
$node_(272) set Y_ 318 
$node_(272) set Z_ 0.0 
$ns at 0.0 "$node_(272) off" 
$ns at 200.0 "$node_(272) on" 
$node_(273) set X_ 1522 
$node_(273) set Y_ 921 
$node_(273) set Z_ 0.0 
$ns at 0.0 "$node_(273) off" 
$ns at 200.0 "$node_(273) on" 
$node_(274) set X_ 2129 
$node_(274) set Y_ 918 
$node_(274) set Z_ 0.0 
$ns at 0.0 "$node_(274) off" 
$ns at 200.0 "$node_(274) on" 
$node_(275) set X_ 120 
$node_(275) set Y_ 195 
$node_(275) set Z_ 0.0 
$ns at 0.0 "$node_(275) off" 
$ns at 200.0 "$node_(275) on" 
$node_(276) set X_ 94 
$node_(276) set Y_ 378 
$node_(276) set Z_ 0.0 
$ns at 0.0 "$node_(276) off" 
$ns at 200.0 "$node_(276) on" 
$node_(277) set X_ 870 
$node_(277) set Y_ 910 
$node_(277) set Z_ 0.0 
$ns at 0.0 "$node_(277) off" 
$ns at 200.0 "$node_(277) on" 
$node_(278) set X_ 2285 
$node_(278) set Y_ 92 
$node_(278) set Z_ 0.0 
$ns at 0.0 "$node_(278) off" 
$ns at 200.0 "$node_(278) on" 
$node_(279) set X_ 1809 
$node_(279) set Y_ 454 
$node_(279) set Z_ 0.0 
$ns at 0.0 "$node_(279) off" 
$ns at 200.0 "$node_(279) on" 
$node_(280) set X_ 944 
$node_(280) set Y_ 939 
$node_(280) set Z_ 0.0 
$ns at 0.0 "$node_(280) off" 
$ns at 200.0 "$node_(280) on" 
$node_(281) set X_ 357 
$node_(281) set Y_ 383 
$node_(281) set Z_ 0.0 
$ns at 0.0 "$node_(281) off" 
$ns at 200.0 "$node_(281) on" 
$node_(282) set X_ 452 
$node_(282) set Y_ 691 
$node_(282) set Z_ 0.0 
$ns at 0.0 "$node_(282) off" 
$ns at 200.0 "$node_(282) on" 
$node_(283) set X_ 1292 
$node_(283) set Y_ 328 
$node_(283) set Z_ 0.0 
$ns at 0.0 "$node_(283) off" 
$ns at 200.0 "$node_(283) on" 
$node_(284) set X_ 2754 
$node_(284) set Y_ 391 
$node_(284) set Z_ 0.0 
$ns at 0.0 "$node_(284) off" 
$ns at 200.0 "$node_(284) on" 
$node_(285) set X_ 533 
$node_(285) set Y_ 783 
$node_(285) set Z_ 0.0 
$ns at 0.0 "$node_(285) off" 
$ns at 200.0 "$node_(285) on" 
$node_(286) set X_ 1108 
$node_(286) set Y_ 48 
$node_(286) set Z_ 0.0 
$ns at 0.0 "$node_(286) off" 
$ns at 200.0 "$node_(286) on" 
$node_(287) set X_ 2153 
$node_(287) set Y_ 86 
$node_(287) set Z_ 0.0 
$ns at 0.0 "$node_(287) off" 
$ns at 200.0 "$node_(287) on" 
$node_(288) set X_ 1033 
$node_(288) set Y_ 645 
$node_(288) set Z_ 0.0 
$ns at 0.0 "$node_(288) off" 
$ns at 200.0 "$node_(288) on" 
$node_(289) set X_ 149 
$node_(289) set Y_ 619 
$node_(289) set Z_ 0.0 
$ns at 0.0 "$node_(289) off" 
$ns at 200.0 "$node_(289) on" 
$node_(290) set X_ 635 
$node_(290) set Y_ 365 
$node_(290) set Z_ 0.0 
$ns at 0.0 "$node_(290) off" 
$ns at 200.0 "$node_(290) on" 
$node_(291) set X_ 1748 
$node_(291) set Y_ 511 
$node_(291) set Z_ 0.0 
$ns at 0.0 "$node_(291) off" 
$ns at 200.0 "$node_(291) on" 
$node_(292) set X_ 517 
$node_(292) set Y_ 913 
$node_(292) set Z_ 0.0 
$ns at 0.0 "$node_(292) off" 
$ns at 200.0 "$node_(292) on" 
$node_(293) set X_ 527 
$node_(293) set Y_ 124 
$node_(293) set Z_ 0.0 
$ns at 0.0 "$node_(293) off" 
$ns at 200.0 "$node_(293) on" 
$node_(294) set X_ 2196 
$node_(294) set Y_ 5 
$node_(294) set Z_ 0.0 
$ns at 0.0 "$node_(294) off" 
$ns at 200.0 "$node_(294) on" 
$node_(295) set X_ 369 
$node_(295) set Y_ 216 
$node_(295) set Z_ 0.0 
$ns at 0.0 "$node_(295) off" 
$ns at 200.0 "$node_(295) on" 
$node_(296) set X_ 1412 
$node_(296) set Y_ 403 
$node_(296) set Z_ 0.0 
$ns at 0.0 "$node_(296) off" 
$ns at 200.0 "$node_(296) on" 
$node_(297) set X_ 1174 
$node_(297) set Y_ 941 
$node_(297) set Z_ 0.0 
$ns at 0.0 "$node_(297) off" 
$ns at 200.0 "$node_(297) on" 
$node_(298) set X_ 2881 
$node_(298) set Y_ 371 
$node_(298) set Z_ 0.0 
$ns at 0.0 "$node_(298) off" 
$ns at 200.0 "$node_(298) on" 
$node_(299) set X_ 1434 
$node_(299) set Y_ 807 
$node_(299) set Z_ 0.0 
$ns at 0.0 "$node_(299) off" 
$ns at 200.0 "$node_(299) on" 
$node_(300) set X_ 929 
$node_(300) set Y_ 60 
$node_(300) set Z_ 0.0 
$ns at 0.0 "$node_(300) off" 
$ns at 300.0 "$node_(300) on" 
$node_(301) set X_ 2147 
$node_(301) set Y_ 275 
$node_(301) set Z_ 0.0 
$ns at 0.0 "$node_(301) off" 
$ns at 300.0 "$node_(301) on" 
$node_(302) set X_ 1077 
$node_(302) set Y_ 115 
$node_(302) set Z_ 0.0 
$ns at 0.0 "$node_(302) off" 
$ns at 300.0 "$node_(302) on" 
$node_(303) set X_ 2107 
$node_(303) set Y_ 953 
$node_(303) set Z_ 0.0 
$ns at 0.0 "$node_(303) off" 
$ns at 300.0 "$node_(303) on" 
$node_(304) set X_ 2926 
$node_(304) set Y_ 762 
$node_(304) set Z_ 0.0 
$ns at 0.0 "$node_(304) off" 
$ns at 300.0 "$node_(304) on" 
$node_(305) set X_ 2475 
$node_(305) set Y_ 226 
$node_(305) set Z_ 0.0 
$ns at 0.0 "$node_(305) off" 
$ns at 300.0 "$node_(305) on" 
$node_(306) set X_ 791 
$node_(306) set Y_ 726 
$node_(306) set Z_ 0.0 
$ns at 0.0 "$node_(306) off" 
$ns at 300.0 "$node_(306) on" 
$node_(307) set X_ 1509 
$node_(307) set Y_ 724 
$node_(307) set Z_ 0.0 
$ns at 0.0 "$node_(307) off" 
$ns at 300.0 "$node_(307) on" 
$node_(308) set X_ 2264 
$node_(308) set Y_ 606 
$node_(308) set Z_ 0.0 
$ns at 0.0 "$node_(308) off" 
$ns at 300.0 "$node_(308) on" 
$node_(309) set X_ 2629 
$node_(309) set Y_ 266 
$node_(309) set Z_ 0.0 
$ns at 0.0 "$node_(309) off" 
$ns at 300.0 "$node_(309) on" 
$node_(310) set X_ 2374 
$node_(310) set Y_ 743 
$node_(310) set Z_ 0.0 
$ns at 0.0 "$node_(310) off" 
$ns at 300.0 "$node_(310) on" 
$node_(311) set X_ 411 
$node_(311) set Y_ 753 
$node_(311) set Z_ 0.0 
$ns at 0.0 "$node_(311) off" 
$ns at 300.0 "$node_(311) on" 
$node_(312) set X_ 1219 
$node_(312) set Y_ 189 
$node_(312) set Z_ 0.0 
$ns at 0.0 "$node_(312) off" 
$ns at 300.0 "$node_(312) on" 
$node_(313) set X_ 1851 
$node_(313) set Y_ 53 
$node_(313) set Z_ 0.0 
$ns at 0.0 "$node_(313) off" 
$ns at 300.0 "$node_(313) on" 
$node_(314) set X_ 2879 
$node_(314) set Y_ 132 
$node_(314) set Z_ 0.0 
$ns at 0.0 "$node_(314) off" 
$ns at 300.0 "$node_(314) on" 
$node_(315) set X_ 71 
$node_(315) set Y_ 70 
$node_(315) set Z_ 0.0 
$ns at 0.0 "$node_(315) off" 
$ns at 300.0 "$node_(315) on" 
$node_(316) set X_ 2019 
$node_(316) set Y_ 8 
$node_(316) set Z_ 0.0 
$ns at 0.0 "$node_(316) off" 
$ns at 300.0 "$node_(316) on" 
$node_(317) set X_ 2849 
$node_(317) set Y_ 51 
$node_(317) set Z_ 0.0 
$ns at 0.0 "$node_(317) off" 
$ns at 300.0 "$node_(317) on" 
$node_(318) set X_ 3 
$node_(318) set Y_ 571 
$node_(318) set Z_ 0.0 
$ns at 0.0 "$node_(318) off" 
$ns at 300.0 "$node_(318) on" 
$node_(319) set X_ 2608 
$node_(319) set Y_ 682 
$node_(319) set Z_ 0.0 
$ns at 0.0 "$node_(319) off" 
$ns at 300.0 "$node_(319) on" 
$node_(320) set X_ 1368 
$node_(320) set Y_ 403 
$node_(320) set Z_ 0.0 
$ns at 0.0 "$node_(320) off" 
$ns at 300.0 "$node_(320) on" 
$node_(321) set X_ 1143 
$node_(321) set Y_ 655 
$node_(321) set Z_ 0.0 
$ns at 0.0 "$node_(321) off" 
$ns at 300.0 "$node_(321) on" 
$node_(322) set X_ 336 
$node_(322) set Y_ 697 
$node_(322) set Z_ 0.0 
$ns at 0.0 "$node_(322) off" 
$ns at 300.0 "$node_(322) on" 
$node_(323) set X_ 1075 
$node_(323) set Y_ 235 
$node_(323) set Z_ 0.0 
$ns at 0.0 "$node_(323) off" 
$ns at 300.0 "$node_(323) on" 
$node_(324) set X_ 1539 
$node_(324) set Y_ 660 
$node_(324) set Z_ 0.0 
$ns at 0.0 "$node_(324) off" 
$ns at 300.0 "$node_(324) on" 
$node_(325) set X_ 84 
$node_(325) set Y_ 784 
$node_(325) set Z_ 0.0 
$ns at 0.0 "$node_(325) off" 
$ns at 300.0 "$node_(325) on" 
$node_(326) set X_ 377 
$node_(326) set Y_ 552 
$node_(326) set Z_ 0.0 
$ns at 0.0 "$node_(326) off" 
$ns at 300.0 "$node_(326) on" 
$node_(327) set X_ 2125 
$node_(327) set Y_ 342 
$node_(327) set Z_ 0.0 
$ns at 0.0 "$node_(327) off" 
$ns at 300.0 "$node_(327) on" 
$node_(328) set X_ 2369 
$node_(328) set Y_ 190 
$node_(328) set Z_ 0.0 
$ns at 0.0 "$node_(328) off" 
$ns at 300.0 "$node_(328) on" 
$node_(329) set X_ 335 
$node_(329) set Y_ 149 
$node_(329) set Z_ 0.0 
$ns at 0.0 "$node_(329) off" 
$ns at 300.0 "$node_(329) on" 
$node_(330) set X_ 2538 
$node_(330) set Y_ 765 
$node_(330) set Z_ 0.0 
$ns at 0.0 "$node_(330) off" 
$ns at 300.0 "$node_(330) on" 
$node_(331) set X_ 1930 
$node_(331) set Y_ 400 
$node_(331) set Z_ 0.0 
$ns at 0.0 "$node_(331) off" 
$ns at 300.0 "$node_(331) on" 
$node_(332) set X_ 2258 
$node_(332) set Y_ 904 
$node_(332) set Z_ 0.0 
$ns at 0.0 "$node_(332) off" 
$ns at 300.0 "$node_(332) on" 
$node_(333) set X_ 324 
$node_(333) set Y_ 646 
$node_(333) set Z_ 0.0 
$ns at 0.0 "$node_(333) off" 
$ns at 300.0 "$node_(333) on" 
$node_(334) set X_ 94 
$node_(334) set Y_ 241 
$node_(334) set Z_ 0.0 
$ns at 0.0 "$node_(334) off" 
$ns at 300.0 "$node_(334) on" 
$node_(335) set X_ 1744 
$node_(335) set Y_ 986 
$node_(335) set Z_ 0.0 
$ns at 0.0 "$node_(335) off" 
$ns at 300.0 "$node_(335) on" 
$node_(336) set X_ 1004 
$node_(336) set Y_ 211 
$node_(336) set Z_ 0.0 
$ns at 0.0 "$node_(336) off" 
$ns at 300.0 "$node_(336) on" 
$node_(337) set X_ 2963 
$node_(337) set Y_ 589 
$node_(337) set Z_ 0.0 
$ns at 0.0 "$node_(337) off" 
$ns at 300.0 "$node_(337) on" 
$node_(338) set X_ 800 
$node_(338) set Y_ 361 
$node_(338) set Z_ 0.0 
$ns at 0.0 "$node_(338) off" 
$ns at 300.0 "$node_(338) on" 
$node_(339) set X_ 281 
$node_(339) set Y_ 168 
$node_(339) set Z_ 0.0 
$ns at 0.0 "$node_(339) off" 
$ns at 300.0 "$node_(339) on" 
$node_(340) set X_ 1063 
$node_(340) set Y_ 255 
$node_(340) set Z_ 0.0 
$ns at 0.0 "$node_(340) off" 
$ns at 300.0 "$node_(340) on" 
$node_(341) set X_ 649 
$node_(341) set Y_ 732 
$node_(341) set Z_ 0.0 
$ns at 0.0 "$node_(341) off" 
$ns at 300.0 "$node_(341) on" 
$node_(342) set X_ 634 
$node_(342) set Y_ 981 
$node_(342) set Z_ 0.0 
$ns at 0.0 "$node_(342) off" 
$ns at 300.0 "$node_(342) on" 
$node_(343) set X_ 2786 
$node_(343) set Y_ 297 
$node_(343) set Z_ 0.0 
$ns at 0.0 "$node_(343) off" 
$ns at 300.0 "$node_(343) on" 
$node_(344) set X_ 1581 
$node_(344) set Y_ 297 
$node_(344) set Z_ 0.0 
$ns at 0.0 "$node_(344) off" 
$ns at 300.0 "$node_(344) on" 
$node_(345) set X_ 1331 
$node_(345) set Y_ 303 
$node_(345) set Z_ 0.0 
$ns at 0.0 "$node_(345) off" 
$ns at 300.0 "$node_(345) on" 
$node_(346) set X_ 2883 
$node_(346) set Y_ 743 
$node_(346) set Z_ 0.0 
$ns at 0.0 "$node_(346) off" 
$ns at 300.0 "$node_(346) on" 
$node_(347) set X_ 476 
$node_(347) set Y_ 130 
$node_(347) set Z_ 0.0 
$ns at 0.0 "$node_(347) off" 
$ns at 300.0 "$node_(347) on" 
$node_(348) set X_ 1279 
$node_(348) set Y_ 390 
$node_(348) set Z_ 0.0 
$ns at 0.0 "$node_(348) off" 
$ns at 300.0 "$node_(348) on" 
$node_(349) set X_ 162 
$node_(349) set Y_ 479 
$node_(349) set Z_ 0.0 
$ns at 0.0 "$node_(349) off" 
$ns at 300.0 "$node_(349) on" 
$node_(350) set X_ 1541 
$node_(350) set Y_ 455 
$node_(350) set Z_ 0.0 
$ns at 0.0 "$node_(350) off" 
$ns at 300.0 "$node_(350) on" 
$node_(351) set X_ 732 
$node_(351) set Y_ 352 
$node_(351) set Z_ 0.0 
$ns at 0.0 "$node_(351) off" 
$ns at 300.0 "$node_(351) on" 
$node_(352) set X_ 39 
$node_(352) set Y_ 731 
$node_(352) set Z_ 0.0 
$ns at 0.0 "$node_(352) off" 
$ns at 300.0 "$node_(352) on" 
$node_(353) set X_ 32 
$node_(353) set Y_ 43 
$node_(353) set Z_ 0.0 
$ns at 0.0 "$node_(353) off" 
$ns at 300.0 "$node_(353) on" 
$node_(354) set X_ 1732 
$node_(354) set Y_ 582 
$node_(354) set Z_ 0.0 
$ns at 0.0 "$node_(354) off" 
$ns at 300.0 "$node_(354) on" 
$node_(355) set X_ 213 
$node_(355) set Y_ 843 
$node_(355) set Z_ 0.0 
$ns at 0.0 "$node_(355) off" 
$ns at 300.0 "$node_(355) on" 
$node_(356) set X_ 1774 
$node_(356) set Y_ 350 
$node_(356) set Z_ 0.0 
$ns at 0.0 "$node_(356) off" 
$ns at 300.0 "$node_(356) on" 
$node_(357) set X_ 1980 
$node_(357) set Y_ 149 
$node_(357) set Z_ 0.0 
$ns at 0.0 "$node_(357) off" 
$ns at 300.0 "$node_(357) on" 
$node_(358) set X_ 610 
$node_(358) set Y_ 99 
$node_(358) set Z_ 0.0 
$ns at 0.0 "$node_(358) off" 
$ns at 300.0 "$node_(358) on" 
$node_(359) set X_ 776 
$node_(359) set Y_ 255 
$node_(359) set Z_ 0.0 
$ns at 0.0 "$node_(359) off" 
$ns at 300.0 "$node_(359) on" 
$node_(360) set X_ 927 
$node_(360) set Y_ 16 
$node_(360) set Z_ 0.0 
$ns at 0.0 "$node_(360) off" 
$ns at 300.0 "$node_(360) on" 
$node_(361) set X_ 1290 
$node_(361) set Y_ 427 
$node_(361) set Z_ 0.0 
$ns at 0.0 "$node_(361) off" 
$ns at 300.0 "$node_(361) on" 
$node_(362) set X_ 2977 
$node_(362) set Y_ 237 
$node_(362) set Z_ 0.0 
$ns at 0.0 "$node_(362) off" 
$ns at 300.0 "$node_(362) on" 
$node_(363) set X_ 873 
$node_(363) set Y_ 748 
$node_(363) set Z_ 0.0 
$ns at 0.0 "$node_(363) off" 
$ns at 300.0 "$node_(363) on" 
$node_(364) set X_ 1686 
$node_(364) set Y_ 505 
$node_(364) set Z_ 0.0 
$ns at 0.0 "$node_(364) off" 
$ns at 300.0 "$node_(364) on" 
$node_(365) set X_ 1785 
$node_(365) set Y_ 863 
$node_(365) set Z_ 0.0 
$ns at 0.0 "$node_(365) off" 
$ns at 300.0 "$node_(365) on" 
$node_(366) set X_ 2560 
$node_(366) set Y_ 881 
$node_(366) set Z_ 0.0 
$ns at 0.0 "$node_(366) off" 
$ns at 300.0 "$node_(366) on" 
$node_(367) set X_ 812 
$node_(367) set Y_ 951 
$node_(367) set Z_ 0.0 
$ns at 0.0 "$node_(367) off" 
$ns at 300.0 "$node_(367) on" 
$node_(368) set X_ 2754 
$node_(368) set Y_ 642 
$node_(368) set Z_ 0.0 
$ns at 0.0 "$node_(368) off" 
$ns at 300.0 "$node_(368) on" 
$node_(369) set X_ 1595 
$node_(369) set Y_ 186 
$node_(369) set Z_ 0.0 
$ns at 0.0 "$node_(369) off" 
$ns at 300.0 "$node_(369) on" 
$node_(370) set X_ 1670 
$node_(370) set Y_ 655 
$node_(370) set Z_ 0.0 
$ns at 0.0 "$node_(370) off" 
$ns at 300.0 "$node_(370) on" 
$node_(371) set X_ 1039 
$node_(371) set Y_ 501 
$node_(371) set Z_ 0.0 
$ns at 0.0 "$node_(371) off" 
$ns at 300.0 "$node_(371) on" 
$node_(372) set X_ 1270 
$node_(372) set Y_ 736 
$node_(372) set Z_ 0.0 
$ns at 0.0 "$node_(372) off" 
$ns at 300.0 "$node_(372) on" 
$node_(373) set X_ 433 
$node_(373) set Y_ 686 
$node_(373) set Z_ 0.0 
$ns at 0.0 "$node_(373) off" 
$ns at 300.0 "$node_(373) on" 
$node_(374) set X_ 1716 
$node_(374) set Y_ 943 
$node_(374) set Z_ 0.0 
$ns at 0.0 "$node_(374) off" 
$ns at 300.0 "$node_(374) on" 
$node_(375) set X_ 355 
$node_(375) set Y_ 712 
$node_(375) set Z_ 0.0 
$ns at 0.0 "$node_(375) off" 
$ns at 300.0 "$node_(375) on" 
$node_(376) set X_ 1210 
$node_(376) set Y_ 327 
$node_(376) set Z_ 0.0 
$ns at 0.0 "$node_(376) off" 
$ns at 300.0 "$node_(376) on" 
$node_(377) set X_ 1156 
$node_(377) set Y_ 711 
$node_(377) set Z_ 0.0 
$ns at 0.0 "$node_(377) off" 
$ns at 300.0 "$node_(377) on" 
$node_(378) set X_ 2771 
$node_(378) set Y_ 385 
$node_(378) set Z_ 0.0 
$ns at 0.0 "$node_(378) off" 
$ns at 300.0 "$node_(378) on" 
$node_(379) set X_ 1694 
$node_(379) set Y_ 240 
$node_(379) set Z_ 0.0 
$ns at 0.0 "$node_(379) off" 
$ns at 300.0 "$node_(379) on" 
$node_(380) set X_ 369 
$node_(380) set Y_ 367 
$node_(380) set Z_ 0.0 
$ns at 0.0 "$node_(380) off" 
$ns at 300.0 "$node_(380) on" 
$node_(381) set X_ 124 
$node_(381) set Y_ 260 
$node_(381) set Z_ 0.0 
$ns at 0.0 "$node_(381) off" 
$ns at 300.0 "$node_(381) on" 
$node_(382) set X_ 175 
$node_(382) set Y_ 605 
$node_(382) set Z_ 0.0 
$ns at 0.0 "$node_(382) off" 
$ns at 300.0 "$node_(382) on" 
$node_(383) set X_ 895 
$node_(383) set Y_ 800 
$node_(383) set Z_ 0.0 
$ns at 0.0 "$node_(383) off" 
$ns at 300.0 "$node_(383) on" 
$node_(384) set X_ 2758 
$node_(384) set Y_ 254 
$node_(384) set Z_ 0.0 
$ns at 0.0 "$node_(384) off" 
$ns at 300.0 "$node_(384) on" 
$node_(385) set X_ 662 
$node_(385) set Y_ 404 
$node_(385) set Z_ 0.0 
$ns at 0.0 "$node_(385) off" 
$ns at 300.0 "$node_(385) on" 
$node_(386) set X_ 2876 
$node_(386) set Y_ 196 
$node_(386) set Z_ 0.0 
$ns at 0.0 "$node_(386) off" 
$ns at 300.0 "$node_(386) on" 
$node_(387) set X_ 601 
$node_(387) set Y_ 274 
$node_(387) set Z_ 0.0 
$ns at 0.0 "$node_(387) off" 
$ns at 300.0 "$node_(387) on" 
$node_(388) set X_ 2003 
$node_(388) set Y_ 336 
$node_(388) set Z_ 0.0 
$ns at 0.0 "$node_(388) off" 
$ns at 300.0 "$node_(388) on" 
$node_(389) set X_ 623 
$node_(389) set Y_ 490 
$node_(389) set Z_ 0.0 
$ns at 0.0 "$node_(389) off" 
$ns at 300.0 "$node_(389) on" 
$node_(390) set X_ 2975 
$node_(390) set Y_ 232 
$node_(390) set Z_ 0.0 
$ns at 0.0 "$node_(390) off" 
$ns at 300.0 "$node_(390) on" 
$node_(391) set X_ 2186 
$node_(391) set Y_ 807 
$node_(391) set Z_ 0.0 
$ns at 0.0 "$node_(391) off" 
$ns at 300.0 "$node_(391) on" 
$node_(392) set X_ 2096 
$node_(392) set Y_ 801 
$node_(392) set Z_ 0.0 
$ns at 0.0 "$node_(392) off" 
$ns at 300.0 "$node_(392) on" 
$node_(393) set X_ 1850 
$node_(393) set Y_ 320 
$node_(393) set Z_ 0.0 
$ns at 0.0 "$node_(393) off" 
$ns at 300.0 "$node_(393) on" 
$node_(394) set X_ 701 
$node_(394) set Y_ 818 
$node_(394) set Z_ 0.0 
$ns at 0.0 "$node_(394) off" 
$ns at 300.0 "$node_(394) on" 
$node_(395) set X_ 1378 
$node_(395) set Y_ 694 
$node_(395) set Z_ 0.0 
$ns at 0.0 "$node_(395) off" 
$ns at 300.0 "$node_(395) on" 
$node_(396) set X_ 1578 
$node_(396) set Y_ 94 
$node_(396) set Z_ 0.0 
$ns at 0.0 "$node_(396) off" 
$ns at 300.0 "$node_(396) on" 
$node_(397) set X_ 52 
$node_(397) set Y_ 782 
$node_(397) set Z_ 0.0 
$ns at 0.0 "$node_(397) off" 
$ns at 300.0 "$node_(397) on" 
$node_(398) set X_ 760 
$node_(398) set Y_ 466 
$node_(398) set Z_ 0.0 
$ns at 0.0 "$node_(398) off" 
$ns at 300.0 "$node_(398) on" 
$node_(399) set X_ 1965 
$node_(399) set Y_ 170 
$node_(399) set Z_ 0.0 
$ns at 0.0 "$node_(399) off" 
$ns at 300.0 "$node_(399) on" 
$node_(400) set X_ 2995 
$node_(400) set Y_ 243 
$node_(400) set Z_ 0.0 
$ns at 0.0 "$node_(400) off" 
$ns at 400.0 "$node_(400) on" 
$node_(401) set X_ 1380 
$node_(401) set Y_ 622 
$node_(401) set Z_ 0.0 
$ns at 0.0 "$node_(401) off" 
$ns at 400.0 "$node_(401) on" 
$node_(402) set X_ 1801 
$node_(402) set Y_ 291 
$node_(402) set Z_ 0.0 
$ns at 0.0 "$node_(402) off" 
$ns at 400.0 "$node_(402) on" 
$node_(403) set X_ 2742 
$node_(403) set Y_ 415 
$node_(403) set Z_ 0.0 
$ns at 0.0 "$node_(403) off" 
$ns at 400.0 "$node_(403) on" 
$node_(404) set X_ 2224 
$node_(404) set Y_ 756 
$node_(404) set Z_ 0.0 
$ns at 0.0 "$node_(404) off" 
$ns at 400.0 "$node_(404) on" 
$node_(405) set X_ 1725 
$node_(405) set Y_ 329 
$node_(405) set Z_ 0.0 
$ns at 0.0 "$node_(405) off" 
$ns at 400.0 "$node_(405) on" 
$node_(406) set X_ 1435 
$node_(406) set Y_ 322 
$node_(406) set Z_ 0.0 
$ns at 0.0 "$node_(406) off" 
$ns at 400.0 "$node_(406) on" 
$node_(407) set X_ 608 
$node_(407) set Y_ 362 
$node_(407) set Z_ 0.0 
$ns at 0.0 "$node_(407) off" 
$ns at 400.0 "$node_(407) on" 
$node_(408) set X_ 2999 
$node_(408) set Y_ 965 
$node_(408) set Z_ 0.0 
$ns at 0.0 "$node_(408) off" 
$ns at 400.0 "$node_(408) on" 
$node_(409) set X_ 519 
$node_(409) set Y_ 329 
$node_(409) set Z_ 0.0 
$ns at 0.0 "$node_(409) off" 
$ns at 400.0 "$node_(409) on" 
$node_(410) set X_ 1043 
$node_(410) set Y_ 427 
$node_(410) set Z_ 0.0 
$ns at 0.0 "$node_(410) off" 
$ns at 400.0 "$node_(410) on" 
$node_(411) set X_ 2446 
$node_(411) set Y_ 143 
$node_(411) set Z_ 0.0 
$ns at 0.0 "$node_(411) off" 
$ns at 400.0 "$node_(411) on" 
$node_(412) set X_ 739 
$node_(412) set Y_ 981 
$node_(412) set Z_ 0.0 
$ns at 0.0 "$node_(412) off" 
$ns at 400.0 "$node_(412) on" 
$node_(413) set X_ 1558 
$node_(413) set Y_ 950 
$node_(413) set Z_ 0.0 
$ns at 0.0 "$node_(413) off" 
$ns at 400.0 "$node_(413) on" 
$node_(414) set X_ 1326 
$node_(414) set Y_ 641 
$node_(414) set Z_ 0.0 
$ns at 0.0 "$node_(414) off" 
$ns at 400.0 "$node_(414) on" 
$node_(415) set X_ 219 
$node_(415) set Y_ 254 
$node_(415) set Z_ 0.0 
$ns at 0.0 "$node_(415) off" 
$ns at 400.0 "$node_(415) on" 
$node_(416) set X_ 504 
$node_(416) set Y_ 641 
$node_(416) set Z_ 0.0 
$ns at 0.0 "$node_(416) off" 
$ns at 400.0 "$node_(416) on" 
$node_(417) set X_ 2140 
$node_(417) set Y_ 867 
$node_(417) set Z_ 0.0 
$ns at 0.0 "$node_(417) off" 
$ns at 400.0 "$node_(417) on" 
$node_(418) set X_ 1319 
$node_(418) set Y_ 890 
$node_(418) set Z_ 0.0 
$ns at 0.0 "$node_(418) off" 
$ns at 400.0 "$node_(418) on" 
$node_(419) set X_ 2397 
$node_(419) set Y_ 766 
$node_(419) set Z_ 0.0 
$ns at 0.0 "$node_(419) off" 
$ns at 400.0 "$node_(419) on" 
$node_(420) set X_ 2675 
$node_(420) set Y_ 92 
$node_(420) set Z_ 0.0 
$ns at 0.0 "$node_(420) off" 
$ns at 400.0 "$node_(420) on" 
$node_(421) set X_ 2526 
$node_(421) set Y_ 977 
$node_(421) set Z_ 0.0 
$ns at 0.0 "$node_(421) off" 
$ns at 400.0 "$node_(421) on" 
$node_(422) set X_ 2329 
$node_(422) set Y_ 416 
$node_(422) set Z_ 0.0 
$ns at 0.0 "$node_(422) off" 
$ns at 400.0 "$node_(422) on" 
$node_(423) set X_ 2653 
$node_(423) set Y_ 165 
$node_(423) set Z_ 0.0 
$ns at 0.0 "$node_(423) off" 
$ns at 400.0 "$node_(423) on" 
$node_(424) set X_ 1706 
$node_(424) set Y_ 917 
$node_(424) set Z_ 0.0 
$ns at 0.0 "$node_(424) off" 
$ns at 400.0 "$node_(424) on" 
$node_(425) set X_ 2520 
$node_(425) set Y_ 921 
$node_(425) set Z_ 0.0 
$ns at 0.0 "$node_(425) off" 
$ns at 400.0 "$node_(425) on" 
$node_(426) set X_ 1012 
$node_(426) set Y_ 384 
$node_(426) set Z_ 0.0 
$ns at 0.0 "$node_(426) off" 
$ns at 400.0 "$node_(426) on" 
$node_(427) set X_ 1455 
$node_(427) set Y_ 669 
$node_(427) set Z_ 0.0 
$ns at 0.0 "$node_(427) off" 
$ns at 400.0 "$node_(427) on" 
$node_(428) set X_ 2024 
$node_(428) set Y_ 934 
$node_(428) set Z_ 0.0 
$ns at 0.0 "$node_(428) off" 
$ns at 400.0 "$node_(428) on" 
$node_(429) set X_ 681 
$node_(429) set Y_ 697 
$node_(429) set Z_ 0.0 
$ns at 0.0 "$node_(429) off" 
$ns at 400.0 "$node_(429) on" 
$node_(430) set X_ 1559 
$node_(430) set Y_ 473 
$node_(430) set Z_ 0.0 
$ns at 0.0 "$node_(430) off" 
$ns at 400.0 "$node_(430) on" 
$node_(431) set X_ 1970 
$node_(431) set Y_ 72 
$node_(431) set Z_ 0.0 
$ns at 0.0 "$node_(431) off" 
$ns at 400.0 "$node_(431) on" 
$node_(432) set X_ 1921 
$node_(432) set Y_ 75 
$node_(432) set Z_ 0.0 
$ns at 0.0 "$node_(432) off" 
$ns at 400.0 "$node_(432) on" 
$node_(433) set X_ 452 
$node_(433) set Y_ 88 
$node_(433) set Z_ 0.0 
$ns at 0.0 "$node_(433) off" 
$ns at 400.0 "$node_(433) on" 
$node_(434) set X_ 2699 
$node_(434) set Y_ 454 
$node_(434) set Z_ 0.0 
$ns at 0.0 "$node_(434) off" 
$ns at 400.0 "$node_(434) on" 
$node_(435) set X_ 1423 
$node_(435) set Y_ 482 
$node_(435) set Z_ 0.0 
$ns at 0.0 "$node_(435) off" 
$ns at 400.0 "$node_(435) on" 
$node_(436) set X_ 2038 
$node_(436) set Y_ 975 
$node_(436) set Z_ 0.0 
$ns at 0.0 "$node_(436) off" 
$ns at 400.0 "$node_(436) on" 
$node_(437) set X_ 1233 
$node_(437) set Y_ 841 
$node_(437) set Z_ 0.0 
$ns at 0.0 "$node_(437) off" 
$ns at 400.0 "$node_(437) on" 
$node_(438) set X_ 2991 
$node_(438) set Y_ 22 
$node_(438) set Z_ 0.0 
$ns at 0.0 "$node_(438) off" 
$ns at 400.0 "$node_(438) on" 
$node_(439) set X_ 2825 
$node_(439) set Y_ 509 
$node_(439) set Z_ 0.0 
$ns at 0.0 "$node_(439) off" 
$ns at 400.0 "$node_(439) on" 
$node_(440) set X_ 2768 
$node_(440) set Y_ 186 
$node_(440) set Z_ 0.0 
$ns at 0.0 "$node_(440) off" 
$ns at 400.0 "$node_(440) on" 
$node_(441) set X_ 1167 
$node_(441) set Y_ 829 
$node_(441) set Z_ 0.0 
$ns at 0.0 "$node_(441) off" 
$ns at 400.0 "$node_(441) on" 
$node_(442) set X_ 2611 
$node_(442) set Y_ 410 
$node_(442) set Z_ 0.0 
$ns at 0.0 "$node_(442) off" 
$ns at 400.0 "$node_(442) on" 
$node_(443) set X_ 711 
$node_(443) set Y_ 747 
$node_(443) set Z_ 0.0 
$ns at 0.0 "$node_(443) off" 
$ns at 400.0 "$node_(443) on" 
$node_(444) set X_ 670 
$node_(444) set Y_ 138 
$node_(444) set Z_ 0.0 
$ns at 0.0 "$node_(444) off" 
$ns at 400.0 "$node_(444) on" 
$node_(445) set X_ 183 
$node_(445) set Y_ 625 
$node_(445) set Z_ 0.0 
$ns at 0.0 "$node_(445) off" 
$ns at 400.0 "$node_(445) on" 
$node_(446) set X_ 1606 
$node_(446) set Y_ 561 
$node_(446) set Z_ 0.0 
$ns at 0.0 "$node_(446) off" 
$ns at 400.0 "$node_(446) on" 
$node_(447) set X_ 292 
$node_(447) set Y_ 633 
$node_(447) set Z_ 0.0 
$ns at 0.0 "$node_(447) off" 
$ns at 400.0 "$node_(447) on" 
$node_(448) set X_ 739 
$node_(448) set Y_ 256 
$node_(448) set Z_ 0.0 
$ns at 0.0 "$node_(448) off" 
$ns at 400.0 "$node_(448) on" 
$node_(449) set X_ 1556 
$node_(449) set Y_ 223 
$node_(449) set Z_ 0.0 
$ns at 0.0 "$node_(449) off" 
$ns at 400.0 "$node_(449) on" 
$node_(450) set X_ 1329 
$node_(450) set Y_ 849 
$node_(450) set Z_ 0.0 
$ns at 0.0 "$node_(450) off" 
$ns at 400.0 "$node_(450) on" 
$node_(451) set X_ 1189 
$node_(451) set Y_ 10 
$node_(451) set Z_ 0.0 
$ns at 0.0 "$node_(451) off" 
$ns at 400.0 "$node_(451) on" 
$node_(452) set X_ 2125 
$node_(452) set Y_ 876 
$node_(452) set Z_ 0.0 
$ns at 0.0 "$node_(452) off" 
$ns at 400.0 "$node_(452) on" 
$node_(453) set X_ 2022 
$node_(453) set Y_ 842 
$node_(453) set Z_ 0.0 
$ns at 0.0 "$node_(453) off" 
$ns at 400.0 "$node_(453) on" 
$node_(454) set X_ 1519 
$node_(454) set Y_ 658 
$node_(454) set Z_ 0.0 
$ns at 0.0 "$node_(454) off" 
$ns at 400.0 "$node_(454) on" 
$node_(455) set X_ 620 
$node_(455) set Y_ 974 
$node_(455) set Z_ 0.0 
$ns at 0.0 "$node_(455) off" 
$ns at 400.0 "$node_(455) on" 
$node_(456) set X_ 2624 
$node_(456) set Y_ 851 
$node_(456) set Z_ 0.0 
$ns at 0.0 "$node_(456) off" 
$ns at 400.0 "$node_(456) on" 
$node_(457) set X_ 217 
$node_(457) set Y_ 25 
$node_(457) set Z_ 0.0 
$ns at 0.0 "$node_(457) off" 
$ns at 400.0 "$node_(457) on" 
$node_(458) set X_ 1234 
$node_(458) set Y_ 303 
$node_(458) set Z_ 0.0 
$ns at 0.0 "$node_(458) off" 
$ns at 400.0 "$node_(458) on" 
$node_(459) set X_ 2726 
$node_(459) set Y_ 847 
$node_(459) set Z_ 0.0 
$ns at 0.0 "$node_(459) off" 
$ns at 400.0 "$node_(459) on" 
$node_(460) set X_ 2049 
$node_(460) set Y_ 987 
$node_(460) set Z_ 0.0 
$ns at 0.0 "$node_(460) off" 
$ns at 400.0 "$node_(460) on" 
$node_(461) set X_ 2981 
$node_(461) set Y_ 505 
$node_(461) set Z_ 0.0 
$ns at 0.0 "$node_(461) off" 
$ns at 400.0 "$node_(461) on" 
$node_(462) set X_ 618 
$node_(462) set Y_ 85 
$node_(462) set Z_ 0.0 
$ns at 0.0 "$node_(462) off" 
$ns at 400.0 "$node_(462) on" 
$node_(463) set X_ 420 
$node_(463) set Y_ 349 
$node_(463) set Z_ 0.0 
$ns at 0.0 "$node_(463) off" 
$ns at 400.0 "$node_(463) on" 
$node_(464) set X_ 316 
$node_(464) set Y_ 721 
$node_(464) set Z_ 0.0 
$ns at 0.0 "$node_(464) off" 
$ns at 400.0 "$node_(464) on" 
$node_(465) set X_ 789 
$node_(465) set Y_ 517 
$node_(465) set Z_ 0.0 
$ns at 0.0 "$node_(465) off" 
$ns at 400.0 "$node_(465) on" 
$node_(466) set X_ 1196 
$node_(466) set Y_ 492 
$node_(466) set Z_ 0.0 
$ns at 0.0 "$node_(466) off" 
$ns at 400.0 "$node_(466) on" 
$node_(467) set X_ 1907 
$node_(467) set Y_ 306 
$node_(467) set Z_ 0.0 
$ns at 0.0 "$node_(467) off" 
$ns at 400.0 "$node_(467) on" 
$node_(468) set X_ 1823 
$node_(468) set Y_ 660 
$node_(468) set Z_ 0.0 
$ns at 0.0 "$node_(468) off" 
$ns at 400.0 "$node_(468) on" 
$node_(469) set X_ 1345 
$node_(469) set Y_ 542 
$node_(469) set Z_ 0.0 
$ns at 0.0 "$node_(469) off" 
$ns at 400.0 "$node_(469) on" 
$node_(470) set X_ 186 
$node_(470) set Y_ 816 
$node_(470) set Z_ 0.0 
$ns at 0.0 "$node_(470) off" 
$ns at 400.0 "$node_(470) on" 
$node_(471) set X_ 795 
$node_(471) set Y_ 467 
$node_(471) set Z_ 0.0 
$ns at 0.0 "$node_(471) off" 
$ns at 400.0 "$node_(471) on" 
$node_(472) set X_ 2486 
$node_(472) set Y_ 902 
$node_(472) set Z_ 0.0 
$ns at 0.0 "$node_(472) off" 
$ns at 400.0 "$node_(472) on" 
$node_(473) set X_ 1116 
$node_(473) set Y_ 667 
$node_(473) set Z_ 0.0 
$ns at 0.0 "$node_(473) off" 
$ns at 400.0 "$node_(473) on" 
$node_(474) set X_ 2016 
$node_(474) set Y_ 699 
$node_(474) set Z_ 0.0 
$ns at 0.0 "$node_(474) off" 
$ns at 400.0 "$node_(474) on" 
$node_(475) set X_ 2435 
$node_(475) set Y_ 281 
$node_(475) set Z_ 0.0 
$ns at 0.0 "$node_(475) off" 
$ns at 400.0 "$node_(475) on" 
$node_(476) set X_ 2490 
$node_(476) set Y_ 265 
$node_(476) set Z_ 0.0 
$ns at 0.0 "$node_(476) off" 
$ns at 400.0 "$node_(476) on" 
$node_(477) set X_ 325 
$node_(477) set Y_ 37 
$node_(477) set Z_ 0.0 
$ns at 0.0 "$node_(477) off" 
$ns at 400.0 "$node_(477) on" 
$node_(478) set X_ 2032 
$node_(478) set Y_ 395 
$node_(478) set Z_ 0.0 
$ns at 0.0 "$node_(478) off" 
$ns at 400.0 "$node_(478) on" 
$node_(479) set X_ 893 
$node_(479) set Y_ 694 
$node_(479) set Z_ 0.0 
$ns at 0.0 "$node_(479) off" 
$ns at 400.0 "$node_(479) on" 
$node_(480) set X_ 1627 
$node_(480) set Y_ 818 
$node_(480) set Z_ 0.0 
$ns at 0.0 "$node_(480) off" 
$ns at 400.0 "$node_(480) on" 
$node_(481) set X_ 2702 
$node_(481) set Y_ 87 
$node_(481) set Z_ 0.0 
$ns at 0.0 "$node_(481) off" 
$ns at 400.0 "$node_(481) on" 
$node_(482) set X_ 107 
$node_(482) set Y_ 747 
$node_(482) set Z_ 0.0 
$ns at 0.0 "$node_(482) off" 
$ns at 400.0 "$node_(482) on" 
$node_(483) set X_ 2719 
$node_(483) set Y_ 311 
$node_(483) set Z_ 0.0 
$ns at 0.0 "$node_(483) off" 
$ns at 400.0 "$node_(483) on" 
$node_(484) set X_ 792 
$node_(484) set Y_ 381 
$node_(484) set Z_ 0.0 
$ns at 0.0 "$node_(484) off" 
$ns at 400.0 "$node_(484) on" 
$node_(485) set X_ 1985 
$node_(485) set Y_ 528 
$node_(485) set Z_ 0.0 
$ns at 0.0 "$node_(485) off" 
$ns at 400.0 "$node_(485) on" 
$node_(486) set X_ 606 
$node_(486) set Y_ 162 
$node_(486) set Z_ 0.0 
$ns at 0.0 "$node_(486) off" 
$ns at 400.0 "$node_(486) on" 
$node_(487) set X_ 2398 
$node_(487) set Y_ 506 
$node_(487) set Z_ 0.0 
$ns at 0.0 "$node_(487) off" 
$ns at 400.0 "$node_(487) on" 
$node_(488) set X_ 972 
$node_(488) set Y_ 857 
$node_(488) set Z_ 0.0 
$ns at 0.0 "$node_(488) off" 
$ns at 400.0 "$node_(488) on" 
$node_(489) set X_ 2987 
$node_(489) set Y_ 287 
$node_(489) set Z_ 0.0 
$ns at 0.0 "$node_(489) off" 
$ns at 400.0 "$node_(489) on" 
$node_(490) set X_ 931 
$node_(490) set Y_ 99 
$node_(490) set Z_ 0.0 
$ns at 0.0 "$node_(490) off" 
$ns at 400.0 "$node_(490) on" 
$node_(491) set X_ 1146 
$node_(491) set Y_ 302 
$node_(491) set Z_ 0.0 
$ns at 0.0 "$node_(491) off" 
$ns at 400.0 "$node_(491) on" 
$node_(492) set X_ 841 
$node_(492) set Y_ 564 
$node_(492) set Z_ 0.0 
$ns at 0.0 "$node_(492) off" 
$ns at 400.0 "$node_(492) on" 
$node_(493) set X_ 2729 
$node_(493) set Y_ 852 
$node_(493) set Z_ 0.0 
$ns at 0.0 "$node_(493) off" 
$ns at 400.0 "$node_(493) on" 
$node_(494) set X_ 1616 
$node_(494) set Y_ 842 
$node_(494) set Z_ 0.0 
$ns at 0.0 "$node_(494) off" 
$ns at 400.0 "$node_(494) on" 
$node_(495) set X_ 2456 
$node_(495) set Y_ 114 
$node_(495) set Z_ 0.0 
$ns at 0.0 "$node_(495) off" 
$ns at 400.0 "$node_(495) on" 
$node_(496) set X_ 777 
$node_(496) set Y_ 950 
$node_(496) set Z_ 0.0 
$ns at 0.0 "$node_(496) off" 
$ns at 400.0 "$node_(496) on" 
$node_(497) set X_ 1926 
$node_(497) set Y_ 740 
$node_(497) set Z_ 0.0 
$ns at 0.0 "$node_(497) off" 
$ns at 400.0 "$node_(497) on" 
$node_(498) set X_ 2668 
$node_(498) set Y_ 568 
$node_(498) set Z_ 0.0 
$ns at 0.0 "$node_(498) off" 
$ns at 400.0 "$node_(498) on" 
$node_(499) set X_ 2532 
$node_(499) set Y_ 678 
$node_(499) set Z_ 0.0 
$ns at 0.0 "$node_(499) off" 
$ns at 400.0 "$node_(499) on" 
$node_(500) set X_ 902 
$node_(500) set Y_ 343 
$node_(500) set Z_ 0.0 
$ns at 0.0 "$node_(500) off" 
$ns at 500.0 "$node_(500) on" 
$node_(501) set X_ 853 
$node_(501) set Y_ 41 
$node_(501) set Z_ 0.0 
$ns at 0.0 "$node_(501) off" 
$ns at 500.0 "$node_(501) on" 
$node_(502) set X_ 2643 
$node_(502) set Y_ 1 
$node_(502) set Z_ 0.0 
$ns at 0.0 "$node_(502) off" 
$ns at 500.0 "$node_(502) on" 
$node_(503) set X_ 533 
$node_(503) set Y_ 759 
$node_(503) set Z_ 0.0 
$ns at 0.0 "$node_(503) off" 
$ns at 500.0 "$node_(503) on" 
$node_(504) set X_ 2486 
$node_(504) set Y_ 624 
$node_(504) set Z_ 0.0 
$ns at 0.0 "$node_(504) off" 
$ns at 500.0 "$node_(504) on" 
$node_(505) set X_ 374 
$node_(505) set Y_ 236 
$node_(505) set Z_ 0.0 
$ns at 0.0 "$node_(505) off" 
$ns at 500.0 "$node_(505) on" 
$node_(506) set X_ 2647 
$node_(506) set Y_ 139 
$node_(506) set Z_ 0.0 
$ns at 0.0 "$node_(506) off" 
$ns at 500.0 "$node_(506) on" 
$node_(507) set X_ 259 
$node_(507) set Y_ 454 
$node_(507) set Z_ 0.0 
$ns at 0.0 "$node_(507) off" 
$ns at 500.0 "$node_(507) on" 
$node_(508) set X_ 1798 
$node_(508) set Y_ 969 
$node_(508) set Z_ 0.0 
$ns at 0.0 "$node_(508) off" 
$ns at 500.0 "$node_(508) on" 
$node_(509) set X_ 2645 
$node_(509) set Y_ 769 
$node_(509) set Z_ 0.0 
$ns at 0.0 "$node_(509) off" 
$ns at 500.0 "$node_(509) on" 
$node_(510) set X_ 249 
$node_(510) set Y_ 861 
$node_(510) set Z_ 0.0 
$ns at 0.0 "$node_(510) off" 
$ns at 500.0 "$node_(510) on" 
$node_(511) set X_ 2704 
$node_(511) set Y_ 191 
$node_(511) set Z_ 0.0 
$ns at 0.0 "$node_(511) off" 
$ns at 500.0 "$node_(511) on" 
$node_(512) set X_ 2253 
$node_(512) set Y_ 58 
$node_(512) set Z_ 0.0 
$ns at 0.0 "$node_(512) off" 
$ns at 500.0 "$node_(512) on" 
$node_(513) set X_ 788 
$node_(513) set Y_ 45 
$node_(513) set Z_ 0.0 
$ns at 0.0 "$node_(513) off" 
$ns at 500.0 "$node_(513) on" 
$node_(514) set X_ 1008 
$node_(514) set Y_ 401 
$node_(514) set Z_ 0.0 
$ns at 0.0 "$node_(514) off" 
$ns at 500.0 "$node_(514) on" 
$node_(515) set X_ 1601 
$node_(515) set Y_ 740 
$node_(515) set Z_ 0.0 
$ns at 0.0 "$node_(515) off" 
$ns at 500.0 "$node_(515) on" 
$node_(516) set X_ 2437 
$node_(516) set Y_ 392 
$node_(516) set Z_ 0.0 
$ns at 0.0 "$node_(516) off" 
$ns at 500.0 "$node_(516) on" 
$node_(517) set X_ 1550 
$node_(517) set Y_ 852 
$node_(517) set Z_ 0.0 
$ns at 0.0 "$node_(517) off" 
$ns at 500.0 "$node_(517) on" 
$node_(518) set X_ 1079 
$node_(518) set Y_ 981 
$node_(518) set Z_ 0.0 
$ns at 0.0 "$node_(518) off" 
$ns at 500.0 "$node_(518) on" 
$node_(519) set X_ 885 
$node_(519) set Y_ 824 
$node_(519) set Z_ 0.0 
$ns at 0.0 "$node_(519) off" 
$ns at 500.0 "$node_(519) on" 
$node_(520) set X_ 2350 
$node_(520) set Y_ 615 
$node_(520) set Z_ 0.0 
$ns at 0.0 "$node_(520) off" 
$ns at 500.0 "$node_(520) on" 
$node_(521) set X_ 2729 
$node_(521) set Y_ 377 
$node_(521) set Z_ 0.0 
$ns at 0.0 "$node_(521) off" 
$ns at 500.0 "$node_(521) on" 
$node_(522) set X_ 123 
$node_(522) set Y_ 106 
$node_(522) set Z_ 0.0 
$ns at 0.0 "$node_(522) off" 
$ns at 500.0 "$node_(522) on" 
$node_(523) set X_ 1721 
$node_(523) set Y_ 167 
$node_(523) set Z_ 0.0 
$ns at 0.0 "$node_(523) off" 
$ns at 500.0 "$node_(523) on" 
$node_(524) set X_ 1965 
$node_(524) set Y_ 981 
$node_(524) set Z_ 0.0 
$ns at 0.0 "$node_(524) off" 
$ns at 500.0 "$node_(524) on" 
$node_(525) set X_ 894 
$node_(525) set Y_ 297 
$node_(525) set Z_ 0.0 
$ns at 0.0 "$node_(525) off" 
$ns at 500.0 "$node_(525) on" 
$node_(526) set X_ 2466 
$node_(526) set Y_ 303 
$node_(526) set Z_ 0.0 
$ns at 0.0 "$node_(526) off" 
$ns at 500.0 "$node_(526) on" 
$node_(527) set X_ 483 
$node_(527) set Y_ 54 
$node_(527) set Z_ 0.0 
$ns at 0.0 "$node_(527) off" 
$ns at 500.0 "$node_(527) on" 
$node_(528) set X_ 2933 
$node_(528) set Y_ 368 
$node_(528) set Z_ 0.0 
$ns at 0.0 "$node_(528) off" 
$ns at 500.0 "$node_(528) on" 
$node_(529) set X_ 678 
$node_(529) set Y_ 644 
$node_(529) set Z_ 0.0 
$ns at 0.0 "$node_(529) off" 
$ns at 500.0 "$node_(529) on" 
$node_(530) set X_ 1253 
$node_(530) set Y_ 321 
$node_(530) set Z_ 0.0 
$ns at 0.0 "$node_(530) off" 
$ns at 500.0 "$node_(530) on" 
$node_(531) set X_ 865 
$node_(531) set Y_ 738 
$node_(531) set Z_ 0.0 
$ns at 0.0 "$node_(531) off" 
$ns at 500.0 "$node_(531) on" 
$node_(532) set X_ 1031 
$node_(532) set Y_ 477 
$node_(532) set Z_ 0.0 
$ns at 0.0 "$node_(532) off" 
$ns at 500.0 "$node_(532) on" 
$node_(533) set X_ 664 
$node_(533) set Y_ 398 
$node_(533) set Z_ 0.0 
$ns at 0.0 "$node_(533) off" 
$ns at 500.0 "$node_(533) on" 
$node_(534) set X_ 1025 
$node_(534) set Y_ 54 
$node_(534) set Z_ 0.0 
$ns at 0.0 "$node_(534) off" 
$ns at 500.0 "$node_(534) on" 
$node_(535) set X_ 1996 
$node_(535) set Y_ 272 
$node_(535) set Z_ 0.0 
$ns at 0.0 "$node_(535) off" 
$ns at 500.0 "$node_(535) on" 
$node_(536) set X_ 2687 
$node_(536) set Y_ 113 
$node_(536) set Z_ 0.0 
$ns at 0.0 "$node_(536) off" 
$ns at 500.0 "$node_(536) on" 
$node_(537) set X_ 657 
$node_(537) set Y_ 23 
$node_(537) set Z_ 0.0 
$ns at 0.0 "$node_(537) off" 
$ns at 500.0 "$node_(537) on" 
$node_(538) set X_ 2961 
$node_(538) set Y_ 713 
$node_(538) set Z_ 0.0 
$ns at 0.0 "$node_(538) off" 
$ns at 500.0 "$node_(538) on" 
$node_(539) set X_ 234 
$node_(539) set Y_ 609 
$node_(539) set Z_ 0.0 
$ns at 0.0 "$node_(539) off" 
$ns at 500.0 "$node_(539) on" 
$node_(540) set X_ 680 
$node_(540) set Y_ 693 
$node_(540) set Z_ 0.0 
$ns at 0.0 "$node_(540) off" 
$ns at 500.0 "$node_(540) on" 
$node_(541) set X_ 848 
$node_(541) set Y_ 392 
$node_(541) set Z_ 0.0 
$ns at 0.0 "$node_(541) off" 
$ns at 500.0 "$node_(541) on" 
$node_(542) set X_ 744 
$node_(542) set Y_ 21 
$node_(542) set Z_ 0.0 
$ns at 0.0 "$node_(542) off" 
$ns at 500.0 "$node_(542) on" 
$node_(543) set X_ 1034 
$node_(543) set Y_ 36 
$node_(543) set Z_ 0.0 
$ns at 0.0 "$node_(543) off" 
$ns at 500.0 "$node_(543) on" 
$node_(544) set X_ 841 
$node_(544) set Y_ 373 
$node_(544) set Z_ 0.0 
$ns at 0.0 "$node_(544) off" 
$ns at 500.0 "$node_(544) on" 
$node_(545) set X_ 164 
$node_(545) set Y_ 821 
$node_(545) set Z_ 0.0 
$ns at 0.0 "$node_(545) off" 
$ns at 500.0 "$node_(545) on" 
$node_(546) set X_ 2757 
$node_(546) set Y_ 434 
$node_(546) set Z_ 0.0 
$ns at 0.0 "$node_(546) off" 
$ns at 500.0 "$node_(546) on" 
$node_(547) set X_ 2036 
$node_(547) set Y_ 292 
$node_(547) set Z_ 0.0 
$ns at 0.0 "$node_(547) off" 
$ns at 500.0 "$node_(547) on" 
$node_(548) set X_ 365 
$node_(548) set Y_ 444 
$node_(548) set Z_ 0.0 
$ns at 0.0 "$node_(548) off" 
$ns at 500.0 "$node_(548) on" 
$node_(549) set X_ 1830 
$node_(549) set Y_ 156 
$node_(549) set Z_ 0.0 
$ns at 0.0 "$node_(549) off" 
$ns at 500.0 "$node_(549) on" 
$node_(550) set X_ 1081 
$node_(550) set Y_ 680 
$node_(550) set Z_ 0.0 
$ns at 0.0 "$node_(550) off" 
$ns at 500.0 "$node_(550) on" 
$node_(551) set X_ 2283 
$node_(551) set Y_ 930 
$node_(551) set Z_ 0.0 
$ns at 0.0 "$node_(551) off" 
$ns at 500.0 "$node_(551) on" 
$node_(552) set X_ 2052 
$node_(552) set Y_ 884 
$node_(552) set Z_ 0.0 
$ns at 0.0 "$node_(552) off" 
$ns at 500.0 "$node_(552) on" 
$node_(553) set X_ 1907 
$node_(553) set Y_ 135 
$node_(553) set Z_ 0.0 
$ns at 0.0 "$node_(553) off" 
$ns at 500.0 "$node_(553) on" 
$node_(554) set X_ 507 
$node_(554) set Y_ 121 
$node_(554) set Z_ 0.0 
$ns at 0.0 "$node_(554) off" 
$ns at 500.0 "$node_(554) on" 
$node_(555) set X_ 224 
$node_(555) set Y_ 784 
$node_(555) set Z_ 0.0 
$ns at 0.0 "$node_(555) off" 
$ns at 500.0 "$node_(555) on" 
$node_(556) set X_ 2581 
$node_(556) set Y_ 219 
$node_(556) set Z_ 0.0 
$ns at 0.0 "$node_(556) off" 
$ns at 500.0 "$node_(556) on" 
$node_(557) set X_ 352 
$node_(557) set Y_ 463 
$node_(557) set Z_ 0.0 
$ns at 0.0 "$node_(557) off" 
$ns at 500.0 "$node_(557) on" 
$node_(558) set X_ 2538 
$node_(558) set Y_ 699 
$node_(558) set Z_ 0.0 
$ns at 0.0 "$node_(558) off" 
$ns at 500.0 "$node_(558) on" 
$node_(559) set X_ 893 
$node_(559) set Y_ 591 
$node_(559) set Z_ 0.0 
$ns at 0.0 "$node_(559) off" 
$ns at 500.0 "$node_(559) on" 
$node_(560) set X_ 1658 
$node_(560) set Y_ 77 
$node_(560) set Z_ 0.0 
$ns at 0.0 "$node_(560) off" 
$ns at 500.0 "$node_(560) on" 
$node_(561) set X_ 2859 
$node_(561) set Y_ 323 
$node_(561) set Z_ 0.0 
$ns at 0.0 "$node_(561) off" 
$ns at 500.0 "$node_(561) on" 
$node_(562) set X_ 2072 
$node_(562) set Y_ 518 
$node_(562) set Z_ 0.0 
$ns at 0.0 "$node_(562) off" 
$ns at 500.0 "$node_(562) on" 
$node_(563) set X_ 2424 
$node_(563) set Y_ 126 
$node_(563) set Z_ 0.0 
$ns at 0.0 "$node_(563) off" 
$ns at 500.0 "$node_(563) on" 
$node_(564) set X_ 1615 
$node_(564) set Y_ 92 
$node_(564) set Z_ 0.0 
$ns at 0.0 "$node_(564) off" 
$ns at 500.0 "$node_(564) on" 
$node_(565) set X_ 526 
$node_(565) set Y_ 278 
$node_(565) set Z_ 0.0 
$ns at 0.0 "$node_(565) off" 
$ns at 500.0 "$node_(565) on" 
$node_(566) set X_ 1253 
$node_(566) set Y_ 290 
$node_(566) set Z_ 0.0 
$ns at 0.0 "$node_(566) off" 
$ns at 500.0 "$node_(566) on" 
$node_(567) set X_ 1810 
$node_(567) set Y_ 417 
$node_(567) set Z_ 0.0 
$ns at 0.0 "$node_(567) off" 
$ns at 500.0 "$node_(567) on" 
$node_(568) set X_ 812 
$node_(568) set Y_ 41 
$node_(568) set Z_ 0.0 
$ns at 0.0 "$node_(568) off" 
$ns at 500.0 "$node_(568) on" 
$node_(569) set X_ 2110 
$node_(569) set Y_ 762 
$node_(569) set Z_ 0.0 
$ns at 0.0 "$node_(569) off" 
$ns at 500.0 "$node_(569) on" 
$node_(570) set X_ 701 
$node_(570) set Y_ 201 
$node_(570) set Z_ 0.0 
$ns at 0.0 "$node_(570) off" 
$ns at 500.0 "$node_(570) on" 
$node_(571) set X_ 539 
$node_(571) set Y_ 880 
$node_(571) set Z_ 0.0 
$ns at 0.0 "$node_(571) off" 
$ns at 500.0 "$node_(571) on" 
$node_(572) set X_ 2927 
$node_(572) set Y_ 369 
$node_(572) set Z_ 0.0 
$ns at 0.0 "$node_(572) off" 
$ns at 500.0 "$node_(572) on" 
$node_(573) set X_ 2409 
$node_(573) set Y_ 622 
$node_(573) set Z_ 0.0 
$ns at 0.0 "$node_(573) off" 
$ns at 500.0 "$node_(573) on" 
$node_(574) set X_ 1071 
$node_(574) set Y_ 939 
$node_(574) set Z_ 0.0 
$ns at 0.0 "$node_(574) off" 
$ns at 500.0 "$node_(574) on" 
$node_(575) set X_ 535 
$node_(575) set Y_ 449 
$node_(575) set Z_ 0.0 
$ns at 0.0 "$node_(575) off" 
$ns at 500.0 "$node_(575) on" 
$node_(576) set X_ 1974 
$node_(576) set Y_ 482 
$node_(576) set Z_ 0.0 
$ns at 0.0 "$node_(576) off" 
$ns at 500.0 "$node_(576) on" 
$node_(577) set X_ 2037 
$node_(577) set Y_ 424 
$node_(577) set Z_ 0.0 
$ns at 0.0 "$node_(577) off" 
$ns at 500.0 "$node_(577) on" 
$node_(578) set X_ 674 
$node_(578) set Y_ 922 
$node_(578) set Z_ 0.0 
$ns at 0.0 "$node_(578) off" 
$ns at 500.0 "$node_(578) on" 
$node_(579) set X_ 2535 
$node_(579) set Y_ 41 
$node_(579) set Z_ 0.0 
$ns at 0.0 "$node_(579) off" 
$ns at 500.0 "$node_(579) on" 
$node_(580) set X_ 2641 
$node_(580) set Y_ 474 
$node_(580) set Z_ 0.0 
$ns at 0.0 "$node_(580) off" 
$ns at 500.0 "$node_(580) on" 
$node_(581) set X_ 2634 
$node_(581) set Y_ 467 
$node_(581) set Z_ 0.0 
$ns at 0.0 "$node_(581) off" 
$ns at 500.0 "$node_(581) on" 
$node_(582) set X_ 2617 
$node_(582) set Y_ 988 
$node_(582) set Z_ 0.0 
$ns at 0.0 "$node_(582) off" 
$ns at 500.0 "$node_(582) on" 
$node_(583) set X_ 1816 
$node_(583) set Y_ 929 
$node_(583) set Z_ 0.0 
$ns at 0.0 "$node_(583) off" 
$ns at 500.0 "$node_(583) on" 
$node_(584) set X_ 1283 
$node_(584) set Y_ 161 
$node_(584) set Z_ 0.0 
$ns at 0.0 "$node_(584) off" 
$ns at 500.0 "$node_(584) on" 
$node_(585) set X_ 1274 
$node_(585) set Y_ 733 
$node_(585) set Z_ 0.0 
$ns at 0.0 "$node_(585) off" 
$ns at 500.0 "$node_(585) on" 
$node_(586) set X_ 677 
$node_(586) set Y_ 64 
$node_(586) set Z_ 0.0 
$ns at 0.0 "$node_(586) off" 
$ns at 500.0 "$node_(586) on" 
$node_(587) set X_ 919 
$node_(587) set Y_ 867 
$node_(587) set Z_ 0.0 
$ns at 0.0 "$node_(587) off" 
$ns at 500.0 "$node_(587) on" 
$node_(588) set X_ 666 
$node_(588) set Y_ 577 
$node_(588) set Z_ 0.0 
$ns at 0.0 "$node_(588) off" 
$ns at 500.0 "$node_(588) on" 
$node_(589) set X_ 2605 
$node_(589) set Y_ 196 
$node_(589) set Z_ 0.0 
$ns at 0.0 "$node_(589) off" 
$ns at 500.0 "$node_(589) on" 
$node_(590) set X_ 871 
$node_(590) set Y_ 590 
$node_(590) set Z_ 0.0 
$ns at 0.0 "$node_(590) off" 
$ns at 500.0 "$node_(590) on" 
$node_(591) set X_ 2777 
$node_(591) set Y_ 33 
$node_(591) set Z_ 0.0 
$ns at 0.0 "$node_(591) off" 
$ns at 500.0 "$node_(591) on" 
$node_(592) set X_ 297 
$node_(592) set Y_ 329 
$node_(592) set Z_ 0.0 
$ns at 0.0 "$node_(592) off" 
$ns at 500.0 "$node_(592) on" 
$node_(593) set X_ 1999 
$node_(593) set Y_ 242 
$node_(593) set Z_ 0.0 
$ns at 0.0 "$node_(593) off" 
$ns at 500.0 "$node_(593) on" 
$node_(594) set X_ 1442 
$node_(594) set Y_ 711 
$node_(594) set Z_ 0.0 
$ns at 0.0 "$node_(594) off" 
$ns at 500.0 "$node_(594) on" 
$node_(595) set X_ 2394 
$node_(595) set Y_ 139 
$node_(595) set Z_ 0.0 
$ns at 0.0 "$node_(595) off" 
$ns at 500.0 "$node_(595) on" 
$node_(596) set X_ 934 
$node_(596) set Y_ 450 
$node_(596) set Z_ 0.0 
$ns at 0.0 "$node_(596) off" 
$ns at 500.0 "$node_(596) on" 
$node_(597) set X_ 1741 
$node_(597) set Y_ 109 
$node_(597) set Z_ 0.0 
$ns at 0.0 "$node_(597) off" 
$ns at 500.0 "$node_(597) on" 
$node_(598) set X_ 1728 
$node_(598) set Y_ 516 
$node_(598) set Z_ 0.0 
$ns at 0.0 "$node_(598) off" 
$ns at 500.0 "$node_(598) on" 
$node_(599) set X_ 1980 
$node_(599) set Y_ 279 
$node_(599) set Z_ 0.0 
$ns at 0.0 "$node_(599) off" 
$ns at 500.0 "$node_(599) on" 
$node_(600) set X_ 2606 
$node_(600) set Y_ 645 
$node_(600) set Z_ 0.0 
$ns at 0.0 "$node_(600) off" 
$ns at 600.0 "$node_(600) on" 
$node_(601) set X_ 23 
$node_(601) set Y_ 597 
$node_(601) set Z_ 0.0 
$ns at 0.0 "$node_(601) off" 
$ns at 600.0 "$node_(601) on" 
$node_(602) set X_ 116 
$node_(602) set Y_ 828 
$node_(602) set Z_ 0.0 
$ns at 0.0 "$node_(602) off" 
$ns at 600.0 "$node_(602) on" 
$node_(603) set X_ 200 
$node_(603) set Y_ 347 
$node_(603) set Z_ 0.0 
$ns at 0.0 "$node_(603) off" 
$ns at 600.0 "$node_(603) on" 
$node_(604) set X_ 256 
$node_(604) set Y_ 76 
$node_(604) set Z_ 0.0 
$ns at 0.0 "$node_(604) off" 
$ns at 600.0 "$node_(604) on" 
$node_(605) set X_ 1289 
$node_(605) set Y_ 476 
$node_(605) set Z_ 0.0 
$ns at 0.0 "$node_(605) off" 
$ns at 600.0 "$node_(605) on" 
$node_(606) set X_ 2062 
$node_(606) set Y_ 335 
$node_(606) set Z_ 0.0 
$ns at 0.0 "$node_(606) off" 
$ns at 600.0 "$node_(606) on" 
$node_(607) set X_ 2920 
$node_(607) set Y_ 115 
$node_(607) set Z_ 0.0 
$ns at 0.0 "$node_(607) off" 
$ns at 600.0 "$node_(607) on" 
$node_(608) set X_ 2812 
$node_(608) set Y_ 85 
$node_(608) set Z_ 0.0 
$ns at 0.0 "$node_(608) off" 
$ns at 600.0 "$node_(608) on" 
$node_(609) set X_ 1191 
$node_(609) set Y_ 309 
$node_(609) set Z_ 0.0 
$ns at 0.0 "$node_(609) off" 
$ns at 600.0 "$node_(609) on" 
$node_(610) set X_ 2884 
$node_(610) set Y_ 59 
$node_(610) set Z_ 0.0 
$ns at 0.0 "$node_(610) off" 
$ns at 600.0 "$node_(610) on" 
$node_(611) set X_ 1637 
$node_(611) set Y_ 297 
$node_(611) set Z_ 0.0 
$ns at 0.0 "$node_(611) off" 
$ns at 600.0 "$node_(611) on" 
$node_(612) set X_ 309 
$node_(612) set Y_ 485 
$node_(612) set Z_ 0.0 
$ns at 0.0 "$node_(612) off" 
$ns at 600.0 "$node_(612) on" 
$node_(613) set X_ 2190 
$node_(613) set Y_ 651 
$node_(613) set Z_ 0.0 
$ns at 0.0 "$node_(613) off" 
$ns at 600.0 "$node_(613) on" 
$node_(614) set X_ 785 
$node_(614) set Y_ 454 
$node_(614) set Z_ 0.0 
$ns at 0.0 "$node_(614) off" 
$ns at 600.0 "$node_(614) on" 
$node_(615) set X_ 1452 
$node_(615) set Y_ 179 
$node_(615) set Z_ 0.0 
$ns at 0.0 "$node_(615) off" 
$ns at 600.0 "$node_(615) on" 
$node_(616) set X_ 2383 
$node_(616) set Y_ 336 
$node_(616) set Z_ 0.0 
$ns at 0.0 "$node_(616) off" 
$ns at 600.0 "$node_(616) on" 
$node_(617) set X_ 2589 
$node_(617) set Y_ 822 
$node_(617) set Z_ 0.0 
$ns at 0.0 "$node_(617) off" 
$ns at 600.0 "$node_(617) on" 
$node_(618) set X_ 341 
$node_(618) set Y_ 635 
$node_(618) set Z_ 0.0 
$ns at 0.0 "$node_(618) off" 
$ns at 600.0 "$node_(618) on" 
$node_(619) set X_ 1276 
$node_(619) set Y_ 653 
$node_(619) set Z_ 0.0 
$ns at 0.0 "$node_(619) off" 
$ns at 600.0 "$node_(619) on" 
$node_(620) set X_ 2231 
$node_(620) set Y_ 329 
$node_(620) set Z_ 0.0 
$ns at 0.0 "$node_(620) off" 
$ns at 600.0 "$node_(620) on" 
$node_(621) set X_ 1502 
$node_(621) set Y_ 723 
$node_(621) set Z_ 0.0 
$ns at 0.0 "$node_(621) off" 
$ns at 600.0 "$node_(621) on" 
$node_(622) set X_ 398 
$node_(622) set Y_ 521 
$node_(622) set Z_ 0.0 
$ns at 0.0 "$node_(622) off" 
$ns at 600.0 "$node_(622) on" 
$node_(623) set X_ 651 
$node_(623) set Y_ 733 
$node_(623) set Z_ 0.0 
$ns at 0.0 "$node_(623) off" 
$ns at 600.0 "$node_(623) on" 
$node_(624) set X_ 2881 
$node_(624) set Y_ 184 
$node_(624) set Z_ 0.0 
$ns at 0.0 "$node_(624) off" 
$ns at 600.0 "$node_(624) on" 
$node_(625) set X_ 65 
$node_(625) set Y_ 387 
$node_(625) set Z_ 0.0 
$ns at 0.0 "$node_(625) off" 
$ns at 600.0 "$node_(625) on" 
$node_(626) set X_ 105 
$node_(626) set Y_ 897 
$node_(626) set Z_ 0.0 
$ns at 0.0 "$node_(626) off" 
$ns at 600.0 "$node_(626) on" 
$node_(627) set X_ 345 
$node_(627) set Y_ 891 
$node_(627) set Z_ 0.0 
$ns at 0.0 "$node_(627) off" 
$ns at 600.0 "$node_(627) on" 
$node_(628) set X_ 351 
$node_(628) set Y_ 704 
$node_(628) set Z_ 0.0 
$ns at 0.0 "$node_(628) off" 
$ns at 600.0 "$node_(628) on" 
$node_(629) set X_ 888 
$node_(629) set Y_ 233 
$node_(629) set Z_ 0.0 
$ns at 0.0 "$node_(629) off" 
$ns at 600.0 "$node_(629) on" 
$node_(630) set X_ 544 
$node_(630) set Y_ 687 
$node_(630) set Z_ 0.0 
$ns at 0.0 "$node_(630) off" 
$ns at 600.0 "$node_(630) on" 
$node_(631) set X_ 615 
$node_(631) set Y_ 779 
$node_(631) set Z_ 0.0 
$ns at 0.0 "$node_(631) off" 
$ns at 600.0 "$node_(631) on" 
$node_(632) set X_ 2055 
$node_(632) set Y_ 382 
$node_(632) set Z_ 0.0 
$ns at 0.0 "$node_(632) off" 
$ns at 600.0 "$node_(632) on" 
$node_(633) set X_ 2552 
$node_(633) set Y_ 232 
$node_(633) set Z_ 0.0 
$ns at 0.0 "$node_(633) off" 
$ns at 600.0 "$node_(633) on" 
$node_(634) set X_ 1175 
$node_(634) set Y_ 928 
$node_(634) set Z_ 0.0 
$ns at 0.0 "$node_(634) off" 
$ns at 600.0 "$node_(634) on" 
$node_(635) set X_ 1809 
$node_(635) set Y_ 195 
$node_(635) set Z_ 0.0 
$ns at 0.0 "$node_(635) off" 
$ns at 600.0 "$node_(635) on" 
$node_(636) set X_ 526 
$node_(636) set Y_ 700 
$node_(636) set Z_ 0.0 
$ns at 0.0 "$node_(636) off" 
$ns at 600.0 "$node_(636) on" 
$node_(637) set X_ 1655 
$node_(637) set Y_ 426 
$node_(637) set Z_ 0.0 
$ns at 0.0 "$node_(637) off" 
$ns at 600.0 "$node_(637) on" 
$node_(638) set X_ 53 
$node_(638) set Y_ 243 
$node_(638) set Z_ 0.0 
$ns at 0.0 "$node_(638) off" 
$ns at 600.0 "$node_(638) on" 
$node_(639) set X_ 687 
$node_(639) set Y_ 346 
$node_(639) set Z_ 0.0 
$ns at 0.0 "$node_(639) off" 
$ns at 600.0 "$node_(639) on" 
$node_(640) set X_ 309 
$node_(640) set Y_ 516 
$node_(640) set Z_ 0.0 
$ns at 0.0 "$node_(640) off" 
$ns at 600.0 "$node_(640) on" 
$node_(641) set X_ 702 
$node_(641) set Y_ 534 
$node_(641) set Z_ 0.0 
$ns at 0.0 "$node_(641) off" 
$ns at 600.0 "$node_(641) on" 
$node_(642) set X_ 1542 
$node_(642) set Y_ 807 
$node_(642) set Z_ 0.0 
$ns at 0.0 "$node_(642) off" 
$ns at 600.0 "$node_(642) on" 
$node_(643) set X_ 627 
$node_(643) set Y_ 766 
$node_(643) set Z_ 0.0 
$ns at 0.0 "$node_(643) off" 
$ns at 600.0 "$node_(643) on" 
$node_(644) set X_ 1610 
$node_(644) set Y_ 194 
$node_(644) set Z_ 0.0 
$ns at 0.0 "$node_(644) off" 
$ns at 600.0 "$node_(644) on" 
$node_(645) set X_ 2857 
$node_(645) set Y_ 568 
$node_(645) set Z_ 0.0 
$ns at 0.0 "$node_(645) off" 
$ns at 600.0 "$node_(645) on" 
$node_(646) set X_ 2984 
$node_(646) set Y_ 105 
$node_(646) set Z_ 0.0 
$ns at 0.0 "$node_(646) off" 
$ns at 600.0 "$node_(646) on" 
$node_(647) set X_ 619 
$node_(647) set Y_ 452 
$node_(647) set Z_ 0.0 
$ns at 0.0 "$node_(647) off" 
$ns at 600.0 "$node_(647) on" 
$node_(648) set X_ 1039 
$node_(648) set Y_ 350 
$node_(648) set Z_ 0.0 
$ns at 0.0 "$node_(648) off" 
$ns at 600.0 "$node_(648) on" 
$node_(649) set X_ 2333 
$node_(649) set Y_ 698 
$node_(649) set Z_ 0.0 
$ns at 0.0 "$node_(649) off" 
$ns at 600.0 "$node_(649) on" 
$node_(650) set X_ 1538 
$node_(650) set Y_ 967 
$node_(650) set Z_ 0.0 
$ns at 0.0 "$node_(650) off" 
$ns at 600.0 "$node_(650) on" 
$node_(651) set X_ 690 
$node_(651) set Y_ 62 
$node_(651) set Z_ 0.0 
$ns at 0.0 "$node_(651) off" 
$ns at 600.0 "$node_(651) on" 
$node_(652) set X_ 1540 
$node_(652) set Y_ 383 
$node_(652) set Z_ 0.0 
$ns at 0.0 "$node_(652) off" 
$ns at 600.0 "$node_(652) on" 
$node_(653) set X_ 957 
$node_(653) set Y_ 804 
$node_(653) set Z_ 0.0 
$ns at 0.0 "$node_(653) off" 
$ns at 600.0 "$node_(653) on" 
$node_(654) set X_ 161 
$node_(654) set Y_ 677 
$node_(654) set Z_ 0.0 
$ns at 0.0 "$node_(654) off" 
$ns at 600.0 "$node_(654) on" 
$node_(655) set X_ 2172 
$node_(655) set Y_ 247 
$node_(655) set Z_ 0.0 
$ns at 0.0 "$node_(655) off" 
$ns at 600.0 "$node_(655) on" 
$node_(656) set X_ 345 
$node_(656) set Y_ 166 
$node_(656) set Z_ 0.0 
$ns at 0.0 "$node_(656) off" 
$ns at 600.0 "$node_(656) on" 
$node_(657) set X_ 1175 
$node_(657) set Y_ 425 
$node_(657) set Z_ 0.0 
$ns at 0.0 "$node_(657) off" 
$ns at 600.0 "$node_(657) on" 
$node_(658) set X_ 1435 
$node_(658) set Y_ 170 
$node_(658) set Z_ 0.0 
$ns at 0.0 "$node_(658) off" 
$ns at 600.0 "$node_(658) on" 
$node_(659) set X_ 2955 
$node_(659) set Y_ 464 
$node_(659) set Z_ 0.0 
$ns at 0.0 "$node_(659) off" 
$ns at 600.0 "$node_(659) on" 
$node_(660) set X_ 2542 
$node_(660) set Y_ 553 
$node_(660) set Z_ 0.0 
$ns at 0.0 "$node_(660) off" 
$ns at 600.0 "$node_(660) on" 
$node_(661) set X_ 1540 
$node_(661) set Y_ 70 
$node_(661) set Z_ 0.0 
$ns at 0.0 "$node_(661) off" 
$ns at 600.0 "$node_(661) on" 
$node_(662) set X_ 2713 
$node_(662) set Y_ 566 
$node_(662) set Z_ 0.0 
$ns at 0.0 "$node_(662) off" 
$ns at 600.0 "$node_(662) on" 
$node_(663) set X_ 643 
$node_(663) set Y_ 829 
$node_(663) set Z_ 0.0 
$ns at 0.0 "$node_(663) off" 
$ns at 600.0 "$node_(663) on" 
$node_(664) set X_ 606 
$node_(664) set Y_ 590 
$node_(664) set Z_ 0.0 
$ns at 0.0 "$node_(664) off" 
$ns at 600.0 "$node_(664) on" 
$node_(665) set X_ 436 
$node_(665) set Y_ 88 
$node_(665) set Z_ 0.0 
$ns at 0.0 "$node_(665) off" 
$ns at 600.0 "$node_(665) on" 
$node_(666) set X_ 794 
$node_(666) set Y_ 599 
$node_(666) set Z_ 0.0 
$ns at 0.0 "$node_(666) off" 
$ns at 600.0 "$node_(666) on" 
$node_(667) set X_ 2246 
$node_(667) set Y_ 867 
$node_(667) set Z_ 0.0 
$ns at 0.0 "$node_(667) off" 
$ns at 600.0 "$node_(667) on" 
$node_(668) set X_ 1960 
$node_(668) set Y_ 582 
$node_(668) set Z_ 0.0 
$ns at 0.0 "$node_(668) off" 
$ns at 600.0 "$node_(668) on" 
$node_(669) set X_ 2595 
$node_(669) set Y_ 560 
$node_(669) set Z_ 0.0 
$ns at 0.0 "$node_(669) off" 
$ns at 600.0 "$node_(669) on" 
$node_(670) set X_ 99 
$node_(670) set Y_ 666 
$node_(670) set Z_ 0.0 
$ns at 0.0 "$node_(670) off" 
$ns at 600.0 "$node_(670) on" 
$node_(671) set X_ 829 
$node_(671) set Y_ 229 
$node_(671) set Z_ 0.0 
$ns at 0.0 "$node_(671) off" 
$ns at 600.0 "$node_(671) on" 
$node_(672) set X_ 1438 
$node_(672) set Y_ 403 
$node_(672) set Z_ 0.0 
$ns at 0.0 "$node_(672) off" 
$ns at 600.0 "$node_(672) on" 
$node_(673) set X_ 2664 
$node_(673) set Y_ 914 
$node_(673) set Z_ 0.0 
$ns at 0.0 "$node_(673) off" 
$ns at 600.0 "$node_(673) on" 
$node_(674) set X_ 1052 
$node_(674) set Y_ 556 
$node_(674) set Z_ 0.0 
$ns at 0.0 "$node_(674) off" 
$ns at 600.0 "$node_(674) on" 
$node_(675) set X_ 252 
$node_(675) set Y_ 697 
$node_(675) set Z_ 0.0 
$ns at 0.0 "$node_(675) off" 
$ns at 600.0 "$node_(675) on" 
$node_(676) set X_ 206 
$node_(676) set Y_ 693 
$node_(676) set Z_ 0.0 
$ns at 0.0 "$node_(676) off" 
$ns at 600.0 "$node_(676) on" 
$node_(677) set X_ 1850 
$node_(677) set Y_ 234 
$node_(677) set Z_ 0.0 
$ns at 0.0 "$node_(677) off" 
$ns at 600.0 "$node_(677) on" 
$node_(678) set X_ 139 
$node_(678) set Y_ 102 
$node_(678) set Z_ 0.0 
$ns at 0.0 "$node_(678) off" 
$ns at 600.0 "$node_(678) on" 
$node_(679) set X_ 1925 
$node_(679) set Y_ 86 
$node_(679) set Z_ 0.0 
$ns at 0.0 "$node_(679) off" 
$ns at 600.0 "$node_(679) on" 
$node_(680) set X_ 2511 
$node_(680) set Y_ 848 
$node_(680) set Z_ 0.0 
$ns at 0.0 "$node_(680) off" 
$ns at 600.0 "$node_(680) on" 
$node_(681) set X_ 434 
$node_(681) set Y_ 452 
$node_(681) set Z_ 0.0 
$ns at 0.0 "$node_(681) off" 
$ns at 600.0 "$node_(681) on" 
$node_(682) set X_ 860 
$node_(682) set Y_ 282 
$node_(682) set Z_ 0.0 
$ns at 0.0 "$node_(682) off" 
$ns at 600.0 "$node_(682) on" 
$node_(683) set X_ 202 
$node_(683) set Y_ 851 
$node_(683) set Z_ 0.0 
$ns at 0.0 "$node_(683) off" 
$ns at 600.0 "$node_(683) on" 
$node_(684) set X_ 328 
$node_(684) set Y_ 933 
$node_(684) set Z_ 0.0 
$ns at 0.0 "$node_(684) off" 
$ns at 600.0 "$node_(684) on" 
$node_(685) set X_ 2664 
$node_(685) set Y_ 889 
$node_(685) set Z_ 0.0 
$ns at 0.0 "$node_(685) off" 
$ns at 600.0 "$node_(685) on" 
$node_(686) set X_ 2532 
$node_(686) set Y_ 545 
$node_(686) set Z_ 0.0 
$ns at 0.0 "$node_(686) off" 
$ns at 600.0 "$node_(686) on" 
$node_(687) set X_ 853 
$node_(687) set Y_ 487 
$node_(687) set Z_ 0.0 
$ns at 0.0 "$node_(687) off" 
$ns at 600.0 "$node_(687) on" 
$node_(688) set X_ 1747 
$node_(688) set Y_ 919 
$node_(688) set Z_ 0.0 
$ns at 0.0 "$node_(688) off" 
$ns at 600.0 "$node_(688) on" 
$node_(689) set X_ 2324 
$node_(689) set Y_ 857 
$node_(689) set Z_ 0.0 
$ns at 0.0 "$node_(689) off" 
$ns at 600.0 "$node_(689) on" 
$node_(690) set X_ 666 
$node_(690) set Y_ 378 
$node_(690) set Z_ 0.0 
$ns at 0.0 "$node_(690) off" 
$ns at 600.0 "$node_(690) on" 
$node_(691) set X_ 2725 
$node_(691) set Y_ 68 
$node_(691) set Z_ 0.0 
$ns at 0.0 "$node_(691) off" 
$ns at 600.0 "$node_(691) on" 
$node_(692) set X_ 706 
$node_(692) set Y_ 895 
$node_(692) set Z_ 0.0 
$ns at 0.0 "$node_(692) off" 
$ns at 600.0 "$node_(692) on" 
$node_(693) set X_ 1982 
$node_(693) set Y_ 268 
$node_(693) set Z_ 0.0 
$ns at 0.0 "$node_(693) off" 
$ns at 600.0 "$node_(693) on" 
$node_(694) set X_ 378 
$node_(694) set Y_ 377 
$node_(694) set Z_ 0.0 
$ns at 0.0 "$node_(694) off" 
$ns at 600.0 "$node_(694) on" 
$node_(695) set X_ 530 
$node_(695) set Y_ 484 
$node_(695) set Z_ 0.0 
$ns at 0.0 "$node_(695) off" 
$ns at 600.0 "$node_(695) on" 
$node_(696) set X_ 2382 
$node_(696) set Y_ 136 
$node_(696) set Z_ 0.0 
$ns at 0.0 "$node_(696) off" 
$ns at 600.0 "$node_(696) on" 
$node_(697) set X_ 2717 
$node_(697) set Y_ 466 
$node_(697) set Z_ 0.0 
$ns at 0.0 "$node_(697) off" 
$ns at 600.0 "$node_(697) on" 
$node_(698) set X_ 47 
$node_(698) set Y_ 353 
$node_(698) set Z_ 0.0 
$ns at 0.0 "$node_(698) off" 
$ns at 600.0 "$node_(698) on" 
$node_(699) set X_ 1392 
$node_(699) set Y_ 224 
$node_(699) set Z_ 0.0 
$ns at 0.0 "$node_(699) off" 
$ns at 600.0 "$node_(699) on" 
$node_(700) set X_ 361 
$node_(700) set Y_ 183 
$node_(700) set Z_ 0.0 
$ns at 0.0 "$node_(700) off" 
$ns at 700.0 "$node_(700) on" 
$node_(701) set X_ 843 
$node_(701) set Y_ 731 
$node_(701) set Z_ 0.0 
$ns at 0.0 "$node_(701) off" 
$ns at 700.0 "$node_(701) on" 
$node_(702) set X_ 2193 
$node_(702) set Y_ 233 
$node_(702) set Z_ 0.0 
$ns at 0.0 "$node_(702) off" 
$ns at 700.0 "$node_(702) on" 
$node_(703) set X_ 561 
$node_(703) set Y_ 788 
$node_(703) set Z_ 0.0 
$ns at 0.0 "$node_(703) off" 
$ns at 700.0 "$node_(703) on" 
$node_(704) set X_ 400 
$node_(704) set Y_ 319 
$node_(704) set Z_ 0.0 
$ns at 0.0 "$node_(704) off" 
$ns at 700.0 "$node_(704) on" 
$node_(705) set X_ 1900 
$node_(705) set Y_ 176 
$node_(705) set Z_ 0.0 
$ns at 0.0 "$node_(705) off" 
$ns at 700.0 "$node_(705) on" 
$node_(706) set X_ 1281 
$node_(706) set Y_ 778 
$node_(706) set Z_ 0.0 
$ns at 0.0 "$node_(706) off" 
$ns at 700.0 "$node_(706) on" 
$node_(707) set X_ 447 
$node_(707) set Y_ 48 
$node_(707) set Z_ 0.0 
$ns at 0.0 "$node_(707) off" 
$ns at 700.0 "$node_(707) on" 
$node_(708) set X_ 389 
$node_(708) set Y_ 105 
$node_(708) set Z_ 0.0 
$ns at 0.0 "$node_(708) off" 
$ns at 700.0 "$node_(708) on" 
$node_(709) set X_ 2956 
$node_(709) set Y_ 971 
$node_(709) set Z_ 0.0 
$ns at 0.0 "$node_(709) off" 
$ns at 700.0 "$node_(709) on" 
$node_(710) set X_ 919 
$node_(710) set Y_ 395 
$node_(710) set Z_ 0.0 
$ns at 0.0 "$node_(710) off" 
$ns at 700.0 "$node_(710) on" 
$node_(711) set X_ 1876 
$node_(711) set Y_ 146 
$node_(711) set Z_ 0.0 
$ns at 0.0 "$node_(711) off" 
$ns at 700.0 "$node_(711) on" 
$node_(712) set X_ 1844 
$node_(712) set Y_ 839 
$node_(712) set Z_ 0.0 
$ns at 0.0 "$node_(712) off" 
$ns at 700.0 "$node_(712) on" 
$node_(713) set X_ 2979 
$node_(713) set Y_ 127 
$node_(713) set Z_ 0.0 
$ns at 0.0 "$node_(713) off" 
$ns at 700.0 "$node_(713) on" 
$node_(714) set X_ 2669 
$node_(714) set Y_ 550 
$node_(714) set Z_ 0.0 
$ns at 0.0 "$node_(714) off" 
$ns at 700.0 "$node_(714) on" 
$node_(715) set X_ 2216 
$node_(715) set Y_ 771 
$node_(715) set Z_ 0.0 
$ns at 0.0 "$node_(715) off" 
$ns at 700.0 "$node_(715) on" 
$node_(716) set X_ 20 
$node_(716) set Y_ 116 
$node_(716) set Z_ 0.0 
$ns at 0.0 "$node_(716) off" 
$ns at 700.0 "$node_(716) on" 
$node_(717) set X_ 2823 
$node_(717) set Y_ 278 
$node_(717) set Z_ 0.0 
$ns at 0.0 "$node_(717) off" 
$ns at 700.0 "$node_(717) on" 
$node_(718) set X_ 2429 
$node_(718) set Y_ 560 
$node_(718) set Z_ 0.0 
$ns at 0.0 "$node_(718) off" 
$ns at 700.0 "$node_(718) on" 
$node_(719) set X_ 2788 
$node_(719) set Y_ 878 
$node_(719) set Z_ 0.0 
$ns at 0.0 "$node_(719) off" 
$ns at 700.0 "$node_(719) on" 
$node_(720) set X_ 2492 
$node_(720) set Y_ 862 
$node_(720) set Z_ 0.0 
$ns at 0.0 "$node_(720) off" 
$ns at 700.0 "$node_(720) on" 
$node_(721) set X_ 2095 
$node_(721) set Y_ 178 
$node_(721) set Z_ 0.0 
$ns at 0.0 "$node_(721) off" 
$ns at 700.0 "$node_(721) on" 
$node_(722) set X_ 1105 
$node_(722) set Y_ 780 
$node_(722) set Z_ 0.0 
$ns at 0.0 "$node_(722) off" 
$ns at 700.0 "$node_(722) on" 
$node_(723) set X_ 1699 
$node_(723) set Y_ 196 
$node_(723) set Z_ 0.0 
$ns at 0.0 "$node_(723) off" 
$ns at 700.0 "$node_(723) on" 
$node_(724) set X_ 787 
$node_(724) set Y_ 490 
$node_(724) set Z_ 0.0 
$ns at 0.0 "$node_(724) off" 
$ns at 700.0 "$node_(724) on" 
$node_(725) set X_ 930 
$node_(725) set Y_ 862 
$node_(725) set Z_ 0.0 
$ns at 0.0 "$node_(725) off" 
$ns at 700.0 "$node_(725) on" 
$node_(726) set X_ 1036 
$node_(726) set Y_ 460 
$node_(726) set Z_ 0.0 
$ns at 0.0 "$node_(726) off" 
$ns at 700.0 "$node_(726) on" 
$node_(727) set X_ 2 
$node_(727) set Y_ 104 
$node_(727) set Z_ 0.0 
$ns at 0.0 "$node_(727) off" 
$ns at 700.0 "$node_(727) on" 
$node_(728) set X_ 406 
$node_(728) set Y_ 83 
$node_(728) set Z_ 0.0 
$ns at 0.0 "$node_(728) off" 
$ns at 700.0 "$node_(728) on" 
$node_(729) set X_ 459 
$node_(729) set Y_ 692 
$node_(729) set Z_ 0.0 
$ns at 0.0 "$node_(729) off" 
$ns at 700.0 "$node_(729) on" 
$node_(730) set X_ 2388 
$node_(730) set Y_ 782 
$node_(730) set Z_ 0.0 
$ns at 0.0 "$node_(730) off" 
$ns at 700.0 "$node_(730) on" 
$node_(731) set X_ 1852 
$node_(731) set Y_ 696 
$node_(731) set Z_ 0.0 
$ns at 0.0 "$node_(731) off" 
$ns at 700.0 "$node_(731) on" 
$node_(732) set X_ 2330 
$node_(732) set Y_ 733 
$node_(732) set Z_ 0.0 
$ns at 0.0 "$node_(732) off" 
$ns at 700.0 "$node_(732) on" 
$node_(733) set X_ 2491 
$node_(733) set Y_ 723 
$node_(733) set Z_ 0.0 
$ns at 0.0 "$node_(733) off" 
$ns at 700.0 "$node_(733) on" 
$node_(734) set X_ 2485 
$node_(734) set Y_ 855 
$node_(734) set Z_ 0.0 
$ns at 0.0 "$node_(734) off" 
$ns at 700.0 "$node_(734) on" 
$node_(735) set X_ 2036 
$node_(735) set Y_ 141 
$node_(735) set Z_ 0.0 
$ns at 0.0 "$node_(735) off" 
$ns at 700.0 "$node_(735) on" 
$node_(736) set X_ 852 
$node_(736) set Y_ 445 
$node_(736) set Z_ 0.0 
$ns at 0.0 "$node_(736) off" 
$ns at 700.0 "$node_(736) on" 
$node_(737) set X_ 685 
$node_(737) set Y_ 119 
$node_(737) set Z_ 0.0 
$ns at 0.0 "$node_(737) off" 
$ns at 700.0 "$node_(737) on" 
$node_(738) set X_ 1781 
$node_(738) set Y_ 683 
$node_(738) set Z_ 0.0 
$ns at 0.0 "$node_(738) off" 
$ns at 700.0 "$node_(738) on" 
$node_(739) set X_ 46 
$node_(739) set Y_ 637 
$node_(739) set Z_ 0.0 
$ns at 0.0 "$node_(739) off" 
$ns at 700.0 "$node_(739) on" 
$node_(740) set X_ 311 
$node_(740) set Y_ 238 
$node_(740) set Z_ 0.0 
$ns at 0.0 "$node_(740) off" 
$ns at 700.0 "$node_(740) on" 
$node_(741) set X_ 1251 
$node_(741) set Y_ 565 
$node_(741) set Z_ 0.0 
$ns at 0.0 "$node_(741) off" 
$ns at 700.0 "$node_(741) on" 
$node_(742) set X_ 2953 
$node_(742) set Y_ 381 
$node_(742) set Z_ 0.0 
$ns at 0.0 "$node_(742) off" 
$ns at 700.0 "$node_(742) on" 
$node_(743) set X_ 2595 
$node_(743) set Y_ 576 
$node_(743) set Z_ 0.0 
$ns at 0.0 "$node_(743) off" 
$ns at 700.0 "$node_(743) on" 
$node_(744) set X_ 91 
$node_(744) set Y_ 348 
$node_(744) set Z_ 0.0 
$ns at 0.0 "$node_(744) off" 
$ns at 700.0 "$node_(744) on" 
$node_(745) set X_ 937 
$node_(745) set Y_ 875 
$node_(745) set Z_ 0.0 
$ns at 0.0 "$node_(745) off" 
$ns at 700.0 "$node_(745) on" 
$node_(746) set X_ 2318 
$node_(746) set Y_ 147 
$node_(746) set Z_ 0.0 
$ns at 0.0 "$node_(746) off" 
$ns at 700.0 "$node_(746) on" 
$node_(747) set X_ 1216 
$node_(747) set Y_ 724 
$node_(747) set Z_ 0.0 
$ns at 0.0 "$node_(747) off" 
$ns at 700.0 "$node_(747) on" 
$node_(748) set X_ 2951 
$node_(748) set Y_ 673 
$node_(748) set Z_ 0.0 
$ns at 0.0 "$node_(748) off" 
$ns at 700.0 "$node_(748) on" 
$node_(749) set X_ 852 
$node_(749) set Y_ 273 
$node_(749) set Z_ 0.0 
$ns at 0.0 "$node_(749) off" 
$ns at 700.0 "$node_(749) on" 
$node_(750) set X_ 540 
$node_(750) set Y_ 772 
$node_(750) set Z_ 0.0 
$ns at 0.0 "$node_(750) off" 
$ns at 700.0 "$node_(750) on" 
$node_(751) set X_ 2368 
$node_(751) set Y_ 514 
$node_(751) set Z_ 0.0 
$ns at 0.0 "$node_(751) off" 
$ns at 700.0 "$node_(751) on" 
$node_(752) set X_ 542 
$node_(752) set Y_ 847 
$node_(752) set Z_ 0.0 
$ns at 0.0 "$node_(752) off" 
$ns at 700.0 "$node_(752) on" 
$node_(753) set X_ 384 
$node_(753) set Y_ 29 
$node_(753) set Z_ 0.0 
$ns at 0.0 "$node_(753) off" 
$ns at 700.0 "$node_(753) on" 
$node_(754) set X_ 355 
$node_(754) set Y_ 705 
$node_(754) set Z_ 0.0 
$ns at 0.0 "$node_(754) off" 
$ns at 700.0 "$node_(754) on" 
$node_(755) set X_ 2182 
$node_(755) set Y_ 780 
$node_(755) set Z_ 0.0 
$ns at 0.0 "$node_(755) off" 
$ns at 700.0 "$node_(755) on" 
$node_(756) set X_ 1695 
$node_(756) set Y_ 610 
$node_(756) set Z_ 0.0 
$ns at 0.0 "$node_(756) off" 
$ns at 700.0 "$node_(756) on" 
$node_(757) set X_ 254 
$node_(757) set Y_ 431 
$node_(757) set Z_ 0.0 
$ns at 0.0 "$node_(757) off" 
$ns at 700.0 "$node_(757) on" 
$node_(758) set X_ 1755 
$node_(758) set Y_ 932 
$node_(758) set Z_ 0.0 
$ns at 0.0 "$node_(758) off" 
$ns at 700.0 "$node_(758) on" 
$node_(759) set X_ 2760 
$node_(759) set Y_ 507 
$node_(759) set Z_ 0.0 
$ns at 0.0 "$node_(759) off" 
$ns at 700.0 "$node_(759) on" 
$node_(760) set X_ 1816 
$node_(760) set Y_ 336 
$node_(760) set Z_ 0.0 
$ns at 0.0 "$node_(760) off" 
$ns at 700.0 "$node_(760) on" 
$node_(761) set X_ 2467 
$node_(761) set Y_ 284 
$node_(761) set Z_ 0.0 
$ns at 0.0 "$node_(761) off" 
$ns at 700.0 "$node_(761) on" 
$node_(762) set X_ 2871 
$node_(762) set Y_ 206 
$node_(762) set Z_ 0.0 
$ns at 0.0 "$node_(762) off" 
$ns at 700.0 "$node_(762) on" 
$node_(763) set X_ 2671 
$node_(763) set Y_ 445 
$node_(763) set Z_ 0.0 
$ns at 0.0 "$node_(763) off" 
$ns at 700.0 "$node_(763) on" 
$node_(764) set X_ 2491 
$node_(764) set Y_ 893 
$node_(764) set Z_ 0.0 
$ns at 0.0 "$node_(764) off" 
$ns at 700.0 "$node_(764) on" 
$node_(765) set X_ 1713 
$node_(765) set Y_ 397 
$node_(765) set Z_ 0.0 
$ns at 0.0 "$node_(765) off" 
$ns at 700.0 "$node_(765) on" 
$node_(766) set X_ 501 
$node_(766) set Y_ 381 
$node_(766) set Z_ 0.0 
$ns at 0.0 "$node_(766) off" 
$ns at 700.0 "$node_(766) on" 
$node_(767) set X_ 60 
$node_(767) set Y_ 649 
$node_(767) set Z_ 0.0 
$ns at 0.0 "$node_(767) off" 
$ns at 700.0 "$node_(767) on" 
$node_(768) set X_ 2120 
$node_(768) set Y_ 219 
$node_(768) set Z_ 0.0 
$ns at 0.0 "$node_(768) off" 
$ns at 700.0 "$node_(768) on" 
$node_(769) set X_ 2464 
$node_(769) set Y_ 769 
$node_(769) set Z_ 0.0 
$ns at 0.0 "$node_(769) off" 
$ns at 700.0 "$node_(769) on" 
$node_(770) set X_ 8 
$node_(770) set Y_ 879 
$node_(770) set Z_ 0.0 
$ns at 0.0 "$node_(770) off" 
$ns at 700.0 "$node_(770) on" 
$node_(771) set X_ 2506 
$node_(771) set Y_ 298 
$node_(771) set Z_ 0.0 
$ns at 0.0 "$node_(771) off" 
$ns at 700.0 "$node_(771) on" 
$node_(772) set X_ 2193 
$node_(772) set Y_ 243 
$node_(772) set Z_ 0.0 
$ns at 0.0 "$node_(772) off" 
$ns at 700.0 "$node_(772) on" 
$node_(773) set X_ 822 
$node_(773) set Y_ 425 
$node_(773) set Z_ 0.0 
$ns at 0.0 "$node_(773) off" 
$ns at 700.0 "$node_(773) on" 
$node_(774) set X_ 53 
$node_(774) set Y_ 559 
$node_(774) set Z_ 0.0 
$ns at 0.0 "$node_(774) off" 
$ns at 700.0 "$node_(774) on" 
$node_(775) set X_ 2542 
$node_(775) set Y_ 356 
$node_(775) set Z_ 0.0 
$ns at 0.0 "$node_(775) off" 
$ns at 700.0 "$node_(775) on" 
$node_(776) set X_ 2529 
$node_(776) set Y_ 77 
$node_(776) set Z_ 0.0 
$ns at 0.0 "$node_(776) off" 
$ns at 700.0 "$node_(776) on" 
$node_(777) set X_ 2876 
$node_(777) set Y_ 117 
$node_(777) set Z_ 0.0 
$ns at 0.0 "$node_(777) off" 
$ns at 700.0 "$node_(777) on" 
$node_(778) set X_ 2365 
$node_(778) set Y_ 504 
$node_(778) set Z_ 0.0 
$ns at 0.0 "$node_(778) off" 
$ns at 700.0 "$node_(778) on" 
$node_(779) set X_ 1488 
$node_(779) set Y_ 917 
$node_(779) set Z_ 0.0 
$ns at 0.0 "$node_(779) off" 
$ns at 700.0 "$node_(779) on" 
$node_(780) set X_ 1583 
$node_(780) set Y_ 597 
$node_(780) set Z_ 0.0 
$ns at 0.0 "$node_(780) off" 
$ns at 700.0 "$node_(780) on" 
$node_(781) set X_ 2108 
$node_(781) set Y_ 337 
$node_(781) set Z_ 0.0 
$ns at 0.0 "$node_(781) off" 
$ns at 700.0 "$node_(781) on" 
$node_(782) set X_ 1535 
$node_(782) set Y_ 495 
$node_(782) set Z_ 0.0 
$ns at 0.0 "$node_(782) off" 
$ns at 700.0 "$node_(782) on" 
$node_(783) set X_ 2996 
$node_(783) set Y_ 318 
$node_(783) set Z_ 0.0 
$ns at 0.0 "$node_(783) off" 
$ns at 700.0 "$node_(783) on" 
$node_(784) set X_ 641 
$node_(784) set Y_ 816 
$node_(784) set Z_ 0.0 
$ns at 0.0 "$node_(784) off" 
$ns at 700.0 "$node_(784) on" 
$node_(785) set X_ 1116 
$node_(785) set Y_ 357 
$node_(785) set Z_ 0.0 
$ns at 0.0 "$node_(785) off" 
$ns at 700.0 "$node_(785) on" 
$node_(786) set X_ 529 
$node_(786) set Y_ 201 
$node_(786) set Z_ 0.0 
$ns at 0.0 "$node_(786) off" 
$ns at 700.0 "$node_(786) on" 
$node_(787) set X_ 461 
$node_(787) set Y_ 347 
$node_(787) set Z_ 0.0 
$ns at 0.0 "$node_(787) off" 
$ns at 700.0 "$node_(787) on" 
$node_(788) set X_ 2520 
$node_(788) set Y_ 699 
$node_(788) set Z_ 0.0 
$ns at 0.0 "$node_(788) off" 
$ns at 700.0 "$node_(788) on" 
$node_(789) set X_ 1688 
$node_(789) set Y_ 251 
$node_(789) set Z_ 0.0 
$ns at 0.0 "$node_(789) off" 
$ns at 700.0 "$node_(789) on" 
$node_(790) set X_ 2394 
$node_(790) set Y_ 339 
$node_(790) set Z_ 0.0 
$ns at 0.0 "$node_(790) off" 
$ns at 700.0 "$node_(790) on" 
$node_(791) set X_ 1200 
$node_(791) set Y_ 127 
$node_(791) set Z_ 0.0 
$ns at 0.0 "$node_(791) off" 
$ns at 700.0 "$node_(791) on" 
$node_(792) set X_ 2086 
$node_(792) set Y_ 304 
$node_(792) set Z_ 0.0 
$ns at 0.0 "$node_(792) off" 
$ns at 700.0 "$node_(792) on" 
$node_(793) set X_ 2002 
$node_(793) set Y_ 101 
$node_(793) set Z_ 0.0 
$ns at 0.0 "$node_(793) off" 
$ns at 700.0 "$node_(793) on" 
$node_(794) set X_ 1366 
$node_(794) set Y_ 335 
$node_(794) set Z_ 0.0 
$ns at 0.0 "$node_(794) off" 
$ns at 700.0 "$node_(794) on" 
$node_(795) set X_ 2055 
$node_(795) set Y_ 513 
$node_(795) set Z_ 0.0 
$ns at 0.0 "$node_(795) off" 
$ns at 700.0 "$node_(795) on" 
$node_(796) set X_ 2700 
$node_(796) set Y_ 409 
$node_(796) set Z_ 0.0 
$ns at 0.0 "$node_(796) off" 
$ns at 700.0 "$node_(796) on" 
$node_(797) set X_ 1481 
$node_(797) set Y_ 856 
$node_(797) set Z_ 0.0 
$ns at 0.0 "$node_(797) off" 
$ns at 700.0 "$node_(797) on" 
$node_(798) set X_ 362 
$node_(798) set Y_ 256 
$node_(798) set Z_ 0.0 
$ns at 0.0 "$node_(798) off" 
$ns at 700.0 "$node_(798) on" 
$node_(799) set X_ 2816 
$node_(799) set Y_ 81 
$node_(799) set Z_ 0.0 
$ns at 0.0 "$node_(799) off" 
$ns at 700.0 "$node_(799) on" 

# Generation of movements
$ns at 0.0 "$node_(0) setdest 13278 31535 17.0" 
$ns at 120.4107406961987 "$node_(0) setdest 48725 745 4.0" 
$ns at 152.08576429988312 "$node_(0) setdest 69290 12049 17.0" 
$ns at 307.0844127708746 "$node_(0) setdest 78178 10217 15.0" 
$ns at 436.33821664390985 "$node_(0) setdest 119113 3653 11.0" 
$ns at 542.314746614031 "$node_(0) setdest 127033 54414 12.0" 
$ns at 574.7927411619282 "$node_(0) setdest 56260 61888 17.0" 
$ns at 646.9989388659106 "$node_(0) setdest 22422 74871 12.0" 
$ns at 700.1112369527592 "$node_(0) setdest 44563 38053 20.0" 
$ns at 844.1404027173382 "$node_(0) setdest 42425 62603 10.0" 
$ns at 891.8990887246274 "$node_(0) setdest 67532 2363 4.0" 
$ns at 0.0 "$node_(1) setdest 25854 9913 1.0" 
$ns at 31.690412173459073 "$node_(1) setdest 39275 17601 3.0" 
$ns at 76.78437871778004 "$node_(1) setdest 24665 29104 1.0" 
$ns at 116.66268059281381 "$node_(1) setdest 40280 24190 9.0" 
$ns at 200.06664694940247 "$node_(1) setdest 112 7779 11.0" 
$ns at 314.2288684896077 "$node_(1) setdest 113749 38888 20.0" 
$ns at 415.21413513415945 "$node_(1) setdest 18773 30513 2.0" 
$ns at 449.3355683529641 "$node_(1) setdest 25701 7790 3.0" 
$ns at 497.78745372856156 "$node_(1) setdest 205428 66167 6.0" 
$ns at 528.7816793575762 "$node_(1) setdest 38027 21831 9.0" 
$ns at 560.1728189886644 "$node_(1) setdest 18964 35998 9.0" 
$ns at 619.3968439515442 "$node_(1) setdest 58471 58471 5.0" 
$ns at 662.3390419679995 "$node_(1) setdest 92135 206 9.0" 
$ns at 708.4835996255333 "$node_(1) setdest 98465 71080 14.0" 
$ns at 835.424115937674 "$node_(1) setdest 267046 59606 5.0" 
$ns at 888.3140869739376 "$node_(1) setdest 224754 31024 3.0" 
$ns at 0.0 "$node_(2) setdest 3841 7328 10.0" 
$ns at 106.40553086636189 "$node_(2) setdest 65882 15081 9.0" 
$ns at 181.87721684264696 "$node_(2) setdest 101693 18550 10.0" 
$ns at 226.95309201333728 "$node_(2) setdest 8946 37804 19.0" 
$ns at 381.74340726259766 "$node_(2) setdest 87839 46589 3.0" 
$ns at 434.11561668081185 "$node_(2) setdest 46911 32616 19.0" 
$ns at 631.2467631600507 "$node_(2) setdest 58434 76362 13.0" 
$ns at 741.3123731514206 "$node_(2) setdest 210683 76990 2.0" 
$ns at 776.7577683412344 "$node_(2) setdest 13519 49224 16.0" 
$ns at 878.7804760753122 "$node_(2) setdest 246885 44055 9.0" 
$ns at 0.0 "$node_(3) setdest 69739 4360 13.0" 
$ns at 146.17495851477995 "$node_(3) setdest 57787 5314 1.0" 
$ns at 178.65895278173298 "$node_(3) setdest 40693 29256 4.0" 
$ns at 233.2664011533077 "$node_(3) setdest 88145 6492 5.0" 
$ns at 289.3469210155365 "$node_(3) setdest 56319 14185 12.0" 
$ns at 372.116072483546 "$node_(3) setdest 173586 34982 8.0" 
$ns at 462.50088393072724 "$node_(3) setdest 59791 61441 7.0" 
$ns at 501.494453629916 "$node_(3) setdest 169743 65060 3.0" 
$ns at 559.562863677247 "$node_(3) setdest 37410 48577 1.0" 
$ns at 595.9421231192612 "$node_(3) setdest 28045 45440 6.0" 
$ns at 673.8697031587141 "$node_(3) setdest 229107 9128 7.0" 
$ns at 769.7080152372821 "$node_(3) setdest 233636 41020 11.0" 
$ns at 865.586524809497 "$node_(3) setdest 104629 25401 7.0" 
$ns at 0.0 "$node_(4) setdest 81824 23543 1.0" 
$ns at 31.60999532999673 "$node_(4) setdest 59631 15850 19.0" 
$ns at 185.8421539852475 "$node_(4) setdest 41088 25543 1.0" 
$ns at 220.0085338982183 "$node_(4) setdest 11490 981 15.0" 
$ns at 358.546719259651 "$node_(4) setdest 133163 39415 18.0" 
$ns at 547.2927644157314 "$node_(4) setdest 177868 61133 19.0" 
$ns at 631.9370941370596 "$node_(4) setdest 152383 15475 8.0" 
$ns at 724.7288983152836 "$node_(4) setdest 247191 82346 5.0" 
$ns at 784.5067628762949 "$node_(4) setdest 130528 29874 6.0" 
$ns at 862.4562281222852 "$node_(4) setdest 196347 4975 2.0" 
$ns at 0.0 "$node_(5) setdest 69372 27479 7.0" 
$ns at 71.35304832726627 "$node_(5) setdest 86468 11971 1.0" 
$ns at 107.3007064538674 "$node_(5) setdest 87115 20092 4.0" 
$ns at 162.71861390388992 "$node_(5) setdest 122449 30229 15.0" 
$ns at 237.15052885645926 "$node_(5) setdest 29064 5582 9.0" 
$ns at 268.3442379167403 "$node_(5) setdest 43616 44029 11.0" 
$ns at 390.7914433475873 "$node_(5) setdest 157118 19214 1.0" 
$ns at 422.1664974128731 "$node_(5) setdest 69804 40659 12.0" 
$ns at 468.6458808444756 "$node_(5) setdest 49532 32698 18.0" 
$ns at 611.1701735283314 "$node_(5) setdest 21688 53484 4.0" 
$ns at 677.10351425994 "$node_(5) setdest 165010 20315 4.0" 
$ns at 737.7283386093977 "$node_(5) setdest 66650 10370 11.0" 
$ns at 832.7891381055844 "$node_(5) setdest 97663 21600 16.0" 
$ns at 0.0 "$node_(6) setdest 22872 11176 13.0" 
$ns at 130.63982857743727 "$node_(6) setdest 61419 26257 18.0" 
$ns at 238.76819888561027 "$node_(6) setdest 11606 14950 18.0" 
$ns at 338.2256957290908 "$node_(6) setdest 103624 4953 10.0" 
$ns at 407.42547757410784 "$node_(6) setdest 16857 10060 3.0" 
$ns at 462.40182521086365 "$node_(6) setdest 49802 292 1.0" 
$ns at 500.4235053915893 "$node_(6) setdest 124687 49320 19.0" 
$ns at 709.9319171552672 "$node_(6) setdest 234287 24972 3.0" 
$ns at 763.5474345131964 "$node_(6) setdest 98658 27294 15.0" 
$ns at 814.852501006909 "$node_(6) setdest 41478 52412 9.0" 
$ns at 0.0 "$node_(7) setdest 9270 27501 1.0" 
$ns at 33.84615568275933 "$node_(7) setdest 42081 22018 4.0" 
$ns at 70.28713107396335 "$node_(7) setdest 52983 22578 19.0" 
$ns at 241.96384680084446 "$node_(7) setdest 100678 15364 13.0" 
$ns at 350.37652598414144 "$node_(7) setdest 122074 8016 4.0" 
$ns at 407.77998822087125 "$node_(7) setdest 86261 33178 16.0" 
$ns at 455.0104103280216 "$node_(7) setdest 79092 38097 10.0" 
$ns at 520.7562695770725 "$node_(7) setdest 210268 20580 10.0" 
$ns at 591.9502031415166 "$node_(7) setdest 95276 47659 14.0" 
$ns at 696.9912559593561 "$node_(7) setdest 47801 66230 6.0" 
$ns at 759.4947499160655 "$node_(7) setdest 218918 70095 1.0" 
$ns at 799.3408725317307 "$node_(7) setdest 186601 65093 5.0" 
$ns at 834.8391197619261 "$node_(7) setdest 8664 86417 9.0" 
$ns at 897.2310696467356 "$node_(7) setdest 18835 55281 19.0" 
$ns at 0.0 "$node_(8) setdest 31417 16972 4.0" 
$ns at 69.02099502351261 "$node_(8) setdest 43825 16294 20.0" 
$ns at 244.4533625130701 "$node_(8) setdest 29239 34524 11.0" 
$ns at 275.601902909476 "$node_(8) setdest 152899 3889 4.0" 
$ns at 332.63489226023603 "$node_(8) setdest 86732 17309 15.0" 
$ns at 511.67072516171993 "$node_(8) setdest 171478 6543 5.0" 
$ns at 559.2701154983426 "$node_(8) setdest 47192 33112 8.0" 
$ns at 640.9928987950899 "$node_(8) setdest 163725 76358 10.0" 
$ns at 738.5331163541497 "$node_(8) setdest 248330 2489 18.0" 
$ns at 843.5347108846591 "$node_(8) setdest 4258 65264 15.0" 
$ns at 0.0 "$node_(9) setdest 51211 26348 19.0" 
$ns at 83.65086761927942 "$node_(9) setdest 5518 8730 14.0" 
$ns at 208.8014796920083 "$node_(9) setdest 89188 2177 10.0" 
$ns at 305.06642737847875 "$node_(9) setdest 29848 28461 18.0" 
$ns at 461.3719863369742 "$node_(9) setdest 151824 32715 12.0" 
$ns at 552.946753128263 "$node_(9) setdest 112242 18015 15.0" 
$ns at 707.1992982307252 "$node_(9) setdest 85719 74679 1.0" 
$ns at 746.6026106926856 "$node_(9) setdest 245449 50904 15.0" 
$ns at 847.0834288315751 "$node_(9) setdest 28278 26182 10.0" 
$ns at 0.0 "$node_(10) setdest 32903 9792 7.0" 
$ns at 53.55474715571415 "$node_(10) setdest 66475 938 15.0" 
$ns at 222.52839068813037 "$node_(10) setdest 82926 7310 4.0" 
$ns at 267.70589351113244 "$node_(10) setdest 123918 5316 19.0" 
$ns at 417.37817449903974 "$node_(10) setdest 76011 56949 11.0" 
$ns at 448.0531816975352 "$node_(10) setdest 86173 18293 3.0" 
$ns at 504.10888205012543 "$node_(10) setdest 112488 41040 10.0" 
$ns at 586.7856271290269 "$node_(10) setdest 114687 46715 11.0" 
$ns at 683.1904523749952 "$node_(10) setdest 60972 50216 10.0" 
$ns at 717.0944378299226 "$node_(10) setdest 15959 32449 9.0" 
$ns at 802.2572939771615 "$node_(10) setdest 63666 38273 19.0" 
$ns at 871.8386797863791 "$node_(10) setdest 238569 1094 8.0" 
$ns at 0.0 "$node_(11) setdest 22875 14478 18.0" 
$ns at 147.0231294921574 "$node_(11) setdest 51386 2168 1.0" 
$ns at 177.6183958271759 "$node_(11) setdest 126656 28223 17.0" 
$ns at 355.8546612734379 "$node_(11) setdest 98660 24240 2.0" 
$ns at 394.80449936995814 "$node_(11) setdest 77753 45282 1.0" 
$ns at 434.62141522185 "$node_(11) setdest 158502 22357 12.0" 
$ns at 529.6100894577798 "$node_(11) setdest 70428 27789 18.0" 
$ns at 671.0523811060889 "$node_(11) setdest 22773 31718 17.0" 
$ns at 704.6786336024323 "$node_(11) setdest 187242 45090 4.0" 
$ns at 767.4139215263253 "$node_(11) setdest 78138 36653 15.0" 
$ns at 892.1377383771193 "$node_(11) setdest 16211 31694 15.0" 
$ns at 0.0 "$node_(12) setdest 83008 27727 17.0" 
$ns at 114.98969777062726 "$node_(12) setdest 49493 7252 14.0" 
$ns at 229.4089621946504 "$node_(12) setdest 94231 23645 8.0" 
$ns at 329.2107503644841 "$node_(12) setdest 78015 26934 12.0" 
$ns at 467.82838565212205 "$node_(12) setdest 210291 66531 9.0" 
$ns at 529.0317487809349 "$node_(12) setdest 7052 30603 8.0" 
$ns at 579.2736580881078 "$node_(12) setdest 101815 55624 11.0" 
$ns at 712.2424452139367 "$node_(12) setdest 5593 21254 12.0" 
$ns at 759.5567741437476 "$node_(12) setdest 2958 59021 11.0" 
$ns at 849.8147293674471 "$node_(12) setdest 82567 74322 13.0" 
$ns at 0.0 "$node_(13) setdest 14728 12904 4.0" 
$ns at 58.196911262123486 "$node_(13) setdest 82938 13816 17.0" 
$ns at 211.8072777109873 "$node_(13) setdest 53393 15480 2.0" 
$ns at 253.72208365752897 "$node_(13) setdest 43785 45063 20.0" 
$ns at 423.2487181596798 "$node_(13) setdest 112158 48698 6.0" 
$ns at 500.17423294900317 "$node_(13) setdest 54228 20924 10.0" 
$ns at 613.3301248350184 "$node_(13) setdest 65181 46410 10.0" 
$ns at 658.2013143902487 "$node_(13) setdest 212259 58070 2.0" 
$ns at 693.4147291455404 "$node_(13) setdest 235791 12455 18.0" 
$ns at 890.0288131868851 "$node_(13) setdest 263388 35566 1.0" 
$ns at 0.0 "$node_(14) setdest 5246 23140 19.0" 
$ns at 194.48020059088537 "$node_(14) setdest 76977 34685 9.0" 
$ns at 266.2965446642245 "$node_(14) setdest 50498 5961 12.0" 
$ns at 405.3891250556893 "$node_(14) setdest 133004 44860 3.0" 
$ns at 460.50702615649095 "$node_(14) setdest 68607 4238 13.0" 
$ns at 609.7574759667478 "$node_(14) setdest 24660 6883 8.0" 
$ns at 709.8551650033968 "$node_(14) setdest 189529 49529 15.0" 
$ns at 786.033664129867 "$node_(14) setdest 93119 38137 7.0" 
$ns at 832.7091915588461 "$node_(14) setdest 176601 49719 14.0" 
$ns at 0.0 "$node_(15) setdest 20551 31017 16.0" 
$ns at 70.4219869014455 "$node_(15) setdest 39614 21836 4.0" 
$ns at 128.86609893177098 "$node_(15) setdest 27974 1230 12.0" 
$ns at 162.18584772630476 "$node_(15) setdest 94602 16283 6.0" 
$ns at 195.86747168958513 "$node_(15) setdest 100128 11025 5.0" 
$ns at 274.04465041208005 "$node_(15) setdest 34111 29145 1.0" 
$ns at 312.6423163741801 "$node_(15) setdest 119337 7424 7.0" 
$ns at 351.7319547476867 "$node_(15) setdest 21681 43079 10.0" 
$ns at 392.97947243780527 "$node_(15) setdest 1709 15179 11.0" 
$ns at 446.5089200907321 "$node_(15) setdest 114155 49250 9.0" 
$ns at 495.41884741890243 "$node_(15) setdest 148756 31574 11.0" 
$ns at 635.120494896119 "$node_(15) setdest 186819 38589 18.0" 
$ns at 695.3395542256137 "$node_(15) setdest 38673 39630 4.0" 
$ns at 748.0423307654386 "$node_(15) setdest 1861 19942 11.0" 
$ns at 824.5883400175319 "$node_(15) setdest 117222 55838 14.0" 
$ns at 0.0 "$node_(16) setdest 5407 22370 11.0" 
$ns at 59.96415588107108 "$node_(16) setdest 93552 6509 15.0" 
$ns at 130.7112691674909 "$node_(16) setdest 20243 2864 18.0" 
$ns at 211.07975387393418 "$node_(16) setdest 39301 11755 16.0" 
$ns at 272.88787574377596 "$node_(16) setdest 155924 3901 4.0" 
$ns at 312.4598280922313 "$node_(16) setdest 121891 28290 8.0" 
$ns at 412.99229972195207 "$node_(16) setdest 79789 14216 12.0" 
$ns at 505.6340934133833 "$node_(16) setdest 204661 46334 7.0" 
$ns at 594.1775166785817 "$node_(16) setdest 141285 42989 19.0" 
$ns at 793.5937819492482 "$node_(16) setdest 86814 33236 9.0" 
$ns at 885.464852919765 "$node_(16) setdest 95503 17189 14.0" 
$ns at 0.0 "$node_(17) setdest 36344 24958 15.0" 
$ns at 78.43462007671886 "$node_(17) setdest 76605 16537 9.0" 
$ns at 196.59415555484208 "$node_(17) setdest 65794 7834 13.0" 
$ns at 283.79015130564284 "$node_(17) setdest 159145 14835 20.0" 
$ns at 406.0438762942325 "$node_(17) setdest 155730 5146 16.0" 
$ns at 586.4511086154017 "$node_(17) setdest 90606 23046 7.0" 
$ns at 635.5539160269678 "$node_(17) setdest 117575 24036 2.0" 
$ns at 683.1273166822908 "$node_(17) setdest 51922 12052 11.0" 
$ns at 820.523438339538 "$node_(17) setdest 189628 31245 12.0" 
$ns at 0.0 "$node_(18) setdest 2200 18395 3.0" 
$ns at 39.90727172796643 "$node_(18) setdest 70505 5309 10.0" 
$ns at 125.89399230672713 "$node_(18) setdest 35940 21882 15.0" 
$ns at 257.18982281787436 "$node_(18) setdest 106281 28620 13.0" 
$ns at 339.5432401809621 "$node_(18) setdest 129658 13420 10.0" 
$ns at 413.8640396301777 "$node_(18) setdest 141606 10372 16.0" 
$ns at 521.5857544955688 "$node_(18) setdest 125902 28044 6.0" 
$ns at 558.8801561277477 "$node_(18) setdest 35292 45779 6.0" 
$ns at 608.1426624723989 "$node_(18) setdest 24013 75326 16.0" 
$ns at 679.2260224323263 "$node_(18) setdest 62726 20524 18.0" 
$ns at 715.3968240908081 "$node_(18) setdest 197015 71954 7.0" 
$ns at 768.2632085537456 "$node_(18) setdest 153638 26161 7.0" 
$ns at 798.2789576240164 "$node_(18) setdest 125634 24767 9.0" 
$ns at 879.1572184097629 "$node_(18) setdest 175665 34256 2.0" 
$ns at 0.0 "$node_(19) setdest 77604 29592 18.0" 
$ns at 42.906604325993484 "$node_(19) setdest 70339 1202 3.0" 
$ns at 93.47311579837631 "$node_(19) setdest 52816 11852 1.0" 
$ns at 131.31769168904736 "$node_(19) setdest 43698 17542 17.0" 
$ns at 173.91536095443013 "$node_(19) setdest 23675 43549 3.0" 
$ns at 208.55478887837856 "$node_(19) setdest 110268 25736 9.0" 
$ns at 298.8367913465561 "$node_(19) setdest 21219 23277 8.0" 
$ns at 376.73070253865524 "$node_(19) setdest 29801 45230 9.0" 
$ns at 476.878894083098 "$node_(19) setdest 155414 47969 4.0" 
$ns at 509.4098441594126 "$node_(19) setdest 183349 63057 7.0" 
$ns at 571.842965816843 "$node_(19) setdest 65380 48876 18.0" 
$ns at 653.0856041207766 "$node_(19) setdest 17489 21283 11.0" 
$ns at 738.1474359506184 "$node_(19) setdest 24982 6657 18.0" 
$ns at 871.4623556217048 "$node_(19) setdest 152718 76295 13.0" 
$ns at 0.0 "$node_(20) setdest 49846 22340 15.0" 
$ns at 61.593097610015406 "$node_(20) setdest 63051 14075 19.0" 
$ns at 275.7130825638392 "$node_(20) setdest 10652 6450 9.0" 
$ns at 375.5809799171227 "$node_(20) setdest 143629 5256 2.0" 
$ns at 425.24989475704604 "$node_(20) setdest 38339 12898 10.0" 
$ns at 456.35111038860515 "$node_(20) setdest 171755 26702 7.0" 
$ns at 499.4837716153072 "$node_(20) setdest 128729 24156 15.0" 
$ns at 532.9912019867127 "$node_(20) setdest 9709 41059 10.0" 
$ns at 569.0135178761142 "$node_(20) setdest 168507 16028 2.0" 
$ns at 617.7634043374233 "$node_(20) setdest 114417 68438 1.0" 
$ns at 652.4177431007041 "$node_(20) setdest 249134 18341 10.0" 
$ns at 713.2117691699862 "$node_(20) setdest 58966 48027 12.0" 
$ns at 784.2857793226144 "$node_(20) setdest 42473 79175 18.0" 
$ns at 0.0 "$node_(21) setdest 46989 29956 11.0" 
$ns at 112.97347898890614 "$node_(21) setdest 43438 17792 10.0" 
$ns at 199.40325948591953 "$node_(21) setdest 120297 5135 6.0" 
$ns at 274.7821853253361 "$node_(21) setdest 102451 22644 16.0" 
$ns at 400.1061779381315 "$node_(21) setdest 100231 6733 14.0" 
$ns at 540.0689212974837 "$node_(21) setdest 205657 39988 1.0" 
$ns at 574.0292060092348 "$node_(21) setdest 156637 70451 11.0" 
$ns at 662.7071083794218 "$node_(21) setdest 10472 63003 1.0" 
$ns at 698.0473596466567 "$node_(21) setdest 79691 28438 1.0" 
$ns at 733.1192984841608 "$node_(21) setdest 142860 79844 15.0" 
$ns at 872.5346337147957 "$node_(21) setdest 211061 79557 20.0" 
$ns at 0.0 "$node_(22) setdest 66937 25217 16.0" 
$ns at 180.91443715765737 "$node_(22) setdest 20402 42237 19.0" 
$ns at 272.3614386727894 "$node_(22) setdest 131452 41212 3.0" 
$ns at 329.145644684957 "$node_(22) setdest 39795 1051 1.0" 
$ns at 367.42146601995296 "$node_(22) setdest 34915 24056 4.0" 
$ns at 420.3813035681801 "$node_(22) setdest 73455 56913 4.0" 
$ns at 475.6891585715466 "$node_(22) setdest 151550 11165 16.0" 
$ns at 605.1211564750542 "$node_(22) setdest 59664 65287 10.0" 
$ns at 716.3984985051045 "$node_(22) setdest 14819 54198 9.0" 
$ns at 799.4961102110177 "$node_(22) setdest 108500 19848 3.0" 
$ns at 834.5489442327847 "$node_(22) setdest 258832 3060 1.0" 
$ns at 869.4340344537277 "$node_(22) setdest 102086 24072 1.0" 
$ns at 0.0 "$node_(23) setdest 94344 9258 12.0" 
$ns at 47.87001430154619 "$node_(23) setdest 50204 25421 6.0" 
$ns at 116.23907751919567 "$node_(23) setdest 45034 16272 8.0" 
$ns at 167.16407932266793 "$node_(23) setdest 111508 4218 7.0" 
$ns at 249.55293806992768 "$node_(23) setdest 85431 6881 15.0" 
$ns at 303.51487745753633 "$node_(23) setdest 66618 13490 6.0" 
$ns at 343.824914857485 "$node_(23) setdest 32056 12003 1.0" 
$ns at 380.67494006995 "$node_(23) setdest 101468 48298 2.0" 
$ns at 415.1213014381729 "$node_(23) setdest 160853 42791 5.0" 
$ns at 480.8864660939782 "$node_(23) setdest 69269 12374 17.0" 
$ns at 519.5339372835963 "$node_(23) setdest 93069 41437 20.0" 
$ns at 587.1729590183423 "$node_(23) setdest 86668 67472 11.0" 
$ns at 699.1405579288985 "$node_(23) setdest 193171 61780 18.0" 
$ns at 855.3028210488021 "$node_(23) setdest 6504 48962 15.0" 
$ns at 0.0 "$node_(24) setdest 28422 25772 20.0" 
$ns at 33.884372177647236 "$node_(24) setdest 13028 28367 7.0" 
$ns at 75.69015425586349 "$node_(24) setdest 21022 10651 18.0" 
$ns at 119.84871775667911 "$node_(24) setdest 39272 14139 11.0" 
$ns at 188.03796346947018 "$node_(24) setdest 87604 41366 1.0" 
$ns at 221.09399340116713 "$node_(24) setdest 92728 30628 8.0" 
$ns at 267.65059400246275 "$node_(24) setdest 152660 35091 17.0" 
$ns at 356.7444395360333 "$node_(24) setdest 151296 54815 18.0" 
$ns at 391.12648765741875 "$node_(24) setdest 45144 26850 15.0" 
$ns at 501.7966726535898 "$node_(24) setdest 177746 10977 8.0" 
$ns at 565.3361563714393 "$node_(24) setdest 19611 70110 11.0" 
$ns at 670.092875697489 "$node_(24) setdest 5548 81908 2.0" 
$ns at 703.2556523177376 "$node_(24) setdest 80779 8008 16.0" 
$ns at 890.4568491175537 "$node_(24) setdest 106470 67877 2.0" 
$ns at 0.0 "$node_(25) setdest 70197 23696 11.0" 
$ns at 55.40813475534034 "$node_(25) setdest 9303 12535 11.0" 
$ns at 139.6941186650073 "$node_(25) setdest 42381 12369 15.0" 
$ns at 247.50020921288296 "$node_(25) setdest 132211 7502 7.0" 
$ns at 282.9917040415807 "$node_(25) setdest 87591 16320 19.0" 
$ns at 337.69619986088736 "$node_(25) setdest 126751 50318 8.0" 
$ns at 424.1183194421768 "$node_(25) setdest 143815 59736 1.0" 
$ns at 458.12560738100825 "$node_(25) setdest 2021 49805 1.0" 
$ns at 492.35463665177434 "$node_(25) setdest 51575 48478 16.0" 
$ns at 624.7860321956871 "$node_(25) setdest 128949 20830 19.0" 
$ns at 701.5149557112308 "$node_(25) setdest 104080 58078 10.0" 
$ns at 776.202152651014 "$node_(25) setdest 96450 833 14.0" 
$ns at 814.1851583536186 "$node_(25) setdest 182628 37970 9.0" 
$ns at 0.0 "$node_(26) setdest 67922 10048 7.0" 
$ns at 64.59915095278862 "$node_(26) setdest 55247 3800 6.0" 
$ns at 103.82828519214807 "$node_(26) setdest 29794 14148 17.0" 
$ns at 181.60137213138768 "$node_(26) setdest 54766 6084 19.0" 
$ns at 293.9912697148964 "$node_(26) setdest 118483 16211 19.0" 
$ns at 457.88071641176725 "$node_(26) setdest 107674 6681 6.0" 
$ns at 502.09024488359273 "$node_(26) setdest 32120 53146 1.0" 
$ns at 534.1099885513589 "$node_(26) setdest 168411 10228 3.0" 
$ns at 589.605062602408 "$node_(26) setdest 148184 38375 5.0" 
$ns at 632.4734021422445 "$node_(26) setdest 40559 65420 7.0" 
$ns at 669.1720015209645 "$node_(26) setdest 242603 33946 4.0" 
$ns at 702.0473416403472 "$node_(26) setdest 224942 36465 14.0" 
$ns at 830.0478110666559 "$node_(26) setdest 266465 85684 4.0" 
$ns at 888.4181515988557 "$node_(26) setdest 11744 47413 5.0" 
$ns at 0.0 "$node_(27) setdest 18622 8383 15.0" 
$ns at 131.47131540261051 "$node_(27) setdest 64631 15084 3.0" 
$ns at 177.20468819874992 "$node_(27) setdest 79157 29204 1.0" 
$ns at 208.66195496584157 "$node_(27) setdest 50021 41731 16.0" 
$ns at 308.9449553102269 "$node_(27) setdest 57693 50146 9.0" 
$ns at 363.6789545570119 "$node_(27) setdest 13705 25401 15.0" 
$ns at 494.103514612819 "$node_(27) setdest 165415 45479 18.0" 
$ns at 584.0578101397291 "$node_(27) setdest 143869 58985 11.0" 
$ns at 647.1685535990802 "$node_(27) setdest 105489 20975 11.0" 
$ns at 742.0383047611809 "$node_(27) setdest 82912 4762 3.0" 
$ns at 792.4749190218673 "$node_(27) setdest 185672 66020 9.0" 
$ns at 837.9405632552789 "$node_(27) setdest 113908 5846 19.0" 
$ns at 887.9069580340218 "$node_(27) setdest 184126 81219 17.0" 
$ns at 0.0 "$node_(28) setdest 25451 13108 6.0" 
$ns at 82.49381788230731 "$node_(28) setdest 87410 4332 12.0" 
$ns at 226.59079355593673 "$node_(28) setdest 91541 11953 4.0" 
$ns at 259.2300232526212 "$node_(28) setdest 121688 35159 5.0" 
$ns at 333.0720067115582 "$node_(28) setdest 130725 46259 10.0" 
$ns at 421.1015035497287 "$node_(28) setdest 32654 35340 8.0" 
$ns at 523.253104326171 "$node_(28) setdest 39451 21588 19.0" 
$ns at 614.044337829361 "$node_(28) setdest 88558 64792 12.0" 
$ns at 672.57071307942 "$node_(28) setdest 74245 63013 8.0" 
$ns at 747.5884325627289 "$node_(28) setdest 89937 30221 9.0" 
$ns at 827.6059059395942 "$node_(28) setdest 96609 34846 9.0" 
$ns at 0.0 "$node_(29) setdest 67368 30224 14.0" 
$ns at 90.02291856997554 "$node_(29) setdest 31884 2620 18.0" 
$ns at 141.5966993320609 "$node_(29) setdest 62845 4675 20.0" 
$ns at 251.22854799566855 "$node_(29) setdest 94152 47767 7.0" 
$ns at 313.81874296536597 "$node_(29) setdest 105547 46698 15.0" 
$ns at 362.4908606812118 "$node_(29) setdest 39554 11175 14.0" 
$ns at 442.1006448951664 "$node_(29) setdest 9517 22980 8.0" 
$ns at 498.27927694735877 "$node_(29) setdest 112894 51597 3.0" 
$ns at 554.8467330052636 "$node_(29) setdest 19946 22882 15.0" 
$ns at 655.6480875315478 "$node_(29) setdest 201632 42286 2.0" 
$ns at 688.0934182911769 "$node_(29) setdest 186345 31561 6.0" 
$ns at 742.7754602161917 "$node_(29) setdest 65474 13426 9.0" 
$ns at 788.7215386657124 "$node_(29) setdest 88598 20901 13.0" 
$ns at 875.4905878160865 "$node_(29) setdest 84487 67783 6.0" 
$ns at 0.0 "$node_(30) setdest 13721 17575 20.0" 
$ns at 119.5985978640227 "$node_(30) setdest 14897 25090 14.0" 
$ns at 191.29478131652996 "$node_(30) setdest 18997 13481 3.0" 
$ns at 227.25949185068674 "$node_(30) setdest 37387 35541 5.0" 
$ns at 300.7702544672394 "$node_(30) setdest 120408 45030 13.0" 
$ns at 437.77344607124917 "$node_(30) setdest 120409 711 12.0" 
$ns at 550.8326381604994 "$node_(30) setdest 15111 4582 9.0" 
$ns at 589.9323734789748 "$node_(30) setdest 102515 74809 5.0" 
$ns at 636.218450105511 "$node_(30) setdest 92150 15881 1.0" 
$ns at 667.9339959901616 "$node_(30) setdest 212446 74184 1.0" 
$ns at 700.8648085685832 "$node_(30) setdest 108787 39642 13.0" 
$ns at 814.9473811269787 "$node_(30) setdest 257924 25940 18.0" 
$ns at 0.0 "$node_(31) setdest 70164 27680 5.0" 
$ns at 46.90871942493385 "$node_(31) setdest 93845 7331 20.0" 
$ns at 166.64971736414594 "$node_(31) setdest 78333 6144 17.0" 
$ns at 204.9227748405055 "$node_(31) setdest 59543 44690 13.0" 
$ns at 244.38040295973158 "$node_(31) setdest 112259 7654 18.0" 
$ns at 299.51100654007007 "$node_(31) setdest 113535 14296 16.0" 
$ns at 373.51618686766346 "$node_(31) setdest 148163 45757 8.0" 
$ns at 469.82380683418455 "$node_(31) setdest 64809 66845 2.0" 
$ns at 499.8604556886236 "$node_(31) setdest 201142 7871 15.0" 
$ns at 593.912336881803 "$node_(31) setdest 227679 28409 6.0" 
$ns at 679.9780081761512 "$node_(31) setdest 87026 15258 5.0" 
$ns at 758.442612522385 "$node_(31) setdest 260890 33068 12.0" 
$ns at 804.0967134686816 "$node_(31) setdest 185404 80213 17.0" 
$ns at 0.0 "$node_(32) setdest 31807 16099 1.0" 
$ns at 33.39873050957011 "$node_(32) setdest 47301 5509 16.0" 
$ns at 81.50206216099167 "$node_(32) setdest 38810 16997 10.0" 
$ns at 169.26627364636494 "$node_(32) setdest 22414 40283 8.0" 
$ns at 240.70936778605892 "$node_(32) setdest 43160 32119 4.0" 
$ns at 302.10946008690854 "$node_(32) setdest 64598 13180 1.0" 
$ns at 335.2777633601164 "$node_(32) setdest 79152 40196 3.0" 
$ns at 385.1236824459427 "$node_(32) setdest 104154 40898 12.0" 
$ns at 531.6645319365641 "$node_(32) setdest 64309 14864 18.0" 
$ns at 741.6500078465194 "$node_(32) setdest 220281 17941 8.0" 
$ns at 839.8852137535038 "$node_(32) setdest 174506 11107 5.0" 
$ns at 875.1620301257084 "$node_(32) setdest 166856 24566 1.0" 
$ns at 0.0 "$node_(33) setdest 70290 19493 7.0" 
$ns at 39.295643563151 "$node_(33) setdest 42552 11632 20.0" 
$ns at 182.07728874138417 "$node_(33) setdest 66490 43702 9.0" 
$ns at 249.90998635759183 "$node_(33) setdest 105080 44565 6.0" 
$ns at 304.8323508428678 "$node_(33) setdest 94108 45226 10.0" 
$ns at 350.55698411162405 "$node_(33) setdest 173971 50521 17.0" 
$ns at 425.85453901955844 "$node_(33) setdest 109308 47550 12.0" 
$ns at 571.2668822243286 "$node_(33) setdest 232200 2982 2.0" 
$ns at 603.5593760673977 "$node_(33) setdest 40454 72837 10.0" 
$ns at 654.1091330712145 "$node_(33) setdest 70477 46491 9.0" 
$ns at 747.7233283448935 "$node_(33) setdest 29751 45744 5.0" 
$ns at 785.9292249457227 "$node_(33) setdest 58538 51226 9.0" 
$ns at 874.4503585785828 "$node_(33) setdest 107783 75552 13.0" 
$ns at 0.0 "$node_(34) setdest 28913 5 14.0" 
$ns at 109.34976088234552 "$node_(34) setdest 3735 13084 5.0" 
$ns at 161.83519365275083 "$node_(34) setdest 99412 6114 14.0" 
$ns at 261.61920585939333 "$node_(34) setdest 35944 48635 19.0" 
$ns at 324.82371063463273 "$node_(34) setdest 50367 49760 20.0" 
$ns at 358.9097980863598 "$node_(34) setdest 151578 2154 11.0" 
$ns at 423.43798065347244 "$node_(34) setdest 9270 2612 11.0" 
$ns at 538.0345462215877 "$node_(34) setdest 85381 12680 15.0" 
$ns at 584.9298339311605 "$node_(34) setdest 151122 62826 16.0" 
$ns at 669.6110576381162 "$node_(34) setdest 147345 21592 8.0" 
$ns at 706.4883428410458 "$node_(34) setdest 147531 22319 5.0" 
$ns at 775.2777801649335 "$node_(34) setdest 223668 89177 3.0" 
$ns at 812.9225365023257 "$node_(34) setdest 120125 6274 20.0" 
$ns at 855.5253092451132 "$node_(34) setdest 91627 745 14.0" 
$ns at 0.0 "$node_(35) setdest 959 10982 11.0" 
$ns at 74.83776708065749 "$node_(35) setdest 82303 25628 4.0" 
$ns at 141.8912891740533 "$node_(35) setdest 91540 6194 6.0" 
$ns at 182.92160362660044 "$node_(35) setdest 13085 2047 9.0" 
$ns at 225.20951443214977 "$node_(35) setdest 50078 33251 4.0" 
$ns at 287.2401562644528 "$node_(35) setdest 47403 22752 11.0" 
$ns at 322.8674025798299 "$node_(35) setdest 39088 49335 1.0" 
$ns at 362.1792098882284 "$node_(35) setdest 32308 6282 11.0" 
$ns at 452.9361641913158 "$node_(35) setdest 168719 14416 14.0" 
$ns at 596.5496000556423 "$node_(35) setdest 80035 52906 18.0" 
$ns at 800.4060182069795 "$node_(35) setdest 105609 35075 19.0" 
$ns at 0.0 "$node_(36) setdest 63425 27154 1.0" 
$ns at 34.02909094552474 "$node_(36) setdest 6442 19399 17.0" 
$ns at 198.30004150098256 "$node_(36) setdest 48965 18853 19.0" 
$ns at 258.52471649210196 "$node_(36) setdest 29401 22092 16.0" 
$ns at 410.8828893924983 "$node_(36) setdest 159594 20898 16.0" 
$ns at 481.3694640788429 "$node_(36) setdest 153920 58821 15.0" 
$ns at 534.4155106964639 "$node_(36) setdest 97788 60228 1.0" 
$ns at 568.7814175084259 "$node_(36) setdest 45659 35835 9.0" 
$ns at 688.0255019932674 "$node_(36) setdest 189446 4807 14.0" 
$ns at 754.1793413071399 "$node_(36) setdest 19584 1689 2.0" 
$ns at 789.4612236666615 "$node_(36) setdest 216310 17464 13.0" 
$ns at 821.0729714662523 "$node_(36) setdest 93170 80570 2.0" 
$ns at 861.1045561036248 "$node_(36) setdest 215851 62754 19.0" 
$ns at 0.0 "$node_(37) setdest 63407 30002 7.0" 
$ns at 37.1005227444483 "$node_(37) setdest 64 27718 2.0" 
$ns at 67.60895715188101 "$node_(37) setdest 93006 3066 1.0" 
$ns at 100.95182395955013 "$node_(37) setdest 52695 15484 15.0" 
$ns at 270.96966171875044 "$node_(37) setdest 125628 44492 3.0" 
$ns at 308.221741033424 "$node_(37) setdest 2798 45889 6.0" 
$ns at 397.1449273478639 "$node_(37) setdest 47475 29248 5.0" 
$ns at 471.2730032793734 "$node_(37) setdest 88629 1591 1.0" 
$ns at 502.96562066260987 "$node_(37) setdest 43848 565 11.0" 
$ns at 602.7479353159619 "$node_(37) setdest 52902 36234 1.0" 
$ns at 638.9926293720708 "$node_(37) setdest 41829 51383 14.0" 
$ns at 740.0921768137364 "$node_(37) setdest 163717 79291 9.0" 
$ns at 774.8956789280719 "$node_(37) setdest 77094 37617 3.0" 
$ns at 825.3068183910323 "$node_(37) setdest 3954 57497 15.0" 
$ns at 0.0 "$node_(38) setdest 88496 18370 10.0" 
$ns at 100.63941963666504 "$node_(38) setdest 19810 31475 20.0" 
$ns at 146.83411384042384 "$node_(38) setdest 5505 21771 15.0" 
$ns at 193.53545720967327 "$node_(38) setdest 61986 17097 1.0" 
$ns at 226.58208357287694 "$node_(38) setdest 105938 22830 20.0" 
$ns at 321.81055965296525 "$node_(38) setdest 147371 48030 19.0" 
$ns at 432.15689708524997 "$node_(38) setdest 113588 60666 8.0" 
$ns at 475.7122021374876 "$node_(38) setdest 133353 43597 2.0" 
$ns at 521.342399687916 "$node_(38) setdest 70848 6987 20.0" 
$ns at 618.2461491778525 "$node_(38) setdest 90089 42445 1.0" 
$ns at 657.9617446919799 "$node_(38) setdest 186527 52993 18.0" 
$ns at 793.7892874880613 "$node_(38) setdest 242829 50850 3.0" 
$ns at 839.9708278552484 "$node_(38) setdest 92399 46441 15.0" 
$ns at 0.0 "$node_(39) setdest 52053 10545 9.0" 
$ns at 35.6709668290184 "$node_(39) setdest 72342 18867 4.0" 
$ns at 100.57474206098664 "$node_(39) setdest 90179 7857 5.0" 
$ns at 151.8990579916539 "$node_(39) setdest 119797 17244 13.0" 
$ns at 239.8780291865993 "$node_(39) setdest 81833 18645 11.0" 
$ns at 311.0544569552954 "$node_(39) setdest 83004 24095 14.0" 
$ns at 394.803374420239 "$node_(39) setdest 135481 35546 4.0" 
$ns at 451.92761307026353 "$node_(39) setdest 32184 63938 13.0" 
$ns at 573.1545100001495 "$node_(39) setdest 153967 14907 12.0" 
$ns at 662.810694577589 "$node_(39) setdest 123859 14089 16.0" 
$ns at 808.0217478241834 "$node_(39) setdest 9406 47555 9.0" 
$ns at 0.0 "$node_(40) setdest 38492 24166 13.0" 
$ns at 35.508039596170406 "$node_(40) setdest 93842 31002 14.0" 
$ns at 161.64937699319012 "$node_(40) setdest 64185 40167 6.0" 
$ns at 245.68625243976447 "$node_(40) setdest 44044 5867 7.0" 
$ns at 322.5874407190671 "$node_(40) setdest 127020 14563 5.0" 
$ns at 393.88199677275884 "$node_(40) setdest 137837 38318 18.0" 
$ns at 475.55014967066296 "$node_(40) setdest 201606 2937 16.0" 
$ns at 641.7224562323777 "$node_(40) setdest 197398 18098 7.0" 
$ns at 677.6251996589405 "$node_(40) setdest 33088 15718 18.0" 
$ns at 834.0909433250063 "$node_(40) setdest 96509 30511 1.0" 
$ns at 867.405244866078 "$node_(40) setdest 28840 42983 5.0" 
$ns at 0.0 "$node_(41) setdest 4121 5458 9.0" 
$ns at 33.38948774822892 "$node_(41) setdest 71608 28209 1.0" 
$ns at 65.77135058914621 "$node_(41) setdest 52099 22472 14.0" 
$ns at 210.4471663922506 "$node_(41) setdest 104740 10230 9.0" 
$ns at 268.0038273587093 "$node_(41) setdest 77924 22811 18.0" 
$ns at 378.67654527621823 "$node_(41) setdest 28512 10559 17.0" 
$ns at 423.61041204615253 "$node_(41) setdest 149725 41723 15.0" 
$ns at 478.740316357577 "$node_(41) setdest 173116 5736 11.0" 
$ns at 592.7007261280623 "$node_(41) setdest 194540 66344 16.0" 
$ns at 638.7914198341019 "$node_(41) setdest 141831 23987 19.0" 
$ns at 710.7660682280341 "$node_(41) setdest 99897 49072 4.0" 
$ns at 754.3826759322553 "$node_(41) setdest 111122 67317 11.0" 
$ns at 891.0496178722192 "$node_(41) setdest 148393 18561 20.0" 
$ns at 0.0 "$node_(42) setdest 91674 29902 13.0" 
$ns at 120.54409562121525 "$node_(42) setdest 32383 23314 8.0" 
$ns at 162.67502862929177 "$node_(42) setdest 124234 208 18.0" 
$ns at 224.34635796623246 "$node_(42) setdest 59598 1005 4.0" 
$ns at 272.30163413949714 "$node_(42) setdest 8380 4752 1.0" 
$ns at 307.198798686339 "$node_(42) setdest 63500 25434 16.0" 
$ns at 376.3777465887316 "$node_(42) setdest 115130 16444 5.0" 
$ns at 444.4801025219381 "$node_(42) setdest 188406 51854 1.0" 
$ns at 482.5495876615554 "$node_(42) setdest 78043 65651 4.0" 
$ns at 547.3057670405054 "$node_(42) setdest 18880 60005 19.0" 
$ns at 624.6163240834065 "$node_(42) setdest 191955 15959 12.0" 
$ns at 753.9176598103468 "$node_(42) setdest 182905 73771 7.0" 
$ns at 830.6079921415123 "$node_(42) setdest 125513 79061 8.0" 
$ns at 0.0 "$node_(43) setdest 10620 5813 17.0" 
$ns at 133.59138106502812 "$node_(43) setdest 22293 28022 11.0" 
$ns at 172.62891846014685 "$node_(43) setdest 122743 36801 16.0" 
$ns at 316.8791210740223 "$node_(43) setdest 87399 19585 1.0" 
$ns at 347.30281757336405 "$node_(43) setdest 61815 45205 17.0" 
$ns at 478.3985272321803 "$node_(43) setdest 82956 55117 5.0" 
$ns at 535.2813430745749 "$node_(43) setdest 5089 44406 4.0" 
$ns at 577.570063210527 "$node_(43) setdest 153978 58582 7.0" 
$ns at 673.6499117743734 "$node_(43) setdest 136417 75426 2.0" 
$ns at 723.2476368098032 "$node_(43) setdest 85157 30874 12.0" 
$ns at 813.2302048661961 "$node_(43) setdest 228965 59273 12.0" 
$ns at 895.766136367332 "$node_(43) setdest 102165 21386 18.0" 
$ns at 0.0 "$node_(44) setdest 31426 12290 16.0" 
$ns at 174.74243061841014 "$node_(44) setdest 87311 31206 15.0" 
$ns at 259.03009550908627 "$node_(44) setdest 70405 8347 17.0" 
$ns at 308.2947057058168 "$node_(44) setdest 136392 38624 18.0" 
$ns at 454.64152679909716 "$node_(44) setdest 33822 3469 7.0" 
$ns at 513.1787605106775 "$node_(44) setdest 88738 29245 13.0" 
$ns at 633.9475104694616 "$node_(44) setdest 48080 33512 16.0" 
$ns at 770.6996319603669 "$node_(44) setdest 50672 46509 19.0" 
$ns at 0.0 "$node_(45) setdest 59713 23165 20.0" 
$ns at 57.38117572873975 "$node_(45) setdest 67242 25351 20.0" 
$ns at 119.18859743618339 "$node_(45) setdest 38914 27498 10.0" 
$ns at 198.61496225851292 "$node_(45) setdest 105785 21460 7.0" 
$ns at 241.0996759739608 "$node_(45) setdest 44954 24194 6.0" 
$ns at 315.21933882078883 "$node_(45) setdest 159862 16761 16.0" 
$ns at 451.77925106421714 "$node_(45) setdest 199096 63207 7.0" 
$ns at 531.621290147212 "$node_(45) setdest 93118 36401 1.0" 
$ns at 569.103322338879 "$node_(45) setdest 117473 27621 11.0" 
$ns at 643.3990955850451 "$node_(45) setdest 211828 3006 4.0" 
$ns at 689.7330927170425 "$node_(45) setdest 92200 54204 15.0" 
$ns at 756.8996292149118 "$node_(45) setdest 123868 56296 8.0" 
$ns at 856.5398595330273 "$node_(45) setdest 263063 20825 6.0" 
$ns at 894.5168262295156 "$node_(45) setdest 80447 69585 6.0" 
$ns at 0.0 "$node_(46) setdest 49856 23586 12.0" 
$ns at 132.16737658858307 "$node_(46) setdest 88106 18419 2.0" 
$ns at 165.32578141303657 "$node_(46) setdest 2231 6674 8.0" 
$ns at 205.5273698822153 "$node_(46) setdest 35855 42636 18.0" 
$ns at 285.41773707398977 "$node_(46) setdest 25690 35487 4.0" 
$ns at 336.77806003552587 "$node_(46) setdest 100250 44054 3.0" 
$ns at 367.258519409552 "$node_(46) setdest 81161 39786 8.0" 
$ns at 468.0009460886114 "$node_(46) setdest 113677 8547 6.0" 
$ns at 515.8398271605909 "$node_(46) setdest 33890 10378 16.0" 
$ns at 695.0221894456579 "$node_(46) setdest 31877 4435 4.0" 
$ns at 750.2110117663293 "$node_(46) setdest 148876 64449 1.0" 
$ns at 784.8348324106479 "$node_(46) setdest 30794 38022 3.0" 
$ns at 842.9797988248758 "$node_(46) setdest 246098 41872 2.0" 
$ns at 874.9628450219785 "$node_(46) setdest 218077 27580 11.0" 
$ns at 0.0 "$node_(47) setdest 54041 26601 1.0" 
$ns at 34.228295338237096 "$node_(47) setdest 90298 17396 6.0" 
$ns at 106.11078676576216 "$node_(47) setdest 18780 15311 1.0" 
$ns at 138.29799191606554 "$node_(47) setdest 74039 12789 10.0" 
$ns at 221.78865588948725 "$node_(47) setdest 81823 44069 1.0" 
$ns at 261.2370946332903 "$node_(47) setdest 7008 36073 13.0" 
$ns at 309.01524571021724 "$node_(47) setdest 24372 29593 10.0" 
$ns at 413.92381308603666 "$node_(47) setdest 132441 56940 4.0" 
$ns at 471.21895480884103 "$node_(47) setdest 52243 56260 16.0" 
$ns at 600.1002152336449 "$node_(47) setdest 115321 63464 4.0" 
$ns at 649.1932438285784 "$node_(47) setdest 200277 30624 8.0" 
$ns at 718.3405200573566 "$node_(47) setdest 193229 57662 11.0" 
$ns at 762.1865461652828 "$node_(47) setdest 209806 89121 17.0" 
$ns at 861.9191463742054 "$node_(47) setdest 15578 37804 14.0" 
$ns at 893.1059199933738 "$node_(47) setdest 8668 69311 11.0" 
$ns at 0.0 "$node_(48) setdest 40384 26743 6.0" 
$ns at 31.304343626861343 "$node_(48) setdest 83802 21880 14.0" 
$ns at 104.88083548195434 "$node_(48) setdest 55935 2678 15.0" 
$ns at 253.06782920053092 "$node_(48) setdest 30956 2080 7.0" 
$ns at 310.1637856827335 "$node_(48) setdest 35595 11575 16.0" 
$ns at 466.72201846374986 "$node_(48) setdest 9353 1897 10.0" 
$ns at 511.97832072348285 "$node_(48) setdest 1204 38142 15.0" 
$ns at 563.9352166922762 "$node_(48) setdest 2458 35388 15.0" 
$ns at 656.4890851663127 "$node_(48) setdest 104911 18287 13.0" 
$ns at 811.4512288832365 "$node_(48) setdest 101892 63543 4.0" 
$ns at 845.539246284623 "$node_(48) setdest 45097 1715 17.0" 
$ns at 0.0 "$node_(49) setdest 21811 19305 5.0" 
$ns at 30.864994595374995 "$node_(49) setdest 79619 14322 12.0" 
$ns at 128.00279952374228 "$node_(49) setdest 24229 28582 13.0" 
$ns at 201.69302436513317 "$node_(49) setdest 31755 27890 15.0" 
$ns at 369.4531571957582 "$node_(49) setdest 115527 24717 2.0" 
$ns at 401.61085196871085 "$node_(49) setdest 64740 28669 4.0" 
$ns at 453.83145871809074 "$node_(49) setdest 51999 68641 2.0" 
$ns at 491.5262553050011 "$node_(49) setdest 207366 12498 4.0" 
$ns at 525.7707748914798 "$node_(49) setdest 106985 8674 13.0" 
$ns at 659.3129386762364 "$node_(49) setdest 140500 20995 1.0" 
$ns at 697.8761267226782 "$node_(49) setdest 231730 49469 11.0" 
$ns at 800.0334967022072 "$node_(49) setdest 141600 6450 9.0" 
$ns at 833.1613801460742 "$node_(49) setdest 137488 26546 19.0" 
$ns at 0.0 "$node_(50) setdest 31987 4624 15.0" 
$ns at 82.66299778333607 "$node_(50) setdest 93712 23379 4.0" 
$ns at 137.9919714100502 "$node_(50) setdest 11153 19185 13.0" 
$ns at 296.4964401392508 "$node_(50) setdest 114264 22794 1.0" 
$ns at 332.0053532383495 "$node_(50) setdest 59167 12275 6.0" 
$ns at 392.43082427247094 "$node_(50) setdest 41014 1441 16.0" 
$ns at 462.38956935498726 "$node_(50) setdest 52978 21403 18.0" 
$ns at 558.1450930321549 "$node_(50) setdest 207031 35295 4.0" 
$ns at 621.41121369136 "$node_(50) setdest 117259 8331 19.0" 
$ns at 654.5120868976725 "$node_(50) setdest 188830 74267 12.0" 
$ns at 797.1399125336875 "$node_(50) setdest 224144 64201 4.0" 
$ns at 858.5994895137558 "$node_(50) setdest 161746 38901 9.0" 
$ns at 0.0 "$node_(51) setdest 36861 14215 7.0" 
$ns at 99.50271388514881 "$node_(51) setdest 21496 5844 14.0" 
$ns at 249.65711263286858 "$node_(51) setdest 105599 10897 11.0" 
$ns at 280.4240261750856 "$node_(51) setdest 160066 33116 20.0" 
$ns at 497.1412508484019 "$node_(51) setdest 133765 46880 4.0" 
$ns at 535.9921525699392 "$node_(51) setdest 43933 42457 14.0" 
$ns at 677.2042593914574 "$node_(51) setdest 142956 32854 7.0" 
$ns at 716.0533195601852 "$node_(51) setdest 85948 62397 1.0" 
$ns at 752.8652930469525 "$node_(51) setdest 84895 34832 13.0" 
$ns at 0.0 "$node_(52) setdest 45864 14217 14.0" 
$ns at 63.161876611236465 "$node_(52) setdest 19575 2310 5.0" 
$ns at 123.2156376701958 "$node_(52) setdest 83170 2616 8.0" 
$ns at 210.6287227982757 "$node_(52) setdest 23078 9191 10.0" 
$ns at 317.38668619832447 "$node_(52) setdest 112110 18249 2.0" 
$ns at 350.04841291024866 "$node_(52) setdest 46374 22265 7.0" 
$ns at 419.0004904571957 "$node_(52) setdest 151137 19538 1.0" 
$ns at 450.4627038478206 "$node_(52) setdest 200268 4814 5.0" 
$ns at 528.0036092785128 "$node_(52) setdest 151666 11180 2.0" 
$ns at 574.336573789881 "$node_(52) setdest 40740 16092 11.0" 
$ns at 703.4194952925986 "$node_(52) setdest 169050 18943 10.0" 
$ns at 785.2185117924005 "$node_(52) setdest 130699 89203 15.0" 
$ns at 0.0 "$node_(53) setdest 52869 653 5.0" 
$ns at 60.605643107970806 "$node_(53) setdest 77181 24314 12.0" 
$ns at 179.291681286099 "$node_(53) setdest 42132 22288 17.0" 
$ns at 330.3330101979268 "$node_(53) setdest 9503 27298 19.0" 
$ns at 447.08809549670974 "$node_(53) setdest 163406 28664 20.0" 
$ns at 600.1662576433475 "$node_(53) setdest 30666 42056 9.0" 
$ns at 683.1160542251981 "$node_(53) setdest 181951 1253 11.0" 
$ns at 739.6312277391671 "$node_(53) setdest 79490 18513 19.0" 
$ns at 822.4518858606893 "$node_(53) setdest 241122 47807 16.0" 
$ns at 876.4445162351439 "$node_(53) setdest 14498 11874 7.0" 
$ns at 0.0 "$node_(54) setdest 62656 11782 12.0" 
$ns at 87.9856012741944 "$node_(54) setdest 50857 11344 4.0" 
$ns at 122.96685919674007 "$node_(54) setdest 31970 11466 10.0" 
$ns at 192.84923652924257 "$node_(54) setdest 94367 42090 5.0" 
$ns at 239.98427567488508 "$node_(54) setdest 33787 43205 13.0" 
$ns at 314.0964382534187 "$node_(54) setdest 84766 15494 5.0" 
$ns at 352.70845412419584 "$node_(54) setdest 65921 24766 9.0" 
$ns at 446.81918819711416 "$node_(54) setdest 115771 23028 19.0" 
$ns at 569.3750721802182 "$node_(54) setdest 50748 15092 10.0" 
$ns at 680.9820645342506 "$node_(54) setdest 177168 76947 10.0" 
$ns at 739.6285920031894 "$node_(54) setdest 136630 11012 7.0" 
$ns at 776.0489039270255 "$node_(54) setdest 100527 86919 12.0" 
$ns at 824.8541381384666 "$node_(54) setdest 43205 25166 9.0" 
$ns at 858.0000095127876 "$node_(54) setdest 9461 32380 8.0" 
$ns at 0.0 "$node_(55) setdest 24418 22509 5.0" 
$ns at 47.418501706178525 "$node_(55) setdest 27283 5642 15.0" 
$ns at 104.44405329027148 "$node_(55) setdest 41510 6447 2.0" 
$ns at 137.78441019328324 "$node_(55) setdest 90054 6983 15.0" 
$ns at 274.1464242252435 "$node_(55) setdest 104403 44183 6.0" 
$ns at 330.4880018293813 "$node_(55) setdest 67026 49296 18.0" 
$ns at 523.305752315263 "$node_(55) setdest 25503 17090 3.0" 
$ns at 577.1060460732612 "$node_(55) setdest 35448 16625 10.0" 
$ns at 682.363754401948 "$node_(55) setdest 20634 35646 12.0" 
$ns at 769.5592931762975 "$node_(55) setdest 160235 62660 18.0" 
$ns at 802.3672134249982 "$node_(55) setdest 143568 56728 3.0" 
$ns at 838.1073675167155 "$node_(55) setdest 150242 44489 9.0" 
$ns at 0.0 "$node_(56) setdest 49794 2146 9.0" 
$ns at 112.5307954829736 "$node_(56) setdest 1065 29296 1.0" 
$ns at 144.12181179799376 "$node_(56) setdest 83806 26974 18.0" 
$ns at 182.54681090113442 "$node_(56) setdest 127981 10041 17.0" 
$ns at 368.11639585068394 "$node_(56) setdest 2552 46451 4.0" 
$ns at 414.96991382768664 "$node_(56) setdest 104144 20808 16.0" 
$ns at 583.0226235467082 "$node_(56) setdest 103521 76451 6.0" 
$ns at 618.5298492200575 "$node_(56) setdest 197390 66399 7.0" 
$ns at 708.4747912783846 "$node_(56) setdest 38425 26118 5.0" 
$ns at 783.1934615242876 "$node_(56) setdest 203269 60457 1.0" 
$ns at 815.7873647259114 "$node_(56) setdest 232345 66321 2.0" 
$ns at 849.1512843289008 "$node_(56) setdest 17567 63067 4.0" 
$ns at 884.1460882927969 "$node_(56) setdest 232952 72820 12.0" 
$ns at 0.0 "$node_(57) setdest 66017 26882 11.0" 
$ns at 42.07897062074398 "$node_(57) setdest 2014 17392 5.0" 
$ns at 82.94025648982783 "$node_(57) setdest 47794 6554 20.0" 
$ns at 229.4050426892142 "$node_(57) setdest 133938 44115 18.0" 
$ns at 267.2178442772665 "$node_(57) setdest 41677 51340 7.0" 
$ns at 341.1707133139418 "$node_(57) setdest 159332 16399 10.0" 
$ns at 440.62492125893175 "$node_(57) setdest 120429 28536 3.0" 
$ns at 497.981993846704 "$node_(57) setdest 48071 54972 10.0" 
$ns at 583.1732174570022 "$node_(57) setdest 99535 62144 11.0" 
$ns at 679.7686033742746 "$node_(57) setdest 121135 14109 8.0" 
$ns at 782.669076053942 "$node_(57) setdest 50944 38509 3.0" 
$ns at 837.6095934604097 "$node_(57) setdest 225311 15239 7.0" 
$ns at 867.6863561882928 "$node_(57) setdest 15851 58350 5.0" 
$ns at 0.0 "$node_(58) setdest 62463 2542 19.0" 
$ns at 182.128711854192 "$node_(58) setdest 75396 24181 16.0" 
$ns at 269.21645554988396 "$node_(58) setdest 134732 48178 19.0" 
$ns at 344.731073247082 "$node_(58) setdest 85018 4951 14.0" 
$ns at 493.9865045123323 "$node_(58) setdest 25045 18822 3.0" 
$ns at 542.3120501928346 "$node_(58) setdest 87351 57479 18.0" 
$ns at 683.4380055625638 "$node_(58) setdest 193222 34265 20.0" 
$ns at 769.4955339705276 "$node_(58) setdest 229455 13867 6.0" 
$ns at 855.3703749897845 "$node_(58) setdest 75905 39796 16.0" 
$ns at 889.0302831599046 "$node_(58) setdest 263453 34565 17.0" 
$ns at 0.0 "$node_(59) setdest 15932 30905 1.0" 
$ns at 35.69448738865921 "$node_(59) setdest 86256 26877 11.0" 
$ns at 114.85568819181196 "$node_(59) setdest 22233 3616 3.0" 
$ns at 150.70543600254587 "$node_(59) setdest 82839 32178 3.0" 
$ns at 185.75748128485137 "$node_(59) setdest 61382 35705 20.0" 
$ns at 301.9157017904226 "$node_(59) setdest 141929 36196 7.0" 
$ns at 365.86117170082065 "$node_(59) setdest 124455 28845 8.0" 
$ns at 414.4593280402501 "$node_(59) setdest 188714 2397 10.0" 
$ns at 476.90449732753785 "$node_(59) setdest 98983 16691 12.0" 
$ns at 529.2194472747002 "$node_(59) setdest 163089 39688 16.0" 
$ns at 683.4832837342684 "$node_(59) setdest 89557 29600 4.0" 
$ns at 736.8150106470289 "$node_(59) setdest 139293 43681 13.0" 
$ns at 822.9059206203846 "$node_(59) setdest 177226 28019 15.0" 
$ns at 0.0 "$node_(60) setdest 49001 194 13.0" 
$ns at 150.80914634992786 "$node_(60) setdest 117773 1107 17.0" 
$ns at 326.9298202974433 "$node_(60) setdest 106441 40143 4.0" 
$ns at 384.12802676272486 "$node_(60) setdest 137747 5608 10.0" 
$ns at 424.71348201623624 "$node_(60) setdest 146858 26181 1.0" 
$ns at 464.28766870915035 "$node_(60) setdest 144124 54066 16.0" 
$ns at 587.8307122652417 "$node_(60) setdest 204268 60041 18.0" 
$ns at 766.7709566929414 "$node_(60) setdest 265105 35363 12.0" 
$ns at 850.3708609638109 "$node_(60) setdest 100228 56993 1.0" 
$ns at 886.5208538976228 "$node_(60) setdest 110391 27314 3.0" 
$ns at 0.0 "$node_(61) setdest 15883 22120 2.0" 
$ns at 47.37160572795122 "$node_(61) setdest 14969 14012 18.0" 
$ns at 78.17673147849055 "$node_(61) setdest 62561 29123 13.0" 
$ns at 111.87866865275075 "$node_(61) setdest 72585 9072 13.0" 
$ns at 271.33729020175645 "$node_(61) setdest 1227 35221 9.0" 
$ns at 324.3736748381866 "$node_(61) setdest 150119 42932 16.0" 
$ns at 441.85190562897753 "$node_(61) setdest 55485 53740 19.0" 
$ns at 496.6403987473702 "$node_(61) setdest 86390 24135 7.0" 
$ns at 594.6467797810882 "$node_(61) setdest 102169 16084 1.0" 
$ns at 626.3646183717152 "$node_(61) setdest 188940 10877 13.0" 
$ns at 754.1035632351768 "$node_(61) setdest 2818 70018 7.0" 
$ns at 811.7040428322933 "$node_(61) setdest 133080 26043 16.0" 
$ns at 0.0 "$node_(62) setdest 21592 18240 10.0" 
$ns at 65.02683426599933 "$node_(62) setdest 3588 18933 14.0" 
$ns at 103.3979470579498 "$node_(62) setdest 80381 8785 19.0" 
$ns at 203.56509880749982 "$node_(62) setdest 37419 42950 2.0" 
$ns at 246.0203683593022 "$node_(62) setdest 99571 38949 15.0" 
$ns at 418.64714711649015 "$node_(62) setdest 89174 41924 9.0" 
$ns at 466.53900468987837 "$node_(62) setdest 65164 154 9.0" 
$ns at 543.0638794822263 "$node_(62) setdest 57977 6998 10.0" 
$ns at 624.6859809422958 "$node_(62) setdest 12254 18640 15.0" 
$ns at 802.0074299336164 "$node_(62) setdest 161226 60281 6.0" 
$ns at 885.2583340175458 "$node_(62) setdest 267681 56663 18.0" 
$ns at 0.0 "$node_(63) setdest 50098 29108 10.0" 
$ns at 52.13542980686838 "$node_(63) setdest 68824 6276 9.0" 
$ns at 152.04283699256953 "$node_(63) setdest 103502 4108 14.0" 
$ns at 211.88507801467196 "$node_(63) setdest 29269 11080 10.0" 
$ns at 327.73432944714364 "$node_(63) setdest 76901 41260 17.0" 
$ns at 450.5902036847638 "$node_(63) setdest 175767 48710 9.0" 
$ns at 482.09790017692416 "$node_(63) setdest 52028 9931 16.0" 
$ns at 541.7556607256805 "$node_(63) setdest 1512 49205 9.0" 
$ns at 596.1993423345266 "$node_(63) setdest 190513 23614 1.0" 
$ns at 627.1528880793611 "$node_(63) setdest 149785 30709 5.0" 
$ns at 697.6562879937778 "$node_(63) setdest 153825 26438 1.0" 
$ns at 737.314422112091 "$node_(63) setdest 36300 39216 13.0" 
$ns at 776.8534147496808 "$node_(63) setdest 32360 3503 8.0" 
$ns at 868.8453716663902 "$node_(63) setdest 158234 70891 11.0" 
$ns at 0.0 "$node_(64) setdest 2718 8189 15.0" 
$ns at 71.05421952180545 "$node_(64) setdest 58155 17401 13.0" 
$ns at 147.14242757066933 "$node_(64) setdest 29196 5307 18.0" 
$ns at 307.34145423830415 "$node_(64) setdest 138069 23011 4.0" 
$ns at 354.57530069129564 "$node_(64) setdest 147938 30929 14.0" 
$ns at 449.9382124578789 "$node_(64) setdest 2715 48001 10.0" 
$ns at 525.0168399900298 "$node_(64) setdest 189123 53320 17.0" 
$ns at 583.5917789520086 "$node_(64) setdest 38578 70996 12.0" 
$ns at 613.727193865887 "$node_(64) setdest 159505 38986 4.0" 
$ns at 675.6839209305276 "$node_(64) setdest 111587 6495 14.0" 
$ns at 829.5170433383796 "$node_(64) setdest 56130 38480 12.0" 
$ns at 0.0 "$node_(65) setdest 44647 8708 10.0" 
$ns at 41.848103638354104 "$node_(65) setdest 79251 23337 12.0" 
$ns at 114.06688835807 "$node_(65) setdest 30868 14905 18.0" 
$ns at 253.33549289670137 "$node_(65) setdest 42943 12514 11.0" 
$ns at 340.6761052706621 "$node_(65) setdest 88589 46326 2.0" 
$ns at 389.51933522682776 "$node_(65) setdest 27382 56487 2.0" 
$ns at 422.41141611076523 "$node_(65) setdest 131357 43879 3.0" 
$ns at 453.66402133517573 "$node_(65) setdest 133726 1758 10.0" 
$ns at 583.6391653868734 "$node_(65) setdest 114438 44200 1.0" 
$ns at 619.4552335000544 "$node_(65) setdest 60144 9370 3.0" 
$ns at 676.9834567625829 "$node_(65) setdest 110546 48686 11.0" 
$ns at 754.0643843037063 "$node_(65) setdest 263187 8628 13.0" 
$ns at 824.144165765061 "$node_(65) setdest 120455 86087 1.0" 
$ns at 859.4264310572895 "$node_(65) setdest 75496 51620 1.0" 
$ns at 890.3527238558565 "$node_(65) setdest 7205 30290 7.0" 
$ns at 0.0 "$node_(66) setdest 60884 9237 3.0" 
$ns at 41.115912973086466 "$node_(66) setdest 84694 10069 16.0" 
$ns at 93.19225761525288 "$node_(66) setdest 78948 26419 19.0" 
$ns at 200.8660377639938 "$node_(66) setdest 17488 13605 20.0" 
$ns at 283.1495702326065 "$node_(66) setdest 126739 17311 15.0" 
$ns at 430.1454361220508 "$node_(66) setdest 47399 42538 17.0" 
$ns at 573.1474901383947 "$node_(66) setdest 218978 51579 7.0" 
$ns at 654.5490188179524 "$node_(66) setdest 192740 59858 19.0" 
$ns at 793.4688506459352 "$node_(66) setdest 161820 55929 7.0" 
$ns at 833.0732527768663 "$node_(66) setdest 45641 88314 1.0" 
$ns at 866.5167318570666 "$node_(66) setdest 74753 60458 1.0" 
$ns at 0.0 "$node_(67) setdest 34945 30154 18.0" 
$ns at 94.67589208676188 "$node_(67) setdest 26062 13909 1.0" 
$ns at 127.80267106053445 "$node_(67) setdest 1653 2616 2.0" 
$ns at 158.39714762151482 "$node_(67) setdest 26909 14087 2.0" 
$ns at 201.02759028961532 "$node_(67) setdest 40671 34885 15.0" 
$ns at 324.73341000726026 "$node_(67) setdest 121351 20069 16.0" 
$ns at 376.38772037705183 "$node_(67) setdest 12549 50838 9.0" 
$ns at 485.26011640125716 "$node_(67) setdest 31769 52491 18.0" 
$ns at 578.3824746503019 "$node_(67) setdest 86887 4737 12.0" 
$ns at 676.8292962325522 "$node_(67) setdest 63727 11332 2.0" 
$ns at 706.9703837417044 "$node_(67) setdest 227109 77550 7.0" 
$ns at 777.4939849268753 "$node_(67) setdest 233616 5194 15.0" 
$ns at 841.6727940736372 "$node_(67) setdest 203195 42951 19.0" 
$ns at 879.7438414835525 "$node_(67) setdest 258154 85091 15.0" 
$ns at 0.0 "$node_(68) setdest 51897 9600 7.0" 
$ns at 76.0895439231679 "$node_(68) setdest 91431 12576 12.0" 
$ns at 118.54588479963067 "$node_(68) setdest 86007 23356 15.0" 
$ns at 190.9075301307911 "$node_(68) setdest 5735 42754 13.0" 
$ns at 290.66532876996195 "$node_(68) setdest 123091 40706 1.0" 
$ns at 323.66928847273107 "$node_(68) setdest 44533 21340 15.0" 
$ns at 430.1300350533112 "$node_(68) setdest 172816 47104 9.0" 
$ns at 503.1393974456412 "$node_(68) setdest 202088 21612 3.0" 
$ns at 543.7400085992178 "$node_(68) setdest 7407 9454 16.0" 
$ns at 612.7149885587651 "$node_(68) setdest 137732 36892 1.0" 
$ns at 649.810173185481 "$node_(68) setdest 188272 22606 8.0" 
$ns at 728.9750517894219 "$node_(68) setdest 61850 30186 19.0" 
$ns at 805.7728205504758 "$node_(68) setdest 248948 26887 2.0" 
$ns at 840.165856177936 "$node_(68) setdest 63550 53505 11.0" 
$ns at 0.0 "$node_(69) setdest 35028 22864 11.0" 
$ns at 44.144565451008376 "$node_(69) setdest 45461 15490 18.0" 
$ns at 92.21301306456348 "$node_(69) setdest 84364 3299 1.0" 
$ns at 126.6476885674094 "$node_(69) setdest 85416 23454 11.0" 
$ns at 177.82262703762382 "$node_(69) setdest 108205 3833 2.0" 
$ns at 225.01952872234 "$node_(69) setdest 92778 44076 18.0" 
$ns at 345.25266241146915 "$node_(69) setdest 76441 15104 3.0" 
$ns at 394.88366338602566 "$node_(69) setdest 72576 53721 17.0" 
$ns at 511.036809515097 "$node_(69) setdest 208248 19361 11.0" 
$ns at 629.6997073013611 "$node_(69) setdest 226807 46097 7.0" 
$ns at 717.8293081802555 "$node_(69) setdest 34756 41019 4.0" 
$ns at 756.1514286550342 "$node_(69) setdest 169044 53190 15.0" 
$ns at 859.9268093224406 "$node_(69) setdest 144731 58858 15.0" 
$ns at 0.0 "$node_(70) setdest 59418 5160 1.0" 
$ns at 32.85458933494269 "$node_(70) setdest 36911 5683 13.0" 
$ns at 156.3686731645372 "$node_(70) setdest 82440 23198 20.0" 
$ns at 258.2010531109494 "$node_(70) setdest 83828 38612 5.0" 
$ns at 300.8396825173516 "$node_(70) setdest 60451 48672 1.0" 
$ns at 334.10830559332766 "$node_(70) setdest 75772 31930 4.0" 
$ns at 394.33463766791965 "$node_(70) setdest 102816 1984 12.0" 
$ns at 483.9947839045516 "$node_(70) setdest 184258 5933 16.0" 
$ns at 599.6291899364005 "$node_(70) setdest 39720 53764 19.0" 
$ns at 639.1440261381683 "$node_(70) setdest 78278 41412 12.0" 
$ns at 678.9069741800108 "$node_(70) setdest 224360 64827 13.0" 
$ns at 740.5978496024501 "$node_(70) setdest 137615 63790 3.0" 
$ns at 791.8955108028142 "$node_(70) setdest 38986 18711 17.0" 
$ns at 0.0 "$node_(71) setdest 39621 15560 16.0" 
$ns at 182.4437795201646 "$node_(71) setdest 107492 38061 17.0" 
$ns at 269.3629425227974 "$node_(71) setdest 68006 32313 16.0" 
$ns at 443.65723187905826 "$node_(71) setdest 3316 54822 1.0" 
$ns at 481.7818724730472 "$node_(71) setdest 87438 21258 5.0" 
$ns at 559.9861377650166 "$node_(71) setdest 57923 31934 1.0" 
$ns at 595.268284614555 "$node_(71) setdest 160407 67360 20.0" 
$ns at 772.1637929516273 "$node_(71) setdest 185035 54802 3.0" 
$ns at 818.0157581794614 "$node_(71) setdest 249961 17648 10.0" 
$ns at 0.0 "$node_(72) setdest 58397 3619 11.0" 
$ns at 129.43194250483495 "$node_(72) setdest 33085 13237 6.0" 
$ns at 200.7983415495813 "$node_(72) setdest 51030 32577 6.0" 
$ns at 261.07372233020175 "$node_(72) setdest 47878 30262 6.0" 
$ns at 315.2501011586397 "$node_(72) setdest 6453 51196 15.0" 
$ns at 396.2050249399707 "$node_(72) setdest 180255 38993 14.0" 
$ns at 463.5474049188843 "$node_(72) setdest 179934 18924 9.0" 
$ns at 583.2863816502493 "$node_(72) setdest 4885 65858 11.0" 
$ns at 616.7735559272649 "$node_(72) setdest 28535 65949 18.0" 
$ns at 766.037885470482 "$node_(72) setdest 119295 84285 7.0" 
$ns at 827.247211766783 "$node_(72) setdest 52693 54134 13.0" 
$ns at 0.0 "$node_(73) setdest 55007 12853 19.0" 
$ns at 172.4958633344433 "$node_(73) setdest 62434 39704 11.0" 
$ns at 309.87970354087446 "$node_(73) setdest 70633 27342 12.0" 
$ns at 453.5974188851451 "$node_(73) setdest 161204 42465 1.0" 
$ns at 493.16412665512075 "$node_(73) setdest 165528 23043 11.0" 
$ns at 611.862573211062 "$node_(73) setdest 122842 1480 6.0" 
$ns at 681.699320642485 "$node_(73) setdest 91483 2339 11.0" 
$ns at 799.3699684915614 "$node_(73) setdest 154283 78085 3.0" 
$ns at 854.001618049454 "$node_(73) setdest 112291 17608 17.0" 
$ns at 0.0 "$node_(74) setdest 31726 13989 18.0" 
$ns at 132.17708517932056 "$node_(74) setdest 22730 28738 12.0" 
$ns at 244.5265867786488 "$node_(74) setdest 124758 30932 3.0" 
$ns at 303.90054311986205 "$node_(74) setdest 100424 1353 1.0" 
$ns at 339.15997979808617 "$node_(74) setdest 81231 38894 16.0" 
$ns at 503.9452695261124 "$node_(74) setdest 43956 46022 14.0" 
$ns at 623.455028060933 "$node_(74) setdest 115824 75733 13.0" 
$ns at 721.0995745517166 "$node_(74) setdest 85409 75560 9.0" 
$ns at 835.6391717324502 "$node_(74) setdest 19207 20312 20.0" 
$ns at 0.0 "$node_(75) setdest 63133 11728 19.0" 
$ns at 120.62678565781434 "$node_(75) setdest 52652 29103 2.0" 
$ns at 157.9293686741633 "$node_(75) setdest 94491 41329 8.0" 
$ns at 247.6194500005285 "$node_(75) setdest 103918 27290 10.0" 
$ns at 332.5890592159884 "$node_(75) setdest 49491 41583 3.0" 
$ns at 380.05552830660656 "$node_(75) setdest 146476 44646 18.0" 
$ns at 544.4312140393298 "$node_(75) setdest 79883 58425 9.0" 
$ns at 584.5918134901826 "$node_(75) setdest 228387 31906 19.0" 
$ns at 616.6987887741628 "$node_(75) setdest 136894 2698 3.0" 
$ns at 660.7128969610613 "$node_(75) setdest 24848 71991 20.0" 
$ns at 714.2264636063501 "$node_(75) setdest 193477 73675 6.0" 
$ns at 756.2275031859261 "$node_(75) setdest 28123 63200 14.0" 
$ns at 833.9702170582028 "$node_(75) setdest 66659 34730 10.0" 
$ns at 0.0 "$node_(76) setdest 21268 22304 9.0" 
$ns at 118.59543943351332 "$node_(76) setdest 39238 16310 17.0" 
$ns at 253.47207318148338 "$node_(76) setdest 126147 2229 7.0" 
$ns at 334.7503378308243 "$node_(76) setdest 25688 22619 18.0" 
$ns at 414.10426946494795 "$node_(76) setdest 22324 26953 7.0" 
$ns at 455.6714164181447 "$node_(76) setdest 5038 12789 16.0" 
$ns at 634.1674036758272 "$node_(76) setdest 78853 19030 13.0" 
$ns at 665.6234031619656 "$node_(76) setdest 54824 2071 20.0" 
$ns at 730.7112018807725 "$node_(76) setdest 39376 21359 7.0" 
$ns at 828.9723695489158 "$node_(76) setdest 214380 84653 16.0" 
$ns at 0.0 "$node_(77) setdest 26758 19432 16.0" 
$ns at 65.21445651595002 "$node_(77) setdest 66058 11694 12.0" 
$ns at 161.59906811376027 "$node_(77) setdest 44817 11948 2.0" 
$ns at 208.32871487911473 "$node_(77) setdest 54914 15396 2.0" 
$ns at 251.49072677499697 "$node_(77) setdest 137817 51557 3.0" 
$ns at 307.9148872192917 "$node_(77) setdest 80873 12094 16.0" 
$ns at 352.3600737449914 "$node_(77) setdest 8650 18171 7.0" 
$ns at 439.42059543240583 "$node_(77) setdest 37553 59764 19.0" 
$ns at 516.210578410671 "$node_(77) setdest 116813 65366 3.0" 
$ns at 559.1131414853114 "$node_(77) setdest 206905 27987 1.0" 
$ns at 597.2553711809105 "$node_(77) setdest 223933 32097 3.0" 
$ns at 644.7381473969483 "$node_(77) setdest 20569 13489 14.0" 
$ns at 735.6204176415076 "$node_(77) setdest 27020 36193 20.0" 
$ns at 832.0766405174215 "$node_(77) setdest 68717 41012 3.0" 
$ns at 870.1575208326777 "$node_(77) setdest 131377 58635 8.0" 
$ns at 0.0 "$node_(78) setdest 66415 27410 1.0" 
$ns at 39.31257644357303 "$node_(78) setdest 2844 4257 7.0" 
$ns at 95.04397891494784 "$node_(78) setdest 18119 29228 19.0" 
$ns at 218.07373044057994 "$node_(78) setdest 38859 7840 11.0" 
$ns at 352.8317028144029 "$node_(78) setdest 31983 3778 7.0" 
$ns at 417.8514595253491 "$node_(78) setdest 129501 62743 16.0" 
$ns at 543.2248883387201 "$node_(78) setdest 137022 18678 18.0" 
$ns at 622.2096198709847 "$node_(78) setdest 95798 50917 5.0" 
$ns at 679.4768672255426 "$node_(78) setdest 44078 43742 13.0" 
$ns at 816.8353363549107 "$node_(78) setdest 32420 10323 6.0" 
$ns at 876.6850597815478 "$node_(78) setdest 131666 37150 13.0" 
$ns at 0.0 "$node_(79) setdest 46294 8846 8.0" 
$ns at 95.11463844380019 "$node_(79) setdest 64917 16693 11.0" 
$ns at 171.65389102794677 "$node_(79) setdest 36120 21624 6.0" 
$ns at 248.86275087970884 "$node_(79) setdest 5467 25591 2.0" 
$ns at 284.3675555022141 "$node_(79) setdest 83962 44017 3.0" 
$ns at 338.1078275580259 "$node_(79) setdest 144901 19516 9.0" 
$ns at 377.2453139249831 "$node_(79) setdest 176653 1660 4.0" 
$ns at 423.47109147666026 "$node_(79) setdest 7791 37 17.0" 
$ns at 551.9388089708086 "$node_(79) setdest 163295 21301 1.0" 
$ns at 590.2415212597613 "$node_(79) setdest 192775 3472 6.0" 
$ns at 648.9702158099649 "$node_(79) setdest 30386 44174 7.0" 
$ns at 692.2246746115543 "$node_(79) setdest 152326 28445 4.0" 
$ns at 732.8192239008565 "$node_(79) setdest 240372 70249 10.0" 
$ns at 817.3609997274892 "$node_(79) setdest 85762 77768 6.0" 
$ns at 850.0813317670436 "$node_(79) setdest 77343 13292 18.0" 
$ns at 0.0 "$node_(80) setdest 58974 28286 15.0" 
$ns at 116.45803801633497 "$node_(80) setdest 35204 5429 3.0" 
$ns at 151.91195745239042 "$node_(80) setdest 58878 3038 20.0" 
$ns at 237.8430841181193 "$node_(80) setdest 97269 7731 17.0" 
$ns at 402.9889652568072 "$node_(80) setdest 17424 26027 5.0" 
$ns at 456.9460711295356 "$node_(80) setdest 73982 1075 12.0" 
$ns at 596.0068812284751 "$node_(80) setdest 78960 23256 16.0" 
$ns at 676.3459847217238 "$node_(80) setdest 619 81087 16.0" 
$ns at 741.8123548530826 "$node_(80) setdest 240685 71055 11.0" 
$ns at 776.0659000798602 "$node_(80) setdest 214338 30330 5.0" 
$ns at 833.0794125922102 "$node_(80) setdest 192798 31080 10.0" 
$ns at 0.0 "$node_(81) setdest 56194 5606 9.0" 
$ns at 37.87700437200712 "$node_(81) setdest 82370 19988 5.0" 
$ns at 72.90371052801353 "$node_(81) setdest 85901 19144 1.0" 
$ns at 104.70137473500552 "$node_(81) setdest 47401 17365 5.0" 
$ns at 156.79903889538915 "$node_(81) setdest 50834 22931 8.0" 
$ns at 215.2972028567898 "$node_(81) setdest 53020 39993 16.0" 
$ns at 368.6502308519353 "$node_(81) setdest 186916 41153 13.0" 
$ns at 436.6626614682912 "$node_(81) setdest 43330 30255 15.0" 
$ns at 583.3697043078662 "$node_(81) setdest 114659 30431 10.0" 
$ns at 621.3189922157554 "$node_(81) setdest 52962 16446 2.0" 
$ns at 655.2831068462133 "$node_(81) setdest 231927 56973 15.0" 
$ns at 790.5643005492682 "$node_(81) setdest 179616 31834 14.0" 
$ns at 0.0 "$node_(82) setdest 93022 29260 3.0" 
$ns at 53.84045641483416 "$node_(82) setdest 76617 10280 14.0" 
$ns at 105.51086339713467 "$node_(82) setdest 66241 27817 6.0" 
$ns at 136.3206899261823 "$node_(82) setdest 10727 22198 9.0" 
$ns at 216.0199517172315 "$node_(82) setdest 106900 34006 12.0" 
$ns at 317.8038771480633 "$node_(82) setdest 152084 18763 9.0" 
$ns at 430.64105567366914 "$node_(82) setdest 90265 8152 1.0" 
$ns at 470.2710166275003 "$node_(82) setdest 188478 51367 2.0" 
$ns at 511.402566255022 "$node_(82) setdest 135966 21695 4.0" 
$ns at 557.1893607549264 "$node_(82) setdest 180581 73028 14.0" 
$ns at 722.3922515927779 "$node_(82) setdest 200861 28808 5.0" 
$ns at 761.9458565188213 "$node_(82) setdest 156592 85660 15.0" 
$ns at 827.1212858692885 "$node_(82) setdest 31300 72454 4.0" 
$ns at 889.9970588768515 "$node_(82) setdest 261066 5102 1.0" 
$ns at 0.0 "$node_(83) setdest 33901 29184 6.0" 
$ns at 86.624921033189 "$node_(83) setdest 44802 19268 1.0" 
$ns at 116.91636765810576 "$node_(83) setdest 68957 25129 17.0" 
$ns at 206.68644774428793 "$node_(83) setdest 968 24298 9.0" 
$ns at 276.35660048503263 "$node_(83) setdest 135152 44031 19.0" 
$ns at 344.0719172554072 "$node_(83) setdest 106580 10138 15.0" 
$ns at 421.8677790822768 "$node_(83) setdest 38044 23364 4.0" 
$ns at 454.50392945170466 "$node_(83) setdest 144830 24621 3.0" 
$ns at 488.4401428483725 "$node_(83) setdest 61760 45524 2.0" 
$ns at 532.7635319927576 "$node_(83) setdest 78105 58174 6.0" 
$ns at 568.1686029918161 "$node_(83) setdest 151276 69417 17.0" 
$ns at 701.822026445194 "$node_(83) setdest 249293 54943 15.0" 
$ns at 821.1775461015577 "$node_(83) setdest 212184 53995 6.0" 
$ns at 882.2962325323783 "$node_(83) setdest 25787 78280 14.0" 
$ns at 0.0 "$node_(84) setdest 6345 16491 6.0" 
$ns at 79.1256041599971 "$node_(84) setdest 91310 16787 6.0" 
$ns at 141.71772186337336 "$node_(84) setdest 35587 7917 15.0" 
$ns at 215.56984401919559 "$node_(84) setdest 102293 10335 7.0" 
$ns at 313.56691382377414 "$node_(84) setdest 104275 3942 1.0" 
$ns at 348.80083512971964 "$node_(84) setdest 154607 29367 4.0" 
$ns at 410.4995596964547 "$node_(84) setdest 56992 4476 8.0" 
$ns at 457.89786566819924 "$node_(84) setdest 153702 61702 17.0" 
$ns at 636.9905407675128 "$node_(84) setdest 91329 62950 5.0" 
$ns at 668.407279286683 "$node_(84) setdest 215496 71668 8.0" 
$ns at 743.3124414565042 "$node_(84) setdest 196602 8321 18.0" 
$ns at 0.0 "$node_(85) setdest 88827 5442 5.0" 
$ns at 32.97852546073115 "$node_(85) setdest 68332 17988 12.0" 
$ns at 155.14488137578246 "$node_(85) setdest 125535 17783 9.0" 
$ns at 235.23864480484087 "$node_(85) setdest 112896 7134 1.0" 
$ns at 271.9159695678743 "$node_(85) setdest 135499 23390 6.0" 
$ns at 358.1968934187829 "$node_(85) setdest 28942 44960 5.0" 
$ns at 420.0954606673612 "$node_(85) setdest 66417 23902 16.0" 
$ns at 508.4944640739538 "$node_(85) setdest 151827 15325 5.0" 
$ns at 560.8139000854876 "$node_(85) setdest 86598 10306 7.0" 
$ns at 601.353630914127 "$node_(85) setdest 8057 38941 1.0" 
$ns at 636.3682585808972 "$node_(85) setdest 83975 70396 11.0" 
$ns at 737.2699486606895 "$node_(85) setdest 93926 29031 2.0" 
$ns at 777.720317816788 "$node_(85) setdest 244301 44297 2.0" 
$ns at 809.4032491861558 "$node_(85) setdest 135021 28030 5.0" 
$ns at 858.0341513748858 "$node_(85) setdest 105392 5594 19.0" 
$ns at 0.0 "$node_(86) setdest 56816 25838 3.0" 
$ns at 56.59156766375929 "$node_(86) setdest 10653 21440 2.0" 
$ns at 105.68366354554051 "$node_(86) setdest 28560 6065 15.0" 
$ns at 251.90320998143375 "$node_(86) setdest 93538 50854 10.0" 
$ns at 318.018854392072 "$node_(86) setdest 25287 42643 10.0" 
$ns at 441.9154925009323 "$node_(86) setdest 133044 18510 19.0" 
$ns at 650.0860404612619 "$node_(86) setdest 232052 25515 11.0" 
$ns at 765.3317130492691 "$node_(86) setdest 57208 14100 2.0" 
$ns at 803.4550266793042 "$node_(86) setdest 143771 6723 9.0" 
$ns at 860.6055638762729 "$node_(86) setdest 96736 55828 4.0" 
$ns at 0.0 "$node_(87) setdest 57122 23382 12.0" 
$ns at 53.25419852949556 "$node_(87) setdest 75607 15677 4.0" 
$ns at 88.32993382807977 "$node_(87) setdest 76485 20976 19.0" 
$ns at 128.18248652615813 "$node_(87) setdest 33432 3010 10.0" 
$ns at 246.8319663756369 "$node_(87) setdest 81242 7417 8.0" 
$ns at 316.1563992720003 "$node_(87) setdest 140063 44044 4.0" 
$ns at 363.7172956492897 "$node_(87) setdest 1165 9231 12.0" 
$ns at 499.80825307290047 "$node_(87) setdest 72869 33170 15.0" 
$ns at 663.8302234317644 "$node_(87) setdest 98556 72552 3.0" 
$ns at 718.7255142757658 "$node_(87) setdest 84705 5806 12.0" 
$ns at 784.1704954357581 "$node_(87) setdest 175077 82260 10.0" 
$ns at 883.8952655532084 "$node_(87) setdest 251557 26026 14.0" 
$ns at 0.0 "$node_(88) setdest 7825 19913 11.0" 
$ns at 118.98579107732668 "$node_(88) setdest 91068 28490 6.0" 
$ns at 177.96216245898628 "$node_(88) setdest 109552 19462 7.0" 
$ns at 215.47539977159641 "$node_(88) setdest 55650 2997 18.0" 
$ns at 257.03006818761804 "$node_(88) setdest 125249 54654 12.0" 
$ns at 332.77489941776764 "$node_(88) setdest 157416 933 18.0" 
$ns at 402.49745670144057 "$node_(88) setdest 54019 4482 17.0" 
$ns at 498.1378533537421 "$node_(88) setdest 38016 48235 13.0" 
$ns at 590.0743114060932 "$node_(88) setdest 29379 30344 2.0" 
$ns at 628.8718127841124 "$node_(88) setdest 194721 16974 19.0" 
$ns at 669.9163295440228 "$node_(88) setdest 75500 10029 19.0" 
$ns at 761.7739948472145 "$node_(88) setdest 110465 49718 13.0" 
$ns at 893.1039425675704 "$node_(88) setdest 254352 52637 9.0" 
$ns at 0.0 "$node_(89) setdest 53977 11207 9.0" 
$ns at 81.72760449209474 "$node_(89) setdest 37085 12343 8.0" 
$ns at 153.96741236125018 "$node_(89) setdest 57828 1635 5.0" 
$ns at 215.90796000300404 "$node_(89) setdest 118207 2977 11.0" 
$ns at 307.42652305827824 "$node_(89) setdest 120757 41978 20.0" 
$ns at 413.44732665465335 "$node_(89) setdest 146086 58112 9.0" 
$ns at 499.4347074462456 "$node_(89) setdest 55515 37753 18.0" 
$ns at 645.3961818030823 "$node_(89) setdest 22520 55258 20.0" 
$ns at 850.1342833203423 "$node_(89) setdest 38364 65701 5.0" 
$ns at 0.0 "$node_(90) setdest 78767 9402 17.0" 
$ns at 183.77974800662017 "$node_(90) setdest 121907 39785 15.0" 
$ns at 281.05468695815165 "$node_(90) setdest 41135 21708 5.0" 
$ns at 315.578758407057 "$node_(90) setdest 64035 21972 10.0" 
$ns at 400.78489725095113 "$node_(90) setdest 40330 7158 12.0" 
$ns at 539.7343267990477 "$node_(90) setdest 177993 34406 15.0" 
$ns at 638.2899577630035 "$node_(90) setdest 64908 69481 12.0" 
$ns at 703.7589823343943 "$node_(90) setdest 221805 57504 12.0" 
$ns at 793.8235806797007 "$node_(90) setdest 257151 222 1.0" 
$ns at 827.7576540074085 "$node_(90) setdest 45989 53307 16.0" 
$ns at 0.0 "$node_(91) setdest 50865 22410 14.0" 
$ns at 63.801698022959116 "$node_(91) setdest 78319 22034 1.0" 
$ns at 93.8743456777764 "$node_(91) setdest 23237 25831 8.0" 
$ns at 145.51198802574282 "$node_(91) setdest 6745 14647 3.0" 
$ns at 189.45882239288048 "$node_(91) setdest 100732 8816 14.0" 
$ns at 312.77742036452094 "$node_(91) setdest 105959 5930 17.0" 
$ns at 404.29670515350796 "$node_(91) setdest 38361 25501 19.0" 
$ns at 613.1676154126621 "$node_(91) setdest 198384 48902 9.0" 
$ns at 729.1748412278711 "$node_(91) setdest 81858 52270 16.0" 
$ns at 805.6876651806306 "$node_(91) setdest 105708 5003 6.0" 
$ns at 847.7733028760298 "$node_(91) setdest 83521 44463 13.0" 
$ns at 0.0 "$node_(92) setdest 27958 117 10.0" 
$ns at 116.81709137546181 "$node_(92) setdest 44142 17007 5.0" 
$ns at 196.1158516618155 "$node_(92) setdest 80384 44641 10.0" 
$ns at 287.71522344852104 "$node_(92) setdest 145523 12555 17.0" 
$ns at 451.7922028742245 "$node_(92) setdest 137156 10187 17.0" 
$ns at 650.5245969029529 "$node_(92) setdest 158421 1439 12.0" 
$ns at 755.3616932783425 "$node_(92) setdest 18397 6697 13.0" 
$ns at 857.5239544389937 "$node_(92) setdest 35905 66640 1.0" 
$ns at 890.5152328107598 "$node_(92) setdest 231506 28217 1.0" 
$ns at 0.0 "$node_(93) setdest 79468 9244 11.0" 
$ns at 40.643501775138624 "$node_(93) setdest 14918 14306 15.0" 
$ns at 75.87327382472836 "$node_(93) setdest 28882 13854 1.0" 
$ns at 115.29279613882792 "$node_(93) setdest 50176 23945 14.0" 
$ns at 266.4556344419975 "$node_(93) setdest 44902 11953 18.0" 
$ns at 299.795217692026 "$node_(93) setdest 162549 8631 4.0" 
$ns at 355.6362751837232 "$node_(93) setdest 78390 18726 19.0" 
$ns at 510.96994157791113 "$node_(93) setdest 143 49503 13.0" 
$ns at 568.0809530856382 "$node_(93) setdest 175782 9003 4.0" 
$ns at 621.9451525575995 "$node_(93) setdest 31760 69684 1.0" 
$ns at 660.5714434044652 "$node_(93) setdest 12941 72013 9.0" 
$ns at 771.4203560821508 "$node_(93) setdest 66842 55457 6.0" 
$ns at 813.1265420708021 "$node_(93) setdest 140384 42712 12.0" 
$ns at 865.0629926864674 "$node_(93) setdest 68673 33999 2.0" 
$ns at 0.0 "$node_(94) setdest 73839 9502 5.0" 
$ns at 76.65083966923932 "$node_(94) setdest 86582 7272 1.0" 
$ns at 110.2220227027292 "$node_(94) setdest 80307 961 5.0" 
$ns at 190.1763624069635 "$node_(94) setdest 24254 26462 18.0" 
$ns at 379.109432941755 "$node_(94) setdest 112365 6127 16.0" 
$ns at 508.1295899032265 "$node_(94) setdest 11970 50194 14.0" 
$ns at 666.4332971566994 "$node_(94) setdest 248010 56087 15.0" 
$ns at 777.277127292739 "$node_(94) setdest 260981 54097 20.0" 
$ns at 815.4972188791403 "$node_(94) setdest 264867 75479 14.0" 
$ns at 855.0217994176879 "$node_(94) setdest 37121 60395 2.0" 
$ns at 886.6982342617694 "$node_(94) setdest 263443 67437 13.0" 
$ns at 0.0 "$node_(95) setdest 40574 10836 1.0" 
$ns at 37.36460538158385 "$node_(95) setdest 8461 20892 15.0" 
$ns at 180.21080176579235 "$node_(95) setdest 91558 17165 4.0" 
$ns at 226.55215257825117 "$node_(95) setdest 100534 11428 10.0" 
$ns at 282.64362454814375 "$node_(95) setdest 88946 46262 15.0" 
$ns at 390.38627702192525 "$node_(95) setdest 71353 45393 19.0" 
$ns at 521.4059961484295 "$node_(95) setdest 33754 48121 2.0" 
$ns at 564.9871340430209 "$node_(95) setdest 11142 22262 2.0" 
$ns at 612.2363638399102 "$node_(95) setdest 99743 40116 14.0" 
$ns at 710.5604691111135 "$node_(95) setdest 119968 31464 13.0" 
$ns at 754.6722450103958 "$node_(95) setdest 153610 16161 17.0" 
$ns at 0.0 "$node_(96) setdest 71157 15286 9.0" 
$ns at 80.40284221166357 "$node_(96) setdest 19534 27742 12.0" 
$ns at 136.03278666103074 "$node_(96) setdest 53212 13911 12.0" 
$ns at 214.96408178227077 "$node_(96) setdest 34161 8569 1.0" 
$ns at 251.62286862285941 "$node_(96) setdest 156933 40829 17.0" 
$ns at 431.2412525609437 "$node_(96) setdest 60697 17297 9.0" 
$ns at 501.2245333803828 "$node_(96) setdest 168004 1585 17.0" 
$ns at 596.2358656027812 "$node_(96) setdest 85301 67579 14.0" 
$ns at 762.1319960438755 "$node_(96) setdest 116182 76366 8.0" 
$ns at 809.8333344525905 "$node_(96) setdest 227068 9800 2.0" 
$ns at 842.3648206669444 "$node_(96) setdest 103731 46966 17.0" 
$ns at 0.0 "$node_(97) setdest 57791 4180 1.0" 
$ns at 30.54879437367013 "$node_(97) setdest 85416 13919 1.0" 
$ns at 70.41043364438868 "$node_(97) setdest 22372 1441 18.0" 
$ns at 140.1562463729926 "$node_(97) setdest 69990 7272 9.0" 
$ns at 181.6070090419334 "$node_(97) setdest 84987 34266 12.0" 
$ns at 294.18694319684005 "$node_(97) setdest 103193 45147 19.0" 
$ns at 398.15529785835804 "$node_(97) setdest 4159 43744 17.0" 
$ns at 567.2746329833287 "$node_(97) setdest 29629 421 14.0" 
$ns at 619.4258506994975 "$node_(97) setdest 155277 25619 9.0" 
$ns at 725.8422948789071 "$node_(97) setdest 221101 17898 3.0" 
$ns at 769.0604612714111 "$node_(97) setdest 263935 25883 18.0" 
$ns at 809.8241698692535 "$node_(97) setdest 139570 55928 17.0" 
$ns at 0.0 "$node_(98) setdest 80344 8095 20.0" 
$ns at 126.18971641507459 "$node_(98) setdest 65457 24283 16.0" 
$ns at 252.94210299437094 "$node_(98) setdest 43771 48270 5.0" 
$ns at 300.6367076662521 "$node_(98) setdest 154087 11005 9.0" 
$ns at 391.1112668720671 "$node_(98) setdest 141307 44093 13.0" 
$ns at 524.9514564170147 "$node_(98) setdest 96777 1590 13.0" 
$ns at 637.6429823970499 "$node_(98) setdest 222965 36307 17.0" 
$ns at 735.162675486255 "$node_(98) setdest 230290 18986 17.0" 
$ns at 786.8048315315876 "$node_(98) setdest 166971 55837 7.0" 
$ns at 862.0743276356754 "$node_(98) setdest 237836 16212 19.0" 
$ns at 0.0 "$node_(99) setdest 59837 20810 8.0" 
$ns at 69.55730032613474 "$node_(99) setdest 52294 23400 5.0" 
$ns at 140.75803356036073 "$node_(99) setdest 83089 20543 10.0" 
$ns at 211.40583760877746 "$node_(99) setdest 102112 34342 19.0" 
$ns at 243.13118647083633 "$node_(99) setdest 42662 13195 6.0" 
$ns at 313.93772754957365 "$node_(99) setdest 99716 4973 17.0" 
$ns at 351.49472885400826 "$node_(99) setdest 37071 5948 5.0" 
$ns at 429.31932662382553 "$node_(99) setdest 6626 9020 7.0" 
$ns at 479.3299277739031 "$node_(99) setdest 101355 41554 7.0" 
$ns at 519.1295548989956 "$node_(99) setdest 49198 58678 1.0" 
$ns at 549.2473920412184 "$node_(99) setdest 197064 55949 16.0" 
$ns at 608.3295686025231 "$node_(99) setdest 178524 29557 15.0" 
$ns at 668.4786681875687 "$node_(99) setdest 98166 18147 18.0" 
$ns at 776.6658713969042 "$node_(99) setdest 198337 18399 13.0" 
$ns at 865.6300420214241 "$node_(99) setdest 41464 11657 8.0" 
$ns at 0.0 "$node_(100) setdest 52517 886 16.0" 
$ns at 131.95858713097766 "$node_(100) setdest 49896 29605 13.0" 
$ns at 164.7462722545229 "$node_(100) setdest 130682 34760 13.0" 
$ns at 206.6008147325487 "$node_(100) setdest 128603 37426 3.0" 
$ns at 240.9852780846965 "$node_(100) setdest 107458 7034 8.0" 
$ns at 308.53070384744433 "$node_(100) setdest 58687 8706 12.0" 
$ns at 408.3376176835673 "$node_(100) setdest 145045 40408 16.0" 
$ns at 527.1403904428338 "$node_(100) setdest 89487 70146 7.0" 
$ns at 626.3371357700689 "$node_(100) setdest 182974 33175 17.0" 
$ns at 763.3439521664072 "$node_(100) setdest 38414 3071 2.0" 
$ns at 806.2080705753557 "$node_(100) setdest 255519 67881 8.0" 
$ns at 854.2409876894753 "$node_(100) setdest 217972 70653 1.0" 
$ns at 890.1208799794421 "$node_(100) setdest 79368 29886 12.0" 
$ns at 235.23473180681486 "$node_(101) setdest 2370 19636 8.0" 
$ns at 271.18293276359896 "$node_(101) setdest 146389 48839 13.0" 
$ns at 362.99566303403043 "$node_(101) setdest 42095 53244 7.0" 
$ns at 461.8410657152757 "$node_(101) setdest 209564 26094 2.0" 
$ns at 493.188219622922 "$node_(101) setdest 172964 65734 10.0" 
$ns at 579.4221518240338 "$node_(101) setdest 157243 28613 1.0" 
$ns at 613.1914748751797 "$node_(101) setdest 114051 57650 8.0" 
$ns at 652.1108376679443 "$node_(101) setdest 220307 21514 1.0" 
$ns at 691.0962500213527 "$node_(101) setdest 120034 3087 1.0" 
$ns at 727.5608224648307 "$node_(101) setdest 79830 5097 16.0" 
$ns at 821.0274834187508 "$node_(101) setdest 179499 22726 16.0" 
$ns at 117.2204834464403 "$node_(102) setdest 29499 26014 15.0" 
$ns at 174.6102581310703 "$node_(102) setdest 18637 974 3.0" 
$ns at 210.75039169456193 "$node_(102) setdest 68978 33656 13.0" 
$ns at 352.9789218446808 "$node_(102) setdest 173230 38807 9.0" 
$ns at 441.8580062826236 "$node_(102) setdest 10215 52370 2.0" 
$ns at 485.23945571213983 "$node_(102) setdest 1046 53188 1.0" 
$ns at 519.0967123253772 "$node_(102) setdest 44694 63998 16.0" 
$ns at 552.086078034936 "$node_(102) setdest 100444 12917 13.0" 
$ns at 649.2768181146628 "$node_(102) setdest 147609 6691 1.0" 
$ns at 679.7033862403144 "$node_(102) setdest 200694 57805 18.0" 
$ns at 740.3079936683723 "$node_(102) setdest 119329 66305 2.0" 
$ns at 772.272962476936 "$node_(102) setdest 177846 49636 12.0" 
$ns at 110.57246970029337 "$node_(103) setdest 23284 4939 20.0" 
$ns at 310.75887221645706 "$node_(103) setdest 25166 40519 11.0" 
$ns at 396.82077623730555 "$node_(103) setdest 57850 36150 15.0" 
$ns at 486.4282426429642 "$node_(103) setdest 180913 36883 15.0" 
$ns at 619.2408999931145 "$node_(103) setdest 104127 19827 18.0" 
$ns at 740.0623834835731 "$node_(103) setdest 47775 28100 11.0" 
$ns at 807.5751831065492 "$node_(103) setdest 163509 46668 14.0" 
$ns at 847.3497242951279 "$node_(103) setdest 174325 23598 15.0" 
$ns at 126.15565575386682 "$node_(104) setdest 48718 23377 4.0" 
$ns at 189.5364763020292 "$node_(104) setdest 80876 36692 6.0" 
$ns at 262.3495407489912 "$node_(104) setdest 958 40335 18.0" 
$ns at 443.3565826303202 "$node_(104) setdest 5965 35759 19.0" 
$ns at 516.5677140489468 "$node_(104) setdest 61943 43643 2.0" 
$ns at 564.8420747664985 "$node_(104) setdest 190688 24768 20.0" 
$ns at 714.538872145295 "$node_(104) setdest 61413 44964 1.0" 
$ns at 748.4162546457791 "$node_(104) setdest 1245 12312 4.0" 
$ns at 809.0200694003568 "$node_(104) setdest 105752 66531 8.0" 
$ns at 873.8856079227204 "$node_(104) setdest 236841 48764 3.0" 
$ns at 120.01294425377337 "$node_(105) setdest 87836 16089 1.0" 
$ns at 151.81241279099038 "$node_(105) setdest 2754 20468 3.0" 
$ns at 195.67040040646927 "$node_(105) setdest 69126 15532 6.0" 
$ns at 279.28677102321603 "$node_(105) setdest 158363 4637 10.0" 
$ns at 408.8648711368405 "$node_(105) setdest 163326 25294 19.0" 
$ns at 450.74932305940183 "$node_(105) setdest 112813 54182 17.0" 
$ns at 512.7381255074896 "$node_(105) setdest 153444 3093 4.0" 
$ns at 565.3205256075767 "$node_(105) setdest 86849 58272 5.0" 
$ns at 632.9551322949933 "$node_(105) setdest 185646 49513 8.0" 
$ns at 690.7121098760916 "$node_(105) setdest 47456 10694 15.0" 
$ns at 844.2705177964529 "$node_(105) setdest 236139 27503 5.0" 
$ns at 893.9433516220538 "$node_(105) setdest 90005 31967 3.0" 
$ns at 105.26479784067901 "$node_(106) setdest 68935 18871 4.0" 
$ns at 161.0541576196431 "$node_(106) setdest 36591 1952 16.0" 
$ns at 338.3654577650374 "$node_(106) setdest 42618 43349 19.0" 
$ns at 406.4620779776749 "$node_(106) setdest 188336 27797 5.0" 
$ns at 475.40900396823037 "$node_(106) setdest 54460 58822 15.0" 
$ns at 613.9994727892476 "$node_(106) setdest 140938 58421 9.0" 
$ns at 663.8434836357363 "$node_(106) setdest 167433 23799 12.0" 
$ns at 795.7443860078421 "$node_(106) setdest 113215 71892 18.0" 
$ns at 104.35108846304306 "$node_(107) setdest 26690 28336 1.0" 
$ns at 139.4558114928672 "$node_(107) setdest 70913 14357 14.0" 
$ns at 177.61951490980022 "$node_(107) setdest 51686 15732 10.0" 
$ns at 211.53403265500438 "$node_(107) setdest 97285 31241 20.0" 
$ns at 330.4162104436217 "$node_(107) setdest 114770 6550 14.0" 
$ns at 412.457039976351 "$node_(107) setdest 150081 23331 10.0" 
$ns at 444.11363339545716 "$node_(107) setdest 168543 8761 15.0" 
$ns at 538.8113798555848 "$node_(107) setdest 198739 2906 14.0" 
$ns at 603.7974937566005 "$node_(107) setdest 33136 7708 16.0" 
$ns at 695.5752949152627 "$node_(107) setdest 234377 49382 14.0" 
$ns at 750.6875616285988 "$node_(107) setdest 87670 67548 15.0" 
$ns at 868.2537618261424 "$node_(107) setdest 174240 64685 19.0" 
$ns at 157.51377565501912 "$node_(108) setdest 48886 32308 15.0" 
$ns at 254.1410252864887 "$node_(108) setdest 146859 12300 14.0" 
$ns at 305.03222276760073 "$node_(108) setdest 115353 43537 7.0" 
$ns at 361.4401064882785 "$node_(108) setdest 46960 48046 9.0" 
$ns at 408.6499047846598 "$node_(108) setdest 6249 42417 15.0" 
$ns at 540.3722293757992 "$node_(108) setdest 119074 24996 15.0" 
$ns at 592.3079714911134 "$node_(108) setdest 109116 26829 2.0" 
$ns at 632.354408402124 "$node_(108) setdest 100580 40853 3.0" 
$ns at 683.9560439644231 "$node_(108) setdest 204014 9780 18.0" 
$ns at 830.9446256642748 "$node_(108) setdest 82911 70154 6.0" 
$ns at 886.10723880234 "$node_(108) setdest 17321 26028 12.0" 
$ns at 180.82600211745932 "$node_(109) setdest 66672 28459 17.0" 
$ns at 328.7112405711235 "$node_(109) setdest 136233 9161 9.0" 
$ns at 423.70380647039536 "$node_(109) setdest 44435 8926 16.0" 
$ns at 587.3626296433326 "$node_(109) setdest 46192 11648 4.0" 
$ns at 629.0945978148056 "$node_(109) setdest 67555 57608 18.0" 
$ns at 817.8215846088016 "$node_(109) setdest 3782 11377 20.0" 
$ns at 113.84396033323384 "$node_(110) setdest 5454 2394 12.0" 
$ns at 219.50176742049123 "$node_(110) setdest 129077 6286 17.0" 
$ns at 344.38062596437743 "$node_(110) setdest 42722 21752 3.0" 
$ns at 382.99679032732473 "$node_(110) setdest 126919 803 16.0" 
$ns at 509.8892996164114 "$node_(110) setdest 111842 65928 15.0" 
$ns at 689.4728763901992 "$node_(110) setdest 230527 82199 17.0" 
$ns at 791.1454848740719 "$node_(110) setdest 107593 10160 17.0" 
$ns at 130.9747232285174 "$node_(111) setdest 39060 13494 9.0" 
$ns at 240.37786523350258 "$node_(111) setdest 50841 33620 11.0" 
$ns at 312.7283663498483 "$node_(111) setdest 77279 51523 12.0" 
$ns at 353.7816051199487 "$node_(111) setdest 180662 39923 1.0" 
$ns at 389.9318437955092 "$node_(111) setdest 102711 51017 18.0" 
$ns at 492.85855962226753 "$node_(111) setdest 48008 7091 14.0" 
$ns at 586.6571037631858 "$node_(111) setdest 155611 26273 7.0" 
$ns at 641.9095731768743 "$node_(111) setdest 102381 2422 19.0" 
$ns at 681.0153331398009 "$node_(111) setdest 177553 74326 19.0" 
$ns at 871.0502244373672 "$node_(111) setdest 81794 1935 16.0" 
$ns at 118.1358765817721 "$node_(112) setdest 14681 31198 8.0" 
$ns at 211.1789765464741 "$node_(112) setdest 2797 4132 9.0" 
$ns at 275.8717575892467 "$node_(112) setdest 123068 23729 14.0" 
$ns at 313.2078521915202 "$node_(112) setdest 15231 26173 10.0" 
$ns at 371.65343482584126 "$node_(112) setdest 84683 59208 5.0" 
$ns at 435.24935951731675 "$node_(112) setdest 98260 62229 2.0" 
$ns at 480.0275430177626 "$node_(112) setdest 159448 41204 14.0" 
$ns at 600.785587299107 "$node_(112) setdest 179366 35523 5.0" 
$ns at 677.3585857542952 "$node_(112) setdest 117532 34221 6.0" 
$ns at 765.0985750699566 "$node_(112) setdest 160644 77819 8.0" 
$ns at 803.8652542872062 "$node_(112) setdest 253711 8528 3.0" 
$ns at 845.1029061464486 "$node_(112) setdest 34794 78120 3.0" 
$ns at 248.76858143683918 "$node_(113) setdest 82683 17217 7.0" 
$ns at 304.0316900471992 "$node_(113) setdest 129900 44411 10.0" 
$ns at 358.638054769656 "$node_(113) setdest 59308 38096 12.0" 
$ns at 434.8726888432551 "$node_(113) setdest 97781 51612 20.0" 
$ns at 573.3476162054087 "$node_(113) setdest 57614 71889 19.0" 
$ns at 611.0069376986526 "$node_(113) setdest 195127 61458 15.0" 
$ns at 762.3581162282371 "$node_(113) setdest 59235 13054 8.0" 
$ns at 818.3766467018514 "$node_(113) setdest 220107 81542 2.0" 
$ns at 851.5137665882502 "$node_(113) setdest 241539 80586 9.0" 
$ns at 142.7072192585225 "$node_(114) setdest 87064 21525 8.0" 
$ns at 247.16061349481765 "$node_(114) setdest 41636 15885 10.0" 
$ns at 280.698586076293 "$node_(114) setdest 156761 23784 18.0" 
$ns at 421.6472273044425 "$node_(114) setdest 5062 12984 14.0" 
$ns at 467.68492217719177 "$node_(114) setdest 100104 50111 17.0" 
$ns at 530.6529228502329 "$node_(114) setdest 84863 11314 7.0" 
$ns at 609.0727960520941 "$node_(114) setdest 200630 73948 16.0" 
$ns at 748.9909605424455 "$node_(114) setdest 219021 30620 5.0" 
$ns at 812.8655210706268 "$node_(114) setdest 116400 19514 4.0" 
$ns at 861.9028064911669 "$node_(114) setdest 54091 12536 5.0" 
$ns at 198.69027091448282 "$node_(115) setdest 10733 14516 11.0" 
$ns at 235.17113513809687 "$node_(115) setdest 34792 1599 17.0" 
$ns at 274.84277573481563 "$node_(115) setdest 78112 43594 18.0" 
$ns at 386.1441220953134 "$node_(115) setdest 53870 26881 15.0" 
$ns at 563.6161632677207 "$node_(115) setdest 30200 75860 5.0" 
$ns at 603.2011716259567 "$node_(115) setdest 125434 4486 13.0" 
$ns at 736.2319718429816 "$node_(115) setdest 152547 46831 11.0" 
$ns at 818.2902731465545 "$node_(115) setdest 105068 30739 7.0" 
$ns at 151.86145477486016 "$node_(116) setdest 44227 14024 12.0" 
$ns at 293.96171081209195 "$node_(116) setdest 30964 50182 14.0" 
$ns at 423.909370329646 "$node_(116) setdest 15706 43310 7.0" 
$ns at 486.46034393983 "$node_(116) setdest 161552 32579 18.0" 
$ns at 634.6848602670416 "$node_(116) setdest 35005 38372 18.0" 
$ns at 685.9038925979687 "$node_(116) setdest 189778 57113 10.0" 
$ns at 776.6667332654143 "$node_(116) setdest 167722 43645 9.0" 
$ns at 860.3611404484151 "$node_(116) setdest 32262 44412 10.0" 
$ns at 151.07606232986876 "$node_(117) setdest 128134 30353 2.0" 
$ns at 181.8262891778976 "$node_(117) setdest 33432 13188 8.0" 
$ns at 259.06605200320143 "$node_(117) setdest 1282 27804 6.0" 
$ns at 294.46140519973994 "$node_(117) setdest 42862 27482 19.0" 
$ns at 486.12451243634075 "$node_(117) setdest 117761 44611 1.0" 
$ns at 525.8997870994965 "$node_(117) setdest 15448 53612 15.0" 
$ns at 582.9125597973949 "$node_(117) setdest 67297 42852 9.0" 
$ns at 656.8535417201152 "$node_(117) setdest 173504 62816 15.0" 
$ns at 730.5792595147583 "$node_(117) setdest 18245 32595 12.0" 
$ns at 772.8053351561673 "$node_(117) setdest 229211 19485 14.0" 
$ns at 810.7135702894913 "$node_(117) setdest 179128 69650 5.0" 
$ns at 863.5316494779743 "$node_(117) setdest 50315 15081 16.0" 
$ns at 116.16643250728423 "$node_(118) setdest 25200 12456 3.0" 
$ns at 155.0850356163312 "$node_(118) setdest 58276 18669 4.0" 
$ns at 197.21192772020663 "$node_(118) setdest 84753 27521 14.0" 
$ns at 320.3209270332803 "$node_(118) setdest 4711 42045 10.0" 
$ns at 358.43789952524224 "$node_(118) setdest 32647 8817 14.0" 
$ns at 408.8718871685955 "$node_(118) setdest 154683 46727 3.0" 
$ns at 447.95837891398645 "$node_(118) setdest 165646 40376 3.0" 
$ns at 492.2492390401897 "$node_(118) setdest 118135 53899 3.0" 
$ns at 523.8407811403617 "$node_(118) setdest 93114 52427 9.0" 
$ns at 557.0672024007358 "$node_(118) setdest 183963 61643 2.0" 
$ns at 587.1385394558504 "$node_(118) setdest 12873 8837 13.0" 
$ns at 743.8970665582218 "$node_(118) setdest 174901 72964 18.0" 
$ns at 845.664619520243 "$node_(118) setdest 10348 76451 6.0" 
$ns at 891.6431036973397 "$node_(118) setdest 231941 56250 11.0" 
$ns at 146.82285069127616 "$node_(119) setdest 26274 31435 3.0" 
$ns at 193.94291490323673 "$node_(119) setdest 82782 10060 13.0" 
$ns at 319.4689453132488 "$node_(119) setdest 13372 21179 5.0" 
$ns at 394.4570891820266 "$node_(119) setdest 135497 1950 19.0" 
$ns at 480.57951983989136 "$node_(119) setdest 34868 67429 9.0" 
$ns at 563.2437886931057 "$node_(119) setdest 79285 15450 10.0" 
$ns at 626.2549659410723 "$node_(119) setdest 157050 6571 16.0" 
$ns at 776.5060802998213 "$node_(119) setdest 234821 53271 6.0" 
$ns at 846.4675881603416 "$node_(119) setdest 65160 19215 15.0" 
$ns at 894.2546933965159 "$node_(119) setdest 199666 8244 10.0" 
$ns at 218.40620766019882 "$node_(120) setdest 49741 37695 4.0" 
$ns at 277.3174071787183 "$node_(120) setdest 39106 42495 8.0" 
$ns at 380.5722409997246 "$node_(120) setdest 20461 53647 6.0" 
$ns at 439.3877489900606 "$node_(120) setdest 94580 49857 1.0" 
$ns at 471.96773680782553 "$node_(120) setdest 204591 26214 12.0" 
$ns at 509.634377386781 "$node_(120) setdest 66084 33831 17.0" 
$ns at 699.7982840859597 "$node_(120) setdest 25396 2809 18.0" 
$ns at 854.6012663522126 "$node_(120) setdest 120762 77546 17.0" 
$ns at 156.42451618310287 "$node_(121) setdest 90598 22022 9.0" 
$ns at 243.46229584254252 "$node_(121) setdest 44967 38819 4.0" 
$ns at 298.40569331217677 "$node_(121) setdest 107348 45019 5.0" 
$ns at 329.6931161463515 "$node_(121) setdest 55539 2948 18.0" 
$ns at 504.97577518355615 "$node_(121) setdest 100766 41805 10.0" 
$ns at 541.6000606100617 "$node_(121) setdest 58271 37115 13.0" 
$ns at 618.8485750449697 "$node_(121) setdest 219331 73338 11.0" 
$ns at 660.1078204555105 "$node_(121) setdest 35809 78940 7.0" 
$ns at 746.2835997764827 "$node_(121) setdest 154805 53231 17.0" 
$ns at 809.2884331856784 "$node_(121) setdest 169305 49371 13.0" 
$ns at 177.26536270344937 "$node_(122) setdest 123977 6390 4.0" 
$ns at 210.12951415249103 "$node_(122) setdest 92024 38643 19.0" 
$ns at 381.9319802580171 "$node_(122) setdest 183754 56552 17.0" 
$ns at 425.3515353139602 "$node_(122) setdest 164599 43842 10.0" 
$ns at 533.9732341867417 "$node_(122) setdest 78595 59623 17.0" 
$ns at 660.2976663406876 "$node_(122) setdest 37952 13302 12.0" 
$ns at 727.4284479042841 "$node_(122) setdest 241090 58818 13.0" 
$ns at 861.987754954994 "$node_(122) setdest 119414 46620 15.0" 
$ns at 131.11378089322415 "$node_(123) setdest 21568 2403 20.0" 
$ns at 256.7757494266592 "$node_(123) setdest 98046 30483 17.0" 
$ns at 307.6635451566888 "$node_(123) setdest 70783 2649 18.0" 
$ns at 442.8378813853418 "$node_(123) setdest 36706 27987 10.0" 
$ns at 566.9751756997671 "$node_(123) setdest 44291 55991 12.0" 
$ns at 613.7766663903985 "$node_(123) setdest 148851 20048 20.0" 
$ns at 808.2191557426206 "$node_(123) setdest 167734 45022 18.0" 
$ns at 890.5250955376607 "$node_(123) setdest 156277 6424 10.0" 
$ns at 169.2508077932264 "$node_(124) setdest 67885 33079 7.0" 
$ns at 224.33303124407496 "$node_(124) setdest 60955 10515 20.0" 
$ns at 406.9735539325411 "$node_(124) setdest 161322 42605 3.0" 
$ns at 438.2514359022801 "$node_(124) setdest 37790 59858 3.0" 
$ns at 480.70358977385047 "$node_(124) setdest 90258 29535 10.0" 
$ns at 594.3845179592823 "$node_(124) setdest 123096 814 19.0" 
$ns at 750.2444936426818 "$node_(124) setdest 169286 28246 4.0" 
$ns at 799.1289892959803 "$node_(124) setdest 76935 44916 4.0" 
$ns at 864.2030888963509 "$node_(124) setdest 55939 70346 16.0" 
$ns at 142.98604559285315 "$node_(125) setdest 49493 30804 10.0" 
$ns at 259.3682927522771 "$node_(125) setdest 24664 43219 10.0" 
$ns at 307.7320474758129 "$node_(125) setdest 98133 43618 18.0" 
$ns at 434.45012506049295 "$node_(125) setdest 100126 48189 17.0" 
$ns at 633.2437920248155 "$node_(125) setdest 97079 50962 3.0" 
$ns at 677.7988552840467 "$node_(125) setdest 99064 48056 12.0" 
$ns at 782.9409064669643 "$node_(125) setdest 54923 31216 9.0" 
$ns at 822.3522143321701 "$node_(125) setdest 58894 48166 19.0" 
$ns at 133.45897595986696 "$node_(126) setdest 50706 12825 3.0" 
$ns at 185.2054704536016 "$node_(126) setdest 80617 1143 4.0" 
$ns at 248.14120983603607 "$node_(126) setdest 83892 4679 19.0" 
$ns at 318.19950752151146 "$node_(126) setdest 31174 28226 19.0" 
$ns at 430.5435891555461 "$node_(126) setdest 110584 13157 10.0" 
$ns at 550.3979909271127 "$node_(126) setdest 126667 35166 12.0" 
$ns at 583.087257676864 "$node_(126) setdest 203013 20995 18.0" 
$ns at 697.7403183014861 "$node_(126) setdest 110440 10528 10.0" 
$ns at 795.8446204978088 "$node_(126) setdest 140206 10175 3.0" 
$ns at 838.6048613480176 "$node_(126) setdest 163649 7158 1.0" 
$ns at 872.2442139523282 "$node_(126) setdest 266693 50471 17.0" 
$ns at 215.48696069226048 "$node_(127) setdest 917 11683 1.0" 
$ns at 250.90185179593996 "$node_(127) setdest 126364 30205 10.0" 
$ns at 329.2490228535785 "$node_(127) setdest 53938 29719 3.0" 
$ns at 385.1360452623662 "$node_(127) setdest 4852 32658 16.0" 
$ns at 474.8396331949471 "$node_(127) setdest 44511 39253 8.0" 
$ns at 539.1108181273233 "$node_(127) setdest 87525 5667 13.0" 
$ns at 640.4508075487477 "$node_(127) setdest 168990 35263 10.0" 
$ns at 700.7317599109002 "$node_(127) setdest 73977 38418 19.0" 
$ns at 835.311104067334 "$node_(127) setdest 224214 64769 15.0" 
$ns at 137.10505015845595 "$node_(128) setdest 86378 24976 4.0" 
$ns at 178.6291905359584 "$node_(128) setdest 5741 7304 16.0" 
$ns at 351.7572997106678 "$node_(128) setdest 38652 17913 14.0" 
$ns at 490.8012809712148 "$node_(128) setdest 86965 51838 7.0" 
$ns at 543.4733985117741 "$node_(128) setdest 85228 11299 13.0" 
$ns at 688.8220815632558 "$node_(128) setdest 185405 65240 7.0" 
$ns at 720.8094134860631 "$node_(128) setdest 137550 61606 17.0" 
$ns at 893.3387637221307 "$node_(128) setdest 18874 83900 10.0" 
$ns at 114.59013877293069 "$node_(129) setdest 69611 7937 1.0" 
$ns at 148.0313622374815 "$node_(129) setdest 23372 15562 15.0" 
$ns at 184.86074106608166 "$node_(129) setdest 61447 39257 10.0" 
$ns at 249.96131812670285 "$node_(129) setdest 8139 18981 1.0" 
$ns at 280.23432911434065 "$node_(129) setdest 119727 35427 3.0" 
$ns at 327.6878440719622 "$node_(129) setdest 142913 9542 15.0" 
$ns at 389.8532136542986 "$node_(129) setdest 118751 29956 6.0" 
$ns at 435.5612931631723 "$node_(129) setdest 177508 3182 6.0" 
$ns at 495.86821533280556 "$node_(129) setdest 134196 64643 9.0" 
$ns at 578.6895159012963 "$node_(129) setdest 144641 52401 13.0" 
$ns at 648.8161582021265 "$node_(129) setdest 35045 28765 16.0" 
$ns at 801.5099599716021 "$node_(129) setdest 16147 88182 7.0" 
$ns at 840.260130253335 "$node_(129) setdest 191736 64906 12.0" 
$ns at 173.40722425695563 "$node_(130) setdest 66043 32852 17.0" 
$ns at 329.63906889326086 "$node_(130) setdest 14093 10454 15.0" 
$ns at 438.6586205894999 "$node_(130) setdest 38524 2142 2.0" 
$ns at 475.14163905463386 "$node_(130) setdest 171124 13958 6.0" 
$ns at 520.2917029124415 "$node_(130) setdest 118697 68307 17.0" 
$ns at 645.792775859927 "$node_(130) setdest 3420 72147 18.0" 
$ns at 787.732176497154 "$node_(130) setdest 137116 61366 3.0" 
$ns at 822.1475622843881 "$node_(130) setdest 42869 28120 1.0" 
$ns at 852.3152234710386 "$node_(130) setdest 17260 45070 14.0" 
$ns at 110.84734889530841 "$node_(131) setdest 22100 19351 14.0" 
$ns at 229.91612762986827 "$node_(131) setdest 93239 2346 12.0" 
$ns at 343.99463696560974 "$node_(131) setdest 19599 15163 13.0" 
$ns at 471.28779222989675 "$node_(131) setdest 185620 52502 15.0" 
$ns at 537.3234445441508 "$node_(131) setdest 90757 9659 18.0" 
$ns at 634.0487719622436 "$node_(131) setdest 33571 12450 18.0" 
$ns at 682.7194963738425 "$node_(131) setdest 25122 37184 3.0" 
$ns at 714.2451848447489 "$node_(131) setdest 105896 52830 8.0" 
$ns at 785.7897518540718 "$node_(131) setdest 114356 14639 15.0" 
$ns at 172.5536072839836 "$node_(132) setdest 39983 17059 14.0" 
$ns at 292.1139016892181 "$node_(132) setdest 30638 46229 13.0" 
$ns at 435.2381553334704 "$node_(132) setdest 181343 58967 13.0" 
$ns at 593.9933443553082 "$node_(132) setdest 192047 6125 2.0" 
$ns at 633.7642985805084 "$node_(132) setdest 149625 72304 16.0" 
$ns at 811.2148669977821 "$node_(132) setdest 140159 86284 12.0" 
$ns at 116.95696108359905 "$node_(133) setdest 84233 5518 10.0" 
$ns at 200.3209369904076 "$node_(133) setdest 41086 35514 13.0" 
$ns at 345.56116473739894 "$node_(133) setdest 125419 17659 5.0" 
$ns at 394.4133737490333 "$node_(133) setdest 34741 48857 2.0" 
$ns at 429.39912764734225 "$node_(133) setdest 182693 51150 3.0" 
$ns at 478.97919675935407 "$node_(133) setdest 16065 36096 13.0" 
$ns at 594.2737975857912 "$node_(133) setdest 231692 16326 10.0" 
$ns at 672.7887850273692 "$node_(133) setdest 167953 2198 2.0" 
$ns at 713.5522940575536 "$node_(133) setdest 189761 82651 12.0" 
$ns at 801.7140792024638 "$node_(133) setdest 102411 11822 10.0" 
$ns at 846.8826418262549 "$node_(133) setdest 105827 46536 19.0" 
$ns at 109.95454056947902 "$node_(134) setdest 85788 23757 15.0" 
$ns at 208.900455891295 "$node_(134) setdest 126616 7265 2.0" 
$ns at 250.77998700388886 "$node_(134) setdest 19011 52146 11.0" 
$ns at 323.336952645133 "$node_(134) setdest 78104 50302 6.0" 
$ns at 363.5639721075297 "$node_(134) setdest 21263 23991 5.0" 
$ns at 439.30316544085747 "$node_(134) setdest 167139 31447 9.0" 
$ns at 541.6931463823057 "$node_(134) setdest 63553 59715 8.0" 
$ns at 602.8102341639667 "$node_(134) setdest 17012 51613 3.0" 
$ns at 637.0972283841191 "$node_(134) setdest 143695 35977 18.0" 
$ns at 826.7176440771707 "$node_(134) setdest 208514 76247 8.0" 
$ns at 212.28261544037963 "$node_(135) setdest 66557 15441 9.0" 
$ns at 249.4505192338989 "$node_(135) setdest 27391 8049 14.0" 
$ns at 311.43783047870215 "$node_(135) setdest 1230 44127 1.0" 
$ns at 349.61194684138934 "$node_(135) setdest 81801 26059 16.0" 
$ns at 504.52854971471584 "$node_(135) setdest 60082 28577 18.0" 
$ns at 626.0488958619287 "$node_(135) setdest 46884 44245 20.0" 
$ns at 657.4656008701221 "$node_(135) setdest 187437 64023 14.0" 
$ns at 696.5281471099402 "$node_(135) setdest 228782 54736 18.0" 
$ns at 732.0929971725609 "$node_(135) setdest 112000 60902 2.0" 
$ns at 768.4691478606552 "$node_(135) setdest 57478 13379 10.0" 
$ns at 887.5403185680934 "$node_(135) setdest 249751 81727 5.0" 
$ns at 132.25435816416712 "$node_(136) setdest 93398 14264 6.0" 
$ns at 176.94464943527333 "$node_(136) setdest 39020 28773 11.0" 
$ns at 316.1034905346787 "$node_(136) setdest 37794 48772 6.0" 
$ns at 390.2798886515942 "$node_(136) setdest 2155 34671 10.0" 
$ns at 466.96063471387527 "$node_(136) setdest 192040 56061 1.0" 
$ns at 503.53563324007797 "$node_(136) setdest 40592 58231 11.0" 
$ns at 586.5446330512466 "$node_(136) setdest 120966 58705 19.0" 
$ns at 698.2551900764213 "$node_(136) setdest 202405 64777 4.0" 
$ns at 751.6450572534866 "$node_(136) setdest 87695 11671 6.0" 
$ns at 832.3870671337411 "$node_(136) setdest 51674 82318 9.0" 
$ns at 869.1003917463818 "$node_(136) setdest 192586 72977 3.0" 
$ns at 106.04214610163746 "$node_(137) setdest 61703 23486 5.0" 
$ns at 184.9061280034472 "$node_(137) setdest 41937 10212 13.0" 
$ns at 279.70582377088516 "$node_(137) setdest 67175 20168 8.0" 
$ns at 358.14163099158975 "$node_(137) setdest 32139 14251 15.0" 
$ns at 523.4239525414005 "$node_(137) setdest 178917 29343 6.0" 
$ns at 593.2270060814039 "$node_(137) setdest 130646 17608 4.0" 
$ns at 643.9931859577451 "$node_(137) setdest 169323 71348 3.0" 
$ns at 692.7250421914239 "$node_(137) setdest 115351 1211 9.0" 
$ns at 785.6090714382075 "$node_(137) setdest 231476 59176 5.0" 
$ns at 841.6822871235588 "$node_(137) setdest 24334 55662 19.0" 
$ns at 114.98805251206275 "$node_(138) setdest 29767 16410 16.0" 
$ns at 267.8164610442227 "$node_(138) setdest 4498 23074 19.0" 
$ns at 471.3530024795567 "$node_(138) setdest 39043 9823 6.0" 
$ns at 506.04692568053343 "$node_(138) setdest 184285 10152 13.0" 
$ns at 570.1655424506575 "$node_(138) setdest 159560 40442 16.0" 
$ns at 677.3253204559167 "$node_(138) setdest 105249 49414 17.0" 
$ns at 713.7145367654979 "$node_(138) setdest 30876 49651 2.0" 
$ns at 757.0951023079778 "$node_(138) setdest 52925 81879 10.0" 
$ns at 884.322817608635 "$node_(138) setdest 264958 47382 7.0" 
$ns at 140.37814603802533 "$node_(139) setdest 88510 12322 15.0" 
$ns at 218.2576434735687 "$node_(139) setdest 133746 32311 9.0" 
$ns at 327.59708873795785 "$node_(139) setdest 47713 48407 10.0" 
$ns at 392.7306962263232 "$node_(139) setdest 188919 10105 10.0" 
$ns at 482.73776622569335 "$node_(139) setdest 132866 65028 19.0" 
$ns at 702.647590918599 "$node_(139) setdest 91900 44576 10.0" 
$ns at 819.546209839511 "$node_(139) setdest 253115 25674 3.0" 
$ns at 876.9435229227818 "$node_(139) setdest 218277 51495 11.0" 
$ns at 129.7246946225674 "$node_(140) setdest 42701 21684 13.0" 
$ns at 206.82635725446386 "$node_(140) setdest 8624 20015 4.0" 
$ns at 245.26085539932484 "$node_(140) setdest 4782 16419 20.0" 
$ns at 366.0556677021683 "$node_(140) setdest 20971 49033 20.0" 
$ns at 525.5584912571607 "$node_(140) setdest 142782 61882 8.0" 
$ns at 623.0141939038413 "$node_(140) setdest 111702 15619 9.0" 
$ns at 665.4018955281799 "$node_(140) setdest 207035 58765 7.0" 
$ns at 733.386540835174 "$node_(140) setdest 179814 71469 15.0" 
$ns at 770.2728941814811 "$node_(140) setdest 204358 71938 11.0" 
$ns at 828.8720965439059 "$node_(140) setdest 99021 22878 9.0" 
$ns at 880.6002665179955 "$node_(140) setdest 216627 63205 1.0" 
$ns at 142.89068360438216 "$node_(141) setdest 94287 28160 12.0" 
$ns at 214.21664084543215 "$node_(141) setdest 118629 12485 16.0" 
$ns at 305.30947661678454 "$node_(141) setdest 162397 5397 1.0" 
$ns at 339.30042358906786 "$node_(141) setdest 14958 53538 2.0" 
$ns at 387.51497950691453 "$node_(141) setdest 77083 28975 20.0" 
$ns at 463.24980261831723 "$node_(141) setdest 78676 7733 4.0" 
$ns at 505.7863295729914 "$node_(141) setdest 185527 39922 13.0" 
$ns at 616.642431287733 "$node_(141) setdest 33900 8721 1.0" 
$ns at 651.3867510034627 "$node_(141) setdest 114634 76980 4.0" 
$ns at 715.9438987188698 "$node_(141) setdest 164857 47799 6.0" 
$ns at 787.6200938158194 "$node_(141) setdest 81530 33297 13.0" 
$ns at 836.8499217855029 "$node_(141) setdest 219106 70390 5.0" 
$ns at 879.3369365052816 "$node_(141) setdest 173152 40000 7.0" 
$ns at 109.30611359209895 "$node_(142) setdest 24295 28420 9.0" 
$ns at 165.30744302095871 "$node_(142) setdest 79395 28005 8.0" 
$ns at 227.2716120970166 "$node_(142) setdest 92228 37301 8.0" 
$ns at 336.7137809548248 "$node_(142) setdest 118872 18226 2.0" 
$ns at 371.24747301396656 "$node_(142) setdest 184835 21824 16.0" 
$ns at 415.5589275616152 "$node_(142) setdest 13305 38318 13.0" 
$ns at 480.6397511177869 "$node_(142) setdest 61925 12635 7.0" 
$ns at 565.7939052358762 "$node_(142) setdest 94828 60233 8.0" 
$ns at 665.2725671690814 "$node_(142) setdest 26377 14687 13.0" 
$ns at 796.7822001710705 "$node_(142) setdest 134216 20692 15.0" 
$ns at 867.6858306009573 "$node_(142) setdest 154613 15517 19.0" 
$ns at 263.4202797231574 "$node_(143) setdest 65121 36534 12.0" 
$ns at 383.66874471274343 "$node_(143) setdest 10472 20885 12.0" 
$ns at 437.8832683390273 "$node_(143) setdest 14828 52632 14.0" 
$ns at 511.7179782187931 "$node_(143) setdest 148073 28914 11.0" 
$ns at 636.7984768579836 "$node_(143) setdest 63435 575 8.0" 
$ns at 682.4692344134027 "$node_(143) setdest 52635 78720 15.0" 
$ns at 734.7090140260942 "$node_(143) setdest 146003 9765 12.0" 
$ns at 876.7349151997223 "$node_(143) setdest 164233 12049 12.0" 
$ns at 134.13774324847464 "$node_(144) setdest 19274 23384 11.0" 
$ns at 206.1767461778325 "$node_(144) setdest 88546 680 13.0" 
$ns at 312.8971689163211 "$node_(144) setdest 96296 48120 11.0" 
$ns at 446.6581828499916 "$node_(144) setdest 50775 17699 17.0" 
$ns at 499.7271095015582 "$node_(144) setdest 184460 3067 7.0" 
$ns at 586.003534028835 "$node_(144) setdest 174187 66402 15.0" 
$ns at 758.8135988463821 "$node_(144) setdest 85263 23717 18.0" 
$ns at 797.1859155000254 "$node_(144) setdest 253704 56163 19.0" 
$ns at 886.7094533493123 "$node_(144) setdest 191741 50604 6.0" 
$ns at 115.16744275934796 "$node_(145) setdest 72570 5141 6.0" 
$ns at 164.70636434478783 "$node_(145) setdest 85719 9878 17.0" 
$ns at 333.42421205252833 "$node_(145) setdest 77911 12245 3.0" 
$ns at 371.4634484718505 "$node_(145) setdest 145754 16911 19.0" 
$ns at 432.1033370070409 "$node_(145) setdest 125684 40751 7.0" 
$ns at 496.8968542080518 "$node_(145) setdest 56176 26676 10.0" 
$ns at 622.0052120836152 "$node_(145) setdest 77581 7583 11.0" 
$ns at 726.0083912471163 "$node_(145) setdest 205539 67900 4.0" 
$ns at 768.9768900178849 "$node_(145) setdest 2056 31835 11.0" 
$ns at 817.5863022215485 "$node_(145) setdest 51609 69774 6.0" 
$ns at 266.40119888967297 "$node_(146) setdest 20514 17140 1.0" 
$ns at 297.574456313054 "$node_(146) setdest 14400 45855 7.0" 
$ns at 364.7207561332488 "$node_(146) setdest 177421 24748 7.0" 
$ns at 401.86071995168254 "$node_(146) setdest 29671 3518 17.0" 
$ns at 448.19140860694273 "$node_(146) setdest 98727 45068 10.0" 
$ns at 479.92682085849265 "$node_(146) setdest 21912 54305 7.0" 
$ns at 512.5970372291622 "$node_(146) setdest 174276 32711 3.0" 
$ns at 567.1533437713515 "$node_(146) setdest 194005 60679 7.0" 
$ns at 612.1938903103526 "$node_(146) setdest 73829 9375 4.0" 
$ns at 660.7301377339952 "$node_(146) setdest 32797 9689 17.0" 
$ns at 720.2638795719397 "$node_(146) setdest 217655 48681 3.0" 
$ns at 776.3315154824585 "$node_(146) setdest 160747 760 11.0" 
$ns at 176.79279216976232 "$node_(147) setdest 48677 18697 1.0" 
$ns at 212.14821997380903 "$node_(147) setdest 101635 16276 7.0" 
$ns at 306.7900659271003 "$node_(147) setdest 134433 25915 11.0" 
$ns at 367.9043217970975 "$node_(147) setdest 181816 32436 15.0" 
$ns at 465.0609581952383 "$node_(147) setdest 176274 21189 5.0" 
$ns at 523.0464090424775 "$node_(147) setdest 115903 13815 5.0" 
$ns at 582.4312610245497 "$node_(147) setdest 203185 68666 6.0" 
$ns at 661.196156228174 "$node_(147) setdest 226804 77611 10.0" 
$ns at 695.5649436703878 "$node_(147) setdest 88192 1050 13.0" 
$ns at 759.6820437703518 "$node_(147) setdest 93638 51143 12.0" 
$ns at 129.65962217380343 "$node_(148) setdest 90984 15872 2.0" 
$ns at 163.16641652446958 "$node_(148) setdest 113885 3246 18.0" 
$ns at 276.0683107113901 "$node_(148) setdest 23922 30175 7.0" 
$ns at 366.0867634713407 "$node_(148) setdest 166428 41348 18.0" 
$ns at 545.2497816577819 "$node_(148) setdest 21892 44757 17.0" 
$ns at 703.9763205518362 "$node_(148) setdest 85655 29274 14.0" 
$ns at 862.5022331926547 "$node_(148) setdest 131783 16658 11.0" 
$ns at 155.66432262426946 "$node_(149) setdest 129030 37128 17.0" 
$ns at 239.88465097294366 "$node_(149) setdest 72110 39363 9.0" 
$ns at 289.87090141588635 "$node_(149) setdest 65623 48316 19.0" 
$ns at 459.82863868750087 "$node_(149) setdest 10223 20447 2.0" 
$ns at 489.964204951129 "$node_(149) setdest 208469 44352 18.0" 
$ns at 671.4026933498312 "$node_(149) setdest 4401 66031 16.0" 
$ns at 795.0041319661392 "$node_(149) setdest 116491 43581 15.0" 
$ns at 855.6891767242918 "$node_(149) setdest 41494 18765 1.0" 
$ns at 888.9868693105878 "$node_(149) setdest 18463 43081 17.0" 
$ns at 222.40883405357988 "$node_(150) setdest 71488 39374 4.0" 
$ns at 280.3187506475719 "$node_(150) setdest 27346 8963 18.0" 
$ns at 322.75991778804075 "$node_(150) setdest 108406 1980 16.0" 
$ns at 473.5277069869989 "$node_(150) setdest 187850 54437 19.0" 
$ns at 579.5907311626855 "$node_(150) setdest 206349 53131 12.0" 
$ns at 627.9945834669554 "$node_(150) setdest 72539 10250 2.0" 
$ns at 672.5492627561082 "$node_(150) setdest 26817 82138 15.0" 
$ns at 746.0942590141468 "$node_(150) setdest 225795 45419 10.0" 
$ns at 820.2167494495435 "$node_(150) setdest 94967 84749 8.0" 
$ns at 864.6484584324681 "$node_(150) setdest 170671 35854 5.0" 
$ns at 896.201659131608 "$node_(150) setdest 225961 14604 13.0" 
$ns at 139.1159285430683 "$node_(151) setdest 82879 31258 3.0" 
$ns at 197.07513106133854 "$node_(151) setdest 95986 34224 20.0" 
$ns at 425.43591168703756 "$node_(151) setdest 9373 56956 1.0" 
$ns at 457.413409310898 "$node_(151) setdest 111350 18897 7.0" 
$ns at 527.8306730887243 "$node_(151) setdest 81413 62275 5.0" 
$ns at 580.5552122499375 "$node_(151) setdest 190403 26792 2.0" 
$ns at 610.5903316676474 "$node_(151) setdest 227904 44855 19.0" 
$ns at 809.4961283998357 "$node_(151) setdest 65898 25154 10.0" 
$ns at 102.13062976917232 "$node_(152) setdest 50995 3248 3.0" 
$ns at 135.49141744778012 "$node_(152) setdest 53135 23649 17.0" 
$ns at 291.8335409416384 "$node_(152) setdest 26575 31500 13.0" 
$ns at 388.19285723751915 "$node_(152) setdest 104163 3574 10.0" 
$ns at 433.0945646739088 "$node_(152) setdest 182519 25014 6.0" 
$ns at 490.58966864427623 "$node_(152) setdest 160418 17837 6.0" 
$ns at 553.3970123785741 "$node_(152) setdest 96817 77087 9.0" 
$ns at 648.9221858995068 "$node_(152) setdest 32349 61111 14.0" 
$ns at 773.542408334273 "$node_(152) setdest 99825 52924 18.0" 
$ns at 833.2984439082803 "$node_(152) setdest 98577 4820 15.0" 
$ns at 877.7858054559464 "$node_(152) setdest 97848 34437 17.0" 
$ns at 215.7973563949748 "$node_(153) setdest 100656 34965 4.0" 
$ns at 252.19275255151075 "$node_(153) setdest 44987 47557 16.0" 
$ns at 371.279170307601 "$node_(153) setdest 119928 11450 10.0" 
$ns at 479.1511415980983 "$node_(153) setdest 186717 21080 5.0" 
$ns at 546.6110353185697 "$node_(153) setdest 186857 10428 6.0" 
$ns at 583.2361708026668 "$node_(153) setdest 228933 48022 6.0" 
$ns at 637.9108600755367 "$node_(153) setdest 228534 71175 3.0" 
$ns at 679.6420671973269 "$node_(153) setdest 116264 4942 16.0" 
$ns at 783.5679817607326 "$node_(153) setdest 66429 64608 14.0" 
$ns at 143.90641382422385 "$node_(154) setdest 63381 21072 8.0" 
$ns at 214.19371653810455 "$node_(154) setdest 115373 16491 16.0" 
$ns at 296.23002986380163 "$node_(154) setdest 12501 31742 3.0" 
$ns at 348.6082466436127 "$node_(154) setdest 115359 50921 2.0" 
$ns at 388.12467448127285 "$node_(154) setdest 58507 19999 17.0" 
$ns at 540.3647284956364 "$node_(154) setdest 180427 38330 1.0" 
$ns at 574.3885198722804 "$node_(154) setdest 89805 23095 9.0" 
$ns at 639.8841253578519 "$node_(154) setdest 137207 67419 2.0" 
$ns at 686.2946874778847 "$node_(154) setdest 236623 26094 10.0" 
$ns at 755.0642541622991 "$node_(154) setdest 262222 29799 8.0" 
$ns at 792.9702214909747 "$node_(154) setdest 102561 74347 5.0" 
$ns at 865.9339895864956 "$node_(154) setdest 17521 71998 9.0" 
$ns at 269.5064808608723 "$node_(155) setdest 36719 45018 3.0" 
$ns at 308.8246594820958 "$node_(155) setdest 76592 49496 1.0" 
$ns at 342.1801915149087 "$node_(155) setdest 122840 35897 1.0" 
$ns at 373.6720386490056 "$node_(155) setdest 155546 17201 9.0" 
$ns at 425.05335734254 "$node_(155) setdest 149912 59563 14.0" 
$ns at 517.9712953552015 "$node_(155) setdest 181654 24032 12.0" 
$ns at 573.3759304924698 "$node_(155) setdest 221846 56993 17.0" 
$ns at 757.1568399585655 "$node_(155) setdest 197462 76153 9.0" 
$ns at 836.6507969039998 "$node_(155) setdest 128122 27389 2.0" 
$ns at 879.0762011967835 "$node_(155) setdest 171284 30621 14.0" 
$ns at 110.82826408867462 "$node_(156) setdest 28535 27056 2.0" 
$ns at 143.07711334479131 "$node_(156) setdest 43717 29370 20.0" 
$ns at 232.70578074175341 "$node_(156) setdest 31487 38461 8.0" 
$ns at 265.87583538522927 "$node_(156) setdest 58322 47907 13.0" 
$ns at 386.0560578618593 "$node_(156) setdest 66594 62897 5.0" 
$ns at 425.9925420284454 "$node_(156) setdest 109016 18250 11.0" 
$ns at 562.5711784755019 "$node_(156) setdest 45421 74555 19.0" 
$ns at 648.6409567626848 "$node_(156) setdest 163611 10650 19.0" 
$ns at 784.9494836216048 "$node_(156) setdest 140797 66698 3.0" 
$ns at 817.9116959090771 "$node_(156) setdest 85126 62583 16.0" 
$ns at 101.30201167643514 "$node_(157) setdest 67474 28226 14.0" 
$ns at 233.21518588033393 "$node_(157) setdest 91267 2618 16.0" 
$ns at 393.2326681348656 "$node_(157) setdest 91927 872 1.0" 
$ns at 429.1010256377524 "$node_(157) setdest 168426 54664 4.0" 
$ns at 481.41123794758124 "$node_(157) setdest 198623 43092 3.0" 
$ns at 534.0176530629385 "$node_(157) setdest 97061 36990 7.0" 
$ns at 565.5088766777383 "$node_(157) setdest 183116 71795 19.0" 
$ns at 739.3961998876429 "$node_(157) setdest 223680 35090 7.0" 
$ns at 771.4145971742105 "$node_(157) setdest 258471 7182 10.0" 
$ns at 846.4188656093805 "$node_(157) setdest 127839 68835 12.0" 
$ns at 108.0416405821634 "$node_(158) setdest 66591 1591 7.0" 
$ns at 190.70853169535923 "$node_(158) setdest 114165 27113 15.0" 
$ns at 349.06121381717765 "$node_(158) setdest 67457 19831 11.0" 
$ns at 461.1778863979484 "$node_(158) setdest 175027 53678 17.0" 
$ns at 564.4654282887946 "$node_(158) setdest 158209 38556 14.0" 
$ns at 599.6240341658365 "$node_(158) setdest 225120 54265 2.0" 
$ns at 644.2167437782257 "$node_(158) setdest 156789 56981 18.0" 
$ns at 688.2484209724686 "$node_(158) setdest 16059 26076 10.0" 
$ns at 753.5677241676077 "$node_(158) setdest 252066 56008 3.0" 
$ns at 809.8968746639566 "$node_(158) setdest 259967 60139 4.0" 
$ns at 872.2944501483524 "$node_(158) setdest 242038 26177 15.0" 
$ns at 124.5726674929384 "$node_(159) setdest 51738 453 7.0" 
$ns at 195.26517391033536 "$node_(159) setdest 28852 8887 15.0" 
$ns at 356.10531945429955 "$node_(159) setdest 95377 7121 17.0" 
$ns at 411.55211499418675 "$node_(159) setdest 154064 23978 6.0" 
$ns at 442.95816063749595 "$node_(159) setdest 11412 25862 5.0" 
$ns at 476.23649920983013 "$node_(159) setdest 35884 27199 8.0" 
$ns at 513.3922258348806 "$node_(159) setdest 170788 54775 11.0" 
$ns at 563.2135631459316 "$node_(159) setdest 111282 25345 11.0" 
$ns at 674.9713712333395 "$node_(159) setdest 227999 45319 9.0" 
$ns at 735.1113658576627 "$node_(159) setdest 58742 67918 12.0" 
$ns at 788.1233469343698 "$node_(159) setdest 74854 71025 7.0" 
$ns at 831.1657247808399 "$node_(159) setdest 147297 5930 11.0" 
$ns at 184.41551079855805 "$node_(160) setdest 45653 7682 1.0" 
$ns at 221.10771982682502 "$node_(160) setdest 30314 38481 10.0" 
$ns at 333.9724081185748 "$node_(160) setdest 108649 17487 17.0" 
$ns at 494.18316288152886 "$node_(160) setdest 57517 21759 15.0" 
$ns at 573.3279055704807 "$node_(160) setdest 55420 43129 13.0" 
$ns at 613.9278865601424 "$node_(160) setdest 213421 13673 10.0" 
$ns at 666.8640865843192 "$node_(160) setdest 177075 66283 8.0" 
$ns at 705.9454833646548 "$node_(160) setdest 186103 16301 12.0" 
$ns at 767.480737830867 "$node_(160) setdest 141052 46736 1.0" 
$ns at 803.5394325659607 "$node_(160) setdest 233431 33898 13.0" 
$ns at 141.97005484310768 "$node_(161) setdest 19377 30823 11.0" 
$ns at 261.3359681709177 "$node_(161) setdest 99847 24976 13.0" 
$ns at 338.0089552006715 "$node_(161) setdest 81579 36337 1.0" 
$ns at 373.4889348144605 "$node_(161) setdest 137934 5076 5.0" 
$ns at 431.08450389620793 "$node_(161) setdest 78064 58747 15.0" 
$ns at 599.9977703992402 "$node_(161) setdest 203852 43412 18.0" 
$ns at 723.96745330062 "$node_(161) setdest 233588 60896 12.0" 
$ns at 792.040742315579 "$node_(161) setdest 18001 59628 13.0" 
$ns at 101.12928811191597 "$node_(162) setdest 88179 14899 20.0" 
$ns at 310.34528516666415 "$node_(162) setdest 44883 37392 12.0" 
$ns at 378.35961569172304 "$node_(162) setdest 123510 38957 4.0" 
$ns at 409.63915602746897 "$node_(162) setdest 18545 3781 6.0" 
$ns at 444.93777335804793 "$node_(162) setdest 68107 62277 9.0" 
$ns at 509.48702394240036 "$node_(162) setdest 10860 49413 19.0" 
$ns at 703.1413966808084 "$node_(162) setdest 239974 45831 14.0" 
$ns at 786.1006969998662 "$node_(162) setdest 186765 23327 7.0" 
$ns at 856.5985351737683 "$node_(162) setdest 171452 35891 11.0" 
$ns at 101.26136272802279 "$node_(163) setdest 22097 2605 3.0" 
$ns at 159.76364379862974 "$node_(163) setdest 78218 43852 19.0" 
$ns at 225.91722016751675 "$node_(163) setdest 47585 42802 20.0" 
$ns at 348.81242927140846 "$node_(163) setdest 79243 39321 1.0" 
$ns at 383.8945022292603 "$node_(163) setdest 178982 29126 9.0" 
$ns at 503.5981299134663 "$node_(163) setdest 188382 747 9.0" 
$ns at 544.2239175130421 "$node_(163) setdest 19294 856 9.0" 
$ns at 591.2162877222783 "$node_(163) setdest 93429 61098 2.0" 
$ns at 633.9019586659533 "$node_(163) setdest 102732 43977 16.0" 
$ns at 773.4454998532561 "$node_(163) setdest 69756 88550 15.0" 
$ns at 181.4917047658588 "$node_(164) setdest 6938 32241 1.0" 
$ns at 220.71388255413535 "$node_(164) setdest 83312 18956 15.0" 
$ns at 301.47849939092123 "$node_(164) setdest 2457 33403 4.0" 
$ns at 371.2710374000826 "$node_(164) setdest 14020 1506 11.0" 
$ns at 452.16927487522975 "$node_(164) setdest 18408 54981 3.0" 
$ns at 501.0786555129001 "$node_(164) setdest 190716 51771 11.0" 
$ns at 546.3094526053811 "$node_(164) setdest 61668 47697 20.0" 
$ns at 770.7157159555552 "$node_(164) setdest 247723 10695 19.0" 
$ns at 835.2232015999961 "$node_(164) setdest 159821 46510 10.0" 
$ns at 107.50609718653004 "$node_(165) setdest 34440 11654 2.0" 
$ns at 148.85624553464913 "$node_(165) setdest 5593 16709 16.0" 
$ns at 296.09980075575083 "$node_(165) setdest 124589 25947 17.0" 
$ns at 382.1874284410679 "$node_(165) setdest 52512 42519 6.0" 
$ns at 426.9293320264999 "$node_(165) setdest 156364 51806 12.0" 
$ns at 475.2110454909437 "$node_(165) setdest 115731 2931 14.0" 
$ns at 627.9784897082407 "$node_(165) setdest 111030 6821 15.0" 
$ns at 749.8148405411538 "$node_(165) setdest 232478 31888 17.0" 
$ns at 185.2058256562604 "$node_(166) setdest 82598 28537 7.0" 
$ns at 220.57517263554797 "$node_(166) setdest 14736 7139 10.0" 
$ns at 253.69648030635096 "$node_(166) setdest 153991 50060 15.0" 
$ns at 341.0974721207481 "$node_(166) setdest 103226 24726 2.0" 
$ns at 373.31687235806055 "$node_(166) setdest 100395 44410 18.0" 
$ns at 519.2712839267836 "$node_(166) setdest 51572 15458 16.0" 
$ns at 624.2818857951154 "$node_(166) setdest 167177 48737 2.0" 
$ns at 666.9262938246437 "$node_(166) setdest 91371 11169 1.0" 
$ns at 702.7168241493747 "$node_(166) setdest 232547 21413 5.0" 
$ns at 737.9103514831282 "$node_(166) setdest 51001 51822 14.0" 
$ns at 795.8364511015311 "$node_(166) setdest 211991 17937 17.0" 
$ns at 865.5669393694523 "$node_(166) setdest 57935 34413 1.0" 
$ns at 897.5379934252968 "$node_(166) setdest 212826 13535 17.0" 
$ns at 162.19531334822284 "$node_(167) setdest 93508 39967 1.0" 
$ns at 199.2601309882459 "$node_(167) setdest 116954 18951 6.0" 
$ns at 270.9886409593715 "$node_(167) setdest 45490 34924 4.0" 
$ns at 332.2803394662709 "$node_(167) setdest 3999 27314 8.0" 
$ns at 412.50002119533104 "$node_(167) setdest 66796 23030 19.0" 
$ns at 489.55996969140836 "$node_(167) setdest 98171 46962 8.0" 
$ns at 529.2933668762337 "$node_(167) setdest 18550 6477 12.0" 
$ns at 638.1745712079178 "$node_(167) setdest 226502 6646 5.0" 
$ns at 700.9343117020788 "$node_(167) setdest 97823 23433 2.0" 
$ns at 736.1178137947857 "$node_(167) setdest 123093 52562 13.0" 
$ns at 814.971617278007 "$node_(167) setdest 38125 11131 15.0" 
$ns at 104.52901897292153 "$node_(168) setdest 23795 9868 5.0" 
$ns at 179.96287046870958 "$node_(168) setdest 96238 9572 19.0" 
$ns at 296.4941331528386 "$node_(168) setdest 4256 23517 15.0" 
$ns at 396.6396950762719 "$node_(168) setdest 151584 27278 3.0" 
$ns at 445.74428711089325 "$node_(168) setdest 105187 28555 19.0" 
$ns at 537.755923426912 "$node_(168) setdest 78735 32690 6.0" 
$ns at 584.7362496574252 "$node_(168) setdest 169521 60038 14.0" 
$ns at 664.6005964657551 "$node_(168) setdest 214765 63957 9.0" 
$ns at 783.567223982519 "$node_(168) setdest 150268 13254 9.0" 
$ns at 868.6534968911167 "$node_(168) setdest 33846 29277 5.0" 
$ns at 136.62853702560852 "$node_(169) setdest 41893 27141 16.0" 
$ns at 250.41049161658674 "$node_(169) setdest 17957 18827 19.0" 
$ns at 288.70071971143216 "$node_(169) setdest 34681 49809 10.0" 
$ns at 408.1302550314065 "$node_(169) setdest 43345 17052 8.0" 
$ns at 455.9154555089742 "$node_(169) setdest 81962 17302 13.0" 
$ns at 572.6342189127099 "$node_(169) setdest 34683 25660 18.0" 
$ns at 641.5197563121544 "$node_(169) setdest 196270 2992 2.0" 
$ns at 674.601498747989 "$node_(169) setdest 122686 70394 20.0" 
$ns at 833.9814934894501 "$node_(169) setdest 114176 35112 6.0" 
$ns at 115.60691197813081 "$node_(170) setdest 45856 6610 19.0" 
$ns at 232.0295603012887 "$node_(170) setdest 62413 1224 9.0" 
$ns at 344.93932127253544 "$node_(170) setdest 98018 48642 17.0" 
$ns at 457.36091332172356 "$node_(170) setdest 106909 42043 19.0" 
$ns at 581.1458661489372 "$node_(170) setdest 40105 28287 1.0" 
$ns at 617.6445109030105 "$node_(170) setdest 167990 31843 4.0" 
$ns at 670.6118207497674 "$node_(170) setdest 235397 21790 2.0" 
$ns at 715.2750738727308 "$node_(170) setdest 189804 54341 13.0" 
$ns at 780.8088258617514 "$node_(170) setdest 147303 14152 17.0" 
$ns at 830.000037164192 "$node_(170) setdest 133875 25078 12.0" 
$ns at 873.049140473345 "$node_(170) setdest 218797 25693 7.0" 
$ns at 102.22634373947578 "$node_(171) setdest 25685 3804 6.0" 
$ns at 179.63433974124433 "$node_(171) setdest 5793 43422 14.0" 
$ns at 304.25708561934294 "$node_(171) setdest 13346 36322 2.0" 
$ns at 346.2757554767001 "$node_(171) setdest 86260 17455 2.0" 
$ns at 383.62072750767425 "$node_(171) setdest 100522 28612 2.0" 
$ns at 427.17902304845916 "$node_(171) setdest 126525 28333 18.0" 
$ns at 601.062025262021 "$node_(171) setdest 131063 41178 15.0" 
$ns at 766.0347656993944 "$node_(171) setdest 290 58521 6.0" 
$ns at 834.0616615749601 "$node_(171) setdest 39123 82757 20.0" 
$ns at 206.8464946254612 "$node_(172) setdest 14836 33526 3.0" 
$ns at 259.97057238265353 "$node_(172) setdest 121990 21566 9.0" 
$ns at 305.05182960702695 "$node_(172) setdest 154758 50825 19.0" 
$ns at 406.9376292643902 "$node_(172) setdest 122756 50525 5.0" 
$ns at 463.1507480471321 "$node_(172) setdest 134383 57349 18.0" 
$ns at 524.0607717098013 "$node_(172) setdest 107218 30017 3.0" 
$ns at 562.2455797989879 "$node_(172) setdest 198499 44929 9.0" 
$ns at 680.3670544984042 "$node_(172) setdest 213931 50372 2.0" 
$ns at 720.8115905962949 "$node_(172) setdest 248866 56916 11.0" 
$ns at 779.1979327196491 "$node_(172) setdest 6204 48005 19.0" 
$ns at 149.93668567224975 "$node_(173) setdest 86847 13484 15.0" 
$ns at 310.46800484968435 "$node_(173) setdest 116406 30471 13.0" 
$ns at 373.93490262596373 "$node_(173) setdest 134280 51270 1.0" 
$ns at 405.6619573386154 "$node_(173) setdest 29244 865 2.0" 
$ns at 453.1577517603213 "$node_(173) setdest 120838 65423 19.0" 
$ns at 570.3712670445148 "$node_(173) setdest 70475 45195 8.0" 
$ns at 650.267800577721 "$node_(173) setdest 5345 72693 1.0" 
$ns at 686.5299025748466 "$node_(173) setdest 132902 46310 14.0" 
$ns at 824.9535216724599 "$node_(173) setdest 169944 82959 15.0" 
$ns at 127.53649570330572 "$node_(174) setdest 19974 4017 17.0" 
$ns at 204.78582227680525 "$node_(174) setdest 112605 5153 16.0" 
$ns at 263.1087438138201 "$node_(174) setdest 71375 29000 3.0" 
$ns at 305.9712947630485 "$node_(174) setdest 87533 40169 12.0" 
$ns at 436.62999328435774 "$node_(174) setdest 65687 13323 1.0" 
$ns at 466.71656042011364 "$node_(174) setdest 99535 45685 6.0" 
$ns at 508.42092783310926 "$node_(174) setdest 166872 22092 17.0" 
$ns at 581.4021708375551 "$node_(174) setdest 70989 54170 1.0" 
$ns at 618.0142649095076 "$node_(174) setdest 213600 66951 11.0" 
$ns at 717.6232368314642 "$node_(174) setdest 76867 57431 17.0" 
$ns at 210.3637471346931 "$node_(175) setdest 73076 19340 1.0" 
$ns at 249.00259424456138 "$node_(175) setdest 92163 9683 3.0" 
$ns at 297.524604778677 "$node_(175) setdest 136358 42645 20.0" 
$ns at 517.2398529300484 "$node_(175) setdest 37081 27647 11.0" 
$ns at 649.6752625709462 "$node_(175) setdest 36358 9261 12.0" 
$ns at 787.4839636341233 "$node_(175) setdest 256939 17029 1.0" 
$ns at 825.9702108868192 "$node_(175) setdest 34802 84797 14.0" 
$ns at 111.36243737213547 "$node_(176) setdest 12444 19095 13.0" 
$ns at 151.07814585901585 "$node_(176) setdest 117287 3601 4.0" 
$ns at 194.93005465177862 "$node_(176) setdest 17694 8884 11.0" 
$ns at 270.78351531801485 "$node_(176) setdest 110955 23507 8.0" 
$ns at 359.3072927961137 "$node_(176) setdest 110113 10883 2.0" 
$ns at 401.0835315529446 "$node_(176) setdest 44600 29720 16.0" 
$ns at 437.7406195328727 "$node_(176) setdest 33274 56897 11.0" 
$ns at 561.7568782468763 "$node_(176) setdest 26148 49529 2.0" 
$ns at 592.7227943361414 "$node_(176) setdest 171210 53370 17.0" 
$ns at 791.5617973613065 "$node_(176) setdest 3399 32091 12.0" 
$ns at 835.1091705958381 "$node_(176) setdest 192508 39197 2.0" 
$ns at 885.0344339590828 "$node_(176) setdest 245819 80766 10.0" 
$ns at 124.04390167121701 "$node_(177) setdest 83257 28930 11.0" 
$ns at 204.20391274773684 "$node_(177) setdest 59252 17115 7.0" 
$ns at 254.97223806309933 "$node_(177) setdest 118884 46742 12.0" 
$ns at 296.3902749527019 "$node_(177) setdest 87843 24777 13.0" 
$ns at 368.0679593658598 "$node_(177) setdest 74684 31801 7.0" 
$ns at 461.0788273297715 "$node_(177) setdest 131457 6441 6.0" 
$ns at 506.82775574210933 "$node_(177) setdest 115513 67268 19.0" 
$ns at 590.8347779983827 "$node_(177) setdest 187068 48405 15.0" 
$ns at 691.7263413198467 "$node_(177) setdest 147747 1638 18.0" 
$ns at 782.7346656065369 "$node_(177) setdest 139986 73144 12.0" 
$ns at 836.4097594824403 "$node_(177) setdest 164657 59547 2.0" 
$ns at 877.5271476005443 "$node_(177) setdest 80770 63721 11.0" 
$ns at 142.94123512787905 "$node_(178) setdest 36310 1429 3.0" 
$ns at 192.42130259291724 "$node_(178) setdest 22542 42661 5.0" 
$ns at 243.77341363049908 "$node_(178) setdest 2450 39334 15.0" 
$ns at 328.68667420217525 "$node_(178) setdest 59619 43699 7.0" 
$ns at 389.78829588052105 "$node_(178) setdest 110328 22295 5.0" 
$ns at 457.00833712300675 "$node_(178) setdest 38641 10791 9.0" 
$ns at 518.679533373073 "$node_(178) setdest 180537 48011 20.0" 
$ns at 687.8963859231158 "$node_(178) setdest 218017 11607 5.0" 
$ns at 764.9630166262394 "$node_(178) setdest 20674 72261 19.0" 
$ns at 831.0461460875249 "$node_(178) setdest 49539 67794 7.0" 
$ns at 865.7063904574453 "$node_(178) setdest 186572 33579 14.0" 
$ns at 162.9222764878025 "$node_(179) setdest 88135 14258 3.0" 
$ns at 218.71735127450154 "$node_(179) setdest 101757 345 18.0" 
$ns at 315.4649748110181 "$node_(179) setdest 103826 24896 19.0" 
$ns at 461.4802463892884 "$node_(179) setdest 109968 10747 15.0" 
$ns at 566.4728314188454 "$node_(179) setdest 119526 73062 19.0" 
$ns at 647.6876401530524 "$node_(179) setdest 133959 53390 17.0" 
$ns at 775.4516917644469 "$node_(179) setdest 2446 23376 1.0" 
$ns at 811.4525291733986 "$node_(179) setdest 165179 88380 16.0" 
$ns at 134.37028989350694 "$node_(180) setdest 65467 11 9.0" 
$ns at 231.0245123305552 "$node_(180) setdest 51719 25474 11.0" 
$ns at 313.2710963191213 "$node_(180) setdest 110781 51616 13.0" 
$ns at 407.54186577740677 "$node_(180) setdest 59764 31448 16.0" 
$ns at 500.51951565283457 "$node_(180) setdest 72979 55802 11.0" 
$ns at 575.0665986970969 "$node_(180) setdest 55672 68409 2.0" 
$ns at 621.542410341337 "$node_(180) setdest 105125 36670 17.0" 
$ns at 797.6772008761022 "$node_(180) setdest 430 23553 1.0" 
$ns at 828.4635645004881 "$node_(180) setdest 99749 78316 5.0" 
$ns at 130.5056374788828 "$node_(181) setdest 90936 19823 5.0" 
$ns at 195.62739914242985 "$node_(181) setdest 92992 15275 14.0" 
$ns at 332.52367051718556 "$node_(181) setdest 78955 51743 16.0" 
$ns at 440.0666846248743 "$node_(181) setdest 150858 34637 13.0" 
$ns at 599.0784227734159 "$node_(181) setdest 84961 71312 19.0" 
$ns at 654.3028583227215 "$node_(181) setdest 92029 14220 17.0" 
$ns at 853.6312296952054 "$node_(181) setdest 185187 78429 17.0" 
$ns at 162.71364432188804 "$node_(182) setdest 72585 7833 16.0" 
$ns at 345.7172658592931 "$node_(182) setdest 127006 54475 13.0" 
$ns at 385.1937312130527 "$node_(182) setdest 45242 16700 10.0" 
$ns at 421.815259435926 "$node_(182) setdest 115050 287 16.0" 
$ns at 584.2338943674441 "$node_(182) setdest 55463 22963 7.0" 
$ns at 627.6377331963838 "$node_(182) setdest 132530 58186 11.0" 
$ns at 707.8742641349857 "$node_(182) setdest 210140 20753 17.0" 
$ns at 857.9341103037585 "$node_(182) setdest 204594 87482 6.0" 
$ns at 157.99266965203017 "$node_(183) setdest 63650 28182 2.0" 
$ns at 200.0583625778434 "$node_(183) setdest 3726 3428 18.0" 
$ns at 263.7566321358287 "$node_(183) setdest 93179 21928 7.0" 
$ns at 358.21898380582905 "$node_(183) setdest 35750 36325 4.0" 
$ns at 390.6138322298534 "$node_(183) setdest 66283 25108 5.0" 
$ns at 445.64661606171705 "$node_(183) setdest 10969 46098 19.0" 
$ns at 478.3249207841338 "$node_(183) setdest 174661 40798 6.0" 
$ns at 564.9239627013168 "$node_(183) setdest 129006 74598 7.0" 
$ns at 604.2960785308703 "$node_(183) setdest 95148 64967 10.0" 
$ns at 648.5255177390708 "$node_(183) setdest 72602 61265 18.0" 
$ns at 805.1274452339607 "$node_(183) setdest 137967 82249 16.0" 
$ns at 839.5951345462081 "$node_(183) setdest 17684 5569 19.0" 
$ns at 185.52909395717575 "$node_(184) setdest 132437 24834 18.0" 
$ns at 387.59326911191727 "$node_(184) setdest 125871 54484 9.0" 
$ns at 440.14174448381846 "$node_(184) setdest 18228 52760 15.0" 
$ns at 553.0926976314532 "$node_(184) setdest 56658 75651 2.0" 
$ns at 600.6245146581774 "$node_(184) setdest 147167 49661 15.0" 
$ns at 644.8190705067918 "$node_(184) setdest 79199 48061 10.0" 
$ns at 691.8641439226699 "$node_(184) setdest 170543 73901 8.0" 
$ns at 736.6764754027554 "$node_(184) setdest 48629 56425 1.0" 
$ns at 766.7970486139411 "$node_(184) setdest 261561 77878 19.0" 
$ns at 101.29829864274893 "$node_(185) setdest 41577 16310 20.0" 
$ns at 293.7366579472408 "$node_(185) setdest 12752 19013 13.0" 
$ns at 327.01646209033754 "$node_(185) setdest 25826 462 10.0" 
$ns at 359.62971184234436 "$node_(185) setdest 106114 56221 12.0" 
$ns at 421.4840330558583 "$node_(185) setdest 3675 6670 17.0" 
$ns at 619.0681366364669 "$node_(185) setdest 203425 61086 14.0" 
$ns at 735.2402215162341 "$node_(185) setdest 72198 43567 13.0" 
$ns at 803.2167427392158 "$node_(185) setdest 240789 8892 16.0" 
$ns at 118.37224541122632 "$node_(186) setdest 73362 30197 6.0" 
$ns at 162.14239575976052 "$node_(186) setdest 89629 23123 17.0" 
$ns at 254.82252375707023 "$node_(186) setdest 68732 45608 14.0" 
$ns at 350.97746864981616 "$node_(186) setdest 13153 46461 3.0" 
$ns at 386.96369554316806 "$node_(186) setdest 110784 59264 2.0" 
$ns at 433.10385304847244 "$node_(186) setdest 147731 11923 5.0" 
$ns at 478.0433266184423 "$node_(186) setdest 52058 15553 13.0" 
$ns at 594.5031038343066 "$node_(186) setdest 62719 60097 2.0" 
$ns at 628.3387348714955 "$node_(186) setdest 68581 62767 3.0" 
$ns at 660.2685666515356 "$node_(186) setdest 231202 73607 12.0" 
$ns at 737.5339750865119 "$node_(186) setdest 195718 72839 18.0" 
$ns at 831.2011627064683 "$node_(186) setdest 235793 41408 1.0" 
$ns at 864.4926515666749 "$node_(186) setdest 45735 13466 17.0" 
$ns at 211.22074246232887 "$node_(187) setdest 91326 40859 4.0" 
$ns at 269.881829140741 "$node_(187) setdest 125940 10519 13.0" 
$ns at 300.0059670981582 "$node_(187) setdest 43678 39247 6.0" 
$ns at 350.064640390312 "$node_(187) setdest 182194 3718 5.0" 
$ns at 381.50005620595726 "$node_(187) setdest 145775 11280 1.0" 
$ns at 412.1743210968222 "$node_(187) setdest 95623 51581 1.0" 
$ns at 449.9845715384512 "$node_(187) setdest 123287 3599 16.0" 
$ns at 545.0867242046484 "$node_(187) setdest 102809 57577 17.0" 
$ns at 611.3008641600667 "$node_(187) setdest 219194 19557 20.0" 
$ns at 764.1009689755845 "$node_(187) setdest 140976 58192 13.0" 
$ns at 808.4305880875496 "$node_(187) setdest 113420 70474 11.0" 
$ns at 114.84459245638675 "$node_(188) setdest 6391 30260 5.0" 
$ns at 192.6741609207225 "$node_(188) setdest 94268 37523 15.0" 
$ns at 254.81308831028673 "$node_(188) setdest 137096 21077 19.0" 
$ns at 301.3160495591725 "$node_(188) setdest 149463 29721 10.0" 
$ns at 354.35169574845213 "$node_(188) setdest 151011 38008 1.0" 
$ns at 387.1236779766956 "$node_(188) setdest 2970 51990 12.0" 
$ns at 498.0829450737795 "$node_(188) setdest 195582 17293 8.0" 
$ns at 591.8018534580676 "$node_(188) setdest 30316 56590 18.0" 
$ns at 655.3415719065135 "$node_(188) setdest 61577 67961 4.0" 
$ns at 714.3877001226907 "$node_(188) setdest 137697 44619 11.0" 
$ns at 756.8699862246976 "$node_(188) setdest 229814 24327 10.0" 
$ns at 814.7251490119614 "$node_(188) setdest 50976 43387 18.0" 
$ns at 894.3601832085748 "$node_(188) setdest 68540 37241 18.0" 
$ns at 212.24915830910055 "$node_(189) setdest 42556 28974 10.0" 
$ns at 273.48579615751635 "$node_(189) setdest 37541 41830 19.0" 
$ns at 479.86150998645996 "$node_(189) setdest 188408 35241 6.0" 
$ns at 552.7392846566642 "$node_(189) setdest 122200 28017 7.0" 
$ns at 604.2300649569095 "$node_(189) setdest 143044 70794 3.0" 
$ns at 653.2486132511981 "$node_(189) setdest 143312 11277 18.0" 
$ns at 685.5539937409371 "$node_(189) setdest 107901 61030 4.0" 
$ns at 720.3903596839899 "$node_(189) setdest 214168 6309 9.0" 
$ns at 806.6592222626375 "$node_(189) setdest 21986 30146 18.0" 
$ns at 842.443319408489 "$node_(189) setdest 192556 23095 6.0" 
$ns at 194.83745427240055 "$node_(190) setdest 11071 36828 9.0" 
$ns at 268.30917989794557 "$node_(190) setdest 38952 24226 18.0" 
$ns at 344.4717596476918 "$node_(190) setdest 77556 8686 2.0" 
$ns at 390.72288693383405 "$node_(190) setdest 66374 30603 15.0" 
$ns at 531.3087839683392 "$node_(190) setdest 166714 8083 8.0" 
$ns at 575.5963201189321 "$node_(190) setdest 120799 63502 4.0" 
$ns at 614.416624602009 "$node_(190) setdest 187178 41996 3.0" 
$ns at 652.6930493199675 "$node_(190) setdest 66761 51839 8.0" 
$ns at 757.5025225799502 "$node_(190) setdest 14241 67576 4.0" 
$ns at 801.8589256560209 "$node_(190) setdest 147126 18424 2.0" 
$ns at 844.1368467264413 "$node_(190) setdest 227753 60157 11.0" 
$ns at 120.44712154097155 "$node_(191) setdest 26995 17609 12.0" 
$ns at 203.85281809850392 "$node_(191) setdest 33353 3129 8.0" 
$ns at 255.5521466364529 "$node_(191) setdest 78661 27360 17.0" 
$ns at 352.84462278685066 "$node_(191) setdest 57274 22906 7.0" 
$ns at 424.36851092584897 "$node_(191) setdest 137455 2441 10.0" 
$ns at 551.6548099633894 "$node_(191) setdest 214858 9244 3.0" 
$ns at 609.2087650145504 "$node_(191) setdest 91880 43278 13.0" 
$ns at 739.1467150548451 "$node_(191) setdest 202504 22561 3.0" 
$ns at 794.0096778388462 "$node_(191) setdest 193629 32822 13.0" 
$ns at 144.64754817426075 "$node_(192) setdest 18092 11767 3.0" 
$ns at 182.96277153692017 "$node_(192) setdest 60081 12405 5.0" 
$ns at 226.90181951478564 "$node_(192) setdest 65240 26737 16.0" 
$ns at 364.2001766829029 "$node_(192) setdest 147218 24379 16.0" 
$ns at 446.6633616416204 "$node_(192) setdest 150132 11185 6.0" 
$ns at 486.5853089651776 "$node_(192) setdest 121543 34397 16.0" 
$ns at 567.3262047526961 "$node_(192) setdest 214460 37350 14.0" 
$ns at 718.5572786082244 "$node_(192) setdest 222389 33224 4.0" 
$ns at 773.1663142520213 "$node_(192) setdest 55712 46882 8.0" 
$ns at 814.7139803129324 "$node_(192) setdest 106597 8213 1.0" 
$ns at 852.6201219037409 "$node_(192) setdest 235944 82691 14.0" 
$ns at 135.93196570127012 "$node_(193) setdest 88151 1868 5.0" 
$ns at 181.4656355258594 "$node_(193) setdest 17047 37589 18.0" 
$ns at 376.33698932675117 "$node_(193) setdest 88719 58656 10.0" 
$ns at 460.6656525887921 "$node_(193) setdest 103667 7525 12.0" 
$ns at 508.63478140471386 "$node_(193) setdest 74365 45627 5.0" 
$ns at 560.972789728029 "$node_(193) setdest 227448 7828 8.0" 
$ns at 631.2894643447298 "$node_(193) setdest 33165 52865 19.0" 
$ns at 788.0620899556255 "$node_(193) setdest 25912 4759 14.0" 
$ns at 882.7607309263769 "$node_(193) setdest 35955 84540 19.0" 
$ns at 156.2293050864308 "$node_(194) setdest 125863 33922 10.0" 
$ns at 278.72681288680707 "$node_(194) setdest 90177 10381 12.0" 
$ns at 421.8099711045909 "$node_(194) setdest 13832 13571 1.0" 
$ns at 452.50859643298213 "$node_(194) setdest 75807 52928 11.0" 
$ns at 585.7273862620319 "$node_(194) setdest 2426 11995 8.0" 
$ns at 637.7052174011844 "$node_(194) setdest 64360 8481 7.0" 
$ns at 724.1779502022397 "$node_(194) setdest 109377 25678 15.0" 
$ns at 146.10995931873305 "$node_(195) setdest 68349 28173 7.0" 
$ns at 178.63162960850934 "$node_(195) setdest 120101 9273 3.0" 
$ns at 227.33576034145352 "$node_(195) setdest 103810 32886 19.0" 
$ns at 288.1342464638789 "$node_(195) setdest 119260 36786 13.0" 
$ns at 418.4613466524983 "$node_(195) setdest 187949 49404 10.0" 
$ns at 509.2348633562809 "$node_(195) setdest 94433 53706 16.0" 
$ns at 569.8593420666324 "$node_(195) setdest 109213 38397 9.0" 
$ns at 615.0993983641191 "$node_(195) setdest 46348 34026 15.0" 
$ns at 727.7780146398594 "$node_(195) setdest 73741 73810 19.0" 
$ns at 859.5608135176121 "$node_(195) setdest 33010 65138 19.0" 
$ns at 110.98491489010584 "$node_(196) setdest 62828 7773 6.0" 
$ns at 146.91368675629303 "$node_(196) setdest 77049 20058 16.0" 
$ns at 196.56244314388067 "$node_(196) setdest 46071 3989 6.0" 
$ns at 235.3335197377342 "$node_(196) setdest 2391 9616 1.0" 
$ns at 266.5365200969176 "$node_(196) setdest 32056 40613 20.0" 
$ns at 400.18497561650383 "$node_(196) setdest 7464 57155 3.0" 
$ns at 431.8574002938225 "$node_(196) setdest 124902 35941 7.0" 
$ns at 514.1395701773338 "$node_(196) setdest 97223 63607 2.0" 
$ns at 551.5766830430093 "$node_(196) setdest 167937 65095 5.0" 
$ns at 600.0119610235871 "$node_(196) setdest 11650 24857 16.0" 
$ns at 750.2931061453621 "$node_(196) setdest 221901 80617 8.0" 
$ns at 852.8058278098155 "$node_(196) setdest 93493 45260 6.0" 
$ns at 883.6130243117226 "$node_(196) setdest 148483 1100 8.0" 
$ns at 136.08906352039992 "$node_(197) setdest 15684 5061 2.0" 
$ns at 183.13627851788738 "$node_(197) setdest 107575 10567 5.0" 
$ns at 232.01396825816167 "$node_(197) setdest 121061 18429 16.0" 
$ns at 355.17813359980397 "$node_(197) setdest 17354 43699 12.0" 
$ns at 484.7788186747177 "$node_(197) setdest 181601 52227 1.0" 
$ns at 520.2953137695065 "$node_(197) setdest 169632 8780 10.0" 
$ns at 561.860005941256 "$node_(197) setdest 94862 66388 9.0" 
$ns at 674.3011977978695 "$node_(197) setdest 156145 53660 5.0" 
$ns at 738.3225259583185 "$node_(197) setdest 207153 7899 7.0" 
$ns at 822.8374670657951 "$node_(197) setdest 23621 14095 7.0" 
$ns at 131.77081999428825 "$node_(198) setdest 46695 17020 11.0" 
$ns at 182.27602493977497 "$node_(198) setdest 104521 10925 6.0" 
$ns at 248.12975416070788 "$node_(198) setdest 131817 41694 17.0" 
$ns at 410.9733686899025 "$node_(198) setdest 24904 12070 9.0" 
$ns at 486.462523043448 "$node_(198) setdest 165095 10700 18.0" 
$ns at 626.2572055865296 "$node_(198) setdest 140415 13941 13.0" 
$ns at 746.52156414727 "$node_(198) setdest 75929 33340 3.0" 
$ns at 789.8552125744766 "$node_(198) setdest 228869 33086 16.0" 
$ns at 136.1398407989997 "$node_(199) setdest 71064 9435 9.0" 
$ns at 214.71451071535049 "$node_(199) setdest 39946 3112 17.0" 
$ns at 254.15837057978783 "$node_(199) setdest 127873 33308 9.0" 
$ns at 347.78925413255945 "$node_(199) setdest 31466 45102 17.0" 
$ns at 433.69078492518474 "$node_(199) setdest 148941 62841 1.0" 
$ns at 472.54926378300746 "$node_(199) setdest 99670 33600 13.0" 
$ns at 552.9148229744834 "$node_(199) setdest 182741 69558 9.0" 
$ns at 601.1040135838746 "$node_(199) setdest 68059 60125 3.0" 
$ns at 652.3158312709726 "$node_(199) setdest 103986 74264 1.0" 
$ns at 683.1090435171193 "$node_(199) setdest 214589 29045 17.0" 
$ns at 808.9369668231998 "$node_(199) setdest 175090 2922 7.0" 
$ns at 890.5418206461115 "$node_(199) setdest 222965 81262 13.0" 
$ns at 267.57242568310505 "$node_(200) setdest 92914 33566 12.0" 
$ns at 413.74643633821904 "$node_(200) setdest 110684 25233 4.0" 
$ns at 481.97463216637016 "$node_(200) setdest 54404 5359 1.0" 
$ns at 519.251707018131 "$node_(200) setdest 43704 26544 4.0" 
$ns at 571.896854765472 "$node_(200) setdest 132968 17931 6.0" 
$ns at 653.7579982352629 "$node_(200) setdest 74283 30884 4.0" 
$ns at 717.7350824807271 "$node_(200) setdest 99186 17769 11.0" 
$ns at 796.8348580117062 "$node_(200) setdest 17809 7146 10.0" 
$ns at 856.2697940495578 "$node_(200) setdest 47452 21538 5.0" 
$ns at 253.6971362452008 "$node_(201) setdest 76151 14382 17.0" 
$ns at 324.236798763092 "$node_(201) setdest 81178 32364 19.0" 
$ns at 484.74976565354496 "$node_(201) setdest 74631 4234 14.0" 
$ns at 636.8253579979229 "$node_(201) setdest 77671 37169 9.0" 
$ns at 679.5720622292049 "$node_(201) setdest 873 24652 11.0" 
$ns at 720.7020769399467 "$node_(201) setdest 132069 37100 9.0" 
$ns at 775.3274274536525 "$node_(201) setdest 51470 46 1.0" 
$ns at 814.6020240890523 "$node_(201) setdest 123529 22496 16.0" 
$ns at 258.2919096928052 "$node_(202) setdest 86455 18903 15.0" 
$ns at 416.9255820541089 "$node_(202) setdest 13439 1937 6.0" 
$ns at 479.1562111124509 "$node_(202) setdest 61804 28740 14.0" 
$ns at 538.1965503122859 "$node_(202) setdest 89435 17782 17.0" 
$ns at 601.4820418923734 "$node_(202) setdest 88000 9783 15.0" 
$ns at 778.5064465775424 "$node_(202) setdest 92725 39559 2.0" 
$ns at 827.2201974717921 "$node_(202) setdest 91830 21406 8.0" 
$ns at 265.3439608344748 "$node_(203) setdest 34020 40426 6.0" 
$ns at 343.809881966751 "$node_(203) setdest 13773 37319 15.0" 
$ns at 466.8196103128419 "$node_(203) setdest 41873 40305 7.0" 
$ns at 518.9585978508023 "$node_(203) setdest 32985 3456 11.0" 
$ns at 638.4595427775695 "$node_(203) setdest 83806 31867 13.0" 
$ns at 758.0074345895353 "$node_(203) setdest 38058 9562 3.0" 
$ns at 790.6754167491981 "$node_(203) setdest 18218 23731 7.0" 
$ns at 860.228095788225 "$node_(203) setdest 57516 32830 4.0" 
$ns at 210.50954073718202 "$node_(204) setdest 46531 14209 3.0" 
$ns at 243.9844384233518 "$node_(204) setdest 89533 25796 14.0" 
$ns at 310.90492306408447 "$node_(204) setdest 66518 10765 15.0" 
$ns at 426.6024576159232 "$node_(204) setdest 47079 14170 11.0" 
$ns at 529.280696460965 "$node_(204) setdest 40527 33355 18.0" 
$ns at 560.2828017439878 "$node_(204) setdest 7498 18905 5.0" 
$ns at 637.9071556360799 "$node_(204) setdest 107386 30372 4.0" 
$ns at 687.3787522835701 "$node_(204) setdest 127358 29160 11.0" 
$ns at 806.614340516141 "$node_(204) setdest 49621 40900 17.0" 
$ns at 262.679285126635 "$node_(205) setdest 126314 7374 13.0" 
$ns at 340.2991403849876 "$node_(205) setdest 119594 31887 1.0" 
$ns at 376.0146940898739 "$node_(205) setdest 3267 40339 16.0" 
$ns at 481.9918495833045 "$node_(205) setdest 123252 12882 1.0" 
$ns at 520.1799350191 "$node_(205) setdest 97088 32982 1.0" 
$ns at 555.7023594941609 "$node_(205) setdest 84419 19964 6.0" 
$ns at 638.5457124702307 "$node_(205) setdest 49582 27479 14.0" 
$ns at 791.4305265851572 "$node_(205) setdest 3206 40850 17.0" 
$ns at 284.50182308942215 "$node_(206) setdest 3247 42048 15.0" 
$ns at 371.42708836397367 "$node_(206) setdest 69590 42792 18.0" 
$ns at 403.10724674897904 "$node_(206) setdest 123299 24712 9.0" 
$ns at 468.8392510463978 "$node_(206) setdest 89319 20200 19.0" 
$ns at 594.267678157335 "$node_(206) setdest 86051 24104 5.0" 
$ns at 642.2645913266114 "$node_(206) setdest 122742 22886 15.0" 
$ns at 736.9049894258087 "$node_(206) setdest 53865 40091 7.0" 
$ns at 769.1310643403488 "$node_(206) setdest 4847 10780 20.0" 
$ns at 212.66972647530997 "$node_(207) setdest 11832 5873 16.0" 
$ns at 311.34905946971895 "$node_(207) setdest 71634 20669 6.0" 
$ns at 396.17948101581646 "$node_(207) setdest 67556 29933 6.0" 
$ns at 472.3741881325973 "$node_(207) setdest 69368 19041 3.0" 
$ns at 504.3395083333798 "$node_(207) setdest 115356 14238 18.0" 
$ns at 701.4898262802444 "$node_(207) setdest 75552 19576 8.0" 
$ns at 734.1278572631077 "$node_(207) setdest 19742 42651 16.0" 
$ns at 279.1869901708407 "$node_(208) setdest 107636 26420 2.0" 
$ns at 314.5120074555038 "$node_(208) setdest 82889 13453 8.0" 
$ns at 422.4419870704263 "$node_(208) setdest 31541 22692 3.0" 
$ns at 476.0193100345032 "$node_(208) setdest 30999 32527 11.0" 
$ns at 561.0354938633865 "$node_(208) setdest 93553 2127 19.0" 
$ns at 676.4833908967819 "$node_(208) setdest 18172 36850 18.0" 
$ns at 874.480807345753 "$node_(208) setdest 19687 38776 16.0" 
$ns at 303.84042333553 "$node_(209) setdest 39675 20479 8.0" 
$ns at 412.6035421293959 "$node_(209) setdest 46297 5285 7.0" 
$ns at 465.70002168440004 "$node_(209) setdest 96331 32835 1.0" 
$ns at 497.6472941052621 "$node_(209) setdest 15125 26845 1.0" 
$ns at 536.1260695828549 "$node_(209) setdest 24030 25341 17.0" 
$ns at 614.7984451580954 "$node_(209) setdest 21048 18866 8.0" 
$ns at 716.1678014146446 "$node_(209) setdest 65581 17622 20.0" 
$ns at 896.5441623296176 "$node_(209) setdest 88962 21873 10.0" 
$ns at 255.28266122589426 "$node_(210) setdest 17992 4427 19.0" 
$ns at 332.7141325378622 "$node_(210) setdest 85350 7410 5.0" 
$ns at 399.21761797534157 "$node_(210) setdest 34317 33593 7.0" 
$ns at 450.5173652389449 "$node_(210) setdest 123839 9558 8.0" 
$ns at 532.370043364973 "$node_(210) setdest 31055 13415 11.0" 
$ns at 630.450124539926 "$node_(210) setdest 8228 27363 18.0" 
$ns at 805.2271560194281 "$node_(210) setdest 32691 35032 17.0" 
$ns at 225.32433470848048 "$node_(211) setdest 684 3121 4.0" 
$ns at 293.3577866689444 "$node_(211) setdest 32629 14449 13.0" 
$ns at 372.9532223871265 "$node_(211) setdest 34787 14742 19.0" 
$ns at 404.77116120655506 "$node_(211) setdest 88719 15764 16.0" 
$ns at 443.2996934859314 "$node_(211) setdest 20250 23607 10.0" 
$ns at 507.62307771462156 "$node_(211) setdest 67314 821 10.0" 
$ns at 631.7037505875204 "$node_(211) setdest 33829 17569 7.0" 
$ns at 699.9439640284227 "$node_(211) setdest 92627 8297 13.0" 
$ns at 824.7461350250042 "$node_(211) setdest 3129 18433 4.0" 
$ns at 886.4777733496536 "$node_(211) setdest 113509 35937 4.0" 
$ns at 326.0396416845889 "$node_(212) setdest 110747 39373 18.0" 
$ns at 440.9853647782236 "$node_(212) setdest 21260 39497 9.0" 
$ns at 542.2857847036282 "$node_(212) setdest 38312 5175 17.0" 
$ns at 677.2378173673583 "$node_(212) setdest 85972 21011 13.0" 
$ns at 787.8387993489002 "$node_(212) setdest 12569 5303 11.0" 
$ns at 885.904076816217 "$node_(212) setdest 1154 14400 19.0" 
$ns at 245.1497530064528 "$node_(213) setdest 89545 19449 1.0" 
$ns at 277.4034221516756 "$node_(213) setdest 100538 39812 3.0" 
$ns at 316.7531211832692 "$node_(213) setdest 111744 35021 5.0" 
$ns at 378.60697153804387 "$node_(213) setdest 4677 8538 19.0" 
$ns at 418.62115714941666 "$node_(213) setdest 41804 21703 18.0" 
$ns at 608.8836841117391 "$node_(213) setdest 90035 17874 7.0" 
$ns at 664.1990006518186 "$node_(213) setdest 102342 8688 9.0" 
$ns at 749.4038361307208 "$node_(213) setdest 21838 35820 6.0" 
$ns at 796.0229324117662 "$node_(213) setdest 99150 18142 19.0" 
$ns at 247.67457170497644 "$node_(214) setdest 44545 43914 1.0" 
$ns at 280.34862407313824 "$node_(214) setdest 63449 18796 17.0" 
$ns at 315.53347280876307 "$node_(214) setdest 91496 38983 12.0" 
$ns at 373.42815483257243 "$node_(214) setdest 34284 26178 1.0" 
$ns at 411.7138809646699 "$node_(214) setdest 108522 42919 18.0" 
$ns at 619.8487696897905 "$node_(214) setdest 55008 40631 17.0" 
$ns at 779.077987337301 "$node_(214) setdest 97512 11293 11.0" 
$ns at 883.1622455345513 "$node_(214) setdest 16924 10408 8.0" 
$ns at 200.88109000645676 "$node_(215) setdest 131265 10925 5.0" 
$ns at 276.13481080290023 "$node_(215) setdest 116561 28882 2.0" 
$ns at 309.46669248104274 "$node_(215) setdest 29230 12904 18.0" 
$ns at 351.15252088639204 "$node_(215) setdest 9519 4308 1.0" 
$ns at 386.9639674284318 "$node_(215) setdest 88971 23468 10.0" 
$ns at 463.99355621236094 "$node_(215) setdest 44603 17560 7.0" 
$ns at 547.6303993456614 "$node_(215) setdest 133077 32229 3.0" 
$ns at 579.0308990763925 "$node_(215) setdest 40900 9278 18.0" 
$ns at 701.3935462486145 "$node_(215) setdest 95539 44118 2.0" 
$ns at 749.5223485061916 "$node_(215) setdest 49766 21279 19.0" 
$ns at 209.51405621381895 "$node_(216) setdest 111306 42669 2.0" 
$ns at 247.94231822340868 "$node_(216) setdest 89119 2699 3.0" 
$ns at 282.27714404497056 "$node_(216) setdest 2885 5288 16.0" 
$ns at 401.57112003378154 "$node_(216) setdest 117087 5161 4.0" 
$ns at 464.5699458579162 "$node_(216) setdest 115952 19127 2.0" 
$ns at 506.0470949578851 "$node_(216) setdest 12391 12169 16.0" 
$ns at 537.1114128369909 "$node_(216) setdest 117641 1840 4.0" 
$ns at 587.1203798183284 "$node_(216) setdest 57498 22442 4.0" 
$ns at 637.1486963387226 "$node_(216) setdest 12299 39637 1.0" 
$ns at 667.2026669344502 "$node_(216) setdest 71663 4532 9.0" 
$ns at 704.4597428242632 "$node_(216) setdest 115205 28622 7.0" 
$ns at 781.6157275303643 "$node_(216) setdest 14873 13082 1.0" 
$ns at 816.0376036903136 "$node_(216) setdest 9749 18820 3.0" 
$ns at 859.4662491156615 "$node_(216) setdest 73385 17352 12.0" 
$ns at 312.4184945337352 "$node_(217) setdest 129602 8645 14.0" 
$ns at 378.39210621377526 "$node_(217) setdest 96549 16800 2.0" 
$ns at 425.6440918781461 "$node_(217) setdest 64313 40226 10.0" 
$ns at 509.55703140644965 "$node_(217) setdest 88132 30388 8.0" 
$ns at 554.7648594533382 "$node_(217) setdest 91922 19955 4.0" 
$ns at 614.1080474027681 "$node_(217) setdest 40968 20542 11.0" 
$ns at 747.4842577133206 "$node_(217) setdest 99301 957 19.0" 
$ns at 282.12943718183124 "$node_(218) setdest 95864 1830 1.0" 
$ns at 321.19746246675845 "$node_(218) setdest 11270 38090 17.0" 
$ns at 424.2611707574083 "$node_(218) setdest 37125 25673 20.0" 
$ns at 522.803118029546 "$node_(218) setdest 85625 41270 8.0" 
$ns at 574.5998070516088 "$node_(218) setdest 73304 19824 8.0" 
$ns at 626.1619891075856 "$node_(218) setdest 37043 19149 10.0" 
$ns at 709.0094312290685 "$node_(218) setdest 128000 32570 8.0" 
$ns at 796.1769089355412 "$node_(218) setdest 9739 32764 6.0" 
$ns at 866.6930788925504 "$node_(218) setdest 25901 9540 10.0" 
$ns at 221.18155427614556 "$node_(219) setdest 9941 17823 12.0" 
$ns at 267.5247098740958 "$node_(219) setdest 31191 26382 8.0" 
$ns at 366.5541320879163 "$node_(219) setdest 57465 2984 6.0" 
$ns at 409.3319655182495 "$node_(219) setdest 97161 17413 4.0" 
$ns at 443.47014560869394 "$node_(219) setdest 127238 7554 6.0" 
$ns at 507.0955162292584 "$node_(219) setdest 294 30585 8.0" 
$ns at 567.3338517221499 "$node_(219) setdest 108886 11203 19.0" 
$ns at 633.7588850888244 "$node_(219) setdest 1109 36854 3.0" 
$ns at 676.7086897572816 "$node_(219) setdest 74533 20032 1.0" 
$ns at 713.8151930211085 "$node_(219) setdest 76531 20532 11.0" 
$ns at 848.4077090305153 "$node_(219) setdest 71859 36286 13.0" 
$ns at 209.73248164394622 "$node_(220) setdest 10954 39907 19.0" 
$ns at 302.2272133051643 "$node_(220) setdest 74165 1360 17.0" 
$ns at 383.51679649725236 "$node_(220) setdest 91212 26984 17.0" 
$ns at 526.0288957855876 "$node_(220) setdest 96953 29549 2.0" 
$ns at 570.9538184819697 "$node_(220) setdest 74244 17322 6.0" 
$ns at 641.3019967121934 "$node_(220) setdest 96240 7152 1.0" 
$ns at 672.7486237453428 "$node_(220) setdest 53591 3632 5.0" 
$ns at 741.6975135081063 "$node_(220) setdest 65314 42110 15.0" 
$ns at 873.9750653116291 "$node_(220) setdest 85942 1770 1.0" 
$ns at 206.43532168207855 "$node_(221) setdest 105013 19118 2.0" 
$ns at 240.83800146407276 "$node_(221) setdest 57451 9699 10.0" 
$ns at 301.27103201848087 "$node_(221) setdest 46418 9026 2.0" 
$ns at 331.8990230674351 "$node_(221) setdest 1776 40664 3.0" 
$ns at 373.33080833207896 "$node_(221) setdest 111090 30644 11.0" 
$ns at 422.71807457320244 "$node_(221) setdest 5284 11116 1.0" 
$ns at 459.8581836549149 "$node_(221) setdest 416 19318 8.0" 
$ns at 543.2526668111408 "$node_(221) setdest 101459 42444 15.0" 
$ns at 628.1778582853655 "$node_(221) setdest 80049 10185 8.0" 
$ns at 715.4984922640784 "$node_(221) setdest 127727 31548 1.0" 
$ns at 753.8123571139413 "$node_(221) setdest 43972 22174 19.0" 
$ns at 231.00316124629268 "$node_(222) setdest 133269 11181 4.0" 
$ns at 300.15686759126186 "$node_(222) setdest 8734 34720 2.0" 
$ns at 335.1449505274993 "$node_(222) setdest 107566 9850 13.0" 
$ns at 443.1939726123588 "$node_(222) setdest 113088 16005 19.0" 
$ns at 517.5920788386579 "$node_(222) setdest 57366 14880 1.0" 
$ns at 548.938638790813 "$node_(222) setdest 64075 22275 1.0" 
$ns at 578.9554877123284 "$node_(222) setdest 107082 13072 19.0" 
$ns at 757.1384520462066 "$node_(222) setdest 73937 349 10.0" 
$ns at 864.3476268105884 "$node_(222) setdest 71992 31419 11.0" 
$ns at 234.25626157742073 "$node_(223) setdest 18233 18575 15.0" 
$ns at 387.4770746672509 "$node_(223) setdest 81290 41153 12.0" 
$ns at 425.89235608628616 "$node_(223) setdest 46260 15514 17.0" 
$ns at 499.76709469004686 "$node_(223) setdest 100680 13858 8.0" 
$ns at 538.9578879915641 "$node_(223) setdest 78956 6246 19.0" 
$ns at 694.6113339361257 "$node_(223) setdest 123877 25965 19.0" 
$ns at 804.3046676638799 "$node_(223) setdest 64510 36485 17.0" 
$ns at 275.9379656116556 "$node_(224) setdest 76307 29282 18.0" 
$ns at 443.47772427327646 "$node_(224) setdest 1483 6083 20.0" 
$ns at 546.8128091383023 "$node_(224) setdest 82224 20944 17.0" 
$ns at 601.9807832168028 "$node_(224) setdest 69903 27725 19.0" 
$ns at 814.0467978213666 "$node_(224) setdest 99741 22495 1.0" 
$ns at 849.2091290664875 "$node_(224) setdest 71428 4607 16.0" 
$ns at 276.2608647961231 "$node_(225) setdest 120310 20627 1.0" 
$ns at 307.3015496331638 "$node_(225) setdest 110240 5599 4.0" 
$ns at 370.9665504262235 "$node_(225) setdest 64264 37436 16.0" 
$ns at 538.0659018806923 "$node_(225) setdest 63564 25652 5.0" 
$ns at 617.7815536889981 "$node_(225) setdest 29271 8010 14.0" 
$ns at 781.5666913154181 "$node_(225) setdest 46867 35622 4.0" 
$ns at 843.149846876277 "$node_(225) setdest 74951 8187 13.0" 
$ns at 218.98891809678804 "$node_(226) setdest 132357 13273 11.0" 
$ns at 342.3292324520593 "$node_(226) setdest 63387 34483 7.0" 
$ns at 433.61634559009434 "$node_(226) setdest 99564 11404 1.0" 
$ns at 472.0170360682503 "$node_(226) setdest 108642 21067 14.0" 
$ns at 571.0567900592962 "$node_(226) setdest 28903 25892 11.0" 
$ns at 658.2980932354205 "$node_(226) setdest 86405 853 3.0" 
$ns at 701.0147011561403 "$node_(226) setdest 127082 43863 16.0" 
$ns at 812.7004428878352 "$node_(226) setdest 106478 33072 1.0" 
$ns at 847.3728110208824 "$node_(226) setdest 107801 33245 8.0" 
$ns at 229.3054728667739 "$node_(227) setdest 55766 21320 4.0" 
$ns at 265.4042256218111 "$node_(227) setdest 64862 43675 17.0" 
$ns at 343.56644681938747 "$node_(227) setdest 55668 41395 9.0" 
$ns at 378.538328979493 "$node_(227) setdest 7511 23696 20.0" 
$ns at 460.99463362382767 "$node_(227) setdest 4286 37418 5.0" 
$ns at 500.09547326794024 "$node_(227) setdest 37491 35937 19.0" 
$ns at 583.2611154793738 "$node_(227) setdest 85856 16995 15.0" 
$ns at 636.6678061288674 "$node_(227) setdest 14998 36306 3.0" 
$ns at 685.2448186271358 "$node_(227) setdest 115785 39728 19.0" 
$ns at 759.7210143445178 "$node_(227) setdest 69436 23411 11.0" 
$ns at 879.377515154326 "$node_(227) setdest 73230 39622 13.0" 
$ns at 218.0540494441077 "$node_(228) setdest 60144 31257 3.0" 
$ns at 248.157279818079 "$node_(228) setdest 28955 15549 11.0" 
$ns at 363.19024918465175 "$node_(228) setdest 81404 38016 19.0" 
$ns at 526.4906564937155 "$node_(228) setdest 14059 35432 1.0" 
$ns at 556.8312315585611 "$node_(228) setdest 7605 33378 17.0" 
$ns at 751.8507066076015 "$node_(228) setdest 44726 24145 7.0" 
$ns at 823.0277161381823 "$node_(228) setdest 30991 44300 18.0" 
$ns at 239.25637586962898 "$node_(229) setdest 36656 10033 19.0" 
$ns at 320.99474175158196 "$node_(229) setdest 127967 43678 20.0" 
$ns at 465.9372663097758 "$node_(229) setdest 83110 2261 17.0" 
$ns at 587.4497114818654 "$node_(229) setdest 120744 5961 11.0" 
$ns at 621.5771377864322 "$node_(229) setdest 77091 24100 10.0" 
$ns at 709.9175569476387 "$node_(229) setdest 9324 8575 19.0" 
$ns at 871.3149505407993 "$node_(229) setdest 126661 17212 19.0" 
$ns at 206.8733917583035 "$node_(230) setdest 87921 38727 15.0" 
$ns at 358.23526576476274 "$node_(230) setdest 102683 17071 9.0" 
$ns at 453.03011842316454 "$node_(230) setdest 5176 36354 9.0" 
$ns at 556.9845214666246 "$node_(230) setdest 60985 18575 5.0" 
$ns at 616.4596347154697 "$node_(230) setdest 31500 40934 16.0" 
$ns at 695.5181782822027 "$node_(230) setdest 120182 13518 2.0" 
$ns at 727.3929758751516 "$node_(230) setdest 121214 15701 15.0" 
$ns at 836.4613098344264 "$node_(230) setdest 13207 7615 2.0" 
$ns at 880.9194641623844 "$node_(230) setdest 50782 40154 12.0" 
$ns at 259.99289307933174 "$node_(231) setdest 35245 6106 13.0" 
$ns at 372.0624418482972 "$node_(231) setdest 78908 30172 9.0" 
$ns at 444.34715386253856 "$node_(231) setdest 73941 10927 20.0" 
$ns at 628.7352321005326 "$node_(231) setdest 12119 38179 1.0" 
$ns at 660.8464122597651 "$node_(231) setdest 92491 4634 14.0" 
$ns at 766.1213627055723 "$node_(231) setdest 26432 14215 9.0" 
$ns at 840.9371904100623 "$node_(231) setdest 52774 13900 2.0" 
$ns at 873.7646005308006 "$node_(231) setdest 38284 170 2.0" 
$ns at 212.644093390864 "$node_(232) setdest 18993 33367 8.0" 
$ns at 263.460808708365 "$node_(232) setdest 101930 41613 13.0" 
$ns at 309.5371509947996 "$node_(232) setdest 44085 5963 2.0" 
$ns at 347.07264529007415 "$node_(232) setdest 81614 30208 6.0" 
$ns at 415.6493821650309 "$node_(232) setdest 105818 14678 8.0" 
$ns at 481.65633062419954 "$node_(232) setdest 56724 36488 10.0" 
$ns at 593.3075808416464 "$node_(232) setdest 105338 17680 14.0" 
$ns at 654.7527482893755 "$node_(232) setdest 85069 13994 6.0" 
$ns at 696.2956681018265 "$node_(232) setdest 44267 30082 1.0" 
$ns at 734.6714591062618 "$node_(232) setdest 19088 6069 6.0" 
$ns at 804.8636327469333 "$node_(232) setdest 48825 40947 6.0" 
$ns at 855.484367150725 "$node_(232) setdest 72934 32837 14.0" 
$ns at 243.78062825229233 "$node_(233) setdest 72721 34428 9.0" 
$ns at 342.38714517660014 "$node_(233) setdest 87124 896 20.0" 
$ns at 569.0927243402632 "$node_(233) setdest 46584 26795 17.0" 
$ns at 636.1061405208843 "$node_(233) setdest 75980 23994 18.0" 
$ns at 804.3736515279131 "$node_(233) setdest 85451 970 7.0" 
$ns at 861.0314462393321 "$node_(233) setdest 108532 25060 2.0" 
$ns at 272.536608579089 "$node_(234) setdest 48035 24019 9.0" 
$ns at 329.49166964618775 "$node_(234) setdest 27474 28214 17.0" 
$ns at 442.42748448954836 "$node_(234) setdest 55041 7557 19.0" 
$ns at 619.4803740403439 "$node_(234) setdest 51885 23723 20.0" 
$ns at 686.7201655570226 "$node_(234) setdest 67159 17624 6.0" 
$ns at 769.2829543915559 "$node_(234) setdest 78942 33294 3.0" 
$ns at 821.7576377311951 "$node_(234) setdest 95373 7244 18.0" 
$ns at 893.4896463012296 "$node_(234) setdest 107035 24694 5.0" 
$ns at 222.92028903883119 "$node_(235) setdest 8786 41541 8.0" 
$ns at 314.63994006130133 "$node_(235) setdest 129711 3076 4.0" 
$ns at 373.76622904970355 "$node_(235) setdest 35185 25715 16.0" 
$ns at 493.8705666663826 "$node_(235) setdest 29698 28900 9.0" 
$ns at 550.3896568907433 "$node_(235) setdest 52878 43976 5.0" 
$ns at 613.8146188909116 "$node_(235) setdest 42828 21664 17.0" 
$ns at 685.6338213743311 "$node_(235) setdest 72330 7437 1.0" 
$ns at 723.2980259598759 "$node_(235) setdest 71261 33613 16.0" 
$ns at 846.9074719965522 "$node_(235) setdest 5770 11122 19.0" 
$ns at 269.86808245403057 "$node_(236) setdest 20017 25468 15.0" 
$ns at 341.5762433735865 "$node_(236) setdest 22556 19368 10.0" 
$ns at 413.6356457770567 "$node_(236) setdest 44237 1075 3.0" 
$ns at 458.6823792827371 "$node_(236) setdest 57564 10234 11.0" 
$ns at 539.7147203085764 "$node_(236) setdest 9659 838 17.0" 
$ns at 606.0645871911809 "$node_(236) setdest 69201 35956 1.0" 
$ns at 640.0954894859417 "$node_(236) setdest 38106 36562 16.0" 
$ns at 684.3855819405874 "$node_(236) setdest 127724 27449 10.0" 
$ns at 770.8163157491542 "$node_(236) setdest 8831 37712 15.0" 
$ns at 270.16831685422227 "$node_(237) setdest 22219 4941 9.0" 
$ns at 358.1061088953636 "$node_(237) setdest 131320 24666 4.0" 
$ns at 418.1829235234085 "$node_(237) setdest 113163 22746 7.0" 
$ns at 495.374846347797 "$node_(237) setdest 115569 2517 11.0" 
$ns at 582.1845290314842 "$node_(237) setdest 114217 15911 11.0" 
$ns at 663.9645712623178 "$node_(237) setdest 4161 40235 15.0" 
$ns at 756.5539133528773 "$node_(237) setdest 6312 6764 10.0" 
$ns at 800.7966742728396 "$node_(237) setdest 49520 39301 11.0" 
$ns at 843.5065984182626 "$node_(237) setdest 68192 19490 8.0" 
$ns at 241.6078892889622 "$node_(238) setdest 113309 38900 12.0" 
$ns at 282.3519282878062 "$node_(238) setdest 45978 29862 12.0" 
$ns at 382.62052294079496 "$node_(238) setdest 72366 20208 19.0" 
$ns at 547.4290757103671 "$node_(238) setdest 106042 42673 11.0" 
$ns at 644.3311151357531 "$node_(238) setdest 102694 7585 6.0" 
$ns at 724.2805069955715 "$node_(238) setdest 45815 24688 7.0" 
$ns at 766.3106905159616 "$node_(238) setdest 83179 13358 5.0" 
$ns at 817.3476357655122 "$node_(238) setdest 27638 32975 20.0" 
$ns at 881.8538290649337 "$node_(238) setdest 27480 29393 14.0" 
$ns at 246.04426753735157 "$node_(239) setdest 103752 21218 14.0" 
$ns at 394.88869804236845 "$node_(239) setdest 55509 12148 6.0" 
$ns at 443.10989427068404 "$node_(239) setdest 93852 36179 1.0" 
$ns at 481.6376130152222 "$node_(239) setdest 120640 21237 5.0" 
$ns at 518.6187475263253 "$node_(239) setdest 59471 41879 4.0" 
$ns at 568.2401702590955 "$node_(239) setdest 27616 38595 15.0" 
$ns at 636.7083354996321 "$node_(239) setdest 55851 3235 10.0" 
$ns at 689.6968585679908 "$node_(239) setdest 90453 35164 15.0" 
$ns at 852.900661975252 "$node_(239) setdest 110917 10102 3.0" 
$ns at 889.209878997872 "$node_(239) setdest 88542 21276 13.0" 
$ns at 208.5966666224501 "$node_(240) setdest 104601 5350 16.0" 
$ns at 323.76567224816085 "$node_(240) setdest 71786 9004 19.0" 
$ns at 398.82736984080356 "$node_(240) setdest 14524 36724 16.0" 
$ns at 574.6768908076383 "$node_(240) setdest 90599 9250 16.0" 
$ns at 704.6112390325961 "$node_(240) setdest 81825 23663 1.0" 
$ns at 742.1172206383288 "$node_(240) setdest 88303 41795 16.0" 
$ns at 813.0830717905542 "$node_(240) setdest 53538 1634 17.0" 
$ns at 891.5486772998366 "$node_(240) setdest 116815 36233 1.0" 
$ns at 294.5802170781129 "$node_(241) setdest 92224 30482 14.0" 
$ns at 415.2469153054228 "$node_(241) setdest 64063 8447 13.0" 
$ns at 534.6204343408725 "$node_(241) setdest 41214 3569 9.0" 
$ns at 637.8097376113429 "$node_(241) setdest 79887 29277 4.0" 
$ns at 707.3639395242844 "$node_(241) setdest 91132 8419 10.0" 
$ns at 740.5341606481709 "$node_(241) setdest 125244 32296 1.0" 
$ns at 780.4763156778141 "$node_(241) setdest 75418 44420 12.0" 
$ns at 201.3524189144498 "$node_(242) setdest 127822 4508 1.0" 
$ns at 235.5456547292599 "$node_(242) setdest 74646 32690 8.0" 
$ns at 304.41320587641735 "$node_(242) setdest 93201 32878 3.0" 
$ns at 359.1557596183897 "$node_(242) setdest 103225 5164 6.0" 
$ns at 414.2695461295719 "$node_(242) setdest 99676 8157 11.0" 
$ns at 447.712757800324 "$node_(242) setdest 103871 21539 19.0" 
$ns at 658.793401487748 "$node_(242) setdest 54084 7011 17.0" 
$ns at 797.519848673578 "$node_(242) setdest 133539 20320 6.0" 
$ns at 847.3207018069954 "$node_(242) setdest 9325 10983 12.0" 
$ns at 255.38462919637584 "$node_(243) setdest 104660 20528 7.0" 
$ns at 289.35815365797043 "$node_(243) setdest 65976 2022 14.0" 
$ns at 452.99995170414934 "$node_(243) setdest 12347 305 16.0" 
$ns at 602.0368641708505 "$node_(243) setdest 67649 31560 9.0" 
$ns at 636.7604454172508 "$node_(243) setdest 42189 16336 11.0" 
$ns at 696.0234836015221 "$node_(243) setdest 131965 14413 19.0" 
$ns at 764.3450236319684 "$node_(243) setdest 87713 31706 6.0" 
$ns at 800.6481535748691 "$node_(243) setdest 899 27329 8.0" 
$ns at 897.2576384971179 "$node_(243) setdest 56045 35395 18.0" 
$ns at 248.2743845701034 "$node_(244) setdest 24915 27878 1.0" 
$ns at 286.55105106651735 "$node_(244) setdest 130359 38523 15.0" 
$ns at 378.01322655929573 "$node_(244) setdest 108854 24096 5.0" 
$ns at 443.53662537011564 "$node_(244) setdest 105463 17222 5.0" 
$ns at 487.29185412870004 "$node_(244) setdest 126409 42169 12.0" 
$ns at 519.0242897085474 "$node_(244) setdest 49747 133 8.0" 
$ns at 610.2365735774472 "$node_(244) setdest 84605 13028 15.0" 
$ns at 742.6186152373732 "$node_(244) setdest 29246 13184 8.0" 
$ns at 820.8861958472955 "$node_(244) setdest 60166 1282 18.0" 
$ns at 296.35337391862623 "$node_(245) setdest 95274 35276 1.0" 
$ns at 334.37341530569677 "$node_(245) setdest 71147 21561 10.0" 
$ns at 389.42984826194134 "$node_(245) setdest 14643 44566 1.0" 
$ns at 423.28659233157003 "$node_(245) setdest 70128 28763 1.0" 
$ns at 461.1961312212446 "$node_(245) setdest 120092 11672 13.0" 
$ns at 578.0087578269148 "$node_(245) setdest 116746 23835 1.0" 
$ns at 613.9935505361279 "$node_(245) setdest 44022 19247 15.0" 
$ns at 740.3943515077857 "$node_(245) setdest 44690 35965 3.0" 
$ns at 798.2752306377212 "$node_(245) setdest 99235 4168 5.0" 
$ns at 868.7766010272576 "$node_(245) setdest 31522 10036 7.0" 
$ns at 243.2957457412179 "$node_(246) setdest 8415 19380 5.0" 
$ns at 280.145726353475 "$node_(246) setdest 9126 20100 2.0" 
$ns at 319.0652184626749 "$node_(246) setdest 80027 37461 8.0" 
$ns at 415.7263700905197 "$node_(246) setdest 68335 35786 6.0" 
$ns at 474.32152255429236 "$node_(246) setdest 71698 6119 12.0" 
$ns at 620.0005582623415 "$node_(246) setdest 40565 8808 18.0" 
$ns at 760.6360236546054 "$node_(246) setdest 18249 555 14.0" 
$ns at 845.0615659741452 "$node_(246) setdest 2313 7581 15.0" 
$ns at 258.6134467755152 "$node_(247) setdest 89097 8280 10.0" 
$ns at 320.9389291288271 "$node_(247) setdest 104432 23687 6.0" 
$ns at 367.56437530288713 "$node_(247) setdest 125153 34435 15.0" 
$ns at 409.0431274596249 "$node_(247) setdest 99988 36594 2.0" 
$ns at 451.43591254649397 "$node_(247) setdest 65365 17687 1.0" 
$ns at 483.73229694606914 "$node_(247) setdest 124562 16101 5.0" 
$ns at 533.1878905232596 "$node_(247) setdest 10814 32506 8.0" 
$ns at 631.6280478583271 "$node_(247) setdest 115197 39480 14.0" 
$ns at 673.8948941099733 "$node_(247) setdest 91759 23077 2.0" 
$ns at 721.4723345413336 "$node_(247) setdest 129373 42358 12.0" 
$ns at 837.2625309422423 "$node_(247) setdest 27205 39095 5.0" 
$ns at 899.8539926091703 "$node_(247) setdest 28406 1118 5.0" 
$ns at 279.7841113694561 "$node_(248) setdest 20289 23412 2.0" 
$ns at 322.71821893329394 "$node_(248) setdest 127883 20726 3.0" 
$ns at 368.3118137585126 "$node_(248) setdest 76018 4438 9.0" 
$ns at 482.6397599146345 "$node_(248) setdest 120863 8648 5.0" 
$ns at 535.0366961734752 "$node_(248) setdest 121522 6375 13.0" 
$ns at 633.1500013799769 "$node_(248) setdest 24542 22476 16.0" 
$ns at 696.2165821456098 "$node_(248) setdest 118746 14136 13.0" 
$ns at 780.0347743363058 "$node_(248) setdest 100717 31338 20.0" 
$ns at 817.223110429827 "$node_(248) setdest 83951 29980 5.0" 
$ns at 868.1954082704083 "$node_(248) setdest 31597 37044 14.0" 
$ns at 225.4692136248853 "$node_(249) setdest 49153 28070 14.0" 
$ns at 264.6506657754045 "$node_(249) setdest 93675 27749 11.0" 
$ns at 366.5599491106939 "$node_(249) setdest 56221 4470 1.0" 
$ns at 402.03141322819187 "$node_(249) setdest 89943 13462 8.0" 
$ns at 496.3815400797068 "$node_(249) setdest 59836 19237 18.0" 
$ns at 666.9716879669755 "$node_(249) setdest 34083 8424 13.0" 
$ns at 767.5097662300801 "$node_(249) setdest 100100 2145 1.0" 
$ns at 798.1105841729844 "$node_(249) setdest 93459 6173 14.0" 
$ns at 232.69784685329338 "$node_(250) setdest 64977 7279 7.0" 
$ns at 269.6004442857801 "$node_(250) setdest 77848 5644 9.0" 
$ns at 324.6981407787646 "$node_(250) setdest 124563 30154 1.0" 
$ns at 360.2684847011614 "$node_(250) setdest 21000 11731 20.0" 
$ns at 519.088712229787 "$node_(250) setdest 131794 36508 16.0" 
$ns at 619.7369152366499 "$node_(250) setdest 100429 5663 1.0" 
$ns at 650.3205040793965 "$node_(250) setdest 81363 37754 15.0" 
$ns at 767.8818943040004 "$node_(250) setdest 114551 29116 18.0" 
$ns at 823.3063748892524 "$node_(250) setdest 134159 33461 3.0" 
$ns at 861.6467284436139 "$node_(250) setdest 13933 24113 9.0" 
$ns at 228.8545959784601 "$node_(251) setdest 96060 14059 19.0" 
$ns at 382.0690189329854 "$node_(251) setdest 121175 31996 2.0" 
$ns at 420.68920164801193 "$node_(251) setdest 105967 28250 2.0" 
$ns at 455.70508406623196 "$node_(251) setdest 42332 35770 18.0" 
$ns at 597.253449545099 "$node_(251) setdest 99252 39595 15.0" 
$ns at 659.1568389463116 "$node_(251) setdest 124357 43217 17.0" 
$ns at 774.9872170694106 "$node_(251) setdest 48367 36596 3.0" 
$ns at 819.2195455155871 "$node_(251) setdest 108043 37612 10.0" 
$ns at 850.3547422541079 "$node_(251) setdest 38663 10363 1.0" 
$ns at 884.2516839466 "$node_(251) setdest 98234 41489 4.0" 
$ns at 274.5761304024076 "$node_(252) setdest 93053 19552 12.0" 
$ns at 331.3381282823048 "$node_(252) setdest 101400 26890 3.0" 
$ns at 369.3332957419588 "$node_(252) setdest 84842 7111 6.0" 
$ns at 431.35075541462686 "$node_(252) setdest 106859 1866 7.0" 
$ns at 493.10705559444193 "$node_(252) setdest 116123 7557 12.0" 
$ns at 600.1995076498979 "$node_(252) setdest 115210 9561 3.0" 
$ns at 658.442215351871 "$node_(252) setdest 52366 43799 7.0" 
$ns at 746.6031677789456 "$node_(252) setdest 78745 30996 4.0" 
$ns at 807.0055070221383 "$node_(252) setdest 19799 7232 9.0" 
$ns at 884.5810645674145 "$node_(252) setdest 67155 23539 16.0" 
$ns at 263.74841951414356 "$node_(253) setdest 32943 309 3.0" 
$ns at 297.3448299161441 "$node_(253) setdest 92173 14883 7.0" 
$ns at 373.30909982994666 "$node_(253) setdest 107297 32248 16.0" 
$ns at 422.392995018887 "$node_(253) setdest 23650 12449 11.0" 
$ns at 476.74841072179663 "$node_(253) setdest 13563 16367 3.0" 
$ns at 533.9626655108102 "$node_(253) setdest 79024 13470 13.0" 
$ns at 669.1398428676573 "$node_(253) setdest 124484 3557 17.0" 
$ns at 854.2355344505838 "$node_(253) setdest 52315 40305 4.0" 
$ns at 224.851654498162 "$node_(254) setdest 108753 41103 1.0" 
$ns at 260.0372317336706 "$node_(254) setdest 32534 23819 19.0" 
$ns at 374.4900660303929 "$node_(254) setdest 89198 32297 12.0" 
$ns at 448.88124355024195 "$node_(254) setdest 68128 13852 2.0" 
$ns at 479.75718818768115 "$node_(254) setdest 6768 22556 14.0" 
$ns at 530.7772026450384 "$node_(254) setdest 60559 39464 5.0" 
$ns at 578.6607831594354 "$node_(254) setdest 98776 26119 1.0" 
$ns at 609.6070878852117 "$node_(254) setdest 103683 20646 15.0" 
$ns at 774.1288962202304 "$node_(254) setdest 86448 13646 17.0" 
$ns at 892.0735802731514 "$node_(254) setdest 15784 36220 1.0" 
$ns at 234.60370766456293 "$node_(255) setdest 81508 21051 1.0" 
$ns at 268.788003929854 "$node_(255) setdest 105369 1447 19.0" 
$ns at 479.9119282245398 "$node_(255) setdest 92663 7770 7.0" 
$ns at 523.9100301780593 "$node_(255) setdest 59029 8303 8.0" 
$ns at 571.794453044129 "$node_(255) setdest 33117 42521 18.0" 
$ns at 655.5075562972331 "$node_(255) setdest 9921 20357 5.0" 
$ns at 696.8948878830015 "$node_(255) setdest 15563 43614 10.0" 
$ns at 741.6417829135636 "$node_(255) setdest 124898 14421 5.0" 
$ns at 779.2568067400927 "$node_(255) setdest 14060 4667 18.0" 
$ns at 208.05919353060204 "$node_(256) setdest 115348 31008 17.0" 
$ns at 394.9197221880966 "$node_(256) setdest 11861 4399 19.0" 
$ns at 557.494288830454 "$node_(256) setdest 25221 30624 4.0" 
$ns at 605.5470133757439 "$node_(256) setdest 103104 20972 13.0" 
$ns at 704.4901542851095 "$node_(256) setdest 27081 17726 1.0" 
$ns at 743.7602332356425 "$node_(256) setdest 84962 4002 9.0" 
$ns at 845.3063286267894 "$node_(256) setdest 61570 8875 7.0" 
$ns at 281.3669061008581 "$node_(257) setdest 61505 25638 12.0" 
$ns at 348.8438590830997 "$node_(257) setdest 26222 23503 1.0" 
$ns at 379.1129528647799 "$node_(257) setdest 96244 37142 2.0" 
$ns at 409.69966893320696 "$node_(257) setdest 90383 23071 14.0" 
$ns at 575.6290927905568 "$node_(257) setdest 68662 33547 19.0" 
$ns at 710.4038015318238 "$node_(257) setdest 40077 15063 2.0" 
$ns at 753.6669012598443 "$node_(257) setdest 74493 35505 2.0" 
$ns at 786.1285287054855 "$node_(257) setdest 100080 6651 16.0" 
$ns at 223.32314946737407 "$node_(258) setdest 90096 40290 16.0" 
$ns at 305.5168519074169 "$node_(258) setdest 121014 8006 16.0" 
$ns at 441.6276921082382 "$node_(258) setdest 53509 9950 12.0" 
$ns at 484.9925677974974 "$node_(258) setdest 33711 20526 13.0" 
$ns at 557.9935374244061 "$node_(258) setdest 81746 44173 13.0" 
$ns at 643.161252497347 "$node_(258) setdest 124172 15486 1.0" 
$ns at 683.0791371634903 "$node_(258) setdest 12397 34747 15.0" 
$ns at 754.4704448990939 "$node_(258) setdest 2207 38381 9.0" 
$ns at 845.2229015152758 "$node_(258) setdest 19367 4265 13.0" 
$ns at 885.2624193587006 "$node_(258) setdest 45080 42662 17.0" 
$ns at 267.24219238288504 "$node_(259) setdest 127932 36330 2.0" 
$ns at 314.80878378528735 "$node_(259) setdest 108301 2679 5.0" 
$ns at 372.5495984518368 "$node_(259) setdest 11534 17414 17.0" 
$ns at 517.5267330769701 "$node_(259) setdest 44049 38924 7.0" 
$ns at 610.8618857013437 "$node_(259) setdest 241 43130 4.0" 
$ns at 654.6640736447706 "$node_(259) setdest 14586 25317 1.0" 
$ns at 692.6267509316677 "$node_(259) setdest 99674 3374 11.0" 
$ns at 786.8013411253794 "$node_(259) setdest 31982 36906 12.0" 
$ns at 882.1502991469282 "$node_(259) setdest 28413 4698 10.0" 
$ns at 286.71425507139367 "$node_(260) setdest 42989 11968 8.0" 
$ns at 374.23920789421464 "$node_(260) setdest 91409 10914 6.0" 
$ns at 405.6498812590983 "$node_(260) setdest 70971 14712 9.0" 
$ns at 500.00203424857057 "$node_(260) setdest 2978 173 3.0" 
$ns at 556.410174690185 "$node_(260) setdest 41723 17794 5.0" 
$ns at 629.7856944034894 "$node_(260) setdest 121173 23871 9.0" 
$ns at 675.4496374965083 "$node_(260) setdest 91738 22622 12.0" 
$ns at 795.4293211938425 "$node_(260) setdest 130732 11304 4.0" 
$ns at 828.2268705859897 "$node_(260) setdest 74594 17079 16.0" 
$ns at 238.94804918101644 "$node_(261) setdest 53360 30437 17.0" 
$ns at 353.45782249247566 "$node_(261) setdest 39213 41916 8.0" 
$ns at 452.9826214165298 "$node_(261) setdest 63226 41755 1.0" 
$ns at 486.7993720363083 "$node_(261) setdest 1487 12940 7.0" 
$ns at 530.5465806778195 "$node_(261) setdest 54359 35034 14.0" 
$ns at 602.7367491452798 "$node_(261) setdest 124501 38809 12.0" 
$ns at 717.1838037369331 "$node_(261) setdest 124601 38071 11.0" 
$ns at 833.8357046454364 "$node_(261) setdest 24566 33266 8.0" 
$ns at 864.0759532628053 "$node_(261) setdest 125621 11809 20.0" 
$ns at 240.06458991279194 "$node_(262) setdest 55147 8418 5.0" 
$ns at 296.9882585695546 "$node_(262) setdest 7150 25492 9.0" 
$ns at 343.2284402020445 "$node_(262) setdest 80958 83 1.0" 
$ns at 374.17738756832875 "$node_(262) setdest 62518 38115 5.0" 
$ns at 411.00272415365885 "$node_(262) setdest 12092 16929 17.0" 
$ns at 559.9855373242821 "$node_(262) setdest 84203 33841 9.0" 
$ns at 595.81655179396 "$node_(262) setdest 101657 39090 17.0" 
$ns at 795.2669276609872 "$node_(262) setdest 91017 15138 19.0" 
$ns at 284.74140235279094 "$node_(263) setdest 42186 41236 5.0" 
$ns at 346.52446890444855 "$node_(263) setdest 56812 29779 8.0" 
$ns at 445.81149985983376 "$node_(263) setdest 38780 29914 20.0" 
$ns at 583.5993640645218 "$node_(263) setdest 71876 38841 12.0" 
$ns at 639.6487437148722 "$node_(263) setdest 27211 22560 3.0" 
$ns at 684.6024238714609 "$node_(263) setdest 127389 3425 20.0" 
$ns at 840.8910344175315 "$node_(263) setdest 113401 7672 1.0" 
$ns at 872.3337229399904 "$node_(263) setdest 102954 21082 15.0" 
$ns at 217.46144173975495 "$node_(264) setdest 107954 9566 11.0" 
$ns at 276.02359567498434 "$node_(264) setdest 108235 14427 15.0" 
$ns at 415.98707808922006 "$node_(264) setdest 64519 36124 19.0" 
$ns at 474.8646798190999 "$node_(264) setdest 113691 30345 1.0" 
$ns at 509.1181271921105 "$node_(264) setdest 18285 24760 1.0" 
$ns at 548.39345779975 "$node_(264) setdest 29684 23509 5.0" 
$ns at 587.0800106771326 "$node_(264) setdest 78572 43582 10.0" 
$ns at 674.0541615312471 "$node_(264) setdest 69920 18243 16.0" 
$ns at 767.1817615054235 "$node_(264) setdest 77419 10369 5.0" 
$ns at 844.7959467276561 "$node_(264) setdest 67312 14998 17.0" 
$ns at 222.01102598836448 "$node_(265) setdest 22177 37433 5.0" 
$ns at 274.82598186084925 "$node_(265) setdest 92194 3706 17.0" 
$ns at 443.5131430141633 "$node_(265) setdest 60388 22538 7.0" 
$ns at 482.02384003751746 "$node_(265) setdest 98981 30749 6.0" 
$ns at 532.2784704719337 "$node_(265) setdest 111009 20529 16.0" 
$ns at 699.5886871482815 "$node_(265) setdest 97548 39257 13.0" 
$ns at 771.289798405506 "$node_(265) setdest 66520 11026 9.0" 
$ns at 886.5819560702046 "$node_(265) setdest 88707 5637 15.0" 
$ns at 208.95369096112853 "$node_(266) setdest 45142 28667 17.0" 
$ns at 379.3655352070923 "$node_(266) setdest 78857 18066 7.0" 
$ns at 469.9412375581709 "$node_(266) setdest 74031 190 17.0" 
$ns at 542.3934512923352 "$node_(266) setdest 96249 41973 17.0" 
$ns at 677.5398410190592 "$node_(266) setdest 128158 38542 17.0" 
$ns at 717.9499067753596 "$node_(266) setdest 49319 43745 16.0" 
$ns at 758.6186127277348 "$node_(266) setdest 6796 29657 19.0" 
$ns at 849.8986164160863 "$node_(266) setdest 6772 40536 2.0" 
$ns at 889.0252420714281 "$node_(266) setdest 128245 26005 12.0" 
$ns at 280.17171810105845 "$node_(267) setdest 24468 1682 16.0" 
$ns at 335.81338646267073 "$node_(267) setdest 123079 10923 19.0" 
$ns at 461.04590588686085 "$node_(267) setdest 91888 11582 12.0" 
$ns at 601.5671065016243 "$node_(267) setdest 101580 31803 8.0" 
$ns at 653.6175867486361 "$node_(267) setdest 89945 43080 2.0" 
$ns at 700.1105589671599 "$node_(267) setdest 87746 28405 15.0" 
$ns at 743.3304593423106 "$node_(267) setdest 48433 19964 11.0" 
$ns at 836.8322149002205 "$node_(267) setdest 124559 13758 11.0" 
$ns at 896.2101147096861 "$node_(267) setdest 57829 39387 10.0" 
$ns at 228.8503787719377 "$node_(268) setdest 90781 23226 7.0" 
$ns at 266.8580183727338 "$node_(268) setdest 75972 11538 8.0" 
$ns at 328.6241106056171 "$node_(268) setdest 127256 5057 17.0" 
$ns at 520.1735384221354 "$node_(268) setdest 124095 27766 14.0" 
$ns at 583.1799728768963 "$node_(268) setdest 49288 33255 1.0" 
$ns at 619.0807192395331 "$node_(268) setdest 29081 1311 1.0" 
$ns at 651.8660549373228 "$node_(268) setdest 121783 11243 20.0" 
$ns at 750.7175679192221 "$node_(268) setdest 25150 12665 7.0" 
$ns at 810.9862207564977 "$node_(268) setdest 80895 43658 13.0" 
$ns at 244.06243507974918 "$node_(269) setdest 44208 21727 10.0" 
$ns at 302.6800719877126 "$node_(269) setdest 47881 15737 13.0" 
$ns at 445.5696768536713 "$node_(269) setdest 21395 20809 1.0" 
$ns at 484.63679372055907 "$node_(269) setdest 104013 9401 5.0" 
$ns at 544.8573562326786 "$node_(269) setdest 59524 6155 14.0" 
$ns at 625.2749302120172 "$node_(269) setdest 117991 28679 5.0" 
$ns at 686.8318106007389 "$node_(269) setdest 98887 27383 10.0" 
$ns at 811.9598980120396 "$node_(269) setdest 38235 8110 6.0" 
$ns at 843.5517715393577 "$node_(269) setdest 12934 31307 18.0" 
$ns at 265.97758214245493 "$node_(270) setdest 81759 6032 5.0" 
$ns at 334.58806747823223 "$node_(270) setdest 128474 42726 19.0" 
$ns at 528.3741959586845 "$node_(270) setdest 3705 37406 11.0" 
$ns at 613.8841146596252 "$node_(270) setdest 132736 39197 20.0" 
$ns at 739.387962538219 "$node_(270) setdest 12164 6626 18.0" 
$ns at 818.4794361662898 "$node_(270) setdest 119991 40340 18.0" 
$ns at 849.5345032346053 "$node_(270) setdest 93022 6088 4.0" 
$ns at 889.6499232301054 "$node_(270) setdest 82475 32071 19.0" 
$ns at 269.03765323091875 "$node_(271) setdest 97206 26 5.0" 
$ns at 347.41904237993947 "$node_(271) setdest 63138 1116 19.0" 
$ns at 526.5671895285532 "$node_(271) setdest 122470 30644 9.0" 
$ns at 583.7631008584987 "$node_(271) setdest 81264 3435 16.0" 
$ns at 619.4386126052867 "$node_(271) setdest 96054 3684 12.0" 
$ns at 721.563463077331 "$node_(271) setdest 127241 8789 19.0" 
$ns at 780.4462704930238 "$node_(271) setdest 43231 21624 10.0" 
$ns at 882.9054821084791 "$node_(271) setdest 61176 37409 5.0" 
$ns at 216.0215499963346 "$node_(272) setdest 125083 39855 2.0" 
$ns at 247.02546195411418 "$node_(272) setdest 113040 8325 15.0" 
$ns at 321.29252308766087 "$node_(272) setdest 33705 13500 7.0" 
$ns at 407.4244971168861 "$node_(272) setdest 2405 24336 4.0" 
$ns at 454.6286589824432 "$node_(272) setdest 96916 12281 1.0" 
$ns at 486.30940317815924 "$node_(272) setdest 84363 21104 5.0" 
$ns at 526.9172233548335 "$node_(272) setdest 10249 24228 3.0" 
$ns at 575.3086372005365 "$node_(272) setdest 101680 19389 6.0" 
$ns at 624.2281188403819 "$node_(272) setdest 5539 14388 2.0" 
$ns at 665.6260928681846 "$node_(272) setdest 11790 20908 18.0" 
$ns at 787.1709205798613 "$node_(272) setdest 3308 17359 11.0" 
$ns at 832.1113530076311 "$node_(272) setdest 112800 5816 19.0" 
$ns at 883.902388258264 "$node_(272) setdest 133415 11986 13.0" 
$ns at 218.91050690724916 "$node_(273) setdest 12658 31032 13.0" 
$ns at 261.2766783608222 "$node_(273) setdest 38838 25524 8.0" 
$ns at 296.9445659555011 "$node_(273) setdest 84134 38875 4.0" 
$ns at 336.12445758356426 "$node_(273) setdest 73953 14147 1.0" 
$ns at 366.8781603741386 "$node_(273) setdest 90170 43599 11.0" 
$ns at 437.77667423094294 "$node_(273) setdest 72707 42883 18.0" 
$ns at 534.6278564890437 "$node_(273) setdest 17428 38607 6.0" 
$ns at 610.361754854433 "$node_(273) setdest 64314 27789 1.0" 
$ns at 640.4909372903929 "$node_(273) setdest 17262 15951 19.0" 
$ns at 691.148454679214 "$node_(273) setdest 118308 36252 9.0" 
$ns at 778.4797091532813 "$node_(273) setdest 57247 4276 18.0" 
$ns at 271.20117455918955 "$node_(274) setdest 56278 21504 15.0" 
$ns at 312.86879398928596 "$node_(274) setdest 127744 36386 19.0" 
$ns at 386.8297960928976 "$node_(274) setdest 54608 14159 8.0" 
$ns at 459.01406058122666 "$node_(274) setdest 125383 43208 15.0" 
$ns at 580.1054249875751 "$node_(274) setdest 18837 13705 19.0" 
$ns at 795.0016540718844 "$node_(274) setdest 86785 3803 18.0" 
$ns at 200.11398530026952 "$node_(275) setdest 11072 44576 4.0" 
$ns at 247.30807206436234 "$node_(275) setdest 89928 31281 10.0" 
$ns at 299.94379846515443 "$node_(275) setdest 81676 4242 19.0" 
$ns at 401.6465748151713 "$node_(275) setdest 54721 38943 7.0" 
$ns at 486.3468369392043 "$node_(275) setdest 51945 6982 1.0" 
$ns at 522.6444056839898 "$node_(275) setdest 28437 3386 6.0" 
$ns at 563.9524909574095 "$node_(275) setdest 20934 35187 17.0" 
$ns at 685.8217974451933 "$node_(275) setdest 16671 41913 2.0" 
$ns at 718.2400936333908 "$node_(275) setdest 54971 41904 4.0" 
$ns at 759.6379852250998 "$node_(275) setdest 1232 1854 14.0" 
$ns at 817.9997932952818 "$node_(275) setdest 10098 231 1.0" 
$ns at 848.957380671456 "$node_(275) setdest 99982 44153 17.0" 
$ns at 293.2342786120541 "$node_(276) setdest 123250 32435 16.0" 
$ns at 462.1350421720822 "$node_(276) setdest 89090 25631 5.0" 
$ns at 514.9426120425255 "$node_(276) setdest 126051 30620 5.0" 
$ns at 547.3186355062688 "$node_(276) setdest 100072 2600 15.0" 
$ns at 583.8260641951138 "$node_(276) setdest 125145 39901 14.0" 
$ns at 673.6565232163683 "$node_(276) setdest 118142 12952 9.0" 
$ns at 777.4952860210019 "$node_(276) setdest 92933 41215 2.0" 
$ns at 826.4953616950218 "$node_(276) setdest 29863 33739 4.0" 
$ns at 869.4308687629341 "$node_(276) setdest 106883 32714 13.0" 
$ns at 206.2139695889881 "$node_(277) setdest 87568 14202 1.0" 
$ns at 240.33801278996827 "$node_(277) setdest 56213 30208 14.0" 
$ns at 344.6720689626738 "$node_(277) setdest 80635 39352 15.0" 
$ns at 507.5472225821564 "$node_(277) setdest 44982 2734 17.0" 
$ns at 675.7312087507271 "$node_(277) setdest 2839 11092 17.0" 
$ns at 725.7587290363624 "$node_(277) setdest 12628 10570 13.0" 
$ns at 814.7327490794644 "$node_(277) setdest 129375 17726 19.0" 
$ns at 897.1055039552134 "$node_(277) setdest 92742 16114 3.0" 
$ns at 205.75510687300653 "$node_(278) setdest 32401 40761 10.0" 
$ns at 318.8564633485634 "$node_(278) setdest 117868 11743 10.0" 
$ns at 355.9158519362203 "$node_(278) setdest 74756 37717 19.0" 
$ns at 408.8211424378163 "$node_(278) setdest 61216 18200 10.0" 
$ns at 450.80720837840994 "$node_(278) setdest 52652 10664 17.0" 
$ns at 579.2012740115172 "$node_(278) setdest 77586 36260 5.0" 
$ns at 611.0731691194234 "$node_(278) setdest 67610 28333 9.0" 
$ns at 660.9545369085924 "$node_(278) setdest 54390 42746 5.0" 
$ns at 716.4842087918162 "$node_(278) setdest 34442 9641 9.0" 
$ns at 767.7008837710421 "$node_(278) setdest 80852 23027 15.0" 
$ns at 892.202336206528 "$node_(278) setdest 111986 42290 4.0" 
$ns at 331.7240269307168 "$node_(279) setdest 100388 3956 4.0" 
$ns at 364.1284099851473 "$node_(279) setdest 102447 42625 9.0" 
$ns at 395.3775023593097 "$node_(279) setdest 2877 13253 6.0" 
$ns at 485.08653048126314 "$node_(279) setdest 1231 15809 20.0" 
$ns at 632.1375860915962 "$node_(279) setdest 102113 30194 18.0" 
$ns at 754.4604231054782 "$node_(279) setdest 8539 12204 3.0" 
$ns at 812.3358956199606 "$node_(279) setdest 32946 6529 9.0" 
$ns at 261.1772076225749 "$node_(280) setdest 12205 8625 17.0" 
$ns at 356.2467025790711 "$node_(280) setdest 79540 10408 20.0" 
$ns at 545.8355799730285 "$node_(280) setdest 61393 16544 1.0" 
$ns at 584.2971187437528 "$node_(280) setdest 132039 41495 1.0" 
$ns at 619.6353765156334 "$node_(280) setdest 94334 4782 12.0" 
$ns at 695.1083660935667 "$node_(280) setdest 112019 33520 4.0" 
$ns at 736.7479809370749 "$node_(280) setdest 43633 34492 17.0" 
$ns at 802.594373669574 "$node_(280) setdest 12760 34584 2.0" 
$ns at 834.7247976320979 "$node_(280) setdest 61998 7895 8.0" 
$ns at 225.61600339979532 "$node_(281) setdest 46248 15153 16.0" 
$ns at 369.0734057803553 "$node_(281) setdest 42105 10110 6.0" 
$ns at 401.5234515128637 "$node_(281) setdest 25447 7052 14.0" 
$ns at 515.2724458595144 "$node_(281) setdest 117862 26449 5.0" 
$ns at 589.0224570502961 "$node_(281) setdest 33211 10573 18.0" 
$ns at 636.6855066022761 "$node_(281) setdest 79893 17587 12.0" 
$ns at 700.5029451383981 "$node_(281) setdest 125915 31819 6.0" 
$ns at 741.5599864514573 "$node_(281) setdest 75595 35554 14.0" 
$ns at 781.1569307191298 "$node_(281) setdest 53432 42128 13.0" 
$ns at 873.3358659187359 "$node_(281) setdest 101279 14266 8.0" 
$ns at 216.01780836004872 "$node_(282) setdest 100738 20323 13.0" 
$ns at 265.3195897880613 "$node_(282) setdest 71212 7085 10.0" 
$ns at 367.9758383682589 "$node_(282) setdest 23809 37547 1.0" 
$ns at 403.4225286437321 "$node_(282) setdest 130246 9065 9.0" 
$ns at 443.062407121574 "$node_(282) setdest 120114 31938 13.0" 
$ns at 541.2762670969832 "$node_(282) setdest 15108 26699 4.0" 
$ns at 586.3339570088093 "$node_(282) setdest 155 14667 7.0" 
$ns at 618.2354041382486 "$node_(282) setdest 24606 17348 13.0" 
$ns at 715.2253665651319 "$node_(282) setdest 113072 40493 9.0" 
$ns at 832.0181818030889 "$node_(282) setdest 55949 39201 12.0" 
$ns at 237.45645787342409 "$node_(283) setdest 72522 39832 2.0" 
$ns at 269.7882983514796 "$node_(283) setdest 65795 32693 12.0" 
$ns at 416.3560416703545 "$node_(283) setdest 72876 15560 6.0" 
$ns at 479.0390516763496 "$node_(283) setdest 116243 23237 7.0" 
$ns at 529.3990745589499 "$node_(283) setdest 85413 28357 4.0" 
$ns at 570.7348452443957 "$node_(283) setdest 47827 19478 10.0" 
$ns at 655.6940696289261 "$node_(283) setdest 4555 43455 1.0" 
$ns at 691.7664367501843 "$node_(283) setdest 103417 9874 16.0" 
$ns at 791.4409330321878 "$node_(283) setdest 129969 35642 1.0" 
$ns at 826.2736647299644 "$node_(283) setdest 124606 9242 1.0" 
$ns at 859.7503965316371 "$node_(283) setdest 12590 16143 13.0" 
$ns at 337.4633489386856 "$node_(284) setdest 78871 10224 15.0" 
$ns at 463.86076408018505 "$node_(284) setdest 14944 26141 9.0" 
$ns at 504.2346627921008 "$node_(284) setdest 36864 4708 15.0" 
$ns at 564.3535745781513 "$node_(284) setdest 37327 26402 2.0" 
$ns at 608.3704193645651 "$node_(284) setdest 10534 35353 4.0" 
$ns at 639.9094398686728 "$node_(284) setdest 104645 37974 10.0" 
$ns at 705.6326054073531 "$node_(284) setdest 64366 17200 8.0" 
$ns at 789.7576977674264 "$node_(284) setdest 59405 6508 5.0" 
$ns at 821.6780113594388 "$node_(284) setdest 86250 26385 8.0" 
$ns at 887.8115326310963 "$node_(284) setdest 103845 14115 1.0" 
$ns at 249.93342443805636 "$node_(285) setdest 114427 36496 1.0" 
$ns at 281.4295541576448 "$node_(285) setdest 10504 35063 1.0" 
$ns at 311.94324126415836 "$node_(285) setdest 43006 21703 14.0" 
$ns at 376.1308762813625 "$node_(285) setdest 85449 26227 6.0" 
$ns at 408.2591764036292 "$node_(285) setdest 121407 32037 17.0" 
$ns at 585.7551990813538 "$node_(285) setdest 5767 27602 13.0" 
$ns at 694.6033489204734 "$node_(285) setdest 64237 44144 2.0" 
$ns at 728.7191555324833 "$node_(285) setdest 62477 1381 1.0" 
$ns at 764.813929415573 "$node_(285) setdest 93313 15262 1.0" 
$ns at 802.9657759710652 "$node_(285) setdest 55249 22191 12.0" 
$ns at 277.73730416804983 "$node_(286) setdest 94379 43243 11.0" 
$ns at 345.16073067624694 "$node_(286) setdest 623 29731 6.0" 
$ns at 384.23078074708394 "$node_(286) setdest 63839 8575 1.0" 
$ns at 416.6557706406632 "$node_(286) setdest 81752 27974 12.0" 
$ns at 536.7172466307194 "$node_(286) setdest 73938 44128 13.0" 
$ns at 592.232625631743 "$node_(286) setdest 25422 23468 5.0" 
$ns at 630.0584480149668 "$node_(286) setdest 10328 13023 1.0" 
$ns at 669.724705059917 "$node_(286) setdest 104740 27121 8.0" 
$ns at 727.3606096252512 "$node_(286) setdest 131656 22690 9.0" 
$ns at 826.3328030668447 "$node_(286) setdest 36291 40292 10.0" 
$ns at 231.64780126947414 "$node_(287) setdest 78239 24375 3.0" 
$ns at 268.2829820509919 "$node_(287) setdest 97701 12567 3.0" 
$ns at 314.0041286774031 "$node_(287) setdest 42956 41793 1.0" 
$ns at 351.1366198109086 "$node_(287) setdest 13358 18615 10.0" 
$ns at 436.22972692222186 "$node_(287) setdest 106849 16871 5.0" 
$ns at 501.27057079887857 "$node_(287) setdest 62840 41047 20.0" 
$ns at 676.5155982187225 "$node_(287) setdest 6967 31447 5.0" 
$ns at 720.0902347380634 "$node_(287) setdest 109624 24066 15.0" 
$ns at 848.1266137364912 "$node_(287) setdest 123674 43226 5.0" 
$ns at 242.1110712542594 "$node_(288) setdest 71082 33504 20.0" 
$ns at 420.55595399314694 "$node_(288) setdest 55166 17682 15.0" 
$ns at 583.7561276043127 "$node_(288) setdest 16080 3112 10.0" 
$ns at 680.0431834901191 "$node_(288) setdest 84810 10156 2.0" 
$ns at 718.1088864117852 "$node_(288) setdest 90288 21691 19.0" 
$ns at 869.5871812011322 "$node_(288) setdest 116933 36170 6.0" 
$ns at 236.77527660953214 "$node_(289) setdest 74422 37739 18.0" 
$ns at 270.87913046157337 "$node_(289) setdest 103154 15502 9.0" 
$ns at 344.84095999570604 "$node_(289) setdest 22779 6416 8.0" 
$ns at 447.86191800243625 "$node_(289) setdest 90449 39528 12.0" 
$ns at 499.18526832671915 "$node_(289) setdest 108057 44306 10.0" 
$ns at 533.8416441094075 "$node_(289) setdest 131054 42862 12.0" 
$ns at 662.4703213134476 "$node_(289) setdest 111766 28479 1.0" 
$ns at 698.2969740986528 "$node_(289) setdest 34285 5915 1.0" 
$ns at 736.5174512807816 "$node_(289) setdest 23333 33618 9.0" 
$ns at 816.4277846917252 "$node_(289) setdest 103020 16317 1.0" 
$ns at 855.0684876162778 "$node_(289) setdest 133144 29820 12.0" 
$ns at 206.16072657029957 "$node_(290) setdest 112210 22690 8.0" 
$ns at 296.7489930073256 "$node_(290) setdest 117477 31094 8.0" 
$ns at 374.35394243046267 "$node_(290) setdest 108504 14084 8.0" 
$ns at 421.6054533655753 "$node_(290) setdest 65358 31792 10.0" 
$ns at 488.9939269140185 "$node_(290) setdest 72931 6308 8.0" 
$ns at 568.6581442348183 "$node_(290) setdest 133048 41761 10.0" 
$ns at 643.1544813883656 "$node_(290) setdest 102724 20400 8.0" 
$ns at 723.6149150617769 "$node_(290) setdest 62194 1436 17.0" 
$ns at 762.8772601977425 "$node_(290) setdest 117285 34783 19.0" 
$ns at 245.16007363857568 "$node_(291) setdest 113989 27611 1.0" 
$ns at 281.3848836376725 "$node_(291) setdest 28700 43998 9.0" 
$ns at 398.7020753166674 "$node_(291) setdest 129351 15717 5.0" 
$ns at 430.22757560589866 "$node_(291) setdest 97588 4222 12.0" 
$ns at 496.1831458350983 "$node_(291) setdest 120577 43266 20.0" 
$ns at 664.5910571562974 "$node_(291) setdest 41040 6048 20.0" 
$ns at 881.806744685869 "$node_(291) setdest 39399 23855 20.0" 
$ns at 213.05450212752592 "$node_(292) setdest 112950 41336 8.0" 
$ns at 272.2880060775542 "$node_(292) setdest 44318 10320 1.0" 
$ns at 310.25407751896097 "$node_(292) setdest 119725 40354 19.0" 
$ns at 449.2065681555555 "$node_(292) setdest 77407 4607 15.0" 
$ns at 533.289207093008 "$node_(292) setdest 81821 28478 5.0" 
$ns at 566.5055630661224 "$node_(292) setdest 59257 5046 5.0" 
$ns at 638.8569066547717 "$node_(292) setdest 62312 11291 12.0" 
$ns at 744.908680175884 "$node_(292) setdest 132327 32488 11.0" 
$ns at 780.3969996696206 "$node_(292) setdest 41352 7766 10.0" 
$ns at 235.01878687903235 "$node_(293) setdest 130374 21563 6.0" 
$ns at 301.5315251250245 "$node_(293) setdest 104151 7768 16.0" 
$ns at 442.82167351063805 "$node_(293) setdest 58344 3411 18.0" 
$ns at 633.1963710713593 "$node_(293) setdest 44081 36692 10.0" 
$ns at 718.188230481353 "$node_(293) setdest 37717 11036 11.0" 
$ns at 839.2106548110047 "$node_(293) setdest 25619 1854 15.0" 
$ns at 203.51991504835502 "$node_(294) setdest 99504 9146 8.0" 
$ns at 267.46240653853386 "$node_(294) setdest 46518 7110 7.0" 
$ns at 316.5785817324773 "$node_(294) setdest 117846 24211 4.0" 
$ns at 372.2935980159646 "$node_(294) setdest 89719 44321 6.0" 
$ns at 460.8939354664294 "$node_(294) setdest 18867 14373 16.0" 
$ns at 576.4026874872347 "$node_(294) setdest 73048 33909 1.0" 
$ns at 610.0014801207509 "$node_(294) setdest 77317 20303 11.0" 
$ns at 702.2221568207178 "$node_(294) setdest 17606 44487 9.0" 
$ns at 751.9293666869743 "$node_(294) setdest 98337 7237 13.0" 
$ns at 795.9112045462293 "$node_(294) setdest 49875 40652 18.0" 
$ns at 883.1864797538967 "$node_(294) setdest 78182 16738 1.0" 
$ns at 239.24722672002068 "$node_(295) setdest 74938 16703 13.0" 
$ns at 352.7898299322937 "$node_(295) setdest 124459 30713 13.0" 
$ns at 436.65447925995903 "$node_(295) setdest 36513 15463 14.0" 
$ns at 571.8465906321494 "$node_(295) setdest 99871 37119 17.0" 
$ns at 747.2594902078176 "$node_(295) setdest 122061 19854 16.0" 
$ns at 210.6611441793869 "$node_(296) setdest 34073 929 17.0" 
$ns at 257.95705656719815 "$node_(296) setdest 73543 8415 6.0" 
$ns at 334.11777140509497 "$node_(296) setdest 109958 26341 6.0" 
$ns at 397.2424802921983 "$node_(296) setdest 80097 15232 9.0" 
$ns at 451.8039235652356 "$node_(296) setdest 115803 36395 13.0" 
$ns at 564.2233950495821 "$node_(296) setdest 131703 28726 14.0" 
$ns at 713.2976912017266 "$node_(296) setdest 95890 37811 14.0" 
$ns at 823.7986327563443 "$node_(296) setdest 60051 36854 14.0" 
$ns at 208.56313989464132 "$node_(297) setdest 62255 26739 9.0" 
$ns at 263.0019312416206 "$node_(297) setdest 17490 18101 7.0" 
$ns at 298.3661564574232 "$node_(297) setdest 19302 1381 5.0" 
$ns at 364.876965411363 "$node_(297) setdest 90835 7402 18.0" 
$ns at 510.15528406280043 "$node_(297) setdest 45809 16853 9.0" 
$ns at 585.3701823282368 "$node_(297) setdest 22158 34308 5.0" 
$ns at 646.8226193467233 "$node_(297) setdest 56585 12614 20.0" 
$ns at 851.2367805391207 "$node_(297) setdest 68023 37634 14.0" 
$ns at 315.09115303990427 "$node_(298) setdest 11057 20998 14.0" 
$ns at 380.90936566284466 "$node_(298) setdest 86915 28403 8.0" 
$ns at 444.32423060320883 "$node_(298) setdest 111737 3724 10.0" 
$ns at 549.5492430295321 "$node_(298) setdest 59155 32849 16.0" 
$ns at 685.3092240918359 "$node_(298) setdest 23533 40597 3.0" 
$ns at 731.5877909662588 "$node_(298) setdest 50866 40082 4.0" 
$ns at 765.1961192863024 "$node_(298) setdest 134087 5940 1.0" 
$ns at 797.0438956257059 "$node_(298) setdest 91263 6492 8.0" 
$ns at 837.8586972932885 "$node_(298) setdest 18521 34204 1.0" 
$ns at 870.1636622985352 "$node_(298) setdest 18688 21115 14.0" 
$ns at 242.68914702937968 "$node_(299) setdest 96941 41547 8.0" 
$ns at 290.85056786636494 "$node_(299) setdest 2677 29024 4.0" 
$ns at 346.415946434518 "$node_(299) setdest 94278 41513 6.0" 
$ns at 418.1926931298947 "$node_(299) setdest 51478 43019 19.0" 
$ns at 485.5668412702811 "$node_(299) setdest 84558 5109 18.0" 
$ns at 600.5918309841884 "$node_(299) setdest 79500 42824 2.0" 
$ns at 644.1100580402127 "$node_(299) setdest 117496 1059 13.0" 
$ns at 711.1655860908882 "$node_(299) setdest 57535 41709 8.0" 
$ns at 779.2870884110505 "$node_(299) setdest 47328 31450 1.0" 
$ns at 810.4203212048678 "$node_(299) setdest 76072 15282 3.0" 
$ns at 865.4782870746212 "$node_(299) setdest 28916 11481 19.0" 
$ns at 302.3379190360505 "$node_(300) setdest 48680 41357 12.0" 
$ns at 390.42469913836646 "$node_(300) setdest 59335 20279 8.0" 
$ns at 498.6257724136231 "$node_(300) setdest 88110 8801 12.0" 
$ns at 540.8343323018419 "$node_(300) setdest 3884 32744 16.0" 
$ns at 574.2642812249181 "$node_(300) setdest 21989 5095 3.0" 
$ns at 617.9751211602644 "$node_(300) setdest 7244 44142 16.0" 
$ns at 704.8417667318178 "$node_(300) setdest 86182 6175 13.0" 
$ns at 741.685096756623 "$node_(300) setdest 27395 13194 19.0" 
$ns at 880.1959530849325 "$node_(300) setdest 56829 14031 6.0" 
$ns at 340.0316636718937 "$node_(301) setdest 24890 10530 12.0" 
$ns at 422.74063119361017 "$node_(301) setdest 95678 39382 5.0" 
$ns at 464.06429991095047 "$node_(301) setdest 73926 37085 7.0" 
$ns at 552.3299161590597 "$node_(301) setdest 134061 44208 6.0" 
$ns at 616.5585688277356 "$node_(301) setdest 72894 2755 17.0" 
$ns at 786.9337056732804 "$node_(301) setdest 55515 20729 14.0" 
$ns at 860.9855038165732 "$node_(301) setdest 46 22901 17.0" 
$ns at 897.4107168716766 "$node_(301) setdest 12432 21349 1.0" 
$ns at 312.61195407649905 "$node_(302) setdest 103467 22376 7.0" 
$ns at 357.7602186355705 "$node_(302) setdest 9900 28857 15.0" 
$ns at 450.7876756249854 "$node_(302) setdest 104162 39217 18.0" 
$ns at 534.7410455513223 "$node_(302) setdest 101083 42279 9.0" 
$ns at 608.8532824912795 "$node_(302) setdest 94214 21318 10.0" 
$ns at 698.0312709166474 "$node_(302) setdest 104880 37871 1.0" 
$ns at 728.9060737965033 "$node_(302) setdest 62791 24483 1.0" 
$ns at 760.5705463657375 "$node_(302) setdest 63019 4106 16.0" 
$ns at 889.0622521851515 "$node_(302) setdest 124271 40110 5.0" 
$ns at 343.04783836468687 "$node_(303) setdest 116113 5506 10.0" 
$ns at 378.41661830087037 "$node_(303) setdest 53183 12583 7.0" 
$ns at 437.8722316324049 "$node_(303) setdest 127689 29648 6.0" 
$ns at 500.7551053373833 "$node_(303) setdest 126374 32483 4.0" 
$ns at 558.0143337200784 "$node_(303) setdest 100900 14992 2.0" 
$ns at 602.631813506693 "$node_(303) setdest 77330 20435 7.0" 
$ns at 663.2391498616969 "$node_(303) setdest 96380 8341 15.0" 
$ns at 780.4323097107258 "$node_(303) setdest 132350 35412 18.0" 
$ns at 306.3389740553056 "$node_(304) setdest 72413 41475 5.0" 
$ns at 381.9849975686043 "$node_(304) setdest 126833 226 9.0" 
$ns at 445.23901055109206 "$node_(304) setdest 108966 6701 5.0" 
$ns at 505.52254590414304 "$node_(304) setdest 60638 18371 11.0" 
$ns at 614.3332554955562 "$node_(304) setdest 87167 22236 10.0" 
$ns at 700.3692366342361 "$node_(304) setdest 13373 6393 3.0" 
$ns at 743.2143560021946 "$node_(304) setdest 92901 21208 6.0" 
$ns at 821.4180656472599 "$node_(304) setdest 121324 12991 7.0" 
$ns at 887.6158113097817 "$node_(304) setdest 64780 27681 18.0" 
$ns at 328.4561660523286 "$node_(305) setdest 275 20631 16.0" 
$ns at 470.6297542802813 "$node_(305) setdest 123310 40102 13.0" 
$ns at 576.6688279433724 "$node_(305) setdest 29449 36394 3.0" 
$ns at 631.9363241061754 "$node_(305) setdest 63613 13659 2.0" 
$ns at 674.3112055230523 "$node_(305) setdest 109472 14537 12.0" 
$ns at 735.0136634759913 "$node_(305) setdest 71999 24030 6.0" 
$ns at 785.6486978109464 "$node_(305) setdest 66512 35873 4.0" 
$ns at 853.6827364142559 "$node_(305) setdest 71338 10868 16.0" 
$ns at 409.7012536642755 "$node_(306) setdest 93912 14376 5.0" 
$ns at 471.68558021025706 "$node_(306) setdest 26933 7372 8.0" 
$ns at 516.8859051680221 "$node_(306) setdest 117583 8055 11.0" 
$ns at 594.1860664869472 "$node_(306) setdest 131430 16260 18.0" 
$ns at 729.5490823332267 "$node_(306) setdest 50264 26074 18.0" 
$ns at 460.5918890193823 "$node_(307) setdest 7949 41597 18.0" 
$ns at 540.9951177785857 "$node_(307) setdest 131560 44195 13.0" 
$ns at 593.8282991338513 "$node_(307) setdest 11040 9215 17.0" 
$ns at 694.8138439677447 "$node_(307) setdest 48792 43955 9.0" 
$ns at 807.4446635018617 "$node_(307) setdest 34764 22617 2.0" 
$ns at 855.5234766363889 "$node_(307) setdest 128394 9639 10.0" 
$ns at 357.2946030246052 "$node_(308) setdest 63030 6717 15.0" 
$ns at 390.2132252650183 "$node_(308) setdest 129943 14943 16.0" 
$ns at 472.30385131645 "$node_(308) setdest 22129 13351 1.0" 
$ns at 505.2218957727915 "$node_(308) setdest 39946 36603 11.0" 
$ns at 597.371181263656 "$node_(308) setdest 65223 24208 6.0" 
$ns at 660.0847398549557 "$node_(308) setdest 123784 3002 12.0" 
$ns at 691.2158911774554 "$node_(308) setdest 80748 5379 3.0" 
$ns at 738.9917815127709 "$node_(308) setdest 80502 13653 16.0" 
$ns at 783.4395422464092 "$node_(308) setdest 2298 35601 9.0" 
$ns at 890.6024233993824 "$node_(308) setdest 93902 14331 16.0" 
$ns at 338.51785127988467 "$node_(309) setdest 55348 6403 7.0" 
$ns at 400.4756673603486 "$node_(309) setdest 44404 22673 20.0" 
$ns at 606.099049221877 "$node_(309) setdest 36635 438 15.0" 
$ns at 702.5968819532875 "$node_(309) setdest 12447 6317 17.0" 
$ns at 876.3803163701398 "$node_(309) setdest 30196 25016 7.0" 
$ns at 381.7739765094859 "$node_(310) setdest 27958 19906 11.0" 
$ns at 490.9213544590496 "$node_(310) setdest 7319 8740 13.0" 
$ns at 559.5239961628022 "$node_(310) setdest 33279 28513 8.0" 
$ns at 613.1394141549442 "$node_(310) setdest 56615 6149 9.0" 
$ns at 722.6150891923236 "$node_(310) setdest 121828 7192 8.0" 
$ns at 831.1846638756097 "$node_(310) setdest 46244 22238 17.0" 
$ns at 334.93137446373277 "$node_(311) setdest 97903 17060 18.0" 
$ns at 430.0063250379813 "$node_(311) setdest 80375 19432 15.0" 
$ns at 534.629035254096 "$node_(311) setdest 90108 43709 6.0" 
$ns at 594.0064819980125 "$node_(311) setdest 8223 22866 13.0" 
$ns at 703.6306822428675 "$node_(311) setdest 110398 28414 16.0" 
$ns at 790.0308395729868 "$node_(311) setdest 21409 38847 16.0" 
$ns at 836.1768559378613 "$node_(311) setdest 28102 23732 8.0" 
$ns at 387.44982528975925 "$node_(312) setdest 54788 23725 15.0" 
$ns at 438.056956433546 "$node_(312) setdest 35913 35032 13.0" 
$ns at 537.6335119951357 "$node_(312) setdest 15335 29583 4.0" 
$ns at 583.0194892869872 "$node_(312) setdest 516 39497 2.0" 
$ns at 613.212922479658 "$node_(312) setdest 29188 1206 17.0" 
$ns at 802.6119589070321 "$node_(312) setdest 133545 31331 19.0" 
$ns at 315.2837261474558 "$node_(313) setdest 110345 38017 1.0" 
$ns at 346.0063678467655 "$node_(313) setdest 73494 25316 1.0" 
$ns at 380.34572442568106 "$node_(313) setdest 112809 32215 3.0" 
$ns at 431.57927230943835 "$node_(313) setdest 6197 36159 7.0" 
$ns at 484.9216102375323 "$node_(313) setdest 71538 8314 3.0" 
$ns at 517.3691732741405 "$node_(313) setdest 125458 35953 7.0" 
$ns at 603.4897394767548 "$node_(313) setdest 60719 37970 8.0" 
$ns at 689.9033842915072 "$node_(313) setdest 54463 27660 6.0" 
$ns at 777.3299678102858 "$node_(313) setdest 34341 11692 14.0" 
$ns at 821.296214443573 "$node_(313) setdest 34295 20776 17.0" 
$ns at 890.6507396420208 "$node_(313) setdest 99858 34291 12.0" 
$ns at 358.7171160074089 "$node_(314) setdest 14012 8280 15.0" 
$ns at 422.2519680161742 "$node_(314) setdest 1573 17818 16.0" 
$ns at 467.9823239547258 "$node_(314) setdest 25980 1557 14.0" 
$ns at 588.5826567507715 "$node_(314) setdest 34789 39019 17.0" 
$ns at 688.979621722443 "$node_(314) setdest 95009 2042 11.0" 
$ns at 779.0060567393604 "$node_(314) setdest 124425 21337 13.0" 
$ns at 885.5341419321173 "$node_(314) setdest 20316 8537 20.0" 
$ns at 353.7572491334812 "$node_(315) setdest 24063 19428 14.0" 
$ns at 495.45648122113045 "$node_(315) setdest 31148 3671 14.0" 
$ns at 622.071227260408 "$node_(315) setdest 64696 13314 3.0" 
$ns at 661.1462989321542 "$node_(315) setdest 85458 42738 19.0" 
$ns at 698.449493194775 "$node_(315) setdest 44132 21814 16.0" 
$ns at 844.6136098708992 "$node_(315) setdest 73686 24857 14.0" 
$ns at 371.6778226917718 "$node_(316) setdest 122472 3667 17.0" 
$ns at 406.83573682316194 "$node_(316) setdest 1945 44436 10.0" 
$ns at 513.5228627765944 "$node_(316) setdest 76955 25583 4.0" 
$ns at 565.2681943224667 "$node_(316) setdest 17428 30283 6.0" 
$ns at 613.903004063877 "$node_(316) setdest 121540 10268 5.0" 
$ns at 664.6459498994118 "$node_(316) setdest 67427 35417 7.0" 
$ns at 734.5840415943793 "$node_(316) setdest 23823 23995 16.0" 
$ns at 782.5259035516995 "$node_(316) setdest 47872 42393 17.0" 
$ns at 819.1245170440043 "$node_(316) setdest 67586 37578 3.0" 
$ns at 850.3545766759195 "$node_(316) setdest 114126 29366 2.0" 
$ns at 881.1869002189676 "$node_(316) setdest 104951 25123 3.0" 
$ns at 396.9751156297724 "$node_(317) setdest 22873 33439 4.0" 
$ns at 437.6514059264522 "$node_(317) setdest 19380 38398 18.0" 
$ns at 569.1607294057121 "$node_(317) setdest 81844 37014 5.0" 
$ns at 606.8336418285421 "$node_(317) setdest 116373 37300 3.0" 
$ns at 643.241974462022 "$node_(317) setdest 78454 1970 1.0" 
$ns at 678.2226311064512 "$node_(317) setdest 13232 6759 16.0" 
$ns at 717.3022412805868 "$node_(317) setdest 17908 41261 1.0" 
$ns at 750.4903499371345 "$node_(317) setdest 114389 43794 13.0" 
$ns at 809.0417531448653 "$node_(317) setdest 29360 27224 2.0" 
$ns at 850.6797736706363 "$node_(317) setdest 82884 6552 17.0" 
$ns at 363.4502476599597 "$node_(318) setdest 14044 10396 18.0" 
$ns at 563.4358386131166 "$node_(318) setdest 92448 17792 4.0" 
$ns at 594.021996507514 "$node_(318) setdest 21276 17433 14.0" 
$ns at 753.9212833432774 "$node_(318) setdest 107347 42817 20.0" 
$ns at 833.5465386561051 "$node_(318) setdest 27778 41359 2.0" 
$ns at 863.5857090777972 "$node_(318) setdest 11467 8369 12.0" 
$ns at 434.3253329660491 "$node_(319) setdest 4597 23875 19.0" 
$ns at 626.6372123055515 "$node_(319) setdest 14966 25011 14.0" 
$ns at 670.3346592781432 "$node_(319) setdest 99737 15494 5.0" 
$ns at 702.0955934616336 "$node_(319) setdest 80502 32360 7.0" 
$ns at 789.0015408222544 "$node_(319) setdest 121653 19551 3.0" 
$ns at 835.6892221681628 "$node_(319) setdest 79153 35603 3.0" 
$ns at 883.4198330163853 "$node_(319) setdest 76092 33790 9.0" 
$ns at 317.4846666427316 "$node_(320) setdest 71065 38903 5.0" 
$ns at 380.9582115945988 "$node_(320) setdest 14523 10072 10.0" 
$ns at 505.9735039928578 "$node_(320) setdest 57825 9774 9.0" 
$ns at 547.6772097128011 "$node_(320) setdest 12281 29567 3.0" 
$ns at 585.5165752025358 "$node_(320) setdest 6106 35269 16.0" 
$ns at 721.1203669146071 "$node_(320) setdest 30120 24107 7.0" 
$ns at 756.5915070814092 "$node_(320) setdest 130391 29186 8.0" 
$ns at 835.1911830303548 "$node_(320) setdest 105920 41163 2.0" 
$ns at 884.3322230914282 "$node_(320) setdest 89861 42603 3.0" 
$ns at 450.34933369207783 "$node_(321) setdest 86635 325 5.0" 
$ns at 506.81760577685486 "$node_(321) setdest 44321 39683 5.0" 
$ns at 584.1300267258272 "$node_(321) setdest 122545 17934 4.0" 
$ns at 652.7603925441517 "$node_(321) setdest 66753 44605 19.0" 
$ns at 848.1848934046552 "$node_(321) setdest 128928 41525 16.0" 
$ns at 343.0941698690647 "$node_(322) setdest 8484 40591 10.0" 
$ns at 397.34513713453134 "$node_(322) setdest 13250 34051 1.0" 
$ns at 430.5561469896663 "$node_(322) setdest 63558 35178 17.0" 
$ns at 575.4598748899258 "$node_(322) setdest 45878 7628 14.0" 
$ns at 624.5650825840085 "$node_(322) setdest 51313 20125 5.0" 
$ns at 662.8227954054881 "$node_(322) setdest 5573 35711 18.0" 
$ns at 806.2640748183451 "$node_(322) setdest 93468 21903 1.0" 
$ns at 836.7502529907835 "$node_(322) setdest 79636 18097 20.0" 
$ns at 401.98033795288165 "$node_(323) setdest 7741 15492 13.0" 
$ns at 475.6819573633177 "$node_(323) setdest 117995 32335 13.0" 
$ns at 589.3329046768723 "$node_(323) setdest 90497 12139 6.0" 
$ns at 632.3877278317088 "$node_(323) setdest 31170 17475 10.0" 
$ns at 740.454389775185 "$node_(323) setdest 2898 35105 7.0" 
$ns at 813.3528847192252 "$node_(323) setdest 122138 40205 8.0" 
$ns at 330.61407975558274 "$node_(324) setdest 45796 42154 17.0" 
$ns at 492.475633490684 "$node_(324) setdest 13668 32021 13.0" 
$ns at 614.4055577021583 "$node_(324) setdest 79142 30384 3.0" 
$ns at 657.152283091527 "$node_(324) setdest 29195 10790 1.0" 
$ns at 689.019691710155 "$node_(324) setdest 131510 16833 9.0" 
$ns at 733.490877099087 "$node_(324) setdest 52692 41363 16.0" 
$ns at 884.4055897082537 "$node_(324) setdest 116753 7699 13.0" 
$ns at 372.708068778196 "$node_(325) setdest 72162 41043 13.0" 
$ns at 462.96675030861263 "$node_(325) setdest 115699 5553 13.0" 
$ns at 594.7994598404132 "$node_(325) setdest 56354 42908 17.0" 
$ns at 672.5443154634488 "$node_(325) setdest 44595 14300 9.0" 
$ns at 790.2585115375906 "$node_(325) setdest 12238 5151 6.0" 
$ns at 860.4306471045442 "$node_(325) setdest 17675 12326 1.0" 
$ns at 890.8742341975081 "$node_(325) setdest 55602 26024 11.0" 
$ns at 349.2703152649026 "$node_(326) setdest 13452 24803 20.0" 
$ns at 527.1682077459077 "$node_(326) setdest 6453 7089 4.0" 
$ns at 563.5133620047557 "$node_(326) setdest 128530 14216 5.0" 
$ns at 622.5443005337936 "$node_(326) setdest 68977 31683 10.0" 
$ns at 686.3347414576702 "$node_(326) setdest 67116 16546 18.0" 
$ns at 853.535946022238 "$node_(326) setdest 33417 6871 15.0" 
$ns at 395.30390750798995 "$node_(327) setdest 121141 19909 3.0" 
$ns at 425.7196571622231 "$node_(327) setdest 70592 13849 15.0" 
$ns at 506.9097375800922 "$node_(327) setdest 128486 17773 17.0" 
$ns at 577.5489314770884 "$node_(327) setdest 36065 1806 18.0" 
$ns at 662.5052741018721 "$node_(327) setdest 14983 11737 5.0" 
$ns at 694.9029063903034 "$node_(327) setdest 62258 13337 14.0" 
$ns at 729.3812137971398 "$node_(327) setdest 13351 1723 16.0" 
$ns at 839.1499391678697 "$node_(327) setdest 26618 24098 9.0" 
$ns at 449.63478536102355 "$node_(328) setdest 87829 7805 13.0" 
$ns at 498.60591821974145 "$node_(328) setdest 57757 20667 4.0" 
$ns at 546.5967858682702 "$node_(328) setdest 85154 8181 15.0" 
$ns at 606.2529274307471 "$node_(328) setdest 56155 22699 2.0" 
$ns at 649.5131618065782 "$node_(328) setdest 93619 1407 5.0" 
$ns at 682.1331983986717 "$node_(328) setdest 125827 35817 1.0" 
$ns at 712.9520212123292 "$node_(328) setdest 96843 21923 20.0" 
$ns at 817.3236137659333 "$node_(328) setdest 85569 25996 15.0" 
$ns at 334.26568081652795 "$node_(329) setdest 104380 24933 20.0" 
$ns at 407.19168746736347 "$node_(329) setdest 30574 34138 20.0" 
$ns at 614.6048169376027 "$node_(329) setdest 73694 18555 8.0" 
$ns at 645.1408483359356 "$node_(329) setdest 57733 1259 12.0" 
$ns at 790.0792333259733 "$node_(329) setdest 74005 25503 18.0" 
$ns at 309.0950863087171 "$node_(330) setdest 125313 17710 13.0" 
$ns at 410.5459148147644 "$node_(330) setdest 92264 5487 14.0" 
$ns at 519.2326648198202 "$node_(330) setdest 35906 13358 18.0" 
$ns at 635.4400640447101 "$node_(330) setdest 98812 15242 18.0" 
$ns at 763.7167845360414 "$node_(330) setdest 49668 31151 3.0" 
$ns at 813.8597736196216 "$node_(330) setdest 79315 26702 6.0" 
$ns at 452.7803252906539 "$node_(331) setdest 13272 22899 9.0" 
$ns at 494.62787412975445 "$node_(331) setdest 111113 33272 3.0" 
$ns at 530.233328549159 "$node_(331) setdest 124074 6076 14.0" 
$ns at 633.2845064582857 "$node_(331) setdest 69592 41954 17.0" 
$ns at 702.1444665287622 "$node_(331) setdest 22854 31723 19.0" 
$ns at 770.9057703267184 "$node_(331) setdest 106346 4670 2.0" 
$ns at 807.5005618169688 "$node_(331) setdest 127029 15652 5.0" 
$ns at 854.3080000978297 "$node_(331) setdest 94499 7362 4.0" 
$ns at 886.8116029988926 "$node_(331) setdest 45044 20401 6.0" 
$ns at 337.15590378581146 "$node_(332) setdest 25154 17819 20.0" 
$ns at 433.2604477060579 "$node_(332) setdest 26664 27532 13.0" 
$ns at 539.777219812076 "$node_(332) setdest 99433 17083 9.0" 
$ns at 637.8988079170597 "$node_(332) setdest 29281 5837 3.0" 
$ns at 684.9074192928023 "$node_(332) setdest 41164 21418 16.0" 
$ns at 792.831974685106 "$node_(332) setdest 45071 15501 16.0" 
$ns at 422.83297930680965 "$node_(333) setdest 87689 17334 9.0" 
$ns at 525.8153961571477 "$node_(333) setdest 113353 40683 8.0" 
$ns at 627.3713577033961 "$node_(333) setdest 18787 40988 16.0" 
$ns at 740.3496442598912 "$node_(333) setdest 23680 18006 9.0" 
$ns at 797.9120476282346 "$node_(333) setdest 33360 7539 17.0" 
$ns at 331.360176657847 "$node_(334) setdest 65403 28760 12.0" 
$ns at 418.09950859882497 "$node_(334) setdest 54759 23597 1.0" 
$ns at 457.5642356829133 "$node_(334) setdest 9052 18924 3.0" 
$ns at 499.61989977645874 "$node_(334) setdest 133217 40476 10.0" 
$ns at 617.6649835609633 "$node_(334) setdest 31560 2235 3.0" 
$ns at 651.0344218433196 "$node_(334) setdest 111821 28711 4.0" 
$ns at 699.3136710837375 "$node_(334) setdest 32841 26962 8.0" 
$ns at 760.6843815672453 "$node_(334) setdest 78820 13814 14.0" 
$ns at 884.3919875187288 "$node_(334) setdest 82383 1511 2.0" 
$ns at 351.03906683986884 "$node_(335) setdest 54019 16383 12.0" 
$ns at 407.2840611304363 "$node_(335) setdest 126963 24340 8.0" 
$ns at 476.07120253368623 "$node_(335) setdest 42700 22159 18.0" 
$ns at 578.4405627594175 "$node_(335) setdest 944 2632 13.0" 
$ns at 672.3117480500313 "$node_(335) setdest 14814 43426 3.0" 
$ns at 704.2888400910989 "$node_(335) setdest 33282 16835 19.0" 
$ns at 325.201438871081 "$node_(336) setdest 6083 295 12.0" 
$ns at 450.51333175737693 "$node_(336) setdest 106271 26474 15.0" 
$ns at 553.8618993120364 "$node_(336) setdest 44132 31051 10.0" 
$ns at 595.1466547076711 "$node_(336) setdest 23656 11027 6.0" 
$ns at 664.7469965151499 "$node_(336) setdest 75398 9305 14.0" 
$ns at 814.6177779340683 "$node_(336) setdest 100475 44044 4.0" 
$ns at 855.8666528791694 "$node_(336) setdest 19219 26834 4.0" 
$ns at 332.21627189201115 "$node_(337) setdest 128365 18184 8.0" 
$ns at 438.5517424967501 "$node_(337) setdest 55977 28355 15.0" 
$ns at 491.73352837555893 "$node_(337) setdest 129532 15961 4.0" 
$ns at 555.4716390832925 "$node_(337) setdest 65237 19520 18.0" 
$ns at 713.226669406452 "$node_(337) setdest 132199 12267 13.0" 
$ns at 816.1997507607557 "$node_(337) setdest 58059 368 10.0" 
$ns at 360.85098140345866 "$node_(338) setdest 96180 7734 9.0" 
$ns at 478.75312707144786 "$node_(338) setdest 59588 703 1.0" 
$ns at 510.5260177429344 "$node_(338) setdest 33317 38664 13.0" 
$ns at 596.97783317032 "$node_(338) setdest 59946 17788 19.0" 
$ns at 810.9385311396599 "$node_(338) setdest 17655 25233 7.0" 
$ns at 877.5424516705015 "$node_(338) setdest 60947 18822 6.0" 
$ns at 390.4931042294886 "$node_(339) setdest 29672 26431 15.0" 
$ns at 492.7642316736469 "$node_(339) setdest 69167 35440 15.0" 
$ns at 578.3597767816651 "$node_(339) setdest 11986 2520 19.0" 
$ns at 630.2507999449409 "$node_(339) setdest 66422 5730 20.0" 
$ns at 712.849757381018 "$node_(339) setdest 63633 1441 12.0" 
$ns at 759.0759834898877 "$node_(339) setdest 47048 17988 10.0" 
$ns at 814.6949178179968 "$node_(339) setdest 127849 11361 1.0" 
$ns at 853.4349475185771 "$node_(339) setdest 42222 31375 1.0" 
$ns at 892.4648428754344 "$node_(339) setdest 29036 19664 4.0" 
$ns at 328.3670758952983 "$node_(340) setdest 125078 42552 8.0" 
$ns at 412.6322858125872 "$node_(340) setdest 131417 15984 12.0" 
$ns at 496.1360150351745 "$node_(340) setdest 106902 13031 17.0" 
$ns at 548.7901009483684 "$node_(340) setdest 97956 3458 14.0" 
$ns at 712.8161143864286 "$node_(340) setdest 81257 20187 13.0" 
$ns at 854.3018693806393 "$node_(340) setdest 99382 15144 15.0" 
$ns at 312.17816822568136 "$node_(341) setdest 27579 422 8.0" 
$ns at 366.6328600225702 "$node_(341) setdest 59159 7548 5.0" 
$ns at 433.80372144817176 "$node_(341) setdest 46888 40802 17.0" 
$ns at 526.1617286544424 "$node_(341) setdest 24482 37126 2.0" 
$ns at 569.9211192455252 "$node_(341) setdest 30356 18378 6.0" 
$ns at 600.6125162701119 "$node_(341) setdest 96466 38212 19.0" 
$ns at 805.2551157004598 "$node_(341) setdest 9894 33626 8.0" 
$ns at 413.7239821164044 "$node_(342) setdest 122757 41877 7.0" 
$ns at 501.9246843450167 "$node_(342) setdest 90070 18837 12.0" 
$ns at 532.7203494556551 "$node_(342) setdest 11575 4205 8.0" 
$ns at 626.1468232742433 "$node_(342) setdest 53903 15230 16.0" 
$ns at 693.914282358196 "$node_(342) setdest 70033 6876 1.0" 
$ns at 729.6006287773303 "$node_(342) setdest 27723 41015 4.0" 
$ns at 766.9550158709553 "$node_(342) setdest 27406 11910 1.0" 
$ns at 797.1233773144925 "$node_(342) setdest 53716 39345 11.0" 
$ns at 384.9136776383459 "$node_(343) setdest 91453 33213 7.0" 
$ns at 481.01687698979674 "$node_(343) setdest 90262 2340 2.0" 
$ns at 517.177754458501 "$node_(343) setdest 90588 40123 11.0" 
$ns at 550.3488961010929 "$node_(343) setdest 125839 43555 8.0" 
$ns at 593.0059338292274 "$node_(343) setdest 30071 37172 10.0" 
$ns at 627.5206165931637 "$node_(343) setdest 46564 34908 12.0" 
$ns at 730.6445211821523 "$node_(343) setdest 83458 24800 1.0" 
$ns at 760.6706790354054 "$node_(343) setdest 129604 3164 10.0" 
$ns at 850.4049125570396 "$node_(343) setdest 93095 21741 10.0" 
$ns at 882.4822566022922 "$node_(343) setdest 38234 31644 20.0" 
$ns at 314.33577092159 "$node_(344) setdest 50596 18217 2.0" 
$ns at 361.5243199603682 "$node_(344) setdest 116383 29496 12.0" 
$ns at 494.2783247448246 "$node_(344) setdest 2359 9653 1.0" 
$ns at 528.1394704570625 "$node_(344) setdest 116050 7985 7.0" 
$ns at 570.9454616009622 "$node_(344) setdest 28349 33955 9.0" 
$ns at 630.483784911592 "$node_(344) setdest 35072 4394 19.0" 
$ns at 788.3762950663124 "$node_(344) setdest 24302 36904 10.0" 
$ns at 868.9317384072357 "$node_(344) setdest 29148 22001 17.0" 
$ns at 383.69034500040186 "$node_(345) setdest 35697 26225 7.0" 
$ns at 427.1124586861653 "$node_(345) setdest 83345 39800 3.0" 
$ns at 470.04259176494884 "$node_(345) setdest 67921 29914 12.0" 
$ns at 500.44531013808125 "$node_(345) setdest 35685 7934 8.0" 
$ns at 600.3941661136013 "$node_(345) setdest 129436 33906 15.0" 
$ns at 744.0165608349237 "$node_(345) setdest 75039 37106 5.0" 
$ns at 795.8015227429904 "$node_(345) setdest 124741 44280 11.0" 
$ns at 887.6222782935467 "$node_(345) setdest 21973 32166 5.0" 
$ns at 319.2458718804705 "$node_(346) setdest 110104 27547 16.0" 
$ns at 381.79603655989854 "$node_(346) setdest 116487 41228 14.0" 
$ns at 442.19177447601214 "$node_(346) setdest 66570 20220 10.0" 
$ns at 519.3627922011406 "$node_(346) setdest 77959 38471 5.0" 
$ns at 580.9827639260333 "$node_(346) setdest 38065 19560 11.0" 
$ns at 707.2497951677801 "$node_(346) setdest 132258 25612 3.0" 
$ns at 739.0251168760045 "$node_(346) setdest 97197 32401 6.0" 
$ns at 811.6998892736885 "$node_(346) setdest 57355 6457 5.0" 
$ns at 880.1709395079413 "$node_(346) setdest 109749 30010 18.0" 
$ns at 394.89575238418155 "$node_(347) setdest 68356 28157 10.0" 
$ns at 450.368359557715 "$node_(347) setdest 133018 2237 5.0" 
$ns at 508.9845040248347 "$node_(347) setdest 36729 14620 7.0" 
$ns at 575.0031373953839 "$node_(347) setdest 111911 11821 15.0" 
$ns at 608.8655999890269 "$node_(347) setdest 121134 7610 9.0" 
$ns at 723.2525095989492 "$node_(347) setdest 91695 2143 14.0" 
$ns at 881.186930541828 "$node_(347) setdest 59366 44550 4.0" 
$ns at 340.2498545785594 "$node_(348) setdest 85235 13331 9.0" 
$ns at 374.35248047430036 "$node_(348) setdest 48640 28977 16.0" 
$ns at 424.9187887261288 "$node_(348) setdest 122617 14842 14.0" 
$ns at 536.9062172363465 "$node_(348) setdest 7614 7222 1.0" 
$ns at 575.8870606619682 "$node_(348) setdest 83805 19661 13.0" 
$ns at 611.8050360274415 "$node_(348) setdest 134061 42148 3.0" 
$ns at 650.3533414099943 "$node_(348) setdest 25390 9876 11.0" 
$ns at 740.4314961977071 "$node_(348) setdest 73988 17552 19.0" 
$ns at 807.6181740445119 "$node_(348) setdest 69136 18867 12.0" 
$ns at 379.29673599968635 "$node_(349) setdest 72066 36101 8.0" 
$ns at 420.31151115714675 "$node_(349) setdest 127117 9868 16.0" 
$ns at 470.3235981866998 "$node_(349) setdest 82801 14778 6.0" 
$ns at 514.3536190569394 "$node_(349) setdest 5010 33470 13.0" 
$ns at 549.7975703957107 "$node_(349) setdest 79072 17745 17.0" 
$ns at 603.0167878261848 "$node_(349) setdest 72566 23719 17.0" 
$ns at 633.6191595312499 "$node_(349) setdest 66247 43562 1.0" 
$ns at 666.6300106893866 "$node_(349) setdest 127384 43055 2.0" 
$ns at 715.13092569309 "$node_(349) setdest 113939 29942 13.0" 
$ns at 864.9311896378042 "$node_(349) setdest 6204 16361 2.0" 
$ns at 332.42132582086947 "$node_(350) setdest 28159 44075 3.0" 
$ns at 380.46179910591786 "$node_(350) setdest 126628 5464 16.0" 
$ns at 474.86230952809103 "$node_(350) setdest 92524 17394 13.0" 
$ns at 551.9810957957673 "$node_(350) setdest 41011 27958 11.0" 
$ns at 645.4901116146633 "$node_(350) setdest 103596 33340 19.0" 
$ns at 773.7110923810237 "$node_(350) setdest 53840 19552 6.0" 
$ns at 816.2679012818531 "$node_(350) setdest 3345 21603 13.0" 
$ns at 855.404774986469 "$node_(350) setdest 116300 259 9.0" 
$ns at 416.7962406732739 "$node_(351) setdest 83486 16127 18.0" 
$ns at 622.3389428934269 "$node_(351) setdest 100877 31438 3.0" 
$ns at 665.6450447617202 "$node_(351) setdest 9300 30074 14.0" 
$ns at 795.6158130927831 "$node_(351) setdest 83714 19231 15.0" 
$ns at 894.030555574612 "$node_(351) setdest 41069 5588 13.0" 
$ns at 337.4131004145999 "$node_(352) setdest 21611 8369 1.0" 
$ns at 371.15583693813613 "$node_(352) setdest 119482 12428 15.0" 
$ns at 537.8927943084531 "$node_(352) setdest 30605 17203 14.0" 
$ns at 705.4147835996871 "$node_(352) setdest 89829 4316 13.0" 
$ns at 767.2071447656328 "$node_(352) setdest 21043 41594 7.0" 
$ns at 862.8488661179204 "$node_(352) setdest 126124 39190 7.0" 
$ns at 336.9787085397537 "$node_(353) setdest 107340 42357 15.0" 
$ns at 453.61656465832056 "$node_(353) setdest 57839 27502 2.0" 
$ns at 485.8773891865852 "$node_(353) setdest 29210 15813 14.0" 
$ns at 598.611452083897 "$node_(353) setdest 85208 3599 18.0" 
$ns at 693.2581035627479 "$node_(353) setdest 21890 29205 19.0" 
$ns at 742.8664750551284 "$node_(353) setdest 8366 38824 9.0" 
$ns at 833.1401376252107 "$node_(353) setdest 26824 35312 10.0" 
$ns at 877.9371700128285 "$node_(353) setdest 103133 38018 14.0" 
$ns at 384.7430268407854 "$node_(354) setdest 35018 24473 6.0" 
$ns at 430.19320056054397 "$node_(354) setdest 1440 33127 18.0" 
$ns at 470.7119928423217 "$node_(354) setdest 62402 29653 9.0" 
$ns at 546.1723813281299 "$node_(354) setdest 110988 4114 13.0" 
$ns at 640.1193031539411 "$node_(354) setdest 39896 31109 2.0" 
$ns at 679.1095547586111 "$node_(354) setdest 44433 7332 13.0" 
$ns at 741.7382065128093 "$node_(354) setdest 126100 41166 4.0" 
$ns at 779.2783303873834 "$node_(354) setdest 116699 20106 9.0" 
$ns at 828.678068406132 "$node_(354) setdest 130655 22658 14.0" 
$ns at 302.22930879441043 "$node_(355) setdest 69138 30685 10.0" 
$ns at 361.28403623085933 "$node_(355) setdest 89061 35196 2.0" 
$ns at 405.5876009516203 "$node_(355) setdest 69556 40783 19.0" 
$ns at 475.04959236868234 "$node_(355) setdest 89767 35264 3.0" 
$ns at 514.736000080519 "$node_(355) setdest 87491 7711 19.0" 
$ns at 572.4698030986035 "$node_(355) setdest 84853 368 8.0" 
$ns at 680.8000442322592 "$node_(355) setdest 112521 27194 19.0" 
$ns at 899.389538198158 "$node_(355) setdest 92478 15312 15.0" 
$ns at 316.4153803960163 "$node_(356) setdest 85719 40364 19.0" 
$ns at 376.99598541649783 "$node_(356) setdest 26283 34579 19.0" 
$ns at 472.2767323928049 "$node_(356) setdest 118480 12595 10.0" 
$ns at 566.3062689540825 "$node_(356) setdest 15307 10706 1.0" 
$ns at 601.5694591109684 "$node_(356) setdest 105542 13589 14.0" 
$ns at 719.0517165978663 "$node_(356) setdest 64759 10492 6.0" 
$ns at 797.3967072738465 "$node_(356) setdest 17655 19365 16.0" 
$ns at 320.17896914366634 "$node_(357) setdest 79532 11903 6.0" 
$ns at 394.363680221361 "$node_(357) setdest 98328 4372 3.0" 
$ns at 429.96831932640475 "$node_(357) setdest 26702 493 13.0" 
$ns at 580.4270695758272 "$node_(357) setdest 101536 34942 14.0" 
$ns at 656.4363729621737 "$node_(357) setdest 43669 2714 5.0" 
$ns at 727.9118866451381 "$node_(357) setdest 32976 16355 8.0" 
$ns at 770.1528314381391 "$node_(357) setdest 104790 16534 8.0" 
$ns at 840.9817526091877 "$node_(357) setdest 91056 13607 3.0" 
$ns at 872.5933705390806 "$node_(357) setdest 96157 5913 20.0" 
$ns at 313.2228215932949 "$node_(358) setdest 37403 16199 5.0" 
$ns at 355.1493485830405 "$node_(358) setdest 37757 504 1.0" 
$ns at 394.71043656680547 "$node_(358) setdest 34587 21716 5.0" 
$ns at 439.9759655110756 "$node_(358) setdest 94112 8664 17.0" 
$ns at 559.2131136253176 "$node_(358) setdest 29389 34302 13.0" 
$ns at 593.2367871850083 "$node_(358) setdest 64885 21453 15.0" 
$ns at 722.5873397747937 "$node_(358) setdest 6436 41721 8.0" 
$ns at 779.1635876064365 "$node_(358) setdest 109191 5757 6.0" 
$ns at 843.5443079403997 "$node_(358) setdest 111839 42446 16.0" 
$ns at 356.8042381043384 "$node_(359) setdest 34078 12284 13.0" 
$ns at 453.3908762770469 "$node_(359) setdest 69106 1392 1.0" 
$ns at 487.74368270868143 "$node_(359) setdest 121220 20116 19.0" 
$ns at 677.7823183933715 "$node_(359) setdest 101097 20721 16.0" 
$ns at 804.7834561496875 "$node_(359) setdest 23491 30787 7.0" 
$ns at 897.822247767948 "$node_(359) setdest 6438 172 3.0" 
$ns at 385.72854764804663 "$node_(360) setdest 49696 17576 2.0" 
$ns at 416.89823962048047 "$node_(360) setdest 90249 43346 15.0" 
$ns at 465.99344635934165 "$node_(360) setdest 31725 13670 18.0" 
$ns at 624.8099198577462 "$node_(360) setdest 11903 41403 4.0" 
$ns at 656.0548741418244 "$node_(360) setdest 104016 40426 15.0" 
$ns at 687.7380540366466 "$node_(360) setdest 55224 15873 6.0" 
$ns at 756.7550768451958 "$node_(360) setdest 132767 29324 17.0" 
$ns at 843.197662992507 "$node_(360) setdest 58769 6642 6.0" 
$ns at 393.31974224305293 "$node_(361) setdest 116647 22865 14.0" 
$ns at 549.3271341214568 "$node_(361) setdest 114283 26889 6.0" 
$ns at 586.5541894428176 "$node_(361) setdest 84906 3572 17.0" 
$ns at 728.4395299830455 "$node_(361) setdest 21472 19379 17.0" 
$ns at 808.7772072445296 "$node_(361) setdest 28617 23640 10.0" 
$ns at 839.3238974484348 "$node_(361) setdest 104740 11202 3.0" 
$ns at 890.5768012019787 "$node_(361) setdest 131768 31498 3.0" 
$ns at 402.33852895714506 "$node_(362) setdest 80494 22979 4.0" 
$ns at 471.4877991742842 "$node_(362) setdest 111712 37794 12.0" 
$ns at 544.6681971333128 "$node_(362) setdest 34724 13016 8.0" 
$ns at 577.4145950172272 "$node_(362) setdest 92232 8394 10.0" 
$ns at 630.620585873425 "$node_(362) setdest 93653 33370 17.0" 
$ns at 761.4093612471687 "$node_(362) setdest 50833 11222 17.0" 
$ns at 859.4820160781145 "$node_(362) setdest 46715 29738 7.0" 
$ns at 340.4785318581311 "$node_(363) setdest 70840 37938 15.0" 
$ns at 439.7315919453562 "$node_(363) setdest 105711 29015 11.0" 
$ns at 489.59155721772123 "$node_(363) setdest 99372 30608 15.0" 
$ns at 566.4314392492247 "$node_(363) setdest 46151 27657 15.0" 
$ns at 697.3675824574317 "$node_(363) setdest 79354 24709 12.0" 
$ns at 734.2296745681018 "$node_(363) setdest 94030 7695 6.0" 
$ns at 811.2696875942614 "$node_(363) setdest 121308 156 11.0" 
$ns at 856.6573957921694 "$node_(363) setdest 19185 28088 7.0" 
$ns at 300.525831441406 "$node_(364) setdest 17712 15168 1.0" 
$ns at 333.8465822904426 "$node_(364) setdest 69617 32249 12.0" 
$ns at 420.0337457448011 "$node_(364) setdest 106221 23603 16.0" 
$ns at 548.2695499773395 "$node_(364) setdest 97647 25864 17.0" 
$ns at 580.9282731737426 "$node_(364) setdest 18532 21287 6.0" 
$ns at 633.2166860559427 "$node_(364) setdest 77572 26367 10.0" 
$ns at 681.1811692613758 "$node_(364) setdest 91664 30417 15.0" 
$ns at 797.8454527108352 "$node_(364) setdest 57263 27145 10.0" 
$ns at 892.0301768770504 "$node_(364) setdest 110799 23644 5.0" 
$ns at 307.89650534519666 "$node_(365) setdest 64929 3444 3.0" 
$ns at 357.12314164651065 "$node_(365) setdest 24245 42444 17.0" 
$ns at 396.29759830104405 "$node_(365) setdest 30085 43968 5.0" 
$ns at 465.9029638084114 "$node_(365) setdest 65752 38616 8.0" 
$ns at 546.6788603211068 "$node_(365) setdest 98503 36119 12.0" 
$ns at 643.4580849409105 "$node_(365) setdest 111558 33440 15.0" 
$ns at 692.6741879050057 "$node_(365) setdest 7169 18888 18.0" 
$ns at 791.0586101476472 "$node_(365) setdest 38013 34564 1.0" 
$ns at 830.0584981018634 "$node_(365) setdest 131421 9214 17.0" 
$ns at 309.5989718095876 "$node_(366) setdest 94662 37860 14.0" 
$ns at 399.2283095945213 "$node_(366) setdest 124845 13036 9.0" 
$ns at 518.8451368073312 "$node_(366) setdest 79036 27649 13.0" 
$ns at 601.7455487118114 "$node_(366) setdest 9846 4692 16.0" 
$ns at 764.3353286775526 "$node_(366) setdest 10194 2386 16.0" 
$ns at 862.5770663762737 "$node_(366) setdest 131057 18286 5.0" 
$ns at 342.12391741311967 "$node_(367) setdest 17464 19599 4.0" 
$ns at 396.03566419113014 "$node_(367) setdest 26433 1133 15.0" 
$ns at 437.0301173410156 "$node_(367) setdest 102573 17628 12.0" 
$ns at 492.4158839109689 "$node_(367) setdest 62875 16670 12.0" 
$ns at 641.095254071815 "$node_(367) setdest 67064 705 3.0" 
$ns at 684.7585919280904 "$node_(367) setdest 80989 799 9.0" 
$ns at 764.2518790308234 "$node_(367) setdest 37338 24323 14.0" 
$ns at 893.3245288631293 "$node_(367) setdest 41122 12783 9.0" 
$ns at 375.47988057202923 "$node_(368) setdest 81 36111 13.0" 
$ns at 430.17014934560365 "$node_(368) setdest 81532 8373 18.0" 
$ns at 608.7266218931339 "$node_(368) setdest 39287 31853 12.0" 
$ns at 753.9163693401117 "$node_(368) setdest 56618 28472 10.0" 
$ns at 795.8100469711455 "$node_(368) setdest 46769 21126 6.0" 
$ns at 882.4854729884227 "$node_(368) setdest 62474 38830 11.0" 
$ns at 303.7128066291391 "$node_(369) setdest 23163 38220 10.0" 
$ns at 350.6241506963346 "$node_(369) setdest 54672 32625 20.0" 
$ns at 392.3310049810974 "$node_(369) setdest 64012 27338 7.0" 
$ns at 461.9017272167953 "$node_(369) setdest 63220 32903 16.0" 
$ns at 621.6841416460932 "$node_(369) setdest 1757 33617 9.0" 
$ns at 708.1700992415718 "$node_(369) setdest 132501 1498 11.0" 
$ns at 748.0394310202813 "$node_(369) setdest 74035 32459 3.0" 
$ns at 798.4693596657353 "$node_(369) setdest 27952 18087 17.0" 
$ns at 343.3872003712431 "$node_(370) setdest 98754 9532 1.0" 
$ns at 378.81630486133685 "$node_(370) setdest 41043 26753 11.0" 
$ns at 511.35227035573575 "$node_(370) setdest 64887 3930 2.0" 
$ns at 552.0272927536921 "$node_(370) setdest 56737 39908 14.0" 
$ns at 662.5425147735746 "$node_(370) setdest 12242 38038 13.0" 
$ns at 720.8141827106317 "$node_(370) setdest 129926 24278 11.0" 
$ns at 810.6227239267962 "$node_(370) setdest 39386 36513 12.0" 
$ns at 863.2433490100498 "$node_(370) setdest 65881 36455 10.0" 
$ns at 389.1016236174514 "$node_(371) setdest 23021 17004 19.0" 
$ns at 422.4158492487053 "$node_(371) setdest 59017 8001 15.0" 
$ns at 470.39276089451937 "$node_(371) setdest 112998 26112 12.0" 
$ns at 597.5348351794444 "$node_(371) setdest 91809 19720 6.0" 
$ns at 658.2061348882517 "$node_(371) setdest 72244 5802 12.0" 
$ns at 779.6946837250048 "$node_(371) setdest 81638 32947 4.0" 
$ns at 829.5795954486587 "$node_(371) setdest 60992 1126 11.0" 
$ns at 864.196050482359 "$node_(371) setdest 128078 6005 2.0" 
$ns at 356.5098604504635 "$node_(372) setdest 117160 36114 12.0" 
$ns at 476.0581559265781 "$node_(372) setdest 94867 23743 17.0" 
$ns at 635.4686209762217 "$node_(372) setdest 77200 323 17.0" 
$ns at 819.6806228698706 "$node_(372) setdest 91090 39819 3.0" 
$ns at 855.9004574036077 "$node_(372) setdest 101064 12141 16.0" 
$ns at 303.10043738480243 "$node_(373) setdest 34086 42150 9.0" 
$ns at 419.21407090405035 "$node_(373) setdest 99601 38776 2.0" 
$ns at 455.356844764383 "$node_(373) setdest 53389 17388 19.0" 
$ns at 628.4226777114588 "$node_(373) setdest 11778 17302 4.0" 
$ns at 670.6354684357315 "$node_(373) setdest 33780 5210 1.0" 
$ns at 703.1895101528456 "$node_(373) setdest 118652 11182 8.0" 
$ns at 751.2485066394764 "$node_(373) setdest 55110 3763 15.0" 
$ns at 857.7793880713457 "$node_(373) setdest 3869 20363 20.0" 
$ns at 331.53734561744545 "$node_(374) setdest 121042 43110 12.0" 
$ns at 411.4757868425437 "$node_(374) setdest 95675 27831 9.0" 
$ns at 529.9811148825082 "$node_(374) setdest 120626 22912 9.0" 
$ns at 599.7595731483634 "$node_(374) setdest 54241 1325 4.0" 
$ns at 647.5964437674552 "$node_(374) setdest 31048 13772 11.0" 
$ns at 698.4934654675984 "$node_(374) setdest 68246 1090 11.0" 
$ns at 765.8557439962755 "$node_(374) setdest 114273 28233 16.0" 
$ns at 816.9612167913244 "$node_(374) setdest 74136 38192 16.0" 
$ns at 303.8776840334535 "$node_(375) setdest 92200 19624 1.0" 
$ns at 334.40388797101576 "$node_(375) setdest 128696 24164 1.0" 
$ns at 374.00237576925656 "$node_(375) setdest 102419 2207 7.0" 
$ns at 435.60436649345036 "$node_(375) setdest 85033 28991 3.0" 
$ns at 466.93622828444467 "$node_(375) setdest 95614 39671 10.0" 
$ns at 561.3537830413385 "$node_(375) setdest 127873 21972 14.0" 
$ns at 669.726576972994 "$node_(375) setdest 115240 6431 14.0" 
$ns at 795.6561735527958 "$node_(375) setdest 121955 34934 2.0" 
$ns at 843.1489531644295 "$node_(375) setdest 126625 26071 12.0" 
$ns at 359.81772212516177 "$node_(376) setdest 48669 12773 15.0" 
$ns at 434.33033074288926 "$node_(376) setdest 131394 13532 17.0" 
$ns at 604.1659404621145 "$node_(376) setdest 83691 42056 13.0" 
$ns at 716.0830856777382 "$node_(376) setdest 10916 6216 7.0" 
$ns at 797.7577065196878 "$node_(376) setdest 100427 38175 14.0" 
$ns at 845.7307526239101 "$node_(376) setdest 61982 35605 13.0" 
$ns at 336.9990695316033 "$node_(377) setdest 80237 25612 18.0" 
$ns at 468.091898333014 "$node_(377) setdest 57058 43249 11.0" 
$ns at 511.1599758903632 "$node_(377) setdest 11629 27562 6.0" 
$ns at 553.1094256574851 "$node_(377) setdest 125327 6863 6.0" 
$ns at 600.2216035163827 "$node_(377) setdest 49091 40297 3.0" 
$ns at 642.7388272461997 "$node_(377) setdest 31089 957 10.0" 
$ns at 728.2068696748947 "$node_(377) setdest 87953 20946 19.0" 
$ns at 817.7228954001077 "$node_(377) setdest 83836 40459 19.0" 
$ns at 320.8109708844719 "$node_(378) setdest 105357 18526 4.0" 
$ns at 364.91254513556055 "$node_(378) setdest 20116 35573 4.0" 
$ns at 430.52597842015024 "$node_(378) setdest 123710 17189 8.0" 
$ns at 507.3916615249222 "$node_(378) setdest 64799 8813 6.0" 
$ns at 581.1573581234401 "$node_(378) setdest 59280 26564 10.0" 
$ns at 675.8593552551188 "$node_(378) setdest 125286 37788 9.0" 
$ns at 757.2576027375673 "$node_(378) setdest 42437 7903 18.0" 
$ns at 374.4638252755864 "$node_(379) setdest 47585 5285 4.0" 
$ns at 444.1241714688633 "$node_(379) setdest 11452 44250 19.0" 
$ns at 525.3976702283951 "$node_(379) setdest 100108 10105 9.0" 
$ns at 601.3353662463102 "$node_(379) setdest 80100 27554 19.0" 
$ns at 676.5383217001929 "$node_(379) setdest 21521 635 4.0" 
$ns at 737.4000956047588 "$node_(379) setdest 73839 44066 11.0" 
$ns at 789.4287346699724 "$node_(379) setdest 59507 31225 11.0" 
$ns at 382.02748370697185 "$node_(380) setdest 3973 27680 9.0" 
$ns at 452.9184819696269 "$node_(380) setdest 25691 35264 6.0" 
$ns at 542.5726487865318 "$node_(380) setdest 110858 25338 16.0" 
$ns at 584.1112220418096 "$node_(380) setdest 54055 22965 2.0" 
$ns at 616.5582085548531 "$node_(380) setdest 58578 3037 16.0" 
$ns at 659.7922766226889 "$node_(380) setdest 86313 8619 10.0" 
$ns at 709.118857311141 "$node_(380) setdest 116058 1035 13.0" 
$ns at 740.2619421477995 "$node_(380) setdest 22941 1120 16.0" 
$ns at 414.0448400418786 "$node_(381) setdest 25899 36099 12.0" 
$ns at 562.0716270300654 "$node_(381) setdest 28807 36360 19.0" 
$ns at 635.4156629317918 "$node_(381) setdest 126262 12659 19.0" 
$ns at 750.7828194403439 "$node_(381) setdest 117397 42394 2.0" 
$ns at 796.5498612638479 "$node_(381) setdest 91852 15200 16.0" 
$ns at 362.0514830150422 "$node_(382) setdest 91390 23097 1.0" 
$ns at 393.2393688795393 "$node_(382) setdest 104707 884 16.0" 
$ns at 513.617518780765 "$node_(382) setdest 40693 30106 12.0" 
$ns at 596.6243121328057 "$node_(382) setdest 11885 40029 10.0" 
$ns at 695.8513986065059 "$node_(382) setdest 71842 2601 13.0" 
$ns at 742.3397599718603 "$node_(382) setdest 3311 8065 3.0" 
$ns at 781.8576826956413 "$node_(382) setdest 85134 42972 9.0" 
$ns at 843.3056406440684 "$node_(382) setdest 59144 43314 5.0" 
$ns at 897.1634037777093 "$node_(382) setdest 42702 19015 12.0" 
$ns at 307.7485281833665 "$node_(383) setdest 127621 12344 12.0" 
$ns at 435.9268415709801 "$node_(383) setdest 10802 25698 20.0" 
$ns at 510.26174353116653 "$node_(383) setdest 46235 20784 1.0" 
$ns at 547.2214466064067 "$node_(383) setdest 55967 15065 1.0" 
$ns at 585.6911648097025 "$node_(383) setdest 14940 12794 18.0" 
$ns at 741.3051865664246 "$node_(383) setdest 82856 24178 15.0" 
$ns at 844.7082751746732 "$node_(383) setdest 36084 19214 5.0" 
$ns at 302.35509911987253 "$node_(384) setdest 86714 42066 19.0" 
$ns at 332.7532780901099 "$node_(384) setdest 121520 11765 3.0" 
$ns at 365.29220454213635 "$node_(384) setdest 24617 25202 13.0" 
$ns at 405.2033963555298 "$node_(384) setdest 105153 4374 17.0" 
$ns at 593.3889005477579 "$node_(384) setdest 52213 16530 6.0" 
$ns at 648.8313264565234 "$node_(384) setdest 118032 29568 16.0" 
$ns at 788.5982704723247 "$node_(384) setdest 62864 22989 15.0" 
$ns at 388.60118254077224 "$node_(385) setdest 95803 26105 5.0" 
$ns at 424.53460229502764 "$node_(385) setdest 105817 1350 9.0" 
$ns at 497.99044842912764 "$node_(385) setdest 124407 4680 9.0" 
$ns at 607.1136914399789 "$node_(385) setdest 69783 25308 6.0" 
$ns at 650.5141046036305 "$node_(385) setdest 79452 27583 15.0" 
$ns at 781.0575356750479 "$node_(385) setdest 75632 40124 18.0" 
$ns at 366.7414102473643 "$node_(386) setdest 83087 43439 3.0" 
$ns at 410.54031270012285 "$node_(386) setdest 21554 41228 5.0" 
$ns at 440.6574871489582 "$node_(386) setdest 61676 11359 19.0" 
$ns at 527.8711056889971 "$node_(386) setdest 26618 19192 4.0" 
$ns at 591.4399396013607 "$node_(386) setdest 105633 24448 13.0" 
$ns at 676.8645799784935 "$node_(386) setdest 129712 14479 16.0" 
$ns at 709.7080331915973 "$node_(386) setdest 104203 17901 1.0" 
$ns at 747.1991686295783 "$node_(386) setdest 17058 37030 18.0" 
$ns at 889.9972608961609 "$node_(386) setdest 69701 19155 4.0" 
$ns at 360.95961844978183 "$node_(387) setdest 91622 2353 7.0" 
$ns at 457.8596034010572 "$node_(387) setdest 5679 31372 3.0" 
$ns at 500.2608806694392 "$node_(387) setdest 92493 42615 8.0" 
$ns at 569.4132482361754 "$node_(387) setdest 73103 15574 3.0" 
$ns at 620.1894867606993 "$node_(387) setdest 57709 42965 18.0" 
$ns at 680.6533503420401 "$node_(387) setdest 38741 14852 8.0" 
$ns at 745.6832626251049 "$node_(387) setdest 98530 42689 2.0" 
$ns at 784.6878648849154 "$node_(387) setdest 130172 3234 6.0" 
$ns at 858.2293822474171 "$node_(387) setdest 30056 19364 12.0" 
$ns at 342.57931981142144 "$node_(388) setdest 110637 9619 4.0" 
$ns at 402.4109383330023 "$node_(388) setdest 5456 32243 15.0" 
$ns at 469.343427699465 "$node_(388) setdest 17537 9455 9.0" 
$ns at 522.6545267278273 "$node_(388) setdest 106255 876 6.0" 
$ns at 605.4621913092752 "$node_(388) setdest 104674 25344 17.0" 
$ns at 636.1723907117729 "$node_(388) setdest 11474 19192 6.0" 
$ns at 678.2324561543763 "$node_(388) setdest 121370 22547 16.0" 
$ns at 778.961797118538 "$node_(388) setdest 56916 16535 13.0" 
$ns at 891.3618166779459 "$node_(388) setdest 41681 36737 17.0" 
$ns at 350.0911643478389 "$node_(389) setdest 45607 34535 2.0" 
$ns at 383.4871067894491 "$node_(389) setdest 718 14650 14.0" 
$ns at 418.52876455571 "$node_(389) setdest 40306 35294 2.0" 
$ns at 459.47470406222646 "$node_(389) setdest 13826 14225 4.0" 
$ns at 501.9171127564444 "$node_(389) setdest 82720 27739 14.0" 
$ns at 654.8004854502431 "$node_(389) setdest 35139 5763 5.0" 
$ns at 725.4872423249857 "$node_(389) setdest 133363 17530 2.0" 
$ns at 775.0780546721548 "$node_(389) setdest 57462 32507 11.0" 
$ns at 846.0597555587041 "$node_(389) setdest 123212 43077 7.0" 
$ns at 307.88022729679665 "$node_(390) setdest 134162 32928 6.0" 
$ns at 345.23281330286875 "$node_(390) setdest 63695 41264 7.0" 
$ns at 415.0839522982296 "$node_(390) setdest 32000 15217 20.0" 
$ns at 617.8271543114321 "$node_(390) setdest 4181 4559 7.0" 
$ns at 696.2495741668433 "$node_(390) setdest 15651 41950 7.0" 
$ns at 786.7959360183223 "$node_(390) setdest 90225 26917 16.0" 
$ns at 824.3576809376294 "$node_(390) setdest 92774 19757 6.0" 
$ns at 311.9152056265022 "$node_(391) setdest 128755 8326 18.0" 
$ns at 466.90704405081715 "$node_(391) setdest 107245 20135 10.0" 
$ns at 533.3799693392907 "$node_(391) setdest 15156 43420 13.0" 
$ns at 593.9117940665499 "$node_(391) setdest 79278 14452 3.0" 
$ns at 628.5853268058268 "$node_(391) setdest 108781 39287 7.0" 
$ns at 727.0894093088183 "$node_(391) setdest 42690 12725 10.0" 
$ns at 768.9681844708603 "$node_(391) setdest 129684 9677 10.0" 
$ns at 890.53299331515 "$node_(391) setdest 73353 23813 18.0" 
$ns at 320.7911201414814 "$node_(392) setdest 23818 14474 17.0" 
$ns at 373.0494424298537 "$node_(392) setdest 132300 11691 7.0" 
$ns at 436.13563980700155 "$node_(392) setdest 89068 28546 8.0" 
$ns at 533.3148625476538 "$node_(392) setdest 17391 31805 14.0" 
$ns at 696.9264671408748 "$node_(392) setdest 118493 33878 16.0" 
$ns at 779.334129674106 "$node_(392) setdest 60579 17106 12.0" 
$ns at 896.4851058110315 "$node_(392) setdest 44986 26801 13.0" 
$ns at 418.3527424430366 "$node_(393) setdest 58684 42700 7.0" 
$ns at 476.13668303015004 "$node_(393) setdest 109149 35040 5.0" 
$ns at 509.06916474937924 "$node_(393) setdest 109751 40826 18.0" 
$ns at 664.5459955423165 "$node_(393) setdest 132044 6298 13.0" 
$ns at 811.5866007246361 "$node_(393) setdest 84446 1634 17.0" 
$ns at 335.0955452157863 "$node_(394) setdest 100340 18823 9.0" 
$ns at 454.1558364338497 "$node_(394) setdest 60688 4855 9.0" 
$ns at 533.8773186726129 "$node_(394) setdest 212 27597 5.0" 
$ns at 601.6386388711885 "$node_(394) setdest 97259 25789 13.0" 
$ns at 726.4393874971096 "$node_(394) setdest 68190 18471 8.0" 
$ns at 775.4387301566777 "$node_(394) setdest 123796 41070 7.0" 
$ns at 839.4779997266179 "$node_(394) setdest 32860 22613 9.0" 
$ns at 358.81573228035575 "$node_(395) setdest 6664 41069 15.0" 
$ns at 487.6712581191968 "$node_(395) setdest 103938 14840 10.0" 
$ns at 528.8067928982695 "$node_(395) setdest 98190 38694 12.0" 
$ns at 661.6707515312844 "$node_(395) setdest 121281 30281 3.0" 
$ns at 693.1781058975533 "$node_(395) setdest 104925 2947 16.0" 
$ns at 761.3748845853443 "$node_(395) setdest 122324 43229 14.0" 
$ns at 808.8684200224784 "$node_(395) setdest 120225 8428 15.0" 
$ns at 304.7062018319781 "$node_(396) setdest 97029 24033 12.0" 
$ns at 449.63782471565514 "$node_(396) setdest 104107 25966 4.0" 
$ns at 491.4549153283169 "$node_(396) setdest 115199 41596 1.0" 
$ns at 528.9741770840637 "$node_(396) setdest 65591 36475 1.0" 
$ns at 567.0462111709347 "$node_(396) setdest 42362 16026 6.0" 
$ns at 641.3035373626648 "$node_(396) setdest 57694 2654 3.0" 
$ns at 681.5664922056615 "$node_(396) setdest 59867 33682 1.0" 
$ns at 716.5961319934329 "$node_(396) setdest 18500 5207 13.0" 
$ns at 769.0249726441369 "$node_(396) setdest 76339 10644 4.0" 
$ns at 808.9607853044629 "$node_(396) setdest 98144 14933 11.0" 
$ns at 875.1363815191594 "$node_(396) setdest 90317 18812 3.0" 
$ns at 364.5574621578311 "$node_(397) setdest 27062 43087 11.0" 
$ns at 460.4756422227879 "$node_(397) setdest 65780 6426 16.0" 
$ns at 635.8358149251271 "$node_(397) setdest 48233 37816 6.0" 
$ns at 685.5150497858609 "$node_(397) setdest 80265 38724 6.0" 
$ns at 737.4820049893134 "$node_(397) setdest 116749 22021 6.0" 
$ns at 818.701923011442 "$node_(397) setdest 2483 7931 4.0" 
$ns at 881.3522520329637 "$node_(397) setdest 17406 3925 2.0" 
$ns at 351.38178240034904 "$node_(398) setdest 55130 14836 12.0" 
$ns at 473.563225330599 "$node_(398) setdest 79685 16486 13.0" 
$ns at 546.7131730314422 "$node_(398) setdest 90487 23076 1.0" 
$ns at 580.8710370786662 "$node_(398) setdest 128490 37315 2.0" 
$ns at 627.5083779835105 "$node_(398) setdest 116870 21687 13.0" 
$ns at 693.4454011601446 "$node_(398) setdest 62824 21166 16.0" 
$ns at 726.3934717771816 "$node_(398) setdest 19867 14794 18.0" 
$ns at 757.6179175631122 "$node_(398) setdest 109304 43681 16.0" 
$ns at 348.7401656990677 "$node_(399) setdest 24667 6381 1.0" 
$ns at 384.302896360577 "$node_(399) setdest 132829 39158 13.0" 
$ns at 507.5046290978186 "$node_(399) setdest 129652 3049 9.0" 
$ns at 615.3472432053657 "$node_(399) setdest 128128 44227 4.0" 
$ns at 684.3208714377961 "$node_(399) setdest 83678 27051 19.0" 
$ns at 872.839044766096 "$node_(399) setdest 131154 7199 4.0" 
$ns at 432.4540173999976 "$node_(400) setdest 77960 15205 12.0" 
$ns at 494.7633795957811 "$node_(400) setdest 77414 33177 9.0" 
$ns at 583.7019157110136 "$node_(400) setdest 105312 16691 16.0" 
$ns at 646.3974812395528 "$node_(400) setdest 19924 44042 17.0" 
$ns at 814.301187806778 "$node_(400) setdest 126186 37269 5.0" 
$ns at 868.5325211629153 "$node_(400) setdest 66197 9761 10.0" 
$ns at 461.18137742819795 "$node_(401) setdest 10260 28220 17.0" 
$ns at 652.3394161131084 "$node_(401) setdest 125376 42616 4.0" 
$ns at 710.463320944528 "$node_(401) setdest 107492 118 3.0" 
$ns at 764.0910644680014 "$node_(401) setdest 76778 8190 9.0" 
$ns at 860.9457408697066 "$node_(401) setdest 39530 40157 16.0" 
$ns at 450.57871625987855 "$node_(402) setdest 95180 21053 14.0" 
$ns at 613.1147617886144 "$node_(402) setdest 22675 31284 10.0" 
$ns at 678.6738936261542 "$node_(402) setdest 4438 21092 17.0" 
$ns at 717.4117230002557 "$node_(402) setdest 15031 10486 3.0" 
$ns at 765.5832173952206 "$node_(402) setdest 104590 18634 13.0" 
$ns at 876.1210649140492 "$node_(402) setdest 30512 34991 12.0" 
$ns at 446.59265216452684 "$node_(403) setdest 69292 30929 11.0" 
$ns at 497.1798268598252 "$node_(403) setdest 74013 43118 1.0" 
$ns at 533.9680819476674 "$node_(403) setdest 801 25659 11.0" 
$ns at 605.9049471334095 "$node_(403) setdest 56605 14041 15.0" 
$ns at 778.4343529835105 "$node_(403) setdest 123048 35237 20.0" 
$ns at 827.2526794814239 "$node_(403) setdest 87896 3410 3.0" 
$ns at 871.6763090703189 "$node_(403) setdest 61084 13244 11.0" 
$ns at 496.20891769495637 "$node_(404) setdest 39212 17251 15.0" 
$ns at 578.234458053288 "$node_(404) setdest 81090 30164 19.0" 
$ns at 779.8116657376038 "$node_(404) setdest 96943 20179 12.0" 
$ns at 829.2744591475036 "$node_(404) setdest 91646 34040 17.0" 
$ns at 469.23335428451 "$node_(405) setdest 66211 21875 16.0" 
$ns at 529.7846131707446 "$node_(405) setdest 126199 42865 16.0" 
$ns at 610.9551377830203 "$node_(405) setdest 44572 4226 9.0" 
$ns at 659.9285710918077 "$node_(405) setdest 64398 36505 9.0" 
$ns at 756.0025545362977 "$node_(405) setdest 133793 39477 2.0" 
$ns at 802.185804172118 "$node_(405) setdest 109854 4718 16.0" 
$ns at 459.76236346080833 "$node_(406) setdest 43808 441 10.0" 
$ns at 585.1013294370765 "$node_(406) setdest 9824 22046 20.0" 
$ns at 735.5150396064632 "$node_(406) setdest 68196 31114 11.0" 
$ns at 861.5670005070256 "$node_(406) setdest 132740 16075 19.0" 
$ns at 895.696895824172 "$node_(406) setdest 88982 2356 10.0" 
$ns at 480.60350342766503 "$node_(407) setdest 41199 3759 8.0" 
$ns at 538.7242391170811 "$node_(407) setdest 33352 24741 9.0" 
$ns at 578.3347262861394 "$node_(407) setdest 88335 29149 1.0" 
$ns at 612.1966022472844 "$node_(407) setdest 54108 27226 13.0" 
$ns at 771.2335839682805 "$node_(407) setdest 51526 42296 5.0" 
$ns at 832.3820807975416 "$node_(407) setdest 19330 33119 7.0" 
$ns at 882.8287500529026 "$node_(407) setdest 129105 32319 5.0" 
$ns at 453.37203473504854 "$node_(408) setdest 89783 29558 13.0" 
$ns at 554.7941424781302 "$node_(408) setdest 77486 6341 1.0" 
$ns at 592.6494295430923 "$node_(408) setdest 77804 1373 7.0" 
$ns at 630.5983616956307 "$node_(408) setdest 42044 9241 12.0" 
$ns at 662.656998146954 "$node_(408) setdest 38698 26528 11.0" 
$ns at 796.5233907316353 "$node_(408) setdest 102606 15275 10.0" 
$ns at 869.8207311914009 "$node_(408) setdest 66984 35093 8.0" 
$ns at 411.9049996472342 "$node_(409) setdest 64305 27008 9.0" 
$ns at 516.9048876346484 "$node_(409) setdest 19156 14175 14.0" 
$ns at 614.166085508637 "$node_(409) setdest 13760 44499 15.0" 
$ns at 659.1940078426358 "$node_(409) setdest 56727 23400 11.0" 
$ns at 751.940945213436 "$node_(409) setdest 107409 14781 19.0" 
$ns at 815.7570242278092 "$node_(409) setdest 10513 42889 2.0" 
$ns at 854.1767140037603 "$node_(409) setdest 58498 37317 17.0" 
$ns at 891.4576424532015 "$node_(409) setdest 99651 33225 8.0" 
$ns at 509.6661462787923 "$node_(410) setdest 38306 37924 15.0" 
$ns at 540.6812064272597 "$node_(410) setdest 107926 14258 4.0" 
$ns at 605.5391954609872 "$node_(410) setdest 77899 10179 17.0" 
$ns at 730.5919230475982 "$node_(410) setdest 78704 27983 6.0" 
$ns at 789.0019347039006 "$node_(410) setdest 58056 11421 18.0" 
$ns at 885.3252917860959 "$node_(410) setdest 61236 18860 16.0" 
$ns at 427.69340135252537 "$node_(411) setdest 114216 16760 6.0" 
$ns at 502.56861628086034 "$node_(411) setdest 80456 10824 19.0" 
$ns at 596.0316024578981 "$node_(411) setdest 69946 20236 19.0" 
$ns at 794.1941571622104 "$node_(411) setdest 16376 7849 1.0" 
$ns at 829.6779227601801 "$node_(411) setdest 35428 20961 19.0" 
$ns at 505.14964111376673 "$node_(412) setdest 63730 24563 8.0" 
$ns at 607.1069947404662 "$node_(412) setdest 29528 21682 18.0" 
$ns at 790.3561840818165 "$node_(412) setdest 2764 38916 9.0" 
$ns at 899.4786081368111 "$node_(412) setdest 81535 4531 9.0" 
$ns at 456.4980864895889 "$node_(413) setdest 5156 34771 11.0" 
$ns at 546.3497951613364 "$node_(413) setdest 87214 38295 7.0" 
$ns at 630.0243120374641 "$node_(413) setdest 10232 39256 8.0" 
$ns at 738.9341092546236 "$node_(413) setdest 131117 23071 10.0" 
$ns at 788.8487746114714 "$node_(413) setdest 76030 19542 12.0" 
$ns at 879.3668522708182 "$node_(413) setdest 6018 42344 6.0" 
$ns at 464.3447073605128 "$node_(414) setdest 40233 22286 1.0" 
$ns at 499.15937887800663 "$node_(414) setdest 112716 12854 16.0" 
$ns at 663.1797579523773 "$node_(414) setdest 17135 28374 15.0" 
$ns at 775.5521395736581 "$node_(414) setdest 31854 38259 10.0" 
$ns at 859.2879644741279 "$node_(414) setdest 124598 1754 17.0" 
$ns at 428.51585066045345 "$node_(415) setdest 114211 29570 15.0" 
$ns at 578.6385353537512 "$node_(415) setdest 1144 3443 12.0" 
$ns at 721.7461613718118 "$node_(415) setdest 24531 13390 2.0" 
$ns at 767.8825585513175 "$node_(415) setdest 106653 33260 10.0" 
$ns at 876.0369058297886 "$node_(415) setdest 75504 20865 15.0" 
$ns at 420.3589445264938 "$node_(416) setdest 117441 4895 8.0" 
$ns at 462.23326905426575 "$node_(416) setdest 2454 36985 14.0" 
$ns at 581.6724662349948 "$node_(416) setdest 101228 21120 19.0" 
$ns at 784.472773074721 "$node_(416) setdest 77857 42116 19.0" 
$ns at 875.7507291893162 "$node_(416) setdest 100414 38023 5.0" 
$ns at 416.4808316471441 "$node_(417) setdest 118569 14187 10.0" 
$ns at 475.66439238196796 "$node_(417) setdest 10807 27056 15.0" 
$ns at 559.7067347240562 "$node_(417) setdest 70806 10503 7.0" 
$ns at 632.0192841282668 "$node_(417) setdest 78144 39903 1.0" 
$ns at 667.8944069010186 "$node_(417) setdest 95480 7265 10.0" 
$ns at 755.2703083269946 "$node_(417) setdest 27454 2676 14.0" 
$ns at 837.8026690887166 "$node_(417) setdest 133131 21626 11.0" 
$ns at 418.6128817316643 "$node_(418) setdest 32146 32290 1.0" 
$ns at 457.358056232642 "$node_(418) setdest 70716 12790 14.0" 
$ns at 548.4197247392907 "$node_(418) setdest 104717 1816 15.0" 
$ns at 687.8757911171494 "$node_(418) setdest 113361 11646 19.0" 
$ns at 804.3981302039911 "$node_(418) setdest 2808 26254 13.0" 
$ns at 412.9298492072409 "$node_(419) setdest 55460 9096 5.0" 
$ns at 478.45264810649155 "$node_(419) setdest 11006 40645 9.0" 
$ns at 526.5430014203032 "$node_(419) setdest 1840 20195 4.0" 
$ns at 591.8183299191849 "$node_(419) setdest 96125 41965 4.0" 
$ns at 630.2372640445869 "$node_(419) setdest 66332 39093 16.0" 
$ns at 745.7337086648483 "$node_(419) setdest 94129 9545 11.0" 
$ns at 832.8473585913041 "$node_(419) setdest 10223 16174 10.0" 
$ns at 508.32873282599473 "$node_(420) setdest 14840 36985 5.0" 
$ns at 548.545974684351 "$node_(420) setdest 23326 34690 11.0" 
$ns at 676.2179380977224 "$node_(420) setdest 84755 38850 2.0" 
$ns at 714.5382830363324 "$node_(420) setdest 102612 37352 15.0" 
$ns at 846.4914216903439 "$node_(420) setdest 74336 42747 7.0" 
$ns at 480.38232821515027 "$node_(421) setdest 82671 43536 12.0" 
$ns at 625.4676773865547 "$node_(421) setdest 113246 24893 6.0" 
$ns at 697.9864944724127 "$node_(421) setdest 106348 18719 20.0" 
$ns at 780.8532549930644 "$node_(421) setdest 25948 40919 4.0" 
$ns at 823.5496632236092 "$node_(421) setdest 94624 15600 16.0" 
$ns at 888.0990642281328 "$node_(421) setdest 79195 21821 18.0" 
$ns at 480.6454911819487 "$node_(422) setdest 61724 3447 16.0" 
$ns at 544.1369502350839 "$node_(422) setdest 61733 13800 6.0" 
$ns at 582.3508990202033 "$node_(422) setdest 19630 881 12.0" 
$ns at 646.7942077738746 "$node_(422) setdest 63662 1144 6.0" 
$ns at 705.6651622165874 "$node_(422) setdest 104618 16485 8.0" 
$ns at 752.9985417018314 "$node_(422) setdest 3005 22088 17.0" 
$ns at 497.2459452619795 "$node_(423) setdest 118701 7801 12.0" 
$ns at 635.1215551329572 "$node_(423) setdest 98957 38288 20.0" 
$ns at 691.5766423035175 "$node_(423) setdest 15002 29976 20.0" 
$ns at 891.9496925916076 "$node_(423) setdest 100043 42294 1.0" 
$ns at 421.80881138279483 "$node_(424) setdest 101702 32807 18.0" 
$ns at 513.2393794140644 "$node_(424) setdest 3833 6622 17.0" 
$ns at 574.6146620559754 "$node_(424) setdest 92531 18192 18.0" 
$ns at 702.4298043922203 "$node_(424) setdest 105982 18168 4.0" 
$ns at 734.5297038217491 "$node_(424) setdest 42019 1947 18.0" 
$ns at 844.6291475562512 "$node_(424) setdest 6829 17305 15.0" 
$ns at 411.3364963056603 "$node_(425) setdest 80438 38596 4.0" 
$ns at 445.403695280557 "$node_(425) setdest 22349 39399 8.0" 
$ns at 549.7450234823021 "$node_(425) setdest 123618 11756 13.0" 
$ns at 610.8125551733174 "$node_(425) setdest 87361 1659 9.0" 
$ns at 682.6424454922263 "$node_(425) setdest 51177 21591 1.0" 
$ns at 718.7381078235722 "$node_(425) setdest 128857 8514 2.0" 
$ns at 761.6746511972466 "$node_(425) setdest 36475 9423 1.0" 
$ns at 793.6101407585035 "$node_(425) setdest 77856 29408 15.0" 
$ns at 418.3323177287839 "$node_(426) setdest 89916 22019 7.0" 
$ns at 511.1285472315134 "$node_(426) setdest 102351 20984 6.0" 
$ns at 551.0122798098425 "$node_(426) setdest 120083 40200 19.0" 
$ns at 627.9708981967713 "$node_(426) setdest 23329 43898 3.0" 
$ns at 660.3375387101357 "$node_(426) setdest 118186 39943 3.0" 
$ns at 702.935312027534 "$node_(426) setdest 114943 36152 5.0" 
$ns at 747.2810358572185 "$node_(426) setdest 84054 19413 9.0" 
$ns at 839.1119603929376 "$node_(426) setdest 2688 12059 13.0" 
$ns at 460.46340302629324 "$node_(427) setdest 119887 2423 4.0" 
$ns at 501.6980519809149 "$node_(427) setdest 69658 37517 20.0" 
$ns at 689.8401197846191 "$node_(427) setdest 165 1557 15.0" 
$ns at 852.0602835227751 "$node_(427) setdest 9582 10694 3.0" 
$ns at 897.725835761075 "$node_(427) setdest 55251 24827 15.0" 
$ns at 536.1354493599517 "$node_(428) setdest 120629 44025 4.0" 
$ns at 566.7223331565433 "$node_(428) setdest 126857 835 1.0" 
$ns at 601.8152137925044 "$node_(428) setdest 57439 41230 4.0" 
$ns at 637.6473022049222 "$node_(428) setdest 70163 17672 14.0" 
$ns at 697.5065236986098 "$node_(428) setdest 120677 11442 16.0" 
$ns at 786.39007046706 "$node_(428) setdest 10370 3490 1.0" 
$ns at 818.0736661918079 "$node_(428) setdest 79992 15052 6.0" 
$ns at 433.24652213534375 "$node_(429) setdest 44727 40822 4.0" 
$ns at 467.7645510894547 "$node_(429) setdest 96202 6597 20.0" 
$ns at 673.5489927187123 "$node_(429) setdest 105598 11668 4.0" 
$ns at 718.6955656820985 "$node_(429) setdest 33181 40270 17.0" 
$ns at 875.1495969339584 "$node_(429) setdest 99257 17620 1.0" 
$ns at 415.27468431175504 "$node_(430) setdest 106533 18940 12.0" 
$ns at 479.36440813480857 "$node_(430) setdest 80832 32063 7.0" 
$ns at 574.1737466143738 "$node_(430) setdest 46977 5839 10.0" 
$ns at 688.5303151566162 "$node_(430) setdest 105773 39597 18.0" 
$ns at 741.1783843899109 "$node_(430) setdest 18889 29772 13.0" 
$ns at 790.7873345531383 "$node_(430) setdest 22838 27263 6.0" 
$ns at 855.1437842996224 "$node_(430) setdest 25404 39981 11.0" 
$ns at 422.82176986871815 "$node_(431) setdest 18462 23086 16.0" 
$ns at 611.226500910209 "$node_(431) setdest 24160 32323 15.0" 
$ns at 691.5323810000762 "$node_(431) setdest 93430 35669 17.0" 
$ns at 796.6150920081217 "$node_(431) setdest 74847 10710 12.0" 
$ns at 464.17323045512154 "$node_(432) setdest 8396 25924 19.0" 
$ns at 537.3538903975686 "$node_(432) setdest 95417 16526 12.0" 
$ns at 639.6471962587395 "$node_(432) setdest 65967 21475 8.0" 
$ns at 697.6675427045827 "$node_(432) setdest 38326 7625 14.0" 
$ns at 728.2527297167445 "$node_(432) setdest 128882 41716 17.0" 
$ns at 854.9518669413874 "$node_(432) setdest 1644 25725 15.0" 
$ns at 475.49753768600095 "$node_(433) setdest 60410 22231 13.0" 
$ns at 610.5992414855053 "$node_(433) setdest 130259 17748 17.0" 
$ns at 703.1638473192003 "$node_(433) setdest 13052 11751 12.0" 
$ns at 804.1204836407683 "$node_(433) setdest 11905 9042 10.0" 
$ns at 872.0327151425415 "$node_(433) setdest 65980 19788 13.0" 
$ns at 474.35480527219715 "$node_(434) setdest 114657 43411 7.0" 
$ns at 560.0903033414055 "$node_(434) setdest 36302 39590 16.0" 
$ns at 601.2790369039446 "$node_(434) setdest 9287 7938 7.0" 
$ns at 667.1412805206542 "$node_(434) setdest 120374 26270 3.0" 
$ns at 726.9938941277286 "$node_(434) setdest 120697 21687 14.0" 
$ns at 842.2523860673374 "$node_(434) setdest 97044 23260 3.0" 
$ns at 885.818035419551 "$node_(434) setdest 58996 2152 15.0" 
$ns at 426.248850078641 "$node_(435) setdest 32712 34899 7.0" 
$ns at 461.5165253964159 "$node_(435) setdest 33611 16356 2.0" 
$ns at 508.2576298727192 "$node_(435) setdest 115813 14322 19.0" 
$ns at 564.1853949785174 "$node_(435) setdest 99353 17443 6.0" 
$ns at 601.2823015351624 "$node_(435) setdest 68018 26305 9.0" 
$ns at 653.3861323669303 "$node_(435) setdest 121741 10056 6.0" 
$ns at 697.0954965194775 "$node_(435) setdest 105486 44592 2.0" 
$ns at 736.6567339513333 "$node_(435) setdest 2925 14957 1.0" 
$ns at 769.0201013075314 "$node_(435) setdest 82279 34414 1.0" 
$ns at 799.6286582572922 "$node_(435) setdest 12316 37382 9.0" 
$ns at 877.0981122258298 "$node_(435) setdest 41155 39453 13.0" 
$ns at 433.8089278158058 "$node_(436) setdest 61182 4319 15.0" 
$ns at 564.8114973249797 "$node_(436) setdest 57969 35151 17.0" 
$ns at 756.6912096584654 "$node_(436) setdest 30177 24671 4.0" 
$ns at 798.3338288054055 "$node_(436) setdest 6575 13626 13.0" 
$ns at 892.0037009234082 "$node_(436) setdest 83658 21259 1.0" 
$ns at 515.9849249999843 "$node_(437) setdest 2832 42294 4.0" 
$ns at 555.4237854213645 "$node_(437) setdest 55623 9121 15.0" 
$ns at 667.2314658120371 "$node_(437) setdest 86697 19628 1.0" 
$ns at 706.0189497353327 "$node_(437) setdest 60579 12964 7.0" 
$ns at 763.0489436427459 "$node_(437) setdest 53827 29995 3.0" 
$ns at 805.6069181556556 "$node_(437) setdest 112017 22243 2.0" 
$ns at 835.713187228895 "$node_(437) setdest 76538 29752 10.0" 
$ns at 438.83266919909727 "$node_(438) setdest 74962 17877 3.0" 
$ns at 477.9323290651835 "$node_(438) setdest 22450 40987 14.0" 
$ns at 605.8242510891014 "$node_(438) setdest 37258 7990 19.0" 
$ns at 683.2337081302717 "$node_(438) setdest 99684 35341 11.0" 
$ns at 715.404388392752 "$node_(438) setdest 122784 19199 18.0" 
$ns at 810.7324340217274 "$node_(438) setdest 1750 7949 18.0" 
$ns at 580.9889036813877 "$node_(439) setdest 35151 35834 15.0" 
$ns at 759.4076618886413 "$node_(439) setdest 132430 11478 2.0" 
$ns at 808.7724762767391 "$node_(439) setdest 21305 35289 1.0" 
$ns at 844.4969366280507 "$node_(439) setdest 10198 1803 12.0" 
$ns at 420.32133207227326 "$node_(440) setdest 131467 8114 20.0" 
$ns at 494.4386698385956 "$node_(440) setdest 30158 28406 18.0" 
$ns at 565.8874544593866 "$node_(440) setdest 6780 11996 6.0" 
$ns at 648.6779427324649 "$node_(440) setdest 95445 36340 6.0" 
$ns at 702.4729836198328 "$node_(440) setdest 27200 20411 11.0" 
$ns at 750.6183305985562 "$node_(440) setdest 74611 33606 16.0" 
$ns at 816.6718597111915 "$node_(440) setdest 123241 11175 5.0" 
$ns at 863.3017014077066 "$node_(440) setdest 87446 6257 10.0" 
$ns at 429.9357097371746 "$node_(441) setdest 43869 36841 13.0" 
$ns at 520.661923122029 "$node_(441) setdest 15918 19563 17.0" 
$ns at 677.0590768108658 "$node_(441) setdest 43680 26036 7.0" 
$ns at 750.1391037331939 "$node_(441) setdest 20177 38046 7.0" 
$ns at 838.9301828174216 "$node_(441) setdest 81519 20906 19.0" 
$ns at 454.86032387611067 "$node_(442) setdest 33162 35764 12.0" 
$ns at 495.00721820133276 "$node_(442) setdest 101169 15063 1.0" 
$ns at 526.2008965512989 "$node_(442) setdest 110281 38832 1.0" 
$ns at 561.7145402886795 "$node_(442) setdest 84839 3045 14.0" 
$ns at 701.6183506154116 "$node_(442) setdest 66898 40198 14.0" 
$ns at 825.4875390266612 "$node_(442) setdest 19402 35595 6.0" 
$ns at 858.8067616636445 "$node_(442) setdest 10830 39812 7.0" 
$ns at 898.3903801688089 "$node_(442) setdest 103312 41387 10.0" 
$ns at 489.1432509528776 "$node_(443) setdest 50572 10825 11.0" 
$ns at 581.6554916900545 "$node_(443) setdest 126114 12443 14.0" 
$ns at 749.5923069456708 "$node_(443) setdest 38605 27623 3.0" 
$ns at 786.5122395570909 "$node_(443) setdest 97028 40550 6.0" 
$ns at 846.6674331727065 "$node_(443) setdest 127671 29446 4.0" 
$ns at 898.9243422435036 "$node_(443) setdest 92428 25476 17.0" 
$ns at 476.58332232725587 "$node_(444) setdest 56286 11388 10.0" 
$ns at 518.7893649999322 "$node_(444) setdest 84765 15100 15.0" 
$ns at 582.7340668267591 "$node_(444) setdest 61222 38665 9.0" 
$ns at 621.3774366575636 "$node_(444) setdest 113323 11361 5.0" 
$ns at 686.713380919784 "$node_(444) setdest 60281 30896 6.0" 
$ns at 720.0379816092695 "$node_(444) setdest 89554 17006 8.0" 
$ns at 774.9230068433905 "$node_(444) setdest 1747 40335 9.0" 
$ns at 875.1366326249695 "$node_(444) setdest 64208 10846 8.0" 
$ns at 417.70804977473165 "$node_(445) setdest 106428 15906 7.0" 
$ns at 453.2872321830216 "$node_(445) setdest 43852 6193 4.0" 
$ns at 516.6024430453461 "$node_(445) setdest 84207 35782 3.0" 
$ns at 573.0289263535651 "$node_(445) setdest 73304 25653 12.0" 
$ns at 697.4068085588837 "$node_(445) setdest 3249 4921 9.0" 
$ns at 762.5722912312924 "$node_(445) setdest 104489 9597 1.0" 
$ns at 799.5740117140141 "$node_(445) setdest 94735 6033 13.0" 
$ns at 521.9567473837967 "$node_(446) setdest 116052 39554 17.0" 
$ns at 719.0067490175761 "$node_(446) setdest 78908 11308 7.0" 
$ns at 762.2561886525405 "$node_(446) setdest 4213 2769 19.0" 
$ns at 865.9216191445768 "$node_(446) setdest 122686 29944 19.0" 
$ns at 424.3619191084708 "$node_(447) setdest 133366 40367 9.0" 
$ns at 526.5802697061035 "$node_(447) setdest 20384 40146 1.0" 
$ns at 564.9173536163788 "$node_(447) setdest 110403 43492 10.0" 
$ns at 624.6320013289587 "$node_(447) setdest 117496 41113 3.0" 
$ns at 671.6959650059514 "$node_(447) setdest 13806 17967 4.0" 
$ns at 714.8904099551227 "$node_(447) setdest 46312 15731 10.0" 
$ns at 798.0910112399818 "$node_(447) setdest 7888 44172 1.0" 
$ns at 834.399629667651 "$node_(447) setdest 63691 13498 16.0" 
$ns at 879.5388841763361 "$node_(447) setdest 130860 4301 5.0" 
$ns at 579.826751144963 "$node_(448) setdest 134033 30524 7.0" 
$ns at 668.5607889852802 "$node_(448) setdest 87831 37938 1.0" 
$ns at 701.8323783238392 "$node_(448) setdest 98770 5507 14.0" 
$ns at 808.8757435927897 "$node_(448) setdest 113782 32839 11.0" 
$ns at 438.20405333154935 "$node_(449) setdest 77491 8913 3.0" 
$ns at 494.743889523965 "$node_(449) setdest 54687 32677 4.0" 
$ns at 537.5092786593721 "$node_(449) setdest 41234 5452 9.0" 
$ns at 594.8375323605378 "$node_(449) setdest 105707 32592 9.0" 
$ns at 695.119403969535 "$node_(449) setdest 34985 27306 19.0" 
$ns at 837.7323327170118 "$node_(449) setdest 26170 6209 2.0" 
$ns at 869.1777178914274 "$node_(449) setdest 110277 32727 15.0" 
$ns at 400.7282022561587 "$node_(450) setdest 85617 11642 7.0" 
$ns at 495.9319191921985 "$node_(450) setdest 100806 15222 2.0" 
$ns at 539.8379819113037 "$node_(450) setdest 123930 32856 4.0" 
$ns at 591.63721039068 "$node_(450) setdest 99704 26140 14.0" 
$ns at 698.2005430976637 "$node_(450) setdest 29515 38154 19.0" 
$ns at 825.6032584467453 "$node_(450) setdest 118214 26870 7.0" 
$ns at 882.4386771136969 "$node_(450) setdest 69904 4007 8.0" 
$ns at 402.52904877611667 "$node_(451) setdest 81847 18617 16.0" 
$ns at 563.9036870580671 "$node_(451) setdest 11634 7479 19.0" 
$ns at 734.3714004139676 "$node_(451) setdest 129175 10049 1.0" 
$ns at 766.4759663261101 "$node_(451) setdest 111056 31371 14.0" 
$ns at 466.92907258621733 "$node_(452) setdest 4755 40290 11.0" 
$ns at 591.038415249662 "$node_(452) setdest 78108 21921 8.0" 
$ns at 674.7131672175448 "$node_(452) setdest 52391 9995 19.0" 
$ns at 764.4501902804742 "$node_(452) setdest 121099 35370 12.0" 
$ns at 885.4181849893935 "$node_(452) setdest 47572 20724 5.0" 
$ns at 431.39390489848927 "$node_(453) setdest 93335 1903 6.0" 
$ns at 496.5700466440062 "$node_(453) setdest 9707 29952 3.0" 
$ns at 556.0794817529159 "$node_(453) setdest 103420 28568 18.0" 
$ns at 620.2659498857677 "$node_(453) setdest 64078 29432 1.0" 
$ns at 654.0591006801521 "$node_(453) setdest 55572 4277 6.0" 
$ns at 737.0690563443111 "$node_(453) setdest 99670 8563 6.0" 
$ns at 816.2493843536022 "$node_(453) setdest 34015 8083 18.0" 
$ns at 446.0123248109778 "$node_(454) setdest 94768 38122 8.0" 
$ns at 514.8596782467597 "$node_(454) setdest 47638 26433 17.0" 
$ns at 649.5884996730202 "$node_(454) setdest 17506 87 13.0" 
$ns at 783.6894392370873 "$node_(454) setdest 106178 41366 11.0" 
$ns at 873.131268234158 "$node_(454) setdest 111139 676 5.0" 
$ns at 465.3127227619102 "$node_(455) setdest 76559 20476 13.0" 
$ns at 502.57898851951546 "$node_(455) setdest 38409 24481 6.0" 
$ns at 549.6648817143902 "$node_(455) setdest 130623 26002 10.0" 
$ns at 601.9554578910438 "$node_(455) setdest 90188 14158 2.0" 
$ns at 632.0094079179444 "$node_(455) setdest 11462 39329 6.0" 
$ns at 672.0726662888951 "$node_(455) setdest 83537 7484 2.0" 
$ns at 720.1416033843208 "$node_(455) setdest 16751 31213 5.0" 
$ns at 792.5210443923092 "$node_(455) setdest 52690 21178 3.0" 
$ns at 843.6967864694204 "$node_(455) setdest 14832 29485 1.0" 
$ns at 879.5310757813997 "$node_(455) setdest 18647 11675 10.0" 
$ns at 526.0210857398247 "$node_(456) setdest 105188 1411 12.0" 
$ns at 593.5218165055221 "$node_(456) setdest 57914 9292 5.0" 
$ns at 623.916670064796 "$node_(456) setdest 106021 36498 2.0" 
$ns at 666.1766773265888 "$node_(456) setdest 103910 37811 8.0" 
$ns at 730.64368991741 "$node_(456) setdest 8742 5562 20.0" 
$ns at 812.2040657976107 "$node_(456) setdest 4643 41229 2.0" 
$ns at 856.4432119313337 "$node_(456) setdest 81085 15352 3.0" 
$ns at 898.4809196752127 "$node_(456) setdest 64635 24131 16.0" 
$ns at 490.8717515682514 "$node_(457) setdest 76830 12619 11.0" 
$ns at 602.116488773853 "$node_(457) setdest 52240 38152 18.0" 
$ns at 708.1671904121024 "$node_(457) setdest 5621 22353 1.0" 
$ns at 741.6600672395405 "$node_(457) setdest 92695 19042 8.0" 
$ns at 815.7380018188439 "$node_(457) setdest 18056 40818 4.0" 
$ns at 884.0942414700334 "$node_(457) setdest 100291 1926 1.0" 
$ns at 442.71472106107365 "$node_(458) setdest 123545 16577 18.0" 
$ns at 557.7169776533452 "$node_(458) setdest 108047 15614 11.0" 
$ns at 593.8512851170979 "$node_(458) setdest 54534 40672 11.0" 
$ns at 659.089800308163 "$node_(458) setdest 25422 400 3.0" 
$ns at 710.8561136678164 "$node_(458) setdest 51904 8952 8.0" 
$ns at 756.0107858172477 "$node_(458) setdest 42395 23766 16.0" 
$ns at 852.590112948071 "$node_(458) setdest 9542 7491 12.0" 
$ns at 509.52618594006924 "$node_(459) setdest 51916 2920 4.0" 
$ns at 568.9055822062186 "$node_(459) setdest 51528 28603 14.0" 
$ns at 604.219147762378 "$node_(459) setdest 107752 38368 10.0" 
$ns at 700.5790272090196 "$node_(459) setdest 18944 20701 13.0" 
$ns at 746.5970337473435 "$node_(459) setdest 49290 42632 11.0" 
$ns at 795.5824845321309 "$node_(459) setdest 133090 41937 6.0" 
$ns at 837.6754915477331 "$node_(459) setdest 57041 23233 18.0" 
$ns at 459.772005620387 "$node_(460) setdest 81027 10348 20.0" 
$ns at 520.8285185384017 "$node_(460) setdest 85911 20007 12.0" 
$ns at 582.6415042831162 "$node_(460) setdest 123301 41926 18.0" 
$ns at 784.0674976584118 "$node_(460) setdest 64100 33657 4.0" 
$ns at 827.480874003046 "$node_(460) setdest 130137 22576 17.0" 
$ns at 400.79877723358913 "$node_(461) setdest 125865 12041 16.0" 
$ns at 571.0871703064449 "$node_(461) setdest 37898 1566 1.0" 
$ns at 608.2042822100361 "$node_(461) setdest 89368 32304 1.0" 
$ns at 646.0473567497775 "$node_(461) setdest 39176 16627 19.0" 
$ns at 732.7559778509801 "$node_(461) setdest 78897 11221 7.0" 
$ns at 825.5070207812392 "$node_(461) setdest 33235 17484 4.0" 
$ns at 886.4444120176864 "$node_(461) setdest 63300 31599 17.0" 
$ns at 458.28111930722895 "$node_(462) setdest 32907 33030 12.0" 
$ns at 597.1760236365699 "$node_(462) setdest 4663 10844 8.0" 
$ns at 654.1587167401115 "$node_(462) setdest 98176 3547 15.0" 
$ns at 703.9332845565816 "$node_(462) setdest 5477 43169 18.0" 
$ns at 853.5058917466383 "$node_(462) setdest 133442 27404 12.0" 
$ns at 438.0836269312455 "$node_(463) setdest 34831 27499 2.0" 
$ns at 470.65479617063727 "$node_(463) setdest 34699 38496 6.0" 
$ns at 552.3885266957576 "$node_(463) setdest 69178 5249 1.0" 
$ns at 586.0527459518639 "$node_(463) setdest 123648 42801 7.0" 
$ns at 651.2099395386228 "$node_(463) setdest 81238 12761 17.0" 
$ns at 696.0651470021901 "$node_(463) setdest 77539 24599 4.0" 
$ns at 743.0489242636228 "$node_(463) setdest 16007 17126 5.0" 
$ns at 784.6376114425588 "$node_(463) setdest 44601 36785 5.0" 
$ns at 819.3300380779388 "$node_(463) setdest 50813 5524 8.0" 
$ns at 425.48440237224867 "$node_(464) setdest 36432 36830 5.0" 
$ns at 494.8545687176116 "$node_(464) setdest 44479 24154 14.0" 
$ns at 569.6558169163188 "$node_(464) setdest 84182 34357 15.0" 
$ns at 701.1365810766497 "$node_(464) setdest 25930 13818 2.0" 
$ns at 741.7681288651628 "$node_(464) setdest 120984 9560 1.0" 
$ns at 777.2590447626349 "$node_(464) setdest 116625 39028 17.0" 
$ns at 888.3480565089626 "$node_(464) setdest 55571 35572 5.0" 
$ns at 441.1446206866127 "$node_(465) setdest 50029 16846 16.0" 
$ns at 598.1422116244278 "$node_(465) setdest 54210 29366 6.0" 
$ns at 687.9753355094899 "$node_(465) setdest 54666 34984 12.0" 
$ns at 774.9051162426578 "$node_(465) setdest 43993 12531 5.0" 
$ns at 829.3705993551279 "$node_(465) setdest 79 43477 3.0" 
$ns at 872.2530843775476 "$node_(465) setdest 25695 8790 1.0" 
$ns at 435.066181952059 "$node_(466) setdest 13454 39454 4.0" 
$ns at 496.30818076039634 "$node_(466) setdest 8487 9533 10.0" 
$ns at 533.7732428787215 "$node_(466) setdest 89141 7359 3.0" 
$ns at 564.1115401252291 "$node_(466) setdest 97825 19835 12.0" 
$ns at 596.8517394033553 "$node_(466) setdest 35612 7385 20.0" 
$ns at 670.3226531934931 "$node_(466) setdest 17153 27834 11.0" 
$ns at 728.3816827351824 "$node_(466) setdest 100873 40194 11.0" 
$ns at 864.8078960186301 "$node_(466) setdest 107724 43602 6.0" 
$ns at 404.80374141486345 "$node_(467) setdest 72290 26329 8.0" 
$ns at 465.5665599472164 "$node_(467) setdest 54682 9481 20.0" 
$ns at 571.9364283869882 "$node_(467) setdest 46377 32642 13.0" 
$ns at 608.0323406901655 "$node_(467) setdest 4289 14705 13.0" 
$ns at 735.2831515308541 "$node_(467) setdest 87642 12843 6.0" 
$ns at 784.6053272012781 "$node_(467) setdest 56470 22891 16.0" 
$ns at 817.3281250888623 "$node_(467) setdest 112346 40322 12.0" 
$ns at 860.8475767359938 "$node_(467) setdest 23149 17514 5.0" 
$ns at 893.6443857890988 "$node_(467) setdest 99327 29913 13.0" 
$ns at 570.280259434054 "$node_(468) setdest 12557 27389 11.0" 
$ns at 686.0912348622218 "$node_(468) setdest 72741 21558 9.0" 
$ns at 795.6652459253045 "$node_(468) setdest 103945 12356 11.0" 
$ns at 865.5349262234226 "$node_(468) setdest 29407 9411 15.0" 
$ns at 401.52930790852906 "$node_(469) setdest 80498 31540 1.0" 
$ns at 438.2588342071439 "$node_(469) setdest 106980 36133 18.0" 
$ns at 626.8548858573255 "$node_(469) setdest 59672 16934 7.0" 
$ns at 663.3902888691447 "$node_(469) setdest 55932 27339 16.0" 
$ns at 738.5806025525425 "$node_(469) setdest 37662 7976 17.0" 
$ns at 853.6902223217596 "$node_(469) setdest 118118 26895 18.0" 
$ns at 428.5272576459878 "$node_(470) setdest 133239 24832 17.0" 
$ns at 518.2244253369719 "$node_(470) setdest 58693 36572 18.0" 
$ns at 628.9556882928019 "$node_(470) setdest 23412 42703 10.0" 
$ns at 753.1989951585431 "$node_(470) setdest 125109 34676 14.0" 
$ns at 844.3531539901154 "$node_(470) setdest 63012 34647 16.0" 
$ns at 414.1721073100693 "$node_(471) setdest 62739 2365 9.0" 
$ns at 463.0400178075181 "$node_(471) setdest 90274 23540 12.0" 
$ns at 563.27623563363 "$node_(471) setdest 76901 30571 4.0" 
$ns at 616.4345845454279 "$node_(471) setdest 13902 23092 6.0" 
$ns at 691.6111175664212 "$node_(471) setdest 8659 44016 14.0" 
$ns at 860.731898286773 "$node_(471) setdest 84961 35589 3.0" 
$ns at 898.679749975777 "$node_(471) setdest 16790 8597 10.0" 
$ns at 434.8657362100246 "$node_(472) setdest 87147 7550 19.0" 
$ns at 626.618241236945 "$node_(472) setdest 32436 12895 3.0" 
$ns at 661.2827536661403 "$node_(472) setdest 60215 41011 16.0" 
$ns at 795.9253064494719 "$node_(472) setdest 121458 28620 10.0" 
$ns at 443.52055685841754 "$node_(473) setdest 3690 39625 10.0" 
$ns at 545.4168729527989 "$node_(473) setdest 102707 15783 18.0" 
$ns at 636.0870829959414 "$node_(473) setdest 86722 14752 2.0" 
$ns at 667.3762091175325 "$node_(473) setdest 13370 14233 13.0" 
$ns at 737.827824063994 "$node_(473) setdest 108842 9026 7.0" 
$ns at 807.6050668564014 "$node_(473) setdest 70395 44091 9.0" 
$ns at 887.5604285466278 "$node_(473) setdest 52896 30197 11.0" 
$ns at 403.3527800597793 "$node_(474) setdest 126226 34631 20.0" 
$ns at 595.8698748572003 "$node_(474) setdest 62451 3888 4.0" 
$ns at 631.2680192238001 "$node_(474) setdest 47637 9663 13.0" 
$ns at 753.4210458610693 "$node_(474) setdest 42558 33635 19.0" 
$ns at 880.116829502866 "$node_(474) setdest 96759 31375 14.0" 
$ns at 466.21920142139095 "$node_(475) setdest 82533 35278 4.0" 
$ns at 526.4580747372015 "$node_(475) setdest 131390 26334 1.0" 
$ns at 558.6418960088865 "$node_(475) setdest 75535 11870 8.0" 
$ns at 602.7242441213285 "$node_(475) setdest 119089 10267 12.0" 
$ns at 651.1671193500009 "$node_(475) setdest 7982 20263 9.0" 
$ns at 725.4452548769565 "$node_(475) setdest 7790 15252 11.0" 
$ns at 793.5691089669949 "$node_(475) setdest 85448 41935 9.0" 
$ns at 402.9734859001321 "$node_(476) setdest 94104 32110 14.0" 
$ns at 440.8458759445062 "$node_(476) setdest 66627 8216 1.0" 
$ns at 480.5467274714772 "$node_(476) setdest 13071 40484 1.0" 
$ns at 514.6656221752868 "$node_(476) setdest 63949 2763 14.0" 
$ns at 629.1350329707644 "$node_(476) setdest 120325 31039 9.0" 
$ns at 709.5781623757537 "$node_(476) setdest 36801 44344 1.0" 
$ns at 745.3134045102361 "$node_(476) setdest 27173 25357 1.0" 
$ns at 779.6201969162357 "$node_(476) setdest 695 23909 17.0" 
$ns at 401.38011118297567 "$node_(477) setdest 96174 24650 13.0" 
$ns at 467.7342574801222 "$node_(477) setdest 55193 19868 2.0" 
$ns at 499.0693738125659 "$node_(477) setdest 9156 9461 4.0" 
$ns at 544.4174855666829 "$node_(477) setdest 72157 44574 14.0" 
$ns at 631.4534310617723 "$node_(477) setdest 1957 24737 9.0" 
$ns at 728.3869748157454 "$node_(477) setdest 110371 15889 3.0" 
$ns at 779.4349081754949 "$node_(477) setdest 1370 3232 10.0" 
$ns at 823.6646881430989 "$node_(477) setdest 29756 30412 16.0" 
$ns at 429.38247006122947 "$node_(478) setdest 47707 1705 12.0" 
$ns at 466.3666692498825 "$node_(478) setdest 106448 22695 9.0" 
$ns at 509.45543702948186 "$node_(478) setdest 61769 21923 16.0" 
$ns at 623.2161840652374 "$node_(478) setdest 27888 2005 3.0" 
$ns at 678.9543638628461 "$node_(478) setdest 34573 6067 3.0" 
$ns at 721.6086702166727 "$node_(478) setdest 19866 23362 14.0" 
$ns at 779.0755753150247 "$node_(478) setdest 45989 43189 11.0" 
$ns at 850.2919950360447 "$node_(478) setdest 101349 29461 2.0" 
$ns at 891.791594501197 "$node_(478) setdest 51278 10926 9.0" 
$ns at 482.29279377994413 "$node_(479) setdest 133149 457 19.0" 
$ns at 692.2715268135586 "$node_(479) setdest 43718 25428 12.0" 
$ns at 837.4596780923059 "$node_(479) setdest 34759 8121 15.0" 
$ns at 454.30287439170286 "$node_(480) setdest 114578 15877 11.0" 
$ns at 588.3854687723905 "$node_(480) setdest 51679 35674 6.0" 
$ns at 621.6334187819673 "$node_(480) setdest 96724 15068 8.0" 
$ns at 693.1539462581472 "$node_(480) setdest 26310 13218 15.0" 
$ns at 776.7706475072655 "$node_(480) setdest 114030 37237 6.0" 
$ns at 821.4814130088905 "$node_(480) setdest 91857 29161 13.0" 
$ns at 422.5602173472249 "$node_(481) setdest 77445 10804 5.0" 
$ns at 492.12608141943645 "$node_(481) setdest 28595 33730 19.0" 
$ns at 544.2777209991185 "$node_(481) setdest 908 26334 8.0" 
$ns at 599.3000261075123 "$node_(481) setdest 95368 25556 11.0" 
$ns at 733.0739466350562 "$node_(481) setdest 2840 38240 10.0" 
$ns at 861.4990183914066 "$node_(481) setdest 126189 33173 7.0" 
$ns at 498.4287504190707 "$node_(482) setdest 61271 3548 4.0" 
$ns at 539.133676903947 "$node_(482) setdest 21407 4264 13.0" 
$ns at 629.976476700807 "$node_(482) setdest 58969 32226 11.0" 
$ns at 669.0310095273433 "$node_(482) setdest 29897 24193 12.0" 
$ns at 742.1798802315775 "$node_(482) setdest 87317 17281 19.0" 
$ns at 827.0764107671932 "$node_(482) setdest 121239 4531 8.0" 
$ns at 430.083284132 "$node_(483) setdest 120841 36846 8.0" 
$ns at 462.13338889435596 "$node_(483) setdest 21112 30044 2.0" 
$ns at 508.09181197898505 "$node_(483) setdest 65562 17324 2.0" 
$ns at 538.7020141453798 "$node_(483) setdest 106278 24084 7.0" 
$ns at 588.1876254930868 "$node_(483) setdest 119325 2224 3.0" 
$ns at 622.4489556821952 "$node_(483) setdest 8526 43992 13.0" 
$ns at 741.522105726984 "$node_(483) setdest 82767 6049 1.0" 
$ns at 780.9916337845742 "$node_(483) setdest 74947 43774 15.0" 
$ns at 506.88628147713143 "$node_(484) setdest 125753 31312 12.0" 
$ns at 551.4790172889179 "$node_(484) setdest 107006 535 18.0" 
$ns at 603.9531627466401 "$node_(484) setdest 89131 31224 14.0" 
$ns at 727.3826757410748 "$node_(484) setdest 123285 10488 10.0" 
$ns at 791.7804963759784 "$node_(484) setdest 122083 21440 5.0" 
$ns at 843.7851199524715 "$node_(484) setdest 22353 40795 16.0" 
$ns at 400.2236129320461 "$node_(485) setdest 15022 24637 9.0" 
$ns at 481.9333453080512 "$node_(485) setdest 6662 11617 12.0" 
$ns at 567.5214069301772 "$node_(485) setdest 65561 21561 4.0" 
$ns at 620.7823845902428 "$node_(485) setdest 78262 16833 17.0" 
$ns at 759.9731780554521 "$node_(485) setdest 103830 29189 17.0" 
$ns at 792.252215939997 "$node_(485) setdest 57458 12967 14.0" 
$ns at 831.1184509104147 "$node_(485) setdest 129203 29746 6.0" 
$ns at 426.18099472792665 "$node_(486) setdest 44903 7068 13.0" 
$ns at 467.02895221386063 "$node_(486) setdest 105172 29129 2.0" 
$ns at 497.5592103456425 "$node_(486) setdest 54510 42548 1.0" 
$ns at 530.031120120835 "$node_(486) setdest 90606 17375 20.0" 
$ns at 613.5393396012558 "$node_(486) setdest 13110 1817 7.0" 
$ns at 651.2802981205072 "$node_(486) setdest 113734 43597 2.0" 
$ns at 700.4180381476192 "$node_(486) setdest 66358 1220 6.0" 
$ns at 776.1540927012879 "$node_(486) setdest 20038 19081 9.0" 
$ns at 861.3395484214498 "$node_(486) setdest 61197 18966 17.0" 
$ns at 440.8043059154139 "$node_(487) setdest 6303 12162 15.0" 
$ns at 615.0594318251563 "$node_(487) setdest 44337 11353 1.0" 
$ns at 647.7349844767125 "$node_(487) setdest 9086 22342 16.0" 
$ns at 747.1391146061334 "$node_(487) setdest 104316 26583 5.0" 
$ns at 794.4363086701595 "$node_(487) setdest 103242 35475 16.0" 
$ns at 434.08824742762874 "$node_(488) setdest 102595 24750 10.0" 
$ns at 522.0587780172424 "$node_(488) setdest 10058 5799 20.0" 
$ns at 699.8995125304152 "$node_(488) setdest 54951 44466 1.0" 
$ns at 737.4906270992982 "$node_(488) setdest 49702 22345 15.0" 
$ns at 855.5018001035334 "$node_(488) setdest 26128 9000 14.0" 
$ns at 892.1157118162348 "$node_(488) setdest 80495 24527 2.0" 
$ns at 460.3127420178979 "$node_(489) setdest 39177 2442 11.0" 
$ns at 493.07917403021185 "$node_(489) setdest 11500 28316 15.0" 
$ns at 629.447873820544 "$node_(489) setdest 132725 40504 9.0" 
$ns at 734.2300667750743 "$node_(489) setdest 42326 9234 15.0" 
$ns at 836.6584325319047 "$node_(489) setdest 58782 5111 10.0" 
$ns at 895.2821482820319 "$node_(489) setdest 105663 40201 4.0" 
$ns at 442.9656737736907 "$node_(490) setdest 8922 31366 11.0" 
$ns at 529.428084925572 "$node_(490) setdest 4899 30330 18.0" 
$ns at 708.0699072828007 "$node_(490) setdest 48880 4935 15.0" 
$ns at 839.4346640242252 "$node_(490) setdest 27471 11845 6.0" 
$ns at 870.4203178721432 "$node_(490) setdest 42562 24282 4.0" 
$ns at 463.9752080810705 "$node_(491) setdest 98349 7035 10.0" 
$ns at 566.8756581154072 "$node_(491) setdest 113508 8559 10.0" 
$ns at 674.8276289144605 "$node_(491) setdest 20464 41430 1.0" 
$ns at 704.9930749469352 "$node_(491) setdest 38884 10950 14.0" 
$ns at 858.4376554400549 "$node_(491) setdest 58296 41224 2.0" 
$ns at 897.7979266812675 "$node_(491) setdest 32695 21252 16.0" 
$ns at 401.41731789899274 "$node_(492) setdest 125530 28344 7.0" 
$ns at 452.2281124486944 "$node_(492) setdest 127523 15421 5.0" 
$ns at 525.0781349977113 "$node_(492) setdest 131495 20065 19.0" 
$ns at 607.7026484595956 "$node_(492) setdest 116936 19940 11.0" 
$ns at 746.9321078482205 "$node_(492) setdest 3071 5972 5.0" 
$ns at 806.6431357804985 "$node_(492) setdest 95544 41451 13.0" 
$ns at 879.7752524397207 "$node_(492) setdest 70795 5946 10.0" 
$ns at 436.18434016869026 "$node_(493) setdest 30976 25823 17.0" 
$ns at 524.6014614948808 "$node_(493) setdest 65906 32054 3.0" 
$ns at 562.8178026788851 "$node_(493) setdest 51011 30029 12.0" 
$ns at 655.5641936686284 "$node_(493) setdest 102249 3970 3.0" 
$ns at 706.7904249820763 "$node_(493) setdest 133949 26356 16.0" 
$ns at 776.1511075697979 "$node_(493) setdest 28539 30850 20.0" 
$ns at 452.946589865921 "$node_(494) setdest 98725 14583 16.0" 
$ns at 625.1200208916149 "$node_(494) setdest 129884 29908 1.0" 
$ns at 663.524315284583 "$node_(494) setdest 86062 23908 10.0" 
$ns at 778.4770426339275 "$node_(494) setdest 29321 2006 3.0" 
$ns at 809.0262857163542 "$node_(494) setdest 71549 1220 17.0" 
$ns at 425.20124700636256 "$node_(495) setdest 116829 39560 13.0" 
$ns at 526.2121466678885 "$node_(495) setdest 6009 36155 20.0" 
$ns at 719.4024943401006 "$node_(495) setdest 121101 41137 2.0" 
$ns at 754.2840473284809 "$node_(495) setdest 62335 15440 14.0" 
$ns at 450.03244230659413 "$node_(496) setdest 10991 24764 9.0" 
$ns at 534.876794420379 "$node_(496) setdest 21730 17544 8.0" 
$ns at 615.926238878865 "$node_(496) setdest 50137 19605 7.0" 
$ns at 653.1603559868934 "$node_(496) setdest 93977 22627 6.0" 
$ns at 702.3316406853951 "$node_(496) setdest 131289 32010 7.0" 
$ns at 767.832708970619 "$node_(496) setdest 3078 29572 19.0" 
$ns at 571.4759840772797 "$node_(497) setdest 42711 39451 17.0" 
$ns at 723.3959810866456 "$node_(497) setdest 13991 22983 5.0" 
$ns at 799.8472205565981 "$node_(497) setdest 100894 43269 6.0" 
$ns at 886.8980064792536 "$node_(497) setdest 57533 38435 3.0" 
$ns at 419.10986854526493 "$node_(498) setdest 102533 24884 14.0" 
$ns at 564.3402791778187 "$node_(498) setdest 96116 14658 2.0" 
$ns at 608.8297134442696 "$node_(498) setdest 130940 29184 4.0" 
$ns at 652.6619085614255 "$node_(498) setdest 109245 20544 3.0" 
$ns at 698.923231462678 "$node_(498) setdest 53371 12491 12.0" 
$ns at 791.8222920637173 "$node_(498) setdest 115855 12731 7.0" 
$ns at 841.8000562556786 "$node_(498) setdest 38801 30831 9.0" 
$ns at 423.66676109211 "$node_(499) setdest 113761 20186 7.0" 
$ns at 506.3314455996958 "$node_(499) setdest 52696 7243 1.0" 
$ns at 544.4208607487687 "$node_(499) setdest 93303 42255 17.0" 
$ns at 581.9740397282935 "$node_(499) setdest 92748 3838 14.0" 
$ns at 735.1874259141625 "$node_(499) setdest 120568 146 18.0" 
$ns at 851.40809645801 "$node_(499) setdest 17126 43444 4.0" 
$ns at 898.7676046824284 "$node_(499) setdest 117072 8325 13.0" 
$ns at 534.8596889815525 "$node_(500) setdest 83379 10391 3.0" 
$ns at 590.3111553176025 "$node_(500) setdest 10123 39217 17.0" 
$ns at 758.8611453583021 "$node_(500) setdest 28757 7927 2.0" 
$ns at 796.3451884881212 "$node_(500) setdest 56463 24707 7.0" 
$ns at 886.1272254042387 "$node_(500) setdest 124900 6250 12.0" 
$ns at 511.5990371069209 "$node_(501) setdest 16722 6840 12.0" 
$ns at 592.1952424553956 "$node_(501) setdest 128851 27824 4.0" 
$ns at 631.3966534769431 "$node_(501) setdest 124864 19475 10.0" 
$ns at 751.2885773808772 "$node_(501) setdest 32144 10797 5.0" 
$ns at 784.8454842179111 "$node_(501) setdest 68225 36138 16.0" 
$ns at 866.2992823381503 "$node_(501) setdest 6477 26964 11.0" 
$ns at 506.4583654185581 "$node_(502) setdest 51557 17876 14.0" 
$ns at 595.7976443505961 "$node_(502) setdest 130197 43989 11.0" 
$ns at 672.171011792942 "$node_(502) setdest 9483 3708 13.0" 
$ns at 710.0211009642181 "$node_(502) setdest 58713 26334 12.0" 
$ns at 772.4276827588662 "$node_(502) setdest 107849 36367 1.0" 
$ns at 806.7209556162157 "$node_(502) setdest 51310 27613 17.0" 
$ns at 507.7235628709175 "$node_(503) setdest 120726 39578 1.0" 
$ns at 547.0159448582002 "$node_(503) setdest 95956 14624 5.0" 
$ns at 577.410027998586 "$node_(503) setdest 88344 42161 7.0" 
$ns at 660.8518967906575 "$node_(503) setdest 123703 23106 6.0" 
$ns at 744.7043830352147 "$node_(503) setdest 15632 27043 12.0" 
$ns at 870.7147747797358 "$node_(503) setdest 93923 36010 9.0" 
$ns at 560.0301092640133 "$node_(504) setdest 128162 22609 7.0" 
$ns at 606.0509429340512 "$node_(504) setdest 8533 23154 3.0" 
$ns at 666.0390741193195 "$node_(504) setdest 77591 3963 19.0" 
$ns at 750.2112963677503 "$node_(504) setdest 120123 28948 20.0" 
$ns at 831.6362435192939 "$node_(504) setdest 41287 20755 5.0" 
$ns at 876.1908363030582 "$node_(504) setdest 85524 18883 16.0" 
$ns at 549.7252398939337 "$node_(505) setdest 87372 19632 3.0" 
$ns at 601.656841258899 "$node_(505) setdest 86187 12322 1.0" 
$ns at 639.3248547625265 "$node_(505) setdest 81705 32264 14.0" 
$ns at 696.3049747008889 "$node_(505) setdest 58480 4032 2.0" 
$ns at 738.5913877303045 "$node_(505) setdest 61174 22706 16.0" 
$ns at 795.451945117482 "$node_(505) setdest 10737 6506 16.0" 
$ns at 509.31375369196076 "$node_(506) setdest 1579 12173 16.0" 
$ns at 588.4690356794432 "$node_(506) setdest 69872 24803 1.0" 
$ns at 628.132451227173 "$node_(506) setdest 117203 29705 2.0" 
$ns at 663.9911497533066 "$node_(506) setdest 49700 40060 9.0" 
$ns at 715.8092247698565 "$node_(506) setdest 87534 12528 14.0" 
$ns at 753.9593651860107 "$node_(506) setdest 94359 4576 15.0" 
$ns at 897.1371529842679 "$node_(506) setdest 64044 27672 6.0" 
$ns at 500.2385351637883 "$node_(507) setdest 125272 29076 18.0" 
$ns at 591.1819680329518 "$node_(507) setdest 100343 24564 10.0" 
$ns at 623.1515829635044 "$node_(507) setdest 99185 38835 11.0" 
$ns at 680.7344914628834 "$node_(507) setdest 112404 36470 19.0" 
$ns at 804.3683684647438 "$node_(507) setdest 69018 18298 19.0" 
$ns at 510.5902398300322 "$node_(508) setdest 4589 29592 13.0" 
$ns at 553.7027113207677 "$node_(508) setdest 74420 38460 20.0" 
$ns at 735.6908379552673 "$node_(508) setdest 96551 19357 12.0" 
$ns at 851.8447271115414 "$node_(508) setdest 74734 38085 1.0" 
$ns at 888.2006217958275 "$node_(508) setdest 87589 25320 1.0" 
$ns at 605.4445171233585 "$node_(509) setdest 89263 34972 14.0" 
$ns at 735.776959606259 "$node_(509) setdest 30687 18117 12.0" 
$ns at 852.8014451242112 "$node_(509) setdest 126747 27170 17.0" 
$ns at 890.6028685831436 "$node_(509) setdest 101384 32520 17.0" 
$ns at 516.9576988784175 "$node_(510) setdest 83208 39340 16.0" 
$ns at 690.1684707511737 "$node_(510) setdest 15167 23004 18.0" 
$ns at 780.4826623537774 "$node_(510) setdest 47366 20659 11.0" 
$ns at 872.0273129492005 "$node_(510) setdest 128410 32426 9.0" 
$ns at 514.6399435145515 "$node_(511) setdest 36043 18913 10.0" 
$ns at 632.0206083778822 "$node_(511) setdest 45881 29527 3.0" 
$ns at 691.6907109958593 "$node_(511) setdest 199 44324 6.0" 
$ns at 753.0994879227766 "$node_(511) setdest 96805 16160 8.0" 
$ns at 814.2624859597817 "$node_(511) setdest 24568 18364 6.0" 
$ns at 880.013229923567 "$node_(511) setdest 107832 11626 9.0" 
$ns at 504.6486949497653 "$node_(512) setdest 77118 35930 13.0" 
$ns at 589.4198899635601 "$node_(512) setdest 23914 25866 17.0" 
$ns at 752.4843253572652 "$node_(512) setdest 97321 11091 12.0" 
$ns at 515.7493438327549 "$node_(513) setdest 14587 41944 15.0" 
$ns at 607.5918810679775 "$node_(513) setdest 13750 449 3.0" 
$ns at 664.725084495359 "$node_(513) setdest 18314 23318 1.0" 
$ns at 699.0763637658131 "$node_(513) setdest 120783 34292 20.0" 
$ns at 531.5338349339356 "$node_(514) setdest 86028 16032 6.0" 
$ns at 593.3524372616594 "$node_(514) setdest 60686 15915 9.0" 
$ns at 625.9456435558606 "$node_(514) setdest 13617 3574 9.0" 
$ns at 706.5263479092484 "$node_(514) setdest 129911 1697 5.0" 
$ns at 746.4360615050881 "$node_(514) setdest 124147 16610 1.0" 
$ns at 786.2523097280078 "$node_(514) setdest 98924 38003 20.0" 
$ns at 568.3455580364413 "$node_(515) setdest 96512 7140 12.0" 
$ns at 680.2102959823372 "$node_(515) setdest 90452 25863 11.0" 
$ns at 807.151624564649 "$node_(515) setdest 10854 23056 16.0" 
$ns at 534.9628257386211 "$node_(516) setdest 106166 2595 19.0" 
$ns at 590.8836717974458 "$node_(516) setdest 131388 29531 3.0" 
$ns at 646.517460117344 "$node_(516) setdest 80716 21192 4.0" 
$ns at 715.9607961085767 "$node_(516) setdest 25245 25409 13.0" 
$ns at 854.875749290233 "$node_(516) setdest 3713 35602 19.0" 
$ns at 584.9914673535407 "$node_(517) setdest 7804 16275 7.0" 
$ns at 659.2403305712538 "$node_(517) setdest 6111 17803 10.0" 
$ns at 721.9327500382302 "$node_(517) setdest 79906 744 19.0" 
$ns at 837.3574194086691 "$node_(517) setdest 23346 21100 19.0" 
$ns at 896.1495931712805 "$node_(517) setdest 5739 33128 7.0" 
$ns at 541.6244710868442 "$node_(518) setdest 132986 27911 17.0" 
$ns at 595.668712200099 "$node_(518) setdest 5572 11664 8.0" 
$ns at 695.3900875720212 "$node_(518) setdest 64780 16461 20.0" 
$ns at 739.4833309629869 "$node_(518) setdest 97759 20217 18.0" 
$ns at 858.1820400383839 "$node_(518) setdest 130881 2954 2.0" 
$ns at 888.9188794921834 "$node_(518) setdest 120676 2061 11.0" 
$ns at 556.474982382053 "$node_(519) setdest 127550 26487 19.0" 
$ns at 587.9974365201218 "$node_(519) setdest 5162 10650 14.0" 
$ns at 755.029730059259 "$node_(519) setdest 84918 11126 18.0" 
$ns at 803.8126255952565 "$node_(519) setdest 56343 10109 7.0" 
$ns at 861.4012076231576 "$node_(519) setdest 47813 32188 8.0" 
$ns at 591.9157712857537 "$node_(520) setdest 924 10277 7.0" 
$ns at 686.8009943799153 "$node_(520) setdest 102584 7539 14.0" 
$ns at 803.7018133288327 "$node_(520) setdest 109183 35883 14.0" 
$ns at 895.9791768680032 "$node_(520) setdest 60769 17806 6.0" 
$ns at 516.4280169441496 "$node_(521) setdest 82320 29494 1.0" 
$ns at 552.1274669237438 "$node_(521) setdest 6145 20146 16.0" 
$ns at 714.433122922539 "$node_(521) setdest 111387 13672 2.0" 
$ns at 756.8508088315954 "$node_(521) setdest 20837 4926 13.0" 
$ns at 818.1078090159338 "$node_(521) setdest 2759 13303 6.0" 
$ns at 853.0831064550125 "$node_(521) setdest 90382 8293 9.0" 
$ns at 519.9445691399142 "$node_(522) setdest 75737 19109 20.0" 
$ns at 720.7057559157518 "$node_(522) setdest 45629 26587 18.0" 
$ns at 757.3002093247904 "$node_(522) setdest 116345 17908 18.0" 
$ns at 830.0842860115764 "$node_(522) setdest 71393 10490 14.0" 
$ns at 589.167470404338 "$node_(523) setdest 116680 13560 19.0" 
$ns at 708.7641262639695 "$node_(523) setdest 9094 31014 15.0" 
$ns at 876.3607215670949 "$node_(523) setdest 42109 7147 7.0" 
$ns at 523.3011128211286 "$node_(524) setdest 32593 5080 10.0" 
$ns at 622.2264175167322 "$node_(524) setdest 104066 25181 18.0" 
$ns at 747.6265550669597 "$node_(524) setdest 121605 19891 4.0" 
$ns at 811.9760529820454 "$node_(524) setdest 37835 13438 6.0" 
$ns at 886.104350774157 "$node_(524) setdest 36698 12536 11.0" 
$ns at 535.7979842209211 "$node_(525) setdest 48785 5333 3.0" 
$ns at 566.2363256498483 "$node_(525) setdest 103569 41743 4.0" 
$ns at 618.3627208422045 "$node_(525) setdest 2547 27499 12.0" 
$ns at 677.7700839441407 "$node_(525) setdest 70017 27375 12.0" 
$ns at 775.274776863535 "$node_(525) setdest 62459 25562 16.0" 
$ns at 840.296587542959 "$node_(525) setdest 129963 17994 9.0" 
$ns at 548.8788683856596 "$node_(526) setdest 91696 19987 8.0" 
$ns at 644.5388824995322 "$node_(526) setdest 56542 7733 3.0" 
$ns at 685.391302905349 "$node_(526) setdest 11354 39442 2.0" 
$ns at 722.3584619379535 "$node_(526) setdest 65257 17353 16.0" 
$ns at 811.9996815506557 "$node_(526) setdest 19954 15622 8.0" 
$ns at 881.9436386822995 "$node_(526) setdest 91114 13792 17.0" 
$ns at 509.2444753007684 "$node_(527) setdest 13333 42913 3.0" 
$ns at 553.0538694202048 "$node_(527) setdest 30724 15046 6.0" 
$ns at 599.8083184605639 "$node_(527) setdest 96503 23143 10.0" 
$ns at 639.1075737700623 "$node_(527) setdest 62849 14069 2.0" 
$ns at 687.45579519501 "$node_(527) setdest 38926 32730 1.0" 
$ns at 718.9825373243949 "$node_(527) setdest 131938 31787 2.0" 
$ns at 766.4873946657652 "$node_(527) setdest 41804 14447 1.0" 
$ns at 799.0197392085163 "$node_(527) setdest 122098 23233 8.0" 
$ns at 829.6778223175396 "$node_(527) setdest 124654 26259 7.0" 
$ns at 883.7271292903687 "$node_(527) setdest 122099 29798 12.0" 
$ns at 528.2085865558165 "$node_(528) setdest 72467 23867 14.0" 
$ns at 566.3506844675325 "$node_(528) setdest 126344 6784 11.0" 
$ns at 645.2973245536923 "$node_(528) setdest 86697 23379 14.0" 
$ns at 771.1492022853797 "$node_(528) setdest 67266 23094 15.0" 
$ns at 850.9468783246502 "$node_(528) setdest 67504 32462 9.0" 
$ns at 522.6246629650525 "$node_(529) setdest 113326 19219 2.0" 
$ns at 557.4904302092639 "$node_(529) setdest 97616 2150 9.0" 
$ns at 632.6581089521978 "$node_(529) setdest 17138 26171 18.0" 
$ns at 735.2598005506175 "$node_(529) setdest 83677 19478 1.0" 
$ns at 771.544488132051 "$node_(529) setdest 116327 18280 13.0" 
$ns at 879.2766175392057 "$node_(529) setdest 63945 2161 1.0" 
$ns at 636.4458500241835 "$node_(530) setdest 39484 13707 6.0" 
$ns at 697.7326159699121 "$node_(530) setdest 80861 28013 5.0" 
$ns at 727.8036185563092 "$node_(530) setdest 76294 31647 15.0" 
$ns at 798.4913544200678 "$node_(530) setdest 101722 22216 10.0" 
$ns at 831.9702398006239 "$node_(530) setdest 83340 9459 6.0" 
$ns at 685.8645884248158 "$node_(531) setdest 22888 31555 7.0" 
$ns at 735.4681276290298 "$node_(531) setdest 60786 31489 16.0" 
$ns at 843.6292021159389 "$node_(531) setdest 74449 24162 13.0" 
$ns at 623.2414719279599 "$node_(532) setdest 38304 17990 14.0" 
$ns at 690.4417411716568 "$node_(532) setdest 23981 17457 9.0" 
$ns at 789.6865221721326 "$node_(532) setdest 59163 11531 9.0" 
$ns at 889.8760273354329 "$node_(532) setdest 65447 42554 15.0" 
$ns at 598.4876502948551 "$node_(533) setdest 96527 32449 8.0" 
$ns at 643.4347463306705 "$node_(533) setdest 60506 4357 20.0" 
$ns at 739.6252333302602 "$node_(533) setdest 95543 25271 13.0" 
$ns at 860.5164743667973 "$node_(533) setdest 107580 7516 2.0" 
$ns at 898.8735518048911 "$node_(533) setdest 127144 29180 5.0" 
$ns at 529.0805647723985 "$node_(534) setdest 125005 3151 11.0" 
$ns at 592.9701134172684 "$node_(534) setdest 24164 11806 1.0" 
$ns at 630.7260678109973 "$node_(534) setdest 66812 30821 6.0" 
$ns at 686.774620606636 "$node_(534) setdest 50734 34760 14.0" 
$ns at 742.2265131520319 "$node_(534) setdest 65148 5392 6.0" 
$ns at 827.9913565536631 "$node_(534) setdest 78134 39371 11.0" 
$ns at 869.0672755651862 "$node_(534) setdest 22845 20728 12.0" 
$ns at 540.5615722353785 "$node_(535) setdest 26584 4635 4.0" 
$ns at 596.9822401043689 "$node_(535) setdest 119646 19516 1.0" 
$ns at 628.4575722518895 "$node_(535) setdest 11294 28850 11.0" 
$ns at 699.436071688572 "$node_(535) setdest 41171 24997 19.0" 
$ns at 524.1256879269031 "$node_(536) setdest 83237 5648 8.0" 
$ns at 570.5170235244904 "$node_(536) setdest 38619 2460 6.0" 
$ns at 624.0116128163888 "$node_(536) setdest 94492 43673 20.0" 
$ns at 738.7590694351662 "$node_(536) setdest 16858 9317 15.0" 
$ns at 789.9046660303796 "$node_(536) setdest 101348 30774 6.0" 
$ns at 833.8748259282594 "$node_(536) setdest 57757 5297 13.0" 
$ns at 563.9097898157747 "$node_(537) setdest 46956 6621 2.0" 
$ns at 610.4006756653295 "$node_(537) setdest 131544 41723 13.0" 
$ns at 743.8191672196978 "$node_(537) setdest 22605 1796 16.0" 
$ns at 605.7157457248954 "$node_(538) setdest 92943 26505 19.0" 
$ns at 753.5672057380054 "$node_(538) setdest 16494 27317 11.0" 
$ns at 847.5843292826142 "$node_(538) setdest 105597 39792 19.0" 
$ns at 541.8153778091391 "$node_(539) setdest 111351 18745 4.0" 
$ns at 589.1645503605232 "$node_(539) setdest 26939 18070 8.0" 
$ns at 649.7177188988724 "$node_(539) setdest 95481 30516 7.0" 
$ns at 710.3895094070638 "$node_(539) setdest 20218 2036 3.0" 
$ns at 762.2544833075269 "$node_(539) setdest 109619 1491 13.0" 
$ns at 842.8746433763903 "$node_(539) setdest 104803 26243 16.0" 
$ns at 890.9255330742185 "$node_(539) setdest 31650 27015 16.0" 
$ns at 528.1558988298415 "$node_(540) setdest 47629 37133 16.0" 
$ns at 573.8823869162662 "$node_(540) setdest 74405 7520 6.0" 
$ns at 605.647892014364 "$node_(540) setdest 91615 20016 8.0" 
$ns at 646.9471846717697 "$node_(540) setdest 53749 42450 2.0" 
$ns at 687.7586839534996 "$node_(540) setdest 125986 40060 16.0" 
$ns at 850.8170094445052 "$node_(540) setdest 86109 33126 17.0" 
$ns at 540.3893973555575 "$node_(541) setdest 107642 22770 1.0" 
$ns at 576.6460592757163 "$node_(541) setdest 79547 21486 9.0" 
$ns at 680.0234170774577 "$node_(541) setdest 106064 15129 5.0" 
$ns at 748.1641163188103 "$node_(541) setdest 54657 19155 14.0" 
$ns at 566.5939880645843 "$node_(542) setdest 2813 33498 14.0" 
$ns at 703.0003305206724 "$node_(542) setdest 97157 39691 1.0" 
$ns at 738.1410588441242 "$node_(542) setdest 121322 19295 18.0" 
$ns at 539.2709493949693 "$node_(543) setdest 117227 17579 3.0" 
$ns at 571.3890612320056 "$node_(543) setdest 92470 26609 11.0" 
$ns at 711.1861029943198 "$node_(543) setdest 127456 32205 18.0" 
$ns at 765.8284580491929 "$node_(543) setdest 101507 33624 1.0" 
$ns at 804.8642484494486 "$node_(543) setdest 43698 31159 2.0" 
$ns at 851.2099815544282 "$node_(543) setdest 38595 26123 4.0" 
$ns at 596.8713584212426 "$node_(544) setdest 44479 18207 2.0" 
$ns at 639.9366820605823 "$node_(544) setdest 49004 41867 12.0" 
$ns at 736.1295783200313 "$node_(544) setdest 53296 10549 5.0" 
$ns at 770.286927573268 "$node_(544) setdest 23635 7559 8.0" 
$ns at 839.857822715268 "$node_(544) setdest 125585 8059 2.0" 
$ns at 881.8295137870073 "$node_(544) setdest 60541 631 6.0" 
$ns at 530.042288393503 "$node_(545) setdest 14518 41526 2.0" 
$ns at 563.9367538733405 "$node_(545) setdest 21261 16538 10.0" 
$ns at 674.342469648343 "$node_(545) setdest 91624 42066 3.0" 
$ns at 729.2470050634317 "$node_(545) setdest 88849 33587 19.0" 
$ns at 777.3747911079861 "$node_(545) setdest 61514 40622 17.0" 
$ns at 822.6264950961084 "$node_(545) setdest 62 27094 18.0" 
$ns at 528.0705204778768 "$node_(546) setdest 126708 28867 10.0" 
$ns at 575.0221694987206 "$node_(546) setdest 90418 13413 1.0" 
$ns at 609.3648095041309 "$node_(546) setdest 2311 12371 5.0" 
$ns at 656.0668273798423 "$node_(546) setdest 68774 11957 18.0" 
$ns at 864.9423722794487 "$node_(546) setdest 27571 5071 13.0" 
$ns at 554.3508972442472 "$node_(547) setdest 70841 36823 13.0" 
$ns at 593.5114178859764 "$node_(547) setdest 55301 37670 12.0" 
$ns at 734.0485214419075 "$node_(547) setdest 76910 26301 17.0" 
$ns at 507.14378810675225 "$node_(548) setdest 67341 13511 10.0" 
$ns at 607.537095190793 "$node_(548) setdest 92075 21830 13.0" 
$ns at 680.8845086733819 "$node_(548) setdest 105597 38291 17.0" 
$ns at 769.4306774453052 "$node_(548) setdest 21769 43453 17.0" 
$ns at 839.6034061356111 "$node_(548) setdest 49457 13770 15.0" 
$ns at 564.2463914053168 "$node_(549) setdest 68159 26465 11.0" 
$ns at 655.2103387972517 "$node_(549) setdest 69855 18541 10.0" 
$ns at 718.8745273800417 "$node_(549) setdest 82346 32755 18.0" 
$ns at 858.2065419810699 "$node_(549) setdest 19421 39477 20.0" 
$ns at 898.7161293807998 "$node_(549) setdest 21974 29449 9.0" 
$ns at 598.4545564480586 "$node_(550) setdest 19620 29715 8.0" 
$ns at 662.6096794403193 "$node_(550) setdest 68716 35322 18.0" 
$ns at 708.1022611282043 "$node_(550) setdest 36574 33049 2.0" 
$ns at 755.257903977497 "$node_(550) setdest 10559 38966 14.0" 
$ns at 825.4201915584463 "$node_(550) setdest 78468 8158 3.0" 
$ns at 862.4576564600382 "$node_(550) setdest 15695 31737 4.0" 
$ns at 653.5259118173385 "$node_(551) setdest 95972 769 8.0" 
$ns at 722.9556024445379 "$node_(551) setdest 59237 4329 18.0" 
$ns at 888.0533266726402 "$node_(551) setdest 75729 36959 9.0" 
$ns at 514.7784490698978 "$node_(552) setdest 111227 2260 5.0" 
$ns at 590.5024697834258 "$node_(552) setdest 133389 33408 7.0" 
$ns at 648.3231981977902 "$node_(552) setdest 48544 13478 19.0" 
$ns at 704.6646844254917 "$node_(552) setdest 80927 14585 17.0" 
$ns at 741.5806441473889 "$node_(552) setdest 120418 20627 3.0" 
$ns at 774.2850906192111 "$node_(552) setdest 129442 8138 19.0" 
$ns at 852.387349653759 "$node_(552) setdest 93682 15703 16.0" 
$ns at 639.8080541542932 "$node_(553) setdest 20239 30924 12.0" 
$ns at 745.066649874335 "$node_(553) setdest 110067 15753 2.0" 
$ns at 789.4475180274093 "$node_(553) setdest 102050 3941 13.0" 
$ns at 846.8798492116738 "$node_(553) setdest 77808 40584 3.0" 
$ns at 885.5624364345097 "$node_(553) setdest 36581 27149 1.0" 
$ns at 516.5643910789955 "$node_(554) setdest 7989 8906 1.0" 
$ns at 548.5674330412089 "$node_(554) setdest 12081 38944 17.0" 
$ns at 694.6184732434706 "$node_(554) setdest 41369 4376 12.0" 
$ns at 840.0307751548243 "$node_(554) setdest 77837 37903 10.0" 
$ns at 536.1637942855623 "$node_(555) setdest 75341 1864 3.0" 
$ns at 568.6539991115662 "$node_(555) setdest 44303 12554 11.0" 
$ns at 618.4863949837717 "$node_(555) setdest 25726 37361 17.0" 
$ns at 678.1638667425077 "$node_(555) setdest 9875 24285 15.0" 
$ns at 813.510898536447 "$node_(555) setdest 52627 6362 17.0" 
$ns at 551.8857872666006 "$node_(556) setdest 76827 12860 13.0" 
$ns at 646.3342350272276 "$node_(556) setdest 3070 16378 6.0" 
$ns at 684.8136741303991 "$node_(556) setdest 125270 31382 8.0" 
$ns at 718.1486981539557 "$node_(556) setdest 88563 34746 8.0" 
$ns at 816.1703652062066 "$node_(556) setdest 131130 29302 16.0" 
$ns at 640.3888406743654 "$node_(557) setdest 75687 44375 3.0" 
$ns at 692.6478461467624 "$node_(557) setdest 61221 25142 1.0" 
$ns at 731.6062396439437 "$node_(557) setdest 114579 37280 16.0" 
$ns at 852.1819576985115 "$node_(557) setdest 104127 37729 11.0" 
$ns at 507.1662215729577 "$node_(558) setdest 12498 27618 10.0" 
$ns at 622.0889324693202 "$node_(558) setdest 106955 30096 17.0" 
$ns at 729.2018040466512 "$node_(558) setdest 14896 13844 11.0" 
$ns at 810.1293508953589 "$node_(558) setdest 60610 42442 10.0" 
$ns at 578.4673851309831 "$node_(559) setdest 130424 17854 5.0" 
$ns at 657.1380584371987 "$node_(559) setdest 63786 40662 17.0" 
$ns at 758.7191402111634 "$node_(559) setdest 32612 34830 1.0" 
$ns at 797.5503998151423 "$node_(559) setdest 59059 21817 13.0" 
$ns at 580.5730254422373 "$node_(560) setdest 79366 38987 1.0" 
$ns at 620.5235976584729 "$node_(560) setdest 113986 36787 7.0" 
$ns at 677.387889091693 "$node_(560) setdest 97489 32417 14.0" 
$ns at 766.8381700234675 "$node_(560) setdest 42610 15515 14.0" 
$ns at 817.7953379566193 "$node_(560) setdest 65281 5844 9.0" 
$ns at 595.7000940904292 "$node_(561) setdest 122706 42755 15.0" 
$ns at 694.8227634651687 "$node_(561) setdest 88407 5689 4.0" 
$ns at 753.5222393641621 "$node_(561) setdest 2858 18042 8.0" 
$ns at 857.3139991112356 "$node_(561) setdest 63450 24180 13.0" 
$ns at 501.68136245421374 "$node_(562) setdest 83570 40375 19.0" 
$ns at 589.3771594787958 "$node_(562) setdest 67642 18308 14.0" 
$ns at 718.2840670349765 "$node_(562) setdest 30828 34918 8.0" 
$ns at 810.87782590699 "$node_(562) setdest 85089 12141 10.0" 
$ns at 884.5972006255529 "$node_(562) setdest 119664 1440 4.0" 
$ns at 632.5820897795038 "$node_(563) setdest 31235 31607 1.0" 
$ns at 672.2604690617746 "$node_(563) setdest 7688 7251 5.0" 
$ns at 737.6900067383317 "$node_(563) setdest 43803 11827 8.0" 
$ns at 845.5648751539504 "$node_(563) setdest 112707 37561 2.0" 
$ns at 880.1071052274712 "$node_(563) setdest 123102 40046 2.0" 
$ns at 563.6169703739464 "$node_(564) setdest 74127 22480 11.0" 
$ns at 699.309769073544 "$node_(564) setdest 109150 26117 7.0" 
$ns at 792.926472574931 "$node_(564) setdest 98214 41408 9.0" 
$ns at 872.0812251051899 "$node_(564) setdest 33492 30813 20.0" 
$ns at 527.1401318147427 "$node_(565) setdest 87131 11072 7.0" 
$ns at 584.7803920224327 "$node_(565) setdest 73320 19882 11.0" 
$ns at 617.8868304454128 "$node_(565) setdest 92788 35405 13.0" 
$ns at 752.1540746587402 "$node_(565) setdest 83695 8533 1.0" 
$ns at 782.9130121850293 "$node_(565) setdest 48239 44002 4.0" 
$ns at 842.9444692965623 "$node_(565) setdest 80398 24224 13.0" 
$ns at 552.6706832839827 "$node_(566) setdest 56282 22270 8.0" 
$ns at 660.9076253069695 "$node_(566) setdest 98484 5420 5.0" 
$ns at 711.202850266239 "$node_(566) setdest 116600 40645 1.0" 
$ns at 747.4269341877194 "$node_(566) setdest 122178 30560 1.0" 
$ns at 785.7418256818236 "$node_(566) setdest 120398 1500 16.0" 
$ns at 537.0133796981253 "$node_(567) setdest 109070 17021 17.0" 
$ns at 716.7729018295945 "$node_(567) setdest 73277 26428 2.0" 
$ns at 764.8176776581781 "$node_(567) setdest 79766 26920 13.0" 
$ns at 854.3136884876529 "$node_(567) setdest 44772 4491 16.0" 
$ns at 526.3891359180857 "$node_(568) setdest 46597 12664 1.0" 
$ns at 559.7235013460497 "$node_(568) setdest 76081 1192 19.0" 
$ns at 609.5208863919473 "$node_(568) setdest 96342 43648 1.0" 
$ns at 644.0085622583274 "$node_(568) setdest 406 39686 16.0" 
$ns at 776.636059195316 "$node_(568) setdest 33106 25108 4.0" 
$ns at 843.5588703969099 "$node_(568) setdest 4529 24235 14.0" 
$ns at 531.4013485340502 "$node_(569) setdest 49324 22844 19.0" 
$ns at 742.4155168186884 "$node_(569) setdest 25631 2193 14.0" 
$ns at 857.2704815642494 "$node_(569) setdest 28632 39263 1.0" 
$ns at 895.6465920200234 "$node_(569) setdest 3884 30869 4.0" 
$ns at 501.37008210527154 "$node_(570) setdest 49281 25327 18.0" 
$ns at 672.5203175763836 "$node_(570) setdest 94464 43166 8.0" 
$ns at 741.4427887944414 "$node_(570) setdest 37567 28323 7.0" 
$ns at 816.6437756031121 "$node_(570) setdest 89375 3079 3.0" 
$ns at 860.9792793223594 "$node_(570) setdest 84152 20575 7.0" 
$ns at 519.6932464191317 "$node_(571) setdest 82334 7544 8.0" 
$ns at 608.2843184817056 "$node_(571) setdest 121373 38717 2.0" 
$ns at 650.8340281813739 "$node_(571) setdest 13304 11785 2.0" 
$ns at 693.6905160120509 "$node_(571) setdest 68314 40877 14.0" 
$ns at 832.9478051694643 "$node_(571) setdest 23841 19410 3.0" 
$ns at 881.4528402435737 "$node_(571) setdest 89049 2716 19.0" 
$ns at 553.7681294836652 "$node_(572) setdest 90324 10719 17.0" 
$ns at 605.1534598770211 "$node_(572) setdest 48822 16619 5.0" 
$ns at 672.8750156649528 "$node_(572) setdest 29919 19304 6.0" 
$ns at 707.7050347157182 "$node_(572) setdest 71115 39467 7.0" 
$ns at 766.3628218372614 "$node_(572) setdest 70354 12555 12.0" 
$ns at 537.1860541540944 "$node_(573) setdest 52830 27280 4.0" 
$ns at 594.4652161338854 "$node_(573) setdest 29063 34240 8.0" 
$ns at 637.8937815222417 "$node_(573) setdest 92652 28292 7.0" 
$ns at 722.6126881455629 "$node_(573) setdest 65381 31971 3.0" 
$ns at 754.3203856250962 "$node_(573) setdest 125062 17711 6.0" 
$ns at 834.70772162871 "$node_(573) setdest 98682 35563 13.0" 
$ns at 583.3081407887217 "$node_(574) setdest 128201 30358 7.0" 
$ns at 613.5447079815718 "$node_(574) setdest 83823 21519 15.0" 
$ns at 694.4522854017831 "$node_(574) setdest 76686 12498 16.0" 
$ns at 760.4086854648501 "$node_(574) setdest 93550 3656 1.0" 
$ns at 799.4208606786186 "$node_(574) setdest 116953 1831 20.0" 
$ns at 836.3582387804918 "$node_(574) setdest 105808 23395 5.0" 
$ns at 504.4142861736224 "$node_(575) setdest 133177 25105 13.0" 
$ns at 569.0395211549553 "$node_(575) setdest 99426 33434 18.0" 
$ns at 639.4353288146023 "$node_(575) setdest 53190 7449 2.0" 
$ns at 684.5051570154766 "$node_(575) setdest 105790 20490 3.0" 
$ns at 742.5704408372991 "$node_(575) setdest 17618 895 7.0" 
$ns at 795.2467752846682 "$node_(575) setdest 13597 30673 7.0" 
$ns at 861.5053798673455 "$node_(575) setdest 129530 4727 19.0" 
$ns at 516.6268796256046 "$node_(576) setdest 16610 33269 11.0" 
$ns at 610.1729530231221 "$node_(576) setdest 54631 12624 9.0" 
$ns at 643.0208515782408 "$node_(576) setdest 59367 26890 17.0" 
$ns at 758.6151247414278 "$node_(576) setdest 112268 41845 7.0" 
$ns at 858.5705508398952 "$node_(576) setdest 115991 37996 15.0" 
$ns at 898.6299478497233 "$node_(576) setdest 73036 21872 19.0" 
$ns at 535.7953816449423 "$node_(577) setdest 37999 8959 6.0" 
$ns at 591.9721607384148 "$node_(577) setdest 119134 30242 15.0" 
$ns at 748.8688465411492 "$node_(577) setdest 22895 30422 19.0" 
$ns at 892.1236601569631 "$node_(577) setdest 49758 4466 10.0" 
$ns at 584.0551331953515 "$node_(578) setdest 129544 8990 17.0" 
$ns at 727.7487384087265 "$node_(578) setdest 19500 21910 18.0" 
$ns at 794.9115120364856 "$node_(578) setdest 126049 32619 11.0" 
$ns at 857.0944268781986 "$node_(578) setdest 133129 4706 3.0" 
$ns at 633.3286778213115 "$node_(579) setdest 132629 41030 9.0" 
$ns at 752.9870897313216 "$node_(579) setdest 113950 28435 9.0" 
$ns at 807.5974393956128 "$node_(579) setdest 128674 29947 2.0" 
$ns at 848.7155359496657 "$node_(579) setdest 23999 8860 5.0" 
$ns at 548.5450316330093 "$node_(580) setdest 11134 17779 3.0" 
$ns at 594.6572457571821 "$node_(580) setdest 43197 30400 17.0" 
$ns at 793.9382991347378 "$node_(580) setdest 25307 25281 11.0" 
$ns at 827.4195933529302 "$node_(580) setdest 59183 39591 18.0" 
$ns at 625.4657058606177 "$node_(581) setdest 33201 10666 9.0" 
$ns at 662.9789224801939 "$node_(581) setdest 87937 41710 17.0" 
$ns at 812.8309975901367 "$node_(581) setdest 45100 18610 8.0" 
$ns at 849.1688735263243 "$node_(581) setdest 45419 15587 11.0" 
$ns at 892.2060764536944 "$node_(581) setdest 130138 24368 14.0" 
$ns at 512.347757211125 "$node_(582) setdest 76428 39999 7.0" 
$ns at 589.7083515235075 "$node_(582) setdest 105810 6109 2.0" 
$ns at 636.6540347585379 "$node_(582) setdest 45423 32481 3.0" 
$ns at 675.9112190802487 "$node_(582) setdest 2517 5333 18.0" 
$ns at 738.5695469827465 "$node_(582) setdest 34217 11320 7.0" 
$ns at 812.2813603033718 "$node_(582) setdest 77930 25670 10.0" 
$ns at 522.8229100258025 "$node_(583) setdest 25340 34911 16.0" 
$ns at 553.2082227701466 "$node_(583) setdest 110701 37636 4.0" 
$ns at 587.5480820637365 "$node_(583) setdest 18630 36422 8.0" 
$ns at 682.4016226112509 "$node_(583) setdest 64283 3692 11.0" 
$ns at 806.3301160306028 "$node_(583) setdest 35041 11320 15.0" 
$ns at 850.9192633489415 "$node_(583) setdest 17450 33587 14.0" 
$ns at 510.46844431368106 "$node_(584) setdest 92451 34782 19.0" 
$ns at 567.3196470172886 "$node_(584) setdest 39809 11656 10.0" 
$ns at 636.6865351247259 "$node_(584) setdest 6325 6127 8.0" 
$ns at 705.5687345517979 "$node_(584) setdest 126171 16304 7.0" 
$ns at 785.6205816407873 "$node_(584) setdest 51112 18738 19.0" 
$ns at 599.7497310509679 "$node_(585) setdest 77038 39044 17.0" 
$ns at 706.3931135757903 "$node_(585) setdest 56453 24873 5.0" 
$ns at 775.4598213225371 "$node_(585) setdest 32840 28192 14.0" 
$ns at 558.700845141373 "$node_(586) setdest 103309 7414 19.0" 
$ns at 771.1238868562423 "$node_(586) setdest 68154 8962 19.0" 
$ns at 807.7724484610928 "$node_(586) setdest 119422 29245 17.0" 
$ns at 882.7273798826909 "$node_(586) setdest 127179 32249 19.0" 
$ns at 648.0267912038964 "$node_(587) setdest 77449 12707 1.0" 
$ns at 679.2801118664045 "$node_(587) setdest 120044 20301 4.0" 
$ns at 720.0688656418814 "$node_(587) setdest 1981 17471 2.0" 
$ns at 754.89189499562 "$node_(587) setdest 89914 13056 7.0" 
$ns at 807.9222213194689 "$node_(587) setdest 111190 40723 7.0" 
$ns at 839.3764003524323 "$node_(587) setdest 41271 24854 1.0" 
$ns at 872.9082778354698 "$node_(587) setdest 56924 29569 12.0" 
$ns at 670.0515598467887 "$node_(588) setdest 57978 11400 14.0" 
$ns at 738.4359164758855 "$node_(588) setdest 58785 35883 9.0" 
$ns at 833.3879324739022 "$node_(588) setdest 94433 34154 4.0" 
$ns at 887.7240361088257 "$node_(588) setdest 19402 30846 5.0" 
$ns at 501.82743818933926 "$node_(589) setdest 89105 1646 16.0" 
$ns at 689.2080596236113 "$node_(589) setdest 87001 36256 9.0" 
$ns at 749.6914697477962 "$node_(589) setdest 124523 35580 15.0" 
$ns at 792.3221399493385 "$node_(589) setdest 93353 44291 18.0" 
$ns at 831.4682390117082 "$node_(589) setdest 65246 17499 14.0" 
$ns at 516.7247264564442 "$node_(590) setdest 129803 12458 8.0" 
$ns at 621.5953595917049 "$node_(590) setdest 58733 26326 16.0" 
$ns at 665.8787171989766 "$node_(590) setdest 99166 41603 19.0" 
$ns at 717.8817906237202 "$node_(590) setdest 23764 38816 7.0" 
$ns at 778.9139284891851 "$node_(590) setdest 111091 32336 5.0" 
$ns at 825.0124568697943 "$node_(590) setdest 96582 15194 16.0" 
$ns at 528.1034173265018 "$node_(591) setdest 22898 40922 14.0" 
$ns at 682.6449114405718 "$node_(591) setdest 118170 37336 14.0" 
$ns at 808.4013775432996 "$node_(591) setdest 73174 17695 3.0" 
$ns at 857.9323991217195 "$node_(591) setdest 38948 34462 17.0" 
$ns at 520.3260188634257 "$node_(592) setdest 67458 15189 17.0" 
$ns at 636.9860695578786 "$node_(592) setdest 2920 7333 6.0" 
$ns at 671.6413432209436 "$node_(592) setdest 44580 43305 4.0" 
$ns at 721.2693641163266 "$node_(592) setdest 73019 27601 3.0" 
$ns at 779.1587159641929 "$node_(592) setdest 61948 19688 17.0" 
$ns at 545.8729600841186 "$node_(593) setdest 112512 37391 14.0" 
$ns at 652.1606506348869 "$node_(593) setdest 30699 5061 14.0" 
$ns at 735.2833151633162 "$node_(593) setdest 94927 14292 12.0" 
$ns at 781.6476755667329 "$node_(593) setdest 7214 22358 6.0" 
$ns at 848.5113623810785 "$node_(593) setdest 110345 19406 1.0" 
$ns at 885.7966754226485 "$node_(593) setdest 62919 22511 19.0" 
$ns at 686.307231038423 "$node_(594) setdest 32487 26765 15.0" 
$ns at 789.6806493897083 "$node_(594) setdest 5019 32830 14.0" 
$ns at 856.4736016889937 "$node_(594) setdest 43759 13081 5.0" 
$ns at 516.654453733646 "$node_(595) setdest 80592 42189 3.0" 
$ns at 574.3777120777828 "$node_(595) setdest 127160 27639 9.0" 
$ns at 655.9030381414209 "$node_(595) setdest 967 31455 20.0" 
$ns at 840.1688284183138 "$node_(595) setdest 79347 1228 2.0" 
$ns at 884.9821407585533 "$node_(595) setdest 129518 28165 9.0" 
$ns at 541.981054846353 "$node_(596) setdest 8066 31437 10.0" 
$ns at 603.2383686029872 "$node_(596) setdest 123095 11944 15.0" 
$ns at 708.5540113022531 "$node_(596) setdest 49353 21295 4.0" 
$ns at 740.2625294607252 "$node_(596) setdest 124186 31489 12.0" 
$ns at 770.8388605024355 "$node_(596) setdest 41225 11550 16.0" 
$ns at 816.545323310667 "$node_(596) setdest 49412 32386 12.0" 
$ns at 604.0923878278766 "$node_(597) setdest 33533 1514 7.0" 
$ns at 703.369083795412 "$node_(597) setdest 28947 1530 5.0" 
$ns at 747.2611072178154 "$node_(597) setdest 109122 25992 12.0" 
$ns at 821.9232742665474 "$node_(597) setdest 120227 10224 19.0" 
$ns at 621.7110234745365 "$node_(598) setdest 19002 36015 1.0" 
$ns at 657.624331552277 "$node_(598) setdest 11433 30239 16.0" 
$ns at 712.8751817206291 "$node_(598) setdest 84508 5725 18.0" 
$ns at 820.8475805022518 "$node_(598) setdest 52243 32822 9.0" 
$ns at 550.5318719400151 "$node_(599) setdest 15015 5805 13.0" 
$ns at 682.4802226103606 "$node_(599) setdest 95296 31856 14.0" 
$ns at 806.8840867753395 "$node_(599) setdest 122279 29547 7.0" 
$ns at 866.3426802413658 "$node_(599) setdest 52634 43472 12.0" 
$ns at 643.4212148516845 "$node_(600) setdest 110667 7889 1.0" 
$ns at 683.0809291337919 "$node_(600) setdest 64029 37687 8.0" 
$ns at 776.6244890583446 "$node_(600) setdest 126748 16590 16.0" 
$ns at 612.480296884894 "$node_(601) setdest 109330 38498 10.0" 
$ns at 668.9475965383305 "$node_(601) setdest 128562 32408 20.0" 
$ns at 752.5986617461873 "$node_(601) setdest 25425 20774 4.0" 
$ns at 787.4227755694683 "$node_(601) setdest 64992 8441 2.0" 
$ns at 833.1487394399912 "$node_(601) setdest 64677 7207 20.0" 
$ns at 715.9675245714495 "$node_(602) setdest 61004 29486 2.0" 
$ns at 755.1523272814454 "$node_(602) setdest 16678 29311 16.0" 
$ns at 852.0338541993112 "$node_(602) setdest 43253 1422 14.0" 
$ns at 654.5338877748229 "$node_(603) setdest 100937 7163 2.0" 
$ns at 693.3182436415373 "$node_(603) setdest 128910 17383 3.0" 
$ns at 745.6176243545453 "$node_(603) setdest 32875 16982 1.0" 
$ns at 778.594080644399 "$node_(603) setdest 15314 660 2.0" 
$ns at 816.8900795477989 "$node_(603) setdest 14687 20599 6.0" 
$ns at 869.587903884147 "$node_(603) setdest 40898 6080 20.0" 
$ns at 690.2368763416302 "$node_(604) setdest 119663 35310 12.0" 
$ns at 799.6008063039288 "$node_(604) setdest 129427 12010 8.0" 
$ns at 893.6145713083152 "$node_(604) setdest 107670 12428 9.0" 
$ns at 665.15212523639 "$node_(605) setdest 47371 21934 14.0" 
$ns at 822.020204691932 "$node_(605) setdest 69909 3184 14.0" 
$ns at 874.5310809256714 "$node_(605) setdest 85325 29446 10.0" 
$ns at 606.7847882613618 "$node_(606) setdest 46600 35515 19.0" 
$ns at 674.4077411818153 "$node_(606) setdest 127133 3184 5.0" 
$ns at 718.6236521450315 "$node_(606) setdest 13866 40078 14.0" 
$ns at 788.8368939899341 "$node_(606) setdest 24829 1902 6.0" 
$ns at 864.5587069511299 "$node_(606) setdest 117977 1115 12.0" 
$ns at 735.4994922078855 "$node_(607) setdest 10140 4374 8.0" 
$ns at 836.2073274554577 "$node_(607) setdest 32585 522 17.0" 
$ns at 629.3847843039899 "$node_(608) setdest 66376 37612 11.0" 
$ns at 684.3401899269709 "$node_(608) setdest 40751 21011 2.0" 
$ns at 721.9482144426258 "$node_(608) setdest 83713 25840 4.0" 
$ns at 765.857537671963 "$node_(608) setdest 66779 42251 8.0" 
$ns at 842.1617271002102 "$node_(608) setdest 103117 5489 1.0" 
$ns at 873.1508140240899 "$node_(608) setdest 4649 38065 7.0" 
$ns at 671.421063158763 "$node_(609) setdest 15580 14998 9.0" 
$ns at 736.2626628933341 "$node_(609) setdest 8463 11916 7.0" 
$ns at 800.2514131766 "$node_(609) setdest 130065 26125 2.0" 
$ns at 845.9141197579374 "$node_(609) setdest 13821 21138 2.0" 
$ns at 881.9244951261792 "$node_(609) setdest 110076 19098 7.0" 
$ns at 610.8865204767619 "$node_(610) setdest 90711 35227 2.0" 
$ns at 657.6164778206132 "$node_(610) setdest 114606 39537 2.0" 
$ns at 699.6327222864949 "$node_(610) setdest 12893 8963 8.0" 
$ns at 779.5093905718807 "$node_(610) setdest 90059 22978 19.0" 
$ns at 841.4609585721826 "$node_(610) setdest 123800 9169 1.0" 
$ns at 875.3568700959501 "$node_(610) setdest 49346 39220 15.0" 
$ns at 630.4016348059403 "$node_(611) setdest 92340 41275 14.0" 
$ns at 782.9702918664983 "$node_(611) setdest 118311 17119 3.0" 
$ns at 816.1652638417734 "$node_(611) setdest 91261 34029 5.0" 
$ns at 864.6624411953411 "$node_(611) setdest 98694 33834 8.0" 
$ns at 602.4831948208823 "$node_(612) setdest 44136 28662 19.0" 
$ns at 700.5694416366905 "$node_(612) setdest 17899 32547 20.0" 
$ns at 781.865514893812 "$node_(612) setdest 124015 23427 13.0" 
$ns at 635.4728045681785 "$node_(613) setdest 115046 7370 12.0" 
$ns at 766.8584892503688 "$node_(613) setdest 99430 24132 6.0" 
$ns at 831.4842292148111 "$node_(613) setdest 85836 32546 20.0" 
$ns at 868.2006719217344 "$node_(613) setdest 50355 28643 10.0" 
$ns at 700.6579909146802 "$node_(614) setdest 16780 35808 6.0" 
$ns at 732.3963506423918 "$node_(614) setdest 42718 7298 6.0" 
$ns at 781.0263330553643 "$node_(614) setdest 21491 6297 8.0" 
$ns at 887.8788809189393 "$node_(614) setdest 16218 43391 20.0" 
$ns at 611.0797600935466 "$node_(615) setdest 121549 3090 13.0" 
$ns at 733.7263316092211 "$node_(615) setdest 125815 18802 20.0" 
$ns at 832.2781005667714 "$node_(615) setdest 20155 42343 15.0" 
$ns at 875.8903567908835 "$node_(615) setdest 24480 14720 10.0" 
$ns at 653.6129825132223 "$node_(616) setdest 34962 22828 15.0" 
$ns at 832.7574401507827 "$node_(616) setdest 61059 44609 4.0" 
$ns at 873.3963060922829 "$node_(616) setdest 133381 37552 18.0" 
$ns at 631.5640167748925 "$node_(617) setdest 44609 1506 12.0" 
$ns at 671.5894775159018 "$node_(617) setdest 21963 10769 11.0" 
$ns at 806.1946527883656 "$node_(617) setdest 15040 16667 15.0" 
$ns at 645.5010861623488 "$node_(618) setdest 82437 17057 1.0" 
$ns at 682.9703238246531 "$node_(618) setdest 1060 14494 13.0" 
$ns at 754.0323463264958 "$node_(618) setdest 37879 14882 2.0" 
$ns at 793.4682066963449 "$node_(618) setdest 113794 29395 2.0" 
$ns at 839.0382845043314 "$node_(618) setdest 53098 20594 4.0" 
$ns at 870.7630930434794 "$node_(618) setdest 105420 44416 10.0" 
$ns at 676.0841868816276 "$node_(619) setdest 13094 42095 6.0" 
$ns at 714.8873976290877 "$node_(619) setdest 38406 14547 17.0" 
$ns at 831.0782262933184 "$node_(619) setdest 43947 2524 15.0" 
$ns at 611.5276846500517 "$node_(620) setdest 10538 30570 2.0" 
$ns at 651.7623653064693 "$node_(620) setdest 81107 43109 19.0" 
$ns at 857.83829159432 "$node_(620) setdest 129544 35678 10.0" 
$ns at 674.5664607774863 "$node_(621) setdest 82605 20793 1.0" 
$ns at 710.4353259722441 "$node_(621) setdest 120324 43117 11.0" 
$ns at 758.7208939548558 "$node_(621) setdest 17569 16387 19.0" 
$ns at 622.7857500537546 "$node_(622) setdest 57983 21474 18.0" 
$ns at 742.4818409194033 "$node_(622) setdest 3936 23027 16.0" 
$ns at 653.3145127442208 "$node_(623) setdest 78655 15185 18.0" 
$ns at 689.05439388388 "$node_(623) setdest 11867 32628 17.0" 
$ns at 885.6512092399471 "$node_(623) setdest 74200 26055 1.0" 
$ns at 600.7199653696532 "$node_(624) setdest 56900 23186 5.0" 
$ns at 675.9025336085805 "$node_(624) setdest 105178 43901 1.0" 
$ns at 710.7664883812281 "$node_(624) setdest 114963 27729 2.0" 
$ns at 743.1334057760607 "$node_(624) setdest 33363 28091 6.0" 
$ns at 813.3471729371387 "$node_(624) setdest 17583 39625 18.0" 
$ns at 609.6185166321277 "$node_(625) setdest 36473 2059 17.0" 
$ns at 712.0312282323944 "$node_(625) setdest 93018 43391 15.0" 
$ns at 877.6660466059284 "$node_(625) setdest 6869 22365 3.0" 
$ns at 737.6728045395474 "$node_(626) setdest 30474 16702 5.0" 
$ns at 777.8034457882443 "$node_(626) setdest 44519 511 4.0" 
$ns at 839.4163452498082 "$node_(626) setdest 73410 6361 17.0" 
$ns at 893.2559663491205 "$node_(626) setdest 34680 20696 6.0" 
$ns at 602.9975567326239 "$node_(627) setdest 70445 40217 7.0" 
$ns at 683.330478235124 "$node_(627) setdest 25243 27609 12.0" 
$ns at 750.2362095779221 "$node_(627) setdest 106227 16857 8.0" 
$ns at 815.2557551415252 "$node_(627) setdest 7326 27824 19.0" 
$ns at 646.5409268117888 "$node_(628) setdest 61014 32459 10.0" 
$ns at 710.091202924317 "$node_(628) setdest 77412 50 18.0" 
$ns at 805.8435032211235 "$node_(628) setdest 4376 21056 10.0" 
$ns at 735.8737929997427 "$node_(629) setdest 64520 34792 18.0" 
$ns at 620.3656265609867 "$node_(630) setdest 75741 41597 7.0" 
$ns at 662.5900806869291 "$node_(630) setdest 50390 11524 9.0" 
$ns at 737.831249096684 "$node_(630) setdest 40322 17508 15.0" 
$ns at 878.7013600244459 "$node_(630) setdest 57255 10885 12.0" 
$ns at 662.668999532015 "$node_(631) setdest 35860 17992 13.0" 
$ns at 752.0091109950852 "$node_(631) setdest 128388 30224 7.0" 
$ns at 786.5222447742129 "$node_(631) setdest 50022 17112 6.0" 
$ns at 822.1655350997424 "$node_(631) setdest 128021 14389 5.0" 
$ns at 893.0449497267477 "$node_(631) setdest 93662 22233 3.0" 
$ns at 608.8765929631313 "$node_(632) setdest 88128 4686 2.0" 
$ns at 647.8572331461312 "$node_(632) setdest 82269 552 5.0" 
$ns at 703.0182202618579 "$node_(632) setdest 71754 22286 19.0" 
$ns at 847.7125972027084 "$node_(632) setdest 81810 26422 10.0" 
$ns at 783.6171817578509 "$node_(633) setdest 39921 31789 11.0" 
$ns at 839.5362353287263 "$node_(633) setdest 65787 7698 19.0" 
$ns at 684.8067974618989 "$node_(634) setdest 56713 26280 4.0" 
$ns at 716.0414841634615 "$node_(634) setdest 89348 39347 1.0" 
$ns at 747.042107503047 "$node_(634) setdest 114451 3475 19.0" 
$ns at 788.5139662247554 "$node_(634) setdest 126678 5947 11.0" 
$ns at 832.6722718374509 "$node_(634) setdest 106705 7695 1.0" 
$ns at 864.2073957858738 "$node_(634) setdest 2443 37113 11.0" 
$ns at 755.9047582451917 "$node_(635) setdest 41637 8473 7.0" 
$ns at 854.0412617882198 "$node_(635) setdest 57221 12493 1.0" 
$ns at 884.2834274535976 "$node_(635) setdest 112483 32264 9.0" 
$ns at 647.2355444574359 "$node_(636) setdest 21844 11364 12.0" 
$ns at 701.0458921945781 "$node_(636) setdest 97041 26807 10.0" 
$ns at 757.3760599370837 "$node_(636) setdest 76142 28074 4.0" 
$ns at 802.2615196314556 "$node_(636) setdest 109313 32547 11.0" 
$ns at 843.1557534142659 "$node_(636) setdest 17896 1132 2.0" 
$ns at 882.6843411423356 "$node_(636) setdest 100673 9412 17.0" 
$ns at 613.1906094588749 "$node_(637) setdest 130618 42878 3.0" 
$ns at 659.5209860578228 "$node_(637) setdest 84050 2777 1.0" 
$ns at 691.6382048459715 "$node_(637) setdest 64264 10419 18.0" 
$ns at 889.4778800691886 "$node_(637) setdest 85288 1467 15.0" 
$ns at 705.518285983238 "$node_(638) setdest 104435 12780 7.0" 
$ns at 739.5806873332376 "$node_(638) setdest 73067 38241 14.0" 
$ns at 892.1040986777979 "$node_(638) setdest 92708 577 1.0" 
$ns at 607.8008505124596 "$node_(639) setdest 5903 25562 12.0" 
$ns at 732.5723401771452 "$node_(639) setdest 80660 34334 17.0" 
$ns at 804.0300945377951 "$node_(639) setdest 63589 2038 19.0" 
$ns at 836.0149767224295 "$node_(639) setdest 34315 531 11.0" 
$ns at 616.3915551316023 "$node_(640) setdest 105713 33790 13.0" 
$ns at 687.8982951811413 "$node_(640) setdest 39371 43384 16.0" 
$ns at 719.0671800010837 "$node_(640) setdest 42640 388 15.0" 
$ns at 771.2998100118292 "$node_(640) setdest 79031 20820 3.0" 
$ns at 804.3641589242086 "$node_(640) setdest 20558 41879 5.0" 
$ns at 858.3462927371497 "$node_(640) setdest 82990 2919 18.0" 
$ns at 741.1388936711569 "$node_(641) setdest 53375 40026 8.0" 
$ns at 849.3079218122207 "$node_(641) setdest 41199 537 15.0" 
$ns at 716.4642473617487 "$node_(642) setdest 5123 32578 2.0" 
$ns at 753.2394065368012 "$node_(642) setdest 60065 37928 15.0" 
$ns at 892.2372047783588 "$node_(642) setdest 132431 32884 9.0" 
$ns at 610.1912641308196 "$node_(643) setdest 62696 3658 19.0" 
$ns at 709.1524679921702 "$node_(643) setdest 131313 44327 1.0" 
$ns at 745.7707269377674 "$node_(643) setdest 130737 11124 6.0" 
$ns at 783.9913569953271 "$node_(643) setdest 132777 38552 9.0" 
$ns at 819.0990380482093 "$node_(643) setdest 123462 9164 4.0" 
$ns at 855.7065077770447 "$node_(643) setdest 128618 40549 17.0" 
$ns at 647.4110680066918 "$node_(644) setdest 99991 34070 4.0" 
$ns at 703.0657007491072 "$node_(644) setdest 36807 10390 6.0" 
$ns at 749.2271287343005 "$node_(644) setdest 19906 33136 15.0" 
$ns at 870.7989843212354 "$node_(644) setdest 130627 26642 18.0" 
$ns at 619.1162386953042 "$node_(645) setdest 53383 35686 4.0" 
$ns at 670.6164960973696 "$node_(645) setdest 77453 30361 13.0" 
$ns at 745.4853657581889 "$node_(645) setdest 79277 38648 7.0" 
$ns at 827.5706731584085 "$node_(645) setdest 37189 2817 12.0" 
$ns at 644.3183861463704 "$node_(646) setdest 4096 13352 11.0" 
$ns at 780.0774547683809 "$node_(646) setdest 11597 19207 7.0" 
$ns at 843.5053286973939 "$node_(646) setdest 107855 25273 3.0" 
$ns at 630.9764015210664 "$node_(647) setdest 59610 7905 9.0" 
$ns at 725.7148055415639 "$node_(647) setdest 22933 19491 13.0" 
$ns at 777.2110792321394 "$node_(647) setdest 101935 30929 1.0" 
$ns at 815.2299566862965 "$node_(647) setdest 99006 42040 7.0" 
$ns at 861.7035444255397 "$node_(647) setdest 96062 29647 1.0" 
$ns at 897.1244798685597 "$node_(647) setdest 74228 30128 7.0" 
$ns at 641.6316873564479 "$node_(648) setdest 75046 15327 2.0" 
$ns at 689.7974775445912 "$node_(648) setdest 44239 11546 10.0" 
$ns at 797.9460433820652 "$node_(648) setdest 65585 17765 3.0" 
$ns at 846.6954976336796 "$node_(648) setdest 11595 27527 9.0" 
$ns at 601.4581819148743 "$node_(649) setdest 92684 453 5.0" 
$ns at 643.500776474164 "$node_(649) setdest 21245 38136 16.0" 
$ns at 763.1165427917454 "$node_(649) setdest 25217 31128 9.0" 
$ns at 813.3152902736139 "$node_(649) setdest 123188 11582 4.0" 
$ns at 862.5886456518083 "$node_(649) setdest 46958 35966 9.0" 
$ns at 622.9412781418102 "$node_(650) setdest 112194 4789 17.0" 
$ns at 659.094625057293 "$node_(650) setdest 39309 6943 10.0" 
$ns at 766.9919918453387 "$node_(650) setdest 32729 22504 11.0" 
$ns at 873.4239644262457 "$node_(650) setdest 67873 3976 11.0" 
$ns at 618.6795330282662 "$node_(651) setdest 94441 30930 1.0" 
$ns at 652.0700939940037 "$node_(651) setdest 15646 11662 10.0" 
$ns at 733.9813357266888 "$node_(651) setdest 35330 19220 20.0" 
$ns at 893.7701549890821 "$node_(651) setdest 104640 31456 18.0" 
$ns at 667.0688168774584 "$node_(652) setdest 51676 16388 11.0" 
$ns at 740.3078912597815 "$node_(652) setdest 32997 1854 4.0" 
$ns at 782.6396901457618 "$node_(652) setdest 103755 33655 17.0" 
$ns at 696.0633278679029 "$node_(653) setdest 50013 37179 19.0" 
$ns at 756.4516194853368 "$node_(653) setdest 55980 16707 6.0" 
$ns at 830.5509010600814 "$node_(653) setdest 107999 22979 3.0" 
$ns at 873.8962783994328 "$node_(653) setdest 83181 37970 18.0" 
$ns at 654.881373566812 "$node_(654) setdest 10102 41047 1.0" 
$ns at 694.0048054219327 "$node_(654) setdest 14933 2346 8.0" 
$ns at 797.0866180725061 "$node_(654) setdest 100348 5828 11.0" 
$ns at 832.3734489999739 "$node_(654) setdest 59430 37812 12.0" 
$ns at 687.2170819044069 "$node_(655) setdest 118771 10374 15.0" 
$ns at 758.4698972098101 "$node_(655) setdest 23434 30753 5.0" 
$ns at 790.7848618510276 "$node_(655) setdest 127766 23348 5.0" 
$ns at 865.8278398912836 "$node_(655) setdest 123728 17902 4.0" 
$ns at 653.0156044946069 "$node_(656) setdest 64288 30498 3.0" 
$ns at 687.9660447996253 "$node_(656) setdest 102969 23251 14.0" 
$ns at 739.5485699239233 "$node_(656) setdest 90957 44502 15.0" 
$ns at 831.8757807241604 "$node_(656) setdest 47611 32254 3.0" 
$ns at 882.6436492234543 "$node_(656) setdest 26898 10702 10.0" 
$ns at 633.0123437467007 "$node_(657) setdest 30929 37284 12.0" 
$ns at 670.4984968236186 "$node_(657) setdest 57259 23584 15.0" 
$ns at 707.9554275388818 "$node_(657) setdest 120977 1376 9.0" 
$ns at 810.3463411766256 "$node_(657) setdest 50097 16504 6.0" 
$ns at 895.3804784642098 "$node_(657) setdest 27635 15665 2.0" 
$ns at 607.2653610467086 "$node_(658) setdest 42205 14914 7.0" 
$ns at 653.8656739566786 "$node_(658) setdest 51830 24252 1.0" 
$ns at 689.4598250486442 "$node_(658) setdest 45791 40157 20.0" 
$ns at 669.5987605544119 "$node_(659) setdest 82025 27955 4.0" 
$ns at 736.8456805812947 "$node_(659) setdest 75699 33533 6.0" 
$ns at 774.094415172732 "$node_(659) setdest 132617 2972 5.0" 
$ns at 822.412039863324 "$node_(659) setdest 121571 34204 15.0" 
$ns at 676.3165833307875 "$node_(660) setdest 7612 42133 7.0" 
$ns at 706.5005298168976 "$node_(660) setdest 133368 5674 3.0" 
$ns at 765.3540611883855 "$node_(660) setdest 69689 8954 1.0" 
$ns at 804.3313655471442 "$node_(660) setdest 24395 44084 8.0" 
$ns at 882.4824096791272 "$node_(660) setdest 80312 7128 19.0" 
$ns at 671.8155097708202 "$node_(661) setdest 109483 14807 6.0" 
$ns at 722.9818052863748 "$node_(661) setdest 57396 25480 12.0" 
$ns at 830.2079385022932 "$node_(661) setdest 13931 43098 1.0" 
$ns at 863.7318538473828 "$node_(661) setdest 114020 30193 8.0" 
$ns at 690.8497594152925 "$node_(662) setdest 21808 8755 16.0" 
$ns at 818.0736408531355 "$node_(662) setdest 4727 23466 18.0" 
$ns at 623.8947991745657 "$node_(663) setdest 66400 42540 7.0" 
$ns at 694.1283869733248 "$node_(663) setdest 123163 38738 9.0" 
$ns at 760.8755870318104 "$node_(663) setdest 78587 24579 17.0" 
$ns at 871.7012940838647 "$node_(663) setdest 49407 16738 7.0" 
$ns at 651.7257578570147 "$node_(664) setdest 105476 22668 19.0" 
$ns at 759.9445900670476 "$node_(664) setdest 20981 4226 12.0" 
$ns at 817.7120849389964 "$node_(664) setdest 107210 31059 2.0" 
$ns at 851.8487266376541 "$node_(664) setdest 84924 41171 19.0" 
$ns at 665.1458750230319 "$node_(665) setdest 82332 10166 17.0" 
$ns at 863.0316854727588 "$node_(665) setdest 67611 42087 13.0" 
$ns at 606.3046141825885 "$node_(666) setdest 39864 34280 16.0" 
$ns at 700.6436565746004 "$node_(666) setdest 114841 43722 18.0" 
$ns at 889.0247025147016 "$node_(666) setdest 115152 26855 1.0" 
$ns at 605.3408385914702 "$node_(667) setdest 87961 31 2.0" 
$ns at 651.8780107045606 "$node_(667) setdest 28151 33481 1.0" 
$ns at 686.7826037210637 "$node_(667) setdest 133150 9736 17.0" 
$ns at 753.8724219323892 "$node_(667) setdest 129849 13006 3.0" 
$ns at 809.043405266943 "$node_(667) setdest 6911 2803 9.0" 
$ns at 897.8786260736499 "$node_(667) setdest 118705 37797 6.0" 
$ns at 605.5848834534993 "$node_(668) setdest 70727 32874 4.0" 
$ns at 672.0239084477203 "$node_(668) setdest 49634 23193 6.0" 
$ns at 714.0311882371383 "$node_(668) setdest 276 18420 12.0" 
$ns at 823.6072341125382 "$node_(668) setdest 27215 6796 6.0" 
$ns at 749.2157133012009 "$node_(669) setdest 41096 7419 18.0" 
$ns at 823.1066891619853 "$node_(669) setdest 132164 9139 8.0" 
$ns at 868.5139188810919 "$node_(669) setdest 122560 35036 16.0" 
$ns at 642.0210107919208 "$node_(670) setdest 84440 15389 9.0" 
$ns at 674.2273437661945 "$node_(670) setdest 124438 1662 8.0" 
$ns at 736.7630368171484 "$node_(670) setdest 17726 16243 11.0" 
$ns at 817.1911413274336 "$node_(670) setdest 38432 11887 13.0" 
$ns at 877.4341181942661 "$node_(670) setdest 64042 40698 6.0" 
$ns at 686.544931388252 "$node_(671) setdest 14362 18910 15.0" 
$ns at 813.4525417668266 "$node_(671) setdest 96229 29141 3.0" 
$ns at 872.187492904002 "$node_(671) setdest 132437 3890 18.0" 
$ns at 622.1824153778264 "$node_(672) setdest 70856 3662 14.0" 
$ns at 717.0660822425314 "$node_(672) setdest 93504 34897 7.0" 
$ns at 799.7972535745371 "$node_(672) setdest 38119 29045 5.0" 
$ns at 831.279595739645 "$node_(672) setdest 20197 10939 7.0" 
$ns at 871.5195050671364 "$node_(672) setdest 14772 40268 7.0" 
$ns at 631.2689642147536 "$node_(673) setdest 51249 39101 1.0" 
$ns at 664.0987092308334 "$node_(673) setdest 48960 1760 16.0" 
$ns at 704.0718703180852 "$node_(673) setdest 10596 23048 15.0" 
$ns at 804.1400764689845 "$node_(673) setdest 54035 19288 6.0" 
$ns at 883.0250339242681 "$node_(673) setdest 11717 4284 18.0" 
$ns at 606.3112489134352 "$node_(674) setdest 95244 32454 10.0" 
$ns at 691.147161586686 "$node_(674) setdest 133909 41701 15.0" 
$ns at 748.5924756337588 "$node_(674) setdest 25803 19421 8.0" 
$ns at 816.6541299621614 "$node_(674) setdest 31900 5831 11.0" 
$ns at 687.8661944461288 "$node_(675) setdest 117010 20404 1.0" 
$ns at 719.2090832016685 "$node_(675) setdest 126106 9028 13.0" 
$ns at 788.3725059024896 "$node_(675) setdest 91901 3554 6.0" 
$ns at 868.4364794342662 "$node_(675) setdest 125859 1971 8.0" 
$ns at 623.7637488895692 "$node_(676) setdest 87651 29274 10.0" 
$ns at 667.5254627405418 "$node_(676) setdest 80052 17796 19.0" 
$ns at 795.9917728463076 "$node_(676) setdest 112668 1293 9.0" 
$ns at 847.164611594374 "$node_(676) setdest 104748 22402 3.0" 
$ns at 889.7823988975604 "$node_(676) setdest 81119 2096 18.0" 
$ns at 695.3428024234584 "$node_(677) setdest 119100 104 12.0" 
$ns at 730.1271330315815 "$node_(677) setdest 41302 26974 17.0" 
$ns at 799.7468634889449 "$node_(677) setdest 81128 1596 13.0" 
$ns at 641.2515639434355 "$node_(678) setdest 114955 37198 14.0" 
$ns at 808.047629513846 "$node_(678) setdest 55362 14233 14.0" 
$ns at 630.6240700511349 "$node_(679) setdest 16192 44261 19.0" 
$ns at 661.4485384888696 "$node_(679) setdest 130297 39725 13.0" 
$ns at 720.2633755856381 "$node_(679) setdest 45716 25503 3.0" 
$ns at 754.405372239693 "$node_(679) setdest 20364 40536 20.0" 
$ns at 719.7061187977105 "$node_(680) setdest 120199 38659 7.0" 
$ns at 751.196943874032 "$node_(680) setdest 83944 26204 7.0" 
$ns at 832.7080269329289 "$node_(680) setdest 29289 28069 19.0" 
$ns at 867.0655389459831 "$node_(680) setdest 5833 41137 1.0" 
$ns at 616.5197830415132 "$node_(681) setdest 66905 7933 19.0" 
$ns at 669.9903195365195 "$node_(681) setdest 83534 29488 1.0" 
$ns at 705.5982904791298 "$node_(681) setdest 54672 13989 3.0" 
$ns at 745.6300679829217 "$node_(681) setdest 103494 12422 15.0" 
$ns at 784.7562969592392 "$node_(681) setdest 8773 1022 3.0" 
$ns at 824.7684150132566 "$node_(681) setdest 93261 12212 8.0" 
$ns at 887.2482400458366 "$node_(681) setdest 36772 40747 3.0" 
$ns at 625.9268961586635 "$node_(682) setdest 59294 14131 13.0" 
$ns at 684.7354451932028 "$node_(682) setdest 728 5006 13.0" 
$ns at 721.0877249595753 "$node_(682) setdest 81842 15150 4.0" 
$ns at 771.5940543193951 "$node_(682) setdest 119898 26831 16.0" 
$ns at 854.8145854047295 "$node_(682) setdest 133364 4867 15.0" 
$ns at 636.0708104346412 "$node_(683) setdest 70707 515 2.0" 
$ns at 685.7346913702893 "$node_(683) setdest 101796 34636 8.0" 
$ns at 777.4465980919608 "$node_(683) setdest 83957 40409 10.0" 
$ns at 810.5389275111127 "$node_(683) setdest 55665 19997 2.0" 
$ns at 848.3499654657344 "$node_(683) setdest 93782 2459 9.0" 
$ns at 613.1201150913826 "$node_(684) setdest 44765 29930 18.0" 
$ns at 667.2142449422433 "$node_(684) setdest 60080 42767 1.0" 
$ns at 702.3594560053227 "$node_(684) setdest 11584 32259 1.0" 
$ns at 735.5755408101465 "$node_(684) setdest 24541 43507 16.0" 
$ns at 853.6515680918159 "$node_(684) setdest 52278 30160 8.0" 
$ns at 701.4885031686997 "$node_(685) setdest 9032 26908 1.0" 
$ns at 736.9931017253256 "$node_(685) setdest 43993 11721 6.0" 
$ns at 780.9132713506184 "$node_(685) setdest 43856 36647 13.0" 
$ns at 850.2975886602048 "$node_(685) setdest 5416 42832 17.0" 
$ns at 657.423280198193 "$node_(686) setdest 52997 9032 2.0" 
$ns at 700.265411766786 "$node_(686) setdest 98582 15203 15.0" 
$ns at 779.9741339442618 "$node_(686) setdest 6138 44523 14.0" 
$ns at 856.2820540108463 "$node_(686) setdest 121190 6822 1.0" 
$ns at 887.372561641802 "$node_(686) setdest 22101 11235 16.0" 
$ns at 696.2469207205282 "$node_(687) setdest 45321 19781 17.0" 
$ns at 807.1065057526571 "$node_(687) setdest 54697 27008 5.0" 
$ns at 885.758591165664 "$node_(687) setdest 17055 31412 14.0" 
$ns at 603.4014755913614 "$node_(688) setdest 114311 4779 7.0" 
$ns at 643.183569204502 "$node_(688) setdest 3193 31618 19.0" 
$ns at 839.500261341316 "$node_(688) setdest 128530 25951 3.0" 
$ns at 876.023649172871 "$node_(688) setdest 70092 5823 9.0" 
$ns at 687.8583842456045 "$node_(689) setdest 26407 41414 2.0" 
$ns at 722.2234307198781 "$node_(689) setdest 25707 21947 8.0" 
$ns at 755.7718480081963 "$node_(689) setdest 59125 5885 1.0" 
$ns at 787.2525806458907 "$node_(689) setdest 38357 34960 14.0" 
$ns at 850.5264998491785 "$node_(689) setdest 105702 29647 12.0" 
$ns at 607.6402232448878 "$node_(690) setdest 92861 17838 1.0" 
$ns at 643.9108210017466 "$node_(690) setdest 92970 4298 5.0" 
$ns at 679.2173562671328 "$node_(690) setdest 69352 34091 20.0" 
$ns at 725.3839709873168 "$node_(690) setdest 84560 9195 16.0" 
$ns at 889.3936485439203 "$node_(690) setdest 132805 4168 14.0" 
$ns at 723.7191590376557 "$node_(691) setdest 124968 36186 10.0" 
$ns at 755.6726203389586 "$node_(691) setdest 80429 169 2.0" 
$ns at 788.2210970290556 "$node_(691) setdest 83051 14494 15.0" 
$ns at 643.9885291274804 "$node_(692) setdest 72802 823 2.0" 
$ns at 681.9996064149066 "$node_(692) setdest 63064 43137 1.0" 
$ns at 715.8537456151018 "$node_(692) setdest 129958 16954 8.0" 
$ns at 815.0737370919258 "$node_(692) setdest 118510 6571 15.0" 
$ns at 683.9255200546672 "$node_(693) setdest 82183 30552 19.0" 
$ns at 840.8410039759915 "$node_(693) setdest 133382 18006 14.0" 
$ns at 879.4167597435944 "$node_(693) setdest 55474 34252 19.0" 
$ns at 737.2981108416858 "$node_(694) setdest 19280 40159 11.0" 
$ns at 810.0207487417986 "$node_(694) setdest 80882 10910 5.0" 
$ns at 855.832729438524 "$node_(694) setdest 60238 2551 4.0" 
$ns at 604.4886646508008 "$node_(695) setdest 133134 27808 19.0" 
$ns at 823.662166612779 "$node_(695) setdest 107510 24448 18.0" 
$ns at 886.8281331553605 "$node_(695) setdest 20164 21715 17.0" 
$ns at 618.299986327657 "$node_(696) setdest 131616 32643 14.0" 
$ns at 703.3848950582529 "$node_(696) setdest 88780 19140 10.0" 
$ns at 768.6252222470495 "$node_(696) setdest 84979 287 9.0" 
$ns at 868.193291259917 "$node_(696) setdest 41225 3465 14.0" 
$ns at 637.2906918696928 "$node_(697) setdest 114847 35576 13.0" 
$ns at 750.6370039713241 "$node_(697) setdest 1247 28198 14.0" 
$ns at 882.7381305463307 "$node_(697) setdest 4351 24807 2.0" 
$ns at 656.4847970849623 "$node_(698) setdest 46289 24388 3.0" 
$ns at 695.1809610967987 "$node_(698) setdest 67629 13773 7.0" 
$ns at 779.9467440003673 "$node_(698) setdest 2652 36784 14.0" 
$ns at 849.7615815651928 "$node_(698) setdest 74409 10992 16.0" 
$ns at 607.9163160510657 "$node_(699) setdest 84075 33828 3.0" 
$ns at 650.4803588470518 "$node_(699) setdest 46678 13093 7.0" 
$ns at 733.0955175939652 "$node_(699) setdest 126886 23136 7.0" 
$ns at 821.575332856969 "$node_(699) setdest 47754 11379 1.0" 
$ns at 857.3345616120592 "$node_(699) setdest 114245 26624 3.0" 
$ns at 761.6017673993381 "$node_(700) setdest 92849 3909 8.0" 
$ns at 798.7065851137111 "$node_(700) setdest 91443 6320 10.0" 
$ns at 845.3941114747217 "$node_(700) setdest 46357 8833 12.0" 
$ns at 778.5177736572406 "$node_(701) setdest 86059 23877 2.0" 
$ns at 821.1438646627871 "$node_(701) setdest 130382 22017 9.0" 
$ns at 870.3563434768313 "$node_(701) setdest 133213 20979 16.0" 
$ns at 736.986038445606 "$node_(702) setdest 57499 30731 9.0" 
$ns at 820.7480395566743 "$node_(702) setdest 100069 33363 11.0" 
$ns at 730.3157797076224 "$node_(703) setdest 101884 24393 17.0" 
$ns at 795.213919618066 "$node_(703) setdest 133701 853 9.0" 
$ns at 701.0864975931823 "$node_(704) setdest 53684 36247 18.0" 
$ns at 781.2944079859734 "$node_(704) setdest 35075 40317 6.0" 
$ns at 826.8878824946083 "$node_(704) setdest 122938 32681 15.0" 
$ns at 707.0081451866181 "$node_(705) setdest 68694 1273 14.0" 
$ns at 751.7548775142935 "$node_(705) setdest 83099 12938 15.0" 
$ns at 850.0893776079716 "$node_(705) setdest 38070 5593 3.0" 
$ns at 730.9153067110833 "$node_(706) setdest 65105 39234 3.0" 
$ns at 776.3104279636392 "$node_(706) setdest 125335 15602 6.0" 
$ns at 845.4588277832579 "$node_(706) setdest 128850 5429 9.0" 
$ns at 744.9737798144087 "$node_(707) setdest 23510 23270 3.0" 
$ns at 793.2852243831137 "$node_(707) setdest 30042 11706 1.0" 
$ns at 825.9447055420156 "$node_(707) setdest 71827 13365 14.0" 
$ns at 896.3920617216978 "$node_(707) setdest 102028 23126 18.0" 
$ns at 763.026554425553 "$node_(708) setdest 132844 12568 1.0" 
$ns at 796.4034035943868 "$node_(708) setdest 5858 2386 2.0" 
$ns at 826.661534406997 "$node_(708) setdest 120193 149 12.0" 
$ns at 864.1634917226983 "$node_(708) setdest 122098 27510 18.0" 
$ns at 809.3640720684341 "$node_(709) setdest 98682 777 18.0" 
$ns at 866.153047713516 "$node_(709) setdest 41402 39541 5.0" 
$ns at 776.8448762643175 "$node_(710) setdest 128592 14741 17.0" 
$ns at 886.2240417653641 "$node_(710) setdest 65321 22587 6.0" 
$ns at 709.7040391500914 "$node_(711) setdest 3676 21275 1.0" 
$ns at 746.8224356557912 "$node_(711) setdest 126951 19575 12.0" 
$ns at 839.0821986366144 "$node_(711) setdest 84147 35987 6.0" 
$ns at 884.7383826036588 "$node_(711) setdest 22491 1546 7.0" 
$ns at 736.1427132013174 "$node_(712) setdest 117989 17746 17.0" 
$ns at 866.5156834337664 "$node_(712) setdest 20171 12861 15.0" 
$ns at 738.9664861241488 "$node_(713) setdest 89700 12957 5.0" 
$ns at 774.0473353289898 "$node_(713) setdest 106690 6245 2.0" 
$ns at 815.468535915142 "$node_(713) setdest 84353 15098 4.0" 
$ns at 866.684801801644 "$node_(713) setdest 97533 43347 8.0" 
$ns at 719.9125342897196 "$node_(714) setdest 4478 20000 8.0" 
$ns at 752.6285202533215 "$node_(714) setdest 107712 5054 6.0" 
$ns at 805.2531349330584 "$node_(714) setdest 132219 28150 19.0" 
$ns at 845.2605895355518 "$node_(714) setdest 111578 17408 1.0" 
$ns at 884.2101460217933 "$node_(714) setdest 32319 37322 1.0" 
$ns at 725.5065546315438 "$node_(715) setdest 110066 4644 17.0" 
$ns at 796.1569963061004 "$node_(715) setdest 96420 31112 12.0" 
$ns at 703.3985179498909 "$node_(716) setdest 88913 18020 9.0" 
$ns at 789.851845125419 "$node_(716) setdest 122249 19821 13.0" 
$ns at 851.2852201775986 "$node_(716) setdest 18318 8772 7.0" 
$ns at 881.5552073216354 "$node_(716) setdest 126868 3942 15.0" 
$ns at 796.8306993985647 "$node_(717) setdest 75254 38220 9.0" 
$ns at 851.5074198947124 "$node_(717) setdest 40361 7309 8.0" 
$ns at 750.6403519299861 "$node_(718) setdest 41378 16465 17.0" 
$ns at 846.3734921436695 "$node_(719) setdest 943 30359 1.0" 
$ns at 883.1058617269629 "$node_(719) setdest 95704 38698 7.0" 
$ns at 723.5480530676216 "$node_(720) setdest 97276 27256 16.0" 
$ns at 805.4895737370069 "$node_(720) setdest 110558 39732 11.0" 
$ns at 767.9445558341193 "$node_(721) setdest 55699 15433 16.0" 
$ns at 848.2908416210017 "$node_(721) setdest 70913 16074 13.0" 
$ns at 863.1312926783121 "$node_(722) setdest 117502 22650 2.0" 
$ns at 743.0820251686688 "$node_(723) setdest 75413 16632 16.0" 
$ns at 843.4785545457652 "$node_(723) setdest 93134 32500 16.0" 
$ns at 740.3870176845005 "$node_(724) setdest 37056 19840 2.0" 
$ns at 775.6010049569425 "$node_(724) setdest 27363 4652 8.0" 
$ns at 882.4402956886803 "$node_(724) setdest 52374 38736 4.0" 
$ns at 741.4658920795473 "$node_(726) setdest 27698 3766 12.0" 
$ns at 870.2359346575362 "$node_(726) setdest 81817 36170 11.0" 
$ns at 819.4243619960098 "$node_(727) setdest 4184 44139 9.0" 
$ns at 743.6933487687328 "$node_(728) setdest 77394 25142 2.0" 
$ns at 787.720663789234 "$node_(728) setdest 17062 12166 1.0" 
$ns at 822.9176062313385 "$node_(728) setdest 32646 39790 3.0" 
$ns at 873.868063757032 "$node_(728) setdest 129827 2447 10.0" 
$ns at 722.7750894973833 "$node_(729) setdest 37782 32002 6.0" 
$ns at 803.3713795018073 "$node_(729) setdest 100746 33077 18.0" 
$ns at 886.5448201021784 "$node_(730) setdest 87965 23309 10.0" 
$ns at 735.5554123643019 "$node_(731) setdest 104662 31447 13.0" 
$ns at 818.1727190693358 "$node_(731) setdest 54532 22575 2.0" 
$ns at 852.5160729746594 "$node_(731) setdest 1475 22977 3.0" 
$ns at 893.4884751144455 "$node_(731) setdest 85822 9157 15.0" 
$ns at 759.0987683200183 "$node_(732) setdest 66980 2929 16.0" 
$ns at 846.0580573047557 "$node_(732) setdest 11486 42790 4.0" 
$ns at 881.0456451917394 "$node_(732) setdest 7925 18986 7.0" 
$ns at 760.5741797624736 "$node_(733) setdest 13616 32326 1.0" 
$ns at 796.612489929314 "$node_(733) setdest 37432 19877 11.0" 
$ns at 871.7023299275376 "$node_(733) setdest 131572 24504 4.0" 
$ns at 799.7909401281686 "$node_(734) setdest 10587 23602 13.0" 
$ns at 838.1561787138695 "$node_(735) setdest 78270 32049 15.0" 
$ns at 728.6946263382547 "$node_(736) setdest 92813 25118 9.0" 
$ns at 805.0105156757465 "$node_(736) setdest 5820 19288 5.0" 
$ns at 860.3748927694455 "$node_(736) setdest 45401 19046 6.0" 
$ns at 898.3357589079192 "$node_(736) setdest 103463 36850 12.0" 
$ns at 779.9973184226457 "$node_(737) setdest 38721 41006 8.0" 
$ns at 858.0008286268101 "$node_(737) setdest 129390 12069 18.0" 
$ns at 702.295852008898 "$node_(738) setdest 63563 5925 15.0" 
$ns at 830.2467917899254 "$node_(738) setdest 20242 35408 6.0" 
$ns at 866.6648500762279 "$node_(738) setdest 67816 26512 17.0" 
$ns at 707.3824263416236 "$node_(739) setdest 33184 25187 8.0" 
$ns at 790.8773505246265 "$node_(739) setdest 86878 43443 16.0" 
$ns at 701.5108821770242 "$node_(740) setdest 56798 21490 14.0" 
$ns at 809.5939427601286 "$node_(740) setdest 36140 35599 6.0" 
$ns at 851.4324863416107 "$node_(740) setdest 23238 10023 17.0" 
$ns at 707.3840143316339 "$node_(741) setdest 25133 13788 3.0" 
$ns at 753.8310117529843 "$node_(741) setdest 17364 9688 7.0" 
$ns at 810.4300786432901 "$node_(741) setdest 127458 27827 5.0" 
$ns at 879.9352123370893 "$node_(741) setdest 67214 35142 6.0" 
$ns at 778.3060989644448 "$node_(742) setdest 94163 30576 14.0" 
$ns at 884.1323265431207 "$node_(742) setdest 27056 37342 10.0" 
$ns at 750.3557384783251 "$node_(743) setdest 32890 20071 4.0" 
$ns at 794.5090577844592 "$node_(743) setdest 13801 23278 11.0" 
$ns at 827.5813056577429 "$node_(743) setdest 42962 17742 3.0" 
$ns at 861.275192310294 "$node_(743) setdest 117319 42356 17.0" 
$ns at 804.6185226473982 "$node_(744) setdest 30290 18105 19.0" 
$ns at 881.9875529349898 "$node_(744) setdest 122249 41358 19.0" 
$ns at 768.475454654966 "$node_(745) setdest 45120 18044 3.0" 
$ns at 827.9200896822908 "$node_(745) setdest 44874 12954 20.0" 
$ns at 714.7965544959022 "$node_(746) setdest 128364 31845 18.0" 
$ns at 768.5717836360054 "$node_(746) setdest 26706 26909 11.0" 
$ns at 891.1624523158923 "$node_(746) setdest 101324 23643 15.0" 
$ns at 828.3300842826585 "$node_(747) setdest 130282 32079 4.0" 
$ns at 864.4002546536826 "$node_(747) setdest 27834 28392 6.0" 
$ns at 894.8641091123596 "$node_(747) setdest 47659 3223 3.0" 
$ns at 715.8972762103317 "$node_(748) setdest 74215 4718 4.0" 
$ns at 767.7927275376926 "$node_(748) setdest 32802 21121 19.0" 
$ns at 702.273993030548 "$node_(749) setdest 10471 8453 19.0" 
$ns at 757.1433505262535 "$node_(749) setdest 125941 24721 17.0" 
$ns at 710.5205778010277 "$node_(750) setdest 14564 8523 9.0" 
$ns at 815.9158423244396 "$node_(750) setdest 115610 17011 15.0" 
$ns at 899.6119102858852 "$node_(750) setdest 18137 30532 19.0" 
$ns at 809.6154011019569 "$node_(751) setdest 87345 22603 8.0" 
$ns at 881.1612945752689 "$node_(751) setdest 81939 24273 7.0" 
$ns at 717.6734366702168 "$node_(752) setdest 29277 36123 10.0" 
$ns at 782.9716693259638 "$node_(752) setdest 43989 36359 3.0" 
$ns at 813.6526115249656 "$node_(752) setdest 64935 29766 9.0" 
$ns at 891.8712994957788 "$node_(752) setdest 104436 25875 6.0" 
$ns at 733.1870537137361 "$node_(753) setdest 44866 15805 7.0" 
$ns at 769.7112943146832 "$node_(753) setdest 131984 28680 15.0" 
$ns at 721.6986690827289 "$node_(754) setdest 54027 5595 15.0" 
$ns at 846.6161470520649 "$node_(754) setdest 69589 25289 5.0" 
$ns at 889.944923747794 "$node_(754) setdest 67492 44338 8.0" 
$ns at 764.0275504553649 "$node_(755) setdest 45703 15270 7.0" 
$ns at 834.1371269794 "$node_(755) setdest 67111 35196 6.0" 
$ns at 791.8605618771097 "$node_(756) setdest 18835 27050 20.0" 
$ns at 772.3527794119341 "$node_(757) setdest 134158 7724 18.0" 
$ns at 894.0877208345261 "$node_(757) setdest 24801 37041 19.0" 
$ns at 749.6860176636478 "$node_(758) setdest 18205 3810 4.0" 
$ns at 809.1870085182251 "$node_(758) setdest 41315 41906 1.0" 
$ns at 843.227427730184 "$node_(758) setdest 43387 4881 10.0" 
$ns at 893.7543798766973 "$node_(758) setdest 132309 30556 14.0" 
$ns at 711.0744084910946 "$node_(759) setdest 20446 4721 17.0" 
$ns at 831.5204585266406 "$node_(759) setdest 121246 39063 16.0" 
$ns at 877.4135069695672 "$node_(759) setdest 31749 14784 15.0" 
$ns at 756.2180078889357 "$node_(760) setdest 75428 24601 12.0" 
$ns at 839.8702648990252 "$node_(760) setdest 83104 7978 8.0" 
$ns at 764.8953871720308 "$node_(761) setdest 82666 34262 19.0" 
$ns at 889.4395864181831 "$node_(761) setdest 46743 21342 15.0" 
$ns at 739.0357720880352 "$node_(762) setdest 36133 17777 18.0" 
$ns at 824.5427969671375 "$node_(762) setdest 64560 27799 19.0" 
$ns at 883.415306442617 "$node_(762) setdest 107356 7785 4.0" 
$ns at 745.0027491314753 "$node_(763) setdest 76773 32816 4.0" 
$ns at 797.328854108314 "$node_(763) setdest 111611 13456 12.0" 
$ns at 837.6766682881417 "$node_(763) setdest 14243 25365 8.0" 
$ns at 718.1751929839018 "$node_(764) setdest 29133 8465 14.0" 
$ns at 767.8815583075534 "$node_(764) setdest 95356 18152 19.0" 
$ns at 827.5267258335481 "$node_(764) setdest 53202 26319 16.0" 
$ns at 726.241469797128 "$node_(765) setdest 99096 692 16.0" 
$ns at 712.1903145824242 "$node_(766) setdest 55200 11474 19.0" 
$ns at 821.1178841096305 "$node_(766) setdest 61362 22457 6.0" 
$ns at 894.9146961758935 "$node_(766) setdest 123804 38252 20.0" 
$ns at 832.430805491062 "$node_(767) setdest 4471 9952 13.0" 
$ns at 746.818907327674 "$node_(768) setdest 83396 40680 11.0" 
$ns at 833.2695996219014 "$node_(768) setdest 86540 24694 8.0" 
$ns at 869.9708894038373 "$node_(768) setdest 103187 4942 17.0" 
$ns at 721.6159577694636 "$node_(769) setdest 79924 30319 1.0" 
$ns at 752.3779419489632 "$node_(769) setdest 74461 40225 3.0" 
$ns at 797.5623522973194 "$node_(769) setdest 133709 33420 15.0" 
$ns at 729.4542078409243 "$node_(770) setdest 89437 23947 18.0" 
$ns at 862.4605413528705 "$node_(770) setdest 17704 1193 12.0" 
$ns at 726.6658753542447 "$node_(772) setdest 77800 35803 19.0" 
$ns at 837.8233482125676 "$node_(772) setdest 64010 44014 15.0" 
$ns at 868.9737415663258 "$node_(772) setdest 3980 36039 15.0" 
$ns at 710.0794427539602 "$node_(773) setdest 55611 13713 10.0" 
$ns at 834.0495426339583 "$node_(773) setdest 23237 39645 1.0" 
$ns at 869.9937315347684 "$node_(773) setdest 119757 5461 11.0" 
$ns at 785.6193636416124 "$node_(774) setdest 60028 40822 10.0" 
$ns at 827.1664730734158 "$node_(774) setdest 9803 38732 17.0" 
$ns at 763.2664608327719 "$node_(775) setdest 24920 25058 6.0" 
$ns at 794.0277734224507 "$node_(775) setdest 79804 25246 17.0" 
$ns at 713.4528881161245 "$node_(776) setdest 56659 9549 19.0" 
$ns at 788.0266046256717 "$node_(776) setdest 73594 9182 3.0" 
$ns at 829.7304585551282 "$node_(776) setdest 15082 21873 12.0" 
$ns at 716.3746355807086 "$node_(777) setdest 107641 12337 18.0" 
$ns at 795.3692648659799 "$node_(778) setdest 8273 19557 3.0" 
$ns at 836.5830177969937 "$node_(778) setdest 65568 21409 11.0" 
$ns at 714.9753828734962 "$node_(779) setdest 31095 29750 13.0" 
$ns at 745.2898463225919 "$node_(779) setdest 124551 41003 8.0" 
$ns at 819.5001950417004 "$node_(779) setdest 43822 12202 2.0" 
$ns at 862.00928430651 "$node_(779) setdest 117492 14800 16.0" 
$ns at 722.0268098380475 "$node_(780) setdest 57461 18118 17.0" 
$ns at 755.5297855576885 "$node_(780) setdest 95212 4287 9.0" 
$ns at 842.1488020489063 "$node_(780) setdest 121219 18108 11.0" 
$ns at 801.3210752864537 "$node_(781) setdest 119434 7248 10.0" 
$ns at 882.8550218973752 "$node_(781) setdest 116602 850 16.0" 
$ns at 705.1268761452125 "$node_(782) setdest 50254 24282 2.0" 
$ns at 754.8319280707225 "$node_(782) setdest 109481 10977 7.0" 
$ns at 801.9545411531371 "$node_(782) setdest 128962 766 2.0" 
$ns at 848.912300925057 "$node_(782) setdest 122471 40593 17.0" 
$ns at 793.1059339643915 "$node_(783) setdest 66322 3939 6.0" 
$ns at 882.6401823535277 "$node_(783) setdest 103473 25637 18.0" 
$ns at 782.1087401478959 "$node_(784) setdest 94896 42720 11.0" 
$ns at 866.0059187482825 "$node_(784) setdest 107879 33769 8.0" 
$ns at 718.2696220614182 "$node_(785) setdest 84966 11014 20.0" 
$ns at 769.6502196031728 "$node_(785) setdest 60063 34326 20.0" 
$ns at 812.8506003437763 "$node_(786) setdest 44582 2436 5.0" 
$ns at 891.7398887527337 "$node_(786) setdest 34422 40819 14.0" 
$ns at 718.391846275759 "$node_(787) setdest 25834 11593 7.0" 
$ns at 761.5944670468434 "$node_(787) setdest 9832 21930 5.0" 
$ns at 797.9732540197025 "$node_(787) setdest 52829 10670 17.0" 
$ns at 778.8888886564517 "$node_(788) setdest 89053 21562 12.0" 
$ns at 836.9405521188281 "$node_(788) setdest 82248 38877 20.0" 
$ns at 707.3473017440048 "$node_(789) setdest 19853 18303 12.0" 
$ns at 762.4756430189047 "$node_(789) setdest 119483 6596 17.0" 
$ns at 768.9125106014811 "$node_(790) setdest 116940 13452 5.0" 
$ns at 814.4204652373988 "$node_(790) setdest 62389 20275 10.0" 
$ns at 775.729892482781 "$node_(791) setdest 115368 20125 19.0" 
$ns at 844.6301043348815 "$node_(791) setdest 58175 38288 1.0" 
$ns at 883.319034888635 "$node_(791) setdest 51073 20395 5.0" 
$ns at 720.4186339203338 "$node_(792) setdest 124383 29171 19.0" 
$ns at 789.806143645909 "$node_(792) setdest 10209 12336 4.0" 
$ns at 835.3713112107712 "$node_(792) setdest 21584 3443 12.0" 
$ns at 897.7994599442181 "$node_(792) setdest 59470 479 13.0" 
$ns at 746.9595666294192 "$node_(793) setdest 72533 2852 20.0" 
$ns at 832.3438530979879 "$node_(793) setdest 66694 35229 14.0" 
$ns at 731.1534621734284 "$node_(794) setdest 43471 9277 14.0" 
$ns at 779.1371587189719 "$node_(794) setdest 122862 44126 6.0" 
$ns at 853.4526090678618 "$node_(794) setdest 98894 6666 9.0" 
$ns at 761.2312342805919 "$node_(795) setdest 12274 3598 5.0" 
$ns at 828.5012280396002 "$node_(795) setdest 13340 26268 15.0" 
$ns at 811.5123516828907 "$node_(796) setdest 55395 9072 16.0" 
$ns at 780.088858415638 "$node_(797) setdest 62621 18815 4.0" 
$ns at 823.7946883359048 "$node_(797) setdest 69447 22303 3.0" 
$ns at 877.7859396650709 "$node_(797) setdest 36642 11198 3.0" 
$ns at 711.551795668338 "$node_(798) setdest 7179 19186 18.0" 
$ns at 789.876525306433 "$node_(799) setdest 16641 40055 15.0" 
$ns at 857.63815433477 "$node_(799) setdest 17628 23632 1.0" 
$ns at 891.4047369105695 "$node_(799) setdest 130785 36028 10.0" 


#Set a TCP connection between node_(12) and node_(78)
set tcp_(0) [new Agent/TCP/Newreno]
$tcp_(0) set class_ 2
set sink_(0) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(0)
$ns attach-agent $node_(78) $sink_(0)
$ns connect $tcp_(0) $sink_(0)
set ftp_(0) [new Application/FTP]
$ftp_(0) attach-agent $tcp_(0)
$ns at 0.2 "$ftp_(0) start"
$ns at 180.0 "$ftp_(0) stop"

#Set a TCP connection between node_(8) and node_(99)
set tcp_(1) [new Agent/TCP/Newreno]
$tcp_(1) set class_ 2
set sink_(1) [new Agent/TCPSink]
$ns attach-agent $node_(8) $tcp_(1)
$ns attach-agent $node_(99) $sink_(1)
$ns connect $tcp_(1) $sink_(1)
set ftp_(1) [new Application/FTP]
$ftp_(1) attach-agent $tcp_(1)
$ns at 180.2 "$ftp_(1) start"
$ns at 360.0 "$ftp_(1) stop"

#Set a TCP connection between node_(71) and node_(42)
set tcp_(2) [new Agent/TCP/Newreno]
$tcp_(2) set class_ 2
set sink_(2) [new Agent/TCPSink]
$ns attach-agent $node_(71) $tcp_(2)
$ns attach-agent $node_(42) $sink_(2)
$ns connect $tcp_(2) $sink_(2)
set ftp_(2) [new Application/FTP]
$ftp_(2) attach-agent $tcp_(2)
$ns at 360.2 "$ftp_(2) start"
$ns at 540.0 "$ftp_(2) stop"

#Set a TCP connection between node_(97) and node_(10)
set tcp_(3) [new Agent/TCP/Newreno]
$tcp_(3) set class_ 2
set sink_(3) [new Agent/TCPSink]
$ns attach-agent $node_(97) $tcp_(3)
$ns attach-agent $node_(10) $sink_(3)
$ns connect $tcp_(3) $sink_(3)
set ftp_(3) [new Application/FTP]
$ftp_(3) attach-agent $tcp_(3)
$ns at 540.2 "$ftp_(3) start"
$ns at 720.0 "$ftp_(3) stop"

#Set a TCP connection between node_(42) and node_(81)
set tcp_(4) [new Agent/TCP/Newreno]
$tcp_(4) set class_ 2
set sink_(4) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(4)
$ns attach-agent $node_(81) $sink_(4)
$ns connect $tcp_(4) $sink_(4)
set ftp_(4) [new Application/FTP]
$ftp_(4) attach-agent $tcp_(4)
$ns at 720.2 "$ftp_(4) start"
$ns at 900.0 "$ftp_(4) stop"

#Set a TCP connection between node_(88) and node_(32)
set tcp_(5) [new Agent/TCP/Newreno]
$tcp_(5) set class_ 2
set sink_(5) [new Agent/TCPSink]
$ns attach-agent $node_(88) $tcp_(5)
$ns attach-agent $node_(32) $sink_(5)
$ns connect $tcp_(5) $sink_(5)
set ftp_(5) [new Application/FTP]
$ftp_(5) attach-agent $tcp_(5)
$ns at 0.2 "$ftp_(5) start"
$ns at 180.0 "$ftp_(5) stop"

#Set a TCP connection between node_(62) and node_(19)
set tcp_(6) [new Agent/TCP/Newreno]
$tcp_(6) set class_ 2
set sink_(6) [new Agent/TCPSink]
$ns attach-agent $node_(62) $tcp_(6)
$ns attach-agent $node_(19) $sink_(6)
$ns connect $tcp_(6) $sink_(6)
set ftp_(6) [new Application/FTP]
$ftp_(6) attach-agent $tcp_(6)
$ns at 180.2 "$ftp_(6) start"
$ns at 360.0 "$ftp_(6) stop"

#Set a TCP connection between node_(14) and node_(69)
set tcp_(7) [new Agent/TCP/Newreno]
$tcp_(7) set class_ 2
set sink_(7) [new Agent/TCPSink]
$ns attach-agent $node_(14) $tcp_(7)
$ns attach-agent $node_(69) $sink_(7)
$ns connect $tcp_(7) $sink_(7)
set ftp_(7) [new Application/FTP]
$ftp_(7) attach-agent $tcp_(7)
$ns at 360.2 "$ftp_(7) start"
$ns at 540.0 "$ftp_(7) stop"

#Set a TCP connection between node_(27) and node_(9)
set tcp_(8) [new Agent/TCP/Newreno]
$tcp_(8) set class_ 2
set sink_(8) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(8)
$ns attach-agent $node_(9) $sink_(8)
$ns connect $tcp_(8) $sink_(8)
set ftp_(8) [new Application/FTP]
$ftp_(8) attach-agent $tcp_(8)
$ns at 540.2 "$ftp_(8) start"
$ns at 720.0 "$ftp_(8) stop"

#Set a TCP connection between node_(41) and node_(62)
set tcp_(9) [new Agent/TCP/Newreno]
$tcp_(9) set class_ 2
set sink_(9) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(9)
$ns attach-agent $node_(62) $sink_(9)
$ns connect $tcp_(9) $sink_(9)
set ftp_(9) [new Application/FTP]
$ftp_(9) attach-agent $tcp_(9)
$ns at 720.2 "$ftp_(9) start"
$ns at 900.0 "$ftp_(9) stop"

#Set a TCP connection between node_(74) and node_(22)
set tcp_(10) [new Agent/TCP/Newreno]
$tcp_(10) set class_ 2
set sink_(10) [new Agent/TCPSink]
$ns attach-agent $node_(74) $tcp_(10)
$ns attach-agent $node_(22) $sink_(10)
$ns connect $tcp_(10) $sink_(10)
set ftp_(10) [new Application/FTP]
$ftp_(10) attach-agent $tcp_(10)
$ns at 0.2 "$ftp_(10) start"
$ns at 180.0 "$ftp_(10) stop"

#Set a TCP connection between node_(17) and node_(73)
set tcp_(11) [new Agent/TCP/Newreno]
$tcp_(11) set class_ 2
set sink_(11) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(11)
$ns attach-agent $node_(73) $sink_(11)
$ns connect $tcp_(11) $sink_(11)
set ftp_(11) [new Application/FTP]
$ftp_(11) attach-agent $tcp_(11)
$ns at 180.2 "$ftp_(11) start"
$ns at 360.0 "$ftp_(11) stop"

#Set a TCP connection between node_(49) and node_(31)
set tcp_(12) [new Agent/TCP/Newreno]
$tcp_(12) set class_ 2
set sink_(12) [new Agent/TCPSink]
$ns attach-agent $node_(49) $tcp_(12)
$ns attach-agent $node_(31) $sink_(12)
$ns connect $tcp_(12) $sink_(12)
set ftp_(12) [new Application/FTP]
$ftp_(12) attach-agent $tcp_(12)
$ns at 360.2 "$ftp_(12) start"
$ns at 540.0 "$ftp_(12) stop"

#Set a TCP connection between node_(78) and node_(44)
set tcp_(13) [new Agent/TCP/Newreno]
$tcp_(13) set class_ 2
set sink_(13) [new Agent/TCPSink]
$ns attach-agent $node_(78) $tcp_(13)
$ns attach-agent $node_(44) $sink_(13)
$ns connect $tcp_(13) $sink_(13)
set ftp_(13) [new Application/FTP]
$ftp_(13) attach-agent $tcp_(13)
$ns at 540.2 "$ftp_(13) start"
$ns at 720.0 "$ftp_(13) stop"

#Set a TCP connection between node_(85) and node_(22)
set tcp_(14) [new Agent/TCP/Newreno]
$tcp_(14) set class_ 2
set sink_(14) [new Agent/TCPSink]
$ns attach-agent $node_(85) $tcp_(14)
$ns attach-agent $node_(22) $sink_(14)
$ns connect $tcp_(14) $sink_(14)
set ftp_(14) [new Application/FTP]
$ftp_(14) attach-agent $tcp_(14)
$ns at 720.2 "$ftp_(14) start"
$ns at 900.0 "$ftp_(14) stop"

#Set a TCP connection between node_(94) and node_(35)
set tcp_(15) [new Agent/TCP/Newreno]
$tcp_(15) set class_ 2
set sink_(15) [new Agent/TCPSink]
$ns attach-agent $node_(94) $tcp_(15)
$ns attach-agent $node_(35) $sink_(15)
$ns connect $tcp_(15) $sink_(15)
set ftp_(15) [new Application/FTP]
$ftp_(15) attach-agent $tcp_(15)
$ns at 0.2 "$ftp_(15) start"
$ns at 180.0 "$ftp_(15) stop"

#Set a TCP connection between node_(10) and node_(8)
set tcp_(16) [new Agent/TCP/Newreno]
$tcp_(16) set class_ 2
set sink_(16) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(16)
$ns attach-agent $node_(8) $sink_(16)
$ns connect $tcp_(16) $sink_(16)
set ftp_(16) [new Application/FTP]
$ftp_(16) attach-agent $tcp_(16)
$ns at 180.2 "$ftp_(16) start"
$ns at 360.0 "$ftp_(16) stop"

#Set a TCP connection between node_(60) and node_(14)
set tcp_(17) [new Agent/TCP/Newreno]
$tcp_(17) set class_ 2
set sink_(17) [new Agent/TCPSink]
$ns attach-agent $node_(60) $tcp_(17)
$ns attach-agent $node_(14) $sink_(17)
$ns connect $tcp_(17) $sink_(17)
set ftp_(17) [new Application/FTP]
$ftp_(17) attach-agent $tcp_(17)
$ns at 360.2 "$ftp_(17) start"
$ns at 540.0 "$ftp_(17) stop"

#Set a TCP connection between node_(85) and node_(32)
set tcp_(18) [new Agent/TCP/Newreno]
$tcp_(18) set class_ 2
set sink_(18) [new Agent/TCPSink]
$ns attach-agent $node_(85) $tcp_(18)
$ns attach-agent $node_(32) $sink_(18)
$ns connect $tcp_(18) $sink_(18)
set ftp_(18) [new Application/FTP]
$ftp_(18) attach-agent $tcp_(18)
$ns at 540.2 "$ftp_(18) start"
$ns at 720.0 "$ftp_(18) stop"

#Set a TCP connection between node_(96) and node_(95)
set tcp_(19) [new Agent/TCP/Newreno]
$tcp_(19) set class_ 2
set sink_(19) [new Agent/TCPSink]
$ns attach-agent $node_(96) $tcp_(19)
$ns attach-agent $node_(95) $sink_(19)
$ns connect $tcp_(19) $sink_(19)
set ftp_(19) [new Application/FTP]
$ftp_(19) attach-agent $tcp_(19)
$ns at 720.2 "$ftp_(19) start"
$ns at 900.0 "$ftp_(19) stop"

#Set a TCP connection between node_(55) and node_(24)
set tcp_(20) [new Agent/TCP/Newreno]
$tcp_(20) set class_ 2
set sink_(20) [new Agent/TCPSink]
$ns attach-agent $node_(55) $tcp_(20)
$ns attach-agent $node_(24) $sink_(20)
$ns connect $tcp_(20) $sink_(20)
set ftp_(20) [new Application/FTP]
$ftp_(20) attach-agent $tcp_(20)
$ns at 0.2 "$ftp_(20) start"
$ns at 180.0 "$ftp_(20) stop"

#Set a TCP connection between node_(70) and node_(59)
set tcp_(21) [new Agent/TCP/Newreno]
$tcp_(21) set class_ 2
set sink_(21) [new Agent/TCPSink]
$ns attach-agent $node_(70) $tcp_(21)
$ns attach-agent $node_(59) $sink_(21)
$ns connect $tcp_(21) $sink_(21)
set ftp_(21) [new Application/FTP]
$ftp_(21) attach-agent $tcp_(21)
$ns at 180.2 "$ftp_(21) start"
$ns at 360.0 "$ftp_(21) stop"

#Set a TCP connection between node_(56) and node_(25)
set tcp_(22) [new Agent/TCP/Newreno]
$tcp_(22) set class_ 2
set sink_(22) [new Agent/TCPSink]
$ns attach-agent $node_(56) $tcp_(22)
$ns attach-agent $node_(25) $sink_(22)
$ns connect $tcp_(22) $sink_(22)
set ftp_(22) [new Application/FTP]
$ftp_(22) attach-agent $tcp_(22)
$ns at 360.2 "$ftp_(22) start"
$ns at 540.0 "$ftp_(22) stop"

#Set a TCP connection between node_(33) and node_(81)
set tcp_(23) [new Agent/TCP/Newreno]
$tcp_(23) set class_ 2
set sink_(23) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(23)
$ns attach-agent $node_(81) $sink_(23)
$ns connect $tcp_(23) $sink_(23)
set ftp_(23) [new Application/FTP]
$ftp_(23) attach-agent $tcp_(23)
$ns at 540.2 "$ftp_(23) start"
$ns at 720.0 "$ftp_(23) stop"

#Set a TCP connection between node_(7) and node_(98)
set tcp_(24) [new Agent/TCP/Newreno]
$tcp_(24) set class_ 2
set sink_(24) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(24)
$ns attach-agent $node_(98) $sink_(24)
$ns connect $tcp_(24) $sink_(24)
set ftp_(24) [new Application/FTP]
$ftp_(24) attach-agent $tcp_(24)
$ns at 720.2 "$ftp_(24) start"
$ns at 900.0 "$ftp_(24) stop"

#Set a TCP connection between node_(61) and node_(22)
set tcp_(25) [new Agent/TCP/Newreno]
$tcp_(25) set class_ 2
set sink_(25) [new Agent/TCPSink]
$ns attach-agent $node_(61) $tcp_(25)
$ns attach-agent $node_(22) $sink_(25)
$ns connect $tcp_(25) $sink_(25)
set ftp_(25) [new Application/FTP]
$ftp_(25) attach-agent $tcp_(25)
$ns at 0.2 "$ftp_(25) start"
$ns at 180.0 "$ftp_(25) stop"

#Set a TCP connection between node_(33) and node_(39)
set tcp_(26) [new Agent/TCP/Newreno]
$tcp_(26) set class_ 2
set sink_(26) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(26)
$ns attach-agent $node_(39) $sink_(26)
$ns connect $tcp_(26) $sink_(26)
set ftp_(26) [new Application/FTP]
$ftp_(26) attach-agent $tcp_(26)
$ns at 180.2 "$ftp_(26) start"
$ns at 360.0 "$ftp_(26) stop"

#Set a TCP connection between node_(15) and node_(38)
set tcp_(27) [new Agent/TCP/Newreno]
$tcp_(27) set class_ 2
set sink_(27) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(27)
$ns attach-agent $node_(38) $sink_(27)
$ns connect $tcp_(27) $sink_(27)
set ftp_(27) [new Application/FTP]
$ftp_(27) attach-agent $tcp_(27)
$ns at 360.2 "$ftp_(27) start"
$ns at 540.0 "$ftp_(27) stop"

#Set a TCP connection between node_(31) and node_(93)
set tcp_(28) [new Agent/TCP/Newreno]
$tcp_(28) set class_ 2
set sink_(28) [new Agent/TCPSink]
$ns attach-agent $node_(31) $tcp_(28)
$ns attach-agent $node_(93) $sink_(28)
$ns connect $tcp_(28) $sink_(28)
set ftp_(28) [new Application/FTP]
$ftp_(28) attach-agent $tcp_(28)
$ns at 540.2 "$ftp_(28) start"
$ns at 720.0 "$ftp_(28) stop"

#Set a TCP connection between node_(84) and node_(95)
set tcp_(29) [new Agent/TCP/Newreno]
$tcp_(29) set class_ 2
set sink_(29) [new Agent/TCPSink]
$ns attach-agent $node_(84) $tcp_(29)
$ns attach-agent $node_(95) $sink_(29)
$ns connect $tcp_(29) $sink_(29)
set ftp_(29) [new Application/FTP]
$ftp_(29) attach-agent $tcp_(29)
$ns at 720.2 "$ftp_(29) start"
$ns at 900.0 "$ftp_(29) stop"

#Set a TCP connection between node_(5) and node_(77)
set tcp_(30) [new Agent/TCP/Newreno]
$tcp_(30) set class_ 2
set sink_(30) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(30)
$ns attach-agent $node_(77) $sink_(30)
$ns connect $tcp_(30) $sink_(30)
set ftp_(30) [new Application/FTP]
$ftp_(30) attach-agent $tcp_(30)
$ns at 0.2 "$ftp_(30) start"
$ns at 180.0 "$ftp_(30) stop"

#Set a TCP connection between node_(61) and node_(65)
set tcp_(31) [new Agent/TCP/Newreno]
$tcp_(31) set class_ 2
set sink_(31) [new Agent/TCPSink]
$ns attach-agent $node_(61) $tcp_(31)
$ns attach-agent $node_(65) $sink_(31)
$ns connect $tcp_(31) $sink_(31)
set ftp_(31) [new Application/FTP]
$ftp_(31) attach-agent $tcp_(31)
$ns at 180.2 "$ftp_(31) start"
$ns at 360.0 "$ftp_(31) stop"

#Set a TCP connection between node_(35) and node_(73)
set tcp_(32) [new Agent/TCP/Newreno]
$tcp_(32) set class_ 2
set sink_(32) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(32)
$ns attach-agent $node_(73) $sink_(32)
$ns connect $tcp_(32) $sink_(32)
set ftp_(32) [new Application/FTP]
$ftp_(32) attach-agent $tcp_(32)
$ns at 360.2 "$ftp_(32) start"
$ns at 540.0 "$ftp_(32) stop"

#Set a TCP connection between node_(60) and node_(94)
set tcp_(33) [new Agent/TCP/Newreno]
$tcp_(33) set class_ 2
set sink_(33) [new Agent/TCPSink]
$ns attach-agent $node_(60) $tcp_(33)
$ns attach-agent $node_(94) $sink_(33)
$ns connect $tcp_(33) $sink_(33)
set ftp_(33) [new Application/FTP]
$ftp_(33) attach-agent $tcp_(33)
$ns at 540.2 "$ftp_(33) start"
$ns at 720.0 "$ftp_(33) stop"

#Set a TCP connection between node_(50) and node_(0)
set tcp_(34) [new Agent/TCP/Newreno]
$tcp_(34) set class_ 2
set sink_(34) [new Agent/TCPSink]
$ns attach-agent $node_(50) $tcp_(34)
$ns attach-agent $node_(0) $sink_(34)
$ns connect $tcp_(34) $sink_(34)
set ftp_(34) [new Application/FTP]
$ftp_(34) attach-agent $tcp_(34)
$ns at 720.2 "$ftp_(34) start"
$ns at 900.0 "$ftp_(34) stop"

#Set a TCP connection between node_(65) and node_(79)
set tcp_(35) [new Agent/TCP/Newreno]
$tcp_(35) set class_ 2
set sink_(35) [new Agent/TCPSink]
$ns attach-agent $node_(65) $tcp_(35)
$ns attach-agent $node_(79) $sink_(35)
$ns connect $tcp_(35) $sink_(35)
set ftp_(35) [new Application/FTP]
$ftp_(35) attach-agent $tcp_(35)
$ns at 0.2 "$ftp_(35) start"
$ns at 180.0 "$ftp_(35) stop"

#Set a TCP connection between node_(71) and node_(92)
set tcp_(36) [new Agent/TCP/Newreno]
$tcp_(36) set class_ 2
set sink_(36) [new Agent/TCPSink]
$ns attach-agent $node_(71) $tcp_(36)
$ns attach-agent $node_(92) $sink_(36)
$ns connect $tcp_(36) $sink_(36)
set ftp_(36) [new Application/FTP]
$ftp_(36) attach-agent $tcp_(36)
$ns at 180.2 "$ftp_(36) start"
$ns at 360.0 "$ftp_(36) stop"

#Set a TCP connection between node_(82) and node_(20)
set tcp_(37) [new Agent/TCP/Newreno]
$tcp_(37) set class_ 2
set sink_(37) [new Agent/TCPSink]
$ns attach-agent $node_(82) $tcp_(37)
$ns attach-agent $node_(20) $sink_(37)
$ns connect $tcp_(37) $sink_(37)
set ftp_(37) [new Application/FTP]
$ftp_(37) attach-agent $tcp_(37)
$ns at 360.2 "$ftp_(37) start"
$ns at 540.0 "$ftp_(37) stop"

#Set a TCP connection between node_(97) and node_(54)
set tcp_(38) [new Agent/TCP/Newreno]
$tcp_(38) set class_ 2
set sink_(38) [new Agent/TCPSink]
$ns attach-agent $node_(97) $tcp_(38)
$ns attach-agent $node_(54) $sink_(38)
$ns connect $tcp_(38) $sink_(38)
set ftp_(38) [new Application/FTP]
$ftp_(38) attach-agent $tcp_(38)
$ns at 540.2 "$ftp_(38) start"
$ns at 720.0 "$ftp_(38) stop"

#Set a TCP connection between node_(74) and node_(4)
set tcp_(39) [new Agent/TCP/Newreno]
$tcp_(39) set class_ 2
set sink_(39) [new Agent/TCPSink]
$ns attach-agent $node_(74) $tcp_(39)
$ns attach-agent $node_(4) $sink_(39)
$ns connect $tcp_(39) $sink_(39)
set ftp_(39) [new Application/FTP]
$ftp_(39) attach-agent $tcp_(39)
$ns at 720.2 "$ftp_(39) start"
$ns at 900.0 "$ftp_(39) stop"

#Set a TCP connection between node_(92) and node_(16)
set tcp_(40) [new Agent/TCP/Newreno]
$tcp_(40) set class_ 2
set sink_(40) [new Agent/TCPSink]
$ns attach-agent $node_(92) $tcp_(40)
$ns attach-agent $node_(16) $sink_(40)
$ns connect $tcp_(40) $sink_(40)
set ftp_(40) [new Application/FTP]
$ftp_(40) attach-agent $tcp_(40)
$ns at 0.2 "$ftp_(40) start"
$ns at 180.0 "$ftp_(40) stop"

#Set a TCP connection between node_(47) and node_(37)
set tcp_(41) [new Agent/TCP/Newreno]
$tcp_(41) set class_ 2
set sink_(41) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(41)
$ns attach-agent $node_(37) $sink_(41)
$ns connect $tcp_(41) $sink_(41)
set ftp_(41) [new Application/FTP]
$ftp_(41) attach-agent $tcp_(41)
$ns at 180.2 "$ftp_(41) start"
$ns at 360.0 "$ftp_(41) stop"

#Set a TCP connection between node_(84) and node_(14)
set tcp_(42) [new Agent/TCP/Newreno]
$tcp_(42) set class_ 2
set sink_(42) [new Agent/TCPSink]
$ns attach-agent $node_(84) $tcp_(42)
$ns attach-agent $node_(14) $sink_(42)
$ns connect $tcp_(42) $sink_(42)
set ftp_(42) [new Application/FTP]
$ftp_(42) attach-agent $tcp_(42)
$ns at 360.2 "$ftp_(42) start"
$ns at 540.0 "$ftp_(42) stop"

#Set a TCP connection between node_(54) and node_(53)
set tcp_(43) [new Agent/TCP/Newreno]
$tcp_(43) set class_ 2
set sink_(43) [new Agent/TCPSink]
$ns attach-agent $node_(54) $tcp_(43)
$ns attach-agent $node_(53) $sink_(43)
$ns connect $tcp_(43) $sink_(43)
set ftp_(43) [new Application/FTP]
$ftp_(43) attach-agent $tcp_(43)
$ns at 540.2 "$ftp_(43) start"
$ns at 720.0 "$ftp_(43) stop"

#Set a TCP connection between node_(93) and node_(89)
set tcp_(44) [new Agent/TCP/Newreno]
$tcp_(44) set class_ 2
set sink_(44) [new Agent/TCPSink]
$ns attach-agent $node_(93) $tcp_(44)
$ns attach-agent $node_(89) $sink_(44)
$ns connect $tcp_(44) $sink_(44)
set ftp_(44) [new Application/FTP]
$ftp_(44) attach-agent $tcp_(44)
$ns at 720.2 "$ftp_(44) start"
$ns at 900.0 "$ftp_(44) stop"

#Set a TCP connection between node_(41) and node_(28)
set tcp_(45) [new Agent/TCP/Newreno]
$tcp_(45) set class_ 2
set sink_(45) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(45)
$ns attach-agent $node_(28) $sink_(45)
$ns connect $tcp_(45) $sink_(45)
set ftp_(45) [new Application/FTP]
$ftp_(45) attach-agent $tcp_(45)
$ns at 0.2 "$ftp_(45) start"
$ns at 180.0 "$ftp_(45) stop"

#Set a TCP connection between node_(24) and node_(5)
set tcp_(46) [new Agent/TCP/Newreno]
$tcp_(46) set class_ 2
set sink_(46) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(46)
$ns attach-agent $node_(5) $sink_(46)
$ns connect $tcp_(46) $sink_(46)
set ftp_(46) [new Application/FTP]
$ftp_(46) attach-agent $tcp_(46)
$ns at 180.2 "$ftp_(46) start"
$ns at 360.0 "$ftp_(46) stop"

#Set a TCP connection between node_(22) and node_(57)
set tcp_(47) [new Agent/TCP/Newreno]
$tcp_(47) set class_ 2
set sink_(47) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(47)
$ns attach-agent $node_(57) $sink_(47)
$ns connect $tcp_(47) $sink_(47)
set ftp_(47) [new Application/FTP]
$ftp_(47) attach-agent $tcp_(47)
$ns at 360.2 "$ftp_(47) start"
$ns at 540.0 "$ftp_(47) stop"

#Set a TCP connection between node_(19) and node_(31)
set tcp_(48) [new Agent/TCP/Newreno]
$tcp_(48) set class_ 2
set sink_(48) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(48)
$ns attach-agent $node_(31) $sink_(48)
$ns connect $tcp_(48) $sink_(48)
set ftp_(48) [new Application/FTP]
$ftp_(48) attach-agent $tcp_(48)
$ns at 540.2 "$ftp_(48) start"
$ns at 720.0 "$ftp_(48) stop"

#Set a TCP connection between node_(49) and node_(16)
set tcp_(49) [new Agent/TCP/Newreno]
$tcp_(49) set class_ 2
set sink_(49) [new Agent/TCPSink]
$ns attach-agent $node_(49) $tcp_(49)
$ns attach-agent $node_(16) $sink_(49)
$ns connect $tcp_(49) $sink_(49)
set ftp_(49) [new Application/FTP]
$ftp_(49) attach-agent $tcp_(49)
$ns at 720.2 "$ftp_(49) start"
$ns at 900.0 "$ftp_(49) stop"

#Set a TCP connection between node_(27) and node_(44)
set tcp_(50) [new Agent/TCP/Newreno]
$tcp_(50) set class_ 2
set sink_(50) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(50)
$ns attach-agent $node_(44) $sink_(50)
$ns connect $tcp_(50) $sink_(50)
set ftp_(50) [new Application/FTP]
$ftp_(50) attach-agent $tcp_(50)
$ns at 0.2 "$ftp_(50) start"
$ns at 180.0 "$ftp_(50) stop"

#Set a TCP connection between node_(62) and node_(48)
set tcp_(51) [new Agent/TCP/Newreno]
$tcp_(51) set class_ 2
set sink_(51) [new Agent/TCPSink]
$ns attach-agent $node_(62) $tcp_(51)
$ns attach-agent $node_(48) $sink_(51)
$ns connect $tcp_(51) $sink_(51)
set ftp_(51) [new Application/FTP]
$ftp_(51) attach-agent $tcp_(51)
$ns at 180.2 "$ftp_(51) start"
$ns at 360.0 "$ftp_(51) stop"

#Set a TCP connection between node_(31) and node_(96)
set tcp_(52) [new Agent/TCP/Newreno]
$tcp_(52) set class_ 2
set sink_(52) [new Agent/TCPSink]
$ns attach-agent $node_(31) $tcp_(52)
$ns attach-agent $node_(96) $sink_(52)
$ns connect $tcp_(52) $sink_(52)
set ftp_(52) [new Application/FTP]
$ftp_(52) attach-agent $tcp_(52)
$ns at 360.2 "$ftp_(52) start"
$ns at 540.0 "$ftp_(52) stop"

#Set a TCP connection between node_(50) and node_(41)
set tcp_(53) [new Agent/TCP/Newreno]
$tcp_(53) set class_ 2
set sink_(53) [new Agent/TCPSink]
$ns attach-agent $node_(50) $tcp_(53)
$ns attach-agent $node_(41) $sink_(53)
$ns connect $tcp_(53) $sink_(53)
set ftp_(53) [new Application/FTP]
$ftp_(53) attach-agent $tcp_(53)
$ns at 540.2 "$ftp_(53) start"
$ns at 720.0 "$ftp_(53) stop"

#Set a TCP connection between node_(30) and node_(16)
set tcp_(54) [new Agent/TCP/Newreno]
$tcp_(54) set class_ 2
set sink_(54) [new Agent/TCPSink]
$ns attach-agent $node_(30) $tcp_(54)
$ns attach-agent $node_(16) $sink_(54)
$ns connect $tcp_(54) $sink_(54)
set ftp_(54) [new Application/FTP]
$ftp_(54) attach-agent $tcp_(54)
$ns at 720.2 "$ftp_(54) start"
$ns at 900.0 "$ftp_(54) stop"

#Set a TCP connection between node_(87) and node_(97)
set tcp_(55) [new Agent/TCP/Newreno]
$tcp_(55) set class_ 2
set sink_(55) [new Agent/TCPSink]
$ns attach-agent $node_(87) $tcp_(55)
$ns attach-agent $node_(97) $sink_(55)
$ns connect $tcp_(55) $sink_(55)
set ftp_(55) [new Application/FTP]
$ftp_(55) attach-agent $tcp_(55)
$ns at 0.2 "$ftp_(55) start"
$ns at 180.0 "$ftp_(55) stop"

#Set a TCP connection between node_(69) and node_(42)
set tcp_(56) [new Agent/TCP/Newreno]
$tcp_(56) set class_ 2
set sink_(56) [new Agent/TCPSink]
$ns attach-agent $node_(69) $tcp_(56)
$ns attach-agent $node_(42) $sink_(56)
$ns connect $tcp_(56) $sink_(56)
set ftp_(56) [new Application/FTP]
$ftp_(56) attach-agent $tcp_(56)
$ns at 180.2 "$ftp_(56) start"
$ns at 360.0 "$ftp_(56) stop"

#Set a TCP connection between node_(21) and node_(55)
set tcp_(57) [new Agent/TCP/Newreno]
$tcp_(57) set class_ 2
set sink_(57) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(57)
$ns attach-agent $node_(55) $sink_(57)
$ns connect $tcp_(57) $sink_(57)
set ftp_(57) [new Application/FTP]
$ftp_(57) attach-agent $tcp_(57)
$ns at 360.2 "$ftp_(57) start"
$ns at 540.0 "$ftp_(57) stop"

#Set a TCP connection between node_(16) and node_(69)
set tcp_(58) [new Agent/TCP/Newreno]
$tcp_(58) set class_ 2
set sink_(58) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(58)
$ns attach-agent $node_(69) $sink_(58)
$ns connect $tcp_(58) $sink_(58)
set ftp_(58) [new Application/FTP]
$ftp_(58) attach-agent $tcp_(58)
$ns at 540.2 "$ftp_(58) start"
$ns at 720.0 "$ftp_(58) stop"

#Set a TCP connection between node_(89) and node_(99)
set tcp_(59) [new Agent/TCP/Newreno]
$tcp_(59) set class_ 2
set sink_(59) [new Agent/TCPSink]
$ns attach-agent $node_(89) $tcp_(59)
$ns attach-agent $node_(99) $sink_(59)
$ns connect $tcp_(59) $sink_(59)
set ftp_(59) [new Application/FTP]
$ftp_(59) attach-agent $tcp_(59)
$ns at 720.2 "$ftp_(59) start"
$ns at 900.0 "$ftp_(59) stop"

#Set a TCP connection between node_(46) and node_(94)
set tcp_(60) [new Agent/TCP/Newreno]
$tcp_(60) set class_ 2
set sink_(60) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(60)
$ns attach-agent $node_(94) $sink_(60)
$ns connect $tcp_(60) $sink_(60)
set ftp_(60) [new Application/FTP]
$ftp_(60) attach-agent $tcp_(60)
$ns at 0.2 "$ftp_(60) start"
$ns at 180.0 "$ftp_(60) stop"

#Set a TCP connection between node_(65) and node_(68)
set tcp_(61) [new Agent/TCP/Newreno]
$tcp_(61) set class_ 2
set sink_(61) [new Agent/TCPSink]
$ns attach-agent $node_(65) $tcp_(61)
$ns attach-agent $node_(68) $sink_(61)
$ns connect $tcp_(61) $sink_(61)
set ftp_(61) [new Application/FTP]
$ftp_(61) attach-agent $tcp_(61)
$ns at 180.2 "$ftp_(61) start"
$ns at 360.0 "$ftp_(61) stop"

#Set a TCP connection between node_(50) and node_(8)
set tcp_(62) [new Agent/TCP/Newreno]
$tcp_(62) set class_ 2
set sink_(62) [new Agent/TCPSink]
$ns attach-agent $node_(50) $tcp_(62)
$ns attach-agent $node_(8) $sink_(62)
$ns connect $tcp_(62) $sink_(62)
set ftp_(62) [new Application/FTP]
$ftp_(62) attach-agent $tcp_(62)
$ns at 360.2 "$ftp_(62) start"
$ns at 540.0 "$ftp_(62) stop"

#Set a TCP connection between node_(84) and node_(2)
set tcp_(63) [new Agent/TCP/Newreno]
$tcp_(63) set class_ 2
set sink_(63) [new Agent/TCPSink]
$ns attach-agent $node_(84) $tcp_(63)
$ns attach-agent $node_(2) $sink_(63)
$ns connect $tcp_(63) $sink_(63)
set ftp_(63) [new Application/FTP]
$ftp_(63) attach-agent $tcp_(63)
$ns at 540.2 "$ftp_(63) start"
$ns at 720.0 "$ftp_(63) stop"

#Set a TCP connection between node_(46) and node_(94)
set tcp_(64) [new Agent/TCP/Newreno]
$tcp_(64) set class_ 2
set sink_(64) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(64)
$ns attach-agent $node_(94) $sink_(64)
$ns connect $tcp_(64) $sink_(64)
set ftp_(64) [new Application/FTP]
$ftp_(64) attach-agent $tcp_(64)
$ns at 720.2 "$ftp_(64) start"
$ns at 900.0 "$ftp_(64) stop"

#Set a TCP connection between node_(29) and node_(34)
set tcp_(65) [new Agent/TCP/Newreno]
$tcp_(65) set class_ 2
set sink_(65) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(65)
$ns attach-agent $node_(34) $sink_(65)
$ns connect $tcp_(65) $sink_(65)
set ftp_(65) [new Application/FTP]
$ftp_(65) attach-agent $tcp_(65)
$ns at 0.2 "$ftp_(65) start"
$ns at 180.0 "$ftp_(65) stop"

#Set a TCP connection between node_(53) and node_(1)
set tcp_(66) [new Agent/TCP/Newreno]
$tcp_(66) set class_ 2
set sink_(66) [new Agent/TCPSink]
$ns attach-agent $node_(53) $tcp_(66)
$ns attach-agent $node_(1) $sink_(66)
$ns connect $tcp_(66) $sink_(66)
set ftp_(66) [new Application/FTP]
$ftp_(66) attach-agent $tcp_(66)
$ns at 180.2 "$ftp_(66) start"
$ns at 360.0 "$ftp_(66) stop"

#Set a TCP connection between node_(71) and node_(52)
set tcp_(67) [new Agent/TCP/Newreno]
$tcp_(67) set class_ 2
set sink_(67) [new Agent/TCPSink]
$ns attach-agent $node_(71) $tcp_(67)
$ns attach-agent $node_(52) $sink_(67)
$ns connect $tcp_(67) $sink_(67)
set ftp_(67) [new Application/FTP]
$ftp_(67) attach-agent $tcp_(67)
$ns at 360.2 "$ftp_(67) start"
$ns at 540.0 "$ftp_(67) stop"

#Set a TCP connection between node_(40) and node_(80)
set tcp_(68) [new Agent/TCP/Newreno]
$tcp_(68) set class_ 2
set sink_(68) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(68)
$ns attach-agent $node_(80) $sink_(68)
$ns connect $tcp_(68) $sink_(68)
set ftp_(68) [new Application/FTP]
$ftp_(68) attach-agent $tcp_(68)
$ns at 540.2 "$ftp_(68) start"
$ns at 720.0 "$ftp_(68) stop"

#Set a TCP connection between node_(83) and node_(95)
set tcp_(69) [new Agent/TCP/Newreno]
$tcp_(69) set class_ 2
set sink_(69) [new Agent/TCPSink]
$ns attach-agent $node_(83) $tcp_(69)
$ns attach-agent $node_(95) $sink_(69)
$ns connect $tcp_(69) $sink_(69)
set ftp_(69) [new Application/FTP]
$ftp_(69) attach-agent $tcp_(69)
$ns at 720.2 "$ftp_(69) start"
$ns at 900.0 "$ftp_(69) stop"

#Set a TCP connection between node_(82) and node_(41)
set tcp_(70) [new Agent/TCP/Newreno]
$tcp_(70) set class_ 2
set sink_(70) [new Agent/TCPSink]
$ns attach-agent $node_(82) $tcp_(70)
$ns attach-agent $node_(41) $sink_(70)
$ns connect $tcp_(70) $sink_(70)
set ftp_(70) [new Application/FTP]
$ftp_(70) attach-agent $tcp_(70)
$ns at 0.2 "$ftp_(70) start"
$ns at 180.0 "$ftp_(70) stop"

#Set a TCP connection between node_(36) and node_(27)
set tcp_(71) [new Agent/TCP/Newreno]
$tcp_(71) set class_ 2
set sink_(71) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(71)
$ns attach-agent $node_(27) $sink_(71)
$ns connect $tcp_(71) $sink_(71)
set ftp_(71) [new Application/FTP]
$ftp_(71) attach-agent $tcp_(71)
$ns at 180.2 "$ftp_(71) start"
$ns at 360.0 "$ftp_(71) stop"

#Set a TCP connection between node_(34) and node_(20)
set tcp_(72) [new Agent/TCP/Newreno]
$tcp_(72) set class_ 2
set sink_(72) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(72)
$ns attach-agent $node_(20) $sink_(72)
$ns connect $tcp_(72) $sink_(72)
set ftp_(72) [new Application/FTP]
$ftp_(72) attach-agent $tcp_(72)
$ns at 360.2 "$ftp_(72) start"
$ns at 540.0 "$ftp_(72) stop"

#Set a TCP connection between node_(75) and node_(14)
set tcp_(73) [new Agent/TCP/Newreno]
$tcp_(73) set class_ 2
set sink_(73) [new Agent/TCPSink]
$ns attach-agent $node_(75) $tcp_(73)
$ns attach-agent $node_(14) $sink_(73)
$ns connect $tcp_(73) $sink_(73)
set ftp_(73) [new Application/FTP]
$ftp_(73) attach-agent $tcp_(73)
$ns at 540.2 "$ftp_(73) start"
$ns at 720.0 "$ftp_(73) stop"

#Set a TCP connection between node_(3) and node_(32)
set tcp_(74) [new Agent/TCP/Newreno]
$tcp_(74) set class_ 2
set sink_(74) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(74)
$ns attach-agent $node_(32) $sink_(74)
$ns connect $tcp_(74) $sink_(74)
set ftp_(74) [new Application/FTP]
$ftp_(74) attach-agent $tcp_(74)
$ns at 720.2 "$ftp_(74) start"
$ns at 900.0 "$ftp_(74) stop"

#Set a TCP connection between node_(84) and node_(17)
set tcp_(75) [new Agent/TCP/Newreno]
$tcp_(75) set class_ 2
set sink_(75) [new Agent/TCPSink]
$ns attach-agent $node_(84) $tcp_(75)
$ns attach-agent $node_(17) $sink_(75)
$ns connect $tcp_(75) $sink_(75)
set ftp_(75) [new Application/FTP]
$ftp_(75) attach-agent $tcp_(75)
$ns at 0.2 "$ftp_(75) start"
$ns at 180.0 "$ftp_(75) stop"

#Set a TCP connection between node_(86) and node_(12)
set tcp_(76) [new Agent/TCP/Newreno]
$tcp_(76) set class_ 2
set sink_(76) [new Agent/TCPSink]
$ns attach-agent $node_(86) $tcp_(76)
$ns attach-agent $node_(12) $sink_(76)
$ns connect $tcp_(76) $sink_(76)
set ftp_(76) [new Application/FTP]
$ftp_(76) attach-agent $tcp_(76)
$ns at 180.2 "$ftp_(76) start"
$ns at 360.0 "$ftp_(76) stop"

#Set a TCP connection between node_(78) and node_(31)
set tcp_(77) [new Agent/TCP/Newreno]
$tcp_(77) set class_ 2
set sink_(77) [new Agent/TCPSink]
$ns attach-agent $node_(78) $tcp_(77)
$ns attach-agent $node_(31) $sink_(77)
$ns connect $tcp_(77) $sink_(77)
set ftp_(77) [new Application/FTP]
$ftp_(77) attach-agent $tcp_(77)
$ns at 360.2 "$ftp_(77) start"
$ns at 540.0 "$ftp_(77) stop"

#Set a TCP connection between node_(61) and node_(68)
set tcp_(78) [new Agent/TCP/Newreno]
$tcp_(78) set class_ 2
set sink_(78) [new Agent/TCPSink]
$ns attach-agent $node_(61) $tcp_(78)
$ns attach-agent $node_(68) $sink_(78)
$ns connect $tcp_(78) $sink_(78)
set ftp_(78) [new Application/FTP]
$ftp_(78) attach-agent $tcp_(78)
$ns at 540.2 "$ftp_(78) start"
$ns at 720.0 "$ftp_(78) stop"

#Set a TCP connection between node_(76) and node_(23)
set tcp_(79) [new Agent/TCP/Newreno]
$tcp_(79) set class_ 2
set sink_(79) [new Agent/TCPSink]
$ns attach-agent $node_(76) $tcp_(79)
$ns attach-agent $node_(23) $sink_(79)
$ns connect $tcp_(79) $sink_(79)
set ftp_(79) [new Application/FTP]
$ftp_(79) attach-agent $tcp_(79)
$ns at 720.2 "$ftp_(79) start"
$ns at 900.0 "$ftp_(79) stop"

#Set a TCP connection between node_(0) and node_(16)
set tcp_(80) [new Agent/TCP/Newreno]
$tcp_(80) set class_ 2
set sink_(80) [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp_(80)
$ns attach-agent $node_(16) $sink_(80)
$ns connect $tcp_(80) $sink_(80)
set ftp_(80) [new Application/FTP]
$ftp_(80) attach-agent $tcp_(80)
$ns at 0.2 "$ftp_(80) start"
$ns at 180.0 "$ftp_(80) stop"

#Set a TCP connection between node_(6) and node_(73)
set tcp_(81) [new Agent/TCP/Newreno]
$tcp_(81) set class_ 2
set sink_(81) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(81)
$ns attach-agent $node_(73) $sink_(81)
$ns connect $tcp_(81) $sink_(81)
set ftp_(81) [new Application/FTP]
$ftp_(81) attach-agent $tcp_(81)
$ns at 180.2 "$ftp_(81) start"
$ns at 360.0 "$ftp_(81) stop"

#Set a TCP connection between node_(0) and node_(56)
set tcp_(82) [new Agent/TCP/Newreno]
$tcp_(82) set class_ 2
set sink_(82) [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp_(82)
$ns attach-agent $node_(56) $sink_(82)
$ns connect $tcp_(82) $sink_(82)
set ftp_(82) [new Application/FTP]
$ftp_(82) attach-agent $tcp_(82)
$ns at 360.2 "$ftp_(82) start"
$ns at 540.0 "$ftp_(82) stop"

#Set a TCP connection between node_(6) and node_(83)
set tcp_(83) [new Agent/TCP/Newreno]
$tcp_(83) set class_ 2
set sink_(83) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(83)
$ns attach-agent $node_(83) $sink_(83)
$ns connect $tcp_(83) $sink_(83)
set ftp_(83) [new Application/FTP]
$ftp_(83) attach-agent $tcp_(83)
$ns at 540.2 "$ftp_(83) start"
$ns at 720.0 "$ftp_(83) stop"

#Set a TCP connection between node_(49) and node_(81)
set tcp_(84) [new Agent/TCP/Newreno]
$tcp_(84) set class_ 2
set sink_(84) [new Agent/TCPSink]
$ns attach-agent $node_(49) $tcp_(84)
$ns attach-agent $node_(81) $sink_(84)
$ns connect $tcp_(84) $sink_(84)
set ftp_(84) [new Application/FTP]
$ftp_(84) attach-agent $tcp_(84)
$ns at 720.2 "$ftp_(84) start"
$ns at 900.0 "$ftp_(84) stop"

#Set a TCP connection between node_(50) and node_(74)
set tcp_(85) [new Agent/TCP/Newreno]
$tcp_(85) set class_ 2
set sink_(85) [new Agent/TCPSink]
$ns attach-agent $node_(50) $tcp_(85)
$ns attach-agent $node_(74) $sink_(85)
$ns connect $tcp_(85) $sink_(85)
set ftp_(85) [new Application/FTP]
$ftp_(85) attach-agent $tcp_(85)
$ns at 0.2 "$ftp_(85) start"
$ns at 180.0 "$ftp_(85) stop"

#Set a TCP connection between node_(71) and node_(81)
set tcp_(86) [new Agent/TCP/Newreno]
$tcp_(86) set class_ 2
set sink_(86) [new Agent/TCPSink]
$ns attach-agent $node_(71) $tcp_(86)
$ns attach-agent $node_(81) $sink_(86)
$ns connect $tcp_(86) $sink_(86)
set ftp_(86) [new Application/FTP]
$ftp_(86) attach-agent $tcp_(86)
$ns at 180.2 "$ftp_(86) start"
$ns at 360.0 "$ftp_(86) stop"

#Set a TCP connection between node_(34) and node_(12)
set tcp_(87) [new Agent/TCP/Newreno]
$tcp_(87) set class_ 2
set sink_(87) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(87)
$ns attach-agent $node_(12) $sink_(87)
$ns connect $tcp_(87) $sink_(87)
set ftp_(87) [new Application/FTP]
$ftp_(87) attach-agent $tcp_(87)
$ns at 360.2 "$ftp_(87) start"
$ns at 540.0 "$ftp_(87) stop"

#Set a TCP connection between node_(98) and node_(84)
set tcp_(88) [new Agent/TCP/Newreno]
$tcp_(88) set class_ 2
set sink_(88) [new Agent/TCPSink]
$ns attach-agent $node_(98) $tcp_(88)
$ns attach-agent $node_(84) $sink_(88)
$ns connect $tcp_(88) $sink_(88)
set ftp_(88) [new Application/FTP]
$ftp_(88) attach-agent $tcp_(88)
$ns at 540.2 "$ftp_(88) start"
$ns at 720.0 "$ftp_(88) stop"

#Set a TCP connection between node_(69) and node_(76)
set tcp_(89) [new Agent/TCP/Newreno]
$tcp_(89) set class_ 2
set sink_(89) [new Agent/TCPSink]
$ns attach-agent $node_(69) $tcp_(89)
$ns attach-agent $node_(76) $sink_(89)
$ns connect $tcp_(89) $sink_(89)
set ftp_(89) [new Application/FTP]
$ftp_(89) attach-agent $tcp_(89)
$ns at 720.2 "$ftp_(89) start"
$ns at 900.0 "$ftp_(89) stop"

#Set a TCP connection between node_(35) and node_(12)
set tcp_(90) [new Agent/TCP/Newreno]
$tcp_(90) set class_ 2
set sink_(90) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(90)
$ns attach-agent $node_(12) $sink_(90)
$ns connect $tcp_(90) $sink_(90)
set ftp_(90) [new Application/FTP]
$ftp_(90) attach-agent $tcp_(90)
$ns at 0.2 "$ftp_(90) start"
$ns at 180.0 "$ftp_(90) stop"

#Set a TCP connection between node_(80) and node_(44)
set tcp_(91) [new Agent/TCP/Newreno]
$tcp_(91) set class_ 2
set sink_(91) [new Agent/TCPSink]
$ns attach-agent $node_(80) $tcp_(91)
$ns attach-agent $node_(44) $sink_(91)
$ns connect $tcp_(91) $sink_(91)
set ftp_(91) [new Application/FTP]
$ftp_(91) attach-agent $tcp_(91)
$ns at 180.2 "$ftp_(91) start"
$ns at 360.0 "$ftp_(91) stop"

#Set a TCP connection between node_(39) and node_(85)
set tcp_(92) [new Agent/TCP/Newreno]
$tcp_(92) set class_ 2
set sink_(92) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(92)
$ns attach-agent $node_(85) $sink_(92)
$ns connect $tcp_(92) $sink_(92)
set ftp_(92) [new Application/FTP]
$ftp_(92) attach-agent $tcp_(92)
$ns at 360.2 "$ftp_(92) start"
$ns at 540.0 "$ftp_(92) stop"

#Set a TCP connection between node_(43) and node_(52)
set tcp_(93) [new Agent/TCP/Newreno]
$tcp_(93) set class_ 2
set sink_(93) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(93)
$ns attach-agent $node_(52) $sink_(93)
$ns connect $tcp_(93) $sink_(93)
set ftp_(93) [new Application/FTP]
$ftp_(93) attach-agent $tcp_(93)
$ns at 540.2 "$ftp_(93) start"
$ns at 720.0 "$ftp_(93) stop"

#Set a TCP connection between node_(61) and node_(14)
set tcp_(94) [new Agent/TCP/Newreno]
$tcp_(94) set class_ 2
set sink_(94) [new Agent/TCPSink]
$ns attach-agent $node_(61) $tcp_(94)
$ns attach-agent $node_(14) $sink_(94)
$ns connect $tcp_(94) $sink_(94)
set ftp_(94) [new Application/FTP]
$ftp_(94) attach-agent $tcp_(94)
$ns at 720.2 "$ftp_(94) start"
$ns at 900.0 "$ftp_(94) stop"

#Set a TCP connection between node_(38) and node_(8)
set tcp_(95) [new Agent/TCP/Newreno]
$tcp_(95) set class_ 2
set sink_(95) [new Agent/TCPSink]
$ns attach-agent $node_(38) $tcp_(95)
$ns attach-agent $node_(8) $sink_(95)
$ns connect $tcp_(95) $sink_(95)
set ftp_(95) [new Application/FTP]
$ftp_(95) attach-agent $tcp_(95)
$ns at 0.2 "$ftp_(95) start"
$ns at 180.0 "$ftp_(95) stop"

#Set a TCP connection between node_(33) and node_(82)
set tcp_(96) [new Agent/TCP/Newreno]
$tcp_(96) set class_ 2
set sink_(96) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(96)
$ns attach-agent $node_(82) $sink_(96)
$ns connect $tcp_(96) $sink_(96)
set ftp_(96) [new Application/FTP]
$ftp_(96) attach-agent $tcp_(96)
$ns at 180.2 "$ftp_(96) start"
$ns at 360.0 "$ftp_(96) stop"

#Set a TCP connection between node_(53) and node_(35)
set tcp_(97) [new Agent/TCP/Newreno]
$tcp_(97) set class_ 2
set sink_(97) [new Agent/TCPSink]
$ns attach-agent $node_(53) $tcp_(97)
$ns attach-agent $node_(35) $sink_(97)
$ns connect $tcp_(97) $sink_(97)
set ftp_(97) [new Application/FTP]
$ftp_(97) attach-agent $tcp_(97)
$ns at 360.2 "$ftp_(97) start"
$ns at 540.0 "$ftp_(97) stop"

#Set a TCP connection between node_(60) and node_(96)
set tcp_(98) [new Agent/TCP/Newreno]
$tcp_(98) set class_ 2
set sink_(98) [new Agent/TCPSink]
$ns attach-agent $node_(60) $tcp_(98)
$ns attach-agent $node_(96) $sink_(98)
$ns connect $tcp_(98) $sink_(98)
set ftp_(98) [new Application/FTP]
$ftp_(98) attach-agent $tcp_(98)
$ns at 540.2 "$ftp_(98) start"
$ns at 720.0 "$ftp_(98) stop"

#Set a TCP connection between node_(35) and node_(67)
set tcp_(99) [new Agent/TCP/Newreno]
$tcp_(99) set class_ 2
set sink_(99) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(99)
$ns attach-agent $node_(67) $sink_(99)
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
