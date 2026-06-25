#sim-scn3-6.tcl 
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
set tracefd       [open sim-scn3-6-$val(rp)-trace.tr w]
set windowVsTime2 [open sim-scn3-6-$val(rp)-win-.tr w]
set namtrace      [open sim-scn3-6-$val(rp).nam w]

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
$node_(0) set X_ 1463 
$node_(0) set Y_ 162 
$node_(0) set Z_ 0.0 
$node_(1) set X_ 2164 
$node_(1) set Y_ 717 
$node_(1) set Z_ 0.0 
$node_(2) set X_ 226 
$node_(2) set Y_ 339 
$node_(2) set Z_ 0.0 
$node_(3) set X_ 138 
$node_(3) set Y_ 131 
$node_(3) set Z_ 0.0 
$node_(4) set X_ 844 
$node_(4) set Y_ 343 
$node_(4) set Z_ 0.0 
$node_(5) set X_ 1900 
$node_(5) set Y_ 155 
$node_(5) set Z_ 0.0 
$node_(6) set X_ 1827 
$node_(6) set Y_ 99 
$node_(6) set Z_ 0.0 
$node_(7) set X_ 2832 
$node_(7) set Y_ 808 
$node_(7) set Z_ 0.0 
$node_(8) set X_ 593 
$node_(8) set Y_ 530 
$node_(8) set Z_ 0.0 
$node_(9) set X_ 584 
$node_(9) set Y_ 397 
$node_(9) set Z_ 0.0 
$node_(10) set X_ 1770 
$node_(10) set Y_ 969 
$node_(10) set Z_ 0.0 
$node_(11) set X_ 1459 
$node_(11) set Y_ 438 
$node_(11) set Z_ 0.0 
$node_(12) set X_ 1801 
$node_(12) set Y_ 508 
$node_(12) set Z_ 0.0 
$node_(13) set X_ 2997 
$node_(13) set Y_ 338 
$node_(13) set Z_ 0.0 
$node_(14) set X_ 1679 
$node_(14) set Y_ 678 
$node_(14) set Z_ 0.0 
$node_(15) set X_ 1463 
$node_(15) set Y_ 998 
$node_(15) set Z_ 0.0 
$node_(16) set X_ 2967 
$node_(16) set Y_ 836 
$node_(16) set Z_ 0.0 
$node_(17) set X_ 1301 
$node_(17) set Y_ 30 
$node_(17) set Z_ 0.0 
$node_(18) set X_ 1360 
$node_(18) set Y_ 868 
$node_(18) set Z_ 0.0 
$node_(19) set X_ 2156 
$node_(19) set Y_ 378 
$node_(19) set Z_ 0.0 
$node_(20) set X_ 2818 
$node_(20) set Y_ 181 
$node_(20) set Z_ 0.0 
$node_(21) set X_ 1878 
$node_(21) set Y_ 9 
$node_(21) set Z_ 0.0 
$node_(22) set X_ 1838 
$node_(22) set Y_ 424 
$node_(22) set Z_ 0.0 
$node_(23) set X_ 882 
$node_(23) set Y_ 756 
$node_(23) set Z_ 0.0 
$node_(24) set X_ 649 
$node_(24) set Y_ 118 
$node_(24) set Z_ 0.0 
$node_(25) set X_ 1505 
$node_(25) set Y_ 527 
$node_(25) set Z_ 0.0 
$node_(26) set X_ 2060 
$node_(26) set Y_ 121 
$node_(26) set Z_ 0.0 
$node_(27) set X_ 2375 
$node_(27) set Y_ 903 
$node_(27) set Z_ 0.0 
$node_(28) set X_ 2403 
$node_(28) set Y_ 909 
$node_(28) set Z_ 0.0 
$node_(29) set X_ 1533 
$node_(29) set Y_ 532 
$node_(29) set Z_ 0.0 
$node_(30) set X_ 2336 
$node_(30) set Y_ 730 
$node_(30) set Z_ 0.0 
$node_(31) set X_ 856 
$node_(31) set Y_ 863 
$node_(31) set Z_ 0.0 
$node_(32) set X_ 2446 
$node_(32) set Y_ 34 
$node_(32) set Z_ 0.0 
$node_(33) set X_ 2470 
$node_(33) set Y_ 479 
$node_(33) set Z_ 0.0 
$node_(34) set X_ 1375 
$node_(34) set Y_ 983 
$node_(34) set Z_ 0.0 
$node_(35) set X_ 2135 
$node_(35) set Y_ 715 
$node_(35) set Z_ 0.0 
$node_(36) set X_ 1753 
$node_(36) set Y_ 498 
$node_(36) set Z_ 0.0 
$node_(37) set X_ 107 
$node_(37) set Y_ 289 
$node_(37) set Z_ 0.0 
$node_(38) set X_ 1496 
$node_(38) set Y_ 30 
$node_(38) set Z_ 0.0 
$node_(39) set X_ 750 
$node_(39) set Y_ 391 
$node_(39) set Z_ 0.0 
$node_(40) set X_ 981 
$node_(40) set Y_ 170 
$node_(40) set Z_ 0.0 
$node_(41) set X_ 2116 
$node_(41) set Y_ 66 
$node_(41) set Z_ 0.0 
$node_(42) set X_ 1357 
$node_(42) set Y_ 300 
$node_(42) set Z_ 0.0 
$node_(43) set X_ 1921 
$node_(43) set Y_ 731 
$node_(43) set Z_ 0.0 
$node_(44) set X_ 626 
$node_(44) set Y_ 694 
$node_(44) set Z_ 0.0 
$node_(45) set X_ 738 
$node_(45) set Y_ 366 
$node_(45) set Z_ 0.0 
$node_(46) set X_ 1292 
$node_(46) set Y_ 896 
$node_(46) set Z_ 0.0 
$node_(47) set X_ 1839 
$node_(47) set Y_ 255 
$node_(47) set Z_ 0.0 
$node_(48) set X_ 2247 
$node_(48) set Y_ 719 
$node_(48) set Z_ 0.0 
$node_(49) set X_ 2999 
$node_(49) set Y_ 143 
$node_(49) set Z_ 0.0 
$node_(50) set X_ 2094 
$node_(50) set Y_ 921 
$node_(50) set Z_ 0.0 
$node_(51) set X_ 2584 
$node_(51) set Y_ 349 
$node_(51) set Z_ 0.0 
$node_(52) set X_ 2461 
$node_(52) set Y_ 482 
$node_(52) set Z_ 0.0 
$node_(53) set X_ 1579 
$node_(53) set Y_ 663 
$node_(53) set Z_ 0.0 
$node_(54) set X_ 2833 
$node_(54) set Y_ 386 
$node_(54) set Z_ 0.0 
$node_(55) set X_ 674 
$node_(55) set Y_ 820 
$node_(55) set Z_ 0.0 
$node_(56) set X_ 2171 
$node_(56) set Y_ 17 
$node_(56) set Z_ 0.0 
$node_(57) set X_ 1247 
$node_(57) set Y_ 1 
$node_(57) set Z_ 0.0 
$node_(58) set X_ 1058 
$node_(58) set Y_ 589 
$node_(58) set Z_ 0.0 
$node_(59) set X_ 50 
$node_(59) set Y_ 29 
$node_(59) set Z_ 0.0 
$node_(60) set X_ 254 
$node_(60) set Y_ 491 
$node_(60) set Z_ 0.0 
$node_(61) set X_ 514 
$node_(61) set Y_ 930 
$node_(61) set Z_ 0.0 
$node_(62) set X_ 2459 
$node_(62) set Y_ 112 
$node_(62) set Z_ 0.0 
$node_(63) set X_ 2004 
$node_(63) set Y_ 63 
$node_(63) set Z_ 0.0 
$node_(64) set X_ 1664 
$node_(64) set Y_ 453 
$node_(64) set Z_ 0.0 
$node_(65) set X_ 2914 
$node_(65) set Y_ 302 
$node_(65) set Z_ 0.0 
$node_(66) set X_ 2835 
$node_(66) set Y_ 827 
$node_(66) set Z_ 0.0 
$node_(67) set X_ 336 
$node_(67) set Y_ 652 
$node_(67) set Z_ 0.0 
$node_(68) set X_ 1666 
$node_(68) set Y_ 16 
$node_(68) set Z_ 0.0 
$node_(69) set X_ 1041 
$node_(69) set Y_ 232 
$node_(69) set Z_ 0.0 
$node_(70) set X_ 1966 
$node_(70) set Y_ 561 
$node_(70) set Z_ 0.0 
$node_(71) set X_ 1766 
$node_(71) set Y_ 779 
$node_(71) set Z_ 0.0 
$node_(72) set X_ 1672 
$node_(72) set Y_ 227 
$node_(72) set Z_ 0.0 
$node_(73) set X_ 280 
$node_(73) set Y_ 694 
$node_(73) set Z_ 0.0 
$node_(74) set X_ 1715 
$node_(74) set Y_ 312 
$node_(74) set Z_ 0.0 
$node_(75) set X_ 2377 
$node_(75) set Y_ 201 
$node_(75) set Z_ 0.0 
$node_(76) set X_ 1884 
$node_(76) set Y_ 159 
$node_(76) set Z_ 0.0 
$node_(77) set X_ 2850 
$node_(77) set Y_ 333 
$node_(77) set Z_ 0.0 
$node_(78) set X_ 1454 
$node_(78) set Y_ 152 
$node_(78) set Z_ 0.0 
$node_(79) set X_ 1623 
$node_(79) set Y_ 340 
$node_(79) set Z_ 0.0 
$node_(80) set X_ 722 
$node_(80) set Y_ 487 
$node_(80) set Z_ 0.0 
$node_(81) set X_ 2581 
$node_(81) set Y_ 597 
$node_(81) set Z_ 0.0 
$node_(82) set X_ 1665 
$node_(82) set Y_ 235 
$node_(82) set Z_ 0.0 
$node_(83) set X_ 1162 
$node_(83) set Y_ 231 
$node_(83) set Z_ 0.0 
$node_(84) set X_ 1732 
$node_(84) set Y_ 571 
$node_(84) set Z_ 0.0 
$node_(85) set X_ 2581 
$node_(85) set Y_ 511 
$node_(85) set Z_ 0.0 
$node_(86) set X_ 286 
$node_(86) set Y_ 523 
$node_(86) set Z_ 0.0 
$node_(87) set X_ 2567 
$node_(87) set Y_ 511 
$node_(87) set Z_ 0.0 
$node_(88) set X_ 2465 
$node_(88) set Y_ 314 
$node_(88) set Z_ 0.0 
$node_(89) set X_ 2670 
$node_(89) set Y_ 669 
$node_(89) set Z_ 0.0 
$node_(90) set X_ 163 
$node_(90) set Y_ 151 
$node_(90) set Z_ 0.0 
$node_(91) set X_ 672 
$node_(91) set Y_ 639 
$node_(91) set Z_ 0.0 
$node_(92) set X_ 519 
$node_(92) set Y_ 316 
$node_(92) set Z_ 0.0 
$node_(93) set X_ 269 
$node_(93) set Y_ 297 
$node_(93) set Z_ 0.0 
$node_(94) set X_ 1679 
$node_(94) set Y_ 563 
$node_(94) set Z_ 0.0 
$node_(95) set X_ 81 
$node_(95) set Y_ 806 
$node_(95) set Z_ 0.0 
$node_(96) set X_ 1716 
$node_(96) set Y_ 87 
$node_(96) set Z_ 0.0 
$node_(97) set X_ 1113 
$node_(97) set Y_ 442 
$node_(97) set Z_ 0.0 
$node_(98) set X_ 410 
$node_(98) set Y_ 815 
$node_(98) set Z_ 0.0 
$node_(99) set X_ 2137 
$node_(99) set Y_ 245 
$node_(99) set Z_ 0.0 
$node_(100) set X_ 1140 
$node_(100) set Y_ 351 
$node_(100) set Z_ 0.0 
$node_(101) set X_ 965 
$node_(101) set Y_ 643 
$node_(101) set Z_ 0.0 
$ns at 0.0 "$node_(101) off" 
$ns at 100.0 "$node_(101) on" 
$node_(102) set X_ 1406 
$node_(102) set Y_ 687 
$node_(102) set Z_ 0.0 
$ns at 0.0 "$node_(102) off" 
$ns at 100.0 "$node_(102) on" 
$node_(103) set X_ 352 
$node_(103) set Y_ 902 
$node_(103) set Z_ 0.0 
$ns at 0.0 "$node_(103) off" 
$ns at 100.0 "$node_(103) on" 
$node_(104) set X_ 1483 
$node_(104) set Y_ 696 
$node_(104) set Z_ 0.0 
$ns at 0.0 "$node_(104) off" 
$ns at 100.0 "$node_(104) on" 
$node_(105) set X_ 2219 
$node_(105) set Y_ 644 
$node_(105) set Z_ 0.0 
$ns at 0.0 "$node_(105) off" 
$ns at 100.0 "$node_(105) on" 
$node_(106) set X_ 2408 
$node_(106) set Y_ 509 
$node_(106) set Z_ 0.0 
$ns at 0.0 "$node_(106) off" 
$ns at 100.0 "$node_(106) on" 
$node_(107) set X_ 2094 
$node_(107) set Y_ 663 
$node_(107) set Z_ 0.0 
$ns at 0.0 "$node_(107) off" 
$ns at 100.0 "$node_(107) on" 
$node_(108) set X_ 1922 
$node_(108) set Y_ 105 
$node_(108) set Z_ 0.0 
$ns at 0.0 "$node_(108) off" 
$ns at 100.0 "$node_(108) on" 
$node_(109) set X_ 1049 
$node_(109) set Y_ 8 
$node_(109) set Z_ 0.0 
$ns at 0.0 "$node_(109) off" 
$ns at 100.0 "$node_(109) on" 
$node_(110) set X_ 1130 
$node_(110) set Y_ 834 
$node_(110) set Z_ 0.0 
$ns at 0.0 "$node_(110) off" 
$ns at 100.0 "$node_(110) on" 
$node_(111) set X_ 2053 
$node_(111) set Y_ 604 
$node_(111) set Z_ 0.0 
$ns at 0.0 "$node_(111) off" 
$ns at 100.0 "$node_(111) on" 
$node_(112) set X_ 2502 
$node_(112) set Y_ 125 
$node_(112) set Z_ 0.0 
$ns at 0.0 "$node_(112) off" 
$ns at 100.0 "$node_(112) on" 
$node_(113) set X_ 1506 
$node_(113) set Y_ 684 
$node_(113) set Z_ 0.0 
$ns at 0.0 "$node_(113) off" 
$ns at 100.0 "$node_(113) on" 
$node_(114) set X_ 1412 
$node_(114) set Y_ 356 
$node_(114) set Z_ 0.0 
$ns at 0.0 "$node_(114) off" 
$ns at 100.0 "$node_(114) on" 
$node_(115) set X_ 1757 
$node_(115) set Y_ 975 
$node_(115) set Z_ 0.0 
$ns at 0.0 "$node_(115) off" 
$ns at 100.0 "$node_(115) on" 
$node_(116) set X_ 713 
$node_(116) set Y_ 692 
$node_(116) set Z_ 0.0 
$ns at 0.0 "$node_(116) off" 
$ns at 100.0 "$node_(116) on" 
$node_(117) set X_ 2720 
$node_(117) set Y_ 881 
$node_(117) set Z_ 0.0 
$ns at 0.0 "$node_(117) off" 
$ns at 100.0 "$node_(117) on" 
$node_(118) set X_ 2851 
$node_(118) set Y_ 722 
$node_(118) set Z_ 0.0 
$ns at 0.0 "$node_(118) off" 
$ns at 100.0 "$node_(118) on" 
$node_(119) set X_ 2178 
$node_(119) set Y_ 856 
$node_(119) set Z_ 0.0 
$ns at 0.0 "$node_(119) off" 
$ns at 100.0 "$node_(119) on" 
$node_(120) set X_ 2762 
$node_(120) set Y_ 902 
$node_(120) set Z_ 0.0 
$ns at 0.0 "$node_(120) off" 
$ns at 100.0 "$node_(120) on" 
$node_(121) set X_ 2096 
$node_(121) set Y_ 822 
$node_(121) set Z_ 0.0 
$ns at 0.0 "$node_(121) off" 
$ns at 100.0 "$node_(121) on" 
$node_(122) set X_ 1253 
$node_(122) set Y_ 123 
$node_(122) set Z_ 0.0 
$ns at 0.0 "$node_(122) off" 
$ns at 100.0 "$node_(122) on" 
$node_(123) set X_ 2192 
$node_(123) set Y_ 714 
$node_(123) set Z_ 0.0 
$ns at 0.0 "$node_(123) off" 
$ns at 100.0 "$node_(123) on" 
$node_(124) set X_ 720 
$node_(124) set Y_ 216 
$node_(124) set Z_ 0.0 
$ns at 0.0 "$node_(124) off" 
$ns at 100.0 "$node_(124) on" 
$node_(125) set X_ 1175 
$node_(125) set Y_ 215 
$node_(125) set Z_ 0.0 
$ns at 0.0 "$node_(125) off" 
$ns at 100.0 "$node_(125) on" 
$node_(126) set X_ 976 
$node_(126) set Y_ 825 
$node_(126) set Z_ 0.0 
$ns at 0.0 "$node_(126) off" 
$ns at 100.0 "$node_(126) on" 
$node_(127) set X_ 433 
$node_(127) set Y_ 306 
$node_(127) set Z_ 0.0 
$ns at 0.0 "$node_(127) off" 
$ns at 100.0 "$node_(127) on" 
$node_(128) set X_ 2530 
$node_(128) set Y_ 903 
$node_(128) set Z_ 0.0 
$ns at 0.0 "$node_(128) off" 
$ns at 100.0 "$node_(128) on" 
$node_(129) set X_ 1546 
$node_(129) set Y_ 513 
$node_(129) set Z_ 0.0 
$ns at 0.0 "$node_(129) off" 
$ns at 100.0 "$node_(129) on" 
$node_(130) set X_ 2031 
$node_(130) set Y_ 11 
$node_(130) set Z_ 0.0 
$ns at 0.0 "$node_(130) off" 
$ns at 100.0 "$node_(130) on" 
$node_(131) set X_ 1806 
$node_(131) set Y_ 636 
$node_(131) set Z_ 0.0 
$ns at 0.0 "$node_(131) off" 
$ns at 100.0 "$node_(131) on" 
$node_(132) set X_ 1591 
$node_(132) set Y_ 707 
$node_(132) set Z_ 0.0 
$ns at 0.0 "$node_(132) off" 
$ns at 100.0 "$node_(132) on" 
$node_(133) set X_ 2968 
$node_(133) set Y_ 306 
$node_(133) set Z_ 0.0 
$ns at 0.0 "$node_(133) off" 
$ns at 100.0 "$node_(133) on" 
$node_(134) set X_ 509 
$node_(134) set Y_ 600 
$node_(134) set Z_ 0.0 
$ns at 0.0 "$node_(134) off" 
$ns at 100.0 "$node_(134) on" 
$node_(135) set X_ 694 
$node_(135) set Y_ 925 
$node_(135) set Z_ 0.0 
$ns at 0.0 "$node_(135) off" 
$ns at 100.0 "$node_(135) on" 
$node_(136) set X_ 1365 
$node_(136) set Y_ 31 
$node_(136) set Z_ 0.0 
$ns at 0.0 "$node_(136) off" 
$ns at 100.0 "$node_(136) on" 
$node_(137) set X_ 1612 
$node_(137) set Y_ 424 
$node_(137) set Z_ 0.0 
$ns at 0.0 "$node_(137) off" 
$ns at 100.0 "$node_(137) on" 
$node_(138) set X_ 2681 
$node_(138) set Y_ 932 
$node_(138) set Z_ 0.0 
$ns at 0.0 "$node_(138) off" 
$ns at 100.0 "$node_(138) on" 
$node_(139) set X_ 638 
$node_(139) set Y_ 801 
$node_(139) set Z_ 0.0 
$ns at 0.0 "$node_(139) off" 
$ns at 100.0 "$node_(139) on" 
$node_(140) set X_ 1247 
$node_(140) set Y_ 156 
$node_(140) set Z_ 0.0 
$ns at 0.0 "$node_(140) off" 
$ns at 100.0 "$node_(140) on" 
$node_(141) set X_ 2054 
$node_(141) set Y_ 578 
$node_(141) set Z_ 0.0 
$ns at 0.0 "$node_(141) off" 
$ns at 100.0 "$node_(141) on" 
$node_(142) set X_ 2868 
$node_(142) set Y_ 446 
$node_(142) set Z_ 0.0 
$ns at 0.0 "$node_(142) off" 
$ns at 100.0 "$node_(142) on" 
$node_(143) set X_ 2012 
$node_(143) set Y_ 167 
$node_(143) set Z_ 0.0 
$ns at 0.0 "$node_(143) off" 
$ns at 100.0 "$node_(143) on" 
$node_(144) set X_ 637 
$node_(144) set Y_ 245 
$node_(144) set Z_ 0.0 
$ns at 0.0 "$node_(144) off" 
$ns at 100.0 "$node_(144) on" 
$node_(145) set X_ 450 
$node_(145) set Y_ 628 
$node_(145) set Z_ 0.0 
$ns at 0.0 "$node_(145) off" 
$ns at 100.0 "$node_(145) on" 
$node_(146) set X_ 1908 
$node_(146) set Y_ 780 
$node_(146) set Z_ 0.0 
$ns at 0.0 "$node_(146) off" 
$ns at 100.0 "$node_(146) on" 
$node_(147) set X_ 969 
$node_(147) set Y_ 449 
$node_(147) set Z_ 0.0 
$ns at 0.0 "$node_(147) off" 
$ns at 100.0 "$node_(147) on" 
$node_(148) set X_ 955 
$node_(148) set Y_ 177 
$node_(148) set Z_ 0.0 
$ns at 0.0 "$node_(148) off" 
$ns at 100.0 "$node_(148) on" 
$node_(149) set X_ 2016 
$node_(149) set Y_ 806 
$node_(149) set Z_ 0.0 
$ns at 0.0 "$node_(149) off" 
$ns at 100.0 "$node_(149) on" 
$node_(150) set X_ 2817 
$node_(150) set Y_ 900 
$node_(150) set Z_ 0.0 
$ns at 0.0 "$node_(150) off" 
$ns at 100.0 "$node_(150) on" 
$node_(151) set X_ 1691 
$node_(151) set Y_ 191 
$node_(151) set Z_ 0.0 
$ns at 0.0 "$node_(151) off" 
$ns at 100.0 "$node_(151) on" 
$node_(152) set X_ 1037 
$node_(152) set Y_ 462 
$node_(152) set Z_ 0.0 
$ns at 0.0 "$node_(152) off" 
$ns at 100.0 "$node_(152) on" 
$node_(153) set X_ 1742 
$node_(153) set Y_ 475 
$node_(153) set Z_ 0.0 
$ns at 0.0 "$node_(153) off" 
$ns at 100.0 "$node_(153) on" 
$node_(154) set X_ 1991 
$node_(154) set Y_ 184 
$node_(154) set Z_ 0.0 
$ns at 0.0 "$node_(154) off" 
$ns at 100.0 "$node_(154) on" 
$node_(155) set X_ 2724 
$node_(155) set Y_ 186 
$node_(155) set Z_ 0.0 
$ns at 0.0 "$node_(155) off" 
$ns at 100.0 "$node_(155) on" 
$node_(156) set X_ 151 
$node_(156) set Y_ 769 
$node_(156) set Z_ 0.0 
$ns at 0.0 "$node_(156) off" 
$ns at 100.0 "$node_(156) on" 
$node_(157) set X_ 1974 
$node_(157) set Y_ 263 
$node_(157) set Z_ 0.0 
$ns at 0.0 "$node_(157) off" 
$ns at 100.0 "$node_(157) on" 
$node_(158) set X_ 1019 
$node_(158) set Y_ 580 
$node_(158) set Z_ 0.0 
$ns at 0.0 "$node_(158) off" 
$ns at 100.0 "$node_(158) on" 
$node_(159) set X_ 2909 
$node_(159) set Y_ 627 
$node_(159) set Z_ 0.0 
$ns at 0.0 "$node_(159) off" 
$ns at 100.0 "$node_(159) on" 
$node_(160) set X_ 2582 
$node_(160) set Y_ 822 
$node_(160) set Z_ 0.0 
$ns at 0.0 "$node_(160) off" 
$ns at 100.0 "$node_(160) on" 
$node_(161) set X_ 268 
$node_(161) set Y_ 641 
$node_(161) set Z_ 0.0 
$ns at 0.0 "$node_(161) off" 
$ns at 100.0 "$node_(161) on" 
$node_(162) set X_ 1967 
$node_(162) set Y_ 254 
$node_(162) set Z_ 0.0 
$ns at 0.0 "$node_(162) off" 
$ns at 100.0 "$node_(162) on" 
$node_(163) set X_ 1203 
$node_(163) set Y_ 957 
$node_(163) set Z_ 0.0 
$ns at 0.0 "$node_(163) off" 
$ns at 100.0 "$node_(163) on" 
$node_(164) set X_ 507 
$node_(164) set Y_ 702 
$node_(164) set Z_ 0.0 
$ns at 0.0 "$node_(164) off" 
$ns at 100.0 "$node_(164) on" 
$node_(165) set X_ 1683 
$node_(165) set Y_ 292 
$node_(165) set Z_ 0.0 
$ns at 0.0 "$node_(165) off" 
$ns at 100.0 "$node_(165) on" 
$node_(166) set X_ 714 
$node_(166) set Y_ 356 
$node_(166) set Z_ 0.0 
$ns at 0.0 "$node_(166) off" 
$ns at 100.0 "$node_(166) on" 
$node_(167) set X_ 1409 
$node_(167) set Y_ 395 
$node_(167) set Z_ 0.0 
$ns at 0.0 "$node_(167) off" 
$ns at 100.0 "$node_(167) on" 
$node_(168) set X_ 2622 
$node_(168) set Y_ 808 
$node_(168) set Z_ 0.0 
$ns at 0.0 "$node_(168) off" 
$ns at 100.0 "$node_(168) on" 
$node_(169) set X_ 2397 
$node_(169) set Y_ 844 
$node_(169) set Z_ 0.0 
$ns at 0.0 "$node_(169) off" 
$ns at 100.0 "$node_(169) on" 
$node_(170) set X_ 2675 
$node_(170) set Y_ 810 
$node_(170) set Z_ 0.0 
$ns at 0.0 "$node_(170) off" 
$ns at 100.0 "$node_(170) on" 
$node_(171) set X_ 600 
$node_(171) set Y_ 333 
$node_(171) set Z_ 0.0 
$ns at 0.0 "$node_(171) off" 
$ns at 100.0 "$node_(171) on" 
$node_(172) set X_ 2743 
$node_(172) set Y_ 8 
$node_(172) set Z_ 0.0 
$ns at 0.0 "$node_(172) off" 
$ns at 100.0 "$node_(172) on" 
$node_(173) set X_ 310 
$node_(173) set Y_ 799 
$node_(173) set Z_ 0.0 
$ns at 0.0 "$node_(173) off" 
$ns at 100.0 "$node_(173) on" 
$node_(174) set X_ 2015 
$node_(174) set Y_ 264 
$node_(174) set Z_ 0.0 
$ns at 0.0 "$node_(174) off" 
$ns at 100.0 "$node_(174) on" 
$node_(175) set X_ 745 
$node_(175) set Y_ 72 
$node_(175) set Z_ 0.0 
$ns at 0.0 "$node_(175) off" 
$ns at 100.0 "$node_(175) on" 
$node_(176) set X_ 2335 
$node_(176) set Y_ 740 
$node_(176) set Z_ 0.0 
$ns at 0.0 "$node_(176) off" 
$ns at 100.0 "$node_(176) on" 
$node_(177) set X_ 2028 
$node_(177) set Y_ 746 
$node_(177) set Z_ 0.0 
$ns at 0.0 "$node_(177) off" 
$ns at 100.0 "$node_(177) on" 
$node_(178) set X_ 1177 
$node_(178) set Y_ 604 
$node_(178) set Z_ 0.0 
$ns at 0.0 "$node_(178) off" 
$ns at 100.0 "$node_(178) on" 
$node_(179) set X_ 2848 
$node_(179) set Y_ 591 
$node_(179) set Z_ 0.0 
$ns at 0.0 "$node_(179) off" 
$ns at 100.0 "$node_(179) on" 
$node_(180) set X_ 691 
$node_(180) set Y_ 93 
$node_(180) set Z_ 0.0 
$ns at 0.0 "$node_(180) off" 
$ns at 100.0 "$node_(180) on" 
$node_(181) set X_ 2393 
$node_(181) set Y_ 180 
$node_(181) set Z_ 0.0 
$ns at 0.0 "$node_(181) off" 
$ns at 100.0 "$node_(181) on" 
$node_(182) set X_ 1328 
$node_(182) set Y_ 661 
$node_(182) set Z_ 0.0 
$ns at 0.0 "$node_(182) off" 
$ns at 100.0 "$node_(182) on" 
$node_(183) set X_ 586 
$node_(183) set Y_ 316 
$node_(183) set Z_ 0.0 
$ns at 0.0 "$node_(183) off" 
$ns at 100.0 "$node_(183) on" 
$node_(184) set X_ 2226 
$node_(184) set Y_ 125 
$node_(184) set Z_ 0.0 
$ns at 0.0 "$node_(184) off" 
$ns at 100.0 "$node_(184) on" 
$node_(185) set X_ 446 
$node_(185) set Y_ 524 
$node_(185) set Z_ 0.0 
$ns at 0.0 "$node_(185) off" 
$ns at 100.0 "$node_(185) on" 
$node_(186) set X_ 51 
$node_(186) set Y_ 29 
$node_(186) set Z_ 0.0 
$ns at 0.0 "$node_(186) off" 
$ns at 100.0 "$node_(186) on" 
$node_(187) set X_ 263 
$node_(187) set Y_ 97 
$node_(187) set Z_ 0.0 
$ns at 0.0 "$node_(187) off" 
$ns at 100.0 "$node_(187) on" 
$node_(188) set X_ 1097 
$node_(188) set Y_ 955 
$node_(188) set Z_ 0.0 
$ns at 0.0 "$node_(188) off" 
$ns at 100.0 "$node_(188) on" 
$node_(189) set X_ 2489 
$node_(189) set Y_ 168 
$node_(189) set Z_ 0.0 
$ns at 0.0 "$node_(189) off" 
$ns at 100.0 "$node_(189) on" 
$node_(190) set X_ 388 
$node_(190) set Y_ 113 
$node_(190) set Z_ 0.0 
$ns at 0.0 "$node_(190) off" 
$ns at 100.0 "$node_(190) on" 
$node_(191) set X_ 1578 
$node_(191) set Y_ 834 
$node_(191) set Z_ 0.0 
$ns at 0.0 "$node_(191) off" 
$ns at 100.0 "$node_(191) on" 
$node_(192) set X_ 115 
$node_(192) set Y_ 373 
$node_(192) set Z_ 0.0 
$ns at 0.0 "$node_(192) off" 
$ns at 100.0 "$node_(192) on" 
$node_(193) set X_ 2633 
$node_(193) set Y_ 622 
$node_(193) set Z_ 0.0 
$ns at 0.0 "$node_(193) off" 
$ns at 100.0 "$node_(193) on" 
$node_(194) set X_ 53 
$node_(194) set Y_ 817 
$node_(194) set Z_ 0.0 
$ns at 0.0 "$node_(194) off" 
$ns at 100.0 "$node_(194) on" 
$node_(195) set X_ 498 
$node_(195) set Y_ 489 
$node_(195) set Z_ 0.0 
$ns at 0.0 "$node_(195) off" 
$ns at 100.0 "$node_(195) on" 
$node_(196) set X_ 1672 
$node_(196) set Y_ 20 
$node_(196) set Z_ 0.0 
$ns at 0.0 "$node_(196) off" 
$ns at 100.0 "$node_(196) on" 
$node_(197) set X_ 1003 
$node_(197) set Y_ 108 
$node_(197) set Z_ 0.0 
$ns at 0.0 "$node_(197) off" 
$ns at 100.0 "$node_(197) on" 
$node_(198) set X_ 2424 
$node_(198) set Y_ 521 
$node_(198) set Z_ 0.0 
$ns at 0.0 "$node_(198) off" 
$ns at 100.0 "$node_(198) on" 
$node_(199) set X_ 1266 
$node_(199) set Y_ 404 
$node_(199) set Z_ 0.0 
$ns at 0.0 "$node_(199) off" 
$ns at 100.0 "$node_(199) on" 
$node_(200) set X_ 2128 
$node_(200) set Y_ 374 
$node_(200) set Z_ 0.0 
$ns at 0.0 "$node_(200) off" 
$ns at 200.0 "$node_(200) on" 
$node_(201) set X_ 489 
$node_(201) set Y_ 173 
$node_(201) set Z_ 0.0 
$ns at 0.0 "$node_(201) off" 
$ns at 200.0 "$node_(201) on" 
$node_(202) set X_ 1647 
$node_(202) set Y_ 220 
$node_(202) set Z_ 0.0 
$ns at 0.0 "$node_(202) off" 
$ns at 200.0 "$node_(202) on" 
$node_(203) set X_ 1307 
$node_(203) set Y_ 165 
$node_(203) set Z_ 0.0 
$ns at 0.0 "$node_(203) off" 
$ns at 200.0 "$node_(203) on" 
$node_(204) set X_ 897 
$node_(204) set Y_ 90 
$node_(204) set Z_ 0.0 
$ns at 0.0 "$node_(204) off" 
$ns at 200.0 "$node_(204) on" 
$node_(205) set X_ 1698 
$node_(205) set Y_ 159 
$node_(205) set Z_ 0.0 
$ns at 0.0 "$node_(205) off" 
$ns at 200.0 "$node_(205) on" 
$node_(206) set X_ 2936 
$node_(206) set Y_ 995 
$node_(206) set Z_ 0.0 
$ns at 0.0 "$node_(206) off" 
$ns at 200.0 "$node_(206) on" 
$node_(207) set X_ 576 
$node_(207) set Y_ 448 
$node_(207) set Z_ 0.0 
$ns at 0.0 "$node_(207) off" 
$ns at 200.0 "$node_(207) on" 
$node_(208) set X_ 179 
$node_(208) set Y_ 443 
$node_(208) set Z_ 0.0 
$ns at 0.0 "$node_(208) off" 
$ns at 200.0 "$node_(208) on" 
$node_(209) set X_ 1510 
$node_(209) set Y_ 602 
$node_(209) set Z_ 0.0 
$ns at 0.0 "$node_(209) off" 
$ns at 200.0 "$node_(209) on" 
$node_(210) set X_ 1916 
$node_(210) set Y_ 189 
$node_(210) set Z_ 0.0 
$ns at 0.0 "$node_(210) off" 
$ns at 200.0 "$node_(210) on" 
$node_(211) set X_ 615 
$node_(211) set Y_ 563 
$node_(211) set Z_ 0.0 
$ns at 0.0 "$node_(211) off" 
$ns at 200.0 "$node_(211) on" 
$node_(212) set X_ 2059 
$node_(212) set Y_ 904 
$node_(212) set Z_ 0.0 
$ns at 0.0 "$node_(212) off" 
$ns at 200.0 "$node_(212) on" 
$node_(213) set X_ 1394 
$node_(213) set Y_ 915 
$node_(213) set Z_ 0.0 
$ns at 0.0 "$node_(213) off" 
$ns at 200.0 "$node_(213) on" 
$node_(214) set X_ 599 
$node_(214) set Y_ 951 
$node_(214) set Z_ 0.0 
$ns at 0.0 "$node_(214) off" 
$ns at 200.0 "$node_(214) on" 
$node_(215) set X_ 1350 
$node_(215) set Y_ 654 
$node_(215) set Z_ 0.0 
$ns at 0.0 "$node_(215) off" 
$ns at 200.0 "$node_(215) on" 
$node_(216) set X_ 1447 
$node_(216) set Y_ 122 
$node_(216) set Z_ 0.0 
$ns at 0.0 "$node_(216) off" 
$ns at 200.0 "$node_(216) on" 
$node_(217) set X_ 2380 
$node_(217) set Y_ 900 
$node_(217) set Z_ 0.0 
$ns at 0.0 "$node_(217) off" 
$ns at 200.0 "$node_(217) on" 
$node_(218) set X_ 330 
$node_(218) set Y_ 30 
$node_(218) set Z_ 0.0 
$ns at 0.0 "$node_(218) off" 
$ns at 200.0 "$node_(218) on" 
$node_(219) set X_ 1403 
$node_(219) set Y_ 753 
$node_(219) set Z_ 0.0 
$ns at 0.0 "$node_(219) off" 
$ns at 200.0 "$node_(219) on" 
$node_(220) set X_ 1047 
$node_(220) set Y_ 814 
$node_(220) set Z_ 0.0 
$ns at 0.0 "$node_(220) off" 
$ns at 200.0 "$node_(220) on" 
$node_(221) set X_ 344 
$node_(221) set Y_ 963 
$node_(221) set Z_ 0.0 
$ns at 0.0 "$node_(221) off" 
$ns at 200.0 "$node_(221) on" 
$node_(222) set X_ 2789 
$node_(222) set Y_ 963 
$node_(222) set Z_ 0.0 
$ns at 0.0 "$node_(222) off" 
$ns at 200.0 "$node_(222) on" 
$node_(223) set X_ 2448 
$node_(223) set Y_ 154 
$node_(223) set Z_ 0.0 
$ns at 0.0 "$node_(223) off" 
$ns at 200.0 "$node_(223) on" 
$node_(224) set X_ 357 
$node_(224) set Y_ 354 
$node_(224) set Z_ 0.0 
$ns at 0.0 "$node_(224) off" 
$ns at 200.0 "$node_(224) on" 
$node_(225) set X_ 2008 
$node_(225) set Y_ 79 
$node_(225) set Z_ 0.0 
$ns at 0.0 "$node_(225) off" 
$ns at 200.0 "$node_(225) on" 
$node_(226) set X_ 2900 
$node_(226) set Y_ 61 
$node_(226) set Z_ 0.0 
$ns at 0.0 "$node_(226) off" 
$ns at 200.0 "$node_(226) on" 
$node_(227) set X_ 893 
$node_(227) set Y_ 817 
$node_(227) set Z_ 0.0 
$ns at 0.0 "$node_(227) off" 
$ns at 200.0 "$node_(227) on" 
$node_(228) set X_ 1383 
$node_(228) set Y_ 69 
$node_(228) set Z_ 0.0 
$ns at 0.0 "$node_(228) off" 
$ns at 200.0 "$node_(228) on" 
$node_(229) set X_ 1801 
$node_(229) set Y_ 859 
$node_(229) set Z_ 0.0 
$ns at 0.0 "$node_(229) off" 
$ns at 200.0 "$node_(229) on" 
$node_(230) set X_ 224 
$node_(230) set Y_ 834 
$node_(230) set Z_ 0.0 
$ns at 0.0 "$node_(230) off" 
$ns at 200.0 "$node_(230) on" 
$node_(231) set X_ 1901 
$node_(231) set Y_ 743 
$node_(231) set Z_ 0.0 
$ns at 0.0 "$node_(231) off" 
$ns at 200.0 "$node_(231) on" 
$node_(232) set X_ 2548 
$node_(232) set Y_ 508 
$node_(232) set Z_ 0.0 
$ns at 0.0 "$node_(232) off" 
$ns at 200.0 "$node_(232) on" 
$node_(233) set X_ 1497 
$node_(233) set Y_ 297 
$node_(233) set Z_ 0.0 
$ns at 0.0 "$node_(233) off" 
$ns at 200.0 "$node_(233) on" 
$node_(234) set X_ 2190 
$node_(234) set Y_ 742 
$node_(234) set Z_ 0.0 
$ns at 0.0 "$node_(234) off" 
$ns at 200.0 "$node_(234) on" 
$node_(235) set X_ 1548 
$node_(235) set Y_ 544 
$node_(235) set Z_ 0.0 
$ns at 0.0 "$node_(235) off" 
$ns at 200.0 "$node_(235) on" 
$node_(236) set X_ 1010 
$node_(236) set Y_ 218 
$node_(236) set Z_ 0.0 
$ns at 0.0 "$node_(236) off" 
$ns at 200.0 "$node_(236) on" 
$node_(237) set X_ 2263 
$node_(237) set Y_ 27 
$node_(237) set Z_ 0.0 
$ns at 0.0 "$node_(237) off" 
$ns at 200.0 "$node_(237) on" 
$node_(238) set X_ 2233 
$node_(238) set Y_ 427 
$node_(238) set Z_ 0.0 
$ns at 0.0 "$node_(238) off" 
$ns at 200.0 "$node_(238) on" 
$node_(239) set X_ 626 
$node_(239) set Y_ 658 
$node_(239) set Z_ 0.0 
$ns at 0.0 "$node_(239) off" 
$ns at 200.0 "$node_(239) on" 
$node_(240) set X_ 345 
$node_(240) set Y_ 778 
$node_(240) set Z_ 0.0 
$ns at 0.0 "$node_(240) off" 
$ns at 200.0 "$node_(240) on" 
$node_(241) set X_ 1543 
$node_(241) set Y_ 167 
$node_(241) set Z_ 0.0 
$ns at 0.0 "$node_(241) off" 
$ns at 200.0 "$node_(241) on" 
$node_(242) set X_ 708 
$node_(242) set Y_ 810 
$node_(242) set Z_ 0.0 
$ns at 0.0 "$node_(242) off" 
$ns at 200.0 "$node_(242) on" 
$node_(243) set X_ 378 
$node_(243) set Y_ 913 
$node_(243) set Z_ 0.0 
$ns at 0.0 "$node_(243) off" 
$ns at 200.0 "$node_(243) on" 
$node_(244) set X_ 319 
$node_(244) set Y_ 127 
$node_(244) set Z_ 0.0 
$ns at 0.0 "$node_(244) off" 
$ns at 200.0 "$node_(244) on" 
$node_(245) set X_ 903 
$node_(245) set Y_ 95 
$node_(245) set Z_ 0.0 
$ns at 0.0 "$node_(245) off" 
$ns at 200.0 "$node_(245) on" 
$node_(246) set X_ 2140 
$node_(246) set Y_ 715 
$node_(246) set Z_ 0.0 
$ns at 0.0 "$node_(246) off" 
$ns at 200.0 "$node_(246) on" 
$node_(247) set X_ 198 
$node_(247) set Y_ 403 
$node_(247) set Z_ 0.0 
$ns at 0.0 "$node_(247) off" 
$ns at 200.0 "$node_(247) on" 
$node_(248) set X_ 215 
$node_(248) set Y_ 443 
$node_(248) set Z_ 0.0 
$ns at 0.0 "$node_(248) off" 
$ns at 200.0 "$node_(248) on" 
$node_(249) set X_ 1769 
$node_(249) set Y_ 730 
$node_(249) set Z_ 0.0 
$ns at 0.0 "$node_(249) off" 
$ns at 200.0 "$node_(249) on" 
$node_(250) set X_ 1169 
$node_(250) set Y_ 888 
$node_(250) set Z_ 0.0 
$ns at 0.0 "$node_(250) off" 
$ns at 200.0 "$node_(250) on" 
$node_(251) set X_ 54 
$node_(251) set Y_ 883 
$node_(251) set Z_ 0.0 
$ns at 0.0 "$node_(251) off" 
$ns at 200.0 "$node_(251) on" 
$node_(252) set X_ 2919 
$node_(252) set Y_ 103 
$node_(252) set Z_ 0.0 
$ns at 0.0 "$node_(252) off" 
$ns at 200.0 "$node_(252) on" 
$node_(253) set X_ 2683 
$node_(253) set Y_ 146 
$node_(253) set Z_ 0.0 
$ns at 0.0 "$node_(253) off" 
$ns at 200.0 "$node_(253) on" 
$node_(254) set X_ 275 
$node_(254) set Y_ 583 
$node_(254) set Z_ 0.0 
$ns at 0.0 "$node_(254) off" 
$ns at 200.0 "$node_(254) on" 
$node_(255) set X_ 2186 
$node_(255) set Y_ 129 
$node_(255) set Z_ 0.0 
$ns at 0.0 "$node_(255) off" 
$ns at 200.0 "$node_(255) on" 
$node_(256) set X_ 1738 
$node_(256) set Y_ 485 
$node_(256) set Z_ 0.0 
$ns at 0.0 "$node_(256) off" 
$ns at 200.0 "$node_(256) on" 
$node_(257) set X_ 496 
$node_(257) set Y_ 616 
$node_(257) set Z_ 0.0 
$ns at 0.0 "$node_(257) off" 
$ns at 200.0 "$node_(257) on" 
$node_(258) set X_ 1121 
$node_(258) set Y_ 90 
$node_(258) set Z_ 0.0 
$ns at 0.0 "$node_(258) off" 
$ns at 200.0 "$node_(258) on" 
$node_(259) set X_ 1334 
$node_(259) set Y_ 988 
$node_(259) set Z_ 0.0 
$ns at 0.0 "$node_(259) off" 
$ns at 200.0 "$node_(259) on" 
$node_(260) set X_ 1666 
$node_(260) set Y_ 636 
$node_(260) set Z_ 0.0 
$ns at 0.0 "$node_(260) off" 
$ns at 200.0 "$node_(260) on" 
$node_(261) set X_ 1652 
$node_(261) set Y_ 399 
$node_(261) set Z_ 0.0 
$ns at 0.0 "$node_(261) off" 
$ns at 200.0 "$node_(261) on" 
$node_(262) set X_ 2102 
$node_(262) set Y_ 860 
$node_(262) set Z_ 0.0 
$ns at 0.0 "$node_(262) off" 
$ns at 200.0 "$node_(262) on" 
$node_(263) set X_ 1539 
$node_(263) set Y_ 58 
$node_(263) set Z_ 0.0 
$ns at 0.0 "$node_(263) off" 
$ns at 200.0 "$node_(263) on" 
$node_(264) set X_ 1555 
$node_(264) set Y_ 75 
$node_(264) set Z_ 0.0 
$ns at 0.0 "$node_(264) off" 
$ns at 200.0 "$node_(264) on" 
$node_(265) set X_ 2444 
$node_(265) set Y_ 871 
$node_(265) set Z_ 0.0 
$ns at 0.0 "$node_(265) off" 
$ns at 200.0 "$node_(265) on" 
$node_(266) set X_ 2449 
$node_(266) set Y_ 114 
$node_(266) set Z_ 0.0 
$ns at 0.0 "$node_(266) off" 
$ns at 200.0 "$node_(266) on" 
$node_(267) set X_ 2290 
$node_(267) set Y_ 219 
$node_(267) set Z_ 0.0 
$ns at 0.0 "$node_(267) off" 
$ns at 200.0 "$node_(267) on" 
$node_(268) set X_ 2421 
$node_(268) set Y_ 252 
$node_(268) set Z_ 0.0 
$ns at 0.0 "$node_(268) off" 
$ns at 200.0 "$node_(268) on" 
$node_(269) set X_ 2928 
$node_(269) set Y_ 816 
$node_(269) set Z_ 0.0 
$ns at 0.0 "$node_(269) off" 
$ns at 200.0 "$node_(269) on" 
$node_(270) set X_ 1966 
$node_(270) set Y_ 91 
$node_(270) set Z_ 0.0 
$ns at 0.0 "$node_(270) off" 
$ns at 200.0 "$node_(270) on" 
$node_(271) set X_ 2536 
$node_(271) set Y_ 462 
$node_(271) set Z_ 0.0 
$ns at 0.0 "$node_(271) off" 
$ns at 200.0 "$node_(271) on" 
$node_(272) set X_ 2824 
$node_(272) set Y_ 425 
$node_(272) set Z_ 0.0 
$ns at 0.0 "$node_(272) off" 
$ns at 200.0 "$node_(272) on" 
$node_(273) set X_ 2865 
$node_(273) set Y_ 969 
$node_(273) set Z_ 0.0 
$ns at 0.0 "$node_(273) off" 
$ns at 200.0 "$node_(273) on" 
$node_(274) set X_ 1249 
$node_(274) set Y_ 318 
$node_(274) set Z_ 0.0 
$ns at 0.0 "$node_(274) off" 
$ns at 200.0 "$node_(274) on" 
$node_(275) set X_ 2854 
$node_(275) set Y_ 724 
$node_(275) set Z_ 0.0 
$ns at 0.0 "$node_(275) off" 
$ns at 200.0 "$node_(275) on" 
$node_(276) set X_ 70 
$node_(276) set Y_ 984 
$node_(276) set Z_ 0.0 
$ns at 0.0 "$node_(276) off" 
$ns at 200.0 "$node_(276) on" 
$node_(277) set X_ 862 
$node_(277) set Y_ 136 
$node_(277) set Z_ 0.0 
$ns at 0.0 "$node_(277) off" 
$ns at 200.0 "$node_(277) on" 
$node_(278) set X_ 1971 
$node_(278) set Y_ 552 
$node_(278) set Z_ 0.0 
$ns at 0.0 "$node_(278) off" 
$ns at 200.0 "$node_(278) on" 
$node_(279) set X_ 1794 
$node_(279) set Y_ 696 
$node_(279) set Z_ 0.0 
$ns at 0.0 "$node_(279) off" 
$ns at 200.0 "$node_(279) on" 
$node_(280) set X_ 1667 
$node_(280) set Y_ 493 
$node_(280) set Z_ 0.0 
$ns at 0.0 "$node_(280) off" 
$ns at 200.0 "$node_(280) on" 
$node_(281) set X_ 614 
$node_(281) set Y_ 488 
$node_(281) set Z_ 0.0 
$ns at 0.0 "$node_(281) off" 
$ns at 200.0 "$node_(281) on" 
$node_(282) set X_ 1574 
$node_(282) set Y_ 292 
$node_(282) set Z_ 0.0 
$ns at 0.0 "$node_(282) off" 
$ns at 200.0 "$node_(282) on" 
$node_(283) set X_ 1168 
$node_(283) set Y_ 795 
$node_(283) set Z_ 0.0 
$ns at 0.0 "$node_(283) off" 
$ns at 200.0 "$node_(283) on" 
$node_(284) set X_ 1278 
$node_(284) set Y_ 950 
$node_(284) set Z_ 0.0 
$ns at 0.0 "$node_(284) off" 
$ns at 200.0 "$node_(284) on" 
$node_(285) set X_ 1886 
$node_(285) set Y_ 832 
$node_(285) set Z_ 0.0 
$ns at 0.0 "$node_(285) off" 
$ns at 200.0 "$node_(285) on" 
$node_(286) set X_ 1466 
$node_(286) set Y_ 998 
$node_(286) set Z_ 0.0 
$ns at 0.0 "$node_(286) off" 
$ns at 200.0 "$node_(286) on" 
$node_(287) set X_ 2835 
$node_(287) set Y_ 775 
$node_(287) set Z_ 0.0 
$ns at 0.0 "$node_(287) off" 
$ns at 200.0 "$node_(287) on" 
$node_(288) set X_ 115 
$node_(288) set Y_ 64 
$node_(288) set Z_ 0.0 
$ns at 0.0 "$node_(288) off" 
$ns at 200.0 "$node_(288) on" 
$node_(289) set X_ 2654 
$node_(289) set Y_ 976 
$node_(289) set Z_ 0.0 
$ns at 0.0 "$node_(289) off" 
$ns at 200.0 "$node_(289) on" 
$node_(290) set X_ 546 
$node_(290) set Y_ 414 
$node_(290) set Z_ 0.0 
$ns at 0.0 "$node_(290) off" 
$ns at 200.0 "$node_(290) on" 
$node_(291) set X_ 1235 
$node_(291) set Y_ 664 
$node_(291) set Z_ 0.0 
$ns at 0.0 "$node_(291) off" 
$ns at 200.0 "$node_(291) on" 
$node_(292) set X_ 2499 
$node_(292) set Y_ 544 
$node_(292) set Z_ 0.0 
$ns at 0.0 "$node_(292) off" 
$ns at 200.0 "$node_(292) on" 
$node_(293) set X_ 545 
$node_(293) set Y_ 492 
$node_(293) set Z_ 0.0 
$ns at 0.0 "$node_(293) off" 
$ns at 200.0 "$node_(293) on" 
$node_(294) set X_ 663 
$node_(294) set Y_ 648 
$node_(294) set Z_ 0.0 
$ns at 0.0 "$node_(294) off" 
$ns at 200.0 "$node_(294) on" 
$node_(295) set X_ 711 
$node_(295) set Y_ 6 
$node_(295) set Z_ 0.0 
$ns at 0.0 "$node_(295) off" 
$ns at 200.0 "$node_(295) on" 
$node_(296) set X_ 2050 
$node_(296) set Y_ 684 
$node_(296) set Z_ 0.0 
$ns at 0.0 "$node_(296) off" 
$ns at 200.0 "$node_(296) on" 
$node_(297) set X_ 487 
$node_(297) set Y_ 478 
$node_(297) set Z_ 0.0 
$ns at 0.0 "$node_(297) off" 
$ns at 200.0 "$node_(297) on" 
$node_(298) set X_ 343 
$node_(298) set Y_ 889 
$node_(298) set Z_ 0.0 
$ns at 0.0 "$node_(298) off" 
$ns at 200.0 "$node_(298) on" 
$node_(299) set X_ 393 
$node_(299) set Y_ 594 
$node_(299) set Z_ 0.0 
$ns at 0.0 "$node_(299) off" 
$ns at 200.0 "$node_(299) on" 
$node_(300) set X_ 2722 
$node_(300) set Y_ 752 
$node_(300) set Z_ 0.0 
$ns at 0.0 "$node_(300) off" 
$ns at 300.0 "$node_(300) on" 
$node_(301) set X_ 213 
$node_(301) set Y_ 135 
$node_(301) set Z_ 0.0 
$ns at 0.0 "$node_(301) off" 
$ns at 300.0 "$node_(301) on" 
$node_(302) set X_ 1868 
$node_(302) set Y_ 916 
$node_(302) set Z_ 0.0 
$ns at 0.0 "$node_(302) off" 
$ns at 300.0 "$node_(302) on" 
$node_(303) set X_ 1182 
$node_(303) set Y_ 169 
$node_(303) set Z_ 0.0 
$ns at 0.0 "$node_(303) off" 
$ns at 300.0 "$node_(303) on" 
$node_(304) set X_ 2640 
$node_(304) set Y_ 965 
$node_(304) set Z_ 0.0 
$ns at 0.0 "$node_(304) off" 
$ns at 300.0 "$node_(304) on" 
$node_(305) set X_ 1028 
$node_(305) set Y_ 253 
$node_(305) set Z_ 0.0 
$ns at 0.0 "$node_(305) off" 
$ns at 300.0 "$node_(305) on" 
$node_(306) set X_ 559 
$node_(306) set Y_ 790 
$node_(306) set Z_ 0.0 
$ns at 0.0 "$node_(306) off" 
$ns at 300.0 "$node_(306) on" 
$node_(307) set X_ 86 
$node_(307) set Y_ 778 
$node_(307) set Z_ 0.0 
$ns at 0.0 "$node_(307) off" 
$ns at 300.0 "$node_(307) on" 
$node_(308) set X_ 1471 
$node_(308) set Y_ 63 
$node_(308) set Z_ 0.0 
$ns at 0.0 "$node_(308) off" 
$ns at 300.0 "$node_(308) on" 
$node_(309) set X_ 1992 
$node_(309) set Y_ 939 
$node_(309) set Z_ 0.0 
$ns at 0.0 "$node_(309) off" 
$ns at 300.0 "$node_(309) on" 
$node_(310) set X_ 839 
$node_(310) set Y_ 374 
$node_(310) set Z_ 0.0 
$ns at 0.0 "$node_(310) off" 
$ns at 300.0 "$node_(310) on" 
$node_(311) set X_ 966 
$node_(311) set Y_ 753 
$node_(311) set Z_ 0.0 
$ns at 0.0 "$node_(311) off" 
$ns at 300.0 "$node_(311) on" 
$node_(312) set X_ 2773 
$node_(312) set Y_ 747 
$node_(312) set Z_ 0.0 
$ns at 0.0 "$node_(312) off" 
$ns at 300.0 "$node_(312) on" 
$node_(313) set X_ 2408 
$node_(313) set Y_ 155 
$node_(313) set Z_ 0.0 
$ns at 0.0 "$node_(313) off" 
$ns at 300.0 "$node_(313) on" 
$node_(314) set X_ 2431 
$node_(314) set Y_ 575 
$node_(314) set Z_ 0.0 
$ns at 0.0 "$node_(314) off" 
$ns at 300.0 "$node_(314) on" 
$node_(315) set X_ 2448 
$node_(315) set Y_ 529 
$node_(315) set Z_ 0.0 
$ns at 0.0 "$node_(315) off" 
$ns at 300.0 "$node_(315) on" 
$node_(316) set X_ 1550 
$node_(316) set Y_ 509 
$node_(316) set Z_ 0.0 
$ns at 0.0 "$node_(316) off" 
$ns at 300.0 "$node_(316) on" 
$node_(317) set X_ 2294 
$node_(317) set Y_ 911 
$node_(317) set Z_ 0.0 
$ns at 0.0 "$node_(317) off" 
$ns at 300.0 "$node_(317) on" 
$node_(318) set X_ 2764 
$node_(318) set Y_ 453 
$node_(318) set Z_ 0.0 
$ns at 0.0 "$node_(318) off" 
$ns at 300.0 "$node_(318) on" 
$node_(319) set X_ 2535 
$node_(319) set Y_ 734 
$node_(319) set Z_ 0.0 
$ns at 0.0 "$node_(319) off" 
$ns at 300.0 "$node_(319) on" 
$node_(320) set X_ 1983 
$node_(320) set Y_ 624 
$node_(320) set Z_ 0.0 
$ns at 0.0 "$node_(320) off" 
$ns at 300.0 "$node_(320) on" 
$node_(321) set X_ 208 
$node_(321) set Y_ 196 
$node_(321) set Z_ 0.0 
$ns at 0.0 "$node_(321) off" 
$ns at 300.0 "$node_(321) on" 
$node_(322) set X_ 2440 
$node_(322) set Y_ 594 
$node_(322) set Z_ 0.0 
$ns at 0.0 "$node_(322) off" 
$ns at 300.0 "$node_(322) on" 
$node_(323) set X_ 198 
$node_(323) set Y_ 282 
$node_(323) set Z_ 0.0 
$ns at 0.0 "$node_(323) off" 
$ns at 300.0 "$node_(323) on" 
$node_(324) set X_ 29 
$node_(324) set Y_ 310 
$node_(324) set Z_ 0.0 
$ns at 0.0 "$node_(324) off" 
$ns at 300.0 "$node_(324) on" 
$node_(325) set X_ 609 
$node_(325) set Y_ 966 
$node_(325) set Z_ 0.0 
$ns at 0.0 "$node_(325) off" 
$ns at 300.0 "$node_(325) on" 
$node_(326) set X_ 1353 
$node_(326) set Y_ 385 
$node_(326) set Z_ 0.0 
$ns at 0.0 "$node_(326) off" 
$ns at 300.0 "$node_(326) on" 
$node_(327) set X_ 1973 
$node_(327) set Y_ 412 
$node_(327) set Z_ 0.0 
$ns at 0.0 "$node_(327) off" 
$ns at 300.0 "$node_(327) on" 
$node_(328) set X_ 1380 
$node_(328) set Y_ 343 
$node_(328) set Z_ 0.0 
$ns at 0.0 "$node_(328) off" 
$ns at 300.0 "$node_(328) on" 
$node_(329) set X_ 1634 
$node_(329) set Y_ 785 
$node_(329) set Z_ 0.0 
$ns at 0.0 "$node_(329) off" 
$ns at 300.0 "$node_(329) on" 
$node_(330) set X_ 781 
$node_(330) set Y_ 92 
$node_(330) set Z_ 0.0 
$ns at 0.0 "$node_(330) off" 
$ns at 300.0 "$node_(330) on" 
$node_(331) set X_ 337 
$node_(331) set Y_ 886 
$node_(331) set Z_ 0.0 
$ns at 0.0 "$node_(331) off" 
$ns at 300.0 "$node_(331) on" 
$node_(332) set X_ 1980 
$node_(332) set Y_ 634 
$node_(332) set Z_ 0.0 
$ns at 0.0 "$node_(332) off" 
$ns at 300.0 "$node_(332) on" 
$node_(333) set X_ 954 
$node_(333) set Y_ 944 
$node_(333) set Z_ 0.0 
$ns at 0.0 "$node_(333) off" 
$ns at 300.0 "$node_(333) on" 
$node_(334) set X_ 565 
$node_(334) set Y_ 884 
$node_(334) set Z_ 0.0 
$ns at 0.0 "$node_(334) off" 
$ns at 300.0 "$node_(334) on" 
$node_(335) set X_ 2396 
$node_(335) set Y_ 797 
$node_(335) set Z_ 0.0 
$ns at 0.0 "$node_(335) off" 
$ns at 300.0 "$node_(335) on" 
$node_(336) set X_ 67 
$node_(336) set Y_ 548 
$node_(336) set Z_ 0.0 
$ns at 0.0 "$node_(336) off" 
$ns at 300.0 "$node_(336) on" 
$node_(337) set X_ 1116 
$node_(337) set Y_ 139 
$node_(337) set Z_ 0.0 
$ns at 0.0 "$node_(337) off" 
$ns at 300.0 "$node_(337) on" 
$node_(338) set X_ 2203 
$node_(338) set Y_ 192 
$node_(338) set Z_ 0.0 
$ns at 0.0 "$node_(338) off" 
$ns at 300.0 "$node_(338) on" 
$node_(339) set X_ 2160 
$node_(339) set Y_ 705 
$node_(339) set Z_ 0.0 
$ns at 0.0 "$node_(339) off" 
$ns at 300.0 "$node_(339) on" 
$node_(340) set X_ 1462 
$node_(340) set Y_ 972 
$node_(340) set Z_ 0.0 
$ns at 0.0 "$node_(340) off" 
$ns at 300.0 "$node_(340) on" 
$node_(341) set X_ 2506 
$node_(341) set Y_ 48 
$node_(341) set Z_ 0.0 
$ns at 0.0 "$node_(341) off" 
$ns at 300.0 "$node_(341) on" 
$node_(342) set X_ 2443 
$node_(342) set Y_ 60 
$node_(342) set Z_ 0.0 
$ns at 0.0 "$node_(342) off" 
$ns at 300.0 "$node_(342) on" 
$node_(343) set X_ 429 
$node_(343) set Y_ 44 
$node_(343) set Z_ 0.0 
$ns at 0.0 "$node_(343) off" 
$ns at 300.0 "$node_(343) on" 
$node_(344) set X_ 1560 
$node_(344) set Y_ 409 
$node_(344) set Z_ 0.0 
$ns at 0.0 "$node_(344) off" 
$ns at 300.0 "$node_(344) on" 
$node_(345) set X_ 2853 
$node_(345) set Y_ 374 
$node_(345) set Z_ 0.0 
$ns at 0.0 "$node_(345) off" 
$ns at 300.0 "$node_(345) on" 
$node_(346) set X_ 1727 
$node_(346) set Y_ 368 
$node_(346) set Z_ 0.0 
$ns at 0.0 "$node_(346) off" 
$ns at 300.0 "$node_(346) on" 
$node_(347) set X_ 75 
$node_(347) set Y_ 16 
$node_(347) set Z_ 0.0 
$ns at 0.0 "$node_(347) off" 
$ns at 300.0 "$node_(347) on" 
$node_(348) set X_ 246 
$node_(348) set Y_ 623 
$node_(348) set Z_ 0.0 
$ns at 0.0 "$node_(348) off" 
$ns at 300.0 "$node_(348) on" 
$node_(349) set X_ 1919 
$node_(349) set Y_ 207 
$node_(349) set Z_ 0.0 
$ns at 0.0 "$node_(349) off" 
$ns at 300.0 "$node_(349) on" 
$node_(350) set X_ 1574 
$node_(350) set Y_ 79 
$node_(350) set Z_ 0.0 
$ns at 0.0 "$node_(350) off" 
$ns at 300.0 "$node_(350) on" 
$node_(351) set X_ 1238 
$node_(351) set Y_ 436 
$node_(351) set Z_ 0.0 
$ns at 0.0 "$node_(351) off" 
$ns at 300.0 "$node_(351) on" 
$node_(352) set X_ 1698 
$node_(352) set Y_ 592 
$node_(352) set Z_ 0.0 
$ns at 0.0 "$node_(352) off" 
$ns at 300.0 "$node_(352) on" 
$node_(353) set X_ 1777 
$node_(353) set Y_ 767 
$node_(353) set Z_ 0.0 
$ns at 0.0 "$node_(353) off" 
$ns at 300.0 "$node_(353) on" 
$node_(354) set X_ 1726 
$node_(354) set Y_ 911 
$node_(354) set Z_ 0.0 
$ns at 0.0 "$node_(354) off" 
$ns at 300.0 "$node_(354) on" 
$node_(355) set X_ 726 
$node_(355) set Y_ 208 
$node_(355) set Z_ 0.0 
$ns at 0.0 "$node_(355) off" 
$ns at 300.0 "$node_(355) on" 
$node_(356) set X_ 2789 
$node_(356) set Y_ 797 
$node_(356) set Z_ 0.0 
$ns at 0.0 "$node_(356) off" 
$ns at 300.0 "$node_(356) on" 
$node_(357) set X_ 2827 
$node_(357) set Y_ 870 
$node_(357) set Z_ 0.0 
$ns at 0.0 "$node_(357) off" 
$ns at 300.0 "$node_(357) on" 
$node_(358) set X_ 2676 
$node_(358) set Y_ 56 
$node_(358) set Z_ 0.0 
$ns at 0.0 "$node_(358) off" 
$ns at 300.0 "$node_(358) on" 
$node_(359) set X_ 626 
$node_(359) set Y_ 426 
$node_(359) set Z_ 0.0 
$ns at 0.0 "$node_(359) off" 
$ns at 300.0 "$node_(359) on" 
$node_(360) set X_ 1557 
$node_(360) set Y_ 114 
$node_(360) set Z_ 0.0 
$ns at 0.0 "$node_(360) off" 
$ns at 300.0 "$node_(360) on" 
$node_(361) set X_ 2462 
$node_(361) set Y_ 700 
$node_(361) set Z_ 0.0 
$ns at 0.0 "$node_(361) off" 
$ns at 300.0 "$node_(361) on" 
$node_(362) set X_ 1883 
$node_(362) set Y_ 877 
$node_(362) set Z_ 0.0 
$ns at 0.0 "$node_(362) off" 
$ns at 300.0 "$node_(362) on" 
$node_(363) set X_ 1932 
$node_(363) set Y_ 280 
$node_(363) set Z_ 0.0 
$ns at 0.0 "$node_(363) off" 
$ns at 300.0 "$node_(363) on" 
$node_(364) set X_ 954 
$node_(364) set Y_ 827 
$node_(364) set Z_ 0.0 
$ns at 0.0 "$node_(364) off" 
$ns at 300.0 "$node_(364) on" 
$node_(365) set X_ 1024 
$node_(365) set Y_ 717 
$node_(365) set Z_ 0.0 
$ns at 0.0 "$node_(365) off" 
$ns at 300.0 "$node_(365) on" 
$node_(366) set X_ 2798 
$node_(366) set Y_ 685 
$node_(366) set Z_ 0.0 
$ns at 0.0 "$node_(366) off" 
$ns at 300.0 "$node_(366) on" 
$node_(367) set X_ 1684 
$node_(367) set Y_ 225 
$node_(367) set Z_ 0.0 
$ns at 0.0 "$node_(367) off" 
$ns at 300.0 "$node_(367) on" 
$node_(368) set X_ 1849 
$node_(368) set Y_ 541 
$node_(368) set Z_ 0.0 
$ns at 0.0 "$node_(368) off" 
$ns at 300.0 "$node_(368) on" 
$node_(369) set X_ 2461 
$node_(369) set Y_ 775 
$node_(369) set Z_ 0.0 
$ns at 0.0 "$node_(369) off" 
$ns at 300.0 "$node_(369) on" 
$node_(370) set X_ 2514 
$node_(370) set Y_ 28 
$node_(370) set Z_ 0.0 
$ns at 0.0 "$node_(370) off" 
$ns at 300.0 "$node_(370) on" 
$node_(371) set X_ 928 
$node_(371) set Y_ 146 
$node_(371) set Z_ 0.0 
$ns at 0.0 "$node_(371) off" 
$ns at 300.0 "$node_(371) on" 
$node_(372) set X_ 977 
$node_(372) set Y_ 994 
$node_(372) set Z_ 0.0 
$ns at 0.0 "$node_(372) off" 
$ns at 300.0 "$node_(372) on" 
$node_(373) set X_ 836 
$node_(373) set Y_ 804 
$node_(373) set Z_ 0.0 
$ns at 0.0 "$node_(373) off" 
$ns at 300.0 "$node_(373) on" 
$node_(374) set X_ 2645 
$node_(374) set Y_ 112 
$node_(374) set Z_ 0.0 
$ns at 0.0 "$node_(374) off" 
$ns at 300.0 "$node_(374) on" 
$node_(375) set X_ 1500 
$node_(375) set Y_ 437 
$node_(375) set Z_ 0.0 
$ns at 0.0 "$node_(375) off" 
$ns at 300.0 "$node_(375) on" 
$node_(376) set X_ 1331 
$node_(376) set Y_ 66 
$node_(376) set Z_ 0.0 
$ns at 0.0 "$node_(376) off" 
$ns at 300.0 "$node_(376) on" 
$node_(377) set X_ 1582 
$node_(377) set Y_ 605 
$node_(377) set Z_ 0.0 
$ns at 0.0 "$node_(377) off" 
$ns at 300.0 "$node_(377) on" 
$node_(378) set X_ 1769 
$node_(378) set Y_ 259 
$node_(378) set Z_ 0.0 
$ns at 0.0 "$node_(378) off" 
$ns at 300.0 "$node_(378) on" 
$node_(379) set X_ 421 
$node_(379) set Y_ 235 
$node_(379) set Z_ 0.0 
$ns at 0.0 "$node_(379) off" 
$ns at 300.0 "$node_(379) on" 
$node_(380) set X_ 1178 
$node_(380) set Y_ 472 
$node_(380) set Z_ 0.0 
$ns at 0.0 "$node_(380) off" 
$ns at 300.0 "$node_(380) on" 
$node_(381) set X_ 1172 
$node_(381) set Y_ 629 
$node_(381) set Z_ 0.0 
$ns at 0.0 "$node_(381) off" 
$ns at 300.0 "$node_(381) on" 
$node_(382) set X_ 524 
$node_(382) set Y_ 544 
$node_(382) set Z_ 0.0 
$ns at 0.0 "$node_(382) off" 
$ns at 300.0 "$node_(382) on" 
$node_(383) set X_ 432 
$node_(383) set Y_ 250 
$node_(383) set Z_ 0.0 
$ns at 0.0 "$node_(383) off" 
$ns at 300.0 "$node_(383) on" 
$node_(384) set X_ 697 
$node_(384) set Y_ 940 
$node_(384) set Z_ 0.0 
$ns at 0.0 "$node_(384) off" 
$ns at 300.0 "$node_(384) on" 
$node_(385) set X_ 2588 
$node_(385) set Y_ 783 
$node_(385) set Z_ 0.0 
$ns at 0.0 "$node_(385) off" 
$ns at 300.0 "$node_(385) on" 
$node_(386) set X_ 199 
$node_(386) set Y_ 11 
$node_(386) set Z_ 0.0 
$ns at 0.0 "$node_(386) off" 
$ns at 300.0 "$node_(386) on" 
$node_(387) set X_ 1946 
$node_(387) set Y_ 893 
$node_(387) set Z_ 0.0 
$ns at 0.0 "$node_(387) off" 
$ns at 300.0 "$node_(387) on" 
$node_(388) set X_ 2921 
$node_(388) set Y_ 874 
$node_(388) set Z_ 0.0 
$ns at 0.0 "$node_(388) off" 
$ns at 300.0 "$node_(388) on" 
$node_(389) set X_ 755 
$node_(389) set Y_ 628 
$node_(389) set Z_ 0.0 
$ns at 0.0 "$node_(389) off" 
$ns at 300.0 "$node_(389) on" 
$node_(390) set X_ 410 
$node_(390) set Y_ 97 
$node_(390) set Z_ 0.0 
$ns at 0.0 "$node_(390) off" 
$ns at 300.0 "$node_(390) on" 
$node_(391) set X_ 2435 
$node_(391) set Y_ 678 
$node_(391) set Z_ 0.0 
$ns at 0.0 "$node_(391) off" 
$ns at 300.0 "$node_(391) on" 
$node_(392) set X_ 1476 
$node_(392) set Y_ 772 
$node_(392) set Z_ 0.0 
$ns at 0.0 "$node_(392) off" 
$ns at 300.0 "$node_(392) on" 
$node_(393) set X_ 1838 
$node_(393) set Y_ 526 
$node_(393) set Z_ 0.0 
$ns at 0.0 "$node_(393) off" 
$ns at 300.0 "$node_(393) on" 
$node_(394) set X_ 2197 
$node_(394) set Y_ 179 
$node_(394) set Z_ 0.0 
$ns at 0.0 "$node_(394) off" 
$ns at 300.0 "$node_(394) on" 
$node_(395) set X_ 42 
$node_(395) set Y_ 85 
$node_(395) set Z_ 0.0 
$ns at 0.0 "$node_(395) off" 
$ns at 300.0 "$node_(395) on" 
$node_(396) set X_ 2314 
$node_(396) set Y_ 928 
$node_(396) set Z_ 0.0 
$ns at 0.0 "$node_(396) off" 
$ns at 300.0 "$node_(396) on" 
$node_(397) set X_ 47 
$node_(397) set Y_ 590 
$node_(397) set Z_ 0.0 
$ns at 0.0 "$node_(397) off" 
$ns at 300.0 "$node_(397) on" 
$node_(398) set X_ 2635 
$node_(398) set Y_ 378 
$node_(398) set Z_ 0.0 
$ns at 0.0 "$node_(398) off" 
$ns at 300.0 "$node_(398) on" 
$node_(399) set X_ 1942 
$node_(399) set Y_ 353 
$node_(399) set Z_ 0.0 
$ns at 0.0 "$node_(399) off" 
$ns at 300.0 "$node_(399) on" 
$node_(400) set X_ 1417 
$node_(400) set Y_ 184 
$node_(400) set Z_ 0.0 
$ns at 0.0 "$node_(400) off" 
$ns at 400.0 "$node_(400) on" 
$node_(401) set X_ 1365 
$node_(401) set Y_ 494 
$node_(401) set Z_ 0.0 
$ns at 0.0 "$node_(401) off" 
$ns at 400.0 "$node_(401) on" 
$node_(402) set X_ 805 
$node_(402) set Y_ 3 
$node_(402) set Z_ 0.0 
$ns at 0.0 "$node_(402) off" 
$ns at 400.0 "$node_(402) on" 
$node_(403) set X_ 2723 
$node_(403) set Y_ 903 
$node_(403) set Z_ 0.0 
$ns at 0.0 "$node_(403) off" 
$ns at 400.0 "$node_(403) on" 
$node_(404) set X_ 167 
$node_(404) set Y_ 748 
$node_(404) set Z_ 0.0 
$ns at 0.0 "$node_(404) off" 
$ns at 400.0 "$node_(404) on" 
$node_(405) set X_ 1346 
$node_(405) set Y_ 504 
$node_(405) set Z_ 0.0 
$ns at 0.0 "$node_(405) off" 
$ns at 400.0 "$node_(405) on" 
$node_(406) set X_ 2695 
$node_(406) set Y_ 313 
$node_(406) set Z_ 0.0 
$ns at 0.0 "$node_(406) off" 
$ns at 400.0 "$node_(406) on" 
$node_(407) set X_ 818 
$node_(407) set Y_ 361 
$node_(407) set Z_ 0.0 
$ns at 0.0 "$node_(407) off" 
$ns at 400.0 "$node_(407) on" 
$node_(408) set X_ 2879 
$node_(408) set Y_ 344 
$node_(408) set Z_ 0.0 
$ns at 0.0 "$node_(408) off" 
$ns at 400.0 "$node_(408) on" 
$node_(409) set X_ 1877 
$node_(409) set Y_ 284 
$node_(409) set Z_ 0.0 
$ns at 0.0 "$node_(409) off" 
$ns at 400.0 "$node_(409) on" 
$node_(410) set X_ 1400 
$node_(410) set Y_ 447 
$node_(410) set Z_ 0.0 
$ns at 0.0 "$node_(410) off" 
$ns at 400.0 "$node_(410) on" 
$node_(411) set X_ 1771 
$node_(411) set Y_ 367 
$node_(411) set Z_ 0.0 
$ns at 0.0 "$node_(411) off" 
$ns at 400.0 "$node_(411) on" 
$node_(412) set X_ 1679 
$node_(412) set Y_ 233 
$node_(412) set Z_ 0.0 
$ns at 0.0 "$node_(412) off" 
$ns at 400.0 "$node_(412) on" 
$node_(413) set X_ 2573 
$node_(413) set Y_ 331 
$node_(413) set Z_ 0.0 
$ns at 0.0 "$node_(413) off" 
$ns at 400.0 "$node_(413) on" 
$node_(414) set X_ 2681 
$node_(414) set Y_ 709 
$node_(414) set Z_ 0.0 
$ns at 0.0 "$node_(414) off" 
$ns at 400.0 "$node_(414) on" 
$node_(415) set X_ 2855 
$node_(415) set Y_ 644 
$node_(415) set Z_ 0.0 
$ns at 0.0 "$node_(415) off" 
$ns at 400.0 "$node_(415) on" 
$node_(416) set X_ 2712 
$node_(416) set Y_ 845 
$node_(416) set Z_ 0.0 
$ns at 0.0 "$node_(416) off" 
$ns at 400.0 "$node_(416) on" 
$node_(417) set X_ 2196 
$node_(417) set Y_ 105 
$node_(417) set Z_ 0.0 
$ns at 0.0 "$node_(417) off" 
$ns at 400.0 "$node_(417) on" 
$node_(418) set X_ 1747 
$node_(418) set Y_ 569 
$node_(418) set Z_ 0.0 
$ns at 0.0 "$node_(418) off" 
$ns at 400.0 "$node_(418) on" 
$node_(419) set X_ 2328 
$node_(419) set Y_ 31 
$node_(419) set Z_ 0.0 
$ns at 0.0 "$node_(419) off" 
$ns at 400.0 "$node_(419) on" 
$node_(420) set X_ 1389 
$node_(420) set Y_ 71 
$node_(420) set Z_ 0.0 
$ns at 0.0 "$node_(420) off" 
$ns at 400.0 "$node_(420) on" 
$node_(421) set X_ 1245 
$node_(421) set Y_ 198 
$node_(421) set Z_ 0.0 
$ns at 0.0 "$node_(421) off" 
$ns at 400.0 "$node_(421) on" 
$node_(422) set X_ 830 
$node_(422) set Y_ 50 
$node_(422) set Z_ 0.0 
$ns at 0.0 "$node_(422) off" 
$ns at 400.0 "$node_(422) on" 
$node_(423) set X_ 2342 
$node_(423) set Y_ 434 
$node_(423) set Z_ 0.0 
$ns at 0.0 "$node_(423) off" 
$ns at 400.0 "$node_(423) on" 
$node_(424) set X_ 1135 
$node_(424) set Y_ 460 
$node_(424) set Z_ 0.0 
$ns at 0.0 "$node_(424) off" 
$ns at 400.0 "$node_(424) on" 
$node_(425) set X_ 639 
$node_(425) set Y_ 119 
$node_(425) set Z_ 0.0 
$ns at 0.0 "$node_(425) off" 
$ns at 400.0 "$node_(425) on" 
$node_(426) set X_ 1918 
$node_(426) set Y_ 377 
$node_(426) set Z_ 0.0 
$ns at 0.0 "$node_(426) off" 
$ns at 400.0 "$node_(426) on" 
$node_(427) set X_ 2302 
$node_(427) set Y_ 894 
$node_(427) set Z_ 0.0 
$ns at 0.0 "$node_(427) off" 
$ns at 400.0 "$node_(427) on" 
$node_(428) set X_ 2861 
$node_(428) set Y_ 859 
$node_(428) set Z_ 0.0 
$ns at 0.0 "$node_(428) off" 
$ns at 400.0 "$node_(428) on" 
$node_(429) set X_ 1123 
$node_(429) set Y_ 522 
$node_(429) set Z_ 0.0 
$ns at 0.0 "$node_(429) off" 
$ns at 400.0 "$node_(429) on" 
$node_(430) set X_ 2697 
$node_(430) set Y_ 41 
$node_(430) set Z_ 0.0 
$ns at 0.0 "$node_(430) off" 
$ns at 400.0 "$node_(430) on" 
$node_(431) set X_ 1180 
$node_(431) set Y_ 254 
$node_(431) set Z_ 0.0 
$ns at 0.0 "$node_(431) off" 
$ns at 400.0 "$node_(431) on" 
$node_(432) set X_ 1110 
$node_(432) set Y_ 255 
$node_(432) set Z_ 0.0 
$ns at 0.0 "$node_(432) off" 
$ns at 400.0 "$node_(432) on" 
$node_(433) set X_ 2817 
$node_(433) set Y_ 970 
$node_(433) set Z_ 0.0 
$ns at 0.0 "$node_(433) off" 
$ns at 400.0 "$node_(433) on" 
$node_(434) set X_ 593 
$node_(434) set Y_ 676 
$node_(434) set Z_ 0.0 
$ns at 0.0 "$node_(434) off" 
$ns at 400.0 "$node_(434) on" 
$node_(435) set X_ 1078 
$node_(435) set Y_ 100 
$node_(435) set Z_ 0.0 
$ns at 0.0 "$node_(435) off" 
$ns at 400.0 "$node_(435) on" 
$node_(436) set X_ 2616 
$node_(436) set Y_ 839 
$node_(436) set Z_ 0.0 
$ns at 0.0 "$node_(436) off" 
$ns at 400.0 "$node_(436) on" 
$node_(437) set X_ 2051 
$node_(437) set Y_ 557 
$node_(437) set Z_ 0.0 
$ns at 0.0 "$node_(437) off" 
$ns at 400.0 "$node_(437) on" 
$node_(438) set X_ 1448 
$node_(438) set Y_ 383 
$node_(438) set Z_ 0.0 
$ns at 0.0 "$node_(438) off" 
$ns at 400.0 "$node_(438) on" 
$node_(439) set X_ 2063 
$node_(439) set Y_ 960 
$node_(439) set Z_ 0.0 
$ns at 0.0 "$node_(439) off" 
$ns at 400.0 "$node_(439) on" 
$node_(440) set X_ 2711 
$node_(440) set Y_ 567 
$node_(440) set Z_ 0.0 
$ns at 0.0 "$node_(440) off" 
$ns at 400.0 "$node_(440) on" 
$node_(441) set X_ 1384 
$node_(441) set Y_ 977 
$node_(441) set Z_ 0.0 
$ns at 0.0 "$node_(441) off" 
$ns at 400.0 "$node_(441) on" 
$node_(442) set X_ 223 
$node_(442) set Y_ 402 
$node_(442) set Z_ 0.0 
$ns at 0.0 "$node_(442) off" 
$ns at 400.0 "$node_(442) on" 
$node_(443) set X_ 40 
$node_(443) set Y_ 951 
$node_(443) set Z_ 0.0 
$ns at 0.0 "$node_(443) off" 
$ns at 400.0 "$node_(443) on" 
$node_(444) set X_ 2820 
$node_(444) set Y_ 738 
$node_(444) set Z_ 0.0 
$ns at 0.0 "$node_(444) off" 
$ns at 400.0 "$node_(444) on" 
$node_(445) set X_ 1478 
$node_(445) set Y_ 867 
$node_(445) set Z_ 0.0 
$ns at 0.0 "$node_(445) off" 
$ns at 400.0 "$node_(445) on" 
$node_(446) set X_ 773 
$node_(446) set Y_ 285 
$node_(446) set Z_ 0.0 
$ns at 0.0 "$node_(446) off" 
$ns at 400.0 "$node_(446) on" 
$node_(447) set X_ 216 
$node_(447) set Y_ 338 
$node_(447) set Z_ 0.0 
$ns at 0.0 "$node_(447) off" 
$ns at 400.0 "$node_(447) on" 
$node_(448) set X_ 2994 
$node_(448) set Y_ 343 
$node_(448) set Z_ 0.0 
$ns at 0.0 "$node_(448) off" 
$ns at 400.0 "$node_(448) on" 
$node_(449) set X_ 1204 
$node_(449) set Y_ 511 
$node_(449) set Z_ 0.0 
$ns at 0.0 "$node_(449) off" 
$ns at 400.0 "$node_(449) on" 
$node_(450) set X_ 1568 
$node_(450) set Y_ 941 
$node_(450) set Z_ 0.0 
$ns at 0.0 "$node_(450) off" 
$ns at 400.0 "$node_(450) on" 
$node_(451) set X_ 2401 
$node_(451) set Y_ 715 
$node_(451) set Z_ 0.0 
$ns at 0.0 "$node_(451) off" 
$ns at 400.0 "$node_(451) on" 
$node_(452) set X_ 204 
$node_(452) set Y_ 233 
$node_(452) set Z_ 0.0 
$ns at 0.0 "$node_(452) off" 
$ns at 400.0 "$node_(452) on" 
$node_(453) set X_ 157 
$node_(453) set Y_ 229 
$node_(453) set Z_ 0.0 
$ns at 0.0 "$node_(453) off" 
$ns at 400.0 "$node_(453) on" 
$node_(454) set X_ 925 
$node_(454) set Y_ 225 
$node_(454) set Z_ 0.0 
$ns at 0.0 "$node_(454) off" 
$ns at 400.0 "$node_(454) on" 
$node_(455) set X_ 2195 
$node_(455) set Y_ 751 
$node_(455) set Z_ 0.0 
$ns at 0.0 "$node_(455) off" 
$ns at 400.0 "$node_(455) on" 
$node_(456) set X_ 2855 
$node_(456) set Y_ 345 
$node_(456) set Z_ 0.0 
$ns at 0.0 "$node_(456) off" 
$ns at 400.0 "$node_(456) on" 
$node_(457) set X_ 1463 
$node_(457) set Y_ 44 
$node_(457) set Z_ 0.0 
$ns at 0.0 "$node_(457) off" 
$ns at 400.0 "$node_(457) on" 
$node_(458) set X_ 1107 
$node_(458) set Y_ 943 
$node_(458) set Z_ 0.0 
$ns at 0.0 "$node_(458) off" 
$ns at 400.0 "$node_(458) on" 
$node_(459) set X_ 1839 
$node_(459) set Y_ 734 
$node_(459) set Z_ 0.0 
$ns at 0.0 "$node_(459) off" 
$ns at 400.0 "$node_(459) on" 
$node_(460) set X_ 741 
$node_(460) set Y_ 525 
$node_(460) set Z_ 0.0 
$ns at 0.0 "$node_(460) off" 
$ns at 400.0 "$node_(460) on" 
$node_(461) set X_ 1540 
$node_(461) set Y_ 453 
$node_(461) set Z_ 0.0 
$ns at 0.0 "$node_(461) off" 
$ns at 400.0 "$node_(461) on" 
$node_(462) set X_ 373 
$node_(462) set Y_ 434 
$node_(462) set Z_ 0.0 
$ns at 0.0 "$node_(462) off" 
$ns at 400.0 "$node_(462) on" 
$node_(463) set X_ 1237 
$node_(463) set Y_ 335 
$node_(463) set Z_ 0.0 
$ns at 0.0 "$node_(463) off" 
$ns at 400.0 "$node_(463) on" 
$node_(464) set X_ 1394 
$node_(464) set Y_ 715 
$node_(464) set Z_ 0.0 
$ns at 0.0 "$node_(464) off" 
$ns at 400.0 "$node_(464) on" 
$node_(465) set X_ 2212 
$node_(465) set Y_ 377 
$node_(465) set Z_ 0.0 
$ns at 0.0 "$node_(465) off" 
$ns at 400.0 "$node_(465) on" 
$node_(466) set X_ 1815 
$node_(466) set Y_ 115 
$node_(466) set Z_ 0.0 
$ns at 0.0 "$node_(466) off" 
$ns at 400.0 "$node_(466) on" 
$node_(467) set X_ 449 
$node_(467) set Y_ 335 
$node_(467) set Z_ 0.0 
$ns at 0.0 "$node_(467) off" 
$ns at 400.0 "$node_(467) on" 
$node_(468) set X_ 1564 
$node_(468) set Y_ 518 
$node_(468) set Z_ 0.0 
$ns at 0.0 "$node_(468) off" 
$ns at 400.0 "$node_(468) on" 
$node_(469) set X_ 339 
$node_(469) set Y_ 638 
$node_(469) set Z_ 0.0 
$ns at 0.0 "$node_(469) off" 
$ns at 400.0 "$node_(469) on" 
$node_(470) set X_ 2580 
$node_(470) set Y_ 632 
$node_(470) set Z_ 0.0 
$ns at 0.0 "$node_(470) off" 
$ns at 400.0 "$node_(470) on" 
$node_(471) set X_ 675 
$node_(471) set Y_ 246 
$node_(471) set Z_ 0.0 
$ns at 0.0 "$node_(471) off" 
$ns at 400.0 "$node_(471) on" 
$node_(472) set X_ 265 
$node_(472) set Y_ 410 
$node_(472) set Z_ 0.0 
$ns at 0.0 "$node_(472) off" 
$ns at 400.0 "$node_(472) on" 
$node_(473) set X_ 839 
$node_(473) set Y_ 536 
$node_(473) set Z_ 0.0 
$ns at 0.0 "$node_(473) off" 
$ns at 400.0 "$node_(473) on" 
$node_(474) set X_ 2813 
$node_(474) set Y_ 516 
$node_(474) set Z_ 0.0 
$ns at 0.0 "$node_(474) off" 
$ns at 400.0 "$node_(474) on" 
$node_(475) set X_ 495 
$node_(475) set Y_ 43 
$node_(475) set Z_ 0.0 
$ns at 0.0 "$node_(475) off" 
$ns at 400.0 "$node_(475) on" 
$node_(476) set X_ 1631 
$node_(476) set Y_ 127 
$node_(476) set Z_ 0.0 
$ns at 0.0 "$node_(476) off" 
$ns at 400.0 "$node_(476) on" 
$node_(477) set X_ 790 
$node_(477) set Y_ 348 
$node_(477) set Z_ 0.0 
$ns at 0.0 "$node_(477) off" 
$ns at 400.0 "$node_(477) on" 
$node_(478) set X_ 2404 
$node_(478) set Y_ 492 
$node_(478) set Z_ 0.0 
$ns at 0.0 "$node_(478) off" 
$ns at 400.0 "$node_(478) on" 
$node_(479) set X_ 2914 
$node_(479) set Y_ 465 
$node_(479) set Z_ 0.0 
$ns at 0.0 "$node_(479) off" 
$ns at 400.0 "$node_(479) on" 
$node_(480) set X_ 1527 
$node_(480) set Y_ 989 
$node_(480) set Z_ 0.0 
$ns at 0.0 "$node_(480) off" 
$ns at 400.0 "$node_(480) on" 
$node_(481) set X_ 980 
$node_(481) set Y_ 856 
$node_(481) set Z_ 0.0 
$ns at 0.0 "$node_(481) off" 
$ns at 400.0 "$node_(481) on" 
$node_(482) set X_ 2394 
$node_(482) set Y_ 824 
$node_(482) set Z_ 0.0 
$ns at 0.0 "$node_(482) off" 
$ns at 400.0 "$node_(482) on" 
$node_(483) set X_ 1473 
$node_(483) set Y_ 590 
$node_(483) set Z_ 0.0 
$ns at 0.0 "$node_(483) off" 
$ns at 400.0 "$node_(483) on" 
$node_(484) set X_ 637 
$node_(484) set Y_ 183 
$node_(484) set Z_ 0.0 
$ns at 0.0 "$node_(484) off" 
$ns at 400.0 "$node_(484) on" 
$node_(485) set X_ 85 
$node_(485) set Y_ 212 
$node_(485) set Z_ 0.0 
$ns at 0.0 "$node_(485) off" 
$ns at 400.0 "$node_(485) on" 
$node_(486) set X_ 1615 
$node_(486) set Y_ 351 
$node_(486) set Z_ 0.0 
$ns at 0.0 "$node_(486) off" 
$ns at 400.0 "$node_(486) on" 
$node_(487) set X_ 1458 
$node_(487) set Y_ 640 
$node_(487) set Z_ 0.0 
$ns at 0.0 "$node_(487) off" 
$ns at 400.0 "$node_(487) on" 
$node_(488) set X_ 495 
$node_(488) set Y_ 275 
$node_(488) set Z_ 0.0 
$ns at 0.0 "$node_(488) off" 
$ns at 400.0 "$node_(488) on" 
$node_(489) set X_ 2360 
$node_(489) set Y_ 731 
$node_(489) set Z_ 0.0 
$ns at 0.0 "$node_(489) off" 
$ns at 400.0 "$node_(489) on" 
$node_(490) set X_ 913 
$node_(490) set Y_ 103 
$node_(490) set Z_ 0.0 
$ns at 0.0 "$node_(490) off" 
$ns at 400.0 "$node_(490) on" 
$node_(491) set X_ 987 
$node_(491) set Y_ 227 
$node_(491) set Z_ 0.0 
$ns at 0.0 "$node_(491) off" 
$ns at 400.0 "$node_(491) on" 
$node_(492) set X_ 2671 
$node_(492) set Y_ 466 
$node_(492) set Z_ 0.0 
$ns at 0.0 "$node_(492) off" 
$ns at 400.0 "$node_(492) on" 
$node_(493) set X_ 1498 
$node_(493) set Y_ 453 
$node_(493) set Z_ 0.0 
$ns at 0.0 "$node_(493) off" 
$ns at 400.0 "$node_(493) on" 
$node_(494) set X_ 1038 
$node_(494) set Y_ 650 
$node_(494) set Z_ 0.0 
$ns at 0.0 "$node_(494) off" 
$ns at 400.0 "$node_(494) on" 
$node_(495) set X_ 1500 
$node_(495) set Y_ 491 
$node_(495) set Z_ 0.0 
$ns at 0.0 "$node_(495) off" 
$ns at 400.0 "$node_(495) on" 
$node_(496) set X_ 2079 
$node_(496) set Y_ 373 
$node_(496) set Z_ 0.0 
$ns at 0.0 "$node_(496) off" 
$ns at 400.0 "$node_(496) on" 
$node_(497) set X_ 71 
$node_(497) set Y_ 540 
$node_(497) set Z_ 0.0 
$ns at 0.0 "$node_(497) off" 
$ns at 400.0 "$node_(497) on" 
$node_(498) set X_ 2048 
$node_(498) set Y_ 557 
$node_(498) set Z_ 0.0 
$ns at 0.0 "$node_(498) off" 
$ns at 400.0 "$node_(498) on" 
$node_(499) set X_ 929 
$node_(499) set Y_ 842 
$node_(499) set Z_ 0.0 
$ns at 0.0 "$node_(499) off" 
$ns at 400.0 "$node_(499) on" 
$node_(500) set X_ 2120 
$node_(500) set Y_ 340 
$node_(500) set Z_ 0.0 
$ns at 0.0 "$node_(500) off" 
$ns at 500.0 "$node_(500) on" 
$node_(501) set X_ 1686 
$node_(501) set Y_ 847 
$node_(501) set Z_ 0.0 
$ns at 0.0 "$node_(501) off" 
$ns at 500.0 "$node_(501) on" 
$node_(502) set X_ 811 
$node_(502) set Y_ 622 
$node_(502) set Z_ 0.0 
$ns at 0.0 "$node_(502) off" 
$ns at 500.0 "$node_(502) on" 
$node_(503) set X_ 1574 
$node_(503) set Y_ 262 
$node_(503) set Z_ 0.0 
$ns at 0.0 "$node_(503) off" 
$ns at 500.0 "$node_(503) on" 
$node_(504) set X_ 2126 
$node_(504) set Y_ 556 
$node_(504) set Z_ 0.0 
$ns at 0.0 "$node_(504) off" 
$ns at 500.0 "$node_(504) on" 
$node_(505) set X_ 780 
$node_(505) set Y_ 257 
$node_(505) set Z_ 0.0 
$ns at 0.0 "$node_(505) off" 
$ns at 500.0 "$node_(505) on" 
$node_(506) set X_ 1942 
$node_(506) set Y_ 763 
$node_(506) set Z_ 0.0 
$ns at 0.0 "$node_(506) off" 
$ns at 500.0 "$node_(506) on" 
$node_(507) set X_ 2468 
$node_(507) set Y_ 372 
$node_(507) set Z_ 0.0 
$ns at 0.0 "$node_(507) off" 
$ns at 500.0 "$node_(507) on" 
$node_(508) set X_ 1318 
$node_(508) set Y_ 506 
$node_(508) set Z_ 0.0 
$ns at 0.0 "$node_(508) off" 
$ns at 500.0 "$node_(508) on" 
$node_(509) set X_ 1684 
$node_(509) set Y_ 597 
$node_(509) set Z_ 0.0 
$ns at 0.0 "$node_(509) off" 
$ns at 500.0 "$node_(509) on" 
$node_(510) set X_ 1276 
$node_(510) set Y_ 711 
$node_(510) set Z_ 0.0 
$ns at 0.0 "$node_(510) off" 
$ns at 500.0 "$node_(510) on" 
$node_(511) set X_ 755 
$node_(511) set Y_ 721 
$node_(511) set Z_ 0.0 
$ns at 0.0 "$node_(511) off" 
$ns at 500.0 "$node_(511) on" 
$node_(512) set X_ 1251 
$node_(512) set Y_ 507 
$node_(512) set Z_ 0.0 
$ns at 0.0 "$node_(512) off" 
$ns at 500.0 "$node_(512) on" 
$node_(513) set X_ 375 
$node_(513) set Y_ 229 
$node_(513) set Z_ 0.0 
$ns at 0.0 "$node_(513) off" 
$ns at 500.0 "$node_(513) on" 
$node_(514) set X_ 703 
$node_(514) set Y_ 907 
$node_(514) set Z_ 0.0 
$ns at 0.0 "$node_(514) off" 
$ns at 500.0 "$node_(514) on" 
$node_(515) set X_ 351 
$node_(515) set Y_ 13 
$node_(515) set Z_ 0.0 
$ns at 0.0 "$node_(515) off" 
$ns at 500.0 "$node_(515) on" 
$node_(516) set X_ 1442 
$node_(516) set Y_ 369 
$node_(516) set Z_ 0.0 
$ns at 0.0 "$node_(516) off" 
$ns at 500.0 "$node_(516) on" 
$node_(517) set X_ 1069 
$node_(517) set Y_ 642 
$node_(517) set Z_ 0.0 
$ns at 0.0 "$node_(517) off" 
$ns at 500.0 "$node_(517) on" 
$node_(518) set X_ 2973 
$node_(518) set Y_ 233 
$node_(518) set Z_ 0.0 
$ns at 0.0 "$node_(518) off" 
$ns at 500.0 "$node_(518) on" 
$node_(519) set X_ 2932 
$node_(519) set Y_ 212 
$node_(519) set Z_ 0.0 
$ns at 0.0 "$node_(519) off" 
$ns at 500.0 "$node_(519) on" 
$node_(520) set X_ 1672 
$node_(520) set Y_ 433 
$node_(520) set Z_ 0.0 
$ns at 0.0 "$node_(520) off" 
$ns at 500.0 "$node_(520) on" 
$node_(521) set X_ 2537 
$node_(521) set Y_ 630 
$node_(521) set Z_ 0.0 
$ns at 0.0 "$node_(521) off" 
$ns at 500.0 "$node_(521) on" 
$node_(522) set X_ 1783 
$node_(522) set Y_ 494 
$node_(522) set Z_ 0.0 
$ns at 0.0 "$node_(522) off" 
$ns at 500.0 "$node_(522) on" 
$node_(523) set X_ 2008 
$node_(523) set Y_ 745 
$node_(523) set Z_ 0.0 
$ns at 0.0 "$node_(523) off" 
$ns at 500.0 "$node_(523) on" 
$node_(524) set X_ 1153 
$node_(524) set Y_ 518 
$node_(524) set Z_ 0.0 
$ns at 0.0 "$node_(524) off" 
$ns at 500.0 "$node_(524) on" 
$node_(525) set X_ 826 
$node_(525) set Y_ 887 
$node_(525) set Z_ 0.0 
$ns at 0.0 "$node_(525) off" 
$ns at 500.0 "$node_(525) on" 
$node_(526) set X_ 1273 
$node_(526) set Y_ 772 
$node_(526) set Z_ 0.0 
$ns at 0.0 "$node_(526) off" 
$ns at 500.0 "$node_(526) on" 
$node_(527) set X_ 1626 
$node_(527) set Y_ 261 
$node_(527) set Z_ 0.0 
$ns at 0.0 "$node_(527) off" 
$ns at 500.0 "$node_(527) on" 
$node_(528) set X_ 538 
$node_(528) set Y_ 537 
$node_(528) set Z_ 0.0 
$ns at 0.0 "$node_(528) off" 
$ns at 500.0 "$node_(528) on" 
$node_(529) set X_ 1756 
$node_(529) set Y_ 98 
$node_(529) set Z_ 0.0 
$ns at 0.0 "$node_(529) off" 
$ns at 500.0 "$node_(529) on" 
$node_(530) set X_ 728 
$node_(530) set Y_ 59 
$node_(530) set Z_ 0.0 
$ns at 0.0 "$node_(530) off" 
$ns at 500.0 "$node_(530) on" 
$node_(531) set X_ 967 
$node_(531) set Y_ 642 
$node_(531) set Z_ 0.0 
$ns at 0.0 "$node_(531) off" 
$ns at 500.0 "$node_(531) on" 
$node_(532) set X_ 1487 
$node_(532) set Y_ 814 
$node_(532) set Z_ 0.0 
$ns at 0.0 "$node_(532) off" 
$ns at 500.0 "$node_(532) on" 
$node_(533) set X_ 1379 
$node_(533) set Y_ 863 
$node_(533) set Z_ 0.0 
$ns at 0.0 "$node_(533) off" 
$ns at 500.0 "$node_(533) on" 
$node_(534) set X_ 1121 
$node_(534) set Y_ 818 
$node_(534) set Z_ 0.0 
$ns at 0.0 "$node_(534) off" 
$ns at 500.0 "$node_(534) on" 
$node_(535) set X_ 874 
$node_(535) set Y_ 232 
$node_(535) set Z_ 0.0 
$ns at 0.0 "$node_(535) off" 
$ns at 500.0 "$node_(535) on" 
$node_(536) set X_ 2249 
$node_(536) set Y_ 355 
$node_(536) set Z_ 0.0 
$ns at 0.0 "$node_(536) off" 
$ns at 500.0 "$node_(536) on" 
$node_(537) set X_ 1270 
$node_(537) set Y_ 37 
$node_(537) set Z_ 0.0 
$ns at 0.0 "$node_(537) off" 
$ns at 500.0 "$node_(537) on" 
$node_(538) set X_ 794 
$node_(538) set Y_ 353 
$node_(538) set Z_ 0.0 
$ns at 0.0 "$node_(538) off" 
$ns at 500.0 "$node_(538) on" 
$node_(539) set X_ 2081 
$node_(539) set Y_ 491 
$node_(539) set Z_ 0.0 
$ns at 0.0 "$node_(539) off" 
$ns at 500.0 "$node_(539) on" 
$node_(540) set X_ 484 
$node_(540) set Y_ 603 
$node_(540) set Z_ 0.0 
$ns at 0.0 "$node_(540) off" 
$ns at 500.0 "$node_(540) on" 
$node_(541) set X_ 322 
$node_(541) set Y_ 307 
$node_(541) set Z_ 0.0 
$ns at 0.0 "$node_(541) off" 
$ns at 500.0 "$node_(541) on" 
$node_(542) set X_ 2404 
$node_(542) set Y_ 143 
$node_(542) set Z_ 0.0 
$ns at 0.0 "$node_(542) off" 
$ns at 500.0 "$node_(542) on" 
$node_(543) set X_ 1673 
$node_(543) set Y_ 526 
$node_(543) set Z_ 0.0 
$ns at 0.0 "$node_(543) off" 
$ns at 500.0 "$node_(543) on" 
$node_(544) set X_ 277 
$node_(544) set Y_ 454 
$node_(544) set Z_ 0.0 
$ns at 0.0 "$node_(544) off" 
$ns at 500.0 "$node_(544) on" 
$node_(545) set X_ 1446 
$node_(545) set Y_ 105 
$node_(545) set Z_ 0.0 
$ns at 0.0 "$node_(545) off" 
$ns at 500.0 "$node_(545) on" 
$node_(546) set X_ 2941 
$node_(546) set Y_ 531 
$node_(546) set Z_ 0.0 
$ns at 0.0 "$node_(546) off" 
$ns at 500.0 "$node_(546) on" 
$node_(547) set X_ 1060 
$node_(547) set Y_ 209 
$node_(547) set Z_ 0.0 
$ns at 0.0 "$node_(547) off" 
$ns at 500.0 "$node_(547) on" 
$node_(548) set X_ 72 
$node_(548) set Y_ 528 
$node_(548) set Z_ 0.0 
$ns at 0.0 "$node_(548) off" 
$ns at 500.0 "$node_(548) on" 
$node_(549) set X_ 319 
$node_(549) set Y_ 173 
$node_(549) set Z_ 0.0 
$ns at 0.0 "$node_(549) off" 
$ns at 500.0 "$node_(549) on" 
$node_(550) set X_ 2439 
$node_(550) set Y_ 411 
$node_(550) set Z_ 0.0 
$ns at 0.0 "$node_(550) off" 
$ns at 500.0 "$node_(550) on" 
$node_(551) set X_ 477 
$node_(551) set Y_ 842 
$node_(551) set Z_ 0.0 
$ns at 0.0 "$node_(551) off" 
$ns at 500.0 "$node_(551) on" 
$node_(552) set X_ 1983 
$node_(552) set Y_ 998 
$node_(552) set Z_ 0.0 
$ns at 0.0 "$node_(552) off" 
$ns at 500.0 "$node_(552) on" 
$node_(553) set X_ 2090 
$node_(553) set Y_ 372 
$node_(553) set Z_ 0.0 
$ns at 0.0 "$node_(553) off" 
$ns at 500.0 "$node_(553) on" 
$node_(554) set X_ 1692 
$node_(554) set Y_ 816 
$node_(554) set Z_ 0.0 
$ns at 0.0 "$node_(554) off" 
$ns at 500.0 "$node_(554) on" 
$node_(555) set X_ 811 
$node_(555) set Y_ 566 
$node_(555) set Z_ 0.0 
$ns at 0.0 "$node_(555) off" 
$ns at 500.0 "$node_(555) on" 
$node_(556) set X_ 2694 
$node_(556) set Y_ 465 
$node_(556) set Z_ 0.0 
$ns at 0.0 "$node_(556) off" 
$ns at 500.0 "$node_(556) on" 
$node_(557) set X_ 1699 
$node_(557) set Y_ 565 
$node_(557) set Z_ 0.0 
$ns at 0.0 "$node_(557) off" 
$ns at 500.0 "$node_(557) on" 
$node_(558) set X_ 2085 
$node_(558) set Y_ 532 
$node_(558) set Z_ 0.0 
$ns at 0.0 "$node_(558) off" 
$ns at 500.0 "$node_(558) on" 
$node_(559) set X_ 1254 
$node_(559) set Y_ 985 
$node_(559) set Z_ 0.0 
$ns at 0.0 "$node_(559) off" 
$ns at 500.0 "$node_(559) on" 
$node_(560) set X_ 1926 
$node_(560) set Y_ 672 
$node_(560) set Z_ 0.0 
$ns at 0.0 "$node_(560) off" 
$ns at 500.0 "$node_(560) on" 
$node_(561) set X_ 2195 
$node_(561) set Y_ 654 
$node_(561) set Z_ 0.0 
$ns at 0.0 "$node_(561) off" 
$ns at 500.0 "$node_(561) on" 
$node_(562) set X_ 367 
$node_(562) set Y_ 160 
$node_(562) set Z_ 0.0 
$ns at 0.0 "$node_(562) off" 
$ns at 500.0 "$node_(562) on" 
$node_(563) set X_ 90 
$node_(563) set Y_ 701 
$node_(563) set Z_ 0.0 
$ns at 0.0 "$node_(563) off" 
$ns at 500.0 "$node_(563) on" 
$node_(564) set X_ 2174 
$node_(564) set Y_ 67 
$node_(564) set Z_ 0.0 
$ns at 0.0 "$node_(564) off" 
$ns at 500.0 "$node_(564) on" 
$node_(565) set X_ 2230 
$node_(565) set Y_ 101 
$node_(565) set Z_ 0.0 
$ns at 0.0 "$node_(565) off" 
$ns at 500.0 "$node_(565) on" 
$node_(566) set X_ 1968 
$node_(566) set Y_ 248 
$node_(566) set Z_ 0.0 
$ns at 0.0 "$node_(566) off" 
$ns at 500.0 "$node_(566) on" 
$node_(567) set X_ 608 
$node_(567) set Y_ 719 
$node_(567) set Z_ 0.0 
$ns at 0.0 "$node_(567) off" 
$ns at 500.0 "$node_(567) on" 
$node_(568) set X_ 1176 
$node_(568) set Y_ 475 
$node_(568) set Z_ 0.0 
$ns at 0.0 "$node_(568) off" 
$ns at 500.0 "$node_(568) on" 
$node_(569) set X_ 1611 
$node_(569) set Y_ 525 
$node_(569) set Z_ 0.0 
$ns at 0.0 "$node_(569) off" 
$ns at 500.0 "$node_(569) on" 
$node_(570) set X_ 2185 
$node_(570) set Y_ 391 
$node_(570) set Z_ 0.0 
$ns at 0.0 "$node_(570) off" 
$ns at 500.0 "$node_(570) on" 
$node_(571) set X_ 959 
$node_(571) set Y_ 940 
$node_(571) set Z_ 0.0 
$ns at 0.0 "$node_(571) off" 
$ns at 500.0 "$node_(571) on" 
$node_(572) set X_ 344 
$node_(572) set Y_ 425 
$node_(572) set Z_ 0.0 
$ns at 0.0 "$node_(572) off" 
$ns at 500.0 "$node_(572) on" 
$node_(573) set X_ 2573 
$node_(573) set Y_ 195 
$node_(573) set Z_ 0.0 
$ns at 0.0 "$node_(573) off" 
$ns at 500.0 "$node_(573) on" 
$node_(574) set X_ 2340 
$node_(574) set Y_ 464 
$node_(574) set Z_ 0.0 
$ns at 0.0 "$node_(574) off" 
$ns at 500.0 "$node_(574) on" 
$node_(575) set X_ 1448 
$node_(575) set Y_ 178 
$node_(575) set Z_ 0.0 
$ns at 0.0 "$node_(575) off" 
$ns at 500.0 "$node_(575) on" 
$node_(576) set X_ 2109 
$node_(576) set Y_ 868 
$node_(576) set Z_ 0.0 
$ns at 0.0 "$node_(576) off" 
$ns at 500.0 "$node_(576) on" 
$node_(577) set X_ 168 
$node_(577) set Y_ 504 
$node_(577) set Z_ 0.0 
$ns at 0.0 "$node_(577) off" 
$ns at 500.0 "$node_(577) on" 
$node_(578) set X_ 2742 
$node_(578) set Y_ 345 
$node_(578) set Z_ 0.0 
$ns at 0.0 "$node_(578) off" 
$ns at 500.0 "$node_(578) on" 
$node_(579) set X_ 557 
$node_(579) set Y_ 426 
$node_(579) set Z_ 0.0 
$ns at 0.0 "$node_(579) off" 
$ns at 500.0 "$node_(579) on" 
$node_(580) set X_ 2901 
$node_(580) set Y_ 338 
$node_(580) set Z_ 0.0 
$ns at 0.0 "$node_(580) off" 
$ns at 500.0 "$node_(580) on" 
$node_(581) set X_ 930 
$node_(581) set Y_ 770 
$node_(581) set Z_ 0.0 
$ns at 0.0 "$node_(581) off" 
$ns at 500.0 "$node_(581) on" 
$node_(582) set X_ 2047 
$node_(582) set Y_ 814 
$node_(582) set Z_ 0.0 
$ns at 0.0 "$node_(582) off" 
$ns at 500.0 "$node_(582) on" 
$node_(583) set X_ 2727 
$node_(583) set Y_ 324 
$node_(583) set Z_ 0.0 
$ns at 0.0 "$node_(583) off" 
$ns at 500.0 "$node_(583) on" 
$node_(584) set X_ 1218 
$node_(584) set Y_ 795 
$node_(584) set Z_ 0.0 
$ns at 0.0 "$node_(584) off" 
$ns at 500.0 "$node_(584) on" 
$node_(585) set X_ 1713 
$node_(585) set Y_ 917 
$node_(585) set Z_ 0.0 
$ns at 0.0 "$node_(585) off" 
$ns at 500.0 "$node_(585) on" 
$node_(586) set X_ 353 
$node_(586) set Y_ 490 
$node_(586) set Z_ 0.0 
$ns at 0.0 "$node_(586) off" 
$ns at 500.0 "$node_(586) on" 
$node_(587) set X_ 1669 
$node_(587) set Y_ 31 
$node_(587) set Z_ 0.0 
$ns at 0.0 "$node_(587) off" 
$ns at 500.0 "$node_(587) on" 
$node_(588) set X_ 2023 
$node_(588) set Y_ 698 
$node_(588) set Z_ 0.0 
$ns at 0.0 "$node_(588) off" 
$ns at 500.0 "$node_(588) on" 
$node_(589) set X_ 2360 
$node_(589) set Y_ 900 
$node_(589) set Z_ 0.0 
$ns at 0.0 "$node_(589) off" 
$ns at 500.0 "$node_(589) on" 
$node_(590) set X_ 1123 
$node_(590) set Y_ 964 
$node_(590) set Z_ 0.0 
$ns at 0.0 "$node_(590) off" 
$ns at 500.0 "$node_(590) on" 
$node_(591) set X_ 2733 
$node_(591) set Y_ 959 
$node_(591) set Z_ 0.0 
$ns at 0.0 "$node_(591) off" 
$ns at 500.0 "$node_(591) on" 
$node_(592) set X_ 2400 
$node_(592) set Y_ 58 
$node_(592) set Z_ 0.0 
$ns at 0.0 "$node_(592) off" 
$ns at 500.0 "$node_(592) on" 
$node_(593) set X_ 594 
$node_(593) set Y_ 934 
$node_(593) set Z_ 0.0 
$ns at 0.0 "$node_(593) off" 
$ns at 500.0 "$node_(593) on" 
$node_(594) set X_ 1772 
$node_(594) set Y_ 534 
$node_(594) set Z_ 0.0 
$ns at 0.0 "$node_(594) off" 
$ns at 500.0 "$node_(594) on" 
$node_(595) set X_ 1618 
$node_(595) set Y_ 85 
$node_(595) set Z_ 0.0 
$ns at 0.0 "$node_(595) off" 
$ns at 500.0 "$node_(595) on" 
$node_(596) set X_ 1221 
$node_(596) set Y_ 493 
$node_(596) set Z_ 0.0 
$ns at 0.0 "$node_(596) off" 
$ns at 500.0 "$node_(596) on" 
$node_(597) set X_ 2297 
$node_(597) set Y_ 868 
$node_(597) set Z_ 0.0 
$ns at 0.0 "$node_(597) off" 
$ns at 500.0 "$node_(597) on" 
$node_(598) set X_ 2510 
$node_(598) set Y_ 155 
$node_(598) set Z_ 0.0 
$ns at 0.0 "$node_(598) off" 
$ns at 500.0 "$node_(598) on" 
$node_(599) set X_ 2441 
$node_(599) set Y_ 784 
$node_(599) set Z_ 0.0 
$ns at 0.0 "$node_(599) off" 
$ns at 500.0 "$node_(599) on" 
$node_(600) set X_ 1253 
$node_(600) set Y_ 565 
$node_(600) set Z_ 0.0 
$ns at 0.0 "$node_(600) off" 
$ns at 600.0 "$node_(600) on" 
$node_(601) set X_ 71 
$node_(601) set Y_ 285 
$node_(601) set Z_ 0.0 
$ns at 0.0 "$node_(601) off" 
$ns at 600.0 "$node_(601) on" 
$node_(602) set X_ 781 
$node_(602) set Y_ 531 
$node_(602) set Z_ 0.0 
$ns at 0.0 "$node_(602) off" 
$ns at 600.0 "$node_(602) on" 
$node_(603) set X_ 2954 
$node_(603) set Y_ 400 
$node_(603) set Z_ 0.0 
$ns at 0.0 "$node_(603) off" 
$ns at 600.0 "$node_(603) on" 
$node_(604) set X_ 2947 
$node_(604) set Y_ 911 
$node_(604) set Z_ 0.0 
$ns at 0.0 "$node_(604) off" 
$ns at 600.0 "$node_(604) on" 
$node_(605) set X_ 2734 
$node_(605) set Y_ 159 
$node_(605) set Z_ 0.0 
$ns at 0.0 "$node_(605) off" 
$ns at 600.0 "$node_(605) on" 
$node_(606) set X_ 2387 
$node_(606) set Y_ 482 
$node_(606) set Z_ 0.0 
$ns at 0.0 "$node_(606) off" 
$ns at 600.0 "$node_(606) on" 
$node_(607) set X_ 1422 
$node_(607) set Y_ 11 
$node_(607) set Z_ 0.0 
$ns at 0.0 "$node_(607) off" 
$ns at 600.0 "$node_(607) on" 
$node_(608) set X_ 1862 
$node_(608) set Y_ 933 
$node_(608) set Z_ 0.0 
$ns at 0.0 "$node_(608) off" 
$ns at 600.0 "$node_(608) on" 
$node_(609) set X_ 1161 
$node_(609) set Y_ 149 
$node_(609) set Z_ 0.0 
$ns at 0.0 "$node_(609) off" 
$ns at 600.0 "$node_(609) on" 
$node_(610) set X_ 142 
$node_(610) set Y_ 963 
$node_(610) set Z_ 0.0 
$ns at 0.0 "$node_(610) off" 
$ns at 600.0 "$node_(610) on" 
$node_(611) set X_ 2455 
$node_(611) set Y_ 89 
$node_(611) set Z_ 0.0 
$ns at 0.0 "$node_(611) off" 
$ns at 600.0 "$node_(611) on" 
$node_(612) set X_ 2438 
$node_(612) set Y_ 75 
$node_(612) set Z_ 0.0 
$ns at 0.0 "$node_(612) off" 
$ns at 600.0 "$node_(612) on" 
$node_(613) set X_ 2604 
$node_(613) set Y_ 872 
$node_(613) set Z_ 0.0 
$ns at 0.0 "$node_(613) off" 
$ns at 600.0 "$node_(613) on" 
$node_(614) set X_ 633 
$node_(614) set Y_ 417 
$node_(614) set Z_ 0.0 
$ns at 0.0 "$node_(614) off" 
$ns at 600.0 "$node_(614) on" 
$node_(615) set X_ 2810 
$node_(615) set Y_ 23 
$node_(615) set Z_ 0.0 
$ns at 0.0 "$node_(615) off" 
$ns at 600.0 "$node_(615) on" 
$node_(616) set X_ 1586 
$node_(616) set Y_ 956 
$node_(616) set Z_ 0.0 
$ns at 0.0 "$node_(616) off" 
$ns at 600.0 "$node_(616) on" 
$node_(617) set X_ 2421 
$node_(617) set Y_ 720 
$node_(617) set Z_ 0.0 
$ns at 0.0 "$node_(617) off" 
$ns at 600.0 "$node_(617) on" 
$node_(618) set X_ 439 
$node_(618) set Y_ 316 
$node_(618) set Z_ 0.0 
$ns at 0.0 "$node_(618) off" 
$ns at 600.0 "$node_(618) on" 
$node_(619) set X_ 1941 
$node_(619) set Y_ 697 
$node_(619) set Z_ 0.0 
$ns at 0.0 "$node_(619) off" 
$ns at 600.0 "$node_(619) on" 
$node_(620) set X_ 1312 
$node_(620) set Y_ 872 
$node_(620) set Z_ 0.0 
$ns at 0.0 "$node_(620) off" 
$ns at 600.0 "$node_(620) on" 
$node_(621) set X_ 2837 
$node_(621) set Y_ 66 
$node_(621) set Z_ 0.0 
$ns at 0.0 "$node_(621) off" 
$ns at 600.0 "$node_(621) on" 
$node_(622) set X_ 2901 
$node_(622) set Y_ 65 
$node_(622) set Z_ 0.0 
$ns at 0.0 "$node_(622) off" 
$ns at 600.0 "$node_(622) on" 
$node_(623) set X_ 1833 
$node_(623) set Y_ 592 
$node_(623) set Z_ 0.0 
$ns at 0.0 "$node_(623) off" 
$ns at 600.0 "$node_(623) on" 
$node_(624) set X_ 2336 
$node_(624) set Y_ 442 
$node_(624) set Z_ 0.0 
$ns at 0.0 "$node_(624) off" 
$ns at 600.0 "$node_(624) on" 
$node_(625) set X_ 162 
$node_(625) set Y_ 945 
$node_(625) set Z_ 0.0 
$ns at 0.0 "$node_(625) off" 
$ns at 600.0 "$node_(625) on" 
$node_(626) set X_ 2268 
$node_(626) set Y_ 646 
$node_(626) set Z_ 0.0 
$ns at 0.0 "$node_(626) off" 
$ns at 600.0 "$node_(626) on" 
$node_(627) set X_ 388 
$node_(627) set Y_ 122 
$node_(627) set Z_ 0.0 
$ns at 0.0 "$node_(627) off" 
$ns at 600.0 "$node_(627) on" 
$node_(628) set X_ 414 
$node_(628) set Y_ 413 
$node_(628) set Z_ 0.0 
$ns at 0.0 "$node_(628) off" 
$ns at 600.0 "$node_(628) on" 
$node_(629) set X_ 605 
$node_(629) set Y_ 522 
$node_(629) set Z_ 0.0 
$ns at 0.0 "$node_(629) off" 
$ns at 600.0 "$node_(629) on" 
$node_(630) set X_ 822 
$node_(630) set Y_ 658 
$node_(630) set Z_ 0.0 
$ns at 0.0 "$node_(630) off" 
$ns at 600.0 "$node_(630) on" 
$node_(631) set X_ 1395 
$node_(631) set Y_ 139 
$node_(631) set Z_ 0.0 
$ns at 0.0 "$node_(631) off" 
$ns at 600.0 "$node_(631) on" 
$node_(632) set X_ 1852 
$node_(632) set Y_ 905 
$node_(632) set Z_ 0.0 
$ns at 0.0 "$node_(632) off" 
$ns at 600.0 "$node_(632) on" 
$node_(633) set X_ 2592 
$node_(633) set Y_ 949 
$node_(633) set Z_ 0.0 
$ns at 0.0 "$node_(633) off" 
$ns at 600.0 "$node_(633) on" 
$node_(634) set X_ 2317 
$node_(634) set Y_ 633 
$node_(634) set Z_ 0.0 
$ns at 0.0 "$node_(634) off" 
$ns at 600.0 "$node_(634) on" 
$node_(635) set X_ 1860 
$node_(635) set Y_ 847 
$node_(635) set Z_ 0.0 
$ns at 0.0 "$node_(635) off" 
$ns at 600.0 "$node_(635) on" 
$node_(636) set X_ 394 
$node_(636) set Y_ 593 
$node_(636) set Z_ 0.0 
$ns at 0.0 "$node_(636) off" 
$ns at 600.0 "$node_(636) on" 
$node_(637) set X_ 1243 
$node_(637) set Y_ 437 
$node_(637) set Z_ 0.0 
$ns at 0.0 "$node_(637) off" 
$ns at 600.0 "$node_(637) on" 
$node_(638) set X_ 821 
$node_(638) set Y_ 791 
$node_(638) set Z_ 0.0 
$ns at 0.0 "$node_(638) off" 
$ns at 600.0 "$node_(638) on" 
$node_(639) set X_ 2223 
$node_(639) set Y_ 549 
$node_(639) set Z_ 0.0 
$ns at 0.0 "$node_(639) off" 
$ns at 600.0 "$node_(639) on" 
$node_(640) set X_ 2477 
$node_(640) set Y_ 626 
$node_(640) set Z_ 0.0 
$ns at 0.0 "$node_(640) off" 
$ns at 600.0 "$node_(640) on" 
$node_(641) set X_ 2399 
$node_(641) set Y_ 619 
$node_(641) set Z_ 0.0 
$ns at 0.0 "$node_(641) off" 
$ns at 600.0 "$node_(641) on" 
$node_(642) set X_ 2805 
$node_(642) set Y_ 616 
$node_(642) set Z_ 0.0 
$ns at 0.0 "$node_(642) off" 
$ns at 600.0 "$node_(642) on" 
$node_(643) set X_ 1742 
$node_(643) set Y_ 962 
$node_(643) set Z_ 0.0 
$ns at 0.0 "$node_(643) off" 
$ns at 600.0 "$node_(643) on" 
$node_(644) set X_ 2549 
$node_(644) set Y_ 270 
$node_(644) set Z_ 0.0 
$ns at 0.0 "$node_(644) off" 
$ns at 600.0 "$node_(644) on" 
$node_(645) set X_ 1367 
$node_(645) set Y_ 543 
$node_(645) set Z_ 0.0 
$ns at 0.0 "$node_(645) off" 
$ns at 600.0 "$node_(645) on" 
$node_(646) set X_ 1063 
$node_(646) set Y_ 895 
$node_(646) set Z_ 0.0 
$ns at 0.0 "$node_(646) off" 
$ns at 600.0 "$node_(646) on" 
$node_(647) set X_ 2067 
$node_(647) set Y_ 37 
$node_(647) set Z_ 0.0 
$ns at 0.0 "$node_(647) off" 
$ns at 600.0 "$node_(647) on" 
$node_(648) set X_ 2926 
$node_(648) set Y_ 575 
$node_(648) set Z_ 0.0 
$ns at 0.0 "$node_(648) off" 
$ns at 600.0 "$node_(648) on" 
$node_(649) set X_ 2268 
$node_(649) set Y_ 878 
$node_(649) set Z_ 0.0 
$ns at 0.0 "$node_(649) off" 
$ns at 600.0 "$node_(649) on" 
$node_(650) set X_ 2802 
$node_(650) set Y_ 128 
$node_(650) set Z_ 0.0 
$ns at 0.0 "$node_(650) off" 
$ns at 600.0 "$node_(650) on" 
$node_(651) set X_ 786 
$node_(651) set Y_ 498 
$node_(651) set Z_ 0.0 
$ns at 0.0 "$node_(651) off" 
$ns at 600.0 "$node_(651) on" 
$node_(652) set X_ 2397 
$node_(652) set Y_ 559 
$node_(652) set Z_ 0.0 
$ns at 0.0 "$node_(652) off" 
$ns at 600.0 "$node_(652) on" 
$node_(653) set X_ 1661 
$node_(653) set Y_ 152 
$node_(653) set Z_ 0.0 
$ns at 0.0 "$node_(653) off" 
$ns at 600.0 "$node_(653) on" 
$node_(654) set X_ 2010 
$node_(654) set Y_ 443 
$node_(654) set Z_ 0.0 
$ns at 0.0 "$node_(654) off" 
$ns at 600.0 "$node_(654) on" 
$node_(655) set X_ 2465 
$node_(655) set Y_ 564 
$node_(655) set Z_ 0.0 
$ns at 0.0 "$node_(655) off" 
$ns at 600.0 "$node_(655) on" 
$node_(656) set X_ 1547 
$node_(656) set Y_ 699 
$node_(656) set Z_ 0.0 
$ns at 0.0 "$node_(656) off" 
$ns at 600.0 "$node_(656) on" 
$node_(657) set X_ 1824 
$node_(657) set Y_ 128 
$node_(657) set Z_ 0.0 
$ns at 0.0 "$node_(657) off" 
$ns at 600.0 "$node_(657) on" 
$node_(658) set X_ 2909 
$node_(658) set Y_ 410 
$node_(658) set Z_ 0.0 
$ns at 0.0 "$node_(658) off" 
$ns at 600.0 "$node_(658) on" 
$node_(659) set X_ 465 
$node_(659) set Y_ 549 
$node_(659) set Z_ 0.0 
$ns at 0.0 "$node_(659) off" 
$ns at 600.0 "$node_(659) on" 
$node_(660) set X_ 1504 
$node_(660) set Y_ 734 
$node_(660) set Z_ 0.0 
$ns at 0.0 "$node_(660) off" 
$ns at 600.0 "$node_(660) on" 
$node_(661) set X_ 2860 
$node_(661) set Y_ 623 
$node_(661) set Z_ 0.0 
$ns at 0.0 "$node_(661) off" 
$ns at 600.0 "$node_(661) on" 
$node_(662) set X_ 1113 
$node_(662) set Y_ 406 
$node_(662) set Z_ 0.0 
$ns at 0.0 "$node_(662) off" 
$ns at 600.0 "$node_(662) on" 
$node_(663) set X_ 560 
$node_(663) set Y_ 305 
$node_(663) set Z_ 0.0 
$ns at 0.0 "$node_(663) off" 
$ns at 600.0 "$node_(663) on" 
$node_(664) set X_ 587 
$node_(664) set Y_ 65 
$node_(664) set Z_ 0.0 
$ns at 0.0 "$node_(664) off" 
$ns at 600.0 "$node_(664) on" 
$node_(665) set X_ 1518 
$node_(665) set Y_ 371 
$node_(665) set Z_ 0.0 
$ns at 0.0 "$node_(665) off" 
$ns at 600.0 "$node_(665) on" 
$node_(666) set X_ 817 
$node_(666) set Y_ 418 
$node_(666) set Z_ 0.0 
$ns at 0.0 "$node_(666) off" 
$ns at 600.0 "$node_(666) on" 
$node_(667) set X_ 2132 
$node_(667) set Y_ 710 
$node_(667) set Z_ 0.0 
$ns at 0.0 "$node_(667) off" 
$ns at 600.0 "$node_(667) on" 
$node_(668) set X_ 57 
$node_(668) set Y_ 249 
$node_(668) set Z_ 0.0 
$ns at 0.0 "$node_(668) off" 
$ns at 600.0 "$node_(668) on" 
$node_(669) set X_ 1403 
$node_(669) set Y_ 759 
$node_(669) set Z_ 0.0 
$ns at 0.0 "$node_(669) off" 
$ns at 600.0 "$node_(669) on" 
$node_(670) set X_ 107 
$node_(670) set Y_ 434 
$node_(670) set Z_ 0.0 
$ns at 0.0 "$node_(670) off" 
$ns at 600.0 "$node_(670) on" 
$node_(671) set X_ 479 
$node_(671) set Y_ 665 
$node_(671) set Z_ 0.0 
$ns at 0.0 "$node_(671) off" 
$ns at 600.0 "$node_(671) on" 
$node_(672) set X_ 946 
$node_(672) set Y_ 381 
$node_(672) set Z_ 0.0 
$ns at 0.0 "$node_(672) off" 
$ns at 600.0 "$node_(672) on" 
$node_(673) set X_ 940 
$node_(673) set Y_ 505 
$node_(673) set Z_ 0.0 
$ns at 0.0 "$node_(673) off" 
$ns at 600.0 "$node_(673) on" 
$node_(674) set X_ 236 
$node_(674) set Y_ 813 
$node_(674) set Z_ 0.0 
$ns at 0.0 "$node_(674) off" 
$ns at 600.0 "$node_(674) on" 
$node_(675) set X_ 2494 
$node_(675) set Y_ 300 
$node_(675) set Z_ 0.0 
$ns at 0.0 "$node_(675) off" 
$ns at 600.0 "$node_(675) on" 
$node_(676) set X_ 1677 
$node_(676) set Y_ 367 
$node_(676) set Z_ 0.0 
$ns at 0.0 "$node_(676) off" 
$ns at 600.0 "$node_(676) on" 
$node_(677) set X_ 1286 
$node_(677) set Y_ 630 
$node_(677) set Z_ 0.0 
$ns at 0.0 "$node_(677) off" 
$ns at 600.0 "$node_(677) on" 
$node_(678) set X_ 2446 
$node_(678) set Y_ 283 
$node_(678) set Z_ 0.0 
$ns at 0.0 "$node_(678) off" 
$ns at 600.0 "$node_(678) on" 
$node_(679) set X_ 771 
$node_(679) set Y_ 348 
$node_(679) set Z_ 0.0 
$ns at 0.0 "$node_(679) off" 
$ns at 600.0 "$node_(679) on" 
$node_(680) set X_ 931 
$node_(680) set Y_ 364 
$node_(680) set Z_ 0.0 
$ns at 0.0 "$node_(680) off" 
$ns at 600.0 "$node_(680) on" 
$node_(681) set X_ 2066 
$node_(681) set Y_ 293 
$node_(681) set Z_ 0.0 
$ns at 0.0 "$node_(681) off" 
$ns at 600.0 "$node_(681) on" 
$node_(682) set X_ 1693 
$node_(682) set Y_ 451 
$node_(682) set Z_ 0.0 
$ns at 0.0 "$node_(682) off" 
$ns at 600.0 "$node_(682) on" 
$node_(683) set X_ 1887 
$node_(683) set Y_ 899 
$node_(683) set Z_ 0.0 
$ns at 0.0 "$node_(683) off" 
$ns at 600.0 "$node_(683) on" 
$node_(684) set X_ 1990 
$node_(684) set Y_ 907 
$node_(684) set Z_ 0.0 
$ns at 0.0 "$node_(684) off" 
$ns at 600.0 "$node_(684) on" 
$node_(685) set X_ 1586 
$node_(685) set Y_ 319 
$node_(685) set Z_ 0.0 
$ns at 0.0 "$node_(685) off" 
$ns at 600.0 "$node_(685) on" 
$node_(686) set X_ 2345 
$node_(686) set Y_ 983 
$node_(686) set Z_ 0.0 
$ns at 0.0 "$node_(686) off" 
$ns at 600.0 "$node_(686) on" 
$node_(687) set X_ 1405 
$node_(687) set Y_ 978 
$node_(687) set Z_ 0.0 
$ns at 0.0 "$node_(687) off" 
$ns at 600.0 "$node_(687) on" 
$node_(688) set X_ 506 
$node_(688) set Y_ 484 
$node_(688) set Z_ 0.0 
$ns at 0.0 "$node_(688) off" 
$ns at 600.0 "$node_(688) on" 
$node_(689) set X_ 945 
$node_(689) set Y_ 515 
$node_(689) set Z_ 0.0 
$ns at 0.0 "$node_(689) off" 
$ns at 600.0 "$node_(689) on" 
$node_(690) set X_ 704 
$node_(690) set Y_ 844 
$node_(690) set Z_ 0.0 
$ns at 0.0 "$node_(690) off" 
$ns at 600.0 "$node_(690) on" 
$node_(691) set X_ 2869 
$node_(691) set Y_ 677 
$node_(691) set Z_ 0.0 
$ns at 0.0 "$node_(691) off" 
$ns at 600.0 "$node_(691) on" 
$node_(692) set X_ 1428 
$node_(692) set Y_ 599 
$node_(692) set Z_ 0.0 
$ns at 0.0 "$node_(692) off" 
$ns at 600.0 "$node_(692) on" 
$node_(693) set X_ 171 
$node_(693) set Y_ 93 
$node_(693) set Z_ 0.0 
$ns at 0.0 "$node_(693) off" 
$ns at 600.0 "$node_(693) on" 
$node_(694) set X_ 2948 
$node_(694) set Y_ 234 
$node_(694) set Z_ 0.0 
$ns at 0.0 "$node_(694) off" 
$ns at 600.0 "$node_(694) on" 
$node_(695) set X_ 1820 
$node_(695) set Y_ 767 
$node_(695) set Z_ 0.0 
$ns at 0.0 "$node_(695) off" 
$ns at 600.0 "$node_(695) on" 
$node_(696) set X_ 535 
$node_(696) set Y_ 563 
$node_(696) set Z_ 0.0 
$ns at 0.0 "$node_(696) off" 
$ns at 600.0 "$node_(696) on" 
$node_(697) set X_ 2311 
$node_(697) set Y_ 789 
$node_(697) set Z_ 0.0 
$ns at 0.0 "$node_(697) off" 
$ns at 600.0 "$node_(697) on" 
$node_(698) set X_ 811 
$node_(698) set Y_ 126 
$node_(698) set Z_ 0.0 
$ns at 0.0 "$node_(698) off" 
$ns at 600.0 "$node_(698) on" 
$node_(699) set X_ 609 
$node_(699) set Y_ 28 
$node_(699) set Z_ 0.0 
$ns at 0.0 "$node_(699) off" 
$ns at 600.0 "$node_(699) on" 
$node_(700) set X_ 1794 
$node_(700) set Y_ 560 
$node_(700) set Z_ 0.0 
$ns at 0.0 "$node_(700) off" 
$ns at 700.0 "$node_(700) on" 
$node_(701) set X_ 99 
$node_(701) set Y_ 506 
$node_(701) set Z_ 0.0 
$ns at 0.0 "$node_(701) off" 
$ns at 700.0 "$node_(701) on" 
$node_(702) set X_ 2120 
$node_(702) set Y_ 548 
$node_(702) set Z_ 0.0 
$ns at 0.0 "$node_(702) off" 
$ns at 700.0 "$node_(702) on" 
$node_(703) set X_ 539 
$node_(703) set Y_ 735 
$node_(703) set Z_ 0.0 
$ns at 0.0 "$node_(703) off" 
$ns at 700.0 "$node_(703) on" 
$node_(704) set X_ 1525 
$node_(704) set Y_ 742 
$node_(704) set Z_ 0.0 
$ns at 0.0 "$node_(704) off" 
$ns at 700.0 "$node_(704) on" 
$node_(705) set X_ 1634 
$node_(705) set Y_ 570 
$node_(705) set Z_ 0.0 
$ns at 0.0 "$node_(705) off" 
$ns at 700.0 "$node_(705) on" 
$node_(706) set X_ 999 
$node_(706) set Y_ 996 
$node_(706) set Z_ 0.0 
$ns at 0.0 "$node_(706) off" 
$ns at 700.0 "$node_(706) on" 
$node_(707) set X_ 2600 
$node_(707) set Y_ 5 
$node_(707) set Z_ 0.0 
$ns at 0.0 "$node_(707) off" 
$ns at 700.0 "$node_(707) on" 
$node_(708) set X_ 57 
$node_(708) set Y_ 374 
$node_(708) set Z_ 0.0 
$ns at 0.0 "$node_(708) off" 
$ns at 700.0 "$node_(708) on" 
$node_(709) set X_ 2193 
$node_(709) set Y_ 920 
$node_(709) set Z_ 0.0 
$ns at 0.0 "$node_(709) off" 
$ns at 700.0 "$node_(709) on" 
$node_(710) set X_ 1357 
$node_(710) set Y_ 631 
$node_(710) set Z_ 0.0 
$ns at 0.0 "$node_(710) off" 
$ns at 700.0 "$node_(710) on" 
$node_(711) set X_ 845 
$node_(711) set Y_ 984 
$node_(711) set Z_ 0.0 
$ns at 0.0 "$node_(711) off" 
$ns at 700.0 "$node_(711) on" 
$node_(712) set X_ 366 
$node_(712) set Y_ 309 
$node_(712) set Z_ 0.0 
$ns at 0.0 "$node_(712) off" 
$ns at 700.0 "$node_(712) on" 
$node_(713) set X_ 2103 
$node_(713) set Y_ 825 
$node_(713) set Z_ 0.0 
$ns at 0.0 "$node_(713) off" 
$ns at 700.0 "$node_(713) on" 
$node_(714) set X_ 977 
$node_(714) set Y_ 154 
$node_(714) set Z_ 0.0 
$ns at 0.0 "$node_(714) off" 
$ns at 700.0 "$node_(714) on" 
$node_(715) set X_ 1166 
$node_(715) set Y_ 52 
$node_(715) set Z_ 0.0 
$ns at 0.0 "$node_(715) off" 
$ns at 700.0 "$node_(715) on" 
$node_(716) set X_ 1902 
$node_(716) set Y_ 293 
$node_(716) set Z_ 0.0 
$ns at 0.0 "$node_(716) off" 
$ns at 700.0 "$node_(716) on" 
$node_(717) set X_ 307 
$node_(717) set Y_ 956 
$node_(717) set Z_ 0.0 
$ns at 0.0 "$node_(717) off" 
$ns at 700.0 "$node_(717) on" 
$node_(718) set X_ 315 
$node_(718) set Y_ 496 
$node_(718) set Z_ 0.0 
$ns at 0.0 "$node_(718) off" 
$ns at 700.0 "$node_(718) on" 
$node_(719) set X_ 7 
$node_(719) set Y_ 522 
$node_(719) set Z_ 0.0 
$ns at 0.0 "$node_(719) off" 
$ns at 700.0 "$node_(719) on" 
$node_(720) set X_ 1560 
$node_(720) set Y_ 893 
$node_(720) set Z_ 0.0 
$ns at 0.0 "$node_(720) off" 
$ns at 700.0 "$node_(720) on" 
$node_(721) set X_ 2043 
$node_(721) set Y_ 887 
$node_(721) set Z_ 0.0 
$ns at 0.0 "$node_(721) off" 
$ns at 700.0 "$node_(721) on" 
$node_(722) set X_ 1832 
$node_(722) set Y_ 726 
$node_(722) set Z_ 0.0 
$ns at 0.0 "$node_(722) off" 
$ns at 700.0 "$node_(722) on" 
$node_(723) set X_ 2287 
$node_(723) set Y_ 540 
$node_(723) set Z_ 0.0 
$ns at 0.0 "$node_(723) off" 
$ns at 700.0 "$node_(723) on" 
$node_(724) set X_ 2526 
$node_(724) set Y_ 47 
$node_(724) set Z_ 0.0 
$ns at 0.0 "$node_(724) off" 
$ns at 700.0 "$node_(724) on" 
$node_(725) set X_ 1770 
$node_(725) set Y_ 373 
$node_(725) set Z_ 0.0 
$ns at 0.0 "$node_(725) off" 
$ns at 700.0 "$node_(725) on" 
$node_(726) set X_ 2464 
$node_(726) set Y_ 818 
$node_(726) set Z_ 0.0 
$ns at 0.0 "$node_(726) off" 
$ns at 700.0 "$node_(726) on" 
$node_(727) set X_ 2567 
$node_(727) set Y_ 131 
$node_(727) set Z_ 0.0 
$ns at 0.0 "$node_(727) off" 
$ns at 700.0 "$node_(727) on" 
$node_(728) set X_ 2452 
$node_(728) set Y_ 517 
$node_(728) set Z_ 0.0 
$ns at 0.0 "$node_(728) off" 
$ns at 700.0 "$node_(728) on" 
$node_(729) set X_ 2264 
$node_(729) set Y_ 974 
$node_(729) set Z_ 0.0 
$ns at 0.0 "$node_(729) off" 
$ns at 700.0 "$node_(729) on" 
$node_(730) set X_ 556 
$node_(730) set Y_ 173 
$node_(730) set Z_ 0.0 
$ns at 0.0 "$node_(730) off" 
$ns at 700.0 "$node_(730) on" 
$node_(731) set X_ 1227 
$node_(731) set Y_ 606 
$node_(731) set Z_ 0.0 
$ns at 0.0 "$node_(731) off" 
$ns at 700.0 "$node_(731) on" 
$node_(732) set X_ 2176 
$node_(732) set Y_ 766 
$node_(732) set Z_ 0.0 
$ns at 0.0 "$node_(732) off" 
$ns at 700.0 "$node_(732) on" 
$node_(733) set X_ 2516 
$node_(733) set Y_ 865 
$node_(733) set Z_ 0.0 
$ns at 0.0 "$node_(733) off" 
$ns at 700.0 "$node_(733) on" 
$node_(734) set X_ 363 
$node_(734) set Y_ 32 
$node_(734) set Z_ 0.0 
$ns at 0.0 "$node_(734) off" 
$ns at 700.0 "$node_(734) on" 
$node_(735) set X_ 2193 
$node_(735) set Y_ 793 
$node_(735) set Z_ 0.0 
$ns at 0.0 "$node_(735) off" 
$ns at 700.0 "$node_(735) on" 
$node_(736) set X_ 1958 
$node_(736) set Y_ 17 
$node_(736) set Z_ 0.0 
$ns at 0.0 "$node_(736) off" 
$ns at 700.0 "$node_(736) on" 
$node_(737) set X_ 1848 
$node_(737) set Y_ 901 
$node_(737) set Z_ 0.0 
$ns at 0.0 "$node_(737) off" 
$ns at 700.0 "$node_(737) on" 
$node_(738) set X_ 943 
$node_(738) set Y_ 193 
$node_(738) set Z_ 0.0 
$ns at 0.0 "$node_(738) off" 
$ns at 700.0 "$node_(738) on" 
$node_(739) set X_ 2478 
$node_(739) set Y_ 785 
$node_(739) set Z_ 0.0 
$ns at 0.0 "$node_(739) off" 
$ns at 700.0 "$node_(739) on" 
$node_(740) set X_ 937 
$node_(740) set Y_ 525 
$node_(740) set Z_ 0.0 
$ns at 0.0 "$node_(740) off" 
$ns at 700.0 "$node_(740) on" 
$node_(741) set X_ 2397 
$node_(741) set Y_ 294 
$node_(741) set Z_ 0.0 
$ns at 0.0 "$node_(741) off" 
$ns at 700.0 "$node_(741) on" 
$node_(742) set X_ 2052 
$node_(742) set Y_ 658 
$node_(742) set Z_ 0.0 
$ns at 0.0 "$node_(742) off" 
$ns at 700.0 "$node_(742) on" 
$node_(743) set X_ 2582 
$node_(743) set Y_ 170 
$node_(743) set Z_ 0.0 
$ns at 0.0 "$node_(743) off" 
$ns at 700.0 "$node_(743) on" 
$node_(744) set X_ 1285 
$node_(744) set Y_ 325 
$node_(744) set Z_ 0.0 
$ns at 0.0 "$node_(744) off" 
$ns at 700.0 "$node_(744) on" 
$node_(745) set X_ 1862 
$node_(745) set Y_ 450 
$node_(745) set Z_ 0.0 
$ns at 0.0 "$node_(745) off" 
$ns at 700.0 "$node_(745) on" 
$node_(746) set X_ 355 
$node_(746) set Y_ 111 
$node_(746) set Z_ 0.0 
$ns at 0.0 "$node_(746) off" 
$ns at 700.0 "$node_(746) on" 
$node_(747) set X_ 1504 
$node_(747) set Y_ 952 
$node_(747) set Z_ 0.0 
$ns at 0.0 "$node_(747) off" 
$ns at 700.0 "$node_(747) on" 
$node_(748) set X_ 1264 
$node_(748) set Y_ 985 
$node_(748) set Z_ 0.0 
$ns at 0.0 "$node_(748) off" 
$ns at 700.0 "$node_(748) on" 
$node_(749) set X_ 2179 
$node_(749) set Y_ 838 
$node_(749) set Z_ 0.0 
$ns at 0.0 "$node_(749) off" 
$ns at 700.0 "$node_(749) on" 
$node_(750) set X_ 1070 
$node_(750) set Y_ 377 
$node_(750) set Z_ 0.0 
$ns at 0.0 "$node_(750) off" 
$ns at 700.0 "$node_(750) on" 
$node_(751) set X_ 923 
$node_(751) set Y_ 619 
$node_(751) set Z_ 0.0 
$ns at 0.0 "$node_(751) off" 
$ns at 700.0 "$node_(751) on" 
$node_(752) set X_ 1151 
$node_(752) set Y_ 114 
$node_(752) set Z_ 0.0 
$ns at 0.0 "$node_(752) off" 
$ns at 700.0 "$node_(752) on" 
$node_(753) set X_ 513 
$node_(753) set Y_ 928 
$node_(753) set Z_ 0.0 
$ns at 0.0 "$node_(753) off" 
$ns at 700.0 "$node_(753) on" 
$node_(754) set X_ 1862 
$node_(754) set Y_ 251 
$node_(754) set Z_ 0.0 
$ns at 0.0 "$node_(754) off" 
$ns at 700.0 "$node_(754) on" 
$node_(755) set X_ 1796 
$node_(755) set Y_ 58 
$node_(755) set Z_ 0.0 
$ns at 0.0 "$node_(755) off" 
$ns at 700.0 "$node_(755) on" 
$node_(756) set X_ 1758 
$node_(756) set Y_ 668 
$node_(756) set Z_ 0.0 
$ns at 0.0 "$node_(756) off" 
$ns at 700.0 "$node_(756) on" 
$node_(757) set X_ 1726 
$node_(757) set Y_ 575 
$node_(757) set Z_ 0.0 
$ns at 0.0 "$node_(757) off" 
$ns at 700.0 "$node_(757) on" 
$node_(758) set X_ 2591 
$node_(758) set Y_ 336 
$node_(758) set Z_ 0.0 
$ns at 0.0 "$node_(758) off" 
$ns at 700.0 "$node_(758) on" 
$node_(759) set X_ 1423 
$node_(759) set Y_ 280 
$node_(759) set Z_ 0.0 
$ns at 0.0 "$node_(759) off" 
$ns at 700.0 "$node_(759) on" 
$node_(760) set X_ 2995 
$node_(760) set Y_ 305 
$node_(760) set Z_ 0.0 
$ns at 0.0 "$node_(760) off" 
$ns at 700.0 "$node_(760) on" 
$node_(761) set X_ 2230 
$node_(761) set Y_ 395 
$node_(761) set Z_ 0.0 
$ns at 0.0 "$node_(761) off" 
$ns at 700.0 "$node_(761) on" 
$node_(762) set X_ 2252 
$node_(762) set Y_ 804 
$node_(762) set Z_ 0.0 
$ns at 0.0 "$node_(762) off" 
$ns at 700.0 "$node_(762) on" 
$node_(763) set X_ 2741 
$node_(763) set Y_ 169 
$node_(763) set Z_ 0.0 
$ns at 0.0 "$node_(763) off" 
$ns at 700.0 "$node_(763) on" 
$node_(764) set X_ 1696 
$node_(764) set Y_ 324 
$node_(764) set Z_ 0.0 
$ns at 0.0 "$node_(764) off" 
$ns at 700.0 "$node_(764) on" 
$node_(765) set X_ 860 
$node_(765) set Y_ 986 
$node_(765) set Z_ 0.0 
$ns at 0.0 "$node_(765) off" 
$ns at 700.0 "$node_(765) on" 
$node_(766) set X_ 2184 
$node_(766) set Y_ 195 
$node_(766) set Z_ 0.0 
$ns at 0.0 "$node_(766) off" 
$ns at 700.0 "$node_(766) on" 
$node_(767) set X_ 387 
$node_(767) set Y_ 694 
$node_(767) set Z_ 0.0 
$ns at 0.0 "$node_(767) off" 
$ns at 700.0 "$node_(767) on" 
$node_(768) set X_ 690 
$node_(768) set Y_ 940 
$node_(768) set Z_ 0.0 
$ns at 0.0 "$node_(768) off" 
$ns at 700.0 "$node_(768) on" 
$node_(769) set X_ 185 
$node_(769) set Y_ 71 
$node_(769) set Z_ 0.0 
$ns at 0.0 "$node_(769) off" 
$ns at 700.0 "$node_(769) on" 
$node_(770) set X_ 2412 
$node_(770) set Y_ 681 
$node_(770) set Z_ 0.0 
$ns at 0.0 "$node_(770) off" 
$ns at 700.0 "$node_(770) on" 
$node_(771) set X_ 1794 
$node_(771) set Y_ 308 
$node_(771) set Z_ 0.0 
$ns at 0.0 "$node_(771) off" 
$ns at 700.0 "$node_(771) on" 
$node_(772) set X_ 2797 
$node_(772) set Y_ 931 
$node_(772) set Z_ 0.0 
$ns at 0.0 "$node_(772) off" 
$ns at 700.0 "$node_(772) on" 
$node_(773) set X_ 1408 
$node_(773) set Y_ 886 
$node_(773) set Z_ 0.0 
$ns at 0.0 "$node_(773) off" 
$ns at 700.0 "$node_(773) on" 
$node_(774) set X_ 2687 
$node_(774) set Y_ 411 
$node_(774) set Z_ 0.0 
$ns at 0.0 "$node_(774) off" 
$ns at 700.0 "$node_(774) on" 
$node_(775) set X_ 1360 
$node_(775) set Y_ 485 
$node_(775) set Z_ 0.0 
$ns at 0.0 "$node_(775) off" 
$ns at 700.0 "$node_(775) on" 
$node_(776) set X_ 251 
$node_(776) set Y_ 917 
$node_(776) set Z_ 0.0 
$ns at 0.0 "$node_(776) off" 
$ns at 700.0 "$node_(776) on" 
$node_(777) set X_ 2742 
$node_(777) set Y_ 415 
$node_(777) set Z_ 0.0 
$ns at 0.0 "$node_(777) off" 
$ns at 700.0 "$node_(777) on" 
$node_(778) set X_ 2581 
$node_(778) set Y_ 854 
$node_(778) set Z_ 0.0 
$ns at 0.0 "$node_(778) off" 
$ns at 700.0 "$node_(778) on" 
$node_(779) set X_ 459 
$node_(779) set Y_ 595 
$node_(779) set Z_ 0.0 
$ns at 0.0 "$node_(779) off" 
$ns at 700.0 "$node_(779) on" 
$node_(780) set X_ 740 
$node_(780) set Y_ 793 
$node_(780) set Z_ 0.0 
$ns at 0.0 "$node_(780) off" 
$ns at 700.0 "$node_(780) on" 
$node_(781) set X_ 2937 
$node_(781) set Y_ 279 
$node_(781) set Z_ 0.0 
$ns at 0.0 "$node_(781) off" 
$ns at 700.0 "$node_(781) on" 
$node_(782) set X_ 1714 
$node_(782) set Y_ 265 
$node_(782) set Z_ 0.0 
$ns at 0.0 "$node_(782) off" 
$ns at 700.0 "$node_(782) on" 
$node_(783) set X_ 1823 
$node_(783) set Y_ 589 
$node_(783) set Z_ 0.0 
$ns at 0.0 "$node_(783) off" 
$ns at 700.0 "$node_(783) on" 
$node_(784) set X_ 35 
$node_(784) set Y_ 88 
$node_(784) set Z_ 0.0 
$ns at 0.0 "$node_(784) off" 
$ns at 700.0 "$node_(784) on" 
$node_(785) set X_ 344 
$node_(785) set Y_ 384 
$node_(785) set Z_ 0.0 
$ns at 0.0 "$node_(785) off" 
$ns at 700.0 "$node_(785) on" 
$node_(786) set X_ 1970 
$node_(786) set Y_ 687 
$node_(786) set Z_ 0.0 
$ns at 0.0 "$node_(786) off" 
$ns at 700.0 "$node_(786) on" 
$node_(787) set X_ 580 
$node_(787) set Y_ 186 
$node_(787) set Z_ 0.0 
$ns at 0.0 "$node_(787) off" 
$ns at 700.0 "$node_(787) on" 
$node_(788) set X_ 928 
$node_(788) set Y_ 261 
$node_(788) set Z_ 0.0 
$ns at 0.0 "$node_(788) off" 
$ns at 700.0 "$node_(788) on" 
$node_(789) set X_ 2669 
$node_(789) set Y_ 644 
$node_(789) set Z_ 0.0 
$ns at 0.0 "$node_(789) off" 
$ns at 700.0 "$node_(789) on" 
$node_(790) set X_ 2270 
$node_(790) set Y_ 119 
$node_(790) set Z_ 0.0 
$ns at 0.0 "$node_(790) off" 
$ns at 700.0 "$node_(790) on" 
$node_(791) set X_ 955 
$node_(791) set Y_ 531 
$node_(791) set Z_ 0.0 
$ns at 0.0 "$node_(791) off" 
$ns at 700.0 "$node_(791) on" 
$node_(792) set X_ 1937 
$node_(792) set Y_ 220 
$node_(792) set Z_ 0.0 
$ns at 0.0 "$node_(792) off" 
$ns at 700.0 "$node_(792) on" 
$node_(793) set X_ 332 
$node_(793) set Y_ 366 
$node_(793) set Z_ 0.0 
$ns at 0.0 "$node_(793) off" 
$ns at 700.0 "$node_(793) on" 
$node_(794) set X_ 1261 
$node_(794) set Y_ 751 
$node_(794) set Z_ 0.0 
$ns at 0.0 "$node_(794) off" 
$ns at 700.0 "$node_(794) on" 
$node_(795) set X_ 1442 
$node_(795) set Y_ 521 
$node_(795) set Z_ 0.0 
$ns at 0.0 "$node_(795) off" 
$ns at 700.0 "$node_(795) on" 
$node_(796) set X_ 2996 
$node_(796) set Y_ 562 
$node_(796) set Z_ 0.0 
$ns at 0.0 "$node_(796) off" 
$ns at 700.0 "$node_(796) on" 
$node_(797) set X_ 1073 
$node_(797) set Y_ 139 
$node_(797) set Z_ 0.0 
$ns at 0.0 "$node_(797) off" 
$ns at 700.0 "$node_(797) on" 
$node_(798) set X_ 2999 
$node_(798) set Y_ 416 
$node_(798) set Z_ 0.0 
$ns at 0.0 "$node_(798) off" 
$ns at 700.0 "$node_(798) on" 
$node_(799) set X_ 2945 
$node_(799) set Y_ 260 
$node_(799) set Z_ 0.0 
$ns at 0.0 "$node_(799) off" 
$ns at 700.0 "$node_(799) on" 

# Generation of movements
$ns at 0.0 "$node_(0) setdest 34504 10170 15.0" 
$ns at 72.92995872978265 "$node_(0) setdest 14848 20039 15.0" 
$ns at 156.80911674849023 "$node_(0) setdest 25341 10814 18.0" 
$ns at 229.78011860392502 "$node_(0) setdest 113673 41169 16.0" 
$ns at 263.2673168761359 "$node_(0) setdest 30384 45429 12.0" 
$ns at 340.3790584576677 "$node_(0) setdest 146860 12654 13.0" 
$ns at 387.4566807229481 "$node_(0) setdest 47509 45959 9.0" 
$ns at 443.73804681794223 "$node_(0) setdest 96549 43913 7.0" 
$ns at 529.7216367418125 "$node_(0) setdest 106010 11318 12.0" 
$ns at 585.7533493583073 "$node_(0) setdest 89906 2543 18.0" 
$ns at 629.862981825936 "$node_(0) setdest 146911 37901 3.0" 
$ns at 675.0974313761383 "$node_(0) setdest 56042 25819 9.0" 
$ns at 776.3442796746126 "$node_(0) setdest 34991 11178 5.0" 
$ns at 816.8233544533362 "$node_(0) setdest 208329 79804 19.0" 
$ns at 0.0 "$node_(1) setdest 2507 10590 10.0" 
$ns at 116.66988549472856 "$node_(1) setdest 79225 25263 2.0" 
$ns at 155.568225651038 "$node_(1) setdest 30049 31677 14.0" 
$ns at 262.78026083182846 "$node_(1) setdest 115852 43032 6.0" 
$ns at 352.6048379994604 "$node_(1) setdest 116639 18838 8.0" 
$ns at 419.2309924626725 "$node_(1) setdest 14642 54097 15.0" 
$ns at 530.3431427462481 "$node_(1) setdest 101256 50084 2.0" 
$ns at 573.1778381796764 "$node_(1) setdest 90995 4681 8.0" 
$ns at 605.2309791030706 "$node_(1) setdest 208430 50520 15.0" 
$ns at 746.5003350271462 "$node_(1) setdest 15107 62951 4.0" 
$ns at 809.6511352694433 "$node_(1) setdest 52116 66330 9.0" 
$ns at 0.0 "$node_(2) setdest 15302 21212 10.0" 
$ns at 53.77753703868926 "$node_(2) setdest 57059 16926 14.0" 
$ns at 117.27493872218994 "$node_(2) setdest 44536 16323 2.0" 
$ns at 161.53194507253312 "$node_(2) setdest 90478 4979 7.0" 
$ns at 220.12463221471603 "$node_(2) setdest 125289 40345 4.0" 
$ns at 255.46407099467507 "$node_(2) setdest 29246 37497 13.0" 
$ns at 304.3633628284494 "$node_(2) setdest 159151 45484 8.0" 
$ns at 373.36780050747984 "$node_(2) setdest 82447 2408 4.0" 
$ns at 436.2174049703677 "$node_(2) setdest 31856 5293 19.0" 
$ns at 601.0426163790742 "$node_(2) setdest 86457 61065 10.0" 
$ns at 668.0363365714306 "$node_(2) setdest 77843 15132 8.0" 
$ns at 748.0695216168227 "$node_(2) setdest 191162 63107 6.0" 
$ns at 787.6818918082548 "$node_(2) setdest 204714 70584 12.0" 
$ns at 842.8618951575455 "$node_(2) setdest 102417 84848 4.0" 
$ns at 892.9973833876372 "$node_(2) setdest 175390 65966 17.0" 
$ns at 0.0 "$node_(3) setdest 9284 30419 19.0" 
$ns at 196.96659173927216 "$node_(3) setdest 56081 1162 8.0" 
$ns at 281.0213169713123 "$node_(3) setdest 15793 41544 8.0" 
$ns at 327.7068893507791 "$node_(3) setdest 96975 26046 11.0" 
$ns at 451.1592515006982 "$node_(3) setdest 160811 10859 13.0" 
$ns at 580.5484388478618 "$node_(3) setdest 220214 70701 18.0" 
$ns at 754.2264253874778 "$node_(3) setdest 245901 43996 17.0" 
$ns at 875.7297951552359 "$node_(3) setdest 100433 3058 15.0" 
$ns at 0.0 "$node_(4) setdest 45421 9373 8.0" 
$ns at 42.57599322793959 "$node_(4) setdest 5184 10901 11.0" 
$ns at 135.3308326377604 "$node_(4) setdest 62456 28687 13.0" 
$ns at 253.5307332118761 "$node_(4) setdest 141793 44599 12.0" 
$ns at 384.32664799249443 "$node_(4) setdest 56835 24026 4.0" 
$ns at 448.01901957148846 "$node_(4) setdest 11373 9357 11.0" 
$ns at 504.52244230130896 "$node_(4) setdest 7853 11565 1.0" 
$ns at 540.6979259254477 "$node_(4) setdest 140268 57530 17.0" 
$ns at 675.5881085816023 "$node_(4) setdest 69327 27325 1.0" 
$ns at 706.7951734894795 "$node_(4) setdest 22492 18531 1.0" 
$ns at 737.468152044062 "$node_(4) setdest 58676 29395 11.0" 
$ns at 793.9895268857468 "$node_(4) setdest 261776 62694 18.0" 
$ns at 0.0 "$node_(5) setdest 49922 24228 16.0" 
$ns at 118.61102526941472 "$node_(5) setdest 20751 5308 13.0" 
$ns at 196.91143104703838 "$node_(5) setdest 6033 6031 10.0" 
$ns at 262.1709737146099 "$node_(5) setdest 110666 34410 2.0" 
$ns at 301.376023014036 "$node_(5) setdest 17424 9462 12.0" 
$ns at 437.5407668514354 "$node_(5) setdest 13747 57673 8.0" 
$ns at 499.17845276695425 "$node_(5) setdest 23947 646 6.0" 
$ns at 536.3676392870674 "$node_(5) setdest 10742 19866 6.0" 
$ns at 619.4740169020479 "$node_(5) setdest 51220 67050 3.0" 
$ns at 668.5207954380239 "$node_(5) setdest 96364 67586 1.0" 
$ns at 703.0919774924492 "$node_(5) setdest 185385 56024 19.0" 
$ns at 818.0448705247809 "$node_(5) setdest 215972 59644 16.0" 
$ns at 0.0 "$node_(6) setdest 25035 11797 17.0" 
$ns at 179.08667890675596 "$node_(6) setdest 1261 32852 8.0" 
$ns at 281.7211523937208 "$node_(6) setdest 127656 54511 19.0" 
$ns at 458.6660767692279 "$node_(6) setdest 152166 10109 4.0" 
$ns at 506.09723213937286 "$node_(6) setdest 41200 46647 6.0" 
$ns at 577.0799273422258 "$node_(6) setdest 209212 52648 14.0" 
$ns at 661.7832821600063 "$node_(6) setdest 28429 12109 3.0" 
$ns at 715.6595735689706 "$node_(6) setdest 135637 15143 20.0" 
$ns at 885.2355322573092 "$node_(6) setdest 197972 64111 14.0" 
$ns at 0.0 "$node_(7) setdest 50500 9828 17.0" 
$ns at 182.74443371299768 "$node_(7) setdest 29902 11912 15.0" 
$ns at 305.70040464138293 "$node_(7) setdest 97442 20306 3.0" 
$ns at 358.3302028187685 "$node_(7) setdest 175932 1022 7.0" 
$ns at 436.8826197583668 "$node_(7) setdest 55314 2288 13.0" 
$ns at 484.2789279200792 "$node_(7) setdest 66097 22677 7.0" 
$ns at 572.6083393808473 "$node_(7) setdest 130756 12548 19.0" 
$ns at 723.7274689928026 "$node_(7) setdest 118186 27373 1.0" 
$ns at 759.0885454250208 "$node_(7) setdest 85228 4760 7.0" 
$ns at 835.9379292264368 "$node_(7) setdest 144631 46233 12.0" 
$ns at 867.061541507454 "$node_(7) setdest 3955 75559 4.0" 
$ns at 0.0 "$node_(8) setdest 43097 12556 2.0" 
$ns at 46.91708858010695 "$node_(8) setdest 28845 27987 18.0" 
$ns at 150.44773050698905 "$node_(8) setdest 110497 38555 4.0" 
$ns at 185.7290000547006 "$node_(8) setdest 14558 11966 18.0" 
$ns at 345.4239417190369 "$node_(8) setdest 143613 54474 12.0" 
$ns at 383.89007855979753 "$node_(8) setdest 143306 57279 9.0" 
$ns at 490.21479442192606 "$node_(8) setdest 154801 22933 18.0" 
$ns at 601.0947426152245 "$node_(8) setdest 4786 61517 9.0" 
$ns at 711.2085442842891 "$node_(8) setdest 126261 68334 4.0" 
$ns at 762.7745581176885 "$node_(8) setdest 53952 31600 11.0" 
$ns at 863.180725195763 "$node_(8) setdest 251410 9679 2.0" 
$ns at 898.2162272435579 "$node_(8) setdest 154329 89318 5.0" 
$ns at 0.0 "$node_(9) setdest 55839 24011 7.0" 
$ns at 74.85011689258904 "$node_(9) setdest 82318 10500 19.0" 
$ns at 286.42530416839764 "$node_(9) setdest 129974 29833 14.0" 
$ns at 327.1460343327301 "$node_(9) setdest 95498 32773 9.0" 
$ns at 444.1709963331247 "$node_(9) setdest 167306 3152 12.0" 
$ns at 555.659140986413 "$node_(9) setdest 71212 23362 13.0" 
$ns at 605.0592998784101 "$node_(9) setdest 101582 7227 1.0" 
$ns at 643.4363277679062 "$node_(9) setdest 87582 9757 16.0" 
$ns at 759.0423536275174 "$node_(9) setdest 133963 66616 14.0" 
$ns at 0.0 "$node_(10) setdest 45417 17573 13.0" 
$ns at 59.03806923400525 "$node_(10) setdest 3355 30301 11.0" 
$ns at 131.02306178367866 "$node_(10) setdest 7690 26525 6.0" 
$ns at 181.44698270382884 "$node_(10) setdest 15705 3993 18.0" 
$ns at 249.88204030508447 "$node_(10) setdest 107158 8425 8.0" 
$ns at 327.4554233372142 "$node_(10) setdest 91634 44766 8.0" 
$ns at 434.9916410820652 "$node_(10) setdest 9761 23224 6.0" 
$ns at 518.0242592988825 "$node_(10) setdest 211369 17009 12.0" 
$ns at 553.2799076262546 "$node_(10) setdest 146991 3780 4.0" 
$ns at 609.6910757201673 "$node_(10) setdest 155071 12759 11.0" 
$ns at 659.7655243724214 "$node_(10) setdest 12602 50268 17.0" 
$ns at 691.7552898667288 "$node_(10) setdest 85696 71482 9.0" 
$ns at 804.4591646588742 "$node_(10) setdest 202575 16476 16.0" 
$ns at 0.0 "$node_(11) setdest 17099 24235 1.0" 
$ns at 37.58488359077414 "$node_(11) setdest 58476 9908 6.0" 
$ns at 89.82843424611329 "$node_(11) setdest 46399 1110 1.0" 
$ns at 121.71391768782763 "$node_(11) setdest 24915 8580 19.0" 
$ns at 222.14399781376923 "$node_(11) setdest 81620 32609 17.0" 
$ns at 396.2623220697269 "$node_(11) setdest 27595 1602 3.0" 
$ns at 453.69463033469907 "$node_(11) setdest 91443 10515 8.0" 
$ns at 518.5980574297687 "$node_(11) setdest 94353 37895 3.0" 
$ns at 549.2746309996579 "$node_(11) setdest 60454 48309 15.0" 
$ns at 609.1593479642657 "$node_(11) setdest 40819 46910 4.0" 
$ns at 677.5451436004013 "$node_(11) setdest 42071 83594 14.0" 
$ns at 716.6390533039371 "$node_(11) setdest 27787 55269 17.0" 
$ns at 767.2889106574922 "$node_(11) setdest 153555 51627 12.0" 
$ns at 889.7758482333575 "$node_(11) setdest 102464 9892 19.0" 
$ns at 0.0 "$node_(12) setdest 37336 27455 15.0" 
$ns at 113.6054448729148 "$node_(12) setdest 82943 5724 8.0" 
$ns at 183.05467681557525 "$node_(12) setdest 87290 26280 1.0" 
$ns at 215.70662485122585 "$node_(12) setdest 104099 16199 9.0" 
$ns at 320.9133757626805 "$node_(12) setdest 2669 50300 1.0" 
$ns at 360.04415439352954 "$node_(12) setdest 169950 55045 11.0" 
$ns at 407.587751059139 "$node_(12) setdest 74047 40514 9.0" 
$ns at 445.9419641690369 "$node_(12) setdest 116563 48318 18.0" 
$ns at 537.019848417528 "$node_(12) setdest 1175 32466 7.0" 
$ns at 620.2758058341822 "$node_(12) setdest 134777 47393 2.0" 
$ns at 660.4943958592726 "$node_(12) setdest 201973 3954 17.0" 
$ns at 734.5014728986185 "$node_(12) setdest 128772 71549 6.0" 
$ns at 804.0713477600748 "$node_(12) setdest 20365 51571 9.0" 
$ns at 892.2710583546498 "$node_(12) setdest 196606 23259 12.0" 
$ns at 0.0 "$node_(13) setdest 55614 23803 20.0" 
$ns at 165.45323050738526 "$node_(13) setdest 36078 4638 12.0" 
$ns at 202.57858335402756 "$node_(13) setdest 93968 28002 10.0" 
$ns at 332.4016011610467 "$node_(13) setdest 110538 54216 20.0" 
$ns at 524.3553512834033 "$node_(13) setdest 47448 49339 15.0" 
$ns at 615.8682473902192 "$node_(13) setdest 206492 33841 11.0" 
$ns at 653.8722305018939 "$node_(13) setdest 240170 7425 13.0" 
$ns at 718.2301372180052 "$node_(13) setdest 201259 53061 7.0" 
$ns at 757.9441964379877 "$node_(13) setdest 54164 71037 9.0" 
$ns at 817.8856938482065 "$node_(13) setdest 87004 952 18.0" 
$ns at 0.0 "$node_(14) setdest 66974 9177 3.0" 
$ns at 51.91361643525411 "$node_(14) setdest 12489 16124 15.0" 
$ns at 136.7511018671811 "$node_(14) setdest 74310 427 9.0" 
$ns at 231.9732207728458 "$node_(14) setdest 55846 32067 9.0" 
$ns at 302.70074410338066 "$node_(14) setdest 98830 26503 11.0" 
$ns at 388.8558475398321 "$node_(14) setdest 50711 14645 13.0" 
$ns at 526.7604836667192 "$node_(14) setdest 184960 6248 16.0" 
$ns at 602.6430577406238 "$node_(14) setdest 126204 72040 17.0" 
$ns at 752.2706106949854 "$node_(14) setdest 115987 71256 1.0" 
$ns at 784.4060015505765 "$node_(14) setdest 93432 1285 1.0" 
$ns at 820.2948204345629 "$node_(14) setdest 123073 29340 6.0" 
$ns at 855.2828136202309 "$node_(14) setdest 128312 88494 6.0" 
$ns at 0.0 "$node_(15) setdest 28154 17019 1.0" 
$ns at 37.86923154092729 "$node_(15) setdest 42326 30497 20.0" 
$ns at 206.5269873135261 "$node_(15) setdest 20040 2083 2.0" 
$ns at 254.72485324858033 "$node_(15) setdest 156715 50567 11.0" 
$ns at 304.17340718960253 "$node_(15) setdest 17926 20444 10.0" 
$ns at 337.6697820268564 "$node_(15) setdest 151170 46978 13.0" 
$ns at 467.39477906379716 "$node_(15) setdest 58215 7396 7.0" 
$ns at 538.6335614442455 "$node_(15) setdest 91561 64233 13.0" 
$ns at 643.6663654984548 "$node_(15) setdest 217812 66452 7.0" 
$ns at 695.6054689904685 "$node_(15) setdest 57119 75941 17.0" 
$ns at 791.220650441838 "$node_(15) setdest 21637 5730 18.0" 
$ns at 0.0 "$node_(16) setdest 55156 30658 3.0" 
$ns at 57.97323006324584 "$node_(16) setdest 63926 26503 7.0" 
$ns at 150.9555994331859 "$node_(16) setdest 93212 911 2.0" 
$ns at 196.09677459503996 "$node_(16) setdest 67757 20421 6.0" 
$ns at 236.19270055905457 "$node_(16) setdest 129493 18605 9.0" 
$ns at 270.52407667872797 "$node_(16) setdest 88360 11636 10.0" 
$ns at 354.4435737831899 "$node_(16) setdest 140674 2434 10.0" 
$ns at 404.4225957880062 "$node_(16) setdest 5833 42067 20.0" 
$ns at 524.429977184617 "$node_(16) setdest 91159 36614 11.0" 
$ns at 558.700421839289 "$node_(16) setdest 211260 43196 14.0" 
$ns at 682.022690371856 "$node_(16) setdest 16154 39599 8.0" 
$ns at 786.198252848048 "$node_(16) setdest 33513 82135 4.0" 
$ns at 832.865146949523 "$node_(16) setdest 189278 82164 18.0" 
$ns at 898.4112506429739 "$node_(16) setdest 267130 10505 19.0" 
$ns at 0.0 "$node_(17) setdest 26321 7120 11.0" 
$ns at 99.09089910150395 "$node_(17) setdest 71961 28425 13.0" 
$ns at 237.5043969144627 "$node_(17) setdest 95558 12899 18.0" 
$ns at 432.29051401541227 "$node_(17) setdest 157568 41416 11.0" 
$ns at 532.0289084955252 "$node_(17) setdest 107901 56006 17.0" 
$ns at 621.5450876793993 "$node_(17) setdest 118188 36012 15.0" 
$ns at 756.4879471488794 "$node_(17) setdest 19621 63815 18.0" 
$ns at 814.1171394408077 "$node_(17) setdest 27829 59710 11.0" 
$ns at 871.5146414456726 "$node_(17) setdest 121862 41730 9.0" 
$ns at 0.0 "$node_(18) setdest 70381 31133 13.0" 
$ns at 32.33564455112214 "$node_(18) setdest 31664 10275 11.0" 
$ns at 168.27984607011746 "$node_(18) setdest 43471 20882 6.0" 
$ns at 202.86297278396395 "$node_(18) setdest 52255 944 11.0" 
$ns at 259.79165600237917 "$node_(18) setdest 62619 42918 11.0" 
$ns at 344.80978397487604 "$node_(18) setdest 64082 36463 8.0" 
$ns at 419.5556480458275 "$node_(18) setdest 154351 39196 17.0" 
$ns at 615.9148105381599 "$node_(18) setdest 148193 29541 9.0" 
$ns at 687.688013663775 "$node_(18) setdest 188963 17326 1.0" 
$ns at 724.5920256185873 "$node_(18) setdest 156081 24740 9.0" 
$ns at 794.5129908806504 "$node_(18) setdest 9198 22689 10.0" 
$ns at 827.5435100851911 "$node_(18) setdest 266890 70495 13.0" 
$ns at 0.0 "$node_(19) setdest 1693 25095 18.0" 
$ns at 33.20184545786346 "$node_(19) setdest 22279 4270 10.0" 
$ns at 70.98894954845471 "$node_(19) setdest 70872 22957 11.0" 
$ns at 152.74315954373748 "$node_(19) setdest 81973 42366 14.0" 
$ns at 249.00286487918584 "$node_(19) setdest 91621 2809 13.0" 
$ns at 314.62994121034274 "$node_(19) setdest 50647 2513 5.0" 
$ns at 375.10680763465314 "$node_(19) setdest 95199 9813 1.0" 
$ns at 408.4114921035206 "$node_(19) setdest 157813 42268 7.0" 
$ns at 470.7866894230994 "$node_(19) setdest 147461 29482 12.0" 
$ns at 502.8289980032246 "$node_(19) setdest 10651 10778 4.0" 
$ns at 538.6967921519869 "$node_(19) setdest 203676 22377 3.0" 
$ns at 575.8307459941194 "$node_(19) setdest 114421 37995 11.0" 
$ns at 626.1227470567072 "$node_(19) setdest 143640 50711 9.0" 
$ns at 692.1088022069227 "$node_(19) setdest 190839 33386 5.0" 
$ns at 726.340191020645 "$node_(19) setdest 138202 33464 12.0" 
$ns at 863.852764243648 "$node_(19) setdest 46222 71409 14.0" 
$ns at 0.0 "$node_(20) setdest 37013 18941 4.0" 
$ns at 67.04295072213326 "$node_(20) setdest 94747 26783 1.0" 
$ns at 106.8717546928065 "$node_(20) setdest 90582 4194 19.0" 
$ns at 277.40668849336714 "$node_(20) setdest 148687 50637 7.0" 
$ns at 332.61049966961457 "$node_(20) setdest 27011 18505 11.0" 
$ns at 431.9592430901614 "$node_(20) setdest 87772 13214 3.0" 
$ns at 476.75356722710023 "$node_(20) setdest 196539 53960 18.0" 
$ns at 554.6784019413958 "$node_(20) setdest 196449 57407 18.0" 
$ns at 732.7560555525431 "$node_(20) setdest 183535 48413 4.0" 
$ns at 770.17544080247 "$node_(20) setdest 18665 10957 4.0" 
$ns at 833.6924698789755 "$node_(20) setdest 252814 36681 6.0" 
$ns at 896.2434142030461 "$node_(20) setdest 105964 21447 3.0" 
$ns at 0.0 "$node_(21) setdest 2138 19459 15.0" 
$ns at 95.08541349252057 "$node_(21) setdest 70968 20911 8.0" 
$ns at 152.28514962399865 "$node_(21) setdest 24701 12253 19.0" 
$ns at 255.91793990660338 "$node_(21) setdest 46344 32835 17.0" 
$ns at 448.34411963795503 "$node_(21) setdest 37573 25887 1.0" 
$ns at 486.81147233408586 "$node_(21) setdest 92260 41336 19.0" 
$ns at 612.3100547291264 "$node_(21) setdest 82494 16393 18.0" 
$ns at 773.9332304080815 "$node_(21) setdest 27190 21726 16.0" 
$ns at 0.0 "$node_(22) setdest 77186 8961 11.0" 
$ns at 74.80244559224451 "$node_(22) setdest 73970 26105 10.0" 
$ns at 118.86068829624345 "$node_(22) setdest 78263 5519 17.0" 
$ns at 259.13817501418754 "$node_(22) setdest 132897 20865 17.0" 
$ns at 327.1663012398664 "$node_(22) setdest 93953 39928 14.0" 
$ns at 416.0912473790306 "$node_(22) setdest 10707 45348 1.0" 
$ns at 446.71071550754004 "$node_(22) setdest 115821 647 18.0" 
$ns at 579.3558526807433 "$node_(22) setdest 156717 42273 9.0" 
$ns at 635.4594235846099 "$node_(22) setdest 35798 64053 18.0" 
$ns at 800.520706349211 "$node_(22) setdest 209817 40834 16.0" 
$ns at 0.0 "$node_(23) setdest 64990 4018 4.0" 
$ns at 36.697879923095684 "$node_(23) setdest 18193 19342 13.0" 
$ns at 100.29880036812929 "$node_(23) setdest 60280 24697 1.0" 
$ns at 140.07119080406096 "$node_(23) setdest 51384 9763 11.0" 
$ns at 269.0630409660148 "$node_(23) setdest 20169 28597 7.0" 
$ns at 328.0889640256326 "$node_(23) setdest 73068 44081 5.0" 
$ns at 374.40144138362 "$node_(23) setdest 186101 4129 14.0" 
$ns at 542.8673811473656 "$node_(23) setdest 110737 3290 6.0" 
$ns at 587.6436265668809 "$node_(23) setdest 133058 52086 15.0" 
$ns at 666.6275545662426 "$node_(23) setdest 108107 16797 10.0" 
$ns at 734.2655124728288 "$node_(23) setdest 31069 57267 20.0" 
$ns at 862.6468636245753 "$node_(23) setdest 67187 11674 1.0" 
$ns at 0.0 "$node_(24) setdest 53693 24972 17.0" 
$ns at 178.1351002310943 "$node_(24) setdest 112962 9413 18.0" 
$ns at 311.7060154029632 "$node_(24) setdest 20827 2604 3.0" 
$ns at 370.18559608399596 "$node_(24) setdest 7879 8007 19.0" 
$ns at 457.85924552385734 "$node_(24) setdest 33011 66319 4.0" 
$ns at 510.25586580914046 "$node_(24) setdest 170293 39220 19.0" 
$ns at 591.9275299286716 "$node_(24) setdest 214688 73958 11.0" 
$ns at 671.0435275905048 "$node_(24) setdest 163491 72105 13.0" 
$ns at 729.9792686675664 "$node_(24) setdest 97049 43055 15.0" 
$ns at 791.5259356046048 "$node_(24) setdest 17259 20233 2.0" 
$ns at 835.4505163433686 "$node_(24) setdest 39047 17713 12.0" 
$ns at 0.0 "$node_(25) setdest 60507 25888 1.0" 
$ns at 38.286633264897745 "$node_(25) setdest 9467 18824 8.0" 
$ns at 99.38028369631151 "$node_(25) setdest 14853 29764 8.0" 
$ns at 206.18250509944835 "$node_(25) setdest 70432 12261 4.0" 
$ns at 263.25346534859983 "$node_(25) setdest 152556 14646 1.0" 
$ns at 298.39920380828664 "$node_(25) setdest 93081 35098 2.0" 
$ns at 328.9073125444734 "$node_(25) setdest 163808 31652 14.0" 
$ns at 478.992777750599 "$node_(25) setdest 82105 50341 14.0" 
$ns at 569.1431698888806 "$node_(25) setdest 22164 49345 18.0" 
$ns at 614.9284996288419 "$node_(25) setdest 105974 5328 8.0" 
$ns at 701.5190753417897 "$node_(25) setdest 114475 8710 4.0" 
$ns at 770.2433871619829 "$node_(25) setdest 192894 45802 14.0" 
$ns at 866.208153622991 "$node_(25) setdest 224628 55829 13.0" 
$ns at 0.0 "$node_(26) setdest 60241 5927 5.0" 
$ns at 37.292443166070974 "$node_(26) setdest 36144 15591 11.0" 
$ns at 128.51741463957447 "$node_(26) setdest 30603 6347 8.0" 
$ns at 187.6217299582657 "$node_(26) setdest 22466 24169 15.0" 
$ns at 275.59672581700477 "$node_(26) setdest 49007 54401 7.0" 
$ns at 328.00666399955026 "$node_(26) setdest 94421 6956 13.0" 
$ns at 459.24758068518815 "$node_(26) setdest 116694 70419 15.0" 
$ns at 627.1835682411088 "$node_(26) setdest 188501 30830 7.0" 
$ns at 710.4033287084142 "$node_(26) setdest 234024 27761 11.0" 
$ns at 828.0925998639149 "$node_(26) setdest 62500 16991 20.0" 
$ns at 0.0 "$node_(27) setdest 11378 18582 16.0" 
$ns at 117.20329885591494 "$node_(27) setdest 29152 7385 2.0" 
$ns at 166.2152244067682 "$node_(27) setdest 81970 41228 4.0" 
$ns at 225.28358419607895 "$node_(27) setdest 45452 24499 19.0" 
$ns at 354.47549888825915 "$node_(27) setdest 97913 1970 7.0" 
$ns at 420.3037078859754 "$node_(27) setdest 60485 10772 4.0" 
$ns at 478.20426624664117 "$node_(27) setdest 25877 52515 7.0" 
$ns at 509.072397617795 "$node_(27) setdest 108823 43649 10.0" 
$ns at 623.5846966459504 "$node_(27) setdest 108907 19622 14.0" 
$ns at 745.0443135462876 "$node_(27) setdest 163078 60136 18.0" 
$ns at 784.9544241720522 "$node_(27) setdest 114607 25449 16.0" 
$ns at 840.3372060156324 "$node_(27) setdest 220652 64670 10.0" 
$ns at 0.0 "$node_(28) setdest 1633 21264 4.0" 
$ns at 69.458643054758 "$node_(28) setdest 44513 25773 13.0" 
$ns at 214.57180699529053 "$node_(28) setdest 127884 7285 2.0" 
$ns at 250.43506475744127 "$node_(28) setdest 7306 24262 11.0" 
$ns at 381.92517121514766 "$node_(28) setdest 124326 27274 13.0" 
$ns at 510.7629338293948 "$node_(28) setdest 51448 6937 9.0" 
$ns at 577.1573651337065 "$node_(28) setdest 50113 46125 6.0" 
$ns at 659.0834142559194 "$node_(28) setdest 223437 36973 4.0" 
$ns at 707.809487128712 "$node_(28) setdest 14408 62201 2.0" 
$ns at 746.3948801342488 "$node_(28) setdest 218157 77402 10.0" 
$ns at 804.0446775252908 "$node_(28) setdest 73521 21709 19.0" 
$ns at 0.0 "$node_(29) setdest 64742 9284 13.0" 
$ns at 146.7229748436032 "$node_(29) setdest 84276 26979 7.0" 
$ns at 180.43910418732403 "$node_(29) setdest 70832 27945 3.0" 
$ns at 233.31089610869927 "$node_(29) setdest 69671 40766 11.0" 
$ns at 334.881512280746 "$node_(29) setdest 163075 43311 8.0" 
$ns at 436.85801732104767 "$node_(29) setdest 36787 6823 3.0" 
$ns at 485.516413673814 "$node_(29) setdest 154696 34622 18.0" 
$ns at 590.3705391330769 "$node_(29) setdest 68261 48225 6.0" 
$ns at 627.4327197192358 "$node_(29) setdest 170308 18878 17.0" 
$ns at 813.2055028225893 "$node_(29) setdest 234498 57665 2.0" 
$ns at 859.3594329435784 "$node_(29) setdest 19878 480 19.0" 
$ns at 0.0 "$node_(30) setdest 79899 17082 5.0" 
$ns at 62.90110379725436 "$node_(30) setdest 19747 8448 16.0" 
$ns at 229.88478210712339 "$node_(30) setdest 98962 8486 17.0" 
$ns at 368.8114737727483 "$node_(30) setdest 41820 51871 17.0" 
$ns at 559.7599470663359 "$node_(30) setdest 22273 20627 2.0" 
$ns at 598.9205027403107 "$node_(30) setdest 144428 42997 4.0" 
$ns at 653.1355508845994 "$node_(30) setdest 160754 39398 11.0" 
$ns at 750.5380735220775 "$node_(30) setdest 149282 85039 9.0" 
$ns at 815.2427389115796 "$node_(30) setdest 211362 89196 17.0" 
$ns at 0.0 "$node_(31) setdest 51174 4563 17.0" 
$ns at 172.88432357414192 "$node_(31) setdest 27294 33267 6.0" 
$ns at 245.1898003733633 "$node_(31) setdest 10789 32547 6.0" 
$ns at 297.09958855784356 "$node_(31) setdest 65795 2405 11.0" 
$ns at 385.31640713532886 "$node_(31) setdest 154213 42114 18.0" 
$ns at 530.83783539306 "$node_(31) setdest 130289 65871 16.0" 
$ns at 695.7378334588047 "$node_(31) setdest 248217 81889 18.0" 
$ns at 841.6516144952597 "$node_(31) setdest 119646 19250 16.0" 
$ns at 884.7897881820688 "$node_(31) setdest 122159 7618 17.0" 
$ns at 0.0 "$node_(32) setdest 972 27718 2.0" 
$ns at 35.52439933313823 "$node_(32) setdest 44610 30036 13.0" 
$ns at 68.73537394241218 "$node_(32) setdest 54741 17862 2.0" 
$ns at 115.59656725854816 "$node_(32) setdest 92851 13596 20.0" 
$ns at 259.3858227126227 "$node_(32) setdest 155157 11334 12.0" 
$ns at 335.414638078656 "$node_(32) setdest 33883 25492 17.0" 
$ns at 519.6185145265896 "$node_(32) setdest 6674 83 7.0" 
$ns at 553.995286030247 "$node_(32) setdest 159314 531 6.0" 
$ns at 620.3614368948965 "$node_(32) setdest 100209 24458 2.0" 
$ns at 658.4776241593926 "$node_(32) setdest 20214 69149 1.0" 
$ns at 692.3928684081427 "$node_(32) setdest 227748 21815 15.0" 
$ns at 811.8824612020769 "$node_(32) setdest 112194 54215 4.0" 
$ns at 876.4558921912292 "$node_(32) setdest 20904 85250 19.0" 
$ns at 0.0 "$node_(33) setdest 56374 29942 12.0" 
$ns at 82.03072492832956 "$node_(33) setdest 73171 23549 6.0" 
$ns at 154.91726443980832 "$node_(33) setdest 35568 8709 5.0" 
$ns at 218.50038518679224 "$node_(33) setdest 106529 41684 12.0" 
$ns at 288.65393664704436 "$node_(33) setdest 80204 12474 9.0" 
$ns at 368.08336927518394 "$node_(33) setdest 18587 45453 7.0" 
$ns at 403.9301045014443 "$node_(33) setdest 137593 37789 2.0" 
$ns at 439.06781353112166 "$node_(33) setdest 111132 28310 17.0" 
$ns at 566.7974002963825 "$node_(33) setdest 16774 51976 8.0" 
$ns at 642.4561028916411 "$node_(33) setdest 9808 29122 20.0" 
$ns at 757.577227466923 "$node_(33) setdest 222005 59643 3.0" 
$ns at 816.6321414030143 "$node_(33) setdest 249789 45516 16.0" 
$ns at 0.0 "$node_(34) setdest 72319 23086 8.0" 
$ns at 106.29249451488059 "$node_(34) setdest 4064 8347 8.0" 
$ns at 164.70763361974616 "$node_(34) setdest 95076 19701 10.0" 
$ns at 224.14391222652245 "$node_(34) setdest 31763 44042 6.0" 
$ns at 287.58309071062195 "$node_(34) setdest 53193 21879 6.0" 
$ns at 325.6383465465227 "$node_(34) setdest 124657 31426 18.0" 
$ns at 515.6136337500816 "$node_(34) setdest 31516 55718 15.0" 
$ns at 572.9415105445894 "$node_(34) setdest 204272 59096 7.0" 
$ns at 661.7450661472354 "$node_(34) setdest 80708 3594 14.0" 
$ns at 753.0528743706423 "$node_(34) setdest 224392 70955 2.0" 
$ns at 785.6878653258796 "$node_(34) setdest 150463 3979 20.0" 
$ns at 847.8387214336997 "$node_(34) setdest 86879 46644 12.0" 
$ns at 0.0 "$node_(35) setdest 26424 14520 1.0" 
$ns at 30.382675821186076 "$node_(35) setdest 979 7067 19.0" 
$ns at 182.1875273055033 "$node_(35) setdest 126330 5998 11.0" 
$ns at 296.00402040007725 "$node_(35) setdest 136486 33679 6.0" 
$ns at 369.8799036831441 "$node_(35) setdest 7522 43398 10.0" 
$ns at 446.59215692073104 "$node_(35) setdest 6712 54249 9.0" 
$ns at 563.2899852400623 "$node_(35) setdest 64142 52719 18.0" 
$ns at 727.1466766427137 "$node_(35) setdest 59858 47888 20.0" 
$ns at 771.6133723420226 "$node_(35) setdest 226403 3946 4.0" 
$ns at 808.6193883492783 "$node_(35) setdest 254915 11182 10.0" 
$ns at 0.0 "$node_(36) setdest 85381 19183 19.0" 
$ns at 146.4940798086129 "$node_(36) setdest 31599 22449 9.0" 
$ns at 266.32467420457107 "$node_(36) setdest 98979 50175 13.0" 
$ns at 379.9631392920825 "$node_(36) setdest 32815 62972 13.0" 
$ns at 493.2995282156615 "$node_(36) setdest 67968 51008 8.0" 
$ns at 599.4289485960148 "$node_(36) setdest 68925 27541 2.0" 
$ns at 645.1056043393593 "$node_(36) setdest 205742 59432 13.0" 
$ns at 746.0105107298536 "$node_(36) setdest 233721 79565 9.0" 
$ns at 806.8957534622484 "$node_(36) setdest 266122 71232 6.0" 
$ns at 839.2579880239693 "$node_(36) setdest 198377 16811 5.0" 
$ns at 897.0696295741712 "$node_(36) setdest 30541 80724 5.0" 
$ns at 0.0 "$node_(37) setdest 49337 9988 1.0" 
$ns at 38.58360511250494 "$node_(37) setdest 52185 19914 15.0" 
$ns at 110.82408009504032 "$node_(37) setdest 77147 5949 9.0" 
$ns at 191.25694356061067 "$node_(37) setdest 61678 20666 5.0" 
$ns at 253.1383777509467 "$node_(37) setdest 147168 24898 10.0" 
$ns at 373.88833022370295 "$node_(37) setdest 668 37840 18.0" 
$ns at 572.2274580522841 "$node_(37) setdest 210955 54571 2.0" 
$ns at 609.2695659432858 "$node_(37) setdest 221437 12058 8.0" 
$ns at 664.021624855534 "$node_(37) setdest 24787 27640 19.0" 
$ns at 717.1973565440734 "$node_(37) setdest 95493 16607 2.0" 
$ns at 759.9232613707958 "$node_(37) setdest 114793 11762 6.0" 
$ns at 814.9117267821676 "$node_(37) setdest 79130 20984 15.0" 
$ns at 853.645195507809 "$node_(37) setdest 3048 82966 15.0" 
$ns at 0.0 "$node_(38) setdest 31707 2381 19.0" 
$ns at 73.3915455453915 "$node_(38) setdest 14507 22166 14.0" 
$ns at 203.0345840187879 "$node_(38) setdest 118037 9064 7.0" 
$ns at 284.2785428399468 "$node_(38) setdest 155245 2067 15.0" 
$ns at 451.24507935399674 "$node_(38) setdest 43511 2785 5.0" 
$ns at 500.82096842392934 "$node_(38) setdest 144169 62732 9.0" 
$ns at 588.3558121200355 "$node_(38) setdest 121355 59244 1.0" 
$ns at 622.470319067991 "$node_(38) setdest 130150 70369 14.0" 
$ns at 736.8048447434214 "$node_(38) setdest 9860 47920 7.0" 
$ns at 806.8540862455554 "$node_(38) setdest 119410 82746 10.0" 
$ns at 0.0 "$node_(39) setdest 37219 16269 13.0" 
$ns at 150.54574828099925 "$node_(39) setdest 83223 11443 13.0" 
$ns at 193.3608128176239 "$node_(39) setdest 8688 14421 18.0" 
$ns at 351.8107027717792 "$node_(39) setdest 157996 59576 17.0" 
$ns at 383.86595690415396 "$node_(39) setdest 124787 54314 10.0" 
$ns at 456.7890085836604 "$node_(39) setdest 15910 9920 2.0" 
$ns at 489.4264070692384 "$node_(39) setdest 26395 5849 7.0" 
$ns at 539.567156508872 "$node_(39) setdest 182579 14270 1.0" 
$ns at 571.2231154226223 "$node_(39) setdest 77256 52867 1.0" 
$ns at 606.2745483062811 "$node_(39) setdest 226924 15882 2.0" 
$ns at 648.1133338366658 "$node_(39) setdest 131556 59279 17.0" 
$ns at 699.67134118629 "$node_(39) setdest 238758 80633 15.0" 
$ns at 772.8822240578369 "$node_(39) setdest 223613 22365 16.0" 
$ns at 859.0484077747991 "$node_(39) setdest 195486 69657 8.0" 
$ns at 0.0 "$node_(40) setdest 8507 27136 10.0" 
$ns at 85.67367969036034 "$node_(40) setdest 26841 14334 11.0" 
$ns at 164.84889124785877 "$node_(40) setdest 99653 37815 15.0" 
$ns at 268.64844014640744 "$node_(40) setdest 27349 18673 1.0" 
$ns at 301.2947434094349 "$node_(40) setdest 8379 47775 13.0" 
$ns at 374.2781601535403 "$node_(40) setdest 42615 28259 18.0" 
$ns at 568.7714136547736 "$node_(40) setdest 64807 50483 14.0" 
$ns at 676.3021306971253 "$node_(40) setdest 243453 71145 9.0" 
$ns at 737.2115941127499 "$node_(40) setdest 181536 23180 19.0" 
$ns at 0.0 "$node_(41) setdest 33333 30665 1.0" 
$ns at 31.139667993867654 "$node_(41) setdest 92292 11588 3.0" 
$ns at 78.69875205596387 "$node_(41) setdest 86095 13838 17.0" 
$ns at 126.9044299255629 "$node_(41) setdest 1428 13400 13.0" 
$ns at 191.65139597166473 "$node_(41) setdest 72807 27164 4.0" 
$ns at 221.7776404583321 "$node_(41) setdest 7099 2597 6.0" 
$ns at 277.6811632496918 "$node_(41) setdest 67874 52582 2.0" 
$ns at 309.8650246023562 "$node_(41) setdest 23923 52422 18.0" 
$ns at 463.58616609659396 "$node_(41) setdest 140517 65751 3.0" 
$ns at 504.6673454646702 "$node_(41) setdest 7580 53652 10.0" 
$ns at 600.5214818515615 "$node_(41) setdest 231080 71307 19.0" 
$ns at 752.1037177078078 "$node_(41) setdest 208469 19278 18.0" 
$ns at 861.1185551381064 "$node_(41) setdest 86126 47343 6.0" 
$ns at 0.0 "$node_(42) setdest 2326 9367 11.0" 
$ns at 87.89145663806528 "$node_(42) setdest 92403 7891 11.0" 
$ns at 184.33631611270403 "$node_(42) setdest 13847 5342 7.0" 
$ns at 245.50306978932724 "$node_(42) setdest 29446 7664 15.0" 
$ns at 296.14088752383407 "$node_(42) setdest 35231 47305 18.0" 
$ns at 419.0370937724841 "$node_(42) setdest 11688 28447 11.0" 
$ns at 512.2791177005695 "$node_(42) setdest 84223 3386 14.0" 
$ns at 608.8300698583847 "$node_(42) setdest 133821 43320 14.0" 
$ns at 772.4703168109334 "$node_(42) setdest 28090 74065 14.0" 
$ns at 0.0 "$node_(43) setdest 24557 19140 10.0" 
$ns at 82.40322818325342 "$node_(43) setdest 48639 6430 6.0" 
$ns at 153.43966458394166 "$node_(43) setdest 17870 9455 12.0" 
$ns at 202.98293829955824 "$node_(43) setdest 123190 12374 19.0" 
$ns at 403.6230370793086 "$node_(43) setdest 113112 47598 11.0" 
$ns at 513.5286853470791 "$node_(43) setdest 179594 68232 1.0" 
$ns at 553.0380492885722 "$node_(43) setdest 58046 73778 2.0" 
$ns at 595.8851399053054 "$node_(43) setdest 169105 62117 11.0" 
$ns at 713.487327347907 "$node_(43) setdest 50527 9728 16.0" 
$ns at 798.194496679949 "$node_(43) setdest 68334 65299 11.0" 
$ns at 885.6659312307884 "$node_(43) setdest 153371 46262 5.0" 
$ns at 0.0 "$node_(44) setdest 74876 771 18.0" 
$ns at 162.37343568167347 "$node_(44) setdest 26883 31609 15.0" 
$ns at 218.19852149015014 "$node_(44) setdest 57239 33267 13.0" 
$ns at 307.0051190568312 "$node_(44) setdest 129215 42077 17.0" 
$ns at 361.19021169847827 "$node_(44) setdest 110557 22409 8.0" 
$ns at 427.9726021031528 "$node_(44) setdest 180335 49483 8.0" 
$ns at 465.438515979841 "$node_(44) setdest 46174 29523 15.0" 
$ns at 547.1107242746742 "$node_(44) setdest 203693 1868 1.0" 
$ns at 581.1416300538988 "$node_(44) setdest 13708 38048 14.0" 
$ns at 702.752189686378 "$node_(44) setdest 26235 56364 8.0" 
$ns at 785.924477064881 "$node_(44) setdest 117186 56730 2.0" 
$ns at 833.8420418764142 "$node_(44) setdest 256448 1362 16.0" 
$ns at 0.0 "$node_(45) setdest 56439 5115 12.0" 
$ns at 69.03440387332975 "$node_(45) setdest 796 14928 3.0" 
$ns at 111.41988582909161 "$node_(45) setdest 56176 17210 12.0" 
$ns at 230.2994352015109 "$node_(45) setdest 58026 41042 14.0" 
$ns at 343.4490272094448 "$node_(45) setdest 25381 32650 19.0" 
$ns at 512.4830178803234 "$node_(45) setdest 197179 5722 14.0" 
$ns at 583.3836573363786 "$node_(45) setdest 21878 26895 19.0" 
$ns at 631.377638257856 "$node_(45) setdest 216009 3664 3.0" 
$ns at 677.9472014929452 "$node_(45) setdest 39508 20282 2.0" 
$ns at 715.3195333234268 "$node_(45) setdest 155117 10917 11.0" 
$ns at 835.5438875577099 "$node_(45) setdest 111199 50425 6.0" 
$ns at 0.0 "$node_(46) setdest 50259 19967 19.0" 
$ns at 208.76136862936852 "$node_(46) setdest 74451 9817 7.0" 
$ns at 273.74046970142956 "$node_(46) setdest 114953 14005 3.0" 
$ns at 315.43623558407745 "$node_(46) setdest 115469 16143 13.0" 
$ns at 420.36727177177045 "$node_(46) setdest 115058 13201 19.0" 
$ns at 463.71772441540287 "$node_(46) setdest 129873 569 13.0" 
$ns at 590.1756936489378 "$node_(46) setdest 93087 18402 19.0" 
$ns at 668.8951728853827 "$node_(46) setdest 90498 81062 10.0" 
$ns at 704.6600433122442 "$node_(46) setdest 38047 11685 4.0" 
$ns at 755.3513758951407 "$node_(46) setdest 241011 78697 1.0" 
$ns at 787.3562654912105 "$node_(46) setdest 28175 45406 8.0" 
$ns at 873.4416836847572 "$node_(46) setdest 19262 7059 6.0" 
$ns at 0.0 "$node_(47) setdest 17727 23080 11.0" 
$ns at 64.4536793230072 "$node_(47) setdest 93166 17885 13.0" 
$ns at 179.47237321115978 "$node_(47) setdest 32677 23073 13.0" 
$ns at 322.54695425206455 "$node_(47) setdest 129873 22227 1.0" 
$ns at 354.3105458394507 "$node_(47) setdest 143407 29556 3.0" 
$ns at 386.061981121831 "$node_(47) setdest 63966 41774 13.0" 
$ns at 453.9561817786853 "$node_(47) setdest 3138 32662 15.0" 
$ns at 602.1946076285485 "$node_(47) setdest 43021 17913 15.0" 
$ns at 740.881540633382 "$node_(47) setdest 250668 73004 8.0" 
$ns at 807.8655105256873 "$node_(47) setdest 255328 24052 17.0" 
$ns at 0.0 "$node_(48) setdest 41571 28112 18.0" 
$ns at 39.407361670681 "$node_(48) setdest 3929 1220 7.0" 
$ns at 132.39443170552437 "$node_(48) setdest 76744 14617 14.0" 
$ns at 275.74696327323426 "$node_(48) setdest 24002 21164 3.0" 
$ns at 311.74842832431193 "$node_(48) setdest 39334 35167 5.0" 
$ns at 376.4605110106564 "$node_(48) setdest 22762 12767 1.0" 
$ns at 415.20402418244055 "$node_(48) setdest 108546 20605 17.0" 
$ns at 590.0578360377557 "$node_(48) setdest 22968 40339 17.0" 
$ns at 660.7789661496415 "$node_(48) setdest 16884 57624 4.0" 
$ns at 719.792130179305 "$node_(48) setdest 244162 13657 18.0" 
$ns at 882.9091907619537 "$node_(48) setdest 130464 72965 19.0" 
$ns at 0.0 "$node_(49) setdest 54765 1611 7.0" 
$ns at 52.98300784262592 "$node_(49) setdest 51543 9590 2.0" 
$ns at 100.0492002611522 "$node_(49) setdest 20475 18933 17.0" 
$ns at 241.9591225935648 "$node_(49) setdest 129450 38059 18.0" 
$ns at 396.9126911681503 "$node_(49) setdest 71516 52139 4.0" 
$ns at 428.15856538938664 "$node_(49) setdest 121959 7219 1.0" 
$ns at 466.9217823373683 "$node_(49) setdest 161038 5093 1.0" 
$ns at 500.1054805164631 "$node_(49) setdest 131896 23578 18.0" 
$ns at 587.4279027081985 "$node_(49) setdest 224797 38158 7.0" 
$ns at 639.0042177059458 "$node_(49) setdest 210995 39895 7.0" 
$ns at 686.6684680928872 "$node_(49) setdest 123882 56637 13.0" 
$ns at 740.9033689711101 "$node_(49) setdest 84741 14879 3.0" 
$ns at 772.4315173399276 "$node_(49) setdest 226782 7620 10.0" 
$ns at 813.1616802902863 "$node_(49) setdest 266622 83965 9.0" 
$ns at 874.1646561415538 "$node_(49) setdest 250821 15005 14.0" 
$ns at 0.0 "$node_(50) setdest 86230 14396 14.0" 
$ns at 65.91407913908702 "$node_(50) setdest 8899 10176 5.0" 
$ns at 121.22754673817573 "$node_(50) setdest 4197 15640 1.0" 
$ns at 159.64726780741722 "$node_(50) setdest 43500 3493 12.0" 
$ns at 242.13453009118115 "$node_(50) setdest 104508 6680 3.0" 
$ns at 273.90419783601817 "$node_(50) setdest 106924 8913 15.0" 
$ns at 439.91933908008286 "$node_(50) setdest 76536 29661 10.0" 
$ns at 555.6276579835373 "$node_(50) setdest 159712 25409 3.0" 
$ns at 589.9952487782887 "$node_(50) setdest 81432 2039 1.0" 
$ns at 622.1268090934421 "$node_(50) setdest 181556 7558 9.0" 
$ns at 722.1859973877524 "$node_(50) setdest 38954 15854 2.0" 
$ns at 756.1394593414396 "$node_(50) setdest 93409 73289 1.0" 
$ns at 794.3983453379502 "$node_(50) setdest 102144 10538 19.0" 
$ns at 0.0 "$node_(51) setdest 24661 21259 5.0" 
$ns at 52.69970176325171 "$node_(51) setdest 94661 23779 5.0" 
$ns at 98.48011515401721 "$node_(51) setdest 38120 16427 17.0" 
$ns at 243.68549134911996 "$node_(51) setdest 128587 14193 17.0" 
$ns at 352.7646464116528 "$node_(51) setdest 143864 47712 15.0" 
$ns at 454.0300203149897 "$node_(51) setdest 201278 7844 5.0" 
$ns at 505.57678222484697 "$node_(51) setdest 136527 37683 19.0" 
$ns at 539.3755327716823 "$node_(51) setdest 119417 41720 15.0" 
$ns at 575.2314972514444 "$node_(51) setdest 218417 2841 5.0" 
$ns at 654.6812353302433 "$node_(51) setdest 96079 2810 11.0" 
$ns at 721.1834149509089 "$node_(51) setdest 114152 55386 20.0" 
$ns at 781.3945984336677 "$node_(51) setdest 189144 26400 3.0" 
$ns at 815.6416917866602 "$node_(51) setdest 204784 24947 2.0" 
$ns at 859.5596489192086 "$node_(51) setdest 241693 37263 5.0" 
$ns at 0.0 "$node_(52) setdest 13864 30199 1.0" 
$ns at 30.085844561087843 "$node_(52) setdest 61620 3885 2.0" 
$ns at 63.45957980798927 "$node_(52) setdest 46466 24921 9.0" 
$ns at 169.71039441080143 "$node_(52) setdest 71349 20868 18.0" 
$ns at 202.23150012609898 "$node_(52) setdest 34605 33231 11.0" 
$ns at 246.62857432483452 "$node_(52) setdest 96828 6401 1.0" 
$ns at 284.8499688595702 "$node_(52) setdest 148102 34874 4.0" 
$ns at 346.6334809673417 "$node_(52) setdest 125996 13351 5.0" 
$ns at 420.2774550462158 "$node_(52) setdest 60193 42078 17.0" 
$ns at 521.4581666395502 "$node_(52) setdest 147009 33153 20.0" 
$ns at 643.8965339283075 "$node_(52) setdest 51669 9270 3.0" 
$ns at 691.5813948792083 "$node_(52) setdest 231867 5737 9.0" 
$ns at 721.8448951214328 "$node_(52) setdest 138605 15227 9.0" 
$ns at 769.659168158774 "$node_(52) setdest 201484 2840 11.0" 
$ns at 842.1297325524386 "$node_(52) setdest 67304 84886 13.0" 
$ns at 889.544581700117 "$node_(52) setdest 92801 26132 13.0" 
$ns at 0.0 "$node_(53) setdest 6009 2413 17.0" 
$ns at 44.10549959563606 "$node_(53) setdest 52165 30727 12.0" 
$ns at 137.98706597524296 "$node_(53) setdest 18530 21740 3.0" 
$ns at 179.4408267209266 "$node_(53) setdest 124868 41578 5.0" 
$ns at 247.34743678879042 "$node_(53) setdest 127698 19862 7.0" 
$ns at 287.2168648403745 "$node_(53) setdest 138806 7622 14.0" 
$ns at 332.716957033241 "$node_(53) setdest 118210 50371 8.0" 
$ns at 369.97361102142565 "$node_(53) setdest 93441 41563 1.0" 
$ns at 401.5008510155374 "$node_(53) setdest 171677 42523 6.0" 
$ns at 482.9158062131678 "$node_(53) setdest 43660 14955 16.0" 
$ns at 618.2066920905963 "$node_(53) setdest 161028 51288 11.0" 
$ns at 716.9811330180364 "$node_(53) setdest 114300 56159 4.0" 
$ns at 750.7409543639696 "$node_(53) setdest 198027 80962 18.0" 
$ns at 852.5973911966685 "$node_(53) setdest 84830 82433 19.0" 
$ns at 886.3905939558582 "$node_(53) setdest 40425 45744 1.0" 
$ns at 0.0 "$node_(54) setdest 36012 28862 8.0" 
$ns at 68.82808343975493 "$node_(54) setdest 37460 15780 5.0" 
$ns at 133.14802721965071 "$node_(54) setdest 33288 28485 11.0" 
$ns at 246.53170742817156 "$node_(54) setdest 128443 1364 1.0" 
$ns at 284.89036324025903 "$node_(54) setdest 134582 8381 9.0" 
$ns at 401.81900079622153 "$node_(54) setdest 171367 61057 7.0" 
$ns at 484.6328558585279 "$node_(54) setdest 199114 44832 1.0" 
$ns at 519.4642300292672 "$node_(54) setdest 144374 61749 16.0" 
$ns at 583.3713698252461 "$node_(54) setdest 2606 34407 9.0" 
$ns at 626.3202790562201 "$node_(54) setdest 183236 69894 4.0" 
$ns at 693.3197765506435 "$node_(54) setdest 51383 2466 14.0" 
$ns at 809.323348780903 "$node_(54) setdest 45621 13206 2.0" 
$ns at 854.8166201273383 "$node_(54) setdest 241257 38627 16.0" 
$ns at 0.0 "$node_(55) setdest 42192 13088 1.0" 
$ns at 32.738957909242565 "$node_(55) setdest 37632 3174 10.0" 
$ns at 69.08758927998016 "$node_(55) setdest 32636 16342 12.0" 
$ns at 188.2759918347927 "$node_(55) setdest 132165 1420 10.0" 
$ns at 268.6260678759093 "$node_(55) setdest 157999 28375 2.0" 
$ns at 316.65272609387534 "$node_(55) setdest 97220 14284 2.0" 
$ns at 353.5726177526632 "$node_(55) setdest 129629 34054 1.0" 
$ns at 391.84563664742217 "$node_(55) setdest 98073 61310 18.0" 
$ns at 477.78863108054486 "$node_(55) setdest 192840 3032 17.0" 
$ns at 593.1331863783113 "$node_(55) setdest 229093 56884 4.0" 
$ns at 647.8073394980372 "$node_(55) setdest 216352 57552 6.0" 
$ns at 700.9314211312055 "$node_(55) setdest 126876 57147 10.0" 
$ns at 807.3798721038598 "$node_(55) setdest 155470 45699 6.0" 
$ns at 881.5732051846865 "$node_(55) setdest 71386 51566 13.0" 
$ns at 0.0 "$node_(56) setdest 47569 30021 15.0" 
$ns at 125.11403014585457 "$node_(56) setdest 7136 2847 17.0" 
$ns at 320.80332824280737 "$node_(56) setdest 30464 28041 18.0" 
$ns at 513.4108302167147 "$node_(56) setdest 119439 57263 7.0" 
$ns at 588.2323029256452 "$node_(56) setdest 21711 24732 4.0" 
$ns at 634.5471554592152 "$node_(56) setdest 150064 55482 20.0" 
$ns at 687.203954720271 "$node_(56) setdest 129561 5350 19.0" 
$ns at 795.413178337988 "$node_(56) setdest 130763 15443 5.0" 
$ns at 834.8567511248285 "$node_(56) setdest 3459 58157 15.0" 
$ns at 0.0 "$node_(57) setdest 42333 21791 2.0" 
$ns at 47.5676813860792 "$node_(57) setdest 52170 14620 11.0" 
$ns at 138.58820255659668 "$node_(57) setdest 70827 31030 14.0" 
$ns at 290.49581286214936 "$node_(57) setdest 115215 22235 2.0" 
$ns at 327.96192605437176 "$node_(57) setdest 141511 5111 16.0" 
$ns at 379.35115981305466 "$node_(57) setdest 99339 7435 18.0" 
$ns at 424.607155580304 "$node_(57) setdest 160389 38253 1.0" 
$ns at 464.46785760278175 "$node_(57) setdest 205964 69722 18.0" 
$ns at 651.7557749771763 "$node_(57) setdest 27352 15957 11.0" 
$ns at 706.424907291789 "$node_(57) setdest 240851 73711 14.0" 
$ns at 748.6840788939812 "$node_(57) setdest 92000 4543 17.0" 
$ns at 801.4050118716065 "$node_(57) setdest 120432 65565 19.0" 
$ns at 0.0 "$node_(58) setdest 71302 83 13.0" 
$ns at 90.8301646075104 "$node_(58) setdest 14206 11353 2.0" 
$ns at 134.00544175797296 "$node_(58) setdest 31816 5815 18.0" 
$ns at 295.0365722253823 "$node_(58) setdest 119201 9781 18.0" 
$ns at 330.34040833730234 "$node_(58) setdest 88264 41405 14.0" 
$ns at 405.46364582603746 "$node_(58) setdest 113092 45237 4.0" 
$ns at 470.6797251433727 "$node_(58) setdest 34969 449 17.0" 
$ns at 575.7336845009388 "$node_(58) setdest 165453 2101 13.0" 
$ns at 687.504723562999 "$node_(58) setdest 18568 57924 3.0" 
$ns at 739.3400935074019 "$node_(58) setdest 228012 38615 3.0" 
$ns at 787.294404971401 "$node_(58) setdest 183418 55571 8.0" 
$ns at 823.1521557868343 "$node_(58) setdest 188996 33847 4.0" 
$ns at 868.9298970093213 "$node_(58) setdest 224550 66250 12.0" 
$ns at 0.0 "$node_(59) setdest 62588 23295 15.0" 
$ns at 105.18144522169237 "$node_(59) setdest 70725 8124 5.0" 
$ns at 152.3106050929007 "$node_(59) setdest 87716 30771 4.0" 
$ns at 204.4924737145667 "$node_(59) setdest 717 24735 1.0" 
$ns at 241.05256626333596 "$node_(59) setdest 93604 25654 7.0" 
$ns at 340.91975166967325 "$node_(59) setdest 151480 50653 12.0" 
$ns at 384.0494460800775 "$node_(59) setdest 27524 61121 7.0" 
$ns at 419.6806962659313 "$node_(59) setdest 120319 25533 5.0" 
$ns at 450.7137528448079 "$node_(59) setdest 87757 46344 12.0" 
$ns at 528.6874967454808 "$node_(59) setdest 164368 13312 5.0" 
$ns at 584.6674493421247 "$node_(59) setdest 135075 55437 14.0" 
$ns at 678.1374210301724 "$node_(59) setdest 164485 37756 12.0" 
$ns at 772.5577879046574 "$node_(59) setdest 125841 5221 12.0" 
$ns at 0.0 "$node_(60) setdest 20250 17196 11.0" 
$ns at 93.41634934192325 "$node_(60) setdest 7200 3338 7.0" 
$ns at 157.23263690792456 "$node_(60) setdest 28556 38669 3.0" 
$ns at 212.88549253318718 "$node_(60) setdest 64066 21675 6.0" 
$ns at 293.89249105128704 "$node_(60) setdest 70916 50160 18.0" 
$ns at 438.77582862128537 "$node_(60) setdest 104707 56079 8.0" 
$ns at 522.9636035904105 "$node_(60) setdest 175829 22052 8.0" 
$ns at 621.5827918929821 "$node_(60) setdest 33951 37377 20.0" 
$ns at 822.6095603715934 "$node_(60) setdest 248940 68408 12.0" 
$ns at 893.4801620732586 "$node_(60) setdest 146911 48553 4.0" 
$ns at 0.0 "$node_(61) setdest 85593 9871 4.0" 
$ns at 39.28838509897254 "$node_(61) setdest 35233 4895 12.0" 
$ns at 86.42511909325106 "$node_(61) setdest 10166 9762 19.0" 
$ns at 201.13875028465296 "$node_(61) setdest 30831 8103 19.0" 
$ns at 259.8143639099582 "$node_(61) setdest 6401 52117 5.0" 
$ns at 300.82719943289453 "$node_(61) setdest 130477 46884 5.0" 
$ns at 368.54296852550414 "$node_(61) setdest 183227 22596 8.0" 
$ns at 407.9377183690657 "$node_(61) setdest 21700 41797 3.0" 
$ns at 467.0280352719796 "$node_(61) setdest 151608 32640 14.0" 
$ns at 503.0345247436334 "$node_(61) setdest 65744 26692 14.0" 
$ns at 536.8722961812238 "$node_(61) setdest 75492 18407 15.0" 
$ns at 584.8872581501323 "$node_(61) setdest 230675 35612 20.0" 
$ns at 740.0625027154417 "$node_(61) setdest 193091 13515 9.0" 
$ns at 815.1688039252955 "$node_(61) setdest 10218 10816 15.0" 
$ns at 0.0 "$node_(62) setdest 31777 14821 14.0" 
$ns at 92.46732506276395 "$node_(62) setdest 53714 24656 10.0" 
$ns at 215.80911476333722 "$node_(62) setdest 31314 11781 16.0" 
$ns at 286.2329997412528 "$node_(62) setdest 40450 41634 16.0" 
$ns at 381.0098092656416 "$node_(62) setdest 18035 13203 5.0" 
$ns at 454.38555396816685 "$node_(62) setdest 61030 27568 1.0" 
$ns at 486.24810303126486 "$node_(62) setdest 209375 2891 5.0" 
$ns at 529.4329625237427 "$node_(62) setdest 155395 63006 9.0" 
$ns at 580.9639835588098 "$node_(62) setdest 226601 59667 16.0" 
$ns at 757.04417429539 "$node_(62) setdest 244019 63373 7.0" 
$ns at 813.865234009254 "$node_(62) setdest 201271 77004 18.0" 
$ns at 0.0 "$node_(63) setdest 15706 5379 18.0" 
$ns at 78.56232473494035 "$node_(63) setdest 5246 28693 12.0" 
$ns at 201.22839431350653 "$node_(63) setdest 31975 27857 8.0" 
$ns at 231.48911785667906 "$node_(63) setdest 121462 25902 9.0" 
$ns at 299.15517409677 "$node_(63) setdest 144581 24148 11.0" 
$ns at 341.517039106005 "$node_(63) setdest 136855 46702 1.0" 
$ns at 377.76305244325937 "$node_(63) setdest 113567 34631 2.0" 
$ns at 424.4105653656885 "$node_(63) setdest 123840 50492 18.0" 
$ns at 557.1637976616435 "$node_(63) setdest 146358 27030 14.0" 
$ns at 713.5835546655069 "$node_(63) setdest 120643 37246 13.0" 
$ns at 859.8688398150232 "$node_(63) setdest 134323 19751 13.0" 
$ns at 0.0 "$node_(64) setdest 94516 15489 11.0" 
$ns at 44.84859012575152 "$node_(64) setdest 75860 29886 17.0" 
$ns at 225.77049953041038 "$node_(64) setdest 25107 38953 11.0" 
$ns at 358.290031895678 "$node_(64) setdest 3371 46781 11.0" 
$ns at 400.1447284248786 "$node_(64) setdest 11960 30284 13.0" 
$ns at 502.7257408385109 "$node_(64) setdest 121119 54918 15.0" 
$ns at 579.7898400391305 "$node_(64) setdest 18311 40091 17.0" 
$ns at 715.1019248258838 "$node_(64) setdest 92766 27847 19.0" 
$ns at 898.4260302586915 "$node_(64) setdest 68011 26183 18.0" 
$ns at 0.0 "$node_(65) setdest 51916 30596 14.0" 
$ns at 46.86623953003195 "$node_(65) setdest 21287 13943 4.0" 
$ns at 93.02898403123545 "$node_(65) setdest 20133 11769 17.0" 
$ns at 161.98343500816435 "$node_(65) setdest 97209 39019 1.0" 
$ns at 192.23456658493166 "$node_(65) setdest 44966 35148 6.0" 
$ns at 278.1694349157715 "$node_(65) setdest 36356 51847 12.0" 
$ns at 338.8561618822644 "$node_(65) setdest 22334 6699 2.0" 
$ns at 386.17118730887574 "$node_(65) setdest 133683 40963 2.0" 
$ns at 424.98008307628857 "$node_(65) setdest 110639 12701 4.0" 
$ns at 489.0342503223357 "$node_(65) setdest 183229 55410 4.0" 
$ns at 521.083092146931 "$node_(65) setdest 184460 51522 4.0" 
$ns at 572.6545610454972 "$node_(65) setdest 32526 36750 16.0" 
$ns at 738.9068253351427 "$node_(65) setdest 245167 77513 13.0" 
$ns at 840.6537464595666 "$node_(65) setdest 105609 40395 8.0" 
$ns at 0.0 "$node_(66) setdest 65660 29834 11.0" 
$ns at 94.35853213085122 "$node_(66) setdest 16532 29633 14.0" 
$ns at 174.98600339324153 "$node_(66) setdest 92780 20362 9.0" 
$ns at 220.69209853255012 "$node_(66) setdest 111659 5441 1.0" 
$ns at 258.6821367732565 "$node_(66) setdest 90592 4960 4.0" 
$ns at 292.0364387993901 "$node_(66) setdest 157582 28080 3.0" 
$ns at 350.81869767657565 "$node_(66) setdest 152212 36628 8.0" 
$ns at 422.5633161057464 "$node_(66) setdest 169919 42361 13.0" 
$ns at 511.7501780271472 "$node_(66) setdest 82549 54308 11.0" 
$ns at 612.7136553017855 "$node_(66) setdest 68962 7673 8.0" 
$ns at 649.2038092244692 "$node_(66) setdest 34763 69596 5.0" 
$ns at 681.9355248474095 "$node_(66) setdest 248486 27140 1.0" 
$ns at 714.053026821983 "$node_(66) setdest 43790 66031 5.0" 
$ns at 756.1163980826045 "$node_(66) setdest 165314 36328 4.0" 
$ns at 820.0289991091374 "$node_(66) setdest 44011 73373 11.0" 
$ns at 870.8300634556424 "$node_(66) setdest 212348 38145 12.0" 
$ns at 0.0 "$node_(67) setdest 13543 27266 18.0" 
$ns at 136.6507977312143 "$node_(67) setdest 73864 22467 18.0" 
$ns at 252.79582702688413 "$node_(67) setdest 24014 29806 1.0" 
$ns at 286.73967325499115 "$node_(67) setdest 148760 44004 10.0" 
$ns at 363.36055177374396 "$node_(67) setdest 140920 32088 6.0" 
$ns at 429.5143026502112 "$node_(67) setdest 41362 29909 15.0" 
$ns at 516.4599661620939 "$node_(67) setdest 107043 37915 2.0" 
$ns at 558.2864452612073 "$node_(67) setdest 25532 19820 6.0" 
$ns at 644.0114080253318 "$node_(67) setdest 183584 55250 13.0" 
$ns at 718.8832532792037 "$node_(67) setdest 228719 26764 13.0" 
$ns at 802.0635523268677 "$node_(67) setdest 120946 88718 18.0" 
$ns at 895.3851752059222 "$node_(67) setdest 182486 58865 19.0" 
$ns at 0.0 "$node_(68) setdest 31123 26278 9.0" 
$ns at 39.1176180027091 "$node_(68) setdest 64662 28076 10.0" 
$ns at 150.86637320787509 "$node_(68) setdest 87257 35189 16.0" 
$ns at 244.67834983255918 "$node_(68) setdest 39536 7670 3.0" 
$ns at 288.9224068447893 "$node_(68) setdest 114320 11304 4.0" 
$ns at 356.81310191337786 "$node_(68) setdest 63347 1939 11.0" 
$ns at 426.8843520221251 "$node_(68) setdest 63107 26308 17.0" 
$ns at 611.1775332761614 "$node_(68) setdest 5755 5521 14.0" 
$ns at 761.7357761846498 "$node_(68) setdest 81092 4567 15.0" 
$ns at 850.7555479855689 "$node_(68) setdest 32611 79685 9.0" 
$ns at 890.6444593290755 "$node_(68) setdest 95420 37627 1.0" 
$ns at 0.0 "$node_(69) setdest 85804 21715 13.0" 
$ns at 55.9210010166035 "$node_(69) setdest 57760 1622 12.0" 
$ns at 154.80682074517037 "$node_(69) setdest 6174 14929 13.0" 
$ns at 234.67301512355166 "$node_(69) setdest 97878 35994 15.0" 
$ns at 367.0834864232535 "$node_(69) setdest 110753 60359 8.0" 
$ns at 451.4724728006478 "$node_(69) setdest 173525 15230 18.0" 
$ns at 569.1838690373833 "$node_(69) setdest 113383 18982 4.0" 
$ns at 616.2779631485374 "$node_(69) setdest 22399 72703 3.0" 
$ns at 660.6584535375181 "$node_(69) setdest 141324 7109 2.0" 
$ns at 703.397577186472 "$node_(69) setdest 193009 38422 2.0" 
$ns at 749.1322241579568 "$node_(69) setdest 168246 16000 15.0" 
$ns at 811.4158474559281 "$node_(69) setdest 178951 40294 17.0" 
$ns at 842.3635774206537 "$node_(69) setdest 136939 75417 12.0" 
$ns at 0.0 "$node_(70) setdest 51312 13605 13.0" 
$ns at 111.01372085955086 "$node_(70) setdest 43073 29859 4.0" 
$ns at 178.95885386715196 "$node_(70) setdest 15372 27202 1.0" 
$ns at 211.3440367170408 "$node_(70) setdest 21426 42075 15.0" 
$ns at 246.5103464805277 "$node_(70) setdest 35248 3107 1.0" 
$ns at 276.8843224579061 "$node_(70) setdest 158581 20180 11.0" 
$ns at 386.9006088724876 "$node_(70) setdest 175803 43474 5.0" 
$ns at 428.3712379226182 "$node_(70) setdest 55459 2749 6.0" 
$ns at 494.20272937724445 "$node_(70) setdest 133708 29144 2.0" 
$ns at 532.2751201869568 "$node_(70) setdest 117520 12120 9.0" 
$ns at 642.9798225590148 "$node_(70) setdest 165394 64165 13.0" 
$ns at 674.2823548014418 "$node_(70) setdest 75115 74467 9.0" 
$ns at 722.2773405747078 "$node_(70) setdest 158200 10567 14.0" 
$ns at 811.6182168154501 "$node_(70) setdest 157560 1591 11.0" 
$ns at 0.0 "$node_(71) setdest 91620 27890 18.0" 
$ns at 83.96645358177037 "$node_(71) setdest 78423 827 4.0" 
$ns at 137.43187703942198 "$node_(71) setdest 92140 9164 9.0" 
$ns at 183.0011736368663 "$node_(71) setdest 76541 22653 2.0" 
$ns at 229.50259741467673 "$node_(71) setdest 106406 33224 5.0" 
$ns at 285.1999834192293 "$node_(71) setdest 390 35613 1.0" 
$ns at 321.21334131138155 "$node_(71) setdest 118598 49601 17.0" 
$ns at 469.2906284984995 "$node_(71) setdest 22187 36162 19.0" 
$ns at 515.0787184192659 "$node_(71) setdest 18282 47507 11.0" 
$ns at 607.9985763815089 "$node_(71) setdest 173162 5664 16.0" 
$ns at 652.0492944647848 "$node_(71) setdest 164547 54841 17.0" 
$ns at 792.1260972938679 "$node_(71) setdest 46282 34407 18.0" 
$ns at 849.7917271960881 "$node_(71) setdest 177498 9433 9.0" 
$ns at 880.4663223073777 "$node_(71) setdest 175932 26049 8.0" 
$ns at 0.0 "$node_(72) setdest 76243 12386 5.0" 
$ns at 55.17364002009822 "$node_(72) setdest 24581 16577 15.0" 
$ns at 154.64341002247278 "$node_(72) setdest 114415 20352 8.0" 
$ns at 254.90163157805958 "$node_(72) setdest 162574 9449 2.0" 
$ns at 289.4533933450818 "$node_(72) setdest 117250 47498 16.0" 
$ns at 446.66660656812655 "$node_(72) setdest 152326 50841 3.0" 
$ns at 505.32592098269294 "$node_(72) setdest 13002 27814 17.0" 
$ns at 701.4730402985473 "$node_(72) setdest 53192 63248 12.0" 
$ns at 806.3492292314625 "$node_(72) setdest 245624 18254 6.0" 
$ns at 891.2433827066133 "$node_(72) setdest 128556 32818 10.0" 
$ns at 0.0 "$node_(73) setdest 72371 4091 7.0" 
$ns at 89.16280339153107 "$node_(73) setdest 60329 5199 7.0" 
$ns at 172.2166351819539 "$node_(73) setdest 12783 26842 5.0" 
$ns at 250.47644330777064 "$node_(73) setdest 134092 15510 14.0" 
$ns at 419.2796442386075 "$node_(73) setdest 89623 10877 16.0" 
$ns at 462.40059619900023 "$node_(73) setdest 135837 44584 3.0" 
$ns at 518.4268958287915 "$node_(73) setdest 100879 54747 6.0" 
$ns at 557.9351480454075 "$node_(73) setdest 149230 44074 16.0" 
$ns at 681.7212794996185 "$node_(73) setdest 41376 6809 7.0" 
$ns at 744.0158651928972 "$node_(73) setdest 243863 11392 17.0" 
$ns at 864.0299713675731 "$node_(73) setdest 242049 58034 11.0" 
$ns at 0.0 "$node_(74) setdest 82158 2238 8.0" 
$ns at 109.89020592058804 "$node_(74) setdest 62043 22423 3.0" 
$ns at 150.21886044966578 "$node_(74) setdest 84077 7376 18.0" 
$ns at 277.22835429617874 "$node_(74) setdest 22766 42299 13.0" 
$ns at 389.64077044204817 "$node_(74) setdest 16675 45015 5.0" 
$ns at 466.45102170244496 "$node_(74) setdest 90660 30121 19.0" 
$ns at 666.3884616536366 "$node_(74) setdest 205463 5696 11.0" 
$ns at 720.0845935395184 "$node_(74) setdest 217861 81844 7.0" 
$ns at 764.6585416191095 "$node_(74) setdest 145867 53835 10.0" 
$ns at 817.1028064551792 "$node_(74) setdest 117767 75037 17.0" 
$ns at 0.0 "$node_(75) setdest 49657 17191 14.0" 
$ns at 118.81897287796563 "$node_(75) setdest 85473 24787 9.0" 
$ns at 163.76942886952486 "$node_(75) setdest 118114 22867 17.0" 
$ns at 268.41001169378 "$node_(75) setdest 58856 27138 4.0" 
$ns at 320.75390745775456 "$node_(75) setdest 18043 39919 7.0" 
$ns at 370.688330255811 "$node_(75) setdest 17309 1652 13.0" 
$ns at 473.08689145314975 "$node_(75) setdest 56098 14623 14.0" 
$ns at 533.0091105223845 "$node_(75) setdest 164843 5425 4.0" 
$ns at 569.3432100418214 "$node_(75) setdest 127833 31439 15.0" 
$ns at 697.1155685539985 "$node_(75) setdest 114957 19802 5.0" 
$ns at 752.6013635604445 "$node_(75) setdest 86168 13564 4.0" 
$ns at 811.5456902201104 "$node_(75) setdest 234268 51777 18.0" 
$ns at 0.0 "$node_(76) setdest 67726 25960 1.0" 
$ns at 32.263026658694386 "$node_(76) setdest 1480 8051 8.0" 
$ns at 101.4293104740331 "$node_(76) setdest 38570 2177 2.0" 
$ns at 148.32303258667625 "$node_(76) setdest 2830 31075 15.0" 
$ns at 299.5796322189841 "$node_(76) setdest 39984 33759 17.0" 
$ns at 404.23800911205205 "$node_(76) setdest 153672 36533 5.0" 
$ns at 439.4512759319094 "$node_(76) setdest 135030 54866 10.0" 
$ns at 518.3407735128311 "$node_(76) setdest 194057 64434 15.0" 
$ns at 642.0171282229595 "$node_(76) setdest 118638 29149 3.0" 
$ns at 672.6772250983413 "$node_(76) setdest 166154 79635 20.0" 
$ns at 895.0434075069917 "$node_(76) setdest 187320 38683 13.0" 
$ns at 0.0 "$node_(77) setdest 48731 24550 2.0" 
$ns at 48.945343045043174 "$node_(77) setdest 14904 9032 3.0" 
$ns at 87.74607638859908 "$node_(77) setdest 11244 22110 8.0" 
$ns at 124.06406020368735 "$node_(77) setdest 34741 24587 7.0" 
$ns at 183.13412459524022 "$node_(77) setdest 83464 40819 4.0" 
$ns at 220.89492317411944 "$node_(77) setdest 96005 17971 9.0" 
$ns at 329.266469857835 "$node_(77) setdest 18021 15546 8.0" 
$ns at 386.4807396094803 "$node_(77) setdest 162232 3874 12.0" 
$ns at 437.84045076481027 "$node_(77) setdest 55834 12708 7.0" 
$ns at 471.67498741785204 "$node_(77) setdest 172456 2878 2.0" 
$ns at 507.8498905991587 "$node_(77) setdest 172581 43582 4.0" 
$ns at 558.1548180753389 "$node_(77) setdest 203187 74912 18.0" 
$ns at 646.7613243399178 "$node_(77) setdest 173958 52528 1.0" 
$ns at 678.9114070595301 "$node_(77) setdest 114529 64821 4.0" 
$ns at 715.3967663774503 "$node_(77) setdest 57222 49890 6.0" 
$ns at 762.3101811830014 "$node_(77) setdest 125801 84595 10.0" 
$ns at 805.1855284063911 "$node_(77) setdest 61826 57023 10.0" 
$ns at 873.1068823675837 "$node_(77) setdest 241549 48787 7.0" 
$ns at 0.0 "$node_(78) setdest 90047 12438 5.0" 
$ns at 75.6720461693134 "$node_(78) setdest 58241 25982 11.0" 
$ns at 171.25362709283291 "$node_(78) setdest 44505 32015 19.0" 
$ns at 219.36338018999027 "$node_(78) setdest 80034 17362 5.0" 
$ns at 284.3458564329089 "$node_(78) setdest 108048 52922 7.0" 
$ns at 374.88736741515856 "$node_(78) setdest 27354 16560 3.0" 
$ns at 406.0946935669545 "$node_(78) setdest 50838 29682 5.0" 
$ns at 480.0845410318968 "$node_(78) setdest 154014 19177 11.0" 
$ns at 513.3519003762971 "$node_(78) setdest 171918 22657 12.0" 
$ns at 546.2310181197752 "$node_(78) setdest 108899 43081 8.0" 
$ns at 641.6867266446023 "$node_(78) setdest 142147 72615 7.0" 
$ns at 681.7419932334949 "$node_(78) setdest 203797 45754 16.0" 
$ns at 739.7062725589788 "$node_(78) setdest 10513 315 2.0" 
$ns at 789.0579043037383 "$node_(78) setdest 237905 51721 1.0" 
$ns at 826.5526134362078 "$node_(78) setdest 263951 62238 17.0" 
$ns at 0.0 "$node_(79) setdest 86882 16356 11.0" 
$ns at 90.39577753280054 "$node_(79) setdest 73011 10770 15.0" 
$ns at 236.80478955256598 "$node_(79) setdest 8685 14043 9.0" 
$ns at 330.5726214352816 "$node_(79) setdest 32943 49107 9.0" 
$ns at 395.39930074463695 "$node_(79) setdest 173639 38718 15.0" 
$ns at 558.9577364156257 "$node_(79) setdest 118218 70020 17.0" 
$ns at 741.7614173091474 "$node_(79) setdest 185825 26357 19.0" 
$ns at 0.0 "$node_(80) setdest 35998 25214 12.0" 
$ns at 54.62922481407028 "$node_(80) setdest 34461 21541 15.0" 
$ns at 130.2923815531007 "$node_(80) setdest 37262 22969 9.0" 
$ns at 211.6396167723957 "$node_(80) setdest 78656 32148 13.0" 
$ns at 276.88478299078963 "$node_(80) setdest 82270 15254 19.0" 
$ns at 428.07726366279417 "$node_(80) setdest 81768 56805 6.0" 
$ns at 502.1432746636395 "$node_(80) setdest 85184 52927 14.0" 
$ns at 571.0362724559479 "$node_(80) setdest 157042 34955 12.0" 
$ns at 684.5643207171013 "$node_(80) setdest 232400 71022 2.0" 
$ns at 724.2570250883173 "$node_(80) setdest 108063 65237 18.0" 
$ns at 818.521949148439 "$node_(80) setdest 213640 584 9.0" 
$ns at 0.0 "$node_(81) setdest 69735 23356 8.0" 
$ns at 46.6380612664053 "$node_(81) setdest 35529 20216 2.0" 
$ns at 92.87666463834485 "$node_(81) setdest 39989 25827 16.0" 
$ns at 187.44601019808067 "$node_(81) setdest 35020 2570 4.0" 
$ns at 223.9971731306108 "$node_(81) setdest 97595 21611 1.0" 
$ns at 254.02484654771163 "$node_(81) setdest 140747 48460 3.0" 
$ns at 298.54479929667207 "$node_(81) setdest 65499 11992 15.0" 
$ns at 464.64892573572513 "$node_(81) setdest 53613 10107 8.0" 
$ns at 533.8464426259152 "$node_(81) setdest 57241 202 8.0" 
$ns at 610.2763701307933 "$node_(81) setdest 14589 30593 3.0" 
$ns at 655.1321929470101 "$node_(81) setdest 140961 22861 9.0" 
$ns at 764.0398133452386 "$node_(81) setdest 15123 52872 18.0" 
$ns at 872.5431530830787 "$node_(81) setdest 102325 56558 16.0" 
$ns at 0.0 "$node_(82) setdest 67519 16212 12.0" 
$ns at 102.3518527887868 "$node_(82) setdest 15874 25769 10.0" 
$ns at 171.73329815665414 "$node_(82) setdest 6491 42806 10.0" 
$ns at 254.84892759367986 "$node_(82) setdest 10439 37757 8.0" 
$ns at 342.4450278016353 "$node_(82) setdest 58130 3334 1.0" 
$ns at 380.05937266819853 "$node_(82) setdest 87980 19737 20.0" 
$ns at 437.8532391064416 "$node_(82) setdest 126529 25403 5.0" 
$ns at 489.06160175331513 "$node_(82) setdest 45191 21435 10.0" 
$ns at 578.1900368020418 "$node_(82) setdest 30764 60257 18.0" 
$ns at 762.3164872189948 "$node_(82) setdest 55181 5728 17.0" 
$ns at 0.0 "$node_(83) setdest 55841 25534 13.0" 
$ns at 121.89991631717307 "$node_(83) setdest 34730 19180 11.0" 
$ns at 194.78384872764042 "$node_(83) setdest 297 33137 3.0" 
$ns at 231.97194420773576 "$node_(83) setdest 33979 539 17.0" 
$ns at 288.283231778755 "$node_(83) setdest 100783 7388 20.0" 
$ns at 475.68777389331865 "$node_(83) setdest 164416 55956 12.0" 
$ns at 565.949103030936 "$node_(83) setdest 210137 21519 4.0" 
$ns at 618.6052588931747 "$node_(83) setdest 174709 51429 2.0" 
$ns at 657.8046328459486 "$node_(83) setdest 189480 43104 11.0" 
$ns at 722.1126004573531 "$node_(83) setdest 79595 44080 17.0" 
$ns at 785.4102901808371 "$node_(83) setdest 106865 77541 9.0" 
$ns at 854.2182201780543 "$node_(83) setdest 105703 56523 6.0" 
$ns at 889.7355588180757 "$node_(83) setdest 10609 52067 7.0" 
$ns at 0.0 "$node_(84) setdest 69706 7648 16.0" 
$ns at 189.634792546739 "$node_(84) setdest 33771 23515 7.0" 
$ns at 241.0397967962187 "$node_(84) setdest 35371 12682 12.0" 
$ns at 330.2800170451268 "$node_(84) setdest 83988 29685 14.0" 
$ns at 484.0513250022657 "$node_(84) setdest 150315 54423 17.0" 
$ns at 556.1357028688919 "$node_(84) setdest 113025 14529 18.0" 
$ns at 636.1129815946333 "$node_(84) setdest 177227 470 3.0" 
$ns at 689.96848309249 "$node_(84) setdest 236836 40314 16.0" 
$ns at 872.307746015535 "$node_(84) setdest 70280 76627 2.0" 
$ns at 0.0 "$node_(85) setdest 36196 17893 17.0" 
$ns at 45.16249635306059 "$node_(85) setdest 11247 18465 5.0" 
$ns at 91.10011865986885 "$node_(85) setdest 72104 13160 13.0" 
$ns at 148.37314268213132 "$node_(85) setdest 94634 1083 13.0" 
$ns at 187.39228336851264 "$node_(85) setdest 125355 356 2.0" 
$ns at 236.94632233512908 "$node_(85) setdest 130805 8484 4.0" 
$ns at 287.33114894303003 "$node_(85) setdest 108355 31300 2.0" 
$ns at 320.1447967519833 "$node_(85) setdest 109512 19347 8.0" 
$ns at 416.6999977923544 "$node_(85) setdest 52590 52904 2.0" 
$ns at 463.02323339583035 "$node_(85) setdest 119625 34535 12.0" 
$ns at 588.1380683687387 "$node_(85) setdest 104497 31731 11.0" 
$ns at 681.7717113953761 "$node_(85) setdest 142752 40395 20.0" 
$ns at 864.1398329588084 "$node_(85) setdest 148151 60715 3.0" 
$ns at 895.7834648044067 "$node_(85) setdest 257620 31720 15.0" 
$ns at 0.0 "$node_(86) setdest 55814 28117 7.0" 
$ns at 99.05272359190919 "$node_(86) setdest 27152 21245 9.0" 
$ns at 194.24986090618862 "$node_(86) setdest 99607 12760 16.0" 
$ns at 378.390067952677 "$node_(86) setdest 174023 44497 19.0" 
$ns at 570.343342275974 "$node_(86) setdest 216079 35998 1.0" 
$ns at 603.2200763302825 "$node_(86) setdest 57496 5699 19.0" 
$ns at 711.6173812599367 "$node_(86) setdest 241188 28082 12.0" 
$ns at 822.5483389266237 "$node_(86) setdest 210967 83601 7.0" 
$ns at 855.8444821659899 "$node_(86) setdest 48369 29110 10.0" 
$ns at 0.0 "$node_(87) setdest 59244 29540 1.0" 
$ns at 31.313767480382307 "$node_(87) setdest 65986 23186 18.0" 
$ns at 156.17974706686473 "$node_(87) setdest 2155 21885 13.0" 
$ns at 233.4315426912276 "$node_(87) setdest 74939 16583 7.0" 
$ns at 291.27648439275566 "$node_(87) setdest 10183 7867 8.0" 
$ns at 381.89142960373204 "$node_(87) setdest 97144 56168 2.0" 
$ns at 416.12322191955667 "$node_(87) setdest 139588 1339 17.0" 
$ns at 509.98364004287794 "$node_(87) setdest 35078 30071 19.0" 
$ns at 641.5898182645167 "$node_(87) setdest 171467 50430 19.0" 
$ns at 743.1272124381932 "$node_(87) setdest 178994 40855 8.0" 
$ns at 790.3459041380761 "$node_(87) setdest 246533 60808 16.0" 
$ns at 855.2732178564994 "$node_(87) setdest 149845 17091 7.0" 
$ns at 0.0 "$node_(88) setdest 24342 7656 3.0" 
$ns at 32.77392338192325 "$node_(88) setdest 43233 8194 18.0" 
$ns at 75.03257786047563 "$node_(88) setdest 59778 267 14.0" 
$ns at 234.35762338805137 "$node_(88) setdest 4747 19649 12.0" 
$ns at 379.2574779412403 "$node_(88) setdest 165811 11425 1.0" 
$ns at 414.43001408970105 "$node_(88) setdest 156347 13327 13.0" 
$ns at 560.1773483087895 "$node_(88) setdest 198496 73865 5.0" 
$ns at 624.4197780880617 "$node_(88) setdest 28636 72766 8.0" 
$ns at 666.9367720281033 "$node_(88) setdest 139061 17826 3.0" 
$ns at 709.9247956487013 "$node_(88) setdest 90475 73151 12.0" 
$ns at 828.7265383425158 "$node_(88) setdest 108855 43771 8.0" 
$ns at 0.0 "$node_(89) setdest 73537 19806 19.0" 
$ns at 217.65200496052532 "$node_(89) setdest 48126 19508 13.0" 
$ns at 264.6715073647096 "$node_(89) setdest 90923 1445 18.0" 
$ns at 341.7378030678074 "$node_(89) setdest 69352 19398 14.0" 
$ns at 372.4892672910466 "$node_(89) setdest 146892 32064 2.0" 
$ns at 403.17894944927514 "$node_(89) setdest 126796 33427 17.0" 
$ns at 590.7322532930101 "$node_(89) setdest 181617 31074 11.0" 
$ns at 635.580022077341 "$node_(89) setdest 218029 31055 7.0" 
$ns at 671.1465418113352 "$node_(89) setdest 211838 67281 12.0" 
$ns at 712.841705664718 "$node_(89) setdest 184430 70640 1.0" 
$ns at 746.3501838913473 "$node_(89) setdest 54309 74594 1.0" 
$ns at 784.6170376658998 "$node_(89) setdest 11591 5431 19.0" 
$ns at 861.1576976044871 "$node_(89) setdest 259357 75053 3.0" 
$ns at 892.1209492890655 "$node_(89) setdest 18037 77952 1.0" 
$ns at 0.0 "$node_(90) setdest 17097 23346 19.0" 
$ns at 56.533337958030565 "$node_(90) setdest 11253 13268 17.0" 
$ns at 229.68128399442463 "$node_(90) setdest 54626 6807 17.0" 
$ns at 368.11790232519627 "$node_(90) setdest 28201 34956 10.0" 
$ns at 413.37082394153657 "$node_(90) setdest 87759 13094 10.0" 
$ns at 449.9229942130962 "$node_(90) setdest 125163 25833 18.0" 
$ns at 550.1578714297455 "$node_(90) setdest 219838 28045 18.0" 
$ns at 597.735341337222 "$node_(90) setdest 228986 75068 12.0" 
$ns at 728.617206547638 "$node_(90) setdest 23230 21297 10.0" 
$ns at 802.3220075976747 "$node_(90) setdest 47678 54277 8.0" 
$ns at 858.8088362913588 "$node_(90) setdest 219319 23504 15.0" 
$ns at 0.0 "$node_(91) setdest 93774 28094 20.0" 
$ns at 207.94756681916869 "$node_(91) setdest 9296 30512 13.0" 
$ns at 352.5223937617146 "$node_(91) setdest 129968 10065 1.0" 
$ns at 389.5006141315419 "$node_(91) setdest 162248 41721 18.0" 
$ns at 549.3992397526993 "$node_(91) setdest 145659 47752 2.0" 
$ns at 587.6954847623792 "$node_(91) setdest 127437 21587 12.0" 
$ns at 686.5706358114428 "$node_(91) setdest 65674 25506 2.0" 
$ns at 720.7664464870976 "$node_(91) setdest 86865 37061 1.0" 
$ns at 759.1326237278091 "$node_(91) setdest 207128 5880 1.0" 
$ns at 789.9392773249058 "$node_(91) setdest 264613 40236 5.0" 
$ns at 834.6248053211418 "$node_(91) setdest 54832 1933 17.0" 
$ns at 0.0 "$node_(92) setdest 8509 12655 8.0" 
$ns at 65.34220485992103 "$node_(92) setdest 92668 9619 18.0" 
$ns at 99.43753585902962 "$node_(92) setdest 70240 26506 19.0" 
$ns at 182.3160686274399 "$node_(92) setdest 34509 12603 15.0" 
$ns at 291.53777124404047 "$node_(92) setdest 27135 14590 1.0" 
$ns at 326.62767934166493 "$node_(92) setdest 46624 7900 19.0" 
$ns at 440.9978386222631 "$node_(92) setdest 119266 27169 19.0" 
$ns at 543.3416958332446 "$node_(92) setdest 90104 29860 5.0" 
$ns at 574.320931463929 "$node_(92) setdest 210384 39739 18.0" 
$ns at 711.8977003759144 "$node_(92) setdest 242580 17797 20.0" 
$ns at 819.4362115806084 "$node_(92) setdest 252987 58025 8.0" 
$ns at 851.5595194351567 "$node_(92) setdest 232577 11400 10.0" 
$ns at 0.0 "$node_(93) setdest 54840 11856 16.0" 
$ns at 53.96094752191928 "$node_(93) setdest 91404 7485 14.0" 
$ns at 109.90670258358435 "$node_(93) setdest 40029 29815 15.0" 
$ns at 210.64488198031904 "$node_(93) setdest 50349 23507 2.0" 
$ns at 251.3552112777064 "$node_(93) setdest 45010 33715 19.0" 
$ns at 345.15459149085575 "$node_(93) setdest 13729 34729 2.0" 
$ns at 376.7810974408637 "$node_(93) setdest 129138 22354 5.0" 
$ns at 449.8317882530547 "$node_(93) setdest 177135 56837 7.0" 
$ns at 529.508908630424 "$node_(93) setdest 106401 37517 8.0" 
$ns at 635.6144710404075 "$node_(93) setdest 126223 74924 1.0" 
$ns at 670.9417283466065 "$node_(93) setdest 149460 48255 18.0" 
$ns at 806.8994371476867 "$node_(93) setdest 230013 45150 3.0" 
$ns at 856.8402526610718 "$node_(93) setdest 265611 61694 2.0" 
$ns at 0.0 "$node_(94) setdest 31889 24044 12.0" 
$ns at 112.19676152562053 "$node_(94) setdest 14065 382 5.0" 
$ns at 165.06522630781504 "$node_(94) setdest 2284 666 12.0" 
$ns at 209.42375760317532 "$node_(94) setdest 26432 41012 20.0" 
$ns at 342.23088758509044 "$node_(94) setdest 153650 9821 2.0" 
$ns at 382.6996681640418 "$node_(94) setdest 42907 18883 9.0" 
$ns at 425.3120345414025 "$node_(94) setdest 122243 3917 4.0" 
$ns at 495.0714545480066 "$node_(94) setdest 5681 641 11.0" 
$ns at 630.5151360175594 "$node_(94) setdest 191731 5863 6.0" 
$ns at 672.5585535980723 "$node_(94) setdest 220575 70309 16.0" 
$ns at 773.2663342632691 "$node_(94) setdest 58425 36109 14.0" 
$ns at 839.6893244158359 "$node_(94) setdest 67559 61867 7.0" 
$ns at 0.0 "$node_(95) setdest 35036 28255 9.0" 
$ns at 33.576321124589555 "$node_(95) setdest 50541 25925 2.0" 
$ns at 80.8229955361867 "$node_(95) setdest 88496 6289 12.0" 
$ns at 197.48543938503877 "$node_(95) setdest 19284 14093 4.0" 
$ns at 256.0683830309242 "$node_(95) setdest 83260 51448 1.0" 
$ns at 293.1940105802566 "$node_(95) setdest 108890 10909 3.0" 
$ns at 351.96544171023675 "$node_(95) setdest 47972 56686 5.0" 
$ns at 392.9566395826483 "$node_(95) setdest 153837 49782 7.0" 
$ns at 450.4929758394843 "$node_(95) setdest 165803 36475 11.0" 
$ns at 490.9543803264823 "$node_(95) setdest 89037 14887 3.0" 
$ns at 521.3154260220728 "$node_(95) setdest 8921 16796 14.0" 
$ns at 657.5269737566257 "$node_(95) setdest 186202 20457 1.0" 
$ns at 693.079765641175 "$node_(95) setdest 51589 35015 8.0" 
$ns at 746.8802965078755 "$node_(95) setdest 179923 69769 3.0" 
$ns at 791.5368020712364 "$node_(95) setdest 209591 78074 3.0" 
$ns at 823.5132431112349 "$node_(95) setdest 15546 86138 3.0" 
$ns at 864.5949954336302 "$node_(95) setdest 121001 26442 4.0" 
$ns at 0.0 "$node_(96) setdest 25724 24151 13.0" 
$ns at 135.15854210677833 "$node_(96) setdest 34545 2860 19.0" 
$ns at 178.82605444519143 "$node_(96) setdest 130224 246 11.0" 
$ns at 262.1560647619751 "$node_(96) setdest 144102 20352 8.0" 
$ns at 307.0948480917672 "$node_(96) setdest 17006 19914 1.0" 
$ns at 346.22545058356417 "$node_(96) setdest 160733 8682 7.0" 
$ns at 433.4744750972223 "$node_(96) setdest 179775 6831 2.0" 
$ns at 482.1766265791084 "$node_(96) setdest 188226 2368 11.0" 
$ns at 622.1599822992143 "$node_(96) setdest 231148 8468 2.0" 
$ns at 654.7179389048287 "$node_(96) setdest 141683 65371 18.0" 
$ns at 736.6302534510089 "$node_(96) setdest 21211 25503 13.0" 
$ns at 843.7831287921418 "$node_(96) setdest 32197 69851 13.0" 
$ns at 896.7571105617127 "$node_(96) setdest 107121 1810 13.0" 
$ns at 0.0 "$node_(97) setdest 34323 5318 9.0" 
$ns at 90.39973234007981 "$node_(97) setdest 17608 25018 10.0" 
$ns at 188.2854949599838 "$node_(97) setdest 130051 1760 2.0" 
$ns at 230.43472723373617 "$node_(97) setdest 42334 25881 1.0" 
$ns at 264.85043388739984 "$node_(97) setdest 5242 11803 15.0" 
$ns at 375.9836615537325 "$node_(97) setdest 9332 33170 16.0" 
$ns at 536.0030299839083 "$node_(97) setdest 199369 23767 1.0" 
$ns at 568.9067879652158 "$node_(97) setdest 142635 49430 14.0" 
$ns at 619.3495915413441 "$node_(97) setdest 201452 23440 16.0" 
$ns at 724.645502786836 "$node_(97) setdest 115883 5349 18.0" 
$ns at 777.3651479751061 "$node_(97) setdest 89101 30457 19.0" 
$ns at 0.0 "$node_(98) setdest 30389 25896 19.0" 
$ns at 32.3818049824242 "$node_(98) setdest 54911 6338 17.0" 
$ns at 158.82562321673373 "$node_(98) setdest 53420 6634 2.0" 
$ns at 207.21586542432365 "$node_(98) setdest 102059 11924 17.0" 
$ns at 354.2030426219019 "$node_(98) setdest 68162 56477 9.0" 
$ns at 459.8279226222393 "$node_(98) setdest 36260 41979 16.0" 
$ns at 559.3316047412711 "$node_(98) setdest 216097 39657 9.0" 
$ns at 622.6226961959472 "$node_(98) setdest 1055 10814 13.0" 
$ns at 739.4166863378042 "$node_(98) setdest 63034 54936 18.0" 
$ns at 829.8623557275632 "$node_(98) setdest 105033 64062 14.0" 
$ns at 868.1690940045788 "$node_(98) setdest 91009 39278 3.0" 
$ns at 0.0 "$node_(99) setdest 65314 13446 1.0" 
$ns at 38.29236250794168 "$node_(99) setdest 25488 25021 13.0" 
$ns at 79.46189621730137 "$node_(99) setdest 25512 18970 8.0" 
$ns at 119.65189530711976 "$node_(99) setdest 89241 17605 16.0" 
$ns at 301.5903720782021 "$node_(99) setdest 48902 28623 15.0" 
$ns at 427.7888318955026 "$node_(99) setdest 104237 13460 11.0" 
$ns at 549.2208503886409 "$node_(99) setdest 48784 30846 4.0" 
$ns at 589.6585922912905 "$node_(99) setdest 25690 28276 11.0" 
$ns at 720.2709190852975 "$node_(99) setdest 5861 51919 6.0" 
$ns at 803.2265300961178 "$node_(99) setdest 178516 36616 10.0" 
$ns at 887.2688887611984 "$node_(99) setdest 80172 49369 18.0" 
$ns at 0.0 "$node_(100) setdest 2942 323 12.0" 
$ns at 147.83665769137096 "$node_(100) setdest 89323 13180 1.0" 
$ns at 182.41277127632006 "$node_(100) setdest 20096 11933 5.0" 
$ns at 251.69745960779795 "$node_(100) setdest 144405 27243 16.0" 
$ns at 412.4396787528778 "$node_(100) setdest 111525 49108 2.0" 
$ns at 445.06166800628625 "$node_(100) setdest 4293 12688 7.0" 
$ns at 502.23430001047024 "$node_(100) setdest 102108 62446 3.0" 
$ns at 559.7857147395034 "$node_(100) setdest 143253 57960 18.0" 
$ns at 641.2831900623087 "$node_(100) setdest 25735 66767 4.0" 
$ns at 692.8973948124126 "$node_(100) setdest 118922 66841 18.0" 
$ns at 809.3855337761736 "$node_(100) setdest 6537 77868 18.0" 
$ns at 138.40955345778508 "$node_(101) setdest 86643 27998 9.0" 
$ns at 183.5330507940719 "$node_(101) setdest 57294 28920 6.0" 
$ns at 262.0659901339892 "$node_(101) setdest 19903 10972 13.0" 
$ns at 406.2360741417647 "$node_(101) setdest 6586 22803 12.0" 
$ns at 470.41291498852286 "$node_(101) setdest 185962 10820 17.0" 
$ns at 505.57175377182324 "$node_(101) setdest 207097 15054 3.0" 
$ns at 564.3749678902572 "$node_(101) setdest 73700 68354 16.0" 
$ns at 661.5755094357406 "$node_(101) setdest 184709 56840 6.0" 
$ns at 709.9276970022742 "$node_(101) setdest 38865 71115 16.0" 
$ns at 817.9175222269579 "$node_(101) setdest 109884 82471 1.0" 
$ns at 855.3465649115224 "$node_(101) setdest 222814 47264 12.0" 
$ns at 114.6382942987018 "$node_(102) setdest 64873 23203 1.0" 
$ns at 145.35152392119784 "$node_(102) setdest 33027 7375 16.0" 
$ns at 319.2398224034143 "$node_(102) setdest 49499 20473 14.0" 
$ns at 356.2169492062433 "$node_(102) setdest 180600 3650 19.0" 
$ns at 474.7568487541679 "$node_(102) setdest 42799 32403 18.0" 
$ns at 596.6805779585385 "$node_(102) setdest 163929 8289 2.0" 
$ns at 641.7502193026329 "$node_(102) setdest 183516 39800 5.0" 
$ns at 693.4840756809028 "$node_(102) setdest 5909 62619 3.0" 
$ns at 745.725783982671 "$node_(102) setdest 249602 40873 12.0" 
$ns at 782.8056910394827 "$node_(102) setdest 86622 24143 10.0" 
$ns at 817.3766983905341 "$node_(102) setdest 87011 5642 13.0" 
$ns at 126.04996826509688 "$node_(103) setdest 34302 16463 10.0" 
$ns at 228.96211677042805 "$node_(103) setdest 97449 20581 11.0" 
$ns at 344.9618094913807 "$node_(103) setdest 92276 44871 12.0" 
$ns at 406.45200383781423 "$node_(103) setdest 37121 7389 3.0" 
$ns at 455.96990994030347 "$node_(103) setdest 99395 53901 1.0" 
$ns at 490.2873460244343 "$node_(103) setdest 137774 53422 15.0" 
$ns at 668.5864992629522 "$node_(103) setdest 178876 34330 11.0" 
$ns at 702.2794112378148 "$node_(103) setdest 146194 62275 12.0" 
$ns at 776.4055535752736 "$node_(103) setdest 107473 11623 16.0" 
$ns at 118.3542910156179 "$node_(104) setdest 11362 11934 7.0" 
$ns at 176.7102419433382 "$node_(104) setdest 23288 41767 12.0" 
$ns at 263.06665486538145 "$node_(104) setdest 116949 43248 10.0" 
$ns at 353.10406375029413 "$node_(104) setdest 170735 17161 17.0" 
$ns at 528.3385254388842 "$node_(104) setdest 141108 41544 18.0" 
$ns at 558.7191433702616 "$node_(104) setdest 47142 42753 5.0" 
$ns at 602.3712516914923 "$node_(104) setdest 97857 35533 5.0" 
$ns at 645.5783166107498 "$node_(104) setdest 150122 61812 19.0" 
$ns at 833.4528835751931 "$node_(104) setdest 85287 15311 15.0" 
$ns at 158.32611065807976 "$node_(105) setdest 9226 14719 10.0" 
$ns at 197.7749025316623 "$node_(105) setdest 27037 27796 7.0" 
$ns at 275.81781778777895 "$node_(105) setdest 94816 44826 5.0" 
$ns at 320.3390756783149 "$node_(105) setdest 114118 1987 17.0" 
$ns at 447.5786018410528 "$node_(105) setdest 61835 60745 17.0" 
$ns at 623.3653871083213 "$node_(105) setdest 114233 16757 5.0" 
$ns at 691.9047771647947 "$node_(105) setdest 209034 53938 2.0" 
$ns at 730.9212330492594 "$node_(105) setdest 149237 74642 19.0" 
$ns at 142.6589870695685 "$node_(106) setdest 65334 2723 18.0" 
$ns at 270.050081367408 "$node_(106) setdest 125196 44145 7.0" 
$ns at 310.7814846694581 "$node_(106) setdest 121394 26875 15.0" 
$ns at 468.51747120092784 "$node_(106) setdest 178492 39260 1.0" 
$ns at 502.05364664739386 "$node_(106) setdest 130738 46514 10.0" 
$ns at 540.7215897112168 "$node_(106) setdest 132746 13048 14.0" 
$ns at 603.9223401327321 "$node_(106) setdest 170318 70588 11.0" 
$ns at 703.592517998702 "$node_(106) setdest 178390 50157 11.0" 
$ns at 778.4737953083785 "$node_(106) setdest 118646 6781 10.0" 
$ns at 871.8329341631847 "$node_(106) setdest 113006 26536 2.0" 
$ns at 129.94679196493828 "$node_(107) setdest 81228 27356 1.0" 
$ns at 166.43979005689803 "$node_(107) setdest 45343 15133 5.0" 
$ns at 231.4496607980253 "$node_(107) setdest 89717 27576 19.0" 
$ns at 370.8598122464167 "$node_(107) setdest 116401 37442 7.0" 
$ns at 413.45073190397727 "$node_(107) setdest 44912 40843 17.0" 
$ns at 560.3140185680552 "$node_(107) setdest 143385 17860 8.0" 
$ns at 600.6351047944387 "$node_(107) setdest 153992 6161 8.0" 
$ns at 636.2454810237954 "$node_(107) setdest 96486 23837 8.0" 
$ns at 724.8635821266456 "$node_(107) setdest 137393 41521 8.0" 
$ns at 809.4632410735937 "$node_(107) setdest 264039 74322 9.0" 
$ns at 897.1382337067934 "$node_(107) setdest 189162 45195 8.0" 
$ns at 198.3315525023966 "$node_(108) setdest 132893 19311 16.0" 
$ns at 295.8865220383147 "$node_(108) setdest 159665 44620 17.0" 
$ns at 411.8887523720626 "$node_(108) setdest 19678 47534 13.0" 
$ns at 560.0184029775264 "$node_(108) setdest 201409 46752 2.0" 
$ns at 598.3934757106583 "$node_(108) setdest 111871 13167 3.0" 
$ns at 644.4642739878007 "$node_(108) setdest 200073 14687 8.0" 
$ns at 682.904247020226 "$node_(108) setdest 161377 40999 16.0" 
$ns at 864.2256424508035 "$node_(108) setdest 83160 23752 7.0" 
$ns at 106.23798870159794 "$node_(109) setdest 19085 21215 1.0" 
$ns at 139.33529821220992 "$node_(109) setdest 93386 29191 16.0" 
$ns at 307.42124924545067 "$node_(109) setdest 82983 6676 15.0" 
$ns at 378.8215961008656 "$node_(109) setdest 149034 28163 17.0" 
$ns at 566.5203373855852 "$node_(109) setdest 134079 56199 16.0" 
$ns at 624.7470384630466 "$node_(109) setdest 214099 67763 15.0" 
$ns at 658.928190038303 "$node_(109) setdest 73164 1649 5.0" 
$ns at 735.1246640979585 "$node_(109) setdest 6357 71708 19.0" 
$ns at 190.47578306795958 "$node_(110) setdest 43398 26635 18.0" 
$ns at 271.0680555779048 "$node_(110) setdest 24824 7105 8.0" 
$ns at 338.87166702630714 "$node_(110) setdest 160830 53308 5.0" 
$ns at 414.7837603510603 "$node_(110) setdest 75630 52517 1.0" 
$ns at 452.71499597878557 "$node_(110) setdest 2153 23858 7.0" 
$ns at 526.0617476268426 "$node_(110) setdest 172136 633 16.0" 
$ns at 664.9424262519988 "$node_(110) setdest 133288 49927 13.0" 
$ns at 779.1314268114493 "$node_(110) setdest 253701 2981 11.0" 
$ns at 827.2982444068342 "$node_(110) setdest 146105 85590 2.0" 
$ns at 875.9273333201432 "$node_(110) setdest 34460 71184 3.0" 
$ns at 224.8389317194617 "$node_(111) setdest 69995 42356 15.0" 
$ns at 365.17741618857326 "$node_(111) setdest 109285 30851 19.0" 
$ns at 575.9317211837723 "$node_(111) setdest 116782 839 4.0" 
$ns at 618.6856343645636 "$node_(111) setdest 225943 4516 8.0" 
$ns at 692.9276942688157 "$node_(111) setdest 28995 65973 11.0" 
$ns at 799.1424717233068 "$node_(111) setdest 93309 35458 19.0" 
$ns at 123.60048596981326 "$node_(112) setdest 19755 21719 18.0" 
$ns at 289.0697096782984 "$node_(112) setdest 37329 46109 2.0" 
$ns at 322.67139934089204 "$node_(112) setdest 18953 40999 10.0" 
$ns at 358.7820926042742 "$node_(112) setdest 128706 34884 14.0" 
$ns at 409.0527283560304 "$node_(112) setdest 28732 53938 6.0" 
$ns at 475.61256240133224 "$node_(112) setdest 92883 18726 13.0" 
$ns at 557.0660769219669 "$node_(112) setdest 140119 55774 19.0" 
$ns at 739.0698631442228 "$node_(112) setdest 51136 75219 12.0" 
$ns at 808.5020841622533 "$node_(112) setdest 127526 8124 9.0" 
$ns at 162.54419167369906 "$node_(113) setdest 40141 24447 6.0" 
$ns at 203.3431158479018 "$node_(113) setdest 21566 11566 3.0" 
$ns at 237.66263878419124 "$node_(113) setdest 40064 20780 7.0" 
$ns at 290.32929415424 "$node_(113) setdest 142134 24961 18.0" 
$ns at 435.329853589455 "$node_(113) setdest 80501 17850 13.0" 
$ns at 540.7447534212938 "$node_(113) setdest 198012 65732 14.0" 
$ns at 616.0634959224972 "$node_(113) setdest 49979 22001 13.0" 
$ns at 663.3837800304645 "$node_(113) setdest 53319 24908 6.0" 
$ns at 698.5429588076317 "$node_(113) setdest 182500 36038 14.0" 
$ns at 768.0359068611191 "$node_(113) setdest 176398 24430 9.0" 
$ns at 840.6104989153744 "$node_(113) setdest 262672 20685 5.0" 
$ns at 894.6569765050398 "$node_(113) setdest 225092 26896 6.0" 
$ns at 106.81491096041773 "$node_(114) setdest 87492 6659 2.0" 
$ns at 139.05695720905982 "$node_(114) setdest 78918 16593 15.0" 
$ns at 196.99601396565456 "$node_(114) setdest 133817 6257 4.0" 
$ns at 253.61964487117342 "$node_(114) setdest 28054 18473 17.0" 
$ns at 305.2824503288936 "$node_(114) setdest 47314 42816 8.0" 
$ns at 394.8689484595306 "$node_(114) setdest 94043 54997 10.0" 
$ns at 432.43597346899475 "$node_(114) setdest 1953 21456 19.0" 
$ns at 582.3658005348643 "$node_(114) setdest 75455 10673 12.0" 
$ns at 694.9498742429814 "$node_(114) setdest 94004 32873 2.0" 
$ns at 727.3114176947178 "$node_(114) setdest 70802 29455 2.0" 
$ns at 776.7647007459963 "$node_(114) setdest 55423 28611 18.0" 
$ns at 840.5829312681151 "$node_(114) setdest 173410 84951 18.0" 
$ns at 878.7239681381378 "$node_(114) setdest 70616 65059 12.0" 
$ns at 132.75097134133546 "$node_(115) setdest 59454 20962 4.0" 
$ns at 179.34545696969644 "$node_(115) setdest 40866 31810 5.0" 
$ns at 215.03547617412286 "$node_(115) setdest 20078 35052 11.0" 
$ns at 342.43225206530724 "$node_(115) setdest 39370 29107 8.0" 
$ns at 373.5650648630565 "$node_(115) setdest 22878 21790 10.0" 
$ns at 434.935314816802 "$node_(115) setdest 87458 2209 7.0" 
$ns at 521.2670014847267 "$node_(115) setdest 21030 66462 13.0" 
$ns at 583.1045212111985 "$node_(115) setdest 76209 69252 20.0" 
$ns at 748.7321074713494 "$node_(115) setdest 214845 72889 1.0" 
$ns at 788.5335039569865 "$node_(115) setdest 105139 54736 3.0" 
$ns at 843.8075863529828 "$node_(115) setdest 55904 19714 18.0" 
$ns at 195.6309309044841 "$node_(116) setdest 134117 24082 6.0" 
$ns at 260.22067789073014 "$node_(116) setdest 65235 44367 3.0" 
$ns at 314.8723943163097 "$node_(116) setdest 96197 37865 3.0" 
$ns at 367.8542279896569 "$node_(116) setdest 35478 2086 4.0" 
$ns at 427.02233798419 "$node_(116) setdest 145817 43858 4.0" 
$ns at 460.4444135763874 "$node_(116) setdest 103593 10746 8.0" 
$ns at 555.5874620609453 "$node_(116) setdest 224550 64372 16.0" 
$ns at 730.9552358854457 "$node_(116) setdest 173037 33090 6.0" 
$ns at 792.3220999185404 "$node_(116) setdest 172951 61141 8.0" 
$ns at 828.573890690121 "$node_(116) setdest 42046 41868 7.0" 
$ns at 896.5787967176766 "$node_(116) setdest 27441 84770 17.0" 
$ns at 138.7446728109564 "$node_(117) setdest 59119 843 18.0" 
$ns at 320.64517412976954 "$node_(117) setdest 34054 7796 2.0" 
$ns at 357.4264611367716 "$node_(117) setdest 20287 17652 7.0" 
$ns at 397.14664887692186 "$node_(117) setdest 147413 40516 4.0" 
$ns at 465.85087785938845 "$node_(117) setdest 115282 5174 3.0" 
$ns at 518.5188671426896 "$node_(117) setdest 145886 33049 3.0" 
$ns at 558.7378502015539 "$node_(117) setdest 219272 3035 4.0" 
$ns at 606.5967547057762 "$node_(117) setdest 21355 55935 20.0" 
$ns at 680.5383441804261 "$node_(117) setdest 147959 13881 18.0" 
$ns at 858.5304852456798 "$node_(117) setdest 89125 22795 7.0" 
$ns at 162.95584429285688 "$node_(118) setdest 20029 21054 8.0" 
$ns at 205.37642625108157 "$node_(118) setdest 134005 24071 11.0" 
$ns at 322.5290310815972 "$node_(118) setdest 137483 44279 8.0" 
$ns at 389.1188379970886 "$node_(118) setdest 80866 55113 12.0" 
$ns at 440.94880295948417 "$node_(118) setdest 109966 57617 10.0" 
$ns at 570.1972623460892 "$node_(118) setdest 111037 34896 18.0" 
$ns at 655.7868741424647 "$node_(118) setdest 117316 63629 14.0" 
$ns at 806.9895437968048 "$node_(118) setdest 178162 57578 5.0" 
$ns at 882.3769744398655 "$node_(118) setdest 246269 26304 17.0" 
$ns at 134.39729619302003 "$node_(119) setdest 47442 8604 13.0" 
$ns at 275.83653728588934 "$node_(119) setdest 129382 33929 19.0" 
$ns at 342.31455617264965 "$node_(119) setdest 65227 22862 10.0" 
$ns at 393.21271136738187 "$node_(119) setdest 48700 35205 11.0" 
$ns at 456.8594806106388 "$node_(119) setdest 210486 6776 1.0" 
$ns at 496.4701387541525 "$node_(119) setdest 7378 28826 14.0" 
$ns at 532.504793795225 "$node_(119) setdest 68608 3996 1.0" 
$ns at 566.9188340914191 "$node_(119) setdest 220986 75062 15.0" 
$ns at 693.5462440354596 "$node_(119) setdest 97107 214 12.0" 
$ns at 829.979893743089 "$node_(119) setdest 27903 64115 1.0" 
$ns at 861.4598423501127 "$node_(119) setdest 143373 969 3.0" 
$ns at 148.1503454293532 "$node_(120) setdest 42553 2243 16.0" 
$ns at 183.89869689108843 "$node_(120) setdest 92162 50 19.0" 
$ns at 250.46642316999174 "$node_(120) setdest 71810 14374 14.0" 
$ns at 299.57420561666913 "$node_(120) setdest 46690 17925 11.0" 
$ns at 363.44235052282454 "$node_(120) setdest 5932 21528 5.0" 
$ns at 402.79775353380063 "$node_(120) setdest 87516 5990 18.0" 
$ns at 609.6394476508061 "$node_(120) setdest 30355 57953 12.0" 
$ns at 679.7071367177491 "$node_(120) setdest 198004 57148 8.0" 
$ns at 784.6383618279289 "$node_(120) setdest 47902 29293 11.0" 
$ns at 142.5922787746254 "$node_(121) setdest 10386 7751 8.0" 
$ns at 189.77841601508402 "$node_(121) setdest 108599 29047 17.0" 
$ns at 268.6792188626103 "$node_(121) setdest 9093 49594 3.0" 
$ns at 324.2758652494516 "$node_(121) setdest 61097 36770 3.0" 
$ns at 382.9705674530787 "$node_(121) setdest 9247 54974 6.0" 
$ns at 426.16146795201524 "$node_(121) setdest 114347 13012 9.0" 
$ns at 529.1889183446829 "$node_(121) setdest 45043 3316 1.0" 
$ns at 563.7648856394605 "$node_(121) setdest 26658 20818 8.0" 
$ns at 646.1905533069646 "$node_(121) setdest 39953 53236 1.0" 
$ns at 682.9303069520695 "$node_(121) setdest 238309 67593 5.0" 
$ns at 714.3220239569125 "$node_(121) setdest 171133 77811 12.0" 
$ns at 845.9474553213806 "$node_(121) setdest 119321 8151 13.0" 
$ns at 129.11546285717444 "$node_(122) setdest 38506 28714 19.0" 
$ns at 186.2608059158301 "$node_(122) setdest 112434 43789 2.0" 
$ns at 219.75850421541418 "$node_(122) setdest 118861 17509 1.0" 
$ns at 250.44563700973035 "$node_(122) setdest 27945 11667 10.0" 
$ns at 329.4103496389596 "$node_(122) setdest 81614 46099 12.0" 
$ns at 438.2360121510919 "$node_(122) setdest 57696 45163 3.0" 
$ns at 473.18883872644847 "$node_(122) setdest 25976 18330 19.0" 
$ns at 588.1503169886273 "$node_(122) setdest 147251 52479 10.0" 
$ns at 701.7668402766777 "$node_(122) setdest 207947 24712 12.0" 
$ns at 828.5911180386383 "$node_(122) setdest 154549 50989 5.0" 
$ns at 871.3580955216579 "$node_(122) setdest 172724 26912 2.0" 
$ns at 121.26907653239131 "$node_(123) setdest 71958 27035 18.0" 
$ns at 272.11452591240294 "$node_(123) setdest 49298 26396 10.0" 
$ns at 306.81465666075053 "$node_(123) setdest 100060 16294 8.0" 
$ns at 358.0712855224274 "$node_(123) setdest 75989 47886 6.0" 
$ns at 415.26380835429484 "$node_(123) setdest 177042 59384 19.0" 
$ns at 518.4953851903512 "$node_(123) setdest 194794 54404 1.0" 
$ns at 553.6162269302009 "$node_(123) setdest 74901 70406 1.0" 
$ns at 586.4808320178475 "$node_(123) setdest 41445 20250 17.0" 
$ns at 622.2561345409015 "$node_(123) setdest 51031 21094 8.0" 
$ns at 711.8864408671727 "$node_(123) setdest 186664 44912 8.0" 
$ns at 821.0969858793399 "$node_(123) setdest 166948 67222 12.0" 
$ns at 161.79640127605225 "$node_(124) setdest 62210 3687 2.0" 
$ns at 203.67993118262234 "$node_(124) setdest 48378 35968 8.0" 
$ns at 267.43930310211545 "$node_(124) setdest 65385 19096 4.0" 
$ns at 324.0357598344451 "$node_(124) setdest 60982 49753 11.0" 
$ns at 359.7573794980659 "$node_(124) setdest 59527 48119 2.0" 
$ns at 407.4881224404136 "$node_(124) setdest 45284 17325 14.0" 
$ns at 473.7709350737441 "$node_(124) setdest 107332 29184 13.0" 
$ns at 534.6417636597903 "$node_(124) setdest 132387 35464 13.0" 
$ns at 622.4589942972146 "$node_(124) setdest 177827 17619 1.0" 
$ns at 653.7194178723396 "$node_(124) setdest 164560 21666 10.0" 
$ns at 697.7175942892818 "$node_(124) setdest 197491 33227 15.0" 
$ns at 774.5414720193638 "$node_(124) setdest 23586 78492 2.0" 
$ns at 809.3223695993339 "$node_(124) setdest 79291 26558 1.0" 
$ns at 848.7327138405719 "$node_(124) setdest 71055 58268 5.0" 
$ns at 126.74923763784608 "$node_(125) setdest 69899 24585 6.0" 
$ns at 160.2922423329709 "$node_(125) setdest 125847 13703 3.0" 
$ns at 213.31905466849486 "$node_(125) setdest 81135 31586 6.0" 
$ns at 288.5905187364509 "$node_(125) setdest 119060 40504 14.0" 
$ns at 413.358029521238 "$node_(125) setdest 43557 17419 7.0" 
$ns at 464.5311899902563 "$node_(125) setdest 19025 48565 17.0" 
$ns at 647.6687817326551 "$node_(125) setdest 96761 23326 19.0" 
$ns at 865.232548642108 "$node_(125) setdest 183843 75640 18.0" 
$ns at 106.26410441497637 "$node_(126) setdest 88744 25991 10.0" 
$ns at 227.68137744361013 "$node_(126) setdest 129069 1338 6.0" 
$ns at 312.2547490225027 "$node_(126) setdest 19043 24280 6.0" 
$ns at 396.4638459811833 "$node_(126) setdest 26854 1923 6.0" 
$ns at 455.5918664316941 "$node_(126) setdest 68895 55112 1.0" 
$ns at 487.59304161294233 "$node_(126) setdest 102228 16829 3.0" 
$ns at 539.1578364394339 "$node_(126) setdest 83091 13842 18.0" 
$ns at 742.0377701710587 "$node_(126) setdest 90118 29744 17.0" 
$ns at 840.2707148734347 "$node_(126) setdest 145342 26129 13.0" 
$ns at 898.7090536343411 "$node_(126) setdest 139414 53847 12.0" 
$ns at 178.672599335743 "$node_(127) setdest 57296 43588 1.0" 
$ns at 213.57882622219765 "$node_(127) setdest 5639 26453 12.0" 
$ns at 302.1442335149295 "$node_(127) setdest 59164 16805 11.0" 
$ns at 434.4660256247882 "$node_(127) setdest 11934 37534 12.0" 
$ns at 557.8302339980726 "$node_(127) setdest 58537 63070 9.0" 
$ns at 670.7627243801605 "$node_(127) setdest 33823 65065 13.0" 
$ns at 724.0359486510243 "$node_(127) setdest 249428 57898 4.0" 
$ns at 759.0457891396564 "$node_(127) setdest 65913 7072 11.0" 
$ns at 804.3023920569298 "$node_(127) setdest 59143 47905 5.0" 
$ns at 851.3773093044173 "$node_(127) setdest 2635 63594 10.0" 
$ns at 884.9867618871966 "$node_(127) setdest 98419 45407 1.0" 
$ns at 188.37731085165296 "$node_(128) setdest 57754 42677 1.0" 
$ns at 226.83060139439235 "$node_(128) setdest 12906 18434 9.0" 
$ns at 308.11595839562284 "$node_(128) setdest 49983 6272 11.0" 
$ns at 362.8220433505766 "$node_(128) setdest 136151 40939 13.0" 
$ns at 421.0179137731068 "$node_(128) setdest 150082 51738 7.0" 
$ns at 481.3141730301551 "$node_(128) setdest 151034 69030 8.0" 
$ns at 524.5108202132228 "$node_(128) setdest 141244 22317 8.0" 
$ns at 580.5039116864182 "$node_(128) setdest 198683 72443 7.0" 
$ns at 679.4796141838721 "$node_(128) setdest 99493 53253 15.0" 
$ns at 777.0594438480573 "$node_(128) setdest 219691 70652 5.0" 
$ns at 850.1925927887169 "$node_(128) setdest 103820 10526 12.0" 
$ns at 136.63666901569172 "$node_(129) setdest 33944 27274 8.0" 
$ns at 172.1422246625125 "$node_(129) setdest 97324 10321 19.0" 
$ns at 271.80180099331903 "$node_(129) setdest 87201 2235 19.0" 
$ns at 370.6050525611423 "$node_(129) setdest 17524 55806 7.0" 
$ns at 411.23559025447724 "$node_(129) setdest 126871 48680 7.0" 
$ns at 489.38845548239084 "$node_(129) setdest 45940 57012 18.0" 
$ns at 697.7415120560532 "$node_(129) setdest 68141 19677 5.0" 
$ns at 771.7520701962836 "$node_(129) setdest 18048 39572 6.0" 
$ns at 828.6025787259395 "$node_(129) setdest 131310 63600 11.0" 
$ns at 878.6990839218387 "$node_(129) setdest 223900 81656 8.0" 
$ns at 170.8352730690782 "$node_(130) setdest 5218 8069 3.0" 
$ns at 202.6304270413425 "$node_(130) setdest 115438 11255 7.0" 
$ns at 302.4289121797559 "$node_(130) setdest 119673 38680 11.0" 
$ns at 355.5824084663584 "$node_(130) setdest 101664 19632 19.0" 
$ns at 423.3435109935396 "$node_(130) setdest 129344 47421 8.0" 
$ns at 475.82905643500493 "$node_(130) setdest 203421 43002 1.0" 
$ns at 509.4695363528418 "$node_(130) setdest 134340 13230 5.0" 
$ns at 564.0376122245225 "$node_(130) setdest 76064 63776 4.0" 
$ns at 631.2072407442067 "$node_(130) setdest 156658 36134 10.0" 
$ns at 671.238495716224 "$node_(130) setdest 240937 45502 20.0" 
$ns at 880.1029251598093 "$node_(130) setdest 36375 49824 9.0" 
$ns at 128.07143778071736 "$node_(131) setdest 80502 26108 5.0" 
$ns at 203.25751995706642 "$node_(131) setdest 37511 16875 7.0" 
$ns at 288.42841752845374 "$node_(131) setdest 64185 11037 13.0" 
$ns at 443.77284578117815 "$node_(131) setdest 46713 36893 1.0" 
$ns at 473.8959859921405 "$node_(131) setdest 98009 6574 9.0" 
$ns at 541.7714153217995 "$node_(131) setdest 54755 63053 10.0" 
$ns at 624.1556704396817 "$node_(131) setdest 19985 31634 10.0" 
$ns at 688.7434669409579 "$node_(131) setdest 166912 51426 10.0" 
$ns at 775.5804370484819 "$node_(131) setdest 105457 23646 13.0" 
$ns at 117.53324309186793 "$node_(132) setdest 16983 4520 5.0" 
$ns at 162.71497866916258 "$node_(132) setdest 80593 8102 2.0" 
$ns at 195.24141911897527 "$node_(132) setdest 119362 28615 16.0" 
$ns at 287.32006145801415 "$node_(132) setdest 24826 54368 6.0" 
$ns at 374.16855394525476 "$node_(132) setdest 108661 863 6.0" 
$ns at 427.6458422591838 "$node_(132) setdest 43339 62624 14.0" 
$ns at 502.1901221404677 "$node_(132) setdest 67811 12010 16.0" 
$ns at 559.6601662653565 "$node_(132) setdest 223562 60396 7.0" 
$ns at 654.6627845315646 "$node_(132) setdest 181718 67712 3.0" 
$ns at 692.4777071081944 "$node_(132) setdest 32234 63952 20.0" 
$ns at 872.7931897662289 "$node_(132) setdest 64519 68420 10.0" 
$ns at 201.44591906389874 "$node_(133) setdest 79673 38551 7.0" 
$ns at 272.18797591926887 "$node_(133) setdest 89274 44559 8.0" 
$ns at 378.29589017785275 "$node_(133) setdest 9124 28889 16.0" 
$ns at 466.5027416365349 "$node_(133) setdest 60478 66757 19.0" 
$ns at 624.028579919894 "$node_(133) setdest 185321 40590 11.0" 
$ns at 748.4571270011515 "$node_(133) setdest 144296 60427 3.0" 
$ns at 784.8947962547878 "$node_(133) setdest 229064 55744 3.0" 
$ns at 841.5016905205683 "$node_(133) setdest 191849 81412 14.0" 
$ns at 131.165087937828 "$node_(134) setdest 58574 5416 2.0" 
$ns at 174.9039069479607 "$node_(134) setdest 133380 22446 4.0" 
$ns at 236.89156439380906 "$node_(134) setdest 12288 7548 19.0" 
$ns at 401.7283144917675 "$node_(134) setdest 18850 10540 14.0" 
$ns at 444.94622784879834 "$node_(134) setdest 44818 41658 19.0" 
$ns at 478.96825637984307 "$node_(134) setdest 88980 7317 6.0" 
$ns at 511.66897183537833 "$node_(134) setdest 164279 53590 10.0" 
$ns at 589.0498068066914 "$node_(134) setdest 149195 9374 12.0" 
$ns at 650.1390089622244 "$node_(134) setdest 171741 28168 13.0" 
$ns at 728.9208564430539 "$node_(134) setdest 134522 14725 18.0" 
$ns at 868.5981508589288 "$node_(134) setdest 55592 88229 10.0" 
$ns at 102.78347133080631 "$node_(135) setdest 6744 23938 4.0" 
$ns at 137.5699425518855 "$node_(135) setdest 42677 4017 17.0" 
$ns at 243.80435663687263 "$node_(135) setdest 38953 36123 1.0" 
$ns at 280.1424257818799 "$node_(135) setdest 71638 52706 1.0" 
$ns at 312.9331269256663 "$node_(135) setdest 25768 20111 14.0" 
$ns at 478.3019803554565 "$node_(135) setdest 47404 56122 6.0" 
$ns at 522.482614934828 "$node_(135) setdest 60448 45642 4.0" 
$ns at 561.6864467541895 "$node_(135) setdest 76566 10341 14.0" 
$ns at 679.0789015765534 "$node_(135) setdest 206812 49724 2.0" 
$ns at 723.6688420954529 "$node_(135) setdest 213873 3271 2.0" 
$ns at 765.4476924050467 "$node_(135) setdest 53868 58943 8.0" 
$ns at 834.4046726820877 "$node_(135) setdest 236194 72066 13.0" 
$ns at 179.3601584935906 "$node_(136) setdest 43345 43016 6.0" 
$ns at 252.17843112150734 "$node_(136) setdest 146453 13526 18.0" 
$ns at 344.8782150158773 "$node_(136) setdest 106264 45829 17.0" 
$ns at 481.68928241003107 "$node_(136) setdest 122362 30054 2.0" 
$ns at 519.7621438283285 "$node_(136) setdest 54476 15494 13.0" 
$ns at 677.7706431870629 "$node_(136) setdest 89364 24183 16.0" 
$ns at 763.8005363669388 "$node_(136) setdest 138287 78521 14.0" 
$ns at 845.8705484187637 "$node_(136) setdest 184414 33007 1.0" 
$ns at 880.5971747449125 "$node_(136) setdest 168978 86096 17.0" 
$ns at 203.05341830890086 "$node_(137) setdest 9655 8769 6.0" 
$ns at 256.65138805702026 "$node_(137) setdest 13073 48643 19.0" 
$ns at 330.27560377254224 "$node_(137) setdest 98289 15291 18.0" 
$ns at 435.7913766244423 "$node_(137) setdest 149355 624 8.0" 
$ns at 536.6805622272 "$node_(137) setdest 170387 40682 9.0" 
$ns at 600.4057504615823 "$node_(137) setdest 67902 69590 19.0" 
$ns at 806.2092167727949 "$node_(137) setdest 193776 80926 9.0" 
$ns at 152.3238021844955 "$node_(138) setdest 130282 39315 13.0" 
$ns at 291.7941157814647 "$node_(138) setdest 60330 54299 17.0" 
$ns at 411.0562196204747 "$node_(138) setdest 153582 13932 19.0" 
$ns at 546.7457345051283 "$node_(138) setdest 6153 59763 2.0" 
$ns at 577.5639868022944 "$node_(138) setdest 206391 6822 9.0" 
$ns at 627.4576400023014 "$node_(138) setdest 9494 22603 10.0" 
$ns at 728.3304295392333 "$node_(138) setdest 168854 69250 9.0" 
$ns at 760.311649251153 "$node_(138) setdest 153883 21943 14.0" 
$ns at 891.0265751467557 "$node_(138) setdest 138818 58845 8.0" 
$ns at 156.40228259931104 "$node_(139) setdest 100558 31839 8.0" 
$ns at 241.37452326152632 "$node_(139) setdest 105893 6087 10.0" 
$ns at 299.36838569007773 "$node_(139) setdest 56200 53787 18.0" 
$ns at 396.8116030439319 "$node_(139) setdest 49608 25837 7.0" 
$ns at 481.46948352758045 "$node_(139) setdest 40290 41954 13.0" 
$ns at 603.3982184434992 "$node_(139) setdest 145159 57624 15.0" 
$ns at 725.5626383310341 "$node_(139) setdest 56929 11443 4.0" 
$ns at 794.7618195658515 "$node_(139) setdest 32658 70395 16.0" 
$ns at 128.73335090197065 "$node_(140) setdest 74424 16296 16.0" 
$ns at 215.19543221645156 "$node_(140) setdest 119781 11652 16.0" 
$ns at 364.0008247686485 "$node_(140) setdest 103610 30221 17.0" 
$ns at 522.5739679364494 "$node_(140) setdest 199707 35534 16.0" 
$ns at 668.1658281646273 "$node_(140) setdest 138979 47267 4.0" 
$ns at 702.9305524383104 "$node_(140) setdest 114955 64391 8.0" 
$ns at 777.6493811654806 "$node_(140) setdest 18218 81824 16.0" 
$ns at 823.6776721061074 "$node_(140) setdest 216130 31338 15.0" 
$ns at 131.16529493312385 "$node_(141) setdest 64409 9427 15.0" 
$ns at 193.18554445020442 "$node_(141) setdest 54262 23398 13.0" 
$ns at 271.9133499845741 "$node_(141) setdest 126541 23648 16.0" 
$ns at 343.1313950944863 "$node_(141) setdest 70780 9058 18.0" 
$ns at 429.39262440217124 "$node_(141) setdest 73295 29865 10.0" 
$ns at 482.04965897845926 "$node_(141) setdest 70132 5772 19.0" 
$ns at 682.687806125972 "$node_(141) setdest 19418 94 20.0" 
$ns at 859.8183210379854 "$node_(141) setdest 260654 13736 9.0" 
$ns at 211.56585213817635 "$node_(142) setdest 69789 8438 15.0" 
$ns at 318.98612867485525 "$node_(142) setdest 98347 8818 5.0" 
$ns at 395.37018563384527 "$node_(142) setdest 17685 29191 13.0" 
$ns at 435.71129592222127 "$node_(142) setdest 97361 53531 11.0" 
$ns at 493.62657133402985 "$node_(142) setdest 6739 44364 16.0" 
$ns at 551.1209783599188 "$node_(142) setdest 148830 53472 15.0" 
$ns at 695.9105080597751 "$node_(142) setdest 195313 3015 6.0" 
$ns at 731.7891695309204 "$node_(142) setdest 91249 9141 1.0" 
$ns at 761.9860327014438 "$node_(142) setdest 252837 19934 2.0" 
$ns at 804.517062197849 "$node_(142) setdest 94843 52455 18.0" 
$ns at 128.46340190486274 "$node_(143) setdest 46751 4622 9.0" 
$ns at 214.1804556236338 "$node_(143) setdest 71690 39618 15.0" 
$ns at 333.61112058236876 "$node_(143) setdest 26638 18198 12.0" 
$ns at 383.12815674296354 "$node_(143) setdest 43644 13199 17.0" 
$ns at 566.7827071422619 "$node_(143) setdest 42194 14715 15.0" 
$ns at 648.241001811471 "$node_(143) setdest 137174 50674 7.0" 
$ns at 745.6375387650806 "$node_(143) setdest 138180 33894 18.0" 
$ns at 867.6135256616818 "$node_(143) setdest 24298 41930 8.0" 
$ns at 129.1282118764528 "$node_(144) setdest 53656 9862 2.0" 
$ns at 167.46819730414904 "$node_(144) setdest 108461 27382 13.0" 
$ns at 243.90164995762134 "$node_(144) setdest 126976 33177 16.0" 
$ns at 333.98397195847406 "$node_(144) setdest 25112 32716 4.0" 
$ns at 368.1159912878055 "$node_(144) setdest 118649 59984 20.0" 
$ns at 411.29934436964595 "$node_(144) setdest 133472 34848 14.0" 
$ns at 447.3524428913335 "$node_(144) setdest 59258 23698 5.0" 
$ns at 524.5219849704995 "$node_(144) setdest 101920 66826 12.0" 
$ns at 556.9355196053464 "$node_(144) setdest 115359 9672 17.0" 
$ns at 679.1111683693217 "$node_(144) setdest 249163 11801 20.0" 
$ns at 178.87947411490327 "$node_(145) setdest 49010 29709 12.0" 
$ns at 302.6637810861038 "$node_(145) setdest 74001 30299 13.0" 
$ns at 385.56769272284225 "$node_(145) setdest 105892 16704 3.0" 
$ns at 432.215492870721 "$node_(145) setdest 88554 39832 7.0" 
$ns at 467.7235053892389 "$node_(145) setdest 155459 65831 12.0" 
$ns at 509.82419489845876 "$node_(145) setdest 101320 17728 4.0" 
$ns at 555.9608861328834 "$node_(145) setdest 183861 60176 18.0" 
$ns at 592.8325465204942 "$node_(145) setdest 28835 20768 2.0" 
$ns at 635.6271161766226 "$node_(145) setdest 168788 7545 1.0" 
$ns at 666.4011940970856 "$node_(145) setdest 199397 53921 14.0" 
$ns at 821.1857895868009 "$node_(145) setdest 131379 28726 5.0" 
$ns at 872.3791892874973 "$node_(145) setdest 108487 16303 16.0" 
$ns at 110.15051094492574 "$node_(146) setdest 22615 9008 7.0" 
$ns at 143.27227771482217 "$node_(146) setdest 15708 17434 2.0" 
$ns at 176.4465868847959 "$node_(146) setdest 40655 17113 11.0" 
$ns at 260.6811088356575 "$node_(146) setdest 81330 6812 8.0" 
$ns at 295.71931224275136 "$node_(146) setdest 30317 7510 15.0" 
$ns at 415.81161861329247 "$node_(146) setdest 109950 14453 16.0" 
$ns at 551.012283073806 "$node_(146) setdest 111167 10019 20.0" 
$ns at 683.186978389381 "$node_(146) setdest 72014 20934 7.0" 
$ns at 728.6647890955053 "$node_(146) setdest 34122 28645 11.0" 
$ns at 816.8691551348418 "$node_(146) setdest 79803 20598 4.0" 
$ns at 858.0418696206888 "$node_(146) setdest 77052 43281 4.0" 
$ns at 112.02412475903503 "$node_(147) setdest 90026 2796 8.0" 
$ns at 159.71839317827477 "$node_(147) setdest 89007 11582 15.0" 
$ns at 215.8092284433178 "$node_(147) setdest 83695 3347 7.0" 
$ns at 309.5127119155797 "$node_(147) setdest 104337 16177 15.0" 
$ns at 340.78316104860437 "$node_(147) setdest 77638 30976 3.0" 
$ns at 386.48764722378786 "$node_(147) setdest 120831 27382 5.0" 
$ns at 434.2252994724153 "$node_(147) setdest 91932 25583 11.0" 
$ns at 487.7460620959599 "$node_(147) setdest 189451 35853 4.0" 
$ns at 523.8679812536208 "$node_(147) setdest 164944 16535 8.0" 
$ns at 593.4648847630269 "$node_(147) setdest 196068 25952 20.0" 
$ns at 729.166844695656 "$node_(147) setdest 235169 53627 3.0" 
$ns at 774.8574176475902 "$node_(147) setdest 60329 88997 18.0" 
$ns at 886.1610739521072 "$node_(147) setdest 64258 37315 14.0" 
$ns at 160.8497518084866 "$node_(148) setdest 70557 44563 8.0" 
$ns at 215.02860468592573 "$node_(148) setdest 40647 41341 18.0" 
$ns at 274.1058276394761 "$node_(148) setdest 70209 23237 17.0" 
$ns at 351.8313439354127 "$node_(148) setdest 16998 45828 8.0" 
$ns at 444.64091576904974 "$node_(148) setdest 48463 36561 2.0" 
$ns at 482.2950760115997 "$node_(148) setdest 182466 37304 19.0" 
$ns at 688.7301853273033 "$node_(148) setdest 181590 33705 12.0" 
$ns at 741.5049986760624 "$node_(148) setdest 167673 80639 9.0" 
$ns at 814.656216896398 "$node_(148) setdest 265154 47043 13.0" 
$ns at 870.9279743622508 "$node_(148) setdest 263519 42838 1.0" 
$ns at 111.58303367572034 "$node_(149) setdest 67782 11897 3.0" 
$ns at 161.00057866315598 "$node_(149) setdest 6508 15951 1.0" 
$ns at 195.37537225379086 "$node_(149) setdest 67317 32662 20.0" 
$ns at 378.23127733251476 "$node_(149) setdest 61498 21394 10.0" 
$ns at 424.5104779327403 "$node_(149) setdest 19393 51644 11.0" 
$ns at 493.60279252769266 "$node_(149) setdest 144190 70564 11.0" 
$ns at 608.9027103363438 "$node_(149) setdest 5433 73557 8.0" 
$ns at 670.652343686529 "$node_(149) setdest 159449 22320 4.0" 
$ns at 729.6401106639698 "$node_(149) setdest 186339 73416 14.0" 
$ns at 814.7435418721833 "$node_(149) setdest 8243 36688 7.0" 
$ns at 849.4686435950546 "$node_(149) setdest 35611 11079 5.0" 
$ns at 891.3330412913632 "$node_(149) setdest 114487 45471 16.0" 
$ns at 108.59090751878182 "$node_(150) setdest 53547 20584 9.0" 
$ns at 209.35811717048705 "$node_(150) setdest 133762 13892 14.0" 
$ns at 240.71046006925872 "$node_(150) setdest 10761 38836 3.0" 
$ns at 281.25782300564396 "$node_(150) setdest 124971 45320 5.0" 
$ns at 356.62458128826654 "$node_(150) setdest 156834 26503 14.0" 
$ns at 495.295363345739 "$node_(150) setdest 40040 53305 4.0" 
$ns at 552.926118815405 "$node_(150) setdest 165619 13780 9.0" 
$ns at 634.2248163986068 "$node_(150) setdest 114882 46415 4.0" 
$ns at 697.9212787092108 "$node_(150) setdest 196282 31376 17.0" 
$ns at 755.66921418354 "$node_(150) setdest 261508 29683 1.0" 
$ns at 791.5101953972338 "$node_(150) setdest 68516 56175 14.0" 
$ns at 867.0691280081567 "$node_(150) setdest 122269 41324 19.0" 
$ns at 177.27877550455253 "$node_(151) setdest 16865 6530 8.0" 
$ns at 275.546734693841 "$node_(151) setdest 15688 15821 8.0" 
$ns at 382.0125243548922 "$node_(151) setdest 46205 36773 16.0" 
$ns at 521.1730508878189 "$node_(151) setdest 39457 53462 2.0" 
$ns at 553.8152058455099 "$node_(151) setdest 107418 16455 20.0" 
$ns at 717.3785596590385 "$node_(151) setdest 5565 21028 14.0" 
$ns at 796.5215733320035 "$node_(151) setdest 202768 46079 8.0" 
$ns at 882.1551541931635 "$node_(151) setdest 205485 28196 12.0" 
$ns at 102.84927040111747 "$node_(152) setdest 94815 11949 3.0" 
$ns at 139.16018785957618 "$node_(152) setdest 15504 27969 8.0" 
$ns at 207.4068750383636 "$node_(152) setdest 106456 16862 19.0" 
$ns at 422.9112041917813 "$node_(152) setdest 41448 4791 3.0" 
$ns at 473.9364122039202 "$node_(152) setdest 155859 26086 19.0" 
$ns at 520.4530264217533 "$node_(152) setdest 49562 22137 9.0" 
$ns at 585.657989454861 "$node_(152) setdest 17457 33531 6.0" 
$ns at 650.7809376525418 "$node_(152) setdest 169888 8101 19.0" 
$ns at 783.6986065580656 "$node_(152) setdest 120475 14656 1.0" 
$ns at 815.287201809186 "$node_(152) setdest 207239 15295 6.0" 
$ns at 881.8460172635519 "$node_(152) setdest 185456 5700 14.0" 
$ns at 179.24180860534761 "$node_(153) setdest 106965 32856 19.0" 
$ns at 343.5697632704659 "$node_(153) setdest 136948 23755 15.0" 
$ns at 474.705316049049 "$node_(153) setdest 4193 55812 8.0" 
$ns at 516.3622992942496 "$node_(153) setdest 122268 45166 13.0" 
$ns at 578.6662828556107 "$node_(153) setdest 182591 35736 14.0" 
$ns at 643.5793265584065 "$node_(153) setdest 108708 65397 10.0" 
$ns at 768.6054658091855 "$node_(153) setdest 149188 18041 10.0" 
$ns at 841.1127270301511 "$node_(153) setdest 6918 58819 16.0" 
$ns at 218.43467099346725 "$node_(154) setdest 88372 37321 18.0" 
$ns at 346.3384864908061 "$node_(154) setdest 163468 10057 17.0" 
$ns at 390.92267332514155 "$node_(154) setdest 151966 62221 11.0" 
$ns at 445.64877696393836 "$node_(154) setdest 187011 25304 20.0" 
$ns at 551.5811153738377 "$node_(154) setdest 110554 30577 12.0" 
$ns at 691.1392363714224 "$node_(154) setdest 250432 61252 6.0" 
$ns at 725.4085519923733 "$node_(154) setdest 68605 63351 4.0" 
$ns at 780.8723182210299 "$node_(154) setdest 264865 47851 19.0" 
$ns at 100.28091557683537 "$node_(155) setdest 14046 3921 12.0" 
$ns at 225.99925870524436 "$node_(155) setdest 48934 3145 5.0" 
$ns at 263.20695056805414 "$node_(155) setdest 116143 2468 15.0" 
$ns at 357.96616220782806 "$node_(155) setdest 153181 32640 19.0" 
$ns at 510.02595843843415 "$node_(155) setdest 197877 37117 13.0" 
$ns at 584.8187376155203 "$node_(155) setdest 196687 31181 12.0" 
$ns at 712.3700174755959 "$node_(155) setdest 246339 41452 17.0" 
$ns at 767.9522833368286 "$node_(155) setdest 213485 73454 5.0" 
$ns at 816.9811166378158 "$node_(155) setdest 115811 74816 8.0" 
$ns at 139.2074906358715 "$node_(156) setdest 59859 23137 6.0" 
$ns at 212.9901390285157 "$node_(156) setdest 32883 18088 16.0" 
$ns at 332.9363889159013 "$node_(156) setdest 34928 15447 13.0" 
$ns at 431.0294114190188 "$node_(156) setdest 176941 7865 15.0" 
$ns at 569.6110812895604 "$node_(156) setdest 91972 59781 13.0" 
$ns at 612.0644880866578 "$node_(156) setdest 51686 52647 15.0" 
$ns at 768.7274685013155 "$node_(156) setdest 250947 20617 11.0" 
$ns at 803.7917621463916 "$node_(156) setdest 179365 35860 14.0" 
$ns at 842.0703485612594 "$node_(156) setdest 222850 16726 19.0" 
$ns at 158.2774876327756 "$node_(157) setdest 64412 39445 18.0" 
$ns at 351.7315735149376 "$node_(157) setdest 124287 29756 13.0" 
$ns at 451.6123220704626 "$node_(157) setdest 73574 37069 17.0" 
$ns at 529.2202426342064 "$node_(157) setdest 184069 31884 8.0" 
$ns at 568.0210421871953 "$node_(157) setdest 231370 16237 1.0" 
$ns at 605.9939343027273 "$node_(157) setdest 14541 69273 16.0" 
$ns at 672.3277874211819 "$node_(157) setdest 118354 51613 9.0" 
$ns at 720.6120212574614 "$node_(157) setdest 44824 78591 19.0" 
$ns at 759.7201719696715 "$node_(157) setdest 257806 57851 16.0" 
$ns at 839.3646414215699 "$node_(157) setdest 130025 31750 16.0" 
$ns at 173.70967772937598 "$node_(158) setdest 48578 2460 17.0" 
$ns at 252.31081003901954 "$node_(158) setdest 51423 38724 16.0" 
$ns at 285.3546282942507 "$node_(158) setdest 53908 13391 3.0" 
$ns at 318.4655005492451 "$node_(158) setdest 99206 25530 1.0" 
$ns at 356.45232197207923 "$node_(158) setdest 72582 14837 10.0" 
$ns at 405.69984880419554 "$node_(158) setdest 15006 5367 8.0" 
$ns at 453.41242368754695 "$node_(158) setdest 110571 27713 8.0" 
$ns at 492.7127652272023 "$node_(158) setdest 18731 13213 15.0" 
$ns at 652.9568131277138 "$node_(158) setdest 172962 10748 11.0" 
$ns at 702.5208732996491 "$node_(158) setdest 148096 59665 20.0" 
$ns at 138.31733385747435 "$node_(159) setdest 49486 22298 16.0" 
$ns at 292.0088988622582 "$node_(159) setdest 75899 27948 12.0" 
$ns at 339.6947893718137 "$node_(159) setdest 118666 34737 10.0" 
$ns at 437.8242480012419 "$node_(159) setdest 56358 51189 13.0" 
$ns at 520.3194080533691 "$node_(159) setdest 205505 24713 19.0" 
$ns at 735.173831653781 "$node_(159) setdest 239594 39796 13.0" 
$ns at 893.9657801089731 "$node_(159) setdest 157370 64212 15.0" 
$ns at 211.02535018267548 "$node_(160) setdest 37825 37841 20.0" 
$ns at 362.7561644331363 "$node_(160) setdest 35929 39529 16.0" 
$ns at 465.34909660465894 "$node_(160) setdest 9089 44066 1.0" 
$ns at 497.43112965665927 "$node_(160) setdest 187646 54163 13.0" 
$ns at 563.4612999222139 "$node_(160) setdest 194939 23887 2.0" 
$ns at 598.5180148309693 "$node_(160) setdest 162829 27137 11.0" 
$ns at 664.9526430882609 "$node_(160) setdest 171241 21819 16.0" 
$ns at 732.0033315014718 "$node_(160) setdest 248065 34262 11.0" 
$ns at 870.830609465781 "$node_(160) setdest 265460 41335 13.0" 
$ns at 148.8375800692589 "$node_(161) setdest 64257 13907 4.0" 
$ns at 208.76802924596012 "$node_(161) setdest 127365 25629 7.0" 
$ns at 248.8650721232216 "$node_(161) setdest 107089 33408 3.0" 
$ns at 296.76622222748193 "$node_(161) setdest 18863 19240 7.0" 
$ns at 388.9524131735343 "$node_(161) setdest 168996 26190 18.0" 
$ns at 541.7434885861155 "$node_(161) setdest 159625 66366 16.0" 
$ns at 648.2987590005687 "$node_(161) setdest 228660 32765 17.0" 
$ns at 755.8273978119336 "$node_(161) setdest 170481 87616 18.0" 
$ns at 797.7215013339301 "$node_(161) setdest 103389 3550 8.0" 
$ns at 889.8561985810622 "$node_(161) setdest 213881 32803 9.0" 
$ns at 149.27797924815502 "$node_(162) setdest 45108 8512 3.0" 
$ns at 203.5032750535894 "$node_(162) setdest 49284 27481 16.0" 
$ns at 296.92378025411676 "$node_(162) setdest 101616 23297 8.0" 
$ns at 327.1491067879645 "$node_(162) setdest 129658 29593 1.0" 
$ns at 365.9179270817566 "$node_(162) setdest 73116 54788 4.0" 
$ns at 415.24373673931643 "$node_(162) setdest 132848 38310 5.0" 
$ns at 448.7139718932884 "$node_(162) setdest 70795 37916 4.0" 
$ns at 491.37022447020433 "$node_(162) setdest 176374 61078 10.0" 
$ns at 620.7229100869043 "$node_(162) setdest 144809 510 20.0" 
$ns at 771.7124789689623 "$node_(162) setdest 109655 86908 6.0" 
$ns at 845.3125929551197 "$node_(162) setdest 10070 42613 18.0" 
$ns at 894.5322786590582 "$node_(162) setdest 189303 52443 16.0" 
$ns at 169.47525481700438 "$node_(163) setdest 40083 35722 19.0" 
$ns at 347.75877594078554 "$node_(163) setdest 132566 10333 4.0" 
$ns at 393.0138479198053 "$node_(163) setdest 121340 116 9.0" 
$ns at 451.980484831096 "$node_(163) setdest 62873 46520 2.0" 
$ns at 488.0695409344025 "$node_(163) setdest 170369 59104 14.0" 
$ns at 613.5970347554415 "$node_(163) setdest 57694 39395 9.0" 
$ns at 687.1172867298183 "$node_(163) setdest 133440 8938 1.0" 
$ns at 725.865294829102 "$node_(163) setdest 51977 80559 4.0" 
$ns at 793.9237409427874 "$node_(163) setdest 250006 73495 2.0" 
$ns at 830.5576710471483 "$node_(163) setdest 152872 134 9.0" 
$ns at 885.6897301487785 "$node_(163) setdest 118459 65733 7.0" 
$ns at 133.64689137434135 "$node_(164) setdest 20782 1320 18.0" 
$ns at 167.13769824376237 "$node_(164) setdest 5199 8027 3.0" 
$ns at 201.72606114563408 "$node_(164) setdest 27967 22257 11.0" 
$ns at 235.19553234677588 "$node_(164) setdest 18866 30420 9.0" 
$ns at 266.47709404912814 "$node_(164) setdest 52014 10535 14.0" 
$ns at 349.42928961435376 "$node_(164) setdest 83635 44075 6.0" 
$ns at 404.9367867472348 "$node_(164) setdest 777 39545 1.0" 
$ns at 438.2118650825205 "$node_(164) setdest 110251 16885 2.0" 
$ns at 477.62704963278645 "$node_(164) setdest 88841 31667 3.0" 
$ns at 512.6452074190074 "$node_(164) setdest 88286 10240 5.0" 
$ns at 562.5692013911538 "$node_(164) setdest 147923 31363 14.0" 
$ns at 687.0268122497218 "$node_(164) setdest 179825 4540 12.0" 
$ns at 740.2569284940656 "$node_(164) setdest 28846 70309 7.0" 
$ns at 786.0158576754711 "$node_(164) setdest 6056 88696 13.0" 
$ns at 823.0801226538277 "$node_(164) setdest 160213 70386 8.0" 
$ns at 280.3497826605397 "$node_(165) setdest 92896 53155 12.0" 
$ns at 416.1496717828281 "$node_(165) setdest 134203 51760 1.0" 
$ns at 448.70261348560825 "$node_(165) setdest 58063 30032 19.0" 
$ns at 490.97291604578766 "$node_(165) setdest 44194 37658 5.0" 
$ns at 531.2951285345065 "$node_(165) setdest 210118 7367 6.0" 
$ns at 609.4737512273655 "$node_(165) setdest 170335 7338 16.0" 
$ns at 713.0038634649607 "$node_(165) setdest 212934 73447 16.0" 
$ns at 895.0695981724025 "$node_(165) setdest 257462 55940 4.0" 
$ns at 139.36369510672353 "$node_(166) setdest 25471 23738 6.0" 
$ns at 208.7414020807621 "$node_(166) setdest 3856 8803 16.0" 
$ns at 312.26612413106733 "$node_(166) setdest 68654 11941 12.0" 
$ns at 455.84948965013047 "$node_(166) setdest 121060 36082 9.0" 
$ns at 573.0001676602622 "$node_(166) setdest 48528 62722 17.0" 
$ns at 750.1933677307112 "$node_(166) setdest 61740 24458 18.0" 
$ns at 124.37548187226604 "$node_(167) setdest 29055 7434 18.0" 
$ns at 319.39167578481135 "$node_(167) setdest 128450 35326 2.0" 
$ns at 351.1295721270333 "$node_(167) setdest 87150 11700 17.0" 
$ns at 386.86003708886216 "$node_(167) setdest 137591 10458 15.0" 
$ns at 442.52803959417605 "$node_(167) setdest 115000 36217 10.0" 
$ns at 521.3682588951654 "$node_(167) setdest 169146 11920 3.0" 
$ns at 554.9225862999173 "$node_(167) setdest 26552 55270 14.0" 
$ns at 696.7981969020468 "$node_(167) setdest 128245 28648 13.0" 
$ns at 764.3262950799709 "$node_(167) setdest 8790 9197 7.0" 
$ns at 810.6182119317991 "$node_(167) setdest 53342 71758 10.0" 
$ns at 847.4711220850158 "$node_(167) setdest 93142 54172 11.0" 
$ns at 110.18058724765362 "$node_(168) setdest 47210 17198 12.0" 
$ns at 205.34744843044527 "$node_(168) setdest 27355 40369 11.0" 
$ns at 281.8129196899571 "$node_(168) setdest 106625 51939 18.0" 
$ns at 342.0534369560874 "$node_(168) setdest 47696 31633 11.0" 
$ns at 386.02396008903884 "$node_(168) setdest 85165 31427 5.0" 
$ns at 436.20754318436934 "$node_(168) setdest 124164 58511 5.0" 
$ns at 499.3181894908596 "$node_(168) setdest 56378 64162 13.0" 
$ns at 609.8305447896505 "$node_(168) setdest 1106 27705 18.0" 
$ns at 786.6017186935172 "$node_(168) setdest 37891 71943 5.0" 
$ns at 844.7493717285662 "$node_(168) setdest 19316 73840 6.0" 
$ns at 204.06879343633113 "$node_(169) setdest 123609 8984 1.0" 
$ns at 236.8958891657336 "$node_(169) setdest 70862 31825 17.0" 
$ns at 307.60903736645196 "$node_(169) setdest 27475 52198 10.0" 
$ns at 414.3033061422264 "$node_(169) setdest 188888 31536 18.0" 
$ns at 554.0505724157929 "$node_(169) setdest 134840 51710 9.0" 
$ns at 664.6673066194587 "$node_(169) setdest 210379 1749 11.0" 
$ns at 761.1122284105775 "$node_(169) setdest 117673 43938 16.0" 
$ns at 825.234137150868 "$node_(169) setdest 74631 52249 8.0" 
$ns at 881.8033660142808 "$node_(169) setdest 138697 87513 5.0" 
$ns at 100.56934753452553 "$node_(170) setdest 16888 25649 17.0" 
$ns at 257.73346906799117 "$node_(170) setdest 107995 23584 8.0" 
$ns at 315.69660070423976 "$node_(170) setdest 28563 20693 14.0" 
$ns at 414.0366692927936 "$node_(170) setdest 142445 44068 4.0" 
$ns at 459.68035566375295 "$node_(170) setdest 57347 7522 1.0" 
$ns at 495.1354737566584 "$node_(170) setdest 72320 65164 9.0" 
$ns at 590.6534313699391 "$node_(170) setdest 13796 53830 8.0" 
$ns at 685.5520719477025 "$node_(170) setdest 215473 77480 10.0" 
$ns at 724.3962983913847 "$node_(170) setdest 143167 53182 14.0" 
$ns at 790.6106941989704 "$node_(170) setdest 184113 18704 19.0" 
$ns at 873.2226446703992 "$node_(170) setdest 146440 60441 2.0" 
$ns at 104.9934489282562 "$node_(171) setdest 46726 3496 5.0" 
$ns at 182.83251860403772 "$node_(171) setdest 5758 16311 1.0" 
$ns at 219.8599821483789 "$node_(171) setdest 117320 2357 9.0" 
$ns at 327.39257468904077 "$node_(171) setdest 141774 24139 7.0" 
$ns at 427.2804643286306 "$node_(171) setdest 10791 4580 11.0" 
$ns at 552.3047207973162 "$node_(171) setdest 158116 49854 1.0" 
$ns at 584.1860080764407 "$node_(171) setdest 201815 66083 8.0" 
$ns at 624.7790080022086 "$node_(171) setdest 104180 22604 18.0" 
$ns at 706.7010131054321 "$node_(171) setdest 224037 63348 3.0" 
$ns at 748.6378142529387 "$node_(171) setdest 74115 72144 13.0" 
$ns at 895.2371666091778 "$node_(171) setdest 228536 39872 3.0" 
$ns at 248.1454820543009 "$node_(172) setdest 36932 36921 6.0" 
$ns at 323.4556745004096 "$node_(172) setdest 97427 986 14.0" 
$ns at 469.4883661130067 "$node_(172) setdest 139887 22576 1.0" 
$ns at 502.78261223336267 "$node_(172) setdest 106927 17697 18.0" 
$ns at 543.0526544003126 "$node_(172) setdest 116883 45032 9.0" 
$ns at 589.4071999755926 "$node_(172) setdest 185305 45204 7.0" 
$ns at 666.6416726720031 "$node_(172) setdest 80998 63710 13.0" 
$ns at 709.2026697056867 "$node_(172) setdest 88001 70578 5.0" 
$ns at 751.6319293484297 "$node_(172) setdest 158777 38863 11.0" 
$ns at 854.5549952705996 "$node_(172) setdest 1102 45584 6.0" 
$ns at 886.1624579974737 "$node_(172) setdest 114707 18243 2.0" 
$ns at 112.47501707331497 "$node_(173) setdest 53025 21627 7.0" 
$ns at 149.3532310667178 "$node_(173) setdest 65705 3001 19.0" 
$ns at 244.9411929626931 "$node_(173) setdest 26075 18735 13.0" 
$ns at 377.02109733672273 "$node_(173) setdest 112197 18329 13.0" 
$ns at 441.14656485540036 "$node_(173) setdest 60167 63163 6.0" 
$ns at 517.1656463805289 "$node_(173) setdest 39806 27912 18.0" 
$ns at 725.6147449201262 "$node_(173) setdest 143206 26479 8.0" 
$ns at 792.3443419330907 "$node_(173) setdest 91414 76240 14.0" 
$ns at 173.75905192965473 "$node_(174) setdest 111013 13175 17.0" 
$ns at 320.5349191052602 "$node_(174) setdest 140635 6364 15.0" 
$ns at 419.940431223108 "$node_(174) setdest 157022 19953 8.0" 
$ns at 502.2743397651509 "$node_(174) setdest 158201 47699 13.0" 
$ns at 611.3993602178357 "$node_(174) setdest 71303 8579 2.0" 
$ns at 655.6233870635181 "$node_(174) setdest 218290 30555 6.0" 
$ns at 720.8837442929123 "$node_(174) setdest 142553 51052 1.0" 
$ns at 755.0695675155627 "$node_(174) setdest 182686 11802 16.0" 
$ns at 883.7631730390083 "$node_(174) setdest 195017 31522 2.0" 
$ns at 215.1778982033112 "$node_(175) setdest 74653 28577 4.0" 
$ns at 266.15138746439334 "$node_(175) setdest 30811 23714 11.0" 
$ns at 367.5741521716784 "$node_(175) setdest 3788 32890 10.0" 
$ns at 457.4505156350493 "$node_(175) setdest 111481 14497 12.0" 
$ns at 581.0231774969429 "$node_(175) setdest 161899 60516 6.0" 
$ns at 659.1148072279107 "$node_(175) setdest 164640 30123 11.0" 
$ns at 761.7818154388376 "$node_(175) setdest 48314 80669 4.0" 
$ns at 807.0060405646453 "$node_(175) setdest 67525 17564 10.0" 
$ns at 875.6646482222201 "$node_(175) setdest 261054 46363 19.0" 
$ns at 279.8958551856006 "$node_(176) setdest 116545 47548 16.0" 
$ns at 344.56303533943856 "$node_(176) setdest 137206 43513 16.0" 
$ns at 421.4621174397213 "$node_(176) setdest 26776 18665 5.0" 
$ns at 476.2483913854891 "$node_(176) setdest 150368 69740 17.0" 
$ns at 543.514952048821 "$node_(176) setdest 187891 41757 19.0" 
$ns at 731.348734183722 "$node_(176) setdest 11268 61417 15.0" 
$ns at 801.1400131768324 "$node_(176) setdest 197220 5059 2.0" 
$ns at 841.09453858444 "$node_(176) setdest 222377 42104 8.0" 
$ns at 120.13831621382413 "$node_(177) setdest 55118 10912 7.0" 
$ns at 201.53681077736798 "$node_(177) setdest 38791 11298 7.0" 
$ns at 280.50702756740947 "$node_(177) setdest 126638 26200 11.0" 
$ns at 341.1914206525034 "$node_(177) setdest 104177 24398 11.0" 
$ns at 479.92534772990456 "$node_(177) setdest 202654 25174 1.0" 
$ns at 510.0987574905138 "$node_(177) setdest 94552 24742 18.0" 
$ns at 701.2994389411333 "$node_(177) setdest 69120 52904 8.0" 
$ns at 795.0216415672728 "$node_(177) setdest 249712 231 3.0" 
$ns at 852.28016466312 "$node_(177) setdest 171817 56810 12.0" 
$ns at 120.88459542398662 "$node_(178) setdest 78605 1135 17.0" 
$ns at 243.23161868667532 "$node_(178) setdest 85568 44248 18.0" 
$ns at 302.0939750922781 "$node_(178) setdest 10503 27341 6.0" 
$ns at 391.0378333126037 "$node_(178) setdest 99310 34059 5.0" 
$ns at 466.1714435813809 "$node_(178) setdest 147429 46470 13.0" 
$ns at 552.5239710999882 "$node_(178) setdest 49776 20218 7.0" 
$ns at 632.7667300013361 "$node_(178) setdest 127392 33984 12.0" 
$ns at 687.0367989028155 "$node_(178) setdest 10679 81188 8.0" 
$ns at 724.5266800974522 "$node_(178) setdest 65580 24217 9.0" 
$ns at 827.3720453735247 "$node_(178) setdest 208808 41563 15.0" 
$ns at 124.24642963411225 "$node_(179) setdest 37011 22687 12.0" 
$ns at 188.23617128963699 "$node_(179) setdest 12048 35263 4.0" 
$ns at 219.85449817432715 "$node_(179) setdest 117808 42699 10.0" 
$ns at 281.78765529204827 "$node_(179) setdest 150187 22459 2.0" 
$ns at 313.42258268783104 "$node_(179) setdest 8140 47992 15.0" 
$ns at 357.51378122858495 "$node_(179) setdest 57303 60571 16.0" 
$ns at 500.1276993644453 "$node_(179) setdest 74964 8432 2.0" 
$ns at 532.208838906368 "$node_(179) setdest 93136 62652 5.0" 
$ns at 592.4207799623146 "$node_(179) setdest 230959 68042 19.0" 
$ns at 698.8093150609662 "$node_(179) setdest 83862 38642 6.0" 
$ns at 786.6705859933425 "$node_(179) setdest 126420 10593 10.0" 
$ns at 857.5143288049071 "$node_(179) setdest 235364 11382 4.0" 
$ns at 895.8135663480515 "$node_(179) setdest 174951 69700 1.0" 
$ns at 103.80298358449993 "$node_(180) setdest 93445 11630 1.0" 
$ns at 139.10049009235746 "$node_(180) setdest 68278 17366 8.0" 
$ns at 179.73770601049637 "$node_(180) setdest 96907 25953 5.0" 
$ns at 254.09089777708587 "$node_(180) setdest 153083 36230 1.0" 
$ns at 293.5968302456114 "$node_(180) setdest 43075 46628 4.0" 
$ns at 345.7190113183476 "$node_(180) setdest 64405 38761 1.0" 
$ns at 382.5546289349952 "$node_(180) setdest 184984 61432 3.0" 
$ns at 423.3579156357998 "$node_(180) setdest 33525 18264 1.0" 
$ns at 455.79066171430856 "$node_(180) setdest 26823 12047 13.0" 
$ns at 552.2851123200901 "$node_(180) setdest 110609 56966 13.0" 
$ns at 676.4893204231926 "$node_(180) setdest 191016 25951 16.0" 
$ns at 845.440332818748 "$node_(180) setdest 180325 54748 17.0" 
$ns at 157.110010044204 "$node_(181) setdest 69209 39852 12.0" 
$ns at 200.43212033875946 "$node_(181) setdest 97774 15274 3.0" 
$ns at 241.9664755781983 "$node_(181) setdest 52502 25304 1.0" 
$ns at 279.57731850975506 "$node_(181) setdest 74566 809 1.0" 
$ns at 316.31875264812953 "$node_(181) setdest 148657 39571 9.0" 
$ns at 394.88047198146495 "$node_(181) setdest 46823 9705 19.0" 
$ns at 546.3198057977413 "$node_(181) setdest 61071 24097 4.0" 
$ns at 582.7428107601157 "$node_(181) setdest 194058 7811 8.0" 
$ns at 639.8471870027072 "$node_(181) setdest 82233 26492 20.0" 
$ns at 735.408031259434 "$node_(181) setdest 8626 72981 9.0" 
$ns at 834.9316299967338 "$node_(181) setdest 266279 58547 1.0" 
$ns at 865.4101272809315 "$node_(181) setdest 141034 14205 17.0" 
$ns at 147.4252291251515 "$node_(182) setdest 47320 18849 20.0" 
$ns at 184.4008762110993 "$node_(182) setdest 113016 39571 1.0" 
$ns at 223.10980700919794 "$node_(182) setdest 37079 8633 14.0" 
$ns at 283.9231746348204 "$node_(182) setdest 124700 36688 2.0" 
$ns at 324.07191971509906 "$node_(182) setdest 45955 3607 4.0" 
$ns at 355.6418279485305 "$node_(182) setdest 141216 35808 3.0" 
$ns at 403.6717447404159 "$node_(182) setdest 180598 55015 2.0" 
$ns at 445.1559059776738 "$node_(182) setdest 18847 31506 8.0" 
$ns at 523.4690401290106 "$node_(182) setdest 106126 40719 20.0" 
$ns at 566.2478505397469 "$node_(182) setdest 85261 58091 7.0" 
$ns at 626.9756537928821 "$node_(182) setdest 132962 37501 13.0" 
$ns at 692.3328791817821 "$node_(182) setdest 70731 58546 8.0" 
$ns at 762.94287913725 "$node_(182) setdest 60649 55566 13.0" 
$ns at 206.31448258543443 "$node_(183) setdest 2291 14186 12.0" 
$ns at 322.52267243169916 "$node_(183) setdest 103492 42978 19.0" 
$ns at 502.04494370255486 "$node_(183) setdest 158869 43702 4.0" 
$ns at 546.3258616275765 "$node_(183) setdest 97736 4496 2.0" 
$ns at 587.4343110929789 "$node_(183) setdest 86371 76923 3.0" 
$ns at 631.5013486476784 "$node_(183) setdest 84736 27957 3.0" 
$ns at 685.6767687497595 "$node_(183) setdest 12708 26412 12.0" 
$ns at 812.0479899728824 "$node_(183) setdest 88046 26385 14.0" 
$ns at 157.86130800869182 "$node_(184) setdest 86254 9831 7.0" 
$ns at 219.16482665938037 "$node_(184) setdest 116654 13659 6.0" 
$ns at 263.0782172362942 "$node_(184) setdest 20175 19018 16.0" 
$ns at 349.72461420392625 "$node_(184) setdest 135734 33832 18.0" 
$ns at 499.11105283568133 "$node_(184) setdest 110961 28819 3.0" 
$ns at 548.2178297452268 "$node_(184) setdest 45434 59269 7.0" 
$ns at 594.8248409237467 "$node_(184) setdest 180251 18923 16.0" 
$ns at 762.1034292524923 "$node_(184) setdest 37058 48219 2.0" 
$ns at 806.0221990284616 "$node_(184) setdest 242363 88196 13.0" 
$ns at 214.5945186975784 "$node_(185) setdest 96816 27318 9.0" 
$ns at 313.79358045397606 "$node_(185) setdest 85804 53059 13.0" 
$ns at 354.2510057388902 "$node_(185) setdest 125323 29064 18.0" 
$ns at 466.29517269062785 "$node_(185) setdest 4490 67154 1.0" 
$ns at 497.7982972769226 "$node_(185) setdest 183349 24547 8.0" 
$ns at 607.2180940495364 "$node_(185) setdest 91834 44380 7.0" 
$ns at 694.5660228156573 "$node_(185) setdest 54384 21554 1.0" 
$ns at 726.0537133298234 "$node_(185) setdest 53074 3243 7.0" 
$ns at 779.732579646499 "$node_(185) setdest 75086 20051 17.0" 
$ns at 860.2549516861842 "$node_(185) setdest 39029 56245 15.0" 
$ns at 171.99152890938606 "$node_(186) setdest 57248 24791 16.0" 
$ns at 300.1038096872061 "$node_(186) setdest 131590 1522 6.0" 
$ns at 386.8073800153582 "$node_(186) setdest 51250 36642 5.0" 
$ns at 423.9914439939324 "$node_(186) setdest 69848 7974 14.0" 
$ns at 566.9400965903753 "$node_(186) setdest 7274 72724 3.0" 
$ns at 601.6769492431996 "$node_(186) setdest 40169 64403 18.0" 
$ns at 730.3016957773664 "$node_(186) setdest 18611 26866 14.0" 
$ns at 808.8955934981549 "$node_(186) setdest 177602 89134 11.0" 
$ns at 111.98412124176647 "$node_(187) setdest 74953 24201 15.0" 
$ns at 288.7274150349667 "$node_(187) setdest 139433 50591 9.0" 
$ns at 361.12066332518634 "$node_(187) setdest 13326 41781 18.0" 
$ns at 560.0530457550257 "$node_(187) setdest 149567 51784 13.0" 
$ns at 633.7081428792198 "$node_(187) setdest 148260 40571 19.0" 
$ns at 821.9257184449621 "$node_(187) setdest 236259 63711 16.0" 
$ns at 119.34463326623754 "$node_(188) setdest 55463 11436 1.0" 
$ns at 150.15863284324493 "$node_(188) setdest 126574 4978 9.0" 
$ns at 265.26300597034844 "$node_(188) setdest 130700 11717 17.0" 
$ns at 341.7086167542205 "$node_(188) setdest 143864 6717 14.0" 
$ns at 487.42699075392386 "$node_(188) setdest 19287 9652 4.0" 
$ns at 528.6583978988032 "$node_(188) setdest 6601 23076 11.0" 
$ns at 608.5714560553287 "$node_(188) setdest 169967 36118 13.0" 
$ns at 752.2385487278727 "$node_(188) setdest 23202 58944 4.0" 
$ns at 821.1773076697142 "$node_(188) setdest 176970 40196 5.0" 
$ns at 888.2482255443916 "$node_(188) setdest 238222 43261 7.0" 
$ns at 204.13550553566859 "$node_(189) setdest 95956 28230 17.0" 
$ns at 382.86104977863187 "$node_(189) setdest 177028 55345 17.0" 
$ns at 575.805410405166 "$node_(189) setdest 151361 25330 10.0" 
$ns at 700.2970814885455 "$node_(189) setdest 2878 20436 11.0" 
$ns at 780.7479679076982 "$node_(189) setdest 215274 3799 14.0" 
$ns at 869.0771010475578 "$node_(189) setdest 133376 41869 17.0" 
$ns at 118.27473140718224 "$node_(190) setdest 31383 25252 9.0" 
$ns at 177.88378131808878 "$node_(190) setdest 48078 15266 16.0" 
$ns at 219.3941905064397 "$node_(190) setdest 67884 15357 12.0" 
$ns at 326.754393506483 "$node_(190) setdest 5721 24736 11.0" 
$ns at 405.92611088202466 "$node_(190) setdest 25815 61737 15.0" 
$ns at 481.3320972191675 "$node_(190) setdest 120980 25838 6.0" 
$ns at 546.553894634647 "$node_(190) setdest 185297 26162 5.0" 
$ns at 610.950684793369 "$node_(190) setdest 27646 25130 3.0" 
$ns at 669.0147259638616 "$node_(190) setdest 198952 4325 2.0" 
$ns at 702.2701389637913 "$node_(190) setdest 203841 10558 14.0" 
$ns at 836.7768510735286 "$node_(190) setdest 26873 55371 1.0" 
$ns at 869.9279277477035 "$node_(190) setdest 109796 88849 13.0" 
$ns at 146.41926424434047 "$node_(191) setdest 54952 508 7.0" 
$ns at 236.2483592268479 "$node_(191) setdest 53730 11023 1.0" 
$ns at 269.0082128828617 "$node_(191) setdest 134622 15855 10.0" 
$ns at 331.6505380224038 "$node_(191) setdest 85196 29374 3.0" 
$ns at 385.4122972424343 "$node_(191) setdest 20877 46223 8.0" 
$ns at 438.0241966189494 "$node_(191) setdest 84879 59114 8.0" 
$ns at 509.590839006418 "$node_(191) setdest 183763 64313 16.0" 
$ns at 587.3063948816732 "$node_(191) setdest 175705 47874 11.0" 
$ns at 658.5355474870631 "$node_(191) setdest 29557 67462 11.0" 
$ns at 770.3681889695214 "$node_(191) setdest 248557 4514 17.0" 
$ns at 159.10755021970135 "$node_(192) setdest 10851 23492 2.0" 
$ns at 201.60769684076334 "$node_(192) setdest 30915 7607 8.0" 
$ns at 252.97675687238433 "$node_(192) setdest 45817 3640 15.0" 
$ns at 403.7272072581418 "$node_(192) setdest 11118 44426 7.0" 
$ns at 462.75025835084176 "$node_(192) setdest 141115 1105 16.0" 
$ns at 601.069195257551 "$node_(192) setdest 22274 58776 16.0" 
$ns at 758.0356660672518 "$node_(192) setdest 223999 36296 3.0" 
$ns at 790.9355092256021 "$node_(192) setdest 176792 68300 14.0" 
$ns at 822.0971414423874 "$node_(192) setdest 17491 53091 2.0" 
$ns at 865.8904019645134 "$node_(192) setdest 204051 75078 9.0" 
$ns at 183.2181293924406 "$node_(193) setdest 20948 38773 16.0" 
$ns at 371.88929256722906 "$node_(193) setdest 9871 21854 7.0" 
$ns at 417.0232805898656 "$node_(193) setdest 86227 33159 13.0" 
$ns at 515.0730866526002 "$node_(193) setdest 40591 40662 19.0" 
$ns at 658.0145339249382 "$node_(193) setdest 7376 68819 17.0" 
$ns at 764.4471369744847 "$node_(193) setdest 61473 40078 10.0" 
$ns at 879.3213650927189 "$node_(193) setdest 194021 81436 10.0" 
$ns at 126.75285180448267 "$node_(194) setdest 94317 22961 20.0" 
$ns at 265.69451728074057 "$node_(194) setdest 13346 45909 1.0" 
$ns at 305.38657359424866 "$node_(194) setdest 112711 15817 9.0" 
$ns at 365.9142241935901 "$node_(194) setdest 128247 49409 19.0" 
$ns at 538.5130647324357 "$node_(194) setdest 150376 67130 20.0" 
$ns at 669.2932828593841 "$node_(194) setdest 125559 1042 12.0" 
$ns at 731.5431139555544 "$node_(194) setdest 74699 47787 9.0" 
$ns at 849.1258028132766 "$node_(194) setdest 166365 13562 13.0" 
$ns at 889.0562118388314 "$node_(194) setdest 154247 32865 10.0" 
$ns at 151.3565780174898 "$node_(195) setdest 73011 31476 11.0" 
$ns at 195.64564680023716 "$node_(195) setdest 96242 43948 10.0" 
$ns at 259.7664259160965 "$node_(195) setdest 71135 28404 1.0" 
$ns at 289.93342711818565 "$node_(195) setdest 111761 23654 10.0" 
$ns at 404.32049495893057 "$node_(195) setdest 176043 49348 8.0" 
$ns at 448.0297580303331 "$node_(195) setdest 185110 3909 9.0" 
$ns at 517.2465922530755 "$node_(195) setdest 42494 54197 9.0" 
$ns at 609.004618575135 "$node_(195) setdest 209675 5168 6.0" 
$ns at 658.8922956369804 "$node_(195) setdest 170991 60147 12.0" 
$ns at 768.9981283410855 "$node_(195) setdest 241584 34448 18.0" 
$ns at 127.49407117833354 "$node_(196) setdest 3351 9205 7.0" 
$ns at 213.71854650124556 "$node_(196) setdest 42138 24473 12.0" 
$ns at 264.79226631539154 "$node_(196) setdest 75277 40259 16.0" 
$ns at 356.8268576457428 "$node_(196) setdest 96508 27041 18.0" 
$ns at 562.1660937390524 "$node_(196) setdest 221646 25502 1.0" 
$ns at 595.1478343782427 "$node_(196) setdest 159339 61165 11.0" 
$ns at 641.9614641683888 "$node_(196) setdest 219156 9439 4.0" 
$ns at 672.2773530783062 "$node_(196) setdest 62702 17193 7.0" 
$ns at 765.4105760243037 "$node_(196) setdest 147440 49611 3.0" 
$ns at 814.3269332947646 "$node_(196) setdest 224742 79405 13.0" 
$ns at 869.3096036048136 "$node_(196) setdest 159763 22228 10.0" 
$ns at 118.52652449272223 "$node_(197) setdest 40491 22556 12.0" 
$ns at 199.57739492019903 "$node_(197) setdest 63758 4511 12.0" 
$ns at 240.4162489371685 "$node_(197) setdest 45524 41280 20.0" 
$ns at 453.0914406211233 "$node_(197) setdest 27082 58077 17.0" 
$ns at 636.1542454794911 "$node_(197) setdest 175064 34920 10.0" 
$ns at 692.2684776359401 "$node_(197) setdest 179447 18983 12.0" 
$ns at 795.7937987995033 "$node_(197) setdest 100328 17098 8.0" 
$ns at 836.2632432529243 "$node_(197) setdest 241470 44547 16.0" 
$ns at 127.53925635208802 "$node_(198) setdest 91029 26791 4.0" 
$ns at 178.71679038261746 "$node_(198) setdest 110309 21445 1.0" 
$ns at 216.75586630424098 "$node_(198) setdest 46815 13803 4.0" 
$ns at 285.22334018128004 "$node_(198) setdest 15054 38012 11.0" 
$ns at 370.45747448234016 "$node_(198) setdest 116933 42414 12.0" 
$ns at 478.8889457765279 "$node_(198) setdest 86947 44388 5.0" 
$ns at 548.7116584934338 "$node_(198) setdest 19581 16201 4.0" 
$ns at 613.0586041464967 "$node_(198) setdest 145949 33665 11.0" 
$ns at 740.9850901206565 "$node_(198) setdest 19902 7520 2.0" 
$ns at 772.6284512446587 "$node_(198) setdest 53101 27993 13.0" 
$ns at 830.1482485903979 "$node_(198) setdest 218694 73902 12.0" 
$ns at 185.4811072587904 "$node_(199) setdest 101833 4826 2.0" 
$ns at 219.00934956312398 "$node_(199) setdest 123693 5944 11.0" 
$ns at 274.7590356406192 "$node_(199) setdest 5332 5752 6.0" 
$ns at 344.1292470057934 "$node_(199) setdest 45879 38054 8.0" 
$ns at 438.8113604268936 "$node_(199) setdest 2586 36176 9.0" 
$ns at 496.72343900650026 "$node_(199) setdest 88884 32999 3.0" 
$ns at 539.9234027430202 "$node_(199) setdest 187751 45390 1.0" 
$ns at 575.2369824973994 "$node_(199) setdest 116464 54993 16.0" 
$ns at 688.6441394324688 "$node_(199) setdest 178612 30158 12.0" 
$ns at 768.408076827455 "$node_(199) setdest 191138 32547 6.0" 
$ns at 838.5237046626553 "$node_(199) setdest 164043 14600 3.0" 
$ns at 880.7081454812495 "$node_(199) setdest 193984 42355 13.0" 
$ns at 339.392555817804 "$node_(200) setdest 124094 37238 5.0" 
$ns at 401.8158072680415 "$node_(200) setdest 125234 10604 12.0" 
$ns at 489.2412019711253 "$node_(200) setdest 55978 5437 19.0" 
$ns at 667.2277340581169 "$node_(200) setdest 69853 35761 14.0" 
$ns at 782.586056816506 "$node_(200) setdest 43274 27868 16.0" 
$ns at 846.2455599515287 "$node_(200) setdest 69279 39101 6.0" 
$ns at 256.249526284318 "$node_(201) setdest 84331 36176 2.0" 
$ns at 287.0051130035954 "$node_(201) setdest 93451 21133 13.0" 
$ns at 365.81345207927075 "$node_(201) setdest 74367 33716 7.0" 
$ns at 408.62734483027606 "$node_(201) setdest 47104 26175 7.0" 
$ns at 500.36031751473695 "$node_(201) setdest 105588 17890 3.0" 
$ns at 549.0756820600253 "$node_(201) setdest 33615 6439 3.0" 
$ns at 587.0564514843161 "$node_(201) setdest 45390 29747 16.0" 
$ns at 642.1694633655186 "$node_(201) setdest 106308 10293 19.0" 
$ns at 776.2318640409874 "$node_(201) setdest 23740 20571 13.0" 
$ns at 863.2695187837184 "$node_(201) setdest 108491 30323 14.0" 
$ns at 245.39792467462107 "$node_(202) setdest 88071 29478 12.0" 
$ns at 322.48191540927155 "$node_(202) setdest 91951 21067 18.0" 
$ns at 460.1312877694426 "$node_(202) setdest 115339 37353 13.0" 
$ns at 606.9727163973802 "$node_(202) setdest 41116 32563 4.0" 
$ns at 653.119279953524 "$node_(202) setdest 52970 18275 13.0" 
$ns at 697.5165831823292 "$node_(202) setdest 55953 1333 3.0" 
$ns at 735.7373209709804 "$node_(202) setdest 83176 21318 17.0" 
$ns at 870.8009983784787 "$node_(202) setdest 3902 19597 19.0" 
$ns at 319.54549287991455 "$node_(203) setdest 47810 17512 1.0" 
$ns at 354.0015299046288 "$node_(203) setdest 106945 1469 20.0" 
$ns at 508.0139372734661 "$node_(203) setdest 106729 38427 12.0" 
$ns at 635.3756522402797 "$node_(203) setdest 42647 14689 4.0" 
$ns at 666.1192263569508 "$node_(203) setdest 41213 26397 9.0" 
$ns at 715.836558444024 "$node_(203) setdest 100577 20952 7.0" 
$ns at 799.1327765810158 "$node_(203) setdest 26761 7523 11.0" 
$ns at 888.3442253007635 "$node_(203) setdest 105877 28482 11.0" 
$ns at 283.4486184431274 "$node_(204) setdest 96309 32034 12.0" 
$ns at 374.0760127033212 "$node_(204) setdest 12131 27788 18.0" 
$ns at 430.1502623941561 "$node_(204) setdest 77423 28563 16.0" 
$ns at 562.508442734995 "$node_(204) setdest 101601 29921 12.0" 
$ns at 607.4762448545245 "$node_(204) setdest 128408 20865 13.0" 
$ns at 700.4109722740985 "$node_(204) setdest 24991 27333 13.0" 
$ns at 809.9480343932182 "$node_(204) setdest 84017 5482 1.0" 
$ns at 845.4787305489945 "$node_(204) setdest 126433 21635 10.0" 
$ns at 251.37095774292243 "$node_(205) setdest 14411 39486 7.0" 
$ns at 310.1731891547779 "$node_(205) setdest 84782 31092 5.0" 
$ns at 343.1001354838891 "$node_(205) setdest 105802 21776 13.0" 
$ns at 382.68609146869437 "$node_(205) setdest 89192 6441 15.0" 
$ns at 535.2131781674708 "$node_(205) setdest 92772 35579 6.0" 
$ns at 589.8047323802218 "$node_(205) setdest 40916 31189 14.0" 
$ns at 743.8924203232812 "$node_(205) setdest 128141 22408 4.0" 
$ns at 789.9614950916439 "$node_(205) setdest 64379 739 16.0" 
$ns at 888.3690682459459 "$node_(205) setdest 87531 27742 5.0" 
$ns at 364.3967865241344 "$node_(206) setdest 2102 18378 5.0" 
$ns at 395.53598539181297 "$node_(206) setdest 59178 17528 1.0" 
$ns at 427.1493304702295 "$node_(206) setdest 26700 33760 6.0" 
$ns at 462.1086893462528 "$node_(206) setdest 91032 29222 8.0" 
$ns at 566.7633765873271 "$node_(206) setdest 49437 20408 12.0" 
$ns at 632.0148894491363 "$node_(206) setdest 51089 16011 7.0" 
$ns at 696.7511849161021 "$node_(206) setdest 11384 39990 2.0" 
$ns at 735.9307110562437 "$node_(206) setdest 104742 10293 14.0" 
$ns at 851.869430439502 "$node_(206) setdest 121451 7299 12.0" 
$ns at 342.1207503186186 "$node_(207) setdest 118689 40732 4.0" 
$ns at 396.2451613253714 "$node_(207) setdest 105320 3892 15.0" 
$ns at 469.18735506946473 "$node_(207) setdest 111703 42779 12.0" 
$ns at 617.9073696435759 "$node_(207) setdest 45018 34213 12.0" 
$ns at 682.6985780328212 "$node_(207) setdest 122231 33005 19.0" 
$ns at 893.4485553477942 "$node_(207) setdest 128202 29357 20.0" 
$ns at 296.45836599495186 "$node_(208) setdest 131965 41003 1.0" 
$ns at 331.4177274466637 "$node_(208) setdest 19394 35025 18.0" 
$ns at 512.8593952321489 "$node_(208) setdest 28837 9994 13.0" 
$ns at 671.2905829977469 "$node_(208) setdest 21081 17007 11.0" 
$ns at 797.2505474728752 "$node_(208) setdest 80253 3039 16.0" 
$ns at 881.7974612288632 "$node_(208) setdest 123476 26966 19.0" 
$ns at 314.0729539741103 "$node_(209) setdest 43806 7521 19.0" 
$ns at 456.1369167075536 "$node_(209) setdest 133909 40707 16.0" 
$ns at 576.6524246957856 "$node_(209) setdest 104966 43283 14.0" 
$ns at 685.0509496842586 "$node_(209) setdest 48761 1208 3.0" 
$ns at 733.5826121606252 "$node_(209) setdest 87413 3228 7.0" 
$ns at 802.9908163531825 "$node_(209) setdest 57511 25131 3.0" 
$ns at 856.5027844225779 "$node_(209) setdest 36796 30948 20.0" 
$ns at 220.0307950710353 "$node_(210) setdest 91021 36733 18.0" 
$ns at 280.8966796013073 "$node_(210) setdest 44484 20 17.0" 
$ns at 473.38677695717195 "$node_(210) setdest 51864 9012 18.0" 
$ns at 557.1921588838883 "$node_(210) setdest 4595 11281 1.0" 
$ns at 592.335423081183 "$node_(210) setdest 84776 36801 2.0" 
$ns at 628.2154345646584 "$node_(210) setdest 40143 44692 9.0" 
$ns at 659.7769044462059 "$node_(210) setdest 69493 26295 18.0" 
$ns at 851.0695319524741 "$node_(210) setdest 6707 10141 17.0" 
$ns at 233.76307653786216 "$node_(211) setdest 72673 5832 13.0" 
$ns at 350.7964653273862 "$node_(211) setdest 95985 20874 8.0" 
$ns at 439.7116263718074 "$node_(211) setdest 123655 37353 12.0" 
$ns at 518.4652192044854 "$node_(211) setdest 62710 39511 17.0" 
$ns at 605.5587195863409 "$node_(211) setdest 2514 2639 8.0" 
$ns at 650.269317589521 "$node_(211) setdest 2082 15555 12.0" 
$ns at 692.3256789605405 "$node_(211) setdest 118635 37073 9.0" 
$ns at 738.4229920340867 "$node_(211) setdest 22467 407 7.0" 
$ns at 775.5879580618564 "$node_(211) setdest 51070 4568 5.0" 
$ns at 824.1934558951459 "$node_(211) setdest 869 34667 7.0" 
$ns at 875.982767290657 "$node_(211) setdest 72501 17624 17.0" 
$ns at 348.72322453954143 "$node_(212) setdest 56897 40027 12.0" 
$ns at 489.5904226888966 "$node_(212) setdest 43062 1303 20.0" 
$ns at 709.4943235175976 "$node_(212) setdest 117798 39419 1.0" 
$ns at 747.3503583656524 "$node_(212) setdest 128999 41826 1.0" 
$ns at 781.9018561346044 "$node_(212) setdest 103304 15129 1.0" 
$ns at 815.5074722087984 "$node_(212) setdest 52928 4893 17.0" 
$ns at 866.9960687159656 "$node_(212) setdest 96385 33869 11.0" 
$ns at 204.42663841833402 "$node_(213) setdest 23699 43818 13.0" 
$ns at 322.9926400819195 "$node_(213) setdest 11675 25269 19.0" 
$ns at 509.6549544390584 "$node_(213) setdest 12232 22717 10.0" 
$ns at 616.2998345615644 "$node_(213) setdest 45283 9571 1.0" 
$ns at 655.9371666726847 "$node_(213) setdest 3670 20406 13.0" 
$ns at 740.2896557536053 "$node_(213) setdest 120885 18091 17.0" 
$ns at 785.1953286550124 "$node_(213) setdest 95959 5458 16.0" 
$ns at 880.6619017075492 "$node_(213) setdest 76782 18987 1.0" 
$ns at 310.47729347442305 "$node_(214) setdest 93483 14533 15.0" 
$ns at 345.43055513960894 "$node_(214) setdest 8335 44398 1.0" 
$ns at 380.3459743879876 "$node_(214) setdest 63446 24553 15.0" 
$ns at 449.2897156538243 "$node_(214) setdest 7508 22248 5.0" 
$ns at 503.9070856363699 "$node_(214) setdest 73840 2465 8.0" 
$ns at 608.4968056565199 "$node_(214) setdest 12507 38150 7.0" 
$ns at 652.3700347409019 "$node_(214) setdest 43895 43985 17.0" 
$ns at 777.0179353575944 "$node_(214) setdest 53725 14889 12.0" 
$ns at 836.7814339349884 "$node_(214) setdest 112831 36222 7.0" 
$ns at 209.85063211389146 "$node_(215) setdest 74283 33900 7.0" 
$ns at 246.08874988946198 "$node_(215) setdest 113736 1879 16.0" 
$ns at 277.3661731920528 "$node_(215) setdest 118328 9960 4.0" 
$ns at 311.1427063431494 "$node_(215) setdest 35353 12188 17.0" 
$ns at 447.99533473638104 "$node_(215) setdest 92729 36825 19.0" 
$ns at 656.441975914465 "$node_(215) setdest 41781 25849 11.0" 
$ns at 759.1842185111773 "$node_(215) setdest 101238 39030 5.0" 
$ns at 825.174401983081 "$node_(215) setdest 22485 30150 5.0" 
$ns at 899.4212760056499 "$node_(215) setdest 113583 37161 12.0" 
$ns at 246.13717300230593 "$node_(216) setdest 14519 23009 5.0" 
$ns at 281.59756573478575 "$node_(216) setdest 35063 39133 6.0" 
$ns at 324.522019583188 "$node_(216) setdest 62147 13741 1.0" 
$ns at 359.3545636869303 "$node_(216) setdest 44016 5591 17.0" 
$ns at 535.2181715769573 "$node_(216) setdest 106804 39752 16.0" 
$ns at 651.9595026244438 "$node_(216) setdest 13561 6038 1.0" 
$ns at 691.2724320274865 "$node_(216) setdest 64391 39849 17.0" 
$ns at 822.8044233729894 "$node_(216) setdest 24952 4438 16.0" 
$ns at 238.69069452635176 "$node_(217) setdest 57479 25939 7.0" 
$ns at 272.25705218377817 "$node_(217) setdest 29307 11979 11.0" 
$ns at 341.409298421257 "$node_(217) setdest 18019 42368 12.0" 
$ns at 450.8618854069922 "$node_(217) setdest 93157 8867 2.0" 
$ns at 489.8637174887435 "$node_(217) setdest 72980 12751 11.0" 
$ns at 530.2438261506339 "$node_(217) setdest 109484 10470 14.0" 
$ns at 591.9932190606402 "$node_(217) setdest 115756 22231 3.0" 
$ns at 632.8575160058484 "$node_(217) setdest 42174 24321 14.0" 
$ns at 685.2531956359409 "$node_(217) setdest 86294 31480 1.0" 
$ns at 716.5654776251772 "$node_(217) setdest 72945 32136 4.0" 
$ns at 774.1493662755653 "$node_(217) setdest 63249 33781 10.0" 
$ns at 823.5374570863091 "$node_(217) setdest 84544 4020 11.0" 
$ns at 857.0081262394077 "$node_(217) setdest 72783 11830 20.0" 
$ns at 256.0295209180551 "$node_(218) setdest 60990 39248 8.0" 
$ns at 355.660496599074 "$node_(218) setdest 7813 16916 5.0" 
$ns at 426.48824958088403 "$node_(218) setdest 88802 14086 19.0" 
$ns at 596.3192038421972 "$node_(218) setdest 12025 5959 14.0" 
$ns at 673.7674413768897 "$node_(218) setdest 102636 18484 12.0" 
$ns at 780.393104022982 "$node_(218) setdest 36756 22290 11.0" 
$ns at 814.7498118133902 "$node_(218) setdest 27672 10077 3.0" 
$ns at 856.8097797753926 "$node_(218) setdest 37897 1442 2.0" 
$ns at 888.6242414717626 "$node_(218) setdest 54199 15956 2.0" 
$ns at 288.2368481004007 "$node_(219) setdest 104152 19489 6.0" 
$ns at 363.28450783097543 "$node_(219) setdest 102802 15673 19.0" 
$ns at 537.6884389454012 "$node_(219) setdest 131083 30768 11.0" 
$ns at 622.3565397687441 "$node_(219) setdest 109239 17080 15.0" 
$ns at 766.8378076339209 "$node_(219) setdest 71459 2216 14.0" 
$ns at 847.283037407075 "$node_(219) setdest 33986 29337 3.0" 
$ns at 895.2897070111095 "$node_(219) setdest 68884 7185 4.0" 
$ns at 316.03624009631847 "$node_(220) setdest 130166 36763 15.0" 
$ns at 408.1342163606803 "$node_(220) setdest 48676 21751 16.0" 
$ns at 443.45257125877345 "$node_(220) setdest 122567 1558 11.0" 
$ns at 510.92242235619324 "$node_(220) setdest 111898 14971 5.0" 
$ns at 584.4497182782177 "$node_(220) setdest 84402 4028 16.0" 
$ns at 769.3422922355998 "$node_(220) setdest 60491 34897 12.0" 
$ns at 882.3525162191569 "$node_(220) setdest 91061 21921 17.0" 
$ns at 219.20959325082381 "$node_(221) setdest 97594 37102 8.0" 
$ns at 249.69606953106646 "$node_(221) setdest 101014 23123 7.0" 
$ns at 321.62167116381767 "$node_(221) setdest 63134 2724 6.0" 
$ns at 360.33547041129805 "$node_(221) setdest 71011 43173 5.0" 
$ns at 394.35771764219294 "$node_(221) setdest 6909 2290 12.0" 
$ns at 463.31972577409647 "$node_(221) setdest 19264 42749 6.0" 
$ns at 547.6580512335998 "$node_(221) setdest 8633 24816 18.0" 
$ns at 705.6343045735302 "$node_(221) setdest 35270 22761 6.0" 
$ns at 792.832179556666 "$node_(221) setdest 54813 13978 1.0" 
$ns at 828.3607951608466 "$node_(221) setdest 47297 24305 18.0" 
$ns at 203.16040644715395 "$node_(222) setdest 128760 5192 2.0" 
$ns at 250.5741999167553 "$node_(222) setdest 87037 3510 18.0" 
$ns at 368.66239235760855 "$node_(222) setdest 18356 19725 10.0" 
$ns at 477.57572473211076 "$node_(222) setdest 111359 4161 18.0" 
$ns at 566.2295191137464 "$node_(222) setdest 56760 28921 7.0" 
$ns at 605.1000020187186 "$node_(222) setdest 40015 3373 8.0" 
$ns at 639.4083792076584 "$node_(222) setdest 84305 11919 1.0" 
$ns at 676.6779273839053 "$node_(222) setdest 18895 1528 3.0" 
$ns at 717.6403206394095 "$node_(222) setdest 38481 8154 2.0" 
$ns at 755.7898666931658 "$node_(222) setdest 33695 18201 9.0" 
$ns at 868.3523489295233 "$node_(222) setdest 112388 8239 1.0" 
$ns at 301.35236374376586 "$node_(223) setdest 75388 39884 8.0" 
$ns at 333.0475829978089 "$node_(223) setdest 89024 39776 4.0" 
$ns at 389.2700875012281 "$node_(223) setdest 16575 38223 18.0" 
$ns at 460.0376772430897 "$node_(223) setdest 81576 5677 13.0" 
$ns at 511.5282213003079 "$node_(223) setdest 60100 14657 2.0" 
$ns at 560.2451047317682 "$node_(223) setdest 43907 38186 15.0" 
$ns at 720.6467324827704 "$node_(223) setdest 66016 35625 3.0" 
$ns at 772.0653850110646 "$node_(223) setdest 122473 29850 11.0" 
$ns at 220.89858021983412 "$node_(224) setdest 120182 2212 16.0" 
$ns at 394.09576369368835 "$node_(224) setdest 67323 7782 1.0" 
$ns at 427.9188469121884 "$node_(224) setdest 42685 20943 9.0" 
$ns at 491.4559538438264 "$node_(224) setdest 28932 10792 12.0" 
$ns at 585.9830949352612 "$node_(224) setdest 30424 7143 13.0" 
$ns at 676.4903331642857 "$node_(224) setdest 125945 2668 14.0" 
$ns at 842.7331497822244 "$node_(224) setdest 99409 38947 18.0" 
$ns at 238.96927047867604 "$node_(225) setdest 85362 20619 15.0" 
$ns at 393.7146006868478 "$node_(225) setdest 69057 22368 19.0" 
$ns at 612.5593284514791 "$node_(225) setdest 100752 10733 10.0" 
$ns at 676.8961383638826 "$node_(225) setdest 128783 28224 2.0" 
$ns at 708.9213269644545 "$node_(225) setdest 7834 22922 5.0" 
$ns at 745.4734324208848 "$node_(225) setdest 111231 25072 4.0" 
$ns at 776.7094304942536 "$node_(225) setdest 72988 4605 17.0" 
$ns at 898.974538569745 "$node_(225) setdest 113286 16250 17.0" 
$ns at 228.5645242818654 "$node_(226) setdest 50423 11765 15.0" 
$ns at 357.2140224182789 "$node_(226) setdest 26002 13559 12.0" 
$ns at 482.87948005655807 "$node_(226) setdest 5835 28865 1.0" 
$ns at 514.730232579233 "$node_(226) setdest 58886 37219 3.0" 
$ns at 554.6209088123288 "$node_(226) setdest 31863 99 20.0" 
$ns at 766.354252136812 "$node_(226) setdest 118529 1482 8.0" 
$ns at 801.549514681743 "$node_(226) setdest 76411 38330 18.0" 
$ns at 266.8909600739006 "$node_(227) setdest 107050 4221 5.0" 
$ns at 300.83388598952405 "$node_(227) setdest 70947 31609 6.0" 
$ns at 389.2602967318619 "$node_(227) setdest 52547 31225 17.0" 
$ns at 499.3601448010847 "$node_(227) setdest 34211 24277 1.0" 
$ns at 537.083586207467 "$node_(227) setdest 2900 15715 11.0" 
$ns at 619.0814344827056 "$node_(227) setdest 6240 44343 13.0" 
$ns at 704.1712336939543 "$node_(227) setdest 13601 1491 12.0" 
$ns at 847.2465337728411 "$node_(227) setdest 109858 48 18.0" 
$ns at 224.52476068934413 "$node_(228) setdest 17178 30380 9.0" 
$ns at 259.5114987847883 "$node_(228) setdest 119137 23791 2.0" 
$ns at 300.8532827673595 "$node_(228) setdest 58628 29701 4.0" 
$ns at 337.6603654533078 "$node_(228) setdest 72454 39746 17.0" 
$ns at 429.9836162252411 "$node_(228) setdest 54367 33864 13.0" 
$ns at 554.0012658241236 "$node_(228) setdest 73602 7731 11.0" 
$ns at 688.900737980109 "$node_(228) setdest 2525 16153 16.0" 
$ns at 773.9863021157952 "$node_(228) setdest 75374 7288 14.0" 
$ns at 877.289661511429 "$node_(228) setdest 71053 26679 4.0" 
$ns at 231.46851080551386 "$node_(229) setdest 41749 35512 14.0" 
$ns at 363.02409768848975 "$node_(229) setdest 23608 138 7.0" 
$ns at 422.36490425136714 "$node_(229) setdest 105424 10729 19.0" 
$ns at 454.8153212775151 "$node_(229) setdest 129003 19847 8.0" 
$ns at 522.5983966995273 "$node_(229) setdest 69545 3222 3.0" 
$ns at 576.7736630553773 "$node_(229) setdest 1389 3353 5.0" 
$ns at 609.8385504668516 "$node_(229) setdest 1591 870 14.0" 
$ns at 673.345827563487 "$node_(229) setdest 14841 12202 5.0" 
$ns at 751.3825852295008 "$node_(229) setdest 106372 7680 8.0" 
$ns at 836.4899237762565 "$node_(229) setdest 41788 12025 1.0" 
$ns at 875.8038952801115 "$node_(229) setdest 59845 3448 6.0" 
$ns at 297.7610448658832 "$node_(230) setdest 67754 5648 2.0" 
$ns at 332.02325985821193 "$node_(230) setdest 121887 41729 10.0" 
$ns at 450.189962548179 "$node_(230) setdest 126527 37014 14.0" 
$ns at 582.2115593174498 "$node_(230) setdest 80064 18280 8.0" 
$ns at 635.7194767556457 "$node_(230) setdest 44688 44532 7.0" 
$ns at 731.6542638639378 "$node_(230) setdest 113105 136 12.0" 
$ns at 814.8571145865465 "$node_(230) setdest 24101 44450 3.0" 
$ns at 855.7243325621308 "$node_(230) setdest 27008 30340 9.0" 
$ns at 249.43550247237545 "$node_(231) setdest 104575 27756 12.0" 
$ns at 318.38600442479867 "$node_(231) setdest 128763 17059 11.0" 
$ns at 389.6153311718082 "$node_(231) setdest 116428 37642 5.0" 
$ns at 446.97348133450515 "$node_(231) setdest 122626 25843 4.0" 
$ns at 493.7713346936529 "$node_(231) setdest 43712 23504 3.0" 
$ns at 548.6333609970953 "$node_(231) setdest 7023 5715 14.0" 
$ns at 586.1770735258015 "$node_(231) setdest 58947 23859 14.0" 
$ns at 717.9230083291854 "$node_(231) setdest 32643 25980 7.0" 
$ns at 785.4324397904056 "$node_(231) setdest 53927 40592 5.0" 
$ns at 859.1126960485975 "$node_(231) setdest 98445 13023 1.0" 
$ns at 891.9178682574972 "$node_(231) setdest 53606 10892 10.0" 
$ns at 259.4626118683391 "$node_(232) setdest 107819 12554 14.0" 
$ns at 408.8648760728291 "$node_(232) setdest 33311 42472 15.0" 
$ns at 511.2577235411228 "$node_(232) setdest 82828 20855 4.0" 
$ns at 551.4187760357071 "$node_(232) setdest 88140 27953 14.0" 
$ns at 661.4723123241012 "$node_(232) setdest 3346 22738 3.0" 
$ns at 702.1497863130763 "$node_(232) setdest 84487 34736 4.0" 
$ns at 749.0320347916286 "$node_(232) setdest 96732 35919 4.0" 
$ns at 804.9403840310438 "$node_(232) setdest 25059 39945 14.0" 
$ns at 253.4034149178514 "$node_(233) setdest 2587 30001 4.0" 
$ns at 293.6406693222407 "$node_(233) setdest 69524 13129 19.0" 
$ns at 402.74739385823716 "$node_(233) setdest 36841 38841 3.0" 
$ns at 440.96325715610175 "$node_(233) setdest 63718 24426 13.0" 
$ns at 501.5174629211927 "$node_(233) setdest 84275 22679 15.0" 
$ns at 583.064284930863 "$node_(233) setdest 112998 22001 8.0" 
$ns at 677.6701848855805 "$node_(233) setdest 117929 5402 14.0" 
$ns at 830.5032247257127 "$node_(233) setdest 75463 42672 12.0" 
$ns at 873.7027396202883 "$node_(233) setdest 58256 3310 16.0" 
$ns at 212.44303547102737 "$node_(234) setdest 123398 26816 10.0" 
$ns at 283.21008991486724 "$node_(234) setdest 63058 27143 3.0" 
$ns at 325.3201801819249 "$node_(234) setdest 118100 2490 4.0" 
$ns at 391.61270770162133 "$node_(234) setdest 107398 40252 13.0" 
$ns at 547.9365716336537 "$node_(234) setdest 51886 7486 17.0" 
$ns at 612.5887113276934 "$node_(234) setdest 44297 35227 2.0" 
$ns at 648.265711246834 "$node_(234) setdest 12121 29145 9.0" 
$ns at 738.2493093237275 "$node_(234) setdest 96833 34180 1.0" 
$ns at 776.2804501178996 "$node_(234) setdest 104822 9764 1.0" 
$ns at 811.6138604333094 "$node_(234) setdest 108596 32449 11.0" 
$ns at 870.2605797185012 "$node_(234) setdest 105784 27302 2.0" 
$ns at 240.28800623982482 "$node_(235) setdest 33689 27339 8.0" 
$ns at 275.3392429794617 "$node_(235) setdest 32912 16603 19.0" 
$ns at 341.068655659861 "$node_(235) setdest 60657 31492 11.0" 
$ns at 475.1909851372037 "$node_(235) setdest 2709 14203 4.0" 
$ns at 507.338884831061 "$node_(235) setdest 6756 9650 1.0" 
$ns at 543.4421489153821 "$node_(235) setdest 107914 37871 15.0" 
$ns at 601.3306180351274 "$node_(235) setdest 7610 11146 14.0" 
$ns at 676.7364836051613 "$node_(235) setdest 127258 17355 2.0" 
$ns at 707.2074047226591 "$node_(235) setdest 77988 33842 8.0" 
$ns at 783.7124152315685 "$node_(235) setdest 50491 16358 11.0" 
$ns at 890.1889283139037 "$node_(235) setdest 122972 19634 1.0" 
$ns at 223.82983080113615 "$node_(236) setdest 33783 27583 5.0" 
$ns at 296.78964658552917 "$node_(236) setdest 32414 5499 7.0" 
$ns at 369.2788583083983 "$node_(236) setdest 111411 5452 14.0" 
$ns at 412.16771221989757 "$node_(236) setdest 34302 5655 3.0" 
$ns at 458.41220012185386 "$node_(236) setdest 82132 5476 6.0" 
$ns at 509.1310740181297 "$node_(236) setdest 34462 33810 7.0" 
$ns at 587.2941927576757 "$node_(236) setdest 63050 29479 3.0" 
$ns at 639.7030790301986 "$node_(236) setdest 11493 36894 6.0" 
$ns at 701.3232953023662 "$node_(236) setdest 37506 7783 13.0" 
$ns at 742.516371343118 "$node_(236) setdest 10612 37691 15.0" 
$ns at 809.4070341189129 "$node_(236) setdest 60462 11942 15.0" 
$ns at 281.8206970850067 "$node_(237) setdest 7928 8862 20.0" 
$ns at 511.81393065706027 "$node_(237) setdest 63958 37857 12.0" 
$ns at 544.3527214080951 "$node_(237) setdest 46045 32383 1.0" 
$ns at 577.2814673769063 "$node_(237) setdest 97063 31734 6.0" 
$ns at 664.0389645334521 "$node_(237) setdest 79023 17984 18.0" 
$ns at 706.5244938578644 "$node_(237) setdest 37447 35021 19.0" 
$ns at 868.0869007366011 "$node_(237) setdest 24163 31482 15.0" 
$ns at 213.12755486419871 "$node_(238) setdest 93033 38196 18.0" 
$ns at 378.4445808611258 "$node_(238) setdest 49490 8271 7.0" 
$ns at 432.2443291967359 "$node_(238) setdest 21560 37063 7.0" 
$ns at 486.56336378934884 "$node_(238) setdest 110356 3548 15.0" 
$ns at 614.4886980460972 "$node_(238) setdest 8676 5624 16.0" 
$ns at 704.3978436898332 "$node_(238) setdest 103484 37075 3.0" 
$ns at 752.2815553121676 "$node_(238) setdest 103513 9655 9.0" 
$ns at 795.2632822119979 "$node_(238) setdest 79463 11697 8.0" 
$ns at 863.1205555598759 "$node_(238) setdest 101053 30011 1.0" 
$ns at 224.4015643541781 "$node_(239) setdest 70449 35233 6.0" 
$ns at 287.684840988338 "$node_(239) setdest 107994 21673 5.0" 
$ns at 363.2549597877654 "$node_(239) setdest 120795 7222 11.0" 
$ns at 462.15298110889165 "$node_(239) setdest 86955 23881 16.0" 
$ns at 650.7007377045745 "$node_(239) setdest 2624 8531 6.0" 
$ns at 689.25879040152 "$node_(239) setdest 69630 44548 4.0" 
$ns at 724.1954737743115 "$node_(239) setdest 71189 38283 17.0" 
$ns at 335.330115929542 "$node_(240) setdest 127696 22298 4.0" 
$ns at 387.89959068791325 "$node_(240) setdest 107361 28940 7.0" 
$ns at 421.68177918946924 "$node_(240) setdest 15671 35215 2.0" 
$ns at 454.29957651455373 "$node_(240) setdest 42309 23817 1.0" 
$ns at 489.87156751102646 "$node_(240) setdest 118213 26396 4.0" 
$ns at 554.675100467765 "$node_(240) setdest 130382 44463 1.0" 
$ns at 594.1509980821711 "$node_(240) setdest 22973 35418 8.0" 
$ns at 683.6319577181844 "$node_(240) setdest 115977 20763 2.0" 
$ns at 733.0219530010756 "$node_(240) setdest 116043 34528 12.0" 
$ns at 808.0007891757175 "$node_(240) setdest 133017 13442 17.0" 
$ns at 240.7369284589396 "$node_(241) setdest 23887 847 18.0" 
$ns at 329.802036164328 "$node_(241) setdest 74005 2772 17.0" 
$ns at 415.7702585378931 "$node_(241) setdest 67277 2798 3.0" 
$ns at 464.8733035460776 "$node_(241) setdest 43656 13391 6.0" 
$ns at 533.6773753787226 "$node_(241) setdest 8341 24349 14.0" 
$ns at 693.6006788518506 "$node_(241) setdest 97768 31351 8.0" 
$ns at 750.120450071069 "$node_(241) setdest 109483 34066 9.0" 
$ns at 816.096986983256 "$node_(241) setdest 31859 19939 16.0" 
$ns at 298.85034964692727 "$node_(242) setdest 102974 29198 2.0" 
$ns at 342.6012279736155 "$node_(242) setdest 99932 18710 5.0" 
$ns at 385.2638557370384 "$node_(242) setdest 45736 39191 5.0" 
$ns at 427.6896671622612 "$node_(242) setdest 94932 24214 1.0" 
$ns at 463.97762941385946 "$node_(242) setdest 14140 14141 17.0" 
$ns at 541.9306639957493 "$node_(242) setdest 43649 21780 10.0" 
$ns at 602.488886469084 "$node_(242) setdest 10655 33995 7.0" 
$ns at 657.993832376453 "$node_(242) setdest 73716 12876 17.0" 
$ns at 835.0865951041606 "$node_(242) setdest 1031 5187 12.0" 
$ns at 230.16374886603947 "$node_(243) setdest 69169 28224 3.0" 
$ns at 271.7526310054563 "$node_(243) setdest 118564 5189 15.0" 
$ns at 445.0878332738257 "$node_(243) setdest 113420 42286 2.0" 
$ns at 487.70183178920945 "$node_(243) setdest 32491 31964 18.0" 
$ns at 606.3637135357723 "$node_(243) setdest 97120 1904 12.0" 
$ns at 638.9440735708445 "$node_(243) setdest 15485 99 14.0" 
$ns at 699.735803734354 "$node_(243) setdest 22164 6263 16.0" 
$ns at 837.919378863968 "$node_(243) setdest 48443 5524 14.0" 
$ns at 331.92847535507826 "$node_(244) setdest 50014 3679 17.0" 
$ns at 393.20278452454016 "$node_(244) setdest 66191 41684 3.0" 
$ns at 435.1222083520205 "$node_(244) setdest 47680 24236 2.0" 
$ns at 471.18428079131655 "$node_(244) setdest 90414 3324 8.0" 
$ns at 550.1406104973983 "$node_(244) setdest 71503 29926 8.0" 
$ns at 652.3934612167415 "$node_(244) setdest 120117 14419 1.0" 
$ns at 684.4830658223676 "$node_(244) setdest 81804 32677 9.0" 
$ns at 757.4392419047127 "$node_(244) setdest 80221 32684 11.0" 
$ns at 809.5796776692928 "$node_(244) setdest 50524 8767 16.0" 
$ns at 869.7007920647068 "$node_(244) setdest 60413 28468 10.0" 
$ns at 288.9382521151499 "$node_(245) setdest 24782 16493 4.0" 
$ns at 319.56385681281256 "$node_(245) setdest 72452 20157 1.0" 
$ns at 350.78673124490314 "$node_(245) setdest 110459 30261 4.0" 
$ns at 382.0094349749923 "$node_(245) setdest 108668 5500 18.0" 
$ns at 467.2602009834637 "$node_(245) setdest 99021 29919 10.0" 
$ns at 546.782910254007 "$node_(245) setdest 54707 15057 14.0" 
$ns at 621.4741070307596 "$node_(245) setdest 40574 15477 5.0" 
$ns at 699.9843280591891 "$node_(245) setdest 68808 43619 17.0" 
$ns at 741.8869779164123 "$node_(245) setdest 54726 32760 17.0" 
$ns at 235.43275115108366 "$node_(246) setdest 33555 20868 11.0" 
$ns at 323.57805978691124 "$node_(246) setdest 69456 974 14.0" 
$ns at 448.23744212301114 "$node_(246) setdest 113376 30756 18.0" 
$ns at 487.9694218116056 "$node_(246) setdest 106286 3991 15.0" 
$ns at 602.1771664201392 "$node_(246) setdest 64006 26056 5.0" 
$ns at 659.0643948701589 "$node_(246) setdest 75987 24187 17.0" 
$ns at 805.7381845615851 "$node_(246) setdest 90934 19764 17.0" 
$ns at 853.5392584298166 "$node_(246) setdest 96729 8493 13.0" 
$ns at 224.428729663115 "$node_(247) setdest 7592 17195 8.0" 
$ns at 288.0417731409875 "$node_(247) setdest 97530 25993 13.0" 
$ns at 417.0411021016537 "$node_(247) setdest 100840 20165 3.0" 
$ns at 448.16293199014024 "$node_(247) setdest 59990 1866 6.0" 
$ns at 506.28404229991384 "$node_(247) setdest 52629 29334 14.0" 
$ns at 573.4569758559901 "$node_(247) setdest 124450 23892 12.0" 
$ns at 683.3412106628871 "$node_(247) setdest 96537 27056 9.0" 
$ns at 725.2750230350669 "$node_(247) setdest 7973 31184 7.0" 
$ns at 761.0624195225789 "$node_(247) setdest 89382 21199 9.0" 
$ns at 865.0892737316389 "$node_(247) setdest 102909 15747 11.0" 
$ns at 304.6345064971165 "$node_(248) setdest 71186 1216 8.0" 
$ns at 337.24272259089986 "$node_(248) setdest 25298 6117 10.0" 
$ns at 375.9969441215935 "$node_(248) setdest 32894 32356 19.0" 
$ns at 522.2007725186033 "$node_(248) setdest 99127 32307 10.0" 
$ns at 633.3664866019977 "$node_(248) setdest 45614 11302 14.0" 
$ns at 796.475856548807 "$node_(248) setdest 14976 6406 18.0" 
$ns at 878.9319799271997 "$node_(248) setdest 12023 23677 15.0" 
$ns at 216.70021699936333 "$node_(249) setdest 14516 33073 2.0" 
$ns at 254.82982647995496 "$node_(249) setdest 96302 7448 19.0" 
$ns at 296.29595462726064 "$node_(249) setdest 27777 40258 12.0" 
$ns at 362.5942417952939 "$node_(249) setdest 76910 6289 16.0" 
$ns at 465.7539881747247 "$node_(249) setdest 58235 18182 20.0" 
$ns at 667.9313641783898 "$node_(249) setdest 20733 42638 17.0" 
$ns at 789.6613174554531 "$node_(249) setdest 102207 24225 10.0" 
$ns at 874.6341247951214 "$node_(249) setdest 88299 10787 8.0" 
$ns at 302.03361786421306 "$node_(250) setdest 7044 3065 12.0" 
$ns at 415.2420625881201 "$node_(250) setdest 9076 15714 20.0" 
$ns at 579.261397296239 "$node_(250) setdest 111851 35423 3.0" 
$ns at 638.8862190575904 "$node_(250) setdest 27194 26308 9.0" 
$ns at 709.2784309951904 "$node_(250) setdest 132617 3030 18.0" 
$ns at 848.098140022407 "$node_(250) setdest 132243 2497 15.0" 
$ns at 229.09363646619371 "$node_(251) setdest 16877 44176 1.0" 
$ns at 265.01454189089014 "$node_(251) setdest 29508 31148 16.0" 
$ns at 415.4290961976404 "$node_(251) setdest 37332 43299 2.0" 
$ns at 454.4106403206338 "$node_(251) setdest 53411 12445 18.0" 
$ns at 549.0189364811674 "$node_(251) setdest 6387 12217 6.0" 
$ns at 612.8376631053656 "$node_(251) setdest 54259 39903 18.0" 
$ns at 660.4308654656326 "$node_(251) setdest 34522 26004 9.0" 
$ns at 778.7550049018068 "$node_(251) setdest 102891 10081 11.0" 
$ns at 888.503974571003 "$node_(251) setdest 35136 13968 4.0" 
$ns at 250.5736945182983 "$node_(252) setdest 128350 8955 12.0" 
$ns at 283.06815117737057 "$node_(252) setdest 107630 14441 15.0" 
$ns at 314.12147677061466 "$node_(252) setdest 23311 10170 8.0" 
$ns at 348.7009323094867 "$node_(252) setdest 97100 9372 13.0" 
$ns at 393.5311011835302 "$node_(252) setdest 13100 28875 6.0" 
$ns at 478.24409875383503 "$node_(252) setdest 501 27755 17.0" 
$ns at 594.4815134984967 "$node_(252) setdest 4015 6486 3.0" 
$ns at 645.2550194302853 "$node_(252) setdest 3521 42332 6.0" 
$ns at 712.6001123659021 "$node_(252) setdest 96654 19094 13.0" 
$ns at 748.7179134983091 "$node_(252) setdest 132665 6194 4.0" 
$ns at 788.8969249285011 "$node_(252) setdest 116210 2400 10.0" 
$ns at 839.3337209918127 "$node_(252) setdest 126751 43632 1.0" 
$ns at 872.9180307241556 "$node_(252) setdest 38582 29963 18.0" 
$ns at 207.6784268955772 "$node_(253) setdest 80436 19523 19.0" 
$ns at 379.0408938478646 "$node_(253) setdest 99571 9059 14.0" 
$ns at 491.9119025968306 "$node_(253) setdest 88319 13339 9.0" 
$ns at 562.3257939494321 "$node_(253) setdest 3950 7731 2.0" 
$ns at 608.2081322223302 "$node_(253) setdest 90771 7960 15.0" 
$ns at 765.1021750462044 "$node_(253) setdest 83722 19256 5.0" 
$ns at 821.4983132569143 "$node_(253) setdest 66194 32945 6.0" 
$ns at 869.3347280495741 "$node_(253) setdest 96938 5406 2.0" 
$ns at 222.93355630939772 "$node_(254) setdest 71685 16866 9.0" 
$ns at 311.0064645937843 "$node_(254) setdest 99711 15898 3.0" 
$ns at 364.0879962494053 "$node_(254) setdest 5507 11326 15.0" 
$ns at 404.8801562797145 "$node_(254) setdest 73703 10162 20.0" 
$ns at 595.9561385066908 "$node_(254) setdest 125188 40874 17.0" 
$ns at 717.8894429506179 "$node_(254) setdest 62325 36787 1.0" 
$ns at 752.722441294693 "$node_(254) setdest 55983 366 2.0" 
$ns at 789.4547729332565 "$node_(254) setdest 125254 2439 15.0" 
$ns at 235.75046413710643 "$node_(255) setdest 73820 43614 14.0" 
$ns at 375.0399115749637 "$node_(255) setdest 131623 40950 11.0" 
$ns at 453.95702441779747 "$node_(255) setdest 103547 30654 5.0" 
$ns at 508.1652894243136 "$node_(255) setdest 96620 40101 8.0" 
$ns at 575.2771851229462 "$node_(255) setdest 119776 21737 7.0" 
$ns at 615.8790614056488 "$node_(255) setdest 8406 15830 9.0" 
$ns at 671.7926340053532 "$node_(255) setdest 129715 39734 11.0" 
$ns at 734.1019112421649 "$node_(255) setdest 16261 15586 17.0" 
$ns at 238.98789632178034 "$node_(256) setdest 66190 10998 16.0" 
$ns at 285.85951067699295 "$node_(256) setdest 62613 14959 9.0" 
$ns at 394.7830452425832 "$node_(256) setdest 31100 19475 7.0" 
$ns at 469.96460145271396 "$node_(256) setdest 108495 43142 6.0" 
$ns at 547.0303998387533 "$node_(256) setdest 91192 37051 12.0" 
$ns at 658.3771166675867 "$node_(256) setdest 69867 4028 17.0" 
$ns at 856.3352273797215 "$node_(256) setdest 13252 26167 5.0" 
$ns at 889.0995207441206 "$node_(256) setdest 121256 27660 8.0" 
$ns at 208.54100086309586 "$node_(257) setdest 90642 41009 15.0" 
$ns at 356.2498545055584 "$node_(257) setdest 5947 4131 5.0" 
$ns at 422.33476328375707 "$node_(257) setdest 128814 20499 11.0" 
$ns at 519.7897432229838 "$node_(257) setdest 54875 31450 9.0" 
$ns at 629.9053666604932 "$node_(257) setdest 87281 17419 18.0" 
$ns at 713.4508722615177 "$node_(257) setdest 25466 36433 7.0" 
$ns at 757.4135832658976 "$node_(257) setdest 53514 31093 4.0" 
$ns at 800.4249035211072 "$node_(257) setdest 126182 32529 12.0" 
$ns at 274.91482185004037 "$node_(258) setdest 93326 12699 19.0" 
$ns at 421.43688684037016 "$node_(258) setdest 100220 964 13.0" 
$ns at 524.3914667928797 "$node_(258) setdest 89262 17222 10.0" 
$ns at 566.5162885587417 "$node_(258) setdest 47329 2941 19.0" 
$ns at 635.9644740167103 "$node_(258) setdest 100965 12687 1.0" 
$ns at 674.3334799146916 "$node_(258) setdest 31969 2749 18.0" 
$ns at 789.3733924736464 "$node_(258) setdest 32955 32942 14.0" 
$ns at 876.8082639813879 "$node_(258) setdest 73083 27114 13.0" 
$ns at 217.0224652685538 "$node_(259) setdest 256 14108 18.0" 
$ns at 314.90671101325046 "$node_(259) setdest 121982 19674 1.0" 
$ns at 351.59262286581907 "$node_(259) setdest 96774 10828 13.0" 
$ns at 505.6704317040838 "$node_(259) setdest 284 29448 10.0" 
$ns at 542.0396546861981 "$node_(259) setdest 96467 30702 12.0" 
$ns at 659.4599659847448 "$node_(259) setdest 87149 14758 10.0" 
$ns at 787.8984990624299 "$node_(259) setdest 103230 3018 4.0" 
$ns at 820.3642660072239 "$node_(259) setdest 122524 20523 9.0" 
$ns at 220.82065458770248 "$node_(260) setdest 117341 4088 4.0" 
$ns at 289.5394177905517 "$node_(260) setdest 51935 39539 18.0" 
$ns at 406.3052717456029 "$node_(260) setdest 90312 40743 7.0" 
$ns at 451.5004433524067 "$node_(260) setdest 94679 39786 1.0" 
$ns at 490.7969004300534 "$node_(260) setdest 51223 29670 16.0" 
$ns at 605.4220166442227 "$node_(260) setdest 62323 41388 18.0" 
$ns at 660.8498353116823 "$node_(260) setdest 106393 10258 7.0" 
$ns at 715.1868502314031 "$node_(260) setdest 81232 24230 3.0" 
$ns at 767.3927586725779 "$node_(260) setdest 102376 1779 6.0" 
$ns at 818.2643928054233 "$node_(260) setdest 68482 20724 4.0" 
$ns at 869.913404337674 "$node_(260) setdest 22011 4315 12.0" 
$ns at 205.97942398425235 "$node_(261) setdest 17508 43469 1.0" 
$ns at 243.5663360125187 "$node_(261) setdest 3415 3991 3.0" 
$ns at 289.8523108675701 "$node_(261) setdest 51549 9111 13.0" 
$ns at 341.13313797510557 "$node_(261) setdest 74450 9264 5.0" 
$ns at 412.40383499617263 "$node_(261) setdest 109172 20834 11.0" 
$ns at 453.1692088486059 "$node_(261) setdest 26977 24042 7.0" 
$ns at 499.38707422196114 "$node_(261) setdest 41021 12278 1.0" 
$ns at 536.3752272307349 "$node_(261) setdest 104723 27157 2.0" 
$ns at 577.0914009377025 "$node_(261) setdest 12997 35054 16.0" 
$ns at 607.3579245211598 "$node_(261) setdest 90573 21352 8.0" 
$ns at 689.59638416178 "$node_(261) setdest 8625 43326 12.0" 
$ns at 741.9306885610204 "$node_(261) setdest 38456 25062 9.0" 
$ns at 798.8875339690205 "$node_(261) setdest 108806 21739 19.0" 
$ns at 392.666689617826 "$node_(262) setdest 21369 17410 1.0" 
$ns at 432.3019525612835 "$node_(262) setdest 66851 36616 18.0" 
$ns at 626.8694265786239 "$node_(262) setdest 75500 36633 18.0" 
$ns at 659.2631282473352 "$node_(262) setdest 51087 25364 14.0" 
$ns at 782.984340803103 "$node_(262) setdest 2425 39067 8.0" 
$ns at 844.0244550416219 "$node_(262) setdest 5992 29724 7.0" 
$ns at 251.52718830153515 "$node_(263) setdest 104657 27429 4.0" 
$ns at 314.99278319855205 "$node_(263) setdest 30145 8708 9.0" 
$ns at 423.42555754268886 "$node_(263) setdest 79339 15481 3.0" 
$ns at 466.554509177745 "$node_(263) setdest 25418 13771 8.0" 
$ns at 566.0459914921877 "$node_(263) setdest 118985 11759 7.0" 
$ns at 613.6222338355004 "$node_(263) setdest 19666 10263 9.0" 
$ns at 647.5527520828938 "$node_(263) setdest 109414 31051 12.0" 
$ns at 787.5803966213964 "$node_(263) setdest 106643 25878 2.0" 
$ns at 836.9946748284509 "$node_(263) setdest 998 30110 14.0" 
$ns at 232.65469196494186 "$node_(264) setdest 121103 19251 7.0" 
$ns at 294.5303108337637 "$node_(264) setdest 128985 30721 12.0" 
$ns at 344.4487705303701 "$node_(264) setdest 44772 9203 16.0" 
$ns at 431.50788542848744 "$node_(264) setdest 20898 38362 3.0" 
$ns at 487.33101217617605 "$node_(264) setdest 46213 19704 1.0" 
$ns at 521.2889046113099 "$node_(264) setdest 39551 27429 3.0" 
$ns at 561.5916912469454 "$node_(264) setdest 2739 35196 1.0" 
$ns at 597.6145166537596 "$node_(264) setdest 115070 6255 1.0" 
$ns at 634.9248892470283 "$node_(264) setdest 14620 8494 5.0" 
$ns at 705.7840666471985 "$node_(264) setdest 21651 34720 9.0" 
$ns at 769.8098948916128 "$node_(264) setdest 91906 39162 10.0" 
$ns at 812.742274475104 "$node_(264) setdest 65518 18372 4.0" 
$ns at 868.3602749826983 "$node_(264) setdest 65450 4409 3.0" 
$ns at 293.87255746417515 "$node_(265) setdest 124580 22354 1.0" 
$ns at 326.4878305124041 "$node_(265) setdest 101873 22728 1.0" 
$ns at 357.70116983733567 "$node_(265) setdest 108827 13001 4.0" 
$ns at 417.8376357767364 "$node_(265) setdest 62496 6145 13.0" 
$ns at 501.10426651361956 "$node_(265) setdest 12679 20228 12.0" 
$ns at 557.4260989184917 "$node_(265) setdest 55865 36250 12.0" 
$ns at 662.022205856781 "$node_(265) setdest 42203 31653 8.0" 
$ns at 753.8225554659573 "$node_(265) setdest 7755 5562 15.0" 
$ns at 835.6113935994032 "$node_(265) setdest 84773 35343 8.0" 
$ns at 209.4132497679201 "$node_(266) setdest 23721 34179 15.0" 
$ns at 311.6628084199877 "$node_(266) setdest 19765 13522 18.0" 
$ns at 485.0738201687126 "$node_(266) setdest 53665 19104 11.0" 
$ns at 586.8580261543625 "$node_(266) setdest 116862 36208 3.0" 
$ns at 642.3249024328106 "$node_(266) setdest 28492 21975 13.0" 
$ns at 760.2540455367757 "$node_(266) setdest 128009 16221 5.0" 
$ns at 833.1308916980056 "$node_(266) setdest 70454 4732 18.0" 
$ns at 289.9972758845065 "$node_(267) setdest 65408 16730 7.0" 
$ns at 358.20556123464456 "$node_(267) setdest 21658 30243 4.0" 
$ns at 396.91794420078725 "$node_(267) setdest 134008 11405 17.0" 
$ns at 529.505891392793 "$node_(267) setdest 26541 720 19.0" 
$ns at 689.3271049449547 "$node_(267) setdest 110294 3829 8.0" 
$ns at 763.0175876052151 "$node_(267) setdest 56906 7287 11.0" 
$ns at 878.891037434504 "$node_(267) setdest 120581 3074 16.0" 
$ns at 323.20545965141616 "$node_(268) setdest 76659 38090 16.0" 
$ns at 451.54263368389496 "$node_(268) setdest 68147 17259 4.0" 
$ns at 489.00429737527134 "$node_(268) setdest 46229 22628 14.0" 
$ns at 538.5172178621367 "$node_(268) setdest 16194 18838 2.0" 
$ns at 581.6067410340327 "$node_(268) setdest 64262 27780 2.0" 
$ns at 619.7644040079787 "$node_(268) setdest 51860 26168 9.0" 
$ns at 667.8509637872646 "$node_(268) setdest 93495 19537 11.0" 
$ns at 801.6705477858503 "$node_(268) setdest 122336 15013 12.0" 
$ns at 895.9425931922278 "$node_(268) setdest 22139 14081 16.0" 
$ns at 284.86338167944535 "$node_(269) setdest 20565 36954 8.0" 
$ns at 347.3580066526991 "$node_(269) setdest 127701 2741 16.0" 
$ns at 425.8102961692524 "$node_(269) setdest 48665 16422 10.0" 
$ns at 464.9667418545374 "$node_(269) setdest 36386 43016 4.0" 
$ns at 532.0642344519032 "$node_(269) setdest 73984 8110 14.0" 
$ns at 638.7422337528886 "$node_(269) setdest 130183 14003 8.0" 
$ns at 721.7571219844201 "$node_(269) setdest 105002 18129 15.0" 
$ns at 816.2067015924326 "$node_(269) setdest 66266 24439 13.0" 
$ns at 227.7636642160327 "$node_(270) setdest 120253 44284 15.0" 
$ns at 355.56819197249683 "$node_(270) setdest 42175 37273 4.0" 
$ns at 388.7744153340145 "$node_(270) setdest 103467 27213 17.0" 
$ns at 431.62169406828036 "$node_(270) setdest 81574 22625 15.0" 
$ns at 557.6393437208224 "$node_(270) setdest 29102 35844 3.0" 
$ns at 615.6150916647198 "$node_(270) setdest 97117 16577 1.0" 
$ns at 653.6570939558032 "$node_(270) setdest 103828 20813 12.0" 
$ns at 711.4001729773814 "$node_(270) setdest 89450 38285 10.0" 
$ns at 837.9749928521803 "$node_(270) setdest 92604 35646 15.0" 
$ns at 249.16571916862839 "$node_(271) setdest 68168 24947 5.0" 
$ns at 326.97756316999147 "$node_(271) setdest 48710 28526 4.0" 
$ns at 383.54024127294736 "$node_(271) setdest 25122 35577 7.0" 
$ns at 464.21394739793965 "$node_(271) setdest 128208 11263 11.0" 
$ns at 513.8964359901126 "$node_(271) setdest 48707 22257 19.0" 
$ns at 627.748378759563 "$node_(271) setdest 56830 20913 4.0" 
$ns at 692.7750479939032 "$node_(271) setdest 5064 4614 9.0" 
$ns at 809.6995274298781 "$node_(271) setdest 103676 44615 18.0" 
$ns at 290.47752192892665 "$node_(272) setdest 39190 19809 17.0" 
$ns at 337.9860894331149 "$node_(272) setdest 82208 1485 12.0" 
$ns at 382.5991127237353 "$node_(272) setdest 37142 40925 4.0" 
$ns at 438.5363116136101 "$node_(272) setdest 133656 42709 19.0" 
$ns at 508.6592492218447 "$node_(272) setdest 39369 29007 14.0" 
$ns at 678.355485778759 "$node_(272) setdest 87545 40519 17.0" 
$ns at 715.152023616645 "$node_(272) setdest 27763 8090 14.0" 
$ns at 849.6163139080945 "$node_(272) setdest 94686 32479 5.0" 
$ns at 336.54242609321193 "$node_(273) setdest 51365 25541 1.0" 
$ns at 372.6030149428262 "$node_(273) setdest 22941 7652 2.0" 
$ns at 417.64145872068013 "$node_(273) setdest 32368 16392 17.0" 
$ns at 588.8346297003931 "$node_(273) setdest 47373 15374 2.0" 
$ns at 635.3743780631464 "$node_(273) setdest 31448 36894 8.0" 
$ns at 692.5563264108199 "$node_(273) setdest 129579 34541 11.0" 
$ns at 809.5659418368045 "$node_(273) setdest 101374 30107 7.0" 
$ns at 888.7031425615551 "$node_(273) setdest 70323 42607 10.0" 
$ns at 270.63310816428674 "$node_(274) setdest 131718 44377 2.0" 
$ns at 313.2088428101425 "$node_(274) setdest 2080 15504 5.0" 
$ns at 358.9117826199986 "$node_(274) setdest 93628 24683 19.0" 
$ns at 503.01985108537735 "$node_(274) setdest 131239 4298 6.0" 
$ns at 567.4683662652981 "$node_(274) setdest 71767 19727 13.0" 
$ns at 605.4635054294913 "$node_(274) setdest 44712 43251 16.0" 
$ns at 703.7800069736177 "$node_(274) setdest 107228 37899 1.0" 
$ns at 738.5829234876617 "$node_(274) setdest 132017 30552 9.0" 
$ns at 852.9083229177096 "$node_(274) setdest 63482 5153 9.0" 
$ns at 222.81214798281047 "$node_(275) setdest 127106 37311 19.0" 
$ns at 362.1929776499354 "$node_(275) setdest 40701 8853 5.0" 
$ns at 404.59040372206465 "$node_(275) setdest 108398 41447 16.0" 
$ns at 448.5598220692144 "$node_(275) setdest 13068 14815 7.0" 
$ns at 546.0491270451387 "$node_(275) setdest 7795 28002 14.0" 
$ns at 713.1884818375288 "$node_(275) setdest 88196 19549 2.0" 
$ns at 754.4313491958658 "$node_(275) setdest 44367 7050 1.0" 
$ns at 792.864336451069 "$node_(275) setdest 89999 42488 7.0" 
$ns at 833.76362456513 "$node_(275) setdest 56249 20074 4.0" 
$ns at 892.3290432569668 "$node_(275) setdest 123649 28713 13.0" 
$ns at 246.21146976970613 "$node_(276) setdest 44689 19910 19.0" 
$ns at 341.2117392787284 "$node_(276) setdest 126070 1366 17.0" 
$ns at 403.416907978736 "$node_(276) setdest 121095 34098 13.0" 
$ns at 452.4178374695814 "$node_(276) setdest 33366 30131 7.0" 
$ns at 528.8275511078903 "$node_(276) setdest 34581 34054 2.0" 
$ns at 572.7056832505051 "$node_(276) setdest 72710 16590 16.0" 
$ns at 632.5149967902936 "$node_(276) setdest 59289 41916 16.0" 
$ns at 717.3037970284822 "$node_(276) setdest 65154 21517 11.0" 
$ns at 801.0796756889868 "$node_(276) setdest 92965 24615 13.0" 
$ns at 849.0838141476196 "$node_(276) setdest 60450 33468 10.0" 
$ns at 251.1201863640346 "$node_(277) setdest 13639 19760 1.0" 
$ns at 290.1708951886414 "$node_(277) setdest 49000 14268 5.0" 
$ns at 364.90883730064775 "$node_(277) setdest 66953 28771 2.0" 
$ns at 398.4132701091827 "$node_(277) setdest 126017 33220 13.0" 
$ns at 511.92381407185525 "$node_(277) setdest 10621 32417 5.0" 
$ns at 550.7858916817485 "$node_(277) setdest 128439 16566 9.0" 
$ns at 655.9562044072591 "$node_(277) setdest 131517 41447 15.0" 
$ns at 765.9414903998362 "$node_(277) setdest 90095 1574 10.0" 
$ns at 830.7992552271264 "$node_(277) setdest 47120 8946 13.0" 
$ns at 882.4313740129733 "$node_(277) setdest 62667 23697 15.0" 
$ns at 206.92221714876547 "$node_(278) setdest 81124 17658 6.0" 
$ns at 258.57703970387024 "$node_(278) setdest 101647 43000 16.0" 
$ns at 409.6678420098498 "$node_(278) setdest 35560 12193 6.0" 
$ns at 459.618887277913 "$node_(278) setdest 40807 5812 1.0" 
$ns at 494.2114782515723 "$node_(278) setdest 87194 28730 3.0" 
$ns at 537.743612942071 "$node_(278) setdest 43751 2299 8.0" 
$ns at 645.7704031085067 "$node_(278) setdest 95455 36800 1.0" 
$ns at 683.4253084271006 "$node_(278) setdest 112607 26111 13.0" 
$ns at 782.017750349881 "$node_(278) setdest 55741 23422 15.0" 
$ns at 876.4921612331573 "$node_(278) setdest 103558 3630 6.0" 
$ns at 241.91453178463956 "$node_(279) setdest 36833 7726 2.0" 
$ns at 279.30112144740707 "$node_(279) setdest 29748 17427 8.0" 
$ns at 378.5505537244038 "$node_(279) setdest 93161 11327 18.0" 
$ns at 483.33450589744524 "$node_(279) setdest 98221 9272 2.0" 
$ns at 528.2170664941432 "$node_(279) setdest 27312 42269 11.0" 
$ns at 599.268861741378 "$node_(279) setdest 28456 23394 11.0" 
$ns at 707.5683929607164 "$node_(279) setdest 10716 41980 17.0" 
$ns at 794.1241222549331 "$node_(279) setdest 120186 26375 19.0" 
$ns at 204.45340422914518 "$node_(280) setdest 67205 13607 6.0" 
$ns at 269.7216854345177 "$node_(280) setdest 5315 37284 12.0" 
$ns at 350.3907313755589 "$node_(280) setdest 16757 3035 9.0" 
$ns at 408.6642446321902 "$node_(280) setdest 114255 4354 10.0" 
$ns at 458.6409121864087 "$node_(280) setdest 34748 11958 8.0" 
$ns at 520.623556766753 "$node_(280) setdest 16820 16324 15.0" 
$ns at 690.6918507077465 "$node_(280) setdest 120672 2360 13.0" 
$ns at 841.1756942483081 "$node_(280) setdest 4735 4419 15.0" 
$ns at 274.49467568060396 "$node_(281) setdest 20843 41482 14.0" 
$ns at 390.3261892055823 "$node_(281) setdest 1813 7078 10.0" 
$ns at 429.6266162714306 "$node_(281) setdest 115340 28540 20.0" 
$ns at 574.9071297832635 "$node_(281) setdest 34364 37174 9.0" 
$ns at 616.683112795249 "$node_(281) setdest 16330 16862 5.0" 
$ns at 686.1966321114307 "$node_(281) setdest 41150 15478 14.0" 
$ns at 815.49236501259 "$node_(281) setdest 84724 33733 10.0" 
$ns at 327.37050892202353 "$node_(282) setdest 26292 10259 16.0" 
$ns at 450.67152104855234 "$node_(282) setdest 124405 17010 19.0" 
$ns at 566.9187256440898 "$node_(282) setdest 105507 14851 1.0" 
$ns at 601.0185041166328 "$node_(282) setdest 19046 43692 18.0" 
$ns at 730.033386389763 "$node_(282) setdest 100225 28504 5.0" 
$ns at 763.6684636670136 "$node_(282) setdest 100516 41687 6.0" 
$ns at 807.7031934034674 "$node_(282) setdest 88139 35900 14.0" 
$ns at 274.75294436278216 "$node_(283) setdest 45128 44109 7.0" 
$ns at 343.5468185192735 "$node_(283) setdest 57200 16776 2.0" 
$ns at 377.02134165996733 "$node_(283) setdest 4404 22155 15.0" 
$ns at 479.1089862241329 "$node_(283) setdest 116840 15461 11.0" 
$ns at 594.9842465058678 "$node_(283) setdest 49055 9107 20.0" 
$ns at 671.9533679092184 "$node_(283) setdest 67776 41872 19.0" 
$ns at 766.9257975575998 "$node_(283) setdest 54833 36006 14.0" 
$ns at 853.0384606528818 "$node_(283) setdest 133810 19150 8.0" 
$ns at 230.21204143486298 "$node_(284) setdest 26042 5113 16.0" 
$ns at 291.7066581718846 "$node_(284) setdest 83636 23782 4.0" 
$ns at 336.6576789853959 "$node_(284) setdest 18415 36625 2.0" 
$ns at 382.2022529442891 "$node_(284) setdest 65506 6430 7.0" 
$ns at 452.94429675191594 "$node_(284) setdest 37102 42294 14.0" 
$ns at 520.9636228969557 "$node_(284) setdest 3383 4553 10.0" 
$ns at 574.9154108003876 "$node_(284) setdest 96354 30934 2.0" 
$ns at 620.221492648514 "$node_(284) setdest 44294 44551 7.0" 
$ns at 700.4761034073077 "$node_(284) setdest 64027 32132 15.0" 
$ns at 753.3318527397641 "$node_(284) setdest 110184 41643 8.0" 
$ns at 817.6274713668583 "$node_(284) setdest 36521 41146 12.0" 
$ns at 226.598825945279 "$node_(285) setdest 125478 34661 5.0" 
$ns at 299.42169972749906 "$node_(285) setdest 75241 28167 16.0" 
$ns at 350.11607355235816 "$node_(285) setdest 97202 34997 19.0" 
$ns at 508.6743227355586 "$node_(285) setdest 54981 20144 12.0" 
$ns at 570.5907531817013 "$node_(285) setdest 126580 8843 20.0" 
$ns at 738.6603177313068 "$node_(285) setdest 108243 13092 2.0" 
$ns at 777.9501631235987 "$node_(285) setdest 90644 37739 2.0" 
$ns at 816.071028340642 "$node_(285) setdest 9192 24956 15.0" 
$ns at 389.7704348868039 "$node_(286) setdest 93442 11790 3.0" 
$ns at 434.501278950917 "$node_(286) setdest 78389 43394 1.0" 
$ns at 466.99385721863894 "$node_(286) setdest 75567 28068 16.0" 
$ns at 559.464261613794 "$node_(286) setdest 109359 166 12.0" 
$ns at 649.934936679056 "$node_(286) setdest 9295 31382 20.0" 
$ns at 871.9155122729649 "$node_(286) setdest 8996 33014 15.0" 
$ns at 245.10479474191868 "$node_(287) setdest 70549 28694 8.0" 
$ns at 297.930361372445 "$node_(287) setdest 14719 22981 14.0" 
$ns at 409.65634327981473 "$node_(287) setdest 31229 12519 11.0" 
$ns at 484.37681278496507 "$node_(287) setdest 120380 30640 16.0" 
$ns at 585.6170362623493 "$node_(287) setdest 49120 15773 17.0" 
$ns at 640.8987946046366 "$node_(287) setdest 79233 41240 2.0" 
$ns at 685.0215247309644 "$node_(287) setdest 126506 13001 7.0" 
$ns at 759.1690342762093 "$node_(287) setdest 72970 16372 19.0" 
$ns at 237.08531493873733 "$node_(288) setdest 53510 26858 8.0" 
$ns at 309.9719036031606 "$node_(288) setdest 127513 18800 2.0" 
$ns at 354.0537344939296 "$node_(288) setdest 36366 1768 17.0" 
$ns at 472.86052927344656 "$node_(288) setdest 15243 2541 20.0" 
$ns at 662.5052947850543 "$node_(288) setdest 94201 9889 2.0" 
$ns at 706.2984257041484 "$node_(288) setdest 129873 13390 15.0" 
$ns at 884.7790742619179 "$node_(288) setdest 10009 21423 15.0" 
$ns at 256.37452324895116 "$node_(289) setdest 12910 43321 18.0" 
$ns at 454.7525276768888 "$node_(289) setdest 82156 8851 3.0" 
$ns at 503.43054918250357 "$node_(289) setdest 44057 44118 15.0" 
$ns at 580.147117198391 "$node_(289) setdest 110951 32480 15.0" 
$ns at 635.0197647386823 "$node_(289) setdest 30887 5849 7.0" 
$ns at 733.8489179194376 "$node_(289) setdest 76188 10012 14.0" 
$ns at 796.0795597225629 "$node_(289) setdest 55759 25794 2.0" 
$ns at 832.0634708211747 "$node_(289) setdest 64563 604 15.0" 
$ns at 214.41277865679987 "$node_(290) setdest 121835 10650 1.0" 
$ns at 246.1147644501371 "$node_(290) setdest 104283 28963 13.0" 
$ns at 329.1555422879313 "$node_(290) setdest 24676 40715 19.0" 
$ns at 413.6695918284712 "$node_(290) setdest 130361 5986 16.0" 
$ns at 503.8379352385809 "$node_(290) setdest 6257 36510 4.0" 
$ns at 549.7712453899868 "$node_(290) setdest 80340 34219 5.0" 
$ns at 627.6497682572909 "$node_(290) setdest 101759 13912 11.0" 
$ns at 659.4881603956201 "$node_(290) setdest 6036 36046 4.0" 
$ns at 717.1613390167263 "$node_(290) setdest 37859 9438 4.0" 
$ns at 775.3523331835019 "$node_(290) setdest 117771 25329 15.0" 
$ns at 846.1549496040111 "$node_(290) setdest 66438 12143 19.0" 
$ns at 243.82438708424607 "$node_(291) setdest 9426 17663 14.0" 
$ns at 289.962092462959 "$node_(291) setdest 51312 37857 15.0" 
$ns at 340.4719893168393 "$node_(291) setdest 109747 30033 10.0" 
$ns at 391.0390991080196 "$node_(291) setdest 103674 28159 3.0" 
$ns at 442.4055176901627 "$node_(291) setdest 43588 37587 7.0" 
$ns at 483.6871386404749 "$node_(291) setdest 94970 8746 16.0" 
$ns at 515.135454624209 "$node_(291) setdest 130280 36332 15.0" 
$ns at 673.9750695990418 "$node_(291) setdest 13089 12791 14.0" 
$ns at 730.969875006522 "$node_(291) setdest 114413 22645 20.0" 
$ns at 367.67671638906376 "$node_(292) setdest 106583 42560 19.0" 
$ns at 494.01009923562265 "$node_(292) setdest 99599 43279 2.0" 
$ns at 538.2459535168025 "$node_(292) setdest 127452 24794 11.0" 
$ns at 574.9994284996296 "$node_(292) setdest 126198 29410 1.0" 
$ns at 611.0185684602319 "$node_(292) setdest 45402 24864 17.0" 
$ns at 734.0659670786222 "$node_(292) setdest 2108 34865 13.0" 
$ns at 842.5213944944566 "$node_(292) setdest 47443 15661 19.0" 
$ns at 232.8700787993689 "$node_(293) setdest 34989 38134 12.0" 
$ns at 374.43321061833075 "$node_(293) setdest 32652 5907 5.0" 
$ns at 409.75275557788467 "$node_(293) setdest 80885 4245 5.0" 
$ns at 475.5931143361574 "$node_(293) setdest 24969 21897 7.0" 
$ns at 557.6099971967099 "$node_(293) setdest 19147 12609 18.0" 
$ns at 703.6845754172639 "$node_(293) setdest 30383 29185 14.0" 
$ns at 827.9071656177198 "$node_(293) setdest 36245 17077 14.0" 
$ns at 277.8971344878877 "$node_(294) setdest 42107 41826 8.0" 
$ns at 311.1133036813278 "$node_(294) setdest 46287 4015 2.0" 
$ns at 342.53551604787435 "$node_(294) setdest 11548 23918 9.0" 
$ns at 384.4698662030195 "$node_(294) setdest 95969 38607 13.0" 
$ns at 523.3525917387165 "$node_(294) setdest 123065 11112 12.0" 
$ns at 644.9418843475602 "$node_(294) setdest 128383 7993 8.0" 
$ns at 700.2186061461341 "$node_(294) setdest 120085 16530 8.0" 
$ns at 757.5227634843977 "$node_(294) setdest 117486 23619 12.0" 
$ns at 791.3577442939941 "$node_(294) setdest 43718 36329 13.0" 
$ns at 861.2677675135126 "$node_(294) setdest 97561 6930 4.0" 
$ns at 895.867674192462 "$node_(294) setdest 45738 4529 12.0" 
$ns at 236.81765046432582 "$node_(295) setdest 105851 8220 7.0" 
$ns at 326.5016391554178 "$node_(295) setdest 33789 40957 1.0" 
$ns at 360.5878834546848 "$node_(295) setdest 3463 3024 13.0" 
$ns at 479.0981283743183 "$node_(295) setdest 27178 19121 11.0" 
$ns at 557.1708465679377 "$node_(295) setdest 27227 10718 20.0" 
$ns at 740.3286807688947 "$node_(295) setdest 37373 31432 3.0" 
$ns at 798.638797712313 "$node_(295) setdest 129393 15181 15.0" 
$ns at 867.3146862552808 "$node_(295) setdest 85450 21972 4.0" 
$ns at 244.71337543106637 "$node_(296) setdest 61231 30737 11.0" 
$ns at 274.7771749800836 "$node_(296) setdest 9480 31658 17.0" 
$ns at 357.88687120643647 "$node_(296) setdest 100704 32632 14.0" 
$ns at 397.58691731432776 "$node_(296) setdest 132604 25868 7.0" 
$ns at 458.77796470485544 "$node_(296) setdest 23960 12972 6.0" 
$ns at 490.4237399211988 "$node_(296) setdest 123946 34046 5.0" 
$ns at 531.1789785952732 "$node_(296) setdest 60198 22286 2.0" 
$ns at 564.4784477033453 "$node_(296) setdest 94664 10571 4.0" 
$ns at 604.4588981559065 "$node_(296) setdest 43388 12458 9.0" 
$ns at 638.2819078514418 "$node_(296) setdest 3090 28345 6.0" 
$ns at 699.5283697370304 "$node_(296) setdest 67692 18832 13.0" 
$ns at 796.52604550494 "$node_(296) setdest 12876 24671 6.0" 
$ns at 852.9695648134621 "$node_(296) setdest 86780 17911 15.0" 
$ns at 205.91903356400508 "$node_(297) setdest 116770 21855 14.0" 
$ns at 352.30846432089334 "$node_(297) setdest 44519 32404 3.0" 
$ns at 390.26871159156383 "$node_(297) setdest 69718 23954 19.0" 
$ns at 444.94176889072156 "$node_(297) setdest 118032 39553 11.0" 
$ns at 579.3765701846964 "$node_(297) setdest 17321 26960 18.0" 
$ns at 611.3962967312253 "$node_(297) setdest 85355 8108 15.0" 
$ns at 684.4338766964962 "$node_(297) setdest 77854 10832 7.0" 
$ns at 724.3066100673093 "$node_(297) setdest 18691 185 15.0" 
$ns at 774.7350157559972 "$node_(297) setdest 15881 20702 16.0" 
$ns at 823.3851341081518 "$node_(297) setdest 66734 26465 13.0" 
$ns at 889.7833073653852 "$node_(297) setdest 47080 26499 15.0" 
$ns at 240.90557656995784 "$node_(298) setdest 50210 33923 15.0" 
$ns at 309.74931067438513 "$node_(298) setdest 24566 37952 3.0" 
$ns at 362.39469099606276 "$node_(298) setdest 115876 15273 4.0" 
$ns at 421.32949022195083 "$node_(298) setdest 49267 27007 4.0" 
$ns at 463.2415049151574 "$node_(298) setdest 112468 7386 5.0" 
$ns at 512.1038105808772 "$node_(298) setdest 65616 42170 14.0" 
$ns at 554.5958070418113 "$node_(298) setdest 39672 20284 9.0" 
$ns at 639.3744613681279 "$node_(298) setdest 65966 17796 14.0" 
$ns at 749.2622077165277 "$node_(298) setdest 91533 27796 1.0" 
$ns at 783.0039841399406 "$node_(298) setdest 21183 9306 18.0" 
$ns at 883.145760373166 "$node_(298) setdest 86784 17289 1.0" 
$ns at 233.1662351642794 "$node_(299) setdest 115000 14729 9.0" 
$ns at 291.3746880579076 "$node_(299) setdest 99096 10207 16.0" 
$ns at 338.93596112647975 "$node_(299) setdest 31132 41337 17.0" 
$ns at 470.05786829822085 "$node_(299) setdest 29343 43641 1.0" 
$ns at 501.2529928016494 "$node_(299) setdest 70112 6618 18.0" 
$ns at 636.6330160435956 "$node_(299) setdest 10537 8080 3.0" 
$ns at 669.5030040054656 "$node_(299) setdest 90343 3594 20.0" 
$ns at 815.8778381595721 "$node_(299) setdest 78394 1595 13.0" 
$ns at 871.6951914684905 "$node_(299) setdest 130886 38084 3.0" 
$ns at 316.49200718981274 "$node_(300) setdest 83298 10554 20.0" 
$ns at 424.29634206141174 "$node_(300) setdest 114087 39146 4.0" 
$ns at 471.7662730178354 "$node_(300) setdest 75563 42 8.0" 
$ns at 570.5307625771071 "$node_(300) setdest 52945 30120 13.0" 
$ns at 701.3565658650466 "$node_(300) setdest 73034 27931 5.0" 
$ns at 761.4062964072783 "$node_(300) setdest 109052 39500 12.0" 
$ns at 805.999249767488 "$node_(300) setdest 56041 20345 16.0" 
$ns at 392.90858262882756 "$node_(301) setdest 42184 24491 11.0" 
$ns at 487.7704699515694 "$node_(301) setdest 93209 24090 8.0" 
$ns at 548.4313051958305 "$node_(301) setdest 14314 40712 10.0" 
$ns at 597.1848367434177 "$node_(301) setdest 88888 3834 4.0" 
$ns at 651.7248599058391 "$node_(301) setdest 35339 7661 1.0" 
$ns at 686.6159729096062 "$node_(301) setdest 72887 5456 8.0" 
$ns at 719.5406252069042 "$node_(301) setdest 42790 14243 1.0" 
$ns at 750.731643842195 "$node_(301) setdest 45789 3641 11.0" 
$ns at 786.5296138149477 "$node_(301) setdest 32432 22482 11.0" 
$ns at 328.8467821458117 "$node_(302) setdest 95034 12746 14.0" 
$ns at 445.85119190594935 "$node_(302) setdest 50073 29610 17.0" 
$ns at 512.2603032667301 "$node_(302) setdest 102594 29667 9.0" 
$ns at 620.1173300219266 "$node_(302) setdest 41226 24389 15.0" 
$ns at 707.2423816255089 "$node_(302) setdest 37477 40802 15.0" 
$ns at 751.8065075373697 "$node_(302) setdest 73408 35120 16.0" 
$ns at 837.2676729304314 "$node_(302) setdest 3377 17278 10.0" 
$ns at 894.2150537670648 "$node_(302) setdest 84142 21682 11.0" 
$ns at 300.6926700987928 "$node_(303) setdest 30424 26182 3.0" 
$ns at 333.91127197840774 "$node_(303) setdest 116494 18340 3.0" 
$ns at 378.7198764845102 "$node_(303) setdest 104154 38453 1.0" 
$ns at 412.12833398677435 "$node_(303) setdest 103451 31609 1.0" 
$ns at 442.7416317045419 "$node_(303) setdest 66158 9273 3.0" 
$ns at 487.07964115655477 "$node_(303) setdest 96954 31617 9.0" 
$ns at 539.2706559422942 "$node_(303) setdest 56365 4956 15.0" 
$ns at 611.1978661469424 "$node_(303) setdest 111758 43544 10.0" 
$ns at 722.8157855921007 "$node_(303) setdest 128310 18476 1.0" 
$ns at 754.727669483978 "$node_(303) setdest 64860 29335 1.0" 
$ns at 788.8217090535355 "$node_(303) setdest 18384 35372 9.0" 
$ns at 850.6072950167027 "$node_(303) setdest 125314 9827 17.0" 
$ns at 366.51031371346835 "$node_(304) setdest 13994 34378 8.0" 
$ns at 401.41602784343974 "$node_(304) setdest 130801 2167 12.0" 
$ns at 467.48777505882737 "$node_(304) setdest 132555 2773 3.0" 
$ns at 498.8618136886658 "$node_(304) setdest 104297 39514 8.0" 
$ns at 604.7933726487589 "$node_(304) setdest 21630 29667 18.0" 
$ns at 808.2830775658649 "$node_(304) setdest 44538 20788 5.0" 
$ns at 886.6388042130188 "$node_(304) setdest 31975 28398 9.0" 
$ns at 357.9820766475879 "$node_(305) setdest 125773 26121 20.0" 
$ns at 587.04808565 "$node_(305) setdest 111525 35180 11.0" 
$ns at 631.8761536743643 "$node_(305) setdest 103797 43802 18.0" 
$ns at 762.855969902259 "$node_(305) setdest 23687 15830 7.0" 
$ns at 847.1013527076068 "$node_(305) setdest 2506 23583 1.0" 
$ns at 886.5637629790873 "$node_(305) setdest 95630 620 5.0" 
$ns at 318.0029097817996 "$node_(306) setdest 24058 19740 13.0" 
$ns at 454.19734510850407 "$node_(306) setdest 22703 35055 15.0" 
$ns at 577.3713182870299 "$node_(306) setdest 127673 13141 12.0" 
$ns at 617.1281783149745 "$node_(306) setdest 117245 30714 1.0" 
$ns at 650.2601385889241 "$node_(306) setdest 22304 28812 19.0" 
$ns at 702.0111730117454 "$node_(306) setdest 123399 28536 12.0" 
$ns at 841.1656792492574 "$node_(306) setdest 71934 44597 3.0" 
$ns at 891.9086709315743 "$node_(306) setdest 115074 27484 2.0" 
$ns at 300.617348033896 "$node_(307) setdest 67004 32148 10.0" 
$ns at 416.59500622677854 "$node_(307) setdest 54803 40732 4.0" 
$ns at 466.6329092941462 "$node_(307) setdest 64107 21813 3.0" 
$ns at 523.8030774560596 "$node_(307) setdest 12873 39534 14.0" 
$ns at 688.390973881895 "$node_(307) setdest 90126 37451 17.0" 
$ns at 844.4731571762386 "$node_(307) setdest 32376 28685 4.0" 
$ns at 323.3603420564956 "$node_(308) setdest 51084 30757 12.0" 
$ns at 364.11667307658195 "$node_(308) setdest 12552 1956 20.0" 
$ns at 447.91033916078686 "$node_(308) setdest 134050 26153 2.0" 
$ns at 487.42023033546843 "$node_(308) setdest 35983 24981 4.0" 
$ns at 523.1224738518114 "$node_(308) setdest 131863 5530 17.0" 
$ns at 700.6470920946318 "$node_(308) setdest 83614 10621 17.0" 
$ns at 868.452977215477 "$node_(308) setdest 40379 24167 1.0" 
$ns at 334.19186554275893 "$node_(309) setdest 89546 39027 14.0" 
$ns at 463.2813705071932 "$node_(309) setdest 52997 38096 9.0" 
$ns at 529.3220432878805 "$node_(309) setdest 253 27064 2.0" 
$ns at 568.5989342979865 "$node_(309) setdest 56516 34027 4.0" 
$ns at 626.3915953232176 "$node_(309) setdest 123057 41201 19.0" 
$ns at 841.5710501079177 "$node_(309) setdest 65260 12627 18.0" 
$ns at 313.77365524182846 "$node_(310) setdest 35662 13283 8.0" 
$ns at 386.80247173910334 "$node_(310) setdest 75474 10358 8.0" 
$ns at 473.7897767579732 "$node_(310) setdest 69295 16634 20.0" 
$ns at 612.1414818764758 "$node_(310) setdest 16719 23938 2.0" 
$ns at 647.623138471828 "$node_(310) setdest 38247 24431 14.0" 
$ns at 696.8331462459415 "$node_(310) setdest 60686 16461 19.0" 
$ns at 340.438732789548 "$node_(311) setdest 34572 2813 11.0" 
$ns at 436.2290105541602 "$node_(311) setdest 23445 1952 19.0" 
$ns at 576.0747664080642 "$node_(311) setdest 12560 22989 1.0" 
$ns at 614.8135844653514 "$node_(311) setdest 64534 20632 9.0" 
$ns at 699.2964963231691 "$node_(311) setdest 58504 21326 6.0" 
$ns at 746.334504666057 "$node_(311) setdest 64100 30680 19.0" 
$ns at 840.848319123397 "$node_(311) setdest 40065 31316 10.0" 
$ns at 373.27660000888125 "$node_(312) setdest 95734 29374 15.0" 
$ns at 470.8342658852204 "$node_(312) setdest 81654 10179 13.0" 
$ns at 549.4009515210885 "$node_(312) setdest 58903 7140 13.0" 
$ns at 689.0917024336549 "$node_(312) setdest 53032 230 14.0" 
$ns at 767.0309988905816 "$node_(312) setdest 114457 38739 14.0" 
$ns at 304.7756960012211 "$node_(313) setdest 60714 5453 12.0" 
$ns at 430.8101038433597 "$node_(313) setdest 111565 30790 11.0" 
$ns at 483.5284565812844 "$node_(313) setdest 27495 3254 12.0" 
$ns at 601.16172927862 "$node_(313) setdest 57666 24642 14.0" 
$ns at 710.5284183497922 "$node_(313) setdest 69608 41040 11.0" 
$ns at 740.959914328086 "$node_(313) setdest 50005 11246 15.0" 
$ns at 793.2250018035328 "$node_(313) setdest 54363 32347 7.0" 
$ns at 842.101348056382 "$node_(313) setdest 41937 42890 3.0" 
$ns at 873.6790955878038 "$node_(313) setdest 129327 42497 1.0" 
$ns at 449.9819328765413 "$node_(314) setdest 86400 19695 16.0" 
$ns at 596.225800929651 "$node_(314) setdest 84144 33013 18.0" 
$ns at 682.3775635266791 "$node_(314) setdest 8010 33144 18.0" 
$ns at 789.9876907757189 "$node_(314) setdest 4925 15020 16.0" 
$ns at 357.53971015489304 "$node_(315) setdest 81537 970 5.0" 
$ns at 402.7209652312795 "$node_(315) setdest 57454 37874 20.0" 
$ns at 551.9837775184083 "$node_(315) setdest 109540 37069 6.0" 
$ns at 627.2189054687406 "$node_(315) setdest 106722 6548 11.0" 
$ns at 755.6740068762874 "$node_(315) setdest 22115 37811 15.0" 
$ns at 349.6710715718146 "$node_(316) setdest 92992 27962 12.0" 
$ns at 404.1439388383016 "$node_(316) setdest 127049 11846 5.0" 
$ns at 460.194522707484 "$node_(316) setdest 20225 31026 18.0" 
$ns at 579.5099133901996 "$node_(316) setdest 79426 14289 11.0" 
$ns at 685.6877196479509 "$node_(316) setdest 82122 5262 7.0" 
$ns at 755.6441163523021 "$node_(316) setdest 81989 10577 18.0" 
$ns at 846.4677110136678 "$node_(316) setdest 90006 36625 14.0" 
$ns at 352.70078048734274 "$node_(317) setdest 66975 33735 10.0" 
$ns at 449.97883810571636 "$node_(317) setdest 50844 38112 10.0" 
$ns at 540.1047282499137 "$node_(317) setdest 49136 29162 1.0" 
$ns at 575.2213406074989 "$node_(317) setdest 55754 43983 7.0" 
$ns at 623.0547651340249 "$node_(317) setdest 96851 37167 5.0" 
$ns at 689.8857854777857 "$node_(317) setdest 88355 35450 14.0" 
$ns at 777.3648467401553 "$node_(317) setdest 118793 15714 18.0" 
$ns at 346.0579319399076 "$node_(318) setdest 130687 34839 9.0" 
$ns at 384.5593302926019 "$node_(318) setdest 107556 13311 4.0" 
$ns at 439.90071324091383 "$node_(318) setdest 64059 41678 20.0" 
$ns at 533.6783058455106 "$node_(318) setdest 79844 31059 7.0" 
$ns at 611.4328452947376 "$node_(318) setdest 19307 32083 17.0" 
$ns at 730.7330648396296 "$node_(318) setdest 9982 14289 1.0" 
$ns at 765.529622150466 "$node_(318) setdest 72561 12530 19.0" 
$ns at 368.3931100935773 "$node_(319) setdest 62482 8078 17.0" 
$ns at 521.3921619181824 "$node_(319) setdest 113140 31923 13.0" 
$ns at 623.0783975132161 "$node_(319) setdest 4160 25144 5.0" 
$ns at 680.730649125595 "$node_(319) setdest 79279 22903 12.0" 
$ns at 791.8366746759738 "$node_(319) setdest 117542 23984 9.0" 
$ns at 885.0480305196053 "$node_(319) setdest 73363 27269 3.0" 
$ns at 334.28352324433183 "$node_(320) setdest 20890 30846 20.0" 
$ns at 495.5556341978618 "$node_(320) setdest 118265 27621 8.0" 
$ns at 603.8883295587793 "$node_(320) setdest 77857 42514 13.0" 
$ns at 690.4718571834127 "$node_(320) setdest 60306 4184 9.0" 
$ns at 756.4347035214221 "$node_(320) setdest 113714 43987 15.0" 
$ns at 872.4735760193928 "$node_(320) setdest 12846 25575 11.0" 
$ns at 314.92108299358785 "$node_(321) setdest 130353 27883 3.0" 
$ns at 360.3539744125262 "$node_(321) setdest 29441 23323 2.0" 
$ns at 392.29855521262493 "$node_(321) setdest 1995 39162 2.0" 
$ns at 441.6287667237543 "$node_(321) setdest 69402 14932 2.0" 
$ns at 478.7770733018808 "$node_(321) setdest 114967 26474 15.0" 
$ns at 597.9441985313123 "$node_(321) setdest 56920 15624 2.0" 
$ns at 630.8855125678294 "$node_(321) setdest 128575 35239 8.0" 
$ns at 677.3441901525858 "$node_(321) setdest 88361 9669 8.0" 
$ns at 728.6150709453426 "$node_(321) setdest 52875 5625 5.0" 
$ns at 771.9571349558513 "$node_(321) setdest 112518 30020 18.0" 
$ns at 379.2538421813969 "$node_(322) setdest 15284 32752 12.0" 
$ns at 490.31259109643275 "$node_(322) setdest 47780 21463 16.0" 
$ns at 648.22401573804 "$node_(322) setdest 100629 13968 8.0" 
$ns at 748.4539665713831 "$node_(322) setdest 104494 15181 14.0" 
$ns at 894.1207570519484 "$node_(322) setdest 43872 1548 14.0" 
$ns at 321.9879322571553 "$node_(323) setdest 64258 11304 13.0" 
$ns at 390.11712710380823 "$node_(323) setdest 66068 42188 1.0" 
$ns at 430.09475177261294 "$node_(323) setdest 94089 20429 2.0" 
$ns at 475.5355303811871 "$node_(323) setdest 114726 12357 4.0" 
$ns at 508.3801724208892 "$node_(323) setdest 39834 29421 2.0" 
$ns at 543.9387852550502 "$node_(323) setdest 129908 40302 16.0" 
$ns at 681.2992926977873 "$node_(323) setdest 11554 7313 10.0" 
$ns at 741.5902601080052 "$node_(323) setdest 27906 6147 13.0" 
$ns at 879.7162924915388 "$node_(323) setdest 275 12070 16.0" 
$ns at 335.3699099820508 "$node_(324) setdest 82942 37059 9.0" 
$ns at 369.6910712484016 "$node_(324) setdest 110731 37743 9.0" 
$ns at 465.76140905864185 "$node_(324) setdest 73455 3816 7.0" 
$ns at 498.26912937975095 "$node_(324) setdest 78106 10793 10.0" 
$ns at 594.7858987412174 "$node_(324) setdest 13642 18642 15.0" 
$ns at 659.059886055114 "$node_(324) setdest 51327 16299 2.0" 
$ns at 696.477573923475 "$node_(324) setdest 80201 2855 13.0" 
$ns at 852.2310639196825 "$node_(324) setdest 31986 8001 13.0" 
$ns at 423.462053440883 "$node_(325) setdest 120220 8761 12.0" 
$ns at 505.31486649756135 "$node_(325) setdest 68521 43533 10.0" 
$ns at 560.8442178388453 "$node_(325) setdest 46967 39060 18.0" 
$ns at 708.4659163549705 "$node_(325) setdest 77465 27814 13.0" 
$ns at 842.053166567394 "$node_(325) setdest 19463 3534 9.0" 
$ns at 327.06505293590106 "$node_(326) setdest 53325 4674 3.0" 
$ns at 362.3333334709982 "$node_(326) setdest 15497 19951 11.0" 
$ns at 465.3476420859553 "$node_(326) setdest 132112 23324 14.0" 
$ns at 629.2587503058934 "$node_(326) setdest 61156 15785 1.0" 
$ns at 664.1618290217195 "$node_(326) setdest 4294 25655 3.0" 
$ns at 722.5573874883405 "$node_(326) setdest 23389 16635 6.0" 
$ns at 770.4814105086078 "$node_(326) setdest 61939 32119 7.0" 
$ns at 866.4563852827043 "$node_(326) setdest 28175 20787 10.0" 
$ns at 357.8209489734735 "$node_(327) setdest 121310 21116 5.0" 
$ns at 390.93478851147887 "$node_(327) setdest 2241 16586 9.0" 
$ns at 451.544123082394 "$node_(327) setdest 36142 18627 5.0" 
$ns at 520.7739505320419 "$node_(327) setdest 130375 24277 15.0" 
$ns at 695.4595960633742 "$node_(327) setdest 11918 14942 10.0" 
$ns at 781.3110222530036 "$node_(327) setdest 54382 5183 8.0" 
$ns at 864.4368039531687 "$node_(327) setdest 33017 10966 17.0" 
$ns at 356.09318055516746 "$node_(328) setdest 83029 1047 11.0" 
$ns at 485.7422627360592 "$node_(328) setdest 103546 2558 9.0" 
$ns at 567.5091320161489 "$node_(328) setdest 78634 13180 12.0" 
$ns at 701.9630080223143 "$node_(328) setdest 86156 41112 11.0" 
$ns at 741.5168631417079 "$node_(328) setdest 36274 4392 9.0" 
$ns at 805.7307957828954 "$node_(328) setdest 24762 24951 17.0" 
$ns at 893.9368886957033 "$node_(328) setdest 86332 2139 3.0" 
$ns at 408.7632429694464 "$node_(329) setdest 113421 31993 9.0" 
$ns at 446.3381968821053 "$node_(329) setdest 32799 21540 1.0" 
$ns at 484.4316977700841 "$node_(329) setdest 120679 40278 11.0" 
$ns at 536.5104288024663 "$node_(329) setdest 3998 9243 5.0" 
$ns at 588.4924747340225 "$node_(329) setdest 107228 22930 6.0" 
$ns at 649.5896337502428 "$node_(329) setdest 28773 16435 14.0" 
$ns at 780.4864643755359 "$node_(329) setdest 25256 35265 1.0" 
$ns at 811.0950585414206 "$node_(329) setdest 128984 5861 17.0" 
$ns at 334.35470144055574 "$node_(330) setdest 113139 18847 10.0" 
$ns at 379.33562986954996 "$node_(330) setdest 59409 24346 2.0" 
$ns at 426.4616356370648 "$node_(330) setdest 53709 26455 10.0" 
$ns at 546.5509584674778 "$node_(330) setdest 40183 35626 8.0" 
$ns at 653.1903216517378 "$node_(330) setdest 99324 13253 17.0" 
$ns at 780.6858689570814 "$node_(330) setdest 23055 5219 4.0" 
$ns at 827.7552449238453 "$node_(330) setdest 105954 13664 12.0" 
$ns at 865.4298042785761 "$node_(330) setdest 55242 28741 1.0" 
$ns at 368.4070061342268 "$node_(331) setdest 87179 24160 11.0" 
$ns at 437.26676702099974 "$node_(331) setdest 10815 9405 7.0" 
$ns at 532.1729300650986 "$node_(331) setdest 2590 21696 3.0" 
$ns at 569.5383762282747 "$node_(331) setdest 112194 1972 7.0" 
$ns at 629.2299470201019 "$node_(331) setdest 121509 6956 18.0" 
$ns at 780.0500827090904 "$node_(331) setdest 51487 34703 12.0" 
$ns at 873.82140710856 "$node_(331) setdest 36825 17645 6.0" 
$ns at 305.6177370723068 "$node_(332) setdest 118381 22772 1.0" 
$ns at 338.05453513036747 "$node_(332) setdest 12290 9971 16.0" 
$ns at 514.1289987585342 "$node_(332) setdest 107108 37030 18.0" 
$ns at 713.7998365641222 "$node_(332) setdest 22478 33381 20.0" 
$ns at 878.987646784406 "$node_(332) setdest 66707 22556 12.0" 
$ns at 449.99437615351405 "$node_(333) setdest 47180 16736 17.0" 
$ns at 527.9748026711633 "$node_(333) setdest 107632 5752 15.0" 
$ns at 684.1117792383908 "$node_(333) setdest 53519 32553 6.0" 
$ns at 761.7751491744735 "$node_(333) setdest 47040 32982 17.0" 
$ns at 829.6555866240204 "$node_(333) setdest 4435 23757 13.0" 
$ns at 883.4525108721059 "$node_(333) setdest 126739 27018 11.0" 
$ns at 381.54148469195786 "$node_(334) setdest 131275 26100 19.0" 
$ns at 510.6636574312075 "$node_(334) setdest 133489 4109 16.0" 
$ns at 589.61045180026 "$node_(334) setdest 112097 7925 11.0" 
$ns at 719.5923609451343 "$node_(334) setdest 31551 15793 5.0" 
$ns at 779.3536174373354 "$node_(334) setdest 131570 39721 15.0" 
$ns at 813.3600224274161 "$node_(334) setdest 78100 4184 13.0" 
$ns at 878.0066351483977 "$node_(334) setdest 60985 30302 15.0" 
$ns at 445.26187656978584 "$node_(335) setdest 38617 36271 11.0" 
$ns at 543.7074955330886 "$node_(335) setdest 30203 34717 9.0" 
$ns at 621.6101452436519 "$node_(335) setdest 113520 15491 17.0" 
$ns at 707.5159602110747 "$node_(335) setdest 84747 16751 11.0" 
$ns at 801.6040224742446 "$node_(335) setdest 116206 41843 19.0" 
$ns at 380.1237668329373 "$node_(336) setdest 88594 33891 4.0" 
$ns at 447.94403353280444 "$node_(336) setdest 38160 4519 1.0" 
$ns at 481.92019176767565 "$node_(336) setdest 121894 14672 12.0" 
$ns at 601.4400908127873 "$node_(336) setdest 109062 15251 6.0" 
$ns at 674.5925600266016 "$node_(336) setdest 9339 18938 19.0" 
$ns at 708.6174472446949 "$node_(336) setdest 53590 39343 1.0" 
$ns at 743.3653723192604 "$node_(336) setdest 83948 11692 7.0" 
$ns at 841.3463168487789 "$node_(336) setdest 78006 2803 18.0" 
$ns at 326.77490650666743 "$node_(337) setdest 102014 44126 14.0" 
$ns at 373.21496097305317 "$node_(337) setdest 28063 28367 3.0" 
$ns at 426.3791141324001 "$node_(337) setdest 50083 1312 10.0" 
$ns at 507.76849058336506 "$node_(337) setdest 82380 25734 19.0" 
$ns at 716.9610291494118 "$node_(337) setdest 27897 7844 17.0" 
$ns at 799.2698224701812 "$node_(337) setdest 53713 4880 1.0" 
$ns at 831.574476865471 "$node_(337) setdest 11563 38119 1.0" 
$ns at 869.3886530247661 "$node_(337) setdest 29522 24931 19.0" 
$ns at 345.4311994021103 "$node_(338) setdest 97281 30456 13.0" 
$ns at 500.5317595380979 "$node_(338) setdest 52523 29168 17.0" 
$ns at 631.737093720934 "$node_(338) setdest 77865 41396 7.0" 
$ns at 705.3853701298614 "$node_(338) setdest 41801 32579 4.0" 
$ns at 760.8070694837661 "$node_(338) setdest 44102 30476 19.0" 
$ns at 864.1704361353112 "$node_(338) setdest 3063 17516 14.0" 
$ns at 334.8237676693391 "$node_(339) setdest 94647 28724 14.0" 
$ns at 390.27125406172854 "$node_(339) setdest 119465 10276 18.0" 
$ns at 441.1921731105568 "$node_(339) setdest 128039 17510 1.0" 
$ns at 476.8971781743209 "$node_(339) setdest 81437 15822 12.0" 
$ns at 568.8660028930592 "$node_(339) setdest 29934 838 16.0" 
$ns at 677.517877620102 "$node_(339) setdest 5193 34383 17.0" 
$ns at 749.718682129904 "$node_(339) setdest 19386 18021 1.0" 
$ns at 780.3091596050244 "$node_(339) setdest 49714 4725 10.0" 
$ns at 818.640238951706 "$node_(339) setdest 42581 34395 1.0" 
$ns at 849.3331143579652 "$node_(339) setdest 114871 25183 11.0" 
$ns at 367.60266451715586 "$node_(340) setdest 107022 41161 10.0" 
$ns at 452.2955744073136 "$node_(340) setdest 85856 19711 14.0" 
$ns at 545.9839942003175 "$node_(340) setdest 7960 44185 2.0" 
$ns at 579.6291648167172 "$node_(340) setdest 25450 18964 13.0" 
$ns at 654.2972656540552 "$node_(340) setdest 96239 11120 10.0" 
$ns at 735.3747382720293 "$node_(340) setdest 35576 39887 9.0" 
$ns at 824.2720123848662 "$node_(340) setdest 33405 32956 7.0" 
$ns at 886.1778465044954 "$node_(340) setdest 117098 20776 10.0" 
$ns at 302.6402054568474 "$node_(341) setdest 126410 30845 2.0" 
$ns at 345.82993079865014 "$node_(341) setdest 126288 2627 16.0" 
$ns at 463.80821257730753 "$node_(341) setdest 27060 37391 19.0" 
$ns at 494.6894366182096 "$node_(341) setdest 18895 20836 19.0" 
$ns at 704.4965647267721 "$node_(341) setdest 125294 6720 13.0" 
$ns at 762.9956695607108 "$node_(341) setdest 22960 9704 7.0" 
$ns at 809.7573170066465 "$node_(341) setdest 120761 34829 12.0" 
$ns at 839.9139831410565 "$node_(341) setdest 101541 7666 5.0" 
$ns at 898.4120437699547 "$node_(341) setdest 44734 27227 2.0" 
$ns at 398.3059799934544 "$node_(342) setdest 127942 11786 16.0" 
$ns at 451.6923350457357 "$node_(342) setdest 24613 633 20.0" 
$ns at 536.541043648502 "$node_(342) setdest 31889 3572 12.0" 
$ns at 571.5911259852948 "$node_(342) setdest 117993 27743 1.0" 
$ns at 603.5599748097801 "$node_(342) setdest 42689 3508 16.0" 
$ns at 721.2126727345126 "$node_(342) setdest 41504 38762 14.0" 
$ns at 755.2060163335595 "$node_(342) setdest 65886 21981 6.0" 
$ns at 843.0959540179463 "$node_(342) setdest 13428 6328 16.0" 
$ns at 310.2656988558434 "$node_(343) setdest 122854 20368 3.0" 
$ns at 356.62096102592034 "$node_(343) setdest 27673 19291 1.0" 
$ns at 395.56801819175666 "$node_(343) setdest 84545 24226 9.0" 
$ns at 469.5880753723772 "$node_(343) setdest 27823 16312 14.0" 
$ns at 529.2302887861367 "$node_(343) setdest 15935 25694 12.0" 
$ns at 648.5453196685166 "$node_(343) setdest 117266 43914 2.0" 
$ns at 690.8242460096315 "$node_(343) setdest 76036 22309 5.0" 
$ns at 732.9458672635615 "$node_(343) setdest 114746 6423 12.0" 
$ns at 833.3162626575249 "$node_(343) setdest 54715 2772 14.0" 
$ns at 304.15645156448625 "$node_(344) setdest 118875 36545 13.0" 
$ns at 369.98834671146096 "$node_(344) setdest 108842 27047 3.0" 
$ns at 400.31906336438567 "$node_(344) setdest 106996 37726 16.0" 
$ns at 454.4029596876127 "$node_(344) setdest 126870 10853 7.0" 
$ns at 549.5075002636247 "$node_(344) setdest 17262 13889 2.0" 
$ns at 590.6885086449138 "$node_(344) setdest 42414 11277 6.0" 
$ns at 680.3714085655096 "$node_(344) setdest 23379 36279 5.0" 
$ns at 720.8648650593864 "$node_(344) setdest 73876 22235 10.0" 
$ns at 826.3619989712955 "$node_(344) setdest 44576 23399 1.0" 
$ns at 858.9247762863798 "$node_(344) setdest 127654 36960 18.0" 
$ns at 380.2950108135892 "$node_(345) setdest 51081 1152 3.0" 
$ns at 436.62230135429974 "$node_(345) setdest 76335 24996 11.0" 
$ns at 486.91954607926607 "$node_(345) setdest 111616 6321 15.0" 
$ns at 653.1399122468645 "$node_(345) setdest 40863 34379 14.0" 
$ns at 735.971473507336 "$node_(345) setdest 26405 799 14.0" 
$ns at 806.9998736107451 "$node_(345) setdest 107908 3740 17.0" 
$ns at 851.0378529870882 "$node_(345) setdest 70789 17799 5.0" 
$ns at 381.3859352151844 "$node_(346) setdest 123609 18562 18.0" 
$ns at 550.9325249815229 "$node_(346) setdest 4978 22402 6.0" 
$ns at 605.257971855432 "$node_(346) setdest 114356 32979 12.0" 
$ns at 704.7112237306985 "$node_(346) setdest 38111 20342 6.0" 
$ns at 759.8699204122502 "$node_(346) setdest 125694 13909 8.0" 
$ns at 850.6429481014097 "$node_(346) setdest 48909 19735 10.0" 
$ns at 892.422392014821 "$node_(346) setdest 117877 40139 19.0" 
$ns at 338.0275296841278 "$node_(347) setdest 112535 24812 15.0" 
$ns at 506.57639988880396 "$node_(347) setdest 65751 29888 18.0" 
$ns at 564.1783665325416 "$node_(347) setdest 100901 13158 3.0" 
$ns at 617.9528182308908 "$node_(347) setdest 31261 10604 2.0" 
$ns at 660.6782477678361 "$node_(347) setdest 92380 10774 1.0" 
$ns at 695.5240353027147 "$node_(347) setdest 13716 29423 7.0" 
$ns at 738.5935758084496 "$node_(347) setdest 126762 18407 14.0" 
$ns at 888.4788221896968 "$node_(347) setdest 117808 26786 17.0" 
$ns at 331.3444328448632 "$node_(348) setdest 39877 43293 2.0" 
$ns at 363.12896577672404 "$node_(348) setdest 68637 36674 6.0" 
$ns at 450.9737922317862 "$node_(348) setdest 121532 14218 1.0" 
$ns at 481.2654220864787 "$node_(348) setdest 72225 11513 7.0" 
$ns at 559.7164637997291 "$node_(348) setdest 119714 25516 1.0" 
$ns at 592.2550524291689 "$node_(348) setdest 76920 15852 19.0" 
$ns at 625.7826391578831 "$node_(348) setdest 60346 27357 7.0" 
$ns at 693.5478372301418 "$node_(348) setdest 84169 34665 18.0" 
$ns at 781.9761828298795 "$node_(348) setdest 41555 386 14.0" 
$ns at 344.74614069124715 "$node_(349) setdest 38269 43981 1.0" 
$ns at 380.9314956635864 "$node_(349) setdest 80602 30912 7.0" 
$ns at 429.46399492403845 "$node_(349) setdest 14384 37823 3.0" 
$ns at 474.4028103040034 "$node_(349) setdest 10553 30610 4.0" 
$ns at 511.07028616129855 "$node_(349) setdest 97102 19794 4.0" 
$ns at 567.1881941518322 "$node_(349) setdest 26178 38252 7.0" 
$ns at 649.4039237383209 "$node_(349) setdest 118186 30593 1.0" 
$ns at 685.296348404362 "$node_(349) setdest 87457 21207 9.0" 
$ns at 719.9155731260103 "$node_(349) setdest 24068 31339 6.0" 
$ns at 796.2601727863474 "$node_(349) setdest 105853 25298 14.0" 
$ns at 315.9012344892574 "$node_(350) setdest 48858 148 1.0" 
$ns at 353.93657493387263 "$node_(350) setdest 103011 14452 16.0" 
$ns at 516.107605569297 "$node_(350) setdest 115218 39386 12.0" 
$ns at 556.5092787031516 "$node_(350) setdest 68386 13352 1.0" 
$ns at 589.0406697985522 "$node_(350) setdest 83156 42736 11.0" 
$ns at 728.4586636322689 "$node_(350) setdest 23949 1067 12.0" 
$ns at 855.2104481936846 "$node_(350) setdest 63141 23265 13.0" 
$ns at 351.55686729510364 "$node_(351) setdest 58475 34770 7.0" 
$ns at 448.49839034267455 "$node_(351) setdest 99126 23627 5.0" 
$ns at 486.487370280737 "$node_(351) setdest 16468 23661 11.0" 
$ns at 605.0015706265348 "$node_(351) setdest 106096 39264 4.0" 
$ns at 640.2567325899124 "$node_(351) setdest 54973 27790 14.0" 
$ns at 771.6767647618628 "$node_(351) setdest 29943 5882 8.0" 
$ns at 853.7665068250795 "$node_(351) setdest 52814 15408 7.0" 
$ns at 369.8210255348193 "$node_(352) setdest 122101 40129 6.0" 
$ns at 428.3323000556401 "$node_(352) setdest 96983 32295 8.0" 
$ns at 475.4097081662563 "$node_(352) setdest 111470 12777 16.0" 
$ns at 631.9480379244728 "$node_(352) setdest 34702 43874 8.0" 
$ns at 729.967500389403 "$node_(352) setdest 61430 20943 20.0" 
$ns at 786.2601281408081 "$node_(352) setdest 13942 37892 20.0" 
$ns at 826.1397678746931 "$node_(352) setdest 61209 43800 5.0" 
$ns at 896.904983612666 "$node_(352) setdest 99169 176 4.0" 
$ns at 351.90920418265785 "$node_(353) setdest 42062 43093 11.0" 
$ns at 486.15137017019407 "$node_(353) setdest 91396 7249 9.0" 
$ns at 570.4613073151941 "$node_(353) setdest 51038 30363 19.0" 
$ns at 771.0686970487106 "$node_(353) setdest 66495 2013 6.0" 
$ns at 820.7423701178587 "$node_(353) setdest 107022 22275 18.0" 
$ns at 318.49943781011314 "$node_(354) setdest 2230 15222 19.0" 
$ns at 513.0939487204305 "$node_(354) setdest 124341 32016 3.0" 
$ns at 552.0988110612248 "$node_(354) setdest 12623 34819 11.0" 
$ns at 616.7340413609621 "$node_(354) setdest 66690 35271 4.0" 
$ns at 661.8309522383095 "$node_(354) setdest 30977 15846 5.0" 
$ns at 729.8711477008903 "$node_(354) setdest 87992 40570 18.0" 
$ns at 314.6143185698255 "$node_(355) setdest 129712 41105 11.0" 
$ns at 437.7095851987361 "$node_(355) setdest 84937 25726 14.0" 
$ns at 595.2463355685611 "$node_(355) setdest 92175 41873 13.0" 
$ns at 704.6611715267131 "$node_(355) setdest 19221 23689 11.0" 
$ns at 801.1589735577238 "$node_(355) setdest 97297 43586 12.0" 
$ns at 318.56426402984505 "$node_(356) setdest 32701 18822 13.0" 
$ns at 450.2742566130538 "$node_(356) setdest 54819 11470 5.0" 
$ns at 490.93358045931797 "$node_(356) setdest 20182 31763 10.0" 
$ns at 525.2186953105319 "$node_(356) setdest 129032 20977 11.0" 
$ns at 560.0302544624052 "$node_(356) setdest 88447 30584 20.0" 
$ns at 681.4968033188444 "$node_(356) setdest 72367 2434 6.0" 
$ns at 731.9382661656956 "$node_(356) setdest 91251 16647 4.0" 
$ns at 794.4907450927807 "$node_(356) setdest 4921 2804 18.0" 
$ns at 384.1210006272102 "$node_(357) setdest 67150 31445 7.0" 
$ns at 423.16034181048116 "$node_(357) setdest 20556 17651 16.0" 
$ns at 504.62860715911387 "$node_(357) setdest 121678 43469 15.0" 
$ns at 667.8295863509607 "$node_(357) setdest 131047 32715 18.0" 
$ns at 820.1083642976753 "$node_(357) setdest 12939 18369 1.0" 
$ns at 855.8049080991108 "$node_(357) setdest 54571 14914 8.0" 
$ns at 359.0743442687032 "$node_(358) setdest 9622 42794 3.0" 
$ns at 392.876326004342 "$node_(358) setdest 113337 169 14.0" 
$ns at 464.4549249647764 "$node_(358) setdest 20576 1061 14.0" 
$ns at 510.34501016582476 "$node_(358) setdest 66940 19762 18.0" 
$ns at 544.5508413870458 "$node_(358) setdest 126662 40620 7.0" 
$ns at 613.7896692492086 "$node_(358) setdest 5038 37571 2.0" 
$ns at 660.4287946272008 "$node_(358) setdest 10504 22601 11.0" 
$ns at 785.7415286679388 "$node_(358) setdest 54524 39897 5.0" 
$ns at 819.462845320324 "$node_(358) setdest 76484 1232 20.0" 
$ns at 373.1568438523783 "$node_(359) setdest 130766 12136 3.0" 
$ns at 430.1871094333902 "$node_(359) setdest 5944 28108 13.0" 
$ns at 528.4558326840536 "$node_(359) setdest 93461 30612 15.0" 
$ns at 697.9755970346692 "$node_(359) setdest 118061 28258 10.0" 
$ns at 768.6414610353556 "$node_(359) setdest 132288 13055 5.0" 
$ns at 839.861083650127 "$node_(359) setdest 58509 16849 6.0" 
$ns at 379.04617736083355 "$node_(360) setdest 23037 30688 15.0" 
$ns at 451.69597239738437 "$node_(360) setdest 24288 29366 9.0" 
$ns at 560.4582915626032 "$node_(360) setdest 120337 30928 15.0" 
$ns at 714.1065412789203 "$node_(360) setdest 119976 43050 12.0" 
$ns at 854.5451009616106 "$node_(360) setdest 94014 43268 12.0" 
$ns at 363.14784043728633 "$node_(361) setdest 96759 2656 11.0" 
$ns at 430.7244103634632 "$node_(361) setdest 53829 37985 19.0" 
$ns at 482.77501201833894 "$node_(361) setdest 74507 22165 14.0" 
$ns at 558.9980242823498 "$node_(361) setdest 28775 40431 17.0" 
$ns at 697.8390821707511 "$node_(361) setdest 131004 14455 11.0" 
$ns at 780.8333805423943 "$node_(361) setdest 88001 33691 4.0" 
$ns at 825.3905294757379 "$node_(361) setdest 23652 12053 8.0" 
$ns at 339.90530723914713 "$node_(362) setdest 129603 35729 17.0" 
$ns at 429.60823452431686 "$node_(362) setdest 61305 28997 8.0" 
$ns at 479.2371396826834 "$node_(362) setdest 86410 38531 1.0" 
$ns at 516.3879395289529 "$node_(362) setdest 59505 176 9.0" 
$ns at 619.604911944833 "$node_(362) setdest 101113 38170 7.0" 
$ns at 680.3854624277168 "$node_(362) setdest 91162 10366 1.0" 
$ns at 716.1010892266719 "$node_(362) setdest 50069 8722 1.0" 
$ns at 750.3392689049375 "$node_(362) setdest 21831 8539 16.0" 
$ns at 313.0486957395087 "$node_(363) setdest 33019 20185 18.0" 
$ns at 364.3763347971818 "$node_(363) setdest 109592 3304 2.0" 
$ns at 408.074761117943 "$node_(363) setdest 3877 8373 4.0" 
$ns at 441.5490973492929 "$node_(363) setdest 121270 40575 10.0" 
$ns at 477.6447766147804 "$node_(363) setdest 97656 19645 13.0" 
$ns at 635.6078433359407 "$node_(363) setdest 103635 11689 5.0" 
$ns at 694.5492703428619 "$node_(363) setdest 17052 39734 1.0" 
$ns at 733.4004824307885 "$node_(363) setdest 80153 42673 3.0" 
$ns at 790.0294480460313 "$node_(363) setdest 8851 13364 6.0" 
$ns at 824.5067450044329 "$node_(363) setdest 8217 38395 6.0" 
$ns at 310.2823766190643 "$node_(364) setdest 14264 16136 11.0" 
$ns at 377.16057105426364 "$node_(364) setdest 13467 19550 6.0" 
$ns at 442.65341848997593 "$node_(364) setdest 5038 37772 15.0" 
$ns at 621.8150868502895 "$node_(364) setdest 54271 2622 9.0" 
$ns at 731.6549404776118 "$node_(364) setdest 9675 14149 11.0" 
$ns at 790.2372382744868 "$node_(364) setdest 29988 27160 9.0" 
$ns at 847.1948737961911 "$node_(364) setdest 67765 7926 3.0" 
$ns at 888.2055245175928 "$node_(364) setdest 19649 42183 19.0" 
$ns at 332.4578977710304 "$node_(365) setdest 117776 11491 7.0" 
$ns at 383.9093158623358 "$node_(365) setdest 82970 19983 10.0" 
$ns at 505.0306924040473 "$node_(365) setdest 38885 43721 4.0" 
$ns at 574.5585124921201 "$node_(365) setdest 100343 26413 15.0" 
$ns at 658.1056491927199 "$node_(365) setdest 125162 8664 20.0" 
$ns at 886.7575961448188 "$node_(365) setdest 37760 10613 5.0" 
$ns at 308.8755087409444 "$node_(366) setdest 42694 28612 2.0" 
$ns at 342.47303070765247 "$node_(366) setdest 8845 8659 1.0" 
$ns at 378.1422393330264 "$node_(366) setdest 107770 38816 19.0" 
$ns at 505.5749472650574 "$node_(366) setdest 128882 12571 14.0" 
$ns at 612.2893372908818 "$node_(366) setdest 131596 19775 4.0" 
$ns at 669.9358862947578 "$node_(366) setdest 87232 1228 2.0" 
$ns at 700.2975060834085 "$node_(366) setdest 30655 2260 8.0" 
$ns at 804.9269263285368 "$node_(366) setdest 26402 13842 14.0" 
$ns at 344.5355023894344 "$node_(367) setdest 116220 35375 13.0" 
$ns at 383.73471716444465 "$node_(367) setdest 42082 9928 11.0" 
$ns at 454.468697172676 "$node_(367) setdest 101986 25461 1.0" 
$ns at 487.2976920998663 "$node_(367) setdest 106648 31243 18.0" 
$ns at 675.6498982474574 "$node_(367) setdest 10945 42680 12.0" 
$ns at 822.3192959437762 "$node_(367) setdest 14557 27687 16.0" 
$ns at 345.8147126796836 "$node_(368) setdest 124666 4708 10.0" 
$ns at 434.2655738055863 "$node_(368) setdest 26092 3519 1.0" 
$ns at 465.77140649114176 "$node_(368) setdest 68655 42175 18.0" 
$ns at 531.0969027597635 "$node_(368) setdest 86187 6316 9.0" 
$ns at 594.9489584947585 "$node_(368) setdest 103880 40668 4.0" 
$ns at 652.2315543923825 "$node_(368) setdest 44858 15585 1.0" 
$ns at 688.7183486089974 "$node_(368) setdest 105037 35758 6.0" 
$ns at 740.6765830225661 "$node_(368) setdest 4334 29213 19.0" 
$ns at 391.3473033605689 "$node_(369) setdest 127935 21964 5.0" 
$ns at 440.7339510171902 "$node_(369) setdest 101440 20217 16.0" 
$ns at 522.135951227777 "$node_(369) setdest 126617 22844 5.0" 
$ns at 596.6754602332762 "$node_(369) setdest 84136 30557 3.0" 
$ns at 651.1197366441489 "$node_(369) setdest 58126 40623 13.0" 
$ns at 759.9209218607396 "$node_(369) setdest 89197 26825 11.0" 
$ns at 898.7504265929937 "$node_(369) setdest 50991 39214 8.0" 
$ns at 313.6981612068727 "$node_(370) setdest 43378 13772 16.0" 
$ns at 491.345271452399 "$node_(370) setdest 56551 15353 6.0" 
$ns at 563.2497636333007 "$node_(370) setdest 7721 26111 17.0" 
$ns at 600.5622542767428 "$node_(370) setdest 67859 38175 15.0" 
$ns at 633.584174039298 "$node_(370) setdest 58286 23197 11.0" 
$ns at 668.4056317866887 "$node_(370) setdest 92841 28945 18.0" 
$ns at 802.9813959054186 "$node_(370) setdest 12017 18144 19.0" 
$ns at 328.2609354422666 "$node_(371) setdest 41502 26245 13.0" 
$ns at 396.24096388951637 "$node_(371) setdest 63838 34179 13.0" 
$ns at 435.6623738508776 "$node_(371) setdest 18484 12577 7.0" 
$ns at 477.8325164593311 "$node_(371) setdest 726 31134 12.0" 
$ns at 590.5112606923785 "$node_(371) setdest 125288 5309 13.0" 
$ns at 627.6708865073011 "$node_(371) setdest 34893 31 7.0" 
$ns at 673.3203532230897 "$node_(371) setdest 614 24730 16.0" 
$ns at 815.7818399730853 "$node_(371) setdest 93158 36365 12.0" 
$ns at 874.110144942954 "$node_(371) setdest 26146 1190 11.0" 
$ns at 349.0352224828993 "$node_(372) setdest 76847 27264 3.0" 
$ns at 387.75927132831 "$node_(372) setdest 25118 28130 9.0" 
$ns at 453.97974577052224 "$node_(372) setdest 20898 31310 7.0" 
$ns at 547.6509861730683 "$node_(372) setdest 2366 36889 14.0" 
$ns at 595.6051486420981 "$node_(372) setdest 39507 37591 15.0" 
$ns at 638.3943529977656 "$node_(372) setdest 36331 34844 17.0" 
$ns at 703.3385692902515 "$node_(372) setdest 58293 4828 5.0" 
$ns at 742.2496006180702 "$node_(372) setdest 83391 1067 3.0" 
$ns at 794.8589353800922 "$node_(372) setdest 30453 35669 16.0" 
$ns at 825.1795376758625 "$node_(372) setdest 8985 6539 7.0" 
$ns at 352.3736874715023 "$node_(373) setdest 15823 2524 4.0" 
$ns at 413.1907656743689 "$node_(373) setdest 106544 12593 15.0" 
$ns at 509.8163605766158 "$node_(373) setdest 85602 32315 12.0" 
$ns at 551.2716559996866 "$node_(373) setdest 61403 31187 3.0" 
$ns at 593.7407746252261 "$node_(373) setdest 24480 40388 8.0" 
$ns at 654.42781945223 "$node_(373) setdest 80814 22722 7.0" 
$ns at 692.3881291871738 "$node_(373) setdest 19385 22107 11.0" 
$ns at 734.9750651132056 "$node_(373) setdest 86400 8707 2.0" 
$ns at 771.4634580652413 "$node_(373) setdest 9411 43813 20.0" 
$ns at 853.4712006132405 "$node_(373) setdest 10788 9785 18.0" 
$ns at 320.89184974649686 "$node_(374) setdest 23363 7974 8.0" 
$ns at 386.5154150509579 "$node_(374) setdest 85063 15954 7.0" 
$ns at 479.85161396401264 "$node_(374) setdest 129867 37156 1.0" 
$ns at 510.12467956500365 "$node_(374) setdest 32407 24565 14.0" 
$ns at 620.2119779472968 "$node_(374) setdest 75675 22166 8.0" 
$ns at 717.6773392666499 "$node_(374) setdest 38245 42483 11.0" 
$ns at 854.4677702361673 "$node_(374) setdest 30977 41989 19.0" 
$ns at 356.30255876126546 "$node_(375) setdest 52073 40853 1.0" 
$ns at 394.8266798623126 "$node_(375) setdest 105011 30535 3.0" 
$ns at 426.360571709333 "$node_(375) setdest 99196 8532 8.0" 
$ns at 473.88611483770865 "$node_(375) setdest 49029 2223 13.0" 
$ns at 549.8563471876181 "$node_(375) setdest 124081 2819 15.0" 
$ns at 603.109574101478 "$node_(375) setdest 122873 33774 9.0" 
$ns at 706.4170529656019 "$node_(375) setdest 52159 34564 4.0" 
$ns at 745.7421830863331 "$node_(375) setdest 114582 41294 1.0" 
$ns at 778.5760589557569 "$node_(375) setdest 131315 10005 20.0" 
$ns at 403.58433827146627 "$node_(376) setdest 62237 7139 2.0" 
$ns at 435.3307137666679 "$node_(376) setdest 1692 41136 14.0" 
$ns at 584.0082666627441 "$node_(376) setdest 122245 40040 1.0" 
$ns at 621.0832950464496 "$node_(376) setdest 96004 4577 7.0" 
$ns at 652.2561940155821 "$node_(376) setdest 36468 10789 14.0" 
$ns at 741.7650972735507 "$node_(376) setdest 8604 13747 14.0" 
$ns at 774.821459402774 "$node_(376) setdest 107868 38584 8.0" 
$ns at 867.0120272504147 "$node_(376) setdest 128753 19821 12.0" 
$ns at 339.396405666282 "$node_(377) setdest 19045 23106 9.0" 
$ns at 416.5818880644705 "$node_(377) setdest 42904 1190 6.0" 
$ns at 453.965100673645 "$node_(377) setdest 132515 24735 18.0" 
$ns at 608.6531872280314 "$node_(377) setdest 114212 14442 7.0" 
$ns at 687.1281397985721 "$node_(377) setdest 131852 17931 1.0" 
$ns at 723.8201406989709 "$node_(377) setdest 23095 33325 6.0" 
$ns at 758.3236272776332 "$node_(377) setdest 83162 32025 11.0" 
$ns at 842.5634535528575 "$node_(377) setdest 44007 1068 14.0" 
$ns at 301.5527498309177 "$node_(378) setdest 3221 26776 1.0" 
$ns at 338.574545199921 "$node_(378) setdest 63841 33745 7.0" 
$ns at 375.80668364284304 "$node_(378) setdest 22882 40144 15.0" 
$ns at 433.944034020008 "$node_(378) setdest 67715 665 3.0" 
$ns at 478.9263676776335 "$node_(378) setdest 130449 29797 6.0" 
$ns at 554.3789043400316 "$node_(378) setdest 52113 31251 6.0" 
$ns at 606.2819742246508 "$node_(378) setdest 7421 6165 1.0" 
$ns at 643.7543849724043 "$node_(378) setdest 24501 23465 16.0" 
$ns at 737.1875132856941 "$node_(378) setdest 34022 15835 1.0" 
$ns at 775.62451723771 "$node_(378) setdest 42295 36284 4.0" 
$ns at 836.5842485635717 "$node_(378) setdest 48680 31650 9.0" 
$ns at 880.6029645452642 "$node_(378) setdest 11731 16535 18.0" 
$ns at 354.6991905089877 "$node_(379) setdest 105276 864 20.0" 
$ns at 552.7064133239121 "$node_(379) setdest 66926 39267 15.0" 
$ns at 717.3883469636846 "$node_(379) setdest 107866 34566 10.0" 
$ns at 758.5174976860643 "$node_(379) setdest 60938 17461 9.0" 
$ns at 829.961199399169 "$node_(379) setdest 69302 24958 13.0" 
$ns at 413.4923896833792 "$node_(380) setdest 116048 19676 5.0" 
$ns at 444.7816309168305 "$node_(380) setdest 125716 28330 6.0" 
$ns at 496.59177841014275 "$node_(380) setdest 110456 15099 6.0" 
$ns at 563.4691980280522 "$node_(380) setdest 125367 4475 9.0" 
$ns at 646.1665830994534 "$node_(380) setdest 27180 23477 19.0" 
$ns at 773.9600026029971 "$node_(380) setdest 41759 18789 4.0" 
$ns at 838.8260262110675 "$node_(380) setdest 92478 14388 17.0" 
$ns at 353.62590176552897 "$node_(381) setdest 39889 24602 20.0" 
$ns at 512.4301754608673 "$node_(381) setdest 66802 16427 10.0" 
$ns at 632.0679979549667 "$node_(381) setdest 34923 15364 15.0" 
$ns at 712.6193496138791 "$node_(381) setdest 36052 34793 7.0" 
$ns at 745.1388031377412 "$node_(381) setdest 13885 37165 1.0" 
$ns at 781.6678985481392 "$node_(381) setdest 122912 3055 5.0" 
$ns at 832.6820622078669 "$node_(381) setdest 30455 30270 2.0" 
$ns at 881.537885015087 "$node_(381) setdest 103404 667 12.0" 
$ns at 396.2458634845642 "$node_(382) setdest 48766 26746 19.0" 
$ns at 544.0675310798116 "$node_(382) setdest 27204 43108 10.0" 
$ns at 640.6433324051866 "$node_(382) setdest 23279 38828 10.0" 
$ns at 687.1772696568271 "$node_(382) setdest 60771 31541 19.0" 
$ns at 728.6198668989081 "$node_(382) setdest 2280 10609 3.0" 
$ns at 767.4619404593034 "$node_(382) setdest 69418 724 19.0" 
$ns at 309.82569780088113 "$node_(383) setdest 109264 11757 4.0" 
$ns at 359.268728070009 "$node_(383) setdest 133358 7090 3.0" 
$ns at 403.0935438421685 "$node_(383) setdest 98670 28350 11.0" 
$ns at 438.50785722810195 "$node_(383) setdest 53108 33819 1.0" 
$ns at 474.66930759689035 "$node_(383) setdest 126522 2848 18.0" 
$ns at 610.4169573414163 "$node_(383) setdest 2304 3226 6.0" 
$ns at 642.7435312170059 "$node_(383) setdest 80308 27056 1.0" 
$ns at 674.2531786137661 "$node_(383) setdest 80595 19307 12.0" 
$ns at 747.9996115477375 "$node_(383) setdest 74539 13698 5.0" 
$ns at 784.1417914786597 "$node_(383) setdest 42105 11620 16.0" 
$ns at 351.16097477174947 "$node_(384) setdest 79866 28228 8.0" 
$ns at 447.1229790004227 "$node_(384) setdest 71258 2163 5.0" 
$ns at 514.0504839518819 "$node_(384) setdest 6445 14090 14.0" 
$ns at 576.9524854288505 "$node_(384) setdest 117568 2366 20.0" 
$ns at 705.5071844778149 "$node_(384) setdest 97952 26274 6.0" 
$ns at 792.6669198886797 "$node_(384) setdest 106241 6876 10.0" 
$ns at 849.5636930417332 "$node_(384) setdest 43971 9831 11.0" 
$ns at 440.6141506939854 "$node_(385) setdest 22559 42950 6.0" 
$ns at 477.31531949855633 "$node_(385) setdest 34830 29142 11.0" 
$ns at 556.9930818744627 "$node_(385) setdest 36942 31013 2.0" 
$ns at 593.592876559661 "$node_(385) setdest 111452 29504 17.0" 
$ns at 668.8728111500254 "$node_(385) setdest 133001 41831 1.0" 
$ns at 704.8992094521722 "$node_(385) setdest 5005 31367 4.0" 
$ns at 763.1668782609127 "$node_(385) setdest 102965 7937 14.0" 
$ns at 802.852413395933 "$node_(385) setdest 101055 28763 18.0" 
$ns at 322.6645847976588 "$node_(386) setdest 30638 34802 18.0" 
$ns at 406.40503255626345 "$node_(386) setdest 15880 27463 1.0" 
$ns at 437.03837797334035 "$node_(386) setdest 51283 43644 9.0" 
$ns at 494.02674425570854 "$node_(386) setdest 41407 1771 13.0" 
$ns at 524.3852481189462 "$node_(386) setdest 22711 17913 15.0" 
$ns at 686.278366486671 "$node_(386) setdest 42415 18111 15.0" 
$ns at 844.827199350556 "$node_(386) setdest 95461 8567 12.0" 
$ns at 880.4826771204279 "$node_(386) setdest 73992 36529 18.0" 
$ns at 432.3337972279724 "$node_(387) setdest 7997 2845 3.0" 
$ns at 486.71870210708255 "$node_(387) setdest 129190 4382 1.0" 
$ns at 517.3885629812108 "$node_(387) setdest 33579 30166 6.0" 
$ns at 552.4037762606464 "$node_(387) setdest 7251 33263 18.0" 
$ns at 597.707166127838 "$node_(387) setdest 49184 11843 12.0" 
$ns at 641.5135439776698 "$node_(387) setdest 12228 9090 17.0" 
$ns at 683.0061870421121 "$node_(387) setdest 82991 9507 9.0" 
$ns at 742.9395908148929 "$node_(387) setdest 133901 28234 14.0" 
$ns at 863.5155301473386 "$node_(387) setdest 112211 169 1.0" 
$ns at 896.1879777200721 "$node_(387) setdest 4737 2812 1.0" 
$ns at 380.50384628373297 "$node_(388) setdest 34786 11202 13.0" 
$ns at 433.96512457892277 "$node_(388) setdest 104368 5436 19.0" 
$ns at 535.2815423743817 "$node_(388) setdest 11957 30450 13.0" 
$ns at 622.9738117687533 "$node_(388) setdest 88527 18575 3.0" 
$ns at 664.9504245608821 "$node_(388) setdest 110808 34843 19.0" 
$ns at 760.4630486785086 "$node_(388) setdest 7777 4064 17.0" 
$ns at 323.5594488923671 "$node_(389) setdest 52770 36070 8.0" 
$ns at 356.8642587243069 "$node_(389) setdest 51812 9496 6.0" 
$ns at 421.03792433978055 "$node_(389) setdest 52096 40015 13.0" 
$ns at 457.5817759746932 "$node_(389) setdest 80812 14393 7.0" 
$ns at 521.4393484716877 "$node_(389) setdest 10109 32705 4.0" 
$ns at 568.4374244933996 "$node_(389) setdest 11500 40033 7.0" 
$ns at 650.4315253165917 "$node_(389) setdest 129848 8963 7.0" 
$ns at 697.0411639179104 "$node_(389) setdest 97312 18550 13.0" 
$ns at 821.2069350296517 "$node_(389) setdest 55519 6434 3.0" 
$ns at 874.6735246360273 "$node_(389) setdest 108695 34897 8.0" 
$ns at 326.7148039992858 "$node_(390) setdest 90286 31520 19.0" 
$ns at 530.3561345771728 "$node_(390) setdest 71845 8014 14.0" 
$ns at 631.5192282637142 "$node_(390) setdest 28769 37875 8.0" 
$ns at 716.3261492440959 "$node_(390) setdest 131051 34905 10.0" 
$ns at 783.0753357411966 "$node_(390) setdest 25756 42395 17.0" 
$ns at 852.3782645105306 "$node_(390) setdest 120733 42677 6.0" 
$ns at 887.0803158168286 "$node_(390) setdest 93645 14358 9.0" 
$ns at 311.9658049515007 "$node_(391) setdest 131110 371 5.0" 
$ns at 356.317074271681 "$node_(391) setdest 53366 4482 19.0" 
$ns at 388.89217945575365 "$node_(391) setdest 33319 19838 9.0" 
$ns at 451.51109645613747 "$node_(391) setdest 19589 33705 3.0" 
$ns at 499.61357027670385 "$node_(391) setdest 36970 32092 14.0" 
$ns at 582.8575862859426 "$node_(391) setdest 47950 35188 5.0" 
$ns at 649.5998863332318 "$node_(391) setdest 18856 16795 12.0" 
$ns at 680.0286411536854 "$node_(391) setdest 91210 8737 19.0" 
$ns at 868.8932449965025 "$node_(391) setdest 113919 7005 17.0" 
$ns at 374.34805336092313 "$node_(392) setdest 109909 8279 14.0" 
$ns at 481.395577120444 "$node_(392) setdest 61116 31946 16.0" 
$ns at 630.3287013547554 "$node_(392) setdest 5658 25004 5.0" 
$ns at 705.4066532674749 "$node_(392) setdest 60450 3612 13.0" 
$ns at 748.4887293705874 "$node_(392) setdest 52536 40214 17.0" 
$ns at 854.607824240692 "$node_(392) setdest 95102 5994 8.0" 
$ns at 375.5393898119278 "$node_(393) setdest 105169 4167 19.0" 
$ns at 520.2410882331383 "$node_(393) setdest 65240 19052 19.0" 
$ns at 687.9816651886188 "$node_(393) setdest 92413 11810 5.0" 
$ns at 739.2556932059404 "$node_(393) setdest 93407 22822 9.0" 
$ns at 832.6322579119624 "$node_(393) setdest 62737 42823 7.0" 
$ns at 879.6500475080782 "$node_(393) setdest 105924 35077 4.0" 
$ns at 336.79826841530365 "$node_(394) setdest 39268 7845 18.0" 
$ns at 544.4172233966435 "$node_(394) setdest 85189 9549 14.0" 
$ns at 706.3284586712613 "$node_(394) setdest 25059 6749 5.0" 
$ns at 772.0456033013168 "$node_(394) setdest 7782 40343 8.0" 
$ns at 829.1071837001068 "$node_(394) setdest 39414 11985 4.0" 
$ns at 890.9094891959023 "$node_(394) setdest 55222 29307 1.0" 
$ns at 311.17231161990804 "$node_(395) setdest 106272 32388 10.0" 
$ns at 400.52735225452653 "$node_(395) setdest 91863 41242 17.0" 
$ns at 447.2128000096999 "$node_(395) setdest 89468 32340 11.0" 
$ns at 565.0231093292074 "$node_(395) setdest 104677 10635 20.0" 
$ns at 720.185401894144 "$node_(395) setdest 8010 12156 11.0" 
$ns at 758.1989503187738 "$node_(395) setdest 47756 20767 2.0" 
$ns at 804.3196779353101 "$node_(395) setdest 66091 3113 10.0" 
$ns at 864.0777185682226 "$node_(395) setdest 115730 13760 15.0" 
$ns at 377.9901291241111 "$node_(396) setdest 6050 15495 12.0" 
$ns at 475.20355178763543 "$node_(396) setdest 126076 14230 5.0" 
$ns at 535.1747239129986 "$node_(396) setdest 33829 20857 13.0" 
$ns at 618.2296183773426 "$node_(396) setdest 49327 22986 12.0" 
$ns at 667.6256177202248 "$node_(396) setdest 92888 38634 8.0" 
$ns at 720.5629773378607 "$node_(396) setdest 48663 12019 11.0" 
$ns at 798.6574642145321 "$node_(396) setdest 103581 41483 7.0" 
$ns at 893.5539726858664 "$node_(396) setdest 48574 28246 10.0" 
$ns at 336.9518019538509 "$node_(397) setdest 56827 5990 6.0" 
$ns at 366.9727891431213 "$node_(397) setdest 56345 36063 18.0" 
$ns at 567.9016988660634 "$node_(397) setdest 105921 19788 16.0" 
$ns at 715.8532274178528 "$node_(397) setdest 132833 30101 7.0" 
$ns at 762.440250192996 "$node_(397) setdest 4583 12873 9.0" 
$ns at 826.8223087235144 "$node_(397) setdest 37089 11658 10.0" 
$ns at 320.00407651316215 "$node_(398) setdest 53641 12537 11.0" 
$ns at 386.42887441325365 "$node_(398) setdest 129073 13910 10.0" 
$ns at 461.68914509839055 "$node_(398) setdest 55981 35707 16.0" 
$ns at 585.1169944034727 "$node_(398) setdest 62139 9469 10.0" 
$ns at 696.3710834801724 "$node_(398) setdest 25628 8833 13.0" 
$ns at 756.5924294438456 "$node_(398) setdest 110769 41861 4.0" 
$ns at 807.3426527370307 "$node_(398) setdest 74412 41461 6.0" 
$ns at 866.5598144720232 "$node_(398) setdest 72402 40316 14.0" 
$ns at 335.35988355181325 "$node_(399) setdest 107628 44413 9.0" 
$ns at 417.21843047889166 "$node_(399) setdest 98573 37839 10.0" 
$ns at 448.7387759530152 "$node_(399) setdest 118472 38275 11.0" 
$ns at 489.8157650831263 "$node_(399) setdest 42109 37451 3.0" 
$ns at 539.8140211012812 "$node_(399) setdest 84165 32067 6.0" 
$ns at 613.0005698029963 "$node_(399) setdest 19887 33061 7.0" 
$ns at 665.1138718206114 "$node_(399) setdest 26550 15899 19.0" 
$ns at 739.3672049007021 "$node_(399) setdest 71759 3575 16.0" 
$ns at 410.05147501909204 "$node_(400) setdest 83678 42190 13.0" 
$ns at 493.4308532180379 "$node_(400) setdest 90098 41114 9.0" 
$ns at 575.0642206840712 "$node_(400) setdest 27927 1496 18.0" 
$ns at 706.9314904058501 "$node_(400) setdest 32533 8233 2.0" 
$ns at 739.3292972728432 "$node_(400) setdest 73851 1627 17.0" 
$ns at 885.4056734101716 "$node_(400) setdest 60751 23782 17.0" 
$ns at 427.2862343488638 "$node_(401) setdest 108556 9430 4.0" 
$ns at 484.75553675664264 "$node_(401) setdest 96271 41617 1.0" 
$ns at 521.982459659497 "$node_(401) setdest 123296 5755 15.0" 
$ns at 666.7663383585077 "$node_(401) setdest 75539 18541 2.0" 
$ns at 698.5614156769642 "$node_(401) setdest 33530 12687 7.0" 
$ns at 733.6787616330465 "$node_(401) setdest 126100 38982 11.0" 
$ns at 850.0752951927676 "$node_(401) setdest 43378 33729 9.0" 
$ns at 427.67709217469644 "$node_(402) setdest 20502 9132 12.0" 
$ns at 570.6502382809656 "$node_(402) setdest 71328 18867 3.0" 
$ns at 621.3841132331763 "$node_(402) setdest 64614 32023 8.0" 
$ns at 686.7750333992803 "$node_(402) setdest 18079 43507 18.0" 
$ns at 764.3896909181833 "$node_(402) setdest 130580 11933 5.0" 
$ns at 825.1312883783295 "$node_(402) setdest 105568 27622 6.0" 
$ns at 858.4428030545772 "$node_(402) setdest 57099 6148 16.0" 
$ns at 453.9297371590374 "$node_(403) setdest 81139 6906 18.0" 
$ns at 530.7607934069413 "$node_(403) setdest 79835 38034 17.0" 
$ns at 701.1402715484176 "$node_(403) setdest 15529 29363 6.0" 
$ns at 783.5298280801605 "$node_(403) setdest 22379 32638 8.0" 
$ns at 888.373220156436 "$node_(403) setdest 27472 34855 13.0" 
$ns at 548.7688101864024 "$node_(404) setdest 27159 42042 6.0" 
$ns at 629.013801973011 "$node_(404) setdest 52624 26217 20.0" 
$ns at 787.4429740101674 "$node_(404) setdest 125189 10274 19.0" 
$ns at 891.9038490287257 "$node_(404) setdest 22606 28825 6.0" 
$ns at 405.8616582401811 "$node_(405) setdest 42993 10956 10.0" 
$ns at 503.8530024496414 "$node_(405) setdest 119862 35730 1.0" 
$ns at 535.764976651065 "$node_(405) setdest 66167 20885 5.0" 
$ns at 583.6987117086882 "$node_(405) setdest 930 42987 11.0" 
$ns at 689.6458419368013 "$node_(405) setdest 44888 3701 7.0" 
$ns at 779.9781434500237 "$node_(405) setdest 79340 36782 4.0" 
$ns at 812.5390692365719 "$node_(405) setdest 128313 7872 12.0" 
$ns at 566.5951433932847 "$node_(406) setdest 115002 18427 7.0" 
$ns at 656.6204526606864 "$node_(406) setdest 20090 6775 6.0" 
$ns at 742.0315526738362 "$node_(406) setdest 121320 30647 19.0" 
$ns at 891.0486601332694 "$node_(406) setdest 66805 18626 18.0" 
$ns at 514.8110035799859 "$node_(407) setdest 117357 43046 4.0" 
$ns at 554.4983566046933 "$node_(407) setdest 102704 7033 20.0" 
$ns at 778.6573613707657 "$node_(407) setdest 7157 10602 2.0" 
$ns at 827.5248090581906 "$node_(407) setdest 133177 1698 2.0" 
$ns at 872.6608891373032 "$node_(407) setdest 110585 38419 1.0" 
$ns at 450.7940447483131 "$node_(408) setdest 23344 12180 3.0" 
$ns at 484.60694638386383 "$node_(408) setdest 36813 28107 20.0" 
$ns at 707.123602184873 "$node_(408) setdest 12953 35201 1.0" 
$ns at 740.6470042836568 "$node_(408) setdest 128142 8623 17.0" 
$ns at 434.4156595352817 "$node_(409) setdest 83870 42691 15.0" 
$ns at 573.8138938969173 "$node_(409) setdest 102909 16380 9.0" 
$ns at 656.813736685707 "$node_(409) setdest 16849 37834 12.0" 
$ns at 803.4064815144693 "$node_(409) setdest 50267 9842 18.0" 
$ns at 473.9947773146256 "$node_(410) setdest 37012 3151 9.0" 
$ns at 564.0658846384848 "$node_(410) setdest 20454 19112 1.0" 
$ns at 600.2723780444007 "$node_(410) setdest 68916 1222 19.0" 
$ns at 804.7360284350992 "$node_(410) setdest 95763 13860 20.0" 
$ns at 874.0221255481599 "$node_(410) setdest 7987 26220 9.0" 
$ns at 419.1112563958641 "$node_(411) setdest 105938 42719 20.0" 
$ns at 509.6975582723162 "$node_(411) setdest 104520 11343 17.0" 
$ns at 636.0220663200369 "$node_(411) setdest 79838 29798 17.0" 
$ns at 701.1151647181075 "$node_(411) setdest 13237 24186 6.0" 
$ns at 787.0586645590114 "$node_(411) setdest 88124 4980 3.0" 
$ns at 836.8874792026141 "$node_(411) setdest 40046 5127 3.0" 
$ns at 896.734238799469 "$node_(411) setdest 60132 41069 9.0" 
$ns at 485.1143807679404 "$node_(412) setdest 130963 24585 5.0" 
$ns at 516.4357798863717 "$node_(412) setdest 5332 4708 15.0" 
$ns at 551.3554954190555 "$node_(412) setdest 92871 18685 10.0" 
$ns at 607.7437324880302 "$node_(412) setdest 33902 35811 10.0" 
$ns at 712.1281641688571 "$node_(412) setdest 68998 44427 12.0" 
$ns at 791.7025307676571 "$node_(412) setdest 82945 6613 5.0" 
$ns at 864.7599892537031 "$node_(412) setdest 97053 17578 17.0" 
$ns at 431.18964960211906 "$node_(413) setdest 37673 37978 19.0" 
$ns at 515.0792347221065 "$node_(413) setdest 36938 37346 17.0" 
$ns at 711.5912932475602 "$node_(413) setdest 48461 23914 12.0" 
$ns at 775.2146828071714 "$node_(413) setdest 40180 18234 14.0" 
$ns at 814.2720637678519 "$node_(413) setdest 66925 16361 18.0" 
$ns at 431.24515058275585 "$node_(414) setdest 50837 42164 11.0" 
$ns at 526.504687946698 "$node_(414) setdest 123275 16546 1.0" 
$ns at 563.2707547945073 "$node_(414) setdest 29145 5893 1.0" 
$ns at 595.3281127543312 "$node_(414) setdest 70515 7583 8.0" 
$ns at 680.5234776283684 "$node_(414) setdest 89176 15320 9.0" 
$ns at 797.4167953378139 "$node_(414) setdest 125706 23185 5.0" 
$ns at 842.2587913829814 "$node_(414) setdest 123988 22911 8.0" 
$ns at 408.1074777175195 "$node_(415) setdest 21635 39597 5.0" 
$ns at 472.65926626868435 "$node_(415) setdest 33432 40130 18.0" 
$ns at 673.3062954663887 "$node_(415) setdest 99513 30379 15.0" 
$ns at 793.0913519674058 "$node_(415) setdest 619 9149 9.0" 
$ns at 844.9017807067382 "$node_(415) setdest 90791 13829 7.0" 
$ns at 428.88337347668164 "$node_(416) setdest 59207 12140 17.0" 
$ns at 536.9218524481846 "$node_(416) setdest 128931 34187 1.0" 
$ns at 574.4239484470237 "$node_(416) setdest 124591 963 1.0" 
$ns at 604.9675810302773 "$node_(416) setdest 41347 40200 16.0" 
$ns at 774.2947006658203 "$node_(416) setdest 26741 40140 8.0" 
$ns at 837.6607335159318 "$node_(416) setdest 65113 41035 3.0" 
$ns at 871.1466247073969 "$node_(416) setdest 130348 37637 14.0" 
$ns at 522.7392959840258 "$node_(417) setdest 30928 9919 11.0" 
$ns at 622.9341168456474 "$node_(417) setdest 44522 22735 11.0" 
$ns at 673.132578876147 "$node_(417) setdest 14030 31521 16.0" 
$ns at 853.1725957787862 "$node_(417) setdest 124574 12324 12.0" 
$ns at 494.31217473482604 "$node_(418) setdest 93156 21165 13.0" 
$ns at 606.2410870754164 "$node_(418) setdest 60275 44392 12.0" 
$ns at 637.6288686221138 "$node_(418) setdest 86522 25289 17.0" 
$ns at 729.7677794542952 "$node_(418) setdest 11982 16001 18.0" 
$ns at 403.2125932004293 "$node_(419) setdest 1343 23979 5.0" 
$ns at 469.6680679711208 "$node_(419) setdest 105847 13800 7.0" 
$ns at 514.0155296371448 "$node_(419) setdest 11083 13145 4.0" 
$ns at 581.7469517423677 "$node_(419) setdest 81428 42052 14.0" 
$ns at 627.3476477995447 "$node_(419) setdest 102788 9466 3.0" 
$ns at 671.4924922266958 "$node_(419) setdest 36651 13675 15.0" 
$ns at 826.1033747130034 "$node_(419) setdest 73543 41023 5.0" 
$ns at 438.30343931833625 "$node_(420) setdest 67770 35130 9.0" 
$ns at 538.4713435249574 "$node_(420) setdest 129135 42425 6.0" 
$ns at 570.9479169537746 "$node_(420) setdest 10347 6553 3.0" 
$ns at 609.9760575410639 "$node_(420) setdest 34247 34350 16.0" 
$ns at 739.1682363758729 "$node_(420) setdest 64206 32034 19.0" 
$ns at 875.5037577601545 "$node_(420) setdest 120299 19299 5.0" 
$ns at 461.022964402978 "$node_(421) setdest 69723 2570 7.0" 
$ns at 525.107887267869 "$node_(421) setdest 61317 11364 14.0" 
$ns at 679.9265985417386 "$node_(421) setdest 92703 33060 5.0" 
$ns at 719.9025695392919 "$node_(421) setdest 692 28324 11.0" 
$ns at 751.5275502975952 "$node_(421) setdest 108427 6347 19.0" 
$ns at 520.3773387908259 "$node_(422) setdest 1550 15676 16.0" 
$ns at 621.550654303563 "$node_(422) setdest 55125 39157 8.0" 
$ns at 677.6740984914319 "$node_(422) setdest 76415 34747 3.0" 
$ns at 725.386251219212 "$node_(422) setdest 83522 8074 9.0" 
$ns at 821.0071814251747 "$node_(422) setdest 108584 28163 2.0" 
$ns at 868.3509962748889 "$node_(422) setdest 53942 14822 5.0" 
$ns at 491.8978686102995 "$node_(423) setdest 111090 23109 7.0" 
$ns at 540.8528774286473 "$node_(423) setdest 81325 41529 17.0" 
$ns at 679.5923343835196 "$node_(423) setdest 120629 15236 4.0" 
$ns at 745.4725496963832 "$node_(423) setdest 65519 8108 12.0" 
$ns at 880.353904181685 "$node_(423) setdest 129712 12458 9.0" 
$ns at 506.5766877499577 "$node_(424) setdest 84793 33819 7.0" 
$ns at 568.6909804929087 "$node_(424) setdest 268 41528 4.0" 
$ns at 629.2602389741876 "$node_(424) setdest 71190 199 15.0" 
$ns at 734.5754968049811 "$node_(424) setdest 21945 31378 9.0" 
$ns at 789.0115934149137 "$node_(424) setdest 97976 21568 4.0" 
$ns at 829.1528332138521 "$node_(424) setdest 106493 41511 6.0" 
$ns at 891.5163766880295 "$node_(424) setdest 40887 12513 16.0" 
$ns at 563.97072726288 "$node_(425) setdest 13416 5756 11.0" 
$ns at 623.9957526831279 "$node_(425) setdest 57016 554 20.0" 
$ns at 718.7799192835085 "$node_(425) setdest 5873 14969 13.0" 
$ns at 845.3205439087338 "$node_(425) setdest 62270 20370 13.0" 
$ns at 410.6641043126621 "$node_(426) setdest 115942 37050 12.0" 
$ns at 511.49841617074344 "$node_(426) setdest 99505 12553 18.0" 
$ns at 623.2273522694343 "$node_(426) setdest 133849 5284 16.0" 
$ns at 757.0439988817735 "$node_(426) setdest 68701 40536 11.0" 
$ns at 880.0225205038968 "$node_(426) setdest 122444 14597 11.0" 
$ns at 412.25339298629797 "$node_(427) setdest 109876 40083 1.0" 
$ns at 448.51439005266957 "$node_(427) setdest 102427 4231 18.0" 
$ns at 633.3723091215115 "$node_(427) setdest 97524 10608 12.0" 
$ns at 755.4446389331908 "$node_(427) setdest 80104 23208 4.0" 
$ns at 793.8737890055976 "$node_(427) setdest 128860 2505 6.0" 
$ns at 825.4697993339778 "$node_(427) setdest 126875 20149 10.0" 
$ns at 417.8838781691715 "$node_(428) setdest 8287 25569 8.0" 
$ns at 458.3820843269921 "$node_(428) setdest 50536 25840 11.0" 
$ns at 528.8472794519953 "$node_(428) setdest 122235 27443 2.0" 
$ns at 561.0137325752524 "$node_(428) setdest 113413 31724 4.0" 
$ns at 622.1569712047111 "$node_(428) setdest 44734 25745 4.0" 
$ns at 661.8327664336352 "$node_(428) setdest 113263 44305 6.0" 
$ns at 751.6711563141589 "$node_(428) setdest 18814 4682 11.0" 
$ns at 798.1065526623494 "$node_(428) setdest 86529 21025 1.0" 
$ns at 837.6976317679339 "$node_(428) setdest 14729 1043 14.0" 
$ns at 410.2772287311499 "$node_(429) setdest 32461 14299 14.0" 
$ns at 487.8784398224263 "$node_(429) setdest 122987 33969 5.0" 
$ns at 539.8456314106304 "$node_(429) setdest 6062 17418 7.0" 
$ns at 575.9790408471569 "$node_(429) setdest 43169 3974 7.0" 
$ns at 646.5242340106147 "$node_(429) setdest 53615 36981 3.0" 
$ns at 691.0781235209885 "$node_(429) setdest 12717 26649 7.0" 
$ns at 727.5635015732252 "$node_(429) setdest 9412 42595 14.0" 
$ns at 858.4047832292498 "$node_(429) setdest 10501 19110 1.0" 
$ns at 892.613421099662 "$node_(429) setdest 67413 43944 20.0" 
$ns at 431.75982777609147 "$node_(430) setdest 121730 4518 2.0" 
$ns at 473.7310545962342 "$node_(430) setdest 111641 15797 11.0" 
$ns at 612.5220722798995 "$node_(430) setdest 119033 33933 5.0" 
$ns at 677.3021425003876 "$node_(430) setdest 24425 13455 3.0" 
$ns at 720.9172784152897 "$node_(430) setdest 3000 40642 3.0" 
$ns at 751.2537132166372 "$node_(430) setdest 106030 22461 10.0" 
$ns at 864.2034192024369 "$node_(430) setdest 59328 35246 17.0" 
$ns at 585.2460924113993 "$node_(431) setdest 4270 9371 1.0" 
$ns at 621.4976017627712 "$node_(431) setdest 24563 34902 12.0" 
$ns at 740.2036850462566 "$node_(431) setdest 63525 40847 16.0" 
$ns at 880.5724312288412 "$node_(431) setdest 119089 43232 10.0" 
$ns at 404.07115851460253 "$node_(432) setdest 108177 1027 1.0" 
$ns at 443.2472011787685 "$node_(432) setdest 91040 3371 11.0" 
$ns at 516.3125713757839 "$node_(432) setdest 119325 14409 15.0" 
$ns at 653.343774054022 "$node_(432) setdest 4036 24031 19.0" 
$ns at 835.9174826645137 "$node_(432) setdest 21804 43832 2.0" 
$ns at 878.5517272671073 "$node_(432) setdest 123672 20005 10.0" 
$ns at 547.8268753967272 "$node_(433) setdest 104156 39497 15.0" 
$ns at 620.429864182881 "$node_(433) setdest 81299 20593 6.0" 
$ns at 704.3674250146203 "$node_(433) setdest 103135 20925 12.0" 
$ns at 760.2705201488661 "$node_(433) setdest 84502 16602 12.0" 
$ns at 870.5170234429527 "$node_(433) setdest 73349 42338 14.0" 
$ns at 479.17021844953393 "$node_(434) setdest 88611 14921 4.0" 
$ns at 516.468575209843 "$node_(434) setdest 16700 22283 8.0" 
$ns at 619.9421629362746 "$node_(434) setdest 34202 16925 19.0" 
$ns at 694.4433822367964 "$node_(434) setdest 77189 30505 9.0" 
$ns at 741.4144699609992 "$node_(434) setdest 127110 5284 18.0" 
$ns at 470.12410805713375 "$node_(435) setdest 61625 15090 18.0" 
$ns at 597.7624967032746 "$node_(435) setdest 71291 23219 1.0" 
$ns at 632.2984672816845 "$node_(435) setdest 42349 39847 12.0" 
$ns at 771.9288164425495 "$node_(435) setdest 82278 8536 10.0" 
$ns at 819.2984036331727 "$node_(435) setdest 91386 21216 7.0" 
$ns at 508.32254191245073 "$node_(436) setdest 64470 8806 10.0" 
$ns at 630.1009006012439 "$node_(436) setdest 7049 31371 7.0" 
$ns at 710.0836082823806 "$node_(436) setdest 64615 15066 7.0" 
$ns at 783.2260810643318 "$node_(436) setdest 68134 21535 2.0" 
$ns at 825.2315007740577 "$node_(436) setdest 52779 6321 13.0" 
$ns at 862.0835040086805 "$node_(436) setdest 31788 12640 16.0" 
$ns at 511.3454543345793 "$node_(437) setdest 60413 14104 13.0" 
$ns at 629.8965438955305 "$node_(437) setdest 15703 737 8.0" 
$ns at 709.4386042233265 "$node_(437) setdest 117880 23372 20.0" 
$ns at 876.7698406779865 "$node_(437) setdest 74207 11001 16.0" 
$ns at 467.4156685502516 "$node_(438) setdest 16898 24377 11.0" 
$ns at 503.26610775581776 "$node_(438) setdest 133795 40610 11.0" 
$ns at 587.9693980816485 "$node_(438) setdest 42097 42926 7.0" 
$ns at 670.8891455940436 "$node_(438) setdest 82325 23684 7.0" 
$ns at 755.7891762246022 "$node_(438) setdest 2893 16756 15.0" 
$ns at 818.5303762332785 "$node_(438) setdest 64786 35173 17.0" 
$ns at 492.61605475590875 "$node_(439) setdest 25674 28808 19.0" 
$ns at 561.4514961910835 "$node_(439) setdest 94157 20561 6.0" 
$ns at 613.3326426141219 "$node_(439) setdest 50044 7621 1.0" 
$ns at 650.6187864558393 "$node_(439) setdest 61420 35384 5.0" 
$ns at 699.8573549644505 "$node_(439) setdest 94911 16289 20.0" 
$ns at 743.6325642553807 "$node_(439) setdest 61627 13933 8.0" 
$ns at 804.4617267683753 "$node_(439) setdest 13567 10112 1.0" 
$ns at 840.7843212256645 "$node_(439) setdest 38361 23801 2.0" 
$ns at 884.0652534870011 "$node_(439) setdest 58503 38782 12.0" 
$ns at 421.8896343458921 "$node_(440) setdest 105056 35036 6.0" 
$ns at 503.0678386853267 "$node_(440) setdest 8679 9351 15.0" 
$ns at 594.3573721415273 "$node_(440) setdest 92920 33596 14.0" 
$ns at 654.3795921445483 "$node_(440) setdest 49759 10009 18.0" 
$ns at 826.8101278753984 "$node_(440) setdest 111134 30564 19.0" 
$ns at 446.0845605730401 "$node_(441) setdest 22685 8370 12.0" 
$ns at 481.76825904418723 "$node_(441) setdest 68469 19294 11.0" 
$ns at 583.5471341599704 "$node_(441) setdest 15143 21568 14.0" 
$ns at 655.0387621562052 "$node_(441) setdest 85100 25957 1.0" 
$ns at 694.5515988153512 "$node_(441) setdest 15660 26322 18.0" 
$ns at 818.9458302764106 "$node_(441) setdest 113569 30516 13.0" 
$ns at 479.28956224444624 "$node_(442) setdest 106600 34220 8.0" 
$ns at 528.4241459457949 "$node_(442) setdest 67243 28681 9.0" 
$ns at 564.3769909009 "$node_(442) setdest 133286 44346 6.0" 
$ns at 620.0194122531959 "$node_(442) setdest 45610 40311 18.0" 
$ns at 653.8912154465665 "$node_(442) setdest 82170 369 17.0" 
$ns at 843.2316607182897 "$node_(442) setdest 1172 18082 15.0" 
$ns at 434.63837298156903 "$node_(443) setdest 113171 2355 20.0" 
$ns at 581.7974525864372 "$node_(443) setdest 127494 24095 14.0" 
$ns at 718.6726469549063 "$node_(443) setdest 29765 30300 7.0" 
$ns at 801.2973711235435 "$node_(443) setdest 117683 21763 17.0" 
$ns at 419.7534389313197 "$node_(444) setdest 78429 6942 2.0" 
$ns at 465.0881058722693 "$node_(444) setdest 61380 24702 1.0" 
$ns at 504.13686251854347 "$node_(444) setdest 50403 13691 19.0" 
$ns at 688.4744030292429 "$node_(444) setdest 7084 43490 13.0" 
$ns at 837.9811888053753 "$node_(444) setdest 49509 6463 19.0" 
$ns at 408.39810261827347 "$node_(445) setdest 91589 40611 10.0" 
$ns at 508.69373331819463 "$node_(445) setdest 89861 7303 4.0" 
$ns at 565.8055778219391 "$node_(445) setdest 68312 3512 18.0" 
$ns at 724.7957928013411 "$node_(445) setdest 102564 4797 6.0" 
$ns at 777.2929282560556 "$node_(445) setdest 9647 40054 7.0" 
$ns at 853.160286588472 "$node_(445) setdest 75155 31744 3.0" 
$ns at 551.3434067478087 "$node_(446) setdest 94376 9642 15.0" 
$ns at 592.4255883504077 "$node_(446) setdest 124942 37424 4.0" 
$ns at 653.740724668562 "$node_(446) setdest 53454 35967 5.0" 
$ns at 704.6353411888551 "$node_(446) setdest 77829 2040 6.0" 
$ns at 754.9170431709139 "$node_(446) setdest 107817 41086 2.0" 
$ns at 792.6616701782173 "$node_(446) setdest 30307 25456 14.0" 
$ns at 492.94894261836566 "$node_(447) setdest 47449 16604 18.0" 
$ns at 653.4538577754126 "$node_(447) setdest 101809 12519 4.0" 
$ns at 723.3687857881949 "$node_(447) setdest 26035 34377 3.0" 
$ns at 770.5199076641309 "$node_(447) setdest 129018 27701 9.0" 
$ns at 843.0346834447159 "$node_(447) setdest 130305 34007 10.0" 
$ns at 432.89364416793694 "$node_(448) setdest 114231 15574 5.0" 
$ns at 493.27045207080073 "$node_(448) setdest 86585 41702 2.0" 
$ns at 530.8013720206711 "$node_(448) setdest 102885 8743 13.0" 
$ns at 667.6390396183048 "$node_(448) setdest 109085 27907 15.0" 
$ns at 824.762523488912 "$node_(448) setdest 77012 5014 1.0" 
$ns at 856.0138282348066 "$node_(448) setdest 67335 12263 14.0" 
$ns at 466.5399715988011 "$node_(449) setdest 77778 7648 12.0" 
$ns at 510.173622858506 "$node_(449) setdest 88645 12910 18.0" 
$ns at 682.6281481026998 "$node_(449) setdest 41307 10075 7.0" 
$ns at 737.5289155957904 "$node_(449) setdest 2198 38816 10.0" 
$ns at 768.6931636199263 "$node_(449) setdest 16538 20373 1.0" 
$ns at 805.0773331886655 "$node_(449) setdest 18346 25929 18.0" 
$ns at 881.1494250390913 "$node_(449) setdest 120218 31280 5.0" 
$ns at 547.5579242566383 "$node_(450) setdest 61421 7768 5.0" 
$ns at 602.9118608525582 "$node_(450) setdest 26637 10680 6.0" 
$ns at 652.3331164455641 "$node_(450) setdest 98887 14809 11.0" 
$ns at 711.2160489350526 "$node_(450) setdest 19087 23724 17.0" 
$ns at 821.0418120630698 "$node_(450) setdest 2886 18427 6.0" 
$ns at 872.1670615046868 "$node_(450) setdest 116186 38903 16.0" 
$ns at 433.3622048988964 "$node_(451) setdest 5379 11415 6.0" 
$ns at 477.5698832228213 "$node_(451) setdest 37801 29686 16.0" 
$ns at 559.5543037859765 "$node_(451) setdest 60925 9726 5.0" 
$ns at 629.6525604368549 "$node_(451) setdest 52955 39621 3.0" 
$ns at 676.164343095054 "$node_(451) setdest 48230 21809 2.0" 
$ns at 711.721017246787 "$node_(451) setdest 113397 30453 5.0" 
$ns at 748.1208292077085 "$node_(451) setdest 49434 26933 2.0" 
$ns at 794.7366293623222 "$node_(451) setdest 71102 29595 16.0" 
$ns at 849.4781251240853 "$node_(451) setdest 47468 41412 7.0" 
$ns at 505.4383829534519 "$node_(452) setdest 15481 9119 13.0" 
$ns at 583.1890930804508 "$node_(452) setdest 37424 34677 1.0" 
$ns at 617.7005862617061 "$node_(452) setdest 74710 17111 7.0" 
$ns at 707.2625678568851 "$node_(452) setdest 122309 44589 11.0" 
$ns at 825.9645747204215 "$node_(452) setdest 56551 33526 1.0" 
$ns at 863.3342915341302 "$node_(452) setdest 59328 22708 9.0" 
$ns at 425.8616508731533 "$node_(453) setdest 85084 10566 4.0" 
$ns at 467.93276176040195 "$node_(453) setdest 113895 42414 15.0" 
$ns at 631.2734113831478 "$node_(453) setdest 101348 23399 4.0" 
$ns at 682.4754054480952 "$node_(453) setdest 61577 4684 1.0" 
$ns at 714.3804099422603 "$node_(453) setdest 61792 21861 1.0" 
$ns at 752.3330215125859 "$node_(453) setdest 97496 1033 2.0" 
$ns at 789.0306845169769 "$node_(453) setdest 13503 44056 11.0" 
$ns at 888.4897505039056 "$node_(453) setdest 66262 1610 4.0" 
$ns at 467.1156250211392 "$node_(454) setdest 97101 12281 16.0" 
$ns at 540.5281253860471 "$node_(454) setdest 28826 30 4.0" 
$ns at 586.2513555335324 "$node_(454) setdest 61917 34871 10.0" 
$ns at 675.3374414425609 "$node_(454) setdest 126795 39766 11.0" 
$ns at 728.7769955832093 "$node_(454) setdest 125281 21336 2.0" 
$ns at 765.3768624017587 "$node_(454) setdest 76314 21138 7.0" 
$ns at 796.8870379151163 "$node_(454) setdest 22627 13381 8.0" 
$ns at 836.7803088823501 "$node_(454) setdest 64769 6500 8.0" 
$ns at 897.0698273387723 "$node_(454) setdest 21646 15458 11.0" 
$ns at 453.4481718121799 "$node_(455) setdest 83538 39148 2.0" 
$ns at 490.7379448704216 "$node_(455) setdest 113023 14711 14.0" 
$ns at 560.853736280343 "$node_(455) setdest 91616 28317 4.0" 
$ns at 606.8388762590761 "$node_(455) setdest 29584 26765 2.0" 
$ns at 655.7262938599787 "$node_(455) setdest 49232 42710 18.0" 
$ns at 849.1592567381095 "$node_(455) setdest 126406 11406 2.0" 
$ns at 894.3363563675065 "$node_(455) setdest 76054 17110 2.0" 
$ns at 505.812297666689 "$node_(456) setdest 31137 26416 8.0" 
$ns at 603.8931473849769 "$node_(456) setdest 58413 44212 3.0" 
$ns at 634.9093004616515 "$node_(456) setdest 25212 32761 11.0" 
$ns at 755.8542635742917 "$node_(456) setdest 77068 31108 14.0" 
$ns at 801.6708733077293 "$node_(456) setdest 79156 19197 6.0" 
$ns at 848.9025306909791 "$node_(456) setdest 88762 28905 11.0" 
$ns at 420.92951874566677 "$node_(457) setdest 98100 26012 3.0" 
$ns at 466.99628885774763 "$node_(457) setdest 100803 14590 8.0" 
$ns at 560.5814623631339 "$node_(457) setdest 113273 13932 12.0" 
$ns at 680.8996961679377 "$node_(457) setdest 54125 10403 15.0" 
$ns at 724.5027169690508 "$node_(457) setdest 28906 18518 4.0" 
$ns at 771.7186340215572 "$node_(457) setdest 71609 33320 5.0" 
$ns at 847.3904003499231 "$node_(457) setdest 72207 31489 9.0" 
$ns at 500.79057002391073 "$node_(458) setdest 40684 34715 6.0" 
$ns at 534.4846607306074 "$node_(458) setdest 84220 21314 8.0" 
$ns at 583.9810609628526 "$node_(458) setdest 113004 2662 11.0" 
$ns at 640.1241352319441 "$node_(458) setdest 35202 3796 1.0" 
$ns at 677.2013746712828 "$node_(458) setdest 17799 1142 2.0" 
$ns at 716.8109814509847 "$node_(458) setdest 34791 43985 10.0" 
$ns at 764.1084135337417 "$node_(458) setdest 121129 19798 19.0" 
$ns at 838.5987158701935 "$node_(458) setdest 30665 12845 17.0" 
$ns at 413.34915824292307 "$node_(459) setdest 5484 39197 7.0" 
$ns at 462.488273431391 "$node_(459) setdest 109163 16472 1.0" 
$ns at 492.8375466749947 "$node_(459) setdest 50743 36399 17.0" 
$ns at 615.4481051342739 "$node_(459) setdest 109983 34083 10.0" 
$ns at 712.0045771246204 "$node_(459) setdest 21031 4998 10.0" 
$ns at 788.6927086457345 "$node_(459) setdest 126094 37581 12.0" 
$ns at 842.033116136245 "$node_(459) setdest 44690 35346 14.0" 
$ns at 877.3764657780915 "$node_(459) setdest 6423 41671 12.0" 
$ns at 408.4410211583795 "$node_(460) setdest 84635 43566 19.0" 
$ns at 552.8063824078866 "$node_(460) setdest 102303 36862 2.0" 
$ns at 601.4294334095292 "$node_(460) setdest 126818 32624 16.0" 
$ns at 644.2297456274541 "$node_(460) setdest 132230 16822 16.0" 
$ns at 803.6969999633404 "$node_(460) setdest 27685 31139 6.0" 
$ns at 884.3273777986008 "$node_(460) setdest 59939 27053 10.0" 
$ns at 414.7292617244435 "$node_(461) setdest 133302 38353 4.0" 
$ns at 481.44635307337603 "$node_(461) setdest 71644 7656 11.0" 
$ns at 596.0306002779821 "$node_(461) setdest 126238 12586 12.0" 
$ns at 724.2272825700095 "$node_(461) setdest 30840 23391 19.0" 
$ns at 424.95647874662774 "$node_(462) setdest 41986 36817 8.0" 
$ns at 505.886676791676 "$node_(462) setdest 126292 29048 15.0" 
$ns at 568.1278617006367 "$node_(462) setdest 47086 11946 10.0" 
$ns at 626.1027423695762 "$node_(462) setdest 86635 4430 3.0" 
$ns at 660.4432614111406 "$node_(462) setdest 21805 1639 9.0" 
$ns at 726.2937997701254 "$node_(462) setdest 115495 18305 11.0" 
$ns at 823.40137068321 "$node_(462) setdest 30095 29375 2.0" 
$ns at 869.7045866171612 "$node_(462) setdest 24669 12835 10.0" 
$ns at 408.06774611280895 "$node_(463) setdest 8386 17895 5.0" 
$ns at 453.21834912732675 "$node_(463) setdest 53941 34036 19.0" 
$ns at 645.5542600345246 "$node_(463) setdest 88635 43013 13.0" 
$ns at 752.339149583123 "$node_(463) setdest 37813 34646 1.0" 
$ns at 789.1097692654678 "$node_(463) setdest 78003 1253 3.0" 
$ns at 842.555221655856 "$node_(463) setdest 38130 3868 18.0" 
$ns at 404.8341463617516 "$node_(464) setdest 60325 16374 2.0" 
$ns at 451.4058428061836 "$node_(464) setdest 91969 21025 6.0" 
$ns at 507.51707693047723 "$node_(464) setdest 35942 20273 5.0" 
$ns at 545.4456667257336 "$node_(464) setdest 67365 23702 2.0" 
$ns at 581.9082092822757 "$node_(464) setdest 9691 39036 9.0" 
$ns at 656.6759464478663 "$node_(464) setdest 92595 37297 12.0" 
$ns at 706.779367287925 "$node_(464) setdest 63776 10898 14.0" 
$ns at 767.5706679655722 "$node_(464) setdest 106134 23746 2.0" 
$ns at 801.862585873868 "$node_(464) setdest 119826 2127 1.0" 
$ns at 832.0585252735675 "$node_(464) setdest 37978 34440 16.0" 
$ns at 479.65197255637855 "$node_(465) setdest 48576 27409 20.0" 
$ns at 570.1867340567544 "$node_(465) setdest 64467 9116 12.0" 
$ns at 693.5514282646809 "$node_(465) setdest 22841 33149 13.0" 
$ns at 783.1282414069142 "$node_(465) setdest 93179 15418 13.0" 
$ns at 866.1968919252371 "$node_(465) setdest 25605 27409 19.0" 
$ns at 475.0069661402489 "$node_(466) setdest 38576 18735 18.0" 
$ns at 534.0940706656814 "$node_(466) setdest 57743 25369 11.0" 
$ns at 656.4263225110094 "$node_(466) setdest 66289 8094 3.0" 
$ns at 716.0804173918885 "$node_(466) setdest 32088 30528 8.0" 
$ns at 813.1705205020037 "$node_(466) setdest 74783 3615 17.0" 
$ns at 432.4197827780341 "$node_(467) setdest 102020 29243 3.0" 
$ns at 470.87515975268127 "$node_(467) setdest 45219 34355 9.0" 
$ns at 569.162021207251 "$node_(467) setdest 63674 30491 6.0" 
$ns at 607.908976118695 "$node_(467) setdest 108619 896 4.0" 
$ns at 669.2556206334623 "$node_(467) setdest 103129 8401 7.0" 
$ns at 721.6367306161158 "$node_(467) setdest 118311 28510 4.0" 
$ns at 782.6356704801514 "$node_(467) setdest 46455 40410 15.0" 
$ns at 836.0246736629151 "$node_(467) setdest 79957 10082 20.0" 
$ns at 488.09645900350813 "$node_(468) setdest 50308 35970 4.0" 
$ns at 536.3556509556665 "$node_(468) setdest 116556 3698 3.0" 
$ns at 577.4620250680103 "$node_(468) setdest 114059 21747 2.0" 
$ns at 609.6954023337233 "$node_(468) setdest 113059 13009 2.0" 
$ns at 653.4737646680899 "$node_(468) setdest 96961 12218 13.0" 
$ns at 692.4004819193264 "$node_(468) setdest 41023 8560 6.0" 
$ns at 724.8887021985165 "$node_(468) setdest 9313 9420 7.0" 
$ns at 767.6596848043249 "$node_(468) setdest 52110 13779 15.0" 
$ns at 847.9635968403741 "$node_(468) setdest 80672 6402 7.0" 
$ns at 467.66303087359637 "$node_(469) setdest 80268 37917 2.0" 
$ns at 514.6358934347854 "$node_(469) setdest 19342 6807 6.0" 
$ns at 599.774092719599 "$node_(469) setdest 56856 1419 10.0" 
$ns at 645.4952445333514 "$node_(469) setdest 41312 7436 20.0" 
$ns at 679.3533219341396 "$node_(469) setdest 25329 33067 14.0" 
$ns at 830.4762973221754 "$node_(469) setdest 126647 38850 8.0" 
$ns at 898.6112660497722 "$node_(469) setdest 130959 38818 1.0" 
$ns at 517.5293069113609 "$node_(470) setdest 34724 23271 3.0" 
$ns at 577.2336230455719 "$node_(470) setdest 48455 31560 7.0" 
$ns at 618.1781192978852 "$node_(470) setdest 46820 19419 20.0" 
$ns at 737.4825366825147 "$node_(470) setdest 98012 42865 8.0" 
$ns at 811.8939362082658 "$node_(470) setdest 108097 32891 2.0" 
$ns at 850.9344099966683 "$node_(470) setdest 6664 26174 6.0" 
$ns at 540.8967880157463 "$node_(471) setdest 89127 30688 7.0" 
$ns at 635.295167785363 "$node_(471) setdest 129833 6915 15.0" 
$ns at 798.5670278653357 "$node_(471) setdest 17235 44232 15.0" 
$ns at 548.1954801682507 "$node_(472) setdest 121719 35273 14.0" 
$ns at 655.2608471259767 "$node_(472) setdest 27853 24214 6.0" 
$ns at 710.5090754030225 "$node_(472) setdest 306 16576 11.0" 
$ns at 784.2458315206434 "$node_(472) setdest 24834 10277 14.0" 
$ns at 848.0048659769332 "$node_(472) setdest 117637 11687 2.0" 
$ns at 882.5216207707565 "$node_(472) setdest 90686 27443 7.0" 
$ns at 409.6441301876425 "$node_(473) setdest 104298 28425 16.0" 
$ns at 575.8174743923655 "$node_(473) setdest 83512 8313 6.0" 
$ns at 608.3495045061692 "$node_(473) setdest 63872 1657 2.0" 
$ns at 650.1206484671355 "$node_(473) setdest 67484 42392 18.0" 
$ns at 684.4883942286317 "$node_(473) setdest 7159 13740 1.0" 
$ns at 718.8434439312105 "$node_(473) setdest 21447 26551 5.0" 
$ns at 774.1243135974528 "$node_(473) setdest 86679 26426 5.0" 
$ns at 808.1677835236285 "$node_(473) setdest 111071 43205 5.0" 
$ns at 860.4926500542143 "$node_(473) setdest 14357 28938 6.0" 
$ns at 413.4246578052794 "$node_(474) setdest 1947 41819 3.0" 
$ns at 452.9617476740585 "$node_(474) setdest 95514 18256 4.0" 
$ns at 506.2062973928402 "$node_(474) setdest 78208 20810 9.0" 
$ns at 547.6368750455786 "$node_(474) setdest 52328 19647 14.0" 
$ns at 645.8906089493487 "$node_(474) setdest 39550 19920 18.0" 
$ns at 723.6578598357263 "$node_(474) setdest 83721 39538 14.0" 
$ns at 831.4199331779 "$node_(474) setdest 128070 29908 15.0" 
$ns at 499.67793545944187 "$node_(475) setdest 47059 38365 9.0" 
$ns at 619.3674338655874 "$node_(475) setdest 1764 17881 17.0" 
$ns at 711.9027133986533 "$node_(475) setdest 93366 17349 3.0" 
$ns at 768.9360743884141 "$node_(475) setdest 123128 232 11.0" 
$ns at 891.505237132112 "$node_(475) setdest 97371 29016 7.0" 
$ns at 416.3764502221767 "$node_(476) setdest 83178 20618 1.0" 
$ns at 446.572290413772 "$node_(476) setdest 126020 7795 17.0" 
$ns at 547.9370868879743 "$node_(476) setdest 122802 11816 7.0" 
$ns at 599.7317126100596 "$node_(476) setdest 3098 27372 11.0" 
$ns at 725.4874456928369 "$node_(476) setdest 86237 23091 18.0" 
$ns at 794.2871520915629 "$node_(476) setdest 119234 36803 19.0" 
$ns at 873.8835613511695 "$node_(476) setdest 130453 10449 11.0" 
$ns at 471.0116187199243 "$node_(477) setdest 120756 10354 18.0" 
$ns at 567.3133906209795 "$node_(477) setdest 2526 9896 12.0" 
$ns at 667.3633310418514 "$node_(477) setdest 92720 36424 8.0" 
$ns at 761.1416702102422 "$node_(477) setdest 25575 35589 4.0" 
$ns at 799.1089782297381 "$node_(477) setdest 127819 21126 8.0" 
$ns at 858.548605464721 "$node_(477) setdest 100701 16768 19.0" 
$ns at 414.40500591257785 "$node_(478) setdest 100519 26802 10.0" 
$ns at 503.68586372079426 "$node_(478) setdest 21999 12314 1.0" 
$ns at 543.3001007898577 "$node_(478) setdest 47192 7847 9.0" 
$ns at 662.1614387227219 "$node_(478) setdest 134104 42817 14.0" 
$ns at 720.1307911369776 "$node_(478) setdest 27227 22901 1.0" 
$ns at 757.3983689817914 "$node_(478) setdest 92439 32994 6.0" 
$ns at 807.0694515955851 "$node_(478) setdest 121083 19814 7.0" 
$ns at 898.0806280663553 "$node_(478) setdest 34378 795 14.0" 
$ns at 501.26277849595886 "$node_(479) setdest 129193 22095 16.0" 
$ns at 546.094892817208 "$node_(479) setdest 64534 20601 10.0" 
$ns at 589.9835627882396 "$node_(479) setdest 88697 34685 18.0" 
$ns at 651.7944283936818 "$node_(479) setdest 20658 35010 8.0" 
$ns at 684.4305852667472 "$node_(479) setdest 72758 5108 3.0" 
$ns at 738.0814373495842 "$node_(479) setdest 48676 37729 3.0" 
$ns at 789.4865229568363 "$node_(479) setdest 83300 26605 6.0" 
$ns at 826.5074474756941 "$node_(479) setdest 76979 3364 5.0" 
$ns at 893.4394516320151 "$node_(479) setdest 4239 33107 19.0" 
$ns at 510.2444589404585 "$node_(480) setdest 48037 13920 8.0" 
$ns at 560.9672050244636 "$node_(480) setdest 126772 15476 16.0" 
$ns at 714.2684296401264 "$node_(480) setdest 29661 28940 1.0" 
$ns at 746.458060020887 "$node_(480) setdest 127739 13917 3.0" 
$ns at 799.8320352072327 "$node_(480) setdest 55840 240 19.0" 
$ns at 837.9442536616278 "$node_(480) setdest 103316 15210 2.0" 
$ns at 870.3246671744507 "$node_(480) setdest 16575 3932 16.0" 
$ns at 529.6144394687549 "$node_(481) setdest 95080 32257 2.0" 
$ns at 561.6419768461924 "$node_(481) setdest 16269 25586 1.0" 
$ns at 597.1352186841721 "$node_(481) setdest 36746 5601 17.0" 
$ns at 720.7250920417378 "$node_(481) setdest 74168 42189 9.0" 
$ns at 829.9610299799177 "$node_(481) setdest 61067 25440 19.0" 
$ns at 412.7485638493117 "$node_(482) setdest 110652 11202 16.0" 
$ns at 476.5577107692045 "$node_(482) setdest 23696 4303 9.0" 
$ns at 518.7167701864956 "$node_(482) setdest 17671 12568 17.0" 
$ns at 670.1716236533377 "$node_(482) setdest 121613 30363 6.0" 
$ns at 755.7933769975192 "$node_(482) setdest 33335 38042 7.0" 
$ns at 786.4281677456148 "$node_(482) setdest 63354 10042 13.0" 
$ns at 833.3657473271006 "$node_(482) setdest 47963 7248 5.0" 
$ns at 892.2077575148816 "$node_(482) setdest 64760 20147 18.0" 
$ns at 404.54075824057713 "$node_(483) setdest 51213 16183 12.0" 
$ns at 475.40313855983266 "$node_(483) setdest 56224 21321 16.0" 
$ns at 545.5664609392766 "$node_(483) setdest 1357 40817 17.0" 
$ns at 745.1997993695877 "$node_(483) setdest 91019 38869 17.0" 
$ns at 400.47849090448403 "$node_(484) setdest 42979 870 12.0" 
$ns at 478.02847066691135 "$node_(484) setdest 123558 16245 17.0" 
$ns at 649.6497988409594 "$node_(484) setdest 127964 39826 7.0" 
$ns at 738.2758292218168 "$node_(484) setdest 26860 23745 18.0" 
$ns at 780.0743482026569 "$node_(484) setdest 72456 33810 16.0" 
$ns at 850.2574188314676 "$node_(484) setdest 3545 1429 16.0" 
$ns at 887.1383827134354 "$node_(484) setdest 82327 22613 19.0" 
$ns at 409.3194848515939 "$node_(485) setdest 93532 6136 2.0" 
$ns at 456.5557891743505 "$node_(485) setdest 86754 40725 8.0" 
$ns at 496.84698258609893 "$node_(485) setdest 125195 28113 13.0" 
$ns at 594.5190666229789 "$node_(485) setdest 22128 8468 7.0" 
$ns at 690.8825202703116 "$node_(485) setdest 17430 26149 7.0" 
$ns at 746.7216040688016 "$node_(485) setdest 80586 11370 16.0" 
$ns at 778.468650546996 "$node_(485) setdest 113225 35485 9.0" 
$ns at 855.1629064963957 "$node_(485) setdest 11758 23683 20.0" 
$ns at 433.0259071253282 "$node_(486) setdest 31493 9691 7.0" 
$ns at 507.77667879179 "$node_(486) setdest 52428 44078 13.0" 
$ns at 619.5733873917688 "$node_(486) setdest 63924 35423 13.0" 
$ns at 763.8196061315623 "$node_(486) setdest 41297 28105 17.0" 
$ns at 874.8558634808787 "$node_(486) setdest 867 28556 19.0" 
$ns at 473.9856521317445 "$node_(487) setdest 42227 12543 17.0" 
$ns at 545.7705251986497 "$node_(487) setdest 87581 37611 1.0" 
$ns at 580.4184346189011 "$node_(487) setdest 10024 5256 15.0" 
$ns at 727.1574676057937 "$node_(487) setdest 15075 5979 1.0" 
$ns at 761.6984248815253 "$node_(487) setdest 2171 14491 1.0" 
$ns at 798.8125883349792 "$node_(487) setdest 104904 14309 12.0" 
$ns at 840.298931819604 "$node_(487) setdest 117257 5877 18.0" 
$ns at 457.8026720775474 "$node_(488) setdest 15846 2272 6.0" 
$ns at 530.189636138565 "$node_(488) setdest 54526 12842 1.0" 
$ns at 561.0813086064342 "$node_(488) setdest 10617 10630 1.0" 
$ns at 592.1093777766745 "$node_(488) setdest 44890 22353 17.0" 
$ns at 653.0430825870503 "$node_(488) setdest 46001 4170 1.0" 
$ns at 688.4279513441504 "$node_(488) setdest 86673 24335 12.0" 
$ns at 824.4223270525486 "$node_(488) setdest 92752 16767 7.0" 
$ns at 886.1713762438729 "$node_(488) setdest 45839 29079 7.0" 
$ns at 456.9471980027347 "$node_(489) setdest 78907 32970 7.0" 
$ns at 552.5359479226582 "$node_(489) setdest 133055 33353 8.0" 
$ns at 608.0946549107566 "$node_(489) setdest 101130 557 4.0" 
$ns at 659.8836163103431 "$node_(489) setdest 3462 41215 16.0" 
$ns at 692.8050320104629 "$node_(489) setdest 65309 36972 8.0" 
$ns at 734.5881438116865 "$node_(489) setdest 49417 32273 1.0" 
$ns at 770.9363900104913 "$node_(489) setdest 45976 6519 18.0" 
$ns at 445.52374611021423 "$node_(490) setdest 81358 33409 14.0" 
$ns at 602.30405123373 "$node_(490) setdest 115745 2705 5.0" 
$ns at 650.1665922043794 "$node_(490) setdest 42583 44715 11.0" 
$ns at 722.1935596159371 "$node_(490) setdest 96392 12057 16.0" 
$ns at 797.491577128859 "$node_(490) setdest 82827 13300 12.0" 
$ns at 834.0993705684833 "$node_(490) setdest 772 40163 10.0" 
$ns at 874.8841575590379 "$node_(490) setdest 121278 30275 15.0" 
$ns at 419.1378254372647 "$node_(491) setdest 10576 4280 14.0" 
$ns at 572.6338214733727 "$node_(491) setdest 76744 5352 1.0" 
$ns at 611.1083451605859 "$node_(491) setdest 104339 25839 10.0" 
$ns at 694.5199946322525 "$node_(491) setdest 38641 395 4.0" 
$ns at 733.7543024665871 "$node_(491) setdest 79448 4805 8.0" 
$ns at 804.4818726512744 "$node_(491) setdest 29667 32462 14.0" 
$ns at 404.3303550795547 "$node_(492) setdest 50786 33598 6.0" 
$ns at 461.98719227072604 "$node_(492) setdest 57341 35442 13.0" 
$ns at 567.9701424131481 "$node_(492) setdest 48342 32912 4.0" 
$ns at 610.8591235422048 "$node_(492) setdest 98144 9460 12.0" 
$ns at 716.2667496692053 "$node_(492) setdest 19764 1068 8.0" 
$ns at 761.028418738195 "$node_(492) setdest 65619 34958 6.0" 
$ns at 792.9542945578028 "$node_(492) setdest 130477 211 4.0" 
$ns at 843.9830542696297 "$node_(492) setdest 15624 42744 6.0" 
$ns at 883.200010698511 "$node_(492) setdest 60430 9323 3.0" 
$ns at 404.6167751550116 "$node_(493) setdest 64130 22199 2.0" 
$ns at 438.2970863556764 "$node_(493) setdest 113940 37658 1.0" 
$ns at 469.4775411070376 "$node_(493) setdest 40619 719 14.0" 
$ns at 547.7082630134213 "$node_(493) setdest 124222 17596 19.0" 
$ns at 724.3653217354231 "$node_(493) setdest 16923 9568 7.0" 
$ns at 761.9654837212346 "$node_(493) setdest 44756 26349 15.0" 
$ns at 832.8452859528171 "$node_(493) setdest 75885 17243 15.0" 
$ns at 452.6666267647458 "$node_(494) setdest 114850 3577 3.0" 
$ns at 488.30985496345573 "$node_(494) setdest 98035 13096 11.0" 
$ns at 546.330435532316 "$node_(494) setdest 111775 13154 8.0" 
$ns at 579.7388280521675 "$node_(494) setdest 84390 17468 13.0" 
$ns at 697.2642713432436 "$node_(494) setdest 61564 43077 1.0" 
$ns at 730.8200603790618 "$node_(494) setdest 113969 41662 3.0" 
$ns at 785.4432935563628 "$node_(494) setdest 3547 17634 16.0" 
$ns at 819.1417182709113 "$node_(494) setdest 126645 5534 11.0" 
$ns at 470.82152229662864 "$node_(495) setdest 61352 15914 19.0" 
$ns at 562.5136735862098 "$node_(495) setdest 15046 11620 1.0" 
$ns at 597.3501056321776 "$node_(495) setdest 24553 16365 2.0" 
$ns at 640.2861298835495 "$node_(495) setdest 9015 40984 2.0" 
$ns at 681.2866031225624 "$node_(495) setdest 59032 19255 3.0" 
$ns at 730.0824339827077 "$node_(495) setdest 24329 29014 19.0" 
$ns at 439.31356302526564 "$node_(496) setdest 50147 16341 2.0" 
$ns at 476.42281148023545 "$node_(496) setdest 34594 39225 18.0" 
$ns at 549.44266006253 "$node_(496) setdest 113975 21156 1.0" 
$ns at 589.3211274744482 "$node_(496) setdest 22118 36721 11.0" 
$ns at 636.7940565522972 "$node_(496) setdest 62987 16551 8.0" 
$ns at 671.0774071358414 "$node_(496) setdest 88640 9209 7.0" 
$ns at 718.8695466511109 "$node_(496) setdest 78666 9059 12.0" 
$ns at 849.5610137139497 "$node_(496) setdest 15199 37471 12.0" 
$ns at 436.193856287547 "$node_(497) setdest 74347 16536 6.0" 
$ns at 473.16517453887616 "$node_(497) setdest 107727 31026 6.0" 
$ns at 512.3892133945458 "$node_(497) setdest 39147 17196 7.0" 
$ns at 551.6223248981162 "$node_(497) setdest 94918 4455 18.0" 
$ns at 588.5060274014664 "$node_(497) setdest 7880 36305 11.0" 
$ns at 635.011931660887 "$node_(497) setdest 93122 39342 20.0" 
$ns at 678.5166420436408 "$node_(497) setdest 77806 26212 19.0" 
$ns at 893.6186782240848 "$node_(497) setdest 58221 6582 14.0" 
$ns at 477.6822809799631 "$node_(498) setdest 92010 44425 12.0" 
$ns at 540.6585824077964 "$node_(498) setdest 9735 18540 3.0" 
$ns at 571.9129853883468 "$node_(498) setdest 10616 788 12.0" 
$ns at 651.0099727130823 "$node_(498) setdest 117677 37132 1.0" 
$ns at 681.2988802760832 "$node_(498) setdest 112929 25771 9.0" 
$ns at 748.3910715773211 "$node_(498) setdest 115686 25700 12.0" 
$ns at 829.2114958100428 "$node_(498) setdest 45995 42783 13.0" 
$ns at 467.39623759676806 "$node_(499) setdest 90378 11735 1.0" 
$ns at 497.54357493827786 "$node_(499) setdest 50457 41374 1.0" 
$ns at 533.3938578353518 "$node_(499) setdest 13349 8383 13.0" 
$ns at 593.7739411619388 "$node_(499) setdest 88492 28715 19.0" 
$ns at 806.1151871173554 "$node_(499) setdest 17135 26481 9.0" 
$ns at 527.3404299360718 "$node_(500) setdest 40726 10516 10.0" 
$ns at 656.9334135305196 "$node_(500) setdest 80717 8903 4.0" 
$ns at 712.3079924481833 "$node_(500) setdest 131576 36698 3.0" 
$ns at 747.6737024248846 "$node_(500) setdest 12479 22281 16.0" 
$ns at 816.752278412215 "$node_(500) setdest 130033 31742 12.0" 
$ns at 518.9630137934857 "$node_(501) setdest 121867 39307 9.0" 
$ns at 550.2518280557787 "$node_(501) setdest 15415 20340 13.0" 
$ns at 671.6440235216485 "$node_(501) setdest 11848 12969 16.0" 
$ns at 762.7479857987735 "$node_(501) setdest 61188 4529 1.0" 
$ns at 795.4187021886956 "$node_(501) setdest 33581 9343 3.0" 
$ns at 825.8115214352831 "$node_(501) setdest 5419 24750 4.0" 
$ns at 893.6687931814098 "$node_(501) setdest 143 15530 19.0" 
$ns at 583.8405619654085 "$node_(502) setdest 100347 10961 8.0" 
$ns at 674.4126795356476 "$node_(502) setdest 98996 41331 6.0" 
$ns at 731.9416214617555 "$node_(502) setdest 103154 25109 9.0" 
$ns at 795.4196896780455 "$node_(502) setdest 20946 17349 18.0" 
$ns at 595.303204325023 "$node_(503) setdest 104869 22194 10.0" 
$ns at 667.6703950458993 "$node_(503) setdest 73649 33696 9.0" 
$ns at 765.7449402883933 "$node_(503) setdest 50137 19075 15.0" 
$ns at 830.1076843952196 "$node_(503) setdest 73910 27266 2.0" 
$ns at 872.0549484082513 "$node_(503) setdest 89671 26647 9.0" 
$ns at 526.1641868488836 "$node_(504) setdest 58571 10471 3.0" 
$ns at 580.7398415968912 "$node_(504) setdest 44609 35876 8.0" 
$ns at 620.8368985771127 "$node_(504) setdest 63184 30755 14.0" 
$ns at 772.0226916566276 "$node_(504) setdest 99169 26087 11.0" 
$ns at 807.262232467194 "$node_(504) setdest 107346 19944 8.0" 
$ns at 847.1274253901233 "$node_(504) setdest 112702 12029 18.0" 
$ns at 530.70076851794 "$node_(505) setdest 26129 3198 12.0" 
$ns at 634.4617355665785 "$node_(505) setdest 75478 3960 8.0" 
$ns at 720.1345084987747 "$node_(505) setdest 106450 17117 5.0" 
$ns at 774.7755961534748 "$node_(505) setdest 129783 41023 8.0" 
$ns at 876.4619184013209 "$node_(505) setdest 71619 41697 10.0" 
$ns at 541.7940924411782 "$node_(506) setdest 110162 39414 1.0" 
$ns at 574.967041321283 "$node_(506) setdest 95854 8393 11.0" 
$ns at 652.0621651345214 "$node_(506) setdest 88899 16751 7.0" 
$ns at 712.9448311374456 "$node_(506) setdest 5888 32572 11.0" 
$ns at 772.0592476966065 "$node_(506) setdest 8554 14882 15.0" 
$ns at 597.0890327012 "$node_(507) setdest 68338 13352 6.0" 
$ns at 676.3108825970728 "$node_(507) setdest 98941 33 3.0" 
$ns at 706.5966222667205 "$node_(507) setdest 77507 36403 7.0" 
$ns at 739.0407405128364 "$node_(507) setdest 24380 40118 1.0" 
$ns at 769.2717854855305 "$node_(507) setdest 73911 3955 13.0" 
$ns at 852.0664118788031 "$node_(507) setdest 128692 41160 12.0" 
$ns at 556.8823329762782 "$node_(508) setdest 20883 20673 8.0" 
$ns at 601.6033933598474 "$node_(508) setdest 15711 25060 20.0" 
$ns at 668.0964143047742 "$node_(508) setdest 76180 38397 17.0" 
$ns at 808.6233591687927 "$node_(508) setdest 132217 39576 14.0" 
$ns at 608.7298961947096 "$node_(509) setdest 131321 36067 4.0" 
$ns at 664.8342494764911 "$node_(509) setdest 34296 10174 10.0" 
$ns at 716.8097565485624 "$node_(509) setdest 127598 10137 3.0" 
$ns at 756.3193128636906 "$node_(509) setdest 110010 39823 18.0" 
$ns at 860.2608075774526 "$node_(509) setdest 64729 26638 17.0" 
$ns at 505.29509659569294 "$node_(510) setdest 44408 35498 17.0" 
$ns at 603.0186701041265 "$node_(510) setdest 58981 13911 14.0" 
$ns at 633.2097789448837 "$node_(510) setdest 119636 9776 19.0" 
$ns at 742.1794967385057 "$node_(510) setdest 6488 14076 10.0" 
$ns at 793.3964980135339 "$node_(510) setdest 43117 15081 1.0" 
$ns at 830.2691578186 "$node_(510) setdest 131039 20074 5.0" 
$ns at 887.4422372235556 "$node_(510) setdest 119363 15989 9.0" 
$ns at 553.8118278081683 "$node_(511) setdest 1721 24841 10.0" 
$ns at 588.0921068336305 "$node_(511) setdest 78342 35004 3.0" 
$ns at 634.6508103404111 "$node_(511) setdest 55172 30244 8.0" 
$ns at 728.8754958049633 "$node_(511) setdest 119796 32965 14.0" 
$ns at 836.045987249581 "$node_(511) setdest 20869 23215 15.0" 
$ns at 874.5927684199606 "$node_(511) setdest 56149 5631 19.0" 
$ns at 523.0125581235858 "$node_(512) setdest 132967 40005 7.0" 
$ns at 559.3281000295649 "$node_(512) setdest 16812 35818 15.0" 
$ns at 645.7386860262147 "$node_(512) setdest 13513 28316 2.0" 
$ns at 683.7996474839023 "$node_(512) setdest 91571 1137 5.0" 
$ns at 757.6311473827238 "$node_(512) setdest 119091 22437 4.0" 
$ns at 789.6675338776032 "$node_(512) setdest 21047 33567 19.0" 
$ns at 873.8512443966424 "$node_(512) setdest 77294 29030 13.0" 
$ns at 510.72959190525074 "$node_(513) setdest 67647 17650 12.0" 
$ns at 601.4581100246435 "$node_(513) setdest 75900 2793 8.0" 
$ns at 663.7039054612665 "$node_(513) setdest 123823 17418 17.0" 
$ns at 794.1019940401575 "$node_(513) setdest 92635 18050 6.0" 
$ns at 829.1224111948231 "$node_(513) setdest 43138 22741 7.0" 
$ns at 530.5479099760821 "$node_(514) setdest 63597 41038 1.0" 
$ns at 564.6065071960953 "$node_(514) setdest 16010 38298 6.0" 
$ns at 602.4424613631909 "$node_(514) setdest 46630 36229 9.0" 
$ns at 652.6240606248654 "$node_(514) setdest 108140 11301 4.0" 
$ns at 692.5141104388643 "$node_(514) setdest 105031 16278 2.0" 
$ns at 728.3462889852548 "$node_(514) setdest 94118 12624 13.0" 
$ns at 820.0322985838313 "$node_(514) setdest 107466 17001 13.0" 
$ns at 549.244308435176 "$node_(515) setdest 44449 34900 4.0" 
$ns at 610.16108539813 "$node_(515) setdest 60159 30212 2.0" 
$ns at 653.2707351614304 "$node_(515) setdest 14289 22508 18.0" 
$ns at 816.7895082351174 "$node_(515) setdest 123120 24262 8.0" 
$ns at 511.92887751806387 "$node_(516) setdest 68497 9680 9.0" 
$ns at 631.478513091856 "$node_(516) setdest 119200 13896 5.0" 
$ns at 692.1865182525944 "$node_(516) setdest 19344 32173 9.0" 
$ns at 727.4934686059141 "$node_(516) setdest 73186 44363 2.0" 
$ns at 768.1515750869289 "$node_(516) setdest 115730 41944 12.0" 
$ns at 874.9476618021542 "$node_(516) setdest 48790 12805 16.0" 
$ns at 567.4718855869107 "$node_(517) setdest 115616 3874 5.0" 
$ns at 634.3972736987488 "$node_(517) setdest 129655 17050 8.0" 
$ns at 698.4281218462916 "$node_(517) setdest 83017 3990 4.0" 
$ns at 758.3906698888876 "$node_(517) setdest 41646 22352 16.0" 
$ns at 555.1719861255401 "$node_(518) setdest 123791 37994 7.0" 
$ns at 614.6065389525203 "$node_(518) setdest 87883 19994 13.0" 
$ns at 719.1124315092609 "$node_(518) setdest 25187 17274 3.0" 
$ns at 757.8530480760818 "$node_(518) setdest 28550 44659 3.0" 
$ns at 795.7183538598908 "$node_(518) setdest 72911 30868 20.0" 
$ns at 887.5589593397568 "$node_(518) setdest 1914 20462 7.0" 
$ns at 615.4953557332211 "$node_(519) setdest 61155 38907 19.0" 
$ns at 821.761515706339 "$node_(519) setdest 93225 24634 1.0" 
$ns at 856.3459896536577 "$node_(519) setdest 27125 41551 18.0" 
$ns at 514.2477868762064 "$node_(520) setdest 60473 33187 1.0" 
$ns at 551.3857982712307 "$node_(520) setdest 6887 8390 8.0" 
$ns at 642.4268902788003 "$node_(520) setdest 4581 39099 12.0" 
$ns at 725.8018364903385 "$node_(520) setdest 37880 29847 15.0" 
$ns at 862.426284588584 "$node_(520) setdest 77534 34113 12.0" 
$ns at 605.5137372219207 "$node_(521) setdest 128536 20515 2.0" 
$ns at 655.1766386642649 "$node_(521) setdest 49470 11018 16.0" 
$ns at 747.776656702526 "$node_(521) setdest 111812 29976 15.0" 
$ns at 876.6438120883442 "$node_(521) setdest 87515 37752 5.0" 
$ns at 551.9561060562121 "$node_(522) setdest 18408 16661 9.0" 
$ns at 625.4406478593877 "$node_(522) setdest 69128 30240 8.0" 
$ns at 657.8190343076964 "$node_(522) setdest 55139 32557 11.0" 
$ns at 688.2794500370361 "$node_(522) setdest 118905 27248 1.0" 
$ns at 726.7148653717549 "$node_(522) setdest 52782 22531 15.0" 
$ns at 850.8627186796836 "$node_(522) setdest 114498 25582 18.0" 
$ns at 568.5346008459902 "$node_(523) setdest 293 5783 13.0" 
$ns at 720.4719581796919 "$node_(523) setdest 93243 14379 3.0" 
$ns at 773.3609591069362 "$node_(523) setdest 7467 35030 3.0" 
$ns at 828.9612667142943 "$node_(523) setdest 86267 43276 2.0" 
$ns at 861.4304894204307 "$node_(523) setdest 130721 1108 20.0" 
$ns at 536.8689824373216 "$node_(524) setdest 17746 21245 14.0" 
$ns at 625.0867740085731 "$node_(524) setdest 69769 13533 7.0" 
$ns at 655.7168456934829 "$node_(524) setdest 116224 6585 4.0" 
$ns at 702.6574606123704 "$node_(524) setdest 6644 9599 12.0" 
$ns at 774.4155639187887 "$node_(524) setdest 3612 37439 6.0" 
$ns at 825.557621003658 "$node_(524) setdest 25292 27903 7.0" 
$ns at 513.9673915645722 "$node_(525) setdest 98589 38042 13.0" 
$ns at 554.3486869967093 "$node_(525) setdest 87943 11463 6.0" 
$ns at 637.5486370692446 "$node_(525) setdest 119193 11917 17.0" 
$ns at 734.1707396793827 "$node_(525) setdest 99756 20482 9.0" 
$ns at 789.7655952193475 "$node_(525) setdest 114272 35937 7.0" 
$ns at 829.7444636191093 "$node_(525) setdest 45018 44466 19.0" 
$ns at 536.7795731198232 "$node_(526) setdest 33044 43283 10.0" 
$ns at 588.4440217384227 "$node_(526) setdest 128718 9656 2.0" 
$ns at 637.0037239299924 "$node_(526) setdest 41104 43560 14.0" 
$ns at 727.9187861728652 "$node_(526) setdest 82971 509 10.0" 
$ns at 813.6927165262857 "$node_(526) setdest 85339 28033 9.0" 
$ns at 866.6363372806951 "$node_(526) setdest 66922 31579 1.0" 
$ns at 897.5519141247152 "$node_(526) setdest 125165 33150 13.0" 
$ns at 587.3412831287021 "$node_(527) setdest 84422 36226 8.0" 
$ns at 688.173618506852 "$node_(527) setdest 128765 7072 8.0" 
$ns at 788.3003321894226 "$node_(527) setdest 109991 23077 6.0" 
$ns at 860.0955407876417 "$node_(527) setdest 35101 43997 18.0" 
$ns at 555.6736499192423 "$node_(528) setdest 25086 42122 16.0" 
$ns at 703.6685226955402 "$node_(528) setdest 25412 27897 9.0" 
$ns at 797.1166954533329 "$node_(528) setdest 98557 43991 1.0" 
$ns at 836.3244107624785 "$node_(528) setdest 74118 23664 5.0" 
$ns at 893.2286083681676 "$node_(528) setdest 21285 26650 2.0" 
$ns at 550.1011886151205 "$node_(529) setdest 12335 34769 16.0" 
$ns at 591.8030059141292 "$node_(529) setdest 26100 43135 2.0" 
$ns at 626.7866287308004 "$node_(529) setdest 103097 30780 9.0" 
$ns at 718.384102987474 "$node_(529) setdest 28675 11135 8.0" 
$ns at 779.359899862207 "$node_(529) setdest 112908 35906 5.0" 
$ns at 812.5313212894075 "$node_(529) setdest 80490 2241 14.0" 
$ns at 854.4128506830205 "$node_(529) setdest 73421 31646 4.0" 
$ns at 521.6821553124189 "$node_(530) setdest 20442 15658 9.0" 
$ns at 636.8394358736191 "$node_(530) setdest 115822 19691 1.0" 
$ns at 676.3051181363182 "$node_(530) setdest 49351 12964 20.0" 
$ns at 784.3554897686442 "$node_(530) setdest 32575 23629 14.0" 
$ns at 501.126910516177 "$node_(531) setdest 125270 25499 19.0" 
$ns at 538.4777289528574 "$node_(531) setdest 33563 9753 9.0" 
$ns at 577.8287707735719 "$node_(531) setdest 5108 23919 9.0" 
$ns at 686.1978379273106 "$node_(531) setdest 25375 36082 6.0" 
$ns at 738.7293071747118 "$node_(531) setdest 41854 32018 16.0" 
$ns at 821.7918090254046 "$node_(531) setdest 127537 9139 10.0" 
$ns at 863.7501518636979 "$node_(531) setdest 32920 41857 17.0" 
$ns at 598.5598730527796 "$node_(532) setdest 107853 37294 17.0" 
$ns at 729.4403122397601 "$node_(532) setdest 56428 32974 5.0" 
$ns at 797.4545344127138 "$node_(532) setdest 109820 21246 4.0" 
$ns at 841.3477410806802 "$node_(532) setdest 6642 18237 9.0" 
$ns at 547.8260586025096 "$node_(533) setdest 115068 1925 4.0" 
$ns at 609.7790911447371 "$node_(533) setdest 105431 27927 13.0" 
$ns at 764.5964495151829 "$node_(533) setdest 132264 20610 15.0" 
$ns at 803.44870710754 "$node_(533) setdest 103965 1339 14.0" 
$ns at 521.5806632444841 "$node_(534) setdest 18330 20820 13.0" 
$ns at 562.00804209438 "$node_(534) setdest 24211 28561 5.0" 
$ns at 593.917856994044 "$node_(534) setdest 98992 6877 1.0" 
$ns at 627.9878919645485 "$node_(534) setdest 7584 30824 9.0" 
$ns at 689.2402857735756 "$node_(534) setdest 76653 23299 17.0" 
$ns at 787.2416530799983 "$node_(534) setdest 58464 27067 11.0" 
$ns at 820.4899507564202 "$node_(534) setdest 106217 40641 15.0" 
$ns at 575.7936174587306 "$node_(535) setdest 34277 4159 18.0" 
$ns at 634.6752917418652 "$node_(535) setdest 53790 30717 14.0" 
$ns at 703.0640922007026 "$node_(535) setdest 54046 16762 18.0" 
$ns at 749.9769710246394 "$node_(535) setdest 119881 42791 14.0" 
$ns at 861.7648233541225 "$node_(535) setdest 6430 14067 19.0" 
$ns at 518.3329522484181 "$node_(536) setdest 57130 32327 5.0" 
$ns at 593.7752377087365 "$node_(536) setdest 109634 7370 18.0" 
$ns at 763.0075597461436 "$node_(536) setdest 37192 41826 9.0" 
$ns at 860.3619709082741 "$node_(536) setdest 16766 40991 5.0" 
$ns at 677.9596464184134 "$node_(537) setdest 130383 3059 9.0" 
$ns at 749.5250768916596 "$node_(537) setdest 5751 1002 9.0" 
$ns at 826.1428331246744 "$node_(537) setdest 105210 27861 13.0" 
$ns at 862.2021887481677 "$node_(537) setdest 125543 35165 11.0" 
$ns at 510.2653271446404 "$node_(538) setdest 77141 43026 1.0" 
$ns at 544.6930743549082 "$node_(538) setdest 92309 19989 5.0" 
$ns at 610.6951458670371 "$node_(538) setdest 75779 36611 2.0" 
$ns at 647.627359699871 "$node_(538) setdest 71151 36546 13.0" 
$ns at 762.7018207974764 "$node_(538) setdest 51736 29757 12.0" 
$ns at 831.5398700763675 "$node_(538) setdest 116643 18178 8.0" 
$ns at 591.7545963188156 "$node_(539) setdest 42508 35633 16.0" 
$ns at 699.1581732386236 "$node_(539) setdest 79879 22456 14.0" 
$ns at 794.6586895991534 "$node_(539) setdest 61581 20055 6.0" 
$ns at 880.9500114411708 "$node_(539) setdest 45044 33799 3.0" 
$ns at 514.0093785575303 "$node_(540) setdest 129607 35475 15.0" 
$ns at 690.6975118011383 "$node_(540) setdest 62338 31696 8.0" 
$ns at 728.2735607511315 "$node_(540) setdest 54356 16191 15.0" 
$ns at 782.9811622414768 "$node_(540) setdest 72241 41884 18.0" 
$ns at 872.7336704301251 "$node_(540) setdest 92476 43623 6.0" 
$ns at 591.0359051847009 "$node_(541) setdest 89314 24412 1.0" 
$ns at 630.1741785684505 "$node_(541) setdest 32271 23623 5.0" 
$ns at 676.3987107539397 "$node_(541) setdest 16896 7379 8.0" 
$ns at 706.9958997698944 "$node_(541) setdest 91745 32628 14.0" 
$ns at 769.41282520081 "$node_(541) setdest 37213 31583 20.0" 
$ns at 820.6488852665966 "$node_(541) setdest 31625 14638 2.0" 
$ns at 858.8130980965386 "$node_(541) setdest 21838 33366 10.0" 
$ns at 515.3947670962588 "$node_(542) setdest 40199 1905 13.0" 
$ns at 599.893281184064 "$node_(542) setdest 112372 20327 15.0" 
$ns at 673.3947438879129 "$node_(542) setdest 33335 32318 17.0" 
$ns at 790.0509375655871 "$node_(542) setdest 86928 13373 20.0" 
$ns at 507.5854142522656 "$node_(543) setdest 92608 25722 19.0" 
$ns at 599.1145966752391 "$node_(543) setdest 43940 14623 1.0" 
$ns at 630.6397361553106 "$node_(543) setdest 43334 24117 10.0" 
$ns at 676.3476933813348 "$node_(543) setdest 93789 22048 10.0" 
$ns at 780.4633287519415 "$node_(543) setdest 36282 39383 16.0" 
$ns at 511.4138668260874 "$node_(544) setdest 35919 10113 4.0" 
$ns at 555.500885731518 "$node_(544) setdest 41627 24064 8.0" 
$ns at 656.1368385842206 "$node_(544) setdest 130455 8015 1.0" 
$ns at 691.368338791586 "$node_(544) setdest 125815 29626 7.0" 
$ns at 771.9692214586057 "$node_(544) setdest 71099 5422 18.0" 
$ns at 539.7613027457002 "$node_(545) setdest 31596 9828 16.0" 
$ns at 700.791622469634 "$node_(545) setdest 133099 40820 17.0" 
$ns at 852.0370945139512 "$node_(545) setdest 123902 22333 11.0" 
$ns at 524.9962389817423 "$node_(546) setdest 44195 29310 2.0" 
$ns at 559.4900190090034 "$node_(546) setdest 61043 16760 16.0" 
$ns at 595.446511500003 "$node_(546) setdest 48735 28473 15.0" 
$ns at 716.4283367361273 "$node_(546) setdest 88993 7535 17.0" 
$ns at 783.3624979911081 "$node_(546) setdest 56229 44679 12.0" 
$ns at 835.0494915776347 "$node_(546) setdest 132779 18844 16.0" 
$ns at 546.1198064934244 "$node_(547) setdest 34051 24708 10.0" 
$ns at 661.0026014570608 "$node_(547) setdest 30861 18707 4.0" 
$ns at 711.2267119784731 "$node_(547) setdest 20756 4072 7.0" 
$ns at 794.0029790879153 "$node_(547) setdest 107585 39402 14.0" 
$ns at 876.2403208578739 "$node_(547) setdest 77495 12146 6.0" 
$ns at 543.701245977999 "$node_(548) setdest 108680 37179 3.0" 
$ns at 591.0462446603545 "$node_(548) setdest 6633 8708 6.0" 
$ns at 635.2740828554932 "$node_(548) setdest 91783 42206 8.0" 
$ns at 737.0859565271053 "$node_(548) setdest 36231 29153 12.0" 
$ns at 794.1155452987367 "$node_(548) setdest 109920 1470 18.0" 
$ns at 512.7782083894081 "$node_(549) setdest 3490 8616 10.0" 
$ns at 612.9723344149561 "$node_(549) setdest 176 35784 12.0" 
$ns at 709.2503775238541 "$node_(549) setdest 99943 40829 18.0" 
$ns at 529.3061557260364 "$node_(550) setdest 104859 17218 15.0" 
$ns at 635.3878018595668 "$node_(550) setdest 26164 21093 13.0" 
$ns at 788.5898230123307 "$node_(550) setdest 128425 28280 11.0" 
$ns at 638.5464218814393 "$node_(551) setdest 103022 2400 14.0" 
$ns at 702.0898012930768 "$node_(551) setdest 56768 26340 14.0" 
$ns at 732.3954733107036 "$node_(551) setdest 122412 39487 18.0" 
$ns at 844.0062089877458 "$node_(551) setdest 132242 44214 10.0" 
$ns at 539.3336882205598 "$node_(552) setdest 74211 43176 14.0" 
$ns at 702.0423069237029 "$node_(552) setdest 131728 6115 11.0" 
$ns at 803.8861987969157 "$node_(552) setdest 19570 3186 3.0" 
$ns at 853.3396122666064 "$node_(552) setdest 22505 38086 2.0" 
$ns at 897.590628107018 "$node_(552) setdest 129419 6317 9.0" 
$ns at 595.1862854834283 "$node_(553) setdest 46049 17644 17.0" 
$ns at 627.633615771166 "$node_(553) setdest 8733 11063 7.0" 
$ns at 680.7763297994962 "$node_(553) setdest 109152 13481 6.0" 
$ns at 720.168442611302 "$node_(553) setdest 35432 37748 20.0" 
$ns at 881.1725178510897 "$node_(553) setdest 11615 25966 1.0" 
$ns at 520.1310369651095 "$node_(554) setdest 27330 4757 7.0" 
$ns at 580.038847185293 "$node_(554) setdest 112893 3049 20.0" 
$ns at 748.7722131216206 "$node_(554) setdest 106855 5729 6.0" 
$ns at 803.1732472209044 "$node_(554) setdest 316 21311 1.0" 
$ns at 840.1089112450945 "$node_(554) setdest 129784 17973 13.0" 
$ns at 512.5542832138623 "$node_(555) setdest 85588 21557 2.0" 
$ns at 550.7487367706171 "$node_(555) setdest 47503 10227 5.0" 
$ns at 626.5836543600674 "$node_(555) setdest 113839 39653 13.0" 
$ns at 716.3036598467077 "$node_(555) setdest 60511 34518 6.0" 
$ns at 761.5075957429832 "$node_(555) setdest 107911 16306 12.0" 
$ns at 562.1891031123719 "$node_(556) setdest 4802 34456 3.0" 
$ns at 616.0932133376899 "$node_(556) setdest 46277 14039 6.0" 
$ns at 693.8683700962339 "$node_(556) setdest 70252 9513 12.0" 
$ns at 796.5666320285192 "$node_(556) setdest 87117 11793 1.0" 
$ns at 832.971849865147 "$node_(556) setdest 22488 12327 7.0" 
$ns at 582.7623746544461 "$node_(557) setdest 58551 41594 6.0" 
$ns at 672.2187167110492 "$node_(557) setdest 96415 35043 7.0" 
$ns at 746.6662248487579 "$node_(557) setdest 80218 33674 12.0" 
$ns at 868.4973582993158 "$node_(557) setdest 115607 24534 16.0" 
$ns at 605.6141677790531 "$node_(558) setdest 117988 2717 15.0" 
$ns at 707.4719750618497 "$node_(558) setdest 63571 6476 2.0" 
$ns at 754.111745856153 "$node_(558) setdest 114066 24145 7.0" 
$ns at 825.4009519574367 "$node_(558) setdest 59096 21175 14.0" 
$ns at 592.6249625561322 "$node_(559) setdest 18997 22846 13.0" 
$ns at 653.2019922965504 "$node_(559) setdest 124823 37744 17.0" 
$ns at 736.1707912411484 "$node_(559) setdest 2443 29617 1.0" 
$ns at 768.0794383542828 "$node_(559) setdest 62927 29272 13.0" 
$ns at 544.2651228169734 "$node_(560) setdest 119584 39562 15.0" 
$ns at 617.7248602722478 "$node_(560) setdest 117773 1165 7.0" 
$ns at 671.1390602985281 "$node_(560) setdest 117248 25199 8.0" 
$ns at 773.7969564625795 "$node_(560) setdest 24095 25397 11.0" 
$ns at 859.9449972442383 "$node_(560) setdest 42172 36326 20.0" 
$ns at 893.9639994634113 "$node_(560) setdest 83635 42868 14.0" 
$ns at 686.4052768310461 "$node_(561) setdest 97665 28597 9.0" 
$ns at 798.5122592943305 "$node_(561) setdest 103515 34540 20.0" 
$ns at 566.1155885934126 "$node_(562) setdest 70288 31687 12.0" 
$ns at 651.131316724169 "$node_(562) setdest 125460 42806 1.0" 
$ns at 689.8277021341856 "$node_(562) setdest 67525 30997 5.0" 
$ns at 739.6335654876426 "$node_(562) setdest 40110 41486 4.0" 
$ns at 775.5806085930068 "$node_(562) setdest 96533 3421 1.0" 
$ns at 811.675200500209 "$node_(562) setdest 121384 29305 11.0" 
$ns at 543.2320844385349 "$node_(563) setdest 72576 42457 5.0" 
$ns at 595.4273452421611 "$node_(563) setdest 22318 24831 18.0" 
$ns at 746.3476500856423 "$node_(563) setdest 53018 23201 11.0" 
$ns at 792.152037037237 "$node_(563) setdest 35803 9572 17.0" 
$ns at 612.8478442904927 "$node_(564) setdest 83981 1963 18.0" 
$ns at 761.9218578234718 "$node_(564) setdest 8890 4597 13.0" 
$ns at 847.4382240813587 "$node_(564) setdest 27729 19845 17.0" 
$ns at 536.2258126062648 "$node_(565) setdest 55718 17093 7.0" 
$ns at 618.6872571753046 "$node_(565) setdest 7785 33746 5.0" 
$ns at 696.4200668924307 "$node_(565) setdest 45892 2111 16.0" 
$ns at 774.5126173284776 "$node_(565) setdest 122723 16742 15.0" 
$ns at 511.41526392206777 "$node_(566) setdest 1274 39764 16.0" 
$ns at 583.5038829425948 "$node_(566) setdest 27753 27786 12.0" 
$ns at 667.8938940673038 "$node_(566) setdest 123670 20865 20.0" 
$ns at 876.3669528921223 "$node_(566) setdest 133964 1713 2.0" 
$ns at 569.4207841371153 "$node_(567) setdest 19402 40351 15.0" 
$ns at 739.9895296230836 "$node_(567) setdest 132098 11170 19.0" 
$ns at 523.2535299963192 "$node_(568) setdest 45635 11409 19.0" 
$ns at 598.7659137540381 "$node_(568) setdest 472 40973 1.0" 
$ns at 633.9926523363162 "$node_(568) setdest 90875 21793 1.0" 
$ns at 665.0129662240244 "$node_(568) setdest 11423 9313 15.0" 
$ns at 741.7736631545829 "$node_(568) setdest 90839 17481 2.0" 
$ns at 774.4413477043151 "$node_(568) setdest 33849 19855 7.0" 
$ns at 858.5629088791256 "$node_(568) setdest 130919 13225 19.0" 
$ns at 531.4602947739139 "$node_(569) setdest 93493 19069 7.0" 
$ns at 582.3663635851854 "$node_(569) setdest 2622 2236 12.0" 
$ns at 685.8898724572385 "$node_(569) setdest 96715 34799 17.0" 
$ns at 866.6275626387103 "$node_(569) setdest 7254 15684 11.0" 
$ns at 557.475354307863 "$node_(570) setdest 116891 8950 14.0" 
$ns at 615.0483341457515 "$node_(570) setdest 94087 27245 11.0" 
$ns at 735.3103137367847 "$node_(570) setdest 8406 8315 15.0" 
$ns at 596.3161683336463 "$node_(571) setdest 94780 18337 17.0" 
$ns at 785.8883870076971 "$node_(571) setdest 2668 40748 10.0" 
$ns at 818.0164383393629 "$node_(571) setdest 64046 7583 14.0" 
$ns at 515.3189980089188 "$node_(572) setdest 4341 41655 19.0" 
$ns at 547.5339309338261 "$node_(572) setdest 33976 24932 19.0" 
$ns at 644.6091760930329 "$node_(572) setdest 109022 22882 9.0" 
$ns at 755.4825473061103 "$node_(572) setdest 95824 24760 12.0" 
$ns at 832.6482714288048 "$node_(572) setdest 103249 31551 9.0" 
$ns at 572.860840075243 "$node_(573) setdest 82105 35360 14.0" 
$ns at 611.9532582204691 "$node_(573) setdest 100112 5134 2.0" 
$ns at 660.2069850663806 "$node_(573) setdest 21682 4646 1.0" 
$ns at 697.5672005336257 "$node_(573) setdest 85136 31891 2.0" 
$ns at 742.4993192352757 "$node_(573) setdest 35978 29631 8.0" 
$ns at 810.484328919797 "$node_(573) setdest 29585 28246 5.0" 
$ns at 876.5318124981102 "$node_(573) setdest 85044 36504 18.0" 
$ns at 613.0749352602982 "$node_(574) setdest 24405 16408 16.0" 
$ns at 715.2691018620089 "$node_(574) setdest 93174 10189 15.0" 
$ns at 816.534189532783 "$node_(574) setdest 104040 19514 10.0" 
$ns at 533.5812791364021 "$node_(575) setdest 68400 6923 2.0" 
$ns at 576.8334528824666 "$node_(575) setdest 78775 37860 8.0" 
$ns at 635.656864685107 "$node_(575) setdest 53856 4151 4.0" 
$ns at 704.6130354814612 "$node_(575) setdest 130115 22428 19.0" 
$ns at 759.2845884296121 "$node_(575) setdest 113094 14040 19.0" 
$ns at 526.9927958463727 "$node_(576) setdest 89760 7323 10.0" 
$ns at 649.3664088196662 "$node_(576) setdest 42942 44084 12.0" 
$ns at 752.100558312234 "$node_(576) setdest 19338 40842 3.0" 
$ns at 799.7607240922271 "$node_(576) setdest 110016 16953 18.0" 
$ns at 506.21913610816165 "$node_(577) setdest 44336 34737 5.0" 
$ns at 570.6986395723661 "$node_(577) setdest 7550 10662 14.0" 
$ns at 678.1623577202317 "$node_(577) setdest 56807 9402 8.0" 
$ns at 752.6366627221987 "$node_(577) setdest 119422 3609 13.0" 
$ns at 797.4676738788781 "$node_(577) setdest 106365 17371 16.0" 
$ns at 529.4409413866202 "$node_(578) setdest 125145 8526 15.0" 
$ns at 570.1352019741073 "$node_(578) setdest 44750 22146 8.0" 
$ns at 632.8821404118057 "$node_(578) setdest 63851 4718 16.0" 
$ns at 734.0010593300921 "$node_(578) setdest 23056 25852 10.0" 
$ns at 776.8170679090939 "$node_(578) setdest 67682 12195 1.0" 
$ns at 809.1058780505754 "$node_(578) setdest 23741 25587 8.0" 
$ns at 878.6034673235422 "$node_(578) setdest 67890 44445 9.0" 
$ns at 505.9041932979519 "$node_(579) setdest 69833 35823 4.0" 
$ns at 566.0166816059326 "$node_(579) setdest 93809 41962 7.0" 
$ns at 650.5538618270265 "$node_(579) setdest 122897 6533 17.0" 
$ns at 759.4849491080926 "$node_(579) setdest 26731 12596 4.0" 
$ns at 803.267056948988 "$node_(579) setdest 121806 41652 3.0" 
$ns at 835.4254303838513 "$node_(579) setdest 73937 24865 11.0" 
$ns at 501.31989352539404 "$node_(580) setdest 57050 7424 2.0" 
$ns at 533.8544946212197 "$node_(580) setdest 50308 8647 15.0" 
$ns at 603.2991113197106 "$node_(580) setdest 96000 9588 15.0" 
$ns at 639.8196929697763 "$node_(580) setdest 49098 11862 2.0" 
$ns at 680.9189717263353 "$node_(580) setdest 37943 23046 14.0" 
$ns at 826.3528880384973 "$node_(580) setdest 115885 4452 4.0" 
$ns at 889.1216221563733 "$node_(580) setdest 110931 448 19.0" 
$ns at 531.461236543141 "$node_(581) setdest 5288 18725 8.0" 
$ns at 623.0817570172632 "$node_(581) setdest 128675 44679 14.0" 
$ns at 772.8562027086748 "$node_(581) setdest 66505 31578 17.0" 
$ns at 707.0513762423413 "$node_(582) setdest 111799 1603 17.0" 
$ns at 749.0331578485091 "$node_(582) setdest 22210 41031 9.0" 
$ns at 803.2647695736699 "$node_(582) setdest 24911 9432 4.0" 
$ns at 869.0766821358366 "$node_(582) setdest 16480 15625 12.0" 
$ns at 511.3808009598324 "$node_(583) setdest 22786 7820 12.0" 
$ns at 650.7819584844169 "$node_(583) setdest 23738 28266 18.0" 
$ns at 749.1398859303008 "$node_(583) setdest 15038 20721 15.0" 
$ns at 832.1300751172835 "$node_(583) setdest 10123 40445 1.0" 
$ns at 863.1311752261365 "$node_(583) setdest 37767 9945 8.0" 
$ns at 515.8796107718356 "$node_(584) setdest 34904 18081 16.0" 
$ns at 557.9751757358961 "$node_(584) setdest 40109 20999 5.0" 
$ns at 608.1009463322655 "$node_(584) setdest 92667 43468 1.0" 
$ns at 645.235521157975 "$node_(584) setdest 52292 410 3.0" 
$ns at 680.2604540851564 "$node_(584) setdest 113703 8652 2.0" 
$ns at 726.0929085219697 "$node_(584) setdest 115223 15464 13.0" 
$ns at 785.0028593737729 "$node_(584) setdest 716 29611 18.0" 
$ns at 839.1058312177064 "$node_(584) setdest 30634 17731 17.0" 
$ns at 521.6587530640098 "$node_(585) setdest 58380 17589 1.0" 
$ns at 558.3404069691587 "$node_(585) setdest 114808 3098 14.0" 
$ns at 603.0571473074039 "$node_(585) setdest 34211 39201 4.0" 
$ns at 668.9935676553399 "$node_(585) setdest 48533 32536 14.0" 
$ns at 781.6778825308782 "$node_(585) setdest 113556 1541 5.0" 
$ns at 838.0524561347705 "$node_(585) setdest 47193 8282 6.0" 
$ns at 513.9148215828616 "$node_(586) setdest 67966 3764 18.0" 
$ns at 655.5570360608019 "$node_(586) setdest 62421 33901 11.0" 
$ns at 749.6443371609964 "$node_(586) setdest 9061 21608 3.0" 
$ns at 784.9490433425304 "$node_(586) setdest 22362 7136 10.0" 
$ns at 842.4044081721458 "$node_(586) setdest 41476 39979 18.0" 
$ns at 596.0030309838802 "$node_(587) setdest 49406 15269 1.0" 
$ns at 629.6539591099864 "$node_(587) setdest 106020 38632 7.0" 
$ns at 703.5062653807232 "$node_(587) setdest 80603 19031 11.0" 
$ns at 797.7709517484028 "$node_(587) setdest 27156 42217 13.0" 
$ns at 562.5952237217424 "$node_(588) setdest 121213 42378 13.0" 
$ns at 663.0721354760589 "$node_(588) setdest 34833 113 19.0" 
$ns at 744.9603343898324 "$node_(588) setdest 20131 36525 17.0" 
$ns at 530.308379006774 "$node_(589) setdest 96363 705 5.0" 
$ns at 606.4687109517326 "$node_(589) setdest 4355 11693 16.0" 
$ns at 741.3266968730965 "$node_(589) setdest 122784 34365 1.0" 
$ns at 772.4928052669366 "$node_(589) setdest 95213 40605 3.0" 
$ns at 826.3208169664227 "$node_(589) setdest 60313 7178 20.0" 
$ns at 870.8211872904365 "$node_(589) setdest 120240 17544 10.0" 
$ns at 538.1189330839766 "$node_(590) setdest 83817 40662 7.0" 
$ns at 575.6911222094424 "$node_(590) setdest 300 37515 2.0" 
$ns at 615.8227581379277 "$node_(590) setdest 8154 28805 6.0" 
$ns at 691.7198862850634 "$node_(590) setdest 27533 38343 1.0" 
$ns at 724.9154578698685 "$node_(590) setdest 80943 28689 12.0" 
$ns at 846.8515258774305 "$node_(590) setdest 34150 36913 7.0" 
$ns at 551.1564528362161 "$node_(591) setdest 120646 3558 17.0" 
$ns at 665.4117345308869 "$node_(591) setdest 81704 41133 15.0" 
$ns at 796.6169663305268 "$node_(591) setdest 108884 40897 12.0" 
$ns at 844.0805773025655 "$node_(591) setdest 24238 21391 11.0" 
$ns at 879.8950877301136 "$node_(591) setdest 131920 35024 11.0" 
$ns at 541.3490311109956 "$node_(592) setdest 131136 21156 5.0" 
$ns at 608.6422645956765 "$node_(592) setdest 129626 28210 15.0" 
$ns at 701.3420706183086 "$node_(592) setdest 126821 25507 1.0" 
$ns at 733.6874226958646 "$node_(592) setdest 12146 22615 4.0" 
$ns at 783.6593138622391 "$node_(592) setdest 37427 32722 10.0" 
$ns at 823.402153820618 "$node_(592) setdest 120928 34456 7.0" 
$ns at 855.0618276591524 "$node_(592) setdest 102618 14749 10.0" 
$ns at 557.5109144769604 "$node_(593) setdest 49142 15780 14.0" 
$ns at 683.0284886075183 "$node_(593) setdest 121231 40600 1.0" 
$ns at 719.3503523847907 "$node_(593) setdest 104994 12577 17.0" 
$ns at 765.6799806731118 "$node_(593) setdest 54168 32783 6.0" 
$ns at 809.2111313426639 "$node_(593) setdest 69425 20573 13.0" 
$ns at 847.9404258616249 "$node_(593) setdest 39498 36999 14.0" 
$ns at 552.4488661911832 "$node_(594) setdest 24188 35514 12.0" 
$ns at 623.5240032621863 "$node_(594) setdest 127625 5942 11.0" 
$ns at 733.631844386927 "$node_(594) setdest 25582 1273 5.0" 
$ns at 774.8283542470015 "$node_(594) setdest 127635 27843 15.0" 
$ns at 864.2216371403198 "$node_(594) setdest 69614 42155 8.0" 
$ns at 533.2316979214693 "$node_(595) setdest 112146 9543 1.0" 
$ns at 571.5855953683799 "$node_(595) setdest 55394 13933 12.0" 
$ns at 705.3674039709315 "$node_(595) setdest 124041 6141 1.0" 
$ns at 737.4400568850399 "$node_(595) setdest 117961 17791 1.0" 
$ns at 776.0256282226876 "$node_(595) setdest 84558 37089 2.0" 
$ns at 809.0063088022491 "$node_(595) setdest 64974 5362 19.0" 
$ns at 538.6954797376178 "$node_(596) setdest 126076 38906 9.0" 
$ns at 586.5117942918132 "$node_(596) setdest 66071 23457 1.0" 
$ns at 624.0219328821373 "$node_(596) setdest 49423 10998 12.0" 
$ns at 684.8207189210616 "$node_(596) setdest 39823 7520 14.0" 
$ns at 723.8915012846526 "$node_(596) setdest 42152 24475 15.0" 
$ns at 809.157786273408 "$node_(596) setdest 64173 2920 13.0" 
$ns at 868.0918192369736 "$node_(596) setdest 128105 15571 3.0" 
$ns at 594.3293975756308 "$node_(597) setdest 60204 24241 9.0" 
$ns at 681.2653135529192 "$node_(597) setdest 102358 23219 16.0" 
$ns at 764.2070897872769 "$node_(597) setdest 23680 28724 3.0" 
$ns at 798.7416050714858 "$node_(597) setdest 12806 41849 8.0" 
$ns at 878.1293092838357 "$node_(597) setdest 52168 35082 9.0" 
$ns at 525.5226551688124 "$node_(598) setdest 63970 23465 13.0" 
$ns at 620.1916554738406 "$node_(598) setdest 56579 42557 9.0" 
$ns at 726.3198766271097 "$node_(598) setdest 58952 10802 10.0" 
$ns at 784.8737201416295 "$node_(598) setdest 77764 30068 10.0" 
$ns at 825.5113042705215 "$node_(598) setdest 129867 15645 4.0" 
$ns at 874.6061105914478 "$node_(598) setdest 118672 3266 9.0" 
$ns at 508.0830096319157 "$node_(599) setdest 75427 26469 13.0" 
$ns at 561.4250480453693 "$node_(599) setdest 1445 2396 17.0" 
$ns at 691.6572642460346 "$node_(599) setdest 75709 2393 5.0" 
$ns at 759.6754846445317 "$node_(599) setdest 107484 36229 9.0" 
$ns at 852.6668872155847 "$node_(599) setdest 12768 29681 12.0" 
$ns at 654.3095932622718 "$node_(600) setdest 133595 27780 19.0" 
$ns at 851.1549182258586 "$node_(600) setdest 126608 32136 17.0" 
$ns at 890.1009864851773 "$node_(600) setdest 3732 41475 19.0" 
$ns at 668.6607743769544 "$node_(601) setdest 116987 39912 5.0" 
$ns at 740.4685818309778 "$node_(601) setdest 73257 8555 6.0" 
$ns at 775.2103532610074 "$node_(601) setdest 18584 19983 7.0" 
$ns at 840.4433782956459 "$node_(601) setdest 72406 20302 1.0" 
$ns at 874.3826050999359 "$node_(601) setdest 38346 35196 18.0" 
$ns at 648.4738136642916 "$node_(602) setdest 7184 7074 20.0" 
$ns at 824.1453240598308 "$node_(602) setdest 51718 25952 10.0" 
$ns at 884.4485309335073 "$node_(602) setdest 3505 2377 4.0" 
$ns at 677.2417761513337 "$node_(603) setdest 123778 8342 18.0" 
$ns at 827.2185324382367 "$node_(603) setdest 40098 4954 10.0" 
$ns at 613.6541595578352 "$node_(604) setdest 98341 6283 15.0" 
$ns at 679.5653448788983 "$node_(604) setdest 2757 403 10.0" 
$ns at 796.9113493498938 "$node_(604) setdest 15824 30753 12.0" 
$ns at 613.3992544807555 "$node_(605) setdest 60627 20910 19.0" 
$ns at 722.0916682125076 "$node_(605) setdest 104364 38398 7.0" 
$ns at 772.6509763383788 "$node_(605) setdest 77278 22580 8.0" 
$ns at 808.9384001759715 "$node_(605) setdest 102272 41091 15.0" 
$ns at 859.1286666766678 "$node_(605) setdest 8958 6322 16.0" 
$ns at 601.2096145804785 "$node_(606) setdest 129244 19356 7.0" 
$ns at 644.2470405764736 "$node_(606) setdest 3290 19392 1.0" 
$ns at 682.2015721178923 "$node_(606) setdest 86111 42735 16.0" 
$ns at 791.3700170603614 "$node_(606) setdest 19882 1899 4.0" 
$ns at 854.4318413914814 "$node_(606) setdest 83073 42842 2.0" 
$ns at 884.7659823747927 "$node_(606) setdest 25879 39512 16.0" 
$ns at 691.7820666340291 "$node_(607) setdest 8147 36277 14.0" 
$ns at 792.6638803764409 "$node_(607) setdest 86427 8997 6.0" 
$ns at 878.917952667028 "$node_(607) setdest 6315 10172 1.0" 
$ns at 632.1531413134028 "$node_(608) setdest 36070 26037 19.0" 
$ns at 774.9736198332891 "$node_(608) setdest 11380 40490 13.0" 
$ns at 604.1464793758216 "$node_(609) setdest 8385 18376 12.0" 
$ns at 670.5782201980351 "$node_(609) setdest 91188 6111 13.0" 
$ns at 813.543131241649 "$node_(609) setdest 67043 14808 17.0" 
$ns at 848.4779835558949 "$node_(609) setdest 14490 15142 16.0" 
$ns at 632.3139405333482 "$node_(610) setdest 10963 16700 14.0" 
$ns at 712.2022606937688 "$node_(610) setdest 119571 19025 4.0" 
$ns at 757.3570831977985 "$node_(610) setdest 131444 43092 20.0" 
$ns at 682.6178709758578 "$node_(611) setdest 46829 6788 3.0" 
$ns at 739.6609039620496 "$node_(611) setdest 94334 40900 10.0" 
$ns at 821.7528580103353 "$node_(611) setdest 124695 173 17.0" 
$ns at 643.511610657922 "$node_(612) setdest 83361 21144 1.0" 
$ns at 679.0958282821405 "$node_(612) setdest 132458 6935 8.0" 
$ns at 776.0547761712667 "$node_(612) setdest 97569 37066 1.0" 
$ns at 807.5055357929594 "$node_(612) setdest 127352 18873 20.0" 
$ns at 704.7315453610393 "$node_(613) setdest 53361 17644 8.0" 
$ns at 781.1465439696677 "$node_(613) setdest 51515 27017 8.0" 
$ns at 814.1298275337573 "$node_(613) setdest 83918 8627 9.0" 
$ns at 889.3826478921677 "$node_(613) setdest 74494 14033 6.0" 
$ns at 609.6900569370563 "$node_(614) setdest 86323 39455 12.0" 
$ns at 726.6998387562477 "$node_(614) setdest 107222 39583 7.0" 
$ns at 776.1885208569284 "$node_(614) setdest 133724 33618 18.0" 
$ns at 818.8472430595976 "$node_(614) setdest 55393 19540 6.0" 
$ns at 878.1148789550036 "$node_(614) setdest 53223 9394 12.0" 
$ns at 632.9140703929472 "$node_(615) setdest 68635 4087 10.0" 
$ns at 688.4647692478976 "$node_(615) setdest 121255 33126 5.0" 
$ns at 725.2195514273659 "$node_(615) setdest 63176 21114 15.0" 
$ns at 770.0606542454483 "$node_(615) setdest 89161 3541 6.0" 
$ns at 840.890916963124 "$node_(615) setdest 123237 13022 2.0" 
$ns at 880.423642864433 "$node_(615) setdest 77303 1126 17.0" 
$ns at 731.1478210395923 "$node_(616) setdest 24871 7751 2.0" 
$ns at 775.1060126056608 "$node_(616) setdest 115532 38323 4.0" 
$ns at 832.0397931303826 "$node_(616) setdest 34267 26702 9.0" 
$ns at 601.5254426360759 "$node_(617) setdest 24015 3355 18.0" 
$ns at 632.1587557487059 "$node_(617) setdest 71011 41304 14.0" 
$ns at 785.1771324353216 "$node_(617) setdest 56307 28366 13.0" 
$ns at 863.6959023792797 "$node_(617) setdest 109382 19739 7.0" 
$ns at 611.3622265014257 "$node_(618) setdest 108866 36853 1.0" 
$ns at 644.6765764718849 "$node_(618) setdest 48388 25972 18.0" 
$ns at 696.8579099054639 "$node_(618) setdest 87783 30148 3.0" 
$ns at 740.8953775634986 "$node_(618) setdest 54516 19987 12.0" 
$ns at 817.4926041032533 "$node_(618) setdest 23335 28240 12.0" 
$ns at 631.0856794475784 "$node_(619) setdest 87026 598 5.0" 
$ns at 683.222682421884 "$node_(619) setdest 75748 15432 3.0" 
$ns at 720.8080301784746 "$node_(619) setdest 37643 6267 7.0" 
$ns at 785.8114520894921 "$node_(619) setdest 76456 26544 10.0" 
$ns at 860.694991804042 "$node_(619) setdest 60875 38254 18.0" 
$ns at 609.673347054268 "$node_(620) setdest 8305 40692 5.0" 
$ns at 642.112108189886 "$node_(620) setdest 20557 38562 6.0" 
$ns at 716.3384797615279 "$node_(620) setdest 85156 14483 9.0" 
$ns at 793.8501361880601 "$node_(620) setdest 37360 37488 16.0" 
$ns at 687.1897791802988 "$node_(621) setdest 31365 21504 19.0" 
$ns at 724.5374112944797 "$node_(621) setdest 18306 27297 2.0" 
$ns at 771.2140343083823 "$node_(621) setdest 122319 20557 7.0" 
$ns at 833.7650739038976 "$node_(621) setdest 99035 16922 8.0" 
$ns at 685.0409659167794 "$node_(622) setdest 103603 44230 4.0" 
$ns at 738.3425819625776 "$node_(622) setdest 64218 34607 17.0" 
$ns at 799.4302926530436 "$node_(622) setdest 5336 11950 4.0" 
$ns at 840.6118059903933 "$node_(622) setdest 67512 12103 14.0" 
$ns at 620.0268178703438 "$node_(623) setdest 3305 4818 3.0" 
$ns at 654.1069762093492 "$node_(623) setdest 111994 95 15.0" 
$ns at 817.6414938970779 "$node_(623) setdest 30782 37649 15.0" 
$ns at 617.0969254620638 "$node_(624) setdest 108032 2253 17.0" 
$ns at 707.0254686144874 "$node_(624) setdest 15129 43105 15.0" 
$ns at 804.9750245400411 "$node_(624) setdest 95350 5687 1.0" 
$ns at 835.1097460745265 "$node_(624) setdest 9431 2969 5.0" 
$ns at 891.6914730563658 "$node_(624) setdest 107530 42351 8.0" 
$ns at 603.1463064361584 "$node_(625) setdest 126790 631 17.0" 
$ns at 728.4309517851187 "$node_(625) setdest 31409 40327 10.0" 
$ns at 834.9065594718892 "$node_(625) setdest 20754 40411 11.0" 
$ns at 649.5473223483647 "$node_(626) setdest 116356 28245 13.0" 
$ns at 804.6383770342642 "$node_(626) setdest 36779 28773 14.0" 
$ns at 888.6321997674519 "$node_(626) setdest 45865 3400 17.0" 
$ns at 701.7491637701368 "$node_(627) setdest 42045 26777 12.0" 
$ns at 838.6386413879543 "$node_(627) setdest 95246 29043 17.0" 
$ns at 673.4862377737652 "$node_(628) setdest 38716 38100 17.0" 
$ns at 836.5206368345038 "$node_(628) setdest 84071 38919 15.0" 
$ns at 667.3676130087681 "$node_(629) setdest 92146 19498 5.0" 
$ns at 743.9392274495555 "$node_(629) setdest 55491 38923 5.0" 
$ns at 815.2509826603141 "$node_(629) setdest 79361 37382 9.0" 
$ns at 883.5520341589145 "$node_(629) setdest 8768 13605 11.0" 
$ns at 645.0302160852588 "$node_(630) setdest 85597 5035 19.0" 
$ns at 742.331590422829 "$node_(630) setdest 87701 33967 14.0" 
$ns at 899.3359937332491 "$node_(630) setdest 96435 23461 18.0" 
$ns at 620.8956954611481 "$node_(631) setdest 31264 380 8.0" 
$ns at 655.4425115743004 "$node_(631) setdest 31930 23397 18.0" 
$ns at 822.3434017601646 "$node_(631) setdest 40134 26211 12.0" 
$ns at 604.1505717226466 "$node_(632) setdest 6573 4150 6.0" 
$ns at 640.4033721347166 "$node_(632) setdest 49930 31229 10.0" 
$ns at 719.1665007107879 "$node_(632) setdest 337 23678 7.0" 
$ns at 789.952173739461 "$node_(632) setdest 6348 4701 1.0" 
$ns at 823.4749426987992 "$node_(632) setdest 87546 27572 9.0" 
$ns at 885.0620029652904 "$node_(632) setdest 68051 25316 15.0" 
$ns at 602.3049653776719 "$node_(633) setdest 18606 5981 2.0" 
$ns at 642.7116285725396 "$node_(633) setdest 130578 23391 11.0" 
$ns at 782.6986336176899 "$node_(633) setdest 77097 30959 8.0" 
$ns at 878.1074434865079 "$node_(633) setdest 106164 1252 13.0" 
$ns at 648.0809196947125 "$node_(634) setdest 74896 1680 5.0" 
$ns at 681.531820451817 "$node_(634) setdest 69361 6745 10.0" 
$ns at 730.8709809727171 "$node_(634) setdest 119150 26648 2.0" 
$ns at 777.2506967943713 "$node_(634) setdest 101977 8791 12.0" 
$ns at 889.1258545198909 "$node_(634) setdest 36064 22832 16.0" 
$ns at 658.1272564030508 "$node_(635) setdest 12018 27318 16.0" 
$ns at 775.0597496586429 "$node_(635) setdest 75106 5565 12.0" 
$ns at 845.0398660635012 "$node_(635) setdest 86450 6574 5.0" 
$ns at 880.3258805256725 "$node_(635) setdest 30430 23444 5.0" 
$ns at 619.761784305681 "$node_(636) setdest 61288 42437 1.0" 
$ns at 654.6377164545831 "$node_(636) setdest 14015 40718 20.0" 
$ns at 747.9825580746048 "$node_(636) setdest 99557 3140 17.0" 
$ns at 700.6510090732918 "$node_(637) setdest 80495 37108 1.0" 
$ns at 735.2756958814952 "$node_(637) setdest 2443 26294 7.0" 
$ns at 807.719378635052 "$node_(637) setdest 123697 28213 3.0" 
$ns at 838.2379556874941 "$node_(637) setdest 120332 17828 18.0" 
$ns at 777.0343226158861 "$node_(638) setdest 90617 22954 8.0" 
$ns at 848.5773232134607 "$node_(638) setdest 35063 12386 17.0" 
$ns at 677.2546150977738 "$node_(639) setdest 85103 41888 8.0" 
$ns at 782.5543668746423 "$node_(639) setdest 112164 38476 7.0" 
$ns at 832.3747396485302 "$node_(639) setdest 15250 30973 1.0" 
$ns at 865.0655129546548 "$node_(639) setdest 78958 26587 10.0" 
$ns at 669.8280449179089 "$node_(640) setdest 6385 37306 10.0" 
$ns at 750.6577736624774 "$node_(640) setdest 58556 25078 1.0" 
$ns at 788.7797135759689 "$node_(640) setdest 34029 43836 7.0" 
$ns at 827.9240927440517 "$node_(640) setdest 6191 9804 3.0" 
$ns at 864.3847371665529 "$node_(640) setdest 120822 22284 16.0" 
$ns at 678.7421473406201 "$node_(641) setdest 62700 43589 16.0" 
$ns at 831.2866544159648 "$node_(641) setdest 26698 16050 2.0" 
$ns at 877.9207874761734 "$node_(641) setdest 27333 4673 6.0" 
$ns at 704.0671192557772 "$node_(642) setdest 53717 38764 11.0" 
$ns at 833.979987836921 "$node_(642) setdest 56277 19024 9.0" 
$ns at 890.0705692537641 "$node_(642) setdest 111240 2693 8.0" 
$ns at 623.5984633027283 "$node_(643) setdest 86490 10112 5.0" 
$ns at 691.817663037991 "$node_(643) setdest 133801 34171 10.0" 
$ns at 724.8507431190652 "$node_(643) setdest 12351 22588 1.0" 
$ns at 763.5951443825135 "$node_(643) setdest 54112 34602 16.0" 
$ns at 857.071859459809 "$node_(643) setdest 108750 30826 12.0" 
$ns at 724.1972058392436 "$node_(644) setdest 116136 36504 11.0" 
$ns at 757.6368304454561 "$node_(644) setdest 83454 36400 18.0" 
$ns at 821.490006908258 "$node_(644) setdest 30178 23056 4.0" 
$ns at 852.5583776053762 "$node_(644) setdest 127207 33689 4.0" 
$ns at 802.3170116146226 "$node_(645) setdest 55492 41540 2.0" 
$ns at 845.2422830376803 "$node_(645) setdest 105669 21493 20.0" 
$ns at 878.5491543523273 "$node_(645) setdest 41569 9972 17.0" 
$ns at 703.828542494888 "$node_(646) setdest 112820 18491 11.0" 
$ns at 745.0938510012448 "$node_(646) setdest 83163 10430 11.0" 
$ns at 881.5309858483317 "$node_(646) setdest 110819 22952 12.0" 
$ns at 665.3069495910693 "$node_(647) setdest 82181 407 14.0" 
$ns at 742.3147082239946 "$node_(647) setdest 36265 44182 5.0" 
$ns at 810.0265696043471 "$node_(647) setdest 5839 13984 18.0" 
$ns at 618.33918268125 "$node_(648) setdest 24550 29587 3.0" 
$ns at 656.6318015151135 "$node_(648) setdest 4027 43638 6.0" 
$ns at 687.1266237440929 "$node_(648) setdest 33715 7852 17.0" 
$ns at 842.3799886543679 "$node_(648) setdest 68778 35477 3.0" 
$ns at 709.8573611280256 "$node_(649) setdest 38937 11202 19.0" 
$ns at 840.9166577162015 "$node_(649) setdest 110271 9698 12.0" 
$ns at 654.1676094666686 "$node_(650) setdest 71594 18056 2.0" 
$ns at 692.2327414188092 "$node_(650) setdest 39799 36729 4.0" 
$ns at 729.8270315274458 "$node_(650) setdest 44362 43401 7.0" 
$ns at 790.8042318801881 "$node_(650) setdest 57580 37156 14.0" 
$ns at 862.9013279722212 "$node_(650) setdest 115782 7331 12.0" 
$ns at 634.2555301257612 "$node_(651) setdest 2161 9423 3.0" 
$ns at 687.546674932459 "$node_(651) setdest 49442 9119 17.0" 
$ns at 807.3147289144299 "$node_(651) setdest 947 43923 18.0" 
$ns at 701.8076486500693 "$node_(652) setdest 105480 7860 14.0" 
$ns at 869.9499057558126 "$node_(652) setdest 77702 19622 10.0" 
$ns at 683.4714897125543 "$node_(653) setdest 6985 19322 1.0" 
$ns at 715.2731968097518 "$node_(653) setdest 13510 14119 7.0" 
$ns at 806.0501304014098 "$node_(653) setdest 81825 15682 19.0" 
$ns at 618.5339619709985 "$node_(654) setdest 91581 6391 9.0" 
$ns at 661.7648495938126 "$node_(654) setdest 89841 36404 3.0" 
$ns at 703.0382775259664 "$node_(654) setdest 132212 5078 10.0" 
$ns at 810.0139114677552 "$node_(654) setdest 83966 368 2.0" 
$ns at 846.3908861711286 "$node_(654) setdest 108474 24995 14.0" 
$ns at 767.6804781091378 "$node_(655) setdest 35794 29100 19.0" 
$ns at 836.2929211741898 "$node_(655) setdest 113401 35038 15.0" 
$ns at 682.4054742927194 "$node_(656) setdest 107331 27368 19.0" 
$ns at 789.0436568182715 "$node_(656) setdest 133559 3299 16.0" 
$ns at 857.5863538766439 "$node_(656) setdest 112081 29370 15.0" 
$ns at 655.4490674002234 "$node_(657) setdest 85568 41567 15.0" 
$ns at 704.1118404512913 "$node_(657) setdest 60486 36468 13.0" 
$ns at 799.6144849261765 "$node_(657) setdest 120461 42812 11.0" 
$ns at 854.1638365844624 "$node_(657) setdest 92183 35012 15.0" 
$ns at 615.2575237130554 "$node_(658) setdest 96969 3193 10.0" 
$ns at 651.075025725077 "$node_(658) setdest 91204 5383 19.0" 
$ns at 868.8474601823391 "$node_(658) setdest 55489 25952 5.0" 
$ns at 614.4289634623804 "$node_(659) setdest 90598 4035 18.0" 
$ns at 726.6406927644805 "$node_(659) setdest 13235 38506 1.0" 
$ns at 760.317794520769 "$node_(659) setdest 81703 18817 16.0" 
$ns at 628.725488419909 "$node_(660) setdest 54670 29767 2.0" 
$ns at 671.4676143463478 "$node_(660) setdest 93925 34086 2.0" 
$ns at 718.3998566541907 "$node_(660) setdest 72433 4156 5.0" 
$ns at 751.5624030517307 "$node_(660) setdest 33751 15343 4.0" 
$ns at 800.7767765313358 "$node_(660) setdest 109000 29919 14.0" 
$ns at 643.1322125890183 "$node_(661) setdest 52031 16327 2.0" 
$ns at 692.4760335607734 "$node_(661) setdest 61626 23815 1.0" 
$ns at 724.8905133635184 "$node_(661) setdest 11456 26612 10.0" 
$ns at 829.013473774409 "$node_(661) setdest 38221 41925 13.0" 
$ns at 867.4805313706861 "$node_(661) setdest 68223 18926 14.0" 
$ns at 616.539123434814 "$node_(662) setdest 85023 36955 5.0" 
$ns at 682.8696059079742 "$node_(662) setdest 101467 38341 8.0" 
$ns at 721.4668350159192 "$node_(662) setdest 108438 22563 1.0" 
$ns at 758.1835553571149 "$node_(662) setdest 90102 41970 1.0" 
$ns at 797.3259234960667 "$node_(662) setdest 121876 9176 6.0" 
$ns at 847.2545659877844 "$node_(662) setdest 52997 14359 11.0" 
$ns at 603.8514880666222 "$node_(663) setdest 57622 38059 7.0" 
$ns at 658.6365111779259 "$node_(663) setdest 127831 14030 13.0" 
$ns at 746.8209266015652 "$node_(663) setdest 57602 5151 4.0" 
$ns at 791.7353817139417 "$node_(663) setdest 29102 11648 3.0" 
$ns at 844.686063832431 "$node_(663) setdest 119657 8170 16.0" 
$ns at 676.7379254751944 "$node_(664) setdest 15414 27280 10.0" 
$ns at 790.3489090566616 "$node_(664) setdest 127257 5074 10.0" 
$ns at 844.958007131816 "$node_(664) setdest 36502 43087 9.0" 
$ns at 882.519302126724 "$node_(664) setdest 23068 14667 11.0" 
$ns at 704.0669746378906 "$node_(665) setdest 111974 42205 2.0" 
$ns at 748.9674422727719 "$node_(665) setdest 89866 15177 10.0" 
$ns at 816.3708320133452 "$node_(665) setdest 31379 7465 18.0" 
$ns at 668.632627300485 "$node_(666) setdest 10099 33914 19.0" 
$ns at 865.3586072330706 "$node_(666) setdest 7346 7586 17.0" 
$ns at 743.7024324795783 "$node_(667) setdest 97115 13954 13.0" 
$ns at 856.0425503820989 "$node_(667) setdest 127136 15372 11.0" 
$ns at 640.1991091653323 "$node_(668) setdest 50259 23434 12.0" 
$ns at 721.9325048240635 "$node_(668) setdest 67874 8358 12.0" 
$ns at 806.25131728117 "$node_(668) setdest 121766 15971 8.0" 
$ns at 896.8582283139934 "$node_(668) setdest 38721 3947 16.0" 
$ns at 680.1016871449508 "$node_(669) setdest 66402 41767 18.0" 
$ns at 786.370637402508 "$node_(669) setdest 108816 2014 3.0" 
$ns at 834.2832425084564 "$node_(669) setdest 40574 29380 11.0" 
$ns at 663.618969622298 "$node_(670) setdest 14894 18085 5.0" 
$ns at 735.9248056383665 "$node_(670) setdest 112275 35317 5.0" 
$ns at 775.8046523218183 "$node_(670) setdest 111795 38234 5.0" 
$ns at 824.5466823326765 "$node_(670) setdest 71456 23323 18.0" 
$ns at 617.9699219068013 "$node_(671) setdest 60285 40022 18.0" 
$ns at 796.3367275012299 "$node_(671) setdest 64420 10192 7.0" 
$ns at 856.1002272227728 "$node_(671) setdest 116349 33014 5.0" 
$ns at 898.8259771273092 "$node_(671) setdest 100790 33782 12.0" 
$ns at 639.4388397088846 "$node_(672) setdest 78925 8295 11.0" 
$ns at 696.1996555695573 "$node_(672) setdest 47682 2932 7.0" 
$ns at 762.0535308983038 "$node_(672) setdest 41429 26695 6.0" 
$ns at 798.5696183089384 "$node_(672) setdest 81267 41859 5.0" 
$ns at 857.3070650322823 "$node_(672) setdest 117452 32500 5.0" 
$ns at 887.5885828820877 "$node_(672) setdest 42798 37138 8.0" 
$ns at 605.8829038291059 "$node_(673) setdest 61005 13153 18.0" 
$ns at 808.4523600296855 "$node_(673) setdest 59150 38446 6.0" 
$ns at 841.0439671375764 "$node_(673) setdest 111192 39582 4.0" 
$ns at 653.2139063888987 "$node_(674) setdest 54011 23995 3.0" 
$ns at 706.0354028755802 "$node_(674) setdest 114681 22569 13.0" 
$ns at 796.1601885365491 "$node_(674) setdest 113019 39082 11.0" 
$ns at 875.3222276617289 "$node_(674) setdest 20932 36912 3.0" 
$ns at 717.5262115906635 "$node_(675) setdest 64732 39633 15.0" 
$ns at 847.5979790034868 "$node_(675) setdest 359 14870 5.0" 
$ns at 615.8116482741781 "$node_(676) setdest 31134 10875 10.0" 
$ns at 721.957548872876 "$node_(676) setdest 101118 5633 14.0" 
$ns at 791.3238959555509 "$node_(676) setdest 36386 20227 10.0" 
$ns at 856.0926754932765 "$node_(676) setdest 82951 37473 3.0" 
$ns at 600.8993606415537 "$node_(677) setdest 83901 22103 11.0" 
$ns at 739.7227562197751 "$node_(677) setdest 96779 19712 20.0" 
$ns at 625.7945596185166 "$node_(678) setdest 32737 16739 18.0" 
$ns at 716.7581794948875 "$node_(678) setdest 31390 5146 19.0" 
$ns at 811.5096670907552 "$node_(678) setdest 26925 40586 5.0" 
$ns at 876.9390897861741 "$node_(678) setdest 108231 1781 11.0" 
$ns at 627.9153951527436 "$node_(679) setdest 123470 2184 9.0" 
$ns at 745.8632276089832 "$node_(679) setdest 64115 22422 17.0" 
$ns at 854.9504137093458 "$node_(679) setdest 50790 23867 6.0" 
$ns at 894.9247791377242 "$node_(679) setdest 67063 3165 3.0" 
$ns at 644.5753162365186 "$node_(680) setdest 33108 35926 1.0" 
$ns at 682.3603323950983 "$node_(680) setdest 26839 18068 8.0" 
$ns at 777.8007276712125 "$node_(680) setdest 67398 39499 7.0" 
$ns at 876.7706582894951 "$node_(680) setdest 15377 8088 8.0" 
$ns at 634.8761958877467 "$node_(681) setdest 89113 22909 10.0" 
$ns at 734.01239902774 "$node_(681) setdest 42159 19069 1.0" 
$ns at 768.9767163616483 "$node_(681) setdest 102133 22818 15.0" 
$ns at 849.7641642007643 "$node_(681) setdest 31962 29696 11.0" 
$ns at 615.8094109930183 "$node_(682) setdest 96890 17626 18.0" 
$ns at 775.554818032196 "$node_(682) setdest 67102 20829 8.0" 
$ns at 879.4976090616055 "$node_(682) setdest 59620 41558 15.0" 
$ns at 630.9764499183156 "$node_(683) setdest 61143 16881 11.0" 
$ns at 723.3830097508255 "$node_(683) setdest 120444 32012 9.0" 
$ns at 835.7805802947566 "$node_(683) setdest 21902 35331 7.0" 
$ns at 610.5036662583034 "$node_(684) setdest 133757 10922 7.0" 
$ns at 703.4265688591064 "$node_(684) setdest 26511 37336 1.0" 
$ns at 735.310356934361 "$node_(684) setdest 32876 43278 13.0" 
$ns at 874.8180841621106 "$node_(684) setdest 2776 22651 16.0" 
$ns at 628.1809360321486 "$node_(685) setdest 18303 16385 7.0" 
$ns at 681.9310943005703 "$node_(685) setdest 25348 9979 8.0" 
$ns at 766.2572997938413 "$node_(685) setdest 89706 16907 19.0" 
$ns at 610.6821499194713 "$node_(686) setdest 53327 19383 11.0" 
$ns at 647.8708545934503 "$node_(686) setdest 113867 255 18.0" 
$ns at 736.6293775985564 "$node_(686) setdest 108396 11600 14.0" 
$ns at 879.3553844485601 "$node_(686) setdest 16539 36850 17.0" 
$ns at 636.805149727693 "$node_(687) setdest 96554 20997 19.0" 
$ns at 709.8082316998245 "$node_(687) setdest 20154 21050 16.0" 
$ns at 827.2983901195017 "$node_(687) setdest 126893 43922 16.0" 
$ns at 884.173220522497 "$node_(687) setdest 8816 42048 19.0" 
$ns at 649.5007501628809 "$node_(688) setdest 90540 21098 4.0" 
$ns at 712.6854375169007 "$node_(688) setdest 60683 6026 2.0" 
$ns at 753.4376572976844 "$node_(688) setdest 90833 9159 8.0" 
$ns at 858.1763150206192 "$node_(688) setdest 56917 1675 1.0" 
$ns at 892.0035055072013 "$node_(688) setdest 97964 5869 11.0" 
$ns at 671.203396552925 "$node_(689) setdest 126448 42002 2.0" 
$ns at 718.2665638348038 "$node_(689) setdest 19189 1958 13.0" 
$ns at 790.369386871212 "$node_(689) setdest 25262 6040 19.0" 
$ns at 743.4522664853325 "$node_(690) setdest 101536 7472 1.0" 
$ns at 783.1577761038358 "$node_(690) setdest 45366 9826 1.0" 
$ns at 819.0787966480225 "$node_(690) setdest 51131 4466 2.0" 
$ns at 853.7861274043524 "$node_(690) setdest 82704 3346 5.0" 
$ns at 899.7927375749429 "$node_(690) setdest 16296 24783 10.0" 
$ns at 623.3159892608353 "$node_(691) setdest 121300 28132 14.0" 
$ns at 740.137528587231 "$node_(691) setdest 47590 30243 19.0" 
$ns at 618.5850533968977 "$node_(692) setdest 118288 11552 15.0" 
$ns at 741.0765460196571 "$node_(692) setdest 62531 3168 3.0" 
$ns at 790.9074681034348 "$node_(692) setdest 32544 42832 10.0" 
$ns at 860.4549721950069 "$node_(692) setdest 94669 41850 2.0" 
$ns at 893.3819110592581 "$node_(692) setdest 106699 11214 18.0" 
$ns at 646.5145697078622 "$node_(693) setdest 22075 25318 18.0" 
$ns at 701.0700764467985 "$node_(693) setdest 46856 26014 18.0" 
$ns at 879.4465456423532 "$node_(693) setdest 106566 29404 11.0" 
$ns at 614.7069654335165 "$node_(694) setdest 69978 740 19.0" 
$ns at 829.8227755096589 "$node_(694) setdest 126526 39803 15.0" 
$ns at 613.4821937606034 "$node_(695) setdest 82606 42390 16.0" 
$ns at 646.158002655999 "$node_(695) setdest 16795 21449 4.0" 
$ns at 677.3358956836695 "$node_(695) setdest 107723 4807 5.0" 
$ns at 709.4944843867031 "$node_(695) setdest 73121 2401 1.0" 
$ns at 749.0492464712639 "$node_(695) setdest 122144 38788 11.0" 
$ns at 793.8584486618782 "$node_(695) setdest 127815 25119 15.0" 
$ns at 846.0516753912374 "$node_(695) setdest 34119 19005 18.0" 
$ns at 622.7824804157882 "$node_(696) setdest 60282 40128 14.0" 
$ns at 773.6792255880288 "$node_(696) setdest 13170 62 6.0" 
$ns at 810.8989380682676 "$node_(696) setdest 101341 25654 9.0" 
$ns at 842.5231909075662 "$node_(696) setdest 11422 27218 8.0" 
$ns at 648.3280910971157 "$node_(697) setdest 35547 34550 17.0" 
$ns at 828.3885407428083 "$node_(697) setdest 89963 11463 7.0" 
$ns at 655.6097668825013 "$node_(698) setdest 120127 15698 19.0" 
$ns at 869.9724742033975 "$node_(698) setdest 125665 7758 9.0" 
$ns at 631.7575896561217 "$node_(699) setdest 84527 29611 14.0" 
$ns at 772.4010598036391 "$node_(699) setdest 16379 3118 20.0" 
$ns at 899.0506298627135 "$node_(699) setdest 47077 10767 9.0" 
$ns at 736.7051604466241 "$node_(700) setdest 18145 37798 10.0" 
$ns at 788.9833892902225 "$node_(700) setdest 128086 18424 7.0" 
$ns at 875.4175636342545 "$node_(700) setdest 921 23388 13.0" 
$ns at 764.8131026106805 "$node_(701) setdest 21525 2838 14.0" 
$ns at 813.6590606802006 "$node_(701) setdest 118994 22468 6.0" 
$ns at 869.5386060957374 "$node_(701) setdest 27918 6921 2.0" 
$ns at 735.3979918121254 "$node_(702) setdest 40086 17438 17.0" 
$ns at 774.1489682226305 "$node_(702) setdest 101794 6757 15.0" 
$ns at 824.1275096912759 "$node_(702) setdest 113653 6518 19.0" 
$ns at 789.1387282859122 "$node_(703) setdest 44646 2149 18.0" 
$ns at 720.7746007203159 "$node_(704) setdest 6684 27092 9.0" 
$ns at 819.6169248037043 "$node_(704) setdest 50727 8628 16.0" 
$ns at 775.4449849388639 "$node_(705) setdest 10562 40563 3.0" 
$ns at 832.2184929714066 "$node_(705) setdest 49639 2527 14.0" 
$ns at 831.4228736526508 "$node_(706) setdest 18893 31370 13.0" 
$ns at 724.8364599851907 "$node_(707) setdest 83650 27254 16.0" 
$ns at 865.5027943227626 "$node_(707) setdest 5707 18515 4.0" 
$ns at 733.5799379244158 "$node_(708) setdest 104508 14166 5.0" 
$ns at 785.4017593288625 "$node_(708) setdest 91071 31415 7.0" 
$ns at 824.6001791863904 "$node_(708) setdest 97468 7171 1.0" 
$ns at 858.7922882382726 "$node_(708) setdest 44143 3869 10.0" 
$ns at 766.2830891975708 "$node_(709) setdest 31133 43102 13.0" 
$ns at 700.9812871384777 "$node_(710) setdest 99583 38201 3.0" 
$ns at 759.7151063180308 "$node_(710) setdest 99432 30055 4.0" 
$ns at 824.0402651093788 "$node_(710) setdest 19266 29288 3.0" 
$ns at 871.9608353244832 "$node_(710) setdest 1539 18528 1.0" 
$ns at 810.6347637449946 "$node_(711) setdest 109976 10884 13.0" 
$ns at 854.8397088131652 "$node_(711) setdest 11230 221 1.0" 
$ns at 890.9003582866504 "$node_(711) setdest 4892 33245 4.0" 
$ns at 741.2225555570067 "$node_(712) setdest 584 1962 19.0" 
$ns at 874.1730667869776 "$node_(712) setdest 71983 33295 13.0" 
$ns at 846.4167725948581 "$node_(713) setdest 16171 16387 12.0" 
$ns at 732.5807052786056 "$node_(714) setdest 43155 12284 4.0" 
$ns at 792.2417736209726 "$node_(714) setdest 132696 41138 3.0" 
$ns at 850.3641618541365 "$node_(714) setdest 130584 26442 14.0" 
$ns at 730.2247999748361 "$node_(715) setdest 90660 9532 9.0" 
$ns at 776.0975030823969 "$node_(715) setdest 63979 2779 4.0" 
$ns at 818.5794683523109 "$node_(715) setdest 108642 15441 10.0" 
$ns at 736.1839584787524 "$node_(716) setdest 39225 15794 15.0" 
$ns at 826.9091641483271 "$node_(716) setdest 43789 28186 20.0" 
$ns at 728.3016886461833 "$node_(717) setdest 72981 38699 14.0" 
$ns at 883.2442849790709 "$node_(717) setdest 116570 22602 12.0" 
$ns at 830.2329979392239 "$node_(718) setdest 112827 43569 12.0" 
$ns at 752.3869164475495 "$node_(719) setdest 48554 41793 4.0" 
$ns at 799.3201577052903 "$node_(719) setdest 63245 2836 12.0" 
$ns at 712.1162588011496 "$node_(720) setdest 42907 9483 6.0" 
$ns at 782.696629023722 "$node_(720) setdest 97155 15318 2.0" 
$ns at 817.3763412860256 "$node_(720) setdest 89894 17615 9.0" 
$ns at 859.4129867625298 "$node_(720) setdest 12198 27356 6.0" 
$ns at 703.7628004420151 "$node_(721) setdest 26134 25749 13.0" 
$ns at 781.4884183560347 "$node_(721) setdest 10047 17087 10.0" 
$ns at 865.2509944525017 "$node_(721) setdest 107843 40113 18.0" 
$ns at 721.2041298412988 "$node_(722) setdest 18534 30082 20.0" 
$ns at 728.3400358824762 "$node_(723) setdest 11990 12088 9.0" 
$ns at 792.1896793436548 "$node_(723) setdest 94508 42727 7.0" 
$ns at 833.3783649218585 "$node_(723) setdest 58491 11949 11.0" 
$ns at 747.9065909551914 "$node_(724) setdest 33426 3044 2.0" 
$ns at 784.3811676173847 "$node_(724) setdest 53595 26501 9.0" 
$ns at 832.9090607440494 "$node_(724) setdest 111226 36579 6.0" 
$ns at 864.1987296429716 "$node_(724) setdest 31715 42000 6.0" 
$ns at 720.1596504245972 "$node_(725) setdest 96717 8120 7.0" 
$ns at 816.1742910596153 "$node_(725) setdest 1071 25685 2.0" 
$ns at 848.5946484068429 "$node_(725) setdest 107498 3501 7.0" 
$ns at 750.4362207330612 "$node_(726) setdest 30568 25316 14.0" 
$ns at 870.8668389704869 "$node_(726) setdest 73253 36483 16.0" 
$ns at 762.6733621992541 "$node_(727) setdest 92129 35780 6.0" 
$ns at 813.1085414556951 "$node_(727) setdest 66872 38762 7.0" 
$ns at 898.8275544404961 "$node_(727) setdest 125087 1087 12.0" 
$ns at 781.5614717538173 "$node_(728) setdest 133434 2747 11.0" 
$ns at 821.6514973155865 "$node_(728) setdest 83577 4446 11.0" 
$ns at 862.6525991570444 "$node_(728) setdest 16107 41721 17.0" 
$ns at 796.3351919154132 "$node_(729) setdest 115203 7113 11.0" 
$ns at 835.610372667557 "$node_(729) setdest 73254 39416 12.0" 
$ns at 757.2539502003435 "$node_(730) setdest 131889 34468 6.0" 
$ns at 802.116404763458 "$node_(730) setdest 80264 36472 6.0" 
$ns at 855.2194229935535 "$node_(730) setdest 80952 35711 6.0" 
$ns at 704.8803578901002 "$node_(731) setdest 70145 27696 10.0" 
$ns at 745.1530923053227 "$node_(731) setdest 46864 17017 20.0" 
$ns at 815.4173696289911 "$node_(731) setdest 54684 29541 8.0" 
$ns at 847.2020565348737 "$node_(731) setdest 127203 21543 18.0" 
$ns at 769.4444719587582 "$node_(732) setdest 13692 30775 4.0" 
$ns at 839.1269654252828 "$node_(732) setdest 119437 20108 6.0" 
$ns at 891.2620761688739 "$node_(732) setdest 43445 33069 14.0" 
$ns at 720.3681053411404 "$node_(733) setdest 107651 19268 19.0" 
$ns at 881.7792436094614 "$node_(733) setdest 33049 9134 16.0" 
$ns at 792.7639743724399 "$node_(734) setdest 6143 29739 10.0" 
$ns at 719.9522325588638 "$node_(735) setdest 64539 27424 5.0" 
$ns at 778.1391809714054 "$node_(735) setdest 91034 10247 10.0" 
$ns at 868.821658536009 "$node_(735) setdest 16696 16600 6.0" 
$ns at 747.8798075563777 "$node_(736) setdest 17752 10436 8.0" 
$ns at 790.4697913733959 "$node_(736) setdest 122607 23742 6.0" 
$ns at 822.3873070824825 "$node_(736) setdest 68882 34385 20.0" 
$ns at 730.2270781139 "$node_(737) setdest 68224 44690 1.0" 
$ns at 762.1204015231168 "$node_(737) setdest 8420 41243 13.0" 
$ns at 864.498586864278 "$node_(737) setdest 92036 7108 13.0" 
$ns at 772.8902347323666 "$node_(738) setdest 48549 8143 15.0" 
$ns at 708.8627701824887 "$node_(739) setdest 82627 41826 17.0" 
$ns at 805.8766279377455 "$node_(739) setdest 60232 17531 17.0" 
$ns at 715.2620243697247 "$node_(740) setdest 53912 28254 10.0" 
$ns at 783.3972916830969 "$node_(740) setdest 127901 14300 19.0" 
$ns at 886.3696065057409 "$node_(740) setdest 18631 26614 4.0" 
$ns at 743.933332338999 "$node_(741) setdest 104800 34822 19.0" 
$ns at 843.8988611115362 "$node_(741) setdest 4525 36895 10.0" 
$ns at 751.5181297509205 "$node_(742) setdest 69145 8597 11.0" 
$ns at 875.7595123593086 "$node_(742) setdest 75468 29453 16.0" 
$ns at 704.9803627322244 "$node_(743) setdest 131239 10741 1.0" 
$ns at 743.0824054579374 "$node_(743) setdest 47765 33460 1.0" 
$ns at 779.0865076116303 "$node_(743) setdest 25968 521 10.0" 
$ns at 879.7300546117423 "$node_(743) setdest 97758 25675 14.0" 
$ns at 775.0355599538614 "$node_(744) setdest 59971 29666 18.0" 
$ns at 834.1101947800704 "$node_(744) setdest 115047 11673 9.0" 
$ns at 770.4336151680408 "$node_(745) setdest 15996 34199 17.0" 
$ns at 820.523320452032 "$node_(745) setdest 31137 36829 10.0" 
$ns at 804.7808865131412 "$node_(746) setdest 125357 3179 3.0" 
$ns at 847.8222460388356 "$node_(746) setdest 38143 1728 13.0" 
$ns at 858.1615409567611 "$node_(747) setdest 126344 29236 15.0" 
$ns at 834.4305795325793 "$node_(748) setdest 80273 10542 5.0" 
$ns at 883.2531960644654 "$node_(748) setdest 97905 8969 15.0" 
$ns at 711.665722842373 "$node_(749) setdest 17619 18191 15.0" 
$ns at 793.1298754706816 "$node_(749) setdest 67938 20172 10.0" 
$ns at 863.3522711037826 "$node_(749) setdest 33920 38317 1.0" 
$ns at 899.7147693686045 "$node_(749) setdest 120540 9244 16.0" 
$ns at 814.3723797995237 "$node_(750) setdest 56633 23671 16.0" 
$ns at 721.9300379151692 "$node_(751) setdest 48738 34167 11.0" 
$ns at 813.945722285288 "$node_(751) setdest 18355 588 12.0" 
$ns at 865.3079362282455 "$node_(751) setdest 26167 38517 7.0" 
$ns at 711.0331579824565 "$node_(752) setdest 25519 10193 1.0" 
$ns at 743.3449394843624 "$node_(752) setdest 27399 35269 11.0" 
$ns at 817.3596384681221 "$node_(752) setdest 16719 14329 6.0" 
$ns at 884.3589695838535 "$node_(752) setdest 75146 480 1.0" 
$ns at 804.1623529394604 "$node_(753) setdest 30772 41225 9.0" 
$ns at 860.1489529497104 "$node_(753) setdest 116739 29447 17.0" 
$ns at 725.8021851007594 "$node_(754) setdest 93079 14864 17.0" 
$ns at 787.5785060173696 "$node_(755) setdest 34361 26801 13.0" 
$ns at 754.1586820459601 "$node_(756) setdest 9688 2142 5.0" 
$ns at 822.7975070908105 "$node_(756) setdest 65012 7319 17.0" 
$ns at 751.670735978847 "$node_(757) setdest 86840 33963 8.0" 
$ns at 805.5210332892469 "$node_(757) setdest 10400 43393 18.0" 
$ns at 716.0913817630362 "$node_(758) setdest 28880 32882 2.0" 
$ns at 754.1003789482894 "$node_(758) setdest 27785 42278 2.0" 
$ns at 788.3366488585274 "$node_(758) setdest 74824 11473 17.0" 
$ns at 885.8372639374473 "$node_(758) setdest 129611 33775 10.0" 
$ns at 743.0546487592743 "$node_(759) setdest 35734 6889 1.0" 
$ns at 775.6427912150147 "$node_(759) setdest 51832 29032 16.0" 
$ns at 705.7729031374181 "$node_(760) setdest 84582 13803 2.0" 
$ns at 739.832502949337 "$node_(760) setdest 106098 19894 5.0" 
$ns at 775.7309390150762 "$node_(760) setdest 82779 35933 20.0" 
$ns at 840.3744712976072 "$node_(760) setdest 24372 29521 8.0" 
$ns at 739.3800418468377 "$node_(761) setdest 32778 42864 4.0" 
$ns at 800.165159881532 "$node_(761) setdest 73239 35263 7.0" 
$ns at 852.9647312870967 "$node_(761) setdest 27673 22702 6.0" 
$ns at 715.0451444728208 "$node_(762) setdest 34101 1932 15.0" 
$ns at 831.403002346336 "$node_(762) setdest 128177 16607 4.0" 
$ns at 877.8334755184122 "$node_(762) setdest 12188 14611 3.0" 
$ns at 755.7955303723398 "$node_(763) setdest 117143 2776 14.0" 
$ns at 705.9003726776201 "$node_(764) setdest 126811 14265 6.0" 
$ns at 764.0064131284013 "$node_(764) setdest 2969 6161 2.0" 
$ns at 798.9172085429266 "$node_(764) setdest 10838 19247 12.0" 
$ns at 898.39399099615 "$node_(764) setdest 34507 12320 4.0" 
$ns at 709.4150922390465 "$node_(765) setdest 3765 24567 5.0" 
$ns at 777.436950203306 "$node_(765) setdest 67414 36541 6.0" 
$ns at 854.155478448575 "$node_(765) setdest 39006 40579 4.0" 
$ns at 721.6590059423883 "$node_(766) setdest 2146 28107 10.0" 
$ns at 808.0762327822216 "$node_(766) setdest 117519 18320 6.0" 
$ns at 875.5019957153881 "$node_(766) setdest 97923 34097 20.0" 
$ns at 734.5339846305205 "$node_(767) setdest 5015 12500 13.0" 
$ns at 875.2490361359103 "$node_(767) setdest 52723 5787 3.0" 
$ns at 771.8647276340351 "$node_(768) setdest 26954 31319 16.0" 
$ns at 869.6680714765496 "$node_(768) setdest 8440 22782 4.0" 
$ns at 834.743572849659 "$node_(769) setdest 41859 16877 8.0" 
$ns at 884.0379115540853 "$node_(769) setdest 42028 4055 14.0" 
$ns at 730.4399816120922 "$node_(770) setdest 36807 28413 18.0" 
$ns at 767.2080865955415 "$node_(770) setdest 38853 1235 14.0" 
$ns at 799.9289491894872 "$node_(770) setdest 56071 35272 4.0" 
$ns at 850.436293554023 "$node_(770) setdest 112227 33153 9.0" 
$ns at 714.804834730861 "$node_(771) setdest 98753 22088 11.0" 
$ns at 780.1442741854923 "$node_(771) setdest 28067 5322 1.0" 
$ns at 811.440813828769 "$node_(771) setdest 92966 15231 16.0" 
$ns at 719.1792273154615 "$node_(772) setdest 129904 38191 4.0" 
$ns at 758.4585797346133 "$node_(772) setdest 27174 42554 6.0" 
$ns at 809.6734791019634 "$node_(772) setdest 96559 33117 11.0" 
$ns at 797.9809548029039 "$node_(773) setdest 18908 9246 2.0" 
$ns at 836.6873642012324 "$node_(773) setdest 108562 29863 14.0" 
$ns at 714.0945521700108 "$node_(774) setdest 86318 42690 7.0" 
$ns at 778.6660257567664 "$node_(774) setdest 55543 7446 19.0" 
$ns at 860.3873895973037 "$node_(774) setdest 122280 33676 1.0" 
$ns at 892.7301474582792 "$node_(774) setdest 21349 28521 1.0" 
$ns at 715.645419294959 "$node_(775) setdest 92813 5097 7.0" 
$ns at 767.2206262385959 "$node_(775) setdest 125331 14731 11.0" 
$ns at 890.1115835939097 "$node_(775) setdest 78974 16106 4.0" 
$ns at 742.2233431093406 "$node_(776) setdest 57576 9295 16.0" 
$ns at 844.0954788537106 "$node_(777) setdest 95598 8941 3.0" 
$ns at 739.3653623785053 "$node_(778) setdest 63383 11712 2.0" 
$ns at 777.5332656902048 "$node_(778) setdest 76828 16194 17.0" 
$ns at 810.7574007820896 "$node_(778) setdest 111292 8636 19.0" 
$ns at 871.944024649561 "$node_(778) setdest 65528 37567 19.0" 
$ns at 798.8573487251011 "$node_(779) setdest 87804 40731 14.0" 
$ns at 727.9799150005274 "$node_(780) setdest 103391 6998 19.0" 
$ns at 806.912348012622 "$node_(780) setdest 11117 43189 11.0" 
$ns at 804.1928819832896 "$node_(781) setdest 114203 9191 12.0" 
$ns at 862.2241452491586 "$node_(781) setdest 65665 18196 10.0" 
$ns at 765.1799071704081 "$node_(782) setdest 131076 5386 8.0" 
$ns at 850.6428748506492 "$node_(782) setdest 20044 15114 18.0" 
$ns at 775.4229154293463 "$node_(783) setdest 37337 2604 18.0" 
$ns at 746.5638430266155 "$node_(784) setdest 3923 6411 3.0" 
$ns at 781.2225608082373 "$node_(784) setdest 88272 22504 3.0" 
$ns at 836.2620383287956 "$node_(784) setdest 126047 37214 13.0" 
$ns at 757.6085948324336 "$node_(785) setdest 67010 28931 12.0" 
$ns at 858.8829376070903 "$node_(785) setdest 95520 5184 1.0" 
$ns at 895.0930638611514 "$node_(785) setdest 10406 38395 1.0" 
$ns at 741.7160185874582 "$node_(786) setdest 66156 34905 11.0" 
$ns at 853.1820280808406 "$node_(786) setdest 30841 44159 18.0" 
$ns at 762.350388470822 "$node_(787) setdest 41219 43468 4.0" 
$ns at 812.2899484343417 "$node_(787) setdest 34216 13 15.0" 
$ns at 710.3363667200703 "$node_(788) setdest 1322 27649 6.0" 
$ns at 772.5193617792762 "$node_(788) setdest 127316 44496 10.0" 
$ns at 833.3003423970217 "$node_(788) setdest 85225 20770 9.0" 
$ns at 887.7967962750948 "$node_(788) setdest 64657 40065 19.0" 
$ns at 706.4390113919984 "$node_(789) setdest 107164 7637 9.0" 
$ns at 788.0265108685572 "$node_(789) setdest 68789 17494 5.0" 
$ns at 861.6007374686599 "$node_(789) setdest 100014 8392 12.0" 
$ns at 760.1738851558805 "$node_(790) setdest 104035 31916 18.0" 
$ns at 702.5984466174293 "$node_(791) setdest 114880 33971 13.0" 
$ns at 740.547912638643 "$node_(791) setdest 29650 36294 4.0" 
$ns at 804.903952102575 "$node_(791) setdest 46076 7353 2.0" 
$ns at 847.5185185881317 "$node_(791) setdest 81576 32253 10.0" 
$ns at 744.0487298004489 "$node_(792) setdest 65859 43248 18.0" 
$ns at 789.4828796208244 "$node_(792) setdest 20255 9302 2.0" 
$ns at 838.9303181481912 "$node_(792) setdest 35524 23203 1.0" 
$ns at 870.2862225613828 "$node_(792) setdest 16488 10979 2.0" 
$ns at 713.9225107716697 "$node_(793) setdest 120073 18376 9.0" 
$ns at 797.1371941716732 "$node_(793) setdest 110149 4798 17.0" 
$ns at 840.3602056089686 "$node_(793) setdest 30553 9000 2.0" 
$ns at 871.349044937912 "$node_(793) setdest 110927 4993 9.0" 
$ns at 830.7712063375739 "$node_(794) setdest 129509 6267 18.0" 
$ns at 710.5243401669163 "$node_(795) setdest 109011 20625 18.0" 
$ns at 781.7874587825991 "$node_(795) setdest 69846 16765 19.0" 
$ns at 704.376572223143 "$node_(796) setdest 15357 38167 8.0" 
$ns at 809.8006083036448 "$node_(796) setdest 31654 25166 10.0" 
$ns at 888.1204852303528 "$node_(796) setdest 58911 25596 13.0" 
$ns at 709.6456538767145 "$node_(797) setdest 32020 18961 12.0" 
$ns at 847.5927842931912 "$node_(797) setdest 105237 13913 15.0" 
$ns at 727.0290334158029 "$node_(798) setdest 45035 26264 3.0" 
$ns at 771.2090743871714 "$node_(798) setdest 88389 9862 7.0" 
$ns at 830.3016318261461 "$node_(798) setdest 9010 32579 19.0" 
$ns at 719.520108379651 "$node_(799) setdest 111791 11103 17.0" 
$ns at 763.3510199780104 "$node_(799) setdest 1633 22851 1.0" 
$ns at 799.292042751936 "$node_(799) setdest 86280 39455 12.0" 
$ns at 887.5483351279365 "$node_(799) setdest 67655 33452 17.0" 


#Set a TCP connection between node_(7) and node_(86)
set tcp_(0) [new Agent/TCP/Newreno]
$tcp_(0) set class_ 2
set sink_(0) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(0)
$ns attach-agent $node_(86) $sink_(0)
$ns connect $tcp_(0) $sink_(0)
set ftp_(0) [new Application/FTP]
$ftp_(0) attach-agent $tcp_(0)
$ns at 0.2 "$ftp_(0) start"
$ns at 180.0 "$ftp_(0) stop"

#Set a TCP connection between node_(9) and node_(7)
set tcp_(1) [new Agent/TCP/Newreno]
$tcp_(1) set class_ 2
set sink_(1) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(1)
$ns attach-agent $node_(7) $sink_(1)
$ns connect $tcp_(1) $sink_(1)
set ftp_(1) [new Application/FTP]
$ftp_(1) attach-agent $tcp_(1)
$ns at 180.2 "$ftp_(1) start"
$ns at 360.0 "$ftp_(1) stop"

#Set a TCP connection between node_(74) and node_(82)
set tcp_(2) [new Agent/TCP/Newreno]
$tcp_(2) set class_ 2
set sink_(2) [new Agent/TCPSink]
$ns attach-agent $node_(74) $tcp_(2)
$ns attach-agent $node_(82) $sink_(2)
$ns connect $tcp_(2) $sink_(2)
set ftp_(2) [new Application/FTP]
$ftp_(2) attach-agent $tcp_(2)
$ns at 360.2 "$ftp_(2) start"
$ns at 540.0 "$ftp_(2) stop"

#Set a TCP connection between node_(60) and node_(48)
set tcp_(3) [new Agent/TCP/Newreno]
$tcp_(3) set class_ 2
set sink_(3) [new Agent/TCPSink]
$ns attach-agent $node_(60) $tcp_(3)
$ns attach-agent $node_(48) $sink_(3)
$ns connect $tcp_(3) $sink_(3)
set ftp_(3) [new Application/FTP]
$ftp_(3) attach-agent $tcp_(3)
$ns at 540.2 "$ftp_(3) start"
$ns at 720.0 "$ftp_(3) stop"

#Set a TCP connection between node_(96) and node_(40)
set tcp_(4) [new Agent/TCP/Newreno]
$tcp_(4) set class_ 2
set sink_(4) [new Agent/TCPSink]
$ns attach-agent $node_(96) $tcp_(4)
$ns attach-agent $node_(40) $sink_(4)
$ns connect $tcp_(4) $sink_(4)
set ftp_(4) [new Application/FTP]
$ftp_(4) attach-agent $tcp_(4)
$ns at 720.2 "$ftp_(4) start"
$ns at 900.0 "$ftp_(4) stop"

#Set a TCP connection between node_(61) and node_(79)
set tcp_(5) [new Agent/TCP/Newreno]
$tcp_(5) set class_ 2
set sink_(5) [new Agent/TCPSink]
$ns attach-agent $node_(61) $tcp_(5)
$ns attach-agent $node_(79) $sink_(5)
$ns connect $tcp_(5) $sink_(5)
set ftp_(5) [new Application/FTP]
$ftp_(5) attach-agent $tcp_(5)
$ns at 0.2 "$ftp_(5) start"
$ns at 180.0 "$ftp_(5) stop"

#Set a TCP connection between node_(89) and node_(34)
set tcp_(6) [new Agent/TCP/Newreno]
$tcp_(6) set class_ 2
set sink_(6) [new Agent/TCPSink]
$ns attach-agent $node_(89) $tcp_(6)
$ns attach-agent $node_(34) $sink_(6)
$ns connect $tcp_(6) $sink_(6)
set ftp_(6) [new Application/FTP]
$ftp_(6) attach-agent $tcp_(6)
$ns at 180.2 "$ftp_(6) start"
$ns at 360.0 "$ftp_(6) stop"

#Set a TCP connection between node_(77) and node_(87)
set tcp_(7) [new Agent/TCP/Newreno]
$tcp_(7) set class_ 2
set sink_(7) [new Agent/TCPSink]
$ns attach-agent $node_(77) $tcp_(7)
$ns attach-agent $node_(87) $sink_(7)
$ns connect $tcp_(7) $sink_(7)
set ftp_(7) [new Application/FTP]
$ftp_(7) attach-agent $tcp_(7)
$ns at 360.2 "$ftp_(7) start"
$ns at 540.0 "$ftp_(7) stop"

#Set a TCP connection between node_(76) and node_(8)
set tcp_(8) [new Agent/TCP/Newreno]
$tcp_(8) set class_ 2
set sink_(8) [new Agent/TCPSink]
$ns attach-agent $node_(76) $tcp_(8)
$ns attach-agent $node_(8) $sink_(8)
$ns connect $tcp_(8) $sink_(8)
set ftp_(8) [new Application/FTP]
$ftp_(8) attach-agent $tcp_(8)
$ns at 540.2 "$ftp_(8) start"
$ns at 720.0 "$ftp_(8) stop"

#Set a TCP connection between node_(26) and node_(59)
set tcp_(9) [new Agent/TCP/Newreno]
$tcp_(9) set class_ 2
set sink_(9) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(9)
$ns attach-agent $node_(59) $sink_(9)
$ns connect $tcp_(9) $sink_(9)
set ftp_(9) [new Application/FTP]
$ftp_(9) attach-agent $tcp_(9)
$ns at 720.2 "$ftp_(9) start"
$ns at 900.0 "$ftp_(9) stop"

#Set a TCP connection between node_(44) and node_(97)
set tcp_(10) [new Agent/TCP/Newreno]
$tcp_(10) set class_ 2
set sink_(10) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(10)
$ns attach-agent $node_(97) $sink_(10)
$ns connect $tcp_(10) $sink_(10)
set ftp_(10) [new Application/FTP]
$ftp_(10) attach-agent $tcp_(10)
$ns at 0.2 "$ftp_(10) start"
$ns at 180.0 "$ftp_(10) stop"

#Set a TCP connection between node_(48) and node_(58)
set tcp_(11) [new Agent/TCP/Newreno]
$tcp_(11) set class_ 2
set sink_(11) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(11)
$ns attach-agent $node_(58) $sink_(11)
$ns connect $tcp_(11) $sink_(11)
set ftp_(11) [new Application/FTP]
$ftp_(11) attach-agent $tcp_(11)
$ns at 180.2 "$ftp_(11) start"
$ns at 360.0 "$ftp_(11) stop"

#Set a TCP connection between node_(75) and node_(70)
set tcp_(12) [new Agent/TCP/Newreno]
$tcp_(12) set class_ 2
set sink_(12) [new Agent/TCPSink]
$ns attach-agent $node_(75) $tcp_(12)
$ns attach-agent $node_(70) $sink_(12)
$ns connect $tcp_(12) $sink_(12)
set ftp_(12) [new Application/FTP]
$ftp_(12) attach-agent $tcp_(12)
$ns at 360.2 "$ftp_(12) start"
$ns at 540.0 "$ftp_(12) stop"

#Set a TCP connection between node_(72) and node_(50)
set tcp_(13) [new Agent/TCP/Newreno]
$tcp_(13) set class_ 2
set sink_(13) [new Agent/TCPSink]
$ns attach-agent $node_(72) $tcp_(13)
$ns attach-agent $node_(50) $sink_(13)
$ns connect $tcp_(13) $sink_(13)
set ftp_(13) [new Application/FTP]
$ftp_(13) attach-agent $tcp_(13)
$ns at 540.2 "$ftp_(13) start"
$ns at 720.0 "$ftp_(13) stop"

#Set a TCP connection between node_(28) and node_(91)
set tcp_(14) [new Agent/TCP/Newreno]
$tcp_(14) set class_ 2
set sink_(14) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(14)
$ns attach-agent $node_(91) $sink_(14)
$ns connect $tcp_(14) $sink_(14)
set ftp_(14) [new Application/FTP]
$ftp_(14) attach-agent $tcp_(14)
$ns at 720.2 "$ftp_(14) start"
$ns at 900.0 "$ftp_(14) stop"

#Set a TCP connection between node_(54) and node_(31)
set tcp_(15) [new Agent/TCP/Newreno]
$tcp_(15) set class_ 2
set sink_(15) [new Agent/TCPSink]
$ns attach-agent $node_(54) $tcp_(15)
$ns attach-agent $node_(31) $sink_(15)
$ns connect $tcp_(15) $sink_(15)
set ftp_(15) [new Application/FTP]
$ftp_(15) attach-agent $tcp_(15)
$ns at 0.2 "$ftp_(15) start"
$ns at 180.0 "$ftp_(15) stop"

#Set a TCP connection between node_(44) and node_(85)
set tcp_(16) [new Agent/TCP/Newreno]
$tcp_(16) set class_ 2
set sink_(16) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(16)
$ns attach-agent $node_(85) $sink_(16)
$ns connect $tcp_(16) $sink_(16)
set ftp_(16) [new Application/FTP]
$ftp_(16) attach-agent $tcp_(16)
$ns at 180.2 "$ftp_(16) start"
$ns at 360.0 "$ftp_(16) stop"

#Set a TCP connection between node_(2) and node_(90)
set tcp_(17) [new Agent/TCP/Newreno]
$tcp_(17) set class_ 2
set sink_(17) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(17)
$ns attach-agent $node_(90) $sink_(17)
$ns connect $tcp_(17) $sink_(17)
set ftp_(17) [new Application/FTP]
$ftp_(17) attach-agent $tcp_(17)
$ns at 360.2 "$ftp_(17) start"
$ns at 540.0 "$ftp_(17) stop"

#Set a TCP connection between node_(33) and node_(0)
set tcp_(18) [new Agent/TCP/Newreno]
$tcp_(18) set class_ 2
set sink_(18) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(18)
$ns attach-agent $node_(0) $sink_(18)
$ns connect $tcp_(18) $sink_(18)
set ftp_(18) [new Application/FTP]
$ftp_(18) attach-agent $tcp_(18)
$ns at 540.2 "$ftp_(18) start"
$ns at 720.0 "$ftp_(18) stop"

#Set a TCP connection between node_(13) and node_(51)
set tcp_(19) [new Agent/TCP/Newreno]
$tcp_(19) set class_ 2
set sink_(19) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(19)
$ns attach-agent $node_(51) $sink_(19)
$ns connect $tcp_(19) $sink_(19)
set ftp_(19) [new Application/FTP]
$ftp_(19) attach-agent $tcp_(19)
$ns at 720.2 "$ftp_(19) start"
$ns at 900.0 "$ftp_(19) stop"

#Set a TCP connection between node_(2) and node_(5)
set tcp_(20) [new Agent/TCP/Newreno]
$tcp_(20) set class_ 2
set sink_(20) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(20)
$ns attach-agent $node_(5) $sink_(20)
$ns connect $tcp_(20) $sink_(20)
set ftp_(20) [new Application/FTP]
$ftp_(20) attach-agent $tcp_(20)
$ns at 0.2 "$ftp_(20) start"
$ns at 180.0 "$ftp_(20) stop"

#Set a TCP connection between node_(20) and node_(80)
set tcp_(21) [new Agent/TCP/Newreno]
$tcp_(21) set class_ 2
set sink_(21) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(21)
$ns attach-agent $node_(80) $sink_(21)
$ns connect $tcp_(21) $sink_(21)
set ftp_(21) [new Application/FTP]
$ftp_(21) attach-agent $tcp_(21)
$ns at 180.2 "$ftp_(21) start"
$ns at 360.0 "$ftp_(21) stop"

#Set a TCP connection between node_(20) and node_(11)
set tcp_(22) [new Agent/TCP/Newreno]
$tcp_(22) set class_ 2
set sink_(22) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(22)
$ns attach-agent $node_(11) $sink_(22)
$ns connect $tcp_(22) $sink_(22)
set ftp_(22) [new Application/FTP]
$ftp_(22) attach-agent $tcp_(22)
$ns at 360.2 "$ftp_(22) start"
$ns at 540.0 "$ftp_(22) stop"

#Set a TCP connection between node_(18) and node_(49)
set tcp_(23) [new Agent/TCP/Newreno]
$tcp_(23) set class_ 2
set sink_(23) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(23)
$ns attach-agent $node_(49) $sink_(23)
$ns connect $tcp_(23) $sink_(23)
set ftp_(23) [new Application/FTP]
$ftp_(23) attach-agent $tcp_(23)
$ns at 540.2 "$ftp_(23) start"
$ns at 720.0 "$ftp_(23) stop"

#Set a TCP connection between node_(30) and node_(52)
set tcp_(24) [new Agent/TCP/Newreno]
$tcp_(24) set class_ 2
set sink_(24) [new Agent/TCPSink]
$ns attach-agent $node_(30) $tcp_(24)
$ns attach-agent $node_(52) $sink_(24)
$ns connect $tcp_(24) $sink_(24)
set ftp_(24) [new Application/FTP]
$ftp_(24) attach-agent $tcp_(24)
$ns at 720.2 "$ftp_(24) start"
$ns at 900.0 "$ftp_(24) stop"

#Set a TCP connection between node_(35) and node_(81)
set tcp_(25) [new Agent/TCP/Newreno]
$tcp_(25) set class_ 2
set sink_(25) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(25)
$ns attach-agent $node_(81) $sink_(25)
$ns connect $tcp_(25) $sink_(25)
set ftp_(25) [new Application/FTP]
$ftp_(25) attach-agent $tcp_(25)
$ns at 0.2 "$ftp_(25) start"
$ns at 180.0 "$ftp_(25) stop"

#Set a TCP connection between node_(8) and node_(55)
set tcp_(26) [new Agent/TCP/Newreno]
$tcp_(26) set class_ 2
set sink_(26) [new Agent/TCPSink]
$ns attach-agent $node_(8) $tcp_(26)
$ns attach-agent $node_(55) $sink_(26)
$ns connect $tcp_(26) $sink_(26)
set ftp_(26) [new Application/FTP]
$ftp_(26) attach-agent $tcp_(26)
$ns at 180.2 "$ftp_(26) start"
$ns at 360.0 "$ftp_(26) stop"

#Set a TCP connection between node_(63) and node_(61)
set tcp_(27) [new Agent/TCP/Newreno]
$tcp_(27) set class_ 2
set sink_(27) [new Agent/TCPSink]
$ns attach-agent $node_(63) $tcp_(27)
$ns attach-agent $node_(61) $sink_(27)
$ns connect $tcp_(27) $sink_(27)
set ftp_(27) [new Application/FTP]
$ftp_(27) attach-agent $tcp_(27)
$ns at 360.2 "$ftp_(27) start"
$ns at 540.0 "$ftp_(27) stop"

#Set a TCP connection between node_(82) and node_(20)
set tcp_(28) [new Agent/TCP/Newreno]
$tcp_(28) set class_ 2
set sink_(28) [new Agent/TCPSink]
$ns attach-agent $node_(82) $tcp_(28)
$ns attach-agent $node_(20) $sink_(28)
$ns connect $tcp_(28) $sink_(28)
set ftp_(28) [new Application/FTP]
$ftp_(28) attach-agent $tcp_(28)
$ns at 540.2 "$ftp_(28) start"
$ns at 720.0 "$ftp_(28) stop"

#Set a TCP connection between node_(2) and node_(46)
set tcp_(29) [new Agent/TCP/Newreno]
$tcp_(29) set class_ 2
set sink_(29) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(29)
$ns attach-agent $node_(46) $sink_(29)
$ns connect $tcp_(29) $sink_(29)
set ftp_(29) [new Application/FTP]
$ftp_(29) attach-agent $tcp_(29)
$ns at 720.2 "$ftp_(29) start"
$ns at 900.0 "$ftp_(29) stop"

#Set a TCP connection between node_(99) and node_(43)
set tcp_(30) [new Agent/TCP/Newreno]
$tcp_(30) set class_ 2
set sink_(30) [new Agent/TCPSink]
$ns attach-agent $node_(99) $tcp_(30)
$ns attach-agent $node_(43) $sink_(30)
$ns connect $tcp_(30) $sink_(30)
set ftp_(30) [new Application/FTP]
$ftp_(30) attach-agent $tcp_(30)
$ns at 0.2 "$ftp_(30) start"
$ns at 180.0 "$ftp_(30) stop"

#Set a TCP connection between node_(39) and node_(97)
set tcp_(31) [new Agent/TCP/Newreno]
$tcp_(31) set class_ 2
set sink_(31) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(31)
$ns attach-agent $node_(97) $sink_(31)
$ns connect $tcp_(31) $sink_(31)
set ftp_(31) [new Application/FTP]
$ftp_(31) attach-agent $tcp_(31)
$ns at 180.2 "$ftp_(31) start"
$ns at 360.0 "$ftp_(31) stop"

#Set a TCP connection between node_(91) and node_(35)
set tcp_(32) [new Agent/TCP/Newreno]
$tcp_(32) set class_ 2
set sink_(32) [new Agent/TCPSink]
$ns attach-agent $node_(91) $tcp_(32)
$ns attach-agent $node_(35) $sink_(32)
$ns connect $tcp_(32) $sink_(32)
set ftp_(32) [new Application/FTP]
$ftp_(32) attach-agent $tcp_(32)
$ns at 360.2 "$ftp_(32) start"
$ns at 540.0 "$ftp_(32) stop"

#Set a TCP connection between node_(98) and node_(76)
set tcp_(33) [new Agent/TCP/Newreno]
$tcp_(33) set class_ 2
set sink_(33) [new Agent/TCPSink]
$ns attach-agent $node_(98) $tcp_(33)
$ns attach-agent $node_(76) $sink_(33)
$ns connect $tcp_(33) $sink_(33)
set ftp_(33) [new Application/FTP]
$ftp_(33) attach-agent $tcp_(33)
$ns at 540.2 "$ftp_(33) start"
$ns at 720.0 "$ftp_(33) stop"

#Set a TCP connection between node_(92) and node_(38)
set tcp_(34) [new Agent/TCP/Newreno]
$tcp_(34) set class_ 2
set sink_(34) [new Agent/TCPSink]
$ns attach-agent $node_(92) $tcp_(34)
$ns attach-agent $node_(38) $sink_(34)
$ns connect $tcp_(34) $sink_(34)
set ftp_(34) [new Application/FTP]
$ftp_(34) attach-agent $tcp_(34)
$ns at 720.2 "$ftp_(34) start"
$ns at 900.0 "$ftp_(34) stop"

#Set a TCP connection between node_(32) and node_(96)
set tcp_(35) [new Agent/TCP/Newreno]
$tcp_(35) set class_ 2
set sink_(35) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(35)
$ns attach-agent $node_(96) $sink_(35)
$ns connect $tcp_(35) $sink_(35)
set ftp_(35) [new Application/FTP]
$ftp_(35) attach-agent $tcp_(35)
$ns at 0.2 "$ftp_(35) start"
$ns at 180.0 "$ftp_(35) stop"

#Set a TCP connection between node_(77) and node_(93)
set tcp_(36) [new Agent/TCP/Newreno]
$tcp_(36) set class_ 2
set sink_(36) [new Agent/TCPSink]
$ns attach-agent $node_(77) $tcp_(36)
$ns attach-agent $node_(93) $sink_(36)
$ns connect $tcp_(36) $sink_(36)
set ftp_(36) [new Application/FTP]
$ftp_(36) attach-agent $tcp_(36)
$ns at 180.2 "$ftp_(36) start"
$ns at 360.0 "$ftp_(36) stop"

#Set a TCP connection between node_(23) and node_(37)
set tcp_(37) [new Agent/TCP/Newreno]
$tcp_(37) set class_ 2
set sink_(37) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(37)
$ns attach-agent $node_(37) $sink_(37)
$ns connect $tcp_(37) $sink_(37)
set ftp_(37) [new Application/FTP]
$ftp_(37) attach-agent $tcp_(37)
$ns at 360.2 "$ftp_(37) start"
$ns at 540.0 "$ftp_(37) stop"

#Set a TCP connection between node_(57) and node_(2)
set tcp_(38) [new Agent/TCP/Newreno]
$tcp_(38) set class_ 2
set sink_(38) [new Agent/TCPSink]
$ns attach-agent $node_(57) $tcp_(38)
$ns attach-agent $node_(2) $sink_(38)
$ns connect $tcp_(38) $sink_(38)
set ftp_(38) [new Application/FTP]
$ftp_(38) attach-agent $tcp_(38)
$ns at 540.2 "$ftp_(38) start"
$ns at 720.0 "$ftp_(38) stop"

#Set a TCP connection between node_(96) and node_(76)
set tcp_(39) [new Agent/TCP/Newreno]
$tcp_(39) set class_ 2
set sink_(39) [new Agent/TCPSink]
$ns attach-agent $node_(96) $tcp_(39)
$ns attach-agent $node_(76) $sink_(39)
$ns connect $tcp_(39) $sink_(39)
set ftp_(39) [new Application/FTP]
$ftp_(39) attach-agent $tcp_(39)
$ns at 720.2 "$ftp_(39) start"
$ns at 900.0 "$ftp_(39) stop"

#Set a TCP connection between node_(15) and node_(71)
set tcp_(40) [new Agent/TCP/Newreno]
$tcp_(40) set class_ 2
set sink_(40) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(40)
$ns attach-agent $node_(71) $sink_(40)
$ns connect $tcp_(40) $sink_(40)
set ftp_(40) [new Application/FTP]
$ftp_(40) attach-agent $tcp_(40)
$ns at 0.2 "$ftp_(40) start"
$ns at 180.0 "$ftp_(40) stop"

#Set a TCP connection between node_(22) and node_(56)
set tcp_(41) [new Agent/TCP/Newreno]
$tcp_(41) set class_ 2
set sink_(41) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(41)
$ns attach-agent $node_(56) $sink_(41)
$ns connect $tcp_(41) $sink_(41)
set ftp_(41) [new Application/FTP]
$ftp_(41) attach-agent $tcp_(41)
$ns at 180.2 "$ftp_(41) start"
$ns at 360.0 "$ftp_(41) stop"

#Set a TCP connection between node_(68) and node_(8)
set tcp_(42) [new Agent/TCP/Newreno]
$tcp_(42) set class_ 2
set sink_(42) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(42)
$ns attach-agent $node_(8) $sink_(42)
$ns connect $tcp_(42) $sink_(42)
set ftp_(42) [new Application/FTP]
$ftp_(42) attach-agent $tcp_(42)
$ns at 360.2 "$ftp_(42) start"
$ns at 540.0 "$ftp_(42) stop"

#Set a TCP connection between node_(56) and node_(62)
set tcp_(43) [new Agent/TCP/Newreno]
$tcp_(43) set class_ 2
set sink_(43) [new Agent/TCPSink]
$ns attach-agent $node_(56) $tcp_(43)
$ns attach-agent $node_(62) $sink_(43)
$ns connect $tcp_(43) $sink_(43)
set ftp_(43) [new Application/FTP]
$ftp_(43) attach-agent $tcp_(43)
$ns at 540.2 "$ftp_(43) start"
$ns at 720.0 "$ftp_(43) stop"

#Set a TCP connection between node_(92) and node_(56)
set tcp_(44) [new Agent/TCP/Newreno]
$tcp_(44) set class_ 2
set sink_(44) [new Agent/TCPSink]
$ns attach-agent $node_(92) $tcp_(44)
$ns attach-agent $node_(56) $sink_(44)
$ns connect $tcp_(44) $sink_(44)
set ftp_(44) [new Application/FTP]
$ftp_(44) attach-agent $tcp_(44)
$ns at 720.2 "$ftp_(44) start"
$ns at 900.0 "$ftp_(44) stop"

#Set a TCP connection between node_(2) and node_(99)
set tcp_(45) [new Agent/TCP/Newreno]
$tcp_(45) set class_ 2
set sink_(45) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(45)
$ns attach-agent $node_(99) $sink_(45)
$ns connect $tcp_(45) $sink_(45)
set ftp_(45) [new Application/FTP]
$ftp_(45) attach-agent $tcp_(45)
$ns at 0.2 "$ftp_(45) start"
$ns at 180.0 "$ftp_(45) stop"

#Set a TCP connection between node_(24) and node_(7)
set tcp_(46) [new Agent/TCP/Newreno]
$tcp_(46) set class_ 2
set sink_(46) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(46)
$ns attach-agent $node_(7) $sink_(46)
$ns connect $tcp_(46) $sink_(46)
set ftp_(46) [new Application/FTP]
$ftp_(46) attach-agent $tcp_(46)
$ns at 180.2 "$ftp_(46) start"
$ns at 360.0 "$ftp_(46) stop"

#Set a TCP connection between node_(61) and node_(49)
set tcp_(47) [new Agent/TCP/Newreno]
$tcp_(47) set class_ 2
set sink_(47) [new Agent/TCPSink]
$ns attach-agent $node_(61) $tcp_(47)
$ns attach-agent $node_(49) $sink_(47)
$ns connect $tcp_(47) $sink_(47)
set ftp_(47) [new Application/FTP]
$ftp_(47) attach-agent $tcp_(47)
$ns at 360.2 "$ftp_(47) start"
$ns at 540.0 "$ftp_(47) stop"

#Set a TCP connection between node_(77) and node_(58)
set tcp_(48) [new Agent/TCP/Newreno]
$tcp_(48) set class_ 2
set sink_(48) [new Agent/TCPSink]
$ns attach-agent $node_(77) $tcp_(48)
$ns attach-agent $node_(58) $sink_(48)
$ns connect $tcp_(48) $sink_(48)
set ftp_(48) [new Application/FTP]
$ftp_(48) attach-agent $tcp_(48)
$ns at 540.2 "$ftp_(48) start"
$ns at 720.0 "$ftp_(48) stop"

#Set a TCP connection between node_(86) and node_(7)
set tcp_(49) [new Agent/TCP/Newreno]
$tcp_(49) set class_ 2
set sink_(49) [new Agent/TCPSink]
$ns attach-agent $node_(86) $tcp_(49)
$ns attach-agent $node_(7) $sink_(49)
$ns connect $tcp_(49) $sink_(49)
set ftp_(49) [new Application/FTP]
$ftp_(49) attach-agent $tcp_(49)
$ns at 720.2 "$ftp_(49) start"
$ns at 900.0 "$ftp_(49) stop"

#Set a TCP connection between node_(2) and node_(80)
set tcp_(50) [new Agent/TCP/Newreno]
$tcp_(50) set class_ 2
set sink_(50) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(50)
$ns attach-agent $node_(80) $sink_(50)
$ns connect $tcp_(50) $sink_(50)
set ftp_(50) [new Application/FTP]
$ftp_(50) attach-agent $tcp_(50)
$ns at 0.2 "$ftp_(50) start"
$ns at 180.0 "$ftp_(50) stop"

#Set a TCP connection between node_(20) and node_(44)
set tcp_(51) [new Agent/TCP/Newreno]
$tcp_(51) set class_ 2
set sink_(51) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(51)
$ns attach-agent $node_(44) $sink_(51)
$ns connect $tcp_(51) $sink_(51)
set ftp_(51) [new Application/FTP]
$ftp_(51) attach-agent $tcp_(51)
$ns at 180.2 "$ftp_(51) start"
$ns at 360.0 "$ftp_(51) stop"

#Set a TCP connection between node_(74) and node_(97)
set tcp_(52) [new Agent/TCP/Newreno]
$tcp_(52) set class_ 2
set sink_(52) [new Agent/TCPSink]
$ns attach-agent $node_(74) $tcp_(52)
$ns attach-agent $node_(97) $sink_(52)
$ns connect $tcp_(52) $sink_(52)
set ftp_(52) [new Application/FTP]
$ftp_(52) attach-agent $tcp_(52)
$ns at 360.2 "$ftp_(52) start"
$ns at 540.0 "$ftp_(52) stop"

#Set a TCP connection between node_(9) and node_(4)
set tcp_(53) [new Agent/TCP/Newreno]
$tcp_(53) set class_ 2
set sink_(53) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(53)
$ns attach-agent $node_(4) $sink_(53)
$ns connect $tcp_(53) $sink_(53)
set ftp_(53) [new Application/FTP]
$ftp_(53) attach-agent $tcp_(53)
$ns at 540.2 "$ftp_(53) start"
$ns at 720.0 "$ftp_(53) stop"

#Set a TCP connection between node_(11) and node_(38)
set tcp_(54) [new Agent/TCP/Newreno]
$tcp_(54) set class_ 2
set sink_(54) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(54)
$ns attach-agent $node_(38) $sink_(54)
$ns connect $tcp_(54) $sink_(54)
set ftp_(54) [new Application/FTP]
$ftp_(54) attach-agent $tcp_(54)
$ns at 720.2 "$ftp_(54) start"
$ns at 900.0 "$ftp_(54) stop"

#Set a TCP connection between node_(61) and node_(64)
set tcp_(55) [new Agent/TCP/Newreno]
$tcp_(55) set class_ 2
set sink_(55) [new Agent/TCPSink]
$ns attach-agent $node_(61) $tcp_(55)
$ns attach-agent $node_(64) $sink_(55)
$ns connect $tcp_(55) $sink_(55)
set ftp_(55) [new Application/FTP]
$ftp_(55) attach-agent $tcp_(55)
$ns at 0.2 "$ftp_(55) start"
$ns at 180.0 "$ftp_(55) stop"

#Set a TCP connection between node_(30) and node_(73)
set tcp_(56) [new Agent/TCP/Newreno]
$tcp_(56) set class_ 2
set sink_(56) [new Agent/TCPSink]
$ns attach-agent $node_(30) $tcp_(56)
$ns attach-agent $node_(73) $sink_(56)
$ns connect $tcp_(56) $sink_(56)
set ftp_(56) [new Application/FTP]
$ftp_(56) attach-agent $tcp_(56)
$ns at 180.2 "$ftp_(56) start"
$ns at 360.0 "$ftp_(56) stop"

#Set a TCP connection between node_(68) and node_(52)
set tcp_(57) [new Agent/TCP/Newreno]
$tcp_(57) set class_ 2
set sink_(57) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(57)
$ns attach-agent $node_(52) $sink_(57)
$ns connect $tcp_(57) $sink_(57)
set ftp_(57) [new Application/FTP]
$ftp_(57) attach-agent $tcp_(57)
$ns at 360.2 "$ftp_(57) start"
$ns at 540.0 "$ftp_(57) stop"

#Set a TCP connection between node_(62) and node_(26)
set tcp_(58) [new Agent/TCP/Newreno]
$tcp_(58) set class_ 2
set sink_(58) [new Agent/TCPSink]
$ns attach-agent $node_(62) $tcp_(58)
$ns attach-agent $node_(26) $sink_(58)
$ns connect $tcp_(58) $sink_(58)
set ftp_(58) [new Application/FTP]
$ftp_(58) attach-agent $tcp_(58)
$ns at 540.2 "$ftp_(58) start"
$ns at 720.0 "$ftp_(58) stop"

#Set a TCP connection between node_(13) and node_(23)
set tcp_(59) [new Agent/TCP/Newreno]
$tcp_(59) set class_ 2
set sink_(59) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(59)
$ns attach-agent $node_(23) $sink_(59)
$ns connect $tcp_(59) $sink_(59)
set ftp_(59) [new Application/FTP]
$ftp_(59) attach-agent $tcp_(59)
$ns at 720.2 "$ftp_(59) start"
$ns at 900.0 "$ftp_(59) stop"

#Set a TCP connection between node_(42) and node_(64)
set tcp_(60) [new Agent/TCP/Newreno]
$tcp_(60) set class_ 2
set sink_(60) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(60)
$ns attach-agent $node_(64) $sink_(60)
$ns connect $tcp_(60) $sink_(60)
set ftp_(60) [new Application/FTP]
$ftp_(60) attach-agent $tcp_(60)
$ns at 0.2 "$ftp_(60) start"
$ns at 180.0 "$ftp_(60) stop"

#Set a TCP connection between node_(78) and node_(92)
set tcp_(61) [new Agent/TCP/Newreno]
$tcp_(61) set class_ 2
set sink_(61) [new Agent/TCPSink]
$ns attach-agent $node_(78) $tcp_(61)
$ns attach-agent $node_(92) $sink_(61)
$ns connect $tcp_(61) $sink_(61)
set ftp_(61) [new Application/FTP]
$ftp_(61) attach-agent $tcp_(61)
$ns at 180.2 "$ftp_(61) start"
$ns at 360.0 "$ftp_(61) stop"

#Set a TCP connection between node_(58) and node_(52)
set tcp_(62) [new Agent/TCP/Newreno]
$tcp_(62) set class_ 2
set sink_(62) [new Agent/TCPSink]
$ns attach-agent $node_(58) $tcp_(62)
$ns attach-agent $node_(52) $sink_(62)
$ns connect $tcp_(62) $sink_(62)
set ftp_(62) [new Application/FTP]
$ftp_(62) attach-agent $tcp_(62)
$ns at 360.2 "$ftp_(62) start"
$ns at 540.0 "$ftp_(62) stop"

#Set a TCP connection between node_(92) and node_(9)
set tcp_(63) [new Agent/TCP/Newreno]
$tcp_(63) set class_ 2
set sink_(63) [new Agent/TCPSink]
$ns attach-agent $node_(92) $tcp_(63)
$ns attach-agent $node_(9) $sink_(63)
$ns connect $tcp_(63) $sink_(63)
set ftp_(63) [new Application/FTP]
$ftp_(63) attach-agent $tcp_(63)
$ns at 540.2 "$ftp_(63) start"
$ns at 720.0 "$ftp_(63) stop"

#Set a TCP connection between node_(49) and node_(16)
set tcp_(64) [new Agent/TCP/Newreno]
$tcp_(64) set class_ 2
set sink_(64) [new Agent/TCPSink]
$ns attach-agent $node_(49) $tcp_(64)
$ns attach-agent $node_(16) $sink_(64)
$ns connect $tcp_(64) $sink_(64)
set ftp_(64) [new Application/FTP]
$ftp_(64) attach-agent $tcp_(64)
$ns at 720.2 "$ftp_(64) start"
$ns at 900.0 "$ftp_(64) stop"

#Set a TCP connection between node_(85) and node_(86)
set tcp_(65) [new Agent/TCP/Newreno]
$tcp_(65) set class_ 2
set sink_(65) [new Agent/TCPSink]
$ns attach-agent $node_(85) $tcp_(65)
$ns attach-agent $node_(86) $sink_(65)
$ns connect $tcp_(65) $sink_(65)
set ftp_(65) [new Application/FTP]
$ftp_(65) attach-agent $tcp_(65)
$ns at 0.2 "$ftp_(65) start"
$ns at 180.0 "$ftp_(65) stop"

#Set a TCP connection between node_(67) and node_(62)
set tcp_(66) [new Agent/TCP/Newreno]
$tcp_(66) set class_ 2
set sink_(66) [new Agent/TCPSink]
$ns attach-agent $node_(67) $tcp_(66)
$ns attach-agent $node_(62) $sink_(66)
$ns connect $tcp_(66) $sink_(66)
set ftp_(66) [new Application/FTP]
$ftp_(66) attach-agent $tcp_(66)
$ns at 180.2 "$ftp_(66) start"
$ns at 360.0 "$ftp_(66) stop"

#Set a TCP connection between node_(51) and node_(40)
set tcp_(67) [new Agent/TCP/Newreno]
$tcp_(67) set class_ 2
set sink_(67) [new Agent/TCPSink]
$ns attach-agent $node_(51) $tcp_(67)
$ns attach-agent $node_(40) $sink_(67)
$ns connect $tcp_(67) $sink_(67)
set ftp_(67) [new Application/FTP]
$ftp_(67) attach-agent $tcp_(67)
$ns at 360.2 "$ftp_(67) start"
$ns at 540.0 "$ftp_(67) stop"

#Set a TCP connection between node_(26) and node_(11)
set tcp_(68) [new Agent/TCP/Newreno]
$tcp_(68) set class_ 2
set sink_(68) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(68)
$ns attach-agent $node_(11) $sink_(68)
$ns connect $tcp_(68) $sink_(68)
set ftp_(68) [new Application/FTP]
$ftp_(68) attach-agent $tcp_(68)
$ns at 540.2 "$ftp_(68) start"
$ns at 720.0 "$ftp_(68) stop"

#Set a TCP connection between node_(47) and node_(66)
set tcp_(69) [new Agent/TCP/Newreno]
$tcp_(69) set class_ 2
set sink_(69) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(69)
$ns attach-agent $node_(66) $sink_(69)
$ns connect $tcp_(69) $sink_(69)
set ftp_(69) [new Application/FTP]
$ftp_(69) attach-agent $tcp_(69)
$ns at 720.2 "$ftp_(69) start"
$ns at 900.0 "$ftp_(69) stop"

#Set a TCP connection between node_(47) and node_(5)
set tcp_(70) [new Agent/TCP/Newreno]
$tcp_(70) set class_ 2
set sink_(70) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(70)
$ns attach-agent $node_(5) $sink_(70)
$ns connect $tcp_(70) $sink_(70)
set ftp_(70) [new Application/FTP]
$ftp_(70) attach-agent $tcp_(70)
$ns at 0.2 "$ftp_(70) start"
$ns at 180.0 "$ftp_(70) stop"

#Set a TCP connection between node_(16) and node_(61)
set tcp_(71) [new Agent/TCP/Newreno]
$tcp_(71) set class_ 2
set sink_(71) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(71)
$ns attach-agent $node_(61) $sink_(71)
$ns connect $tcp_(71) $sink_(71)
set ftp_(71) [new Application/FTP]
$ftp_(71) attach-agent $tcp_(71)
$ns at 180.2 "$ftp_(71) start"
$ns at 360.0 "$ftp_(71) stop"

#Set a TCP connection between node_(13) and node_(28)
set tcp_(72) [new Agent/TCP/Newreno]
$tcp_(72) set class_ 2
set sink_(72) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(72)
$ns attach-agent $node_(28) $sink_(72)
$ns connect $tcp_(72) $sink_(72)
set ftp_(72) [new Application/FTP]
$ftp_(72) attach-agent $tcp_(72)
$ns at 360.2 "$ftp_(72) start"
$ns at 540.0 "$ftp_(72) stop"

#Set a TCP connection between node_(88) and node_(60)
set tcp_(73) [new Agent/TCP/Newreno]
$tcp_(73) set class_ 2
set sink_(73) [new Agent/TCPSink]
$ns attach-agent $node_(88) $tcp_(73)
$ns attach-agent $node_(60) $sink_(73)
$ns connect $tcp_(73) $sink_(73)
set ftp_(73) [new Application/FTP]
$ftp_(73) attach-agent $tcp_(73)
$ns at 540.2 "$ftp_(73) start"
$ns at 720.0 "$ftp_(73) stop"

#Set a TCP connection between node_(16) and node_(76)
set tcp_(74) [new Agent/TCP/Newreno]
$tcp_(74) set class_ 2
set sink_(74) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(74)
$ns attach-agent $node_(76) $sink_(74)
$ns connect $tcp_(74) $sink_(74)
set ftp_(74) [new Application/FTP]
$ftp_(74) attach-agent $tcp_(74)
$ns at 720.2 "$ftp_(74) start"
$ns at 900.0 "$ftp_(74) stop"

#Set a TCP connection between node_(18) and node_(95)
set tcp_(75) [new Agent/TCP/Newreno]
$tcp_(75) set class_ 2
set sink_(75) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(75)
$ns attach-agent $node_(95) $sink_(75)
$ns connect $tcp_(75) $sink_(75)
set ftp_(75) [new Application/FTP]
$ftp_(75) attach-agent $tcp_(75)
$ns at 0.2 "$ftp_(75) start"
$ns at 180.0 "$ftp_(75) stop"

#Set a TCP connection between node_(41) and node_(46)
set tcp_(76) [new Agent/TCP/Newreno]
$tcp_(76) set class_ 2
set sink_(76) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(76)
$ns attach-agent $node_(46) $sink_(76)
$ns connect $tcp_(76) $sink_(76)
set ftp_(76) [new Application/FTP]
$ftp_(76) attach-agent $tcp_(76)
$ns at 180.2 "$ftp_(76) start"
$ns at 360.0 "$ftp_(76) stop"

#Set a TCP connection between node_(73) and node_(35)
set tcp_(77) [new Agent/TCP/Newreno]
$tcp_(77) set class_ 2
set sink_(77) [new Agent/TCPSink]
$ns attach-agent $node_(73) $tcp_(77)
$ns attach-agent $node_(35) $sink_(77)
$ns connect $tcp_(77) $sink_(77)
set ftp_(77) [new Application/FTP]
$ftp_(77) attach-agent $tcp_(77)
$ns at 360.2 "$ftp_(77) start"
$ns at 540.0 "$ftp_(77) stop"

#Set a TCP connection between node_(9) and node_(39)
set tcp_(78) [new Agent/TCP/Newreno]
$tcp_(78) set class_ 2
set sink_(78) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(78)
$ns attach-agent $node_(39) $sink_(78)
$ns connect $tcp_(78) $sink_(78)
set ftp_(78) [new Application/FTP]
$ftp_(78) attach-agent $tcp_(78)
$ns at 540.2 "$ftp_(78) start"
$ns at 720.0 "$ftp_(78) stop"

#Set a TCP connection between node_(0) and node_(89)
set tcp_(79) [new Agent/TCP/Newreno]
$tcp_(79) set class_ 2
set sink_(79) [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp_(79)
$ns attach-agent $node_(89) $sink_(79)
$ns connect $tcp_(79) $sink_(79)
set ftp_(79) [new Application/FTP]
$ftp_(79) attach-agent $tcp_(79)
$ns at 720.2 "$ftp_(79) start"
$ns at 900.0 "$ftp_(79) stop"

#Set a TCP connection between node_(43) and node_(33)
set tcp_(80) [new Agent/TCP/Newreno]
$tcp_(80) set class_ 2
set sink_(80) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(80)
$ns attach-agent $node_(33) $sink_(80)
$ns connect $tcp_(80) $sink_(80)
set ftp_(80) [new Application/FTP]
$ftp_(80) attach-agent $tcp_(80)
$ns at 0.2 "$ftp_(80) start"
$ns at 180.0 "$ftp_(80) stop"

#Set a TCP connection between node_(68) and node_(76)
set tcp_(81) [new Agent/TCP/Newreno]
$tcp_(81) set class_ 2
set sink_(81) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(81)
$ns attach-agent $node_(76) $sink_(81)
$ns connect $tcp_(81) $sink_(81)
set ftp_(81) [new Application/FTP]
$ftp_(81) attach-agent $tcp_(81)
$ns at 180.2 "$ftp_(81) start"
$ns at 360.0 "$ftp_(81) stop"

#Set a TCP connection between node_(47) and node_(39)
set tcp_(82) [new Agent/TCP/Newreno]
$tcp_(82) set class_ 2
set sink_(82) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(82)
$ns attach-agent $node_(39) $sink_(82)
$ns connect $tcp_(82) $sink_(82)
set ftp_(82) [new Application/FTP]
$ftp_(82) attach-agent $tcp_(82)
$ns at 360.2 "$ftp_(82) start"
$ns at 540.0 "$ftp_(82) stop"

#Set a TCP connection between node_(58) and node_(2)
set tcp_(83) [new Agent/TCP/Newreno]
$tcp_(83) set class_ 2
set sink_(83) [new Agent/TCPSink]
$ns attach-agent $node_(58) $tcp_(83)
$ns attach-agent $node_(2) $sink_(83)
$ns connect $tcp_(83) $sink_(83)
set ftp_(83) [new Application/FTP]
$ftp_(83) attach-agent $tcp_(83)
$ns at 540.2 "$ftp_(83) start"
$ns at 720.0 "$ftp_(83) stop"

#Set a TCP connection between node_(59) and node_(35)
set tcp_(84) [new Agent/TCP/Newreno]
$tcp_(84) set class_ 2
set sink_(84) [new Agent/TCPSink]
$ns attach-agent $node_(59) $tcp_(84)
$ns attach-agent $node_(35) $sink_(84)
$ns connect $tcp_(84) $sink_(84)
set ftp_(84) [new Application/FTP]
$ftp_(84) attach-agent $tcp_(84)
$ns at 720.2 "$ftp_(84) start"
$ns at 900.0 "$ftp_(84) stop"

#Set a TCP connection between node_(81) and node_(13)
set tcp_(85) [new Agent/TCP/Newreno]
$tcp_(85) set class_ 2
set sink_(85) [new Agent/TCPSink]
$ns attach-agent $node_(81) $tcp_(85)
$ns attach-agent $node_(13) $sink_(85)
$ns connect $tcp_(85) $sink_(85)
set ftp_(85) [new Application/FTP]
$ftp_(85) attach-agent $tcp_(85)
$ns at 0.2 "$ftp_(85) start"
$ns at 180.0 "$ftp_(85) stop"

#Set a TCP connection between node_(9) and node_(85)
set tcp_(86) [new Agent/TCP/Newreno]
$tcp_(86) set class_ 2
set sink_(86) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(86)
$ns attach-agent $node_(85) $sink_(86)
$ns connect $tcp_(86) $sink_(86)
set ftp_(86) [new Application/FTP]
$ftp_(86) attach-agent $tcp_(86)
$ns at 180.2 "$ftp_(86) start"
$ns at 360.0 "$ftp_(86) stop"

#Set a TCP connection between node_(41) and node_(29)
set tcp_(87) [new Agent/TCP/Newreno]
$tcp_(87) set class_ 2
set sink_(87) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(87)
$ns attach-agent $node_(29) $sink_(87)
$ns connect $tcp_(87) $sink_(87)
set ftp_(87) [new Application/FTP]
$ftp_(87) attach-agent $tcp_(87)
$ns at 360.2 "$ftp_(87) start"
$ns at 540.0 "$ftp_(87) stop"

#Set a TCP connection between node_(72) and node_(56)
set tcp_(88) [new Agent/TCP/Newreno]
$tcp_(88) set class_ 2
set sink_(88) [new Agent/TCPSink]
$ns attach-agent $node_(72) $tcp_(88)
$ns attach-agent $node_(56) $sink_(88)
$ns connect $tcp_(88) $sink_(88)
set ftp_(88) [new Application/FTP]
$ftp_(88) attach-agent $tcp_(88)
$ns at 540.2 "$ftp_(88) start"
$ns at 720.0 "$ftp_(88) stop"

#Set a TCP connection between node_(3) and node_(38)
set tcp_(89) [new Agent/TCP/Newreno]
$tcp_(89) set class_ 2
set sink_(89) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(89)
$ns attach-agent $node_(38) $sink_(89)
$ns connect $tcp_(89) $sink_(89)
set ftp_(89) [new Application/FTP]
$ftp_(89) attach-agent $tcp_(89)
$ns at 720.2 "$ftp_(89) start"
$ns at 900.0 "$ftp_(89) stop"

#Set a TCP connection between node_(94) and node_(53)
set tcp_(90) [new Agent/TCP/Newreno]
$tcp_(90) set class_ 2
set sink_(90) [new Agent/TCPSink]
$ns attach-agent $node_(94) $tcp_(90)
$ns attach-agent $node_(53) $sink_(90)
$ns connect $tcp_(90) $sink_(90)
set ftp_(90) [new Application/FTP]
$ftp_(90) attach-agent $tcp_(90)
$ns at 0.2 "$ftp_(90) start"
$ns at 180.0 "$ftp_(90) stop"

#Set a TCP connection between node_(4) and node_(61)
set tcp_(91) [new Agent/TCP/Newreno]
$tcp_(91) set class_ 2
set sink_(91) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(91)
$ns attach-agent $node_(61) $sink_(91)
$ns connect $tcp_(91) $sink_(91)
set ftp_(91) [new Application/FTP]
$ftp_(91) attach-agent $tcp_(91)
$ns at 180.2 "$ftp_(91) start"
$ns at 360.0 "$ftp_(91) stop"

#Set a TCP connection between node_(36) and node_(91)
set tcp_(92) [new Agent/TCP/Newreno]
$tcp_(92) set class_ 2
set sink_(92) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(92)
$ns attach-agent $node_(91) $sink_(92)
$ns connect $tcp_(92) $sink_(92)
set ftp_(92) [new Application/FTP]
$ftp_(92) attach-agent $tcp_(92)
$ns at 360.2 "$ftp_(92) start"
$ns at 540.0 "$ftp_(92) stop"

#Set a TCP connection between node_(80) and node_(89)
set tcp_(93) [new Agent/TCP/Newreno]
$tcp_(93) set class_ 2
set sink_(93) [new Agent/TCPSink]
$ns attach-agent $node_(80) $tcp_(93)
$ns attach-agent $node_(89) $sink_(93)
$ns connect $tcp_(93) $sink_(93)
set ftp_(93) [new Application/FTP]
$ftp_(93) attach-agent $tcp_(93)
$ns at 540.2 "$ftp_(93) start"
$ns at 720.0 "$ftp_(93) stop"

#Set a TCP connection between node_(18) and node_(23)
set tcp_(94) [new Agent/TCP/Newreno]
$tcp_(94) set class_ 2
set sink_(94) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(94)
$ns attach-agent $node_(23) $sink_(94)
$ns connect $tcp_(94) $sink_(94)
set ftp_(94) [new Application/FTP]
$ftp_(94) attach-agent $tcp_(94)
$ns at 720.2 "$ftp_(94) start"
$ns at 900.0 "$ftp_(94) stop"

#Set a TCP connection between node_(33) and node_(20)
set tcp_(95) [new Agent/TCP/Newreno]
$tcp_(95) set class_ 2
set sink_(95) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(95)
$ns attach-agent $node_(20) $sink_(95)
$ns connect $tcp_(95) $sink_(95)
set ftp_(95) [new Application/FTP]
$ftp_(95) attach-agent $tcp_(95)
$ns at 0.2 "$ftp_(95) start"
$ns at 180.0 "$ftp_(95) stop"

#Set a TCP connection between node_(81) and node_(58)
set tcp_(96) [new Agent/TCP/Newreno]
$tcp_(96) set class_ 2
set sink_(96) [new Agent/TCPSink]
$ns attach-agent $node_(81) $tcp_(96)
$ns attach-agent $node_(58) $sink_(96)
$ns connect $tcp_(96) $sink_(96)
set ftp_(96) [new Application/FTP]
$ftp_(96) attach-agent $tcp_(96)
$ns at 180.2 "$ftp_(96) start"
$ns at 360.0 "$ftp_(96) stop"

#Set a TCP connection between node_(8) and node_(1)
set tcp_(97) [new Agent/TCP/Newreno]
$tcp_(97) set class_ 2
set sink_(97) [new Agent/TCPSink]
$ns attach-agent $node_(8) $tcp_(97)
$ns attach-agent $node_(1) $sink_(97)
$ns connect $tcp_(97) $sink_(97)
set ftp_(97) [new Application/FTP]
$ftp_(97) attach-agent $tcp_(97)
$ns at 360.2 "$ftp_(97) start"
$ns at 540.0 "$ftp_(97) stop"

#Set a TCP connection between node_(59) and node_(85)
set tcp_(98) [new Agent/TCP/Newreno]
$tcp_(98) set class_ 2
set sink_(98) [new Agent/TCPSink]
$ns attach-agent $node_(59) $tcp_(98)
$ns attach-agent $node_(85) $sink_(98)
$ns connect $tcp_(98) $sink_(98)
set ftp_(98) [new Application/FTP]
$ftp_(98) attach-agent $tcp_(98)
$ns at 540.2 "$ftp_(98) start"
$ns at 720.0 "$ftp_(98) stop"

#Set a TCP connection between node_(43) and node_(14)
set tcp_(99) [new Agent/TCP/Newreno]
$tcp_(99) set class_ 2
set sink_(99) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(99)
$ns attach-agent $node_(14) $sink_(99)
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
