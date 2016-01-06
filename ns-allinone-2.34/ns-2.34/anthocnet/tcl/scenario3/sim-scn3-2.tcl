#sim-scn3-2.tcl 
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
set tracefd       [open sim-scn3-2-$val(rp)-trace.tr w]
set windowVsTime2 [open sim-scn3-2-$val(rp)-win-.tr w]
set namtrace      [open sim-scn3-2-$val(rp).nam w]

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
$node_(0) set X_ 1602 
$node_(0) set Y_ 648 
$node_(0) set Z_ 0.0 
$node_(1) set X_ 2432 
$node_(1) set Y_ 428 
$node_(1) set Z_ 0.0 
$node_(2) set X_ 1696 
$node_(2) set Y_ 850 
$node_(2) set Z_ 0.0 
$node_(3) set X_ 519 
$node_(3) set Y_ 954 
$node_(3) set Z_ 0.0 
$node_(4) set X_ 2129 
$node_(4) set Y_ 183 
$node_(4) set Z_ 0.0 
$node_(5) set X_ 1909 
$node_(5) set Y_ 115 
$node_(5) set Z_ 0.0 
$node_(6) set X_ 119 
$node_(6) set Y_ 466 
$node_(6) set Z_ 0.0 
$node_(7) set X_ 1588 
$node_(7) set Y_ 166 
$node_(7) set Z_ 0.0 
$node_(8) set X_ 2357 
$node_(8) set Y_ 479 
$node_(8) set Z_ 0.0 
$node_(9) set X_ 2603 
$node_(9) set Y_ 877 
$node_(9) set Z_ 0.0 
$node_(10) set X_ 349 
$node_(10) set Y_ 322 
$node_(10) set Z_ 0.0 
$node_(11) set X_ 2749 
$node_(11) set Y_ 745 
$node_(11) set Z_ 0.0 
$node_(12) set X_ 2866 
$node_(12) set Y_ 653 
$node_(12) set Z_ 0.0 
$node_(13) set X_ 1515 
$node_(13) set Y_ 453 
$node_(13) set Z_ 0.0 
$node_(14) set X_ 2228 
$node_(14) set Y_ 423 
$node_(14) set Z_ 0.0 
$node_(15) set X_ 674 
$node_(15) set Y_ 264 
$node_(15) set Z_ 0.0 
$node_(16) set X_ 1014 
$node_(16) set Y_ 275 
$node_(16) set Z_ 0.0 
$node_(17) set X_ 732 
$node_(17) set Y_ 27 
$node_(17) set Z_ 0.0 
$node_(18) set X_ 1365 
$node_(18) set Y_ 474 
$node_(18) set Z_ 0.0 
$node_(19) set X_ 1547 
$node_(19) set Y_ 157 
$node_(19) set Z_ 0.0 
$node_(20) set X_ 341 
$node_(20) set Y_ 101 
$node_(20) set Z_ 0.0 
$node_(21) set X_ 1664 
$node_(21) set Y_ 203 
$node_(21) set Z_ 0.0 
$node_(22) set X_ 1807 
$node_(22) set Y_ 239 
$node_(22) set Z_ 0.0 
$node_(23) set X_ 2437 
$node_(23) set Y_ 653 
$node_(23) set Z_ 0.0 
$node_(24) set X_ 1076 
$node_(24) set Y_ 55 
$node_(24) set Z_ 0.0 
$node_(25) set X_ 2737 
$node_(25) set Y_ 183 
$node_(25) set Z_ 0.0 
$node_(26) set X_ 2945 
$node_(26) set Y_ 18 
$node_(26) set Z_ 0.0 
$node_(27) set X_ 1953 
$node_(27) set Y_ 896 
$node_(27) set Z_ 0.0 
$node_(28) set X_ 981 
$node_(28) set Y_ 965 
$node_(28) set Z_ 0.0 
$node_(29) set X_ 2165 
$node_(29) set Y_ 962 
$node_(29) set Z_ 0.0 
$node_(30) set X_ 774 
$node_(30) set Y_ 349 
$node_(30) set Z_ 0.0 
$node_(31) set X_ 1743 
$node_(31) set Y_ 742 
$node_(31) set Z_ 0.0 
$node_(32) set X_ 481 
$node_(32) set Y_ 842 
$node_(32) set Z_ 0.0 
$node_(33) set X_ 2222 
$node_(33) set Y_ 640 
$node_(33) set Z_ 0.0 
$node_(34) set X_ 2332 
$node_(34) set Y_ 356 
$node_(34) set Z_ 0.0 
$node_(35) set X_ 84 
$node_(35) set Y_ 915 
$node_(35) set Z_ 0.0 
$node_(36) set X_ 802 
$node_(36) set Y_ 708 
$node_(36) set Z_ 0.0 
$node_(37) set X_ 166 
$node_(37) set Y_ 167 
$node_(37) set Z_ 0.0 
$node_(38) set X_ 1905 
$node_(38) set Y_ 377 
$node_(38) set Z_ 0.0 
$node_(39) set X_ 600 
$node_(39) set Y_ 489 
$node_(39) set Z_ 0.0 
$node_(40) set X_ 2587 
$node_(40) set Y_ 243 
$node_(40) set Z_ 0.0 
$node_(41) set X_ 2704 
$node_(41) set Y_ 112 
$node_(41) set Z_ 0.0 
$node_(42) set X_ 350 
$node_(42) set Y_ 763 
$node_(42) set Z_ 0.0 
$node_(43) set X_ 2901 
$node_(43) set Y_ 904 
$node_(43) set Z_ 0.0 
$node_(44) set X_ 1197 
$node_(44) set Y_ 775 
$node_(44) set Z_ 0.0 
$node_(45) set X_ 2668 
$node_(45) set Y_ 292 
$node_(45) set Z_ 0.0 
$node_(46) set X_ 2616 
$node_(46) set Y_ 3 
$node_(46) set Z_ 0.0 
$node_(47) set X_ 2636 
$node_(47) set Y_ 972 
$node_(47) set Z_ 0.0 
$node_(48) set X_ 2660 
$node_(48) set Y_ 387 
$node_(48) set Z_ 0.0 
$node_(49) set X_ 1286 
$node_(49) set Y_ 328 
$node_(49) set Z_ 0.0 
$node_(50) set X_ 1304 
$node_(50) set Y_ 561 
$node_(50) set Z_ 0.0 
$node_(51) set X_ 2280 
$node_(51) set Y_ 572 
$node_(51) set Z_ 0.0 
$node_(52) set X_ 992 
$node_(52) set Y_ 147 
$node_(52) set Z_ 0.0 
$node_(53) set X_ 1220 
$node_(53) set Y_ 477 
$node_(53) set Z_ 0.0 
$node_(54) set X_ 2864 
$node_(54) set Y_ 70 
$node_(54) set Z_ 0.0 
$node_(55) set X_ 1641 
$node_(55) set Y_ 11 
$node_(55) set Z_ 0.0 
$node_(56) set X_ 2348 
$node_(56) set Y_ 738 
$node_(56) set Z_ 0.0 
$node_(57) set X_ 1253 
$node_(57) set Y_ 312 
$node_(57) set Z_ 0.0 
$node_(58) set X_ 757 
$node_(58) set Y_ 784 
$node_(58) set Z_ 0.0 
$node_(59) set X_ 894 
$node_(59) set Y_ 231 
$node_(59) set Z_ 0.0 
$node_(60) set X_ 2224 
$node_(60) set Y_ 18 
$node_(60) set Z_ 0.0 
$node_(61) set X_ 296 
$node_(61) set Y_ 81 
$node_(61) set Z_ 0.0 
$node_(62) set X_ 1676 
$node_(62) set Y_ 424 
$node_(62) set Z_ 0.0 
$node_(63) set X_ 1660 
$node_(63) set Y_ 345 
$node_(63) set Z_ 0.0 
$node_(64) set X_ 2661 
$node_(64) set Y_ 256 
$node_(64) set Z_ 0.0 
$node_(65) set X_ 1105 
$node_(65) set Y_ 836 
$node_(65) set Z_ 0.0 
$node_(66) set X_ 1676 
$node_(66) set Y_ 823 
$node_(66) set Z_ 0.0 
$node_(67) set X_ 1398 
$node_(67) set Y_ 188 
$node_(67) set Z_ 0.0 
$node_(68) set X_ 1186 
$node_(68) set Y_ 85 
$node_(68) set Z_ 0.0 
$node_(69) set X_ 1863 
$node_(69) set Y_ 655 
$node_(69) set Z_ 0.0 
$node_(70) set X_ 1786 
$node_(70) set Y_ 999 
$node_(70) set Z_ 0.0 
$node_(71) set X_ 1155 
$node_(71) set Y_ 856 
$node_(71) set Z_ 0.0 
$node_(72) set X_ 940 
$node_(72) set Y_ 432 
$node_(72) set Z_ 0.0 
$node_(73) set X_ 530 
$node_(73) set Y_ 544 
$node_(73) set Z_ 0.0 
$node_(74) set X_ 453 
$node_(74) set Y_ 569 
$node_(74) set Z_ 0.0 
$node_(75) set X_ 2432 
$node_(75) set Y_ 429 
$node_(75) set Z_ 0.0 
$node_(76) set X_ 2209 
$node_(76) set Y_ 944 
$node_(76) set Z_ 0.0 
$node_(77) set X_ 1623 
$node_(77) set Y_ 848 
$node_(77) set Z_ 0.0 
$node_(78) set X_ 2907 
$node_(78) set Y_ 634 
$node_(78) set Z_ 0.0 
$node_(79) set X_ 2715 
$node_(79) set Y_ 342 
$node_(79) set Z_ 0.0 
$node_(80) set X_ 2329 
$node_(80) set Y_ 684 
$node_(80) set Z_ 0.0 
$node_(81) set X_ 801 
$node_(81) set Y_ 259 
$node_(81) set Z_ 0.0 
$node_(82) set X_ 1288 
$node_(82) set Y_ 537 
$node_(82) set Z_ 0.0 
$node_(83) set X_ 2924 
$node_(83) set Y_ 108 
$node_(83) set Z_ 0.0 
$node_(84) set X_ 1683 
$node_(84) set Y_ 109 
$node_(84) set Z_ 0.0 
$node_(85) set X_ 1447 
$node_(85) set Y_ 739 
$node_(85) set Z_ 0.0 
$node_(86) set X_ 116 
$node_(86) set Y_ 135 
$node_(86) set Z_ 0.0 
$node_(87) set X_ 1831 
$node_(87) set Y_ 347 
$node_(87) set Z_ 0.0 
$node_(88) set X_ 2235 
$node_(88) set Y_ 614 
$node_(88) set Z_ 0.0 
$node_(89) set X_ 1109 
$node_(89) set Y_ 963 
$node_(89) set Z_ 0.0 
$node_(90) set X_ 455 
$node_(90) set Y_ 482 
$node_(90) set Z_ 0.0 
$node_(91) set X_ 1206 
$node_(91) set Y_ 338 
$node_(91) set Z_ 0.0 
$node_(92) set X_ 842 
$node_(92) set Y_ 138 
$node_(92) set Z_ 0.0 
$node_(93) set X_ 487 
$node_(93) set Y_ 87 
$node_(93) set Z_ 0.0 
$node_(94) set X_ 860 
$node_(94) set Y_ 67 
$node_(94) set Z_ 0.0 
$node_(95) set X_ 1228 
$node_(95) set Y_ 535 
$node_(95) set Z_ 0.0 
$node_(96) set X_ 1289 
$node_(96) set Y_ 630 
$node_(96) set Z_ 0.0 
$node_(97) set X_ 1337 
$node_(97) set Y_ 950 
$node_(97) set Z_ 0.0 
$node_(98) set X_ 1930 
$node_(98) set Y_ 0 
$node_(98) set Z_ 0.0 
$node_(99) set X_ 2437 
$node_(99) set Y_ 777 
$node_(99) set Z_ 0.0 
$node_(100) set X_ 775 
$node_(100) set Y_ 371 
$node_(100) set Z_ 0.0 
$node_(101) set X_ 2475 
$node_(101) set Y_ 16 
$node_(101) set Z_ 0.0 
$ns at 0.0 "$node_(101) off" 
$ns at 100.0 "$node_(101) on" 
$node_(102) set X_ 2088 
$node_(102) set Y_ 792 
$node_(102) set Z_ 0.0 
$ns at 0.0 "$node_(102) off" 
$ns at 100.0 "$node_(102) on" 
$node_(103) set X_ 1253 
$node_(103) set Y_ 120 
$node_(103) set Z_ 0.0 
$ns at 0.0 "$node_(103) off" 
$ns at 100.0 "$node_(103) on" 
$node_(104) set X_ 304 
$node_(104) set Y_ 432 
$node_(104) set Z_ 0.0 
$ns at 0.0 "$node_(104) off" 
$ns at 100.0 "$node_(104) on" 
$node_(105) set X_ 757 
$node_(105) set Y_ 660 
$node_(105) set Z_ 0.0 
$ns at 0.0 "$node_(105) off" 
$ns at 100.0 "$node_(105) on" 
$node_(106) set X_ 2893 
$node_(106) set Y_ 623 
$node_(106) set Z_ 0.0 
$ns at 0.0 "$node_(106) off" 
$ns at 100.0 "$node_(106) on" 
$node_(107) set X_ 2837 
$node_(107) set Y_ 524 
$node_(107) set Z_ 0.0 
$ns at 0.0 "$node_(107) off" 
$ns at 100.0 "$node_(107) on" 
$node_(108) set X_ 2203 
$node_(108) set Y_ 790 
$node_(108) set Z_ 0.0 
$ns at 0.0 "$node_(108) off" 
$ns at 100.0 "$node_(108) on" 
$node_(109) set X_ 1703 
$node_(109) set Y_ 617 
$node_(109) set Z_ 0.0 
$ns at 0.0 "$node_(109) off" 
$ns at 100.0 "$node_(109) on" 
$node_(110) set X_ 1001 
$node_(110) set Y_ 242 
$node_(110) set Z_ 0.0 
$ns at 0.0 "$node_(110) off" 
$ns at 100.0 "$node_(110) on" 
$node_(111) set X_ 827 
$node_(111) set Y_ 842 
$node_(111) set Z_ 0.0 
$ns at 0.0 "$node_(111) off" 
$ns at 100.0 "$node_(111) on" 
$node_(112) set X_ 727 
$node_(112) set Y_ 860 
$node_(112) set Z_ 0.0 
$ns at 0.0 "$node_(112) off" 
$ns at 100.0 "$node_(112) on" 
$node_(113) set X_ 167 
$node_(113) set Y_ 682 
$node_(113) set Z_ 0.0 
$ns at 0.0 "$node_(113) off" 
$ns at 100.0 "$node_(113) on" 
$node_(114) set X_ 1601 
$node_(114) set Y_ 896 
$node_(114) set Z_ 0.0 
$ns at 0.0 "$node_(114) off" 
$ns at 100.0 "$node_(114) on" 
$node_(115) set X_ 224 
$node_(115) set Y_ 808 
$node_(115) set Z_ 0.0 
$ns at 0.0 "$node_(115) off" 
$ns at 100.0 "$node_(115) on" 
$node_(116) set X_ 2480 
$node_(116) set Y_ 481 
$node_(116) set Z_ 0.0 
$ns at 0.0 "$node_(116) off" 
$ns at 100.0 "$node_(116) on" 
$node_(117) set X_ 189 
$node_(117) set Y_ 987 
$node_(117) set Z_ 0.0 
$ns at 0.0 "$node_(117) off" 
$ns at 100.0 "$node_(117) on" 
$node_(118) set X_ 1920 
$node_(118) set Y_ 929 
$node_(118) set Z_ 0.0 
$ns at 0.0 "$node_(118) off" 
$ns at 100.0 "$node_(118) on" 
$node_(119) set X_ 1450 
$node_(119) set Y_ 2 
$node_(119) set Z_ 0.0 
$ns at 0.0 "$node_(119) off" 
$ns at 100.0 "$node_(119) on" 
$node_(120) set X_ 86 
$node_(120) set Y_ 604 
$node_(120) set Z_ 0.0 
$ns at 0.0 "$node_(120) off" 
$ns at 100.0 "$node_(120) on" 
$node_(121) set X_ 2959 
$node_(121) set Y_ 442 
$node_(121) set Z_ 0.0 
$ns at 0.0 "$node_(121) off" 
$ns at 100.0 "$node_(121) on" 
$node_(122) set X_ 2135 
$node_(122) set Y_ 947 
$node_(122) set Z_ 0.0 
$ns at 0.0 "$node_(122) off" 
$ns at 100.0 "$node_(122) on" 
$node_(123) set X_ 2367 
$node_(123) set Y_ 978 
$node_(123) set Z_ 0.0 
$ns at 0.0 "$node_(123) off" 
$ns at 100.0 "$node_(123) on" 
$node_(124) set X_ 363 
$node_(124) set Y_ 219 
$node_(124) set Z_ 0.0 
$ns at 0.0 "$node_(124) off" 
$ns at 100.0 "$node_(124) on" 
$node_(125) set X_ 521 
$node_(125) set Y_ 179 
$node_(125) set Z_ 0.0 
$ns at 0.0 "$node_(125) off" 
$ns at 100.0 "$node_(125) on" 
$node_(126) set X_ 2784 
$node_(126) set Y_ 695 
$node_(126) set Z_ 0.0 
$ns at 0.0 "$node_(126) off" 
$ns at 100.0 "$node_(126) on" 
$node_(127) set X_ 770 
$node_(127) set Y_ 34 
$node_(127) set Z_ 0.0 
$ns at 0.0 "$node_(127) off" 
$ns at 100.0 "$node_(127) on" 
$node_(128) set X_ 1935 
$node_(128) set Y_ 281 
$node_(128) set Z_ 0.0 
$ns at 0.0 "$node_(128) off" 
$ns at 100.0 "$node_(128) on" 
$node_(129) set X_ 1626 
$node_(129) set Y_ 59 
$node_(129) set Z_ 0.0 
$ns at 0.0 "$node_(129) off" 
$ns at 100.0 "$node_(129) on" 
$node_(130) set X_ 2514 
$node_(130) set Y_ 40 
$node_(130) set Z_ 0.0 
$ns at 0.0 "$node_(130) off" 
$ns at 100.0 "$node_(130) on" 
$node_(131) set X_ 1644 
$node_(131) set Y_ 301 
$node_(131) set Z_ 0.0 
$ns at 0.0 "$node_(131) off" 
$ns at 100.0 "$node_(131) on" 
$node_(132) set X_ 1011 
$node_(132) set Y_ 658 
$node_(132) set Z_ 0.0 
$ns at 0.0 "$node_(132) off" 
$ns at 100.0 "$node_(132) on" 
$node_(133) set X_ 2897 
$node_(133) set Y_ 596 
$node_(133) set Z_ 0.0 
$ns at 0.0 "$node_(133) off" 
$ns at 100.0 "$node_(133) on" 
$node_(134) set X_ 1758 
$node_(134) set Y_ 700 
$node_(134) set Z_ 0.0 
$ns at 0.0 "$node_(134) off" 
$ns at 100.0 "$node_(134) on" 
$node_(135) set X_ 1204 
$node_(135) set Y_ 144 
$node_(135) set Z_ 0.0 
$ns at 0.0 "$node_(135) off" 
$ns at 100.0 "$node_(135) on" 
$node_(136) set X_ 2795 
$node_(136) set Y_ 371 
$node_(136) set Z_ 0.0 
$ns at 0.0 "$node_(136) off" 
$ns at 100.0 "$node_(136) on" 
$node_(137) set X_ 2193 
$node_(137) set Y_ 875 
$node_(137) set Z_ 0.0 
$ns at 0.0 "$node_(137) off" 
$ns at 100.0 "$node_(137) on" 
$node_(138) set X_ 678 
$node_(138) set Y_ 623 
$node_(138) set Z_ 0.0 
$ns at 0.0 "$node_(138) off" 
$ns at 100.0 "$node_(138) on" 
$node_(139) set X_ 1504 
$node_(139) set Y_ 52 
$node_(139) set Z_ 0.0 
$ns at 0.0 "$node_(139) off" 
$ns at 100.0 "$node_(139) on" 
$node_(140) set X_ 1737 
$node_(140) set Y_ 641 
$node_(140) set Z_ 0.0 
$ns at 0.0 "$node_(140) off" 
$ns at 100.0 "$node_(140) on" 
$node_(141) set X_ 1834 
$node_(141) set Y_ 289 
$node_(141) set Z_ 0.0 
$ns at 0.0 "$node_(141) off" 
$ns at 100.0 "$node_(141) on" 
$node_(142) set X_ 1470 
$node_(142) set Y_ 150 
$node_(142) set Z_ 0.0 
$ns at 0.0 "$node_(142) off" 
$ns at 100.0 "$node_(142) on" 
$node_(143) set X_ 2126 
$node_(143) set Y_ 488 
$node_(143) set Z_ 0.0 
$ns at 0.0 "$node_(143) off" 
$ns at 100.0 "$node_(143) on" 
$node_(144) set X_ 2592 
$node_(144) set Y_ 521 
$node_(144) set Z_ 0.0 
$ns at 0.0 "$node_(144) off" 
$ns at 100.0 "$node_(144) on" 
$node_(145) set X_ 1088 
$node_(145) set Y_ 175 
$node_(145) set Z_ 0.0 
$ns at 0.0 "$node_(145) off" 
$ns at 100.0 "$node_(145) on" 
$node_(146) set X_ 1853 
$node_(146) set Y_ 362 
$node_(146) set Z_ 0.0 
$ns at 0.0 "$node_(146) off" 
$ns at 100.0 "$node_(146) on" 
$node_(147) set X_ 248 
$node_(147) set Y_ 409 
$node_(147) set Z_ 0.0 
$ns at 0.0 "$node_(147) off" 
$ns at 100.0 "$node_(147) on" 
$node_(148) set X_ 2007 
$node_(148) set Y_ 120 
$node_(148) set Z_ 0.0 
$ns at 0.0 "$node_(148) off" 
$ns at 100.0 "$node_(148) on" 
$node_(149) set X_ 2068 
$node_(149) set Y_ 702 
$node_(149) set Z_ 0.0 
$ns at 0.0 "$node_(149) off" 
$ns at 100.0 "$node_(149) on" 
$node_(150) set X_ 367 
$node_(150) set Y_ 258 
$node_(150) set Z_ 0.0 
$ns at 0.0 "$node_(150) off" 
$ns at 100.0 "$node_(150) on" 
$node_(151) set X_ 1103 
$node_(151) set Y_ 402 
$node_(151) set Z_ 0.0 
$ns at 0.0 "$node_(151) off" 
$ns at 100.0 "$node_(151) on" 
$node_(152) set X_ 1088 
$node_(152) set Y_ 707 
$node_(152) set Z_ 0.0 
$ns at 0.0 "$node_(152) off" 
$ns at 100.0 "$node_(152) on" 
$node_(153) set X_ 2947 
$node_(153) set Y_ 564 
$node_(153) set Z_ 0.0 
$ns at 0.0 "$node_(153) off" 
$ns at 100.0 "$node_(153) on" 
$node_(154) set X_ 1773 
$node_(154) set Y_ 655 
$node_(154) set Z_ 0.0 
$ns at 0.0 "$node_(154) off" 
$ns at 100.0 "$node_(154) on" 
$node_(155) set X_ 2609 
$node_(155) set Y_ 652 
$node_(155) set Z_ 0.0 
$ns at 0.0 "$node_(155) off" 
$ns at 100.0 "$node_(155) on" 
$node_(156) set X_ 181 
$node_(156) set Y_ 189 
$node_(156) set Z_ 0.0 
$ns at 0.0 "$node_(156) off" 
$ns at 100.0 "$node_(156) on" 
$node_(157) set X_ 1139 
$node_(157) set Y_ 330 
$node_(157) set Z_ 0.0 
$ns at 0.0 "$node_(157) off" 
$ns at 100.0 "$node_(157) on" 
$node_(158) set X_ 2692 
$node_(158) set Y_ 950 
$node_(158) set Z_ 0.0 
$ns at 0.0 "$node_(158) off" 
$ns at 100.0 "$node_(158) on" 
$node_(159) set X_ 2701 
$node_(159) set Y_ 192 
$node_(159) set Z_ 0.0 
$ns at 0.0 "$node_(159) off" 
$ns at 100.0 "$node_(159) on" 
$node_(160) set X_ 2810 
$node_(160) set Y_ 764 
$node_(160) set Z_ 0.0 
$ns at 0.0 "$node_(160) off" 
$ns at 100.0 "$node_(160) on" 
$node_(161) set X_ 2852 
$node_(161) set Y_ 531 
$node_(161) set Z_ 0.0 
$ns at 0.0 "$node_(161) off" 
$ns at 100.0 "$node_(161) on" 
$node_(162) set X_ 1283 
$node_(162) set Y_ 151 
$node_(162) set Z_ 0.0 
$ns at 0.0 "$node_(162) off" 
$ns at 100.0 "$node_(162) on" 
$node_(163) set X_ 644 
$node_(163) set Y_ 154 
$node_(163) set Z_ 0.0 
$ns at 0.0 "$node_(163) off" 
$ns at 100.0 "$node_(163) on" 
$node_(164) set X_ 2505 
$node_(164) set Y_ 733 
$node_(164) set Z_ 0.0 
$ns at 0.0 "$node_(164) off" 
$ns at 100.0 "$node_(164) on" 
$node_(165) set X_ 158 
$node_(165) set Y_ 804 
$node_(165) set Z_ 0.0 
$ns at 0.0 "$node_(165) off" 
$ns at 100.0 "$node_(165) on" 
$node_(166) set X_ 581 
$node_(166) set Y_ 805 
$node_(166) set Z_ 0.0 
$ns at 0.0 "$node_(166) off" 
$ns at 100.0 "$node_(166) on" 
$node_(167) set X_ 342 
$node_(167) set Y_ 962 
$node_(167) set Z_ 0.0 
$ns at 0.0 "$node_(167) off" 
$ns at 100.0 "$node_(167) on" 
$node_(168) set X_ 1975 
$node_(168) set Y_ 776 
$node_(168) set Z_ 0.0 
$ns at 0.0 "$node_(168) off" 
$ns at 100.0 "$node_(168) on" 
$node_(169) set X_ 498 
$node_(169) set Y_ 690 
$node_(169) set Z_ 0.0 
$ns at 0.0 "$node_(169) off" 
$ns at 100.0 "$node_(169) on" 
$node_(170) set X_ 2809 
$node_(170) set Y_ 739 
$node_(170) set Z_ 0.0 
$ns at 0.0 "$node_(170) off" 
$ns at 100.0 "$node_(170) on" 
$node_(171) set X_ 438 
$node_(171) set Y_ 684 
$node_(171) set Z_ 0.0 
$ns at 0.0 "$node_(171) off" 
$ns at 100.0 "$node_(171) on" 
$node_(172) set X_ 844 
$node_(172) set Y_ 185 
$node_(172) set Z_ 0.0 
$ns at 0.0 "$node_(172) off" 
$ns at 100.0 "$node_(172) on" 
$node_(173) set X_ 2252 
$node_(173) set Y_ 907 
$node_(173) set Z_ 0.0 
$ns at 0.0 "$node_(173) off" 
$ns at 100.0 "$node_(173) on" 
$node_(174) set X_ 1781 
$node_(174) set Y_ 733 
$node_(174) set Z_ 0.0 
$ns at 0.0 "$node_(174) off" 
$ns at 100.0 "$node_(174) on" 
$node_(175) set X_ 1720 
$node_(175) set Y_ 2 
$node_(175) set Z_ 0.0 
$ns at 0.0 "$node_(175) off" 
$ns at 100.0 "$node_(175) on" 
$node_(176) set X_ 2913 
$node_(176) set Y_ 832 
$node_(176) set Z_ 0.0 
$ns at 0.0 "$node_(176) off" 
$ns at 100.0 "$node_(176) on" 
$node_(177) set X_ 2799 
$node_(177) set Y_ 189 
$node_(177) set Z_ 0.0 
$ns at 0.0 "$node_(177) off" 
$ns at 100.0 "$node_(177) on" 
$node_(178) set X_ 2202 
$node_(178) set Y_ 542 
$node_(178) set Z_ 0.0 
$ns at 0.0 "$node_(178) off" 
$ns at 100.0 "$node_(178) on" 
$node_(179) set X_ 112 
$node_(179) set Y_ 499 
$node_(179) set Z_ 0.0 
$ns at 0.0 "$node_(179) off" 
$ns at 100.0 "$node_(179) on" 
$node_(180) set X_ 1666 
$node_(180) set Y_ 903 
$node_(180) set Z_ 0.0 
$ns at 0.0 "$node_(180) off" 
$ns at 100.0 "$node_(180) on" 
$node_(181) set X_ 202 
$node_(181) set Y_ 12 
$node_(181) set Z_ 0.0 
$ns at 0.0 "$node_(181) off" 
$ns at 100.0 "$node_(181) on" 
$node_(182) set X_ 2492 
$node_(182) set Y_ 895 
$node_(182) set Z_ 0.0 
$ns at 0.0 "$node_(182) off" 
$ns at 100.0 "$node_(182) on" 
$node_(183) set X_ 281 
$node_(183) set Y_ 224 
$node_(183) set Z_ 0.0 
$ns at 0.0 "$node_(183) off" 
$ns at 100.0 "$node_(183) on" 
$node_(184) set X_ 2483 
$node_(184) set Y_ 643 
$node_(184) set Z_ 0.0 
$ns at 0.0 "$node_(184) off" 
$ns at 100.0 "$node_(184) on" 
$node_(185) set X_ 1428 
$node_(185) set Y_ 801 
$node_(185) set Z_ 0.0 
$ns at 0.0 "$node_(185) off" 
$ns at 100.0 "$node_(185) on" 
$node_(186) set X_ 1446 
$node_(186) set Y_ 383 
$node_(186) set Z_ 0.0 
$ns at 0.0 "$node_(186) off" 
$ns at 100.0 "$node_(186) on" 
$node_(187) set X_ 1638 
$node_(187) set Y_ 746 
$node_(187) set Z_ 0.0 
$ns at 0.0 "$node_(187) off" 
$ns at 100.0 "$node_(187) on" 
$node_(188) set X_ 2770 
$node_(188) set Y_ 658 
$node_(188) set Z_ 0.0 
$ns at 0.0 "$node_(188) off" 
$ns at 100.0 "$node_(188) on" 
$node_(189) set X_ 2759 
$node_(189) set Y_ 443 
$node_(189) set Z_ 0.0 
$ns at 0.0 "$node_(189) off" 
$ns at 100.0 "$node_(189) on" 
$node_(190) set X_ 2829 
$node_(190) set Y_ 357 
$node_(190) set Z_ 0.0 
$ns at 0.0 "$node_(190) off" 
$ns at 100.0 "$node_(190) on" 
$node_(191) set X_ 2253 
$node_(191) set Y_ 145 
$node_(191) set Z_ 0.0 
$ns at 0.0 "$node_(191) off" 
$ns at 100.0 "$node_(191) on" 
$node_(192) set X_ 1984 
$node_(192) set Y_ 522 
$node_(192) set Z_ 0.0 
$ns at 0.0 "$node_(192) off" 
$ns at 100.0 "$node_(192) on" 
$node_(193) set X_ 1785 
$node_(193) set Y_ 188 
$node_(193) set Z_ 0.0 
$ns at 0.0 "$node_(193) off" 
$ns at 100.0 "$node_(193) on" 
$node_(194) set X_ 1750 
$node_(194) set Y_ 255 
$node_(194) set Z_ 0.0 
$ns at 0.0 "$node_(194) off" 
$ns at 100.0 "$node_(194) on" 
$node_(195) set X_ 970 
$node_(195) set Y_ 660 
$node_(195) set Z_ 0.0 
$ns at 0.0 "$node_(195) off" 
$ns at 100.0 "$node_(195) on" 
$node_(196) set X_ 255 
$node_(196) set Y_ 727 
$node_(196) set Z_ 0.0 
$ns at 0.0 "$node_(196) off" 
$ns at 100.0 "$node_(196) on" 
$node_(197) set X_ 2144 
$node_(197) set Y_ 272 
$node_(197) set Z_ 0.0 
$ns at 0.0 "$node_(197) off" 
$ns at 100.0 "$node_(197) on" 
$node_(198) set X_ 400 
$node_(198) set Y_ 986 
$node_(198) set Z_ 0.0 
$ns at 0.0 "$node_(198) off" 
$ns at 100.0 "$node_(198) on" 
$node_(199) set X_ 2744 
$node_(199) set Y_ 930 
$node_(199) set Z_ 0.0 
$ns at 0.0 "$node_(199) off" 
$ns at 100.0 "$node_(199) on" 
$node_(200) set X_ 2070 
$node_(200) set Y_ 229 
$node_(200) set Z_ 0.0 
$ns at 0.0 "$node_(200) off" 
$ns at 200.0 "$node_(200) on" 
$node_(201) set X_ 2902 
$node_(201) set Y_ 843 
$node_(201) set Z_ 0.0 
$ns at 0.0 "$node_(201) off" 
$ns at 200.0 "$node_(201) on" 
$node_(202) set X_ 2495 
$node_(202) set Y_ 268 
$node_(202) set Z_ 0.0 
$ns at 0.0 "$node_(202) off" 
$ns at 200.0 "$node_(202) on" 
$node_(203) set X_ 2979 
$node_(203) set Y_ 65 
$node_(203) set Z_ 0.0 
$ns at 0.0 "$node_(203) off" 
$ns at 200.0 "$node_(203) on" 
$node_(204) set X_ 246 
$node_(204) set Y_ 118 
$node_(204) set Z_ 0.0 
$ns at 0.0 "$node_(204) off" 
$ns at 200.0 "$node_(204) on" 
$node_(205) set X_ 1233 
$node_(205) set Y_ 27 
$node_(205) set Z_ 0.0 
$ns at 0.0 "$node_(205) off" 
$ns at 200.0 "$node_(205) on" 
$node_(206) set X_ 2513 
$node_(206) set Y_ 79 
$node_(206) set Z_ 0.0 
$ns at 0.0 "$node_(206) off" 
$ns at 200.0 "$node_(206) on" 
$node_(207) set X_ 2393 
$node_(207) set Y_ 973 
$node_(207) set Z_ 0.0 
$ns at 0.0 "$node_(207) off" 
$ns at 200.0 "$node_(207) on" 
$node_(208) set X_ 148 
$node_(208) set Y_ 181 
$node_(208) set Z_ 0.0 
$ns at 0.0 "$node_(208) off" 
$ns at 200.0 "$node_(208) on" 
$node_(209) set X_ 1787 
$node_(209) set Y_ 204 
$node_(209) set Z_ 0.0 
$ns at 0.0 "$node_(209) off" 
$ns at 200.0 "$node_(209) on" 
$node_(210) set X_ 1567 
$node_(210) set Y_ 587 
$node_(210) set Z_ 0.0 
$ns at 0.0 "$node_(210) off" 
$ns at 200.0 "$node_(210) on" 
$node_(211) set X_ 2693 
$node_(211) set Y_ 675 
$node_(211) set Z_ 0.0 
$ns at 0.0 "$node_(211) off" 
$ns at 200.0 "$node_(211) on" 
$node_(212) set X_ 858 
$node_(212) set Y_ 384 
$node_(212) set Z_ 0.0 
$ns at 0.0 "$node_(212) off" 
$ns at 200.0 "$node_(212) on" 
$node_(213) set X_ 2924 
$node_(213) set Y_ 840 
$node_(213) set Z_ 0.0 
$ns at 0.0 "$node_(213) off" 
$ns at 200.0 "$node_(213) on" 
$node_(214) set X_ 1500 
$node_(214) set Y_ 238 
$node_(214) set Z_ 0.0 
$ns at 0.0 "$node_(214) off" 
$ns at 200.0 "$node_(214) on" 
$node_(215) set X_ 78 
$node_(215) set Y_ 544 
$node_(215) set Z_ 0.0 
$ns at 0.0 "$node_(215) off" 
$ns at 200.0 "$node_(215) on" 
$node_(216) set X_ 786 
$node_(216) set Y_ 520 
$node_(216) set Z_ 0.0 
$ns at 0.0 "$node_(216) off" 
$ns at 200.0 "$node_(216) on" 
$node_(217) set X_ 2687 
$node_(217) set Y_ 448 
$node_(217) set Z_ 0.0 
$ns at 0.0 "$node_(217) off" 
$ns at 200.0 "$node_(217) on" 
$node_(218) set X_ 1550 
$node_(218) set Y_ 863 
$node_(218) set Z_ 0.0 
$ns at 0.0 "$node_(218) off" 
$ns at 200.0 "$node_(218) on" 
$node_(219) set X_ 355 
$node_(219) set Y_ 696 
$node_(219) set Z_ 0.0 
$ns at 0.0 "$node_(219) off" 
$ns at 200.0 "$node_(219) on" 
$node_(220) set X_ 2907 
$node_(220) set Y_ 574 
$node_(220) set Z_ 0.0 
$ns at 0.0 "$node_(220) off" 
$ns at 200.0 "$node_(220) on" 
$node_(221) set X_ 2190 
$node_(221) set Y_ 512 
$node_(221) set Z_ 0.0 
$ns at 0.0 "$node_(221) off" 
$ns at 200.0 "$node_(221) on" 
$node_(222) set X_ 1662 
$node_(222) set Y_ 978 
$node_(222) set Z_ 0.0 
$ns at 0.0 "$node_(222) off" 
$ns at 200.0 "$node_(222) on" 
$node_(223) set X_ 2189 
$node_(223) set Y_ 971 
$node_(223) set Z_ 0.0 
$ns at 0.0 "$node_(223) off" 
$ns at 200.0 "$node_(223) on" 
$node_(224) set X_ 1609 
$node_(224) set Y_ 548 
$node_(224) set Z_ 0.0 
$ns at 0.0 "$node_(224) off" 
$ns at 200.0 "$node_(224) on" 
$node_(225) set X_ 2804 
$node_(225) set Y_ 458 
$node_(225) set Z_ 0.0 
$ns at 0.0 "$node_(225) off" 
$ns at 200.0 "$node_(225) on" 
$node_(226) set X_ 2298 
$node_(226) set Y_ 647 
$node_(226) set Z_ 0.0 
$ns at 0.0 "$node_(226) off" 
$ns at 200.0 "$node_(226) on" 
$node_(227) set X_ 777 
$node_(227) set Y_ 225 
$node_(227) set Z_ 0.0 
$ns at 0.0 "$node_(227) off" 
$ns at 200.0 "$node_(227) on" 
$node_(228) set X_ 2867 
$node_(228) set Y_ 781 
$node_(228) set Z_ 0.0 
$ns at 0.0 "$node_(228) off" 
$ns at 200.0 "$node_(228) on" 
$node_(229) set X_ 313 
$node_(229) set Y_ 5 
$node_(229) set Z_ 0.0 
$ns at 0.0 "$node_(229) off" 
$ns at 200.0 "$node_(229) on" 
$node_(230) set X_ 334 
$node_(230) set Y_ 572 
$node_(230) set Z_ 0.0 
$ns at 0.0 "$node_(230) off" 
$ns at 200.0 "$node_(230) on" 
$node_(231) set X_ 1952 
$node_(231) set Y_ 884 
$node_(231) set Z_ 0.0 
$ns at 0.0 "$node_(231) off" 
$ns at 200.0 "$node_(231) on" 
$node_(232) set X_ 1191 
$node_(232) set Y_ 25 
$node_(232) set Z_ 0.0 
$ns at 0.0 "$node_(232) off" 
$ns at 200.0 "$node_(232) on" 
$node_(233) set X_ 926 
$node_(233) set Y_ 469 
$node_(233) set Z_ 0.0 
$ns at 0.0 "$node_(233) off" 
$ns at 200.0 "$node_(233) on" 
$node_(234) set X_ 2372 
$node_(234) set Y_ 291 
$node_(234) set Z_ 0.0 
$ns at 0.0 "$node_(234) off" 
$ns at 200.0 "$node_(234) on" 
$node_(235) set X_ 1517 
$node_(235) set Y_ 960 
$node_(235) set Z_ 0.0 
$ns at 0.0 "$node_(235) off" 
$ns at 200.0 "$node_(235) on" 
$node_(236) set X_ 2580 
$node_(236) set Y_ 807 
$node_(236) set Z_ 0.0 
$ns at 0.0 "$node_(236) off" 
$ns at 200.0 "$node_(236) on" 
$node_(237) set X_ 803 
$node_(237) set Y_ 866 
$node_(237) set Z_ 0.0 
$ns at 0.0 "$node_(237) off" 
$ns at 200.0 "$node_(237) on" 
$node_(238) set X_ 2576 
$node_(238) set Y_ 638 
$node_(238) set Z_ 0.0 
$ns at 0.0 "$node_(238) off" 
$ns at 200.0 "$node_(238) on" 
$node_(239) set X_ 2320 
$node_(239) set Y_ 7 
$node_(239) set Z_ 0.0 
$ns at 0.0 "$node_(239) off" 
$ns at 200.0 "$node_(239) on" 
$node_(240) set X_ 444 
$node_(240) set Y_ 830 
$node_(240) set Z_ 0.0 
$ns at 0.0 "$node_(240) off" 
$ns at 200.0 "$node_(240) on" 
$node_(241) set X_ 504 
$node_(241) set Y_ 884 
$node_(241) set Z_ 0.0 
$ns at 0.0 "$node_(241) off" 
$ns at 200.0 "$node_(241) on" 
$node_(242) set X_ 1852 
$node_(242) set Y_ 847 
$node_(242) set Z_ 0.0 
$ns at 0.0 "$node_(242) off" 
$ns at 200.0 "$node_(242) on" 
$node_(243) set X_ 1354 
$node_(243) set Y_ 697 
$node_(243) set Z_ 0.0 
$ns at 0.0 "$node_(243) off" 
$ns at 200.0 "$node_(243) on" 
$node_(244) set X_ 1199 
$node_(244) set Y_ 449 
$node_(244) set Z_ 0.0 
$ns at 0.0 "$node_(244) off" 
$ns at 200.0 "$node_(244) on" 
$node_(245) set X_ 500 
$node_(245) set Y_ 65 
$node_(245) set Z_ 0.0 
$ns at 0.0 "$node_(245) off" 
$ns at 200.0 "$node_(245) on" 
$node_(246) set X_ 1980 
$node_(246) set Y_ 963 
$node_(246) set Z_ 0.0 
$ns at 0.0 "$node_(246) off" 
$ns at 200.0 "$node_(246) on" 
$node_(247) set X_ 2913 
$node_(247) set Y_ 998 
$node_(247) set Z_ 0.0 
$ns at 0.0 "$node_(247) off" 
$ns at 200.0 "$node_(247) on" 
$node_(248) set X_ 2009 
$node_(248) set Y_ 484 
$node_(248) set Z_ 0.0 
$ns at 0.0 "$node_(248) off" 
$ns at 200.0 "$node_(248) on" 
$node_(249) set X_ 2659 
$node_(249) set Y_ 771 
$node_(249) set Z_ 0.0 
$ns at 0.0 "$node_(249) off" 
$ns at 200.0 "$node_(249) on" 
$node_(250) set X_ 2019 
$node_(250) set Y_ 440 
$node_(250) set Z_ 0.0 
$ns at 0.0 "$node_(250) off" 
$ns at 200.0 "$node_(250) on" 
$node_(251) set X_ 572 
$node_(251) set Y_ 140 
$node_(251) set Z_ 0.0 
$ns at 0.0 "$node_(251) off" 
$ns at 200.0 "$node_(251) on" 
$node_(252) set X_ 890 
$node_(252) set Y_ 887 
$node_(252) set Z_ 0.0 
$ns at 0.0 "$node_(252) off" 
$ns at 200.0 "$node_(252) on" 
$node_(253) set X_ 1358 
$node_(253) set Y_ 771 
$node_(253) set Z_ 0.0 
$ns at 0.0 "$node_(253) off" 
$ns at 200.0 "$node_(253) on" 
$node_(254) set X_ 1098 
$node_(254) set Y_ 68 
$node_(254) set Z_ 0.0 
$ns at 0.0 "$node_(254) off" 
$ns at 200.0 "$node_(254) on" 
$node_(255) set X_ 525 
$node_(255) set Y_ 842 
$node_(255) set Z_ 0.0 
$ns at 0.0 "$node_(255) off" 
$ns at 200.0 "$node_(255) on" 
$node_(256) set X_ 133 
$node_(256) set Y_ 39 
$node_(256) set Z_ 0.0 
$ns at 0.0 "$node_(256) off" 
$ns at 200.0 "$node_(256) on" 
$node_(257) set X_ 2619 
$node_(257) set Y_ 533 
$node_(257) set Z_ 0.0 
$ns at 0.0 "$node_(257) off" 
$ns at 200.0 "$node_(257) on" 
$node_(258) set X_ 407 
$node_(258) set Y_ 643 
$node_(258) set Z_ 0.0 
$ns at 0.0 "$node_(258) off" 
$ns at 200.0 "$node_(258) on" 
$node_(259) set X_ 560 
$node_(259) set Y_ 502 
$node_(259) set Z_ 0.0 
$ns at 0.0 "$node_(259) off" 
$ns at 200.0 "$node_(259) on" 
$node_(260) set X_ 772 
$node_(260) set Y_ 692 
$node_(260) set Z_ 0.0 
$ns at 0.0 "$node_(260) off" 
$ns at 200.0 "$node_(260) on" 
$node_(261) set X_ 2420 
$node_(261) set Y_ 545 
$node_(261) set Z_ 0.0 
$ns at 0.0 "$node_(261) off" 
$ns at 200.0 "$node_(261) on" 
$node_(262) set X_ 998 
$node_(262) set Y_ 1 
$node_(262) set Z_ 0.0 
$ns at 0.0 "$node_(262) off" 
$ns at 200.0 "$node_(262) on" 
$node_(263) set X_ 1688 
$node_(263) set Y_ 297 
$node_(263) set Z_ 0.0 
$ns at 0.0 "$node_(263) off" 
$ns at 200.0 "$node_(263) on" 
$node_(264) set X_ 1550 
$node_(264) set Y_ 826 
$node_(264) set Z_ 0.0 
$ns at 0.0 "$node_(264) off" 
$ns at 200.0 "$node_(264) on" 
$node_(265) set X_ 96 
$node_(265) set Y_ 258 
$node_(265) set Z_ 0.0 
$ns at 0.0 "$node_(265) off" 
$ns at 200.0 "$node_(265) on" 
$node_(266) set X_ 727 
$node_(266) set Y_ 330 
$node_(266) set Z_ 0.0 
$ns at 0.0 "$node_(266) off" 
$ns at 200.0 "$node_(266) on" 
$node_(267) set X_ 1216 
$node_(267) set Y_ 418 
$node_(267) set Z_ 0.0 
$ns at 0.0 "$node_(267) off" 
$ns at 200.0 "$node_(267) on" 
$node_(268) set X_ 1608 
$node_(268) set Y_ 946 
$node_(268) set Z_ 0.0 
$ns at 0.0 "$node_(268) off" 
$ns at 200.0 "$node_(268) on" 
$node_(269) set X_ 465 
$node_(269) set Y_ 467 
$node_(269) set Z_ 0.0 
$ns at 0.0 "$node_(269) off" 
$ns at 200.0 "$node_(269) on" 
$node_(270) set X_ 430 
$node_(270) set Y_ 885 
$node_(270) set Z_ 0.0 
$ns at 0.0 "$node_(270) off" 
$ns at 200.0 "$node_(270) on" 
$node_(271) set X_ 786 
$node_(271) set Y_ 884 
$node_(271) set Z_ 0.0 
$ns at 0.0 "$node_(271) off" 
$ns at 200.0 "$node_(271) on" 
$node_(272) set X_ 855 
$node_(272) set Y_ 573 
$node_(272) set Z_ 0.0 
$ns at 0.0 "$node_(272) off" 
$ns at 200.0 "$node_(272) on" 
$node_(273) set X_ 1093 
$node_(273) set Y_ 237 
$node_(273) set Z_ 0.0 
$ns at 0.0 "$node_(273) off" 
$ns at 200.0 "$node_(273) on" 
$node_(274) set X_ 165 
$node_(274) set Y_ 523 
$node_(274) set Z_ 0.0 
$ns at 0.0 "$node_(274) off" 
$ns at 200.0 "$node_(274) on" 
$node_(275) set X_ 654 
$node_(275) set Y_ 645 
$node_(275) set Z_ 0.0 
$ns at 0.0 "$node_(275) off" 
$ns at 200.0 "$node_(275) on" 
$node_(276) set X_ 1737 
$node_(276) set Y_ 975 
$node_(276) set Z_ 0.0 
$ns at 0.0 "$node_(276) off" 
$ns at 200.0 "$node_(276) on" 
$node_(277) set X_ 848 
$node_(277) set Y_ 678 
$node_(277) set Z_ 0.0 
$ns at 0.0 "$node_(277) off" 
$ns at 200.0 "$node_(277) on" 
$node_(278) set X_ 125 
$node_(278) set Y_ 685 
$node_(278) set Z_ 0.0 
$ns at 0.0 "$node_(278) off" 
$ns at 200.0 "$node_(278) on" 
$node_(279) set X_ 241 
$node_(279) set Y_ 935 
$node_(279) set Z_ 0.0 
$ns at 0.0 "$node_(279) off" 
$ns at 200.0 "$node_(279) on" 
$node_(280) set X_ 1871 
$node_(280) set Y_ 378 
$node_(280) set Z_ 0.0 
$ns at 0.0 "$node_(280) off" 
$ns at 200.0 "$node_(280) on" 
$node_(281) set X_ 642 
$node_(281) set Y_ 168 
$node_(281) set Z_ 0.0 
$ns at 0.0 "$node_(281) off" 
$ns at 200.0 "$node_(281) on" 
$node_(282) set X_ 545 
$node_(282) set Y_ 726 
$node_(282) set Z_ 0.0 
$ns at 0.0 "$node_(282) off" 
$ns at 200.0 "$node_(282) on" 
$node_(283) set X_ 1732 
$node_(283) set Y_ 75 
$node_(283) set Z_ 0.0 
$ns at 0.0 "$node_(283) off" 
$ns at 200.0 "$node_(283) on" 
$node_(284) set X_ 755 
$node_(284) set Y_ 197 
$node_(284) set Z_ 0.0 
$ns at 0.0 "$node_(284) off" 
$ns at 200.0 "$node_(284) on" 
$node_(285) set X_ 1019 
$node_(285) set Y_ 857 
$node_(285) set Z_ 0.0 
$ns at 0.0 "$node_(285) off" 
$ns at 200.0 "$node_(285) on" 
$node_(286) set X_ 1705 
$node_(286) set Y_ 734 
$node_(286) set Z_ 0.0 
$ns at 0.0 "$node_(286) off" 
$ns at 200.0 "$node_(286) on" 
$node_(287) set X_ 2248 
$node_(287) set Y_ 189 
$node_(287) set Z_ 0.0 
$ns at 0.0 "$node_(287) off" 
$ns at 200.0 "$node_(287) on" 
$node_(288) set X_ 2520 
$node_(288) set Y_ 51 
$node_(288) set Z_ 0.0 
$ns at 0.0 "$node_(288) off" 
$ns at 200.0 "$node_(288) on" 
$node_(289) set X_ 1982 
$node_(289) set Y_ 523 
$node_(289) set Z_ 0.0 
$ns at 0.0 "$node_(289) off" 
$ns at 200.0 "$node_(289) on" 
$node_(290) set X_ 2865 
$node_(290) set Y_ 245 
$node_(290) set Z_ 0.0 
$ns at 0.0 "$node_(290) off" 
$ns at 200.0 "$node_(290) on" 
$node_(291) set X_ 2877 
$node_(291) set Y_ 540 
$node_(291) set Z_ 0.0 
$ns at 0.0 "$node_(291) off" 
$ns at 200.0 "$node_(291) on" 
$node_(292) set X_ 444 
$node_(292) set Y_ 577 
$node_(292) set Z_ 0.0 
$ns at 0.0 "$node_(292) off" 
$ns at 200.0 "$node_(292) on" 
$node_(293) set X_ 2227 
$node_(293) set Y_ 121 
$node_(293) set Z_ 0.0 
$ns at 0.0 "$node_(293) off" 
$ns at 200.0 "$node_(293) on" 
$node_(294) set X_ 2719 
$node_(294) set Y_ 478 
$node_(294) set Z_ 0.0 
$ns at 0.0 "$node_(294) off" 
$ns at 200.0 "$node_(294) on" 
$node_(295) set X_ 574 
$node_(295) set Y_ 436 
$node_(295) set Z_ 0.0 
$ns at 0.0 "$node_(295) off" 
$ns at 200.0 "$node_(295) on" 
$node_(296) set X_ 1684 
$node_(296) set Y_ 319 
$node_(296) set Z_ 0.0 
$ns at 0.0 "$node_(296) off" 
$ns at 200.0 "$node_(296) on" 
$node_(297) set X_ 1666 
$node_(297) set Y_ 604 
$node_(297) set Z_ 0.0 
$ns at 0.0 "$node_(297) off" 
$ns at 200.0 "$node_(297) on" 
$node_(298) set X_ 1712 
$node_(298) set Y_ 2 
$node_(298) set Z_ 0.0 
$ns at 0.0 "$node_(298) off" 
$ns at 200.0 "$node_(298) on" 
$node_(299) set X_ 1727 
$node_(299) set Y_ 925 
$node_(299) set Z_ 0.0 
$ns at 0.0 "$node_(299) off" 
$ns at 200.0 "$node_(299) on" 
$node_(300) set X_ 1446 
$node_(300) set Y_ 206 
$node_(300) set Z_ 0.0 
$ns at 0.0 "$node_(300) off" 
$ns at 300.0 "$node_(300) on" 
$node_(301) set X_ 2909 
$node_(301) set Y_ 850 
$node_(301) set Z_ 0.0 
$ns at 0.0 "$node_(301) off" 
$ns at 300.0 "$node_(301) on" 
$node_(302) set X_ 1303 
$node_(302) set Y_ 973 
$node_(302) set Z_ 0.0 
$ns at 0.0 "$node_(302) off" 
$ns at 300.0 "$node_(302) on" 
$node_(303) set X_ 908 
$node_(303) set Y_ 719 
$node_(303) set Z_ 0.0 
$ns at 0.0 "$node_(303) off" 
$ns at 300.0 "$node_(303) on" 
$node_(304) set X_ 2561 
$node_(304) set Y_ 393 
$node_(304) set Z_ 0.0 
$ns at 0.0 "$node_(304) off" 
$ns at 300.0 "$node_(304) on" 
$node_(305) set X_ 2100 
$node_(305) set Y_ 768 
$node_(305) set Z_ 0.0 
$ns at 0.0 "$node_(305) off" 
$ns at 300.0 "$node_(305) on" 
$node_(306) set X_ 2033 
$node_(306) set Y_ 330 
$node_(306) set Z_ 0.0 
$ns at 0.0 "$node_(306) off" 
$ns at 300.0 "$node_(306) on" 
$node_(307) set X_ 1076 
$node_(307) set Y_ 76 
$node_(307) set Z_ 0.0 
$ns at 0.0 "$node_(307) off" 
$ns at 300.0 "$node_(307) on" 
$node_(308) set X_ 176 
$node_(308) set Y_ 482 
$node_(308) set Z_ 0.0 
$ns at 0.0 "$node_(308) off" 
$ns at 300.0 "$node_(308) on" 
$node_(309) set X_ 2258 
$node_(309) set Y_ 935 
$node_(309) set Z_ 0.0 
$ns at 0.0 "$node_(309) off" 
$ns at 300.0 "$node_(309) on" 
$node_(310) set X_ 2953 
$node_(310) set Y_ 610 
$node_(310) set Z_ 0.0 
$ns at 0.0 "$node_(310) off" 
$ns at 300.0 "$node_(310) on" 
$node_(311) set X_ 2281 
$node_(311) set Y_ 577 
$node_(311) set Z_ 0.0 
$ns at 0.0 "$node_(311) off" 
$ns at 300.0 "$node_(311) on" 
$node_(312) set X_ 2025 
$node_(312) set Y_ 395 
$node_(312) set Z_ 0.0 
$ns at 0.0 "$node_(312) off" 
$ns at 300.0 "$node_(312) on" 
$node_(313) set X_ 2024 
$node_(313) set Y_ 324 
$node_(313) set Z_ 0.0 
$ns at 0.0 "$node_(313) off" 
$ns at 300.0 "$node_(313) on" 
$node_(314) set X_ 2793 
$node_(314) set Y_ 258 
$node_(314) set Z_ 0.0 
$ns at 0.0 "$node_(314) off" 
$ns at 300.0 "$node_(314) on" 
$node_(315) set X_ 627 
$node_(315) set Y_ 13 
$node_(315) set Z_ 0.0 
$ns at 0.0 "$node_(315) off" 
$ns at 300.0 "$node_(315) on" 
$node_(316) set X_ 2496 
$node_(316) set Y_ 413 
$node_(316) set Z_ 0.0 
$ns at 0.0 "$node_(316) off" 
$ns at 300.0 "$node_(316) on" 
$node_(317) set X_ 479 
$node_(317) set Y_ 962 
$node_(317) set Z_ 0.0 
$ns at 0.0 "$node_(317) off" 
$ns at 300.0 "$node_(317) on" 
$node_(318) set X_ 926 
$node_(318) set Y_ 590 
$node_(318) set Z_ 0.0 
$ns at 0.0 "$node_(318) off" 
$ns at 300.0 "$node_(318) on" 
$node_(319) set X_ 1034 
$node_(319) set Y_ 848 
$node_(319) set Z_ 0.0 
$ns at 0.0 "$node_(319) off" 
$ns at 300.0 "$node_(319) on" 
$node_(320) set X_ 470 
$node_(320) set Y_ 156 
$node_(320) set Z_ 0.0 
$ns at 0.0 "$node_(320) off" 
$ns at 300.0 "$node_(320) on" 
$node_(321) set X_ 2415 
$node_(321) set Y_ 616 
$node_(321) set Z_ 0.0 
$ns at 0.0 "$node_(321) off" 
$ns at 300.0 "$node_(321) on" 
$node_(322) set X_ 2993 
$node_(322) set Y_ 794 
$node_(322) set Z_ 0.0 
$ns at 0.0 "$node_(322) off" 
$ns at 300.0 "$node_(322) on" 
$node_(323) set X_ 64 
$node_(323) set Y_ 940 
$node_(323) set Z_ 0.0 
$ns at 0.0 "$node_(323) off" 
$ns at 300.0 "$node_(323) on" 
$node_(324) set X_ 1620 
$node_(324) set Y_ 526 
$node_(324) set Z_ 0.0 
$ns at 0.0 "$node_(324) off" 
$ns at 300.0 "$node_(324) on" 
$node_(325) set X_ 230 
$node_(325) set Y_ 807 
$node_(325) set Z_ 0.0 
$ns at 0.0 "$node_(325) off" 
$ns at 300.0 "$node_(325) on" 
$node_(326) set X_ 759 
$node_(326) set Y_ 626 
$node_(326) set Z_ 0.0 
$ns at 0.0 "$node_(326) off" 
$ns at 300.0 "$node_(326) on" 
$node_(327) set X_ 852 
$node_(327) set Y_ 515 
$node_(327) set Z_ 0.0 
$ns at 0.0 "$node_(327) off" 
$ns at 300.0 "$node_(327) on" 
$node_(328) set X_ 664 
$node_(328) set Y_ 871 
$node_(328) set Z_ 0.0 
$ns at 0.0 "$node_(328) off" 
$ns at 300.0 "$node_(328) on" 
$node_(329) set X_ 2334 
$node_(329) set Y_ 771 
$node_(329) set Z_ 0.0 
$ns at 0.0 "$node_(329) off" 
$ns at 300.0 "$node_(329) on" 
$node_(330) set X_ 1561 
$node_(330) set Y_ 680 
$node_(330) set Z_ 0.0 
$ns at 0.0 "$node_(330) off" 
$ns at 300.0 "$node_(330) on" 
$node_(331) set X_ 2914 
$node_(331) set Y_ 558 
$node_(331) set Z_ 0.0 
$ns at 0.0 "$node_(331) off" 
$ns at 300.0 "$node_(331) on" 
$node_(332) set X_ 2772 
$node_(332) set Y_ 899 
$node_(332) set Z_ 0.0 
$ns at 0.0 "$node_(332) off" 
$ns at 300.0 "$node_(332) on" 
$node_(333) set X_ 1738 
$node_(333) set Y_ 168 
$node_(333) set Z_ 0.0 
$ns at 0.0 "$node_(333) off" 
$ns at 300.0 "$node_(333) on" 
$node_(334) set X_ 411 
$node_(334) set Y_ 389 
$node_(334) set Z_ 0.0 
$ns at 0.0 "$node_(334) off" 
$ns at 300.0 "$node_(334) on" 
$node_(335) set X_ 351 
$node_(335) set Y_ 113 
$node_(335) set Z_ 0.0 
$ns at 0.0 "$node_(335) off" 
$ns at 300.0 "$node_(335) on" 
$node_(336) set X_ 87 
$node_(336) set Y_ 117 
$node_(336) set Z_ 0.0 
$ns at 0.0 "$node_(336) off" 
$ns at 300.0 "$node_(336) on" 
$node_(337) set X_ 1199 
$node_(337) set Y_ 635 
$node_(337) set Z_ 0.0 
$ns at 0.0 "$node_(337) off" 
$ns at 300.0 "$node_(337) on" 
$node_(338) set X_ 1622 
$node_(338) set Y_ 147 
$node_(338) set Z_ 0.0 
$ns at 0.0 "$node_(338) off" 
$ns at 300.0 "$node_(338) on" 
$node_(339) set X_ 1740 
$node_(339) set Y_ 179 
$node_(339) set Z_ 0.0 
$ns at 0.0 "$node_(339) off" 
$ns at 300.0 "$node_(339) on" 
$node_(340) set X_ 93 
$node_(340) set Y_ 793 
$node_(340) set Z_ 0.0 
$ns at 0.0 "$node_(340) off" 
$ns at 300.0 "$node_(340) on" 
$node_(341) set X_ 2109 
$node_(341) set Y_ 520 
$node_(341) set Z_ 0.0 
$ns at 0.0 "$node_(341) off" 
$ns at 300.0 "$node_(341) on" 
$node_(342) set X_ 2523 
$node_(342) set Y_ 192 
$node_(342) set Z_ 0.0 
$ns at 0.0 "$node_(342) off" 
$ns at 300.0 "$node_(342) on" 
$node_(343) set X_ 1728 
$node_(343) set Y_ 171 
$node_(343) set Z_ 0.0 
$ns at 0.0 "$node_(343) off" 
$ns at 300.0 "$node_(343) on" 
$node_(344) set X_ 2271 
$node_(344) set Y_ 740 
$node_(344) set Z_ 0.0 
$ns at 0.0 "$node_(344) off" 
$ns at 300.0 "$node_(344) on" 
$node_(345) set X_ 2996 
$node_(345) set Y_ 367 
$node_(345) set Z_ 0.0 
$ns at 0.0 "$node_(345) off" 
$ns at 300.0 "$node_(345) on" 
$node_(346) set X_ 2625 
$node_(346) set Y_ 156 
$node_(346) set Z_ 0.0 
$ns at 0.0 "$node_(346) off" 
$ns at 300.0 "$node_(346) on" 
$node_(347) set X_ 120 
$node_(347) set Y_ 140 
$node_(347) set Z_ 0.0 
$ns at 0.0 "$node_(347) off" 
$ns at 300.0 "$node_(347) on" 
$node_(348) set X_ 286 
$node_(348) set Y_ 411 
$node_(348) set Z_ 0.0 
$ns at 0.0 "$node_(348) off" 
$ns at 300.0 "$node_(348) on" 
$node_(349) set X_ 316 
$node_(349) set Y_ 993 
$node_(349) set Z_ 0.0 
$ns at 0.0 "$node_(349) off" 
$ns at 300.0 "$node_(349) on" 
$node_(350) set X_ 303 
$node_(350) set Y_ 411 
$node_(350) set Z_ 0.0 
$ns at 0.0 "$node_(350) off" 
$ns at 300.0 "$node_(350) on" 
$node_(351) set X_ 2967 
$node_(351) set Y_ 223 
$node_(351) set Z_ 0.0 
$ns at 0.0 "$node_(351) off" 
$ns at 300.0 "$node_(351) on" 
$node_(352) set X_ 638 
$node_(352) set Y_ 101 
$node_(352) set Z_ 0.0 
$ns at 0.0 "$node_(352) off" 
$ns at 300.0 "$node_(352) on" 
$node_(353) set X_ 2923 
$node_(353) set Y_ 231 
$node_(353) set Z_ 0.0 
$ns at 0.0 "$node_(353) off" 
$ns at 300.0 "$node_(353) on" 
$node_(354) set X_ 2858 
$node_(354) set Y_ 624 
$node_(354) set Z_ 0.0 
$ns at 0.0 "$node_(354) off" 
$ns at 300.0 "$node_(354) on" 
$node_(355) set X_ 954 
$node_(355) set Y_ 19 
$node_(355) set Z_ 0.0 
$ns at 0.0 "$node_(355) off" 
$ns at 300.0 "$node_(355) on" 
$node_(356) set X_ 1518 
$node_(356) set Y_ 259 
$node_(356) set Z_ 0.0 
$ns at 0.0 "$node_(356) off" 
$ns at 300.0 "$node_(356) on" 
$node_(357) set X_ 371 
$node_(357) set Y_ 680 
$node_(357) set Z_ 0.0 
$ns at 0.0 "$node_(357) off" 
$ns at 300.0 "$node_(357) on" 
$node_(358) set X_ 1529 
$node_(358) set Y_ 145 
$node_(358) set Z_ 0.0 
$ns at 0.0 "$node_(358) off" 
$ns at 300.0 "$node_(358) on" 
$node_(359) set X_ 2103 
$node_(359) set Y_ 855 
$node_(359) set Z_ 0.0 
$ns at 0.0 "$node_(359) off" 
$ns at 300.0 "$node_(359) on" 
$node_(360) set X_ 2325 
$node_(360) set Y_ 185 
$node_(360) set Z_ 0.0 
$ns at 0.0 "$node_(360) off" 
$ns at 300.0 "$node_(360) on" 
$node_(361) set X_ 2964 
$node_(361) set Y_ 42 
$node_(361) set Z_ 0.0 
$ns at 0.0 "$node_(361) off" 
$ns at 300.0 "$node_(361) on" 
$node_(362) set X_ 1816 
$node_(362) set Y_ 142 
$node_(362) set Z_ 0.0 
$ns at 0.0 "$node_(362) off" 
$ns at 300.0 "$node_(362) on" 
$node_(363) set X_ 1566 
$node_(363) set Y_ 148 
$node_(363) set Z_ 0.0 
$ns at 0.0 "$node_(363) off" 
$ns at 300.0 "$node_(363) on" 
$node_(364) set X_ 1054 
$node_(364) set Y_ 629 
$node_(364) set Z_ 0.0 
$ns at 0.0 "$node_(364) off" 
$ns at 300.0 "$node_(364) on" 
$node_(365) set X_ 2181 
$node_(365) set Y_ 868 
$node_(365) set Z_ 0.0 
$ns at 0.0 "$node_(365) off" 
$ns at 300.0 "$node_(365) on" 
$node_(366) set X_ 2175 
$node_(366) set Y_ 613 
$node_(366) set Z_ 0.0 
$ns at 0.0 "$node_(366) off" 
$ns at 300.0 "$node_(366) on" 
$node_(367) set X_ 49 
$node_(367) set Y_ 312 
$node_(367) set Z_ 0.0 
$ns at 0.0 "$node_(367) off" 
$ns at 300.0 "$node_(367) on" 
$node_(368) set X_ 521 
$node_(368) set Y_ 72 
$node_(368) set Z_ 0.0 
$ns at 0.0 "$node_(368) off" 
$ns at 300.0 "$node_(368) on" 
$node_(369) set X_ 905 
$node_(369) set Y_ 807 
$node_(369) set Z_ 0.0 
$ns at 0.0 "$node_(369) off" 
$ns at 300.0 "$node_(369) on" 
$node_(370) set X_ 956 
$node_(370) set Y_ 678 
$node_(370) set Z_ 0.0 
$ns at 0.0 "$node_(370) off" 
$ns at 300.0 "$node_(370) on" 
$node_(371) set X_ 123 
$node_(371) set Y_ 933 
$node_(371) set Z_ 0.0 
$ns at 0.0 "$node_(371) off" 
$ns at 300.0 "$node_(371) on" 
$node_(372) set X_ 152 
$node_(372) set Y_ 689 
$node_(372) set Z_ 0.0 
$ns at 0.0 "$node_(372) off" 
$ns at 300.0 "$node_(372) on" 
$node_(373) set X_ 2589 
$node_(373) set Y_ 692 
$node_(373) set Z_ 0.0 
$ns at 0.0 "$node_(373) off" 
$ns at 300.0 "$node_(373) on" 
$node_(374) set X_ 1155 
$node_(374) set Y_ 792 
$node_(374) set Z_ 0.0 
$ns at 0.0 "$node_(374) off" 
$ns at 300.0 "$node_(374) on" 
$node_(375) set X_ 476 
$node_(375) set Y_ 150 
$node_(375) set Z_ 0.0 
$ns at 0.0 "$node_(375) off" 
$ns at 300.0 "$node_(375) on" 
$node_(376) set X_ 1781 
$node_(376) set Y_ 281 
$node_(376) set Z_ 0.0 
$ns at 0.0 "$node_(376) off" 
$ns at 300.0 "$node_(376) on" 
$node_(377) set X_ 2272 
$node_(377) set Y_ 25 
$node_(377) set Z_ 0.0 
$ns at 0.0 "$node_(377) off" 
$ns at 300.0 "$node_(377) on" 
$node_(378) set X_ 1315 
$node_(378) set Y_ 774 
$node_(378) set Z_ 0.0 
$ns at 0.0 "$node_(378) off" 
$ns at 300.0 "$node_(378) on" 
$node_(379) set X_ 2857 
$node_(379) set Y_ 468 
$node_(379) set Z_ 0.0 
$ns at 0.0 "$node_(379) off" 
$ns at 300.0 "$node_(379) on" 
$node_(380) set X_ 1691 
$node_(380) set Y_ 689 
$node_(380) set Z_ 0.0 
$ns at 0.0 "$node_(380) off" 
$ns at 300.0 "$node_(380) on" 
$node_(381) set X_ 2094 
$node_(381) set Y_ 723 
$node_(381) set Z_ 0.0 
$ns at 0.0 "$node_(381) off" 
$ns at 300.0 "$node_(381) on" 
$node_(382) set X_ 693 
$node_(382) set Y_ 793 
$node_(382) set Z_ 0.0 
$ns at 0.0 "$node_(382) off" 
$ns at 300.0 "$node_(382) on" 
$node_(383) set X_ 2257 
$node_(383) set Y_ 443 
$node_(383) set Z_ 0.0 
$ns at 0.0 "$node_(383) off" 
$ns at 300.0 "$node_(383) on" 
$node_(384) set X_ 1849 
$node_(384) set Y_ 460 
$node_(384) set Z_ 0.0 
$ns at 0.0 "$node_(384) off" 
$ns at 300.0 "$node_(384) on" 
$node_(385) set X_ 2711 
$node_(385) set Y_ 176 
$node_(385) set Z_ 0.0 
$ns at 0.0 "$node_(385) off" 
$ns at 300.0 "$node_(385) on" 
$node_(386) set X_ 2497 
$node_(386) set Y_ 720 
$node_(386) set Z_ 0.0 
$ns at 0.0 "$node_(386) off" 
$ns at 300.0 "$node_(386) on" 
$node_(387) set X_ 598 
$node_(387) set Y_ 957 
$node_(387) set Z_ 0.0 
$ns at 0.0 "$node_(387) off" 
$ns at 300.0 "$node_(387) on" 
$node_(388) set X_ 2057 
$node_(388) set Y_ 781 
$node_(388) set Z_ 0.0 
$ns at 0.0 "$node_(388) off" 
$ns at 300.0 "$node_(388) on" 
$node_(389) set X_ 764 
$node_(389) set Y_ 976 
$node_(389) set Z_ 0.0 
$ns at 0.0 "$node_(389) off" 
$ns at 300.0 "$node_(389) on" 
$node_(390) set X_ 2812 
$node_(390) set Y_ 468 
$node_(390) set Z_ 0.0 
$ns at 0.0 "$node_(390) off" 
$ns at 300.0 "$node_(390) on" 
$node_(391) set X_ 961 
$node_(391) set Y_ 38 
$node_(391) set Z_ 0.0 
$ns at 0.0 "$node_(391) off" 
$ns at 300.0 "$node_(391) on" 
$node_(392) set X_ 1478 
$node_(392) set Y_ 958 
$node_(392) set Z_ 0.0 
$ns at 0.0 "$node_(392) off" 
$ns at 300.0 "$node_(392) on" 
$node_(393) set X_ 2302 
$node_(393) set Y_ 878 
$node_(393) set Z_ 0.0 
$ns at 0.0 "$node_(393) off" 
$ns at 300.0 "$node_(393) on" 
$node_(394) set X_ 1538 
$node_(394) set Y_ 233 
$node_(394) set Z_ 0.0 
$ns at 0.0 "$node_(394) off" 
$ns at 300.0 "$node_(394) on" 
$node_(395) set X_ 119 
$node_(395) set Y_ 429 
$node_(395) set Z_ 0.0 
$ns at 0.0 "$node_(395) off" 
$ns at 300.0 "$node_(395) on" 
$node_(396) set X_ 2763 
$node_(396) set Y_ 951 
$node_(396) set Z_ 0.0 
$ns at 0.0 "$node_(396) off" 
$ns at 300.0 "$node_(396) on" 
$node_(397) set X_ 2819 
$node_(397) set Y_ 841 
$node_(397) set Z_ 0.0 
$ns at 0.0 "$node_(397) off" 
$ns at 300.0 "$node_(397) on" 
$node_(398) set X_ 441 
$node_(398) set Y_ 770 
$node_(398) set Z_ 0.0 
$ns at 0.0 "$node_(398) off" 
$ns at 300.0 "$node_(398) on" 
$node_(399) set X_ 919 
$node_(399) set Y_ 363 
$node_(399) set Z_ 0.0 
$ns at 0.0 "$node_(399) off" 
$ns at 300.0 "$node_(399) on" 
$node_(400) set X_ 733 
$node_(400) set Y_ 745 
$node_(400) set Z_ 0.0 
$ns at 0.0 "$node_(400) off" 
$ns at 400.0 "$node_(400) on" 
$node_(401) set X_ 2298 
$node_(401) set Y_ 221 
$node_(401) set Z_ 0.0 
$ns at 0.0 "$node_(401) off" 
$ns at 400.0 "$node_(401) on" 
$node_(402) set X_ 2140 
$node_(402) set Y_ 106 
$node_(402) set Z_ 0.0 
$ns at 0.0 "$node_(402) off" 
$ns at 400.0 "$node_(402) on" 
$node_(403) set X_ 780 
$node_(403) set Y_ 260 
$node_(403) set Z_ 0.0 
$ns at 0.0 "$node_(403) off" 
$ns at 400.0 "$node_(403) on" 
$node_(404) set X_ 1329 
$node_(404) set Y_ 564 
$node_(404) set Z_ 0.0 
$ns at 0.0 "$node_(404) off" 
$ns at 400.0 "$node_(404) on" 
$node_(405) set X_ 1413 
$node_(405) set Y_ 448 
$node_(405) set Z_ 0.0 
$ns at 0.0 "$node_(405) off" 
$ns at 400.0 "$node_(405) on" 
$node_(406) set X_ 646 
$node_(406) set Y_ 332 
$node_(406) set Z_ 0.0 
$ns at 0.0 "$node_(406) off" 
$ns at 400.0 "$node_(406) on" 
$node_(407) set X_ 334 
$node_(407) set Y_ 284 
$node_(407) set Z_ 0.0 
$ns at 0.0 "$node_(407) off" 
$ns at 400.0 "$node_(407) on" 
$node_(408) set X_ 308 
$node_(408) set Y_ 206 
$node_(408) set Z_ 0.0 
$ns at 0.0 "$node_(408) off" 
$ns at 400.0 "$node_(408) on" 
$node_(409) set X_ 809 
$node_(409) set Y_ 781 
$node_(409) set Z_ 0.0 
$ns at 0.0 "$node_(409) off" 
$ns at 400.0 "$node_(409) on" 
$node_(410) set X_ 2768 
$node_(410) set Y_ 360 
$node_(410) set Z_ 0.0 
$ns at 0.0 "$node_(410) off" 
$ns at 400.0 "$node_(410) on" 
$node_(411) set X_ 1992 
$node_(411) set Y_ 992 
$node_(411) set Z_ 0.0 
$ns at 0.0 "$node_(411) off" 
$ns at 400.0 "$node_(411) on" 
$node_(412) set X_ 1891 
$node_(412) set Y_ 22 
$node_(412) set Z_ 0.0 
$ns at 0.0 "$node_(412) off" 
$ns at 400.0 "$node_(412) on" 
$node_(413) set X_ 2085 
$node_(413) set Y_ 952 
$node_(413) set Z_ 0.0 
$ns at 0.0 "$node_(413) off" 
$ns at 400.0 "$node_(413) on" 
$node_(414) set X_ 485 
$node_(414) set Y_ 806 
$node_(414) set Z_ 0.0 
$ns at 0.0 "$node_(414) off" 
$ns at 400.0 "$node_(414) on" 
$node_(415) set X_ 1961 
$node_(415) set Y_ 511 
$node_(415) set Z_ 0.0 
$ns at 0.0 "$node_(415) off" 
$ns at 400.0 "$node_(415) on" 
$node_(416) set X_ 2323 
$node_(416) set Y_ 292 
$node_(416) set Z_ 0.0 
$ns at 0.0 "$node_(416) off" 
$ns at 400.0 "$node_(416) on" 
$node_(417) set X_ 911 
$node_(417) set Y_ 805 
$node_(417) set Z_ 0.0 
$ns at 0.0 "$node_(417) off" 
$ns at 400.0 "$node_(417) on" 
$node_(418) set X_ 1133 
$node_(418) set Y_ 377 
$node_(418) set Z_ 0.0 
$ns at 0.0 "$node_(418) off" 
$ns at 400.0 "$node_(418) on" 
$node_(419) set X_ 983 
$node_(419) set Y_ 958 
$node_(419) set Z_ 0.0 
$ns at 0.0 "$node_(419) off" 
$ns at 400.0 "$node_(419) on" 
$node_(420) set X_ 2073 
$node_(420) set Y_ 40 
$node_(420) set Z_ 0.0 
$ns at 0.0 "$node_(420) off" 
$ns at 400.0 "$node_(420) on" 
$node_(421) set X_ 2405 
$node_(421) set Y_ 242 
$node_(421) set Z_ 0.0 
$ns at 0.0 "$node_(421) off" 
$ns at 400.0 "$node_(421) on" 
$node_(422) set X_ 977 
$node_(422) set Y_ 421 
$node_(422) set Z_ 0.0 
$ns at 0.0 "$node_(422) off" 
$ns at 400.0 "$node_(422) on" 
$node_(423) set X_ 2839 
$node_(423) set Y_ 63 
$node_(423) set Z_ 0.0 
$ns at 0.0 "$node_(423) off" 
$ns at 400.0 "$node_(423) on" 
$node_(424) set X_ 127 
$node_(424) set Y_ 536 
$node_(424) set Z_ 0.0 
$ns at 0.0 "$node_(424) off" 
$ns at 400.0 "$node_(424) on" 
$node_(425) set X_ 2693 
$node_(425) set Y_ 72 
$node_(425) set Z_ 0.0 
$ns at 0.0 "$node_(425) off" 
$ns at 400.0 "$node_(425) on" 
$node_(426) set X_ 1532 
$node_(426) set Y_ 520 
$node_(426) set Z_ 0.0 
$ns at 0.0 "$node_(426) off" 
$ns at 400.0 "$node_(426) on" 
$node_(427) set X_ 373 
$node_(427) set Y_ 197 
$node_(427) set Z_ 0.0 
$ns at 0.0 "$node_(427) off" 
$ns at 400.0 "$node_(427) on" 
$node_(428) set X_ 2595 
$node_(428) set Y_ 25 
$node_(428) set Z_ 0.0 
$ns at 0.0 "$node_(428) off" 
$ns at 400.0 "$node_(428) on" 
$node_(429) set X_ 1295 
$node_(429) set Y_ 584 
$node_(429) set Z_ 0.0 
$ns at 0.0 "$node_(429) off" 
$ns at 400.0 "$node_(429) on" 
$node_(430) set X_ 698 
$node_(430) set Y_ 289 
$node_(430) set Z_ 0.0 
$ns at 0.0 "$node_(430) off" 
$ns at 400.0 "$node_(430) on" 
$node_(431) set X_ 585 
$node_(431) set Y_ 270 
$node_(431) set Z_ 0.0 
$ns at 0.0 "$node_(431) off" 
$ns at 400.0 "$node_(431) on" 
$node_(432) set X_ 595 
$node_(432) set Y_ 433 
$node_(432) set Z_ 0.0 
$ns at 0.0 "$node_(432) off" 
$ns at 400.0 "$node_(432) on" 
$node_(433) set X_ 1736 
$node_(433) set Y_ 934 
$node_(433) set Z_ 0.0 
$ns at 0.0 "$node_(433) off" 
$ns at 400.0 "$node_(433) on" 
$node_(434) set X_ 2569 
$node_(434) set Y_ 749 
$node_(434) set Z_ 0.0 
$ns at 0.0 "$node_(434) off" 
$ns at 400.0 "$node_(434) on" 
$node_(435) set X_ 58 
$node_(435) set Y_ 185 
$node_(435) set Z_ 0.0 
$ns at 0.0 "$node_(435) off" 
$ns at 400.0 "$node_(435) on" 
$node_(436) set X_ 2129 
$node_(436) set Y_ 82 
$node_(436) set Z_ 0.0 
$ns at 0.0 "$node_(436) off" 
$ns at 400.0 "$node_(436) on" 
$node_(437) set X_ 542 
$node_(437) set Y_ 680 
$node_(437) set Z_ 0.0 
$ns at 0.0 "$node_(437) off" 
$ns at 400.0 "$node_(437) on" 
$node_(438) set X_ 495 
$node_(438) set Y_ 950 
$node_(438) set Z_ 0.0 
$ns at 0.0 "$node_(438) off" 
$ns at 400.0 "$node_(438) on" 
$node_(439) set X_ 2745 
$node_(439) set Y_ 840 
$node_(439) set Z_ 0.0 
$ns at 0.0 "$node_(439) off" 
$ns at 400.0 "$node_(439) on" 
$node_(440) set X_ 2416 
$node_(440) set Y_ 684 
$node_(440) set Z_ 0.0 
$ns at 0.0 "$node_(440) off" 
$ns at 400.0 "$node_(440) on" 
$node_(441) set X_ 1523 
$node_(441) set Y_ 29 
$node_(441) set Z_ 0.0 
$ns at 0.0 "$node_(441) off" 
$ns at 400.0 "$node_(441) on" 
$node_(442) set X_ 2740 
$node_(442) set Y_ 715 
$node_(442) set Z_ 0.0 
$ns at 0.0 "$node_(442) off" 
$ns at 400.0 "$node_(442) on" 
$node_(443) set X_ 1904 
$node_(443) set Y_ 851 
$node_(443) set Z_ 0.0 
$ns at 0.0 "$node_(443) off" 
$ns at 400.0 "$node_(443) on" 
$node_(444) set X_ 2901 
$node_(444) set Y_ 120 
$node_(444) set Z_ 0.0 
$ns at 0.0 "$node_(444) off" 
$ns at 400.0 "$node_(444) on" 
$node_(445) set X_ 2986 
$node_(445) set Y_ 660 
$node_(445) set Z_ 0.0 
$ns at 0.0 "$node_(445) off" 
$ns at 400.0 "$node_(445) on" 
$node_(446) set X_ 2824 
$node_(446) set Y_ 653 
$node_(446) set Z_ 0.0 
$ns at 0.0 "$node_(446) off" 
$ns at 400.0 "$node_(446) on" 
$node_(447) set X_ 1700 
$node_(447) set Y_ 470 
$node_(447) set Z_ 0.0 
$ns at 0.0 "$node_(447) off" 
$ns at 400.0 "$node_(447) on" 
$node_(448) set X_ 888 
$node_(448) set Y_ 799 
$node_(448) set Z_ 0.0 
$ns at 0.0 "$node_(448) off" 
$ns at 400.0 "$node_(448) on" 
$node_(449) set X_ 2292 
$node_(449) set Y_ 170 
$node_(449) set Z_ 0.0 
$ns at 0.0 "$node_(449) off" 
$ns at 400.0 "$node_(449) on" 
$node_(450) set X_ 1394 
$node_(450) set Y_ 851 
$node_(450) set Z_ 0.0 
$ns at 0.0 "$node_(450) off" 
$ns at 400.0 "$node_(450) on" 
$node_(451) set X_ 1750 
$node_(451) set Y_ 407 
$node_(451) set Z_ 0.0 
$ns at 0.0 "$node_(451) off" 
$ns at 400.0 "$node_(451) on" 
$node_(452) set X_ 1543 
$node_(452) set Y_ 581 
$node_(452) set Z_ 0.0 
$ns at 0.0 "$node_(452) off" 
$ns at 400.0 "$node_(452) on" 
$node_(453) set X_ 2899 
$node_(453) set Y_ 499 
$node_(453) set Z_ 0.0 
$ns at 0.0 "$node_(453) off" 
$ns at 400.0 "$node_(453) on" 
$node_(454) set X_ 1204 
$node_(454) set Y_ 870 
$node_(454) set Z_ 0.0 
$ns at 0.0 "$node_(454) off" 
$ns at 400.0 "$node_(454) on" 
$node_(455) set X_ 643 
$node_(455) set Y_ 503 
$node_(455) set Z_ 0.0 
$ns at 0.0 "$node_(455) off" 
$ns at 400.0 "$node_(455) on" 
$node_(456) set X_ 2696 
$node_(456) set Y_ 571 
$node_(456) set Z_ 0.0 
$ns at 0.0 "$node_(456) off" 
$ns at 400.0 "$node_(456) on" 
$node_(457) set X_ 807 
$node_(457) set Y_ 910 
$node_(457) set Z_ 0.0 
$ns at 0.0 "$node_(457) off" 
$ns at 400.0 "$node_(457) on" 
$node_(458) set X_ 2561 
$node_(458) set Y_ 948 
$node_(458) set Z_ 0.0 
$ns at 0.0 "$node_(458) off" 
$ns at 400.0 "$node_(458) on" 
$node_(459) set X_ 215 
$node_(459) set Y_ 470 
$node_(459) set Z_ 0.0 
$ns at 0.0 "$node_(459) off" 
$ns at 400.0 "$node_(459) on" 
$node_(460) set X_ 2686 
$node_(460) set Y_ 275 
$node_(460) set Z_ 0.0 
$ns at 0.0 "$node_(460) off" 
$ns at 400.0 "$node_(460) on" 
$node_(461) set X_ 40 
$node_(461) set Y_ 351 
$node_(461) set Z_ 0.0 
$ns at 0.0 "$node_(461) off" 
$ns at 400.0 "$node_(461) on" 
$node_(462) set X_ 300 
$node_(462) set Y_ 560 
$node_(462) set Z_ 0.0 
$ns at 0.0 "$node_(462) off" 
$ns at 400.0 "$node_(462) on" 
$node_(463) set X_ 2097 
$node_(463) set Y_ 148 
$node_(463) set Z_ 0.0 
$ns at 0.0 "$node_(463) off" 
$ns at 400.0 "$node_(463) on" 
$node_(464) set X_ 1196 
$node_(464) set Y_ 904 
$node_(464) set Z_ 0.0 
$ns at 0.0 "$node_(464) off" 
$ns at 400.0 "$node_(464) on" 
$node_(465) set X_ 2580 
$node_(465) set Y_ 286 
$node_(465) set Z_ 0.0 
$ns at 0.0 "$node_(465) off" 
$ns at 400.0 "$node_(465) on" 
$node_(466) set X_ 2158 
$node_(466) set Y_ 717 
$node_(466) set Z_ 0.0 
$ns at 0.0 "$node_(466) off" 
$ns at 400.0 "$node_(466) on" 
$node_(467) set X_ 820 
$node_(467) set Y_ 991 
$node_(467) set Z_ 0.0 
$ns at 0.0 "$node_(467) off" 
$ns at 400.0 "$node_(467) on" 
$node_(468) set X_ 2801 
$node_(468) set Y_ 836 
$node_(468) set Z_ 0.0 
$ns at 0.0 "$node_(468) off" 
$ns at 400.0 "$node_(468) on" 
$node_(469) set X_ 2903 
$node_(469) set Y_ 324 
$node_(469) set Z_ 0.0 
$ns at 0.0 "$node_(469) off" 
$ns at 400.0 "$node_(469) on" 
$node_(470) set X_ 2117 
$node_(470) set Y_ 660 
$node_(470) set Z_ 0.0 
$ns at 0.0 "$node_(470) off" 
$ns at 400.0 "$node_(470) on" 
$node_(471) set X_ 2506 
$node_(471) set Y_ 738 
$node_(471) set Z_ 0.0 
$ns at 0.0 "$node_(471) off" 
$ns at 400.0 "$node_(471) on" 
$node_(472) set X_ 691 
$node_(472) set Y_ 513 
$node_(472) set Z_ 0.0 
$ns at 0.0 "$node_(472) off" 
$ns at 400.0 "$node_(472) on" 
$node_(473) set X_ 13 
$node_(473) set Y_ 234 
$node_(473) set Z_ 0.0 
$ns at 0.0 "$node_(473) off" 
$ns at 400.0 "$node_(473) on" 
$node_(474) set X_ 2057 
$node_(474) set Y_ 841 
$node_(474) set Z_ 0.0 
$ns at 0.0 "$node_(474) off" 
$ns at 400.0 "$node_(474) on" 
$node_(475) set X_ 2914 
$node_(475) set Y_ 477 
$node_(475) set Z_ 0.0 
$ns at 0.0 "$node_(475) off" 
$ns at 400.0 "$node_(475) on" 
$node_(476) set X_ 2785 
$node_(476) set Y_ 285 
$node_(476) set Z_ 0.0 
$ns at 0.0 "$node_(476) off" 
$ns at 400.0 "$node_(476) on" 
$node_(477) set X_ 1640 
$node_(477) set Y_ 167 
$node_(477) set Z_ 0.0 
$ns at 0.0 "$node_(477) off" 
$ns at 400.0 "$node_(477) on" 
$node_(478) set X_ 1824 
$node_(478) set Y_ 324 
$node_(478) set Z_ 0.0 
$ns at 0.0 "$node_(478) off" 
$ns at 400.0 "$node_(478) on" 
$node_(479) set X_ 379 
$node_(479) set Y_ 549 
$node_(479) set Z_ 0.0 
$ns at 0.0 "$node_(479) off" 
$ns at 400.0 "$node_(479) on" 
$node_(480) set X_ 1202 
$node_(480) set Y_ 979 
$node_(480) set Z_ 0.0 
$ns at 0.0 "$node_(480) off" 
$ns at 400.0 "$node_(480) on" 
$node_(481) set X_ 1982 
$node_(481) set Y_ 183 
$node_(481) set Z_ 0.0 
$ns at 0.0 "$node_(481) off" 
$ns at 400.0 "$node_(481) on" 
$node_(482) set X_ 1531 
$node_(482) set Y_ 20 
$node_(482) set Z_ 0.0 
$ns at 0.0 "$node_(482) off" 
$ns at 400.0 "$node_(482) on" 
$node_(483) set X_ 2910 
$node_(483) set Y_ 22 
$node_(483) set Z_ 0.0 
$ns at 0.0 "$node_(483) off" 
$ns at 400.0 "$node_(483) on" 
$node_(484) set X_ 2798 
$node_(484) set Y_ 206 
$node_(484) set Z_ 0.0 
$ns at 0.0 "$node_(484) off" 
$ns at 400.0 "$node_(484) on" 
$node_(485) set X_ 2173 
$node_(485) set Y_ 392 
$node_(485) set Z_ 0.0 
$ns at 0.0 "$node_(485) off" 
$ns at 400.0 "$node_(485) on" 
$node_(486) set X_ 697 
$node_(486) set Y_ 388 
$node_(486) set Z_ 0.0 
$ns at 0.0 "$node_(486) off" 
$ns at 400.0 "$node_(486) on" 
$node_(487) set X_ 1490 
$node_(487) set Y_ 663 
$node_(487) set Z_ 0.0 
$ns at 0.0 "$node_(487) off" 
$ns at 400.0 "$node_(487) on" 
$node_(488) set X_ 2240 
$node_(488) set Y_ 676 
$node_(488) set Z_ 0.0 
$ns at 0.0 "$node_(488) off" 
$ns at 400.0 "$node_(488) on" 
$node_(489) set X_ 2348 
$node_(489) set Y_ 322 
$node_(489) set Z_ 0.0 
$ns at 0.0 "$node_(489) off" 
$ns at 400.0 "$node_(489) on" 
$node_(490) set X_ 566 
$node_(490) set Y_ 495 
$node_(490) set Z_ 0.0 
$ns at 0.0 "$node_(490) off" 
$ns at 400.0 "$node_(490) on" 
$node_(491) set X_ 2331 
$node_(491) set Y_ 637 
$node_(491) set Z_ 0.0 
$ns at 0.0 "$node_(491) off" 
$ns at 400.0 "$node_(491) on" 
$node_(492) set X_ 1836 
$node_(492) set Y_ 43 
$node_(492) set Z_ 0.0 
$ns at 0.0 "$node_(492) off" 
$ns at 400.0 "$node_(492) on" 
$node_(493) set X_ 2986 
$node_(493) set Y_ 314 
$node_(493) set Z_ 0.0 
$ns at 0.0 "$node_(493) off" 
$ns at 400.0 "$node_(493) on" 
$node_(494) set X_ 1678 
$node_(494) set Y_ 588 
$node_(494) set Z_ 0.0 
$ns at 0.0 "$node_(494) off" 
$ns at 400.0 "$node_(494) on" 
$node_(495) set X_ 1642 
$node_(495) set Y_ 384 
$node_(495) set Z_ 0.0 
$ns at 0.0 "$node_(495) off" 
$ns at 400.0 "$node_(495) on" 
$node_(496) set X_ 67 
$node_(496) set Y_ 52 
$node_(496) set Z_ 0.0 
$ns at 0.0 "$node_(496) off" 
$ns at 400.0 "$node_(496) on" 
$node_(497) set X_ 2908 
$node_(497) set Y_ 48 
$node_(497) set Z_ 0.0 
$ns at 0.0 "$node_(497) off" 
$ns at 400.0 "$node_(497) on" 
$node_(498) set X_ 1552 
$node_(498) set Y_ 567 
$node_(498) set Z_ 0.0 
$ns at 0.0 "$node_(498) off" 
$ns at 400.0 "$node_(498) on" 
$node_(499) set X_ 160 
$node_(499) set Y_ 373 
$node_(499) set Z_ 0.0 
$ns at 0.0 "$node_(499) off" 
$ns at 400.0 "$node_(499) on" 
$node_(500) set X_ 564 
$node_(500) set Y_ 0 
$node_(500) set Z_ 0.0 
$ns at 0.0 "$node_(500) off" 
$ns at 500.0 "$node_(500) on" 
$node_(501) set X_ 104 
$node_(501) set Y_ 525 
$node_(501) set Z_ 0.0 
$ns at 0.0 "$node_(501) off" 
$ns at 500.0 "$node_(501) on" 
$node_(502) set X_ 1059 
$node_(502) set Y_ 5 
$node_(502) set Z_ 0.0 
$ns at 0.0 "$node_(502) off" 
$ns at 500.0 "$node_(502) on" 
$node_(503) set X_ 2487 
$node_(503) set Y_ 705 
$node_(503) set Z_ 0.0 
$ns at 0.0 "$node_(503) off" 
$ns at 500.0 "$node_(503) on" 
$node_(504) set X_ 962 
$node_(504) set Y_ 784 
$node_(504) set Z_ 0.0 
$ns at 0.0 "$node_(504) off" 
$ns at 500.0 "$node_(504) on" 
$node_(505) set X_ 2274 
$node_(505) set Y_ 82 
$node_(505) set Z_ 0.0 
$ns at 0.0 "$node_(505) off" 
$ns at 500.0 "$node_(505) on" 
$node_(506) set X_ 1832 
$node_(506) set Y_ 605 
$node_(506) set Z_ 0.0 
$ns at 0.0 "$node_(506) off" 
$ns at 500.0 "$node_(506) on" 
$node_(507) set X_ 1006 
$node_(507) set Y_ 757 
$node_(507) set Z_ 0.0 
$ns at 0.0 "$node_(507) off" 
$ns at 500.0 "$node_(507) on" 
$node_(508) set X_ 2881 
$node_(508) set Y_ 63 
$node_(508) set Z_ 0.0 
$ns at 0.0 "$node_(508) off" 
$ns at 500.0 "$node_(508) on" 
$node_(509) set X_ 751 
$node_(509) set Y_ 286 
$node_(509) set Z_ 0.0 
$ns at 0.0 "$node_(509) off" 
$ns at 500.0 "$node_(509) on" 
$node_(510) set X_ 1792 
$node_(510) set Y_ 252 
$node_(510) set Z_ 0.0 
$ns at 0.0 "$node_(510) off" 
$ns at 500.0 "$node_(510) on" 
$node_(511) set X_ 1903 
$node_(511) set Y_ 330 
$node_(511) set Z_ 0.0 
$ns at 0.0 "$node_(511) off" 
$ns at 500.0 "$node_(511) on" 
$node_(512) set X_ 970 
$node_(512) set Y_ 285 
$node_(512) set Z_ 0.0 
$ns at 0.0 "$node_(512) off" 
$ns at 500.0 "$node_(512) on" 
$node_(513) set X_ 191 
$node_(513) set Y_ 768 
$node_(513) set Z_ 0.0 
$ns at 0.0 "$node_(513) off" 
$ns at 500.0 "$node_(513) on" 
$node_(514) set X_ 2639 
$node_(514) set Y_ 36 
$node_(514) set Z_ 0.0 
$ns at 0.0 "$node_(514) off" 
$ns at 500.0 "$node_(514) on" 
$node_(515) set X_ 1571 
$node_(515) set Y_ 17 
$node_(515) set Z_ 0.0 
$ns at 0.0 "$node_(515) off" 
$ns at 500.0 "$node_(515) on" 
$node_(516) set X_ 2743 
$node_(516) set Y_ 627 
$node_(516) set Z_ 0.0 
$ns at 0.0 "$node_(516) off" 
$ns at 500.0 "$node_(516) on" 
$node_(517) set X_ 2199 
$node_(517) set Y_ 352 
$node_(517) set Z_ 0.0 
$ns at 0.0 "$node_(517) off" 
$ns at 500.0 "$node_(517) on" 
$node_(518) set X_ 1906 
$node_(518) set Y_ 903 
$node_(518) set Z_ 0.0 
$ns at 0.0 "$node_(518) off" 
$ns at 500.0 "$node_(518) on" 
$node_(519) set X_ 2431 
$node_(519) set Y_ 733 
$node_(519) set Z_ 0.0 
$ns at 0.0 "$node_(519) off" 
$ns at 500.0 "$node_(519) on" 
$node_(520) set X_ 2666 
$node_(520) set Y_ 81 
$node_(520) set Z_ 0.0 
$ns at 0.0 "$node_(520) off" 
$ns at 500.0 "$node_(520) on" 
$node_(521) set X_ 782 
$node_(521) set Y_ 43 
$node_(521) set Z_ 0.0 
$ns at 0.0 "$node_(521) off" 
$ns at 500.0 "$node_(521) on" 
$node_(522) set X_ 2888 
$node_(522) set Y_ 828 
$node_(522) set Z_ 0.0 
$ns at 0.0 "$node_(522) off" 
$ns at 500.0 "$node_(522) on" 
$node_(523) set X_ 1932 
$node_(523) set Y_ 620 
$node_(523) set Z_ 0.0 
$ns at 0.0 "$node_(523) off" 
$ns at 500.0 "$node_(523) on" 
$node_(524) set X_ 2721 
$node_(524) set Y_ 246 
$node_(524) set Z_ 0.0 
$ns at 0.0 "$node_(524) off" 
$ns at 500.0 "$node_(524) on" 
$node_(525) set X_ 291 
$node_(525) set Y_ 716 
$node_(525) set Z_ 0.0 
$ns at 0.0 "$node_(525) off" 
$ns at 500.0 "$node_(525) on" 
$node_(526) set X_ 1566 
$node_(526) set Y_ 650 
$node_(526) set Z_ 0.0 
$ns at 0.0 "$node_(526) off" 
$ns at 500.0 "$node_(526) on" 
$node_(527) set X_ 274 
$node_(527) set Y_ 789 
$node_(527) set Z_ 0.0 
$ns at 0.0 "$node_(527) off" 
$ns at 500.0 "$node_(527) on" 
$node_(528) set X_ 1394 
$node_(528) set Y_ 553 
$node_(528) set Z_ 0.0 
$ns at 0.0 "$node_(528) off" 
$ns at 500.0 "$node_(528) on" 
$node_(529) set X_ 1236 
$node_(529) set Y_ 586 
$node_(529) set Z_ 0.0 
$ns at 0.0 "$node_(529) off" 
$ns at 500.0 "$node_(529) on" 
$node_(530) set X_ 348 
$node_(530) set Y_ 963 
$node_(530) set Z_ 0.0 
$ns at 0.0 "$node_(530) off" 
$ns at 500.0 "$node_(530) on" 
$node_(531) set X_ 1124 
$node_(531) set Y_ 599 
$node_(531) set Z_ 0.0 
$ns at 0.0 "$node_(531) off" 
$ns at 500.0 "$node_(531) on" 
$node_(532) set X_ 2817 
$node_(532) set Y_ 987 
$node_(532) set Z_ 0.0 
$ns at 0.0 "$node_(532) off" 
$ns at 500.0 "$node_(532) on" 
$node_(533) set X_ 2157 
$node_(533) set Y_ 786 
$node_(533) set Z_ 0.0 
$ns at 0.0 "$node_(533) off" 
$ns at 500.0 "$node_(533) on" 
$node_(534) set X_ 228 
$node_(534) set Y_ 713 
$node_(534) set Z_ 0.0 
$ns at 0.0 "$node_(534) off" 
$ns at 500.0 "$node_(534) on" 
$node_(535) set X_ 1349 
$node_(535) set Y_ 434 
$node_(535) set Z_ 0.0 
$ns at 0.0 "$node_(535) off" 
$ns at 500.0 "$node_(535) on" 
$node_(536) set X_ 2519 
$node_(536) set Y_ 534 
$node_(536) set Z_ 0.0 
$ns at 0.0 "$node_(536) off" 
$ns at 500.0 "$node_(536) on" 
$node_(537) set X_ 418 
$node_(537) set Y_ 642 
$node_(537) set Z_ 0.0 
$ns at 0.0 "$node_(537) off" 
$ns at 500.0 "$node_(537) on" 
$node_(538) set X_ 1686 
$node_(538) set Y_ 392 
$node_(538) set Z_ 0.0 
$ns at 0.0 "$node_(538) off" 
$ns at 500.0 "$node_(538) on" 
$node_(539) set X_ 2544 
$node_(539) set Y_ 186 
$node_(539) set Z_ 0.0 
$ns at 0.0 "$node_(539) off" 
$ns at 500.0 "$node_(539) on" 
$node_(540) set X_ 13 
$node_(540) set Y_ 904 
$node_(540) set Z_ 0.0 
$ns at 0.0 "$node_(540) off" 
$ns at 500.0 "$node_(540) on" 
$node_(541) set X_ 2606 
$node_(541) set Y_ 478 
$node_(541) set Z_ 0.0 
$ns at 0.0 "$node_(541) off" 
$ns at 500.0 "$node_(541) on" 
$node_(542) set X_ 440 
$node_(542) set Y_ 974 
$node_(542) set Z_ 0.0 
$ns at 0.0 "$node_(542) off" 
$ns at 500.0 "$node_(542) on" 
$node_(543) set X_ 2898 
$node_(543) set Y_ 893 
$node_(543) set Z_ 0.0 
$ns at 0.0 "$node_(543) off" 
$ns at 500.0 "$node_(543) on" 
$node_(544) set X_ 2165 
$node_(544) set Y_ 280 
$node_(544) set Z_ 0.0 
$ns at 0.0 "$node_(544) off" 
$ns at 500.0 "$node_(544) on" 
$node_(545) set X_ 1921 
$node_(545) set Y_ 19 
$node_(545) set Z_ 0.0 
$ns at 0.0 "$node_(545) off" 
$ns at 500.0 "$node_(545) on" 
$node_(546) set X_ 875 
$node_(546) set Y_ 985 
$node_(546) set Z_ 0.0 
$ns at 0.0 "$node_(546) off" 
$ns at 500.0 "$node_(546) on" 
$node_(547) set X_ 647 
$node_(547) set Y_ 251 
$node_(547) set Z_ 0.0 
$ns at 0.0 "$node_(547) off" 
$ns at 500.0 "$node_(547) on" 
$node_(548) set X_ 80 
$node_(548) set Y_ 122 
$node_(548) set Z_ 0.0 
$ns at 0.0 "$node_(548) off" 
$ns at 500.0 "$node_(548) on" 
$node_(549) set X_ 708 
$node_(549) set Y_ 746 
$node_(549) set Z_ 0.0 
$ns at 0.0 "$node_(549) off" 
$ns at 500.0 "$node_(549) on" 
$node_(550) set X_ 1745 
$node_(550) set Y_ 359 
$node_(550) set Z_ 0.0 
$ns at 0.0 "$node_(550) off" 
$ns at 500.0 "$node_(550) on" 
$node_(551) set X_ 2166 
$node_(551) set Y_ 947 
$node_(551) set Z_ 0.0 
$ns at 0.0 "$node_(551) off" 
$ns at 500.0 "$node_(551) on" 
$node_(552) set X_ 1954 
$node_(552) set Y_ 294 
$node_(552) set Z_ 0.0 
$ns at 0.0 "$node_(552) off" 
$ns at 500.0 "$node_(552) on" 
$node_(553) set X_ 1049 
$node_(553) set Y_ 763 
$node_(553) set Z_ 0.0 
$ns at 0.0 "$node_(553) off" 
$ns at 500.0 "$node_(553) on" 
$node_(554) set X_ 2482 
$node_(554) set Y_ 964 
$node_(554) set Z_ 0.0 
$ns at 0.0 "$node_(554) off" 
$ns at 500.0 "$node_(554) on" 
$node_(555) set X_ 1465 
$node_(555) set Y_ 28 
$node_(555) set Z_ 0.0 
$ns at 0.0 "$node_(555) off" 
$ns at 500.0 "$node_(555) on" 
$node_(556) set X_ 1120 
$node_(556) set Y_ 31 
$node_(556) set Z_ 0.0 
$ns at 0.0 "$node_(556) off" 
$ns at 500.0 "$node_(556) on" 
$node_(557) set X_ 1051 
$node_(557) set Y_ 29 
$node_(557) set Z_ 0.0 
$ns at 0.0 "$node_(557) off" 
$ns at 500.0 "$node_(557) on" 
$node_(558) set X_ 1214 
$node_(558) set Y_ 953 
$node_(558) set Z_ 0.0 
$ns at 0.0 "$node_(558) off" 
$ns at 500.0 "$node_(558) on" 
$node_(559) set X_ 623 
$node_(559) set Y_ 757 
$node_(559) set Z_ 0.0 
$ns at 0.0 "$node_(559) off" 
$ns at 500.0 "$node_(559) on" 
$node_(560) set X_ 2239 
$node_(560) set Y_ 520 
$node_(560) set Z_ 0.0 
$ns at 0.0 "$node_(560) off" 
$ns at 500.0 "$node_(560) on" 
$node_(561) set X_ 2237 
$node_(561) set Y_ 13 
$node_(561) set Z_ 0.0 
$ns at 0.0 "$node_(561) off" 
$ns at 500.0 "$node_(561) on" 
$node_(562) set X_ 1317 
$node_(562) set Y_ 327 
$node_(562) set Z_ 0.0 
$ns at 0.0 "$node_(562) off" 
$ns at 500.0 "$node_(562) on" 
$node_(563) set X_ 428 
$node_(563) set Y_ 660 
$node_(563) set Z_ 0.0 
$ns at 0.0 "$node_(563) off" 
$ns at 500.0 "$node_(563) on" 
$node_(564) set X_ 1365 
$node_(564) set Y_ 106 
$node_(564) set Z_ 0.0 
$ns at 0.0 "$node_(564) off" 
$ns at 500.0 "$node_(564) on" 
$node_(565) set X_ 1195 
$node_(565) set Y_ 129 
$node_(565) set Z_ 0.0 
$ns at 0.0 "$node_(565) off" 
$ns at 500.0 "$node_(565) on" 
$node_(566) set X_ 2101 
$node_(566) set Y_ 357 
$node_(566) set Z_ 0.0 
$ns at 0.0 "$node_(566) off" 
$ns at 500.0 "$node_(566) on" 
$node_(567) set X_ 2260 
$node_(567) set Y_ 738 
$node_(567) set Z_ 0.0 
$ns at 0.0 "$node_(567) off" 
$ns at 500.0 "$node_(567) on" 
$node_(568) set X_ 2335 
$node_(568) set Y_ 401 
$node_(568) set Z_ 0.0 
$ns at 0.0 "$node_(568) off" 
$ns at 500.0 "$node_(568) on" 
$node_(569) set X_ 2393 
$node_(569) set Y_ 520 
$node_(569) set Z_ 0.0 
$ns at 0.0 "$node_(569) off" 
$ns at 500.0 "$node_(569) on" 
$node_(570) set X_ 964 
$node_(570) set Y_ 762 
$node_(570) set Z_ 0.0 
$ns at 0.0 "$node_(570) off" 
$ns at 500.0 "$node_(570) on" 
$node_(571) set X_ 2993 
$node_(571) set Y_ 27 
$node_(571) set Z_ 0.0 
$ns at 0.0 "$node_(571) off" 
$ns at 500.0 "$node_(571) on" 
$node_(572) set X_ 2714 
$node_(572) set Y_ 820 
$node_(572) set Z_ 0.0 
$ns at 0.0 "$node_(572) off" 
$ns at 500.0 "$node_(572) on" 
$node_(573) set X_ 2794 
$node_(573) set Y_ 13 
$node_(573) set Z_ 0.0 
$ns at 0.0 "$node_(573) off" 
$ns at 500.0 "$node_(573) on" 
$node_(574) set X_ 2113 
$node_(574) set Y_ 780 
$node_(574) set Z_ 0.0 
$ns at 0.0 "$node_(574) off" 
$ns at 500.0 "$node_(574) on" 
$node_(575) set X_ 1432 
$node_(575) set Y_ 983 
$node_(575) set Z_ 0.0 
$ns at 0.0 "$node_(575) off" 
$ns at 500.0 "$node_(575) on" 
$node_(576) set X_ 243 
$node_(576) set Y_ 293 
$node_(576) set Z_ 0.0 
$ns at 0.0 "$node_(576) off" 
$ns at 500.0 "$node_(576) on" 
$node_(577) set X_ 1692 
$node_(577) set Y_ 357 
$node_(577) set Z_ 0.0 
$ns at 0.0 "$node_(577) off" 
$ns at 500.0 "$node_(577) on" 
$node_(578) set X_ 675 
$node_(578) set Y_ 542 
$node_(578) set Z_ 0.0 
$ns at 0.0 "$node_(578) off" 
$ns at 500.0 "$node_(578) on" 
$node_(579) set X_ 2584 
$node_(579) set Y_ 387 
$node_(579) set Z_ 0.0 
$ns at 0.0 "$node_(579) off" 
$ns at 500.0 "$node_(579) on" 
$node_(580) set X_ 2521 
$node_(580) set Y_ 194 
$node_(580) set Z_ 0.0 
$ns at 0.0 "$node_(580) off" 
$ns at 500.0 "$node_(580) on" 
$node_(581) set X_ 2913 
$node_(581) set Y_ 38 
$node_(581) set Z_ 0.0 
$ns at 0.0 "$node_(581) off" 
$ns at 500.0 "$node_(581) on" 
$node_(582) set X_ 1809 
$node_(582) set Y_ 371 
$node_(582) set Z_ 0.0 
$ns at 0.0 "$node_(582) off" 
$ns at 500.0 "$node_(582) on" 
$node_(583) set X_ 765 
$node_(583) set Y_ 736 
$node_(583) set Z_ 0.0 
$ns at 0.0 "$node_(583) off" 
$ns at 500.0 "$node_(583) on" 
$node_(584) set X_ 2372 
$node_(584) set Y_ 748 
$node_(584) set Z_ 0.0 
$ns at 0.0 "$node_(584) off" 
$ns at 500.0 "$node_(584) on" 
$node_(585) set X_ 1285 
$node_(585) set Y_ 292 
$node_(585) set Z_ 0.0 
$ns at 0.0 "$node_(585) off" 
$ns at 500.0 "$node_(585) on" 
$node_(586) set X_ 138 
$node_(586) set Y_ 920 
$node_(586) set Z_ 0.0 
$ns at 0.0 "$node_(586) off" 
$ns at 500.0 "$node_(586) on" 
$node_(587) set X_ 1341 
$node_(587) set Y_ 314 
$node_(587) set Z_ 0.0 
$ns at 0.0 "$node_(587) off" 
$ns at 500.0 "$node_(587) on" 
$node_(588) set X_ 2126 
$node_(588) set Y_ 436 
$node_(588) set Z_ 0.0 
$ns at 0.0 "$node_(588) off" 
$ns at 500.0 "$node_(588) on" 
$node_(589) set X_ 26 
$node_(589) set Y_ 108 
$node_(589) set Z_ 0.0 
$ns at 0.0 "$node_(589) off" 
$ns at 500.0 "$node_(589) on" 
$node_(590) set X_ 1611 
$node_(590) set Y_ 288 
$node_(590) set Z_ 0.0 
$ns at 0.0 "$node_(590) off" 
$ns at 500.0 "$node_(590) on" 
$node_(591) set X_ 621 
$node_(591) set Y_ 419 
$node_(591) set Z_ 0.0 
$ns at 0.0 "$node_(591) off" 
$ns at 500.0 "$node_(591) on" 
$node_(592) set X_ 2759 
$node_(592) set Y_ 163 
$node_(592) set Z_ 0.0 
$ns at 0.0 "$node_(592) off" 
$ns at 500.0 "$node_(592) on" 
$node_(593) set X_ 1456 
$node_(593) set Y_ 344 
$node_(593) set Z_ 0.0 
$ns at 0.0 "$node_(593) off" 
$ns at 500.0 "$node_(593) on" 
$node_(594) set X_ 2616 
$node_(594) set Y_ 500 
$node_(594) set Z_ 0.0 
$ns at 0.0 "$node_(594) off" 
$ns at 500.0 "$node_(594) on" 
$node_(595) set X_ 175 
$node_(595) set Y_ 433 
$node_(595) set Z_ 0.0 
$ns at 0.0 "$node_(595) off" 
$ns at 500.0 "$node_(595) on" 
$node_(596) set X_ 635 
$node_(596) set Y_ 216 
$node_(596) set Z_ 0.0 
$ns at 0.0 "$node_(596) off" 
$ns at 500.0 "$node_(596) on" 
$node_(597) set X_ 1191 
$node_(597) set Y_ 251 
$node_(597) set Z_ 0.0 
$ns at 0.0 "$node_(597) off" 
$ns at 500.0 "$node_(597) on" 
$node_(598) set X_ 946 
$node_(598) set Y_ 8 
$node_(598) set Z_ 0.0 
$ns at 0.0 "$node_(598) off" 
$ns at 500.0 "$node_(598) on" 
$node_(599) set X_ 621 
$node_(599) set Y_ 707 
$node_(599) set Z_ 0.0 
$ns at 0.0 "$node_(599) off" 
$ns at 500.0 "$node_(599) on" 
$node_(600) set X_ 2281 
$node_(600) set Y_ 282 
$node_(600) set Z_ 0.0 
$ns at 0.0 "$node_(600) off" 
$ns at 600.0 "$node_(600) on" 
$node_(601) set X_ 1703 
$node_(601) set Y_ 13 
$node_(601) set Z_ 0.0 
$ns at 0.0 "$node_(601) off" 
$ns at 600.0 "$node_(601) on" 
$node_(602) set X_ 2956 
$node_(602) set Y_ 104 
$node_(602) set Z_ 0.0 
$ns at 0.0 "$node_(602) off" 
$ns at 600.0 "$node_(602) on" 
$node_(603) set X_ 1634 
$node_(603) set Y_ 462 
$node_(603) set Z_ 0.0 
$ns at 0.0 "$node_(603) off" 
$ns at 600.0 "$node_(603) on" 
$node_(604) set X_ 2444 
$node_(604) set Y_ 36 
$node_(604) set Z_ 0.0 
$ns at 0.0 "$node_(604) off" 
$ns at 600.0 "$node_(604) on" 
$node_(605) set X_ 1921 
$node_(605) set Y_ 124 
$node_(605) set Z_ 0.0 
$ns at 0.0 "$node_(605) off" 
$ns at 600.0 "$node_(605) on" 
$node_(606) set X_ 999 
$node_(606) set Y_ 375 
$node_(606) set Z_ 0.0 
$ns at 0.0 "$node_(606) off" 
$ns at 600.0 "$node_(606) on" 
$node_(607) set X_ 2728 
$node_(607) set Y_ 158 
$node_(607) set Z_ 0.0 
$ns at 0.0 "$node_(607) off" 
$ns at 600.0 "$node_(607) on" 
$node_(608) set X_ 366 
$node_(608) set Y_ 76 
$node_(608) set Z_ 0.0 
$ns at 0.0 "$node_(608) off" 
$ns at 600.0 "$node_(608) on" 
$node_(609) set X_ 1259 
$node_(609) set Y_ 683 
$node_(609) set Z_ 0.0 
$ns at 0.0 "$node_(609) off" 
$ns at 600.0 "$node_(609) on" 
$node_(610) set X_ 974 
$node_(610) set Y_ 626 
$node_(610) set Z_ 0.0 
$ns at 0.0 "$node_(610) off" 
$ns at 600.0 "$node_(610) on" 
$node_(611) set X_ 74 
$node_(611) set Y_ 53 
$node_(611) set Z_ 0.0 
$ns at 0.0 "$node_(611) off" 
$ns at 600.0 "$node_(611) on" 
$node_(612) set X_ 1011 
$node_(612) set Y_ 224 
$node_(612) set Z_ 0.0 
$ns at 0.0 "$node_(612) off" 
$ns at 600.0 "$node_(612) on" 
$node_(613) set X_ 227 
$node_(613) set Y_ 946 
$node_(613) set Z_ 0.0 
$ns at 0.0 "$node_(613) off" 
$ns at 600.0 "$node_(613) on" 
$node_(614) set X_ 596 
$node_(614) set Y_ 879 
$node_(614) set Z_ 0.0 
$ns at 0.0 "$node_(614) off" 
$ns at 600.0 "$node_(614) on" 
$node_(615) set X_ 2384 
$node_(615) set Y_ 888 
$node_(615) set Z_ 0.0 
$ns at 0.0 "$node_(615) off" 
$ns at 600.0 "$node_(615) on" 
$node_(616) set X_ 2699 
$node_(616) set Y_ 467 
$node_(616) set Z_ 0.0 
$ns at 0.0 "$node_(616) off" 
$ns at 600.0 "$node_(616) on" 
$node_(617) set X_ 1540 
$node_(617) set Y_ 706 
$node_(617) set Z_ 0.0 
$ns at 0.0 "$node_(617) off" 
$ns at 600.0 "$node_(617) on" 
$node_(618) set X_ 2701 
$node_(618) set Y_ 373 
$node_(618) set Z_ 0.0 
$ns at 0.0 "$node_(618) off" 
$ns at 600.0 "$node_(618) on" 
$node_(619) set X_ 2644 
$node_(619) set Y_ 929 
$node_(619) set Z_ 0.0 
$ns at 0.0 "$node_(619) off" 
$ns at 600.0 "$node_(619) on" 
$node_(620) set X_ 369 
$node_(620) set Y_ 40 
$node_(620) set Z_ 0.0 
$ns at 0.0 "$node_(620) off" 
$ns at 600.0 "$node_(620) on" 
$node_(621) set X_ 1350 
$node_(621) set Y_ 351 
$node_(621) set Z_ 0.0 
$ns at 0.0 "$node_(621) off" 
$ns at 600.0 "$node_(621) on" 
$node_(622) set X_ 1702 
$node_(622) set Y_ 685 
$node_(622) set Z_ 0.0 
$ns at 0.0 "$node_(622) off" 
$ns at 600.0 "$node_(622) on" 
$node_(623) set X_ 2213 
$node_(623) set Y_ 800 
$node_(623) set Z_ 0.0 
$ns at 0.0 "$node_(623) off" 
$ns at 600.0 "$node_(623) on" 
$node_(624) set X_ 1425 
$node_(624) set Y_ 440 
$node_(624) set Z_ 0.0 
$ns at 0.0 "$node_(624) off" 
$ns at 600.0 "$node_(624) on" 
$node_(625) set X_ 36 
$node_(625) set Y_ 658 
$node_(625) set Z_ 0.0 
$ns at 0.0 "$node_(625) off" 
$ns at 600.0 "$node_(625) on" 
$node_(626) set X_ 2012 
$node_(626) set Y_ 393 
$node_(626) set Z_ 0.0 
$ns at 0.0 "$node_(626) off" 
$ns at 600.0 "$node_(626) on" 
$node_(627) set X_ 1577 
$node_(627) set Y_ 830 
$node_(627) set Z_ 0.0 
$ns at 0.0 "$node_(627) off" 
$ns at 600.0 "$node_(627) on" 
$node_(628) set X_ 893 
$node_(628) set Y_ 387 
$node_(628) set Z_ 0.0 
$ns at 0.0 "$node_(628) off" 
$ns at 600.0 "$node_(628) on" 
$node_(629) set X_ 2676 
$node_(629) set Y_ 676 
$node_(629) set Z_ 0.0 
$ns at 0.0 "$node_(629) off" 
$ns at 600.0 "$node_(629) on" 
$node_(630) set X_ 2044 
$node_(630) set Y_ 892 
$node_(630) set Z_ 0.0 
$ns at 0.0 "$node_(630) off" 
$ns at 600.0 "$node_(630) on" 
$node_(631) set X_ 1776 
$node_(631) set Y_ 865 
$node_(631) set Z_ 0.0 
$ns at 0.0 "$node_(631) off" 
$ns at 600.0 "$node_(631) on" 
$node_(632) set X_ 1346 
$node_(632) set Y_ 990 
$node_(632) set Z_ 0.0 
$ns at 0.0 "$node_(632) off" 
$ns at 600.0 "$node_(632) on" 
$node_(633) set X_ 1124 
$node_(633) set Y_ 270 
$node_(633) set Z_ 0.0 
$ns at 0.0 "$node_(633) off" 
$ns at 600.0 "$node_(633) on" 
$node_(634) set X_ 1116 
$node_(634) set Y_ 295 
$node_(634) set Z_ 0.0 
$ns at 0.0 "$node_(634) off" 
$ns at 600.0 "$node_(634) on" 
$node_(635) set X_ 1287 
$node_(635) set Y_ 751 
$node_(635) set Z_ 0.0 
$ns at 0.0 "$node_(635) off" 
$ns at 600.0 "$node_(635) on" 
$node_(636) set X_ 1809 
$node_(636) set Y_ 649 
$node_(636) set Z_ 0.0 
$ns at 0.0 "$node_(636) off" 
$ns at 600.0 "$node_(636) on" 
$node_(637) set X_ 2334 
$node_(637) set Y_ 161 
$node_(637) set Z_ 0.0 
$ns at 0.0 "$node_(637) off" 
$ns at 600.0 "$node_(637) on" 
$node_(638) set X_ 352 
$node_(638) set Y_ 532 
$node_(638) set Z_ 0.0 
$ns at 0.0 "$node_(638) off" 
$ns at 600.0 "$node_(638) on" 
$node_(639) set X_ 887 
$node_(639) set Y_ 950 
$node_(639) set Z_ 0.0 
$ns at 0.0 "$node_(639) off" 
$ns at 600.0 "$node_(639) on" 
$node_(640) set X_ 618 
$node_(640) set Y_ 459 
$node_(640) set Z_ 0.0 
$ns at 0.0 "$node_(640) off" 
$ns at 600.0 "$node_(640) on" 
$node_(641) set X_ 328 
$node_(641) set Y_ 539 
$node_(641) set Z_ 0.0 
$ns at 0.0 "$node_(641) off" 
$ns at 600.0 "$node_(641) on" 
$node_(642) set X_ 2425 
$node_(642) set Y_ 57 
$node_(642) set Z_ 0.0 
$ns at 0.0 "$node_(642) off" 
$ns at 600.0 "$node_(642) on" 
$node_(643) set X_ 2777 
$node_(643) set Y_ 989 
$node_(643) set Z_ 0.0 
$ns at 0.0 "$node_(643) off" 
$ns at 600.0 "$node_(643) on" 
$node_(644) set X_ 944 
$node_(644) set Y_ 133 
$node_(644) set Z_ 0.0 
$ns at 0.0 "$node_(644) off" 
$ns at 600.0 "$node_(644) on" 
$node_(645) set X_ 2980 
$node_(645) set Y_ 591 
$node_(645) set Z_ 0.0 
$ns at 0.0 "$node_(645) off" 
$ns at 600.0 "$node_(645) on" 
$node_(646) set X_ 723 
$node_(646) set Y_ 809 
$node_(646) set Z_ 0.0 
$ns at 0.0 "$node_(646) off" 
$ns at 600.0 "$node_(646) on" 
$node_(647) set X_ 2989 
$node_(647) set Y_ 703 
$node_(647) set Z_ 0.0 
$ns at 0.0 "$node_(647) off" 
$ns at 600.0 "$node_(647) on" 
$node_(648) set X_ 2440 
$node_(648) set Y_ 717 
$node_(648) set Z_ 0.0 
$ns at 0.0 "$node_(648) off" 
$ns at 600.0 "$node_(648) on" 
$node_(649) set X_ 496 
$node_(649) set Y_ 513 
$node_(649) set Z_ 0.0 
$ns at 0.0 "$node_(649) off" 
$ns at 600.0 "$node_(649) on" 
$node_(650) set X_ 287 
$node_(650) set Y_ 314 
$node_(650) set Z_ 0.0 
$ns at 0.0 "$node_(650) off" 
$ns at 600.0 "$node_(650) on" 
$node_(651) set X_ 858 
$node_(651) set Y_ 483 
$node_(651) set Z_ 0.0 
$ns at 0.0 "$node_(651) off" 
$ns at 600.0 "$node_(651) on" 
$node_(652) set X_ 2235 
$node_(652) set Y_ 621 
$node_(652) set Z_ 0.0 
$ns at 0.0 "$node_(652) off" 
$ns at 600.0 "$node_(652) on" 
$node_(653) set X_ 259 
$node_(653) set Y_ 852 
$node_(653) set Z_ 0.0 
$ns at 0.0 "$node_(653) off" 
$ns at 600.0 "$node_(653) on" 
$node_(654) set X_ 2605 
$node_(654) set Y_ 75 
$node_(654) set Z_ 0.0 
$ns at 0.0 "$node_(654) off" 
$ns at 600.0 "$node_(654) on" 
$node_(655) set X_ 2086 
$node_(655) set Y_ 978 
$node_(655) set Z_ 0.0 
$ns at 0.0 "$node_(655) off" 
$ns at 600.0 "$node_(655) on" 
$node_(656) set X_ 2239 
$node_(656) set Y_ 717 
$node_(656) set Z_ 0.0 
$ns at 0.0 "$node_(656) off" 
$ns at 600.0 "$node_(656) on" 
$node_(657) set X_ 1428 
$node_(657) set Y_ 247 
$node_(657) set Z_ 0.0 
$ns at 0.0 "$node_(657) off" 
$ns at 600.0 "$node_(657) on" 
$node_(658) set X_ 1098 
$node_(658) set Y_ 649 
$node_(658) set Z_ 0.0 
$ns at 0.0 "$node_(658) off" 
$ns at 600.0 "$node_(658) on" 
$node_(659) set X_ 1672 
$node_(659) set Y_ 962 
$node_(659) set Z_ 0.0 
$ns at 0.0 "$node_(659) off" 
$ns at 600.0 "$node_(659) on" 
$node_(660) set X_ 2467 
$node_(660) set Y_ 549 
$node_(660) set Z_ 0.0 
$ns at 0.0 "$node_(660) off" 
$ns at 600.0 "$node_(660) on" 
$node_(661) set X_ 2457 
$node_(661) set Y_ 915 
$node_(661) set Z_ 0.0 
$ns at 0.0 "$node_(661) off" 
$ns at 600.0 "$node_(661) on" 
$node_(662) set X_ 1904 
$node_(662) set Y_ 46 
$node_(662) set Z_ 0.0 
$ns at 0.0 "$node_(662) off" 
$ns at 600.0 "$node_(662) on" 
$node_(663) set X_ 2737 
$node_(663) set Y_ 325 
$node_(663) set Z_ 0.0 
$ns at 0.0 "$node_(663) off" 
$ns at 600.0 "$node_(663) on" 
$node_(664) set X_ 2856 
$node_(664) set Y_ 907 
$node_(664) set Z_ 0.0 
$ns at 0.0 "$node_(664) off" 
$ns at 600.0 "$node_(664) on" 
$node_(665) set X_ 425 
$node_(665) set Y_ 444 
$node_(665) set Z_ 0.0 
$ns at 0.0 "$node_(665) off" 
$ns at 600.0 "$node_(665) on" 
$node_(666) set X_ 1277 
$node_(666) set Y_ 358 
$node_(666) set Z_ 0.0 
$ns at 0.0 "$node_(666) off" 
$ns at 600.0 "$node_(666) on" 
$node_(667) set X_ 2027 
$node_(667) set Y_ 391 
$node_(667) set Z_ 0.0 
$ns at 0.0 "$node_(667) off" 
$ns at 600.0 "$node_(667) on" 
$node_(668) set X_ 777 
$node_(668) set Y_ 285 
$node_(668) set Z_ 0.0 
$ns at 0.0 "$node_(668) off" 
$ns at 600.0 "$node_(668) on" 
$node_(669) set X_ 1834 
$node_(669) set Y_ 750 
$node_(669) set Z_ 0.0 
$ns at 0.0 "$node_(669) off" 
$ns at 600.0 "$node_(669) on" 
$node_(670) set X_ 1711 
$node_(670) set Y_ 750 
$node_(670) set Z_ 0.0 
$ns at 0.0 "$node_(670) off" 
$ns at 600.0 "$node_(670) on" 
$node_(671) set X_ 2606 
$node_(671) set Y_ 20 
$node_(671) set Z_ 0.0 
$ns at 0.0 "$node_(671) off" 
$ns at 600.0 "$node_(671) on" 
$node_(672) set X_ 2225 
$node_(672) set Y_ 9 
$node_(672) set Z_ 0.0 
$ns at 0.0 "$node_(672) off" 
$ns at 600.0 "$node_(672) on" 
$node_(673) set X_ 2278 
$node_(673) set Y_ 261 
$node_(673) set Z_ 0.0 
$ns at 0.0 "$node_(673) off" 
$ns at 600.0 "$node_(673) on" 
$node_(674) set X_ 2617 
$node_(674) set Y_ 213 
$node_(674) set Z_ 0.0 
$ns at 0.0 "$node_(674) off" 
$ns at 600.0 "$node_(674) on" 
$node_(675) set X_ 1038 
$node_(675) set Y_ 211 
$node_(675) set Z_ 0.0 
$ns at 0.0 "$node_(675) off" 
$ns at 600.0 "$node_(675) on" 
$node_(676) set X_ 2385 
$node_(676) set Y_ 28 
$node_(676) set Z_ 0.0 
$ns at 0.0 "$node_(676) off" 
$ns at 600.0 "$node_(676) on" 
$node_(677) set X_ 1137 
$node_(677) set Y_ 663 
$node_(677) set Z_ 0.0 
$ns at 0.0 "$node_(677) off" 
$ns at 600.0 "$node_(677) on" 
$node_(678) set X_ 1146 
$node_(678) set Y_ 724 
$node_(678) set Z_ 0.0 
$ns at 0.0 "$node_(678) off" 
$ns at 600.0 "$node_(678) on" 
$node_(679) set X_ 2067 
$node_(679) set Y_ 146 
$node_(679) set Z_ 0.0 
$ns at 0.0 "$node_(679) off" 
$ns at 600.0 "$node_(679) on" 
$node_(680) set X_ 46 
$node_(680) set Y_ 663 
$node_(680) set Z_ 0.0 
$ns at 0.0 "$node_(680) off" 
$ns at 600.0 "$node_(680) on" 
$node_(681) set X_ 1187 
$node_(681) set Y_ 803 
$node_(681) set Z_ 0.0 
$ns at 0.0 "$node_(681) off" 
$ns at 600.0 "$node_(681) on" 
$node_(682) set X_ 505 
$node_(682) set Y_ 708 
$node_(682) set Z_ 0.0 
$ns at 0.0 "$node_(682) off" 
$ns at 600.0 "$node_(682) on" 
$node_(683) set X_ 579 
$node_(683) set Y_ 895 
$node_(683) set Z_ 0.0 
$ns at 0.0 "$node_(683) off" 
$ns at 600.0 "$node_(683) on" 
$node_(684) set X_ 81 
$node_(684) set Y_ 817 
$node_(684) set Z_ 0.0 
$ns at 0.0 "$node_(684) off" 
$ns at 600.0 "$node_(684) on" 
$node_(685) set X_ 802 
$node_(685) set Y_ 558 
$node_(685) set Z_ 0.0 
$ns at 0.0 "$node_(685) off" 
$ns at 600.0 "$node_(685) on" 
$node_(686) set X_ 2833 
$node_(686) set Y_ 940 
$node_(686) set Z_ 0.0 
$ns at 0.0 "$node_(686) off" 
$ns at 600.0 "$node_(686) on" 
$node_(687) set X_ 377 
$node_(687) set Y_ 235 
$node_(687) set Z_ 0.0 
$ns at 0.0 "$node_(687) off" 
$ns at 600.0 "$node_(687) on" 
$node_(688) set X_ 954 
$node_(688) set Y_ 425 
$node_(688) set Z_ 0.0 
$ns at 0.0 "$node_(688) off" 
$ns at 600.0 "$node_(688) on" 
$node_(689) set X_ 2118 
$node_(689) set Y_ 780 
$node_(689) set Z_ 0.0 
$ns at 0.0 "$node_(689) off" 
$ns at 600.0 "$node_(689) on" 
$node_(690) set X_ 516 
$node_(690) set Y_ 296 
$node_(690) set Z_ 0.0 
$ns at 0.0 "$node_(690) off" 
$ns at 600.0 "$node_(690) on" 
$node_(691) set X_ 2041 
$node_(691) set Y_ 290 
$node_(691) set Z_ 0.0 
$ns at 0.0 "$node_(691) off" 
$ns at 600.0 "$node_(691) on" 
$node_(692) set X_ 962 
$node_(692) set Y_ 157 
$node_(692) set Z_ 0.0 
$ns at 0.0 "$node_(692) off" 
$ns at 600.0 "$node_(692) on" 
$node_(693) set X_ 2340 
$node_(693) set Y_ 623 
$node_(693) set Z_ 0.0 
$ns at 0.0 "$node_(693) off" 
$ns at 600.0 "$node_(693) on" 
$node_(694) set X_ 1485 
$node_(694) set Y_ 974 
$node_(694) set Z_ 0.0 
$ns at 0.0 "$node_(694) off" 
$ns at 600.0 "$node_(694) on" 
$node_(695) set X_ 901 
$node_(695) set Y_ 948 
$node_(695) set Z_ 0.0 
$ns at 0.0 "$node_(695) off" 
$ns at 600.0 "$node_(695) on" 
$node_(696) set X_ 693 
$node_(696) set Y_ 644 
$node_(696) set Z_ 0.0 
$ns at 0.0 "$node_(696) off" 
$ns at 600.0 "$node_(696) on" 
$node_(697) set X_ 2085 
$node_(697) set Y_ 850 
$node_(697) set Z_ 0.0 
$ns at 0.0 "$node_(697) off" 
$ns at 600.0 "$node_(697) on" 
$node_(698) set X_ 1876 
$node_(698) set Y_ 111 
$node_(698) set Z_ 0.0 
$ns at 0.0 "$node_(698) off" 
$ns at 600.0 "$node_(698) on" 
$node_(699) set X_ 904 
$node_(699) set Y_ 265 
$node_(699) set Z_ 0.0 
$ns at 0.0 "$node_(699) off" 
$ns at 600.0 "$node_(699) on" 
$node_(700) set X_ 902 
$node_(700) set Y_ 755 
$node_(700) set Z_ 0.0 
$ns at 0.0 "$node_(700) off" 
$ns at 700.0 "$node_(700) on" 
$node_(701) set X_ 2400 
$node_(701) set Y_ 950 
$node_(701) set Z_ 0.0 
$ns at 0.0 "$node_(701) off" 
$ns at 700.0 "$node_(701) on" 
$node_(702) set X_ 118 
$node_(702) set Y_ 909 
$node_(702) set Z_ 0.0 
$ns at 0.0 "$node_(702) off" 
$ns at 700.0 "$node_(702) on" 
$node_(703) set X_ 2896 
$node_(703) set Y_ 312 
$node_(703) set Z_ 0.0 
$ns at 0.0 "$node_(703) off" 
$ns at 700.0 "$node_(703) on" 
$node_(704) set X_ 1773 
$node_(704) set Y_ 684 
$node_(704) set Z_ 0.0 
$ns at 0.0 "$node_(704) off" 
$ns at 700.0 "$node_(704) on" 
$node_(705) set X_ 1879 
$node_(705) set Y_ 135 
$node_(705) set Z_ 0.0 
$ns at 0.0 "$node_(705) off" 
$ns at 700.0 "$node_(705) on" 
$node_(706) set X_ 295 
$node_(706) set Y_ 686 
$node_(706) set Z_ 0.0 
$ns at 0.0 "$node_(706) off" 
$ns at 700.0 "$node_(706) on" 
$node_(707) set X_ 1607 
$node_(707) set Y_ 165 
$node_(707) set Z_ 0.0 
$ns at 0.0 "$node_(707) off" 
$ns at 700.0 "$node_(707) on" 
$node_(708) set X_ 1283 
$node_(708) set Y_ 869 
$node_(708) set Z_ 0.0 
$ns at 0.0 "$node_(708) off" 
$ns at 700.0 "$node_(708) on" 
$node_(709) set X_ 20 
$node_(709) set Y_ 571 
$node_(709) set Z_ 0.0 
$ns at 0.0 "$node_(709) off" 
$ns at 700.0 "$node_(709) on" 
$node_(710) set X_ 1381 
$node_(710) set Y_ 484 
$node_(710) set Z_ 0.0 
$ns at 0.0 "$node_(710) off" 
$ns at 700.0 "$node_(710) on" 
$node_(711) set X_ 2352 
$node_(711) set Y_ 10 
$node_(711) set Z_ 0.0 
$ns at 0.0 "$node_(711) off" 
$ns at 700.0 "$node_(711) on" 
$node_(712) set X_ 133 
$node_(712) set Y_ 23 
$node_(712) set Z_ 0.0 
$ns at 0.0 "$node_(712) off" 
$ns at 700.0 "$node_(712) on" 
$node_(713) set X_ 1719 
$node_(713) set Y_ 404 
$node_(713) set Z_ 0.0 
$ns at 0.0 "$node_(713) off" 
$ns at 700.0 "$node_(713) on" 
$node_(714) set X_ 2671 
$node_(714) set Y_ 145 
$node_(714) set Z_ 0.0 
$ns at 0.0 "$node_(714) off" 
$ns at 700.0 "$node_(714) on" 
$node_(715) set X_ 239 
$node_(715) set Y_ 556 
$node_(715) set Z_ 0.0 
$ns at 0.0 "$node_(715) off" 
$ns at 700.0 "$node_(715) on" 
$node_(716) set X_ 460 
$node_(716) set Y_ 775 
$node_(716) set Z_ 0.0 
$ns at 0.0 "$node_(716) off" 
$ns at 700.0 "$node_(716) on" 
$node_(717) set X_ 566 
$node_(717) set Y_ 425 
$node_(717) set Z_ 0.0 
$ns at 0.0 "$node_(717) off" 
$ns at 700.0 "$node_(717) on" 
$node_(718) set X_ 2512 
$node_(718) set Y_ 973 
$node_(718) set Z_ 0.0 
$ns at 0.0 "$node_(718) off" 
$ns at 700.0 "$node_(718) on" 
$node_(719) set X_ 400 
$node_(719) set Y_ 218 
$node_(719) set Z_ 0.0 
$ns at 0.0 "$node_(719) off" 
$ns at 700.0 "$node_(719) on" 
$node_(720) set X_ 1294 
$node_(720) set Y_ 713 
$node_(720) set Z_ 0.0 
$ns at 0.0 "$node_(720) off" 
$ns at 700.0 "$node_(720) on" 
$node_(721) set X_ 339 
$node_(721) set Y_ 450 
$node_(721) set Z_ 0.0 
$ns at 0.0 "$node_(721) off" 
$ns at 700.0 "$node_(721) on" 
$node_(722) set X_ 1169 
$node_(722) set Y_ 403 
$node_(722) set Z_ 0.0 
$ns at 0.0 "$node_(722) off" 
$ns at 700.0 "$node_(722) on" 
$node_(723) set X_ 2532 
$node_(723) set Y_ 781 
$node_(723) set Z_ 0.0 
$ns at 0.0 "$node_(723) off" 
$ns at 700.0 "$node_(723) on" 
$node_(724) set X_ 478 
$node_(724) set Y_ 838 
$node_(724) set Z_ 0.0 
$ns at 0.0 "$node_(724) off" 
$ns at 700.0 "$node_(724) on" 
$node_(725) set X_ 2844 
$node_(725) set Y_ 752 
$node_(725) set Z_ 0.0 
$ns at 0.0 "$node_(725) off" 
$ns at 700.0 "$node_(725) on" 
$node_(726) set X_ 1411 
$node_(726) set Y_ 306 
$node_(726) set Z_ 0.0 
$ns at 0.0 "$node_(726) off" 
$ns at 700.0 "$node_(726) on" 
$node_(727) set X_ 2768 
$node_(727) set Y_ 493 
$node_(727) set Z_ 0.0 
$ns at 0.0 "$node_(727) off" 
$ns at 700.0 "$node_(727) on" 
$node_(728) set X_ 1512 
$node_(728) set Y_ 695 
$node_(728) set Z_ 0.0 
$ns at 0.0 "$node_(728) off" 
$ns at 700.0 "$node_(728) on" 
$node_(729) set X_ 2013 
$node_(729) set Y_ 123 
$node_(729) set Z_ 0.0 
$ns at 0.0 "$node_(729) off" 
$ns at 700.0 "$node_(729) on" 
$node_(730) set X_ 1167 
$node_(730) set Y_ 832 
$node_(730) set Z_ 0.0 
$ns at 0.0 "$node_(730) off" 
$ns at 700.0 "$node_(730) on" 
$node_(731) set X_ 660 
$node_(731) set Y_ 807 
$node_(731) set Z_ 0.0 
$ns at 0.0 "$node_(731) off" 
$ns at 700.0 "$node_(731) on" 
$node_(732) set X_ 537 
$node_(732) set Y_ 708 
$node_(732) set Z_ 0.0 
$ns at 0.0 "$node_(732) off" 
$ns at 700.0 "$node_(732) on" 
$node_(733) set X_ 904 
$node_(733) set Y_ 405 
$node_(733) set Z_ 0.0 
$ns at 0.0 "$node_(733) off" 
$ns at 700.0 "$node_(733) on" 
$node_(734) set X_ 335 
$node_(734) set Y_ 929 
$node_(734) set Z_ 0.0 
$ns at 0.0 "$node_(734) off" 
$ns at 700.0 "$node_(734) on" 
$node_(735) set X_ 2801 
$node_(735) set Y_ 212 
$node_(735) set Z_ 0.0 
$ns at 0.0 "$node_(735) off" 
$ns at 700.0 "$node_(735) on" 
$node_(736) set X_ 1427 
$node_(736) set Y_ 487 
$node_(736) set Z_ 0.0 
$ns at 0.0 "$node_(736) off" 
$ns at 700.0 "$node_(736) on" 
$node_(737) set X_ 10 
$node_(737) set Y_ 554 
$node_(737) set Z_ 0.0 
$ns at 0.0 "$node_(737) off" 
$ns at 700.0 "$node_(737) on" 
$node_(738) set X_ 2578 
$node_(738) set Y_ 936 
$node_(738) set Z_ 0.0 
$ns at 0.0 "$node_(738) off" 
$ns at 700.0 "$node_(738) on" 
$node_(739) set X_ 355 
$node_(739) set Y_ 880 
$node_(739) set Z_ 0.0 
$ns at 0.0 "$node_(739) off" 
$ns at 700.0 "$node_(739) on" 
$node_(740) set X_ 2697 
$node_(740) set Y_ 121 
$node_(740) set Z_ 0.0 
$ns at 0.0 "$node_(740) off" 
$ns at 700.0 "$node_(740) on" 
$node_(741) set X_ 2027 
$node_(741) set Y_ 599 
$node_(741) set Z_ 0.0 
$ns at 0.0 "$node_(741) off" 
$ns at 700.0 "$node_(741) on" 
$node_(742) set X_ 2715 
$node_(742) set Y_ 901 
$node_(742) set Z_ 0.0 
$ns at 0.0 "$node_(742) off" 
$ns at 700.0 "$node_(742) on" 
$node_(743) set X_ 540 
$node_(743) set Y_ 65 
$node_(743) set Z_ 0.0 
$ns at 0.0 "$node_(743) off" 
$ns at 700.0 "$node_(743) on" 
$node_(744) set X_ 2702 
$node_(744) set Y_ 732 
$node_(744) set Z_ 0.0 
$ns at 0.0 "$node_(744) off" 
$ns at 700.0 "$node_(744) on" 
$node_(745) set X_ 984 
$node_(745) set Y_ 45 
$node_(745) set Z_ 0.0 
$ns at 0.0 "$node_(745) off" 
$ns at 700.0 "$node_(745) on" 
$node_(746) set X_ 2031 
$node_(746) set Y_ 502 
$node_(746) set Z_ 0.0 
$ns at 0.0 "$node_(746) off" 
$ns at 700.0 "$node_(746) on" 
$node_(747) set X_ 822 
$node_(747) set Y_ 479 
$node_(747) set Z_ 0.0 
$ns at 0.0 "$node_(747) off" 
$ns at 700.0 "$node_(747) on" 
$node_(748) set X_ 1332 
$node_(748) set Y_ 813 
$node_(748) set Z_ 0.0 
$ns at 0.0 "$node_(748) off" 
$ns at 700.0 "$node_(748) on" 
$node_(749) set X_ 2390 
$node_(749) set Y_ 578 
$node_(749) set Z_ 0.0 
$ns at 0.0 "$node_(749) off" 
$ns at 700.0 "$node_(749) on" 
$node_(750) set X_ 1596 
$node_(750) set Y_ 731 
$node_(750) set Z_ 0.0 
$ns at 0.0 "$node_(750) off" 
$ns at 700.0 "$node_(750) on" 
$node_(751) set X_ 2359 
$node_(751) set Y_ 93 
$node_(751) set Z_ 0.0 
$ns at 0.0 "$node_(751) off" 
$ns at 700.0 "$node_(751) on" 
$node_(752) set X_ 1170 
$node_(752) set Y_ 106 
$node_(752) set Z_ 0.0 
$ns at 0.0 "$node_(752) off" 
$ns at 700.0 "$node_(752) on" 
$node_(753) set X_ 1795 
$node_(753) set Y_ 140 
$node_(753) set Z_ 0.0 
$ns at 0.0 "$node_(753) off" 
$ns at 700.0 "$node_(753) on" 
$node_(754) set X_ 2444 
$node_(754) set Y_ 737 
$node_(754) set Z_ 0.0 
$ns at 0.0 "$node_(754) off" 
$ns at 700.0 "$node_(754) on" 
$node_(755) set X_ 971 
$node_(755) set Y_ 68 
$node_(755) set Z_ 0.0 
$ns at 0.0 "$node_(755) off" 
$ns at 700.0 "$node_(755) on" 
$node_(756) set X_ 2835 
$node_(756) set Y_ 55 
$node_(756) set Z_ 0.0 
$ns at 0.0 "$node_(756) off" 
$ns at 700.0 "$node_(756) on" 
$node_(757) set X_ 2921 
$node_(757) set Y_ 709 
$node_(757) set Z_ 0.0 
$ns at 0.0 "$node_(757) off" 
$ns at 700.0 "$node_(757) on" 
$node_(758) set X_ 191 
$node_(758) set Y_ 450 
$node_(758) set Z_ 0.0 
$ns at 0.0 "$node_(758) off" 
$ns at 700.0 "$node_(758) on" 
$node_(759) set X_ 2658 
$node_(759) set Y_ 782 
$node_(759) set Z_ 0.0 
$ns at 0.0 "$node_(759) off" 
$ns at 700.0 "$node_(759) on" 
$node_(760) set X_ 1963 
$node_(760) set Y_ 94 
$node_(760) set Z_ 0.0 
$ns at 0.0 "$node_(760) off" 
$ns at 700.0 "$node_(760) on" 
$node_(761) set X_ 1266 
$node_(761) set Y_ 370 
$node_(761) set Z_ 0.0 
$ns at 0.0 "$node_(761) off" 
$ns at 700.0 "$node_(761) on" 
$node_(762) set X_ 1443 
$node_(762) set Y_ 908 
$node_(762) set Z_ 0.0 
$ns at 0.0 "$node_(762) off" 
$ns at 700.0 "$node_(762) on" 
$node_(763) set X_ 451 
$node_(763) set Y_ 151 
$node_(763) set Z_ 0.0 
$ns at 0.0 "$node_(763) off" 
$ns at 700.0 "$node_(763) on" 
$node_(764) set X_ 2057 
$node_(764) set Y_ 293 
$node_(764) set Z_ 0.0 
$ns at 0.0 "$node_(764) off" 
$ns at 700.0 "$node_(764) on" 
$node_(765) set X_ 833 
$node_(765) set Y_ 504 
$node_(765) set Z_ 0.0 
$ns at 0.0 "$node_(765) off" 
$ns at 700.0 "$node_(765) on" 
$node_(766) set X_ 66 
$node_(766) set Y_ 421 
$node_(766) set Z_ 0.0 
$ns at 0.0 "$node_(766) off" 
$ns at 700.0 "$node_(766) on" 
$node_(767) set X_ 117 
$node_(767) set Y_ 706 
$node_(767) set Z_ 0.0 
$ns at 0.0 "$node_(767) off" 
$ns at 700.0 "$node_(767) on" 
$node_(768) set X_ 1149 
$node_(768) set Y_ 129 
$node_(768) set Z_ 0.0 
$ns at 0.0 "$node_(768) off" 
$ns at 700.0 "$node_(768) on" 
$node_(769) set X_ 378 
$node_(769) set Y_ 177 
$node_(769) set Z_ 0.0 
$ns at 0.0 "$node_(769) off" 
$ns at 700.0 "$node_(769) on" 
$node_(770) set X_ 2177 
$node_(770) set Y_ 953 
$node_(770) set Z_ 0.0 
$ns at 0.0 "$node_(770) off" 
$ns at 700.0 "$node_(770) on" 
$node_(771) set X_ 2997 
$node_(771) set Y_ 131 
$node_(771) set Z_ 0.0 
$ns at 0.0 "$node_(771) off" 
$ns at 700.0 "$node_(771) on" 
$node_(772) set X_ 1009 
$node_(772) set Y_ 406 
$node_(772) set Z_ 0.0 
$ns at 0.0 "$node_(772) off" 
$ns at 700.0 "$node_(772) on" 
$node_(773) set X_ 346 
$node_(773) set Y_ 66 
$node_(773) set Z_ 0.0 
$ns at 0.0 "$node_(773) off" 
$ns at 700.0 "$node_(773) on" 
$node_(774) set X_ 436 
$node_(774) set Y_ 395 
$node_(774) set Z_ 0.0 
$ns at 0.0 "$node_(774) off" 
$ns at 700.0 "$node_(774) on" 
$node_(775) set X_ 2010 
$node_(775) set Y_ 219 
$node_(775) set Z_ 0.0 
$ns at 0.0 "$node_(775) off" 
$ns at 700.0 "$node_(775) on" 
$node_(776) set X_ 1356 
$node_(776) set Y_ 588 
$node_(776) set Z_ 0.0 
$ns at 0.0 "$node_(776) off" 
$ns at 700.0 "$node_(776) on" 
$node_(777) set X_ 1384 
$node_(777) set Y_ 503 
$node_(777) set Z_ 0.0 
$ns at 0.0 "$node_(777) off" 
$ns at 700.0 "$node_(777) on" 
$node_(778) set X_ 2981 
$node_(778) set Y_ 592 
$node_(778) set Z_ 0.0 
$ns at 0.0 "$node_(778) off" 
$ns at 700.0 "$node_(778) on" 
$node_(779) set X_ 2585 
$node_(779) set Y_ 460 
$node_(779) set Z_ 0.0 
$ns at 0.0 "$node_(779) off" 
$ns at 700.0 "$node_(779) on" 
$node_(780) set X_ 2290 
$node_(780) set Y_ 72 
$node_(780) set Z_ 0.0 
$ns at 0.0 "$node_(780) off" 
$ns at 700.0 "$node_(780) on" 
$node_(781) set X_ 2086 
$node_(781) set Y_ 460 
$node_(781) set Z_ 0.0 
$ns at 0.0 "$node_(781) off" 
$ns at 700.0 "$node_(781) on" 
$node_(782) set X_ 1092 
$node_(782) set Y_ 297 
$node_(782) set Z_ 0.0 
$ns at 0.0 "$node_(782) off" 
$ns at 700.0 "$node_(782) on" 
$node_(783) set X_ 73 
$node_(783) set Y_ 700 
$node_(783) set Z_ 0.0 
$ns at 0.0 "$node_(783) off" 
$ns at 700.0 "$node_(783) on" 
$node_(784) set X_ 2902 
$node_(784) set Y_ 160 
$node_(784) set Z_ 0.0 
$ns at 0.0 "$node_(784) off" 
$ns at 700.0 "$node_(784) on" 
$node_(785) set X_ 1376 
$node_(785) set Y_ 571 
$node_(785) set Z_ 0.0 
$ns at 0.0 "$node_(785) off" 
$ns at 700.0 "$node_(785) on" 
$node_(786) set X_ 431 
$node_(786) set Y_ 421 
$node_(786) set Z_ 0.0 
$ns at 0.0 "$node_(786) off" 
$ns at 700.0 "$node_(786) on" 
$node_(787) set X_ 1890 
$node_(787) set Y_ 603 
$node_(787) set Z_ 0.0 
$ns at 0.0 "$node_(787) off" 
$ns at 700.0 "$node_(787) on" 
$node_(788) set X_ 2783 
$node_(788) set Y_ 758 
$node_(788) set Z_ 0.0 
$ns at 0.0 "$node_(788) off" 
$ns at 700.0 "$node_(788) on" 
$node_(789) set X_ 2676 
$node_(789) set Y_ 513 
$node_(789) set Z_ 0.0 
$ns at 0.0 "$node_(789) off" 
$ns at 700.0 "$node_(789) on" 
$node_(790) set X_ 1442 
$node_(790) set Y_ 251 
$node_(790) set Z_ 0.0 
$ns at 0.0 "$node_(790) off" 
$ns at 700.0 "$node_(790) on" 
$node_(791) set X_ 436 
$node_(791) set Y_ 849 
$node_(791) set Z_ 0.0 
$ns at 0.0 "$node_(791) off" 
$ns at 700.0 "$node_(791) on" 
$node_(792) set X_ 1907 
$node_(792) set Y_ 72 
$node_(792) set Z_ 0.0 
$ns at 0.0 "$node_(792) off" 
$ns at 700.0 "$node_(792) on" 
$node_(793) set X_ 2770 
$node_(793) set Y_ 331 
$node_(793) set Z_ 0.0 
$ns at 0.0 "$node_(793) off" 
$ns at 700.0 "$node_(793) on" 
$node_(794) set X_ 1253 
$node_(794) set Y_ 497 
$node_(794) set Z_ 0.0 
$ns at 0.0 "$node_(794) off" 
$ns at 700.0 "$node_(794) on" 
$node_(795) set X_ 1563 
$node_(795) set Y_ 293 
$node_(795) set Z_ 0.0 
$ns at 0.0 "$node_(795) off" 
$ns at 700.0 "$node_(795) on" 
$node_(796) set X_ 1076 
$node_(796) set Y_ 810 
$node_(796) set Z_ 0.0 
$ns at 0.0 "$node_(796) off" 
$ns at 700.0 "$node_(796) on" 
$node_(797) set X_ 4 
$node_(797) set Y_ 538 
$node_(797) set Z_ 0.0 
$ns at 0.0 "$node_(797) off" 
$ns at 700.0 "$node_(797) on" 
$node_(798) set X_ 173 
$node_(798) set Y_ 348 
$node_(798) set Z_ 0.0 
$ns at 0.0 "$node_(798) off" 
$ns at 700.0 "$node_(798) on" 
$node_(799) set X_ 1112 
$node_(799) set Y_ 530 
$node_(799) set Z_ 0.0 
$ns at 0.0 "$node_(799) off" 
$ns at 700.0 "$node_(799) on" 

# Generation of movements
$ns at 0.0 "$node_(0) setdest 92306 21448 2.0" 
$ns at 31.588930419701533 "$node_(0) setdest 82671 28647 5.0" 
$ns at 90.92255795263972 "$node_(0) setdest 67828 5255 18.0" 
$ns at 207.28791706803906 "$node_(0) setdest 1845 29053 17.0" 
$ns at 351.64757595545655 "$node_(0) setdest 159302 57941 17.0" 
$ns at 511.89807511848915 "$node_(0) setdest 161175 58644 12.0" 
$ns at 569.5506280948747 "$node_(0) setdest 214938 13710 1.0" 
$ns at 609.5015753617965 "$node_(0) setdest 98687 71871 11.0" 
$ns at 717.9933238969289 "$node_(0) setdest 203518 10175 6.0" 
$ns at 775.9301922907532 "$node_(0) setdest 102101 52558 8.0" 
$ns at 871.1536363204 "$node_(0) setdest 109942 3988 1.0" 
$ns at 0.0 "$node_(1) setdest 3167 20452 8.0" 
$ns at 37.9374475840521 "$node_(1) setdest 83331 22459 14.0" 
$ns at 142.11263924073052 "$node_(1) setdest 82928 5653 8.0" 
$ns at 191.33581033464733 "$node_(1) setdest 119188 16554 15.0" 
$ns at 349.123927917065 "$node_(1) setdest 158702 37277 15.0" 
$ns at 429.078542300296 "$node_(1) setdest 186679 13944 14.0" 
$ns at 587.2630244866011 "$node_(1) setdest 111845 62226 2.0" 
$ns at 636.7423698804196 "$node_(1) setdest 61569 24576 6.0" 
$ns at 708.3683237162471 "$node_(1) setdest 38723 22624 1.0" 
$ns at 739.1215488939085 "$node_(1) setdest 222018 18482 7.0" 
$ns at 782.2511536312295 "$node_(1) setdest 203109 78489 16.0" 
$ns at 0.0 "$node_(2) setdest 9266 28077 10.0" 
$ns at 104.08201855276344 "$node_(2) setdest 91797 22738 16.0" 
$ns at 261.1101965838604 "$node_(2) setdest 139805 31774 18.0" 
$ns at 416.568911417073 "$node_(2) setdest 45850 2217 7.0" 
$ns at 465.1651010522024 "$node_(2) setdest 31840 57382 18.0" 
$ns at 626.7096241860875 "$node_(2) setdest 127504 25123 1.0" 
$ns at 661.364708798715 "$node_(2) setdest 174727 50225 12.0" 
$ns at 743.7430770662553 "$node_(2) setdest 22583 51606 6.0" 
$ns at 784.3014283693504 "$node_(2) setdest 140694 49024 15.0" 
$ns at 815.0127511309727 "$node_(2) setdest 96202 4544 12.0" 
$ns at 0.0 "$node_(3) setdest 60575 16252 10.0" 
$ns at 37.0392649136443 "$node_(3) setdest 14779 4719 14.0" 
$ns at 99.06751113917306 "$node_(3) setdest 83132 28577 7.0" 
$ns at 133.46292656837582 "$node_(3) setdest 40589 13893 1.0" 
$ns at 170.28155848740147 "$node_(3) setdest 66343 37736 14.0" 
$ns at 290.02291669401586 "$node_(3) setdest 5695 17013 4.0" 
$ns at 347.84108625425847 "$node_(3) setdest 34987 41601 1.0" 
$ns at 378.2993718130947 "$node_(3) setdest 154709 16147 14.0" 
$ns at 512.8790480863065 "$node_(3) setdest 149494 8933 5.0" 
$ns at 565.4078522761693 "$node_(3) setdest 130899 68629 3.0" 
$ns at 619.5437594198986 "$node_(3) setdest 179290 32130 3.0" 
$ns at 668.8287392766144 "$node_(3) setdest 194115 31377 20.0" 
$ns at 811.6192972013002 "$node_(3) setdest 185666 44554 1.0" 
$ns at 847.8097016983578 "$node_(3) setdest 74058 18788 5.0" 
$ns at 0.0 "$node_(4) setdest 45648 1327 1.0" 
$ns at 39.24046763122808 "$node_(4) setdest 11381 12977 20.0" 
$ns at 259.3958180051824 "$node_(4) setdest 8337 35373 11.0" 
$ns at 379.3332104438928 "$node_(4) setdest 60355 37852 3.0" 
$ns at 428.9639323600337 "$node_(4) setdest 95986 47816 10.0" 
$ns at 518.9557632001001 "$node_(4) setdest 67619 40423 9.0" 
$ns at 594.7392051340966 "$node_(4) setdest 16143 47970 9.0" 
$ns at 685.7678471539797 "$node_(4) setdest 79447 22387 2.0" 
$ns at 734.7221493387528 "$node_(4) setdest 92930 66662 1.0" 
$ns at 766.7803731724912 "$node_(4) setdest 205358 24064 16.0" 
$ns at 0.0 "$node_(5) setdest 7983 252 4.0" 
$ns at 45.12003342866075 "$node_(5) setdest 67102 7654 5.0" 
$ns at 111.48339722394707 "$node_(5) setdest 15810 10252 8.0" 
$ns at 198.4886542109566 "$node_(5) setdest 104751 42566 12.0" 
$ns at 330.5236494572374 "$node_(5) setdest 27019 53714 9.0" 
$ns at 441.65317420688837 "$node_(5) setdest 3838 47512 12.0" 
$ns at 535.5969930079002 "$node_(5) setdest 73163 23160 9.0" 
$ns at 571.2374889316916 "$node_(5) setdest 188764 53166 6.0" 
$ns at 602.281600589972 "$node_(5) setdest 146753 53329 7.0" 
$ns at 665.5876615139024 "$node_(5) setdest 155694 51328 7.0" 
$ns at 700.9945630758881 "$node_(5) setdest 146477 12319 15.0" 
$ns at 750.8619771309753 "$node_(5) setdest 91479 86953 1.0" 
$ns at 785.7621000211241 "$node_(5) setdest 243709 47495 17.0" 
$ns at 0.0 "$node_(6) setdest 38566 3444 17.0" 
$ns at 101.06641455579457 "$node_(6) setdest 23118 3494 18.0" 
$ns at 242.63703317880413 "$node_(6) setdest 133624 13243 19.0" 
$ns at 301.6723077794877 "$node_(6) setdest 33037 43054 13.0" 
$ns at 429.6620988315615 "$node_(6) setdest 183573 53150 19.0" 
$ns at 636.4786464309027 "$node_(6) setdest 210090 60402 3.0" 
$ns at 677.2196768280251 "$node_(6) setdest 94606 77412 15.0" 
$ns at 823.6461100489189 "$node_(6) setdest 137947 9155 11.0" 
$ns at 0.0 "$node_(7) setdest 65856 2614 18.0" 
$ns at 134.6944362516458 "$node_(7) setdest 45457 9962 6.0" 
$ns at 197.98924767549772 "$node_(7) setdest 11005 19568 7.0" 
$ns at 289.42086926142326 "$node_(7) setdest 81390 19479 17.0" 
$ns at 415.38304376516425 "$node_(7) setdest 66315 7605 19.0" 
$ns at 446.0387820240855 "$node_(7) setdest 79388 28374 9.0" 
$ns at 517.277548502774 "$node_(7) setdest 94207 34737 19.0" 
$ns at 667.7348195656314 "$node_(7) setdest 154265 30800 14.0" 
$ns at 702.6056384375986 "$node_(7) setdest 149414 6098 4.0" 
$ns at 767.3751659550659 "$node_(7) setdest 130964 51357 5.0" 
$ns at 844.6996324827248 "$node_(7) setdest 126993 29713 7.0" 
$ns at 898.8295855978237 "$node_(7) setdest 46670 88653 7.0" 
$ns at 0.0 "$node_(8) setdest 92580 22450 4.0" 
$ns at 32.75762119855026 "$node_(8) setdest 60226 14174 18.0" 
$ns at 161.02248108646577 "$node_(8) setdest 68002 24137 9.0" 
$ns at 276.1101359989164 "$node_(8) setdest 106732 2801 1.0" 
$ns at 308.8848245974625 "$node_(8) setdest 141171 41221 17.0" 
$ns at 370.5019179249264 "$node_(8) setdest 81880 332 12.0" 
$ns at 445.23472972822503 "$node_(8) setdest 12541 32292 5.0" 
$ns at 478.86578182010743 "$node_(8) setdest 183758 46581 6.0" 
$ns at 566.4912876561972 "$node_(8) setdest 193844 12759 2.0" 
$ns at 611.9866292881009 "$node_(8) setdest 140565 60901 5.0" 
$ns at 667.0760876787283 "$node_(8) setdest 105452 15173 14.0" 
$ns at 722.1516093114703 "$node_(8) setdest 126389 31922 9.0" 
$ns at 774.7935222067032 "$node_(8) setdest 17785 83334 16.0" 
$ns at 0.0 "$node_(9) setdest 13782 15183 13.0" 
$ns at 63.82992687130037 "$node_(9) setdest 33853 15463 8.0" 
$ns at 109.83901002434354 "$node_(9) setdest 41179 24655 14.0" 
$ns at 139.85973860183685 "$node_(9) setdest 10328 26175 10.0" 
$ns at 240.90972532837839 "$node_(9) setdest 66883 3532 12.0" 
$ns at 384.6436417332758 "$node_(9) setdest 125383 4410 19.0" 
$ns at 465.98936958461434 "$node_(9) setdest 83528 56914 14.0" 
$ns at 594.4989140217359 "$node_(9) setdest 156245 51999 6.0" 
$ns at 668.2714219741791 "$node_(9) setdest 85276 12211 16.0" 
$ns at 775.4253463050655 "$node_(9) setdest 214212 62273 2.0" 
$ns at 825.2497546736336 "$node_(9) setdest 129959 50372 1.0" 
$ns at 855.7885517501505 "$node_(9) setdest 228158 50898 14.0" 
$ns at 0.0 "$node_(10) setdest 40723 22041 18.0" 
$ns at 114.74489336648745 "$node_(10) setdest 29338 30139 16.0" 
$ns at 264.8104209871167 "$node_(10) setdest 1244 51491 16.0" 
$ns at 320.22746054495747 "$node_(10) setdest 49650 35484 11.0" 
$ns at 382.77330736913666 "$node_(10) setdest 9565 12368 11.0" 
$ns at 435.6084332912074 "$node_(10) setdest 77072 41137 12.0" 
$ns at 536.4188204056527 "$node_(10) setdest 27961 41711 16.0" 
$ns at 716.8718718578638 "$node_(10) setdest 224294 64851 18.0" 
$ns at 835.7328443379251 "$node_(10) setdest 142086 14363 2.0" 
$ns at 867.6598837691067 "$node_(10) setdest 75283 42582 13.0" 
$ns at 0.0 "$node_(11) setdest 84462 24904 1.0" 
$ns at 32.072346263859494 "$node_(11) setdest 27837 24271 18.0" 
$ns at 188.99745502832647 "$node_(11) setdest 45331 39711 14.0" 
$ns at 358.9130342226743 "$node_(11) setdest 116787 24395 7.0" 
$ns at 390.72289274135346 "$node_(11) setdest 2239 40757 12.0" 
$ns at 529.3036420770779 "$node_(11) setdest 5878 41567 17.0" 
$ns at 616.4423570941489 "$node_(11) setdest 64065 60818 6.0" 
$ns at 647.1707274186329 "$node_(11) setdest 187355 17935 17.0" 
$ns at 764.8378484417262 "$node_(11) setdest 22252 16719 17.0" 
$ns at 801.5905616314802 "$node_(11) setdest 131733 2712 1.0" 
$ns at 839.5507681925885 "$node_(11) setdest 63898 73252 7.0" 
$ns at 880.9915700120916 "$node_(11) setdest 103856 11542 12.0" 
$ns at 0.0 "$node_(12) setdest 51497 25254 6.0" 
$ns at 76.82980498855304 "$node_(12) setdest 39294 12459 14.0" 
$ns at 146.48020784099984 "$node_(12) setdest 6013 18244 12.0" 
$ns at 241.48855593574228 "$node_(12) setdest 22207 2782 17.0" 
$ns at 359.05024249232946 "$node_(12) setdest 1836 33230 9.0" 
$ns at 410.1407961341837 "$node_(12) setdest 55093 40765 6.0" 
$ns at 492.4034925190024 "$node_(12) setdest 204220 31224 5.0" 
$ns at 539.7511676052226 "$node_(12) setdest 119602 16044 4.0" 
$ns at 598.9095927762288 "$node_(12) setdest 102088 57661 10.0" 
$ns at 668.8381910071498 "$node_(12) setdest 64337 47217 3.0" 
$ns at 710.6797864410081 "$node_(12) setdest 8179 31652 8.0" 
$ns at 770.1355011566626 "$node_(12) setdest 178922 54786 10.0" 
$ns at 834.3146899006733 "$node_(12) setdest 165250 62213 1.0" 
$ns at 872.237842511258 "$node_(12) setdest 250151 34958 15.0" 
$ns at 0.0 "$node_(13) setdest 33097 26451 20.0" 
$ns at 107.44436720995745 "$node_(13) setdest 45297 10186 15.0" 
$ns at 140.97249516989416 "$node_(13) setdest 44998 11922 6.0" 
$ns at 186.16527136609167 "$node_(13) setdest 96319 19814 14.0" 
$ns at 261.8787194326005 "$node_(13) setdest 23485 14431 16.0" 
$ns at 293.10957018630535 "$node_(13) setdest 144458 7141 17.0" 
$ns at 358.4394451560685 "$node_(13) setdest 143333 19188 19.0" 
$ns at 469.0404865972886 "$node_(13) setdest 9754 16729 18.0" 
$ns at 572.3399025356101 "$node_(13) setdest 130102 56748 15.0" 
$ns at 663.8720418625203 "$node_(13) setdest 202013 65303 17.0" 
$ns at 858.635299502808 "$node_(13) setdest 132074 56147 3.0" 
$ns at 0.0 "$node_(14) setdest 8762 18556 9.0" 
$ns at 43.329074080831504 "$node_(14) setdest 47320 5812 17.0" 
$ns at 163.96446872308664 "$node_(14) setdest 15252 23202 3.0" 
$ns at 222.4898752480936 "$node_(14) setdest 111198 5650 14.0" 
$ns at 264.54114774625594 "$node_(14) setdest 72899 10961 20.0" 
$ns at 399.37174685086507 "$node_(14) setdest 6654 49190 3.0" 
$ns at 434.74827730160916 "$node_(14) setdest 127931 23267 10.0" 
$ns at 549.0844713344519 "$node_(14) setdest 142410 38689 5.0" 
$ns at 611.655135153223 "$node_(14) setdest 51472 19679 15.0" 
$ns at 703.1346228545685 "$node_(14) setdest 232072 72242 17.0" 
$ns at 826.2732284750687 "$node_(14) setdest 41612 57057 15.0" 
$ns at 0.0 "$node_(15) setdest 63611 25971 4.0" 
$ns at 60.62209249205493 "$node_(15) setdest 15567 14704 14.0" 
$ns at 100.64110041702793 "$node_(15) setdest 65477 1861 10.0" 
$ns at 199.98805072939496 "$node_(15) setdest 2960 7893 4.0" 
$ns at 233.49572757121217 "$node_(15) setdest 4930 28530 15.0" 
$ns at 402.9967670558493 "$node_(15) setdest 31234 9139 12.0" 
$ns at 488.2633985865814 "$node_(15) setdest 167563 66814 7.0" 
$ns at 546.9068395044629 "$node_(15) setdest 51546 60558 19.0" 
$ns at 591.4452822482353 "$node_(15) setdest 159601 68362 9.0" 
$ns at 668.0664141584907 "$node_(15) setdest 192460 62259 11.0" 
$ns at 786.8368554812321 "$node_(15) setdest 98600 78056 1.0" 
$ns at 817.204758834016 "$node_(15) setdest 53416 71732 17.0" 
$ns at 857.9208416769756 "$node_(15) setdest 59812 39185 17.0" 
$ns at 0.0 "$node_(16) setdest 11134 12272 17.0" 
$ns at 32.487320734948064 "$node_(16) setdest 8032 12151 2.0" 
$ns at 76.5288726896627 "$node_(16) setdest 28790 26991 7.0" 
$ns at 136.77491332408727 "$node_(16) setdest 23100 26878 7.0" 
$ns at 219.4648097725285 "$node_(16) setdest 117498 39997 7.0" 
$ns at 274.3971065828009 "$node_(16) setdest 88051 40873 15.0" 
$ns at 375.82964945393354 "$node_(16) setdest 156905 48708 20.0" 
$ns at 416.6905426581387 "$node_(16) setdest 92280 22372 7.0" 
$ns at 465.9011847210768 "$node_(16) setdest 123186 55461 15.0" 
$ns at 641.3471662389795 "$node_(16) setdest 172989 7518 4.0" 
$ns at 709.8586872071994 "$node_(16) setdest 108045 56118 17.0" 
$ns at 845.3020999147366 "$node_(16) setdest 81449 68576 14.0" 
$ns at 0.0 "$node_(17) setdest 92373 24677 18.0" 
$ns at 147.9573111167178 "$node_(17) setdest 22890 22368 5.0" 
$ns at 218.48906162686137 "$node_(17) setdest 121387 9549 11.0" 
$ns at 306.27785185328173 "$node_(17) setdest 159130 40653 1.0" 
$ns at 337.63102722706816 "$node_(17) setdest 128147 15979 20.0" 
$ns at 462.3522960416319 "$node_(17) setdest 47832 60354 18.0" 
$ns at 609.801518194105 "$node_(17) setdest 143423 1045 1.0" 
$ns at 647.8570967861531 "$node_(17) setdest 73154 68753 17.0" 
$ns at 769.9950759400228 "$node_(17) setdest 119573 34800 19.0" 
$ns at 0.0 "$node_(18) setdest 29100 25458 15.0" 
$ns at 175.41178032295494 "$node_(18) setdest 22178 35705 9.0" 
$ns at 261.5593020670304 "$node_(18) setdest 34167 13429 8.0" 
$ns at 306.8527068645966 "$node_(18) setdest 54769 41999 16.0" 
$ns at 375.6392193905357 "$node_(18) setdest 62634 26832 5.0" 
$ns at 424.6852743270432 "$node_(18) setdest 139963 50786 6.0" 
$ns at 503.13791965710845 "$node_(18) setdest 73762 45030 16.0" 
$ns at 654.6760813971424 "$node_(18) setdest 219141 16230 16.0" 
$ns at 717.5476632393909 "$node_(18) setdest 196424 73647 14.0" 
$ns at 868.0917905183505 "$node_(18) setdest 182896 80622 17.0" 
$ns at 0.0 "$node_(19) setdest 85746 11746 17.0" 
$ns at 32.54261805936757 "$node_(19) setdest 16280 30152 3.0" 
$ns at 66.35848101205244 "$node_(19) setdest 26728 30850 20.0" 
$ns at 172.35164164595693 "$node_(19) setdest 104390 43734 17.0" 
$ns at 284.06470899361346 "$node_(19) setdest 79363 44699 12.0" 
$ns at 327.00612630408386 "$node_(19) setdest 94969 42136 3.0" 
$ns at 367.8971543096457 "$node_(19) setdest 122683 37073 8.0" 
$ns at 435.63452004471833 "$node_(19) setdest 137258 2288 7.0" 
$ns at 500.10348656664655 "$node_(19) setdest 196864 23341 3.0" 
$ns at 531.2996296800942 "$node_(19) setdest 149860 51076 12.0" 
$ns at 673.1034188288212 "$node_(19) setdest 12592 59828 20.0" 
$ns at 748.5724169080324 "$node_(19) setdest 79886 45704 5.0" 
$ns at 795.780184163011 "$node_(19) setdest 120558 5600 18.0" 
$ns at 0.0 "$node_(20) setdest 39512 20689 10.0" 
$ns at 101.85591050799694 "$node_(20) setdest 71564 20833 14.0" 
$ns at 161.82767776433985 "$node_(20) setdest 115855 23723 11.0" 
$ns at 194.1263756066192 "$node_(20) setdest 78873 5074 5.0" 
$ns at 260.1488677405058 "$node_(20) setdest 41009 30661 1.0" 
$ns at 294.9457173010326 "$node_(20) setdest 152276 43124 16.0" 
$ns at 456.1809940538117 "$node_(20) setdest 55832 62723 2.0" 
$ns at 495.41930732616413 "$node_(20) setdest 108392 39394 14.0" 
$ns at 581.3041020511655 "$node_(20) setdest 191283 36199 13.0" 
$ns at 630.372539421528 "$node_(20) setdest 9134 33886 8.0" 
$ns at 702.432765245899 "$node_(20) setdest 83929 37857 17.0" 
$ns at 809.5254241062578 "$node_(20) setdest 37327 74250 2.0" 
$ns at 858.3996877070698 "$node_(20) setdest 182917 27505 18.0" 
$ns at 0.0 "$node_(21) setdest 33157 13254 6.0" 
$ns at 65.93000594868292 "$node_(21) setdest 78201 9549 1.0" 
$ns at 101.65396511120959 "$node_(21) setdest 57462 31048 13.0" 
$ns at 233.26240515293443 "$node_(21) setdest 14039 12100 8.0" 
$ns at 322.21349010920187 "$node_(21) setdest 158232 34798 11.0" 
$ns at 431.19255693580806 "$node_(21) setdest 120363 49835 14.0" 
$ns at 556.4256321764848 "$node_(21) setdest 127423 22309 2.0" 
$ns at 600.2316184072763 "$node_(21) setdest 86322 11736 5.0" 
$ns at 648.0061545391866 "$node_(21) setdest 227392 24407 16.0" 
$ns at 681.2281083416395 "$node_(21) setdest 188524 68385 13.0" 
$ns at 772.1302321197942 "$node_(21) setdest 196487 65155 5.0" 
$ns at 826.9079051690501 "$node_(21) setdest 263981 16442 11.0" 
$ns at 0.0 "$node_(22) setdest 20414 11380 2.0" 
$ns at 31.486938915272866 "$node_(22) setdest 36463 27409 11.0" 
$ns at 122.46281455865085 "$node_(22) setdest 47990 26159 4.0" 
$ns at 190.28662996005005 "$node_(22) setdest 46212 38525 18.0" 
$ns at 317.0037230224118 "$node_(22) setdest 3451 16606 7.0" 
$ns at 366.70383583139176 "$node_(22) setdest 154146 14916 7.0" 
$ns at 440.6189049684533 "$node_(22) setdest 111593 22537 9.0" 
$ns at 494.1169080536445 "$node_(22) setdest 83493 17603 3.0" 
$ns at 531.3165378876572 "$node_(22) setdest 140909 27114 15.0" 
$ns at 591.2081245617546 "$node_(22) setdest 100881 3067 15.0" 
$ns at 643.2492503185097 "$node_(22) setdest 159949 31227 1.0" 
$ns at 681.8579572391172 "$node_(22) setdest 176192 23423 17.0" 
$ns at 721.2773085297312 "$node_(22) setdest 202402 19264 5.0" 
$ns at 765.9767340773054 "$node_(22) setdest 141691 39182 10.0" 
$ns at 805.0198040744573 "$node_(22) setdest 122704 26859 11.0" 
$ns at 0.0 "$node_(23) setdest 49428 17206 1.0" 
$ns at 33.87466796821361 "$node_(23) setdest 52858 20990 5.0" 
$ns at 94.71390780296234 "$node_(23) setdest 20754 19132 3.0" 
$ns at 132.27853432941595 "$node_(23) setdest 25744 29079 12.0" 
$ns at 182.0076671644759 "$node_(23) setdest 38930 2766 12.0" 
$ns at 283.3244436884792 "$node_(23) setdest 100520 5886 13.0" 
$ns at 431.1953150179197 "$node_(23) setdest 28473 59102 19.0" 
$ns at 573.8976207541142 "$node_(23) setdest 80819 64188 2.0" 
$ns at 617.6833792479442 "$node_(23) setdest 23487 42451 9.0" 
$ns at 719.7711512643555 "$node_(23) setdest 243422 9563 13.0" 
$ns at 830.2475275645601 "$node_(23) setdest 97998 88179 5.0" 
$ns at 867.3381265565275 "$node_(23) setdest 185804 72578 11.0" 
$ns at 0.0 "$node_(24) setdest 58714 20977 11.0" 
$ns at 86.41473081619858 "$node_(24) setdest 69900 15997 20.0" 
$ns at 192.3531142755726 "$node_(24) setdest 119984 29834 14.0" 
$ns at 354.6550306809554 "$node_(24) setdest 72018 15898 13.0" 
$ns at 386.2928356819136 "$node_(24) setdest 182277 47707 4.0" 
$ns at 437.4891319364648 "$node_(24) setdest 96220 39532 2.0" 
$ns at 474.7903166349811 "$node_(24) setdest 116375 11051 10.0" 
$ns at 561.8317463569613 "$node_(24) setdest 154162 68022 12.0" 
$ns at 705.9859952171647 "$node_(24) setdest 7696 48643 9.0" 
$ns at 795.5307385932988 "$node_(24) setdest 222521 18058 16.0" 
$ns at 842.8065390538916 "$node_(24) setdest 113191 5486 17.0" 
$ns at 0.0 "$node_(25) setdest 40041 11950 17.0" 
$ns at 120.27922118418874 "$node_(25) setdest 77096 16936 18.0" 
$ns at 283.98087645026357 "$node_(25) setdest 41623 18227 12.0" 
$ns at 341.49055299202587 "$node_(25) setdest 98383 17434 17.0" 
$ns at 376.590353060354 "$node_(25) setdest 82198 23167 11.0" 
$ns at 514.0010629242212 "$node_(25) setdest 25364 59602 9.0" 
$ns at 584.5149639693915 "$node_(25) setdest 106881 5641 11.0" 
$ns at 679.9715650292205 "$node_(25) setdest 143158 27408 13.0" 
$ns at 818.2455937278091 "$node_(25) setdest 263490 20151 12.0" 
$ns at 0.0 "$node_(26) setdest 28430 8151 5.0" 
$ns at 50.982475089472736 "$node_(26) setdest 92215 4479 4.0" 
$ns at 96.98730062338501 "$node_(26) setdest 81263 26206 11.0" 
$ns at 155.03986453669575 "$node_(26) setdest 40341 13544 14.0" 
$ns at 191.45778080595136 "$node_(26) setdest 53704 33270 4.0" 
$ns at 228.0401789272085 "$node_(26) setdest 127172 10838 8.0" 
$ns at 312.1688338347429 "$node_(26) setdest 55156 720 1.0" 
$ns at 344.9341659386758 "$node_(26) setdest 56013 53468 2.0" 
$ns at 383.5100272644056 "$node_(26) setdest 54668 40758 1.0" 
$ns at 416.45428175000484 "$node_(26) setdest 105616 31228 11.0" 
$ns at 526.6327215692602 "$node_(26) setdest 165608 26566 4.0" 
$ns at 595.7226665901709 "$node_(26) setdest 87638 6052 13.0" 
$ns at 715.3940907181587 "$node_(26) setdest 56968 70208 2.0" 
$ns at 756.0885133083402 "$node_(26) setdest 116918 42580 1.0" 
$ns at 796.0290170959577 "$node_(26) setdest 27674 71903 8.0" 
$ns at 897.5755664938433 "$node_(26) setdest 253037 16709 2.0" 
$ns at 0.0 "$node_(27) setdest 39100 12367 2.0" 
$ns at 30.946456904099296 "$node_(27) setdest 69283 12319 8.0" 
$ns at 127.19660921471595 "$node_(27) setdest 76232 12832 4.0" 
$ns at 194.4214644948481 "$node_(27) setdest 80376 12465 5.0" 
$ns at 261.0433444337431 "$node_(27) setdest 158108 9902 1.0" 
$ns at 296.5608783310603 "$node_(27) setdest 35290 45292 3.0" 
$ns at 348.1076639448955 "$node_(27) setdest 21213 31552 8.0" 
$ns at 403.2091625479979 "$node_(27) setdest 6242 15491 12.0" 
$ns at 476.25445749148673 "$node_(27) setdest 184035 2060 6.0" 
$ns at 551.0870673380932 "$node_(27) setdest 231510 51002 8.0" 
$ns at 614.7148490440455 "$node_(27) setdest 101833 61999 19.0" 
$ns at 664.8846536213134 "$node_(27) setdest 248741 64476 15.0" 
$ns at 762.8229402188363 "$node_(27) setdest 106264 72287 5.0" 
$ns at 819.5916388946366 "$node_(27) setdest 80557 47479 17.0" 
$ns at 0.0 "$node_(28) setdest 25836 22074 3.0" 
$ns at 52.967983768845656 "$node_(28) setdest 51520 2466 12.0" 
$ns at 163.71249496882254 "$node_(28) setdest 61143 1813 8.0" 
$ns at 237.23242663308594 "$node_(28) setdest 112426 21429 11.0" 
$ns at 370.26870426824473 "$node_(28) setdest 120404 50770 2.0" 
$ns at 405.4051395625496 "$node_(28) setdest 33760 2036 9.0" 
$ns at 525.0827503258847 "$node_(28) setdest 87974 34429 6.0" 
$ns at 582.1598374298773 "$node_(28) setdest 59574 11783 10.0" 
$ns at 693.0569973491542 "$node_(28) setdest 244852 48694 14.0" 
$ns at 752.9781471689946 "$node_(28) setdest 62189 9925 4.0" 
$ns at 814.4607513808762 "$node_(28) setdest 235507 19841 12.0" 
$ns at 0.0 "$node_(29) setdest 16068 4758 8.0" 
$ns at 59.24338520272349 "$node_(29) setdest 36612 6151 8.0" 
$ns at 141.4367512747102 "$node_(29) setdest 14061 23309 3.0" 
$ns at 172.4963722419017 "$node_(29) setdest 123415 31213 16.0" 
$ns at 279.065201171569 "$node_(29) setdest 44661 53622 14.0" 
$ns at 333.8386605495114 "$node_(29) setdest 81603 26610 15.0" 
$ns at 474.0979676882766 "$node_(29) setdest 14981 33553 20.0" 
$ns at 559.2666328312274 "$node_(29) setdest 64568 23110 11.0" 
$ns at 626.3852479935764 "$node_(29) setdest 8131 8636 15.0" 
$ns at 709.0567267968282 "$node_(29) setdest 146909 60460 17.0" 
$ns at 753.4150710059333 "$node_(29) setdest 71432 52539 7.0" 
$ns at 831.0408572867893 "$node_(29) setdest 267617 78458 10.0" 
$ns at 0.0 "$node_(30) setdest 45971 21161 14.0" 
$ns at 51.24616533659332 "$node_(30) setdest 37037 17861 8.0" 
$ns at 93.20222341296791 "$node_(30) setdest 83709 14637 13.0" 
$ns at 230.6361742126445 "$node_(30) setdest 5121 35271 12.0" 
$ns at 353.10586699583087 "$node_(30) setdest 106294 13428 9.0" 
$ns at 431.9084113263747 "$node_(30) setdest 25052 49087 12.0" 
$ns at 476.43693100554765 "$node_(30) setdest 113479 28041 7.0" 
$ns at 551.361173979718 "$node_(30) setdest 78105 70055 15.0" 
$ns at 702.0491165785727 "$node_(30) setdest 139916 12151 14.0" 
$ns at 753.85496883629 "$node_(30) setdest 64362 15497 14.0" 
$ns at 0.0 "$node_(31) setdest 21681 7650 14.0" 
$ns at 33.469462396028554 "$node_(31) setdest 77974 3755 8.0" 
$ns at 88.13800688531757 "$node_(31) setdest 14367 7414 17.0" 
$ns at 150.56663021315538 "$node_(31) setdest 38657 13986 10.0" 
$ns at 241.75144726277662 "$node_(31) setdest 14604 18889 14.0" 
$ns at 361.40226150584715 "$node_(31) setdest 170245 53300 3.0" 
$ns at 395.44531190025384 "$node_(31) setdest 95438 46818 15.0" 
$ns at 535.3233487451164 "$node_(31) setdest 135260 29453 13.0" 
$ns at 588.7942381893266 "$node_(31) setdest 127137 62524 14.0" 
$ns at 673.6561357313599 "$node_(31) setdest 217806 82507 9.0" 
$ns at 761.403746470436 "$node_(31) setdest 253920 59159 16.0" 
$ns at 791.4557086545548 "$node_(31) setdest 76398 3196 6.0" 
$ns at 848.0212184728472 "$node_(31) setdest 15141 84980 1.0" 
$ns at 878.7081850430367 "$node_(31) setdest 223514 82987 3.0" 
$ns at 0.0 "$node_(32) setdest 71999 18761 17.0" 
$ns at 33.47848688533327 "$node_(32) setdest 39601 30123 4.0" 
$ns at 76.2946538966963 "$node_(32) setdest 51255 6066 11.0" 
$ns at 179.9579333196532 "$node_(32) setdest 71591 43575 6.0" 
$ns at 266.7563939745617 "$node_(32) setdest 84431 38292 14.0" 
$ns at 328.259432368889 "$node_(32) setdest 29335 44950 17.0" 
$ns at 450.23222300336636 "$node_(32) setdest 79116 8863 18.0" 
$ns at 642.6308201054962 "$node_(32) setdest 152309 62517 14.0" 
$ns at 739.6467066415604 "$node_(32) setdest 128815 24661 3.0" 
$ns at 783.9405449706346 "$node_(32) setdest 36386 3912 1.0" 
$ns at 818.0343826009583 "$node_(32) setdest 217909 82709 19.0" 
$ns at 0.0 "$node_(33) setdest 8596 13191 13.0" 
$ns at 72.54803765778821 "$node_(33) setdest 76338 17281 1.0" 
$ns at 102.72754389850732 "$node_(33) setdest 90912 12403 15.0" 
$ns at 152.22267650323036 "$node_(33) setdest 32629 1661 19.0" 
$ns at 345.6914225419424 "$node_(33) setdest 107748 1590 18.0" 
$ns at 442.90008758986716 "$node_(33) setdest 52976 49470 8.0" 
$ns at 540.860306500665 "$node_(33) setdest 170220 60713 18.0" 
$ns at 603.278539952301 "$node_(33) setdest 175724 57188 11.0" 
$ns at 687.9927728829381 "$node_(33) setdest 192539 42880 19.0" 
$ns at 814.443204211221 "$node_(33) setdest 94260 81920 17.0" 
$ns at 849.5234725480148 "$node_(33) setdest 241828 22429 2.0" 
$ns at 884.2029011321138 "$node_(33) setdest 148673 4555 14.0" 
$ns at 0.0 "$node_(34) setdest 54349 24744 8.0" 
$ns at 91.38946222315099 "$node_(34) setdest 68399 15353 19.0" 
$ns at 198.2074809675483 "$node_(34) setdest 115870 1058 16.0" 
$ns at 250.18817053229736 "$node_(34) setdest 113948 28851 13.0" 
$ns at 372.72174618734937 "$node_(34) setdest 8063 43470 2.0" 
$ns at 418.2055901396541 "$node_(34) setdest 136256 50833 18.0" 
$ns at 494.62688118885774 "$node_(34) setdest 38077 60057 11.0" 
$ns at 572.288159525019 "$node_(34) setdest 152756 30333 16.0" 
$ns at 676.7137680521313 "$node_(34) setdest 128702 74103 11.0" 
$ns at 813.6816900315871 "$node_(34) setdest 195466 64633 9.0" 
$ns at 879.2278140181545 "$node_(34) setdest 115891 38022 18.0" 
$ns at 0.0 "$node_(35) setdest 24642 17516 19.0" 
$ns at 122.73365683251535 "$node_(35) setdest 18151 6682 8.0" 
$ns at 166.20297715638492 "$node_(35) setdest 27082 22847 11.0" 
$ns at 212.04257174269608 "$node_(35) setdest 96137 903 16.0" 
$ns at 381.07331975081996 "$node_(35) setdest 72556 61755 7.0" 
$ns at 426.53861775268865 "$node_(35) setdest 22196 1643 6.0" 
$ns at 508.74981658435075 "$node_(35) setdest 157523 24394 11.0" 
$ns at 625.4899298710708 "$node_(35) setdest 178503 20181 7.0" 
$ns at 656.9760811630931 "$node_(35) setdest 10936 76243 15.0" 
$ns at 794.3001630302979 "$node_(35) setdest 20684 5489 17.0" 
$ns at 0.0 "$node_(36) setdest 74140 28878 8.0" 
$ns at 103.90093039265369 "$node_(36) setdest 27866 20612 16.0" 
$ns at 213.52383613816986 "$node_(36) setdest 40089 22279 1.0" 
$ns at 247.4422836462619 "$node_(36) setdest 131740 11114 13.0" 
$ns at 404.7668779213471 "$node_(36) setdest 62711 40037 20.0" 
$ns at 482.52628522949425 "$node_(36) setdest 2791 24100 11.0" 
$ns at 566.1426323275226 "$node_(36) setdest 110095 17514 3.0" 
$ns at 610.2781477083314 "$node_(36) setdest 45604 2786 15.0" 
$ns at 667.8499484182545 "$node_(36) setdest 79999 82163 12.0" 
$ns at 724.8462776150394 "$node_(36) setdest 227546 51483 17.0" 
$ns at 856.273510070634 "$node_(36) setdest 61475 67803 10.0" 
$ns at 0.0 "$node_(37) setdest 31084 22009 3.0" 
$ns at 53.20537844390394 "$node_(37) setdest 1035 13968 14.0" 
$ns at 126.56317854963515 "$node_(37) setdest 16021 20295 9.0" 
$ns at 177.1887044393938 "$node_(37) setdest 128431 27696 15.0" 
$ns at 215.62627154771224 "$node_(37) setdest 130431 5331 4.0" 
$ns at 281.37359294741395 "$node_(37) setdest 1300 30389 8.0" 
$ns at 384.6720218899651 "$node_(37) setdest 70451 59556 13.0" 
$ns at 482.0869595665305 "$node_(37) setdest 2438 17586 1.0" 
$ns at 515.7447910962837 "$node_(37) setdest 194485 42251 1.0" 
$ns at 548.2228200897384 "$node_(37) setdest 69796 42142 14.0" 
$ns at 711.1025224043989 "$node_(37) setdest 82819 8863 9.0" 
$ns at 769.0543381544562 "$node_(37) setdest 71565 81705 9.0" 
$ns at 824.427384399782 "$node_(37) setdest 80250 8513 6.0" 
$ns at 857.0155024390541 "$node_(37) setdest 20521 31793 8.0" 
$ns at 0.0 "$node_(38) setdest 17206 7840 8.0" 
$ns at 85.71699769337175 "$node_(38) setdest 48620 31219 17.0" 
$ns at 145.51815712257746 "$node_(38) setdest 21216 16072 3.0" 
$ns at 197.6273511194507 "$node_(38) setdest 24408 23986 7.0" 
$ns at 242.5055470835286 "$node_(38) setdest 22159 31050 2.0" 
$ns at 284.4500423597971 "$node_(38) setdest 29275 4985 11.0" 
$ns at 315.07517132090317 "$node_(38) setdest 55202 22578 7.0" 
$ns at 350.931838047531 "$node_(38) setdest 139453 16754 16.0" 
$ns at 539.2226879887659 "$node_(38) setdest 130189 29307 11.0" 
$ns at 668.053813643789 "$node_(38) setdest 223310 50048 17.0" 
$ns at 780.5388612038295 "$node_(38) setdest 228854 71398 7.0" 
$ns at 879.3091319074973 "$node_(38) setdest 105648 19169 19.0" 
$ns at 0.0 "$node_(39) setdest 61551 21761 7.0" 
$ns at 74.52688611675204 "$node_(39) setdest 34044 62 2.0" 
$ns at 122.87487612794772 "$node_(39) setdest 52227 9398 5.0" 
$ns at 184.17203849928146 "$node_(39) setdest 50628 37639 10.0" 
$ns at 259.1947821162847 "$node_(39) setdest 14028 28010 11.0" 
$ns at 369.8067111937666 "$node_(39) setdest 19799 40900 7.0" 
$ns at 414.6456545920532 "$node_(39) setdest 39611 24803 1.0" 
$ns at 449.14265068982445 "$node_(39) setdest 102599 15053 11.0" 
$ns at 530.0057437823775 "$node_(39) setdest 8957 17021 4.0" 
$ns at 591.4234730797425 "$node_(39) setdest 117315 24952 9.0" 
$ns at 673.2148178154589 "$node_(39) setdest 3315 10006 10.0" 
$ns at 741.4330392145048 "$node_(39) setdest 7808 7714 8.0" 
$ns at 843.9628051699302 "$node_(39) setdest 203887 87255 19.0" 
$ns at 0.0 "$node_(40) setdest 64909 6997 19.0" 
$ns at 101.71712219968894 "$node_(40) setdest 39263 23974 9.0" 
$ns at 212.33785059329733 "$node_(40) setdest 3582 11963 16.0" 
$ns at 259.94345399443006 "$node_(40) setdest 20570 9805 1.0" 
$ns at 295.8900201779684 "$node_(40) setdest 119733 41686 2.0" 
$ns at 339.7480476753244 "$node_(40) setdest 154631 333 16.0" 
$ns at 427.11358006475666 "$node_(40) setdest 10909 31098 1.0" 
$ns at 466.221290454699 "$node_(40) setdest 85603 2620 11.0" 
$ns at 574.472212661912 "$node_(40) setdest 171051 59408 1.0" 
$ns at 604.6713765942864 "$node_(40) setdest 111117 11401 1.0" 
$ns at 636.5371546196625 "$node_(40) setdest 94797 51164 8.0" 
$ns at 738.6420268142462 "$node_(40) setdest 170017 4651 17.0" 
$ns at 842.4508152829749 "$node_(40) setdest 52898 46517 20.0" 
$ns at 0.0 "$node_(41) setdest 46643 22278 15.0" 
$ns at 74.62021234511184 "$node_(41) setdest 9651 8041 13.0" 
$ns at 182.30480000276924 "$node_(41) setdest 66042 17721 5.0" 
$ns at 228.12328354581211 "$node_(41) setdest 27994 7527 9.0" 
$ns at 290.09567227372986 "$node_(41) setdest 117964 4522 12.0" 
$ns at 363.8020670704783 "$node_(41) setdest 183779 23261 13.0" 
$ns at 398.19557312098266 "$node_(41) setdest 39804 28474 5.0" 
$ns at 446.96199528399546 "$node_(41) setdest 3593 13 7.0" 
$ns at 504.83192672507107 "$node_(41) setdest 171225 49367 18.0" 
$ns at 601.4589141431801 "$node_(41) setdest 68128 66124 3.0" 
$ns at 639.9546942381005 "$node_(41) setdest 131895 11646 11.0" 
$ns at 695.822966504998 "$node_(41) setdest 101675 6894 14.0" 
$ns at 752.1540974847165 "$node_(41) setdest 113924 8842 7.0" 
$ns at 849.6689491189169 "$node_(41) setdest 146459 7036 19.0" 
$ns at 0.0 "$node_(42) setdest 89769 16498 18.0" 
$ns at 87.6504203276125 "$node_(42) setdest 36276 24042 17.0" 
$ns at 161.93055931458505 "$node_(42) setdest 41341 25503 17.0" 
$ns at 212.13159554519999 "$node_(42) setdest 93317 35493 14.0" 
$ns at 286.04763125116176 "$node_(42) setdest 138586 53141 15.0" 
$ns at 405.9933486634996 "$node_(42) setdest 141493 33001 16.0" 
$ns at 527.6572033142575 "$node_(42) setdest 166275 51713 5.0" 
$ns at 586.8682425455193 "$node_(42) setdest 140573 47757 5.0" 
$ns at 621.0173486662643 "$node_(42) setdest 12732 62721 9.0" 
$ns at 685.384067705194 "$node_(42) setdest 236710 60645 2.0" 
$ns at 724.4542827483978 "$node_(42) setdest 59634 51705 3.0" 
$ns at 773.930937872045 "$node_(42) setdest 1901 56229 3.0" 
$ns at 808.8401521335339 "$node_(42) setdest 16716 47152 8.0" 
$ns at 891.7230165863524 "$node_(42) setdest 209532 61501 3.0" 
$ns at 0.0 "$node_(43) setdest 4221 23880 13.0" 
$ns at 120.818575114136 "$node_(43) setdest 53567 18481 1.0" 
$ns at 151.17872058365353 "$node_(43) setdest 17325 12807 2.0" 
$ns at 191.4474854887142 "$node_(43) setdest 61935 28725 18.0" 
$ns at 312.4463231943515 "$node_(43) setdest 74740 39263 7.0" 
$ns at 347.548557720769 "$node_(43) setdest 83931 12825 5.0" 
$ns at 416.7887767470757 "$node_(43) setdest 114215 10730 11.0" 
$ns at 451.72397135353594 "$node_(43) setdest 96181 3708 16.0" 
$ns at 510.9392677996283 "$node_(43) setdest 198858 47710 2.0" 
$ns at 555.5123453622591 "$node_(43) setdest 86508 20170 17.0" 
$ns at 602.5439048480927 "$node_(43) setdest 213814 50978 1.0" 
$ns at 636.4326837442214 "$node_(43) setdest 160660 61414 7.0" 
$ns at 671.0753676162942 "$node_(43) setdest 120373 36383 17.0" 
$ns at 735.011563197822 "$node_(43) setdest 68913 27378 8.0" 
$ns at 781.3891710087091 "$node_(43) setdest 223178 76030 17.0" 
$ns at 854.8704272087425 "$node_(43) setdest 164072 62030 18.0" 
$ns at 0.0 "$node_(44) setdest 32685 14635 11.0" 
$ns at 69.44010184075917 "$node_(44) setdest 31201 23501 4.0" 
$ns at 107.68199156224152 "$node_(44) setdest 30085 29014 16.0" 
$ns at 222.85672416930743 "$node_(44) setdest 69225 42323 17.0" 
$ns at 413.1930216194395 "$node_(44) setdest 149067 25101 5.0" 
$ns at 467.1847971394931 "$node_(44) setdest 127586 16766 9.0" 
$ns at 530.9669390246364 "$node_(44) setdest 152516 21315 8.0" 
$ns at 595.5607656808925 "$node_(44) setdest 179213 67819 8.0" 
$ns at 664.8118103856735 "$node_(44) setdest 54637 46006 15.0" 
$ns at 710.2639306484865 "$node_(44) setdest 41300 29082 13.0" 
$ns at 850.977729964713 "$node_(44) setdest 155528 12956 18.0" 
$ns at 0.0 "$node_(45) setdest 31991 18047 9.0" 
$ns at 64.83666894177348 "$node_(45) setdest 32743 28424 15.0" 
$ns at 124.3753898186046 "$node_(45) setdest 69236 29269 2.0" 
$ns at 159.81028449713932 "$node_(45) setdest 91970 20767 4.0" 
$ns at 203.90584946767694 "$node_(45) setdest 17372 39525 1.0" 
$ns at 243.67966544236188 "$node_(45) setdest 100305 2834 15.0" 
$ns at 292.3887296243429 "$node_(45) setdest 59724 13698 16.0" 
$ns at 454.57261939374433 "$node_(45) setdest 173622 39604 20.0" 
$ns at 584.767739170692 "$node_(45) setdest 165613 22409 8.0" 
$ns at 665.0847329005776 "$node_(45) setdest 105986 64591 2.0" 
$ns at 713.2782326403518 "$node_(45) setdest 196670 21551 18.0" 
$ns at 786.5871140921511 "$node_(45) setdest 191622 14632 12.0" 
$ns at 899.0306981117535 "$node_(45) setdest 221772 9585 13.0" 
$ns at 0.0 "$node_(46) setdest 74284 10023 18.0" 
$ns at 84.30164916095222 "$node_(46) setdest 70132 12151 2.0" 
$ns at 117.97148773527258 "$node_(46) setdest 69011 26071 13.0" 
$ns at 186.3323319076418 "$node_(46) setdest 32655 26369 1.0" 
$ns at 222.98912672465545 "$node_(46) setdest 82818 22235 4.0" 
$ns at 258.77434443877553 "$node_(46) setdest 159757 28576 8.0" 
$ns at 336.69314827893504 "$node_(46) setdest 115844 1904 5.0" 
$ns at 392.01185618488677 "$node_(46) setdest 87001 23466 8.0" 
$ns at 439.1988960264875 "$node_(46) setdest 94731 34767 17.0" 
$ns at 561.7731285797174 "$node_(46) setdest 60429 45409 11.0" 
$ns at 643.032567969551 "$node_(46) setdest 131222 45875 5.0" 
$ns at 688.2754884172281 "$node_(46) setdest 178604 65334 19.0" 
$ns at 774.5530561566455 "$node_(46) setdest 43078 50902 16.0" 
$ns at 858.709916363974 "$node_(46) setdest 11110 17951 9.0" 
$ns at 0.0 "$node_(47) setdest 7788 22178 1.0" 
$ns at 30.34004103462615 "$node_(47) setdest 79751 16457 15.0" 
$ns at 80.59438448237354 "$node_(47) setdest 30127 28950 20.0" 
$ns at 183.42292690400802 "$node_(47) setdest 16603 44293 13.0" 
$ns at 236.56363375876037 "$node_(47) setdest 51539 13985 6.0" 
$ns at 266.8255483605974 "$node_(47) setdest 76948 11071 3.0" 
$ns at 309.05759824411024 "$node_(47) setdest 74978 6053 13.0" 
$ns at 343.0150131745726 "$node_(47) setdest 159820 54327 1.0" 
$ns at 382.47420592250387 "$node_(47) setdest 123265 12723 8.0" 
$ns at 464.62921507354224 "$node_(47) setdest 4111 17884 4.0" 
$ns at 501.77034456210896 "$node_(47) setdest 15650 51055 3.0" 
$ns at 552.4310504092683 "$node_(47) setdest 19338 52274 16.0" 
$ns at 663.9555563874931 "$node_(47) setdest 129763 23562 11.0" 
$ns at 776.1580933533014 "$node_(47) setdest 19101 60843 14.0" 
$ns at 877.8223224897362 "$node_(47) setdest 235257 65880 10.0" 
$ns at 0.0 "$node_(48) setdest 88590 2460 2.0" 
$ns at 36.15781700579815 "$node_(48) setdest 66280 20980 18.0" 
$ns at 94.14984561055384 "$node_(48) setdest 50791 6379 13.0" 
$ns at 158.05330203390054 "$node_(48) setdest 58683 41163 6.0" 
$ns at 243.93117066344635 "$node_(48) setdest 2878 24894 13.0" 
$ns at 314.2127233037815 "$node_(48) setdest 49799 51657 4.0" 
$ns at 370.0868028034172 "$node_(48) setdest 32664 15050 16.0" 
$ns at 485.0086927178744 "$node_(48) setdest 170969 47307 18.0" 
$ns at 601.8587744657359 "$node_(48) setdest 111400 50089 11.0" 
$ns at 714.7419172887797 "$node_(48) setdest 91162 19682 3.0" 
$ns at 752.4898091799284 "$node_(48) setdest 251215 24026 18.0" 
$ns at 840.0212423027208 "$node_(48) setdest 155770 75512 16.0" 
$ns at 0.0 "$node_(49) setdest 73694 17003 2.0" 
$ns at 36.224265874112504 "$node_(49) setdest 6866 13963 3.0" 
$ns at 87.3931256545425 "$node_(49) setdest 62143 1641 9.0" 
$ns at 192.37296055511527 "$node_(49) setdest 125278 4495 13.0" 
$ns at 230.8379191187407 "$node_(49) setdest 55 29640 19.0" 
$ns at 295.2018896878111 "$node_(49) setdest 37303 14157 15.0" 
$ns at 377.2241799586965 "$node_(49) setdest 102261 13094 5.0" 
$ns at 456.0364593375611 "$node_(49) setdest 20527 14053 14.0" 
$ns at 542.2679716939756 "$node_(49) setdest 46274 63636 4.0" 
$ns at 596.3626842918302 "$node_(49) setdest 87487 32765 20.0" 
$ns at 665.461923682407 "$node_(49) setdest 5864 55260 3.0" 
$ns at 711.0756430055826 "$node_(49) setdest 200748 67669 19.0" 
$ns at 0.0 "$node_(50) setdest 40305 28057 19.0" 
$ns at 87.0607710687891 "$node_(50) setdest 17065 22026 11.0" 
$ns at 170.4940643935851 "$node_(50) setdest 59427 20347 10.0" 
$ns at 245.14566638611228 "$node_(50) setdest 22837 13426 10.0" 
$ns at 373.7765097715695 "$node_(50) setdest 108165 60156 9.0" 
$ns at 435.48210886999675 "$node_(50) setdest 89172 5521 12.0" 
$ns at 499.9801348971332 "$node_(50) setdest 8047 29847 8.0" 
$ns at 607.0395609373793 "$node_(50) setdest 136488 1632 14.0" 
$ns at 742.2740108870767 "$node_(50) setdest 42111 12404 4.0" 
$ns at 811.589934828355 "$node_(50) setdest 140621 72540 8.0" 
$ns at 895.3921853515606 "$node_(50) setdest 212631 19507 4.0" 
$ns at 0.0 "$node_(51) setdest 94336 17876 15.0" 
$ns at 43.140314726375976 "$node_(51) setdest 93744 29099 5.0" 
$ns at 112.32769208434416 "$node_(51) setdest 3977 15485 11.0" 
$ns at 244.81039575739985 "$node_(51) setdest 81122 9970 8.0" 
$ns at 321.76600626902604 "$node_(51) setdest 27502 28925 16.0" 
$ns at 469.7881386670942 "$node_(51) setdest 70322 60936 12.0" 
$ns at 602.8717639782965 "$node_(51) setdest 76863 6869 13.0" 
$ns at 677.3707539357961 "$node_(51) setdest 72624 67158 1.0" 
$ns at 716.1818874413774 "$node_(51) setdest 110727 20916 10.0" 
$ns at 776.5455924204902 "$node_(51) setdest 103047 9178 17.0" 
$ns at 874.0348862808565 "$node_(51) setdest 52934 8267 11.0" 
$ns at 0.0 "$node_(52) setdest 86531 13760 6.0" 
$ns at 84.49310934505165 "$node_(52) setdest 37226 1538 3.0" 
$ns at 130.3079312504875 "$node_(52) setdest 14782 25358 15.0" 
$ns at 185.3833436545664 "$node_(52) setdest 6249 18691 13.0" 
$ns at 231.35514473620597 "$node_(52) setdest 128249 8886 13.0" 
$ns at 384.8918199934825 "$node_(52) setdest 185881 27782 8.0" 
$ns at 444.62497331549184 "$node_(52) setdest 95000 16208 6.0" 
$ns at 501.22628959497706 "$node_(52) setdest 146025 40083 18.0" 
$ns at 639.4728944125693 "$node_(52) setdest 190407 9657 9.0" 
$ns at 743.3651624385691 "$node_(52) setdest 160762 70572 9.0" 
$ns at 809.856639217077 "$node_(52) setdest 192713 10863 9.0" 
$ns at 0.0 "$node_(53) setdest 33198 16312 12.0" 
$ns at 130.7392998765828 "$node_(53) setdest 13985 28862 12.0" 
$ns at 234.5445984287569 "$node_(53) setdest 113423 12792 10.0" 
$ns at 363.09128178347225 "$node_(53) setdest 45085 15600 12.0" 
$ns at 470.9558902654662 "$node_(53) setdest 84075 59744 15.0" 
$ns at 627.1349785447223 "$node_(53) setdest 114704 39465 2.0" 
$ns at 659.7903412702037 "$node_(53) setdest 152906 48529 9.0" 
$ns at 756.5461026049755 "$node_(53) setdest 237192 55683 12.0" 
$ns at 896.3680359751609 "$node_(53) setdest 69101 54078 9.0" 
$ns at 0.0 "$node_(54) setdest 77301 1611 10.0" 
$ns at 78.11975206743003 "$node_(54) setdest 43542 15828 1.0" 
$ns at 116.74716475201656 "$node_(54) setdest 21442 29805 8.0" 
$ns at 161.78268364297298 "$node_(54) setdest 8392 18823 19.0" 
$ns at 300.37867812473144 "$node_(54) setdest 48930 36554 3.0" 
$ns at 340.89139008390123 "$node_(54) setdest 59066 24440 12.0" 
$ns at 452.6735405985306 "$node_(54) setdest 107441 19585 10.0" 
$ns at 483.6498001261144 "$node_(54) setdest 101987 23948 10.0" 
$ns at 528.541411145729 "$node_(54) setdest 3728 46126 10.0" 
$ns at 605.1344346985595 "$node_(54) setdest 22114 6934 11.0" 
$ns at 642.007441488453 "$node_(54) setdest 151976 27986 15.0" 
$ns at 808.0508965766307 "$node_(54) setdest 72474 80804 17.0" 
$ns at 0.0 "$node_(55) setdest 88076 15626 3.0" 
$ns at 51.50024325646897 "$node_(55) setdest 57836 16284 15.0" 
$ns at 94.86656522192388 "$node_(55) setdest 83236 31519 4.0" 
$ns at 136.58762429177483 "$node_(55) setdest 3061 31028 12.0" 
$ns at 277.4331017036839 "$node_(55) setdest 112749 14866 20.0" 
$ns at 399.2237071123828 "$node_(55) setdest 152138 21859 6.0" 
$ns at 462.36547096757414 "$node_(55) setdest 72499 4576 2.0" 
$ns at 508.3237046114889 "$node_(55) setdest 143226 57766 12.0" 
$ns at 656.6820468484106 "$node_(55) setdest 201598 76251 18.0" 
$ns at 775.9698227929962 "$node_(55) setdest 74963 32048 20.0" 
$ns at 0.0 "$node_(56) setdest 40486 20700 1.0" 
$ns at 35.23023730430029 "$node_(56) setdest 7798 26276 8.0" 
$ns at 125.89943779833654 "$node_(56) setdest 60235 25663 14.0" 
$ns at 188.60794584860395 "$node_(56) setdest 76327 3869 18.0" 
$ns at 223.30967178794728 "$node_(56) setdest 8962 35967 9.0" 
$ns at 318.2954320111962 "$node_(56) setdest 80283 35801 8.0" 
$ns at 413.30761192782967 "$node_(56) setdest 132579 20539 16.0" 
$ns at 525.0712634516075 "$node_(56) setdest 60150 64482 1.0" 
$ns at 562.6996261725328 "$node_(56) setdest 156466 27463 15.0" 
$ns at 653.8428306769018 "$node_(56) setdest 16274 75207 17.0" 
$ns at 732.9547743784422 "$node_(56) setdest 206998 50835 15.0" 
$ns at 854.1731309004523 "$node_(56) setdest 200510 12897 2.0" 
$ns at 0.0 "$node_(57) setdest 13197 13173 4.0" 
$ns at 45.34205667910726 "$node_(57) setdest 19653 5540 10.0" 
$ns at 167.65812557124212 "$node_(57) setdest 85639 14839 16.0" 
$ns at 346.1720969291122 "$node_(57) setdest 94694 32261 17.0" 
$ns at 432.7282819635901 "$node_(57) setdest 80566 60237 9.0" 
$ns at 481.0105954003408 "$node_(57) setdest 7410 59066 2.0" 
$ns at 523.5728620617128 "$node_(57) setdest 185723 53688 3.0" 
$ns at 579.2678440773825 "$node_(57) setdest 166778 8078 1.0" 
$ns at 619.1161062780825 "$node_(57) setdest 52600 75072 11.0" 
$ns at 709.9492887940758 "$node_(57) setdest 149393 80691 14.0" 
$ns at 757.3111469145339 "$node_(57) setdest 7888 60825 9.0" 
$ns at 813.8114559104848 "$node_(57) setdest 119364 57677 20.0" 
$ns at 0.0 "$node_(58) setdest 21558 26128 1.0" 
$ns at 35.62970789455351 "$node_(58) setdest 26012 3358 12.0" 
$ns at 80.09168146735294 "$node_(58) setdest 78671 22576 13.0" 
$ns at 158.1777805502506 "$node_(58) setdest 108662 13203 8.0" 
$ns at 215.69831341260408 "$node_(58) setdest 57569 6968 18.0" 
$ns at 343.13253139147406 "$node_(58) setdest 150500 12447 1.0" 
$ns at 378.6250089320697 "$node_(58) setdest 9771 30038 7.0" 
$ns at 466.2305361319426 "$node_(58) setdest 11362 55924 1.0" 
$ns at 505.6912412343786 "$node_(58) setdest 14217 63414 20.0" 
$ns at 662.9392774959094 "$node_(58) setdest 37075 35149 3.0" 
$ns at 703.3539770428005 "$node_(58) setdest 40790 8332 10.0" 
$ns at 790.1159762353326 "$node_(58) setdest 126496 2466 7.0" 
$ns at 877.5366749493878 "$node_(58) setdest 162595 84252 14.0" 
$ns at 0.0 "$node_(59) setdest 39171 26695 15.0" 
$ns at 73.5981283842751 "$node_(59) setdest 27874 20173 10.0" 
$ns at 196.53681020133723 "$node_(59) setdest 31909 2642 12.0" 
$ns at 262.54740656341335 "$node_(59) setdest 52446 49198 3.0" 
$ns at 305.0397265670535 "$node_(59) setdest 34578 22186 18.0" 
$ns at 403.53533869646674 "$node_(59) setdest 9301 51110 16.0" 
$ns at 442.86595727262284 "$node_(59) setdest 130249 5264 4.0" 
$ns at 502.8054068105858 "$node_(59) setdest 201280 32560 8.0" 
$ns at 573.6049402077131 "$node_(59) setdest 9658 52075 7.0" 
$ns at 623.0409775872298 "$node_(59) setdest 149402 47591 10.0" 
$ns at 654.8555618096389 "$node_(59) setdest 137556 76650 18.0" 
$ns at 857.0704510552159 "$node_(59) setdest 254531 80357 19.0" 
$ns at 0.0 "$node_(60) setdest 53466 16922 13.0" 
$ns at 67.6302782066382 "$node_(60) setdest 82781 10373 20.0" 
$ns at 107.84445038937976 "$node_(60) setdest 61193 14381 9.0" 
$ns at 168.7802276984272 "$node_(60) setdest 108420 7018 1.0" 
$ns at 204.534906992092 "$node_(60) setdest 60448 4333 3.0" 
$ns at 246.75094067390344 "$node_(60) setdest 56413 14837 5.0" 
$ns at 302.6673318851648 "$node_(60) setdest 89302 34383 10.0" 
$ns at 378.27030318058695 "$node_(60) setdest 182129 4397 13.0" 
$ns at 425.8020165641651 "$node_(60) setdest 87488 19435 8.0" 
$ns at 527.3209792321255 "$node_(60) setdest 209937 23161 7.0" 
$ns at 558.4799923727554 "$node_(60) setdest 153772 25914 8.0" 
$ns at 609.9939618381942 "$node_(60) setdest 178423 14347 3.0" 
$ns at 649.8072119984001 "$node_(60) setdest 49548 64548 18.0" 
$ns at 846.0602718220209 "$node_(60) setdest 206858 36439 11.0" 
$ns at 894.7546691707574 "$node_(60) setdest 90245 78069 5.0" 
$ns at 0.0 "$node_(61) setdest 9281 22407 6.0" 
$ns at 85.17053142480393 "$node_(61) setdest 15759 21129 4.0" 
$ns at 145.9795817288404 "$node_(61) setdest 70397 15423 7.0" 
$ns at 217.85132171893437 "$node_(61) setdest 46259 15838 12.0" 
$ns at 302.10185585227777 "$node_(61) setdest 159520 2907 6.0" 
$ns at 369.95949822910063 "$node_(61) setdest 58644 61893 17.0" 
$ns at 408.21567478565015 "$node_(61) setdest 56753 38371 13.0" 
$ns at 511.02351286318043 "$node_(61) setdest 81796 42985 12.0" 
$ns at 641.3019991876503 "$node_(61) setdest 185261 39338 6.0" 
$ns at 704.3660641508915 "$node_(61) setdest 14402 57787 3.0" 
$ns at 749.5245004842585 "$node_(61) setdest 180636 48967 10.0" 
$ns at 856.8389764355744 "$node_(61) setdest 4021 6578 15.0" 
$ns at 0.0 "$node_(62) setdest 65842 16365 8.0" 
$ns at 108.80135003588508 "$node_(62) setdest 81133 9911 16.0" 
$ns at 276.53052644321804 "$node_(62) setdest 157439 30181 19.0" 
$ns at 479.2176438639983 "$node_(62) setdest 114771 12811 2.0" 
$ns at 510.5456554773287 "$node_(62) setdest 81336 5337 16.0" 
$ns at 576.423814915922 "$node_(62) setdest 229054 38812 18.0" 
$ns at 642.8035130922254 "$node_(62) setdest 63477 63962 18.0" 
$ns at 720.2722031813885 "$node_(62) setdest 94013 60264 18.0" 
$ns at 801.4510543366523 "$node_(62) setdest 46609 65328 14.0" 
$ns at 0.0 "$node_(63) setdest 8327 26993 8.0" 
$ns at 64.09563274840619 "$node_(63) setdest 17733 21372 7.0" 
$ns at 101.51038078211434 "$node_(63) setdest 31984 22039 1.0" 
$ns at 136.26375064376484 "$node_(63) setdest 49546 22324 19.0" 
$ns at 227.03892339261105 "$node_(63) setdest 118115 20363 15.0" 
$ns at 292.2002781890933 "$node_(63) setdest 45455 23356 4.0" 
$ns at 330.12912660951116 "$node_(63) setdest 70032 9800 15.0" 
$ns at 505.8564142367254 "$node_(63) setdest 144338 44822 10.0" 
$ns at 594.5802020978805 "$node_(63) setdest 137887 50507 6.0" 
$ns at 635.2304603561797 "$node_(63) setdest 69230 33966 7.0" 
$ns at 734.9607837895286 "$node_(63) setdest 134798 52685 14.0" 
$ns at 873.766921308975 "$node_(63) setdest 246977 35820 15.0" 
$ns at 0.0 "$node_(64) setdest 57463 17905 1.0" 
$ns at 32.515013371906804 "$node_(64) setdest 13314 14211 4.0" 
$ns at 63.40524587468142 "$node_(64) setdest 60904 7277 5.0" 
$ns at 112.28840642066744 "$node_(64) setdest 80111 19164 14.0" 
$ns at 177.82244610447333 "$node_(64) setdest 106063 38036 11.0" 
$ns at 267.6979932815344 "$node_(64) setdest 18873 42531 13.0" 
$ns at 416.78628678683674 "$node_(64) setdest 175788 43554 5.0" 
$ns at 489.22483954543657 "$node_(64) setdest 58460 9743 13.0" 
$ns at 528.9007447451993 "$node_(64) setdest 14291 12715 16.0" 
$ns at 628.2149746135804 "$node_(64) setdest 17055 68510 7.0" 
$ns at 704.4004900427767 "$node_(64) setdest 95958 3343 10.0" 
$ns at 811.1164650383989 "$node_(64) setdest 61958 31859 6.0" 
$ns at 871.3975343695975 "$node_(64) setdest 177423 87765 2.0" 
$ns at 0.0 "$node_(65) setdest 81625 25783 6.0" 
$ns at 58.793346949477716 "$node_(65) setdest 33938 29461 11.0" 
$ns at 135.1464865250168 "$node_(65) setdest 45211 12470 20.0" 
$ns at 277.84261124114266 "$node_(65) setdest 93476 49433 6.0" 
$ns at 367.5284090917146 "$node_(65) setdest 113168 62127 1.0" 
$ns at 406.77163187972 "$node_(65) setdest 107167 56873 19.0" 
$ns at 593.2966493188811 "$node_(65) setdest 38321 5470 1.0" 
$ns at 626.8172941323545 "$node_(65) setdest 170131 40187 4.0" 
$ns at 671.0659982714919 "$node_(65) setdest 73759 69152 6.0" 
$ns at 738.0061987294257 "$node_(65) setdest 10941 10847 12.0" 
$ns at 770.7920821128232 "$node_(65) setdest 14380 81835 6.0" 
$ns at 835.7419828274973 "$node_(65) setdest 112172 69548 6.0" 
$ns at 0.0 "$node_(66) setdest 28877 26479 10.0" 
$ns at 47.998042757859196 "$node_(66) setdest 55347 6726 13.0" 
$ns at 106.370227493703 "$node_(66) setdest 76540 25548 12.0" 
$ns at 200.20001395755668 "$node_(66) setdest 41091 30494 19.0" 
$ns at 384.7631832249681 "$node_(66) setdest 18761 27555 8.0" 
$ns at 482.87655356294977 "$node_(66) setdest 21479 26940 18.0" 
$ns at 543.7742067587455 "$node_(66) setdest 186347 51856 17.0" 
$ns at 730.6081418812905 "$node_(66) setdest 196636 59562 7.0" 
$ns at 765.8217209324545 "$node_(66) setdest 235869 19752 10.0" 
$ns at 821.0902321998063 "$node_(66) setdest 128021 66030 19.0" 
$ns at 0.0 "$node_(67) setdest 45288 4568 14.0" 
$ns at 61.86011815146598 "$node_(67) setdest 89590 15333 8.0" 
$ns at 165.49476252277236 "$node_(67) setdest 69916 3598 7.0" 
$ns at 255.08143132066274 "$node_(67) setdest 56907 53432 9.0" 
$ns at 358.4986797109704 "$node_(67) setdest 21761 27997 15.0" 
$ns at 523.8969688255951 "$node_(67) setdest 169862 10816 6.0" 
$ns at 568.5351540337451 "$node_(67) setdest 81758 51421 16.0" 
$ns at 693.1379051686785 "$node_(67) setdest 87615 6380 7.0" 
$ns at 778.5235344126854 "$node_(67) setdest 62524 6279 15.0" 
$ns at 815.0308742632405 "$node_(67) setdest 52668 3567 13.0" 
$ns at 882.5944462492293 "$node_(67) setdest 68693 64270 1.0" 
$ns at 0.0 "$node_(68) setdest 31946 16095 5.0" 
$ns at 31.42747997319549 "$node_(68) setdest 39640 22637 18.0" 
$ns at 235.73838584486833 "$node_(68) setdest 124687 687 1.0" 
$ns at 274.29546780071735 "$node_(68) setdest 101311 43284 12.0" 
$ns at 385.7279239878836 "$node_(68) setdest 6732 25858 12.0" 
$ns at 517.9042503474286 "$node_(68) setdest 146563 9464 11.0" 
$ns at 573.0208124669365 "$node_(68) setdest 135355 8388 6.0" 
$ns at 636.4443778834193 "$node_(68) setdest 136251 60869 5.0" 
$ns at 688.7850730414422 "$node_(68) setdest 167337 20676 2.0" 
$ns at 737.7752494741901 "$node_(68) setdest 96776 6380 12.0" 
$ns at 832.6429625244298 "$node_(68) setdest 149923 76717 15.0" 
$ns at 0.0 "$node_(69) setdest 18215 28454 1.0" 
$ns at 36.92751016294042 "$node_(69) setdest 2328 15466 1.0" 
$ns at 75.90411917965423 "$node_(69) setdest 9890 26516 10.0" 
$ns at 120.87260195501369 "$node_(69) setdest 78310 28542 1.0" 
$ns at 158.56030839834736 "$node_(69) setdest 103312 18071 8.0" 
$ns at 218.6774331584152 "$node_(69) setdest 68504 33099 13.0" 
$ns at 375.66799778746406 "$node_(69) setdest 48933 58071 20.0" 
$ns at 428.42863638929833 "$node_(69) setdest 164082 19565 1.0" 
$ns at 464.25093095046986 "$node_(69) setdest 49783 56638 7.0" 
$ns at 523.5162989521252 "$node_(69) setdest 132664 62244 8.0" 
$ns at 617.1307598432002 "$node_(69) setdest 159751 22248 11.0" 
$ns at 648.9577822132551 "$node_(69) setdest 76974 10699 17.0" 
$ns at 679.6330799732497 "$node_(69) setdest 170151 70225 13.0" 
$ns at 782.4648540652975 "$node_(69) setdest 111907 61425 12.0" 
$ns at 837.660133817538 "$node_(69) setdest 232752 69522 3.0" 
$ns at 885.8167770786241 "$node_(69) setdest 245908 66818 11.0" 
$ns at 0.0 "$node_(70) setdest 76036 28279 4.0" 
$ns at 46.25573176415242 "$node_(70) setdest 36717 14078 10.0" 
$ns at 81.30711484843411 "$node_(70) setdest 18151 2480 1.0" 
$ns at 119.84527273706182 "$node_(70) setdest 87351 10590 17.0" 
$ns at 193.75844447035394 "$node_(70) setdest 91385 9378 5.0" 
$ns at 230.49542403552044 "$node_(70) setdest 47327 2175 2.0" 
$ns at 263.33079666928563 "$node_(70) setdest 137934 46619 2.0" 
$ns at 312.39152629692023 "$node_(70) setdest 5264 12154 18.0" 
$ns at 438.29505931788526 "$node_(70) setdest 68775 31930 15.0" 
$ns at 526.5086763247909 "$node_(70) setdest 162778 6035 6.0" 
$ns at 564.2264485992591 "$node_(70) setdest 169231 34974 9.0" 
$ns at 659.4933196228685 "$node_(70) setdest 203643 30887 19.0" 
$ns at 798.3790866725478 "$node_(70) setdest 211775 39652 4.0" 
$ns at 861.9562056642463 "$node_(70) setdest 267373 37074 14.0" 
$ns at 0.0 "$node_(71) setdest 4006 24343 6.0" 
$ns at 87.91231820227193 "$node_(71) setdest 36593 20111 10.0" 
$ns at 188.2910279250632 "$node_(71) setdest 75594 20836 16.0" 
$ns at 367.61411082913014 "$node_(71) setdest 9856 46190 12.0" 
$ns at 400.05789307122444 "$node_(71) setdest 160784 43149 1.0" 
$ns at 432.1320269883025 "$node_(71) setdest 160917 17424 10.0" 
$ns at 503.64200178441195 "$node_(71) setdest 7966 34402 19.0" 
$ns at 591.1767861544612 "$node_(71) setdest 65734 47599 2.0" 
$ns at 640.0809501706889 "$node_(71) setdest 66731 47728 5.0" 
$ns at 690.9838149065308 "$node_(71) setdest 216864 14142 1.0" 
$ns at 722.757705440985 "$node_(71) setdest 59916 79600 9.0" 
$ns at 785.4161812254375 "$node_(71) setdest 140388 51599 5.0" 
$ns at 818.4065306039088 "$node_(71) setdest 230746 65144 16.0" 
$ns at 866.5859576078137 "$node_(71) setdest 264437 26670 3.0" 
$ns at 0.0 "$node_(72) setdest 11860 24087 14.0" 
$ns at 110.9989794905828 "$node_(72) setdest 18665 18481 14.0" 
$ns at 211.25936975566157 "$node_(72) setdest 37430 8794 9.0" 
$ns at 277.70279545138214 "$node_(72) setdest 28277 52333 1.0" 
$ns at 311.50643364694827 "$node_(72) setdest 110716 30628 10.0" 
$ns at 432.48822200910286 "$node_(72) setdest 166801 36581 7.0" 
$ns at 531.9055548932263 "$node_(72) setdest 87866 8837 5.0" 
$ns at 585.2561009762792 "$node_(72) setdest 4334 14968 3.0" 
$ns at 636.4080509960413 "$node_(72) setdest 70153 67811 8.0" 
$ns at 740.9387108052531 "$node_(72) setdest 204975 40154 16.0" 
$ns at 812.8611620778288 "$node_(72) setdest 218940 50225 8.0" 
$ns at 0.0 "$node_(73) setdest 18062 343 9.0" 
$ns at 60.01090990995827 "$node_(73) setdest 11202 20367 18.0" 
$ns at 113.43517013911266 "$node_(73) setdest 85604 5815 4.0" 
$ns at 154.9835180912755 "$node_(73) setdest 43053 5825 17.0" 
$ns at 308.14608502865144 "$node_(73) setdest 92815 42727 14.0" 
$ns at 356.7969736630387 "$node_(73) setdest 96270 36456 15.0" 
$ns at 517.9575449903676 "$node_(73) setdest 129186 2889 11.0" 
$ns at 638.384372330494 "$node_(73) setdest 55769 60081 7.0" 
$ns at 723.0459682881989 "$node_(73) setdest 145817 34209 2.0" 
$ns at 761.171368673495 "$node_(73) setdest 146921 80552 4.0" 
$ns at 813.7350433029444 "$node_(73) setdest 101719 29296 14.0" 
$ns at 0.0 "$node_(74) setdest 59606 3819 12.0" 
$ns at 60.03439950233537 "$node_(74) setdest 27987 23505 12.0" 
$ns at 157.09071570707044 "$node_(74) setdest 101617 43089 14.0" 
$ns at 250.48490028696776 "$node_(74) setdest 159716 11252 16.0" 
$ns at 372.6813747876077 "$node_(74) setdest 25998 59369 9.0" 
$ns at 454.8231820797737 "$node_(74) setdest 136592 50059 13.0" 
$ns at 526.7049233199016 "$node_(74) setdest 143708 13888 1.0" 
$ns at 563.1782498864399 "$node_(74) setdest 62285 51725 1.0" 
$ns at 594.8140971616274 "$node_(74) setdest 220169 18361 9.0" 
$ns at 628.3803288267636 "$node_(74) setdest 96460 53010 6.0" 
$ns at 659.8502268420069 "$node_(74) setdest 196339 78954 17.0" 
$ns at 822.8750694450531 "$node_(74) setdest 7941 87172 10.0" 
$ns at 868.7714506065008 "$node_(74) setdest 77019 40778 3.0" 
$ns at 0.0 "$node_(75) setdest 40214 19860 8.0" 
$ns at 63.05074852931413 "$node_(75) setdest 21346 20710 15.0" 
$ns at 223.85191103124743 "$node_(75) setdest 16011 3422 11.0" 
$ns at 329.0287119214578 "$node_(75) setdest 4496 15286 20.0" 
$ns at 497.491491315506 "$node_(75) setdest 84336 29940 1.0" 
$ns at 532.7696652025957 "$node_(75) setdest 193933 66477 9.0" 
$ns at 637.9114053269003 "$node_(75) setdest 156946 40759 1.0" 
$ns at 669.2846660789194 "$node_(75) setdest 216942 46726 20.0" 
$ns at 746.1533521284616 "$node_(75) setdest 16707 81778 16.0" 
$ns at 796.1011191946209 "$node_(75) setdest 113265 88413 8.0" 
$ns at 841.9337344850605 "$node_(75) setdest 199517 33863 13.0" 
$ns at 0.0 "$node_(76) setdest 55039 26940 19.0" 
$ns at 150.91663382539826 "$node_(76) setdest 129174 24646 6.0" 
$ns at 189.97513701412015 "$node_(76) setdest 30247 38019 5.0" 
$ns at 243.64780382307185 "$node_(76) setdest 116267 25904 2.0" 
$ns at 292.714999389973 "$node_(76) setdest 145862 4058 4.0" 
$ns at 325.3296790327748 "$node_(76) setdest 69824 45435 18.0" 
$ns at 494.0527273403125 "$node_(76) setdest 165046 5758 1.0" 
$ns at 531.1886851245803 "$node_(76) setdest 27696 24102 11.0" 
$ns at 588.5165086200897 "$node_(76) setdest 82813 58945 7.0" 
$ns at 660.6432762863728 "$node_(76) setdest 77966 19259 5.0" 
$ns at 712.6820073062922 "$node_(76) setdest 229793 21191 4.0" 
$ns at 772.2673633631902 "$node_(76) setdest 45086 735 14.0" 
$ns at 818.5747556585887 "$node_(76) setdest 247031 40014 6.0" 
$ns at 893.2777818128942 "$node_(76) setdest 245767 84923 6.0" 
$ns at 0.0 "$node_(77) setdest 8735 26025 18.0" 
$ns at 128.5573491195703 "$node_(77) setdest 58679 28822 10.0" 
$ns at 200.86053441024202 "$node_(77) setdest 63061 29416 19.0" 
$ns at 296.21214942458556 "$node_(77) setdest 98859 13553 3.0" 
$ns at 327.36686027068225 "$node_(77) setdest 155962 47608 15.0" 
$ns at 415.7425496442578 "$node_(77) setdest 103587 44735 4.0" 
$ns at 471.5770063654991 "$node_(77) setdest 4571 744 19.0" 
$ns at 587.7516630236868 "$node_(77) setdest 145639 36484 19.0" 
$ns at 758.9202749865981 "$node_(77) setdest 192202 17020 14.0" 
$ns at 793.0152755723384 "$node_(77) setdest 83953 63427 1.0" 
$ns at 831.1807459443934 "$node_(77) setdest 261329 83654 10.0" 
$ns at 0.0 "$node_(78) setdest 65341 9971 3.0" 
$ns at 46.79251065400137 "$node_(78) setdest 89549 8406 15.0" 
$ns at 178.51375889844405 "$node_(78) setdest 55292 31513 3.0" 
$ns at 231.39798539204648 "$node_(78) setdest 126639 22526 5.0" 
$ns at 265.1842656828553 "$node_(78) setdest 110310 45092 17.0" 
$ns at 351.7974194500743 "$node_(78) setdest 12945 36777 16.0" 
$ns at 397.8616925386988 "$node_(78) setdest 143283 48226 15.0" 
$ns at 450.60544021125736 "$node_(78) setdest 145259 61765 12.0" 
$ns at 528.5378802659104 "$node_(78) setdest 20918 44102 17.0" 
$ns at 681.6891603580498 "$node_(78) setdest 77302 68375 14.0" 
$ns at 767.5643926882834 "$node_(78) setdest 246242 47104 15.0" 
$ns at 0.0 "$node_(79) setdest 55639 26741 18.0" 
$ns at 38.9578042897815 "$node_(79) setdest 75597 28695 3.0" 
$ns at 88.29984397213101 "$node_(79) setdest 37332 12607 5.0" 
$ns at 167.09875634627758 "$node_(79) setdest 112980 22328 19.0" 
$ns at 384.31934237504316 "$node_(79) setdest 49030 2209 17.0" 
$ns at 476.1675486228646 "$node_(79) setdest 55791 45380 19.0" 
$ns at 646.0989870533887 "$node_(79) setdest 145855 70623 18.0" 
$ns at 706.2052188300371 "$node_(79) setdest 124783 67942 20.0" 
$ns at 848.1272615576271 "$node_(79) setdest 186092 13771 3.0" 
$ns at 892.1020897802478 "$node_(79) setdest 64440 46821 9.0" 
$ns at 0.0 "$node_(80) setdest 73871 27854 10.0" 
$ns at 35.53988061629143 "$node_(80) setdest 94343 31163 3.0" 
$ns at 81.3419757446783 "$node_(80) setdest 48861 28781 1.0" 
$ns at 117.38468928144874 "$node_(80) setdest 32 5365 6.0" 
$ns at 202.2200441587949 "$node_(80) setdest 40958 18329 1.0" 
$ns at 241.78527543590897 "$node_(80) setdest 88853 7894 15.0" 
$ns at 335.41710613927046 "$node_(80) setdest 132262 877 9.0" 
$ns at 402.7371779422103 "$node_(80) setdest 158257 2982 6.0" 
$ns at 492.58302220544465 "$node_(80) setdest 87763 13221 17.0" 
$ns at 536.8038785222669 "$node_(80) setdest 122193 29327 17.0" 
$ns at 686.4663149462313 "$node_(80) setdest 3605 68036 14.0" 
$ns at 801.6184699049517 "$node_(80) setdest 66308 57262 1.0" 
$ns at 837.3046162449417 "$node_(80) setdest 119884 31513 5.0" 
$ns at 0.0 "$node_(81) setdest 4372 10326 12.0" 
$ns at 75.67641676632685 "$node_(81) setdest 43303 286 16.0" 
$ns at 199.48003778703367 "$node_(81) setdest 48847 15939 2.0" 
$ns at 248.37252045319838 "$node_(81) setdest 14078 32607 13.0" 
$ns at 351.4883313450455 "$node_(81) setdest 106730 53610 18.0" 
$ns at 468.1832449625393 "$node_(81) setdest 186841 1924 15.0" 
$ns at 570.2437820865326 "$node_(81) setdest 9134 51962 15.0" 
$ns at 620.6732780880103 "$node_(81) setdest 232245 71118 19.0" 
$ns at 699.0705982867568 "$node_(81) setdest 174891 35472 2.0" 
$ns at 745.0029734956042 "$node_(81) setdest 158127 39399 18.0" 
$ns at 796.3321009327716 "$node_(81) setdest 46837 756 3.0" 
$ns at 846.9031091156868 "$node_(81) setdest 10059 67551 5.0" 
$ns at 897.4659536336524 "$node_(81) setdest 123589 17961 13.0" 
$ns at 0.0 "$node_(82) setdest 83352 6321 14.0" 
$ns at 88.30155418298463 "$node_(82) setdest 70567 27357 14.0" 
$ns at 196.1357364319361 "$node_(82) setdest 18715 28286 6.0" 
$ns at 275.9652609033198 "$node_(82) setdest 102153 38347 7.0" 
$ns at 351.2081303024002 "$node_(82) setdest 86070 32918 4.0" 
$ns at 409.03550658004224 "$node_(82) setdest 4804 42140 18.0" 
$ns at 541.6094858530624 "$node_(82) setdest 167203 12890 17.0" 
$ns at 720.9764605068875 "$node_(82) setdest 119657 40687 12.0" 
$ns at 815.21931319217 "$node_(82) setdest 197838 88454 19.0" 
$ns at 0.0 "$node_(83) setdest 51236 27343 4.0" 
$ns at 66.02893782289848 "$node_(83) setdest 86330 26086 17.0" 
$ns at 161.19288577549668 "$node_(83) setdest 77973 14314 13.0" 
$ns at 315.0498523922305 "$node_(83) setdest 24962 17976 6.0" 
$ns at 398.88904725091845 "$node_(83) setdest 37585 49052 11.0" 
$ns at 441.3752331797044 "$node_(83) setdest 111605 42960 14.0" 
$ns at 569.8150788220619 "$node_(83) setdest 217556 23300 10.0" 
$ns at 627.8551153813537 "$node_(83) setdest 168842 74183 3.0" 
$ns at 667.1292081591666 "$node_(83) setdest 37941 54462 6.0" 
$ns at 712.5330848007031 "$node_(83) setdest 27200 28200 5.0" 
$ns at 766.1777905852992 "$node_(83) setdest 35601 44448 9.0" 
$ns at 839.3832942283409 "$node_(83) setdest 66027 56942 12.0" 
$ns at 0.0 "$node_(84) setdest 80910 15540 16.0" 
$ns at 110.83122175151489 "$node_(84) setdest 79275 3 13.0" 
$ns at 209.03226054400267 "$node_(84) setdest 127733 25263 2.0" 
$ns at 258.01072849482046 "$node_(84) setdest 79149 39463 2.0" 
$ns at 305.4995342987132 "$node_(84) setdest 135655 5306 15.0" 
$ns at 463.5276405246269 "$node_(84) setdest 89968 34009 8.0" 
$ns at 532.2850807561924 "$node_(84) setdest 196127 60537 17.0" 
$ns at 677.211803436683 "$node_(84) setdest 1041 44414 6.0" 
$ns at 755.7695325951805 "$node_(84) setdest 170237 76479 1.0" 
$ns at 789.3738114014805 "$node_(84) setdest 230311 50700 16.0" 
$ns at 0.0 "$node_(85) setdest 32635 16203 18.0" 
$ns at 65.91053718731479 "$node_(85) setdest 7451 10699 13.0" 
$ns at 150.27112591395013 "$node_(85) setdest 76273 34376 1.0" 
$ns at 184.70924982739936 "$node_(85) setdest 110897 11040 17.0" 
$ns at 370.25372976891106 "$node_(85) setdest 45552 3132 15.0" 
$ns at 529.915723503209 "$node_(85) setdest 29962 32460 7.0" 
$ns at 615.3515729506425 "$node_(85) setdest 122875 17089 12.0" 
$ns at 732.5437744905404 "$node_(85) setdest 232554 25309 10.0" 
$ns at 806.6212921133779 "$node_(85) setdest 216633 83125 9.0" 
$ns at 0.0 "$node_(86) setdest 34053 30492 5.0" 
$ns at 52.25420806845443 "$node_(86) setdest 59134 30915 2.0" 
$ns at 100.92204286459489 "$node_(86) setdest 19219 24075 6.0" 
$ns at 185.47026016040837 "$node_(86) setdest 106176 27722 20.0" 
$ns at 352.92276731530586 "$node_(86) setdest 146038 31815 3.0" 
$ns at 394.65001115889515 "$node_(86) setdest 183950 58941 3.0" 
$ns at 434.78597245175325 "$node_(86) setdest 97823 45166 10.0" 
$ns at 516.9326757744974 "$node_(86) setdest 70430 45518 10.0" 
$ns at 557.2381248384461 "$node_(86) setdest 117544 57232 3.0" 
$ns at 606.5202931614085 "$node_(86) setdest 47183 6331 15.0" 
$ns at 675.6690436844405 "$node_(86) setdest 61287 83262 9.0" 
$ns at 709.779255138876 "$node_(86) setdest 191614 9620 17.0" 
$ns at 875.3369459260841 "$node_(86) setdest 160793 80381 17.0" 
$ns at 0.0 "$node_(87) setdest 18438 7882 16.0" 
$ns at 49.201071377418245 "$node_(87) setdest 77660 7142 11.0" 
$ns at 94.97913846607491 "$node_(87) setdest 82670 8356 16.0" 
$ns at 212.5381603951286 "$node_(87) setdest 116500 41857 7.0" 
$ns at 249.88848628100715 "$node_(87) setdest 63287 1686 17.0" 
$ns at 369.6783186528041 "$node_(87) setdest 111234 45634 4.0" 
$ns at 414.6118295420879 "$node_(87) setdest 20454 28581 16.0" 
$ns at 572.7309775493745 "$node_(87) setdest 89999 62471 12.0" 
$ns at 700.3181709727381 "$node_(87) setdest 213749 44012 19.0" 
$ns at 0.0 "$node_(88) setdest 48313 24090 19.0" 
$ns at 100.23816292688052 "$node_(88) setdest 24806 5371 18.0" 
$ns at 137.56243654243843 "$node_(88) setdest 3524 11318 13.0" 
$ns at 272.3108011639005 "$node_(88) setdest 127499 11089 2.0" 
$ns at 309.8951936078152 "$node_(88) setdest 31931 39646 17.0" 
$ns at 458.40754163376664 "$node_(88) setdest 18441 37570 13.0" 
$ns at 546.7415035701143 "$node_(88) setdest 135565 23482 7.0" 
$ns at 612.8080671504504 "$node_(88) setdest 199030 49240 12.0" 
$ns at 719.3158589982007 "$node_(88) setdest 189337 48459 13.0" 
$ns at 863.8718369656658 "$node_(88) setdest 104512 66994 6.0" 
$ns at 0.0 "$node_(89) setdest 16085 31028 18.0" 
$ns at 88.04937478996135 "$node_(89) setdest 11975 12175 1.0" 
$ns at 124.35934027768927 "$node_(89) setdest 207 8026 15.0" 
$ns at 171.5171308319022 "$node_(89) setdest 9094 4548 11.0" 
$ns at 210.38671146504015 "$node_(89) setdest 74832 35629 15.0" 
$ns at 246.10955328528814 "$node_(89) setdest 66775 28991 2.0" 
$ns at 280.6435014063874 "$node_(89) setdest 78299 19242 7.0" 
$ns at 320.3172420045903 "$node_(89) setdest 100745 48684 14.0" 
$ns at 399.44683775464466 "$node_(89) setdest 107155 53881 9.0" 
$ns at 502.34548383433855 "$node_(89) setdest 196974 10482 3.0" 
$ns at 536.931207505476 "$node_(89) setdest 169615 52293 4.0" 
$ns at 598.9677720734092 "$node_(89) setdest 131511 67673 13.0" 
$ns at 670.0524389369905 "$node_(89) setdest 61456 21562 1.0" 
$ns at 709.6134502238804 "$node_(89) setdest 199251 63364 14.0" 
$ns at 803.1600522330857 "$node_(89) setdest 232653 44765 3.0" 
$ns at 856.8943601085718 "$node_(89) setdest 115196 63900 19.0" 
$ns at 0.0 "$node_(90) setdest 46390 7317 1.0" 
$ns at 32.238745175285516 "$node_(90) setdest 91613 11402 6.0" 
$ns at 122.02965638373763 "$node_(90) setdest 35095 23508 6.0" 
$ns at 154.858388512607 "$node_(90) setdest 72377 39537 17.0" 
$ns at 354.3721347880971 "$node_(90) setdest 28491 17654 18.0" 
$ns at 559.8125434814458 "$node_(90) setdest 23178 35377 16.0" 
$ns at 674.0381841569858 "$node_(90) setdest 37265 65356 1.0" 
$ns at 707.4576870925262 "$node_(90) setdest 98716 48364 9.0" 
$ns at 811.0241016297698 "$node_(90) setdest 67288 88680 14.0" 
$ns at 0.0 "$node_(91) setdest 59647 31554 11.0" 
$ns at 115.35196887734273 "$node_(91) setdest 83300 5379 15.0" 
$ns at 226.98983410316634 "$node_(91) setdest 125168 4941 13.0" 
$ns at 306.5430102382554 "$node_(91) setdest 126877 52151 15.0" 
$ns at 340.97290346061106 "$node_(91) setdest 158252 52971 4.0" 
$ns at 375.8679362639623 "$node_(91) setdest 111427 7137 20.0" 
$ns at 416.8853021710221 "$node_(91) setdest 54542 18883 13.0" 
$ns at 470.07132385654785 "$node_(91) setdest 111588 18401 5.0" 
$ns at 537.5574948604877 "$node_(91) setdest 84541 13782 16.0" 
$ns at 615.1058606863633 "$node_(91) setdest 118006 56137 19.0" 
$ns at 819.9601892336982 "$node_(91) setdest 126479 29989 12.0" 
$ns at 0.0 "$node_(92) setdest 57686 5235 14.0" 
$ns at 118.91301116203273 "$node_(92) setdest 21891 28874 14.0" 
$ns at 239.32222704330974 "$node_(92) setdest 101509 29657 3.0" 
$ns at 272.88377421295297 "$node_(92) setdest 88790 35627 5.0" 
$ns at 344.14132002599354 "$node_(92) setdest 153370 17383 12.0" 
$ns at 408.95842856749067 "$node_(92) setdest 109495 34632 5.0" 
$ns at 460.8764613137172 "$node_(92) setdest 74207 43888 2.0" 
$ns at 501.40262451593804 "$node_(92) setdest 149348 18382 14.0" 
$ns at 568.7031799307092 "$node_(92) setdest 82298 9787 19.0" 
$ns at 690.493589663019 "$node_(92) setdest 101716 20877 14.0" 
$ns at 822.8761089558767 "$node_(92) setdest 13143 16174 8.0" 
$ns at 857.3430651486907 "$node_(92) setdest 240313 9237 19.0" 
$ns at 0.0 "$node_(93) setdest 81516 23395 11.0" 
$ns at 119.22628502558194 "$node_(93) setdest 25524 21005 16.0" 
$ns at 193.9405912635719 "$node_(93) setdest 72332 24048 6.0" 
$ns at 252.29209618642005 "$node_(93) setdest 49067 47617 1.0" 
$ns at 288.1791004718038 "$node_(93) setdest 58472 7132 16.0" 
$ns at 364.79080525571885 "$node_(93) setdest 47664 27749 12.0" 
$ns at 514.6961811451894 "$node_(93) setdest 93115 40918 16.0" 
$ns at 606.3594869375289 "$node_(93) setdest 76878 62802 2.0" 
$ns at 646.6958409939356 "$node_(93) setdest 123887 61741 1.0" 
$ns at 680.469280431668 "$node_(93) setdest 153900 80959 12.0" 
$ns at 768.3394721528916 "$node_(93) setdest 172528 74241 15.0" 
$ns at 0.0 "$node_(94) setdest 55497 1455 18.0" 
$ns at 100.33917492164828 "$node_(94) setdest 29216 18403 14.0" 
$ns at 256.63449913676715 "$node_(94) setdest 107107 48035 18.0" 
$ns at 297.47684916536804 "$node_(94) setdest 81471 41990 18.0" 
$ns at 423.49606941301073 "$node_(94) setdest 43011 53776 2.0" 
$ns at 470.58865560067386 "$node_(94) setdest 74819 6854 2.0" 
$ns at 509.50911892571736 "$node_(94) setdest 55925 52803 1.0" 
$ns at 548.7105558839944 "$node_(94) setdest 63303 69587 11.0" 
$ns at 643.4876757552722 "$node_(94) setdest 81159 33642 4.0" 
$ns at 699.1182982576744 "$node_(94) setdest 51427 22267 17.0" 
$ns at 836.4037574367557 "$node_(94) setdest 191928 51096 14.0" 
$ns at 0.0 "$node_(95) setdest 61315 23237 14.0" 
$ns at 169.19385872698152 "$node_(95) setdest 105412 31833 9.0" 
$ns at 284.59823152101563 "$node_(95) setdest 75441 26336 15.0" 
$ns at 440.71825357152375 "$node_(95) setdest 23094 28987 1.0" 
$ns at 476.2992890425968 "$node_(95) setdest 21222 23110 6.0" 
$ns at 542.3202992726882 "$node_(95) setdest 186174 39230 12.0" 
$ns at 587.4542993892595 "$node_(95) setdest 125673 67195 11.0" 
$ns at 712.6901101324449 "$node_(95) setdest 32920 5531 14.0" 
$ns at 845.7568529020147 "$node_(95) setdest 184436 79282 5.0" 
$ns at 0.0 "$node_(96) setdest 66528 1186 16.0" 
$ns at 53.537949524147606 "$node_(96) setdest 53328 5356 7.0" 
$ns at 151.8050059777692 "$node_(96) setdest 42533 12470 5.0" 
$ns at 210.9309065926324 "$node_(96) setdest 98973 43982 8.0" 
$ns at 277.4853490697812 "$node_(96) setdest 41152 9224 9.0" 
$ns at 343.1229216215977 "$node_(96) setdest 124857 40607 9.0" 
$ns at 455.4018422235906 "$node_(96) setdest 164824 43866 4.0" 
$ns at 488.1565398570043 "$node_(96) setdest 116378 43894 6.0" 
$ns at 571.5043296668208 "$node_(96) setdest 17807 47304 5.0" 
$ns at 613.9129357515912 "$node_(96) setdest 3558 12235 20.0" 
$ns at 709.2148839933383 "$node_(96) setdest 110198 75817 1.0" 
$ns at 747.0256931885529 "$node_(96) setdest 96419 7175 4.0" 
$ns at 791.2873443820492 "$node_(96) setdest 237748 79673 18.0" 
$ns at 0.0 "$node_(97) setdest 90726 29552 6.0" 
$ns at 36.214094335310484 "$node_(97) setdest 54510 20044 4.0" 
$ns at 81.81067643136376 "$node_(97) setdest 28967 5262 6.0" 
$ns at 147.99570650673644 "$node_(97) setdest 56326 18826 3.0" 
$ns at 187.60073270915584 "$node_(97) setdest 18951 38555 13.0" 
$ns at 238.2674003089976 "$node_(97) setdest 2490 27343 5.0" 
$ns at 276.9011905381527 "$node_(97) setdest 54679 12583 14.0" 
$ns at 408.1268503373684 "$node_(97) setdest 63511 3568 18.0" 
$ns at 563.8786106872549 "$node_(97) setdest 191694 35263 18.0" 
$ns at 617.067548871243 "$node_(97) setdest 138631 25119 7.0" 
$ns at 653.0624761044696 "$node_(97) setdest 110691 55555 11.0" 
$ns at 711.8600813388956 "$node_(97) setdest 233990 2098 17.0" 
$ns at 872.3457856478573 "$node_(97) setdest 216475 1174 13.0" 
$ns at 0.0 "$node_(98) setdest 24582 17091 6.0" 
$ns at 83.2355255601133 "$node_(98) setdest 83984 5816 10.0" 
$ns at 212.4714743476205 "$node_(98) setdest 43305 37254 18.0" 
$ns at 354.01516532731773 "$node_(98) setdest 163332 50226 3.0" 
$ns at 403.556575628739 "$node_(98) setdest 80215 41354 7.0" 
$ns at 490.4051609695058 "$node_(98) setdest 76362 35312 17.0" 
$ns at 667.9074605972712 "$node_(98) setdest 110057 45411 16.0" 
$ns at 801.6866773880392 "$node_(98) setdest 66548 71870 11.0" 
$ns at 870.5056975480246 "$node_(98) setdest 4948 23794 16.0" 
$ns at 0.0 "$node_(99) setdest 46427 26792 14.0" 
$ns at 120.80908006649791 "$node_(99) setdest 4392 18525 9.0" 
$ns at 217.100738741653 "$node_(99) setdest 108680 31060 8.0" 
$ns at 258.9144586128084 "$node_(99) setdest 122690 27721 7.0" 
$ns at 306.4198623624875 "$node_(99) setdest 24688 48559 18.0" 
$ns at 463.8764580417896 "$node_(99) setdest 9407 27540 18.0" 
$ns at 537.5769757565035 "$node_(99) setdest 30933 19981 1.0" 
$ns at 569.4960624974519 "$node_(99) setdest 9273 45638 4.0" 
$ns at 615.0909726751185 "$node_(99) setdest 29403 35402 4.0" 
$ns at 665.5048867795348 "$node_(99) setdest 179515 41129 8.0" 
$ns at 718.9214082930018 "$node_(99) setdest 92741 14472 7.0" 
$ns at 749.4695311649775 "$node_(99) setdest 58202 9427 1.0" 
$ns at 780.5670833405288 "$node_(99) setdest 159954 62674 13.0" 
$ns at 845.2332239905763 "$node_(99) setdest 117066 57587 8.0" 
$ns at 0.0 "$node_(100) setdest 127560 78 8.0" 
$ns at 83.1580789400758 "$node_(100) setdest 58223 26441 12.0" 
$ns at 162.61295526833993 "$node_(100) setdest 127396 2105 12.0" 
$ns at 224.58612745241527 "$node_(100) setdest 46581 18029 17.0" 
$ns at 288.1635340111721 "$node_(100) setdest 22548 43259 13.0" 
$ns at 433.1230405209316 "$node_(100) setdest 117366 46166 6.0" 
$ns at 486.27216895902876 "$node_(100) setdest 93525 39686 3.0" 
$ns at 527.7991156756957 "$node_(100) setdest 100594 50303 6.0" 
$ns at 614.701632567155 "$node_(100) setdest 106539 70514 17.0" 
$ns at 742.5485812262751 "$node_(100) setdest 102810 78268 2.0" 
$ns at 787.2599659598081 "$node_(100) setdest 45723 13918 14.0" 
$ns at 854.0065710769854 "$node_(100) setdest 217790 86179 19.0" 
$ns at 232.62993637965738 "$node_(101) setdest 120688 7366 6.0" 
$ns at 302.8347317125129 "$node_(101) setdest 141389 3489 18.0" 
$ns at 392.42154090500424 "$node_(101) setdest 120420 31675 7.0" 
$ns at 430.0639089014073 "$node_(101) setdest 48531 26491 1.0" 
$ns at 470.0016039958963 "$node_(101) setdest 41959 55389 17.0" 
$ns at 591.2469128845238 "$node_(101) setdest 28729 75147 8.0" 
$ns at 655.262116829628 "$node_(101) setdest 162318 64561 18.0" 
$ns at 766.1484654165696 "$node_(101) setdest 222310 85607 17.0" 
$ns at 233.67798493207587 "$node_(102) setdest 92642 9147 18.0" 
$ns at 318.0253690356908 "$node_(102) setdest 94134 42383 19.0" 
$ns at 435.54985083852773 "$node_(102) setdest 4739 38031 1.0" 
$ns at 466.6137391776097 "$node_(102) setdest 209532 69951 12.0" 
$ns at 542.01973662829 "$node_(102) setdest 30128 64393 7.0" 
$ns at 599.4693592246302 "$node_(102) setdest 226072 61570 7.0" 
$ns at 648.9061972865375 "$node_(102) setdest 163425 40343 1.0" 
$ns at 681.3326100927264 "$node_(102) setdest 116256 2088 6.0" 
$ns at 721.1380754878708 "$node_(102) setdest 102340 3098 7.0" 
$ns at 804.8103813678363 "$node_(102) setdest 202357 64404 4.0" 
$ns at 862.0267352225932 "$node_(102) setdest 232734 36605 14.0" 
$ns at 133.62011229968513 "$node_(103) setdest 307 852 17.0" 
$ns at 215.7832736025093 "$node_(103) setdest 83696 9057 11.0" 
$ns at 331.0379327853846 "$node_(103) setdest 156276 30108 15.0" 
$ns at 479.5705163713548 "$node_(103) setdest 173304 4302 16.0" 
$ns at 634.4973395088964 "$node_(103) setdest 165878 38238 6.0" 
$ns at 704.4850119150608 "$node_(103) setdest 179998 22277 8.0" 
$ns at 762.2728665215726 "$node_(103) setdest 13475 75417 10.0" 
$ns at 848.4387633814066 "$node_(103) setdest 175105 54465 1.0" 
$ns at 884.8611077051042 "$node_(103) setdest 90434 18537 16.0" 
$ns at 182.9626714979502 "$node_(104) setdest 118284 20745 10.0" 
$ns at 255.01778583029 "$node_(104) setdest 83350 38069 16.0" 
$ns at 435.01019632896424 "$node_(104) setdest 167946 16559 15.0" 
$ns at 530.3815004861914 "$node_(104) setdest 31068 23596 6.0" 
$ns at 587.4503819402576 "$node_(104) setdest 164070 16566 15.0" 
$ns at 733.4871303750936 "$node_(104) setdest 25706 79904 11.0" 
$ns at 810.8183136379467 "$node_(104) setdest 77643 17069 6.0" 
$ns at 844.0466443088036 "$node_(104) setdest 12071 50920 13.0" 
$ns at 879.319588349297 "$node_(104) setdest 95486 78260 16.0" 
$ns at 179.36786311500958 "$node_(105) setdest 48864 14034 15.0" 
$ns at 354.2730143964583 "$node_(105) setdest 124285 51767 2.0" 
$ns at 402.83054061622084 "$node_(105) setdest 153863 13351 15.0" 
$ns at 498.38828722794295 "$node_(105) setdest 211136 54326 6.0" 
$ns at 529.0565938751361 "$node_(105) setdest 152062 38231 3.0" 
$ns at 588.0157427127118 "$node_(105) setdest 10312 53190 7.0" 
$ns at 635.0617705521116 "$node_(105) setdest 164050 43712 16.0" 
$ns at 712.7941995170335 "$node_(105) setdest 174949 22010 17.0" 
$ns at 862.4778359745902 "$node_(105) setdest 49531 60565 12.0" 
$ns at 899.6566895129356 "$node_(105) setdest 150623 71248 10.0" 
$ns at 172.16836704724986 "$node_(106) setdest 37774 34221 8.0" 
$ns at 272.1078597087975 "$node_(106) setdest 45516 29161 14.0" 
$ns at 326.79036328198 "$node_(106) setdest 113338 22430 17.0" 
$ns at 465.8298546692199 "$node_(106) setdest 10451 45053 7.0" 
$ns at 558.933396092438 "$node_(106) setdest 57953 37621 15.0" 
$ns at 683.686804122276 "$node_(106) setdest 173188 18912 4.0" 
$ns at 747.917225142039 "$node_(106) setdest 205106 5923 17.0" 
$ns at 854.1050494332046 "$node_(106) setdest 116259 9684 3.0" 
$ns at 892.9641123067577 "$node_(106) setdest 49581 48784 18.0" 
$ns at 106.70637220818404 "$node_(107) setdest 47315 29348 4.0" 
$ns at 159.21054775225588 "$node_(107) setdest 107771 11333 2.0" 
$ns at 201.02187148058584 "$node_(107) setdest 94216 19100 12.0" 
$ns at 333.58807561280423 "$node_(107) setdest 163453 42790 6.0" 
$ns at 408.80249089124663 "$node_(107) setdest 39481 32127 5.0" 
$ns at 468.45489528346224 "$node_(107) setdest 123596 53015 17.0" 
$ns at 660.0080946885563 "$node_(107) setdest 168877 58655 2.0" 
$ns at 699.2280451067006 "$node_(107) setdest 45641 48853 8.0" 
$ns at 790.76049305844 "$node_(107) setdest 149951 47170 10.0" 
$ns at 820.9079743696451 "$node_(107) setdest 189065 63326 15.0" 
$ns at 109.910073592284 "$node_(108) setdest 32789 22998 4.0" 
$ns at 159.3987022193345 "$node_(108) setdest 64628 19538 5.0" 
$ns at 218.63666088258194 "$node_(108) setdest 28305 22181 2.0" 
$ns at 258.9888821516185 "$node_(108) setdest 99688 13978 11.0" 
$ns at 302.1973747539089 "$node_(108) setdest 74622 39269 5.0" 
$ns at 376.8985198830333 "$node_(108) setdest 72027 37899 5.0" 
$ns at 451.9621432900049 "$node_(108) setdest 6891 68316 12.0" 
$ns at 566.9212360164405 "$node_(108) setdest 186861 57213 19.0" 
$ns at 607.7498205354552 "$node_(108) setdest 103992 22293 8.0" 
$ns at 700.5257069288864 "$node_(108) setdest 187550 29818 2.0" 
$ns at 750.4581343636958 "$node_(108) setdest 21990 67449 9.0" 
$ns at 840.620162732444 "$node_(108) setdest 86020 56310 16.0" 
$ns at 226.14768501643482 "$node_(109) setdest 40852 2928 9.0" 
$ns at 262.6521325261527 "$node_(109) setdest 12917 47873 14.0" 
$ns at 346.48113703679974 "$node_(109) setdest 77611 20654 16.0" 
$ns at 421.66213503885933 "$node_(109) setdest 165117 54650 16.0" 
$ns at 568.0347833644003 "$node_(109) setdest 42935 34923 4.0" 
$ns at 601.473155213261 "$node_(109) setdest 43625 14361 2.0" 
$ns at 635.9755882369501 "$node_(109) setdest 142347 59915 8.0" 
$ns at 706.9031588031723 "$node_(109) setdest 74779 73947 7.0" 
$ns at 798.6894905414943 "$node_(109) setdest 56670 6189 3.0" 
$ns at 834.1510312752577 "$node_(109) setdest 178058 51026 16.0" 
$ns at 189.3595540623063 "$node_(110) setdest 106972 42013 2.0" 
$ns at 234.40898541151597 "$node_(110) setdest 30736 20968 9.0" 
$ns at 269.6671264076432 "$node_(110) setdest 113421 34558 13.0" 
$ns at 362.55870522829065 "$node_(110) setdest 29096 19768 5.0" 
$ns at 403.344756851626 "$node_(110) setdest 30374 43031 17.0" 
$ns at 437.21415750741954 "$node_(110) setdest 132376 346 14.0" 
$ns at 501.8712721560218 "$node_(110) setdest 194923 68768 11.0" 
$ns at 635.5488817637731 "$node_(110) setdest 138890 50256 3.0" 
$ns at 694.5567724141229 "$node_(110) setdest 164454 19980 1.0" 
$ns at 732.227523919305 "$node_(110) setdest 110068 71657 14.0" 
$ns at 779.19216078866 "$node_(110) setdest 185331 72433 16.0" 
$ns at 864.5593600052036 "$node_(110) setdest 83351 27889 12.0" 
$ns at 169.99626643073623 "$node_(111) setdest 59597 505 6.0" 
$ns at 209.66176855614177 "$node_(111) setdest 89598 21666 12.0" 
$ns at 297.67952147153056 "$node_(111) setdest 60892 28635 18.0" 
$ns at 402.0036742285218 "$node_(111) setdest 67928 28499 3.0" 
$ns at 435.5602918906238 "$node_(111) setdest 166189 20481 13.0" 
$ns at 494.8340868691122 "$node_(111) setdest 138711 55154 2.0" 
$ns at 524.9443782964224 "$node_(111) setdest 87565 12148 12.0" 
$ns at 585.1505669571357 "$node_(111) setdest 90466 52752 2.0" 
$ns at 615.3477789364356 "$node_(111) setdest 130729 19171 3.0" 
$ns at 658.903021252383 "$node_(111) setdest 75872 36952 1.0" 
$ns at 697.9676335778626 "$node_(111) setdest 25395 71911 10.0" 
$ns at 775.4253633586784 "$node_(111) setdest 242260 20131 10.0" 
$ns at 876.7128863907195 "$node_(111) setdest 78079 13276 10.0" 
$ns at 134.61905281020492 "$node_(112) setdest 85022 30612 6.0" 
$ns at 216.0965811693967 "$node_(112) setdest 79732 4924 15.0" 
$ns at 323.16939800510426 "$node_(112) setdest 70218 39956 7.0" 
$ns at 357.48354604770645 "$node_(112) setdest 89031 12679 5.0" 
$ns at 427.7586834314057 "$node_(112) setdest 82884 26596 11.0" 
$ns at 567.454220383556 "$node_(112) setdest 231365 1763 10.0" 
$ns at 658.875537319137 "$node_(112) setdest 206352 73427 2.0" 
$ns at 702.9276175958647 "$node_(112) setdest 20398 4365 1.0" 
$ns at 740.3081568639855 "$node_(112) setdest 176053 73413 17.0" 
$ns at 836.7545955363316 "$node_(112) setdest 123091 36788 2.0" 
$ns at 880.2197079199477 "$node_(112) setdest 112548 33852 5.0" 
$ns at 113.95396925952099 "$node_(113) setdest 51751 15852 15.0" 
$ns at 269.9974042668333 "$node_(113) setdest 35448 18555 1.0" 
$ns at 300.08256197412805 "$node_(113) setdest 3711 7544 14.0" 
$ns at 406.0714870187407 "$node_(113) setdest 183440 41193 19.0" 
$ns at 572.9207426198482 "$node_(113) setdest 181424 1803 20.0" 
$ns at 630.6112131653597 "$node_(113) setdest 85518 25052 8.0" 
$ns at 710.7531763927813 "$node_(113) setdest 48384 67298 19.0" 
$ns at 776.3473950900539 "$node_(113) setdest 99586 44244 13.0" 
$ns at 129.51113948864645 "$node_(114) setdest 44371 12129 8.0" 
$ns at 207.6008294727272 "$node_(114) setdest 61659 22627 18.0" 
$ns at 290.06180843699246 "$node_(114) setdest 40586 44087 18.0" 
$ns at 410.9007633345916 "$node_(114) setdest 111569 46580 5.0" 
$ns at 449.7438380250599 "$node_(114) setdest 168047 50033 15.0" 
$ns at 614.1044204694069 "$node_(114) setdest 213402 19267 12.0" 
$ns at 683.6262907689367 "$node_(114) setdest 131068 52377 8.0" 
$ns at 736.6784370241886 "$node_(114) setdest 203182 49158 8.0" 
$ns at 798.5907990668824 "$node_(114) setdest 19640 15265 20.0" 
$ns at 169.0743773129192 "$node_(115) setdest 28527 34824 1.0" 
$ns at 204.16405008897237 "$node_(115) setdest 51353 27291 7.0" 
$ns at 290.97805715750457 "$node_(115) setdest 78680 52481 18.0" 
$ns at 334.1434520282196 "$node_(115) setdest 106615 39197 16.0" 
$ns at 443.7295894133527 "$node_(115) setdest 70824 26803 12.0" 
$ns at 531.9692683807708 "$node_(115) setdest 78366 40200 19.0" 
$ns at 684.856549554967 "$node_(115) setdest 141579 36304 7.0" 
$ns at 732.8440758188482 "$node_(115) setdest 43492 5717 7.0" 
$ns at 829.3601923048652 "$node_(115) setdest 149596 49840 14.0" 
$ns at 864.284663039228 "$node_(115) setdest 15169 52827 10.0" 
$ns at 128.23323285900779 "$node_(116) setdest 59866 31063 3.0" 
$ns at 183.47909865023365 "$node_(116) setdest 95645 26465 20.0" 
$ns at 395.6196932549926 "$node_(116) setdest 100142 33287 16.0" 
$ns at 551.7029603823173 "$node_(116) setdest 59609 20564 3.0" 
$ns at 596.2272797406722 "$node_(116) setdest 184224 1569 14.0" 
$ns at 677.8433919835891 "$node_(116) setdest 44503 5009 1.0" 
$ns at 714.6861185179157 "$node_(116) setdest 127895 61379 19.0" 
$ns at 819.0739422240343 "$node_(116) setdest 200288 63408 12.0" 
$ns at 137.79021467694372 "$node_(117) setdest 73891 22280 17.0" 
$ns at 190.6721786428129 "$node_(117) setdest 61482 14904 7.0" 
$ns at 260.89216938870345 "$node_(117) setdest 72650 17159 5.0" 
$ns at 295.88037841526784 "$node_(117) setdest 68559 13214 7.0" 
$ns at 374.97755226112645 "$node_(117) setdest 16971 29705 2.0" 
$ns at 406.35768009172295 "$node_(117) setdest 49016 12894 16.0" 
$ns at 586.1139085342627 "$node_(117) setdest 82788 43857 18.0" 
$ns at 689.8281712060086 "$node_(117) setdest 7642 32461 8.0" 
$ns at 743.6916734188461 "$node_(117) setdest 1967 34200 9.0" 
$ns at 847.698905175662 "$node_(117) setdest 13329 56962 14.0" 
$ns at 894.2920634564854 "$node_(117) setdest 74178 76726 19.0" 
$ns at 100.92249472497797 "$node_(118) setdest 64169 29223 9.0" 
$ns at 212.31848250000036 "$node_(118) setdest 15792 13720 3.0" 
$ns at 261.5542279796352 "$node_(118) setdest 87952 18569 14.0" 
$ns at 369.57320848201937 "$node_(118) setdest 61115 30348 1.0" 
$ns at 408.1390463292338 "$node_(118) setdest 138389 54954 15.0" 
$ns at 486.6949708967717 "$node_(118) setdest 157088 51622 3.0" 
$ns at 517.6585595468714 "$node_(118) setdest 76829 63119 10.0" 
$ns at 559.9406494379062 "$node_(118) setdest 152477 41085 7.0" 
$ns at 620.993701517625 "$node_(118) setdest 86768 980 12.0" 
$ns at 661.3498975015489 "$node_(118) setdest 123716 59551 11.0" 
$ns at 775.2077541185688 "$node_(118) setdest 85208 64225 20.0" 
$ns at 119.83896678447505 "$node_(119) setdest 75893 11704 3.0" 
$ns at 160.96584944988936 "$node_(119) setdest 68090 12567 15.0" 
$ns at 263.0154727898198 "$node_(119) setdest 50719 1601 1.0" 
$ns at 293.92295011113026 "$node_(119) setdest 150303 30410 1.0" 
$ns at 332.05565533199245 "$node_(119) setdest 70676 48921 14.0" 
$ns at 485.19509429339377 "$node_(119) setdest 40958 43436 7.0" 
$ns at 518.5048816629917 "$node_(119) setdest 145892 25867 18.0" 
$ns at 681.6788404229414 "$node_(119) setdest 24817 37346 13.0" 
$ns at 775.1527575152047 "$node_(119) setdest 131682 2349 11.0" 
$ns at 187.18143172665063 "$node_(120) setdest 125049 787 14.0" 
$ns at 246.38923931274428 "$node_(120) setdest 42067 38226 11.0" 
$ns at 371.22489807683024 "$node_(120) setdest 80343 39526 5.0" 
$ns at 417.68453928115076 "$node_(120) setdest 19038 30048 18.0" 
$ns at 457.38700178685326 "$node_(120) setdest 86141 4409 15.0" 
$ns at 609.8921232652201 "$node_(120) setdest 119364 26919 2.0" 
$ns at 649.5652850036515 "$node_(120) setdest 145235 57155 5.0" 
$ns at 725.0016626207496 "$node_(120) setdest 95786 20099 4.0" 
$ns at 787.336877442671 "$node_(120) setdest 189311 46218 4.0" 
$ns at 821.8446337482429 "$node_(120) setdest 103742 10984 1.0" 
$ns at 858.2223532961277 "$node_(120) setdest 5390 67239 15.0" 
$ns at 245.9731586306367 "$node_(121) setdest 75760 36593 14.0" 
$ns at 405.0521552131821 "$node_(121) setdest 183287 25304 7.0" 
$ns at 442.0303850112633 "$node_(121) setdest 147770 8790 2.0" 
$ns at 477.2946922030901 "$node_(121) setdest 97449 8136 4.0" 
$ns at 527.6593847526805 "$node_(121) setdest 9385 4055 6.0" 
$ns at 580.0682074862335 "$node_(121) setdest 229902 10433 12.0" 
$ns at 669.4683891095926 "$node_(121) setdest 48330 35707 17.0" 
$ns at 728.0795786857223 "$node_(121) setdest 127406 78008 3.0" 
$ns at 778.8959260843465 "$node_(121) setdest 83780 20965 13.0" 
$ns at 892.9970843136327 "$node_(121) setdest 229353 32272 9.0" 
$ns at 116.75425112322242 "$node_(122) setdest 64465 1186 2.0" 
$ns at 161.61927146649128 "$node_(122) setdest 62486 1582 9.0" 
$ns at 227.80565654610155 "$node_(122) setdest 3576 41101 17.0" 
$ns at 393.55946634247834 "$node_(122) setdest 41043 3980 4.0" 
$ns at 459.2931698355716 "$node_(122) setdest 68171 14853 17.0" 
$ns at 623.4225296728474 "$node_(122) setdest 22659 9961 6.0" 
$ns at 666.7856412563176 "$node_(122) setdest 221582 79155 8.0" 
$ns at 732.4119993601036 "$node_(122) setdest 242675 40473 18.0" 
$ns at 815.5449438599036 "$node_(122) setdest 140829 4496 4.0" 
$ns at 860.209443255675 "$node_(122) setdest 123906 40145 12.0" 
$ns at 140.23679239177068 "$node_(123) setdest 30795 6242 10.0" 
$ns at 264.4869819507164 "$node_(123) setdest 105717 8174 10.0" 
$ns at 384.0312609010003 "$node_(123) setdest 19665 20916 2.0" 
$ns at 431.5079950755793 "$node_(123) setdest 150949 11443 14.0" 
$ns at 497.6670187118892 "$node_(123) setdest 205529 53956 18.0" 
$ns at 677.8830986547064 "$node_(123) setdest 64821 72550 4.0" 
$ns at 730.4239552376914 "$node_(123) setdest 158270 57443 11.0" 
$ns at 860.5338593493959 "$node_(123) setdest 135597 44598 9.0" 
$ns at 116.85091626018878 "$node_(124) setdest 25921 29129 12.0" 
$ns at 198.67123404926605 "$node_(124) setdest 118502 6845 8.0" 
$ns at 300.4327305971201 "$node_(124) setdest 98354 52062 4.0" 
$ns at 334.94967697225985 "$node_(124) setdest 141310 25801 20.0" 
$ns at 436.7987188254641 "$node_(124) setdest 52858 13253 6.0" 
$ns at 510.7997986423663 "$node_(124) setdest 116241 55799 11.0" 
$ns at 544.923520152856 "$node_(124) setdest 166004 64972 7.0" 
$ns at 639.3681090242767 "$node_(124) setdest 116413 42194 16.0" 
$ns at 797.9268044063838 "$node_(124) setdest 170336 57117 18.0" 
$ns at 127.79132846753754 "$node_(125) setdest 68194 23180 7.0" 
$ns at 209.5384748775519 "$node_(125) setdest 84301 31806 6.0" 
$ns at 263.95941577527316 "$node_(125) setdest 115793 15861 8.0" 
$ns at 366.8636593060377 "$node_(125) setdest 32400 45730 15.0" 
$ns at 519.855065991664 "$node_(125) setdest 191610 15891 12.0" 
$ns at 604.1235301154377 "$node_(125) setdest 170338 55341 6.0" 
$ns at 639.3695445537521 "$node_(125) setdest 226668 65369 18.0" 
$ns at 756.8803574085467 "$node_(125) setdest 7061 47109 17.0" 
$ns at 144.54667145356478 "$node_(126) setdest 41370 210 7.0" 
$ns at 224.02748844000502 "$node_(126) setdest 8686 7568 16.0" 
$ns at 377.13407979056825 "$node_(126) setdest 145406 52550 2.0" 
$ns at 422.61623140171656 "$node_(126) setdest 152582 44460 13.0" 
$ns at 550.966073584326 "$node_(126) setdest 101828 13990 1.0" 
$ns at 587.3958552191859 "$node_(126) setdest 45238 74847 16.0" 
$ns at 661.2649171838885 "$node_(126) setdest 57589 69832 13.0" 
$ns at 741.1165189041662 "$node_(126) setdest 224126 73217 12.0" 
$ns at 871.5468592281786 "$node_(126) setdest 188747 36209 9.0" 
$ns at 115.45323737013797 "$node_(127) setdest 27920 17663 9.0" 
$ns at 201.91625403054942 "$node_(127) setdest 114813 2868 20.0" 
$ns at 300.18914392785075 "$node_(127) setdest 14826 38940 18.0" 
$ns at 509.2808979635279 "$node_(127) setdest 78534 17872 1.0" 
$ns at 548.9028852868489 "$node_(127) setdest 46278 6955 2.0" 
$ns at 586.5766730859064 "$node_(127) setdest 203404 67808 3.0" 
$ns at 624.2732529005909 "$node_(127) setdest 24761 56013 14.0" 
$ns at 678.330635849366 "$node_(127) setdest 69694 55708 19.0" 
$ns at 804.4864941964987 "$node_(127) setdest 217073 88813 14.0" 
$ns at 890.7892931741376 "$node_(127) setdest 22251 27195 1.0" 
$ns at 112.97275142711307 "$node_(128) setdest 25329 5000 19.0" 
$ns at 145.9090807877003 "$node_(128) setdest 79002 16964 5.0" 
$ns at 189.58844953889536 "$node_(128) setdest 27784 26573 8.0" 
$ns at 268.95547413932127 "$node_(128) setdest 82356 24445 10.0" 
$ns at 312.29846373133006 "$node_(128) setdest 26456 6813 3.0" 
$ns at 370.1015435256771 "$node_(128) setdest 60889 60022 10.0" 
$ns at 443.91430500647436 "$node_(128) setdest 6210 57659 17.0" 
$ns at 580.4279470575525 "$node_(128) setdest 230303 26213 16.0" 
$ns at 726.1574227367288 "$node_(128) setdest 103634 33604 11.0" 
$ns at 758.1676522531491 "$node_(128) setdest 180129 44357 10.0" 
$ns at 842.2610625578708 "$node_(128) setdest 35441 9002 7.0" 
$ns at 122.91924372003436 "$node_(129) setdest 66999 2985 11.0" 
$ns at 162.65928437833952 "$node_(129) setdest 23825 24748 17.0" 
$ns at 282.5709009558684 "$node_(129) setdest 139744 46320 17.0" 
$ns at 344.82416201249947 "$node_(129) setdest 7101 44627 1.0" 
$ns at 378.0297684393415 "$node_(129) setdest 35580 57496 16.0" 
$ns at 553.0016066354385 "$node_(129) setdest 78267 53701 18.0" 
$ns at 691.1832674483744 "$node_(129) setdest 159395 43679 5.0" 
$ns at 758.278909096949 "$node_(129) setdest 140733 58807 3.0" 
$ns at 789.6941066347478 "$node_(129) setdest 77418 38972 2.0" 
$ns at 837.5974516247285 "$node_(129) setdest 66928 51090 17.0" 
$ns at 868.4278245992799 "$node_(129) setdest 153066 28882 18.0" 
$ns at 180.19152793862733 "$node_(130) setdest 11562 3361 8.0" 
$ns at 273.3153369960412 "$node_(130) setdest 18013 6456 7.0" 
$ns at 348.0870276420671 "$node_(130) setdest 49415 16030 1.0" 
$ns at 381.1767702339929 "$node_(130) setdest 120042 11572 4.0" 
$ns at 412.40035580683946 "$node_(130) setdest 36037 16013 3.0" 
$ns at 454.26347214130993 "$node_(130) setdest 135885 7724 6.0" 
$ns at 532.2390225375691 "$node_(130) setdest 156048 44279 20.0" 
$ns at 625.0910245275875 "$node_(130) setdest 215541 49508 16.0" 
$ns at 718.3752061529738 "$node_(130) setdest 200469 20876 15.0" 
$ns at 847.4547571881812 "$node_(130) setdest 132949 27916 1.0" 
$ns at 881.6806637642801 "$node_(130) setdest 207975 30116 1.0" 
$ns at 129.2866121198113 "$node_(131) setdest 15839 24438 11.0" 
$ns at 173.89085269806117 "$node_(131) setdest 46101 15070 5.0" 
$ns at 230.39097360392435 "$node_(131) setdest 57053 15749 2.0" 
$ns at 280.33279434419046 "$node_(131) setdest 143220 36431 10.0" 
$ns at 357.59973421602183 "$node_(131) setdest 43890 1614 12.0" 
$ns at 479.9822089589187 "$node_(131) setdest 70782 40014 10.0" 
$ns at 590.9968353548827 "$node_(131) setdest 136333 53224 1.0" 
$ns at 626.3644818542898 "$node_(131) setdest 219248 67048 5.0" 
$ns at 688.1874789104094 "$node_(131) setdest 120178 24044 7.0" 
$ns at 755.9660892737063 "$node_(131) setdest 215540 67835 2.0" 
$ns at 789.2887600620448 "$node_(131) setdest 197579 3535 19.0" 
$ns at 131.2755349726914 "$node_(132) setdest 71237 28196 19.0" 
$ns at 202.23088842734296 "$node_(132) setdest 67851 3546 19.0" 
$ns at 364.9819350468344 "$node_(132) setdest 33892 10039 11.0" 
$ns at 492.70568164781423 "$node_(132) setdest 157051 2630 17.0" 
$ns at 576.6380242737301 "$node_(132) setdest 228835 35573 16.0" 
$ns at 749.075623633918 "$node_(132) setdest 63092 10008 15.0" 
$ns at 871.1574104521608 "$node_(132) setdest 119309 31364 10.0" 
$ns at 210.52268279511804 "$node_(133) setdest 80667 33849 18.0" 
$ns at 317.7983955748049 "$node_(133) setdest 137125 51718 3.0" 
$ns at 352.75913982527413 "$node_(133) setdest 4523 40884 16.0" 
$ns at 386.03945310571 "$node_(133) setdest 53013 38192 2.0" 
$ns at 427.50008438132465 "$node_(133) setdest 74576 23926 17.0" 
$ns at 518.0415118780559 "$node_(133) setdest 88429 52763 15.0" 
$ns at 609.4381628464678 "$node_(133) setdest 54916 45502 18.0" 
$ns at 748.219912529952 "$node_(133) setdest 248483 61993 16.0" 
$ns at 100.49109726272931 "$node_(134) setdest 74685 16427 7.0" 
$ns at 170.91093349985434 "$node_(134) setdest 67046 21137 4.0" 
$ns at 200.92686975376296 "$node_(134) setdest 1953 24763 5.0" 
$ns at 249.85490313484252 "$node_(134) setdest 63257 10606 14.0" 
$ns at 406.55881528223426 "$node_(134) setdest 34344 29160 13.0" 
$ns at 560.7853091519646 "$node_(134) setdest 31377 21006 1.0" 
$ns at 593.6923742502687 "$node_(134) setdest 65721 40767 12.0" 
$ns at 655.2488590789745 "$node_(134) setdest 79459 71704 18.0" 
$ns at 843.7792280543323 "$node_(134) setdest 49582 26976 14.0" 
$ns at 163.32756065843014 "$node_(135) setdest 39950 16743 14.0" 
$ns at 269.4993514100924 "$node_(135) setdest 88072 5305 6.0" 
$ns at 338.1158277856483 "$node_(135) setdest 21002 22002 15.0" 
$ns at 498.9170453854622 "$node_(135) setdest 134072 63929 7.0" 
$ns at 573.928635645547 "$node_(135) setdest 72841 30653 7.0" 
$ns at 641.8760777057087 "$node_(135) setdest 53849 37012 16.0" 
$ns at 815.1630334779015 "$node_(135) setdest 232340 78596 15.0" 
$ns at 116.31575750309204 "$node_(136) setdest 85409 21279 20.0" 
$ns at 333.32904140372307 "$node_(136) setdest 98399 5836 3.0" 
$ns at 388.7296835681716 "$node_(136) setdest 86600 43259 10.0" 
$ns at 442.87346979670247 "$node_(136) setdest 10175 34763 17.0" 
$ns at 508.494264406169 "$node_(136) setdest 160093 45485 1.0" 
$ns at 540.329007121663 "$node_(136) setdest 149667 66434 4.0" 
$ns at 603.5552080582378 "$node_(136) setdest 140122 53442 15.0" 
$ns at 657.4901275462416 "$node_(136) setdest 160557 14639 1.0" 
$ns at 688.182166978088 "$node_(136) setdest 157661 69567 16.0" 
$ns at 779.1292121678764 "$node_(136) setdest 217953 11905 9.0" 
$ns at 886.3252208732389 "$node_(136) setdest 76571 24153 10.0" 
$ns at 190.28338237785704 "$node_(137) setdest 79391 1058 15.0" 
$ns at 269.1560425114037 "$node_(137) setdest 52819 20535 17.0" 
$ns at 384.793164467584 "$node_(137) setdest 108506 38693 17.0" 
$ns at 517.6717743039351 "$node_(137) setdest 139587 2959 14.0" 
$ns at 681.4801945568731 "$node_(137) setdest 164163 68984 13.0" 
$ns at 716.6859173520302 "$node_(137) setdest 162497 46339 7.0" 
$ns at 751.0626079977544 "$node_(137) setdest 135541 75600 6.0" 
$ns at 798.1668201504162 "$node_(137) setdest 148411 2145 18.0" 
$ns at 899.6314129842169 "$node_(137) setdest 11451 22005 2.0" 
$ns at 111.429352206078 "$node_(138) setdest 58076 19784 11.0" 
$ns at 217.43629338557685 "$node_(138) setdest 5549 30883 11.0" 
$ns at 343.2973247532307 "$node_(138) setdest 93344 49795 3.0" 
$ns at 401.8835913635122 "$node_(138) setdest 157508 35937 15.0" 
$ns at 508.79096752514977 "$node_(138) setdest 158392 40967 18.0" 
$ns at 681.2404705787261 "$node_(138) setdest 19577 9099 8.0" 
$ns at 754.3133902045274 "$node_(138) setdest 152719 32107 5.0" 
$ns at 822.3220670055092 "$node_(138) setdest 159713 84662 1.0" 
$ns at 852.3529321340906 "$node_(138) setdest 204775 10133 1.0" 
$ns at 882.8852181886255 "$node_(138) setdest 98436 85810 3.0" 
$ns at 147.8717633853411 "$node_(139) setdest 49640 2755 20.0" 
$ns at 269.97741645506494 "$node_(139) setdest 35373 44692 1.0" 
$ns at 305.60995072394314 "$node_(139) setdest 122400 5660 20.0" 
$ns at 492.9779460692455 "$node_(139) setdest 9282 46970 5.0" 
$ns at 558.0245137682305 "$node_(139) setdest 170572 65788 17.0" 
$ns at 708.5399318603995 "$node_(139) setdest 212362 34459 16.0" 
$ns at 858.7858912955896 "$node_(139) setdest 241409 47446 17.0" 
$ns at 149.9239612011143 "$node_(140) setdest 11215 4303 11.0" 
$ns at 188.27142154160643 "$node_(140) setdest 89412 17705 6.0" 
$ns at 269.39190779210855 "$node_(140) setdest 74921 23697 18.0" 
$ns at 314.60062964053594 "$node_(140) setdest 51395 28650 5.0" 
$ns at 363.59688027403246 "$node_(140) setdest 79053 21113 6.0" 
$ns at 421.608743262503 "$node_(140) setdest 188589 4812 14.0" 
$ns at 551.3489879968138 "$node_(140) setdest 221185 51654 2.0" 
$ns at 587.1005812854376 "$node_(140) setdest 65480 70245 6.0" 
$ns at 631.7361885136755 "$node_(140) setdest 167915 46840 4.0" 
$ns at 667.2171417547032 "$node_(140) setdest 185634 54529 2.0" 
$ns at 714.4039326267371 "$node_(140) setdest 88049 23730 17.0" 
$ns at 749.630699835166 "$node_(140) setdest 178385 12735 4.0" 
$ns at 805.0363050421032 "$node_(140) setdest 173928 33595 6.0" 
$ns at 870.3706596825588 "$node_(140) setdest 146975 38808 12.0" 
$ns at 195.5693290478136 "$node_(141) setdest 19570 39739 9.0" 
$ns at 259.20143987024994 "$node_(141) setdest 135213 37810 5.0" 
$ns at 296.49214650949267 "$node_(141) setdest 146793 30335 20.0" 
$ns at 387.79254302559536 "$node_(141) setdest 102566 37740 12.0" 
$ns at 457.9763858985302 "$node_(141) setdest 85439 44858 3.0" 
$ns at 514.5008125583137 "$node_(141) setdest 47491 65413 3.0" 
$ns at 565.5305102413605 "$node_(141) setdest 147781 51138 1.0" 
$ns at 603.502945091388 "$node_(141) setdest 226542 31066 7.0" 
$ns at 677.2164520435598 "$node_(141) setdest 71837 77440 16.0" 
$ns at 741.9629922276722 "$node_(141) setdest 210508 30724 14.0" 
$ns at 791.9227877104881 "$node_(141) setdest 142440 9299 2.0" 
$ns at 834.3972375930457 "$node_(141) setdest 147392 52465 13.0" 
$ns at 281.9599018646627 "$node_(142) setdest 32415 6145 8.0" 
$ns at 348.3369822398591 "$node_(142) setdest 130444 30581 4.0" 
$ns at 400.4783685345201 "$node_(142) setdest 69917 51573 5.0" 
$ns at 438.9385030978437 "$node_(142) setdest 1979 5981 13.0" 
$ns at 532.9216379974781 "$node_(142) setdest 9247 31790 16.0" 
$ns at 665.735074433746 "$node_(142) setdest 129024 21970 10.0" 
$ns at 781.1188702250456 "$node_(142) setdest 134989 5991 15.0" 
$ns at 199.39891991616355 "$node_(143) setdest 70453 4244 17.0" 
$ns at 259.67669873650243 "$node_(143) setdest 88249 42418 13.0" 
$ns at 409.30673095030386 "$node_(143) setdest 20016 15688 12.0" 
$ns at 503.91566829282726 "$node_(143) setdest 134732 14099 19.0" 
$ns at 635.2214182286111 "$node_(143) setdest 170558 61302 19.0" 
$ns at 705.0543093323645 "$node_(143) setdest 151815 62076 11.0" 
$ns at 826.647100757986 "$node_(143) setdest 217003 64322 15.0" 
$ns at 275.4946983932829 "$node_(144) setdest 35618 15389 16.0" 
$ns at 309.1165846906271 "$node_(144) setdest 143996 30526 19.0" 
$ns at 423.98299032132536 "$node_(144) setdest 69664 32908 14.0" 
$ns at 486.23863558269943 "$node_(144) setdest 24192 57618 10.0" 
$ns at 549.8947741433608 "$node_(144) setdest 12253 28519 2.0" 
$ns at 582.5131147138102 "$node_(144) setdest 32304 42281 10.0" 
$ns at 656.7547714423597 "$node_(144) setdest 141336 60758 4.0" 
$ns at 705.0065038979773 "$node_(144) setdest 205696 26174 4.0" 
$ns at 762.381407074974 "$node_(144) setdest 133591 28475 1.0" 
$ns at 800.233586101416 "$node_(144) setdest 245534 31577 2.0" 
$ns at 834.059516540759 "$node_(144) setdest 120410 67578 14.0" 
$ns at 192.35441558093336 "$node_(145) setdest 102720 4480 10.0" 
$ns at 302.27497641856155 "$node_(145) setdest 143116 6258 12.0" 
$ns at 356.9904191178633 "$node_(145) setdest 71283 19817 20.0" 
$ns at 398.67246591761824 "$node_(145) setdest 95826 19747 2.0" 
$ns at 430.6799436077532 "$node_(145) setdest 139168 14735 14.0" 
$ns at 486.8578561311297 "$node_(145) setdest 72664 69288 7.0" 
$ns at 554.4870189242879 "$node_(145) setdest 62806 20369 11.0" 
$ns at 694.1635125487767 "$node_(145) setdest 212637 31276 13.0" 
$ns at 750.5248826718273 "$node_(145) setdest 256573 14962 9.0" 
$ns at 866.5848042846005 "$node_(145) setdest 837 27670 11.0" 
$ns at 166.42394231383219 "$node_(146) setdest 89409 16303 10.0" 
$ns at 216.62815198096456 "$node_(146) setdest 15305 43759 18.0" 
$ns at 296.67084992332815 "$node_(146) setdest 160256 13655 12.0" 
$ns at 387.8525788180966 "$node_(146) setdest 140013 26539 9.0" 
$ns at 435.50377896800404 "$node_(146) setdest 43110 20874 13.0" 
$ns at 465.727573581196 "$node_(146) setdest 181839 21213 18.0" 
$ns at 507.60665902628386 "$node_(146) setdest 188300 62776 8.0" 
$ns at 607.4738418853549 "$node_(146) setdest 93466 19259 9.0" 
$ns at 721.6330419206848 "$node_(146) setdest 135942 11211 16.0" 
$ns at 849.2562945557581 "$node_(146) setdest 66858 5125 4.0" 
$ns at 892.2938976363938 "$node_(146) setdest 111541 70562 9.0" 
$ns at 132.44072994753333 "$node_(147) setdest 13095 4799 19.0" 
$ns at 271.91769470771345 "$node_(147) setdest 11085 37954 12.0" 
$ns at 361.50376029673487 "$node_(147) setdest 49793 6341 5.0" 
$ns at 432.68205894547623 "$node_(147) setdest 170762 57412 11.0" 
$ns at 510.9815830331143 "$node_(147) setdest 165833 25668 11.0" 
$ns at 548.017253691451 "$node_(147) setdest 54781 35388 9.0" 
$ns at 660.4498210499654 "$node_(147) setdest 103623 40701 8.0" 
$ns at 703.4939295457026 "$node_(147) setdest 134191 30877 1.0" 
$ns at 733.7694974948784 "$node_(147) setdest 127685 60456 9.0" 
$ns at 782.1230229460741 "$node_(147) setdest 69006 16990 14.0" 
$ns at 115.77498405640927 "$node_(148) setdest 59058 3542 19.0" 
$ns at 270.61941114231126 "$node_(148) setdest 157804 59 14.0" 
$ns at 432.59521116217513 "$node_(148) setdest 64696 29964 7.0" 
$ns at 463.30148038927325 "$node_(148) setdest 108071 45999 12.0" 
$ns at 573.7229338202269 "$node_(148) setdest 94440 72710 2.0" 
$ns at 622.3210892952466 "$node_(148) setdest 96621 62600 8.0" 
$ns at 696.2335874396797 "$node_(148) setdest 164340 57925 12.0" 
$ns at 798.2813540141617 "$node_(148) setdest 204981 59224 1.0" 
$ns at 837.1824075027002 "$node_(148) setdest 60126 53387 4.0" 
$ns at 871.7873863452173 "$node_(148) setdest 187396 72118 14.0" 
$ns at 183.63777923668772 "$node_(149) setdest 82814 32167 12.0" 
$ns at 267.58262672642496 "$node_(149) setdest 27030 29439 2.0" 
$ns at 312.99304240742737 "$node_(149) setdest 1293 25669 11.0" 
$ns at 360.25112270025346 "$node_(149) setdest 95088 35094 5.0" 
$ns at 431.65773530611864 "$node_(149) setdest 75399 15864 8.0" 
$ns at 520.8119118647975 "$node_(149) setdest 58162 25688 1.0" 
$ns at 556.8756792044335 "$node_(149) setdest 75349 17903 9.0" 
$ns at 624.8720228130079 "$node_(149) setdest 137251 658 2.0" 
$ns at 674.3383121839075 "$node_(149) setdest 42288 72321 2.0" 
$ns at 719.5985153297952 "$node_(149) setdest 61219 1535 6.0" 
$ns at 768.2871451562401 "$node_(149) setdest 25587 71033 13.0" 
$ns at 800.5691086479655 "$node_(149) setdest 92308 26247 17.0" 
$ns at 195.53677996652962 "$node_(150) setdest 37744 12384 3.0" 
$ns at 241.1417200753047 "$node_(150) setdest 62425 17495 16.0" 
$ns at 385.2051846885184 "$node_(150) setdest 2241 10932 12.0" 
$ns at 517.8985188102648 "$node_(150) setdest 84619 5723 1.0" 
$ns at 547.9423246998142 "$node_(150) setdest 191371 16468 17.0" 
$ns at 726.084986284165 "$node_(150) setdest 115114 21146 6.0" 
$ns at 773.5427288644734 "$node_(150) setdest 167165 34041 2.0" 
$ns at 821.5354847186256 "$node_(150) setdest 35775 22044 12.0" 
$ns at 170.32072654384305 "$node_(151) setdest 106044 7542 12.0" 
$ns at 313.1321795412483 "$node_(151) setdest 100603 27863 12.0" 
$ns at 458.215255079151 "$node_(151) setdest 138701 26054 15.0" 
$ns at 575.6061811328448 "$node_(151) setdest 225773 14180 7.0" 
$ns at 649.7483890937688 "$node_(151) setdest 89029 22344 8.0" 
$ns at 735.5680431157557 "$node_(151) setdest 195639 63423 4.0" 
$ns at 784.914958630298 "$node_(151) setdest 98297 52288 2.0" 
$ns at 815.7071060846785 "$node_(151) setdest 265968 6116 17.0" 
$ns at 199.77545793971314 "$node_(152) setdest 27377 379 16.0" 
$ns at 349.6018675703617 "$node_(152) setdest 155121 15673 8.0" 
$ns at 437.47765855269876 "$node_(152) setdest 24624 472 8.0" 
$ns at 543.5146994712086 "$node_(152) setdest 159798 1033 15.0" 
$ns at 700.0497097537284 "$node_(152) setdest 87786 5291 6.0" 
$ns at 779.7268546503926 "$node_(152) setdest 136542 17186 17.0" 
$ns at 864.9738927808405 "$node_(152) setdest 192494 21862 17.0" 
$ns at 118.37597821065236 "$node_(153) setdest 39341 25412 15.0" 
$ns at 210.5047697861825 "$node_(153) setdest 39709 907 13.0" 
$ns at 365.59717637125607 "$node_(153) setdest 79018 14527 17.0" 
$ns at 460.7902469738451 "$node_(153) setdest 131672 59685 4.0" 
$ns at 512.7400958401525 "$node_(153) setdest 121950 51333 16.0" 
$ns at 666.6893820307369 "$node_(153) setdest 185273 38107 19.0" 
$ns at 835.1986279923967 "$node_(153) setdest 184563 23082 10.0" 
$ns at 163.64350429440407 "$node_(154) setdest 22028 25353 18.0" 
$ns at 232.58845945197524 "$node_(154) setdest 8545 36667 9.0" 
$ns at 335.5582165174982 "$node_(154) setdest 24549 43304 15.0" 
$ns at 490.49237325463093 "$node_(154) setdest 102201 53265 14.0" 
$ns at 530.4795064567621 "$node_(154) setdest 47639 41729 8.0" 
$ns at 584.25042242073 "$node_(154) setdest 197888 28849 14.0" 
$ns at 706.9098277654361 "$node_(154) setdest 10645 77241 10.0" 
$ns at 769.1137618356431 "$node_(154) setdest 222987 7555 7.0" 
$ns at 827.4960311702831 "$node_(154) setdest 137729 77029 10.0" 
$ns at 134.53251824489914 "$node_(155) setdest 56757 636 7.0" 
$ns at 222.09315532823547 "$node_(155) setdest 62678 501 16.0" 
$ns at 289.61531104533117 "$node_(155) setdest 47334 19197 9.0" 
$ns at 353.3178623103874 "$node_(155) setdest 85527 33132 2.0" 
$ns at 396.96014013288067 "$node_(155) setdest 62038 60746 20.0" 
$ns at 573.141392957745 "$node_(155) setdest 144988 76543 1.0" 
$ns at 608.8670375468853 "$node_(155) setdest 230507 20013 5.0" 
$ns at 640.9295311151346 "$node_(155) setdest 153263 70402 6.0" 
$ns at 710.7046067849515 "$node_(155) setdest 196094 75425 7.0" 
$ns at 771.3325091659262 "$node_(155) setdest 124 26562 14.0" 
$ns at 806.969087072762 "$node_(155) setdest 121578 63589 18.0" 
$ns at 102.49975150287676 "$node_(156) setdest 52904 21554 2.0" 
$ns at 151.0207599886338 "$node_(156) setdest 124534 10181 18.0" 
$ns at 206.95681984565192 "$node_(156) setdest 94048 4805 10.0" 
$ns at 324.0384300944283 "$node_(156) setdest 45036 23593 8.0" 
$ns at 405.4874208750655 "$node_(156) setdest 5475 5786 13.0" 
$ns at 476.3196951999714 "$node_(156) setdest 179381 40429 18.0" 
$ns at 546.7218150359737 "$node_(156) setdest 141897 67847 5.0" 
$ns at 602.3649365152428 "$node_(156) setdest 149289 61023 15.0" 
$ns at 780.6243212800282 "$node_(156) setdest 32059 31101 9.0" 
$ns at 854.2864261153197 "$node_(156) setdest 146877 29253 5.0" 
$ns at 147.3388115720535 "$node_(157) setdest 21105 18151 2.0" 
$ns at 184.31092734991853 "$node_(157) setdest 55531 19190 18.0" 
$ns at 285.6271527353176 "$node_(157) setdest 64265 48787 20.0" 
$ns at 324.8644906416255 "$node_(157) setdest 61572 16800 2.0" 
$ns at 356.9955297835196 "$node_(157) setdest 164973 26538 16.0" 
$ns at 427.0682060209822 "$node_(157) setdest 18242 49118 14.0" 
$ns at 535.670615575358 "$node_(157) setdest 203786 17002 3.0" 
$ns at 580.3980636173037 "$node_(157) setdest 132922 22120 1.0" 
$ns at 612.5207433944881 "$node_(157) setdest 17307 40909 2.0" 
$ns at 643.9647408935002 "$node_(157) setdest 51512 66346 7.0" 
$ns at 688.7677868644992 "$node_(157) setdest 172365 50548 18.0" 
$ns at 800.8362329416632 "$node_(157) setdest 154794 39227 1.0" 
$ns at 833.4673300519167 "$node_(157) setdest 173 2449 4.0" 
$ns at 897.484976564629 "$node_(157) setdest 220402 7766 6.0" 
$ns at 165.902806639634 "$node_(158) setdest 56585 44347 3.0" 
$ns at 214.46451574248033 "$node_(158) setdest 30447 24998 3.0" 
$ns at 248.59523744246297 "$node_(158) setdest 45285 28038 7.0" 
$ns at 289.586109218251 "$node_(158) setdest 162253 53223 19.0" 
$ns at 374.2993374499274 "$node_(158) setdest 104190 33959 3.0" 
$ns at 411.53931946071583 "$node_(158) setdest 132566 38339 7.0" 
$ns at 470.29049644895855 "$node_(158) setdest 189151 37530 8.0" 
$ns at 531.5646278135895 "$node_(158) setdest 135885 38507 17.0" 
$ns at 571.6386338665475 "$node_(158) setdest 100635 23622 14.0" 
$ns at 658.7310681015199 "$node_(158) setdest 96678 5024 9.0" 
$ns at 736.4087192368725 "$node_(158) setdest 222053 63816 17.0" 
$ns at 772.4532550565892 "$node_(158) setdest 146885 2378 5.0" 
$ns at 837.5879332025931 "$node_(158) setdest 210027 49199 3.0" 
$ns at 878.0126904098809 "$node_(158) setdest 38731 46831 2.0" 
$ns at 137.95017910468573 "$node_(159) setdest 78543 17362 9.0" 
$ns at 195.4790662339562 "$node_(159) setdest 39503 38217 7.0" 
$ns at 279.6461951059898 "$node_(159) setdest 18372 41808 6.0" 
$ns at 360.14206018844345 "$node_(159) setdest 125967 43633 19.0" 
$ns at 557.1687516987109 "$node_(159) setdest 43381 55240 5.0" 
$ns at 613.8669964428906 "$node_(159) setdest 91266 34573 19.0" 
$ns at 715.9612372871952 "$node_(159) setdest 148801 20636 11.0" 
$ns at 767.384978534012 "$node_(159) setdest 35690 66961 16.0" 
$ns at 830.9272317172881 "$node_(159) setdest 218660 28025 16.0" 
$ns at 184.90572625979146 "$node_(160) setdest 130304 6032 4.0" 
$ns at 253.18723503665734 "$node_(160) setdest 88394 17461 13.0" 
$ns at 315.4101839148725 "$node_(160) setdest 161015 28329 17.0" 
$ns at 392.15829274513965 "$node_(160) setdest 65357 43620 8.0" 
$ns at 462.3527029273164 "$node_(160) setdest 119604 37196 16.0" 
$ns at 507.3791173377534 "$node_(160) setdest 140935 60016 16.0" 
$ns at 558.0166239528825 "$node_(160) setdest 159274 25195 7.0" 
$ns at 633.7116480608878 "$node_(160) setdest 70762 57323 1.0" 
$ns at 670.1092091314224 "$node_(160) setdest 247160 33559 19.0" 
$ns at 743.7603014289805 "$node_(160) setdest 45584 61708 8.0" 
$ns at 816.1357631083579 "$node_(160) setdest 209054 69924 13.0" 
$ns at 187.10819349225477 "$node_(161) setdest 4521 31890 10.0" 
$ns at 314.32380396779735 "$node_(161) setdest 154510 642 17.0" 
$ns at 422.7454482227455 "$node_(161) setdest 167780 61514 11.0" 
$ns at 469.7803453123876 "$node_(161) setdest 189774 18304 10.0" 
$ns at 558.3896948274707 "$node_(161) setdest 227983 53323 20.0" 
$ns at 660.7762634978105 "$node_(161) setdest 26951 72377 12.0" 
$ns at 725.9447084931949 "$node_(161) setdest 196724 34980 9.0" 
$ns at 827.6900507362353 "$node_(161) setdest 158496 46030 16.0" 
$ns at 228.45353622541307 "$node_(162) setdest 120453 33488 3.0" 
$ns at 287.424917782373 "$node_(162) setdest 100244 17706 12.0" 
$ns at 341.79163462380166 "$node_(162) setdest 85167 41586 14.0" 
$ns at 409.2724581533233 "$node_(162) setdest 15550 56822 4.0" 
$ns at 476.1796730959693 "$node_(162) setdest 161482 29613 17.0" 
$ns at 555.3112101879559 "$node_(162) setdest 76342 3656 2.0" 
$ns at 595.9832658005532 "$node_(162) setdest 138817 63329 12.0" 
$ns at 730.3431246712105 "$node_(162) setdest 162568 53106 3.0" 
$ns at 771.8270038665648 "$node_(162) setdest 76942 28955 17.0" 
$ns at 898.3187010046425 "$node_(162) setdest 14246 37446 11.0" 
$ns at 189.124569111838 "$node_(163) setdest 55295 450 15.0" 
$ns at 331.23545143240324 "$node_(163) setdest 76915 963 1.0" 
$ns at 361.4701338884927 "$node_(163) setdest 21248 35211 1.0" 
$ns at 400.67792234366493 "$node_(163) setdest 131763 58661 13.0" 
$ns at 510.5459064290216 "$node_(163) setdest 149012 13628 18.0" 
$ns at 589.3884031401329 "$node_(163) setdest 157451 64327 2.0" 
$ns at 628.1375122952613 "$node_(163) setdest 76353 14146 16.0" 
$ns at 676.1200814221377 "$node_(163) setdest 49969 7833 3.0" 
$ns at 707.6546599706743 "$node_(163) setdest 174017 6998 7.0" 
$ns at 788.8942694916658 "$node_(163) setdest 164157 45376 10.0" 
$ns at 169.69038886565107 "$node_(164) setdest 52007 43865 1.0" 
$ns at 202.17463740800383 "$node_(164) setdest 48011 23969 18.0" 
$ns at 293.114328196496 "$node_(164) setdest 89392 3742 14.0" 
$ns at 398.3513468008417 "$node_(164) setdest 113240 17169 6.0" 
$ns at 471.25567249958584 "$node_(164) setdest 50959 55640 8.0" 
$ns at 575.0144190724807 "$node_(164) setdest 57777 62888 20.0" 
$ns at 619.8460768394392 "$node_(164) setdest 120754 24941 2.0" 
$ns at 665.2153379222989 "$node_(164) setdest 181748 1361 19.0" 
$ns at 869.5504088629632 "$node_(164) setdest 89309 82323 6.0" 
$ns at 125.94287115930595 "$node_(165) setdest 28112 15176 16.0" 
$ns at 162.92062232646373 "$node_(165) setdest 874 9681 6.0" 
$ns at 245.39294491240298 "$node_(165) setdest 25088 39638 4.0" 
$ns at 276.4821068179452 "$node_(165) setdest 21278 44226 14.0" 
$ns at 424.4264553393173 "$node_(165) setdest 24739 13245 13.0" 
$ns at 499.88103429439207 "$node_(165) setdest 95635 22261 20.0" 
$ns at 589.138077101958 "$node_(165) setdest 153352 31077 3.0" 
$ns at 648.595320473153 "$node_(165) setdest 41328 48313 1.0" 
$ns at 681.0111265390115 "$node_(165) setdest 30573 77148 10.0" 
$ns at 803.0853909394125 "$node_(165) setdest 201283 3249 10.0" 
$ns at 120.4283537201049 "$node_(166) setdest 76594 18461 14.0" 
$ns at 162.86237116189756 "$node_(166) setdest 87140 620 9.0" 
$ns at 273.88653146383984 "$node_(166) setdest 145743 13588 7.0" 
$ns at 343.4785126914278 "$node_(166) setdest 50344 42913 11.0" 
$ns at 375.48361190844474 "$node_(166) setdest 40756 15077 16.0" 
$ns at 498.5052734729032 "$node_(166) setdest 172357 30483 1.0" 
$ns at 537.4587350635016 "$node_(166) setdest 42919 50667 9.0" 
$ns at 618.1310477125671 "$node_(166) setdest 196027 72683 17.0" 
$ns at 804.5896752597141 "$node_(166) setdest 137711 55094 5.0" 
$ns at 862.269018172735 "$node_(166) setdest 267962 36280 19.0" 
$ns at 104.73120709976149 "$node_(167) setdest 53637 7774 5.0" 
$ns at 170.0036772055696 "$node_(167) setdest 38293 24728 20.0" 
$ns at 268.47144411504746 "$node_(167) setdest 79947 1251 5.0" 
$ns at 317.59471981011484 "$node_(167) setdest 7557 43024 19.0" 
$ns at 375.84438874326446 "$node_(167) setdest 99471 26541 1.0" 
$ns at 414.6662907037907 "$node_(167) setdest 32785 52743 16.0" 
$ns at 514.5776071941827 "$node_(167) setdest 100037 28620 1.0" 
$ns at 546.4616971369417 "$node_(167) setdest 185781 13554 19.0" 
$ns at 664.882552715716 "$node_(167) setdest 145675 15970 16.0" 
$ns at 839.5935667249782 "$node_(167) setdest 39719 78674 9.0" 
$ns at 128.08746981118662 "$node_(168) setdest 87159 5785 4.0" 
$ns at 158.92445007969565 "$node_(168) setdest 55871 27413 19.0" 
$ns at 274.2865595379274 "$node_(168) setdest 95722 9818 18.0" 
$ns at 450.5303350211769 "$node_(168) setdest 99509 51378 13.0" 
$ns at 496.9245112274807 "$node_(168) setdest 136472 40777 15.0" 
$ns at 654.8094341732763 "$node_(168) setdest 218056 59856 12.0" 
$ns at 742.6455843321098 "$node_(168) setdest 115688 52875 12.0" 
$ns at 772.6635529236937 "$node_(168) setdest 72392 66195 13.0" 
$ns at 886.5161090830429 "$node_(168) setdest 90925 15046 7.0" 
$ns at 103.86083155308182 "$node_(169) setdest 41904 30397 11.0" 
$ns at 178.70688927435967 "$node_(169) setdest 43025 34108 5.0" 
$ns at 209.32649102436133 "$node_(169) setdest 37549 656 17.0" 
$ns at 363.2464018173413 "$node_(169) setdest 29245 62310 18.0" 
$ns at 529.9441000242499 "$node_(169) setdest 159211 34858 16.0" 
$ns at 566.5344609165408 "$node_(169) setdest 57496 4934 9.0" 
$ns at 661.897863577053 "$node_(169) setdest 244150 27777 20.0" 
$ns at 740.6326288090681 "$node_(169) setdest 70356 17908 1.0" 
$ns at 780.3622672005929 "$node_(169) setdest 108677 71263 4.0" 
$ns at 827.5411166128061 "$node_(169) setdest 65401 41418 4.0" 
$ns at 873.1534610104275 "$node_(169) setdest 264036 45214 5.0" 
$ns at 142.81186329357115 "$node_(170) setdest 57128 17940 2.0" 
$ns at 174.04551916464135 "$node_(170) setdest 114201 31906 18.0" 
$ns at 375.70633215072246 "$node_(170) setdest 43738 52888 13.0" 
$ns at 534.9259844245553 "$node_(170) setdest 96701 7627 4.0" 
$ns at 599.1075200625019 "$node_(170) setdest 46896 38249 18.0" 
$ns at 791.0314881994659 "$node_(170) setdest 154343 59397 2.0" 
$ns at 822.8940647148053 "$node_(170) setdest 19393 31614 18.0" 
$ns at 125.4056043768533 "$node_(171) setdest 69426 4126 17.0" 
$ns at 222.06824515016578 "$node_(171) setdest 5893 3574 19.0" 
$ns at 340.54083250696465 "$node_(171) setdest 32644 32926 15.0" 
$ns at 403.3861675446811 "$node_(171) setdest 179112 31043 1.0" 
$ns at 434.0071908885795 "$node_(171) setdest 177118 47025 14.0" 
$ns at 516.5439025907153 "$node_(171) setdest 211779 69228 13.0" 
$ns at 562.9421981511796 "$node_(171) setdest 17246 71694 10.0" 
$ns at 650.6776079901746 "$node_(171) setdest 122840 54537 18.0" 
$ns at 716.9337855832464 "$node_(171) setdest 81689 21219 1.0" 
$ns at 755.798249925754 "$node_(171) setdest 126909 77771 2.0" 
$ns at 788.5521637920921 "$node_(171) setdest 220619 20205 17.0" 
$ns at 862.528832291993 "$node_(171) setdest 201836 35082 16.0" 
$ns at 135.94184088523633 "$node_(172) setdest 76868 2826 14.0" 
$ns at 232.21155838034812 "$node_(172) setdest 132834 1141 14.0" 
$ns at 395.8479454616538 "$node_(172) setdest 102156 3948 7.0" 
$ns at 452.01942750447625 "$node_(172) setdest 8139 25996 11.0" 
$ns at 548.3219506355143 "$node_(172) setdest 81256 31915 4.0" 
$ns at 604.9214975762874 "$node_(172) setdest 69693 19837 8.0" 
$ns at 655.4964861015105 "$node_(172) setdest 246805 10408 15.0" 
$ns at 704.1291554631117 "$node_(172) setdest 193477 78142 1.0" 
$ns at 742.1372773380444 "$node_(172) setdest 100001 3917 2.0" 
$ns at 772.9309086269992 "$node_(172) setdest 234302 20642 5.0" 
$ns at 838.5536846335442 "$node_(172) setdest 111391 34143 4.0" 
$ns at 872.2256345551281 "$node_(172) setdest 63097 62513 14.0" 
$ns at 215.1875660891717 "$node_(173) setdest 126858 1629 14.0" 
$ns at 272.84614237338604 "$node_(173) setdest 79743 54150 9.0" 
$ns at 351.2030482906662 "$node_(173) setdest 51715 10791 16.0" 
$ns at 388.3230546833039 "$node_(173) setdest 150858 40844 19.0" 
$ns at 543.6494887554148 "$node_(173) setdest 109561 65734 12.0" 
$ns at 611.2550547428492 "$node_(173) setdest 163627 10131 12.0" 
$ns at 647.7958190881683 "$node_(173) setdest 140531 64809 1.0" 
$ns at 680.741428514674 "$node_(173) setdest 9714 65690 1.0" 
$ns at 718.049463720039 "$node_(173) setdest 170093 5519 1.0" 
$ns at 749.6591141694828 "$node_(173) setdest 92374 37724 16.0" 
$ns at 893.8296649211194 "$node_(173) setdest 232828 41540 13.0" 
$ns at 184.2123142980264 "$node_(174) setdest 110003 10492 1.0" 
$ns at 218.0573465351241 "$node_(174) setdest 40330 32583 4.0" 
$ns at 267.6945094009434 "$node_(174) setdest 30262 23390 5.0" 
$ns at 318.17141438210035 "$node_(174) setdest 91293 45500 5.0" 
$ns at 362.62351683937396 "$node_(174) setdest 139382 43433 5.0" 
$ns at 400.1203251656517 "$node_(174) setdest 38194 6433 4.0" 
$ns at 443.68356591741315 "$node_(174) setdest 188663 16183 5.0" 
$ns at 475.5381783725504 "$node_(174) setdest 178614 3581 12.0" 
$ns at 512.7263650340085 "$node_(174) setdest 55112 53326 10.0" 
$ns at 580.7686551432964 "$node_(174) setdest 169276 46173 17.0" 
$ns at 719.0719218717902 "$node_(174) setdest 213807 25784 16.0" 
$ns at 811.9528511773816 "$node_(174) setdest 23425 72047 4.0" 
$ns at 844.476853535514 "$node_(174) setdest 64164 50259 9.0" 
$ns at 895.680048194525 "$node_(174) setdest 110197 66527 5.0" 
$ns at 101.92201609623699 "$node_(175) setdest 1636 30449 8.0" 
$ns at 139.20585755650194 "$node_(175) setdest 81856 9966 20.0" 
$ns at 269.4220017210173 "$node_(175) setdest 151953 29931 10.0" 
$ns at 320.19286752889775 "$node_(175) setdest 60681 47712 10.0" 
$ns at 366.704775279392 "$node_(175) setdest 62035 44289 9.0" 
$ns at 431.9013188985985 "$node_(175) setdest 39697 17423 10.0" 
$ns at 558.3421948623313 "$node_(175) setdest 231568 38649 15.0" 
$ns at 676.1839077000222 "$node_(175) setdest 21479 62503 14.0" 
$ns at 796.4736463583804 "$node_(175) setdest 203481 61169 15.0" 
$ns at 890.5368938803382 "$node_(175) setdest 191548 42929 10.0" 
$ns at 124.53551085462955 "$node_(176) setdest 29402 27805 14.0" 
$ns at 230.4038398533133 "$node_(176) setdest 15807 27144 19.0" 
$ns at 434.11144731614036 "$node_(176) setdest 96711 41528 16.0" 
$ns at 579.9162685043842 "$node_(176) setdest 112357 32970 4.0" 
$ns at 628.8355003964137 "$node_(176) setdest 121292 24045 17.0" 
$ns at 703.0037615464068 "$node_(176) setdest 46076 69409 14.0" 
$ns at 777.4440398921082 "$node_(176) setdest 96289 2203 19.0" 
$ns at 808.8593693821593 "$node_(176) setdest 74155 1149 10.0" 
$ns at 121.67090376622029 "$node_(177) setdest 70981 25869 17.0" 
$ns at 305.65119088535494 "$node_(177) setdest 96246 51713 14.0" 
$ns at 352.5748189805612 "$node_(177) setdest 127133 4825 9.0" 
$ns at 451.84648618272195 "$node_(177) setdest 36590 65402 10.0" 
$ns at 575.1528445373507 "$node_(177) setdest 73058 54817 14.0" 
$ns at 689.0843230508932 "$node_(177) setdest 139942 2803 4.0" 
$ns at 756.4388459836883 "$node_(177) setdest 199162 32221 8.0" 
$ns at 838.3266400003039 "$node_(177) setdest 140878 89188 1.0" 
$ns at 869.0912480320434 "$node_(177) setdest 235909 26175 20.0" 
$ns at 132.41819673071234 "$node_(178) setdest 88795 2377 14.0" 
$ns at 211.8224817735795 "$node_(178) setdest 85776 2248 6.0" 
$ns at 290.3697119800543 "$node_(178) setdest 162525 14375 6.0" 
$ns at 337.7317416568402 "$node_(178) setdest 53301 2452 6.0" 
$ns at 412.32181135673824 "$node_(178) setdest 130159 45449 18.0" 
$ns at 603.3252592144268 "$node_(178) setdest 159997 11554 17.0" 
$ns at 680.1950253996355 "$node_(178) setdest 89140 11086 13.0" 
$ns at 833.2095248574869 "$node_(178) setdest 170001 48087 3.0" 
$ns at 891.1238822584992 "$node_(178) setdest 185353 46053 14.0" 
$ns at 134.7397649030366 "$node_(179) setdest 46928 29057 8.0" 
$ns at 244.71095744463707 "$node_(179) setdest 129931 18946 19.0" 
$ns at 281.5656089825804 "$node_(179) setdest 75768 33450 7.0" 
$ns at 344.48359722357924 "$node_(179) setdest 137969 45925 10.0" 
$ns at 387.08190598878895 "$node_(179) setdest 89425 52528 19.0" 
$ns at 492.9079813514971 "$node_(179) setdest 45881 56378 14.0" 
$ns at 615.0031596220806 "$node_(179) setdest 104245 33603 13.0" 
$ns at 725.6619033936171 "$node_(179) setdest 48769 57095 15.0" 
$ns at 777.800169328545 "$node_(179) setdest 196197 36769 1.0" 
$ns at 808.8287627204733 "$node_(179) setdest 41667 51657 11.0" 
$ns at 133.69531525671096 "$node_(180) setdest 22417 20154 9.0" 
$ns at 246.2403671712964 "$node_(180) setdest 109051 35846 20.0" 
$ns at 319.3145115587592 "$node_(180) setdest 16207 34972 16.0" 
$ns at 368.5926161074531 "$node_(180) setdest 17838 54930 2.0" 
$ns at 411.87699100810306 "$node_(180) setdest 117993 5961 3.0" 
$ns at 460.2370383717054 "$node_(180) setdest 46049 14537 1.0" 
$ns at 498.22272433450723 "$node_(180) setdest 66234 2387 4.0" 
$ns at 540.6876768960102 "$node_(180) setdest 144341 42999 4.0" 
$ns at 605.2334877834836 "$node_(180) setdest 52302 39193 11.0" 
$ns at 721.3224068880173 "$node_(180) setdest 61041 6779 16.0" 
$ns at 879.265501374496 "$node_(180) setdest 62002 71959 2.0" 
$ns at 100.48992989221995 "$node_(181) setdest 75073 31430 10.0" 
$ns at 190.7675189938089 "$node_(181) setdest 75199 9342 1.0" 
$ns at 225.23873496485803 "$node_(181) setdest 73679 12510 2.0" 
$ns at 264.611291942849 "$node_(181) setdest 92688 7638 5.0" 
$ns at 298.76191537478496 "$node_(181) setdest 130947 47509 1.0" 
$ns at 336.01197949572554 "$node_(181) setdest 97214 53821 5.0" 
$ns at 412.1431561588244 "$node_(181) setdest 59060 358 8.0" 
$ns at 475.0226652771713 "$node_(181) setdest 135920 43787 16.0" 
$ns at 664.0498937803037 "$node_(181) setdest 143754 77640 13.0" 
$ns at 756.8904657388747 "$node_(181) setdest 38130 57381 1.0" 
$ns at 790.14633445555 "$node_(181) setdest 186944 43628 17.0" 
$ns at 897.758701631409 "$node_(181) setdest 33091 71529 2.0" 
$ns at 105.41215234481471 "$node_(182) setdest 90504 24417 16.0" 
$ns at 197.76969620196627 "$node_(182) setdest 43388 18301 4.0" 
$ns at 255.4239352955261 "$node_(182) setdest 87992 49525 5.0" 
$ns at 314.7465052171427 "$node_(182) setdest 156224 41116 15.0" 
$ns at 481.2780300481648 "$node_(182) setdest 10329 57315 16.0" 
$ns at 587.4651508637047 "$node_(182) setdest 64158 71988 16.0" 
$ns at 622.6133846789347 "$node_(182) setdest 144724 76260 1.0" 
$ns at 659.3232095416483 "$node_(182) setdest 199246 6789 3.0" 
$ns at 709.664568056206 "$node_(182) setdest 135234 67767 18.0" 
$ns at 105.7034729100314 "$node_(183) setdest 78793 19603 1.0" 
$ns at 141.04528026649538 "$node_(183) setdest 85139 21195 3.0" 
$ns at 181.41279628033297 "$node_(183) setdest 53271 31124 11.0" 
$ns at 307.3706178233146 "$node_(183) setdest 92876 45285 20.0" 
$ns at 356.81059818017417 "$node_(183) setdest 187634 22396 2.0" 
$ns at 396.42126107919046 "$node_(183) setdest 40888 42027 15.0" 
$ns at 559.8378983871623 "$node_(183) setdest 158590 39527 10.0" 
$ns at 635.5001700842757 "$node_(183) setdest 125815 28237 19.0" 
$ns at 744.5468386640714 "$node_(183) setdest 176909 31039 2.0" 
$ns at 788.1124434327196 "$node_(183) setdest 28197 28470 14.0" 
$ns at 857.3865954157341 "$node_(183) setdest 194028 12804 16.0" 
$ns at 134.92630094793304 "$node_(184) setdest 71750 1689 13.0" 
$ns at 272.157927987523 "$node_(184) setdest 103198 25056 1.0" 
$ns at 302.45190001492614 "$node_(184) setdest 69362 49765 12.0" 
$ns at 342.79936381927973 "$node_(184) setdest 61434 52466 16.0" 
$ns at 456.1393609682518 "$node_(184) setdest 111522 33747 8.0" 
$ns at 519.8420995070685 "$node_(184) setdest 203473 26697 11.0" 
$ns at 563.9600641926673 "$node_(184) setdest 220235 31908 7.0" 
$ns at 631.0057744923527 "$node_(184) setdest 149023 54860 16.0" 
$ns at 779.5327560502355 "$node_(184) setdest 89987 55920 5.0" 
$ns at 853.2190510840632 "$node_(184) setdest 195015 56620 8.0" 
$ns at 893.412320720268 "$node_(184) setdest 218031 16276 16.0" 
$ns at 143.3303216415825 "$node_(185) setdest 51738 9047 1.0" 
$ns at 176.02979605197248 "$node_(185) setdest 17912 3315 2.0" 
$ns at 217.74325884288768 "$node_(185) setdest 95120 2257 8.0" 
$ns at 279.0083426727369 "$node_(185) setdest 101441 49644 16.0" 
$ns at 370.00420112420636 "$node_(185) setdest 33320 21987 15.0" 
$ns at 465.55121681991926 "$node_(185) setdest 843 45278 6.0" 
$ns at 503.01647067445447 "$node_(185) setdest 193368 29615 11.0" 
$ns at 553.0266183375496 "$node_(185) setdest 89509 72838 1.0" 
$ns at 590.0990136667212 "$node_(185) setdest 221780 73732 16.0" 
$ns at 651.9656897071196 "$node_(185) setdest 209576 39539 11.0" 
$ns at 758.5712298032593 "$node_(185) setdest 77903 7974 16.0" 
$ns at 789.2919738014352 "$node_(185) setdest 24594 72599 12.0" 
$ns at 867.7899974819255 "$node_(185) setdest 82357 12871 13.0" 
$ns at 105.2081684252227 "$node_(186) setdest 29384 9337 1.0" 
$ns at 143.8430707801115 "$node_(186) setdest 61714 4621 15.0" 
$ns at 241.58929814112864 "$node_(186) setdest 112821 34921 3.0" 
$ns at 272.5375285718295 "$node_(186) setdest 17653 40069 7.0" 
$ns at 303.19919216046264 "$node_(186) setdest 129523 19560 11.0" 
$ns at 406.3154060768498 "$node_(186) setdest 86947 30305 19.0" 
$ns at 596.9567870825132 "$node_(186) setdest 121471 3577 8.0" 
$ns at 636.5057487018346 "$node_(186) setdest 215786 75053 16.0" 
$ns at 810.5495484455437 "$node_(186) setdest 148412 39307 4.0" 
$ns at 868.3301305371484 "$node_(186) setdest 173696 33179 17.0" 
$ns at 164.8817324328702 "$node_(187) setdest 106880 22784 3.0" 
$ns at 203.03441214093704 "$node_(187) setdest 83153 9215 11.0" 
$ns at 248.20528631153815 "$node_(187) setdest 65641 20259 13.0" 
$ns at 362.99018468011946 "$node_(187) setdest 103768 8954 12.0" 
$ns at 404.61128570595866 "$node_(187) setdest 113623 19104 6.0" 
$ns at 463.5900116693195 "$node_(187) setdest 105026 22189 10.0" 
$ns at 584.6530643650141 "$node_(187) setdest 155375 67408 1.0" 
$ns at 618.2727979851617 "$node_(187) setdest 3441 17527 16.0" 
$ns at 763.9168226987589 "$node_(187) setdest 264251 40704 19.0" 
$ns at 149.6836912325496 "$node_(188) setdest 83535 25968 20.0" 
$ns at 334.47128024171866 "$node_(188) setdest 33690 2299 14.0" 
$ns at 461.66349677507026 "$node_(188) setdest 106616 46164 19.0" 
$ns at 591.6751849905049 "$node_(188) setdest 167154 63582 18.0" 
$ns at 664.8114330921791 "$node_(188) setdest 114612 75812 17.0" 
$ns at 743.5385628272049 "$node_(188) setdest 92408 46815 18.0" 
$ns at 830.672009046533 "$node_(188) setdest 85864 14696 19.0" 
$ns at 210.8099804410307 "$node_(189) setdest 125643 21135 20.0" 
$ns at 420.8316730518767 "$node_(189) setdest 22329 45302 8.0" 
$ns at 501.306969208398 "$node_(189) setdest 175608 62034 14.0" 
$ns at 567.1134913034784 "$node_(189) setdest 120091 68830 10.0" 
$ns at 627.2304739999046 "$node_(189) setdest 157668 57845 13.0" 
$ns at 688.9665206353533 "$node_(189) setdest 230275 17712 15.0" 
$ns at 856.295647477475 "$node_(189) setdest 127061 86193 18.0" 
$ns at 119.75505305581238 "$node_(190) setdest 54874 27501 5.0" 
$ns at 179.67444234564806 "$node_(190) setdest 117624 27114 15.0" 
$ns at 212.62633313766588 "$node_(190) setdest 79087 13272 9.0" 
$ns at 321.80831568052184 "$node_(190) setdest 54508 25607 8.0" 
$ns at 357.1143925754002 "$node_(190) setdest 38499 54408 14.0" 
$ns at 408.84596496982635 "$node_(190) setdest 148970 3524 6.0" 
$ns at 464.84568638038826 "$node_(190) setdest 204951 11126 9.0" 
$ns at 534.9956390790136 "$node_(190) setdest 152171 51651 6.0" 
$ns at 578.2753503934542 "$node_(190) setdest 5711 59394 3.0" 
$ns at 633.6966738579504 "$node_(190) setdest 33227 13626 13.0" 
$ns at 698.7703455401974 "$node_(190) setdest 56963 16179 10.0" 
$ns at 729.7891054097605 "$node_(190) setdest 43332 11544 6.0" 
$ns at 760.3201059121593 "$node_(190) setdest 54406 13632 1.0" 
$ns at 799.7782052785308 "$node_(190) setdest 86343 82005 12.0" 
$ns at 854.3093208491055 "$node_(190) setdest 73781 74944 12.0" 
$ns at 897.2244687439064 "$node_(190) setdest 14880 79149 12.0" 
$ns at 116.24745843235996 "$node_(191) setdest 29112 17374 17.0" 
$ns at 203.87465446168102 "$node_(191) setdest 127008 20785 13.0" 
$ns at 296.16748485888616 "$node_(191) setdest 157453 50898 15.0" 
$ns at 340.18436554289883 "$node_(191) setdest 95735 1298 10.0" 
$ns at 403.06756827677196 "$node_(191) setdest 99047 16810 13.0" 
$ns at 497.00939321880463 "$node_(191) setdest 79045 55363 3.0" 
$ns at 545.2494077608968 "$node_(191) setdest 108433 23805 10.0" 
$ns at 591.9725143445788 "$node_(191) setdest 223281 32636 12.0" 
$ns at 674.4964455920511 "$node_(191) setdest 59258 74702 8.0" 
$ns at 737.6196147186729 "$node_(191) setdest 136872 81070 2.0" 
$ns at 783.7741046520582 "$node_(191) setdest 4657 88363 16.0" 
$ns at 891.1985272023553 "$node_(191) setdest 217138 1075 18.0" 
$ns at 106.69786270653398 "$node_(192) setdest 39848 4747 3.0" 
$ns at 139.3460833239186 "$node_(192) setdest 40476 25752 16.0" 
$ns at 198.1097625902379 "$node_(192) setdest 130926 19438 8.0" 
$ns at 228.87098967907085 "$node_(192) setdest 35720 42539 14.0" 
$ns at 288.3251634816467 "$node_(192) setdest 16720 22496 15.0" 
$ns at 386.4592812247721 "$node_(192) setdest 15252 2015 1.0" 
$ns at 421.13533605611457 "$node_(192) setdest 108704 11680 12.0" 
$ns at 541.4281880688604 "$node_(192) setdest 24903 68339 15.0" 
$ns at 675.8572158622057 "$node_(192) setdest 3928 39756 9.0" 
$ns at 762.4151298424657 "$node_(192) setdest 264552 40881 7.0" 
$ns at 856.03148251085 "$node_(192) setdest 187590 65831 20.0" 
$ns at 140.5247793947787 "$node_(193) setdest 61544 10363 12.0" 
$ns at 236.49818358468482 "$node_(193) setdest 99813 38623 1.0" 
$ns at 267.4482940335046 "$node_(193) setdest 52494 41471 4.0" 
$ns at 327.7324573987649 "$node_(193) setdest 114458 30385 20.0" 
$ns at 504.99010003515843 "$node_(193) setdest 67291 18050 2.0" 
$ns at 535.8852213462204 "$node_(193) setdest 155767 62717 1.0" 
$ns at 574.6004643409965 "$node_(193) setdest 210688 16378 6.0" 
$ns at 652.6279159488544 "$node_(193) setdest 42762 48251 3.0" 
$ns at 692.9335383058714 "$node_(193) setdest 73756 19672 11.0" 
$ns at 832.7572126980883 "$node_(193) setdest 259426 79865 17.0" 
$ns at 182.2408905128125 "$node_(194) setdest 35864 8287 10.0" 
$ns at 232.3570627675703 "$node_(194) setdest 119349 14981 17.0" 
$ns at 394.8706661982394 "$node_(194) setdest 166479 56877 20.0" 
$ns at 435.1616973145983 "$node_(194) setdest 53440 62413 13.0" 
$ns at 532.1121068609598 "$node_(194) setdest 134413 40913 7.0" 
$ns at 588.120024790072 "$node_(194) setdest 151917 7719 14.0" 
$ns at 733.5294259819013 "$node_(194) setdest 121064 13277 6.0" 
$ns at 790.9265513813062 "$node_(194) setdest 13542 28377 15.0" 
$ns at 885.1952201135673 "$node_(194) setdest 32088 82264 5.0" 
$ns at 218.6457468141213 "$node_(195) setdest 111928 547 1.0" 
$ns at 252.66961648935316 "$node_(195) setdest 39147 32092 15.0" 
$ns at 356.9825767919632 "$node_(195) setdest 116955 18814 6.0" 
$ns at 418.4488045404472 "$node_(195) setdest 170879 42422 18.0" 
$ns at 603.6739835747991 "$node_(195) setdest 67578 60673 16.0" 
$ns at 748.8342406154513 "$node_(195) setdest 19179 44388 13.0" 
$ns at 803.6013550522027 "$node_(195) setdest 111877 54795 12.0" 
$ns at 834.3062479881288 "$node_(195) setdest 151855 49899 20.0" 
$ns at 107.96272984107264 "$node_(196) setdest 94137 19700 1.0" 
$ns at 146.6414563656347 "$node_(196) setdest 42551 22033 3.0" 
$ns at 178.7484215739076 "$node_(196) setdest 98071 37830 13.0" 
$ns at 274.32104165052067 "$node_(196) setdest 29021 11788 10.0" 
$ns at 365.3637931418831 "$node_(196) setdest 186178 9497 2.0" 
$ns at 396.424149832486 "$node_(196) setdest 53838 10058 6.0" 
$ns at 485.079659243985 "$node_(196) setdest 83242 30791 7.0" 
$ns at 537.5334777440289 "$node_(196) setdest 46051 11522 5.0" 
$ns at 607.070945468228 "$node_(196) setdest 212317 21291 2.0" 
$ns at 647.796409248645 "$node_(196) setdest 138380 73435 5.0" 
$ns at 706.9182141694525 "$node_(196) setdest 181141 72962 12.0" 
$ns at 836.2136612697067 "$node_(196) setdest 116232 22796 7.0" 
$ns at 104.50564473219573 "$node_(197) setdest 62350 8459 13.0" 
$ns at 139.29316339448417 "$node_(197) setdest 20319 3060 13.0" 
$ns at 245.80565969252285 "$node_(197) setdest 57222 22510 13.0" 
$ns at 293.4281342395992 "$node_(197) setdest 13746 51809 16.0" 
$ns at 413.41603804507355 "$node_(197) setdest 156989 57568 6.0" 
$ns at 446.8919170722047 "$node_(197) setdest 41910 14045 14.0" 
$ns at 595.7392712128092 "$node_(197) setdest 112859 67802 2.0" 
$ns at 629.3629752045808 "$node_(197) setdest 147090 9241 16.0" 
$ns at 743.872914971028 "$node_(197) setdest 86555 15634 11.0" 
$ns at 839.7269077705158 "$node_(197) setdest 133419 75016 19.0" 
$ns at 169.9317063073467 "$node_(198) setdest 122638 19633 11.0" 
$ns at 213.2229345064893 "$node_(198) setdest 72154 762 3.0" 
$ns at 257.4509595718185 "$node_(198) setdest 55588 49596 3.0" 
$ns at 305.8626842311801 "$node_(198) setdest 83588 20651 12.0" 
$ns at 447.8123127670666 "$node_(198) setdest 84447 48896 18.0" 
$ns at 554.8987728586529 "$node_(198) setdest 56412 49077 12.0" 
$ns at 624.051639260045 "$node_(198) setdest 143357 33975 1.0" 
$ns at 658.827344031774 "$node_(198) setdest 213171 15464 6.0" 
$ns at 710.802350105151 "$node_(198) setdest 194358 57348 8.0" 
$ns at 797.2472857332164 "$node_(198) setdest 36219 27754 2.0" 
$ns at 834.627008964257 "$node_(198) setdest 231393 77142 3.0" 
$ns at 889.8419847503942 "$node_(198) setdest 258505 38121 18.0" 
$ns at 114.80778318005324 "$node_(199) setdest 65142 2683 1.0" 
$ns at 152.89320192230932 "$node_(199) setdest 73286 28707 11.0" 
$ns at 262.18962630037504 "$node_(199) setdest 14481 8582 7.0" 
$ns at 335.74166079618647 "$node_(199) setdest 8997 35470 20.0" 
$ns at 410.0100394143642 "$node_(199) setdest 173768 47906 1.0" 
$ns at 443.3905221835135 "$node_(199) setdest 169069 31881 1.0" 
$ns at 481.8104900598574 "$node_(199) setdest 23858 34739 6.0" 
$ns at 525.3249887718804 "$node_(199) setdest 159754 27277 5.0" 
$ns at 559.5258735199063 "$node_(199) setdest 10993 24896 19.0" 
$ns at 607.8020704070963 "$node_(199) setdest 30827 70158 8.0" 
$ns at 641.5008349873947 "$node_(199) setdest 128867 52024 3.0" 
$ns at 673.6524535202606 "$node_(199) setdest 23189 11989 1.0" 
$ns at 709.4885841569461 "$node_(199) setdest 72622 13899 7.0" 
$ns at 756.7959759160657 "$node_(199) setdest 187271 70530 14.0" 
$ns at 787.0321757414388 "$node_(199) setdest 104548 69529 8.0" 
$ns at 844.4081759191183 "$node_(199) setdest 192967 71416 5.0" 
$ns at 331.34619515781526 "$node_(200) setdest 107793 33230 1.0" 
$ns at 362.03570215106475 "$node_(200) setdest 16176 6374 18.0" 
$ns at 457.4179341832087 "$node_(200) setdest 96898 7895 10.0" 
$ns at 507.0570885010412 "$node_(200) setdest 94116 11965 6.0" 
$ns at 546.3069426985323 "$node_(200) setdest 73784 496 4.0" 
$ns at 599.9549259124165 "$node_(200) setdest 33038 23544 19.0" 
$ns at 669.9819750221629 "$node_(200) setdest 118193 10030 17.0" 
$ns at 827.5924354825055 "$node_(200) setdest 107948 27377 9.0" 
$ns at 216.037304794932 "$node_(201) setdest 54501 18551 16.0" 
$ns at 394.77868602964594 "$node_(201) setdest 2968 5673 10.0" 
$ns at 486.1326453761942 "$node_(201) setdest 25690 17431 7.0" 
$ns at 541.8453041706263 "$node_(201) setdest 74303 42558 19.0" 
$ns at 616.8574462471378 "$node_(201) setdest 18432 35219 15.0" 
$ns at 661.097230721544 "$node_(201) setdest 107443 33365 19.0" 
$ns at 730.7850290825684 "$node_(201) setdest 25064 10004 9.0" 
$ns at 836.1784707992522 "$node_(201) setdest 89915 25869 11.0" 
$ns at 314.3588130196214 "$node_(202) setdest 107391 39951 13.0" 
$ns at 440.36090658702835 "$node_(202) setdest 86140 32968 19.0" 
$ns at 636.3152441520028 "$node_(202) setdest 24318 34562 15.0" 
$ns at 792.2553255671314 "$node_(202) setdest 129631 7826 4.0" 
$ns at 858.1797058898989 "$node_(202) setdest 108492 7949 14.0" 
$ns at 892.7843309705429 "$node_(202) setdest 70651 34925 12.0" 
$ns at 218.14960271482178 "$node_(203) setdest 126244 32866 4.0" 
$ns at 272.9625936415986 "$node_(203) setdest 30746 17191 13.0" 
$ns at 349.83365295659337 "$node_(203) setdest 31053 6861 6.0" 
$ns at 384.66620756618323 "$node_(203) setdest 65177 2950 1.0" 
$ns at 421.2418423524339 "$node_(203) setdest 106042 34328 13.0" 
$ns at 490.43948771247165 "$node_(203) setdest 112725 13737 9.0" 
$ns at 597.9362669308866 "$node_(203) setdest 120334 1241 6.0" 
$ns at 673.35646713668 "$node_(203) setdest 18157 4226 6.0" 
$ns at 709.626501774213 "$node_(203) setdest 71475 7556 1.0" 
$ns at 739.8333616244853 "$node_(203) setdest 39958 39218 17.0" 
$ns at 804.5749493426464 "$node_(203) setdest 116954 488 16.0" 
$ns at 288.9653830164974 "$node_(204) setdest 64737 1378 15.0" 
$ns at 452.11802164122514 "$node_(204) setdest 71210 187 15.0" 
$ns at 620.3497415586844 "$node_(204) setdest 107706 17866 5.0" 
$ns at 661.6211093447187 "$node_(204) setdest 107392 11998 8.0" 
$ns at 727.4514403262409 "$node_(204) setdest 83941 26025 11.0" 
$ns at 811.8699508326455 "$node_(204) setdest 55688 41411 6.0" 
$ns at 885.7231928463265 "$node_(204) setdest 37290 16479 19.0" 
$ns at 209.92541113280578 "$node_(205) setdest 103901 25004 19.0" 
$ns at 341.6754614747189 "$node_(205) setdest 119781 42881 5.0" 
$ns at 390.37130508532573 "$node_(205) setdest 31198 41498 11.0" 
$ns at 478.62365326991187 "$node_(205) setdest 109802 16743 17.0" 
$ns at 601.0282721369559 "$node_(205) setdest 99200 12825 17.0" 
$ns at 776.3650345893852 "$node_(205) setdest 124971 23409 1.0" 
$ns at 810.0204345109056 "$node_(205) setdest 71544 32141 1.0" 
$ns at 844.2232062822824 "$node_(205) setdest 123817 10985 3.0" 
$ns at 889.3234052792984 "$node_(205) setdest 57034 2766 5.0" 
$ns at 209.47778985420626 "$node_(206) setdest 93689 17299 1.0" 
$ns at 247.25033003788474 "$node_(206) setdest 36647 19892 17.0" 
$ns at 290.07769957079256 "$node_(206) setdest 114381 41575 13.0" 
$ns at 362.55574180721385 "$node_(206) setdest 108478 26384 16.0" 
$ns at 471.2436020305534 "$node_(206) setdest 91879 20731 19.0" 
$ns at 652.2541885764814 "$node_(206) setdest 67842 28603 18.0" 
$ns at 809.2451061036544 "$node_(206) setdest 104523 3257 12.0" 
$ns at 860.0283019425025 "$node_(206) setdest 110736 33420 19.0" 
$ns at 211.67585047396292 "$node_(207) setdest 125779 20014 4.0" 
$ns at 256.6400742072261 "$node_(207) setdest 32088 44589 8.0" 
$ns at 307.043337194692 "$node_(207) setdest 122342 10141 16.0" 
$ns at 463.3058748337659 "$node_(207) setdest 110211 5008 17.0" 
$ns at 585.7036441598209 "$node_(207) setdest 64194 25300 17.0" 
$ns at 626.4357009695512 "$node_(207) setdest 105910 34093 1.0" 
$ns at 660.6283060981533 "$node_(207) setdest 87469 41205 14.0" 
$ns at 781.3861948425288 "$node_(207) setdest 27409 5104 11.0" 
$ns at 863.4605772601734 "$node_(207) setdest 47731 43831 2.0" 
$ns at 222.74636295328747 "$node_(208) setdest 40225 10363 14.0" 
$ns at 334.03120650094064 "$node_(208) setdest 1492 41377 10.0" 
$ns at 370.4548878219115 "$node_(208) setdest 62550 19909 19.0" 
$ns at 420.47841148218805 "$node_(208) setdest 109730 35180 8.0" 
$ns at 487.7173097357846 "$node_(208) setdest 83061 1036 5.0" 
$ns at 553.581804758646 "$node_(208) setdest 45344 37276 5.0" 
$ns at 617.1919490384607 "$node_(208) setdest 15233 15204 11.0" 
$ns at 713.9410816706766 "$node_(208) setdest 53345 44297 6.0" 
$ns at 794.1382263529315 "$node_(208) setdest 122574 11742 15.0" 
$ns at 230.10195618425251 "$node_(209) setdest 5599 32431 17.0" 
$ns at 421.44510711858646 "$node_(209) setdest 21334 40118 13.0" 
$ns at 473.327556004428 "$node_(209) setdest 127622 6245 12.0" 
$ns at 521.7528201647644 "$node_(209) setdest 116087 17590 17.0" 
$ns at 686.9447404668044 "$node_(209) setdest 15934 43451 17.0" 
$ns at 787.8049603055484 "$node_(209) setdest 61102 26818 10.0" 
$ns at 889.4785671106456 "$node_(209) setdest 4172 18309 11.0" 
$ns at 231.52636927023772 "$node_(210) setdest 99503 15506 8.0" 
$ns at 310.09480682774756 "$node_(210) setdest 83564 33737 17.0" 
$ns at 353.3868731353858 "$node_(210) setdest 66913 16466 16.0" 
$ns at 460.37274889129753 "$node_(210) setdest 62585 17961 6.0" 
$ns at 533.00148458031 "$node_(210) setdest 83487 2152 8.0" 
$ns at 621.3128716923691 "$node_(210) setdest 49823 2305 17.0" 
$ns at 723.8781210718779 "$node_(210) setdest 90255 12767 4.0" 
$ns at 788.3885785881652 "$node_(210) setdest 30286 27544 8.0" 
$ns at 890.0613658707977 "$node_(210) setdest 31648 42952 3.0" 
$ns at 270.90897881709986 "$node_(211) setdest 127677 25588 7.0" 
$ns at 309.96486039420296 "$node_(211) setdest 114602 40421 20.0" 
$ns at 463.09320566397747 "$node_(211) setdest 30245 12272 11.0" 
$ns at 595.3846226449887 "$node_(211) setdest 9353 35013 20.0" 
$ns at 719.9586284806085 "$node_(211) setdest 125384 37678 19.0" 
$ns at 204.4564780734611 "$node_(212) setdest 112990 38874 10.0" 
$ns at 324.549105307995 "$node_(212) setdest 114517 24690 2.0" 
$ns at 364.9306394494654 "$node_(212) setdest 78958 41177 6.0" 
$ns at 429.60387929175715 "$node_(212) setdest 79345 30891 15.0" 
$ns at 553.8042233012445 "$node_(212) setdest 97714 13172 19.0" 
$ns at 658.6619622098542 "$node_(212) setdest 55437 39703 5.0" 
$ns at 717.2880314511889 "$node_(212) setdest 96069 6830 20.0" 
$ns at 873.2288843610343 "$node_(212) setdest 19536 27470 1.0" 
$ns at 201.13819211965483 "$node_(213) setdest 85286 30012 4.0" 
$ns at 269.45414839231614 "$node_(213) setdest 67657 10498 16.0" 
$ns at 330.8098761838776 "$node_(213) setdest 11064 31657 16.0" 
$ns at 436.2160710860619 "$node_(213) setdest 49331 22213 10.0" 
$ns at 476.9236259499684 "$node_(213) setdest 30167 31773 15.0" 
$ns at 633.5333124758599 "$node_(213) setdest 69090 33323 14.0" 
$ns at 757.2906305870996 "$node_(213) setdest 117013 12260 16.0" 
$ns at 252.4342863019923 "$node_(214) setdest 10333 19547 13.0" 
$ns at 299.5985169390299 "$node_(214) setdest 51356 32172 9.0" 
$ns at 366.2409230788573 "$node_(214) setdest 71163 17908 9.0" 
$ns at 410.5497524916695 "$node_(214) setdest 107861 7439 13.0" 
$ns at 564.8136563967619 "$node_(214) setdest 124841 1528 3.0" 
$ns at 604.3756502543513 "$node_(214) setdest 17792 3964 18.0" 
$ns at 726.4527068465437 "$node_(214) setdest 72523 1772 2.0" 
$ns at 762.3921822041885 "$node_(214) setdest 123760 6545 16.0" 
$ns at 795.2378363690036 "$node_(214) setdest 63782 4368 12.0" 
$ns at 221.8184858935183 "$node_(215) setdest 99103 17493 16.0" 
$ns at 368.1146986931344 "$node_(215) setdest 8115 718 4.0" 
$ns at 420.66887887763704 "$node_(215) setdest 37474 5732 13.0" 
$ns at 558.8181712465107 "$node_(215) setdest 128886 32842 7.0" 
$ns at 645.1699532508853 "$node_(215) setdest 18526 14801 17.0" 
$ns at 739.0620899586885 "$node_(215) setdest 71055 6887 6.0" 
$ns at 822.7127076065387 "$node_(215) setdest 8960 20494 18.0" 
$ns at 873.6469350494151 "$node_(215) setdest 80619 5770 2.0" 
$ns at 277.33078844501074 "$node_(216) setdest 1422 32312 12.0" 
$ns at 413.16679749730906 "$node_(216) setdest 78225 44608 7.0" 
$ns at 485.7288628582934 "$node_(216) setdest 23843 5705 18.0" 
$ns at 591.54619491131 "$node_(216) setdest 21530 17026 3.0" 
$ns at 646.6819875740175 "$node_(216) setdest 118030 44287 10.0" 
$ns at 764.1480077867825 "$node_(216) setdest 42480 9955 17.0" 
$ns at 252.0852930489205 "$node_(217) setdest 35895 37876 12.0" 
$ns at 333.3860224757377 "$node_(217) setdest 39245 25423 12.0" 
$ns at 436.5597491379525 "$node_(217) setdest 68644 14475 1.0" 
$ns at 473.9485423390253 "$node_(217) setdest 69994 29985 18.0" 
$ns at 580.5425369735531 "$node_(217) setdest 37918 38793 18.0" 
$ns at 742.3438620513884 "$node_(217) setdest 62732 12316 11.0" 
$ns at 874.4124687712897 "$node_(217) setdest 46478 12836 15.0" 
$ns at 208.7534883642704 "$node_(218) setdest 109401 19926 1.0" 
$ns at 243.25301194051212 "$node_(218) setdest 75393 34493 18.0" 
$ns at 352.87948360590747 "$node_(218) setdest 97177 23054 17.0" 
$ns at 546.2628077743009 "$node_(218) setdest 42675 6477 17.0" 
$ns at 744.845351452493 "$node_(218) setdest 11690 44481 3.0" 
$ns at 782.9224966575844 "$node_(218) setdest 53031 34475 1.0" 
$ns at 817.2423229755807 "$node_(218) setdest 40291 16718 18.0" 
$ns at 848.7879746452923 "$node_(218) setdest 8966 43182 6.0" 
$ns at 225.0079760063718 "$node_(219) setdest 109081 24162 20.0" 
$ns at 261.36087399820536 "$node_(219) setdest 62756 12355 9.0" 
$ns at 298.76446246233706 "$node_(219) setdest 42943 23744 6.0" 
$ns at 374.79304398112515 "$node_(219) setdest 89896 44646 8.0" 
$ns at 468.86333014403084 "$node_(219) setdest 1646 7195 11.0" 
$ns at 591.2021883030484 "$node_(219) setdest 58001 4742 9.0" 
$ns at 623.5389326890175 "$node_(219) setdest 92126 41564 7.0" 
$ns at 687.7008291864786 "$node_(219) setdest 65735 33225 11.0" 
$ns at 737.7581262885914 "$node_(219) setdest 59643 21256 8.0" 
$ns at 776.1128424452368 "$node_(219) setdest 116032 43673 6.0" 
$ns at 815.6830429427462 "$node_(219) setdest 63349 18840 14.0" 
$ns at 208.07813822439522 "$node_(220) setdest 33263 39359 11.0" 
$ns at 323.36789954417986 "$node_(220) setdest 51526 7953 2.0" 
$ns at 353.96365865669526 "$node_(220) setdest 91934 1347 1.0" 
$ns at 393.53189105942874 "$node_(220) setdest 91405 20430 14.0" 
$ns at 546.142095733303 "$node_(220) setdest 24783 33360 16.0" 
$ns at 720.8202572762573 "$node_(220) setdest 132110 15913 20.0" 
$ns at 228.9141436394903 "$node_(221) setdest 19715 13923 8.0" 
$ns at 303.4223527297569 "$node_(221) setdest 117954 32867 16.0" 
$ns at 342.783046639227 "$node_(221) setdest 92409 44016 19.0" 
$ns at 413.64868655646353 "$node_(221) setdest 85139 31231 1.0" 
$ns at 453.0569720310504 "$node_(221) setdest 28962 20549 3.0" 
$ns at 504.60907929545453 "$node_(221) setdest 64356 22793 16.0" 
$ns at 680.9857703206989 "$node_(221) setdest 46340 41806 17.0" 
$ns at 838.9078760691164 "$node_(221) setdest 121738 33632 15.0" 
$ns at 232.56486013983584 "$node_(222) setdest 65836 27134 14.0" 
$ns at 388.29491215613336 "$node_(222) setdest 102313 11115 16.0" 
$ns at 575.4767102192574 "$node_(222) setdest 6188 42320 12.0" 
$ns at 682.9752998977027 "$node_(222) setdest 71664 31249 8.0" 
$ns at 742.4992579668746 "$node_(222) setdest 45961 42210 17.0" 
$ns at 236.40926637832695 "$node_(223) setdest 101156 29555 14.0" 
$ns at 273.1380125720403 "$node_(223) setdest 16451 12592 9.0" 
$ns at 346.96336981709624 "$node_(223) setdest 53172 2607 8.0" 
$ns at 414.50902459239967 "$node_(223) setdest 54854 22497 19.0" 
$ns at 591.326274576468 "$node_(223) setdest 113058 19004 1.0" 
$ns at 630.8275422261191 "$node_(223) setdest 85096 18038 9.0" 
$ns at 691.1468931449117 "$node_(223) setdest 56106 37862 3.0" 
$ns at 729.3038831488876 "$node_(223) setdest 125620 40295 5.0" 
$ns at 764.9212847549318 "$node_(223) setdest 16686 23146 8.0" 
$ns at 804.3743455902572 "$node_(223) setdest 37634 8299 14.0" 
$ns at 895.4192209588596 "$node_(223) setdest 42836 8854 5.0" 
$ns at 251.00010116984274 "$node_(224) setdest 100477 22615 7.0" 
$ns at 315.0862861281604 "$node_(224) setdest 14557 6672 14.0" 
$ns at 440.09326882983123 "$node_(224) setdest 30779 24025 16.0" 
$ns at 594.0886618337798 "$node_(224) setdest 107493 4834 17.0" 
$ns at 704.2090396283783 "$node_(224) setdest 131216 23962 7.0" 
$ns at 783.5931166464563 "$node_(224) setdest 44778 32194 17.0" 
$ns at 815.7767056393719 "$node_(224) setdest 53969 40788 17.0" 
$ns at 860.1316072132557 "$node_(224) setdest 85332 146 20.0" 
$ns at 291.9976574141017 "$node_(225) setdest 98135 36830 16.0" 
$ns at 373.1223854720258 "$node_(225) setdest 46276 37187 7.0" 
$ns at 412.0353325290572 "$node_(225) setdest 100758 38290 10.0" 
$ns at 525.4083493804047 "$node_(225) setdest 88308 23042 5.0" 
$ns at 587.0531431188315 "$node_(225) setdest 48223 40043 1.0" 
$ns at 620.2777351179992 "$node_(225) setdest 85943 12920 12.0" 
$ns at 735.3974080253616 "$node_(225) setdest 24000 10640 16.0" 
$ns at 857.1174218463862 "$node_(225) setdest 46882 14803 16.0" 
$ns at 216.4576658942533 "$node_(226) setdest 65475 5134 4.0" 
$ns at 246.7381692805215 "$node_(226) setdest 32236 8554 17.0" 
$ns at 282.5456170409778 "$node_(226) setdest 109904 44465 17.0" 
$ns at 358.43879600324453 "$node_(226) setdest 95630 2800 5.0" 
$ns at 405.26604859838346 "$node_(226) setdest 38471 614 14.0" 
$ns at 568.1444791477277 "$node_(226) setdest 75892 19077 17.0" 
$ns at 749.0435577602763 "$node_(226) setdest 75665 42477 4.0" 
$ns at 808.3902074758828 "$node_(226) setdest 30472 2266 1.0" 
$ns at 838.4767570607825 "$node_(226) setdest 86232 7817 4.0" 
$ns at 874.8286206231146 "$node_(226) setdest 92057 26916 10.0" 
$ns at 216.37284074118523 "$node_(227) setdest 17453 21674 6.0" 
$ns at 296.5760772937871 "$node_(227) setdest 42822 1430 14.0" 
$ns at 388.5458470888228 "$node_(227) setdest 26757 2942 3.0" 
$ns at 436.32413605102124 "$node_(227) setdest 16562 6432 19.0" 
$ns at 508.02519296257026 "$node_(227) setdest 8623 12843 4.0" 
$ns at 553.9395967695018 "$node_(227) setdest 59906 11376 3.0" 
$ns at 604.9523677419184 "$node_(227) setdest 86027 34989 8.0" 
$ns at 671.4808668277899 "$node_(227) setdest 43082 43010 11.0" 
$ns at 767.4113755094312 "$node_(227) setdest 8801 27448 11.0" 
$ns at 845.7123746109767 "$node_(227) setdest 94279 17635 1.0" 
$ns at 875.844301388382 "$node_(227) setdest 118211 16132 18.0" 
$ns at 220.3056588647635 "$node_(228) setdest 93976 24444 11.0" 
$ns at 257.56992952591276 "$node_(228) setdest 43308 38505 15.0" 
$ns at 367.3963915687207 "$node_(228) setdest 39696 1584 15.0" 
$ns at 480.5753239532352 "$node_(228) setdest 7411 28393 1.0" 
$ns at 510.64178459492126 "$node_(228) setdest 51684 14649 14.0" 
$ns at 645.616198783423 "$node_(228) setdest 28294 34663 15.0" 
$ns at 716.6105216046005 "$node_(228) setdest 107858 43467 1.0" 
$ns at 754.5857796999933 "$node_(228) setdest 105709 21948 6.0" 
$ns at 796.9868773637112 "$node_(228) setdest 40439 36819 8.0" 
$ns at 855.9057017322573 "$node_(228) setdest 74858 39951 16.0" 
$ns at 231.84516752544965 "$node_(229) setdest 110939 7880 6.0" 
$ns at 285.46045523714554 "$node_(229) setdest 28286 42478 5.0" 
$ns at 353.9947113470465 "$node_(229) setdest 89911 5881 9.0" 
$ns at 408.24051984273655 "$node_(229) setdest 71341 34219 15.0" 
$ns at 487.9747153784702 "$node_(229) setdest 47607 38948 11.0" 
$ns at 562.3796060641218 "$node_(229) setdest 17184 40982 10.0" 
$ns at 641.1400604966898 "$node_(229) setdest 100409 25988 10.0" 
$ns at 766.5548053620313 "$node_(229) setdest 35771 32624 17.0" 
$ns at 845.6448583228338 "$node_(229) setdest 6129 19194 1.0" 
$ns at 883.7493098200026 "$node_(229) setdest 73075 41349 14.0" 
$ns at 305.69090730060327 "$node_(230) setdest 9678 5858 7.0" 
$ns at 392.872568392603 "$node_(230) setdest 91113 16344 13.0" 
$ns at 477.6264875647564 "$node_(230) setdest 17829 40933 19.0" 
$ns at 608.0299146371591 "$node_(230) setdest 116747 18161 4.0" 
$ns at 671.7109793615873 "$node_(230) setdest 71843 93 4.0" 
$ns at 722.2927925862448 "$node_(230) setdest 6393 13033 14.0" 
$ns at 837.3516340713792 "$node_(230) setdest 103743 35597 5.0" 
$ns at 246.2562249423326 "$node_(231) setdest 110784 7434 7.0" 
$ns at 325.7357143762346 "$node_(231) setdest 49642 24723 18.0" 
$ns at 506.1948572103504 "$node_(231) setdest 68881 44668 5.0" 
$ns at 548.5862572692625 "$node_(231) setdest 49055 42110 1.0" 
$ns at 584.8296284999853 "$node_(231) setdest 52526 43314 5.0" 
$ns at 647.5928991392932 "$node_(231) setdest 60255 43680 3.0" 
$ns at 706.071061002056 "$node_(231) setdest 66413 41172 15.0" 
$ns at 878.4467337609001 "$node_(231) setdest 124573 32680 12.0" 
$ns at 260.0513318499299 "$node_(232) setdest 72490 5998 18.0" 
$ns at 433.51437067701977 "$node_(232) setdest 62549 12573 8.0" 
$ns at 523.8073612225929 "$node_(232) setdest 61670 17219 7.0" 
$ns at 614.821400043137 "$node_(232) setdest 76953 37351 7.0" 
$ns at 649.8472234276854 "$node_(232) setdest 29606 36031 19.0" 
$ns at 795.1615043621691 "$node_(232) setdest 5463 5503 16.0" 
$ns at 885.8080419307363 "$node_(232) setdest 106946 41986 10.0" 
$ns at 219.21881969969644 "$node_(233) setdest 126620 17709 17.0" 
$ns at 254.4319787547507 "$node_(233) setdest 43079 8235 16.0" 
$ns at 373.4617386425748 "$node_(233) setdest 128998 37598 12.0" 
$ns at 439.4787729050748 "$node_(233) setdest 68822 36992 7.0" 
$ns at 473.3558123111627 "$node_(233) setdest 81507 9527 4.0" 
$ns at 541.9750349138698 "$node_(233) setdest 120209 1433 6.0" 
$ns at 624.7181464396997 "$node_(233) setdest 90889 44151 11.0" 
$ns at 733.6937896747588 "$node_(233) setdest 45258 23185 4.0" 
$ns at 780.5010253708997 "$node_(233) setdest 8516 22709 3.0" 
$ns at 817.5846313514777 "$node_(233) setdest 63105 14283 16.0" 
$ns at 852.2109877189592 "$node_(233) setdest 111249 19748 8.0" 
$ns at 395.0587655453511 "$node_(234) setdest 18960 37830 12.0" 
$ns at 515.0571069479864 "$node_(234) setdest 51493 27039 11.0" 
$ns at 568.4075008700257 "$node_(234) setdest 17436 32954 17.0" 
$ns at 754.2368469880967 "$node_(234) setdest 82078 5681 3.0" 
$ns at 799.3254425972333 "$node_(234) setdest 116030 5447 12.0" 
$ns at 224.8808296210956 "$node_(235) setdest 103786 38616 15.0" 
$ns at 266.0341000885542 "$node_(235) setdest 109240 37451 6.0" 
$ns at 346.934841789248 "$node_(235) setdest 87482 41510 16.0" 
$ns at 403.4383946557911 "$node_(235) setdest 84047 16849 16.0" 
$ns at 531.7674207572863 "$node_(235) setdest 104600 14836 11.0" 
$ns at 638.584208135451 "$node_(235) setdest 27345 21656 19.0" 
$ns at 719.2066883941618 "$node_(235) setdest 26776 29186 16.0" 
$ns at 879.7486917871804 "$node_(235) setdest 55135 9116 14.0" 
$ns at 275.4944878999248 "$node_(236) setdest 106017 13430 8.0" 
$ns at 377.50623257799987 "$node_(236) setdest 48183 5324 9.0" 
$ns at 414.5704149294589 "$node_(236) setdest 81319 6868 1.0" 
$ns at 446.6298643884303 "$node_(236) setdest 54237 31070 5.0" 
$ns at 488.0548001182324 "$node_(236) setdest 125383 36808 18.0" 
$ns at 622.9562437054442 "$node_(236) setdest 132616 11935 12.0" 
$ns at 681.7652677756647 "$node_(236) setdest 19235 14918 5.0" 
$ns at 752.4818624407981 "$node_(236) setdest 91405 37246 11.0" 
$ns at 859.8392204694879 "$node_(236) setdest 50500 7802 9.0" 
$ns at 360.8863945900248 "$node_(237) setdest 90624 1120 15.0" 
$ns at 526.6703263895271 "$node_(237) setdest 124778 33624 16.0" 
$ns at 617.5455281710109 "$node_(237) setdest 50497 41935 18.0" 
$ns at 817.5533599830212 "$node_(237) setdest 76521 5781 14.0" 
$ns at 201.8955369250205 "$node_(238) setdest 129853 10922 6.0" 
$ns at 248.39278809485978 "$node_(238) setdest 118029 33257 1.0" 
$ns at 278.92692473209803 "$node_(238) setdest 74766 9220 5.0" 
$ns at 352.17026543712956 "$node_(238) setdest 16756 20678 19.0" 
$ns at 528.1103945516304 "$node_(238) setdest 26918 10257 1.0" 
$ns at 558.5814160066907 "$node_(238) setdest 31703 6669 19.0" 
$ns at 734.3590532506435 "$node_(238) setdest 113929 8469 6.0" 
$ns at 817.0033792870311 "$node_(238) setdest 91333 29318 7.0" 
$ns at 858.9965243544044 "$node_(238) setdest 81072 27133 11.0" 
$ns at 229.3029250365949 "$node_(239) setdest 74755 40599 16.0" 
$ns at 404.93031314638915 "$node_(239) setdest 120209 11730 19.0" 
$ns at 504.502478448977 "$node_(239) setdest 70562 8168 16.0" 
$ns at 675.807372452684 "$node_(239) setdest 123846 32555 2.0" 
$ns at 725.3501718118493 "$node_(239) setdest 108611 41377 11.0" 
$ns at 809.8998711659717 "$node_(239) setdest 17437 35174 6.0" 
$ns at 870.3582359245495 "$node_(239) setdest 24071 5463 18.0" 
$ns at 250.4879274740142 "$node_(240) setdest 104080 14104 7.0" 
$ns at 313.3494897084401 "$node_(240) setdest 27115 16258 17.0" 
$ns at 394.47430620367953 "$node_(240) setdest 118592 40750 18.0" 
$ns at 524.3480953062829 "$node_(240) setdest 124712 2986 1.0" 
$ns at 555.1484311627544 "$node_(240) setdest 62166 1323 12.0" 
$ns at 646.3490914630298 "$node_(240) setdest 47662 8688 2.0" 
$ns at 681.0086621237306 "$node_(240) setdest 59737 16333 8.0" 
$ns at 771.3663747200759 "$node_(240) setdest 58737 17444 4.0" 
$ns at 813.2442566662089 "$node_(240) setdest 115839 22511 15.0" 
$ns at 224.14312049703898 "$node_(241) setdest 23738 22584 7.0" 
$ns at 282.28416558564214 "$node_(241) setdest 5489 27175 8.0" 
$ns at 316.09286575726475 "$node_(241) setdest 93560 21500 19.0" 
$ns at 507.29685255830145 "$node_(241) setdest 71595 16187 9.0" 
$ns at 555.3049522794325 "$node_(241) setdest 18980 35070 17.0" 
$ns at 753.7010423447513 "$node_(241) setdest 409 28722 6.0" 
$ns at 840.3236265366188 "$node_(241) setdest 76251 28154 3.0" 
$ns at 897.278083468466 "$node_(241) setdest 66076 13461 19.0" 
$ns at 201.05456801696286 "$node_(242) setdest 97350 22363 13.0" 
$ns at 315.27996473236635 "$node_(242) setdest 115637 41575 4.0" 
$ns at 377.31356788930094 "$node_(242) setdest 20751 28608 5.0" 
$ns at 452.66583358383355 "$node_(242) setdest 28468 11104 10.0" 
$ns at 565.8493171541546 "$node_(242) setdest 11141 13615 19.0" 
$ns at 646.4521383099086 "$node_(242) setdest 54364 6200 2.0" 
$ns at 690.0469068338236 "$node_(242) setdest 27451 16723 6.0" 
$ns at 725.27553379991 "$node_(242) setdest 1262 3869 6.0" 
$ns at 757.1010323529414 "$node_(242) setdest 123465 15024 12.0" 
$ns at 829.6369862629427 "$node_(242) setdest 20967 30120 16.0" 
$ns at 891.9051428440081 "$node_(242) setdest 51372 12530 11.0" 
$ns at 267.51852547364314 "$node_(243) setdest 130605 25426 15.0" 
$ns at 337.36259408031714 "$node_(243) setdest 68114 3356 13.0" 
$ns at 390.3918281417951 "$node_(243) setdest 45682 27629 12.0" 
$ns at 515.6398610508612 "$node_(243) setdest 128472 7238 8.0" 
$ns at 568.2993554721562 "$node_(243) setdest 128985 25727 12.0" 
$ns at 656.0099073673052 "$node_(243) setdest 68973 16607 6.0" 
$ns at 717.8941698054713 "$node_(243) setdest 31540 17552 3.0" 
$ns at 765.4060148745348 "$node_(243) setdest 42873 39546 4.0" 
$ns at 804.992653006584 "$node_(243) setdest 40896 14583 7.0" 
$ns at 892.9405589738676 "$node_(243) setdest 64287 20586 16.0" 
$ns at 253.29527960811168 "$node_(244) setdest 40485 8020 17.0" 
$ns at 370.27816347568756 "$node_(244) setdest 43747 20463 14.0" 
$ns at 406.8407904846823 "$node_(244) setdest 95454 1394 11.0" 
$ns at 522.5043655209328 "$node_(244) setdest 34802 9456 19.0" 
$ns at 663.0903087758707 "$node_(244) setdest 55047 1547 12.0" 
$ns at 811.9670854547785 "$node_(244) setdest 76435 38143 1.0" 
$ns at 848.498635782344 "$node_(244) setdest 87423 28523 16.0" 
$ns at 230.9651207448615 "$node_(245) setdest 69395 22353 18.0" 
$ns at 344.9651580341498 "$node_(245) setdest 110376 34643 5.0" 
$ns at 384.4844781497698 "$node_(245) setdest 132354 28602 10.0" 
$ns at 435.45345869769704 "$node_(245) setdest 17585 29543 9.0" 
$ns at 546.2940531488543 "$node_(245) setdest 70507 29085 15.0" 
$ns at 680.107962988295 "$node_(245) setdest 25816 29774 15.0" 
$ns at 716.5524864633364 "$node_(245) setdest 497 22392 3.0" 
$ns at 770.7372492481403 "$node_(245) setdest 101037 35548 12.0" 
$ns at 887.0159329371064 "$node_(245) setdest 122746 38582 16.0" 
$ns at 348.06909758015115 "$node_(246) setdest 3994 3882 5.0" 
$ns at 400.08553950301416 "$node_(246) setdest 91803 11873 20.0" 
$ns at 468.90397225582467 "$node_(246) setdest 38762 3510 10.0" 
$ns at 584.4230518256256 "$node_(246) setdest 105815 16091 3.0" 
$ns at 629.9534921016287 "$node_(246) setdest 86953 32730 2.0" 
$ns at 672.9431772989694 "$node_(246) setdest 21630 11625 7.0" 
$ns at 763.6738811918973 "$node_(246) setdest 39030 22011 10.0" 
$ns at 868.1703627261788 "$node_(246) setdest 16593 43195 17.0" 
$ns at 355.5412120401511 "$node_(247) setdest 69505 36011 8.0" 
$ns at 398.2303794555754 "$node_(247) setdest 34835 14222 8.0" 
$ns at 449.6695560591372 "$node_(247) setdest 129431 15872 1.0" 
$ns at 485.48642458638847 "$node_(247) setdest 37564 30818 7.0" 
$ns at 544.4860120405308 "$node_(247) setdest 48304 14159 4.0" 
$ns at 599.445095966329 "$node_(247) setdest 427 30612 19.0" 
$ns at 778.3066171887422 "$node_(247) setdest 124866 20782 16.0" 
$ns at 282.98821122799137 "$node_(248) setdest 34703 35121 3.0" 
$ns at 323.9808178643635 "$node_(248) setdest 74888 23798 16.0" 
$ns at 424.0345710353558 "$node_(248) setdest 64223 34945 1.0" 
$ns at 455.56833081852 "$node_(248) setdest 42940 30333 13.0" 
$ns at 509.3540592791498 "$node_(248) setdest 1947 25083 8.0" 
$ns at 606.5942861492085 "$node_(248) setdest 120392 13034 2.0" 
$ns at 641.3130142817906 "$node_(248) setdest 130637 36311 10.0" 
$ns at 765.3823001001988 "$node_(248) setdest 23899 3189 5.0" 
$ns at 833.0555597264988 "$node_(248) setdest 21359 34238 9.0" 
$ns at 363.1459132767126 "$node_(249) setdest 27001 5270 20.0" 
$ns at 448.03550188763955 "$node_(249) setdest 97296 27164 9.0" 
$ns at 523.7738334867572 "$node_(249) setdest 49024 29898 12.0" 
$ns at 613.5488172340517 "$node_(249) setdest 36521 28086 3.0" 
$ns at 653.0022052104309 "$node_(249) setdest 16307 7466 17.0" 
$ns at 740.8270833967222 "$node_(249) setdest 48903 37285 8.0" 
$ns at 831.7524458161481 "$node_(249) setdest 58126 13848 4.0" 
$ns at 868.8138769727136 "$node_(249) setdest 74741 26055 8.0" 
$ns at 351.3313069972055 "$node_(250) setdest 25869 5718 9.0" 
$ns at 461.12761194953094 "$node_(250) setdest 63577 17403 9.0" 
$ns at 546.2159417265541 "$node_(250) setdest 124202 3969 16.0" 
$ns at 617.2482225550987 "$node_(250) setdest 7205 31136 1.0" 
$ns at 648.7501657983948 "$node_(250) setdest 70004 12943 14.0" 
$ns at 739.7690778151907 "$node_(250) setdest 108358 6219 10.0" 
$ns at 865.0609808938972 "$node_(250) setdest 66011 19130 1.0" 
$ns at 896.732354646583 "$node_(250) setdest 90057 19247 11.0" 
$ns at 269.6553935646557 "$node_(251) setdest 130498 9362 6.0" 
$ns at 306.6314944968457 "$node_(251) setdest 15344 35148 14.0" 
$ns at 395.9797668327085 "$node_(251) setdest 26827 4497 3.0" 
$ns at 434.6355600387525 "$node_(251) setdest 46476 44249 2.0" 
$ns at 476.05029256171633 "$node_(251) setdest 90877 15032 7.0" 
$ns at 521.8326011309127 "$node_(251) setdest 81831 41290 3.0" 
$ns at 568.3317350631627 "$node_(251) setdest 123457 9483 3.0" 
$ns at 603.0028919769445 "$node_(251) setdest 76073 20264 3.0" 
$ns at 659.015976314807 "$node_(251) setdest 1236 13239 20.0" 
$ns at 782.324628673751 "$node_(251) setdest 55254 43925 2.0" 
$ns at 823.8559944736304 "$node_(251) setdest 94576 12652 11.0" 
$ns at 258.4742031351742 "$node_(252) setdest 99879 27876 4.0" 
$ns at 316.37328382342133 "$node_(252) setdest 95488 10085 1.0" 
$ns at 349.44721107031444 "$node_(252) setdest 116542 32218 15.0" 
$ns at 402.1160137267391 "$node_(252) setdest 6505 43804 1.0" 
$ns at 436.7704599655195 "$node_(252) setdest 117834 8973 16.0" 
$ns at 562.7235643031705 "$node_(252) setdest 18217 17803 18.0" 
$ns at 762.5757856585655 "$node_(252) setdest 25436 2510 4.0" 
$ns at 807.8882787773199 "$node_(252) setdest 131781 8827 5.0" 
$ns at 844.3365666997383 "$node_(252) setdest 48813 9948 4.0" 
$ns at 887.5779995667757 "$node_(252) setdest 112629 6306 9.0" 
$ns at 237.9250243388375 "$node_(253) setdest 75458 1225 14.0" 
$ns at 377.9601129798523 "$node_(253) setdest 38836 7428 2.0" 
$ns at 414.8359390472086 "$node_(253) setdest 11887 30577 7.0" 
$ns at 462.5697708070089 "$node_(253) setdest 13120 21916 13.0" 
$ns at 516.5085791984693 "$node_(253) setdest 56389 4188 13.0" 
$ns at 666.8434206148569 "$node_(253) setdest 12616 16163 14.0" 
$ns at 765.2400629826836 "$node_(253) setdest 5581 38034 17.0" 
$ns at 829.6609930215403 "$node_(253) setdest 61251 24684 10.0" 
$ns at 230.89765258909782 "$node_(254) setdest 108841 8626 18.0" 
$ns at 393.90862304020226 "$node_(254) setdest 123829 9710 4.0" 
$ns at 428.38733678549187 "$node_(254) setdest 13499 41729 15.0" 
$ns at 538.4102546133041 "$node_(254) setdest 72878 42918 1.0" 
$ns at 572.5057572609225 "$node_(254) setdest 88037 3139 7.0" 
$ns at 603.7651123067672 "$node_(254) setdest 110232 43405 2.0" 
$ns at 652.0960836454087 "$node_(254) setdest 132853 29321 9.0" 
$ns at 695.2329590926416 "$node_(254) setdest 114664 25641 18.0" 
$ns at 363.6351355955494 "$node_(255) setdest 40314 9463 10.0" 
$ns at 475.7707543040514 "$node_(255) setdest 107685 16367 18.0" 
$ns at 578.6992276374598 "$node_(255) setdest 124027 1064 3.0" 
$ns at 614.575102153993 "$node_(255) setdest 29318 13028 14.0" 
$ns at 747.1322359743021 "$node_(255) setdest 75618 84 1.0" 
$ns at 785.8787296323843 "$node_(255) setdest 72090 27004 14.0" 
$ns at 881.1169937323142 "$node_(255) setdest 9952 20115 10.0" 
$ns at 254.06389033374964 "$node_(256) setdest 63135 19745 1.0" 
$ns at 290.99481960366387 "$node_(256) setdest 66023 2468 7.0" 
$ns at 383.44109183632963 "$node_(256) setdest 107144 4107 18.0" 
$ns at 421.88756179304204 "$node_(256) setdest 21030 40675 16.0" 
$ns at 455.0055469352236 "$node_(256) setdest 98926 626 17.0" 
$ns at 538.606444301081 "$node_(256) setdest 47160 32124 13.0" 
$ns at 683.0136266455386 "$node_(256) setdest 22061 2983 20.0" 
$ns at 795.6295906259649 "$node_(256) setdest 134009 34404 14.0" 
$ns at 892.568016330066 "$node_(256) setdest 75561 39186 3.0" 
$ns at 252.64994574240754 "$node_(257) setdest 37084 34951 14.0" 
$ns at 346.67160155487056 "$node_(257) setdest 59569 877 10.0" 
$ns at 420.0900458125128 "$node_(257) setdest 11281 29739 19.0" 
$ns at 581.8177517762647 "$node_(257) setdest 40527 37257 7.0" 
$ns at 645.3825212190584 "$node_(257) setdest 205 44317 18.0" 
$ns at 839.6143686231048 "$node_(257) setdest 2728 14957 1.0" 
$ns at 879.0478295988912 "$node_(257) setdest 29530 24183 13.0" 
$ns at 339.81361215850535 "$node_(258) setdest 16277 28063 10.0" 
$ns at 383.91247177883696 "$node_(258) setdest 55104 25145 9.0" 
$ns at 477.01482836514253 "$node_(258) setdest 120338 25289 3.0" 
$ns at 516.0234684750271 "$node_(258) setdest 131623 21457 11.0" 
$ns at 574.988334841942 "$node_(258) setdest 10261 12654 3.0" 
$ns at 627.1959858704607 "$node_(258) setdest 91014 26387 4.0" 
$ns at 692.4903596996555 "$node_(258) setdest 71448 781 13.0" 
$ns at 787.0115063025012 "$node_(258) setdest 3230 25854 5.0" 
$ns at 836.7854813148527 "$node_(258) setdest 21658 24156 1.0" 
$ns at 875.6140951773691 "$node_(258) setdest 92876 26862 6.0" 
$ns at 224.13114128696992 "$node_(259) setdest 64612 26718 2.0" 
$ns at 255.31558685103755 "$node_(259) setdest 30143 35461 5.0" 
$ns at 299.5906025966517 "$node_(259) setdest 116270 21403 4.0" 
$ns at 351.8674506339586 "$node_(259) setdest 18265 15443 4.0" 
$ns at 414.09196221234464 "$node_(259) setdest 64530 17200 15.0" 
$ns at 576.6087519171205 "$node_(259) setdest 93211 29975 8.0" 
$ns at 684.3344380368875 "$node_(259) setdest 37316 17194 16.0" 
$ns at 847.9846818443134 "$node_(259) setdest 88002 38461 7.0" 
$ns at 887.5378929417158 "$node_(259) setdest 54704 31511 7.0" 
$ns at 219.95169183556857 "$node_(260) setdest 63231 10679 11.0" 
$ns at 325.2468547688523 "$node_(260) setdest 90660 43335 10.0" 
$ns at 358.06239379286296 "$node_(260) setdest 103268 1267 1.0" 
$ns at 396.5815407871279 "$node_(260) setdest 24322 17789 8.0" 
$ns at 439.2994409181015 "$node_(260) setdest 55620 43437 10.0" 
$ns at 547.7264206424618 "$node_(260) setdest 6837 10662 9.0" 
$ns at 590.6713305082989 "$node_(260) setdest 94241 11283 14.0" 
$ns at 628.5004007704789 "$node_(260) setdest 38166 22101 8.0" 
$ns at 668.3699701092904 "$node_(260) setdest 119062 18613 6.0" 
$ns at 745.6857671932953 "$node_(260) setdest 45931 34331 2.0" 
$ns at 784.7080977838039 "$node_(260) setdest 40376 13119 8.0" 
$ns at 892.4593103577777 "$node_(260) setdest 37497 1262 10.0" 
$ns at 269.78252991759433 "$node_(261) setdest 16248 24866 2.0" 
$ns at 315.90843586309774 "$node_(261) setdest 109726 12427 16.0" 
$ns at 346.64523008639804 "$node_(261) setdest 40456 3870 10.0" 
$ns at 438.63413245897914 "$node_(261) setdest 81542 3424 20.0" 
$ns at 522.1240019965678 "$node_(261) setdest 97384 2683 11.0" 
$ns at 633.1368922895532 "$node_(261) setdest 74144 10252 19.0" 
$ns at 729.9560444717092 "$node_(261) setdest 69211 29963 7.0" 
$ns at 786.9512299570715 "$node_(261) setdest 75474 35293 7.0" 
$ns at 866.9740290820858 "$node_(261) setdest 83076 17523 4.0" 
$ns at 898.2584502871313 "$node_(261) setdest 127228 43219 17.0" 
$ns at 231.8191096363044 "$node_(262) setdest 27981 15142 1.0" 
$ns at 269.46579499173583 "$node_(262) setdest 118219 34890 12.0" 
$ns at 357.5269368660041 "$node_(262) setdest 73391 34277 1.0" 
$ns at 389.6091373098185 "$node_(262) setdest 36632 6261 9.0" 
$ns at 423.23364889751645 "$node_(262) setdest 2893 31726 6.0" 
$ns at 482.0718526936465 "$node_(262) setdest 80030 41110 19.0" 
$ns at 665.1742408414652 "$node_(262) setdest 15701 30243 6.0" 
$ns at 709.4935584453322 "$node_(262) setdest 61804 32959 19.0" 
$ns at 268.17688365525845 "$node_(263) setdest 64479 31042 2.0" 
$ns at 312.7139090466774 "$node_(263) setdest 73594 24816 16.0" 
$ns at 370.34309554197347 "$node_(263) setdest 24948 20395 9.0" 
$ns at 481.7927881074289 "$node_(263) setdest 10638 28591 13.0" 
$ns at 628.1066753398031 "$node_(263) setdest 33008 35276 5.0" 
$ns at 684.2828340855154 "$node_(263) setdest 48072 291 18.0" 
$ns at 733.2531192675359 "$node_(263) setdest 96951 4336 16.0" 
$ns at 255.16778730876234 "$node_(264) setdest 66379 44462 3.0" 
$ns at 299.3414607585965 "$node_(264) setdest 61183 33745 14.0" 
$ns at 454.87627661214526 "$node_(264) setdest 100081 10801 8.0" 
$ns at 526.6639748566267 "$node_(264) setdest 16718 15729 12.0" 
$ns at 615.5562382443192 "$node_(264) setdest 40629 21297 1.0" 
$ns at 647.652162088429 "$node_(264) setdest 28205 4291 8.0" 
$ns at 742.8457646006882 "$node_(264) setdest 62930 3489 4.0" 
$ns at 812.486277602553 "$node_(264) setdest 112297 14030 18.0" 
$ns at 234.2713321627706 "$node_(265) setdest 121243 17836 11.0" 
$ns at 346.9260617165364 "$node_(265) setdest 123203 15759 16.0" 
$ns at 507.1737791285354 "$node_(265) setdest 51780 35866 11.0" 
$ns at 631.6417945943545 "$node_(265) setdest 124969 44402 9.0" 
$ns at 663.443860970282 "$node_(265) setdest 89863 7562 19.0" 
$ns at 779.1988802184909 "$node_(265) setdest 97495 32579 3.0" 
$ns at 831.0839193665206 "$node_(265) setdest 59657 26825 19.0" 
$ns at 863.0239761322761 "$node_(265) setdest 88344 31207 11.0" 
$ns at 203.77240353992 "$node_(266) setdest 38212 38960 12.0" 
$ns at 255.09405342378182 "$node_(266) setdest 45864 40142 11.0" 
$ns at 288.74200787224214 "$node_(266) setdest 68552 18253 3.0" 
$ns at 332.43254508477446 "$node_(266) setdest 60864 6384 3.0" 
$ns at 362.68075303250237 "$node_(266) setdest 32632 19358 18.0" 
$ns at 483.36082641335804 "$node_(266) setdest 56996 40162 18.0" 
$ns at 682.6073502300167 "$node_(266) setdest 1337 7847 14.0" 
$ns at 720.9772545001341 "$node_(266) setdest 66363 25493 14.0" 
$ns at 888.4984794055347 "$node_(266) setdest 32888 34746 5.0" 
$ns at 200.42171166186932 "$node_(267) setdest 123279 27958 12.0" 
$ns at 305.20914760144353 "$node_(267) setdest 37021 15987 11.0" 
$ns at 412.2064015106087 "$node_(267) setdest 73601 42965 19.0" 
$ns at 532.0526842937575 "$node_(267) setdest 39207 26360 2.0" 
$ns at 564.7829418146983 "$node_(267) setdest 56019 32267 16.0" 
$ns at 747.3187795865946 "$node_(267) setdest 2969 596 18.0" 
$ns at 251.05324489516926 "$node_(268) setdest 132045 9503 11.0" 
$ns at 330.79035230841987 "$node_(268) setdest 35175 17005 14.0" 
$ns at 484.81436911785 "$node_(268) setdest 26195 3112 13.0" 
$ns at 634.5199048091994 "$node_(268) setdest 715 7589 12.0" 
$ns at 753.0030816239773 "$node_(268) setdest 37228 39929 16.0" 
$ns at 796.0901165664371 "$node_(268) setdest 38531 11079 16.0" 
$ns at 842.2103864306589 "$node_(268) setdest 130716 8006 9.0" 
$ns at 884.3291956140328 "$node_(268) setdest 42682 26409 14.0" 
$ns at 243.0958020068156 "$node_(269) setdest 58592 31099 13.0" 
$ns at 357.1634145731078 "$node_(269) setdest 67619 39307 9.0" 
$ns at 449.4726697622129 "$node_(269) setdest 51899 19453 5.0" 
$ns at 485.0822508861571 "$node_(269) setdest 31492 24976 8.0" 
$ns at 557.4897076077442 "$node_(269) setdest 123747 3869 13.0" 
$ns at 592.2130097994549 "$node_(269) setdest 56782 39326 19.0" 
$ns at 792.0801583386342 "$node_(269) setdest 19049 36223 15.0" 
$ns at 296.0024343447519 "$node_(270) setdest 105022 43598 10.0" 
$ns at 396.7832719937739 "$node_(270) setdest 36811 12453 6.0" 
$ns at 449.41739653131214 "$node_(270) setdest 123671 13800 1.0" 
$ns at 488.6225210577211 "$node_(270) setdest 93053 31783 9.0" 
$ns at 595.547521895793 "$node_(270) setdest 92869 44335 12.0" 
$ns at 697.0184060059203 "$node_(270) setdest 18368 11226 12.0" 
$ns at 801.9552003181149 "$node_(270) setdest 42831 8056 11.0" 
$ns at 211.01996328818143 "$node_(271) setdest 93929 6426 5.0" 
$ns at 256.50772620882555 "$node_(271) setdest 36678 19620 4.0" 
$ns at 304.48489655514277 "$node_(271) setdest 50835 17252 16.0" 
$ns at 445.5162892188682 "$node_(271) setdest 2143 4508 2.0" 
$ns at 481.23436658733027 "$node_(271) setdest 84037 32572 19.0" 
$ns at 584.7789340257776 "$node_(271) setdest 124485 9927 12.0" 
$ns at 664.8948564416057 "$node_(271) setdest 115992 29953 7.0" 
$ns at 703.7052065715276 "$node_(271) setdest 49777 37212 18.0" 
$ns at 837.0462703700074 "$node_(271) setdest 112551 11606 10.0" 
$ns at 285.4600100287174 "$node_(272) setdest 102737 25052 5.0" 
$ns at 333.284296350319 "$node_(272) setdest 15929 30554 15.0" 
$ns at 477.9635566869834 "$node_(272) setdest 33899 16695 17.0" 
$ns at 632.0597632920897 "$node_(272) setdest 86029 39184 4.0" 
$ns at 666.0611529386209 "$node_(272) setdest 124223 19058 11.0" 
$ns at 803.2252364983553 "$node_(272) setdest 21314 37287 11.0" 
$ns at 281.4342379697282 "$node_(273) setdest 77200 5326 14.0" 
$ns at 420.4394005756758 "$node_(273) setdest 41016 20918 2.0" 
$ns at 455.3004019528924 "$node_(273) setdest 121299 23917 6.0" 
$ns at 522.734062951137 "$node_(273) setdest 33946 5109 5.0" 
$ns at 593.9239713350692 "$node_(273) setdest 50417 8682 20.0" 
$ns at 780.014103784395 "$node_(273) setdest 10222 32947 5.0" 
$ns at 810.7804749556801 "$node_(273) setdest 41101 23168 7.0" 
$ns at 303.9653211441038 "$node_(274) setdest 94809 37534 4.0" 
$ns at 335.48870960565694 "$node_(274) setdest 18330 29960 17.0" 
$ns at 444.72028788888645 "$node_(274) setdest 16383 23583 19.0" 
$ns at 535.0567103080722 "$node_(274) setdest 15508 24851 1.0" 
$ns at 573.5481034738683 "$node_(274) setdest 97672 14504 13.0" 
$ns at 724.5942973904703 "$node_(274) setdest 131907 8758 11.0" 
$ns at 764.8382736900495 "$node_(274) setdest 87367 10197 1.0" 
$ns at 799.2426096354302 "$node_(274) setdest 46653 11257 13.0" 
$ns at 248.21982481396645 "$node_(275) setdest 24136 31776 5.0" 
$ns at 300.5349672472542 "$node_(275) setdest 60570 19044 2.0" 
$ns at 338.44048232571936 "$node_(275) setdest 126300 18199 6.0" 
$ns at 406.4184491981637 "$node_(275) setdest 100435 1382 11.0" 
$ns at 529.4288013636924 "$node_(275) setdest 89133 26901 10.0" 
$ns at 590.1940914279784 "$node_(275) setdest 109937 19853 18.0" 
$ns at 670.260931058869 "$node_(275) setdest 52473 31398 5.0" 
$ns at 704.6499406368947 "$node_(275) setdest 10691 15201 3.0" 
$ns at 735.1140907432107 "$node_(275) setdest 55286 42617 15.0" 
$ns at 856.5724675212062 "$node_(275) setdest 24928 11643 14.0" 
$ns at 233.66142504065047 "$node_(276) setdest 88487 28682 2.0" 
$ns at 266.9088025937035 "$node_(276) setdest 73805 30518 10.0" 
$ns at 351.6774831352725 "$node_(276) setdest 132642 4364 14.0" 
$ns at 404.0551771704694 "$node_(276) setdest 94878 43568 7.0" 
$ns at 500.98840036956403 "$node_(276) setdest 33603 38308 7.0" 
$ns at 576.7729425274013 "$node_(276) setdest 89392 29736 17.0" 
$ns at 616.5279315669452 "$node_(276) setdest 113575 4353 10.0" 
$ns at 734.1482800717549 "$node_(276) setdest 82406 825 18.0" 
$ns at 842.6116572883512 "$node_(276) setdest 79688 35252 1.0" 
$ns at 873.3708161662141 "$node_(276) setdest 100910 4096 11.0" 
$ns at 267.4589919816008 "$node_(277) setdest 14975 18236 14.0" 
$ns at 421.7802885443432 "$node_(277) setdest 92128 38585 20.0" 
$ns at 499.33191640070885 "$node_(277) setdest 13858 32143 16.0" 
$ns at 670.9700453324665 "$node_(277) setdest 55674 29355 16.0" 
$ns at 709.8142422844074 "$node_(277) setdest 118436 4538 8.0" 
$ns at 807.1080554660192 "$node_(277) setdest 90118 25133 2.0" 
$ns at 841.0904639127256 "$node_(277) setdest 122314 25907 13.0" 
$ns at 895.7084853650924 "$node_(277) setdest 45522 22870 16.0" 
$ns at 243.97075248881234 "$node_(278) setdest 37295 15655 16.0" 
$ns at 338.2494370444248 "$node_(278) setdest 94740 19969 7.0" 
$ns at 410.339958682217 "$node_(278) setdest 105036 13837 10.0" 
$ns at 502.2182008902058 "$node_(278) setdest 130505 6209 1.0" 
$ns at 537.9543071312108 "$node_(278) setdest 101933 39647 18.0" 
$ns at 672.0583613725643 "$node_(278) setdest 23768 25793 1.0" 
$ns at 703.325350299549 "$node_(278) setdest 76041 13885 1.0" 
$ns at 736.8828611047945 "$node_(278) setdest 83231 15310 16.0" 
$ns at 317.6806452627342 "$node_(279) setdest 31766 7557 13.0" 
$ns at 354.16640049100386 "$node_(279) setdest 47981 41505 14.0" 
$ns at 418.89360789848956 "$node_(279) setdest 16439 44173 4.0" 
$ns at 458.1568931004271 "$node_(279) setdest 21254 43054 18.0" 
$ns at 608.7659293475899 "$node_(279) setdest 108388 14282 10.0" 
$ns at 671.522190417958 "$node_(279) setdest 45956 26946 2.0" 
$ns at 713.9923576829452 "$node_(279) setdest 37658 13089 4.0" 
$ns at 772.00811709821 "$node_(279) setdest 14265 23372 19.0" 
$ns at 284.00825768499453 "$node_(280) setdest 12055 38011 12.0" 
$ns at 370.23400663390726 "$node_(280) setdest 47726 17532 12.0" 
$ns at 502.74135482488316 "$node_(280) setdest 97564 35041 13.0" 
$ns at 532.9014067482879 "$node_(280) setdest 58760 23293 17.0" 
$ns at 617.1018974227369 "$node_(280) setdest 19471 19724 4.0" 
$ns at 648.6589582480009 "$node_(280) setdest 28170 29117 4.0" 
$ns at 697.8829332362983 "$node_(280) setdest 74693 21520 4.0" 
$ns at 733.1155007674844 "$node_(280) setdest 107204 40832 13.0" 
$ns at 863.8621614764958 "$node_(280) setdest 6392 18474 17.0" 
$ns at 215.7974266875953 "$node_(281) setdest 96695 40880 20.0" 
$ns at 297.84155370037274 "$node_(281) setdest 74770 32754 17.0" 
$ns at 369.6502071419451 "$node_(281) setdest 65160 36345 6.0" 
$ns at 458.26551220215316 "$node_(281) setdest 113866 27414 16.0" 
$ns at 515.3569071663322 "$node_(281) setdest 80030 35417 11.0" 
$ns at 577.9286369863311 "$node_(281) setdest 43943 6751 1.0" 
$ns at 612.3496636872305 "$node_(281) setdest 110942 36227 20.0" 
$ns at 687.7311182660378 "$node_(281) setdest 79918 42803 5.0" 
$ns at 737.8963187828334 "$node_(281) setdest 74691 31739 8.0" 
$ns at 839.2609045958026 "$node_(281) setdest 96883 44118 7.0" 
$ns at 262.4547059802994 "$node_(282) setdest 28715 700 3.0" 
$ns at 299.6212373595901 "$node_(282) setdest 60631 628 6.0" 
$ns at 344.88476666262994 "$node_(282) setdest 49986 2482 8.0" 
$ns at 424.54303055760477 "$node_(282) setdest 101411 2916 10.0" 
$ns at 541.6523936403457 "$node_(282) setdest 116221 43848 3.0" 
$ns at 592.4129255813644 "$node_(282) setdest 59890 8399 1.0" 
$ns at 623.6171052191542 "$node_(282) setdest 109703 40685 18.0" 
$ns at 717.2516789455514 "$node_(282) setdest 36195 30032 3.0" 
$ns at 776.0491412450245 "$node_(282) setdest 52961 9309 1.0" 
$ns at 815.6936605716761 "$node_(282) setdest 53846 25088 5.0" 
$ns at 876.7324079108321 "$node_(282) setdest 98103 29341 17.0" 
$ns at 229.42732604298507 "$node_(283) setdest 43036 2763 18.0" 
$ns at 387.3609635357403 "$node_(283) setdest 105123 10549 1.0" 
$ns at 421.66095702048744 "$node_(283) setdest 88627 8887 13.0" 
$ns at 476.9891812625547 "$node_(283) setdest 101496 39262 9.0" 
$ns at 593.0372741139178 "$node_(283) setdest 91462 19256 1.0" 
$ns at 626.3755446079803 "$node_(283) setdest 62653 18880 16.0" 
$ns at 690.6228020259681 "$node_(283) setdest 108542 31574 19.0" 
$ns at 751.8844342829946 "$node_(283) setdest 30684 26434 7.0" 
$ns at 835.140029711564 "$node_(283) setdest 78456 13707 1.0" 
$ns at 872.9907327761624 "$node_(283) setdest 60805 15413 11.0" 
$ns at 288.95960853881354 "$node_(284) setdest 12816 24190 3.0" 
$ns at 329.8681760139158 "$node_(284) setdest 45514 1916 1.0" 
$ns at 362.9669252511633 "$node_(284) setdest 12944 26295 14.0" 
$ns at 422.6646050825591 "$node_(284) setdest 85262 10299 13.0" 
$ns at 546.9986967886019 "$node_(284) setdest 70567 9963 9.0" 
$ns at 652.1936631291496 "$node_(284) setdest 61382 42682 8.0" 
$ns at 761.0700932440523 "$node_(284) setdest 10579 30186 7.0" 
$ns at 794.7333026118695 "$node_(284) setdest 118770 41874 6.0" 
$ns at 826.1473256042577 "$node_(284) setdest 29269 43484 6.0" 
$ns at 856.8025451495059 "$node_(284) setdest 51403 30865 15.0" 
$ns at 286.71824729047614 "$node_(285) setdest 53414 13297 17.0" 
$ns at 371.7933185228194 "$node_(285) setdest 17614 5926 7.0" 
$ns at 433.68481305516104 "$node_(285) setdest 2250 43312 13.0" 
$ns at 561.2315703634221 "$node_(285) setdest 57939 5208 10.0" 
$ns at 654.0709401457993 "$node_(285) setdest 55371 22866 13.0" 
$ns at 725.4589022960603 "$node_(285) setdest 27741 4169 10.0" 
$ns at 810.2532777988785 "$node_(285) setdest 28444 29570 1.0" 
$ns at 843.490413011402 "$node_(285) setdest 65529 6089 6.0" 
$ns at 237.8006733968189 "$node_(286) setdest 98308 42733 18.0" 
$ns at 302.9206695345043 "$node_(286) setdest 35993 27016 9.0" 
$ns at 386.28904846855323 "$node_(286) setdest 127414 25453 13.0" 
$ns at 423.65080397336 "$node_(286) setdest 24039 35308 3.0" 
$ns at 455.9388299135317 "$node_(286) setdest 24083 655 1.0" 
$ns at 494.2724260111353 "$node_(286) setdest 18607 40954 20.0" 
$ns at 633.2862244404846 "$node_(286) setdest 16595 18991 1.0" 
$ns at 671.7858229648957 "$node_(286) setdest 121158 23271 17.0" 
$ns at 755.6962370541356 "$node_(286) setdest 93708 25570 5.0" 
$ns at 785.7819552775688 "$node_(286) setdest 90055 17373 18.0" 
$ns at 899.849423270821 "$node_(286) setdest 86182 14824 20.0" 
$ns at 212.84432463544718 "$node_(287) setdest 49978 37096 4.0" 
$ns at 259.9524545571128 "$node_(287) setdest 39903 37667 16.0" 
$ns at 377.6782830343576 "$node_(287) setdest 129510 23303 5.0" 
$ns at 454.2524232930361 "$node_(287) setdest 68338 3491 19.0" 
$ns at 562.0526115379611 "$node_(287) setdest 125391 18351 3.0" 
$ns at 606.1411721093699 "$node_(287) setdest 27579 43736 6.0" 
$ns at 673.3326596679308 "$node_(287) setdest 1033 29060 11.0" 
$ns at 740.2485733374263 "$node_(287) setdest 14761 17185 10.0" 
$ns at 786.29550215347 "$node_(287) setdest 110451 30719 1.0" 
$ns at 821.9124577791858 "$node_(287) setdest 70000 820 2.0" 
$ns at 868.4207243421702 "$node_(287) setdest 77450 31925 10.0" 
$ns at 221.1252583927784 "$node_(288) setdest 23263 14980 12.0" 
$ns at 364.78630931382224 "$node_(288) setdest 56411 27236 9.0" 
$ns at 470.98445149023917 "$node_(288) setdest 6246 32427 12.0" 
$ns at 574.2037886350663 "$node_(288) setdest 47193 36702 8.0" 
$ns at 623.4238109224128 "$node_(288) setdest 53707 18417 7.0" 
$ns at 657.171472065909 "$node_(288) setdest 57336 31027 7.0" 
$ns at 727.2230921996118 "$node_(288) setdest 55798 28246 4.0" 
$ns at 770.6070849143947 "$node_(288) setdest 111983 39014 6.0" 
$ns at 845.8412728856243 "$node_(288) setdest 117562 27610 7.0" 
$ns at 239.32453860879002 "$node_(289) setdest 36293 34248 10.0" 
$ns at 340.85867562349614 "$node_(289) setdest 55329 4022 1.0" 
$ns at 372.0853923444879 "$node_(289) setdest 48835 14062 2.0" 
$ns at 410.82046511306055 "$node_(289) setdest 128789 21746 9.0" 
$ns at 514.4425258674271 "$node_(289) setdest 111152 15831 11.0" 
$ns at 554.5738274520629 "$node_(289) setdest 99674 10571 17.0" 
$ns at 701.9736639022561 "$node_(289) setdest 100118 29831 2.0" 
$ns at 751.5282997774079 "$node_(289) setdest 96372 27375 5.0" 
$ns at 798.5360965655065 "$node_(289) setdest 49996 39471 1.0" 
$ns at 830.4859565215598 "$node_(289) setdest 119751 15393 13.0" 
$ns at 217.71741804806732 "$node_(290) setdest 51194 10767 8.0" 
$ns at 315.4082834364712 "$node_(290) setdest 38098 30135 10.0" 
$ns at 380.26555068704073 "$node_(290) setdest 30296 32242 19.0" 
$ns at 559.5347572265036 "$node_(290) setdest 64508 20624 5.0" 
$ns at 595.0685960668509 "$node_(290) setdest 7618 11311 10.0" 
$ns at 665.9100644573119 "$node_(290) setdest 62605 32812 17.0" 
$ns at 826.7759622172917 "$node_(290) setdest 53693 31978 5.0" 
$ns at 883.5027804864151 "$node_(290) setdest 117858 24220 17.0" 
$ns at 283.8627672400566 "$node_(291) setdest 110383 33217 19.0" 
$ns at 384.56849173347706 "$node_(291) setdest 99974 18727 19.0" 
$ns at 463.1169249354376 "$node_(291) setdest 73338 12984 10.0" 
$ns at 559.9916193699378 "$node_(291) setdest 60231 34354 11.0" 
$ns at 660.8173506470271 "$node_(291) setdest 90712 40215 16.0" 
$ns at 823.2090460028088 "$node_(291) setdest 131928 5231 4.0" 
$ns at 889.2069319469692 "$node_(291) setdest 37874 27505 11.0" 
$ns at 200.37274872528926 "$node_(292) setdest 46617 1110 18.0" 
$ns at 365.8949751155897 "$node_(292) setdest 80988 37272 11.0" 
$ns at 449.4467863874967 "$node_(292) setdest 22957 2581 7.0" 
$ns at 497.57553952326543 "$node_(292) setdest 79904 21356 6.0" 
$ns at 533.3031346136211 "$node_(292) setdest 101747 39061 10.0" 
$ns at 628.4553292345913 "$node_(292) setdest 65590 16445 9.0" 
$ns at 707.7971554458583 "$node_(292) setdest 101882 24986 14.0" 
$ns at 815.4124094839389 "$node_(292) setdest 44209 42831 9.0" 
$ns at 261.01595243396633 "$node_(293) setdest 58763 7146 19.0" 
$ns at 428.01094126576675 "$node_(293) setdest 72730 6864 1.0" 
$ns at 460.24283591373296 "$node_(293) setdest 23748 33975 14.0" 
$ns at 617.387908385401 "$node_(293) setdest 9735 14502 19.0" 
$ns at 762.4091949576136 "$node_(293) setdest 82581 11481 10.0" 
$ns at 842.5558572133875 "$node_(293) setdest 3731 17794 4.0" 
$ns at 877.1837374118677 "$node_(293) setdest 44922 6212 5.0" 
$ns at 244.16901549821125 "$node_(294) setdest 124933 9756 6.0" 
$ns at 293.6873005166528 "$node_(294) setdest 51186 29270 16.0" 
$ns at 365.1845774562844 "$node_(294) setdest 6435 10847 4.0" 
$ns at 428.33153077242935 "$node_(294) setdest 58978 2821 3.0" 
$ns at 472.52156262108736 "$node_(294) setdest 112352 5375 6.0" 
$ns at 527.8001700309313 "$node_(294) setdest 104729 27362 2.0" 
$ns at 566.5322278987375 "$node_(294) setdest 123706 18782 3.0" 
$ns at 602.8879660767523 "$node_(294) setdest 21454 1530 5.0" 
$ns at 639.5421687814205 "$node_(294) setdest 15137 24193 20.0" 
$ns at 869.047250384093 "$node_(294) setdest 9942 39644 1.0" 
$ns at 309.17351512667335 "$node_(295) setdest 33447 19759 13.0" 
$ns at 405.41742557204634 "$node_(295) setdest 114700 24992 3.0" 
$ns at 440.861486202347 "$node_(295) setdest 29138 65 2.0" 
$ns at 483.22046200774577 "$node_(295) setdest 31059 454 18.0" 
$ns at 620.8485752289739 "$node_(295) setdest 100334 27042 4.0" 
$ns at 672.4913903474362 "$node_(295) setdest 49688 4325 1.0" 
$ns at 702.6872969746271 "$node_(295) setdest 69206 18335 20.0" 
$ns at 821.6132881700048 "$node_(295) setdest 51497 34054 11.0" 
$ns at 897.8473553724841 "$node_(295) setdest 70732 24632 2.0" 
$ns at 238.37097090356775 "$node_(296) setdest 89147 14422 3.0" 
$ns at 269.1697331567566 "$node_(296) setdest 82697 20816 12.0" 
$ns at 314.4838780226092 "$node_(296) setdest 30229 17931 19.0" 
$ns at 409.30934978981844 "$node_(296) setdest 88754 14196 2.0" 
$ns at 450.182170947675 "$node_(296) setdest 129836 28107 10.0" 
$ns at 578.9441915855454 "$node_(296) setdest 78975 31774 3.0" 
$ns at 628.9088001482129 "$node_(296) setdest 100890 38630 5.0" 
$ns at 681.3394143701287 "$node_(296) setdest 80494 39835 3.0" 
$ns at 734.535772827887 "$node_(296) setdest 118180 38115 1.0" 
$ns at 767.1904259209543 "$node_(296) setdest 111145 39841 16.0" 
$ns at 241.6285278502362 "$node_(297) setdest 70393 1773 8.0" 
$ns at 325.9743388483559 "$node_(297) setdest 25671 3290 19.0" 
$ns at 381.27159173197805 "$node_(297) setdest 32586 2442 14.0" 
$ns at 459.6537553220274 "$node_(297) setdest 65293 38160 4.0" 
$ns at 509.22969132275495 "$node_(297) setdest 4593 12798 20.0" 
$ns at 705.7374932454424 "$node_(297) setdest 47527 29832 13.0" 
$ns at 792.1571450593983 "$node_(297) setdest 73611 15026 6.0" 
$ns at 875.4453464210848 "$node_(297) setdest 130905 6377 20.0" 
$ns at 243.57105363604114 "$node_(298) setdest 77718 23681 12.0" 
$ns at 315.72773451244433 "$node_(298) setdest 107532 16916 5.0" 
$ns at 370.7602303956887 "$node_(298) setdest 12345 1776 11.0" 
$ns at 468.26446848146475 "$node_(298) setdest 46398 33442 14.0" 
$ns at 619.748761664244 "$node_(298) setdest 30614 25231 4.0" 
$ns at 687.335007386355 "$node_(298) setdest 41541 35992 2.0" 
$ns at 723.1080290380233 "$node_(298) setdest 31971 25873 19.0" 
$ns at 843.9145378356911 "$node_(298) setdest 67286 41618 11.0" 
$ns at 223.89288136099862 "$node_(299) setdest 120024 27208 7.0" 
$ns at 290.73590296574685 "$node_(299) setdest 107767 16211 11.0" 
$ns at 370.37208466904747 "$node_(299) setdest 112419 2219 10.0" 
$ns at 401.783057366891 "$node_(299) setdest 128984 11779 13.0" 
$ns at 460.7805527115098 "$node_(299) setdest 62701 20613 12.0" 
$ns at 601.5679137545017 "$node_(299) setdest 76973 29011 2.0" 
$ns at 643.5001837894575 "$node_(299) setdest 115953 22711 7.0" 
$ns at 688.2582713262605 "$node_(299) setdest 28890 39012 7.0" 
$ns at 768.6265140380999 "$node_(299) setdest 51162 11917 17.0" 
$ns at 809.563128568008 "$node_(299) setdest 114621 7084 7.0" 
$ns at 869.7335506052042 "$node_(299) setdest 129070 31013 1.0" 
$ns at 408.2999837268206 "$node_(300) setdest 22426 40212 15.0" 
$ns at 479.64138129682374 "$node_(300) setdest 21255 24737 13.0" 
$ns at 586.3766794942375 "$node_(300) setdest 72500 11766 3.0" 
$ns at 638.6059229162709 "$node_(300) setdest 123380 38603 4.0" 
$ns at 696.8963895291143 "$node_(300) setdest 49884 34791 10.0" 
$ns at 790.7379460443194 "$node_(300) setdest 84087 30016 19.0" 
$ns at 434.60234001369923 "$node_(301) setdest 77224 9710 20.0" 
$ns at 532.1801284252448 "$node_(301) setdest 96018 32939 19.0" 
$ns at 613.0205575904756 "$node_(301) setdest 43366 1793 5.0" 
$ns at 687.6949123118442 "$node_(301) setdest 98952 20390 4.0" 
$ns at 725.3611270773057 "$node_(301) setdest 71082 32197 8.0" 
$ns at 795.9718696811723 "$node_(301) setdest 79817 41912 8.0" 
$ns at 891.9248202034177 "$node_(301) setdest 20061 44595 15.0" 
$ns at 303.4167471836193 "$node_(302) setdest 6262 41801 1.0" 
$ns at 338.43802369291427 "$node_(302) setdest 102334 21297 6.0" 
$ns at 379.5780910652762 "$node_(302) setdest 117837 7450 9.0" 
$ns at 491.76367579722523 "$node_(302) setdest 37500 17527 16.0" 
$ns at 564.1418965179979 "$node_(302) setdest 90668 24214 4.0" 
$ns at 611.843196317956 "$node_(302) setdest 8308 34943 18.0" 
$ns at 780.0377909774994 "$node_(302) setdest 49479 6610 15.0" 
$ns at 852.3148590920554 "$node_(302) setdest 51098 27603 3.0" 
$ns at 326.0965599002893 "$node_(303) setdest 103207 7566 7.0" 
$ns at 368.2853015283988 "$node_(303) setdest 129695 8084 3.0" 
$ns at 425.0624344830056 "$node_(303) setdest 37926 14449 10.0" 
$ns at 530.1978029630943 "$node_(303) setdest 45425 30226 9.0" 
$ns at 579.7495205539997 "$node_(303) setdest 128080 10591 10.0" 
$ns at 630.207666561453 "$node_(303) setdest 98097 33997 14.0" 
$ns at 677.7712068502357 "$node_(303) setdest 86490 17663 6.0" 
$ns at 711.910402636436 "$node_(303) setdest 115798 22707 7.0" 
$ns at 794.2482193640883 "$node_(303) setdest 86477 44483 7.0" 
$ns at 839.6956699274238 "$node_(303) setdest 100801 20672 14.0" 
$ns at 315.0219291011614 "$node_(304) setdest 131773 37348 6.0" 
$ns at 372.0089529784087 "$node_(304) setdest 93264 16577 12.0" 
$ns at 454.3702935120636 "$node_(304) setdest 30290 25782 12.0" 
$ns at 595.2635715024173 "$node_(304) setdest 27826 18687 1.0" 
$ns at 628.4079008096301 "$node_(304) setdest 25229 10186 5.0" 
$ns at 675.5939464142652 "$node_(304) setdest 101263 31807 8.0" 
$ns at 731.664188688553 "$node_(304) setdest 75240 28789 13.0" 
$ns at 785.9961097171374 "$node_(304) setdest 24621 32785 18.0" 
$ns at 437.5310828713875 "$node_(305) setdest 33537 20439 15.0" 
$ns at 473.29588054203333 "$node_(305) setdest 83959 38426 8.0" 
$ns at 541.2476881418888 "$node_(305) setdest 128829 7553 11.0" 
$ns at 644.4276676546602 "$node_(305) setdest 78455 34688 13.0" 
$ns at 789.7049106883346 "$node_(305) setdest 44104 212 3.0" 
$ns at 823.445962258937 "$node_(305) setdest 3459 8584 1.0" 
$ns at 854.4906001168309 "$node_(305) setdest 59748 21712 4.0" 
$ns at 892.7363037378235 "$node_(305) setdest 76920 19438 14.0" 
$ns at 308.87924328203997 "$node_(306) setdest 23551 20543 12.0" 
$ns at 404.7113722144048 "$node_(306) setdest 38681 15052 6.0" 
$ns at 450.9729665328939 "$node_(306) setdest 78556 24311 6.0" 
$ns at 501.11158498353706 "$node_(306) setdest 115427 1157 15.0" 
$ns at 570.7504915032301 "$node_(306) setdest 44960 14336 18.0" 
$ns at 739.8145019349446 "$node_(306) setdest 85523 17414 1.0" 
$ns at 774.0510655623775 "$node_(306) setdest 26694 26408 1.0" 
$ns at 812.7733181228084 "$node_(306) setdest 40845 10697 2.0" 
$ns at 846.1097166992082 "$node_(306) setdest 28426 40503 15.0" 
$ns at 335.3128256556837 "$node_(307) setdest 111566 10468 1.0" 
$ns at 372.8241194038605 "$node_(307) setdest 45109 7456 15.0" 
$ns at 510.2965309266977 "$node_(307) setdest 97517 5475 14.0" 
$ns at 606.6318623665261 "$node_(307) setdest 8553 36132 8.0" 
$ns at 703.7684536785856 "$node_(307) setdest 76930 15222 4.0" 
$ns at 760.5752363360957 "$node_(307) setdest 119023 39389 15.0" 
$ns at 894.198747123412 "$node_(307) setdest 115251 24390 2.0" 
$ns at 416.6093433141215 "$node_(308) setdest 85060 41174 16.0" 
$ns at 586.5824877891773 "$node_(308) setdest 19974 26740 11.0" 
$ns at 627.6980718777969 "$node_(308) setdest 14034 30937 17.0" 
$ns at 672.5684339753092 "$node_(308) setdest 132952 2172 8.0" 
$ns at 736.737676884184 "$node_(308) setdest 85093 29260 11.0" 
$ns at 789.3372602043365 "$node_(308) setdest 56418 9599 19.0" 
$ns at 884.9712406636637 "$node_(308) setdest 101919 6778 11.0" 
$ns at 397.78414795095824 "$node_(309) setdest 90219 9807 17.0" 
$ns at 564.6240140912425 "$node_(309) setdest 46636 9946 6.0" 
$ns at 596.1417561848011 "$node_(309) setdest 89337 17381 7.0" 
$ns at 646.7820396492816 "$node_(309) setdest 106938 22050 15.0" 
$ns at 713.6894361545956 "$node_(309) setdest 62906 35218 1.0" 
$ns at 746.9454840357976 "$node_(309) setdest 3286 42592 7.0" 
$ns at 777.6860899073247 "$node_(309) setdest 125399 4267 1.0" 
$ns at 814.1076062790131 "$node_(309) setdest 114761 39849 12.0" 
$ns at 880.2584992599528 "$node_(309) setdest 18745 12506 5.0" 
$ns at 383.45578544147554 "$node_(310) setdest 64069 44150 9.0" 
$ns at 482.6244723674859 "$node_(310) setdest 114481 28056 7.0" 
$ns at 525.3398825493363 "$node_(310) setdest 18277 2657 15.0" 
$ns at 599.470485883344 "$node_(310) setdest 70427 20299 14.0" 
$ns at 677.4812861717395 "$node_(310) setdest 111434 37753 14.0" 
$ns at 739.5996744116787 "$node_(310) setdest 39879 31495 9.0" 
$ns at 828.7153017772777 "$node_(310) setdest 777 37604 1.0" 
$ns at 866.6436744055325 "$node_(310) setdest 35708 4852 14.0" 
$ns at 302.66245192936503 "$node_(311) setdest 27350 37666 12.0" 
$ns at 444.04612061966884 "$node_(311) setdest 125567 8029 19.0" 
$ns at 562.9934439595326 "$node_(311) setdest 133273 39281 8.0" 
$ns at 651.24811285074 "$node_(311) setdest 71170 40865 8.0" 
$ns at 727.1883657831926 "$node_(311) setdest 59944 21572 5.0" 
$ns at 767.8227854030843 "$node_(311) setdest 96894 16994 4.0" 
$ns at 833.257393612129 "$node_(311) setdest 32628 30070 20.0" 
$ns at 344.3625031027927 "$node_(312) setdest 122585 34788 11.0" 
$ns at 465.1669963369028 "$node_(312) setdest 90317 40131 14.0" 
$ns at 621.3324276832244 "$node_(312) setdest 102895 18795 18.0" 
$ns at 689.5439681171989 "$node_(312) setdest 103025 34204 1.0" 
$ns at 727.2432330122922 "$node_(312) setdest 52834 22608 19.0" 
$ns at 775.226375289798 "$node_(312) setdest 21509 30426 1.0" 
$ns at 809.1843702081065 "$node_(312) setdest 46795 275 5.0" 
$ns at 869.1267686532769 "$node_(312) setdest 99645 10751 1.0" 
$ns at 319.28025479789153 "$node_(313) setdest 93854 1597 15.0" 
$ns at 368.1837222896548 "$node_(313) setdest 133633 11369 11.0" 
$ns at 495.9637132917999 "$node_(313) setdest 25294 30226 12.0" 
$ns at 577.8640648942421 "$node_(313) setdest 5878 28528 18.0" 
$ns at 700.6010057994246 "$node_(313) setdest 16579 423 15.0" 
$ns at 777.6218457221064 "$node_(313) setdest 62537 15244 8.0" 
$ns at 880.5614630516769 "$node_(313) setdest 24727 36555 12.0" 
$ns at 372.95013630597236 "$node_(314) setdest 101402 28262 11.0" 
$ns at 439.55350660880435 "$node_(314) setdest 52636 15843 3.0" 
$ns at 485.106421141525 "$node_(314) setdest 114911 32444 10.0" 
$ns at 584.0385431963363 "$node_(314) setdest 2809 9337 1.0" 
$ns at 622.1568907916682 "$node_(314) setdest 36587 4972 16.0" 
$ns at 779.9924784099953 "$node_(314) setdest 46854 38925 1.0" 
$ns at 818.3170721929478 "$node_(314) setdest 99863 20783 11.0" 
$ns at 875.1029864727003 "$node_(314) setdest 118189 5070 16.0" 
$ns at 351.41933706401267 "$node_(315) setdest 108128 11396 2.0" 
$ns at 399.56039283051496 "$node_(315) setdest 13966 5693 15.0" 
$ns at 534.8893391170072 "$node_(315) setdest 2186 15740 14.0" 
$ns at 626.4656355528718 "$node_(315) setdest 36178 17887 16.0" 
$ns at 789.5701222574005 "$node_(315) setdest 1277 16385 19.0" 
$ns at 870.8557894287601 "$node_(315) setdest 50299 8157 2.0" 
$ns at 306.6949080023535 "$node_(316) setdest 97169 14487 16.0" 
$ns at 414.19193394947 "$node_(316) setdest 59126 43682 2.0" 
$ns at 447.53651551281325 "$node_(316) setdest 76686 39155 16.0" 
$ns at 617.4232024240973 "$node_(316) setdest 26806 16097 3.0" 
$ns at 650.4242126040598 "$node_(316) setdest 87665 3067 12.0" 
$ns at 765.7327235730919 "$node_(316) setdest 102963 4620 9.0" 
$ns at 860.7191475198933 "$node_(316) setdest 118207 1788 16.0" 
$ns at 309.61881990801794 "$node_(317) setdest 83896 30418 11.0" 
$ns at 342.3243867938219 "$node_(317) setdest 90924 19081 6.0" 
$ns at 403.56021632197746 "$node_(317) setdest 12624 42781 18.0" 
$ns at 564.2165078563041 "$node_(317) setdest 47033 35180 14.0" 
$ns at 686.5690899597298 "$node_(317) setdest 111931 24790 18.0" 
$ns at 732.7077508088274 "$node_(317) setdest 115235 24354 11.0" 
$ns at 820.961578359352 "$node_(317) setdest 29097 41765 6.0" 
$ns at 871.3691884291585 "$node_(317) setdest 19570 39799 12.0" 
$ns at 327.51340129289895 "$node_(318) setdest 93936 25880 10.0" 
$ns at 412.52240859503956 "$node_(318) setdest 24519 5812 3.0" 
$ns at 449.1395646911417 "$node_(318) setdest 34413 8986 6.0" 
$ns at 516.4480148133026 "$node_(318) setdest 31721 4898 3.0" 
$ns at 570.6555120816298 "$node_(318) setdest 124950 12367 20.0" 
$ns at 673.2541410399843 "$node_(318) setdest 107247 31043 17.0" 
$ns at 854.1181384450521 "$node_(318) setdest 40761 40747 14.0" 
$ns at 419.2148639641389 "$node_(319) setdest 100794 27057 12.0" 
$ns at 531.323290674537 "$node_(319) setdest 85718 28511 17.0" 
$ns at 589.4408195134946 "$node_(319) setdest 18025 40865 1.0" 
$ns at 623.313815035999 "$node_(319) setdest 113231 31438 8.0" 
$ns at 728.9675567025179 "$node_(319) setdest 87118 31091 15.0" 
$ns at 822.351684624777 "$node_(319) setdest 102893 25482 5.0" 
$ns at 870.2059813935207 "$node_(319) setdest 99715 23431 7.0" 
$ns at 301.2884818944406 "$node_(320) setdest 132891 40613 15.0" 
$ns at 432.90978575402926 "$node_(320) setdest 95846 19574 15.0" 
$ns at 514.3879018776204 "$node_(320) setdest 29445 3011 17.0" 
$ns at 658.6806678061221 "$node_(320) setdest 102592 16219 18.0" 
$ns at 775.2298472997396 "$node_(320) setdest 84449 37955 16.0" 
$ns at 411.57928952995474 "$node_(321) setdest 81290 7655 1.0" 
$ns at 445.57859290788053 "$node_(321) setdest 36445 26271 19.0" 
$ns at 491.47806319835695 "$node_(321) setdest 83576 25770 4.0" 
$ns at 549.6518883041218 "$node_(321) setdest 72814 35720 9.0" 
$ns at 606.6353194946789 "$node_(321) setdest 101016 44126 5.0" 
$ns at 676.8562444415473 "$node_(321) setdest 43968 3244 6.0" 
$ns at 731.2015281065225 "$node_(321) setdest 82398 8978 1.0" 
$ns at 770.3080207913723 "$node_(321) setdest 56620 5255 17.0" 
$ns at 825.9153251548065 "$node_(321) setdest 76238 18641 1.0" 
$ns at 864.8347651777549 "$node_(321) setdest 132963 11571 13.0" 
$ns at 332.05514461171487 "$node_(322) setdest 15618 44209 19.0" 
$ns at 525.8179600826072 "$node_(322) setdest 51313 11609 15.0" 
$ns at 646.1797945533862 "$node_(322) setdest 17048 3656 9.0" 
$ns at 687.8597138761025 "$node_(322) setdest 94502 11027 2.0" 
$ns at 730.2140878900852 "$node_(322) setdest 80674 1164 16.0" 
$ns at 791.6183598656314 "$node_(322) setdest 44000 23274 1.0" 
$ns at 823.1256598538192 "$node_(322) setdest 62586 21669 17.0" 
$ns at 461.3822929212921 "$node_(323) setdest 112938 18744 4.0" 
$ns at 493.57028786039325 "$node_(323) setdest 23574 41053 8.0" 
$ns at 544.5545266991505 "$node_(323) setdest 25388 29196 8.0" 
$ns at 611.5565523893295 "$node_(323) setdest 7846 12330 13.0" 
$ns at 770.6559815574358 "$node_(323) setdest 65296 27198 13.0" 
$ns at 850.6361355702375 "$node_(323) setdest 101261 36834 11.0" 
$ns at 363.1721694921885 "$node_(324) setdest 100752 2780 5.0" 
$ns at 418.79895144437256 "$node_(324) setdest 91769 10315 15.0" 
$ns at 474.05814500118083 "$node_(324) setdest 69059 23459 1.0" 
$ns at 508.8344858019708 "$node_(324) setdest 94785 42633 4.0" 
$ns at 541.3721826386508 "$node_(324) setdest 15546 43568 3.0" 
$ns at 581.6696365044683 "$node_(324) setdest 56366 37585 5.0" 
$ns at 652.6934277539906 "$node_(324) setdest 77824 37225 14.0" 
$ns at 707.3195387823843 "$node_(324) setdest 33040 8431 9.0" 
$ns at 815.4170935023187 "$node_(324) setdest 128597 94 6.0" 
$ns at 866.5970592349034 "$node_(324) setdest 112302 42752 14.0" 
$ns at 318.8881198774819 "$node_(325) setdest 100990 11013 17.0" 
$ns at 517.5027024455725 "$node_(325) setdest 81200 36367 1.0" 
$ns at 550.3226309694772 "$node_(325) setdest 78158 8777 4.0" 
$ns at 592.3536005687167 "$node_(325) setdest 104899 22781 18.0" 
$ns at 750.671782756943 "$node_(325) setdest 84822 15106 5.0" 
$ns at 791.6820404111365 "$node_(325) setdest 130388 6448 11.0" 
$ns at 887.5771232162099 "$node_(325) setdest 9307 7340 17.0" 
$ns at 324.9025100733788 "$node_(326) setdest 11991 28169 6.0" 
$ns at 398.74195295836705 "$node_(326) setdest 69606 28370 18.0" 
$ns at 587.0764960642646 "$node_(326) setdest 15295 19456 3.0" 
$ns at 629.1340003788307 "$node_(326) setdest 50175 21424 1.0" 
$ns at 661.7016270407845 "$node_(326) setdest 39538 39077 3.0" 
$ns at 720.2629652229284 "$node_(326) setdest 69288 29182 4.0" 
$ns at 780.9185073713577 "$node_(326) setdest 38541 33938 13.0" 
$ns at 393.72688289390226 "$node_(327) setdest 34169 31933 4.0" 
$ns at 429.3948125417126 "$node_(327) setdest 41555 33198 11.0" 
$ns at 515.4800108030599 "$node_(327) setdest 23985 43865 4.0" 
$ns at 580.7712283659151 "$node_(327) setdest 125664 43271 13.0" 
$ns at 724.7652033123378 "$node_(327) setdest 128155 40734 9.0" 
$ns at 837.5215829920351 "$node_(327) setdest 70844 33337 15.0" 
$ns at 346.3280876968236 "$node_(328) setdest 43321 13110 7.0" 
$ns at 435.9855775150791 "$node_(328) setdest 28809 4117 4.0" 
$ns at 473.0396213953932 "$node_(328) setdest 87920 8940 12.0" 
$ns at 576.065003752693 "$node_(328) setdest 106378 34379 13.0" 
$ns at 676.3447521572631 "$node_(328) setdest 59441 36949 10.0" 
$ns at 797.8259861611733 "$node_(328) setdest 80798 11491 10.0" 
$ns at 427.89524742182425 "$node_(329) setdest 128076 3759 14.0" 
$ns at 573.6243152049235 "$node_(329) setdest 99812 30234 1.0" 
$ns at 612.523349368589 "$node_(329) setdest 103975 32569 5.0" 
$ns at 646.7091892621876 "$node_(329) setdest 33341 43216 18.0" 
$ns at 773.9199896194295 "$node_(329) setdest 6488 27615 11.0" 
$ns at 828.8640013973949 "$node_(329) setdest 9815 534 7.0" 
$ns at 390.96535919956875 "$node_(330) setdest 13401 17817 6.0" 
$ns at 457.5849504081963 "$node_(330) setdest 15909 15318 14.0" 
$ns at 500.6441804462372 "$node_(330) setdest 80771 42832 9.0" 
$ns at 587.2710745225946 "$node_(330) setdest 78671 27318 5.0" 
$ns at 667.2192234962461 "$node_(330) setdest 30047 14892 19.0" 
$ns at 833.2036773144965 "$node_(330) setdest 99553 15687 16.0" 
$ns at 349.74089045809814 "$node_(331) setdest 87273 24946 1.0" 
$ns at 384.5884499474287 "$node_(331) setdest 3905 33748 3.0" 
$ns at 419.165734722504 "$node_(331) setdest 107077 34567 8.0" 
$ns at 521.0022155118564 "$node_(331) setdest 31225 27529 2.0" 
$ns at 561.3082414796619 "$node_(331) setdest 100308 25374 15.0" 
$ns at 594.0043995322035 "$node_(331) setdest 51536 9200 10.0" 
$ns at 720.5795287931273 "$node_(331) setdest 56451 12448 1.0" 
$ns at 750.9774161366864 "$node_(331) setdest 80255 43892 6.0" 
$ns at 810.5684236685469 "$node_(331) setdest 106935 12336 18.0" 
$ns at 381.02201481598144 "$node_(332) setdest 115080 29357 7.0" 
$ns at 432.6777429300097 "$node_(332) setdest 51088 10562 1.0" 
$ns at 471.2119637185645 "$node_(332) setdest 21066 22015 15.0" 
$ns at 530.134545566296 "$node_(332) setdest 25547 24090 7.0" 
$ns at 606.9445551477461 "$node_(332) setdest 69895 41357 10.0" 
$ns at 709.1450378862754 "$node_(332) setdest 35296 25854 3.0" 
$ns at 759.6852156995242 "$node_(332) setdest 70645 23248 8.0" 
$ns at 815.1029926170329 "$node_(332) setdest 124817 20400 5.0" 
$ns at 854.386296815942 "$node_(332) setdest 73696 21755 16.0" 
$ns at 892.1285275300673 "$node_(332) setdest 22880 20710 2.0" 
$ns at 368.82923558809887 "$node_(333) setdest 27016 9173 5.0" 
$ns at 421.0002911531723 "$node_(333) setdest 96378 14310 16.0" 
$ns at 465.0986050130929 "$node_(333) setdest 51069 33484 5.0" 
$ns at 496.63268646972523 "$node_(333) setdest 100678 3949 11.0" 
$ns at 636.3702294827228 "$node_(333) setdest 84960 34381 12.0" 
$ns at 751.7627775007037 "$node_(333) setdest 9280 15813 7.0" 
$ns at 812.2461918457376 "$node_(333) setdest 113065 31840 2.0" 
$ns at 857.0963760705303 "$node_(333) setdest 43934 28550 9.0" 
$ns at 341.37206401510554 "$node_(334) setdest 112209 24897 19.0" 
$ns at 379.71537459099386 "$node_(334) setdest 99979 31088 7.0" 
$ns at 460.48878411422123 "$node_(334) setdest 10780 21145 17.0" 
$ns at 648.4820132827952 "$node_(334) setdest 22878 17631 16.0" 
$ns at 821.2557464665159 "$node_(334) setdest 132154 44113 6.0" 
$ns at 853.5439429523399 "$node_(334) setdest 15475 13923 1.0" 
$ns at 888.5382581409834 "$node_(334) setdest 76545 41813 19.0" 
$ns at 340.7068652137431 "$node_(335) setdest 74901 20922 12.0" 
$ns at 396.1772963211159 "$node_(335) setdest 78450 24183 15.0" 
$ns at 428.7132904043325 "$node_(335) setdest 11862 39170 4.0" 
$ns at 483.11148238035486 "$node_(335) setdest 51676 30667 2.0" 
$ns at 522.7526636614423 "$node_(335) setdest 29279 37599 1.0" 
$ns at 558.9622124902897 "$node_(335) setdest 2255 24360 8.0" 
$ns at 634.4277733305324 "$node_(335) setdest 51641 16472 9.0" 
$ns at 673.5983957086753 "$node_(335) setdest 120579 40294 7.0" 
$ns at 707.4988250215005 "$node_(335) setdest 127798 8966 8.0" 
$ns at 750.5688101670069 "$node_(335) setdest 128761 13177 7.0" 
$ns at 839.1936184023631 "$node_(335) setdest 92575 9913 3.0" 
$ns at 883.6945640672229 "$node_(335) setdest 121189 21559 18.0" 
$ns at 314.6172345140714 "$node_(336) setdest 100610 14077 3.0" 
$ns at 350.68448718373395 "$node_(336) setdest 81453 36279 1.0" 
$ns at 381.1673773465165 "$node_(336) setdest 118798 43809 20.0" 
$ns at 491.44788150093285 "$node_(336) setdest 75789 20365 6.0" 
$ns at 570.0479790944986 "$node_(336) setdest 69229 33117 15.0" 
$ns at 669.0673418115392 "$node_(336) setdest 106743 6153 14.0" 
$ns at 767.9202416849865 "$node_(336) setdest 90065 31093 19.0" 
$ns at 894.9385332634447 "$node_(336) setdest 126503 13311 17.0" 
$ns at 396.185556388519 "$node_(337) setdest 57492 32020 3.0" 
$ns at 446.28137874493956 "$node_(337) setdest 35275 25947 16.0" 
$ns at 623.4190340719645 "$node_(337) setdest 88939 10811 1.0" 
$ns at 655.6938664329873 "$node_(337) setdest 132991 18131 4.0" 
$ns at 686.1037828161225 "$node_(337) setdest 24553 9971 2.0" 
$ns at 728.9442434913706 "$node_(337) setdest 91415 44485 19.0" 
$ns at 303.60540393462117 "$node_(338) setdest 68184 7739 10.0" 
$ns at 401.5530003806594 "$node_(338) setdest 130952 14523 18.0" 
$ns at 577.4351482651085 "$node_(338) setdest 71799 28610 2.0" 
$ns at 621.782593956479 "$node_(338) setdest 81677 33454 17.0" 
$ns at 705.8872007938872 "$node_(338) setdest 121245 26570 11.0" 
$ns at 753.9979862187215 "$node_(338) setdest 119530 44462 19.0" 
$ns at 873.8704613226387 "$node_(338) setdest 93519 27500 10.0" 
$ns at 323.4945719121752 "$node_(339) setdest 74977 16042 1.0" 
$ns at 358.21723204134906 "$node_(339) setdest 72795 38241 10.0" 
$ns at 402.7908886860673 "$node_(339) setdest 78498 26152 19.0" 
$ns at 486.23927023359676 "$node_(339) setdest 17388 38205 17.0" 
$ns at 629.4914585581035 "$node_(339) setdest 115988 22817 7.0" 
$ns at 713.8886029517965 "$node_(339) setdest 125719 29799 7.0" 
$ns at 760.1481125023527 "$node_(339) setdest 65298 43775 4.0" 
$ns at 802.2666635567024 "$node_(339) setdest 96968 22698 18.0" 
$ns at 317.6489402486576 "$node_(340) setdest 4305 33043 3.0" 
$ns at 360.20408633642455 "$node_(340) setdest 7093 11944 13.0" 
$ns at 504.32257501795544 "$node_(340) setdest 415 711 1.0" 
$ns at 540.3680921230672 "$node_(340) setdest 40830 13276 10.0" 
$ns at 573.8753077279334 "$node_(340) setdest 61259 21094 8.0" 
$ns at 654.3539201951844 "$node_(340) setdest 36659 13528 17.0" 
$ns at 838.5317005730681 "$node_(340) setdest 18421 30998 15.0" 
$ns at 436.14962755192437 "$node_(341) setdest 51685 31916 5.0" 
$ns at 474.4017479445249 "$node_(341) setdest 3704 8209 6.0" 
$ns at 558.2795176955792 "$node_(341) setdest 9060 39550 2.0" 
$ns at 594.1390528608756 "$node_(341) setdest 64531 16952 13.0" 
$ns at 697.0031166175935 "$node_(341) setdest 81220 793 10.0" 
$ns at 776.9265937291168 "$node_(341) setdest 7823 147 7.0" 
$ns at 837.290838365528 "$node_(341) setdest 26924 41945 16.0" 
$ns at 889.8510660295624 "$node_(341) setdest 14789 36630 3.0" 
$ns at 327.1994277626702 "$node_(342) setdest 60443 32402 6.0" 
$ns at 392.6296476997458 "$node_(342) setdest 88326 5110 13.0" 
$ns at 547.0804480153356 "$node_(342) setdest 39410 5146 5.0" 
$ns at 590.0503358617547 "$node_(342) setdest 22927 43840 4.0" 
$ns at 637.128705939617 "$node_(342) setdest 9792 12031 1.0" 
$ns at 670.5000413925823 "$node_(342) setdest 120780 24487 12.0" 
$ns at 702.7430945675295 "$node_(342) setdest 19582 26728 7.0" 
$ns at 749.0923308707407 "$node_(342) setdest 77689 38954 17.0" 
$ns at 838.4842712269234 "$node_(342) setdest 69276 19799 9.0" 
$ns at 327.60072845606953 "$node_(343) setdest 91926 36834 9.0" 
$ns at 447.0074424861004 "$node_(343) setdest 18370 17931 2.0" 
$ns at 496.08345262642945 "$node_(343) setdest 4221 30884 14.0" 
$ns at 643.2760562468596 "$node_(343) setdest 11017 22112 1.0" 
$ns at 682.4620601257939 "$node_(343) setdest 3507 37100 9.0" 
$ns at 765.9174020094404 "$node_(343) setdest 122525 12346 6.0" 
$ns at 809.9845340983796 "$node_(343) setdest 95099 5705 1.0" 
$ns at 843.2408900884634 "$node_(343) setdest 45794 41926 14.0" 
$ns at 879.7091531741313 "$node_(343) setdest 81710 26684 14.0" 
$ns at 314.064959235913 "$node_(344) setdest 6233 42013 18.0" 
$ns at 497.4894209537688 "$node_(344) setdest 3542 21223 4.0" 
$ns at 562.1202964784457 "$node_(344) setdest 9181 27511 10.0" 
$ns at 679.5192055174042 "$node_(344) setdest 105098 13923 1.0" 
$ns at 710.6665955437547 "$node_(344) setdest 38237 27342 1.0" 
$ns at 749.1583099435609 "$node_(344) setdest 128845 25259 12.0" 
$ns at 820.1888012775764 "$node_(344) setdest 37270 26647 1.0" 
$ns at 859.5485015760165 "$node_(344) setdest 31837 34660 12.0" 
$ns at 896.4399281351328 "$node_(344) setdest 5396 6512 19.0" 
$ns at 375.1198575557329 "$node_(345) setdest 113536 6744 10.0" 
$ns at 424.3651698621088 "$node_(345) setdest 28464 22446 5.0" 
$ns at 479.5693542864115 "$node_(345) setdest 56047 25367 17.0" 
$ns at 585.539397302731 "$node_(345) setdest 75455 4535 11.0" 
$ns at 713.8799158868559 "$node_(345) setdest 59105 21033 18.0" 
$ns at 794.5048247886798 "$node_(345) setdest 45574 38037 6.0" 
$ns at 882.3592013299427 "$node_(345) setdest 115150 8227 16.0" 
$ns at 316.2589115719483 "$node_(346) setdest 14374 16982 20.0" 
$ns at 517.8130082794906 "$node_(346) setdest 36264 31065 11.0" 
$ns at 614.903798067769 "$node_(346) setdest 119697 12589 14.0" 
$ns at 695.5723747161654 "$node_(346) setdest 49659 8318 11.0" 
$ns at 814.0514052662569 "$node_(346) setdest 132553 40195 15.0" 
$ns at 859.2728618579689 "$node_(346) setdest 97277 636 14.0" 
$ns at 321.0072419292633 "$node_(347) setdest 41048 23704 14.0" 
$ns at 407.4785242627351 "$node_(347) setdest 119066 16255 6.0" 
$ns at 450.106352784407 "$node_(347) setdest 65623 36583 6.0" 
$ns at 532.4861174380924 "$node_(347) setdest 83881 20476 1.0" 
$ns at 564.2623449774924 "$node_(347) setdest 107486 29358 12.0" 
$ns at 686.1291272377933 "$node_(347) setdest 68926 23683 20.0" 
$ns at 893.1749800312065 "$node_(347) setdest 5890 5627 3.0" 
$ns at 372.2582229581812 "$node_(348) setdest 7572 8682 4.0" 
$ns at 417.65810327517806 "$node_(348) setdest 80456 14451 13.0" 
$ns at 525.7216132216977 "$node_(348) setdest 19413 25205 4.0" 
$ns at 582.5425344493237 "$node_(348) setdest 77316 33918 9.0" 
$ns at 654.8935270129399 "$node_(348) setdest 42029 6606 10.0" 
$ns at 700.8600464542945 "$node_(348) setdest 58336 13004 12.0" 
$ns at 756.383647566242 "$node_(348) setdest 76396 35218 1.0" 
$ns at 790.503810230917 "$node_(348) setdest 76160 22771 7.0" 
$ns at 870.5302691119073 "$node_(348) setdest 73368 5579 19.0" 
$ns at 313.1411490533069 "$node_(349) setdest 60699 25965 13.0" 
$ns at 347.15299395302065 "$node_(349) setdest 39068 8575 1.0" 
$ns at 380.8255969589361 "$node_(349) setdest 85554 21106 6.0" 
$ns at 448.19691750393247 "$node_(349) setdest 103377 27735 18.0" 
$ns at 563.3858337539415 "$node_(349) setdest 29121 25713 6.0" 
$ns at 635.3911318438512 "$node_(349) setdest 13485 34828 14.0" 
$ns at 721.5339469103911 "$node_(349) setdest 29153 21245 4.0" 
$ns at 754.5824811617887 "$node_(349) setdest 127470 29943 14.0" 
$ns at 303.9121186907129 "$node_(350) setdest 77374 9654 8.0" 
$ns at 376.62827293517176 "$node_(350) setdest 77848 1530 16.0" 
$ns at 417.4355252888579 "$node_(350) setdest 94063 18252 6.0" 
$ns at 494.9315691273357 "$node_(350) setdest 110278 44174 15.0" 
$ns at 536.2383480732885 "$node_(350) setdest 16689 33733 2.0" 
$ns at 579.2542541292268 "$node_(350) setdest 109132 19661 11.0" 
$ns at 660.7585849780083 "$node_(350) setdest 101325 16693 13.0" 
$ns at 799.225858180568 "$node_(350) setdest 117392 9630 17.0" 
$ns at 342.6657724126019 "$node_(351) setdest 90812 38470 14.0" 
$ns at 457.14349314135427 "$node_(351) setdest 10647 12512 3.0" 
$ns at 492.68756848683364 "$node_(351) setdest 23747 13887 18.0" 
$ns at 539.3854047155195 "$node_(351) setdest 130377 34302 15.0" 
$ns at 651.2516253139502 "$node_(351) setdest 675 19263 10.0" 
$ns at 774.8867125016714 "$node_(351) setdest 52282 6714 3.0" 
$ns at 809.945316268464 "$node_(351) setdest 45052 357 6.0" 
$ns at 841.6245425625905 "$node_(351) setdest 35910 38808 18.0" 
$ns at 364.0062295675687 "$node_(352) setdest 132653 29473 8.0" 
$ns at 473.66311616896576 "$node_(352) setdest 69820 951 2.0" 
$ns at 510.3161990952447 "$node_(352) setdest 24831 41607 9.0" 
$ns at 548.6597897500503 "$node_(352) setdest 15982 25553 1.0" 
$ns at 584.2462310360266 "$node_(352) setdest 117771 30400 5.0" 
$ns at 621.8764053803939 "$node_(352) setdest 44717 3550 10.0" 
$ns at 742.8855539029267 "$node_(352) setdest 113586 20069 15.0" 
$ns at 823.1017346426222 "$node_(352) setdest 29372 39602 1.0" 
$ns at 854.6976487090512 "$node_(352) setdest 133456 18530 15.0" 
$ns at 894.9056139071004 "$node_(352) setdest 88993 14070 4.0" 
$ns at 324.4612640101127 "$node_(353) setdest 41837 9293 6.0" 
$ns at 390.86643137541625 "$node_(353) setdest 131417 43707 12.0" 
$ns at 433.24003147013656 "$node_(353) setdest 23918 32711 19.0" 
$ns at 590.4679273291013 "$node_(353) setdest 120100 44127 4.0" 
$ns at 626.1849579588942 "$node_(353) setdest 121137 18814 9.0" 
$ns at 745.2882053217996 "$node_(353) setdest 97825 36433 7.0" 
$ns at 835.6475539383493 "$node_(353) setdest 121260 17481 12.0" 
$ns at 350.0681985381931 "$node_(354) setdest 17736 28043 7.0" 
$ns at 429.7653516489455 "$node_(354) setdest 11370 9767 1.0" 
$ns at 465.432987371674 "$node_(354) setdest 116216 31569 15.0" 
$ns at 501.79090236498234 "$node_(354) setdest 50324 16272 3.0" 
$ns at 532.0994339321834 "$node_(354) setdest 85345 40772 18.0" 
$ns at 609.9262674365984 "$node_(354) setdest 46769 41996 15.0" 
$ns at 713.2813249794335 "$node_(354) setdest 21006 24819 2.0" 
$ns at 748.6059516988103 "$node_(354) setdest 5100 42471 1.0" 
$ns at 783.11269821206 "$node_(354) setdest 74923 29676 14.0" 
$ns at 305.3617765512617 "$node_(355) setdest 69697 25595 2.0" 
$ns at 350.15739923088165 "$node_(355) setdest 120576 12233 1.0" 
$ns at 388.95335628421986 "$node_(355) setdest 31711 2101 1.0" 
$ns at 423.15042907138127 "$node_(355) setdest 82786 39666 13.0" 
$ns at 476.0275707463574 "$node_(355) setdest 52403 19966 2.0" 
$ns at 506.15998434210115 "$node_(355) setdest 459 16826 2.0" 
$ns at 536.9350847787265 "$node_(355) setdest 95138 3747 12.0" 
$ns at 654.3664592134202 "$node_(355) setdest 121311 13839 17.0" 
$ns at 785.0628964071909 "$node_(355) setdest 117013 9409 4.0" 
$ns at 822.737107717857 "$node_(355) setdest 88610 4203 9.0" 
$ns at 885.3854912269237 "$node_(355) setdest 89122 24515 8.0" 
$ns at 304.95588256473513 "$node_(356) setdest 52839 2763 16.0" 
$ns at 337.608037440578 "$node_(356) setdest 79039 14537 16.0" 
$ns at 467.25699491067047 "$node_(356) setdest 30947 17230 5.0" 
$ns at 500.7465531159341 "$node_(356) setdest 115292 26288 5.0" 
$ns at 554.6646110463545 "$node_(356) setdest 65352 11416 17.0" 
$ns at 631.6363605550139 "$node_(356) setdest 62525 2187 1.0" 
$ns at 666.832595760079 "$node_(356) setdest 76650 29735 9.0" 
$ns at 754.3924336482225 "$node_(356) setdest 99689 3491 11.0" 
$ns at 846.5111847338318 "$node_(356) setdest 75305 8178 2.0" 
$ns at 891.6830944388213 "$node_(356) setdest 8777 21305 1.0" 
$ns at 399.6288165701426 "$node_(357) setdest 109293 38575 5.0" 
$ns at 472.4565894105784 "$node_(357) setdest 131394 518 11.0" 
$ns at 526.326618412487 "$node_(357) setdest 15267 1995 16.0" 
$ns at 655.7654296942306 "$node_(357) setdest 55645 15053 12.0" 
$ns at 792.4644295167343 "$node_(357) setdest 9725 14753 15.0" 
$ns at 398.9172887655201 "$node_(358) setdest 58509 37833 6.0" 
$ns at 431.6232803614561 "$node_(358) setdest 77849 8726 2.0" 
$ns at 475.08677409325367 "$node_(358) setdest 120536 1861 20.0" 
$ns at 690.0984954949988 "$node_(358) setdest 55804 31539 11.0" 
$ns at 829.4161455905229 "$node_(358) setdest 128068 44171 15.0" 
$ns at 372.55916258615724 "$node_(359) setdest 23279 31903 4.0" 
$ns at 431.96773870646496 "$node_(359) setdest 3163 19315 1.0" 
$ns at 470.25755067732615 "$node_(359) setdest 69061 5196 9.0" 
$ns at 548.0591407813081 "$node_(359) setdest 26517 23063 19.0" 
$ns at 764.6301219330055 "$node_(359) setdest 124138 28073 1.0" 
$ns at 802.8841543102968 "$node_(359) setdest 129081 40349 18.0" 
$ns at 890.908842909935 "$node_(359) setdest 106315 33788 8.0" 
$ns at 312.44195285190904 "$node_(360) setdest 106853 21326 10.0" 
$ns at 375.71712782305724 "$node_(360) setdest 103501 36339 8.0" 
$ns at 446.93459938695014 "$node_(360) setdest 80905 23375 19.0" 
$ns at 581.8155595991716 "$node_(360) setdest 95381 4941 2.0" 
$ns at 616.6230715217354 "$node_(360) setdest 26936 6000 20.0" 
$ns at 815.0307136345355 "$node_(360) setdest 54294 19073 4.0" 
$ns at 851.0447320117934 "$node_(360) setdest 123482 32204 1.0" 
$ns at 889.090803613883 "$node_(360) setdest 16863 12281 17.0" 
$ns at 389.97306425309085 "$node_(361) setdest 59583 40522 13.0" 
$ns at 454.1385419194746 "$node_(361) setdest 112342 19628 12.0" 
$ns at 567.9394391181487 "$node_(361) setdest 5252 22945 14.0" 
$ns at 608.2350248391838 "$node_(361) setdest 119961 41047 1.0" 
$ns at 641.9065746770642 "$node_(361) setdest 74496 41675 1.0" 
$ns at 672.3579987455763 "$node_(361) setdest 34876 16434 1.0" 
$ns at 711.6186928280944 "$node_(361) setdest 75287 28521 11.0" 
$ns at 786.9158548570779 "$node_(361) setdest 2992 14650 12.0" 
$ns at 826.709276691387 "$node_(361) setdest 77526 20040 12.0" 
$ns at 892.8801521038515 "$node_(361) setdest 115320 18411 5.0" 
$ns at 389.6978027829118 "$node_(362) setdest 60144 14521 12.0" 
$ns at 528.3144552065828 "$node_(362) setdest 117950 42036 14.0" 
$ns at 580.4172861275057 "$node_(362) setdest 41223 42678 7.0" 
$ns at 678.9723752183367 "$node_(362) setdest 91249 36708 8.0" 
$ns at 766.5050916235109 "$node_(362) setdest 120864 1511 17.0" 
$ns at 835.7628169140972 "$node_(362) setdest 128282 36057 18.0" 
$ns at 878.3415049705341 "$node_(362) setdest 24266 26246 10.0" 
$ns at 314.0516807273184 "$node_(363) setdest 52238 25169 19.0" 
$ns at 516.6943424609445 "$node_(363) setdest 67137 38088 20.0" 
$ns at 712.8845446947428 "$node_(363) setdest 89652 15199 4.0" 
$ns at 749.5934888408813 "$node_(363) setdest 92607 30345 6.0" 
$ns at 807.8568451436058 "$node_(363) setdest 106333 5017 8.0" 
$ns at 884.1024256721535 "$node_(363) setdest 113886 27571 11.0" 
$ns at 304.02271438257867 "$node_(364) setdest 75597 39616 15.0" 
$ns at 378.729124727635 "$node_(364) setdest 48427 1075 14.0" 
$ns at 503.77683275448896 "$node_(364) setdest 76466 43943 13.0" 
$ns at 566.2844155108414 "$node_(364) setdest 84103 27560 5.0" 
$ns at 638.7627022040308 "$node_(364) setdest 10836 5029 13.0" 
$ns at 701.1062769518026 "$node_(364) setdest 19902 24942 1.0" 
$ns at 740.7325092147838 "$node_(364) setdest 123327 27045 14.0" 
$ns at 804.8579304114276 "$node_(364) setdest 23218 8729 14.0" 
$ns at 301.73815300513905 "$node_(365) setdest 116942 21900 13.0" 
$ns at 367.82747406856083 "$node_(365) setdest 75850 16267 19.0" 
$ns at 480.4881435649851 "$node_(365) setdest 95001 42844 19.0" 
$ns at 548.9547989712077 "$node_(365) setdest 79159 11040 1.0" 
$ns at 582.3425348115493 "$node_(365) setdest 40161 42821 8.0" 
$ns at 619.2647207033685 "$node_(365) setdest 36000 1124 20.0" 
$ns at 747.7889149721061 "$node_(365) setdest 29890 19570 2.0" 
$ns at 786.8556603291361 "$node_(365) setdest 3841 36212 14.0" 
$ns at 829.6055370130426 "$node_(365) setdest 83382 10148 7.0" 
$ns at 875.2640045583548 "$node_(365) setdest 107864 11351 14.0" 
$ns at 394.8136950546167 "$node_(366) setdest 43899 7281 19.0" 
$ns at 585.9436490224075 "$node_(366) setdest 114162 31254 14.0" 
$ns at 749.8063675689923 "$node_(366) setdest 61437 40347 16.0" 
$ns at 808.0485712547105 "$node_(366) setdest 7651 39724 15.0" 
$ns at 376.66681347999145 "$node_(367) setdest 54619 40104 3.0" 
$ns at 412.08971329105145 "$node_(367) setdest 108 30387 13.0" 
$ns at 446.65087732676227 "$node_(367) setdest 9662 40870 5.0" 
$ns at 513.5080784888903 "$node_(367) setdest 97455 13840 15.0" 
$ns at 610.6984045573492 "$node_(367) setdest 9208 4909 19.0" 
$ns at 683.7502541034897 "$node_(367) setdest 128015 24689 19.0" 
$ns at 779.7424665010876 "$node_(367) setdest 85560 39967 1.0" 
$ns at 812.9784815619261 "$node_(367) setdest 2498 21493 18.0" 
$ns at 322.17057082820645 "$node_(368) setdest 23353 13266 8.0" 
$ns at 406.04262862089314 "$node_(368) setdest 108803 3729 18.0" 
$ns at 497.45585943646904 "$node_(368) setdest 6380 14242 17.0" 
$ns at 649.2214443868301 "$node_(368) setdest 77864 9559 5.0" 
$ns at 719.3075272756282 "$node_(368) setdest 101541 15750 11.0" 
$ns at 843.5553793722631 "$node_(368) setdest 26488 3786 18.0" 
$ns at 400.6174616767688 "$node_(369) setdest 10304 6203 4.0" 
$ns at 436.08281841441266 "$node_(369) setdest 85804 28375 16.0" 
$ns at 550.4563044196416 "$node_(369) setdest 49661 25855 6.0" 
$ns at 596.3540303592853 "$node_(369) setdest 114997 1610 1.0" 
$ns at 626.8242886422768 "$node_(369) setdest 104609 20060 8.0" 
$ns at 660.351647735277 "$node_(369) setdest 67002 38146 12.0" 
$ns at 802.8977546175761 "$node_(369) setdest 71288 6814 5.0" 
$ns at 834.834771570449 "$node_(369) setdest 67727 21146 13.0" 
$ns at 328.6286974665196 "$node_(370) setdest 21786 41554 15.0" 
$ns at 405.8010532817201 "$node_(370) setdest 88841 5348 9.0" 
$ns at 521.9450860441133 "$node_(370) setdest 67709 2999 18.0" 
$ns at 672.7668218330334 "$node_(370) setdest 100667 1795 5.0" 
$ns at 749.6357216260424 "$node_(370) setdest 115677 9440 10.0" 
$ns at 782.68424781077 "$node_(370) setdest 18832 31165 19.0" 
$ns at 835.4356060553712 "$node_(370) setdest 48673 7698 2.0" 
$ns at 883.6134842840576 "$node_(370) setdest 132665 19447 20.0" 
$ns at 305.44458644389164 "$node_(371) setdest 98405 21699 18.0" 
$ns at 354.7562297891801 "$node_(371) setdest 3263 10250 1.0" 
$ns at 387.1191066306109 "$node_(371) setdest 123394 33620 12.0" 
$ns at 419.9684027968485 "$node_(371) setdest 33882 21770 1.0" 
$ns at 452.5292167868927 "$node_(371) setdest 63814 34559 9.0" 
$ns at 539.2122118916546 "$node_(371) setdest 112992 38922 3.0" 
$ns at 579.0273587500786 "$node_(371) setdest 56979 5642 2.0" 
$ns at 619.4207143309027 "$node_(371) setdest 132267 7766 1.0" 
$ns at 657.1243740385064 "$node_(371) setdest 4245 39608 6.0" 
$ns at 692.1715444119669 "$node_(371) setdest 80601 34732 7.0" 
$ns at 777.4346031378329 "$node_(371) setdest 63670 30785 11.0" 
$ns at 865.3832739748269 "$node_(371) setdest 70750 39720 7.0" 
$ns at 331.6285425824048 "$node_(372) setdest 97075 42918 5.0" 
$ns at 363.04418429978716 "$node_(372) setdest 83210 40557 18.0" 
$ns at 568.7788957865914 "$node_(372) setdest 75019 40058 11.0" 
$ns at 653.5782951774128 "$node_(372) setdest 1684 43427 12.0" 
$ns at 749.9076789505033 "$node_(372) setdest 9465 38153 4.0" 
$ns at 791.4775856772258 "$node_(372) setdest 96778 27612 18.0" 
$ns at 858.6362232587184 "$node_(372) setdest 102674 12921 3.0" 
$ns at 337.4384381692676 "$node_(373) setdest 74233 12667 10.0" 
$ns at 371.532653008577 "$node_(373) setdest 54268 4360 19.0" 
$ns at 463.6649346529032 "$node_(373) setdest 131915 44632 4.0" 
$ns at 496.92021329821864 "$node_(373) setdest 78465 44455 2.0" 
$ns at 527.2150235762932 "$node_(373) setdest 57607 26693 9.0" 
$ns at 604.04465888226 "$node_(373) setdest 71913 19425 16.0" 
$ns at 709.786415758731 "$node_(373) setdest 23602 26735 16.0" 
$ns at 804.5603066976903 "$node_(373) setdest 93906 37931 6.0" 
$ns at 866.8206330960963 "$node_(373) setdest 55981 31091 20.0" 
$ns at 899.8725148415551 "$node_(373) setdest 132468 18284 13.0" 
$ns at 437.7836686458958 "$node_(374) setdest 6470 37466 5.0" 
$ns at 494.94544135772026 "$node_(374) setdest 19584 7102 8.0" 
$ns at 592.3286474399663 "$node_(374) setdest 2589 16653 5.0" 
$ns at 671.1863848755833 "$node_(374) setdest 65036 25954 3.0" 
$ns at 731.0341452780494 "$node_(374) setdest 67995 5544 10.0" 
$ns at 825.2531930753761 "$node_(374) setdest 133251 26656 4.0" 
$ns at 895.2092496783189 "$node_(374) setdest 133550 28394 7.0" 
$ns at 306.8219860786917 "$node_(375) setdest 72926 42188 12.0" 
$ns at 370.60196746676297 "$node_(375) setdest 69138 41991 3.0" 
$ns at 421.43768331360025 "$node_(375) setdest 49394 27909 6.0" 
$ns at 509.1013474964218 "$node_(375) setdest 52942 559 20.0" 
$ns at 640.1109620911909 "$node_(375) setdest 19645 34562 15.0" 
$ns at 746.2289835306243 "$node_(375) setdest 103722 33907 4.0" 
$ns at 809.7348797813728 "$node_(375) setdest 7903 13387 2.0" 
$ns at 843.8531512491181 "$node_(375) setdest 108072 8910 15.0" 
$ns at 884.568653684448 "$node_(375) setdest 74534 21193 12.0" 
$ns at 304.65012501217586 "$node_(376) setdest 7234 4373 16.0" 
$ns at 366.9702068467679 "$node_(376) setdest 26852 11457 3.0" 
$ns at 413.7521730862287 "$node_(376) setdest 63291 38688 8.0" 
$ns at 511.9138492390467 "$node_(376) setdest 9153 44495 18.0" 
$ns at 646.032642561988 "$node_(376) setdest 129276 14054 4.0" 
$ns at 710.3024573665135 "$node_(376) setdest 61851 39387 15.0" 
$ns at 764.9875585071873 "$node_(376) setdest 31753 39449 18.0" 
$ns at 899.4781962125724 "$node_(376) setdest 99107 37381 1.0" 
$ns at 326.9958301454198 "$node_(377) setdest 93640 36740 1.0" 
$ns at 365.75706740217333 "$node_(377) setdest 97407 30119 15.0" 
$ns at 534.9338732061351 "$node_(377) setdest 58625 34513 14.0" 
$ns at 569.9640248677794 "$node_(377) setdest 14105 36476 13.0" 
$ns at 627.7307410919431 "$node_(377) setdest 24926 30955 8.0" 
$ns at 680.3840129399038 "$node_(377) setdest 125609 19941 3.0" 
$ns at 711.4491656648834 "$node_(377) setdest 14789 11109 8.0" 
$ns at 790.5277079714178 "$node_(377) setdest 129886 38229 8.0" 
$ns at 859.2522563039396 "$node_(377) setdest 101486 9073 9.0" 
$ns at 363.5647922319168 "$node_(378) setdest 15230 29200 2.0" 
$ns at 411.2594201313447 "$node_(378) setdest 5817 41131 12.0" 
$ns at 458.0237086490835 "$node_(378) setdest 71739 497 6.0" 
$ns at 498.7234141372498 "$node_(378) setdest 26990 3305 11.0" 
$ns at 637.6059400874544 "$node_(378) setdest 33579 25892 8.0" 
$ns at 741.4541240589647 "$node_(378) setdest 4870 42062 20.0" 
$ns at 828.6329917122703 "$node_(378) setdest 14349 22554 10.0" 
$ns at 408.0791335041615 "$node_(379) setdest 118089 13357 4.0" 
$ns at 466.55702975394445 "$node_(379) setdest 11121 9287 14.0" 
$ns at 519.4442345096893 "$node_(379) setdest 67243 5538 20.0" 
$ns at 572.015199099167 "$node_(379) setdest 44451 588 5.0" 
$ns at 642.7346716087146 "$node_(379) setdest 114618 16845 17.0" 
$ns at 785.4117135414604 "$node_(379) setdest 77023 9619 4.0" 
$ns at 834.7633134767333 "$node_(379) setdest 66173 29308 5.0" 
$ns at 866.3962832395391 "$node_(379) setdest 896 6406 15.0" 
$ns at 310.2977412689924 "$node_(380) setdest 72692 24645 9.0" 
$ns at 390.4747699364389 "$node_(380) setdest 48993 20464 3.0" 
$ns at 447.7750110792264 "$node_(380) setdest 43653 26837 10.0" 
$ns at 495.8601068059247 "$node_(380) setdest 117750 25103 1.0" 
$ns at 532.8377473995763 "$node_(380) setdest 42257 39471 11.0" 
$ns at 667.6750937231049 "$node_(380) setdest 121012 34470 3.0" 
$ns at 701.6388288244983 "$node_(380) setdest 13825 1233 10.0" 
$ns at 822.475930579957 "$node_(380) setdest 34223 25498 12.0" 
$ns at 865.7402682193241 "$node_(380) setdest 89364 24578 14.0" 
$ns at 359.23870253514235 "$node_(381) setdest 61135 9991 14.0" 
$ns at 416.06771253408067 "$node_(381) setdest 37184 18422 10.0" 
$ns at 513.715338004737 "$node_(381) setdest 92914 362 16.0" 
$ns at 595.9971908495385 "$node_(381) setdest 79609 11455 16.0" 
$ns at 783.9656246936771 "$node_(381) setdest 74847 44656 13.0" 
$ns at 820.9174266255966 "$node_(381) setdest 95877 30538 9.0" 
$ns at 866.5711430339983 "$node_(381) setdest 53894 23048 20.0" 
$ns at 340.418061989031 "$node_(382) setdest 106454 43337 14.0" 
$ns at 414.4476387557812 "$node_(382) setdest 22972 36353 3.0" 
$ns at 465.64698633045293 "$node_(382) setdest 75873 5884 10.0" 
$ns at 504.16846748728267 "$node_(382) setdest 132312 17182 10.0" 
$ns at 594.3519728873105 "$node_(382) setdest 65297 23301 15.0" 
$ns at 746.2697229113136 "$node_(382) setdest 16478 26530 11.0" 
$ns at 810.9407243844993 "$node_(382) setdest 47237 18105 9.0" 
$ns at 353.8227880388521 "$node_(383) setdest 56399 34999 10.0" 
$ns at 455.2161460645196 "$node_(383) setdest 94526 16234 19.0" 
$ns at 623.8334423662042 "$node_(383) setdest 71176 18495 15.0" 
$ns at 676.2980943233499 "$node_(383) setdest 87056 25014 11.0" 
$ns at 798.3140208235069 "$node_(383) setdest 47412 17804 10.0" 
$ns at 332.547710829188 "$node_(384) setdest 43317 2650 4.0" 
$ns at 373.89545208327763 "$node_(384) setdest 102279 26590 6.0" 
$ns at 413.7485230222464 "$node_(384) setdest 45182 2584 13.0" 
$ns at 567.8043878060852 "$node_(384) setdest 94445 36094 14.0" 
$ns at 643.1138057558694 "$node_(384) setdest 53453 4790 18.0" 
$ns at 730.8857241642868 "$node_(384) setdest 128639 10195 4.0" 
$ns at 792.5733333128337 "$node_(384) setdest 575 12960 1.0" 
$ns at 823.3811764414561 "$node_(384) setdest 12740 3616 15.0" 
$ns at 887.0603650153313 "$node_(384) setdest 45889 9614 7.0" 
$ns at 352.4546292534967 "$node_(385) setdest 3601 21617 1.0" 
$ns at 391.93897238848473 "$node_(385) setdest 50021 10281 19.0" 
$ns at 576.9309715267741 "$node_(385) setdest 45198 38406 20.0" 
$ns at 710.3943605211173 "$node_(385) setdest 124674 39296 6.0" 
$ns at 755.9616509518978 "$node_(385) setdest 57271 20204 15.0" 
$ns at 328.70152225332737 "$node_(386) setdest 17299 35645 12.0" 
$ns at 363.2877974032707 "$node_(386) setdest 44768 23541 8.0" 
$ns at 455.6361580899336 "$node_(386) setdest 81970 26662 11.0" 
$ns at 547.0211450541877 "$node_(386) setdest 3868 272 12.0" 
$ns at 604.6731495977828 "$node_(386) setdest 84304 212 14.0" 
$ns at 675.0011864087164 "$node_(386) setdest 77567 2846 15.0" 
$ns at 781.4077794233834 "$node_(386) setdest 56857 14610 12.0" 
$ns at 855.7281762209939 "$node_(386) setdest 68437 8636 13.0" 
$ns at 387.6876420376325 "$node_(387) setdest 6433 17992 10.0" 
$ns at 438.2229406883961 "$node_(387) setdest 122254 21204 1.0" 
$ns at 474.13830952328215 "$node_(387) setdest 81247 44229 6.0" 
$ns at 554.8562107796897 "$node_(387) setdest 10077 6164 13.0" 
$ns at 654.4751471264025 "$node_(387) setdest 40399 2919 7.0" 
$ns at 745.5986473342248 "$node_(387) setdest 47871 42032 11.0" 
$ns at 824.6627590061279 "$node_(387) setdest 51449 43818 14.0" 
$ns at 310.4756244331367 "$node_(388) setdest 72802 13943 8.0" 
$ns at 392.9808170175663 "$node_(388) setdest 95010 9515 17.0" 
$ns at 438.7961095330576 "$node_(388) setdest 132487 36645 20.0" 
$ns at 485.43926506275295 "$node_(388) setdest 21219 39148 15.0" 
$ns at 593.4220953892027 "$node_(388) setdest 119118 40016 16.0" 
$ns at 751.4626051379294 "$node_(388) setdest 93490 11372 15.0" 
$ns at 804.5345839049716 "$node_(388) setdest 32662 27561 6.0" 
$ns at 879.9454117840304 "$node_(388) setdest 56164 9062 18.0" 
$ns at 408.26070289927384 "$node_(389) setdest 59484 42679 6.0" 
$ns at 461.25833679721666 "$node_(389) setdest 51642 43922 13.0" 
$ns at 583.1651645545726 "$node_(389) setdest 95946 20139 15.0" 
$ns at 642.733262199839 "$node_(389) setdest 8638 11638 12.0" 
$ns at 675.5649826380724 "$node_(389) setdest 32852 3728 10.0" 
$ns at 739.6678258719412 "$node_(389) setdest 106422 32659 17.0" 
$ns at 780.738928312292 "$node_(389) setdest 113285 18019 11.0" 
$ns at 831.7853955604405 "$node_(389) setdest 35005 39773 19.0" 
$ns at 306.05213512583225 "$node_(390) setdest 112433 11905 20.0" 
$ns at 531.3364279124597 "$node_(390) setdest 51225 7999 3.0" 
$ns at 566.2528554371921 "$node_(390) setdest 12746 43661 15.0" 
$ns at 635.8471356391885 "$node_(390) setdest 107580 26708 15.0" 
$ns at 705.1846343089052 "$node_(390) setdest 130380 9848 12.0" 
$ns at 784.3827735407972 "$node_(390) setdest 78626 6689 3.0" 
$ns at 838.518097803144 "$node_(390) setdest 131650 26595 5.0" 
$ns at 320.1981238552952 "$node_(391) setdest 97236 28256 7.0" 
$ns at 381.8385005012655 "$node_(391) setdest 26961 8579 19.0" 
$ns at 472.14157266990424 "$node_(391) setdest 119802 9030 16.0" 
$ns at 503.70509553704557 "$node_(391) setdest 107111 12989 7.0" 
$ns at 552.6335011555612 "$node_(391) setdest 101579 22823 3.0" 
$ns at 588.971282709284 "$node_(391) setdest 63916 754 3.0" 
$ns at 638.0875156771775 "$node_(391) setdest 5464 7996 11.0" 
$ns at 704.6222761088317 "$node_(391) setdest 43466 38588 9.0" 
$ns at 775.7154573007351 "$node_(391) setdest 92990 16157 16.0" 
$ns at 867.9871715158678 "$node_(391) setdest 36716 14338 13.0" 
$ns at 301.11166702619505 "$node_(392) setdest 97654 6724 9.0" 
$ns at 394.79394360525106 "$node_(392) setdest 6880 10043 8.0" 
$ns at 460.59526960119666 "$node_(392) setdest 5012 31534 16.0" 
$ns at 562.8123262112845 "$node_(392) setdest 102268 16382 13.0" 
$ns at 687.7324278514468 "$node_(392) setdest 56791 44087 9.0" 
$ns at 765.7327770246908 "$node_(392) setdest 53847 9274 12.0" 
$ns at 842.5497633557185 "$node_(392) setdest 84537 36513 10.0" 
$ns at 358.8425186069509 "$node_(393) setdest 63362 2423 9.0" 
$ns at 410.41406376318463 "$node_(393) setdest 122526 626 12.0" 
$ns at 467.3480345612585 "$node_(393) setdest 108721 564 14.0" 
$ns at 617.3493501445603 "$node_(393) setdest 97606 21850 10.0" 
$ns at 651.0197930606096 "$node_(393) setdest 123607 8535 5.0" 
$ns at 686.7919790799107 "$node_(393) setdest 26063 26819 13.0" 
$ns at 731.8337961106272 "$node_(393) setdest 394 22412 13.0" 
$ns at 789.3075992579093 "$node_(393) setdest 83066 2084 1.0" 
$ns at 828.7965621530541 "$node_(393) setdest 78468 25905 18.0" 
$ns at 476.62982089422513 "$node_(394) setdest 120495 35428 4.0" 
$ns at 535.1208785237056 "$node_(394) setdest 93185 22604 3.0" 
$ns at 568.7323334913085 "$node_(394) setdest 20593 36495 19.0" 
$ns at 758.3015782078085 "$node_(394) setdest 67465 4472 9.0" 
$ns at 831.6339531086375 "$node_(394) setdest 77810 37163 15.0" 
$ns at 401.99284853836554 "$node_(395) setdest 130217 1690 14.0" 
$ns at 450.70093468436164 "$node_(395) setdest 97354 42984 1.0" 
$ns at 483.85449145424093 "$node_(395) setdest 10258 44323 4.0" 
$ns at 543.7879441906301 "$node_(395) setdest 49005 1716 14.0" 
$ns at 628.3608700683315 "$node_(395) setdest 14242 6552 1.0" 
$ns at 666.5634746558484 "$node_(395) setdest 62592 29092 8.0" 
$ns at 735.4107059376519 "$node_(395) setdest 68269 42639 1.0" 
$ns at 767.0592759718061 "$node_(395) setdest 98373 8161 17.0" 
$ns at 355.561771822178 "$node_(396) setdest 56308 37678 6.0" 
$ns at 438.6060756510916 "$node_(396) setdest 67019 5734 14.0" 
$ns at 607.1752952464201 "$node_(396) setdest 28787 971 5.0" 
$ns at 679.9684286424558 "$node_(396) setdest 41494 20053 8.0" 
$ns at 767.0346048459458 "$node_(396) setdest 98615 9941 7.0" 
$ns at 853.2891261109521 "$node_(396) setdest 21671 26879 1.0" 
$ns at 887.4835134671036 "$node_(396) setdest 62762 7154 19.0" 
$ns at 334.9715326807035 "$node_(397) setdest 27151 14752 16.0" 
$ns at 513.3616247719792 "$node_(397) setdest 33332 8526 16.0" 
$ns at 594.7614207018032 "$node_(397) setdest 101919 33249 15.0" 
$ns at 677.9292058698609 "$node_(397) setdest 73701 40163 5.0" 
$ns at 719.30907981459 "$node_(397) setdest 52644 28576 9.0" 
$ns at 829.1193803877154 "$node_(397) setdest 15187 29775 17.0" 
$ns at 313.6860183403983 "$node_(398) setdest 43108 42744 17.0" 
$ns at 440.6438798687808 "$node_(398) setdest 36377 12522 7.0" 
$ns at 520.9687330653749 "$node_(398) setdest 129494 12877 20.0" 
$ns at 567.5880890104042 "$node_(398) setdest 124282 15896 1.0" 
$ns at 604.1090528811458 "$node_(398) setdest 31379 44128 10.0" 
$ns at 670.1899206527665 "$node_(398) setdest 77236 6902 7.0" 
$ns at 751.4846219804155 "$node_(398) setdest 114041 30338 16.0" 
$ns at 847.3164315443308 "$node_(398) setdest 108638 17051 19.0" 
$ns at 344.9924125860141 "$node_(399) setdest 52256 11782 9.0" 
$ns at 398.694847584225 "$node_(399) setdest 6906 7825 15.0" 
$ns at 457.1004044194901 "$node_(399) setdest 54342 490 2.0" 
$ns at 491.9669839733177 "$node_(399) setdest 114063 5448 19.0" 
$ns at 536.1579478134622 "$node_(399) setdest 105947 18139 2.0" 
$ns at 567.1785018312936 "$node_(399) setdest 29506 2122 14.0" 
$ns at 690.6844313053072 "$node_(399) setdest 125209 21379 2.0" 
$ns at 722.6948679033369 "$node_(399) setdest 92706 33086 18.0" 
$ns at 833.3741595293288 "$node_(399) setdest 81243 15113 12.0" 
$ns at 870.9796498274746 "$node_(399) setdest 101507 31155 19.0" 
$ns at 428.34678880470244 "$node_(400) setdest 31285 31134 10.0" 
$ns at 523.9691771286133 "$node_(400) setdest 22591 16372 15.0" 
$ns at 696.890545550271 "$node_(400) setdest 64750 37689 10.0" 
$ns at 812.5652008032296 "$node_(400) setdest 87781 17846 6.0" 
$ns at 888.5420420188926 "$node_(400) setdest 111897 42627 8.0" 
$ns at 477.1246865235841 "$node_(401) setdest 4328 23935 4.0" 
$ns at 511.4027883488145 "$node_(401) setdest 16364 7687 8.0" 
$ns at 612.6407428474012 "$node_(401) setdest 127467 39748 10.0" 
$ns at 714.220570447093 "$node_(401) setdest 14429 6375 12.0" 
$ns at 829.1830670115553 "$node_(401) setdest 29545 31470 10.0" 
$ns at 509.98300519265484 "$node_(402) setdest 97740 39672 1.0" 
$ns at 546.4912340088357 "$node_(402) setdest 95505 34880 6.0" 
$ns at 626.8430425975376 "$node_(402) setdest 86617 15439 6.0" 
$ns at 704.1165770455622 "$node_(402) setdest 74134 28755 9.0" 
$ns at 761.8625357009463 "$node_(402) setdest 95326 14965 8.0" 
$ns at 815.6898288625597 "$node_(402) setdest 3172 33012 1.0" 
$ns at 848.8163038221732 "$node_(402) setdest 113371 17501 3.0" 
$ns at 439.0294570231195 "$node_(403) setdest 36075 35909 7.0" 
$ns at 513.1899045568018 "$node_(403) setdest 86091 16218 10.0" 
$ns at 621.0950306266333 "$node_(403) setdest 25170 7861 16.0" 
$ns at 655.4060270989966 "$node_(403) setdest 119760 27043 19.0" 
$ns at 851.2434492081835 "$node_(403) setdest 28411 42379 4.0" 
$ns at 893.8953643463011 "$node_(403) setdest 125325 25960 11.0" 
$ns at 494.0138870813269 "$node_(404) setdest 48650 15532 10.0" 
$ns at 554.5534248477384 "$node_(404) setdest 94565 29552 13.0" 
$ns at 706.9197401343881 "$node_(404) setdest 30741 29199 18.0" 
$ns at 403.07364372960296 "$node_(405) setdest 33511 13468 16.0" 
$ns at 436.82964856661226 "$node_(405) setdest 133516 33539 7.0" 
$ns at 533.9138600619706 "$node_(405) setdest 17951 6321 13.0" 
$ns at 582.4813558706358 "$node_(405) setdest 128734 10718 10.0" 
$ns at 638.11734845489 "$node_(405) setdest 131057 1897 8.0" 
$ns at 712.1932804688215 "$node_(405) setdest 90725 18674 2.0" 
$ns at 746.0650207715095 "$node_(405) setdest 4938 12480 1.0" 
$ns at 782.3466487851008 "$node_(405) setdest 127495 29549 10.0" 
$ns at 878.6527695372388 "$node_(405) setdest 81623 29300 5.0" 
$ns at 441.69815910688556 "$node_(406) setdest 79781 40280 16.0" 
$ns at 587.9375988561345 "$node_(406) setdest 59346 11650 12.0" 
$ns at 626.9252661498961 "$node_(406) setdest 121717 20733 18.0" 
$ns at 728.930087277697 "$node_(406) setdest 126511 7941 6.0" 
$ns at 791.4280133202218 "$node_(406) setdest 11175 5475 16.0" 
$ns at 446.0213318503324 "$node_(407) setdest 53259 24536 1.0" 
$ns at 479.6641823898784 "$node_(407) setdest 12551 37481 16.0" 
$ns at 593.7418534336074 "$node_(407) setdest 10272 24966 13.0" 
$ns at 714.0582835594336 "$node_(407) setdest 940 42012 3.0" 
$ns at 748.64147039335 "$node_(407) setdest 36635 22073 20.0" 
$ns at 433.47817153184286 "$node_(408) setdest 50649 6307 18.0" 
$ns at 640.9977937029435 "$node_(408) setdest 47453 22266 9.0" 
$ns at 706.4276336232542 "$node_(408) setdest 106846 13419 17.0" 
$ns at 759.8219196579607 "$node_(408) setdest 96217 26327 4.0" 
$ns at 829.7387760816591 "$node_(408) setdest 76840 29173 6.0" 
$ns at 420.3329819844845 "$node_(409) setdest 95264 43309 2.0" 
$ns at 450.62969922733936 "$node_(409) setdest 116491 17769 1.0" 
$ns at 481.24894222117507 "$node_(409) setdest 79661 4655 20.0" 
$ns at 637.62379569048 "$node_(409) setdest 114568 29380 11.0" 
$ns at 711.485247955777 "$node_(409) setdest 75175 41127 6.0" 
$ns at 777.901534529779 "$node_(409) setdest 91213 9778 9.0" 
$ns at 809.3874458549249 "$node_(409) setdest 41583 27707 16.0" 
$ns at 883.6628321742176 "$node_(409) setdest 32702 6160 15.0" 
$ns at 418.5302817825511 "$node_(410) setdest 72061 12579 20.0" 
$ns at 540.8580891132793 "$node_(410) setdest 75710 1689 11.0" 
$ns at 604.5632540684069 "$node_(410) setdest 4791 27282 19.0" 
$ns at 762.964100640502 "$node_(410) setdest 78936 13946 12.0" 
$ns at 878.5104050754248 "$node_(410) setdest 73116 18308 13.0" 
$ns at 583.7883953554751 "$node_(411) setdest 129589 26372 18.0" 
$ns at 646.0631393009562 "$node_(411) setdest 27170 36169 16.0" 
$ns at 821.5337984482372 "$node_(411) setdest 91644 32990 11.0" 
$ns at 424.10509529635453 "$node_(412) setdest 106505 6045 2.0" 
$ns at 455.9074623400791 "$node_(412) setdest 8704 35230 7.0" 
$ns at 493.93067401302494 "$node_(412) setdest 14802 25778 7.0" 
$ns at 525.1377691184006 "$node_(412) setdest 125397 21586 16.0" 
$ns at 614.3475456811576 "$node_(412) setdest 107187 33629 7.0" 
$ns at 660.6754473794134 "$node_(412) setdest 132718 6164 18.0" 
$ns at 853.2697461521353 "$node_(412) setdest 80584 30289 5.0" 
$ns at 413.5954704556468 "$node_(413) setdest 18696 13090 12.0" 
$ns at 486.41915024788625 "$node_(413) setdest 110736 36787 8.0" 
$ns at 569.2029895525552 "$node_(413) setdest 2963 23072 18.0" 
$ns at 668.8676076783869 "$node_(413) setdest 28593 33920 9.0" 
$ns at 700.0118457809785 "$node_(413) setdest 13758 21412 16.0" 
$ns at 743.9581042862933 "$node_(413) setdest 87473 20510 18.0" 
$ns at 884.4580478707929 "$node_(413) setdest 123778 33947 2.0" 
$ns at 450.74646366325334 "$node_(414) setdest 71395 4334 16.0" 
$ns at 499.02204563846976 "$node_(414) setdest 93100 1365 15.0" 
$ns at 552.5082923366947 "$node_(414) setdest 58969 3882 19.0" 
$ns at 628.2276907059216 "$node_(414) setdest 850 13191 14.0" 
$ns at 721.4444750703808 "$node_(414) setdest 77123 22824 18.0" 
$ns at 774.9613837556305 "$node_(414) setdest 76364 26275 2.0" 
$ns at 822.3587193738709 "$node_(414) setdest 115774 18075 9.0" 
$ns at 555.494629698291 "$node_(415) setdest 6462 36711 3.0" 
$ns at 585.6377254234121 "$node_(415) setdest 14136 27219 9.0" 
$ns at 618.1848051783946 "$node_(415) setdest 47375 2977 3.0" 
$ns at 677.4507035772103 "$node_(415) setdest 30579 24217 15.0" 
$ns at 833.9090470537678 "$node_(415) setdest 120796 27484 3.0" 
$ns at 869.198555059175 "$node_(415) setdest 133569 36481 3.0" 
$ns at 418.37871381982507 "$node_(416) setdest 21544 30481 3.0" 
$ns at 476.6654990511967 "$node_(416) setdest 97783 16557 14.0" 
$ns at 631.5443171514482 "$node_(416) setdest 24998 35232 19.0" 
$ns at 750.310445141228 "$node_(416) setdest 106820 6788 14.0" 
$ns at 798.9849397539589 "$node_(416) setdest 119482 939 17.0" 
$ns at 885.3462876471292 "$node_(416) setdest 18681 29055 18.0" 
$ns at 434.4438477930398 "$node_(417) setdest 127460 17104 2.0" 
$ns at 483.17665387031064 "$node_(417) setdest 24358 38234 7.0" 
$ns at 559.9933424571491 "$node_(417) setdest 90580 24775 5.0" 
$ns at 622.1202552352872 "$node_(417) setdest 60148 40093 7.0" 
$ns at 673.2793132876892 "$node_(417) setdest 31880 7485 18.0" 
$ns at 728.526604255705 "$node_(417) setdest 80184 37334 11.0" 
$ns at 833.8935105498387 "$node_(417) setdest 57440 28830 5.0" 
$ns at 878.5426276495584 "$node_(417) setdest 124303 33223 18.0" 
$ns at 443.45610562876186 "$node_(418) setdest 96559 37578 3.0" 
$ns at 478.96035900172154 "$node_(418) setdest 12805 223 6.0" 
$ns at 564.9090431187308 "$node_(418) setdest 10474 23831 1.0" 
$ns at 600.4612884644865 "$node_(418) setdest 68425 41030 20.0" 
$ns at 703.6633750882357 "$node_(418) setdest 25502 15743 2.0" 
$ns at 748.032298830055 "$node_(418) setdest 48301 33764 9.0" 
$ns at 867.3504862018733 "$node_(418) setdest 122211 18236 9.0" 
$ns at 438.7195639968846 "$node_(419) setdest 113311 35798 1.0" 
$ns at 469.7848287690615 "$node_(419) setdest 12266 21977 12.0" 
$ns at 580.2618861187291 "$node_(419) setdest 95051 24341 8.0" 
$ns at 650.3775890164468 "$node_(419) setdest 117992 27956 18.0" 
$ns at 822.8601035500026 "$node_(419) setdest 87407 28730 14.0" 
$ns at 470.7084780353917 "$node_(420) setdest 26083 23642 20.0" 
$ns at 669.4583094139264 "$node_(420) setdest 127754 37964 13.0" 
$ns at 797.9354045718545 "$node_(420) setdest 28665 11579 7.0" 
$ns at 897.5428254563299 "$node_(420) setdest 91783 26436 16.0" 
$ns at 430.75622255482756 "$node_(421) setdest 48673 25252 9.0" 
$ns at 485.75561328613776 "$node_(421) setdest 36660 18087 14.0" 
$ns at 648.9048078442497 "$node_(421) setdest 61527 23983 17.0" 
$ns at 820.345971859905 "$node_(421) setdest 77194 12150 18.0" 
$ns at 438.7378460470975 "$node_(422) setdest 66626 25735 16.0" 
$ns at 590.0750842323336 "$node_(422) setdest 35019 1383 15.0" 
$ns at 669.9947915359683 "$node_(422) setdest 25253 19849 9.0" 
$ns at 735.0153431616526 "$node_(422) setdest 127985 32863 4.0" 
$ns at 783.9880664827632 "$node_(422) setdest 113351 15902 17.0" 
$ns at 835.1559407268985 "$node_(422) setdest 24186 13011 10.0" 
$ns at 882.1221665911733 "$node_(422) setdest 43563 13472 2.0" 
$ns at 490.94768444470253 "$node_(423) setdest 17276 24067 14.0" 
$ns at 539.2367986691136 "$node_(423) setdest 112280 36248 7.0" 
$ns at 625.1310019528552 "$node_(423) setdest 130454 24930 6.0" 
$ns at 676.7215858716733 "$node_(423) setdest 49411 44645 14.0" 
$ns at 718.0846738182812 "$node_(423) setdest 51978 26676 1.0" 
$ns at 753.5697362672139 "$node_(423) setdest 43509 24237 17.0" 
$ns at 824.7631004328969 "$node_(423) setdest 27575 40389 19.0" 
$ns at 474.10657008915996 "$node_(424) setdest 54517 30275 11.0" 
$ns at 510.1861029560454 "$node_(424) setdest 63053 8312 15.0" 
$ns at 689.7497084938977 "$node_(424) setdest 96449 3033 1.0" 
$ns at 722.4810155305611 "$node_(424) setdest 2970 39115 17.0" 
$ns at 836.4749657821911 "$node_(424) setdest 34617 22813 12.0" 
$ns at 880.8491738189584 "$node_(424) setdest 93998 31686 9.0" 
$ns at 426.16612622640775 "$node_(425) setdest 116345 3786 1.0" 
$ns at 459.4433473826951 "$node_(425) setdest 25899 8534 20.0" 
$ns at 570.4394387622067 "$node_(425) setdest 19826 17919 2.0" 
$ns at 616.0375310201406 "$node_(425) setdest 75466 36371 16.0" 
$ns at 681.7997534686399 "$node_(425) setdest 22479 16631 16.0" 
$ns at 784.2891779392339 "$node_(425) setdest 927 24946 19.0" 
$ns at 414.44156206911566 "$node_(426) setdest 49206 6958 1.0" 
$ns at 450.7979965099908 "$node_(426) setdest 1775 5025 1.0" 
$ns at 484.4593214974199 "$node_(426) setdest 56824 2760 14.0" 
$ns at 537.7903576992427 "$node_(426) setdest 45418 14986 18.0" 
$ns at 695.513769675907 "$node_(426) setdest 114438 31068 10.0" 
$ns at 744.6192579253128 "$node_(426) setdest 111820 17804 2.0" 
$ns at 792.934053188271 "$node_(426) setdest 20563 22502 14.0" 
$ns at 887.5443723679433 "$node_(426) setdest 83777 15984 14.0" 
$ns at 480.18805563311986 "$node_(427) setdest 40939 9807 12.0" 
$ns at 621.1118463653528 "$node_(427) setdest 19033 12076 7.0" 
$ns at 681.8473996522471 "$node_(427) setdest 103567 26694 2.0" 
$ns at 719.8088698441409 "$node_(427) setdest 75033 9247 2.0" 
$ns at 768.7048434803706 "$node_(427) setdest 32956 1279 7.0" 
$ns at 801.5337230568989 "$node_(427) setdest 99698 35566 10.0" 
$ns at 878.7857676303526 "$node_(427) setdest 49149 37086 13.0" 
$ns at 418.92177113170163 "$node_(428) setdest 9576 13553 4.0" 
$ns at 463.1353435232474 "$node_(428) setdest 31257 9893 12.0" 
$ns at 564.0648580140346 "$node_(428) setdest 98455 4984 17.0" 
$ns at 736.8678305459757 "$node_(428) setdest 131589 42774 1.0" 
$ns at 767.3401837437085 "$node_(428) setdest 97154 42038 10.0" 
$ns at 819.5136288754057 "$node_(428) setdest 39459 13913 17.0" 
$ns at 899.8706597701162 "$node_(428) setdest 114662 41474 4.0" 
$ns at 448.7852882988344 "$node_(429) setdest 27003 9135 1.0" 
$ns at 486.9852963140782 "$node_(429) setdest 106196 20006 10.0" 
$ns at 534.4455594581663 "$node_(429) setdest 37401 1308 12.0" 
$ns at 590.804309224636 "$node_(429) setdest 37934 39297 10.0" 
$ns at 719.7665129142104 "$node_(429) setdest 55378 11278 8.0" 
$ns at 757.4478300812142 "$node_(429) setdest 82514 36371 13.0" 
$ns at 887.8995454803224 "$node_(429) setdest 109635 44501 11.0" 
$ns at 409.505252156921 "$node_(430) setdest 94922 3355 1.0" 
$ns at 441.6482903098111 "$node_(430) setdest 37094 8294 1.0" 
$ns at 476.84502089095605 "$node_(430) setdest 48888 14949 10.0" 
$ns at 597.696053007219 "$node_(430) setdest 43106 25515 7.0" 
$ns at 649.7469771221764 "$node_(430) setdest 83537 15261 17.0" 
$ns at 803.5620086539955 "$node_(430) setdest 104382 39511 16.0" 
$ns at 882.1441747124309 "$node_(430) setdest 50682 38999 19.0" 
$ns at 400.2710811495948 "$node_(431) setdest 30692 2372 15.0" 
$ns at 526.9024153922744 "$node_(431) setdest 57665 473 20.0" 
$ns at 624.2663252665968 "$node_(431) setdest 39589 39599 1.0" 
$ns at 661.827697712656 "$node_(431) setdest 64855 28059 2.0" 
$ns at 706.9422254260894 "$node_(431) setdest 113287 16324 6.0" 
$ns at 768.3181762165988 "$node_(431) setdest 98859 16308 6.0" 
$ns at 843.2353055988345 "$node_(431) setdest 42147 43082 19.0" 
$ns at 521.9089300443704 "$node_(432) setdest 43469 29289 17.0" 
$ns at 560.4080188916904 "$node_(432) setdest 119925 11885 18.0" 
$ns at 710.387174745404 "$node_(432) setdest 6712 7373 14.0" 
$ns at 797.3841110441086 "$node_(432) setdest 77361 41668 2.0" 
$ns at 846.8281359965082 "$node_(432) setdest 76550 2623 1.0" 
$ns at 884.5420491642716 "$node_(432) setdest 125330 43035 5.0" 
$ns at 407.2172759273201 "$node_(433) setdest 56671 28217 8.0" 
$ns at 443.6096774173619 "$node_(433) setdest 31245 35126 18.0" 
$ns at 540.452123598737 "$node_(433) setdest 59513 20824 3.0" 
$ns at 580.0462000809729 "$node_(433) setdest 86581 11585 12.0" 
$ns at 729.7393578419001 "$node_(433) setdest 67775 38269 14.0" 
$ns at 798.9581269823727 "$node_(433) setdest 119922 24211 15.0" 
$ns at 455.1926804791151 "$node_(434) setdest 123217 15697 1.0" 
$ns at 492.8560835273253 "$node_(434) setdest 92920 982 6.0" 
$ns at 554.3349624592558 "$node_(434) setdest 26765 30333 8.0" 
$ns at 640.9447371601849 "$node_(434) setdest 64233 44661 8.0" 
$ns at 730.980189238433 "$node_(434) setdest 14895 15302 11.0" 
$ns at 841.7826547158078 "$node_(434) setdest 90438 41686 3.0" 
$ns at 461.14591099073243 "$node_(435) setdest 82302 19877 10.0" 
$ns at 532.9593782155616 "$node_(435) setdest 20686 31908 12.0" 
$ns at 588.7809681548604 "$node_(435) setdest 31479 18617 16.0" 
$ns at 776.7767334111883 "$node_(435) setdest 101242 19359 16.0" 
$ns at 448.83883451125064 "$node_(436) setdest 49256 23807 1.0" 
$ns at 483.66069453879555 "$node_(436) setdest 8858 21242 20.0" 
$ns at 564.499257167526 "$node_(436) setdest 6975 6702 17.0" 
$ns at 600.8279406257351 "$node_(436) setdest 46946 37271 15.0" 
$ns at 732.4023022640998 "$node_(436) setdest 131180 17738 11.0" 
$ns at 762.5221868145695 "$node_(436) setdest 35252 22122 15.0" 
$ns at 795.7838118007113 "$node_(436) setdest 75491 5890 8.0" 
$ns at 839.2333880621837 "$node_(436) setdest 107426 23238 10.0" 
$ns at 413.9569978155831 "$node_(437) setdest 59288 26061 19.0" 
$ns at 457.9234580580498 "$node_(437) setdest 60052 29212 15.0" 
$ns at 628.5064574596105 "$node_(437) setdest 40199 19148 2.0" 
$ns at 673.4590978232095 "$node_(437) setdest 3121 24437 1.0" 
$ns at 704.5169726996036 "$node_(437) setdest 126124 742 18.0" 
$ns at 502.51297134837756 "$node_(438) setdest 105911 22218 6.0" 
$ns at 542.8368405918092 "$node_(438) setdest 57618 28544 18.0" 
$ns at 623.5648851820893 "$node_(438) setdest 97492 22573 12.0" 
$ns at 735.738161636106 "$node_(438) setdest 98161 35517 10.0" 
$ns at 776.5670912564469 "$node_(438) setdest 4871 34889 20.0" 
$ns at 454.71143225889665 "$node_(439) setdest 101962 2162 17.0" 
$ns at 555.8800095846369 "$node_(439) setdest 19447 38095 1.0" 
$ns at 591.458682758556 "$node_(439) setdest 103947 16497 12.0" 
$ns at 678.1868269045964 "$node_(439) setdest 65873 22516 7.0" 
$ns at 765.6269483021972 "$node_(439) setdest 116933 21771 6.0" 
$ns at 822.6337276815044 "$node_(439) setdest 132483 15758 15.0" 
$ns at 895.7999592394708 "$node_(439) setdest 42085 21397 16.0" 
$ns at 545.7448349830863 "$node_(440) setdest 131989 21980 3.0" 
$ns at 596.7305425505523 "$node_(440) setdest 15442 26692 13.0" 
$ns at 671.0370287286723 "$node_(440) setdest 95025 33251 18.0" 
$ns at 763.3905384189765 "$node_(440) setdest 83412 33302 2.0" 
$ns at 812.9761752772089 "$node_(440) setdest 94237 34547 1.0" 
$ns at 852.1376898214369 "$node_(440) setdest 122113 1327 8.0" 
$ns at 524.2751914572895 "$node_(441) setdest 63027 23137 9.0" 
$ns at 578.7449674528752 "$node_(441) setdest 83228 37975 1.0" 
$ns at 617.935224927589 "$node_(441) setdest 28292 36145 5.0" 
$ns at 653.4346964621233 "$node_(441) setdest 12515 28349 15.0" 
$ns at 753.4813333007842 "$node_(441) setdest 46931 15878 8.0" 
$ns at 794.765115973051 "$node_(441) setdest 18293 26658 2.0" 
$ns at 826.4245157312939 "$node_(441) setdest 61062 10747 6.0" 
$ns at 877.8505626915628 "$node_(441) setdest 74259 27633 8.0" 
$ns at 433.9033913274013 "$node_(442) setdest 82402 21835 11.0" 
$ns at 481.6306237212959 "$node_(442) setdest 129616 680 11.0" 
$ns at 550.4843986872985 "$node_(442) setdest 90758 18423 5.0" 
$ns at 606.1797251689816 "$node_(442) setdest 116133 30057 6.0" 
$ns at 667.6725365531742 "$node_(442) setdest 100241 26850 19.0" 
$ns at 865.5280201130832 "$node_(442) setdest 8726 29174 17.0" 
$ns at 442.7554269770725 "$node_(443) setdest 27991 10379 19.0" 
$ns at 584.5210236675433 "$node_(443) setdest 128393 6443 12.0" 
$ns at 722.7909040877768 "$node_(443) setdest 109320 15091 1.0" 
$ns at 758.4494762063237 "$node_(443) setdest 63071 36610 12.0" 
$ns at 892.2714716820748 "$node_(443) setdest 60848 37643 6.0" 
$ns at 414.1057115176801 "$node_(444) setdest 68998 43813 9.0" 
$ns at 464.0631637406788 "$node_(444) setdest 62638 26004 5.0" 
$ns at 537.2727351812273 "$node_(444) setdest 55569 43468 9.0" 
$ns at 656.0879171624861 "$node_(444) setdest 107556 9786 9.0" 
$ns at 690.3170636651873 "$node_(444) setdest 72085 4350 18.0" 
$ns at 739.6352188835458 "$node_(444) setdest 38555 7621 4.0" 
$ns at 783.0251205112821 "$node_(444) setdest 128801 16391 3.0" 
$ns at 840.7345313727434 "$node_(444) setdest 3316 8774 6.0" 
$ns at 460.39251419610014 "$node_(445) setdest 35034 1349 4.0" 
$ns at 492.4229769916908 "$node_(445) setdest 67741 32944 17.0" 
$ns at 620.086854863075 "$node_(445) setdest 22216 23258 7.0" 
$ns at 683.6555624581956 "$node_(445) setdest 69186 23387 4.0" 
$ns at 731.860492920541 "$node_(445) setdest 83895 30835 7.0" 
$ns at 827.328528802771 "$node_(445) setdest 16967 43232 12.0" 
$ns at 535.9213035134198 "$node_(446) setdest 110665 3100 4.0" 
$ns at 587.2950838696196 "$node_(446) setdest 64651 16212 8.0" 
$ns at 636.9189961450363 "$node_(446) setdest 31676 38801 14.0" 
$ns at 722.4946272614998 "$node_(446) setdest 116483 42974 14.0" 
$ns at 765.0305606058997 "$node_(446) setdest 23299 8999 6.0" 
$ns at 796.696035982175 "$node_(446) setdest 99782 17287 19.0" 
$ns at 893.5997863396642 "$node_(446) setdest 14444 35354 8.0" 
$ns at 406.56489066572317 "$node_(447) setdest 38276 35162 2.0" 
$ns at 436.71853274953907 "$node_(447) setdest 122690 19822 11.0" 
$ns at 547.5170961373977 "$node_(447) setdest 43763 10208 5.0" 
$ns at 603.5815102654058 "$node_(447) setdest 100475 24493 6.0" 
$ns at 647.547523345703 "$node_(447) setdest 84276 22220 3.0" 
$ns at 691.98436642125 "$node_(447) setdest 35482 6561 4.0" 
$ns at 728.8366323732573 "$node_(447) setdest 133441 16077 18.0" 
$ns at 855.8576325516663 "$node_(447) setdest 6293 14688 14.0" 
$ns at 465.5593525251011 "$node_(448) setdest 100975 3992 1.0" 
$ns at 497.3424342774911 "$node_(448) setdest 21359 20637 7.0" 
$ns at 553.4924349599662 "$node_(448) setdest 122934 34793 12.0" 
$ns at 669.1310240591258 "$node_(448) setdest 101338 3105 13.0" 
$ns at 810.8639781522904 "$node_(448) setdest 132477 43690 5.0" 
$ns at 873.01404001883 "$node_(448) setdest 89100 19778 20.0" 
$ns at 457.9262576159423 "$node_(449) setdest 132060 5852 3.0" 
$ns at 514.4117361573752 "$node_(449) setdest 113581 12473 16.0" 
$ns at 702.8325258629607 "$node_(449) setdest 37597 38750 8.0" 
$ns at 788.9591342018119 "$node_(449) setdest 52253 36950 19.0" 
$ns at 887.1005081790292 "$node_(449) setdest 93605 11307 19.0" 
$ns at 470.2263641385798 "$node_(450) setdest 58949 40913 9.0" 
$ns at 516.0685279307721 "$node_(450) setdest 67529 10507 6.0" 
$ns at 604.6320754650719 "$node_(450) setdest 92696 24987 3.0" 
$ns at 635.5034709686005 "$node_(450) setdest 19566 23837 13.0" 
$ns at 768.5971630583056 "$node_(450) setdest 89 4918 7.0" 
$ns at 864.139359911046 "$node_(450) setdest 57387 23022 3.0" 
$ns at 897.8637194652578 "$node_(450) setdest 134135 33959 7.0" 
$ns at 469.9933133420185 "$node_(451) setdest 14415 10725 15.0" 
$ns at 649.8638820839391 "$node_(451) setdest 36677 18801 10.0" 
$ns at 708.7732152995928 "$node_(451) setdest 8586 31899 11.0" 
$ns at 775.8013437444541 "$node_(451) setdest 21223 42494 18.0" 
$ns at 869.5904982920965 "$node_(451) setdest 80907 35105 14.0" 
$ns at 466.30877192880706 "$node_(452) setdest 10849 42971 1.0" 
$ns at 501.951025003738 "$node_(452) setdest 102512 19676 14.0" 
$ns at 600.5993570258415 "$node_(452) setdest 76144 20429 12.0" 
$ns at 693.4783236271525 "$node_(452) setdest 11974 9925 11.0" 
$ns at 798.7490094132778 "$node_(452) setdest 89178 23433 15.0" 
$ns at 878.931222135151 "$node_(452) setdest 46444 39390 6.0" 
$ns at 452.1743502096781 "$node_(453) setdest 17254 11905 10.0" 
$ns at 508.8351844160572 "$node_(453) setdest 12656 11664 10.0" 
$ns at 546.1895981667889 "$node_(453) setdest 4446 2512 7.0" 
$ns at 584.1570786824678 "$node_(453) setdest 88714 779 12.0" 
$ns at 675.9701755732399 "$node_(453) setdest 14248 30871 19.0" 
$ns at 789.8134712101231 "$node_(453) setdest 86601 16227 5.0" 
$ns at 851.2130919887177 "$node_(453) setdest 130208 14954 7.0" 
$ns at 446.4627112264517 "$node_(454) setdest 28750 39834 17.0" 
$ns at 484.51989670740716 "$node_(454) setdest 108402 33443 19.0" 
$ns at 618.3576177587762 "$node_(454) setdest 22639 41124 19.0" 
$ns at 686.6770775171747 "$node_(454) setdest 116984 40543 18.0" 
$ns at 797.7185068933047 "$node_(454) setdest 132998 12859 7.0" 
$ns at 878.2739924203522 "$node_(454) setdest 1618 36921 18.0" 
$ns at 405.2677029530863 "$node_(455) setdest 118550 1060 9.0" 
$ns at 488.2361853585851 "$node_(455) setdest 46769 9092 8.0" 
$ns at 562.6501652672712 "$node_(455) setdest 33340 26970 14.0" 
$ns at 717.4422770651863 "$node_(455) setdest 37833 28442 7.0" 
$ns at 762.308792603662 "$node_(455) setdest 130113 18945 3.0" 
$ns at 801.952723578731 "$node_(455) setdest 2595 34926 4.0" 
$ns at 865.3069814267351 "$node_(455) setdest 6695 21752 5.0" 
$ns at 401.58016770603876 "$node_(456) setdest 81619 8420 3.0" 
$ns at 432.40447671675497 "$node_(456) setdest 10566 3278 2.0" 
$ns at 475.50953332063364 "$node_(456) setdest 12780 10033 14.0" 
$ns at 568.7374302338014 "$node_(456) setdest 87052 5083 9.0" 
$ns at 628.6611986446565 "$node_(456) setdest 83326 28018 4.0" 
$ns at 663.871441154584 "$node_(456) setdest 112591 23210 2.0" 
$ns at 710.7618090518619 "$node_(456) setdest 119329 3082 3.0" 
$ns at 754.190503192375 "$node_(456) setdest 2496 28399 15.0" 
$ns at 489.1757103802114 "$node_(457) setdest 88803 27826 4.0" 
$ns at 530.2734596296706 "$node_(457) setdest 15759 25910 19.0" 
$ns at 645.1977925753081 "$node_(457) setdest 99679 9210 12.0" 
$ns at 691.83914306699 "$node_(457) setdest 5367 71 14.0" 
$ns at 725.9183428498459 "$node_(457) setdest 122983 20024 1.0" 
$ns at 761.202969353015 "$node_(457) setdest 80150 14538 6.0" 
$ns at 823.0164634120104 "$node_(457) setdest 9847 4546 18.0" 
$ns at 884.9915188710559 "$node_(457) setdest 125347 10528 12.0" 
$ns at 410.2447178268071 "$node_(458) setdest 34104 11556 5.0" 
$ns at 456.29444086485194 "$node_(458) setdest 64032 29074 3.0" 
$ns at 497.43868465347543 "$node_(458) setdest 76783 7783 6.0" 
$ns at 585.6508070934528 "$node_(458) setdest 25036 19729 19.0" 
$ns at 759.1011787551491 "$node_(458) setdest 95357 4495 10.0" 
$ns at 873.3340433739115 "$node_(458) setdest 75424 969 14.0" 
$ns at 458.2532239343125 "$node_(459) setdest 132929 31826 2.0" 
$ns at 491.75881248214495 "$node_(459) setdest 61986 11488 13.0" 
$ns at 603.17766742662 "$node_(459) setdest 133032 28766 16.0" 
$ns at 650.4279109809233 "$node_(459) setdest 119122 39904 2.0" 
$ns at 695.8765573480347 "$node_(459) setdest 40792 41713 6.0" 
$ns at 765.3537714481478 "$node_(459) setdest 30244 13981 19.0" 
$ns at 448.85266718257424 "$node_(460) setdest 105162 9512 7.0" 
$ns at 479.1744866942491 "$node_(460) setdest 56466 38697 2.0" 
$ns at 527.932167793776 "$node_(460) setdest 101431 3933 19.0" 
$ns at 682.1579358164336 "$node_(460) setdest 46903 20132 19.0" 
$ns at 890.4566530206607 "$node_(460) setdest 90927 6253 8.0" 
$ns at 465.9168638178442 "$node_(461) setdest 34182 33965 16.0" 
$ns at 554.1719549624631 "$node_(461) setdest 124393 25846 11.0" 
$ns at 689.1653373807679 "$node_(461) setdest 39437 28816 10.0" 
$ns at 728.4583153118145 "$node_(461) setdest 15375 21292 17.0" 
$ns at 827.5979679880567 "$node_(461) setdest 48569 35144 19.0" 
$ns at 882.8671328004201 "$node_(461) setdest 96541 32334 12.0" 
$ns at 427.7341975950097 "$node_(462) setdest 6904 30529 7.0" 
$ns at 457.9026154354113 "$node_(462) setdest 46848 10496 11.0" 
$ns at 544.1505438795556 "$node_(462) setdest 120927 31548 15.0" 
$ns at 601.3281294601824 "$node_(462) setdest 126252 36177 2.0" 
$ns at 634.8352642212994 "$node_(462) setdest 34826 3774 7.0" 
$ns at 726.9584012944433 "$node_(462) setdest 73973 15527 3.0" 
$ns at 758.0166278923579 "$node_(462) setdest 99022 13256 14.0" 
$ns at 876.9120459536489 "$node_(462) setdest 69088 34213 15.0" 
$ns at 527.9283027556388 "$node_(463) setdest 43748 1664 9.0" 
$ns at 605.0941658466095 "$node_(463) setdest 65649 38422 10.0" 
$ns at 669.3329001853467 "$node_(463) setdest 45968 9223 17.0" 
$ns at 711.0639656931686 "$node_(463) setdest 94443 21509 15.0" 
$ns at 836.5673997404741 "$node_(463) setdest 45793 40718 18.0" 
$ns at 475.87934257201624 "$node_(464) setdest 54940 21220 1.0" 
$ns at 508.2594728378203 "$node_(464) setdest 104016 33372 13.0" 
$ns at 600.141278222246 "$node_(464) setdest 86871 22301 11.0" 
$ns at 683.480815401428 "$node_(464) setdest 129895 24965 1.0" 
$ns at 721.7108515028955 "$node_(464) setdest 24167 27033 14.0" 
$ns at 887.4934274389271 "$node_(464) setdest 61579 3755 5.0" 
$ns at 493.9338395932946 "$node_(465) setdest 118359 5525 18.0" 
$ns at 584.0288273390331 "$node_(465) setdest 14372 31070 2.0" 
$ns at 631.3256402629194 "$node_(465) setdest 69096 32111 3.0" 
$ns at 669.3996769588671 "$node_(465) setdest 132465 25436 13.0" 
$ns at 816.5909508101865 "$node_(465) setdest 75955 4408 16.0" 
$ns at 534.1248729115599 "$node_(466) setdest 15105 41042 5.0" 
$ns at 599.8216839496449 "$node_(466) setdest 42009 6376 14.0" 
$ns at 664.7606267279355 "$node_(466) setdest 57446 37677 12.0" 
$ns at 708.6470239889325 "$node_(466) setdest 70186 180 8.0" 
$ns at 784.8366180597601 "$node_(466) setdest 55710 37518 9.0" 
$ns at 857.6949359911414 "$node_(466) setdest 8369 7569 14.0" 
$ns at 448.2018503498123 "$node_(467) setdest 10899 6331 10.0" 
$ns at 504.47324472372514 "$node_(467) setdest 131131 28867 17.0" 
$ns at 702.2819814741283 "$node_(467) setdest 74924 252 15.0" 
$ns at 792.404343884398 "$node_(467) setdest 111770 30081 5.0" 
$ns at 837.0139592161007 "$node_(467) setdest 120952 13416 11.0" 
$ns at 457.52753331370377 "$node_(468) setdest 107375 26672 5.0" 
$ns at 490.6010887614554 "$node_(468) setdest 81816 26327 7.0" 
$ns at 555.6824072463412 "$node_(468) setdest 38444 37926 11.0" 
$ns at 665.2662345663646 "$node_(468) setdest 100085 13986 4.0" 
$ns at 732.1798286549138 "$node_(468) setdest 20683 8465 13.0" 
$ns at 837.8853197432284 "$node_(468) setdest 7452 12484 14.0" 
$ns at 406.6391303878392 "$node_(469) setdest 124393 41714 3.0" 
$ns at 463.8857456830342 "$node_(469) setdest 40679 24234 18.0" 
$ns at 601.3146901457015 "$node_(469) setdest 111120 579 4.0" 
$ns at 655.5064852141505 "$node_(469) setdest 101432 16934 5.0" 
$ns at 732.814515378269 "$node_(469) setdest 83109 40003 3.0" 
$ns at 786.9484698114504 "$node_(469) setdest 113493 27701 14.0" 
$ns at 879.3110877293867 "$node_(469) setdest 3833 22017 3.0" 
$ns at 470.61516200330027 "$node_(470) setdest 40280 39350 19.0" 
$ns at 503.9041984252636 "$node_(470) setdest 69028 16345 2.0" 
$ns at 552.2438824907124 "$node_(470) setdest 4429 5262 8.0" 
$ns at 657.1678030974472 "$node_(470) setdest 99855 12033 19.0" 
$ns at 844.1514591291032 "$node_(470) setdest 73895 20080 17.0" 
$ns at 417.1924084471591 "$node_(471) setdest 93382 33267 6.0" 
$ns at 481.3529700576791 "$node_(471) setdest 65341 7352 2.0" 
$ns at 531.3130574769867 "$node_(471) setdest 91854 17851 5.0" 
$ns at 596.9103283201206 "$node_(471) setdest 76190 31860 10.0" 
$ns at 641.7804207383074 "$node_(471) setdest 51712 1667 19.0" 
$ns at 709.7560593700815 "$node_(471) setdest 27347 34951 19.0" 
$ns at 821.5050326213758 "$node_(471) setdest 111962 41302 1.0" 
$ns at 853.8146617115696 "$node_(471) setdest 106967 42178 1.0" 
$ns at 886.4844367279168 "$node_(471) setdest 8530 7935 6.0" 
$ns at 459.4915459922665 "$node_(472) setdest 53015 29973 12.0" 
$ns at 542.6556861112787 "$node_(472) setdest 121592 16813 8.0" 
$ns at 610.0244545615658 "$node_(472) setdest 123598 1175 15.0" 
$ns at 789.099954324633 "$node_(472) setdest 87517 2897 18.0" 
$ns at 427.0585963762838 "$node_(473) setdest 32828 29957 3.0" 
$ns at 469.7741553805736 "$node_(473) setdest 88957 22039 20.0" 
$ns at 594.0789583299312 "$node_(473) setdest 2688 12322 15.0" 
$ns at 638.4086417041589 "$node_(473) setdest 123964 10611 6.0" 
$ns at 689.1205453896131 "$node_(473) setdest 103790 42692 1.0" 
$ns at 725.1140943891623 "$node_(473) setdest 27477 9107 8.0" 
$ns at 799.3469282624833 "$node_(473) setdest 33868 36167 18.0" 
$ns at 884.8521945142165 "$node_(473) setdest 20875 43257 6.0" 
$ns at 473.4957955248938 "$node_(474) setdest 103767 12530 9.0" 
$ns at 579.2334924919932 "$node_(474) setdest 69721 40131 3.0" 
$ns at 628.1216848954448 "$node_(474) setdest 63066 37459 9.0" 
$ns at 726.0881063667924 "$node_(474) setdest 103377 24265 16.0" 
$ns at 436.9078569906293 "$node_(475) setdest 56257 31883 4.0" 
$ns at 500.548073940549 "$node_(475) setdest 25273 6844 12.0" 
$ns at 546.2921864122479 "$node_(475) setdest 91563 22635 9.0" 
$ns at 612.063101145875 "$node_(475) setdest 38062 6955 13.0" 
$ns at 692.357384802846 "$node_(475) setdest 87701 17875 9.0" 
$ns at 741.4971667187748 "$node_(475) setdest 96538 13892 20.0" 
$ns at 473.8205025295268 "$node_(476) setdest 8946 39034 3.0" 
$ns at 521.3746563200235 "$node_(476) setdest 29465 9324 10.0" 
$ns at 567.1783913974728 "$node_(476) setdest 48030 21638 17.0" 
$ns at 720.4635301950605 "$node_(476) setdest 112896 37746 7.0" 
$ns at 772.1150485240514 "$node_(476) setdest 48200 26593 12.0" 
$ns at 856.3822133963841 "$node_(476) setdest 17794 22956 9.0" 
$ns at 499.2308714350868 "$node_(477) setdest 6297 22716 1.0" 
$ns at 531.550211078609 "$node_(477) setdest 44756 41997 4.0" 
$ns at 593.1496306231686 "$node_(477) setdest 117514 28115 2.0" 
$ns at 630.7040832899655 "$node_(477) setdest 58112 39551 17.0" 
$ns at 814.265469694926 "$node_(477) setdest 128156 12362 6.0" 
$ns at 890.9937375316175 "$node_(477) setdest 52621 25916 15.0" 
$ns at 418.19357679894347 "$node_(478) setdest 51901 36231 8.0" 
$ns at 456.01405405618544 "$node_(478) setdest 65629 17538 8.0" 
$ns at 509.95013643255146 "$node_(478) setdest 73021 23446 11.0" 
$ns at 620.7555058242284 "$node_(478) setdest 129141 40366 5.0" 
$ns at 652.9709422950864 "$node_(478) setdest 14316 1782 10.0" 
$ns at 749.661791014556 "$node_(478) setdest 117512 38090 4.0" 
$ns at 786.3460103308564 "$node_(478) setdest 86976 31176 15.0" 
$ns at 485.47505186081503 "$node_(479) setdest 2759 4512 2.0" 
$ns at 521.2126431209743 "$node_(479) setdest 36282 30607 13.0" 
$ns at 560.725721787996 "$node_(479) setdest 9410 28345 5.0" 
$ns at 616.4019056311835 "$node_(479) setdest 115556 34463 15.0" 
$ns at 738.8250957993055 "$node_(479) setdest 70710 37873 1.0" 
$ns at 772.5923737048457 "$node_(479) setdest 4633 20609 16.0" 
$ns at 828.0679960267565 "$node_(479) setdest 63558 26807 13.0" 
$ns at 415.7257314741555 "$node_(480) setdest 82095 5951 7.0" 
$ns at 513.6263717948957 "$node_(480) setdest 19821 25917 16.0" 
$ns at 700.8016760273872 "$node_(480) setdest 95818 32299 4.0" 
$ns at 743.0246287210641 "$node_(480) setdest 15264 3501 12.0" 
$ns at 786.9030188080751 "$node_(480) setdest 61129 16024 3.0" 
$ns at 820.6397940801471 "$node_(480) setdest 33580 27708 17.0" 
$ns at 408.07119900002675 "$node_(481) setdest 8185 38360 10.0" 
$ns at 512.5223962816527 "$node_(481) setdest 44367 3986 18.0" 
$ns at 595.4762114184108 "$node_(481) setdest 57453 29337 10.0" 
$ns at 650.5448304514739 "$node_(481) setdest 63313 31830 11.0" 
$ns at 699.656397040827 "$node_(481) setdest 48338 39669 2.0" 
$ns at 734.0739016333338 "$node_(481) setdest 60557 32623 8.0" 
$ns at 793.9697730254393 "$node_(481) setdest 80089 35281 2.0" 
$ns at 824.7506489917693 "$node_(481) setdest 13031 30106 18.0" 
$ns at 878.7767351318439 "$node_(481) setdest 115819 39383 1.0" 
$ns at 495.61753965468233 "$node_(482) setdest 84927 32691 1.0" 
$ns at 526.9538582460958 "$node_(482) setdest 65116 3378 9.0" 
$ns at 645.9815833457532 "$node_(482) setdest 102371 1760 10.0" 
$ns at 690.8421320724324 "$node_(482) setdest 27798 32671 19.0" 
$ns at 522.9511694331837 "$node_(483) setdest 104792 19581 4.0" 
$ns at 565.2956160591083 "$node_(483) setdest 11246 35135 9.0" 
$ns at 628.4057843722546 "$node_(483) setdest 103420 15698 9.0" 
$ns at 681.6469043385426 "$node_(483) setdest 13550 34336 20.0" 
$ns at 724.6616188864422 "$node_(483) setdest 37703 22150 1.0" 
$ns at 755.2335408777108 "$node_(483) setdest 1853 7698 10.0" 
$ns at 860.4166113259898 "$node_(483) setdest 124882 24199 15.0" 
$ns at 408.28965033922697 "$node_(484) setdest 109433 10830 8.0" 
$ns at 504.10185746219025 "$node_(484) setdest 52274 1600 7.0" 
$ns at 564.8311789187063 "$node_(484) setdest 130049 16600 5.0" 
$ns at 642.1925994509174 "$node_(484) setdest 35914 36059 9.0" 
$ns at 700.492489907868 "$node_(484) setdest 46777 33620 7.0" 
$ns at 776.6235774670918 "$node_(484) setdest 73465 23106 19.0" 
$ns at 860.4274449119075 "$node_(484) setdest 19864 32414 19.0" 
$ns at 404.8918677429863 "$node_(485) setdest 57039 17187 13.0" 
$ns at 525.0038081440617 "$node_(485) setdest 111435 6139 3.0" 
$ns at 560.0365491428238 "$node_(485) setdest 55668 18098 2.0" 
$ns at 609.2266722935764 "$node_(485) setdest 122588 15586 9.0" 
$ns at 701.2801682603198 "$node_(485) setdest 93737 42637 9.0" 
$ns at 736.0729506121387 "$node_(485) setdest 129018 40720 10.0" 
$ns at 787.8983880706453 "$node_(485) setdest 90392 44483 8.0" 
$ns at 875.4743233327481 "$node_(485) setdest 12381 26858 7.0" 
$ns at 443.00758940275443 "$node_(486) setdest 63385 38224 15.0" 
$ns at 517.1774459119272 "$node_(486) setdest 4527 9064 13.0" 
$ns at 568.436996170462 "$node_(486) setdest 78431 7937 17.0" 
$ns at 658.6338867386214 "$node_(486) setdest 128365 28466 10.0" 
$ns at 745.8788905958402 "$node_(486) setdest 6740 35332 1.0" 
$ns at 781.1321176045672 "$node_(486) setdest 66302 25838 10.0" 
$ns at 829.9781559078426 "$node_(486) setdest 40899 44263 1.0" 
$ns at 867.7060570612641 "$node_(486) setdest 91733 43050 14.0" 
$ns at 403.1058719174803 "$node_(487) setdest 107993 11339 9.0" 
$ns at 492.73197920582203 "$node_(487) setdest 88875 15500 15.0" 
$ns at 631.0154308907106 "$node_(487) setdest 57679 11036 9.0" 
$ns at 736.5730480483151 "$node_(487) setdest 4427 36240 8.0" 
$ns at 797.145164203233 "$node_(487) setdest 85253 13780 18.0" 
$ns at 561.6727540393332 "$node_(488) setdest 55552 42567 1.0" 
$ns at 598.9689621588116 "$node_(488) setdest 37957 7112 15.0" 
$ns at 645.1200434036205 "$node_(488) setdest 83320 43429 15.0" 
$ns at 726.939547756017 "$node_(488) setdest 36251 14416 7.0" 
$ns at 770.6892048889413 "$node_(488) setdest 83503 23669 10.0" 
$ns at 885.1320350347024 "$node_(488) setdest 14703 3991 13.0" 
$ns at 519.1364142176968 "$node_(489) setdest 36646 27153 19.0" 
$ns at 735.973243795315 "$node_(489) setdest 50204 3996 14.0" 
$ns at 786.4094373915765 "$node_(489) setdest 91344 25457 14.0" 
$ns at 825.4459120203454 "$node_(489) setdest 73688 23431 2.0" 
$ns at 856.2047790215802 "$node_(489) setdest 117355 31533 6.0" 
$ns at 891.4945444873728 "$node_(489) setdest 114952 15899 15.0" 
$ns at 444.2164155792255 "$node_(490) setdest 79489 3571 6.0" 
$ns at 478.6851427236626 "$node_(490) setdest 37784 32040 12.0" 
$ns at 550.9782328794126 "$node_(490) setdest 502 38426 6.0" 
$ns at 590.9018113274642 "$node_(490) setdest 118568 10929 6.0" 
$ns at 666.2478606571631 "$node_(490) setdest 114215 15732 12.0" 
$ns at 703.8165361176704 "$node_(490) setdest 1096 3613 10.0" 
$ns at 790.4064370915465 "$node_(490) setdest 72196 42288 14.0" 
$ns at 829.2832483991784 "$node_(490) setdest 39229 35470 4.0" 
$ns at 880.335240333872 "$node_(490) setdest 79848 31973 5.0" 
$ns at 444.7713335288305 "$node_(491) setdest 76788 37821 9.0" 
$ns at 512.5551273842404 "$node_(491) setdest 109559 33813 1.0" 
$ns at 545.206838077093 "$node_(491) setdest 62405 1822 11.0" 
$ns at 647.3896938388682 "$node_(491) setdest 52472 17367 12.0" 
$ns at 733.3637849352625 "$node_(491) setdest 101774 30995 8.0" 
$ns at 807.7762137057526 "$node_(491) setdest 51569 32534 16.0" 
$ns at 853.1361929047526 "$node_(491) setdest 84499 10471 13.0" 
$ns at 435.915303447411 "$node_(492) setdest 77726 13962 8.0" 
$ns at 487.4264437546968 "$node_(492) setdest 72578 14988 5.0" 
$ns at 551.3760256182214 "$node_(492) setdest 72438 1350 8.0" 
$ns at 657.57931626529 "$node_(492) setdest 5067 2565 7.0" 
$ns at 755.7028441245583 "$node_(492) setdest 5600 41784 13.0" 
$ns at 877.8200329291934 "$node_(492) setdest 33632 11903 17.0" 
$ns at 524.3386543984814 "$node_(493) setdest 68324 43557 9.0" 
$ns at 576.6108622488621 "$node_(493) setdest 123921 1804 5.0" 
$ns at 630.1881583447243 "$node_(493) setdest 133512 30981 2.0" 
$ns at 664.305956711005 "$node_(493) setdest 10498 1292 10.0" 
$ns at 775.084757217508 "$node_(493) setdest 22818 20238 9.0" 
$ns at 851.161572295951 "$node_(493) setdest 116820 39052 2.0" 
$ns at 881.2403671139756 "$node_(493) setdest 42998 25926 13.0" 
$ns at 409.4268424637836 "$node_(494) setdest 66905 24166 3.0" 
$ns at 451.8461821075465 "$node_(494) setdest 127910 20852 7.0" 
$ns at 516.3504955066078 "$node_(494) setdest 109982 29789 14.0" 
$ns at 642.5615393608643 "$node_(494) setdest 106160 42337 13.0" 
$ns at 673.9710411801168 "$node_(494) setdest 73813 18131 18.0" 
$ns at 765.5974763387314 "$node_(494) setdest 68247 8369 4.0" 
$ns at 815.3751375710782 "$node_(494) setdest 99882 42731 16.0" 
$ns at 410.12583857916013 "$node_(495) setdest 4219 24405 3.0" 
$ns at 440.21775890442865 "$node_(495) setdest 24221 21731 1.0" 
$ns at 478.17154015380333 "$node_(495) setdest 65504 4958 7.0" 
$ns at 555.028040074967 "$node_(495) setdest 104411 29336 18.0" 
$ns at 706.7291022514279 "$node_(495) setdest 62188 42150 11.0" 
$ns at 755.9284701532281 "$node_(495) setdest 39055 15304 12.0" 
$ns at 835.5878776997365 "$node_(495) setdest 29227 22889 12.0" 
$ns at 468.48940711523676 "$node_(496) setdest 60470 36117 17.0" 
$ns at 654.2942188424569 "$node_(496) setdest 29294 8992 9.0" 
$ns at 738.5891523722556 "$node_(496) setdest 104972 16801 11.0" 
$ns at 785.4191615955763 "$node_(496) setdest 26235 9505 16.0" 
$ns at 423.22589310805427 "$node_(497) setdest 53590 18534 10.0" 
$ns at 497.3557188116731 "$node_(497) setdest 30047 9488 2.0" 
$ns at 545.0811090590445 "$node_(497) setdest 1977 26921 2.0" 
$ns at 577.3988273384435 "$node_(497) setdest 119060 13947 15.0" 
$ns at 647.6494371229909 "$node_(497) setdest 127347 24346 17.0" 
$ns at 707.4040748700078 "$node_(497) setdest 10521 14099 15.0" 
$ns at 776.134201777837 "$node_(497) setdest 5640 26466 3.0" 
$ns at 833.9276978967517 "$node_(497) setdest 60756 44430 14.0" 
$ns at 865.9079153046946 "$node_(497) setdest 106369 13372 4.0" 
$ns at 406.13431855822324 "$node_(498) setdest 123377 8296 1.0" 
$ns at 444.43589717709665 "$node_(498) setdest 106410 17819 14.0" 
$ns at 504.83548663742533 "$node_(498) setdest 28221 5887 19.0" 
$ns at 588.4001225193842 "$node_(498) setdest 19605 43952 14.0" 
$ns at 624.8625198490145 "$node_(498) setdest 51796 3714 1.0" 
$ns at 660.247306819492 "$node_(498) setdest 80450 31386 1.0" 
$ns at 699.4331919996561 "$node_(498) setdest 16722 5486 7.0" 
$ns at 763.3534314376999 "$node_(498) setdest 39341 268 16.0" 
$ns at 408.4480390794771 "$node_(499) setdest 40731 30879 7.0" 
$ns at 462.9182519699287 "$node_(499) setdest 74266 26205 9.0" 
$ns at 534.5909446290477 "$node_(499) setdest 98789 17147 8.0" 
$ns at 605.1747247401449 "$node_(499) setdest 26000 28867 18.0" 
$ns at 727.2701112371501 "$node_(499) setdest 37843 12649 19.0" 
$ns at 782.4646509421822 "$node_(499) setdest 71515 9666 12.0" 
$ns at 614.8282667866931 "$node_(500) setdest 4435 9047 13.0" 
$ns at 679.0005202772784 "$node_(500) setdest 28271 40986 8.0" 
$ns at 757.1936748135455 "$node_(500) setdest 73817 34966 4.0" 
$ns at 824.4461363290242 "$node_(500) setdest 58312 10967 17.0" 
$ns at 563.2050340948199 "$node_(501) setdest 100805 20331 6.0" 
$ns at 618.2061023307427 "$node_(501) setdest 60088 26813 5.0" 
$ns at 691.4807527236636 "$node_(501) setdest 88682 1042 6.0" 
$ns at 765.0731143506808 "$node_(501) setdest 37458 31229 15.0" 
$ns at 859.6265570594707 "$node_(501) setdest 46812 36604 1.0" 
$ns at 892.1184999746981 "$node_(501) setdest 1933 35729 6.0" 
$ns at 594.1433962653061 "$node_(502) setdest 12124 37858 15.0" 
$ns at 672.4227290342759 "$node_(502) setdest 14332 44512 1.0" 
$ns at 705.7853314002306 "$node_(502) setdest 12749 30356 10.0" 
$ns at 814.9942554915301 "$node_(502) setdest 129334 35902 15.0" 
$ns at 647.4975107619789 "$node_(503) setdest 95262 41466 7.0" 
$ns at 694.5271874249084 "$node_(503) setdest 35513 7235 11.0" 
$ns at 831.9509201444612 "$node_(503) setdest 26673 2123 15.0" 
$ns at 896.4647681916224 "$node_(503) setdest 125490 22350 19.0" 
$ns at 501.900928826586 "$node_(504) setdest 123523 29623 1.0" 
$ns at 537.5243933455714 "$node_(504) setdest 101539 38651 13.0" 
$ns at 601.0219954538253 "$node_(504) setdest 126714 35823 17.0" 
$ns at 633.3165191033772 "$node_(504) setdest 26119 34812 14.0" 
$ns at 715.2949213796971 "$node_(504) setdest 70690 23655 11.0" 
$ns at 778.1064919890367 "$node_(504) setdest 85683 42555 14.0" 
$ns at 808.38787700464 "$node_(504) setdest 18264 43010 3.0" 
$ns at 840.7879307666951 "$node_(504) setdest 125122 31579 5.0" 
$ns at 548.9730536910836 "$node_(505) setdest 128048 378 17.0" 
$ns at 617.9049410393534 "$node_(505) setdest 5765 4324 18.0" 
$ns at 748.7580854284341 "$node_(505) setdest 9050 27508 14.0" 
$ns at 780.1812864454109 "$node_(505) setdest 9270 27513 7.0" 
$ns at 848.3636766018502 "$node_(505) setdest 1333 9206 15.0" 
$ns at 523.5188642058309 "$node_(506) setdest 100339 29539 2.0" 
$ns at 571.8337990130666 "$node_(506) setdest 50981 16400 17.0" 
$ns at 663.9079159699766 "$node_(506) setdest 111343 36615 17.0" 
$ns at 702.0367424617037 "$node_(506) setdest 16351 41119 13.0" 
$ns at 756.2244173866652 "$node_(506) setdest 9442 16372 5.0" 
$ns at 818.9458882841376 "$node_(506) setdest 121153 5757 1.0" 
$ns at 856.5860869906533 "$node_(506) setdest 33476 23600 5.0" 
$ns at 527.2176680636488 "$node_(507) setdest 64015 28132 1.0" 
$ns at 559.7268572996112 "$node_(507) setdest 129153 21707 6.0" 
$ns at 592.0567505021517 "$node_(507) setdest 22384 30949 17.0" 
$ns at 650.8145582039192 "$node_(507) setdest 125173 19761 18.0" 
$ns at 851.6091403427033 "$node_(507) setdest 67021 3511 18.0" 
$ns at 882.9645802181741 "$node_(507) setdest 33685 30657 17.0" 
$ns at 518.7211878187053 "$node_(508) setdest 49502 9740 19.0" 
$ns at 622.1091774919128 "$node_(508) setdest 43211 1041 13.0" 
$ns at 745.4814425038767 "$node_(508) setdest 29807 27205 18.0" 
$ns at 522.9052678638517 "$node_(509) setdest 73814 6846 8.0" 
$ns at 561.0592397586139 "$node_(509) setdest 3607 10674 3.0" 
$ns at 595.7653060842467 "$node_(509) setdest 85537 18047 10.0" 
$ns at 715.46640221609 "$node_(509) setdest 119622 24578 14.0" 
$ns at 773.9412207517646 "$node_(509) setdest 103203 42617 15.0" 
$ns at 836.4292087904264 "$node_(509) setdest 119997 32627 8.0" 
$ns at 875.8692646291868 "$node_(509) setdest 83138 10309 13.0" 
$ns at 537.0422516650481 "$node_(510) setdest 83575 32725 6.0" 
$ns at 613.5427466213044 "$node_(510) setdest 30972 13624 1.0" 
$ns at 648.3310492996997 "$node_(510) setdest 80393 42686 2.0" 
$ns at 693.9826466606178 "$node_(510) setdest 27862 32663 5.0" 
$ns at 757.1942210049224 "$node_(510) setdest 35074 29266 5.0" 
$ns at 826.4873486916815 "$node_(510) setdest 36217 22552 10.0" 
$ns at 894.6854169288484 "$node_(510) setdest 50535 37498 16.0" 
$ns at 567.2394310919989 "$node_(511) setdest 76231 40872 13.0" 
$ns at 695.0880888296679 "$node_(511) setdest 112390 21969 9.0" 
$ns at 757.9605104247273 "$node_(511) setdest 36184 40140 17.0" 
$ns at 873.6235932428447 "$node_(511) setdest 60797 11033 9.0" 
$ns at 540.3648157919171 "$node_(512) setdest 115815 43206 9.0" 
$ns at 578.750429752849 "$node_(512) setdest 44727 18517 3.0" 
$ns at 612.7356232610609 "$node_(512) setdest 53719 17366 9.0" 
$ns at 681.6447248210909 "$node_(512) setdest 25126 15824 18.0" 
$ns at 830.5555989918155 "$node_(512) setdest 102112 36953 14.0" 
$ns at 518.158784152632 "$node_(513) setdest 114969 10017 1.0" 
$ns at 548.2731831248637 "$node_(513) setdest 122399 41925 20.0" 
$ns at 676.5511843399397 "$node_(513) setdest 57561 1324 1.0" 
$ns at 712.1816437047802 "$node_(513) setdest 41841 26829 18.0" 
$ns at 613.9191143214241 "$node_(514) setdest 70296 43548 12.0" 
$ns at 655.1191075777405 "$node_(514) setdest 89302 6509 5.0" 
$ns at 702.2490681638258 "$node_(514) setdest 25532 29849 14.0" 
$ns at 758.625337184204 "$node_(514) setdest 88301 33379 4.0" 
$ns at 809.0375839619504 "$node_(514) setdest 48839 12841 12.0" 
$ns at 849.5642935189086 "$node_(514) setdest 15028 17544 11.0" 
$ns at 605.7513288974276 "$node_(515) setdest 95756 28882 11.0" 
$ns at 704.0085665814447 "$node_(515) setdest 27664 32138 1.0" 
$ns at 742.5780505097891 "$node_(515) setdest 114435 13824 2.0" 
$ns at 782.5708983449488 "$node_(515) setdest 52830 6675 14.0" 
$ns at 871.3891671884213 "$node_(515) setdest 83193 19908 3.0" 
$ns at 609.9517308237837 "$node_(516) setdest 40615 6712 11.0" 
$ns at 718.1941926300801 "$node_(516) setdest 103338 25152 17.0" 
$ns at 783.1944286324615 "$node_(516) setdest 31342 9814 7.0" 
$ns at 867.9638980516995 "$node_(516) setdest 83273 32705 1.0" 
$ns at 504.97052809295616 "$node_(517) setdest 4100 43752 6.0" 
$ns at 577.4514315135602 "$node_(517) setdest 85471 36876 12.0" 
$ns at 626.7742155937588 "$node_(517) setdest 36411 28374 11.0" 
$ns at 739.3978123714463 "$node_(517) setdest 89793 11938 16.0" 
$ns at 888.0414719998878 "$node_(517) setdest 100096 35231 2.0" 
$ns at 511.9159579431834 "$node_(518) setdest 112500 15151 20.0" 
$ns at 623.643522552926 "$node_(518) setdest 65053 2525 16.0" 
$ns at 760.5467292700378 "$node_(518) setdest 113771 22430 8.0" 
$ns at 856.524535600382 "$node_(518) setdest 52428 11655 13.0" 
$ns at 554.290850231927 "$node_(519) setdest 25623 41421 20.0" 
$ns at 626.3089415110777 "$node_(519) setdest 115427 13060 19.0" 
$ns at 790.057974136107 "$node_(519) setdest 121837 36700 18.0" 
$ns at 507.04759443765704 "$node_(520) setdest 123579 44429 16.0" 
$ns at 561.0784455321586 "$node_(520) setdest 60618 25591 1.0" 
$ns at 594.1455252690848 "$node_(520) setdest 54521 6944 13.0" 
$ns at 722.4296835339132 "$node_(520) setdest 56325 10291 16.0" 
$ns at 887.2534865142053 "$node_(520) setdest 60235 12295 12.0" 
$ns at 576.0012654515936 "$node_(521) setdest 89912 25511 16.0" 
$ns at 744.3659635650874 "$node_(521) setdest 97531 20474 16.0" 
$ns at 894.1016374377649 "$node_(521) setdest 100086 25836 12.0" 
$ns at 527.7012337350974 "$node_(522) setdest 79161 11662 10.0" 
$ns at 600.5277491412808 "$node_(522) setdest 21189 26895 9.0" 
$ns at 713.6604152211065 "$node_(522) setdest 33619 26304 3.0" 
$ns at 763.7591727002404 "$node_(522) setdest 125744 14989 7.0" 
$ns at 824.2622249971322 "$node_(522) setdest 46847 31528 12.0" 
$ns at 568.1658761287246 "$node_(523) setdest 16981 15029 13.0" 
$ns at 684.9751499425428 "$node_(523) setdest 114509 9804 17.0" 
$ns at 752.6018759424302 "$node_(523) setdest 83634 16285 16.0" 
$ns at 788.0796486081626 "$node_(523) setdest 79880 4546 15.0" 
$ns at 831.4378968435806 "$node_(523) setdest 73867 24906 12.0" 
$ns at 532.6072333301419 "$node_(524) setdest 38000 7138 15.0" 
$ns at 572.4332726606683 "$node_(524) setdest 109778 22594 10.0" 
$ns at 627.4466166799189 "$node_(524) setdest 46637 25152 19.0" 
$ns at 789.0809518776355 "$node_(524) setdest 11927 26260 6.0" 
$ns at 873.9178636370001 "$node_(524) setdest 104654 28396 10.0" 
$ns at 596.7363796246947 "$node_(525) setdest 34859 26024 3.0" 
$ns at 631.5583139601589 "$node_(525) setdest 18255 7904 8.0" 
$ns at 683.8514096346063 "$node_(525) setdest 107568 21428 1.0" 
$ns at 714.4890754723854 "$node_(525) setdest 116560 3224 9.0" 
$ns at 807.4805498042366 "$node_(525) setdest 115528 22504 16.0" 
$ns at 571.7396928607542 "$node_(526) setdest 106550 36326 13.0" 
$ns at 676.6998947720967 "$node_(526) setdest 94495 20163 13.0" 
$ns at 734.1445547179212 "$node_(526) setdest 4601 25495 15.0" 
$ns at 868.1523048647109 "$node_(526) setdest 6417 22267 11.0" 
$ns at 506.5803408893727 "$node_(527) setdest 128082 16171 6.0" 
$ns at 584.8015349044813 "$node_(527) setdest 22858 38766 1.0" 
$ns at 618.939781011142 "$node_(527) setdest 76026 926 17.0" 
$ns at 730.2796005954536 "$node_(527) setdest 63513 35851 19.0" 
$ns at 891.9959279130759 "$node_(527) setdest 97337 34262 12.0" 
$ns at 556.4642277743615 "$node_(528) setdest 24563 4206 9.0" 
$ns at 668.1814008648846 "$node_(528) setdest 52789 34944 16.0" 
$ns at 752.941119762844 "$node_(528) setdest 124825 22194 10.0" 
$ns at 819.2511303035989 "$node_(528) setdest 95605 26926 12.0" 
$ns at 851.6593370333362 "$node_(528) setdest 122485 26081 11.0" 
$ns at 512.9085242275869 "$node_(529) setdest 8007 30518 11.0" 
$ns at 605.7790194964525 "$node_(529) setdest 54720 33968 10.0" 
$ns at 730.6698157195386 "$node_(529) setdest 18945 35328 13.0" 
$ns at 808.7532854752592 "$node_(529) setdest 31351 41186 12.0" 
$ns at 882.1422974639216 "$node_(529) setdest 72403 41021 11.0" 
$ns at 505.8099034013904 "$node_(530) setdest 79322 7710 18.0" 
$ns at 625.835253846037 "$node_(530) setdest 11557 43572 17.0" 
$ns at 763.4978282114731 "$node_(530) setdest 15256 17697 13.0" 
$ns at 825.4420761068642 "$node_(530) setdest 120142 29992 19.0" 
$ns at 515.8136331770249 "$node_(531) setdest 79309 526 11.0" 
$ns at 609.3744600114107 "$node_(531) setdest 24885 41072 15.0" 
$ns at 718.1794311131885 "$node_(531) setdest 111011 17093 11.0" 
$ns at 752.9983364304157 "$node_(531) setdest 28372 43900 11.0" 
$ns at 878.7942421111785 "$node_(531) setdest 81689 29266 15.0" 
$ns at 579.4918573124518 "$node_(532) setdest 29191 27688 7.0" 
$ns at 672.7158182656927 "$node_(532) setdest 100967 6411 18.0" 
$ns at 818.3844591389524 "$node_(532) setdest 86192 19416 2.0" 
$ns at 859.3197646933635 "$node_(532) setdest 79421 834 9.0" 
$ns at 555.2978128376759 "$node_(533) setdest 8776 33187 19.0" 
$ns at 668.2390573025724 "$node_(533) setdest 21598 10475 17.0" 
$ns at 805.7421322018533 "$node_(533) setdest 68904 24311 13.0" 
$ns at 587.3601338377118 "$node_(534) setdest 13970 41444 14.0" 
$ns at 624.0389145872277 "$node_(534) setdest 2473 6657 8.0" 
$ns at 699.865382851961 "$node_(534) setdest 81162 8507 1.0" 
$ns at 739.006395658675 "$node_(534) setdest 81161 13434 1.0" 
$ns at 778.3096325673381 "$node_(534) setdest 76924 18976 10.0" 
$ns at 872.8808490419838 "$node_(534) setdest 48044 38840 1.0" 
$ns at 525.2500063410122 "$node_(535) setdest 17419 24906 1.0" 
$ns at 555.6182377441468 "$node_(535) setdest 5136 699 1.0" 
$ns at 589.5023386142432 "$node_(535) setdest 11066 30095 3.0" 
$ns at 643.8999098416305 "$node_(535) setdest 113685 27516 16.0" 
$ns at 811.6662447142969 "$node_(535) setdest 101248 23899 15.0" 
$ns at 513.2609053366136 "$node_(536) setdest 78284 17392 5.0" 
$ns at 552.406207388016 "$node_(536) setdest 102850 19687 15.0" 
$ns at 656.755367041397 "$node_(536) setdest 62442 14144 3.0" 
$ns at 714.88395897695 "$node_(536) setdest 97625 27314 5.0" 
$ns at 753.3743109774946 "$node_(536) setdest 44301 15467 15.0" 
$ns at 875.1311534736307 "$node_(536) setdest 37228 22462 5.0" 
$ns at 589.6260304332764 "$node_(537) setdest 17732 40232 7.0" 
$ns at 627.7270597853731 "$node_(537) setdest 84554 23582 9.0" 
$ns at 683.8230672735027 "$node_(537) setdest 3089 1132 16.0" 
$ns at 738.2998579276208 "$node_(537) setdest 1002 38844 3.0" 
$ns at 787.1268571399851 "$node_(537) setdest 108803 30298 19.0" 
$ns at 841.1456651811271 "$node_(537) setdest 67884 43480 6.0" 
$ns at 525.4475095021807 "$node_(538) setdest 8338 32076 14.0" 
$ns at 634.3377805381635 "$node_(538) setdest 109964 2562 7.0" 
$ns at 704.0028406007867 "$node_(538) setdest 15936 22025 13.0" 
$ns at 781.8381940325254 "$node_(538) setdest 88902 6307 6.0" 
$ns at 826.0995805859379 "$node_(538) setdest 133842 37150 17.0" 
$ns at 875.0907981595032 "$node_(538) setdest 3870 1966 1.0" 
$ns at 553.8475720334014 "$node_(539) setdest 100909 13329 11.0" 
$ns at 687.4745110065741 "$node_(539) setdest 38066 4151 16.0" 
$ns at 876.3354043444397 "$node_(539) setdest 95549 1159 10.0" 
$ns at 662.8706883404279 "$node_(540) setdest 8346 7642 8.0" 
$ns at 745.1876127346027 "$node_(540) setdest 29906 34382 14.0" 
$ns at 849.0932756254091 "$node_(540) setdest 58547 43839 5.0" 
$ns at 895.1629417036971 "$node_(540) setdest 54720 14342 18.0" 
$ns at 552.23049636419 "$node_(541) setdest 25350 42388 18.0" 
$ns at 731.6339233454316 "$node_(541) setdest 17041 19829 3.0" 
$ns at 775.2628159581606 "$node_(541) setdest 110619 8366 19.0" 
$ns at 601.6842564912562 "$node_(542) setdest 126995 1500 6.0" 
$ns at 677.1150308431074 "$node_(542) setdest 98013 6718 1.0" 
$ns at 709.0016646014818 "$node_(542) setdest 117123 40955 6.0" 
$ns at 790.764854146795 "$node_(542) setdest 80322 42361 1.0" 
$ns at 826.0774480071664 "$node_(542) setdest 92490 26500 12.0" 
$ns at 504.09262885397163 "$node_(543) setdest 73330 17960 6.0" 
$ns at 566.6804397148923 "$node_(543) setdest 116256 42035 14.0" 
$ns at 610.1834839075602 "$node_(543) setdest 32154 10458 1.0" 
$ns at 648.3339790048537 "$node_(543) setdest 58668 5999 2.0" 
$ns at 688.2747766228068 "$node_(543) setdest 85882 38693 16.0" 
$ns at 831.8280409323133 "$node_(543) setdest 123892 12230 1.0" 
$ns at 871.4498761042643 "$node_(543) setdest 47977 16979 8.0" 
$ns at 575.8289351666748 "$node_(544) setdest 57604 21971 5.0" 
$ns at 625.84948557435 "$node_(544) setdest 94966 27465 3.0" 
$ns at 673.0931703928102 "$node_(544) setdest 33679 9100 1.0" 
$ns at 703.3003795799181 "$node_(544) setdest 19118 213 17.0" 
$ns at 869.9678420761047 "$node_(544) setdest 91482 41725 2.0" 
$ns at 504.0405414388254 "$node_(545) setdest 125544 10008 8.0" 
$ns at 540.1614576221583 "$node_(545) setdest 77585 31684 9.0" 
$ns at 598.2622709054501 "$node_(545) setdest 4880 32089 8.0" 
$ns at 672.8625154530165 "$node_(545) setdest 131667 40937 8.0" 
$ns at 726.469857159057 "$node_(545) setdest 62954 32554 11.0" 
$ns at 770.2125035111585 "$node_(545) setdest 23252 38872 8.0" 
$ns at 826.775304217979 "$node_(545) setdest 104517 40679 3.0" 
$ns at 862.3595460256532 "$node_(545) setdest 70603 22693 14.0" 
$ns at 633.0211442462945 "$node_(546) setdest 119888 25613 2.0" 
$ns at 674.3652105464918 "$node_(546) setdest 29934 9188 15.0" 
$ns at 789.069075847254 "$node_(546) setdest 118691 35120 9.0" 
$ns at 841.6534919917171 "$node_(546) setdest 67826 22622 11.0" 
$ns at 591.5930143099547 "$node_(547) setdest 130843 36118 13.0" 
$ns at 686.8646855686707 "$node_(547) setdest 105065 40778 15.0" 
$ns at 794.4116397533735 "$node_(547) setdest 138 18213 4.0" 
$ns at 831.5475599760605 "$node_(547) setdest 33047 34870 5.0" 
$ns at 897.2962428937627 "$node_(547) setdest 91937 40257 12.0" 
$ns at 510.10857911326417 "$node_(548) setdest 61721 27571 6.0" 
$ns at 568.6445100967197 "$node_(548) setdest 19146 10753 16.0" 
$ns at 631.4581660625354 "$node_(548) setdest 5401 23965 13.0" 
$ns at 672.967660898619 "$node_(548) setdest 12394 33468 12.0" 
$ns at 754.0599810329812 "$node_(548) setdest 29297 31394 4.0" 
$ns at 791.1711776795427 "$node_(548) setdest 19291 22327 2.0" 
$ns at 840.0366933338593 "$node_(548) setdest 113809 7342 15.0" 
$ns at 871.8552110936408 "$node_(548) setdest 122746 9574 1.0" 
$ns at 516.7149661802284 "$node_(549) setdest 51892 25659 10.0" 
$ns at 637.2398911089789 "$node_(549) setdest 67712 41040 4.0" 
$ns at 690.6266202823052 "$node_(549) setdest 19206 823 1.0" 
$ns at 720.6950143735903 "$node_(549) setdest 104511 44227 17.0" 
$ns at 501.2423909344682 "$node_(550) setdest 81425 25608 6.0" 
$ns at 571.8419935315503 "$node_(550) setdest 17632 29069 9.0" 
$ns at 673.3759003019607 "$node_(550) setdest 24844 31308 2.0" 
$ns at 718.9218010975411 "$node_(550) setdest 54919 33746 5.0" 
$ns at 758.5446395769364 "$node_(550) setdest 118872 43361 11.0" 
$ns at 845.9987010888079 "$node_(550) setdest 117196 29974 4.0" 
$ns at 889.5818274813281 "$node_(550) setdest 93542 36775 19.0" 
$ns at 572.7578897304013 "$node_(551) setdest 34530 39576 7.0" 
$ns at 659.9845474548108 "$node_(551) setdest 105633 40382 13.0" 
$ns at 807.9157401243565 "$node_(551) setdest 101760 42450 4.0" 
$ns at 852.2082495161213 "$node_(551) setdest 60854 42288 17.0" 
$ns at 895.362348337596 "$node_(551) setdest 128971 32049 14.0" 
$ns at 596.4190711233849 "$node_(552) setdest 90014 24990 16.0" 
$ns at 642.8217996274985 "$node_(552) setdest 80871 34608 19.0" 
$ns at 808.5264453068123 "$node_(552) setdest 91657 26999 17.0" 
$ns at 872.778445724385 "$node_(552) setdest 49283 13634 12.0" 
$ns at 592.7883034892673 "$node_(553) setdest 118163 14412 19.0" 
$ns at 736.4046368789343 "$node_(553) setdest 92582 41628 14.0" 
$ns at 895.4206214461967 "$node_(553) setdest 96318 26853 6.0" 
$ns at 531.7994022173393 "$node_(554) setdest 41926 37275 15.0" 
$ns at 686.071171267574 "$node_(554) setdest 38495 1616 3.0" 
$ns at 721.7067001118228 "$node_(554) setdest 36895 35770 12.0" 
$ns at 794.0644564084924 "$node_(554) setdest 112600 4571 11.0" 
$ns at 859.2944200673105 "$node_(554) setdest 128115 5225 19.0" 
$ns at 520.5466657774451 "$node_(555) setdest 83933 34029 4.0" 
$ns at 579.3699277518823 "$node_(555) setdest 107990 41391 19.0" 
$ns at 796.1360925261883 "$node_(555) setdest 1127 30665 6.0" 
$ns at 884.295627944653 "$node_(555) setdest 122139 4719 1.0" 
$ns at 523.7687200819717 "$node_(556) setdest 3794 25814 8.0" 
$ns at 614.0878523979092 "$node_(556) setdest 64962 11943 6.0" 
$ns at 687.6385320480014 "$node_(556) setdest 82543 39212 18.0" 
$ns at 885.4917546620646 "$node_(556) setdest 15631 16316 1.0" 
$ns at 591.2870178770811 "$node_(557) setdest 23686 23378 18.0" 
$ns at 741.1278581517017 "$node_(557) setdest 56439 4395 14.0" 
$ns at 827.2909516860681 "$node_(557) setdest 54525 27757 4.0" 
$ns at 891.099312658508 "$node_(557) setdest 33640 25027 16.0" 
$ns at 548.2383002481924 "$node_(558) setdest 46766 6892 2.0" 
$ns at 590.29677555396 "$node_(558) setdest 118434 33156 1.0" 
$ns at 628.4658865727389 "$node_(558) setdest 74202 39774 1.0" 
$ns at 659.4251052560159 "$node_(558) setdest 13179 42787 13.0" 
$ns at 792.2117386567603 "$node_(558) setdest 67360 43878 6.0" 
$ns at 829.0088494935667 "$node_(558) setdest 84465 5220 2.0" 
$ns at 862.7529601752356 "$node_(558) setdest 4397 35952 14.0" 
$ns at 529.4016918669355 "$node_(559) setdest 3149 28883 7.0" 
$ns at 628.5402791451769 "$node_(559) setdest 23252 36627 14.0" 
$ns at 733.7327057809573 "$node_(559) setdest 53682 40262 17.0" 
$ns at 795.7875529876156 "$node_(559) setdest 11499 3186 1.0" 
$ns at 829.429151804502 "$node_(559) setdest 77121 8817 18.0" 
$ns at 897.9863414605145 "$node_(559) setdest 23944 1005 14.0" 
$ns at 647.6446671002843 "$node_(560) setdest 120714 34401 9.0" 
$ns at 685.8354039647862 "$node_(560) setdest 41207 16483 5.0" 
$ns at 755.7094439818628 "$node_(560) setdest 39047 33554 7.0" 
$ns at 805.3779146515603 "$node_(560) setdest 17251 23877 2.0" 
$ns at 846.1687805411977 "$node_(560) setdest 66814 16220 13.0" 
$ns at 888.9732920402597 "$node_(560) setdest 84261 24467 1.0" 
$ns at 532.3561728677545 "$node_(561) setdest 46887 26006 14.0" 
$ns at 583.0679633412755 "$node_(561) setdest 97765 40868 20.0" 
$ns at 633.7046426509132 "$node_(561) setdest 92326 23298 14.0" 
$ns at 719.8442016051222 "$node_(561) setdest 129794 22584 10.0" 
$ns at 774.2174548110992 "$node_(561) setdest 5552 36433 1.0" 
$ns at 806.764959909505 "$node_(561) setdest 114961 37714 12.0" 
$ns at 880.0878765509068 "$node_(561) setdest 122169 18951 9.0" 
$ns at 503.8126978001886 "$node_(562) setdest 63360 5013 12.0" 
$ns at 604.5531732765476 "$node_(562) setdest 123083 33408 7.0" 
$ns at 653.7986159708726 "$node_(562) setdest 39817 30676 1.0" 
$ns at 684.9053963032462 "$node_(562) setdest 117288 9709 3.0" 
$ns at 730.1976134547162 "$node_(562) setdest 99622 4098 10.0" 
$ns at 823.781409826864 "$node_(562) setdest 15363 11888 7.0" 
$ns at 580.7493301698374 "$node_(563) setdest 98302 22255 4.0" 
$ns at 635.5718748970443 "$node_(563) setdest 59297 34450 11.0" 
$ns at 752.7060878190266 "$node_(563) setdest 5500 31537 4.0" 
$ns at 792.6262247809302 "$node_(563) setdest 12077 16667 5.0" 
$ns at 863.4628309547754 "$node_(563) setdest 21307 23432 11.0" 
$ns at 899.512822956843 "$node_(563) setdest 122679 38350 16.0" 
$ns at 559.4687624118917 "$node_(564) setdest 63370 15670 14.0" 
$ns at 641.135637027452 "$node_(564) setdest 56279 970 8.0" 
$ns at 747.5542955828037 "$node_(564) setdest 74632 8540 5.0" 
$ns at 823.0912397989152 "$node_(564) setdest 131878 42606 17.0" 
$ns at 876.4011318553773 "$node_(564) setdest 133086 9045 6.0" 
$ns at 524.9357970996336 "$node_(565) setdest 5031 34389 19.0" 
$ns at 598.3054415545467 "$node_(565) setdest 70293 30094 15.0" 
$ns at 718.5315914610585 "$node_(565) setdest 100984 32781 8.0" 
$ns at 769.2346445344958 "$node_(565) setdest 74169 5820 14.0" 
$ns at 888.0492469025063 "$node_(565) setdest 30922 35929 12.0" 
$ns at 502.7704095661508 "$node_(566) setdest 83665 7357 11.0" 
$ns at 629.4627356290454 "$node_(566) setdest 29972 32497 17.0" 
$ns at 732.4968953008294 "$node_(566) setdest 117093 15527 10.0" 
$ns at 830.0789339607052 "$node_(566) setdest 47551 40861 16.0" 
$ns at 613.4693355148975 "$node_(567) setdest 46284 41530 10.0" 
$ns at 738.2009166069655 "$node_(567) setdest 12442 18210 15.0" 
$ns at 513.816482261986 "$node_(568) setdest 115347 41891 5.0" 
$ns at 548.7910280851077 "$node_(568) setdest 53301 42529 14.0" 
$ns at 646.3808936387949 "$node_(568) setdest 118089 15122 8.0" 
$ns at 695.5006802987673 "$node_(568) setdest 87698 35823 7.0" 
$ns at 732.8879383415562 "$node_(568) setdest 39424 26677 2.0" 
$ns at 772.1788433719491 "$node_(568) setdest 75279 23417 1.0" 
$ns at 812.1003907559161 "$node_(568) setdest 64901 25337 7.0" 
$ns at 890.6324700408259 "$node_(568) setdest 31370 7564 20.0" 
$ns at 530.0651043167878 "$node_(569) setdest 114096 6745 2.0" 
$ns at 579.5942565765931 "$node_(569) setdest 2492 11796 10.0" 
$ns at 620.1441073138875 "$node_(569) setdest 47212 4907 5.0" 
$ns at 667.6150461945281 "$node_(569) setdest 84921 3077 18.0" 
$ns at 808.108393942377 "$node_(569) setdest 121964 28019 7.0" 
$ns at 896.3949200065663 "$node_(569) setdest 43813 12146 17.0" 
$ns at 604.1646488885641 "$node_(570) setdest 101953 13908 19.0" 
$ns at 729.6793184883388 "$node_(570) setdest 25837 16028 18.0" 
$ns at 612.3579070819018 "$node_(571) setdest 19429 29704 18.0" 
$ns at 812.5507137754514 "$node_(571) setdest 118395 39330 11.0" 
$ns at 625.4056280558243 "$node_(572) setdest 112152 2018 1.0" 
$ns at 656.1900357079214 "$node_(572) setdest 121431 25275 7.0" 
$ns at 740.1938631022085 "$node_(572) setdest 112039 17069 20.0" 
$ns at 844.7746307067941 "$node_(572) setdest 95015 17346 7.0" 
$ns at 529.5489789547612 "$node_(573) setdest 78291 11632 15.0" 
$ns at 684.9743606947445 "$node_(573) setdest 132098 25767 11.0" 
$ns at 747.2731286755175 "$node_(573) setdest 2741 41643 9.0" 
$ns at 852.1665564728245 "$node_(573) setdest 103183 2523 2.0" 
$ns at 894.3910763155034 "$node_(573) setdest 52719 14579 9.0" 
$ns at 522.6127102041992 "$node_(574) setdest 95642 26197 15.0" 
$ns at 646.4456661663917 "$node_(574) setdest 51182 14391 14.0" 
$ns at 812.9671895274129 "$node_(574) setdest 117546 22765 4.0" 
$ns at 869.1624327033082 "$node_(574) setdest 122478 26329 11.0" 
$ns at 558.0709764776861 "$node_(575) setdest 116244 107 1.0" 
$ns at 596.4665607579838 "$node_(575) setdest 12386 7996 20.0" 
$ns at 712.8605236769573 "$node_(575) setdest 72624 43081 4.0" 
$ns at 747.9891333839465 "$node_(575) setdest 33307 41524 2.0" 
$ns at 779.9568664870615 "$node_(575) setdest 123070 41155 14.0" 
$ns at 631.9583055168873 "$node_(576) setdest 55017 22010 18.0" 
$ns at 679.5446717089992 "$node_(576) setdest 98724 5416 1.0" 
$ns at 718.9698523006626 "$node_(576) setdest 18372 1373 10.0" 
$ns at 760.7005971809441 "$node_(576) setdest 107771 29925 6.0" 
$ns at 806.2074663032931 "$node_(576) setdest 11334 19176 6.0" 
$ns at 862.8682669901722 "$node_(576) setdest 68387 5607 17.0" 
$ns at 502.3543927091047 "$node_(577) setdest 110033 39737 1.0" 
$ns at 533.2244531800866 "$node_(577) setdest 45821 24746 4.0" 
$ns at 601.2793364089621 "$node_(577) setdest 24608 18954 15.0" 
$ns at 683.7507091930123 "$node_(577) setdest 91225 35875 4.0" 
$ns at 750.6129605520135 "$node_(577) setdest 31926 39684 13.0" 
$ns at 805.260673549936 "$node_(577) setdest 124507 19325 19.0" 
$ns at 522.4165677543347 "$node_(578) setdest 59110 38464 1.0" 
$ns at 556.7277197084802 "$node_(578) setdest 93564 17921 11.0" 
$ns at 616.6659456086276 "$node_(578) setdest 52661 9047 2.0" 
$ns at 649.9478644481811 "$node_(578) setdest 117592 2383 6.0" 
$ns at 703.7874268892358 "$node_(578) setdest 2702 32761 17.0" 
$ns at 830.0260279042798 "$node_(578) setdest 2359 12070 20.0" 
$ns at 520.9913034121133 "$node_(579) setdest 26461 35845 16.0" 
$ns at 606.7125339618458 "$node_(579) setdest 91228 41360 19.0" 
$ns at 740.9488935012997 "$node_(579) setdest 26674 31675 17.0" 
$ns at 857.2894460114779 "$node_(579) setdest 76918 20923 14.0" 
$ns at 511.5114612677683 "$node_(580) setdest 48943 44210 7.0" 
$ns at 595.2687033566372 "$node_(580) setdest 42384 11578 13.0" 
$ns at 744.5171561233783 "$node_(580) setdest 41594 19687 20.0" 
$ns at 896.2411124658396 "$node_(580) setdest 91015 40365 17.0" 
$ns at 511.27813535975554 "$node_(581) setdest 39850 5840 16.0" 
$ns at 586.4993541086595 "$node_(581) setdest 33403 13447 9.0" 
$ns at 655.7892234221063 "$node_(581) setdest 39758 17163 5.0" 
$ns at 724.5440792587962 "$node_(581) setdest 129122 29796 16.0" 
$ns at 812.9089860829151 "$node_(581) setdest 1562 10623 8.0" 
$ns at 877.5336359070443 "$node_(581) setdest 122678 10204 18.0" 
$ns at 519.5313230428405 "$node_(582) setdest 5369 44529 18.0" 
$ns at 693.3275443707171 "$node_(582) setdest 38044 43481 4.0" 
$ns at 744.9952704885663 "$node_(582) setdest 80376 15243 1.0" 
$ns at 776.0539320890612 "$node_(582) setdest 52645 31348 13.0" 
$ns at 872.6333998914498 "$node_(582) setdest 20352 35998 7.0" 
$ns at 606.2016135380017 "$node_(583) setdest 113376 30325 10.0" 
$ns at 689.0898586257698 "$node_(583) setdest 118017 5783 3.0" 
$ns at 738.9454507930873 "$node_(583) setdest 54212 30430 16.0" 
$ns at 861.9776773775794 "$node_(583) setdest 44251 5266 5.0" 
$ns at 579.3428411362756 "$node_(584) setdest 81717 4082 17.0" 
$ns at 614.2934179978361 "$node_(584) setdest 49277 3616 14.0" 
$ns at 719.7114067385472 "$node_(584) setdest 68410 43804 16.0" 
$ns at 756.6165174570054 "$node_(584) setdest 103833 23173 2.0" 
$ns at 786.8931375325417 "$node_(584) setdest 62499 25612 3.0" 
$ns at 846.523080529889 "$node_(584) setdest 2857 11286 3.0" 
$ns at 515.2503819625298 "$node_(585) setdest 114251 25531 16.0" 
$ns at 550.421704491785 "$node_(585) setdest 107530 34346 1.0" 
$ns at 584.3913760430062 "$node_(585) setdest 43012 24931 1.0" 
$ns at 619.3523333963204 "$node_(585) setdest 9234 31978 2.0" 
$ns at 651.1665309640085 "$node_(585) setdest 95631 15336 7.0" 
$ns at 709.6055611117602 "$node_(585) setdest 58318 20392 3.0" 
$ns at 750.1624722141078 "$node_(585) setdest 2949 25174 19.0" 
$ns at 810.533670407735 "$node_(585) setdest 7786 38021 4.0" 
$ns at 875.2671028127643 "$node_(585) setdest 69682 27771 3.0" 
$ns at 532.5861924538726 "$node_(586) setdest 122709 28456 16.0" 
$ns at 709.7598692884128 "$node_(586) setdest 54220 810 10.0" 
$ns at 804.7756745124093 "$node_(586) setdest 18162 569 18.0" 
$ns at 504.679559156316 "$node_(587) setdest 122662 43606 10.0" 
$ns at 557.7025105074518 "$node_(587) setdest 129988 18682 2.0" 
$ns at 597.0272764827232 "$node_(587) setdest 76694 17912 8.0" 
$ns at 662.8225650755414 "$node_(587) setdest 110567 26794 2.0" 
$ns at 697.0479137264704 "$node_(587) setdest 53221 26221 1.0" 
$ns at 735.0752961866052 "$node_(587) setdest 56819 16851 4.0" 
$ns at 793.5884859942684 "$node_(587) setdest 91141 42004 7.0" 
$ns at 846.7335219596617 "$node_(587) setdest 73807 20720 13.0" 
$ns at 502.5560516677061 "$node_(588) setdest 103619 8673 18.0" 
$ns at 683.290138312636 "$node_(588) setdest 22232 29024 14.0" 
$ns at 753.8875597713941 "$node_(588) setdest 86632 35638 18.0" 
$ns at 896.9194606944823 "$node_(588) setdest 97346 33902 17.0" 
$ns at 506.3004514137077 "$node_(589) setdest 123869 43093 13.0" 
$ns at 539.2557792202904 "$node_(589) setdest 83511 43441 5.0" 
$ns at 617.7163965441117 "$node_(589) setdest 7885 42984 5.0" 
$ns at 689.7400120315722 "$node_(589) setdest 66057 12774 11.0" 
$ns at 812.3158391161321 "$node_(589) setdest 97178 15371 3.0" 
$ns at 871.8234776472739 "$node_(589) setdest 5873 689 7.0" 
$ns at 558.7562879056694 "$node_(590) setdest 54864 29686 1.0" 
$ns at 598.4778214852856 "$node_(590) setdest 128973 36798 8.0" 
$ns at 641.4660198459276 "$node_(590) setdest 133098 16664 12.0" 
$ns at 770.8331171192526 "$node_(590) setdest 12394 12538 20.0" 
$ns at 587.6202609761671 "$node_(591) setdest 15107 24143 16.0" 
$ns at 704.355662081439 "$node_(591) setdest 57664 4323 18.0" 
$ns at 753.6274340658916 "$node_(591) setdest 24077 20360 3.0" 
$ns at 796.4852265722155 "$node_(591) setdest 109262 14340 15.0" 
$ns at 559.5310149344543 "$node_(592) setdest 128731 11329 13.0" 
$ns at 686.9101970015886 "$node_(592) setdest 46732 32774 12.0" 
$ns at 804.4916748396414 "$node_(592) setdest 130755 23812 17.0" 
$ns at 562.8364328140941 "$node_(593) setdest 36792 28277 4.0" 
$ns at 607.8112028369849 "$node_(593) setdest 107747 29115 6.0" 
$ns at 672.649317997968 "$node_(593) setdest 79475 24134 17.0" 
$ns at 814.3781308108494 "$node_(593) setdest 38457 24093 1.0" 
$ns at 850.1596108544659 "$node_(593) setdest 31183 18617 15.0" 
$ns at 887.0936982839888 "$node_(593) setdest 105602 10628 2.0" 
$ns at 597.7690872207017 "$node_(594) setdest 119433 36047 2.0" 
$ns at 641.551055910211 "$node_(594) setdest 125702 1998 10.0" 
$ns at 691.0598378614995 "$node_(594) setdest 109894 12781 9.0" 
$ns at 727.5254060627783 "$node_(594) setdest 51404 15270 12.0" 
$ns at 794.3631407342804 "$node_(594) setdest 27781 40076 17.0" 
$ns at 677.1413692602874 "$node_(595) setdest 71146 35712 10.0" 
$ns at 708.3504869470497 "$node_(595) setdest 96843 5880 9.0" 
$ns at 754.710377067755 "$node_(595) setdest 32930 42288 8.0" 
$ns at 840.4775151638038 "$node_(595) setdest 20441 35992 20.0" 
$ns at 897.2038029626676 "$node_(595) setdest 22214 38880 1.0" 
$ns at 565.9632926803814 "$node_(596) setdest 133381 32912 9.0" 
$ns at 626.2868317791252 "$node_(596) setdest 22135 19061 18.0" 
$ns at 796.8687963105789 "$node_(596) setdest 102892 585 9.0" 
$ns at 827.0015294612117 "$node_(596) setdest 5847 864 1.0" 
$ns at 865.7362114816821 "$node_(596) setdest 8705 1340 3.0" 
$ns at 601.0111696250918 "$node_(597) setdest 71279 21143 5.0" 
$ns at 675.8020583243992 "$node_(597) setdest 127034 22558 9.0" 
$ns at 735.9971721447841 "$node_(597) setdest 102960 32473 7.0" 
$ns at 786.7661585136176 "$node_(597) setdest 83970 28932 17.0" 
$ns at 571.6975890834179 "$node_(598) setdest 33441 34761 7.0" 
$ns at 642.5557895817674 "$node_(598) setdest 41304 15504 9.0" 
$ns at 702.5543128422389 "$node_(598) setdest 58965 19271 10.0" 
$ns at 782.6609107590209 "$node_(598) setdest 28159 29948 3.0" 
$ns at 819.4600404306623 "$node_(598) setdest 14114 3786 16.0" 
$ns at 554.1375809914579 "$node_(599) setdest 82741 34698 7.0" 
$ns at 645.889668710291 "$node_(599) setdest 93652 27942 14.0" 
$ns at 751.2269570292931 "$node_(599) setdest 96187 35897 7.0" 
$ns at 835.0931843631814 "$node_(599) setdest 105186 13419 5.0" 
$ns at 648.270037607944 "$node_(600) setdest 53740 18804 18.0" 
$ns at 753.3029396449385 "$node_(600) setdest 82441 44534 11.0" 
$ns at 848.0419409790755 "$node_(600) setdest 43773 16235 10.0" 
$ns at 678.2278903356499 "$node_(601) setdest 8478 8360 12.0" 
$ns at 814.3218343016156 "$node_(601) setdest 43519 5066 7.0" 
$ns at 894.3985194265813 "$node_(601) setdest 60181 20461 1.0" 
$ns at 641.3949139655967 "$node_(602) setdest 8712 30136 1.0" 
$ns at 679.3107401267087 "$node_(602) setdest 84758 39957 18.0" 
$ns at 720.7451119061805 "$node_(602) setdest 47931 27360 18.0" 
$ns at 707.8898619541402 "$node_(603) setdest 18190 33999 9.0" 
$ns at 815.704944873137 "$node_(603) setdest 12649 4326 10.0" 
$ns at 730.7177567432548 "$node_(604) setdest 13494 18220 7.0" 
$ns at 811.9440621844998 "$node_(604) setdest 100953 1264 12.0" 
$ns at 697.0739844419144 "$node_(605) setdest 13256 12370 17.0" 
$ns at 834.0146209520532 "$node_(605) setdest 14725 15833 4.0" 
$ns at 872.1053089113195 "$node_(605) setdest 60900 12814 8.0" 
$ns at 642.1656479483571 "$node_(606) setdest 22399 7825 14.0" 
$ns at 799.9299754845729 "$node_(606) setdest 122955 44293 16.0" 
$ns at 703.093188448972 "$node_(607) setdest 23865 26197 1.0" 
$ns at 737.7199892648845 "$node_(607) setdest 130751 18045 10.0" 
$ns at 841.2363519938081 "$node_(607) setdest 57775 18933 14.0" 
$ns at 677.5489225493711 "$node_(608) setdest 15078 19587 2.0" 
$ns at 725.1951623253553 "$node_(608) setdest 113464 37841 10.0" 
$ns at 823.5659304038222 "$node_(608) setdest 77223 9058 14.0" 
$ns at 880.6648795627531 "$node_(608) setdest 74778 43255 9.0" 
$ns at 679.6543662153935 "$node_(609) setdest 36484 38993 12.0" 
$ns at 743.2413394686952 "$node_(609) setdest 5803 14411 3.0" 
$ns at 777.9261586115908 "$node_(609) setdest 43135 42067 19.0" 
$ns at 899.6435294796511 "$node_(609) setdest 28689 14857 3.0" 
$ns at 760.0115780846772 "$node_(610) setdest 51346 14811 19.0" 
$ns at 624.3560152633466 "$node_(611) setdest 43271 39425 8.0" 
$ns at 705.7888827981736 "$node_(611) setdest 52357 32047 1.0" 
$ns at 741.5680897014774 "$node_(611) setdest 78618 13243 9.0" 
$ns at 783.5263087230529 "$node_(611) setdest 31387 7223 9.0" 
$ns at 824.3986280609523 "$node_(611) setdest 99993 26728 20.0" 
$ns at 876.6687721010384 "$node_(611) setdest 6331 14284 4.0" 
$ns at 670.2208456008714 "$node_(612) setdest 129733 23308 7.0" 
$ns at 755.6861424220084 "$node_(612) setdest 15806 17828 18.0" 
$ns at 605.9794194108583 "$node_(613) setdest 65201 10133 9.0" 
$ns at 716.8008386456085 "$node_(613) setdest 888 36743 1.0" 
$ns at 749.809758420901 "$node_(613) setdest 44445 17643 10.0" 
$ns at 866.0755560220389 "$node_(613) setdest 32059 20716 5.0" 
$ns at 618.5699000240485 "$node_(614) setdest 130128 7964 16.0" 
$ns at 771.5058139004935 "$node_(614) setdest 57083 32885 9.0" 
$ns at 875.0370713716737 "$node_(614) setdest 101476 29470 1.0" 
$ns at 615.2180249820719 "$node_(615) setdest 107158 26025 4.0" 
$ns at 645.7213587234082 "$node_(615) setdest 46425 10203 1.0" 
$ns at 680.407901473308 "$node_(615) setdest 43391 37695 11.0" 
$ns at 711.4901274116338 "$node_(615) setdest 42207 42732 18.0" 
$ns at 850.1254740883506 "$node_(615) setdest 57068 43547 2.0" 
$ns at 887.2178088279136 "$node_(615) setdest 64369 17708 2.0" 
$ns at 681.9885591147763 "$node_(616) setdest 116882 37014 1.0" 
$ns at 717.791426527176 "$node_(616) setdest 60123 27322 1.0" 
$ns at 750.628207237678 "$node_(616) setdest 42216 11958 19.0" 
$ns at 615.4257656353695 "$node_(617) setdest 130501 1874 14.0" 
$ns at 690.7779340828472 "$node_(617) setdest 73423 36722 12.0" 
$ns at 779.1975464777768 "$node_(617) setdest 44636 20074 13.0" 
$ns at 846.1829989866728 "$node_(617) setdest 99728 40081 5.0" 
$ns at 889.0753728327895 "$node_(617) setdest 34802 4710 3.0" 
$ns at 602.0234761390134 "$node_(618) setdest 31763 11282 6.0" 
$ns at 635.3007315825998 "$node_(618) setdest 130162 26914 16.0" 
$ns at 737.89289572726 "$node_(618) setdest 44491 1120 4.0" 
$ns at 795.9192827938932 "$node_(618) setdest 40698 6675 15.0" 
$ns at 601.610609799644 "$node_(619) setdest 30003 31923 13.0" 
$ns at 724.8156306626083 "$node_(619) setdest 89724 35073 11.0" 
$ns at 806.529098339302 "$node_(619) setdest 16764 41922 1.0" 
$ns at 841.6614416424333 "$node_(619) setdest 27365 14082 6.0" 
$ns at 632.606344457441 "$node_(620) setdest 63225 22312 9.0" 
$ns at 745.9989701249399 "$node_(620) setdest 49212 43915 11.0" 
$ns at 846.4197956479935 "$node_(620) setdest 75100 26855 8.0" 
$ns at 883.9746811014207 "$node_(620) setdest 9099 26515 2.0" 
$ns at 659.078257622527 "$node_(621) setdest 26414 23346 8.0" 
$ns at 753.1148623954547 "$node_(621) setdest 60668 19372 5.0" 
$ns at 810.1495735305184 "$node_(621) setdest 49105 16266 17.0" 
$ns at 752.1657719026371 "$node_(622) setdest 78271 11648 12.0" 
$ns at 845.3770263039062 "$node_(622) setdest 10897 40973 7.0" 
$ns at 600.0629540360718 "$node_(623) setdest 84323 35400 5.0" 
$ns at 659.8938216153656 "$node_(623) setdest 72845 18405 14.0" 
$ns at 701.7412146758065 "$node_(623) setdest 37716 33149 19.0" 
$ns at 763.4536770909318 "$node_(623) setdest 111451 44553 11.0" 
$ns at 850.5549513869084 "$node_(623) setdest 35827 29450 20.0" 
$ns at 898.7720993535972 "$node_(623) setdest 8901 38513 10.0" 
$ns at 639.0580201277999 "$node_(624) setdest 60421 41989 1.0" 
$ns at 671.4672690623886 "$node_(624) setdest 106532 14398 6.0" 
$ns at 745.7895858596224 "$node_(624) setdest 75501 33593 13.0" 
$ns at 790.1410219446122 "$node_(624) setdest 43734 30729 9.0" 
$ns at 836.4261029590104 "$node_(624) setdest 3192 27 5.0" 
$ns at 888.3762981710231 "$node_(624) setdest 3678 43179 17.0" 
$ns at 739.38103076548 "$node_(625) setdest 45114 8635 11.0" 
$ns at 826.5091196133096 "$node_(625) setdest 100273 44420 18.0" 
$ns at 723.328108566704 "$node_(626) setdest 44670 29881 17.0" 
$ns at 857.4164629481479 "$node_(626) setdest 129744 7159 14.0" 
$ns at 699.5870704400716 "$node_(627) setdest 95606 7584 8.0" 
$ns at 737.3554649742432 "$node_(627) setdest 15756 16197 8.0" 
$ns at 783.603764210948 "$node_(627) setdest 115245 43915 2.0" 
$ns at 820.4315437060382 "$node_(627) setdest 32394 11320 2.0" 
$ns at 868.6752626101919 "$node_(627) setdest 56724 3784 3.0" 
$ns at 610.0759688912152 "$node_(628) setdest 111317 22373 13.0" 
$ns at 759.8235389639365 "$node_(628) setdest 91961 32506 2.0" 
$ns at 796.5673673162263 "$node_(628) setdest 81140 14158 16.0" 
$ns at 640.7581738279305 "$node_(629) setdest 26741 7070 20.0" 
$ns at 845.2160697942448 "$node_(629) setdest 3848 31251 16.0" 
$ns at 892.6176349414192 "$node_(629) setdest 25836 24403 13.0" 
$ns at 632.893237295119 "$node_(630) setdest 25477 10826 3.0" 
$ns at 683.5104476916334 "$node_(630) setdest 85870 5337 11.0" 
$ns at 726.8094605324059 "$node_(630) setdest 5714 37 7.0" 
$ns at 811.006474071609 "$node_(630) setdest 60784 41601 3.0" 
$ns at 849.159068433963 "$node_(630) setdest 110472 42170 1.0" 
$ns at 882.8900435500734 "$node_(630) setdest 80640 37492 9.0" 
$ns at 788.4119778308666 "$node_(631) setdest 69078 6262 7.0" 
$ns at 857.7059650870466 "$node_(631) setdest 128647 28660 18.0" 
$ns at 752.4801099024378 "$node_(632) setdest 93448 6871 2.0" 
$ns at 792.7371168910869 "$node_(632) setdest 66888 29223 17.0" 
$ns at 881.0806645741013 "$node_(632) setdest 116785 18612 16.0" 
$ns at 604.1696007368532 "$node_(633) setdest 30417 36963 10.0" 
$ns at 681.6811424351516 "$node_(633) setdest 35582 10646 11.0" 
$ns at 762.4915330058066 "$node_(633) setdest 127881 33800 11.0" 
$ns at 803.3175697031602 "$node_(633) setdest 72392 42574 6.0" 
$ns at 891.7338756886166 "$node_(633) setdest 118586 33714 1.0" 
$ns at 644.5191911525645 "$node_(634) setdest 62836 12799 6.0" 
$ns at 695.3311567380723 "$node_(634) setdest 72400 37473 5.0" 
$ns at 756.7328900404027 "$node_(634) setdest 24274 3668 18.0" 
$ns at 788.0774076958534 "$node_(634) setdest 44009 39320 15.0" 
$ns at 869.7963562807516 "$node_(634) setdest 73395 42926 17.0" 
$ns at 671.4703702326459 "$node_(635) setdest 48792 19964 5.0" 
$ns at 727.6491940045421 "$node_(635) setdest 96730 914 10.0" 
$ns at 810.3047598275987 "$node_(635) setdest 114093 25500 10.0" 
$ns at 751.1919510717711 "$node_(636) setdest 68893 6590 9.0" 
$ns at 809.5878885901964 "$node_(636) setdest 94000 473 1.0" 
$ns at 847.0945540466253 "$node_(636) setdest 31199 38891 12.0" 
$ns at 600.5351769986829 "$node_(637) setdest 15020 22765 15.0" 
$ns at 719.6626811798233 "$node_(637) setdest 61953 16907 13.0" 
$ns at 752.7673428205682 "$node_(637) setdest 68885 43970 6.0" 
$ns at 836.3102152981027 "$node_(637) setdest 49099 35819 5.0" 
$ns at 897.9091070298251 "$node_(637) setdest 730 9780 18.0" 
$ns at 631.32292537256 "$node_(638) setdest 61253 23742 5.0" 
$ns at 701.2832947351831 "$node_(638) setdest 79231 22140 15.0" 
$ns at 839.8887261852703 "$node_(638) setdest 110564 23094 13.0" 
$ns at 616.7240391222376 "$node_(639) setdest 107489 15906 5.0" 
$ns at 690.5085518843879 "$node_(639) setdest 82744 12091 3.0" 
$ns at 728.0772139501705 "$node_(639) setdest 37211 39990 15.0" 
$ns at 860.3690052611663 "$node_(639) setdest 16649 11957 2.0" 
$ns at 893.3773269790589 "$node_(639) setdest 129835 15674 14.0" 
$ns at 621.734228928976 "$node_(640) setdest 92209 22115 16.0" 
$ns at 690.5250355792022 "$node_(640) setdest 77973 3844 18.0" 
$ns at 730.9646650496891 "$node_(640) setdest 106456 15185 17.0" 
$ns at 784.5668588714685 "$node_(640) setdest 131730 35264 3.0" 
$ns at 843.1059551913252 "$node_(640) setdest 85957 5557 3.0" 
$ns at 875.2066468660825 "$node_(640) setdest 134096 4772 10.0" 
$ns at 638.0652860228417 "$node_(641) setdest 110583 23480 1.0" 
$ns at 675.7989097248235 "$node_(641) setdest 120925 507 9.0" 
$ns at 727.7865337499686 "$node_(641) setdest 34543 31836 9.0" 
$ns at 817.7885603883428 "$node_(641) setdest 65427 26323 19.0" 
$ns at 629.7167909532324 "$node_(642) setdest 86825 37278 19.0" 
$ns at 758.8342774605093 "$node_(642) setdest 14901 20778 18.0" 
$ns at 866.8936522457009 "$node_(642) setdest 16959 37124 4.0" 
$ns at 630.3062263310046 "$node_(643) setdest 50114 2120 15.0" 
$ns at 741.6354362574699 "$node_(643) setdest 79100 30398 2.0" 
$ns at 788.0775381570542 "$node_(643) setdest 83854 31570 1.0" 
$ns at 823.509470093501 "$node_(643) setdest 109495 3905 5.0" 
$ns at 891.4988464716662 "$node_(643) setdest 127101 26846 10.0" 
$ns at 626.9430858055638 "$node_(644) setdest 118677 38419 17.0" 
$ns at 672.0218388429141 "$node_(644) setdest 89467 11670 2.0" 
$ns at 715.0520599038725 "$node_(644) setdest 56354 13672 6.0" 
$ns at 766.8454658877207 "$node_(644) setdest 39485 15283 4.0" 
$ns at 832.3727865080945 "$node_(644) setdest 45710 6579 13.0" 
$ns at 644.2063001294855 "$node_(645) setdest 8728 43661 6.0" 
$ns at 717.1391516947313 "$node_(645) setdest 108944 43807 16.0" 
$ns at 850.54038230996 "$node_(645) setdest 88183 36651 3.0" 
$ns at 604.6575976906094 "$node_(646) setdest 110888 26654 7.0" 
$ns at 693.7548279998804 "$node_(646) setdest 85386 32435 2.0" 
$ns at 725.9795003181506 "$node_(646) setdest 86544 13410 2.0" 
$ns at 773.2760563688023 "$node_(646) setdest 50224 20011 15.0" 
$ns at 677.915139145379 "$node_(647) setdest 9879 42058 5.0" 
$ns at 741.6077902022856 "$node_(647) setdest 44681 1512 7.0" 
$ns at 797.3867149383638 "$node_(647) setdest 74066 40373 8.0" 
$ns at 858.2937447982744 "$node_(647) setdest 80944 9725 18.0" 
$ns at 688.9921087766171 "$node_(648) setdest 54548 16227 1.0" 
$ns at 720.2351496633516 "$node_(648) setdest 110256 16300 12.0" 
$ns at 786.6182440963282 "$node_(648) setdest 103599 7296 6.0" 
$ns at 828.9354540184792 "$node_(648) setdest 114541 9161 9.0" 
$ns at 897.4559460802584 "$node_(648) setdest 106313 7804 19.0" 
$ns at 642.5525877482539 "$node_(649) setdest 57171 37011 3.0" 
$ns at 694.9386530919053 "$node_(649) setdest 131439 28075 7.0" 
$ns at 789.0950003707565 "$node_(649) setdest 77461 28100 5.0" 
$ns at 835.6257965263643 "$node_(649) setdest 45220 28060 1.0" 
$ns at 873.6385768611766 "$node_(649) setdest 84628 31314 7.0" 
$ns at 621.7861064430809 "$node_(650) setdest 117610 39753 1.0" 
$ns at 658.7399613464369 "$node_(650) setdest 128818 7027 5.0" 
$ns at 731.092019493146 "$node_(650) setdest 10077 34828 7.0" 
$ns at 796.16251385022 "$node_(650) setdest 45133 4346 12.0" 
$ns at 635.9599562234426 "$node_(651) setdest 3870 43369 12.0" 
$ns at 779.9834818959519 "$node_(651) setdest 4377 27246 19.0" 
$ns at 639.635898478479 "$node_(652) setdest 68176 29390 4.0" 
$ns at 675.6117716753465 "$node_(652) setdest 41959 33532 5.0" 
$ns at 719.5715216703809 "$node_(652) setdest 12619 40308 4.0" 
$ns at 784.5877810810928 "$node_(652) setdest 22460 20536 13.0" 
$ns at 891.002045434644 "$node_(652) setdest 34456 9644 19.0" 
$ns at 721.2414973738998 "$node_(653) setdest 65511 35472 15.0" 
$ns at 827.0134899927075 "$node_(653) setdest 79524 38459 7.0" 
$ns at 866.679578211274 "$node_(653) setdest 29710 32753 20.0" 
$ns at 662.7973235570588 "$node_(654) setdest 124503 9383 12.0" 
$ns at 801.4843883220431 "$node_(654) setdest 123778 33026 10.0" 
$ns at 872.4626239621209 "$node_(654) setdest 58147 4989 1.0" 
$ns at 612.4412437891468 "$node_(655) setdest 105211 22155 20.0" 
$ns at 686.0628038114454 "$node_(655) setdest 113687 43611 13.0" 
$ns at 805.4887931549017 "$node_(655) setdest 66105 27854 16.0" 
$ns at 873.9367551203345 "$node_(655) setdest 30523 42974 19.0" 
$ns at 609.596744200418 "$node_(656) setdest 111050 16213 16.0" 
$ns at 787.0356450378323 "$node_(656) setdest 59293 19967 4.0" 
$ns at 819.053368094963 "$node_(656) setdest 133111 10988 11.0" 
$ns at 878.6973407170303 "$node_(656) setdest 84998 6841 13.0" 
$ns at 705.9234070339305 "$node_(657) setdest 110429 37424 6.0" 
$ns at 772.2118270294781 "$node_(657) setdest 11064 25320 18.0" 
$ns at 746.320732144978 "$node_(658) setdest 19320 21549 17.0" 
$ns at 781.1014961716077 "$node_(658) setdest 132812 827 13.0" 
$ns at 887.6540333800809 "$node_(658) setdest 108244 35261 14.0" 
$ns at 601.8188910983813 "$node_(659) setdest 80011 24047 13.0" 
$ns at 756.3180500150344 "$node_(659) setdest 93079 36870 17.0" 
$ns at 647.8357433633103 "$node_(660) setdest 70570 20512 6.0" 
$ns at 707.4290468599263 "$node_(660) setdest 110021 2877 18.0" 
$ns at 885.5906610747409 "$node_(660) setdest 102981 28027 1.0" 
$ns at 672.6640948196323 "$node_(661) setdest 24686 35028 5.0" 
$ns at 726.7300574759016 "$node_(661) setdest 101169 7680 3.0" 
$ns at 761.746080400414 "$node_(661) setdest 28132 18601 4.0" 
$ns at 826.6312569954312 "$node_(661) setdest 27229 8905 15.0" 
$ns at 706.8071808674209 "$node_(662) setdest 26797 38311 16.0" 
$ns at 738.5732616861155 "$node_(662) setdest 30223 30283 14.0" 
$ns at 854.022061486088 "$node_(662) setdest 46230 32255 16.0" 
$ns at 629.4100498751411 "$node_(663) setdest 51864 5517 10.0" 
$ns at 679.8411000841353 "$node_(663) setdest 34077 8156 5.0" 
$ns at 736.9123900288846 "$node_(663) setdest 59604 8126 12.0" 
$ns at 826.3921473625443 "$node_(663) setdest 53744 42953 18.0" 
$ns at 711.7113047014014 "$node_(664) setdest 125447 4101 20.0" 
$ns at 691.4353909623579 "$node_(665) setdest 35385 5736 1.0" 
$ns at 726.3874345096464 "$node_(665) setdest 86921 8654 14.0" 
$ns at 854.9285606485888 "$node_(665) setdest 104633 7191 9.0" 
$ns at 611.227146962312 "$node_(666) setdest 97040 34867 2.0" 
$ns at 641.3944864288425 "$node_(666) setdest 22058 17006 11.0" 
$ns at 741.3832056985694 "$node_(666) setdest 91204 36396 12.0" 
$ns at 777.3903020156989 "$node_(666) setdest 104405 2356 7.0" 
$ns at 840.8995701984728 "$node_(666) setdest 85564 1919 17.0" 
$ns at 883.7654291318659 "$node_(666) setdest 77531 23999 9.0" 
$ns at 704.0568339119772 "$node_(667) setdest 47826 3320 13.0" 
$ns at 749.2596501144226 "$node_(667) setdest 41399 9715 4.0" 
$ns at 796.4119743720883 "$node_(667) setdest 120682 34368 20.0" 
$ns at 671.2871614588147 "$node_(668) setdest 91279 11057 4.0" 
$ns at 727.774461750661 "$node_(668) setdest 128660 16903 2.0" 
$ns at 766.0292276382074 "$node_(668) setdest 119641 27448 13.0" 
$ns at 626.2883433869562 "$node_(669) setdest 104472 27755 3.0" 
$ns at 681.6398652990865 "$node_(669) setdest 37549 2184 11.0" 
$ns at 776.3481951551406 "$node_(669) setdest 36880 3899 3.0" 
$ns at 810.5390626729617 "$node_(669) setdest 24291 23554 4.0" 
$ns at 862.4738497083115 "$node_(669) setdest 85095 16083 10.0" 
$ns at 701.9812407994909 "$node_(670) setdest 2187 21898 9.0" 
$ns at 820.2254059960468 "$node_(670) setdest 90724 17348 1.0" 
$ns at 854.8584143516453 "$node_(670) setdest 85754 24513 13.0" 
$ns at 648.3183380198094 "$node_(671) setdest 75100 7979 14.0" 
$ns at 794.606642196858 "$node_(671) setdest 20980 5618 5.0" 
$ns at 857.2970154592675 "$node_(671) setdest 100150 31150 13.0" 
$ns at 601.484238326092 "$node_(672) setdest 132007 7833 5.0" 
$ns at 633.1136440130178 "$node_(672) setdest 26907 35913 5.0" 
$ns at 665.2566141129603 "$node_(672) setdest 95849 13441 19.0" 
$ns at 795.0373390562077 "$node_(672) setdest 80148 29671 1.0" 
$ns at 828.628401174207 "$node_(672) setdest 52471 14950 4.0" 
$ns at 876.7109918192695 "$node_(672) setdest 63980 28328 8.0" 
$ns at 753.0610070392304 "$node_(673) setdest 13472 18469 18.0" 
$ns at 866.4471180054272 "$node_(673) setdest 78928 33284 17.0" 
$ns at 625.1151998423636 "$node_(674) setdest 81021 10277 13.0" 
$ns at 771.2916103839201 "$node_(674) setdest 5602 24194 15.0" 
$ns at 886.088224577884 "$node_(674) setdest 79299 22631 7.0" 
$ns at 720.1630303459224 "$node_(675) setdest 71134 14865 1.0" 
$ns at 752.7756827262235 "$node_(675) setdest 52887 33513 8.0" 
$ns at 800.7154927126384 "$node_(675) setdest 134047 3782 7.0" 
$ns at 883.2943794428453 "$node_(675) setdest 88152 40522 18.0" 
$ns at 610.4671020115177 "$node_(676) setdest 17289 7591 14.0" 
$ns at 751.60792514339 "$node_(676) setdest 61760 21190 10.0" 
$ns at 856.2764706360591 "$node_(676) setdest 35569 16495 8.0" 
$ns at 652.9157980801757 "$node_(677) setdest 40744 11654 8.0" 
$ns at 746.0905401604366 "$node_(677) setdest 71454 23925 1.0" 
$ns at 783.472621898808 "$node_(677) setdest 55649 7725 18.0" 
$ns at 662.5059779118315 "$node_(678) setdest 104940 39298 7.0" 
$ns at 758.9544504927997 "$node_(678) setdest 74601 30319 20.0" 
$ns at 624.7678220179279 "$node_(679) setdest 65392 39730 20.0" 
$ns at 846.8430102889082 "$node_(679) setdest 129881 1068 18.0" 
$ns at 620.3290037847697 "$node_(680) setdest 106919 40146 2.0" 
$ns at 657.0622588590198 "$node_(680) setdest 33297 3469 19.0" 
$ns at 691.8748835811364 "$node_(680) setdest 8918 10044 1.0" 
$ns at 731.1460045645852 "$node_(680) setdest 128866 40773 1.0" 
$ns at 768.4209571536702 "$node_(680) setdest 28664 21398 20.0" 
$ns at 659.7695935931554 "$node_(681) setdest 54996 18661 10.0" 
$ns at 754.0224763870324 "$node_(681) setdest 44830 14679 3.0" 
$ns at 806.3961880986401 "$node_(681) setdest 58560 26741 7.0" 
$ns at 885.2352430134706 "$node_(681) setdest 73002 43435 5.0" 
$ns at 611.2873486320607 "$node_(682) setdest 34019 15715 20.0" 
$ns at 665.8749720534429 "$node_(682) setdest 8056 36181 16.0" 
$ns at 829.6611668782232 "$node_(682) setdest 58666 16547 16.0" 
$ns at 876.3298435528176 "$node_(682) setdest 76803 5912 7.0" 
$ns at 633.3934583055096 "$node_(683) setdest 81451 36108 15.0" 
$ns at 693.1553780144375 "$node_(683) setdest 101354 13387 5.0" 
$ns at 758.9446045901241 "$node_(683) setdest 42542 4902 13.0" 
$ns at 804.5655762519215 "$node_(683) setdest 31456 12893 5.0" 
$ns at 866.5296756550629 "$node_(683) setdest 29701 22464 3.0" 
$ns at 898.9668601911025 "$node_(683) setdest 24229 1695 10.0" 
$ns at 705.0317168473574 "$node_(684) setdest 125906 18256 15.0" 
$ns at 742.739717629912 "$node_(684) setdest 75221 12666 4.0" 
$ns at 785.681756151439 "$node_(684) setdest 21562 7322 10.0" 
$ns at 888.9795424792675 "$node_(684) setdest 12317 26645 6.0" 
$ns at 683.8911517089103 "$node_(685) setdest 107454 4862 17.0" 
$ns at 761.9081654442558 "$node_(685) setdest 9955 7597 4.0" 
$ns at 795.299071372855 "$node_(685) setdest 100859 29264 5.0" 
$ns at 866.3264513428247 "$node_(685) setdest 124074 14090 11.0" 
$ns at 676.7393551548147 "$node_(686) setdest 67210 42194 1.0" 
$ns at 708.1577116342427 "$node_(686) setdest 117001 10998 7.0" 
$ns at 802.0178274158548 "$node_(686) setdest 38010 18210 11.0" 
$ns at 610.3186485479882 "$node_(687) setdest 94041 5518 8.0" 
$ns at 698.9039395879106 "$node_(687) setdest 40278 20074 3.0" 
$ns at 731.6239851825329 "$node_(687) setdest 117532 16302 14.0" 
$ns at 818.1817048463769 "$node_(687) setdest 126776 39721 5.0" 
$ns at 850.1485026757574 "$node_(687) setdest 30947 38120 16.0" 
$ns at 687.0774704558851 "$node_(688) setdest 116288 19262 15.0" 
$ns at 826.3127739840097 "$node_(688) setdest 114596 18992 5.0" 
$ns at 898.5839061079712 "$node_(688) setdest 13925 8269 18.0" 
$ns at 607.5316837871003 "$node_(689) setdest 103310 42692 5.0" 
$ns at 660.6668250513951 "$node_(689) setdest 27393 10499 11.0" 
$ns at 752.8994285983674 "$node_(689) setdest 13685 14801 13.0" 
$ns at 807.9353661316077 "$node_(689) setdest 54476 4366 18.0" 
$ns at 863.0932500172806 "$node_(689) setdest 16807 15490 15.0" 
$ns at 638.6395664759839 "$node_(690) setdest 18099 6463 20.0" 
$ns at 784.5935528188527 "$node_(690) setdest 57419 37047 14.0" 
$ns at 652.9971186317837 "$node_(691) setdest 50626 24362 8.0" 
$ns at 696.8179335043017 "$node_(691) setdest 23234 36192 13.0" 
$ns at 731.2624048245597 "$node_(691) setdest 131388 8602 17.0" 
$ns at 775.2312969784901 "$node_(691) setdest 83813 37001 16.0" 
$ns at 632.7594641314248 "$node_(692) setdest 74937 18009 7.0" 
$ns at 699.2919983308157 "$node_(692) setdest 50017 5370 8.0" 
$ns at 794.0729943757635 "$node_(692) setdest 13248 31155 12.0" 
$ns at 896.1147301234404 "$node_(692) setdest 69456 16753 5.0" 
$ns at 600.1718621792622 "$node_(693) setdest 102735 29372 2.0" 
$ns at 646.5948552557938 "$node_(693) setdest 41329 4399 15.0" 
$ns at 707.3108130761472 "$node_(693) setdest 109681 25522 5.0" 
$ns at 754.8881480497437 "$node_(693) setdest 23175 1882 20.0" 
$ns at 898.1411645168992 "$node_(693) setdest 40819 14407 3.0" 
$ns at 766.6473867664978 "$node_(694) setdest 119724 2395 9.0" 
$ns at 801.9849690387584 "$node_(694) setdest 75922 9382 2.0" 
$ns at 850.78503026472 "$node_(694) setdest 50678 23948 2.0" 
$ns at 883.6736983037222 "$node_(694) setdest 111769 38609 4.0" 
$ns at 674.7767604678695 "$node_(695) setdest 125581 22295 16.0" 
$ns at 813.1197386628675 "$node_(695) setdest 82032 17903 9.0" 
$ns at 867.040492310951 "$node_(695) setdest 39671 17461 16.0" 
$ns at 747.153843832628 "$node_(696) setdest 13231 688 2.0" 
$ns at 795.3632833282078 "$node_(696) setdest 77578 2964 4.0" 
$ns at 834.8204114781677 "$node_(696) setdest 122406 1449 8.0" 
$ns at 644.783893580732 "$node_(697) setdest 5420 25573 12.0" 
$ns at 745.9611970934827 "$node_(697) setdest 46321 32716 9.0" 
$ns at 810.6986767127959 "$node_(697) setdest 115537 31469 17.0" 
$ns at 616.688906454868 "$node_(698) setdest 1256 36539 12.0" 
$ns at 765.9618549911346 "$node_(698) setdest 119876 2574 9.0" 
$ns at 853.565553147822 "$node_(698) setdest 132379 38373 19.0" 
$ns at 606.5679380167375 "$node_(699) setdest 29938 1142 15.0" 
$ns at 772.2572613853004 "$node_(699) setdest 14634 26021 11.0" 
$ns at 745.4781920154298 "$node_(700) setdest 110822 40607 13.0" 
$ns at 855.223689599753 "$node_(700) setdest 87520 12321 12.0" 
$ns at 719.1236459073162 "$node_(701) setdest 39868 15062 16.0" 
$ns at 846.411819208732 "$node_(701) setdest 3674 21855 5.0" 
$ns at 883.5460943297772 "$node_(702) setdest 102316 42887 4.0" 
$ns at 790.9155854048751 "$node_(703) setdest 17257 27388 7.0" 
$ns at 830.8523429023952 "$node_(703) setdest 28600 17608 10.0" 
$ns at 774.640004038972 "$node_(704) setdest 118544 22962 7.0" 
$ns at 843.3979234646724 "$node_(704) setdest 62581 42664 11.0" 
$ns at 822.3522480725895 "$node_(705) setdest 89247 10550 9.0" 
$ns at 721.5062114338435 "$node_(706) setdest 99901 11209 9.0" 
$ns at 829.0476774821053 "$node_(706) setdest 127593 33029 14.0" 
$ns at 727.8554459081626 "$node_(707) setdest 52546 18711 10.0" 
$ns at 844.7854824611371 "$node_(707) setdest 97680 4350 12.0" 
$ns at 778.1725348856078 "$node_(708) setdest 37590 10692 3.0" 
$ns at 810.1901758670934 "$node_(708) setdest 91233 20240 3.0" 
$ns at 869.6258916265379 "$node_(708) setdest 100028 25816 1.0" 
$ns at 761.9867070326911 "$node_(709) setdest 55807 43491 15.0" 
$ns at 751.8513459754134 "$node_(710) setdest 27887 34469 15.0" 
$ns at 881.6590187272787 "$node_(710) setdest 87462 21742 9.0" 
$ns at 730.5743429309912 "$node_(711) setdest 127118 43370 16.0" 
$ns at 765.1164031057087 "$node_(711) setdest 84613 15686 11.0" 
$ns at 849.037818934076 "$node_(711) setdest 125562 40944 17.0" 
$ns at 835.8247298984671 "$node_(712) setdest 118324 38639 17.0" 
$ns at 722.5063528630736 "$node_(713) setdest 85101 42643 12.0" 
$ns at 791.2716461296967 "$node_(713) setdest 110015 26072 18.0" 
$ns at 866.3428726545549 "$node_(713) setdest 122750 23805 16.0" 
$ns at 829.2458757316161 "$node_(714) setdest 1212 27049 11.0" 
$ns at 788.4225988489334 "$node_(715) setdest 34452 25111 19.0" 
$ns at 733.5515068605924 "$node_(716) setdest 109956 30919 1.0" 
$ns at 768.518945507108 "$node_(716) setdest 102082 5361 13.0" 
$ns at 779.5369376847299 "$node_(717) setdest 50859 39109 11.0" 
$ns at 788.9443895779641 "$node_(718) setdest 53611 4277 12.0" 
$ns at 864.1066317963813 "$node_(718) setdest 103571 139 2.0" 
$ns at 734.0223049491065 "$node_(719) setdest 73628 1916 17.0" 
$ns at 809.487584643043 "$node_(719) setdest 118907 37556 6.0" 
$ns at 880.938178116478 "$node_(719) setdest 127997 22342 13.0" 
$ns at 801.4703030491523 "$node_(720) setdest 69047 21945 16.0" 
$ns at 700.1173022649073 "$node_(721) setdest 82859 38572 11.0" 
$ns at 828.5867519606813 "$node_(721) setdest 112359 1735 6.0" 
$ns at 870.4788038632025 "$node_(721) setdest 4292 23322 1.0" 
$ns at 722.5374874418893 "$node_(722) setdest 25054 14250 8.0" 
$ns at 792.0451609764739 "$node_(722) setdest 97443 25072 18.0" 
$ns at 776.481826104105 "$node_(723) setdest 100704 15941 7.0" 
$ns at 853.3758512646923 "$node_(723) setdest 77098 8203 18.0" 
$ns at 816.9242701267275 "$node_(724) setdest 36970 32016 19.0" 
$ns at 737.3886393871111 "$node_(725) setdest 65372 12119 11.0" 
$ns at 769.4472898598158 "$node_(725) setdest 30894 7570 1.0" 
$ns at 809.2580380732671 "$node_(725) setdest 83662 6190 14.0" 
$ns at 860.3746377878152 "$node_(725) setdest 21999 14535 5.0" 
$ns at 861.1584933111857 "$node_(726) setdest 126884 37328 3.0" 
$ns at 771.3218377694332 "$node_(727) setdest 82586 5233 10.0" 
$ns at 860.2076884579475 "$node_(727) setdest 44081 41534 9.0" 
$ns at 860.4957876447768 "$node_(728) setdest 83086 25385 16.0" 
$ns at 772.0420058932264 "$node_(729) setdest 91340 28008 6.0" 
$ns at 851.9315230520742 "$node_(729) setdest 41307 34658 10.0" 
$ns at 890.9787684535423 "$node_(729) setdest 74357 30259 20.0" 
$ns at 716.8314550115969 "$node_(730) setdest 31871 15009 6.0" 
$ns at 764.236004484222 "$node_(730) setdest 100517 42614 8.0" 
$ns at 862.2972443433508 "$node_(730) setdest 63366 17236 2.0" 
$ns at 892.8259307932807 "$node_(730) setdest 131410 36231 13.0" 
$ns at 816.4592580309735 "$node_(731) setdest 88774 23588 7.0" 
$ns at 875.7750045365658 "$node_(731) setdest 24894 1969 3.0" 
$ns at 763.9927861670717 "$node_(732) setdest 82803 43128 19.0" 
$ns at 879.5664001541863 "$node_(732) setdest 113636 13847 1.0" 
$ns at 849.8161931111729 "$node_(733) setdest 7264 5991 9.0" 
$ns at 745.4143830784333 "$node_(734) setdest 85839 15677 1.0" 
$ns at 782.4986347080477 "$node_(734) setdest 102037 8828 13.0" 
$ns at 829.0842364500712 "$node_(734) setdest 98254 18508 16.0" 
$ns at 704.4684129550045 "$node_(735) setdest 62041 16401 3.0" 
$ns at 736.244536593294 "$node_(735) setdest 86799 39942 1.0" 
$ns at 772.7856470688745 "$node_(735) setdest 45667 29471 5.0" 
$ns at 808.9572188556714 "$node_(735) setdest 122457 42032 7.0" 
$ns at 859.1651848902533 "$node_(735) setdest 83422 9574 13.0" 
$ns at 711.7917805470646 "$node_(736) setdest 59405 22536 5.0" 
$ns at 782.0699207981961 "$node_(736) setdest 43386 30267 20.0" 
$ns at 703.6988001810599 "$node_(737) setdest 99442 33602 18.0" 
$ns at 885.7020881493606 "$node_(737) setdest 100569 17401 7.0" 
$ns at 717.7462370364406 "$node_(738) setdest 62202 12612 7.0" 
$ns at 789.1991970544061 "$node_(738) setdest 53473 13261 11.0" 
$ns at 859.0701500268907 "$node_(738) setdest 75552 42811 18.0" 
$ns at 771.6375098959035 "$node_(739) setdest 129519 28238 4.0" 
$ns at 823.5874594977095 "$node_(739) setdest 119604 39547 11.0" 
$ns at 710.408028348858 "$node_(740) setdest 48519 36374 4.0" 
$ns at 765.1835959619805 "$node_(740) setdest 99466 9425 5.0" 
$ns at 836.167846847684 "$node_(740) setdest 61932 25833 6.0" 
$ns at 720.1714784212978 "$node_(741) setdest 26098 5139 9.0" 
$ns at 798.6519306702552 "$node_(741) setdest 94165 20873 5.0" 
$ns at 838.382934887173 "$node_(741) setdest 52872 27833 6.0" 
$ns at 891.2045680419789 "$node_(741) setdest 109821 1095 3.0" 
$ns at 728.5555603018386 "$node_(742) setdest 94199 36786 15.0" 
$ns at 791.6684124046166 "$node_(742) setdest 116494 14924 13.0" 
$ns at 778.4719138670342 "$node_(743) setdest 32199 34325 15.0" 
$ns at 735.9213522618397 "$node_(744) setdest 63910 28813 16.0" 
$ns at 848.1506843506497 "$node_(744) setdest 78818 3206 10.0" 
$ns at 719.2858237201683 "$node_(745) setdest 99811 12660 15.0" 
$ns at 768.7675123412955 "$node_(745) setdest 115995 36802 7.0" 
$ns at 822.3216949272788 "$node_(745) setdest 105472 33018 17.0" 
$ns at 891.6260171713166 "$node_(745) setdest 10502 19817 8.0" 
$ns at 709.3182996583366 "$node_(746) setdest 71657 21461 6.0" 
$ns at 786.6058072874978 "$node_(746) setdest 33846 14830 20.0" 
$ns at 843.6314098512836 "$node_(746) setdest 74159 33415 18.0" 
$ns at 716.7024491764564 "$node_(747) setdest 27109 3669 10.0" 
$ns at 795.9718902032589 "$node_(747) setdest 114476 13685 13.0" 
$ns at 837.0804985163512 "$node_(748) setdest 75203 44418 11.0" 
$ns at 868.9213966165062 "$node_(748) setdest 121995 29944 15.0" 
$ns at 788.0456858128327 "$node_(749) setdest 28792 18832 9.0" 
$ns at 878.4305856427542 "$node_(749) setdest 3390 30394 1.0" 
$ns at 771.9258513705953 "$node_(750) setdest 37422 17225 7.0" 
$ns at 820.8418362307606 "$node_(750) setdest 92185 25057 8.0" 
$ns at 720.6941301969963 "$node_(751) setdest 67868 13593 9.0" 
$ns at 817.3152339485563 "$node_(751) setdest 27221 2924 16.0" 
$ns at 718.8269961273585 "$node_(752) setdest 125777 30095 1.0" 
$ns at 757.1066792188209 "$node_(752) setdest 91960 40349 20.0" 
$ns at 709.8528668372904 "$node_(753) setdest 22137 35762 12.0" 
$ns at 853.4100583329608 "$node_(753) setdest 60790 35589 3.0" 
$ns at 887.8416637264859 "$node_(753) setdest 78208 22539 1.0" 
$ns at 791.0060963707355 "$node_(754) setdest 71717 26406 1.0" 
$ns at 824.796173564347 "$node_(754) setdest 124074 11002 19.0" 
$ns at 704.7900619966406 "$node_(755) setdest 123552 17238 19.0" 
$ns at 815.5843296054499 "$node_(755) setdest 87929 14210 6.0" 
$ns at 887.7664044987529 "$node_(755) setdest 46916 7001 6.0" 
$ns at 777.7537146173652 "$node_(756) setdest 29577 38141 11.0" 
$ns at 864.9276252569541 "$node_(756) setdest 35616 7833 17.0" 
$ns at 727.4313987867897 "$node_(757) setdest 13986 283 12.0" 
$ns at 766.7061296557373 "$node_(757) setdest 16743 37809 10.0" 
$ns at 890.395004180076 "$node_(757) setdest 102765 3789 15.0" 
$ns at 711.3286266848057 "$node_(758) setdest 47564 19394 17.0" 
$ns at 859.1897289823526 "$node_(758) setdest 128475 12057 13.0" 
$ns at 782.3873290207008 "$node_(759) setdest 39706 10173 18.0" 
$ns at 865.2731966496685 "$node_(759) setdest 43685 1348 14.0" 
$ns at 749.5018465237674 "$node_(760) setdest 10203 6265 16.0" 
$ns at 879.192709102937 "$node_(760) setdest 99647 11350 7.0" 
$ns at 768.2024276674977 "$node_(761) setdest 29583 5396 12.0" 
$ns at 855.8549617717036 "$node_(761) setdest 91010 20444 11.0" 
$ns at 708.5389630024137 "$node_(762) setdest 16598 43264 6.0" 
$ns at 747.1328408590281 "$node_(762) setdest 23039 21409 12.0" 
$ns at 852.2690183456117 "$node_(762) setdest 127996 17759 5.0" 
$ns at 891.9384234683004 "$node_(762) setdest 76326 37266 1.0" 
$ns at 712.424871537306 "$node_(763) setdest 65465 4195 15.0" 
$ns at 847.4543901405033 "$node_(763) setdest 109535 11426 11.0" 
$ns at 779.8944668413983 "$node_(764) setdest 87136 4800 4.0" 
$ns at 811.6296072201771 "$node_(764) setdest 49200 33383 19.0" 
$ns at 817.6499179389479 "$node_(765) setdest 109913 42966 7.0" 
$ns at 897.6423107888395 "$node_(765) setdest 49472 29251 1.0" 
$ns at 748.293847596141 "$node_(766) setdest 44979 9308 7.0" 
$ns at 798.1641704749088 "$node_(766) setdest 73213 35618 10.0" 
$ns at 733.8224340587897 "$node_(767) setdest 6311 32385 19.0" 
$ns at 862.1096137273491 "$node_(767) setdest 107090 5091 8.0" 
$ns at 708.3918631286322 "$node_(768) setdest 63797 17533 1.0" 
$ns at 744.0934888222573 "$node_(768) setdest 133112 40752 1.0" 
$ns at 783.9983580913785 "$node_(768) setdest 71155 1034 2.0" 
$ns at 818.3879001626622 "$node_(768) setdest 42458 33601 18.0" 
$ns at 860.1819352846991 "$node_(768) setdest 34303 14681 5.0" 
$ns at 776.9162232449913 "$node_(769) setdest 124404 357 19.0" 
$ns at 875.3683618169248 "$node_(769) setdest 70621 39604 8.0" 
$ns at 715.6200668106047 "$node_(770) setdest 19108 30496 7.0" 
$ns at 794.0025496807838 "$node_(770) setdest 36341 19765 13.0" 
$ns at 856.6879048576697 "$node_(770) setdest 102556 42292 14.0" 
$ns at 890.520816967827 "$node_(770) setdest 68893 27287 4.0" 
$ns at 795.3382834513975 "$node_(771) setdest 100673 4858 6.0" 
$ns at 827.068532793051 "$node_(771) setdest 44348 31118 6.0" 
$ns at 864.0707504590811 "$node_(771) setdest 112654 43504 20.0" 
$ns at 794.1891249142245 "$node_(772) setdest 131990 36412 10.0" 
$ns at 840.2602625068512 "$node_(772) setdest 40845 5594 4.0" 
$ns at 886.0360574404294 "$node_(772) setdest 95338 36960 14.0" 
$ns at 821.3399711566533 "$node_(773) setdest 69282 14011 10.0" 
$ns at 851.9910324177467 "$node_(774) setdest 110415 499 16.0" 
$ns at 857.6952296381687 "$node_(775) setdest 16253 30584 15.0" 
$ns at 827.2242956072425 "$node_(776) setdest 65396 17368 19.0" 
$ns at 738.2031991083028 "$node_(777) setdest 132309 36830 16.0" 
$ns at 730.4411728084292 "$node_(778) setdest 19439 42625 12.0" 
$ns at 800.4985421548772 "$node_(778) setdest 113512 13534 17.0" 
$ns at 861.3400586703873 "$node_(778) setdest 97097 43400 11.0" 
$ns at 722.8755575093969 "$node_(779) setdest 29563 12897 4.0" 
$ns at 790.1713730300373 "$node_(779) setdest 103126 9446 11.0" 
$ns at 872.3762757850525 "$node_(779) setdest 122279 18082 9.0" 
$ns at 701.3933321159595 "$node_(780) setdest 125835 21794 14.0" 
$ns at 774.0158644418236 "$node_(780) setdest 79485 14414 14.0" 
$ns at 710.6642233990323 "$node_(781) setdest 65675 29521 18.0" 
$ns at 880.2851700696056 "$node_(781) setdest 46541 28927 5.0" 
$ns at 737.0254364544683 "$node_(782) setdest 45370 41184 3.0" 
$ns at 773.6778728298167 "$node_(782) setdest 89985 39547 14.0" 
$ns at 729.4593086024049 "$node_(783) setdest 133320 38985 8.0" 
$ns at 823.4649365946357 "$node_(783) setdest 88973 27176 1.0" 
$ns at 855.4649616310888 "$node_(783) setdest 108301 42427 5.0" 
$ns at 894.5193866586552 "$node_(783) setdest 11774 12895 5.0" 
$ns at 755.9214717085939 "$node_(784) setdest 101263 25394 18.0" 
$ns at 738.277039956778 "$node_(785) setdest 30043 11551 18.0" 
$ns at 715.0232016895771 "$node_(786) setdest 122765 14540 1.0" 
$ns at 750.8430784354193 "$node_(786) setdest 109486 9052 19.0" 
$ns at 799.3993949399577 "$node_(787) setdest 19495 42247 8.0" 
$ns at 856.7841814219768 "$node_(787) setdest 133980 40823 3.0" 
$ns at 892.1303113366064 "$node_(787) setdest 73207 12408 16.0" 
$ns at 704.7346708508923 "$node_(788) setdest 63058 34751 2.0" 
$ns at 749.2873335809327 "$node_(788) setdest 130444 28681 12.0" 
$ns at 835.311271059818 "$node_(788) setdest 61160 30191 7.0" 
$ns at 886.5423219469968 "$node_(788) setdest 24769 43673 6.0" 
$ns at 835.7707606125293 "$node_(789) setdest 131174 42614 19.0" 
$ns at 759.4182700814763 "$node_(790) setdest 101755 16213 17.0" 
$ns at 882.439773774917 "$node_(790) setdest 88055 24061 13.0" 
$ns at 772.5788318460816 "$node_(791) setdest 91190 10409 9.0" 
$ns at 818.588783707679 "$node_(791) setdest 121421 35934 12.0" 
$ns at 866.6015252350434 "$node_(791) setdest 35713 30200 19.0" 
$ns at 735.2021689343073 "$node_(792) setdest 123504 10350 14.0" 
$ns at 802.8404154441469 "$node_(792) setdest 104488 13459 17.0" 
$ns at 708.1638225383115 "$node_(793) setdest 77539 43165 6.0" 
$ns at 798.0512684948438 "$node_(793) setdest 72886 33532 12.0" 
$ns at 897.4512484243205 "$node_(793) setdest 32513 6756 17.0" 
$ns at 702.5214900777761 "$node_(794) setdest 129638 31994 19.0" 
$ns at 867.8897036667483 "$node_(794) setdest 110623 25280 1.0" 
$ns at 899.9340601224284 "$node_(794) setdest 43905 13704 1.0" 
$ns at 714.5935550958974 "$node_(795) setdest 57625 13406 16.0" 
$ns at 771.5222654272324 "$node_(795) setdest 4857 2365 10.0" 
$ns at 784.0488809560923 "$node_(796) setdest 82187 4097 6.0" 
$ns at 860.8114297877877 "$node_(796) setdest 489 10566 19.0" 
$ns at 736.5639811549411 "$node_(797) setdest 18792 14103 19.0" 
$ns at 788.7456591146549 "$node_(797) setdest 18507 40231 10.0" 
$ns at 888.1466413934894 "$node_(797) setdest 51503 23523 16.0" 
$ns at 759.1096821317475 "$node_(798) setdest 67102 22062 13.0" 
$ns at 800.0652443918684 "$node_(798) setdest 69321 28930 12.0" 
$ns at 855.2721877952628 "$node_(798) setdest 97527 18229 5.0" 
$ns at 732.2812930990056 "$node_(799) setdest 73067 25355 19.0" 
$ns at 803.078385925217 "$node_(799) setdest 31455 25423 11.0" 
$ns at 885.7222877233532 "$node_(799) setdest 45563 39483 19.0" 


#Set a TCP connection between node_(65) and node_(98)
set tcp_(0) [new Agent/TCP/Newreno]
$tcp_(0) set class_ 2
set sink_(0) [new Agent/TCPSink]
$ns attach-agent $node_(65) $tcp_(0)
$ns attach-agent $node_(98) $sink_(0)
$ns connect $tcp_(0) $sink_(0)
set ftp_(0) [new Application/FTP]
$ftp_(0) attach-agent $tcp_(0)
$ns at 0.2 "$ftp_(0) start"
$ns at 180.0 "$ftp_(0) stop"

#Set a TCP connection between node_(26) and node_(95)
set tcp_(1) [new Agent/TCP/Newreno]
$tcp_(1) set class_ 2
set sink_(1) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(1)
$ns attach-agent $node_(95) $sink_(1)
$ns connect $tcp_(1) $sink_(1)
set ftp_(1) [new Application/FTP]
$ftp_(1) attach-agent $tcp_(1)
$ns at 180.2 "$ftp_(1) start"
$ns at 360.0 "$ftp_(1) stop"

#Set a TCP connection between node_(40) and node_(90)
set tcp_(2) [new Agent/TCP/Newreno]
$tcp_(2) set class_ 2
set sink_(2) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(2)
$ns attach-agent $node_(90) $sink_(2)
$ns connect $tcp_(2) $sink_(2)
set ftp_(2) [new Application/FTP]
$ftp_(2) attach-agent $tcp_(2)
$ns at 360.2 "$ftp_(2) start"
$ns at 540.0 "$ftp_(2) stop"

#Set a TCP connection between node_(28) and node_(59)
set tcp_(3) [new Agent/TCP/Newreno]
$tcp_(3) set class_ 2
set sink_(3) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(3)
$ns attach-agent $node_(59) $sink_(3)
$ns connect $tcp_(3) $sink_(3)
set ftp_(3) [new Application/FTP]
$ftp_(3) attach-agent $tcp_(3)
$ns at 540.2 "$ftp_(3) start"
$ns at 720.0 "$ftp_(3) stop"

#Set a TCP connection between node_(57) and node_(80)
set tcp_(4) [new Agent/TCP/Newreno]
$tcp_(4) set class_ 2
set sink_(4) [new Agent/TCPSink]
$ns attach-agent $node_(57) $tcp_(4)
$ns attach-agent $node_(80) $sink_(4)
$ns connect $tcp_(4) $sink_(4)
set ftp_(4) [new Application/FTP]
$ftp_(4) attach-agent $tcp_(4)
$ns at 720.2 "$ftp_(4) start"
$ns at 900.0 "$ftp_(4) stop"

#Set a TCP connection between node_(94) and node_(74)
set tcp_(5) [new Agent/TCP/Newreno]
$tcp_(5) set class_ 2
set sink_(5) [new Agent/TCPSink]
$ns attach-agent $node_(94) $tcp_(5)
$ns attach-agent $node_(74) $sink_(5)
$ns connect $tcp_(5) $sink_(5)
set ftp_(5) [new Application/FTP]
$ftp_(5) attach-agent $tcp_(5)
$ns at 0.2 "$ftp_(5) start"
$ns at 180.0 "$ftp_(5) stop"

#Set a TCP connection between node_(85) and node_(63)
set tcp_(6) [new Agent/TCP/Newreno]
$tcp_(6) set class_ 2
set sink_(6) [new Agent/TCPSink]
$ns attach-agent $node_(85) $tcp_(6)
$ns attach-agent $node_(63) $sink_(6)
$ns connect $tcp_(6) $sink_(6)
set ftp_(6) [new Application/FTP]
$ftp_(6) attach-agent $tcp_(6)
$ns at 180.2 "$ftp_(6) start"
$ns at 360.0 "$ftp_(6) stop"

#Set a TCP connection between node_(91) and node_(33)
set tcp_(7) [new Agent/TCP/Newreno]
$tcp_(7) set class_ 2
set sink_(7) [new Agent/TCPSink]
$ns attach-agent $node_(91) $tcp_(7)
$ns attach-agent $node_(33) $sink_(7)
$ns connect $tcp_(7) $sink_(7)
set ftp_(7) [new Application/FTP]
$ftp_(7) attach-agent $tcp_(7)
$ns at 360.2 "$ftp_(7) start"
$ns at 540.0 "$ftp_(7) stop"

#Set a TCP connection between node_(98) and node_(37)
set tcp_(8) [new Agent/TCP/Newreno]
$tcp_(8) set class_ 2
set sink_(8) [new Agent/TCPSink]
$ns attach-agent $node_(98) $tcp_(8)
$ns attach-agent $node_(37) $sink_(8)
$ns connect $tcp_(8) $sink_(8)
set ftp_(8) [new Application/FTP]
$ftp_(8) attach-agent $tcp_(8)
$ns at 540.2 "$ftp_(8) start"
$ns at 720.0 "$ftp_(8) stop"

#Set a TCP connection between node_(80) and node_(36)
set tcp_(9) [new Agent/TCP/Newreno]
$tcp_(9) set class_ 2
set sink_(9) [new Agent/TCPSink]
$ns attach-agent $node_(80) $tcp_(9)
$ns attach-agent $node_(36) $sink_(9)
$ns connect $tcp_(9) $sink_(9)
set ftp_(9) [new Application/FTP]
$ftp_(9) attach-agent $tcp_(9)
$ns at 720.2 "$ftp_(9) start"
$ns at 900.0 "$ftp_(9) stop"

#Set a TCP connection between node_(61) and node_(98)
set tcp_(10) [new Agent/TCP/Newreno]
$tcp_(10) set class_ 2
set sink_(10) [new Agent/TCPSink]
$ns attach-agent $node_(61) $tcp_(10)
$ns attach-agent $node_(98) $sink_(10)
$ns connect $tcp_(10) $sink_(10)
set ftp_(10) [new Application/FTP]
$ftp_(10) attach-agent $tcp_(10)
$ns at 0.2 "$ftp_(10) start"
$ns at 180.0 "$ftp_(10) stop"

#Set a TCP connection between node_(3) and node_(93)
set tcp_(11) [new Agent/TCP/Newreno]
$tcp_(11) set class_ 2
set sink_(11) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(11)
$ns attach-agent $node_(93) $sink_(11)
$ns connect $tcp_(11) $sink_(11)
set ftp_(11) [new Application/FTP]
$ftp_(11) attach-agent $tcp_(11)
$ns at 180.2 "$ftp_(11) start"
$ns at 360.0 "$ftp_(11) stop"

#Set a TCP connection between node_(71) and node_(30)
set tcp_(12) [new Agent/TCP/Newreno]
$tcp_(12) set class_ 2
set sink_(12) [new Agent/TCPSink]
$ns attach-agent $node_(71) $tcp_(12)
$ns attach-agent $node_(30) $sink_(12)
$ns connect $tcp_(12) $sink_(12)
set ftp_(12) [new Application/FTP]
$ftp_(12) attach-agent $tcp_(12)
$ns at 360.2 "$ftp_(12) start"
$ns at 540.0 "$ftp_(12) stop"

#Set a TCP connection between node_(74) and node_(37)
set tcp_(13) [new Agent/TCP/Newreno]
$tcp_(13) set class_ 2
set sink_(13) [new Agent/TCPSink]
$ns attach-agent $node_(74) $tcp_(13)
$ns attach-agent $node_(37) $sink_(13)
$ns connect $tcp_(13) $sink_(13)
set ftp_(13) [new Application/FTP]
$ftp_(13) attach-agent $tcp_(13)
$ns at 540.2 "$ftp_(13) start"
$ns at 720.0 "$ftp_(13) stop"

#Set a TCP connection between node_(50) and node_(35)
set tcp_(14) [new Agent/TCP/Newreno]
$tcp_(14) set class_ 2
set sink_(14) [new Agent/TCPSink]
$ns attach-agent $node_(50) $tcp_(14)
$ns attach-agent $node_(35) $sink_(14)
$ns connect $tcp_(14) $sink_(14)
set ftp_(14) [new Application/FTP]
$ftp_(14) attach-agent $tcp_(14)
$ns at 720.2 "$ftp_(14) start"
$ns at 900.0 "$ftp_(14) stop"

#Set a TCP connection between node_(21) and node_(65)
set tcp_(15) [new Agent/TCP/Newreno]
$tcp_(15) set class_ 2
set sink_(15) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(15)
$ns attach-agent $node_(65) $sink_(15)
$ns connect $tcp_(15) $sink_(15)
set ftp_(15) [new Application/FTP]
$ftp_(15) attach-agent $tcp_(15)
$ns at 0.2 "$ftp_(15) start"
$ns at 180.0 "$ftp_(15) stop"

#Set a TCP connection between node_(86) and node_(58)
set tcp_(16) [new Agent/TCP/Newreno]
$tcp_(16) set class_ 2
set sink_(16) [new Agent/TCPSink]
$ns attach-agent $node_(86) $tcp_(16)
$ns attach-agent $node_(58) $sink_(16)
$ns connect $tcp_(16) $sink_(16)
set ftp_(16) [new Application/FTP]
$ftp_(16) attach-agent $tcp_(16)
$ns at 180.2 "$ftp_(16) start"
$ns at 360.0 "$ftp_(16) stop"

#Set a TCP connection between node_(87) and node_(29)
set tcp_(17) [new Agent/TCP/Newreno]
$tcp_(17) set class_ 2
set sink_(17) [new Agent/TCPSink]
$ns attach-agent $node_(87) $tcp_(17)
$ns attach-agent $node_(29) $sink_(17)
$ns connect $tcp_(17) $sink_(17)
set ftp_(17) [new Application/FTP]
$ftp_(17) attach-agent $tcp_(17)
$ns at 360.2 "$ftp_(17) start"
$ns at 540.0 "$ftp_(17) stop"

#Set a TCP connection between node_(71) and node_(94)
set tcp_(18) [new Agent/TCP/Newreno]
$tcp_(18) set class_ 2
set sink_(18) [new Agent/TCPSink]
$ns attach-agent $node_(71) $tcp_(18)
$ns attach-agent $node_(94) $sink_(18)
$ns connect $tcp_(18) $sink_(18)
set ftp_(18) [new Application/FTP]
$ftp_(18) attach-agent $tcp_(18)
$ns at 540.2 "$ftp_(18) start"
$ns at 720.0 "$ftp_(18) stop"

#Set a TCP connection between node_(42) and node_(29)
set tcp_(19) [new Agent/TCP/Newreno]
$tcp_(19) set class_ 2
set sink_(19) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(19)
$ns attach-agent $node_(29) $sink_(19)
$ns connect $tcp_(19) $sink_(19)
set ftp_(19) [new Application/FTP]
$ftp_(19) attach-agent $tcp_(19)
$ns at 720.2 "$ftp_(19) start"
$ns at 900.0 "$ftp_(19) stop"

#Set a TCP connection between node_(68) and node_(81)
set tcp_(20) [new Agent/TCP/Newreno]
$tcp_(20) set class_ 2
set sink_(20) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(20)
$ns attach-agent $node_(81) $sink_(20)
$ns connect $tcp_(20) $sink_(20)
set ftp_(20) [new Application/FTP]
$ftp_(20) attach-agent $tcp_(20)
$ns at 0.2 "$ftp_(20) start"
$ns at 180.0 "$ftp_(20) stop"

#Set a TCP connection between node_(46) and node_(41)
set tcp_(21) [new Agent/TCP/Newreno]
$tcp_(21) set class_ 2
set sink_(21) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(21)
$ns attach-agent $node_(41) $sink_(21)
$ns connect $tcp_(21) $sink_(21)
set ftp_(21) [new Application/FTP]
$ftp_(21) attach-agent $tcp_(21)
$ns at 180.2 "$ftp_(21) start"
$ns at 360.0 "$ftp_(21) stop"

#Set a TCP connection between node_(93) and node_(71)
set tcp_(22) [new Agent/TCP/Newreno]
$tcp_(22) set class_ 2
set sink_(22) [new Agent/TCPSink]
$ns attach-agent $node_(93) $tcp_(22)
$ns attach-agent $node_(71) $sink_(22)
$ns connect $tcp_(22) $sink_(22)
set ftp_(22) [new Application/FTP]
$ftp_(22) attach-agent $tcp_(22)
$ns at 360.2 "$ftp_(22) start"
$ns at 540.0 "$ftp_(22) stop"

#Set a TCP connection between node_(60) and node_(4)
set tcp_(23) [new Agent/TCP/Newreno]
$tcp_(23) set class_ 2
set sink_(23) [new Agent/TCPSink]
$ns attach-agent $node_(60) $tcp_(23)
$ns attach-agent $node_(4) $sink_(23)
$ns connect $tcp_(23) $sink_(23)
set ftp_(23) [new Application/FTP]
$ftp_(23) attach-agent $tcp_(23)
$ns at 540.2 "$ftp_(23) start"
$ns at 720.0 "$ftp_(23) stop"

#Set a TCP connection between node_(42) and node_(26)
set tcp_(24) [new Agent/TCP/Newreno]
$tcp_(24) set class_ 2
set sink_(24) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(24)
$ns attach-agent $node_(26) $sink_(24)
$ns connect $tcp_(24) $sink_(24)
set ftp_(24) [new Application/FTP]
$ftp_(24) attach-agent $tcp_(24)
$ns at 720.2 "$ftp_(24) start"
$ns at 900.0 "$ftp_(24) stop"

#Set a TCP connection between node_(89) and node_(33)
set tcp_(25) [new Agent/TCP/Newreno]
$tcp_(25) set class_ 2
set sink_(25) [new Agent/TCPSink]
$ns attach-agent $node_(89) $tcp_(25)
$ns attach-agent $node_(33) $sink_(25)
$ns connect $tcp_(25) $sink_(25)
set ftp_(25) [new Application/FTP]
$ftp_(25) attach-agent $tcp_(25)
$ns at 0.2 "$ftp_(25) start"
$ns at 180.0 "$ftp_(25) stop"

#Set a TCP connection between node_(25) and node_(85)
set tcp_(26) [new Agent/TCP/Newreno]
$tcp_(26) set class_ 2
set sink_(26) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(26)
$ns attach-agent $node_(85) $sink_(26)
$ns connect $tcp_(26) $sink_(26)
set ftp_(26) [new Application/FTP]
$ftp_(26) attach-agent $tcp_(26)
$ns at 180.2 "$ftp_(26) start"
$ns at 360.0 "$ftp_(26) stop"

#Set a TCP connection between node_(5) and node_(10)
set tcp_(27) [new Agent/TCP/Newreno]
$tcp_(27) set class_ 2
set sink_(27) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(27)
$ns attach-agent $node_(10) $sink_(27)
$ns connect $tcp_(27) $sink_(27)
set ftp_(27) [new Application/FTP]
$ftp_(27) attach-agent $tcp_(27)
$ns at 360.2 "$ftp_(27) start"
$ns at 540.0 "$ftp_(27) stop"

#Set a TCP connection between node_(22) and node_(35)
set tcp_(28) [new Agent/TCP/Newreno]
$tcp_(28) set class_ 2
set sink_(28) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(28)
$ns attach-agent $node_(35) $sink_(28)
$ns connect $tcp_(28) $sink_(28)
set ftp_(28) [new Application/FTP]
$ftp_(28) attach-agent $tcp_(28)
$ns at 540.2 "$ftp_(28) start"
$ns at 720.0 "$ftp_(28) stop"

#Set a TCP connection between node_(61) and node_(40)
set tcp_(29) [new Agent/TCP/Newreno]
$tcp_(29) set class_ 2
set sink_(29) [new Agent/TCPSink]
$ns attach-agent $node_(61) $tcp_(29)
$ns attach-agent $node_(40) $sink_(29)
$ns connect $tcp_(29) $sink_(29)
set ftp_(29) [new Application/FTP]
$ftp_(29) attach-agent $tcp_(29)
$ns at 720.2 "$ftp_(29) start"
$ns at 900.0 "$ftp_(29) stop"

#Set a TCP connection between node_(57) and node_(63)
set tcp_(30) [new Agent/TCP/Newreno]
$tcp_(30) set class_ 2
set sink_(30) [new Agent/TCPSink]
$ns attach-agent $node_(57) $tcp_(30)
$ns attach-agent $node_(63) $sink_(30)
$ns connect $tcp_(30) $sink_(30)
set ftp_(30) [new Application/FTP]
$ftp_(30) attach-agent $tcp_(30)
$ns at 0.2 "$ftp_(30) start"
$ns at 180.0 "$ftp_(30) stop"

#Set a TCP connection between node_(0) and node_(95)
set tcp_(31) [new Agent/TCP/Newreno]
$tcp_(31) set class_ 2
set sink_(31) [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp_(31)
$ns attach-agent $node_(95) $sink_(31)
$ns connect $tcp_(31) $sink_(31)
set ftp_(31) [new Application/FTP]
$ftp_(31) attach-agent $tcp_(31)
$ns at 180.2 "$ftp_(31) start"
$ns at 360.0 "$ftp_(31) stop"

#Set a TCP connection between node_(33) and node_(80)
set tcp_(32) [new Agent/TCP/Newreno]
$tcp_(32) set class_ 2
set sink_(32) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(32)
$ns attach-agent $node_(80) $sink_(32)
$ns connect $tcp_(32) $sink_(32)
set ftp_(32) [new Application/FTP]
$ftp_(32) attach-agent $tcp_(32)
$ns at 360.2 "$ftp_(32) start"
$ns at 540.0 "$ftp_(32) stop"

#Set a TCP connection between node_(86) and node_(32)
set tcp_(33) [new Agent/TCP/Newreno]
$tcp_(33) set class_ 2
set sink_(33) [new Agent/TCPSink]
$ns attach-agent $node_(86) $tcp_(33)
$ns attach-agent $node_(32) $sink_(33)
$ns connect $tcp_(33) $sink_(33)
set ftp_(33) [new Application/FTP]
$ftp_(33) attach-agent $tcp_(33)
$ns at 540.2 "$ftp_(33) start"
$ns at 720.0 "$ftp_(33) stop"

#Set a TCP connection between node_(46) and node_(81)
set tcp_(34) [new Agent/TCP/Newreno]
$tcp_(34) set class_ 2
set sink_(34) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(34)
$ns attach-agent $node_(81) $sink_(34)
$ns connect $tcp_(34) $sink_(34)
set ftp_(34) [new Application/FTP]
$ftp_(34) attach-agent $tcp_(34)
$ns at 720.2 "$ftp_(34) start"
$ns at 900.0 "$ftp_(34) stop"

#Set a TCP connection between node_(21) and node_(19)
set tcp_(35) [new Agent/TCP/Newreno]
$tcp_(35) set class_ 2
set sink_(35) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(35)
$ns attach-agent $node_(19) $sink_(35)
$ns connect $tcp_(35) $sink_(35)
set ftp_(35) [new Application/FTP]
$ftp_(35) attach-agent $tcp_(35)
$ns at 0.2 "$ftp_(35) start"
$ns at 180.0 "$ftp_(35) stop"

#Set a TCP connection between node_(4) and node_(46)
set tcp_(36) [new Agent/TCP/Newreno]
$tcp_(36) set class_ 2
set sink_(36) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(36)
$ns attach-agent $node_(46) $sink_(36)
$ns connect $tcp_(36) $sink_(36)
set ftp_(36) [new Application/FTP]
$ftp_(36) attach-agent $tcp_(36)
$ns at 180.2 "$ftp_(36) start"
$ns at 360.0 "$ftp_(36) stop"

#Set a TCP connection between node_(66) and node_(44)
set tcp_(37) [new Agent/TCP/Newreno]
$tcp_(37) set class_ 2
set sink_(37) [new Agent/TCPSink]
$ns attach-agent $node_(66) $tcp_(37)
$ns attach-agent $node_(44) $sink_(37)
$ns connect $tcp_(37) $sink_(37)
set ftp_(37) [new Application/FTP]
$ftp_(37) attach-agent $tcp_(37)
$ns at 360.2 "$ftp_(37) start"
$ns at 540.0 "$ftp_(37) stop"

#Set a TCP connection between node_(42) and node_(88)
set tcp_(38) [new Agent/TCP/Newreno]
$tcp_(38) set class_ 2
set sink_(38) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(38)
$ns attach-agent $node_(88) $sink_(38)
$ns connect $tcp_(38) $sink_(38)
set ftp_(38) [new Application/FTP]
$ftp_(38) attach-agent $tcp_(38)
$ns at 540.2 "$ftp_(38) start"
$ns at 720.0 "$ftp_(38) stop"

#Set a TCP connection between node_(23) and node_(5)
set tcp_(39) [new Agent/TCP/Newreno]
$tcp_(39) set class_ 2
set sink_(39) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(39)
$ns attach-agent $node_(5) $sink_(39)
$ns connect $tcp_(39) $sink_(39)
set ftp_(39) [new Application/FTP]
$ftp_(39) attach-agent $tcp_(39)
$ns at 720.2 "$ftp_(39) start"
$ns at 900.0 "$ftp_(39) stop"

#Set a TCP connection between node_(16) and node_(57)
set tcp_(40) [new Agent/TCP/Newreno]
$tcp_(40) set class_ 2
set sink_(40) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(40)
$ns attach-agent $node_(57) $sink_(40)
$ns connect $tcp_(40) $sink_(40)
set ftp_(40) [new Application/FTP]
$ftp_(40) attach-agent $tcp_(40)
$ns at 0.2 "$ftp_(40) start"
$ns at 180.0 "$ftp_(40) stop"

#Set a TCP connection between node_(58) and node_(76)
set tcp_(41) [new Agent/TCP/Newreno]
$tcp_(41) set class_ 2
set sink_(41) [new Agent/TCPSink]
$ns attach-agent $node_(58) $tcp_(41)
$ns attach-agent $node_(76) $sink_(41)
$ns connect $tcp_(41) $sink_(41)
set ftp_(41) [new Application/FTP]
$ftp_(41) attach-agent $tcp_(41)
$ns at 180.2 "$ftp_(41) start"
$ns at 360.0 "$ftp_(41) stop"

#Set a TCP connection between node_(1) and node_(95)
set tcp_(42) [new Agent/TCP/Newreno]
$tcp_(42) set class_ 2
set sink_(42) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(42)
$ns attach-agent $node_(95) $sink_(42)
$ns connect $tcp_(42) $sink_(42)
set ftp_(42) [new Application/FTP]
$ftp_(42) attach-agent $tcp_(42)
$ns at 360.2 "$ftp_(42) start"
$ns at 540.0 "$ftp_(42) stop"

#Set a TCP connection between node_(81) and node_(27)
set tcp_(43) [new Agent/TCP/Newreno]
$tcp_(43) set class_ 2
set sink_(43) [new Agent/TCPSink]
$ns attach-agent $node_(81) $tcp_(43)
$ns attach-agent $node_(27) $sink_(43)
$ns connect $tcp_(43) $sink_(43)
set ftp_(43) [new Application/FTP]
$ftp_(43) attach-agent $tcp_(43)
$ns at 540.2 "$ftp_(43) start"
$ns at 720.0 "$ftp_(43) stop"

#Set a TCP connection between node_(94) and node_(3)
set tcp_(44) [new Agent/TCP/Newreno]
$tcp_(44) set class_ 2
set sink_(44) [new Agent/TCPSink]
$ns attach-agent $node_(94) $tcp_(44)
$ns attach-agent $node_(3) $sink_(44)
$ns connect $tcp_(44) $sink_(44)
set ftp_(44) [new Application/FTP]
$ftp_(44) attach-agent $tcp_(44)
$ns at 720.2 "$ftp_(44) start"
$ns at 900.0 "$ftp_(44) stop"

#Set a TCP connection between node_(3) and node_(47)
set tcp_(45) [new Agent/TCP/Newreno]
$tcp_(45) set class_ 2
set sink_(45) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(45)
$ns attach-agent $node_(47) $sink_(45)
$ns connect $tcp_(45) $sink_(45)
set ftp_(45) [new Application/FTP]
$ftp_(45) attach-agent $tcp_(45)
$ns at 0.2 "$ftp_(45) start"
$ns at 180.0 "$ftp_(45) stop"

#Set a TCP connection between node_(44) and node_(93)
set tcp_(46) [new Agent/TCP/Newreno]
$tcp_(46) set class_ 2
set sink_(46) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(46)
$ns attach-agent $node_(93) $sink_(46)
$ns connect $tcp_(46) $sink_(46)
set ftp_(46) [new Application/FTP]
$ftp_(46) attach-agent $tcp_(46)
$ns at 180.2 "$ftp_(46) start"
$ns at 360.0 "$ftp_(46) stop"

#Set a TCP connection between node_(67) and node_(80)
set tcp_(47) [new Agent/TCP/Newreno]
$tcp_(47) set class_ 2
set sink_(47) [new Agent/TCPSink]
$ns attach-agent $node_(67) $tcp_(47)
$ns attach-agent $node_(80) $sink_(47)
$ns connect $tcp_(47) $sink_(47)
set ftp_(47) [new Application/FTP]
$ftp_(47) attach-agent $tcp_(47)
$ns at 360.2 "$ftp_(47) start"
$ns at 540.0 "$ftp_(47) stop"

#Set a TCP connection between node_(82) and node_(18)
set tcp_(48) [new Agent/TCP/Newreno]
$tcp_(48) set class_ 2
set sink_(48) [new Agent/TCPSink]
$ns attach-agent $node_(82) $tcp_(48)
$ns attach-agent $node_(18) $sink_(48)
$ns connect $tcp_(48) $sink_(48)
set ftp_(48) [new Application/FTP]
$ftp_(48) attach-agent $tcp_(48)
$ns at 540.2 "$ftp_(48) start"
$ns at 720.0 "$ftp_(48) stop"

#Set a TCP connection between node_(61) and node_(50)
set tcp_(49) [new Agent/TCP/Newreno]
$tcp_(49) set class_ 2
set sink_(49) [new Agent/TCPSink]
$ns attach-agent $node_(61) $tcp_(49)
$ns attach-agent $node_(50) $sink_(49)
$ns connect $tcp_(49) $sink_(49)
set ftp_(49) [new Application/FTP]
$ftp_(49) attach-agent $tcp_(49)
$ns at 720.2 "$ftp_(49) start"
$ns at 900.0 "$ftp_(49) stop"

#Set a TCP connection between node_(54) and node_(35)
set tcp_(50) [new Agent/TCP/Newreno]
$tcp_(50) set class_ 2
set sink_(50) [new Agent/TCPSink]
$ns attach-agent $node_(54) $tcp_(50)
$ns attach-agent $node_(35) $sink_(50)
$ns connect $tcp_(50) $sink_(50)
set ftp_(50) [new Application/FTP]
$ftp_(50) attach-agent $tcp_(50)
$ns at 0.2 "$ftp_(50) start"
$ns at 180.0 "$ftp_(50) stop"

#Set a TCP connection between node_(45) and node_(28)
set tcp_(51) [new Agent/TCP/Newreno]
$tcp_(51) set class_ 2
set sink_(51) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(51)
$ns attach-agent $node_(28) $sink_(51)
$ns connect $tcp_(51) $sink_(51)
set ftp_(51) [new Application/FTP]
$ftp_(51) attach-agent $tcp_(51)
$ns at 180.2 "$ftp_(51) start"
$ns at 360.0 "$ftp_(51) stop"

#Set a TCP connection between node_(86) and node_(79)
set tcp_(52) [new Agent/TCP/Newreno]
$tcp_(52) set class_ 2
set sink_(52) [new Agent/TCPSink]
$ns attach-agent $node_(86) $tcp_(52)
$ns attach-agent $node_(79) $sink_(52)
$ns connect $tcp_(52) $sink_(52)
set ftp_(52) [new Application/FTP]
$ftp_(52) attach-agent $tcp_(52)
$ns at 360.2 "$ftp_(52) start"
$ns at 540.0 "$ftp_(52) stop"

#Set a TCP connection between node_(24) and node_(85)
set tcp_(53) [new Agent/TCP/Newreno]
$tcp_(53) set class_ 2
set sink_(53) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(53)
$ns attach-agent $node_(85) $sink_(53)
$ns connect $tcp_(53) $sink_(53)
set ftp_(53) [new Application/FTP]
$ftp_(53) attach-agent $tcp_(53)
$ns at 540.2 "$ftp_(53) start"
$ns at 720.0 "$ftp_(53) stop"

#Set a TCP connection between node_(5) and node_(15)
set tcp_(54) [new Agent/TCP/Newreno]
$tcp_(54) set class_ 2
set sink_(54) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(54)
$ns attach-agent $node_(15) $sink_(54)
$ns connect $tcp_(54) $sink_(54)
set ftp_(54) [new Application/FTP]
$ftp_(54) attach-agent $tcp_(54)
$ns at 720.2 "$ftp_(54) start"
$ns at 900.0 "$ftp_(54) stop"

#Set a TCP connection between node_(58) and node_(69)
set tcp_(55) [new Agent/TCP/Newreno]
$tcp_(55) set class_ 2
set sink_(55) [new Agent/TCPSink]
$ns attach-agent $node_(58) $tcp_(55)
$ns attach-agent $node_(69) $sink_(55)
$ns connect $tcp_(55) $sink_(55)
set ftp_(55) [new Application/FTP]
$ftp_(55) attach-agent $tcp_(55)
$ns at 0.2 "$ftp_(55) start"
$ns at 180.0 "$ftp_(55) stop"

#Set a TCP connection between node_(65) and node_(55)
set tcp_(56) [new Agent/TCP/Newreno]
$tcp_(56) set class_ 2
set sink_(56) [new Agent/TCPSink]
$ns attach-agent $node_(65) $tcp_(56)
$ns attach-agent $node_(55) $sink_(56)
$ns connect $tcp_(56) $sink_(56)
set ftp_(56) [new Application/FTP]
$ftp_(56) attach-agent $tcp_(56)
$ns at 180.2 "$ftp_(56) start"
$ns at 360.0 "$ftp_(56) stop"

#Set a TCP connection between node_(4) and node_(22)
set tcp_(57) [new Agent/TCP/Newreno]
$tcp_(57) set class_ 2
set sink_(57) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(57)
$ns attach-agent $node_(22) $sink_(57)
$ns connect $tcp_(57) $sink_(57)
set ftp_(57) [new Application/FTP]
$ftp_(57) attach-agent $tcp_(57)
$ns at 360.2 "$ftp_(57) start"
$ns at 540.0 "$ftp_(57) stop"

#Set a TCP connection between node_(89) and node_(26)
set tcp_(58) [new Agent/TCP/Newreno]
$tcp_(58) set class_ 2
set sink_(58) [new Agent/TCPSink]
$ns attach-agent $node_(89) $tcp_(58)
$ns attach-agent $node_(26) $sink_(58)
$ns connect $tcp_(58) $sink_(58)
set ftp_(58) [new Application/FTP]
$ftp_(58) attach-agent $tcp_(58)
$ns at 540.2 "$ftp_(58) start"
$ns at 720.0 "$ftp_(58) stop"

#Set a TCP connection between node_(40) and node_(20)
set tcp_(59) [new Agent/TCP/Newreno]
$tcp_(59) set class_ 2
set sink_(59) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(59)
$ns attach-agent $node_(20) $sink_(59)
$ns connect $tcp_(59) $sink_(59)
set ftp_(59) [new Application/FTP]
$ftp_(59) attach-agent $tcp_(59)
$ns at 720.2 "$ftp_(59) start"
$ns at 900.0 "$ftp_(59) stop"

#Set a TCP connection between node_(68) and node_(55)
set tcp_(60) [new Agent/TCP/Newreno]
$tcp_(60) set class_ 2
set sink_(60) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(60)
$ns attach-agent $node_(55) $sink_(60)
$ns connect $tcp_(60) $sink_(60)
set ftp_(60) [new Application/FTP]
$ftp_(60) attach-agent $tcp_(60)
$ns at 0.2 "$ftp_(60) start"
$ns at 180.0 "$ftp_(60) stop"

#Set a TCP connection between node_(42) and node_(86)
set tcp_(61) [new Agent/TCP/Newreno]
$tcp_(61) set class_ 2
set sink_(61) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(61)
$ns attach-agent $node_(86) $sink_(61)
$ns connect $tcp_(61) $sink_(61)
set ftp_(61) [new Application/FTP]
$ftp_(61) attach-agent $tcp_(61)
$ns at 180.2 "$ftp_(61) start"
$ns at 360.0 "$ftp_(61) stop"

#Set a TCP connection between node_(59) and node_(51)
set tcp_(62) [new Agent/TCP/Newreno]
$tcp_(62) set class_ 2
set sink_(62) [new Agent/TCPSink]
$ns attach-agent $node_(59) $tcp_(62)
$ns attach-agent $node_(51) $sink_(62)
$ns connect $tcp_(62) $sink_(62)
set ftp_(62) [new Application/FTP]
$ftp_(62) attach-agent $tcp_(62)
$ns at 360.2 "$ftp_(62) start"
$ns at 540.0 "$ftp_(62) stop"

#Set a TCP connection between node_(46) and node_(65)
set tcp_(63) [new Agent/TCP/Newreno]
$tcp_(63) set class_ 2
set sink_(63) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(63)
$ns attach-agent $node_(65) $sink_(63)
$ns connect $tcp_(63) $sink_(63)
set ftp_(63) [new Application/FTP]
$ftp_(63) attach-agent $tcp_(63)
$ns at 540.2 "$ftp_(63) start"
$ns at 720.0 "$ftp_(63) stop"

#Set a TCP connection between node_(56) and node_(25)
set tcp_(64) [new Agent/TCP/Newreno]
$tcp_(64) set class_ 2
set sink_(64) [new Agent/TCPSink]
$ns attach-agent $node_(56) $tcp_(64)
$ns attach-agent $node_(25) $sink_(64)
$ns connect $tcp_(64) $sink_(64)
set ftp_(64) [new Application/FTP]
$ftp_(64) attach-agent $tcp_(64)
$ns at 720.2 "$ftp_(64) start"
$ns at 900.0 "$ftp_(64) stop"

#Set a TCP connection between node_(51) and node_(48)
set tcp_(65) [new Agent/TCP/Newreno]
$tcp_(65) set class_ 2
set sink_(65) [new Agent/TCPSink]
$ns attach-agent $node_(51) $tcp_(65)
$ns attach-agent $node_(48) $sink_(65)
$ns connect $tcp_(65) $sink_(65)
set ftp_(65) [new Application/FTP]
$ftp_(65) attach-agent $tcp_(65)
$ns at 0.2 "$ftp_(65) start"
$ns at 180.0 "$ftp_(65) stop"

#Set a TCP connection between node_(55) and node_(45)
set tcp_(66) [new Agent/TCP/Newreno]
$tcp_(66) set class_ 2
set sink_(66) [new Agent/TCPSink]
$ns attach-agent $node_(55) $tcp_(66)
$ns attach-agent $node_(45) $sink_(66)
$ns connect $tcp_(66) $sink_(66)
set ftp_(66) [new Application/FTP]
$ftp_(66) attach-agent $tcp_(66)
$ns at 180.2 "$ftp_(66) start"
$ns at 360.0 "$ftp_(66) stop"

#Set a TCP connection between node_(44) and node_(30)
set tcp_(67) [new Agent/TCP/Newreno]
$tcp_(67) set class_ 2
set sink_(67) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(67)
$ns attach-agent $node_(30) $sink_(67)
$ns connect $tcp_(67) $sink_(67)
set ftp_(67) [new Application/FTP]
$ftp_(67) attach-agent $tcp_(67)
$ns at 360.2 "$ftp_(67) start"
$ns at 540.0 "$ftp_(67) stop"

#Set a TCP connection between node_(96) and node_(88)
set tcp_(68) [new Agent/TCP/Newreno]
$tcp_(68) set class_ 2
set sink_(68) [new Agent/TCPSink]
$ns attach-agent $node_(96) $tcp_(68)
$ns attach-agent $node_(88) $sink_(68)
$ns connect $tcp_(68) $sink_(68)
set ftp_(68) [new Application/FTP]
$ftp_(68) attach-agent $tcp_(68)
$ns at 540.2 "$ftp_(68) start"
$ns at 720.0 "$ftp_(68) stop"

#Set a TCP connection between node_(43) and node_(37)
set tcp_(69) [new Agent/TCP/Newreno]
$tcp_(69) set class_ 2
set sink_(69) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(69)
$ns attach-agent $node_(37) $sink_(69)
$ns connect $tcp_(69) $sink_(69)
set ftp_(69) [new Application/FTP]
$ftp_(69) attach-agent $tcp_(69)
$ns at 720.2 "$ftp_(69) start"
$ns at 900.0 "$ftp_(69) stop"

#Set a TCP connection between node_(68) and node_(60)
set tcp_(70) [new Agent/TCP/Newreno]
$tcp_(70) set class_ 2
set sink_(70) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(70)
$ns attach-agent $node_(60) $sink_(70)
$ns connect $tcp_(70) $sink_(70)
set ftp_(70) [new Application/FTP]
$ftp_(70) attach-agent $tcp_(70)
$ns at 0.2 "$ftp_(70) start"
$ns at 180.0 "$ftp_(70) stop"

#Set a TCP connection between node_(30) and node_(85)
set tcp_(71) [new Agent/TCP/Newreno]
$tcp_(71) set class_ 2
set sink_(71) [new Agent/TCPSink]
$ns attach-agent $node_(30) $tcp_(71)
$ns attach-agent $node_(85) $sink_(71)
$ns connect $tcp_(71) $sink_(71)
set ftp_(71) [new Application/FTP]
$ftp_(71) attach-agent $tcp_(71)
$ns at 180.2 "$ftp_(71) start"
$ns at 360.0 "$ftp_(71) stop"

#Set a TCP connection between node_(23) and node_(18)
set tcp_(72) [new Agent/TCP/Newreno]
$tcp_(72) set class_ 2
set sink_(72) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(72)
$ns attach-agent $node_(18) $sink_(72)
$ns connect $tcp_(72) $sink_(72)
set ftp_(72) [new Application/FTP]
$ftp_(72) attach-agent $tcp_(72)
$ns at 360.2 "$ftp_(72) start"
$ns at 540.0 "$ftp_(72) stop"

#Set a TCP connection between node_(96) and node_(35)
set tcp_(73) [new Agent/TCP/Newreno]
$tcp_(73) set class_ 2
set sink_(73) [new Agent/TCPSink]
$ns attach-agent $node_(96) $tcp_(73)
$ns attach-agent $node_(35) $sink_(73)
$ns connect $tcp_(73) $sink_(73)
set ftp_(73) [new Application/FTP]
$ftp_(73) attach-agent $tcp_(73)
$ns at 540.2 "$ftp_(73) start"
$ns at 720.0 "$ftp_(73) stop"

#Set a TCP connection between node_(8) and node_(24)
set tcp_(74) [new Agent/TCP/Newreno]
$tcp_(74) set class_ 2
set sink_(74) [new Agent/TCPSink]
$ns attach-agent $node_(8) $tcp_(74)
$ns attach-agent $node_(24) $sink_(74)
$ns connect $tcp_(74) $sink_(74)
set ftp_(74) [new Application/FTP]
$ftp_(74) attach-agent $tcp_(74)
$ns at 720.2 "$ftp_(74) start"
$ns at 900.0 "$ftp_(74) stop"

#Set a TCP connection between node_(31) and node_(1)
set tcp_(75) [new Agent/TCP/Newreno]
$tcp_(75) set class_ 2
set sink_(75) [new Agent/TCPSink]
$ns attach-agent $node_(31) $tcp_(75)
$ns attach-agent $node_(1) $sink_(75)
$ns connect $tcp_(75) $sink_(75)
set ftp_(75) [new Application/FTP]
$ftp_(75) attach-agent $tcp_(75)
$ns at 0.2 "$ftp_(75) start"
$ns at 180.0 "$ftp_(75) stop"

#Set a TCP connection between node_(11) and node_(95)
set tcp_(76) [new Agent/TCP/Newreno]
$tcp_(76) set class_ 2
set sink_(76) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(76)
$ns attach-agent $node_(95) $sink_(76)
$ns connect $tcp_(76) $sink_(76)
set ftp_(76) [new Application/FTP]
$ftp_(76) attach-agent $tcp_(76)
$ns at 180.2 "$ftp_(76) start"
$ns at 360.0 "$ftp_(76) stop"

#Set a TCP connection between node_(42) and node_(14)
set tcp_(77) [new Agent/TCP/Newreno]
$tcp_(77) set class_ 2
set sink_(77) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(77)
$ns attach-agent $node_(14) $sink_(77)
$ns connect $tcp_(77) $sink_(77)
set ftp_(77) [new Application/FTP]
$ftp_(77) attach-agent $tcp_(77)
$ns at 360.2 "$ftp_(77) start"
$ns at 540.0 "$ftp_(77) stop"

#Set a TCP connection between node_(86) and node_(88)
set tcp_(78) [new Agent/TCP/Newreno]
$tcp_(78) set class_ 2
set sink_(78) [new Agent/TCPSink]
$ns attach-agent $node_(86) $tcp_(78)
$ns attach-agent $node_(88) $sink_(78)
$ns connect $tcp_(78) $sink_(78)
set ftp_(78) [new Application/FTP]
$ftp_(78) attach-agent $tcp_(78)
$ns at 540.2 "$ftp_(78) start"
$ns at 720.0 "$ftp_(78) stop"

#Set a TCP connection between node_(70) and node_(50)
set tcp_(79) [new Agent/TCP/Newreno]
$tcp_(79) set class_ 2
set sink_(79) [new Agent/TCPSink]
$ns attach-agent $node_(70) $tcp_(79)
$ns attach-agent $node_(50) $sink_(79)
$ns connect $tcp_(79) $sink_(79)
set ftp_(79) [new Application/FTP]
$ftp_(79) attach-agent $tcp_(79)
$ns at 720.2 "$ftp_(79) start"
$ns at 900.0 "$ftp_(79) stop"

#Set a TCP connection between node_(78) and node_(76)
set tcp_(80) [new Agent/TCP/Newreno]
$tcp_(80) set class_ 2
set sink_(80) [new Agent/TCPSink]
$ns attach-agent $node_(78) $tcp_(80)
$ns attach-agent $node_(76) $sink_(80)
$ns connect $tcp_(80) $sink_(80)
set ftp_(80) [new Application/FTP]
$ftp_(80) attach-agent $tcp_(80)
$ns at 0.2 "$ftp_(80) start"
$ns at 180.0 "$ftp_(80) stop"

#Set a TCP connection between node_(26) and node_(85)
set tcp_(81) [new Agent/TCP/Newreno]
$tcp_(81) set class_ 2
set sink_(81) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(81)
$ns attach-agent $node_(85) $sink_(81)
$ns connect $tcp_(81) $sink_(81)
set ftp_(81) [new Application/FTP]
$ftp_(81) attach-agent $tcp_(81)
$ns at 180.2 "$ftp_(81) start"
$ns at 360.0 "$ftp_(81) stop"

#Set a TCP connection between node_(25) and node_(39)
set tcp_(82) [new Agent/TCP/Newreno]
$tcp_(82) set class_ 2
set sink_(82) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(82)
$ns attach-agent $node_(39) $sink_(82)
$ns connect $tcp_(82) $sink_(82)
set ftp_(82) [new Application/FTP]
$ftp_(82) attach-agent $tcp_(82)
$ns at 360.2 "$ftp_(82) start"
$ns at 540.0 "$ftp_(82) stop"

#Set a TCP connection between node_(85) and node_(41)
set tcp_(83) [new Agent/TCP/Newreno]
$tcp_(83) set class_ 2
set sink_(83) [new Agent/TCPSink]
$ns attach-agent $node_(85) $tcp_(83)
$ns attach-agent $node_(41) $sink_(83)
$ns connect $tcp_(83) $sink_(83)
set ftp_(83) [new Application/FTP]
$ftp_(83) attach-agent $tcp_(83)
$ns at 540.2 "$ftp_(83) start"
$ns at 720.0 "$ftp_(83) stop"

#Set a TCP connection between node_(51) and node_(84)
set tcp_(84) [new Agent/TCP/Newreno]
$tcp_(84) set class_ 2
set sink_(84) [new Agent/TCPSink]
$ns attach-agent $node_(51) $tcp_(84)
$ns attach-agent $node_(84) $sink_(84)
$ns connect $tcp_(84) $sink_(84)
set ftp_(84) [new Application/FTP]
$ftp_(84) attach-agent $tcp_(84)
$ns at 720.2 "$ftp_(84) start"
$ns at 900.0 "$ftp_(84) stop"

#Set a TCP connection between node_(91) and node_(29)
set tcp_(85) [new Agent/TCP/Newreno]
$tcp_(85) set class_ 2
set sink_(85) [new Agent/TCPSink]
$ns attach-agent $node_(91) $tcp_(85)
$ns attach-agent $node_(29) $sink_(85)
$ns connect $tcp_(85) $sink_(85)
set ftp_(85) [new Application/FTP]
$ftp_(85) attach-agent $tcp_(85)
$ns at 0.2 "$ftp_(85) start"
$ns at 180.0 "$ftp_(85) stop"

#Set a TCP connection between node_(43) and node_(22)
set tcp_(86) [new Agent/TCP/Newreno]
$tcp_(86) set class_ 2
set sink_(86) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(86)
$ns attach-agent $node_(22) $sink_(86)
$ns connect $tcp_(86) $sink_(86)
set ftp_(86) [new Application/FTP]
$ftp_(86) attach-agent $tcp_(86)
$ns at 180.2 "$ftp_(86) start"
$ns at 360.0 "$ftp_(86) stop"

#Set a TCP connection between node_(22) and node_(23)
set tcp_(87) [new Agent/TCP/Newreno]
$tcp_(87) set class_ 2
set sink_(87) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(87)
$ns attach-agent $node_(23) $sink_(87)
$ns connect $tcp_(87) $sink_(87)
set ftp_(87) [new Application/FTP]
$ftp_(87) attach-agent $tcp_(87)
$ns at 360.2 "$ftp_(87) start"
$ns at 540.0 "$ftp_(87) stop"

#Set a TCP connection between node_(95) and node_(65)
set tcp_(88) [new Agent/TCP/Newreno]
$tcp_(88) set class_ 2
set sink_(88) [new Agent/TCPSink]
$ns attach-agent $node_(95) $tcp_(88)
$ns attach-agent $node_(65) $sink_(88)
$ns connect $tcp_(88) $sink_(88)
set ftp_(88) [new Application/FTP]
$ftp_(88) attach-agent $tcp_(88)
$ns at 540.2 "$ftp_(88) start"
$ns at 720.0 "$ftp_(88) stop"

#Set a TCP connection between node_(62) and node_(85)
set tcp_(89) [new Agent/TCP/Newreno]
$tcp_(89) set class_ 2
set sink_(89) [new Agent/TCPSink]
$ns attach-agent $node_(62) $tcp_(89)
$ns attach-agent $node_(85) $sink_(89)
$ns connect $tcp_(89) $sink_(89)
set ftp_(89) [new Application/FTP]
$ftp_(89) attach-agent $tcp_(89)
$ns at 720.2 "$ftp_(89) start"
$ns at 900.0 "$ftp_(89) stop"

#Set a TCP connection between node_(61) and node_(42)
set tcp_(90) [new Agent/TCP/Newreno]
$tcp_(90) set class_ 2
set sink_(90) [new Agent/TCPSink]
$ns attach-agent $node_(61) $tcp_(90)
$ns attach-agent $node_(42) $sink_(90)
$ns connect $tcp_(90) $sink_(90)
set ftp_(90) [new Application/FTP]
$ftp_(90) attach-agent $tcp_(90)
$ns at 0.2 "$ftp_(90) start"
$ns at 180.0 "$ftp_(90) stop"

#Set a TCP connection between node_(80) and node_(4)
set tcp_(91) [new Agent/TCP/Newreno]
$tcp_(91) set class_ 2
set sink_(91) [new Agent/TCPSink]
$ns attach-agent $node_(80) $tcp_(91)
$ns attach-agent $node_(4) $sink_(91)
$ns connect $tcp_(91) $sink_(91)
set ftp_(91) [new Application/FTP]
$ftp_(91) attach-agent $tcp_(91)
$ns at 180.2 "$ftp_(91) start"
$ns at 360.0 "$ftp_(91) stop"

#Set a TCP connection between node_(89) and node_(66)
set tcp_(92) [new Agent/TCP/Newreno]
$tcp_(92) set class_ 2
set sink_(92) [new Agent/TCPSink]
$ns attach-agent $node_(89) $tcp_(92)
$ns attach-agent $node_(66) $sink_(92)
$ns connect $tcp_(92) $sink_(92)
set ftp_(92) [new Application/FTP]
$ftp_(92) attach-agent $tcp_(92)
$ns at 360.2 "$ftp_(92) start"
$ns at 540.0 "$ftp_(92) stop"

#Set a TCP connection between node_(3) and node_(87)
set tcp_(93) [new Agent/TCP/Newreno]
$tcp_(93) set class_ 2
set sink_(93) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(93)
$ns attach-agent $node_(87) $sink_(93)
$ns connect $tcp_(93) $sink_(93)
set ftp_(93) [new Application/FTP]
$ftp_(93) attach-agent $tcp_(93)
$ns at 540.2 "$ftp_(93) start"
$ns at 720.0 "$ftp_(93) stop"

#Set a TCP connection between node_(61) and node_(37)
set tcp_(94) [new Agent/TCP/Newreno]
$tcp_(94) set class_ 2
set sink_(94) [new Agent/TCPSink]
$ns attach-agent $node_(61) $tcp_(94)
$ns attach-agent $node_(37) $sink_(94)
$ns connect $tcp_(94) $sink_(94)
set ftp_(94) [new Application/FTP]
$ftp_(94) attach-agent $tcp_(94)
$ns at 720.2 "$ftp_(94) start"
$ns at 900.0 "$ftp_(94) stop"

#Set a TCP connection between node_(50) and node_(53)
set tcp_(95) [new Agent/TCP/Newreno]
$tcp_(95) set class_ 2
set sink_(95) [new Agent/TCPSink]
$ns attach-agent $node_(50) $tcp_(95)
$ns attach-agent $node_(53) $sink_(95)
$ns connect $tcp_(95) $sink_(95)
set ftp_(95) [new Application/FTP]
$ftp_(95) attach-agent $tcp_(95)
$ns at 0.2 "$ftp_(95) start"
$ns at 180.0 "$ftp_(95) stop"

#Set a TCP connection between node_(68) and node_(59)
set tcp_(96) [new Agent/TCP/Newreno]
$tcp_(96) set class_ 2
set sink_(96) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(96)
$ns attach-agent $node_(59) $sink_(96)
$ns connect $tcp_(96) $sink_(96)
set ftp_(96) [new Application/FTP]
$ftp_(96) attach-agent $tcp_(96)
$ns at 180.2 "$ftp_(96) start"
$ns at 360.0 "$ftp_(96) stop"

#Set a TCP connection between node_(6) and node_(80)
set tcp_(97) [new Agent/TCP/Newreno]
$tcp_(97) set class_ 2
set sink_(97) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(97)
$ns attach-agent $node_(80) $sink_(97)
$ns connect $tcp_(97) $sink_(97)
set ftp_(97) [new Application/FTP]
$ftp_(97) attach-agent $tcp_(97)
$ns at 360.2 "$ftp_(97) start"
$ns at 540.0 "$ftp_(97) stop"

#Set a TCP connection between node_(8) and node_(13)
set tcp_(98) [new Agent/TCP/Newreno]
$tcp_(98) set class_ 2
set sink_(98) [new Agent/TCPSink]
$ns attach-agent $node_(8) $tcp_(98)
$ns attach-agent $node_(13) $sink_(98)
$ns connect $tcp_(98) $sink_(98)
set ftp_(98) [new Application/FTP]
$ftp_(98) attach-agent $tcp_(98)
$ns at 540.2 "$ftp_(98) start"
$ns at 720.0 "$ftp_(98) stop"

#Set a TCP connection between node_(69) and node_(24)
set tcp_(99) [new Agent/TCP/Newreno]
$tcp_(99) set class_ 2
set sink_(99) [new Agent/TCPSink]
$ns attach-agent $node_(69) $tcp_(99)
$ns attach-agent $node_(24) $sink_(99)
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
