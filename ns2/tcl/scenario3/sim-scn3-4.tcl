#sim-scn3-4.tcl 
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
set tracefd       [open sim-scn3-4-$val(rp)-trace.tr w]
set windowVsTime2 [open sim-scn3-4-$val(rp)-win-.tr w]
set namtrace      [open sim-scn3-4-$val(rp).nam w]

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
$node_(0) set X_ 1289 
$node_(0) set Y_ 877 
$node_(0) set Z_ 0.0 
$node_(1) set X_ 1442 
$node_(1) set Y_ 217 
$node_(1) set Z_ 0.0 
$node_(2) set X_ 2779 
$node_(2) set Y_ 102 
$node_(2) set Z_ 0.0 
$node_(3) set X_ 2121 
$node_(3) set Y_ 876 
$node_(3) set Z_ 0.0 
$node_(4) set X_ 2078 
$node_(4) set Y_ 504 
$node_(4) set Z_ 0.0 
$node_(5) set X_ 1168 
$node_(5) set Y_ 440 
$node_(5) set Z_ 0.0 
$node_(6) set X_ 501 
$node_(6) set Y_ 114 
$node_(6) set Z_ 0.0 
$node_(7) set X_ 1830 
$node_(7) set Y_ 715 
$node_(7) set Z_ 0.0 
$node_(8) set X_ 2622 
$node_(8) set Y_ 604 
$node_(8) set Z_ 0.0 
$node_(9) set X_ 1900 
$node_(9) set Y_ 925 
$node_(9) set Z_ 0.0 
$node_(10) set X_ 1717 
$node_(10) set Y_ 534 
$node_(10) set Z_ 0.0 
$node_(11) set X_ 2770 
$node_(11) set Y_ 198 
$node_(11) set Z_ 0.0 
$node_(12) set X_ 586 
$node_(12) set Y_ 866 
$node_(12) set Z_ 0.0 
$node_(13) set X_ 1814 
$node_(13) set Y_ 107 
$node_(13) set Z_ 0.0 
$node_(14) set X_ 1344 
$node_(14) set Y_ 989 
$node_(14) set Z_ 0.0 
$node_(15) set X_ 1377 
$node_(15) set Y_ 786 
$node_(15) set Z_ 0.0 
$node_(16) set X_ 1241 
$node_(16) set Y_ 200 
$node_(16) set Z_ 0.0 
$node_(17) set X_ 2234 
$node_(17) set Y_ 680 
$node_(17) set Z_ 0.0 
$node_(18) set X_ 2046 
$node_(18) set Y_ 165 
$node_(18) set Z_ 0.0 
$node_(19) set X_ 1461 
$node_(19) set Y_ 937 
$node_(19) set Z_ 0.0 
$node_(20) set X_ 970 
$node_(20) set Y_ 407 
$node_(20) set Z_ 0.0 
$node_(21) set X_ 1190 
$node_(21) set Y_ 732 
$node_(21) set Z_ 0.0 
$node_(22) set X_ 1461 
$node_(22) set Y_ 270 
$node_(22) set Z_ 0.0 
$node_(23) set X_ 732 
$node_(23) set Y_ 604 
$node_(23) set Z_ 0.0 
$node_(24) set X_ 1628 
$node_(24) set Y_ 119 
$node_(24) set Z_ 0.0 
$node_(25) set X_ 1041 
$node_(25) set Y_ 999 
$node_(25) set Z_ 0.0 
$node_(26) set X_ 1323 
$node_(26) set Y_ 785 
$node_(26) set Z_ 0.0 
$node_(27) set X_ 2390 
$node_(27) set Y_ 780 
$node_(27) set Z_ 0.0 
$node_(28) set X_ 1268 
$node_(28) set Y_ 357 
$node_(28) set Z_ 0.0 
$node_(29) set X_ 616 
$node_(29) set Y_ 407 
$node_(29) set Z_ 0.0 
$node_(30) set X_ 851 
$node_(30) set Y_ 490 
$node_(30) set Z_ 0.0 
$node_(31) set X_ 98 
$node_(31) set Y_ 886 
$node_(31) set Z_ 0.0 
$node_(32) set X_ 470 
$node_(32) set Y_ 331 
$node_(32) set Z_ 0.0 
$node_(33) set X_ 38 
$node_(33) set Y_ 313 
$node_(33) set Z_ 0.0 
$node_(34) set X_ 518 
$node_(34) set Y_ 999 
$node_(34) set Z_ 0.0 
$node_(35) set X_ 2399 
$node_(35) set Y_ 51 
$node_(35) set Z_ 0.0 
$node_(36) set X_ 1270 
$node_(36) set Y_ 339 
$node_(36) set Z_ 0.0 
$node_(37) set X_ 2172 
$node_(37) set Y_ 146 
$node_(37) set Z_ 0.0 
$node_(38) set X_ 1082 
$node_(38) set Y_ 301 
$node_(38) set Z_ 0.0 
$node_(39) set X_ 1369 
$node_(39) set Y_ 581 
$node_(39) set Z_ 0.0 
$node_(40) set X_ 444 
$node_(40) set Y_ 882 
$node_(40) set Z_ 0.0 
$node_(41) set X_ 1389 
$node_(41) set Y_ 354 
$node_(41) set Z_ 0.0 
$node_(42) set X_ 1487 
$node_(42) set Y_ 39 
$node_(42) set Z_ 0.0 
$node_(43) set X_ 1090 
$node_(43) set Y_ 183 
$node_(43) set Z_ 0.0 
$node_(44) set X_ 628 
$node_(44) set Y_ 352 
$node_(44) set Z_ 0.0 
$node_(45) set X_ 2061 
$node_(45) set Y_ 839 
$node_(45) set Z_ 0.0 
$node_(46) set X_ 23 
$node_(46) set Y_ 514 
$node_(46) set Z_ 0.0 
$node_(47) set X_ 224 
$node_(47) set Y_ 721 
$node_(47) set Z_ 0.0 
$node_(48) set X_ 536 
$node_(48) set Y_ 914 
$node_(48) set Z_ 0.0 
$node_(49) set X_ 1989 
$node_(49) set Y_ 311 
$node_(49) set Z_ 0.0 
$node_(50) set X_ 842 
$node_(50) set Y_ 661 
$node_(50) set Z_ 0.0 
$node_(51) set X_ 771 
$node_(51) set Y_ 579 
$node_(51) set Z_ 0.0 
$node_(52) set X_ 1256 
$node_(52) set Y_ 443 
$node_(52) set Z_ 0.0 
$node_(53) set X_ 2689 
$node_(53) set Y_ 227 
$node_(53) set Z_ 0.0 
$node_(54) set X_ 1730 
$node_(54) set Y_ 471 
$node_(54) set Z_ 0.0 
$node_(55) set X_ 1804 
$node_(55) set Y_ 915 
$node_(55) set Z_ 0.0 
$node_(56) set X_ 387 
$node_(56) set Y_ 627 
$node_(56) set Z_ 0.0 
$node_(57) set X_ 1213 
$node_(57) set Y_ 250 
$node_(57) set Z_ 0.0 
$node_(58) set X_ 2726 
$node_(58) set Y_ 618 
$node_(58) set Z_ 0.0 
$node_(59) set X_ 746 
$node_(59) set Y_ 367 
$node_(59) set Z_ 0.0 
$node_(60) set X_ 499 
$node_(60) set Y_ 601 
$node_(60) set Z_ 0.0 
$node_(61) set X_ 2961 
$node_(61) set Y_ 399 
$node_(61) set Z_ 0.0 
$node_(62) set X_ 985 
$node_(62) set Y_ 252 
$node_(62) set Z_ 0.0 
$node_(63) set X_ 1491 
$node_(63) set Y_ 998 
$node_(63) set Z_ 0.0 
$node_(64) set X_ 2167 
$node_(64) set Y_ 720 
$node_(64) set Z_ 0.0 
$node_(65) set X_ 2635 
$node_(65) set Y_ 313 
$node_(65) set Z_ 0.0 
$node_(66) set X_ 988 
$node_(66) set Y_ 224 
$node_(66) set Z_ 0.0 
$node_(67) set X_ 2443 
$node_(67) set Y_ 554 
$node_(67) set Z_ 0.0 
$node_(68) set X_ 581 
$node_(68) set Y_ 349 
$node_(68) set Z_ 0.0 
$node_(69) set X_ 1296 
$node_(69) set Y_ 310 
$node_(69) set Z_ 0.0 
$node_(70) set X_ 982 
$node_(70) set Y_ 211 
$node_(70) set Z_ 0.0 
$node_(71) set X_ 1260 
$node_(71) set Y_ 309 
$node_(71) set Z_ 0.0 
$node_(72) set X_ 2470 
$node_(72) set Y_ 766 
$node_(72) set Z_ 0.0 
$node_(73) set X_ 2203 
$node_(73) set Y_ 173 
$node_(73) set Z_ 0.0 
$node_(74) set X_ 1262 
$node_(74) set Y_ 490 
$node_(74) set Z_ 0.0 
$node_(75) set X_ 2883 
$node_(75) set Y_ 70 
$node_(75) set Z_ 0.0 
$node_(76) set X_ 2834 
$node_(76) set Y_ 549 
$node_(76) set Z_ 0.0 
$node_(77) set X_ 847 
$node_(77) set Y_ 813 
$node_(77) set Z_ 0.0 
$node_(78) set X_ 2673 
$node_(78) set Y_ 347 
$node_(78) set Z_ 0.0 
$node_(79) set X_ 138 
$node_(79) set Y_ 126 
$node_(79) set Z_ 0.0 
$node_(80) set X_ 2746 
$node_(80) set Y_ 64 
$node_(80) set Z_ 0.0 
$node_(81) set X_ 394 
$node_(81) set Y_ 273 
$node_(81) set Z_ 0.0 
$node_(82) set X_ 449 
$node_(82) set Y_ 352 
$node_(82) set Z_ 0.0 
$node_(83) set X_ 1991 
$node_(83) set Y_ 208 
$node_(83) set Z_ 0.0 
$node_(84) set X_ 198 
$node_(84) set Y_ 908 
$node_(84) set Z_ 0.0 
$node_(85) set X_ 444 
$node_(85) set Y_ 714 
$node_(85) set Z_ 0.0 
$node_(86) set X_ 261 
$node_(86) set Y_ 6 
$node_(86) set Z_ 0.0 
$node_(87) set X_ 2242 
$node_(87) set Y_ 742 
$node_(87) set Z_ 0.0 
$node_(88) set X_ 755 
$node_(88) set Y_ 433 
$node_(88) set Z_ 0.0 
$node_(89) set X_ 813 
$node_(89) set Y_ 326 
$node_(89) set Z_ 0.0 
$node_(90) set X_ 99 
$node_(90) set Y_ 472 
$node_(90) set Z_ 0.0 
$node_(91) set X_ 1240 
$node_(91) set Y_ 963 
$node_(91) set Z_ 0.0 
$node_(92) set X_ 2503 
$node_(92) set Y_ 697 
$node_(92) set Z_ 0.0 
$node_(93) set X_ 2749 
$node_(93) set Y_ 346 
$node_(93) set Z_ 0.0 
$node_(94) set X_ 2348 
$node_(94) set Y_ 412 
$node_(94) set Z_ 0.0 
$node_(95) set X_ 1907 
$node_(95) set Y_ 681 
$node_(95) set Z_ 0.0 
$node_(96) set X_ 545 
$node_(96) set Y_ 475 
$node_(96) set Z_ 0.0 
$node_(97) set X_ 2779 
$node_(97) set Y_ 584 
$node_(97) set Z_ 0.0 
$node_(98) set X_ 1196 
$node_(98) set Y_ 127 
$node_(98) set Z_ 0.0 
$node_(99) set X_ 1142 
$node_(99) set Y_ 754 
$node_(99) set Z_ 0.0 
$node_(100) set X_ 28 
$node_(100) set Y_ 173 
$node_(100) set Z_ 0.0 
$node_(101) set X_ 2125 
$node_(101) set Y_ 165 
$node_(101) set Z_ 0.0 
$ns at 0.0 "$node_(101) off" 
$ns at 100.0 "$node_(101) on" 
$node_(102) set X_ 2231 
$node_(102) set Y_ 535 
$node_(102) set Z_ 0.0 
$ns at 0.0 "$node_(102) off" 
$ns at 100.0 "$node_(102) on" 
$node_(103) set X_ 1411 
$node_(103) set Y_ 564 
$node_(103) set Z_ 0.0 
$ns at 0.0 "$node_(103) off" 
$ns at 100.0 "$node_(103) on" 
$node_(104) set X_ 466 
$node_(104) set Y_ 781 
$node_(104) set Z_ 0.0 
$ns at 0.0 "$node_(104) off" 
$ns at 100.0 "$node_(104) on" 
$node_(105) set X_ 1356 
$node_(105) set Y_ 383 
$node_(105) set Z_ 0.0 
$ns at 0.0 "$node_(105) off" 
$ns at 100.0 "$node_(105) on" 
$node_(106) set X_ 2850 
$node_(106) set Y_ 678 
$node_(106) set Z_ 0.0 
$ns at 0.0 "$node_(106) off" 
$ns at 100.0 "$node_(106) on" 
$node_(107) set X_ 2077 
$node_(107) set Y_ 54 
$node_(107) set Z_ 0.0 
$ns at 0.0 "$node_(107) off" 
$ns at 100.0 "$node_(107) on" 
$node_(108) set X_ 1835 
$node_(108) set Y_ 207 
$node_(108) set Z_ 0.0 
$ns at 0.0 "$node_(108) off" 
$ns at 100.0 "$node_(108) on" 
$node_(109) set X_ 1725 
$node_(109) set Y_ 862 
$node_(109) set Z_ 0.0 
$ns at 0.0 "$node_(109) off" 
$ns at 100.0 "$node_(109) on" 
$node_(110) set X_ 860 
$node_(110) set Y_ 788 
$node_(110) set Z_ 0.0 
$ns at 0.0 "$node_(110) off" 
$ns at 100.0 "$node_(110) on" 
$node_(111) set X_ 2786 
$node_(111) set Y_ 118 
$node_(111) set Z_ 0.0 
$ns at 0.0 "$node_(111) off" 
$ns at 100.0 "$node_(111) on" 
$node_(112) set X_ 2704 
$node_(112) set Y_ 613 
$node_(112) set Z_ 0.0 
$ns at 0.0 "$node_(112) off" 
$ns at 100.0 "$node_(112) on" 
$node_(113) set X_ 2365 
$node_(113) set Y_ 448 
$node_(113) set Z_ 0.0 
$ns at 0.0 "$node_(113) off" 
$ns at 100.0 "$node_(113) on" 
$node_(114) set X_ 381 
$node_(114) set Y_ 120 
$node_(114) set Z_ 0.0 
$ns at 0.0 "$node_(114) off" 
$ns at 100.0 "$node_(114) on" 
$node_(115) set X_ 959 
$node_(115) set Y_ 407 
$node_(115) set Z_ 0.0 
$ns at 0.0 "$node_(115) off" 
$ns at 100.0 "$node_(115) on" 
$node_(116) set X_ 382 
$node_(116) set Y_ 627 
$node_(116) set Z_ 0.0 
$ns at 0.0 "$node_(116) off" 
$ns at 100.0 "$node_(116) on" 
$node_(117) set X_ 1285 
$node_(117) set Y_ 493 
$node_(117) set Z_ 0.0 
$ns at 0.0 "$node_(117) off" 
$ns at 100.0 "$node_(117) on" 
$node_(118) set X_ 2934 
$node_(118) set Y_ 57 
$node_(118) set Z_ 0.0 
$ns at 0.0 "$node_(118) off" 
$ns at 100.0 "$node_(118) on" 
$node_(119) set X_ 2212 
$node_(119) set Y_ 831 
$node_(119) set Z_ 0.0 
$ns at 0.0 "$node_(119) off" 
$ns at 100.0 "$node_(119) on" 
$node_(120) set X_ 845 
$node_(120) set Y_ 523 
$node_(120) set Z_ 0.0 
$ns at 0.0 "$node_(120) off" 
$ns at 100.0 "$node_(120) on" 
$node_(121) set X_ 2846 
$node_(121) set Y_ 478 
$node_(121) set Z_ 0.0 
$ns at 0.0 "$node_(121) off" 
$ns at 100.0 "$node_(121) on" 
$node_(122) set X_ 2317 
$node_(122) set Y_ 219 
$node_(122) set Z_ 0.0 
$ns at 0.0 "$node_(122) off" 
$ns at 100.0 "$node_(122) on" 
$node_(123) set X_ 243 
$node_(123) set Y_ 339 
$node_(123) set Z_ 0.0 
$ns at 0.0 "$node_(123) off" 
$ns at 100.0 "$node_(123) on" 
$node_(124) set X_ 1915 
$node_(124) set Y_ 756 
$node_(124) set Z_ 0.0 
$ns at 0.0 "$node_(124) off" 
$ns at 100.0 "$node_(124) on" 
$node_(125) set X_ 2145 
$node_(125) set Y_ 135 
$node_(125) set Z_ 0.0 
$ns at 0.0 "$node_(125) off" 
$ns at 100.0 "$node_(125) on" 
$node_(126) set X_ 2664 
$node_(126) set Y_ 563 
$node_(126) set Z_ 0.0 
$ns at 0.0 "$node_(126) off" 
$ns at 100.0 "$node_(126) on" 
$node_(127) set X_ 515 
$node_(127) set Y_ 744 
$node_(127) set Z_ 0.0 
$ns at 0.0 "$node_(127) off" 
$ns at 100.0 "$node_(127) on" 
$node_(128) set X_ 968 
$node_(128) set Y_ 442 
$node_(128) set Z_ 0.0 
$ns at 0.0 "$node_(128) off" 
$ns at 100.0 "$node_(128) on" 
$node_(129) set X_ 1502 
$node_(129) set Y_ 496 
$node_(129) set Z_ 0.0 
$ns at 0.0 "$node_(129) off" 
$ns at 100.0 "$node_(129) on" 
$node_(130) set X_ 1785 
$node_(130) set Y_ 721 
$node_(130) set Z_ 0.0 
$ns at 0.0 "$node_(130) off" 
$ns at 100.0 "$node_(130) on" 
$node_(131) set X_ 776 
$node_(131) set Y_ 669 
$node_(131) set Z_ 0.0 
$ns at 0.0 "$node_(131) off" 
$ns at 100.0 "$node_(131) on" 
$node_(132) set X_ 1133 
$node_(132) set Y_ 668 
$node_(132) set Z_ 0.0 
$ns at 0.0 "$node_(132) off" 
$ns at 100.0 "$node_(132) on" 
$node_(133) set X_ 975 
$node_(133) set Y_ 556 
$node_(133) set Z_ 0.0 
$ns at 0.0 "$node_(133) off" 
$ns at 100.0 "$node_(133) on" 
$node_(134) set X_ 2677 
$node_(134) set Y_ 52 
$node_(134) set Z_ 0.0 
$ns at 0.0 "$node_(134) off" 
$ns at 100.0 "$node_(134) on" 
$node_(135) set X_ 1242 
$node_(135) set Y_ 901 
$node_(135) set Z_ 0.0 
$ns at 0.0 "$node_(135) off" 
$ns at 100.0 "$node_(135) on" 
$node_(136) set X_ 2761 
$node_(136) set Y_ 725 
$node_(136) set Z_ 0.0 
$ns at 0.0 "$node_(136) off" 
$ns at 100.0 "$node_(136) on" 
$node_(137) set X_ 1590 
$node_(137) set Y_ 461 
$node_(137) set Z_ 0.0 
$ns at 0.0 "$node_(137) off" 
$ns at 100.0 "$node_(137) on" 
$node_(138) set X_ 2812 
$node_(138) set Y_ 154 
$node_(138) set Z_ 0.0 
$ns at 0.0 "$node_(138) off" 
$ns at 100.0 "$node_(138) on" 
$node_(139) set X_ 982 
$node_(139) set Y_ 708 
$node_(139) set Z_ 0.0 
$ns at 0.0 "$node_(139) off" 
$ns at 100.0 "$node_(139) on" 
$node_(140) set X_ 633 
$node_(140) set Y_ 645 
$node_(140) set Z_ 0.0 
$ns at 0.0 "$node_(140) off" 
$ns at 100.0 "$node_(140) on" 
$node_(141) set X_ 719 
$node_(141) set Y_ 407 
$node_(141) set Z_ 0.0 
$ns at 0.0 "$node_(141) off" 
$ns at 100.0 "$node_(141) on" 
$node_(142) set X_ 1583 
$node_(142) set Y_ 826 
$node_(142) set Z_ 0.0 
$ns at 0.0 "$node_(142) off" 
$ns at 100.0 "$node_(142) on" 
$node_(143) set X_ 832 
$node_(143) set Y_ 928 
$node_(143) set Z_ 0.0 
$ns at 0.0 "$node_(143) off" 
$ns at 100.0 "$node_(143) on" 
$node_(144) set X_ 2170 
$node_(144) set Y_ 645 
$node_(144) set Z_ 0.0 
$ns at 0.0 "$node_(144) off" 
$ns at 100.0 "$node_(144) on" 
$node_(145) set X_ 1789 
$node_(145) set Y_ 666 
$node_(145) set Z_ 0.0 
$ns at 0.0 "$node_(145) off" 
$ns at 100.0 "$node_(145) on" 
$node_(146) set X_ 1023 
$node_(146) set Y_ 708 
$node_(146) set Z_ 0.0 
$ns at 0.0 "$node_(146) off" 
$ns at 100.0 "$node_(146) on" 
$node_(147) set X_ 887 
$node_(147) set Y_ 857 
$node_(147) set Z_ 0.0 
$ns at 0.0 "$node_(147) off" 
$ns at 100.0 "$node_(147) on" 
$node_(148) set X_ 1634 
$node_(148) set Y_ 341 
$node_(148) set Z_ 0.0 
$ns at 0.0 "$node_(148) off" 
$ns at 100.0 "$node_(148) on" 
$node_(149) set X_ 1256 
$node_(149) set Y_ 431 
$node_(149) set Z_ 0.0 
$ns at 0.0 "$node_(149) off" 
$ns at 100.0 "$node_(149) on" 
$node_(150) set X_ 2679 
$node_(150) set Y_ 101 
$node_(150) set Z_ 0.0 
$ns at 0.0 "$node_(150) off" 
$ns at 100.0 "$node_(150) on" 
$node_(151) set X_ 2378 
$node_(151) set Y_ 270 
$node_(151) set Z_ 0.0 
$ns at 0.0 "$node_(151) off" 
$ns at 100.0 "$node_(151) on" 
$node_(152) set X_ 2069 
$node_(152) set Y_ 853 
$node_(152) set Z_ 0.0 
$ns at 0.0 "$node_(152) off" 
$ns at 100.0 "$node_(152) on" 
$node_(153) set X_ 530 
$node_(153) set Y_ 387 
$node_(153) set Z_ 0.0 
$ns at 0.0 "$node_(153) off" 
$ns at 100.0 "$node_(153) on" 
$node_(154) set X_ 1241 
$node_(154) set Y_ 693 
$node_(154) set Z_ 0.0 
$ns at 0.0 "$node_(154) off" 
$ns at 100.0 "$node_(154) on" 
$node_(155) set X_ 494 
$node_(155) set Y_ 97 
$node_(155) set Z_ 0.0 
$ns at 0.0 "$node_(155) off" 
$ns at 100.0 "$node_(155) on" 
$node_(156) set X_ 475 
$node_(156) set Y_ 156 
$node_(156) set Z_ 0.0 
$ns at 0.0 "$node_(156) off" 
$ns at 100.0 "$node_(156) on" 
$node_(157) set X_ 1275 
$node_(157) set Y_ 197 
$node_(157) set Z_ 0.0 
$ns at 0.0 "$node_(157) off" 
$ns at 100.0 "$node_(157) on" 
$node_(158) set X_ 323 
$node_(158) set Y_ 190 
$node_(158) set Z_ 0.0 
$ns at 0.0 "$node_(158) off" 
$ns at 100.0 "$node_(158) on" 
$node_(159) set X_ 472 
$node_(159) set Y_ 566 
$node_(159) set Z_ 0.0 
$ns at 0.0 "$node_(159) off" 
$ns at 100.0 "$node_(159) on" 
$node_(160) set X_ 2464 
$node_(160) set Y_ 292 
$node_(160) set Z_ 0.0 
$ns at 0.0 "$node_(160) off" 
$ns at 100.0 "$node_(160) on" 
$node_(161) set X_ 287 
$node_(161) set Y_ 320 
$node_(161) set Z_ 0.0 
$ns at 0.0 "$node_(161) off" 
$ns at 100.0 "$node_(161) on" 
$node_(162) set X_ 1496 
$node_(162) set Y_ 82 
$node_(162) set Z_ 0.0 
$ns at 0.0 "$node_(162) off" 
$ns at 100.0 "$node_(162) on" 
$node_(163) set X_ 2982 
$node_(163) set Y_ 876 
$node_(163) set Z_ 0.0 
$ns at 0.0 "$node_(163) off" 
$ns at 100.0 "$node_(163) on" 
$node_(164) set X_ 1392 
$node_(164) set Y_ 315 
$node_(164) set Z_ 0.0 
$ns at 0.0 "$node_(164) off" 
$ns at 100.0 "$node_(164) on" 
$node_(165) set X_ 860 
$node_(165) set Y_ 846 
$node_(165) set Z_ 0.0 
$ns at 0.0 "$node_(165) off" 
$ns at 100.0 "$node_(165) on" 
$node_(166) set X_ 2451 
$node_(166) set Y_ 33 
$node_(166) set Z_ 0.0 
$ns at 0.0 "$node_(166) off" 
$ns at 100.0 "$node_(166) on" 
$node_(167) set X_ 1649 
$node_(167) set Y_ 668 
$node_(167) set Z_ 0.0 
$ns at 0.0 "$node_(167) off" 
$ns at 100.0 "$node_(167) on" 
$node_(168) set X_ 1717 
$node_(168) set Y_ 66 
$node_(168) set Z_ 0.0 
$ns at 0.0 "$node_(168) off" 
$ns at 100.0 "$node_(168) on" 
$node_(169) set X_ 1339 
$node_(169) set Y_ 269 
$node_(169) set Z_ 0.0 
$ns at 0.0 "$node_(169) off" 
$ns at 100.0 "$node_(169) on" 
$node_(170) set X_ 1926 
$node_(170) set Y_ 640 
$node_(170) set Z_ 0.0 
$ns at 0.0 "$node_(170) off" 
$ns at 100.0 "$node_(170) on" 
$node_(171) set X_ 254 
$node_(171) set Y_ 889 
$node_(171) set Z_ 0.0 
$ns at 0.0 "$node_(171) off" 
$ns at 100.0 "$node_(171) on" 
$node_(172) set X_ 2073 
$node_(172) set Y_ 156 
$node_(172) set Z_ 0.0 
$ns at 0.0 "$node_(172) off" 
$ns at 100.0 "$node_(172) on" 
$node_(173) set X_ 295 
$node_(173) set Y_ 364 
$node_(173) set Z_ 0.0 
$ns at 0.0 "$node_(173) off" 
$ns at 100.0 "$node_(173) on" 
$node_(174) set X_ 741 
$node_(174) set Y_ 545 
$node_(174) set Z_ 0.0 
$ns at 0.0 "$node_(174) off" 
$ns at 100.0 "$node_(174) on" 
$node_(175) set X_ 915 
$node_(175) set Y_ 805 
$node_(175) set Z_ 0.0 
$ns at 0.0 "$node_(175) off" 
$ns at 100.0 "$node_(175) on" 
$node_(176) set X_ 1307 
$node_(176) set Y_ 766 
$node_(176) set Z_ 0.0 
$ns at 0.0 "$node_(176) off" 
$ns at 100.0 "$node_(176) on" 
$node_(177) set X_ 1491 
$node_(177) set Y_ 618 
$node_(177) set Z_ 0.0 
$ns at 0.0 "$node_(177) off" 
$ns at 100.0 "$node_(177) on" 
$node_(178) set X_ 1092 
$node_(178) set Y_ 130 
$node_(178) set Z_ 0.0 
$ns at 0.0 "$node_(178) off" 
$ns at 100.0 "$node_(178) on" 
$node_(179) set X_ 2330 
$node_(179) set Y_ 252 
$node_(179) set Z_ 0.0 
$ns at 0.0 "$node_(179) off" 
$ns at 100.0 "$node_(179) on" 
$node_(180) set X_ 1487 
$node_(180) set Y_ 120 
$node_(180) set Z_ 0.0 
$ns at 0.0 "$node_(180) off" 
$ns at 100.0 "$node_(180) on" 
$node_(181) set X_ 2586 
$node_(181) set Y_ 866 
$node_(181) set Z_ 0.0 
$ns at 0.0 "$node_(181) off" 
$ns at 100.0 "$node_(181) on" 
$node_(182) set X_ 945 
$node_(182) set Y_ 306 
$node_(182) set Z_ 0.0 
$ns at 0.0 "$node_(182) off" 
$ns at 100.0 "$node_(182) on" 
$node_(183) set X_ 2864 
$node_(183) set Y_ 395 
$node_(183) set Z_ 0.0 
$ns at 0.0 "$node_(183) off" 
$ns at 100.0 "$node_(183) on" 
$node_(184) set X_ 606 
$node_(184) set Y_ 758 
$node_(184) set Z_ 0.0 
$ns at 0.0 "$node_(184) off" 
$ns at 100.0 "$node_(184) on" 
$node_(185) set X_ 262 
$node_(185) set Y_ 69 
$node_(185) set Z_ 0.0 
$ns at 0.0 "$node_(185) off" 
$ns at 100.0 "$node_(185) on" 
$node_(186) set X_ 2184 
$node_(186) set Y_ 101 
$node_(186) set Z_ 0.0 
$ns at 0.0 "$node_(186) off" 
$ns at 100.0 "$node_(186) on" 
$node_(187) set X_ 1064 
$node_(187) set Y_ 571 
$node_(187) set Z_ 0.0 
$ns at 0.0 "$node_(187) off" 
$ns at 100.0 "$node_(187) on" 
$node_(188) set X_ 1497 
$node_(188) set Y_ 956 
$node_(188) set Z_ 0.0 
$ns at 0.0 "$node_(188) off" 
$ns at 100.0 "$node_(188) on" 
$node_(189) set X_ 190 
$node_(189) set Y_ 412 
$node_(189) set Z_ 0.0 
$ns at 0.0 "$node_(189) off" 
$ns at 100.0 "$node_(189) on" 
$node_(190) set X_ 854 
$node_(190) set Y_ 76 
$node_(190) set Z_ 0.0 
$ns at 0.0 "$node_(190) off" 
$ns at 100.0 "$node_(190) on" 
$node_(191) set X_ 1889 
$node_(191) set Y_ 998 
$node_(191) set Z_ 0.0 
$ns at 0.0 "$node_(191) off" 
$ns at 100.0 "$node_(191) on" 
$node_(192) set X_ 1195 
$node_(192) set Y_ 923 
$node_(192) set Z_ 0.0 
$ns at 0.0 "$node_(192) off" 
$ns at 100.0 "$node_(192) on" 
$node_(193) set X_ 42 
$node_(193) set Y_ 142 
$node_(193) set Z_ 0.0 
$ns at 0.0 "$node_(193) off" 
$ns at 100.0 "$node_(193) on" 
$node_(194) set X_ 639 
$node_(194) set Y_ 762 
$node_(194) set Z_ 0.0 
$ns at 0.0 "$node_(194) off" 
$ns at 100.0 "$node_(194) on" 
$node_(195) set X_ 1721 
$node_(195) set Y_ 409 
$node_(195) set Z_ 0.0 
$ns at 0.0 "$node_(195) off" 
$ns at 100.0 "$node_(195) on" 
$node_(196) set X_ 744 
$node_(196) set Y_ 624 
$node_(196) set Z_ 0.0 
$ns at 0.0 "$node_(196) off" 
$ns at 100.0 "$node_(196) on" 
$node_(197) set X_ 1464 
$node_(197) set Y_ 826 
$node_(197) set Z_ 0.0 
$ns at 0.0 "$node_(197) off" 
$ns at 100.0 "$node_(197) on" 
$node_(198) set X_ 1436 
$node_(198) set Y_ 648 
$node_(198) set Z_ 0.0 
$ns at 0.0 "$node_(198) off" 
$ns at 100.0 "$node_(198) on" 
$node_(199) set X_ 979 
$node_(199) set Y_ 915 
$node_(199) set Z_ 0.0 
$ns at 0.0 "$node_(199) off" 
$ns at 100.0 "$node_(199) on" 
$node_(200) set X_ 1198 
$node_(200) set Y_ 355 
$node_(200) set Z_ 0.0 
$ns at 0.0 "$node_(200) off" 
$ns at 200.0 "$node_(200) on" 
$node_(201) set X_ 2706 
$node_(201) set Y_ 953 
$node_(201) set Z_ 0.0 
$ns at 0.0 "$node_(201) off" 
$ns at 200.0 "$node_(201) on" 
$node_(202) set X_ 2655 
$node_(202) set Y_ 430 
$node_(202) set Z_ 0.0 
$ns at 0.0 "$node_(202) off" 
$ns at 200.0 "$node_(202) on" 
$node_(203) set X_ 872 
$node_(203) set Y_ 638 
$node_(203) set Z_ 0.0 
$ns at 0.0 "$node_(203) off" 
$ns at 200.0 "$node_(203) on" 
$node_(204) set X_ 308 
$node_(204) set Y_ 415 
$node_(204) set Z_ 0.0 
$ns at 0.0 "$node_(204) off" 
$ns at 200.0 "$node_(204) on" 
$node_(205) set X_ 2332 
$node_(205) set Y_ 52 
$node_(205) set Z_ 0.0 
$ns at 0.0 "$node_(205) off" 
$ns at 200.0 "$node_(205) on" 
$node_(206) set X_ 1608 
$node_(206) set Y_ 526 
$node_(206) set Z_ 0.0 
$ns at 0.0 "$node_(206) off" 
$ns at 200.0 "$node_(206) on" 
$node_(207) set X_ 1613 
$node_(207) set Y_ 928 
$node_(207) set Z_ 0.0 
$ns at 0.0 "$node_(207) off" 
$ns at 200.0 "$node_(207) on" 
$node_(208) set X_ 2145 
$node_(208) set Y_ 517 
$node_(208) set Z_ 0.0 
$ns at 0.0 "$node_(208) off" 
$ns at 200.0 "$node_(208) on" 
$node_(209) set X_ 201 
$node_(209) set Y_ 761 
$node_(209) set Z_ 0.0 
$ns at 0.0 "$node_(209) off" 
$ns at 200.0 "$node_(209) on" 
$node_(210) set X_ 1110 
$node_(210) set Y_ 76 
$node_(210) set Z_ 0.0 
$ns at 0.0 "$node_(210) off" 
$ns at 200.0 "$node_(210) on" 
$node_(211) set X_ 2150 
$node_(211) set Y_ 199 
$node_(211) set Z_ 0.0 
$ns at 0.0 "$node_(211) off" 
$ns at 200.0 "$node_(211) on" 
$node_(212) set X_ 1653 
$node_(212) set Y_ 767 
$node_(212) set Z_ 0.0 
$ns at 0.0 "$node_(212) off" 
$ns at 200.0 "$node_(212) on" 
$node_(213) set X_ 656 
$node_(213) set Y_ 516 
$node_(213) set Z_ 0.0 
$ns at 0.0 "$node_(213) off" 
$ns at 200.0 "$node_(213) on" 
$node_(214) set X_ 2169 
$node_(214) set Y_ 943 
$node_(214) set Z_ 0.0 
$ns at 0.0 "$node_(214) off" 
$ns at 200.0 "$node_(214) on" 
$node_(215) set X_ 2229 
$node_(215) set Y_ 695 
$node_(215) set Z_ 0.0 
$ns at 0.0 "$node_(215) off" 
$ns at 200.0 "$node_(215) on" 
$node_(216) set X_ 2871 
$node_(216) set Y_ 355 
$node_(216) set Z_ 0.0 
$ns at 0.0 "$node_(216) off" 
$ns at 200.0 "$node_(216) on" 
$node_(217) set X_ 2589 
$node_(217) set Y_ 781 
$node_(217) set Z_ 0.0 
$ns at 0.0 "$node_(217) off" 
$ns at 200.0 "$node_(217) on" 
$node_(218) set X_ 379 
$node_(218) set Y_ 430 
$node_(218) set Z_ 0.0 
$ns at 0.0 "$node_(218) off" 
$ns at 200.0 "$node_(218) on" 
$node_(219) set X_ 2329 
$node_(219) set Y_ 742 
$node_(219) set Z_ 0.0 
$ns at 0.0 "$node_(219) off" 
$ns at 200.0 "$node_(219) on" 
$node_(220) set X_ 1343 
$node_(220) set Y_ 298 
$node_(220) set Z_ 0.0 
$ns at 0.0 "$node_(220) off" 
$ns at 200.0 "$node_(220) on" 
$node_(221) set X_ 835 
$node_(221) set Y_ 13 
$node_(221) set Z_ 0.0 
$ns at 0.0 "$node_(221) off" 
$ns at 200.0 "$node_(221) on" 
$node_(222) set X_ 2389 
$node_(222) set Y_ 706 
$node_(222) set Z_ 0.0 
$ns at 0.0 "$node_(222) off" 
$ns at 200.0 "$node_(222) on" 
$node_(223) set X_ 801 
$node_(223) set Y_ 271 
$node_(223) set Z_ 0.0 
$ns at 0.0 "$node_(223) off" 
$ns at 200.0 "$node_(223) on" 
$node_(224) set X_ 2928 
$node_(224) set Y_ 867 
$node_(224) set Z_ 0.0 
$ns at 0.0 "$node_(224) off" 
$ns at 200.0 "$node_(224) on" 
$node_(225) set X_ 63 
$node_(225) set Y_ 764 
$node_(225) set Z_ 0.0 
$ns at 0.0 "$node_(225) off" 
$ns at 200.0 "$node_(225) on" 
$node_(226) set X_ 1567 
$node_(226) set Y_ 190 
$node_(226) set Z_ 0.0 
$ns at 0.0 "$node_(226) off" 
$ns at 200.0 "$node_(226) on" 
$node_(227) set X_ 253 
$node_(227) set Y_ 675 
$node_(227) set Z_ 0.0 
$ns at 0.0 "$node_(227) off" 
$ns at 200.0 "$node_(227) on" 
$node_(228) set X_ 2039 
$node_(228) set Y_ 541 
$node_(228) set Z_ 0.0 
$ns at 0.0 "$node_(228) off" 
$ns at 200.0 "$node_(228) on" 
$node_(229) set X_ 1109 
$node_(229) set Y_ 615 
$node_(229) set Z_ 0.0 
$ns at 0.0 "$node_(229) off" 
$ns at 200.0 "$node_(229) on" 
$node_(230) set X_ 2741 
$node_(230) set Y_ 371 
$node_(230) set Z_ 0.0 
$ns at 0.0 "$node_(230) off" 
$ns at 200.0 "$node_(230) on" 
$node_(231) set X_ 2994 
$node_(231) set Y_ 296 
$node_(231) set Z_ 0.0 
$ns at 0.0 "$node_(231) off" 
$ns at 200.0 "$node_(231) on" 
$node_(232) set X_ 2035 
$node_(232) set Y_ 627 
$node_(232) set Z_ 0.0 
$ns at 0.0 "$node_(232) off" 
$ns at 200.0 "$node_(232) on" 
$node_(233) set X_ 1425 
$node_(233) set Y_ 857 
$node_(233) set Z_ 0.0 
$ns at 0.0 "$node_(233) off" 
$ns at 200.0 "$node_(233) on" 
$node_(234) set X_ 622 
$node_(234) set Y_ 801 
$node_(234) set Z_ 0.0 
$ns at 0.0 "$node_(234) off" 
$ns at 200.0 "$node_(234) on" 
$node_(235) set X_ 102 
$node_(235) set Y_ 97 
$node_(235) set Z_ 0.0 
$ns at 0.0 "$node_(235) off" 
$ns at 200.0 "$node_(235) on" 
$node_(236) set X_ 2271 
$node_(236) set Y_ 884 
$node_(236) set Z_ 0.0 
$ns at 0.0 "$node_(236) off" 
$ns at 200.0 "$node_(236) on" 
$node_(237) set X_ 1085 
$node_(237) set Y_ 97 
$node_(237) set Z_ 0.0 
$ns at 0.0 "$node_(237) off" 
$ns at 200.0 "$node_(237) on" 
$node_(238) set X_ 292 
$node_(238) set Y_ 259 
$node_(238) set Z_ 0.0 
$ns at 0.0 "$node_(238) off" 
$ns at 200.0 "$node_(238) on" 
$node_(239) set X_ 1411 
$node_(239) set Y_ 310 
$node_(239) set Z_ 0.0 
$ns at 0.0 "$node_(239) off" 
$ns at 200.0 "$node_(239) on" 
$node_(240) set X_ 53 
$node_(240) set Y_ 775 
$node_(240) set Z_ 0.0 
$ns at 0.0 "$node_(240) off" 
$ns at 200.0 "$node_(240) on" 
$node_(241) set X_ 526 
$node_(241) set Y_ 221 
$node_(241) set Z_ 0.0 
$ns at 0.0 "$node_(241) off" 
$ns at 200.0 "$node_(241) on" 
$node_(242) set X_ 872 
$node_(242) set Y_ 317 
$node_(242) set Z_ 0.0 
$ns at 0.0 "$node_(242) off" 
$ns at 200.0 "$node_(242) on" 
$node_(243) set X_ 1494 
$node_(243) set Y_ 127 
$node_(243) set Z_ 0.0 
$ns at 0.0 "$node_(243) off" 
$ns at 200.0 "$node_(243) on" 
$node_(244) set X_ 2488 
$node_(244) set Y_ 222 
$node_(244) set Z_ 0.0 
$ns at 0.0 "$node_(244) off" 
$ns at 200.0 "$node_(244) on" 
$node_(245) set X_ 968 
$node_(245) set Y_ 380 
$node_(245) set Z_ 0.0 
$ns at 0.0 "$node_(245) off" 
$ns at 200.0 "$node_(245) on" 
$node_(246) set X_ 2245 
$node_(246) set Y_ 793 
$node_(246) set Z_ 0.0 
$ns at 0.0 "$node_(246) off" 
$ns at 200.0 "$node_(246) on" 
$node_(247) set X_ 2431 
$node_(247) set Y_ 718 
$node_(247) set Z_ 0.0 
$ns at 0.0 "$node_(247) off" 
$ns at 200.0 "$node_(247) on" 
$node_(248) set X_ 1983 
$node_(248) set Y_ 952 
$node_(248) set Z_ 0.0 
$ns at 0.0 "$node_(248) off" 
$ns at 200.0 "$node_(248) on" 
$node_(249) set X_ 1175 
$node_(249) set Y_ 927 
$node_(249) set Z_ 0.0 
$ns at 0.0 "$node_(249) off" 
$ns at 200.0 "$node_(249) on" 
$node_(250) set X_ 2452 
$node_(250) set Y_ 846 
$node_(250) set Z_ 0.0 
$ns at 0.0 "$node_(250) off" 
$ns at 200.0 "$node_(250) on" 
$node_(251) set X_ 1935 
$node_(251) set Y_ 134 
$node_(251) set Z_ 0.0 
$ns at 0.0 "$node_(251) off" 
$ns at 200.0 "$node_(251) on" 
$node_(252) set X_ 1884 
$node_(252) set Y_ 817 
$node_(252) set Z_ 0.0 
$ns at 0.0 "$node_(252) off" 
$ns at 200.0 "$node_(252) on" 
$node_(253) set X_ 19 
$node_(253) set Y_ 495 
$node_(253) set Z_ 0.0 
$ns at 0.0 "$node_(253) off" 
$ns at 200.0 "$node_(253) on" 
$node_(254) set X_ 2132 
$node_(254) set Y_ 675 
$node_(254) set Z_ 0.0 
$ns at 0.0 "$node_(254) off" 
$ns at 200.0 "$node_(254) on" 
$node_(255) set X_ 139 
$node_(255) set Y_ 903 
$node_(255) set Z_ 0.0 
$ns at 0.0 "$node_(255) off" 
$ns at 200.0 "$node_(255) on" 
$node_(256) set X_ 2500 
$node_(256) set Y_ 699 
$node_(256) set Z_ 0.0 
$ns at 0.0 "$node_(256) off" 
$ns at 200.0 "$node_(256) on" 
$node_(257) set X_ 9 
$node_(257) set Y_ 614 
$node_(257) set Z_ 0.0 
$ns at 0.0 "$node_(257) off" 
$ns at 200.0 "$node_(257) on" 
$node_(258) set X_ 135 
$node_(258) set Y_ 84 
$node_(258) set Z_ 0.0 
$ns at 0.0 "$node_(258) off" 
$ns at 200.0 "$node_(258) on" 
$node_(259) set X_ 1101 
$node_(259) set Y_ 354 
$node_(259) set Z_ 0.0 
$ns at 0.0 "$node_(259) off" 
$ns at 200.0 "$node_(259) on" 
$node_(260) set X_ 2509 
$node_(260) set Y_ 853 
$node_(260) set Z_ 0.0 
$ns at 0.0 "$node_(260) off" 
$ns at 200.0 "$node_(260) on" 
$node_(261) set X_ 1721 
$node_(261) set Y_ 572 
$node_(261) set Z_ 0.0 
$ns at 0.0 "$node_(261) off" 
$ns at 200.0 "$node_(261) on" 
$node_(262) set X_ 1161 
$node_(262) set Y_ 390 
$node_(262) set Z_ 0.0 
$ns at 0.0 "$node_(262) off" 
$ns at 200.0 "$node_(262) on" 
$node_(263) set X_ 841 
$node_(263) set Y_ 982 
$node_(263) set Z_ 0.0 
$ns at 0.0 "$node_(263) off" 
$ns at 200.0 "$node_(263) on" 
$node_(264) set X_ 2503 
$node_(264) set Y_ 814 
$node_(264) set Z_ 0.0 
$ns at 0.0 "$node_(264) off" 
$ns at 200.0 "$node_(264) on" 
$node_(265) set X_ 832 
$node_(265) set Y_ 425 
$node_(265) set Z_ 0.0 
$ns at 0.0 "$node_(265) off" 
$ns at 200.0 "$node_(265) on" 
$node_(266) set X_ 70 
$node_(266) set Y_ 415 
$node_(266) set Z_ 0.0 
$ns at 0.0 "$node_(266) off" 
$ns at 200.0 "$node_(266) on" 
$node_(267) set X_ 2463 
$node_(267) set Y_ 404 
$node_(267) set Z_ 0.0 
$ns at 0.0 "$node_(267) off" 
$ns at 200.0 "$node_(267) on" 
$node_(268) set X_ 1144 
$node_(268) set Y_ 218 
$node_(268) set Z_ 0.0 
$ns at 0.0 "$node_(268) off" 
$ns at 200.0 "$node_(268) on" 
$node_(269) set X_ 159 
$node_(269) set Y_ 340 
$node_(269) set Z_ 0.0 
$ns at 0.0 "$node_(269) off" 
$ns at 200.0 "$node_(269) on" 
$node_(270) set X_ 1212 
$node_(270) set Y_ 548 
$node_(270) set Z_ 0.0 
$ns at 0.0 "$node_(270) off" 
$ns at 200.0 "$node_(270) on" 
$node_(271) set X_ 673 
$node_(271) set Y_ 700 
$node_(271) set Z_ 0.0 
$ns at 0.0 "$node_(271) off" 
$ns at 200.0 "$node_(271) on" 
$node_(272) set X_ 2204 
$node_(272) set Y_ 164 
$node_(272) set Z_ 0.0 
$ns at 0.0 "$node_(272) off" 
$ns at 200.0 "$node_(272) on" 
$node_(273) set X_ 1917 
$node_(273) set Y_ 703 
$node_(273) set Z_ 0.0 
$ns at 0.0 "$node_(273) off" 
$ns at 200.0 "$node_(273) on" 
$node_(274) set X_ 2916 
$node_(274) set Y_ 114 
$node_(274) set Z_ 0.0 
$ns at 0.0 "$node_(274) off" 
$ns at 200.0 "$node_(274) on" 
$node_(275) set X_ 1753 
$node_(275) set Y_ 195 
$node_(275) set Z_ 0.0 
$ns at 0.0 "$node_(275) off" 
$ns at 200.0 "$node_(275) on" 
$node_(276) set X_ 464 
$node_(276) set Y_ 973 
$node_(276) set Z_ 0.0 
$ns at 0.0 "$node_(276) off" 
$ns at 200.0 "$node_(276) on" 
$node_(277) set X_ 115 
$node_(277) set Y_ 650 
$node_(277) set Z_ 0.0 
$ns at 0.0 "$node_(277) off" 
$ns at 200.0 "$node_(277) on" 
$node_(278) set X_ 992 
$node_(278) set Y_ 550 
$node_(278) set Z_ 0.0 
$ns at 0.0 "$node_(278) off" 
$ns at 200.0 "$node_(278) on" 
$node_(279) set X_ 1798 
$node_(279) set Y_ 980 
$node_(279) set Z_ 0.0 
$ns at 0.0 "$node_(279) off" 
$ns at 200.0 "$node_(279) on" 
$node_(280) set X_ 2235 
$node_(280) set Y_ 451 
$node_(280) set Z_ 0.0 
$ns at 0.0 "$node_(280) off" 
$ns at 200.0 "$node_(280) on" 
$node_(281) set X_ 2770 
$node_(281) set Y_ 968 
$node_(281) set Z_ 0.0 
$ns at 0.0 "$node_(281) off" 
$ns at 200.0 "$node_(281) on" 
$node_(282) set X_ 2884 
$node_(282) set Y_ 110 
$node_(282) set Z_ 0.0 
$ns at 0.0 "$node_(282) off" 
$ns at 200.0 "$node_(282) on" 
$node_(283) set X_ 2770 
$node_(283) set Y_ 729 
$node_(283) set Z_ 0.0 
$ns at 0.0 "$node_(283) off" 
$ns at 200.0 "$node_(283) on" 
$node_(284) set X_ 1977 
$node_(284) set Y_ 40 
$node_(284) set Z_ 0.0 
$ns at 0.0 "$node_(284) off" 
$ns at 200.0 "$node_(284) on" 
$node_(285) set X_ 385 
$node_(285) set Y_ 521 
$node_(285) set Z_ 0.0 
$ns at 0.0 "$node_(285) off" 
$ns at 200.0 "$node_(285) on" 
$node_(286) set X_ 2833 
$node_(286) set Y_ 94 
$node_(286) set Z_ 0.0 
$ns at 0.0 "$node_(286) off" 
$ns at 200.0 "$node_(286) on" 
$node_(287) set X_ 2691 
$node_(287) set Y_ 606 
$node_(287) set Z_ 0.0 
$ns at 0.0 "$node_(287) off" 
$ns at 200.0 "$node_(287) on" 
$node_(288) set X_ 2288 
$node_(288) set Y_ 441 
$node_(288) set Z_ 0.0 
$ns at 0.0 "$node_(288) off" 
$ns at 200.0 "$node_(288) on" 
$node_(289) set X_ 1864 
$node_(289) set Y_ 650 
$node_(289) set Z_ 0.0 
$ns at 0.0 "$node_(289) off" 
$ns at 200.0 "$node_(289) on" 
$node_(290) set X_ 1177 
$node_(290) set Y_ 849 
$node_(290) set Z_ 0.0 
$ns at 0.0 "$node_(290) off" 
$ns at 200.0 "$node_(290) on" 
$node_(291) set X_ 2019 
$node_(291) set Y_ 306 
$node_(291) set Z_ 0.0 
$ns at 0.0 "$node_(291) off" 
$ns at 200.0 "$node_(291) on" 
$node_(292) set X_ 233 
$node_(292) set Y_ 598 
$node_(292) set Z_ 0.0 
$ns at 0.0 "$node_(292) off" 
$ns at 200.0 "$node_(292) on" 
$node_(293) set X_ 1802 
$node_(293) set Y_ 199 
$node_(293) set Z_ 0.0 
$ns at 0.0 "$node_(293) off" 
$ns at 200.0 "$node_(293) on" 
$node_(294) set X_ 1655 
$node_(294) set Y_ 7 
$node_(294) set Z_ 0.0 
$ns at 0.0 "$node_(294) off" 
$ns at 200.0 "$node_(294) on" 
$node_(295) set X_ 20 
$node_(295) set Y_ 559 
$node_(295) set Z_ 0.0 
$ns at 0.0 "$node_(295) off" 
$ns at 200.0 "$node_(295) on" 
$node_(296) set X_ 1780 
$node_(296) set Y_ 144 
$node_(296) set Z_ 0.0 
$ns at 0.0 "$node_(296) off" 
$ns at 200.0 "$node_(296) on" 
$node_(297) set X_ 1834 
$node_(297) set Y_ 107 
$node_(297) set Z_ 0.0 
$ns at 0.0 "$node_(297) off" 
$ns at 200.0 "$node_(297) on" 
$node_(298) set X_ 2337 
$node_(298) set Y_ 729 
$node_(298) set Z_ 0.0 
$ns at 0.0 "$node_(298) off" 
$ns at 200.0 "$node_(298) on" 
$node_(299) set X_ 702 
$node_(299) set Y_ 608 
$node_(299) set Z_ 0.0 
$ns at 0.0 "$node_(299) off" 
$ns at 200.0 "$node_(299) on" 
$node_(300) set X_ 822 
$node_(300) set Y_ 673 
$node_(300) set Z_ 0.0 
$ns at 0.0 "$node_(300) off" 
$ns at 300.0 "$node_(300) on" 
$node_(301) set X_ 2475 
$node_(301) set Y_ 741 
$node_(301) set Z_ 0.0 
$ns at 0.0 "$node_(301) off" 
$ns at 300.0 "$node_(301) on" 
$node_(302) set X_ 2564 
$node_(302) set Y_ 913 
$node_(302) set Z_ 0.0 
$ns at 0.0 "$node_(302) off" 
$ns at 300.0 "$node_(302) on" 
$node_(303) set X_ 609 
$node_(303) set Y_ 496 
$node_(303) set Z_ 0.0 
$ns at 0.0 "$node_(303) off" 
$ns at 300.0 "$node_(303) on" 
$node_(304) set X_ 1046 
$node_(304) set Y_ 457 
$node_(304) set Z_ 0.0 
$ns at 0.0 "$node_(304) off" 
$ns at 300.0 "$node_(304) on" 
$node_(305) set X_ 2637 
$node_(305) set Y_ 394 
$node_(305) set Z_ 0.0 
$ns at 0.0 "$node_(305) off" 
$ns at 300.0 "$node_(305) on" 
$node_(306) set X_ 988 
$node_(306) set Y_ 623 
$node_(306) set Z_ 0.0 
$ns at 0.0 "$node_(306) off" 
$ns at 300.0 "$node_(306) on" 
$node_(307) set X_ 539 
$node_(307) set Y_ 192 
$node_(307) set Z_ 0.0 
$ns at 0.0 "$node_(307) off" 
$ns at 300.0 "$node_(307) on" 
$node_(308) set X_ 637 
$node_(308) set Y_ 455 
$node_(308) set Z_ 0.0 
$ns at 0.0 "$node_(308) off" 
$ns at 300.0 "$node_(308) on" 
$node_(309) set X_ 2750 
$node_(309) set Y_ 616 
$node_(309) set Z_ 0.0 
$ns at 0.0 "$node_(309) off" 
$ns at 300.0 "$node_(309) on" 
$node_(310) set X_ 2621 
$node_(310) set Y_ 228 
$node_(310) set Z_ 0.0 
$ns at 0.0 "$node_(310) off" 
$ns at 300.0 "$node_(310) on" 
$node_(311) set X_ 2996 
$node_(311) set Y_ 868 
$node_(311) set Z_ 0.0 
$ns at 0.0 "$node_(311) off" 
$ns at 300.0 "$node_(311) on" 
$node_(312) set X_ 1560 
$node_(312) set Y_ 760 
$node_(312) set Z_ 0.0 
$ns at 0.0 "$node_(312) off" 
$ns at 300.0 "$node_(312) on" 
$node_(313) set X_ 2181 
$node_(313) set Y_ 321 
$node_(313) set Z_ 0.0 
$ns at 0.0 "$node_(313) off" 
$ns at 300.0 "$node_(313) on" 
$node_(314) set X_ 2486 
$node_(314) set Y_ 975 
$node_(314) set Z_ 0.0 
$ns at 0.0 "$node_(314) off" 
$ns at 300.0 "$node_(314) on" 
$node_(315) set X_ 2931 
$node_(315) set Y_ 869 
$node_(315) set Z_ 0.0 
$ns at 0.0 "$node_(315) off" 
$ns at 300.0 "$node_(315) on" 
$node_(316) set X_ 925 
$node_(316) set Y_ 802 
$node_(316) set Z_ 0.0 
$ns at 0.0 "$node_(316) off" 
$ns at 300.0 "$node_(316) on" 
$node_(317) set X_ 376 
$node_(317) set Y_ 827 
$node_(317) set Z_ 0.0 
$ns at 0.0 "$node_(317) off" 
$ns at 300.0 "$node_(317) on" 
$node_(318) set X_ 1251 
$node_(318) set Y_ 997 
$node_(318) set Z_ 0.0 
$ns at 0.0 "$node_(318) off" 
$ns at 300.0 "$node_(318) on" 
$node_(319) set X_ 1080 
$node_(319) set Y_ 187 
$node_(319) set Z_ 0.0 
$ns at 0.0 "$node_(319) off" 
$ns at 300.0 "$node_(319) on" 
$node_(320) set X_ 679 
$node_(320) set Y_ 969 
$node_(320) set Z_ 0.0 
$ns at 0.0 "$node_(320) off" 
$ns at 300.0 "$node_(320) on" 
$node_(321) set X_ 2913 
$node_(321) set Y_ 267 
$node_(321) set Z_ 0.0 
$ns at 0.0 "$node_(321) off" 
$ns at 300.0 "$node_(321) on" 
$node_(322) set X_ 972 
$node_(322) set Y_ 991 
$node_(322) set Z_ 0.0 
$ns at 0.0 "$node_(322) off" 
$ns at 300.0 "$node_(322) on" 
$node_(323) set X_ 966 
$node_(323) set Y_ 481 
$node_(323) set Z_ 0.0 
$ns at 0.0 "$node_(323) off" 
$ns at 300.0 "$node_(323) on" 
$node_(324) set X_ 609 
$node_(324) set Y_ 465 
$node_(324) set Z_ 0.0 
$ns at 0.0 "$node_(324) off" 
$ns at 300.0 "$node_(324) on" 
$node_(325) set X_ 1396 
$node_(325) set Y_ 48 
$node_(325) set Z_ 0.0 
$ns at 0.0 "$node_(325) off" 
$ns at 300.0 "$node_(325) on" 
$node_(326) set X_ 1807 
$node_(326) set Y_ 50 
$node_(326) set Z_ 0.0 
$ns at 0.0 "$node_(326) off" 
$ns at 300.0 "$node_(326) on" 
$node_(327) set X_ 2357 
$node_(327) set Y_ 942 
$node_(327) set Z_ 0.0 
$ns at 0.0 "$node_(327) off" 
$ns at 300.0 "$node_(327) on" 
$node_(328) set X_ 423 
$node_(328) set Y_ 550 
$node_(328) set Z_ 0.0 
$ns at 0.0 "$node_(328) off" 
$ns at 300.0 "$node_(328) on" 
$node_(329) set X_ 1877 
$node_(329) set Y_ 268 
$node_(329) set Z_ 0.0 
$ns at 0.0 "$node_(329) off" 
$ns at 300.0 "$node_(329) on" 
$node_(330) set X_ 325 
$node_(330) set Y_ 399 
$node_(330) set Z_ 0.0 
$ns at 0.0 "$node_(330) off" 
$ns at 300.0 "$node_(330) on" 
$node_(331) set X_ 1761 
$node_(331) set Y_ 571 
$node_(331) set Z_ 0.0 
$ns at 0.0 "$node_(331) off" 
$ns at 300.0 "$node_(331) on" 
$node_(332) set X_ 1387 
$node_(332) set Y_ 512 
$node_(332) set Z_ 0.0 
$ns at 0.0 "$node_(332) off" 
$ns at 300.0 "$node_(332) on" 
$node_(333) set X_ 241 
$node_(333) set Y_ 288 
$node_(333) set Z_ 0.0 
$ns at 0.0 "$node_(333) off" 
$ns at 300.0 "$node_(333) on" 
$node_(334) set X_ 2788 
$node_(334) set Y_ 1 
$node_(334) set Z_ 0.0 
$ns at 0.0 "$node_(334) off" 
$ns at 300.0 "$node_(334) on" 
$node_(335) set X_ 2244 
$node_(335) set Y_ 647 
$node_(335) set Z_ 0.0 
$ns at 0.0 "$node_(335) off" 
$ns at 300.0 "$node_(335) on" 
$node_(336) set X_ 1773 
$node_(336) set Y_ 983 
$node_(336) set Z_ 0.0 
$ns at 0.0 "$node_(336) off" 
$ns at 300.0 "$node_(336) on" 
$node_(337) set X_ 1731 
$node_(337) set Y_ 873 
$node_(337) set Z_ 0.0 
$ns at 0.0 "$node_(337) off" 
$ns at 300.0 "$node_(337) on" 
$node_(338) set X_ 1515 
$node_(338) set Y_ 300 
$node_(338) set Z_ 0.0 
$ns at 0.0 "$node_(338) off" 
$ns at 300.0 "$node_(338) on" 
$node_(339) set X_ 2647 
$node_(339) set Y_ 452 
$node_(339) set Z_ 0.0 
$ns at 0.0 "$node_(339) off" 
$ns at 300.0 "$node_(339) on" 
$node_(340) set X_ 2114 
$node_(340) set Y_ 466 
$node_(340) set Z_ 0.0 
$ns at 0.0 "$node_(340) off" 
$ns at 300.0 "$node_(340) on" 
$node_(341) set X_ 2552 
$node_(341) set Y_ 570 
$node_(341) set Z_ 0.0 
$ns at 0.0 "$node_(341) off" 
$ns at 300.0 "$node_(341) on" 
$node_(342) set X_ 1209 
$node_(342) set Y_ 569 
$node_(342) set Z_ 0.0 
$ns at 0.0 "$node_(342) off" 
$ns at 300.0 "$node_(342) on" 
$node_(343) set X_ 3000 
$node_(343) set Y_ 548 
$node_(343) set Z_ 0.0 
$ns at 0.0 "$node_(343) off" 
$ns at 300.0 "$node_(343) on" 
$node_(344) set X_ 1004 
$node_(344) set Y_ 191 
$node_(344) set Z_ 0.0 
$ns at 0.0 "$node_(344) off" 
$ns at 300.0 "$node_(344) on" 
$node_(345) set X_ 2236 
$node_(345) set Y_ 274 
$node_(345) set Z_ 0.0 
$ns at 0.0 "$node_(345) off" 
$ns at 300.0 "$node_(345) on" 
$node_(346) set X_ 2865 
$node_(346) set Y_ 601 
$node_(346) set Z_ 0.0 
$ns at 0.0 "$node_(346) off" 
$ns at 300.0 "$node_(346) on" 
$node_(347) set X_ 693 
$node_(347) set Y_ 161 
$node_(347) set Z_ 0.0 
$ns at 0.0 "$node_(347) off" 
$ns at 300.0 "$node_(347) on" 
$node_(348) set X_ 1955 
$node_(348) set Y_ 645 
$node_(348) set Z_ 0.0 
$ns at 0.0 "$node_(348) off" 
$ns at 300.0 "$node_(348) on" 
$node_(349) set X_ 2205 
$node_(349) set Y_ 128 
$node_(349) set Z_ 0.0 
$ns at 0.0 "$node_(349) off" 
$ns at 300.0 "$node_(349) on" 
$node_(350) set X_ 625 
$node_(350) set Y_ 746 
$node_(350) set Z_ 0.0 
$ns at 0.0 "$node_(350) off" 
$ns at 300.0 "$node_(350) on" 
$node_(351) set X_ 726 
$node_(351) set Y_ 464 
$node_(351) set Z_ 0.0 
$ns at 0.0 "$node_(351) off" 
$ns at 300.0 "$node_(351) on" 
$node_(352) set X_ 1539 
$node_(352) set Y_ 419 
$node_(352) set Z_ 0.0 
$ns at 0.0 "$node_(352) off" 
$ns at 300.0 "$node_(352) on" 
$node_(353) set X_ 705 
$node_(353) set Y_ 203 
$node_(353) set Z_ 0.0 
$ns at 0.0 "$node_(353) off" 
$ns at 300.0 "$node_(353) on" 
$node_(354) set X_ 2711 
$node_(354) set Y_ 520 
$node_(354) set Z_ 0.0 
$ns at 0.0 "$node_(354) off" 
$ns at 300.0 "$node_(354) on" 
$node_(355) set X_ 1067 
$node_(355) set Y_ 819 
$node_(355) set Z_ 0.0 
$ns at 0.0 "$node_(355) off" 
$ns at 300.0 "$node_(355) on" 
$node_(356) set X_ 1821 
$node_(356) set Y_ 206 
$node_(356) set Z_ 0.0 
$ns at 0.0 "$node_(356) off" 
$ns at 300.0 "$node_(356) on" 
$node_(357) set X_ 1060 
$node_(357) set Y_ 627 
$node_(357) set Z_ 0.0 
$ns at 0.0 "$node_(357) off" 
$ns at 300.0 "$node_(357) on" 
$node_(358) set X_ 1300 
$node_(358) set Y_ 277 
$node_(358) set Z_ 0.0 
$ns at 0.0 "$node_(358) off" 
$ns at 300.0 "$node_(358) on" 
$node_(359) set X_ 1965 
$node_(359) set Y_ 275 
$node_(359) set Z_ 0.0 
$ns at 0.0 "$node_(359) off" 
$ns at 300.0 "$node_(359) on" 
$node_(360) set X_ 833 
$node_(360) set Y_ 78 
$node_(360) set Z_ 0.0 
$ns at 0.0 "$node_(360) off" 
$ns at 300.0 "$node_(360) on" 
$node_(361) set X_ 2916 
$node_(361) set Y_ 91 
$node_(361) set Z_ 0.0 
$ns at 0.0 "$node_(361) off" 
$ns at 300.0 "$node_(361) on" 
$node_(362) set X_ 2963 
$node_(362) set Y_ 685 
$node_(362) set Z_ 0.0 
$ns at 0.0 "$node_(362) off" 
$ns at 300.0 "$node_(362) on" 
$node_(363) set X_ 1740 
$node_(363) set Y_ 874 
$node_(363) set Z_ 0.0 
$ns at 0.0 "$node_(363) off" 
$ns at 300.0 "$node_(363) on" 
$node_(364) set X_ 2575 
$node_(364) set Y_ 407 
$node_(364) set Z_ 0.0 
$ns at 0.0 "$node_(364) off" 
$ns at 300.0 "$node_(364) on" 
$node_(365) set X_ 918 
$node_(365) set Y_ 902 
$node_(365) set Z_ 0.0 
$ns at 0.0 "$node_(365) off" 
$ns at 300.0 "$node_(365) on" 
$node_(366) set X_ 1039 
$node_(366) set Y_ 990 
$node_(366) set Z_ 0.0 
$ns at 0.0 "$node_(366) off" 
$ns at 300.0 "$node_(366) on" 
$node_(367) set X_ 2386 
$node_(367) set Y_ 560 
$node_(367) set Z_ 0.0 
$ns at 0.0 "$node_(367) off" 
$ns at 300.0 "$node_(367) on" 
$node_(368) set X_ 1790 
$node_(368) set Y_ 36 
$node_(368) set Z_ 0.0 
$ns at 0.0 "$node_(368) off" 
$ns at 300.0 "$node_(368) on" 
$node_(369) set X_ 995 
$node_(369) set Y_ 13 
$node_(369) set Z_ 0.0 
$ns at 0.0 "$node_(369) off" 
$ns at 300.0 "$node_(369) on" 
$node_(370) set X_ 71 
$node_(370) set Y_ 310 
$node_(370) set Z_ 0.0 
$ns at 0.0 "$node_(370) off" 
$ns at 300.0 "$node_(370) on" 
$node_(371) set X_ 1029 
$node_(371) set Y_ 752 
$node_(371) set Z_ 0.0 
$ns at 0.0 "$node_(371) off" 
$ns at 300.0 "$node_(371) on" 
$node_(372) set X_ 1523 
$node_(372) set Y_ 565 
$node_(372) set Z_ 0.0 
$ns at 0.0 "$node_(372) off" 
$ns at 300.0 "$node_(372) on" 
$node_(373) set X_ 2197 
$node_(373) set Y_ 713 
$node_(373) set Z_ 0.0 
$ns at 0.0 "$node_(373) off" 
$ns at 300.0 "$node_(373) on" 
$node_(374) set X_ 2163 
$node_(374) set Y_ 448 
$node_(374) set Z_ 0.0 
$ns at 0.0 "$node_(374) off" 
$ns at 300.0 "$node_(374) on" 
$node_(375) set X_ 1057 
$node_(375) set Y_ 872 
$node_(375) set Z_ 0.0 
$ns at 0.0 "$node_(375) off" 
$ns at 300.0 "$node_(375) on" 
$node_(376) set X_ 2193 
$node_(376) set Y_ 873 
$node_(376) set Z_ 0.0 
$ns at 0.0 "$node_(376) off" 
$ns at 300.0 "$node_(376) on" 
$node_(377) set X_ 758 
$node_(377) set Y_ 885 
$node_(377) set Z_ 0.0 
$ns at 0.0 "$node_(377) off" 
$ns at 300.0 "$node_(377) on" 
$node_(378) set X_ 894 
$node_(378) set Y_ 953 
$node_(378) set Z_ 0.0 
$ns at 0.0 "$node_(378) off" 
$ns at 300.0 "$node_(378) on" 
$node_(379) set X_ 2480 
$node_(379) set Y_ 388 
$node_(379) set Z_ 0.0 
$ns at 0.0 "$node_(379) off" 
$ns at 300.0 "$node_(379) on" 
$node_(380) set X_ 680 
$node_(380) set Y_ 226 
$node_(380) set Z_ 0.0 
$ns at 0.0 "$node_(380) off" 
$ns at 300.0 "$node_(380) on" 
$node_(381) set X_ 1823 
$node_(381) set Y_ 26 
$node_(381) set Z_ 0.0 
$ns at 0.0 "$node_(381) off" 
$ns at 300.0 "$node_(381) on" 
$node_(382) set X_ 2143 
$node_(382) set Y_ 436 
$node_(382) set Z_ 0.0 
$ns at 0.0 "$node_(382) off" 
$ns at 300.0 "$node_(382) on" 
$node_(383) set X_ 816 
$node_(383) set Y_ 161 
$node_(383) set Z_ 0.0 
$ns at 0.0 "$node_(383) off" 
$ns at 300.0 "$node_(383) on" 
$node_(384) set X_ 2679 
$node_(384) set Y_ 594 
$node_(384) set Z_ 0.0 
$ns at 0.0 "$node_(384) off" 
$ns at 300.0 "$node_(384) on" 
$node_(385) set X_ 1024 
$node_(385) set Y_ 444 
$node_(385) set Z_ 0.0 
$ns at 0.0 "$node_(385) off" 
$ns at 300.0 "$node_(385) on" 
$node_(386) set X_ 1968 
$node_(386) set Y_ 355 
$node_(386) set Z_ 0.0 
$ns at 0.0 "$node_(386) off" 
$ns at 300.0 "$node_(386) on" 
$node_(387) set X_ 591 
$node_(387) set Y_ 162 
$node_(387) set Z_ 0.0 
$ns at 0.0 "$node_(387) off" 
$ns at 300.0 "$node_(387) on" 
$node_(388) set X_ 1309 
$node_(388) set Y_ 41 
$node_(388) set Z_ 0.0 
$ns at 0.0 "$node_(388) off" 
$ns at 300.0 "$node_(388) on" 
$node_(389) set X_ 832 
$node_(389) set Y_ 308 
$node_(389) set Z_ 0.0 
$ns at 0.0 "$node_(389) off" 
$ns at 300.0 "$node_(389) on" 
$node_(390) set X_ 2384 
$node_(390) set Y_ 780 
$node_(390) set Z_ 0.0 
$ns at 0.0 "$node_(390) off" 
$ns at 300.0 "$node_(390) on" 
$node_(391) set X_ 2221 
$node_(391) set Y_ 842 
$node_(391) set Z_ 0.0 
$ns at 0.0 "$node_(391) off" 
$ns at 300.0 "$node_(391) on" 
$node_(392) set X_ 1727 
$node_(392) set Y_ 293 
$node_(392) set Z_ 0.0 
$ns at 0.0 "$node_(392) off" 
$ns at 300.0 "$node_(392) on" 
$node_(393) set X_ 1383 
$node_(393) set Y_ 488 
$node_(393) set Z_ 0.0 
$ns at 0.0 "$node_(393) off" 
$ns at 300.0 "$node_(393) on" 
$node_(394) set X_ 2682 
$node_(394) set Y_ 861 
$node_(394) set Z_ 0.0 
$ns at 0.0 "$node_(394) off" 
$ns at 300.0 "$node_(394) on" 
$node_(395) set X_ 2874 
$node_(395) set Y_ 725 
$node_(395) set Z_ 0.0 
$ns at 0.0 "$node_(395) off" 
$ns at 300.0 "$node_(395) on" 
$node_(396) set X_ 1243 
$node_(396) set Y_ 853 
$node_(396) set Z_ 0.0 
$ns at 0.0 "$node_(396) off" 
$ns at 300.0 "$node_(396) on" 
$node_(397) set X_ 2190 
$node_(397) set Y_ 341 
$node_(397) set Z_ 0.0 
$ns at 0.0 "$node_(397) off" 
$ns at 300.0 "$node_(397) on" 
$node_(398) set X_ 656 
$node_(398) set Y_ 997 
$node_(398) set Z_ 0.0 
$ns at 0.0 "$node_(398) off" 
$ns at 300.0 "$node_(398) on" 
$node_(399) set X_ 1595 
$node_(399) set Y_ 7 
$node_(399) set Z_ 0.0 
$ns at 0.0 "$node_(399) off" 
$ns at 300.0 "$node_(399) on" 
$node_(400) set X_ 181 
$node_(400) set Y_ 279 
$node_(400) set Z_ 0.0 
$ns at 0.0 "$node_(400) off" 
$ns at 400.0 "$node_(400) on" 
$node_(401) set X_ 944 
$node_(401) set Y_ 892 
$node_(401) set Z_ 0.0 
$ns at 0.0 "$node_(401) off" 
$ns at 400.0 "$node_(401) on" 
$node_(402) set X_ 2847 
$node_(402) set Y_ 930 
$node_(402) set Z_ 0.0 
$ns at 0.0 "$node_(402) off" 
$ns at 400.0 "$node_(402) on" 
$node_(403) set X_ 2757 
$node_(403) set Y_ 223 
$node_(403) set Z_ 0.0 
$ns at 0.0 "$node_(403) off" 
$ns at 400.0 "$node_(403) on" 
$node_(404) set X_ 2482 
$node_(404) set Y_ 481 
$node_(404) set Z_ 0.0 
$ns at 0.0 "$node_(404) off" 
$ns at 400.0 "$node_(404) on" 
$node_(405) set X_ 328 
$node_(405) set Y_ 62 
$node_(405) set Z_ 0.0 
$ns at 0.0 "$node_(405) off" 
$ns at 400.0 "$node_(405) on" 
$node_(406) set X_ 1689 
$node_(406) set Y_ 278 
$node_(406) set Z_ 0.0 
$ns at 0.0 "$node_(406) off" 
$ns at 400.0 "$node_(406) on" 
$node_(407) set X_ 663 
$node_(407) set Y_ 281 
$node_(407) set Z_ 0.0 
$ns at 0.0 "$node_(407) off" 
$ns at 400.0 "$node_(407) on" 
$node_(408) set X_ 1798 
$node_(408) set Y_ 157 
$node_(408) set Z_ 0.0 
$ns at 0.0 "$node_(408) off" 
$ns at 400.0 "$node_(408) on" 
$node_(409) set X_ 1531 
$node_(409) set Y_ 891 
$node_(409) set Z_ 0.0 
$ns at 0.0 "$node_(409) off" 
$ns at 400.0 "$node_(409) on" 
$node_(410) set X_ 1177 
$node_(410) set Y_ 215 
$node_(410) set Z_ 0.0 
$ns at 0.0 "$node_(410) off" 
$ns at 400.0 "$node_(410) on" 
$node_(411) set X_ 827 
$node_(411) set Y_ 409 
$node_(411) set Z_ 0.0 
$ns at 0.0 "$node_(411) off" 
$ns at 400.0 "$node_(411) on" 
$node_(412) set X_ 568 
$node_(412) set Y_ 725 
$node_(412) set Z_ 0.0 
$ns at 0.0 "$node_(412) off" 
$ns at 400.0 "$node_(412) on" 
$node_(413) set X_ 2891 
$node_(413) set Y_ 916 
$node_(413) set Z_ 0.0 
$ns at 0.0 "$node_(413) off" 
$ns at 400.0 "$node_(413) on" 
$node_(414) set X_ 2411 
$node_(414) set Y_ 306 
$node_(414) set Z_ 0.0 
$ns at 0.0 "$node_(414) off" 
$ns at 400.0 "$node_(414) on" 
$node_(415) set X_ 2277 
$node_(415) set Y_ 823 
$node_(415) set Z_ 0.0 
$ns at 0.0 "$node_(415) off" 
$ns at 400.0 "$node_(415) on" 
$node_(416) set X_ 2326 
$node_(416) set Y_ 368 
$node_(416) set Z_ 0.0 
$ns at 0.0 "$node_(416) off" 
$ns at 400.0 "$node_(416) on" 
$node_(417) set X_ 1857 
$node_(417) set Y_ 133 
$node_(417) set Z_ 0.0 
$ns at 0.0 "$node_(417) off" 
$ns at 400.0 "$node_(417) on" 
$node_(418) set X_ 2168 
$node_(418) set Y_ 733 
$node_(418) set Z_ 0.0 
$ns at 0.0 "$node_(418) off" 
$ns at 400.0 "$node_(418) on" 
$node_(419) set X_ 911 
$node_(419) set Y_ 157 
$node_(419) set Z_ 0.0 
$ns at 0.0 "$node_(419) off" 
$ns at 400.0 "$node_(419) on" 
$node_(420) set X_ 2235 
$node_(420) set Y_ 62 
$node_(420) set Z_ 0.0 
$ns at 0.0 "$node_(420) off" 
$ns at 400.0 "$node_(420) on" 
$node_(421) set X_ 2200 
$node_(421) set Y_ 230 
$node_(421) set Z_ 0.0 
$ns at 0.0 "$node_(421) off" 
$ns at 400.0 "$node_(421) on" 
$node_(422) set X_ 1340 
$node_(422) set Y_ 396 
$node_(422) set Z_ 0.0 
$ns at 0.0 "$node_(422) off" 
$ns at 400.0 "$node_(422) on" 
$node_(423) set X_ 2729 
$node_(423) set Y_ 970 
$node_(423) set Z_ 0.0 
$ns at 0.0 "$node_(423) off" 
$ns at 400.0 "$node_(423) on" 
$node_(424) set X_ 1600 
$node_(424) set Y_ 682 
$node_(424) set Z_ 0.0 
$ns at 0.0 "$node_(424) off" 
$ns at 400.0 "$node_(424) on" 
$node_(425) set X_ 2155 
$node_(425) set Y_ 998 
$node_(425) set Z_ 0.0 
$ns at 0.0 "$node_(425) off" 
$ns at 400.0 "$node_(425) on" 
$node_(426) set X_ 2880 
$node_(426) set Y_ 620 
$node_(426) set Z_ 0.0 
$ns at 0.0 "$node_(426) off" 
$ns at 400.0 "$node_(426) on" 
$node_(427) set X_ 497 
$node_(427) set Y_ 865 
$node_(427) set Z_ 0.0 
$ns at 0.0 "$node_(427) off" 
$ns at 400.0 "$node_(427) on" 
$node_(428) set X_ 840 
$node_(428) set Y_ 566 
$node_(428) set Z_ 0.0 
$ns at 0.0 "$node_(428) off" 
$ns at 400.0 "$node_(428) on" 
$node_(429) set X_ 2934 
$node_(429) set Y_ 111 
$node_(429) set Z_ 0.0 
$ns at 0.0 "$node_(429) off" 
$ns at 400.0 "$node_(429) on" 
$node_(430) set X_ 628 
$node_(430) set Y_ 481 
$node_(430) set Z_ 0.0 
$ns at 0.0 "$node_(430) off" 
$ns at 400.0 "$node_(430) on" 
$node_(431) set X_ 153 
$node_(431) set Y_ 30 
$node_(431) set Z_ 0.0 
$ns at 0.0 "$node_(431) off" 
$ns at 400.0 "$node_(431) on" 
$node_(432) set X_ 1182 
$node_(432) set Y_ 150 
$node_(432) set Z_ 0.0 
$ns at 0.0 "$node_(432) off" 
$ns at 400.0 "$node_(432) on" 
$node_(433) set X_ 2780 
$node_(433) set Y_ 694 
$node_(433) set Z_ 0.0 
$ns at 0.0 "$node_(433) off" 
$ns at 400.0 "$node_(433) on" 
$node_(434) set X_ 118 
$node_(434) set Y_ 957 
$node_(434) set Z_ 0.0 
$ns at 0.0 "$node_(434) off" 
$ns at 400.0 "$node_(434) on" 
$node_(435) set X_ 1000 
$node_(435) set Y_ 256 
$node_(435) set Z_ 0.0 
$ns at 0.0 "$node_(435) off" 
$ns at 400.0 "$node_(435) on" 
$node_(436) set X_ 1068 
$node_(436) set Y_ 521 
$node_(436) set Z_ 0.0 
$ns at 0.0 "$node_(436) off" 
$ns at 400.0 "$node_(436) on" 
$node_(437) set X_ 2519 
$node_(437) set Y_ 357 
$node_(437) set Z_ 0.0 
$ns at 0.0 "$node_(437) off" 
$ns at 400.0 "$node_(437) on" 
$node_(438) set X_ 2264 
$node_(438) set Y_ 420 
$node_(438) set Z_ 0.0 
$ns at 0.0 "$node_(438) off" 
$ns at 400.0 "$node_(438) on" 
$node_(439) set X_ 2524 
$node_(439) set Y_ 715 
$node_(439) set Z_ 0.0 
$ns at 0.0 "$node_(439) off" 
$ns at 400.0 "$node_(439) on" 
$node_(440) set X_ 1011 
$node_(440) set Y_ 20 
$node_(440) set Z_ 0.0 
$ns at 0.0 "$node_(440) off" 
$ns at 400.0 "$node_(440) on" 
$node_(441) set X_ 1267 
$node_(441) set Y_ 616 
$node_(441) set Z_ 0.0 
$ns at 0.0 "$node_(441) off" 
$ns at 400.0 "$node_(441) on" 
$node_(442) set X_ 1523 
$node_(442) set Y_ 188 
$node_(442) set Z_ 0.0 
$ns at 0.0 "$node_(442) off" 
$ns at 400.0 "$node_(442) on" 
$node_(443) set X_ 358 
$node_(443) set Y_ 73 
$node_(443) set Z_ 0.0 
$ns at 0.0 "$node_(443) off" 
$ns at 400.0 "$node_(443) on" 
$node_(444) set X_ 1417 
$node_(444) set Y_ 249 
$node_(444) set Z_ 0.0 
$ns at 0.0 "$node_(444) off" 
$ns at 400.0 "$node_(444) on" 
$node_(445) set X_ 742 
$node_(445) set Y_ 889 
$node_(445) set Z_ 0.0 
$ns at 0.0 "$node_(445) off" 
$ns at 400.0 "$node_(445) on" 
$node_(446) set X_ 2920 
$node_(446) set Y_ 139 
$node_(446) set Z_ 0.0 
$ns at 0.0 "$node_(446) off" 
$ns at 400.0 "$node_(446) on" 
$node_(447) set X_ 739 
$node_(447) set Y_ 717 
$node_(447) set Z_ 0.0 
$ns at 0.0 "$node_(447) off" 
$ns at 400.0 "$node_(447) on" 
$node_(448) set X_ 2591 
$node_(448) set Y_ 95 
$node_(448) set Z_ 0.0 
$ns at 0.0 "$node_(448) off" 
$ns at 400.0 "$node_(448) on" 
$node_(449) set X_ 1365 
$node_(449) set Y_ 475 
$node_(449) set Z_ 0.0 
$ns at 0.0 "$node_(449) off" 
$ns at 400.0 "$node_(449) on" 
$node_(450) set X_ 56 
$node_(450) set Y_ 615 
$node_(450) set Z_ 0.0 
$ns at 0.0 "$node_(450) off" 
$ns at 400.0 "$node_(450) on" 
$node_(451) set X_ 2478 
$node_(451) set Y_ 164 
$node_(451) set Z_ 0.0 
$ns at 0.0 "$node_(451) off" 
$ns at 400.0 "$node_(451) on" 
$node_(452) set X_ 1958 
$node_(452) set Y_ 640 
$node_(452) set Z_ 0.0 
$ns at 0.0 "$node_(452) off" 
$ns at 400.0 "$node_(452) on" 
$node_(453) set X_ 1069 
$node_(453) set Y_ 209 
$node_(453) set Z_ 0.0 
$ns at 0.0 "$node_(453) off" 
$ns at 400.0 "$node_(453) on" 
$node_(454) set X_ 955 
$node_(454) set Y_ 109 
$node_(454) set Z_ 0.0 
$ns at 0.0 "$node_(454) off" 
$ns at 400.0 "$node_(454) on" 
$node_(455) set X_ 1290 
$node_(455) set Y_ 937 
$node_(455) set Z_ 0.0 
$ns at 0.0 "$node_(455) off" 
$ns at 400.0 "$node_(455) on" 
$node_(456) set X_ 2205 
$node_(456) set Y_ 62 
$node_(456) set Z_ 0.0 
$ns at 0.0 "$node_(456) off" 
$ns at 400.0 "$node_(456) on" 
$node_(457) set X_ 2525 
$node_(457) set Y_ 704 
$node_(457) set Z_ 0.0 
$ns at 0.0 "$node_(457) off" 
$ns at 400.0 "$node_(457) on" 
$node_(458) set X_ 393 
$node_(458) set Y_ 478 
$node_(458) set Z_ 0.0 
$ns at 0.0 "$node_(458) off" 
$ns at 400.0 "$node_(458) on" 
$node_(459) set X_ 12 
$node_(459) set Y_ 472 
$node_(459) set Z_ 0.0 
$ns at 0.0 "$node_(459) off" 
$ns at 400.0 "$node_(459) on" 
$node_(460) set X_ 2876 
$node_(460) set Y_ 896 
$node_(460) set Z_ 0.0 
$ns at 0.0 "$node_(460) off" 
$ns at 400.0 "$node_(460) on" 
$node_(461) set X_ 2186 
$node_(461) set Y_ 369 
$node_(461) set Z_ 0.0 
$ns at 0.0 "$node_(461) off" 
$ns at 400.0 "$node_(461) on" 
$node_(462) set X_ 2066 
$node_(462) set Y_ 654 
$node_(462) set Z_ 0.0 
$ns at 0.0 "$node_(462) off" 
$ns at 400.0 "$node_(462) on" 
$node_(463) set X_ 32 
$node_(463) set Y_ 850 
$node_(463) set Z_ 0.0 
$ns at 0.0 "$node_(463) off" 
$ns at 400.0 "$node_(463) on" 
$node_(464) set X_ 2649 
$node_(464) set Y_ 271 
$node_(464) set Z_ 0.0 
$ns at 0.0 "$node_(464) off" 
$ns at 400.0 "$node_(464) on" 
$node_(465) set X_ 1363 
$node_(465) set Y_ 621 
$node_(465) set Z_ 0.0 
$ns at 0.0 "$node_(465) off" 
$ns at 400.0 "$node_(465) on" 
$node_(466) set X_ 2716 
$node_(466) set Y_ 115 
$node_(466) set Z_ 0.0 
$ns at 0.0 "$node_(466) off" 
$ns at 400.0 "$node_(466) on" 
$node_(467) set X_ 985 
$node_(467) set Y_ 406 
$node_(467) set Z_ 0.0 
$ns at 0.0 "$node_(467) off" 
$ns at 400.0 "$node_(467) on" 
$node_(468) set X_ 1284 
$node_(468) set Y_ 974 
$node_(468) set Z_ 0.0 
$ns at 0.0 "$node_(468) off" 
$ns at 400.0 "$node_(468) on" 
$node_(469) set X_ 2250 
$node_(469) set Y_ 964 
$node_(469) set Z_ 0.0 
$ns at 0.0 "$node_(469) off" 
$ns at 400.0 "$node_(469) on" 
$node_(470) set X_ 1102 
$node_(470) set Y_ 584 
$node_(470) set Z_ 0.0 
$ns at 0.0 "$node_(470) off" 
$ns at 400.0 "$node_(470) on" 
$node_(471) set X_ 529 
$node_(471) set Y_ 517 
$node_(471) set Z_ 0.0 
$ns at 0.0 "$node_(471) off" 
$ns at 400.0 "$node_(471) on" 
$node_(472) set X_ 7 
$node_(472) set Y_ 473 
$node_(472) set Z_ 0.0 
$ns at 0.0 "$node_(472) off" 
$ns at 400.0 "$node_(472) on" 
$node_(473) set X_ 580 
$node_(473) set Y_ 873 
$node_(473) set Z_ 0.0 
$ns at 0.0 "$node_(473) off" 
$ns at 400.0 "$node_(473) on" 
$node_(474) set X_ 2412 
$node_(474) set Y_ 704 
$node_(474) set Z_ 0.0 
$ns at 0.0 "$node_(474) off" 
$ns at 400.0 "$node_(474) on" 
$node_(475) set X_ 1749 
$node_(475) set Y_ 116 
$node_(475) set Z_ 0.0 
$ns at 0.0 "$node_(475) off" 
$ns at 400.0 "$node_(475) on" 
$node_(476) set X_ 2815 
$node_(476) set Y_ 241 
$node_(476) set Z_ 0.0 
$ns at 0.0 "$node_(476) off" 
$ns at 400.0 "$node_(476) on" 
$node_(477) set X_ 2359 
$node_(477) set Y_ 643 
$node_(477) set Z_ 0.0 
$ns at 0.0 "$node_(477) off" 
$ns at 400.0 "$node_(477) on" 
$node_(478) set X_ 1517 
$node_(478) set Y_ 674 
$node_(478) set Z_ 0.0 
$ns at 0.0 "$node_(478) off" 
$ns at 400.0 "$node_(478) on" 
$node_(479) set X_ 506 
$node_(479) set Y_ 742 
$node_(479) set Z_ 0.0 
$ns at 0.0 "$node_(479) off" 
$ns at 400.0 "$node_(479) on" 
$node_(480) set X_ 940 
$node_(480) set Y_ 14 
$node_(480) set Z_ 0.0 
$ns at 0.0 "$node_(480) off" 
$ns at 400.0 "$node_(480) on" 
$node_(481) set X_ 2848 
$node_(481) set Y_ 643 
$node_(481) set Z_ 0.0 
$ns at 0.0 "$node_(481) off" 
$ns at 400.0 "$node_(481) on" 
$node_(482) set X_ 1164 
$node_(482) set Y_ 88 
$node_(482) set Z_ 0.0 
$ns at 0.0 "$node_(482) off" 
$ns at 400.0 "$node_(482) on" 
$node_(483) set X_ 788 
$node_(483) set Y_ 162 
$node_(483) set Z_ 0.0 
$ns at 0.0 "$node_(483) off" 
$ns at 400.0 "$node_(483) on" 
$node_(484) set X_ 1494 
$node_(484) set Y_ 834 
$node_(484) set Z_ 0.0 
$ns at 0.0 "$node_(484) off" 
$ns at 400.0 "$node_(484) on" 
$node_(485) set X_ 1733 
$node_(485) set Y_ 641 
$node_(485) set Z_ 0.0 
$ns at 0.0 "$node_(485) off" 
$ns at 400.0 "$node_(485) on" 
$node_(486) set X_ 1987 
$node_(486) set Y_ 461 
$node_(486) set Z_ 0.0 
$ns at 0.0 "$node_(486) off" 
$ns at 400.0 "$node_(486) on" 
$node_(487) set X_ 1874 
$node_(487) set Y_ 879 
$node_(487) set Z_ 0.0 
$ns at 0.0 "$node_(487) off" 
$ns at 400.0 "$node_(487) on" 
$node_(488) set X_ 8 
$node_(488) set Y_ 989 
$node_(488) set Z_ 0.0 
$ns at 0.0 "$node_(488) off" 
$ns at 400.0 "$node_(488) on" 
$node_(489) set X_ 167 
$node_(489) set Y_ 130 
$node_(489) set Z_ 0.0 
$ns at 0.0 "$node_(489) off" 
$ns at 400.0 "$node_(489) on" 
$node_(490) set X_ 962 
$node_(490) set Y_ 181 
$node_(490) set Z_ 0.0 
$ns at 0.0 "$node_(490) off" 
$ns at 400.0 "$node_(490) on" 
$node_(491) set X_ 859 
$node_(491) set Y_ 72 
$node_(491) set Z_ 0.0 
$ns at 0.0 "$node_(491) off" 
$ns at 400.0 "$node_(491) on" 
$node_(492) set X_ 1389 
$node_(492) set Y_ 229 
$node_(492) set Z_ 0.0 
$ns at 0.0 "$node_(492) off" 
$ns at 400.0 "$node_(492) on" 
$node_(493) set X_ 1113 
$node_(493) set Y_ 830 
$node_(493) set Z_ 0.0 
$ns at 0.0 "$node_(493) off" 
$ns at 400.0 "$node_(493) on" 
$node_(494) set X_ 2669 
$node_(494) set Y_ 882 
$node_(494) set Z_ 0.0 
$ns at 0.0 "$node_(494) off" 
$ns at 400.0 "$node_(494) on" 
$node_(495) set X_ 862 
$node_(495) set Y_ 769 
$node_(495) set Z_ 0.0 
$ns at 0.0 "$node_(495) off" 
$ns at 400.0 "$node_(495) on" 
$node_(496) set X_ 2522 
$node_(496) set Y_ 849 
$node_(496) set Z_ 0.0 
$ns at 0.0 "$node_(496) off" 
$ns at 400.0 "$node_(496) on" 
$node_(497) set X_ 2178 
$node_(497) set Y_ 793 
$node_(497) set Z_ 0.0 
$ns at 0.0 "$node_(497) off" 
$ns at 400.0 "$node_(497) on" 
$node_(498) set X_ 494 
$node_(498) set Y_ 459 
$node_(498) set Z_ 0.0 
$ns at 0.0 "$node_(498) off" 
$ns at 400.0 "$node_(498) on" 
$node_(499) set X_ 968 
$node_(499) set Y_ 300 
$node_(499) set Z_ 0.0 
$ns at 0.0 "$node_(499) off" 
$ns at 400.0 "$node_(499) on" 
$node_(500) set X_ 530 
$node_(500) set Y_ 517 
$node_(500) set Z_ 0.0 
$ns at 0.0 "$node_(500) off" 
$ns at 500.0 "$node_(500) on" 
$node_(501) set X_ 869 
$node_(501) set Y_ 787 
$node_(501) set Z_ 0.0 
$ns at 0.0 "$node_(501) off" 
$ns at 500.0 "$node_(501) on" 
$node_(502) set X_ 2622 
$node_(502) set Y_ 241 
$node_(502) set Z_ 0.0 
$ns at 0.0 "$node_(502) off" 
$ns at 500.0 "$node_(502) on" 
$node_(503) set X_ 1719 
$node_(503) set Y_ 339 
$node_(503) set Z_ 0.0 
$ns at 0.0 "$node_(503) off" 
$ns at 500.0 "$node_(503) on" 
$node_(504) set X_ 1417 
$node_(504) set Y_ 965 
$node_(504) set Z_ 0.0 
$ns at 0.0 "$node_(504) off" 
$ns at 500.0 "$node_(504) on" 
$node_(505) set X_ 2949 
$node_(505) set Y_ 875 
$node_(505) set Z_ 0.0 
$ns at 0.0 "$node_(505) off" 
$ns at 500.0 "$node_(505) on" 
$node_(506) set X_ 1463 
$node_(506) set Y_ 28 
$node_(506) set Z_ 0.0 
$ns at 0.0 "$node_(506) off" 
$ns at 500.0 "$node_(506) on" 
$node_(507) set X_ 696 
$node_(507) set Y_ 77 
$node_(507) set Z_ 0.0 
$ns at 0.0 "$node_(507) off" 
$ns at 500.0 "$node_(507) on" 
$node_(508) set X_ 1615 
$node_(508) set Y_ 882 
$node_(508) set Z_ 0.0 
$ns at 0.0 "$node_(508) off" 
$ns at 500.0 "$node_(508) on" 
$node_(509) set X_ 1334 
$node_(509) set Y_ 387 
$node_(509) set Z_ 0.0 
$ns at 0.0 "$node_(509) off" 
$ns at 500.0 "$node_(509) on" 
$node_(510) set X_ 1872 
$node_(510) set Y_ 8 
$node_(510) set Z_ 0.0 
$ns at 0.0 "$node_(510) off" 
$ns at 500.0 "$node_(510) on" 
$node_(511) set X_ 1526 
$node_(511) set Y_ 333 
$node_(511) set Z_ 0.0 
$ns at 0.0 "$node_(511) off" 
$ns at 500.0 "$node_(511) on" 
$node_(512) set X_ 2658 
$node_(512) set Y_ 655 
$node_(512) set Z_ 0.0 
$ns at 0.0 "$node_(512) off" 
$ns at 500.0 "$node_(512) on" 
$node_(513) set X_ 1718 
$node_(513) set Y_ 684 
$node_(513) set Z_ 0.0 
$ns at 0.0 "$node_(513) off" 
$ns at 500.0 "$node_(513) on" 
$node_(514) set X_ 2284 
$node_(514) set Y_ 777 
$node_(514) set Z_ 0.0 
$ns at 0.0 "$node_(514) off" 
$ns at 500.0 "$node_(514) on" 
$node_(515) set X_ 353 
$node_(515) set Y_ 653 
$node_(515) set Z_ 0.0 
$ns at 0.0 "$node_(515) off" 
$ns at 500.0 "$node_(515) on" 
$node_(516) set X_ 2993 
$node_(516) set Y_ 792 
$node_(516) set Z_ 0.0 
$ns at 0.0 "$node_(516) off" 
$ns at 500.0 "$node_(516) on" 
$node_(517) set X_ 840 
$node_(517) set Y_ 410 
$node_(517) set Z_ 0.0 
$ns at 0.0 "$node_(517) off" 
$ns at 500.0 "$node_(517) on" 
$node_(518) set X_ 637 
$node_(518) set Y_ 950 
$node_(518) set Z_ 0.0 
$ns at 0.0 "$node_(518) off" 
$ns at 500.0 "$node_(518) on" 
$node_(519) set X_ 1585 
$node_(519) set Y_ 692 
$node_(519) set Z_ 0.0 
$ns at 0.0 "$node_(519) off" 
$ns at 500.0 "$node_(519) on" 
$node_(520) set X_ 1671 
$node_(520) set Y_ 161 
$node_(520) set Z_ 0.0 
$ns at 0.0 "$node_(520) off" 
$ns at 500.0 "$node_(520) on" 
$node_(521) set X_ 1108 
$node_(521) set Y_ 151 
$node_(521) set Z_ 0.0 
$ns at 0.0 "$node_(521) off" 
$ns at 500.0 "$node_(521) on" 
$node_(522) set X_ 1701 
$node_(522) set Y_ 114 
$node_(522) set Z_ 0.0 
$ns at 0.0 "$node_(522) off" 
$ns at 500.0 "$node_(522) on" 
$node_(523) set X_ 1484 
$node_(523) set Y_ 439 
$node_(523) set Z_ 0.0 
$ns at 0.0 "$node_(523) off" 
$ns at 500.0 "$node_(523) on" 
$node_(524) set X_ 1413 
$node_(524) set Y_ 396 
$node_(524) set Z_ 0.0 
$ns at 0.0 "$node_(524) off" 
$ns at 500.0 "$node_(524) on" 
$node_(525) set X_ 1978 
$node_(525) set Y_ 671 
$node_(525) set Z_ 0.0 
$ns at 0.0 "$node_(525) off" 
$ns at 500.0 "$node_(525) on" 
$node_(526) set X_ 196 
$node_(526) set Y_ 94 
$node_(526) set Z_ 0.0 
$ns at 0.0 "$node_(526) off" 
$ns at 500.0 "$node_(526) on" 
$node_(527) set X_ 1900 
$node_(527) set Y_ 80 
$node_(527) set Z_ 0.0 
$ns at 0.0 "$node_(527) off" 
$ns at 500.0 "$node_(527) on" 
$node_(528) set X_ 2299 
$node_(528) set Y_ 87 
$node_(528) set Z_ 0.0 
$ns at 0.0 "$node_(528) off" 
$ns at 500.0 "$node_(528) on" 
$node_(529) set X_ 2304 
$node_(529) set Y_ 160 
$node_(529) set Z_ 0.0 
$ns at 0.0 "$node_(529) off" 
$ns at 500.0 "$node_(529) on" 
$node_(530) set X_ 1797 
$node_(530) set Y_ 784 
$node_(530) set Z_ 0.0 
$ns at 0.0 "$node_(530) off" 
$ns at 500.0 "$node_(530) on" 
$node_(531) set X_ 206 
$node_(531) set Y_ 544 
$node_(531) set Z_ 0.0 
$ns at 0.0 "$node_(531) off" 
$ns at 500.0 "$node_(531) on" 
$node_(532) set X_ 2069 
$node_(532) set Y_ 624 
$node_(532) set Z_ 0.0 
$ns at 0.0 "$node_(532) off" 
$ns at 500.0 "$node_(532) on" 
$node_(533) set X_ 568 
$node_(533) set Y_ 167 
$node_(533) set Z_ 0.0 
$ns at 0.0 "$node_(533) off" 
$ns at 500.0 "$node_(533) on" 
$node_(534) set X_ 921 
$node_(534) set Y_ 24 
$node_(534) set Z_ 0.0 
$ns at 0.0 "$node_(534) off" 
$ns at 500.0 "$node_(534) on" 
$node_(535) set X_ 1252 
$node_(535) set Y_ 51 
$node_(535) set Z_ 0.0 
$ns at 0.0 "$node_(535) off" 
$ns at 500.0 "$node_(535) on" 
$node_(536) set X_ 1794 
$node_(536) set Y_ 793 
$node_(536) set Z_ 0.0 
$ns at 0.0 "$node_(536) off" 
$ns at 500.0 "$node_(536) on" 
$node_(537) set X_ 1691 
$node_(537) set Y_ 139 
$node_(537) set Z_ 0.0 
$ns at 0.0 "$node_(537) off" 
$ns at 500.0 "$node_(537) on" 
$node_(538) set X_ 2905 
$node_(538) set Y_ 264 
$node_(538) set Z_ 0.0 
$ns at 0.0 "$node_(538) off" 
$ns at 500.0 "$node_(538) on" 
$node_(539) set X_ 1887 
$node_(539) set Y_ 195 
$node_(539) set Z_ 0.0 
$ns at 0.0 "$node_(539) off" 
$ns at 500.0 "$node_(539) on" 
$node_(540) set X_ 1403 
$node_(540) set Y_ 502 
$node_(540) set Z_ 0.0 
$ns at 0.0 "$node_(540) off" 
$ns at 500.0 "$node_(540) on" 
$node_(541) set X_ 845 
$node_(541) set Y_ 746 
$node_(541) set Z_ 0.0 
$ns at 0.0 "$node_(541) off" 
$ns at 500.0 "$node_(541) on" 
$node_(542) set X_ 1947 
$node_(542) set Y_ 5 
$node_(542) set Z_ 0.0 
$ns at 0.0 "$node_(542) off" 
$ns at 500.0 "$node_(542) on" 
$node_(543) set X_ 1359 
$node_(543) set Y_ 366 
$node_(543) set Z_ 0.0 
$ns at 0.0 "$node_(543) off" 
$ns at 500.0 "$node_(543) on" 
$node_(544) set X_ 321 
$node_(544) set Y_ 245 
$node_(544) set Z_ 0.0 
$ns at 0.0 "$node_(544) off" 
$ns at 500.0 "$node_(544) on" 
$node_(545) set X_ 2463 
$node_(545) set Y_ 424 
$node_(545) set Z_ 0.0 
$ns at 0.0 "$node_(545) off" 
$ns at 500.0 "$node_(545) on" 
$node_(546) set X_ 932 
$node_(546) set Y_ 248 
$node_(546) set Z_ 0.0 
$ns at 0.0 "$node_(546) off" 
$ns at 500.0 "$node_(546) on" 
$node_(547) set X_ 1665 
$node_(547) set Y_ 570 
$node_(547) set Z_ 0.0 
$ns at 0.0 "$node_(547) off" 
$ns at 500.0 "$node_(547) on" 
$node_(548) set X_ 1200 
$node_(548) set Y_ 163 
$node_(548) set Z_ 0.0 
$ns at 0.0 "$node_(548) off" 
$ns at 500.0 "$node_(548) on" 
$node_(549) set X_ 1365 
$node_(549) set Y_ 794 
$node_(549) set Z_ 0.0 
$ns at 0.0 "$node_(549) off" 
$ns at 500.0 "$node_(549) on" 
$node_(550) set X_ 1012 
$node_(550) set Y_ 447 
$node_(550) set Z_ 0.0 
$ns at 0.0 "$node_(550) off" 
$ns at 500.0 "$node_(550) on" 
$node_(551) set X_ 1629 
$node_(551) set Y_ 944 
$node_(551) set Z_ 0.0 
$ns at 0.0 "$node_(551) off" 
$ns at 500.0 "$node_(551) on" 
$node_(552) set X_ 507 
$node_(552) set Y_ 824 
$node_(552) set Z_ 0.0 
$ns at 0.0 "$node_(552) off" 
$ns at 500.0 "$node_(552) on" 
$node_(553) set X_ 697 
$node_(553) set Y_ 902 
$node_(553) set Z_ 0.0 
$ns at 0.0 "$node_(553) off" 
$ns at 500.0 "$node_(553) on" 
$node_(554) set X_ 571 
$node_(554) set Y_ 705 
$node_(554) set Z_ 0.0 
$ns at 0.0 "$node_(554) off" 
$ns at 500.0 "$node_(554) on" 
$node_(555) set X_ 1310 
$node_(555) set Y_ 508 
$node_(555) set Z_ 0.0 
$ns at 0.0 "$node_(555) off" 
$ns at 500.0 "$node_(555) on" 
$node_(556) set X_ 1451 
$node_(556) set Y_ 75 
$node_(556) set Z_ 0.0 
$ns at 0.0 "$node_(556) off" 
$ns at 500.0 "$node_(556) on" 
$node_(557) set X_ 1114 
$node_(557) set Y_ 443 
$node_(557) set Z_ 0.0 
$ns at 0.0 "$node_(557) off" 
$ns at 500.0 "$node_(557) on" 
$node_(558) set X_ 1931 
$node_(558) set Y_ 191 
$node_(558) set Z_ 0.0 
$ns at 0.0 "$node_(558) off" 
$ns at 500.0 "$node_(558) on" 
$node_(559) set X_ 1002 
$node_(559) set Y_ 971 
$node_(559) set Z_ 0.0 
$ns at 0.0 "$node_(559) off" 
$ns at 500.0 "$node_(559) on" 
$node_(560) set X_ 1503 
$node_(560) set Y_ 590 
$node_(560) set Z_ 0.0 
$ns at 0.0 "$node_(560) off" 
$ns at 500.0 "$node_(560) on" 
$node_(561) set X_ 1382 
$node_(561) set Y_ 405 
$node_(561) set Z_ 0.0 
$ns at 0.0 "$node_(561) off" 
$ns at 500.0 "$node_(561) on" 
$node_(562) set X_ 929 
$node_(562) set Y_ 29 
$node_(562) set Z_ 0.0 
$ns at 0.0 "$node_(562) off" 
$ns at 500.0 "$node_(562) on" 
$node_(563) set X_ 922 
$node_(563) set Y_ 626 
$node_(563) set Z_ 0.0 
$ns at 0.0 "$node_(563) off" 
$ns at 500.0 "$node_(563) on" 
$node_(564) set X_ 501 
$node_(564) set Y_ 970 
$node_(564) set Z_ 0.0 
$ns at 0.0 "$node_(564) off" 
$ns at 500.0 "$node_(564) on" 
$node_(565) set X_ 345 
$node_(565) set Y_ 795 
$node_(565) set Z_ 0.0 
$ns at 0.0 "$node_(565) off" 
$ns at 500.0 "$node_(565) on" 
$node_(566) set X_ 1237 
$node_(566) set Y_ 138 
$node_(566) set Z_ 0.0 
$ns at 0.0 "$node_(566) off" 
$ns at 500.0 "$node_(566) on" 
$node_(567) set X_ 2378 
$node_(567) set Y_ 645 
$node_(567) set Z_ 0.0 
$ns at 0.0 "$node_(567) off" 
$ns at 500.0 "$node_(567) on" 
$node_(568) set X_ 1084 
$node_(568) set Y_ 507 
$node_(568) set Z_ 0.0 
$ns at 0.0 "$node_(568) off" 
$ns at 500.0 "$node_(568) on" 
$node_(569) set X_ 2927 
$node_(569) set Y_ 389 
$node_(569) set Z_ 0.0 
$ns at 0.0 "$node_(569) off" 
$ns at 500.0 "$node_(569) on" 
$node_(570) set X_ 44 
$node_(570) set Y_ 765 
$node_(570) set Z_ 0.0 
$ns at 0.0 "$node_(570) off" 
$ns at 500.0 "$node_(570) on" 
$node_(571) set X_ 2970 
$node_(571) set Y_ 323 
$node_(571) set Z_ 0.0 
$ns at 0.0 "$node_(571) off" 
$ns at 500.0 "$node_(571) on" 
$node_(572) set X_ 965 
$node_(572) set Y_ 984 
$node_(572) set Z_ 0.0 
$ns at 0.0 "$node_(572) off" 
$ns at 500.0 "$node_(572) on" 
$node_(573) set X_ 620 
$node_(573) set Y_ 670 
$node_(573) set Z_ 0.0 
$ns at 0.0 "$node_(573) off" 
$ns at 500.0 "$node_(573) on" 
$node_(574) set X_ 467 
$node_(574) set Y_ 701 
$node_(574) set Z_ 0.0 
$ns at 0.0 "$node_(574) off" 
$ns at 500.0 "$node_(574) on" 
$node_(575) set X_ 146 
$node_(575) set Y_ 67 
$node_(575) set Z_ 0.0 
$ns at 0.0 "$node_(575) off" 
$ns at 500.0 "$node_(575) on" 
$node_(576) set X_ 1266 
$node_(576) set Y_ 117 
$node_(576) set Z_ 0.0 
$ns at 0.0 "$node_(576) off" 
$ns at 500.0 "$node_(576) on" 
$node_(577) set X_ 2622 
$node_(577) set Y_ 380 
$node_(577) set Z_ 0.0 
$ns at 0.0 "$node_(577) off" 
$ns at 500.0 "$node_(577) on" 
$node_(578) set X_ 1818 
$node_(578) set Y_ 415 
$node_(578) set Z_ 0.0 
$ns at 0.0 "$node_(578) off" 
$ns at 500.0 "$node_(578) on" 
$node_(579) set X_ 168 
$node_(579) set Y_ 185 
$node_(579) set Z_ 0.0 
$ns at 0.0 "$node_(579) off" 
$ns at 500.0 "$node_(579) on" 
$node_(580) set X_ 1932 
$node_(580) set Y_ 500 
$node_(580) set Z_ 0.0 
$ns at 0.0 "$node_(580) off" 
$ns at 500.0 "$node_(580) on" 
$node_(581) set X_ 2573 
$node_(581) set Y_ 372 
$node_(581) set Z_ 0.0 
$ns at 0.0 "$node_(581) off" 
$ns at 500.0 "$node_(581) on" 
$node_(582) set X_ 601 
$node_(582) set Y_ 593 
$node_(582) set Z_ 0.0 
$ns at 0.0 "$node_(582) off" 
$ns at 500.0 "$node_(582) on" 
$node_(583) set X_ 288 
$node_(583) set Y_ 776 
$node_(583) set Z_ 0.0 
$ns at 0.0 "$node_(583) off" 
$ns at 500.0 "$node_(583) on" 
$node_(584) set X_ 960 
$node_(584) set Y_ 180 
$node_(584) set Z_ 0.0 
$ns at 0.0 "$node_(584) off" 
$ns at 500.0 "$node_(584) on" 
$node_(585) set X_ 571 
$node_(585) set Y_ 678 
$node_(585) set Z_ 0.0 
$ns at 0.0 "$node_(585) off" 
$ns at 500.0 "$node_(585) on" 
$node_(586) set X_ 2842 
$node_(586) set Y_ 829 
$node_(586) set Z_ 0.0 
$ns at 0.0 "$node_(586) off" 
$ns at 500.0 "$node_(586) on" 
$node_(587) set X_ 2701 
$node_(587) set Y_ 274 
$node_(587) set Z_ 0.0 
$ns at 0.0 "$node_(587) off" 
$ns at 500.0 "$node_(587) on" 
$node_(588) set X_ 2939 
$node_(588) set Y_ 203 
$node_(588) set Z_ 0.0 
$ns at 0.0 "$node_(588) off" 
$ns at 500.0 "$node_(588) on" 
$node_(589) set X_ 2886 
$node_(589) set Y_ 971 
$node_(589) set Z_ 0.0 
$ns at 0.0 "$node_(589) off" 
$ns at 500.0 "$node_(589) on" 
$node_(590) set X_ 1154 
$node_(590) set Y_ 446 
$node_(590) set Z_ 0.0 
$ns at 0.0 "$node_(590) off" 
$ns at 500.0 "$node_(590) on" 
$node_(591) set X_ 2584 
$node_(591) set Y_ 433 
$node_(591) set Z_ 0.0 
$ns at 0.0 "$node_(591) off" 
$ns at 500.0 "$node_(591) on" 
$node_(592) set X_ 1150 
$node_(592) set Y_ 769 
$node_(592) set Z_ 0.0 
$ns at 0.0 "$node_(592) off" 
$ns at 500.0 "$node_(592) on" 
$node_(593) set X_ 587 
$node_(593) set Y_ 849 
$node_(593) set Z_ 0.0 
$ns at 0.0 "$node_(593) off" 
$ns at 500.0 "$node_(593) on" 
$node_(594) set X_ 2625 
$node_(594) set Y_ 685 
$node_(594) set Z_ 0.0 
$ns at 0.0 "$node_(594) off" 
$ns at 500.0 "$node_(594) on" 
$node_(595) set X_ 1275 
$node_(595) set Y_ 826 
$node_(595) set Z_ 0.0 
$ns at 0.0 "$node_(595) off" 
$ns at 500.0 "$node_(595) on" 
$node_(596) set X_ 223 
$node_(596) set Y_ 836 
$node_(596) set Z_ 0.0 
$ns at 0.0 "$node_(596) off" 
$ns at 500.0 "$node_(596) on" 
$node_(597) set X_ 977 
$node_(597) set Y_ 613 
$node_(597) set Z_ 0.0 
$ns at 0.0 "$node_(597) off" 
$ns at 500.0 "$node_(597) on" 
$node_(598) set X_ 2424 
$node_(598) set Y_ 765 
$node_(598) set Z_ 0.0 
$ns at 0.0 "$node_(598) off" 
$ns at 500.0 "$node_(598) on" 
$node_(599) set X_ 401 
$node_(599) set Y_ 140 
$node_(599) set Z_ 0.0 
$ns at 0.0 "$node_(599) off" 
$ns at 500.0 "$node_(599) on" 
$node_(600) set X_ 93 
$node_(600) set Y_ 312 
$node_(600) set Z_ 0.0 
$ns at 0.0 "$node_(600) off" 
$ns at 600.0 "$node_(600) on" 
$node_(601) set X_ 553 
$node_(601) set Y_ 471 
$node_(601) set Z_ 0.0 
$ns at 0.0 "$node_(601) off" 
$ns at 600.0 "$node_(601) on" 
$node_(602) set X_ 2733 
$node_(602) set Y_ 534 
$node_(602) set Z_ 0.0 
$ns at 0.0 "$node_(602) off" 
$ns at 600.0 "$node_(602) on" 
$node_(603) set X_ 2520 
$node_(603) set Y_ 830 
$node_(603) set Z_ 0.0 
$ns at 0.0 "$node_(603) off" 
$ns at 600.0 "$node_(603) on" 
$node_(604) set X_ 754 
$node_(604) set Y_ 168 
$node_(604) set Z_ 0.0 
$ns at 0.0 "$node_(604) off" 
$ns at 600.0 "$node_(604) on" 
$node_(605) set X_ 1905 
$node_(605) set Y_ 337 
$node_(605) set Z_ 0.0 
$ns at 0.0 "$node_(605) off" 
$ns at 600.0 "$node_(605) on" 
$node_(606) set X_ 385 
$node_(606) set Y_ 710 
$node_(606) set Z_ 0.0 
$ns at 0.0 "$node_(606) off" 
$ns at 600.0 "$node_(606) on" 
$node_(607) set X_ 2575 
$node_(607) set Y_ 919 
$node_(607) set Z_ 0.0 
$ns at 0.0 "$node_(607) off" 
$ns at 600.0 "$node_(607) on" 
$node_(608) set X_ 1055 
$node_(608) set Y_ 111 
$node_(608) set Z_ 0.0 
$ns at 0.0 "$node_(608) off" 
$ns at 600.0 "$node_(608) on" 
$node_(609) set X_ 745 
$node_(609) set Y_ 657 
$node_(609) set Z_ 0.0 
$ns at 0.0 "$node_(609) off" 
$ns at 600.0 "$node_(609) on" 
$node_(610) set X_ 2319 
$node_(610) set Y_ 946 
$node_(610) set Z_ 0.0 
$ns at 0.0 "$node_(610) off" 
$ns at 600.0 "$node_(610) on" 
$node_(611) set X_ 230 
$node_(611) set Y_ 12 
$node_(611) set Z_ 0.0 
$ns at 0.0 "$node_(611) off" 
$ns at 600.0 "$node_(611) on" 
$node_(612) set X_ 1540 
$node_(612) set Y_ 667 
$node_(612) set Z_ 0.0 
$ns at 0.0 "$node_(612) off" 
$ns at 600.0 "$node_(612) on" 
$node_(613) set X_ 1995 
$node_(613) set Y_ 926 
$node_(613) set Z_ 0.0 
$ns at 0.0 "$node_(613) off" 
$ns at 600.0 "$node_(613) on" 
$node_(614) set X_ 2737 
$node_(614) set Y_ 210 
$node_(614) set Z_ 0.0 
$ns at 0.0 "$node_(614) off" 
$ns at 600.0 "$node_(614) on" 
$node_(615) set X_ 883 
$node_(615) set Y_ 815 
$node_(615) set Z_ 0.0 
$ns at 0.0 "$node_(615) off" 
$ns at 600.0 "$node_(615) on" 
$node_(616) set X_ 1068 
$node_(616) set Y_ 794 
$node_(616) set Z_ 0.0 
$ns at 0.0 "$node_(616) off" 
$ns at 600.0 "$node_(616) on" 
$node_(617) set X_ 1625 
$node_(617) set Y_ 845 
$node_(617) set Z_ 0.0 
$ns at 0.0 "$node_(617) off" 
$ns at 600.0 "$node_(617) on" 
$node_(618) set X_ 564 
$node_(618) set Y_ 221 
$node_(618) set Z_ 0.0 
$ns at 0.0 "$node_(618) off" 
$ns at 600.0 "$node_(618) on" 
$node_(619) set X_ 935 
$node_(619) set Y_ 705 
$node_(619) set Z_ 0.0 
$ns at 0.0 "$node_(619) off" 
$ns at 600.0 "$node_(619) on" 
$node_(620) set X_ 1718 
$node_(620) set Y_ 380 
$node_(620) set Z_ 0.0 
$ns at 0.0 "$node_(620) off" 
$ns at 600.0 "$node_(620) on" 
$node_(621) set X_ 666 
$node_(621) set Y_ 264 
$node_(621) set Z_ 0.0 
$ns at 0.0 "$node_(621) off" 
$ns at 600.0 "$node_(621) on" 
$node_(622) set X_ 1609 
$node_(622) set Y_ 915 
$node_(622) set Z_ 0.0 
$ns at 0.0 "$node_(622) off" 
$ns at 600.0 "$node_(622) on" 
$node_(623) set X_ 1600 
$node_(623) set Y_ 164 
$node_(623) set Z_ 0.0 
$ns at 0.0 "$node_(623) off" 
$ns at 600.0 "$node_(623) on" 
$node_(624) set X_ 1218 
$node_(624) set Y_ 246 
$node_(624) set Z_ 0.0 
$ns at 0.0 "$node_(624) off" 
$ns at 600.0 "$node_(624) on" 
$node_(625) set X_ 1592 
$node_(625) set Y_ 362 
$node_(625) set Z_ 0.0 
$ns at 0.0 "$node_(625) off" 
$ns at 600.0 "$node_(625) on" 
$node_(626) set X_ 1518 
$node_(626) set Y_ 199 
$node_(626) set Z_ 0.0 
$ns at 0.0 "$node_(626) off" 
$ns at 600.0 "$node_(626) on" 
$node_(627) set X_ 327 
$node_(627) set Y_ 119 
$node_(627) set Z_ 0.0 
$ns at 0.0 "$node_(627) off" 
$ns at 600.0 "$node_(627) on" 
$node_(628) set X_ 908 
$node_(628) set Y_ 520 
$node_(628) set Z_ 0.0 
$ns at 0.0 "$node_(628) off" 
$ns at 600.0 "$node_(628) on" 
$node_(629) set X_ 987 
$node_(629) set Y_ 723 
$node_(629) set Z_ 0.0 
$ns at 0.0 "$node_(629) off" 
$ns at 600.0 "$node_(629) on" 
$node_(630) set X_ 415 
$node_(630) set Y_ 469 
$node_(630) set Z_ 0.0 
$ns at 0.0 "$node_(630) off" 
$ns at 600.0 "$node_(630) on" 
$node_(631) set X_ 2651 
$node_(631) set Y_ 492 
$node_(631) set Z_ 0.0 
$ns at 0.0 "$node_(631) off" 
$ns at 600.0 "$node_(631) on" 
$node_(632) set X_ 958 
$node_(632) set Y_ 482 
$node_(632) set Z_ 0.0 
$ns at 0.0 "$node_(632) off" 
$ns at 600.0 "$node_(632) on" 
$node_(633) set X_ 2207 
$node_(633) set Y_ 248 
$node_(633) set Z_ 0.0 
$ns at 0.0 "$node_(633) off" 
$ns at 600.0 "$node_(633) on" 
$node_(634) set X_ 1839 
$node_(634) set Y_ 635 
$node_(634) set Z_ 0.0 
$ns at 0.0 "$node_(634) off" 
$ns at 600.0 "$node_(634) on" 
$node_(635) set X_ 2010 
$node_(635) set Y_ 507 
$node_(635) set Z_ 0.0 
$ns at 0.0 "$node_(635) off" 
$ns at 600.0 "$node_(635) on" 
$node_(636) set X_ 364 
$node_(636) set Y_ 262 
$node_(636) set Z_ 0.0 
$ns at 0.0 "$node_(636) off" 
$ns at 600.0 "$node_(636) on" 
$node_(637) set X_ 438 
$node_(637) set Y_ 63 
$node_(637) set Z_ 0.0 
$ns at 0.0 "$node_(637) off" 
$ns at 600.0 "$node_(637) on" 
$node_(638) set X_ 352 
$node_(638) set Y_ 630 
$node_(638) set Z_ 0.0 
$ns at 0.0 "$node_(638) off" 
$ns at 600.0 "$node_(638) on" 
$node_(639) set X_ 1854 
$node_(639) set Y_ 563 
$node_(639) set Z_ 0.0 
$ns at 0.0 "$node_(639) off" 
$ns at 600.0 "$node_(639) on" 
$node_(640) set X_ 1950 
$node_(640) set Y_ 985 
$node_(640) set Z_ 0.0 
$ns at 0.0 "$node_(640) off" 
$ns at 600.0 "$node_(640) on" 
$node_(641) set X_ 1371 
$node_(641) set Y_ 862 
$node_(641) set Z_ 0.0 
$ns at 0.0 "$node_(641) off" 
$ns at 600.0 "$node_(641) on" 
$node_(642) set X_ 1940 
$node_(642) set Y_ 669 
$node_(642) set Z_ 0.0 
$ns at 0.0 "$node_(642) off" 
$ns at 600.0 "$node_(642) on" 
$node_(643) set X_ 2102 
$node_(643) set Y_ 715 
$node_(643) set Z_ 0.0 
$ns at 0.0 "$node_(643) off" 
$ns at 600.0 "$node_(643) on" 
$node_(644) set X_ 2382 
$node_(644) set Y_ 243 
$node_(644) set Z_ 0.0 
$ns at 0.0 "$node_(644) off" 
$ns at 600.0 "$node_(644) on" 
$node_(645) set X_ 390 
$node_(645) set Y_ 355 
$node_(645) set Z_ 0.0 
$ns at 0.0 "$node_(645) off" 
$ns at 600.0 "$node_(645) on" 
$node_(646) set X_ 2071 
$node_(646) set Y_ 708 
$node_(646) set Z_ 0.0 
$ns at 0.0 "$node_(646) off" 
$ns at 600.0 "$node_(646) on" 
$node_(647) set X_ 1746 
$node_(647) set Y_ 71 
$node_(647) set Z_ 0.0 
$ns at 0.0 "$node_(647) off" 
$ns at 600.0 "$node_(647) on" 
$node_(648) set X_ 1932 
$node_(648) set Y_ 996 
$node_(648) set Z_ 0.0 
$ns at 0.0 "$node_(648) off" 
$ns at 600.0 "$node_(648) on" 
$node_(649) set X_ 2982 
$node_(649) set Y_ 746 
$node_(649) set Z_ 0.0 
$ns at 0.0 "$node_(649) off" 
$ns at 600.0 "$node_(649) on" 
$node_(650) set X_ 40 
$node_(650) set Y_ 874 
$node_(650) set Z_ 0.0 
$ns at 0.0 "$node_(650) off" 
$ns at 600.0 "$node_(650) on" 
$node_(651) set X_ 1172 
$node_(651) set Y_ 643 
$node_(651) set Z_ 0.0 
$ns at 0.0 "$node_(651) off" 
$ns at 600.0 "$node_(651) on" 
$node_(652) set X_ 499 
$node_(652) set Y_ 270 
$node_(652) set Z_ 0.0 
$ns at 0.0 "$node_(652) off" 
$ns at 600.0 "$node_(652) on" 
$node_(653) set X_ 2798 
$node_(653) set Y_ 420 
$node_(653) set Z_ 0.0 
$ns at 0.0 "$node_(653) off" 
$ns at 600.0 "$node_(653) on" 
$node_(654) set X_ 2975 
$node_(654) set Y_ 841 
$node_(654) set Z_ 0.0 
$ns at 0.0 "$node_(654) off" 
$ns at 600.0 "$node_(654) on" 
$node_(655) set X_ 504 
$node_(655) set Y_ 478 
$node_(655) set Z_ 0.0 
$ns at 0.0 "$node_(655) off" 
$ns at 600.0 "$node_(655) on" 
$node_(656) set X_ 1117 
$node_(656) set Y_ 266 
$node_(656) set Z_ 0.0 
$ns at 0.0 "$node_(656) off" 
$ns at 600.0 "$node_(656) on" 
$node_(657) set X_ 2541 
$node_(657) set Y_ 265 
$node_(657) set Z_ 0.0 
$ns at 0.0 "$node_(657) off" 
$ns at 600.0 "$node_(657) on" 
$node_(658) set X_ 606 
$node_(658) set Y_ 381 
$node_(658) set Z_ 0.0 
$ns at 0.0 "$node_(658) off" 
$ns at 600.0 "$node_(658) on" 
$node_(659) set X_ 17 
$node_(659) set Y_ 86 
$node_(659) set Z_ 0.0 
$ns at 0.0 "$node_(659) off" 
$ns at 600.0 "$node_(659) on" 
$node_(660) set X_ 966 
$node_(660) set Y_ 737 
$node_(660) set Z_ 0.0 
$ns at 0.0 "$node_(660) off" 
$ns at 600.0 "$node_(660) on" 
$node_(661) set X_ 1616 
$node_(661) set Y_ 295 
$node_(661) set Z_ 0.0 
$ns at 0.0 "$node_(661) off" 
$ns at 600.0 "$node_(661) on" 
$node_(662) set X_ 693 
$node_(662) set Y_ 604 
$node_(662) set Z_ 0.0 
$ns at 0.0 "$node_(662) off" 
$ns at 600.0 "$node_(662) on" 
$node_(663) set X_ 455 
$node_(663) set Y_ 496 
$node_(663) set Z_ 0.0 
$ns at 0.0 "$node_(663) off" 
$ns at 600.0 "$node_(663) on" 
$node_(664) set X_ 1613 
$node_(664) set Y_ 759 
$node_(664) set Z_ 0.0 
$ns at 0.0 "$node_(664) off" 
$ns at 600.0 "$node_(664) on" 
$node_(665) set X_ 1238 
$node_(665) set Y_ 517 
$node_(665) set Z_ 0.0 
$ns at 0.0 "$node_(665) off" 
$ns at 600.0 "$node_(665) on" 
$node_(666) set X_ 2713 
$node_(666) set Y_ 594 
$node_(666) set Z_ 0.0 
$ns at 0.0 "$node_(666) off" 
$ns at 600.0 "$node_(666) on" 
$node_(667) set X_ 1778 
$node_(667) set Y_ 475 
$node_(667) set Z_ 0.0 
$ns at 0.0 "$node_(667) off" 
$ns at 600.0 "$node_(667) on" 
$node_(668) set X_ 1995 
$node_(668) set Y_ 245 
$node_(668) set Z_ 0.0 
$ns at 0.0 "$node_(668) off" 
$ns at 600.0 "$node_(668) on" 
$node_(669) set X_ 413 
$node_(669) set Y_ 206 
$node_(669) set Z_ 0.0 
$ns at 0.0 "$node_(669) off" 
$ns at 600.0 "$node_(669) on" 
$node_(670) set X_ 1191 
$node_(670) set Y_ 453 
$node_(670) set Z_ 0.0 
$ns at 0.0 "$node_(670) off" 
$ns at 600.0 "$node_(670) on" 
$node_(671) set X_ 2678 
$node_(671) set Y_ 710 
$node_(671) set Z_ 0.0 
$ns at 0.0 "$node_(671) off" 
$ns at 600.0 "$node_(671) on" 
$node_(672) set X_ 1376 
$node_(672) set Y_ 821 
$node_(672) set Z_ 0.0 
$ns at 0.0 "$node_(672) off" 
$ns at 600.0 "$node_(672) on" 
$node_(673) set X_ 1991 
$node_(673) set Y_ 9 
$node_(673) set Z_ 0.0 
$ns at 0.0 "$node_(673) off" 
$ns at 600.0 "$node_(673) on" 
$node_(674) set X_ 2791 
$node_(674) set Y_ 981 
$node_(674) set Z_ 0.0 
$ns at 0.0 "$node_(674) off" 
$ns at 600.0 "$node_(674) on" 
$node_(675) set X_ 899 
$node_(675) set Y_ 15 
$node_(675) set Z_ 0.0 
$ns at 0.0 "$node_(675) off" 
$ns at 600.0 "$node_(675) on" 
$node_(676) set X_ 1288 
$node_(676) set Y_ 934 
$node_(676) set Z_ 0.0 
$ns at 0.0 "$node_(676) off" 
$ns at 600.0 "$node_(676) on" 
$node_(677) set X_ 717 
$node_(677) set Y_ 574 
$node_(677) set Z_ 0.0 
$ns at 0.0 "$node_(677) off" 
$ns at 600.0 "$node_(677) on" 
$node_(678) set X_ 37 
$node_(678) set Y_ 487 
$node_(678) set Z_ 0.0 
$ns at 0.0 "$node_(678) off" 
$ns at 600.0 "$node_(678) on" 
$node_(679) set X_ 1188 
$node_(679) set Y_ 851 
$node_(679) set Z_ 0.0 
$ns at 0.0 "$node_(679) off" 
$ns at 600.0 "$node_(679) on" 
$node_(680) set X_ 2187 
$node_(680) set Y_ 293 
$node_(680) set Z_ 0.0 
$ns at 0.0 "$node_(680) off" 
$ns at 600.0 "$node_(680) on" 
$node_(681) set X_ 960 
$node_(681) set Y_ 604 
$node_(681) set Z_ 0.0 
$ns at 0.0 "$node_(681) off" 
$ns at 600.0 "$node_(681) on" 
$node_(682) set X_ 1288 
$node_(682) set Y_ 452 
$node_(682) set Z_ 0.0 
$ns at 0.0 "$node_(682) off" 
$ns at 600.0 "$node_(682) on" 
$node_(683) set X_ 2421 
$node_(683) set Y_ 716 
$node_(683) set Z_ 0.0 
$ns at 0.0 "$node_(683) off" 
$ns at 600.0 "$node_(683) on" 
$node_(684) set X_ 338 
$node_(684) set Y_ 18 
$node_(684) set Z_ 0.0 
$ns at 0.0 "$node_(684) off" 
$ns at 600.0 "$node_(684) on" 
$node_(685) set X_ 1568 
$node_(685) set Y_ 533 
$node_(685) set Z_ 0.0 
$ns at 0.0 "$node_(685) off" 
$ns at 600.0 "$node_(685) on" 
$node_(686) set X_ 1330 
$node_(686) set Y_ 62 
$node_(686) set Z_ 0.0 
$ns at 0.0 "$node_(686) off" 
$ns at 600.0 "$node_(686) on" 
$node_(687) set X_ 2221 
$node_(687) set Y_ 209 
$node_(687) set Z_ 0.0 
$ns at 0.0 "$node_(687) off" 
$ns at 600.0 "$node_(687) on" 
$node_(688) set X_ 157 
$node_(688) set Y_ 97 
$node_(688) set Z_ 0.0 
$ns at 0.0 "$node_(688) off" 
$ns at 600.0 "$node_(688) on" 
$node_(689) set X_ 14 
$node_(689) set Y_ 238 
$node_(689) set Z_ 0.0 
$ns at 0.0 "$node_(689) off" 
$ns at 600.0 "$node_(689) on" 
$node_(690) set X_ 2725 
$node_(690) set Y_ 814 
$node_(690) set Z_ 0.0 
$ns at 0.0 "$node_(690) off" 
$ns at 600.0 "$node_(690) on" 
$node_(691) set X_ 1124 
$node_(691) set Y_ 813 
$node_(691) set Z_ 0.0 
$ns at 0.0 "$node_(691) off" 
$ns at 600.0 "$node_(691) on" 
$node_(692) set X_ 1016 
$node_(692) set Y_ 31 
$node_(692) set Z_ 0.0 
$ns at 0.0 "$node_(692) off" 
$ns at 600.0 "$node_(692) on" 
$node_(693) set X_ 2784 
$node_(693) set Y_ 467 
$node_(693) set Z_ 0.0 
$ns at 0.0 "$node_(693) off" 
$ns at 600.0 "$node_(693) on" 
$node_(694) set X_ 763 
$node_(694) set Y_ 720 
$node_(694) set Z_ 0.0 
$ns at 0.0 "$node_(694) off" 
$ns at 600.0 "$node_(694) on" 
$node_(695) set X_ 1101 
$node_(695) set Y_ 696 
$node_(695) set Z_ 0.0 
$ns at 0.0 "$node_(695) off" 
$ns at 600.0 "$node_(695) on" 
$node_(696) set X_ 2260 
$node_(696) set Y_ 764 
$node_(696) set Z_ 0.0 
$ns at 0.0 "$node_(696) off" 
$ns at 600.0 "$node_(696) on" 
$node_(697) set X_ 2675 
$node_(697) set Y_ 907 
$node_(697) set Z_ 0.0 
$ns at 0.0 "$node_(697) off" 
$ns at 600.0 "$node_(697) on" 
$node_(698) set X_ 1659 
$node_(698) set Y_ 812 
$node_(698) set Z_ 0.0 
$ns at 0.0 "$node_(698) off" 
$ns at 600.0 "$node_(698) on" 
$node_(699) set X_ 2997 
$node_(699) set Y_ 91 
$node_(699) set Z_ 0.0 
$ns at 0.0 "$node_(699) off" 
$ns at 600.0 "$node_(699) on" 
$node_(700) set X_ 1923 
$node_(700) set Y_ 273 
$node_(700) set Z_ 0.0 
$ns at 0.0 "$node_(700) off" 
$ns at 700.0 "$node_(700) on" 
$node_(701) set X_ 1449 
$node_(701) set Y_ 70 
$node_(701) set Z_ 0.0 
$ns at 0.0 "$node_(701) off" 
$ns at 700.0 "$node_(701) on" 
$node_(702) set X_ 355 
$node_(702) set Y_ 963 
$node_(702) set Z_ 0.0 
$ns at 0.0 "$node_(702) off" 
$ns at 700.0 "$node_(702) on" 
$node_(703) set X_ 2194 
$node_(703) set Y_ 45 
$node_(703) set Z_ 0.0 
$ns at 0.0 "$node_(703) off" 
$ns at 700.0 "$node_(703) on" 
$node_(704) set X_ 1394 
$node_(704) set Y_ 427 
$node_(704) set Z_ 0.0 
$ns at 0.0 "$node_(704) off" 
$ns at 700.0 "$node_(704) on" 
$node_(705) set X_ 1019 
$node_(705) set Y_ 421 
$node_(705) set Z_ 0.0 
$ns at 0.0 "$node_(705) off" 
$ns at 700.0 "$node_(705) on" 
$node_(706) set X_ 1048 
$node_(706) set Y_ 250 
$node_(706) set Z_ 0.0 
$ns at 0.0 "$node_(706) off" 
$ns at 700.0 "$node_(706) on" 
$node_(707) set X_ 558 
$node_(707) set Y_ 594 
$node_(707) set Z_ 0.0 
$ns at 0.0 "$node_(707) off" 
$ns at 700.0 "$node_(707) on" 
$node_(708) set X_ 2032 
$node_(708) set Y_ 972 
$node_(708) set Z_ 0.0 
$ns at 0.0 "$node_(708) off" 
$ns at 700.0 "$node_(708) on" 
$node_(709) set X_ 1105 
$node_(709) set Y_ 424 
$node_(709) set Z_ 0.0 
$ns at 0.0 "$node_(709) off" 
$ns at 700.0 "$node_(709) on" 
$node_(710) set X_ 2325 
$node_(710) set Y_ 346 
$node_(710) set Z_ 0.0 
$ns at 0.0 "$node_(710) off" 
$ns at 700.0 "$node_(710) on" 
$node_(711) set X_ 2468 
$node_(711) set Y_ 662 
$node_(711) set Z_ 0.0 
$ns at 0.0 "$node_(711) off" 
$ns at 700.0 "$node_(711) on" 
$node_(712) set X_ 1468 
$node_(712) set Y_ 772 
$node_(712) set Z_ 0.0 
$ns at 0.0 "$node_(712) off" 
$ns at 700.0 "$node_(712) on" 
$node_(713) set X_ 43 
$node_(713) set Y_ 432 
$node_(713) set Z_ 0.0 
$ns at 0.0 "$node_(713) off" 
$ns at 700.0 "$node_(713) on" 
$node_(714) set X_ 1513 
$node_(714) set Y_ 692 
$node_(714) set Z_ 0.0 
$ns at 0.0 "$node_(714) off" 
$ns at 700.0 "$node_(714) on" 
$node_(715) set X_ 2510 
$node_(715) set Y_ 236 
$node_(715) set Z_ 0.0 
$ns at 0.0 "$node_(715) off" 
$ns at 700.0 "$node_(715) on" 
$node_(716) set X_ 1099 
$node_(716) set Y_ 646 
$node_(716) set Z_ 0.0 
$ns at 0.0 "$node_(716) off" 
$ns at 700.0 "$node_(716) on" 
$node_(717) set X_ 2172 
$node_(717) set Y_ 597 
$node_(717) set Z_ 0.0 
$ns at 0.0 "$node_(717) off" 
$ns at 700.0 "$node_(717) on" 
$node_(718) set X_ 1624 
$node_(718) set Y_ 415 
$node_(718) set Z_ 0.0 
$ns at 0.0 "$node_(718) off" 
$ns at 700.0 "$node_(718) on" 
$node_(719) set X_ 119 
$node_(719) set Y_ 619 
$node_(719) set Z_ 0.0 
$ns at 0.0 "$node_(719) off" 
$ns at 700.0 "$node_(719) on" 
$node_(720) set X_ 1014 
$node_(720) set Y_ 442 
$node_(720) set Z_ 0.0 
$ns at 0.0 "$node_(720) off" 
$ns at 700.0 "$node_(720) on" 
$node_(721) set X_ 0 
$node_(721) set Y_ 226 
$node_(721) set Z_ 0.0 
$ns at 0.0 "$node_(721) off" 
$ns at 700.0 "$node_(721) on" 
$node_(722) set X_ 2011 
$node_(722) set Y_ 255 
$node_(722) set Z_ 0.0 
$ns at 0.0 "$node_(722) off" 
$ns at 700.0 "$node_(722) on" 
$node_(723) set X_ 2238 
$node_(723) set Y_ 804 
$node_(723) set Z_ 0.0 
$ns at 0.0 "$node_(723) off" 
$ns at 700.0 "$node_(723) on" 
$node_(724) set X_ 1353 
$node_(724) set Y_ 177 
$node_(724) set Z_ 0.0 
$ns at 0.0 "$node_(724) off" 
$ns at 700.0 "$node_(724) on" 
$node_(725) set X_ 2069 
$node_(725) set Y_ 259 
$node_(725) set Z_ 0.0 
$ns at 0.0 "$node_(725) off" 
$ns at 700.0 "$node_(725) on" 
$node_(726) set X_ 2614 
$node_(726) set Y_ 969 
$node_(726) set Z_ 0.0 
$ns at 0.0 "$node_(726) off" 
$ns at 700.0 "$node_(726) on" 
$node_(727) set X_ 2809 
$node_(727) set Y_ 289 
$node_(727) set Z_ 0.0 
$ns at 0.0 "$node_(727) off" 
$ns at 700.0 "$node_(727) on" 
$node_(728) set X_ 2835 
$node_(728) set Y_ 399 
$node_(728) set Z_ 0.0 
$ns at 0.0 "$node_(728) off" 
$ns at 700.0 "$node_(728) on" 
$node_(729) set X_ 1198 
$node_(729) set Y_ 789 
$node_(729) set Z_ 0.0 
$ns at 0.0 "$node_(729) off" 
$ns at 700.0 "$node_(729) on" 
$node_(730) set X_ 1403 
$node_(730) set Y_ 966 
$node_(730) set Z_ 0.0 
$ns at 0.0 "$node_(730) off" 
$ns at 700.0 "$node_(730) on" 
$node_(731) set X_ 641 
$node_(731) set Y_ 854 
$node_(731) set Z_ 0.0 
$ns at 0.0 "$node_(731) off" 
$ns at 700.0 "$node_(731) on" 
$node_(732) set X_ 2966 
$node_(732) set Y_ 88 
$node_(732) set Z_ 0.0 
$ns at 0.0 "$node_(732) off" 
$ns at 700.0 "$node_(732) on" 
$node_(733) set X_ 562 
$node_(733) set Y_ 818 
$node_(733) set Z_ 0.0 
$ns at 0.0 "$node_(733) off" 
$ns at 700.0 "$node_(733) on" 
$node_(734) set X_ 1406 
$node_(734) set Y_ 153 
$node_(734) set Z_ 0.0 
$ns at 0.0 "$node_(734) off" 
$ns at 700.0 "$node_(734) on" 
$node_(735) set X_ 979 
$node_(735) set Y_ 132 
$node_(735) set Z_ 0.0 
$ns at 0.0 "$node_(735) off" 
$ns at 700.0 "$node_(735) on" 
$node_(736) set X_ 166 
$node_(736) set Y_ 747 
$node_(736) set Z_ 0.0 
$ns at 0.0 "$node_(736) off" 
$ns at 700.0 "$node_(736) on" 
$node_(737) set X_ 2758 
$node_(737) set Y_ 641 
$node_(737) set Z_ 0.0 
$ns at 0.0 "$node_(737) off" 
$ns at 700.0 "$node_(737) on" 
$node_(738) set X_ 2428 
$node_(738) set Y_ 222 
$node_(738) set Z_ 0.0 
$ns at 0.0 "$node_(738) off" 
$ns at 700.0 "$node_(738) on" 
$node_(739) set X_ 813 
$node_(739) set Y_ 2 
$node_(739) set Z_ 0.0 
$ns at 0.0 "$node_(739) off" 
$ns at 700.0 "$node_(739) on" 
$node_(740) set X_ 800 
$node_(740) set Y_ 527 
$node_(740) set Z_ 0.0 
$ns at 0.0 "$node_(740) off" 
$ns at 700.0 "$node_(740) on" 
$node_(741) set X_ 2820 
$node_(741) set Y_ 578 
$node_(741) set Z_ 0.0 
$ns at 0.0 "$node_(741) off" 
$ns at 700.0 "$node_(741) on" 
$node_(742) set X_ 1344 
$node_(742) set Y_ 892 
$node_(742) set Z_ 0.0 
$ns at 0.0 "$node_(742) off" 
$ns at 700.0 "$node_(742) on" 
$node_(743) set X_ 760 
$node_(743) set Y_ 118 
$node_(743) set Z_ 0.0 
$ns at 0.0 "$node_(743) off" 
$ns at 700.0 "$node_(743) on" 
$node_(744) set X_ 880 
$node_(744) set Y_ 503 
$node_(744) set Z_ 0.0 
$ns at 0.0 "$node_(744) off" 
$ns at 700.0 "$node_(744) on" 
$node_(745) set X_ 2846 
$node_(745) set Y_ 938 
$node_(745) set Z_ 0.0 
$ns at 0.0 "$node_(745) off" 
$ns at 700.0 "$node_(745) on" 
$node_(746) set X_ 1578 
$node_(746) set Y_ 813 
$node_(746) set Z_ 0.0 
$ns at 0.0 "$node_(746) off" 
$ns at 700.0 "$node_(746) on" 
$node_(747) set X_ 54 
$node_(747) set Y_ 114 
$node_(747) set Z_ 0.0 
$ns at 0.0 "$node_(747) off" 
$ns at 700.0 "$node_(747) on" 
$node_(748) set X_ 1923 
$node_(748) set Y_ 465 
$node_(748) set Z_ 0.0 
$ns at 0.0 "$node_(748) off" 
$ns at 700.0 "$node_(748) on" 
$node_(749) set X_ 686 
$node_(749) set Y_ 416 
$node_(749) set Z_ 0.0 
$ns at 0.0 "$node_(749) off" 
$ns at 700.0 "$node_(749) on" 
$node_(750) set X_ 146 
$node_(750) set Y_ 147 
$node_(750) set Z_ 0.0 
$ns at 0.0 "$node_(750) off" 
$ns at 700.0 "$node_(750) on" 
$node_(751) set X_ 970 
$node_(751) set Y_ 301 
$node_(751) set Z_ 0.0 
$ns at 0.0 "$node_(751) off" 
$ns at 700.0 "$node_(751) on" 
$node_(752) set X_ 1205 
$node_(752) set Y_ 838 
$node_(752) set Z_ 0.0 
$ns at 0.0 "$node_(752) off" 
$ns at 700.0 "$node_(752) on" 
$node_(753) set X_ 1863 
$node_(753) set Y_ 346 
$node_(753) set Z_ 0.0 
$ns at 0.0 "$node_(753) off" 
$ns at 700.0 "$node_(753) on" 
$node_(754) set X_ 2377 
$node_(754) set Y_ 42 
$node_(754) set Z_ 0.0 
$ns at 0.0 "$node_(754) off" 
$ns at 700.0 "$node_(754) on" 
$node_(755) set X_ 1729 
$node_(755) set Y_ 885 
$node_(755) set Z_ 0.0 
$ns at 0.0 "$node_(755) off" 
$ns at 700.0 "$node_(755) on" 
$node_(756) set X_ 2420 
$node_(756) set Y_ 591 
$node_(756) set Z_ 0.0 
$ns at 0.0 "$node_(756) off" 
$ns at 700.0 "$node_(756) on" 
$node_(757) set X_ 2666 
$node_(757) set Y_ 472 
$node_(757) set Z_ 0.0 
$ns at 0.0 "$node_(757) off" 
$ns at 700.0 "$node_(757) on" 
$node_(758) set X_ 1194 
$node_(758) set Y_ 509 
$node_(758) set Z_ 0.0 
$ns at 0.0 "$node_(758) off" 
$ns at 700.0 "$node_(758) on" 
$node_(759) set X_ 2701 
$node_(759) set Y_ 32 
$node_(759) set Z_ 0.0 
$ns at 0.0 "$node_(759) off" 
$ns at 700.0 "$node_(759) on" 
$node_(760) set X_ 479 
$node_(760) set Y_ 259 
$node_(760) set Z_ 0.0 
$ns at 0.0 "$node_(760) off" 
$ns at 700.0 "$node_(760) on" 
$node_(761) set X_ 1102 
$node_(761) set Y_ 184 
$node_(761) set Z_ 0.0 
$ns at 0.0 "$node_(761) off" 
$ns at 700.0 "$node_(761) on" 
$node_(762) set X_ 2560 
$node_(762) set Y_ 417 
$node_(762) set Z_ 0.0 
$ns at 0.0 "$node_(762) off" 
$ns at 700.0 "$node_(762) on" 
$node_(763) set X_ 460 
$node_(763) set Y_ 311 
$node_(763) set Z_ 0.0 
$ns at 0.0 "$node_(763) off" 
$ns at 700.0 "$node_(763) on" 
$node_(764) set X_ 2959 
$node_(764) set Y_ 421 
$node_(764) set Z_ 0.0 
$ns at 0.0 "$node_(764) off" 
$ns at 700.0 "$node_(764) on" 
$node_(765) set X_ 131 
$node_(765) set Y_ 370 
$node_(765) set Z_ 0.0 
$ns at 0.0 "$node_(765) off" 
$ns at 700.0 "$node_(765) on" 
$node_(766) set X_ 2479 
$node_(766) set Y_ 621 
$node_(766) set Z_ 0.0 
$ns at 0.0 "$node_(766) off" 
$ns at 700.0 "$node_(766) on" 
$node_(767) set X_ 1998 
$node_(767) set Y_ 322 
$node_(767) set Z_ 0.0 
$ns at 0.0 "$node_(767) off" 
$ns at 700.0 "$node_(767) on" 
$node_(768) set X_ 1428 
$node_(768) set Y_ 268 
$node_(768) set Z_ 0.0 
$ns at 0.0 "$node_(768) off" 
$ns at 700.0 "$node_(768) on" 
$node_(769) set X_ 1373 
$node_(769) set Y_ 335 
$node_(769) set Z_ 0.0 
$ns at 0.0 "$node_(769) off" 
$ns at 700.0 "$node_(769) on" 
$node_(770) set X_ 1655 
$node_(770) set Y_ 431 
$node_(770) set Z_ 0.0 
$ns at 0.0 "$node_(770) off" 
$ns at 700.0 "$node_(770) on" 
$node_(771) set X_ 2164 
$node_(771) set Y_ 566 
$node_(771) set Z_ 0.0 
$ns at 0.0 "$node_(771) off" 
$ns at 700.0 "$node_(771) on" 
$node_(772) set X_ 1657 
$node_(772) set Y_ 111 
$node_(772) set Z_ 0.0 
$ns at 0.0 "$node_(772) off" 
$ns at 700.0 "$node_(772) on" 
$node_(773) set X_ 231 
$node_(773) set Y_ 445 
$node_(773) set Z_ 0.0 
$ns at 0.0 "$node_(773) off" 
$ns at 700.0 "$node_(773) on" 
$node_(774) set X_ 696 
$node_(774) set Y_ 939 
$node_(774) set Z_ 0.0 
$ns at 0.0 "$node_(774) off" 
$ns at 700.0 "$node_(774) on" 
$node_(775) set X_ 126 
$node_(775) set Y_ 846 
$node_(775) set Z_ 0.0 
$ns at 0.0 "$node_(775) off" 
$ns at 700.0 "$node_(775) on" 
$node_(776) set X_ 469 
$node_(776) set Y_ 955 
$node_(776) set Z_ 0.0 
$ns at 0.0 "$node_(776) off" 
$ns at 700.0 "$node_(776) on" 
$node_(777) set X_ 87 
$node_(777) set Y_ 428 
$node_(777) set Z_ 0.0 
$ns at 0.0 "$node_(777) off" 
$ns at 700.0 "$node_(777) on" 
$node_(778) set X_ 469 
$node_(778) set Y_ 920 
$node_(778) set Z_ 0.0 
$ns at 0.0 "$node_(778) off" 
$ns at 700.0 "$node_(778) on" 
$node_(779) set X_ 2426 
$node_(779) set Y_ 761 
$node_(779) set Z_ 0.0 
$ns at 0.0 "$node_(779) off" 
$ns at 700.0 "$node_(779) on" 
$node_(780) set X_ 1703 
$node_(780) set Y_ 479 
$node_(780) set Z_ 0.0 
$ns at 0.0 "$node_(780) off" 
$ns at 700.0 "$node_(780) on" 
$node_(781) set X_ 1034 
$node_(781) set Y_ 506 
$node_(781) set Z_ 0.0 
$ns at 0.0 "$node_(781) off" 
$ns at 700.0 "$node_(781) on" 
$node_(782) set X_ 2994 
$node_(782) set Y_ 313 
$node_(782) set Z_ 0.0 
$ns at 0.0 "$node_(782) off" 
$ns at 700.0 "$node_(782) on" 
$node_(783) set X_ 2927 
$node_(783) set Y_ 90 
$node_(783) set Z_ 0.0 
$ns at 0.0 "$node_(783) off" 
$ns at 700.0 "$node_(783) on" 
$node_(784) set X_ 2552 
$node_(784) set Y_ 69 
$node_(784) set Z_ 0.0 
$ns at 0.0 "$node_(784) off" 
$ns at 700.0 "$node_(784) on" 
$node_(785) set X_ 308 
$node_(785) set Y_ 790 
$node_(785) set Z_ 0.0 
$ns at 0.0 "$node_(785) off" 
$ns at 700.0 "$node_(785) on" 
$node_(786) set X_ 2976 
$node_(786) set Y_ 504 
$node_(786) set Z_ 0.0 
$ns at 0.0 "$node_(786) off" 
$ns at 700.0 "$node_(786) on" 
$node_(787) set X_ 2716 
$node_(787) set Y_ 107 
$node_(787) set Z_ 0.0 
$ns at 0.0 "$node_(787) off" 
$ns at 700.0 "$node_(787) on" 
$node_(788) set X_ 2273 
$node_(788) set Y_ 732 
$node_(788) set Z_ 0.0 
$ns at 0.0 "$node_(788) off" 
$ns at 700.0 "$node_(788) on" 
$node_(789) set X_ 363 
$node_(789) set Y_ 602 
$node_(789) set Z_ 0.0 
$ns at 0.0 "$node_(789) off" 
$ns at 700.0 "$node_(789) on" 
$node_(790) set X_ 2875 
$node_(790) set Y_ 914 
$node_(790) set Z_ 0.0 
$ns at 0.0 "$node_(790) off" 
$ns at 700.0 "$node_(790) on" 
$node_(791) set X_ 1769 
$node_(791) set Y_ 148 
$node_(791) set Z_ 0.0 
$ns at 0.0 "$node_(791) off" 
$ns at 700.0 "$node_(791) on" 
$node_(792) set X_ 2009 
$node_(792) set Y_ 34 
$node_(792) set Z_ 0.0 
$ns at 0.0 "$node_(792) off" 
$ns at 700.0 "$node_(792) on" 
$node_(793) set X_ 269 
$node_(793) set Y_ 663 
$node_(793) set Z_ 0.0 
$ns at 0.0 "$node_(793) off" 
$ns at 700.0 "$node_(793) on" 
$node_(794) set X_ 1104 
$node_(794) set Y_ 616 
$node_(794) set Z_ 0.0 
$ns at 0.0 "$node_(794) off" 
$ns at 700.0 "$node_(794) on" 
$node_(795) set X_ 2940 
$node_(795) set Y_ 963 
$node_(795) set Z_ 0.0 
$ns at 0.0 "$node_(795) off" 
$ns at 700.0 "$node_(795) on" 
$node_(796) set X_ 1216 
$node_(796) set Y_ 401 
$node_(796) set Z_ 0.0 
$ns at 0.0 "$node_(796) off" 
$ns at 700.0 "$node_(796) on" 
$node_(797) set X_ 866 
$node_(797) set Y_ 316 
$node_(797) set Z_ 0.0 
$ns at 0.0 "$node_(797) off" 
$ns at 700.0 "$node_(797) on" 
$node_(798) set X_ 2750 
$node_(798) set Y_ 985 
$node_(798) set Z_ 0.0 
$ns at 0.0 "$node_(798) off" 
$ns at 700.0 "$node_(798) on" 
$node_(799) set X_ 580 
$node_(799) set Y_ 659 
$node_(799) set Z_ 0.0 
$ns at 0.0 "$node_(799) off" 
$ns at 700.0 "$node_(799) on" 

# Generation of movements
$ns at 0.0 "$node_(0) setdest 93394 13333 6.0" 
$ns at 42.011108257652594 "$node_(0) setdest 29340 19040 12.0" 
$ns at 106.96791508247132 "$node_(0) setdest 63831 31115 5.0" 
$ns at 140.9591878200754 "$node_(0) setdest 20254 29108 3.0" 
$ns at 182.69009239435314 "$node_(0) setdest 120185 17458 17.0" 
$ns at 334.9650581428128 "$node_(0) setdest 96685 22491 5.0" 
$ns at 414.7168699079148 "$node_(0) setdest 160863 50142 13.0" 
$ns at 445.52476108488264 "$node_(0) setdest 160670 11993 3.0" 
$ns at 504.48710024874305 "$node_(0) setdest 187316 40345 16.0" 
$ns at 652.2711275628112 "$node_(0) setdest 139789 30499 1.0" 
$ns at 688.8429756913265 "$node_(0) setdest 4441 42839 3.0" 
$ns at 740.9630562152545 "$node_(0) setdest 160938 48563 6.0" 
$ns at 784.9115234883274 "$node_(0) setdest 34074 81729 8.0" 
$ns at 835.85428830762 "$node_(0) setdest 74798 45730 15.0" 
$ns at 891.6845830334335 "$node_(0) setdest 179166 85868 5.0" 
$ns at 0.0 "$node_(1) setdest 91942 8904 9.0" 
$ns at 100.75450587216206 "$node_(1) setdest 893 31506 13.0" 
$ns at 243.9542343423892 "$node_(1) setdest 62226 2564 12.0" 
$ns at 366.6205375242896 "$node_(1) setdest 133894 35408 20.0" 
$ns at 413.68720591774354 "$node_(1) setdest 99160 18639 17.0" 
$ns at 465.0106707552598 "$node_(1) setdest 61038 19844 7.0" 
$ns at 497.75141432642124 "$node_(1) setdest 149036 27168 12.0" 
$ns at 641.4942405202421 "$node_(1) setdest 95812 1255 13.0" 
$ns at 746.8409983561921 "$node_(1) setdest 159480 56822 10.0" 
$ns at 872.8249503047198 "$node_(1) setdest 119646 74530 15.0" 
$ns at 0.0 "$node_(2) setdest 47564 4633 1.0" 
$ns at 37.63562469187169 "$node_(2) setdest 77539 22127 13.0" 
$ns at 129.12602474458342 "$node_(2) setdest 62262 4057 17.0" 
$ns at 186.2632644241341 "$node_(2) setdest 96711 5 4.0" 
$ns at 231.42940968257454 "$node_(2) setdest 82984 42575 2.0" 
$ns at 262.7790054141056 "$node_(2) setdest 235 13040 1.0" 
$ns at 297.97181188921587 "$node_(2) setdest 143494 20717 16.0" 
$ns at 464.0332340893497 "$node_(2) setdest 64666 38091 9.0" 
$ns at 568.1741838739277 "$node_(2) setdest 46745 9587 10.0" 
$ns at 607.7591562764029 "$node_(2) setdest 191459 63081 9.0" 
$ns at 684.7566168009362 "$node_(2) setdest 122485 79355 6.0" 
$ns at 723.8870041797254 "$node_(2) setdest 56110 59183 10.0" 
$ns at 847.5055574773694 "$node_(2) setdest 59798 3960 19.0" 
$ns at 0.0 "$node_(3) setdest 54662 21259 9.0" 
$ns at 59.1388672432505 "$node_(3) setdest 13424 22594 13.0" 
$ns at 97.36358225121649 "$node_(3) setdest 36988 25668 11.0" 
$ns at 149.39231820808692 "$node_(3) setdest 68507 18393 16.0" 
$ns at 275.31533270493713 "$node_(3) setdest 10030 17990 14.0" 
$ns at 418.99370062949725 "$node_(3) setdest 93068 51386 9.0" 
$ns at 537.9458307894764 "$node_(3) setdest 70787 50041 9.0" 
$ns at 629.8962736448215 "$node_(3) setdest 79381 7576 18.0" 
$ns at 741.0453589762806 "$node_(3) setdest 150006 82983 3.0" 
$ns at 784.4878157418392 "$node_(3) setdest 89760 33640 18.0" 
$ns at 888.5249176408377 "$node_(3) setdest 28742 68173 15.0" 
$ns at 0.0 "$node_(4) setdest 63376 17036 3.0" 
$ns at 52.47392211461344 "$node_(4) setdest 42914 21819 2.0" 
$ns at 98.73936256275633 "$node_(4) setdest 75293 19138 5.0" 
$ns at 139.3641670715317 "$node_(4) setdest 82141 24360 17.0" 
$ns at 200.72230949248853 "$node_(4) setdest 117138 4775 2.0" 
$ns at 241.6374241000268 "$node_(4) setdest 26215 26946 8.0" 
$ns at 325.64601616289036 "$node_(4) setdest 6151 36511 2.0" 
$ns at 358.25678732161145 "$node_(4) setdest 118795 20860 16.0" 
$ns at 411.85684086875455 "$node_(4) setdest 29386 940 3.0" 
$ns at 447.6075330870458 "$node_(4) setdest 91668 6430 12.0" 
$ns at 486.40414135188826 "$node_(4) setdest 13597 65542 2.0" 
$ns at 533.7789413640188 "$node_(4) setdest 147943 12199 7.0" 
$ns at 566.6648143265198 "$node_(4) setdest 111610 63745 16.0" 
$ns at 709.2561322825445 "$node_(4) setdest 192337 83622 4.0" 
$ns at 776.2612376110135 "$node_(4) setdest 8298 1555 14.0" 
$ns at 854.6916048834315 "$node_(4) setdest 78117 85227 11.0" 
$ns at 899.9142940440388 "$node_(4) setdest 34393 76588 16.0" 
$ns at 0.0 "$node_(5) setdest 40213 15892 8.0" 
$ns at 82.02334502369568 "$node_(5) setdest 60261 7300 15.0" 
$ns at 200.8075304853336 "$node_(5) setdest 107974 44426 8.0" 
$ns at 286.02480949067274 "$node_(5) setdest 87610 11276 18.0" 
$ns at 348.47759436610113 "$node_(5) setdest 135227 20452 14.0" 
$ns at 422.634713329737 "$node_(5) setdest 8741 47470 14.0" 
$ns at 562.8583609379347 "$node_(5) setdest 65588 37744 15.0" 
$ns at 633.0778376988291 "$node_(5) setdest 216216 62811 18.0" 
$ns at 721.7227673106786 "$node_(5) setdest 201819 66867 9.0" 
$ns at 823.5383854015846 "$node_(5) setdest 238008 18882 9.0" 
$ns at 0.0 "$node_(6) setdest 52131 20805 7.0" 
$ns at 56.24814733690847 "$node_(6) setdest 28566 3893 2.0" 
$ns at 100.11189550379089 "$node_(6) setdest 8779 14775 8.0" 
$ns at 167.6929963055635 "$node_(6) setdest 103208 4093 12.0" 
$ns at 288.30903708740544 "$node_(6) setdest 86508 20569 7.0" 
$ns at 376.11384936325226 "$node_(6) setdest 22490 53974 17.0" 
$ns at 478.9537459468262 "$node_(6) setdest 28770 24570 11.0" 
$ns at 607.9633846908811 "$node_(6) setdest 203563 34092 13.0" 
$ns at 641.390514352793 "$node_(6) setdest 49808 56612 20.0" 
$ns at 751.0076539925866 "$node_(6) setdest 106065 26861 2.0" 
$ns at 787.5142918403224 "$node_(6) setdest 232170 61039 2.0" 
$ns at 819.0768980413413 "$node_(6) setdest 26060 38614 7.0" 
$ns at 872.6184096776443 "$node_(6) setdest 230463 5874 2.0" 
$ns at 0.0 "$node_(7) setdest 50376 24051 7.0" 
$ns at 61.70575420376915 "$node_(7) setdest 84119 21620 15.0" 
$ns at 189.9797671827495 "$node_(7) setdest 28856 11472 7.0" 
$ns at 239.43639802172945 "$node_(7) setdest 105916 42963 15.0" 
$ns at 362.1737629638832 "$node_(7) setdest 87471 32989 3.0" 
$ns at 412.52321633203405 "$node_(7) setdest 112519 27548 11.0" 
$ns at 520.1979023015898 "$node_(7) setdest 136038 59492 13.0" 
$ns at 663.3005737303117 "$node_(7) setdest 108873 56904 1.0" 
$ns at 695.8980736378535 "$node_(7) setdest 151999 78338 14.0" 
$ns at 807.5515597908526 "$node_(7) setdest 189230 45268 17.0" 
$ns at 0.0 "$node_(8) setdest 19298 28546 8.0" 
$ns at 78.69155411698569 "$node_(8) setdest 807 18139 2.0" 
$ns at 112.63837670054696 "$node_(8) setdest 11402 2517 19.0" 
$ns at 195.01770024037816 "$node_(8) setdest 99039 34195 14.0" 
$ns at 344.67009976484667 "$node_(8) setdest 79432 45569 14.0" 
$ns at 467.5683410651341 "$node_(8) setdest 81823 66101 13.0" 
$ns at 524.7495225849749 "$node_(8) setdest 200763 34440 1.0" 
$ns at 560.707130261346 "$node_(8) setdest 207407 70225 5.0" 
$ns at 608.1395909425285 "$node_(8) setdest 47947 70693 11.0" 
$ns at 717.2111320747636 "$node_(8) setdest 159349 68388 4.0" 
$ns at 771.1107362211817 "$node_(8) setdest 43906 42548 6.0" 
$ns at 814.0855840423117 "$node_(8) setdest 233998 16596 5.0" 
$ns at 857.556958496995 "$node_(8) setdest 48286 33038 17.0" 
$ns at 0.0 "$node_(9) setdest 70281 9736 4.0" 
$ns at 59.06074594122032 "$node_(9) setdest 13429 17289 4.0" 
$ns at 94.56398009510556 "$node_(9) setdest 12056 26937 16.0" 
$ns at 191.50700137542412 "$node_(9) setdest 38259 33518 15.0" 
$ns at 325.6797880198693 "$node_(9) setdest 163925 41377 13.0" 
$ns at 463.33873330776214 "$node_(9) setdest 210747 26181 18.0" 
$ns at 507.27617688471935 "$node_(9) setdest 5000 56472 6.0" 
$ns at 567.3094827162652 "$node_(9) setdest 3977 10540 16.0" 
$ns at 620.4555713444504 "$node_(9) setdest 134266 35546 17.0" 
$ns at 748.7894584614609 "$node_(9) setdest 208410 71293 6.0" 
$ns at 794.0763871616409 "$node_(9) setdest 117521 81824 7.0" 
$ns at 860.6773815606452 "$node_(9) setdest 20710 62016 5.0" 
$ns at 0.0 "$node_(10) setdest 73788 9823 11.0" 
$ns at 133.74642560211794 "$node_(10) setdest 29935 24753 6.0" 
$ns at 167.86001162823726 "$node_(10) setdest 37288 28845 1.0" 
$ns at 204.98134813436917 "$node_(10) setdest 69188 1973 17.0" 
$ns at 274.0254498416669 "$node_(10) setdest 72136 49162 19.0" 
$ns at 454.6759558088878 "$node_(10) setdest 4387 40164 5.0" 
$ns at 493.2146339271571 "$node_(10) setdest 90933 18130 5.0" 
$ns at 545.8332430814686 "$node_(10) setdest 196318 69222 4.0" 
$ns at 608.1884586714186 "$node_(10) setdest 10343 43323 5.0" 
$ns at 677.5786631831976 "$node_(10) setdest 20527 45352 3.0" 
$ns at 720.6047574618714 "$node_(10) setdest 156933 26188 5.0" 
$ns at 787.6945579755645 "$node_(10) setdest 49909 89242 13.0" 
$ns at 889.3283964804634 "$node_(10) setdest 266120 80757 10.0" 
$ns at 0.0 "$node_(11) setdest 62290 11459 18.0" 
$ns at 86.62988384892378 "$node_(11) setdest 71204 27088 1.0" 
$ns at 123.32252466023581 "$node_(11) setdest 24544 5794 1.0" 
$ns at 161.9708879904096 "$node_(11) setdest 72583 12307 8.0" 
$ns at 271.6465339772618 "$node_(11) setdest 112155 54035 1.0" 
$ns at 302.721375305523 "$node_(11) setdest 9716 43531 11.0" 
$ns at 377.85298431348434 "$node_(11) setdest 101070 57311 15.0" 
$ns at 519.4254895204265 "$node_(11) setdest 199268 48923 14.0" 
$ns at 579.178734009151 "$node_(11) setdest 101192 56663 15.0" 
$ns at 699.0760009585264 "$node_(11) setdest 207490 83344 10.0" 
$ns at 753.3322290858907 "$node_(11) setdest 59379 77206 16.0" 
$ns at 871.7043652937892 "$node_(11) setdest 59265 64708 6.0" 
$ns at 0.0 "$node_(12) setdest 36912 28914 11.0" 
$ns at 97.47438870452358 "$node_(12) setdest 87790 18737 3.0" 
$ns at 129.9054541354383 "$node_(12) setdest 29379 29919 20.0" 
$ns at 351.131632207769 "$node_(12) setdest 34568 53042 7.0" 
$ns at 407.78972492526526 "$node_(12) setdest 166103 36393 17.0" 
$ns at 599.3231951338256 "$node_(12) setdest 191761 76524 4.0" 
$ns at 630.6231876674265 "$node_(12) setdest 128490 34358 2.0" 
$ns at 670.5734784954943 "$node_(12) setdest 8566 58940 15.0" 
$ns at 807.5405590243531 "$node_(12) setdest 12303 70079 4.0" 
$ns at 846.4269343957425 "$node_(12) setdest 139692 6712 13.0" 
$ns at 0.0 "$node_(13) setdest 2377 2360 12.0" 
$ns at 67.78921746808757 "$node_(13) setdest 21719 29834 12.0" 
$ns at 197.64260065002404 "$node_(13) setdest 84909 1020 19.0" 
$ns at 243.44539406301988 "$node_(13) setdest 118507 7080 14.0" 
$ns at 290.95908731423435 "$node_(13) setdest 118099 19412 16.0" 
$ns at 402.08996629754637 "$node_(13) setdest 182793 53625 9.0" 
$ns at 513.6394883046881 "$node_(13) setdest 2741 11469 18.0" 
$ns at 607.0836132466252 "$node_(13) setdest 218619 6527 8.0" 
$ns at 693.3915108526974 "$node_(13) setdest 174664 66243 18.0" 
$ns at 838.9070040244384 "$node_(13) setdest 230142 49309 18.0" 
$ns at 0.0 "$node_(14) setdest 6610 16012 17.0" 
$ns at 120.62476670827425 "$node_(14) setdest 55073 2491 12.0" 
$ns at 212.63306638202687 "$node_(14) setdest 38770 18734 8.0" 
$ns at 315.35084384884726 "$node_(14) setdest 50940 8574 13.0" 
$ns at 420.05603258946815 "$node_(14) setdest 67994 27129 1.0" 
$ns at 452.3048431371377 "$node_(14) setdest 38186 55969 16.0" 
$ns at 583.475325591628 "$node_(14) setdest 198255 11869 3.0" 
$ns at 626.0374476472176 "$node_(14) setdest 6285 24887 7.0" 
$ns at 690.8769135885816 "$node_(14) setdest 17741 7356 4.0" 
$ns at 758.1582063107443 "$node_(14) setdest 177792 4222 11.0" 
$ns at 793.5176488333543 "$node_(14) setdest 152700 43916 6.0" 
$ns at 832.1188746169422 "$node_(14) setdest 61751 71590 2.0" 
$ns at 862.1451513342402 "$node_(14) setdest 80667 64645 17.0" 
$ns at 0.0 "$node_(15) setdest 45446 25428 18.0" 
$ns at 99.29696544610735 "$node_(15) setdest 75577 1048 10.0" 
$ns at 129.7213343009707 "$node_(15) setdest 3537 14082 20.0" 
$ns at 189.99947626053563 "$node_(15) setdest 14898 1509 4.0" 
$ns at 241.50627856366776 "$node_(15) setdest 2009 36643 9.0" 
$ns at 324.77406409321776 "$node_(15) setdest 78776 18792 17.0" 
$ns at 457.3351092844648 "$node_(15) setdest 110503 11350 19.0" 
$ns at 580.3566484769591 "$node_(15) setdest 209358 11104 17.0" 
$ns at 739.1063939177211 "$node_(15) setdest 231915 43645 13.0" 
$ns at 792.7985591225175 "$node_(15) setdest 26784 56945 9.0" 
$ns at 831.688066280658 "$node_(15) setdest 252620 28356 15.0" 
$ns at 0.0 "$node_(16) setdest 54418 20226 15.0" 
$ns at 31.73247071780719 "$node_(16) setdest 84104 18672 2.0" 
$ns at 71.35324643652686 "$node_(16) setdest 65005 25419 18.0" 
$ns at 231.9757481219956 "$node_(16) setdest 88096 5498 7.0" 
$ns at 269.74609706950014 "$node_(16) setdest 925 11030 12.0" 
$ns at 329.456629452484 "$node_(16) setdest 48448 40680 13.0" 
$ns at 410.755749763003 "$node_(16) setdest 69189 16617 10.0" 
$ns at 486.8322816718917 "$node_(16) setdest 43822 31884 7.0" 
$ns at 520.5175928740911 "$node_(16) setdest 67112 21639 3.0" 
$ns at 563.9405043011843 "$node_(16) setdest 84396 17536 18.0" 
$ns at 629.8976922734978 "$node_(16) setdest 226912 11281 5.0" 
$ns at 676.4959477954526 "$node_(16) setdest 18770 52103 18.0" 
$ns at 832.8905923245815 "$node_(16) setdest 117691 46385 15.0" 
$ns at 892.4300343849047 "$node_(16) setdest 44086 46601 20.0" 
$ns at 0.0 "$node_(17) setdest 21498 10018 13.0" 
$ns at 143.41546670856644 "$node_(17) setdest 59264 20589 10.0" 
$ns at 251.93917261117628 "$node_(17) setdest 80467 47297 6.0" 
$ns at 320.91516369045706 "$node_(17) setdest 15026 40825 2.0" 
$ns at 357.21037888849554 "$node_(17) setdest 170343 45699 5.0" 
$ns at 398.16269191087923 "$node_(17) setdest 135142 27694 11.0" 
$ns at 440.47602153248266 "$node_(17) setdest 84179 49207 6.0" 
$ns at 493.57151539201794 "$node_(17) setdest 52228 19236 11.0" 
$ns at 568.0739261747665 "$node_(17) setdest 141616 44413 18.0" 
$ns at 662.071526671977 "$node_(17) setdest 118991 36000 9.0" 
$ns at 748.0379761585012 "$node_(17) setdest 151577 12359 17.0" 
$ns at 890.4412941862847 "$node_(17) setdest 67662 4403 18.0" 
$ns at 0.0 "$node_(18) setdest 59604 27128 20.0" 
$ns at 30.011719134408715 "$node_(18) setdest 75085 7373 15.0" 
$ns at 164.7523632198436 "$node_(18) setdest 50563 41331 4.0" 
$ns at 217.26761451943617 "$node_(18) setdest 133397 5787 3.0" 
$ns at 269.1622417218359 "$node_(18) setdest 37800 37733 8.0" 
$ns at 350.14626621676234 "$node_(18) setdest 176509 42937 14.0" 
$ns at 415.4477922207859 "$node_(18) setdest 160602 52153 9.0" 
$ns at 494.2751745004267 "$node_(18) setdest 166333 63994 1.0" 
$ns at 532.0147864122792 "$node_(18) setdest 23647 69424 18.0" 
$ns at 597.150649245201 "$node_(18) setdest 199020 66164 16.0" 
$ns at 639.2335609032418 "$node_(18) setdest 150818 47510 20.0" 
$ns at 840.6708791800659 "$node_(18) setdest 120944 49313 16.0" 
$ns at 0.0 "$node_(19) setdest 33538 30496 17.0" 
$ns at 177.23902606000172 "$node_(19) setdest 97586 26107 19.0" 
$ns at 390.47696675950533 "$node_(19) setdest 123229 29454 17.0" 
$ns at 488.3731408261075 "$node_(19) setdest 181920 12464 14.0" 
$ns at 599.4049407494623 "$node_(19) setdest 101119 1490 9.0" 
$ns at 680.9342722475936 "$node_(19) setdest 14814 72900 9.0" 
$ns at 720.9591987111789 "$node_(19) setdest 230393 76435 18.0" 
$ns at 827.0324184934377 "$node_(19) setdest 92546 15845 17.0" 
$ns at 884.8366187835828 "$node_(19) setdest 214093 32019 13.0" 
$ns at 0.0 "$node_(20) setdest 6541 25212 10.0" 
$ns at 56.75401072198743 "$node_(20) setdest 48108 27614 16.0" 
$ns at 192.57687500854485 "$node_(20) setdest 80243 13623 9.0" 
$ns at 251.40594216338764 "$node_(20) setdest 75791 1502 17.0" 
$ns at 407.0169667300872 "$node_(20) setdest 131851 23633 16.0" 
$ns at 464.8623810640743 "$node_(20) setdest 112603 18036 1.0" 
$ns at 498.3195558289981 "$node_(20) setdest 93733 66016 18.0" 
$ns at 628.8883185069899 "$node_(20) setdest 43908 57932 17.0" 
$ns at 813.5160640692608 "$node_(20) setdest 211819 76579 10.0" 
$ns at 0.0 "$node_(21) setdest 4064 20726 15.0" 
$ns at 121.54152564938236 "$node_(21) setdest 5691 1301 13.0" 
$ns at 249.02403035470365 "$node_(21) setdest 94689 3739 16.0" 
$ns at 435.90827647733386 "$node_(21) setdest 187821 818 7.0" 
$ns at 509.94705955164835 "$node_(21) setdest 45997 44569 3.0" 
$ns at 563.8871197004277 "$node_(21) setdest 32788 30320 12.0" 
$ns at 674.2041222699883 "$node_(21) setdest 116798 37225 9.0" 
$ns at 710.4631403671921 "$node_(21) setdest 192000 71167 19.0" 
$ns at 791.3514755260679 "$node_(21) setdest 87730 4605 4.0" 
$ns at 827.6807425221758 "$node_(21) setdest 120756 38264 18.0" 
$ns at 0.0 "$node_(22) setdest 44457 13370 5.0" 
$ns at 47.705649229427905 "$node_(22) setdest 12896 9404 9.0" 
$ns at 130.52843020897672 "$node_(22) setdest 2775 1397 20.0" 
$ns at 248.40722067557016 "$node_(22) setdest 43617 16624 19.0" 
$ns at 318.53538240042775 "$node_(22) setdest 104051 52317 19.0" 
$ns at 357.8159181238138 "$node_(22) setdest 109057 21694 8.0" 
$ns at 402.5981570359837 "$node_(22) setdest 84216 450 18.0" 
$ns at 590.3176796981604 "$node_(22) setdest 139681 2241 16.0" 
$ns at 630.887021250077 "$node_(22) setdest 49617 63937 16.0" 
$ns at 665.2809708766964 "$node_(22) setdest 144892 11367 16.0" 
$ns at 839.1739200222889 "$node_(22) setdest 144348 19172 14.0" 
$ns at 879.182001074236 "$node_(22) setdest 122902 71772 13.0" 
$ns at 0.0 "$node_(23) setdest 73177 31395 6.0" 
$ns at 65.35829477710845 "$node_(23) setdest 39109 16984 10.0" 
$ns at 107.9882275298168 "$node_(23) setdest 29362 15793 12.0" 
$ns at 170.66356513596503 "$node_(23) setdest 93346 18456 5.0" 
$ns at 208.0041430581645 "$node_(23) setdest 26547 11405 19.0" 
$ns at 403.3750050106709 "$node_(23) setdest 103708 39950 10.0" 
$ns at 474.0750637681792 "$node_(23) setdest 57659 36856 20.0" 
$ns at 612.2498747233358 "$node_(23) setdest 217114 63885 14.0" 
$ns at 739.2855717459753 "$node_(23) setdest 71732 62138 19.0" 
$ns at 845.0762517582369 "$node_(23) setdest 65989 62315 3.0" 
$ns at 898.6466282425798 "$node_(23) setdest 198232 10035 1.0" 
$ns at 0.0 "$node_(24) setdest 22767 27906 10.0" 
$ns at 72.29287662605115 "$node_(24) setdest 33457 23590 2.0" 
$ns at 108.20185472311874 "$node_(24) setdest 80749 4001 18.0" 
$ns at 216.74815456840474 "$node_(24) setdest 55145 9316 9.0" 
$ns at 327.07086476810304 "$node_(24) setdest 111293 8194 9.0" 
$ns at 378.16094924927927 "$node_(24) setdest 78717 23600 1.0" 
$ns at 414.3365855203108 "$node_(24) setdest 43793 51542 13.0" 
$ns at 452.0433151258165 "$node_(24) setdest 161815 60899 15.0" 
$ns at 517.4886627273344 "$node_(24) setdest 60815 32407 15.0" 
$ns at 651.6791911189003 "$node_(24) setdest 103496 45279 5.0" 
$ns at 699.1251210762919 "$node_(24) setdest 228156 41376 4.0" 
$ns at 750.9947984349059 "$node_(24) setdest 195762 74455 13.0" 
$ns at 881.4649963758918 "$node_(24) setdest 265086 59401 14.0" 
$ns at 0.0 "$node_(25) setdest 93360 25253 6.0" 
$ns at 61.981476716744865 "$node_(25) setdest 35044 16853 4.0" 
$ns at 108.726577921525 "$node_(25) setdest 18637 8518 19.0" 
$ns at 235.7567554672437 "$node_(25) setdest 122010 4851 1.0" 
$ns at 272.0118830309094 "$node_(25) setdest 48418 26277 6.0" 
$ns at 305.09924267053475 "$node_(25) setdest 5730 37579 18.0" 
$ns at 430.0254275357761 "$node_(25) setdest 149417 60953 18.0" 
$ns at 475.05835809216444 "$node_(25) setdest 136452 20364 6.0" 
$ns at 524.142947985531 "$node_(25) setdest 87190 48941 10.0" 
$ns at 608.8040006925055 "$node_(25) setdest 98262 23920 13.0" 
$ns at 708.0232909486523 "$node_(25) setdest 114360 57873 15.0" 
$ns at 765.4276014562736 "$node_(25) setdest 248461 20642 5.0" 
$ns at 829.2969586412909 "$node_(25) setdest 196048 56765 12.0" 
$ns at 0.0 "$node_(26) setdest 92647 16503 18.0" 
$ns at 146.0101165601109 "$node_(26) setdest 35424 4305 13.0" 
$ns at 290.96734851685824 "$node_(26) setdest 40288 4381 10.0" 
$ns at 328.98740068501513 "$node_(26) setdest 157751 41003 15.0" 
$ns at 417.34885676456634 "$node_(26) setdest 13683 52920 11.0" 
$ns at 462.6173033457143 "$node_(26) setdest 132510 62997 4.0" 
$ns at 507.44333996955504 "$node_(26) setdest 184981 27157 10.0" 
$ns at 566.9014799686423 "$node_(26) setdest 33543 15531 7.0" 
$ns at 607.6519627517646 "$node_(26) setdest 162906 57069 5.0" 
$ns at 644.5757168537808 "$node_(26) setdest 45721 3663 19.0" 
$ns at 778.4235713247069 "$node_(26) setdest 219791 53162 4.0" 
$ns at 821.8348068836794 "$node_(26) setdest 66387 17611 18.0" 
$ns at 0.0 "$node_(27) setdest 31217 22636 3.0" 
$ns at 35.01214845943103 "$node_(27) setdest 73404 27267 12.0" 
$ns at 70.99812683326083 "$node_(27) setdest 21322 8526 7.0" 
$ns at 124.70325233081685 "$node_(27) setdest 74272 19961 1.0" 
$ns at 155.0444585708555 "$node_(27) setdest 57737 12241 17.0" 
$ns at 350.07614687706916 "$node_(27) setdest 157535 564 6.0" 
$ns at 389.4777582434656 "$node_(27) setdest 125694 30825 18.0" 
$ns at 591.7472587070052 "$node_(27) setdest 231458 43595 19.0" 
$ns at 655.1338803012496 "$node_(27) setdest 49599 30867 8.0" 
$ns at 693.9413646841219 "$node_(27) setdest 132093 76048 12.0" 
$ns at 733.6682840602107 "$node_(27) setdest 220013 80544 3.0" 
$ns at 786.8550031897221 "$node_(27) setdest 25822 2477 5.0" 
$ns at 864.7193092707043 "$node_(27) setdest 249012 74052 18.0" 
$ns at 0.0 "$node_(28) setdest 85606 20460 11.0" 
$ns at 48.616578735578734 "$node_(28) setdest 42065 11814 6.0" 
$ns at 92.53964752239165 "$node_(28) setdest 3832 21559 18.0" 
$ns at 243.30486378477346 "$node_(28) setdest 78468 9477 19.0" 
$ns at 396.08467311059474 "$node_(28) setdest 166251 61175 3.0" 
$ns at 440.739501089491 "$node_(28) setdest 162895 24910 12.0" 
$ns at 542.3756771416108 "$node_(28) setdest 77867 54837 5.0" 
$ns at 606.289683083412 "$node_(28) setdest 8144 49612 15.0" 
$ns at 686.457624353226 "$node_(28) setdest 135403 71275 6.0" 
$ns at 735.0788704601838 "$node_(28) setdest 137907 78019 16.0" 
$ns at 832.1478492630902 "$node_(28) setdest 156003 85988 20.0" 
$ns at 0.0 "$node_(29) setdest 43854 2285 18.0" 
$ns at 122.0401909484809 "$node_(29) setdest 24244 5746 2.0" 
$ns at 171.80994044649273 "$node_(29) setdest 42158 3603 6.0" 
$ns at 203.6958132108463 "$node_(29) setdest 79256 19346 14.0" 
$ns at 264.73034389391665 "$node_(29) setdest 74942 29716 2.0" 
$ns at 307.0939250119028 "$node_(29) setdest 9593 53601 7.0" 
$ns at 388.2679757807671 "$node_(29) setdest 130169 16749 12.0" 
$ns at 485.3825714488088 "$node_(29) setdest 146640 63243 18.0" 
$ns at 580.9381682889822 "$node_(29) setdest 64297 66475 9.0" 
$ns at 666.8307488808787 "$node_(29) setdest 213747 61103 12.0" 
$ns at 788.9459520141183 "$node_(29) setdest 194067 9702 7.0" 
$ns at 885.6076214398147 "$node_(29) setdest 162370 77551 14.0" 
$ns at 0.0 "$node_(30) setdest 75470 7880 8.0" 
$ns at 109.12525467095907 "$node_(30) setdest 86214 9391 8.0" 
$ns at 171.9720516249581 "$node_(30) setdest 97316 22316 16.0" 
$ns at 287.52870125085735 "$node_(30) setdest 11254 44974 7.0" 
$ns at 329.2189895555758 "$node_(30) setdest 100497 26159 15.0" 
$ns at 425.60427931663276 "$node_(30) setdest 33089 56905 5.0" 
$ns at 481.16011086373476 "$node_(30) setdest 79518 25663 18.0" 
$ns at 614.7822899276292 "$node_(30) setdest 109324 49933 17.0" 
$ns at 647.4541607465749 "$node_(30) setdest 196055 69972 4.0" 
$ns at 716.2700975982973 "$node_(30) setdest 217234 57874 6.0" 
$ns at 794.8516669794108 "$node_(30) setdest 215923 57931 14.0" 
$ns at 877.9033780540667 "$node_(30) setdest 11427 84279 18.0" 
$ns at 0.0 "$node_(31) setdest 9315 221 9.0" 
$ns at 85.53149607905341 "$node_(31) setdest 82929 12981 1.0" 
$ns at 122.34247165968034 "$node_(31) setdest 8694 331 9.0" 
$ns at 187.64323774136864 "$node_(31) setdest 13323 29813 16.0" 
$ns at 334.399636989344 "$node_(31) setdest 18553 47638 7.0" 
$ns at 402.1320276456481 "$node_(31) setdest 89344 38768 20.0" 
$ns at 586.9289516253735 "$node_(31) setdest 156930 55317 17.0" 
$ns at 759.0510588074727 "$node_(31) setdest 222465 52022 5.0" 
$ns at 804.0156792305224 "$node_(31) setdest 154689 9871 16.0" 
$ns at 0.0 "$node_(32) setdest 76707 31376 19.0" 
$ns at 38.543475138159764 "$node_(32) setdest 19272 7279 1.0" 
$ns at 72.06191349163748 "$node_(32) setdest 12937 1820 18.0" 
$ns at 214.47333518095252 "$node_(32) setdest 83680 34837 19.0" 
$ns at 362.7429005826576 "$node_(32) setdest 138002 17463 6.0" 
$ns at 433.97667629267653 "$node_(32) setdest 57103 3078 8.0" 
$ns at 477.59702987416654 "$node_(32) setdest 7285 49407 4.0" 
$ns at 524.4757714877804 "$node_(32) setdest 107450 50081 15.0" 
$ns at 695.5117017829295 "$node_(32) setdest 90413 17452 6.0" 
$ns at 752.7332992329877 "$node_(32) setdest 206472 17462 18.0" 
$ns at 836.4009034320534 "$node_(32) setdest 23723 27069 4.0" 
$ns at 883.7517592446674 "$node_(32) setdest 252468 73455 14.0" 
$ns at 0.0 "$node_(33) setdest 3748 3547 14.0" 
$ns at 152.45566763016876 "$node_(33) setdest 94788 42714 18.0" 
$ns at 223.0941604550316 "$node_(33) setdest 55074 29138 11.0" 
$ns at 256.3901422248207 "$node_(33) setdest 103424 49108 15.0" 
$ns at 337.19558741940136 "$node_(33) setdest 652 29194 1.0" 
$ns at 375.89708079634477 "$node_(33) setdest 10429 19242 20.0" 
$ns at 536.5214322035877 "$node_(33) setdest 149368 44956 13.0" 
$ns at 625.7390946980844 "$node_(33) setdest 106826 22499 11.0" 
$ns at 713.9703124111893 "$node_(33) setdest 102103 39149 2.0" 
$ns at 749.0984747778782 "$node_(33) setdest 19236 45788 6.0" 
$ns at 823.259812223251 "$node_(33) setdest 230837 18716 16.0" 
$ns at 888.7569040248341 "$node_(33) setdest 235744 10352 19.0" 
$ns at 0.0 "$node_(34) setdest 11795 21292 10.0" 
$ns at 94.7419502144836 "$node_(34) setdest 23886 20958 8.0" 
$ns at 152.87066952667442 "$node_(34) setdest 81038 30278 11.0" 
$ns at 198.58603361710692 "$node_(34) setdest 126377 16910 11.0" 
$ns at 331.4006994231954 "$node_(34) setdest 142245 30464 6.0" 
$ns at 376.4362882337586 "$node_(34) setdest 19814 54095 15.0" 
$ns at 538.9478817928593 "$node_(34) setdest 146781 57618 4.0" 
$ns at 589.5677916149073 "$node_(34) setdest 125655 44100 16.0" 
$ns at 662.1206239860281 "$node_(34) setdest 20802 12321 3.0" 
$ns at 693.8344239532979 "$node_(34) setdest 113845 68165 8.0" 
$ns at 725.9098445910755 "$node_(34) setdest 40235 26818 6.0" 
$ns at 812.6009870753655 "$node_(34) setdest 81076 19433 1.0" 
$ns at 850.2269982292794 "$node_(34) setdest 48870 58671 10.0" 
$ns at 0.0 "$node_(35) setdest 55973 5764 10.0" 
$ns at 40.88349364246226 "$node_(35) setdest 11773 3094 6.0" 
$ns at 89.713010409732 "$node_(35) setdest 63296 28248 17.0" 
$ns at 142.33116305509378 "$node_(35) setdest 50809 3403 16.0" 
$ns at 183.1713392208494 "$node_(35) setdest 117943 32373 2.0" 
$ns at 221.9811192706568 "$node_(35) setdest 84087 38993 6.0" 
$ns at 275.8172223008394 "$node_(35) setdest 105760 9664 17.0" 
$ns at 458.8007408994106 "$node_(35) setdest 168431 39780 2.0" 
$ns at 496.99389670222456 "$node_(35) setdest 61344 50240 5.0" 
$ns at 535.5573460602225 "$node_(35) setdest 8627 45045 2.0" 
$ns at 577.9711189029917 "$node_(35) setdest 170774 5790 9.0" 
$ns at 649.4075534967475 "$node_(35) setdest 49 32329 1.0" 
$ns at 683.1370623356167 "$node_(35) setdest 86810 441 4.0" 
$ns at 720.1859409065684 "$node_(35) setdest 130169 36498 2.0" 
$ns at 759.4554777888995 "$node_(35) setdest 146161 36100 1.0" 
$ns at 793.619572951113 "$node_(35) setdest 896 25755 10.0" 
$ns at 876.7629332878956 "$node_(35) setdest 3232 32023 7.0" 
$ns at 0.0 "$node_(36) setdest 94462 30773 9.0" 
$ns at 30.60008061916123 "$node_(36) setdest 52892 19639 6.0" 
$ns at 101.0346110358205 "$node_(36) setdest 63918 30830 17.0" 
$ns at 244.91458028757455 "$node_(36) setdest 133325 18182 3.0" 
$ns at 291.8734213719964 "$node_(36) setdest 39844 30428 2.0" 
$ns at 324.37802934323076 "$node_(36) setdest 97731 33966 16.0" 
$ns at 484.3107021966798 "$node_(36) setdest 88858 763 13.0" 
$ns at 610.004060802276 "$node_(36) setdest 225796 68561 10.0" 
$ns at 694.0890433333029 "$node_(36) setdest 117553 72909 11.0" 
$ns at 814.8272254174519 "$node_(36) setdest 119873 87523 16.0" 
$ns at 880.3251351929589 "$node_(36) setdest 134096 25875 11.0" 
$ns at 0.0 "$node_(37) setdest 24536 17067 7.0" 
$ns at 91.29265101956304 "$node_(37) setdest 92609 3055 19.0" 
$ns at 163.75624190430764 "$node_(37) setdest 24210 7367 8.0" 
$ns at 234.88223716028892 "$node_(37) setdest 86983 12376 10.0" 
$ns at 288.1116438889078 "$node_(37) setdest 62882 13728 18.0" 
$ns at 496.7514484046849 "$node_(37) setdest 77970 59017 17.0" 
$ns at 641.81855173543 "$node_(37) setdest 144814 15624 16.0" 
$ns at 783.3474202554523 "$node_(37) setdest 130324 27309 15.0" 
$ns at 883.0938339467295 "$node_(37) setdest 25777 77108 12.0" 
$ns at 0.0 "$node_(38) setdest 75767 12291 15.0" 
$ns at 112.38873554745211 "$node_(38) setdest 49497 9087 16.0" 
$ns at 242.20218051292574 "$node_(38) setdest 32310 20062 12.0" 
$ns at 319.80440994921037 "$node_(38) setdest 50926 11969 3.0" 
$ns at 362.9768339983157 "$node_(38) setdest 149357 54733 2.0" 
$ns at 395.5424124596044 "$node_(38) setdest 166533 55151 12.0" 
$ns at 450.60323344963876 "$node_(38) setdest 57363 33860 1.0" 
$ns at 484.40147564318283 "$node_(38) setdest 96486 64227 4.0" 
$ns at 549.1110598231038 "$node_(38) setdest 14814 43206 1.0" 
$ns at 580.954797724317 "$node_(38) setdest 222654 53692 19.0" 
$ns at 784.6411177734792 "$node_(38) setdest 235924 36365 7.0" 
$ns at 844.5537421447189 "$node_(38) setdest 205827 19164 16.0" 
$ns at 0.0 "$node_(39) setdest 1018 15152 12.0" 
$ns at 110.98058420757191 "$node_(39) setdest 45771 8439 4.0" 
$ns at 141.18846249329903 "$node_(39) setdest 89315 3223 9.0" 
$ns at 209.5658528483004 "$node_(39) setdest 90 34495 15.0" 
$ns at 378.3514877977851 "$node_(39) setdest 11480 27248 11.0" 
$ns at 418.51082314064104 "$node_(39) setdest 91978 21283 18.0" 
$ns at 462.22421729783855 "$node_(39) setdest 174507 35238 3.0" 
$ns at 499.63254479553956 "$node_(39) setdest 13848 30495 1.0" 
$ns at 531.7781640382246 "$node_(39) setdest 162549 68352 1.0" 
$ns at 571.3589647652988 "$node_(39) setdest 81818 60302 14.0" 
$ns at 649.6319167122194 "$node_(39) setdest 23818 68008 6.0" 
$ns at 694.2839773986223 "$node_(39) setdest 22541 69791 9.0" 
$ns at 793.9874057233852 "$node_(39) setdest 223316 79668 11.0" 
$ns at 0.0 "$node_(40) setdest 51084 14700 19.0" 
$ns at 71.16492772738587 "$node_(40) setdest 56788 23381 16.0" 
$ns at 206.17206546420917 "$node_(40) setdest 55249 8379 14.0" 
$ns at 252.30721360565394 "$node_(40) setdest 120170 49668 17.0" 
$ns at 321.61016465775464 "$node_(40) setdest 74722 31936 4.0" 
$ns at 376.37501527340606 "$node_(40) setdest 36174 47246 9.0" 
$ns at 442.0197018786673 "$node_(40) setdest 188347 47503 19.0" 
$ns at 639.3482546313844 "$node_(40) setdest 85346 42334 3.0" 
$ns at 677.8767942650485 "$node_(40) setdest 8549 76366 13.0" 
$ns at 786.4998437905423 "$node_(40) setdest 253750 23528 13.0" 
$ns at 0.0 "$node_(41) setdest 71971 16800 3.0" 
$ns at 30.71446762344635 "$node_(41) setdest 27301 29390 1.0" 
$ns at 61.46288190059475 "$node_(41) setdest 44903 17692 14.0" 
$ns at 192.8834633265264 "$node_(41) setdest 5894 42971 16.0" 
$ns at 286.33627406213543 "$node_(41) setdest 60389 37205 13.0" 
$ns at 316.62132248492594 "$node_(41) setdest 155823 46831 6.0" 
$ns at 389.88173816327594 "$node_(41) setdest 123387 40835 18.0" 
$ns at 540.3836847745999 "$node_(41) setdest 1203 1480 3.0" 
$ns at 585.5978426711738 "$node_(41) setdest 209417 7662 3.0" 
$ns at 630.3744286870349 "$node_(41) setdest 122391 56353 14.0" 
$ns at 711.1913258283342 "$node_(41) setdest 179856 38345 5.0" 
$ns at 775.3885653341126 "$node_(41) setdest 192819 36524 13.0" 
$ns at 0.0 "$node_(42) setdest 93349 24038 6.0" 
$ns at 37.50870275910226 "$node_(42) setdest 74803 25663 5.0" 
$ns at 100.89850723990384 "$node_(42) setdest 34738 17520 10.0" 
$ns at 155.51907796366373 "$node_(42) setdest 102787 32774 10.0" 
$ns at 267.52471384417254 "$node_(42) setdest 135856 12055 1.0" 
$ns at 304.9000796759179 "$node_(42) setdest 82690 17562 4.0" 
$ns at 354.0469332682038 "$node_(42) setdest 53161 20294 13.0" 
$ns at 451.6264531704177 "$node_(42) setdest 118056 13464 17.0" 
$ns at 597.3515442499904 "$node_(42) setdest 161933 65910 17.0" 
$ns at 737.5046451138433 "$node_(42) setdest 228729 70084 8.0" 
$ns at 776.2114203142016 "$node_(42) setdest 66254 44477 5.0" 
$ns at 809.9299808901756 "$node_(42) setdest 201955 7799 19.0" 
$ns at 0.0 "$node_(43) setdest 29740 8687 1.0" 
$ns at 34.48187135082375 "$node_(43) setdest 70353 17931 12.0" 
$ns at 158.07272973299902 "$node_(43) setdest 61446 6622 1.0" 
$ns at 191.82635566966314 "$node_(43) setdest 67434 19918 15.0" 
$ns at 297.9019477344716 "$node_(43) setdest 110015 27702 5.0" 
$ns at 368.6991212518225 "$node_(43) setdest 53175 58127 1.0" 
$ns at 405.74811194255506 "$node_(43) setdest 91112 37791 12.0" 
$ns at 501.04201429829953 "$node_(43) setdest 206036 13512 12.0" 
$ns at 633.5395433204046 "$node_(43) setdest 180918 23185 8.0" 
$ns at 731.2869028111215 "$node_(43) setdest 248430 77519 2.0" 
$ns at 767.5967253027892 "$node_(43) setdest 108154 73284 16.0" 
$ns at 0.0 "$node_(44) setdest 63770 13415 15.0" 
$ns at 41.18054519802208 "$node_(44) setdest 80431 6569 5.0" 
$ns at 91.4733967347129 "$node_(44) setdest 16991 31401 17.0" 
$ns at 144.2839369711229 "$node_(44) setdest 62828 24785 17.0" 
$ns at 292.1808053899992 "$node_(44) setdest 16578 14818 13.0" 
$ns at 335.75922007935475 "$node_(44) setdest 61976 46203 11.0" 
$ns at 475.5750704409417 "$node_(44) setdest 47636 33468 2.0" 
$ns at 521.3891373590817 "$node_(44) setdest 8237 18502 2.0" 
$ns at 567.5071045663589 "$node_(44) setdest 39119 63174 20.0" 
$ns at 763.6975827259715 "$node_(44) setdest 183398 76002 6.0" 
$ns at 833.3265259397938 "$node_(44) setdest 225776 52425 2.0" 
$ns at 876.9885510868787 "$node_(44) setdest 89633 52386 10.0" 
$ns at 0.0 "$node_(45) setdest 88762 19628 4.0" 
$ns at 50.515420488116476 "$node_(45) setdest 33307 2422 1.0" 
$ns at 84.21063355962166 "$node_(45) setdest 85984 5011 18.0" 
$ns at 255.2019601399562 "$node_(45) setdest 36188 47566 1.0" 
$ns at 293.9147542261295 "$node_(45) setdest 24530 17586 19.0" 
$ns at 437.1920732108907 "$node_(45) setdest 20466 29488 20.0" 
$ns at 561.8310019878821 "$node_(45) setdest 76831 54392 8.0" 
$ns at 598.8024765821214 "$node_(45) setdest 178296 13762 16.0" 
$ns at 653.6818782064213 "$node_(45) setdest 19388 67430 5.0" 
$ns at 704.8723990189757 "$node_(45) setdest 157421 12012 7.0" 
$ns at 779.5981006374332 "$node_(45) setdest 129892 28868 10.0" 
$ns at 830.5157043916286 "$node_(45) setdest 38868 15071 13.0" 
$ns at 0.0 "$node_(46) setdest 13835 15196 19.0" 
$ns at 94.60591331722722 "$node_(46) setdest 71678 6789 11.0" 
$ns at 215.08444027379053 "$node_(46) setdest 89873 42918 16.0" 
$ns at 344.5501652154918 "$node_(46) setdest 105 36845 14.0" 
$ns at 410.58591461392876 "$node_(46) setdest 166476 6975 5.0" 
$ns at 475.0595337260186 "$node_(46) setdest 141313 54591 4.0" 
$ns at 535.310989130972 "$node_(46) setdest 31831 32481 17.0" 
$ns at 571.8306135789428 "$node_(46) setdest 3266 57705 15.0" 
$ns at 649.0916690329254 "$node_(46) setdest 146101 57867 5.0" 
$ns at 689.617735306213 "$node_(46) setdest 109943 50773 12.0" 
$ns at 774.4296898494115 "$node_(46) setdest 59533 87617 17.0" 
$ns at 879.6892335749467 "$node_(46) setdest 33800 59595 1.0" 
$ns at 0.0 "$node_(47) setdest 59787 7505 2.0" 
$ns at 36.46665487827043 "$node_(47) setdest 53235 4060 15.0" 
$ns at 104.27294938981056 "$node_(47) setdest 80151 7161 13.0" 
$ns at 168.15607799197667 "$node_(47) setdest 126664 18080 3.0" 
$ns at 211.8379240798787 "$node_(47) setdest 110816 36329 20.0" 
$ns at 404.308897352706 "$node_(47) setdest 164546 62638 8.0" 
$ns at 500.5867125344404 "$node_(47) setdest 67629 1625 4.0" 
$ns at 537.700162715892 "$node_(47) setdest 174849 2160 10.0" 
$ns at 612.9110174537432 "$node_(47) setdest 3371 20185 9.0" 
$ns at 679.215761956854 "$node_(47) setdest 96972 77339 9.0" 
$ns at 780.9476919050048 "$node_(47) setdest 137462 63504 17.0" 
$ns at 828.2108858210217 "$node_(47) setdest 34151 53230 7.0" 
$ns at 0.0 "$node_(48) setdest 74977 5750 16.0" 
$ns at 147.6260879426838 "$node_(48) setdest 59697 8861 18.0" 
$ns at 227.86422857019525 "$node_(48) setdest 19083 39304 3.0" 
$ns at 280.87307469296985 "$node_(48) setdest 24953 52469 17.0" 
$ns at 377.6100955972141 "$node_(48) setdest 149183 52096 5.0" 
$ns at 418.8841138551971 "$node_(48) setdest 150966 48919 20.0" 
$ns at 451.2741476473466 "$node_(48) setdest 128152 66213 8.0" 
$ns at 520.3204781586405 "$node_(48) setdest 51562 5467 19.0" 
$ns at 691.1350574734637 "$node_(48) setdest 179864 83655 2.0" 
$ns at 727.7718745641703 "$node_(48) setdest 102407 78643 8.0" 
$ns at 795.655422292325 "$node_(48) setdest 228868 154 13.0" 
$ns at 897.5632112274277 "$node_(48) setdest 154734 22845 6.0" 
$ns at 0.0 "$node_(49) setdest 68397 18675 10.0" 
$ns at 100.66376486176732 "$node_(49) setdest 82660 25214 6.0" 
$ns at 162.2857461548477 "$node_(49) setdest 112038 28407 6.0" 
$ns at 238.15879640932144 "$node_(49) setdest 15998 37603 19.0" 
$ns at 337.93795722958765 "$node_(49) setdest 83647 6843 9.0" 
$ns at 435.1560103181403 "$node_(49) setdest 87031 13501 8.0" 
$ns at 471.9329615501179 "$node_(49) setdest 205942 63592 12.0" 
$ns at 576.7405507132714 "$node_(49) setdest 61377 68799 18.0" 
$ns at 681.2126406732998 "$node_(49) setdest 202313 79110 6.0" 
$ns at 713.5150808601484 "$node_(49) setdest 55854 40349 2.0" 
$ns at 749.3455750846736 "$node_(49) setdest 47118 21065 5.0" 
$ns at 812.2665078985142 "$node_(49) setdest 172539 24570 17.0" 
$ns at 0.0 "$node_(50) setdest 56809 14384 7.0" 
$ns at 43.62379179569399 "$node_(50) setdest 31462 19168 11.0" 
$ns at 153.7144503558917 "$node_(50) setdest 641 34451 5.0" 
$ns at 203.6930560128012 "$node_(50) setdest 82307 34606 12.0" 
$ns at 305.416596772843 "$node_(50) setdest 112251 51689 2.0" 
$ns at 347.2169974001876 "$node_(50) setdest 54895 43034 13.0" 
$ns at 394.54600963872974 "$node_(50) setdest 31740 13286 14.0" 
$ns at 493.9993055463623 "$node_(50) setdest 195622 41434 3.0" 
$ns at 547.9059523269542 "$node_(50) setdest 2386 35493 15.0" 
$ns at 651.0645235132595 "$node_(50) setdest 212293 51576 2.0" 
$ns at 683.9914870531942 "$node_(50) setdest 83482 32810 18.0" 
$ns at 800.2316370888345 "$node_(50) setdest 11766 73889 8.0" 
$ns at 876.8228686013307 "$node_(50) setdest 91399 45701 3.0" 
$ns at 0.0 "$node_(51) setdest 15654 15576 9.0" 
$ns at 81.15820201202497 "$node_(51) setdest 29085 13447 5.0" 
$ns at 144.59667831006084 "$node_(51) setdest 66046 14819 1.0" 
$ns at 182.08845969274768 "$node_(51) setdest 91671 9761 14.0" 
$ns at 326.23253212901 "$node_(51) setdest 51337 39295 5.0" 
$ns at 388.4245392814694 "$node_(51) setdest 62775 16340 16.0" 
$ns at 534.568884177921 "$node_(51) setdest 6441 17605 11.0" 
$ns at 656.9147944942963 "$node_(51) setdest 14032 74820 7.0" 
$ns at 749.1698435214586 "$node_(51) setdest 250298 68751 15.0" 
$ns at 0.0 "$node_(52) setdest 87362 2097 4.0" 
$ns at 43.929192928888774 "$node_(52) setdest 94620 714 10.0" 
$ns at 88.01661601020379 "$node_(52) setdest 2927 2239 7.0" 
$ns at 172.0157909944833 "$node_(52) setdest 1170 26297 3.0" 
$ns at 225.15308441930375 "$node_(52) setdest 101259 43229 9.0" 
$ns at 310.15088577304095 "$node_(52) setdest 64134 4410 5.0" 
$ns at 387.82551756201485 "$node_(52) setdest 111530 22889 8.0" 
$ns at 489.39880099435425 "$node_(52) setdest 113294 19984 11.0" 
$ns at 555.847923130418 "$node_(52) setdest 26210 44076 8.0" 
$ns at 622.0624255711666 "$node_(52) setdest 14422 71462 10.0" 
$ns at 714.7945431842332 "$node_(52) setdest 192343 30671 14.0" 
$ns at 833.4472327602998 "$node_(52) setdest 241880 53178 16.0" 
$ns at 0.0 "$node_(53) setdest 34911 27082 3.0" 
$ns at 54.11662772414072 "$node_(53) setdest 77721 31209 10.0" 
$ns at 170.97738963912886 "$node_(53) setdest 83048 6867 14.0" 
$ns at 227.82342540537672 "$node_(53) setdest 33423 34945 13.0" 
$ns at 377.2125935164298 "$node_(53) setdest 5153 56818 6.0" 
$ns at 458.9666542767582 "$node_(53) setdest 104283 59195 7.0" 
$ns at 546.0845647406098 "$node_(53) setdest 204861 58550 13.0" 
$ns at 691.7162578343214 "$node_(53) setdest 155746 43692 10.0" 
$ns at 742.4527572050101 "$node_(53) setdest 206520 75001 9.0" 
$ns at 773.5710443321095 "$node_(53) setdest 181710 27394 6.0" 
$ns at 826.7315819618777 "$node_(53) setdest 120299 60871 5.0" 
$ns at 873.6735641050351 "$node_(53) setdest 264208 87438 9.0" 
$ns at 0.0 "$node_(54) setdest 33766 1941 8.0" 
$ns at 100.91131374178556 "$node_(54) setdest 62955 3087 14.0" 
$ns at 185.29418270423452 "$node_(54) setdest 51829 18691 19.0" 
$ns at 218.84259156803566 "$node_(54) setdest 91598 24887 4.0" 
$ns at 269.24407411751804 "$node_(54) setdest 129741 45059 5.0" 
$ns at 302.9710469541032 "$node_(54) setdest 4053 18775 17.0" 
$ns at 487.80949249582886 "$node_(54) setdest 197966 69022 5.0" 
$ns at 554.9023330292939 "$node_(54) setdest 185977 68977 1.0" 
$ns at 588.7599224815508 "$node_(54) setdest 21621 67374 12.0" 
$ns at 735.9439827811431 "$node_(54) setdest 98665 51614 5.0" 
$ns at 789.5756329461359 "$node_(54) setdest 9076 37115 13.0" 
$ns at 886.8531952155015 "$node_(54) setdest 259026 46027 10.0" 
$ns at 0.0 "$node_(55) setdest 31969 16628 1.0" 
$ns at 32.98608180414537 "$node_(55) setdest 86225 28792 5.0" 
$ns at 85.44477438552474 "$node_(55) setdest 64708 12505 1.0" 
$ns at 118.52287102711351 "$node_(55) setdest 6817 23894 13.0" 
$ns at 247.6965009402412 "$node_(55) setdest 72355 42607 7.0" 
$ns at 326.35178382115447 "$node_(55) setdest 138607 3212 6.0" 
$ns at 372.23464807702 "$node_(55) setdest 185925 46706 18.0" 
$ns at 434.482607738976 "$node_(55) setdest 81523 20675 12.0" 
$ns at 479.71775975156754 "$node_(55) setdest 119161 48726 6.0" 
$ns at 512.9799198372893 "$node_(55) setdest 190898 8997 8.0" 
$ns at 611.4071103614733 "$node_(55) setdest 115415 43844 12.0" 
$ns at 683.1762167665038 "$node_(55) setdest 210743 10961 11.0" 
$ns at 726.2700174169403 "$node_(55) setdest 139877 1626 8.0" 
$ns at 830.6393369486674 "$node_(55) setdest 184623 22896 18.0" 
$ns at 0.0 "$node_(56) setdest 40746 16573 10.0" 
$ns at 92.15190544666132 "$node_(56) setdest 8991 24300 12.0" 
$ns at 199.7123740583024 "$node_(56) setdest 62850 30228 7.0" 
$ns at 272.674210340345 "$node_(56) setdest 144055 25126 3.0" 
$ns at 312.5363469261391 "$node_(56) setdest 10589 32193 17.0" 
$ns at 466.9305349060383 "$node_(56) setdest 86399 17962 13.0" 
$ns at 577.5774109755123 "$node_(56) setdest 17704 28808 7.0" 
$ns at 632.7141939486313 "$node_(56) setdest 120960 68214 18.0" 
$ns at 767.356899115363 "$node_(56) setdest 10258 84838 10.0" 
$ns at 803.9223626521191 "$node_(56) setdest 70062 39376 3.0" 
$ns at 850.4376792437945 "$node_(56) setdest 26737 59712 19.0" 
$ns at 0.0 "$node_(57) setdest 6007 393 9.0" 
$ns at 44.493285520742006 "$node_(57) setdest 85477 15279 11.0" 
$ns at 106.26856550111233 "$node_(57) setdest 18068 20472 18.0" 
$ns at 254.58180021693443 "$node_(57) setdest 139134 36570 4.0" 
$ns at 291.3664764661884 "$node_(57) setdest 84911 19813 12.0" 
$ns at 433.9871626875115 "$node_(57) setdest 91026 19298 2.0" 
$ns at 471.26783528310756 "$node_(57) setdest 208752 66 1.0" 
$ns at 501.3183206288262 "$node_(57) setdest 194204 3608 19.0" 
$ns at 633.3109837682903 "$node_(57) setdest 73216 6306 4.0" 
$ns at 692.6396966005836 "$node_(57) setdest 136154 75098 6.0" 
$ns at 750.4745013793595 "$node_(57) setdest 218755 87285 12.0" 
$ns at 798.9757540447906 "$node_(57) setdest 119695 83399 4.0" 
$ns at 829.7860413802943 "$node_(57) setdest 92716 4907 9.0" 
$ns at 0.0 "$node_(58) setdest 24966 10399 15.0" 
$ns at 71.83135089672646 "$node_(58) setdest 75676 20494 10.0" 
$ns at 185.12624845499272 "$node_(58) setdest 56856 2520 9.0" 
$ns at 217.16130843087598 "$node_(58) setdest 87821 41969 1.0" 
$ns at 254.78778633188193 "$node_(58) setdest 162303 2707 14.0" 
$ns at 315.44232787759006 "$node_(58) setdest 76744 8362 3.0" 
$ns at 349.3064979292279 "$node_(58) setdest 87518 45063 14.0" 
$ns at 415.5523953023167 "$node_(58) setdest 62584 41801 1.0" 
$ns at 449.28637230159995 "$node_(58) setdest 151867 48794 16.0" 
$ns at 480.9613742562942 "$node_(58) setdest 146012 60076 7.0" 
$ns at 559.9059824239647 "$node_(58) setdest 13895 49942 14.0" 
$ns at 728.2124903806789 "$node_(58) setdest 14543 73616 7.0" 
$ns at 814.2227432254514 "$node_(58) setdest 104944 83200 1.0" 
$ns at 846.0935060456678 "$node_(58) setdest 131212 62242 19.0" 
$ns at 0.0 "$node_(59) setdest 33294 4387 19.0" 
$ns at 103.72870225473359 "$node_(59) setdest 81394 28308 3.0" 
$ns at 155.9149027813669 "$node_(59) setdest 97082 10150 12.0" 
$ns at 302.9736574557461 "$node_(59) setdest 52268 17819 12.0" 
$ns at 398.4209187272064 "$node_(59) setdest 59986 40858 15.0" 
$ns at 515.0909029134623 "$node_(59) setdest 104132 36738 16.0" 
$ns at 701.4202415624025 "$node_(59) setdest 1109 63162 1.0" 
$ns at 732.1764957405456 "$node_(59) setdest 57915 28019 11.0" 
$ns at 779.4739735919911 "$node_(59) setdest 130599 52489 3.0" 
$ns at 832.8931980462874 "$node_(59) setdest 11967 36320 14.0" 
$ns at 0.0 "$node_(60) setdest 42925 6526 2.0" 
$ns at 46.70647957446547 "$node_(60) setdest 47317 8802 5.0" 
$ns at 90.41699550619816 "$node_(60) setdest 11644 4628 2.0" 
$ns at 123.10745469372698 "$node_(60) setdest 18487 10523 17.0" 
$ns at 153.50232619171982 "$node_(60) setdest 49585 29614 13.0" 
$ns at 225.0495129906588 "$node_(60) setdest 19720 38767 3.0" 
$ns at 262.5531031109489 "$node_(60) setdest 143201 43404 14.0" 
$ns at 382.9777282071896 "$node_(60) setdest 121811 59721 19.0" 
$ns at 575.0863339414273 "$node_(60) setdest 2719 35890 6.0" 
$ns at 651.5495470082113 "$node_(60) setdest 229719 73336 6.0" 
$ns at 722.593984903521 "$node_(60) setdest 119613 10540 15.0" 
$ns at 870.8265554266734 "$node_(60) setdest 59905 40277 13.0" 
$ns at 0.0 "$node_(61) setdest 72187 21010 14.0" 
$ns at 167.88686156374857 "$node_(61) setdest 19613 11770 3.0" 
$ns at 220.92644047797268 "$node_(61) setdest 5056 25159 2.0" 
$ns at 255.828075297044 "$node_(61) setdest 33049 42808 20.0" 
$ns at 444.2681278718341 "$node_(61) setdest 18654 35991 5.0" 
$ns at 475.69028102294897 "$node_(61) setdest 21025 69572 2.0" 
$ns at 518.7639000069141 "$node_(61) setdest 68221 24531 5.0" 
$ns at 563.6523478676027 "$node_(61) setdest 52838 54396 2.0" 
$ns at 594.7335832906215 "$node_(61) setdest 203918 65676 1.0" 
$ns at 633.9510556904344 "$node_(61) setdest 43952 2004 5.0" 
$ns at 680.9272503705529 "$node_(61) setdest 156468 33353 5.0" 
$ns at 728.7975390984489 "$node_(61) setdest 121176 31781 7.0" 
$ns at 812.2737510731398 "$node_(61) setdest 107089 65977 3.0" 
$ns at 862.161564282411 "$node_(61) setdest 175093 12709 19.0" 
$ns at 0.0 "$node_(62) setdest 64395 15515 7.0" 
$ns at 39.91392502541358 "$node_(62) setdest 46746 28840 6.0" 
$ns at 121.51521651217953 "$node_(62) setdest 74536 26033 12.0" 
$ns at 171.66102677071564 "$node_(62) setdest 18466 35513 10.0" 
$ns at 231.0904649735175 "$node_(62) setdest 17075 11586 2.0" 
$ns at 281.0059695190337 "$node_(62) setdest 19502 16982 7.0" 
$ns at 330.0994943444599 "$node_(62) setdest 25950 49360 18.0" 
$ns at 468.3270130395453 "$node_(62) setdest 153081 56701 14.0" 
$ns at 504.72961886367807 "$node_(62) setdest 5475 38587 7.0" 
$ns at 594.833343891301 "$node_(62) setdest 52316 34097 3.0" 
$ns at 649.356684321086 "$node_(62) setdest 25848 32954 4.0" 
$ns at 703.4356792974952 "$node_(62) setdest 214123 16780 13.0" 
$ns at 859.8365614232564 "$node_(62) setdest 245119 51165 11.0" 
$ns at 0.0 "$node_(63) setdest 49587 13314 18.0" 
$ns at 184.105628857087 "$node_(63) setdest 133252 1567 9.0" 
$ns at 295.39265659287565 "$node_(63) setdest 118349 44062 2.0" 
$ns at 341.15474727560826 "$node_(63) setdest 152320 24407 14.0" 
$ns at 460.5861138241348 "$node_(63) setdest 18397 69204 2.0" 
$ns at 495.1720930549345 "$node_(63) setdest 102239 46950 20.0" 
$ns at 694.5545854988193 "$node_(63) setdest 136833 81818 3.0" 
$ns at 733.0634140111872 "$node_(63) setdest 117110 41683 7.0" 
$ns at 771.1720352657683 "$node_(63) setdest 13915 23130 6.0" 
$ns at 858.579814385276 "$node_(63) setdest 258987 65557 17.0" 
$ns at 0.0 "$node_(64) setdest 28795 3578 17.0" 
$ns at 174.36628273601664 "$node_(64) setdest 122521 42767 9.0" 
$ns at 219.14414854750387 "$node_(64) setdest 131782 26587 8.0" 
$ns at 265.829648636441 "$node_(64) setdest 36146 50565 18.0" 
$ns at 371.9915199556934 "$node_(64) setdest 70280 19942 13.0" 
$ns at 469.31513101671 "$node_(64) setdest 190118 31348 12.0" 
$ns at 587.4374126743921 "$node_(64) setdest 97045 56888 18.0" 
$ns at 625.4916126939053 "$node_(64) setdest 207614 2505 12.0" 
$ns at 768.0781583346879 "$node_(64) setdest 158742 71063 4.0" 
$ns at 799.1866354632075 "$node_(64) setdest 164161 72810 6.0" 
$ns at 871.1707989185408 "$node_(64) setdest 25519 2119 10.0" 
$ns at 0.0 "$node_(65) setdest 26951 13040 6.0" 
$ns at 39.1134166999224 "$node_(65) setdest 26649 14697 11.0" 
$ns at 113.53808323587072 "$node_(65) setdest 65676 25962 5.0" 
$ns at 160.24796109699986 "$node_(65) setdest 46538 2011 19.0" 
$ns at 378.2303929501717 "$node_(65) setdest 175336 30953 13.0" 
$ns at 470.2709073154519 "$node_(65) setdest 136432 17683 19.0" 
$ns at 606.662278751254 "$node_(65) setdest 29357 8749 18.0" 
$ns at 714.7776883772192 "$node_(65) setdest 43550 18019 7.0" 
$ns at 752.0435046070803 "$node_(65) setdest 124022 77448 6.0" 
$ns at 830.5648312801654 "$node_(65) setdest 32977 53450 3.0" 
$ns at 873.1387947889048 "$node_(65) setdest 195779 5844 20.0" 
$ns at 0.0 "$node_(66) setdest 46786 26579 2.0" 
$ns at 43.630737905493234 "$node_(66) setdest 32960 15950 6.0" 
$ns at 91.52817049080832 "$node_(66) setdest 16991 22061 4.0" 
$ns at 123.7109088958486 "$node_(66) setdest 63242 29814 5.0" 
$ns at 157.20914243651336 "$node_(66) setdest 8936 5618 16.0" 
$ns at 230.31968978781225 "$node_(66) setdest 109169 22076 13.0" 
$ns at 263.7632513939018 "$node_(66) setdest 161915 49893 11.0" 
$ns at 332.21272291641924 "$node_(66) setdest 85931 48950 5.0" 
$ns at 408.80510871380886 "$node_(66) setdest 113427 40723 14.0" 
$ns at 565.5833520029709 "$node_(66) setdest 154545 69457 2.0" 
$ns at 596.9329867574227 "$node_(66) setdest 129254 69927 17.0" 
$ns at 742.0269604507182 "$node_(66) setdest 107570 23150 7.0" 
$ns at 818.6513058068532 "$node_(66) setdest 137014 68106 2.0" 
$ns at 853.5715069483267 "$node_(66) setdest 97084 16182 12.0" 
$ns at 0.0 "$node_(67) setdest 75781 31121 6.0" 
$ns at 35.928975936882935 "$node_(67) setdest 69422 25910 12.0" 
$ns at 74.21723111446721 "$node_(67) setdest 85473 16436 9.0" 
$ns at 145.7411164005843 "$node_(67) setdest 86083 23090 18.0" 
$ns at 267.0252015265762 "$node_(67) setdest 162801 8772 3.0" 
$ns at 314.551269453961 "$node_(67) setdest 118962 5957 3.0" 
$ns at 366.35368837897175 "$node_(67) setdest 31304 30026 17.0" 
$ns at 464.8002793119342 "$node_(67) setdest 7638 66389 10.0" 
$ns at 508.2416684244115 "$node_(67) setdest 38959 27237 20.0" 
$ns at 687.8691441833128 "$node_(67) setdest 229718 76485 6.0" 
$ns at 756.7547277153333 "$node_(67) setdest 215430 88838 14.0" 
$ns at 861.8748720691024 "$node_(67) setdest 53950 34727 5.0" 
$ns at 0.0 "$node_(68) setdest 3048 16609 8.0" 
$ns at 78.71772482279154 "$node_(68) setdest 34201 26619 19.0" 
$ns at 211.97250592363594 "$node_(68) setdest 120543 22637 2.0" 
$ns at 244.98955506349853 "$node_(68) setdest 115969 27036 16.0" 
$ns at 308.2496094100894 "$node_(68) setdest 90226 28877 5.0" 
$ns at 381.53465725353607 "$node_(68) setdest 101880 51946 3.0" 
$ns at 418.9522081223281 "$node_(68) setdest 147017 13855 10.0" 
$ns at 481.7975170407916 "$node_(68) setdest 124357 63583 1.0" 
$ns at 521.6795849999259 "$node_(68) setdest 60760 20891 1.0" 
$ns at 553.6270984556738 "$node_(68) setdest 63109 71650 14.0" 
$ns at 693.5761525266257 "$node_(68) setdest 81656 65195 12.0" 
$ns at 746.5868735986069 "$node_(68) setdest 104424 66193 8.0" 
$ns at 837.8390617769851 "$node_(68) setdest 118500 69309 12.0" 
$ns at 875.794202376577 "$node_(68) setdest 59049 1614 13.0" 
$ns at 0.0 "$node_(69) setdest 49387 12662 19.0" 
$ns at 204.0625603320992 "$node_(69) setdest 11271 22861 13.0" 
$ns at 267.9046600822069 "$node_(69) setdest 64110 40629 1.0" 
$ns at 303.7055184812527 "$node_(69) setdest 65095 40627 11.0" 
$ns at 371.13162488731166 "$node_(69) setdest 112208 59705 15.0" 
$ns at 403.079569005244 "$node_(69) setdest 93625 5580 4.0" 
$ns at 434.2008300086916 "$node_(69) setdest 27261 50655 10.0" 
$ns at 546.2866446104406 "$node_(69) setdest 53440 23205 2.0" 
$ns at 596.1815690535965 "$node_(69) setdest 89964 35464 4.0" 
$ns at 641.4829283632005 "$node_(69) setdest 3220 40098 12.0" 
$ns at 787.9950830449893 "$node_(69) setdest 62755 8072 6.0" 
$ns at 831.9878958459215 "$node_(69) setdest 217004 66826 5.0" 
$ns at 882.2524382647887 "$node_(69) setdest 110079 60049 18.0" 
$ns at 0.0 "$node_(70) setdest 7103 16185 13.0" 
$ns at 126.55402335981017 "$node_(70) setdest 49548 6084 8.0" 
$ns at 197.83973820821112 "$node_(70) setdest 45492 30634 9.0" 
$ns at 238.878669810441 "$node_(70) setdest 3509 42413 8.0" 
$ns at 283.80651556380013 "$node_(70) setdest 92170 18205 8.0" 
$ns at 357.6730431903403 "$node_(70) setdest 82675 47637 12.0" 
$ns at 452.06957092335534 "$node_(70) setdest 21031 60513 18.0" 
$ns at 631.0954134613357 "$node_(70) setdest 81179 15232 3.0" 
$ns at 679.4655956202894 "$node_(70) setdest 127187 17132 2.0" 
$ns at 726.2292391145952 "$node_(70) setdest 32045 25714 1.0" 
$ns at 763.8683105729272 "$node_(70) setdest 164257 12874 19.0" 
$ns at 0.0 "$node_(71) setdest 28928 7410 14.0" 
$ns at 139.93011606847185 "$node_(71) setdest 56302 25764 20.0" 
$ns at 249.32243127291468 "$node_(71) setdest 8748 36265 10.0" 
$ns at 351.492090188057 "$node_(71) setdest 474 5028 14.0" 
$ns at 479.01414831078256 "$node_(71) setdest 77672 8048 1.0" 
$ns at 511.7370289340014 "$node_(71) setdest 200664 27348 16.0" 
$ns at 594.0453992761895 "$node_(71) setdest 125936 29522 9.0" 
$ns at 710.5542879051629 "$node_(71) setdest 221053 12139 7.0" 
$ns at 797.0720352466417 "$node_(71) setdest 125470 80699 1.0" 
$ns at 832.1256801319095 "$node_(71) setdest 195939 75560 11.0" 
$ns at 0.0 "$node_(72) setdest 58501 23495 16.0" 
$ns at 38.5013853863647 "$node_(72) setdest 26471 13122 10.0" 
$ns at 86.66235566717123 "$node_(72) setdest 56376 13259 14.0" 
$ns at 147.51216153706406 "$node_(72) setdest 4969 17540 11.0" 
$ns at 227.98704573833126 "$node_(72) setdest 131167 39484 12.0" 
$ns at 269.89880232309054 "$node_(72) setdest 22692 1430 5.0" 
$ns at 311.2779798003863 "$node_(72) setdest 89760 23654 15.0" 
$ns at 441.2036386717562 "$node_(72) setdest 124802 9406 19.0" 
$ns at 628.2198664475856 "$node_(72) setdest 54149 31732 19.0" 
$ns at 708.3167969769124 "$node_(72) setdest 211843 82112 17.0" 
$ns at 844.7374942185429 "$node_(72) setdest 101837 72082 7.0" 
$ns at 880.5574027373349 "$node_(72) setdest 249867 83414 10.0" 
$ns at 0.0 "$node_(73) setdest 12002 3858 13.0" 
$ns at 137.03774867625623 "$node_(73) setdest 30021 24819 8.0" 
$ns at 189.12443870188758 "$node_(73) setdest 2962 5148 9.0" 
$ns at 304.7122412694619 "$node_(73) setdest 114680 20471 16.0" 
$ns at 350.9936651474028 "$node_(73) setdest 34039 17932 19.0" 
$ns at 426.3209917321146 "$node_(73) setdest 27997 25833 4.0" 
$ns at 491.7725617960447 "$node_(73) setdest 120114 14629 15.0" 
$ns at 597.7093775150872 "$node_(73) setdest 75583 13343 19.0" 
$ns at 724.3746823765146 "$node_(73) setdest 64742 8743 9.0" 
$ns at 821.1902040972712 "$node_(73) setdest 78202 8220 19.0" 
$ns at 0.0 "$node_(74) setdest 69865 7116 10.0" 
$ns at 32.940496975697535 "$node_(74) setdest 59307 13076 7.0" 
$ns at 87.02653767406315 "$node_(74) setdest 53763 29433 9.0" 
$ns at 202.5450237108758 "$node_(74) setdest 107953 21176 7.0" 
$ns at 297.1769472660661 "$node_(74) setdest 5446 32304 2.0" 
$ns at 335.2037235001345 "$node_(74) setdest 9441 16596 19.0" 
$ns at 553.9395106467981 "$node_(74) setdest 131930 49540 3.0" 
$ns at 613.5907653514159 "$node_(74) setdest 31889 42881 6.0" 
$ns at 652.7909580650253 "$node_(74) setdest 13077 36367 5.0" 
$ns at 704.2630876794711 "$node_(74) setdest 184216 82257 4.0" 
$ns at 764.7993487833746 "$node_(74) setdest 87293 66420 17.0" 
$ns at 0.0 "$node_(75) setdest 45047 31300 1.0" 
$ns at 36.430724114942166 "$node_(75) setdest 45514 14 4.0" 
$ns at 84.16010950764306 "$node_(75) setdest 68605 29476 12.0" 
$ns at 151.47861407971888 "$node_(75) setdest 104211 31121 2.0" 
$ns at 181.99978776007805 "$node_(75) setdest 84702 10035 8.0" 
$ns at 257.3427886672224 "$node_(75) setdest 43424 26623 2.0" 
$ns at 300.5327611079462 "$node_(75) setdest 25651 24353 12.0" 
$ns at 386.4310275100738 "$node_(75) setdest 81335 57988 20.0" 
$ns at 469.68021120729804 "$node_(75) setdest 210504 66737 2.0" 
$ns at 519.4308566145014 "$node_(75) setdest 98075 60587 16.0" 
$ns at 680.1441116653706 "$node_(75) setdest 158771 58143 18.0" 
$ns at 880.8419274237808 "$node_(75) setdest 262806 740 2.0" 
$ns at 0.0 "$node_(76) setdest 902 11694 9.0" 
$ns at 116.36294208015899 "$node_(76) setdest 24836 3454 1.0" 
$ns at 152.16774559829736 "$node_(76) setdest 57463 39433 15.0" 
$ns at 254.44063197987168 "$node_(76) setdest 60291 37757 19.0" 
$ns at 315.2439169336472 "$node_(76) setdest 122528 48371 12.0" 
$ns at 378.2975654177254 "$node_(76) setdest 129032 31190 5.0" 
$ns at 419.0383471288317 "$node_(76) setdest 582 60409 12.0" 
$ns at 544.952715361013 "$node_(76) setdest 157513 66034 17.0" 
$ns at 678.0688287343382 "$node_(76) setdest 243628 40067 13.0" 
$ns at 754.5204688570088 "$node_(76) setdest 117597 17083 8.0" 
$ns at 786.7494640125817 "$node_(76) setdest 82996 38063 11.0" 
$ns at 821.6576896969239 "$node_(76) setdest 233598 72918 4.0" 
$ns at 891.5311616883442 "$node_(76) setdest 82591 49561 3.0" 
$ns at 0.0 "$node_(77) setdest 48497 30159 6.0" 
$ns at 35.00806573395654 "$node_(77) setdest 38108 23871 16.0" 
$ns at 75.95996761766382 "$node_(77) setdest 43043 17670 9.0" 
$ns at 153.53666140906202 "$node_(77) setdest 124989 23576 6.0" 
$ns at 184.57674806279115 "$node_(77) setdest 114461 8678 18.0" 
$ns at 337.653062610908 "$node_(77) setdest 139250 45426 5.0" 
$ns at 373.5766468450098 "$node_(77) setdest 167746 19016 11.0" 
$ns at 507.7362930373107 "$node_(77) setdest 66986 55827 17.0" 
$ns at 645.7758124323833 "$node_(77) setdest 185727 2850 3.0" 
$ns at 679.4057185287716 "$node_(77) setdest 109792 1249 4.0" 
$ns at 726.378663543935 "$node_(77) setdest 230969 4553 11.0" 
$ns at 797.0809683029651 "$node_(77) setdest 142806 43748 5.0" 
$ns at 871.809602259523 "$node_(77) setdest 172516 73870 12.0" 
$ns at 0.0 "$node_(78) setdest 66215 9298 18.0" 
$ns at 61.85655319772577 "$node_(78) setdest 74907 12143 3.0" 
$ns at 95.85810566544754 "$node_(78) setdest 56996 20436 1.0" 
$ns at 133.82338913289104 "$node_(78) setdest 84334 18619 19.0" 
$ns at 168.37936022808984 "$node_(78) setdest 94398 44051 19.0" 
$ns at 274.8904986672425 "$node_(78) setdest 35716 15560 8.0" 
$ns at 317.1026287804243 "$node_(78) setdest 64079 5531 6.0" 
$ns at 368.5457394161013 "$node_(78) setdest 129450 60568 20.0" 
$ns at 511.5748393608585 "$node_(78) setdest 146460 38408 11.0" 
$ns at 567.0324406314077 "$node_(78) setdest 204584 59445 1.0" 
$ns at 600.0968224303713 "$node_(78) setdest 131991 61431 16.0" 
$ns at 711.744790859112 "$node_(78) setdest 229063 4005 10.0" 
$ns at 790.2000781558799 "$node_(78) setdest 260367 84428 14.0" 
$ns at 828.5886215907277 "$node_(78) setdest 211278 58961 5.0" 
$ns at 875.5175636761381 "$node_(78) setdest 28203 78125 1.0" 
$ns at 0.0 "$node_(79) setdest 46964 25083 19.0" 
$ns at 169.97017121429542 "$node_(79) setdest 86676 6629 1.0" 
$ns at 201.0612758122805 "$node_(79) setdest 11364 4398 2.0" 
$ns at 246.65942907841998 "$node_(79) setdest 110869 6630 18.0" 
$ns at 428.1916303714098 "$node_(79) setdest 61865 15067 15.0" 
$ns at 523.8154683562227 "$node_(79) setdest 132973 10584 17.0" 
$ns at 702.7838772554787 "$node_(79) setdest 197766 20577 3.0" 
$ns at 744.4710766089304 "$node_(79) setdest 129354 29646 5.0" 
$ns at 805.7266503521153 "$node_(79) setdest 111520 25753 9.0" 
$ns at 880.9940075460911 "$node_(79) setdest 119446 9292 14.0" 
$ns at 0.0 "$node_(80) setdest 89104 22160 14.0" 
$ns at 116.22390832474679 "$node_(80) setdest 6510 24265 2.0" 
$ns at 156.7815302108578 "$node_(80) setdest 93228 18508 6.0" 
$ns at 220.21798545938333 "$node_(80) setdest 50159 1779 1.0" 
$ns at 259.3109433632983 "$node_(80) setdest 113487 6659 14.0" 
$ns at 370.04753962466884 "$node_(80) setdest 38115 40557 14.0" 
$ns at 424.71013151881766 "$node_(80) setdest 189706 51726 4.0" 
$ns at 479.124444741458 "$node_(80) setdest 73079 46177 13.0" 
$ns at 527.7388920816621 "$node_(80) setdest 172437 39373 18.0" 
$ns at 568.4095254579324 "$node_(80) setdest 46727 75963 13.0" 
$ns at 607.2044400739805 "$node_(80) setdest 169761 42794 12.0" 
$ns at 637.8225154963673 "$node_(80) setdest 38585 52780 20.0" 
$ns at 707.2236959495042 "$node_(80) setdest 32638 82073 10.0" 
$ns at 741.2075228114186 "$node_(80) setdest 60025 12078 4.0" 
$ns at 810.6754705161736 "$node_(80) setdest 184147 8809 15.0" 
$ns at 860.8147676679201 "$node_(80) setdest 146155 32389 4.0" 
$ns at 892.3758598525197 "$node_(80) setdest 102027 48139 10.0" 
$ns at 0.0 "$node_(81) setdest 68644 24710 15.0" 
$ns at 39.564036288545495 "$node_(81) setdest 54688 28446 9.0" 
$ns at 107.92364138342016 "$node_(81) setdest 38353 14910 8.0" 
$ns at 170.8307575985632 "$node_(81) setdest 241 44407 5.0" 
$ns at 205.69838293149104 "$node_(81) setdest 28147 26789 5.0" 
$ns at 284.66989488788795 "$node_(81) setdest 116220 19374 11.0" 
$ns at 325.80501796453444 "$node_(81) setdest 1240 24444 8.0" 
$ns at 399.2939649056607 "$node_(81) setdest 65527 56137 18.0" 
$ns at 432.8026335137845 "$node_(81) setdest 68172 29270 18.0" 
$ns at 609.1376914728432 "$node_(81) setdest 79991 59040 2.0" 
$ns at 643.0674400406425 "$node_(81) setdest 87874 6754 9.0" 
$ns at 741.5941806115883 "$node_(81) setdest 203732 75880 14.0" 
$ns at 884.3728820179199 "$node_(81) setdest 120627 29381 1.0" 
$ns at 0.0 "$node_(82) setdest 23736 23240 12.0" 
$ns at 73.3202982056088 "$node_(82) setdest 49662 10896 19.0" 
$ns at 196.2340559448366 "$node_(82) setdest 55724 42489 10.0" 
$ns at 261.3699718391825 "$node_(82) setdest 153589 27729 14.0" 
$ns at 311.9573339389787 "$node_(82) setdest 147831 30300 6.0" 
$ns at 397.1547181393312 "$node_(82) setdest 181818 43372 19.0" 
$ns at 455.0537224577204 "$node_(82) setdest 58134 28928 7.0" 
$ns at 538.8390669089474 "$node_(82) setdest 118176 53505 18.0" 
$ns at 651.6001507080219 "$node_(82) setdest 217964 82801 2.0" 
$ns at 695.7721562173596 "$node_(82) setdest 7256 45601 8.0" 
$ns at 761.2320987232296 "$node_(82) setdest 140584 13836 8.0" 
$ns at 834.4231466956262 "$node_(82) setdest 136690 64298 13.0" 
$ns at 0.0 "$node_(83) setdest 85287 2682 9.0" 
$ns at 45.810964242440534 "$node_(83) setdest 51103 11224 10.0" 
$ns at 131.91877019627822 "$node_(83) setdest 15221 23055 16.0" 
$ns at 193.40404411905627 "$node_(83) setdest 19843 7636 20.0" 
$ns at 362.95623648356417 "$node_(83) setdest 27028 24092 9.0" 
$ns at 416.0303124778194 "$node_(83) setdest 32937 41753 12.0" 
$ns at 534.6549569735486 "$node_(83) setdest 64740 17374 16.0" 
$ns at 566.6776553694065 "$node_(83) setdest 175687 48109 10.0" 
$ns at 633.3525518063263 "$node_(83) setdest 17431 8741 9.0" 
$ns at 709.6871617294353 "$node_(83) setdest 57532 68031 6.0" 
$ns at 784.3712900164139 "$node_(83) setdest 106889 44384 3.0" 
$ns at 820.9281377391522 "$node_(83) setdest 230551 65639 16.0" 
$ns at 898.9734622449096 "$node_(83) setdest 158670 76550 11.0" 
$ns at 0.0 "$node_(84) setdest 13098 23775 4.0" 
$ns at 59.98748192581386 "$node_(84) setdest 77518 24167 9.0" 
$ns at 111.35565252741517 "$node_(84) setdest 55983 2671 15.0" 
$ns at 240.0907802668336 "$node_(84) setdest 103719 5838 12.0" 
$ns at 355.02513034615214 "$node_(84) setdest 56530 22737 10.0" 
$ns at 393.913477584905 "$node_(84) setdest 79634 53520 12.0" 
$ns at 476.4388120938726 "$node_(84) setdest 128308 52885 11.0" 
$ns at 521.8301190824616 "$node_(84) setdest 176799 32864 4.0" 
$ns at 590.6713400253615 "$node_(84) setdest 162891 70223 12.0" 
$ns at 671.3562405485256 "$node_(84) setdest 129336 65222 16.0" 
$ns at 846.4522559023115 "$node_(84) setdest 13407 19617 2.0" 
$ns at 892.0115685062643 "$node_(84) setdest 197868 36899 8.0" 
$ns at 0.0 "$node_(85) setdest 81914 2350 11.0" 
$ns at 116.7226209168725 "$node_(85) setdest 72063 24583 7.0" 
$ns at 198.8090200411732 "$node_(85) setdest 10748 7429 7.0" 
$ns at 290.1764735971151 "$node_(85) setdest 163958 1648 19.0" 
$ns at 471.78790077706685 "$node_(85) setdest 118049 4303 3.0" 
$ns at 503.3323343281285 "$node_(85) setdest 101077 61565 10.0" 
$ns at 570.6240221373193 "$node_(85) setdest 99134 39700 15.0" 
$ns at 689.8697579361199 "$node_(85) setdest 36935 25837 7.0" 
$ns at 724.421224028025 "$node_(85) setdest 210172 22507 4.0" 
$ns at 764.2301940741809 "$node_(85) setdest 242821 67725 1.0" 
$ns at 797.9599876702554 "$node_(85) setdest 138638 31829 18.0" 
$ns at 0.0 "$node_(86) setdest 36544 2066 18.0" 
$ns at 145.07435262280623 "$node_(86) setdest 83644 2409 9.0" 
$ns at 202.9212940091486 "$node_(86) setdest 117033 15993 6.0" 
$ns at 252.81571856228553 "$node_(86) setdest 105751 11780 6.0" 
$ns at 331.30738178861924 "$node_(86) setdest 148293 43192 3.0" 
$ns at 378.99726392722084 "$node_(86) setdest 22107 11792 9.0" 
$ns at 473.95946705968584 "$node_(86) setdest 83359 40918 15.0" 
$ns at 536.1553449230479 "$node_(86) setdest 145829 7863 4.0" 
$ns at 572.7015416714858 "$node_(86) setdest 88137 73119 4.0" 
$ns at 623.7090451492924 "$node_(86) setdest 35768 4985 3.0" 
$ns at 669.4412435750836 "$node_(86) setdest 173906 65516 19.0" 
$ns at 843.3268129767578 "$node_(86) setdest 237979 87640 9.0" 
$ns at 0.0 "$node_(87) setdest 15253 7411 17.0" 
$ns at 188.60651031892007 "$node_(87) setdest 3435 42535 14.0" 
$ns at 252.80598234708768 "$node_(87) setdest 26285 25573 1.0" 
$ns at 286.54491004291356 "$node_(87) setdest 26534 50157 14.0" 
$ns at 409.42562065160985 "$node_(87) setdest 115297 20140 6.0" 
$ns at 456.55503708264285 "$node_(87) setdest 46288 68064 14.0" 
$ns at 515.7976957273165 "$node_(87) setdest 152801 45512 15.0" 
$ns at 558.9433347173976 "$node_(87) setdest 112674 58041 11.0" 
$ns at 606.9341090975322 "$node_(87) setdest 28523 37628 17.0" 
$ns at 707.8891163529354 "$node_(87) setdest 2348 64363 10.0" 
$ns at 813.4787189419997 "$node_(87) setdest 37550 38946 16.0" 
$ns at 0.0 "$node_(88) setdest 76733 14396 14.0" 
$ns at 119.7525331209783 "$node_(88) setdest 33504 24954 18.0" 
$ns at 270.698415426631 "$node_(88) setdest 99345 19647 9.0" 
$ns at 376.0921344667023 "$node_(88) setdest 142795 23488 18.0" 
$ns at 524.5027623824207 "$node_(88) setdest 8067 63156 12.0" 
$ns at 604.9658629308742 "$node_(88) setdest 15927 10349 4.0" 
$ns at 647.6419015270346 "$node_(88) setdest 133617 29377 20.0" 
$ns at 781.6958725755509 "$node_(88) setdest 30366 79848 5.0" 
$ns at 823.929814089415 "$node_(88) setdest 149051 34015 15.0" 
$ns at 0.0 "$node_(89) setdest 20380 26030 13.0" 
$ns at 124.9125340305104 "$node_(89) setdest 9069 17915 6.0" 
$ns at 207.50817143949797 "$node_(89) setdest 10330 25279 6.0" 
$ns at 260.62924594936635 "$node_(89) setdest 131287 32650 10.0" 
$ns at 364.13251980660357 "$node_(89) setdest 122174 4028 9.0" 
$ns at 471.01530041346206 "$node_(89) setdest 102806 53139 6.0" 
$ns at 547.4998001640244 "$node_(89) setdest 170735 35257 10.0" 
$ns at 654.9774119557862 "$node_(89) setdest 97424 26696 13.0" 
$ns at 711.0157481357936 "$node_(89) setdest 4798 77268 14.0" 
$ns at 800.0402199345432 "$node_(89) setdest 145839 85040 1.0" 
$ns at 830.6437085530599 "$node_(89) setdest 52003 42270 15.0" 
$ns at 0.0 "$node_(90) setdest 28681 15668 9.0" 
$ns at 103.61016867492775 "$node_(90) setdest 37599 7932 4.0" 
$ns at 151.5267952943444 "$node_(90) setdest 26513 1739 10.0" 
$ns at 244.89509150460447 "$node_(90) setdest 31364 12106 6.0" 
$ns at 282.6193349616831 "$node_(90) setdest 100108 7670 9.0" 
$ns at 327.3509431115853 "$node_(90) setdest 161203 2626 2.0" 
$ns at 367.27244291934267 "$node_(90) setdest 177943 31782 10.0" 
$ns at 489.3955370438902 "$node_(90) setdest 167574 50943 2.0" 
$ns at 534.4107211063783 "$node_(90) setdest 51862 40230 15.0" 
$ns at 640.1237244890468 "$node_(90) setdest 130392 62191 9.0" 
$ns at 688.9512277631814 "$node_(90) setdest 141297 64999 7.0" 
$ns at 735.8785432453349 "$node_(90) setdest 78040 78720 16.0" 
$ns at 866.3149373555233 "$node_(90) setdest 91688 41548 18.0" 
$ns at 0.0 "$node_(91) setdest 10938 8784 8.0" 
$ns at 79.0606507961306 "$node_(91) setdest 68557 21003 11.0" 
$ns at 171.45948346788492 "$node_(91) setdest 129150 13287 19.0" 
$ns at 352.67571619356136 "$node_(91) setdest 116429 17218 12.0" 
$ns at 484.3073565987745 "$node_(91) setdest 20701 17995 19.0" 
$ns at 645.2733932190383 "$node_(91) setdest 176985 25852 19.0" 
$ns at 709.0075200855362 "$node_(91) setdest 172711 47000 17.0" 
$ns at 809.5389259474795 "$node_(91) setdest 76180 38420 16.0" 
$ns at 0.0 "$node_(92) setdest 85129 23307 15.0" 
$ns at 137.26262998230112 "$node_(92) setdest 34534 12801 9.0" 
$ns at 231.2119817749665 "$node_(92) setdest 92966 35042 4.0" 
$ns at 298.48761459560103 "$node_(92) setdest 11433 50765 10.0" 
$ns at 373.7084219416845 "$node_(92) setdest 185026 7033 11.0" 
$ns at 500.1115557731085 "$node_(92) setdest 105870 43182 15.0" 
$ns at 546.0511281747974 "$node_(92) setdest 181710 25669 9.0" 
$ns at 644.8940255670337 "$node_(92) setdest 166045 54259 2.0" 
$ns at 687.3732393595973 "$node_(92) setdest 43825 63689 3.0" 
$ns at 736.8054269246788 "$node_(92) setdest 41991 45629 14.0" 
$ns at 899.1894122186904 "$node_(92) setdest 152807 74676 9.0" 
$ns at 0.0 "$node_(93) setdest 54418 11311 11.0" 
$ns at 38.32368218559838 "$node_(93) setdest 67314 20344 9.0" 
$ns at 108.16679204651757 "$node_(93) setdest 42453 31373 18.0" 
$ns at 261.22804272804274 "$node_(93) setdest 81464 46994 4.0" 
$ns at 316.97336751161413 "$node_(93) setdest 122825 40187 15.0" 
$ns at 351.6883337059418 "$node_(93) setdest 62150 20016 19.0" 
$ns at 388.09814296920035 "$node_(93) setdest 65385 21110 14.0" 
$ns at 456.96937439925296 "$node_(93) setdest 161658 64471 1.0" 
$ns at 495.0194773233089 "$node_(93) setdest 56941 55211 3.0" 
$ns at 538.8349614035276 "$node_(93) setdest 31566 65760 2.0" 
$ns at 573.6659177075687 "$node_(93) setdest 218033 42272 14.0" 
$ns at 702.9426916725595 "$node_(93) setdest 18012 16736 10.0" 
$ns at 784.6958423375627 "$node_(93) setdest 224511 25881 5.0" 
$ns at 838.9202153052919 "$node_(93) setdest 182707 59776 9.0" 
$ns at 0.0 "$node_(94) setdest 31513 8544 3.0" 
$ns at 57.02950593246575 "$node_(94) setdest 23269 8279 14.0" 
$ns at 155.6317433505242 "$node_(94) setdest 81564 42085 4.0" 
$ns at 202.78714196319828 "$node_(94) setdest 68359 6836 10.0" 
$ns at 238.23095714552244 "$node_(94) setdest 121323 21151 8.0" 
$ns at 310.5429462330062 "$node_(94) setdest 112726 43212 14.0" 
$ns at 398.41639487491835 "$node_(94) setdest 100769 12268 20.0" 
$ns at 432.2990348499758 "$node_(94) setdest 31244 19016 2.0" 
$ns at 472.6959415178726 "$node_(94) setdest 75883 12878 2.0" 
$ns at 507.2407540226759 "$node_(94) setdest 57730 10686 5.0" 
$ns at 551.2840889610557 "$node_(94) setdest 171330 38718 20.0" 
$ns at 625.8185345631018 "$node_(94) setdest 154052 10870 19.0" 
$ns at 767.5631347445585 "$node_(94) setdest 19436 72342 5.0" 
$ns at 832.042468758668 "$node_(94) setdest 46701 11404 4.0" 
$ns at 871.1536908595851 "$node_(94) setdest 128643 31593 7.0" 
$ns at 0.0 "$node_(95) setdest 21378 2682 11.0" 
$ns at 40.476474911862574 "$node_(95) setdest 24458 17386 1.0" 
$ns at 72.11401145028036 "$node_(95) setdest 9272 10933 18.0" 
$ns at 172.45594338340604 "$node_(95) setdest 16447 30087 17.0" 
$ns at 218.49577011554547 "$node_(95) setdest 90035 7215 19.0" 
$ns at 385.6188419469345 "$node_(95) setdest 77008 23551 13.0" 
$ns at 524.99418922013 "$node_(95) setdest 96289 65605 13.0" 
$ns at 592.2685546494441 "$node_(95) setdest 159220 1129 11.0" 
$ns at 676.2176866983381 "$node_(95) setdest 247737 58427 7.0" 
$ns at 746.0254077309058 "$node_(95) setdest 136874 6788 6.0" 
$ns at 814.5369595219064 "$node_(95) setdest 255673 75398 5.0" 
$ns at 855.084159416414 "$node_(95) setdest 115619 10500 16.0" 
$ns at 0.0 "$node_(96) setdest 54350 30654 4.0" 
$ns at 30.14484338981818 "$node_(96) setdest 75558 30573 19.0" 
$ns at 229.48632738472062 "$node_(96) setdest 16771 20919 7.0" 
$ns at 270.3494520348922 "$node_(96) setdest 1878 15339 3.0" 
$ns at 312.5595862749925 "$node_(96) setdest 108861 16106 8.0" 
$ns at 364.5884562924828 "$node_(96) setdest 137885 33971 12.0" 
$ns at 442.01486485486123 "$node_(96) setdest 50766 53948 1.0" 
$ns at 479.46489109974885 "$node_(96) setdest 140016 5008 12.0" 
$ns at 560.956584278485 "$node_(96) setdest 97689 7456 17.0" 
$ns at 658.7566179144957 "$node_(96) setdest 1794 69416 16.0" 
$ns at 753.8244817313033 "$node_(96) setdest 84945 17677 17.0" 
$ns at 0.0 "$node_(97) setdest 88775 27475 11.0" 
$ns at 90.27718196966998 "$node_(97) setdest 20351 13249 3.0" 
$ns at 144.5537115125001 "$node_(97) setdest 82490 25517 6.0" 
$ns at 233.84244730485244 "$node_(97) setdest 19451 1347 16.0" 
$ns at 310.8362062350748 "$node_(97) setdest 85212 40394 14.0" 
$ns at 378.27008729467104 "$node_(97) setdest 107147 25071 10.0" 
$ns at 436.84736256709255 "$node_(97) setdest 164003 21064 11.0" 
$ns at 496.37532672548735 "$node_(97) setdest 166823 42163 3.0" 
$ns at 537.8598928800104 "$node_(97) setdest 117768 9194 16.0" 
$ns at 632.2501273018019 "$node_(97) setdest 61987 14190 18.0" 
$ns at 778.3517385316349 "$node_(97) setdest 112607 20846 1.0" 
$ns at 809.2908575359585 "$node_(97) setdest 22741 85368 3.0" 
$ns at 850.9747555743744 "$node_(97) setdest 14920 82902 20.0" 
$ns at 0.0 "$node_(98) setdest 18250 26577 13.0" 
$ns at 121.45956591417769 "$node_(98) setdest 66444 29528 7.0" 
$ns at 191.66135868084 "$node_(98) setdest 36153 12420 7.0" 
$ns at 281.36572164438934 "$node_(98) setdest 138157 16724 16.0" 
$ns at 406.9657619825284 "$node_(98) setdest 50284 42941 1.0" 
$ns at 437.06955593863717 "$node_(98) setdest 51008 11808 10.0" 
$ns at 469.3777824543507 "$node_(98) setdest 202962 61031 17.0" 
$ns at 666.1259137180087 "$node_(98) setdest 135701 78736 9.0" 
$ns at 708.8661571966062 "$node_(98) setdest 27940 46800 2.0" 
$ns at 755.8431713771918 "$node_(98) setdest 12260 33406 12.0" 
$ns at 880.9134049167349 "$node_(98) setdest 20526 31096 15.0" 
$ns at 0.0 "$node_(99) setdest 13569 1320 9.0" 
$ns at 62.76902485603274 "$node_(99) setdest 84282 20538 19.0" 
$ns at 94.27604251942995 "$node_(99) setdest 6823 28231 16.0" 
$ns at 204.56843119531052 "$node_(99) setdest 30161 28257 9.0" 
$ns at 312.628608296623 "$node_(99) setdest 97537 39032 18.0" 
$ns at 489.9195937613314 "$node_(99) setdest 166959 9785 2.0" 
$ns at 536.3836456249088 "$node_(99) setdest 121211 9134 19.0" 
$ns at 597.4918714381143 "$node_(99) setdest 219055 756 18.0" 
$ns at 744.1425487143695 "$node_(99) setdest 237504 12905 8.0" 
$ns at 794.3698379358924 "$node_(99) setdest 190626 36485 1.0" 
$ns at 834.2428061141948 "$node_(99) setdest 218515 45170 17.0" 
$ns at 0.0 "$node_(100) setdest 56361 287 1.0" 
$ns at 33.83613583338269 "$node_(100) setdest 75738 8592 9.0" 
$ns at 132.7143483409901 "$node_(100) setdest 59655 5087 5.0" 
$ns at 194.2087135462392 "$node_(100) setdest 37781 5053 1.0" 
$ns at 227.7791684541312 "$node_(100) setdest 16932 18881 1.0" 
$ns at 264.04174947786623 "$node_(100) setdest 143561 34972 16.0" 
$ns at 310.0106292731721 "$node_(100) setdest 18086 351 19.0" 
$ns at 371.779483043576 "$node_(100) setdest 119443 27299 15.0" 
$ns at 478.38211354604624 "$node_(100) setdest 183497 5943 10.0" 
$ns at 541.8214571499949 "$node_(100) setdest 34707 69721 18.0" 
$ns at 677.8917495428182 "$node_(100) setdest 131952 201 19.0" 
$ns at 787.8979513552973 "$node_(100) setdest 256470 55690 1.0" 
$ns at 821.6046677655341 "$node_(100) setdest 203135 71918 17.0" 
$ns at 163.02246041476167 "$node_(101) setdest 116199 40696 19.0" 
$ns at 207.4733593827288 "$node_(101) setdest 86763 2005 10.0" 
$ns at 255.35946949817549 "$node_(101) setdest 56038 13369 7.0" 
$ns at 318.59355161911736 "$node_(101) setdest 103977 47902 19.0" 
$ns at 537.6304425931784 "$node_(101) setdest 178456 38292 1.0" 
$ns at 574.4959447962374 "$node_(101) setdest 101183 61338 4.0" 
$ns at 607.7833824158212 "$node_(101) setdest 15855 33655 1.0" 
$ns at 647.6339797361994 "$node_(101) setdest 93598 30221 7.0" 
$ns at 735.8376828841206 "$node_(101) setdest 101778 69617 5.0" 
$ns at 794.2461347615033 "$node_(101) setdest 225574 11916 5.0" 
$ns at 847.5097464339334 "$node_(101) setdest 111843 71323 4.0" 
$ns at 888.51637735311 "$node_(101) setdest 109265 10645 7.0" 
$ns at 117.54517044440547 "$node_(102) setdest 7643 1452 13.0" 
$ns at 222.62912372038727 "$node_(102) setdest 110061 11414 17.0" 
$ns at 306.2301616274639 "$node_(102) setdest 128452 54480 14.0" 
$ns at 363.87123878731035 "$node_(102) setdest 43485 51838 8.0" 
$ns at 411.1537897743752 "$node_(102) setdest 186792 56258 6.0" 
$ns at 472.08511908539714 "$node_(102) setdest 97732 38603 8.0" 
$ns at 570.3597835802443 "$node_(102) setdest 207842 58200 11.0" 
$ns at 671.3423851426135 "$node_(102) setdest 119963 1718 8.0" 
$ns at 720.554899653232 "$node_(102) setdest 7344 8932 9.0" 
$ns at 798.3519367598076 "$node_(102) setdest 114443 21566 7.0" 
$ns at 889.2033603081773 "$node_(102) setdest 75763 14815 11.0" 
$ns at 136.86477306401292 "$node_(103) setdest 87480 3038 19.0" 
$ns at 294.7293526676434 "$node_(103) setdest 43411 13972 17.0" 
$ns at 413.38239967730516 "$node_(103) setdest 150641 36544 14.0" 
$ns at 546.8491409212968 "$node_(103) setdest 81573 35476 11.0" 
$ns at 584.3305847025497 "$node_(103) setdest 6448 17944 12.0" 
$ns at 632.0746354751532 "$node_(103) setdest 169242 72340 16.0" 
$ns at 733.7844151051602 "$node_(103) setdest 77840 27437 12.0" 
$ns at 775.9078752128429 "$node_(103) setdest 46619 16494 7.0" 
$ns at 870.3596664870241 "$node_(103) setdest 136838 58008 10.0" 
$ns at 135.96541134389565 "$node_(104) setdest 58275 3200 9.0" 
$ns at 235.03935504189798 "$node_(104) setdest 24594 25634 7.0" 
$ns at 333.7916422169052 "$node_(104) setdest 76502 18232 5.0" 
$ns at 387.5444984142568 "$node_(104) setdest 120903 58042 1.0" 
$ns at 425.9156602944905 "$node_(104) setdest 69655 54742 11.0" 
$ns at 505.28690600691004 "$node_(104) setdest 68416 9621 7.0" 
$ns at 548.3402352297975 "$node_(104) setdest 195026 46961 14.0" 
$ns at 702.4128412543189 "$node_(104) setdest 144141 76906 1.0" 
$ns at 735.7092119972092 "$node_(104) setdest 100360 60682 6.0" 
$ns at 809.0294534658346 "$node_(104) setdest 167847 78860 16.0" 
$ns at 878.9728577049763 "$node_(104) setdest 6338 28398 10.0" 
$ns at 135.6629054884039 "$node_(105) setdest 21570 19320 12.0" 
$ns at 240.87020639961708 "$node_(105) setdest 65933 23324 3.0" 
$ns at 292.50263353214206 "$node_(105) setdest 58209 47654 16.0" 
$ns at 478.1855249657751 "$node_(105) setdest 155861 6 7.0" 
$ns at 567.4767072531838 "$node_(105) setdest 61509 4280 4.0" 
$ns at 631.0661959867372 "$node_(105) setdest 6154 72285 7.0" 
$ns at 699.9726810597981 "$node_(105) setdest 241033 46622 1.0" 
$ns at 738.773164069984 "$node_(105) setdest 71498 80829 18.0" 
$ns at 841.0119227681491 "$node_(105) setdest 131812 78964 17.0" 
$ns at 145.44730822672423 "$node_(106) setdest 25918 14679 15.0" 
$ns at 241.52377307358682 "$node_(106) setdest 59560 24016 3.0" 
$ns at 297.6168600854053 "$node_(106) setdest 58157 40245 3.0" 
$ns at 341.4023922712233 "$node_(106) setdest 32205 18337 14.0" 
$ns at 377.5272289637288 "$node_(106) setdest 183547 50711 19.0" 
$ns at 478.60472664665866 "$node_(106) setdest 139987 28743 11.0" 
$ns at 572.5679356536319 "$node_(106) setdest 12527 4594 16.0" 
$ns at 663.6415016372816 "$node_(106) setdest 232856 39876 9.0" 
$ns at 775.1444013777325 "$node_(106) setdest 249241 82744 4.0" 
$ns at 844.8468906815349 "$node_(106) setdest 119176 74032 16.0" 
$ns at 898.966595155621 "$node_(106) setdest 148276 40740 11.0" 
$ns at 128.2451090102674 "$node_(107) setdest 65276 13259 3.0" 
$ns at 177.6537082696161 "$node_(107) setdest 107713 8308 8.0" 
$ns at 231.46773025810634 "$node_(107) setdest 67172 14404 9.0" 
$ns at 265.67483502503285 "$node_(107) setdest 118867 3603 9.0" 
$ns at 317.7177162722031 "$node_(107) setdest 39239 13605 12.0" 
$ns at 456.0995276415581 "$node_(107) setdest 105448 65464 13.0" 
$ns at 613.967397331435 "$node_(107) setdest 52770 4502 4.0" 
$ns at 675.8138717386352 "$node_(107) setdest 105563 61248 14.0" 
$ns at 779.1650719988897 "$node_(107) setdest 85659 29439 9.0" 
$ns at 821.6018992558324 "$node_(107) setdest 171916 77040 1.0" 
$ns at 857.7076967466128 "$node_(107) setdest 149851 37407 19.0" 
$ns at 245.18527871412934 "$node_(108) setdest 40405 10844 20.0" 
$ns at 296.94989672633676 "$node_(108) setdest 147051 54445 3.0" 
$ns at 337.73184516778696 "$node_(108) setdest 120776 51086 13.0" 
$ns at 393.32585985075457 "$node_(108) setdest 135774 22265 14.0" 
$ns at 506.13410849542817 "$node_(108) setdest 7014 63274 3.0" 
$ns at 552.0549220931791 "$node_(108) setdest 160572 62289 17.0" 
$ns at 637.96149835165 "$node_(108) setdest 45913 68448 10.0" 
$ns at 686.2915342136234 "$node_(108) setdest 212796 16051 3.0" 
$ns at 740.19825214629 "$node_(108) setdest 120181 15689 5.0" 
$ns at 790.6005643866238 "$node_(108) setdest 198793 57443 18.0" 
$ns at 220.19552637513934 "$node_(109) setdest 86554 42868 1.0" 
$ns at 253.98638540982145 "$node_(109) setdest 125622 387 19.0" 
$ns at 309.03619298073124 "$node_(109) setdest 98317 14331 6.0" 
$ns at 377.87313187568384 "$node_(109) setdest 69472 52031 6.0" 
$ns at 430.0182848651988 "$node_(109) setdest 67439 56731 17.0" 
$ns at 559.4278668902026 "$node_(109) setdest 184643 8882 10.0" 
$ns at 632.6130036756813 "$node_(109) setdest 186197 71652 1.0" 
$ns at 669.8295872495682 "$node_(109) setdest 18927 18215 7.0" 
$ns at 731.9836694477801 "$node_(109) setdest 94827 73809 11.0" 
$ns at 798.7998716814812 "$node_(109) setdest 231837 44045 8.0" 
$ns at 849.5709034348758 "$node_(109) setdest 7365 61163 1.0" 
$ns at 881.9372375031827 "$node_(109) setdest 93036 6708 5.0" 
$ns at 121.10107091193214 "$node_(110) setdest 90870 13555 5.0" 
$ns at 155.5574724364768 "$node_(110) setdest 83939 34541 6.0" 
$ns at 209.4860980033176 "$node_(110) setdest 87713 8796 8.0" 
$ns at 273.9972594510441 "$node_(110) setdest 79791 19946 16.0" 
$ns at 313.8419628482528 "$node_(110) setdest 86458 3107 5.0" 
$ns at 373.59146863212754 "$node_(110) setdest 56794 35543 16.0" 
$ns at 533.7701441182658 "$node_(110) setdest 165654 48657 1.0" 
$ns at 563.8449946754669 "$node_(110) setdest 117341 74798 1.0" 
$ns at 597.6337817174291 "$node_(110) setdest 139337 65727 1.0" 
$ns at 630.4915671911999 "$node_(110) setdest 28911 68876 1.0" 
$ns at 663.3096172228854 "$node_(110) setdest 239392 77666 5.0" 
$ns at 733.5626269730836 "$node_(110) setdest 245696 26338 11.0" 
$ns at 837.2709358784142 "$node_(110) setdest 157121 4556 17.0" 
$ns at 131.5743287925763 "$node_(111) setdest 74371 24644 1.0" 
$ns at 168.5041487672218 "$node_(111) setdest 62236 7506 5.0" 
$ns at 215.72132814432445 "$node_(111) setdest 3433 6271 17.0" 
$ns at 397.33706268141736 "$node_(111) setdest 114328 40631 12.0" 
$ns at 450.21721503071655 "$node_(111) setdest 50778 58388 5.0" 
$ns at 487.9392055566655 "$node_(111) setdest 158068 32353 16.0" 
$ns at 565.6641277196169 "$node_(111) setdest 5655 33905 16.0" 
$ns at 691.4249025466868 "$node_(111) setdest 196163 80113 18.0" 
$ns at 893.3743048982479 "$node_(111) setdest 241530 61527 3.0" 
$ns at 180.46358966251444 "$node_(112) setdest 87319 27609 10.0" 
$ns at 302.8345528493383 "$node_(112) setdest 72550 43520 6.0" 
$ns at 375.6873500933185 "$node_(112) setdest 84518 37067 1.0" 
$ns at 409.9080472663352 "$node_(112) setdest 135058 15945 1.0" 
$ns at 440.90494504510895 "$node_(112) setdest 113928 13646 10.0" 
$ns at 516.766459655377 "$node_(112) setdest 24508 35795 12.0" 
$ns at 555.6097161905817 "$node_(112) setdest 109338 11024 16.0" 
$ns at 646.0264214648153 "$node_(112) setdest 216837 76666 17.0" 
$ns at 789.1384116572694 "$node_(112) setdest 74518 31246 1.0" 
$ns at 822.9405770946328 "$node_(112) setdest 28720 14619 9.0" 
$ns at 889.8666034570954 "$node_(112) setdest 240365 23587 19.0" 
$ns at 109.42746110057817 "$node_(113) setdest 88370 8213 16.0" 
$ns at 146.33480657771034 "$node_(113) setdest 5711 10920 7.0" 
$ns at 189.8733920077981 "$node_(113) setdest 41248 25524 15.0" 
$ns at 343.3018768540039 "$node_(113) setdest 85170 19469 13.0" 
$ns at 493.06990126613596 "$node_(113) setdest 168338 66696 14.0" 
$ns at 661.2572882670183 "$node_(113) setdest 183493 10383 1.0" 
$ns at 699.0470375837258 "$node_(113) setdest 197419 7735 9.0" 
$ns at 775.7155033569526 "$node_(113) setdest 111966 51386 12.0" 
$ns at 860.3395942671399 "$node_(113) setdest 37334 68823 11.0" 
$ns at 162.69376148961504 "$node_(114) setdest 53002 9308 14.0" 
$ns at 219.14643639878267 "$node_(114) setdest 7148 36101 14.0" 
$ns at 372.8124884701875 "$node_(114) setdest 181036 6223 1.0" 
$ns at 412.35826749097805 "$node_(114) setdest 50025 20947 3.0" 
$ns at 446.53305102384246 "$node_(114) setdest 20768 22169 16.0" 
$ns at 476.7101003029175 "$node_(114) setdest 18255 2970 1.0" 
$ns at 515.6190243669051 "$node_(114) setdest 18423 36964 12.0" 
$ns at 556.1635149082504 "$node_(114) setdest 80126 44646 15.0" 
$ns at 663.3931676443921 "$node_(114) setdest 62371 17716 18.0" 
$ns at 805.2613776732969 "$node_(114) setdest 225580 45708 1.0" 
$ns at 841.7320392955389 "$node_(114) setdest 242615 11145 19.0" 
$ns at 160.94394248319986 "$node_(115) setdest 90185 39911 19.0" 
$ns at 229.20448816685553 "$node_(115) setdest 82150 34462 13.0" 
$ns at 259.41031351596394 "$node_(115) setdest 159709 40463 5.0" 
$ns at 297.3411838420285 "$node_(115) setdest 135394 52450 10.0" 
$ns at 374.81412292679295 "$node_(115) setdest 91101 23133 11.0" 
$ns at 449.1700763284389 "$node_(115) setdest 109596 12349 3.0" 
$ns at 500.52926161984846 "$node_(115) setdest 134228 47539 18.0" 
$ns at 547.9534258594341 "$node_(115) setdest 100002 54729 17.0" 
$ns at 653.1500692713367 "$node_(115) setdest 126692 13900 14.0" 
$ns at 754.5592692601278 "$node_(115) setdest 9454 54470 4.0" 
$ns at 797.4933285908266 "$node_(115) setdest 174299 16498 3.0" 
$ns at 839.9182780294373 "$node_(115) setdest 76169 60166 15.0" 
$ns at 118.0537170545424 "$node_(116) setdest 78931 23574 13.0" 
$ns at 213.04465028254998 "$node_(116) setdest 18557 34659 18.0" 
$ns at 326.8251386761555 "$node_(116) setdest 4817 3234 18.0" 
$ns at 385.2553327063839 "$node_(116) setdest 94513 20297 17.0" 
$ns at 462.2842934257147 "$node_(116) setdest 193642 50961 16.0" 
$ns at 551.0503056745513 "$node_(116) setdest 110887 43174 4.0" 
$ns at 590.6275440433427 "$node_(116) setdest 150374 24835 12.0" 
$ns at 662.7343359661025 "$node_(116) setdest 53293 78809 19.0" 
$ns at 836.7559461258878 "$node_(116) setdest 41667 84435 6.0" 
$ns at 891.1745699464773 "$node_(116) setdest 123337 84212 2.0" 
$ns at 125.52617239915094 "$node_(117) setdest 87906 29769 4.0" 
$ns at 156.70670582863943 "$node_(117) setdest 118671 15551 17.0" 
$ns at 327.64538571278956 "$node_(117) setdest 106433 4611 11.0" 
$ns at 391.8047760265585 "$node_(117) setdest 43694 37411 11.0" 
$ns at 455.44470871176856 "$node_(117) setdest 8406 4525 5.0" 
$ns at 498.52453032461443 "$node_(117) setdest 39193 52228 9.0" 
$ns at 595.8134812898537 "$node_(117) setdest 56718 9196 14.0" 
$ns at 647.6211652669285 "$node_(117) setdest 82346 75765 15.0" 
$ns at 695.8488399298107 "$node_(117) setdest 190913 59839 15.0" 
$ns at 763.7772704398928 "$node_(117) setdest 241833 22984 15.0" 
$ns at 824.8808467529353 "$node_(117) setdest 186154 22218 2.0" 
$ns at 855.3664289245781 "$node_(117) setdest 250353 63116 8.0" 
$ns at 179.85042836928875 "$node_(118) setdest 2486 20669 18.0" 
$ns at 349.9121858176046 "$node_(118) setdest 59139 42194 19.0" 
$ns at 531.91495752229 "$node_(118) setdest 108690 64609 13.0" 
$ns at 565.5886711504533 "$node_(118) setdest 141666 33081 1.0" 
$ns at 603.9149290491962 "$node_(118) setdest 72205 24881 13.0" 
$ns at 697.4798075585422 "$node_(118) setdest 38322 508 11.0" 
$ns at 758.0721701002375 "$node_(118) setdest 167917 64363 10.0" 
$ns at 869.1170116422528 "$node_(118) setdest 120229 81162 4.0" 
$ns at 103.91292184507375 "$node_(119) setdest 60135 3146 2.0" 
$ns at 146.3751850439607 "$node_(119) setdest 78165 28394 14.0" 
$ns at 182.90426845415325 "$node_(119) setdest 75071 27820 6.0" 
$ns at 225.59590760211773 "$node_(119) setdest 14889 12153 15.0" 
$ns at 260.11988936341027 "$node_(119) setdest 117850 27008 3.0" 
$ns at 294.3286490974836 "$node_(119) setdest 53732 14265 6.0" 
$ns at 350.1636789745518 "$node_(119) setdest 102723 48796 14.0" 
$ns at 389.0189118535434 "$node_(119) setdest 80469 56552 12.0" 
$ns at 526.2005771395548 "$node_(119) setdest 185409 69060 4.0" 
$ns at 595.5836067263691 "$node_(119) setdest 218230 16543 10.0" 
$ns at 639.0077528501063 "$node_(119) setdest 183910 3465 11.0" 
$ns at 770.7393179608539 "$node_(119) setdest 21533 23070 7.0" 
$ns at 860.3745802350503 "$node_(119) setdest 9039 50465 9.0" 
$ns at 199.16849958072686 "$node_(120) setdest 101323 12448 15.0" 
$ns at 248.47257036470086 "$node_(120) setdest 63179 4060 12.0" 
$ns at 325.6197366119275 "$node_(120) setdest 4840 15281 15.0" 
$ns at 450.56036340575247 "$node_(120) setdest 138457 4937 1.0" 
$ns at 486.0949582768103 "$node_(120) setdest 62497 61161 12.0" 
$ns at 543.2679525380917 "$node_(120) setdest 4395 12556 20.0" 
$ns at 740.0068641815355 "$node_(120) setdest 37369 77965 6.0" 
$ns at 795.4846002233578 "$node_(120) setdest 39953 64791 20.0" 
$ns at 879.7367979188448 "$node_(120) setdest 45628 63850 11.0" 
$ns at 194.25246880088127 "$node_(121) setdest 45581 1235 14.0" 
$ns at 284.38849120075383 "$node_(121) setdest 18257 30524 19.0" 
$ns at 368.3710371499085 "$node_(121) setdest 93993 51443 5.0" 
$ns at 411.8156374100457 "$node_(121) setdest 84607 52714 20.0" 
$ns at 630.0875314499503 "$node_(121) setdest 50061 66216 11.0" 
$ns at 710.6793711248325 "$node_(121) setdest 103697 30951 15.0" 
$ns at 789.067772483543 "$node_(121) setdest 10165 33225 10.0" 
$ns at 899.7114984115063 "$node_(121) setdest 45896 86842 9.0" 
$ns at 181.7177042526176 "$node_(122) setdest 56457 1452 1.0" 
$ns at 220.96654067407235 "$node_(122) setdest 129296 565 16.0" 
$ns at 387.0513765435 "$node_(122) setdest 125553 39921 11.0" 
$ns at 520.6262026727713 "$node_(122) setdest 196591 35429 2.0" 
$ns at 559.7599089129848 "$node_(122) setdest 159738 73750 7.0" 
$ns at 619.4279777099894 "$node_(122) setdest 37619 49487 4.0" 
$ns at 666.1271185017048 "$node_(122) setdest 38926 35046 11.0" 
$ns at 724.8551845561742 "$node_(122) setdest 1556 53273 12.0" 
$ns at 795.0903462507775 "$node_(122) setdest 83175 12525 12.0" 
$ns at 847.9163054049977 "$node_(122) setdest 50469 40465 12.0" 
$ns at 132.9124278156336 "$node_(123) setdest 89197 7783 1.0" 
$ns at 164.1027382429082 "$node_(123) setdest 11432 22152 8.0" 
$ns at 221.59424799711906 "$node_(123) setdest 124387 32305 17.0" 
$ns at 364.98754050429596 "$node_(123) setdest 175033 3860 4.0" 
$ns at 415.3621512403307 "$node_(123) setdest 184269 3189 12.0" 
$ns at 551.5893221941262 "$node_(123) setdest 1063 20985 16.0" 
$ns at 700.9833782340188 "$node_(123) setdest 199143 78138 4.0" 
$ns at 736.3020694378519 "$node_(123) setdest 94983 56940 19.0" 
$ns at 162.10247778788843 "$node_(124) setdest 107083 10704 12.0" 
$ns at 240.2640095329853 "$node_(124) setdest 115977 30141 17.0" 
$ns at 346.8870610315803 "$node_(124) setdest 64144 35206 9.0" 
$ns at 407.44817178151015 "$node_(124) setdest 96684 8760 5.0" 
$ns at 458.20045917989114 "$node_(124) setdest 187893 3786 6.0" 
$ns at 542.3933626463985 "$node_(124) setdest 76461 37295 2.0" 
$ns at 583.8955108245799 "$node_(124) setdest 117056 22758 17.0" 
$ns at 720.3695202945285 "$node_(124) setdest 39552 72482 1.0" 
$ns at 757.3957712801299 "$node_(124) setdest 41040 39400 20.0" 
$ns at 861.0815031004745 "$node_(124) setdest 34439 29509 14.0" 
$ns at 190.58633890530527 "$node_(125) setdest 126428 15711 14.0" 
$ns at 358.0138254945533 "$node_(125) setdest 110329 40919 14.0" 
$ns at 512.1486384588611 "$node_(125) setdest 46732 62427 18.0" 
$ns at 600.8575749229182 "$node_(125) setdest 60909 44699 18.0" 
$ns at 790.3657302940752 "$node_(125) setdest 114998 15379 1.0" 
$ns at 828.9725322136976 "$node_(125) setdest 224336 54487 11.0" 
$ns at 167.86109794527195 "$node_(126) setdest 94131 40419 13.0" 
$ns at 318.69046484716034 "$node_(126) setdest 86788 2468 11.0" 
$ns at 350.8803408540402 "$node_(126) setdest 145324 33153 13.0" 
$ns at 432.31783258431636 "$node_(126) setdest 91257 17850 19.0" 
$ns at 523.9576978170645 "$node_(126) setdest 12726 51358 1.0" 
$ns at 558.691727961023 "$node_(126) setdest 7161 29319 8.0" 
$ns at 643.4801700139079 "$node_(126) setdest 216614 63783 9.0" 
$ns at 729.929898782475 "$node_(126) setdest 67028 37636 2.0" 
$ns at 772.8173098024332 "$node_(126) setdest 35880 65894 19.0" 
$ns at 842.3438006657477 "$node_(126) setdest 92237 89047 11.0" 
$ns at 122.87838976319762 "$node_(127) setdest 67247 9104 2.0" 
$ns at 170.24960500076827 "$node_(127) setdest 124555 21061 18.0" 
$ns at 296.1439196459953 "$node_(127) setdest 83755 18229 9.0" 
$ns at 382.32469872630907 "$node_(127) setdest 64953 54648 17.0" 
$ns at 466.59390084859655 "$node_(127) setdest 187182 45337 20.0" 
$ns at 523.0520378009899 "$node_(127) setdest 62590 9301 8.0" 
$ns at 617.3850027043823 "$node_(127) setdest 18918 23050 16.0" 
$ns at 680.3610727614424 "$node_(127) setdest 118783 53772 4.0" 
$ns at 743.9450179155732 "$node_(127) setdest 165003 5530 2.0" 
$ns at 775.1914196391773 "$node_(127) setdest 87452 2023 2.0" 
$ns at 807.7716001168492 "$node_(127) setdest 37348 46541 19.0" 
$ns at 166.31463600583066 "$node_(128) setdest 23576 30942 8.0" 
$ns at 210.43678834952948 "$node_(128) setdest 48241 41999 6.0" 
$ns at 247.15852260785678 "$node_(128) setdest 30681 17330 16.0" 
$ns at 430.4002862806959 "$node_(128) setdest 27262 8390 5.0" 
$ns at 483.852887526238 "$node_(128) setdest 171622 19777 8.0" 
$ns at 554.6855202460785 "$node_(128) setdest 147455 16722 20.0" 
$ns at 702.9164848940841 "$node_(128) setdest 166034 56207 5.0" 
$ns at 741.378733593997 "$node_(128) setdest 161247 25830 17.0" 
$ns at 799.018443317248 "$node_(128) setdest 46470 51430 13.0" 
$ns at 209.16556841588977 "$node_(129) setdest 37923 33419 10.0" 
$ns at 271.6697680289062 "$node_(129) setdest 48818 15260 16.0" 
$ns at 364.493203753746 "$node_(129) setdest 107173 59042 6.0" 
$ns at 421.84103157726065 "$node_(129) setdest 163706 25709 3.0" 
$ns at 457.9735129094642 "$node_(129) setdest 186163 56000 18.0" 
$ns at 605.5788821270781 "$node_(129) setdest 189584 75381 7.0" 
$ns at 691.687021556612 "$node_(129) setdest 91887 59751 1.0" 
$ns at 729.0754437769652 "$node_(129) setdest 25093 7524 2.0" 
$ns at 762.0165753479581 "$node_(129) setdest 249406 77259 8.0" 
$ns at 827.442765716749 "$node_(129) setdest 112961 26866 14.0" 
$ns at 165.91322211279254 "$node_(130) setdest 22157 2649 1.0" 
$ns at 199.9370505731417 "$node_(130) setdest 98840 37797 8.0" 
$ns at 289.30610390801746 "$node_(130) setdest 135735 27820 7.0" 
$ns at 350.08085353116184 "$node_(130) setdest 22637 49819 17.0" 
$ns at 522.9817065410008 "$node_(130) setdest 78892 23356 1.0" 
$ns at 556.6268851639388 "$node_(130) setdest 28292 17578 6.0" 
$ns at 614.6658439183382 "$node_(130) setdest 12684 39812 16.0" 
$ns at 756.1707317300927 "$node_(130) setdest 204409 68317 4.0" 
$ns at 795.0455784625415 "$node_(130) setdest 9248 66777 16.0" 
$ns at 887.3914285758824 "$node_(130) setdest 240702 80296 18.0" 
$ns at 119.93243503648091 "$node_(131) setdest 72031 30149 12.0" 
$ns at 244.789438367289 "$node_(131) setdest 36581 15181 8.0" 
$ns at 335.9986965975693 "$node_(131) setdest 82036 8087 9.0" 
$ns at 430.323836411761 "$node_(131) setdest 107167 13635 17.0" 
$ns at 595.0137656217214 "$node_(131) setdest 191532 31723 7.0" 
$ns at 668.4915084081842 "$node_(131) setdest 145526 2368 12.0" 
$ns at 746.3136688651151 "$node_(131) setdest 15053 68354 3.0" 
$ns at 777.0194044635609 "$node_(131) setdest 249247 80528 7.0" 
$ns at 871.1482881716062 "$node_(131) setdest 58918 68255 6.0" 
$ns at 131.34100353732302 "$node_(132) setdest 16259 12405 6.0" 
$ns at 208.2048913641831 "$node_(132) setdest 22031 30554 11.0" 
$ns at 277.592677021809 "$node_(132) setdest 45630 51611 1.0" 
$ns at 310.5316168004645 "$node_(132) setdest 84476 41073 10.0" 
$ns at 427.228857168354 "$node_(132) setdest 85616 16503 1.0" 
$ns at 459.06326530936104 "$node_(132) setdest 193915 20823 13.0" 
$ns at 599.2593591816922 "$node_(132) setdest 88176 72033 11.0" 
$ns at 688.3764076534484 "$node_(132) setdest 80249 63149 14.0" 
$ns at 801.8215184370397 "$node_(132) setdest 143640 62162 10.0" 
$ns at 245.74167433233487 "$node_(133) setdest 10446 10527 19.0" 
$ns at 300.99204998414325 "$node_(133) setdest 42265 31252 16.0" 
$ns at 357.69274203391825 "$node_(133) setdest 145598 10801 9.0" 
$ns at 392.50704600553854 "$node_(133) setdest 169644 38898 10.0" 
$ns at 492.3311194809801 "$node_(133) setdest 95610 24044 14.0" 
$ns at 603.9919579949726 "$node_(133) setdest 171926 71072 2.0" 
$ns at 652.6030703204278 "$node_(133) setdest 151452 70063 18.0" 
$ns at 688.3646769073663 "$node_(133) setdest 42619 15667 8.0" 
$ns at 721.8098586074367 "$node_(133) setdest 156705 23483 14.0" 
$ns at 825.1777439621231 "$node_(133) setdest 187723 76374 19.0" 
$ns at 128.31862901041796 "$node_(134) setdest 81143 24666 6.0" 
$ns at 212.6043516958106 "$node_(134) setdest 80442 38992 14.0" 
$ns at 312.754998108128 "$node_(134) setdest 73709 29528 6.0" 
$ns at 371.99824652576467 "$node_(134) setdest 180697 40400 12.0" 
$ns at 404.1138080170689 "$node_(134) setdest 111718 7768 6.0" 
$ns at 480.0299695319536 "$node_(134) setdest 188867 37616 4.0" 
$ns at 529.4482897105182 "$node_(134) setdest 3114 13450 19.0" 
$ns at 642.8069215586636 "$node_(134) setdest 78374 47001 14.0" 
$ns at 700.4762526092687 "$node_(134) setdest 144765 18640 6.0" 
$ns at 779.4202989999483 "$node_(134) setdest 149394 15732 13.0" 
$ns at 835.7506340258956 "$node_(134) setdest 255787 17744 9.0" 
$ns at 148.24559082993966 "$node_(135) setdest 27469 13927 10.0" 
$ns at 188.78928768728198 "$node_(135) setdest 111972 9063 3.0" 
$ns at 237.05575027221687 "$node_(135) setdest 86590 41758 15.0" 
$ns at 403.11682926823164 "$node_(135) setdest 176902 800 14.0" 
$ns at 508.0043160893677 "$node_(135) setdest 9495 52391 1.0" 
$ns at 542.9353462483431 "$node_(135) setdest 192422 43876 13.0" 
$ns at 590.8824215509035 "$node_(135) setdest 229622 18927 20.0" 
$ns at 745.5832575929196 "$node_(135) setdest 180100 15300 1.0" 
$ns at 776.1525344815688 "$node_(135) setdest 195762 59098 4.0" 
$ns at 817.0703613373664 "$node_(135) setdest 117086 12127 7.0" 
$ns at 866.0755470572607 "$node_(135) setdest 56608 10218 2.0" 
$ns at 134.86741426586707 "$node_(136) setdest 20867 20318 8.0" 
$ns at 194.46238315878355 "$node_(136) setdest 1251 3592 16.0" 
$ns at 327.0266431514863 "$node_(136) setdest 96257 41215 12.0" 
$ns at 414.04613370177015 "$node_(136) setdest 140732 11958 14.0" 
$ns at 551.6185054304852 "$node_(136) setdest 180795 11504 10.0" 
$ns at 633.4097042177175 "$node_(136) setdest 144628 23540 5.0" 
$ns at 688.1641043555582 "$node_(136) setdest 97054 65221 9.0" 
$ns at 757.6214340221554 "$node_(136) setdest 139827 85264 11.0" 
$ns at 812.6893595435344 "$node_(136) setdest 193086 11839 11.0" 
$ns at 151.22079231720863 "$node_(137) setdest 115516 33564 2.0" 
$ns at 193.30819290495168 "$node_(137) setdest 105289 38464 19.0" 
$ns at 256.97274728833315 "$node_(137) setdest 94404 16688 2.0" 
$ns at 305.008559144645 "$node_(137) setdest 61454 45651 4.0" 
$ns at 370.3878974557973 "$node_(137) setdest 92383 29111 4.0" 
$ns at 434.19254589101615 "$node_(137) setdest 11895 9987 11.0" 
$ns at 497.85896832610104 "$node_(137) setdest 15504 5983 18.0" 
$ns at 623.2450324931655 "$node_(137) setdest 185444 55666 9.0" 
$ns at 674.5083997472259 "$node_(137) setdest 64243 36556 17.0" 
$ns at 809.3405140192797 "$node_(137) setdest 237504 12705 12.0" 
$ns at 846.9251481535471 "$node_(137) setdest 83472 46061 1.0" 
$ns at 880.1950055498943 "$node_(137) setdest 59024 31405 2.0" 
$ns at 157.67722646100387 "$node_(138) setdest 69363 21929 19.0" 
$ns at 369.9612565637974 "$node_(138) setdest 115454 37602 8.0" 
$ns at 424.3506112764101 "$node_(138) setdest 151210 10315 17.0" 
$ns at 534.5509862377312 "$node_(138) setdest 67235 9179 13.0" 
$ns at 568.0135388762262 "$node_(138) setdest 65306 17727 13.0" 
$ns at 616.8000663133607 "$node_(138) setdest 160165 33958 13.0" 
$ns at 691.2979660097167 "$node_(138) setdest 67199 71132 4.0" 
$ns at 746.4745294424127 "$node_(138) setdest 125229 76454 1.0" 
$ns at 777.4864045163831 "$node_(138) setdest 71159 67898 1.0" 
$ns at 813.3169058799261 "$node_(138) setdest 65441 86017 5.0" 
$ns at 889.4836832495187 "$node_(138) setdest 151255 61086 19.0" 
$ns at 173.22390358128087 "$node_(139) setdest 123597 32787 19.0" 
$ns at 358.2890680219374 "$node_(139) setdest 54661 42522 6.0" 
$ns at 401.32423451303623 "$node_(139) setdest 117777 33300 12.0" 
$ns at 494.5965601611655 "$node_(139) setdest 78810 1163 5.0" 
$ns at 540.955422684134 "$node_(139) setdest 108301 4000 20.0" 
$ns at 735.3449544408505 "$node_(139) setdest 210964 49884 17.0" 
$ns at 796.2039558944975 "$node_(139) setdest 50026 25729 18.0" 
$ns at 878.4299767239235 "$node_(139) setdest 210592 38472 18.0" 
$ns at 172.38017568298199 "$node_(140) setdest 28409 9103 17.0" 
$ns at 226.92240829292808 "$node_(140) setdest 117252 22005 11.0" 
$ns at 307.0664077932755 "$node_(140) setdest 67361 44629 17.0" 
$ns at 343.3470588087399 "$node_(140) setdest 70708 39785 14.0" 
$ns at 437.3800949049577 "$node_(140) setdest 181631 31988 2.0" 
$ns at 479.2379165282225 "$node_(140) setdest 169061 10320 9.0" 
$ns at 528.0003561585514 "$node_(140) setdest 77908 38331 14.0" 
$ns at 629.4792404870598 "$node_(140) setdest 173152 36470 15.0" 
$ns at 792.0685849057326 "$node_(140) setdest 228200 49337 10.0" 
$ns at 177.03209728662924 "$node_(141) setdest 127003 28129 15.0" 
$ns at 312.7078348344446 "$node_(141) setdest 18117 25703 17.0" 
$ns at 462.5640647018216 "$node_(141) setdest 91773 58153 7.0" 
$ns at 554.2131704631815 "$node_(141) setdest 38255 47498 19.0" 
$ns at 638.8652822523391 "$node_(141) setdest 44379 65353 14.0" 
$ns at 695.8113969206659 "$node_(141) setdest 214963 28986 20.0" 
$ns at 826.082058772385 "$node_(141) setdest 243535 65092 13.0" 
$ns at 893.493617823694 "$node_(141) setdest 125209 7962 2.0" 
$ns at 115.56352275836089 "$node_(142) setdest 19107 31298 18.0" 
$ns at 225.16072731579456 "$node_(142) setdest 36323 2375 8.0" 
$ns at 319.6427025891894 "$node_(142) setdest 87176 5165 17.0" 
$ns at 407.8685270756931 "$node_(142) setdest 184167 44813 2.0" 
$ns at 439.4327717362056 "$node_(142) setdest 178940 5092 19.0" 
$ns at 592.0366107066216 "$node_(142) setdest 135544 20001 8.0" 
$ns at 697.2722113254069 "$node_(142) setdest 133746 47136 13.0" 
$ns at 753.92981893752 "$node_(142) setdest 186459 21803 1.0" 
$ns at 793.6732161843621 "$node_(142) setdest 92038 868 11.0" 
$ns at 846.57121200573 "$node_(142) setdest 40969 48229 1.0" 
$ns at 878.4349032050782 "$node_(142) setdest 168181 34399 18.0" 
$ns at 186.02630044151556 "$node_(143) setdest 23554 38260 10.0" 
$ns at 281.2670562808295 "$node_(143) setdest 26597 50975 5.0" 
$ns at 337.31832737658965 "$node_(143) setdest 152988 47736 18.0" 
$ns at 478.1935842667847 "$node_(143) setdest 49458 7342 5.0" 
$ns at 533.4664667286316 "$node_(143) setdest 37940 55897 11.0" 
$ns at 643.7267658288712 "$node_(143) setdest 177803 33892 7.0" 
$ns at 711.1919627759291 "$node_(143) setdest 244011 1535 6.0" 
$ns at 768.5881304044871 "$node_(143) setdest 8096 33932 17.0" 
$ns at 818.0851583192015 "$node_(143) setdest 154950 703 8.0" 
$ns at 133.44846780695266 "$node_(144) setdest 43515 8292 8.0" 
$ns at 198.69609774092626 "$node_(144) setdest 54728 7390 12.0" 
$ns at 278.20053443330073 "$node_(144) setdest 12539 24278 11.0" 
$ns at 373.1411563241557 "$node_(144) setdest 101754 39683 9.0" 
$ns at 463.12212661989815 "$node_(144) setdest 147268 35095 4.0" 
$ns at 527.8645049441722 "$node_(144) setdest 156474 55483 15.0" 
$ns at 630.3687332119739 "$node_(144) setdest 170884 61345 14.0" 
$ns at 708.2159651223021 "$node_(144) setdest 107012 82749 17.0" 
$ns at 837.0449669621034 "$node_(144) setdest 153639 552 1.0" 
$ns at 873.2002147444073 "$node_(144) setdest 67084 51876 9.0" 
$ns at 157.40154898157934 "$node_(145) setdest 93570 26057 5.0" 
$ns at 214.37542016868684 "$node_(145) setdest 67809 33172 14.0" 
$ns at 287.34065193372106 "$node_(145) setdest 118425 4487 4.0" 
$ns at 327.7166081720984 "$node_(145) setdest 64601 19388 15.0" 
$ns at 450.8514133487668 "$node_(145) setdest 20930 28360 1.0" 
$ns at 481.78596881587083 "$node_(145) setdest 80140 47976 7.0" 
$ns at 579.3460861722192 "$node_(145) setdest 144079 8496 5.0" 
$ns at 653.3352987250304 "$node_(145) setdest 208784 52085 2.0" 
$ns at 698.6846715962379 "$node_(145) setdest 236328 72880 17.0" 
$ns at 885.7800604642889 "$node_(145) setdest 44837 63996 16.0" 
$ns at 153.2571778887236 "$node_(146) setdest 72889 4512 12.0" 
$ns at 210.90878677365612 "$node_(146) setdest 105538 14259 18.0" 
$ns at 351.5510980447449 "$node_(146) setdest 168414 15847 1.0" 
$ns at 389.2069807504094 "$node_(146) setdest 132123 26096 15.0" 
$ns at 521.1671708968913 "$node_(146) setdest 118386 18671 18.0" 
$ns at 710.9170649618891 "$node_(146) setdest 226002 86 16.0" 
$ns at 752.5633368822466 "$node_(146) setdest 62233 77507 18.0" 
$ns at 116.62180110965754 "$node_(147) setdest 80800 14820 13.0" 
$ns at 268.7561854991013 "$node_(147) setdest 19203 52081 5.0" 
$ns at 301.8757260666077 "$node_(147) setdest 116781 49360 8.0" 
$ns at 376.7772240938898 "$node_(147) setdest 3383 22331 15.0" 
$ns at 536.6584646984335 "$node_(147) setdest 2094 48695 3.0" 
$ns at 591.153373026777 "$node_(147) setdest 174212 12114 18.0" 
$ns at 689.6481259292499 "$node_(147) setdest 117549 81480 13.0" 
$ns at 827.5394898974106 "$node_(147) setdest 260767 34841 14.0" 
$ns at 154.1368622505545 "$node_(148) setdest 60626 26136 3.0" 
$ns at 214.0433851935153 "$node_(148) setdest 38236 23315 6.0" 
$ns at 273.19185572115947 "$node_(148) setdest 122720 24824 4.0" 
$ns at 340.2973742753741 "$node_(148) setdest 31215 53605 3.0" 
$ns at 385.23971478026976 "$node_(148) setdest 114599 46531 1.0" 
$ns at 423.6051137437046 "$node_(148) setdest 108506 43578 17.0" 
$ns at 574.8903563903807 "$node_(148) setdest 13587 42285 3.0" 
$ns at 620.7749318042783 "$node_(148) setdest 95824 53990 20.0" 
$ns at 759.2379379314905 "$node_(148) setdest 232218 38294 9.0" 
$ns at 824.5855727249665 "$node_(148) setdest 100343 36025 4.0" 
$ns at 878.0163706700187 "$node_(148) setdest 231035 51646 6.0" 
$ns at 174.0508525824104 "$node_(149) setdest 72856 6387 1.0" 
$ns at 211.3654764094444 "$node_(149) setdest 27908 22615 11.0" 
$ns at 346.43121109244726 "$node_(149) setdest 53906 33005 16.0" 
$ns at 491.97562487154767 "$node_(149) setdest 111931 45820 3.0" 
$ns at 535.3898780059759 "$node_(149) setdest 40788 31763 2.0" 
$ns at 578.6518259347936 "$node_(149) setdest 31037 55804 7.0" 
$ns at 661.17161405633 "$node_(149) setdest 163868 56257 2.0" 
$ns at 696.8348828328922 "$node_(149) setdest 134766 22642 3.0" 
$ns at 751.5647794095644 "$node_(149) setdest 79719 69661 1.0" 
$ns at 787.0265999540849 "$node_(149) setdest 106931 29882 2.0" 
$ns at 817.4096895075779 "$node_(149) setdest 84825 30082 14.0" 
$ns at 102.82775895264685 "$node_(150) setdest 48439 18666 11.0" 
$ns at 241.87926177388414 "$node_(150) setdest 54266 21324 17.0" 
$ns at 313.7920861145848 "$node_(150) setdest 97141 35434 15.0" 
$ns at 475.7547099332793 "$node_(150) setdest 134921 18506 15.0" 
$ns at 569.4658861530514 "$node_(150) setdest 54517 22315 11.0" 
$ns at 672.0838154344127 "$node_(150) setdest 120427 81627 12.0" 
$ns at 738.8732646239854 "$node_(150) setdest 215217 29179 13.0" 
$ns at 813.4908968898461 "$node_(150) setdest 217301 62748 7.0" 
$ns at 887.8556496838023 "$node_(150) setdest 4132 7884 10.0" 
$ns at 131.0308866991242 "$node_(151) setdest 30992 816 14.0" 
$ns at 161.9537667617036 "$node_(151) setdest 38397 17645 12.0" 
$ns at 258.695830194908 "$node_(151) setdest 109801 5826 5.0" 
$ns at 317.89278766348616 "$node_(151) setdest 67207 52397 19.0" 
$ns at 396.6085823451799 "$node_(151) setdest 84540 46242 1.0" 
$ns at 436.60376776764247 "$node_(151) setdest 9823 45600 7.0" 
$ns at 500.60435704336885 "$node_(151) setdest 165039 56751 4.0" 
$ns at 565.2659748173857 "$node_(151) setdest 200011 72894 17.0" 
$ns at 722.5577477903962 "$node_(151) setdest 38384 71635 10.0" 
$ns at 764.5750018104039 "$node_(151) setdest 125402 33578 4.0" 
$ns at 816.3673296864034 "$node_(151) setdest 193454 61795 1.0" 
$ns at 851.0565551477987 "$node_(151) setdest 113558 30153 4.0" 
$ns at 897.2441736318416 "$node_(151) setdest 230634 18706 9.0" 
$ns at 115.03363504006128 "$node_(152) setdest 54659 5535 15.0" 
$ns at 181.26223511501178 "$node_(152) setdest 88270 4268 5.0" 
$ns at 251.5379163087264 "$node_(152) setdest 86270 6649 14.0" 
$ns at 291.1133790677313 "$node_(152) setdest 70037 16977 19.0" 
$ns at 436.1053728475837 "$node_(152) setdest 167232 190 6.0" 
$ns at 514.7795473369404 "$node_(152) setdest 169746 25894 16.0" 
$ns at 630.020029488358 "$node_(152) setdest 40354 8237 18.0" 
$ns at 767.5682400778094 "$node_(152) setdest 235986 51890 1.0" 
$ns at 797.755444427578 "$node_(152) setdest 45774 87778 12.0" 
$ns at 881.6715626694779 "$node_(152) setdest 27191 60225 14.0" 
$ns at 101.1448291443004 "$node_(153) setdest 92939 8122 4.0" 
$ns at 155.64667540620326 "$node_(153) setdest 71603 2635 16.0" 
$ns at 332.5536274256416 "$node_(153) setdest 126294 23661 19.0" 
$ns at 455.9886721515112 "$node_(153) setdest 169088 36047 8.0" 
$ns at 539.4550614673819 "$node_(153) setdest 134238 43903 10.0" 
$ns at 573.9310721714731 "$node_(153) setdest 141321 56612 4.0" 
$ns at 641.7414612582255 "$node_(153) setdest 36363 76671 6.0" 
$ns at 697.6449755508762 "$node_(153) setdest 227198 54577 18.0" 
$ns at 871.0126042807685 "$node_(153) setdest 73264 7088 8.0" 
$ns at 114.47953910482977 "$node_(154) setdest 94504 24207 15.0" 
$ns at 223.85141343737416 "$node_(154) setdest 26018 37223 8.0" 
$ns at 266.66697426210334 "$node_(154) setdest 3116 10699 7.0" 
$ns at 359.55057695902093 "$node_(154) setdest 49145 1352 4.0" 
$ns at 408.84403215049207 "$node_(154) setdest 23522 3955 7.0" 
$ns at 483.12501900102166 "$node_(154) setdest 11754 70603 16.0" 
$ns at 635.4948443034916 "$node_(154) setdest 42173 52946 4.0" 
$ns at 684.271107697114 "$node_(154) setdest 43972 23052 9.0" 
$ns at 715.4533386084728 "$node_(154) setdest 185656 53064 4.0" 
$ns at 779.8221124765321 "$node_(154) setdest 17867 62186 11.0" 
$ns at 848.0252536232977 "$node_(154) setdest 105065 66909 9.0" 
$ns at 898.4168945441445 "$node_(154) setdest 55153 60599 18.0" 
$ns at 143.81765712904783 "$node_(155) setdest 32659 18283 7.0" 
$ns at 178.09285652642848 "$node_(155) setdest 119351 16155 1.0" 
$ns at 209.09909183046796 "$node_(155) setdest 22637 1066 17.0" 
$ns at 253.38564938854245 "$node_(155) setdest 124366 31416 17.0" 
$ns at 329.66613590876034 "$node_(155) setdest 155654 18402 7.0" 
$ns at 411.9566558435332 "$node_(155) setdest 97754 51469 3.0" 
$ns at 441.96967315061187 "$node_(155) setdest 426 25753 11.0" 
$ns at 524.4682290735414 "$node_(155) setdest 110772 302 7.0" 
$ns at 598.2003886155817 "$node_(155) setdest 20132 49836 10.0" 
$ns at 630.7153826110557 "$node_(155) setdest 23672 42401 13.0" 
$ns at 740.3650264548714 "$node_(155) setdest 250494 69863 12.0" 
$ns at 867.545841901042 "$node_(155) setdest 246161 11232 1.0" 
$ns at 115.2747667120397 "$node_(156) setdest 16352 17994 11.0" 
$ns at 155.84862928978765 "$node_(156) setdest 129269 2469 6.0" 
$ns at 191.66733947122424 "$node_(156) setdest 13193 34853 8.0" 
$ns at 258.1745177805185 "$node_(156) setdest 11544 24619 11.0" 
$ns at 361.9923738376385 "$node_(156) setdest 82553 59928 4.0" 
$ns at 398.80458908993666 "$node_(156) setdest 153517 5604 20.0" 
$ns at 605.856134935533 "$node_(156) setdest 200106 42949 12.0" 
$ns at 728.1140190869033 "$node_(156) setdest 112755 16588 6.0" 
$ns at 804.5297253587694 "$node_(156) setdest 155902 79796 8.0" 
$ns at 842.443575870099 "$node_(156) setdest 16265 86648 4.0" 
$ns at 881.4519845399495 "$node_(156) setdest 141407 8413 10.0" 
$ns at 131.58939519533408 "$node_(157) setdest 83629 28872 11.0" 
$ns at 169.03049009375638 "$node_(157) setdest 107077 8430 2.0" 
$ns at 212.29876510796066 "$node_(157) setdest 117807 32843 17.0" 
$ns at 254.05666008104754 "$node_(157) setdest 41467 2537 9.0" 
$ns at 346.9856259745663 "$node_(157) setdest 14301 30876 9.0" 
$ns at 418.06909396433286 "$node_(157) setdest 98713 22376 15.0" 
$ns at 561.186895956077 "$node_(157) setdest 149613 75604 17.0" 
$ns at 741.1634760987225 "$node_(157) setdest 83421 18495 8.0" 
$ns at 824.1259100697025 "$node_(157) setdest 33891 23798 18.0" 
$ns at 158.56587572456178 "$node_(158) setdest 33478 11763 16.0" 
$ns at 297.2114046769368 "$node_(158) setdest 17522 39248 10.0" 
$ns at 415.42825309362155 "$node_(158) setdest 127753 55752 8.0" 
$ns at 513.8185409611158 "$node_(158) setdest 179936 52186 14.0" 
$ns at 660.1211644019795 "$node_(158) setdest 22571 72735 8.0" 
$ns at 710.0244773051268 "$node_(158) setdest 28811 31392 18.0" 
$ns at 852.6144839910118 "$node_(158) setdest 250962 71822 5.0" 
$ns at 124.75885038062734 "$node_(159) setdest 30234 16953 5.0" 
$ns at 155.17724813434603 "$node_(159) setdest 7158 24362 18.0" 
$ns at 236.8814903049693 "$node_(159) setdest 14509 44301 1.0" 
$ns at 270.1284443195749 "$node_(159) setdest 101738 39000 15.0" 
$ns at 449.3763020861403 "$node_(159) setdest 165063 30372 6.0" 
$ns at 525.9734711896521 "$node_(159) setdest 209543 23328 12.0" 
$ns at 615.6846229987699 "$node_(159) setdest 115753 24120 6.0" 
$ns at 704.5220412212384 "$node_(159) setdest 73853 43257 5.0" 
$ns at 747.1867372622792 "$node_(159) setdest 26894 17594 11.0" 
$ns at 809.0664316641889 "$node_(159) setdest 200000 68382 16.0" 
$ns at 194.6111667500183 "$node_(160) setdest 44034 19690 2.0" 
$ns at 226.82568024407226 "$node_(160) setdest 75109 11961 1.0" 
$ns at 257.37886106384536 "$node_(160) setdest 118990 51523 13.0" 
$ns at 319.3580873343882 "$node_(160) setdest 83278 27585 10.0" 
$ns at 371.34893175766433 "$node_(160) setdest 2060 38185 13.0" 
$ns at 505.15024213164816 "$node_(160) setdest 53756 9204 2.0" 
$ns at 538.288460980212 "$node_(160) setdest 208804 52776 14.0" 
$ns at 671.3498143174834 "$node_(160) setdest 72464 60714 6.0" 
$ns at 720.8532340361226 "$node_(160) setdest 45863 36744 9.0" 
$ns at 787.892765100027 "$node_(160) setdest 218628 62166 2.0" 
$ns at 819.4517463231986 "$node_(160) setdest 253421 78930 13.0" 
$ns at 888.2939601193569 "$node_(160) setdest 23282 47862 19.0" 
$ns at 188.5312137860157 "$node_(161) setdest 516 3883 1.0" 
$ns at 223.54363300435773 "$node_(161) setdest 71401 23836 7.0" 
$ns at 297.8956103439293 "$node_(161) setdest 60294 38711 8.0" 
$ns at 383.13528268855634 "$node_(161) setdest 55968 4302 6.0" 
$ns at 413.7510114594525 "$node_(161) setdest 112040 4131 15.0" 
$ns at 569.0760674479461 "$node_(161) setdest 210616 44991 19.0" 
$ns at 627.0569866291161 "$node_(161) setdest 189306 47146 13.0" 
$ns at 777.3411151532612 "$node_(161) setdest 170780 21147 17.0" 
$ns at 113.55220247196083 "$node_(162) setdest 22452 8097 14.0" 
$ns at 251.84423302142142 "$node_(162) setdest 32018 1260 1.0" 
$ns at 285.2458924038745 "$node_(162) setdest 83431 19914 9.0" 
$ns at 391.36104391865285 "$node_(162) setdest 89077 34392 1.0" 
$ns at 431.22169062784724 "$node_(162) setdest 84099 40449 17.0" 
$ns at 486.4613759968938 "$node_(162) setdest 173969 48889 5.0" 
$ns at 554.4664010994762 "$node_(162) setdest 35958 40356 2.0" 
$ns at 593.0824856039641 "$node_(162) setdest 35835 44426 8.0" 
$ns at 680.7768367527786 "$node_(162) setdest 9109 78247 15.0" 
$ns at 782.950305789017 "$node_(162) setdest 72815 32972 19.0" 
$ns at 855.6626383844489 "$node_(162) setdest 234771 72112 14.0" 
$ns at 198.76331326984695 "$node_(163) setdest 97746 17798 12.0" 
$ns at 327.6462973756084 "$node_(163) setdest 145129 45239 15.0" 
$ns at 367.315640581927 "$node_(163) setdest 78389 14863 19.0" 
$ns at 552.2550317411597 "$node_(163) setdest 209923 46025 8.0" 
$ns at 646.4432502432139 "$node_(163) setdest 11699 53684 7.0" 
$ns at 729.5358555640878 "$node_(163) setdest 143910 80865 17.0" 
$ns at 888.3731513974769 "$node_(163) setdest 41746 43475 3.0" 
$ns at 111.57319547549629 "$node_(164) setdest 42885 6531 10.0" 
$ns at 228.95435608277225 "$node_(164) setdest 102084 15155 14.0" 
$ns at 328.47087747129126 "$node_(164) setdest 80029 25678 10.0" 
$ns at 455.08547764420643 "$node_(164) setdest 159523 40659 19.0" 
$ns at 542.4808297866294 "$node_(164) setdest 106472 44504 10.0" 
$ns at 575.7743218782159 "$node_(164) setdest 94010 74235 10.0" 
$ns at 608.2356821419362 "$node_(164) setdest 107380 16793 9.0" 
$ns at 713.0382401996036 "$node_(164) setdest 80388 27666 14.0" 
$ns at 780.3044817258376 "$node_(164) setdest 226873 26873 18.0" 
$ns at 146.76874425972846 "$node_(165) setdest 25455 16457 4.0" 
$ns at 213.77833510357067 "$node_(165) setdest 123042 23353 8.0" 
$ns at 280.9189698037286 "$node_(165) setdest 75384 49859 16.0" 
$ns at 321.972116309353 "$node_(165) setdest 45714 21243 1.0" 
$ns at 356.99399277550066 "$node_(165) setdest 148271 41692 19.0" 
$ns at 572.2848560329451 "$node_(165) setdest 34515 48761 9.0" 
$ns at 673.2920131091336 "$node_(165) setdest 91680 12544 8.0" 
$ns at 762.5789959563012 "$node_(165) setdest 28844 36317 19.0" 
$ns at 101.04434894783455 "$node_(166) setdest 63302 28342 8.0" 
$ns at 169.90846259433914 "$node_(166) setdest 80152 33991 2.0" 
$ns at 204.39845700932287 "$node_(166) setdest 54453 40783 1.0" 
$ns at 242.80682151880853 "$node_(166) setdest 38045 21523 4.0" 
$ns at 311.80394037090616 "$node_(166) setdest 118000 11439 9.0" 
$ns at 415.2812120957652 "$node_(166) setdest 151864 23555 18.0" 
$ns at 515.0823075415952 "$node_(166) setdest 153718 49396 18.0" 
$ns at 692.3389779371307 "$node_(166) setdest 171347 15733 3.0" 
$ns at 745.3530538249355 "$node_(166) setdest 181818 29244 15.0" 
$ns at 858.7008595606478 "$node_(166) setdest 49745 72389 9.0" 
$ns at 169.30326817572703 "$node_(167) setdest 77927 16097 5.0" 
$ns at 226.92748835169675 "$node_(167) setdest 88231 33005 19.0" 
$ns at 416.1151015489954 "$node_(167) setdest 187165 32176 13.0" 
$ns at 510.69335710683663 "$node_(167) setdest 79286 64660 4.0" 
$ns at 548.6351084700283 "$node_(167) setdest 80924 42155 8.0" 
$ns at 632.1038637687361 "$node_(167) setdest 204278 74852 12.0" 
$ns at 725.1061653705028 "$node_(167) setdest 31396 43150 8.0" 
$ns at 795.7812723551451 "$node_(167) setdest 95491 53977 1.0" 
$ns at 833.9355177558693 "$node_(167) setdest 28487 64419 9.0" 
$ns at 147.54326621741168 "$node_(168) setdest 78257 10196 13.0" 
$ns at 220.1710406658511 "$node_(168) setdest 131890 29017 19.0" 
$ns at 358.38820702103953 "$node_(168) setdest 5515 35849 2.0" 
$ns at 398.48363755888766 "$node_(168) setdest 146988 24263 11.0" 
$ns at 495.7861890819966 "$node_(168) setdest 4048 30934 5.0" 
$ns at 556.1219399993994 "$node_(168) setdest 6237 74287 12.0" 
$ns at 680.8921930556808 "$node_(168) setdest 40208 63666 13.0" 
$ns at 788.4536484459829 "$node_(168) setdest 121962 1136 1.0" 
$ns at 822.3668838982323 "$node_(168) setdest 105282 68943 10.0" 
$ns at 880.2157655609099 "$node_(168) setdest 67840 22439 1.0" 
$ns at 245.37311616838417 "$node_(169) setdest 97396 31152 12.0" 
$ns at 336.3222754759083 "$node_(169) setdest 10953 52972 4.0" 
$ns at 403.3210272789799 "$node_(169) setdest 171597 57734 12.0" 
$ns at 517.4364753776767 "$node_(169) setdest 69994 67473 5.0" 
$ns at 579.0198885381282 "$node_(169) setdest 67509 44083 6.0" 
$ns at 634.4821665098189 "$node_(169) setdest 76673 13178 14.0" 
$ns at 766.9655316586719 "$node_(169) setdest 19595 37357 2.0" 
$ns at 797.2348678482922 "$node_(169) setdest 38920 87043 15.0" 
$ns at 166.4953206773925 "$node_(170) setdest 120144 15804 1.0" 
$ns at 197.6503058049015 "$node_(170) setdest 85708 11932 13.0" 
$ns at 250.84469476228986 "$node_(170) setdest 159677 20004 9.0" 
$ns at 346.65855997543224 "$node_(170) setdest 9050 40693 2.0" 
$ns at 396.4139303069902 "$node_(170) setdest 136223 57967 7.0" 
$ns at 464.70214035032836 "$node_(170) setdest 99308 63812 12.0" 
$ns at 516.645141398348 "$node_(170) setdest 52721 28264 1.0" 
$ns at 547.3198998448363 "$node_(170) setdest 121146 51217 3.0" 
$ns at 594.5119111390221 "$node_(170) setdest 130730 38008 4.0" 
$ns at 643.5234617892982 "$node_(170) setdest 3678 22533 4.0" 
$ns at 692.0337192303231 "$node_(170) setdest 189864 65525 13.0" 
$ns at 767.1873191981239 "$node_(170) setdest 135918 59765 5.0" 
$ns at 810.4437730124871 "$node_(170) setdest 256490 562 11.0" 
$ns at 891.0294200783046 "$node_(170) setdest 250846 18564 18.0" 
$ns at 226.6740563227726 "$node_(171) setdest 74837 17104 15.0" 
$ns at 348.36404788796756 "$node_(171) setdest 19417 28488 1.0" 
$ns at 386.02081372649644 "$node_(171) setdest 135215 19652 10.0" 
$ns at 460.4228523122012 "$node_(171) setdest 166830 3606 5.0" 
$ns at 517.6916627389155 "$node_(171) setdest 19403 38950 17.0" 
$ns at 657.302795167032 "$node_(171) setdest 149195 10348 3.0" 
$ns at 703.1644322774034 "$node_(171) setdest 31584 30785 19.0" 
$ns at 771.5261058963818 "$node_(171) setdest 162188 63869 17.0" 
$ns at 816.5726227489168 "$node_(171) setdest 19826 50211 18.0" 
$ns at 132.5185438621542 "$node_(172) setdest 5392 22039 11.0" 
$ns at 261.3114506303126 "$node_(172) setdest 139228 14806 2.0" 
$ns at 307.8396640914316 "$node_(172) setdest 11971 53683 10.0" 
$ns at 356.3305501578827 "$node_(172) setdest 104434 15489 19.0" 
$ns at 503.80777888426013 "$node_(172) setdest 13563 146 18.0" 
$ns at 651.2531701852113 "$node_(172) setdest 103271 9213 14.0" 
$ns at 742.1316719173542 "$node_(172) setdest 208949 39586 14.0" 
$ns at 864.212378255487 "$node_(172) setdest 48400 3660 19.0" 
$ns at 124.3372369644506 "$node_(173) setdest 63715 1793 11.0" 
$ns at 204.7314262836024 "$node_(173) setdest 8560 30346 19.0" 
$ns at 276.1345602636167 "$node_(173) setdest 52817 686 1.0" 
$ns at 306.3282102639807 "$node_(173) setdest 130853 54041 19.0" 
$ns at 339.86282393048145 "$node_(173) setdest 22093 1824 17.0" 
$ns at 407.0963562556736 "$node_(173) setdest 187085 1729 15.0" 
$ns at 487.867842732616 "$node_(173) setdest 102600 1108 17.0" 
$ns at 649.3829170660813 "$node_(173) setdest 140428 65607 11.0" 
$ns at 724.4062578965111 "$node_(173) setdest 179756 57756 16.0" 
$ns at 871.0594490818846 "$node_(173) setdest 121373 19449 9.0" 
$ns at 212.9447495559483 "$node_(174) setdest 32077 30595 5.0" 
$ns at 286.0648798235392 "$node_(174) setdest 10060 11848 17.0" 
$ns at 480.3163304349068 "$node_(174) setdest 18878 66945 12.0" 
$ns at 522.4255450663142 "$node_(174) setdest 25860 69105 3.0" 
$ns at 568.9392602340881 "$node_(174) setdest 35932 48904 14.0" 
$ns at 602.8029703103042 "$node_(174) setdest 99539 18376 8.0" 
$ns at 706.9954021071392 "$node_(174) setdest 50895 38141 17.0" 
$ns at 865.6487553028094 "$node_(174) setdest 239477 56568 16.0" 
$ns at 157.2942903245131 "$node_(175) setdest 21639 21466 4.0" 
$ns at 195.67481876360108 "$node_(175) setdest 54320 44513 11.0" 
$ns at 264.60400118585255 "$node_(175) setdest 152392 26248 15.0" 
$ns at 403.32269493359667 "$node_(175) setdest 77118 41114 16.0" 
$ns at 448.0750877642806 "$node_(175) setdest 73067 44494 16.0" 
$ns at 585.7095594674133 "$node_(175) setdest 156690 67189 2.0" 
$ns at 618.9875103126269 "$node_(175) setdest 125096 9350 1.0" 
$ns at 654.7582575195149 "$node_(175) setdest 117716 81600 12.0" 
$ns at 780.406335765712 "$node_(175) setdest 85494 11674 8.0" 
$ns at 813.3476934447223 "$node_(175) setdest 49634 56160 6.0" 
$ns at 110.26169220631049 "$node_(176) setdest 43733 12431 1.0" 
$ns at 147.05860892055387 "$node_(176) setdest 38099 5830 5.0" 
$ns at 204.74513098945368 "$node_(176) setdest 28362 2085 15.0" 
$ns at 300.9318809733463 "$node_(176) setdest 79784 42457 17.0" 
$ns at 384.2730281114881 "$node_(176) setdest 172693 27545 20.0" 
$ns at 562.639817620293 "$node_(176) setdest 109818 43196 17.0" 
$ns at 647.9353283801453 "$node_(176) setdest 164911 1919 10.0" 
$ns at 710.6482876229992 "$node_(176) setdest 129778 35310 18.0" 
$ns at 815.4205694247547 "$node_(176) setdest 60697 43818 14.0" 
$ns at 862.8785745301176 "$node_(176) setdest 133507 10121 10.0" 
$ns at 144.20283009294428 "$node_(177) setdest 33147 3685 15.0" 
$ns at 279.5287560652297 "$node_(177) setdest 94019 6811 9.0" 
$ns at 394.2553374469756 "$node_(177) setdest 67654 31221 15.0" 
$ns at 568.4476446629996 "$node_(177) setdest 29566 70424 20.0" 
$ns at 628.3018941070691 "$node_(177) setdest 32109 23332 7.0" 
$ns at 702.9562118927666 "$node_(177) setdest 238137 30107 2.0" 
$ns at 750.3322737121083 "$node_(177) setdest 218914 45429 18.0" 
$ns at 875.1675228007109 "$node_(177) setdest 29931 20005 4.0" 
$ns at 138.0003323409374 "$node_(178) setdest 67806 28995 20.0" 
$ns at 270.7212301577225 "$node_(178) setdest 37730 46485 11.0" 
$ns at 317.90233884135824 "$node_(178) setdest 156929 30963 11.0" 
$ns at 449.36947947681404 "$node_(178) setdest 187675 44304 11.0" 
$ns at 519.1811933123307 "$node_(178) setdest 128336 43160 14.0" 
$ns at 669.5741652955953 "$node_(178) setdest 183506 68198 14.0" 
$ns at 765.219113659797 "$node_(178) setdest 61273 75533 1.0" 
$ns at 795.3254014158904 "$node_(178) setdest 37588 85234 13.0" 
$ns at 154.24442234332685 "$node_(179) setdest 37250 18877 9.0" 
$ns at 239.43944850652176 "$node_(179) setdest 129477 7820 13.0" 
$ns at 317.50630279828727 "$node_(179) setdest 151401 22802 8.0" 
$ns at 423.1015791102518 "$node_(179) setdest 153881 60051 16.0" 
$ns at 516.6765704155999 "$node_(179) setdest 84194 10377 2.0" 
$ns at 558.7791620076339 "$node_(179) setdest 115902 50811 11.0" 
$ns at 656.3798690136955 "$node_(179) setdest 215758 21481 2.0" 
$ns at 697.1729639692768 "$node_(179) setdest 80475 26360 6.0" 
$ns at 773.4941657272943 "$node_(179) setdest 62759 22984 1.0" 
$ns at 809.1041861592578 "$node_(179) setdest 60604 32461 1.0" 
$ns at 846.4333250511818 "$node_(179) setdest 71410 86756 19.0" 
$ns at 102.81814871637462 "$node_(180) setdest 75348 1362 9.0" 
$ns at 162.3274933990557 "$node_(180) setdest 56760 12085 1.0" 
$ns at 201.99931163586584 "$node_(180) setdest 32001 13694 18.0" 
$ns at 294.6458137502476 "$node_(180) setdest 19021 38600 13.0" 
$ns at 454.18561879459986 "$node_(180) setdest 46177 1393 12.0" 
$ns at 529.7038726204177 "$node_(180) setdest 67792 57384 8.0" 
$ns at 589.3002921080854 "$node_(180) setdest 33777 58441 20.0" 
$ns at 789.8663833508683 "$node_(180) setdest 46081 56974 8.0" 
$ns at 886.7644080852361 "$node_(180) setdest 111633 71803 7.0" 
$ns at 162.05171054078397 "$node_(181) setdest 22432 39150 4.0" 
$ns at 195.59984905398687 "$node_(181) setdest 91389 40553 18.0" 
$ns at 380.68860161321953 "$node_(181) setdest 18581 5218 10.0" 
$ns at 463.1328216092352 "$node_(181) setdest 104831 62293 20.0" 
$ns at 557.6250672663274 "$node_(181) setdest 131712 72864 6.0" 
$ns at 598.576072724067 "$node_(181) setdest 132180 29087 14.0" 
$ns at 665.5819912319133 "$node_(181) setdest 209063 80066 16.0" 
$ns at 824.6958086262437 "$node_(181) setdest 23579 9222 18.0" 
$ns at 119.78260083304068 "$node_(182) setdest 32467 19875 10.0" 
$ns at 234.23841148233922 "$node_(182) setdest 54491 22590 12.0" 
$ns at 316.50508198118285 "$node_(182) setdest 109955 52545 2.0" 
$ns at 357.1555127954755 "$node_(182) setdest 16000 20655 16.0" 
$ns at 422.7216361582603 "$node_(182) setdest 90149 24484 3.0" 
$ns at 465.36938281337785 "$node_(182) setdest 168309 56024 2.0" 
$ns at 506.7474541806081 "$node_(182) setdest 61877 4926 3.0" 
$ns at 565.2309367296117 "$node_(182) setdest 30052 12754 20.0" 
$ns at 710.8549283943789 "$node_(182) setdest 194087 21913 4.0" 
$ns at 768.0250323743197 "$node_(182) setdest 13627 28856 9.0" 
$ns at 827.0732567298929 "$node_(182) setdest 232160 33286 10.0" 
$ns at 214.08898577822947 "$node_(183) setdest 129716 29418 12.0" 
$ns at 249.57454764603932 "$node_(183) setdest 4665 16729 5.0" 
$ns at 323.5783439074204 "$node_(183) setdest 97995 15046 9.0" 
$ns at 375.4513963715624 "$node_(183) setdest 59067 8179 4.0" 
$ns at 430.50699370352896 "$node_(183) setdest 30352 33916 19.0" 
$ns at 638.6052737572425 "$node_(183) setdest 176064 68799 14.0" 
$ns at 731.599791433449 "$node_(183) setdest 62280 61374 6.0" 
$ns at 798.0818948663864 "$node_(183) setdest 211074 86419 16.0" 
$ns at 855.7562267802039 "$node_(183) setdest 174567 66950 13.0" 
$ns at 887.1764537490889 "$node_(183) setdest 188024 40617 9.0" 
$ns at 231.55358461982775 "$node_(184) setdest 99883 25134 6.0" 
$ns at 317.69392355577526 "$node_(184) setdest 119454 4757 6.0" 
$ns at 352.24474505306 "$node_(184) setdest 3772 45618 19.0" 
$ns at 384.72953096811074 "$node_(184) setdest 12957 23608 19.0" 
$ns at 569.0489497322967 "$node_(184) setdest 140662 57905 6.0" 
$ns at 639.4719357323149 "$node_(184) setdest 150847 28695 18.0" 
$ns at 692.495307289067 "$node_(184) setdest 111125 69433 8.0" 
$ns at 745.5837112751368 "$node_(184) setdest 250609 13280 10.0" 
$ns at 784.8870046095694 "$node_(184) setdest 218207 57081 5.0" 
$ns at 821.4519599563614 "$node_(184) setdest 235938 49463 3.0" 
$ns at 874.0094002097181 "$node_(184) setdest 89028 52878 18.0" 
$ns at 144.59229572305097 "$node_(185) setdest 32606 14798 13.0" 
$ns at 203.13864565823746 "$node_(185) setdest 128852 44493 7.0" 
$ns at 281.977885151024 "$node_(185) setdest 103748 33249 6.0" 
$ns at 325.18129810405344 "$node_(185) setdest 129180 24546 6.0" 
$ns at 386.090576789983 "$node_(185) setdest 186545 33069 7.0" 
$ns at 460.54716307106946 "$node_(185) setdest 18004 17879 5.0" 
$ns at 505.8305508186427 "$node_(185) setdest 153644 59574 12.0" 
$ns at 628.1430302459183 "$node_(185) setdest 21053 56710 17.0" 
$ns at 741.5511333749466 "$node_(185) setdest 38149 37830 13.0" 
$ns at 831.3097763626658 "$node_(185) setdest 48620 12085 1.0" 
$ns at 867.2724031583408 "$node_(185) setdest 228732 70635 18.0" 
$ns at 137.18869840510604 "$node_(186) setdest 41180 23010 2.0" 
$ns at 168.63601655846628 "$node_(186) setdest 11698 15627 20.0" 
$ns at 385.0285420026868 "$node_(186) setdest 53671 37026 1.0" 
$ns at 419.4751535148572 "$node_(186) setdest 155444 57707 7.0" 
$ns at 469.6697914259056 "$node_(186) setdest 6305 46712 16.0" 
$ns at 590.9450906197416 "$node_(186) setdest 19827 4747 17.0" 
$ns at 636.5156960874074 "$node_(186) setdest 166789 55817 12.0" 
$ns at 728.2707866450344 "$node_(186) setdest 190320 79853 8.0" 
$ns at 776.4703414586054 "$node_(186) setdest 136984 21172 7.0" 
$ns at 830.3173948659808 "$node_(186) setdest 67950 65926 6.0" 
$ns at 878.8414188333179 "$node_(186) setdest 27732 49539 9.0" 
$ns at 191.30029191798374 "$node_(187) setdest 40975 741 15.0" 
$ns at 355.72817214571114 "$node_(187) setdest 135085 11130 19.0" 
$ns at 543.8693160645025 "$node_(187) setdest 26387 64665 8.0" 
$ns at 589.234148510291 "$node_(187) setdest 29461 69033 14.0" 
$ns at 757.5497550864187 "$node_(187) setdest 251200 32298 8.0" 
$ns at 798.1414288405382 "$node_(187) setdest 151051 41307 11.0" 
$ns at 140.30601614384406 "$node_(188) setdest 37885 13629 7.0" 
$ns at 185.3865326697986 "$node_(188) setdest 128069 15313 16.0" 
$ns at 245.58321109064917 "$node_(188) setdest 100187 17148 4.0" 
$ns at 313.9118107859914 "$node_(188) setdest 137079 15824 4.0" 
$ns at 382.24910316002155 "$node_(188) setdest 42506 9046 7.0" 
$ns at 464.07013755570324 "$node_(188) setdest 95370 13491 7.0" 
$ns at 500.92107070568005 "$node_(188) setdest 169830 14300 7.0" 
$ns at 581.8005489248419 "$node_(188) setdest 169491 27899 8.0" 
$ns at 636.2352659947577 "$node_(188) setdest 163925 45215 19.0" 
$ns at 791.3479416535315 "$node_(188) setdest 51812 4359 3.0" 
$ns at 846.6340906628299 "$node_(188) setdest 130676 37677 12.0" 
$ns at 177.671068906496 "$node_(189) setdest 51195 11270 10.0" 
$ns at 245.81420013249272 "$node_(189) setdest 114056 12414 1.0" 
$ns at 276.7578567033771 "$node_(189) setdest 156175 31656 6.0" 
$ns at 320.6836005879668 "$node_(189) setdest 46248 28773 2.0" 
$ns at 355.00195539682954 "$node_(189) setdest 101043 8722 2.0" 
$ns at 388.18226758175274 "$node_(189) setdest 63440 15335 3.0" 
$ns at 424.23812420910974 "$node_(189) setdest 102441 31297 13.0" 
$ns at 485.88487637463345 "$node_(189) setdest 76352 11827 18.0" 
$ns at 635.20659515302 "$node_(189) setdest 12762 25918 8.0" 
$ns at 719.4547859797067 "$node_(189) setdest 205990 60391 1.0" 
$ns at 753.9084102082008 "$node_(189) setdest 25494 946 6.0" 
$ns at 836.055604384588 "$node_(189) setdest 204018 75674 11.0" 
$ns at 103.91313011791806 "$node_(190) setdest 8414 14670 9.0" 
$ns at 163.89326542304974 "$node_(190) setdest 32449 30828 8.0" 
$ns at 241.2817104760246 "$node_(190) setdest 35420 31073 3.0" 
$ns at 298.0273754177985 "$node_(190) setdest 137277 24044 15.0" 
$ns at 464.96827917984746 "$node_(190) setdest 43372 12305 4.0" 
$ns at 502.20900272152653 "$node_(190) setdest 110600 39773 11.0" 
$ns at 553.802029489714 "$node_(190) setdest 118771 7346 17.0" 
$ns at 740.2339850354333 "$node_(190) setdest 179219 67884 8.0" 
$ns at 815.4613096677838 "$node_(190) setdest 89665 74783 5.0" 
$ns at 894.4483488621853 "$node_(190) setdest 53659 57480 2.0" 
$ns at 146.60271504049007 "$node_(191) setdest 45868 7636 15.0" 
$ns at 293.80163693039987 "$node_(191) setdest 103696 14784 9.0" 
$ns at 337.19659620408606 "$node_(191) setdest 8249 24545 1.0" 
$ns at 369.1802157723099 "$node_(191) setdest 189352 2027 3.0" 
$ns at 415.67975404967865 "$node_(191) setdest 125765 14209 5.0" 
$ns at 450.9478311611792 "$node_(191) setdest 141563 55854 2.0" 
$ns at 496.4390221273749 "$node_(191) setdest 100056 49817 15.0" 
$ns at 581.4747407846681 "$node_(191) setdest 217358 55965 15.0" 
$ns at 672.8927125559172 "$node_(191) setdest 245551 8873 19.0" 
$ns at 867.1792435217969 "$node_(191) setdest 167360 5708 9.0" 
$ns at 239.8765238924242 "$node_(192) setdest 19906 37647 13.0" 
$ns at 310.2429461014705 "$node_(192) setdest 47864 17026 3.0" 
$ns at 364.6070633077601 "$node_(192) setdest 123851 42685 15.0" 
$ns at 518.2396483122875 "$node_(192) setdest 173415 36113 2.0" 
$ns at 558.1060802294601 "$node_(192) setdest 219957 29486 20.0" 
$ns at 687.5806539301111 "$node_(192) setdest 125969 65447 18.0" 
$ns at 896.2618236697199 "$node_(192) setdest 137478 6777 20.0" 
$ns at 148.4158686397972 "$node_(193) setdest 70522 24274 1.0" 
$ns at 185.4577243030567 "$node_(193) setdest 103231 31291 8.0" 
$ns at 294.47184314425186 "$node_(193) setdest 93172 10369 13.0" 
$ns at 417.6012185817243 "$node_(193) setdest 176766 13643 9.0" 
$ns at 515.3990012686288 "$node_(193) setdest 69151 30634 17.0" 
$ns at 583.4395194816383 "$node_(193) setdest 94123 28003 10.0" 
$ns at 622.9844875623544 "$node_(193) setdest 95526 4993 14.0" 
$ns at 786.2499273419271 "$node_(193) setdest 237233 43137 11.0" 
$ns at 860.6422354466662 "$node_(193) setdest 160763 88758 3.0" 
$ns at 126.87265870747346 "$node_(194) setdest 68229 22373 14.0" 
$ns at 218.67272980504367 "$node_(194) setdest 80173 38569 15.0" 
$ns at 262.2387165855424 "$node_(194) setdest 156951 28798 19.0" 
$ns at 454.5629984874841 "$node_(194) setdest 95900 17389 7.0" 
$ns at 508.2427474451809 "$node_(194) setdest 99288 15904 8.0" 
$ns at 582.1863835514135 "$node_(194) setdest 184079 20947 6.0" 
$ns at 663.0263783080833 "$node_(194) setdest 162441 60197 8.0" 
$ns at 739.9590350329379 "$node_(194) setdest 99533 20494 16.0" 
$ns at 862.0179351441756 "$node_(194) setdest 166980 66277 13.0" 
$ns at 204.79788731387276 "$node_(195) setdest 68378 41664 14.0" 
$ns at 313.9379602977633 "$node_(195) setdest 61359 27421 15.0" 
$ns at 440.3635734702924 "$node_(195) setdest 97909 19338 5.0" 
$ns at 482.0744415903104 "$node_(195) setdest 20179 12613 12.0" 
$ns at 540.44224469253 "$node_(195) setdest 6292 62610 10.0" 
$ns at 656.7402561966562 "$node_(195) setdest 74937 10693 11.0" 
$ns at 756.5712144746072 "$node_(195) setdest 114419 71142 1.0" 
$ns at 789.3978774325116 "$node_(195) setdest 93035 34033 9.0" 
$ns at 890.504512792842 "$node_(195) setdest 105389 63171 16.0" 
$ns at 206.4695176966787 "$node_(196) setdest 37552 17558 19.0" 
$ns at 348.00121494379823 "$node_(196) setdest 71224 51587 9.0" 
$ns at 385.7356721862156 "$node_(196) setdest 111685 11554 19.0" 
$ns at 553.7482129906015 "$node_(196) setdest 36318 40068 2.0" 
$ns at 589.0275940290636 "$node_(196) setdest 39304 75107 15.0" 
$ns at 708.4129697585621 "$node_(196) setdest 2674 60390 9.0" 
$ns at 747.8885450957011 "$node_(196) setdest 121732 31470 18.0" 
$ns at 782.7033892243335 "$node_(196) setdest 179112 44046 14.0" 
$ns at 857.3164789320718 "$node_(196) setdest 202259 15483 6.0" 
$ns at 892.0513806021165 "$node_(196) setdest 150157 53558 2.0" 
$ns at 236.1732630680684 "$node_(197) setdest 83834 17149 3.0" 
$ns at 279.55535440438246 "$node_(197) setdest 11433 5310 16.0" 
$ns at 380.4781573377084 "$node_(197) setdest 137704 818 17.0" 
$ns at 443.1124857563277 "$node_(197) setdest 382 27316 17.0" 
$ns at 495.29601396765406 "$node_(197) setdest 193633 63216 8.0" 
$ns at 525.6307626488593 "$node_(197) setdest 209447 33021 18.0" 
$ns at 730.7772607037234 "$node_(197) setdest 135296 40613 4.0" 
$ns at 774.9674885965596 "$node_(197) setdest 103863 70362 10.0" 
$ns at 897.1812314613711 "$node_(197) setdest 208168 52524 14.0" 
$ns at 122.2166305796184 "$node_(198) setdest 15899 20304 1.0" 
$ns at 158.88408526723896 "$node_(198) setdest 25370 8628 5.0" 
$ns at 196.87646348585767 "$node_(198) setdest 2962 19666 6.0" 
$ns at 244.97771697960056 "$node_(198) setdest 75337 37148 1.0" 
$ns at 282.4441500228026 "$node_(198) setdest 13687 41393 15.0" 
$ns at 420.1109711425983 "$node_(198) setdest 101496 39747 15.0" 
$ns at 467.93531824922104 "$node_(198) setdest 87452 61741 3.0" 
$ns at 524.6937261644861 "$node_(198) setdest 125978 56017 16.0" 
$ns at 647.1983808106381 "$node_(198) setdest 87804 27473 16.0" 
$ns at 826.4688103919821 "$node_(198) setdest 132374 82383 1.0" 
$ns at 863.9809959077227 "$node_(198) setdest 11817 71510 11.0" 
$ns at 109.76303757268613 "$node_(199) setdest 69602 6708 17.0" 
$ns at 206.12744640937595 "$node_(199) setdest 81319 30325 1.0" 
$ns at 236.24988701175437 "$node_(199) setdest 32929 20664 14.0" 
$ns at 307.28456504496637 "$node_(199) setdest 51841 52898 2.0" 
$ns at 340.45791604452484 "$node_(199) setdest 149040 18816 20.0" 
$ns at 479.5008569157361 "$node_(199) setdest 22679 40598 15.0" 
$ns at 649.2689225668719 "$node_(199) setdest 162904 42189 19.0" 
$ns at 792.405253417929 "$node_(199) setdest 243470 61090 15.0" 
$ns at 259.6225140571041 "$node_(200) setdest 12509 34019 6.0" 
$ns at 341.79717758100327 "$node_(200) setdest 22605 14737 1.0" 
$ns at 377.2438682792585 "$node_(200) setdest 83854 26360 17.0" 
$ns at 453.769010760525 "$node_(200) setdest 105514 6419 20.0" 
$ns at 629.9673317733532 "$node_(200) setdest 104153 30315 17.0" 
$ns at 707.8159182414013 "$node_(200) setdest 131834 21711 18.0" 
$ns at 762.7926760911814 "$node_(200) setdest 70061 14111 13.0" 
$ns at 898.2663672137995 "$node_(200) setdest 22155 15781 18.0" 
$ns at 292.35875906342187 "$node_(201) setdest 57264 19190 16.0" 
$ns at 460.309537977679 "$node_(201) setdest 104592 16492 18.0" 
$ns at 628.8167643018087 "$node_(201) setdest 63529 9367 2.0" 
$ns at 671.5516520024488 "$node_(201) setdest 68477 7863 7.0" 
$ns at 755.8473547463936 "$node_(201) setdest 66863 9034 2.0" 
$ns at 804.3333906126505 "$node_(201) setdest 116088 23968 11.0" 
$ns at 309.9434259389689 "$node_(202) setdest 112858 8865 15.0" 
$ns at 355.4765122970246 "$node_(202) setdest 27221 24508 10.0" 
$ns at 395.31116435229274 "$node_(202) setdest 58542 23397 17.0" 
$ns at 582.9779189518662 "$node_(202) setdest 5603 43528 13.0" 
$ns at 655.599874231621 "$node_(202) setdest 125486 19373 13.0" 
$ns at 779.2725245016605 "$node_(202) setdest 15670 12110 3.0" 
$ns at 832.5232295585793 "$node_(202) setdest 68819 7296 1.0" 
$ns at 872.1663283506149 "$node_(202) setdest 94283 42109 1.0" 
$ns at 210.89389416304266 "$node_(203) setdest 26779 39803 12.0" 
$ns at 304.783599894517 "$node_(203) setdest 23305 37632 20.0" 
$ns at 440.24171806872096 "$node_(203) setdest 131885 10938 1.0" 
$ns at 474.734859809256 "$node_(203) setdest 73266 9125 19.0" 
$ns at 576.5292920986637 "$node_(203) setdest 55189 31869 18.0" 
$ns at 676.6865804183153 "$node_(203) setdest 123724 39320 19.0" 
$ns at 737.117243654079 "$node_(203) setdest 6799 28104 4.0" 
$ns at 796.3120465187084 "$node_(203) setdest 98330 10870 16.0" 
$ns at 853.4258445369605 "$node_(203) setdest 21620 42065 16.0" 
$ns at 226.39696293319435 "$node_(204) setdest 37274 23277 10.0" 
$ns at 271.16960597269804 "$node_(204) setdest 13131 1580 10.0" 
$ns at 335.0264368858808 "$node_(204) setdest 120793 36625 16.0" 
$ns at 516.3721805722607 "$node_(204) setdest 40137 20159 1.0" 
$ns at 552.3172493246681 "$node_(204) setdest 64981 18073 14.0" 
$ns at 717.9052087578273 "$node_(204) setdest 26112 8526 19.0" 
$ns at 867.4303218979801 "$node_(204) setdest 53498 34033 8.0" 
$ns at 899.8930219793948 "$node_(204) setdest 106363 37930 15.0" 
$ns at 272.2729608154049 "$node_(205) setdest 46954 31850 5.0" 
$ns at 336.4983549860575 "$node_(205) setdest 94170 29015 16.0" 
$ns at 523.4005785731387 "$node_(205) setdest 118086 16822 8.0" 
$ns at 588.7609475036686 "$node_(205) setdest 102387 7952 1.0" 
$ns at 619.1616472989532 "$node_(205) setdest 1005 15251 16.0" 
$ns at 776.5065227244681 "$node_(205) setdest 79375 30679 17.0" 
$ns at 854.0242603326444 "$node_(205) setdest 129480 15785 20.0" 
$ns at 201.1905675294239 "$node_(206) setdest 59816 16921 8.0" 
$ns at 264.6054081299992 "$node_(206) setdest 123353 15150 11.0" 
$ns at 366.63793262236675 "$node_(206) setdest 116712 20326 8.0" 
$ns at 435.0018393080606 "$node_(206) setdest 67588 36594 13.0" 
$ns at 583.3403924751472 "$node_(206) setdest 87392 39448 12.0" 
$ns at 676.7721055269138 "$node_(206) setdest 89378 12644 7.0" 
$ns at 766.3728951243428 "$node_(206) setdest 58968 22706 8.0" 
$ns at 820.4308780883896 "$node_(206) setdest 52719 11091 12.0" 
$ns at 886.6505977318897 "$node_(206) setdest 78839 315 2.0" 
$ns at 366.5218717252157 "$node_(207) setdest 82330 15491 19.0" 
$ns at 431.03103712016446 "$node_(207) setdest 38769 14512 20.0" 
$ns at 652.0321437744831 "$node_(207) setdest 30025 25940 17.0" 
$ns at 790.7482937337805 "$node_(207) setdest 38347 2908 10.0" 
$ns at 878.434826958129 "$node_(207) setdest 89820 4982 7.0" 
$ns at 318.4317367947528 "$node_(208) setdest 129750 27573 6.0" 
$ns at 369.6468799173825 "$node_(208) setdest 91024 17826 17.0" 
$ns at 455.37967653225746 "$node_(208) setdest 91248 42570 14.0" 
$ns at 534.2788912492927 "$node_(208) setdest 40254 2959 15.0" 
$ns at 602.8563962857362 "$node_(208) setdest 114325 6995 13.0" 
$ns at 722.7312718844993 "$node_(208) setdest 20713 39454 5.0" 
$ns at 794.3454455361281 "$node_(208) setdest 81930 5166 6.0" 
$ns at 856.8062991834612 "$node_(208) setdest 20174 1257 9.0" 
$ns at 249.2482337172656 "$node_(209) setdest 77667 14520 11.0" 
$ns at 362.30967544540005 "$node_(209) setdest 74625 25211 3.0" 
$ns at 412.55276079757766 "$node_(209) setdest 68090 10967 9.0" 
$ns at 482.507352094221 "$node_(209) setdest 33962 37878 18.0" 
$ns at 515.9398986887098 "$node_(209) setdest 107398 26181 12.0" 
$ns at 619.1770466969825 "$node_(209) setdest 25848 42537 6.0" 
$ns at 700.062654622918 "$node_(209) setdest 120871 36235 10.0" 
$ns at 797.6065376358788 "$node_(209) setdest 32452 41479 1.0" 
$ns at 829.2476363650012 "$node_(209) setdest 119484 13580 3.0" 
$ns at 868.759228315442 "$node_(209) setdest 108414 7176 8.0" 
$ns at 301.96060866437676 "$node_(210) setdest 16476 41957 20.0" 
$ns at 444.69977936887244 "$node_(210) setdest 19957 40173 1.0" 
$ns at 477.2414686162308 "$node_(210) setdest 1356 19190 1.0" 
$ns at 507.73804602694975 "$node_(210) setdest 99081 38915 12.0" 
$ns at 600.8714363034057 "$node_(210) setdest 35633 20884 2.0" 
$ns at 631.8920199309256 "$node_(210) setdest 67123 10441 10.0" 
$ns at 702.9029133832776 "$node_(210) setdest 105892 38286 18.0" 
$ns at 862.9874308042888 "$node_(210) setdest 1275 31030 4.0" 
$ns at 230.6912727971977 "$node_(211) setdest 41798 32230 14.0" 
$ns at 338.49350484660425 "$node_(211) setdest 11222 16643 7.0" 
$ns at 376.51356813719065 "$node_(211) setdest 23598 12521 17.0" 
$ns at 414.97720515030386 "$node_(211) setdest 23277 27192 7.0" 
$ns at 450.3251631466013 "$node_(211) setdest 25972 30457 2.0" 
$ns at 486.76525472719703 "$node_(211) setdest 19875 34627 3.0" 
$ns at 524.8246571150258 "$node_(211) setdest 42087 9610 5.0" 
$ns at 590.13116988819 "$node_(211) setdest 44393 5434 19.0" 
$ns at 695.5321910885701 "$node_(211) setdest 55057 9267 2.0" 
$ns at 737.1120142927025 "$node_(211) setdest 111534 3396 7.0" 
$ns at 785.8734019437662 "$node_(211) setdest 105219 15817 20.0" 
$ns at 220.93096149398974 "$node_(212) setdest 96189 43140 3.0" 
$ns at 264.3826406339841 "$node_(212) setdest 126688 32486 6.0" 
$ns at 307.5974739127364 "$node_(212) setdest 83129 14050 1.0" 
$ns at 343.70501190622656 "$node_(212) setdest 43961 12075 1.0" 
$ns at 374.91201752705643 "$node_(212) setdest 54443 28024 1.0" 
$ns at 407.14988688837894 "$node_(212) setdest 57217 37402 17.0" 
$ns at 466.7130922794968 "$node_(212) setdest 5170 19415 20.0" 
$ns at 563.7597603141389 "$node_(212) setdest 20842 27334 10.0" 
$ns at 661.628047389323 "$node_(212) setdest 42851 29567 11.0" 
$ns at 713.8791645278901 "$node_(212) setdest 76397 42635 1.0" 
$ns at 749.4178498979295 "$node_(212) setdest 38905 30739 5.0" 
$ns at 782.4667068749577 "$node_(212) setdest 44575 8315 6.0" 
$ns at 854.8251352845905 "$node_(212) setdest 21684 40085 5.0" 
$ns at 230.98898294834794 "$node_(213) setdest 69141 11832 15.0" 
$ns at 321.50210435596694 "$node_(213) setdest 114802 20536 7.0" 
$ns at 387.41491723764454 "$node_(213) setdest 103144 25789 9.0" 
$ns at 499.83686618668384 "$node_(213) setdest 46089 32358 11.0" 
$ns at 550.4551402555494 "$node_(213) setdest 75131 36221 10.0" 
$ns at 587.3599878795766 "$node_(213) setdest 124564 16326 7.0" 
$ns at 634.4253203380781 "$node_(213) setdest 119661 11002 17.0" 
$ns at 726.3714738181856 "$node_(213) setdest 70378 1358 17.0" 
$ns at 784.8013724554398 "$node_(213) setdest 7477 3361 5.0" 
$ns at 841.2740862636902 "$node_(213) setdest 53909 14486 3.0" 
$ns at 893.8359511546862 "$node_(213) setdest 26682 42397 4.0" 
$ns at 314.11483316096053 "$node_(214) setdest 27482 6167 16.0" 
$ns at 387.74824713428256 "$node_(214) setdest 96515 23960 6.0" 
$ns at 477.68377627317204 "$node_(214) setdest 45636 41223 14.0" 
$ns at 517.404016580932 "$node_(214) setdest 64624 38578 3.0" 
$ns at 548.700705026076 "$node_(214) setdest 73183 1792 11.0" 
$ns at 625.7116431613833 "$node_(214) setdest 71806 30658 1.0" 
$ns at 657.1872532057974 "$node_(214) setdest 66701 15915 3.0" 
$ns at 708.5608691036929 "$node_(214) setdest 133639 132 3.0" 
$ns at 743.4685974593181 "$node_(214) setdest 2835 7573 10.0" 
$ns at 834.5208787128786 "$node_(214) setdest 74771 41531 3.0" 
$ns at 872.4755745363999 "$node_(214) setdest 74478 39441 2.0" 
$ns at 225.6299557268433 "$node_(215) setdest 16465 751 1.0" 
$ns at 263.9951809569327 "$node_(215) setdest 19740 8671 8.0" 
$ns at 363.5159217093768 "$node_(215) setdest 33151 20000 17.0" 
$ns at 483.9453104521889 "$node_(215) setdest 44986 10849 3.0" 
$ns at 523.1863059714213 "$node_(215) setdest 60573 18916 15.0" 
$ns at 652.6220395826045 "$node_(215) setdest 77709 6998 12.0" 
$ns at 709.8358635425335 "$node_(215) setdest 55472 10952 18.0" 
$ns at 781.276016882893 "$node_(215) setdest 129285 4487 6.0" 
$ns at 844.9882869455957 "$node_(215) setdest 121453 7615 18.0" 
$ns at 298.41806298099107 "$node_(216) setdest 125069 29754 19.0" 
$ns at 501.2630940855252 "$node_(216) setdest 89454 5422 3.0" 
$ns at 560.4203444972417 "$node_(216) setdest 23210 10947 3.0" 
$ns at 615.0948179690522 "$node_(216) setdest 120031 33847 7.0" 
$ns at 693.5563016163205 "$node_(216) setdest 13223 1171 18.0" 
$ns at 784.1925462621131 "$node_(216) setdest 52503 3783 12.0" 
$ns at 814.285964747896 "$node_(216) setdest 78779 5607 1.0" 
$ns at 845.7441216610894 "$node_(216) setdest 49273 28475 1.0" 
$ns at 879.9532025196313 "$node_(216) setdest 98039 25792 18.0" 
$ns at 262.7742443193631 "$node_(217) setdest 84194 33541 5.0" 
$ns at 339.34740133055266 "$node_(217) setdest 121032 10662 9.0" 
$ns at 383.01918570390114 "$node_(217) setdest 103159 35335 9.0" 
$ns at 417.90058542846253 "$node_(217) setdest 69935 25550 11.0" 
$ns at 528.750834030978 "$node_(217) setdest 41520 34605 15.0" 
$ns at 689.8939110726457 "$node_(217) setdest 120398 5043 20.0" 
$ns at 878.6881014603596 "$node_(217) setdest 48812 36947 13.0" 
$ns at 228.66879587241877 "$node_(218) setdest 68173 10223 18.0" 
$ns at 340.10846254127074 "$node_(218) setdest 85283 205 4.0" 
$ns at 404.48941414671145 "$node_(218) setdest 128305 22923 10.0" 
$ns at 497.6257976669358 "$node_(218) setdest 44335 27276 1.0" 
$ns at 530.6377777987263 "$node_(218) setdest 45264 5489 13.0" 
$ns at 649.4228548968952 "$node_(218) setdest 66589 12826 6.0" 
$ns at 721.4275233925966 "$node_(218) setdest 55916 22953 3.0" 
$ns at 760.5144078078895 "$node_(218) setdest 29965 26043 19.0" 
$ns at 229.32260025937222 "$node_(219) setdest 90587 23477 14.0" 
$ns at 280.00537908397206 "$node_(219) setdest 117012 23312 2.0" 
$ns at 310.09838548546225 "$node_(219) setdest 1749 18997 7.0" 
$ns at 382.8128899759332 "$node_(219) setdest 5029 6437 14.0" 
$ns at 540.6938694603941 "$node_(219) setdest 38349 19389 19.0" 
$ns at 583.8177484293241 "$node_(219) setdest 133188 16861 11.0" 
$ns at 706.977551521672 "$node_(219) setdest 83733 19574 2.0" 
$ns at 755.3928026950051 "$node_(219) setdest 62257 6387 13.0" 
$ns at 883.5183118994221 "$node_(219) setdest 9846 27902 1.0" 
$ns at 227.4149703526308 "$node_(220) setdest 94314 5939 18.0" 
$ns at 330.2548667407564 "$node_(220) setdest 131253 7351 7.0" 
$ns at 371.68411692540997 "$node_(220) setdest 3096 12049 15.0" 
$ns at 453.1063016110635 "$node_(220) setdest 24093 33277 4.0" 
$ns at 483.8552300966287 "$node_(220) setdest 102789 20152 4.0" 
$ns at 524.3897503500333 "$node_(220) setdest 112435 14645 2.0" 
$ns at 558.5608941264842 "$node_(220) setdest 38582 10455 12.0" 
$ns at 620.4772202865533 "$node_(220) setdest 79471 41885 4.0" 
$ns at 686.7412308525077 "$node_(220) setdest 81991 3862 7.0" 
$ns at 770.2866678099283 "$node_(220) setdest 77017 43291 13.0" 
$ns at 878.7783013575212 "$node_(220) setdest 109616 29692 8.0" 
$ns at 231.82309466774245 "$node_(221) setdest 76375 1386 9.0" 
$ns at 297.25351984002634 "$node_(221) setdest 88494 29233 16.0" 
$ns at 479.6064198457621 "$node_(221) setdest 26643 14047 3.0" 
$ns at 509.8629941177087 "$node_(221) setdest 21104 41239 10.0" 
$ns at 626.3747991243819 "$node_(221) setdest 93056 25127 16.0" 
$ns at 671.3748515582101 "$node_(221) setdest 70554 19144 19.0" 
$ns at 771.3705152348352 "$node_(221) setdest 54634 16519 13.0" 
$ns at 874.8942727752432 "$node_(221) setdest 37195 24371 4.0" 
$ns at 233.37354587642523 "$node_(222) setdest 130418 28361 15.0" 
$ns at 280.6606671067168 "$node_(222) setdest 47531 21234 10.0" 
$ns at 390.3390106303405 "$node_(222) setdest 132930 2014 9.0" 
$ns at 458.9584109992494 "$node_(222) setdest 67039 37738 12.0" 
$ns at 561.9059646135343 "$node_(222) setdest 22805 20126 18.0" 
$ns at 762.2290532947578 "$node_(222) setdest 128571 989 1.0" 
$ns at 793.8632946014709 "$node_(222) setdest 82998 7117 3.0" 
$ns at 835.82018809009 "$node_(222) setdest 122985 17986 5.0" 
$ns at 898.4316648005747 "$node_(222) setdest 4533 11395 12.0" 
$ns at 252.741421176292 "$node_(223) setdest 83305 16029 8.0" 
$ns at 294.22634353528815 "$node_(223) setdest 92088 42312 13.0" 
$ns at 394.59113094911544 "$node_(223) setdest 38792 16435 8.0" 
$ns at 426.0664391104891 "$node_(223) setdest 37090 41521 14.0" 
$ns at 496.2969606037897 "$node_(223) setdest 109745 1161 7.0" 
$ns at 565.8814127384279 "$node_(223) setdest 54665 14945 1.0" 
$ns at 601.4813755267346 "$node_(223) setdest 1497 38832 9.0" 
$ns at 711.9068729837485 "$node_(223) setdest 66516 30223 11.0" 
$ns at 809.0648985901852 "$node_(223) setdest 20335 12701 20.0" 
$ns at 257.3485413307068 "$node_(224) setdest 48309 15986 3.0" 
$ns at 313.7853659967492 "$node_(224) setdest 121317 32764 9.0" 
$ns at 426.73461531207465 "$node_(224) setdest 61612 17732 19.0" 
$ns at 605.1575517650274 "$node_(224) setdest 104915 12602 13.0" 
$ns at 658.7978176447165 "$node_(224) setdest 33872 26659 14.0" 
$ns at 798.0712683540621 "$node_(224) setdest 11773 21903 17.0" 
$ns at 201.73575817295944 "$node_(225) setdest 65357 34062 16.0" 
$ns at 321.32445073035984 "$node_(225) setdest 97669 43619 1.0" 
$ns at 360.470215924632 "$node_(225) setdest 40882 23465 3.0" 
$ns at 390.75584871679337 "$node_(225) setdest 102503 21541 3.0" 
$ns at 431.33771434799496 "$node_(225) setdest 82832 38889 14.0" 
$ns at 509.18160406451216 "$node_(225) setdest 37996 36326 17.0" 
$ns at 654.0481038700536 "$node_(225) setdest 69708 17289 12.0" 
$ns at 757.6055860651394 "$node_(225) setdest 89747 9756 19.0" 
$ns at 862.466668297001 "$node_(225) setdest 67133 12096 6.0" 
$ns at 275.61346163377425 "$node_(226) setdest 83890 22124 13.0" 
$ns at 363.0825168031792 "$node_(226) setdest 22389 17566 3.0" 
$ns at 414.21802408885327 "$node_(226) setdest 110951 38168 7.0" 
$ns at 498.2241436107985 "$node_(226) setdest 50957 27937 13.0" 
$ns at 597.6411797147439 "$node_(226) setdest 56512 36189 1.0" 
$ns at 635.7477657106956 "$node_(226) setdest 17996 35345 9.0" 
$ns at 715.4206270937409 "$node_(226) setdest 98301 28174 20.0" 
$ns at 256.972939487251 "$node_(227) setdest 93620 40326 3.0" 
$ns at 287.3970091787262 "$node_(227) setdest 39362 38219 7.0" 
$ns at 384.9821182394724 "$node_(227) setdest 101113 43377 12.0" 
$ns at 521.9689058532575 "$node_(227) setdest 77830 26420 8.0" 
$ns at 620.2573686782206 "$node_(227) setdest 10470 8988 1.0" 
$ns at 657.4566981663819 "$node_(227) setdest 128983 23724 19.0" 
$ns at 707.3333770265785 "$node_(227) setdest 97739 37075 12.0" 
$ns at 805.6097974213877 "$node_(227) setdest 130272 32927 17.0" 
$ns at 270.2625931090276 "$node_(228) setdest 70860 22105 3.0" 
$ns at 320.1440108067085 "$node_(228) setdest 9489 20997 15.0" 
$ns at 407.9145106050531 "$node_(228) setdest 61542 9655 13.0" 
$ns at 465.24162950219204 "$node_(228) setdest 63460 22362 2.0" 
$ns at 504.9956721135696 "$node_(228) setdest 131098 36727 3.0" 
$ns at 543.2562639331172 "$node_(228) setdest 99669 27479 17.0" 
$ns at 679.9285479452026 "$node_(228) setdest 9214 15264 14.0" 
$ns at 796.31285754427 "$node_(228) setdest 123112 7382 6.0" 
$ns at 860.3008358163614 "$node_(228) setdest 102981 14135 5.0" 
$ns at 334.2902101426709 "$node_(229) setdest 103328 25871 6.0" 
$ns at 370.8645839639519 "$node_(229) setdest 68870 32158 4.0" 
$ns at 422.4767005833949 "$node_(229) setdest 60586 35676 9.0" 
$ns at 490.6451763211784 "$node_(229) setdest 110543 27791 16.0" 
$ns at 537.999426475036 "$node_(229) setdest 2875 41033 13.0" 
$ns at 569.4197596148888 "$node_(229) setdest 113592 40260 4.0" 
$ns at 616.4957176517431 "$node_(229) setdest 4686 1130 1.0" 
$ns at 647.5163367694923 "$node_(229) setdest 919 29542 4.0" 
$ns at 691.2158082350489 "$node_(229) setdest 109935 26550 7.0" 
$ns at 753.1649192925506 "$node_(229) setdest 125543 17630 14.0" 
$ns at 887.9252356619659 "$node_(229) setdest 99741 29329 17.0" 
$ns at 232.18004031006973 "$node_(230) setdest 53635 5471 6.0" 
$ns at 320.31118553278475 "$node_(230) setdest 125257 20830 5.0" 
$ns at 350.39268276808326 "$node_(230) setdest 31517 31335 8.0" 
$ns at 437.54741498803355 "$node_(230) setdest 53702 35854 7.0" 
$ns at 500.6179343345859 "$node_(230) setdest 45899 35512 14.0" 
$ns at 603.9378095843766 "$node_(230) setdest 64468 23949 1.0" 
$ns at 637.9362635550735 "$node_(230) setdest 102525 15355 2.0" 
$ns at 686.3673168808973 "$node_(230) setdest 18724 17102 4.0" 
$ns at 737.8405788260417 "$node_(230) setdest 15571 31500 4.0" 
$ns at 768.672078154963 "$node_(230) setdest 34785 31655 13.0" 
$ns at 834.3415449940766 "$node_(230) setdest 38283 25760 1.0" 
$ns at 865.0770848683194 "$node_(230) setdest 124309 42023 7.0" 
$ns at 217.05088736918157 "$node_(231) setdest 70010 9181 4.0" 
$ns at 271.50205805910315 "$node_(231) setdest 51437 33236 19.0" 
$ns at 423.65431954886253 "$node_(231) setdest 11712 20870 13.0" 
$ns at 470.6006970696011 "$node_(231) setdest 17081 397 12.0" 
$ns at 590.014508300773 "$node_(231) setdest 28560 28479 18.0" 
$ns at 642.7768264364635 "$node_(231) setdest 103954 5721 1.0" 
$ns at 678.9354267043958 "$node_(231) setdest 81496 21902 1.0" 
$ns at 718.400979061648 "$node_(231) setdest 129988 34322 9.0" 
$ns at 765.8431157882507 "$node_(231) setdest 65876 29403 6.0" 
$ns at 801.4352222741387 "$node_(231) setdest 125298 1109 2.0" 
$ns at 832.2833402190136 "$node_(231) setdest 21599 31702 2.0" 
$ns at 876.5992271779367 "$node_(231) setdest 95003 8673 16.0" 
$ns at 261.08809051241315 "$node_(232) setdest 58710 11935 3.0" 
$ns at 314.99953534263045 "$node_(232) setdest 119929 14469 2.0" 
$ns at 363.6045480136606 "$node_(232) setdest 83526 36132 15.0" 
$ns at 505.666605734288 "$node_(232) setdest 35153 1416 6.0" 
$ns at 588.6849894232452 "$node_(232) setdest 93153 27139 14.0" 
$ns at 637.0932574412656 "$node_(232) setdest 87743 34372 20.0" 
$ns at 763.5791290293209 "$node_(232) setdest 71117 35289 13.0" 
$ns at 888.290341884631 "$node_(232) setdest 118997 2519 11.0" 
$ns at 228.90247998407685 "$node_(233) setdest 110039 22919 7.0" 
$ns at 298.0066492186741 "$node_(233) setdest 78354 22979 15.0" 
$ns at 421.4934387595554 "$node_(233) setdest 15520 36299 10.0" 
$ns at 494.07515102508967 "$node_(233) setdest 84120 33729 8.0" 
$ns at 554.0473254644405 "$node_(233) setdest 70207 26854 13.0" 
$ns at 681.6127128059754 "$node_(233) setdest 12293 23837 12.0" 
$ns at 737.8641751224151 "$node_(233) setdest 125170 12014 9.0" 
$ns at 839.1696415403163 "$node_(233) setdest 42408 15068 6.0" 
$ns at 247.10324382565705 "$node_(234) setdest 56607 18174 11.0" 
$ns at 379.3016513632966 "$node_(234) setdest 61529 34981 11.0" 
$ns at 456.7315322463275 "$node_(234) setdest 72140 4467 11.0" 
$ns at 515.806549563343 "$node_(234) setdest 18841 29494 19.0" 
$ns at 674.1091764138569 "$node_(234) setdest 111190 12187 7.0" 
$ns at 754.5236478342697 "$node_(234) setdest 23557 12841 5.0" 
$ns at 789.8252884290495 "$node_(234) setdest 76168 18876 10.0" 
$ns at 852.9259508723567 "$node_(234) setdest 28419 21174 12.0" 
$ns at 280.54864123475625 "$node_(235) setdest 21263 19354 9.0" 
$ns at 317.65745589457015 "$node_(235) setdest 42650 7563 12.0" 
$ns at 375.11527467100154 "$node_(235) setdest 60879 24795 1.0" 
$ns at 408.82974183710735 "$node_(235) setdest 113412 30934 3.0" 
$ns at 459.34402223653774 "$node_(235) setdest 81331 5349 8.0" 
$ns at 491.2587344286886 "$node_(235) setdest 115743 33909 1.0" 
$ns at 525.8997400498776 "$node_(235) setdest 3501 31642 8.0" 
$ns at 616.7627793341463 "$node_(235) setdest 86499 34310 16.0" 
$ns at 794.8261932077515 "$node_(235) setdest 109765 10672 7.0" 
$ns at 865.4417815840598 "$node_(235) setdest 41514 7552 7.0" 
$ns at 278.1240207979471 "$node_(236) setdest 8736 17258 5.0" 
$ns at 319.1806287891407 "$node_(236) setdest 113888 26064 11.0" 
$ns at 404.71739866563166 "$node_(236) setdest 53594 125 11.0" 
$ns at 482.14674416256173 "$node_(236) setdest 115434 30386 8.0" 
$ns at 545.5288802270201 "$node_(236) setdest 23029 12294 10.0" 
$ns at 601.8550236909307 "$node_(236) setdest 83176 22427 14.0" 
$ns at 681.4660356277126 "$node_(236) setdest 65866 39850 16.0" 
$ns at 790.8703066591552 "$node_(236) setdest 78595 40332 17.0" 
$ns at 298.89818334155353 "$node_(237) setdest 106160 2221 1.0" 
$ns at 338.06135897149017 "$node_(237) setdest 117172 12646 8.0" 
$ns at 433.64025544063395 "$node_(237) setdest 72010 12262 1.0" 
$ns at 472.2577756888092 "$node_(237) setdest 86234 7407 10.0" 
$ns at 509.0805241235631 "$node_(237) setdest 132202 39168 15.0" 
$ns at 613.2128184328462 "$node_(237) setdest 87040 41703 11.0" 
$ns at 703.1449876778145 "$node_(237) setdest 78919 37153 2.0" 
$ns at 747.1976898004141 "$node_(237) setdest 60319 16223 2.0" 
$ns at 779.6031518922612 "$node_(237) setdest 77288 44413 18.0" 
$ns at 228.45571682460863 "$node_(238) setdest 88366 21079 5.0" 
$ns at 272.9019808602678 "$node_(238) setdest 55537 13024 5.0" 
$ns at 332.67474217073334 "$node_(238) setdest 124964 21771 1.0" 
$ns at 367.32614318121693 "$node_(238) setdest 121495 28940 8.0" 
$ns at 408.8737338307116 "$node_(238) setdest 83342 11354 3.0" 
$ns at 439.0651120146552 "$node_(238) setdest 56171 15738 17.0" 
$ns at 620.7718555274886 "$node_(238) setdest 82756 1340 14.0" 
$ns at 786.4272375636378 "$node_(238) setdest 58452 23614 6.0" 
$ns at 868.6209191761182 "$node_(238) setdest 36333 13050 16.0" 
$ns at 367.0139447513683 "$node_(239) setdest 118789 39578 15.0" 
$ns at 495.17351941427785 "$node_(239) setdest 32790 24960 16.0" 
$ns at 664.0569236944679 "$node_(239) setdest 99948 31135 16.0" 
$ns at 700.5341494224378 "$node_(239) setdest 64669 10926 15.0" 
$ns at 751.1041018773909 "$node_(239) setdest 92770 32672 9.0" 
$ns at 860.2125793885925 "$node_(239) setdest 58864 7860 2.0" 
$ns at 896.0836793156735 "$node_(239) setdest 10395 13450 14.0" 
$ns at 281.5302623235779 "$node_(240) setdest 90935 10222 6.0" 
$ns at 349.94856283182514 "$node_(240) setdest 50084 8572 12.0" 
$ns at 472.060070309209 "$node_(240) setdest 92172 16022 15.0" 
$ns at 600.0039976102354 "$node_(240) setdest 79179 5522 14.0" 
$ns at 766.2417563576679 "$node_(240) setdest 24882 10672 4.0" 
$ns at 796.4847237354339 "$node_(240) setdest 94583 23247 1.0" 
$ns at 827.7913071283788 "$node_(240) setdest 63783 37355 14.0" 
$ns at 887.872737771673 "$node_(240) setdest 5863 3617 5.0" 
$ns at 276.26748863305966 "$node_(241) setdest 70121 22297 15.0" 
$ns at 455.5774989172125 "$node_(241) setdest 78698 1628 17.0" 
$ns at 579.1945567639933 "$node_(241) setdest 43061 43801 2.0" 
$ns at 626.0771607867897 "$node_(241) setdest 120417 15805 14.0" 
$ns at 692.0123781078491 "$node_(241) setdest 112524 44222 9.0" 
$ns at 791.0828135435238 "$node_(241) setdest 33530 38549 6.0" 
$ns at 835.7405140916848 "$node_(241) setdest 91409 14190 1.0" 
$ns at 868.7459943552858 "$node_(241) setdest 99661 4490 4.0" 
$ns at 321.8887185618714 "$node_(242) setdest 27630 34395 9.0" 
$ns at 368.89765945750867 "$node_(242) setdest 127077 34946 18.0" 
$ns at 574.7941851988187 "$node_(242) setdest 107446 26011 4.0" 
$ns at 634.3178446457925 "$node_(242) setdest 125748 19343 16.0" 
$ns at 671.3932212699957 "$node_(242) setdest 50473 5227 11.0" 
$ns at 745.5241837781997 "$node_(242) setdest 55660 15437 1.0" 
$ns at 784.954207567253 "$node_(242) setdest 31105 6336 9.0" 
$ns at 870.421257301207 "$node_(242) setdest 42732 22740 5.0" 
$ns at 219.1184118547419 "$node_(243) setdest 131406 24509 1.0" 
$ns at 250.6482570392212 "$node_(243) setdest 21575 8354 14.0" 
$ns at 316.02559306829346 "$node_(243) setdest 85326 17834 3.0" 
$ns at 354.857712943704 "$node_(243) setdest 11845 42542 15.0" 
$ns at 498.5631792591126 "$node_(243) setdest 109486 28930 2.0" 
$ns at 539.3484351413438 "$node_(243) setdest 26796 41119 12.0" 
$ns at 676.2368129427366 "$node_(243) setdest 72533 16977 1.0" 
$ns at 707.298474405302 "$node_(243) setdest 73829 19705 6.0" 
$ns at 770.9230983247409 "$node_(243) setdest 85912 9912 16.0" 
$ns at 899.209962724968 "$node_(243) setdest 92902 40264 19.0" 
$ns at 288.49589016468184 "$node_(244) setdest 84330 9703 17.0" 
$ns at 352.73431071510333 "$node_(244) setdest 110097 20064 9.0" 
$ns at 435.4299804939616 "$node_(244) setdest 84927 11627 11.0" 
$ns at 544.1836868078348 "$node_(244) setdest 75685 28503 8.0" 
$ns at 615.409800422101 "$node_(244) setdest 29817 25025 7.0" 
$ns at 646.3932637522978 "$node_(244) setdest 91126 19221 4.0" 
$ns at 680.894670458453 "$node_(244) setdest 43998 12876 1.0" 
$ns at 711.2666456400982 "$node_(244) setdest 60373 15476 6.0" 
$ns at 777.8155921559048 "$node_(244) setdest 101832 6442 18.0" 
$ns at 812.8041932862993 "$node_(244) setdest 120955 12683 6.0" 
$ns at 894.4080320638628 "$node_(244) setdest 36101 11942 12.0" 
$ns at 276.74079561168884 "$node_(245) setdest 93983 791 13.0" 
$ns at 318.8504621802972 "$node_(245) setdest 9607 16539 14.0" 
$ns at 387.7319524681795 "$node_(245) setdest 13472 43917 5.0" 
$ns at 425.0882005168863 "$node_(245) setdest 107708 37116 12.0" 
$ns at 493.9211261781699 "$node_(245) setdest 81661 15077 3.0" 
$ns at 541.1019876087521 "$node_(245) setdest 16660 1141 5.0" 
$ns at 620.1915777907169 "$node_(245) setdest 77936 4878 18.0" 
$ns at 727.212919964576 "$node_(245) setdest 97989 27299 19.0" 
$ns at 868.2344406779072 "$node_(245) setdest 25539 990 11.0" 
$ns at 211.08382550773484 "$node_(246) setdest 133679 37968 2.0" 
$ns at 243.35552789343558 "$node_(246) setdest 49971 33203 8.0" 
$ns at 332.1678530852132 "$node_(246) setdest 88580 30271 17.0" 
$ns at 530.4322464148597 "$node_(246) setdest 128134 2457 9.0" 
$ns at 644.2200174139996 "$node_(246) setdest 33684 466 8.0" 
$ns at 723.0620567626011 "$node_(246) setdest 98317 24304 14.0" 
$ns at 868.675605408153 "$node_(246) setdest 72782 5591 14.0" 
$ns at 230.81355073095926 "$node_(247) setdest 69586 482 3.0" 
$ns at 263.41920434829274 "$node_(247) setdest 126497 40480 5.0" 
$ns at 334.0421773524722 "$node_(247) setdest 80982 43216 12.0" 
$ns at 399.84320152149087 "$node_(247) setdest 37149 5678 5.0" 
$ns at 472.5073723884149 "$node_(247) setdest 91787 28976 6.0" 
$ns at 531.7763193679212 "$node_(247) setdest 78497 24395 17.0" 
$ns at 617.2350829198652 "$node_(247) setdest 28615 9700 6.0" 
$ns at 660.1728800067591 "$node_(247) setdest 116449 26251 5.0" 
$ns at 710.1313109787991 "$node_(247) setdest 63436 12937 11.0" 
$ns at 755.6414036541574 "$node_(247) setdest 75920 22115 20.0" 
$ns at 216.32215460586758 "$node_(248) setdest 20776 43751 9.0" 
$ns at 304.73549857114756 "$node_(248) setdest 81835 41988 9.0" 
$ns at 399.71010200833547 "$node_(248) setdest 46683 23207 1.0" 
$ns at 436.9370534300752 "$node_(248) setdest 115074 6030 19.0" 
$ns at 655.8550913815989 "$node_(248) setdest 13016 26488 13.0" 
$ns at 782.7740504681391 "$node_(248) setdest 35251 33779 7.0" 
$ns at 830.1699279187212 "$node_(248) setdest 121156 13400 6.0" 
$ns at 867.0108051247065 "$node_(248) setdest 115737 1523 1.0" 
$ns at 238.49126771974431 "$node_(249) setdest 39490 8880 10.0" 
$ns at 356.3220945346304 "$node_(249) setdest 82347 23338 18.0" 
$ns at 508.35870720426266 "$node_(249) setdest 102090 26182 2.0" 
$ns at 542.84758634403 "$node_(249) setdest 14743 25379 2.0" 
$ns at 578.3647841622899 "$node_(249) setdest 92397 32548 15.0" 
$ns at 718.7927876368016 "$node_(249) setdest 59116 26373 3.0" 
$ns at 761.8529804146781 "$node_(249) setdest 106881 17397 7.0" 
$ns at 849.7339531989294 "$node_(249) setdest 57321 38185 3.0" 
$ns at 882.3573705768396 "$node_(249) setdest 105895 14390 15.0" 
$ns at 223.48859815951693 "$node_(250) setdest 11918 35843 18.0" 
$ns at 384.7723765471215 "$node_(250) setdest 69831 11156 15.0" 
$ns at 455.44691217666366 "$node_(250) setdest 92048 12086 12.0" 
$ns at 526.0148965347224 "$node_(250) setdest 50847 6146 6.0" 
$ns at 563.1843481186372 "$node_(250) setdest 40018 13231 17.0" 
$ns at 688.7893496190933 "$node_(250) setdest 74077 39434 1.0" 
$ns at 726.0866860924629 "$node_(250) setdest 76993 37959 7.0" 
$ns at 764.2448603864036 "$node_(250) setdest 79990 39553 4.0" 
$ns at 812.8887510299184 "$node_(250) setdest 60584 5368 17.0" 
$ns at 889.6242471826009 "$node_(250) setdest 99874 16073 1.0" 
$ns at 241.2628654829667 "$node_(251) setdest 145 18595 13.0" 
$ns at 296.90602579125675 "$node_(251) setdest 83002 32917 4.0" 
$ns at 340.67087999933733 "$node_(251) setdest 93721 41088 7.0" 
$ns at 373.95379216330434 "$node_(251) setdest 83679 22137 4.0" 
$ns at 441.047819324471 "$node_(251) setdest 107769 18625 12.0" 
$ns at 541.0868061743439 "$node_(251) setdest 73445 25595 19.0" 
$ns at 642.5127093144154 "$node_(251) setdest 117751 33903 19.0" 
$ns at 745.7788528419193 "$node_(251) setdest 113428 8677 19.0" 
$ns at 794.3261095342251 "$node_(251) setdest 99638 8692 13.0" 
$ns at 378.1706670267714 "$node_(252) setdest 62652 23351 4.0" 
$ns at 424.34649493840004 "$node_(252) setdest 40407 39302 12.0" 
$ns at 515.8427582859829 "$node_(252) setdest 36214 40248 10.0" 
$ns at 549.2041683893906 "$node_(252) setdest 128020 2043 2.0" 
$ns at 582.3071798782355 "$node_(252) setdest 110121 11863 7.0" 
$ns at 630.2838650036279 "$node_(252) setdest 15221 675 3.0" 
$ns at 670.9463825526395 "$node_(252) setdest 49210 26425 18.0" 
$ns at 820.0798909988707 "$node_(252) setdest 19253 33197 7.0" 
$ns at 892.6133290885982 "$node_(252) setdest 37594 41068 10.0" 
$ns at 286.1559462124485 "$node_(253) setdest 121193 37936 16.0" 
$ns at 414.668182682286 "$node_(253) setdest 109134 37959 13.0" 
$ns at 535.1978283817847 "$node_(253) setdest 115526 1154 17.0" 
$ns at 651.3113058848904 "$node_(253) setdest 110628 33978 18.0" 
$ns at 688.4549117197687 "$node_(253) setdest 85019 9077 15.0" 
$ns at 844.1708176202283 "$node_(253) setdest 89490 33429 1.0" 
$ns at 881.2674231427387 "$node_(253) setdest 28544 39479 4.0" 
$ns at 216.87342056790354 "$node_(254) setdest 111101 37185 4.0" 
$ns at 271.39285072515736 "$node_(254) setdest 8311 15101 13.0" 
$ns at 425.9084918844997 "$node_(254) setdest 15211 1678 19.0" 
$ns at 621.7006438491899 "$node_(254) setdest 122287 43946 8.0" 
$ns at 685.4900292618102 "$node_(254) setdest 121566 29009 19.0" 
$ns at 855.8679083537504 "$node_(254) setdest 43502 902 5.0" 
$ns at 229.6024456019849 "$node_(255) setdest 101458 35047 9.0" 
$ns at 300.1149329300053 "$node_(255) setdest 84723 39292 10.0" 
$ns at 398.36544802138417 "$node_(255) setdest 41114 26187 10.0" 
$ns at 498.008080512186 "$node_(255) setdest 12351 10357 19.0" 
$ns at 562.5198861154674 "$node_(255) setdest 45735 37207 14.0" 
$ns at 628.8918356024345 "$node_(255) setdest 60048 15589 9.0" 
$ns at 679.2913413762785 "$node_(255) setdest 32530 29764 19.0" 
$ns at 711.7642552844873 "$node_(255) setdest 105373 40584 19.0" 
$ns at 302.8327060964672 "$node_(256) setdest 62221 25078 14.0" 
$ns at 385.45974376576015 "$node_(256) setdest 94101 28946 18.0" 
$ns at 511.16560509801303 "$node_(256) setdest 101458 2500 9.0" 
$ns at 541.9611177776907 "$node_(256) setdest 130915 28345 7.0" 
$ns at 580.6281911823742 "$node_(256) setdest 114321 24416 10.0" 
$ns at 677.5017690482439 "$node_(256) setdest 87260 23476 13.0" 
$ns at 711.399908004872 "$node_(256) setdest 9575 34844 7.0" 
$ns at 761.8462216720417 "$node_(256) setdest 64585 24775 17.0" 
$ns at 817.1684562740783 "$node_(256) setdest 107962 26721 8.0" 
$ns at 889.3814646798961 "$node_(256) setdest 51934 42079 17.0" 
$ns at 297.8284035311986 "$node_(257) setdest 123846 10155 20.0" 
$ns at 428.57145620613346 "$node_(257) setdest 29348 37491 10.0" 
$ns at 466.5236291550303 "$node_(257) setdest 29863 38468 18.0" 
$ns at 601.7225169457774 "$node_(257) setdest 80847 4240 17.0" 
$ns at 725.6204241259952 "$node_(257) setdest 63467 38244 15.0" 
$ns at 271.53746389363204 "$node_(258) setdest 127250 26860 1.0" 
$ns at 310.8666878711709 "$node_(258) setdest 37714 20616 12.0" 
$ns at 415.8431346977559 "$node_(258) setdest 36836 14347 1.0" 
$ns at 447.291589898759 "$node_(258) setdest 1048 16451 3.0" 
$ns at 502.7391810980419 "$node_(258) setdest 81073 34123 10.0" 
$ns at 553.2521091098201 "$node_(258) setdest 77203 12836 18.0" 
$ns at 615.9972512625349 "$node_(258) setdest 107659 16660 19.0" 
$ns at 729.548372893894 "$node_(258) setdest 74384 34204 13.0" 
$ns at 775.4113313241788 "$node_(258) setdest 121797 43121 6.0" 
$ns at 819.9897566291094 "$node_(258) setdest 74224 18858 1.0" 
$ns at 853.331236651757 "$node_(258) setdest 34153 8145 14.0" 
$ns at 891.4364794979831 "$node_(258) setdest 21459 13433 15.0" 
$ns at 206.11597705202976 "$node_(259) setdest 92133 9694 18.0" 
$ns at 393.9342602342036 "$node_(259) setdest 63894 15359 18.0" 
$ns at 592.2665324004103 "$node_(259) setdest 122442 23740 12.0" 
$ns at 738.3448507199826 "$node_(259) setdest 12734 43740 5.0" 
$ns at 810.8033669968562 "$node_(259) setdest 98900 26506 20.0" 
$ns at 851.0852560485629 "$node_(259) setdest 22028 21936 18.0" 
$ns at 334.39844032820884 "$node_(260) setdest 37007 12936 14.0" 
$ns at 481.43659228283894 "$node_(260) setdest 82165 21568 6.0" 
$ns at 562.8813869692872 "$node_(260) setdest 94147 32739 19.0" 
$ns at 606.039752881442 "$node_(260) setdest 52062 28196 3.0" 
$ns at 639.507197987757 "$node_(260) setdest 68411 19911 10.0" 
$ns at 717.9698886701203 "$node_(260) setdest 96739 38069 15.0" 
$ns at 804.8191358936264 "$node_(260) setdest 4726 37012 17.0" 
$ns at 264.6391123042911 "$node_(261) setdest 15063 38036 7.0" 
$ns at 313.7201382841995 "$node_(261) setdest 38450 26402 19.0" 
$ns at 380.6496334284873 "$node_(261) setdest 56957 38044 2.0" 
$ns at 428.80792583021946 "$node_(261) setdest 94795 6730 3.0" 
$ns at 462.02425947558356 "$node_(261) setdest 119848 20788 14.0" 
$ns at 555.4983740210002 "$node_(261) setdest 94675 14399 5.0" 
$ns at 600.4888569465393 "$node_(261) setdest 82261 13710 5.0" 
$ns at 657.0712411729879 "$node_(261) setdest 94048 14330 2.0" 
$ns at 694.7721644844476 "$node_(261) setdest 29826 26007 1.0" 
$ns at 730.4629499043999 "$node_(261) setdest 4176 39273 19.0" 
$ns at 276.24629428660677 "$node_(262) setdest 128891 31216 12.0" 
$ns at 323.1515302138955 "$node_(262) setdest 61997 44648 17.0" 
$ns at 391.9712811547015 "$node_(262) setdest 65425 7266 9.0" 
$ns at 448.715821541845 "$node_(262) setdest 111214 7441 16.0" 
$ns at 489.79507141722513 "$node_(262) setdest 48114 22012 7.0" 
$ns at 543.5335857246337 "$node_(262) setdest 75507 4 11.0" 
$ns at 587.5355003991662 "$node_(262) setdest 105878 3919 9.0" 
$ns at 627.1720919582967 "$node_(262) setdest 29348 16275 20.0" 
$ns at 819.5010806765789 "$node_(262) setdest 4712 21285 5.0" 
$ns at 892.8635042511277 "$node_(262) setdest 51900 1932 8.0" 
$ns at 252.6185800015599 "$node_(263) setdest 10277 19398 4.0" 
$ns at 303.22341853760565 "$node_(263) setdest 60074 4711 16.0" 
$ns at 383.0270961884644 "$node_(263) setdest 8584 13139 1.0" 
$ns at 421.127246365995 "$node_(263) setdest 70691 8428 6.0" 
$ns at 486.6233995512789 "$node_(263) setdest 30413 5204 10.0" 
$ns at 552.9475747296591 "$node_(263) setdest 41925 39663 15.0" 
$ns at 668.3567685644055 "$node_(263) setdest 79613 29380 17.0" 
$ns at 787.1774831617184 "$node_(263) setdest 37570 12983 19.0" 
$ns at 863.5891246357643 "$node_(263) setdest 109746 21004 1.0" 
$ns at 228.7600683005297 "$node_(264) setdest 56927 8770 4.0" 
$ns at 278.025271472213 "$node_(264) setdest 39320 20734 6.0" 
$ns at 345.25408345681967 "$node_(264) setdest 9959 36178 6.0" 
$ns at 416.6832204675783 "$node_(264) setdest 6182 6495 12.0" 
$ns at 461.60214973747435 "$node_(264) setdest 12342 37859 9.0" 
$ns at 534.8782368061035 "$node_(264) setdest 62194 25214 6.0" 
$ns at 613.676780875908 "$node_(264) setdest 77780 32061 18.0" 
$ns at 667.4410481189979 "$node_(264) setdest 52350 1948 11.0" 
$ns at 788.1434526523769 "$node_(264) setdest 94424 29171 13.0" 
$ns at 220.09712317509312 "$node_(265) setdest 41496 2089 2.0" 
$ns at 268.9754393708823 "$node_(265) setdest 1449 27120 10.0" 
$ns at 340.3402969221454 "$node_(265) setdest 46955 14815 9.0" 
$ns at 370.7382911015526 "$node_(265) setdest 85795 43999 1.0" 
$ns at 407.0385316131316 "$node_(265) setdest 44980 28221 4.0" 
$ns at 445.20649085488725 "$node_(265) setdest 95907 44526 8.0" 
$ns at 502.7236106124744 "$node_(265) setdest 87171 40467 4.0" 
$ns at 570.5870422430277 "$node_(265) setdest 92176 35813 19.0" 
$ns at 733.1586594273326 "$node_(265) setdest 100107 14047 6.0" 
$ns at 819.1190929152496 "$node_(265) setdest 64848 37783 16.0" 
$ns at 855.9272634526737 "$node_(265) setdest 104715 42171 12.0" 
$ns at 230.59022228749546 "$node_(266) setdest 75824 8645 11.0" 
$ns at 300.33777710223046 "$node_(266) setdest 50967 1093 11.0" 
$ns at 396.9512691578948 "$node_(266) setdest 112719 18060 7.0" 
$ns at 467.8939822053902 "$node_(266) setdest 4090 26025 10.0" 
$ns at 500.21235226078016 "$node_(266) setdest 30845 29915 16.0" 
$ns at 669.0666192999082 "$node_(266) setdest 58871 21736 13.0" 
$ns at 790.7534170654286 "$node_(266) setdest 20056 8509 2.0" 
$ns at 838.3124094297787 "$node_(266) setdest 75927 27369 5.0" 
$ns at 889.744654455407 "$node_(266) setdest 101415 43335 10.0" 
$ns at 243.50900374964547 "$node_(267) setdest 4273 30482 13.0" 
$ns at 358.02649504931054 "$node_(267) setdest 99699 31334 11.0" 
$ns at 423.1322402539587 "$node_(267) setdest 134035 35723 15.0" 
$ns at 465.50035576909454 "$node_(267) setdest 2799 24800 3.0" 
$ns at 518.7805163525827 "$node_(267) setdest 41215 16475 8.0" 
$ns at 613.4190772125087 "$node_(267) setdest 94727 18579 9.0" 
$ns at 713.7079340055379 "$node_(267) setdest 125795 35076 19.0" 
$ns at 766.0008034176761 "$node_(267) setdest 57068 10644 6.0" 
$ns at 810.8156198537501 "$node_(267) setdest 59872 28237 2.0" 
$ns at 857.6945214126831 "$node_(267) setdest 56452 23485 19.0" 
$ns at 235.63555462412722 "$node_(268) setdest 89016 12081 18.0" 
$ns at 318.38437017488286 "$node_(268) setdest 124342 41784 17.0" 
$ns at 372.8659954093336 "$node_(268) setdest 5590 13847 13.0" 
$ns at 435.6564828345345 "$node_(268) setdest 131036 21093 9.0" 
$ns at 483.9662087448492 "$node_(268) setdest 74488 11997 9.0" 
$ns at 601.5809225936948 "$node_(268) setdest 46416 39059 9.0" 
$ns at 699.2558151854346 "$node_(268) setdest 107263 3369 6.0" 
$ns at 760.2444142394237 "$node_(268) setdest 89663 9160 17.0" 
$ns at 223.4769865997293 "$node_(269) setdest 20499 41726 14.0" 
$ns at 312.5460834893403 "$node_(269) setdest 56197 1825 20.0" 
$ns at 444.1791185070188 "$node_(269) setdest 94987 5011 18.0" 
$ns at 650.8490712201008 "$node_(269) setdest 75351 6094 7.0" 
$ns at 731.9193449156869 "$node_(269) setdest 40729 1053 20.0" 
$ns at 772.2800773637507 "$node_(269) setdest 114260 40785 15.0" 
$ns at 208.92552445734697 "$node_(270) setdest 116257 31220 13.0" 
$ns at 334.6271703619753 "$node_(270) setdest 94733 34095 12.0" 
$ns at 390.8770478670708 "$node_(270) setdest 18415 2383 1.0" 
$ns at 429.983180711229 "$node_(270) setdest 82820 14782 1.0" 
$ns at 464.08826941433745 "$node_(270) setdest 105401 9501 10.0" 
$ns at 520.3825820615226 "$node_(270) setdest 63679 15215 14.0" 
$ns at 582.3924620879937 "$node_(270) setdest 124049 30982 10.0" 
$ns at 697.2976642882543 "$node_(270) setdest 83095 33215 9.0" 
$ns at 812.5610308838249 "$node_(270) setdest 130090 29037 13.0" 
$ns at 847.9689880753546 "$node_(270) setdest 72016 4257 1.0" 
$ns at 881.8127076519349 "$node_(270) setdest 81982 30909 8.0" 
$ns at 247.74921400326392 "$node_(271) setdest 77705 34032 3.0" 
$ns at 294.6805994460132 "$node_(271) setdest 112742 43673 4.0" 
$ns at 347.1290579824844 "$node_(271) setdest 75229 23343 9.0" 
$ns at 382.515176619984 "$node_(271) setdest 29054 32612 4.0" 
$ns at 415.0520865681389 "$node_(271) setdest 82868 32087 2.0" 
$ns at 455.0501710344133 "$node_(271) setdest 130299 43492 19.0" 
$ns at 514.4933025964675 "$node_(271) setdest 63303 9643 4.0" 
$ns at 570.078968815112 "$node_(271) setdest 72291 3641 1.0" 
$ns at 601.2127148747454 "$node_(271) setdest 17405 5703 7.0" 
$ns at 653.3342771997826 "$node_(271) setdest 70628 27371 7.0" 
$ns at 732.4578381070676 "$node_(271) setdest 82018 12981 3.0" 
$ns at 765.8556361474754 "$node_(271) setdest 124705 9278 19.0" 
$ns at 888.2328381205579 "$node_(271) setdest 102999 4149 4.0" 
$ns at 220.64606941523124 "$node_(272) setdest 15406 5048 18.0" 
$ns at 384.86691623176205 "$node_(272) setdest 15799 35006 12.0" 
$ns at 479.8464036084306 "$node_(272) setdest 104415 6556 10.0" 
$ns at 607.0222293320805 "$node_(272) setdest 77484 31450 3.0" 
$ns at 658.9897789314416 "$node_(272) setdest 61835 15853 2.0" 
$ns at 698.5924192199989 "$node_(272) setdest 79489 30402 14.0" 
$ns at 823.9727895741049 "$node_(272) setdest 4389 10608 19.0" 
$ns at 200.84149548126993 "$node_(273) setdest 51273 44605 19.0" 
$ns at 306.3783092924201 "$node_(273) setdest 90656 29471 2.0" 
$ns at 346.8280824725961 "$node_(273) setdest 99214 14309 13.0" 
$ns at 437.42693246693307 "$node_(273) setdest 67838 35955 13.0" 
$ns at 577.6929611485796 "$node_(273) setdest 79516 8756 12.0" 
$ns at 636.7218746083031 "$node_(273) setdest 64640 16134 3.0" 
$ns at 673.1912041614991 "$node_(273) setdest 88186 11664 18.0" 
$ns at 799.0807734289962 "$node_(273) setdest 71612 36279 1.0" 
$ns at 832.2310331128886 "$node_(273) setdest 2774 22209 8.0" 
$ns at 243.57508114180604 "$node_(274) setdest 118426 7473 8.0" 
$ns at 328.1856040151216 "$node_(274) setdest 9268 8564 11.0" 
$ns at 431.3390516214964 "$node_(274) setdest 116764 40188 3.0" 
$ns at 488.5857970174071 "$node_(274) setdest 17116 34736 2.0" 
$ns at 521.8107712745235 "$node_(274) setdest 110791 16414 16.0" 
$ns at 698.5335656549765 "$node_(274) setdest 26138 12184 18.0" 
$ns at 728.775585040706 "$node_(274) setdest 119188 23767 15.0" 
$ns at 800.4933169944766 "$node_(274) setdest 95911 26769 15.0" 
$ns at 259.88037612516905 "$node_(275) setdest 49367 29664 13.0" 
$ns at 371.558120065335 "$node_(275) setdest 30105 11977 10.0" 
$ns at 432.84297374169705 "$node_(275) setdest 48598 8731 14.0" 
$ns at 483.81949080204726 "$node_(275) setdest 100161 21111 19.0" 
$ns at 686.1669147146176 "$node_(275) setdest 64230 36641 16.0" 
$ns at 787.2237117324361 "$node_(275) setdest 63305 22551 8.0" 
$ns at 854.0544424371103 "$node_(275) setdest 52280 40720 16.0" 
$ns at 220.6508417017468 "$node_(276) setdest 34637 20415 3.0" 
$ns at 255.97837935988835 "$node_(276) setdest 30800 30649 16.0" 
$ns at 372.94195213057975 "$node_(276) setdest 45670 41630 5.0" 
$ns at 444.35786662012606 "$node_(276) setdest 78482 3303 1.0" 
$ns at 475.2316836984179 "$node_(276) setdest 43944 39740 7.0" 
$ns at 515.7181938398994 "$node_(276) setdest 107622 37992 7.0" 
$ns at 571.3171582669065 "$node_(276) setdest 22756 39425 1.0" 
$ns at 610.5549964176012 "$node_(276) setdest 52127 41566 5.0" 
$ns at 665.6992383143647 "$node_(276) setdest 113013 26827 18.0" 
$ns at 736.8939922053083 "$node_(276) setdest 580 18650 1.0" 
$ns at 772.122320442037 "$node_(276) setdest 56367 18978 12.0" 
$ns at 855.7725148594415 "$node_(276) setdest 126231 43115 7.0" 
$ns at 201.4785824414347 "$node_(277) setdest 129317 33175 19.0" 
$ns at 305.5385934213159 "$node_(277) setdest 85406 10068 17.0" 
$ns at 424.0868384859251 "$node_(277) setdest 22227 19909 19.0" 
$ns at 538.1597268818005 "$node_(277) setdest 24525 5871 11.0" 
$ns at 676.0381620654623 "$node_(277) setdest 104554 706 18.0" 
$ns at 733.7110222516874 "$node_(277) setdest 81644 22180 6.0" 
$ns at 813.1655722700084 "$node_(277) setdest 117247 26295 12.0" 
$ns at 850.4034249950147 "$node_(277) setdest 85099 40315 10.0" 
$ns at 204.6143335560558 "$node_(278) setdest 46199 33571 17.0" 
$ns at 360.578953307236 "$node_(278) setdest 62582 44221 12.0" 
$ns at 419.92357002470186 "$node_(278) setdest 24108 33426 15.0" 
$ns at 540.280887175119 "$node_(278) setdest 103892 735 6.0" 
$ns at 601.8934993656844 "$node_(278) setdest 126829 2735 1.0" 
$ns at 636.1389551865292 "$node_(278) setdest 12724 21872 18.0" 
$ns at 786.4091071442125 "$node_(278) setdest 127020 44297 5.0" 
$ns at 833.8009785757824 "$node_(278) setdest 74615 43726 12.0" 
$ns at 244.6294483622995 "$node_(279) setdest 16776 6379 20.0" 
$ns at 367.7057910499534 "$node_(279) setdest 108 36470 3.0" 
$ns at 415.9695672236216 "$node_(279) setdest 59030 15171 5.0" 
$ns at 447.52252437318475 "$node_(279) setdest 69727 22506 15.0" 
$ns at 533.3585881740167 "$node_(279) setdest 108268 43060 1.0" 
$ns at 566.0247375943114 "$node_(279) setdest 70382 23880 1.0" 
$ns at 601.988294656744 "$node_(279) setdest 4336 11009 16.0" 
$ns at 783.6144617356475 "$node_(279) setdest 115315 16787 13.0" 
$ns at 836.5586545941231 "$node_(279) setdest 107894 17935 17.0" 
$ns at 873.8293900653442 "$node_(279) setdest 73515 20666 14.0" 
$ns at 281.48122529780255 "$node_(280) setdest 43634 28606 17.0" 
$ns at 418.11424211164973 "$node_(280) setdest 114576 43338 11.0" 
$ns at 548.4908977006089 "$node_(280) setdest 534 44268 1.0" 
$ns at 579.2854535992034 "$node_(280) setdest 93213 8625 9.0" 
$ns at 674.226235878921 "$node_(280) setdest 40006 40499 12.0" 
$ns at 801.0993962036523 "$node_(280) setdest 22073 27791 9.0" 
$ns at 884.5253679146697 "$node_(280) setdest 125391 26485 19.0" 
$ns at 211.51100513113656 "$node_(281) setdest 60398 25997 17.0" 
$ns at 351.85107032457177 "$node_(281) setdest 77083 28374 19.0" 
$ns at 507.5086002410093 "$node_(281) setdest 4706 27401 13.0" 
$ns at 555.7016300223451 "$node_(281) setdest 29161 3011 1.0" 
$ns at 587.6677488066188 "$node_(281) setdest 29378 7724 10.0" 
$ns at 624.6576100646242 "$node_(281) setdest 88141 17712 18.0" 
$ns at 799.8902561469392 "$node_(281) setdest 122075 25664 19.0" 
$ns at 217.79944300824442 "$node_(282) setdest 58749 2234 4.0" 
$ns at 261.4149519153524 "$node_(282) setdest 71400 42190 17.0" 
$ns at 361.5802505091606 "$node_(282) setdest 70281 41136 11.0" 
$ns at 489.9049914764921 "$node_(282) setdest 29152 41861 6.0" 
$ns at 557.9984567349384 "$node_(282) setdest 8 20519 17.0" 
$ns at 751.7824156264053 "$node_(282) setdest 93472 43435 8.0" 
$ns at 808.8913227454057 "$node_(282) setdest 44451 7808 5.0" 
$ns at 863.5090978810381 "$node_(282) setdest 109955 42301 2.0" 
$ns at 235.76919406724 "$node_(283) setdest 114557 18088 8.0" 
$ns at 325.924415183644 "$node_(283) setdest 132325 18690 1.0" 
$ns at 356.62028856684367 "$node_(283) setdest 27072 26226 1.0" 
$ns at 394.7082509380326 "$node_(283) setdest 2701 9431 15.0" 
$ns at 560.0295977661924 "$node_(283) setdest 106691 11179 17.0" 
$ns at 638.360258491854 "$node_(283) setdest 121431 31631 16.0" 
$ns at 737.8627555293367 "$node_(283) setdest 76877 38513 5.0" 
$ns at 794.5610281329073 "$node_(283) setdest 37148 10372 14.0" 
$ns at 838.948490450468 "$node_(283) setdest 73116 43269 14.0" 
$ns at 881.3823002293825 "$node_(283) setdest 58071 971 10.0" 
$ns at 225.29865348080966 "$node_(284) setdest 66558 27418 18.0" 
$ns at 336.0689631008805 "$node_(284) setdest 114842 22672 6.0" 
$ns at 373.5775008674106 "$node_(284) setdest 75222 38032 6.0" 
$ns at 442.10049759350846 "$node_(284) setdest 125272 18961 11.0" 
$ns at 580.2879130726899 "$node_(284) setdest 48673 35707 17.0" 
$ns at 667.1771216227816 "$node_(284) setdest 6365 12644 19.0" 
$ns at 702.0868328669693 "$node_(284) setdest 12480 38206 1.0" 
$ns at 736.0989622310661 "$node_(284) setdest 3451 39089 13.0" 
$ns at 850.0653083744364 "$node_(284) setdest 23670 42732 10.0" 
$ns at 880.3709005366381 "$node_(284) setdest 54878 37180 8.0" 
$ns at 235.75244564755462 "$node_(285) setdest 104821 28556 10.0" 
$ns at 303.996431519978 "$node_(285) setdest 71553 30027 19.0" 
$ns at 336.08200206538595 "$node_(285) setdest 22628 25109 16.0" 
$ns at 413.2688052761913 "$node_(285) setdest 82649 3452 19.0" 
$ns at 568.0423144144219 "$node_(285) setdest 38874 3764 14.0" 
$ns at 695.293760476085 "$node_(285) setdest 1573 28941 5.0" 
$ns at 733.1031230536412 "$node_(285) setdest 9492 2942 8.0" 
$ns at 821.7481535169958 "$node_(285) setdest 131727 14013 6.0" 
$ns at 869.9028767279183 "$node_(285) setdest 97122 22745 5.0" 
$ns at 234.03003287706076 "$node_(286) setdest 900 8757 1.0" 
$ns at 265.87848512536146 "$node_(286) setdest 129988 31066 16.0" 
$ns at 369.58631420266886 "$node_(286) setdest 32499 38370 18.0" 
$ns at 468.47964040767636 "$node_(286) setdest 58799 30166 14.0" 
$ns at 579.8795758574224 "$node_(286) setdest 23393 5367 2.0" 
$ns at 624.6888923227435 "$node_(286) setdest 81995 1972 19.0" 
$ns at 715.4242736302916 "$node_(286) setdest 129210 37846 13.0" 
$ns at 818.2726092357883 "$node_(286) setdest 72193 8556 9.0" 
$ns at 888.3704374950868 "$node_(286) setdest 81755 42874 11.0" 
$ns at 254.20174070570584 "$node_(287) setdest 30400 22884 20.0" 
$ns at 299.6472514215779 "$node_(287) setdest 105992 11506 9.0" 
$ns at 395.25240016359203 "$node_(287) setdest 6939 44657 6.0" 
$ns at 476.4992212039619 "$node_(287) setdest 78507 22528 9.0" 
$ns at 544.6998476057015 "$node_(287) setdest 112827 36064 7.0" 
$ns at 628.2954778727496 "$node_(287) setdest 105909 6613 15.0" 
$ns at 738.5062354438173 "$node_(287) setdest 2695 37354 19.0" 
$ns at 252.604114399739 "$node_(288) setdest 9058 18564 1.0" 
$ns at 287.09391015186475 "$node_(288) setdest 46826 40832 1.0" 
$ns at 317.3253062656344 "$node_(288) setdest 93821 32241 7.0" 
$ns at 384.8522736164664 "$node_(288) setdest 31681 40761 19.0" 
$ns at 478.08277503489364 "$node_(288) setdest 58928 851 14.0" 
$ns at 568.574778061513 "$node_(288) setdest 127406 24879 2.0" 
$ns at 602.6453233378519 "$node_(288) setdest 70737 23448 20.0" 
$ns at 689.4430249997127 "$node_(288) setdest 47076 9070 16.0" 
$ns at 720.0279440089942 "$node_(288) setdest 96320 25713 3.0" 
$ns at 764.6172400516141 "$node_(288) setdest 97746 31911 20.0" 
$ns at 205.94627303334815 "$node_(289) setdest 12348 12255 10.0" 
$ns at 300.1941453985126 "$node_(289) setdest 125986 16556 17.0" 
$ns at 430.8325534727269 "$node_(289) setdest 73497 21113 15.0" 
$ns at 490.25483833943804 "$node_(289) setdest 112094 38418 4.0" 
$ns at 530.3477269417463 "$node_(289) setdest 100726 43229 10.0" 
$ns at 653.7010831367481 "$node_(289) setdest 22292 18392 2.0" 
$ns at 687.3855904626269 "$node_(289) setdest 5195 7895 12.0" 
$ns at 824.8766362446274 "$node_(289) setdest 73559 36300 11.0" 
$ns at 215.83173441404065 "$node_(290) setdest 73846 12021 20.0" 
$ns at 343.0926110747051 "$node_(290) setdest 125278 36865 4.0" 
$ns at 402.3371652831454 "$node_(290) setdest 34003 14731 11.0" 
$ns at 481.3366449345639 "$node_(290) setdest 62716 37318 4.0" 
$ns at 515.7122307143595 "$node_(290) setdest 98388 29907 7.0" 
$ns at 611.739049580142 "$node_(290) setdest 14239 21604 5.0" 
$ns at 669.6585471316126 "$node_(290) setdest 66476 39960 4.0" 
$ns at 702.7546625840072 "$node_(290) setdest 20862 37694 20.0" 
$ns at 806.8999251900814 "$node_(290) setdest 127016 31709 17.0" 
$ns at 887.3282691436585 "$node_(290) setdest 31087 286 5.0" 
$ns at 233.63292526113725 "$node_(291) setdest 215 40013 11.0" 
$ns at 275.0240508306631 "$node_(291) setdest 9606 7616 19.0" 
$ns at 320.1805296292042 "$node_(291) setdest 25474 31905 7.0" 
$ns at 410.3389016013276 "$node_(291) setdest 113003 40982 1.0" 
$ns at 443.3655131599428 "$node_(291) setdest 126142 36428 16.0" 
$ns at 497.6854102177822 "$node_(291) setdest 48579 3580 18.0" 
$ns at 543.7012321950489 "$node_(291) setdest 115742 17553 20.0" 
$ns at 761.0388175568264 "$node_(291) setdest 2352 5698 10.0" 
$ns at 881.0685312910116 "$node_(291) setdest 91095 36148 14.0" 
$ns at 268.93160007963536 "$node_(292) setdest 109320 11206 13.0" 
$ns at 353.92372049157086 "$node_(292) setdest 243 15042 15.0" 
$ns at 512.4802300676367 "$node_(292) setdest 73375 20282 15.0" 
$ns at 620.9083085934217 "$node_(292) setdest 67531 8106 4.0" 
$ns at 672.9073288419748 "$node_(292) setdest 51836 8735 6.0" 
$ns at 713.589140553649 "$node_(292) setdest 14746 24505 14.0" 
$ns at 858.4456233429391 "$node_(292) setdest 13901 13949 19.0" 
$ns at 274.49270999109143 "$node_(293) setdest 10457 16398 3.0" 
$ns at 323.22196508115854 "$node_(293) setdest 106827 8663 14.0" 
$ns at 356.0624171597709 "$node_(293) setdest 79972 34199 6.0" 
$ns at 425.12717377659703 "$node_(293) setdest 68866 14680 16.0" 
$ns at 612.0645339413308 "$node_(293) setdest 127406 15767 7.0" 
$ns at 697.0369967357724 "$node_(293) setdest 40998 9385 10.0" 
$ns at 772.7467294073532 "$node_(293) setdest 49055 25977 18.0" 
$ns at 231.06433435263114 "$node_(294) setdest 104442 42447 19.0" 
$ns at 416.90653191875225 "$node_(294) setdest 129612 28113 13.0" 
$ns at 464.13807513403515 "$node_(294) setdest 42084 20452 18.0" 
$ns at 603.0552067088197 "$node_(294) setdest 26744 43387 1.0" 
$ns at 641.2212854457682 "$node_(294) setdest 54316 9271 14.0" 
$ns at 805.7449696944223 "$node_(294) setdest 74006 17432 15.0" 
$ns at 289.47384801416456 "$node_(295) setdest 65348 6206 1.0" 
$ns at 324.2767674710328 "$node_(295) setdest 129481 23679 19.0" 
$ns at 377.19688700370534 "$node_(295) setdest 29442 6715 14.0" 
$ns at 492.8804693568508 "$node_(295) setdest 61357 18689 12.0" 
$ns at 626.4294546554503 "$node_(295) setdest 74212 39461 15.0" 
$ns at 796.7143772154732 "$node_(295) setdest 25285 6318 9.0" 
$ns at 890.6905265156587 "$node_(295) setdest 24875 15013 15.0" 
$ns at 234.9199384488959 "$node_(296) setdest 126832 8541 2.0" 
$ns at 282.2755042355111 "$node_(296) setdest 49095 22633 4.0" 
$ns at 338.15712849857795 "$node_(296) setdest 80053 32320 16.0" 
$ns at 405.75451332410813 "$node_(296) setdest 79628 29046 16.0" 
$ns at 555.5531862647417 "$node_(296) setdest 1985 19704 18.0" 
$ns at 622.9253717008082 "$node_(296) setdest 41758 7560 16.0" 
$ns at 669.3196899094141 "$node_(296) setdest 65805 13413 7.0" 
$ns at 714.2470564194442 "$node_(296) setdest 68224 42269 4.0" 
$ns at 767.1022591901235 "$node_(296) setdest 23487 18446 18.0" 
$ns at 214.24667866739637 "$node_(297) setdest 59410 6168 6.0" 
$ns at 269.82397487199233 "$node_(297) setdest 34844 30670 7.0" 
$ns at 320.45209193959323 "$node_(297) setdest 107179 7839 2.0" 
$ns at 361.37776531294156 "$node_(297) setdest 29718 721 19.0" 
$ns at 504.8228810565635 "$node_(297) setdest 28259 38693 6.0" 
$ns at 559.8802936884117 "$node_(297) setdest 83867 27336 1.0" 
$ns at 597.5670529099946 "$node_(297) setdest 132318 6185 20.0" 
$ns at 780.9951453713778 "$node_(297) setdest 16544 23381 7.0" 
$ns at 815.2295085735686 "$node_(297) setdest 61390 41052 15.0" 
$ns at 302.1857367506458 "$node_(298) setdest 73150 14115 6.0" 
$ns at 378.1950764432179 "$node_(298) setdest 50726 12572 17.0" 
$ns at 547.4560402746625 "$node_(298) setdest 36490 13118 11.0" 
$ns at 685.2303656185103 "$node_(298) setdest 9463 9760 3.0" 
$ns at 730.4567460995304 "$node_(298) setdest 17209 14911 8.0" 
$ns at 767.6127583794143 "$node_(298) setdest 41545 30522 19.0" 
$ns at 259.4267872684139 "$node_(299) setdest 1284 4436 1.0" 
$ns at 297.64637713643685 "$node_(299) setdest 76896 31111 12.0" 
$ns at 371.68824155500965 "$node_(299) setdest 132863 20310 3.0" 
$ns at 429.44613880569574 "$node_(299) setdest 69167 32121 10.0" 
$ns at 477.0458654314244 "$node_(299) setdest 53865 3832 9.0" 
$ns at 572.0563381645906 "$node_(299) setdest 111662 39203 13.0" 
$ns at 704.675287009247 "$node_(299) setdest 122180 31009 10.0" 
$ns at 742.641750244287 "$node_(299) setdest 133086 10730 12.0" 
$ns at 808.2481964325314 "$node_(299) setdest 33356 4721 12.0" 
$ns at 439.6233717342494 "$node_(300) setdest 51833 39596 3.0" 
$ns at 479.3228644878914 "$node_(300) setdest 38116 35075 17.0" 
$ns at 528.2603320852025 "$node_(300) setdest 102139 9905 17.0" 
$ns at 622.370130702215 "$node_(300) setdest 40555 645 10.0" 
$ns at 733.1399597361927 "$node_(300) setdest 77120 12555 11.0" 
$ns at 784.8952996634954 "$node_(300) setdest 15878 23677 1.0" 
$ns at 821.5989338281734 "$node_(300) setdest 89614 1710 20.0" 
$ns at 384.0707040946291 "$node_(301) setdest 71943 36035 1.0" 
$ns at 417.80028755209236 "$node_(301) setdest 13176 33209 1.0" 
$ns at 452.4576032299524 "$node_(301) setdest 45789 28720 4.0" 
$ns at 512.965454886948 "$node_(301) setdest 122390 9401 15.0" 
$ns at 649.0880890116317 "$node_(301) setdest 113101 12600 12.0" 
$ns at 761.7271390167269 "$node_(301) setdest 20975 32588 3.0" 
$ns at 817.7183433230446 "$node_(301) setdest 46764 43303 11.0" 
$ns at 313.41923396746506 "$node_(302) setdest 40055 2227 18.0" 
$ns at 467.46535678195505 "$node_(302) setdest 79575 9189 7.0" 
$ns at 540.3399418502098 "$node_(302) setdest 58739 44387 1.0" 
$ns at 572.7123478898145 "$node_(302) setdest 48333 37241 4.0" 
$ns at 635.9882453285325 "$node_(302) setdest 116484 14514 19.0" 
$ns at 672.8942361653243 "$node_(302) setdest 39394 11455 14.0" 
$ns at 778.4714435204403 "$node_(302) setdest 11328 25342 4.0" 
$ns at 847.2155354865633 "$node_(302) setdest 102044 36801 6.0" 
$ns at 879.2441444674647 "$node_(302) setdest 83448 37870 17.0" 
$ns at 311.2208798987499 "$node_(303) setdest 26953 18916 9.0" 
$ns at 391.29583918749285 "$node_(303) setdest 21071 8913 8.0" 
$ns at 474.28056824886494 "$node_(303) setdest 35822 14170 17.0" 
$ns at 602.8792908722314 "$node_(303) setdest 50985 29289 10.0" 
$ns at 673.0984656819041 "$node_(303) setdest 52062 34750 7.0" 
$ns at 715.3358840245635 "$node_(303) setdest 5384 20978 17.0" 
$ns at 750.2860554439751 "$node_(303) setdest 81260 7189 4.0" 
$ns at 786.5207701360054 "$node_(303) setdest 79112 43176 9.0" 
$ns at 885.0292165906134 "$node_(303) setdest 56217 32833 18.0" 
$ns at 359.8266019827508 "$node_(304) setdest 111400 2881 9.0" 
$ns at 395.25840023849753 "$node_(304) setdest 9745 1011 4.0" 
$ns at 432.76741862528587 "$node_(304) setdest 15704 33978 3.0" 
$ns at 479.0806626585899 "$node_(304) setdest 99276 37879 9.0" 
$ns at 532.1848300803588 "$node_(304) setdest 99269 1437 4.0" 
$ns at 571.8926608705482 "$node_(304) setdest 80161 36636 2.0" 
$ns at 613.3406977272042 "$node_(304) setdest 113300 11470 15.0" 
$ns at 722.9778240441345 "$node_(304) setdest 11526 17529 7.0" 
$ns at 775.9953004809637 "$node_(304) setdest 69963 9159 5.0" 
$ns at 810.9558311288831 "$node_(304) setdest 50079 3374 3.0" 
$ns at 867.9030400034537 "$node_(304) setdest 112902 815 10.0" 
$ns at 469.25645037563754 "$node_(305) setdest 115831 19265 19.0" 
$ns at 606.5324384320767 "$node_(305) setdest 73870 6030 1.0" 
$ns at 645.770981938379 "$node_(305) setdest 421 41097 18.0" 
$ns at 724.2200923120788 "$node_(305) setdest 73340 28819 5.0" 
$ns at 756.384031123888 "$node_(305) setdest 99499 3652 8.0" 
$ns at 821.5247095640057 "$node_(305) setdest 53923 6040 15.0" 
$ns at 876.5833960261099 "$node_(305) setdest 1842 17251 14.0" 
$ns at 353.12251437527993 "$node_(306) setdest 89807 20418 17.0" 
$ns at 451.1243876356485 "$node_(306) setdest 90074 39659 14.0" 
$ns at 554.5109287609245 "$node_(306) setdest 3422 3225 14.0" 
$ns at 631.6914498214297 "$node_(306) setdest 104665 39411 7.0" 
$ns at 710.3822170198722 "$node_(306) setdest 57600 19535 1.0" 
$ns at 745.1462642946213 "$node_(306) setdest 71607 22088 1.0" 
$ns at 781.9309365644896 "$node_(306) setdest 13146 14845 2.0" 
$ns at 815.9408770719223 "$node_(306) setdest 37860 29801 1.0" 
$ns at 854.0769255715045 "$node_(306) setdest 128683 32091 7.0" 
$ns at 322.2870212245944 "$node_(307) setdest 122505 17834 11.0" 
$ns at 364.8013472603387 "$node_(307) setdest 9151 32213 19.0" 
$ns at 475.56855844664824 "$node_(307) setdest 73138 16591 7.0" 
$ns at 548.87932568952 "$node_(307) setdest 81462 37444 4.0" 
$ns at 608.7058679545931 "$node_(307) setdest 107930 19658 14.0" 
$ns at 720.1558787179398 "$node_(307) setdest 76752 13014 1.0" 
$ns at 755.2836294512646 "$node_(307) setdest 129873 38412 11.0" 
$ns at 878.6233014006647 "$node_(307) setdest 7119 10778 13.0" 
$ns at 339.05498947160095 "$node_(308) setdest 132057 26831 18.0" 
$ns at 460.3183635637128 "$node_(308) setdest 51793 14072 12.0" 
$ns at 535.0630259686379 "$node_(308) setdest 44592 40975 9.0" 
$ns at 622.8364006642851 "$node_(308) setdest 127209 10794 10.0" 
$ns at 730.6287317281428 "$node_(308) setdest 56299 3242 7.0" 
$ns at 792.1539411429309 "$node_(308) setdest 61214 11667 18.0" 
$ns at 871.6157849467934 "$node_(308) setdest 83757 10840 14.0" 
$ns at 328.7379234732896 "$node_(309) setdest 120502 24311 4.0" 
$ns at 396.30049499741926 "$node_(309) setdest 55583 23875 1.0" 
$ns at 432.5974941340477 "$node_(309) setdest 8822 39478 3.0" 
$ns at 482.5521924560001 "$node_(309) setdest 106457 36867 10.0" 
$ns at 521.9458444013952 "$node_(309) setdest 95595 22617 10.0" 
$ns at 588.6169516904524 "$node_(309) setdest 37520 31007 15.0" 
$ns at 660.8467318742544 "$node_(309) setdest 96307 32952 3.0" 
$ns at 692.0451446730447 "$node_(309) setdest 548 17581 1.0" 
$ns at 730.3348578066909 "$node_(309) setdest 34368 3980 3.0" 
$ns at 779.7032607976194 "$node_(309) setdest 72112 3545 18.0" 
$ns at 311.8025743906392 "$node_(310) setdest 20755 37140 6.0" 
$ns at 351.7484882069353 "$node_(310) setdest 82802 22837 6.0" 
$ns at 403.66723912948936 "$node_(310) setdest 35325 14077 18.0" 
$ns at 508.01503195462595 "$node_(310) setdest 94253 11071 15.0" 
$ns at 661.3180817615881 "$node_(310) setdest 102519 10474 11.0" 
$ns at 718.356664237993 "$node_(310) setdest 52660 41921 6.0" 
$ns at 762.3166117043054 "$node_(310) setdest 6228 34040 11.0" 
$ns at 818.1571617578654 "$node_(310) setdest 3266 33354 7.0" 
$ns at 881.8750833150136 "$node_(310) setdest 114524 32106 13.0" 
$ns at 391.8399481606915 "$node_(311) setdest 99869 20775 5.0" 
$ns at 425.8160971523169 "$node_(311) setdest 123602 19984 11.0" 
$ns at 498.09663184388916 "$node_(311) setdest 51950 41830 17.0" 
$ns at 676.1479240330086 "$node_(311) setdest 96943 7700 1.0" 
$ns at 715.2847728699907 "$node_(311) setdest 105180 35794 1.0" 
$ns at 754.0014786996467 "$node_(311) setdest 1763 1864 11.0" 
$ns at 784.3782121126306 "$node_(311) setdest 34581 43062 18.0" 
$ns at 313.7165244314876 "$node_(312) setdest 88172 26950 9.0" 
$ns at 398.2815852205548 "$node_(312) setdest 70302 4449 15.0" 
$ns at 482.7280291586884 "$node_(312) setdest 5794 34130 17.0" 
$ns at 619.8680355352097 "$node_(312) setdest 45292 26525 7.0" 
$ns at 687.5412402733314 "$node_(312) setdest 99340 35754 6.0" 
$ns at 718.252720759365 "$node_(312) setdest 3250 22992 16.0" 
$ns at 806.8664758925853 "$node_(312) setdest 133869 4405 17.0" 
$ns at 300.0230677847776 "$node_(313) setdest 71298 22401 6.0" 
$ns at 385.81427683637935 "$node_(313) setdest 128669 36620 16.0" 
$ns at 428.4079073199006 "$node_(313) setdest 133276 30536 1.0" 
$ns at 462.9417969349986 "$node_(313) setdest 88752 21508 2.0" 
$ns at 503.2497300955023 "$node_(313) setdest 94293 31320 13.0" 
$ns at 627.4975362494934 "$node_(313) setdest 67741 11400 10.0" 
$ns at 668.4913188356885 "$node_(313) setdest 51518 18077 3.0" 
$ns at 725.3385440459119 "$node_(313) setdest 20648 14519 6.0" 
$ns at 763.8774618760849 "$node_(313) setdest 82256 34677 3.0" 
$ns at 810.7965423579591 "$node_(313) setdest 123341 26229 3.0" 
$ns at 849.0977590834832 "$node_(313) setdest 109884 39789 11.0" 
$ns at 405.9200859944533 "$node_(314) setdest 60238 4111 5.0" 
$ns at 477.77923593447815 "$node_(314) setdest 107256 21499 9.0" 
$ns at 522.3182978979916 "$node_(314) setdest 25178 24514 6.0" 
$ns at 590.856160509804 "$node_(314) setdest 104386 40767 18.0" 
$ns at 791.0135536355276 "$node_(314) setdest 99893 33480 13.0" 
$ns at 325.7931523342224 "$node_(315) setdest 67964 12377 13.0" 
$ns at 371.97778628724893 "$node_(315) setdest 14482 25395 12.0" 
$ns at 463.2109400973935 "$node_(315) setdest 46347 6509 5.0" 
$ns at 511.6828558726901 "$node_(315) setdest 30748 658 11.0" 
$ns at 543.1025572660167 "$node_(315) setdest 112092 9109 4.0" 
$ns at 586.0302548404235 "$node_(315) setdest 78554 42978 1.0" 
$ns at 616.6711268368443 "$node_(315) setdest 842 2048 13.0" 
$ns at 675.3289875654091 "$node_(315) setdest 93282 8616 17.0" 
$ns at 855.7066407995146 "$node_(315) setdest 132506 2478 16.0" 
$ns at 505.963075222675 "$node_(316) setdest 92566 32783 8.0" 
$ns at 599.9517318043767 "$node_(316) setdest 95530 23815 9.0" 
$ns at 649.5750826502729 "$node_(316) setdest 112816 16738 1.0" 
$ns at 684.7213664287266 "$node_(316) setdest 124452 11525 19.0" 
$ns at 854.5961154997451 "$node_(316) setdest 54967 15582 11.0" 
$ns at 356.74993892737297 "$node_(317) setdest 23681 5517 13.0" 
$ns at 430.7928396140834 "$node_(317) setdest 40986 30490 6.0" 
$ns at 495.8583661452502 "$node_(317) setdest 13344 41114 19.0" 
$ns at 528.3311530517298 "$node_(317) setdest 127584 40700 20.0" 
$ns at 561.3189052169744 "$node_(317) setdest 119521 38508 14.0" 
$ns at 722.3234944951386 "$node_(317) setdest 5102 9880 3.0" 
$ns at 759.3796783097481 "$node_(317) setdest 120529 35162 9.0" 
$ns at 844.0851807978079 "$node_(317) setdest 5242 16951 1.0" 
$ns at 883.571710600362 "$node_(317) setdest 25724 28657 15.0" 
$ns at 348.62706586766717 "$node_(318) setdest 9234 12140 16.0" 
$ns at 416.12164895198794 "$node_(318) setdest 98009 33427 6.0" 
$ns at 458.8292600813099 "$node_(318) setdest 75821 5600 6.0" 
$ns at 523.8437389133461 "$node_(318) setdest 97661 11549 1.0" 
$ns at 563.3770611662981 "$node_(318) setdest 128151 26532 3.0" 
$ns at 598.5593780478322 "$node_(318) setdest 14206 18482 1.0" 
$ns at 633.9816946271343 "$node_(318) setdest 67529 10872 3.0" 
$ns at 686.690221711408 "$node_(318) setdest 58150 33641 10.0" 
$ns at 783.1271010184753 "$node_(318) setdest 70877 2440 10.0" 
$ns at 842.6525161787647 "$node_(318) setdest 106289 34883 5.0" 
$ns at 894.2354996222457 "$node_(318) setdest 95465 30070 16.0" 
$ns at 318.02726424659727 "$node_(319) setdest 6660 243 14.0" 
$ns at 391.7993579601042 "$node_(319) setdest 19412 16033 8.0" 
$ns at 459.7978082941703 "$node_(319) setdest 127046 37151 13.0" 
$ns at 600.9868278938492 "$node_(319) setdest 108784 7804 5.0" 
$ns at 642.5387424424403 "$node_(319) setdest 15564 27035 8.0" 
$ns at 721.4990175308174 "$node_(319) setdest 107349 15579 5.0" 
$ns at 778.0330070471034 "$node_(319) setdest 55989 23907 9.0" 
$ns at 886.5497075605379 "$node_(319) setdest 920 7346 1.0" 
$ns at 336.1572964562266 "$node_(320) setdest 87965 21902 17.0" 
$ns at 384.31541326401833 "$node_(320) setdest 9771 40173 9.0" 
$ns at 426.17909246182865 "$node_(320) setdest 77761 41894 1.0" 
$ns at 463.8019834376097 "$node_(320) setdest 130525 35695 18.0" 
$ns at 645.5068080609723 "$node_(320) setdest 62025 42936 6.0" 
$ns at 692.5341633869191 "$node_(320) setdest 30597 29478 7.0" 
$ns at 788.9958262048121 "$node_(320) setdest 29930 37862 18.0" 
$ns at 306.48606303490806 "$node_(321) setdest 78231 14947 3.0" 
$ns at 363.48537538076823 "$node_(321) setdest 21202 26809 3.0" 
$ns at 422.0179089955439 "$node_(321) setdest 25342 26974 1.0" 
$ns at 461.50451018673226 "$node_(321) setdest 108948 44515 8.0" 
$ns at 506.24822917749316 "$node_(321) setdest 25646 33442 5.0" 
$ns at 577.2949394711898 "$node_(321) setdest 67860 3782 8.0" 
$ns at 669.9949948353474 "$node_(321) setdest 81461 29325 1.0" 
$ns at 705.7807378627701 "$node_(321) setdest 71003 29010 16.0" 
$ns at 780.5679225929503 "$node_(321) setdest 5497 32537 6.0" 
$ns at 867.6428995738605 "$node_(321) setdest 10612 35236 5.0" 
$ns at 366.86942170812443 "$node_(322) setdest 70747 18145 18.0" 
$ns at 539.4568299964047 "$node_(322) setdest 101473 20638 8.0" 
$ns at 637.5163164867382 "$node_(322) setdest 49370 19956 3.0" 
$ns at 681.8661270861624 "$node_(322) setdest 36481 13519 17.0" 
$ns at 749.0885888912609 "$node_(322) setdest 63670 36871 19.0" 
$ns at 841.6059408688526 "$node_(322) setdest 54927 25033 2.0" 
$ns at 887.7141857051593 "$node_(322) setdest 24570 3783 8.0" 
$ns at 396.7408433186507 "$node_(323) setdest 48126 16800 12.0" 
$ns at 531.0621720904928 "$node_(323) setdest 59881 2548 1.0" 
$ns at 565.8013394974402 "$node_(323) setdest 17728 10751 4.0" 
$ns at 628.8858850868776 "$node_(323) setdest 8705 26462 3.0" 
$ns at 675.3355020345032 "$node_(323) setdest 7087 1377 20.0" 
$ns at 898.3653428935785 "$node_(323) setdest 18446 11585 18.0" 
$ns at 317.1016619537059 "$node_(324) setdest 43393 2537 1.0" 
$ns at 355.78135043489243 "$node_(324) setdest 45402 36027 15.0" 
$ns at 440.21416555535086 "$node_(324) setdest 34376 17760 19.0" 
$ns at 502.51618010936556 "$node_(324) setdest 116682 14656 4.0" 
$ns at 534.3843364545601 "$node_(324) setdest 38849 35934 16.0" 
$ns at 723.8698907529388 "$node_(324) setdest 67417 31777 8.0" 
$ns at 821.2874140910162 "$node_(324) setdest 92108 13124 5.0" 
$ns at 896.4666709602283 "$node_(324) setdest 57264 41153 16.0" 
$ns at 400.0342062172218 "$node_(325) setdest 99696 5822 4.0" 
$ns at 462.0547175159248 "$node_(325) setdest 122977 34516 9.0" 
$ns at 504.38375849315963 "$node_(325) setdest 43921 18129 12.0" 
$ns at 564.1681468247876 "$node_(325) setdest 109070 7047 20.0" 
$ns at 602.7673719426555 "$node_(325) setdest 122422 11812 13.0" 
$ns at 699.6728935195597 "$node_(325) setdest 12395 2332 6.0" 
$ns at 733.5965029722128 "$node_(325) setdest 119242 5044 6.0" 
$ns at 764.3005366087594 "$node_(325) setdest 35438 37828 6.0" 
$ns at 839.1421876219282 "$node_(325) setdest 130606 11160 19.0" 
$ns at 306.57037375964154 "$node_(326) setdest 37181 20423 16.0" 
$ns at 491.0372809034764 "$node_(326) setdest 87362 22316 16.0" 
$ns at 653.2257847636099 "$node_(326) setdest 123321 23953 18.0" 
$ns at 742.7143728099195 "$node_(326) setdest 2680 38073 13.0" 
$ns at 893.9030039504562 "$node_(326) setdest 239 10388 6.0" 
$ns at 349.573191065512 "$node_(327) setdest 90343 27459 11.0" 
$ns at 432.77760417782406 "$node_(327) setdest 15836 15631 6.0" 
$ns at 484.7555999144251 "$node_(327) setdest 116333 5452 5.0" 
$ns at 548.8816435875603 "$node_(327) setdest 26161 7765 19.0" 
$ns at 628.4626876213938 "$node_(327) setdest 80559 35398 1.0" 
$ns at 659.3534953088177 "$node_(327) setdest 122063 23951 10.0" 
$ns at 740.3198671203903 "$node_(327) setdest 17213 43127 13.0" 
$ns at 863.1580496684638 "$node_(327) setdest 107509 10928 16.0" 
$ns at 384.49804502565104 "$node_(328) setdest 97437 28810 19.0" 
$ns at 505.2458879327185 "$node_(328) setdest 79931 4034 14.0" 
$ns at 563.3342923920492 "$node_(328) setdest 125644 14202 12.0" 
$ns at 595.7567754277002 "$node_(328) setdest 71034 3462 3.0" 
$ns at 637.6024937712023 "$node_(328) setdest 108299 44278 12.0" 
$ns at 778.8179405244256 "$node_(328) setdest 5532 36949 6.0" 
$ns at 838.4025123833596 "$node_(328) setdest 105840 30836 8.0" 
$ns at 336.85232160752565 "$node_(329) setdest 38248 13190 5.0" 
$ns at 393.8548454500095 "$node_(329) setdest 115725 5141 17.0" 
$ns at 590.768083981128 "$node_(329) setdest 12069 39238 16.0" 
$ns at 646.2741759509838 "$node_(329) setdest 12670 32382 17.0" 
$ns at 748.2965163938399 "$node_(329) setdest 104208 327 13.0" 
$ns at 796.155549655449 "$node_(329) setdest 5590 28014 18.0" 
$ns at 320.4948610889083 "$node_(330) setdest 66678 40086 13.0" 
$ns at 353.9037020479732 "$node_(330) setdest 116685 1691 2.0" 
$ns at 400.31760125891367 "$node_(330) setdest 53394 24453 3.0" 
$ns at 455.3761915224118 "$node_(330) setdest 66656 31469 13.0" 
$ns at 559.5537140188153 "$node_(330) setdest 109259 38354 15.0" 
$ns at 723.7644435547993 "$node_(330) setdest 14262 2753 19.0" 
$ns at 831.8997451845119 "$node_(330) setdest 17125 23631 1.0" 
$ns at 866.7975816395069 "$node_(330) setdest 1423 23899 7.0" 
$ns at 334.0215292459512 "$node_(331) setdest 1816 40679 5.0" 
$ns at 386.4019960731534 "$node_(331) setdest 63984 2297 8.0" 
$ns at 443.20935871660674 "$node_(331) setdest 121973 32082 7.0" 
$ns at 506.88884273797873 "$node_(331) setdest 58573 9025 5.0" 
$ns at 559.9577912749587 "$node_(331) setdest 105688 35811 8.0" 
$ns at 666.300451398733 "$node_(331) setdest 86666 27907 18.0" 
$ns at 747.7197529370073 "$node_(331) setdest 35582 33203 2.0" 
$ns at 791.0050082387447 "$node_(331) setdest 96645 1930 17.0" 
$ns at 833.2716184211469 "$node_(331) setdest 34065 8929 11.0" 
$ns at 878.4512847913097 "$node_(331) setdest 124552 4790 4.0" 
$ns at 311.2559256632625 "$node_(332) setdest 35416 13629 1.0" 
$ns at 343.87493996073925 "$node_(332) setdest 90303 19589 6.0" 
$ns at 413.6276429131798 "$node_(332) setdest 31624 34120 16.0" 
$ns at 497.7468678235613 "$node_(332) setdest 120377 3017 1.0" 
$ns at 534.8412194742285 "$node_(332) setdest 98368 18432 15.0" 
$ns at 673.6865818471255 "$node_(332) setdest 44919 20572 19.0" 
$ns at 749.4111349190364 "$node_(332) setdest 20962 38100 4.0" 
$ns at 804.4627937083096 "$node_(332) setdest 62175 31227 17.0" 
$ns at 337.2272860621953 "$node_(333) setdest 56693 36120 17.0" 
$ns at 452.1528377854972 "$node_(333) setdest 55853 30620 11.0" 
$ns at 542.8134510479641 "$node_(333) setdest 24378 8958 14.0" 
$ns at 640.5676243821935 "$node_(333) setdest 115346 9230 2.0" 
$ns at 683.2995554667891 "$node_(333) setdest 72961 15959 6.0" 
$ns at 753.5754743607229 "$node_(333) setdest 77589 26390 15.0" 
$ns at 791.154498916746 "$node_(333) setdest 96627 39466 2.0" 
$ns at 836.2975195439419 "$node_(333) setdest 18867 9767 15.0" 
$ns at 452.943021436414 "$node_(334) setdest 88860 11971 17.0" 
$ns at 618.1631235134487 "$node_(334) setdest 38746 15773 12.0" 
$ns at 754.1784343433759 "$node_(334) setdest 65568 102 15.0" 
$ns at 812.1027747718944 "$node_(334) setdest 9173 1422 15.0" 
$ns at 852.3662467766599 "$node_(334) setdest 18038 25150 5.0" 
$ns at 895.0734461239196 "$node_(334) setdest 110346 7351 19.0" 
$ns at 308.89509190180866 "$node_(335) setdest 68039 20774 1.0" 
$ns at 341.055460176663 "$node_(335) setdest 95242 19639 16.0" 
$ns at 473.72844398507345 "$node_(335) setdest 63536 12432 13.0" 
$ns at 588.5490469092852 "$node_(335) setdest 82072 5451 7.0" 
$ns at 667.8097849743924 "$node_(335) setdest 28131 14823 8.0" 
$ns at 748.4192574987329 "$node_(335) setdest 46221 19359 11.0" 
$ns at 803.9691564494171 "$node_(335) setdest 124231 33735 8.0" 
$ns at 895.1128249335562 "$node_(335) setdest 126012 30889 10.0" 
$ns at 350.3955674515867 "$node_(336) setdest 49414 3982 19.0" 
$ns at 530.9199659075446 "$node_(336) setdest 81717 836 4.0" 
$ns at 594.631671626867 "$node_(336) setdest 42295 16730 17.0" 
$ns at 646.7870977113053 "$node_(336) setdest 32387 24002 15.0" 
$ns at 714.1453198223585 "$node_(336) setdest 68590 39562 9.0" 
$ns at 772.2556059755743 "$node_(336) setdest 91631 43361 16.0" 
$ns at 308.20674717596717 "$node_(337) setdest 62009 25895 9.0" 
$ns at 414.8451805421805 "$node_(337) setdest 101643 7296 9.0" 
$ns at 515.1966400051293 "$node_(337) setdest 20082 16461 15.0" 
$ns at 581.0087439550082 "$node_(337) setdest 42132 8175 6.0" 
$ns at 654.8089207988262 "$node_(337) setdest 93462 17289 17.0" 
$ns at 744.2178942188151 "$node_(337) setdest 97348 31552 17.0" 
$ns at 787.5910458930554 "$node_(337) setdest 109196 6253 14.0" 
$ns at 396.77600955834 "$node_(338) setdest 75400 13266 2.0" 
$ns at 445.7050026949072 "$node_(338) setdest 43521 3920 19.0" 
$ns at 619.5064114842867 "$node_(338) setdest 38084 26588 6.0" 
$ns at 655.9424699309313 "$node_(338) setdest 58586 15347 19.0" 
$ns at 841.0829830695068 "$node_(338) setdest 133855 17713 1.0" 
$ns at 873.8535736560813 "$node_(338) setdest 127464 8416 10.0" 
$ns at 304.1313593485078 "$node_(339) setdest 117834 27293 9.0" 
$ns at 392.03645599303724 "$node_(339) setdest 102884 38832 4.0" 
$ns at 455.55616310719165 "$node_(339) setdest 107152 36875 12.0" 
$ns at 504.1032827603775 "$node_(339) setdest 54933 8887 5.0" 
$ns at 569.3828982314011 "$node_(339) setdest 51283 28295 15.0" 
$ns at 740.0786890546783 "$node_(339) setdest 15493 4715 20.0" 
$ns at 390.1246345488281 "$node_(340) setdest 124766 9346 16.0" 
$ns at 482.49587586511603 "$node_(340) setdest 32735 33594 1.0" 
$ns at 516.7881044076197 "$node_(340) setdest 33292 18223 13.0" 
$ns at 584.6878194829015 "$node_(340) setdest 28574 31049 18.0" 
$ns at 764.1836185240967 "$node_(340) setdest 85440 43091 3.0" 
$ns at 804.2844705099193 "$node_(340) setdest 39284 21348 6.0" 
$ns at 859.7785493024742 "$node_(340) setdest 44550 32678 4.0" 
$ns at 347.8486049503815 "$node_(341) setdest 111987 42838 14.0" 
$ns at 515.6492788737891 "$node_(341) setdest 88406 38963 10.0" 
$ns at 633.8000950062391 "$node_(341) setdest 27700 14895 1.0" 
$ns at 664.6245340534841 "$node_(341) setdest 96743 709 13.0" 
$ns at 771.8526962789256 "$node_(341) setdest 100411 41437 8.0" 
$ns at 851.4066968497858 "$node_(341) setdest 73893 37924 6.0" 
$ns at 892.0227216657822 "$node_(341) setdest 112696 26398 6.0" 
$ns at 383.1594050277174 "$node_(342) setdest 77713 24080 10.0" 
$ns at 446.47668343618136 "$node_(342) setdest 44121 20649 4.0" 
$ns at 503.2378162520044 "$node_(342) setdest 45928 18166 20.0" 
$ns at 666.788739883613 "$node_(342) setdest 45625 8068 1.0" 
$ns at 699.1226350584046 "$node_(342) setdest 65041 31574 13.0" 
$ns at 829.1427019850205 "$node_(342) setdest 50457 21368 6.0" 
$ns at 889.6932867612129 "$node_(342) setdest 60845 32706 2.0" 
$ns at 493.53244495960314 "$node_(343) setdest 63891 22684 14.0" 
$ns at 614.7186549771926 "$node_(343) setdest 104022 14613 5.0" 
$ns at 675.0575940560317 "$node_(343) setdest 49112 36969 5.0" 
$ns at 743.5206883976316 "$node_(343) setdest 44881 36514 15.0" 
$ns at 899.6026024288917 "$node_(343) setdest 77274 36960 2.0" 
$ns at 314.7093785483769 "$node_(344) setdest 116368 14094 11.0" 
$ns at 416.9669076044229 "$node_(344) setdest 68987 9657 11.0" 
$ns at 459.1149388221556 "$node_(344) setdest 55773 29133 3.0" 
$ns at 518.5662872659512 "$node_(344) setdest 73463 6148 3.0" 
$ns at 553.1260092486222 "$node_(344) setdest 75554 9036 14.0" 
$ns at 703.2493570262732 "$node_(344) setdest 792 10721 3.0" 
$ns at 737.3529036986987 "$node_(344) setdest 1852 37315 20.0" 
$ns at 440.3798599172847 "$node_(345) setdest 127897 28674 3.0" 
$ns at 499.74489388342533 "$node_(345) setdest 53823 3277 13.0" 
$ns at 569.2082052321377 "$node_(345) setdest 8917 42952 12.0" 
$ns at 612.3680197179607 "$node_(345) setdest 100492 30404 20.0" 
$ns at 745.8328496427333 "$node_(345) setdest 11039 14012 16.0" 
$ns at 870.6460478429279 "$node_(345) setdest 45551 18764 6.0" 
$ns at 300.14889247120084 "$node_(346) setdest 94140 24120 13.0" 
$ns at 427.35200231352775 "$node_(346) setdest 100956 9172 19.0" 
$ns at 642.4864640037498 "$node_(346) setdest 23692 29084 14.0" 
$ns at 675.5327150679201 "$node_(346) setdest 34634 26796 1.0" 
$ns at 712.8068693068203 "$node_(346) setdest 118990 17905 19.0" 
$ns at 779.3020114275716 "$node_(346) setdest 122923 42357 8.0" 
$ns at 841.486021783588 "$node_(346) setdest 16343 30379 17.0" 
$ns at 338.8749988395465 "$node_(347) setdest 82696 3430 6.0" 
$ns at 424.6996489476527 "$node_(347) setdest 78439 265 7.0" 
$ns at 514.593566645264 "$node_(347) setdest 11648 2155 17.0" 
$ns at 626.8629019248599 "$node_(347) setdest 99959 43389 13.0" 
$ns at 767.2571753844718 "$node_(347) setdest 125171 13719 17.0" 
$ns at 895.6829617320886 "$node_(347) setdest 8295 35913 13.0" 
$ns at 358.7027099329549 "$node_(348) setdest 41575 3483 11.0" 
$ns at 450.06415193807027 "$node_(348) setdest 102724 7445 7.0" 
$ns at 528.0290583799056 "$node_(348) setdest 93677 9232 15.0" 
$ns at 613.3225459860048 "$node_(348) setdest 113866 8204 3.0" 
$ns at 652.1399293004223 "$node_(348) setdest 13699 2083 19.0" 
$ns at 724.4017488266659 "$node_(348) setdest 22812 44615 6.0" 
$ns at 776.9542095622129 "$node_(348) setdest 87640 8995 13.0" 
$ns at 807.9391582525591 "$node_(348) setdest 128513 24750 8.0" 
$ns at 870.4375774686764 "$node_(348) setdest 88730 20825 11.0" 
$ns at 326.60906169056307 "$node_(349) setdest 16544 41504 3.0" 
$ns at 381.29815143162904 "$node_(349) setdest 116043 4370 9.0" 
$ns at 416.1803885764492 "$node_(349) setdest 23318 32719 16.0" 
$ns at 516.1031739002158 "$node_(349) setdest 73401 3162 7.0" 
$ns at 564.5072489683077 "$node_(349) setdest 68321 29731 20.0" 
$ns at 731.0365938093537 "$node_(349) setdest 42844 28757 3.0" 
$ns at 784.6367043096031 "$node_(349) setdest 57255 28770 8.0" 
$ns at 863.2331096087523 "$node_(349) setdest 123819 38144 1.0" 
$ns at 343.555849004857 "$node_(350) setdest 102003 28631 1.0" 
$ns at 377.5353434935574 "$node_(350) setdest 27049 28688 11.0" 
$ns at 466.2885670327563 "$node_(350) setdest 112741 7675 9.0" 
$ns at 508.2939237780295 "$node_(350) setdest 99931 35488 19.0" 
$ns at 646.2825259129227 "$node_(350) setdest 90393 16041 6.0" 
$ns at 694.5522093192147 "$node_(350) setdest 3163 31429 7.0" 
$ns at 792.899392701383 "$node_(350) setdest 62875 41322 15.0" 
$ns at 374.2703428901955 "$node_(351) setdest 81801 44090 11.0" 
$ns at 416.1293670403116 "$node_(351) setdest 71538 38917 7.0" 
$ns at 514.2934554330037 "$node_(351) setdest 72162 20485 11.0" 
$ns at 634.9395939219102 "$node_(351) setdest 114611 25403 3.0" 
$ns at 686.5090034739366 "$node_(351) setdest 127996 28637 1.0" 
$ns at 717.6858798960903 "$node_(351) setdest 88716 34413 16.0" 
$ns at 840.1366907094327 "$node_(351) setdest 31398 40450 14.0" 
$ns at 318.2194670685068 "$node_(352) setdest 47110 37822 1.0" 
$ns at 351.91338619351035 "$node_(352) setdest 109307 4224 18.0" 
$ns at 415.0696019246676 "$node_(352) setdest 36841 38713 14.0" 
$ns at 499.3612723842001 "$node_(352) setdest 934 11127 1.0" 
$ns at 537.2688545557625 "$node_(352) setdest 78044 32131 17.0" 
$ns at 603.9522492642805 "$node_(352) setdest 101217 14885 11.0" 
$ns at 716.7892580699843 "$node_(352) setdest 58820 2150 15.0" 
$ns at 754.5218816951377 "$node_(352) setdest 55549 2871 16.0" 
$ns at 881.6457706905437 "$node_(352) setdest 57669 13857 17.0" 
$ns at 301.64185965110937 "$node_(353) setdest 19406 10934 19.0" 
$ns at 516.7990422011883 "$node_(353) setdest 51367 30336 8.0" 
$ns at 604.0298048537021 "$node_(353) setdest 64624 40291 4.0" 
$ns at 660.2683694004164 "$node_(353) setdest 284 27856 16.0" 
$ns at 837.9231912503749 "$node_(353) setdest 97986 16734 7.0" 
$ns at 874.0554094089131 "$node_(353) setdest 47033 36404 18.0" 
$ns at 318.8948231723177 "$node_(354) setdest 102903 15685 2.0" 
$ns at 363.8427910712056 "$node_(354) setdest 126745 34220 4.0" 
$ns at 412.70094772099964 "$node_(354) setdest 92083 4099 2.0" 
$ns at 458.2401598596557 "$node_(354) setdest 105366 7278 5.0" 
$ns at 497.89267457476535 "$node_(354) setdest 62171 13733 11.0" 
$ns at 552.4057024253534 "$node_(354) setdest 152 8303 13.0" 
$ns at 709.1283549108937 "$node_(354) setdest 89540 2783 9.0" 
$ns at 811.160449329662 "$node_(354) setdest 88404 7387 11.0" 
$ns at 897.9403963070836 "$node_(354) setdest 68401 33150 15.0" 
$ns at 303.51176039097845 "$node_(355) setdest 96143 4689 10.0" 
$ns at 407.4882809627203 "$node_(355) setdest 23144 31644 3.0" 
$ns at 449.848161436254 "$node_(355) setdest 31600 39074 1.0" 
$ns at 488.69845145216556 "$node_(355) setdest 75013 18949 17.0" 
$ns at 600.5584164603287 "$node_(355) setdest 14153 28123 12.0" 
$ns at 663.882478935426 "$node_(355) setdest 10557 21238 3.0" 
$ns at 716.0280688133556 "$node_(355) setdest 49881 26937 18.0" 
$ns at 774.629522000943 "$node_(355) setdest 18791 23211 11.0" 
$ns at 826.6184727604248 "$node_(355) setdest 52267 18133 18.0" 
$ns at 303.9160562794272 "$node_(356) setdest 60822 35064 5.0" 
$ns at 356.8882929945667 "$node_(356) setdest 94280 13237 17.0" 
$ns at 514.1279784335188 "$node_(356) setdest 111999 15507 7.0" 
$ns at 549.0998345539683 "$node_(356) setdest 56769 43006 8.0" 
$ns at 616.193290082724 "$node_(356) setdest 71834 23275 4.0" 
$ns at 650.1252353709245 "$node_(356) setdest 36248 12273 15.0" 
$ns at 787.1626604519847 "$node_(356) setdest 119386 37046 2.0" 
$ns at 817.7809474558146 "$node_(356) setdest 109192 30357 12.0" 
$ns at 369.6331423372885 "$node_(357) setdest 99648 1904 19.0" 
$ns at 507.7595881250617 "$node_(357) setdest 15885 20640 17.0" 
$ns at 570.0035151397966 "$node_(357) setdest 62765 10189 15.0" 
$ns at 662.2564451444688 "$node_(357) setdest 39137 3143 17.0" 
$ns at 800.284190941629 "$node_(357) setdest 8437 12969 6.0" 
$ns at 859.6914085642127 "$node_(357) setdest 121357 10245 8.0" 
$ns at 362.76446548816796 "$node_(358) setdest 80938 13964 2.0" 
$ns at 397.1652362618161 "$node_(358) setdest 7821 10769 7.0" 
$ns at 445.2601094594562 "$node_(358) setdest 92977 43792 10.0" 
$ns at 535.3660978426179 "$node_(358) setdest 111506 21092 12.0" 
$ns at 585.9874168846551 "$node_(358) setdest 41898 5969 10.0" 
$ns at 635.3927449222405 "$node_(358) setdest 70477 3184 10.0" 
$ns at 724.8303042962777 "$node_(358) setdest 78824 10189 15.0" 
$ns at 807.9153849565145 "$node_(358) setdest 129688 19248 3.0" 
$ns at 846.7858353951281 "$node_(358) setdest 104047 42270 8.0" 
$ns at 897.3539413110186 "$node_(358) setdest 75320 30533 20.0" 
$ns at 302.59180083334127 "$node_(359) setdest 34619 26080 1.0" 
$ns at 340.38965609309554 "$node_(359) setdest 58030 18557 17.0" 
$ns at 461.2097112080809 "$node_(359) setdest 19595 30747 1.0" 
$ns at 494.13225202385786 "$node_(359) setdest 89713 13757 1.0" 
$ns at 527.245858263565 "$node_(359) setdest 101531 22389 11.0" 
$ns at 641.0577866899538 "$node_(359) setdest 131060 1129 1.0" 
$ns at 678.2477263710631 "$node_(359) setdest 45662 19458 12.0" 
$ns at 754.7253927320212 "$node_(359) setdest 63012 43297 7.0" 
$ns at 825.0535133964612 "$node_(359) setdest 39615 38799 1.0" 
$ns at 864.972266921911 "$node_(359) setdest 96202 3060 14.0" 
$ns at 322.1126626342062 "$node_(360) setdest 34948 8028 14.0" 
$ns at 376.1264394564668 "$node_(360) setdest 64574 38374 4.0" 
$ns at 437.8977568363905 "$node_(360) setdest 64222 24290 13.0" 
$ns at 474.825284062351 "$node_(360) setdest 29818 14305 1.0" 
$ns at 509.5091839872393 "$node_(360) setdest 22653 19188 7.0" 
$ns at 558.3361085949737 "$node_(360) setdest 129569 6771 14.0" 
$ns at 693.9617589617746 "$node_(360) setdest 115237 37529 4.0" 
$ns at 759.0605044910408 "$node_(360) setdest 91182 7706 16.0" 
$ns at 868.8938212538189 "$node_(360) setdest 125564 36380 10.0" 
$ns at 317.97514907067944 "$node_(361) setdest 62098 31749 17.0" 
$ns at 433.40881654413926 "$node_(361) setdest 107634 14734 4.0" 
$ns at 502.40253074024815 "$node_(361) setdest 124443 27628 7.0" 
$ns at 579.4452199357008 "$node_(361) setdest 2792 26616 12.0" 
$ns at 692.2726579657798 "$node_(361) setdest 52660 7165 1.0" 
$ns at 726.7976611146651 "$node_(361) setdest 31167 2988 9.0" 
$ns at 769.2215303168556 "$node_(361) setdest 82785 43403 4.0" 
$ns at 813.0225561680616 "$node_(361) setdest 68971 21091 3.0" 
$ns at 854.4437259080466 "$node_(361) setdest 48236 38760 1.0" 
$ns at 891.308640095302 "$node_(361) setdest 38566 609 16.0" 
$ns at 351.67695100617937 "$node_(362) setdest 79770 29180 18.0" 
$ns at 446.9293928350101 "$node_(362) setdest 85202 32452 12.0" 
$ns at 545.628658705819 "$node_(362) setdest 133150 30742 2.0" 
$ns at 591.0521812466912 "$node_(362) setdest 7306 42458 16.0" 
$ns at 757.9413840894609 "$node_(362) setdest 2342 34151 19.0" 
$ns at 353.8605797512759 "$node_(363) setdest 111744 27279 9.0" 
$ns at 386.2532773514796 "$node_(363) setdest 39929 43993 2.0" 
$ns at 422.41937306757745 "$node_(363) setdest 8124 22584 7.0" 
$ns at 492.6920147762247 "$node_(363) setdest 115284 29528 20.0" 
$ns at 563.0215708852686 "$node_(363) setdest 105595 5188 2.0" 
$ns at 595.7379782303772 "$node_(363) setdest 60328 21002 10.0" 
$ns at 632.6051679699385 "$node_(363) setdest 61861 19665 4.0" 
$ns at 675.555744277102 "$node_(363) setdest 122403 42500 10.0" 
$ns at 765.0991813621739 "$node_(363) setdest 93121 267 5.0" 
$ns at 841.5917981481091 "$node_(363) setdest 61393 26959 16.0" 
$ns at 874.9954057206294 "$node_(363) setdest 74858 7911 12.0" 
$ns at 306.1793038609598 "$node_(364) setdest 79427 21662 4.0" 
$ns at 368.6251032071598 "$node_(364) setdest 87482 13401 6.0" 
$ns at 447.6580561249831 "$node_(364) setdest 49728 10183 6.0" 
$ns at 495.85354921394605 "$node_(364) setdest 7761 25850 11.0" 
$ns at 617.6841148461345 "$node_(364) setdest 99726 33080 13.0" 
$ns at 742.8388668580442 "$node_(364) setdest 75742 27364 13.0" 
$ns at 857.1331565248004 "$node_(364) setdest 105391 14842 7.0" 
$ns at 393.7368149976729 "$node_(365) setdest 48697 29224 16.0" 
$ns at 437.8738686074186 "$node_(365) setdest 79222 22262 6.0" 
$ns at 473.22383794626484 "$node_(365) setdest 25815 30575 14.0" 
$ns at 608.4260143845154 "$node_(365) setdest 46703 42457 10.0" 
$ns at 650.1359870049248 "$node_(365) setdest 125113 13882 18.0" 
$ns at 819.5569427290579 "$node_(365) setdest 122913 28133 18.0" 
$ns at 339.608295045157 "$node_(366) setdest 99182 33315 14.0" 
$ns at 428.2191818429552 "$node_(366) setdest 1469 3072 11.0" 
$ns at 549.4434092127769 "$node_(366) setdest 63653 20300 17.0" 
$ns at 631.6571450928803 "$node_(366) setdest 25315 28581 19.0" 
$ns at 817.4692186696366 "$node_(366) setdest 105612 13487 19.0" 
$ns at 334.01126670817484 "$node_(367) setdest 63060 14250 17.0" 
$ns at 415.2632174159322 "$node_(367) setdest 124674 28687 17.0" 
$ns at 478.645172070242 "$node_(367) setdest 70537 21408 15.0" 
$ns at 577.5569113209218 "$node_(367) setdest 119367 41212 16.0" 
$ns at 765.0197338543996 "$node_(367) setdest 3016 13006 19.0" 
$ns at 436.26438875462327 "$node_(368) setdest 66064 8116 3.0" 
$ns at 484.11885292511266 "$node_(368) setdest 82287 26138 8.0" 
$ns at 526.0231157422693 "$node_(368) setdest 45840 28736 16.0" 
$ns at 615.3242161651955 "$node_(368) setdest 50771 24456 18.0" 
$ns at 805.802489382339 "$node_(368) setdest 39338 42424 2.0" 
$ns at 843.909669071802 "$node_(368) setdest 5063 14898 14.0" 
$ns at 316.44433443649365 "$node_(369) setdest 64112 30125 1.0" 
$ns at 352.73867349233507 "$node_(369) setdest 111701 8480 1.0" 
$ns at 385.0962496901853 "$node_(369) setdest 19606 25980 18.0" 
$ns at 499.5451671356955 "$node_(369) setdest 21704 33354 2.0" 
$ns at 546.6457760918771 "$node_(369) setdest 10667 34346 1.0" 
$ns at 583.871922759901 "$node_(369) setdest 51621 7545 10.0" 
$ns at 694.5205943346632 "$node_(369) setdest 25727 39908 6.0" 
$ns at 767.460283068584 "$node_(369) setdest 117281 1852 7.0" 
$ns at 827.179919951604 "$node_(369) setdest 126161 11379 10.0" 
$ns at 348.44657370625305 "$node_(370) setdest 43730 39226 3.0" 
$ns at 399.7317514887743 "$node_(370) setdest 107413 21938 2.0" 
$ns at 439.0734938388248 "$node_(370) setdest 99614 9940 7.0" 
$ns at 490.1065761796848 "$node_(370) setdest 102324 8616 12.0" 
$ns at 620.3448857342557 "$node_(370) setdest 50806 43915 14.0" 
$ns at 673.9989504152417 "$node_(370) setdest 107877 9396 8.0" 
$ns at 763.0635528193818 "$node_(370) setdest 51098 38659 10.0" 
$ns at 840.2857847424697 "$node_(370) setdest 1913 23090 14.0" 
$ns at 407.78080158127284 "$node_(371) setdest 56225 28073 19.0" 
$ns at 625.9417988381374 "$node_(371) setdest 71570 23208 5.0" 
$ns at 659.3052168680047 "$node_(371) setdest 43093 25963 12.0" 
$ns at 734.8175148311616 "$node_(371) setdest 4062 37237 18.0" 
$ns at 416.65203716443193 "$node_(372) setdest 28003 11948 1.0" 
$ns at 452.9980374387933 "$node_(372) setdest 10112 27753 3.0" 
$ns at 494.5733473294745 "$node_(372) setdest 57055 36831 10.0" 
$ns at 624.1960322906931 "$node_(372) setdest 35468 3835 9.0" 
$ns at 731.6215863325253 "$node_(372) setdest 59055 44704 13.0" 
$ns at 789.2945760415641 "$node_(372) setdest 16881 29082 18.0" 
$ns at 314.7604901204516 "$node_(373) setdest 83088 29642 8.0" 
$ns at 360.8190704492843 "$node_(373) setdest 14402 1735 11.0" 
$ns at 498.84529852374175 "$node_(373) setdest 18056 15813 18.0" 
$ns at 549.4798792461835 "$node_(373) setdest 130597 21245 13.0" 
$ns at 618.6232305419393 "$node_(373) setdest 120700 17499 17.0" 
$ns at 756.9679841727939 "$node_(373) setdest 38502 36489 10.0" 
$ns at 806.2797238466691 "$node_(373) setdest 88762 34562 11.0" 
$ns at 860.1681218525719 "$node_(373) setdest 26656 27680 17.0" 
$ns at 320.7244486713946 "$node_(374) setdest 93184 15054 14.0" 
$ns at 397.71308633490315 "$node_(374) setdest 19094 28793 20.0" 
$ns at 454.84133238615937 "$node_(374) setdest 90696 15414 17.0" 
$ns at 505.2900363866644 "$node_(374) setdest 71821 38123 19.0" 
$ns at 663.7779226447801 "$node_(374) setdest 46596 3065 1.0" 
$ns at 697.414150464367 "$node_(374) setdest 30598 18563 14.0" 
$ns at 828.0760065224795 "$node_(374) setdest 74529 7626 13.0" 
$ns at 314.7557311281148 "$node_(375) setdest 5783 29819 6.0" 
$ns at 398.9258926138843 "$node_(375) setdest 75417 20718 12.0" 
$ns at 488.42476114345845 "$node_(375) setdest 90261 22684 16.0" 
$ns at 609.7790451994562 "$node_(375) setdest 130871 28136 17.0" 
$ns at 720.4083061963167 "$node_(375) setdest 124743 42349 20.0" 
$ns at 783.5312008777403 "$node_(375) setdest 121892 29363 19.0" 
$ns at 879.2932311237591 "$node_(375) setdest 86016 38539 20.0" 
$ns at 319.6449071106672 "$node_(376) setdest 133010 25445 9.0" 
$ns at 428.1557962353524 "$node_(376) setdest 17450 9974 11.0" 
$ns at 493.81847030920227 "$node_(376) setdest 65865 11639 6.0" 
$ns at 533.2434887104592 "$node_(376) setdest 1764 36436 4.0" 
$ns at 579.5378869751135 "$node_(376) setdest 6270 35618 11.0" 
$ns at 698.857970828639 "$node_(376) setdest 132760 19483 15.0" 
$ns at 865.0152038703341 "$node_(376) setdest 132857 31055 1.0" 
$ns at 896.4039941665117 "$node_(376) setdest 761 31336 13.0" 
$ns at 300.8282703350763 "$node_(377) setdest 41450 14547 8.0" 
$ns at 387.7694175532183 "$node_(377) setdest 56606 28125 6.0" 
$ns at 450.7548226447066 "$node_(377) setdest 70693 7133 17.0" 
$ns at 489.5892950269174 "$node_(377) setdest 38401 15624 12.0" 
$ns at 632.6948713870802 "$node_(377) setdest 106955 9236 11.0" 
$ns at 771.7137113807424 "$node_(377) setdest 66294 31583 3.0" 
$ns at 802.649229625742 "$node_(377) setdest 17653 16325 13.0" 
$ns at 356.6718138147437 "$node_(378) setdest 122677 3432 13.0" 
$ns at 499.2466470004386 "$node_(378) setdest 112426 16729 7.0" 
$ns at 572.0794247887616 "$node_(378) setdest 10476 19802 12.0" 
$ns at 642.2383584469392 "$node_(378) setdest 14378 6487 2.0" 
$ns at 682.798960919383 "$node_(378) setdest 36661 6917 1.0" 
$ns at 716.7550233806863 "$node_(378) setdest 23996 34677 9.0" 
$ns at 751.1941939827725 "$node_(378) setdest 30576 19186 13.0" 
$ns at 830.3137078645262 "$node_(378) setdest 37988 29966 13.0" 
$ns at 319.8998722319431 "$node_(379) setdest 114249 3099 1.0" 
$ns at 359.20923115371215 "$node_(379) setdest 56395 13257 5.0" 
$ns at 424.19013738735305 "$node_(379) setdest 41634 18162 8.0" 
$ns at 514.0206788669368 "$node_(379) setdest 10232 10610 13.0" 
$ns at 638.150032037288 "$node_(379) setdest 42281 36869 18.0" 
$ns at 776.1117277133934 "$node_(379) setdest 129791 9972 7.0" 
$ns at 854.1005429169702 "$node_(379) setdest 70876 27198 14.0" 
$ns at 448.5164267168321 "$node_(380) setdest 4885 9934 5.0" 
$ns at 489.1039877358719 "$node_(380) setdest 50094 14129 9.0" 
$ns at 603.0954875125116 "$node_(380) setdest 36664 27906 5.0" 
$ns at 639.5349518552631 "$node_(380) setdest 117634 1442 4.0" 
$ns at 706.2609451695439 "$node_(380) setdest 98490 36122 7.0" 
$ns at 744.636106895156 "$node_(380) setdest 105872 23759 2.0" 
$ns at 794.1424295978978 "$node_(380) setdest 41940 30127 4.0" 
$ns at 824.8392705470337 "$node_(380) setdest 75859 11345 15.0" 
$ns at 880.186424753298 "$node_(380) setdest 25401 7895 14.0" 
$ns at 303.02756183846856 "$node_(381) setdest 18380 30270 17.0" 
$ns at 386.6766639270896 "$node_(381) setdest 79449 9251 19.0" 
$ns at 453.3641191975022 "$node_(381) setdest 57307 16916 2.0" 
$ns at 483.9066652748345 "$node_(381) setdest 111621 21332 6.0" 
$ns at 518.5101546611194 "$node_(381) setdest 80078 13252 1.0" 
$ns at 557.7367613164304 "$node_(381) setdest 43465 28916 5.0" 
$ns at 620.5352957603727 "$node_(381) setdest 35923 42802 11.0" 
$ns at 734.3888759345364 "$node_(381) setdest 77627 8518 14.0" 
$ns at 882.3604238524847 "$node_(381) setdest 63190 10367 19.0" 
$ns at 355.2962629355249 "$node_(382) setdest 109900 18632 12.0" 
$ns at 453.00915511014045 "$node_(382) setdest 102448 38006 8.0" 
$ns at 491.8791435860452 "$node_(382) setdest 52829 30658 16.0" 
$ns at 602.9890562423413 "$node_(382) setdest 54125 23889 20.0" 
$ns at 669.3628401575052 "$node_(382) setdest 21433 36767 3.0" 
$ns at 712.3235346527655 "$node_(382) setdest 49796 27425 17.0" 
$ns at 897.8858826881703 "$node_(382) setdest 5145 5310 5.0" 
$ns at 321.49345732664716 "$node_(383) setdest 28697 10411 4.0" 
$ns at 361.4255277763932 "$node_(383) setdest 59164 15988 13.0" 
$ns at 410.2501672908213 "$node_(383) setdest 40316 6563 1.0" 
$ns at 447.58860946104403 "$node_(383) setdest 33947 4160 8.0" 
$ns at 555.3718645006513 "$node_(383) setdest 61039 25806 2.0" 
$ns at 595.4152409977053 "$node_(383) setdest 24462 12910 1.0" 
$ns at 629.1836503395966 "$node_(383) setdest 73711 10771 4.0" 
$ns at 659.4605593578743 "$node_(383) setdest 108847 6035 15.0" 
$ns at 819.0492477258275 "$node_(383) setdest 747 11042 3.0" 
$ns at 855.6153740670171 "$node_(383) setdest 108679 14349 17.0" 
$ns at 305.2464116159076 "$node_(384) setdest 10992 35221 7.0" 
$ns at 358.6539263686932 "$node_(384) setdest 90834 23605 12.0" 
$ns at 497.7131748399976 "$node_(384) setdest 18263 19233 1.0" 
$ns at 532.8038663697847 "$node_(384) setdest 43569 7160 10.0" 
$ns at 587.2421568609336 "$node_(384) setdest 125552 44185 8.0" 
$ns at 634.1095892150709 "$node_(384) setdest 110523 14277 17.0" 
$ns at 833.6574166746844 "$node_(384) setdest 127096 32284 8.0" 
$ns at 870.9135528612529 "$node_(384) setdest 60335 19362 2.0" 
$ns at 316.6811002272348 "$node_(385) setdest 12816 7290 5.0" 
$ns at 360.14921447530827 "$node_(385) setdest 23828 29324 11.0" 
$ns at 481.4632029633931 "$node_(385) setdest 10415 41978 12.0" 
$ns at 625.6657151660106 "$node_(385) setdest 36868 44458 8.0" 
$ns at 673.9570904325295 "$node_(385) setdest 48072 42181 2.0" 
$ns at 705.4703387618604 "$node_(385) setdest 71709 19106 13.0" 
$ns at 826.5670930111335 "$node_(385) setdest 104663 11279 2.0" 
$ns at 874.5749878131614 "$node_(385) setdest 60611 9310 9.0" 
$ns at 362.2874422450067 "$node_(386) setdest 101313 21322 7.0" 
$ns at 422.9916224984693 "$node_(386) setdest 82071 33076 3.0" 
$ns at 469.723844654843 "$node_(386) setdest 85060 43810 4.0" 
$ns at 513.2099557920711 "$node_(386) setdest 48321 20507 3.0" 
$ns at 564.5744914067049 "$node_(386) setdest 112823 19297 7.0" 
$ns at 605.1826286091526 "$node_(386) setdest 29359 37864 18.0" 
$ns at 662.7426181764541 "$node_(386) setdest 70197 3430 5.0" 
$ns at 715.2096697380864 "$node_(386) setdest 56158 224 13.0" 
$ns at 787.3017470521486 "$node_(386) setdest 94324 24419 19.0" 
$ns at 821.3499500992367 "$node_(386) setdest 9397 15138 17.0" 
$ns at 889.566698850001 "$node_(386) setdest 2403 41116 15.0" 
$ns at 324.3586847244816 "$node_(387) setdest 50557 10712 1.0" 
$ns at 355.45615698651983 "$node_(387) setdest 50481 28626 17.0" 
$ns at 517.8344299878015 "$node_(387) setdest 30794 20207 14.0" 
$ns at 606.1569909014996 "$node_(387) setdest 28520 5047 5.0" 
$ns at 667.7699458560995 "$node_(387) setdest 4602 44696 13.0" 
$ns at 761.710901466206 "$node_(387) setdest 130289 3751 6.0" 
$ns at 821.7117523934301 "$node_(387) setdest 17155 3768 4.0" 
$ns at 865.9279104150228 "$node_(387) setdest 48588 40710 1.0" 
$ns at 898.7505194692059 "$node_(387) setdest 41984 24886 18.0" 
$ns at 335.60877930526806 "$node_(388) setdest 50606 26781 17.0" 
$ns at 400.0625612219957 "$node_(388) setdest 117965 24249 13.0" 
$ns at 508.652768469429 "$node_(388) setdest 122327 40480 19.0" 
$ns at 605.7990964854547 "$node_(388) setdest 52700 15421 18.0" 
$ns at 659.7646120671791 "$node_(388) setdest 20830 36375 3.0" 
$ns at 708.1074517392783 "$node_(388) setdest 24143 26455 5.0" 
$ns at 771.470433853412 "$node_(388) setdest 61210 36317 2.0" 
$ns at 807.8942366663075 "$node_(388) setdest 62185 29579 17.0" 
$ns at 327.39587602376605 "$node_(389) setdest 17453 37544 4.0" 
$ns at 397.13371179142297 "$node_(389) setdest 120299 34544 18.0" 
$ns at 452.4375647555259 "$node_(389) setdest 87967 42207 14.0" 
$ns at 595.3849450993528 "$node_(389) setdest 59339 28253 5.0" 
$ns at 642.719542061176 "$node_(389) setdest 104092 37145 19.0" 
$ns at 786.27649261009 "$node_(389) setdest 122181 22852 16.0" 
$ns at 897.9563284271542 "$node_(389) setdest 64296 28916 12.0" 
$ns at 350.6135860536913 "$node_(390) setdest 120485 20304 1.0" 
$ns at 387.6486705800064 "$node_(390) setdest 55260 15655 11.0" 
$ns at 467.7974855215791 "$node_(390) setdest 63675 8522 19.0" 
$ns at 606.5954860434724 "$node_(390) setdest 5035 44184 2.0" 
$ns at 655.5165067970586 "$node_(390) setdest 58751 40069 16.0" 
$ns at 700.0489192313717 "$node_(390) setdest 13041 44356 12.0" 
$ns at 779.9462230986029 "$node_(390) setdest 96729 44002 10.0" 
$ns at 880.4580699955948 "$node_(390) setdest 93764 2949 1.0" 
$ns at 315.72926997432455 "$node_(391) setdest 55443 28833 17.0" 
$ns at 433.1987342263767 "$node_(391) setdest 66872 10382 2.0" 
$ns at 463.44898809504207 "$node_(391) setdest 118025 14529 12.0" 
$ns at 496.64506331255757 "$node_(391) setdest 114007 40653 1.0" 
$ns at 531.4458222792933 "$node_(391) setdest 95261 2895 16.0" 
$ns at 688.165645401299 "$node_(391) setdest 71392 7671 14.0" 
$ns at 785.4418887016127 "$node_(391) setdest 81612 17933 4.0" 
$ns at 831.9730021549674 "$node_(391) setdest 42496 26353 2.0" 
$ns at 865.720886310817 "$node_(391) setdest 108932 43066 13.0" 
$ns at 390.7560039418523 "$node_(392) setdest 99715 44013 10.0" 
$ns at 495.7328649042908 "$node_(392) setdest 1124 39231 4.0" 
$ns at 529.0451670461584 "$node_(392) setdest 40222 12717 10.0" 
$ns at 568.0563734945383 "$node_(392) setdest 110964 41732 11.0" 
$ns at 641.1298961388525 "$node_(392) setdest 54673 5752 7.0" 
$ns at 710.2128450563787 "$node_(392) setdest 825 39742 8.0" 
$ns at 743.6503263178773 "$node_(392) setdest 39732 5168 19.0" 
$ns at 833.2360684957722 "$node_(392) setdest 35926 30554 7.0" 
$ns at 354.57583816750355 "$node_(393) setdest 64472 12643 14.0" 
$ns at 462.95335559645434 "$node_(393) setdest 85176 37209 13.0" 
$ns at 600.152202123672 "$node_(393) setdest 128316 31524 10.0" 
$ns at 651.8309044539526 "$node_(393) setdest 116370 28854 9.0" 
$ns at 760.1797716832964 "$node_(393) setdest 16368 26879 18.0" 
$ns at 869.8847688595098 "$node_(393) setdest 79126 37987 6.0" 
$ns at 337.28002055509944 "$node_(394) setdest 92410 4284 3.0" 
$ns at 367.9905870572926 "$node_(394) setdest 34743 9298 18.0" 
$ns at 518.0319944682575 "$node_(394) setdest 105159 40839 12.0" 
$ns at 565.8128794480762 "$node_(394) setdest 17241 39920 9.0" 
$ns at 597.2251145601413 "$node_(394) setdest 74985 17610 2.0" 
$ns at 634.4636875972166 "$node_(394) setdest 105772 41654 3.0" 
$ns at 694.3297261110515 "$node_(394) setdest 58051 24949 3.0" 
$ns at 734.8969562507243 "$node_(394) setdest 4081 5242 2.0" 
$ns at 777.010348684161 "$node_(394) setdest 105082 4120 10.0" 
$ns at 852.9492579952991 "$node_(394) setdest 110537 33516 13.0" 
$ns at 334.8696831797869 "$node_(395) setdest 124392 22178 11.0" 
$ns at 434.64142325409176 "$node_(395) setdest 78217 10127 13.0" 
$ns at 582.3254947712873 "$node_(395) setdest 112180 3042 14.0" 
$ns at 614.5063359474108 "$node_(395) setdest 47988 954 5.0" 
$ns at 650.471859888509 "$node_(395) setdest 23774 15940 16.0" 
$ns at 706.5739623383454 "$node_(395) setdest 81070 12016 2.0" 
$ns at 745.8332182250791 "$node_(395) setdest 49597 13486 12.0" 
$ns at 801.3499804678684 "$node_(395) setdest 110237 5102 3.0" 
$ns at 850.595365167079 "$node_(395) setdest 26386 2244 10.0" 
$ns at 436.98841886810277 "$node_(396) setdest 30549 8088 10.0" 
$ns at 521.660620231414 "$node_(396) setdest 84543 36397 10.0" 
$ns at 650.2206349067294 "$node_(396) setdest 87680 38594 1.0" 
$ns at 689.4621968827172 "$node_(396) setdest 18800 37006 18.0" 
$ns at 747.1532217178303 "$node_(396) setdest 109774 20818 9.0" 
$ns at 822.6859270722716 "$node_(396) setdest 30276 3779 4.0" 
$ns at 868.9840257952254 "$node_(396) setdest 106500 41376 6.0" 
$ns at 366.29095531944654 "$node_(397) setdest 57021 19391 3.0" 
$ns at 423.287904597918 "$node_(397) setdest 82937 620 11.0" 
$ns at 454.35197770044556 "$node_(397) setdest 127107 3048 18.0" 
$ns at 492.3112063307746 "$node_(397) setdest 41488 7376 20.0" 
$ns at 612.2296978668613 "$node_(397) setdest 9869 25470 11.0" 
$ns at 674.6337864765594 "$node_(397) setdest 14532 5871 20.0" 
$ns at 833.027370519183 "$node_(397) setdest 86937 32019 13.0" 
$ns at 393.44300159607485 "$node_(398) setdest 87635 35252 1.0" 
$ns at 426.0388839437741 "$node_(398) setdest 128408 16269 14.0" 
$ns at 475.7075919637442 "$node_(398) setdest 2583 7733 10.0" 
$ns at 563.6667805452836 "$node_(398) setdest 26779 6240 13.0" 
$ns at 654.6148752720693 "$node_(398) setdest 41127 573 15.0" 
$ns at 811.0362214592828 "$node_(398) setdest 28041 25592 11.0" 
$ns at 861.6447917699323 "$node_(398) setdest 81329 38039 9.0" 
$ns at 381.0544038749381 "$node_(399) setdest 34810 16569 3.0" 
$ns at 438.2984541210933 "$node_(399) setdest 75417 5805 16.0" 
$ns at 609.4975396030471 "$node_(399) setdest 59237 7931 12.0" 
$ns at 707.6112516776989 "$node_(399) setdest 65814 37224 8.0" 
$ns at 795.6385241724679 "$node_(399) setdest 39151 1588 12.0" 
$ns at 888.5189399170306 "$node_(399) setdest 35739 42954 16.0" 
$ns at 455.0932692067614 "$node_(400) setdest 22839 19736 18.0" 
$ns at 555.9940190592258 "$node_(400) setdest 79842 30129 1.0" 
$ns at 592.5051987003146 "$node_(400) setdest 124213 37899 3.0" 
$ns at 644.4296428188668 "$node_(400) setdest 58280 6764 5.0" 
$ns at 697.7691373957266 "$node_(400) setdest 36575 39994 19.0" 
$ns at 865.7585012251736 "$node_(400) setdest 17285 19994 3.0" 
$ns at 540.9040406541967 "$node_(401) setdest 132777 24780 16.0" 
$ns at 609.0487605576983 "$node_(401) setdest 17888 16002 17.0" 
$ns at 763.1336206113884 "$node_(401) setdest 9355 32140 1.0" 
$ns at 801.127226541082 "$node_(401) setdest 99686 41226 7.0" 
$ns at 883.7974893092533 "$node_(401) setdest 34023 5201 16.0" 
$ns at 405.5306225549476 "$node_(402) setdest 93841 1871 18.0" 
$ns at 438.05330387051237 "$node_(402) setdest 62059 25975 14.0" 
$ns at 550.2695025154247 "$node_(402) setdest 125834 15611 17.0" 
$ns at 686.4684661412826 "$node_(402) setdest 89122 23744 12.0" 
$ns at 727.1791183513888 "$node_(402) setdest 1328 22866 14.0" 
$ns at 876.4720084533242 "$node_(402) setdest 94104 22313 17.0" 
$ns at 502.36332891931175 "$node_(403) setdest 78480 23576 10.0" 
$ns at 613.2934394888391 "$node_(403) setdest 121567 1623 11.0" 
$ns at 699.5418078002555 "$node_(403) setdest 79650 24935 16.0" 
$ns at 776.0824547537391 "$node_(403) setdest 38126 14981 10.0" 
$ns at 483.2090370964611 "$node_(404) setdest 37526 26381 9.0" 
$ns at 591.7107851806285 "$node_(404) setdest 61358 33330 4.0" 
$ns at 645.7174979126027 "$node_(404) setdest 56064 27444 20.0" 
$ns at 707.4910351995372 "$node_(404) setdest 10602 43228 4.0" 
$ns at 741.6459355134314 "$node_(404) setdest 95564 42268 13.0" 
$ns at 824.1000678875989 "$node_(404) setdest 36257 4752 13.0" 
$ns at 402.73706136883027 "$node_(405) setdest 119098 29986 2.0" 
$ns at 449.29987249864604 "$node_(405) setdest 127718 2840 4.0" 
$ns at 490.0993108091274 "$node_(405) setdest 48132 22129 16.0" 
$ns at 603.5892763865393 "$node_(405) setdest 124124 39616 6.0" 
$ns at 669.7790365021252 "$node_(405) setdest 99147 18636 20.0" 
$ns at 811.2257402831513 "$node_(405) setdest 31457 1566 2.0" 
$ns at 846.559631593197 "$node_(405) setdest 106035 19566 18.0" 
$ns at 427.19337521337377 "$node_(406) setdest 34057 37746 2.0" 
$ns at 468.83209833085067 "$node_(406) setdest 95166 44250 2.0" 
$ns at 502.58277649475605 "$node_(406) setdest 113384 40638 2.0" 
$ns at 539.1593347250665 "$node_(406) setdest 78963 14301 19.0" 
$ns at 676.5941764384685 "$node_(406) setdest 69320 6388 8.0" 
$ns at 749.1409252087931 "$node_(406) setdest 79124 22034 7.0" 
$ns at 784.6667226271408 "$node_(406) setdest 25058 2298 7.0" 
$ns at 868.8318909194722 "$node_(406) setdest 121120 1067 14.0" 
$ns at 540.6851405391207 "$node_(407) setdest 50459 33198 6.0" 
$ns at 589.2417189341111 "$node_(407) setdest 89498 24999 5.0" 
$ns at 668.3847282657647 "$node_(407) setdest 184 29554 7.0" 
$ns at 737.1777689942833 "$node_(407) setdest 126775 40919 4.0" 
$ns at 791.675416914515 "$node_(407) setdest 127061 15253 2.0" 
$ns at 829.1876320160529 "$node_(407) setdest 119744 20627 5.0" 
$ns at 864.0208600087664 "$node_(407) setdest 2814 21527 15.0" 
$ns at 401.1179241865407 "$node_(408) setdest 45421 562 18.0" 
$ns at 440.690905911419 "$node_(408) setdest 13907 43810 19.0" 
$ns at 488.43307618314043 "$node_(408) setdest 3547 27507 13.0" 
$ns at 520.7672735652094 "$node_(408) setdest 103996 21226 15.0" 
$ns at 610.1390081407772 "$node_(408) setdest 46089 41367 1.0" 
$ns at 642.1375821167909 "$node_(408) setdest 121092 38491 12.0" 
$ns at 752.4060586330586 "$node_(408) setdest 25231 33966 17.0" 
$ns at 848.4558243126198 "$node_(408) setdest 58913 23352 14.0" 
$ns at 885.4273232178225 "$node_(408) setdest 112251 7601 17.0" 
$ns at 437.5593603235768 "$node_(409) setdest 82353 20582 1.0" 
$ns at 473.362711922544 "$node_(409) setdest 11396 1409 3.0" 
$ns at 525.8782290584201 "$node_(409) setdest 129757 18530 13.0" 
$ns at 610.0145370625473 "$node_(409) setdest 47187 9362 17.0" 
$ns at 708.711248456252 "$node_(409) setdest 113846 35163 5.0" 
$ns at 779.175728704455 "$node_(409) setdest 5679 18377 7.0" 
$ns at 826.8519332837209 "$node_(409) setdest 57681 38594 13.0" 
$ns at 879.0725041613636 "$node_(409) setdest 104562 26614 1.0" 
$ns at 453.29295542569855 "$node_(410) setdest 5389 6935 7.0" 
$ns at 538.3585462533307 "$node_(410) setdest 73670 9504 3.0" 
$ns at 591.0936716927162 "$node_(410) setdest 87769 40342 14.0" 
$ns at 730.8886212852706 "$node_(410) setdest 130178 20671 8.0" 
$ns at 836.6536710123145 "$node_(410) setdest 103153 21569 2.0" 
$ns at 882.3388630287451 "$node_(410) setdest 120133 42373 19.0" 
$ns at 440.3758002992461 "$node_(411) setdest 62478 1052 12.0" 
$ns at 557.1349939440466 "$node_(411) setdest 33584 18203 20.0" 
$ns at 697.5851944539672 "$node_(411) setdest 113624 39451 19.0" 
$ns at 781.5574664298318 "$node_(411) setdest 3683 5968 7.0" 
$ns at 829.1493225670196 "$node_(411) setdest 52897 22215 14.0" 
$ns at 444.1588093266184 "$node_(412) setdest 109061 17765 16.0" 
$ns at 574.7751812906674 "$node_(412) setdest 89787 31978 10.0" 
$ns at 636.739789774893 "$node_(412) setdest 108720 36261 5.0" 
$ns at 676.279770428155 "$node_(412) setdest 57182 25904 16.0" 
$ns at 844.6583296865412 "$node_(412) setdest 53074 42407 10.0" 
$ns at 898.4310513220164 "$node_(412) setdest 128048 35724 15.0" 
$ns at 425.394981128919 "$node_(413) setdest 28509 14295 11.0" 
$ns at 541.8837448844897 "$node_(413) setdest 91138 43214 18.0" 
$ns at 666.5970131495458 "$node_(413) setdest 11087 19719 14.0" 
$ns at 834.4989607072876 "$node_(413) setdest 47172 10969 6.0" 
$ns at 871.4004683948207 "$node_(413) setdest 57839 28886 19.0" 
$ns at 512.2422432031012 "$node_(414) setdest 15534 22277 6.0" 
$ns at 596.6812857241989 "$node_(414) setdest 27435 23694 16.0" 
$ns at 667.7936040015301 "$node_(414) setdest 117275 27436 19.0" 
$ns at 858.8472599634657 "$node_(414) setdest 16507 251 13.0" 
$ns at 445.4181818128322 "$node_(415) setdest 101110 33525 18.0" 
$ns at 608.0105243317751 "$node_(415) setdest 93009 7378 1.0" 
$ns at 640.8917537343065 "$node_(415) setdest 115037 9406 12.0" 
$ns at 765.5314396073226 "$node_(415) setdest 115576 28961 7.0" 
$ns at 843.516846666515 "$node_(415) setdest 48452 30707 17.0" 
$ns at 895.5422137916563 "$node_(415) setdest 25081 3229 9.0" 
$ns at 454.2646089539784 "$node_(416) setdest 38614 848 19.0" 
$ns at 618.3356005550974 "$node_(416) setdest 53867 16250 5.0" 
$ns at 691.2876342133392 "$node_(416) setdest 34856 43588 2.0" 
$ns at 723.7271331394832 "$node_(416) setdest 51229 24171 14.0" 
$ns at 807.6123049153598 "$node_(416) setdest 78336 14603 2.0" 
$ns at 846.5625912035904 "$node_(416) setdest 23575 18976 19.0" 
$ns at 427.90317370968506 "$node_(417) setdest 106838 276 1.0" 
$ns at 467.65418945665755 "$node_(417) setdest 61364 10501 6.0" 
$ns at 504.9499364478464 "$node_(417) setdest 2199 28551 13.0" 
$ns at 621.0344566171583 "$node_(417) setdest 3117 32939 4.0" 
$ns at 678.0108726376171 "$node_(417) setdest 60778 14417 3.0" 
$ns at 725.4983113862609 "$node_(417) setdest 124079 6809 6.0" 
$ns at 770.3489842890745 "$node_(417) setdest 100277 34638 14.0" 
$ns at 824.1374444102806 "$node_(417) setdest 46801 15749 7.0" 
$ns at 888.0297431799553 "$node_(417) setdest 23472 13701 11.0" 
$ns at 417.2504430880567 "$node_(418) setdest 46852 17735 4.0" 
$ns at 484.2233250643013 "$node_(418) setdest 8383 38167 19.0" 
$ns at 557.9455483046579 "$node_(418) setdest 7951 43341 18.0" 
$ns at 612.8199628286392 "$node_(418) setdest 75309 4561 15.0" 
$ns at 719.4049664475638 "$node_(418) setdest 117291 44046 4.0" 
$ns at 749.6116649716782 "$node_(418) setdest 9128 28372 18.0" 
$ns at 418.1028220735391 "$node_(419) setdest 61873 5128 7.0" 
$ns at 493.94642663402044 "$node_(419) setdest 483 11836 14.0" 
$ns at 534.4469206331199 "$node_(419) setdest 108966 11478 9.0" 
$ns at 568.6144904340257 "$node_(419) setdest 81007 44380 12.0" 
$ns at 698.2119685945861 "$node_(419) setdest 41838 1525 4.0" 
$ns at 755.7511237090258 "$node_(419) setdest 126827 30998 12.0" 
$ns at 868.870961928821 "$node_(419) setdest 129442 8744 6.0" 
$ns at 506.3541605339306 "$node_(420) setdest 62874 5701 8.0" 
$ns at 562.2286186845394 "$node_(420) setdest 85496 35869 7.0" 
$ns at 659.3517834094113 "$node_(420) setdest 8454 12262 11.0" 
$ns at 711.371120390491 "$node_(420) setdest 77675 31432 9.0" 
$ns at 769.0791813066414 "$node_(420) setdest 2163 33667 4.0" 
$ns at 818.2266610164742 "$node_(420) setdest 103055 41412 5.0" 
$ns at 897.5895463476666 "$node_(420) setdest 23783 28487 4.0" 
$ns at 503.57689909043575 "$node_(421) setdest 100971 1088 12.0" 
$ns at 643.7141600615076 "$node_(421) setdest 13369 23018 8.0" 
$ns at 688.1614247128186 "$node_(421) setdest 64389 15003 13.0" 
$ns at 758.4143362249838 "$node_(421) setdest 8408 12517 14.0" 
$ns at 794.104644408684 "$node_(421) setdest 31452 11439 4.0" 
$ns at 826.6396047767654 "$node_(421) setdest 71506 43328 19.0" 
$ns at 894.0836677872977 "$node_(421) setdest 77759 21966 12.0" 
$ns at 545.2996964140718 "$node_(422) setdest 15128 35533 15.0" 
$ns at 720.5795186328745 "$node_(422) setdest 93033 18781 2.0" 
$ns at 767.1183209045666 "$node_(422) setdest 119533 12336 2.0" 
$ns at 810.8983936866033 "$node_(422) setdest 112132 36757 9.0" 
$ns at 888.7098113178308 "$node_(422) setdest 41026 39302 8.0" 
$ns at 427.3639089522035 "$node_(423) setdest 2967 42098 15.0" 
$ns at 577.4324811536972 "$node_(423) setdest 74688 26299 18.0" 
$ns at 696.3432537046959 "$node_(423) setdest 35878 3842 10.0" 
$ns at 770.7574563446399 "$node_(423) setdest 28946 37475 7.0" 
$ns at 837.0791514506618 "$node_(423) setdest 23232 38124 16.0" 
$ns at 452.15890863851916 "$node_(424) setdest 66953 36117 16.0" 
$ns at 502.39012738413294 "$node_(424) setdest 131560 39297 3.0" 
$ns at 558.8860259779807 "$node_(424) setdest 25667 13349 7.0" 
$ns at 644.8133571541521 "$node_(424) setdest 60055 6853 1.0" 
$ns at 683.0471190662939 "$node_(424) setdest 29830 1408 1.0" 
$ns at 714.7106433204664 "$node_(424) setdest 67219 28998 2.0" 
$ns at 764.5239703233362 "$node_(424) setdest 128729 40848 6.0" 
$ns at 851.643338746984 "$node_(424) setdest 78982 3347 9.0" 
$ns at 436.2457305310356 "$node_(425) setdest 91755 39841 10.0" 
$ns at 545.659649081182 "$node_(425) setdest 107715 23163 20.0" 
$ns at 656.0400410398686 "$node_(425) setdest 59166 22670 18.0" 
$ns at 833.887495149399 "$node_(425) setdest 95814 36511 1.0" 
$ns at 866.198144048321 "$node_(425) setdest 9689 18920 9.0" 
$ns at 450.28887550786277 "$node_(426) setdest 44877 1458 9.0" 
$ns at 527.0394862119817 "$node_(426) setdest 78253 117 5.0" 
$ns at 569.8972839379411 "$node_(426) setdest 93035 44187 19.0" 
$ns at 671.188832200955 "$node_(426) setdest 35522 29890 19.0" 
$ns at 811.1318821392803 "$node_(426) setdest 122767 4111 4.0" 
$ns at 878.6754221798024 "$node_(426) setdest 111225 7867 11.0" 
$ns at 402.0473386978191 "$node_(427) setdest 18411 22887 18.0" 
$ns at 499.3550882068645 "$node_(427) setdest 49537 35487 1.0" 
$ns at 534.0346051781053 "$node_(427) setdest 60781 29044 5.0" 
$ns at 565.0156692786924 "$node_(427) setdest 30663 9466 5.0" 
$ns at 611.629824935849 "$node_(427) setdest 114409 5751 11.0" 
$ns at 655.0771767559233 "$node_(427) setdest 89645 42338 20.0" 
$ns at 774.4707855829147 "$node_(427) setdest 28507 26483 15.0" 
$ns at 878.1242506229993 "$node_(427) setdest 43916 20125 16.0" 
$ns at 565.3670910551947 "$node_(428) setdest 104370 7848 1.0" 
$ns at 603.3790566260482 "$node_(428) setdest 89411 11562 17.0" 
$ns at 758.6162020777111 "$node_(428) setdest 130196 22998 13.0" 
$ns at 875.3081972233967 "$node_(428) setdest 79241 11203 13.0" 
$ns at 439.946559724851 "$node_(429) setdest 51525 26195 8.0" 
$ns at 540.2309249329828 "$node_(429) setdest 98314 6926 16.0" 
$ns at 644.170220522644 "$node_(429) setdest 73156 2080 1.0" 
$ns at 674.984528319884 "$node_(429) setdest 15912 7089 3.0" 
$ns at 731.6116285133778 "$node_(429) setdest 73315 12595 15.0" 
$ns at 788.5181696004868 "$node_(429) setdest 108631 16808 2.0" 
$ns at 824.9940443605375 "$node_(429) setdest 126813 32801 6.0" 
$ns at 883.3889096047111 "$node_(429) setdest 41080 12029 14.0" 
$ns at 495.57472948602344 "$node_(430) setdest 96835 23551 13.0" 
$ns at 579.4747455268973 "$node_(430) setdest 106418 9297 18.0" 
$ns at 737.799695012342 "$node_(430) setdest 121916 22437 12.0" 
$ns at 778.612071747971 "$node_(430) setdest 75090 32567 17.0" 
$ns at 825.1370538015128 "$node_(430) setdest 6083 12268 20.0" 
$ns at 413.1726977054307 "$node_(431) setdest 100389 378 17.0" 
$ns at 512.0772192916278 "$node_(431) setdest 34207 18177 5.0" 
$ns at 549.0870044792289 "$node_(431) setdest 95774 17338 15.0" 
$ns at 584.9234580572705 "$node_(431) setdest 58611 25532 17.0" 
$ns at 645.2587674784006 "$node_(431) setdest 107134 2657 8.0" 
$ns at 693.0568048861147 "$node_(431) setdest 63848 25747 8.0" 
$ns at 790.2307429428992 "$node_(431) setdest 83526 19923 3.0" 
$ns at 829.312995146128 "$node_(431) setdest 103213 22234 15.0" 
$ns at 429.469267197323 "$node_(432) setdest 127861 39166 5.0" 
$ns at 500.594988458393 "$node_(432) setdest 16339 747 12.0" 
$ns at 589.9050782303945 "$node_(432) setdest 83889 33497 19.0" 
$ns at 627.259835514899 "$node_(432) setdest 124310 20057 11.0" 
$ns at 733.4707330578991 "$node_(432) setdest 71498 6969 8.0" 
$ns at 824.4933903935485 "$node_(432) setdest 124030 11453 16.0" 
$ns at 402.5989622066708 "$node_(433) setdest 62225 13745 1.0" 
$ns at 433.84730682487213 "$node_(433) setdest 94854 13459 13.0" 
$ns at 507.37397054442255 "$node_(433) setdest 101395 28276 17.0" 
$ns at 601.6558514303232 "$node_(433) setdest 71477 42327 1.0" 
$ns at 634.8590606701109 "$node_(433) setdest 91965 20811 19.0" 
$ns at 840.8496483778484 "$node_(433) setdest 102419 16834 3.0" 
$ns at 872.7481813389325 "$node_(433) setdest 4357 11131 17.0" 
$ns at 524.7139527377589 "$node_(434) setdest 65783 23088 15.0" 
$ns at 619.0765269098762 "$node_(434) setdest 83725 4165 2.0" 
$ns at 649.7782393555743 "$node_(434) setdest 46783 673 8.0" 
$ns at 736.7590166888972 "$node_(434) setdest 53134 8685 1.0" 
$ns at 773.1283043568128 "$node_(434) setdest 59403 11493 1.0" 
$ns at 805.016643641606 "$node_(434) setdest 103833 11414 7.0" 
$ns at 885.7924120650798 "$node_(434) setdest 6972 13327 19.0" 
$ns at 452.4520385498546 "$node_(435) setdest 87220 14175 6.0" 
$ns at 540.7706246424273 "$node_(435) setdest 104902 38357 16.0" 
$ns at 640.3832234430616 "$node_(435) setdest 12029 775 17.0" 
$ns at 715.0716362398331 "$node_(435) setdest 10037 16752 19.0" 
$ns at 745.1508131783565 "$node_(435) setdest 84975 34815 4.0" 
$ns at 776.8691211257127 "$node_(435) setdest 97832 23689 7.0" 
$ns at 873.7803150452613 "$node_(435) setdest 63278 5710 17.0" 
$ns at 422.31745504457433 "$node_(436) setdest 123378 7561 7.0" 
$ns at 459.6476250973781 "$node_(436) setdest 90417 11961 10.0" 
$ns at 557.9777183821626 "$node_(436) setdest 28517 17538 8.0" 
$ns at 609.9410467614177 "$node_(436) setdest 98363 21014 10.0" 
$ns at 690.0027864910697 "$node_(436) setdest 110247 8206 4.0" 
$ns at 740.7506549494658 "$node_(436) setdest 108701 40490 11.0" 
$ns at 823.7899328354438 "$node_(436) setdest 55204 42403 11.0" 
$ns at 487.074140840352 "$node_(437) setdest 76196 37497 12.0" 
$ns at 622.1925929023984 "$node_(437) setdest 52879 41091 12.0" 
$ns at 675.8472719436891 "$node_(437) setdest 7687 26467 18.0" 
$ns at 794.8190430563905 "$node_(437) setdest 60685 41996 20.0" 
$ns at 404.66034458535586 "$node_(438) setdest 7506 34426 1.0" 
$ns at 436.9863429883184 "$node_(438) setdest 87161 9115 19.0" 
$ns at 559.5325562839023 "$node_(438) setdest 52491 8956 9.0" 
$ns at 649.8433890659634 "$node_(438) setdest 68827 39534 13.0" 
$ns at 758.5941502281339 "$node_(438) setdest 63837 43372 18.0" 
$ns at 423.67182813302395 "$node_(439) setdest 46138 17950 13.0" 
$ns at 523.1974322546549 "$node_(439) setdest 117150 11869 9.0" 
$ns at 623.8987783946508 "$node_(439) setdest 92425 30810 2.0" 
$ns at 660.869932931704 "$node_(439) setdest 31694 30829 14.0" 
$ns at 796.8353503941878 "$node_(439) setdest 94218 11333 8.0" 
$ns at 427.40542303315505 "$node_(440) setdest 98198 25359 20.0" 
$ns at 503.49790615629627 "$node_(440) setdest 2254 30397 1.0" 
$ns at 543.4139729754864 "$node_(440) setdest 113769 30565 12.0" 
$ns at 671.8618553070296 "$node_(440) setdest 25328 5505 3.0" 
$ns at 710.1887064823333 "$node_(440) setdest 60302 39996 15.0" 
$ns at 789.5922636180009 "$node_(440) setdest 23817 37343 6.0" 
$ns at 853.3077164972574 "$node_(440) setdest 94283 29363 20.0" 
$ns at 439.6691731206125 "$node_(441) setdest 93361 9363 17.0" 
$ns at 564.8133152729523 "$node_(441) setdest 52334 28455 9.0" 
$ns at 643.1086183362845 "$node_(441) setdest 60604 15869 17.0" 
$ns at 788.1739527125148 "$node_(441) setdest 76826 23125 12.0" 
$ns at 852.7532536569436 "$node_(441) setdest 27696 1196 7.0" 
$ns at 406.4770884709243 "$node_(442) setdest 100005 20635 2.0" 
$ns at 444.8376611699457 "$node_(442) setdest 82180 26454 16.0" 
$ns at 484.6004561725417 "$node_(442) setdest 115181 37923 2.0" 
$ns at 522.0977824946708 "$node_(442) setdest 24405 2375 10.0" 
$ns at 611.3812040268143 "$node_(442) setdest 1666 15086 6.0" 
$ns at 675.1433938397045 "$node_(442) setdest 5919 11309 16.0" 
$ns at 736.3548181369354 "$node_(442) setdest 50191 11201 6.0" 
$ns at 801.2821558040164 "$node_(442) setdest 61666 12506 8.0" 
$ns at 899.9275142268896 "$node_(442) setdest 85191 11017 16.0" 
$ns at 460.6648358792858 "$node_(443) setdest 80789 37405 7.0" 
$ns at 509.92561319156385 "$node_(443) setdest 126959 19107 5.0" 
$ns at 573.1806198133573 "$node_(443) setdest 53007 26213 12.0" 
$ns at 627.7066709189778 "$node_(443) setdest 59651 27682 1.0" 
$ns at 667.0477424551186 "$node_(443) setdest 11698 18140 19.0" 
$ns at 713.6301060970145 "$node_(443) setdest 56608 14861 18.0" 
$ns at 501.28923714756087 "$node_(444) setdest 82974 6182 12.0" 
$ns at 612.0793486777418 "$node_(444) setdest 123657 28832 3.0" 
$ns at 658.7284088671544 "$node_(444) setdest 55158 10652 19.0" 
$ns at 747.9278047924366 "$node_(444) setdest 12792 42737 8.0" 
$ns at 815.4353263756368 "$node_(444) setdest 2806 13960 1.0" 
$ns at 846.8697398902764 "$node_(444) setdest 105056 776 5.0" 
$ns at 474.7692073245721 "$node_(445) setdest 106307 22796 9.0" 
$ns at 506.8467209761761 "$node_(445) setdest 43404 43705 14.0" 
$ns at 598.6621950048458 "$node_(445) setdest 38131 9869 11.0" 
$ns at 684.9714955860203 "$node_(445) setdest 105050 1742 14.0" 
$ns at 719.8647966039254 "$node_(445) setdest 56271 6301 11.0" 
$ns at 806.2858916738198 "$node_(445) setdest 89322 15607 10.0" 
$ns at 850.7894651026648 "$node_(445) setdest 58571 15086 3.0" 
$ns at 895.1613265954282 "$node_(445) setdest 113386 31645 14.0" 
$ns at 423.85810186888534 "$node_(446) setdest 71893 36308 14.0" 
$ns at 501.6703225187679 "$node_(446) setdest 64713 42736 13.0" 
$ns at 565.5969261053693 "$node_(446) setdest 83762 27103 5.0" 
$ns at 631.1106952672751 "$node_(446) setdest 127428 26393 19.0" 
$ns at 740.6344409876422 "$node_(446) setdest 119483 4524 7.0" 
$ns at 810.9556476166089 "$node_(446) setdest 46742 43974 11.0" 
$ns at 851.5992482113761 "$node_(446) setdest 42670 22489 15.0" 
$ns at 460.1297035939365 "$node_(447) setdest 91059 42258 3.0" 
$ns at 506.9916956197276 "$node_(447) setdest 21856 14841 16.0" 
$ns at 667.6877978711279 "$node_(447) setdest 131221 31579 2.0" 
$ns at 715.4167626527915 "$node_(447) setdest 71900 38028 10.0" 
$ns at 765.9928639762891 "$node_(447) setdest 68865 36296 14.0" 
$ns at 449.9087567296155 "$node_(448) setdest 90464 6414 14.0" 
$ns at 503.3810032580992 "$node_(448) setdest 108804 42604 9.0" 
$ns at 534.4662042324388 "$node_(448) setdest 91567 40605 4.0" 
$ns at 564.5936555051969 "$node_(448) setdest 645 42943 1.0" 
$ns at 599.3756041748142 "$node_(448) setdest 74459 1905 11.0" 
$ns at 737.1699175310462 "$node_(448) setdest 19983 32901 2.0" 
$ns at 782.0171791601803 "$node_(448) setdest 67589 13290 1.0" 
$ns at 818.4371548814979 "$node_(448) setdest 88890 27904 13.0" 
$ns at 409.7499739015118 "$node_(449) setdest 7009 24672 5.0" 
$ns at 452.0921213270972 "$node_(449) setdest 72157 11701 12.0" 
$ns at 583.5932972438566 "$node_(449) setdest 80092 4119 8.0" 
$ns at 652.9912102556842 "$node_(449) setdest 117784 34607 4.0" 
$ns at 698.120308758309 "$node_(449) setdest 85904 38072 9.0" 
$ns at 777.4643613895139 "$node_(449) setdest 90673 5469 12.0" 
$ns at 833.6541894108129 "$node_(449) setdest 9735 9672 4.0" 
$ns at 869.9256760380955 "$node_(449) setdest 124919 26850 17.0" 
$ns at 433.8414489594883 "$node_(450) setdest 40308 40865 1.0" 
$ns at 473.75508967486326 "$node_(450) setdest 122399 23664 20.0" 
$ns at 538.1746458918685 "$node_(450) setdest 57965 38399 9.0" 
$ns at 598.7955836271916 "$node_(450) setdest 39841 36986 3.0" 
$ns at 650.1281003726109 "$node_(450) setdest 5418 35464 16.0" 
$ns at 792.6734393335722 "$node_(450) setdest 132880 27623 4.0" 
$ns at 846.1489830965739 "$node_(450) setdest 33936 4702 16.0" 
$ns at 408.1069712844916 "$node_(451) setdest 112570 42858 2.0" 
$ns at 442.4959880699628 "$node_(451) setdest 112946 41903 19.0" 
$ns at 633.9111289536445 "$node_(451) setdest 2262 18999 19.0" 
$ns at 731.3496601495124 "$node_(451) setdest 98430 25003 15.0" 
$ns at 450.415874161717 "$node_(452) setdest 20755 217 14.0" 
$ns at 600.4258917673272 "$node_(452) setdest 15177 13991 11.0" 
$ns at 661.9034206291891 "$node_(452) setdest 128400 25573 1.0" 
$ns at 694.429976876829 "$node_(452) setdest 105893 3770 18.0" 
$ns at 829.3416793978719 "$node_(452) setdest 77268 682 11.0" 
$ns at 440.30833025906884 "$node_(453) setdest 72344 7812 7.0" 
$ns at 493.48194467474787 "$node_(453) setdest 59904 20917 5.0" 
$ns at 561.7993870831789 "$node_(453) setdest 56184 26955 1.0" 
$ns at 594.755109687327 "$node_(453) setdest 76959 35706 9.0" 
$ns at 670.5562125792151 "$node_(453) setdest 10477 20879 5.0" 
$ns at 714.50695292003 "$node_(453) setdest 61694 13554 16.0" 
$ns at 814.6268537322464 "$node_(453) setdest 89564 16449 19.0" 
$ns at 879.0302961501056 "$node_(453) setdest 13254 41928 19.0" 
$ns at 400.0385050347329 "$node_(454) setdest 128721 40543 1.0" 
$ns at 438.4177145884443 "$node_(454) setdest 21875 7751 16.0" 
$ns at 498.1004881405528 "$node_(454) setdest 49588 5187 15.0" 
$ns at 622.22156210182 "$node_(454) setdest 14458 27309 14.0" 
$ns at 770.7821179083985 "$node_(454) setdest 127682 20555 13.0" 
$ns at 437.615542151602 "$node_(455) setdest 102550 12467 13.0" 
$ns at 521.8174704342455 "$node_(455) setdest 85999 29036 13.0" 
$ns at 606.8488047588739 "$node_(455) setdest 120023 13939 3.0" 
$ns at 644.022778920715 "$node_(455) setdest 100655 15070 3.0" 
$ns at 675.9122634838026 "$node_(455) setdest 20651 4132 1.0" 
$ns at 711.9557173928248 "$node_(455) setdest 29392 6753 13.0" 
$ns at 783.9130554286222 "$node_(455) setdest 9545 575 1.0" 
$ns at 820.5508720453802 "$node_(455) setdest 33087 20159 1.0" 
$ns at 858.1470120308179 "$node_(455) setdest 2510 20334 16.0" 
$ns at 544.0159128849458 "$node_(456) setdest 119145 37550 1.0" 
$ns at 581.9705564691366 "$node_(456) setdest 120417 28178 2.0" 
$ns at 627.7160637733934 "$node_(456) setdest 66963 35011 2.0" 
$ns at 668.4592522022531 "$node_(456) setdest 118774 22560 18.0" 
$ns at 810.0605211793829 "$node_(456) setdest 29887 17695 5.0" 
$ns at 863.9333029208224 "$node_(456) setdest 49530 22677 15.0" 
$ns at 495.7685635956721 "$node_(457) setdest 100799 41810 1.0" 
$ns at 528.7081530640213 "$node_(457) setdest 4247 33539 18.0" 
$ns at 717.7902799739072 "$node_(457) setdest 104509 22517 10.0" 
$ns at 787.9436203808278 "$node_(457) setdest 83197 19095 11.0" 
$ns at 883.986649445682 "$node_(457) setdest 120372 15614 9.0" 
$ns at 482.1253278157843 "$node_(458) setdest 85366 21838 20.0" 
$ns at 685.0197176117695 "$node_(458) setdest 3599 6040 8.0" 
$ns at 763.8975490304323 "$node_(458) setdest 19271 34887 10.0" 
$ns at 794.0312226219601 "$node_(458) setdest 66671 27402 2.0" 
$ns at 829.2881683984291 "$node_(458) setdest 104110 37553 17.0" 
$ns at 445.95668587375394 "$node_(459) setdest 80591 40722 18.0" 
$ns at 558.5074154509565 "$node_(459) setdest 6553 26672 14.0" 
$ns at 682.0740473264082 "$node_(459) setdest 57343 2590 19.0" 
$ns at 847.8291925939934 "$node_(459) setdest 25033 38625 12.0" 
$ns at 404.58409333394826 "$node_(460) setdest 22044 22353 8.0" 
$ns at 461.24361826206496 "$node_(460) setdest 131525 8175 11.0" 
$ns at 502.6741376392058 "$node_(460) setdest 3875 27577 9.0" 
$ns at 532.9418969059003 "$node_(460) setdest 77828 27441 15.0" 
$ns at 574.3344641892206 "$node_(460) setdest 2324 14584 7.0" 
$ns at 635.2510294678959 "$node_(460) setdest 110562 16288 20.0" 
$ns at 692.6882912027638 "$node_(460) setdest 105060 8279 17.0" 
$ns at 756.4667717100158 "$node_(460) setdest 126804 9444 3.0" 
$ns at 805.5593506993716 "$node_(460) setdest 31578 6148 10.0" 
$ns at 465.4126763731589 "$node_(461) setdest 125731 4275 10.0" 
$ns at 526.4118901468369 "$node_(461) setdest 69020 5404 17.0" 
$ns at 724.9416844552286 "$node_(461) setdest 69733 44120 13.0" 
$ns at 774.5173120960342 "$node_(461) setdest 84960 5239 11.0" 
$ns at 809.9845040565143 "$node_(461) setdest 65471 981 12.0" 
$ns at 843.5003862418785 "$node_(461) setdest 130572 30920 5.0" 
$ns at 894.2914095183216 "$node_(461) setdest 81111 43593 11.0" 
$ns at 481.05790249484994 "$node_(462) setdest 1631 33786 13.0" 
$ns at 629.6969664450887 "$node_(462) setdest 93035 9998 19.0" 
$ns at 798.7127859841848 "$node_(462) setdest 65969 26516 4.0" 
$ns at 840.4273781933406 "$node_(462) setdest 41702 625 6.0" 
$ns at 898.9372630933665 "$node_(462) setdest 125503 28664 10.0" 
$ns at 473.2024666423936 "$node_(463) setdest 105021 28451 17.0" 
$ns at 550.9391410280294 "$node_(463) setdest 69948 7763 17.0" 
$ns at 660.2157720224046 "$node_(463) setdest 125416 27440 12.0" 
$ns at 742.3306679876968 "$node_(463) setdest 63097 9496 1.0" 
$ns at 779.9312534505076 "$node_(463) setdest 101611 6739 16.0" 
$ns at 873.3543398436616 "$node_(463) setdest 51214 44414 15.0" 
$ns at 410.746140396611 "$node_(464) setdest 7187 25770 18.0" 
$ns at 452.52202442176844 "$node_(464) setdest 124663 15399 13.0" 
$ns at 600.9289254614647 "$node_(464) setdest 99193 40353 17.0" 
$ns at 643.5594636985669 "$node_(464) setdest 27750 9335 16.0" 
$ns at 716.4576406307903 "$node_(464) setdest 124664 37469 9.0" 
$ns at 789.8926867698045 "$node_(464) setdest 25780 41491 12.0" 
$ns at 837.023027599332 "$node_(464) setdest 81498 31523 13.0" 
$ns at 417.2884413303516 "$node_(465) setdest 5205 29256 15.0" 
$ns at 545.8112773569067 "$node_(465) setdest 94678 103 9.0" 
$ns at 622.563472189618 "$node_(465) setdest 131866 3625 16.0" 
$ns at 774.9764036243625 "$node_(465) setdest 63119 44451 11.0" 
$ns at 401.65151198633004 "$node_(466) setdest 82079 13458 6.0" 
$ns at 488.86255750607864 "$node_(466) setdest 87506 39823 16.0" 
$ns at 674.245547198019 "$node_(466) setdest 76369 18741 7.0" 
$ns at 746.9128584767068 "$node_(466) setdest 46653 36787 2.0" 
$ns at 796.8513846792155 "$node_(466) setdest 72735 13287 15.0" 
$ns at 850.8586142095321 "$node_(466) setdest 22007 14756 10.0" 
$ns at 448.8220315811414 "$node_(467) setdest 69126 13383 5.0" 
$ns at 499.5896621712043 "$node_(467) setdest 10936 20952 7.0" 
$ns at 579.0135628205919 "$node_(467) setdest 25660 6904 8.0" 
$ns at 657.4661708822368 "$node_(467) setdest 45728 2812 9.0" 
$ns at 735.6186148264206 "$node_(467) setdest 131388 3999 19.0" 
$ns at 766.0650687548949 "$node_(467) setdest 8681 26017 5.0" 
$ns at 819.9020720204899 "$node_(467) setdest 91177 36749 18.0" 
$ns at 403.34691486976806 "$node_(468) setdest 69096 43898 11.0" 
$ns at 477.3996672103934 "$node_(468) setdest 77441 37265 16.0" 
$ns at 581.9578380492611 "$node_(468) setdest 44220 38135 13.0" 
$ns at 724.2883309326087 "$node_(468) setdest 65461 18300 16.0" 
$ns at 823.2117000139474 "$node_(468) setdest 62705 9908 6.0" 
$ns at 868.8013154519914 "$node_(468) setdest 87669 11757 15.0" 
$ns at 470.6010918007738 "$node_(469) setdest 44596 7663 13.0" 
$ns at 502.90958546496336 "$node_(469) setdest 45448 33628 13.0" 
$ns at 602.5035043897187 "$node_(469) setdest 126400 17066 1.0" 
$ns at 640.7677210453817 "$node_(469) setdest 41206 31546 10.0" 
$ns at 744.3768443406881 "$node_(469) setdest 99438 34287 2.0" 
$ns at 778.8433897599041 "$node_(469) setdest 129386 8273 9.0" 
$ns at 870.9564698231659 "$node_(469) setdest 93291 43054 12.0" 
$ns at 488.81374321140856 "$node_(470) setdest 65396 23598 12.0" 
$ns at 544.4114314948673 "$node_(470) setdest 69656 11540 17.0" 
$ns at 664.8684544609325 "$node_(470) setdest 73271 3284 2.0" 
$ns at 702.8650801449139 "$node_(470) setdest 9570 2957 7.0" 
$ns at 787.4776943651464 "$node_(470) setdest 64287 39019 1.0" 
$ns at 820.902072759703 "$node_(470) setdest 8358 17694 4.0" 
$ns at 870.4752577140225 "$node_(470) setdest 79068 28419 7.0" 
$ns at 487.5400743373647 "$node_(471) setdest 35941 31993 4.0" 
$ns at 541.777698828702 "$node_(471) setdest 96661 17791 9.0" 
$ns at 644.9570596690489 "$node_(471) setdest 47526 44611 19.0" 
$ns at 745.4122282223482 "$node_(471) setdest 15842 6277 1.0" 
$ns at 781.8508334392069 "$node_(471) setdest 60930 4817 19.0" 
$ns at 451.0020775357798 "$node_(472) setdest 65399 7639 14.0" 
$ns at 563.6491251691884 "$node_(472) setdest 108520 543 14.0" 
$ns at 677.894802603313 "$node_(472) setdest 68333 12554 15.0" 
$ns at 741.2893132381788 "$node_(472) setdest 88534 37842 15.0" 
$ns at 844.9412554942494 "$node_(472) setdest 68194 34664 11.0" 
$ns at 484.7764952598063 "$node_(473) setdest 23424 18485 14.0" 
$ns at 635.0757125937596 "$node_(473) setdest 98732 12678 8.0" 
$ns at 711.321777702871 "$node_(473) setdest 132180 41986 11.0" 
$ns at 841.8278524043017 "$node_(473) setdest 87172 37482 1.0" 
$ns at 877.6227667331071 "$node_(473) setdest 38560 41233 8.0" 
$ns at 445.788344239442 "$node_(474) setdest 24110 42873 2.0" 
$ns at 475.9315970330857 "$node_(474) setdest 76650 15212 7.0" 
$ns at 509.9968029530914 "$node_(474) setdest 117320 2012 7.0" 
$ns at 591.5612635021935 "$node_(474) setdest 47590 9236 19.0" 
$ns at 722.5346315847501 "$node_(474) setdest 47012 33334 16.0" 
$ns at 409.98569710085076 "$node_(475) setdest 67868 43674 6.0" 
$ns at 468.46992164673946 "$node_(475) setdest 40944 32183 13.0" 
$ns at 620.9696479543506 "$node_(475) setdest 84492 23097 17.0" 
$ns at 789.8542788505982 "$node_(475) setdest 121397 2578 17.0" 
$ns at 822.4560663556896 "$node_(475) setdest 130049 43669 16.0" 
$ns at 560.6110494480469 "$node_(476) setdest 2653 41262 15.0" 
$ns at 695.2624402923502 "$node_(476) setdest 11551 40348 5.0" 
$ns at 767.5516699973567 "$node_(476) setdest 37184 35448 17.0" 
$ns at 410.59180081735735 "$node_(477) setdest 31982 27399 18.0" 
$ns at 604.0899855154637 "$node_(477) setdest 30046 18258 2.0" 
$ns at 646.8831089923445 "$node_(477) setdest 34074 44253 3.0" 
$ns at 706.2431405103072 "$node_(477) setdest 123483 19691 17.0" 
$ns at 817.5560465415609 "$node_(477) setdest 20393 43991 10.0" 
$ns at 428.28409160920353 "$node_(478) setdest 92742 456 20.0" 
$ns at 637.6601911877781 "$node_(478) setdest 79699 8014 12.0" 
$ns at 755.9616102410857 "$node_(478) setdest 93194 8264 11.0" 
$ns at 849.416881108462 "$node_(478) setdest 59130 23510 6.0" 
$ns at 898.5828069777791 "$node_(478) setdest 126904 39272 3.0" 
$ns at 403.7033808752591 "$node_(479) setdest 57121 29074 4.0" 
$ns at 442.23989878239024 "$node_(479) setdest 122024 13906 18.0" 
$ns at 527.0406719232757 "$node_(479) setdest 133612 23527 3.0" 
$ns at 557.049865476905 "$node_(479) setdest 86581 34921 9.0" 
$ns at 611.592151720088 "$node_(479) setdest 113826 37735 2.0" 
$ns at 656.1240061310845 "$node_(479) setdest 72157 19860 12.0" 
$ns at 793.0377009307383 "$node_(479) setdest 89038 19844 7.0" 
$ns at 864.250896521126 "$node_(479) setdest 131663 6265 12.0" 
$ns at 484.662335274273 "$node_(480) setdest 71791 7248 8.0" 
$ns at 517.9235370792624 "$node_(480) setdest 121345 20207 8.0" 
$ns at 622.3586510955006 "$node_(480) setdest 56158 5347 9.0" 
$ns at 654.9897083753895 "$node_(480) setdest 39084 33978 16.0" 
$ns at 717.7883640177497 "$node_(480) setdest 134059 10389 1.0" 
$ns at 753.9846852441962 "$node_(480) setdest 15033 3749 1.0" 
$ns at 792.6629164102466 "$node_(480) setdest 37803 41994 18.0" 
$ns at 841.2007552313553 "$node_(480) setdest 66066 23913 7.0" 
$ns at 439.7176083593773 "$node_(481) setdest 10880 35803 7.0" 
$ns at 513.688500164585 "$node_(481) setdest 88007 13088 13.0" 
$ns at 582.078590716708 "$node_(481) setdest 19570 42799 3.0" 
$ns at 626.9994466336308 "$node_(481) setdest 82693 3332 19.0" 
$ns at 756.4087703094168 "$node_(481) setdest 23367 43834 17.0" 
$ns at 439.0141799511026 "$node_(482) setdest 111348 15180 10.0" 
$ns at 514.3167950537162 "$node_(482) setdest 66590 5299 18.0" 
$ns at 632.9244090292452 "$node_(482) setdest 24955 532 1.0" 
$ns at 665.5947691116259 "$node_(482) setdest 69774 28068 15.0" 
$ns at 707.2351020316908 "$node_(482) setdest 35072 6251 2.0" 
$ns at 751.9937883606945 "$node_(482) setdest 128427 16115 13.0" 
$ns at 825.1575349551769 "$node_(482) setdest 128480 13849 14.0" 
$ns at 863.2385793244499 "$node_(482) setdest 82934 44356 6.0" 
$ns at 897.2053737449107 "$node_(482) setdest 107822 3865 8.0" 
$ns at 456.0350256965918 "$node_(483) setdest 12719 27516 16.0" 
$ns at 587.8558211203886 "$node_(483) setdest 51997 30337 12.0" 
$ns at 716.9427656309188 "$node_(483) setdest 107692 11784 15.0" 
$ns at 782.2267310017793 "$node_(483) setdest 64533 27143 1.0" 
$ns at 816.9450472487079 "$node_(483) setdest 88208 22639 7.0" 
$ns at 875.1878918427681 "$node_(483) setdest 53369 13446 3.0" 
$ns at 402.82585385240736 "$node_(484) setdest 50397 10187 2.0" 
$ns at 441.5528652384679 "$node_(484) setdest 33993 18414 19.0" 
$ns at 648.2334253741734 "$node_(484) setdest 71125 26387 15.0" 
$ns at 706.5646652445556 "$node_(484) setdest 125751 29642 13.0" 
$ns at 826.1824180967008 "$node_(484) setdest 101747 5697 18.0" 
$ns at 437.8162803490409 "$node_(485) setdest 62687 43247 9.0" 
$ns at 532.5957232689558 "$node_(485) setdest 79747 42788 6.0" 
$ns at 568.0738125354884 "$node_(485) setdest 47072 21870 12.0" 
$ns at 629.4936940212735 "$node_(485) setdest 105564 17504 4.0" 
$ns at 664.9727717410763 "$node_(485) setdest 106983 24163 17.0" 
$ns at 720.047892823953 "$node_(485) setdest 58017 30046 8.0" 
$ns at 782.042608799016 "$node_(485) setdest 96022 20106 18.0" 
$ns at 831.4572392715636 "$node_(485) setdest 62099 3053 3.0" 
$ns at 874.6722329031072 "$node_(485) setdest 28095 21901 6.0" 
$ns at 475.0302549014622 "$node_(486) setdest 115292 6671 1.0" 
$ns at 505.23714017359947 "$node_(486) setdest 8764 41045 5.0" 
$ns at 558.3211476105348 "$node_(486) setdest 28771 27971 1.0" 
$ns at 590.1733821721233 "$node_(486) setdest 103356 1386 4.0" 
$ns at 634.5603871447686 "$node_(486) setdest 50424 29496 8.0" 
$ns at 706.6928178713631 "$node_(486) setdest 22641 11643 15.0" 
$ns at 846.9844983678199 "$node_(486) setdest 126489 30437 1.0" 
$ns at 881.8449632820673 "$node_(486) setdest 9333 15482 8.0" 
$ns at 417.61348215415825 "$node_(487) setdest 123148 41743 10.0" 
$ns at 480.7813556778319 "$node_(487) setdest 8111 12926 17.0" 
$ns at 676.0848258776713 "$node_(487) setdest 107133 21666 19.0" 
$ns at 722.4638198797104 "$node_(487) setdest 105418 16380 3.0" 
$ns at 760.871561237225 "$node_(487) setdest 21112 43695 17.0" 
$ns at 894.9448606659573 "$node_(487) setdest 96392 6102 17.0" 
$ns at 410.3663397341526 "$node_(488) setdest 45820 44631 11.0" 
$ns at 452.0220652930002 "$node_(488) setdest 10628 30537 17.0" 
$ns at 521.3515840383009 "$node_(488) setdest 17266 12258 16.0" 
$ns at 618.3327764835082 "$node_(488) setdest 110290 9874 16.0" 
$ns at 721.7130983366658 "$node_(488) setdest 49207 41101 15.0" 
$ns at 810.0279959001945 "$node_(488) setdest 59433 23178 12.0" 
$ns at 864.7396774025881 "$node_(488) setdest 46716 14342 15.0" 
$ns at 405.9080357195925 "$node_(489) setdest 133047 44005 11.0" 
$ns at 473.2568320904576 "$node_(489) setdest 15352 9018 11.0" 
$ns at 587.9096260093199 "$node_(489) setdest 16676 25373 18.0" 
$ns at 755.7091863759615 "$node_(489) setdest 107599 11489 1.0" 
$ns at 790.417246266931 "$node_(489) setdest 85152 18734 16.0" 
$ns at 435.22782758428104 "$node_(490) setdest 88647 28104 19.0" 
$ns at 481.45605231834173 "$node_(490) setdest 116009 1953 10.0" 
$ns at 587.7397094309579 "$node_(490) setdest 119163 6429 8.0" 
$ns at 643.6974479223111 "$node_(490) setdest 23473 39454 8.0" 
$ns at 713.4282269200257 "$node_(490) setdest 16153 17495 12.0" 
$ns at 859.4034089566985 "$node_(490) setdest 17733 3794 13.0" 
$ns at 482.7723616769841 "$node_(491) setdest 105916 18248 7.0" 
$ns at 578.4600625621504 "$node_(491) setdest 6735 37767 8.0" 
$ns at 637.5731230655424 "$node_(491) setdest 46336 21278 17.0" 
$ns at 677.698441070457 "$node_(491) setdest 65230 8469 18.0" 
$ns at 807.1023106529924 "$node_(491) setdest 72072 39386 14.0" 
$ns at 838.055936870159 "$node_(491) setdest 49362 38800 3.0" 
$ns at 884.2843880425903 "$node_(491) setdest 36982 11885 2.0" 
$ns at 439.68334554029775 "$node_(492) setdest 50871 29651 10.0" 
$ns at 544.4736888236736 "$node_(492) setdest 102379 13120 17.0" 
$ns at 610.0958323807141 "$node_(492) setdest 121952 18454 13.0" 
$ns at 721.1442524903623 "$node_(492) setdest 84004 6414 3.0" 
$ns at 778.2806644992893 "$node_(492) setdest 19150 10975 8.0" 
$ns at 809.5164343809033 "$node_(492) setdest 96301 36660 17.0" 
$ns at 435.8274590699353 "$node_(493) setdest 28810 18283 19.0" 
$ns at 541.435543081687 "$node_(493) setdest 14532 5342 6.0" 
$ns at 601.6097450693449 "$node_(493) setdest 123226 9960 18.0" 
$ns at 759.7783826317568 "$node_(493) setdest 91715 34718 12.0" 
$ns at 800.2257969056884 "$node_(493) setdest 117140 2604 8.0" 
$ns at 830.4450013308988 "$node_(493) setdest 75916 43716 18.0" 
$ns at 882.4530031296919 "$node_(493) setdest 2612 19165 9.0" 
$ns at 441.6928212618411 "$node_(494) setdest 13163 20633 11.0" 
$ns at 565.6875103072097 "$node_(494) setdest 96498 24236 8.0" 
$ns at 665.9686490281485 "$node_(494) setdest 108980 17535 6.0" 
$ns at 739.1113618227189 "$node_(494) setdest 88868 44359 1.0" 
$ns at 775.8456021932886 "$node_(494) setdest 35632 20325 19.0" 
$ns at 857.6296191597002 "$node_(494) setdest 125538 21759 13.0" 
$ns at 433.12582349049416 "$node_(495) setdest 122706 33425 18.0" 
$ns at 545.4389626726538 "$node_(495) setdest 107591 43422 15.0" 
$ns at 604.5667367718772 "$node_(495) setdest 107592 21111 10.0" 
$ns at 694.4348798138418 "$node_(495) setdest 101448 25142 19.0" 
$ns at 773.75390641226 "$node_(495) setdest 116057 2389 14.0" 
$ns at 475.4359085623598 "$node_(496) setdest 33930 8131 1.0" 
$ns at 512.0995691300881 "$node_(496) setdest 20039 37700 4.0" 
$ns at 560.8243394698545 "$node_(496) setdest 51937 5905 2.0" 
$ns at 592.853346770515 "$node_(496) setdest 5930 44677 6.0" 
$ns at 659.3076331005652 "$node_(496) setdest 42846 17044 16.0" 
$ns at 729.5497160935868 "$node_(496) setdest 110419 27145 4.0" 
$ns at 770.7395238110156 "$node_(496) setdest 10102 21956 7.0" 
$ns at 854.073239187629 "$node_(496) setdest 21517 8587 19.0" 
$ns at 471.83706589672175 "$node_(497) setdest 117635 13987 3.0" 
$ns at 513.9987438308344 "$node_(497) setdest 67516 38555 12.0" 
$ns at 562.2009630149619 "$node_(497) setdest 75330 29790 7.0" 
$ns at 598.9195845910324 "$node_(497) setdest 95936 11622 18.0" 
$ns at 802.5630036863604 "$node_(497) setdest 92097 21468 5.0" 
$ns at 874.4074846497557 "$node_(497) setdest 2566 21119 7.0" 
$ns at 461.28345662998856 "$node_(498) setdest 18141 9669 5.0" 
$ns at 524.0495617584639 "$node_(498) setdest 93401 7194 3.0" 
$ns at 565.4544119392081 "$node_(498) setdest 109937 2422 14.0" 
$ns at 627.8347718262758 "$node_(498) setdest 121830 16694 16.0" 
$ns at 785.1515943735362 "$node_(498) setdest 69310 22295 9.0" 
$ns at 866.0443848810576 "$node_(498) setdest 72611 35515 9.0" 
$ns at 533.7515123298241 "$node_(499) setdest 87130 12632 18.0" 
$ns at 627.8412774415934 "$node_(499) setdest 110772 44607 10.0" 
$ns at 675.217718621921 "$node_(499) setdest 66400 9217 13.0" 
$ns at 787.5760538336425 "$node_(499) setdest 131640 37492 8.0" 
$ns at 881.6482928810349 "$node_(499) setdest 48865 30493 1.0" 
$ns at 500.696559614378 "$node_(500) setdest 124138 21054 6.0" 
$ns at 586.8792943552937 "$node_(500) setdest 10487 16765 19.0" 
$ns at 796.1481035570553 "$node_(500) setdest 87769 13956 18.0" 
$ns at 500.61582667460993 "$node_(501) setdest 56959 12423 11.0" 
$ns at 531.9292617438055 "$node_(501) setdest 122475 25060 16.0" 
$ns at 699.0933179207028 "$node_(501) setdest 99060 23205 12.0" 
$ns at 845.2347184479081 "$node_(501) setdest 78504 41624 7.0" 
$ns at 538.7563201681049 "$node_(502) setdest 21946 28116 16.0" 
$ns at 618.9779588154815 "$node_(502) setdest 56952 44177 5.0" 
$ns at 660.7395009697904 "$node_(502) setdest 60028 187 18.0" 
$ns at 778.2462094809437 "$node_(502) setdest 82549 21122 17.0" 
$ns at 830.0684628085025 "$node_(502) setdest 104547 26470 11.0" 
$ns at 518.6429460507626 "$node_(503) setdest 28501 13781 4.0" 
$ns at 553.5107427190112 "$node_(503) setdest 113627 29013 9.0" 
$ns at 627.3229818442576 "$node_(503) setdest 70532 39202 2.0" 
$ns at 663.7254880717602 "$node_(503) setdest 17991 9707 8.0" 
$ns at 733.8091143165649 "$node_(503) setdest 15353 18978 11.0" 
$ns at 820.1465010309004 "$node_(503) setdest 4301 35576 7.0" 
$ns at 854.7356093954368 "$node_(503) setdest 9032 21540 5.0" 
$ns at 892.4355893106275 "$node_(503) setdest 105659 27838 7.0" 
$ns at 550.4724127642571 "$node_(504) setdest 15940 27223 19.0" 
$ns at 673.0298979495273 "$node_(504) setdest 133183 38420 16.0" 
$ns at 749.8979070311867 "$node_(504) setdest 80149 42636 9.0" 
$ns at 796.3330551945463 "$node_(504) setdest 105241 7660 13.0" 
$ns at 831.803223073687 "$node_(504) setdest 42387 29314 16.0" 
$ns at 518.1501567937272 "$node_(505) setdest 120318 17175 7.0" 
$ns at 553.139658469965 "$node_(505) setdest 10335 29419 5.0" 
$ns at 586.3086393578719 "$node_(505) setdest 53621 7401 9.0" 
$ns at 661.7221975315703 "$node_(505) setdest 101066 4654 9.0" 
$ns at 768.2351160585206 "$node_(505) setdest 34044 15708 17.0" 
$ns at 554.9373585816262 "$node_(506) setdest 3787 26412 19.0" 
$ns at 723.4648427571656 "$node_(506) setdest 68980 43775 14.0" 
$ns at 889.9780972096817 "$node_(506) setdest 42441 6988 7.0" 
$ns at 644.2853058529878 "$node_(507) setdest 100038 17923 5.0" 
$ns at 721.535710086401 "$node_(507) setdest 72868 10 2.0" 
$ns at 756.1273206744289 "$node_(507) setdest 125587 21647 5.0" 
$ns at 827.2825505521681 "$node_(507) setdest 100452 2352 4.0" 
$ns at 871.4480340018549 "$node_(507) setdest 50891 22832 11.0" 
$ns at 598.8599302858192 "$node_(508) setdest 88665 7325 19.0" 
$ns at 732.5184117255599 "$node_(508) setdest 8560 44574 11.0" 
$ns at 845.8704100655366 "$node_(508) setdest 79301 6785 19.0" 
$ns at 525.6590667657372 "$node_(509) setdest 21685 399 7.0" 
$ns at 617.1553655102483 "$node_(509) setdest 9108 12146 18.0" 
$ns at 782.2584871510766 "$node_(509) setdest 7328 3617 5.0" 
$ns at 829.7006000996017 "$node_(509) setdest 24223 12787 19.0" 
$ns at 517.3377207648708 "$node_(510) setdest 32973 39617 7.0" 
$ns at 591.1592955455656 "$node_(510) setdest 61715 43536 6.0" 
$ns at 647.3899712755215 "$node_(510) setdest 76308 41816 6.0" 
$ns at 728.526057844183 "$node_(510) setdest 122126 1284 14.0" 
$ns at 804.007704900037 "$node_(510) setdest 7612 184 6.0" 
$ns at 884.161734100507 "$node_(510) setdest 127557 21441 2.0" 
$ns at 538.2957043457968 "$node_(511) setdest 95820 42206 1.0" 
$ns at 572.8804457046679 "$node_(511) setdest 86385 32018 14.0" 
$ns at 668.9274853916701 "$node_(511) setdest 112023 10253 16.0" 
$ns at 732.453928330369 "$node_(511) setdest 20945 22873 13.0" 
$ns at 816.5215976608621 "$node_(511) setdest 38667 14952 13.0" 
$ns at 714.7175977361863 "$node_(512) setdest 33388 21849 17.0" 
$ns at 814.3159493783514 "$node_(512) setdest 119295 6000 9.0" 
$ns at 895.7666242283237 "$node_(512) setdest 134065 28968 8.0" 
$ns at 553.9584274981346 "$node_(513) setdest 52228 31488 6.0" 
$ns at 638.175099340512 "$node_(513) setdest 37664 16627 15.0" 
$ns at 749.4356237150922 "$node_(513) setdest 1575 17727 17.0" 
$ns at 825.8506091879236 "$node_(513) setdest 83940 14223 8.0" 
$ns at 867.9788786183493 "$node_(513) setdest 67296 12519 12.0" 
$ns at 588.0326843766243 "$node_(514) setdest 103807 26975 13.0" 
$ns at 723.1657995338237 "$node_(514) setdest 91787 4778 7.0" 
$ns at 758.2608972092977 "$node_(514) setdest 13757 12042 6.0" 
$ns at 819.2652423718641 "$node_(514) setdest 44363 42032 5.0" 
$ns at 850.6457072118098 "$node_(514) setdest 112349 15609 13.0" 
$ns at 523.4215970979689 "$node_(515) setdest 60208 6358 3.0" 
$ns at 560.0560890538377 "$node_(515) setdest 71932 35026 13.0" 
$ns at 669.4871997912267 "$node_(515) setdest 100443 6892 8.0" 
$ns at 733.3541195072241 "$node_(515) setdest 124273 23768 17.0" 
$ns at 859.3105561420703 "$node_(515) setdest 60565 43066 11.0" 
$ns at 623.7059819105806 "$node_(516) setdest 98439 25110 8.0" 
$ns at 685.5598698799182 "$node_(516) setdest 117618 35212 16.0" 
$ns at 796.0112804799998 "$node_(516) setdest 100727 32286 5.0" 
$ns at 871.5458145352636 "$node_(516) setdest 128775 22674 8.0" 
$ns at 525.2732762243157 "$node_(517) setdest 116082 15038 1.0" 
$ns at 558.801016435171 "$node_(517) setdest 34287 22566 3.0" 
$ns at 610.0096762527949 "$node_(517) setdest 11898 14767 5.0" 
$ns at 655.1880876157911 "$node_(517) setdest 130183 4731 6.0" 
$ns at 729.0496258173551 "$node_(517) setdest 21087 36197 14.0" 
$ns at 865.6696732423761 "$node_(517) setdest 109227 26224 7.0" 
$ns at 542.3833074062397 "$node_(518) setdest 94645 26534 19.0" 
$ns at 723.185110544473 "$node_(518) setdest 114514 33961 18.0" 
$ns at 826.3335265793191 "$node_(518) setdest 106876 17058 8.0" 
$ns at 872.1128507853479 "$node_(518) setdest 16439 7764 19.0" 
$ns at 570.7109420008185 "$node_(519) setdest 80591 37796 2.0" 
$ns at 618.317910979922 "$node_(519) setdest 20314 19509 19.0" 
$ns at 816.2236599310728 "$node_(519) setdest 52090 8961 17.0" 
$ns at 530.7120227120096 "$node_(520) setdest 13428 23503 19.0" 
$ns at 602.3631496619619 "$node_(520) setdest 116830 24163 19.0" 
$ns at 661.5796870094832 "$node_(520) setdest 99149 18396 7.0" 
$ns at 732.7769334281404 "$node_(520) setdest 1801 10755 11.0" 
$ns at 864.9231107399235 "$node_(520) setdest 49118 20629 14.0" 
$ns at 542.7357132210279 "$node_(521) setdest 123766 21146 13.0" 
$ns at 696.5559215643488 "$node_(521) setdest 85032 40294 9.0" 
$ns at 809.2918980616314 "$node_(521) setdest 105011 4107 16.0" 
$ns at 564.2740801016909 "$node_(522) setdest 122961 8034 5.0" 
$ns at 600.6023181320011 "$node_(522) setdest 116580 26388 16.0" 
$ns at 727.432702102348 "$node_(522) setdest 115577 96 17.0" 
$ns at 869.1018026650598 "$node_(522) setdest 45736 5701 6.0" 
$ns at 618.4303561050629 "$node_(523) setdest 67151 17207 8.0" 
$ns at 714.2489385600327 "$node_(523) setdest 40327 16400 14.0" 
$ns at 837.1088858191165 "$node_(523) setdest 125314 16756 10.0" 
$ns at 881.1436419722563 "$node_(523) setdest 84590 39344 17.0" 
$ns at 512.4260478635936 "$node_(524) setdest 57193 12783 6.0" 
$ns at 564.2266779108256 "$node_(524) setdest 125618 38597 6.0" 
$ns at 623.5810157977714 "$node_(524) setdest 43337 1397 14.0" 
$ns at 752.3809566890168 "$node_(524) setdest 129913 31642 2.0" 
$ns at 782.5951005506199 "$node_(524) setdest 65686 21163 10.0" 
$ns at 549.5895301800857 "$node_(525) setdest 19755 2185 19.0" 
$ns at 747.1111067168893 "$node_(525) setdest 82653 32446 17.0" 
$ns at 823.7893921214269 "$node_(525) setdest 24101 193 15.0" 
$ns at 532.7027885577291 "$node_(526) setdest 21020 7918 19.0" 
$ns at 723.3414729361043 "$node_(526) setdest 67078 30468 1.0" 
$ns at 757.1170921571037 "$node_(526) setdest 17691 31386 6.0" 
$ns at 818.2427752504351 "$node_(526) setdest 34872 19609 9.0" 
$ns at 514.793447158306 "$node_(527) setdest 105920 24061 10.0" 
$ns at 566.6215034989308 "$node_(527) setdest 54750 28067 5.0" 
$ns at 634.6827611542742 "$node_(527) setdest 74037 34386 17.0" 
$ns at 804.1856134522423 "$node_(527) setdest 29169 33331 5.0" 
$ns at 866.0728272268304 "$node_(527) setdest 52381 35211 9.0" 
$ns at 503.67273956240183 "$node_(528) setdest 130999 35474 2.0" 
$ns at 535.7198530318573 "$node_(528) setdest 42771 12576 15.0" 
$ns at 687.3178576707007 "$node_(528) setdest 75393 9249 14.0" 
$ns at 782.8803987102375 "$node_(528) setdest 66449 32788 10.0" 
$ns at 820.2673878890974 "$node_(528) setdest 50163 10258 14.0" 
$ns at 570.7958390987532 "$node_(529) setdest 34943 9750 8.0" 
$ns at 603.6751508994539 "$node_(529) setdest 37605 40275 8.0" 
$ns at 635.734369939979 "$node_(529) setdest 71091 38506 1.0" 
$ns at 674.4416124428169 "$node_(529) setdest 38984 14465 13.0" 
$ns at 725.2769193001345 "$node_(529) setdest 50074 11890 3.0" 
$ns at 769.0993819550278 "$node_(529) setdest 78034 9086 15.0" 
$ns at 815.4113302135062 "$node_(529) setdest 132771 36350 2.0" 
$ns at 857.2252313101138 "$node_(529) setdest 7472 12108 15.0" 
$ns at 648.7604407271814 "$node_(530) setdest 73382 21246 15.0" 
$ns at 751.0941161913032 "$node_(530) setdest 131520 16987 10.0" 
$ns at 796.922746574674 "$node_(530) setdest 121151 40854 5.0" 
$ns at 851.9257289314826 "$node_(530) setdest 76772 18537 1.0" 
$ns at 882.3708303391073 "$node_(530) setdest 130613 5319 10.0" 
$ns at 578.8180830774459 "$node_(531) setdest 114579 22955 18.0" 
$ns at 755.8464164440411 "$node_(531) setdest 29857 29144 3.0" 
$ns at 798.7741111503926 "$node_(531) setdest 108736 44674 6.0" 
$ns at 840.7558397220749 "$node_(531) setdest 68992 34597 6.0" 
$ns at 551.4273929375556 "$node_(532) setdest 74739 44159 5.0" 
$ns at 582.6196148005076 "$node_(532) setdest 82398 25377 11.0" 
$ns at 701.1716449858368 "$node_(532) setdest 112717 861 18.0" 
$ns at 777.9024652205143 "$node_(532) setdest 106130 16992 3.0" 
$ns at 833.832675877539 "$node_(532) setdest 100432 33942 17.0" 
$ns at 527.4638674442605 "$node_(533) setdest 42031 39973 2.0" 
$ns at 569.564772595983 "$node_(533) setdest 87141 5815 2.0" 
$ns at 606.2495143840076 "$node_(533) setdest 12786 14544 8.0" 
$ns at 691.3826907456536 "$node_(533) setdest 102989 33918 13.0" 
$ns at 787.3267815412507 "$node_(533) setdest 128169 44486 5.0" 
$ns at 823.536840779588 "$node_(533) setdest 33240 1418 7.0" 
$ns at 863.3329897734561 "$node_(533) setdest 68134 39619 2.0" 
$ns at 898.2736619031001 "$node_(533) setdest 92306 18950 4.0" 
$ns at 618.4651271604505 "$node_(534) setdest 45626 13256 9.0" 
$ns at 706.6846923967237 "$node_(534) setdest 87353 28707 13.0" 
$ns at 756.4146311558213 "$node_(534) setdest 104169 26062 13.0" 
$ns at 890.3850654521582 "$node_(534) setdest 19425 30306 17.0" 
$ns at 577.8473148908458 "$node_(535) setdest 88700 25428 4.0" 
$ns at 629.0410715536202 "$node_(535) setdest 18486 17399 15.0" 
$ns at 754.4574044200144 "$node_(535) setdest 80460 17227 6.0" 
$ns at 787.4262382633437 "$node_(535) setdest 116342 35951 12.0" 
$ns at 829.6064594414214 "$node_(535) setdest 5160 27844 19.0" 
$ns at 527.3355706458839 "$node_(536) setdest 77484 27387 18.0" 
$ns at 687.5445385314428 "$node_(536) setdest 66008 13689 3.0" 
$ns at 722.2930392993238 "$node_(536) setdest 938 28923 1.0" 
$ns at 754.4990021639411 "$node_(536) setdest 35673 36970 13.0" 
$ns at 876.7008799794293 "$node_(536) setdest 13142 34522 8.0" 
$ns at 631.5531947075499 "$node_(537) setdest 52204 14199 3.0" 
$ns at 691.2855863881505 "$node_(537) setdest 95518 19886 15.0" 
$ns at 765.715203500598 "$node_(537) setdest 8643 1803 4.0" 
$ns at 811.6624027658931 "$node_(537) setdest 18584 27027 13.0" 
$ns at 523.7048262112601 "$node_(538) setdest 33505 9578 3.0" 
$ns at 574.7887206571755 "$node_(538) setdest 80543 21231 15.0" 
$ns at 628.8310526262208 "$node_(538) setdest 2113 27324 15.0" 
$ns at 727.2665241914133 "$node_(538) setdest 103250 23585 4.0" 
$ns at 785.2241536807674 "$node_(538) setdest 44532 4056 6.0" 
$ns at 861.7205409106273 "$node_(538) setdest 24137 9251 7.0" 
$ns at 515.046347989376 "$node_(539) setdest 13199 31148 4.0" 
$ns at 567.44594097487 "$node_(539) setdest 14645 28132 18.0" 
$ns at 632.8911415399942 "$node_(539) setdest 129158 41944 18.0" 
$ns at 840.9883336350317 "$node_(539) setdest 8138 37134 15.0" 
$ns at 520.0611507730041 "$node_(540) setdest 126471 43366 2.0" 
$ns at 551.5309942444293 "$node_(540) setdest 44749 20624 18.0" 
$ns at 616.1233136894081 "$node_(540) setdest 88923 24412 9.0" 
$ns at 707.755546605063 "$node_(540) setdest 40117 28979 18.0" 
$ns at 872.7171618754795 "$node_(540) setdest 61410 41447 18.0" 
$ns at 503.412294488988 "$node_(541) setdest 109587 28271 1.0" 
$ns at 537.5885889273746 "$node_(541) setdest 22280 34509 20.0" 
$ns at 601.707710462697 "$node_(541) setdest 25988 28410 6.0" 
$ns at 635.8648002500237 "$node_(541) setdest 125043 14471 18.0" 
$ns at 741.9939914338527 "$node_(541) setdest 96277 41094 14.0" 
$ns at 801.2943427163061 "$node_(541) setdest 11231 25750 11.0" 
$ns at 849.0640297715747 "$node_(541) setdest 7517 32975 11.0" 
$ns at 553.3753235350825 "$node_(542) setdest 57254 6770 11.0" 
$ns at 680.2786309533783 "$node_(542) setdest 105182 34463 11.0" 
$ns at 722.3673249581816 "$node_(542) setdest 39840 40080 11.0" 
$ns at 757.4834650608854 "$node_(542) setdest 24453 40977 4.0" 
$ns at 822.7303007894878 "$node_(542) setdest 34964 10715 19.0" 
$ns at 636.062528184394 "$node_(543) setdest 69439 12754 14.0" 
$ns at 683.3941738484 "$node_(543) setdest 30784 39672 15.0" 
$ns at 824.4933100474348 "$node_(543) setdest 75411 22928 18.0" 
$ns at 864.5057134020865 "$node_(543) setdest 107833 4860 10.0" 
$ns at 537.5622216631403 "$node_(544) setdest 84624 4509 8.0" 
$ns at 642.6802295696135 "$node_(544) setdest 24519 10691 3.0" 
$ns at 691.5221330572681 "$node_(544) setdest 127439 3669 1.0" 
$ns at 726.7149625223655 "$node_(544) setdest 5270 38254 9.0" 
$ns at 844.415572439041 "$node_(544) setdest 101554 2044 16.0" 
$ns at 502.3805663024875 "$node_(545) setdest 16406 7025 12.0" 
$ns at 591.3672667103701 "$node_(545) setdest 125014 20151 12.0" 
$ns at 739.6623155733635 "$node_(545) setdest 114457 26256 5.0" 
$ns at 795.0968161835868 "$node_(545) setdest 122767 30264 12.0" 
$ns at 521.3132975558142 "$node_(546) setdest 116804 5184 2.0" 
$ns at 552.6693541336576 "$node_(546) setdest 98819 9136 15.0" 
$ns at 595.3678302849914 "$node_(546) setdest 34204 9458 19.0" 
$ns at 756.0918884616456 "$node_(546) setdest 67770 19008 5.0" 
$ns at 833.2740979492736 "$node_(546) setdest 71624 12344 10.0" 
$ns at 552.487171823759 "$node_(547) setdest 21446 31385 4.0" 
$ns at 594.3368442254168 "$node_(547) setdest 110662 5910 12.0" 
$ns at 736.3489628673254 "$node_(547) setdest 95418 26816 9.0" 
$ns at 814.0651499862008 "$node_(547) setdest 11376 19836 12.0" 
$ns at 503.93006406317863 "$node_(548) setdest 5693 6483 16.0" 
$ns at 540.3025892314444 "$node_(548) setdest 5202 4701 3.0" 
$ns at 575.8219486617858 "$node_(548) setdest 112164 30105 3.0" 
$ns at 619.8635522276353 "$node_(548) setdest 96592 20663 7.0" 
$ns at 687.3748273361842 "$node_(548) setdest 53048 34540 3.0" 
$ns at 743.9024705339555 "$node_(548) setdest 104325 20577 13.0" 
$ns at 884.4678448291737 "$node_(548) setdest 20365 7032 6.0" 
$ns at 583.7707893120262 "$node_(549) setdest 114 31779 8.0" 
$ns at 675.8125966885157 "$node_(549) setdest 88099 40050 6.0" 
$ns at 764.4895726187106 "$node_(549) setdest 2513 14368 10.0" 
$ns at 883.6873326034679 "$node_(549) setdest 118690 39224 16.0" 
$ns at 529.7525196176367 "$node_(550) setdest 101008 18425 2.0" 
$ns at 565.9142344230282 "$node_(550) setdest 98394 19565 2.0" 
$ns at 599.2124264391421 "$node_(550) setdest 60228 7533 5.0" 
$ns at 670.5552476757747 "$node_(550) setdest 132061 6728 5.0" 
$ns at 724.4124070890197 "$node_(550) setdest 31295 30494 8.0" 
$ns at 793.1400240782311 "$node_(550) setdest 120923 11150 14.0" 
$ns at 886.5063232391976 "$node_(550) setdest 14975 12294 12.0" 
$ns at 504.87616754146813 "$node_(551) setdest 77847 4447 14.0" 
$ns at 643.6796715103691 "$node_(551) setdest 42578 7933 4.0" 
$ns at 702.2987622851083 "$node_(551) setdest 65305 15573 9.0" 
$ns at 786.6546253547375 "$node_(551) setdest 95750 21948 2.0" 
$ns at 828.3912912340766 "$node_(551) setdest 63580 24247 17.0" 
$ns at 511.61078883091864 "$node_(552) setdest 63044 27718 19.0" 
$ns at 610.4340625176164 "$node_(552) setdest 113998 219 1.0" 
$ns at 646.7681618019575 "$node_(552) setdest 29658 13053 18.0" 
$ns at 760.0124964791439 "$node_(552) setdest 119596 6190 15.0" 
$ns at 850.6447813423915 "$node_(552) setdest 124951 19499 2.0" 
$ns at 893.0429952927449 "$node_(552) setdest 88335 36331 16.0" 
$ns at 561.8224379957198 "$node_(553) setdest 100716 43981 14.0" 
$ns at 630.9938682747534 "$node_(553) setdest 59773 43544 16.0" 
$ns at 812.3506384244563 "$node_(553) setdest 48953 44082 2.0" 
$ns at 846.3441104869617 "$node_(553) setdest 73312 44504 3.0" 
$ns at 517.3201705798442 "$node_(554) setdest 41694 24568 16.0" 
$ns at 617.473833163162 "$node_(554) setdest 133262 23411 13.0" 
$ns at 654.4813123922765 "$node_(554) setdest 29675 3451 10.0" 
$ns at 731.8153376995659 "$node_(554) setdest 114475 32888 4.0" 
$ns at 776.3746037262924 "$node_(554) setdest 112929 17214 19.0" 
$ns at 817.2830354120365 "$node_(554) setdest 67677 8861 18.0" 
$ns at 525.358307960929 "$node_(555) setdest 60019 12006 6.0" 
$ns at 575.6036450760896 "$node_(555) setdest 74028 22090 10.0" 
$ns at 695.847325762581 "$node_(555) setdest 97185 38969 16.0" 
$ns at 770.2580932131455 "$node_(555) setdest 74263 32227 10.0" 
$ns at 895.5291381995555 "$node_(555) setdest 57137 13731 4.0" 
$ns at 526.420580518205 "$node_(556) setdest 97131 15864 1.0" 
$ns at 562.834109951637 "$node_(556) setdest 672 21202 15.0" 
$ns at 742.3344791872541 "$node_(556) setdest 98586 22330 4.0" 
$ns at 788.9705621106721 "$node_(556) setdest 104420 6707 9.0" 
$ns at 840.4712601962938 "$node_(556) setdest 115185 39631 11.0" 
$ns at 503.9613244443197 "$node_(557) setdest 28266 13942 14.0" 
$ns at 559.2300607379702 "$node_(557) setdest 1920 25438 2.0" 
$ns at 589.8254994531967 "$node_(557) setdest 43234 291 13.0" 
$ns at 661.5019264382563 "$node_(557) setdest 16016 43920 13.0" 
$ns at 705.8163211739358 "$node_(557) setdest 129791 38217 13.0" 
$ns at 750.0850614316902 "$node_(557) setdest 133500 40968 19.0" 
$ns at 874.9284162361424 "$node_(557) setdest 77589 9535 17.0" 
$ns at 668.1143278733232 "$node_(558) setdest 59426 15768 6.0" 
$ns at 716.242007021393 "$node_(558) setdest 2825 34550 12.0" 
$ns at 860.5589431973079 "$node_(558) setdest 17041 15748 7.0" 
$ns at 549.3173444808277 "$node_(559) setdest 5069 36909 15.0" 
$ns at 700.6322449642353 "$node_(559) setdest 37114 18898 20.0" 
$ns at 862.3582683329514 "$node_(559) setdest 1646 38260 19.0" 
$ns at 531.9420874990839 "$node_(560) setdest 67079 20119 4.0" 
$ns at 599.4878118355433 "$node_(560) setdest 119814 13626 5.0" 
$ns at 629.8858855308476 "$node_(560) setdest 129885 18173 12.0" 
$ns at 741.5378645342993 "$node_(560) setdest 89918 43910 9.0" 
$ns at 787.5203012402984 "$node_(560) setdest 115836 41455 15.0" 
$ns at 569.9963840001558 "$node_(561) setdest 32850 11926 2.0" 
$ns at 614.7516717008494 "$node_(561) setdest 91787 32303 2.0" 
$ns at 646.8432664829928 "$node_(561) setdest 82342 38749 6.0" 
$ns at 704.7573041839469 "$node_(561) setdest 34259 36886 14.0" 
$ns at 744.1974262788964 "$node_(561) setdest 45720 41019 12.0" 
$ns at 777.2297978110337 "$node_(561) setdest 74997 9460 3.0" 
$ns at 808.0916072265337 "$node_(561) setdest 97151 42348 2.0" 
$ns at 847.6591323884842 "$node_(561) setdest 37624 19486 7.0" 
$ns at 898.1938304404723 "$node_(561) setdest 126853 41680 11.0" 
$ns at 513.6239113969552 "$node_(562) setdest 29233 10510 15.0" 
$ns at 668.4394633165671 "$node_(562) setdest 105190 24324 1.0" 
$ns at 699.3750423498703 "$node_(562) setdest 95674 20886 5.0" 
$ns at 766.4541234175106 "$node_(562) setdest 122434 40578 1.0" 
$ns at 805.4368684992367 "$node_(562) setdest 39058 3616 16.0" 
$ns at 846.0434243242278 "$node_(562) setdest 66607 18549 20.0" 
$ns at 518.7692926441944 "$node_(563) setdest 115022 17357 18.0" 
$ns at 567.5771383271615 "$node_(563) setdest 23925 8392 9.0" 
$ns at 667.866935836052 "$node_(563) setdest 26458 13070 17.0" 
$ns at 801.6146377775642 "$node_(563) setdest 125764 35040 11.0" 
$ns at 637.991379326189 "$node_(564) setdest 20545 41917 11.0" 
$ns at 748.6956259517501 "$node_(564) setdest 90532 20759 15.0" 
$ns at 896.6529065151828 "$node_(564) setdest 46187 4218 17.0" 
$ns at 510.6271923241766 "$node_(565) setdest 68205 6612 3.0" 
$ns at 543.1990371589176 "$node_(565) setdest 69235 27894 19.0" 
$ns at 664.5534614606496 "$node_(565) setdest 55009 17794 2.0" 
$ns at 699.7471786490137 "$node_(565) setdest 8692 44057 8.0" 
$ns at 766.8876766850464 "$node_(565) setdest 23932 14544 20.0" 
$ns at 807.7074796827841 "$node_(565) setdest 3737 16679 15.0" 
$ns at 505.4823526797015 "$node_(566) setdest 33468 8604 12.0" 
$ns at 604.4705396667466 "$node_(566) setdest 75305 26290 15.0" 
$ns at 747.5188718200624 "$node_(566) setdest 117055 36728 12.0" 
$ns at 882.7980071274005 "$node_(566) setdest 50414 34760 18.0" 
$ns at 548.002649492656 "$node_(567) setdest 3904 4571 15.0" 
$ns at 702.4666970638923 "$node_(567) setdest 63766 21696 15.0" 
$ns at 864.0192620376351 "$node_(567) setdest 104749 40363 12.0" 
$ns at 573.8708829472282 "$node_(568) setdest 24643 40746 8.0" 
$ns at 627.4212151082248 "$node_(568) setdest 12151 39951 10.0" 
$ns at 691.5465401295055 "$node_(568) setdest 114888 31669 2.0" 
$ns at 722.2602936083144 "$node_(568) setdest 85289 36661 10.0" 
$ns at 799.8638903655785 "$node_(568) setdest 88991 39167 16.0" 
$ns at 555.4438072098413 "$node_(569) setdest 77833 8669 7.0" 
$ns at 608.1356770897502 "$node_(569) setdest 76070 25285 8.0" 
$ns at 692.1789586264146 "$node_(569) setdest 130053 28062 7.0" 
$ns at 775.5881191157109 "$node_(569) setdest 133402 9637 10.0" 
$ns at 806.8678311820374 "$node_(569) setdest 56326 7677 19.0" 
$ns at 534.6507306212679 "$node_(570) setdest 19196 9414 15.0" 
$ns at 655.3189984983469 "$node_(570) setdest 73704 17984 3.0" 
$ns at 703.7224840136387 "$node_(570) setdest 100661 29506 4.0" 
$ns at 767.1166926034579 "$node_(570) setdest 32319 5640 1.0" 
$ns at 803.8577900863374 "$node_(570) setdest 95897 5233 11.0" 
$ns at 892.6635174422811 "$node_(570) setdest 69376 11860 13.0" 
$ns at 650.5922608678693 "$node_(571) setdest 125888 42491 8.0" 
$ns at 752.5326552963068 "$node_(571) setdest 4376 7344 4.0" 
$ns at 816.8433174902109 "$node_(571) setdest 35269 31105 15.0" 
$ns at 884.6342769817257 "$node_(571) setdest 73350 25697 1.0" 
$ns at 513.3436131352505 "$node_(572) setdest 115025 318 14.0" 
$ns at 610.3135648767834 "$node_(572) setdest 133836 39584 11.0" 
$ns at 698.5587818399782 "$node_(572) setdest 65631 19349 16.0" 
$ns at 828.9684308596103 "$node_(572) setdest 72552 28089 5.0" 
$ns at 873.8653366561471 "$node_(572) setdest 35661 26918 13.0" 
$ns at 578.6580819699562 "$node_(573) setdest 83678 6609 20.0" 
$ns at 662.0093421999267 "$node_(573) setdest 128193 7983 8.0" 
$ns at 768.7324140321334 "$node_(573) setdest 93660 29366 9.0" 
$ns at 822.2768199879863 "$node_(573) setdest 118155 39163 6.0" 
$ns at 867.7569617132121 "$node_(573) setdest 38678 15041 12.0" 
$ns at 513.3703691587357 "$node_(574) setdest 123439 33914 16.0" 
$ns at 602.2165753633053 "$node_(574) setdest 113466 4228 13.0" 
$ns at 696.1398543326892 "$node_(574) setdest 79446 17715 12.0" 
$ns at 841.3503067686413 "$node_(574) setdest 124917 17991 18.0" 
$ns at 542.0951872086015 "$node_(575) setdest 62164 21541 7.0" 
$ns at 628.1514880499993 "$node_(575) setdest 121089 28268 7.0" 
$ns at 665.3823495429398 "$node_(575) setdest 55369 39608 14.0" 
$ns at 803.1623387626369 "$node_(575) setdest 115636 14804 8.0" 
$ns at 897.7737674659371 "$node_(575) setdest 64292 3673 4.0" 
$ns at 599.3628064832465 "$node_(576) setdest 25829 7824 1.0" 
$ns at 630.0238798732998 "$node_(576) setdest 102483 11822 11.0" 
$ns at 764.8539136195848 "$node_(576) setdest 120188 40980 16.0" 
$ns at 501.1657680714176 "$node_(577) setdest 104164 10227 17.0" 
$ns at 654.6472352866712 "$node_(577) setdest 16590 21385 18.0" 
$ns at 825.575124220157 "$node_(577) setdest 32782 14094 1.0" 
$ns at 863.1472797237006 "$node_(577) setdest 87409 13464 11.0" 
$ns at 510.41200948537346 "$node_(578) setdest 93715 26849 8.0" 
$ns at 578.4332303414122 "$node_(578) setdest 64726 14946 15.0" 
$ns at 715.0085927621352 "$node_(578) setdest 62565 33306 9.0" 
$ns at 811.8791198691727 "$node_(578) setdest 31853 29663 16.0" 
$ns at 507.79724341335225 "$node_(579) setdest 132408 4663 3.0" 
$ns at 546.8678352378788 "$node_(579) setdest 95955 35891 9.0" 
$ns at 581.4430654513228 "$node_(579) setdest 18137 23340 8.0" 
$ns at 672.5131316217564 "$node_(579) setdest 112348 38171 13.0" 
$ns at 709.5923513509605 "$node_(579) setdest 38983 8883 4.0" 
$ns at 740.2132500309109 "$node_(579) setdest 18133 41952 12.0" 
$ns at 831.8252128787735 "$node_(579) setdest 130754 1600 5.0" 
$ns at 882.4769533742 "$node_(579) setdest 133417 6266 16.0" 
$ns at 540.3159557106462 "$node_(580) setdest 78918 6842 20.0" 
$ns at 736.8474026149236 "$node_(580) setdest 33840 33038 13.0" 
$ns at 853.2845590983451 "$node_(580) setdest 107812 9238 9.0" 
$ns at 526.4213060698326 "$node_(581) setdest 46485 9924 3.0" 
$ns at 561.5464696004129 "$node_(581) setdest 20238 12053 15.0" 
$ns at 599.5286349007381 "$node_(581) setdest 43295 15633 1.0" 
$ns at 632.4786194369516 "$node_(581) setdest 128051 28118 1.0" 
$ns at 666.5515224851458 "$node_(581) setdest 9252 32329 4.0" 
$ns at 734.5228979372052 "$node_(581) setdest 23176 26989 8.0" 
$ns at 769.6795083317934 "$node_(581) setdest 84954 7224 5.0" 
$ns at 819.935934265023 "$node_(581) setdest 8854 14204 1.0" 
$ns at 857.0158468438839 "$node_(581) setdest 76645 29802 11.0" 
$ns at 566.8384470210476 "$node_(582) setdest 34803 777 12.0" 
$ns at 641.5253331559222 "$node_(582) setdest 13685 27905 7.0" 
$ns at 672.6536621881617 "$node_(582) setdest 101691 27620 19.0" 
$ns at 721.4884145627454 "$node_(582) setdest 12132 18855 10.0" 
$ns at 851.4424141206333 "$node_(582) setdest 25285 8183 17.0" 
$ns at 545.9596964186344 "$node_(583) setdest 98145 3442 11.0" 
$ns at 684.9922471969712 "$node_(583) setdest 81023 42514 18.0" 
$ns at 822.4149782243423 "$node_(583) setdest 68183 34748 19.0" 
$ns at 889.369807432533 "$node_(583) setdest 10678 14601 13.0" 
$ns at 528.3954265344826 "$node_(584) setdest 52260 39669 17.0" 
$ns at 642.9222155591364 "$node_(584) setdest 66220 1001 19.0" 
$ns at 850.5309284870647 "$node_(584) setdest 80430 39565 12.0" 
$ns at 536.4679718732825 "$node_(585) setdest 38568 14287 18.0" 
$ns at 599.600338207972 "$node_(585) setdest 28868 2333 15.0" 
$ns at 654.1920328637735 "$node_(585) setdest 22083 37555 19.0" 
$ns at 711.3347310313522 "$node_(585) setdest 19990 15677 14.0" 
$ns at 751.3157481998066 "$node_(585) setdest 109398 38337 9.0" 
$ns at 834.6557249489442 "$node_(585) setdest 9722 5967 11.0" 
$ns at 899.0507797075193 "$node_(585) setdest 54025 34120 9.0" 
$ns at 546.9417348369223 "$node_(586) setdest 67553 44356 18.0" 
$ns at 626.4477324274309 "$node_(586) setdest 34226 24676 9.0" 
$ns at 683.6490242433915 "$node_(586) setdest 67831 22329 14.0" 
$ns at 801.3742429420727 "$node_(586) setdest 76186 8947 7.0" 
$ns at 845.7337162529169 "$node_(586) setdest 125709 1321 14.0" 
$ns at 614.2417689204792 "$node_(587) setdest 4985 27748 18.0" 
$ns at 788.2647873525449 "$node_(587) setdest 62727 14232 19.0" 
$ns at 522.8387905420417 "$node_(588) setdest 81880 37092 5.0" 
$ns at 577.6383736073883 "$node_(588) setdest 3596 3849 16.0" 
$ns at 757.88080592446 "$node_(588) setdest 87904 7499 16.0" 
$ns at 572.5531521371637 "$node_(589) setdest 100476 38306 10.0" 
$ns at 625.5072138585474 "$node_(589) setdest 32491 18254 18.0" 
$ns at 820.3329887230271 "$node_(589) setdest 71123 20442 11.0" 
$ns at 574.0846987542379 "$node_(590) setdest 93271 30291 4.0" 
$ns at 606.5259616020178 "$node_(590) setdest 56820 18104 14.0" 
$ns at 678.0306763868502 "$node_(590) setdest 131276 18729 18.0" 
$ns at 772.9063635006696 "$node_(590) setdest 123528 17586 1.0" 
$ns at 812.3552024760412 "$node_(590) setdest 65361 24914 19.0" 
$ns at 899.1257056830635 "$node_(590) setdest 79383 16289 13.0" 
$ns at 513.0882151449214 "$node_(591) setdest 95915 10946 14.0" 
$ns at 561.3167563698624 "$node_(591) setdest 109653 14534 12.0" 
$ns at 691.7028340273057 "$node_(591) setdest 88853 34201 6.0" 
$ns at 744.7290807005205 "$node_(591) setdest 71762 2744 13.0" 
$ns at 894.31504818797 "$node_(591) setdest 2768 30826 20.0" 
$ns at 530.4487194847999 "$node_(592) setdest 36788 20918 1.0" 
$ns at 561.4417563061409 "$node_(592) setdest 107207 27280 6.0" 
$ns at 596.9447712905221 "$node_(592) setdest 15997 27939 18.0" 
$ns at 639.6676697598818 "$node_(592) setdest 5828 22674 3.0" 
$ns at 686.7147611223968 "$node_(592) setdest 18529 4581 12.0" 
$ns at 770.0724863818675 "$node_(592) setdest 3505 16885 17.0" 
$ns at 877.3402802902638 "$node_(592) setdest 62652 37384 14.0" 
$ns at 512.087262261665 "$node_(593) setdest 85349 920 9.0" 
$ns at 612.8198673133952 "$node_(593) setdest 40384 38109 4.0" 
$ns at 681.3380855187802 "$node_(593) setdest 6749 11923 17.0" 
$ns at 724.9498465258804 "$node_(593) setdest 120468 30288 19.0" 
$ns at 790.7479134116372 "$node_(593) setdest 2491 4962 4.0" 
$ns at 845.1788253030517 "$node_(593) setdest 67942 28919 13.0" 
$ns at 554.2549106996 "$node_(594) setdest 34256 20306 9.0" 
$ns at 638.3250055781696 "$node_(594) setdest 83629 25436 13.0" 
$ns at 684.150671342479 "$node_(594) setdest 10627 30477 19.0" 
$ns at 843.5749124728676 "$node_(594) setdest 126148 8230 18.0" 
$ns at 506.2678020924522 "$node_(595) setdest 95893 14573 18.0" 
$ns at 665.659235433796 "$node_(595) setdest 115411 10722 14.0" 
$ns at 768.4222772466889 "$node_(595) setdest 21513 287 13.0" 
$ns at 836.7817036177587 "$node_(595) setdest 83487 23770 17.0" 
$ns at 585.4475362884156 "$node_(596) setdest 88293 5159 15.0" 
$ns at 699.910382902119 "$node_(596) setdest 114491 19741 5.0" 
$ns at 757.1819842473901 "$node_(596) setdest 9668 33037 17.0" 
$ns at 501.7370211402396 "$node_(597) setdest 133247 8860 2.0" 
$ns at 536.2900996095257 "$node_(597) setdest 39634 12809 19.0" 
$ns at 714.0644767570777 "$node_(597) setdest 113473 7580 15.0" 
$ns at 770.370795357758 "$node_(597) setdest 125738 35364 7.0" 
$ns at 810.0903571446107 "$node_(597) setdest 90380 17984 2.0" 
$ns at 851.6368807715162 "$node_(597) setdest 23401 40540 4.0" 
$ns at 592.9639818692963 "$node_(598) setdest 41158 16972 19.0" 
$ns at 736.165913567276 "$node_(598) setdest 13778 9358 12.0" 
$ns at 879.188224672366 "$node_(598) setdest 77205 30974 12.0" 
$ns at 526.118814584228 "$node_(599) setdest 122028 42757 17.0" 
$ns at 677.400169896408 "$node_(599) setdest 43119 32519 3.0" 
$ns at 732.3583154167429 "$node_(599) setdest 101165 28651 1.0" 
$ns at 762.360840800536 "$node_(599) setdest 113570 33974 15.0" 
$ns at 876.92937167 "$node_(599) setdest 8945 20639 9.0" 
$ns at 676.7789534425709 "$node_(600) setdest 72467 11761 1.0" 
$ns at 712.5910249519522 "$node_(600) setdest 2150 27552 4.0" 
$ns at 756.1252910525164 "$node_(600) setdest 35763 26236 6.0" 
$ns at 838.0195812350593 "$node_(600) setdest 86403 10480 15.0" 
$ns at 606.5419385791029 "$node_(601) setdest 30149 7906 4.0" 
$ns at 654.5121412766816 "$node_(601) setdest 132394 33460 11.0" 
$ns at 718.3949922516333 "$node_(601) setdest 90979 12848 1.0" 
$ns at 749.9996588935371 "$node_(601) setdest 120090 22439 2.0" 
$ns at 788.7717189826544 "$node_(601) setdest 128847 2790 3.0" 
$ns at 824.3085539985366 "$node_(601) setdest 57000 29026 8.0" 
$ns at 887.297568052864 "$node_(601) setdest 92380 14275 14.0" 
$ns at 654.3083538799489 "$node_(602) setdest 91553 18279 11.0" 
$ns at 759.8144521904712 "$node_(602) setdest 29457 10818 9.0" 
$ns at 795.9067596556295 "$node_(602) setdest 100595 34328 2.0" 
$ns at 839.9886819264934 "$node_(602) setdest 60249 17960 14.0" 
$ns at 619.4116135976943 "$node_(603) setdest 44939 2527 4.0" 
$ns at 673.2503408061068 "$node_(603) setdest 105357 13414 12.0" 
$ns at 806.376125943664 "$node_(603) setdest 78498 39717 16.0" 
$ns at 885.2331797893014 "$node_(603) setdest 35143 2056 6.0" 
$ns at 669.181723479096 "$node_(604) setdest 17240 42935 10.0" 
$ns at 717.0577121264446 "$node_(604) setdest 47512 26825 12.0" 
$ns at 797.0716834035081 "$node_(604) setdest 64296 26704 14.0" 
$ns at 873.8577965521703 "$node_(604) setdest 45533 13774 19.0" 
$ns at 633.0798076124314 "$node_(605) setdest 98796 40218 1.0" 
$ns at 665.1428838736725 "$node_(605) setdest 61496 13387 17.0" 
$ns at 714.0370957406336 "$node_(605) setdest 101908 6722 19.0" 
$ns at 867.4066080798291 "$node_(605) setdest 5166 15331 13.0" 
$ns at 653.1768707702328 "$node_(606) setdest 899 36768 13.0" 
$ns at 806.6268779348618 "$node_(606) setdest 62776 25506 6.0" 
$ns at 864.122054512196 "$node_(606) setdest 87946 8621 19.0" 
$ns at 604.8189232224769 "$node_(607) setdest 98076 43989 10.0" 
$ns at 665.1335617418437 "$node_(607) setdest 131160 24814 14.0" 
$ns at 775.8160553481011 "$node_(607) setdest 60717 10069 19.0" 
$ns at 625.6199882117886 "$node_(608) setdest 104668 20458 5.0" 
$ns at 698.9991050880542 "$node_(608) setdest 11920 20315 2.0" 
$ns at 738.5332874780296 "$node_(608) setdest 113823 2487 19.0" 
$ns at 638.6667912797045 "$node_(609) setdest 114322 39524 5.0" 
$ns at 680.3070704401966 "$node_(609) setdest 98721 31958 11.0" 
$ns at 799.6359834534718 "$node_(609) setdest 33334 4714 8.0" 
$ns at 841.0237058858582 "$node_(609) setdest 37036 43230 19.0" 
$ns at 610.7302284479306 "$node_(610) setdest 105842 2557 9.0" 
$ns at 667.1420245504687 "$node_(610) setdest 84863 33263 6.0" 
$ns at 739.4562306086576 "$node_(610) setdest 44997 27624 5.0" 
$ns at 802.6550023991266 "$node_(610) setdest 92311 6351 17.0" 
$ns at 626.3982656353859 "$node_(611) setdest 16228 36808 6.0" 
$ns at 700.4405173899902 "$node_(611) setdest 30211 11359 15.0" 
$ns at 803.2075702378634 "$node_(611) setdest 125223 24312 18.0" 
$ns at 866.8916245530428 "$node_(611) setdest 14330 1863 16.0" 
$ns at 643.1176467927578 "$node_(612) setdest 64999 25399 10.0" 
$ns at 685.8101614467115 "$node_(612) setdest 48444 40214 10.0" 
$ns at 814.6326440993366 "$node_(612) setdest 119801 9768 13.0" 
$ns at 848.5371188105734 "$node_(612) setdest 17446 19490 14.0" 
$ns at 880.3061416837838 "$node_(612) setdest 66115 39224 17.0" 
$ns at 631.6422531667733 "$node_(613) setdest 2479 31947 7.0" 
$ns at 661.7773324460109 "$node_(613) setdest 56255 15081 5.0" 
$ns at 720.3080072393159 "$node_(613) setdest 15655 35837 16.0" 
$ns at 767.5014171173684 "$node_(613) setdest 101025 36289 2.0" 
$ns at 801.7463035984883 "$node_(613) setdest 89308 24976 1.0" 
$ns at 837.5842629070581 "$node_(613) setdest 129239 24606 17.0" 
$ns at 643.3811748025724 "$node_(614) setdest 132395 18548 11.0" 
$ns at 680.4106402931917 "$node_(614) setdest 49243 792 17.0" 
$ns at 816.6106778737051 "$node_(614) setdest 35864 4095 15.0" 
$ns at 619.3259712410556 "$node_(615) setdest 133452 43324 16.0" 
$ns at 704.7680545608769 "$node_(615) setdest 3705 41813 16.0" 
$ns at 803.9342899894991 "$node_(615) setdest 66151 15976 19.0" 
$ns at 844.1929717098393 "$node_(615) setdest 79618 26117 1.0" 
$ns at 883.2059490918443 "$node_(615) setdest 40682 41388 15.0" 
$ns at 688.6232308550241 "$node_(616) setdest 32791 30833 9.0" 
$ns at 743.7405447022775 "$node_(616) setdest 59149 12930 4.0" 
$ns at 793.4052627532443 "$node_(616) setdest 91288 10010 2.0" 
$ns at 829.0210017405655 "$node_(616) setdest 113574 20856 16.0" 
$ns at 876.4295058218299 "$node_(616) setdest 87413 21176 19.0" 
$ns at 712.2506050263818 "$node_(617) setdest 108297 3440 20.0" 
$ns at 814.0729926804474 "$node_(617) setdest 58472 9531 17.0" 
$ns at 879.1585038492608 "$node_(617) setdest 9473 33944 7.0" 
$ns at 724.6444035368027 "$node_(618) setdest 117564 23174 1.0" 
$ns at 761.7285768301778 "$node_(618) setdest 131664 3291 3.0" 
$ns at 804.0587662172027 "$node_(618) setdest 111211 8394 19.0" 
$ns at 706.0651514007716 "$node_(619) setdest 11774 1043 9.0" 
$ns at 780.9607793833804 "$node_(619) setdest 43275 21370 10.0" 
$ns at 829.3532528294176 "$node_(619) setdest 22459 22156 15.0" 
$ns at 609.8730627542312 "$node_(620) setdest 49200 12129 9.0" 
$ns at 719.5972717726828 "$node_(620) setdest 72829 3649 15.0" 
$ns at 755.353006502319 "$node_(620) setdest 33147 41102 7.0" 
$ns at 794.996744719802 "$node_(620) setdest 37501 37151 15.0" 
$ns at 828.8897888178942 "$node_(620) setdest 63868 29764 13.0" 
$ns at 695.8770863007071 "$node_(621) setdest 40778 16406 3.0" 
$ns at 740.0161065274988 "$node_(621) setdest 28449 26010 14.0" 
$ns at 816.9930270669478 "$node_(621) setdest 112084 27171 7.0" 
$ns at 888.924084875372 "$node_(621) setdest 59396 29965 4.0" 
$ns at 656.6484413434964 "$node_(622) setdest 128805 34133 19.0" 
$ns at 829.5673502625176 "$node_(622) setdest 99130 7736 13.0" 
$ns at 866.4061684423341 "$node_(622) setdest 21936 43764 18.0" 
$ns at 680.4383793689406 "$node_(623) setdest 23826 40860 1.0" 
$ns at 713.8246691351015 "$node_(623) setdest 87480 30437 15.0" 
$ns at 847.1028130944547 "$node_(623) setdest 53063 16016 19.0" 
$ns at 897.0138873172054 "$node_(623) setdest 129858 4275 1.0" 
$ns at 609.9501041424509 "$node_(624) setdest 123123 12081 17.0" 
$ns at 715.5599995928249 "$node_(624) setdest 41948 37112 18.0" 
$ns at 881.9065329664373 "$node_(624) setdest 99144 28472 11.0" 
$ns at 637.4975139403143 "$node_(625) setdest 13505 2308 11.0" 
$ns at 737.6331722912387 "$node_(625) setdest 113255 4875 2.0" 
$ns at 773.8436734353365 "$node_(625) setdest 96945 30265 7.0" 
$ns at 804.9602609674988 "$node_(625) setdest 92027 11344 3.0" 
$ns at 855.61160825826 "$node_(625) setdest 101372 21838 15.0" 
$ns at 624.9190130641284 "$node_(626) setdest 75079 20755 18.0" 
$ns at 758.9227187107376 "$node_(626) setdest 95267 942 3.0" 
$ns at 803.6445441428901 "$node_(626) setdest 17316 27245 8.0" 
$ns at 836.2274941679082 "$node_(626) setdest 101506 21486 10.0" 
$ns at 603.6014579568248 "$node_(627) setdest 132877 23750 2.0" 
$ns at 653.4950733825971 "$node_(627) setdest 87791 24862 4.0" 
$ns at 693.9007102787219 "$node_(627) setdest 41296 11689 8.0" 
$ns at 781.668739876656 "$node_(627) setdest 72658 37788 15.0" 
$ns at 626.200282620482 "$node_(628) setdest 78300 35681 1.0" 
$ns at 659.0761681398935 "$node_(628) setdest 104629 41405 7.0" 
$ns at 744.5185725937777 "$node_(628) setdest 103133 27864 5.0" 
$ns at 823.845515055506 "$node_(628) setdest 129858 10446 12.0" 
$ns at 707.8390572999976 "$node_(629) setdest 12893 24074 13.0" 
$ns at 834.7488216469958 "$node_(629) setdest 20129 29200 3.0" 
$ns at 868.9489719183465 "$node_(629) setdest 45318 22497 17.0" 
$ns at 740.0869499643265 "$node_(630) setdest 101716 1334 10.0" 
$ns at 822.8413525818237 "$node_(630) setdest 96494 28132 14.0" 
$ns at 860.5882535736968 "$node_(630) setdest 9943 22523 5.0" 
$ns at 896.9203299155158 "$node_(630) setdest 124233 25401 12.0" 
$ns at 642.1466490280727 "$node_(631) setdest 29185 11055 10.0" 
$ns at 741.6768273433765 "$node_(631) setdest 17270 5528 8.0" 
$ns at 782.3334861494424 "$node_(631) setdest 132254 23319 18.0" 
$ns at 709.7928902072013 "$node_(632) setdest 28143 34677 17.0" 
$ns at 789.6254042225531 "$node_(632) setdest 35938 38291 17.0" 
$ns at 857.7081941389424 "$node_(632) setdest 83373 20125 7.0" 
$ns at 892.9055833847541 "$node_(632) setdest 119170 9952 10.0" 
$ns at 602.9978081790722 "$node_(633) setdest 92559 4775 12.0" 
$ns at 734.1858996884384 "$node_(633) setdest 46924 7079 10.0" 
$ns at 771.3003916757592 "$node_(633) setdest 70276 26803 1.0" 
$ns at 805.1781605748338 "$node_(633) setdest 66088 17833 18.0" 
$ns at 849.1153551482183 "$node_(633) setdest 122887 44221 18.0" 
$ns at 616.1599859040505 "$node_(634) setdest 14421 18692 6.0" 
$ns at 667.797869681636 "$node_(634) setdest 70524 9208 15.0" 
$ns at 843.1172330214378 "$node_(634) setdest 89117 17448 11.0" 
$ns at 611.7918808325641 "$node_(635) setdest 64867 37885 8.0" 
$ns at 710.6116222830493 "$node_(635) setdest 16570 19948 10.0" 
$ns at 777.0180370884303 "$node_(635) setdest 121535 32360 5.0" 
$ns at 823.0702689632932 "$node_(635) setdest 102274 19974 15.0" 
$ns at 882.703353143562 "$node_(635) setdest 35392 747 12.0" 
$ns at 617.9600843038593 "$node_(636) setdest 4818 23558 17.0" 
$ns at 650.8720464360638 "$node_(636) setdest 115956 29121 1.0" 
$ns at 685.645555786887 "$node_(636) setdest 60462 17067 4.0" 
$ns at 747.2766315158376 "$node_(636) setdest 117741 40201 5.0" 
$ns at 795.7583790291611 "$node_(636) setdest 105784 14563 18.0" 
$ns at 839.3808488001217 "$node_(636) setdest 100993 212 15.0" 
$ns at 616.3269401385431 "$node_(637) setdest 107544 15318 10.0" 
$ns at 733.7276050449673 "$node_(637) setdest 29779 17003 9.0" 
$ns at 847.7784133952807 "$node_(637) setdest 30399 30792 10.0" 
$ns at 664.5636796774494 "$node_(638) setdest 98371 30355 14.0" 
$ns at 794.8474981666574 "$node_(638) setdest 105772 23387 11.0" 
$ns at 620.8109511229803 "$node_(639) setdest 48661 11216 19.0" 
$ns at 722.0532017895636 "$node_(639) setdest 26410 38909 8.0" 
$ns at 766.3559491457052 "$node_(639) setdest 41641 25671 13.0" 
$ns at 863.2292930932496 "$node_(639) setdest 104052 13821 18.0" 
$ns at 665.1330601633724 "$node_(640) setdest 27991 18496 18.0" 
$ns at 802.7304005475294 "$node_(640) setdest 85759 7002 13.0" 
$ns at 851.9689596789445 "$node_(640) setdest 86967 21959 8.0" 
$ns at 623.8825054526053 "$node_(641) setdest 37552 42695 2.0" 
$ns at 670.4427706881692 "$node_(641) setdest 98072 19239 10.0" 
$ns at 780.5252126437945 "$node_(641) setdest 16093 21200 17.0" 
$ns at 652.9733623158686 "$node_(642) setdest 50631 8236 2.0" 
$ns at 701.3876441399841 "$node_(642) setdest 91296 15108 7.0" 
$ns at 781.5675250395711 "$node_(642) setdest 8270 19889 11.0" 
$ns at 860.8339345385763 "$node_(642) setdest 92349 30302 10.0" 
$ns at 712.7844722342065 "$node_(643) setdest 10753 15204 3.0" 
$ns at 765.7101677922494 "$node_(643) setdest 76328 31189 18.0" 
$ns at 895.6782554767312 "$node_(643) setdest 43077 4156 15.0" 
$ns at 684.8029310469116 "$node_(644) setdest 83427 42438 3.0" 
$ns at 738.4091089908976 "$node_(644) setdest 68799 44533 15.0" 
$ns at 824.1535287894561 "$node_(644) setdest 3319 16773 13.0" 
$ns at 859.5978471467093 "$node_(644) setdest 36303 34787 1.0" 
$ns at 896.6569366902697 "$node_(644) setdest 54209 10076 11.0" 
$ns at 716.8567248649048 "$node_(645) setdest 33264 40812 10.0" 
$ns at 845.1376104435462 "$node_(645) setdest 50533 23068 16.0" 
$ns at 719.3416732908632 "$node_(646) setdest 91121 4679 18.0" 
$ns at 780.89272648784 "$node_(646) setdest 31613 43659 7.0" 
$ns at 871.8481869148357 "$node_(646) setdest 1449 9370 19.0" 
$ns at 668.1913603677319 "$node_(647) setdest 20084 14007 13.0" 
$ns at 818.0343346337429 "$node_(647) setdest 40102 39903 1.0" 
$ns at 855.3449577848921 "$node_(647) setdest 132619 12623 19.0" 
$ns at 616.022091445636 "$node_(648) setdest 73531 42494 6.0" 
$ns at 646.8540049173961 "$node_(648) setdest 129445 41393 14.0" 
$ns at 802.4721355940786 "$node_(648) setdest 65526 42523 5.0" 
$ns at 846.5436205764852 "$node_(648) setdest 71063 31213 16.0" 
$ns at 712.7568787010609 "$node_(649) setdest 99444 13059 1.0" 
$ns at 750.427985822515 "$node_(649) setdest 54021 14507 2.0" 
$ns at 783.8617582580498 "$node_(649) setdest 70652 13439 9.0" 
$ns at 886.4281734122126 "$node_(649) setdest 62567 5630 1.0" 
$ns at 616.1586343406627 "$node_(650) setdest 7604 1329 3.0" 
$ns at 667.8988137928009 "$node_(650) setdest 48451 20472 17.0" 
$ns at 722.6625732657958 "$node_(650) setdest 30504 2639 13.0" 
$ns at 862.9898506581084 "$node_(650) setdest 77190 26855 1.0" 
$ns at 679.5775060828499 "$node_(651) setdest 71196 40057 6.0" 
$ns at 750.5116647021927 "$node_(651) setdest 106246 5977 20.0" 
$ns at 838.2084151695445 "$node_(651) setdest 95676 36061 7.0" 
$ns at 625.5115979015214 "$node_(652) setdest 132594 34552 2.0" 
$ns at 666.262246657241 "$node_(652) setdest 66733 13449 7.0" 
$ns at 762.1812997754253 "$node_(652) setdest 19777 6150 1.0" 
$ns at 802.0478424995896 "$node_(652) setdest 84167 42235 18.0" 
$ns at 874.9716017032795 "$node_(652) setdest 105342 43728 9.0" 
$ns at 643.5946480012709 "$node_(653) setdest 96094 20421 3.0" 
$ns at 695.7309360190364 "$node_(653) setdest 46304 9337 2.0" 
$ns at 739.2229211664368 "$node_(653) setdest 43116 36220 12.0" 
$ns at 826.9081085379852 "$node_(653) setdest 41817 31503 3.0" 
$ns at 858.4373932368044 "$node_(653) setdest 123565 29623 1.0" 
$ns at 896.6465894829292 "$node_(653) setdest 73546 14112 1.0" 
$ns at 629.7983585181211 "$node_(654) setdest 49299 9194 9.0" 
$ns at 714.1700545501352 "$node_(654) setdest 31575 32407 13.0" 
$ns at 873.7219095927402 "$node_(654) setdest 123698 16455 20.0" 
$ns at 654.5025059275108 "$node_(655) setdest 32038 14800 1.0" 
$ns at 693.1261980175384 "$node_(655) setdest 93533 6690 6.0" 
$ns at 763.3973583558413 "$node_(655) setdest 54231 20191 8.0" 
$ns at 859.3146188761659 "$node_(655) setdest 81437 36183 13.0" 
$ns at 801.8880270363754 "$node_(656) setdest 18518 41004 14.0" 
$ns at 600.7023106040009 "$node_(657) setdest 122534 8034 15.0" 
$ns at 690.5923743606747 "$node_(657) setdest 114435 3132 14.0" 
$ns at 800.5289460138744 "$node_(657) setdest 108632 15372 12.0" 
$ns at 671.9265832637637 "$node_(658) setdest 49533 31554 17.0" 
$ns at 710.153230002931 "$node_(658) setdest 100650 34083 1.0" 
$ns at 745.1849488608603 "$node_(658) setdest 117047 2448 5.0" 
$ns at 821.9246167861149 "$node_(658) setdest 114134 1501 19.0" 
$ns at 687.7133739887738 "$node_(659) setdest 111657 16543 1.0" 
$ns at 721.2508574412626 "$node_(659) setdest 105998 23349 7.0" 
$ns at 818.1607272351008 "$node_(659) setdest 15319 31236 15.0" 
$ns at 883.7976195484056 "$node_(659) setdest 122717 37887 5.0" 
$ns at 645.9974611371993 "$node_(660) setdest 115583 7438 15.0" 
$ns at 680.0180994781007 "$node_(660) setdest 81642 5858 5.0" 
$ns at 727.446116170496 "$node_(660) setdest 16096 28915 18.0" 
$ns at 779.2033195528903 "$node_(660) setdest 81836 8577 19.0" 
$ns at 888.3718832910187 "$node_(660) setdest 101678 26061 2.0" 
$ns at 724.2890020574719 "$node_(661) setdest 88799 23932 9.0" 
$ns at 783.5251761907571 "$node_(661) setdest 117888 35823 3.0" 
$ns at 837.3203760142088 "$node_(661) setdest 3270 25657 15.0" 
$ns at 622.2572142873693 "$node_(662) setdest 57531 34052 6.0" 
$ns at 681.1505309506115 "$node_(662) setdest 13532 12777 11.0" 
$ns at 804.5266149393758 "$node_(662) setdest 123447 40142 8.0" 
$ns at 836.3890045052843 "$node_(662) setdest 110203 2666 20.0" 
$ns at 873.2090810978816 "$node_(662) setdest 130617 42490 16.0" 
$ns at 658.6337185036484 "$node_(663) setdest 31236 32859 1.0" 
$ns at 693.2171438952487 "$node_(663) setdest 13537 13043 8.0" 
$ns at 754.3097240689461 "$node_(663) setdest 124213 22577 13.0" 
$ns at 845.5537273680746 "$node_(663) setdest 67833 23658 13.0" 
$ns at 892.2142860340139 "$node_(663) setdest 18567 40474 2.0" 
$ns at 702.6682960651569 "$node_(664) setdest 28583 14845 6.0" 
$ns at 752.9933555091422 "$node_(664) setdest 65703 32153 5.0" 
$ns at 817.367342373694 "$node_(664) setdest 37771 29797 4.0" 
$ns at 869.3265659670824 "$node_(664) setdest 41398 26963 13.0" 
$ns at 723.6037267470413 "$node_(665) setdest 103447 13909 16.0" 
$ns at 771.0529735045922 "$node_(665) setdest 16306 39940 4.0" 
$ns at 830.7111693481306 "$node_(665) setdest 37795 30822 16.0" 
$ns at 602.3471530566947 "$node_(666) setdest 1874 2949 6.0" 
$ns at 661.6951382984968 "$node_(666) setdest 5938 26807 14.0" 
$ns at 718.2910719312605 "$node_(666) setdest 122324 33002 7.0" 
$ns at 798.1375140811313 "$node_(666) setdest 63843 28380 2.0" 
$ns at 831.7542119776865 "$node_(666) setdest 67030 27021 15.0" 
$ns at 894.3438084730601 "$node_(666) setdest 72594 32797 14.0" 
$ns at 619.5832308841929 "$node_(667) setdest 122859 3033 4.0" 
$ns at 682.1722943719503 "$node_(667) setdest 94004 14419 13.0" 
$ns at 811.0059520560853 "$node_(667) setdest 93847 21141 5.0" 
$ns at 842.1082020752543 "$node_(667) setdest 76887 26268 12.0" 
$ns at 757.1619569193147 "$node_(668) setdest 72289 24316 3.0" 
$ns at 794.2383390149623 "$node_(668) setdest 106577 29919 17.0" 
$ns at 680.5198583028683 "$node_(669) setdest 127841 41561 19.0" 
$ns at 743.1142166581333 "$node_(669) setdest 15733 29571 18.0" 
$ns at 784.3978876006581 "$node_(669) setdest 92894 23682 11.0" 
$ns at 858.7205782067596 "$node_(669) setdest 39180 7204 1.0" 
$ns at 894.2279225784237 "$node_(669) setdest 87212 35999 19.0" 
$ns at 636.2628500145994 "$node_(670) setdest 78716 22080 9.0" 
$ns at 755.6483488030321 "$node_(670) setdest 19418 35806 5.0" 
$ns at 827.522853534049 "$node_(670) setdest 11637 30977 8.0" 
$ns at 641.8658928372038 "$node_(671) setdest 34070 41403 7.0" 
$ns at 682.8565896307209 "$node_(671) setdest 70825 176 11.0" 
$ns at 759.3101120456424 "$node_(671) setdest 50874 31769 4.0" 
$ns at 815.6271037491499 "$node_(671) setdest 122588 35661 14.0" 
$ns at 689.6982419381977 "$node_(672) setdest 92990 6684 13.0" 
$ns at 740.9789218946473 "$node_(672) setdest 29406 42978 6.0" 
$ns at 816.4704230441547 "$node_(672) setdest 53339 7960 1.0" 
$ns at 853.8094913765274 "$node_(672) setdest 65008 36742 16.0" 
$ns at 887.9255727251007 "$node_(672) setdest 87789 29564 19.0" 
$ns at 646.5292755892866 "$node_(673) setdest 103143 38225 17.0" 
$ns at 843.6489424511991 "$node_(673) setdest 33862 17656 5.0" 
$ns at 603.8516635946038 "$node_(674) setdest 40410 3373 12.0" 
$ns at 654.8482285538765 "$node_(674) setdest 22716 22807 2.0" 
$ns at 690.5860443435841 "$node_(674) setdest 119823 10961 11.0" 
$ns at 805.2042026657853 "$node_(674) setdest 45945 28510 9.0" 
$ns at 885.5239834687526 "$node_(674) setdest 12114 29464 7.0" 
$ns at 644.1651796015442 "$node_(675) setdest 78197 13145 13.0" 
$ns at 770.6139821398554 "$node_(675) setdest 62925 9239 13.0" 
$ns at 841.692230280718 "$node_(675) setdest 114178 35561 9.0" 
$ns at 688.8312728574632 "$node_(676) setdest 585 16058 3.0" 
$ns at 745.5559217723617 "$node_(676) setdest 95520 41934 17.0" 
$ns at 629.1358562742372 "$node_(677) setdest 113945 9323 15.0" 
$ns at 684.3556603974033 "$node_(677) setdest 84932 15789 13.0" 
$ns at 755.3288252447327 "$node_(677) setdest 79155 22710 12.0" 
$ns at 801.9869435661217 "$node_(677) setdest 120404 5281 16.0" 
$ns at 873.8358869819887 "$node_(677) setdest 93131 23353 18.0" 
$ns at 658.4297041137409 "$node_(678) setdest 78933 35594 19.0" 
$ns at 855.0931539360199 "$node_(678) setdest 62239 34055 16.0" 
$ns at 630.8830000642661 "$node_(679) setdest 121557 41570 9.0" 
$ns at 722.9781927623637 "$node_(679) setdest 59323 7147 14.0" 
$ns at 824.1776299603849 "$node_(679) setdest 131663 18553 3.0" 
$ns at 866.1408984517315 "$node_(679) setdest 131933 37444 7.0" 
$ns at 640.9097233109064 "$node_(680) setdest 63357 32447 9.0" 
$ns at 702.2416091132305 "$node_(680) setdest 98207 35092 17.0" 
$ns at 776.5806537833491 "$node_(680) setdest 40937 3658 4.0" 
$ns at 814.0464534061148 "$node_(680) setdest 133710 892 8.0" 
$ns at 642.4326883757481 "$node_(681) setdest 51213 42419 16.0" 
$ns at 752.5187454344511 "$node_(681) setdest 67120 25772 1.0" 
$ns at 787.5739382987605 "$node_(681) setdest 21575 19604 13.0" 
$ns at 824.3725846982513 "$node_(681) setdest 4874 8572 8.0" 
$ns at 644.765138766804 "$node_(682) setdest 30694 36258 17.0" 
$ns at 809.4511334616336 "$node_(682) setdest 110490 43658 2.0" 
$ns at 856.7245021517888 "$node_(682) setdest 77803 13489 4.0" 
$ns at 888.8388324587792 "$node_(682) setdest 76871 10377 13.0" 
$ns at 630.6078195124709 "$node_(683) setdest 613 43645 4.0" 
$ns at 672.4984486482372 "$node_(683) setdest 22918 23774 10.0" 
$ns at 778.2432162098311 "$node_(683) setdest 9692 42786 3.0" 
$ns at 809.1461376348503 "$node_(683) setdest 79355 26812 13.0" 
$ns at 876.6388977701852 "$node_(683) setdest 24995 38866 11.0" 
$ns at 632.9547927195714 "$node_(684) setdest 112829 40404 6.0" 
$ns at 721.7110482350729 "$node_(684) setdest 133826 590 19.0" 
$ns at 847.9254862629191 "$node_(684) setdest 132335 21561 10.0" 
$ns at 610.891546616581 "$node_(685) setdest 109590 34030 11.0" 
$ns at 749.9063759233113 "$node_(685) setdest 46867 25374 15.0" 
$ns at 800.4384917909733 "$node_(685) setdest 61556 20397 11.0" 
$ns at 635.4471416356272 "$node_(686) setdest 74334 23967 3.0" 
$ns at 690.3467662552591 "$node_(686) setdest 31729 12159 4.0" 
$ns at 732.1877457919871 "$node_(686) setdest 57728 5551 16.0" 
$ns at 627.5561352389828 "$node_(687) setdest 12078 28581 9.0" 
$ns at 736.8313053793636 "$node_(687) setdest 85695 1334 9.0" 
$ns at 768.1359503854069 "$node_(687) setdest 21057 22251 11.0" 
$ns at 815.1798022680067 "$node_(687) setdest 19348 22745 4.0" 
$ns at 884.9038397263708 "$node_(687) setdest 79604 29246 15.0" 
$ns at 654.3318248982846 "$node_(688) setdest 53598 21965 11.0" 
$ns at 719.0891037014027 "$node_(688) setdest 10308 38083 1.0" 
$ns at 752.3345357796511 "$node_(688) setdest 102303 30041 9.0" 
$ns at 788.679334762116 "$node_(688) setdest 82863 37257 4.0" 
$ns at 836.6999343046936 "$node_(688) setdest 26207 39379 2.0" 
$ns at 874.4988861725443 "$node_(688) setdest 105025 360 9.0" 
$ns at 665.0946692404552 "$node_(689) setdest 117706 42468 19.0" 
$ns at 882.6785647649074 "$node_(689) setdest 126524 37560 10.0" 
$ns at 600.080638422942 "$node_(690) setdest 62796 36829 6.0" 
$ns at 667.4474380951731 "$node_(690) setdest 83297 38167 1.0" 
$ns at 699.9814414716651 "$node_(690) setdest 3912 6063 18.0" 
$ns at 765.8486653030101 "$node_(690) setdest 106481 32508 18.0" 
$ns at 852.89557568081 "$node_(690) setdest 77182 29160 15.0" 
$ns at 883.1704841292877 "$node_(690) setdest 52130 22097 16.0" 
$ns at 628.0022902718332 "$node_(691) setdest 67645 35731 17.0" 
$ns at 778.2026632873892 "$node_(691) setdest 19365 7560 12.0" 
$ns at 859.3488977111931 "$node_(691) setdest 64790 14166 13.0" 
$ns at 633.0457985825285 "$node_(692) setdest 99901 20391 9.0" 
$ns at 688.8593806550703 "$node_(692) setdest 105408 22701 4.0" 
$ns at 723.310117570164 "$node_(692) setdest 73013 31146 18.0" 
$ns at 777.6605188396102 "$node_(692) setdest 38565 7663 10.0" 
$ns at 869.1182698865445 "$node_(692) setdest 103117 25388 3.0" 
$ns at 679.1502643953022 "$node_(693) setdest 22812 1761 15.0" 
$ns at 780.6554378274157 "$node_(693) setdest 16085 28244 13.0" 
$ns at 872.2355663998515 "$node_(693) setdest 59991 2647 13.0" 
$ns at 629.3296187397062 "$node_(694) setdest 44435 12510 10.0" 
$ns at 675.841851012375 "$node_(694) setdest 58361 12968 3.0" 
$ns at 725.6076784865971 "$node_(694) setdest 18561 12317 5.0" 
$ns at 766.0714985301701 "$node_(694) setdest 23168 10630 4.0" 
$ns at 821.713210700012 "$node_(694) setdest 73724 10393 13.0" 
$ns at 613.9378545517651 "$node_(695) setdest 101467 40837 9.0" 
$ns at 719.3026505263756 "$node_(695) setdest 13303 6717 2.0" 
$ns at 757.5070421484497 "$node_(695) setdest 115831 12891 20.0" 
$ns at 641.7864504198267 "$node_(696) setdest 31864 7614 7.0" 
$ns at 739.7164482480646 "$node_(696) setdest 36469 30102 3.0" 
$ns at 775.7918347811412 "$node_(696) setdest 59360 23588 6.0" 
$ns at 831.4044274241224 "$node_(696) setdest 88932 34333 13.0" 
$ns at 619.1730932254774 "$node_(697) setdest 60387 20028 18.0" 
$ns at 678.835849909095 "$node_(697) setdest 71353 41505 17.0" 
$ns at 877.7062695879144 "$node_(697) setdest 45669 11944 8.0" 
$ns at 621.5729988384851 "$node_(698) setdest 91920 34663 7.0" 
$ns at 660.9545431822991 "$node_(698) setdest 84409 41608 19.0" 
$ns at 853.8756311120555 "$node_(698) setdest 69863 35486 15.0" 
$ns at 693.7674508582279 "$node_(699) setdest 22390 27523 19.0" 
$ns at 871.0176627076569 "$node_(699) setdest 126046 23857 7.0" 
$ns at 707.142824590755 "$node_(700) setdest 24023 19807 9.0" 
$ns at 815.8467677290034 "$node_(700) setdest 118508 23288 2.0" 
$ns at 849.2125408858828 "$node_(700) setdest 66194 10930 6.0" 
$ns at 742.2899220958271 "$node_(701) setdest 126999 43501 6.0" 
$ns at 784.7471802254086 "$node_(701) setdest 62168 6933 4.0" 
$ns at 841.6795999216007 "$node_(701) setdest 49926 29041 1.0" 
$ns at 881.4283198842611 "$node_(701) setdest 124664 32814 13.0" 
$ns at 718.1513041907684 "$node_(702) setdest 11319 36775 5.0" 
$ns at 759.4851152422582 "$node_(702) setdest 105992 11203 2.0" 
$ns at 796.3244065994608 "$node_(702) setdest 131116 7264 16.0" 
$ns at 875.1322653253092 "$node_(702) setdest 117806 40959 17.0" 
$ns at 729.1784072255007 "$node_(703) setdest 81172 7222 7.0" 
$ns at 781.5301133779906 "$node_(703) setdest 9546 10518 12.0" 
$ns at 845.7749430185305 "$node_(703) setdest 92524 4278 4.0" 
$ns at 892.6050754145906 "$node_(703) setdest 15227 27473 12.0" 
$ns at 749.4773110141455 "$node_(704) setdest 60627 11684 6.0" 
$ns at 788.849388099721 "$node_(704) setdest 46133 25766 5.0" 
$ns at 858.6805100398219 "$node_(704) setdest 118371 40869 18.0" 
$ns at 771.9201975890526 "$node_(705) setdest 90884 40734 18.0" 
$ns at 706.5268817452263 "$node_(706) setdest 182 5154 19.0" 
$ns at 818.4543713336582 "$node_(706) setdest 71972 36214 1.0" 
$ns at 852.1306955448363 "$node_(706) setdest 91229 26056 10.0" 
$ns at 794.4783243890826 "$node_(707) setdest 60802 16248 10.0" 
$ns at 840.469634738772 "$node_(707) setdest 128446 11523 15.0" 
$ns at 715.9523054845879 "$node_(708) setdest 10373 18893 18.0" 
$ns at 791.7843150796988 "$node_(708) setdest 34752 12112 18.0" 
$ns at 845.7378287974992 "$node_(708) setdest 50677 151 13.0" 
$ns at 746.3789904316573 "$node_(709) setdest 106107 28293 19.0" 
$ns at 847.2896853984154 "$node_(709) setdest 123717 4436 9.0" 
$ns at 726.6132569006977 "$node_(710) setdest 115850 17537 13.0" 
$ns at 785.0205897525638 "$node_(710) setdest 22820 27463 14.0" 
$ns at 871.3108414202297 "$node_(710) setdest 26685 41874 12.0" 
$ns at 729.1908008972034 "$node_(711) setdest 56264 26477 8.0" 
$ns at 818.7605645819194 "$node_(711) setdest 104845 44363 16.0" 
$ns at 880.9432979080564 "$node_(711) setdest 102937 33327 18.0" 
$ns at 717.7214304086424 "$node_(712) setdest 2948 18687 12.0" 
$ns at 755.1250661345769 "$node_(712) setdest 33033 44247 13.0" 
$ns at 806.2018000155695 "$node_(712) setdest 80749 14144 2.0" 
$ns at 839.3236883918494 "$node_(712) setdest 31630 24523 13.0" 
$ns at 898.8887031904355 "$node_(712) setdest 39720 32569 4.0" 
$ns at 732.695423782978 "$node_(713) setdest 93972 10059 16.0" 
$ns at 891.0361665984115 "$node_(713) setdest 110553 28244 10.0" 
$ns at 809.9873793494371 "$node_(714) setdest 65086 17084 1.0" 
$ns at 844.6136178620558 "$node_(714) setdest 51401 20147 17.0" 
$ns at 700.1831383355532 "$node_(715) setdest 134111 23630 1.0" 
$ns at 730.8422000940686 "$node_(715) setdest 104006 5790 19.0" 
$ns at 876.7031977358763 "$node_(715) setdest 101973 4654 14.0" 
$ns at 736.1101112056676 "$node_(716) setdest 43158 17537 14.0" 
$ns at 811.0696427380055 "$node_(716) setdest 117514 15138 11.0" 
$ns at 709.9536897027933 "$node_(717) setdest 57226 1170 4.0" 
$ns at 762.7181180658001 "$node_(717) setdest 116472 24175 1.0" 
$ns at 793.1990422927829 "$node_(717) setdest 90106 36998 10.0" 
$ns at 867.8178198481171 "$node_(717) setdest 1411 896 5.0" 
$ns at 715.1622113144251 "$node_(718) setdest 108666 24758 16.0" 
$ns at 862.2909472397964 "$node_(718) setdest 12675 42228 9.0" 
$ns at 738.2368870134724 "$node_(719) setdest 125008 21274 16.0" 
$ns at 860.1808869277891 "$node_(719) setdest 121604 21184 15.0" 
$ns at 766.9488391111863 "$node_(720) setdest 82352 30606 2.0" 
$ns at 806.5617147890725 "$node_(720) setdest 18095 36418 7.0" 
$ns at 858.8588095438441 "$node_(720) setdest 38328 16905 7.0" 
$ns at 710.7413289517685 "$node_(721) setdest 60923 40581 6.0" 
$ns at 763.4052182053307 "$node_(721) setdest 23267 41294 10.0" 
$ns at 798.3651282040306 "$node_(721) setdest 21376 21727 14.0" 
$ns at 721.2417348971669 "$node_(722) setdest 125739 1389 12.0" 
$ns at 819.9742327568647 "$node_(722) setdest 133941 32067 12.0" 
$ns at 859.4339863909702 "$node_(722) setdest 121411 14043 19.0" 
$ns at 751.1629914712838 "$node_(723) setdest 119930 41877 2.0" 
$ns at 795.1876546964227 "$node_(723) setdest 32648 11420 18.0" 
$ns at 867.1236220355579 "$node_(723) setdest 124062 42479 3.0" 
$ns at 760.8515320710367 "$node_(724) setdest 63225 43027 6.0" 
$ns at 793.7295418982305 "$node_(724) setdest 63519 3265 4.0" 
$ns at 834.4891460028459 "$node_(724) setdest 79801 19712 2.0" 
$ns at 881.7795016522794 "$node_(724) setdest 38118 25943 4.0" 
$ns at 774.174846713083 "$node_(725) setdest 22849 19301 9.0" 
$ns at 840.8730729832896 "$node_(725) setdest 76568 9807 18.0" 
$ns at 743.195015288716 "$node_(726) setdest 77598 29511 11.0" 
$ns at 877.7353293360709 "$node_(726) setdest 68326 39683 11.0" 
$ns at 739.5171960352911 "$node_(727) setdest 58647 39290 1.0" 
$ns at 770.990232194595 "$node_(727) setdest 108541 38551 3.0" 
$ns at 810.0429156104062 "$node_(727) setdest 75269 9092 8.0" 
$ns at 840.2778825736365 "$node_(727) setdest 111467 43096 9.0" 
$ns at 727.6921772460618 "$node_(728) setdest 117838 3139 17.0" 
$ns at 807.7109429872435 "$node_(728) setdest 47120 33701 17.0" 
$ns at 734.5360506593566 "$node_(729) setdest 116517 29786 7.0" 
$ns at 778.6237765945646 "$node_(729) setdest 103661 39240 10.0" 
$ns at 848.2189656216249 "$node_(729) setdest 74230 28891 13.0" 
$ns at 723.4650747849075 "$node_(730) setdest 102621 24597 2.0" 
$ns at 760.1750896148753 "$node_(730) setdest 132149 35840 14.0" 
$ns at 804.9512015818514 "$node_(730) setdest 59677 11054 14.0" 
$ns at 847.5344227368291 "$node_(731) setdest 32366 37339 10.0" 
$ns at 818.1346497482444 "$node_(732) setdest 64405 17726 10.0" 
$ns at 884.5948192632158 "$node_(732) setdest 17135 31126 8.0" 
$ns at 717.2345646466001 "$node_(733) setdest 72543 3105 5.0" 
$ns at 768.2860073475157 "$node_(733) setdest 16928 3926 16.0" 
$ns at 718.5992656458529 "$node_(734) setdest 32506 23814 3.0" 
$ns at 752.2132907859811 "$node_(734) setdest 67332 31160 13.0" 
$ns at 817.9669429076263 "$node_(734) setdest 19848 39151 15.0" 
$ns at 894.9283068834292 "$node_(734) setdest 37862 95 3.0" 
$ns at 818.4521120026797 "$node_(735) setdest 50339 24168 6.0" 
$ns at 897.9981893448573 "$node_(735) setdest 26339 15329 9.0" 
$ns at 774.3706753523815 "$node_(736) setdest 111682 3938 16.0" 
$ns at 709.488445873829 "$node_(737) setdest 85955 40544 16.0" 
$ns at 830.23504394801 "$node_(737) setdest 6538 34151 4.0" 
$ns at 883.4634368789153 "$node_(737) setdest 61438 33948 19.0" 
$ns at 714.3885819825829 "$node_(738) setdest 54244 31146 16.0" 
$ns at 843.995527314946 "$node_(738) setdest 56768 10517 8.0" 
$ns at 771.113464492684 "$node_(739) setdest 9978 18089 17.0" 
$ns at 883.8461107668904 "$node_(739) setdest 49907 22193 8.0" 
$ns at 726.6319140829389 "$node_(740) setdest 101827 13681 11.0" 
$ns at 758.6736696389651 "$node_(740) setdest 103162 31384 9.0" 
$ns at 799.5095788903373 "$node_(740) setdest 46684 10646 15.0" 
$ns at 836.6975982348952 "$node_(740) setdest 37808 19175 6.0" 
$ns at 876.0089948409939 "$node_(740) setdest 38137 38251 18.0" 
$ns at 837.5572576472068 "$node_(741) setdest 88101 26136 10.0" 
$ns at 894.0622725965846 "$node_(741) setdest 30973 21652 19.0" 
$ns at 754.0065794425179 "$node_(742) setdest 4734 44567 9.0" 
$ns at 829.8151958562629 "$node_(742) setdest 106185 4891 9.0" 
$ns at 733.750049282341 "$node_(743) setdest 10009 9201 9.0" 
$ns at 826.434184699823 "$node_(743) setdest 104790 21770 5.0" 
$ns at 881.0999521663031 "$node_(743) setdest 39394 44660 11.0" 
$ns at 768.6625847005364 "$node_(744) setdest 133466 992 13.0" 
$ns at 830.6936436376449 "$node_(744) setdest 100278 34116 15.0" 
$ns at 738.8777530274668 "$node_(745) setdest 53123 5574 13.0" 
$ns at 811.5431370502084 "$node_(745) setdest 70153 31888 13.0" 
$ns at 897.7221675083958 "$node_(745) setdest 127217 913 8.0" 
$ns at 722.2271173498784 "$node_(746) setdest 1691 8860 5.0" 
$ns at 778.7832065261587 "$node_(746) setdest 78021 11333 1.0" 
$ns at 815.7021613256095 "$node_(746) setdest 18886 27000 19.0" 
$ns at 791.1822089656034 "$node_(747) setdest 126692 36880 15.0" 
$ns at 845.3888581057247 "$node_(747) setdest 114516 34425 5.0" 
$ns at 896.906822074206 "$node_(747) setdest 56352 33935 8.0" 
$ns at 728.7111992063568 "$node_(748) setdest 113566 43521 1.0" 
$ns at 759.4228993870846 "$node_(748) setdest 55198 2299 13.0" 
$ns at 872.8292637844845 "$node_(748) setdest 78562 9368 4.0" 
$ns at 884.557456325896 "$node_(749) setdest 126523 24905 4.0" 
$ns at 748.5090943340402 "$node_(750) setdest 80648 8207 5.0" 
$ns at 783.4603613002853 "$node_(750) setdest 101452 37536 6.0" 
$ns at 859.3663035779609 "$node_(750) setdest 103420 16111 14.0" 
$ns at 717.8123825703557 "$node_(751) setdest 86885 42208 16.0" 
$ns at 791.9677682653372 "$node_(751) setdest 69164 35844 20.0" 
$ns at 724.4532841884716 "$node_(752) setdest 54277 35273 16.0" 
$ns at 757.9726581910071 "$node_(752) setdest 16691 10918 9.0" 
$ns at 812.4948258889586 "$node_(752) setdest 97289 8991 16.0" 
$ns at 781.8183272199968 "$node_(753) setdest 15698 22665 17.0" 
$ns at 716.4446644135394 "$node_(754) setdest 112168 24458 4.0" 
$ns at 769.0267333049828 "$node_(754) setdest 19298 23154 4.0" 
$ns at 835.5217460486714 "$node_(754) setdest 56627 26629 14.0" 
$ns at 701.2198178470695 "$node_(755) setdest 123547 5461 1.0" 
$ns at 739.7413789776928 "$node_(755) setdest 56330 6958 12.0" 
$ns at 816.0505768459253 "$node_(755) setdest 117636 6369 3.0" 
$ns at 851.049960659921 "$node_(755) setdest 108142 37089 8.0" 
$ns at 712.2980882906925 "$node_(756) setdest 60457 12084 6.0" 
$ns at 742.5178578639567 "$node_(756) setdest 13442 35392 5.0" 
$ns at 814.5094328733985 "$node_(756) setdest 4829 11487 1.0" 
$ns at 851.7447582718145 "$node_(756) setdest 117854 23407 15.0" 
$ns at 811.7530968494243 "$node_(757) setdest 17405 9967 8.0" 
$ns at 875.9411341407505 "$node_(757) setdest 110798 41024 11.0" 
$ns at 756.5953662009271 "$node_(758) setdest 4572 2042 12.0" 
$ns at 885.7342812953418 "$node_(758) setdest 107640 22018 16.0" 
$ns at 797.7291160196977 "$node_(759) setdest 32012 13810 18.0" 
$ns at 783.7717836044162 "$node_(760) setdest 27521 23183 6.0" 
$ns at 836.5913869730376 "$node_(760) setdest 114403 36019 13.0" 
$ns at 780.2307369651026 "$node_(761) setdest 98622 3559 15.0" 
$ns at 869.8034496864631 "$node_(761) setdest 94156 24100 18.0" 
$ns at 761.5871123692178 "$node_(762) setdest 56006 35680 13.0" 
$ns at 881.4110701951759 "$node_(762) setdest 1611 30097 15.0" 
$ns at 706.9819890013752 "$node_(763) setdest 37567 42872 10.0" 
$ns at 830.5963018861847 "$node_(763) setdest 18785 5137 4.0" 
$ns at 878.2670569168642 "$node_(763) setdest 106039 10267 8.0" 
$ns at 724.1609975947872 "$node_(764) setdest 69765 36977 13.0" 
$ns at 824.0112702583604 "$node_(764) setdest 81953 39102 4.0" 
$ns at 865.6493234932315 "$node_(764) setdest 128187 20302 20.0" 
$ns at 748.3954769925319 "$node_(765) setdest 47791 44548 16.0" 
$ns at 886.24372164087 "$node_(765) setdest 121466 3426 3.0" 
$ns at 706.9906640868646 "$node_(766) setdest 4127 3579 1.0" 
$ns at 737.2986582683086 "$node_(766) setdest 53481 31788 16.0" 
$ns at 884.4885688091036 "$node_(766) setdest 61073 13670 10.0" 
$ns at 715.9807545826335 "$node_(767) setdest 102388 37728 6.0" 
$ns at 747.3252724408794 "$node_(767) setdest 100155 597 1.0" 
$ns at 787.1858902588226 "$node_(767) setdest 38227 36008 15.0" 
$ns at 837.5768823964634 "$node_(767) setdest 49238 22631 13.0" 
$ns at 741.469584130768 "$node_(768) setdest 83314 17227 7.0" 
$ns at 788.1700815115499 "$node_(768) setdest 114822 1016 8.0" 
$ns at 849.8511108923686 "$node_(768) setdest 56824 25896 19.0" 
$ns at 780.4330874833456 "$node_(769) setdest 34045 2414 9.0" 
$ns at 827.2957119450139 "$node_(769) setdest 58038 23772 4.0" 
$ns at 885.8925527892363 "$node_(769) setdest 110145 40377 18.0" 
$ns at 708.5956291958247 "$node_(770) setdest 69842 35851 9.0" 
$ns at 770.8446899172388 "$node_(770) setdest 71006 15497 9.0" 
$ns at 858.2034009091471 "$node_(770) setdest 131893 30858 1.0" 
$ns at 893.2065153396372 "$node_(770) setdest 47079 18187 2.0" 
$ns at 857.2344935901428 "$node_(771) setdest 51057 28207 17.0" 
$ns at 703.4129629332581 "$node_(772) setdest 5403 25779 6.0" 
$ns at 789.4351510068193 "$node_(772) setdest 95379 40507 2.0" 
$ns at 821.5202285968306 "$node_(772) setdest 106933 34000 4.0" 
$ns at 880.057012967908 "$node_(772) setdest 71816 8234 4.0" 
$ns at 700.9163872000671 "$node_(773) setdest 5703 16537 8.0" 
$ns at 744.1788813612327 "$node_(773) setdest 100476 28422 11.0" 
$ns at 810.4016074007309 "$node_(773) setdest 66512 8516 3.0" 
$ns at 869.129615288803 "$node_(773) setdest 71161 43033 1.0" 
$ns at 752.6326576282252 "$node_(774) setdest 12887 19258 7.0" 
$ns at 847.6263319991009 "$node_(774) setdest 120806 38062 17.0" 
$ns at 713.921333624691 "$node_(775) setdest 36846 13869 16.0" 
$ns at 830.405244140068 "$node_(775) setdest 75687 30028 20.0" 
$ns at 722.3095013429609 "$node_(776) setdest 129750 17923 11.0" 
$ns at 771.4432046544423 "$node_(776) setdest 56415 12665 10.0" 
$ns at 837.3360695309493 "$node_(776) setdest 33428 10942 4.0" 
$ns at 873.2825574246891 "$node_(776) setdest 44692 40600 11.0" 
$ns at 744.8935282093984 "$node_(777) setdest 81277 10109 4.0" 
$ns at 786.0595226989616 "$node_(777) setdest 45141 11278 15.0" 
$ns at 727.7446309092282 "$node_(778) setdest 66143 6820 12.0" 
$ns at 765.034068488427 "$node_(778) setdest 60150 22713 4.0" 
$ns at 823.3693826709609 "$node_(778) setdest 58818 28610 5.0" 
$ns at 867.0973974277248 "$node_(778) setdest 40196 39507 9.0" 
$ns at 736.1344671914269 "$node_(779) setdest 117200 24184 15.0" 
$ns at 836.371957444456 "$node_(779) setdest 113251 43060 1.0" 
$ns at 875.2632588697187 "$node_(779) setdest 36974 19916 15.0" 
$ns at 779.4807701073946 "$node_(780) setdest 91201 22170 9.0" 
$ns at 877.226608280141 "$node_(780) setdest 73365 24193 6.0" 
$ns at 732.4346619133808 "$node_(781) setdest 23881 15139 7.0" 
$ns at 768.8112244985367 "$node_(781) setdest 55573 33925 16.0" 
$ns at 701.0572910442024 "$node_(782) setdest 130488 28396 17.0" 
$ns at 813.364038670593 "$node_(782) setdest 27891 34916 8.0" 
$ns at 897.2088547193596 "$node_(782) setdest 26690 10124 2.0" 
$ns at 732.6675899681076 "$node_(783) setdest 35228 42249 17.0" 
$ns at 764.8484846217102 "$node_(783) setdest 65736 18947 18.0" 
$ns at 894.0104054828344 "$node_(783) setdest 60861 28829 4.0" 
$ns at 757.9092698759187 "$node_(784) setdest 126470 14021 10.0" 
$ns at 866.8686889352912 "$node_(784) setdest 10051 32594 1.0" 
$ns at 896.9925426518731 "$node_(784) setdest 88531 3282 3.0" 
$ns at 755.6870411767114 "$node_(785) setdest 122151 29987 2.0" 
$ns at 801.7590692247244 "$node_(785) setdest 72073 39852 16.0" 
$ns at 723.0455420200506 "$node_(786) setdest 116718 9353 20.0" 
$ns at 856.6379214583525 "$node_(786) setdest 106336 44633 7.0" 
$ns at 771.3768531720712 "$node_(787) setdest 2768 8312 19.0" 
$ns at 815.6233647105527 "$node_(787) setdest 26869 16899 15.0" 
$ns at 884.2857138194566 "$node_(787) setdest 39639 21355 18.0" 
$ns at 720.1911683115881 "$node_(788) setdest 55143 27657 17.0" 
$ns at 803.7741040664657 "$node_(789) setdest 9254 39298 8.0" 
$ns at 885.0809057494868 "$node_(789) setdest 39124 4927 4.0" 
$ns at 708.5513933377365 "$node_(790) setdest 114512 40594 9.0" 
$ns at 740.3138184373106 "$node_(790) setdest 101092 33470 18.0" 
$ns at 700.2526013607868 "$node_(791) setdest 1987 8956 3.0" 
$ns at 750.1038770804718 "$node_(791) setdest 75963 18074 14.0" 
$ns at 804.9908130194427 "$node_(791) setdest 8652 40558 1.0" 
$ns at 839.6564476684539 "$node_(791) setdest 32586 13171 9.0" 
$ns at 705.0356324278748 "$node_(792) setdest 34347 22745 11.0" 
$ns at 743.6520416078395 "$node_(792) setdest 5461 21254 3.0" 
$ns at 801.7438567675666 "$node_(792) setdest 6137 23280 13.0" 
$ns at 872.2298373385315 "$node_(793) setdest 22985 16428 18.0" 
$ns at 763.7533028411825 "$node_(794) setdest 80727 20151 15.0" 
$ns at 800.0060163452538 "$node_(794) setdest 32418 10476 2.0" 
$ns at 831.5906412956055 "$node_(794) setdest 64362 9819 7.0" 
$ns at 752.6587505214146 "$node_(795) setdest 43935 12637 1.0" 
$ns at 789.1483128253724 "$node_(795) setdest 15757 25182 9.0" 
$ns at 836.957623102284 "$node_(795) setdest 16590 17710 2.0" 
$ns at 884.4946705274214 "$node_(795) setdest 132149 1063 15.0" 
$ns at 736.7487666973731 "$node_(796) setdest 102903 19253 5.0" 
$ns at 774.0710013213167 "$node_(796) setdest 120166 38722 11.0" 
$ns at 701.4463538966467 "$node_(797) setdest 111579 15284 5.0" 
$ns at 766.9443331394102 "$node_(797) setdest 44905 39884 1.0" 
$ns at 799.6854743043249 "$node_(797) setdest 61878 22951 3.0" 
$ns at 858.5015901423254 "$node_(797) setdest 40781 37151 14.0" 
$ns at 705.5454525135794 "$node_(798) setdest 104618 31860 7.0" 
$ns at 793.438875505543 "$node_(798) setdest 132589 18116 8.0" 
$ns at 872.8124935564634 "$node_(798) setdest 97783 44594 4.0" 
$ns at 704.2668135488287 "$node_(799) setdest 43931 5773 14.0" 
$ns at 829.2343625714482 "$node_(799) setdest 15254 9386 2.0" 
$ns at 868.232243166239 "$node_(799) setdest 13580 18880 7.0" 


#Set a TCP connection between node_(17) and node_(56)
set tcp_(0) [new Agent/TCP/Newreno]
$tcp_(0) set class_ 2
set sink_(0) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(0)
$ns attach-agent $node_(56) $sink_(0)
$ns connect $tcp_(0) $sink_(0)
set ftp_(0) [new Application/FTP]
$ftp_(0) attach-agent $tcp_(0)
$ns at 0.2 "$ftp_(0) start"
$ns at 180.0 "$ftp_(0) stop"

#Set a TCP connection between node_(33) and node_(12)
set tcp_(1) [new Agent/TCP/Newreno]
$tcp_(1) set class_ 2
set sink_(1) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(1)
$ns attach-agent $node_(12) $sink_(1)
$ns connect $tcp_(1) $sink_(1)
set ftp_(1) [new Application/FTP]
$ftp_(1) attach-agent $tcp_(1)
$ns at 180.2 "$ftp_(1) start"
$ns at 360.0 "$ftp_(1) stop"

#Set a TCP connection between node_(73) and node_(26)
set tcp_(2) [new Agent/TCP/Newreno]
$tcp_(2) set class_ 2
set sink_(2) [new Agent/TCPSink]
$ns attach-agent $node_(73) $tcp_(2)
$ns attach-agent $node_(26) $sink_(2)
$ns connect $tcp_(2) $sink_(2)
set ftp_(2) [new Application/FTP]
$ftp_(2) attach-agent $tcp_(2)
$ns at 360.2 "$ftp_(2) start"
$ns at 540.0 "$ftp_(2) stop"

#Set a TCP connection between node_(26) and node_(63)
set tcp_(3) [new Agent/TCP/Newreno]
$tcp_(3) set class_ 2
set sink_(3) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(3)
$ns attach-agent $node_(63) $sink_(3)
$ns connect $tcp_(3) $sink_(3)
set ftp_(3) [new Application/FTP]
$ftp_(3) attach-agent $tcp_(3)
$ns at 540.2 "$ftp_(3) start"
$ns at 720.0 "$ftp_(3) stop"

#Set a TCP connection between node_(9) and node_(30)
set tcp_(4) [new Agent/TCP/Newreno]
$tcp_(4) set class_ 2
set sink_(4) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(4)
$ns attach-agent $node_(30) $sink_(4)
$ns connect $tcp_(4) $sink_(4)
set ftp_(4) [new Application/FTP]
$ftp_(4) attach-agent $tcp_(4)
$ns at 720.2 "$ftp_(4) start"
$ns at 900.0 "$ftp_(4) stop"

#Set a TCP connection between node_(98) and node_(39)
set tcp_(5) [new Agent/TCP/Newreno]
$tcp_(5) set class_ 2
set sink_(5) [new Agent/TCPSink]
$ns attach-agent $node_(98) $tcp_(5)
$ns attach-agent $node_(39) $sink_(5)
$ns connect $tcp_(5) $sink_(5)
set ftp_(5) [new Application/FTP]
$ftp_(5) attach-agent $tcp_(5)
$ns at 0.2 "$ftp_(5) start"
$ns at 180.0 "$ftp_(5) stop"

#Set a TCP connection between node_(9) and node_(19)
set tcp_(6) [new Agent/TCP/Newreno]
$tcp_(6) set class_ 2
set sink_(6) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(6)
$ns attach-agent $node_(19) $sink_(6)
$ns connect $tcp_(6) $sink_(6)
set ftp_(6) [new Application/FTP]
$ftp_(6) attach-agent $tcp_(6)
$ns at 180.2 "$ftp_(6) start"
$ns at 360.0 "$ftp_(6) stop"

#Set a TCP connection between node_(32) and node_(20)
set tcp_(7) [new Agent/TCP/Newreno]
$tcp_(7) set class_ 2
set sink_(7) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(7)
$ns attach-agent $node_(20) $sink_(7)
$ns connect $tcp_(7) $sink_(7)
set ftp_(7) [new Application/FTP]
$ftp_(7) attach-agent $tcp_(7)
$ns at 360.2 "$ftp_(7) start"
$ns at 540.0 "$ftp_(7) stop"

#Set a TCP connection between node_(10) and node_(68)
set tcp_(8) [new Agent/TCP/Newreno]
$tcp_(8) set class_ 2
set sink_(8) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(8)
$ns attach-agent $node_(68) $sink_(8)
$ns connect $tcp_(8) $sink_(8)
set ftp_(8) [new Application/FTP]
$ftp_(8) attach-agent $tcp_(8)
$ns at 540.2 "$ftp_(8) start"
$ns at 720.0 "$ftp_(8) stop"

#Set a TCP connection between node_(70) and node_(82)
set tcp_(9) [new Agent/TCP/Newreno]
$tcp_(9) set class_ 2
set sink_(9) [new Agent/TCPSink]
$ns attach-agent $node_(70) $tcp_(9)
$ns attach-agent $node_(82) $sink_(9)
$ns connect $tcp_(9) $sink_(9)
set ftp_(9) [new Application/FTP]
$ftp_(9) attach-agent $tcp_(9)
$ns at 720.2 "$ftp_(9) start"
$ns at 900.0 "$ftp_(9) stop"

#Set a TCP connection between node_(11) and node_(37)
set tcp_(10) [new Agent/TCP/Newreno]
$tcp_(10) set class_ 2
set sink_(10) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(10)
$ns attach-agent $node_(37) $sink_(10)
$ns connect $tcp_(10) $sink_(10)
set ftp_(10) [new Application/FTP]
$ftp_(10) attach-agent $tcp_(10)
$ns at 0.2 "$ftp_(10) start"
$ns at 180.0 "$ftp_(10) stop"

#Set a TCP connection between node_(91) and node_(56)
set tcp_(11) [new Agent/TCP/Newreno]
$tcp_(11) set class_ 2
set sink_(11) [new Agent/TCPSink]
$ns attach-agent $node_(91) $tcp_(11)
$ns attach-agent $node_(56) $sink_(11)
$ns connect $tcp_(11) $sink_(11)
set ftp_(11) [new Application/FTP]
$ftp_(11) attach-agent $tcp_(11)
$ns at 180.2 "$ftp_(11) start"
$ns at 360.0 "$ftp_(11) stop"

#Set a TCP connection between node_(31) and node_(73)
set tcp_(12) [new Agent/TCP/Newreno]
$tcp_(12) set class_ 2
set sink_(12) [new Agent/TCPSink]
$ns attach-agent $node_(31) $tcp_(12)
$ns attach-agent $node_(73) $sink_(12)
$ns connect $tcp_(12) $sink_(12)
set ftp_(12) [new Application/FTP]
$ftp_(12) attach-agent $tcp_(12)
$ns at 360.2 "$ftp_(12) start"
$ns at 540.0 "$ftp_(12) stop"

#Set a TCP connection between node_(68) and node_(87)
set tcp_(13) [new Agent/TCP/Newreno]
$tcp_(13) set class_ 2
set sink_(13) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(13)
$ns attach-agent $node_(87) $sink_(13)
$ns connect $tcp_(13) $sink_(13)
set ftp_(13) [new Application/FTP]
$ftp_(13) attach-agent $tcp_(13)
$ns at 540.2 "$ftp_(13) start"
$ns at 720.0 "$ftp_(13) stop"

#Set a TCP connection between node_(4) and node_(41)
set tcp_(14) [new Agent/TCP/Newreno]
$tcp_(14) set class_ 2
set sink_(14) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(14)
$ns attach-agent $node_(41) $sink_(14)
$ns connect $tcp_(14) $sink_(14)
set ftp_(14) [new Application/FTP]
$ftp_(14) attach-agent $tcp_(14)
$ns at 720.2 "$ftp_(14) start"
$ns at 900.0 "$ftp_(14) stop"

#Set a TCP connection between node_(72) and node_(66)
set tcp_(15) [new Agent/TCP/Newreno]
$tcp_(15) set class_ 2
set sink_(15) [new Agent/TCPSink]
$ns attach-agent $node_(72) $tcp_(15)
$ns attach-agent $node_(66) $sink_(15)
$ns connect $tcp_(15) $sink_(15)
set ftp_(15) [new Application/FTP]
$ftp_(15) attach-agent $tcp_(15)
$ns at 0.2 "$ftp_(15) start"
$ns at 180.0 "$ftp_(15) stop"

#Set a TCP connection between node_(55) and node_(38)
set tcp_(16) [new Agent/TCP/Newreno]
$tcp_(16) set class_ 2
set sink_(16) [new Agent/TCPSink]
$ns attach-agent $node_(55) $tcp_(16)
$ns attach-agent $node_(38) $sink_(16)
$ns connect $tcp_(16) $sink_(16)
set ftp_(16) [new Application/FTP]
$ftp_(16) attach-agent $tcp_(16)
$ns at 180.2 "$ftp_(16) start"
$ns at 360.0 "$ftp_(16) stop"

#Set a TCP connection between node_(25) and node_(85)
set tcp_(17) [new Agent/TCP/Newreno]
$tcp_(17) set class_ 2
set sink_(17) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(17)
$ns attach-agent $node_(85) $sink_(17)
$ns connect $tcp_(17) $sink_(17)
set ftp_(17) [new Application/FTP]
$ftp_(17) attach-agent $tcp_(17)
$ns at 360.2 "$ftp_(17) start"
$ns at 540.0 "$ftp_(17) stop"

#Set a TCP connection between node_(17) and node_(98)
set tcp_(18) [new Agent/TCP/Newreno]
$tcp_(18) set class_ 2
set sink_(18) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(18)
$ns attach-agent $node_(98) $sink_(18)
$ns connect $tcp_(18) $sink_(18)
set ftp_(18) [new Application/FTP]
$ftp_(18) attach-agent $tcp_(18)
$ns at 540.2 "$ftp_(18) start"
$ns at 720.0 "$ftp_(18) stop"

#Set a TCP connection between node_(75) and node_(29)
set tcp_(19) [new Agent/TCP/Newreno]
$tcp_(19) set class_ 2
set sink_(19) [new Agent/TCPSink]
$ns attach-agent $node_(75) $tcp_(19)
$ns attach-agent $node_(29) $sink_(19)
$ns connect $tcp_(19) $sink_(19)
set ftp_(19) [new Application/FTP]
$ftp_(19) attach-agent $tcp_(19)
$ns at 720.2 "$ftp_(19) start"
$ns at 900.0 "$ftp_(19) stop"

#Set a TCP connection between node_(1) and node_(43)
set tcp_(20) [new Agent/TCP/Newreno]
$tcp_(20) set class_ 2
set sink_(20) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(20)
$ns attach-agent $node_(43) $sink_(20)
$ns connect $tcp_(20) $sink_(20)
set ftp_(20) [new Application/FTP]
$ftp_(20) attach-agent $tcp_(20)
$ns at 0.2 "$ftp_(20) start"
$ns at 180.0 "$ftp_(20) stop"

#Set a TCP connection between node_(99) and node_(69)
set tcp_(21) [new Agent/TCP/Newreno]
$tcp_(21) set class_ 2
set sink_(21) [new Agent/TCPSink]
$ns attach-agent $node_(99) $tcp_(21)
$ns attach-agent $node_(69) $sink_(21)
$ns connect $tcp_(21) $sink_(21)
set ftp_(21) [new Application/FTP]
$ftp_(21) attach-agent $tcp_(21)
$ns at 180.2 "$ftp_(21) start"
$ns at 360.0 "$ftp_(21) stop"

#Set a TCP connection between node_(89) and node_(59)
set tcp_(22) [new Agent/TCP/Newreno]
$tcp_(22) set class_ 2
set sink_(22) [new Agent/TCPSink]
$ns attach-agent $node_(89) $tcp_(22)
$ns attach-agent $node_(59) $sink_(22)
$ns connect $tcp_(22) $sink_(22)
set ftp_(22) [new Application/FTP]
$ftp_(22) attach-agent $tcp_(22)
$ns at 360.2 "$ftp_(22) start"
$ns at 540.0 "$ftp_(22) stop"

#Set a TCP connection between node_(96) and node_(64)
set tcp_(23) [new Agent/TCP/Newreno]
$tcp_(23) set class_ 2
set sink_(23) [new Agent/TCPSink]
$ns attach-agent $node_(96) $tcp_(23)
$ns attach-agent $node_(64) $sink_(23)
$ns connect $tcp_(23) $sink_(23)
set ftp_(23) [new Application/FTP]
$ftp_(23) attach-agent $tcp_(23)
$ns at 540.2 "$ftp_(23) start"
$ns at 720.0 "$ftp_(23) stop"

#Set a TCP connection between node_(41) and node_(22)
set tcp_(24) [new Agent/TCP/Newreno]
$tcp_(24) set class_ 2
set sink_(24) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(24)
$ns attach-agent $node_(22) $sink_(24)
$ns connect $tcp_(24) $sink_(24)
set ftp_(24) [new Application/FTP]
$ftp_(24) attach-agent $tcp_(24)
$ns at 720.2 "$ftp_(24) start"
$ns at 900.0 "$ftp_(24) stop"

#Set a TCP connection between node_(15) and node_(16)
set tcp_(25) [new Agent/TCP/Newreno]
$tcp_(25) set class_ 2
set sink_(25) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(25)
$ns attach-agent $node_(16) $sink_(25)
$ns connect $tcp_(25) $sink_(25)
set ftp_(25) [new Application/FTP]
$ftp_(25) attach-agent $tcp_(25)
$ns at 0.2 "$ftp_(25) start"
$ns at 180.0 "$ftp_(25) stop"

#Set a TCP connection between node_(10) and node_(90)
set tcp_(26) [new Agent/TCP/Newreno]
$tcp_(26) set class_ 2
set sink_(26) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(26)
$ns attach-agent $node_(90) $sink_(26)
$ns connect $tcp_(26) $sink_(26)
set ftp_(26) [new Application/FTP]
$ftp_(26) attach-agent $tcp_(26)
$ns at 180.2 "$ftp_(26) start"
$ns at 360.0 "$ftp_(26) stop"

#Set a TCP connection between node_(61) and node_(24)
set tcp_(27) [new Agent/TCP/Newreno]
$tcp_(27) set class_ 2
set sink_(27) [new Agent/TCPSink]
$ns attach-agent $node_(61) $tcp_(27)
$ns attach-agent $node_(24) $sink_(27)
$ns connect $tcp_(27) $sink_(27)
set ftp_(27) [new Application/FTP]
$ftp_(27) attach-agent $tcp_(27)
$ns at 360.2 "$ftp_(27) start"
$ns at 540.0 "$ftp_(27) stop"

#Set a TCP connection between node_(13) and node_(8)
set tcp_(28) [new Agent/TCP/Newreno]
$tcp_(28) set class_ 2
set sink_(28) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(28)
$ns attach-agent $node_(8) $sink_(28)
$ns connect $tcp_(28) $sink_(28)
set ftp_(28) [new Application/FTP]
$ftp_(28) attach-agent $tcp_(28)
$ns at 540.2 "$ftp_(28) start"
$ns at 720.0 "$ftp_(28) stop"

#Set a TCP connection between node_(7) and node_(52)
set tcp_(29) [new Agent/TCP/Newreno]
$tcp_(29) set class_ 2
set sink_(29) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(29)
$ns attach-agent $node_(52) $sink_(29)
$ns connect $tcp_(29) $sink_(29)
set ftp_(29) [new Application/FTP]
$ftp_(29) attach-agent $tcp_(29)
$ns at 720.2 "$ftp_(29) start"
$ns at 900.0 "$ftp_(29) stop"

#Set a TCP connection between node_(85) and node_(45)
set tcp_(30) [new Agent/TCP/Newreno]
$tcp_(30) set class_ 2
set sink_(30) [new Agent/TCPSink]
$ns attach-agent $node_(85) $tcp_(30)
$ns attach-agent $node_(45) $sink_(30)
$ns connect $tcp_(30) $sink_(30)
set ftp_(30) [new Application/FTP]
$ftp_(30) attach-agent $tcp_(30)
$ns at 0.2 "$ftp_(30) start"
$ns at 180.0 "$ftp_(30) stop"

#Set a TCP connection between node_(90) and node_(56)
set tcp_(31) [new Agent/TCP/Newreno]
$tcp_(31) set class_ 2
set sink_(31) [new Agent/TCPSink]
$ns attach-agent $node_(90) $tcp_(31)
$ns attach-agent $node_(56) $sink_(31)
$ns connect $tcp_(31) $sink_(31)
set ftp_(31) [new Application/FTP]
$ftp_(31) attach-agent $tcp_(31)
$ns at 180.2 "$ftp_(31) start"
$ns at 360.0 "$ftp_(31) stop"

#Set a TCP connection between node_(2) and node_(1)
set tcp_(32) [new Agent/TCP/Newreno]
$tcp_(32) set class_ 2
set sink_(32) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(32)
$ns attach-agent $node_(1) $sink_(32)
$ns connect $tcp_(32) $sink_(32)
set ftp_(32) [new Application/FTP]
$ftp_(32) attach-agent $tcp_(32)
$ns at 360.2 "$ftp_(32) start"
$ns at 540.0 "$ftp_(32) stop"

#Set a TCP connection between node_(94) and node_(76)
set tcp_(33) [new Agent/TCP/Newreno]
$tcp_(33) set class_ 2
set sink_(33) [new Agent/TCPSink]
$ns attach-agent $node_(94) $tcp_(33)
$ns attach-agent $node_(76) $sink_(33)
$ns connect $tcp_(33) $sink_(33)
set ftp_(33) [new Application/FTP]
$ftp_(33) attach-agent $tcp_(33)
$ns at 540.2 "$ftp_(33) start"
$ns at 720.0 "$ftp_(33) stop"

#Set a TCP connection between node_(29) and node_(64)
set tcp_(34) [new Agent/TCP/Newreno]
$tcp_(34) set class_ 2
set sink_(34) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(34)
$ns attach-agent $node_(64) $sink_(34)
$ns connect $tcp_(34) $sink_(34)
set ftp_(34) [new Application/FTP]
$ftp_(34) attach-agent $tcp_(34)
$ns at 720.2 "$ftp_(34) start"
$ns at 900.0 "$ftp_(34) stop"

#Set a TCP connection between node_(68) and node_(47)
set tcp_(35) [new Agent/TCP/Newreno]
$tcp_(35) set class_ 2
set sink_(35) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(35)
$ns attach-agent $node_(47) $sink_(35)
$ns connect $tcp_(35) $sink_(35)
set ftp_(35) [new Application/FTP]
$ftp_(35) attach-agent $tcp_(35)
$ns at 0.2 "$ftp_(35) start"
$ns at 180.0 "$ftp_(35) stop"

#Set a TCP connection between node_(21) and node_(6)
set tcp_(36) [new Agent/TCP/Newreno]
$tcp_(36) set class_ 2
set sink_(36) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(36)
$ns attach-agent $node_(6) $sink_(36)
$ns connect $tcp_(36) $sink_(36)
set ftp_(36) [new Application/FTP]
$ftp_(36) attach-agent $tcp_(36)
$ns at 180.2 "$ftp_(36) start"
$ns at 360.0 "$ftp_(36) stop"

#Set a TCP connection between node_(24) and node_(80)
set tcp_(37) [new Agent/TCP/Newreno]
$tcp_(37) set class_ 2
set sink_(37) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(37)
$ns attach-agent $node_(80) $sink_(37)
$ns connect $tcp_(37) $sink_(37)
set ftp_(37) [new Application/FTP]
$ftp_(37) attach-agent $tcp_(37)
$ns at 360.2 "$ftp_(37) start"
$ns at 540.0 "$ftp_(37) stop"

#Set a TCP connection between node_(82) and node_(28)
set tcp_(38) [new Agent/TCP/Newreno]
$tcp_(38) set class_ 2
set sink_(38) [new Agent/TCPSink]
$ns attach-agent $node_(82) $tcp_(38)
$ns attach-agent $node_(28) $sink_(38)
$ns connect $tcp_(38) $sink_(38)
set ftp_(38) [new Application/FTP]
$ftp_(38) attach-agent $tcp_(38)
$ns at 540.2 "$ftp_(38) start"
$ns at 720.0 "$ftp_(38) stop"

#Set a TCP connection between node_(18) and node_(3)
set tcp_(39) [new Agent/TCP/Newreno]
$tcp_(39) set class_ 2
set sink_(39) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(39)
$ns attach-agent $node_(3) $sink_(39)
$ns connect $tcp_(39) $sink_(39)
set ftp_(39) [new Application/FTP]
$ftp_(39) attach-agent $tcp_(39)
$ns at 720.2 "$ftp_(39) start"
$ns at 900.0 "$ftp_(39) stop"

#Set a TCP connection between node_(45) and node_(34)
set tcp_(40) [new Agent/TCP/Newreno]
$tcp_(40) set class_ 2
set sink_(40) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(40)
$ns attach-agent $node_(34) $sink_(40)
$ns connect $tcp_(40) $sink_(40)
set ftp_(40) [new Application/FTP]
$ftp_(40) attach-agent $tcp_(40)
$ns at 0.2 "$ftp_(40) start"
$ns at 180.0 "$ftp_(40) stop"

#Set a TCP connection between node_(41) and node_(21)
set tcp_(41) [new Agent/TCP/Newreno]
$tcp_(41) set class_ 2
set sink_(41) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(41)
$ns attach-agent $node_(21) $sink_(41)
$ns connect $tcp_(41) $sink_(41)
set ftp_(41) [new Application/FTP]
$ftp_(41) attach-agent $tcp_(41)
$ns at 180.2 "$ftp_(41) start"
$ns at 360.0 "$ftp_(41) stop"

#Set a TCP connection between node_(24) and node_(8)
set tcp_(42) [new Agent/TCP/Newreno]
$tcp_(42) set class_ 2
set sink_(42) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(42)
$ns attach-agent $node_(8) $sink_(42)
$ns connect $tcp_(42) $sink_(42)
set ftp_(42) [new Application/FTP]
$ftp_(42) attach-agent $tcp_(42)
$ns at 360.2 "$ftp_(42) start"
$ns at 540.0 "$ftp_(42) stop"

#Set a TCP connection between node_(33) and node_(80)
set tcp_(43) [new Agent/TCP/Newreno]
$tcp_(43) set class_ 2
set sink_(43) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(43)
$ns attach-agent $node_(80) $sink_(43)
$ns connect $tcp_(43) $sink_(43)
set ftp_(43) [new Application/FTP]
$ftp_(43) attach-agent $tcp_(43)
$ns at 540.2 "$ftp_(43) start"
$ns at 720.0 "$ftp_(43) stop"

#Set a TCP connection between node_(35) and node_(44)
set tcp_(44) [new Agent/TCP/Newreno]
$tcp_(44) set class_ 2
set sink_(44) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(44)
$ns attach-agent $node_(44) $sink_(44)
$ns connect $tcp_(44) $sink_(44)
set ftp_(44) [new Application/FTP]
$ftp_(44) attach-agent $tcp_(44)
$ns at 720.2 "$ftp_(44) start"
$ns at 900.0 "$ftp_(44) stop"

#Set a TCP connection between node_(76) and node_(25)
set tcp_(45) [new Agent/TCP/Newreno]
$tcp_(45) set class_ 2
set sink_(45) [new Agent/TCPSink]
$ns attach-agent $node_(76) $tcp_(45)
$ns attach-agent $node_(25) $sink_(45)
$ns connect $tcp_(45) $sink_(45)
set ftp_(45) [new Application/FTP]
$ftp_(45) attach-agent $tcp_(45)
$ns at 0.2 "$ftp_(45) start"
$ns at 180.0 "$ftp_(45) stop"

#Set a TCP connection between node_(80) and node_(53)
set tcp_(46) [new Agent/TCP/Newreno]
$tcp_(46) set class_ 2
set sink_(46) [new Agent/TCPSink]
$ns attach-agent $node_(80) $tcp_(46)
$ns attach-agent $node_(53) $sink_(46)
$ns connect $tcp_(46) $sink_(46)
set ftp_(46) [new Application/FTP]
$ftp_(46) attach-agent $tcp_(46)
$ns at 180.2 "$ftp_(46) start"
$ns at 360.0 "$ftp_(46) stop"

#Set a TCP connection between node_(53) and node_(17)
set tcp_(47) [new Agent/TCP/Newreno]
$tcp_(47) set class_ 2
set sink_(47) [new Agent/TCPSink]
$ns attach-agent $node_(53) $tcp_(47)
$ns attach-agent $node_(17) $sink_(47)
$ns connect $tcp_(47) $sink_(47)
set ftp_(47) [new Application/FTP]
$ftp_(47) attach-agent $tcp_(47)
$ns at 360.2 "$ftp_(47) start"
$ns at 540.0 "$ftp_(47) stop"

#Set a TCP connection between node_(91) and node_(77)
set tcp_(48) [new Agent/TCP/Newreno]
$tcp_(48) set class_ 2
set sink_(48) [new Agent/TCPSink]
$ns attach-agent $node_(91) $tcp_(48)
$ns attach-agent $node_(77) $sink_(48)
$ns connect $tcp_(48) $sink_(48)
set ftp_(48) [new Application/FTP]
$ftp_(48) attach-agent $tcp_(48)
$ns at 540.2 "$ftp_(48) start"
$ns at 720.0 "$ftp_(48) stop"

#Set a TCP connection between node_(71) and node_(78)
set tcp_(49) [new Agent/TCP/Newreno]
$tcp_(49) set class_ 2
set sink_(49) [new Agent/TCPSink]
$ns attach-agent $node_(71) $tcp_(49)
$ns attach-agent $node_(78) $sink_(49)
$ns connect $tcp_(49) $sink_(49)
set ftp_(49) [new Application/FTP]
$ftp_(49) attach-agent $tcp_(49)
$ns at 720.2 "$ftp_(49) start"
$ns at 900.0 "$ftp_(49) stop"

#Set a TCP connection between node_(88) and node_(68)
set tcp_(50) [new Agent/TCP/Newreno]
$tcp_(50) set class_ 2
set sink_(50) [new Agent/TCPSink]
$ns attach-agent $node_(88) $tcp_(50)
$ns attach-agent $node_(68) $sink_(50)
$ns connect $tcp_(50) $sink_(50)
set ftp_(50) [new Application/FTP]
$ftp_(50) attach-agent $tcp_(50)
$ns at 0.2 "$ftp_(50) start"
$ns at 180.0 "$ftp_(50) stop"

#Set a TCP connection between node_(27) and node_(20)
set tcp_(51) [new Agent/TCP/Newreno]
$tcp_(51) set class_ 2
set sink_(51) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(51)
$ns attach-agent $node_(20) $sink_(51)
$ns connect $tcp_(51) $sink_(51)
set ftp_(51) [new Application/FTP]
$ftp_(51) attach-agent $tcp_(51)
$ns at 180.2 "$ftp_(51) start"
$ns at 360.0 "$ftp_(51) stop"

#Set a TCP connection between node_(88) and node_(55)
set tcp_(52) [new Agent/TCP/Newreno]
$tcp_(52) set class_ 2
set sink_(52) [new Agent/TCPSink]
$ns attach-agent $node_(88) $tcp_(52)
$ns attach-agent $node_(55) $sink_(52)
$ns connect $tcp_(52) $sink_(52)
set ftp_(52) [new Application/FTP]
$ftp_(52) attach-agent $tcp_(52)
$ns at 360.2 "$ftp_(52) start"
$ns at 540.0 "$ftp_(52) stop"

#Set a TCP connection between node_(35) and node_(72)
set tcp_(53) [new Agent/TCP/Newreno]
$tcp_(53) set class_ 2
set sink_(53) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(53)
$ns attach-agent $node_(72) $sink_(53)
$ns connect $tcp_(53) $sink_(53)
set ftp_(53) [new Application/FTP]
$ftp_(53) attach-agent $tcp_(53)
$ns at 540.2 "$ftp_(53) start"
$ns at 720.0 "$ftp_(53) stop"

#Set a TCP connection between node_(19) and node_(89)
set tcp_(54) [new Agent/TCP/Newreno]
$tcp_(54) set class_ 2
set sink_(54) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(54)
$ns attach-agent $node_(89) $sink_(54)
$ns connect $tcp_(54) $sink_(54)
set ftp_(54) [new Application/FTP]
$ftp_(54) attach-agent $tcp_(54)
$ns at 720.2 "$ftp_(54) start"
$ns at 900.0 "$ftp_(54) stop"

#Set a TCP connection between node_(25) and node_(45)
set tcp_(55) [new Agent/TCP/Newreno]
$tcp_(55) set class_ 2
set sink_(55) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(55)
$ns attach-agent $node_(45) $sink_(55)
$ns connect $tcp_(55) $sink_(55)
set ftp_(55) [new Application/FTP]
$ftp_(55) attach-agent $tcp_(55)
$ns at 0.2 "$ftp_(55) start"
$ns at 180.0 "$ftp_(55) stop"

#Set a TCP connection between node_(97) and node_(26)
set tcp_(56) [new Agent/TCP/Newreno]
$tcp_(56) set class_ 2
set sink_(56) [new Agent/TCPSink]
$ns attach-agent $node_(97) $tcp_(56)
$ns attach-agent $node_(26) $sink_(56)
$ns connect $tcp_(56) $sink_(56)
set ftp_(56) [new Application/FTP]
$ftp_(56) attach-agent $tcp_(56)
$ns at 180.2 "$ftp_(56) start"
$ns at 360.0 "$ftp_(56) stop"

#Set a TCP connection between node_(36) and node_(85)
set tcp_(57) [new Agent/TCP/Newreno]
$tcp_(57) set class_ 2
set sink_(57) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(57)
$ns attach-agent $node_(85) $sink_(57)
$ns connect $tcp_(57) $sink_(57)
set ftp_(57) [new Application/FTP]
$ftp_(57) attach-agent $tcp_(57)
$ns at 360.2 "$ftp_(57) start"
$ns at 540.0 "$ftp_(57) stop"

#Set a TCP connection between node_(88) and node_(92)
set tcp_(58) [new Agent/TCP/Newreno]
$tcp_(58) set class_ 2
set sink_(58) [new Agent/TCPSink]
$ns attach-agent $node_(88) $tcp_(58)
$ns attach-agent $node_(92) $sink_(58)
$ns connect $tcp_(58) $sink_(58)
set ftp_(58) [new Application/FTP]
$ftp_(58) attach-agent $tcp_(58)
$ns at 540.2 "$ftp_(58) start"
$ns at 720.0 "$ftp_(58) stop"

#Set a TCP connection between node_(32) and node_(74)
set tcp_(59) [new Agent/TCP/Newreno]
$tcp_(59) set class_ 2
set sink_(59) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(59)
$ns attach-agent $node_(74) $sink_(59)
$ns connect $tcp_(59) $sink_(59)
set ftp_(59) [new Application/FTP]
$ftp_(59) attach-agent $tcp_(59)
$ns at 720.2 "$ftp_(59) start"
$ns at 900.0 "$ftp_(59) stop"

#Set a TCP connection between node_(84) and node_(27)
set tcp_(60) [new Agent/TCP/Newreno]
$tcp_(60) set class_ 2
set sink_(60) [new Agent/TCPSink]
$ns attach-agent $node_(84) $tcp_(60)
$ns attach-agent $node_(27) $sink_(60)
$ns connect $tcp_(60) $sink_(60)
set ftp_(60) [new Application/FTP]
$ftp_(60) attach-agent $tcp_(60)
$ns at 0.2 "$ftp_(60) start"
$ns at 180.0 "$ftp_(60) stop"

#Set a TCP connection between node_(30) and node_(90)
set tcp_(61) [new Agent/TCP/Newreno]
$tcp_(61) set class_ 2
set sink_(61) [new Agent/TCPSink]
$ns attach-agent $node_(30) $tcp_(61)
$ns attach-agent $node_(90) $sink_(61)
$ns connect $tcp_(61) $sink_(61)
set ftp_(61) [new Application/FTP]
$ftp_(61) attach-agent $tcp_(61)
$ns at 180.2 "$ftp_(61) start"
$ns at 360.0 "$ftp_(61) stop"

#Set a TCP connection between node_(57) and node_(45)
set tcp_(62) [new Agent/TCP/Newreno]
$tcp_(62) set class_ 2
set sink_(62) [new Agent/TCPSink]
$ns attach-agent $node_(57) $tcp_(62)
$ns attach-agent $node_(45) $sink_(62)
$ns connect $tcp_(62) $sink_(62)
set ftp_(62) [new Application/FTP]
$ftp_(62) attach-agent $tcp_(62)
$ns at 360.2 "$ftp_(62) start"
$ns at 540.0 "$ftp_(62) stop"

#Set a TCP connection between node_(79) and node_(28)
set tcp_(63) [new Agent/TCP/Newreno]
$tcp_(63) set class_ 2
set sink_(63) [new Agent/TCPSink]
$ns attach-agent $node_(79) $tcp_(63)
$ns attach-agent $node_(28) $sink_(63)
$ns connect $tcp_(63) $sink_(63)
set ftp_(63) [new Application/FTP]
$ftp_(63) attach-agent $tcp_(63)
$ns at 540.2 "$ftp_(63) start"
$ns at 720.0 "$ftp_(63) stop"

#Set a TCP connection between node_(15) and node_(84)
set tcp_(64) [new Agent/TCP/Newreno]
$tcp_(64) set class_ 2
set sink_(64) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(64)
$ns attach-agent $node_(84) $sink_(64)
$ns connect $tcp_(64) $sink_(64)
set ftp_(64) [new Application/FTP]
$ftp_(64) attach-agent $tcp_(64)
$ns at 720.2 "$ftp_(64) start"
$ns at 900.0 "$ftp_(64) stop"

#Set a TCP connection between node_(78) and node_(13)
set tcp_(65) [new Agent/TCP/Newreno]
$tcp_(65) set class_ 2
set sink_(65) [new Agent/TCPSink]
$ns attach-agent $node_(78) $tcp_(65)
$ns attach-agent $node_(13) $sink_(65)
$ns connect $tcp_(65) $sink_(65)
set ftp_(65) [new Application/FTP]
$ftp_(65) attach-agent $tcp_(65)
$ns at 0.2 "$ftp_(65) start"
$ns at 180.0 "$ftp_(65) stop"

#Set a TCP connection between node_(42) and node_(89)
set tcp_(66) [new Agent/TCP/Newreno]
$tcp_(66) set class_ 2
set sink_(66) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(66)
$ns attach-agent $node_(89) $sink_(66)
$ns connect $tcp_(66) $sink_(66)
set ftp_(66) [new Application/FTP]
$ftp_(66) attach-agent $tcp_(66)
$ns at 180.2 "$ftp_(66) start"
$ns at 360.0 "$ftp_(66) stop"

#Set a TCP connection between node_(66) and node_(37)
set tcp_(67) [new Agent/TCP/Newreno]
$tcp_(67) set class_ 2
set sink_(67) [new Agent/TCPSink]
$ns attach-agent $node_(66) $tcp_(67)
$ns attach-agent $node_(37) $sink_(67)
$ns connect $tcp_(67) $sink_(67)
set ftp_(67) [new Application/FTP]
$ftp_(67) attach-agent $tcp_(67)
$ns at 360.2 "$ftp_(67) start"
$ns at 540.0 "$ftp_(67) stop"

#Set a TCP connection between node_(42) and node_(94)
set tcp_(68) [new Agent/TCP/Newreno]
$tcp_(68) set class_ 2
set sink_(68) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(68)
$ns attach-agent $node_(94) $sink_(68)
$ns connect $tcp_(68) $sink_(68)
set ftp_(68) [new Application/FTP]
$ftp_(68) attach-agent $tcp_(68)
$ns at 540.2 "$ftp_(68) start"
$ns at 720.0 "$ftp_(68) stop"

#Set a TCP connection between node_(11) and node_(19)
set tcp_(69) [new Agent/TCP/Newreno]
$tcp_(69) set class_ 2
set sink_(69) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(69)
$ns attach-agent $node_(19) $sink_(69)
$ns connect $tcp_(69) $sink_(69)
set ftp_(69) [new Application/FTP]
$ftp_(69) attach-agent $tcp_(69)
$ns at 720.2 "$ftp_(69) start"
$ns at 900.0 "$ftp_(69) stop"

#Set a TCP connection between node_(76) and node_(38)
set tcp_(70) [new Agent/TCP/Newreno]
$tcp_(70) set class_ 2
set sink_(70) [new Agent/TCPSink]
$ns attach-agent $node_(76) $tcp_(70)
$ns attach-agent $node_(38) $sink_(70)
$ns connect $tcp_(70) $sink_(70)
set ftp_(70) [new Application/FTP]
$ftp_(70) attach-agent $tcp_(70)
$ns at 0.2 "$ftp_(70) start"
$ns at 180.0 "$ftp_(70) stop"

#Set a TCP connection between node_(4) and node_(1)
set tcp_(71) [new Agent/TCP/Newreno]
$tcp_(71) set class_ 2
set sink_(71) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(71)
$ns attach-agent $node_(1) $sink_(71)
$ns connect $tcp_(71) $sink_(71)
set ftp_(71) [new Application/FTP]
$ftp_(71) attach-agent $tcp_(71)
$ns at 180.2 "$ftp_(71) start"
$ns at 360.0 "$ftp_(71) stop"

#Set a TCP connection between node_(29) and node_(47)
set tcp_(72) [new Agent/TCP/Newreno]
$tcp_(72) set class_ 2
set sink_(72) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(72)
$ns attach-agent $node_(47) $sink_(72)
$ns connect $tcp_(72) $sink_(72)
set ftp_(72) [new Application/FTP]
$ftp_(72) attach-agent $tcp_(72)
$ns at 360.2 "$ftp_(72) start"
$ns at 540.0 "$ftp_(72) stop"

#Set a TCP connection between node_(95) and node_(28)
set tcp_(73) [new Agent/TCP/Newreno]
$tcp_(73) set class_ 2
set sink_(73) [new Agent/TCPSink]
$ns attach-agent $node_(95) $tcp_(73)
$ns attach-agent $node_(28) $sink_(73)
$ns connect $tcp_(73) $sink_(73)
set ftp_(73) [new Application/FTP]
$ftp_(73) attach-agent $tcp_(73)
$ns at 540.2 "$ftp_(73) start"
$ns at 720.0 "$ftp_(73) stop"

#Set a TCP connection between node_(72) and node_(29)
set tcp_(74) [new Agent/TCP/Newreno]
$tcp_(74) set class_ 2
set sink_(74) [new Agent/TCPSink]
$ns attach-agent $node_(72) $tcp_(74)
$ns attach-agent $node_(29) $sink_(74)
$ns connect $tcp_(74) $sink_(74)
set ftp_(74) [new Application/FTP]
$ftp_(74) attach-agent $tcp_(74)
$ns at 720.2 "$ftp_(74) start"
$ns at 900.0 "$ftp_(74) stop"

#Set a TCP connection between node_(88) and node_(81)
set tcp_(75) [new Agent/TCP/Newreno]
$tcp_(75) set class_ 2
set sink_(75) [new Agent/TCPSink]
$ns attach-agent $node_(88) $tcp_(75)
$ns attach-agent $node_(81) $sink_(75)
$ns connect $tcp_(75) $sink_(75)
set ftp_(75) [new Application/FTP]
$ftp_(75) attach-agent $tcp_(75)
$ns at 0.2 "$ftp_(75) start"
$ns at 180.0 "$ftp_(75) stop"

#Set a TCP connection between node_(56) and node_(90)
set tcp_(76) [new Agent/TCP/Newreno]
$tcp_(76) set class_ 2
set sink_(76) [new Agent/TCPSink]
$ns attach-agent $node_(56) $tcp_(76)
$ns attach-agent $node_(90) $sink_(76)
$ns connect $tcp_(76) $sink_(76)
set ftp_(76) [new Application/FTP]
$ftp_(76) attach-agent $tcp_(76)
$ns at 180.2 "$ftp_(76) start"
$ns at 360.0 "$ftp_(76) stop"

#Set a TCP connection between node_(16) and node_(74)
set tcp_(77) [new Agent/TCP/Newreno]
$tcp_(77) set class_ 2
set sink_(77) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(77)
$ns attach-agent $node_(74) $sink_(77)
$ns connect $tcp_(77) $sink_(77)
set ftp_(77) [new Application/FTP]
$ftp_(77) attach-agent $tcp_(77)
$ns at 360.2 "$ftp_(77) start"
$ns at 540.0 "$ftp_(77) stop"

#Set a TCP connection between node_(42) and node_(72)
set tcp_(78) [new Agent/TCP/Newreno]
$tcp_(78) set class_ 2
set sink_(78) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(78)
$ns attach-agent $node_(72) $sink_(78)
$ns connect $tcp_(78) $sink_(78)
set ftp_(78) [new Application/FTP]
$ftp_(78) attach-agent $tcp_(78)
$ns at 540.2 "$ftp_(78) start"
$ns at 720.0 "$ftp_(78) stop"

#Set a TCP connection between node_(79) and node_(40)
set tcp_(79) [new Agent/TCP/Newreno]
$tcp_(79) set class_ 2
set sink_(79) [new Agent/TCPSink]
$ns attach-agent $node_(79) $tcp_(79)
$ns attach-agent $node_(40) $sink_(79)
$ns connect $tcp_(79) $sink_(79)
set ftp_(79) [new Application/FTP]
$ftp_(79) attach-agent $tcp_(79)
$ns at 720.2 "$ftp_(79) start"
$ns at 900.0 "$ftp_(79) stop"

#Set a TCP connection between node_(23) and node_(41)
set tcp_(80) [new Agent/TCP/Newreno]
$tcp_(80) set class_ 2
set sink_(80) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(80)
$ns attach-agent $node_(41) $sink_(80)
$ns connect $tcp_(80) $sink_(80)
set ftp_(80) [new Application/FTP]
$ftp_(80) attach-agent $tcp_(80)
$ns at 0.2 "$ftp_(80) start"
$ns at 180.0 "$ftp_(80) stop"

#Set a TCP connection between node_(57) and node_(53)
set tcp_(81) [new Agent/TCP/Newreno]
$tcp_(81) set class_ 2
set sink_(81) [new Agent/TCPSink]
$ns attach-agent $node_(57) $tcp_(81)
$ns attach-agent $node_(53) $sink_(81)
$ns connect $tcp_(81) $sink_(81)
set ftp_(81) [new Application/FTP]
$ftp_(81) attach-agent $tcp_(81)
$ns at 180.2 "$ftp_(81) start"
$ns at 360.0 "$ftp_(81) stop"

#Set a TCP connection between node_(97) and node_(80)
set tcp_(82) [new Agent/TCP/Newreno]
$tcp_(82) set class_ 2
set sink_(82) [new Agent/TCPSink]
$ns attach-agent $node_(97) $tcp_(82)
$ns attach-agent $node_(80) $sink_(82)
$ns connect $tcp_(82) $sink_(82)
set ftp_(82) [new Application/FTP]
$ftp_(82) attach-agent $tcp_(82)
$ns at 360.2 "$ftp_(82) start"
$ns at 540.0 "$ftp_(82) stop"

#Set a TCP connection between node_(41) and node_(95)
set tcp_(83) [new Agent/TCP/Newreno]
$tcp_(83) set class_ 2
set sink_(83) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(83)
$ns attach-agent $node_(95) $sink_(83)
$ns connect $tcp_(83) $sink_(83)
set ftp_(83) [new Application/FTP]
$ftp_(83) attach-agent $tcp_(83)
$ns at 540.2 "$ftp_(83) start"
$ns at 720.0 "$ftp_(83) stop"

#Set a TCP connection between node_(14) and node_(80)
set tcp_(84) [new Agent/TCP/Newreno]
$tcp_(84) set class_ 2
set sink_(84) [new Agent/TCPSink]
$ns attach-agent $node_(14) $tcp_(84)
$ns attach-agent $node_(80) $sink_(84)
$ns connect $tcp_(84) $sink_(84)
set ftp_(84) [new Application/FTP]
$ftp_(84) attach-agent $tcp_(84)
$ns at 720.2 "$ftp_(84) start"
$ns at 900.0 "$ftp_(84) stop"

#Set a TCP connection between node_(66) and node_(33)
set tcp_(85) [new Agent/TCP/Newreno]
$tcp_(85) set class_ 2
set sink_(85) [new Agent/TCPSink]
$ns attach-agent $node_(66) $tcp_(85)
$ns attach-agent $node_(33) $sink_(85)
$ns connect $tcp_(85) $sink_(85)
set ftp_(85) [new Application/FTP]
$ftp_(85) attach-agent $tcp_(85)
$ns at 0.2 "$ftp_(85) start"
$ns at 180.0 "$ftp_(85) stop"

#Set a TCP connection between node_(36) and node_(81)
set tcp_(86) [new Agent/TCP/Newreno]
$tcp_(86) set class_ 2
set sink_(86) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(86)
$ns attach-agent $node_(81) $sink_(86)
$ns connect $tcp_(86) $sink_(86)
set ftp_(86) [new Application/FTP]
$ftp_(86) attach-agent $tcp_(86)
$ns at 180.2 "$ftp_(86) start"
$ns at 360.0 "$ftp_(86) stop"

#Set a TCP connection between node_(73) and node_(57)
set tcp_(87) [new Agent/TCP/Newreno]
$tcp_(87) set class_ 2
set sink_(87) [new Agent/TCPSink]
$ns attach-agent $node_(73) $tcp_(87)
$ns attach-agent $node_(57) $sink_(87)
$ns connect $tcp_(87) $sink_(87)
set ftp_(87) [new Application/FTP]
$ftp_(87) attach-agent $tcp_(87)
$ns at 360.2 "$ftp_(87) start"
$ns at 540.0 "$ftp_(87) stop"

#Set a TCP connection between node_(17) and node_(9)
set tcp_(88) [new Agent/TCP/Newreno]
$tcp_(88) set class_ 2
set sink_(88) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(88)
$ns attach-agent $node_(9) $sink_(88)
$ns connect $tcp_(88) $sink_(88)
set ftp_(88) [new Application/FTP]
$ftp_(88) attach-agent $tcp_(88)
$ns at 540.2 "$ftp_(88) start"
$ns at 720.0 "$ftp_(88) stop"

#Set a TCP connection between node_(32) and node_(27)
set tcp_(89) [new Agent/TCP/Newreno]
$tcp_(89) set class_ 2
set sink_(89) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(89)
$ns attach-agent $node_(27) $sink_(89)
$ns connect $tcp_(89) $sink_(89)
set ftp_(89) [new Application/FTP]
$ftp_(89) attach-agent $tcp_(89)
$ns at 720.2 "$ftp_(89) start"
$ns at 900.0 "$ftp_(89) stop"

#Set a TCP connection between node_(64) and node_(29)
set tcp_(90) [new Agent/TCP/Newreno]
$tcp_(90) set class_ 2
set sink_(90) [new Agent/TCPSink]
$ns attach-agent $node_(64) $tcp_(90)
$ns attach-agent $node_(29) $sink_(90)
$ns connect $tcp_(90) $sink_(90)
set ftp_(90) [new Application/FTP]
$ftp_(90) attach-agent $tcp_(90)
$ns at 0.2 "$ftp_(90) start"
$ns at 180.0 "$ftp_(90) stop"

#Set a TCP connection between node_(48) and node_(87)
set tcp_(91) [new Agent/TCP/Newreno]
$tcp_(91) set class_ 2
set sink_(91) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(91)
$ns attach-agent $node_(87) $sink_(91)
$ns connect $tcp_(91) $sink_(91)
set ftp_(91) [new Application/FTP]
$ftp_(91) attach-agent $tcp_(91)
$ns at 180.2 "$ftp_(91) start"
$ns at 360.0 "$ftp_(91) stop"

#Set a TCP connection between node_(6) and node_(41)
set tcp_(92) [new Agent/TCP/Newreno]
$tcp_(92) set class_ 2
set sink_(92) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(92)
$ns attach-agent $node_(41) $sink_(92)
$ns connect $tcp_(92) $sink_(92)
set ftp_(92) [new Application/FTP]
$ftp_(92) attach-agent $tcp_(92)
$ns at 360.2 "$ftp_(92) start"
$ns at 540.0 "$ftp_(92) stop"

#Set a TCP connection between node_(91) and node_(37)
set tcp_(93) [new Agent/TCP/Newreno]
$tcp_(93) set class_ 2
set sink_(93) [new Agent/TCPSink]
$ns attach-agent $node_(91) $tcp_(93)
$ns attach-agent $node_(37) $sink_(93)
$ns connect $tcp_(93) $sink_(93)
set ftp_(93) [new Application/FTP]
$ftp_(93) attach-agent $tcp_(93)
$ns at 540.2 "$ftp_(93) start"
$ns at 720.0 "$ftp_(93) stop"

#Set a TCP connection between node_(47) and node_(86)
set tcp_(94) [new Agent/TCP/Newreno]
$tcp_(94) set class_ 2
set sink_(94) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(94)
$ns attach-agent $node_(86) $sink_(94)
$ns connect $tcp_(94) $sink_(94)
set ftp_(94) [new Application/FTP]
$ftp_(94) attach-agent $tcp_(94)
$ns at 720.2 "$ftp_(94) start"
$ns at 900.0 "$ftp_(94) stop"

#Set a TCP connection between node_(13) and node_(74)
set tcp_(95) [new Agent/TCP/Newreno]
$tcp_(95) set class_ 2
set sink_(95) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(95)
$ns attach-agent $node_(74) $sink_(95)
$ns connect $tcp_(95) $sink_(95)
set ftp_(95) [new Application/FTP]
$ftp_(95) attach-agent $tcp_(95)
$ns at 0.2 "$ftp_(95) start"
$ns at 180.0 "$ftp_(95) stop"

#Set a TCP connection between node_(18) and node_(54)
set tcp_(96) [new Agent/TCP/Newreno]
$tcp_(96) set class_ 2
set sink_(96) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(96)
$ns attach-agent $node_(54) $sink_(96)
$ns connect $tcp_(96) $sink_(96)
set ftp_(96) [new Application/FTP]
$ftp_(96) attach-agent $tcp_(96)
$ns at 180.2 "$ftp_(96) start"
$ns at 360.0 "$ftp_(96) stop"

#Set a TCP connection between node_(72) and node_(27)
set tcp_(97) [new Agent/TCP/Newreno]
$tcp_(97) set class_ 2
set sink_(97) [new Agent/TCPSink]
$ns attach-agent $node_(72) $tcp_(97)
$ns attach-agent $node_(27) $sink_(97)
$ns connect $tcp_(97) $sink_(97)
set ftp_(97) [new Application/FTP]
$ftp_(97) attach-agent $tcp_(97)
$ns at 360.2 "$ftp_(97) start"
$ns at 540.0 "$ftp_(97) stop"

#Set a TCP connection between node_(57) and node_(34)
set tcp_(98) [new Agent/TCP/Newreno]
$tcp_(98) set class_ 2
set sink_(98) [new Agent/TCPSink]
$ns attach-agent $node_(57) $tcp_(98)
$ns attach-agent $node_(34) $sink_(98)
$ns connect $tcp_(98) $sink_(98)
set ftp_(98) [new Application/FTP]
$ftp_(98) attach-agent $tcp_(98)
$ns at 540.2 "$ftp_(98) start"
$ns at 720.0 "$ftp_(98) stop"

#Set a TCP connection between node_(36) and node_(13)
set tcp_(99) [new Agent/TCP/Newreno]
$tcp_(99) set class_ 2
set sink_(99) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(99)
$ns attach-agent $node_(13) $sink_(99)
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
