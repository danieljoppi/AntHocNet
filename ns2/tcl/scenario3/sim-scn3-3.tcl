#sim-scn3-3.tcl 
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
set tracefd       [open sim-scn3-3-$val(rp)-trace.tr w]
set windowVsTime2 [open sim-scn3-3-$val(rp)-win-.tr w]
set namtrace      [open sim-scn3-3-$val(rp).nam w]

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
$node_(0) set X_ 2479 
$node_(0) set Y_ 147 
$node_(0) set Z_ 0.0 
$node_(1) set X_ 2614 
$node_(1) set Y_ 947 
$node_(1) set Z_ 0.0 
$node_(2) set X_ 304 
$node_(2) set Y_ 963 
$node_(2) set Z_ 0.0 
$node_(3) set X_ 2401 
$node_(3) set Y_ 734 
$node_(3) set Z_ 0.0 
$node_(4) set X_ 403 
$node_(4) set Y_ 589 
$node_(4) set Z_ 0.0 
$node_(5) set X_ 2548 
$node_(5) set Y_ 963 
$node_(5) set Z_ 0.0 
$node_(6) set X_ 1611 
$node_(6) set Y_ 828 
$node_(6) set Z_ 0.0 
$node_(7) set X_ 1504 
$node_(7) set Y_ 70 
$node_(7) set Z_ 0.0 
$node_(8) set X_ 2697 
$node_(8) set Y_ 258 
$node_(8) set Z_ 0.0 
$node_(9) set X_ 2821 
$node_(9) set Y_ 871 
$node_(9) set Z_ 0.0 
$node_(10) set X_ 1801 
$node_(10) set Y_ 201 
$node_(10) set Z_ 0.0 
$node_(11) set X_ 1709 
$node_(11) set Y_ 758 
$node_(11) set Z_ 0.0 
$node_(12) set X_ 1531 
$node_(12) set Y_ 359 
$node_(12) set Z_ 0.0 
$node_(13) set X_ 179 
$node_(13) set Y_ 198 
$node_(13) set Z_ 0.0 
$node_(14) set X_ 981 
$node_(14) set Y_ 30 
$node_(14) set Z_ 0.0 
$node_(15) set X_ 2052 
$node_(15) set Y_ 349 
$node_(15) set Z_ 0.0 
$node_(16) set X_ 2373 
$node_(16) set Y_ 675 
$node_(16) set Z_ 0.0 
$node_(17) set X_ 2302 
$node_(17) set Y_ 187 
$node_(17) set Z_ 0.0 
$node_(18) set X_ 2719 
$node_(18) set Y_ 134 
$node_(18) set Z_ 0.0 
$node_(19) set X_ 105 
$node_(19) set Y_ 279 
$node_(19) set Z_ 0.0 
$node_(20) set X_ 1833 
$node_(20) set Y_ 1 
$node_(20) set Z_ 0.0 
$node_(21) set X_ 1650 
$node_(21) set Y_ 201 
$node_(21) set Z_ 0.0 
$node_(22) set X_ 88 
$node_(22) set Y_ 451 
$node_(22) set Z_ 0.0 
$node_(23) set X_ 2067 
$node_(23) set Y_ 683 
$node_(23) set Z_ 0.0 
$node_(24) set X_ 1728 
$node_(24) set Y_ 390 
$node_(24) set Z_ 0.0 
$node_(25) set X_ 971 
$node_(25) set Y_ 711 
$node_(25) set Z_ 0.0 
$node_(26) set X_ 2042 
$node_(26) set Y_ 863 
$node_(26) set Z_ 0.0 
$node_(27) set X_ 2844 
$node_(27) set Y_ 224 
$node_(27) set Z_ 0.0 
$node_(28) set X_ 2529 
$node_(28) set Y_ 545 
$node_(28) set Z_ 0.0 
$node_(29) set X_ 67 
$node_(29) set Y_ 523 
$node_(29) set Z_ 0.0 
$node_(30) set X_ 164 
$node_(30) set Y_ 547 
$node_(30) set Z_ 0.0 
$node_(31) set X_ 582 
$node_(31) set Y_ 189 
$node_(31) set Z_ 0.0 
$node_(32) set X_ 1096 
$node_(32) set Y_ 930 
$node_(32) set Z_ 0.0 
$node_(33) set X_ 1156 
$node_(33) set Y_ 134 
$node_(33) set Z_ 0.0 
$node_(34) set X_ 1550 
$node_(34) set Y_ 64 
$node_(34) set Z_ 0.0 
$node_(35) set X_ 2880 
$node_(35) set Y_ 386 
$node_(35) set Z_ 0.0 
$node_(36) set X_ 348 
$node_(36) set Y_ 445 
$node_(36) set Z_ 0.0 
$node_(37) set X_ 916 
$node_(37) set Y_ 355 
$node_(37) set Z_ 0.0 
$node_(38) set X_ 2362 
$node_(38) set Y_ 633 
$node_(38) set Z_ 0.0 
$node_(39) set X_ 630 
$node_(39) set Y_ 602 
$node_(39) set Z_ 0.0 
$node_(40) set X_ 270 
$node_(40) set Y_ 740 
$node_(40) set Z_ 0.0 
$node_(41) set X_ 1058 
$node_(41) set Y_ 612 
$node_(41) set Z_ 0.0 
$node_(42) set X_ 2331 
$node_(42) set Y_ 315 
$node_(42) set Z_ 0.0 
$node_(43) set X_ 216 
$node_(43) set Y_ 647 
$node_(43) set Z_ 0.0 
$node_(44) set X_ 410 
$node_(44) set Y_ 494 
$node_(44) set Z_ 0.0 
$node_(45) set X_ 1015 
$node_(45) set Y_ 549 
$node_(45) set Z_ 0.0 
$node_(46) set X_ 2226 
$node_(46) set Y_ 43 
$node_(46) set Z_ 0.0 
$node_(47) set X_ 1528 
$node_(47) set Y_ 248 
$node_(47) set Z_ 0.0 
$node_(48) set X_ 2778 
$node_(48) set Y_ 255 
$node_(48) set Z_ 0.0 
$node_(49) set X_ 79 
$node_(49) set Y_ 843 
$node_(49) set Z_ 0.0 
$node_(50) set X_ 2085 
$node_(50) set Y_ 723 
$node_(50) set Z_ 0.0 
$node_(51) set X_ 2001 
$node_(51) set Y_ 318 
$node_(51) set Z_ 0.0 
$node_(52) set X_ 1778 
$node_(52) set Y_ 664 
$node_(52) set Z_ 0.0 
$node_(53) set X_ 1095 
$node_(53) set Y_ 373 
$node_(53) set Z_ 0.0 
$node_(54) set X_ 713 
$node_(54) set Y_ 848 
$node_(54) set Z_ 0.0 
$node_(55) set X_ 2659 
$node_(55) set Y_ 371 
$node_(55) set Z_ 0.0 
$node_(56) set X_ 2601 
$node_(56) set Y_ 139 
$node_(56) set Z_ 0.0 
$node_(57) set X_ 2526 
$node_(57) set Y_ 128 
$node_(57) set Z_ 0.0 
$node_(58) set X_ 745 
$node_(58) set Y_ 347 
$node_(58) set Z_ 0.0 
$node_(59) set X_ 1865 
$node_(59) set Y_ 91 
$node_(59) set Z_ 0.0 
$node_(60) set X_ 2208 
$node_(60) set Y_ 372 
$node_(60) set Z_ 0.0 
$node_(61) set X_ 2502 
$node_(61) set Y_ 510 
$node_(61) set Z_ 0.0 
$node_(62) set X_ 284 
$node_(62) set Y_ 613 
$node_(62) set Z_ 0.0 
$node_(63) set X_ 2247 
$node_(63) set Y_ 337 
$node_(63) set Z_ 0.0 
$node_(64) set X_ 2820 
$node_(64) set Y_ 198 
$node_(64) set Z_ 0.0 
$node_(65) set X_ 181 
$node_(65) set Y_ 925 
$node_(65) set Z_ 0.0 
$node_(66) set X_ 905 
$node_(66) set Y_ 925 
$node_(66) set Z_ 0.0 
$node_(67) set X_ 13 
$node_(67) set Y_ 102 
$node_(67) set Z_ 0.0 
$node_(68) set X_ 2569 
$node_(68) set Y_ 678 
$node_(68) set Z_ 0.0 
$node_(69) set X_ 1512 
$node_(69) set Y_ 792 
$node_(69) set Z_ 0.0 
$node_(70) set X_ 2544 
$node_(70) set Y_ 718 
$node_(70) set Z_ 0.0 
$node_(71) set X_ 1628 
$node_(71) set Y_ 186 
$node_(71) set Z_ 0.0 
$node_(72) set X_ 1694 
$node_(72) set Y_ 481 
$node_(72) set Z_ 0.0 
$node_(73) set X_ 1245 
$node_(73) set Y_ 391 
$node_(73) set Z_ 0.0 
$node_(74) set X_ 1554 
$node_(74) set Y_ 405 
$node_(74) set Z_ 0.0 
$node_(75) set X_ 2552 
$node_(75) set Y_ 613 
$node_(75) set Z_ 0.0 
$node_(76) set X_ 458 
$node_(76) set Y_ 894 
$node_(76) set Z_ 0.0 
$node_(77) set X_ 775 
$node_(77) set Y_ 168 
$node_(77) set Z_ 0.0 
$node_(78) set X_ 2949 
$node_(78) set Y_ 719 
$node_(78) set Z_ 0.0 
$node_(79) set X_ 1522 
$node_(79) set Y_ 58 
$node_(79) set Z_ 0.0 
$node_(80) set X_ 1675 
$node_(80) set Y_ 41 
$node_(80) set Z_ 0.0 
$node_(81) set X_ 2156 
$node_(81) set Y_ 409 
$node_(81) set Z_ 0.0 
$node_(82) set X_ 1624 
$node_(82) set Y_ 768 
$node_(82) set Z_ 0.0 
$node_(83) set X_ 1576 
$node_(83) set Y_ 801 
$node_(83) set Z_ 0.0 
$node_(84) set X_ 1492 
$node_(84) set Y_ 139 
$node_(84) set Z_ 0.0 
$node_(85) set X_ 382 
$node_(85) set Y_ 419 
$node_(85) set Z_ 0.0 
$node_(86) set X_ 2064 
$node_(86) set Y_ 267 
$node_(86) set Z_ 0.0 
$node_(87) set X_ 797 
$node_(87) set Y_ 980 
$node_(87) set Z_ 0.0 
$node_(88) set X_ 857 
$node_(88) set Y_ 885 
$node_(88) set Z_ 0.0 
$node_(89) set X_ 2770 
$node_(89) set Y_ 605 
$node_(89) set Z_ 0.0 
$node_(90) set X_ 2838 
$node_(90) set Y_ 660 
$node_(90) set Z_ 0.0 
$node_(91) set X_ 487 
$node_(91) set Y_ 163 
$node_(91) set Z_ 0.0 
$node_(92) set X_ 1785 
$node_(92) set Y_ 298 
$node_(92) set Z_ 0.0 
$node_(93) set X_ 40 
$node_(93) set Y_ 105 
$node_(93) set Z_ 0.0 
$node_(94) set X_ 1884 
$node_(94) set Y_ 73 
$node_(94) set Z_ 0.0 
$node_(95) set X_ 2229 
$node_(95) set Y_ 510 
$node_(95) set Z_ 0.0 
$node_(96) set X_ 1360 
$node_(96) set Y_ 591 
$node_(96) set Z_ 0.0 
$node_(97) set X_ 421 
$node_(97) set Y_ 856 
$node_(97) set Z_ 0.0 
$node_(98) set X_ 1378 
$node_(98) set Y_ 323 
$node_(98) set Z_ 0.0 
$node_(99) set X_ 2069 
$node_(99) set Y_ 36 
$node_(99) set Z_ 0.0 
$node_(100) set X_ 108 
$node_(100) set Y_ 926 
$node_(100) set Z_ 0.0 
$node_(101) set X_ 1886 
$node_(101) set Y_ 253 
$node_(101) set Z_ 0.0 
$ns at 0.0 "$node_(101) off" 
$ns at 100.0 "$node_(101) on" 
$node_(102) set X_ 713 
$node_(102) set Y_ 426 
$node_(102) set Z_ 0.0 
$ns at 0.0 "$node_(102) off" 
$ns at 100.0 "$node_(102) on" 
$node_(103) set X_ 2760 
$node_(103) set Y_ 755 
$node_(103) set Z_ 0.0 
$ns at 0.0 "$node_(103) off" 
$ns at 100.0 "$node_(103) on" 
$node_(104) set X_ 140 
$node_(104) set Y_ 106 
$node_(104) set Z_ 0.0 
$ns at 0.0 "$node_(104) off" 
$ns at 100.0 "$node_(104) on" 
$node_(105) set X_ 347 
$node_(105) set Y_ 781 
$node_(105) set Z_ 0.0 
$ns at 0.0 "$node_(105) off" 
$ns at 100.0 "$node_(105) on" 
$node_(106) set X_ 2852 
$node_(106) set Y_ 322 
$node_(106) set Z_ 0.0 
$ns at 0.0 "$node_(106) off" 
$ns at 100.0 "$node_(106) on" 
$node_(107) set X_ 2805 
$node_(107) set Y_ 725 
$node_(107) set Z_ 0.0 
$ns at 0.0 "$node_(107) off" 
$ns at 100.0 "$node_(107) on" 
$node_(108) set X_ 2234 
$node_(108) set Y_ 565 
$node_(108) set Z_ 0.0 
$ns at 0.0 "$node_(108) off" 
$ns at 100.0 "$node_(108) on" 
$node_(109) set X_ 405 
$node_(109) set Y_ 281 
$node_(109) set Z_ 0.0 
$ns at 0.0 "$node_(109) off" 
$ns at 100.0 "$node_(109) on" 
$node_(110) set X_ 102 
$node_(110) set Y_ 763 
$node_(110) set Z_ 0.0 
$ns at 0.0 "$node_(110) off" 
$ns at 100.0 "$node_(110) on" 
$node_(111) set X_ 2749 
$node_(111) set Y_ 245 
$node_(111) set Z_ 0.0 
$ns at 0.0 "$node_(111) off" 
$ns at 100.0 "$node_(111) on" 
$node_(112) set X_ 2740 
$node_(112) set Y_ 216 
$node_(112) set Z_ 0.0 
$ns at 0.0 "$node_(112) off" 
$ns at 100.0 "$node_(112) on" 
$node_(113) set X_ 1991 
$node_(113) set Y_ 725 
$node_(113) set Z_ 0.0 
$ns at 0.0 "$node_(113) off" 
$ns at 100.0 "$node_(113) on" 
$node_(114) set X_ 2071 
$node_(114) set Y_ 581 
$node_(114) set Z_ 0.0 
$ns at 0.0 "$node_(114) off" 
$ns at 100.0 "$node_(114) on" 
$node_(115) set X_ 940 
$node_(115) set Y_ 752 
$node_(115) set Z_ 0.0 
$ns at 0.0 "$node_(115) off" 
$ns at 100.0 "$node_(115) on" 
$node_(116) set X_ 969 
$node_(116) set Y_ 995 
$node_(116) set Z_ 0.0 
$ns at 0.0 "$node_(116) off" 
$ns at 100.0 "$node_(116) on" 
$node_(117) set X_ 2986 
$node_(117) set Y_ 663 
$node_(117) set Z_ 0.0 
$ns at 0.0 "$node_(117) off" 
$ns at 100.0 "$node_(117) on" 
$node_(118) set X_ 1343 
$node_(118) set Y_ 786 
$node_(118) set Z_ 0.0 
$ns at 0.0 "$node_(118) off" 
$ns at 100.0 "$node_(118) on" 
$node_(119) set X_ 2724 
$node_(119) set Y_ 167 
$node_(119) set Z_ 0.0 
$ns at 0.0 "$node_(119) off" 
$ns at 100.0 "$node_(119) on" 
$node_(120) set X_ 1474 
$node_(120) set Y_ 195 
$node_(120) set Z_ 0.0 
$ns at 0.0 "$node_(120) off" 
$ns at 100.0 "$node_(120) on" 
$node_(121) set X_ 1670 
$node_(121) set Y_ 727 
$node_(121) set Z_ 0.0 
$ns at 0.0 "$node_(121) off" 
$ns at 100.0 "$node_(121) on" 
$node_(122) set X_ 1142 
$node_(122) set Y_ 209 
$node_(122) set Z_ 0.0 
$ns at 0.0 "$node_(122) off" 
$ns at 100.0 "$node_(122) on" 
$node_(123) set X_ 1791 
$node_(123) set Y_ 713 
$node_(123) set Z_ 0.0 
$ns at 0.0 "$node_(123) off" 
$ns at 100.0 "$node_(123) on" 
$node_(124) set X_ 2359 
$node_(124) set Y_ 901 
$node_(124) set Z_ 0.0 
$ns at 0.0 "$node_(124) off" 
$ns at 100.0 "$node_(124) on" 
$node_(125) set X_ 1579 
$node_(125) set Y_ 832 
$node_(125) set Z_ 0.0 
$ns at 0.0 "$node_(125) off" 
$ns at 100.0 "$node_(125) on" 
$node_(126) set X_ 2025 
$node_(126) set Y_ 635 
$node_(126) set Z_ 0.0 
$ns at 0.0 "$node_(126) off" 
$ns at 100.0 "$node_(126) on" 
$node_(127) set X_ 1127 
$node_(127) set Y_ 477 
$node_(127) set Z_ 0.0 
$ns at 0.0 "$node_(127) off" 
$ns at 100.0 "$node_(127) on" 
$node_(128) set X_ 541 
$node_(128) set Y_ 128 
$node_(128) set Z_ 0.0 
$ns at 0.0 "$node_(128) off" 
$ns at 100.0 "$node_(128) on" 
$node_(129) set X_ 1116 
$node_(129) set Y_ 983 
$node_(129) set Z_ 0.0 
$ns at 0.0 "$node_(129) off" 
$ns at 100.0 "$node_(129) on" 
$node_(130) set X_ 1360 
$node_(130) set Y_ 641 
$node_(130) set Z_ 0.0 
$ns at 0.0 "$node_(130) off" 
$ns at 100.0 "$node_(130) on" 
$node_(131) set X_ 804 
$node_(131) set Y_ 245 
$node_(131) set Z_ 0.0 
$ns at 0.0 "$node_(131) off" 
$ns at 100.0 "$node_(131) on" 
$node_(132) set X_ 589 
$node_(132) set Y_ 478 
$node_(132) set Z_ 0.0 
$ns at 0.0 "$node_(132) off" 
$ns at 100.0 "$node_(132) on" 
$node_(133) set X_ 1996 
$node_(133) set Y_ 817 
$node_(133) set Z_ 0.0 
$ns at 0.0 "$node_(133) off" 
$ns at 100.0 "$node_(133) on" 
$node_(134) set X_ 145 
$node_(134) set Y_ 605 
$node_(134) set Z_ 0.0 
$ns at 0.0 "$node_(134) off" 
$ns at 100.0 "$node_(134) on" 
$node_(135) set X_ 554 
$node_(135) set Y_ 356 
$node_(135) set Z_ 0.0 
$ns at 0.0 "$node_(135) off" 
$ns at 100.0 "$node_(135) on" 
$node_(136) set X_ 2574 
$node_(136) set Y_ 411 
$node_(136) set Z_ 0.0 
$ns at 0.0 "$node_(136) off" 
$ns at 100.0 "$node_(136) on" 
$node_(137) set X_ 2388 
$node_(137) set Y_ 288 
$node_(137) set Z_ 0.0 
$ns at 0.0 "$node_(137) off" 
$ns at 100.0 "$node_(137) on" 
$node_(138) set X_ 415 
$node_(138) set Y_ 565 
$node_(138) set Z_ 0.0 
$ns at 0.0 "$node_(138) off" 
$ns at 100.0 "$node_(138) on" 
$node_(139) set X_ 2856 
$node_(139) set Y_ 618 
$node_(139) set Z_ 0.0 
$ns at 0.0 "$node_(139) off" 
$ns at 100.0 "$node_(139) on" 
$node_(140) set X_ 2058 
$node_(140) set Y_ 452 
$node_(140) set Z_ 0.0 
$ns at 0.0 "$node_(140) off" 
$ns at 100.0 "$node_(140) on" 
$node_(141) set X_ 1312 
$node_(141) set Y_ 125 
$node_(141) set Z_ 0.0 
$ns at 0.0 "$node_(141) off" 
$ns at 100.0 "$node_(141) on" 
$node_(142) set X_ 1284 
$node_(142) set Y_ 921 
$node_(142) set Z_ 0.0 
$ns at 0.0 "$node_(142) off" 
$ns at 100.0 "$node_(142) on" 
$node_(143) set X_ 2994 
$node_(143) set Y_ 544 
$node_(143) set Z_ 0.0 
$ns at 0.0 "$node_(143) off" 
$ns at 100.0 "$node_(143) on" 
$node_(144) set X_ 127 
$node_(144) set Y_ 924 
$node_(144) set Z_ 0.0 
$ns at 0.0 "$node_(144) off" 
$ns at 100.0 "$node_(144) on" 
$node_(145) set X_ 2659 
$node_(145) set Y_ 975 
$node_(145) set Z_ 0.0 
$ns at 0.0 "$node_(145) off" 
$ns at 100.0 "$node_(145) on" 
$node_(146) set X_ 2402 
$node_(146) set Y_ 158 
$node_(146) set Z_ 0.0 
$ns at 0.0 "$node_(146) off" 
$ns at 100.0 "$node_(146) on" 
$node_(147) set X_ 1300 
$node_(147) set Y_ 427 
$node_(147) set Z_ 0.0 
$ns at 0.0 "$node_(147) off" 
$ns at 100.0 "$node_(147) on" 
$node_(148) set X_ 1144 
$node_(148) set Y_ 31 
$node_(148) set Z_ 0.0 
$ns at 0.0 "$node_(148) off" 
$ns at 100.0 "$node_(148) on" 
$node_(149) set X_ 1902 
$node_(149) set Y_ 356 
$node_(149) set Z_ 0.0 
$ns at 0.0 "$node_(149) off" 
$ns at 100.0 "$node_(149) on" 
$node_(150) set X_ 331 
$node_(150) set Y_ 61 
$node_(150) set Z_ 0.0 
$ns at 0.0 "$node_(150) off" 
$ns at 100.0 "$node_(150) on" 
$node_(151) set X_ 1559 
$node_(151) set Y_ 31 
$node_(151) set Z_ 0.0 
$ns at 0.0 "$node_(151) off" 
$ns at 100.0 "$node_(151) on" 
$node_(152) set X_ 586 
$node_(152) set Y_ 382 
$node_(152) set Z_ 0.0 
$ns at 0.0 "$node_(152) off" 
$ns at 100.0 "$node_(152) on" 
$node_(153) set X_ 2363 
$node_(153) set Y_ 835 
$node_(153) set Z_ 0.0 
$ns at 0.0 "$node_(153) off" 
$ns at 100.0 "$node_(153) on" 
$node_(154) set X_ 148 
$node_(154) set Y_ 125 
$node_(154) set Z_ 0.0 
$ns at 0.0 "$node_(154) off" 
$ns at 100.0 "$node_(154) on" 
$node_(155) set X_ 2263 
$node_(155) set Y_ 905 
$node_(155) set Z_ 0.0 
$ns at 0.0 "$node_(155) off" 
$ns at 100.0 "$node_(155) on" 
$node_(156) set X_ 2152 
$node_(156) set Y_ 281 
$node_(156) set Z_ 0.0 
$ns at 0.0 "$node_(156) off" 
$ns at 100.0 "$node_(156) on" 
$node_(157) set X_ 592 
$node_(157) set Y_ 58 
$node_(157) set Z_ 0.0 
$ns at 0.0 "$node_(157) off" 
$ns at 100.0 "$node_(157) on" 
$node_(158) set X_ 2277 
$node_(158) set Y_ 124 
$node_(158) set Z_ 0.0 
$ns at 0.0 "$node_(158) off" 
$ns at 100.0 "$node_(158) on" 
$node_(159) set X_ 219 
$node_(159) set Y_ 610 
$node_(159) set Z_ 0.0 
$ns at 0.0 "$node_(159) off" 
$ns at 100.0 "$node_(159) on" 
$node_(160) set X_ 2024 
$node_(160) set Y_ 366 
$node_(160) set Z_ 0.0 
$ns at 0.0 "$node_(160) off" 
$ns at 100.0 "$node_(160) on" 
$node_(161) set X_ 1230 
$node_(161) set Y_ 533 
$node_(161) set Z_ 0.0 
$ns at 0.0 "$node_(161) off" 
$ns at 100.0 "$node_(161) on" 
$node_(162) set X_ 340 
$node_(162) set Y_ 30 
$node_(162) set Z_ 0.0 
$ns at 0.0 "$node_(162) off" 
$ns at 100.0 "$node_(162) on" 
$node_(163) set X_ 2684 
$node_(163) set Y_ 349 
$node_(163) set Z_ 0.0 
$ns at 0.0 "$node_(163) off" 
$ns at 100.0 "$node_(163) on" 
$node_(164) set X_ 1939 
$node_(164) set Y_ 431 
$node_(164) set Z_ 0.0 
$ns at 0.0 "$node_(164) off" 
$ns at 100.0 "$node_(164) on" 
$node_(165) set X_ 2430 
$node_(165) set Y_ 321 
$node_(165) set Z_ 0.0 
$ns at 0.0 "$node_(165) off" 
$ns at 100.0 "$node_(165) on" 
$node_(166) set X_ 2558 
$node_(166) set Y_ 759 
$node_(166) set Z_ 0.0 
$ns at 0.0 "$node_(166) off" 
$ns at 100.0 "$node_(166) on" 
$node_(167) set X_ 26 
$node_(167) set Y_ 800 
$node_(167) set Z_ 0.0 
$ns at 0.0 "$node_(167) off" 
$ns at 100.0 "$node_(167) on" 
$node_(168) set X_ 2481 
$node_(168) set Y_ 517 
$node_(168) set Z_ 0.0 
$ns at 0.0 "$node_(168) off" 
$ns at 100.0 "$node_(168) on" 
$node_(169) set X_ 1675 
$node_(169) set Y_ 5 
$node_(169) set Z_ 0.0 
$ns at 0.0 "$node_(169) off" 
$ns at 100.0 "$node_(169) on" 
$node_(170) set X_ 2963 
$node_(170) set Y_ 436 
$node_(170) set Z_ 0.0 
$ns at 0.0 "$node_(170) off" 
$ns at 100.0 "$node_(170) on" 
$node_(171) set X_ 1602 
$node_(171) set Y_ 154 
$node_(171) set Z_ 0.0 
$ns at 0.0 "$node_(171) off" 
$ns at 100.0 "$node_(171) on" 
$node_(172) set X_ 729 
$node_(172) set Y_ 594 
$node_(172) set Z_ 0.0 
$ns at 0.0 "$node_(172) off" 
$ns at 100.0 "$node_(172) on" 
$node_(173) set X_ 586 
$node_(173) set Y_ 610 
$node_(173) set Z_ 0.0 
$ns at 0.0 "$node_(173) off" 
$ns at 100.0 "$node_(173) on" 
$node_(174) set X_ 466 
$node_(174) set Y_ 140 
$node_(174) set Z_ 0.0 
$ns at 0.0 "$node_(174) off" 
$ns at 100.0 "$node_(174) on" 
$node_(175) set X_ 1333 
$node_(175) set Y_ 626 
$node_(175) set Z_ 0.0 
$ns at 0.0 "$node_(175) off" 
$ns at 100.0 "$node_(175) on" 
$node_(176) set X_ 2186 
$node_(176) set Y_ 423 
$node_(176) set Z_ 0.0 
$ns at 0.0 "$node_(176) off" 
$ns at 100.0 "$node_(176) on" 
$node_(177) set X_ 68 
$node_(177) set Y_ 346 
$node_(177) set Z_ 0.0 
$ns at 0.0 "$node_(177) off" 
$ns at 100.0 "$node_(177) on" 
$node_(178) set X_ 2549 
$node_(178) set Y_ 342 
$node_(178) set Z_ 0.0 
$ns at 0.0 "$node_(178) off" 
$ns at 100.0 "$node_(178) on" 
$node_(179) set X_ 1184 
$node_(179) set Y_ 970 
$node_(179) set Z_ 0.0 
$ns at 0.0 "$node_(179) off" 
$ns at 100.0 "$node_(179) on" 
$node_(180) set X_ 613 
$node_(180) set Y_ 428 
$node_(180) set Z_ 0.0 
$ns at 0.0 "$node_(180) off" 
$ns at 100.0 "$node_(180) on" 
$node_(181) set X_ 1865 
$node_(181) set Y_ 333 
$node_(181) set Z_ 0.0 
$ns at 0.0 "$node_(181) off" 
$ns at 100.0 "$node_(181) on" 
$node_(182) set X_ 2110 
$node_(182) set Y_ 486 
$node_(182) set Z_ 0.0 
$ns at 0.0 "$node_(182) off" 
$ns at 100.0 "$node_(182) on" 
$node_(183) set X_ 2515 
$node_(183) set Y_ 760 
$node_(183) set Z_ 0.0 
$ns at 0.0 "$node_(183) off" 
$ns at 100.0 "$node_(183) on" 
$node_(184) set X_ 204 
$node_(184) set Y_ 665 
$node_(184) set Z_ 0.0 
$ns at 0.0 "$node_(184) off" 
$ns at 100.0 "$node_(184) on" 
$node_(185) set X_ 378 
$node_(185) set Y_ 689 
$node_(185) set Z_ 0.0 
$ns at 0.0 "$node_(185) off" 
$ns at 100.0 "$node_(185) on" 
$node_(186) set X_ 735 
$node_(186) set Y_ 422 
$node_(186) set Z_ 0.0 
$ns at 0.0 "$node_(186) off" 
$ns at 100.0 "$node_(186) on" 
$node_(187) set X_ 2013 
$node_(187) set Y_ 459 
$node_(187) set Z_ 0.0 
$ns at 0.0 "$node_(187) off" 
$ns at 100.0 "$node_(187) on" 
$node_(188) set X_ 2223 
$node_(188) set Y_ 209 
$node_(188) set Z_ 0.0 
$ns at 0.0 "$node_(188) off" 
$ns at 100.0 "$node_(188) on" 
$node_(189) set X_ 341 
$node_(189) set Y_ 648 
$node_(189) set Z_ 0.0 
$ns at 0.0 "$node_(189) off" 
$ns at 100.0 "$node_(189) on" 
$node_(190) set X_ 2438 
$node_(190) set Y_ 645 
$node_(190) set Z_ 0.0 
$ns at 0.0 "$node_(190) off" 
$ns at 100.0 "$node_(190) on" 
$node_(191) set X_ 2683 
$node_(191) set Y_ 537 
$node_(191) set Z_ 0.0 
$ns at 0.0 "$node_(191) off" 
$ns at 100.0 "$node_(191) on" 
$node_(192) set X_ 2024 
$node_(192) set Y_ 553 
$node_(192) set Z_ 0.0 
$ns at 0.0 "$node_(192) off" 
$ns at 100.0 "$node_(192) on" 
$node_(193) set X_ 673 
$node_(193) set Y_ 569 
$node_(193) set Z_ 0.0 
$ns at 0.0 "$node_(193) off" 
$ns at 100.0 "$node_(193) on" 
$node_(194) set X_ 1625 
$node_(194) set Y_ 561 
$node_(194) set Z_ 0.0 
$ns at 0.0 "$node_(194) off" 
$ns at 100.0 "$node_(194) on" 
$node_(195) set X_ 100 
$node_(195) set Y_ 179 
$node_(195) set Z_ 0.0 
$ns at 0.0 "$node_(195) off" 
$ns at 100.0 "$node_(195) on" 
$node_(196) set X_ 1103 
$node_(196) set Y_ 841 
$node_(196) set Z_ 0.0 
$ns at 0.0 "$node_(196) off" 
$ns at 100.0 "$node_(196) on" 
$node_(197) set X_ 2620 
$node_(197) set Y_ 14 
$node_(197) set Z_ 0.0 
$ns at 0.0 "$node_(197) off" 
$ns at 100.0 "$node_(197) on" 
$node_(198) set X_ 1825 
$node_(198) set Y_ 213 
$node_(198) set Z_ 0.0 
$ns at 0.0 "$node_(198) off" 
$ns at 100.0 "$node_(198) on" 
$node_(199) set X_ 892 
$node_(199) set Y_ 322 
$node_(199) set Z_ 0.0 
$ns at 0.0 "$node_(199) off" 
$ns at 100.0 "$node_(199) on" 
$node_(200) set X_ 575 
$node_(200) set Y_ 28 
$node_(200) set Z_ 0.0 
$ns at 0.0 "$node_(200) off" 
$ns at 200.0 "$node_(200) on" 
$node_(201) set X_ 2010 
$node_(201) set Y_ 273 
$node_(201) set Z_ 0.0 
$ns at 0.0 "$node_(201) off" 
$ns at 200.0 "$node_(201) on" 
$node_(202) set X_ 465 
$node_(202) set Y_ 200 
$node_(202) set Z_ 0.0 
$ns at 0.0 "$node_(202) off" 
$ns at 200.0 "$node_(202) on" 
$node_(203) set X_ 2166 
$node_(203) set Y_ 71 
$node_(203) set Z_ 0.0 
$ns at 0.0 "$node_(203) off" 
$ns at 200.0 "$node_(203) on" 
$node_(204) set X_ 250 
$node_(204) set Y_ 284 
$node_(204) set Z_ 0.0 
$ns at 0.0 "$node_(204) off" 
$ns at 200.0 "$node_(204) on" 
$node_(205) set X_ 1219 
$node_(205) set Y_ 973 
$node_(205) set Z_ 0.0 
$ns at 0.0 "$node_(205) off" 
$ns at 200.0 "$node_(205) on" 
$node_(206) set X_ 1705 
$node_(206) set Y_ 720 
$node_(206) set Z_ 0.0 
$ns at 0.0 "$node_(206) off" 
$ns at 200.0 "$node_(206) on" 
$node_(207) set X_ 2350 
$node_(207) set Y_ 744 
$node_(207) set Z_ 0.0 
$ns at 0.0 "$node_(207) off" 
$ns at 200.0 "$node_(207) on" 
$node_(208) set X_ 1178 
$node_(208) set Y_ 243 
$node_(208) set Z_ 0.0 
$ns at 0.0 "$node_(208) off" 
$ns at 200.0 "$node_(208) on" 
$node_(209) set X_ 2184 
$node_(209) set Y_ 687 
$node_(209) set Z_ 0.0 
$ns at 0.0 "$node_(209) off" 
$ns at 200.0 "$node_(209) on" 
$node_(210) set X_ 125 
$node_(210) set Y_ 973 
$node_(210) set Z_ 0.0 
$ns at 0.0 "$node_(210) off" 
$ns at 200.0 "$node_(210) on" 
$node_(211) set X_ 653 
$node_(211) set Y_ 66 
$node_(211) set Z_ 0.0 
$ns at 0.0 "$node_(211) off" 
$ns at 200.0 "$node_(211) on" 
$node_(212) set X_ 1350 
$node_(212) set Y_ 910 
$node_(212) set Z_ 0.0 
$ns at 0.0 "$node_(212) off" 
$ns at 200.0 "$node_(212) on" 
$node_(213) set X_ 2560 
$node_(213) set Y_ 671 
$node_(213) set Z_ 0.0 
$ns at 0.0 "$node_(213) off" 
$ns at 200.0 "$node_(213) on" 
$node_(214) set X_ 1776 
$node_(214) set Y_ 352 
$node_(214) set Z_ 0.0 
$ns at 0.0 "$node_(214) off" 
$ns at 200.0 "$node_(214) on" 
$node_(215) set X_ 120 
$node_(215) set Y_ 298 
$node_(215) set Z_ 0.0 
$ns at 0.0 "$node_(215) off" 
$ns at 200.0 "$node_(215) on" 
$node_(216) set X_ 1931 
$node_(216) set Y_ 321 
$node_(216) set Z_ 0.0 
$ns at 0.0 "$node_(216) off" 
$ns at 200.0 "$node_(216) on" 
$node_(217) set X_ 2849 
$node_(217) set Y_ 123 
$node_(217) set Z_ 0.0 
$ns at 0.0 "$node_(217) off" 
$ns at 200.0 "$node_(217) on" 
$node_(218) set X_ 2890 
$node_(218) set Y_ 151 
$node_(218) set Z_ 0.0 
$ns at 0.0 "$node_(218) off" 
$ns at 200.0 "$node_(218) on" 
$node_(219) set X_ 2987 
$node_(219) set Y_ 298 
$node_(219) set Z_ 0.0 
$ns at 0.0 "$node_(219) off" 
$ns at 200.0 "$node_(219) on" 
$node_(220) set X_ 192 
$node_(220) set Y_ 287 
$node_(220) set Z_ 0.0 
$ns at 0.0 "$node_(220) off" 
$ns at 200.0 "$node_(220) on" 
$node_(221) set X_ 100 
$node_(221) set Y_ 624 
$node_(221) set Z_ 0.0 
$ns at 0.0 "$node_(221) off" 
$ns at 200.0 "$node_(221) on" 
$node_(222) set X_ 256 
$node_(222) set Y_ 735 
$node_(222) set Z_ 0.0 
$ns at 0.0 "$node_(222) off" 
$ns at 200.0 "$node_(222) on" 
$node_(223) set X_ 2814 
$node_(223) set Y_ 804 
$node_(223) set Z_ 0.0 
$ns at 0.0 "$node_(223) off" 
$ns at 200.0 "$node_(223) on" 
$node_(224) set X_ 33 
$node_(224) set Y_ 790 
$node_(224) set Z_ 0.0 
$ns at 0.0 "$node_(224) off" 
$ns at 200.0 "$node_(224) on" 
$node_(225) set X_ 1517 
$node_(225) set Y_ 636 
$node_(225) set Z_ 0.0 
$ns at 0.0 "$node_(225) off" 
$ns at 200.0 "$node_(225) on" 
$node_(226) set X_ 60 
$node_(226) set Y_ 383 
$node_(226) set Z_ 0.0 
$ns at 0.0 "$node_(226) off" 
$ns at 200.0 "$node_(226) on" 
$node_(227) set X_ 2588 
$node_(227) set Y_ 441 
$node_(227) set Z_ 0.0 
$ns at 0.0 "$node_(227) off" 
$ns at 200.0 "$node_(227) on" 
$node_(228) set X_ 2764 
$node_(228) set Y_ 887 
$node_(228) set Z_ 0.0 
$ns at 0.0 "$node_(228) off" 
$ns at 200.0 "$node_(228) on" 
$node_(229) set X_ 2066 
$node_(229) set Y_ 215 
$node_(229) set Z_ 0.0 
$ns at 0.0 "$node_(229) off" 
$ns at 200.0 "$node_(229) on" 
$node_(230) set X_ 1698 
$node_(230) set Y_ 262 
$node_(230) set Z_ 0.0 
$ns at 0.0 "$node_(230) off" 
$ns at 200.0 "$node_(230) on" 
$node_(231) set X_ 1794 
$node_(231) set Y_ 234 
$node_(231) set Z_ 0.0 
$ns at 0.0 "$node_(231) off" 
$ns at 200.0 "$node_(231) on" 
$node_(232) set X_ 1528 
$node_(232) set Y_ 185 
$node_(232) set Z_ 0.0 
$ns at 0.0 "$node_(232) off" 
$ns at 200.0 "$node_(232) on" 
$node_(233) set X_ 2918 
$node_(233) set Y_ 331 
$node_(233) set Z_ 0.0 
$ns at 0.0 "$node_(233) off" 
$ns at 200.0 "$node_(233) on" 
$node_(234) set X_ 2855 
$node_(234) set Y_ 237 
$node_(234) set Z_ 0.0 
$ns at 0.0 "$node_(234) off" 
$ns at 200.0 "$node_(234) on" 
$node_(235) set X_ 1127 
$node_(235) set Y_ 646 
$node_(235) set Z_ 0.0 
$ns at 0.0 "$node_(235) off" 
$ns at 200.0 "$node_(235) on" 
$node_(236) set X_ 536 
$node_(236) set Y_ 221 
$node_(236) set Z_ 0.0 
$ns at 0.0 "$node_(236) off" 
$ns at 200.0 "$node_(236) on" 
$node_(237) set X_ 1322 
$node_(237) set Y_ 432 
$node_(237) set Z_ 0.0 
$ns at 0.0 "$node_(237) off" 
$ns at 200.0 "$node_(237) on" 
$node_(238) set X_ 866 
$node_(238) set Y_ 475 
$node_(238) set Z_ 0.0 
$ns at 0.0 "$node_(238) off" 
$ns at 200.0 "$node_(238) on" 
$node_(239) set X_ 2359 
$node_(239) set Y_ 397 
$node_(239) set Z_ 0.0 
$ns at 0.0 "$node_(239) off" 
$ns at 200.0 "$node_(239) on" 
$node_(240) set X_ 2999 
$node_(240) set Y_ 341 
$node_(240) set Z_ 0.0 
$ns at 0.0 "$node_(240) off" 
$ns at 200.0 "$node_(240) on" 
$node_(241) set X_ 241 
$node_(241) set Y_ 158 
$node_(241) set Z_ 0.0 
$ns at 0.0 "$node_(241) off" 
$ns at 200.0 "$node_(241) on" 
$node_(242) set X_ 2136 
$node_(242) set Y_ 49 
$node_(242) set Z_ 0.0 
$ns at 0.0 "$node_(242) off" 
$ns at 200.0 "$node_(242) on" 
$node_(243) set X_ 2524 
$node_(243) set Y_ 604 
$node_(243) set Z_ 0.0 
$ns at 0.0 "$node_(243) off" 
$ns at 200.0 "$node_(243) on" 
$node_(244) set X_ 2427 
$node_(244) set Y_ 896 
$node_(244) set Z_ 0.0 
$ns at 0.0 "$node_(244) off" 
$ns at 200.0 "$node_(244) on" 
$node_(245) set X_ 2854 
$node_(245) set Y_ 344 
$node_(245) set Z_ 0.0 
$ns at 0.0 "$node_(245) off" 
$ns at 200.0 "$node_(245) on" 
$node_(246) set X_ 1166 
$node_(246) set Y_ 999 
$node_(246) set Z_ 0.0 
$ns at 0.0 "$node_(246) off" 
$ns at 200.0 "$node_(246) on" 
$node_(247) set X_ 432 
$node_(247) set Y_ 992 
$node_(247) set Z_ 0.0 
$ns at 0.0 "$node_(247) off" 
$ns at 200.0 "$node_(247) on" 
$node_(248) set X_ 684 
$node_(248) set Y_ 846 
$node_(248) set Z_ 0.0 
$ns at 0.0 "$node_(248) off" 
$ns at 200.0 "$node_(248) on" 
$node_(249) set X_ 2741 
$node_(249) set Y_ 697 
$node_(249) set Z_ 0.0 
$ns at 0.0 "$node_(249) off" 
$ns at 200.0 "$node_(249) on" 
$node_(250) set X_ 2426 
$node_(250) set Y_ 563 
$node_(250) set Z_ 0.0 
$ns at 0.0 "$node_(250) off" 
$ns at 200.0 "$node_(250) on" 
$node_(251) set X_ 1195 
$node_(251) set Y_ 214 
$node_(251) set Z_ 0.0 
$ns at 0.0 "$node_(251) off" 
$ns at 200.0 "$node_(251) on" 
$node_(252) set X_ 1954 
$node_(252) set Y_ 101 
$node_(252) set Z_ 0.0 
$ns at 0.0 "$node_(252) off" 
$ns at 200.0 "$node_(252) on" 
$node_(253) set X_ 2374 
$node_(253) set Y_ 817 
$node_(253) set Z_ 0.0 
$ns at 0.0 "$node_(253) off" 
$ns at 200.0 "$node_(253) on" 
$node_(254) set X_ 142 
$node_(254) set Y_ 522 
$node_(254) set Z_ 0.0 
$ns at 0.0 "$node_(254) off" 
$ns at 200.0 "$node_(254) on" 
$node_(255) set X_ 2244 
$node_(255) set Y_ 526 
$node_(255) set Z_ 0.0 
$ns at 0.0 "$node_(255) off" 
$ns at 200.0 "$node_(255) on" 
$node_(256) set X_ 1530 
$node_(256) set Y_ 180 
$node_(256) set Z_ 0.0 
$ns at 0.0 "$node_(256) off" 
$ns at 200.0 "$node_(256) on" 
$node_(257) set X_ 216 
$node_(257) set Y_ 425 
$node_(257) set Z_ 0.0 
$ns at 0.0 "$node_(257) off" 
$ns at 200.0 "$node_(257) on" 
$node_(258) set X_ 2746 
$node_(258) set Y_ 880 
$node_(258) set Z_ 0.0 
$ns at 0.0 "$node_(258) off" 
$ns at 200.0 "$node_(258) on" 
$node_(259) set X_ 2051 
$node_(259) set Y_ 367 
$node_(259) set Z_ 0.0 
$ns at 0.0 "$node_(259) off" 
$ns at 200.0 "$node_(259) on" 
$node_(260) set X_ 1062 
$node_(260) set Y_ 21 
$node_(260) set Z_ 0.0 
$ns at 0.0 "$node_(260) off" 
$ns at 200.0 "$node_(260) on" 
$node_(261) set X_ 1549 
$node_(261) set Y_ 967 
$node_(261) set Z_ 0.0 
$ns at 0.0 "$node_(261) off" 
$ns at 200.0 "$node_(261) on" 
$node_(262) set X_ 525 
$node_(262) set Y_ 328 
$node_(262) set Z_ 0.0 
$ns at 0.0 "$node_(262) off" 
$ns at 200.0 "$node_(262) on" 
$node_(263) set X_ 1513 
$node_(263) set Y_ 585 
$node_(263) set Z_ 0.0 
$ns at 0.0 "$node_(263) off" 
$ns at 200.0 "$node_(263) on" 
$node_(264) set X_ 1681 
$node_(264) set Y_ 26 
$node_(264) set Z_ 0.0 
$ns at 0.0 "$node_(264) off" 
$ns at 200.0 "$node_(264) on" 
$node_(265) set X_ 855 
$node_(265) set Y_ 976 
$node_(265) set Z_ 0.0 
$ns at 0.0 "$node_(265) off" 
$ns at 200.0 "$node_(265) on" 
$node_(266) set X_ 756 
$node_(266) set Y_ 201 
$node_(266) set Z_ 0.0 
$ns at 0.0 "$node_(266) off" 
$ns at 200.0 "$node_(266) on" 
$node_(267) set X_ 1729 
$node_(267) set Y_ 344 
$node_(267) set Z_ 0.0 
$ns at 0.0 "$node_(267) off" 
$ns at 200.0 "$node_(267) on" 
$node_(268) set X_ 2142 
$node_(268) set Y_ 671 
$node_(268) set Z_ 0.0 
$ns at 0.0 "$node_(268) off" 
$ns at 200.0 "$node_(268) on" 
$node_(269) set X_ 1345 
$node_(269) set Y_ 846 
$node_(269) set Z_ 0.0 
$ns at 0.0 "$node_(269) off" 
$ns at 200.0 "$node_(269) on" 
$node_(270) set X_ 337 
$node_(270) set Y_ 885 
$node_(270) set Z_ 0.0 
$ns at 0.0 "$node_(270) off" 
$ns at 200.0 "$node_(270) on" 
$node_(271) set X_ 2615 
$node_(271) set Y_ 982 
$node_(271) set Z_ 0.0 
$ns at 0.0 "$node_(271) off" 
$ns at 200.0 "$node_(271) on" 
$node_(272) set X_ 2897 
$node_(272) set Y_ 259 
$node_(272) set Z_ 0.0 
$ns at 0.0 "$node_(272) off" 
$ns at 200.0 "$node_(272) on" 
$node_(273) set X_ 2967 
$node_(273) set Y_ 894 
$node_(273) set Z_ 0.0 
$ns at 0.0 "$node_(273) off" 
$ns at 200.0 "$node_(273) on" 
$node_(274) set X_ 707 
$node_(274) set Y_ 878 
$node_(274) set Z_ 0.0 
$ns at 0.0 "$node_(274) off" 
$ns at 200.0 "$node_(274) on" 
$node_(275) set X_ 1586 
$node_(275) set Y_ 326 
$node_(275) set Z_ 0.0 
$ns at 0.0 "$node_(275) off" 
$ns at 200.0 "$node_(275) on" 
$node_(276) set X_ 2734 
$node_(276) set Y_ 661 
$node_(276) set Z_ 0.0 
$ns at 0.0 "$node_(276) off" 
$ns at 200.0 "$node_(276) on" 
$node_(277) set X_ 2001 
$node_(277) set Y_ 880 
$node_(277) set Z_ 0.0 
$ns at 0.0 "$node_(277) off" 
$ns at 200.0 "$node_(277) on" 
$node_(278) set X_ 2568 
$node_(278) set Y_ 973 
$node_(278) set Z_ 0.0 
$ns at 0.0 "$node_(278) off" 
$ns at 200.0 "$node_(278) on" 
$node_(279) set X_ 1262 
$node_(279) set Y_ 256 
$node_(279) set Z_ 0.0 
$ns at 0.0 "$node_(279) off" 
$ns at 200.0 "$node_(279) on" 
$node_(280) set X_ 2409 
$node_(280) set Y_ 107 
$node_(280) set Z_ 0.0 
$ns at 0.0 "$node_(280) off" 
$ns at 200.0 "$node_(280) on" 
$node_(281) set X_ 1062 
$node_(281) set Y_ 361 
$node_(281) set Z_ 0.0 
$ns at 0.0 "$node_(281) off" 
$ns at 200.0 "$node_(281) on" 
$node_(282) set X_ 2701 
$node_(282) set Y_ 255 
$node_(282) set Z_ 0.0 
$ns at 0.0 "$node_(282) off" 
$ns at 200.0 "$node_(282) on" 
$node_(283) set X_ 2924 
$node_(283) set Y_ 515 
$node_(283) set Z_ 0.0 
$ns at 0.0 "$node_(283) off" 
$ns at 200.0 "$node_(283) on" 
$node_(284) set X_ 403 
$node_(284) set Y_ 383 
$node_(284) set Z_ 0.0 
$ns at 0.0 "$node_(284) off" 
$ns at 200.0 "$node_(284) on" 
$node_(285) set X_ 2114 
$node_(285) set Y_ 528 
$node_(285) set Z_ 0.0 
$ns at 0.0 "$node_(285) off" 
$ns at 200.0 "$node_(285) on" 
$node_(286) set X_ 893 
$node_(286) set Y_ 878 
$node_(286) set Z_ 0.0 
$ns at 0.0 "$node_(286) off" 
$ns at 200.0 "$node_(286) on" 
$node_(287) set X_ 2164 
$node_(287) set Y_ 46 
$node_(287) set Z_ 0.0 
$ns at 0.0 "$node_(287) off" 
$ns at 200.0 "$node_(287) on" 
$node_(288) set X_ 2709 
$node_(288) set Y_ 991 
$node_(288) set Z_ 0.0 
$ns at 0.0 "$node_(288) off" 
$ns at 200.0 "$node_(288) on" 
$node_(289) set X_ 824 
$node_(289) set Y_ 427 
$node_(289) set Z_ 0.0 
$ns at 0.0 "$node_(289) off" 
$ns at 200.0 "$node_(289) on" 
$node_(290) set X_ 1757 
$node_(290) set Y_ 827 
$node_(290) set Z_ 0.0 
$ns at 0.0 "$node_(290) off" 
$ns at 200.0 "$node_(290) on" 
$node_(291) set X_ 971 
$node_(291) set Y_ 376 
$node_(291) set Z_ 0.0 
$ns at 0.0 "$node_(291) off" 
$ns at 200.0 "$node_(291) on" 
$node_(292) set X_ 314 
$node_(292) set Y_ 126 
$node_(292) set Z_ 0.0 
$ns at 0.0 "$node_(292) off" 
$ns at 200.0 "$node_(292) on" 
$node_(293) set X_ 1355 
$node_(293) set Y_ 695 
$node_(293) set Z_ 0.0 
$ns at 0.0 "$node_(293) off" 
$ns at 200.0 "$node_(293) on" 
$node_(294) set X_ 2966 
$node_(294) set Y_ 122 
$node_(294) set Z_ 0.0 
$ns at 0.0 "$node_(294) off" 
$ns at 200.0 "$node_(294) on" 
$node_(295) set X_ 193 
$node_(295) set Y_ 815 
$node_(295) set Z_ 0.0 
$ns at 0.0 "$node_(295) off" 
$ns at 200.0 "$node_(295) on" 
$node_(296) set X_ 766 
$node_(296) set Y_ 539 
$node_(296) set Z_ 0.0 
$ns at 0.0 "$node_(296) off" 
$ns at 200.0 "$node_(296) on" 
$node_(297) set X_ 2437 
$node_(297) set Y_ 222 
$node_(297) set Z_ 0.0 
$ns at 0.0 "$node_(297) off" 
$ns at 200.0 "$node_(297) on" 
$node_(298) set X_ 1190 
$node_(298) set Y_ 177 
$node_(298) set Z_ 0.0 
$ns at 0.0 "$node_(298) off" 
$ns at 200.0 "$node_(298) on" 
$node_(299) set X_ 105 
$node_(299) set Y_ 484 
$node_(299) set Z_ 0.0 
$ns at 0.0 "$node_(299) off" 
$ns at 200.0 "$node_(299) on" 
$node_(300) set X_ 2979 
$node_(300) set Y_ 617 
$node_(300) set Z_ 0.0 
$ns at 0.0 "$node_(300) off" 
$ns at 300.0 "$node_(300) on" 
$node_(301) set X_ 2297 
$node_(301) set Y_ 371 
$node_(301) set Z_ 0.0 
$ns at 0.0 "$node_(301) off" 
$ns at 300.0 "$node_(301) on" 
$node_(302) set X_ 2753 
$node_(302) set Y_ 254 
$node_(302) set Z_ 0.0 
$ns at 0.0 "$node_(302) off" 
$ns at 300.0 "$node_(302) on" 
$node_(303) set X_ 1544 
$node_(303) set Y_ 451 
$node_(303) set Z_ 0.0 
$ns at 0.0 "$node_(303) off" 
$ns at 300.0 "$node_(303) on" 
$node_(304) set X_ 188 
$node_(304) set Y_ 278 
$node_(304) set Z_ 0.0 
$ns at 0.0 "$node_(304) off" 
$ns at 300.0 "$node_(304) on" 
$node_(305) set X_ 1798 
$node_(305) set Y_ 654 
$node_(305) set Z_ 0.0 
$ns at 0.0 "$node_(305) off" 
$ns at 300.0 "$node_(305) on" 
$node_(306) set X_ 2793 
$node_(306) set Y_ 238 
$node_(306) set Z_ 0.0 
$ns at 0.0 "$node_(306) off" 
$ns at 300.0 "$node_(306) on" 
$node_(307) set X_ 822 
$node_(307) set Y_ 488 
$node_(307) set Z_ 0.0 
$ns at 0.0 "$node_(307) off" 
$ns at 300.0 "$node_(307) on" 
$node_(308) set X_ 692 
$node_(308) set Y_ 487 
$node_(308) set Z_ 0.0 
$ns at 0.0 "$node_(308) off" 
$ns at 300.0 "$node_(308) on" 
$node_(309) set X_ 871 
$node_(309) set Y_ 16 
$node_(309) set Z_ 0.0 
$ns at 0.0 "$node_(309) off" 
$ns at 300.0 "$node_(309) on" 
$node_(310) set X_ 2445 
$node_(310) set Y_ 185 
$node_(310) set Z_ 0.0 
$ns at 0.0 "$node_(310) off" 
$ns at 300.0 "$node_(310) on" 
$node_(311) set X_ 2390 
$node_(311) set Y_ 221 
$node_(311) set Z_ 0.0 
$ns at 0.0 "$node_(311) off" 
$ns at 300.0 "$node_(311) on" 
$node_(312) set X_ 2804 
$node_(312) set Y_ 501 
$node_(312) set Z_ 0.0 
$ns at 0.0 "$node_(312) off" 
$ns at 300.0 "$node_(312) on" 
$node_(313) set X_ 2086 
$node_(313) set Y_ 102 
$node_(313) set Z_ 0.0 
$ns at 0.0 "$node_(313) off" 
$ns at 300.0 "$node_(313) on" 
$node_(314) set X_ 2336 
$node_(314) set Y_ 336 
$node_(314) set Z_ 0.0 
$ns at 0.0 "$node_(314) off" 
$ns at 300.0 "$node_(314) on" 
$node_(315) set X_ 1956 
$node_(315) set Y_ 688 
$node_(315) set Z_ 0.0 
$ns at 0.0 "$node_(315) off" 
$ns at 300.0 "$node_(315) on" 
$node_(316) set X_ 2144 
$node_(316) set Y_ 160 
$node_(316) set Z_ 0.0 
$ns at 0.0 "$node_(316) off" 
$ns at 300.0 "$node_(316) on" 
$node_(317) set X_ 2939 
$node_(317) set Y_ 180 
$node_(317) set Z_ 0.0 
$ns at 0.0 "$node_(317) off" 
$ns at 300.0 "$node_(317) on" 
$node_(318) set X_ 1410 
$node_(318) set Y_ 579 
$node_(318) set Z_ 0.0 
$ns at 0.0 "$node_(318) off" 
$ns at 300.0 "$node_(318) on" 
$node_(319) set X_ 1534 
$node_(319) set Y_ 590 
$node_(319) set Z_ 0.0 
$ns at 0.0 "$node_(319) off" 
$ns at 300.0 "$node_(319) on" 
$node_(320) set X_ 2190 
$node_(320) set Y_ 807 
$node_(320) set Z_ 0.0 
$ns at 0.0 "$node_(320) off" 
$ns at 300.0 "$node_(320) on" 
$node_(321) set X_ 1215 
$node_(321) set Y_ 588 
$node_(321) set Z_ 0.0 
$ns at 0.0 "$node_(321) off" 
$ns at 300.0 "$node_(321) on" 
$node_(322) set X_ 863 
$node_(322) set Y_ 543 
$node_(322) set Z_ 0.0 
$ns at 0.0 "$node_(322) off" 
$ns at 300.0 "$node_(322) on" 
$node_(323) set X_ 1634 
$node_(323) set Y_ 726 
$node_(323) set Z_ 0.0 
$ns at 0.0 "$node_(323) off" 
$ns at 300.0 "$node_(323) on" 
$node_(324) set X_ 2731 
$node_(324) set Y_ 674 
$node_(324) set Z_ 0.0 
$ns at 0.0 "$node_(324) off" 
$ns at 300.0 "$node_(324) on" 
$node_(325) set X_ 2492 
$node_(325) set Y_ 863 
$node_(325) set Z_ 0.0 
$ns at 0.0 "$node_(325) off" 
$ns at 300.0 "$node_(325) on" 
$node_(326) set X_ 1716 
$node_(326) set Y_ 794 
$node_(326) set Z_ 0.0 
$ns at 0.0 "$node_(326) off" 
$ns at 300.0 "$node_(326) on" 
$node_(327) set X_ 554 
$node_(327) set Y_ 412 
$node_(327) set Z_ 0.0 
$ns at 0.0 "$node_(327) off" 
$ns at 300.0 "$node_(327) on" 
$node_(328) set X_ 1626 
$node_(328) set Y_ 817 
$node_(328) set Z_ 0.0 
$ns at 0.0 "$node_(328) off" 
$ns at 300.0 "$node_(328) on" 
$node_(329) set X_ 1650 
$node_(329) set Y_ 949 
$node_(329) set Z_ 0.0 
$ns at 0.0 "$node_(329) off" 
$ns at 300.0 "$node_(329) on" 
$node_(330) set X_ 306 
$node_(330) set Y_ 834 
$node_(330) set Z_ 0.0 
$ns at 0.0 "$node_(330) off" 
$ns at 300.0 "$node_(330) on" 
$node_(331) set X_ 1493 
$node_(331) set Y_ 886 
$node_(331) set Z_ 0.0 
$ns at 0.0 "$node_(331) off" 
$ns at 300.0 "$node_(331) on" 
$node_(332) set X_ 1031 
$node_(332) set Y_ 922 
$node_(332) set Z_ 0.0 
$ns at 0.0 "$node_(332) off" 
$ns at 300.0 "$node_(332) on" 
$node_(333) set X_ 962 
$node_(333) set Y_ 112 
$node_(333) set Z_ 0.0 
$ns at 0.0 "$node_(333) off" 
$ns at 300.0 "$node_(333) on" 
$node_(334) set X_ 1711 
$node_(334) set Y_ 867 
$node_(334) set Z_ 0.0 
$ns at 0.0 "$node_(334) off" 
$ns at 300.0 "$node_(334) on" 
$node_(335) set X_ 1951 
$node_(335) set Y_ 970 
$node_(335) set Z_ 0.0 
$ns at 0.0 "$node_(335) off" 
$ns at 300.0 "$node_(335) on" 
$node_(336) set X_ 979 
$node_(336) set Y_ 575 
$node_(336) set Z_ 0.0 
$ns at 0.0 "$node_(336) off" 
$ns at 300.0 "$node_(336) on" 
$node_(337) set X_ 2099 
$node_(337) set Y_ 486 
$node_(337) set Z_ 0.0 
$ns at 0.0 "$node_(337) off" 
$ns at 300.0 "$node_(337) on" 
$node_(338) set X_ 2905 
$node_(338) set Y_ 533 
$node_(338) set Z_ 0.0 
$ns at 0.0 "$node_(338) off" 
$ns at 300.0 "$node_(338) on" 
$node_(339) set X_ 627 
$node_(339) set Y_ 516 
$node_(339) set Z_ 0.0 
$ns at 0.0 "$node_(339) off" 
$ns at 300.0 "$node_(339) on" 
$node_(340) set X_ 2980 
$node_(340) set Y_ 824 
$node_(340) set Z_ 0.0 
$ns at 0.0 "$node_(340) off" 
$ns at 300.0 "$node_(340) on" 
$node_(341) set X_ 164 
$node_(341) set Y_ 355 
$node_(341) set Z_ 0.0 
$ns at 0.0 "$node_(341) off" 
$ns at 300.0 "$node_(341) on" 
$node_(342) set X_ 153 
$node_(342) set Y_ 63 
$node_(342) set Z_ 0.0 
$ns at 0.0 "$node_(342) off" 
$ns at 300.0 "$node_(342) on" 
$node_(343) set X_ 784 
$node_(343) set Y_ 393 
$node_(343) set Z_ 0.0 
$ns at 0.0 "$node_(343) off" 
$ns at 300.0 "$node_(343) on" 
$node_(344) set X_ 2034 
$node_(344) set Y_ 111 
$node_(344) set Z_ 0.0 
$ns at 0.0 "$node_(344) off" 
$ns at 300.0 "$node_(344) on" 
$node_(345) set X_ 2568 
$node_(345) set Y_ 609 
$node_(345) set Z_ 0.0 
$ns at 0.0 "$node_(345) off" 
$ns at 300.0 "$node_(345) on" 
$node_(346) set X_ 935 
$node_(346) set Y_ 575 
$node_(346) set Z_ 0.0 
$ns at 0.0 "$node_(346) off" 
$ns at 300.0 "$node_(346) on" 
$node_(347) set X_ 1791 
$node_(347) set Y_ 53 
$node_(347) set Z_ 0.0 
$ns at 0.0 "$node_(347) off" 
$ns at 300.0 "$node_(347) on" 
$node_(348) set X_ 220 
$node_(348) set Y_ 917 
$node_(348) set Z_ 0.0 
$ns at 0.0 "$node_(348) off" 
$ns at 300.0 "$node_(348) on" 
$node_(349) set X_ 354 
$node_(349) set Y_ 977 
$node_(349) set Z_ 0.0 
$ns at 0.0 "$node_(349) off" 
$ns at 300.0 "$node_(349) on" 
$node_(350) set X_ 413 
$node_(350) set Y_ 458 
$node_(350) set Z_ 0.0 
$ns at 0.0 "$node_(350) off" 
$ns at 300.0 "$node_(350) on" 
$node_(351) set X_ 1311 
$node_(351) set Y_ 925 
$node_(351) set Z_ 0.0 
$ns at 0.0 "$node_(351) off" 
$ns at 300.0 "$node_(351) on" 
$node_(352) set X_ 746 
$node_(352) set Y_ 687 
$node_(352) set Z_ 0.0 
$ns at 0.0 "$node_(352) off" 
$ns at 300.0 "$node_(352) on" 
$node_(353) set X_ 301 
$node_(353) set Y_ 966 
$node_(353) set Z_ 0.0 
$ns at 0.0 "$node_(353) off" 
$ns at 300.0 "$node_(353) on" 
$node_(354) set X_ 243 
$node_(354) set Y_ 54 
$node_(354) set Z_ 0.0 
$ns at 0.0 "$node_(354) off" 
$ns at 300.0 "$node_(354) on" 
$node_(355) set X_ 1348 
$node_(355) set Y_ 171 
$node_(355) set Z_ 0.0 
$ns at 0.0 "$node_(355) off" 
$ns at 300.0 "$node_(355) on" 
$node_(356) set X_ 2135 
$node_(356) set Y_ 880 
$node_(356) set Z_ 0.0 
$ns at 0.0 "$node_(356) off" 
$ns at 300.0 "$node_(356) on" 
$node_(357) set X_ 1906 
$node_(357) set Y_ 629 
$node_(357) set Z_ 0.0 
$ns at 0.0 "$node_(357) off" 
$ns at 300.0 "$node_(357) on" 
$node_(358) set X_ 1222 
$node_(358) set Y_ 90 
$node_(358) set Z_ 0.0 
$ns at 0.0 "$node_(358) off" 
$ns at 300.0 "$node_(358) on" 
$node_(359) set X_ 118 
$node_(359) set Y_ 566 
$node_(359) set Z_ 0.0 
$ns at 0.0 "$node_(359) off" 
$ns at 300.0 "$node_(359) on" 
$node_(360) set X_ 929 
$node_(360) set Y_ 221 
$node_(360) set Z_ 0.0 
$ns at 0.0 "$node_(360) off" 
$ns at 300.0 "$node_(360) on" 
$node_(361) set X_ 2076 
$node_(361) set Y_ 564 
$node_(361) set Z_ 0.0 
$ns at 0.0 "$node_(361) off" 
$ns at 300.0 "$node_(361) on" 
$node_(362) set X_ 1093 
$node_(362) set Y_ 582 
$node_(362) set Z_ 0.0 
$ns at 0.0 "$node_(362) off" 
$ns at 300.0 "$node_(362) on" 
$node_(363) set X_ 459 
$node_(363) set Y_ 531 
$node_(363) set Z_ 0.0 
$ns at 0.0 "$node_(363) off" 
$ns at 300.0 "$node_(363) on" 
$node_(364) set X_ 73 
$node_(364) set Y_ 480 
$node_(364) set Z_ 0.0 
$ns at 0.0 "$node_(364) off" 
$ns at 300.0 "$node_(364) on" 
$node_(365) set X_ 119 
$node_(365) set Y_ 785 
$node_(365) set Z_ 0.0 
$ns at 0.0 "$node_(365) off" 
$ns at 300.0 "$node_(365) on" 
$node_(366) set X_ 2487 
$node_(366) set Y_ 147 
$node_(366) set Z_ 0.0 
$ns at 0.0 "$node_(366) off" 
$ns at 300.0 "$node_(366) on" 
$node_(367) set X_ 246 
$node_(367) set Y_ 571 
$node_(367) set Z_ 0.0 
$ns at 0.0 "$node_(367) off" 
$ns at 300.0 "$node_(367) on" 
$node_(368) set X_ 2884 
$node_(368) set Y_ 381 
$node_(368) set Z_ 0.0 
$ns at 0.0 "$node_(368) off" 
$ns at 300.0 "$node_(368) on" 
$node_(369) set X_ 383 
$node_(369) set Y_ 373 
$node_(369) set Z_ 0.0 
$ns at 0.0 "$node_(369) off" 
$ns at 300.0 "$node_(369) on" 
$node_(370) set X_ 823 
$node_(370) set Y_ 946 
$node_(370) set Z_ 0.0 
$ns at 0.0 "$node_(370) off" 
$ns at 300.0 "$node_(370) on" 
$node_(371) set X_ 23 
$node_(371) set Y_ 658 
$node_(371) set Z_ 0.0 
$ns at 0.0 "$node_(371) off" 
$ns at 300.0 "$node_(371) on" 
$node_(372) set X_ 247 
$node_(372) set Y_ 442 
$node_(372) set Z_ 0.0 
$ns at 0.0 "$node_(372) off" 
$ns at 300.0 "$node_(372) on" 
$node_(373) set X_ 1630 
$node_(373) set Y_ 24 
$node_(373) set Z_ 0.0 
$ns at 0.0 "$node_(373) off" 
$ns at 300.0 "$node_(373) on" 
$node_(374) set X_ 660 
$node_(374) set Y_ 713 
$node_(374) set Z_ 0.0 
$ns at 0.0 "$node_(374) off" 
$ns at 300.0 "$node_(374) on" 
$node_(375) set X_ 819 
$node_(375) set Y_ 313 
$node_(375) set Z_ 0.0 
$ns at 0.0 "$node_(375) off" 
$ns at 300.0 "$node_(375) on" 
$node_(376) set X_ 1453 
$node_(376) set Y_ 860 
$node_(376) set Z_ 0.0 
$ns at 0.0 "$node_(376) off" 
$ns at 300.0 "$node_(376) on" 
$node_(377) set X_ 1969 
$node_(377) set Y_ 923 
$node_(377) set Z_ 0.0 
$ns at 0.0 "$node_(377) off" 
$ns at 300.0 "$node_(377) on" 
$node_(378) set X_ 1802 
$node_(378) set Y_ 564 
$node_(378) set Z_ 0.0 
$ns at 0.0 "$node_(378) off" 
$ns at 300.0 "$node_(378) on" 
$node_(379) set X_ 1863 
$node_(379) set Y_ 418 
$node_(379) set Z_ 0.0 
$ns at 0.0 "$node_(379) off" 
$ns at 300.0 "$node_(379) on" 
$node_(380) set X_ 821 
$node_(380) set Y_ 748 
$node_(380) set Z_ 0.0 
$ns at 0.0 "$node_(380) off" 
$ns at 300.0 "$node_(380) on" 
$node_(381) set X_ 967 
$node_(381) set Y_ 558 
$node_(381) set Z_ 0.0 
$ns at 0.0 "$node_(381) off" 
$ns at 300.0 "$node_(381) on" 
$node_(382) set X_ 2168 
$node_(382) set Y_ 564 
$node_(382) set Z_ 0.0 
$ns at 0.0 "$node_(382) off" 
$ns at 300.0 "$node_(382) on" 
$node_(383) set X_ 2662 
$node_(383) set Y_ 14 
$node_(383) set Z_ 0.0 
$ns at 0.0 "$node_(383) off" 
$ns at 300.0 "$node_(383) on" 
$node_(384) set X_ 1012 
$node_(384) set Y_ 322 
$node_(384) set Z_ 0.0 
$ns at 0.0 "$node_(384) off" 
$ns at 300.0 "$node_(384) on" 
$node_(385) set X_ 2251 
$node_(385) set Y_ 388 
$node_(385) set Z_ 0.0 
$ns at 0.0 "$node_(385) off" 
$ns at 300.0 "$node_(385) on" 
$node_(386) set X_ 2208 
$node_(386) set Y_ 241 
$node_(386) set Z_ 0.0 
$ns at 0.0 "$node_(386) off" 
$ns at 300.0 "$node_(386) on" 
$node_(387) set X_ 2657 
$node_(387) set Y_ 619 
$node_(387) set Z_ 0.0 
$ns at 0.0 "$node_(387) off" 
$ns at 300.0 "$node_(387) on" 
$node_(388) set X_ 1683 
$node_(388) set Y_ 861 
$node_(388) set Z_ 0.0 
$ns at 0.0 "$node_(388) off" 
$ns at 300.0 "$node_(388) on" 
$node_(389) set X_ 2706 
$node_(389) set Y_ 501 
$node_(389) set Z_ 0.0 
$ns at 0.0 "$node_(389) off" 
$ns at 300.0 "$node_(389) on" 
$node_(390) set X_ 2402 
$node_(390) set Y_ 513 
$node_(390) set Z_ 0.0 
$ns at 0.0 "$node_(390) off" 
$ns at 300.0 "$node_(390) on" 
$node_(391) set X_ 1418 
$node_(391) set Y_ 830 
$node_(391) set Z_ 0.0 
$ns at 0.0 "$node_(391) off" 
$ns at 300.0 "$node_(391) on" 
$node_(392) set X_ 893 
$node_(392) set Y_ 527 
$node_(392) set Z_ 0.0 
$ns at 0.0 "$node_(392) off" 
$ns at 300.0 "$node_(392) on" 
$node_(393) set X_ 106 
$node_(393) set Y_ 658 
$node_(393) set Z_ 0.0 
$ns at 0.0 "$node_(393) off" 
$ns at 300.0 "$node_(393) on" 
$node_(394) set X_ 1102 
$node_(394) set Y_ 732 
$node_(394) set Z_ 0.0 
$ns at 0.0 "$node_(394) off" 
$ns at 300.0 "$node_(394) on" 
$node_(395) set X_ 109 
$node_(395) set Y_ 218 
$node_(395) set Z_ 0.0 
$ns at 0.0 "$node_(395) off" 
$ns at 300.0 "$node_(395) on" 
$node_(396) set X_ 395 
$node_(396) set Y_ 376 
$node_(396) set Z_ 0.0 
$ns at 0.0 "$node_(396) off" 
$ns at 300.0 "$node_(396) on" 
$node_(397) set X_ 761 
$node_(397) set Y_ 370 
$node_(397) set Z_ 0.0 
$ns at 0.0 "$node_(397) off" 
$ns at 300.0 "$node_(397) on" 
$node_(398) set X_ 761 
$node_(398) set Y_ 806 
$node_(398) set Z_ 0.0 
$ns at 0.0 "$node_(398) off" 
$ns at 300.0 "$node_(398) on" 
$node_(399) set X_ 2659 
$node_(399) set Y_ 810 
$node_(399) set Z_ 0.0 
$ns at 0.0 "$node_(399) off" 
$ns at 300.0 "$node_(399) on" 
$node_(400) set X_ 744 
$node_(400) set Y_ 134 
$node_(400) set Z_ 0.0 
$ns at 0.0 "$node_(400) off" 
$ns at 400.0 "$node_(400) on" 
$node_(401) set X_ 531 
$node_(401) set Y_ 898 
$node_(401) set Z_ 0.0 
$ns at 0.0 "$node_(401) off" 
$ns at 400.0 "$node_(401) on" 
$node_(402) set X_ 1318 
$node_(402) set Y_ 599 
$node_(402) set Z_ 0.0 
$ns at 0.0 "$node_(402) off" 
$ns at 400.0 "$node_(402) on" 
$node_(403) set X_ 882 
$node_(403) set Y_ 645 
$node_(403) set Z_ 0.0 
$ns at 0.0 "$node_(403) off" 
$ns at 400.0 "$node_(403) on" 
$node_(404) set X_ 2835 
$node_(404) set Y_ 591 
$node_(404) set Z_ 0.0 
$ns at 0.0 "$node_(404) off" 
$ns at 400.0 "$node_(404) on" 
$node_(405) set X_ 287 
$node_(405) set Y_ 326 
$node_(405) set Z_ 0.0 
$ns at 0.0 "$node_(405) off" 
$ns at 400.0 "$node_(405) on" 
$node_(406) set X_ 2262 
$node_(406) set Y_ 72 
$node_(406) set Z_ 0.0 
$ns at 0.0 "$node_(406) off" 
$ns at 400.0 "$node_(406) on" 
$node_(407) set X_ 497 
$node_(407) set Y_ 209 
$node_(407) set Z_ 0.0 
$ns at 0.0 "$node_(407) off" 
$ns at 400.0 "$node_(407) on" 
$node_(408) set X_ 321 
$node_(408) set Y_ 670 
$node_(408) set Z_ 0.0 
$ns at 0.0 "$node_(408) off" 
$ns at 400.0 "$node_(408) on" 
$node_(409) set X_ 667 
$node_(409) set Y_ 96 
$node_(409) set Z_ 0.0 
$ns at 0.0 "$node_(409) off" 
$ns at 400.0 "$node_(409) on" 
$node_(410) set X_ 2664 
$node_(410) set Y_ 870 
$node_(410) set Z_ 0.0 
$ns at 0.0 "$node_(410) off" 
$ns at 400.0 "$node_(410) on" 
$node_(411) set X_ 1760 
$node_(411) set Y_ 736 
$node_(411) set Z_ 0.0 
$ns at 0.0 "$node_(411) off" 
$ns at 400.0 "$node_(411) on" 
$node_(412) set X_ 2014 
$node_(412) set Y_ 515 
$node_(412) set Z_ 0.0 
$ns at 0.0 "$node_(412) off" 
$ns at 400.0 "$node_(412) on" 
$node_(413) set X_ 2710 
$node_(413) set Y_ 656 
$node_(413) set Z_ 0.0 
$ns at 0.0 "$node_(413) off" 
$ns at 400.0 "$node_(413) on" 
$node_(414) set X_ 1197 
$node_(414) set Y_ 316 
$node_(414) set Z_ 0.0 
$ns at 0.0 "$node_(414) off" 
$ns at 400.0 "$node_(414) on" 
$node_(415) set X_ 2186 
$node_(415) set Y_ 671 
$node_(415) set Z_ 0.0 
$ns at 0.0 "$node_(415) off" 
$ns at 400.0 "$node_(415) on" 
$node_(416) set X_ 1212 
$node_(416) set Y_ 188 
$node_(416) set Z_ 0.0 
$ns at 0.0 "$node_(416) off" 
$ns at 400.0 "$node_(416) on" 
$node_(417) set X_ 2708 
$node_(417) set Y_ 105 
$node_(417) set Z_ 0.0 
$ns at 0.0 "$node_(417) off" 
$ns at 400.0 "$node_(417) on" 
$node_(418) set X_ 1920 
$node_(418) set Y_ 4 
$node_(418) set Z_ 0.0 
$ns at 0.0 "$node_(418) off" 
$ns at 400.0 "$node_(418) on" 
$node_(419) set X_ 2564 
$node_(419) set Y_ 789 
$node_(419) set Z_ 0.0 
$ns at 0.0 "$node_(419) off" 
$ns at 400.0 "$node_(419) on" 
$node_(420) set X_ 1582 
$node_(420) set Y_ 788 
$node_(420) set Z_ 0.0 
$ns at 0.0 "$node_(420) off" 
$ns at 400.0 "$node_(420) on" 
$node_(421) set X_ 375 
$node_(421) set Y_ 992 
$node_(421) set Z_ 0.0 
$ns at 0.0 "$node_(421) off" 
$ns at 400.0 "$node_(421) on" 
$node_(422) set X_ 2361 
$node_(422) set Y_ 474 
$node_(422) set Z_ 0.0 
$ns at 0.0 "$node_(422) off" 
$ns at 400.0 "$node_(422) on" 
$node_(423) set X_ 1228 
$node_(423) set Y_ 771 
$node_(423) set Z_ 0.0 
$ns at 0.0 "$node_(423) off" 
$ns at 400.0 "$node_(423) on" 
$node_(424) set X_ 2999 
$node_(424) set Y_ 91 
$node_(424) set Z_ 0.0 
$ns at 0.0 "$node_(424) off" 
$ns at 400.0 "$node_(424) on" 
$node_(425) set X_ 1162 
$node_(425) set Y_ 659 
$node_(425) set Z_ 0.0 
$ns at 0.0 "$node_(425) off" 
$ns at 400.0 "$node_(425) on" 
$node_(426) set X_ 1161 
$node_(426) set Y_ 648 
$node_(426) set Z_ 0.0 
$ns at 0.0 "$node_(426) off" 
$ns at 400.0 "$node_(426) on" 
$node_(427) set X_ 1316 
$node_(427) set Y_ 221 
$node_(427) set Z_ 0.0 
$ns at 0.0 "$node_(427) off" 
$ns at 400.0 "$node_(427) on" 
$node_(428) set X_ 1516 
$node_(428) set Y_ 37 
$node_(428) set Z_ 0.0 
$ns at 0.0 "$node_(428) off" 
$ns at 400.0 "$node_(428) on" 
$node_(429) set X_ 314 
$node_(429) set Y_ 765 
$node_(429) set Z_ 0.0 
$ns at 0.0 "$node_(429) off" 
$ns at 400.0 "$node_(429) on" 
$node_(430) set X_ 331 
$node_(430) set Y_ 9 
$node_(430) set Z_ 0.0 
$ns at 0.0 "$node_(430) off" 
$ns at 400.0 "$node_(430) on" 
$node_(431) set X_ 2461 
$node_(431) set Y_ 424 
$node_(431) set Z_ 0.0 
$ns at 0.0 "$node_(431) off" 
$ns at 400.0 "$node_(431) on" 
$node_(432) set X_ 1343 
$node_(432) set Y_ 638 
$node_(432) set Z_ 0.0 
$ns at 0.0 "$node_(432) off" 
$ns at 400.0 "$node_(432) on" 
$node_(433) set X_ 4 
$node_(433) set Y_ 895 
$node_(433) set Z_ 0.0 
$ns at 0.0 "$node_(433) off" 
$ns at 400.0 "$node_(433) on" 
$node_(434) set X_ 1871 
$node_(434) set Y_ 706 
$node_(434) set Z_ 0.0 
$ns at 0.0 "$node_(434) off" 
$ns at 400.0 "$node_(434) on" 
$node_(435) set X_ 145 
$node_(435) set Y_ 346 
$node_(435) set Z_ 0.0 
$ns at 0.0 "$node_(435) off" 
$ns at 400.0 "$node_(435) on" 
$node_(436) set X_ 1495 
$node_(436) set Y_ 155 
$node_(436) set Z_ 0.0 
$ns at 0.0 "$node_(436) off" 
$ns at 400.0 "$node_(436) on" 
$node_(437) set X_ 640 
$node_(437) set Y_ 400 
$node_(437) set Z_ 0.0 
$ns at 0.0 "$node_(437) off" 
$ns at 400.0 "$node_(437) on" 
$node_(438) set X_ 2305 
$node_(438) set Y_ 64 
$node_(438) set Z_ 0.0 
$ns at 0.0 "$node_(438) off" 
$ns at 400.0 "$node_(438) on" 
$node_(439) set X_ 1663 
$node_(439) set Y_ 652 
$node_(439) set Z_ 0.0 
$ns at 0.0 "$node_(439) off" 
$ns at 400.0 "$node_(439) on" 
$node_(440) set X_ 1521 
$node_(440) set Y_ 616 
$node_(440) set Z_ 0.0 
$ns at 0.0 "$node_(440) off" 
$ns at 400.0 "$node_(440) on" 
$node_(441) set X_ 1183 
$node_(441) set Y_ 849 
$node_(441) set Z_ 0.0 
$ns at 0.0 "$node_(441) off" 
$ns at 400.0 "$node_(441) on" 
$node_(442) set X_ 1382 
$node_(442) set Y_ 194 
$node_(442) set Z_ 0.0 
$ns at 0.0 "$node_(442) off" 
$ns at 400.0 "$node_(442) on" 
$node_(443) set X_ 2439 
$node_(443) set Y_ 763 
$node_(443) set Z_ 0.0 
$ns at 0.0 "$node_(443) off" 
$ns at 400.0 "$node_(443) on" 
$node_(444) set X_ 2450 
$node_(444) set Y_ 4 
$node_(444) set Z_ 0.0 
$ns at 0.0 "$node_(444) off" 
$ns at 400.0 "$node_(444) on" 
$node_(445) set X_ 2058 
$node_(445) set Y_ 754 
$node_(445) set Z_ 0.0 
$ns at 0.0 "$node_(445) off" 
$ns at 400.0 "$node_(445) on" 
$node_(446) set X_ 1 
$node_(446) set Y_ 659 
$node_(446) set Z_ 0.0 
$ns at 0.0 "$node_(446) off" 
$ns at 400.0 "$node_(446) on" 
$node_(447) set X_ 2130 
$node_(447) set Y_ 219 
$node_(447) set Z_ 0.0 
$ns at 0.0 "$node_(447) off" 
$ns at 400.0 "$node_(447) on" 
$node_(448) set X_ 875 
$node_(448) set Y_ 705 
$node_(448) set Z_ 0.0 
$ns at 0.0 "$node_(448) off" 
$ns at 400.0 "$node_(448) on" 
$node_(449) set X_ 2011 
$node_(449) set Y_ 449 
$node_(449) set Z_ 0.0 
$ns at 0.0 "$node_(449) off" 
$ns at 400.0 "$node_(449) on" 
$node_(450) set X_ 2108 
$node_(450) set Y_ 412 
$node_(450) set Z_ 0.0 
$ns at 0.0 "$node_(450) off" 
$ns at 400.0 "$node_(450) on" 
$node_(451) set X_ 2749 
$node_(451) set Y_ 864 
$node_(451) set Z_ 0.0 
$ns at 0.0 "$node_(451) off" 
$ns at 400.0 "$node_(451) on" 
$node_(452) set X_ 1806 
$node_(452) set Y_ 46 
$node_(452) set Z_ 0.0 
$ns at 0.0 "$node_(452) off" 
$ns at 400.0 "$node_(452) on" 
$node_(453) set X_ 1994 
$node_(453) set Y_ 281 
$node_(453) set Z_ 0.0 
$ns at 0.0 "$node_(453) off" 
$ns at 400.0 "$node_(453) on" 
$node_(454) set X_ 114 
$node_(454) set Y_ 450 
$node_(454) set Z_ 0.0 
$ns at 0.0 "$node_(454) off" 
$ns at 400.0 "$node_(454) on" 
$node_(455) set X_ 771 
$node_(455) set Y_ 630 
$node_(455) set Z_ 0.0 
$ns at 0.0 "$node_(455) off" 
$ns at 400.0 "$node_(455) on" 
$node_(456) set X_ 1714 
$node_(456) set Y_ 999 
$node_(456) set Z_ 0.0 
$ns at 0.0 "$node_(456) off" 
$ns at 400.0 "$node_(456) on" 
$node_(457) set X_ 2916 
$node_(457) set Y_ 491 
$node_(457) set Z_ 0.0 
$ns at 0.0 "$node_(457) off" 
$ns at 400.0 "$node_(457) on" 
$node_(458) set X_ 2098 
$node_(458) set Y_ 905 
$node_(458) set Z_ 0.0 
$ns at 0.0 "$node_(458) off" 
$ns at 400.0 "$node_(458) on" 
$node_(459) set X_ 930 
$node_(459) set Y_ 941 
$node_(459) set Z_ 0.0 
$ns at 0.0 "$node_(459) off" 
$ns at 400.0 "$node_(459) on" 
$node_(460) set X_ 1904 
$node_(460) set Y_ 396 
$node_(460) set Z_ 0.0 
$ns at 0.0 "$node_(460) off" 
$ns at 400.0 "$node_(460) on" 
$node_(461) set X_ 2855 
$node_(461) set Y_ 447 
$node_(461) set Z_ 0.0 
$ns at 0.0 "$node_(461) off" 
$ns at 400.0 "$node_(461) on" 
$node_(462) set X_ 830 
$node_(462) set Y_ 524 
$node_(462) set Z_ 0.0 
$ns at 0.0 "$node_(462) off" 
$ns at 400.0 "$node_(462) on" 
$node_(463) set X_ 2182 
$node_(463) set Y_ 987 
$node_(463) set Z_ 0.0 
$ns at 0.0 "$node_(463) off" 
$ns at 400.0 "$node_(463) on" 
$node_(464) set X_ 2133 
$node_(464) set Y_ 218 
$node_(464) set Z_ 0.0 
$ns at 0.0 "$node_(464) off" 
$ns at 400.0 "$node_(464) on" 
$node_(465) set X_ 71 
$node_(465) set Y_ 109 
$node_(465) set Z_ 0.0 
$ns at 0.0 "$node_(465) off" 
$ns at 400.0 "$node_(465) on" 
$node_(466) set X_ 1390 
$node_(466) set Y_ 731 
$node_(466) set Z_ 0.0 
$ns at 0.0 "$node_(466) off" 
$ns at 400.0 "$node_(466) on" 
$node_(467) set X_ 35 
$node_(467) set Y_ 422 
$node_(467) set Z_ 0.0 
$ns at 0.0 "$node_(467) off" 
$ns at 400.0 "$node_(467) on" 
$node_(468) set X_ 108 
$node_(468) set Y_ 809 
$node_(468) set Z_ 0.0 
$ns at 0.0 "$node_(468) off" 
$ns at 400.0 "$node_(468) on" 
$node_(469) set X_ 2902 
$node_(469) set Y_ 877 
$node_(469) set Z_ 0.0 
$ns at 0.0 "$node_(469) off" 
$ns at 400.0 "$node_(469) on" 
$node_(470) set X_ 2902 
$node_(470) set Y_ 759 
$node_(470) set Z_ 0.0 
$ns at 0.0 "$node_(470) off" 
$ns at 400.0 "$node_(470) on" 
$node_(471) set X_ 2227 
$node_(471) set Y_ 216 
$node_(471) set Z_ 0.0 
$ns at 0.0 "$node_(471) off" 
$ns at 400.0 "$node_(471) on" 
$node_(472) set X_ 2282 
$node_(472) set Y_ 86 
$node_(472) set Z_ 0.0 
$ns at 0.0 "$node_(472) off" 
$ns at 400.0 "$node_(472) on" 
$node_(473) set X_ 393 
$node_(473) set Y_ 223 
$node_(473) set Z_ 0.0 
$ns at 0.0 "$node_(473) off" 
$ns at 400.0 "$node_(473) on" 
$node_(474) set X_ 1678 
$node_(474) set Y_ 523 
$node_(474) set Z_ 0.0 
$ns at 0.0 "$node_(474) off" 
$ns at 400.0 "$node_(474) on" 
$node_(475) set X_ 1452 
$node_(475) set Y_ 712 
$node_(475) set Z_ 0.0 
$ns at 0.0 "$node_(475) off" 
$ns at 400.0 "$node_(475) on" 
$node_(476) set X_ 1093 
$node_(476) set Y_ 81 
$node_(476) set Z_ 0.0 
$ns at 0.0 "$node_(476) off" 
$ns at 400.0 "$node_(476) on" 
$node_(477) set X_ 1244 
$node_(477) set Y_ 736 
$node_(477) set Z_ 0.0 
$ns at 0.0 "$node_(477) off" 
$ns at 400.0 "$node_(477) on" 
$node_(478) set X_ 2780 
$node_(478) set Y_ 225 
$node_(478) set Z_ 0.0 
$ns at 0.0 "$node_(478) off" 
$ns at 400.0 "$node_(478) on" 
$node_(479) set X_ 2610 
$node_(479) set Y_ 148 
$node_(479) set Z_ 0.0 
$ns at 0.0 "$node_(479) off" 
$ns at 400.0 "$node_(479) on" 
$node_(480) set X_ 552 
$node_(480) set Y_ 393 
$node_(480) set Z_ 0.0 
$ns at 0.0 "$node_(480) off" 
$ns at 400.0 "$node_(480) on" 
$node_(481) set X_ 411 
$node_(481) set Y_ 490 
$node_(481) set Z_ 0.0 
$ns at 0.0 "$node_(481) off" 
$ns at 400.0 "$node_(481) on" 
$node_(482) set X_ 788 
$node_(482) set Y_ 863 
$node_(482) set Z_ 0.0 
$ns at 0.0 "$node_(482) off" 
$ns at 400.0 "$node_(482) on" 
$node_(483) set X_ 1789 
$node_(483) set Y_ 148 
$node_(483) set Z_ 0.0 
$ns at 0.0 "$node_(483) off" 
$ns at 400.0 "$node_(483) on" 
$node_(484) set X_ 1821 
$node_(484) set Y_ 389 
$node_(484) set Z_ 0.0 
$ns at 0.0 "$node_(484) off" 
$ns at 400.0 "$node_(484) on" 
$node_(485) set X_ 460 
$node_(485) set Y_ 864 
$node_(485) set Z_ 0.0 
$ns at 0.0 "$node_(485) off" 
$ns at 400.0 "$node_(485) on" 
$node_(486) set X_ 2303 
$node_(486) set Y_ 141 
$node_(486) set Z_ 0.0 
$ns at 0.0 "$node_(486) off" 
$ns at 400.0 "$node_(486) on" 
$node_(487) set X_ 947 
$node_(487) set Y_ 977 
$node_(487) set Z_ 0.0 
$ns at 0.0 "$node_(487) off" 
$ns at 400.0 "$node_(487) on" 
$node_(488) set X_ 2207 
$node_(488) set Y_ 226 
$node_(488) set Z_ 0.0 
$ns at 0.0 "$node_(488) off" 
$ns at 400.0 "$node_(488) on" 
$node_(489) set X_ 2505 
$node_(489) set Y_ 230 
$node_(489) set Z_ 0.0 
$ns at 0.0 "$node_(489) off" 
$ns at 400.0 "$node_(489) on" 
$node_(490) set X_ 1457 
$node_(490) set Y_ 445 
$node_(490) set Z_ 0.0 
$ns at 0.0 "$node_(490) off" 
$ns at 400.0 "$node_(490) on" 
$node_(491) set X_ 2005 
$node_(491) set Y_ 566 
$node_(491) set Z_ 0.0 
$ns at 0.0 "$node_(491) off" 
$ns at 400.0 "$node_(491) on" 
$node_(492) set X_ 1695 
$node_(492) set Y_ 42 
$node_(492) set Z_ 0.0 
$ns at 0.0 "$node_(492) off" 
$ns at 400.0 "$node_(492) on" 
$node_(493) set X_ 2331 
$node_(493) set Y_ 128 
$node_(493) set Z_ 0.0 
$ns at 0.0 "$node_(493) off" 
$ns at 400.0 "$node_(493) on" 
$node_(494) set X_ 452 
$node_(494) set Y_ 880 
$node_(494) set Z_ 0.0 
$ns at 0.0 "$node_(494) off" 
$ns at 400.0 "$node_(494) on" 
$node_(495) set X_ 2827 
$node_(495) set Y_ 567 
$node_(495) set Z_ 0.0 
$ns at 0.0 "$node_(495) off" 
$ns at 400.0 "$node_(495) on" 
$node_(496) set X_ 2946 
$node_(496) set Y_ 877 
$node_(496) set Z_ 0.0 
$ns at 0.0 "$node_(496) off" 
$ns at 400.0 "$node_(496) on" 
$node_(497) set X_ 1022 
$node_(497) set Y_ 847 
$node_(497) set Z_ 0.0 
$ns at 0.0 "$node_(497) off" 
$ns at 400.0 "$node_(497) on" 
$node_(498) set X_ 2928 
$node_(498) set Y_ 545 
$node_(498) set Z_ 0.0 
$ns at 0.0 "$node_(498) off" 
$ns at 400.0 "$node_(498) on" 
$node_(499) set X_ 284 
$node_(499) set Y_ 987 
$node_(499) set Z_ 0.0 
$ns at 0.0 "$node_(499) off" 
$ns at 400.0 "$node_(499) on" 
$node_(500) set X_ 401 
$node_(500) set Y_ 174 
$node_(500) set Z_ 0.0 
$ns at 0.0 "$node_(500) off" 
$ns at 500.0 "$node_(500) on" 
$node_(501) set X_ 1208 
$node_(501) set Y_ 533 
$node_(501) set Z_ 0.0 
$ns at 0.0 "$node_(501) off" 
$ns at 500.0 "$node_(501) on" 
$node_(502) set X_ 1653 
$node_(502) set Y_ 526 
$node_(502) set Z_ 0.0 
$ns at 0.0 "$node_(502) off" 
$ns at 500.0 "$node_(502) on" 
$node_(503) set X_ 380 
$node_(503) set Y_ 130 
$node_(503) set Z_ 0.0 
$ns at 0.0 "$node_(503) off" 
$ns at 500.0 "$node_(503) on" 
$node_(504) set X_ 2894 
$node_(504) set Y_ 932 
$node_(504) set Z_ 0.0 
$ns at 0.0 "$node_(504) off" 
$ns at 500.0 "$node_(504) on" 
$node_(505) set X_ 2753 
$node_(505) set Y_ 239 
$node_(505) set Z_ 0.0 
$ns at 0.0 "$node_(505) off" 
$ns at 500.0 "$node_(505) on" 
$node_(506) set X_ 849 
$node_(506) set Y_ 293 
$node_(506) set Z_ 0.0 
$ns at 0.0 "$node_(506) off" 
$ns at 500.0 "$node_(506) on" 
$node_(507) set X_ 157 
$node_(507) set Y_ 911 
$node_(507) set Z_ 0.0 
$ns at 0.0 "$node_(507) off" 
$ns at 500.0 "$node_(507) on" 
$node_(508) set X_ 2932 
$node_(508) set Y_ 848 
$node_(508) set Z_ 0.0 
$ns at 0.0 "$node_(508) off" 
$ns at 500.0 "$node_(508) on" 
$node_(509) set X_ 484 
$node_(509) set Y_ 552 
$node_(509) set Z_ 0.0 
$ns at 0.0 "$node_(509) off" 
$ns at 500.0 "$node_(509) on" 
$node_(510) set X_ 147 
$node_(510) set Y_ 481 
$node_(510) set Z_ 0.0 
$ns at 0.0 "$node_(510) off" 
$ns at 500.0 "$node_(510) on" 
$node_(511) set X_ 2828 
$node_(511) set Y_ 766 
$node_(511) set Z_ 0.0 
$ns at 0.0 "$node_(511) off" 
$ns at 500.0 "$node_(511) on" 
$node_(512) set X_ 1535 
$node_(512) set Y_ 27 
$node_(512) set Z_ 0.0 
$ns at 0.0 "$node_(512) off" 
$ns at 500.0 "$node_(512) on" 
$node_(513) set X_ 2292 
$node_(513) set Y_ 689 
$node_(513) set Z_ 0.0 
$ns at 0.0 "$node_(513) off" 
$ns at 500.0 "$node_(513) on" 
$node_(514) set X_ 2981 
$node_(514) set Y_ 240 
$node_(514) set Z_ 0.0 
$ns at 0.0 "$node_(514) off" 
$ns at 500.0 "$node_(514) on" 
$node_(515) set X_ 2373 
$node_(515) set Y_ 725 
$node_(515) set Z_ 0.0 
$ns at 0.0 "$node_(515) off" 
$ns at 500.0 "$node_(515) on" 
$node_(516) set X_ 298 
$node_(516) set Y_ 95 
$node_(516) set Z_ 0.0 
$ns at 0.0 "$node_(516) off" 
$ns at 500.0 "$node_(516) on" 
$node_(517) set X_ 2703 
$node_(517) set Y_ 213 
$node_(517) set Z_ 0.0 
$ns at 0.0 "$node_(517) off" 
$ns at 500.0 "$node_(517) on" 
$node_(518) set X_ 1916 
$node_(518) set Y_ 626 
$node_(518) set Z_ 0.0 
$ns at 0.0 "$node_(518) off" 
$ns at 500.0 "$node_(518) on" 
$node_(519) set X_ 544 
$node_(519) set Y_ 367 
$node_(519) set Z_ 0.0 
$ns at 0.0 "$node_(519) off" 
$ns at 500.0 "$node_(519) on" 
$node_(520) set X_ 2070 
$node_(520) set Y_ 791 
$node_(520) set Z_ 0.0 
$ns at 0.0 "$node_(520) off" 
$ns at 500.0 "$node_(520) on" 
$node_(521) set X_ 757 
$node_(521) set Y_ 756 
$node_(521) set Z_ 0.0 
$ns at 0.0 "$node_(521) off" 
$ns at 500.0 "$node_(521) on" 
$node_(522) set X_ 2216 
$node_(522) set Y_ 733 
$node_(522) set Z_ 0.0 
$ns at 0.0 "$node_(522) off" 
$ns at 500.0 "$node_(522) on" 
$node_(523) set X_ 12 
$node_(523) set Y_ 726 
$node_(523) set Z_ 0.0 
$ns at 0.0 "$node_(523) off" 
$ns at 500.0 "$node_(523) on" 
$node_(524) set X_ 2411 
$node_(524) set Y_ 378 
$node_(524) set Z_ 0.0 
$ns at 0.0 "$node_(524) off" 
$ns at 500.0 "$node_(524) on" 
$node_(525) set X_ 1778 
$node_(525) set Y_ 407 
$node_(525) set Z_ 0.0 
$ns at 0.0 "$node_(525) off" 
$ns at 500.0 "$node_(525) on" 
$node_(526) set X_ 1663 
$node_(526) set Y_ 526 
$node_(526) set Z_ 0.0 
$ns at 0.0 "$node_(526) off" 
$ns at 500.0 "$node_(526) on" 
$node_(527) set X_ 2101 
$node_(527) set Y_ 380 
$node_(527) set Z_ 0.0 
$ns at 0.0 "$node_(527) off" 
$ns at 500.0 "$node_(527) on" 
$node_(528) set X_ 2715 
$node_(528) set Y_ 452 
$node_(528) set Z_ 0.0 
$ns at 0.0 "$node_(528) off" 
$ns at 500.0 "$node_(528) on" 
$node_(529) set X_ 388 
$node_(529) set Y_ 641 
$node_(529) set Z_ 0.0 
$ns at 0.0 "$node_(529) off" 
$ns at 500.0 "$node_(529) on" 
$node_(530) set X_ 1404 
$node_(530) set Y_ 582 
$node_(530) set Z_ 0.0 
$ns at 0.0 "$node_(530) off" 
$ns at 500.0 "$node_(530) on" 
$node_(531) set X_ 2345 
$node_(531) set Y_ 258 
$node_(531) set Z_ 0.0 
$ns at 0.0 "$node_(531) off" 
$ns at 500.0 "$node_(531) on" 
$node_(532) set X_ 1668 
$node_(532) set Y_ 975 
$node_(532) set Z_ 0.0 
$ns at 0.0 "$node_(532) off" 
$ns at 500.0 "$node_(532) on" 
$node_(533) set X_ 2838 
$node_(533) set Y_ 949 
$node_(533) set Z_ 0.0 
$ns at 0.0 "$node_(533) off" 
$ns at 500.0 "$node_(533) on" 
$node_(534) set X_ 363 
$node_(534) set Y_ 193 
$node_(534) set Z_ 0.0 
$ns at 0.0 "$node_(534) off" 
$ns at 500.0 "$node_(534) on" 
$node_(535) set X_ 1815 
$node_(535) set Y_ 940 
$node_(535) set Z_ 0.0 
$ns at 0.0 "$node_(535) off" 
$ns at 500.0 "$node_(535) on" 
$node_(536) set X_ 430 
$node_(536) set Y_ 628 
$node_(536) set Z_ 0.0 
$ns at 0.0 "$node_(536) off" 
$ns at 500.0 "$node_(536) on" 
$node_(537) set X_ 513 
$node_(537) set Y_ 555 
$node_(537) set Z_ 0.0 
$ns at 0.0 "$node_(537) off" 
$ns at 500.0 "$node_(537) on" 
$node_(538) set X_ 1485 
$node_(538) set Y_ 539 
$node_(538) set Z_ 0.0 
$ns at 0.0 "$node_(538) off" 
$ns at 500.0 "$node_(538) on" 
$node_(539) set X_ 1942 
$node_(539) set Y_ 455 
$node_(539) set Z_ 0.0 
$ns at 0.0 "$node_(539) off" 
$ns at 500.0 "$node_(539) on" 
$node_(540) set X_ 703 
$node_(540) set Y_ 798 
$node_(540) set Z_ 0.0 
$ns at 0.0 "$node_(540) off" 
$ns at 500.0 "$node_(540) on" 
$node_(541) set X_ 2189 
$node_(541) set Y_ 867 
$node_(541) set Z_ 0.0 
$ns at 0.0 "$node_(541) off" 
$ns at 500.0 "$node_(541) on" 
$node_(542) set X_ 1853 
$node_(542) set Y_ 895 
$node_(542) set Z_ 0.0 
$ns at 0.0 "$node_(542) off" 
$ns at 500.0 "$node_(542) on" 
$node_(543) set X_ 2292 
$node_(543) set Y_ 861 
$node_(543) set Z_ 0.0 
$ns at 0.0 "$node_(543) off" 
$ns at 500.0 "$node_(543) on" 
$node_(544) set X_ 2580 
$node_(544) set Y_ 794 
$node_(544) set Z_ 0.0 
$ns at 0.0 "$node_(544) off" 
$ns at 500.0 "$node_(544) on" 
$node_(545) set X_ 2387 
$node_(545) set Y_ 560 
$node_(545) set Z_ 0.0 
$ns at 0.0 "$node_(545) off" 
$ns at 500.0 "$node_(545) on" 
$node_(546) set X_ 2434 
$node_(546) set Y_ 66 
$node_(546) set Z_ 0.0 
$ns at 0.0 "$node_(546) off" 
$ns at 500.0 "$node_(546) on" 
$node_(547) set X_ 523 
$node_(547) set Y_ 112 
$node_(547) set Z_ 0.0 
$ns at 0.0 "$node_(547) off" 
$ns at 500.0 "$node_(547) on" 
$node_(548) set X_ 833 
$node_(548) set Y_ 126 
$node_(548) set Z_ 0.0 
$ns at 0.0 "$node_(548) off" 
$ns at 500.0 "$node_(548) on" 
$node_(549) set X_ 908 
$node_(549) set Y_ 431 
$node_(549) set Z_ 0.0 
$ns at 0.0 "$node_(549) off" 
$ns at 500.0 "$node_(549) on" 
$node_(550) set X_ 2003 
$node_(550) set Y_ 519 
$node_(550) set Z_ 0.0 
$ns at 0.0 "$node_(550) off" 
$ns at 500.0 "$node_(550) on" 
$node_(551) set X_ 464 
$node_(551) set Y_ 995 
$node_(551) set Z_ 0.0 
$ns at 0.0 "$node_(551) off" 
$ns at 500.0 "$node_(551) on" 
$node_(552) set X_ 35 
$node_(552) set Y_ 915 
$node_(552) set Z_ 0.0 
$ns at 0.0 "$node_(552) off" 
$ns at 500.0 "$node_(552) on" 
$node_(553) set X_ 400 
$node_(553) set Y_ 416 
$node_(553) set Z_ 0.0 
$ns at 0.0 "$node_(553) off" 
$ns at 500.0 "$node_(553) on" 
$node_(554) set X_ 511 
$node_(554) set Y_ 913 
$node_(554) set Z_ 0.0 
$ns at 0.0 "$node_(554) off" 
$ns at 500.0 "$node_(554) on" 
$node_(555) set X_ 2059 
$node_(555) set Y_ 151 
$node_(555) set Z_ 0.0 
$ns at 0.0 "$node_(555) off" 
$ns at 500.0 "$node_(555) on" 
$node_(556) set X_ 681 
$node_(556) set Y_ 779 
$node_(556) set Z_ 0.0 
$ns at 0.0 "$node_(556) off" 
$ns at 500.0 "$node_(556) on" 
$node_(557) set X_ 2539 
$node_(557) set Y_ 429 
$node_(557) set Z_ 0.0 
$ns at 0.0 "$node_(557) off" 
$ns at 500.0 "$node_(557) on" 
$node_(558) set X_ 1925 
$node_(558) set Y_ 983 
$node_(558) set Z_ 0.0 
$ns at 0.0 "$node_(558) off" 
$ns at 500.0 "$node_(558) on" 
$node_(559) set X_ 1620 
$node_(559) set Y_ 446 
$node_(559) set Z_ 0.0 
$ns at 0.0 "$node_(559) off" 
$ns at 500.0 "$node_(559) on" 
$node_(560) set X_ 2195 
$node_(560) set Y_ 769 
$node_(560) set Z_ 0.0 
$ns at 0.0 "$node_(560) off" 
$ns at 500.0 "$node_(560) on" 
$node_(561) set X_ 159 
$node_(561) set Y_ 899 
$node_(561) set Z_ 0.0 
$ns at 0.0 "$node_(561) off" 
$ns at 500.0 "$node_(561) on" 
$node_(562) set X_ 1323 
$node_(562) set Y_ 992 
$node_(562) set Z_ 0.0 
$ns at 0.0 "$node_(562) off" 
$ns at 500.0 "$node_(562) on" 
$node_(563) set X_ 1614 
$node_(563) set Y_ 216 
$node_(563) set Z_ 0.0 
$ns at 0.0 "$node_(563) off" 
$ns at 500.0 "$node_(563) on" 
$node_(564) set X_ 488 
$node_(564) set Y_ 199 
$node_(564) set Z_ 0.0 
$ns at 0.0 "$node_(564) off" 
$ns at 500.0 "$node_(564) on" 
$node_(565) set X_ 2433 
$node_(565) set Y_ 167 
$node_(565) set Z_ 0.0 
$ns at 0.0 "$node_(565) off" 
$ns at 500.0 "$node_(565) on" 
$node_(566) set X_ 1759 
$node_(566) set Y_ 198 
$node_(566) set Z_ 0.0 
$ns at 0.0 "$node_(566) off" 
$ns at 500.0 "$node_(566) on" 
$node_(567) set X_ 2944 
$node_(567) set Y_ 156 
$node_(567) set Z_ 0.0 
$ns at 0.0 "$node_(567) off" 
$ns at 500.0 "$node_(567) on" 
$node_(568) set X_ 460 
$node_(568) set Y_ 432 
$node_(568) set Z_ 0.0 
$ns at 0.0 "$node_(568) off" 
$ns at 500.0 "$node_(568) on" 
$node_(569) set X_ 1938 
$node_(569) set Y_ 119 
$node_(569) set Z_ 0.0 
$ns at 0.0 "$node_(569) off" 
$ns at 500.0 "$node_(569) on" 
$node_(570) set X_ 2193 
$node_(570) set Y_ 53 
$node_(570) set Z_ 0.0 
$ns at 0.0 "$node_(570) off" 
$ns at 500.0 "$node_(570) on" 
$node_(571) set X_ 1441 
$node_(571) set Y_ 871 
$node_(571) set Z_ 0.0 
$ns at 0.0 "$node_(571) off" 
$ns at 500.0 "$node_(571) on" 
$node_(572) set X_ 1605 
$node_(572) set Y_ 974 
$node_(572) set Z_ 0.0 
$ns at 0.0 "$node_(572) off" 
$ns at 500.0 "$node_(572) on" 
$node_(573) set X_ 189 
$node_(573) set Y_ 719 
$node_(573) set Z_ 0.0 
$ns at 0.0 "$node_(573) off" 
$ns at 500.0 "$node_(573) on" 
$node_(574) set X_ 500 
$node_(574) set Y_ 82 
$node_(574) set Z_ 0.0 
$ns at 0.0 "$node_(574) off" 
$ns at 500.0 "$node_(574) on" 
$node_(575) set X_ 2036 
$node_(575) set Y_ 353 
$node_(575) set Z_ 0.0 
$ns at 0.0 "$node_(575) off" 
$ns at 500.0 "$node_(575) on" 
$node_(576) set X_ 2620 
$node_(576) set Y_ 449 
$node_(576) set Z_ 0.0 
$ns at 0.0 "$node_(576) off" 
$ns at 500.0 "$node_(576) on" 
$node_(577) set X_ 1999 
$node_(577) set Y_ 321 
$node_(577) set Z_ 0.0 
$ns at 0.0 "$node_(577) off" 
$ns at 500.0 "$node_(577) on" 
$node_(578) set X_ 2337 
$node_(578) set Y_ 659 
$node_(578) set Z_ 0.0 
$ns at 0.0 "$node_(578) off" 
$ns at 500.0 "$node_(578) on" 
$node_(579) set X_ 1813 
$node_(579) set Y_ 918 
$node_(579) set Z_ 0.0 
$ns at 0.0 "$node_(579) off" 
$ns at 500.0 "$node_(579) on" 
$node_(580) set X_ 2667 
$node_(580) set Y_ 280 
$node_(580) set Z_ 0.0 
$ns at 0.0 "$node_(580) off" 
$ns at 500.0 "$node_(580) on" 
$node_(581) set X_ 728 
$node_(581) set Y_ 911 
$node_(581) set Z_ 0.0 
$ns at 0.0 "$node_(581) off" 
$ns at 500.0 "$node_(581) on" 
$node_(582) set X_ 399 
$node_(582) set Y_ 125 
$node_(582) set Z_ 0.0 
$ns at 0.0 "$node_(582) off" 
$ns at 500.0 "$node_(582) on" 
$node_(583) set X_ 1934 
$node_(583) set Y_ 356 
$node_(583) set Z_ 0.0 
$ns at 0.0 "$node_(583) off" 
$ns at 500.0 "$node_(583) on" 
$node_(584) set X_ 1692 
$node_(584) set Y_ 177 
$node_(584) set Z_ 0.0 
$ns at 0.0 "$node_(584) off" 
$ns at 500.0 "$node_(584) on" 
$node_(585) set X_ 1290 
$node_(585) set Y_ 677 
$node_(585) set Z_ 0.0 
$ns at 0.0 "$node_(585) off" 
$ns at 500.0 "$node_(585) on" 
$node_(586) set X_ 346 
$node_(586) set Y_ 967 
$node_(586) set Z_ 0.0 
$ns at 0.0 "$node_(586) off" 
$ns at 500.0 "$node_(586) on" 
$node_(587) set X_ 1111 
$node_(587) set Y_ 323 
$node_(587) set Z_ 0.0 
$ns at 0.0 "$node_(587) off" 
$ns at 500.0 "$node_(587) on" 
$node_(588) set X_ 2957 
$node_(588) set Y_ 744 
$node_(588) set Z_ 0.0 
$ns at 0.0 "$node_(588) off" 
$ns at 500.0 "$node_(588) on" 
$node_(589) set X_ 2485 
$node_(589) set Y_ 541 
$node_(589) set Z_ 0.0 
$ns at 0.0 "$node_(589) off" 
$ns at 500.0 "$node_(589) on" 
$node_(590) set X_ 2412 
$node_(590) set Y_ 5 
$node_(590) set Z_ 0.0 
$ns at 0.0 "$node_(590) off" 
$ns at 500.0 "$node_(590) on" 
$node_(591) set X_ 2137 
$node_(591) set Y_ 249 
$node_(591) set Z_ 0.0 
$ns at 0.0 "$node_(591) off" 
$ns at 500.0 "$node_(591) on" 
$node_(592) set X_ 680 
$node_(592) set Y_ 801 
$node_(592) set Z_ 0.0 
$ns at 0.0 "$node_(592) off" 
$ns at 500.0 "$node_(592) on" 
$node_(593) set X_ 2006 
$node_(593) set Y_ 563 
$node_(593) set Z_ 0.0 
$ns at 0.0 "$node_(593) off" 
$ns at 500.0 "$node_(593) on" 
$node_(594) set X_ 1490 
$node_(594) set Y_ 803 
$node_(594) set Z_ 0.0 
$ns at 0.0 "$node_(594) off" 
$ns at 500.0 "$node_(594) on" 
$node_(595) set X_ 650 
$node_(595) set Y_ 260 
$node_(595) set Z_ 0.0 
$ns at 0.0 "$node_(595) off" 
$ns at 500.0 "$node_(595) on" 
$node_(596) set X_ 2446 
$node_(596) set Y_ 244 
$node_(596) set Z_ 0.0 
$ns at 0.0 "$node_(596) off" 
$ns at 500.0 "$node_(596) on" 
$node_(597) set X_ 1218 
$node_(597) set Y_ 342 
$node_(597) set Z_ 0.0 
$ns at 0.0 "$node_(597) off" 
$ns at 500.0 "$node_(597) on" 
$node_(598) set X_ 213 
$node_(598) set Y_ 752 
$node_(598) set Z_ 0.0 
$ns at 0.0 "$node_(598) off" 
$ns at 500.0 "$node_(598) on" 
$node_(599) set X_ 1118 
$node_(599) set Y_ 919 
$node_(599) set Z_ 0.0 
$ns at 0.0 "$node_(599) off" 
$ns at 500.0 "$node_(599) on" 
$node_(600) set X_ 1775 
$node_(600) set Y_ 531 
$node_(600) set Z_ 0.0 
$ns at 0.0 "$node_(600) off" 
$ns at 600.0 "$node_(600) on" 
$node_(601) set X_ 2526 
$node_(601) set Y_ 829 
$node_(601) set Z_ 0.0 
$ns at 0.0 "$node_(601) off" 
$ns at 600.0 "$node_(601) on" 
$node_(602) set X_ 311 
$node_(602) set Y_ 543 
$node_(602) set Z_ 0.0 
$ns at 0.0 "$node_(602) off" 
$ns at 600.0 "$node_(602) on" 
$node_(603) set X_ 756 
$node_(603) set Y_ 764 
$node_(603) set Z_ 0.0 
$ns at 0.0 "$node_(603) off" 
$ns at 600.0 "$node_(603) on" 
$node_(604) set X_ 23 
$node_(604) set Y_ 125 
$node_(604) set Z_ 0.0 
$ns at 0.0 "$node_(604) off" 
$ns at 600.0 "$node_(604) on" 
$node_(605) set X_ 1949 
$node_(605) set Y_ 179 
$node_(605) set Z_ 0.0 
$ns at 0.0 "$node_(605) off" 
$ns at 600.0 "$node_(605) on" 
$node_(606) set X_ 1264 
$node_(606) set Y_ 969 
$node_(606) set Z_ 0.0 
$ns at 0.0 "$node_(606) off" 
$ns at 600.0 "$node_(606) on" 
$node_(607) set X_ 2833 
$node_(607) set Y_ 952 
$node_(607) set Z_ 0.0 
$ns at 0.0 "$node_(607) off" 
$ns at 600.0 "$node_(607) on" 
$node_(608) set X_ 488 
$node_(608) set Y_ 472 
$node_(608) set Z_ 0.0 
$ns at 0.0 "$node_(608) off" 
$ns at 600.0 "$node_(608) on" 
$node_(609) set X_ 1219 
$node_(609) set Y_ 551 
$node_(609) set Z_ 0.0 
$ns at 0.0 "$node_(609) off" 
$ns at 600.0 "$node_(609) on" 
$node_(610) set X_ 41 
$node_(610) set Y_ 292 
$node_(610) set Z_ 0.0 
$ns at 0.0 "$node_(610) off" 
$ns at 600.0 "$node_(610) on" 
$node_(611) set X_ 1590 
$node_(611) set Y_ 498 
$node_(611) set Z_ 0.0 
$ns at 0.0 "$node_(611) off" 
$ns at 600.0 "$node_(611) on" 
$node_(612) set X_ 406 
$node_(612) set Y_ 348 
$node_(612) set Z_ 0.0 
$ns at 0.0 "$node_(612) off" 
$ns at 600.0 "$node_(612) on" 
$node_(613) set X_ 1511 
$node_(613) set Y_ 988 
$node_(613) set Z_ 0.0 
$ns at 0.0 "$node_(613) off" 
$ns at 600.0 "$node_(613) on" 
$node_(614) set X_ 1442 
$node_(614) set Y_ 596 
$node_(614) set Z_ 0.0 
$ns at 0.0 "$node_(614) off" 
$ns at 600.0 "$node_(614) on" 
$node_(615) set X_ 1731 
$node_(615) set Y_ 896 
$node_(615) set Z_ 0.0 
$ns at 0.0 "$node_(615) off" 
$ns at 600.0 "$node_(615) on" 
$node_(616) set X_ 1211 
$node_(616) set Y_ 667 
$node_(616) set Z_ 0.0 
$ns at 0.0 "$node_(616) off" 
$ns at 600.0 "$node_(616) on" 
$node_(617) set X_ 1624 
$node_(617) set Y_ 779 
$node_(617) set Z_ 0.0 
$ns at 0.0 "$node_(617) off" 
$ns at 600.0 "$node_(617) on" 
$node_(618) set X_ 1322 
$node_(618) set Y_ 866 
$node_(618) set Z_ 0.0 
$ns at 0.0 "$node_(618) off" 
$ns at 600.0 "$node_(618) on" 
$node_(619) set X_ 1209 
$node_(619) set Y_ 138 
$node_(619) set Z_ 0.0 
$ns at 0.0 "$node_(619) off" 
$ns at 600.0 "$node_(619) on" 
$node_(620) set X_ 1233 
$node_(620) set Y_ 58 
$node_(620) set Z_ 0.0 
$ns at 0.0 "$node_(620) off" 
$ns at 600.0 "$node_(620) on" 
$node_(621) set X_ 229 
$node_(621) set Y_ 950 
$node_(621) set Z_ 0.0 
$ns at 0.0 "$node_(621) off" 
$ns at 600.0 "$node_(621) on" 
$node_(622) set X_ 1729 
$node_(622) set Y_ 728 
$node_(622) set Z_ 0.0 
$ns at 0.0 "$node_(622) off" 
$ns at 600.0 "$node_(622) on" 
$node_(623) set X_ 1755 
$node_(623) set Y_ 391 
$node_(623) set Z_ 0.0 
$ns at 0.0 "$node_(623) off" 
$ns at 600.0 "$node_(623) on" 
$node_(624) set X_ 1720 
$node_(624) set Y_ 824 
$node_(624) set Z_ 0.0 
$ns at 0.0 "$node_(624) off" 
$ns at 600.0 "$node_(624) on" 
$node_(625) set X_ 2496 
$node_(625) set Y_ 765 
$node_(625) set Z_ 0.0 
$ns at 0.0 "$node_(625) off" 
$ns at 600.0 "$node_(625) on" 
$node_(626) set X_ 732 
$node_(626) set Y_ 70 
$node_(626) set Z_ 0.0 
$ns at 0.0 "$node_(626) off" 
$ns at 600.0 "$node_(626) on" 
$node_(627) set X_ 1387 
$node_(627) set Y_ 867 
$node_(627) set Z_ 0.0 
$ns at 0.0 "$node_(627) off" 
$ns at 600.0 "$node_(627) on" 
$node_(628) set X_ 845 
$node_(628) set Y_ 84 
$node_(628) set Z_ 0.0 
$ns at 0.0 "$node_(628) off" 
$ns at 600.0 "$node_(628) on" 
$node_(629) set X_ 2215 
$node_(629) set Y_ 404 
$node_(629) set Z_ 0.0 
$ns at 0.0 "$node_(629) off" 
$ns at 600.0 "$node_(629) on" 
$node_(630) set X_ 2457 
$node_(630) set Y_ 989 
$node_(630) set Z_ 0.0 
$ns at 0.0 "$node_(630) off" 
$ns at 600.0 "$node_(630) on" 
$node_(631) set X_ 1844 
$node_(631) set Y_ 648 
$node_(631) set Z_ 0.0 
$ns at 0.0 "$node_(631) off" 
$ns at 600.0 "$node_(631) on" 
$node_(632) set X_ 2104 
$node_(632) set Y_ 209 
$node_(632) set Z_ 0.0 
$ns at 0.0 "$node_(632) off" 
$ns at 600.0 "$node_(632) on" 
$node_(633) set X_ 1229 
$node_(633) set Y_ 185 
$node_(633) set Z_ 0.0 
$ns at 0.0 "$node_(633) off" 
$ns at 600.0 "$node_(633) on" 
$node_(634) set X_ 626 
$node_(634) set Y_ 785 
$node_(634) set Z_ 0.0 
$ns at 0.0 "$node_(634) off" 
$ns at 600.0 "$node_(634) on" 
$node_(635) set X_ 1671 
$node_(635) set Y_ 480 
$node_(635) set Z_ 0.0 
$ns at 0.0 "$node_(635) off" 
$ns at 600.0 "$node_(635) on" 
$node_(636) set X_ 1243 
$node_(636) set Y_ 860 
$node_(636) set Z_ 0.0 
$ns at 0.0 "$node_(636) off" 
$ns at 600.0 "$node_(636) on" 
$node_(637) set X_ 2787 
$node_(637) set Y_ 2 
$node_(637) set Z_ 0.0 
$ns at 0.0 "$node_(637) off" 
$ns at 600.0 "$node_(637) on" 
$node_(638) set X_ 609 
$node_(638) set Y_ 947 
$node_(638) set Z_ 0.0 
$ns at 0.0 "$node_(638) off" 
$ns at 600.0 "$node_(638) on" 
$node_(639) set X_ 422 
$node_(639) set Y_ 814 
$node_(639) set Z_ 0.0 
$ns at 0.0 "$node_(639) off" 
$ns at 600.0 "$node_(639) on" 
$node_(640) set X_ 633 
$node_(640) set Y_ 223 
$node_(640) set Z_ 0.0 
$ns at 0.0 "$node_(640) off" 
$ns at 600.0 "$node_(640) on" 
$node_(641) set X_ 146 
$node_(641) set Y_ 850 
$node_(641) set Z_ 0.0 
$ns at 0.0 "$node_(641) off" 
$ns at 600.0 "$node_(641) on" 
$node_(642) set X_ 1780 
$node_(642) set Y_ 346 
$node_(642) set Z_ 0.0 
$ns at 0.0 "$node_(642) off" 
$ns at 600.0 "$node_(642) on" 
$node_(643) set X_ 1185 
$node_(643) set Y_ 610 
$node_(643) set Z_ 0.0 
$ns at 0.0 "$node_(643) off" 
$ns at 600.0 "$node_(643) on" 
$node_(644) set X_ 1736 
$node_(644) set Y_ 274 
$node_(644) set Z_ 0.0 
$ns at 0.0 "$node_(644) off" 
$ns at 600.0 "$node_(644) on" 
$node_(645) set X_ 510 
$node_(645) set Y_ 598 
$node_(645) set Z_ 0.0 
$ns at 0.0 "$node_(645) off" 
$ns at 600.0 "$node_(645) on" 
$node_(646) set X_ 688 
$node_(646) set Y_ 88 
$node_(646) set Z_ 0.0 
$ns at 0.0 "$node_(646) off" 
$ns at 600.0 "$node_(646) on" 
$node_(647) set X_ 2399 
$node_(647) set Y_ 676 
$node_(647) set Z_ 0.0 
$ns at 0.0 "$node_(647) off" 
$ns at 600.0 "$node_(647) on" 
$node_(648) set X_ 2059 
$node_(648) set Y_ 147 
$node_(648) set Z_ 0.0 
$ns at 0.0 "$node_(648) off" 
$ns at 600.0 "$node_(648) on" 
$node_(649) set X_ 2160 
$node_(649) set Y_ 398 
$node_(649) set Z_ 0.0 
$ns at 0.0 "$node_(649) off" 
$ns at 600.0 "$node_(649) on" 
$node_(650) set X_ 1346 
$node_(650) set Y_ 731 
$node_(650) set Z_ 0.0 
$ns at 0.0 "$node_(650) off" 
$ns at 600.0 "$node_(650) on" 
$node_(651) set X_ 687 
$node_(651) set Y_ 557 
$node_(651) set Z_ 0.0 
$ns at 0.0 "$node_(651) off" 
$ns at 600.0 "$node_(651) on" 
$node_(652) set X_ 2768 
$node_(652) set Y_ 945 
$node_(652) set Z_ 0.0 
$ns at 0.0 "$node_(652) off" 
$ns at 600.0 "$node_(652) on" 
$node_(653) set X_ 2350 
$node_(653) set Y_ 374 
$node_(653) set Z_ 0.0 
$ns at 0.0 "$node_(653) off" 
$ns at 600.0 "$node_(653) on" 
$node_(654) set X_ 1633 
$node_(654) set Y_ 836 
$node_(654) set Z_ 0.0 
$ns at 0.0 "$node_(654) off" 
$ns at 600.0 "$node_(654) on" 
$node_(655) set X_ 151 
$node_(655) set Y_ 246 
$node_(655) set Z_ 0.0 
$ns at 0.0 "$node_(655) off" 
$ns at 600.0 "$node_(655) on" 
$node_(656) set X_ 843 
$node_(656) set Y_ 572 
$node_(656) set Z_ 0.0 
$ns at 0.0 "$node_(656) off" 
$ns at 600.0 "$node_(656) on" 
$node_(657) set X_ 311 
$node_(657) set Y_ 484 
$node_(657) set Z_ 0.0 
$ns at 0.0 "$node_(657) off" 
$ns at 600.0 "$node_(657) on" 
$node_(658) set X_ 617 
$node_(658) set Y_ 40 
$node_(658) set Z_ 0.0 
$ns at 0.0 "$node_(658) off" 
$ns at 600.0 "$node_(658) on" 
$node_(659) set X_ 363 
$node_(659) set Y_ 241 
$node_(659) set Z_ 0.0 
$ns at 0.0 "$node_(659) off" 
$ns at 600.0 "$node_(659) on" 
$node_(660) set X_ 434 
$node_(660) set Y_ 420 
$node_(660) set Z_ 0.0 
$ns at 0.0 "$node_(660) off" 
$ns at 600.0 "$node_(660) on" 
$node_(661) set X_ 2464 
$node_(661) set Y_ 710 
$node_(661) set Z_ 0.0 
$ns at 0.0 "$node_(661) off" 
$ns at 600.0 "$node_(661) on" 
$node_(662) set X_ 303 
$node_(662) set Y_ 125 
$node_(662) set Z_ 0.0 
$ns at 0.0 "$node_(662) off" 
$ns at 600.0 "$node_(662) on" 
$node_(663) set X_ 2005 
$node_(663) set Y_ 704 
$node_(663) set Z_ 0.0 
$ns at 0.0 "$node_(663) off" 
$ns at 600.0 "$node_(663) on" 
$node_(664) set X_ 829 
$node_(664) set Y_ 995 
$node_(664) set Z_ 0.0 
$ns at 0.0 "$node_(664) off" 
$ns at 600.0 "$node_(664) on" 
$node_(665) set X_ 1667 
$node_(665) set Y_ 951 
$node_(665) set Z_ 0.0 
$ns at 0.0 "$node_(665) off" 
$ns at 600.0 "$node_(665) on" 
$node_(666) set X_ 98 
$node_(666) set Y_ 783 
$node_(666) set Z_ 0.0 
$ns at 0.0 "$node_(666) off" 
$ns at 600.0 "$node_(666) on" 
$node_(667) set X_ 874 
$node_(667) set Y_ 762 
$node_(667) set Z_ 0.0 
$ns at 0.0 "$node_(667) off" 
$ns at 600.0 "$node_(667) on" 
$node_(668) set X_ 172 
$node_(668) set Y_ 803 
$node_(668) set Z_ 0.0 
$ns at 0.0 "$node_(668) off" 
$ns at 600.0 "$node_(668) on" 
$node_(669) set X_ 2097 
$node_(669) set Y_ 287 
$node_(669) set Z_ 0.0 
$ns at 0.0 "$node_(669) off" 
$ns at 600.0 "$node_(669) on" 
$node_(670) set X_ 1013 
$node_(670) set Y_ 27 
$node_(670) set Z_ 0.0 
$ns at 0.0 "$node_(670) off" 
$ns at 600.0 "$node_(670) on" 
$node_(671) set X_ 1721 
$node_(671) set Y_ 198 
$node_(671) set Z_ 0.0 
$ns at 0.0 "$node_(671) off" 
$ns at 600.0 "$node_(671) on" 
$node_(672) set X_ 841 
$node_(672) set Y_ 99 
$node_(672) set Z_ 0.0 
$ns at 0.0 "$node_(672) off" 
$ns at 600.0 "$node_(672) on" 
$node_(673) set X_ 101 
$node_(673) set Y_ 490 
$node_(673) set Z_ 0.0 
$ns at 0.0 "$node_(673) off" 
$ns at 600.0 "$node_(673) on" 
$node_(674) set X_ 1385 
$node_(674) set Y_ 469 
$node_(674) set Z_ 0.0 
$ns at 0.0 "$node_(674) off" 
$ns at 600.0 "$node_(674) on" 
$node_(675) set X_ 142 
$node_(675) set Y_ 71 
$node_(675) set Z_ 0.0 
$ns at 0.0 "$node_(675) off" 
$ns at 600.0 "$node_(675) on" 
$node_(676) set X_ 143 
$node_(676) set Y_ 305 
$node_(676) set Z_ 0.0 
$ns at 0.0 "$node_(676) off" 
$ns at 600.0 "$node_(676) on" 
$node_(677) set X_ 107 
$node_(677) set Y_ 934 
$node_(677) set Z_ 0.0 
$ns at 0.0 "$node_(677) off" 
$ns at 600.0 "$node_(677) on" 
$node_(678) set X_ 2635 
$node_(678) set Y_ 917 
$node_(678) set Z_ 0.0 
$ns at 0.0 "$node_(678) off" 
$ns at 600.0 "$node_(678) on" 
$node_(679) set X_ 1467 
$node_(679) set Y_ 17 
$node_(679) set Z_ 0.0 
$ns at 0.0 "$node_(679) off" 
$ns at 600.0 "$node_(679) on" 
$node_(680) set X_ 1716 
$node_(680) set Y_ 204 
$node_(680) set Z_ 0.0 
$ns at 0.0 "$node_(680) off" 
$ns at 600.0 "$node_(680) on" 
$node_(681) set X_ 1437 
$node_(681) set Y_ 297 
$node_(681) set Z_ 0.0 
$ns at 0.0 "$node_(681) off" 
$ns at 600.0 "$node_(681) on" 
$node_(682) set X_ 2357 
$node_(682) set Y_ 988 
$node_(682) set Z_ 0.0 
$ns at 0.0 "$node_(682) off" 
$ns at 600.0 "$node_(682) on" 
$node_(683) set X_ 2392 
$node_(683) set Y_ 264 
$node_(683) set Z_ 0.0 
$ns at 0.0 "$node_(683) off" 
$ns at 600.0 "$node_(683) on" 
$node_(684) set X_ 2798 
$node_(684) set Y_ 221 
$node_(684) set Z_ 0.0 
$ns at 0.0 "$node_(684) off" 
$ns at 600.0 "$node_(684) on" 
$node_(685) set X_ 610 
$node_(685) set Y_ 705 
$node_(685) set Z_ 0.0 
$ns at 0.0 "$node_(685) off" 
$ns at 600.0 "$node_(685) on" 
$node_(686) set X_ 749 
$node_(686) set Y_ 707 
$node_(686) set Z_ 0.0 
$ns at 0.0 "$node_(686) off" 
$ns at 600.0 "$node_(686) on" 
$node_(687) set X_ 2789 
$node_(687) set Y_ 622 
$node_(687) set Z_ 0.0 
$ns at 0.0 "$node_(687) off" 
$ns at 600.0 "$node_(687) on" 
$node_(688) set X_ 272 
$node_(688) set Y_ 393 
$node_(688) set Z_ 0.0 
$ns at 0.0 "$node_(688) off" 
$ns at 600.0 "$node_(688) on" 
$node_(689) set X_ 470 
$node_(689) set Y_ 202 
$node_(689) set Z_ 0.0 
$ns at 0.0 "$node_(689) off" 
$ns at 600.0 "$node_(689) on" 
$node_(690) set X_ 2172 
$node_(690) set Y_ 299 
$node_(690) set Z_ 0.0 
$ns at 0.0 "$node_(690) off" 
$ns at 600.0 "$node_(690) on" 
$node_(691) set X_ 1930 
$node_(691) set Y_ 976 
$node_(691) set Z_ 0.0 
$ns at 0.0 "$node_(691) off" 
$ns at 600.0 "$node_(691) on" 
$node_(692) set X_ 2120 
$node_(692) set Y_ 837 
$node_(692) set Z_ 0.0 
$ns at 0.0 "$node_(692) off" 
$ns at 600.0 "$node_(692) on" 
$node_(693) set X_ 245 
$node_(693) set Y_ 701 
$node_(693) set Z_ 0.0 
$ns at 0.0 "$node_(693) off" 
$ns at 600.0 "$node_(693) on" 
$node_(694) set X_ 362 
$node_(694) set Y_ 616 
$node_(694) set Z_ 0.0 
$ns at 0.0 "$node_(694) off" 
$ns at 600.0 "$node_(694) on" 
$node_(695) set X_ 81 
$node_(695) set Y_ 40 
$node_(695) set Z_ 0.0 
$ns at 0.0 "$node_(695) off" 
$ns at 600.0 "$node_(695) on" 
$node_(696) set X_ 1710 
$node_(696) set Y_ 822 
$node_(696) set Z_ 0.0 
$ns at 0.0 "$node_(696) off" 
$ns at 600.0 "$node_(696) on" 
$node_(697) set X_ 1352 
$node_(697) set Y_ 803 
$node_(697) set Z_ 0.0 
$ns at 0.0 "$node_(697) off" 
$ns at 600.0 "$node_(697) on" 
$node_(698) set X_ 2573 
$node_(698) set Y_ 924 
$node_(698) set Z_ 0.0 
$ns at 0.0 "$node_(698) off" 
$ns at 600.0 "$node_(698) on" 
$node_(699) set X_ 175 
$node_(699) set Y_ 401 
$node_(699) set Z_ 0.0 
$ns at 0.0 "$node_(699) off" 
$ns at 600.0 "$node_(699) on" 
$node_(700) set X_ 2057 
$node_(700) set Y_ 756 
$node_(700) set Z_ 0.0 
$ns at 0.0 "$node_(700) off" 
$ns at 700.0 "$node_(700) on" 
$node_(701) set X_ 1563 
$node_(701) set Y_ 130 
$node_(701) set Z_ 0.0 
$ns at 0.0 "$node_(701) off" 
$ns at 700.0 "$node_(701) on" 
$node_(702) set X_ 1679 
$node_(702) set Y_ 997 
$node_(702) set Z_ 0.0 
$ns at 0.0 "$node_(702) off" 
$ns at 700.0 "$node_(702) on" 
$node_(703) set X_ 2048 
$node_(703) set Y_ 122 
$node_(703) set Z_ 0.0 
$ns at 0.0 "$node_(703) off" 
$ns at 700.0 "$node_(703) on" 
$node_(704) set X_ 951 
$node_(704) set Y_ 691 
$node_(704) set Z_ 0.0 
$ns at 0.0 "$node_(704) off" 
$ns at 700.0 "$node_(704) on" 
$node_(705) set X_ 1853 
$node_(705) set Y_ 76 
$node_(705) set Z_ 0.0 
$ns at 0.0 "$node_(705) off" 
$ns at 700.0 "$node_(705) on" 
$node_(706) set X_ 1007 
$node_(706) set Y_ 729 
$node_(706) set Z_ 0.0 
$ns at 0.0 "$node_(706) off" 
$ns at 700.0 "$node_(706) on" 
$node_(707) set X_ 429 
$node_(707) set Y_ 416 
$node_(707) set Z_ 0.0 
$ns at 0.0 "$node_(707) off" 
$ns at 700.0 "$node_(707) on" 
$node_(708) set X_ 1635 
$node_(708) set Y_ 153 
$node_(708) set Z_ 0.0 
$ns at 0.0 "$node_(708) off" 
$ns at 700.0 "$node_(708) on" 
$node_(709) set X_ 33 
$node_(709) set Y_ 102 
$node_(709) set Z_ 0.0 
$ns at 0.0 "$node_(709) off" 
$ns at 700.0 "$node_(709) on" 
$node_(710) set X_ 2436 
$node_(710) set Y_ 716 
$node_(710) set Z_ 0.0 
$ns at 0.0 "$node_(710) off" 
$ns at 700.0 "$node_(710) on" 
$node_(711) set X_ 1667 
$node_(711) set Y_ 169 
$node_(711) set Z_ 0.0 
$ns at 0.0 "$node_(711) off" 
$ns at 700.0 "$node_(711) on" 
$node_(712) set X_ 398 
$node_(712) set Y_ 407 
$node_(712) set Z_ 0.0 
$ns at 0.0 "$node_(712) off" 
$ns at 700.0 "$node_(712) on" 
$node_(713) set X_ 2994 
$node_(713) set Y_ 984 
$node_(713) set Z_ 0.0 
$ns at 0.0 "$node_(713) off" 
$ns at 700.0 "$node_(713) on" 
$node_(714) set X_ 1040 
$node_(714) set Y_ 522 
$node_(714) set Z_ 0.0 
$ns at 0.0 "$node_(714) off" 
$ns at 700.0 "$node_(714) on" 
$node_(715) set X_ 2902 
$node_(715) set Y_ 325 
$node_(715) set Z_ 0.0 
$ns at 0.0 "$node_(715) off" 
$ns at 700.0 "$node_(715) on" 
$node_(716) set X_ 2259 
$node_(716) set Y_ 459 
$node_(716) set Z_ 0.0 
$ns at 0.0 "$node_(716) off" 
$ns at 700.0 "$node_(716) on" 
$node_(717) set X_ 171 
$node_(717) set Y_ 660 
$node_(717) set Z_ 0.0 
$ns at 0.0 "$node_(717) off" 
$ns at 700.0 "$node_(717) on" 
$node_(718) set X_ 289 
$node_(718) set Y_ 579 
$node_(718) set Z_ 0.0 
$ns at 0.0 "$node_(718) off" 
$ns at 700.0 "$node_(718) on" 
$node_(719) set X_ 1143 
$node_(719) set Y_ 411 
$node_(719) set Z_ 0.0 
$ns at 0.0 "$node_(719) off" 
$ns at 700.0 "$node_(719) on" 
$node_(720) set X_ 2643 
$node_(720) set Y_ 410 
$node_(720) set Z_ 0.0 
$ns at 0.0 "$node_(720) off" 
$ns at 700.0 "$node_(720) on" 
$node_(721) set X_ 545 
$node_(721) set Y_ 559 
$node_(721) set Z_ 0.0 
$ns at 0.0 "$node_(721) off" 
$ns at 700.0 "$node_(721) on" 
$node_(722) set X_ 2600 
$node_(722) set Y_ 937 
$node_(722) set Z_ 0.0 
$ns at 0.0 "$node_(722) off" 
$ns at 700.0 "$node_(722) on" 
$node_(723) set X_ 1478 
$node_(723) set Y_ 709 
$node_(723) set Z_ 0.0 
$ns at 0.0 "$node_(723) off" 
$ns at 700.0 "$node_(723) on" 
$node_(724) set X_ 2688 
$node_(724) set Y_ 963 
$node_(724) set Z_ 0.0 
$ns at 0.0 "$node_(724) off" 
$ns at 700.0 "$node_(724) on" 
$node_(725) set X_ 2292 
$node_(725) set Y_ 562 
$node_(725) set Z_ 0.0 
$ns at 0.0 "$node_(725) off" 
$ns at 700.0 "$node_(725) on" 
$node_(726) set X_ 2762 
$node_(726) set Y_ 310 
$node_(726) set Z_ 0.0 
$ns at 0.0 "$node_(726) off" 
$ns at 700.0 "$node_(726) on" 
$node_(727) set X_ 362 
$node_(727) set Y_ 859 
$node_(727) set Z_ 0.0 
$ns at 0.0 "$node_(727) off" 
$ns at 700.0 "$node_(727) on" 
$node_(728) set X_ 600 
$node_(728) set Y_ 185 
$node_(728) set Z_ 0.0 
$ns at 0.0 "$node_(728) off" 
$ns at 700.0 "$node_(728) on" 
$node_(729) set X_ 1903 
$node_(729) set Y_ 994 
$node_(729) set Z_ 0.0 
$ns at 0.0 "$node_(729) off" 
$ns at 700.0 "$node_(729) on" 
$node_(730) set X_ 507 
$node_(730) set Y_ 131 
$node_(730) set Z_ 0.0 
$ns at 0.0 "$node_(730) off" 
$ns at 700.0 "$node_(730) on" 
$node_(731) set X_ 1725 
$node_(731) set Y_ 898 
$node_(731) set Z_ 0.0 
$ns at 0.0 "$node_(731) off" 
$ns at 700.0 "$node_(731) on" 
$node_(732) set X_ 1203 
$node_(732) set Y_ 848 
$node_(732) set Z_ 0.0 
$ns at 0.0 "$node_(732) off" 
$ns at 700.0 "$node_(732) on" 
$node_(733) set X_ 380 
$node_(733) set Y_ 285 
$node_(733) set Z_ 0.0 
$ns at 0.0 "$node_(733) off" 
$ns at 700.0 "$node_(733) on" 
$node_(734) set X_ 1259 
$node_(734) set Y_ 580 
$node_(734) set Z_ 0.0 
$ns at 0.0 "$node_(734) off" 
$ns at 700.0 "$node_(734) on" 
$node_(735) set X_ 1337 
$node_(735) set Y_ 18 
$node_(735) set Z_ 0.0 
$ns at 0.0 "$node_(735) off" 
$ns at 700.0 "$node_(735) on" 
$node_(736) set X_ 2577 
$node_(736) set Y_ 939 
$node_(736) set Z_ 0.0 
$ns at 0.0 "$node_(736) off" 
$ns at 700.0 "$node_(736) on" 
$node_(737) set X_ 833 
$node_(737) set Y_ 199 
$node_(737) set Z_ 0.0 
$ns at 0.0 "$node_(737) off" 
$ns at 700.0 "$node_(737) on" 
$node_(738) set X_ 1833 
$node_(738) set Y_ 773 
$node_(738) set Z_ 0.0 
$ns at 0.0 "$node_(738) off" 
$ns at 700.0 "$node_(738) on" 
$node_(739) set X_ 1660 
$node_(739) set Y_ 549 
$node_(739) set Z_ 0.0 
$ns at 0.0 "$node_(739) off" 
$ns at 700.0 "$node_(739) on" 
$node_(740) set X_ 457 
$node_(740) set Y_ 150 
$node_(740) set Z_ 0.0 
$ns at 0.0 "$node_(740) off" 
$ns at 700.0 "$node_(740) on" 
$node_(741) set X_ 1580 
$node_(741) set Y_ 775 
$node_(741) set Z_ 0.0 
$ns at 0.0 "$node_(741) off" 
$ns at 700.0 "$node_(741) on" 
$node_(742) set X_ 624 
$node_(742) set Y_ 590 
$node_(742) set Z_ 0.0 
$ns at 0.0 "$node_(742) off" 
$ns at 700.0 "$node_(742) on" 
$node_(743) set X_ 154 
$node_(743) set Y_ 955 
$node_(743) set Z_ 0.0 
$ns at 0.0 "$node_(743) off" 
$ns at 700.0 "$node_(743) on" 
$node_(744) set X_ 775 
$node_(744) set Y_ 464 
$node_(744) set Z_ 0.0 
$ns at 0.0 "$node_(744) off" 
$ns at 700.0 "$node_(744) on" 
$node_(745) set X_ 1585 
$node_(745) set Y_ 367 
$node_(745) set Z_ 0.0 
$ns at 0.0 "$node_(745) off" 
$ns at 700.0 "$node_(745) on" 
$node_(746) set X_ 549 
$node_(746) set Y_ 837 
$node_(746) set Z_ 0.0 
$ns at 0.0 "$node_(746) off" 
$ns at 700.0 "$node_(746) on" 
$node_(747) set X_ 2745 
$node_(747) set Y_ 840 
$node_(747) set Z_ 0.0 
$ns at 0.0 "$node_(747) off" 
$ns at 700.0 "$node_(747) on" 
$node_(748) set X_ 1506 
$node_(748) set Y_ 136 
$node_(748) set Z_ 0.0 
$ns at 0.0 "$node_(748) off" 
$ns at 700.0 "$node_(748) on" 
$node_(749) set X_ 2815 
$node_(749) set Y_ 441 
$node_(749) set Z_ 0.0 
$ns at 0.0 "$node_(749) off" 
$ns at 700.0 "$node_(749) on" 
$node_(750) set X_ 773 
$node_(750) set Y_ 699 
$node_(750) set Z_ 0.0 
$ns at 0.0 "$node_(750) off" 
$ns at 700.0 "$node_(750) on" 
$node_(751) set X_ 916 
$node_(751) set Y_ 247 
$node_(751) set Z_ 0.0 
$ns at 0.0 "$node_(751) off" 
$ns at 700.0 "$node_(751) on" 
$node_(752) set X_ 1726 
$node_(752) set Y_ 670 
$node_(752) set Z_ 0.0 
$ns at 0.0 "$node_(752) off" 
$ns at 700.0 "$node_(752) on" 
$node_(753) set X_ 879 
$node_(753) set Y_ 12 
$node_(753) set Z_ 0.0 
$ns at 0.0 "$node_(753) off" 
$ns at 700.0 "$node_(753) on" 
$node_(754) set X_ 1002 
$node_(754) set Y_ 698 
$node_(754) set Z_ 0.0 
$ns at 0.0 "$node_(754) off" 
$ns at 700.0 "$node_(754) on" 
$node_(755) set X_ 1649 
$node_(755) set Y_ 778 
$node_(755) set Z_ 0.0 
$ns at 0.0 "$node_(755) off" 
$ns at 700.0 "$node_(755) on" 
$node_(756) set X_ 522 
$node_(756) set Y_ 620 
$node_(756) set Z_ 0.0 
$ns at 0.0 "$node_(756) off" 
$ns at 700.0 "$node_(756) on" 
$node_(757) set X_ 1013 
$node_(757) set Y_ 873 
$node_(757) set Z_ 0.0 
$ns at 0.0 "$node_(757) off" 
$ns at 700.0 "$node_(757) on" 
$node_(758) set X_ 868 
$node_(758) set Y_ 607 
$node_(758) set Z_ 0.0 
$ns at 0.0 "$node_(758) off" 
$ns at 700.0 "$node_(758) on" 
$node_(759) set X_ 2173 
$node_(759) set Y_ 274 
$node_(759) set Z_ 0.0 
$ns at 0.0 "$node_(759) off" 
$ns at 700.0 "$node_(759) on" 
$node_(760) set X_ 164 
$node_(760) set Y_ 294 
$node_(760) set Z_ 0.0 
$ns at 0.0 "$node_(760) off" 
$ns at 700.0 "$node_(760) on" 
$node_(761) set X_ 1266 
$node_(761) set Y_ 5 
$node_(761) set Z_ 0.0 
$ns at 0.0 "$node_(761) off" 
$ns at 700.0 "$node_(761) on" 
$node_(762) set X_ 1681 
$node_(762) set Y_ 26 
$node_(762) set Z_ 0.0 
$ns at 0.0 "$node_(762) off" 
$ns at 700.0 "$node_(762) on" 
$node_(763) set X_ 236 
$node_(763) set Y_ 119 
$node_(763) set Z_ 0.0 
$ns at 0.0 "$node_(763) off" 
$ns at 700.0 "$node_(763) on" 
$node_(764) set X_ 1693 
$node_(764) set Y_ 696 
$node_(764) set Z_ 0.0 
$ns at 0.0 "$node_(764) off" 
$ns at 700.0 "$node_(764) on" 
$node_(765) set X_ 2472 
$node_(765) set Y_ 814 
$node_(765) set Z_ 0.0 
$ns at 0.0 "$node_(765) off" 
$ns at 700.0 "$node_(765) on" 
$node_(766) set X_ 569 
$node_(766) set Y_ 587 
$node_(766) set Z_ 0.0 
$ns at 0.0 "$node_(766) off" 
$ns at 700.0 "$node_(766) on" 
$node_(767) set X_ 2361 
$node_(767) set Y_ 388 
$node_(767) set Z_ 0.0 
$ns at 0.0 "$node_(767) off" 
$ns at 700.0 "$node_(767) on" 
$node_(768) set X_ 2824 
$node_(768) set Y_ 287 
$node_(768) set Z_ 0.0 
$ns at 0.0 "$node_(768) off" 
$ns at 700.0 "$node_(768) on" 
$node_(769) set X_ 352 
$node_(769) set Y_ 94 
$node_(769) set Z_ 0.0 
$ns at 0.0 "$node_(769) off" 
$ns at 700.0 "$node_(769) on" 
$node_(770) set X_ 807 
$node_(770) set Y_ 981 
$node_(770) set Z_ 0.0 
$ns at 0.0 "$node_(770) off" 
$ns at 700.0 "$node_(770) on" 
$node_(771) set X_ 2313 
$node_(771) set Y_ 404 
$node_(771) set Z_ 0.0 
$ns at 0.0 "$node_(771) off" 
$ns at 700.0 "$node_(771) on" 
$node_(772) set X_ 2811 
$node_(772) set Y_ 399 
$node_(772) set Z_ 0.0 
$ns at 0.0 "$node_(772) off" 
$ns at 700.0 "$node_(772) on" 
$node_(773) set X_ 2829 
$node_(773) set Y_ 856 
$node_(773) set Z_ 0.0 
$ns at 0.0 "$node_(773) off" 
$ns at 700.0 "$node_(773) on" 
$node_(774) set X_ 2827 
$node_(774) set Y_ 272 
$node_(774) set Z_ 0.0 
$ns at 0.0 "$node_(774) off" 
$ns at 700.0 "$node_(774) on" 
$node_(775) set X_ 1726 
$node_(775) set Y_ 439 
$node_(775) set Z_ 0.0 
$ns at 0.0 "$node_(775) off" 
$ns at 700.0 "$node_(775) on" 
$node_(776) set X_ 1687 
$node_(776) set Y_ 378 
$node_(776) set Z_ 0.0 
$ns at 0.0 "$node_(776) off" 
$ns at 700.0 "$node_(776) on" 
$node_(777) set X_ 2402 
$node_(777) set Y_ 415 
$node_(777) set Z_ 0.0 
$ns at 0.0 "$node_(777) off" 
$ns at 700.0 "$node_(777) on" 
$node_(778) set X_ 1222 
$node_(778) set Y_ 208 
$node_(778) set Z_ 0.0 
$ns at 0.0 "$node_(778) off" 
$ns at 700.0 "$node_(778) on" 
$node_(779) set X_ 1619 
$node_(779) set Y_ 602 
$node_(779) set Z_ 0.0 
$ns at 0.0 "$node_(779) off" 
$ns at 700.0 "$node_(779) on" 
$node_(780) set X_ 30 
$node_(780) set Y_ 794 
$node_(780) set Z_ 0.0 
$ns at 0.0 "$node_(780) off" 
$ns at 700.0 "$node_(780) on" 
$node_(781) set X_ 2164 
$node_(781) set Y_ 387 
$node_(781) set Z_ 0.0 
$ns at 0.0 "$node_(781) off" 
$ns at 700.0 "$node_(781) on" 
$node_(782) set X_ 1746 
$node_(782) set Y_ 481 
$node_(782) set Z_ 0.0 
$ns at 0.0 "$node_(782) off" 
$ns at 700.0 "$node_(782) on" 
$node_(783) set X_ 2254 
$node_(783) set Y_ 168 
$node_(783) set Z_ 0.0 
$ns at 0.0 "$node_(783) off" 
$ns at 700.0 "$node_(783) on" 
$node_(784) set X_ 143 
$node_(784) set Y_ 304 
$node_(784) set Z_ 0.0 
$ns at 0.0 "$node_(784) off" 
$ns at 700.0 "$node_(784) on" 
$node_(785) set X_ 2808 
$node_(785) set Y_ 487 
$node_(785) set Z_ 0.0 
$ns at 0.0 "$node_(785) off" 
$ns at 700.0 "$node_(785) on" 
$node_(786) set X_ 1094 
$node_(786) set Y_ 138 
$node_(786) set Z_ 0.0 
$ns at 0.0 "$node_(786) off" 
$ns at 700.0 "$node_(786) on" 
$node_(787) set X_ 1561 
$node_(787) set Y_ 875 
$node_(787) set Z_ 0.0 
$ns at 0.0 "$node_(787) off" 
$ns at 700.0 "$node_(787) on" 
$node_(788) set X_ 1322 
$node_(788) set Y_ 985 
$node_(788) set Z_ 0.0 
$ns at 0.0 "$node_(788) off" 
$ns at 700.0 "$node_(788) on" 
$node_(789) set X_ 2712 
$node_(789) set Y_ 268 
$node_(789) set Z_ 0.0 
$ns at 0.0 "$node_(789) off" 
$ns at 700.0 "$node_(789) on" 
$node_(790) set X_ 2000 
$node_(790) set Y_ 613 
$node_(790) set Z_ 0.0 
$ns at 0.0 "$node_(790) off" 
$ns at 700.0 "$node_(790) on" 
$node_(791) set X_ 1089 
$node_(791) set Y_ 960 
$node_(791) set Z_ 0.0 
$ns at 0.0 "$node_(791) off" 
$ns at 700.0 "$node_(791) on" 
$node_(792) set X_ 597 
$node_(792) set Y_ 233 
$node_(792) set Z_ 0.0 
$ns at 0.0 "$node_(792) off" 
$ns at 700.0 "$node_(792) on" 
$node_(793) set X_ 933 
$node_(793) set Y_ 202 
$node_(793) set Z_ 0.0 
$ns at 0.0 "$node_(793) off" 
$ns at 700.0 "$node_(793) on" 
$node_(794) set X_ 1918 
$node_(794) set Y_ 80 
$node_(794) set Z_ 0.0 
$ns at 0.0 "$node_(794) off" 
$ns at 700.0 "$node_(794) on" 
$node_(795) set X_ 2194 
$node_(795) set Y_ 948 
$node_(795) set Z_ 0.0 
$ns at 0.0 "$node_(795) off" 
$ns at 700.0 "$node_(795) on" 
$node_(796) set X_ 2107 
$node_(796) set Y_ 557 
$node_(796) set Z_ 0.0 
$ns at 0.0 "$node_(796) off" 
$ns at 700.0 "$node_(796) on" 
$node_(797) set X_ 2712 
$node_(797) set Y_ 748 
$node_(797) set Z_ 0.0 
$ns at 0.0 "$node_(797) off" 
$ns at 700.0 "$node_(797) on" 
$node_(798) set X_ 2313 
$node_(798) set Y_ 77 
$node_(798) set Z_ 0.0 
$ns at 0.0 "$node_(798) off" 
$ns at 700.0 "$node_(798) on" 
$node_(799) set X_ 2948 
$node_(799) set Y_ 464 
$node_(799) set Z_ 0.0 
$ns at 0.0 "$node_(799) off" 
$ns at 700.0 "$node_(799) on" 

# Generation of movements
$ns at 0.0 "$node_(0) setdest 299 26723 5.0" 
$ns at 44.71919849470552 "$node_(0) setdest 74181 19749 6.0" 
$ns at 110.57613376281228 "$node_(0) setdest 81389 29717 19.0" 
$ns at 164.3379439854205 "$node_(0) setdest 66417 12514 14.0" 
$ns at 274.35835937157174 "$node_(0) setdest 47466 32973 9.0" 
$ns at 376.97814886635285 "$node_(0) setdest 19085 53257 17.0" 
$ns at 534.9564804243896 "$node_(0) setdest 153922 13962 19.0" 
$ns at 685.7318929793507 "$node_(0) setdest 125201 55626 6.0" 
$ns at 731.4482669008904 "$node_(0) setdest 7015 57359 6.0" 
$ns at 763.8906522452869 "$node_(0) setdest 172167 69858 7.0" 
$ns at 843.3972860562473 "$node_(0) setdest 252461 66608 12.0" 
$ns at 884.2579318750205 "$node_(0) setdest 13575 26655 14.0" 
$ns at 0.0 "$node_(1) setdest 74180 3623 8.0" 
$ns at 69.53909759938476 "$node_(1) setdest 88867 24366 1.0" 
$ns at 109.00622632924754 "$node_(1) setdest 39125 15446 1.0" 
$ns at 146.4440056153885 "$node_(1) setdest 56740 16055 1.0" 
$ns at 185.0476557174881 "$node_(1) setdest 106351 24011 7.0" 
$ns at 235.3928195630996 "$node_(1) setdest 2760 966 3.0" 
$ns at 268.0686389426533 "$node_(1) setdest 110518 49047 20.0" 
$ns at 478.56440583118206 "$node_(1) setdest 182027 5246 6.0" 
$ns at 559.7813428033995 "$node_(1) setdest 50596 15305 7.0" 
$ns at 631.3287317868514 "$node_(1) setdest 50594 2306 9.0" 
$ns at 700.7612965444122 "$node_(1) setdest 156223 40644 6.0" 
$ns at 777.1863740738869 "$node_(1) setdest 248364 42036 12.0" 
$ns at 847.0317646647723 "$node_(1) setdest 2666 52083 14.0" 
$ns at 0.0 "$node_(2) setdest 18910 8800 12.0" 
$ns at 107.90030205207042 "$node_(2) setdest 16237 7958 1.0" 
$ns at 138.4051236366685 "$node_(2) setdest 85649 20587 1.0" 
$ns at 174.36855371291574 "$node_(2) setdest 126373 10600 15.0" 
$ns at 352.4895479557081 "$node_(2) setdest 153526 46937 4.0" 
$ns at 382.88956924805836 "$node_(2) setdest 51309 31779 15.0" 
$ns at 523.1673477351949 "$node_(2) setdest 116122 63537 5.0" 
$ns at 564.6922309372889 "$node_(2) setdest 63879 20385 14.0" 
$ns at 620.5963697573128 "$node_(2) setdest 36979 53682 1.0" 
$ns at 658.9330587808158 "$node_(2) setdest 211537 53163 13.0" 
$ns at 780.2145300335405 "$node_(2) setdest 118153 18960 1.0" 
$ns at 820.1060718227203 "$node_(2) setdest 153479 88437 2.0" 
$ns at 867.1342492982006 "$node_(2) setdest 132713 27267 17.0" 
$ns at 0.0 "$node_(3) setdest 9951 10498 19.0" 
$ns at 124.61309896759194 "$node_(3) setdest 16446 23790 10.0" 
$ns at 209.4387041830832 "$node_(3) setdest 20960 14095 20.0" 
$ns at 274.9376767584578 "$node_(3) setdest 54041 30683 17.0" 
$ns at 373.02737068504086 "$node_(3) setdest 148982 43009 11.0" 
$ns at 499.83679394680837 "$node_(3) setdest 11862 59143 10.0" 
$ns at 591.7335071253841 "$node_(3) setdest 165683 18578 16.0" 
$ns at 724.5500599548513 "$node_(3) setdest 87246 80106 13.0" 
$ns at 757.3169863304389 "$node_(3) setdest 197530 64579 12.0" 
$ns at 858.5979168730566 "$node_(3) setdest 225832 87843 5.0" 
$ns at 0.0 "$node_(4) setdest 50936 1724 1.0" 
$ns at 33.481316299615195 "$node_(4) setdest 55241 16407 1.0" 
$ns at 67.87548128037261 "$node_(4) setdest 41830 29364 1.0" 
$ns at 106.76015415346818 "$node_(4) setdest 92426 15942 17.0" 
$ns at 228.98106672618704 "$node_(4) setdest 123898 32180 9.0" 
$ns at 289.5349302282792 "$node_(4) setdest 58133 32813 17.0" 
$ns at 482.3398564729159 "$node_(4) setdest 194047 6943 18.0" 
$ns at 560.7658156993327 "$node_(4) setdest 198287 12441 14.0" 
$ns at 605.4574100362823 "$node_(4) setdest 47642 70789 1.0" 
$ns at 639.620417768622 "$node_(4) setdest 112686 77076 5.0" 
$ns at 701.7379851597715 "$node_(4) setdest 125655 15271 19.0" 
$ns at 0.0 "$node_(5) setdest 58720 11087 15.0" 
$ns at 85.37380891832503 "$node_(5) setdest 88348 8241 19.0" 
$ns at 292.2479487739021 "$node_(5) setdest 46489 46882 5.0" 
$ns at 347.7207764057052 "$node_(5) setdest 9819 29442 1.0" 
$ns at 385.56385607911835 "$node_(5) setdest 181558 22905 18.0" 
$ns at 531.8571055673326 "$node_(5) setdest 147335 16169 15.0" 
$ns at 573.1322496403825 "$node_(5) setdest 183868 69286 18.0" 
$ns at 751.4882795192336 "$node_(5) setdest 15125 8980 5.0" 
$ns at 798.1074884313776 "$node_(5) setdest 113276 15342 1.0" 
$ns at 834.050341361265 "$node_(5) setdest 26638 18792 11.0" 
$ns at 881.147669579628 "$node_(5) setdest 217604 35659 2.0" 
$ns at 0.0 "$node_(6) setdest 3522 31376 10.0" 
$ns at 126.84108722766844 "$node_(6) setdest 74281 9256 3.0" 
$ns at 183.1494279603542 "$node_(6) setdest 50479 12213 1.0" 
$ns at 216.7090271224809 "$node_(6) setdest 25723 24355 14.0" 
$ns at 343.7557876920686 "$node_(6) setdest 828 2542 10.0" 
$ns at 386.3073868493423 "$node_(6) setdest 167728 11259 3.0" 
$ns at 421.7651394030686 "$node_(6) setdest 26806 5750 12.0" 
$ns at 510.62621951049834 "$node_(6) setdest 189256 36043 19.0" 
$ns at 598.5735354684195 "$node_(6) setdest 43680 59110 4.0" 
$ns at 629.333075586791 "$node_(6) setdest 122881 51867 5.0" 
$ns at 664.5968453211609 "$node_(6) setdest 200409 45716 3.0" 
$ns at 701.8636058417055 "$node_(6) setdest 77787 74224 6.0" 
$ns at 784.1488312113713 "$node_(6) setdest 188255 16910 16.0" 
$ns at 824.9996524612963 "$node_(6) setdest 236755 115 3.0" 
$ns at 866.9383010792316 "$node_(6) setdest 23570 45852 13.0" 
$ns at 0.0 "$node_(7) setdest 36155 28482 6.0" 
$ns at 51.63323263487958 "$node_(7) setdest 57576 7068 18.0" 
$ns at 181.44566540843564 "$node_(7) setdest 119762 38086 5.0" 
$ns at 215.23812529895642 "$node_(7) setdest 37278 13814 18.0" 
$ns at 341.3742584166473 "$node_(7) setdest 156014 50416 6.0" 
$ns at 381.29585276846115 "$node_(7) setdest 163623 53746 14.0" 
$ns at 414.5451015002104 "$node_(7) setdest 44058 59929 5.0" 
$ns at 489.19844899824085 "$node_(7) setdest 106499 23533 19.0" 
$ns at 667.8803602665046 "$node_(7) setdest 227109 65238 19.0" 
$ns at 735.1516164137554 "$node_(7) setdest 168265 66323 18.0" 
$ns at 0.0 "$node_(8) setdest 24541 22729 5.0" 
$ns at 63.92593469049798 "$node_(8) setdest 70241 11639 4.0" 
$ns at 132.42650098295064 "$node_(8) setdest 56093 12395 10.0" 
$ns at 171.06300543832333 "$node_(8) setdest 96394 4547 17.0" 
$ns at 362.1928005823802 "$node_(8) setdest 94001 31812 19.0" 
$ns at 398.9902770631844 "$node_(8) setdest 179367 4300 2.0" 
$ns at 444.83972233035064 "$node_(8) setdest 186853 10692 18.0" 
$ns at 476.8972072956145 "$node_(8) setdest 172879 11288 5.0" 
$ns at 542.8458569212931 "$node_(8) setdest 27856 56713 11.0" 
$ns at 672.5293311402223 "$node_(8) setdest 203821 9607 16.0" 
$ns at 791.0979480712829 "$node_(8) setdest 37692 66218 1.0" 
$ns at 827.3097755494482 "$node_(8) setdest 112445 55266 7.0" 
$ns at 861.9830335783395 "$node_(8) setdest 10785 7922 3.0" 
$ns at 0.0 "$node_(9) setdest 65782 17548 1.0" 
$ns at 37.47463312944947 "$node_(9) setdest 38811 14930 7.0" 
$ns at 108.44981361640438 "$node_(9) setdest 53664 23922 14.0" 
$ns at 230.12221017147124 "$node_(9) setdest 109997 29677 1.0" 
$ns at 260.7516864453471 "$node_(9) setdest 26221 44341 11.0" 
$ns at 317.4393350433976 "$node_(9) setdest 151755 15785 10.0" 
$ns at 372.6852380045499 "$node_(9) setdest 129895 48735 17.0" 
$ns at 453.83070814955795 "$node_(9) setdest 74374 4592 20.0" 
$ns at 498.87245038495297 "$node_(9) setdest 148895 60930 3.0" 
$ns at 541.1293448968954 "$node_(9) setdest 181251 20584 2.0" 
$ns at 589.5666121599234 "$node_(9) setdest 189235 37365 6.0" 
$ns at 652.1398024635375 "$node_(9) setdest 93656 44038 17.0" 
$ns at 719.8505947914537 "$node_(9) setdest 20455 9896 8.0" 
$ns at 808.9476369849785 "$node_(9) setdest 251001 61196 14.0" 
$ns at 871.0422169898955 "$node_(9) setdest 190600 87584 6.0" 
$ns at 0.0 "$node_(10) setdest 55617 31223 1.0" 
$ns at 37.951476364163 "$node_(10) setdest 78011 14191 11.0" 
$ns at 118.69595743968628 "$node_(10) setdest 71925 15632 5.0" 
$ns at 155.95912870089526 "$node_(10) setdest 46671 30274 6.0" 
$ns at 223.8907459500167 "$node_(10) setdest 102490 6888 6.0" 
$ns at 309.8744835203097 "$node_(10) setdest 57307 49227 6.0" 
$ns at 378.19830674154963 "$node_(10) setdest 63845 37669 16.0" 
$ns at 422.2006319121202 "$node_(10) setdest 60607 19576 15.0" 
$ns at 540.2548463940457 "$node_(10) setdest 83119 7810 2.0" 
$ns at 574.7574598827849 "$node_(10) setdest 62231 44943 1.0" 
$ns at 607.307478520486 "$node_(10) setdest 102354 41331 14.0" 
$ns at 727.7195682588574 "$node_(10) setdest 157271 28785 15.0" 
$ns at 780.6795645151465 "$node_(10) setdest 86840 87742 17.0" 
$ns at 841.6136784924943 "$node_(10) setdest 79333 21170 9.0" 
$ns at 0.0 "$node_(11) setdest 18945 20573 16.0" 
$ns at 97.30434989693185 "$node_(11) setdest 34763 10179 12.0" 
$ns at 163.33194766442656 "$node_(11) setdest 128343 6407 11.0" 
$ns at 200.80152625482833 "$node_(11) setdest 44137 44045 17.0" 
$ns at 365.4278643807638 "$node_(11) setdest 90380 727 9.0" 
$ns at 438.1906715094123 "$node_(11) setdest 154175 39547 3.0" 
$ns at 471.76003270672044 "$node_(11) setdest 90552 34797 15.0" 
$ns at 591.3053506161813 "$node_(11) setdest 37321 56680 2.0" 
$ns at 639.5640397703334 "$node_(11) setdest 117957 48847 7.0" 
$ns at 732.5627059398787 "$node_(11) setdest 98028 14228 12.0" 
$ns at 769.085020536656 "$node_(11) setdest 86969 22720 14.0" 
$ns at 0.0 "$node_(12) setdest 32234 24266 15.0" 
$ns at 174.99293069764877 "$node_(12) setdest 42626 22316 1.0" 
$ns at 214.91183105372136 "$node_(12) setdest 6434 23422 12.0" 
$ns at 290.3067902482893 "$node_(12) setdest 69989 46703 8.0" 
$ns at 392.9170118087341 "$node_(12) setdest 128447 2135 1.0" 
$ns at 427.4024236804274 "$node_(12) setdest 75801 57736 12.0" 
$ns at 522.8336299826448 "$node_(12) setdest 110082 67163 19.0" 
$ns at 628.8784693892771 "$node_(12) setdest 221138 25177 19.0" 
$ns at 794.7619167294815 "$node_(12) setdest 239674 50919 12.0" 
$ns at 831.3827583914294 "$node_(12) setdest 44402 53900 16.0" 
$ns at 0.0 "$node_(13) setdest 93280 27751 14.0" 
$ns at 158.24173564170735 "$node_(13) setdest 112093 35253 11.0" 
$ns at 260.03094047598904 "$node_(13) setdest 150170 34448 17.0" 
$ns at 407.23283223978433 "$node_(13) setdest 126824 10285 7.0" 
$ns at 454.39647262336337 "$node_(13) setdest 131525 21044 14.0" 
$ns at 539.6958088465906 "$node_(13) setdest 110261 32358 4.0" 
$ns at 583.1577229767129 "$node_(13) setdest 71399 75940 1.0" 
$ns at 617.7020359520593 "$node_(13) setdest 21279 21836 17.0" 
$ns at 763.2559683476219 "$node_(13) setdest 149107 52195 12.0" 
$ns at 841.9224258451352 "$node_(13) setdest 205819 63923 1.0" 
$ns at 873.3004170648073 "$node_(13) setdest 98514 78335 2.0" 
$ns at 0.0 "$node_(14) setdest 48215 8713 14.0" 
$ns at 103.91223758538551 "$node_(14) setdest 67060 7560 5.0" 
$ns at 172.85116532564302 "$node_(14) setdest 133106 32510 17.0" 
$ns at 359.3324314589755 "$node_(14) setdest 64626 12622 3.0" 
$ns at 409.4707279125511 "$node_(14) setdest 77994 26361 7.0" 
$ns at 468.32932286813644 "$node_(14) setdest 3709 5016 19.0" 
$ns at 500.32230472983997 "$node_(14) setdest 130156 8322 13.0" 
$ns at 614.0567688056681 "$node_(14) setdest 69673 22581 17.0" 
$ns at 662.8864763787822 "$node_(14) setdest 128193 47704 9.0" 
$ns at 745.2331842892061 "$node_(14) setdest 148213 24081 6.0" 
$ns at 799.3246738771335 "$node_(14) setdest 248116 16721 10.0" 
$ns at 862.2388410487307 "$node_(14) setdest 42552 84633 1.0" 
$ns at 897.8577048889762 "$node_(14) setdest 81633 55907 9.0" 
$ns at 0.0 "$node_(15) setdest 20323 786 13.0" 
$ns at 86.72064368015256 "$node_(15) setdest 93354 5789 6.0" 
$ns at 169.8622919145111 "$node_(15) setdest 44724 3931 12.0" 
$ns at 274.96905336214286 "$node_(15) setdest 149966 12614 7.0" 
$ns at 341.7079832076697 "$node_(15) setdest 128681 43488 18.0" 
$ns at 533.6578730932442 "$node_(15) setdest 5420 8851 10.0" 
$ns at 594.2201496157332 "$node_(15) setdest 127542 48116 16.0" 
$ns at 755.5782723187083 "$node_(15) setdest 184767 29477 3.0" 
$ns at 808.2932800623621 "$node_(15) setdest 30360 32206 11.0" 
$ns at 863.8346892975915 "$node_(15) setdest 238292 60497 4.0" 
$ns at 0.0 "$node_(16) setdest 27337 30281 5.0" 
$ns at 54.70717894391136 "$node_(16) setdest 8808 31538 2.0" 
$ns at 103.2501311875061 "$node_(16) setdest 61814 17166 16.0" 
$ns at 232.95620057440297 "$node_(16) setdest 129397 25388 5.0" 
$ns at 303.30230762495705 "$node_(16) setdest 63643 39320 13.0" 
$ns at 427.04765927003416 "$node_(16) setdest 64699 4791 1.0" 
$ns at 461.56059982352076 "$node_(16) setdest 123350 31436 5.0" 
$ns at 508.6976860198599 "$node_(16) setdest 36144 5155 1.0" 
$ns at 539.6477707995975 "$node_(16) setdest 58242 7790 7.0" 
$ns at 618.2845711753226 "$node_(16) setdest 74174 8716 19.0" 
$ns at 758.4086285404907 "$node_(16) setdest 220182 53979 2.0" 
$ns at 804.6427682977742 "$node_(16) setdest 116008 3040 2.0" 
$ns at 846.3820719284621 "$node_(16) setdest 94967 43258 9.0" 
$ns at 885.5510858326306 "$node_(16) setdest 72370 8857 6.0" 
$ns at 0.0 "$node_(17) setdest 39346 18126 12.0" 
$ns at 139.1704157905437 "$node_(17) setdest 18545 29647 2.0" 
$ns at 174.74726993951242 "$node_(17) setdest 4502 24970 14.0" 
$ns at 343.01478611421476 "$node_(17) setdest 122553 27917 4.0" 
$ns at 393.62461397542586 "$node_(17) setdest 156725 27037 3.0" 
$ns at 424.2856358302809 "$node_(17) setdest 85544 34265 7.0" 
$ns at 456.35831509989333 "$node_(17) setdest 190589 58731 1.0" 
$ns at 492.45025364149535 "$node_(17) setdest 71376 10044 5.0" 
$ns at 544.2109328964505 "$node_(17) setdest 130479 48884 17.0" 
$ns at 629.287585444904 "$node_(17) setdest 181755 42957 3.0" 
$ns at 668.1726491081488 "$node_(17) setdest 132450 54722 2.0" 
$ns at 713.7130361625237 "$node_(17) setdest 165692 21529 8.0" 
$ns at 766.0834720939475 "$node_(17) setdest 4929 17656 9.0" 
$ns at 868.4798575852841 "$node_(17) setdest 250093 77097 8.0" 
$ns at 0.0 "$node_(18) setdest 43294 15714 15.0" 
$ns at 57.68605998046685 "$node_(18) setdest 12196 16513 13.0" 
$ns at 113.19546063558217 "$node_(18) setdest 87241 11652 15.0" 
$ns at 222.22769163235603 "$node_(18) setdest 52061 36123 3.0" 
$ns at 271.6379244569154 "$node_(18) setdest 128467 47899 8.0" 
$ns at 319.74909392156763 "$node_(18) setdest 160997 13749 7.0" 
$ns at 381.3407750818429 "$node_(18) setdest 135842 26913 8.0" 
$ns at 461.6940137681163 "$node_(18) setdest 103486 1664 7.0" 
$ns at 515.2030433446233 "$node_(18) setdest 194023 32386 17.0" 
$ns at 681.9451145074315 "$node_(18) setdest 20297 37562 13.0" 
$ns at 825.5351630013239 "$node_(18) setdest 155269 1953 5.0" 
$ns at 883.6543115336995 "$node_(18) setdest 146040 27724 12.0" 
$ns at 0.0 "$node_(19) setdest 92398 27149 18.0" 
$ns at 142.02299267674783 "$node_(19) setdest 94860 4931 12.0" 
$ns at 221.505604099069 "$node_(19) setdest 81602 35889 7.0" 
$ns at 256.0388735582876 "$node_(19) setdest 80459 3743 17.0" 
$ns at 305.39851552006235 "$node_(19) setdest 53820 32180 14.0" 
$ns at 401.06033178726295 "$node_(19) setdest 160891 37393 19.0" 
$ns at 489.2457703363788 "$node_(19) setdest 81495 27587 18.0" 
$ns at 587.4000396012841 "$node_(19) setdest 125468 60674 14.0" 
$ns at 717.2656927626094 "$node_(19) setdest 194804 57935 15.0" 
$ns at 895.6142995493746 "$node_(19) setdest 104670 53584 4.0" 
$ns at 0.0 "$node_(20) setdest 38819 9359 1.0" 
$ns at 32.01987374922546 "$node_(20) setdest 35857 1774 19.0" 
$ns at 213.9116085380673 "$node_(20) setdest 118399 25428 15.0" 
$ns at 310.2592307099781 "$node_(20) setdest 152190 49010 19.0" 
$ns at 508.42026956478264 "$node_(20) setdest 201102 18176 2.0" 
$ns at 556.0156613337191 "$node_(20) setdest 82902 53353 2.0" 
$ns at 599.3534313062157 "$node_(20) setdest 219614 34579 16.0" 
$ns at 781.6952575184495 "$node_(20) setdest 118438 54724 12.0" 
$ns at 886.2703653025148 "$node_(20) setdest 204097 44637 4.0" 
$ns at 0.0 "$node_(21) setdest 21047 10092 7.0" 
$ns at 41.979107373357394 "$node_(21) setdest 10993 1735 19.0" 
$ns at 212.71057977934305 "$node_(21) setdest 70532 29052 9.0" 
$ns at 283.2272883966005 "$node_(21) setdest 37829 23274 4.0" 
$ns at 322.3336755749108 "$node_(21) setdest 140259 5826 17.0" 
$ns at 453.67841181938667 "$node_(21) setdest 34626 67913 13.0" 
$ns at 594.646876108907 "$node_(21) setdest 130962 24956 19.0" 
$ns at 640.9514178898055 "$node_(21) setdest 89572 17757 6.0" 
$ns at 723.6363783383936 "$node_(21) setdest 132677 80947 2.0" 
$ns at 771.3483036594993 "$node_(21) setdest 101651 7314 13.0" 
$ns at 0.0 "$node_(22) setdest 65703 25531 9.0" 
$ns at 69.2062292283598 "$node_(22) setdest 30114 29676 2.0" 
$ns at 107.07973759685927 "$node_(22) setdest 19071 27346 7.0" 
$ns at 188.68415370294014 "$node_(22) setdest 17367 39378 20.0" 
$ns at 241.77583984533933 "$node_(22) setdest 4296 40122 7.0" 
$ns at 276.1956412927714 "$node_(22) setdest 80691 20637 19.0" 
$ns at 412.620650478543 "$node_(22) setdest 57533 40702 4.0" 
$ns at 445.0379339124709 "$node_(22) setdest 104945 46011 5.0" 
$ns at 516.3837419772672 "$node_(22) setdest 144419 38790 4.0" 
$ns at 556.9809395711259 "$node_(22) setdest 104831 43235 16.0" 
$ns at 740.6517760340754 "$node_(22) setdest 142051 77081 1.0" 
$ns at 773.6259728745796 "$node_(22) setdest 241449 84514 1.0" 
$ns at 812.1687221783759 "$node_(22) setdest 264276 65766 15.0" 
$ns at 881.2752031639775 "$node_(22) setdest 113401 313 15.0" 
$ns at 0.0 "$node_(23) setdest 33973 16667 15.0" 
$ns at 46.085370958292394 "$node_(23) setdest 1601 766 10.0" 
$ns at 107.48318297297169 "$node_(23) setdest 54495 3169 12.0" 
$ns at 257.0889865037276 "$node_(23) setdest 50272 26523 14.0" 
$ns at 311.39312804723374 "$node_(23) setdest 7573 54328 12.0" 
$ns at 450.99937543657916 "$node_(23) setdest 101517 36770 7.0" 
$ns at 533.1768396785671 "$node_(23) setdest 142166 64264 16.0" 
$ns at 573.1539426290437 "$node_(23) setdest 131610 53549 11.0" 
$ns at 664.938704241257 "$node_(23) setdest 219001 49365 20.0" 
$ns at 857.8603932850154 "$node_(23) setdest 230906 10666 17.0" 
$ns at 0.0 "$node_(24) setdest 15146 25395 11.0" 
$ns at 54.21771417464933 "$node_(24) setdest 49150 10437 5.0" 
$ns at 96.39576118123132 "$node_(24) setdest 81079 13624 6.0" 
$ns at 147.93326202675408 "$node_(24) setdest 62490 12230 1.0" 
$ns at 179.30499395329923 "$node_(24) setdest 126480 38294 2.0" 
$ns at 210.2847159567962 "$node_(24) setdest 67479 6300 12.0" 
$ns at 353.07745901204737 "$node_(24) setdest 38365 6422 1.0" 
$ns at 389.88907417032567 "$node_(24) setdest 66893 43393 5.0" 
$ns at 445.51297001267665 "$node_(24) setdest 8876 27128 3.0" 
$ns at 481.52868931514615 "$node_(24) setdest 98331 24448 4.0" 
$ns at 547.4191798685238 "$node_(24) setdest 160119 25509 18.0" 
$ns at 668.0056657917893 "$node_(24) setdest 28384 64971 16.0" 
$ns at 764.4474317704958 "$node_(24) setdest 3050 29049 12.0" 
$ns at 886.7372025045404 "$node_(24) setdest 110234 1816 6.0" 
$ns at 0.0 "$node_(25) setdest 89075 12102 13.0" 
$ns at 94.8082351238666 "$node_(25) setdest 62164 18520 18.0" 
$ns at 286.58635797455605 "$node_(25) setdest 6969 40983 9.0" 
$ns at 341.30419739483176 "$node_(25) setdest 47066 48855 12.0" 
$ns at 392.8959951249652 "$node_(25) setdest 141229 3314 18.0" 
$ns at 516.2578712711003 "$node_(25) setdest 155924 46495 13.0" 
$ns at 626.4468453189353 "$node_(25) setdest 101310 43558 5.0" 
$ns at 694.4075193099269 "$node_(25) setdest 180569 5328 1.0" 
$ns at 728.5763306577148 "$node_(25) setdest 55247 67890 19.0" 
$ns at 793.6037004193737 "$node_(25) setdest 212176 69522 11.0" 
$ns at 867.1463065847897 "$node_(25) setdest 207003 31064 17.0" 
$ns at 0.0 "$node_(26) setdest 16829 5169 9.0" 
$ns at 75.61563865510243 "$node_(26) setdest 93934 17540 10.0" 
$ns at 139.50432863113838 "$node_(26) setdest 21748 8559 14.0" 
$ns at 210.78808493738887 "$node_(26) setdest 50243 34003 3.0" 
$ns at 265.22450757127615 "$node_(26) setdest 2062 22993 5.0" 
$ns at 316.3017605254915 "$node_(26) setdest 47375 4244 1.0" 
$ns at 354.95516629667225 "$node_(26) setdest 162508 30359 16.0" 
$ns at 489.6432614883129 "$node_(26) setdest 116501 49193 16.0" 
$ns at 604.8373793505754 "$node_(26) setdest 209563 12602 4.0" 
$ns at 673.4398792164071 "$node_(26) setdest 3237 48049 7.0" 
$ns at 729.1192083388191 "$node_(26) setdest 239099 76619 1.0" 
$ns at 765.4435251731435 "$node_(26) setdest 21484 66718 11.0" 
$ns at 851.472105358601 "$node_(26) setdest 48782 22422 16.0" 
$ns at 0.0 "$node_(27) setdest 28543 21731 6.0" 
$ns at 42.612879288693684 "$node_(27) setdest 46624 18457 20.0" 
$ns at 218.74807102185616 "$node_(27) setdest 67535 20736 11.0" 
$ns at 337.55404231418 "$node_(27) setdest 95008 50580 20.0" 
$ns at 540.6004521430011 "$node_(27) setdest 25769 42848 11.0" 
$ns at 618.2100621685684 "$node_(27) setdest 1155 76520 5.0" 
$ns at 688.5514227102649 "$node_(27) setdest 162668 77336 8.0" 
$ns at 795.9514985724836 "$node_(27) setdest 222632 51910 12.0" 
$ns at 843.809123426091 "$node_(27) setdest 104498 64261 5.0" 
$ns at 874.4470309862915 "$node_(27) setdest 158766 27715 16.0" 
$ns at 0.0 "$node_(28) setdest 89772 2832 3.0" 
$ns at 56.97857671922581 "$node_(28) setdest 67022 31137 15.0" 
$ns at 168.47379272521232 "$node_(28) setdest 13105 13953 4.0" 
$ns at 198.56768245207002 "$node_(28) setdest 76482 11766 16.0" 
$ns at 325.20552294926426 "$node_(28) setdest 2174 25815 20.0" 
$ns at 531.8042547994927 "$node_(28) setdest 195829 27817 8.0" 
$ns at 566.305236273068 "$node_(28) setdest 225307 63945 11.0" 
$ns at 599.034316795294 "$node_(28) setdest 64188 9555 13.0" 
$ns at 730.2419464979598 "$node_(28) setdest 250194 49957 17.0" 
$ns at 791.8126175419075 "$node_(28) setdest 119763 10159 13.0" 
$ns at 875.4114901255541 "$node_(28) setdest 35073 13628 1.0" 
$ns at 0.0 "$node_(29) setdest 48024 13756 19.0" 
$ns at 83.7041457597876 "$node_(29) setdest 18649 24523 19.0" 
$ns at 263.8896809498689 "$node_(29) setdest 114478 53867 1.0" 
$ns at 300.90121062285385 "$node_(29) setdest 49339 27057 3.0" 
$ns at 332.07942097453923 "$node_(29) setdest 16909 48912 1.0" 
$ns at 362.53983373129404 "$node_(29) setdest 85847 41924 15.0" 
$ns at 503.32960302721983 "$node_(29) setdest 30867 19804 19.0" 
$ns at 583.5060990001231 "$node_(29) setdest 414 20484 5.0" 
$ns at 647.9515826253023 "$node_(29) setdest 43510 69762 13.0" 
$ns at 767.4770497230229 "$node_(29) setdest 215379 11691 9.0" 
$ns at 850.1833351616566 "$node_(29) setdest 216232 49392 14.0" 
$ns at 0.0 "$node_(30) setdest 27851 17252 20.0" 
$ns at 74.62533658685518 "$node_(30) setdest 50678 9582 7.0" 
$ns at 171.27225447611522 "$node_(30) setdest 122295 41754 9.0" 
$ns at 243.580254174218 "$node_(30) setdest 15852 39339 17.0" 
$ns at 413.170406502201 "$node_(30) setdest 98410 37506 13.0" 
$ns at 480.30431694501357 "$node_(30) setdest 125836 56323 19.0" 
$ns at 627.9469483415608 "$node_(30) setdest 178131 52557 12.0" 
$ns at 693.4568156880424 "$node_(30) setdest 183344 4821 8.0" 
$ns at 728.9554953727887 "$node_(30) setdest 144114 74719 12.0" 
$ns at 843.006698326794 "$node_(30) setdest 175221 45965 10.0" 
$ns at 0.0 "$node_(31) setdest 13770 18779 5.0" 
$ns at 56.39817572940808 "$node_(31) setdest 63856 6561 16.0" 
$ns at 172.509737440121 "$node_(31) setdest 26871 12081 1.0" 
$ns at 207.62348066261336 "$node_(31) setdest 87378 12749 12.0" 
$ns at 290.05997141190574 "$node_(31) setdest 57656 32888 4.0" 
$ns at 324.0946192545696 "$node_(31) setdest 70323 17134 3.0" 
$ns at 368.01368530807326 "$node_(31) setdest 149672 34482 5.0" 
$ns at 417.2796955510888 "$node_(31) setdest 24382 4674 5.0" 
$ns at 470.8581935806129 "$node_(31) setdest 152576 12919 8.0" 
$ns at 576.1508200148794 "$node_(31) setdest 91150 14081 1.0" 
$ns at 612.6931522336781 "$node_(31) setdest 49092 18972 16.0" 
$ns at 783.2195495268136 "$node_(31) setdest 221799 8100 12.0" 
$ns at 0.0 "$node_(32) setdest 37280 17724 13.0" 
$ns at 108.34836709987353 "$node_(32) setdest 22461 10583 16.0" 
$ns at 145.58884956248625 "$node_(32) setdest 15765 27244 1.0" 
$ns at 176.239351338034 "$node_(32) setdest 57950 3571 16.0" 
$ns at 318.04978375358047 "$node_(32) setdest 142427 36258 17.0" 
$ns at 435.64538966395884 "$node_(32) setdest 124998 20092 3.0" 
$ns at 480.46544191504574 "$node_(32) setdest 115931 11566 1.0" 
$ns at 510.78480782786 "$node_(32) setdest 204281 20167 9.0" 
$ns at 581.2014923819556 "$node_(32) setdest 186335 30779 6.0" 
$ns at 632.0049073301028 "$node_(32) setdest 6849 72993 8.0" 
$ns at 686.7311437563976 "$node_(32) setdest 81842 4794 12.0" 
$ns at 804.6868099342047 "$node_(32) setdest 81155 52632 2.0" 
$ns at 835.1023286641872 "$node_(32) setdest 163593 65567 16.0" 
$ns at 0.0 "$node_(33) setdest 41329 30062 3.0" 
$ns at 30.597027593065626 "$node_(33) setdest 44186 15783 7.0" 
$ns at 110.24217892536635 "$node_(33) setdest 35469 10290 10.0" 
$ns at 162.76765216959126 "$node_(33) setdest 40976 2997 11.0" 
$ns at 257.891788451825 "$node_(33) setdest 101276 33193 1.0" 
$ns at 296.73366222815173 "$node_(33) setdest 55749 52490 15.0" 
$ns at 352.46175487592353 "$node_(33) setdest 87832 17538 1.0" 
$ns at 389.10162084557305 "$node_(33) setdest 24850 25583 19.0" 
$ns at 490.3468176097051 "$node_(33) setdest 62304 50218 16.0" 
$ns at 621.7403464821758 "$node_(33) setdest 41418 72142 9.0" 
$ns at 736.916156078811 "$node_(33) setdest 45942 28266 5.0" 
$ns at 768.4655275399981 "$node_(33) setdest 120044 74679 1.0" 
$ns at 801.7839497961652 "$node_(33) setdest 106927 48794 11.0" 
$ns at 0.0 "$node_(34) setdest 3513 188 10.0" 
$ns at 108.52996187856563 "$node_(34) setdest 55570 11263 12.0" 
$ns at 186.94913699298036 "$node_(34) setdest 53246 36194 17.0" 
$ns at 338.43768092732495 "$node_(34) setdest 113402 13341 18.0" 
$ns at 409.5397554032546 "$node_(34) setdest 147440 61779 16.0" 
$ns at 525.4794298411791 "$node_(34) setdest 194202 46358 8.0" 
$ns at 557.1530886738801 "$node_(34) setdest 193900 55660 1.0" 
$ns at 592.7935499373714 "$node_(34) setdest 63037 6116 8.0" 
$ns at 699.1967622088985 "$node_(34) setdest 143219 42815 8.0" 
$ns at 783.9173920895779 "$node_(34) setdest 136514 65116 1.0" 
$ns at 814.4385002142724 "$node_(34) setdest 7726 24370 8.0" 
$ns at 0.0 "$node_(35) setdest 47130 5988 4.0" 
$ns at 49.58481421059377 "$node_(35) setdest 40226 27465 6.0" 
$ns at 124.00974427502513 "$node_(35) setdest 32086 19109 12.0" 
$ns at 256.1118925565995 "$node_(35) setdest 104049 9839 3.0" 
$ns at 310.46451366415505 "$node_(35) setdest 127766 12117 10.0" 
$ns at 386.49951125420046 "$node_(35) setdest 41897 10287 18.0" 
$ns at 419.2873232939809 "$node_(35) setdest 132982 25309 19.0" 
$ns at 487.2269093239357 "$node_(35) setdest 90257 44414 12.0" 
$ns at 600.7092359290109 "$node_(35) setdest 180894 31066 5.0" 
$ns at 653.1094164024436 "$node_(35) setdest 196765 57388 15.0" 
$ns at 718.9127098916449 "$node_(35) setdest 138328 45031 3.0" 
$ns at 750.1721575138131 "$node_(35) setdest 85216 5961 11.0" 
$ns at 878.4873647617064 "$node_(35) setdest 137144 47657 9.0" 
$ns at 0.0 "$node_(36) setdest 43422 24528 6.0" 
$ns at 62.923521622423344 "$node_(36) setdest 92788 4599 16.0" 
$ns at 125.29697879121872 "$node_(36) setdest 12809 24889 17.0" 
$ns at 236.8653686355414 "$node_(36) setdest 110168 18817 14.0" 
$ns at 306.11774327752664 "$node_(36) setdest 116562 40245 18.0" 
$ns at 398.3532405267888 "$node_(36) setdest 62176 8002 2.0" 
$ns at 440.2568058348319 "$node_(36) setdest 126258 51047 11.0" 
$ns at 574.2209017474568 "$node_(36) setdest 178897 16914 12.0" 
$ns at 659.9174963427198 "$node_(36) setdest 62756 25327 12.0" 
$ns at 750.7403809054741 "$node_(36) setdest 125889 36961 7.0" 
$ns at 810.261982244253 "$node_(36) setdest 127982 49572 2.0" 
$ns at 850.9258854905532 "$node_(36) setdest 110155 18138 17.0" 
$ns at 0.0 "$node_(37) setdest 16619 5598 7.0" 
$ns at 62.537638561602535 "$node_(37) setdest 66975 28120 8.0" 
$ns at 160.95599412392983 "$node_(37) setdest 799 38016 17.0" 
$ns at 307.84026240572655 "$node_(37) setdest 75458 26032 19.0" 
$ns at 487.5896443174646 "$node_(37) setdest 132548 6064 18.0" 
$ns at 634.6220192997079 "$node_(37) setdest 193237 38016 17.0" 
$ns at 786.0635292914126 "$node_(37) setdest 111186 62240 8.0" 
$ns at 825.1030814940092 "$node_(37) setdest 96637 7808 3.0" 
$ns at 872.119114935161 "$node_(37) setdest 124249 81457 6.0" 
$ns at 0.0 "$node_(38) setdest 78672 31099 14.0" 
$ns at 117.5143810938449 "$node_(38) setdest 67982 11334 10.0" 
$ns at 242.51646830564152 "$node_(38) setdest 32934 4132 16.0" 
$ns at 412.57510559141156 "$node_(38) setdest 90520 22857 17.0" 
$ns at 546.1315441266015 "$node_(38) setdest 152135 64641 1.0" 
$ns at 577.8389156996182 "$node_(38) setdest 157059 19912 18.0" 
$ns at 709.1083602102356 "$node_(38) setdest 72738 2004 9.0" 
$ns at 813.2050338101401 "$node_(38) setdest 159939 62593 14.0" 
$ns at 884.7735961258611 "$node_(38) setdest 9938 21422 18.0" 
$ns at 0.0 "$node_(39) setdest 92041 4783 7.0" 
$ns at 60.74606628672224 "$node_(39) setdest 90979 9443 1.0" 
$ns at 98.50419367773914 "$node_(39) setdest 59686 504 6.0" 
$ns at 156.54949284761457 "$node_(39) setdest 65497 5790 13.0" 
$ns at 200.16158222620606 "$node_(39) setdest 17143 5772 15.0" 
$ns at 336.2372832293802 "$node_(39) setdest 107433 2494 20.0" 
$ns at 548.2716848230968 "$node_(39) setdest 4940 39182 14.0" 
$ns at 702.2373622320222 "$node_(39) setdest 51615 37407 6.0" 
$ns at 770.1951810588916 "$node_(39) setdest 196423 80172 19.0" 
$ns at 0.0 "$node_(40) setdest 23497 27243 5.0" 
$ns at 55.630216105531076 "$node_(40) setdest 13324 18663 10.0" 
$ns at 145.1100177716822 "$node_(40) setdest 17351 12775 1.0" 
$ns at 178.03696501359315 "$node_(40) setdest 53141 38761 11.0" 
$ns at 262.9342818496193 "$node_(40) setdest 3189 54310 3.0" 
$ns at 308.32830672158985 "$node_(40) setdest 91093 19673 5.0" 
$ns at 383.4830691361975 "$node_(40) setdest 64366 56375 18.0" 
$ns at 466.6618302065846 "$node_(40) setdest 1457 39062 6.0" 
$ns at 537.8461614573082 "$node_(40) setdest 101854 30823 13.0" 
$ns at 666.4748299942806 "$node_(40) setdest 217607 44705 6.0" 
$ns at 740.2925000478797 "$node_(40) setdest 183610 82598 2.0" 
$ns at 779.5514453489387 "$node_(40) setdest 198195 67599 16.0" 
$ns at 0.0 "$node_(41) setdest 56446 15241 18.0" 
$ns at 124.40059330702046 "$node_(41) setdest 51615 23912 18.0" 
$ns at 302.02842403463626 "$node_(41) setdest 67463 7615 19.0" 
$ns at 388.4372247071581 "$node_(41) setdest 63768 3897 4.0" 
$ns at 445.678163584496 "$node_(41) setdest 170599 10290 10.0" 
$ns at 552.0356046648668 "$node_(41) setdest 62945 55225 13.0" 
$ns at 623.0010872229789 "$node_(41) setdest 98069 40451 8.0" 
$ns at 655.7856210432495 "$node_(41) setdest 41933 10904 16.0" 
$ns at 700.7715773881654 "$node_(41) setdest 2127 11765 1.0" 
$ns at 736.7225201229277 "$node_(41) setdest 82031 22728 2.0" 
$ns at 770.6116629445996 "$node_(41) setdest 121225 6672 12.0" 
$ns at 823.9774641039129 "$node_(41) setdest 146152 26101 11.0" 
$ns at 0.0 "$node_(42) setdest 2355 16359 18.0" 
$ns at 125.4279655192589 "$node_(42) setdest 45541 5051 6.0" 
$ns at 159.96910099899605 "$node_(42) setdest 82636 31593 16.0" 
$ns at 207.2428730599365 "$node_(42) setdest 109882 42046 17.0" 
$ns at 364.22126145557115 "$node_(42) setdest 63679 4373 3.0" 
$ns at 422.31715066735796 "$node_(42) setdest 171018 44125 10.0" 
$ns at 540.2443979457746 "$node_(42) setdest 189909 13180 6.0" 
$ns at 626.6669527922222 "$node_(42) setdest 171584 17747 3.0" 
$ns at 658.0599130094089 "$node_(42) setdest 77342 34168 4.0" 
$ns at 697.7160012342232 "$node_(42) setdest 150014 6896 19.0" 
$ns at 890.4740730738419 "$node_(42) setdest 191630 18168 15.0" 
$ns at 0.0 "$node_(43) setdest 55031 17969 5.0" 
$ns at 69.48432428708156 "$node_(43) setdest 35891 18037 8.0" 
$ns at 129.27967975395148 "$node_(43) setdest 82079 22815 11.0" 
$ns at 212.22683844791393 "$node_(43) setdest 22053 4597 11.0" 
$ns at 323.9913576242342 "$node_(43) setdest 90491 23008 12.0" 
$ns at 470.8707565636 "$node_(43) setdest 7223 37221 13.0" 
$ns at 622.700686397971 "$node_(43) setdest 60838 9121 6.0" 
$ns at 694.9272205412194 "$node_(43) setdest 93583 67126 12.0" 
$ns at 754.2301996704846 "$node_(43) setdest 256513 80308 5.0" 
$ns at 796.3882110458879 "$node_(43) setdest 51782 10922 19.0" 
$ns at 0.0 "$node_(44) setdest 56855 25469 11.0" 
$ns at 37.57523297221475 "$node_(44) setdest 48806 11963 1.0" 
$ns at 69.42736631088331 "$node_(44) setdest 60720 21004 13.0" 
$ns at 213.10671570400365 "$node_(44) setdest 63718 42140 4.0" 
$ns at 260.7413548038923 "$node_(44) setdest 74756 45802 17.0" 
$ns at 324.2698018983813 "$node_(44) setdest 159244 45568 9.0" 
$ns at 382.3229173155013 "$node_(44) setdest 36905 39865 11.0" 
$ns at 453.99974807059294 "$node_(44) setdest 184291 42473 5.0" 
$ns at 531.2076339560922 "$node_(44) setdest 149051 22409 11.0" 
$ns at 575.4583614247993 "$node_(44) setdest 28692 41026 19.0" 
$ns at 716.4675656878125 "$node_(44) setdest 109611 80011 7.0" 
$ns at 761.4952561464236 "$node_(44) setdest 78844 85522 14.0" 
$ns at 866.5876552559349 "$node_(44) setdest 151230 44464 9.0" 
$ns at 899.6736216855345 "$node_(44) setdest 85063 73269 17.0" 
$ns at 0.0 "$node_(45) setdest 62399 26945 12.0" 
$ns at 43.70106919473582 "$node_(45) setdest 52742 23860 20.0" 
$ns at 224.56481738852418 "$node_(45) setdest 90781 40619 18.0" 
$ns at 394.70985482090236 "$node_(45) setdest 82136 20366 7.0" 
$ns at 467.36734777431343 "$node_(45) setdest 29694 48007 1.0" 
$ns at 502.60574156590866 "$node_(45) setdest 41975 13850 3.0" 
$ns at 544.4451461574727 "$node_(45) setdest 145916 3764 8.0" 
$ns at 643.4469722738819 "$node_(45) setdest 147133 31078 5.0" 
$ns at 686.0993680023198 "$node_(45) setdest 111448 71301 17.0" 
$ns at 827.9057102099548 "$node_(45) setdest 199716 83005 15.0" 
$ns at 0.0 "$node_(46) setdest 81579 4636 17.0" 
$ns at 66.82976837799407 "$node_(46) setdest 70063 9648 4.0" 
$ns at 102.6126544314146 "$node_(46) setdest 91573 1409 4.0" 
$ns at 159.16922082679204 "$node_(46) setdest 112896 43183 6.0" 
$ns at 204.20189502868084 "$node_(46) setdest 26960 18152 12.0" 
$ns at 277.73093898352647 "$node_(46) setdest 123687 26659 1.0" 
$ns at 309.4645807169744 "$node_(46) setdest 42728 10399 6.0" 
$ns at 363.75630559353846 "$node_(46) setdest 150133 2209 13.0" 
$ns at 481.6337294932133 "$node_(46) setdest 129986 27832 9.0" 
$ns at 551.047498707953 "$node_(46) setdest 7284 46418 5.0" 
$ns at 601.198890119569 "$node_(46) setdest 148977 61057 12.0" 
$ns at 673.2241037265335 "$node_(46) setdest 245918 70664 16.0" 
$ns at 755.9566934283002 "$node_(46) setdest 149951 81373 4.0" 
$ns at 809.2374748849209 "$node_(46) setdest 159707 59645 12.0" 
$ns at 0.0 "$node_(47) setdest 51504 365 7.0" 
$ns at 35.844240209747014 "$node_(47) setdest 66449 24731 8.0" 
$ns at 128.45962982006063 "$node_(47) setdest 71311 29587 14.0" 
$ns at 184.79998397316987 "$node_(47) setdest 11842 41664 6.0" 
$ns at 232.2912753389707 "$node_(47) setdest 20955 4911 14.0" 
$ns at 391.351747830055 "$node_(47) setdest 165416 33881 14.0" 
$ns at 424.80530981651657 "$node_(47) setdest 68264 8080 7.0" 
$ns at 490.974107834077 "$node_(47) setdest 186705 61964 19.0" 
$ns at 655.7287893655407 "$node_(47) setdest 208891 51748 17.0" 
$ns at 711.0891792540384 "$node_(47) setdest 37584 11963 10.0" 
$ns at 815.0748101358752 "$node_(47) setdest 62804 32500 16.0" 
$ns at 872.6777610234146 "$node_(47) setdest 218149 82501 18.0" 
$ns at 0.0 "$node_(48) setdest 71775 27397 13.0" 
$ns at 77.10361271720652 "$node_(48) setdest 88611 30487 10.0" 
$ns at 139.39344790511245 "$node_(48) setdest 62033 26434 3.0" 
$ns at 197.75522961743968 "$node_(48) setdest 12491 13621 1.0" 
$ns at 232.45478487162399 "$node_(48) setdest 52625 12710 10.0" 
$ns at 305.54326103994373 "$node_(48) setdest 126503 4470 15.0" 
$ns at 355.3881133333167 "$node_(48) setdest 17578 12768 20.0" 
$ns at 488.1498816460096 "$node_(48) setdest 175405 43886 2.0" 
$ns at 537.9273195806788 "$node_(48) setdest 40860 1025 16.0" 
$ns at 659.119243065455 "$node_(48) setdest 161509 52359 3.0" 
$ns at 703.5875647011247 "$node_(48) setdest 126182 23278 18.0" 
$ns at 825.7490515442246 "$node_(48) setdest 188206 49826 2.0" 
$ns at 866.4426566458001 "$node_(48) setdest 22466 28765 6.0" 
$ns at 898.0272188662227 "$node_(48) setdest 180458 47029 17.0" 
$ns at 0.0 "$node_(49) setdest 58834 24996 7.0" 
$ns at 62.221939633629106 "$node_(49) setdest 29374 9194 6.0" 
$ns at 143.65558932082712 "$node_(49) setdest 20502 9578 6.0" 
$ns at 226.35775964953044 "$node_(49) setdest 92716 8338 10.0" 
$ns at 352.2072992966377 "$node_(49) setdest 149667 42479 13.0" 
$ns at 389.84315926720336 "$node_(49) setdest 117625 4183 11.0" 
$ns at 450.4160073660248 "$node_(49) setdest 103143 28326 11.0" 
$ns at 529.6862223432897 "$node_(49) setdest 48533 41794 12.0" 
$ns at 650.2081329939915 "$node_(49) setdest 201778 34499 19.0" 
$ns at 745.5443209741318 "$node_(49) setdest 22666 37517 17.0" 
$ns at 0.0 "$node_(50) setdest 31054 6783 5.0" 
$ns at 71.35612316245772 "$node_(50) setdest 36531 10430 15.0" 
$ns at 188.60836582210746 "$node_(50) setdest 36936 42972 1.0" 
$ns at 220.6990997575387 "$node_(50) setdest 124373 33644 9.0" 
$ns at 262.0108839437096 "$node_(50) setdest 44373 6319 14.0" 
$ns at 294.44860827728195 "$node_(50) setdest 16003 2963 19.0" 
$ns at 372.1204998486761 "$node_(50) setdest 1939 42684 2.0" 
$ns at 417.87827147885554 "$node_(50) setdest 187450 9284 8.0" 
$ns at 517.0684596112285 "$node_(50) setdest 163801 11251 14.0" 
$ns at 572.5629263439826 "$node_(50) setdest 70719 66344 10.0" 
$ns at 700.8791559591438 "$node_(50) setdest 229775 68881 4.0" 
$ns at 738.9118327497363 "$node_(50) setdest 208380 78264 2.0" 
$ns at 784.8038456039321 "$node_(50) setdest 219585 71718 18.0" 
$ns at 0.0 "$node_(51) setdest 47727 2421 11.0" 
$ns at 92.71653461769662 "$node_(51) setdest 87199 4403 5.0" 
$ns at 130.98215832047316 "$node_(51) setdest 38187 16212 13.0" 
$ns at 201.2584573011053 "$node_(51) setdest 105864 40946 4.0" 
$ns at 239.50177196305566 "$node_(51) setdest 27043 1453 13.0" 
$ns at 304.89018628900055 "$node_(51) setdest 67737 50595 19.0" 
$ns at 519.0161271949003 "$node_(51) setdest 187115 35052 7.0" 
$ns at 603.7071301423449 "$node_(51) setdest 23054 46858 9.0" 
$ns at 639.185501062671 "$node_(51) setdest 177754 13828 9.0" 
$ns at 755.113349515703 "$node_(51) setdest 190258 17906 13.0" 
$ns at 824.9808088202232 "$node_(51) setdest 41787 47625 12.0" 
$ns at 884.8192075959926 "$node_(51) setdest 28501 29006 8.0" 
$ns at 0.0 "$node_(52) setdest 14871 5944 19.0" 
$ns at 212.94041137219773 "$node_(52) setdest 3747 18762 11.0" 
$ns at 295.66486384247344 "$node_(52) setdest 73299 15605 1.0" 
$ns at 326.6810836654087 "$node_(52) setdest 129432 43603 11.0" 
$ns at 388.33507331937477 "$node_(52) setdest 14160 29236 3.0" 
$ns at 425.3618142974652 "$node_(52) setdest 93159 13679 12.0" 
$ns at 510.33055094931103 "$node_(52) setdest 123409 6263 13.0" 
$ns at 572.7883735747054 "$node_(52) setdest 160016 17781 6.0" 
$ns at 612.9611660699628 "$node_(52) setdest 227824 43818 8.0" 
$ns at 655.0014619077787 "$node_(52) setdest 161553 59847 4.0" 
$ns at 697.4124466188226 "$node_(52) setdest 103512 65887 5.0" 
$ns at 741.4062538001237 "$node_(52) setdest 160121 28491 12.0" 
$ns at 856.5513707648128 "$node_(52) setdest 140829 7675 16.0" 
$ns at 0.0 "$node_(53) setdest 94252 28127 18.0" 
$ns at 118.05612780302738 "$node_(53) setdest 82361 7758 5.0" 
$ns at 153.20747844727228 "$node_(53) setdest 98612 30048 19.0" 
$ns at 193.37651144221547 "$node_(53) setdest 116307 18775 8.0" 
$ns at 298.48766888745286 "$node_(53) setdest 11327 25625 6.0" 
$ns at 357.71226358707906 "$node_(53) setdest 31059 2008 6.0" 
$ns at 422.9984156274049 "$node_(53) setdest 19958 45206 8.0" 
$ns at 483.4118542684072 "$node_(53) setdest 82202 69765 12.0" 
$ns at 608.2790913985358 "$node_(53) setdest 115506 69331 4.0" 
$ns at 652.3325773866954 "$node_(53) setdest 162318 65692 13.0" 
$ns at 771.3773015682148 "$node_(53) setdest 248252 29566 9.0" 
$ns at 872.1615247093739 "$node_(53) setdest 79915 32606 10.0" 
$ns at 0.0 "$node_(54) setdest 57048 26595 10.0" 
$ns at 86.41738952234867 "$node_(54) setdest 75037 23744 3.0" 
$ns at 132.47726356997504 "$node_(54) setdest 20672 30795 12.0" 
$ns at 256.8585150109802 "$node_(54) setdest 105517 46839 15.0" 
$ns at 305.82931222395683 "$node_(54) setdest 3066 41720 6.0" 
$ns at 382.9511021208528 "$node_(54) setdest 158250 62922 19.0" 
$ns at 426.64849782930116 "$node_(54) setdest 173953 13647 1.0" 
$ns at 465.8807348038017 "$node_(54) setdest 41420 68770 1.0" 
$ns at 496.7237226214859 "$node_(54) setdest 177334 753 6.0" 
$ns at 584.2262704200241 "$node_(54) setdest 129982 61510 2.0" 
$ns at 626.3628682988574 "$node_(54) setdest 162621 5326 16.0" 
$ns at 815.3803934022844 "$node_(54) setdest 202390 32072 2.0" 
$ns at 851.9575999690596 "$node_(54) setdest 200281 102 19.0" 
$ns at 0.0 "$node_(55) setdest 68569 22185 8.0" 
$ns at 102.45335513742651 "$node_(55) setdest 8791 19330 17.0" 
$ns at 198.48264245530055 "$node_(55) setdest 43618 27898 13.0" 
$ns at 232.46966226118957 "$node_(55) setdest 97275 41115 17.0" 
$ns at 352.8847529490634 "$node_(55) setdest 118395 49836 14.0" 
$ns at 418.35829007057555 "$node_(55) setdest 64886 26185 7.0" 
$ns at 451.25848943580513 "$node_(55) setdest 149238 43441 13.0" 
$ns at 505.67376474593 "$node_(55) setdest 153598 34518 8.0" 
$ns at 557.9663109448647 "$node_(55) setdest 74842 43288 20.0" 
$ns at 589.1286515852214 "$node_(55) setdest 129583 20646 3.0" 
$ns at 634.043535250394 "$node_(55) setdest 220865 46804 2.0" 
$ns at 671.2430553429573 "$node_(55) setdest 222769 23559 19.0" 
$ns at 782.0211963721148 "$node_(55) setdest 267203 4234 1.0" 
$ns at 813.326454115881 "$node_(55) setdest 167673 63035 17.0" 
$ns at 0.0 "$node_(56) setdest 24873 28899 1.0" 
$ns at 36.4079331942727 "$node_(56) setdest 74534 2859 19.0" 
$ns at 187.96209252149526 "$node_(56) setdest 127257 26075 2.0" 
$ns at 222.67794041553336 "$node_(56) setdest 51762 37532 15.0" 
$ns at 286.5100580828093 "$node_(56) setdest 120743 24873 8.0" 
$ns at 345.9836545459287 "$node_(56) setdest 27713 45912 5.0" 
$ns at 382.99258191283224 "$node_(56) setdest 143691 46581 19.0" 
$ns at 524.6780836790538 "$node_(56) setdest 125261 69599 13.0" 
$ns at 659.5604747935564 "$node_(56) setdest 131372 58241 19.0" 
$ns at 703.7021748693569 "$node_(56) setdest 185744 45882 1.0" 
$ns at 737.1265183017407 "$node_(56) setdest 16822 78589 15.0" 
$ns at 859.5675831364234 "$node_(56) setdest 31538 52563 16.0" 
$ns at 0.0 "$node_(57) setdest 84957 17929 3.0" 
$ns at 35.12933112506345 "$node_(57) setdest 42641 27252 15.0" 
$ns at 196.11671590230642 "$node_(57) setdest 70905 12539 16.0" 
$ns at 291.41206823423136 "$node_(57) setdest 158451 52658 16.0" 
$ns at 406.5652169690087 "$node_(57) setdest 128927 48778 12.0" 
$ns at 541.7143889797919 "$node_(57) setdest 170840 42799 1.0" 
$ns at 576.1712263772024 "$node_(57) setdest 88671 75727 15.0" 
$ns at 709.6077213778228 "$node_(57) setdest 127132 26190 12.0" 
$ns at 754.3887973609442 "$node_(57) setdest 162881 3405 4.0" 
$ns at 819.5151471217312 "$node_(57) setdest 189572 81486 14.0" 
$ns at 863.2432461955311 "$node_(57) setdest 48983 2294 10.0" 
$ns at 0.0 "$node_(58) setdest 50039 18273 19.0" 
$ns at 154.28577945739792 "$node_(58) setdest 6758 35521 10.0" 
$ns at 207.92755890417203 "$node_(58) setdest 39417 17294 19.0" 
$ns at 294.19687545190004 "$node_(58) setdest 28934 28432 3.0" 
$ns at 328.2149451268887 "$node_(58) setdest 84921 30228 20.0" 
$ns at 454.97433046932616 "$node_(58) setdest 138772 53958 11.0" 
$ns at 487.47829726690645 "$node_(58) setdest 68131 59120 10.0" 
$ns at 557.3486267388236 "$node_(58) setdest 188641 11762 8.0" 
$ns at 637.0190488352771 "$node_(58) setdest 171681 63953 13.0" 
$ns at 766.3441376460062 "$node_(58) setdest 97053 88433 5.0" 
$ns at 806.3220833247162 "$node_(58) setdest 146524 2762 18.0" 
$ns at 0.0 "$node_(59) setdest 85873 12396 8.0" 
$ns at 80.22056994539736 "$node_(59) setdest 54078 586 11.0" 
$ns at 125.38064664690202 "$node_(59) setdest 31838 24878 4.0" 
$ns at 164.84626108561037 "$node_(59) setdest 85805 1480 19.0" 
$ns at 299.8580197318546 "$node_(59) setdest 155014 45599 20.0" 
$ns at 509.6108559624472 "$node_(59) setdest 128741 57587 4.0" 
$ns at 541.6251372446677 "$node_(59) setdest 57986 8493 1.0" 
$ns at 581.2896255883261 "$node_(59) setdest 26936 44017 2.0" 
$ns at 612.5222509578537 "$node_(59) setdest 8150 16879 20.0" 
$ns at 835.2976179443178 "$node_(59) setdest 11350 26597 13.0" 
$ns at 887.8666627519107 "$node_(59) setdest 165560 80616 17.0" 
$ns at 0.0 "$node_(60) setdest 74167 30020 18.0" 
$ns at 185.51152910071107 "$node_(60) setdest 704 28905 10.0" 
$ns at 269.40179970720715 "$node_(60) setdest 133454 4867 4.0" 
$ns at 317.1621995554248 "$node_(60) setdest 25910 39425 16.0" 
$ns at 418.49104084684166 "$node_(60) setdest 38856 3257 16.0" 
$ns at 525.3292661620651 "$node_(60) setdest 28491 31671 19.0" 
$ns at 633.9546623042831 "$node_(60) setdest 2634 60825 18.0" 
$ns at 702.3875716649153 "$node_(60) setdest 134149 41463 6.0" 
$ns at 774.7114045026282 "$node_(60) setdest 188297 74937 15.0" 
$ns at 0.0 "$node_(61) setdest 3966 7536 13.0" 
$ns at 72.81995614448422 "$node_(61) setdest 7491 6204 16.0" 
$ns at 105.04519559542598 "$node_(61) setdest 12129 17661 9.0" 
$ns at 140.08871017450392 "$node_(61) setdest 32859 29580 1.0" 
$ns at 178.281567918463 "$node_(61) setdest 28799 29007 7.0" 
$ns at 232.22495555102898 "$node_(61) setdest 34021 39530 1.0" 
$ns at 266.5688345108362 "$node_(61) setdest 139303 35773 7.0" 
$ns at 318.27150906478994 "$node_(61) setdest 81591 41764 17.0" 
$ns at 442.47007821337934 "$node_(61) setdest 128997 14593 1.0" 
$ns at 474.24129080721485 "$node_(61) setdest 169189 35588 17.0" 
$ns at 608.3589620101787 "$node_(61) setdest 73459 28647 5.0" 
$ns at 677.2095627022438 "$node_(61) setdest 85618 59121 16.0" 
$ns at 824.6131784201748 "$node_(61) setdest 86374 3439 2.0" 
$ns at 856.0179686300551 "$node_(61) setdest 131806 39571 10.0" 
$ns at 0.0 "$node_(62) setdest 89534 15847 17.0" 
$ns at 163.78822724462708 "$node_(62) setdest 129623 38144 7.0" 
$ns at 240.68889223482887 "$node_(62) setdest 46206 17198 10.0" 
$ns at 330.3996814075438 "$node_(62) setdest 147280 14479 13.0" 
$ns at 460.63860819235344 "$node_(62) setdest 85323 58278 10.0" 
$ns at 535.8180812939828 "$node_(62) setdest 93525 54011 7.0" 
$ns at 612.3256810775925 "$node_(62) setdest 87525 21192 1.0" 
$ns at 652.2409109930978 "$node_(62) setdest 223202 37596 1.0" 
$ns at 689.9600365731303 "$node_(62) setdest 248400 67682 4.0" 
$ns at 726.5484556162131 "$node_(62) setdest 106162 67701 20.0" 
$ns at 0.0 "$node_(63) setdest 68719 327 11.0" 
$ns at 79.68458386608461 "$node_(63) setdest 91422 29665 13.0" 
$ns at 219.6212669649616 "$node_(63) setdest 52542 33636 15.0" 
$ns at 300.3849234584688 "$node_(63) setdest 128737 29977 3.0" 
$ns at 354.2513521791421 "$node_(63) setdest 50313 30627 3.0" 
$ns at 412.2938281143809 "$node_(63) setdest 152289 61691 19.0" 
$ns at 575.1589041993141 "$node_(63) setdest 78139 64820 17.0" 
$ns at 754.9723441459307 "$node_(63) setdest 201596 58745 15.0" 
$ns at 893.6940653896063 "$node_(63) setdest 131087 56302 15.0" 
$ns at 0.0 "$node_(64) setdest 58846 23881 13.0" 
$ns at 83.58538494884732 "$node_(64) setdest 61086 19548 17.0" 
$ns at 268.5680092905312 "$node_(64) setdest 12681 50336 4.0" 
$ns at 309.10157856562597 "$node_(64) setdest 29613 30715 3.0" 
$ns at 362.46392328802966 "$node_(64) setdest 146708 23125 16.0" 
$ns at 427.6791670848013 "$node_(64) setdest 32531 27475 2.0" 
$ns at 461.8998210135909 "$node_(64) setdest 152119 53145 18.0" 
$ns at 635.9769086521462 "$node_(64) setdest 58405 68573 10.0" 
$ns at 749.5918308029093 "$node_(64) setdest 35407 44818 1.0" 
$ns at 788.7130933899522 "$node_(64) setdest 40529 21849 9.0" 
$ns at 0.0 "$node_(65) setdest 50793 25057 16.0" 
$ns at 128.17490935858353 "$node_(65) setdest 20097 21812 3.0" 
$ns at 167.6720310415576 "$node_(65) setdest 104238 30495 7.0" 
$ns at 221.55990313735637 "$node_(65) setdest 56806 17419 8.0" 
$ns at 326.8847840919744 "$node_(65) setdest 86655 1894 4.0" 
$ns at 371.80929927149214 "$node_(65) setdest 149635 44532 10.0" 
$ns at 499.8829415116465 "$node_(65) setdest 69411 53482 5.0" 
$ns at 557.2813313726243 "$node_(65) setdest 15271 60705 15.0" 
$ns at 686.4582233746859 "$node_(65) setdest 15363 1025 9.0" 
$ns at 762.3455343167703 "$node_(65) setdest 50496 12535 1.0" 
$ns at 796.0433314767517 "$node_(65) setdest 193422 35347 17.0" 
$ns at 0.0 "$node_(66) setdest 86702 841 10.0" 
$ns at 60.02284576907499 "$node_(66) setdest 60698 16978 12.0" 
$ns at 203.59149948332208 "$node_(66) setdest 67566 31598 13.0" 
$ns at 235.90486102828137 "$node_(66) setdest 84301 38820 18.0" 
$ns at 343.0837611127821 "$node_(66) setdest 78819 51727 10.0" 
$ns at 431.72609571044893 "$node_(66) setdest 129373 30656 16.0" 
$ns at 572.3531934784188 "$node_(66) setdest 178088 23194 7.0" 
$ns at 613.0404032928509 "$node_(66) setdest 44183 25415 8.0" 
$ns at 708.684629312027 "$node_(66) setdest 191199 4651 4.0" 
$ns at 743.9266190452038 "$node_(66) setdest 206431 11261 15.0" 
$ns at 893.5265933322414 "$node_(66) setdest 38232 77689 15.0" 
$ns at 0.0 "$node_(67) setdest 48814 27295 11.0" 
$ns at 136.22053103225943 "$node_(67) setdest 42883 14635 5.0" 
$ns at 168.70664861956706 "$node_(67) setdest 31315 24910 5.0" 
$ns at 207.77154533981994 "$node_(67) setdest 103740 42922 3.0" 
$ns at 264.3684972653387 "$node_(67) setdest 73168 46399 15.0" 
$ns at 318.7095797980893 "$node_(67) setdest 5905 36715 3.0" 
$ns at 358.3523047006308 "$node_(67) setdest 87855 35012 2.0" 
$ns at 404.5406672339386 "$node_(67) setdest 144282 27357 15.0" 
$ns at 517.6121668568802 "$node_(67) setdest 20885 6566 6.0" 
$ns at 578.6465094117483 "$node_(67) setdest 66822 64090 16.0" 
$ns at 670.3788306230553 "$node_(67) setdest 74125 54169 10.0" 
$ns at 774.8055546051739 "$node_(67) setdest 213647 76390 14.0" 
$ns at 897.7693702967183 "$node_(67) setdest 179535 27288 2.0" 
$ns at 0.0 "$node_(68) setdest 62528 28376 19.0" 
$ns at 120.98973449479494 "$node_(68) setdest 12220 19748 6.0" 
$ns at 184.3308434023107 "$node_(68) setdest 125761 3062 2.0" 
$ns at 224.66048229712231 "$node_(68) setdest 976 14968 1.0" 
$ns at 257.5134328870634 "$node_(68) setdest 10691 13821 16.0" 
$ns at 320.59492227604034 "$node_(68) setdest 61612 6858 9.0" 
$ns at 404.1319946425806 "$node_(68) setdest 4583 27966 8.0" 
$ns at 479.1847823749166 "$node_(68) setdest 98371 51866 8.0" 
$ns at 530.8673689502629 "$node_(68) setdest 118963 13741 9.0" 
$ns at 638.0782865755627 "$node_(68) setdest 87364 61002 11.0" 
$ns at 737.5619464325969 "$node_(68) setdest 61181 23847 11.0" 
$ns at 825.5949078146238 "$node_(68) setdest 135486 9823 13.0" 
$ns at 0.0 "$node_(69) setdest 39435 28497 2.0" 
$ns at 49.07140714702764 "$node_(69) setdest 32464 13923 6.0" 
$ns at 100.39293903844175 "$node_(69) setdest 32075 29947 4.0" 
$ns at 130.86664814451177 "$node_(69) setdest 56715 24823 17.0" 
$ns at 163.8512247749447 "$node_(69) setdest 10840 13372 11.0" 
$ns at 252.8707566110408 "$node_(69) setdest 132963 46418 8.0" 
$ns at 301.9447738059556 "$node_(69) setdest 157157 4976 19.0" 
$ns at 349.4387107444193 "$node_(69) setdest 141978 13713 16.0" 
$ns at 478.0121124969944 "$node_(69) setdest 116920 25478 10.0" 
$ns at 577.8219239148478 "$node_(69) setdest 26491 38991 20.0" 
$ns at 660.5900291160913 "$node_(69) setdest 163688 53594 3.0" 
$ns at 702.6498680304591 "$node_(69) setdest 901 77437 8.0" 
$ns at 735.2477800187509 "$node_(69) setdest 156234 27405 16.0" 
$ns at 0.0 "$node_(70) setdest 37125 30940 16.0" 
$ns at 32.48508681155427 "$node_(70) setdest 2318 28635 11.0" 
$ns at 85.02350708257586 "$node_(70) setdest 93741 22671 7.0" 
$ns at 140.02626768977535 "$node_(70) setdest 51443 11475 13.0" 
$ns at 195.34055308843637 "$node_(70) setdest 79019 14118 16.0" 
$ns at 326.48410610447206 "$node_(70) setdest 82855 20831 5.0" 
$ns at 404.1756531042638 "$node_(70) setdest 4511 55477 20.0" 
$ns at 497.6254532743086 "$node_(70) setdest 117938 8720 15.0" 
$ns at 532.7210429950741 "$node_(70) setdest 619 69201 7.0" 
$ns at 571.408262147829 "$node_(70) setdest 66193 55829 3.0" 
$ns at 626.6119195000396 "$node_(70) setdest 65877 51572 19.0" 
$ns at 696.984324670118 "$node_(70) setdest 212594 63763 10.0" 
$ns at 745.1980262812431 "$node_(70) setdest 208814 71030 5.0" 
$ns at 802.8936575242254 "$node_(70) setdest 240694 35337 4.0" 
$ns at 866.0985183279556 "$node_(70) setdest 243868 27724 10.0" 
$ns at 0.0 "$node_(71) setdest 35267 27052 2.0" 
$ns at 34.36135491114286 "$node_(71) setdest 23879 24531 16.0" 
$ns at 157.1285362798546 "$node_(71) setdest 124580 22876 3.0" 
$ns at 207.83674658182736 "$node_(71) setdest 104845 34281 18.0" 
$ns at 378.5389315803633 "$node_(71) setdest 16885 47764 10.0" 
$ns at 502.0468248563078 "$node_(71) setdest 107869 12389 4.0" 
$ns at 566.549473346539 "$node_(71) setdest 90302 24886 3.0" 
$ns at 611.5629301176277 "$node_(71) setdest 131057 60783 7.0" 
$ns at 706.7152265117829 "$node_(71) setdest 21021 72580 10.0" 
$ns at 790.3088864067007 "$node_(71) setdest 142834 16207 16.0" 
$ns at 0.0 "$node_(72) setdest 20505 28374 3.0" 
$ns at 34.666800317732545 "$node_(72) setdest 48421 24327 2.0" 
$ns at 67.27793180440324 "$node_(72) setdest 8141 11283 12.0" 
$ns at 105.211689106982 "$node_(72) setdest 54040 26773 9.0" 
$ns at 165.7523657492136 "$node_(72) setdest 58152 21869 16.0" 
$ns at 252.62665125687752 "$node_(72) setdest 89749 51767 1.0" 
$ns at 283.15105988447243 "$node_(72) setdest 145046 42509 3.0" 
$ns at 330.7110835803643 "$node_(72) setdest 55161 49045 20.0" 
$ns at 483.8946076191827 "$node_(72) setdest 94109 3739 5.0" 
$ns at 543.0516017734527 "$node_(72) setdest 24975 22769 10.0" 
$ns at 616.705448257125 "$node_(72) setdest 29576 9502 18.0" 
$ns at 750.6345404071385 "$node_(72) setdest 49973 47010 19.0" 
$ns at 813.1778898238002 "$node_(72) setdest 261119 40993 10.0" 
$ns at 0.0 "$node_(73) setdest 29540 30370 7.0" 
$ns at 52.46645888984719 "$node_(73) setdest 3756 25919 3.0" 
$ns at 85.41312225224812 "$node_(73) setdest 76732 24118 2.0" 
$ns at 135.361902368779 "$node_(73) setdest 15025 27509 10.0" 
$ns at 240.99981411210524 "$node_(73) setdest 99559 1701 13.0" 
$ns at 385.9422924958331 "$node_(73) setdest 95578 7800 7.0" 
$ns at 427.3074854021167 "$node_(73) setdest 177159 54668 4.0" 
$ns at 483.67745955983617 "$node_(73) setdest 58810 56930 3.0" 
$ns at 520.3695055864648 "$node_(73) setdest 150909 15369 7.0" 
$ns at 578.4273558318296 "$node_(73) setdest 13659 35372 17.0" 
$ns at 755.9066148727964 "$node_(73) setdest 151387 24665 14.0" 
$ns at 890.1054180163617 "$node_(73) setdest 167662 32893 11.0" 
$ns at 0.0 "$node_(74) setdest 12832 25724 9.0" 
$ns at 102.95812702444715 "$node_(74) setdest 26988 5304 14.0" 
$ns at 239.02322609426986 "$node_(74) setdest 30390 28406 18.0" 
$ns at 300.6918521311372 "$node_(74) setdest 5598 8625 11.0" 
$ns at 402.261339988949 "$node_(74) setdest 140611 16640 15.0" 
$ns at 492.3763954292227 "$node_(74) setdest 17283 15190 5.0" 
$ns at 568.570790784495 "$node_(74) setdest 171812 25651 13.0" 
$ns at 714.2595862571123 "$node_(74) setdest 135647 29679 9.0" 
$ns at 774.8487686781729 "$node_(74) setdest 9247 35274 7.0" 
$ns at 811.9389648634566 "$node_(74) setdest 92832 24757 15.0" 
$ns at 893.6202764810887 "$node_(74) setdest 740 9831 14.0" 
$ns at 0.0 "$node_(75) setdest 65609 15234 17.0" 
$ns at 42.12952596315743 "$node_(75) setdest 50795 31533 1.0" 
$ns at 81.07068140314576 "$node_(75) setdest 51134 24961 1.0" 
$ns at 120.69502060535129 "$node_(75) setdest 29088 7391 10.0" 
$ns at 207.73694208379055 "$node_(75) setdest 176 15169 19.0" 
$ns at 313.9701185900092 "$node_(75) setdest 128859 10647 11.0" 
$ns at 435.82949642061027 "$node_(75) setdest 123368 25749 17.0" 
$ns at 466.0308063055459 "$node_(75) setdest 139744 48798 14.0" 
$ns at 586.1083577321832 "$node_(75) setdest 11182 47918 11.0" 
$ns at 665.068640930516 "$node_(75) setdest 154753 9542 16.0" 
$ns at 725.3683601069722 "$node_(75) setdest 14087 32765 12.0" 
$ns at 757.7110637724633 "$node_(75) setdest 169709 85120 8.0" 
$ns at 796.3078789239263 "$node_(75) setdest 192724 61779 19.0" 
$ns at 871.7029985014287 "$node_(75) setdest 55947 32376 13.0" 
$ns at 0.0 "$node_(76) setdest 73337 13429 11.0" 
$ns at 52.4312841338584 "$node_(76) setdest 22162 24882 7.0" 
$ns at 139.88612368726257 "$node_(76) setdest 8850 2191 7.0" 
$ns at 211.07052722745658 "$node_(76) setdest 52434 35576 11.0" 
$ns at 334.64822074486665 "$node_(76) setdest 99308 19057 9.0" 
$ns at 400.6038515666565 "$node_(76) setdest 54500 39298 15.0" 
$ns at 481.80002332948504 "$node_(76) setdest 102326 3617 1.0" 
$ns at 520.8623249160165 "$node_(76) setdest 155459 6915 8.0" 
$ns at 594.0135752912435 "$node_(76) setdest 158601 25420 13.0" 
$ns at 673.3175454698033 "$node_(76) setdest 211783 79527 11.0" 
$ns at 719.3842963416162 "$node_(76) setdest 24786 2646 8.0" 
$ns at 792.4624762361397 "$node_(76) setdest 240397 58406 14.0" 
$ns at 888.0459677676188 "$node_(76) setdest 242927 84797 15.0" 
$ns at 0.0 "$node_(77) setdest 9927 9559 2.0" 
$ns at 34.27690498916527 "$node_(77) setdest 83585 31493 9.0" 
$ns at 71.31251673010405 "$node_(77) setdest 71751 7026 19.0" 
$ns at 280.99623749349536 "$node_(77) setdest 126050 39603 10.0" 
$ns at 381.5558259094572 "$node_(77) setdest 69744 15869 1.0" 
$ns at 416.26769633226877 "$node_(77) setdest 181967 43402 3.0" 
$ns at 451.3069059173803 "$node_(77) setdest 169252 65056 11.0" 
$ns at 556.0666515510685 "$node_(77) setdest 19526 42129 7.0" 
$ns at 655.7931859705456 "$node_(77) setdest 123324 82147 18.0" 
$ns at 794.0767846544946 "$node_(77) setdest 70776 84511 7.0" 
$ns at 844.4316562357501 "$node_(77) setdest 73448 88763 19.0" 
$ns at 0.0 "$node_(78) setdest 10832 17231 7.0" 
$ns at 41.546715681997995 "$node_(78) setdest 36043 28678 2.0" 
$ns at 85.90624394465542 "$node_(78) setdest 74228 23169 15.0" 
$ns at 123.21462719583822 "$node_(78) setdest 60542 28288 2.0" 
$ns at 161.98373669084953 "$node_(78) setdest 76764 40162 11.0" 
$ns at 192.22483285502065 "$node_(78) setdest 132355 37135 19.0" 
$ns at 297.9644373505974 "$node_(78) setdest 157372 17731 2.0" 
$ns at 336.57169689455765 "$node_(78) setdest 122831 9320 5.0" 
$ns at 381.8483637471171 "$node_(78) setdest 7241 2089 1.0" 
$ns at 420.2959409518562 "$node_(78) setdest 63889 10519 10.0" 
$ns at 508.9086441969084 "$node_(78) setdest 155211 12411 9.0" 
$ns at 589.871764216398 "$node_(78) setdest 76881 48902 5.0" 
$ns at 646.7128299472402 "$node_(78) setdest 60773 60621 18.0" 
$ns at 769.177906431567 "$node_(78) setdest 19182 63137 17.0" 
$ns at 0.0 "$node_(79) setdest 69628 30833 19.0" 
$ns at 119.8204999941202 "$node_(79) setdest 21822 10718 16.0" 
$ns at 235.4979105729884 "$node_(79) setdest 115242 42679 6.0" 
$ns at 294.8732327913096 "$node_(79) setdest 1564 23886 7.0" 
$ns at 360.6590460694526 "$node_(79) setdest 21798 22802 12.0" 
$ns at 424.7409184359442 "$node_(79) setdest 172562 55930 8.0" 
$ns at 484.7280429546637 "$node_(79) setdest 192450 58520 8.0" 
$ns at 580.831462536548 "$node_(79) setdest 53260 70413 15.0" 
$ns at 630.844000189359 "$node_(79) setdest 121504 63460 3.0" 
$ns at 675.0198126051635 "$node_(79) setdest 184579 39432 9.0" 
$ns at 786.5977861162673 "$node_(79) setdest 249617 6863 10.0" 
$ns at 846.8914685483516 "$node_(79) setdest 45633 59201 16.0" 
$ns at 0.0 "$node_(80) setdest 68907 8246 9.0" 
$ns at 80.18413704852172 "$node_(80) setdest 49743 9460 18.0" 
$ns at 286.82314876474294 "$node_(80) setdest 128342 33944 13.0" 
$ns at 357.67127038928516 "$node_(80) setdest 48162 11885 9.0" 
$ns at 405.18714732254443 "$node_(80) setdest 72157 48451 16.0" 
$ns at 563.5682929905745 "$node_(80) setdest 200244 57816 13.0" 
$ns at 630.5972470439463 "$node_(80) setdest 213286 69161 12.0" 
$ns at 780.4727641407923 "$node_(80) setdest 140845 85687 12.0" 
$ns at 864.7260206118905 "$node_(80) setdest 117345 1137 13.0" 
$ns at 0.0 "$node_(81) setdest 65401 27048 4.0" 
$ns at 41.37305320462793 "$node_(81) setdest 54536 1613 15.0" 
$ns at 87.42232871318144 "$node_(81) setdest 76882 31405 11.0" 
$ns at 208.5138767151295 "$node_(81) setdest 94340 39148 10.0" 
$ns at 302.74005128535464 "$node_(81) setdest 108965 33810 14.0" 
$ns at 443.4025238242373 "$node_(81) setdest 62206 37552 11.0" 
$ns at 484.87048400647814 "$node_(81) setdest 190894 34463 17.0" 
$ns at 538.7703879734759 "$node_(81) setdest 7823 49673 14.0" 
$ns at 651.5149185630852 "$node_(81) setdest 195634 46749 1.0" 
$ns at 687.8309240542483 "$node_(81) setdest 138992 76749 15.0" 
$ns at 720.2632135713851 "$node_(81) setdest 61320 82186 19.0" 
$ns at 752.4018266690382 "$node_(81) setdest 186592 68733 20.0" 
$ns at 0.0 "$node_(82) setdest 73225 4057 15.0" 
$ns at 171.2537084570451 "$node_(82) setdest 38268 13073 9.0" 
$ns at 247.11634089718152 "$node_(82) setdest 90535 26446 5.0" 
$ns at 321.98692769150534 "$node_(82) setdest 53027 22010 15.0" 
$ns at 359.6702973518695 "$node_(82) setdest 147442 24291 15.0" 
$ns at 473.84304269573283 "$node_(82) setdest 203544 54247 6.0" 
$ns at 546.5796508679051 "$node_(82) setdest 135943 54838 16.0" 
$ns at 654.5211838741776 "$node_(82) setdest 20993 24190 19.0" 
$ns at 740.375867955721 "$node_(82) setdest 193329 40365 17.0" 
$ns at 779.089677567375 "$node_(82) setdest 150783 44476 14.0" 
$ns at 847.1236206838306 "$node_(82) setdest 125559 15177 11.0" 
$ns at 0.0 "$node_(83) setdest 41928 14370 12.0" 
$ns at 83.57349494914983 "$node_(83) setdest 25610 14770 2.0" 
$ns at 130.00796772562114 "$node_(83) setdest 62981 5 10.0" 
$ns at 175.12317738799987 "$node_(83) setdest 18095 42918 6.0" 
$ns at 240.9722624049988 "$node_(83) setdest 11165 18552 7.0" 
$ns at 299.3600512970355 "$node_(83) setdest 133567 47041 4.0" 
$ns at 364.2230987997876 "$node_(83) setdest 162284 52897 9.0" 
$ns at 454.0668265925284 "$node_(83) setdest 14972 21939 20.0" 
$ns at 542.1952741223483 "$node_(83) setdest 102254 835 5.0" 
$ns at 575.0448521149052 "$node_(83) setdest 162116 42365 5.0" 
$ns at 637.2104232649805 "$node_(83) setdest 16699 16717 16.0" 
$ns at 707.3933418514182 "$node_(83) setdest 118054 28753 20.0" 
$ns at 810.541357910109 "$node_(83) setdest 164714 37377 14.0" 
$ns at 890.2584416156151 "$node_(83) setdest 133787 42935 17.0" 
$ns at 0.0 "$node_(84) setdest 30015 961 10.0" 
$ns at 78.32389286768458 "$node_(84) setdest 59928 5348 8.0" 
$ns at 132.89734599804785 "$node_(84) setdest 29542 25921 17.0" 
$ns at 314.34350446846656 "$node_(84) setdest 139471 36088 16.0" 
$ns at 385.5704499188281 "$node_(84) setdest 52195 51357 14.0" 
$ns at 530.3200583902376 "$node_(84) setdest 171789 32747 9.0" 
$ns at 635.0229734560579 "$node_(84) setdest 177887 21410 16.0" 
$ns at 736.7102665867752 "$node_(84) setdest 249161 77755 9.0" 
$ns at 809.5479882556352 "$node_(84) setdest 88066 10430 1.0" 
$ns at 845.4648851004711 "$node_(84) setdest 24799 8972 4.0" 
$ns at 0.0 "$node_(85) setdest 63608 8034 6.0" 
$ns at 32.88113326430497 "$node_(85) setdest 57704 2413 7.0" 
$ns at 109.69814294896454 "$node_(85) setdest 43176 26367 1.0" 
$ns at 146.99692165450807 "$node_(85) setdest 75340 10606 18.0" 
$ns at 289.7127918862115 "$node_(85) setdest 84491 18384 13.0" 
$ns at 447.4358401736493 "$node_(85) setdest 75667 45434 6.0" 
$ns at 493.82911892818714 "$node_(85) setdest 113309 65224 4.0" 
$ns at 552.963112228709 "$node_(85) setdest 202322 2765 18.0" 
$ns at 626.6973145758946 "$node_(85) setdest 119072 47029 12.0" 
$ns at 696.8569732729742 "$node_(85) setdest 239470 42109 6.0" 
$ns at 767.2695829647827 "$node_(85) setdest 144021 6424 3.0" 
$ns at 807.7004399312859 "$node_(85) setdest 228607 41539 3.0" 
$ns at 862.3242019736148 "$node_(85) setdest 184572 19590 13.0" 
$ns at 0.0 "$node_(86) setdest 36156 3298 14.0" 
$ns at 148.7996411176989 "$node_(86) setdest 11029 24950 1.0" 
$ns at 184.35982889887748 "$node_(86) setdest 106746 5139 10.0" 
$ns at 220.96943256509076 "$node_(86) setdest 79669 27897 13.0" 
$ns at 267.5409956710172 "$node_(86) setdest 33613 28315 12.0" 
$ns at 313.37278776610935 "$node_(86) setdest 15001 22523 12.0" 
$ns at 368.3678177968617 "$node_(86) setdest 144058 6041 2.0" 
$ns at 418.24948742305014 "$node_(86) setdest 34554 62568 1.0" 
$ns at 450.43341912002296 "$node_(86) setdest 7723 11117 11.0" 
$ns at 544.8713981433103 "$node_(86) setdest 68631 38532 19.0" 
$ns at 758.0287350008848 "$node_(86) setdest 78491 50559 15.0" 
$ns at 870.0137286898024 "$node_(86) setdest 84730 25714 4.0" 
$ns at 0.0 "$node_(87) setdest 48898 8216 20.0" 
$ns at 127.56892177741803 "$node_(87) setdest 46490 13597 18.0" 
$ns at 327.3064923688768 "$node_(87) setdest 73768 39456 19.0" 
$ns at 466.1908492266318 "$node_(87) setdest 90393 39570 5.0" 
$ns at 540.3792691690221 "$node_(87) setdest 3407 5492 4.0" 
$ns at 587.6388820874381 "$node_(87) setdest 58160 56538 19.0" 
$ns at 735.3987436132237 "$node_(87) setdest 205043 69570 19.0" 
$ns at 893.696089588189 "$node_(87) setdest 218549 76600 9.0" 
$ns at 0.0 "$node_(88) setdest 59463 12085 12.0" 
$ns at 94.7335222925132 "$node_(88) setdest 29165 7837 19.0" 
$ns at 211.36866578762263 "$node_(88) setdest 9455 37202 4.0" 
$ns at 257.94896229684696 "$node_(88) setdest 16164 19431 9.0" 
$ns at 346.17787920230774 "$node_(88) setdest 147588 41841 9.0" 
$ns at 402.3245150937047 "$node_(88) setdest 164013 4316 7.0" 
$ns at 486.29241326900933 "$node_(88) setdest 114441 67592 11.0" 
$ns at 558.4228901272938 "$node_(88) setdest 70223 11594 7.0" 
$ns at 589.5679691251825 "$node_(88) setdest 199914 18169 11.0" 
$ns at 670.1354925029045 "$node_(88) setdest 244577 52260 17.0" 
$ns at 759.8200499957243 "$node_(88) setdest 80333 83091 14.0" 
$ns at 879.1208774120257 "$node_(88) setdest 24830 19880 3.0" 
$ns at 0.0 "$node_(89) setdest 76815 19900 17.0" 
$ns at 144.16697468643815 "$node_(89) setdest 27115 6091 4.0" 
$ns at 186.04041814995182 "$node_(89) setdest 37634 9295 14.0" 
$ns at 355.8572196508368 "$node_(89) setdest 124839 5278 7.0" 
$ns at 404.00990607606667 "$node_(89) setdest 69464 19610 15.0" 
$ns at 444.04536365290585 "$node_(89) setdest 129369 19555 2.0" 
$ns at 486.2162107211985 "$node_(89) setdest 190252 54565 12.0" 
$ns at 601.2217181948613 "$node_(89) setdest 170399 45968 15.0" 
$ns at 638.7921914836909 "$node_(89) setdest 69331 51874 8.0" 
$ns at 715.4043021011196 "$node_(89) setdest 78957 51669 16.0" 
$ns at 747.038659233463 "$node_(89) setdest 174310 80657 1.0" 
$ns at 786.6104244340054 "$node_(89) setdest 72042 40879 12.0" 
$ns at 840.3867047793156 "$node_(89) setdest 166384 83781 10.0" 
$ns at 0.0 "$node_(90) setdest 50627 20169 18.0" 
$ns at 122.10908405571372 "$node_(90) setdest 49264 28009 3.0" 
$ns at 175.2106806874296 "$node_(90) setdest 32477 40009 10.0" 
$ns at 271.9837414663282 "$node_(90) setdest 74737 42771 7.0" 
$ns at 349.34505817853477 "$node_(90) setdest 34404 52762 18.0" 
$ns at 417.00333692431525 "$node_(90) setdest 133684 53010 3.0" 
$ns at 469.7235383444409 "$node_(90) setdest 25235 69938 4.0" 
$ns at 530.9951807691492 "$node_(90) setdest 36224 15544 9.0" 
$ns at 580.3326002195021 "$node_(90) setdest 220844 29663 16.0" 
$ns at 742.1550631681926 "$node_(90) setdest 195242 26581 8.0" 
$ns at 790.4471133855379 "$node_(90) setdest 121549 18628 1.0" 
$ns at 821.1005963394734 "$node_(90) setdest 76425 29153 3.0" 
$ns at 870.4970683276867 "$node_(90) setdest 192072 38389 16.0" 
$ns at 0.0 "$node_(91) setdest 17778 1923 11.0" 
$ns at 48.70932339173254 "$node_(91) setdest 12697 19087 15.0" 
$ns at 165.64589488665655 "$node_(91) setdest 85394 10488 14.0" 
$ns at 273.11071669588455 "$node_(91) setdest 52946 46656 12.0" 
$ns at 328.91172881429566 "$node_(91) setdest 90070 35043 4.0" 
$ns at 382.30025610569817 "$node_(91) setdest 147728 11640 15.0" 
$ns at 448.859142008035 "$node_(91) setdest 62815 60243 17.0" 
$ns at 627.0193298497775 "$node_(91) setdest 80095 40085 19.0" 
$ns at 798.2720926612545 "$node_(91) setdest 243472 9792 11.0" 
$ns at 0.0 "$node_(92) setdest 72832 30555 2.0" 
$ns at 42.90655001625811 "$node_(92) setdest 90356 14799 11.0" 
$ns at 124.0716545260344 "$node_(92) setdest 86580 7434 5.0" 
$ns at 200.99371059281526 "$node_(92) setdest 71056 9153 6.0" 
$ns at 261.98771038105446 "$node_(92) setdest 69948 10957 4.0" 
$ns at 325.5353898060647 "$node_(92) setdest 89628 36171 16.0" 
$ns at 405.43708874777514 "$node_(92) setdest 170822 435 12.0" 
$ns at 503.4878696843983 "$node_(92) setdest 148792 41597 4.0" 
$ns at 544.491332556823 "$node_(92) setdest 179481 19112 7.0" 
$ns at 618.708943660549 "$node_(92) setdest 201643 39646 13.0" 
$ns at 753.0700048883291 "$node_(92) setdest 3078 18373 9.0" 
$ns at 851.2665835379247 "$node_(92) setdest 14833 58172 5.0" 
$ns at 891.9330104999417 "$node_(92) setdest 231080 69217 15.0" 
$ns at 0.0 "$node_(93) setdest 39000 3754 5.0" 
$ns at 62.74108418851796 "$node_(93) setdest 24562 5572 14.0" 
$ns at 191.68432486388303 "$node_(93) setdest 122557 16006 6.0" 
$ns at 236.1641646342677 "$node_(93) setdest 88038 12206 7.0" 
$ns at 276.9676436763855 "$node_(93) setdest 113783 251 13.0" 
$ns at 428.78625384557427 "$node_(93) setdest 64194 48457 2.0" 
$ns at 461.2541522301651 "$node_(93) setdest 32071 46335 14.0" 
$ns at 625.3623785906041 "$node_(93) setdest 122672 17330 8.0" 
$ns at 710.112665605155 "$node_(93) setdest 78900 19531 12.0" 
$ns at 825.3018741879671 "$node_(93) setdest 106485 24864 7.0" 
$ns at 0.0 "$node_(94) setdest 7509 28954 16.0" 
$ns at 115.46327447417949 "$node_(94) setdest 27312 18381 18.0" 
$ns at 218.59974395015698 "$node_(94) setdest 39551 36851 16.0" 
$ns at 373.0313675471624 "$node_(94) setdest 132044 22137 6.0" 
$ns at 439.0070187398599 "$node_(94) setdest 160526 59632 15.0" 
$ns at 613.0150137359042 "$node_(94) setdest 188312 44901 4.0" 
$ns at 654.5031899635803 "$node_(94) setdest 41900 80716 12.0" 
$ns at 691.0544642250827 "$node_(94) setdest 167915 21937 1.0" 
$ns at 730.8876240496405 "$node_(94) setdest 215898 2077 8.0" 
$ns at 773.2605928568449 "$node_(94) setdest 60207 16859 20.0" 
$ns at 807.7032712261064 "$node_(94) setdest 93384 47362 16.0" 
$ns at 844.701857998397 "$node_(94) setdest 234354 14989 4.0" 
$ns at 896.3410584894724 "$node_(94) setdest 196087 48000 2.0" 
$ns at 0.0 "$node_(95) setdest 23782 23547 9.0" 
$ns at 96.54104234085638 "$node_(95) setdest 26374 12470 1.0" 
$ns at 135.83800460691006 "$node_(95) setdest 31974 23710 13.0" 
$ns at 173.79677804339968 "$node_(95) setdest 30722 26626 13.0" 
$ns at 317.4272915846545 "$node_(95) setdest 30085 14244 9.0" 
$ns at 364.74945471308706 "$node_(95) setdest 157037 3447 3.0" 
$ns at 418.2739531011636 "$node_(95) setdest 151701 50979 15.0" 
$ns at 451.18508719129983 "$node_(95) setdest 162936 18747 10.0" 
$ns at 576.9810862140351 "$node_(95) setdest 3329 70142 6.0" 
$ns at 663.5385081262976 "$node_(95) setdest 119523 3589 9.0" 
$ns at 728.1819583460185 "$node_(95) setdest 87298 21443 3.0" 
$ns at 763.8994908286807 "$node_(95) setdest 242423 72728 17.0" 
$ns at 826.4849064064746 "$node_(95) setdest 55405 15184 8.0" 
$ns at 858.6934320384619 "$node_(95) setdest 203519 58028 11.0" 
$ns at 0.0 "$node_(96) setdest 89771 2460 17.0" 
$ns at 30.119421027008652 "$node_(96) setdest 33397 16333 14.0" 
$ns at 60.719406228134005 "$node_(96) setdest 57485 6154 1.0" 
$ns at 96.91777425304983 "$node_(96) setdest 45696 13834 7.0" 
$ns at 174.1252542585848 "$node_(96) setdest 48512 29768 20.0" 
$ns at 227.3503129525359 "$node_(96) setdest 4195 23250 10.0" 
$ns at 311.63213272061535 "$node_(96) setdest 471 43045 16.0" 
$ns at 369.2331888985616 "$node_(96) setdest 40146 4483 11.0" 
$ns at 443.93064700184436 "$node_(96) setdest 186295 7532 12.0" 
$ns at 566.5008873246703 "$node_(96) setdest 143520 18881 4.0" 
$ns at 629.5124690103786 "$node_(96) setdest 194085 46496 17.0" 
$ns at 753.6942560015948 "$node_(96) setdest 141756 83069 8.0" 
$ns at 855.8623382260054 "$node_(96) setdest 8170 85291 12.0" 
$ns at 0.0 "$node_(97) setdest 11819 26673 20.0" 
$ns at 181.39063706334937 "$node_(97) setdest 72077 331 7.0" 
$ns at 258.33660547416 "$node_(97) setdest 90628 1675 13.0" 
$ns at 316.93878784349323 "$node_(97) setdest 110791 40456 4.0" 
$ns at 371.5626353529623 "$node_(97) setdest 55 13874 14.0" 
$ns at 472.9416976717031 "$node_(97) setdest 6920 9083 9.0" 
$ns at 509.9310261111933 "$node_(97) setdest 49967 53640 1.0" 
$ns at 549.1057488519862 "$node_(97) setdest 111699 11414 1.0" 
$ns at 583.1123937228316 "$node_(97) setdest 56836 5990 10.0" 
$ns at 689.6762708592161 "$node_(97) setdest 218883 46012 5.0" 
$ns at 723.5968658004917 "$node_(97) setdest 234271 73722 4.0" 
$ns at 760.1113784714457 "$node_(97) setdest 11915 1452 6.0" 
$ns at 834.6025191360905 "$node_(97) setdest 12241 48327 12.0" 
$ns at 0.0 "$node_(98) setdest 48889 6756 16.0" 
$ns at 159.9268997418665 "$node_(98) setdest 98039 16873 8.0" 
$ns at 226.7944756439777 "$node_(98) setdest 42999 27711 19.0" 
$ns at 346.17431634020625 "$node_(98) setdest 71654 44399 1.0" 
$ns at 381.7796964890171 "$node_(98) setdest 48973 62115 14.0" 
$ns at 527.8749893369163 "$node_(98) setdest 10525 39725 5.0" 
$ns at 582.4183302126218 "$node_(98) setdest 178842 11733 15.0" 
$ns at 681.189261157443 "$node_(98) setdest 117663 32034 13.0" 
$ns at 747.906114176773 "$node_(98) setdest 76049 31799 15.0" 
$ns at 876.370042484059 "$node_(98) setdest 5635 992 4.0" 
$ns at 0.0 "$node_(99) setdest 19884 13331 1.0" 
$ns at 31.113841765048413 "$node_(99) setdest 39086 9740 19.0" 
$ns at 137.38553336128646 "$node_(99) setdest 45093 365 11.0" 
$ns at 260.6699032026607 "$node_(99) setdest 20953 43272 17.0" 
$ns at 318.3709686683201 "$node_(99) setdest 137503 30796 4.0" 
$ns at 372.5110898406986 "$node_(99) setdest 88068 480 2.0" 
$ns at 402.6015562834273 "$node_(99) setdest 15839 9661 13.0" 
$ns at 436.1549552882497 "$node_(99) setdest 116759 30320 4.0" 
$ns at 472.9784444620167 "$node_(99) setdest 126480 10384 3.0" 
$ns at 513.4826616791265 "$node_(99) setdest 103540 9868 8.0" 
$ns at 565.4200575571375 "$node_(99) setdest 98431 1622 15.0" 
$ns at 657.7117074407093 "$node_(99) setdest 44165 42175 8.0" 
$ns at 696.6286330953866 "$node_(99) setdest 111927 19539 11.0" 
$ns at 750.6275629639022 "$node_(99) setdest 71084 1258 19.0" 
$ns at 0.0 "$node_(100) setdest 57538 9781 5.0" 
$ns at 47.39054033277179 "$node_(100) setdest 53247 11729 16.0" 
$ns at 90.47823783791564 "$node_(100) setdest 2172 37358 8.0" 
$ns at 198.47183127965204 "$node_(100) setdest 102950 2712 9.0" 
$ns at 282.3759812269823 "$node_(100) setdest 158322 46798 14.0" 
$ns at 351.7673630505368 "$node_(100) setdest 91570 35115 10.0" 
$ns at 458.0385858710821 "$node_(100) setdest 34609 22337 1.0" 
$ns at 492.7917646948832 "$node_(100) setdest 202070 59812 5.0" 
$ns at 567.0418532477315 "$node_(100) setdest 60671 64918 17.0" 
$ns at 730.7772877491284 "$node_(100) setdest 186895 68424 15.0" 
$ns at 768.5333877577093 "$node_(100) setdest 246036 18836 17.0" 
$ns at 813.3840403247773 "$node_(100) setdest 154198 12686 1.0" 
$ns at 845.261605363 "$node_(100) setdest 1979 76332 10.0" 
$ns at 878.3480943869907 "$node_(100) setdest 96862 58152 10.0" 
$ns at 192.60413433217187 "$node_(101) setdest 69300 24395 4.0" 
$ns at 231.3938938480277 "$node_(101) setdest 76190 22595 18.0" 
$ns at 305.99704767322214 "$node_(101) setdest 148828 8190 6.0" 
$ns at 348.4688968700278 "$node_(101) setdest 112710 8401 18.0" 
$ns at 541.2334729890487 "$node_(101) setdest 29994 10514 11.0" 
$ns at 621.0638162361233 "$node_(101) setdest 199803 11077 5.0" 
$ns at 685.9009308129599 "$node_(101) setdest 37017 45473 9.0" 
$ns at 735.8280353058698 "$node_(101) setdest 172716 40667 9.0" 
$ns at 817.6062660405864 "$node_(101) setdest 43935 67897 18.0" 
$ns at 862.8255269953978 "$node_(101) setdest 98892 76914 5.0" 
$ns at 106.09617675293474 "$node_(102) setdest 88136 13456 16.0" 
$ns at 265.58556390085465 "$node_(102) setdest 88716 9409 2.0" 
$ns at 312.88858600407525 "$node_(102) setdest 132887 9197 3.0" 
$ns at 361.62784181023113 "$node_(102) setdest 85095 30362 12.0" 
$ns at 455.92004113693827 "$node_(102) setdest 72042 41785 14.0" 
$ns at 522.4650111805702 "$node_(102) setdest 186282 70117 13.0" 
$ns at 590.3412699406199 "$node_(102) setdest 216059 65715 14.0" 
$ns at 650.1501991494331 "$node_(102) setdest 245996 3066 19.0" 
$ns at 785.4963466294355 "$node_(102) setdest 267993 57553 5.0" 
$ns at 848.2430252301788 "$node_(102) setdest 232956 45299 18.0" 
$ns at 116.41911126802265 "$node_(103) setdest 80006 2789 4.0" 
$ns at 181.55884272868636 "$node_(103) setdest 30906 4977 14.0" 
$ns at 280.2996295153865 "$node_(103) setdest 38031 7367 8.0" 
$ns at 358.55074566193514 "$node_(103) setdest 109461 58974 4.0" 
$ns at 424.62449012625547 "$node_(103) setdest 146579 31738 9.0" 
$ns at 482.8801157511633 "$node_(103) setdest 145167 55351 19.0" 
$ns at 665.0469700591551 "$node_(103) setdest 90007 64242 12.0" 
$ns at 712.8049533234673 "$node_(103) setdest 151081 26556 17.0" 
$ns at 766.7455978117259 "$node_(103) setdest 173548 61368 8.0" 
$ns at 869.4070342800538 "$node_(103) setdest 117306 9386 12.0" 
$ns at 145.64416627709596 "$node_(104) setdest 65574 10923 17.0" 
$ns at 205.947572858233 "$node_(104) setdest 36076 6976 1.0" 
$ns at 238.71146162275699 "$node_(104) setdest 99367 28637 18.0" 
$ns at 305.7598384606858 "$node_(104) setdest 120542 5498 13.0" 
$ns at 436.21895180369887 "$node_(104) setdest 127345 5223 12.0" 
$ns at 516.0028678810934 "$node_(104) setdest 18411 4266 1.0" 
$ns at 547.2130366947375 "$node_(104) setdest 151453 52365 11.0" 
$ns at 618.2007687936648 "$node_(104) setdest 229376 31095 3.0" 
$ns at 669.9869317857042 "$node_(104) setdest 168420 73916 20.0" 
$ns at 715.216050859723 "$node_(104) setdest 207318 60903 14.0" 
$ns at 774.7924710527833 "$node_(104) setdest 56512 43434 18.0" 
$ns at 806.7409845198683 "$node_(104) setdest 141408 36022 2.0" 
$ns at 847.0001738645315 "$node_(104) setdest 166425 47619 14.0" 
$ns at 895.5400468967987 "$node_(104) setdest 230420 73005 10.0" 
$ns at 202.75056910006643 "$node_(105) setdest 89855 13883 16.0" 
$ns at 372.8973947921029 "$node_(105) setdest 160555 20167 8.0" 
$ns at 448.93460588728374 "$node_(105) setdest 80479 59123 8.0" 
$ns at 532.6932014962651 "$node_(105) setdest 9134 43817 5.0" 
$ns at 598.4521817372108 "$node_(105) setdest 69061 63953 4.0" 
$ns at 638.2742879159684 "$node_(105) setdest 113701 52238 9.0" 
$ns at 705.8021061740228 "$node_(105) setdest 194785 13492 9.0" 
$ns at 765.5720687322472 "$node_(105) setdest 112241 44214 10.0" 
$ns at 810.9927288773937 "$node_(105) setdest 115893 79965 14.0" 
$ns at 843.1126354577035 "$node_(105) setdest 247958 49233 16.0" 
$ns at 180.16147366581464 "$node_(106) setdest 13327 43444 10.0" 
$ns at 244.64051812576875 "$node_(106) setdest 35120 35953 10.0" 
$ns at 300.0598751816294 "$node_(106) setdest 49539 28037 12.0" 
$ns at 366.2040207650641 "$node_(106) setdest 43910 54845 7.0" 
$ns at 452.96758154228587 "$node_(106) setdest 18031 44978 11.0" 
$ns at 504.48353414700125 "$node_(106) setdest 164008 8270 2.0" 
$ns at 543.2575205418474 "$node_(106) setdest 157064 9668 19.0" 
$ns at 609.4464584702632 "$node_(106) setdest 218803 1422 18.0" 
$ns at 799.3235848011367 "$node_(106) setdest 31666 55619 2.0" 
$ns at 831.4766701791831 "$node_(106) setdest 58385 72305 19.0" 
$ns at 170.20841671324212 "$node_(107) setdest 109566 14376 19.0" 
$ns at 320.21027481777537 "$node_(107) setdest 150850 2458 4.0" 
$ns at 380.3988845120065 "$node_(107) setdest 38007 57821 8.0" 
$ns at 458.3318783511693 "$node_(107) setdest 148108 23083 17.0" 
$ns at 553.2087700143708 "$node_(107) setdest 86471 68695 7.0" 
$ns at 598.9747388008786 "$node_(107) setdest 111668 2524 7.0" 
$ns at 669.4240734690485 "$node_(107) setdest 110819 45267 1.0" 
$ns at 701.6565316270094 "$node_(107) setdest 86960 25336 15.0" 
$ns at 852.6210413208787 "$node_(107) setdest 7660 77085 4.0" 
$ns at 140.79506268434451 "$node_(108) setdest 23529 1187 8.0" 
$ns at 212.1692951310945 "$node_(108) setdest 24218 10960 3.0" 
$ns at 266.24992418376894 "$node_(108) setdest 62380 44712 6.0" 
$ns at 310.2435851572508 "$node_(108) setdest 46119 39295 12.0" 
$ns at 381.4720189419759 "$node_(108) setdest 149138 51907 20.0" 
$ns at 478.1686204804857 "$node_(108) setdest 5127 61311 11.0" 
$ns at 553.3363484327832 "$node_(108) setdest 18861 37809 20.0" 
$ns at 589.3468090662045 "$node_(108) setdest 79812 8180 5.0" 
$ns at 650.4950469729058 "$node_(108) setdest 74900 72355 3.0" 
$ns at 709.0176275808901 "$node_(108) setdest 63634 63310 11.0" 
$ns at 840.3547333022137 "$node_(108) setdest 122260 65876 13.0" 
$ns at 190.05182403505114 "$node_(109) setdest 120488 8643 8.0" 
$ns at 240.94335288915636 "$node_(109) setdest 53816 8195 14.0" 
$ns at 317.05078433188055 "$node_(109) setdest 56602 45779 1.0" 
$ns at 354.04901911504084 "$node_(109) setdest 9660 16223 4.0" 
$ns at 392.8669232663625 "$node_(109) setdest 154184 5079 1.0" 
$ns at 423.24491382278205 "$node_(109) setdest 61347 55298 12.0" 
$ns at 550.7660950723911 "$node_(109) setdest 197462 20808 11.0" 
$ns at 604.6217929637708 "$node_(109) setdest 20725 2626 5.0" 
$ns at 641.7983485552197 "$node_(109) setdest 172821 41918 12.0" 
$ns at 729.6815082341267 "$node_(109) setdest 82854 76113 12.0" 
$ns at 866.0049944552663 "$node_(109) setdest 171942 60739 11.0" 
$ns at 213.6980011791533 "$node_(110) setdest 4057 28038 1.0" 
$ns at 243.87922581975033 "$node_(110) setdest 69080 34249 9.0" 
$ns at 297.33888156938417 "$node_(110) setdest 20459 13609 2.0" 
$ns at 340.38553429601825 "$node_(110) setdest 65017 10151 20.0" 
$ns at 548.0898720408688 "$node_(110) setdest 67804 45428 16.0" 
$ns at 595.087793147595 "$node_(110) setdest 43210 48243 7.0" 
$ns at 644.5372380925604 "$node_(110) setdest 198578 27514 3.0" 
$ns at 702.6505896499755 "$node_(110) setdest 134031 71087 19.0" 
$ns at 875.8570202567662 "$node_(110) setdest 245410 7324 13.0" 
$ns at 102.00914321774877 "$node_(111) setdest 65191 7096 2.0" 
$ns at 148.14780152466156 "$node_(111) setdest 67304 8982 4.0" 
$ns at 205.046346858197 "$node_(111) setdest 52740 38473 7.0" 
$ns at 269.94360559268625 "$node_(111) setdest 124313 17217 4.0" 
$ns at 302.0361937694783 "$node_(111) setdest 154240 11369 4.0" 
$ns at 357.9212496606363 "$node_(111) setdest 45824 33353 15.0" 
$ns at 419.6861639628682 "$node_(111) setdest 164838 14857 12.0" 
$ns at 510.5020250522303 "$node_(111) setdest 54615 44129 9.0" 
$ns at 564.6843540100622 "$node_(111) setdest 32400 46704 2.0" 
$ns at 602.4427097209202 "$node_(111) setdest 26663 22303 16.0" 
$ns at 745.8132127828335 "$node_(111) setdest 143308 19633 6.0" 
$ns at 816.2972614132564 "$node_(111) setdest 64416 19766 14.0" 
$ns at 141.07452075934364 "$node_(112) setdest 2581 1763 10.0" 
$ns at 253.84916400476652 "$node_(112) setdest 78223 43631 19.0" 
$ns at 418.5285362009993 "$node_(112) setdest 23458 50270 14.0" 
$ns at 521.1784550103757 "$node_(112) setdest 13383 64103 5.0" 
$ns at 572.2937455844411 "$node_(112) setdest 203586 21988 15.0" 
$ns at 610.9195472064471 "$node_(112) setdest 191379 76076 17.0" 
$ns at 726.657383358281 "$node_(112) setdest 236632 18740 12.0" 
$ns at 852.4722074731541 "$node_(112) setdest 71537 21247 1.0" 
$ns at 887.9301928836877 "$node_(112) setdest 82530 35363 10.0" 
$ns at 114.12608529474782 "$node_(113) setdest 76109 20652 3.0" 
$ns at 156.89256388991413 "$node_(113) setdest 53372 8234 4.0" 
$ns at 189.46567914531923 "$node_(113) setdest 75836 42324 12.0" 
$ns at 267.3792513270745 "$node_(113) setdest 141583 38730 5.0" 
$ns at 331.5020425513669 "$node_(113) setdest 65244 777 9.0" 
$ns at 443.71984162717223 "$node_(113) setdest 159120 38849 6.0" 
$ns at 495.83831445992826 "$node_(113) setdest 147875 29972 2.0" 
$ns at 540.4905031708678 "$node_(113) setdest 137770 68583 13.0" 
$ns at 651.1375116067009 "$node_(113) setdest 11864 20395 6.0" 
$ns at 711.4237904907102 "$node_(113) setdest 140915 50081 1.0" 
$ns at 745.9825200316675 "$node_(113) setdest 30785 55135 19.0" 
$ns at 897.6444669217913 "$node_(113) setdest 249846 18846 16.0" 
$ns at 218.45800020086537 "$node_(114) setdest 112966 43387 13.0" 
$ns at 280.92469490735095 "$node_(114) setdest 153250 39164 11.0" 
$ns at 349.2038230713012 "$node_(114) setdest 160608 43292 11.0" 
$ns at 449.7759812594197 "$node_(114) setdest 148290 49076 19.0" 
$ns at 624.7001625090793 "$node_(114) setdest 14455 67114 6.0" 
$ns at 710.0900879650903 "$node_(114) setdest 156682 51859 4.0" 
$ns at 742.0845116493516 "$node_(114) setdest 59717 44944 4.0" 
$ns at 790.5911299371942 "$node_(114) setdest 128351 45202 7.0" 
$ns at 844.1995519501005 "$node_(114) setdest 233215 31335 14.0" 
$ns at 104.22931657407389 "$node_(115) setdest 45864 7673 15.0" 
$ns at 176.70175332310322 "$node_(115) setdest 49040 40211 9.0" 
$ns at 293.3095333061844 "$node_(115) setdest 68815 42262 7.0" 
$ns at 365.9780006566417 "$node_(115) setdest 90663 53685 17.0" 
$ns at 480.6828497067224 "$node_(115) setdest 128126 7491 3.0" 
$ns at 538.2418141317202 "$node_(115) setdest 50893 49007 6.0" 
$ns at 617.7810880754078 "$node_(115) setdest 34416 56668 17.0" 
$ns at 661.1445684754895 "$node_(115) setdest 126666 36714 11.0" 
$ns at 772.2608289650105 "$node_(115) setdest 178301 7190 15.0" 
$ns at 126.65840670737151 "$node_(116) setdest 52972 7976 15.0" 
$ns at 219.69366792531815 "$node_(116) setdest 44606 24219 15.0" 
$ns at 303.2135227989096 "$node_(116) setdest 142085 54127 1.0" 
$ns at 336.5382306542412 "$node_(116) setdest 115029 39078 18.0" 
$ns at 412.93152152515256 "$node_(116) setdest 67422 18462 18.0" 
$ns at 548.4415014336341 "$node_(116) setdest 122026 18116 3.0" 
$ns at 595.5637704547299 "$node_(116) setdest 113261 17611 2.0" 
$ns at 645.4190468411556 "$node_(116) setdest 225964 3658 1.0" 
$ns at 677.6023616439795 "$node_(116) setdest 44625 23935 2.0" 
$ns at 710.3586330226608 "$node_(116) setdest 31770 12711 9.0" 
$ns at 776.3627888385092 "$node_(116) setdest 213803 12310 13.0" 
$ns at 853.9086729025066 "$node_(116) setdest 236734 63308 5.0" 
$ns at 141.15766424711575 "$node_(117) setdest 69546 3379 13.0" 
$ns at 249.50347341328452 "$node_(117) setdest 15783 40194 14.0" 
$ns at 341.33152760471904 "$node_(117) setdest 141186 22946 13.0" 
$ns at 460.96896751844434 "$node_(117) setdest 23208 15904 8.0" 
$ns at 505.1615066794851 "$node_(117) setdest 80256 9632 13.0" 
$ns at 644.6979249482122 "$node_(117) setdest 74999 44037 13.0" 
$ns at 764.9705596327801 "$node_(117) setdest 166466 32917 19.0" 
$ns at 176.867637449873 "$node_(118) setdest 59774 29963 8.0" 
$ns at 253.77052601943672 "$node_(118) setdest 90859 16052 20.0" 
$ns at 347.69215982068624 "$node_(118) setdest 114367 5245 20.0" 
$ns at 421.60711663954413 "$node_(118) setdest 71680 12694 11.0" 
$ns at 494.61926803013375 "$node_(118) setdest 22231 33345 19.0" 
$ns at 571.6196888167908 "$node_(118) setdest 70105 37053 5.0" 
$ns at 632.7620781218328 "$node_(118) setdest 59001 16836 9.0" 
$ns at 743.1666935979946 "$node_(118) setdest 76043 77409 10.0" 
$ns at 832.8818156853237 "$node_(118) setdest 127947 37423 7.0" 
$ns at 886.6466650845823 "$node_(118) setdest 27399 12127 6.0" 
$ns at 129.45785086162635 "$node_(119) setdest 19121 1416 7.0" 
$ns at 213.75260403265634 "$node_(119) setdest 128423 9819 12.0" 
$ns at 301.7795465989566 "$node_(119) setdest 145956 38741 9.0" 
$ns at 342.07004819199824 "$node_(119) setdest 54313 44191 20.0" 
$ns at 564.7554817862144 "$node_(119) setdest 187808 33859 15.0" 
$ns at 715.1411501926654 "$node_(119) setdest 240604 35099 5.0" 
$ns at 770.4514983179891 "$node_(119) setdest 210093 86126 9.0" 
$ns at 832.1730072905423 "$node_(119) setdest 202868 8504 18.0" 
$ns at 143.61923402735522 "$node_(120) setdest 23930 26128 2.0" 
$ns at 181.15075993491484 "$node_(120) setdest 67897 38961 16.0" 
$ns at 248.07785171160674 "$node_(120) setdest 33060 38330 15.0" 
$ns at 415.9310629855054 "$node_(120) setdest 80018 16426 10.0" 
$ns at 478.32435273750787 "$node_(120) setdest 31566 54802 2.0" 
$ns at 517.9891936805928 "$node_(120) setdest 195543 68793 12.0" 
$ns at 556.6823107640446 "$node_(120) setdest 13580 56550 16.0" 
$ns at 705.9898648751738 "$node_(120) setdest 9633 41987 19.0" 
$ns at 890.0652829962186 "$node_(120) setdest 235673 32589 12.0" 
$ns at 210.22129402844047 "$node_(121) setdest 65678 6729 6.0" 
$ns at 246.71499573435955 "$node_(121) setdest 58433 30980 18.0" 
$ns at 430.93419652698526 "$node_(121) setdest 82075 46700 18.0" 
$ns at 575.9961410947819 "$node_(121) setdest 135968 44134 14.0" 
$ns at 677.1580913994474 "$node_(121) setdest 98868 43295 15.0" 
$ns at 758.483673006548 "$node_(121) setdest 209918 54023 7.0" 
$ns at 854.4537642573856 "$node_(121) setdest 238274 54968 17.0" 
$ns at 891.7065004630368 "$node_(121) setdest 257176 38691 3.0" 
$ns at 163.73657657145205 "$node_(122) setdest 4029 20357 20.0" 
$ns at 279.1504115089614 "$node_(122) setdest 74514 43833 17.0" 
$ns at 388.8572562495881 "$node_(122) setdest 128832 43375 12.0" 
$ns at 446.18328750771843 "$node_(122) setdest 59844 39390 2.0" 
$ns at 478.8971058753514 "$node_(122) setdest 147534 33953 10.0" 
$ns at 566.8689779071417 "$node_(122) setdest 179129 42639 15.0" 
$ns at 683.6485668053749 "$node_(122) setdest 14868 49888 15.0" 
$ns at 851.9456331810507 "$node_(122) setdest 237859 5600 15.0" 
$ns at 186.01229820041578 "$node_(123) setdest 1476 19476 3.0" 
$ns at 228.4422947214403 "$node_(123) setdest 61427 42813 19.0" 
$ns at 331.0079283480517 "$node_(123) setdest 138965 42701 16.0" 
$ns at 519.0465928535817 "$node_(123) setdest 193662 4231 9.0" 
$ns at 552.9050573725015 "$node_(123) setdest 38715 73628 2.0" 
$ns at 588.0737869251466 "$node_(123) setdest 225498 2895 9.0" 
$ns at 679.6992911541756 "$node_(123) setdest 195444 63966 19.0" 
$ns at 820.1019285614169 "$node_(123) setdest 65852 8670 13.0" 
$ns at 191.49950976662296 "$node_(124) setdest 125014 554 12.0" 
$ns at 257.5998565268132 "$node_(124) setdest 130209 39942 5.0" 
$ns at 315.6287427033106 "$node_(124) setdest 95874 2985 6.0" 
$ns at 391.07198855548995 "$node_(124) setdest 83869 62013 17.0" 
$ns at 570.4693661839708 "$node_(124) setdest 221846 358 3.0" 
$ns at 617.3764655007258 "$node_(124) setdest 176875 31334 11.0" 
$ns at 679.5848422363612 "$node_(124) setdest 18578 38811 9.0" 
$ns at 732.0693810505315 "$node_(124) setdest 239431 49197 17.0" 
$ns at 767.6374288332579 "$node_(124) setdest 87434 2452 2.0" 
$ns at 805.3487732466829 "$node_(124) setdest 73345 32349 19.0" 
$ns at 883.0569396621459 "$node_(124) setdest 28354 88290 13.0" 
$ns at 142.3738673415152 "$node_(125) setdest 86478 2818 17.0" 
$ns at 247.69740319693216 "$node_(125) setdest 133937 9499 14.0" 
$ns at 335.05070606632466 "$node_(125) setdest 134791 52299 6.0" 
$ns at 401.724784892467 "$node_(125) setdest 1676 52189 1.0" 
$ns at 435.77665507883574 "$node_(125) setdest 15456 6446 7.0" 
$ns at 509.04996748563485 "$node_(125) setdest 192468 9391 13.0" 
$ns at 606.0193000444376 "$node_(125) setdest 223308 34162 6.0" 
$ns at 648.173129613242 "$node_(125) setdest 48957 14979 4.0" 
$ns at 702.5529416517332 "$node_(125) setdest 80175 46094 8.0" 
$ns at 761.216226881667 "$node_(125) setdest 20611 4010 8.0" 
$ns at 804.211753536016 "$node_(125) setdest 167730 35641 2.0" 
$ns at 851.619380695596 "$node_(125) setdest 25362 13549 17.0" 
$ns at 120.50526117513945 "$node_(126) setdest 36470 8576 6.0" 
$ns at 178.50238952392448 "$node_(126) setdest 103685 42731 19.0" 
$ns at 248.73812336908097 "$node_(126) setdest 8255 3367 12.0" 
$ns at 339.95657605572893 "$node_(126) setdest 11601 7647 18.0" 
$ns at 476.64690337043515 "$node_(126) setdest 76385 7308 1.0" 
$ns at 511.53301990651676 "$node_(126) setdest 130377 62089 15.0" 
$ns at 668.9281848366926 "$node_(126) setdest 243917 74014 8.0" 
$ns at 773.6685575792701 "$node_(126) setdest 176173 84525 18.0" 
$ns at 854.9710190524205 "$node_(126) setdest 106758 27598 14.0" 
$ns at 179.32879116423356 "$node_(127) setdest 14521 23529 5.0" 
$ns at 234.233000552403 "$node_(127) setdest 82157 13979 17.0" 
$ns at 370.6369385130198 "$node_(127) setdest 156501 33001 16.0" 
$ns at 488.4043075270573 "$node_(127) setdest 123280 48059 4.0" 
$ns at 551.9301271316643 "$node_(127) setdest 174465 3687 5.0" 
$ns at 582.9153204977479 "$node_(127) setdest 195100 43247 1.0" 
$ns at 620.4306699929106 "$node_(127) setdest 194206 53520 17.0" 
$ns at 778.9959225454122 "$node_(127) setdest 70307 13017 14.0" 
$ns at 134.6558375582361 "$node_(128) setdest 72624 4778 20.0" 
$ns at 238.04677236489283 "$node_(128) setdest 21138 15242 5.0" 
$ns at 290.3230900101828 "$node_(128) setdest 49312 733 6.0" 
$ns at 366.7003974473797 "$node_(128) setdest 90187 51725 9.0" 
$ns at 438.75977219043364 "$node_(128) setdest 182307 21358 10.0" 
$ns at 527.1251204763015 "$node_(128) setdest 111037 21820 4.0" 
$ns at 577.0721587383777 "$node_(128) setdest 196075 68300 19.0" 
$ns at 782.141529571972 "$node_(128) setdest 158771 68025 16.0" 
$ns at 285.200099580333 "$node_(129) setdest 162072 14976 17.0" 
$ns at 408.3988813303189 "$node_(129) setdest 4657 33635 8.0" 
$ns at 465.0133719117942 "$node_(129) setdest 169499 26046 16.0" 
$ns at 645.6709322680841 "$node_(129) setdest 89861 15429 1.0" 
$ns at 678.5157584052198 "$node_(129) setdest 467 32235 19.0" 
$ns at 825.9923121000377 "$node_(129) setdest 244998 19795 19.0" 
$ns at 140.03749684755132 "$node_(130) setdest 5368 9949 14.0" 
$ns at 274.3798731428633 "$node_(130) setdest 147026 49696 9.0" 
$ns at 314.5746426552358 "$node_(130) setdest 45393 3469 16.0" 
$ns at 491.27715372978093 "$node_(130) setdest 97129 63971 13.0" 
$ns at 631.3718727809655 "$node_(130) setdest 19492 28532 17.0" 
$ns at 781.6147544649793 "$node_(130) setdest 54756 88090 4.0" 
$ns at 832.652955414718 "$node_(130) setdest 108078 12456 12.0" 
$ns at 888.8914191038945 "$node_(130) setdest 56517 55183 6.0" 
$ns at 152.4315194849947 "$node_(131) setdest 90016 29838 12.0" 
$ns at 189.28164541181474 "$node_(131) setdest 35878 40951 16.0" 
$ns at 366.25159446999146 "$node_(131) setdest 28796 63114 15.0" 
$ns at 472.94274957267766 "$node_(131) setdest 188311 1103 12.0" 
$ns at 617.0703170165439 "$node_(131) setdest 65632 15623 11.0" 
$ns at 728.8924018132967 "$node_(131) setdest 124741 42611 14.0" 
$ns at 824.8338519912581 "$node_(131) setdest 181601 49497 11.0" 
$ns at 112.76662969776956 "$node_(132) setdest 58096 11307 6.0" 
$ns at 184.35615009493588 "$node_(132) setdest 60557 15740 3.0" 
$ns at 219.0383408792437 "$node_(132) setdest 115016 28870 1.0" 
$ns at 250.70155474249432 "$node_(132) setdest 49791 41832 4.0" 
$ns at 307.3546147394872 "$node_(132) setdest 101623 49758 18.0" 
$ns at 463.2047666163427 "$node_(132) setdest 31108 34845 7.0" 
$ns at 497.1887300390912 "$node_(132) setdest 104061 57843 8.0" 
$ns at 547.1350573773502 "$node_(132) setdest 10130 25566 6.0" 
$ns at 605.648764627016 "$node_(132) setdest 142480 27945 7.0" 
$ns at 684.4887007063508 "$node_(132) setdest 205565 20867 19.0" 
$ns at 809.4333289614565 "$node_(132) setdest 20826 2845 15.0" 
$ns at 858.5833956559873 "$node_(132) setdest 266450 77316 8.0" 
$ns at 890.1039381375242 "$node_(132) setdest 245879 85447 16.0" 
$ns at 129.45604581455527 "$node_(133) setdest 60821 10512 16.0" 
$ns at 180.6432545938528 "$node_(133) setdest 29289 14171 6.0" 
$ns at 259.10922383783 "$node_(133) setdest 6095 9232 13.0" 
$ns at 317.044190068511 "$node_(133) setdest 126830 5226 5.0" 
$ns at 351.44430446497086 "$node_(133) setdest 152786 37763 1.0" 
$ns at 382.8754221150881 "$node_(133) setdest 46952 21938 13.0" 
$ns at 422.3376699772686 "$node_(133) setdest 12025 31884 4.0" 
$ns at 459.48171479777295 "$node_(133) setdest 86162 4945 17.0" 
$ns at 491.8382183981294 "$node_(133) setdest 91749 67723 1.0" 
$ns at 523.558776075552 "$node_(133) setdest 97118 11805 2.0" 
$ns at 559.06620149082 "$node_(133) setdest 69505 63476 13.0" 
$ns at 627.1347144827178 "$node_(133) setdest 11242 65627 12.0" 
$ns at 723.0216663396834 "$node_(133) setdest 80725 67249 2.0" 
$ns at 756.4673310177881 "$node_(133) setdest 63312 54853 9.0" 
$ns at 811.1596307572865 "$node_(133) setdest 263585 6060 10.0" 
$ns at 262.97623263375806 "$node_(134) setdest 90415 23560 10.0" 
$ns at 358.7345249291469 "$node_(134) setdest 170350 36706 16.0" 
$ns at 433.8388087279204 "$node_(134) setdest 171948 10993 10.0" 
$ns at 509.771689432181 "$node_(134) setdest 123632 8687 14.0" 
$ns at 676.9672943009049 "$node_(134) setdest 133213 15894 1.0" 
$ns at 715.0205914575685 "$node_(134) setdest 86855 5109 19.0" 
$ns at 754.3580559627981 "$node_(134) setdest 118049 43638 3.0" 
$ns at 799.2672800710433 "$node_(134) setdest 194066 52810 12.0" 
$ns at 179.25251269538586 "$node_(135) setdest 81696 26493 7.0" 
$ns at 226.9610905105328 "$node_(135) setdest 83914 15068 16.0" 
$ns at 401.3395191963038 "$node_(135) setdest 124263 1363 12.0" 
$ns at 549.8374748196668 "$node_(135) setdest 179018 23290 15.0" 
$ns at 600.1499610351491 "$node_(135) setdest 126386 4866 15.0" 
$ns at 669.3612595542252 "$node_(135) setdest 157225 38713 14.0" 
$ns at 714.7506644254918 "$node_(135) setdest 89020 41776 16.0" 
$ns at 751.6397568651322 "$node_(135) setdest 113206 42785 9.0" 
$ns at 859.6657107063909 "$node_(135) setdest 85429 66127 4.0" 
$ns at 128.8624305099559 "$node_(136) setdest 72228 319 5.0" 
$ns at 179.06235364933758 "$node_(136) setdest 124540 37103 7.0" 
$ns at 224.46981958709952 "$node_(136) setdest 72117 37407 10.0" 
$ns at 313.3542121562712 "$node_(136) setdest 20492 4309 6.0" 
$ns at 379.5998245843483 "$node_(136) setdest 182691 55143 6.0" 
$ns at 427.15304802059933 "$node_(136) setdest 31421 59293 13.0" 
$ns at 541.02737798563 "$node_(136) setdest 92793 33108 15.0" 
$ns at 713.2249676648203 "$node_(136) setdest 124162 28210 18.0" 
$ns at 799.225947079293 "$node_(136) setdest 53893 28709 12.0" 
$ns at 847.4671934261111 "$node_(136) setdest 238037 46222 19.0" 
$ns at 170.06781599537294 "$node_(137) setdest 74270 37517 2.0" 
$ns at 218.62250778935845 "$node_(137) setdest 23772 11255 4.0" 
$ns at 281.08828965334635 "$node_(137) setdest 98575 31058 11.0" 
$ns at 332.55977694641496 "$node_(137) setdest 95156 15192 6.0" 
$ns at 363.4102672748754 "$node_(137) setdest 114347 53534 7.0" 
$ns at 446.39637142022764 "$node_(137) setdest 171789 54547 1.0" 
$ns at 478.2817895544145 "$node_(137) setdest 29999 15237 1.0" 
$ns at 508.91608328177455 "$node_(137) setdest 168471 47266 16.0" 
$ns at 589.4453687469195 "$node_(137) setdest 70210 55721 12.0" 
$ns at 733.1892928319062 "$node_(137) setdest 44832 70034 10.0" 
$ns at 835.5917426956885 "$node_(137) setdest 30485 88849 8.0" 
$ns at 126.14426698848438 "$node_(138) setdest 58534 19131 14.0" 
$ns at 236.24835679393811 "$node_(138) setdest 25152 26318 4.0" 
$ns at 291.4473960377728 "$node_(138) setdest 40140 33485 11.0" 
$ns at 365.47756784669315 "$node_(138) setdest 165689 55839 12.0" 
$ns at 448.0964697882142 "$node_(138) setdest 81846 34128 3.0" 
$ns at 483.2174699409823 "$node_(138) setdest 201019 38038 7.0" 
$ns at 514.060511619367 "$node_(138) setdest 136124 17450 13.0" 
$ns at 672.9227210080771 "$node_(138) setdest 50414 63742 5.0" 
$ns at 725.9231546743238 "$node_(138) setdest 56742 30667 11.0" 
$ns at 763.8929541587477 "$node_(138) setdest 116794 55792 17.0" 
$ns at 161.80994430916274 "$node_(139) setdest 3469 42709 5.0" 
$ns at 233.15393852759104 "$node_(139) setdest 82840 32926 17.0" 
$ns at 350.1749627467501 "$node_(139) setdest 17296 44222 8.0" 
$ns at 387.93438498504327 "$node_(139) setdest 156498 38467 14.0" 
$ns at 545.5970979213173 "$node_(139) setdest 24631 15550 10.0" 
$ns at 600.5411724155489 "$node_(139) setdest 203725 44773 18.0" 
$ns at 723.7263313420092 "$node_(139) setdest 90094 21919 2.0" 
$ns at 758.5929578899933 "$node_(139) setdest 164880 68276 2.0" 
$ns at 790.5046586004457 "$node_(139) setdest 7795 39548 17.0" 
$ns at 120.08668998108719 "$node_(140) setdest 87508 18964 8.0" 
$ns at 198.83699894070463 "$node_(140) setdest 35851 17855 1.0" 
$ns at 233.34518283528925 "$node_(140) setdest 40185 17444 2.0" 
$ns at 268.4890580478078 "$node_(140) setdest 89381 25485 17.0" 
$ns at 395.7291378704831 "$node_(140) setdest 129301 4973 8.0" 
$ns at 462.3857417843499 "$node_(140) setdest 170535 8272 7.0" 
$ns at 516.2092681338871 "$node_(140) setdest 104006 52418 17.0" 
$ns at 682.0995252697792 "$node_(140) setdest 35236 57186 12.0" 
$ns at 752.2639259679955 "$node_(140) setdest 190218 29465 8.0" 
$ns at 794.4006096095046 "$node_(140) setdest 26316 36993 17.0" 
$ns at 863.9825511681913 "$node_(140) setdest 264806 27338 11.0" 
$ns at 148.9023343019399 "$node_(141) setdest 82296 25549 2.0" 
$ns at 196.77074217810244 "$node_(141) setdest 68898 40070 20.0" 
$ns at 287.21527879832337 "$node_(141) setdest 10173 30055 15.0" 
$ns at 328.60974621801483 "$node_(141) setdest 27547 1239 14.0" 
$ns at 422.06055209548657 "$node_(141) setdest 179603 57332 13.0" 
$ns at 560.563575831641 "$node_(141) setdest 159536 51971 10.0" 
$ns at 592.0808571655605 "$node_(141) setdest 164766 70971 10.0" 
$ns at 703.7095976380609 "$node_(141) setdest 31642 17510 19.0" 
$ns at 203.1706395378661 "$node_(142) setdest 96 21772 18.0" 
$ns at 319.24154705604576 "$node_(142) setdest 18667 40577 12.0" 
$ns at 449.9441140558822 "$node_(142) setdest 173937 37518 8.0" 
$ns at 491.59069201437393 "$node_(142) setdest 146202 18368 1.0" 
$ns at 529.5639824154175 "$node_(142) setdest 27912 9115 16.0" 
$ns at 605.0412665936087 "$node_(142) setdest 212968 51019 12.0" 
$ns at 753.2195991216954 "$node_(142) setdest 180090 37731 13.0" 
$ns at 794.1590704408064 "$node_(142) setdest 239622 14147 20.0" 
$ns at 857.5322977113477 "$node_(142) setdest 94028 56007 20.0" 
$ns at 249.2376994191942 "$node_(143) setdest 62383 12520 3.0" 
$ns at 294.52429796769974 "$node_(143) setdest 139817 16690 12.0" 
$ns at 432.6280241451717 "$node_(143) setdest 181959 44722 18.0" 
$ns at 612.1243622424947 "$node_(143) setdest 35542 52629 16.0" 
$ns at 743.1688877338336 "$node_(143) setdest 111877 72324 2.0" 
$ns at 782.6195613692468 "$node_(143) setdest 255728 77827 12.0" 
$ns at 173.0720402642236 "$node_(144) setdest 102025 39965 4.0" 
$ns at 217.13805701427927 "$node_(144) setdest 35206 16876 11.0" 
$ns at 248.45953761118656 "$node_(144) setdest 46051 1434 1.0" 
$ns at 282.87616131326985 "$node_(144) setdest 107491 38682 12.0" 
$ns at 352.38422798057627 "$node_(144) setdest 83377 1409 18.0" 
$ns at 492.1240468038869 "$node_(144) setdest 153512 8936 11.0" 
$ns at 544.404224039827 "$node_(144) setdest 202549 43622 10.0" 
$ns at 663.5378955747638 "$node_(144) setdest 14010 40621 10.0" 
$ns at 767.009070792686 "$node_(144) setdest 163214 27567 14.0" 
$ns at 798.0955741942796 "$node_(144) setdest 18441 87980 17.0" 
$ns at 122.84629355685446 "$node_(145) setdest 70909 7715 19.0" 
$ns at 314.4066679323201 "$node_(145) setdest 26205 34469 13.0" 
$ns at 423.22141048877273 "$node_(145) setdest 66033 52956 3.0" 
$ns at 477.3734421625361 "$node_(145) setdest 10055 33260 15.0" 
$ns at 532.7245303900794 "$node_(145) setdest 153091 41639 10.0" 
$ns at 647.0227610095109 "$node_(145) setdest 168464 17836 14.0" 
$ns at 734.2141883224821 "$node_(145) setdest 146110 9261 13.0" 
$ns at 781.6587579804207 "$node_(145) setdest 107811 44299 18.0" 
$ns at 891.527309736263 "$node_(145) setdest 21065 44906 5.0" 
$ns at 179.70784836156844 "$node_(146) setdest 50937 40359 1.0" 
$ns at 216.42489234002895 "$node_(146) setdest 15651 21295 4.0" 
$ns at 268.3800438693174 "$node_(146) setdest 117823 22860 20.0" 
$ns at 430.39868224029874 "$node_(146) setdest 74254 19784 2.0" 
$ns at 471.24335301650547 "$node_(146) setdest 20096 52871 14.0" 
$ns at 537.7938705551161 "$node_(146) setdest 47475 40440 19.0" 
$ns at 755.5559444467651 "$node_(146) setdest 25737 70544 10.0" 
$ns at 872.2997730483697 "$node_(146) setdest 179006 18576 8.0" 
$ns at 108.5184701962123 "$node_(147) setdest 8551 385 18.0" 
$ns at 263.1108948778051 "$node_(147) setdest 93763 10845 17.0" 
$ns at 384.06007503368164 "$node_(147) setdest 25016 4551 10.0" 
$ns at 414.90521354101304 "$node_(147) setdest 105131 45786 15.0" 
$ns at 557.2438443178262 "$node_(147) setdest 146716 53101 17.0" 
$ns at 692.7864115196282 "$node_(147) setdest 59225 21808 8.0" 
$ns at 739.3953232835363 "$node_(147) setdest 154792 1203 15.0" 
$ns at 778.1490320300306 "$node_(147) setdest 217611 5686 18.0" 
$ns at 129.55955863771234 "$node_(148) setdest 94697 12713 5.0" 
$ns at 186.65149093931504 "$node_(148) setdest 102868 29786 3.0" 
$ns at 235.5834409386968 "$node_(148) setdest 61487 33859 10.0" 
$ns at 297.06848357331023 "$node_(148) setdest 92743 2321 6.0" 
$ns at 335.33798321803624 "$node_(148) setdest 135863 48400 3.0" 
$ns at 389.57409666655474 "$node_(148) setdest 143129 30206 9.0" 
$ns at 442.8753493361653 "$node_(148) setdest 166119 45615 18.0" 
$ns at 577.333027761827 "$node_(148) setdest 152394 67749 16.0" 
$ns at 667.378251693568 "$node_(148) setdest 62011 34509 12.0" 
$ns at 749.599587636003 "$node_(148) setdest 221580 61581 8.0" 
$ns at 787.5264821744621 "$node_(148) setdest 210437 31417 3.0" 
$ns at 826.668619525098 "$node_(148) setdest 241628 63415 6.0" 
$ns at 864.5532899831245 "$node_(148) setdest 179774 13542 7.0" 
$ns at 110.94825085306329 "$node_(149) setdest 18746 25049 18.0" 
$ns at 202.65567394791054 "$node_(149) setdest 12169 2439 15.0" 
$ns at 359.34755457755523 "$node_(149) setdest 93749 21753 3.0" 
$ns at 391.3704798009383 "$node_(149) setdest 13059 30628 7.0" 
$ns at 482.749644603314 "$node_(149) setdest 173957 7594 2.0" 
$ns at 515.5184343816437 "$node_(149) setdest 116697 44117 3.0" 
$ns at 547.1069200447776 "$node_(149) setdest 199975 48867 16.0" 
$ns at 581.873457298042 "$node_(149) setdest 104914 14370 8.0" 
$ns at 687.4989486100137 "$node_(149) setdest 125600 12933 13.0" 
$ns at 756.6431396046701 "$node_(149) setdest 64735 30624 5.0" 
$ns at 817.7805060251951 "$node_(149) setdest 69840 59428 18.0" 
$ns at 271.1036455983631 "$node_(150) setdest 113991 31522 19.0" 
$ns at 319.8438344617487 "$node_(150) setdest 75496 18101 3.0" 
$ns at 361.9716604233781 "$node_(150) setdest 173678 3614 8.0" 
$ns at 467.2434631703843 "$node_(150) setdest 315 27516 12.0" 
$ns at 579.1920856939865 "$node_(150) setdest 152414 44865 7.0" 
$ns at 664.2060407667202 "$node_(150) setdest 196346 51617 9.0" 
$ns at 728.3198186526058 "$node_(150) setdest 115343 18354 18.0" 
$ns at 847.1225360583076 "$node_(150) setdest 53138 84340 4.0" 
$ns at 899.3959780213794 "$node_(150) setdest 18059 28476 14.0" 
$ns at 119.4714986045607 "$node_(151) setdest 93842 20288 18.0" 
$ns at 244.80640567268728 "$node_(151) setdest 81257 30992 11.0" 
$ns at 342.27880710681484 "$node_(151) setdest 158966 47617 3.0" 
$ns at 388.76416946532447 "$node_(151) setdest 3859 39833 11.0" 
$ns at 432.8484957868051 "$node_(151) setdest 96103 55270 6.0" 
$ns at 477.2868622048334 "$node_(151) setdest 70435 12021 9.0" 
$ns at 596.0132014686939 "$node_(151) setdest 208082 37819 6.0" 
$ns at 656.2428568046104 "$node_(151) setdest 167622 62788 14.0" 
$ns at 765.5823114177057 "$node_(151) setdest 106962 64936 14.0" 
$ns at 847.3127933679689 "$node_(151) setdest 217426 60241 1.0" 
$ns at 882.7300100180616 "$node_(151) setdest 145026 58835 13.0" 
$ns at 204.96465205773245 "$node_(152) setdest 55956 19459 18.0" 
$ns at 346.33034352370896 "$node_(152) setdest 26538 51234 15.0" 
$ns at 422.73380014667 "$node_(152) setdest 30053 49269 12.0" 
$ns at 489.74066993464737 "$node_(152) setdest 28663 48447 1.0" 
$ns at 524.7945691518061 "$node_(152) setdest 155936 32352 2.0" 
$ns at 559.7733544174126 "$node_(152) setdest 64296 7866 9.0" 
$ns at 635.0930535977434 "$node_(152) setdest 213128 2471 11.0" 
$ns at 713.470867206322 "$node_(152) setdest 70019 56595 4.0" 
$ns at 748.1686619871757 "$node_(152) setdest 241037 44284 11.0" 
$ns at 819.047902277742 "$node_(152) setdest 32800 9773 14.0" 
$ns at 106.07590184534291 "$node_(153) setdest 90469 28949 8.0" 
$ns at 178.78098565390525 "$node_(153) setdest 51103 14947 10.0" 
$ns at 304.8979566645012 "$node_(153) setdest 88232 5962 4.0" 
$ns at 372.1142744291934 "$node_(153) setdest 124640 2606 3.0" 
$ns at 403.3209311434431 "$node_(153) setdest 82918 14158 20.0" 
$ns at 549.2236373036616 "$node_(153) setdest 144218 44247 9.0" 
$ns at 652.8014732746625 "$node_(153) setdest 113097 10046 10.0" 
$ns at 756.0955748973465 "$node_(153) setdest 264487 48041 16.0" 
$ns at 875.1338844945827 "$node_(153) setdest 223861 84732 10.0" 
$ns at 139.45477256822215 "$node_(154) setdest 31556 9938 5.0" 
$ns at 185.05026594776746 "$node_(154) setdest 34391 8121 10.0" 
$ns at 238.56115498376192 "$node_(154) setdest 548 3783 8.0" 
$ns at 337.7722871415174 "$node_(154) setdest 84068 10177 14.0" 
$ns at 485.5465253955004 "$node_(154) setdest 173316 26874 2.0" 
$ns at 518.4904043783704 "$node_(154) setdest 27784 1344 17.0" 
$ns at 557.9983353488082 "$node_(154) setdest 60664 76519 13.0" 
$ns at 627.1859681527303 "$node_(154) setdest 140969 50604 18.0" 
$ns at 661.407865084741 "$node_(154) setdest 162955 3644 13.0" 
$ns at 701.0774269532753 "$node_(154) setdest 245275 9868 13.0" 
$ns at 793.2587917618273 "$node_(154) setdest 108488 12239 10.0" 
$ns at 842.0762389159654 "$node_(154) setdest 179336 85201 16.0" 
$ns at 215.67326033527402 "$node_(155) setdest 24986 24158 16.0" 
$ns at 377.534285903105 "$node_(155) setdest 128866 530 6.0" 
$ns at 413.1935551664995 "$node_(155) setdest 106964 732 14.0" 
$ns at 459.57622085751177 "$node_(155) setdest 164204 14992 15.0" 
$ns at 539.893153400913 "$node_(155) setdest 95788 56722 3.0" 
$ns at 594.7043524084407 "$node_(155) setdest 14440 31800 10.0" 
$ns at 672.4932936114344 "$node_(155) setdest 51487 2062 1.0" 
$ns at 711.4563347838173 "$node_(155) setdest 52982 78712 10.0" 
$ns at 785.9626202070255 "$node_(155) setdest 5906 69679 4.0" 
$ns at 816.0960033704025 "$node_(155) setdest 174012 25597 17.0" 
$ns at 112.75042772794379 "$node_(156) setdest 14495 24281 1.0" 
$ns at 149.83500488310372 "$node_(156) setdest 33259 1147 5.0" 
$ns at 221.39604971828084 "$node_(156) setdest 5370 26735 10.0" 
$ns at 251.45255647894163 "$node_(156) setdest 98672 6658 9.0" 
$ns at 331.20135744112076 "$node_(156) setdest 40693 48018 7.0" 
$ns at 376.54108610285016 "$node_(156) setdest 84471 38358 18.0" 
$ns at 416.80467503529485 "$node_(156) setdest 164254 23214 13.0" 
$ns at 551.5338279231698 "$node_(156) setdest 160829 57806 10.0" 
$ns at 600.1263715860534 "$node_(156) setdest 212956 9711 9.0" 
$ns at 685.4075383889067 "$node_(156) setdest 141064 45870 10.0" 
$ns at 805.8868564399887 "$node_(156) setdest 116185 28993 13.0" 
$ns at 203.67180014757463 "$node_(157) setdest 22567 36023 9.0" 
$ns at 269.60422126888665 "$node_(157) setdest 44978 26480 5.0" 
$ns at 318.93824899978193 "$node_(157) setdest 111084 16156 5.0" 
$ns at 375.2174001296559 "$node_(157) setdest 72292 51974 10.0" 
$ns at 472.6010680425678 "$node_(157) setdest 143044 61377 1.0" 
$ns at 505.62037883250343 "$node_(157) setdest 17888 10216 16.0" 
$ns at 682.7255688460538 "$node_(157) setdest 197874 22974 15.0" 
$ns at 784.4962074551811 "$node_(157) setdest 47462 83732 6.0" 
$ns at 863.3366686563699 "$node_(157) setdest 117020 65496 19.0" 
$ns at 108.4676068647185 "$node_(158) setdest 79830 77 12.0" 
$ns at 240.67804644393783 "$node_(158) setdest 70562 29676 6.0" 
$ns at 329.02295698178955 "$node_(158) setdest 103175 31912 19.0" 
$ns at 465.5084868997481 "$node_(158) setdest 23977 4173 9.0" 
$ns at 501.13128581379016 "$node_(158) setdest 177834 18793 11.0" 
$ns at 620.3520231852045 "$node_(158) setdest 179798 20028 16.0" 
$ns at 803.808805423649 "$node_(158) setdest 151199 31811 7.0" 
$ns at 890.0295779474725 "$node_(158) setdest 23143 32097 8.0" 
$ns at 240.52055054173996 "$node_(159) setdest 69301 27052 4.0" 
$ns at 306.0945374669626 "$node_(159) setdest 55959 21343 2.0" 
$ns at 351.1562840040113 "$node_(159) setdest 22479 17277 19.0" 
$ns at 424.1154923339058 "$node_(159) setdest 186455 60980 1.0" 
$ns at 463.31446813124046 "$node_(159) setdest 195251 68939 1.0" 
$ns at 498.14514500609437 "$node_(159) setdest 15882 66861 6.0" 
$ns at 556.1102155713061 "$node_(159) setdest 85702 50836 16.0" 
$ns at 637.8243847192866 "$node_(159) setdest 123888 54196 1.0" 
$ns at 668.1606054177369 "$node_(159) setdest 75376 28757 11.0" 
$ns at 707.6721160791387 "$node_(159) setdest 151904 27916 11.0" 
$ns at 846.9789097934538 "$node_(159) setdest 33658 22469 2.0" 
$ns at 878.368329191955 "$node_(159) setdest 104260 51813 12.0" 
$ns at 147.0770845154394 "$node_(160) setdest 58064 20928 8.0" 
$ns at 210.37521201393858 "$node_(160) setdest 28712 14471 6.0" 
$ns at 277.06565636402877 "$node_(160) setdest 25439 3905 7.0" 
$ns at 352.4607982866163 "$node_(160) setdest 13423 36245 11.0" 
$ns at 488.77788688992433 "$node_(160) setdest 195218 9459 13.0" 
$ns at 632.689835033325 "$node_(160) setdest 78487 52426 5.0" 
$ns at 674.7553030287744 "$node_(160) setdest 233462 68267 13.0" 
$ns at 812.1911548121 "$node_(160) setdest 11497 48374 2.0" 
$ns at 856.0058660577805 "$node_(160) setdest 237631 70521 6.0" 
$ns at 160.93988693740434 "$node_(161) setdest 48974 23922 19.0" 
$ns at 295.5515712808884 "$node_(161) setdest 99872 29130 19.0" 
$ns at 338.91000949057496 "$node_(161) setdest 155247 33677 5.0" 
$ns at 372.6786399991216 "$node_(161) setdest 47249 42833 20.0" 
$ns at 436.6571440027108 "$node_(161) setdest 37766 15705 9.0" 
$ns at 485.12612883827114 "$node_(161) setdest 24579 9898 18.0" 
$ns at 687.942694395509 "$node_(161) setdest 149913 27068 8.0" 
$ns at 733.444111145787 "$node_(161) setdest 207419 72959 1.0" 
$ns at 773.4072607234307 "$node_(161) setdest 70987 68945 19.0" 
$ns at 245.088321613448 "$node_(162) setdest 41725 37895 3.0" 
$ns at 283.46367713003536 "$node_(162) setdest 24265 40936 12.0" 
$ns at 375.6813587910128 "$node_(162) setdest 48010 9182 15.0" 
$ns at 477.8277233032444 "$node_(162) setdest 184684 51712 19.0" 
$ns at 647.9818955510849 "$node_(162) setdest 87703 34941 20.0" 
$ns at 792.5769901247402 "$node_(162) setdest 168777 52518 18.0" 
$ns at 831.7214620509411 "$node_(162) setdest 159431 59999 11.0" 
$ns at 109.88769671561533 "$node_(163) setdest 50388 7069 15.0" 
$ns at 143.04657299618876 "$node_(163) setdest 46186 22737 6.0" 
$ns at 178.17093117176313 "$node_(163) setdest 67767 14328 17.0" 
$ns at 276.67753616320124 "$node_(163) setdest 44991 39868 16.0" 
$ns at 378.6502332174377 "$node_(163) setdest 111155 58489 2.0" 
$ns at 415.27482259512556 "$node_(163) setdest 121233 53406 1.0" 
$ns at 447.2458526351238 "$node_(163) setdest 12689 39207 10.0" 
$ns at 551.6748269758388 "$node_(163) setdest 99004 19846 13.0" 
$ns at 685.2252691613552 "$node_(163) setdest 205974 54841 2.0" 
$ns at 720.166573061511 "$node_(163) setdest 178825 56370 6.0" 
$ns at 756.0839142935145 "$node_(163) setdest 196787 25931 2.0" 
$ns at 804.9370916642667 "$node_(163) setdest 132512 2500 16.0" 
$ns at 153.49632153716217 "$node_(164) setdest 3 9895 18.0" 
$ns at 310.4013316825325 "$node_(164) setdest 157458 10242 6.0" 
$ns at 388.35483618042485 "$node_(164) setdest 36571 48339 17.0" 
$ns at 437.82372912622566 "$node_(164) setdest 71290 36045 8.0" 
$ns at 504.40209125260924 "$node_(164) setdest 52238 26883 15.0" 
$ns at 548.2948444056842 "$node_(164) setdest 82026 5923 8.0" 
$ns at 607.477100809641 "$node_(164) setdest 14240 70355 10.0" 
$ns at 727.4697403988288 "$node_(164) setdest 246719 10792 9.0" 
$ns at 792.826135131769 "$node_(164) setdest 30430 8037 1.0" 
$ns at 825.8394009400461 "$node_(164) setdest 66495 57738 3.0" 
$ns at 863.4850285518351 "$node_(164) setdest 50026 6012 18.0" 
$ns at 202.73281612616836 "$node_(165) setdest 43429 39404 17.0" 
$ns at 294.788514395005 "$node_(165) setdest 29282 25675 10.0" 
$ns at 408.33798815152875 "$node_(165) setdest 48168 55826 17.0" 
$ns at 505.0386104217007 "$node_(165) setdest 73537 60422 2.0" 
$ns at 554.5982601913956 "$node_(165) setdest 211836 63265 18.0" 
$ns at 760.5532604130835 "$node_(165) setdest 72589 87037 11.0" 
$ns at 873.5002773509689 "$node_(165) setdest 175741 3600 1.0" 
$ns at 144.37048454969937 "$node_(166) setdest 35640 30427 8.0" 
$ns at 240.22036208491033 "$node_(166) setdest 89009 2447 19.0" 
$ns at 326.8614470974158 "$node_(166) setdest 157375 16382 9.0" 
$ns at 441.622190975184 "$node_(166) setdest 153203 34769 10.0" 
$ns at 545.8548026089281 "$node_(166) setdest 44782 69147 3.0" 
$ns at 580.5029357138764 "$node_(166) setdest 297 33614 3.0" 
$ns at 614.7021379763476 "$node_(166) setdest 84299 1622 10.0" 
$ns at 722.7381550853526 "$node_(166) setdest 54762 11885 17.0" 
$ns at 822.0459582201065 "$node_(166) setdest 54593 58771 10.0" 
$ns at 876.1998399175142 "$node_(166) setdest 94281 72554 7.0" 
$ns at 124.93161008062734 "$node_(167) setdest 58780 22374 20.0" 
$ns at 225.14836636086025 "$node_(167) setdest 88710 31941 12.0" 
$ns at 269.4332869368955 "$node_(167) setdest 75340 56 11.0" 
$ns at 317.04370962505226 "$node_(167) setdest 108114 41771 2.0" 
$ns at 366.84394662821376 "$node_(167) setdest 108717 34679 9.0" 
$ns at 460.9849768366471 "$node_(167) setdest 64772 14531 17.0" 
$ns at 530.7481206706775 "$node_(167) setdest 98902 8537 3.0" 
$ns at 577.0872018526162 "$node_(167) setdest 212420 61781 5.0" 
$ns at 617.9789768117415 "$node_(167) setdest 183631 4584 13.0" 
$ns at 675.7086731746027 "$node_(167) setdest 101305 5496 18.0" 
$ns at 740.1627682148044 "$node_(167) setdest 48705 75052 13.0" 
$ns at 874.0541536144729 "$node_(167) setdest 22601 59641 19.0" 
$ns at 117.4557727753797 "$node_(168) setdest 38797 8800 10.0" 
$ns at 148.11731366588043 "$node_(168) setdest 39150 2911 12.0" 
$ns at 183.32934081407512 "$node_(168) setdest 116696 21333 18.0" 
$ns at 385.6898622792004 "$node_(168) setdest 113637 40362 4.0" 
$ns at 438.4311486271516 "$node_(168) setdest 88181 19917 17.0" 
$ns at 502.7536115016552 "$node_(168) setdest 97755 42544 14.0" 
$ns at 606.5868239542006 "$node_(168) setdest 95561 42389 8.0" 
$ns at 648.0893666053438 "$node_(168) setdest 146673 75295 20.0" 
$ns at 797.0486783200092 "$node_(168) setdest 8490 64526 6.0" 
$ns at 855.935805971674 "$node_(168) setdest 189174 670 12.0" 
$ns at 141.35626925298766 "$node_(169) setdest 26939 15962 13.0" 
$ns at 173.83138314813704 "$node_(169) setdest 52861 24800 7.0" 
$ns at 215.2930128205271 "$node_(169) setdest 98224 40254 13.0" 
$ns at 369.24193071246145 "$node_(169) setdest 21746 204 10.0" 
$ns at 424.2485507924939 "$node_(169) setdest 147171 51901 10.0" 
$ns at 540.149531638268 "$node_(169) setdest 86497 3867 5.0" 
$ns at 607.6032608536598 "$node_(169) setdest 203743 15659 13.0" 
$ns at 687.0188199236645 "$node_(169) setdest 128000 41210 3.0" 
$ns at 744.4019104074853 "$node_(169) setdest 219805 38640 2.0" 
$ns at 793.0143289286998 "$node_(169) setdest 107550 19314 4.0" 
$ns at 835.7413732900437 "$node_(169) setdest 954 36214 11.0" 
$ns at 877.475234737436 "$node_(169) setdest 43194 49228 10.0" 
$ns at 144.68030698543254 "$node_(170) setdest 78265 452 7.0" 
$ns at 203.41236526192927 "$node_(170) setdest 85502 36001 6.0" 
$ns at 270.64013710305915 "$node_(170) setdest 74231 33616 15.0" 
$ns at 344.0156787722284 "$node_(170) setdest 72109 43290 4.0" 
$ns at 391.74911209227054 "$node_(170) setdest 185985 35058 4.0" 
$ns at 454.9039884593696 "$node_(170) setdest 5129 35215 5.0" 
$ns at 496.64544552237965 "$node_(170) setdest 91972 35557 7.0" 
$ns at 566.8188488194735 "$node_(170) setdest 111708 1890 11.0" 
$ns at 674.0990790693811 "$node_(170) setdest 88203 45632 16.0" 
$ns at 705.3225237150983 "$node_(170) setdest 159214 41104 12.0" 
$ns at 853.7675315702681 "$node_(170) setdest 78635 5056 13.0" 
$ns at 131.37231826596087 "$node_(171) setdest 34553 30034 16.0" 
$ns at 184.82143242545862 "$node_(171) setdest 126111 27162 14.0" 
$ns at 330.0676998827629 "$node_(171) setdest 19404 19040 1.0" 
$ns at 367.20391945404106 "$node_(171) setdest 3703 42592 14.0" 
$ns at 453.71698992476905 "$node_(171) setdest 41370 14139 9.0" 
$ns at 491.79952917163416 "$node_(171) setdest 184978 61668 19.0" 
$ns at 655.5724367406726 "$node_(171) setdest 153286 25889 10.0" 
$ns at 754.6155403453095 "$node_(171) setdest 111565 31601 10.0" 
$ns at 802.0844408932314 "$node_(171) setdest 90692 23650 8.0" 
$ns at 859.6669244790332 "$node_(171) setdest 267502 4084 10.0" 
$ns at 898.6762483654901 "$node_(171) setdest 68912 4586 16.0" 
$ns at 114.71995124101791 "$node_(172) setdest 39511 12556 16.0" 
$ns at 288.2354506474693 "$node_(172) setdest 46906 12234 14.0" 
$ns at 411.46539962837574 "$node_(172) setdest 178377 21645 4.0" 
$ns at 455.2721565944677 "$node_(172) setdest 69381 67730 2.0" 
$ns at 504.45244221474985 "$node_(172) setdest 163226 48807 9.0" 
$ns at 561.5419181713795 "$node_(172) setdest 199938 59667 6.0" 
$ns at 619.5406323849394 "$node_(172) setdest 70747 11638 20.0" 
$ns at 677.8575100563295 "$node_(172) setdest 143449 44570 14.0" 
$ns at 800.0048811035365 "$node_(172) setdest 242565 78793 18.0" 
$ns at 847.4577271557873 "$node_(172) setdest 80799 16886 13.0" 
$ns at 894.0210576701625 "$node_(172) setdest 159333 14395 15.0" 
$ns at 102.64283924620975 "$node_(173) setdest 15610 9422 3.0" 
$ns at 141.4366424088111 "$node_(173) setdest 86304 17198 13.0" 
$ns at 241.8272616794205 "$node_(173) setdest 25797 36988 13.0" 
$ns at 335.6832761440997 "$node_(173) setdest 116251 15958 1.0" 
$ns at 370.5123591957448 "$node_(173) setdest 185237 420 18.0" 
$ns at 436.39881254628176 "$node_(173) setdest 188133 35536 4.0" 
$ns at 502.6702000824751 "$node_(173) setdest 4491 66955 14.0" 
$ns at 645.0044016516345 "$node_(173) setdest 213270 14639 2.0" 
$ns at 676.6904572811864 "$node_(173) setdest 60811 25095 13.0" 
$ns at 791.6444574318579 "$node_(173) setdest 234366 74780 17.0" 
$ns at 119.4465838952534 "$node_(174) setdest 88372 15641 17.0" 
$ns at 260.04449131942016 "$node_(174) setdest 78864 15144 6.0" 
$ns at 342.7858291174143 "$node_(174) setdest 30580 15674 14.0" 
$ns at 398.5177843680857 "$node_(174) setdest 169854 51461 16.0" 
$ns at 543.5679702552343 "$node_(174) setdest 110232 28271 11.0" 
$ns at 605.9622670434119 "$node_(174) setdest 178679 57044 13.0" 
$ns at 729.9949924546554 "$node_(174) setdest 151363 20672 9.0" 
$ns at 849.9639424595398 "$node_(174) setdest 171879 81091 17.0" 
$ns at 175.11704735013763 "$node_(175) setdest 124934 11666 13.0" 
$ns at 292.6159172232108 "$node_(175) setdest 132561 47593 1.0" 
$ns at 331.7481224216406 "$node_(175) setdest 79603 10696 6.0" 
$ns at 375.842165908046 "$node_(175) setdest 108313 12565 16.0" 
$ns at 496.39696160210815 "$node_(175) setdest 73452 3168 5.0" 
$ns at 550.9133767684295 "$node_(175) setdest 153913 67812 11.0" 
$ns at 598.5674496127027 "$node_(175) setdest 193080 40041 14.0" 
$ns at 739.292863290593 "$node_(175) setdest 71179 26137 1.0" 
$ns at 772.6252910693328 "$node_(175) setdest 73096 12076 17.0" 
$ns at 889.3689511734724 "$node_(175) setdest 208111 14922 11.0" 
$ns at 134.82592245434017 "$node_(176) setdest 38585 22325 17.0" 
$ns at 242.4225183333104 "$node_(176) setdest 112758 24762 12.0" 
$ns at 316.239106630167 "$node_(176) setdest 93937 14325 6.0" 
$ns at 372.46675166117166 "$node_(176) setdest 115751 10065 7.0" 
$ns at 403.11291627184846 "$node_(176) setdest 73607 4164 5.0" 
$ns at 438.00317104892093 "$node_(176) setdest 146519 14004 8.0" 
$ns at 535.8684320663799 "$node_(176) setdest 20222 21529 8.0" 
$ns at 575.331936662309 "$node_(176) setdest 155494 38748 9.0" 
$ns at 606.2094955189066 "$node_(176) setdest 141730 25358 1.0" 
$ns at 642.3826929724975 "$node_(176) setdest 133083 26004 16.0" 
$ns at 810.7562914943426 "$node_(176) setdest 45780 75794 8.0" 
$ns at 846.016529423935 "$node_(176) setdest 117311 56264 16.0" 
$ns at 125.50472858279592 "$node_(177) setdest 27167 12025 12.0" 
$ns at 271.2300944672986 "$node_(177) setdest 108420 12131 4.0" 
$ns at 308.164222801118 "$node_(177) setdest 3109 15709 15.0" 
$ns at 371.78578543633546 "$node_(177) setdest 151202 44779 17.0" 
$ns at 542.5188429116954 "$node_(177) setdest 107873 65444 1.0" 
$ns at 575.6702306886698 "$node_(177) setdest 111522 18011 13.0" 
$ns at 669.7747074728213 "$node_(177) setdest 28358 61418 20.0" 
$ns at 880.4051814278225 "$node_(177) setdest 58053 77003 7.0" 
$ns at 175.58556212181463 "$node_(178) setdest 120789 6905 5.0" 
$ns at 220.55047364711413 "$node_(178) setdest 82235 2991 14.0" 
$ns at 353.20660902092527 "$node_(178) setdest 162502 4731 17.0" 
$ns at 517.0724010276012 "$node_(178) setdest 204931 24875 9.0" 
$ns at 588.52050315499 "$node_(178) setdest 188121 69870 10.0" 
$ns at 697.3222182494353 "$node_(178) setdest 83236 42264 10.0" 
$ns at 750.9628911957036 "$node_(178) setdest 8881 25026 12.0" 
$ns at 819.4138126532247 "$node_(178) setdest 192125 78896 2.0" 
$ns at 853.1925149084368 "$node_(178) setdest 252196 76351 12.0" 
$ns at 898.2626489109763 "$node_(178) setdest 41546 70263 2.0" 
$ns at 176.93633300153118 "$node_(179) setdest 74377 7132 3.0" 
$ns at 217.1493459992789 "$node_(179) setdest 122433 16556 18.0" 
$ns at 328.82486444030985 "$node_(179) setdest 162797 47748 5.0" 
$ns at 392.3775145541322 "$node_(179) setdest 134439 4586 7.0" 
$ns at 491.36160251203194 "$node_(179) setdest 151206 37602 8.0" 
$ns at 558.5594117595589 "$node_(179) setdest 8748 49067 3.0" 
$ns at 609.2290565341907 "$node_(179) setdest 23659 42987 16.0" 
$ns at 704.1803683990377 "$node_(179) setdest 137202 16540 12.0" 
$ns at 847.8131966454874 "$node_(179) setdest 218507 69178 15.0" 
$ns at 108.6686254325351 "$node_(180) setdest 9993 26406 14.0" 
$ns at 154.52285460134493 "$node_(180) setdest 49503 38125 8.0" 
$ns at 193.10999597582634 "$node_(180) setdest 91595 41651 14.0" 
$ns at 264.5101383472803 "$node_(180) setdest 69380 15366 8.0" 
$ns at 360.40330631683247 "$node_(180) setdest 42556 10172 2.0" 
$ns at 408.43821493696584 "$node_(180) setdest 9272 9076 9.0" 
$ns at 484.6842346633903 "$node_(180) setdest 21810 63842 8.0" 
$ns at 548.7461771752214 "$node_(180) setdest 145775 60853 16.0" 
$ns at 597.9530825492527 "$node_(180) setdest 70017 70021 4.0" 
$ns at 643.5086818322696 "$node_(180) setdest 3049 74315 4.0" 
$ns at 696.7230417542138 "$node_(180) setdest 47368 34991 8.0" 
$ns at 799.6146828673519 "$node_(180) setdest 43663 25449 18.0" 
$ns at 142.5069312456598 "$node_(181) setdest 46155 15839 12.0" 
$ns at 249.34739458490398 "$node_(181) setdest 21038 37053 3.0" 
$ns at 282.6894924796935 "$node_(181) setdest 47976 38007 10.0" 
$ns at 388.47245061980465 "$node_(181) setdest 22206 49124 13.0" 
$ns at 425.69383070348806 "$node_(181) setdest 34288 60409 12.0" 
$ns at 564.2679387034074 "$node_(181) setdest 64374 56777 18.0" 
$ns at 707.8932478787585 "$node_(181) setdest 148874 61631 19.0" 
$ns at 853.4886446265186 "$node_(181) setdest 241970 86373 19.0" 
$ns at 120.73050530511864 "$node_(182) setdest 20217 7085 18.0" 
$ns at 172.3073391560473 "$node_(182) setdest 18487 28922 19.0" 
$ns at 203.21037222816602 "$node_(182) setdest 79141 17118 15.0" 
$ns at 275.5488181105057 "$node_(182) setdest 36823 53821 18.0" 
$ns at 378.8126730852035 "$node_(182) setdest 31600 6662 17.0" 
$ns at 489.547701146026 "$node_(182) setdest 62519 8704 9.0" 
$ns at 571.6210417856444 "$node_(182) setdest 182831 36439 20.0" 
$ns at 623.2065188546695 "$node_(182) setdest 144028 66646 13.0" 
$ns at 692.2749678200837 "$node_(182) setdest 179968 12124 1.0" 
$ns at 724.3171523658384 "$node_(182) setdest 218605 75713 3.0" 
$ns at 761.094539721916 "$node_(182) setdest 107950 73587 18.0" 
$ns at 124.34421415494938 "$node_(183) setdest 20197 31485 12.0" 
$ns at 226.11481941358005 "$node_(183) setdest 121973 33215 13.0" 
$ns at 302.7686730568694 "$node_(183) setdest 1727 14281 8.0" 
$ns at 366.6132601823747 "$node_(183) setdest 112827 35152 9.0" 
$ns at 415.96122885271797 "$node_(183) setdest 138281 38189 19.0" 
$ns at 615.9787950222563 "$node_(183) setdest 137923 23822 15.0" 
$ns at 717.1735166537733 "$node_(183) setdest 124870 37313 11.0" 
$ns at 784.411693766126 "$node_(183) setdest 111947 37542 10.0" 
$ns at 893.8152605098385 "$node_(183) setdest 267525 69872 15.0" 
$ns at 125.62993170609454 "$node_(184) setdest 25500 15378 8.0" 
$ns at 224.98328522099493 "$node_(184) setdest 42008 29539 6.0" 
$ns at 266.2776404849735 "$node_(184) setdest 132980 19996 2.0" 
$ns at 304.03874344636074 "$node_(184) setdest 160744 9615 3.0" 
$ns at 362.0004198754847 "$node_(184) setdest 164267 36286 5.0" 
$ns at 397.6970749849082 "$node_(184) setdest 88161 20000 6.0" 
$ns at 428.7002082735335 "$node_(184) setdest 118343 63119 12.0" 
$ns at 501.9902352775335 "$node_(184) setdest 171929 10082 1.0" 
$ns at 540.2874244059233 "$node_(184) setdest 206139 14815 14.0" 
$ns at 602.3423198783985 "$node_(184) setdest 74183 48457 3.0" 
$ns at 654.8154810909859 "$node_(184) setdest 214962 26649 17.0" 
$ns at 800.9807060813114 "$node_(184) setdest 230375 23293 1.0" 
$ns at 832.760925465055 "$node_(184) setdest 85654 18959 5.0" 
$ns at 280.71604760441744 "$node_(185) setdest 85833 33797 18.0" 
$ns at 405.3960573107159 "$node_(185) setdest 51277 51764 13.0" 
$ns at 448.51144841301164 "$node_(185) setdest 125840 15632 13.0" 
$ns at 484.79779670210024 "$node_(185) setdest 203719 8612 3.0" 
$ns at 525.5579902308979 "$node_(185) setdest 112415 23189 19.0" 
$ns at 703.4635133722177 "$node_(185) setdest 198804 31626 11.0" 
$ns at 786.5267421712998 "$node_(185) setdest 96640 34266 20.0" 
$ns at 136.31405324033742 "$node_(186) setdest 78451 14847 19.0" 
$ns at 296.93829366048266 "$node_(186) setdest 102565 27394 16.0" 
$ns at 379.4572128524304 "$node_(186) setdest 35557 56325 4.0" 
$ns at 430.6202318114003 "$node_(186) setdest 165243 55487 6.0" 
$ns at 495.3179315305652 "$node_(186) setdest 118147 66887 11.0" 
$ns at 540.7735851988818 "$node_(186) setdest 169339 12849 10.0" 
$ns at 645.5772905735265 "$node_(186) setdest 92341 35344 6.0" 
$ns at 683.2550942268697 "$node_(186) setdest 215096 28065 16.0" 
$ns at 774.9952222566301 "$node_(186) setdest 16865 36144 3.0" 
$ns at 822.4024767577216 "$node_(186) setdest 239752 15175 1.0" 
$ns at 861.3039533860855 "$node_(186) setdest 50920 73955 5.0" 
$ns at 153.69716161344994 "$node_(187) setdest 51255 17081 5.0" 
$ns at 204.2864285633543 "$node_(187) setdest 62180 2446 3.0" 
$ns at 246.18819072268496 "$node_(187) setdest 98081 39782 12.0" 
$ns at 296.5760261383142 "$node_(187) setdest 153750 9444 6.0" 
$ns at 345.11496687382225 "$node_(187) setdest 1553 53735 6.0" 
$ns at 378.2704493307498 "$node_(187) setdest 56196 16127 15.0" 
$ns at 506.32447278496534 "$node_(187) setdest 72484 3638 7.0" 
$ns at 572.814864059984 "$node_(187) setdest 96052 45364 7.0" 
$ns at 604.4989288025341 "$node_(187) setdest 29452 76958 4.0" 
$ns at 649.4413401538703 "$node_(187) setdest 39941 58332 9.0" 
$ns at 742.8819721651664 "$node_(187) setdest 37916 29525 10.0" 
$ns at 805.7841065241131 "$node_(187) setdest 259799 9569 11.0" 
$ns at 851.595142917671 "$node_(187) setdest 11204 87630 10.0" 
$ns at 110.79425393762924 "$node_(188) setdest 82527 106 17.0" 
$ns at 149.7149940486653 "$node_(188) setdest 84451 8063 18.0" 
$ns at 248.6968060805208 "$node_(188) setdest 53116 4987 1.0" 
$ns at 288.22277728023226 "$node_(188) setdest 67618 46020 10.0" 
$ns at 328.70842553123936 "$node_(188) setdest 86512 2532 8.0" 
$ns at 370.423921560944 "$node_(188) setdest 99834 10181 3.0" 
$ns at 401.5317305503945 "$node_(188) setdest 154447 29308 18.0" 
$ns at 464.21760442889786 "$node_(188) setdest 121287 17756 2.0" 
$ns at 509.51179454870504 "$node_(188) setdest 192045 68027 13.0" 
$ns at 663.0611894382105 "$node_(188) setdest 233992 74328 16.0" 
$ns at 744.5140982360041 "$node_(188) setdest 221191 52018 1.0" 
$ns at 775.799116681074 "$node_(188) setdest 213100 46643 11.0" 
$ns at 835.8830119995217 "$node_(188) setdest 93457 27572 9.0" 
$ns at 260.9289537836245 "$node_(189) setdest 76898 41874 5.0" 
$ns at 321.77107528683666 "$node_(189) setdest 46316 15081 20.0" 
$ns at 411.57356124646253 "$node_(189) setdest 137440 38228 15.0" 
$ns at 521.5687974896919 "$node_(189) setdest 150997 8346 19.0" 
$ns at 560.8961391378086 "$node_(189) setdest 160385 72753 6.0" 
$ns at 608.3554760321912 "$node_(189) setdest 74671 70828 11.0" 
$ns at 739.9532858219168 "$node_(189) setdest 171150 27736 8.0" 
$ns at 796.0739394096645 "$node_(189) setdest 27879 61044 13.0" 
$ns at 857.2629562955619 "$node_(189) setdest 48716 70499 8.0" 
$ns at 136.55786672023174 "$node_(190) setdest 877 27106 13.0" 
$ns at 219.85990563552505 "$node_(190) setdest 3426 19608 3.0" 
$ns at 260.2972894925932 "$node_(190) setdest 159725 31544 11.0" 
$ns at 366.0773492984989 "$node_(190) setdest 97079 3969 14.0" 
$ns at 500.7103721532182 "$node_(190) setdest 141262 16269 4.0" 
$ns at 547.9063312150682 "$node_(190) setdest 42409 53040 19.0" 
$ns at 665.8661477540904 "$node_(190) setdest 89315 10709 19.0" 
$ns at 768.7700529941624 "$node_(190) setdest 80643 88353 19.0" 
$ns at 139.0645377952203 "$node_(191) setdest 58417 21227 4.0" 
$ns at 197.85674103389823 "$node_(191) setdest 59287 38106 19.0" 
$ns at 359.1851857726251 "$node_(191) setdest 65781 8829 17.0" 
$ns at 483.2502879626548 "$node_(191) setdest 35397 24770 1.0" 
$ns at 519.3985671062512 "$node_(191) setdest 3705 68903 14.0" 
$ns at 588.2369799762233 "$node_(191) setdest 202180 25388 14.0" 
$ns at 726.4819086875933 "$node_(191) setdest 123334 65674 8.0" 
$ns at 773.088004897994 "$node_(191) setdest 260103 57215 16.0" 
$ns at 864.7391203735801 "$node_(191) setdest 153718 25915 18.0" 
$ns at 146.85869803817474 "$node_(192) setdest 58116 21383 10.0" 
$ns at 254.64878097791578 "$node_(192) setdest 12060 32601 1.0" 
$ns at 287.53526504705843 "$node_(192) setdest 113729 46617 11.0" 
$ns at 365.90945144272075 "$node_(192) setdest 107412 23974 6.0" 
$ns at 449.5108904355411 "$node_(192) setdest 16674 42103 4.0" 
$ns at 514.6969173500867 "$node_(192) setdest 189331 45105 3.0" 
$ns at 572.2598280436795 "$node_(192) setdest 73402 26539 6.0" 
$ns at 631.2469340471572 "$node_(192) setdest 153281 57607 12.0" 
$ns at 732.3283231725125 "$node_(192) setdest 137587 27805 10.0" 
$ns at 803.100769321933 "$node_(192) setdest 15560 24827 8.0" 
$ns at 843.0739786184057 "$node_(192) setdest 27315 47121 17.0" 
$ns at 112.80199572252367 "$node_(193) setdest 80458 27782 5.0" 
$ns at 192.41307909647935 "$node_(193) setdest 12549 28249 19.0" 
$ns at 318.64571495118673 "$node_(193) setdest 97424 41429 5.0" 
$ns at 362.954594975237 "$node_(193) setdest 40888 40631 11.0" 
$ns at 424.3031516979995 "$node_(193) setdest 138231 39272 6.0" 
$ns at 511.1432220870678 "$node_(193) setdest 27593 36812 18.0" 
$ns at 643.1597488734699 "$node_(193) setdest 164646 65903 2.0" 
$ns at 689.661011724481 "$node_(193) setdest 202894 59803 5.0" 
$ns at 755.6067636357078 "$node_(193) setdest 39030 71744 7.0" 
$ns at 787.7612207574783 "$node_(193) setdest 211044 63859 10.0" 
$ns at 878.5135463657032 "$node_(193) setdest 156470 38772 17.0" 
$ns at 107.64133241737076 "$node_(194) setdest 30360 15106 4.0" 
$ns at 167.27139587665425 "$node_(194) setdest 40197 8702 8.0" 
$ns at 248.50088819232118 "$node_(194) setdest 45471 20913 3.0" 
$ns at 305.3924331045997 "$node_(194) setdest 77936 9912 9.0" 
$ns at 362.9034679399543 "$node_(194) setdest 103574 58301 9.0" 
$ns at 438.98574568044603 "$node_(194) setdest 3250 36658 3.0" 
$ns at 478.3200891608353 "$node_(194) setdest 180943 61251 11.0" 
$ns at 577.2097725024182 "$node_(194) setdest 83330 20080 11.0" 
$ns at 706.318139958106 "$node_(194) setdest 6731 54296 2.0" 
$ns at 749.0682869346779 "$node_(194) setdest 249364 33792 12.0" 
$ns at 892.6224731159914 "$node_(194) setdest 176680 59091 14.0" 
$ns at 126.07578215497593 "$node_(195) setdest 53840 14833 16.0" 
$ns at 277.56154669262133 "$node_(195) setdest 99500 42536 17.0" 
$ns at 335.9174050402863 "$node_(195) setdest 125721 45104 10.0" 
$ns at 454.26103670064265 "$node_(195) setdest 136412 45775 2.0" 
$ns at 503.21924728035714 "$node_(195) setdest 174737 61578 10.0" 
$ns at 591.7464534517447 "$node_(195) setdest 56639 7907 9.0" 
$ns at 667.1565817672279 "$node_(195) setdest 91102 82649 1.0" 
$ns at 702.234312372323 "$node_(195) setdest 12502 3074 9.0" 
$ns at 742.6691411586287 "$node_(195) setdest 231434 24728 12.0" 
$ns at 783.0929620561852 "$node_(195) setdest 33135 52241 9.0" 
$ns at 815.2945455765918 "$node_(195) setdest 43555 24315 9.0" 
$ns at 104.81059542496094 "$node_(196) setdest 90017 14626 10.0" 
$ns at 149.93877463309605 "$node_(196) setdest 10459 5894 15.0" 
$ns at 324.78453441709047 "$node_(196) setdest 121146 54649 16.0" 
$ns at 391.8369759365895 "$node_(196) setdest 67479 23094 14.0" 
$ns at 544.1267818845727 "$node_(196) setdest 199627 61601 5.0" 
$ns at 612.0418470093917 "$node_(196) setdest 58011 39809 8.0" 
$ns at 707.5025178270831 "$node_(196) setdest 51624 15763 17.0" 
$ns at 818.9735270955184 "$node_(196) setdest 16900 32854 13.0" 
$ns at 151.941801954683 "$node_(197) setdest 40957 14372 9.0" 
$ns at 232.79021564511996 "$node_(197) setdest 43766 40007 7.0" 
$ns at 278.09994163977206 "$node_(197) setdest 2376 33398 15.0" 
$ns at 354.6216902783681 "$node_(197) setdest 68320 3978 9.0" 
$ns at 458.0163313416373 "$node_(197) setdest 156830 27134 18.0" 
$ns at 612.9807520264919 "$node_(197) setdest 79308 72275 11.0" 
$ns at 665.1838285269745 "$node_(197) setdest 107766 80629 18.0" 
$ns at 819.5499353962925 "$node_(197) setdest 138123 18260 9.0" 
$ns at 887.1058649295915 "$node_(197) setdest 78242 65086 2.0" 
$ns at 203.97157847017692 "$node_(198) setdest 128880 19151 3.0" 
$ns at 251.09449241301417 "$node_(198) setdest 34718 12432 7.0" 
$ns at 300.67352119024497 "$node_(198) setdest 24284 8694 4.0" 
$ns at 342.92771012837306 "$node_(198) setdest 96245 4520 3.0" 
$ns at 402.33329437676406 "$node_(198) setdest 28378 38180 15.0" 
$ns at 495.42307737952626 "$node_(198) setdest 77862 16555 5.0" 
$ns at 537.6220495303996 "$node_(198) setdest 183647 37551 17.0" 
$ns at 665.1898213666218 "$node_(198) setdest 142791 58802 6.0" 
$ns at 703.3250693687316 "$node_(198) setdest 6925 66418 16.0" 
$ns at 819.7553869976001 "$node_(198) setdest 179981 74978 5.0" 
$ns at 867.1237896741413 "$node_(198) setdest 216663 27434 19.0" 
$ns at 125.91474284014137 "$node_(199) setdest 64154 27862 2.0" 
$ns at 165.98644845655153 "$node_(199) setdest 36332 41325 2.0" 
$ns at 198.60106266516567 "$node_(199) setdest 75189 11185 12.0" 
$ns at 289.47978012250564 "$node_(199) setdest 134430 40863 17.0" 
$ns at 368.88872419042866 "$node_(199) setdest 113599 54804 15.0" 
$ns at 540.7433401146211 "$node_(199) setdest 3162 37553 1.0" 
$ns at 575.9194417442263 "$node_(199) setdest 11535 23559 9.0" 
$ns at 688.3619128974914 "$node_(199) setdest 122012 10390 6.0" 
$ns at 760.8036829881994 "$node_(199) setdest 40350 30959 4.0" 
$ns at 815.2353884798907 "$node_(199) setdest 183110 1269 20.0" 
$ns at 895.3184265029697 "$node_(199) setdest 262436 8183 19.0" 
$ns at 263.42250138211165 "$node_(200) setdest 65225 22566 9.0" 
$ns at 333.0125603883416 "$node_(200) setdest 21651 15267 2.0" 
$ns at 376.9359494674785 "$node_(200) setdest 131954 16199 6.0" 
$ns at 434.9012664921826 "$node_(200) setdest 56195 10265 13.0" 
$ns at 509.452061636508 "$node_(200) setdest 46137 7683 6.0" 
$ns at 583.1237956408224 "$node_(200) setdest 34559 33199 1.0" 
$ns at 622.1741659255208 "$node_(200) setdest 24431 35225 9.0" 
$ns at 730.6267881869641 "$node_(200) setdest 802 24191 14.0" 
$ns at 861.0330816376425 "$node_(200) setdest 56234 35156 6.0" 
$ns at 309.0118673262357 "$node_(201) setdest 57926 3680 13.0" 
$ns at 350.9088495114053 "$node_(201) setdest 22740 28839 4.0" 
$ns at 420.0622100290976 "$node_(201) setdest 65885 36320 20.0" 
$ns at 623.8427405998639 "$node_(201) setdest 5594 22158 16.0" 
$ns at 755.334362163851 "$node_(201) setdest 31905 18939 20.0" 
$ns at 816.7282800818931 "$node_(201) setdest 80513 42713 9.0" 
$ns at 208.64250185558762 "$node_(202) setdest 24036 11918 17.0" 
$ns at 394.86222045565233 "$node_(202) setdest 52854 32188 4.0" 
$ns at 433.64343652829666 "$node_(202) setdest 110040 8165 14.0" 
$ns at 508.1932459709348 "$node_(202) setdest 122410 30629 16.0" 
$ns at 629.1308611689001 "$node_(202) setdest 94248 41472 8.0" 
$ns at 705.5930820795359 "$node_(202) setdest 22749 5211 18.0" 
$ns at 856.1317028643647 "$node_(202) setdest 86678 37493 14.0" 
$ns at 240.91329170500808 "$node_(203) setdest 77127 9929 8.0" 
$ns at 293.6392984814704 "$node_(203) setdest 54600 43097 5.0" 
$ns at 363.9219872625075 "$node_(203) setdest 20141 19448 10.0" 
$ns at 396.4640355665018 "$node_(203) setdest 13747 21904 6.0" 
$ns at 435.77039262166267 "$node_(203) setdest 21100 36153 13.0" 
$ns at 580.5560830464192 "$node_(203) setdest 47023 16583 19.0" 
$ns at 637.9196954428834 "$node_(203) setdest 63051 24804 6.0" 
$ns at 726.4462441921605 "$node_(203) setdest 86840 36069 5.0" 
$ns at 760.146741243185 "$node_(203) setdest 112997 9361 10.0" 
$ns at 864.9053417446277 "$node_(203) setdest 70511 13241 11.0" 
$ns at 212.95178398767717 "$node_(204) setdest 31595 25134 10.0" 
$ns at 306.0323376213281 "$node_(204) setdest 77202 270 19.0" 
$ns at 499.86078068146975 "$node_(204) setdest 97222 1116 19.0" 
$ns at 670.5771744045182 "$node_(204) setdest 108697 43744 2.0" 
$ns at 709.9996721960836 "$node_(204) setdest 76949 26517 12.0" 
$ns at 846.3821361275554 "$node_(204) setdest 43269 44121 18.0" 
$ns at 273.53286368391315 "$node_(205) setdest 442 20264 13.0" 
$ns at 398.7104854971377 "$node_(205) setdest 2717 38415 6.0" 
$ns at 472.19451363262306 "$node_(205) setdest 112350 35595 14.0" 
$ns at 515.3347170554694 "$node_(205) setdest 47393 25457 1.0" 
$ns at 546.9148144801879 "$node_(205) setdest 109352 36643 6.0" 
$ns at 632.7934554493803 "$node_(205) setdest 9485 35799 5.0" 
$ns at 696.8357704632515 "$node_(205) setdest 108880 22041 6.0" 
$ns at 756.8314660286036 "$node_(205) setdest 35136 3945 18.0" 
$ns at 212.1686088492088 "$node_(206) setdest 67824 42943 3.0" 
$ns at 262.3571970901866 "$node_(206) setdest 36814 41275 2.0" 
$ns at 310.20140035246914 "$node_(206) setdest 32789 24132 16.0" 
$ns at 433.5679827951582 "$node_(206) setdest 115942 22257 8.0" 
$ns at 519.1378095546208 "$node_(206) setdest 129108 1402 3.0" 
$ns at 558.8475783112623 "$node_(206) setdest 88532 22998 14.0" 
$ns at 590.7597449715555 "$node_(206) setdest 75081 44268 14.0" 
$ns at 717.5164642886812 "$node_(206) setdest 37294 16490 5.0" 
$ns at 789.8873863251998 "$node_(206) setdest 104874 2195 15.0" 
$ns at 307.03598339738585 "$node_(207) setdest 99714 1867 17.0" 
$ns at 464.9076100814797 "$node_(207) setdest 64881 10943 19.0" 
$ns at 649.079895097916 "$node_(207) setdest 34954 4542 15.0" 
$ns at 803.3974852903362 "$node_(207) setdest 79601 36186 16.0" 
$ns at 250.35731828805265 "$node_(208) setdest 55536 24574 8.0" 
$ns at 325.55867092091034 "$node_(208) setdest 99697 21816 1.0" 
$ns at 359.1765278975778 "$node_(208) setdest 31492 6894 13.0" 
$ns at 518.4395366613476 "$node_(208) setdest 95356 3583 4.0" 
$ns at 565.1422660385526 "$node_(208) setdest 30212 23015 1.0" 
$ns at 603.2544873669989 "$node_(208) setdest 128785 27711 6.0" 
$ns at 693.0895657471684 "$node_(208) setdest 80894 24710 1.0" 
$ns at 724.9111922492547 "$node_(208) setdest 74017 3595 5.0" 
$ns at 789.6499230045367 "$node_(208) setdest 132845 9447 2.0" 
$ns at 828.3287031655813 "$node_(208) setdest 637 36900 13.0" 
$ns at 238.71984162311477 "$node_(209) setdest 87201 42060 9.0" 
$ns at 347.32546692385154 "$node_(209) setdest 103517 18704 16.0" 
$ns at 394.2206386798121 "$node_(209) setdest 73026 11824 15.0" 
$ns at 550.1690075721192 "$node_(209) setdest 101529 3129 1.0" 
$ns at 588.700418448354 "$node_(209) setdest 42873 32744 5.0" 
$ns at 640.8868067732524 "$node_(209) setdest 52003 31231 17.0" 
$ns at 810.0503468693752 "$node_(209) setdest 7086 22891 4.0" 
$ns at 842.8777564049153 "$node_(209) setdest 111332 35571 13.0" 
$ns at 240.02987558877481 "$node_(210) setdest 36639 26207 5.0" 
$ns at 282.45537716486615 "$node_(210) setdest 45377 8362 2.0" 
$ns at 321.33767192285626 "$node_(210) setdest 64288 19382 20.0" 
$ns at 508.08815785866614 "$node_(210) setdest 72009 15667 18.0" 
$ns at 649.5665485285888 "$node_(210) setdest 16441 16354 18.0" 
$ns at 714.5574603026821 "$node_(210) setdest 77681 23876 10.0" 
$ns at 843.4911295210928 "$node_(210) setdest 99515 17192 17.0" 
$ns at 228.1522483963886 "$node_(211) setdest 122400 4779 11.0" 
$ns at 355.5467693152535 "$node_(211) setdest 75736 16779 2.0" 
$ns at 400.57171374861264 "$node_(211) setdest 19509 388 10.0" 
$ns at 452.7698439710708 "$node_(211) setdest 131076 24080 4.0" 
$ns at 503.2614704359489 "$node_(211) setdest 106882 27281 10.0" 
$ns at 600.3809862732758 "$node_(211) setdest 98799 32264 18.0" 
$ns at 711.397889331408 "$node_(211) setdest 79852 20915 2.0" 
$ns at 760.3608748623705 "$node_(211) setdest 97219 30430 1.0" 
$ns at 798.9205264327771 "$node_(211) setdest 49528 232 13.0" 
$ns at 890.6650794402851 "$node_(211) setdest 30542 11950 13.0" 
$ns at 212.3534755239641 "$node_(212) setdest 76820 26735 1.0" 
$ns at 244.241340628272 "$node_(212) setdest 20063 19534 15.0" 
$ns at 361.402743333997 "$node_(212) setdest 109201 43667 10.0" 
$ns at 418.84342334909303 "$node_(212) setdest 18135 22976 18.0" 
$ns at 602.3729305185452 "$node_(212) setdest 6928 41326 13.0" 
$ns at 665.7005628346625 "$node_(212) setdest 14612 31861 9.0" 
$ns at 778.560361261698 "$node_(212) setdest 75434 32707 19.0" 
$ns at 893.6924763135089 "$node_(212) setdest 96920 4756 1.0" 
$ns at 233.05644141156856 "$node_(213) setdest 59353 8961 16.0" 
$ns at 364.07503501584904 "$node_(213) setdest 92614 86 5.0" 
$ns at 394.3230498277976 "$node_(213) setdest 125193 28933 5.0" 
$ns at 463.9352846544257 "$node_(213) setdest 126933 19614 5.0" 
$ns at 505.0556110831674 "$node_(213) setdest 99983 13555 16.0" 
$ns at 675.7138687966316 "$node_(213) setdest 65756 7676 12.0" 
$ns at 706.5540279281573 "$node_(213) setdest 27139 36676 10.0" 
$ns at 774.2374735690989 "$node_(213) setdest 49939 5074 2.0" 
$ns at 809.4336132809949 "$node_(213) setdest 52673 37940 14.0" 
$ns at 841.058067911928 "$node_(213) setdest 3414 12994 12.0" 
$ns at 206.4036521609488 "$node_(214) setdest 70450 23606 13.0" 
$ns at 358.62643424344526 "$node_(214) setdest 111394 16919 10.0" 
$ns at 397.29210364420703 "$node_(214) setdest 120669 9710 7.0" 
$ns at 458.83082408159254 "$node_(214) setdest 64489 15737 7.0" 
$ns at 492.5527182800444 "$node_(214) setdest 117262 35692 13.0" 
$ns at 524.6131121918512 "$node_(214) setdest 91113 36798 6.0" 
$ns at 571.8192703474921 "$node_(214) setdest 87546 44080 4.0" 
$ns at 626.6058181683769 "$node_(214) setdest 124929 40263 18.0" 
$ns at 669.1605862187861 "$node_(214) setdest 82880 2826 11.0" 
$ns at 709.8685711915178 "$node_(214) setdest 116724 39025 20.0" 
$ns at 810.0934481283083 "$node_(214) setdest 25047 17797 9.0" 
$ns at 870.7475088201056 "$node_(214) setdest 72692 24491 12.0" 
$ns at 219.44981504469365 "$node_(215) setdest 119183 33961 10.0" 
$ns at 257.179998184309 "$node_(215) setdest 90368 6465 15.0" 
$ns at 294.4280983805331 "$node_(215) setdest 30830 5204 11.0" 
$ns at 382.8706904119459 "$node_(215) setdest 98652 29918 3.0" 
$ns at 441.933058621354 "$node_(215) setdest 99005 37680 11.0" 
$ns at 546.717563481061 "$node_(215) setdest 110248 36166 14.0" 
$ns at 707.9126629027476 "$node_(215) setdest 94163 8161 11.0" 
$ns at 744.8246485288998 "$node_(215) setdest 78152 21783 12.0" 
$ns at 866.5353420330321 "$node_(215) setdest 114341 14339 4.0" 
$ns at 247.91804758746053 "$node_(216) setdest 74508 41070 6.0" 
$ns at 292.5212933100951 "$node_(216) setdest 97633 12669 7.0" 
$ns at 367.53330587880697 "$node_(216) setdest 35673 37615 10.0" 
$ns at 447.0506778865648 "$node_(216) setdest 97926 11822 14.0" 
$ns at 568.6727175684462 "$node_(216) setdest 7142 42284 5.0" 
$ns at 627.6318822540685 "$node_(216) setdest 123963 41890 18.0" 
$ns at 718.9983120085185 "$node_(216) setdest 124724 25737 12.0" 
$ns at 770.5263456062017 "$node_(216) setdest 83085 6784 7.0" 
$ns at 842.0379795972076 "$node_(216) setdest 75460 34839 8.0" 
$ns at 274.0638650615122 "$node_(217) setdest 119835 18311 16.0" 
$ns at 367.6034124225326 "$node_(217) setdest 129510 2189 7.0" 
$ns at 429.0191789224312 "$node_(217) setdest 81085 42245 2.0" 
$ns at 475.8970553797971 "$node_(217) setdest 111733 13154 6.0" 
$ns at 553.5847310816854 "$node_(217) setdest 118102 27768 13.0" 
$ns at 658.4856294292006 "$node_(217) setdest 129908 2381 2.0" 
$ns at 692.2531981834296 "$node_(217) setdest 43614 32797 14.0" 
$ns at 738.0702685487217 "$node_(217) setdest 42907 18971 3.0" 
$ns at 768.1445215488274 "$node_(217) setdest 108948 32213 17.0" 
$ns at 207.05620983556202 "$node_(218) setdest 12286 2290 19.0" 
$ns at 333.7268724005172 "$node_(218) setdest 106322 9322 14.0" 
$ns at 393.389397717168 "$node_(218) setdest 51577 38538 1.0" 
$ns at 433.08873141192504 "$node_(218) setdest 109945 22417 6.0" 
$ns at 520.169102591634 "$node_(218) setdest 11051 299 2.0" 
$ns at 565.3249865981891 "$node_(218) setdest 32489 31767 4.0" 
$ns at 627.4892100957929 "$node_(218) setdest 67197 11565 5.0" 
$ns at 666.218667154729 "$node_(218) setdest 58495 33126 20.0" 
$ns at 823.8925461980068 "$node_(218) setdest 96281 34424 19.0" 
$ns at 217.10001876123698 "$node_(219) setdest 18219 30061 16.0" 
$ns at 295.2033317718574 "$node_(219) setdest 30978 41948 5.0" 
$ns at 353.9763572478997 "$node_(219) setdest 84409 27032 15.0" 
$ns at 446.3812179643829 "$node_(219) setdest 26991 16810 19.0" 
$ns at 528.514960829958 "$node_(219) setdest 93349 38995 13.0" 
$ns at 624.6717396670565 "$node_(219) setdest 121693 21777 18.0" 
$ns at 712.0679894181241 "$node_(219) setdest 39646 8850 10.0" 
$ns at 800.1781972986478 "$node_(219) setdest 49885 21507 6.0" 
$ns at 859.6639467781312 "$node_(219) setdest 39839 12153 6.0" 
$ns at 258.44423358278925 "$node_(220) setdest 9187 41656 10.0" 
$ns at 312.0510764716454 "$node_(220) setdest 41705 5695 9.0" 
$ns at 428.0343242913051 "$node_(220) setdest 12863 21573 20.0" 
$ns at 541.8688063094364 "$node_(220) setdest 19505 31053 10.0" 
$ns at 581.3394159429329 "$node_(220) setdest 130844 15624 8.0" 
$ns at 646.9525995058751 "$node_(220) setdest 15237 31190 1.0" 
$ns at 680.1114852022421 "$node_(220) setdest 27903 13270 6.0" 
$ns at 713.161052835029 "$node_(220) setdest 45176 13402 4.0" 
$ns at 751.2110274169185 "$node_(220) setdest 89978 5403 10.0" 
$ns at 866.9744424600872 "$node_(220) setdest 117102 37899 2.0" 
$ns at 328.90221059521394 "$node_(221) setdest 41264 19094 3.0" 
$ns at 379.70428347621703 "$node_(221) setdest 52994 16113 15.0" 
$ns at 411.11157879333547 "$node_(221) setdest 8262 4497 4.0" 
$ns at 444.36171919934367 "$node_(221) setdest 1621 6988 13.0" 
$ns at 547.5924988554544 "$node_(221) setdest 40589 131 15.0" 
$ns at 675.3251285375084 "$node_(221) setdest 65196 39322 1.0" 
$ns at 705.678191751092 "$node_(221) setdest 97544 2108 18.0" 
$ns at 896.9235684678727 "$node_(221) setdest 111537 23626 13.0" 
$ns at 308.2139908737873 "$node_(222) setdest 65925 1518 5.0" 
$ns at 355.9493537031768 "$node_(222) setdest 126241 22909 6.0" 
$ns at 415.51404030729617 "$node_(222) setdest 12719 30414 13.0" 
$ns at 463.65998127618457 "$node_(222) setdest 68600 23634 4.0" 
$ns at 494.18993444434653 "$node_(222) setdest 55844 14646 9.0" 
$ns at 597.6708305426299 "$node_(222) setdest 59192 6295 16.0" 
$ns at 724.8348953884611 "$node_(222) setdest 52032 29946 15.0" 
$ns at 831.021874211805 "$node_(222) setdest 4309 9861 7.0" 
$ns at 229.79203976139402 "$node_(223) setdest 126670 12428 4.0" 
$ns at 288.9888959962851 "$node_(223) setdest 97816 36595 18.0" 
$ns at 381.4228006513022 "$node_(223) setdest 27314 10401 19.0" 
$ns at 480.42009852883535 "$node_(223) setdest 86295 16422 7.0" 
$ns at 540.3906201743146 "$node_(223) setdest 9242 5387 9.0" 
$ns at 601.8987885500073 "$node_(223) setdest 48057 9366 1.0" 
$ns at 641.7852045993807 "$node_(223) setdest 131846 33397 6.0" 
$ns at 729.9408893282871 "$node_(223) setdest 82075 27168 1.0" 
$ns at 765.948146832607 "$node_(223) setdest 37640 7036 19.0" 
$ns at 828.4992102590643 "$node_(223) setdest 91959 7214 19.0" 
$ns at 234.9758036709594 "$node_(224) setdest 13273 29281 16.0" 
$ns at 270.3582793452785 "$node_(224) setdest 119732 4803 11.0" 
$ns at 345.57790978523633 "$node_(224) setdest 104016 11906 9.0" 
$ns at 412.50130689443125 "$node_(224) setdest 106778 14652 10.0" 
$ns at 523.9492330041314 "$node_(224) setdest 64225 5283 9.0" 
$ns at 577.0072324628927 "$node_(224) setdest 124302 17731 14.0" 
$ns at 709.5532905942647 "$node_(224) setdest 62260 14927 1.0" 
$ns at 743.6247104702588 "$node_(224) setdest 59725 6368 5.0" 
$ns at 794.3888258487825 "$node_(224) setdest 132651 26950 1.0" 
$ns at 828.0565421667911 "$node_(224) setdest 129171 30022 11.0" 
$ns at 328.7815562433773 "$node_(225) setdest 95981 34419 18.0" 
$ns at 480.8737725714105 "$node_(225) setdest 96403 16922 8.0" 
$ns at 534.6791920574288 "$node_(225) setdest 114887 2538 18.0" 
$ns at 629.8204574007367 "$node_(225) setdest 37413 36687 16.0" 
$ns at 675.0759145652846 "$node_(225) setdest 48928 1664 5.0" 
$ns at 732.9069483227408 "$node_(225) setdest 72673 35024 5.0" 
$ns at 809.4228536835521 "$node_(225) setdest 61737 29941 1.0" 
$ns at 842.5054227225442 "$node_(225) setdest 19470 32579 7.0" 
$ns at 241.09363459361356 "$node_(226) setdest 67556 39348 14.0" 
$ns at 354.1572596151516 "$node_(226) setdest 82627 749 2.0" 
$ns at 396.46243294478484 "$node_(226) setdest 79085 39486 11.0" 
$ns at 486.4105924504357 "$node_(226) setdest 51757 20175 12.0" 
$ns at 600.223267342997 "$node_(226) setdest 38440 10611 4.0" 
$ns at 663.2535168629609 "$node_(226) setdest 89725 14596 16.0" 
$ns at 742.8161259607263 "$node_(226) setdest 1082 1026 4.0" 
$ns at 791.759791540279 "$node_(226) setdest 73106 27447 15.0" 
$ns at 823.5022446616359 "$node_(226) setdest 101724 25617 8.0" 
$ns at 240.3056394851829 "$node_(227) setdest 97697 29916 15.0" 
$ns at 397.5115412711349 "$node_(227) setdest 977 15301 9.0" 
$ns at 487.77793706757154 "$node_(227) setdest 108685 12934 8.0" 
$ns at 596.2131808686743 "$node_(227) setdest 48054 32138 18.0" 
$ns at 626.3342042354061 "$node_(227) setdest 58970 11252 2.0" 
$ns at 668.6979935175451 "$node_(227) setdest 70514 43671 4.0" 
$ns at 714.1969276459628 "$node_(227) setdest 117753 1199 10.0" 
$ns at 843.5275866360462 "$node_(227) setdest 28289 22959 2.0" 
$ns at 878.9409954662776 "$node_(227) setdest 88324 31412 17.0" 
$ns at 215.74581943594256 "$node_(228) setdest 8333 41259 10.0" 
$ns at 275.92385198303043 "$node_(228) setdest 3472 40646 19.0" 
$ns at 471.48612828333137 "$node_(228) setdest 108624 43297 19.0" 
$ns at 586.856017944179 "$node_(228) setdest 20339 9424 15.0" 
$ns at 760.909431629057 "$node_(228) setdest 93412 24149 14.0" 
$ns at 862.9432871334628 "$node_(228) setdest 57208 25591 3.0" 
$ns at 202.30587595205816 "$node_(229) setdest 62050 17878 1.0" 
$ns at 241.3740603439776 "$node_(229) setdest 71254 19975 4.0" 
$ns at 304.00831556068 "$node_(229) setdest 59591 33182 17.0" 
$ns at 429.29014359235543 "$node_(229) setdest 59654 35194 15.0" 
$ns at 539.4466290197975 "$node_(229) setdest 43626 32344 18.0" 
$ns at 588.2686253639893 "$node_(229) setdest 122012 10091 5.0" 
$ns at 657.6122653784706 "$node_(229) setdest 77510 44113 15.0" 
$ns at 800.479843143936 "$node_(229) setdest 17075 22351 10.0" 
$ns at 334.52377686883466 "$node_(230) setdest 29287 44615 14.0" 
$ns at 374.90285857176275 "$node_(230) setdest 113222 8072 13.0" 
$ns at 530.212741181791 "$node_(230) setdest 83327 24518 10.0" 
$ns at 575.3540997511245 "$node_(230) setdest 111549 12661 16.0" 
$ns at 737.7730135217739 "$node_(230) setdest 124303 11636 16.0" 
$ns at 848.3806004951514 "$node_(230) setdest 21463 15562 3.0" 
$ns at 232.22878744191763 "$node_(231) setdest 8149 19893 20.0" 
$ns at 307.08804944429096 "$node_(231) setdest 109946 1326 6.0" 
$ns at 342.48254089801503 "$node_(231) setdest 51878 19012 3.0" 
$ns at 372.5939891815772 "$node_(231) setdest 104443 9891 3.0" 
$ns at 415.936578012898 "$node_(231) setdest 66021 8289 7.0" 
$ns at 515.9360550724336 "$node_(231) setdest 49596 40188 6.0" 
$ns at 572.0668085743094 "$node_(231) setdest 29046 38708 1.0" 
$ns at 607.1113925077753 "$node_(231) setdest 126931 20698 7.0" 
$ns at 647.4501770009605 "$node_(231) setdest 35366 31889 9.0" 
$ns at 683.5952581167892 "$node_(231) setdest 73089 6622 18.0" 
$ns at 739.2023928935985 "$node_(231) setdest 83091 43009 11.0" 
$ns at 853.4787085264777 "$node_(231) setdest 83941 10816 1.0" 
$ns at 883.8299832984247 "$node_(231) setdest 129878 14271 12.0" 
$ns at 225.97692938897384 "$node_(232) setdest 2323 28935 13.0" 
$ns at 259.96952875336984 "$node_(232) setdest 22556 21229 10.0" 
$ns at 303.44590344661714 "$node_(232) setdest 9200 30991 7.0" 
$ns at 361.7533281752644 "$node_(232) setdest 80407 10767 14.0" 
$ns at 483.0621180889499 "$node_(232) setdest 127174 1937 9.0" 
$ns at 514.7710859593876 "$node_(232) setdest 78709 31221 6.0" 
$ns at 546.4206436242996 "$node_(232) setdest 77009 27449 13.0" 
$ns at 627.2615136809924 "$node_(232) setdest 71002 29932 7.0" 
$ns at 670.3006728280558 "$node_(232) setdest 49786 26123 16.0" 
$ns at 832.0411984083318 "$node_(232) setdest 7369 43200 1.0" 
$ns at 864.3509560710311 "$node_(232) setdest 12829 19662 14.0" 
$ns at 290.59953392712544 "$node_(233) setdest 114956 31706 4.0" 
$ns at 338.76744879876105 "$node_(233) setdest 6905 25179 4.0" 
$ns at 391.5899056156055 "$node_(233) setdest 97467 42094 16.0" 
$ns at 563.4691045712327 "$node_(233) setdest 70056 28662 20.0" 
$ns at 669.1580970817556 "$node_(233) setdest 51260 38849 1.0" 
$ns at 702.3308535094502 "$node_(233) setdest 93573 33823 7.0" 
$ns at 738.7972536641234 "$node_(233) setdest 111275 11508 10.0" 
$ns at 796.9168858424447 "$node_(233) setdest 90891 41233 10.0" 
$ns at 861.9133192192912 "$node_(233) setdest 52371 15821 8.0" 
$ns at 282.44450313582547 "$node_(234) setdest 127825 12467 2.0" 
$ns at 329.3624645347777 "$node_(234) setdest 110998 19463 3.0" 
$ns at 374.2445148602737 "$node_(234) setdest 72993 28306 1.0" 
$ns at 411.51643658425127 "$node_(234) setdest 14119 42361 10.0" 
$ns at 458.16018943482044 "$node_(234) setdest 61245 14942 2.0" 
$ns at 506.366499982474 "$node_(234) setdest 31049 23042 5.0" 
$ns at 541.1909630887474 "$node_(234) setdest 75133 34530 4.0" 
$ns at 605.5657256898753 "$node_(234) setdest 89515 31106 17.0" 
$ns at 745.5042534991762 "$node_(234) setdest 68257 3934 8.0" 
$ns at 793.9659273629121 "$node_(234) setdest 82913 1203 13.0" 
$ns at 857.8501095318068 "$node_(234) setdest 89923 25206 13.0" 
$ns at 240.63592719387748 "$node_(235) setdest 119320 19494 1.0" 
$ns at 274.6653713278156 "$node_(235) setdest 108990 14762 13.0" 
$ns at 326.4889252214226 "$node_(235) setdest 3099 29383 15.0" 
$ns at 456.4024787254753 "$node_(235) setdest 73548 36018 2.0" 
$ns at 497.6165176357986 "$node_(235) setdest 105766 27404 10.0" 
$ns at 606.1475716977444 "$node_(235) setdest 12135 29548 9.0" 
$ns at 725.158971377762 "$node_(235) setdest 82495 31846 6.0" 
$ns at 788.703745164599 "$node_(235) setdest 90979 23089 1.0" 
$ns at 818.9012584738931 "$node_(235) setdest 74247 39919 15.0" 
$ns at 327.6736348855849 "$node_(236) setdest 25455 15463 15.0" 
$ns at 429.85008605749124 "$node_(236) setdest 25838 10412 5.0" 
$ns at 464.1039705690056 "$node_(236) setdest 121300 2122 13.0" 
$ns at 560.6299795720925 "$node_(236) setdest 41177 11779 14.0" 
$ns at 712.9632328476636 "$node_(236) setdest 127366 15721 14.0" 
$ns at 751.6449558479333 "$node_(236) setdest 27991 24006 1.0" 
$ns at 787.4629845927457 "$node_(236) setdest 123595 31992 7.0" 
$ns at 836.770657407177 "$node_(236) setdest 89991 37827 3.0" 
$ns at 895.516583074993 "$node_(236) setdest 14523 15283 7.0" 
$ns at 200.736978860011 "$node_(237) setdest 29995 5111 11.0" 
$ns at 320.1709359958029 "$node_(237) setdest 88601 32692 7.0" 
$ns at 381.0890617007407 "$node_(237) setdest 12690 42773 8.0" 
$ns at 445.5449835808338 "$node_(237) setdest 108598 20073 9.0" 
$ns at 561.5296919668749 "$node_(237) setdest 109815 1113 5.0" 
$ns at 622.8316761716222 "$node_(237) setdest 124209 24734 10.0" 
$ns at 671.6917858794793 "$node_(237) setdest 127435 26788 9.0" 
$ns at 721.5562980610858 "$node_(237) setdest 88477 26918 1.0" 
$ns at 752.0699879216314 "$node_(237) setdest 69856 35694 10.0" 
$ns at 809.0647452010905 "$node_(237) setdest 41892 8819 13.0" 
$ns at 289.85318348566045 "$node_(238) setdest 4115 34997 13.0" 
$ns at 443.8866839433968 "$node_(238) setdest 122034 40827 9.0" 
$ns at 479.8611853087334 "$node_(238) setdest 129134 13558 2.0" 
$ns at 521.2612604156716 "$node_(238) setdest 97219 25076 18.0" 
$ns at 570.2394605372255 "$node_(238) setdest 30116 9991 5.0" 
$ns at 642.284859718483 "$node_(238) setdest 91333 12516 5.0" 
$ns at 692.2975553424458 "$node_(238) setdest 15657 35247 10.0" 
$ns at 760.888944695293 "$node_(238) setdest 17837 7855 1.0" 
$ns at 799.606970496172 "$node_(238) setdest 42869 19029 7.0" 
$ns at 869.2181545522026 "$node_(238) setdest 58034 28320 10.0" 
$ns at 223.3476293392401 "$node_(239) setdest 56622 29244 18.0" 
$ns at 367.61604683800056 "$node_(239) setdest 72660 32267 6.0" 
$ns at 417.7288262902936 "$node_(239) setdest 98860 32492 2.0" 
$ns at 464.0797939814884 "$node_(239) setdest 20181 10634 14.0" 
$ns at 562.489729601992 "$node_(239) setdest 32481 33455 16.0" 
$ns at 615.7010350414192 "$node_(239) setdest 2497 43666 4.0" 
$ns at 649.9147355959806 "$node_(239) setdest 27343 40953 9.0" 
$ns at 738.4440872979412 "$node_(239) setdest 121945 28515 17.0" 
$ns at 281.1176479488598 "$node_(240) setdest 7313 38522 1.0" 
$ns at 318.17935750583393 "$node_(240) setdest 87827 5819 11.0" 
$ns at 456.65193579811057 "$node_(240) setdest 63466 43777 2.0" 
$ns at 496.551044657122 "$node_(240) setdest 50597 18720 10.0" 
$ns at 544.3864795098344 "$node_(240) setdest 41166 29430 6.0" 
$ns at 583.0129776538386 "$node_(240) setdest 81906 14108 10.0" 
$ns at 691.7964836731684 "$node_(240) setdest 49647 29733 5.0" 
$ns at 747.5308472108964 "$node_(240) setdest 110569 24876 4.0" 
$ns at 791.5221731161391 "$node_(240) setdest 132358 837 20.0" 
$ns at 359.30524364764153 "$node_(241) setdest 62610 25847 16.0" 
$ns at 424.4369160769582 "$node_(241) setdest 19672 5217 5.0" 
$ns at 485.5078695130542 "$node_(241) setdest 78946 3350 4.0" 
$ns at 516.9755833329518 "$node_(241) setdest 71112 30698 5.0" 
$ns at 596.7556101990006 "$node_(241) setdest 62677 42052 7.0" 
$ns at 686.1954962943573 "$node_(241) setdest 93515 28430 6.0" 
$ns at 748.8301589920878 "$node_(241) setdest 14647 21153 11.0" 
$ns at 833.5272623456258 "$node_(241) setdest 50940 37712 14.0" 
$ns at 869.4208363370311 "$node_(241) setdest 66437 39475 8.0" 
$ns at 234.65268450036382 "$node_(242) setdest 24092 30268 16.0" 
$ns at 355.72643228810875 "$node_(242) setdest 107551 28134 3.0" 
$ns at 408.3421114944645 "$node_(242) setdest 62610 5953 17.0" 
$ns at 465.67507487211617 "$node_(242) setdest 105922 14240 12.0" 
$ns at 498.60082729153265 "$node_(242) setdest 90484 11126 4.0" 
$ns at 552.6198315269859 "$node_(242) setdest 87205 20900 2.0" 
$ns at 586.8753806614983 "$node_(242) setdest 84282 41460 3.0" 
$ns at 632.8561078295759 "$node_(242) setdest 67142 14938 3.0" 
$ns at 670.9805091070507 "$node_(242) setdest 126092 958 12.0" 
$ns at 791.2775139654768 "$node_(242) setdest 19392 9857 14.0" 
$ns at 863.2525035114263 "$node_(242) setdest 3579 44535 11.0" 
$ns at 231.31147395181296 "$node_(243) setdest 46145 12338 14.0" 
$ns at 311.4138926385964 "$node_(243) setdest 112205 11310 4.0" 
$ns at 346.9314639050835 "$node_(243) setdest 17034 37001 10.0" 
$ns at 464.3463021269415 "$node_(243) setdest 9097 20929 1.0" 
$ns at 498.33951391028427 "$node_(243) setdest 69122 18104 10.0" 
$ns at 566.299969392703 "$node_(243) setdest 96512 42246 12.0" 
$ns at 670.3064954239883 "$node_(243) setdest 101038 31929 1.0" 
$ns at 702.4783747040426 "$node_(243) setdest 56149 5606 17.0" 
$ns at 838.271475845194 "$node_(243) setdest 16287 13348 6.0" 
$ns at 876.099237267625 "$node_(243) setdest 88788 11461 3.0" 
$ns at 280.0164956525398 "$node_(244) setdest 75141 31997 18.0" 
$ns at 333.5930326500193 "$node_(244) setdest 126101 27017 8.0" 
$ns at 412.47090873931427 "$node_(244) setdest 77044 11303 13.0" 
$ns at 541.241825397834 "$node_(244) setdest 13552 10907 12.0" 
$ns at 625.8740166355425 "$node_(244) setdest 33438 18712 6.0" 
$ns at 673.9931348071766 "$node_(244) setdest 15419 13876 5.0" 
$ns at 732.2363781936456 "$node_(244) setdest 70822 5276 14.0" 
$ns at 812.4279701878045 "$node_(244) setdest 51171 1624 7.0" 
$ns at 845.972143983894 "$node_(244) setdest 97125 25997 6.0" 
$ns at 897.03096767125 "$node_(244) setdest 99802 318 19.0" 
$ns at 278.5835472777099 "$node_(245) setdest 81838 26493 10.0" 
$ns at 405.87809416588385 "$node_(245) setdest 123993 6449 1.0" 
$ns at 444.36443602899453 "$node_(245) setdest 70148 17263 17.0" 
$ns at 631.4696491477105 "$node_(245) setdest 12954 20778 11.0" 
$ns at 753.0571586729703 "$node_(245) setdest 130477 10527 1.0" 
$ns at 791.5325405481885 "$node_(245) setdest 14677 29353 9.0" 
$ns at 845.1605169018658 "$node_(245) setdest 133263 11490 9.0" 
$ns at 890.1656203718688 "$node_(245) setdest 5702 9716 10.0" 
$ns at 261.6805016077898 "$node_(246) setdest 32290 5387 12.0" 
$ns at 338.5352728892263 "$node_(246) setdest 117483 13291 13.0" 
$ns at 416.3118764762542 "$node_(246) setdest 8240 4123 12.0" 
$ns at 521.6301937627759 "$node_(246) setdest 110213 41394 2.0" 
$ns at 558.0145409576695 "$node_(246) setdest 76196 36824 8.0" 
$ns at 617.3933475100414 "$node_(246) setdest 114232 38694 11.0" 
$ns at 664.0595823808776 "$node_(246) setdest 54227 44715 1.0" 
$ns at 699.9600627285918 "$node_(246) setdest 52532 7435 19.0" 
$ns at 782.9373119777224 "$node_(246) setdest 116914 39058 3.0" 
$ns at 835.6753606488345 "$node_(246) setdest 127378 11834 1.0" 
$ns at 871.1672882913924 "$node_(246) setdest 1833 9856 15.0" 
$ns at 281.07648810777664 "$node_(247) setdest 114750 16529 4.0" 
$ns at 321.09490380743904 "$node_(247) setdest 106139 3140 5.0" 
$ns at 365.0924399311019 "$node_(247) setdest 19159 16266 9.0" 
$ns at 463.5560725555884 "$node_(247) setdest 10816 43147 18.0" 
$ns at 592.3557328814363 "$node_(247) setdest 121184 34689 19.0" 
$ns at 725.526989985 "$node_(247) setdest 32958 8736 18.0" 
$ns at 217.53286676518968 "$node_(248) setdest 14499 19651 18.0" 
$ns at 274.5090885690339 "$node_(248) setdest 77556 6519 13.0" 
$ns at 371.7119025630017 "$node_(248) setdest 9016 23890 4.0" 
$ns at 417.4052421684073 "$node_(248) setdest 55204 11393 15.0" 
$ns at 449.81784681231704 "$node_(248) setdest 112945 44454 10.0" 
$ns at 535.3439336789475 "$node_(248) setdest 4604 11206 6.0" 
$ns at 587.1914116749742 "$node_(248) setdest 57861 13579 20.0" 
$ns at 639.6558615192359 "$node_(248) setdest 108117 29404 17.0" 
$ns at 676.8755726757744 "$node_(248) setdest 87896 10769 10.0" 
$ns at 738.7455529525225 "$node_(248) setdest 3812 13144 15.0" 
$ns at 811.3779472237114 "$node_(248) setdest 110521 8334 18.0" 
$ns at 226.49977777914276 "$node_(249) setdest 80835 22641 18.0" 
$ns at 426.4438430207241 "$node_(249) setdest 43915 43624 4.0" 
$ns at 461.35608533936806 "$node_(249) setdest 74316 1544 18.0" 
$ns at 552.0041492377236 "$node_(249) setdest 33695 12031 1.0" 
$ns at 582.9104950447937 "$node_(249) setdest 2729 18295 7.0" 
$ns at 633.7570276648391 "$node_(249) setdest 81185 15498 15.0" 
$ns at 777.402529083817 "$node_(249) setdest 6333 40576 18.0" 
$ns at 256.3330327286859 "$node_(250) setdest 99533 37793 7.0" 
$ns at 328.6129849360164 "$node_(250) setdest 80795 21659 1.0" 
$ns at 367.90194893421756 "$node_(250) setdest 67218 21824 3.0" 
$ns at 412.25011194948615 "$node_(250) setdest 56039 9766 9.0" 
$ns at 526.6535266984184 "$node_(250) setdest 84556 24778 1.0" 
$ns at 560.9397337796336 "$node_(250) setdest 12715 35042 11.0" 
$ns at 671.2832937855608 "$node_(250) setdest 32399 14840 19.0" 
$ns at 887.8865135835949 "$node_(250) setdest 21551 36088 7.0" 
$ns at 214.84060014664394 "$node_(251) setdest 32908 16537 9.0" 
$ns at 316.28955487679303 "$node_(251) setdest 130931 22667 6.0" 
$ns at 360.2432389748052 "$node_(251) setdest 23430 4827 19.0" 
$ns at 529.6622275433583 "$node_(251) setdest 21268 2303 7.0" 
$ns at 609.0973014283952 "$node_(251) setdest 53360 23707 17.0" 
$ns at 805.2569762185456 "$node_(251) setdest 52640 7601 18.0" 
$ns at 884.6501012409979 "$node_(251) setdest 54372 12909 18.0" 
$ns at 259.075290096294 "$node_(252) setdest 82708 25630 3.0" 
$ns at 316.12055114006125 "$node_(252) setdest 43230 30516 4.0" 
$ns at 377.6117956442135 "$node_(252) setdest 64476 15433 18.0" 
$ns at 485.4756620352091 "$node_(252) setdest 21141 27434 15.0" 
$ns at 655.0795834055222 "$node_(252) setdest 84341 27649 19.0" 
$ns at 776.224916721615 "$node_(252) setdest 59214 9193 4.0" 
$ns at 813.921697088291 "$node_(252) setdest 103394 43142 19.0" 
$ns at 271.21733618796895 "$node_(253) setdest 113190 23813 12.0" 
$ns at 319.4915367014752 "$node_(253) setdest 115705 21609 20.0" 
$ns at 492.03967377803406 "$node_(253) setdest 37300 38581 2.0" 
$ns at 529.3187343866263 "$node_(253) setdest 62991 25212 17.0" 
$ns at 671.1745886003176 "$node_(253) setdest 83781 27442 16.0" 
$ns at 825.5108462203766 "$node_(253) setdest 121783 10360 11.0" 
$ns at 319.3115903800131 "$node_(254) setdest 111053 12964 1.0" 
$ns at 358.7760155923282 "$node_(254) setdest 117053 38182 4.0" 
$ns at 426.970335820542 "$node_(254) setdest 16881 11863 17.0" 
$ns at 461.3498109299208 "$node_(254) setdest 61379 15935 16.0" 
$ns at 646.2149077299941 "$node_(254) setdest 31478 24696 10.0" 
$ns at 763.6874536755518 "$node_(254) setdest 34263 3950 19.0" 
$ns at 294.5046769398089 "$node_(255) setdest 118113 28398 3.0" 
$ns at 329.5701271088588 "$node_(255) setdest 47168 41476 1.0" 
$ns at 365.9103876743351 "$node_(255) setdest 64528 22426 20.0" 
$ns at 570.012873057218 "$node_(255) setdest 38724 23995 13.0" 
$ns at 699.303309997839 "$node_(255) setdest 26986 10432 16.0" 
$ns at 854.8347071151599 "$node_(255) setdest 89845 19812 11.0" 
$ns at 260.7657574128424 "$node_(256) setdest 70929 2005 19.0" 
$ns at 304.59828005164684 "$node_(256) setdest 130156 25557 8.0" 
$ns at 409.8874843535517 "$node_(256) setdest 89587 2730 5.0" 
$ns at 442.1839843723837 "$node_(256) setdest 128633 23131 16.0" 
$ns at 601.1326691259237 "$node_(256) setdest 65898 633 2.0" 
$ns at 639.1378665672355 "$node_(256) setdest 17323 14829 4.0" 
$ns at 688.7202533881679 "$node_(256) setdest 56852 44048 19.0" 
$ns at 742.0526019450838 "$node_(256) setdest 39003 12282 4.0" 
$ns at 788.1281044310166 "$node_(256) setdest 11771 18457 10.0" 
$ns at 879.4893973412907 "$node_(256) setdest 32664 39232 13.0" 
$ns at 223.81136632758 "$node_(257) setdest 132035 15963 10.0" 
$ns at 259.67377434101377 "$node_(257) setdest 121570 11733 16.0" 
$ns at 321.29752911252456 "$node_(257) setdest 132182 41518 8.0" 
$ns at 419.10741512782056 "$node_(257) setdest 107496 18148 4.0" 
$ns at 477.57542677004716 "$node_(257) setdest 65933 29428 17.0" 
$ns at 522.0858646028197 "$node_(257) setdest 59460 27466 17.0" 
$ns at 679.8998159661219 "$node_(257) setdest 82877 34706 10.0" 
$ns at 757.4775992503365 "$node_(257) setdest 112748 36080 3.0" 
$ns at 811.8732978961054 "$node_(257) setdest 84646 6663 16.0" 
$ns at 886.9593935183809 "$node_(257) setdest 106539 36 1.0" 
$ns at 267.3322233796589 "$node_(258) setdest 109813 37010 14.0" 
$ns at 371.49960930357315 "$node_(258) setdest 51635 6698 8.0" 
$ns at 416.4739792567113 "$node_(258) setdest 104572 32474 4.0" 
$ns at 453.13373350540644 "$node_(258) setdest 67696 16048 2.0" 
$ns at 493.29366337160496 "$node_(258) setdest 60879 25568 4.0" 
$ns at 556.8103928893976 "$node_(258) setdest 1638 8460 2.0" 
$ns at 601.6760944154491 "$node_(258) setdest 130570 1057 8.0" 
$ns at 647.9755433110936 "$node_(258) setdest 38765 39197 9.0" 
$ns at 679.2008871326763 "$node_(258) setdest 105719 24720 3.0" 
$ns at 719.0301125094898 "$node_(258) setdest 68873 33336 17.0" 
$ns at 888.4817271451242 "$node_(258) setdest 34942 20232 3.0" 
$ns at 208.82956206823806 "$node_(259) setdest 73433 39041 9.0" 
$ns at 302.3030488556732 "$node_(259) setdest 37743 30177 16.0" 
$ns at 487.35499528920843 "$node_(259) setdest 4971 3919 3.0" 
$ns at 539.4105718157081 "$node_(259) setdest 12652 26775 13.0" 
$ns at 608.1493041321711 "$node_(259) setdest 23556 6610 12.0" 
$ns at 744.261900908482 "$node_(259) setdest 119968 29337 4.0" 
$ns at 775.44225403224 "$node_(259) setdest 73664 28224 17.0" 
$ns at 834.2643682738045 "$node_(259) setdest 114456 32725 16.0" 
$ns at 283.13378412328876 "$node_(260) setdest 94211 20024 3.0" 
$ns at 334.38847928348633 "$node_(260) setdest 76486 38233 2.0" 
$ns at 373.89473084146283 "$node_(260) setdest 102402 19678 6.0" 
$ns at 451.25298567075197 "$node_(260) setdest 46878 33864 7.0" 
$ns at 484.98646465643446 "$node_(260) setdest 11535 23556 4.0" 
$ns at 531.6674687862671 "$node_(260) setdest 35709 25983 11.0" 
$ns at 628.3265014210269 "$node_(260) setdest 81695 11793 6.0" 
$ns at 700.9369499469542 "$node_(260) setdest 10567 24128 11.0" 
$ns at 818.2966296965523 "$node_(260) setdest 51671 14376 12.0" 
$ns at 865.4298549074168 "$node_(260) setdest 24401 18985 9.0" 
$ns at 212.90126017502777 "$node_(261) setdest 111897 22578 18.0" 
$ns at 414.24735282465934 "$node_(261) setdest 101855 27744 19.0" 
$ns at 541.2446918261792 "$node_(261) setdest 23348 21645 19.0" 
$ns at 623.2923071526363 "$node_(261) setdest 49439 10326 18.0" 
$ns at 718.3920929981216 "$node_(261) setdest 112923 2256 13.0" 
$ns at 815.1745369007658 "$node_(261) setdest 60105 4054 4.0" 
$ns at 852.0614661326673 "$node_(261) setdest 93973 6266 19.0" 
$ns at 330.27035960699095 "$node_(262) setdest 10969 42182 12.0" 
$ns at 463.0415122528516 "$node_(262) setdest 34137 27975 2.0" 
$ns at 496.7617410732331 "$node_(262) setdest 52975 28644 9.0" 
$ns at 546.9068557576541 "$node_(262) setdest 104305 34939 7.0" 
$ns at 627.1526354346415 "$node_(262) setdest 32739 12024 11.0" 
$ns at 700.7041597338565 "$node_(262) setdest 82822 18076 4.0" 
$ns at 750.4702264700448 "$node_(262) setdest 26760 14677 17.0" 
$ns at 858.2959941321244 "$node_(262) setdest 14494 9122 15.0" 
$ns at 212.25007161357348 "$node_(263) setdest 69837 38783 4.0" 
$ns at 252.60021514981983 "$node_(263) setdest 16829 6863 10.0" 
$ns at 287.62070931235957 "$node_(263) setdest 118141 4574 13.0" 
$ns at 379.3846595933428 "$node_(263) setdest 97689 2426 17.0" 
$ns at 475.4365866707142 "$node_(263) setdest 112861 25295 1.0" 
$ns at 507.9452278984904 "$node_(263) setdest 105591 32080 10.0" 
$ns at 627.610934922535 "$node_(263) setdest 93228 12829 15.0" 
$ns at 756.979093555412 "$node_(263) setdest 81259 26760 6.0" 
$ns at 828.9256216506961 "$node_(263) setdest 114890 19068 9.0" 
$ns at 336.63865648514025 "$node_(264) setdest 118078 39246 1.0" 
$ns at 376.11709567723074 "$node_(264) setdest 69402 39699 1.0" 
$ns at 411.41359743634433 "$node_(264) setdest 131095 22361 5.0" 
$ns at 455.9361687248454 "$node_(264) setdest 96816 27543 5.0" 
$ns at 532.4430501028678 "$node_(264) setdest 29659 162 20.0" 
$ns at 671.2517548772137 "$node_(264) setdest 34534 22079 8.0" 
$ns at 748.725301177853 "$node_(264) setdest 22256 11225 10.0" 
$ns at 836.392657265339 "$node_(264) setdest 85169 21999 1.0" 
$ns at 867.6297440909663 "$node_(264) setdest 6389 34090 6.0" 
$ns at 359.6842373150462 "$node_(265) setdest 129277 22692 19.0" 
$ns at 489.9265339017067 "$node_(265) setdest 120651 30482 12.0" 
$ns at 524.288531993567 "$node_(265) setdest 2169 30800 2.0" 
$ns at 565.5055994070226 "$node_(265) setdest 13183 38013 2.0" 
$ns at 596.4039602543435 "$node_(265) setdest 90076 43410 4.0" 
$ns at 653.2535259162189 "$node_(265) setdest 68504 6392 7.0" 
$ns at 736.2794484014532 "$node_(265) setdest 100047 16685 19.0" 
$ns at 870.0640835098393 "$node_(265) setdest 81536 13440 10.0" 
$ns at 310.7791154451061 "$node_(266) setdest 6111 43440 3.0" 
$ns at 355.83589277172393 "$node_(266) setdest 38181 30771 2.0" 
$ns at 395.8668803706493 "$node_(266) setdest 66967 11326 11.0" 
$ns at 440.06766575027507 "$node_(266) setdest 39335 14060 3.0" 
$ns at 492.6982419971896 "$node_(266) setdest 121092 39011 13.0" 
$ns at 614.2401656948687 "$node_(266) setdest 121512 22201 13.0" 
$ns at 729.0635172400432 "$node_(266) setdest 84074 10771 1.0" 
$ns at 759.6131315925101 "$node_(266) setdest 47356 14968 8.0" 
$ns at 856.5582960717016 "$node_(266) setdest 55897 23694 17.0" 
$ns at 895.9551412109356 "$node_(266) setdest 69779 20317 1.0" 
$ns at 220.7707143776393 "$node_(267) setdest 57884 10592 7.0" 
$ns at 289.3896517431424 "$node_(267) setdest 43068 3512 4.0" 
$ns at 343.9604391730081 "$node_(267) setdest 131210 2930 20.0" 
$ns at 477.1155675882823 "$node_(267) setdest 80737 16489 5.0" 
$ns at 525.7412038793827 "$node_(267) setdest 79315 44148 11.0" 
$ns at 590.6913000207885 "$node_(267) setdest 80074 7479 3.0" 
$ns at 630.7171677061905 "$node_(267) setdest 36376 9379 5.0" 
$ns at 703.1195866943106 "$node_(267) setdest 103433 34269 17.0" 
$ns at 861.8713071874571 "$node_(267) setdest 116810 18338 1.0" 
$ns at 212.89473945357673 "$node_(268) setdest 18948 9328 17.0" 
$ns at 403.677764019298 "$node_(268) setdest 69946 11212 8.0" 
$ns at 460.1647536922079 "$node_(268) setdest 67082 5843 1.0" 
$ns at 491.5689104251998 "$node_(268) setdest 45514 10210 4.0" 
$ns at 538.4311939487828 "$node_(268) setdest 109812 28495 2.0" 
$ns at 577.0657103403365 "$node_(268) setdest 38182 42938 15.0" 
$ns at 715.937764238822 "$node_(268) setdest 105180 2526 14.0" 
$ns at 877.1338426084415 "$node_(268) setdest 84713 9755 6.0" 
$ns at 375.6476052302394 "$node_(269) setdest 125935 22714 6.0" 
$ns at 412.1008236568151 "$node_(269) setdest 11383 34129 15.0" 
$ns at 555.8735335671336 "$node_(269) setdest 127519 5377 2.0" 
$ns at 594.8672242595271 "$node_(269) setdest 99952 1544 3.0" 
$ns at 649.4896831161001 "$node_(269) setdest 53768 4071 5.0" 
$ns at 715.9443477391494 "$node_(269) setdest 131591 13765 8.0" 
$ns at 760.920421086308 "$node_(269) setdest 50413 25037 13.0" 
$ns at 837.3452056626224 "$node_(269) setdest 76034 19 16.0" 
$ns at 224.87723646414594 "$node_(270) setdest 134057 26361 10.0" 
$ns at 260.61455189160756 "$node_(270) setdest 11530 21719 11.0" 
$ns at 390.56861145307926 "$node_(270) setdest 132365 34432 19.0" 
$ns at 531.7084771519558 "$node_(270) setdest 50898 3672 1.0" 
$ns at 570.7476512391057 "$node_(270) setdest 66662 40344 16.0" 
$ns at 682.3704625400301 "$node_(270) setdest 4396 18009 4.0" 
$ns at 737.9051651321665 "$node_(270) setdest 56550 7138 1.0" 
$ns at 768.2446927259094 "$node_(270) setdest 95579 11251 16.0" 
$ns at 884.925352034251 "$node_(270) setdest 117299 12484 4.0" 
$ns at 288.3300350907268 "$node_(271) setdest 2938 32144 16.0" 
$ns at 414.50358361304393 "$node_(271) setdest 16247 40273 11.0" 
$ns at 543.8048746238927 "$node_(271) setdest 88886 12232 11.0" 
$ns at 667.0048514197456 "$node_(271) setdest 56129 1646 4.0" 
$ns at 704.0371452643503 "$node_(271) setdest 102799 20995 6.0" 
$ns at 784.0896942601798 "$node_(271) setdest 124269 18223 8.0" 
$ns at 874.8333978495792 "$node_(271) setdest 19635 6616 19.0" 
$ns at 260.69944533680814 "$node_(272) setdest 128522 21655 9.0" 
$ns at 362.0362341036456 "$node_(272) setdest 27504 41960 14.0" 
$ns at 469.2996341330676 "$node_(272) setdest 127720 21392 13.0" 
$ns at 606.623830632881 "$node_(272) setdest 71041 10733 17.0" 
$ns at 787.6226066044603 "$node_(272) setdest 83212 34506 4.0" 
$ns at 844.9232928200565 "$node_(272) setdest 134018 9056 6.0" 
$ns at 887.8106249892844 "$node_(272) setdest 82938 44315 6.0" 
$ns at 295.7031231021179 "$node_(273) setdest 61334 6859 5.0" 
$ns at 335.23076660081773 "$node_(273) setdest 2449 5603 17.0" 
$ns at 403.76645081887443 "$node_(273) setdest 64085 39741 13.0" 
$ns at 549.2784400887954 "$node_(273) setdest 85837 32949 16.0" 
$ns at 604.9424122009306 "$node_(273) setdest 114927 6066 3.0" 
$ns at 659.7134015993621 "$node_(273) setdest 51017 32637 5.0" 
$ns at 711.7018567616013 "$node_(273) setdest 30722 32526 14.0" 
$ns at 817.0466303226424 "$node_(273) setdest 74975 26801 16.0" 
$ns at 878.8591672409069 "$node_(273) setdest 74230 30550 16.0" 
$ns at 239.4983101807282 "$node_(274) setdest 91903 10850 2.0" 
$ns at 274.19698597051627 "$node_(274) setdest 57902 33523 15.0" 
$ns at 441.74454302682346 "$node_(274) setdest 72733 22178 8.0" 
$ns at 550.8852284928064 "$node_(274) setdest 68465 14792 9.0" 
$ns at 615.2143056047196 "$node_(274) setdest 86791 15978 4.0" 
$ns at 675.1343085564099 "$node_(274) setdest 12339 41632 3.0" 
$ns at 716.8818260565002 "$node_(274) setdest 55387 24294 6.0" 
$ns at 783.1198893374046 "$node_(274) setdest 46834 36085 8.0" 
$ns at 857.7016282228524 "$node_(274) setdest 101354 28201 16.0" 
$ns at 252.8018954441957 "$node_(275) setdest 108611 26721 17.0" 
$ns at 405.87866837138904 "$node_(275) setdest 72066 19692 14.0" 
$ns at 445.75238876036383 "$node_(275) setdest 76207 480 2.0" 
$ns at 492.58844964904284 "$node_(275) setdest 85452 38599 6.0" 
$ns at 522.7359928190734 "$node_(275) setdest 73264 7471 16.0" 
$ns at 633.7043116846735 "$node_(275) setdest 132915 12763 13.0" 
$ns at 775.615522712129 "$node_(275) setdest 50099 34012 2.0" 
$ns at 806.4349302897197 "$node_(275) setdest 114410 31457 6.0" 
$ns at 841.8385297932294 "$node_(275) setdest 31482 14521 4.0" 
$ns at 880.4475323910433 "$node_(275) setdest 11681 33645 5.0" 
$ns at 224.81009210881047 "$node_(276) setdest 12865 3280 15.0" 
$ns at 360.13722096103527 "$node_(276) setdest 74435 42345 3.0" 
$ns at 411.27044140491273 "$node_(276) setdest 105883 7707 11.0" 
$ns at 524.0181882952229 "$node_(276) setdest 6220 43510 6.0" 
$ns at 554.714076589772 "$node_(276) setdest 41913 30245 11.0" 
$ns at 679.7526192391991 "$node_(276) setdest 70550 11082 2.0" 
$ns at 713.553092020443 "$node_(276) setdest 31243 44583 8.0" 
$ns at 799.8369076326774 "$node_(276) setdest 133853 28123 4.0" 
$ns at 838.0423887550877 "$node_(276) setdest 125188 33364 19.0" 
$ns at 218.9103628016495 "$node_(277) setdest 60127 26404 1.0" 
$ns at 255.24067884470068 "$node_(277) setdest 51761 31285 6.0" 
$ns at 307.75394169241184 "$node_(277) setdest 28910 43791 15.0" 
$ns at 470.34709866508217 "$node_(277) setdest 128342 7932 19.0" 
$ns at 527.7019019092958 "$node_(277) setdest 65332 16996 15.0" 
$ns at 593.0504413363337 "$node_(277) setdest 60877 28117 2.0" 
$ns at 637.876642113797 "$node_(277) setdest 127688 12338 7.0" 
$ns at 710.8110935114087 "$node_(277) setdest 26091 27886 13.0" 
$ns at 868.4209103640586 "$node_(277) setdest 124253 24273 3.0" 
$ns at 235.44375954765178 "$node_(278) setdest 44777 39734 6.0" 
$ns at 292.89721476347637 "$node_(278) setdest 9314 34709 4.0" 
$ns at 361.2741206552822 "$node_(278) setdest 94029 15207 12.0" 
$ns at 443.53499261899117 "$node_(278) setdest 15650 3943 19.0" 
$ns at 539.7765675912806 "$node_(278) setdest 112234 23929 14.0" 
$ns at 680.9335699602759 "$node_(278) setdest 90913 9972 9.0" 
$ns at 774.4167319842156 "$node_(278) setdest 85012 23042 5.0" 
$ns at 811.9387691805886 "$node_(278) setdest 33868 38480 17.0" 
$ns at 234.74866202050123 "$node_(279) setdest 66116 20909 20.0" 
$ns at 432.61810599267017 "$node_(279) setdest 84573 27140 19.0" 
$ns at 477.5042606730694 "$node_(279) setdest 117374 31932 11.0" 
$ns at 613.1805564364206 "$node_(279) setdest 45303 20507 14.0" 
$ns at 662.4638799318457 "$node_(279) setdest 6517 38490 4.0" 
$ns at 719.3097314320489 "$node_(279) setdest 129513 18200 19.0" 
$ns at 873.5665983328747 "$node_(279) setdest 15601 20105 10.0" 
$ns at 248.4495932027643 "$node_(280) setdest 63773 42462 17.0" 
$ns at 325.75393016008616 "$node_(280) setdest 98138 3110 4.0" 
$ns at 392.4576425160347 "$node_(280) setdest 46275 24506 2.0" 
$ns at 441.50943977260187 "$node_(280) setdest 84790 16646 12.0" 
$ns at 506.0841615091376 "$node_(280) setdest 7189 25338 12.0" 
$ns at 624.382355022693 "$node_(280) setdest 62356 44558 20.0" 
$ns at 777.0065764256012 "$node_(280) setdest 73832 17842 4.0" 
$ns at 841.8725079640049 "$node_(280) setdest 111181 26543 3.0" 
$ns at 876.0212712114053 "$node_(280) setdest 17170 43538 14.0" 
$ns at 261.3188082995073 "$node_(281) setdest 114095 41027 13.0" 
$ns at 293.2256977565553 "$node_(281) setdest 107264 35629 7.0" 
$ns at 344.59792955285076 "$node_(281) setdest 22291 22052 17.0" 
$ns at 423.98725360110495 "$node_(281) setdest 57018 7900 11.0" 
$ns at 479.0741865496244 "$node_(281) setdest 7477 28007 13.0" 
$ns at 633.1939829395016 "$node_(281) setdest 119106 5393 1.0" 
$ns at 672.2617136921231 "$node_(281) setdest 127696 20840 12.0" 
$ns at 722.7655109368183 "$node_(281) setdest 37540 11868 16.0" 
$ns at 839.2069245786006 "$node_(281) setdest 65755 25024 17.0" 
$ns at 252.37599297254528 "$node_(282) setdest 108541 42880 5.0" 
$ns at 295.60125722711365 "$node_(282) setdest 60647 20407 5.0" 
$ns at 372.4705710249532 "$node_(282) setdest 5925 39551 8.0" 
$ns at 476.9372034032232 "$node_(282) setdest 63483 35940 2.0" 
$ns at 508.85509720194557 "$node_(282) setdest 113330 31288 16.0" 
$ns at 634.9355809480043 "$node_(282) setdest 19189 19475 9.0" 
$ns at 738.9633617055676 "$node_(282) setdest 23223 14755 1.0" 
$ns at 775.0027021653154 "$node_(282) setdest 105171 27575 17.0" 
$ns at 285.1269683230486 "$node_(283) setdest 86325 44224 15.0" 
$ns at 419.8765114195586 "$node_(283) setdest 103452 4160 13.0" 
$ns at 527.7696681253533 "$node_(283) setdest 59670 16888 7.0" 
$ns at 560.1218002914388 "$node_(283) setdest 45095 29207 10.0" 
$ns at 613.796874094444 "$node_(283) setdest 1892 2251 4.0" 
$ns at 650.8557788537856 "$node_(283) setdest 52462 24265 14.0" 
$ns at 683.2344907214575 "$node_(283) setdest 48072 16659 18.0" 
$ns at 762.546123379133 "$node_(283) setdest 124874 7647 5.0" 
$ns at 816.9783939625255 "$node_(283) setdest 128548 30219 6.0" 
$ns at 851.4391610237001 "$node_(283) setdest 81569 32932 6.0" 
$ns at 204.62717510330975 "$node_(284) setdest 78356 1009 7.0" 
$ns at 272.41049321622035 "$node_(284) setdest 120612 40314 20.0" 
$ns at 344.7292730425019 "$node_(284) setdest 14305 25485 8.0" 
$ns at 382.1333499422226 "$node_(284) setdest 45568 1981 17.0" 
$ns at 558.8439765757174 "$node_(284) setdest 123849 36218 18.0" 
$ns at 723.3114900714459 "$node_(284) setdest 10885 25574 13.0" 
$ns at 786.6139271805195 "$node_(284) setdest 111723 15361 6.0" 
$ns at 842.9172772491936 "$node_(284) setdest 93137 19239 7.0" 
$ns at 899.1976455420935 "$node_(284) setdest 110719 23469 18.0" 
$ns at 304.0150377435948 "$node_(285) setdest 112049 41863 17.0" 
$ns at 493.88320979137586 "$node_(285) setdest 124206 3958 6.0" 
$ns at 554.1581741687854 "$node_(285) setdest 77481 37749 12.0" 
$ns at 629.0743495864849 "$node_(285) setdest 55137 39406 7.0" 
$ns at 682.4911877494981 "$node_(285) setdest 24594 18013 13.0" 
$ns at 803.7276725358406 "$node_(285) setdest 56699 2650 4.0" 
$ns at 843.3493953080423 "$node_(285) setdest 8151 6348 17.0" 
$ns at 238.00806784360964 "$node_(286) setdest 27218 30493 11.0" 
$ns at 356.29001483735226 "$node_(286) setdest 42862 40576 8.0" 
$ns at 442.3768226941794 "$node_(286) setdest 121491 9354 20.0" 
$ns at 579.246327721125 "$node_(286) setdest 45074 30603 13.0" 
$ns at 665.0256672327758 "$node_(286) setdest 72182 42787 9.0" 
$ns at 758.8015971787439 "$node_(286) setdest 117896 16937 9.0" 
$ns at 837.7598939229891 "$node_(286) setdest 129061 26424 4.0" 
$ns at 890.435540809638 "$node_(286) setdest 76383 36095 3.0" 
$ns at 230.394718088679 "$node_(287) setdest 97121 26972 19.0" 
$ns at 327.7262599290831 "$node_(287) setdest 63644 38512 1.0" 
$ns at 358.36231069508534 "$node_(287) setdest 95500 16331 3.0" 
$ns at 399.6792231697003 "$node_(287) setdest 88722 41267 19.0" 
$ns at 553.1961360706291 "$node_(287) setdest 47557 43236 13.0" 
$ns at 646.4011693562538 "$node_(287) setdest 60530 22101 2.0" 
$ns at 676.7226447761323 "$node_(287) setdest 40713 11657 8.0" 
$ns at 756.2609031719866 "$node_(287) setdest 26914 1200 2.0" 
$ns at 797.9700463814191 "$node_(287) setdest 105327 26255 14.0" 
$ns at 282.87235983053824 "$node_(288) setdest 80422 18467 4.0" 
$ns at 321.4863858843265 "$node_(288) setdest 52339 13654 17.0" 
$ns at 503.0432535003332 "$node_(288) setdest 21709 12827 9.0" 
$ns at 558.9858241244624 "$node_(288) setdest 34873 21730 15.0" 
$ns at 714.923532116019 "$node_(288) setdest 69100 13052 6.0" 
$ns at 803.6907718946048 "$node_(288) setdest 52098 15678 2.0" 
$ns at 853.4521462135422 "$node_(288) setdest 55149 19019 4.0" 
$ns at 277.18981740055403 "$node_(289) setdest 88901 20637 12.0" 
$ns at 347.406085285731 "$node_(289) setdest 65899 2491 8.0" 
$ns at 430.5089165212348 "$node_(289) setdest 98896 28076 19.0" 
$ns at 554.8523081108118 "$node_(289) setdest 49887 3473 19.0" 
$ns at 772.5720879518034 "$node_(289) setdest 45638 10516 13.0" 
$ns at 200.64285950514855 "$node_(290) setdest 3189 20322 11.0" 
$ns at 262.8185564026094 "$node_(290) setdest 90683 21084 6.0" 
$ns at 310.58501778234256 "$node_(290) setdest 13214 37205 9.0" 
$ns at 368.65896467245574 "$node_(290) setdest 32501 24922 8.0" 
$ns at 400.12360519402984 "$node_(290) setdest 5183 39930 16.0" 
$ns at 468.5281037327809 "$node_(290) setdest 53055 6120 8.0" 
$ns at 537.7001954205258 "$node_(290) setdest 92045 36721 1.0" 
$ns at 569.039324495956 "$node_(290) setdest 24327 7531 2.0" 
$ns at 601.116729730941 "$node_(290) setdest 69600 1259 1.0" 
$ns at 636.6050106022177 "$node_(290) setdest 47708 19113 17.0" 
$ns at 746.8110540670714 "$node_(290) setdest 108634 20790 15.0" 
$ns at 803.5410938388153 "$node_(290) setdest 21144 23394 1.0" 
$ns at 836.7376157048175 "$node_(290) setdest 70855 30234 13.0" 
$ns at 213.32755545178168 "$node_(291) setdest 116393 230 11.0" 
$ns at 263.0357499189129 "$node_(291) setdest 101740 22968 7.0" 
$ns at 319.31230111906694 "$node_(291) setdest 91370 43197 13.0" 
$ns at 382.640904910549 "$node_(291) setdest 52516 11555 9.0" 
$ns at 497.1310632650032 "$node_(291) setdest 83129 22785 14.0" 
$ns at 598.8920745181184 "$node_(291) setdest 96241 28462 1.0" 
$ns at 636.9104484026733 "$node_(291) setdest 126908 43186 1.0" 
$ns at 674.1279303077886 "$node_(291) setdest 125020 221 14.0" 
$ns at 788.648382875007 "$node_(291) setdest 129202 12623 5.0" 
$ns at 860.7323122564816 "$node_(291) setdest 46960 26464 4.0" 
$ns at 255.02968961279103 "$node_(292) setdest 69309 7595 1.0" 
$ns at 290.15134395492356 "$node_(292) setdest 126950 44300 8.0" 
$ns at 369.103879659304 "$node_(292) setdest 99606 19193 10.0" 
$ns at 446.41252428310827 "$node_(292) setdest 52584 33476 7.0" 
$ns at 531.2365616971367 "$node_(292) setdest 54894 2216 10.0" 
$ns at 636.0453984139118 "$node_(292) setdest 69766 1178 1.0" 
$ns at 666.1665216329286 "$node_(292) setdest 117786 35992 9.0" 
$ns at 718.4354319717888 "$node_(292) setdest 56081 13295 3.0" 
$ns at 770.3474085932149 "$node_(292) setdest 118412 36460 19.0" 
$ns at 845.1466631237379 "$node_(292) setdest 118656 29020 16.0" 
$ns at 272.4180371145044 "$node_(293) setdest 91248 40216 19.0" 
$ns at 369.49778846546997 "$node_(293) setdest 56339 23771 3.0" 
$ns at 419.441838425207 "$node_(293) setdest 103964 6745 5.0" 
$ns at 459.21054381315247 "$node_(293) setdest 99538 422 18.0" 
$ns at 603.7901003632735 "$node_(293) setdest 7150 42487 20.0" 
$ns at 713.8466848376692 "$node_(293) setdest 99786 30029 18.0" 
$ns at 868.8152136351774 "$node_(293) setdest 76009 3475 8.0" 
$ns at 270.8785722369947 "$node_(294) setdest 74632 36565 4.0" 
$ns at 304.9241334577431 "$node_(294) setdest 60530 17024 17.0" 
$ns at 394.80252145227007 "$node_(294) setdest 100104 10428 1.0" 
$ns at 434.2178245947897 "$node_(294) setdest 86186 37807 7.0" 
$ns at 517.480957074726 "$node_(294) setdest 111965 12904 5.0" 
$ns at 587.7507048014953 "$node_(294) setdest 51607 14057 13.0" 
$ns at 739.1808445446654 "$node_(294) setdest 28992 26634 5.0" 
$ns at 803.5014621554225 "$node_(294) setdest 93955 5156 7.0" 
$ns at 896.6352882350051 "$node_(294) setdest 132432 33609 5.0" 
$ns at 208.02773896996177 "$node_(295) setdest 39728 35133 8.0" 
$ns at 240.2688879776443 "$node_(295) setdest 122913 16255 17.0" 
$ns at 394.96153932760785 "$node_(295) setdest 64480 1095 18.0" 
$ns at 515.9657999121672 "$node_(295) setdest 73021 16630 4.0" 
$ns at 573.2583800397698 "$node_(295) setdest 134082 5376 19.0" 
$ns at 675.3532729085837 "$node_(295) setdest 5037 29016 17.0" 
$ns at 772.313134531844 "$node_(295) setdest 92948 6060 4.0" 
$ns at 806.9921860794901 "$node_(295) setdest 97678 350 17.0" 
$ns at 869.0944703409577 "$node_(295) setdest 36432 32476 11.0" 
$ns at 205.70610292822232 "$node_(296) setdest 38125 10618 17.0" 
$ns at 338.1242717754802 "$node_(296) setdest 103848 31028 3.0" 
$ns at 390.08524813559933 "$node_(296) setdest 128758 9059 11.0" 
$ns at 486.51231022764404 "$node_(296) setdest 62513 15144 9.0" 
$ns at 540.6283742294173 "$node_(296) setdest 905 13384 10.0" 
$ns at 666.116503837725 "$node_(296) setdest 93569 4835 17.0" 
$ns at 800.3185383939865 "$node_(296) setdest 8883 43896 5.0" 
$ns at 849.2543075746044 "$node_(296) setdest 11484 11040 7.0" 
$ns at 225.61334584728496 "$node_(297) setdest 115792 32462 1.0" 
$ns at 260.77263296788436 "$node_(297) setdest 37609 43560 1.0" 
$ns at 290.98821011166933 "$node_(297) setdest 1093 44079 7.0" 
$ns at 346.13185278895486 "$node_(297) setdest 47912 14144 11.0" 
$ns at 445.4081933980996 "$node_(297) setdest 65626 22810 16.0" 
$ns at 631.5654756668154 "$node_(297) setdest 115872 22001 1.0" 
$ns at 664.2342284845032 "$node_(297) setdest 128042 12644 1.0" 
$ns at 698.9154357342611 "$node_(297) setdest 82587 25829 17.0" 
$ns at 747.3285694965653 "$node_(297) setdest 117019 33908 19.0" 
$ns at 869.2507116655439 "$node_(297) setdest 95240 26498 6.0" 
$ns at 240.47248761607688 "$node_(298) setdest 96874 20930 11.0" 
$ns at 300.23966692180824 "$node_(298) setdest 30513 2796 19.0" 
$ns at 447.02700116815504 "$node_(298) setdest 41533 39057 2.0" 
$ns at 489.7083114564973 "$node_(298) setdest 82799 39272 9.0" 
$ns at 604.2084485128586 "$node_(298) setdest 98390 39001 6.0" 
$ns at 653.7825857422017 "$node_(298) setdest 131109 23415 1.0" 
$ns at 684.4255964205777 "$node_(298) setdest 67079 21941 15.0" 
$ns at 780.7084999779835 "$node_(298) setdest 82333 35409 1.0" 
$ns at 811.5474806200843 "$node_(298) setdest 75159 23618 10.0" 
$ns at 225.1049976943416 "$node_(299) setdest 32271 36723 11.0" 
$ns at 343.80660870378006 "$node_(299) setdest 8071 31726 10.0" 
$ns at 429.2788421570512 "$node_(299) setdest 89792 4007 8.0" 
$ns at 496.3850461975077 "$node_(299) setdest 100026 18390 12.0" 
$ns at 549.3066335777512 "$node_(299) setdest 75971 5014 16.0" 
$ns at 614.7971115590262 "$node_(299) setdest 41296 26686 2.0" 
$ns at 659.4867484813408 "$node_(299) setdest 115527 16446 18.0" 
$ns at 846.5611228968136 "$node_(299) setdest 56229 23925 15.0" 
$ns at 317.1996396531707 "$node_(300) setdest 6740 38877 12.0" 
$ns at 457.1912499858434 "$node_(300) setdest 61368 26997 14.0" 
$ns at 593.3983052087116 "$node_(300) setdest 120466 22520 10.0" 
$ns at 648.1830386980282 "$node_(300) setdest 20637 19285 3.0" 
$ns at 678.7946823950102 "$node_(300) setdest 35946 37007 10.0" 
$ns at 786.1986632330555 "$node_(300) setdest 90715 17401 3.0" 
$ns at 844.1970350247076 "$node_(300) setdest 49693 15923 3.0" 
$ns at 898.4252713542345 "$node_(300) setdest 110537 3102 8.0" 
$ns at 300.94581828814637 "$node_(301) setdest 35486 25448 12.0" 
$ns at 368.4489518176754 "$node_(301) setdest 129455 11618 5.0" 
$ns at 424.9653463765545 "$node_(301) setdest 65046 39778 11.0" 
$ns at 546.5141615473987 "$node_(301) setdest 43860 7125 17.0" 
$ns at 590.7463253615449 "$node_(301) setdest 117705 34012 13.0" 
$ns at 621.8264761204418 "$node_(301) setdest 9269 25810 13.0" 
$ns at 651.91663803015 "$node_(301) setdest 68333 8466 12.0" 
$ns at 684.5774522818604 "$node_(301) setdest 22007 12348 2.0" 
$ns at 734.2960683376255 "$node_(301) setdest 129415 18856 5.0" 
$ns at 771.5590119927122 "$node_(301) setdest 50580 17275 2.0" 
$ns at 806.7752283572477 "$node_(301) setdest 7713 5479 3.0" 
$ns at 859.0305715543411 "$node_(301) setdest 27933 30626 14.0" 
$ns at 338.80163383310736 "$node_(302) setdest 6747 2922 2.0" 
$ns at 387.6530776868818 "$node_(302) setdest 80801 17597 16.0" 
$ns at 555.1223540729936 "$node_(302) setdest 84794 25866 2.0" 
$ns at 599.4232299878176 "$node_(302) setdest 60350 4197 7.0" 
$ns at 681.0228302859787 "$node_(302) setdest 107858 3250 3.0" 
$ns at 712.1204032119576 "$node_(302) setdest 8689 23119 1.0" 
$ns at 747.6897422561128 "$node_(302) setdest 44601 13551 7.0" 
$ns at 839.9114168574625 "$node_(302) setdest 85789 35068 11.0" 
$ns at 401.61516516328896 "$node_(303) setdest 108969 12522 7.0" 
$ns at 464.41283958919644 "$node_(303) setdest 122767 35169 15.0" 
$ns at 621.986036718409 "$node_(303) setdest 131035 27673 15.0" 
$ns at 716.9057823346361 "$node_(303) setdest 5970 34602 1.0" 
$ns at 749.2960167540758 "$node_(303) setdest 121837 9943 20.0" 
$ns at 325.4490683426401 "$node_(304) setdest 20597 2891 7.0" 
$ns at 383.86457781415874 "$node_(304) setdest 65180 188 17.0" 
$ns at 446.95557024008923 "$node_(304) setdest 43733 31758 15.0" 
$ns at 574.5865828816895 "$node_(304) setdest 118224 37128 5.0" 
$ns at 634.0723056386762 "$node_(304) setdest 42297 32278 14.0" 
$ns at 735.0327410637401 "$node_(304) setdest 77773 1332 13.0" 
$ns at 772.0772182004574 "$node_(304) setdest 120054 19228 6.0" 
$ns at 838.5690207421029 "$node_(304) setdest 73262 27813 6.0" 
$ns at 888.9150174666198 "$node_(304) setdest 128986 37680 14.0" 
$ns at 457.65684592350374 "$node_(305) setdest 59271 8612 2.0" 
$ns at 495.43509153377903 "$node_(305) setdest 83531 43538 13.0" 
$ns at 646.2441864875701 "$node_(305) setdest 11302 32891 12.0" 
$ns at 682.4694361557815 "$node_(305) setdest 47363 8229 17.0" 
$ns at 852.0973583577046 "$node_(305) setdest 14576 17884 1.0" 
$ns at 891.5561253213071 "$node_(305) setdest 16264 25208 9.0" 
$ns at 326.63103564684377 "$node_(306) setdest 100538 38626 16.0" 
$ns at 508.3409400563329 "$node_(306) setdest 132009 44377 1.0" 
$ns at 540.1945881646026 "$node_(306) setdest 91247 18856 8.0" 
$ns at 589.932882591724 "$node_(306) setdest 29392 24805 4.0" 
$ns at 644.298019796408 "$node_(306) setdest 115479 31760 14.0" 
$ns at 797.8035977029451 "$node_(306) setdest 36227 1677 19.0" 
$ns at 844.9710392627178 "$node_(306) setdest 25088 37144 11.0" 
$ns at 884.9321185199485 "$node_(306) setdest 36620 39403 16.0" 
$ns at 324.2406202546352 "$node_(307) setdest 5538 15880 11.0" 
$ns at 445.0756014120113 "$node_(307) setdest 68947 17373 14.0" 
$ns at 600.7388770312994 "$node_(307) setdest 4605 40145 1.0" 
$ns at 638.1835415154886 "$node_(307) setdest 24943 33181 4.0" 
$ns at 703.7241110185024 "$node_(307) setdest 91336 6380 3.0" 
$ns at 763.2893296667426 "$node_(307) setdest 28678 2909 1.0" 
$ns at 799.7751859009735 "$node_(307) setdest 85453 32804 4.0" 
$ns at 866.6177622798051 "$node_(307) setdest 123482 20022 11.0" 
$ns at 468.3901332190446 "$node_(308) setdest 57234 29738 14.0" 
$ns at 590.7274603239898 "$node_(308) setdest 38508 43341 12.0" 
$ns at 683.3631242952764 "$node_(308) setdest 20594 9343 4.0" 
$ns at 742.893202317918 "$node_(308) setdest 125037 20073 3.0" 
$ns at 779.3129585142168 "$node_(308) setdest 1838 34312 16.0" 
$ns at 314.6207198221635 "$node_(309) setdest 27058 2066 7.0" 
$ns at 394.40022604200897 "$node_(309) setdest 4894 38098 6.0" 
$ns at 447.74934076794034 "$node_(309) setdest 91837 22646 12.0" 
$ns at 574.5968038659828 "$node_(309) setdest 103564 11702 1.0" 
$ns at 609.4963951125558 "$node_(309) setdest 18643 17723 11.0" 
$ns at 738.9010879013231 "$node_(309) setdest 29733 39616 12.0" 
$ns at 823.3636914676354 "$node_(309) setdest 62501 24104 5.0" 
$ns at 876.5103830386784 "$node_(309) setdest 1917 25949 18.0" 
$ns at 313.812450473371 "$node_(310) setdest 24782 7568 18.0" 
$ns at 394.8063853933117 "$node_(310) setdest 76284 12073 17.0" 
$ns at 457.58254248551805 "$node_(310) setdest 78581 16906 14.0" 
$ns at 574.3344082151709 "$node_(310) setdest 100522 22350 17.0" 
$ns at 687.576229005725 "$node_(310) setdest 107803 17824 20.0" 
$ns at 894.8863278175131 "$node_(310) setdest 26823 17899 1.0" 
$ns at 328.3966875796129 "$node_(311) setdest 24760 7584 19.0" 
$ns at 533.8959310441776 "$node_(311) setdest 81641 10927 8.0" 
$ns at 582.6109574562809 "$node_(311) setdest 132315 30177 5.0" 
$ns at 615.6826578142026 "$node_(311) setdest 19518 8276 7.0" 
$ns at 658.5630879059114 "$node_(311) setdest 47626 25489 4.0" 
$ns at 693.2350107969979 "$node_(311) setdest 126597 20963 7.0" 
$ns at 751.0667689846364 "$node_(311) setdest 88544 12639 15.0" 
$ns at 821.4923815863992 "$node_(311) setdest 125126 36164 6.0" 
$ns at 893.6720545305266 "$node_(311) setdest 78650 8541 4.0" 
$ns at 329.56704591134536 "$node_(312) setdest 98793 8653 19.0" 
$ns at 385.3620853082124 "$node_(312) setdest 11319 21789 2.0" 
$ns at 433.46139171092074 "$node_(312) setdest 113437 30517 19.0" 
$ns at 504.21868826921656 "$node_(312) setdest 29976 35371 13.0" 
$ns at 648.6690270492574 "$node_(312) setdest 9923 32918 1.0" 
$ns at 680.2699269494342 "$node_(312) setdest 29320 43136 3.0" 
$ns at 728.123670049246 "$node_(312) setdest 82630 24173 7.0" 
$ns at 774.7608077232575 "$node_(312) setdest 51154 37995 13.0" 
$ns at 856.7330574165557 "$node_(312) setdest 42827 26850 17.0" 
$ns at 353.5150377870366 "$node_(313) setdest 123111 36291 17.0" 
$ns at 435.13882456183467 "$node_(313) setdest 20865 10172 6.0" 
$ns at 469.4337005641187 "$node_(313) setdest 82301 12080 10.0" 
$ns at 586.6956530082205 "$node_(313) setdest 113319 11523 17.0" 
$ns at 761.4673452699419 "$node_(313) setdest 111015 21685 18.0" 
$ns at 841.6752643528387 "$node_(313) setdest 113278 924 5.0" 
$ns at 885.1868558013191 "$node_(313) setdest 17437 37152 3.0" 
$ns at 336.21050205048493 "$node_(314) setdest 72321 23164 19.0" 
$ns at 498.7319289655697 "$node_(314) setdest 82043 23096 9.0" 
$ns at 574.9252041283213 "$node_(314) setdest 101604 22099 12.0" 
$ns at 661.7219540927215 "$node_(314) setdest 106025 19837 13.0" 
$ns at 742.7460855426026 "$node_(314) setdest 44923 10809 17.0" 
$ns at 798.18809796853 "$node_(314) setdest 59878 29416 15.0" 
$ns at 896.7853392415942 "$node_(314) setdest 108249 24427 14.0" 
$ns at 302.98945070453016 "$node_(315) setdest 133391 26860 12.0" 
$ns at 376.0692523372329 "$node_(315) setdest 82532 22812 7.0" 
$ns at 428.13086297940526 "$node_(315) setdest 120189 12514 14.0" 
$ns at 578.255815957959 "$node_(315) setdest 57277 9724 3.0" 
$ns at 636.8910086308956 "$node_(315) setdest 92965 25996 3.0" 
$ns at 672.8396038647652 "$node_(315) setdest 127153 16124 16.0" 
$ns at 747.5964664809101 "$node_(315) setdest 36737 8165 17.0" 
$ns at 873.3906169894348 "$node_(315) setdest 130153 39446 11.0" 
$ns at 388.229244141202 "$node_(316) setdest 112251 17956 18.0" 
$ns at 428.85407557645 "$node_(316) setdest 128422 28119 8.0" 
$ns at 538.7780309397192 "$node_(316) setdest 45227 3517 4.0" 
$ns at 579.3911587105614 "$node_(316) setdest 23538 21286 8.0" 
$ns at 658.7176081148884 "$node_(316) setdest 40520 4182 18.0" 
$ns at 827.3361146860418 "$node_(316) setdest 106967 9535 5.0" 
$ns at 878.1885396701404 "$node_(316) setdest 86972 29067 17.0" 
$ns at 304.0906001488285 "$node_(317) setdest 55281 33535 20.0" 
$ns at 451.7169437477836 "$node_(317) setdest 112081 2390 5.0" 
$ns at 484.61118881879526 "$node_(317) setdest 38740 11656 12.0" 
$ns at 525.9554955028847 "$node_(317) setdest 11284 20698 20.0" 
$ns at 577.2625506316931 "$node_(317) setdest 17289 14597 10.0" 
$ns at 707.082244795002 "$node_(317) setdest 93227 3654 14.0" 
$ns at 768.8274956381089 "$node_(317) setdest 54214 32151 12.0" 
$ns at 819.6311218597953 "$node_(317) setdest 123816 36979 3.0" 
$ns at 863.0091622965354 "$node_(317) setdest 117752 7307 2.0" 
$ns at 354.61287650611695 "$node_(318) setdest 125992 8409 11.0" 
$ns at 452.4099358036291 "$node_(318) setdest 63049 32589 1.0" 
$ns at 491.8267726761321 "$node_(318) setdest 131912 2595 2.0" 
$ns at 532.8582292352608 "$node_(318) setdest 111241 25567 10.0" 
$ns at 628.9978430393992 "$node_(318) setdest 12247 25734 1.0" 
$ns at 662.6398802296428 "$node_(318) setdest 119236 836 1.0" 
$ns at 698.859736349248 "$node_(318) setdest 10624 33369 4.0" 
$ns at 732.576481451751 "$node_(318) setdest 108574 17134 3.0" 
$ns at 784.587353983527 "$node_(318) setdest 88525 6969 16.0" 
$ns at 815.1874921915029 "$node_(318) setdest 113021 35267 18.0" 
$ns at 335.78673243174865 "$node_(319) setdest 127598 30399 10.0" 
$ns at 443.3880089741649 "$node_(319) setdest 55816 36670 5.0" 
$ns at 518.0788596730102 "$node_(319) setdest 46192 39026 19.0" 
$ns at 616.5151020461515 "$node_(319) setdest 102497 4106 1.0" 
$ns at 653.3119834181725 "$node_(319) setdest 128303 27003 16.0" 
$ns at 699.531324391369 "$node_(319) setdest 60903 39576 15.0" 
$ns at 870.4585401479858 "$node_(319) setdest 88705 21264 1.0" 
$ns at 347.0768678865308 "$node_(320) setdest 68034 28436 15.0" 
$ns at 491.937491824238 "$node_(320) setdest 61144 694 14.0" 
$ns at 648.7231493393003 "$node_(320) setdest 34149 8304 18.0" 
$ns at 758.5247680227366 "$node_(320) setdest 10544 5026 16.0" 
$ns at 884.9406054754437 "$node_(320) setdest 30486 14495 3.0" 
$ns at 303.0622735814609 "$node_(321) setdest 37268 2828 20.0" 
$ns at 503.20965406800053 "$node_(321) setdest 123178 32519 1.0" 
$ns at 540.4415710742436 "$node_(321) setdest 105551 39595 2.0" 
$ns at 571.3044120625248 "$node_(321) setdest 103542 16671 6.0" 
$ns at 612.8222819896257 "$node_(321) setdest 105271 3096 5.0" 
$ns at 668.970918320961 "$node_(321) setdest 112404 11191 8.0" 
$ns at 747.1446527032223 "$node_(321) setdest 79467 22510 11.0" 
$ns at 885.939954577658 "$node_(321) setdest 13675 11437 11.0" 
$ns at 353.5892381046372 "$node_(322) setdest 123337 35382 3.0" 
$ns at 385.74415127583615 "$node_(322) setdest 125221 12700 1.0" 
$ns at 419.62540038770493 "$node_(322) setdest 105254 11415 15.0" 
$ns at 545.2989175108988 "$node_(322) setdest 95924 638 4.0" 
$ns at 579.1449863980765 "$node_(322) setdest 68640 4894 2.0" 
$ns at 623.5354328892515 "$node_(322) setdest 36974 19808 16.0" 
$ns at 742.6639073690682 "$node_(322) setdest 7504 14316 12.0" 
$ns at 878.3454225915723 "$node_(322) setdest 72136 30599 7.0" 
$ns at 342.87284607600054 "$node_(323) setdest 46592 37409 2.0" 
$ns at 379.874276223778 "$node_(323) setdest 132758 24871 5.0" 
$ns at 423.0255077599504 "$node_(323) setdest 58687 44336 12.0" 
$ns at 525.576502379436 "$node_(323) setdest 60618 37600 19.0" 
$ns at 635.5279068543105 "$node_(323) setdest 38557 28705 3.0" 
$ns at 688.9358033999957 "$node_(323) setdest 83805 39057 1.0" 
$ns at 722.7794555422308 "$node_(323) setdest 75948 8347 14.0" 
$ns at 787.144452294915 "$node_(323) setdest 9463 13230 16.0" 
$ns at 301.23830741895927 "$node_(324) setdest 125370 30344 10.0" 
$ns at 401.8181484237808 "$node_(324) setdest 30512 41335 20.0" 
$ns at 546.4158785248976 "$node_(324) setdest 90864 42617 4.0" 
$ns at 602.1081029819923 "$node_(324) setdest 60687 7941 11.0" 
$ns at 716.8495309473768 "$node_(324) setdest 112631 12179 13.0" 
$ns at 839.8960588230034 "$node_(324) setdest 32025 9877 19.0" 
$ns at 376.2043589012284 "$node_(325) setdest 119972 42901 14.0" 
$ns at 462.7480869743289 "$node_(325) setdest 75053 44175 8.0" 
$ns at 536.3599711601049 "$node_(325) setdest 54166 24912 1.0" 
$ns at 572.0579246350137 "$node_(325) setdest 24479 32217 3.0" 
$ns at 610.8312368619748 "$node_(325) setdest 59654 13183 17.0" 
$ns at 675.866059567435 "$node_(325) setdest 57938 15625 19.0" 
$ns at 734.2180080733394 "$node_(325) setdest 122237 23412 10.0" 
$ns at 796.7837799361049 "$node_(325) setdest 123903 21545 18.0" 
$ns at 303.07385476766154 "$node_(326) setdest 84880 20714 17.0" 
$ns at 376.6409191685782 "$node_(326) setdest 94612 31578 8.0" 
$ns at 442.73069284147806 "$node_(326) setdest 22491 39838 6.0" 
$ns at 492.8440609338064 "$node_(326) setdest 57025 39711 7.0" 
$ns at 587.4412457777662 "$node_(326) setdest 117425 14674 1.0" 
$ns at 622.0869898795111 "$node_(326) setdest 2699 28307 6.0" 
$ns at 658.3951107148486 "$node_(326) setdest 99743 31804 4.0" 
$ns at 691.6102955421566 "$node_(326) setdest 130373 37474 11.0" 
$ns at 831.6092360259366 "$node_(326) setdest 86297 3546 17.0" 
$ns at 316.97567440539433 "$node_(327) setdest 16336 37472 4.0" 
$ns at 369.5577832758652 "$node_(327) setdest 36915 7135 11.0" 
$ns at 500.0132111504952 "$node_(327) setdest 46775 34082 14.0" 
$ns at 560.2604884450691 "$node_(327) setdest 29830 29731 16.0" 
$ns at 745.768577910784 "$node_(327) setdest 33312 12497 20.0" 
$ns at 797.5303015301698 "$node_(327) setdest 52055 13685 13.0" 
$ns at 892.3677177822667 "$node_(327) setdest 100038 14328 3.0" 
$ns at 301.6799543668219 "$node_(328) setdest 7027 41427 14.0" 
$ns at 389.8070002008837 "$node_(328) setdest 46103 3800 19.0" 
$ns at 592.1732459289375 "$node_(328) setdest 82988 23777 9.0" 
$ns at 706.538339571186 "$node_(328) setdest 37193 25628 12.0" 
$ns at 822.5675501537232 "$node_(328) setdest 64943 882 3.0" 
$ns at 878.7238210804702 "$node_(328) setdest 121496 32469 15.0" 
$ns at 443.73041828833084 "$node_(329) setdest 37611 35489 19.0" 
$ns at 659.6436231625003 "$node_(329) setdest 18476 33310 7.0" 
$ns at 726.5588149909806 "$node_(329) setdest 21979 2735 16.0" 
$ns at 835.8001912999213 "$node_(329) setdest 102279 10633 4.0" 
$ns at 882.4606823362528 "$node_(329) setdest 87861 13997 7.0" 
$ns at 342.34115106984046 "$node_(330) setdest 120267 19131 10.0" 
$ns at 379.9586666598997 "$node_(330) setdest 96945 28840 9.0" 
$ns at 426.39994276187446 "$node_(330) setdest 119591 24625 19.0" 
$ns at 501.47030158989685 "$node_(330) setdest 80103 2571 1.0" 
$ns at 535.5723392281252 "$node_(330) setdest 130903 12414 17.0" 
$ns at 638.4799352482694 "$node_(330) setdest 32735 36747 7.0" 
$ns at 681.8308087505071 "$node_(330) setdest 92562 18763 12.0" 
$ns at 816.0980846000355 "$node_(330) setdest 26416 8500 10.0" 
$ns at 367.2572955500722 "$node_(331) setdest 111541 12721 9.0" 
$ns at 429.328632856847 "$node_(331) setdest 25330 23238 4.0" 
$ns at 482.0641116125012 "$node_(331) setdest 18930 35292 20.0" 
$ns at 631.8138997561043 "$node_(331) setdest 52056 40412 9.0" 
$ns at 717.0154043711764 "$node_(331) setdest 65480 18461 6.0" 
$ns at 788.6031608611875 "$node_(331) setdest 15066 7505 16.0" 
$ns at 832.4418915770792 "$node_(331) setdest 99759 20912 18.0" 
$ns at 349.62221144790885 "$node_(332) setdest 41969 39989 15.0" 
$ns at 509.69790537012744 "$node_(332) setdest 80043 44417 8.0" 
$ns at 554.0464454733092 "$node_(332) setdest 97381 5329 3.0" 
$ns at 607.9958907345518 "$node_(332) setdest 114711 27299 6.0" 
$ns at 638.1913918073935 "$node_(332) setdest 35927 14259 1.0" 
$ns at 674.1573555275821 "$node_(332) setdest 52595 7436 18.0" 
$ns at 823.4746812036279 "$node_(332) setdest 41875 40014 7.0" 
$ns at 335.98725449055223 "$node_(333) setdest 74690 1484 2.0" 
$ns at 370.68570067974844 "$node_(333) setdest 90138 3877 16.0" 
$ns at 520.2308095235035 "$node_(333) setdest 19705 4082 13.0" 
$ns at 676.4904502776836 "$node_(333) setdest 9822 40372 5.0" 
$ns at 711.7455404037373 "$node_(333) setdest 213 42407 5.0" 
$ns at 771.2947083609258 "$node_(333) setdest 61075 17571 2.0" 
$ns at 805.7554671078193 "$node_(333) setdest 126799 8373 19.0" 
$ns at 304.8624777095104 "$node_(334) setdest 104843 13012 7.0" 
$ns at 384.48671708517645 "$node_(334) setdest 100334 8308 20.0" 
$ns at 515.100458525919 "$node_(334) setdest 45264 36449 10.0" 
$ns at 556.3160271049937 "$node_(334) setdest 92894 43407 3.0" 
$ns at 604.1425569506372 "$node_(334) setdest 115117 33230 16.0" 
$ns at 714.8117576301141 "$node_(334) setdest 63952 30424 17.0" 
$ns at 785.4078363677701 "$node_(334) setdest 130626 5279 15.0" 
$ns at 856.347701518879 "$node_(334) setdest 27205 6959 6.0" 
$ns at 335.5395337070227 "$node_(335) setdest 10038 4796 10.0" 
$ns at 453.05028638840935 "$node_(335) setdest 97311 43811 9.0" 
$ns at 519.5156995605846 "$node_(335) setdest 15380 41623 20.0" 
$ns at 691.565321310075 "$node_(335) setdest 30840 13363 9.0" 
$ns at 801.6954682545426 "$node_(335) setdest 63432 11972 14.0" 
$ns at 317.56655902841175 "$node_(336) setdest 44730 7962 13.0" 
$ns at 428.27101629356355 "$node_(336) setdest 23996 33895 2.0" 
$ns at 468.31488773526485 "$node_(336) setdest 33997 6470 14.0" 
$ns at 548.9575075557538 "$node_(336) setdest 10126 197 14.0" 
$ns at 609.2278566645032 "$node_(336) setdest 90315 14383 19.0" 
$ns at 718.7425247799808 "$node_(336) setdest 108517 22502 15.0" 
$ns at 863.8953438225572 "$node_(336) setdest 79115 40446 16.0" 
$ns at 483.81239533685596 "$node_(337) setdest 61828 9549 13.0" 
$ns at 583.7125943108947 "$node_(337) setdest 11037 28521 20.0" 
$ns at 667.9888105999506 "$node_(337) setdest 33985 952 16.0" 
$ns at 706.3775132075234 "$node_(337) setdest 8794 5131 16.0" 
$ns at 811.692036211552 "$node_(337) setdest 99080 23134 4.0" 
$ns at 846.4838153396333 "$node_(337) setdest 82851 18994 1.0" 
$ns at 883.5891649351857 "$node_(337) setdest 128371 29906 7.0" 
$ns at 344.0565213143429 "$node_(338) setdest 129180 3261 13.0" 
$ns at 438.953244957717 "$node_(338) setdest 76345 3453 10.0" 
$ns at 540.6104224920679 "$node_(338) setdest 89660 38931 11.0" 
$ns at 576.1486657268767 "$node_(338) setdest 76083 30164 18.0" 
$ns at 641.7364527862119 "$node_(338) setdest 30539 2774 1.0" 
$ns at 671.8391822729691 "$node_(338) setdest 102596 41046 18.0" 
$ns at 872.7802438749246 "$node_(338) setdest 68950 18301 14.0" 
$ns at 354.99496905099386 "$node_(339) setdest 31039 30998 6.0" 
$ns at 391.6275365718409 "$node_(339) setdest 15340 5108 6.0" 
$ns at 457.3517768250614 "$node_(339) setdest 21907 13029 9.0" 
$ns at 508.8782790611025 "$node_(339) setdest 78798 7738 14.0" 
$ns at 560.3083774517453 "$node_(339) setdest 86752 6927 7.0" 
$ns at 597.118047923416 "$node_(339) setdest 25402 28069 3.0" 
$ns at 653.9662116438557 "$node_(339) setdest 84398 42809 13.0" 
$ns at 753.0459194576507 "$node_(339) setdest 65761 26229 13.0" 
$ns at 796.8871942149599 "$node_(339) setdest 35352 42185 13.0" 
$ns at 892.8953782888649 "$node_(339) setdest 44958 22126 5.0" 
$ns at 338.19583040772795 "$node_(340) setdest 51323 13054 7.0" 
$ns at 415.8349904230339 "$node_(340) setdest 66930 10773 10.0" 
$ns at 462.2934187077597 "$node_(340) setdest 28802 31230 17.0" 
$ns at 585.7590167645752 "$node_(340) setdest 75720 20957 11.0" 
$ns at 683.3015281168167 "$node_(340) setdest 13621 12061 19.0" 
$ns at 786.1536438299511 "$node_(340) setdest 24246 25528 10.0" 
$ns at 827.458663391642 "$node_(340) setdest 125614 1318 14.0" 
$ns at 879.6087027194494 "$node_(340) setdest 89008 41091 13.0" 
$ns at 301.5731753093976 "$node_(341) setdest 125963 40007 7.0" 
$ns at 388.7341923937255 "$node_(341) setdest 121619 4026 17.0" 
$ns at 581.4839300247509 "$node_(341) setdest 128544 5988 2.0" 
$ns at 630.2203205280543 "$node_(341) setdest 129355 39874 8.0" 
$ns at 714.2042427022279 "$node_(341) setdest 76223 11003 9.0" 
$ns at 757.2150626635505 "$node_(341) setdest 30446 684 15.0" 
$ns at 867.1634037363128 "$node_(341) setdest 120621 22598 11.0" 
$ns at 329.85135846702616 "$node_(342) setdest 49361 18646 4.0" 
$ns at 361.1565447224912 "$node_(342) setdest 336 27267 16.0" 
$ns at 442.65220545579535 "$node_(342) setdest 31373 16737 14.0" 
$ns at 503.12419046601235 "$node_(342) setdest 69093 14683 17.0" 
$ns at 622.3782050862326 "$node_(342) setdest 16186 21554 4.0" 
$ns at 657.4662812726305 "$node_(342) setdest 97423 32766 5.0" 
$ns at 695.382357228893 "$node_(342) setdest 39012 13777 13.0" 
$ns at 725.5103183868646 "$node_(342) setdest 79287 9442 17.0" 
$ns at 883.3655464042324 "$node_(342) setdest 78090 30789 15.0" 
$ns at 374.84733343298944 "$node_(343) setdest 125048 8170 2.0" 
$ns at 421.1209048402669 "$node_(343) setdest 24284 15915 15.0" 
$ns at 459.23815339685103 "$node_(343) setdest 117104 130 9.0" 
$ns at 521.7760802699509 "$node_(343) setdest 90521 2362 6.0" 
$ns at 608.5525669926569 "$node_(343) setdest 30905 9252 20.0" 
$ns at 739.5023496653107 "$node_(343) setdest 74678 33482 15.0" 
$ns at 807.94700975923 "$node_(343) setdest 32853 3538 6.0" 
$ns at 840.8929811948624 "$node_(343) setdest 83448 41743 17.0" 
$ns at 317.15491969763195 "$node_(344) setdest 30444 9731 17.0" 
$ns at 465.27012621164266 "$node_(344) setdest 120244 26009 6.0" 
$ns at 553.8207892585328 "$node_(344) setdest 41223 14174 3.0" 
$ns at 588.3213363622764 "$node_(344) setdest 79196 29674 20.0" 
$ns at 753.4939377028395 "$node_(344) setdest 119127 32685 4.0" 
$ns at 794.4150559047855 "$node_(344) setdest 59859 207 13.0" 
$ns at 325.95134024829844 "$node_(345) setdest 2035 8403 9.0" 
$ns at 387.07315972085536 "$node_(345) setdest 99567 17113 5.0" 
$ns at 424.459667451247 "$node_(345) setdest 6249 5427 15.0" 
$ns at 517.6467769204088 "$node_(345) setdest 15572 2685 2.0" 
$ns at 562.805897429138 "$node_(345) setdest 110215 11226 13.0" 
$ns at 660.8080216832901 "$node_(345) setdest 61912 5828 19.0" 
$ns at 764.6566832182359 "$node_(345) setdest 73005 32007 6.0" 
$ns at 831.9177444881475 "$node_(345) setdest 126336 19775 2.0" 
$ns at 878.7378051849639 "$node_(345) setdest 132959 30575 5.0" 
$ns at 337.3526856523782 "$node_(346) setdest 30512 27357 15.0" 
$ns at 456.1183703467443 "$node_(346) setdest 19969 43865 15.0" 
$ns at 624.2488028311171 "$node_(346) setdest 108975 12581 15.0" 
$ns at 708.864522527896 "$node_(346) setdest 77812 22917 17.0" 
$ns at 776.41098036192 "$node_(346) setdest 106298 35531 7.0" 
$ns at 835.1224318679631 "$node_(346) setdest 2264 23352 6.0" 
$ns at 899.4090884813838 "$node_(346) setdest 72269 21794 19.0" 
$ns at 361.558272505564 "$node_(347) setdest 7727 10348 1.0" 
$ns at 392.0173463866009 "$node_(347) setdest 130731 4537 18.0" 
$ns at 481.31166713913103 "$node_(347) setdest 105319 6183 15.0" 
$ns at 655.628327209295 "$node_(347) setdest 130450 22412 5.0" 
$ns at 719.4319580617232 "$node_(347) setdest 43367 43404 20.0" 
$ns at 362.01084838702803 "$node_(348) setdest 121652 35452 11.0" 
$ns at 474.0187851020279 "$node_(348) setdest 14220 12318 4.0" 
$ns at 504.64607668767144 "$node_(348) setdest 110885 12642 20.0" 
$ns at 550.9220889481711 "$node_(348) setdest 107615 27416 12.0" 
$ns at 692.4911849926923 "$node_(348) setdest 12483 11853 3.0" 
$ns at 741.3552352898852 "$node_(348) setdest 3031 24349 15.0" 
$ns at 785.2972044530926 "$node_(348) setdest 4086 18913 8.0" 
$ns at 856.3793803695194 "$node_(348) setdest 23178 26990 17.0" 
$ns at 322.5525274422566 "$node_(349) setdest 30768 27180 16.0" 
$ns at 429.15210418132244 "$node_(349) setdest 82568 31683 1.0" 
$ns at 463.8813687446565 "$node_(349) setdest 103920 41713 10.0" 
$ns at 546.8618427774771 "$node_(349) setdest 25624 28759 6.0" 
$ns at 595.8782435478621 "$node_(349) setdest 115279 11025 18.0" 
$ns at 739.4690532053728 "$node_(349) setdest 3438 23005 4.0" 
$ns at 775.2575556914318 "$node_(349) setdest 127145 43844 12.0" 
$ns at 893.0625825984936 "$node_(349) setdest 18562 8343 11.0" 
$ns at 322.4092104813901 "$node_(350) setdest 49886 25188 17.0" 
$ns at 473.868498721896 "$node_(350) setdest 84446 6853 12.0" 
$ns at 525.6885587121402 "$node_(350) setdest 103990 24107 1.0" 
$ns at 560.2360393758804 "$node_(350) setdest 61184 11428 15.0" 
$ns at 642.3642452013974 "$node_(350) setdest 108208 7897 3.0" 
$ns at 687.0804687015717 "$node_(350) setdest 8569 17819 1.0" 
$ns at 722.4934708828338 "$node_(350) setdest 121595 13714 4.0" 
$ns at 784.3482550782442 "$node_(350) setdest 38686 44670 19.0" 
$ns at 346.240101932991 "$node_(351) setdest 70940 41207 20.0" 
$ns at 514.8032449260409 "$node_(351) setdest 34022 17854 3.0" 
$ns at 556.0498393222335 "$node_(351) setdest 22897 6169 13.0" 
$ns at 648.9059575638873 "$node_(351) setdest 21212 40721 5.0" 
$ns at 702.209354188039 "$node_(351) setdest 71135 21463 1.0" 
$ns at 742.1855089281582 "$node_(351) setdest 113083 16296 13.0" 
$ns at 830.9054603740241 "$node_(351) setdest 77558 21053 3.0" 
$ns at 873.5761908482609 "$node_(351) setdest 39099 29903 14.0" 
$ns at 340.64383949873144 "$node_(352) setdest 128206 2186 1.0" 
$ns at 375.037691109965 "$node_(352) setdest 60367 40127 7.0" 
$ns at 422.4954101867775 "$node_(352) setdest 3265 43407 1.0" 
$ns at 452.59429798106123 "$node_(352) setdest 72579 14846 18.0" 
$ns at 614.6339372860205 "$node_(352) setdest 87556 41508 9.0" 
$ns at 686.1887740560364 "$node_(352) setdest 5244 27864 9.0" 
$ns at 739.3624855728264 "$node_(352) setdest 3473 37399 3.0" 
$ns at 785.6684192518604 "$node_(352) setdest 108649 32641 16.0" 
$ns at 858.6565321794891 "$node_(352) setdest 34482 349 17.0" 
$ns at 312.69890552318054 "$node_(353) setdest 37159 43357 4.0" 
$ns at 373.13342540907433 "$node_(353) setdest 105173 19992 13.0" 
$ns at 421.31234315604036 "$node_(353) setdest 73314 38585 3.0" 
$ns at 456.91456530047105 "$node_(353) setdest 126039 8488 7.0" 
$ns at 505.38939385745624 "$node_(353) setdest 57216 24927 15.0" 
$ns at 640.4343904897283 "$node_(353) setdest 12680 29336 16.0" 
$ns at 754.2884538967239 "$node_(353) setdest 56180 13269 1.0" 
$ns at 789.6898941901452 "$node_(353) setdest 30585 36022 1.0" 
$ns at 819.8900883208545 "$node_(353) setdest 90481 40120 8.0" 
$ns at 885.2464329558662 "$node_(353) setdest 33626 13302 3.0" 
$ns at 301.0032107877728 "$node_(354) setdest 32290 1472 19.0" 
$ns at 445.62067077688414 "$node_(354) setdest 23146 42680 19.0" 
$ns at 647.4123393563323 "$node_(354) setdest 74329 21941 8.0" 
$ns at 683.9822396247584 "$node_(354) setdest 85851 33582 17.0" 
$ns at 724.2432625498452 "$node_(354) setdest 87514 35899 18.0" 
$ns at 361.10190373541246 "$node_(355) setdest 86143 29753 3.0" 
$ns at 397.6014280540754 "$node_(355) setdest 87665 33500 17.0" 
$ns at 444.0258923969149 "$node_(355) setdest 5855 2088 2.0" 
$ns at 489.2319916150018 "$node_(355) setdest 45124 35089 15.0" 
$ns at 558.4234689099036 "$node_(355) setdest 106633 12334 18.0" 
$ns at 646.9064408465606 "$node_(355) setdest 55515 19780 2.0" 
$ns at 690.1243525260434 "$node_(355) setdest 91924 31325 5.0" 
$ns at 732.6881600943914 "$node_(355) setdest 6504 5956 7.0" 
$ns at 783.6252633638131 "$node_(355) setdest 15324 41766 18.0" 
$ns at 865.0621425361592 "$node_(355) setdest 44351 36796 19.0" 
$ns at 364.6722961287203 "$node_(356) setdest 40375 18386 6.0" 
$ns at 407.34725628164983 "$node_(356) setdest 87877 44677 13.0" 
$ns at 439.41212532523025 "$node_(356) setdest 33315 17571 5.0" 
$ns at 476.05839652711194 "$node_(356) setdest 80945 36877 18.0" 
$ns at 519.2980157304469 "$node_(356) setdest 118340 16957 14.0" 
$ns at 577.8447639648567 "$node_(356) setdest 13593 42835 16.0" 
$ns at 759.0044559406363 "$node_(356) setdest 25585 14588 20.0" 
$ns at 869.3173871994675 "$node_(356) setdest 15041 43484 11.0" 
$ns at 375.2666489477536 "$node_(357) setdest 70056 42546 17.0" 
$ns at 459.1261691274656 "$node_(357) setdest 46153 15240 4.0" 
$ns at 510.7942269336785 "$node_(357) setdest 40131 4543 14.0" 
$ns at 679.0184370460493 "$node_(357) setdest 7992 25643 14.0" 
$ns at 745.4173608090239 "$node_(357) setdest 120893 21097 8.0" 
$ns at 781.8977978425368 "$node_(357) setdest 9242 12622 17.0" 
$ns at 899.9180971235206 "$node_(357) setdest 112532 19301 9.0" 
$ns at 367.23306640956787 "$node_(358) setdest 103478 42803 11.0" 
$ns at 473.6412138849497 "$node_(358) setdest 3050 37409 14.0" 
$ns at 529.0125948898939 "$node_(358) setdest 78577 17404 9.0" 
$ns at 600.9485643005158 "$node_(358) setdest 131279 28839 12.0" 
$ns at 634.3270079725452 "$node_(358) setdest 64762 29099 1.0" 
$ns at 671.9639056730042 "$node_(358) setdest 34394 8639 13.0" 
$ns at 818.8389529829767 "$node_(358) setdest 38117 4272 11.0" 
$ns at 343.6502357527296 "$node_(359) setdest 8888 20513 9.0" 
$ns at 439.4874284683181 "$node_(359) setdest 41225 7339 12.0" 
$ns at 552.5351212555956 "$node_(359) setdest 114638 40476 1.0" 
$ns at 591.0790375196597 "$node_(359) setdest 6040 27947 14.0" 
$ns at 711.6809798306614 "$node_(359) setdest 69463 31900 18.0" 
$ns at 311.2844342471513 "$node_(360) setdest 86036 26603 1.0" 
$ns at 349.6730099058198 "$node_(360) setdest 128270 12596 7.0" 
$ns at 444.30870018055 "$node_(360) setdest 20150 25843 15.0" 
$ns at 483.9587850710068 "$node_(360) setdest 34615 14350 6.0" 
$ns at 560.5076788248588 "$node_(360) setdest 11826 15529 6.0" 
$ns at 623.9356558929428 "$node_(360) setdest 110336 44690 10.0" 
$ns at 659.4485309159041 "$node_(360) setdest 47462 23374 17.0" 
$ns at 711.9384170314797 "$node_(360) setdest 106954 28514 17.0" 
$ns at 889.6287452169868 "$node_(360) setdest 100899 15498 17.0" 
$ns at 392.79965995128515 "$node_(361) setdest 51726 23292 1.0" 
$ns at 431.3185966741439 "$node_(361) setdest 59632 42709 10.0" 
$ns at 532.0419895267555 "$node_(361) setdest 41860 24998 16.0" 
$ns at 702.3509978140095 "$node_(361) setdest 84698 2812 12.0" 
$ns at 763.4543150707407 "$node_(361) setdest 30795 18027 13.0" 
$ns at 354.00969119858365 "$node_(362) setdest 119598 13185 17.0" 
$ns at 432.5060938978155 "$node_(362) setdest 14894 27729 1.0" 
$ns at 467.9252395946405 "$node_(362) setdest 57734 28744 9.0" 
$ns at 519.1118860841209 "$node_(362) setdest 70809 11334 14.0" 
$ns at 570.3594173539908 "$node_(362) setdest 8763 24691 9.0" 
$ns at 664.098830189186 "$node_(362) setdest 133400 25615 9.0" 
$ns at 724.5305934834079 "$node_(362) setdest 55663 34246 14.0" 
$ns at 836.0715557397631 "$node_(362) setdest 5274 14568 14.0" 
$ns at 342.2649086818596 "$node_(363) setdest 82544 20098 8.0" 
$ns at 380.40997055833134 "$node_(363) setdest 8609 18208 20.0" 
$ns at 594.0966855944648 "$node_(363) setdest 31938 31401 18.0" 
$ns at 752.5407733236731 "$node_(363) setdest 34979 28927 15.0" 
$ns at 879.2122024472507 "$node_(363) setdest 82084 4745 3.0" 
$ns at 418.62385314169114 "$node_(364) setdest 101004 25513 11.0" 
$ns at 499.44925902882153 "$node_(364) setdest 27273 40594 18.0" 
$ns at 703.1603901868293 "$node_(364) setdest 114919 6821 1.0" 
$ns at 742.7578414971017 "$node_(364) setdest 71282 30879 11.0" 
$ns at 851.0814489599677 "$node_(364) setdest 64412 1357 20.0" 
$ns at 389.9226306337273 "$node_(365) setdest 103845 24719 4.0" 
$ns at 426.1003413844127 "$node_(365) setdest 9717 35740 13.0" 
$ns at 563.5285872508574 "$node_(365) setdest 5035 1401 10.0" 
$ns at 624.726453456553 "$node_(365) setdest 36247 30529 17.0" 
$ns at 779.6013174967102 "$node_(365) setdest 68065 29071 14.0" 
$ns at 348.1116874069128 "$node_(366) setdest 80695 38703 7.0" 
$ns at 444.9577917378019 "$node_(366) setdest 3398 16042 20.0" 
$ns at 483.31662065097277 "$node_(366) setdest 91819 43014 6.0" 
$ns at 547.7329462978772 "$node_(366) setdest 54677 29582 11.0" 
$ns at 633.3926167306888 "$node_(366) setdest 126162 18966 18.0" 
$ns at 744.426730452884 "$node_(366) setdest 121881 11195 13.0" 
$ns at 825.2270182062394 "$node_(366) setdest 80671 16754 1.0" 
$ns at 862.0152400184821 "$node_(366) setdest 78225 26141 1.0" 
$ns at 895.1720597210663 "$node_(366) setdest 117595 33753 11.0" 
$ns at 322.7830773938738 "$node_(367) setdest 122063 35403 20.0" 
$ns at 548.2244208823521 "$node_(367) setdest 101995 38678 12.0" 
$ns at 679.7059895235919 "$node_(367) setdest 59458 35376 17.0" 
$ns at 712.7103106220302 "$node_(367) setdest 81100 2008 20.0" 
$ns at 890.3764869692149 "$node_(367) setdest 95045 24411 16.0" 
$ns at 323.191241581581 "$node_(368) setdest 115080 33127 18.0" 
$ns at 517.0097854532082 "$node_(368) setdest 18714 22019 15.0" 
$ns at 661.9674782381558 "$node_(368) setdest 87534 20216 1.0" 
$ns at 698.0514098731317 "$node_(368) setdest 76622 21058 1.0" 
$ns at 728.8083192499802 "$node_(368) setdest 89205 4798 4.0" 
$ns at 777.8301850175795 "$node_(368) setdest 54273 30246 7.0" 
$ns at 858.0034668312778 "$node_(368) setdest 73109 42215 17.0" 
$ns at 314.1060476877143 "$node_(369) setdest 13690 43640 2.0" 
$ns at 357.57944304291726 "$node_(369) setdest 99093 34734 18.0" 
$ns at 471.0398898822681 "$node_(369) setdest 112904 34916 6.0" 
$ns at 553.7990854670546 "$node_(369) setdest 84936 37747 19.0" 
$ns at 664.5353513369671 "$node_(369) setdest 118915 2193 19.0" 
$ns at 768.4227670704279 "$node_(369) setdest 71367 32144 6.0" 
$ns at 841.5996792195169 "$node_(369) setdest 5080 7468 6.0" 
$ns at 341.5111300628149 "$node_(370) setdest 91271 11514 5.0" 
$ns at 373.29469788137555 "$node_(370) setdest 115015 33082 1.0" 
$ns at 405.206745513675 "$node_(370) setdest 46168 2561 15.0" 
$ns at 560.0938942987797 "$node_(370) setdest 46295 20921 9.0" 
$ns at 655.2961838585152 "$node_(370) setdest 60807 44257 7.0" 
$ns at 733.4033107550107 "$node_(370) setdest 88871 15765 18.0" 
$ns at 325.6275191347999 "$node_(371) setdest 89976 27549 16.0" 
$ns at 507.5150804443524 "$node_(371) setdest 114904 22280 12.0" 
$ns at 621.501488529804 "$node_(371) setdest 107048 34676 2.0" 
$ns at 658.9928678170509 "$node_(371) setdest 56260 30139 1.0" 
$ns at 692.4989056370721 "$node_(371) setdest 119616 15152 12.0" 
$ns at 788.7396001953437 "$node_(371) setdest 100692 36727 16.0" 
$ns at 348.5746397838713 "$node_(372) setdest 16614 31802 8.0" 
$ns at 453.6760282916707 "$node_(372) setdest 116144 20664 19.0" 
$ns at 546.200957242014 "$node_(372) setdest 104994 42532 5.0" 
$ns at 617.786299117317 "$node_(372) setdest 93073 42342 15.0" 
$ns at 727.3459621537704 "$node_(372) setdest 2337 38277 18.0" 
$ns at 862.2215738619191 "$node_(372) setdest 37517 26315 10.0" 
$ns at 367.93581036402065 "$node_(373) setdest 66979 4961 11.0" 
$ns at 467.94177899571457 "$node_(373) setdest 26586 27852 7.0" 
$ns at 528.3448320022101 "$node_(373) setdest 95361 164 6.0" 
$ns at 614.4495584663837 "$node_(373) setdest 100149 28076 5.0" 
$ns at 679.8395269870811 "$node_(373) setdest 30928 32596 1.0" 
$ns at 718.2385529337499 "$node_(373) setdest 33701 30810 16.0" 
$ns at 785.1565753856102 "$node_(373) setdest 80415 33806 14.0" 
$ns at 885.7496023633837 "$node_(373) setdest 121259 33696 13.0" 
$ns at 329.5875831213164 "$node_(374) setdest 28403 290 13.0" 
$ns at 469.4396227649328 "$node_(374) setdest 118095 24021 11.0" 
$ns at 566.9036714532954 "$node_(374) setdest 5294 1710 15.0" 
$ns at 644.6522240408808 "$node_(374) setdest 8093 34840 18.0" 
$ns at 721.5809063870603 "$node_(374) setdest 54206 38413 17.0" 
$ns at 891.0256896886434 "$node_(374) setdest 88474 12950 15.0" 
$ns at 315.48701946330783 "$node_(375) setdest 44704 37570 7.0" 
$ns at 401.1969941309527 "$node_(375) setdest 127688 19602 8.0" 
$ns at 505.2575700745715 "$node_(375) setdest 109757 33340 1.0" 
$ns at 539.562341825925 "$node_(375) setdest 74411 15652 14.0" 
$ns at 690.6627259822676 "$node_(375) setdest 31425 40106 12.0" 
$ns at 763.6818163507542 "$node_(375) setdest 99030 22320 15.0" 
$ns at 835.0192428036892 "$node_(375) setdest 9771 27354 18.0" 
$ns at 308.42763374499594 "$node_(376) setdest 26299 41840 14.0" 
$ns at 436.67803275768205 "$node_(376) setdest 67795 34787 1.0" 
$ns at 469.60546535373936 "$node_(376) setdest 64418 3355 12.0" 
$ns at 545.8913492959225 "$node_(376) setdest 94715 7365 9.0" 
$ns at 654.1019485150675 "$node_(376) setdest 129759 40336 5.0" 
$ns at 697.0179822844942 "$node_(376) setdest 121470 19468 6.0" 
$ns at 737.3269553589143 "$node_(376) setdest 129545 41650 6.0" 
$ns at 808.3210666594872 "$node_(376) setdest 56846 38803 11.0" 
$ns at 844.7709738221176 "$node_(376) setdest 96163 36891 1.0" 
$ns at 878.7204333528915 "$node_(376) setdest 17242 30078 18.0" 
$ns at 340.1894334714747 "$node_(377) setdest 111150 86 15.0" 
$ns at 497.3978906692798 "$node_(377) setdest 105579 32100 13.0" 
$ns at 656.6754697054187 "$node_(377) setdest 67219 10788 3.0" 
$ns at 701.1046886664553 "$node_(377) setdest 132173 16762 3.0" 
$ns at 745.9259490827949 "$node_(377) setdest 42545 3657 10.0" 
$ns at 869.3759198586687 "$node_(377) setdest 75405 25693 15.0" 
$ns at 335.6178777896063 "$node_(378) setdest 58707 42970 20.0" 
$ns at 558.5429330831928 "$node_(378) setdest 28170 6315 10.0" 
$ns at 600.3357253301664 "$node_(378) setdest 80331 6639 10.0" 
$ns at 679.941568180079 "$node_(378) setdest 21313 6987 5.0" 
$ns at 725.5805723161969 "$node_(378) setdest 81891 18778 1.0" 
$ns at 760.4876074324973 "$node_(378) setdest 10432 39911 7.0" 
$ns at 842.4690028175319 "$node_(378) setdest 94478 16396 11.0" 
$ns at 331.92123952834936 "$node_(379) setdest 63877 17328 4.0" 
$ns at 363.99898419664447 "$node_(379) setdest 123429 38385 13.0" 
$ns at 522.4287412197713 "$node_(379) setdest 85712 34658 5.0" 
$ns at 562.4352028696735 "$node_(379) setdest 79752 16493 17.0" 
$ns at 676.6274152758588 "$node_(379) setdest 104885 17362 16.0" 
$ns at 789.8958009865364 "$node_(379) setdest 91622 23184 3.0" 
$ns at 822.8515338646948 "$node_(379) setdest 83235 36190 6.0" 
$ns at 873.5344911289767 "$node_(379) setdest 61669 1604 14.0" 
$ns at 370.73798663075763 "$node_(380) setdest 62310 30547 1.0" 
$ns at 404.42065520055866 "$node_(380) setdest 93458 23719 11.0" 
$ns at 445.13952792121887 "$node_(380) setdest 35317 4762 14.0" 
$ns at 508.70364537078166 "$node_(380) setdest 41763 21631 3.0" 
$ns at 559.6821594457126 "$node_(380) setdest 125618 9734 6.0" 
$ns at 624.1867382575938 "$node_(380) setdest 60332 34252 8.0" 
$ns at 711.6047966405018 "$node_(380) setdest 123618 14442 11.0" 
$ns at 769.067170047038 "$node_(380) setdest 70633 35862 3.0" 
$ns at 811.4804502396297 "$node_(380) setdest 20178 22434 18.0" 
$ns at 365.07085317963214 "$node_(381) setdest 120821 13046 14.0" 
$ns at 411.36448759070134 "$node_(381) setdest 67627 13287 15.0" 
$ns at 541.2387626600535 "$node_(381) setdest 99914 27559 20.0" 
$ns at 681.9237263410756 "$node_(381) setdest 102988 31449 5.0" 
$ns at 746.6362852968607 "$node_(381) setdest 101535 2555 3.0" 
$ns at 792.1406418951307 "$node_(381) setdest 16807 20660 3.0" 
$ns at 829.4084672268145 "$node_(381) setdest 78630 18068 18.0" 
$ns at 440.6999024320629 "$node_(382) setdest 96062 39512 11.0" 
$ns at 495.5474441342328 "$node_(382) setdest 14970 16107 4.0" 
$ns at 561.6371582164975 "$node_(382) setdest 10520 42144 15.0" 
$ns at 612.4713166264479 "$node_(382) setdest 113493 38552 12.0" 
$ns at 736.0157788418542 "$node_(382) setdest 87268 18796 13.0" 
$ns at 784.2492230312374 "$node_(382) setdest 113984 8719 5.0" 
$ns at 822.0171927226774 "$node_(382) setdest 66055 44545 2.0" 
$ns at 869.0185182723928 "$node_(382) setdest 47 28111 11.0" 
$ns at 358.12497294629225 "$node_(383) setdest 102256 24322 15.0" 
$ns at 473.5594694282436 "$node_(383) setdest 74689 29530 11.0" 
$ns at 583.4120264628201 "$node_(383) setdest 129955 35903 9.0" 
$ns at 680.0811356724533 "$node_(383) setdest 114733 15572 1.0" 
$ns at 713.701843442657 "$node_(383) setdest 22253 43601 19.0" 
$ns at 888.3294773063768 "$node_(383) setdest 64820 39429 2.0" 
$ns at 327.7868150744654 "$node_(384) setdest 98482 1327 3.0" 
$ns at 362.04562900930557 "$node_(384) setdest 44455 44275 2.0" 
$ns at 394.1029472439701 "$node_(384) setdest 82402 21077 10.0" 
$ns at 426.30334751734 "$node_(384) setdest 15153 42242 7.0" 
$ns at 458.2929513807495 "$node_(384) setdest 14250 3419 11.0" 
$ns at 554.1019193294351 "$node_(384) setdest 77180 33569 15.0" 
$ns at 657.8869265024766 "$node_(384) setdest 83692 9479 8.0" 
$ns at 723.9912386610457 "$node_(384) setdest 118797 20003 16.0" 
$ns at 764.1574612487902 "$node_(384) setdest 91312 24149 15.0" 
$ns at 872.3829792897939 "$node_(384) setdest 44223 571 17.0" 
$ns at 409.83401778446876 "$node_(385) setdest 40311 36336 16.0" 
$ns at 581.9910964407544 "$node_(385) setdest 37602 31709 12.0" 
$ns at 705.4134178368975 "$node_(385) setdest 116516 5522 3.0" 
$ns at 751.3033641166509 "$node_(385) setdest 53515 14795 9.0" 
$ns at 797.8074315271103 "$node_(385) setdest 129917 32932 10.0" 
$ns at 858.6218981670095 "$node_(385) setdest 10965 24397 20.0" 
$ns at 316.87620238821876 "$node_(386) setdest 59813 14006 17.0" 
$ns at 358.4088100050437 "$node_(386) setdest 26593 44316 7.0" 
$ns at 442.1998858790053 "$node_(386) setdest 80971 3035 4.0" 
$ns at 493.1296395160261 "$node_(386) setdest 9651 28159 16.0" 
$ns at 639.7361494837784 "$node_(386) setdest 12684 30008 2.0" 
$ns at 672.8113089149304 "$node_(386) setdest 17355 29616 11.0" 
$ns at 765.7447403445568 "$node_(386) setdest 129880 21137 14.0" 
$ns at 863.7508447654848 "$node_(386) setdest 52351 4622 10.0" 
$ns at 339.55523379748087 "$node_(387) setdest 77302 24902 7.0" 
$ns at 428.1081169031745 "$node_(387) setdest 65135 6850 2.0" 
$ns at 470.2307710152304 "$node_(387) setdest 62045 22161 2.0" 
$ns at 503.34607392488147 "$node_(387) setdest 67058 4308 5.0" 
$ns at 544.9971615529839 "$node_(387) setdest 109488 22873 17.0" 
$ns at 702.4152255253186 "$node_(387) setdest 13257 19062 4.0" 
$ns at 752.3361449945031 "$node_(387) setdest 102105 6981 2.0" 
$ns at 802.0228298269765 "$node_(387) setdest 110766 41061 8.0" 
$ns at 842.4496599127787 "$node_(387) setdest 68510 36661 10.0" 
$ns at 352.7368538146034 "$node_(388) setdest 122444 28599 13.0" 
$ns at 414.38805641356737 "$node_(388) setdest 95321 23596 12.0" 
$ns at 493.55781542634253 "$node_(388) setdest 92251 7079 8.0" 
$ns at 533.9840445422207 "$node_(388) setdest 115040 34849 10.0" 
$ns at 649.4634068783729 "$node_(388) setdest 118172 40556 2.0" 
$ns at 691.2459142587794 "$node_(388) setdest 123043 33057 4.0" 
$ns at 757.1615056301855 "$node_(388) setdest 53375 16920 11.0" 
$ns at 838.9549655344942 "$node_(388) setdest 131255 3864 14.0" 
$ns at 329.810164799751 "$node_(389) setdest 13940 3045 20.0" 
$ns at 437.67507672100186 "$node_(389) setdest 81113 1096 16.0" 
$ns at 515.3210746141253 "$node_(389) setdest 95911 20368 1.0" 
$ns at 553.1008609341657 "$node_(389) setdest 6973 3817 3.0" 
$ns at 611.3222259433712 "$node_(389) setdest 93529 13383 12.0" 
$ns at 699.8278088277598 "$node_(389) setdest 128001 29801 11.0" 
$ns at 781.2645165513514 "$node_(389) setdest 29052 17510 9.0" 
$ns at 820.2932773727678 "$node_(389) setdest 67031 30973 18.0" 
$ns at 386.39362606790166 "$node_(390) setdest 16383 24221 12.0" 
$ns at 448.36507428909596 "$node_(390) setdest 55229 41664 12.0" 
$ns at 528.3480777742236 "$node_(390) setdest 22394 23439 17.0" 
$ns at 645.3125722883293 "$node_(390) setdest 105453 24734 16.0" 
$ns at 698.5220894081837 "$node_(390) setdest 46839 7921 18.0" 
$ns at 781.8467252671456 "$node_(390) setdest 120175 26468 13.0" 
$ns at 882.2028983081997 "$node_(390) setdest 26111 24252 2.0" 
$ns at 351.2076269434772 "$node_(391) setdest 101410 31834 16.0" 
$ns at 533.2395050505997 "$node_(391) setdest 56410 18199 11.0" 
$ns at 612.1702349889582 "$node_(391) setdest 16547 6619 1.0" 
$ns at 651.9469545717059 "$node_(391) setdest 41705 3091 5.0" 
$ns at 695.8580913443434 "$node_(391) setdest 119761 17234 2.0" 
$ns at 742.7682098576267 "$node_(391) setdest 1184 14263 15.0" 
$ns at 895.0667663531765 "$node_(391) setdest 17006 21298 3.0" 
$ns at 397.3052588109554 "$node_(392) setdest 117421 43631 18.0" 
$ns at 449.28743523484405 "$node_(392) setdest 79282 24597 16.0" 
$ns at 546.1438581853874 "$node_(392) setdest 105173 34408 4.0" 
$ns at 589.6804124426533 "$node_(392) setdest 22255 19019 1.0" 
$ns at 622.6631766768722 "$node_(392) setdest 28476 16271 8.0" 
$ns at 661.1226752295325 "$node_(392) setdest 97845 11739 2.0" 
$ns at 697.9997467054257 "$node_(392) setdest 119608 35146 9.0" 
$ns at 765.2758197682011 "$node_(392) setdest 121750 21844 5.0" 
$ns at 805.2381054907814 "$node_(392) setdest 40952 35624 12.0" 
$ns at 891.4267860494872 "$node_(392) setdest 9071 1167 15.0" 
$ns at 385.9897208141615 "$node_(393) setdest 5073 8457 6.0" 
$ns at 455.0470273291259 "$node_(393) setdest 12319 42974 6.0" 
$ns at 499.2640881202225 "$node_(393) setdest 81240 35649 7.0" 
$ns at 546.2107747640135 "$node_(393) setdest 94280 43768 16.0" 
$ns at 684.0585236910947 "$node_(393) setdest 95882 24028 5.0" 
$ns at 734.022516633173 "$node_(393) setdest 79263 10482 13.0" 
$ns at 852.0770462910244 "$node_(393) setdest 90157 36978 9.0" 
$ns at 401.30681351782255 "$node_(394) setdest 87639 42923 20.0" 
$ns at 444.0235552682725 "$node_(394) setdest 20807 38326 3.0" 
$ns at 484.3827652470281 "$node_(394) setdest 46989 19403 13.0" 
$ns at 574.1319784826801 "$node_(394) setdest 78145 40095 8.0" 
$ns at 635.4622129613181 "$node_(394) setdest 66844 34475 1.0" 
$ns at 673.3344937981141 "$node_(394) setdest 105386 13932 7.0" 
$ns at 756.4518896399231 "$node_(394) setdest 82246 26613 17.0" 
$ns at 838.4113585957846 "$node_(394) setdest 84299 30637 13.0" 
$ns at 337.25282163119545 "$node_(395) setdest 89657 8870 7.0" 
$ns at 412.8374460612604 "$node_(395) setdest 11837 40095 9.0" 
$ns at 515.2194427366207 "$node_(395) setdest 43022 43237 1.0" 
$ns at 546.3602741655194 "$node_(395) setdest 28634 24616 10.0" 
$ns at 616.8543294472596 "$node_(395) setdest 44511 8398 20.0" 
$ns at 805.1578762367806 "$node_(395) setdest 120612 1599 16.0" 
$ns at 867.6456400137663 "$node_(395) setdest 42843 34895 9.0" 
$ns at 324.95287704690674 "$node_(396) setdest 105323 5748 8.0" 
$ns at 363.14454658218006 "$node_(396) setdest 65266 4941 19.0" 
$ns at 445.8408226258327 "$node_(396) setdest 73968 7296 1.0" 
$ns at 483.13989378574325 "$node_(396) setdest 66623 8312 2.0" 
$ns at 522.4316154648383 "$node_(396) setdest 80456 1735 12.0" 
$ns at 583.6115273675508 "$node_(396) setdest 65983 2098 4.0" 
$ns at 626.2894915572041 "$node_(396) setdest 64119 13126 3.0" 
$ns at 677.7197864411078 "$node_(396) setdest 6600 38942 15.0" 
$ns at 778.1449562180818 "$node_(396) setdest 131559 2859 1.0" 
$ns at 813.382757072543 "$node_(396) setdest 99103 40765 1.0" 
$ns at 849.7233296403358 "$node_(396) setdest 89197 31591 13.0" 
$ns at 341.43334568701965 "$node_(397) setdest 85858 26412 5.0" 
$ns at 390.4532390382113 "$node_(397) setdest 28464 34827 7.0" 
$ns at 432.68039705367323 "$node_(397) setdest 124661 22066 7.0" 
$ns at 478.001725270476 "$node_(397) setdest 98550 5047 14.0" 
$ns at 594.255190076698 "$node_(397) setdest 59025 13017 17.0" 
$ns at 739.115144010135 "$node_(397) setdest 43894 44436 10.0" 
$ns at 814.2499682261305 "$node_(397) setdest 82685 19200 1.0" 
$ns at 844.7287394607843 "$node_(397) setdest 110435 4216 1.0" 
$ns at 880.6713117246082 "$node_(397) setdest 6690 35718 9.0" 
$ns at 381.57694154515013 "$node_(398) setdest 106127 36945 13.0" 
$ns at 500.71599222253775 "$node_(398) setdest 34268 22474 9.0" 
$ns at 593.159463971206 "$node_(398) setdest 79874 8060 4.0" 
$ns at 638.8173502088397 "$node_(398) setdest 119490 36896 18.0" 
$ns at 745.5226063371608 "$node_(398) setdest 86994 34214 15.0" 
$ns at 797.5590402450582 "$node_(398) setdest 109781 16065 16.0" 
$ns at 309.9564839949329 "$node_(399) setdest 115223 13808 15.0" 
$ns at 455.07184047613066 "$node_(399) setdest 131338 37187 10.0" 
$ns at 569.5003235731166 "$node_(399) setdest 78117 15090 2.0" 
$ns at 615.213842283681 "$node_(399) setdest 104258 608 4.0" 
$ns at 659.4029213186745 "$node_(399) setdest 57031 40103 15.0" 
$ns at 839.0542930195405 "$node_(399) setdest 39050 40842 17.0" 
$ns at 422.94228197230063 "$node_(400) setdest 105390 28509 7.0" 
$ns at 516.2508739951813 "$node_(400) setdest 83427 625 1.0" 
$ns at 553.150634328364 "$node_(400) setdest 40216 15836 1.0" 
$ns at 588.6854715020962 "$node_(400) setdest 1990 17913 15.0" 
$ns at 636.626321605378 "$node_(400) setdest 68926 36711 6.0" 
$ns at 711.7178214648549 "$node_(400) setdest 49762 40446 16.0" 
$ns at 838.9407543019581 "$node_(400) setdest 7604 28141 15.0" 
$ns at 895.2368975866121 "$node_(400) setdest 34461 29177 16.0" 
$ns at 421.80620617812224 "$node_(401) setdest 90363 28032 13.0" 
$ns at 513.4668372498854 "$node_(401) setdest 10895 42319 7.0" 
$ns at 611.9165857357274 "$node_(401) setdest 100693 25458 10.0" 
$ns at 703.0476909850464 "$node_(401) setdest 51451 4687 4.0" 
$ns at 771.7632316804394 "$node_(401) setdest 19648 129 11.0" 
$ns at 891.4998388503066 "$node_(401) setdest 70656 36845 5.0" 
$ns at 425.3364867557144 "$node_(402) setdest 117985 7909 1.0" 
$ns at 458.3978516678872 "$node_(402) setdest 3914 8689 7.0" 
$ns at 543.7678637834075 "$node_(402) setdest 67999 38964 18.0" 
$ns at 746.7969643729311 "$node_(402) setdest 95743 11811 9.0" 
$ns at 790.1042112337414 "$node_(402) setdest 10316 35804 17.0" 
$ns at 868.3751403521981 "$node_(402) setdest 42565 26014 11.0" 
$ns at 400.69202413647264 "$node_(403) setdest 32380 38919 2.0" 
$ns at 443.6888334876998 "$node_(403) setdest 125302 22518 14.0" 
$ns at 508.9477894693747 "$node_(403) setdest 78342 26266 18.0" 
$ns at 694.842711867901 "$node_(403) setdest 58756 31196 7.0" 
$ns at 751.7887472028217 "$node_(403) setdest 60098 36982 6.0" 
$ns at 824.3958958769091 "$node_(403) setdest 85325 1653 13.0" 
$ns at 463.96580575596744 "$node_(404) setdest 95699 38329 16.0" 
$ns at 621.1424516633592 "$node_(404) setdest 131507 10103 2.0" 
$ns at 665.3631273837633 "$node_(404) setdest 74546 12696 17.0" 
$ns at 863.8282821592626 "$node_(404) setdest 43331 8450 18.0" 
$ns at 405.5991673160819 "$node_(405) setdest 42827 3691 6.0" 
$ns at 480.5050631513469 "$node_(405) setdest 60475 40625 18.0" 
$ns at 673.6896638658122 "$node_(405) setdest 10904 39178 7.0" 
$ns at 741.5135356238379 "$node_(405) setdest 39536 16229 13.0" 
$ns at 889.7260663383605 "$node_(405) setdest 130513 37926 16.0" 
$ns at 505.81754536970607 "$node_(406) setdest 36957 16054 12.0" 
$ns at 546.968198581515 "$node_(406) setdest 70572 30258 11.0" 
$ns at 612.842760838465 "$node_(406) setdest 69842 22288 14.0" 
$ns at 766.9899347684332 "$node_(406) setdest 109483 6825 2.0" 
$ns at 805.3479913294793 "$node_(406) setdest 48119 16726 1.0" 
$ns at 841.9532198951736 "$node_(406) setdest 42563 12516 10.0" 
$ns at 479.46852433695597 "$node_(407) setdest 37019 37273 13.0" 
$ns at 616.2980454819208 "$node_(407) setdest 107685 22693 15.0" 
$ns at 776.375777306713 "$node_(407) setdest 90180 16825 7.0" 
$ns at 818.3671915574571 "$node_(407) setdest 12667 28191 13.0" 
$ns at 485.9878575507944 "$node_(408) setdest 15061 5084 16.0" 
$ns at 531.0379159156844 "$node_(408) setdest 122803 21549 16.0" 
$ns at 684.3338175624159 "$node_(408) setdest 56941 2542 10.0" 
$ns at 809.7250233315011 "$node_(408) setdest 36239 16431 3.0" 
$ns at 866.0477798193591 "$node_(408) setdest 53824 17889 8.0" 
$ns at 417.64568458589036 "$node_(409) setdest 40480 6568 9.0" 
$ns at 470.18253356258856 "$node_(409) setdest 48582 12369 7.0" 
$ns at 513.8380352112797 "$node_(409) setdest 45158 1252 18.0" 
$ns at 563.7715905406268 "$node_(409) setdest 52814 14611 11.0" 
$ns at 598.6795926312928 "$node_(409) setdest 36114 22133 16.0" 
$ns at 708.0380412101052 "$node_(409) setdest 95867 35001 13.0" 
$ns at 789.520823045962 "$node_(409) setdest 86234 14334 19.0" 
$ns at 429.1524730836373 "$node_(410) setdest 124475 34652 16.0" 
$ns at 616.2277362174627 "$node_(410) setdest 129592 2754 12.0" 
$ns at 698.1923400447475 "$node_(410) setdest 119542 27744 13.0" 
$ns at 823.1354232030179 "$node_(410) setdest 59878 34123 16.0" 
$ns at 403.61668953380604 "$node_(411) setdest 26187 34617 12.0" 
$ns at 483.8434131865843 "$node_(411) setdest 13137 10615 20.0" 
$ns at 577.9401076859327 "$node_(411) setdest 114647 687 13.0" 
$ns at 679.9690169979064 "$node_(411) setdest 93392 24849 19.0" 
$ns at 747.4047425051784 "$node_(411) setdest 96608 40203 10.0" 
$ns at 835.2652610796629 "$node_(411) setdest 11125 28001 17.0" 
$ns at 507.3540500498483 "$node_(412) setdest 130749 6327 15.0" 
$ns at 647.9759391300242 "$node_(412) setdest 55271 27655 6.0" 
$ns at 737.1180297431483 "$node_(412) setdest 101974 19191 4.0" 
$ns at 790.508454196553 "$node_(412) setdest 92804 10936 17.0" 
$ns at 404.63207930397385 "$node_(413) setdest 22970 4648 18.0" 
$ns at 529.3780045076684 "$node_(413) setdest 62535 39949 7.0" 
$ns at 622.2135992559146 "$node_(413) setdest 37898 22321 8.0" 
$ns at 671.6587338483363 "$node_(413) setdest 1060 43795 10.0" 
$ns at 708.3713194204882 "$node_(413) setdest 71221 27260 14.0" 
$ns at 863.8821122408955 "$node_(413) setdest 20604 10662 14.0" 
$ns at 498.14802870354265 "$node_(414) setdest 64274 40031 9.0" 
$ns at 576.4904524404005 "$node_(414) setdest 81269 18467 11.0" 
$ns at 694.0065500936175 "$node_(414) setdest 52270 33093 7.0" 
$ns at 793.6501279924362 "$node_(414) setdest 24795 2837 4.0" 
$ns at 836.7633646049422 "$node_(414) setdest 121171 34902 12.0" 
$ns at 889.5648965341329 "$node_(414) setdest 109262 39699 5.0" 
$ns at 510.4912009028935 "$node_(415) setdest 124356 24338 19.0" 
$ns at 704.170832124671 "$node_(415) setdest 30086 38285 6.0" 
$ns at 775.6625227876098 "$node_(415) setdest 51921 17642 8.0" 
$ns at 811.6577143285518 "$node_(415) setdest 59884 2872 1.0" 
$ns at 843.9867644766312 "$node_(415) setdest 27077 25899 1.0" 
$ns at 881.4314054329707 "$node_(415) setdest 124679 378 11.0" 
$ns at 455.56329527736 "$node_(416) setdest 95554 637 1.0" 
$ns at 489.70190251062957 "$node_(416) setdest 67838 18180 11.0" 
$ns at 591.6399981815755 "$node_(416) setdest 630 32752 16.0" 
$ns at 683.5275445035351 "$node_(416) setdest 25533 19230 9.0" 
$ns at 723.9705013778846 "$node_(416) setdest 79852 1492 3.0" 
$ns at 776.4920865732681 "$node_(416) setdest 128178 3856 7.0" 
$ns at 849.8460605028849 "$node_(416) setdest 116703 2322 3.0" 
$ns at 881.9888793725737 "$node_(416) setdest 128901 11498 17.0" 
$ns at 421.91503658694876 "$node_(417) setdest 93058 27379 3.0" 
$ns at 458.35192738748435 "$node_(417) setdest 104716 29148 16.0" 
$ns at 496.58797776731944 "$node_(417) setdest 117685 8568 11.0" 
$ns at 566.3100357055667 "$node_(417) setdest 100476 21721 13.0" 
$ns at 722.8782098710711 "$node_(417) setdest 123060 19139 4.0" 
$ns at 759.585020518599 "$node_(417) setdest 86551 17812 16.0" 
$ns at 882.126526146095 "$node_(417) setdest 8643 30673 1.0" 
$ns at 405.06116085789955 "$node_(418) setdest 3294 2423 7.0" 
$ns at 481.56043126686836 "$node_(418) setdest 17545 4242 15.0" 
$ns at 642.650140608714 "$node_(418) setdest 40638 11722 10.0" 
$ns at 693.4412176372468 "$node_(418) setdest 32374 44172 1.0" 
$ns at 726.2192983454078 "$node_(418) setdest 118192 21336 19.0" 
$ns at 405.6706277949351 "$node_(419) setdest 91377 37163 3.0" 
$ns at 446.8795307235142 "$node_(419) setdest 73265 20685 8.0" 
$ns at 531.3371223139103 "$node_(419) setdest 123689 26431 7.0" 
$ns at 623.436669336885 "$node_(419) setdest 5295 12638 9.0" 
$ns at 718.9777053937769 "$node_(419) setdest 30423 25915 1.0" 
$ns at 756.8947352007193 "$node_(419) setdest 40716 10154 3.0" 
$ns at 802.9911055367082 "$node_(419) setdest 11118 27350 8.0" 
$ns at 854.2193089058107 "$node_(419) setdest 57964 1682 10.0" 
$ns at 405.9652369099368 "$node_(420) setdest 66560 8515 10.0" 
$ns at 454.53640353794606 "$node_(420) setdest 122497 22321 8.0" 
$ns at 497.0976971220307 "$node_(420) setdest 85619 42246 9.0" 
$ns at 554.0290297061963 "$node_(420) setdest 522 12724 18.0" 
$ns at 721.9892964388016 "$node_(420) setdest 70199 14666 1.0" 
$ns at 761.9528892305916 "$node_(420) setdest 110514 7235 13.0" 
$ns at 448.30831203111256 "$node_(421) setdest 49778 28994 4.0" 
$ns at 506.92402831668915 "$node_(421) setdest 57372 16469 6.0" 
$ns at 578.2787708079152 "$node_(421) setdest 32367 40815 13.0" 
$ns at 612.1717347736975 "$node_(421) setdest 43400 30238 6.0" 
$ns at 655.8097327345552 "$node_(421) setdest 28174 8210 4.0" 
$ns at 722.4848137207786 "$node_(421) setdest 46220 11215 4.0" 
$ns at 786.471017970487 "$node_(421) setdest 16694 9106 11.0" 
$ns at 407.60308588999067 "$node_(422) setdest 69923 34916 8.0" 
$ns at 484.77372410899125 "$node_(422) setdest 33479 1658 13.0" 
$ns at 543.9795839914374 "$node_(422) setdest 17738 6935 9.0" 
$ns at 627.9546287294143 "$node_(422) setdest 36037 10455 11.0" 
$ns at 663.2275697994709 "$node_(422) setdest 121184 10315 16.0" 
$ns at 773.0277481041798 "$node_(422) setdest 28891 28700 2.0" 
$ns at 811.9095180029627 "$node_(422) setdest 189 9695 11.0" 
$ns at 422.4843144598427 "$node_(423) setdest 95699 30078 17.0" 
$ns at 603.7746169188271 "$node_(423) setdest 58748 15955 4.0" 
$ns at 664.5472488566576 "$node_(423) setdest 121502 10519 16.0" 
$ns at 809.3815731703912 "$node_(423) setdest 107043 10653 9.0" 
$ns at 413.2850330559793 "$node_(424) setdest 82105 30343 13.0" 
$ns at 547.0689747080693 "$node_(424) setdest 2253 7282 1.0" 
$ns at 578.6817714663857 "$node_(424) setdest 128314 25452 2.0" 
$ns at 621.1099294320973 "$node_(424) setdest 81904 11546 8.0" 
$ns at 667.2994929657418 "$node_(424) setdest 16480 16820 5.0" 
$ns at 733.8413201219771 "$node_(424) setdest 28543 32719 12.0" 
$ns at 772.3927077638103 "$node_(424) setdest 98794 10029 15.0" 
$ns at 462.0861949614963 "$node_(425) setdest 16772 26435 7.0" 
$ns at 510.56022597980245 "$node_(425) setdest 121529 4207 20.0" 
$ns at 584.5273260644017 "$node_(425) setdest 130429 40875 11.0" 
$ns at 717.0224976099303 "$node_(425) setdest 114382 26452 17.0" 
$ns at 886.6448124857692 "$node_(425) setdest 51877 7899 1.0" 
$ns at 448.27178461246024 "$node_(426) setdest 6890 38531 9.0" 
$ns at 566.7129166539365 "$node_(426) setdest 32981 7644 14.0" 
$ns at 656.0529081681565 "$node_(426) setdest 87 33834 14.0" 
$ns at 728.7364342145315 "$node_(426) setdest 4144 2262 12.0" 
$ns at 805.697184596245 "$node_(426) setdest 54551 10622 10.0" 
$ns at 887.2734352326337 "$node_(426) setdest 109755 24782 13.0" 
$ns at 405.3276534836379 "$node_(427) setdest 65361 32330 18.0" 
$ns at 499.77617813931414 "$node_(427) setdest 53137 15702 14.0" 
$ns at 618.8365416116035 "$node_(427) setdest 106916 13273 19.0" 
$ns at 721.6220798789843 "$node_(427) setdest 21063 10613 6.0" 
$ns at 777.9147771610232 "$node_(427) setdest 46192 31061 6.0" 
$ns at 846.4736829419737 "$node_(427) setdest 65566 33213 14.0" 
$ns at 401.1938334766563 "$node_(428) setdest 36041 535 19.0" 
$ns at 575.3743793326673 "$node_(428) setdest 36561 36119 1.0" 
$ns at 612.5717301201311 "$node_(428) setdest 75174 36248 17.0" 
$ns at 696.034047281033 "$node_(428) setdest 109168 29903 2.0" 
$ns at 732.1940466532814 "$node_(428) setdest 53388 37108 15.0" 
$ns at 455.43274826521133 "$node_(429) setdest 108695 9347 16.0" 
$ns at 619.71419023881 "$node_(429) setdest 64382 5193 18.0" 
$ns at 808.8799956259967 "$node_(429) setdest 103637 11037 14.0" 
$ns at 477.2637310789797 "$node_(430) setdest 6093 33672 19.0" 
$ns at 661.1059557596566 "$node_(430) setdest 58303 10659 16.0" 
$ns at 794.955107760828 "$node_(430) setdest 28197 8461 18.0" 
$ns at 440.5925139289221 "$node_(431) setdest 61307 9465 1.0" 
$ns at 473.9004574223869 "$node_(431) setdest 12411 31614 5.0" 
$ns at 537.3388099210395 "$node_(431) setdest 72014 7146 3.0" 
$ns at 589.5698073604025 "$node_(431) setdest 80337 27688 17.0" 
$ns at 741.4052461524896 "$node_(431) setdest 5033 27403 2.0" 
$ns at 775.6209021648114 "$node_(431) setdest 42912 2284 20.0" 
$ns at 426.64636895191444 "$node_(432) setdest 55390 21798 16.0" 
$ns at 537.3638842649118 "$node_(432) setdest 101261 35783 16.0" 
$ns at 639.6835575881163 "$node_(432) setdest 58686 2207 14.0" 
$ns at 808.9828543605802 "$node_(432) setdest 126818 17676 9.0" 
$ns at 890.838694047367 "$node_(432) setdest 101766 18313 13.0" 
$ns at 529.9927852245432 "$node_(433) setdest 51430 41498 7.0" 
$ns at 626.8355245973463 "$node_(433) setdest 48219 36924 1.0" 
$ns at 660.9598119101445 "$node_(433) setdest 17812 535 19.0" 
$ns at 863.1376122226393 "$node_(433) setdest 22392 15488 3.0" 
$ns at 898.9835876605448 "$node_(433) setdest 6103 32271 14.0" 
$ns at 477.15574178372356 "$node_(434) setdest 53110 17466 11.0" 
$ns at 531.7770015445054 "$node_(434) setdest 4293 33825 7.0" 
$ns at 565.7405548720649 "$node_(434) setdest 48182 39822 5.0" 
$ns at 639.8034902517865 "$node_(434) setdest 10772 8865 1.0" 
$ns at 679.2394691759256 "$node_(434) setdest 132939 16301 4.0" 
$ns at 729.3332367358614 "$node_(434) setdest 34737 32237 12.0" 
$ns at 787.8103511286946 "$node_(434) setdest 50896 35064 12.0" 
$ns at 880.1927461741761 "$node_(434) setdest 112342 18493 3.0" 
$ns at 444.02225462561205 "$node_(435) setdest 57246 26945 11.0" 
$ns at 535.4428156309749 "$node_(435) setdest 85226 21332 18.0" 
$ns at 650.3415235622684 "$node_(435) setdest 44022 35059 17.0" 
$ns at 764.1250141715216 "$node_(435) setdest 72522 41558 16.0" 
$ns at 882.212993493449 "$node_(435) setdest 22004 2037 17.0" 
$ns at 450.9757738917756 "$node_(436) setdest 45258 30883 9.0" 
$ns at 516.4473987878955 "$node_(436) setdest 42930 35185 10.0" 
$ns at 580.8399934488646 "$node_(436) setdest 83372 24985 8.0" 
$ns at 683.9835174852657 "$node_(436) setdest 37040 42595 6.0" 
$ns at 736.4607296566526 "$node_(436) setdest 66867 28772 17.0" 
$ns at 838.1458406336856 "$node_(436) setdest 8397 27300 13.0" 
$ns at 886.7661713277674 "$node_(436) setdest 34932 41995 14.0" 
$ns at 443.54830150826206 "$node_(437) setdest 80666 37731 7.0" 
$ns at 529.2418583007052 "$node_(437) setdest 117258 30925 11.0" 
$ns at 641.8152574863648 "$node_(437) setdest 62033 29196 19.0" 
$ns at 843.7409519953842 "$node_(437) setdest 39262 13933 1.0" 
$ns at 875.8494700486937 "$node_(437) setdest 133912 10594 14.0" 
$ns at 440.9127670690019 "$node_(438) setdest 46813 38602 5.0" 
$ns at 487.62763986840463 "$node_(438) setdest 43764 23200 8.0" 
$ns at 522.4353149323186 "$node_(438) setdest 57534 2668 10.0" 
$ns at 630.0275951389476 "$node_(438) setdest 59486 38554 10.0" 
$ns at 723.730296410785 "$node_(438) setdest 113593 2520 12.0" 
$ns at 840.4539115945132 "$node_(438) setdest 109818 33872 4.0" 
$ns at 896.9108911636652 "$node_(438) setdest 32779 17380 5.0" 
$ns at 451.2305335751797 "$node_(439) setdest 104923 6386 10.0" 
$ns at 510.71032721649584 "$node_(439) setdest 113580 22676 2.0" 
$ns at 551.3926244268185 "$node_(439) setdest 91666 41558 16.0" 
$ns at 612.0588989243705 "$node_(439) setdest 4094 3788 17.0" 
$ns at 757.6839701496397 "$node_(439) setdest 75663 42231 2.0" 
$ns at 801.2578330675746 "$node_(439) setdest 58809 39553 12.0" 
$ns at 438.2442422406318 "$node_(440) setdest 1370 7441 3.0" 
$ns at 486.01746887686534 "$node_(440) setdest 16449 5235 7.0" 
$ns at 563.8002642863478 "$node_(440) setdest 51239 31348 5.0" 
$ns at 600.2221937707736 "$node_(440) setdest 44038 1346 17.0" 
$ns at 728.8350528916775 "$node_(440) setdest 98586 33345 14.0" 
$ns at 853.9417764030572 "$node_(440) setdest 113348 22284 9.0" 
$ns at 436.96568661722324 "$node_(441) setdest 124449 29658 12.0" 
$ns at 579.3478624295723 "$node_(441) setdest 46780 24054 5.0" 
$ns at 637.756841051719 "$node_(441) setdest 126841 6141 8.0" 
$ns at 739.7266765469348 "$node_(441) setdest 31165 17970 4.0" 
$ns at 783.8200246203431 "$node_(441) setdest 117032 25602 19.0" 
$ns at 863.3270994821717 "$node_(441) setdest 214 25254 19.0" 
$ns at 462.7057809957254 "$node_(442) setdest 16968 28974 7.0" 
$ns at 535.1460828073896 "$node_(442) setdest 128334 19708 14.0" 
$ns at 602.3688294107614 "$node_(442) setdest 65974 5322 11.0" 
$ns at 649.5532649900499 "$node_(442) setdest 53701 43768 18.0" 
$ns at 841.0477052960061 "$node_(442) setdest 45299 37872 11.0" 
$ns at 450.42341584042606 "$node_(443) setdest 104387 9271 2.0" 
$ns at 493.65911854469783 "$node_(443) setdest 10237 22338 1.0" 
$ns at 526.2957711422496 "$node_(443) setdest 126554 3762 5.0" 
$ns at 598.927301276759 "$node_(443) setdest 130032 22172 4.0" 
$ns at 640.7999140889905 "$node_(443) setdest 93161 27129 13.0" 
$ns at 785.2737570766567 "$node_(443) setdest 93507 38864 19.0" 
$ns at 867.2194749578075 "$node_(443) setdest 103727 44668 6.0" 
$ns at 426.85200018915856 "$node_(444) setdest 93112 20385 17.0" 
$ns at 594.0714098346484 "$node_(444) setdest 41052 24556 9.0" 
$ns at 696.5987357928989 "$node_(444) setdest 115138 23932 18.0" 
$ns at 869.8451806777426 "$node_(444) setdest 107371 25250 7.0" 
$ns at 443.81511507392867 "$node_(445) setdest 118403 30215 15.0" 
$ns at 516.051705223218 "$node_(445) setdest 32342 11851 19.0" 
$ns at 616.7961933346323 "$node_(445) setdest 26781 37541 9.0" 
$ns at 709.4294254398217 "$node_(445) setdest 132407 22171 18.0" 
$ns at 842.0728801092448 "$node_(445) setdest 70949 8942 13.0" 
$ns at 495.17985846631774 "$node_(446) setdest 44269 14932 16.0" 
$ns at 643.332593931492 "$node_(446) setdest 119527 2262 8.0" 
$ns at 717.3374839961275 "$node_(446) setdest 44516 25809 10.0" 
$ns at 822.8367945242211 "$node_(446) setdest 61988 12630 12.0" 
$ns at 852.9513129423616 "$node_(446) setdest 99575 7436 16.0" 
$ns at 884.321982817186 "$node_(446) setdest 71882 43503 20.0" 
$ns at 489.73764106543797 "$node_(447) setdest 104625 8549 17.0" 
$ns at 644.9925655777431 "$node_(447) setdest 49358 6440 18.0" 
$ns at 726.3800683340603 "$node_(447) setdest 62776 27767 20.0" 
$ns at 820.4234050192949 "$node_(447) setdest 77006 18171 2.0" 
$ns at 861.9851423671439 "$node_(447) setdest 24251 7617 19.0" 
$ns at 413.801271826544 "$node_(448) setdest 115872 30151 5.0" 
$ns at 492.06146636472937 "$node_(448) setdest 130222 40848 20.0" 
$ns at 542.3043364147674 "$node_(448) setdest 50396 12645 17.0" 
$ns at 615.6462725688968 "$node_(448) setdest 23672 36619 19.0" 
$ns at 744.325918400478 "$node_(448) setdest 113904 23712 14.0" 
$ns at 889.3810534236536 "$node_(448) setdest 98215 19111 8.0" 
$ns at 586.1827347127851 "$node_(449) setdest 87432 16315 18.0" 
$ns at 638.0424414430543 "$node_(449) setdest 111240 28426 17.0" 
$ns at 717.1053896560643 "$node_(449) setdest 66623 7856 3.0" 
$ns at 765.5399624764026 "$node_(449) setdest 10188 16403 19.0" 
$ns at 577.2775415065416 "$node_(450) setdest 31243 13 1.0" 
$ns at 614.2584569691111 "$node_(450) setdest 90725 8817 1.0" 
$ns at 648.8094495564482 "$node_(450) setdest 72272 26237 15.0" 
$ns at 705.4250355191757 "$node_(450) setdest 86492 15954 2.0" 
$ns at 741.7317757825417 "$node_(450) setdest 71000 11256 13.0" 
$ns at 894.5930484347971 "$node_(450) setdest 7603 9728 19.0" 
$ns at 405.06702794863196 "$node_(451) setdest 132938 35259 15.0" 
$ns at 513.4553724010286 "$node_(451) setdest 63280 29919 1.0" 
$ns at 543.5309507296921 "$node_(451) setdest 15284 18534 3.0" 
$ns at 581.7709958887519 "$node_(451) setdest 95659 19654 14.0" 
$ns at 671.2169569955892 "$node_(451) setdest 83764 18803 19.0" 
$ns at 787.8866901898484 "$node_(451) setdest 101072 39450 14.0" 
$ns at 896.8817215459211 "$node_(451) setdest 134127 28137 1.0" 
$ns at 474.0015539382157 "$node_(452) setdest 60829 15617 8.0" 
$ns at 520.6691451684262 "$node_(452) setdest 75208 33867 10.0" 
$ns at 600.5779979040493 "$node_(452) setdest 5440 37365 20.0" 
$ns at 675.4885247443439 "$node_(452) setdest 66029 11005 14.0" 
$ns at 841.2561986389047 "$node_(452) setdest 103505 30256 3.0" 
$ns at 887.523134822764 "$node_(452) setdest 131859 1429 13.0" 
$ns at 441.41054071357115 "$node_(453) setdest 70928 11379 18.0" 
$ns at 529.3923869077363 "$node_(453) setdest 96631 3708 13.0" 
$ns at 630.7749785941494 "$node_(453) setdest 49122 14469 1.0" 
$ns at 663.19203661343 "$node_(453) setdest 29724 34939 5.0" 
$ns at 722.1737447425894 "$node_(453) setdest 58322 9168 10.0" 
$ns at 804.5337488177629 "$node_(453) setdest 32603 6874 2.0" 
$ns at 851.710974180503 "$node_(453) setdest 115205 23406 19.0" 
$ns at 425.64729800859067 "$node_(454) setdest 47848 18893 6.0" 
$ns at 494.7972713457053 "$node_(454) setdest 23694 37849 1.0" 
$ns at 526.2557111634538 "$node_(454) setdest 85697 25637 1.0" 
$ns at 560.1003123210714 "$node_(454) setdest 49622 23737 18.0" 
$ns at 754.039964478708 "$node_(454) setdest 102557 16035 1.0" 
$ns at 788.6929310219173 "$node_(454) setdest 131788 35700 1.0" 
$ns at 818.7477483861404 "$node_(454) setdest 25676 34159 2.0" 
$ns at 865.5545524093197 "$node_(454) setdest 27305 19425 20.0" 
$ns at 485.8766262997606 "$node_(455) setdest 127926 43 10.0" 
$ns at 570.9554034772603 "$node_(455) setdest 71063 852 19.0" 
$ns at 749.6486709348453 "$node_(455) setdest 49084 9386 20.0" 
$ns at 884.7134429341604 "$node_(455) setdest 21106 1513 20.0" 
$ns at 405.46182533891397 "$node_(456) setdest 124915 35124 5.0" 
$ns at 480.50090543434976 "$node_(456) setdest 25022 35262 7.0" 
$ns at 515.2517304036753 "$node_(456) setdest 41969 44657 2.0" 
$ns at 546.7938433671005 "$node_(456) setdest 85013 14838 1.0" 
$ns at 576.8833641964538 "$node_(456) setdest 25864 4909 7.0" 
$ns at 664.8323742858121 "$node_(456) setdest 12038 38084 6.0" 
$ns at 750.6660396241379 "$node_(456) setdest 111658 9669 19.0" 
$ns at 786.5739354110463 "$node_(456) setdest 56169 31521 15.0" 
$ns at 884.8064087486189 "$node_(456) setdest 59787 20074 9.0" 
$ns at 443.6787414676205 "$node_(457) setdest 75589 33469 8.0" 
$ns at 549.4221262181023 "$node_(457) setdest 110711 20555 18.0" 
$ns at 675.2657908507713 "$node_(457) setdest 24421 6495 19.0" 
$ns at 849.3488403721752 "$node_(457) setdest 54675 7705 16.0" 
$ns at 513.349291564092 "$node_(458) setdest 53872 15815 8.0" 
$ns at 544.9489642772161 "$node_(458) setdest 96733 32136 10.0" 
$ns at 613.4737649419178 "$node_(458) setdest 58880 38436 14.0" 
$ns at 660.5859863689551 "$node_(458) setdest 123235 8896 2.0" 
$ns at 704.9159019197655 "$node_(458) setdest 18842 15093 3.0" 
$ns at 746.2571819611925 "$node_(458) setdest 82870 35296 13.0" 
$ns at 439.2889129989856 "$node_(459) setdest 95632 42289 2.0" 
$ns at 484.3462852525758 "$node_(459) setdest 59937 21219 10.0" 
$ns at 559.7959149830126 "$node_(459) setdest 13193 18381 8.0" 
$ns at 652.6587416277193 "$node_(459) setdest 75934 12967 3.0" 
$ns at 696.1055453456858 "$node_(459) setdest 113075 8968 20.0" 
$ns at 770.0561959233526 "$node_(459) setdest 104291 16055 8.0" 
$ns at 805.0849889162149 "$node_(459) setdest 20606 5847 2.0" 
$ns at 846.6120036121866 "$node_(459) setdest 71382 27084 7.0" 
$ns at 463.86582422680874 "$node_(460) setdest 66210 41917 5.0" 
$ns at 536.3113949546357 "$node_(460) setdest 27870 6561 13.0" 
$ns at 605.1174713136122 "$node_(460) setdest 91169 14490 17.0" 
$ns at 803.8744580049827 "$node_(460) setdest 57436 6949 3.0" 
$ns at 841.0580291470314 "$node_(460) setdest 97157 39654 5.0" 
$ns at 899.6429037774492 "$node_(460) setdest 68494 6503 1.0" 
$ns at 451.40453538492926 "$node_(461) setdest 70902 31895 7.0" 
$ns at 512.4349311760241 "$node_(461) setdest 67950 1075 13.0" 
$ns at 582.9444708183515 "$node_(461) setdest 101944 41387 8.0" 
$ns at 638.8882015520614 "$node_(461) setdest 101087 10764 17.0" 
$ns at 768.8036241669166 "$node_(461) setdest 83132 8511 10.0" 
$ns at 824.9489435334206 "$node_(461) setdest 95229 43 7.0" 
$ns at 876.0208117862211 "$node_(461) setdest 62703 23178 7.0" 
$ns at 421.07661860151654 "$node_(462) setdest 26784 21979 4.0" 
$ns at 453.543317392947 "$node_(462) setdest 88282 34597 5.0" 
$ns at 514.8536442132065 "$node_(462) setdest 5299 6180 14.0" 
$ns at 636.933113446065 "$node_(462) setdest 80735 23274 19.0" 
$ns at 835.4703510612251 "$node_(462) setdest 14594 16422 5.0" 
$ns at 875.8100828426586 "$node_(462) setdest 27532 43323 1.0" 
$ns at 463.1186099812096 "$node_(463) setdest 119297 21995 1.0" 
$ns at 495.5954342275862 "$node_(463) setdest 68989 32596 11.0" 
$ns at 599.020041516505 "$node_(463) setdest 44045 39074 11.0" 
$ns at 687.3940392889065 "$node_(463) setdest 67558 18514 11.0" 
$ns at 750.0282033932341 "$node_(463) setdest 43346 9307 4.0" 
$ns at 790.4511131269717 "$node_(463) setdest 5885 17974 13.0" 
$ns at 440.1271791660066 "$node_(464) setdest 79721 13807 1.0" 
$ns at 471.25426253023204 "$node_(464) setdest 49720 12877 3.0" 
$ns at 520.2820711565452 "$node_(464) setdest 107315 32138 19.0" 
$ns at 647.659810819013 "$node_(464) setdest 30094 4996 7.0" 
$ns at 712.3432321426224 "$node_(464) setdest 36905 33669 20.0" 
$ns at 769.6837256070569 "$node_(464) setdest 75892 38000 9.0" 
$ns at 888.0743215457745 "$node_(464) setdest 70840 14005 7.0" 
$ns at 412.51560527342656 "$node_(465) setdest 88898 39154 7.0" 
$ns at 502.80969901684546 "$node_(465) setdest 124688 157 6.0" 
$ns at 563.9768700829277 "$node_(465) setdest 122106 16560 7.0" 
$ns at 615.6603837740727 "$node_(465) setdest 115180 34403 5.0" 
$ns at 685.9944603184578 "$node_(465) setdest 117953 37322 5.0" 
$ns at 759.3249434366763 "$node_(465) setdest 126319 41024 1.0" 
$ns at 794.3843333175774 "$node_(465) setdest 85521 42381 12.0" 
$ns at 458.4156910644353 "$node_(466) setdest 61092 6323 12.0" 
$ns at 492.1810408012745 "$node_(466) setdest 5742 15036 11.0" 
$ns at 565.3242774337057 "$node_(466) setdest 84581 26676 12.0" 
$ns at 704.8575481813903 "$node_(466) setdest 26311 19280 7.0" 
$ns at 772.5111222136973 "$node_(466) setdest 111238 11054 16.0" 
$ns at 805.1572057224536 "$node_(466) setdest 16867 6021 14.0" 
$ns at 409.2060078254581 "$node_(467) setdest 6644 33504 2.0" 
$ns at 448.63076725616156 "$node_(467) setdest 67145 25196 1.0" 
$ns at 481.1965098255511 "$node_(467) setdest 19653 21650 16.0" 
$ns at 535.2548390172359 "$node_(467) setdest 95766 2508 5.0" 
$ns at 613.2994435142396 "$node_(467) setdest 38753 33606 6.0" 
$ns at 680.4245091790542 "$node_(467) setdest 108083 43084 1.0" 
$ns at 716.2394668009463 "$node_(467) setdest 49968 28032 1.0" 
$ns at 748.1486965229157 "$node_(467) setdest 49407 37533 8.0" 
$ns at 821.2140851191258 "$node_(467) setdest 34609 22741 4.0" 
$ns at 861.191373967351 "$node_(467) setdest 67635 16231 15.0" 
$ns at 432.55262372876 "$node_(468) setdest 29951 42367 9.0" 
$ns at 527.1604674592082 "$node_(468) setdest 70012 1589 6.0" 
$ns at 601.4118089584923 "$node_(468) setdest 123278 7848 11.0" 
$ns at 648.9826806092939 "$node_(468) setdest 77129 39704 9.0" 
$ns at 751.9244218079592 "$node_(468) setdest 39366 15103 16.0" 
$ns at 449.85225338150747 "$node_(469) setdest 117264 4186 1.0" 
$ns at 484.5590952777024 "$node_(469) setdest 16168 12914 7.0" 
$ns at 582.5712161472825 "$node_(469) setdest 58876 25387 8.0" 
$ns at 643.1152933683763 "$node_(469) setdest 41638 1182 8.0" 
$ns at 729.3734643135017 "$node_(469) setdest 132465 1618 15.0" 
$ns at 815.3768221203768 "$node_(469) setdest 82038 13792 11.0" 
$ns at 443.90453147037346 "$node_(470) setdest 71923 43082 17.0" 
$ns at 481.9439384206973 "$node_(470) setdest 42926 37762 4.0" 
$ns at 533.4128143612552 "$node_(470) setdest 44121 42457 4.0" 
$ns at 576.4657051504734 "$node_(470) setdest 41609 12857 7.0" 
$ns at 674.1793768024542 "$node_(470) setdest 19327 22541 14.0" 
$ns at 746.8919410726453 "$node_(470) setdest 108135 24232 4.0" 
$ns at 797.3835220493464 "$node_(470) setdest 13174 8824 15.0" 
$ns at 837.2045377471737 "$node_(470) setdest 104114 42595 4.0" 
$ns at 881.3119443008314 "$node_(470) setdest 129336 16412 11.0" 
$ns at 506.3649241562258 "$node_(471) setdest 96497 811 3.0" 
$ns at 544.5810715181341 "$node_(471) setdest 109939 41359 12.0" 
$ns at 653.8984422749438 "$node_(471) setdest 124417 9475 10.0" 
$ns at 741.2170563317658 "$node_(471) setdest 52482 11035 19.0" 
$ns at 800.6580355974622 "$node_(471) setdest 100718 19876 18.0" 
$ns at 423.508911937454 "$node_(472) setdest 14643 22782 4.0" 
$ns at 464.9381231553764 "$node_(472) setdest 125623 18061 19.0" 
$ns at 540.5249784952642 "$node_(472) setdest 8702 4647 11.0" 
$ns at 638.708838219752 "$node_(472) setdest 81058 26313 14.0" 
$ns at 761.0456252056463 "$node_(472) setdest 120933 39218 12.0" 
$ns at 427.9682548440019 "$node_(473) setdest 54348 36640 16.0" 
$ns at 593.113014331798 "$node_(473) setdest 38241 21546 4.0" 
$ns at 649.1365566777625 "$node_(473) setdest 30496 5194 6.0" 
$ns at 688.0445221183381 "$node_(473) setdest 49298 21838 4.0" 
$ns at 754.0333443325309 "$node_(473) setdest 65666 3448 8.0" 
$ns at 787.7899552066461 "$node_(473) setdest 37287 19126 4.0" 
$ns at 824.0131065146752 "$node_(473) setdest 24423 7661 3.0" 
$ns at 866.4573302330247 "$node_(473) setdest 11766 25829 8.0" 
$ns at 556.994843481201 "$node_(474) setdest 64314 30800 12.0" 
$ns at 684.7163669756045 "$node_(474) setdest 115133 9300 16.0" 
$ns at 848.5088861742628 "$node_(474) setdest 120031 20934 3.0" 
$ns at 407.1188391621782 "$node_(475) setdest 18940 43003 20.0" 
$ns at 440.86303249661836 "$node_(475) setdest 108136 15692 3.0" 
$ns at 494.17848406587916 "$node_(475) setdest 42631 33128 16.0" 
$ns at 654.8462505405008 "$node_(475) setdest 21004 18095 1.0" 
$ns at 692.8817448290382 "$node_(475) setdest 116974 411 10.0" 
$ns at 795.3831504179557 "$node_(475) setdest 80024 26994 1.0" 
$ns at 832.5107686304601 "$node_(475) setdest 131407 30405 20.0" 
$ns at 890.0202036433404 "$node_(475) setdest 20615 29521 10.0" 
$ns at 508.9972031516565 "$node_(476) setdest 48388 3556 6.0" 
$ns at 575.3754458634163 "$node_(476) setdest 29869 5019 1.0" 
$ns at 607.3830568950651 "$node_(476) setdest 30042 37503 9.0" 
$ns at 662.0456528744933 "$node_(476) setdest 122532 40539 8.0" 
$ns at 766.7050998957434 "$node_(476) setdest 89759 30127 1.0" 
$ns at 802.4106635178539 "$node_(476) setdest 2017 9426 12.0" 
$ns at 424.449229214543 "$node_(477) setdest 40453 12511 1.0" 
$ns at 461.1451577363125 "$node_(477) setdest 125253 5652 18.0" 
$ns at 593.7609119263996 "$node_(477) setdest 76770 32728 12.0" 
$ns at 637.4856845544634 "$node_(477) setdest 56626 22558 7.0" 
$ns at 685.3952642645833 "$node_(477) setdest 8054 28194 1.0" 
$ns at 717.8391303405584 "$node_(477) setdest 3564 25206 16.0" 
$ns at 836.1711216006846 "$node_(477) setdest 125111 4402 14.0" 
$ns at 869.1355213806415 "$node_(477) setdest 85322 1160 16.0" 
$ns at 419.0955150432708 "$node_(478) setdest 43075 9694 3.0" 
$ns at 476.99945562563045 "$node_(478) setdest 117019 11712 1.0" 
$ns at 512.5716515644738 "$node_(478) setdest 69470 8553 18.0" 
$ns at 585.9172603952351 "$node_(478) setdest 73166 8894 3.0" 
$ns at 638.6172988866437 "$node_(478) setdest 121709 26952 1.0" 
$ns at 675.6861060354457 "$node_(478) setdest 85578 42361 14.0" 
$ns at 800.3872393593084 "$node_(478) setdest 13861 38284 17.0" 
$ns at 887.7484056907075 "$node_(478) setdest 80423 15083 3.0" 
$ns at 442.1130435438911 "$node_(479) setdest 22856 30702 17.0" 
$ns at 547.589715169111 "$node_(479) setdest 91553 26178 2.0" 
$ns at 586.3351281740062 "$node_(479) setdest 49775 35298 19.0" 
$ns at 788.5485976440929 "$node_(479) setdest 21163 7758 6.0" 
$ns at 822.8741975547305 "$node_(479) setdest 72317 4456 20.0" 
$ns at 407.2377537430084 "$node_(480) setdest 59208 33283 11.0" 
$ns at 464.72162105936997 "$node_(480) setdest 25700 25493 17.0" 
$ns at 544.6092684509923 "$node_(480) setdest 114336 7193 8.0" 
$ns at 648.573328202325 "$node_(480) setdest 109227 13404 1.0" 
$ns at 688.5384585443702 "$node_(480) setdest 119069 25498 10.0" 
$ns at 809.5433571223489 "$node_(480) setdest 120655 13150 1.0" 
$ns at 844.0321418393853 "$node_(480) setdest 98796 14402 14.0" 
$ns at 436.5615603249738 "$node_(481) setdest 120602 16757 6.0" 
$ns at 483.9198758993144 "$node_(481) setdest 6420 3332 8.0" 
$ns at 564.9147092816 "$node_(481) setdest 70475 34423 2.0" 
$ns at 605.6201262709851 "$node_(481) setdest 109280 31870 1.0" 
$ns at 641.6950090375253 "$node_(481) setdest 10118 18063 3.0" 
$ns at 698.5973004985552 "$node_(481) setdest 11005 37657 14.0" 
$ns at 782.7997253533684 "$node_(481) setdest 35395 29294 17.0" 
$ns at 576.7422550888032 "$node_(482) setdest 999 43185 6.0" 
$ns at 655.2655676598375 "$node_(482) setdest 71011 41816 17.0" 
$ns at 829.0718690873093 "$node_(482) setdest 2968 1423 3.0" 
$ns at 874.8570487513654 "$node_(482) setdest 52327 44124 6.0" 
$ns at 420.9569338528206 "$node_(483) setdest 107471 21318 11.0" 
$ns at 552.7919572934152 "$node_(483) setdest 35169 10195 11.0" 
$ns at 595.7029274759199 "$node_(483) setdest 55688 5333 15.0" 
$ns at 693.884899641473 "$node_(483) setdest 109110 17310 16.0" 
$ns at 853.1320255775829 "$node_(483) setdest 96962 10134 10.0" 
$ns at 472.54155355215835 "$node_(484) setdest 85969 44313 8.0" 
$ns at 545.4228658842312 "$node_(484) setdest 87059 10016 5.0" 
$ns at 576.1494778675643 "$node_(484) setdest 129800 29025 5.0" 
$ns at 609.0068840000272 "$node_(484) setdest 102039 38661 9.0" 
$ns at 723.0321369871303 "$node_(484) setdest 59933 18400 6.0" 
$ns at 779.2751538162536 "$node_(484) setdest 101232 2170 14.0" 
$ns at 832.284496174464 "$node_(484) setdest 66384 2653 12.0" 
$ns at 476.2123243631305 "$node_(485) setdest 52249 16119 7.0" 
$ns at 566.84125845214 "$node_(485) setdest 19338 31071 8.0" 
$ns at 670.0221925469414 "$node_(485) setdest 61833 30986 4.0" 
$ns at 719.7810869115405 "$node_(485) setdest 108671 19408 16.0" 
$ns at 800.9454967319622 "$node_(485) setdest 45864 27319 17.0" 
$ns at 477.31977787115665 "$node_(486) setdest 46720 62 6.0" 
$ns at 524.9635604023904 "$node_(486) setdest 48586 25489 7.0" 
$ns at 593.6515315688102 "$node_(486) setdest 28368 28071 12.0" 
$ns at 696.9580723068833 "$node_(486) setdest 42815 27741 17.0" 
$ns at 808.8642143111963 "$node_(486) setdest 57547 19456 7.0" 
$ns at 887.0426411885599 "$node_(486) setdest 98576 25324 3.0" 
$ns at 443.5333103020704 "$node_(487) setdest 39332 41641 10.0" 
$ns at 520.5175288981634 "$node_(487) setdest 46906 41939 6.0" 
$ns at 588.3103419094666 "$node_(487) setdest 15641 19693 9.0" 
$ns at 685.3610947684739 "$node_(487) setdest 55901 14951 15.0" 
$ns at 864.6851417164976 "$node_(487) setdest 70892 37676 2.0" 
$ns at 403.5910809266147 "$node_(488) setdest 63289 5201 1.0" 
$ns at 440.9977070644329 "$node_(488) setdest 27361 33021 3.0" 
$ns at 487.06158996409783 "$node_(488) setdest 78009 44548 11.0" 
$ns at 612.4085199925389 "$node_(488) setdest 100636 98 16.0" 
$ns at 668.122693374598 "$node_(488) setdest 68734 30950 10.0" 
$ns at 789.1418971390448 "$node_(488) setdest 68539 2728 1.0" 
$ns at 823.9361936390833 "$node_(488) setdest 103230 6874 14.0" 
$ns at 457.1846217619447 "$node_(489) setdest 11531 629 8.0" 
$ns at 544.0041934167981 "$node_(489) setdest 92294 5643 4.0" 
$ns at 576.20307656975 "$node_(489) setdest 76708 34994 13.0" 
$ns at 692.6372365550005 "$node_(489) setdest 45607 29323 17.0" 
$ns at 727.2353478398563 "$node_(489) setdest 25850 28381 13.0" 
$ns at 803.8007206021102 "$node_(489) setdest 83063 17685 12.0" 
$ns at 471.64533107515865 "$node_(490) setdest 15394 25691 2.0" 
$ns at 510.68306520730874 "$node_(490) setdest 18137 35516 19.0" 
$ns at 667.5856869602123 "$node_(490) setdest 120405 23748 20.0" 
$ns at 879.3762735835244 "$node_(490) setdest 98522 16340 5.0" 
$ns at 428.5747237383216 "$node_(491) setdest 108008 28971 16.0" 
$ns at 564.0070350484202 "$node_(491) setdest 76686 22332 1.0" 
$ns at 599.033254430668 "$node_(491) setdest 99129 24604 4.0" 
$ns at 668.8903768291858 "$node_(491) setdest 77005 1675 10.0" 
$ns at 797.3559320635104 "$node_(491) setdest 59126 18654 5.0" 
$ns at 856.2496277512522 "$node_(491) setdest 115943 991 10.0" 
$ns at 444.59409353523114 "$node_(492) setdest 38032 20631 4.0" 
$ns at 506.20312193243154 "$node_(492) setdest 16621 31628 2.0" 
$ns at 555.0023303101786 "$node_(492) setdest 65153 33755 15.0" 
$ns at 706.7651607272783 "$node_(492) setdest 31744 32793 15.0" 
$ns at 741.0904590605355 "$node_(492) setdest 129345 28139 2.0" 
$ns at 787.301411688209 "$node_(492) setdest 101960 29720 17.0" 
$ns at 840.1096855504076 "$node_(492) setdest 60479 25703 15.0" 
$ns at 512.6735288588773 "$node_(493) setdest 65817 26179 17.0" 
$ns at 556.2890786039111 "$node_(493) setdest 113464 29991 9.0" 
$ns at 639.2211664658416 "$node_(493) setdest 4930 42900 7.0" 
$ns at 675.5724958502433 "$node_(493) setdest 99855 33040 12.0" 
$ns at 725.1218798065552 "$node_(493) setdest 82102 40127 1.0" 
$ns at 762.2804252621039 "$node_(493) setdest 39541 1114 11.0" 
$ns at 836.7351631099641 "$node_(493) setdest 86928 31337 15.0" 
$ns at 504.9319216069119 "$node_(494) setdest 13249 8180 12.0" 
$ns at 558.656563815366 "$node_(494) setdest 87929 23686 14.0" 
$ns at 714.3678340353931 "$node_(494) setdest 74389 38044 17.0" 
$ns at 880.973023639382 "$node_(494) setdest 97702 16923 4.0" 
$ns at 402.41360293343894 "$node_(495) setdest 22833 12922 1.0" 
$ns at 432.74873645447263 "$node_(495) setdest 32976 7557 12.0" 
$ns at 549.1533900839602 "$node_(495) setdest 108267 37654 6.0" 
$ns at 633.9771259960912 "$node_(495) setdest 43351 17090 16.0" 
$ns at 666.3268568456356 "$node_(495) setdest 118903 2393 5.0" 
$ns at 735.5068402698719 "$node_(495) setdest 42909 21426 18.0" 
$ns at 860.0292496409712 "$node_(495) setdest 108928 28189 19.0" 
$ns at 440.8067200777154 "$node_(496) setdest 74357 6594 9.0" 
$ns at 532.0105918938955 "$node_(496) setdest 33576 3761 6.0" 
$ns at 585.4136239303834 "$node_(496) setdest 57373 37808 20.0" 
$ns at 717.0376201491532 "$node_(496) setdest 69586 44692 12.0" 
$ns at 761.3469099336116 "$node_(496) setdest 90366 13722 9.0" 
$ns at 874.6237883572999 "$node_(496) setdest 23410 39395 5.0" 
$ns at 404.14337955074757 "$node_(497) setdest 80535 28296 20.0" 
$ns at 627.1097629818868 "$node_(497) setdest 104255 10879 1.0" 
$ns at 661.7630671330519 "$node_(497) setdest 57320 12356 5.0" 
$ns at 698.2322203999988 "$node_(497) setdest 93565 24955 18.0" 
$ns at 405.96744204789735 "$node_(498) setdest 92002 20008 13.0" 
$ns at 563.2536113335105 "$node_(498) setdest 21898 17852 15.0" 
$ns at 695.6443200091708 "$node_(498) setdest 934 20456 6.0" 
$ns at 731.44342513076 "$node_(498) setdest 21321 35344 13.0" 
$ns at 774.3986090278487 "$node_(498) setdest 73693 20872 7.0" 
$ns at 861.649981354885 "$node_(498) setdest 52000 29601 12.0" 
$ns at 897.6209917892398 "$node_(498) setdest 118542 44448 10.0" 
$ns at 475.48304930366305 "$node_(499) setdest 31746 43036 2.0" 
$ns at 510.71561798975836 "$node_(499) setdest 123519 27380 17.0" 
$ns at 670.600983894495 "$node_(499) setdest 54174 10990 10.0" 
$ns at 738.8248662832177 "$node_(499) setdest 125756 26668 9.0" 
$ns at 778.9479278943419 "$node_(499) setdest 104655 33636 17.0" 
$ns at 897.0441340848579 "$node_(499) setdest 110176 39794 9.0" 
$ns at 602.8423282018965 "$node_(500) setdest 31055 8513 6.0" 
$ns at 678.3088729563868 "$node_(500) setdest 114745 15907 18.0" 
$ns at 824.6241401515294 "$node_(500) setdest 34990 21419 12.0" 
$ns at 899.6962672974337 "$node_(500) setdest 90743 30942 15.0" 
$ns at 534.2763895735984 "$node_(501) setdest 93586 24957 10.0" 
$ns at 640.658150875173 "$node_(501) setdest 35698 37045 14.0" 
$ns at 693.6340977851021 "$node_(501) setdest 88678 39789 14.0" 
$ns at 853.3883508471854 "$node_(501) setdest 89046 23730 1.0" 
$ns at 885.9309242653521 "$node_(501) setdest 111618 19202 13.0" 
$ns at 504.93313332866376 "$node_(502) setdest 3760 32544 5.0" 
$ns at 549.3317719620698 "$node_(502) setdest 88942 20263 16.0" 
$ns at 581.3128811188456 "$node_(502) setdest 78581 28925 9.0" 
$ns at 677.2023108365964 "$node_(502) setdest 27322 13193 10.0" 
$ns at 716.4740039214425 "$node_(502) setdest 52294 16061 10.0" 
$ns at 826.2254900808877 "$node_(502) setdest 81423 29086 10.0" 
$ns at 532.9808434830024 "$node_(503) setdest 18574 28657 10.0" 
$ns at 647.6497882468943 "$node_(503) setdest 113041 22467 9.0" 
$ns at 726.7913776907869 "$node_(503) setdest 44789 12473 12.0" 
$ns at 829.6360550525836 "$node_(503) setdest 133475 43006 17.0" 
$ns at 888.9311850259004 "$node_(503) setdest 32702 29846 5.0" 
$ns at 537.5546061168723 "$node_(504) setdest 80178 7240 20.0" 
$ns at 705.1278725047689 "$node_(504) setdest 130142 17512 1.0" 
$ns at 737.5741893674857 "$node_(504) setdest 84961 13413 11.0" 
$ns at 809.4595186073655 "$node_(504) setdest 131789 30100 11.0" 
$ns at 854.198487212112 "$node_(504) setdest 56845 15370 17.0" 
$ns at 541.451448231878 "$node_(505) setdest 87842 13425 11.0" 
$ns at 679.957494446802 "$node_(505) setdest 31580 41304 17.0" 
$ns at 872.6140433321685 "$node_(505) setdest 83633 22747 3.0" 
$ns at 539.6022290010811 "$node_(506) setdest 91964 7952 10.0" 
$ns at 657.2149795485932 "$node_(506) setdest 77106 1277 1.0" 
$ns at 694.5071041255042 "$node_(506) setdest 63306 6520 18.0" 
$ns at 894.8697767420497 "$node_(506) setdest 45421 14750 12.0" 
$ns at 599.0097356382761 "$node_(507) setdest 61322 35740 16.0" 
$ns at 777.1778526224273 "$node_(507) setdest 17299 7443 14.0" 
$ns at 829.631170827306 "$node_(507) setdest 62042 4889 1.0" 
$ns at 866.9866862964531 "$node_(507) setdest 96448 40107 12.0" 
$ns at 655.7996600356396 "$node_(508) setdest 131658 30324 2.0" 
$ns at 694.0994252649251 "$node_(508) setdest 75879 10901 2.0" 
$ns at 733.4883434184131 "$node_(508) setdest 55947 24085 15.0" 
$ns at 834.8356272763035 "$node_(508) setdest 105219 1083 19.0" 
$ns at 550.2336026460122 "$node_(509) setdest 102271 3203 9.0" 
$ns at 629.2918469762517 "$node_(509) setdest 15110 3326 8.0" 
$ns at 726.6638377314932 "$node_(509) setdest 21949 26962 6.0" 
$ns at 777.8154835553403 "$node_(509) setdest 30261 14485 14.0" 
$ns at 845.4383697907778 "$node_(509) setdest 14871 1564 3.0" 
$ns at 888.7130597758086 "$node_(509) setdest 15957 13415 19.0" 
$ns at 563.3692890028569 "$node_(510) setdest 103238 17190 2.0" 
$ns at 593.9358335879405 "$node_(510) setdest 123202 30341 20.0" 
$ns at 723.2684893166138 "$node_(510) setdest 112819 38781 15.0" 
$ns at 802.874380969771 "$node_(510) setdest 90063 31482 12.0" 
$ns at 613.2350249033598 "$node_(511) setdest 108196 5819 17.0" 
$ns at 810.8765886962428 "$node_(511) setdest 73758 23822 10.0" 
$ns at 846.6780823658456 "$node_(511) setdest 113531 37749 7.0" 
$ns at 501.3647471915788 "$node_(512) setdest 125166 38390 5.0" 
$ns at 545.9253447694571 "$node_(512) setdest 127937 37099 1.0" 
$ns at 582.2906449224903 "$node_(512) setdest 5516 17164 13.0" 
$ns at 725.4923953154671 "$node_(512) setdest 16284 25227 11.0" 
$ns at 783.7724698619742 "$node_(512) setdest 83494 27634 17.0" 
$ns at 851.0950386535246 "$node_(512) setdest 86959 28207 7.0" 
$ns at 566.3439556995445 "$node_(513) setdest 28960 10592 3.0" 
$ns at 614.0121015024725 "$node_(513) setdest 47041 7038 11.0" 
$ns at 646.126801812185 "$node_(513) setdest 32140 11550 11.0" 
$ns at 767.2517096708393 "$node_(513) setdest 56611 20315 18.0" 
$ns at 803.9605322666633 "$node_(513) setdest 102786 21467 5.0" 
$ns at 850.8347581537637 "$node_(513) setdest 9815 16713 16.0" 
$ns at 554.3425688637119 "$node_(514) setdest 72869 22060 4.0" 
$ns at 617.318359311121 "$node_(514) setdest 64674 14156 16.0" 
$ns at 777.793894564035 "$node_(514) setdest 106690 39367 7.0" 
$ns at 853.6892009057451 "$node_(514) setdest 130627 22776 15.0" 
$ns at 503.60272111980316 "$node_(515) setdest 29375 11739 18.0" 
$ns at 561.903120922112 "$node_(515) setdest 29058 14068 11.0" 
$ns at 598.0923346242721 "$node_(515) setdest 118310 12171 14.0" 
$ns at 703.5899778892324 "$node_(515) setdest 33409 41347 6.0" 
$ns at 778.2310630417703 "$node_(515) setdest 66833 17841 1.0" 
$ns at 814.8048210961414 "$node_(515) setdest 24208 27509 6.0" 
$ns at 873.0802881030803 "$node_(515) setdest 111018 2811 11.0" 
$ns at 555.1158493873868 "$node_(516) setdest 20496 25371 12.0" 
$ns at 654.989955844089 "$node_(516) setdest 1063 34412 1.0" 
$ns at 689.6697157355896 "$node_(516) setdest 28254 15896 6.0" 
$ns at 755.4017475811258 "$node_(516) setdest 123242 38699 13.0" 
$ns at 505.0809394340535 "$node_(517) setdest 21195 35756 11.0" 
$ns at 615.8664506362476 "$node_(517) setdest 5178 20458 3.0" 
$ns at 660.1998417891136 "$node_(517) setdest 95681 4248 1.0" 
$ns at 690.7000792259626 "$node_(517) setdest 132071 22655 6.0" 
$ns at 764.2675436306295 "$node_(517) setdest 31474 26768 15.0" 
$ns at 657.7389249062508 "$node_(518) setdest 99470 41678 19.0" 
$ns at 764.6377408502563 "$node_(518) setdest 9866 40480 5.0" 
$ns at 839.0792148462484 "$node_(518) setdest 68575 37314 14.0" 
$ns at 539.273715803262 "$node_(519) setdest 562 20699 9.0" 
$ns at 629.3416783718316 "$node_(519) setdest 46745 9405 10.0" 
$ns at 689.5295538958702 "$node_(519) setdest 37331 40625 2.0" 
$ns at 725.1117660410873 "$node_(519) setdest 13713 31554 18.0" 
$ns at 850.6497944583809 "$node_(519) setdest 62886 35428 1.0" 
$ns at 888.5446148437431 "$node_(519) setdest 47353 31868 1.0" 
$ns at 530.3267836039988 "$node_(520) setdest 1850 13825 11.0" 
$ns at 619.1227286040432 "$node_(520) setdest 115379 42020 7.0" 
$ns at 704.54827097102 "$node_(520) setdest 95341 22193 14.0" 
$ns at 793.2153982393015 "$node_(520) setdest 12959 35202 20.0" 
$ns at 560.3089598769963 "$node_(521) setdest 20382 39373 3.0" 
$ns at 593.7468532634691 "$node_(521) setdest 94606 3760 3.0" 
$ns at 651.8665288923163 "$node_(521) setdest 129169 6785 4.0" 
$ns at 713.0494002766653 "$node_(521) setdest 109895 15537 11.0" 
$ns at 843.3848531471833 "$node_(521) setdest 8499 551 15.0" 
$ns at 510.23143362330836 "$node_(522) setdest 26261 26019 4.0" 
$ns at 578.3283807673812 "$node_(522) setdest 69959 25953 10.0" 
$ns at 632.1907163324014 "$node_(522) setdest 26492 40331 14.0" 
$ns at 695.2025937891532 "$node_(522) setdest 54778 22089 6.0" 
$ns at 734.9995880546801 "$node_(522) setdest 46176 25124 11.0" 
$ns at 788.1909054265919 "$node_(522) setdest 110263 9961 14.0" 
$ns at 871.6875405582882 "$node_(522) setdest 20842 33489 10.0" 
$ns at 633.4096434265025 "$node_(523) setdest 5251 19276 1.0" 
$ns at 666.0721314618582 "$node_(523) setdest 52202 38826 19.0" 
$ns at 701.2539524300242 "$node_(523) setdest 71139 24761 7.0" 
$ns at 795.1172825132705 "$node_(523) setdest 133613 44086 6.0" 
$ns at 868.083323437038 "$node_(523) setdest 61338 19042 8.0" 
$ns at 650.562900537944 "$node_(524) setdest 124267 43303 18.0" 
$ns at 687.1557104148243 "$node_(524) setdest 127447 27797 14.0" 
$ns at 787.7257131176149 "$node_(524) setdest 63502 8353 19.0" 
$ns at 843.3712832130486 "$node_(524) setdest 84406 20681 3.0" 
$ns at 889.4063160590134 "$node_(524) setdest 73013 4285 6.0" 
$ns at 552.0945230642882 "$node_(525) setdest 107926 20196 13.0" 
$ns at 685.5848104964675 "$node_(525) setdest 127822 5109 8.0" 
$ns at 763.7355235643729 "$node_(525) setdest 121092 23362 9.0" 
$ns at 836.530231303104 "$node_(525) setdest 69710 43404 1.0" 
$ns at 873.1731184268388 "$node_(525) setdest 129552 43331 19.0" 
$ns at 579.94381906279 "$node_(526) setdest 33454 34674 20.0" 
$ns at 747.3669750342337 "$node_(526) setdest 56049 40066 4.0" 
$ns at 813.4856071199054 "$node_(526) setdest 23469 33033 20.0" 
$ns at 578.3016684342174 "$node_(527) setdest 62223 19601 5.0" 
$ns at 639.2095665708762 "$node_(527) setdest 122455 8329 3.0" 
$ns at 682.0302071260561 "$node_(527) setdest 89485 36991 6.0" 
$ns at 732.72010319331 "$node_(527) setdest 96449 22237 3.0" 
$ns at 769.8686639742767 "$node_(527) setdest 125430 41463 11.0" 
$ns at 832.5161368215768 "$node_(527) setdest 32535 43573 13.0" 
$ns at 513.3445994169656 "$node_(528) setdest 49899 17011 4.0" 
$ns at 558.1516171576444 "$node_(528) setdest 119830 27034 17.0" 
$ns at 693.6204420315511 "$node_(528) setdest 12061 18845 19.0" 
$ns at 504.4086235963967 "$node_(529) setdest 7657 25603 2.0" 
$ns at 549.5023120743356 "$node_(529) setdest 70751 7973 6.0" 
$ns at 591.9133734910143 "$node_(529) setdest 13659 33629 12.0" 
$ns at 630.2390686402836 "$node_(529) setdest 118206 13758 1.0" 
$ns at 660.3766995521219 "$node_(529) setdest 10405 33132 6.0" 
$ns at 738.5808789757561 "$node_(529) setdest 8095 10706 10.0" 
$ns at 820.7030359419562 "$node_(529) setdest 113649 14317 13.0" 
$ns at 874.3932505265635 "$node_(529) setdest 74926 35165 14.0" 
$ns at 546.5096805996645 "$node_(530) setdest 68883 28287 2.0" 
$ns at 590.5225280347906 "$node_(530) setdest 23004 34328 16.0" 
$ns at 639.8162941589567 "$node_(530) setdest 24894 2324 17.0" 
$ns at 746.2966584314297 "$node_(530) setdest 115719 11092 1.0" 
$ns at 785.807302617292 "$node_(530) setdest 60272 24039 16.0" 
$ns at 856.3886334808604 "$node_(530) setdest 44960 20500 8.0" 
$ns at 564.921167469309 "$node_(531) setdest 118153 38773 8.0" 
$ns at 606.2315096834608 "$node_(531) setdest 66478 31685 13.0" 
$ns at 720.6466888107309 "$node_(531) setdest 124344 15678 3.0" 
$ns at 765.7669738359753 "$node_(531) setdest 38942 25006 1.0" 
$ns at 801.7637130422696 "$node_(531) setdest 9512 35146 1.0" 
$ns at 834.713754532417 "$node_(531) setdest 86879 12611 18.0" 
$ns at 533.6899645547545 "$node_(532) setdest 110631 24058 2.0" 
$ns at 581.73121530842 "$node_(532) setdest 3467 12670 17.0" 
$ns at 689.0198497718455 "$node_(532) setdest 118029 30005 14.0" 
$ns at 802.3677072695492 "$node_(532) setdest 109136 40695 16.0" 
$ns at 869.3993468064359 "$node_(532) setdest 55126 23290 5.0" 
$ns at 539.3655576911001 "$node_(533) setdest 122088 3723 1.0" 
$ns at 578.5442620257237 "$node_(533) setdest 63012 5367 15.0" 
$ns at 747.473542611002 "$node_(533) setdest 103220 33916 5.0" 
$ns at 792.2674224461417 "$node_(533) setdest 68257 36661 8.0" 
$ns at 861.8116638471106 "$node_(533) setdest 67125 23659 19.0" 
$ns at 660.2522639417182 "$node_(534) setdest 110376 17448 1.0" 
$ns at 694.7647192291978 "$node_(534) setdest 102393 25331 8.0" 
$ns at 730.5468102834841 "$node_(534) setdest 32199 19521 6.0" 
$ns at 815.0160758474331 "$node_(534) setdest 123174 240 11.0" 
$ns at 512.8792634465387 "$node_(535) setdest 14343 39714 4.0" 
$ns at 578.4155776123804 "$node_(535) setdest 29489 16640 10.0" 
$ns at 693.42667077968 "$node_(535) setdest 51422 33238 1.0" 
$ns at 726.133616560106 "$node_(535) setdest 29488 10266 9.0" 
$ns at 787.7079368453674 "$node_(535) setdest 36801 24047 17.0" 
$ns at 844.0377200568009 "$node_(535) setdest 60912 16169 16.0" 
$ns at 597.1283079023744 "$node_(536) setdest 4438 35983 1.0" 
$ns at 632.5653822663414 "$node_(536) setdest 72431 14253 12.0" 
$ns at 732.1510084101346 "$node_(536) setdest 128880 14111 20.0" 
$ns at 877.5405590071166 "$node_(536) setdest 129642 9260 11.0" 
$ns at 554.628144435837 "$node_(537) setdest 24585 27483 15.0" 
$ns at 643.6851341095798 "$node_(537) setdest 77470 10136 8.0" 
$ns at 703.7067885533646 "$node_(537) setdest 25717 5782 7.0" 
$ns at 763.6119233132066 "$node_(537) setdest 118517 28405 4.0" 
$ns at 823.2078228507391 "$node_(537) setdest 18237 29499 6.0" 
$ns at 866.9954239882569 "$node_(537) setdest 95409 22032 8.0" 
$ns at 545.5312325371957 "$node_(538) setdest 48392 33901 17.0" 
$ns at 691.811353470813 "$node_(538) setdest 66216 19193 7.0" 
$ns at 727.599340928537 "$node_(538) setdest 37510 10169 2.0" 
$ns at 773.6304049208911 "$node_(538) setdest 64128 24640 11.0" 
$ns at 896.4823389528583 "$node_(538) setdest 75642 17348 2.0" 
$ns at 590.1242516781324 "$node_(539) setdest 68528 40548 6.0" 
$ns at 669.284421786459 "$node_(539) setdest 121429 43961 7.0" 
$ns at 769.1224091478009 "$node_(539) setdest 76543 7100 18.0" 
$ns at 810.0136114396652 "$node_(539) setdest 103890 12168 1.0" 
$ns at 840.6591822906914 "$node_(539) setdest 84346 25351 4.0" 
$ns at 547.1197053522772 "$node_(540) setdest 114722 2370 1.0" 
$ns at 584.5074820372311 "$node_(540) setdest 12730 35936 8.0" 
$ns at 694.0526611723544 "$node_(540) setdest 89443 12297 16.0" 
$ns at 878.5420314692115 "$node_(540) setdest 4942 30109 14.0" 
$ns at 555.495009796048 "$node_(541) setdest 28777 8284 3.0" 
$ns at 594.6122483509404 "$node_(541) setdest 5751 25105 4.0" 
$ns at 646.9744703998147 "$node_(541) setdest 10933 20101 6.0" 
$ns at 679.8165924490729 "$node_(541) setdest 125272 29522 10.0" 
$ns at 792.0927091798674 "$node_(541) setdest 95442 15636 10.0" 
$ns at 867.6613489335207 "$node_(541) setdest 124845 33162 3.0" 
$ns at 531.7449327607623 "$node_(542) setdest 113238 5720 9.0" 
$ns at 637.3669418313225 "$node_(542) setdest 84937 12296 2.0" 
$ns at 684.3934258929495 "$node_(542) setdest 48631 10330 12.0" 
$ns at 833.2568821574415 "$node_(542) setdest 113574 22587 14.0" 
$ns at 566.3226485278548 "$node_(543) setdest 103589 10163 13.0" 
$ns at 668.5865021203583 "$node_(543) setdest 41065 25047 15.0" 
$ns at 809.9195062672356 "$node_(543) setdest 96158 14680 18.0" 
$ns at 530.0238665050206 "$node_(544) setdest 84408 1962 1.0" 
$ns at 568.6313366502039 "$node_(544) setdest 41086 14849 2.0" 
$ns at 605.3853442472129 "$node_(544) setdest 56070 4152 12.0" 
$ns at 717.3640317327178 "$node_(544) setdest 90009 22196 17.0" 
$ns at 768.2711452092423 "$node_(544) setdest 62733 4660 16.0" 
$ns at 569.9895796317809 "$node_(545) setdest 65510 41606 3.0" 
$ns at 618.648958636313 "$node_(545) setdest 56160 29736 10.0" 
$ns at 668.3152720341468 "$node_(545) setdest 79652 30503 17.0" 
$ns at 826.4714494344123 "$node_(545) setdest 105134 4966 11.0" 
$ns at 513.3100073490591 "$node_(546) setdest 126818 13918 6.0" 
$ns at 558.3995756670425 "$node_(546) setdest 8278 5935 19.0" 
$ns at 613.9956070775359 "$node_(546) setdest 46782 41916 15.0" 
$ns at 663.5779554413357 "$node_(546) setdest 18999 22177 19.0" 
$ns at 760.3445663282051 "$node_(546) setdest 62219 32648 19.0" 
$ns at 582.6893021983611 "$node_(547) setdest 44675 25738 16.0" 
$ns at 708.8197689808985 "$node_(547) setdest 77143 41561 15.0" 
$ns at 793.7808391840488 "$node_(547) setdest 112925 20750 2.0" 
$ns at 835.487973612153 "$node_(547) setdest 120772 27585 15.0" 
$ns at 576.2191094933971 "$node_(548) setdest 33207 29676 8.0" 
$ns at 606.5409086524548 "$node_(548) setdest 23185 41523 14.0" 
$ns at 702.715744793408 "$node_(548) setdest 51127 42960 5.0" 
$ns at 776.3253997569242 "$node_(548) setdest 2091 2770 4.0" 
$ns at 827.1293521308613 "$node_(548) setdest 19209 28869 9.0" 
$ns at 618.2877495559792 "$node_(549) setdest 97672 32677 4.0" 
$ns at 650.58989278217 "$node_(549) setdest 88895 15855 4.0" 
$ns at 688.6911628273999 "$node_(549) setdest 132864 11306 17.0" 
$ns at 740.5918891622132 "$node_(549) setdest 36017 13516 6.0" 
$ns at 792.6434852148317 "$node_(549) setdest 87538 7749 10.0" 
$ns at 505.6970106793066 "$node_(550) setdest 60997 26545 18.0" 
$ns at 554.9020979407803 "$node_(550) setdest 57968 28421 16.0" 
$ns at 641.8322810468566 "$node_(550) setdest 20060 6283 14.0" 
$ns at 754.1852292663917 "$node_(550) setdest 126500 9987 12.0" 
$ns at 852.4699708465109 "$node_(550) setdest 129308 21443 12.0" 
$ns at 546.9458580304506 "$node_(551) setdest 90893 37571 2.0" 
$ns at 578.1940747769377 "$node_(551) setdest 101771 13865 1.0" 
$ns at 609.5409122418585 "$node_(551) setdest 108539 16724 1.0" 
$ns at 647.109349222454 "$node_(551) setdest 41451 36268 15.0" 
$ns at 821.5041199320513 "$node_(551) setdest 31013 14432 19.0" 
$ns at 584.0343022655577 "$node_(552) setdest 9413 8989 10.0" 
$ns at 680.2563054409575 "$node_(552) setdest 2352 41503 14.0" 
$ns at 772.7844675227967 "$node_(552) setdest 117475 43786 14.0" 
$ns at 860.4368918199483 "$node_(552) setdest 130192 39162 5.0" 
$ns at 534.7335186379481 "$node_(553) setdest 41369 42856 14.0" 
$ns at 614.7141253550942 "$node_(553) setdest 58580 33865 12.0" 
$ns at 760.441882977058 "$node_(553) setdest 62982 158 7.0" 
$ns at 806.9326854191058 "$node_(553) setdest 57015 10180 9.0" 
$ns at 520.2040120037017 "$node_(554) setdest 99149 19809 8.0" 
$ns at 568.8505226346774 "$node_(554) setdest 94650 1955 12.0" 
$ns at 651.7181962008386 "$node_(554) setdest 130134 27948 20.0" 
$ns at 742.4712211460114 "$node_(554) setdest 117190 40695 19.0" 
$ns at 883.2968109046138 "$node_(554) setdest 35601 14609 1.0" 
$ns at 536.3334686691005 "$node_(555) setdest 92688 8039 15.0" 
$ns at 603.5932936503318 "$node_(555) setdest 72604 32499 15.0" 
$ns at 667.2257269444473 "$node_(555) setdest 108077 3713 1.0" 
$ns at 704.5229041364845 "$node_(555) setdest 8667 39076 6.0" 
$ns at 774.660227261038 "$node_(555) setdest 31654 23701 15.0" 
$ns at 886.6281348701272 "$node_(555) setdest 42939 42536 13.0" 
$ns at 512.2505495058657 "$node_(556) setdest 88754 9865 6.0" 
$ns at 574.4139515568484 "$node_(556) setdest 65059 34896 18.0" 
$ns at 650.2363074263657 "$node_(556) setdest 126137 22657 7.0" 
$ns at 742.4803318594268 "$node_(556) setdest 45587 39764 5.0" 
$ns at 820.9109177391982 "$node_(556) setdest 8096 28648 7.0" 
$ns at 884.7513749915995 "$node_(556) setdest 78646 24852 19.0" 
$ns at 521.1411307420717 "$node_(557) setdest 36105 15826 5.0" 
$ns at 582.6154671630244 "$node_(557) setdest 78215 8656 8.0" 
$ns at 666.9243046882325 "$node_(557) setdest 74841 18049 16.0" 
$ns at 855.1495544103332 "$node_(557) setdest 65934 8127 16.0" 
$ns at 552.8435211935672 "$node_(558) setdest 71759 7639 12.0" 
$ns at 602.3417690926851 "$node_(558) setdest 39950 37226 16.0" 
$ns at 747.579964354489 "$node_(558) setdest 62515 10427 6.0" 
$ns at 810.2469387586334 "$node_(558) setdest 27324 43011 3.0" 
$ns at 847.214735753452 "$node_(558) setdest 130189 16716 3.0" 
$ns at 883.9984211129465 "$node_(558) setdest 57816 23837 17.0" 
$ns at 619.3375439552688 "$node_(559) setdest 121136 35039 12.0" 
$ns at 737.5647147907127 "$node_(559) setdest 39222 16588 9.0" 
$ns at 839.7779839019584 "$node_(559) setdest 33833 21372 12.0" 
$ns at 572.9846827075056 "$node_(560) setdest 22444 22083 17.0" 
$ns at 723.7751123936339 "$node_(560) setdest 5278 28568 3.0" 
$ns at 767.2169926822991 "$node_(560) setdest 128654 17032 6.0" 
$ns at 849.7971223948919 "$node_(560) setdest 51759 13980 13.0" 
$ns at 544.8823746434789 "$node_(561) setdest 94082 31635 5.0" 
$ns at 575.717423488092 "$node_(561) setdest 119931 2263 10.0" 
$ns at 691.0810555399684 "$node_(561) setdest 117206 13320 6.0" 
$ns at 769.5286745103319 "$node_(561) setdest 5181 34290 12.0" 
$ns at 886.4214635471969 "$node_(561) setdest 42338 28906 18.0" 
$ns at 504.28899027860245 "$node_(562) setdest 123831 35661 12.0" 
$ns at 589.2237393825056 "$node_(562) setdest 48122 39032 5.0" 
$ns at 656.0087789200395 "$node_(562) setdest 100619 3876 5.0" 
$ns at 703.4821716304917 "$node_(562) setdest 116383 10637 19.0" 
$ns at 786.4936698165728 "$node_(562) setdest 93138 38457 11.0" 
$ns at 861.5481195181918 "$node_(562) setdest 81019 28784 6.0" 
$ns at 512.048988692095 "$node_(563) setdest 108095 42894 18.0" 
$ns at 589.1048465946363 "$node_(563) setdest 82748 17075 1.0" 
$ns at 619.3762940084019 "$node_(563) setdest 123408 9764 5.0" 
$ns at 656.0270311352122 "$node_(563) setdest 88949 8412 19.0" 
$ns at 856.6026418265675 "$node_(563) setdest 47330 12796 9.0" 
$ns at 550.7696053829263 "$node_(564) setdest 10854 40695 6.0" 
$ns at 600.4499410251437 "$node_(564) setdest 125513 25240 8.0" 
$ns at 663.9504255989542 "$node_(564) setdest 107364 42976 10.0" 
$ns at 747.1835489735392 "$node_(564) setdest 99287 13761 5.0" 
$ns at 779.0332981179683 "$node_(564) setdest 130024 18330 5.0" 
$ns at 846.7464186320192 "$node_(564) setdest 126421 14610 13.0" 
$ns at 502.4645138266977 "$node_(565) setdest 20254 22652 2.0" 
$ns at 549.4960142903612 "$node_(565) setdest 31311 1306 16.0" 
$ns at 649.1122764086161 "$node_(565) setdest 127293 20086 17.0" 
$ns at 751.3888481239826 "$node_(565) setdest 42086 101 1.0" 
$ns at 785.522233101263 "$node_(565) setdest 81914 28472 12.0" 
$ns at 836.0977972196961 "$node_(565) setdest 113624 42356 3.0" 
$ns at 884.8900950925224 "$node_(565) setdest 89576 1140 3.0" 
$ns at 565.3034797346045 "$node_(566) setdest 75784 12301 17.0" 
$ns at 741.5139232458652 "$node_(566) setdest 72234 34063 14.0" 
$ns at 882.7487511715293 "$node_(566) setdest 82611 37043 18.0" 
$ns at 596.6611137590128 "$node_(567) setdest 47066 9393 4.0" 
$ns at 636.5814187494773 "$node_(567) setdest 27118 23727 8.0" 
$ns at 676.059063068846 "$node_(567) setdest 125767 28221 11.0" 
$ns at 707.9774046295902 "$node_(567) setdest 32392 12074 6.0" 
$ns at 769.338302754937 "$node_(567) setdest 8480 14059 1.0" 
$ns at 800.7481590376524 "$node_(567) setdest 11005 9362 14.0" 
$ns at 567.943351762262 "$node_(568) setdest 16577 12189 9.0" 
$ns at 629.4185805955378 "$node_(568) setdest 53127 42703 12.0" 
$ns at 699.8730950788403 "$node_(568) setdest 76419 43177 8.0" 
$ns at 757.9637249787413 "$node_(568) setdest 40905 39966 8.0" 
$ns at 814.9063079200027 "$node_(568) setdest 129036 37506 18.0" 
$ns at 600.7219887605138 "$node_(569) setdest 102565 34714 13.0" 
$ns at 669.397353769345 "$node_(569) setdest 34423 35780 14.0" 
$ns at 767.9611314207046 "$node_(569) setdest 59817 18979 7.0" 
$ns at 856.3727268406088 "$node_(569) setdest 16847 12786 10.0" 
$ns at 511.9672498398704 "$node_(570) setdest 15577 30161 2.0" 
$ns at 543.8696040698146 "$node_(570) setdest 91398 19964 9.0" 
$ns at 658.3408710924995 "$node_(570) setdest 65999 30606 6.0" 
$ns at 708.9042671833118 "$node_(570) setdest 129327 5612 12.0" 
$ns at 793.3603778846365 "$node_(570) setdest 40935 27137 2.0" 
$ns at 836.5099155716065 "$node_(570) setdest 92413 41354 10.0" 
$ns at 550.8526707177798 "$node_(571) setdest 119387 11262 8.0" 
$ns at 624.7792954167455 "$node_(571) setdest 47750 40512 18.0" 
$ns at 772.7540276206423 "$node_(571) setdest 25489 28457 20.0" 
$ns at 507.2247623186993 "$node_(572) setdest 127995 43227 6.0" 
$ns at 588.7485250112413 "$node_(572) setdest 10735 24959 15.0" 
$ns at 766.4265450760596 "$node_(572) setdest 36872 15979 9.0" 
$ns at 840.7916290840839 "$node_(572) setdest 109566 19991 15.0" 
$ns at 562.8367965175999 "$node_(573) setdest 61609 37130 1.0" 
$ns at 594.0157276290747 "$node_(573) setdest 7901 2848 12.0" 
$ns at 635.7792186252783 "$node_(573) setdest 61222 34509 1.0" 
$ns at 670.2105152695066 "$node_(573) setdest 51933 13916 10.0" 
$ns at 753.1497597144144 "$node_(573) setdest 53670 16569 16.0" 
$ns at 837.2010209954005 "$node_(573) setdest 40479 35061 8.0" 
$ns at 884.746981869121 "$node_(573) setdest 12363 34090 13.0" 
$ns at 508.832217316821 "$node_(574) setdest 32236 43446 18.0" 
$ns at 653.476251176693 "$node_(574) setdest 20127 23029 16.0" 
$ns at 717.5933833289748 "$node_(574) setdest 10155 5347 4.0" 
$ns at 784.6468052011165 "$node_(574) setdest 65684 19087 13.0" 
$ns at 532.3922238343287 "$node_(575) setdest 4388 5182 14.0" 
$ns at 607.2198982311954 "$node_(575) setdest 31547 15710 2.0" 
$ns at 645.2956360221136 "$node_(575) setdest 39319 18648 6.0" 
$ns at 721.7905397291943 "$node_(575) setdest 113244 2474 17.0" 
$ns at 794.159571409536 "$node_(575) setdest 77628 6737 12.0" 
$ns at 523.0827155244667 "$node_(576) setdest 78710 5005 4.0" 
$ns at 569.693282064554 "$node_(576) setdest 111412 6925 2.0" 
$ns at 618.2688572030675 "$node_(576) setdest 98174 26431 10.0" 
$ns at 726.1865155438079 "$node_(576) setdest 5095 33435 8.0" 
$ns at 758.4052301023542 "$node_(576) setdest 44234 2893 2.0" 
$ns at 797.465680077266 "$node_(576) setdest 98061 43979 19.0" 
$ns at 512.7957356542529 "$node_(577) setdest 39177 40599 3.0" 
$ns at 551.7711178371684 "$node_(577) setdest 24122 39926 13.0" 
$ns at 652.518053070435 "$node_(577) setdest 86825 3648 14.0" 
$ns at 733.4148824153449 "$node_(577) setdest 87221 5518 6.0" 
$ns at 792.7867205811415 "$node_(577) setdest 54602 16344 7.0" 
$ns at 873.7992243320408 "$node_(577) setdest 36092 23422 9.0" 
$ns at 531.4771059001316 "$node_(578) setdest 53444 33918 15.0" 
$ns at 639.4311461627092 "$node_(578) setdest 72671 40567 18.0" 
$ns at 750.3390800317047 "$node_(578) setdest 19167 10758 6.0" 
$ns at 834.6773213905988 "$node_(578) setdest 131398 37571 8.0" 
$ns at 872.70138947566 "$node_(578) setdest 21037 6072 2.0" 
$ns at 562.4690110049769 "$node_(579) setdest 26107 11970 16.0" 
$ns at 674.6799514630565 "$node_(579) setdest 131004 19097 6.0" 
$ns at 739.7729861757875 "$node_(579) setdest 17010 39903 15.0" 
$ns at 790.4104993570323 "$node_(579) setdest 84522 12271 19.0" 
$ns at 829.6457949813085 "$node_(579) setdest 95557 8490 14.0" 
$ns at 868.5145584124722 "$node_(579) setdest 45003 44460 14.0" 
$ns at 565.7822827830586 "$node_(580) setdest 6675 5116 4.0" 
$ns at 600.3244790086392 "$node_(580) setdest 7692 39823 2.0" 
$ns at 642.1826916588846 "$node_(580) setdest 102547 23670 8.0" 
$ns at 679.2041902198359 "$node_(580) setdest 72923 37801 13.0" 
$ns at 747.9120857157038 "$node_(580) setdest 22535 34824 8.0" 
$ns at 810.8638850326696 "$node_(580) setdest 69015 20480 19.0" 
$ns at 503.7405694823919 "$node_(581) setdest 87442 34479 16.0" 
$ns at 559.4487114946005 "$node_(581) setdest 118540 24366 9.0" 
$ns at 637.2402775933608 "$node_(581) setdest 121447 40614 20.0" 
$ns at 711.5851513489096 "$node_(581) setdest 100029 12359 7.0" 
$ns at 776.8874166765708 "$node_(581) setdest 21871 36008 6.0" 
$ns at 842.7345723285421 "$node_(581) setdest 130951 31523 12.0" 
$ns at 515.5366008323193 "$node_(582) setdest 9896 9565 16.0" 
$ns at 601.7824027221316 "$node_(582) setdest 77359 12541 11.0" 
$ns at 644.1588324344666 "$node_(582) setdest 80571 27178 6.0" 
$ns at 709.9167797169791 "$node_(582) setdest 52247 18114 4.0" 
$ns at 776.3760494463413 "$node_(582) setdest 85498 32870 12.0" 
$ns at 892.9822937980038 "$node_(582) setdest 14814 599 19.0" 
$ns at 557.0260301906335 "$node_(583) setdest 18780 7147 18.0" 
$ns at 631.6473840908488 "$node_(583) setdest 130414 20337 20.0" 
$ns at 721.622416604026 "$node_(583) setdest 33035 31617 12.0" 
$ns at 801.3091678630842 "$node_(583) setdest 7985 12056 18.0" 
$ns at 507.9887499191468 "$node_(584) setdest 128065 30178 18.0" 
$ns at 563.7201181621916 "$node_(584) setdest 100047 18290 1.0" 
$ns at 594.2526907652402 "$node_(584) setdest 3507 13709 19.0" 
$ns at 727.2477975072046 "$node_(584) setdest 51280 10826 17.0" 
$ns at 824.8991942580568 "$node_(584) setdest 67849 29453 4.0" 
$ns at 870.6225200593647 "$node_(584) setdest 50230 19230 7.0" 
$ns at 508.59458287628075 "$node_(585) setdest 89688 20138 19.0" 
$ns at 682.3980896887283 "$node_(585) setdest 63089 13946 9.0" 
$ns at 744.6348623637477 "$node_(585) setdest 44989 34633 12.0" 
$ns at 849.6366962237965 "$node_(585) setdest 112615 40529 17.0" 
$ns at 635.744597248552 "$node_(586) setdest 47049 20318 5.0" 
$ns at 701.1908175154725 "$node_(586) setdest 325 4664 17.0" 
$ns at 776.1926483337609 "$node_(586) setdest 37615 26526 16.0" 
$ns at 880.970638922871 "$node_(586) setdest 26902 28102 11.0" 
$ns at 505.3562355663331 "$node_(587) setdest 40481 382 1.0" 
$ns at 544.5766402221305 "$node_(587) setdest 61956 35469 1.0" 
$ns at 577.5008949142891 "$node_(587) setdest 56401 3114 1.0" 
$ns at 612.9418036415645 "$node_(587) setdest 88886 43450 17.0" 
$ns at 729.7964446246826 "$node_(587) setdest 34681 28576 7.0" 
$ns at 810.6174429850521 "$node_(587) setdest 51148 4488 8.0" 
$ns at 505.07744032917344 "$node_(588) setdest 113524 44174 6.0" 
$ns at 557.8916176239038 "$node_(588) setdest 48510 39674 20.0" 
$ns at 618.2470186605029 "$node_(588) setdest 70920 3496 18.0" 
$ns at 694.7239910240746 "$node_(588) setdest 39314 27552 4.0" 
$ns at 750.9545197562297 "$node_(588) setdest 60776 39924 17.0" 
$ns at 575.9407153813519 "$node_(589) setdest 100426 37711 19.0" 
$ns at 626.2800179269998 "$node_(589) setdest 77619 4430 2.0" 
$ns at 673.5807401046363 "$node_(589) setdest 15408 40366 15.0" 
$ns at 741.4453632294188 "$node_(589) setdest 51976 35 18.0" 
$ns at 564.1431022968089 "$node_(590) setdest 13812 31973 20.0" 
$ns at 707.1580796188254 "$node_(590) setdest 17196 33642 9.0" 
$ns at 758.1212553430845 "$node_(590) setdest 9984 40017 18.0" 
$ns at 552.7644995032169 "$node_(591) setdest 45762 11477 1.0" 
$ns at 591.8811700377188 "$node_(591) setdest 132279 12529 1.0" 
$ns at 626.0215386868614 "$node_(591) setdest 31938 13264 18.0" 
$ns at 834.297786919945 "$node_(591) setdest 116853 2305 8.0" 
$ns at 664.951916619937 "$node_(592) setdest 64883 41561 6.0" 
$ns at 744.0546606182904 "$node_(592) setdest 3770 5701 3.0" 
$ns at 785.5268451748486 "$node_(592) setdest 8793 4173 1.0" 
$ns at 818.2948791507658 "$node_(592) setdest 9487 36695 1.0" 
$ns at 848.9324500780958 "$node_(592) setdest 126892 16834 12.0" 
$ns at 554.8065018486051 "$node_(593) setdest 55487 2459 11.0" 
$ns at 611.9007122822594 "$node_(593) setdest 85913 33817 8.0" 
$ns at 656.9367550529656 "$node_(593) setdest 80476 27652 2.0" 
$ns at 688.5706090502425 "$node_(593) setdest 22792 24881 5.0" 
$ns at 763.989455591613 "$node_(593) setdest 119532 1773 17.0" 
$ns at 820.4151310128419 "$node_(593) setdest 97329 20323 15.0" 
$ns at 503.500546617443 "$node_(594) setdest 80235 18006 3.0" 
$ns at 550.8042161388121 "$node_(594) setdest 123842 5289 1.0" 
$ns at 589.3268820771113 "$node_(594) setdest 39361 23988 6.0" 
$ns at 625.8534497240013 "$node_(594) setdest 52267 19269 16.0" 
$ns at 727.6971399293227 "$node_(594) setdest 42159 11082 19.0" 
$ns at 783.5034204425577 "$node_(594) setdest 58819 18292 19.0" 
$ns at 619.4062803713537 "$node_(595) setdest 75291 19444 8.0" 
$ns at 661.6986414726517 "$node_(595) setdest 61670 21027 1.0" 
$ns at 697.3569396834208 "$node_(595) setdest 57521 21657 12.0" 
$ns at 780.823099007246 "$node_(595) setdest 114492 13374 15.0" 
$ns at 829.7752165599568 "$node_(595) setdest 79759 41950 14.0" 
$ns at 872.2473334692752 "$node_(595) setdest 125822 31794 3.0" 
$ns at 601.6918077976044 "$node_(596) setdest 131740 1919 15.0" 
$ns at 672.9917029197998 "$node_(596) setdest 3424 11176 3.0" 
$ns at 703.5848404419332 "$node_(596) setdest 78847 27501 7.0" 
$ns at 777.3039661728388 "$node_(596) setdest 29134 7603 18.0" 
$ns at 876.3040013366377 "$node_(596) setdest 69684 34914 13.0" 
$ns at 512.1966662113742 "$node_(597) setdest 55472 23745 3.0" 
$ns at 542.3728850694531 "$node_(597) setdest 122931 41533 18.0" 
$ns at 655.8624065787977 "$node_(597) setdest 34530 44003 16.0" 
$ns at 693.5132033919084 "$node_(597) setdest 50052 25299 18.0" 
$ns at 874.2299598450156 "$node_(597) setdest 22261 39179 11.0" 
$ns at 511.1439651233092 "$node_(598) setdest 6585 10900 11.0" 
$ns at 567.8474316651227 "$node_(598) setdest 60738 14326 16.0" 
$ns at 633.2681502297496 "$node_(598) setdest 128037 4864 7.0" 
$ns at 695.0868519063083 "$node_(598) setdest 57164 16010 14.0" 
$ns at 834.134017897498 "$node_(598) setdest 81875 12107 13.0" 
$ns at 520.5700300956257 "$node_(599) setdest 99242 1858 15.0" 
$ns at 688.2726449308323 "$node_(599) setdest 80581 41401 12.0" 
$ns at 729.0729885217736 "$node_(599) setdest 2888 36536 4.0" 
$ns at 782.1213213737317 "$node_(599) setdest 32424 14851 15.0" 
$ns at 679.2757174764461 "$node_(600) setdest 9632 35949 7.0" 
$ns at 714.6846369344814 "$node_(600) setdest 30118 4370 3.0" 
$ns at 765.3192673800786 "$node_(600) setdest 107758 25186 17.0" 
$ns at 877.0621966875511 "$node_(600) setdest 97152 6337 11.0" 
$ns at 630.7472021927975 "$node_(601) setdest 104161 17925 1.0" 
$ns at 664.8050603466802 "$node_(601) setdest 27882 3741 18.0" 
$ns at 710.7159924284106 "$node_(601) setdest 118432 33267 4.0" 
$ns at 771.2298764784716 "$node_(601) setdest 2723 17152 16.0" 
$ns at 601.4507190389592 "$node_(602) setdest 66453 11003 12.0" 
$ns at 685.2501828850507 "$node_(602) setdest 67421 8845 17.0" 
$ns at 760.2421391272493 "$node_(602) setdest 17541 1104 5.0" 
$ns at 836.2081584954051 "$node_(602) setdest 133673 31121 4.0" 
$ns at 893.0396750457877 "$node_(602) setdest 23803 486 18.0" 
$ns at 620.1364627322863 "$node_(603) setdest 102457 21022 9.0" 
$ns at 674.5349240919641 "$node_(603) setdest 125492 18678 12.0" 
$ns at 738.00253333577 "$node_(603) setdest 85160 4925 12.0" 
$ns at 786.6043039698252 "$node_(603) setdest 44464 29173 4.0" 
$ns at 824.1011307492341 "$node_(603) setdest 34536 32519 5.0" 
$ns at 877.5117988142191 "$node_(603) setdest 37563 38926 20.0" 
$ns at 625.5263783908711 "$node_(604) setdest 96365 35077 3.0" 
$ns at 667.9127177238428 "$node_(604) setdest 92348 39020 5.0" 
$ns at 745.8380114741631 "$node_(604) setdest 22469 11173 5.0" 
$ns at 801.1732643805647 "$node_(604) setdest 106864 37074 2.0" 
$ns at 846.9448811731121 "$node_(604) setdest 1375 13949 14.0" 
$ns at 609.780241571847 "$node_(605) setdest 61240 28125 3.0" 
$ns at 666.9830703518342 "$node_(605) setdest 106559 7891 15.0" 
$ns at 758.4460080178005 "$node_(605) setdest 104162 19712 14.0" 
$ns at 623.7982330181512 "$node_(606) setdest 106208 43368 12.0" 
$ns at 730.7976609000046 "$node_(606) setdest 114583 13526 9.0" 
$ns at 793.040890722144 "$node_(606) setdest 55576 11478 2.0" 
$ns at 842.5107835984046 "$node_(606) setdest 48013 4158 9.0" 
$ns at 685.7785194608864 "$node_(607) setdest 7033 28268 15.0" 
$ns at 754.2559738677667 "$node_(607) setdest 50398 36971 14.0" 
$ns at 891.2494511168746 "$node_(607) setdest 98861 20609 2.0" 
$ns at 623.3995632293262 "$node_(608) setdest 82987 3426 8.0" 
$ns at 681.8455682335132 "$node_(608) setdest 68783 25152 19.0" 
$ns at 850.6607385744694 "$node_(608) setdest 58179 29605 19.0" 
$ns at 886.2562516270386 "$node_(608) setdest 13737 3415 8.0" 
$ns at 662.3297197223573 "$node_(609) setdest 25235 28828 14.0" 
$ns at 723.6322397069657 "$node_(609) setdest 5269 12861 19.0" 
$ns at 852.3652532214029 "$node_(609) setdest 94529 17681 6.0" 
$ns at 607.3223525337751 "$node_(610) setdest 80445 33066 15.0" 
$ns at 762.2865549612022 "$node_(610) setdest 69399 4212 3.0" 
$ns at 795.0489893767287 "$node_(610) setdest 7258 34648 11.0" 
$ns at 770.1782281204754 "$node_(611) setdest 36266 17147 15.0" 
$ns at 847.981383891488 "$node_(611) setdest 125404 2136 20.0" 
$ns at 708.0314784148842 "$node_(612) setdest 6289 1252 18.0" 
$ns at 668.7762130294227 "$node_(613) setdest 128867 3437 13.0" 
$ns at 747.1003455490072 "$node_(613) setdest 29444 27813 19.0" 
$ns at 665.2446284597997 "$node_(614) setdest 16249 5527 4.0" 
$ns at 726.794862663721 "$node_(614) setdest 64497 15838 15.0" 
$ns at 787.0319340632091 "$node_(614) setdest 356 26302 18.0" 
$ns at 684.7066120778522 "$node_(615) setdest 67663 44161 19.0" 
$ns at 852.9988391726212 "$node_(615) setdest 17403 21743 5.0" 
$ns at 636.4434530687828 "$node_(616) setdest 188 42386 9.0" 
$ns at 736.4156285389477 "$node_(616) setdest 81116 19770 3.0" 
$ns at 790.865217032453 "$node_(616) setdest 56361 31141 11.0" 
$ns at 835.4907032584514 "$node_(616) setdest 24583 13057 18.0" 
$ns at 725.387094616609 "$node_(617) setdest 125575 41532 13.0" 
$ns at 785.6990688583094 "$node_(617) setdest 117981 43369 10.0" 
$ns at 821.1159473019474 "$node_(617) setdest 98502 34908 3.0" 
$ns at 863.9065011059453 "$node_(617) setdest 77219 18320 6.0" 
$ns at 899.6251580782542 "$node_(617) setdest 127384 25122 5.0" 
$ns at 643.4896364517185 "$node_(618) setdest 74292 34996 4.0" 
$ns at 710.8493739658579 "$node_(618) setdest 45369 1006 9.0" 
$ns at 828.2014229952929 "$node_(618) setdest 116842 148 2.0" 
$ns at 862.8019424081347 "$node_(618) setdest 45738 13824 1.0" 
$ns at 636.976600780811 "$node_(619) setdest 28441 9395 2.0" 
$ns at 679.2454277345083 "$node_(619) setdest 95832 1981 20.0" 
$ns at 858.4587089777757 "$node_(619) setdest 95499 18263 7.0" 
$ns at 647.8802445486974 "$node_(620) setdest 39854 6788 8.0" 
$ns at 713.7221089895575 "$node_(620) setdest 36211 34032 2.0" 
$ns at 752.7279513905827 "$node_(620) setdest 108254 37649 13.0" 
$ns at 796.8039249183537 "$node_(620) setdest 69053 20086 1.0" 
$ns at 829.9100504903305 "$node_(620) setdest 81145 37278 14.0" 
$ns at 693.5666284201736 "$node_(621) setdest 38639 29590 14.0" 
$ns at 802.631170865708 "$node_(621) setdest 105351 22710 9.0" 
$ns at 853.9587437404249 "$node_(621) setdest 58475 24352 15.0" 
$ns at 639.3853281230353 "$node_(622) setdest 108165 39015 19.0" 
$ns at 681.8347129844535 "$node_(622) setdest 96732 17004 16.0" 
$ns at 755.3254254981445 "$node_(622) setdest 88241 10433 17.0" 
$ns at 643.1592119774275 "$node_(623) setdest 108636 14641 10.0" 
$ns at 680.0270549353824 "$node_(623) setdest 92224 26431 14.0" 
$ns at 731.1674382925656 "$node_(623) setdest 51448 19070 18.0" 
$ns at 774.4993420644638 "$node_(623) setdest 20348 33902 11.0" 
$ns at 881.747391736563 "$node_(623) setdest 91685 28842 1.0" 
$ns at 643.7771068558659 "$node_(624) setdest 108020 7189 1.0" 
$ns at 677.7774795105728 "$node_(624) setdest 130411 18746 6.0" 
$ns at 753.5546954003908 "$node_(624) setdest 17731 3700 1.0" 
$ns at 786.0480958453409 "$node_(624) setdest 1053 6330 14.0" 
$ns at 736.4005229561893 "$node_(625) setdest 17206 41584 5.0" 
$ns at 806.9261132537911 "$node_(625) setdest 52969 36079 11.0" 
$ns at 875.2270153437579 "$node_(625) setdest 112033 12632 13.0" 
$ns at 752.0170741322867 "$node_(626) setdest 46047 10498 13.0" 
$ns at 741.1918659910243 "$node_(627) setdest 97828 29424 13.0" 
$ns at 854.563638404361 "$node_(627) setdest 15596 13212 12.0" 
$ns at 897.7745555158517 "$node_(627) setdest 42967 32056 8.0" 
$ns at 640.6296437202687 "$node_(628) setdest 26007 5642 18.0" 
$ns at 681.2913801448747 "$node_(628) setdest 82023 23035 1.0" 
$ns at 719.0976466194873 "$node_(628) setdest 132250 24000 1.0" 
$ns at 750.2353259231465 "$node_(628) setdest 3085 17208 14.0" 
$ns at 874.3937088196697 "$node_(628) setdest 88350 9601 15.0" 
$ns at 696.007948724678 "$node_(629) setdest 116465 42309 10.0" 
$ns at 756.7460489061732 "$node_(629) setdest 13414 13498 4.0" 
$ns at 820.472415704978 "$node_(629) setdest 119043 4572 11.0" 
$ns at 876.5677175263379 "$node_(629) setdest 37628 28295 8.0" 
$ns at 719.6757423864246 "$node_(630) setdest 30507 6740 18.0" 
$ns at 840.1754281602294 "$node_(630) setdest 119846 24728 18.0" 
$ns at 890.9450383934811 "$node_(630) setdest 100481 41622 16.0" 
$ns at 606.7605248555707 "$node_(631) setdest 132939 35291 10.0" 
$ns at 664.5789670422491 "$node_(631) setdest 26754 30530 20.0" 
$ns at 706.9451323448201 "$node_(631) setdest 86055 2904 14.0" 
$ns at 848.9367722022915 "$node_(631) setdest 4144 6163 8.0" 
$ns at 685.2629376183615 "$node_(632) setdest 5949 38469 19.0" 
$ns at 851.6729367046977 "$node_(632) setdest 10048 34736 6.0" 
$ns at 651.8459650624036 "$node_(633) setdest 124425 27359 2.0" 
$ns at 682.3897600600465 "$node_(633) setdest 129610 36678 11.0" 
$ns at 712.5558135421362 "$node_(633) setdest 109929 40303 2.0" 
$ns at 754.3934609235455 "$node_(633) setdest 132063 24162 12.0" 
$ns at 848.5367748988699 "$node_(633) setdest 108959 27029 3.0" 
$ns at 895.1419111655812 "$node_(633) setdest 93619 17249 1.0" 
$ns at 605.2031242977484 "$node_(634) setdest 97409 22198 8.0" 
$ns at 683.2349973943777 "$node_(634) setdest 16632 19683 14.0" 
$ns at 811.1674431930105 "$node_(634) setdest 44973 7410 19.0" 
$ns at 866.5145773940294 "$node_(634) setdest 14736 29137 12.0" 
$ns at 663.9386705235595 "$node_(635) setdest 96702 6560 8.0" 
$ns at 750.463839272209 "$node_(635) setdest 93447 32278 7.0" 
$ns at 833.2443499351047 "$node_(635) setdest 79134 3336 11.0" 
$ns at 607.747342040546 "$node_(636) setdest 41982 3630 18.0" 
$ns at 753.5556152222965 "$node_(636) setdest 73788 40099 8.0" 
$ns at 819.752879736594 "$node_(636) setdest 55170 20297 19.0" 
$ns at 891.5391841814236 "$node_(636) setdest 80802 33942 7.0" 
$ns at 665.5666614069987 "$node_(637) setdest 7445 20591 6.0" 
$ns at 719.9401616252602 "$node_(637) setdest 130231 39862 19.0" 
$ns at 717.0584940558233 "$node_(638) setdest 134010 26086 14.0" 
$ns at 832.6825428246959 "$node_(638) setdest 58556 31205 13.0" 
$ns at 608.0275787647361 "$node_(639) setdest 17122 20066 10.0" 
$ns at 697.530026159217 "$node_(639) setdest 11680 26401 4.0" 
$ns at 766.0207647611405 "$node_(639) setdest 132979 29618 9.0" 
$ns at 848.6085438340043 "$node_(639) setdest 82583 36051 8.0" 
$ns at 883.1298591874006 "$node_(639) setdest 79908 9974 11.0" 
$ns at 615.2995591653946 "$node_(640) setdest 4637 11128 18.0" 
$ns at 767.3860829859798 "$node_(640) setdest 50021 2946 18.0" 
$ns at 635.672268618895 "$node_(641) setdest 36698 1632 20.0" 
$ns at 688.8959907706812 "$node_(641) setdest 21572 11633 17.0" 
$ns at 840.2378842746226 "$node_(641) setdest 44220 21703 1.0" 
$ns at 871.2972972093331 "$node_(641) setdest 25044 4375 13.0" 
$ns at 604.4830532888715 "$node_(642) setdest 109938 4606 7.0" 
$ns at 700.3558415599286 "$node_(642) setdest 74177 23081 5.0" 
$ns at 772.1132346760869 "$node_(642) setdest 44193 22415 5.0" 
$ns at 840.1500356766459 "$node_(642) setdest 71192 16506 13.0" 
$ns at 658.5827766692245 "$node_(643) setdest 51951 9443 16.0" 
$ns at 777.0844470288214 "$node_(643) setdest 42680 19336 17.0" 
$ns at 889.0754648623509 "$node_(643) setdest 99806 40213 3.0" 
$ns at 631.7910168832101 "$node_(644) setdest 49422 2802 15.0" 
$ns at 742.6402826087949 "$node_(644) setdest 130006 12869 20.0" 
$ns at 850.8114938176656 "$node_(644) setdest 29421 41386 8.0" 
$ns at 892.6847397529247 "$node_(644) setdest 1524 2268 10.0" 
$ns at 712.0614342846893 "$node_(645) setdest 33771 30637 5.0" 
$ns at 772.3232043956624 "$node_(645) setdest 11398 21252 11.0" 
$ns at 869.0621319543759 "$node_(645) setdest 76684 18052 4.0" 
$ns at 619.9234614593971 "$node_(646) setdest 407 40201 1.0" 
$ns at 654.5801213026314 "$node_(646) setdest 66339 35433 16.0" 
$ns at 686.9642097537466 "$node_(646) setdest 37364 34310 3.0" 
$ns at 738.6496730612622 "$node_(646) setdest 86086 22219 15.0" 
$ns at 899.8529726444641 "$node_(646) setdest 30047 36265 6.0" 
$ns at 603.8735119722306 "$node_(647) setdest 63629 38867 13.0" 
$ns at 635.6281725944878 "$node_(647) setdest 103218 15487 13.0" 
$ns at 712.2457846466194 "$node_(647) setdest 108723 23411 13.0" 
$ns at 866.3434504369019 "$node_(647) setdest 96041 8170 13.0" 
$ns at 608.9805856444598 "$node_(648) setdest 10219 21031 8.0" 
$ns at 660.4094844056117 "$node_(648) setdest 133905 22776 6.0" 
$ns at 695.854619026659 "$node_(648) setdest 33280 21004 17.0" 
$ns at 798.2972401477443 "$node_(648) setdest 34392 9320 17.0" 
$ns at 662.3902040430364 "$node_(649) setdest 106415 42845 19.0" 
$ns at 817.9413769401776 "$node_(649) setdest 98139 36101 8.0" 
$ns at 891.3481912487978 "$node_(649) setdest 33087 20901 16.0" 
$ns at 603.5200096413707 "$node_(650) setdest 26699 43028 13.0" 
$ns at 691.0212057032331 "$node_(650) setdest 39791 12051 14.0" 
$ns at 759.0315819472567 "$node_(650) setdest 114215 21512 2.0" 
$ns at 803.5193769609506 "$node_(650) setdest 19184 38229 10.0" 
$ns at 874.4722697478605 "$node_(650) setdest 103313 6076 2.0" 
$ns at 629.3585153251001 "$node_(651) setdest 52807 3460 12.0" 
$ns at 700.1252115897055 "$node_(651) setdest 119180 27445 8.0" 
$ns at 767.7090634813859 "$node_(651) setdest 101356 14728 8.0" 
$ns at 797.9574347537306 "$node_(651) setdest 128684 1978 8.0" 
$ns at 830.6862546985876 "$node_(651) setdest 93506 8798 20.0" 
$ns at 629.3915337386413 "$node_(652) setdest 30748 17563 20.0" 
$ns at 691.454016545797 "$node_(652) setdest 127262 1809 17.0" 
$ns at 844.6016281417064 "$node_(652) setdest 103419 33255 16.0" 
$ns at 680.8858284015655 "$node_(653) setdest 74640 38367 12.0" 
$ns at 782.4615593707769 "$node_(653) setdest 51880 29282 15.0" 
$ns at 623.0579793597202 "$node_(654) setdest 50054 14069 5.0" 
$ns at 668.0107650898155 "$node_(654) setdest 71402 24226 15.0" 
$ns at 715.277114595821 "$node_(654) setdest 31420 34716 1.0" 
$ns at 748.0476791026009 "$node_(654) setdest 93467 3729 1.0" 
$ns at 784.7474779705811 "$node_(654) setdest 130819 41943 2.0" 
$ns at 834.1282796285606 "$node_(654) setdest 26695 7034 19.0" 
$ns at 623.4180144379586 "$node_(655) setdest 118297 4165 1.0" 
$ns at 662.240521543467 "$node_(655) setdest 12405 20290 1.0" 
$ns at 700.2174153534764 "$node_(655) setdest 112366 33877 3.0" 
$ns at 759.1705937898223 "$node_(655) setdest 56939 17366 3.0" 
$ns at 813.1509494335249 "$node_(655) setdest 30974 30906 14.0" 
$ns at 642.850745958076 "$node_(656) setdest 60348 2714 11.0" 
$ns at 757.9262495723754 "$node_(656) setdest 89042 30553 10.0" 
$ns at 813.5424724936715 "$node_(656) setdest 78899 19827 8.0" 
$ns at 872.3094189733642 "$node_(656) setdest 17891 29802 18.0" 
$ns at 713.0143114555079 "$node_(657) setdest 103155 25347 11.0" 
$ns at 772.6071866786252 "$node_(657) setdest 60906 23576 13.0" 
$ns at 886.9129607190298 "$node_(657) setdest 58013 7646 9.0" 
$ns at 613.534682332738 "$node_(658) setdest 107877 29608 18.0" 
$ns at 791.1686500939975 "$node_(658) setdest 100616 8079 4.0" 
$ns at 859.657690193336 "$node_(658) setdest 116068 37133 13.0" 
$ns at 624.8221953448497 "$node_(659) setdest 82160 38102 7.0" 
$ns at 709.3882202987767 "$node_(659) setdest 97502 11906 12.0" 
$ns at 744.3462893425678 "$node_(659) setdest 5569 29364 1.0" 
$ns at 782.2721481173038 "$node_(659) setdest 61288 350 4.0" 
$ns at 843.5455631078648 "$node_(659) setdest 74808 12300 12.0" 
$ns at 884.481384476235 "$node_(659) setdest 98159 18534 1.0" 
$ns at 684.4279508714066 "$node_(660) setdest 69527 44714 8.0" 
$ns at 775.3939396585606 "$node_(660) setdest 20126 12679 8.0" 
$ns at 808.2657335950588 "$node_(660) setdest 133701 26914 3.0" 
$ns at 852.6764358325441 "$node_(660) setdest 64872 27794 12.0" 
$ns at 622.5811849440047 "$node_(661) setdest 60983 14479 16.0" 
$ns at 667.1381982858846 "$node_(661) setdest 119194 10436 4.0" 
$ns at 705.8071729032156 "$node_(661) setdest 85361 19111 11.0" 
$ns at 775.6942931586133 "$node_(661) setdest 55330 4310 8.0" 
$ns at 872.8627728960419 "$node_(661) setdest 27401 25999 12.0" 
$ns at 606.9212654324756 "$node_(662) setdest 28919 18016 3.0" 
$ns at 659.3696918670606 "$node_(662) setdest 46918 3729 11.0" 
$ns at 718.5791380006898 "$node_(662) setdest 83679 21572 1.0" 
$ns at 753.6419407991469 "$node_(662) setdest 28761 30859 9.0" 
$ns at 812.5092111711718 "$node_(662) setdest 10559 5432 18.0" 
$ns at 626.8914320399017 "$node_(663) setdest 43943 31886 2.0" 
$ns at 666.7046875056368 "$node_(663) setdest 126840 34560 3.0" 
$ns at 717.9189128906719 "$node_(663) setdest 56370 38432 14.0" 
$ns at 852.5413153471735 "$node_(663) setdest 22493 41733 5.0" 
$ns at 605.8068723750093 "$node_(664) setdest 110847 40195 5.0" 
$ns at 648.2890882093568 "$node_(664) setdest 43241 36448 2.0" 
$ns at 692.243516540064 "$node_(664) setdest 123851 22872 13.0" 
$ns at 739.1831032636303 "$node_(664) setdest 52680 9127 9.0" 
$ns at 790.5904103788805 "$node_(664) setdest 14504 9511 6.0" 
$ns at 829.087735890889 "$node_(664) setdest 87890 11979 8.0" 
$ns at 632.6964283871948 "$node_(665) setdest 62973 6859 2.0" 
$ns at 677.1282504711918 "$node_(665) setdest 3687 38598 1.0" 
$ns at 711.0227348823605 "$node_(665) setdest 49761 38162 9.0" 
$ns at 774.2647092540207 "$node_(665) setdest 8285 42450 3.0" 
$ns at 818.5573100981819 "$node_(665) setdest 104639 22997 19.0" 
$ns at 644.6908628825008 "$node_(666) setdest 44693 17644 10.0" 
$ns at 712.8549136096754 "$node_(666) setdest 89019 35085 6.0" 
$ns at 771.2315774285055 "$node_(666) setdest 37384 11291 14.0" 
$ns at 873.9706799619593 "$node_(666) setdest 126091 39433 4.0" 
$ns at 659.6100651232732 "$node_(667) setdest 27551 43786 7.0" 
$ns at 720.1927397742036 "$node_(667) setdest 29229 10454 10.0" 
$ns at 845.3861271180365 "$node_(667) setdest 13299 27616 16.0" 
$ns at 700.3986335494509 "$node_(668) setdest 20780 21582 7.0" 
$ns at 798.866391690394 "$node_(668) setdest 74108 17110 11.0" 
$ns at 865.530517604372 "$node_(668) setdest 69579 40000 1.0" 
$ns at 635.1358092287933 "$node_(669) setdest 71802 34918 20.0" 
$ns at 756.5354710695034 "$node_(669) setdest 90000 31511 10.0" 
$ns at 829.534393415724 "$node_(669) setdest 98507 40472 10.0" 
$ns at 636.5097137161906 "$node_(670) setdest 110856 15912 6.0" 
$ns at 703.126838738069 "$node_(670) setdest 103286 9765 12.0" 
$ns at 819.5581147704626 "$node_(670) setdest 19070 22666 18.0" 
$ns at 877.0579421746595 "$node_(670) setdest 47382 26525 2.0" 
$ns at 675.185773799383 "$node_(671) setdest 121509 36238 14.0" 
$ns at 771.875135037163 "$node_(671) setdest 76108 24684 14.0" 
$ns at 608.8395809692355 "$node_(672) setdest 103115 660 8.0" 
$ns at 676.2845862921506 "$node_(672) setdest 126555 985 10.0" 
$ns at 734.6611275916791 "$node_(672) setdest 70282 43503 16.0" 
$ns at 845.1174931631132 "$node_(672) setdest 24612 1720 11.0" 
$ns at 606.0451134051102 "$node_(673) setdest 58635 17270 16.0" 
$ns at 727.2508809553178 "$node_(673) setdest 63375 33 19.0" 
$ns at 620.02628874628 "$node_(674) setdest 45636 38740 15.0" 
$ns at 748.5766563679019 "$node_(674) setdest 23511 39898 15.0" 
$ns at 787.3529406545479 "$node_(674) setdest 79851 2217 20.0" 
$ns at 849.6330948910233 "$node_(674) setdest 131647 38173 18.0" 
$ns at 899.7162845254664 "$node_(674) setdest 112788 16251 14.0" 
$ns at 618.4989474423451 "$node_(675) setdest 87471 16230 1.0" 
$ns at 652.1918321006879 "$node_(675) setdest 114181 28890 13.0" 
$ns at 718.2726652933187 "$node_(675) setdest 108148 10541 1.0" 
$ns at 754.9907720889663 "$node_(675) setdest 37412 7571 3.0" 
$ns at 807.4164840652834 "$node_(675) setdest 65475 27218 14.0" 
$ns at 857.5639866294991 "$node_(675) setdest 57143 23732 13.0" 
$ns at 624.2082154599077 "$node_(676) setdest 117703 25277 7.0" 
$ns at 705.1189838059029 "$node_(676) setdest 61732 25891 6.0" 
$ns at 738.1108893593579 "$node_(676) setdest 118563 22481 15.0" 
$ns at 801.5740532984729 "$node_(676) setdest 54150 35653 6.0" 
$ns at 855.4562703977787 "$node_(676) setdest 106436 6568 12.0" 
$ns at 676.1197316969519 "$node_(677) setdest 57708 33998 5.0" 
$ns at 746.5359717573372 "$node_(677) setdest 101911 31128 1.0" 
$ns at 779.4309678649289 "$node_(677) setdest 42915 34621 1.0" 
$ns at 816.9570646168822 "$node_(677) setdest 39276 42348 13.0" 
$ns at 695.3594422477995 "$node_(678) setdest 119884 17258 10.0" 
$ns at 759.8195931207475 "$node_(678) setdest 21184 20483 5.0" 
$ns at 821.6451395836949 "$node_(678) setdest 64963 39019 11.0" 
$ns at 653.6580137044544 "$node_(679) setdest 49946 24051 1.0" 
$ns at 692.5412204368491 "$node_(679) setdest 132895 10251 19.0" 
$ns at 782.8225392682021 "$node_(679) setdest 89897 16597 3.0" 
$ns at 826.7690042226442 "$node_(679) setdest 74017 1367 15.0" 
$ns at 676.04945981687 "$node_(680) setdest 110275 8263 13.0" 
$ns at 835.5853039925973 "$node_(680) setdest 130660 7211 11.0" 
$ns at 891.2697637111718 "$node_(680) setdest 59450 6392 7.0" 
$ns at 626.1446016360355 "$node_(681) setdest 108116 1432 5.0" 
$ns at 662.5199737993969 "$node_(681) setdest 106543 33787 8.0" 
$ns at 699.0087261525421 "$node_(681) setdest 71300 30752 11.0" 
$ns at 781.0220610519527 "$node_(681) setdest 104288 25623 6.0" 
$ns at 818.8305869210598 "$node_(681) setdest 95546 40196 20.0" 
$ns at 750.0914834039443 "$node_(682) setdest 77007 17859 10.0" 
$ns at 817.0510999088744 "$node_(682) setdest 96641 37440 16.0" 
$ns at 642.7224617654921 "$node_(683) setdest 16889 35373 1.0" 
$ns at 676.1565116075716 "$node_(683) setdest 82836 2232 6.0" 
$ns at 727.0681570783081 "$node_(683) setdest 54363 38082 13.0" 
$ns at 824.2990634905012 "$node_(683) setdest 42057 9167 14.0" 
$ns at 660.756423118506 "$node_(684) setdest 133964 12766 11.0" 
$ns at 753.2544898367545 "$node_(684) setdest 132147 34840 4.0" 
$ns at 794.7645429441593 "$node_(684) setdest 51676 4932 1.0" 
$ns at 827.3491276684136 "$node_(684) setdest 11078 14627 1.0" 
$ns at 860.6763434469826 "$node_(684) setdest 73696 8573 15.0" 
$ns at 714.9285430758135 "$node_(685) setdest 120626 13708 13.0" 
$ns at 758.7369598319933 "$node_(685) setdest 66716 39218 1.0" 
$ns at 798.0852094766063 "$node_(685) setdest 128529 8138 15.0" 
$ns at 854.8873246723159 "$node_(685) setdest 105707 17114 3.0" 
$ns at 606.1984044400767 "$node_(686) setdest 17466 1827 11.0" 
$ns at 696.069248504846 "$node_(686) setdest 31244 33803 9.0" 
$ns at 804.1192923254526 "$node_(686) setdest 100265 22402 9.0" 
$ns at 882.6403823249854 "$node_(686) setdest 81383 18163 12.0" 
$ns at 646.0742390587994 "$node_(687) setdest 124760 28419 18.0" 
$ns at 712.3594361369287 "$node_(687) setdest 62137 41821 17.0" 
$ns at 746.2941210499674 "$node_(687) setdest 73199 22142 14.0" 
$ns at 600.8848548305166 "$node_(688) setdest 41728 33804 4.0" 
$ns at 632.5228820156823 "$node_(688) setdest 68146 3860 5.0" 
$ns at 703.9534103066253 "$node_(688) setdest 130399 6454 10.0" 
$ns at 828.6082550067551 "$node_(688) setdest 7663 21765 4.0" 
$ns at 888.4905127156637 "$node_(688) setdest 53313 32560 16.0" 
$ns at 627.5088234255238 "$node_(689) setdest 131262 40592 2.0" 
$ns at 671.4188874668339 "$node_(689) setdest 4304 32129 1.0" 
$ns at 707.1358703682932 "$node_(689) setdest 14786 5044 11.0" 
$ns at 750.9993886882376 "$node_(689) setdest 67592 37910 10.0" 
$ns at 783.6975609980459 "$node_(689) setdest 46377 44013 19.0" 
$ns at 651.7886275511997 "$node_(690) setdest 72481 14465 19.0" 
$ns at 745.2189589390921 "$node_(690) setdest 122964 44113 2.0" 
$ns at 783.440316645624 "$node_(690) setdest 122339 14800 20.0" 
$ns at 613.3403285033387 "$node_(691) setdest 132511 41193 14.0" 
$ns at 651.2154985963226 "$node_(691) setdest 41890 41384 10.0" 
$ns at 757.5413759924455 "$node_(691) setdest 53117 36129 1.0" 
$ns at 791.1266725520165 "$node_(691) setdest 19189 39505 19.0" 
$ns at 883.2253620513632 "$node_(691) setdest 94131 38317 17.0" 
$ns at 665.9757883407799 "$node_(692) setdest 106879 16575 12.0" 
$ns at 709.3754956730006 "$node_(692) setdest 111213 24375 9.0" 
$ns at 796.0011285378938 "$node_(692) setdest 105859 33003 3.0" 
$ns at 836.1233854133159 "$node_(692) setdest 80544 11824 9.0" 
$ns at 659.0058600150056 "$node_(693) setdest 119656 36634 1.0" 
$ns at 693.7199178280441 "$node_(693) setdest 48618 6004 12.0" 
$ns at 754.0637397756535 "$node_(693) setdest 85785 29648 20.0" 
$ns at 610.5290101918174 "$node_(694) setdest 101752 479 10.0" 
$ns at 715.5194044006183 "$node_(694) setdest 28012 744 12.0" 
$ns at 801.1842282536962 "$node_(694) setdest 98512 32714 13.0" 
$ns at 665.9440168365201 "$node_(695) setdest 109396 1462 12.0" 
$ns at 730.7583014046069 "$node_(695) setdest 104536 19935 17.0" 
$ns at 882.2570894882634 "$node_(695) setdest 31212 18561 9.0" 
$ns at 634.9310332942945 "$node_(696) setdest 60649 24178 2.0" 
$ns at 673.958897433563 "$node_(696) setdest 60732 2332 7.0" 
$ns at 738.2734622842174 "$node_(696) setdest 27325 26399 1.0" 
$ns at 776.6970996632912 "$node_(696) setdest 40446 30777 8.0" 
$ns at 807.4699865111712 "$node_(696) setdest 128716 31247 17.0" 
$ns at 860.2701266425655 "$node_(696) setdest 44823 2026 8.0" 
$ns at 895.3845988156994 "$node_(696) setdest 32743 29021 9.0" 
$ns at 636.2540374747011 "$node_(697) setdest 49117 8069 4.0" 
$ns at 702.0831369721053 "$node_(697) setdest 89026 17441 19.0" 
$ns at 754.2281754121515 "$node_(697) setdest 575 33692 9.0" 
$ns at 812.9368464568354 "$node_(697) setdest 10653 17102 18.0" 
$ns at 617.3459660083454 "$node_(698) setdest 127486 24239 4.0" 
$ns at 665.0647249582182 "$node_(698) setdest 67349 169 7.0" 
$ns at 712.2338482140805 "$node_(698) setdest 108283 31021 11.0" 
$ns at 833.8310573002206 "$node_(698) setdest 29503 33005 2.0" 
$ns at 881.1004569423744 "$node_(698) setdest 45627 3082 3.0" 
$ns at 731.5698544877035 "$node_(699) setdest 102521 21341 1.0" 
$ns at 766.8631301545099 "$node_(699) setdest 65016 22079 10.0" 
$ns at 828.0134393257514 "$node_(699) setdest 23638 31346 2.0" 
$ns at 871.9804026563838 "$node_(699) setdest 5462 18148 7.0" 
$ns at 700.6784730838598 "$node_(700) setdest 50268 44135 1.0" 
$ns at 740.6516395443758 "$node_(700) setdest 25547 23332 14.0" 
$ns at 848.8271498716839 "$node_(700) setdest 113322 971 15.0" 
$ns at 704.5736763949542 "$node_(701) setdest 26337 11421 10.0" 
$ns at 829.4183241761001 "$node_(701) setdest 61613 41144 4.0" 
$ns at 872.6737165231375 "$node_(701) setdest 45513 27864 16.0" 
$ns at 718.0797211390211 "$node_(702) setdest 73496 35755 11.0" 
$ns at 852.1590107637178 "$node_(702) setdest 125911 35219 13.0" 
$ns at 804.0543146655393 "$node_(703) setdest 6280 44295 3.0" 
$ns at 862.8417061142952 "$node_(703) setdest 95264 10478 6.0" 
$ns at 899.4797529362413 "$node_(703) setdest 50008 26399 9.0" 
$ns at 714.8387459799312 "$node_(704) setdest 97418 44256 2.0" 
$ns at 764.2438955078761 "$node_(704) setdest 77912 6890 17.0" 
$ns at 812.8258736199168 "$node_(704) setdest 39827 32373 5.0" 
$ns at 862.3172507407063 "$node_(704) setdest 88473 1071 16.0" 
$ns at 721.5176872538357 "$node_(705) setdest 81037 16362 12.0" 
$ns at 817.5490401833239 "$node_(705) setdest 80721 18014 2.0" 
$ns at 852.2766379302059 "$node_(705) setdest 29379 32773 6.0" 
$ns at 756.1447161586041 "$node_(706) setdest 107157 44218 2.0" 
$ns at 796.2288732731117 "$node_(706) setdest 13652 27848 1.0" 
$ns at 828.5086278152701 "$node_(706) setdest 82870 37424 8.0" 
$ns at 892.3804043780192 "$node_(706) setdest 98400 4414 16.0" 
$ns at 809.3180059846455 "$node_(707) setdest 129067 40995 11.0" 
$ns at 886.6470223569875 "$node_(707) setdest 48463 19977 6.0" 
$ns at 725.4284585958944 "$node_(708) setdest 51162 17695 2.0" 
$ns at 764.165960605313 "$node_(708) setdest 64531 6416 10.0" 
$ns at 857.2126290057317 "$node_(708) setdest 902 4366 14.0" 
$ns at 893.5998772368739 "$node_(708) setdest 27819 44717 8.0" 
$ns at 729.0315523115229 "$node_(709) setdest 80727 18305 17.0" 
$ns at 877.8678322037981 "$node_(709) setdest 45559 29123 15.0" 
$ns at 828.0616886769673 "$node_(710) setdest 97115 22856 16.0" 
$ns at 760.6795373065052 "$node_(711) setdest 27581 22918 3.0" 
$ns at 800.3568451977173 "$node_(711) setdest 113396 27993 14.0" 
$ns at 836.1097111637332 "$node_(711) setdest 30731 11371 6.0" 
$ns at 869.6820611653163 "$node_(711) setdest 94575 30151 19.0" 
$ns at 786.9769486506541 "$node_(712) setdest 12213 41621 18.0" 
$ns at 710.1363525357111 "$node_(713) setdest 54876 13938 1.0" 
$ns at 742.4327808886045 "$node_(713) setdest 106430 40428 2.0" 
$ns at 775.6150832575833 "$node_(713) setdest 94409 33209 11.0" 
$ns at 878.5537299582322 "$node_(713) setdest 2826 36509 13.0" 
$ns at 766.5288088111978 "$node_(714) setdest 21833 23103 6.0" 
$ns at 836.7125866967053 "$node_(714) setdest 34996 20934 1.0" 
$ns at 875.4807653165789 "$node_(714) setdest 64414 25384 3.0" 
$ns at 731.3602869071202 "$node_(715) setdest 122225 15508 11.0" 
$ns at 803.3028248942071 "$node_(715) setdest 101430 28460 2.0" 
$ns at 852.8427944337378 "$node_(715) setdest 4173 43748 5.0" 
$ns at 700.6771253639952 "$node_(716) setdest 113788 36192 3.0" 
$ns at 734.9059760967614 "$node_(716) setdest 18529 25045 19.0" 
$ns at 795.9926961500889 "$node_(716) setdest 13341 2923 1.0" 
$ns at 831.9906706952066 "$node_(716) setdest 51297 34171 8.0" 
$ns at 740.8510200275833 "$node_(717) setdest 59499 30561 6.0" 
$ns at 827.34145649792 "$node_(717) setdest 117017 41744 5.0" 
$ns at 702.8808984247737 "$node_(718) setdest 92898 35979 12.0" 
$ns at 767.6559395401716 "$node_(718) setdest 126514 255 12.0" 
$ns at 800.4292346915391 "$node_(718) setdest 26708 23209 14.0" 
$ns at 875.6507118595023 "$node_(718) setdest 6580 43328 5.0" 
$ns at 800.6468705736897 "$node_(719) setdest 5029 12392 8.0" 
$ns at 888.1739282408612 "$node_(719) setdest 114168 13061 17.0" 
$ns at 715.989382509343 "$node_(720) setdest 123277 930 10.0" 
$ns at 760.6220749073032 "$node_(720) setdest 35789 26995 15.0" 
$ns at 861.1278116632054 "$node_(720) setdest 115580 22800 13.0" 
$ns at 744.080474676214 "$node_(721) setdest 14835 24083 18.0" 
$ns at 862.6364604330147 "$node_(721) setdest 71826 8752 8.0" 
$ns at 796.2434592965351 "$node_(722) setdest 118401 34339 18.0" 
$ns at 759.445741653362 "$node_(723) setdest 16398 14160 6.0" 
$ns at 843.9303954724849 "$node_(723) setdest 45900 15863 7.0" 
$ns at 875.3339799148374 "$node_(723) setdest 78208 22658 9.0" 
$ns at 703.1423845089765 "$node_(724) setdest 118649 14208 14.0" 
$ns at 781.7617423078775 "$node_(724) setdest 21909 24168 15.0" 
$ns at 879.1550357765684 "$node_(724) setdest 98341 14576 10.0" 
$ns at 731.4167717415431 "$node_(725) setdest 81641 35483 14.0" 
$ns at 815.7700548987038 "$node_(725) setdest 93818 30516 7.0" 
$ns at 889.0085296997697 "$node_(725) setdest 99810 44309 14.0" 
$ns at 861.4854190473136 "$node_(726) setdest 68391 43425 8.0" 
$ns at 755.3418271149769 "$node_(727) setdest 81308 13821 13.0" 
$ns at 831.4094281015953 "$node_(727) setdest 95868 14076 9.0" 
$ns at 703.2660246323292 "$node_(728) setdest 117409 35511 19.0" 
$ns at 830.733509687099 "$node_(728) setdest 95958 30756 12.0" 
$ns at 879.6619892624378 "$node_(728) setdest 55047 16300 13.0" 
$ns at 754.3132281197085 "$node_(729) setdest 43386 7534 19.0" 
$ns at 878.5158250678156 "$node_(729) setdest 93267 38670 9.0" 
$ns at 723.3996339756768 "$node_(730) setdest 19732 3813 3.0" 
$ns at 767.3165265497828 "$node_(730) setdest 11580 31032 13.0" 
$ns at 844.0390410830565 "$node_(730) setdest 45886 10149 16.0" 
$ns at 826.5163391638523 "$node_(731) setdest 71107 1342 16.0" 
$ns at 741.1448641075095 "$node_(732) setdest 45523 44387 12.0" 
$ns at 797.9286173460135 "$node_(732) setdest 34230 28883 14.0" 
$ns at 864.783326217114 "$node_(732) setdest 112192 25117 10.0" 
$ns at 730.2397100315765 "$node_(733) setdest 112888 11290 17.0" 
$ns at 782.4029429235406 "$node_(733) setdest 10518 23821 4.0" 
$ns at 824.6089251871623 "$node_(733) setdest 68072 34951 12.0" 
$ns at 866.3721571960565 "$node_(733) setdest 17605 43419 6.0" 
$ns at 718.7980234907474 "$node_(734) setdest 127688 37145 12.0" 
$ns at 801.7338088997245 "$node_(734) setdest 7081 26131 7.0" 
$ns at 833.0056619344915 "$node_(734) setdest 36969 19436 9.0" 
$ns at 735.80114679823 "$node_(735) setdest 19090 39406 10.0" 
$ns at 790.0930727430721 "$node_(735) setdest 44204 4582 5.0" 
$ns at 828.1515615144895 "$node_(735) setdest 115876 10195 18.0" 
$ns at 719.8378319080321 "$node_(736) setdest 11434 40210 3.0" 
$ns at 766.9164806870001 "$node_(736) setdest 88930 21460 5.0" 
$ns at 839.4172697342458 "$node_(736) setdest 17302 29285 12.0" 
$ns at 728.1310377966805 "$node_(737) setdest 131452 4050 1.0" 
$ns at 763.2888828640541 "$node_(737) setdest 2735 43716 1.0" 
$ns at 801.4520127569127 "$node_(737) setdest 25139 29565 4.0" 
$ns at 858.9363295821638 "$node_(737) setdest 14408 25649 18.0" 
$ns at 832.7839692002674 "$node_(738) setdest 40812 6688 4.0" 
$ns at 899.7973363681153 "$node_(738) setdest 41057 10666 19.0" 
$ns at 713.857047063662 "$node_(739) setdest 29787 35744 3.0" 
$ns at 750.2171938719293 "$node_(739) setdest 80713 15351 12.0" 
$ns at 862.1494146978738 "$node_(739) setdest 45822 36452 10.0" 
$ns at 813.4349838282819 "$node_(740) setdest 64025 20818 3.0" 
$ns at 846.2294174908118 "$node_(740) setdest 127511 24406 10.0" 
$ns at 750.3060855812357 "$node_(741) setdest 11284 9648 17.0" 
$ns at 811.949602970499 "$node_(742) setdest 86214 33056 16.0" 
$ns at 885.3509232194863 "$node_(742) setdest 43054 9210 4.0" 
$ns at 740.5487628437011 "$node_(743) setdest 64535 16706 11.0" 
$ns at 784.0367313935521 "$node_(743) setdest 103151 27691 15.0" 
$ns at 717.3576512358645 "$node_(744) setdest 119042 12354 6.0" 
$ns at 757.42341048063 "$node_(744) setdest 64486 12415 11.0" 
$ns at 896.0135549464435 "$node_(744) setdest 30003 16233 19.0" 
$ns at 791.029103159195 "$node_(745) setdest 53298 11657 17.0" 
$ns at 859.0863340089613 "$node_(745) setdest 88776 41197 4.0" 
$ns at 892.0874583368729 "$node_(745) setdest 126342 25919 4.0" 
$ns at 765.4203634756175 "$node_(746) setdest 95268 2843 13.0" 
$ns at 898.7619671113436 "$node_(746) setdest 126952 14250 4.0" 
$ns at 777.3655654313872 "$node_(747) setdest 81210 32292 1.0" 
$ns at 814.2467004883343 "$node_(747) setdest 11684 33926 1.0" 
$ns at 850.7242900178035 "$node_(747) setdest 77740 34273 17.0" 
$ns at 718.177395240222 "$node_(748) setdest 8058 2867 20.0" 
$ns at 850.2360730462095 "$node_(748) setdest 14823 5925 16.0" 
$ns at 892.2388607382478 "$node_(748) setdest 78488 35973 20.0" 
$ns at 747.8777707381141 "$node_(749) setdest 20289 10790 2.0" 
$ns at 786.9675497790432 "$node_(749) setdest 42996 29208 6.0" 
$ns at 858.0558140245615 "$node_(749) setdest 78934 41769 16.0" 
$ns at 760.3818733695337 "$node_(750) setdest 106062 34644 5.0" 
$ns at 816.6555372616698 "$node_(750) setdest 34571 8459 9.0" 
$ns at 728.1285839086482 "$node_(751) setdest 60991 19867 16.0" 
$ns at 764.3470364691457 "$node_(751) setdest 89836 10967 4.0" 
$ns at 802.1279898260427 "$node_(751) setdest 91012 39558 17.0" 
$ns at 714.1491148949767 "$node_(752) setdest 93457 9315 5.0" 
$ns at 757.2109991329105 "$node_(752) setdest 92022 43779 5.0" 
$ns at 836.3585774805573 "$node_(752) setdest 15265 36535 9.0" 
$ns at 770.7993493895307 "$node_(753) setdest 10593 3705 3.0" 
$ns at 809.4207271600226 "$node_(753) setdest 32215 43174 2.0" 
$ns at 851.0341240801307 "$node_(753) setdest 19996 17957 16.0" 
$ns at 707.0861796893691 "$node_(754) setdest 45562 34207 7.0" 
$ns at 781.1841320349134 "$node_(754) setdest 89988 32957 17.0" 
$ns at 822.6131496675541 "$node_(754) setdest 52390 26747 13.0" 
$ns at 873.7783324781452 "$node_(754) setdest 12872 28339 20.0" 
$ns at 774.4991134778155 "$node_(755) setdest 100002 20340 12.0" 
$ns at 724.3146094198787 "$node_(756) setdest 85224 24579 1.0" 
$ns at 759.4263672449056 "$node_(756) setdest 15918 36671 10.0" 
$ns at 823.013368306655 "$node_(756) setdest 5091 16821 4.0" 
$ns at 871.9851060673894 "$node_(756) setdest 133321 37524 19.0" 
$ns at 701.597263765316 "$node_(757) setdest 116189 1230 1.0" 
$ns at 734.8382607561006 "$node_(757) setdest 129844 746 12.0" 
$ns at 825.1322563984755 "$node_(757) setdest 10468 19200 14.0" 
$ns at 740.2154840763071 "$node_(758) setdest 59794 22893 9.0" 
$ns at 802.7170426822801 "$node_(758) setdest 63336 27136 16.0" 
$ns at 788.8726470522083 "$node_(759) setdest 63962 6243 13.0" 
$ns at 812.4995718926106 "$node_(760) setdest 118309 34603 15.0" 
$ns at 846.4210288139479 "$node_(761) setdest 64666 17810 3.0" 
$ns at 893.6976708996046 "$node_(761) setdest 33735 8141 17.0" 
$ns at 741.8376024257276 "$node_(762) setdest 22986 37445 20.0" 
$ns at 791.2811976313329 "$node_(762) setdest 19409 20255 13.0" 
$ns at 872.2503352253143 "$node_(762) setdest 40891 44031 1.0" 
$ns at 759.2805201271411 "$node_(763) setdest 125404 5426 6.0" 
$ns at 829.1094335770398 "$node_(763) setdest 17947 20100 6.0" 
$ns at 700.2928049015808 "$node_(764) setdest 132397 28363 16.0" 
$ns at 820.2187346432926 "$node_(764) setdest 55762 14115 18.0" 
$ns at 854.6974176503851 "$node_(764) setdest 52266 4208 10.0" 
$ns at 891.3060845792978 "$node_(764) setdest 119303 2490 11.0" 
$ns at 867.6392485840594 "$node_(765) setdest 48436 13724 19.0" 
$ns at 742.4449422813433 "$node_(766) setdest 103135 36995 16.0" 
$ns at 791.7922542896381 "$node_(766) setdest 67886 27214 15.0" 
$ns at 897.9507138265757 "$node_(766) setdest 98762 15349 8.0" 
$ns at 731.3586113912745 "$node_(767) setdest 64167 24858 18.0" 
$ns at 886.1713131297868 "$node_(767) setdest 99375 1483 16.0" 
$ns at 843.7049522388781 "$node_(768) setdest 28949 196 2.0" 
$ns at 888.6555025588696 "$node_(768) setdest 47502 40526 10.0" 
$ns at 786.8263122297362 "$node_(769) setdest 57333 12552 18.0" 
$ns at 859.0264551427738 "$node_(769) setdest 19074 25471 1.0" 
$ns at 894.0127536461706 "$node_(769) setdest 349 37524 7.0" 
$ns at 762.4009458199602 "$node_(770) setdest 83913 7572 18.0" 
$ns at 874.891001158664 "$node_(770) setdest 21153 43257 8.0" 
$ns at 712.9539631052539 "$node_(771) setdest 104149 7040 10.0" 
$ns at 829.9095447954936 "$node_(771) setdest 116449 27926 9.0" 
$ns at 865.172100148151 "$node_(771) setdest 131964 24801 7.0" 
$ns at 722.5563207281732 "$node_(772) setdest 40934 96 13.0" 
$ns at 753.0262593219655 "$node_(772) setdest 96810 34944 14.0" 
$ns at 889.3236855024863 "$node_(772) setdest 94140 40462 3.0" 
$ns at 726.92123783266 "$node_(773) setdest 78035 17557 14.0" 
$ns at 891.6072178491165 "$node_(773) setdest 69880 6862 7.0" 
$ns at 733.5852535766403 "$node_(774) setdest 105372 17889 2.0" 
$ns at 774.9411296046451 "$node_(774) setdest 121340 29940 4.0" 
$ns at 823.1799708008938 "$node_(774) setdest 93139 16875 13.0" 
$ns at 779.712326388149 "$node_(775) setdest 28057 11017 19.0" 
$ns at 836.4552369185205 "$node_(775) setdest 16925 35839 3.0" 
$ns at 888.8300294259218 "$node_(775) setdest 132905 22657 9.0" 
$ns at 782.8305268763411 "$node_(776) setdest 128241 3591 2.0" 
$ns at 819.4361797064278 "$node_(776) setdest 60970 42009 7.0" 
$ns at 888.5324554813681 "$node_(776) setdest 48351 38157 1.0" 
$ns at 709.4357623261883 "$node_(777) setdest 118929 32676 18.0" 
$ns at 868.6073583798383 "$node_(777) setdest 16640 32872 2.0" 
$ns at 702.8658795424831 "$node_(778) setdest 20522 39967 1.0" 
$ns at 737.0176656872221 "$node_(778) setdest 14068 18062 3.0" 
$ns at 796.9987967538432 "$node_(778) setdest 65936 31886 17.0" 
$ns at 835.72662221052 "$node_(778) setdest 64706 4138 16.0" 
$ns at 720.5741462413362 "$node_(779) setdest 6713 10938 18.0" 
$ns at 768.5559582810049 "$node_(779) setdest 43049 16344 7.0" 
$ns at 834.9370372161629 "$node_(779) setdest 33208 28265 16.0" 
$ns at 868.6492009141143 "$node_(779) setdest 108511 9140 16.0" 
$ns at 715.4413291140661 "$node_(780) setdest 88399 9974 13.0" 
$ns at 802.9912509090827 "$node_(780) setdest 117722 39167 16.0" 
$ns at 745.3209597013895 "$node_(781) setdest 108432 33869 4.0" 
$ns at 796.7022023735476 "$node_(781) setdest 105021 25636 5.0" 
$ns at 864.396892942395 "$node_(781) setdest 71299 39238 17.0" 
$ns at 700.189612463367 "$node_(782) setdest 7263 37109 10.0" 
$ns at 816.3564103637327 "$node_(782) setdest 61416 9046 13.0" 
$ns at 730.7020310172253 "$node_(783) setdest 42362 21875 8.0" 
$ns at 781.7432377573294 "$node_(783) setdest 71672 31092 19.0" 
$ns at 772.1745251922479 "$node_(784) setdest 127188 27752 1.0" 
$ns at 811.44335129308 "$node_(784) setdest 21680 7309 3.0" 
$ns at 843.1885294594616 "$node_(784) setdest 106490 2359 6.0" 
$ns at 773.4454830926547 "$node_(785) setdest 34465 34298 9.0" 
$ns at 833.7030793296788 "$node_(785) setdest 83612 29727 15.0" 
$ns at 707.0052148161249 "$node_(786) setdest 22067 33548 8.0" 
$ns at 744.1784167222297 "$node_(786) setdest 133897 31052 12.0" 
$ns at 829.2097987564747 "$node_(786) setdest 24687 41550 9.0" 
$ns at 892.6324121029176 "$node_(786) setdest 132424 21707 4.0" 
$ns at 702.3927396254732 "$node_(787) setdest 16928 4839 5.0" 
$ns at 771.4491426512213 "$node_(787) setdest 59618 18039 20.0" 
$ns at 718.8097108894875 "$node_(788) setdest 39519 19452 7.0" 
$ns at 796.0558117226146 "$node_(788) setdest 119527 8256 10.0" 
$ns at 830.4618592769016 "$node_(788) setdest 45023 42747 20.0" 
$ns at 792.8473492864737 "$node_(789) setdest 6234 49 8.0" 
$ns at 853.2637239296837 "$node_(789) setdest 72168 42455 6.0" 
$ns at 899.8507590008448 "$node_(789) setdest 79769 25486 17.0" 
$ns at 733.4012261151906 "$node_(790) setdest 63181 1144 4.0" 
$ns at 793.1865552336066 "$node_(790) setdest 79042 20855 4.0" 
$ns at 833.9122517687329 "$node_(790) setdest 57495 5924 9.0" 
$ns at 701.6199460949988 "$node_(791) setdest 58885 18920 20.0" 
$ns at 711.3871749396664 "$node_(792) setdest 126714 43023 18.0" 
$ns at 768.2146445635781 "$node_(792) setdest 53907 24164 7.0" 
$ns at 803.1954840382155 "$node_(792) setdest 133797 17797 7.0" 
$ns at 853.5566431441358 "$node_(792) setdest 33360 12137 2.0" 
$ns at 887.0145432021948 "$node_(792) setdest 51250 36452 10.0" 
$ns at 792.2776293187806 "$node_(793) setdest 109833 39427 20.0" 
$ns at 881.9241683155209 "$node_(793) setdest 56648 31861 7.0" 
$ns at 703.9965350589002 "$node_(794) setdest 122718 32724 9.0" 
$ns at 806.373565023126 "$node_(794) setdest 49253 23735 2.0" 
$ns at 853.9892258876773 "$node_(794) setdest 124144 39388 8.0" 
$ns at 789.8205094668028 "$node_(795) setdest 80397 20527 16.0" 
$ns at 711.1890917304063 "$node_(796) setdest 86176 20242 17.0" 
$ns at 796.3914273701581 "$node_(796) setdest 33706 36556 9.0" 
$ns at 848.0587253214067 "$node_(796) setdest 122115 34287 15.0" 
$ns at 707.3984168467152 "$node_(797) setdest 1869 48 11.0" 
$ns at 746.8406602566756 "$node_(797) setdest 23350 14021 6.0" 
$ns at 802.0819304511864 "$node_(797) setdest 40837 39158 11.0" 
$ns at 853.3144401518848 "$node_(797) setdest 44414 35122 12.0" 
$ns at 893.4193064369467 "$node_(797) setdest 128969 18122 7.0" 
$ns at 888.159602747175 "$node_(798) setdest 58645 29071 1.0" 
$ns at 752.4668911785458 "$node_(799) setdest 94933 13552 9.0" 
$ns at 836.50329388736 "$node_(799) setdest 101872 38716 12.0" 
$ns at 892.1875559632585 "$node_(799) setdest 64316 30769 6.0" 


#Set a TCP connection between node_(37) and node_(63)
set tcp_(0) [new Agent/TCP/Newreno]
$tcp_(0) set class_ 2
set sink_(0) [new Agent/TCPSink]
$ns attach-agent $node_(37) $tcp_(0)
$ns attach-agent $node_(63) $sink_(0)
$ns connect $tcp_(0) $sink_(0)
set ftp_(0) [new Application/FTP]
$ftp_(0) attach-agent $tcp_(0)
$ns at 0.2 "$ftp_(0) start"
$ns at 180.0 "$ftp_(0) stop"

#Set a TCP connection between node_(50) and node_(52)
set tcp_(1) [new Agent/TCP/Newreno]
$tcp_(1) set class_ 2
set sink_(1) [new Agent/TCPSink]
$ns attach-agent $node_(50) $tcp_(1)
$ns attach-agent $node_(52) $sink_(1)
$ns connect $tcp_(1) $sink_(1)
set ftp_(1) [new Application/FTP]
$ftp_(1) attach-agent $tcp_(1)
$ns at 180.2 "$ftp_(1) start"
$ns at 360.0 "$ftp_(1) stop"

#Set a TCP connection between node_(44) and node_(41)
set tcp_(2) [new Agent/TCP/Newreno]
$tcp_(2) set class_ 2
set sink_(2) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(2)
$ns attach-agent $node_(41) $sink_(2)
$ns connect $tcp_(2) $sink_(2)
set ftp_(2) [new Application/FTP]
$ftp_(2) attach-agent $tcp_(2)
$ns at 360.2 "$ftp_(2) start"
$ns at 540.0 "$ftp_(2) stop"

#Set a TCP connection between node_(96) and node_(22)
set tcp_(3) [new Agent/TCP/Newreno]
$tcp_(3) set class_ 2
set sink_(3) [new Agent/TCPSink]
$ns attach-agent $node_(96) $tcp_(3)
$ns attach-agent $node_(22) $sink_(3)
$ns connect $tcp_(3) $sink_(3)
set ftp_(3) [new Application/FTP]
$ftp_(3) attach-agent $tcp_(3)
$ns at 540.2 "$ftp_(3) start"
$ns at 720.0 "$ftp_(3) stop"

#Set a TCP connection between node_(7) and node_(42)
set tcp_(4) [new Agent/TCP/Newreno]
$tcp_(4) set class_ 2
set sink_(4) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(4)
$ns attach-agent $node_(42) $sink_(4)
$ns connect $tcp_(4) $sink_(4)
set ftp_(4) [new Application/FTP]
$ftp_(4) attach-agent $tcp_(4)
$ns at 720.2 "$ftp_(4) start"
$ns at 900.0 "$ftp_(4) stop"

#Set a TCP connection between node_(54) and node_(4)
set tcp_(5) [new Agent/TCP/Newreno]
$tcp_(5) set class_ 2
set sink_(5) [new Agent/TCPSink]
$ns attach-agent $node_(54) $tcp_(5)
$ns attach-agent $node_(4) $sink_(5)
$ns connect $tcp_(5) $sink_(5)
set ftp_(5) [new Application/FTP]
$ftp_(5) attach-agent $tcp_(5)
$ns at 0.2 "$ftp_(5) start"
$ns at 180.0 "$ftp_(5) stop"

#Set a TCP connection between node_(62) and node_(50)
set tcp_(6) [new Agent/TCP/Newreno]
$tcp_(6) set class_ 2
set sink_(6) [new Agent/TCPSink]
$ns attach-agent $node_(62) $tcp_(6)
$ns attach-agent $node_(50) $sink_(6)
$ns connect $tcp_(6) $sink_(6)
set ftp_(6) [new Application/FTP]
$ftp_(6) attach-agent $tcp_(6)
$ns at 180.2 "$ftp_(6) start"
$ns at 360.0 "$ftp_(6) stop"

#Set a TCP connection between node_(24) and node_(82)
set tcp_(7) [new Agent/TCP/Newreno]
$tcp_(7) set class_ 2
set sink_(7) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(7)
$ns attach-agent $node_(82) $sink_(7)
$ns connect $tcp_(7) $sink_(7)
set ftp_(7) [new Application/FTP]
$ftp_(7) attach-agent $tcp_(7)
$ns at 360.2 "$ftp_(7) start"
$ns at 540.0 "$ftp_(7) stop"

#Set a TCP connection between node_(34) and node_(92)
set tcp_(8) [new Agent/TCP/Newreno]
$tcp_(8) set class_ 2
set sink_(8) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(8)
$ns attach-agent $node_(92) $sink_(8)
$ns connect $tcp_(8) $sink_(8)
set ftp_(8) [new Application/FTP]
$ftp_(8) attach-agent $tcp_(8)
$ns at 540.2 "$ftp_(8) start"
$ns at 720.0 "$ftp_(8) stop"

#Set a TCP connection between node_(37) and node_(54)
set tcp_(9) [new Agent/TCP/Newreno]
$tcp_(9) set class_ 2
set sink_(9) [new Agent/TCPSink]
$ns attach-agent $node_(37) $tcp_(9)
$ns attach-agent $node_(54) $sink_(9)
$ns connect $tcp_(9) $sink_(9)
set ftp_(9) [new Application/FTP]
$ftp_(9) attach-agent $tcp_(9)
$ns at 720.2 "$ftp_(9) start"
$ns at 900.0 "$ftp_(9) stop"

#Set a TCP connection between node_(89) and node_(25)
set tcp_(10) [new Agent/TCP/Newreno]
$tcp_(10) set class_ 2
set sink_(10) [new Agent/TCPSink]
$ns attach-agent $node_(89) $tcp_(10)
$ns attach-agent $node_(25) $sink_(10)
$ns connect $tcp_(10) $sink_(10)
set ftp_(10) [new Application/FTP]
$ftp_(10) attach-agent $tcp_(10)
$ns at 0.2 "$ftp_(10) start"
$ns at 180.0 "$ftp_(10) stop"

#Set a TCP connection between node_(71) and node_(84)
set tcp_(11) [new Agent/TCP/Newreno]
$tcp_(11) set class_ 2
set sink_(11) [new Agent/TCPSink]
$ns attach-agent $node_(71) $tcp_(11)
$ns attach-agent $node_(84) $sink_(11)
$ns connect $tcp_(11) $sink_(11)
set ftp_(11) [new Application/FTP]
$ftp_(11) attach-agent $tcp_(11)
$ns at 180.2 "$ftp_(11) start"
$ns at 360.0 "$ftp_(11) stop"

#Set a TCP connection between node_(90) and node_(45)
set tcp_(12) [new Agent/TCP/Newreno]
$tcp_(12) set class_ 2
set sink_(12) [new Agent/TCPSink]
$ns attach-agent $node_(90) $tcp_(12)
$ns attach-agent $node_(45) $sink_(12)
$ns connect $tcp_(12) $sink_(12)
set ftp_(12) [new Application/FTP]
$ftp_(12) attach-agent $tcp_(12)
$ns at 360.2 "$ftp_(12) start"
$ns at 540.0 "$ftp_(12) stop"

#Set a TCP connection between node_(60) and node_(6)
set tcp_(13) [new Agent/TCP/Newreno]
$tcp_(13) set class_ 2
set sink_(13) [new Agent/TCPSink]
$ns attach-agent $node_(60) $tcp_(13)
$ns attach-agent $node_(6) $sink_(13)
$ns connect $tcp_(13) $sink_(13)
set ftp_(13) [new Application/FTP]
$ftp_(13) attach-agent $tcp_(13)
$ns at 540.2 "$ftp_(13) start"
$ns at 720.0 "$ftp_(13) stop"

#Set a TCP connection between node_(24) and node_(68)
set tcp_(14) [new Agent/TCP/Newreno]
$tcp_(14) set class_ 2
set sink_(14) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(14)
$ns attach-agent $node_(68) $sink_(14)
$ns connect $tcp_(14) $sink_(14)
set ftp_(14) [new Application/FTP]
$ftp_(14) attach-agent $tcp_(14)
$ns at 720.2 "$ftp_(14) start"
$ns at 900.0 "$ftp_(14) stop"

#Set a TCP connection between node_(91) and node_(29)
set tcp_(15) [new Agent/TCP/Newreno]
$tcp_(15) set class_ 2
set sink_(15) [new Agent/TCPSink]
$ns attach-agent $node_(91) $tcp_(15)
$ns attach-agent $node_(29) $sink_(15)
$ns connect $tcp_(15) $sink_(15)
set ftp_(15) [new Application/FTP]
$ftp_(15) attach-agent $tcp_(15)
$ns at 0.2 "$ftp_(15) start"
$ns at 180.0 "$ftp_(15) stop"

#Set a TCP connection between node_(95) and node_(17)
set tcp_(16) [new Agent/TCP/Newreno]
$tcp_(16) set class_ 2
set sink_(16) [new Agent/TCPSink]
$ns attach-agent $node_(95) $tcp_(16)
$ns attach-agent $node_(17) $sink_(16)
$ns connect $tcp_(16) $sink_(16)
set ftp_(16) [new Application/FTP]
$ftp_(16) attach-agent $tcp_(16)
$ns at 180.2 "$ftp_(16) start"
$ns at 360.0 "$ftp_(16) stop"

#Set a TCP connection between node_(18) and node_(85)
set tcp_(17) [new Agent/TCP/Newreno]
$tcp_(17) set class_ 2
set sink_(17) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(17)
$ns attach-agent $node_(85) $sink_(17)
$ns connect $tcp_(17) $sink_(17)
set ftp_(17) [new Application/FTP]
$ftp_(17) attach-agent $tcp_(17)
$ns at 360.2 "$ftp_(17) start"
$ns at 540.0 "$ftp_(17) stop"

#Set a TCP connection between node_(70) and node_(4)
set tcp_(18) [new Agent/TCP/Newreno]
$tcp_(18) set class_ 2
set sink_(18) [new Agent/TCPSink]
$ns attach-agent $node_(70) $tcp_(18)
$ns attach-agent $node_(4) $sink_(18)
$ns connect $tcp_(18) $sink_(18)
set ftp_(18) [new Application/FTP]
$ftp_(18) attach-agent $tcp_(18)
$ns at 540.2 "$ftp_(18) start"
$ns at 720.0 "$ftp_(18) stop"

#Set a TCP connection between node_(43) and node_(33)
set tcp_(19) [new Agent/TCP/Newreno]
$tcp_(19) set class_ 2
set sink_(19) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(19)
$ns attach-agent $node_(33) $sink_(19)
$ns connect $tcp_(19) $sink_(19)
set ftp_(19) [new Application/FTP]
$ftp_(19) attach-agent $tcp_(19)
$ns at 720.2 "$ftp_(19) start"
$ns at 900.0 "$ftp_(19) stop"

#Set a TCP connection between node_(55) and node_(31)
set tcp_(20) [new Agent/TCP/Newreno]
$tcp_(20) set class_ 2
set sink_(20) [new Agent/TCPSink]
$ns attach-agent $node_(55) $tcp_(20)
$ns attach-agent $node_(31) $sink_(20)
$ns connect $tcp_(20) $sink_(20)
set ftp_(20) [new Application/FTP]
$ftp_(20) attach-agent $tcp_(20)
$ns at 0.2 "$ftp_(20) start"
$ns at 180.0 "$ftp_(20) stop"

#Set a TCP connection between node_(95) and node_(24)
set tcp_(21) [new Agent/TCP/Newreno]
$tcp_(21) set class_ 2
set sink_(21) [new Agent/TCPSink]
$ns attach-agent $node_(95) $tcp_(21)
$ns attach-agent $node_(24) $sink_(21)
$ns connect $tcp_(21) $sink_(21)
set ftp_(21) [new Application/FTP]
$ftp_(21) attach-agent $tcp_(21)
$ns at 180.2 "$ftp_(21) start"
$ns at 360.0 "$ftp_(21) stop"

#Set a TCP connection between node_(17) and node_(47)
set tcp_(22) [new Agent/TCP/Newreno]
$tcp_(22) set class_ 2
set sink_(22) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(22)
$ns attach-agent $node_(47) $sink_(22)
$ns connect $tcp_(22) $sink_(22)
set ftp_(22) [new Application/FTP]
$ftp_(22) attach-agent $tcp_(22)
$ns at 360.2 "$ftp_(22) start"
$ns at 540.0 "$ftp_(22) stop"

#Set a TCP connection between node_(95) and node_(64)
set tcp_(23) [new Agent/TCP/Newreno]
$tcp_(23) set class_ 2
set sink_(23) [new Agent/TCPSink]
$ns attach-agent $node_(95) $tcp_(23)
$ns attach-agent $node_(64) $sink_(23)
$ns connect $tcp_(23) $sink_(23)
set ftp_(23) [new Application/FTP]
$ftp_(23) attach-agent $tcp_(23)
$ns at 540.2 "$ftp_(23) start"
$ns at 720.0 "$ftp_(23) stop"

#Set a TCP connection between node_(64) and node_(92)
set tcp_(24) [new Agent/TCP/Newreno]
$tcp_(24) set class_ 2
set sink_(24) [new Agent/TCPSink]
$ns attach-agent $node_(64) $tcp_(24)
$ns attach-agent $node_(92) $sink_(24)
$ns connect $tcp_(24) $sink_(24)
set ftp_(24) [new Application/FTP]
$ftp_(24) attach-agent $tcp_(24)
$ns at 720.2 "$ftp_(24) start"
$ns at 900.0 "$ftp_(24) stop"

#Set a TCP connection between node_(93) and node_(64)
set tcp_(25) [new Agent/TCP/Newreno]
$tcp_(25) set class_ 2
set sink_(25) [new Agent/TCPSink]
$ns attach-agent $node_(93) $tcp_(25)
$ns attach-agent $node_(64) $sink_(25)
$ns connect $tcp_(25) $sink_(25)
set ftp_(25) [new Application/FTP]
$ftp_(25) attach-agent $tcp_(25)
$ns at 0.2 "$ftp_(25) start"
$ns at 180.0 "$ftp_(25) stop"

#Set a TCP connection between node_(11) and node_(62)
set tcp_(26) [new Agent/TCP/Newreno]
$tcp_(26) set class_ 2
set sink_(26) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(26)
$ns attach-agent $node_(62) $sink_(26)
$ns connect $tcp_(26) $sink_(26)
set ftp_(26) [new Application/FTP]
$ftp_(26) attach-agent $tcp_(26)
$ns at 180.2 "$ftp_(26) start"
$ns at 360.0 "$ftp_(26) stop"

#Set a TCP connection between node_(3) and node_(37)
set tcp_(27) [new Agent/TCP/Newreno]
$tcp_(27) set class_ 2
set sink_(27) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(27)
$ns attach-agent $node_(37) $sink_(27)
$ns connect $tcp_(27) $sink_(27)
set ftp_(27) [new Application/FTP]
$ftp_(27) attach-agent $tcp_(27)
$ns at 360.2 "$ftp_(27) start"
$ns at 540.0 "$ftp_(27) stop"

#Set a TCP connection between node_(49) and node_(55)
set tcp_(28) [new Agent/TCP/Newreno]
$tcp_(28) set class_ 2
set sink_(28) [new Agent/TCPSink]
$ns attach-agent $node_(49) $tcp_(28)
$ns attach-agent $node_(55) $sink_(28)
$ns connect $tcp_(28) $sink_(28)
set ftp_(28) [new Application/FTP]
$ftp_(28) attach-agent $tcp_(28)
$ns at 540.2 "$ftp_(28) start"
$ns at 720.0 "$ftp_(28) stop"

#Set a TCP connection between node_(28) and node_(8)
set tcp_(29) [new Agent/TCP/Newreno]
$tcp_(29) set class_ 2
set sink_(29) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(29)
$ns attach-agent $node_(8) $sink_(29)
$ns connect $tcp_(29) $sink_(29)
set ftp_(29) [new Application/FTP]
$ftp_(29) attach-agent $tcp_(29)
$ns at 720.2 "$ftp_(29) start"
$ns at 900.0 "$ftp_(29) stop"

#Set a TCP connection between node_(3) and node_(65)
set tcp_(30) [new Agent/TCP/Newreno]
$tcp_(30) set class_ 2
set sink_(30) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(30)
$ns attach-agent $node_(65) $sink_(30)
$ns connect $tcp_(30) $sink_(30)
set ftp_(30) [new Application/FTP]
$ftp_(30) attach-agent $tcp_(30)
$ns at 0.2 "$ftp_(30) start"
$ns at 180.0 "$ftp_(30) stop"

#Set a TCP connection between node_(85) and node_(76)
set tcp_(31) [new Agent/TCP/Newreno]
$tcp_(31) set class_ 2
set sink_(31) [new Agent/TCPSink]
$ns attach-agent $node_(85) $tcp_(31)
$ns attach-agent $node_(76) $sink_(31)
$ns connect $tcp_(31) $sink_(31)
set ftp_(31) [new Application/FTP]
$ftp_(31) attach-agent $tcp_(31)
$ns at 180.2 "$ftp_(31) start"
$ns at 360.0 "$ftp_(31) stop"

#Set a TCP connection between node_(88) and node_(20)
set tcp_(32) [new Agent/TCP/Newreno]
$tcp_(32) set class_ 2
set sink_(32) [new Agent/TCPSink]
$ns attach-agent $node_(88) $tcp_(32)
$ns attach-agent $node_(20) $sink_(32)
$ns connect $tcp_(32) $sink_(32)
set ftp_(32) [new Application/FTP]
$ftp_(32) attach-agent $tcp_(32)
$ns at 360.2 "$ftp_(32) start"
$ns at 540.0 "$ftp_(32) stop"

#Set a TCP connection between node_(52) and node_(37)
set tcp_(33) [new Agent/TCP/Newreno]
$tcp_(33) set class_ 2
set sink_(33) [new Agent/TCPSink]
$ns attach-agent $node_(52) $tcp_(33)
$ns attach-agent $node_(37) $sink_(33)
$ns connect $tcp_(33) $sink_(33)
set ftp_(33) [new Application/FTP]
$ftp_(33) attach-agent $tcp_(33)
$ns at 540.2 "$ftp_(33) start"
$ns at 720.0 "$ftp_(33) stop"

#Set a TCP connection between node_(25) and node_(48)
set tcp_(34) [new Agent/TCP/Newreno]
$tcp_(34) set class_ 2
set sink_(34) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(34)
$ns attach-agent $node_(48) $sink_(34)
$ns connect $tcp_(34) $sink_(34)
set ftp_(34) [new Application/FTP]
$ftp_(34) attach-agent $tcp_(34)
$ns at 720.2 "$ftp_(34) start"
$ns at 900.0 "$ftp_(34) stop"

#Set a TCP connection between node_(60) and node_(36)
set tcp_(35) [new Agent/TCP/Newreno]
$tcp_(35) set class_ 2
set sink_(35) [new Agent/TCPSink]
$ns attach-agent $node_(60) $tcp_(35)
$ns attach-agent $node_(36) $sink_(35)
$ns connect $tcp_(35) $sink_(35)
set ftp_(35) [new Application/FTP]
$ftp_(35) attach-agent $tcp_(35)
$ns at 0.2 "$ftp_(35) start"
$ns at 180.0 "$ftp_(35) stop"

#Set a TCP connection between node_(98) and node_(69)
set tcp_(36) [new Agent/TCP/Newreno]
$tcp_(36) set class_ 2
set sink_(36) [new Agent/TCPSink]
$ns attach-agent $node_(98) $tcp_(36)
$ns attach-agent $node_(69) $sink_(36)
$ns connect $tcp_(36) $sink_(36)
set ftp_(36) [new Application/FTP]
$ftp_(36) attach-agent $tcp_(36)
$ns at 180.2 "$ftp_(36) start"
$ns at 360.0 "$ftp_(36) stop"

#Set a TCP connection between node_(56) and node_(81)
set tcp_(37) [new Agent/TCP/Newreno]
$tcp_(37) set class_ 2
set sink_(37) [new Agent/TCPSink]
$ns attach-agent $node_(56) $tcp_(37)
$ns attach-agent $node_(81) $sink_(37)
$ns connect $tcp_(37) $sink_(37)
set ftp_(37) [new Application/FTP]
$ftp_(37) attach-agent $tcp_(37)
$ns at 360.2 "$ftp_(37) start"
$ns at 540.0 "$ftp_(37) stop"

#Set a TCP connection between node_(27) and node_(75)
set tcp_(38) [new Agent/TCP/Newreno]
$tcp_(38) set class_ 2
set sink_(38) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(38)
$ns attach-agent $node_(75) $sink_(38)
$ns connect $tcp_(38) $sink_(38)
set ftp_(38) [new Application/FTP]
$ftp_(38) attach-agent $tcp_(38)
$ns at 540.2 "$ftp_(38) start"
$ns at 720.0 "$ftp_(38) stop"

#Set a TCP connection between node_(47) and node_(84)
set tcp_(39) [new Agent/TCP/Newreno]
$tcp_(39) set class_ 2
set sink_(39) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(39)
$ns attach-agent $node_(84) $sink_(39)
$ns connect $tcp_(39) $sink_(39)
set ftp_(39) [new Application/FTP]
$ftp_(39) attach-agent $tcp_(39)
$ns at 720.2 "$ftp_(39) start"
$ns at 900.0 "$ftp_(39) stop"

#Set a TCP connection between node_(89) and node_(44)
set tcp_(40) [new Agent/TCP/Newreno]
$tcp_(40) set class_ 2
set sink_(40) [new Agent/TCPSink]
$ns attach-agent $node_(89) $tcp_(40)
$ns attach-agent $node_(44) $sink_(40)
$ns connect $tcp_(40) $sink_(40)
set ftp_(40) [new Application/FTP]
$ftp_(40) attach-agent $tcp_(40)
$ns at 0.2 "$ftp_(40) start"
$ns at 180.0 "$ftp_(40) stop"

#Set a TCP connection between node_(1) and node_(10)
set tcp_(41) [new Agent/TCP/Newreno]
$tcp_(41) set class_ 2
set sink_(41) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(41)
$ns attach-agent $node_(10) $sink_(41)
$ns connect $tcp_(41) $sink_(41)
set ftp_(41) [new Application/FTP]
$ftp_(41) attach-agent $tcp_(41)
$ns at 180.2 "$ftp_(41) start"
$ns at 360.0 "$ftp_(41) stop"

#Set a TCP connection between node_(48) and node_(13)
set tcp_(42) [new Agent/TCP/Newreno]
$tcp_(42) set class_ 2
set sink_(42) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(42)
$ns attach-agent $node_(13) $sink_(42)
$ns connect $tcp_(42) $sink_(42)
set ftp_(42) [new Application/FTP]
$ftp_(42) attach-agent $tcp_(42)
$ns at 360.2 "$ftp_(42) start"
$ns at 540.0 "$ftp_(42) stop"

#Set a TCP connection between node_(63) and node_(90)
set tcp_(43) [new Agent/TCP/Newreno]
$tcp_(43) set class_ 2
set sink_(43) [new Agent/TCPSink]
$ns attach-agent $node_(63) $tcp_(43)
$ns attach-agent $node_(90) $sink_(43)
$ns connect $tcp_(43) $sink_(43)
set ftp_(43) [new Application/FTP]
$ftp_(43) attach-agent $tcp_(43)
$ns at 540.2 "$ftp_(43) start"
$ns at 720.0 "$ftp_(43) stop"

#Set a TCP connection between node_(18) and node_(64)
set tcp_(44) [new Agent/TCP/Newreno]
$tcp_(44) set class_ 2
set sink_(44) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(44)
$ns attach-agent $node_(64) $sink_(44)
$ns connect $tcp_(44) $sink_(44)
set ftp_(44) [new Application/FTP]
$ftp_(44) attach-agent $tcp_(44)
$ns at 720.2 "$ftp_(44) start"
$ns at 900.0 "$ftp_(44) stop"

#Set a TCP connection between node_(88) and node_(17)
set tcp_(45) [new Agent/TCP/Newreno]
$tcp_(45) set class_ 2
set sink_(45) [new Agent/TCPSink]
$ns attach-agent $node_(88) $tcp_(45)
$ns attach-agent $node_(17) $sink_(45)
$ns connect $tcp_(45) $sink_(45)
set ftp_(45) [new Application/FTP]
$ftp_(45) attach-agent $tcp_(45)
$ns at 0.2 "$ftp_(45) start"
$ns at 180.0 "$ftp_(45) stop"

#Set a TCP connection between node_(62) and node_(57)
set tcp_(46) [new Agent/TCP/Newreno]
$tcp_(46) set class_ 2
set sink_(46) [new Agent/TCPSink]
$ns attach-agent $node_(62) $tcp_(46)
$ns attach-agent $node_(57) $sink_(46)
$ns connect $tcp_(46) $sink_(46)
set ftp_(46) [new Application/FTP]
$ftp_(46) attach-agent $tcp_(46)
$ns at 180.2 "$ftp_(46) start"
$ns at 360.0 "$ftp_(46) stop"

#Set a TCP connection between node_(64) and node_(58)
set tcp_(47) [new Agent/TCP/Newreno]
$tcp_(47) set class_ 2
set sink_(47) [new Agent/TCPSink]
$ns attach-agent $node_(64) $tcp_(47)
$ns attach-agent $node_(58) $sink_(47)
$ns connect $tcp_(47) $sink_(47)
set ftp_(47) [new Application/FTP]
$ftp_(47) attach-agent $tcp_(47)
$ns at 360.2 "$ftp_(47) start"
$ns at 540.0 "$ftp_(47) stop"

#Set a TCP connection between node_(50) and node_(43)
set tcp_(48) [new Agent/TCP/Newreno]
$tcp_(48) set class_ 2
set sink_(48) [new Agent/TCPSink]
$ns attach-agent $node_(50) $tcp_(48)
$ns attach-agent $node_(43) $sink_(48)
$ns connect $tcp_(48) $sink_(48)
set ftp_(48) [new Application/FTP]
$ftp_(48) attach-agent $tcp_(48)
$ns at 540.2 "$ftp_(48) start"
$ns at 720.0 "$ftp_(48) stop"

#Set a TCP connection between node_(75) and node_(55)
set tcp_(49) [new Agent/TCP/Newreno]
$tcp_(49) set class_ 2
set sink_(49) [new Agent/TCPSink]
$ns attach-agent $node_(75) $tcp_(49)
$ns attach-agent $node_(55) $sink_(49)
$ns connect $tcp_(49) $sink_(49)
set ftp_(49) [new Application/FTP]
$ftp_(49) attach-agent $tcp_(49)
$ns at 720.2 "$ftp_(49) start"
$ns at 900.0 "$ftp_(49) stop"

#Set a TCP connection between node_(33) and node_(65)
set tcp_(50) [new Agent/TCP/Newreno]
$tcp_(50) set class_ 2
set sink_(50) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(50)
$ns attach-agent $node_(65) $sink_(50)
$ns connect $tcp_(50) $sink_(50)
set ftp_(50) [new Application/FTP]
$ftp_(50) attach-agent $tcp_(50)
$ns at 0.2 "$ftp_(50) start"
$ns at 180.0 "$ftp_(50) stop"

#Set a TCP connection between node_(14) and node_(0)
set tcp_(51) [new Agent/TCP/Newreno]
$tcp_(51) set class_ 2
set sink_(51) [new Agent/TCPSink]
$ns attach-agent $node_(14) $tcp_(51)
$ns attach-agent $node_(0) $sink_(51)
$ns connect $tcp_(51) $sink_(51)
set ftp_(51) [new Application/FTP]
$ftp_(51) attach-agent $tcp_(51)
$ns at 180.2 "$ftp_(51) start"
$ns at 360.0 "$ftp_(51) stop"

#Set a TCP connection between node_(30) and node_(39)
set tcp_(52) [new Agent/TCP/Newreno]
$tcp_(52) set class_ 2
set sink_(52) [new Agent/TCPSink]
$ns attach-agent $node_(30) $tcp_(52)
$ns attach-agent $node_(39) $sink_(52)
$ns connect $tcp_(52) $sink_(52)
set ftp_(52) [new Application/FTP]
$ftp_(52) attach-agent $tcp_(52)
$ns at 360.2 "$ftp_(52) start"
$ns at 540.0 "$ftp_(52) stop"

#Set a TCP connection between node_(67) and node_(22)
set tcp_(53) [new Agent/TCP/Newreno]
$tcp_(53) set class_ 2
set sink_(53) [new Agent/TCPSink]
$ns attach-agent $node_(67) $tcp_(53)
$ns attach-agent $node_(22) $sink_(53)
$ns connect $tcp_(53) $sink_(53)
set ftp_(53) [new Application/FTP]
$ftp_(53) attach-agent $tcp_(53)
$ns at 540.2 "$ftp_(53) start"
$ns at 720.0 "$ftp_(53) stop"

#Set a TCP connection between node_(44) and node_(12)
set tcp_(54) [new Agent/TCP/Newreno]
$tcp_(54) set class_ 2
set sink_(54) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(54)
$ns attach-agent $node_(12) $sink_(54)
$ns connect $tcp_(54) $sink_(54)
set ftp_(54) [new Application/FTP]
$ftp_(54) attach-agent $tcp_(54)
$ns at 720.2 "$ftp_(54) start"
$ns at 900.0 "$ftp_(54) stop"

#Set a TCP connection between node_(75) and node_(37)
set tcp_(55) [new Agent/TCP/Newreno]
$tcp_(55) set class_ 2
set sink_(55) [new Agent/TCPSink]
$ns attach-agent $node_(75) $tcp_(55)
$ns attach-agent $node_(37) $sink_(55)
$ns connect $tcp_(55) $sink_(55)
set ftp_(55) [new Application/FTP]
$ftp_(55) attach-agent $tcp_(55)
$ns at 0.2 "$ftp_(55) start"
$ns at 180.0 "$ftp_(55) stop"

#Set a TCP connection between node_(79) and node_(50)
set tcp_(56) [new Agent/TCP/Newreno]
$tcp_(56) set class_ 2
set sink_(56) [new Agent/TCPSink]
$ns attach-agent $node_(79) $tcp_(56)
$ns attach-agent $node_(50) $sink_(56)
$ns connect $tcp_(56) $sink_(56)
set ftp_(56) [new Application/FTP]
$ftp_(56) attach-agent $tcp_(56)
$ns at 180.2 "$ftp_(56) start"
$ns at 360.0 "$ftp_(56) stop"

#Set a TCP connection between node_(63) and node_(90)
set tcp_(57) [new Agent/TCP/Newreno]
$tcp_(57) set class_ 2
set sink_(57) [new Agent/TCPSink]
$ns attach-agent $node_(63) $tcp_(57)
$ns attach-agent $node_(90) $sink_(57)
$ns connect $tcp_(57) $sink_(57)
set ftp_(57) [new Application/FTP]
$ftp_(57) attach-agent $tcp_(57)
$ns at 360.2 "$ftp_(57) start"
$ns at 540.0 "$ftp_(57) stop"

#Set a TCP connection between node_(21) and node_(13)
set tcp_(58) [new Agent/TCP/Newreno]
$tcp_(58) set class_ 2
set sink_(58) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(58)
$ns attach-agent $node_(13) $sink_(58)
$ns connect $tcp_(58) $sink_(58)
set ftp_(58) [new Application/FTP]
$ftp_(58) attach-agent $tcp_(58)
$ns at 540.2 "$ftp_(58) start"
$ns at 720.0 "$ftp_(58) stop"

#Set a TCP connection between node_(55) and node_(80)
set tcp_(59) [new Agent/TCP/Newreno]
$tcp_(59) set class_ 2
set sink_(59) [new Agent/TCPSink]
$ns attach-agent $node_(55) $tcp_(59)
$ns attach-agent $node_(80) $sink_(59)
$ns connect $tcp_(59) $sink_(59)
set ftp_(59) [new Application/FTP]
$ftp_(59) attach-agent $tcp_(59)
$ns at 720.2 "$ftp_(59) start"
$ns at 900.0 "$ftp_(59) stop"

#Set a TCP connection between node_(5) and node_(47)
set tcp_(60) [new Agent/TCP/Newreno]
$tcp_(60) set class_ 2
set sink_(60) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(60)
$ns attach-agent $node_(47) $sink_(60)
$ns connect $tcp_(60) $sink_(60)
set ftp_(60) [new Application/FTP]
$ftp_(60) attach-agent $tcp_(60)
$ns at 0.2 "$ftp_(60) start"
$ns at 180.0 "$ftp_(60) stop"

#Set a TCP connection between node_(39) and node_(67)
set tcp_(61) [new Agent/TCP/Newreno]
$tcp_(61) set class_ 2
set sink_(61) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(61)
$ns attach-agent $node_(67) $sink_(61)
$ns connect $tcp_(61) $sink_(61)
set ftp_(61) [new Application/FTP]
$ftp_(61) attach-agent $tcp_(61)
$ns at 180.2 "$ftp_(61) start"
$ns at 360.0 "$ftp_(61) stop"

#Set a TCP connection between node_(34) and node_(9)
set tcp_(62) [new Agent/TCP/Newreno]
$tcp_(62) set class_ 2
set sink_(62) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(62)
$ns attach-agent $node_(9) $sink_(62)
$ns connect $tcp_(62) $sink_(62)
set ftp_(62) [new Application/FTP]
$ftp_(62) attach-agent $tcp_(62)
$ns at 360.2 "$ftp_(62) start"
$ns at 540.0 "$ftp_(62) stop"

#Set a TCP connection between node_(53) and node_(25)
set tcp_(63) [new Agent/TCP/Newreno]
$tcp_(63) set class_ 2
set sink_(63) [new Agent/TCPSink]
$ns attach-agent $node_(53) $tcp_(63)
$ns attach-agent $node_(25) $sink_(63)
$ns connect $tcp_(63) $sink_(63)
set ftp_(63) [new Application/FTP]
$ftp_(63) attach-agent $tcp_(63)
$ns at 540.2 "$ftp_(63) start"
$ns at 720.0 "$ftp_(63) stop"

#Set a TCP connection between node_(77) and node_(91)
set tcp_(64) [new Agent/TCP/Newreno]
$tcp_(64) set class_ 2
set sink_(64) [new Agent/TCPSink]
$ns attach-agent $node_(77) $tcp_(64)
$ns attach-agent $node_(91) $sink_(64)
$ns connect $tcp_(64) $sink_(64)
set ftp_(64) [new Application/FTP]
$ftp_(64) attach-agent $tcp_(64)
$ns at 720.2 "$ftp_(64) start"
$ns at 900.0 "$ftp_(64) stop"

#Set a TCP connection between node_(84) and node_(0)
set tcp_(65) [new Agent/TCP/Newreno]
$tcp_(65) set class_ 2
set sink_(65) [new Agent/TCPSink]
$ns attach-agent $node_(84) $tcp_(65)
$ns attach-agent $node_(0) $sink_(65)
$ns connect $tcp_(65) $sink_(65)
set ftp_(65) [new Application/FTP]
$ftp_(65) attach-agent $tcp_(65)
$ns at 0.2 "$ftp_(65) start"
$ns at 180.0 "$ftp_(65) stop"

#Set a TCP connection between node_(63) and node_(79)
set tcp_(66) [new Agent/TCP/Newreno]
$tcp_(66) set class_ 2
set sink_(66) [new Agent/TCPSink]
$ns attach-agent $node_(63) $tcp_(66)
$ns attach-agent $node_(79) $sink_(66)
$ns connect $tcp_(66) $sink_(66)
set ftp_(66) [new Application/FTP]
$ftp_(66) attach-agent $tcp_(66)
$ns at 180.2 "$ftp_(66) start"
$ns at 360.0 "$ftp_(66) stop"

#Set a TCP connection between node_(93) and node_(53)
set tcp_(67) [new Agent/TCP/Newreno]
$tcp_(67) set class_ 2
set sink_(67) [new Agent/TCPSink]
$ns attach-agent $node_(93) $tcp_(67)
$ns attach-agent $node_(53) $sink_(67)
$ns connect $tcp_(67) $sink_(67)
set ftp_(67) [new Application/FTP]
$ftp_(67) attach-agent $tcp_(67)
$ns at 360.2 "$ftp_(67) start"
$ns at 540.0 "$ftp_(67) stop"

#Set a TCP connection between node_(6) and node_(93)
set tcp_(68) [new Agent/TCP/Newreno]
$tcp_(68) set class_ 2
set sink_(68) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(68)
$ns attach-agent $node_(93) $sink_(68)
$ns connect $tcp_(68) $sink_(68)
set ftp_(68) [new Application/FTP]
$ftp_(68) attach-agent $tcp_(68)
$ns at 540.2 "$ftp_(68) start"
$ns at 720.0 "$ftp_(68) stop"

#Set a TCP connection between node_(27) and node_(74)
set tcp_(69) [new Agent/TCP/Newreno]
$tcp_(69) set class_ 2
set sink_(69) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(69)
$ns attach-agent $node_(74) $sink_(69)
$ns connect $tcp_(69) $sink_(69)
set ftp_(69) [new Application/FTP]
$ftp_(69) attach-agent $tcp_(69)
$ns at 720.2 "$ftp_(69) start"
$ns at 900.0 "$ftp_(69) stop"

#Set a TCP connection between node_(64) and node_(43)
set tcp_(70) [new Agent/TCP/Newreno]
$tcp_(70) set class_ 2
set sink_(70) [new Agent/TCPSink]
$ns attach-agent $node_(64) $tcp_(70)
$ns attach-agent $node_(43) $sink_(70)
$ns connect $tcp_(70) $sink_(70)
set ftp_(70) [new Application/FTP]
$ftp_(70) attach-agent $tcp_(70)
$ns at 0.2 "$ftp_(70) start"
$ns at 180.0 "$ftp_(70) stop"

#Set a TCP connection between node_(38) and node_(40)
set tcp_(71) [new Agent/TCP/Newreno]
$tcp_(71) set class_ 2
set sink_(71) [new Agent/TCPSink]
$ns attach-agent $node_(38) $tcp_(71)
$ns attach-agent $node_(40) $sink_(71)
$ns connect $tcp_(71) $sink_(71)
set ftp_(71) [new Application/FTP]
$ftp_(71) attach-agent $tcp_(71)
$ns at 180.2 "$ftp_(71) start"
$ns at 360.0 "$ftp_(71) stop"

#Set a TCP connection between node_(34) and node_(1)
set tcp_(72) [new Agent/TCP/Newreno]
$tcp_(72) set class_ 2
set sink_(72) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(72)
$ns attach-agent $node_(1) $sink_(72)
$ns connect $tcp_(72) $sink_(72)
set ftp_(72) [new Application/FTP]
$ftp_(72) attach-agent $tcp_(72)
$ns at 360.2 "$ftp_(72) start"
$ns at 540.0 "$ftp_(72) stop"

#Set a TCP connection between node_(15) and node_(66)
set tcp_(73) [new Agent/TCP/Newreno]
$tcp_(73) set class_ 2
set sink_(73) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(73)
$ns attach-agent $node_(66) $sink_(73)
$ns connect $tcp_(73) $sink_(73)
set ftp_(73) [new Application/FTP]
$ftp_(73) attach-agent $tcp_(73)
$ns at 540.2 "$ftp_(73) start"
$ns at 720.0 "$ftp_(73) stop"

#Set a TCP connection between node_(51) and node_(63)
set tcp_(74) [new Agent/TCP/Newreno]
$tcp_(74) set class_ 2
set sink_(74) [new Agent/TCPSink]
$ns attach-agent $node_(51) $tcp_(74)
$ns attach-agent $node_(63) $sink_(74)
$ns connect $tcp_(74) $sink_(74)
set ftp_(74) [new Application/FTP]
$ftp_(74) attach-agent $tcp_(74)
$ns at 720.2 "$ftp_(74) start"
$ns at 900.0 "$ftp_(74) stop"

#Set a TCP connection between node_(9) and node_(3)
set tcp_(75) [new Agent/TCP/Newreno]
$tcp_(75) set class_ 2
set sink_(75) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(75)
$ns attach-agent $node_(3) $sink_(75)
$ns connect $tcp_(75) $sink_(75)
set ftp_(75) [new Application/FTP]
$ftp_(75) attach-agent $tcp_(75)
$ns at 0.2 "$ftp_(75) start"
$ns at 180.0 "$ftp_(75) stop"

#Set a TCP connection between node_(11) and node_(26)
set tcp_(76) [new Agent/TCP/Newreno]
$tcp_(76) set class_ 2
set sink_(76) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(76)
$ns attach-agent $node_(26) $sink_(76)
$ns connect $tcp_(76) $sink_(76)
set ftp_(76) [new Application/FTP]
$ftp_(76) attach-agent $tcp_(76)
$ns at 180.2 "$ftp_(76) start"
$ns at 360.0 "$ftp_(76) stop"

#Set a TCP connection between node_(49) and node_(45)
set tcp_(77) [new Agent/TCP/Newreno]
$tcp_(77) set class_ 2
set sink_(77) [new Agent/TCPSink]
$ns attach-agent $node_(49) $tcp_(77)
$ns attach-agent $node_(45) $sink_(77)
$ns connect $tcp_(77) $sink_(77)
set ftp_(77) [new Application/FTP]
$ftp_(77) attach-agent $tcp_(77)
$ns at 360.2 "$ftp_(77) start"
$ns at 540.0 "$ftp_(77) stop"

#Set a TCP connection between node_(14) and node_(54)
set tcp_(78) [new Agent/TCP/Newreno]
$tcp_(78) set class_ 2
set sink_(78) [new Agent/TCPSink]
$ns attach-agent $node_(14) $tcp_(78)
$ns attach-agent $node_(54) $sink_(78)
$ns connect $tcp_(78) $sink_(78)
set ftp_(78) [new Application/FTP]
$ftp_(78) attach-agent $tcp_(78)
$ns at 540.2 "$ftp_(78) start"
$ns at 720.0 "$ftp_(78) stop"

#Set a TCP connection between node_(80) and node_(38)
set tcp_(79) [new Agent/TCP/Newreno]
$tcp_(79) set class_ 2
set sink_(79) [new Agent/TCPSink]
$ns attach-agent $node_(80) $tcp_(79)
$ns attach-agent $node_(38) $sink_(79)
$ns connect $tcp_(79) $sink_(79)
set ftp_(79) [new Application/FTP]
$ftp_(79) attach-agent $tcp_(79)
$ns at 720.2 "$ftp_(79) start"
$ns at 900.0 "$ftp_(79) stop"

#Set a TCP connection between node_(32) and node_(50)
set tcp_(80) [new Agent/TCP/Newreno]
$tcp_(80) set class_ 2
set sink_(80) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(80)
$ns attach-agent $node_(50) $sink_(80)
$ns connect $tcp_(80) $sink_(80)
set ftp_(80) [new Application/FTP]
$ftp_(80) attach-agent $tcp_(80)
$ns at 0.2 "$ftp_(80) start"
$ns at 180.0 "$ftp_(80) stop"

#Set a TCP connection between node_(68) and node_(46)
set tcp_(81) [new Agent/TCP/Newreno]
$tcp_(81) set class_ 2
set sink_(81) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(81)
$ns attach-agent $node_(46) $sink_(81)
$ns connect $tcp_(81) $sink_(81)
set ftp_(81) [new Application/FTP]
$ftp_(81) attach-agent $tcp_(81)
$ns at 180.2 "$ftp_(81) start"
$ns at 360.0 "$ftp_(81) stop"

#Set a TCP connection between node_(1) and node_(75)
set tcp_(82) [new Agent/TCP/Newreno]
$tcp_(82) set class_ 2
set sink_(82) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(82)
$ns attach-agent $node_(75) $sink_(82)
$ns connect $tcp_(82) $sink_(82)
set ftp_(82) [new Application/FTP]
$ftp_(82) attach-agent $tcp_(82)
$ns at 360.2 "$ftp_(82) start"
$ns at 540.0 "$ftp_(82) stop"

#Set a TCP connection between node_(98) and node_(41)
set tcp_(83) [new Agent/TCP/Newreno]
$tcp_(83) set class_ 2
set sink_(83) [new Agent/TCPSink]
$ns attach-agent $node_(98) $tcp_(83)
$ns attach-agent $node_(41) $sink_(83)
$ns connect $tcp_(83) $sink_(83)
set ftp_(83) [new Application/FTP]
$ftp_(83) attach-agent $tcp_(83)
$ns at 540.2 "$ftp_(83) start"
$ns at 720.0 "$ftp_(83) stop"

#Set a TCP connection between node_(49) and node_(67)
set tcp_(84) [new Agent/TCP/Newreno]
$tcp_(84) set class_ 2
set sink_(84) [new Agent/TCPSink]
$ns attach-agent $node_(49) $tcp_(84)
$ns attach-agent $node_(67) $sink_(84)
$ns connect $tcp_(84) $sink_(84)
set ftp_(84) [new Application/FTP]
$ftp_(84) attach-agent $tcp_(84)
$ns at 720.2 "$ftp_(84) start"
$ns at 900.0 "$ftp_(84) stop"

#Set a TCP connection between node_(40) and node_(54)
set tcp_(85) [new Agent/TCP/Newreno]
$tcp_(85) set class_ 2
set sink_(85) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(85)
$ns attach-agent $node_(54) $sink_(85)
$ns connect $tcp_(85) $sink_(85)
set ftp_(85) [new Application/FTP]
$ftp_(85) attach-agent $tcp_(85)
$ns at 0.2 "$ftp_(85) start"
$ns at 180.0 "$ftp_(85) stop"

#Set a TCP connection between node_(64) and node_(44)
set tcp_(86) [new Agent/TCP/Newreno]
$tcp_(86) set class_ 2
set sink_(86) [new Agent/TCPSink]
$ns attach-agent $node_(64) $tcp_(86)
$ns attach-agent $node_(44) $sink_(86)
$ns connect $tcp_(86) $sink_(86)
set ftp_(86) [new Application/FTP]
$ftp_(86) attach-agent $tcp_(86)
$ns at 180.2 "$ftp_(86) start"
$ns at 360.0 "$ftp_(86) stop"

#Set a TCP connection between node_(54) and node_(89)
set tcp_(87) [new Agent/TCP/Newreno]
$tcp_(87) set class_ 2
set sink_(87) [new Agent/TCPSink]
$ns attach-agent $node_(54) $tcp_(87)
$ns attach-agent $node_(89) $sink_(87)
$ns connect $tcp_(87) $sink_(87)
set ftp_(87) [new Application/FTP]
$ftp_(87) attach-agent $tcp_(87)
$ns at 360.2 "$ftp_(87) start"
$ns at 540.0 "$ftp_(87) stop"

#Set a TCP connection between node_(83) and node_(49)
set tcp_(88) [new Agent/TCP/Newreno]
$tcp_(88) set class_ 2
set sink_(88) [new Agent/TCPSink]
$ns attach-agent $node_(83) $tcp_(88)
$ns attach-agent $node_(49) $sink_(88)
$ns connect $tcp_(88) $sink_(88)
set ftp_(88) [new Application/FTP]
$ftp_(88) attach-agent $tcp_(88)
$ns at 540.2 "$ftp_(88) start"
$ns at 720.0 "$ftp_(88) stop"

#Set a TCP connection between node_(12) and node_(58)
set tcp_(89) [new Agent/TCP/Newreno]
$tcp_(89) set class_ 2
set sink_(89) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(89)
$ns attach-agent $node_(58) $sink_(89)
$ns connect $tcp_(89) $sink_(89)
set ftp_(89) [new Application/FTP]
$ftp_(89) attach-agent $tcp_(89)
$ns at 720.2 "$ftp_(89) start"
$ns at 900.0 "$ftp_(89) stop"

#Set a TCP connection between node_(38) and node_(10)
set tcp_(90) [new Agent/TCP/Newreno]
$tcp_(90) set class_ 2
set sink_(90) [new Agent/TCPSink]
$ns attach-agent $node_(38) $tcp_(90)
$ns attach-agent $node_(10) $sink_(90)
$ns connect $tcp_(90) $sink_(90)
set ftp_(90) [new Application/FTP]
$ftp_(90) attach-agent $tcp_(90)
$ns at 0.2 "$ftp_(90) start"
$ns at 180.0 "$ftp_(90) stop"

#Set a TCP connection between node_(13) and node_(49)
set tcp_(91) [new Agent/TCP/Newreno]
$tcp_(91) set class_ 2
set sink_(91) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(91)
$ns attach-agent $node_(49) $sink_(91)
$ns connect $tcp_(91) $sink_(91)
set ftp_(91) [new Application/FTP]
$ftp_(91) attach-agent $tcp_(91)
$ns at 180.2 "$ftp_(91) start"
$ns at 360.0 "$ftp_(91) stop"

#Set a TCP connection between node_(6) and node_(48)
set tcp_(92) [new Agent/TCP/Newreno]
$tcp_(92) set class_ 2
set sink_(92) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(92)
$ns attach-agent $node_(48) $sink_(92)
$ns connect $tcp_(92) $sink_(92)
set ftp_(92) [new Application/FTP]
$ftp_(92) attach-agent $tcp_(92)
$ns at 360.2 "$ftp_(92) start"
$ns at 540.0 "$ftp_(92) stop"

#Set a TCP connection between node_(18) and node_(84)
set tcp_(93) [new Agent/TCP/Newreno]
$tcp_(93) set class_ 2
set sink_(93) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(93)
$ns attach-agent $node_(84) $sink_(93)
$ns connect $tcp_(93) $sink_(93)
set ftp_(93) [new Application/FTP]
$ftp_(93) attach-agent $tcp_(93)
$ns at 540.2 "$ftp_(93) start"
$ns at 720.0 "$ftp_(93) stop"

#Set a TCP connection between node_(83) and node_(66)
set tcp_(94) [new Agent/TCP/Newreno]
$tcp_(94) set class_ 2
set sink_(94) [new Agent/TCPSink]
$ns attach-agent $node_(83) $tcp_(94)
$ns attach-agent $node_(66) $sink_(94)
$ns connect $tcp_(94) $sink_(94)
set ftp_(94) [new Application/FTP]
$ftp_(94) attach-agent $tcp_(94)
$ns at 720.2 "$ftp_(94) start"
$ns at 900.0 "$ftp_(94) stop"

#Set a TCP connection between node_(72) and node_(35)
set tcp_(95) [new Agent/TCP/Newreno]
$tcp_(95) set class_ 2
set sink_(95) [new Agent/TCPSink]
$ns attach-agent $node_(72) $tcp_(95)
$ns attach-agent $node_(35) $sink_(95)
$ns connect $tcp_(95) $sink_(95)
set ftp_(95) [new Application/FTP]
$ftp_(95) attach-agent $tcp_(95)
$ns at 0.2 "$ftp_(95) start"
$ns at 180.0 "$ftp_(95) stop"

#Set a TCP connection between node_(60) and node_(72)
set tcp_(96) [new Agent/TCP/Newreno]
$tcp_(96) set class_ 2
set sink_(96) [new Agent/TCPSink]
$ns attach-agent $node_(60) $tcp_(96)
$ns attach-agent $node_(72) $sink_(96)
$ns connect $tcp_(96) $sink_(96)
set ftp_(96) [new Application/FTP]
$ftp_(96) attach-agent $tcp_(96)
$ns at 180.2 "$ftp_(96) start"
$ns at 360.0 "$ftp_(96) stop"

#Set a TCP connection between node_(51) and node_(12)
set tcp_(97) [new Agent/TCP/Newreno]
$tcp_(97) set class_ 2
set sink_(97) [new Agent/TCPSink]
$ns attach-agent $node_(51) $tcp_(97)
$ns attach-agent $node_(12) $sink_(97)
$ns connect $tcp_(97) $sink_(97)
set ftp_(97) [new Application/FTP]
$ftp_(97) attach-agent $tcp_(97)
$ns at 360.2 "$ftp_(97) start"
$ns at 540.0 "$ftp_(97) stop"

#Set a TCP connection between node_(47) and node_(2)
set tcp_(98) [new Agent/TCP/Newreno]
$tcp_(98) set class_ 2
set sink_(98) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(98)
$ns attach-agent $node_(2) $sink_(98)
$ns connect $tcp_(98) $sink_(98)
set ftp_(98) [new Application/FTP]
$ftp_(98) attach-agent $tcp_(98)
$ns at 540.2 "$ftp_(98) start"
$ns at 720.0 "$ftp_(98) stop"

#Set a TCP connection between node_(19) and node_(20)
set tcp_(99) [new Agent/TCP/Newreno]
$tcp_(99) set class_ 2
set sink_(99) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(99)
$ns attach-agent $node_(20) $sink_(99)
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
