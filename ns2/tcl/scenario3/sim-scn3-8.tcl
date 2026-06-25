#sim-scn3-8.tcl 
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
set tracefd       [open sim-scn3-8-$val(rp)-trace.tr w]
set windowVsTime2 [open sim-scn3-8-$val(rp)-win-.tr w]
set namtrace      [open sim-scn3-8-$val(rp).nam w]

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
$node_(0) set X_ 781 
$node_(0) set Y_ 579 
$node_(0) set Z_ 0.0 
$node_(1) set X_ 999 
$node_(1) set Y_ 968 
$node_(1) set Z_ 0.0 
$node_(2) set X_ 1039 
$node_(2) set Y_ 557 
$node_(2) set Z_ 0.0 
$node_(3) set X_ 2209 
$node_(3) set Y_ 207 
$node_(3) set Z_ 0.0 
$node_(4) set X_ 28 
$node_(4) set Y_ 544 
$node_(4) set Z_ 0.0 
$node_(5) set X_ 2918 
$node_(5) set Y_ 216 
$node_(5) set Z_ 0.0 
$node_(6) set X_ 1471 
$node_(6) set Y_ 648 
$node_(6) set Z_ 0.0 
$node_(7) set X_ 326 
$node_(7) set Y_ 41 
$node_(7) set Z_ 0.0 
$node_(8) set X_ 399 
$node_(8) set Y_ 18 
$node_(8) set Z_ 0.0 
$node_(9) set X_ 1278 
$node_(9) set Y_ 61 
$node_(9) set Z_ 0.0 
$node_(10) set X_ 436 
$node_(10) set Y_ 385 
$node_(10) set Z_ 0.0 
$node_(11) set X_ 1117 
$node_(11) set Y_ 959 
$node_(11) set Z_ 0.0 
$node_(12) set X_ 2402 
$node_(12) set Y_ 859 
$node_(12) set Z_ 0.0 
$node_(13) set X_ 1014 
$node_(13) set Y_ 456 
$node_(13) set Z_ 0.0 
$node_(14) set X_ 535 
$node_(14) set Y_ 113 
$node_(14) set Z_ 0.0 
$node_(15) set X_ 106 
$node_(15) set Y_ 209 
$node_(15) set Z_ 0.0 
$node_(16) set X_ 790 
$node_(16) set Y_ 528 
$node_(16) set Z_ 0.0 
$node_(17) set X_ 964 
$node_(17) set Y_ 183 
$node_(17) set Z_ 0.0 
$node_(18) set X_ 2556 
$node_(18) set Y_ 529 
$node_(18) set Z_ 0.0 
$node_(19) set X_ 2243 
$node_(19) set Y_ 421 
$node_(19) set Z_ 0.0 
$node_(20) set X_ 751 
$node_(20) set Y_ 135 
$node_(20) set Z_ 0.0 
$node_(21) set X_ 5 
$node_(21) set Y_ 375 
$node_(21) set Z_ 0.0 
$node_(22) set X_ 591 
$node_(22) set Y_ 679 
$node_(22) set Z_ 0.0 
$node_(23) set X_ 1980 
$node_(23) set Y_ 856 
$node_(23) set Z_ 0.0 
$node_(24) set X_ 2343 
$node_(24) set Y_ 796 
$node_(24) set Z_ 0.0 
$node_(25) set X_ 1082 
$node_(25) set Y_ 234 
$node_(25) set Z_ 0.0 
$node_(26) set X_ 1171 
$node_(26) set Y_ 990 
$node_(26) set Z_ 0.0 
$node_(27) set X_ 1736 
$node_(27) set Y_ 730 
$node_(27) set Z_ 0.0 
$node_(28) set X_ 2657 
$node_(28) set Y_ 564 
$node_(28) set Z_ 0.0 
$node_(29) set X_ 2046 
$node_(29) set Y_ 509 
$node_(29) set Z_ 0.0 
$node_(30) set X_ 759 
$node_(30) set Y_ 223 
$node_(30) set Z_ 0.0 
$node_(31) set X_ 2515 
$node_(31) set Y_ 817 
$node_(31) set Z_ 0.0 
$node_(32) set X_ 2925 
$node_(32) set Y_ 439 
$node_(32) set Z_ 0.0 
$node_(33) set X_ 1936 
$node_(33) set Y_ 591 
$node_(33) set Z_ 0.0 
$node_(34) set X_ 700 
$node_(34) set Y_ 497 
$node_(34) set Z_ 0.0 
$node_(35) set X_ 203 
$node_(35) set Y_ 797 
$node_(35) set Z_ 0.0 
$node_(36) set X_ 2516 
$node_(36) set Y_ 255 
$node_(36) set Z_ 0.0 
$node_(37) set X_ 1116 
$node_(37) set Y_ 284 
$node_(37) set Z_ 0.0 
$node_(38) set X_ 1457 
$node_(38) set Y_ 780 
$node_(38) set Z_ 0.0 
$node_(39) set X_ 839 
$node_(39) set Y_ 41 
$node_(39) set Z_ 0.0 
$node_(40) set X_ 1558 
$node_(40) set Y_ 438 
$node_(40) set Z_ 0.0 
$node_(41) set X_ 1427 
$node_(41) set Y_ 605 
$node_(41) set Z_ 0.0 
$node_(42) set X_ 2732 
$node_(42) set Y_ 486 
$node_(42) set Z_ 0.0 
$node_(43) set X_ 2865 
$node_(43) set Y_ 808 
$node_(43) set Z_ 0.0 
$node_(44) set X_ 1644 
$node_(44) set Y_ 913 
$node_(44) set Z_ 0.0 
$node_(45) set X_ 1239 
$node_(45) set Y_ 172 
$node_(45) set Z_ 0.0 
$node_(46) set X_ 804 
$node_(46) set Y_ 78 
$node_(46) set Z_ 0.0 
$node_(47) set X_ 147 
$node_(47) set Y_ 48 
$node_(47) set Z_ 0.0 
$node_(48) set X_ 826 
$node_(48) set Y_ 691 
$node_(48) set Z_ 0.0 
$node_(49) set X_ 2064 
$node_(49) set Y_ 34 
$node_(49) set Z_ 0.0 
$node_(50) set X_ 2180 
$node_(50) set Y_ 818 
$node_(50) set Z_ 0.0 
$node_(51) set X_ 287 
$node_(51) set Y_ 272 
$node_(51) set Z_ 0.0 
$node_(52) set X_ 881 
$node_(52) set Y_ 880 
$node_(52) set Z_ 0.0 
$node_(53) set X_ 2145 
$node_(53) set Y_ 12 
$node_(53) set Z_ 0.0 
$node_(54) set X_ 1392 
$node_(54) set Y_ 62 
$node_(54) set Z_ 0.0 
$node_(55) set X_ 2513 
$node_(55) set Y_ 195 
$node_(55) set Z_ 0.0 
$node_(56) set X_ 542 
$node_(56) set Y_ 172 
$node_(56) set Z_ 0.0 
$node_(57) set X_ 1146 
$node_(57) set Y_ 888 
$node_(57) set Z_ 0.0 
$node_(58) set X_ 545 
$node_(58) set Y_ 738 
$node_(58) set Z_ 0.0 
$node_(59) set X_ 156 
$node_(59) set Y_ 118 
$node_(59) set Z_ 0.0 
$node_(60) set X_ 184 
$node_(60) set Y_ 44 
$node_(60) set Z_ 0.0 
$node_(61) set X_ 1867 
$node_(61) set Y_ 20 
$node_(61) set Z_ 0.0 
$node_(62) set X_ 1927 
$node_(62) set Y_ 910 
$node_(62) set Z_ 0.0 
$node_(63) set X_ 1515 
$node_(63) set Y_ 237 
$node_(63) set Z_ 0.0 
$node_(64) set X_ 2152 
$node_(64) set Y_ 212 
$node_(64) set Z_ 0.0 
$node_(65) set X_ 1635 
$node_(65) set Y_ 216 
$node_(65) set Z_ 0.0 
$node_(66) set X_ 1811 
$node_(66) set Y_ 566 
$node_(66) set Z_ 0.0 
$node_(67) set X_ 618 
$node_(67) set Y_ 352 
$node_(67) set Z_ 0.0 
$node_(68) set X_ 722 
$node_(68) set Y_ 108 
$node_(68) set Z_ 0.0 
$node_(69) set X_ 2758 
$node_(69) set Y_ 960 
$node_(69) set Z_ 0.0 
$node_(70) set X_ 2245 
$node_(70) set Y_ 31 
$node_(70) set Z_ 0.0 
$node_(71) set X_ 1165 
$node_(71) set Y_ 687 
$node_(71) set Z_ 0.0 
$node_(72) set X_ 1391 
$node_(72) set Y_ 383 
$node_(72) set Z_ 0.0 
$node_(73) set X_ 214 
$node_(73) set Y_ 302 
$node_(73) set Z_ 0.0 
$node_(74) set X_ 1456 
$node_(74) set Y_ 636 
$node_(74) set Z_ 0.0 
$node_(75) set X_ 2681 
$node_(75) set Y_ 752 
$node_(75) set Z_ 0.0 
$node_(76) set X_ 1966 
$node_(76) set Y_ 725 
$node_(76) set Z_ 0.0 
$node_(77) set X_ 1459 
$node_(77) set Y_ 8 
$node_(77) set Z_ 0.0 
$node_(78) set X_ 2192 
$node_(78) set Y_ 559 
$node_(78) set Z_ 0.0 
$node_(79) set X_ 2650 
$node_(79) set Y_ 488 
$node_(79) set Z_ 0.0 
$node_(80) set X_ 679 
$node_(80) set Y_ 502 
$node_(80) set Z_ 0.0 
$node_(81) set X_ 2024 
$node_(81) set Y_ 801 
$node_(81) set Z_ 0.0 
$node_(82) set X_ 85 
$node_(82) set Y_ 961 
$node_(82) set Z_ 0.0 
$node_(83) set X_ 168 
$node_(83) set Y_ 123 
$node_(83) set Z_ 0.0 
$node_(84) set X_ 1271 
$node_(84) set Y_ 995 
$node_(84) set Z_ 0.0 
$node_(85) set X_ 287 
$node_(85) set Y_ 773 
$node_(85) set Z_ 0.0 
$node_(86) set X_ 1890 
$node_(86) set Y_ 828 
$node_(86) set Z_ 0.0 
$node_(87) set X_ 2379 
$node_(87) set Y_ 470 
$node_(87) set Z_ 0.0 
$node_(88) set X_ 774 
$node_(88) set Y_ 251 
$node_(88) set Z_ 0.0 
$node_(89) set X_ 587 
$node_(89) set Y_ 293 
$node_(89) set Z_ 0.0 
$node_(90) set X_ 1182 
$node_(90) set Y_ 148 
$node_(90) set Z_ 0.0 
$node_(91) set X_ 2735 
$node_(91) set Y_ 600 
$node_(91) set Z_ 0.0 
$node_(92) set X_ 459 
$node_(92) set Y_ 821 
$node_(92) set Z_ 0.0 
$node_(93) set X_ 2566 
$node_(93) set Y_ 10 
$node_(93) set Z_ 0.0 
$node_(94) set X_ 1852 
$node_(94) set Y_ 339 
$node_(94) set Z_ 0.0 
$node_(95) set X_ 2842 
$node_(95) set Y_ 120 
$node_(95) set Z_ 0.0 
$node_(96) set X_ 154 
$node_(96) set Y_ 900 
$node_(96) set Z_ 0.0 
$node_(97) set X_ 2412 
$node_(97) set Y_ 763 
$node_(97) set Z_ 0.0 
$node_(98) set X_ 488 
$node_(98) set Y_ 44 
$node_(98) set Z_ 0.0 
$node_(99) set X_ 441 
$node_(99) set Y_ 499 
$node_(99) set Z_ 0.0 
$node_(100) set X_ 2899 
$node_(100) set Y_ 638 
$node_(100) set Z_ 0.0 
$node_(101) set X_ 2383 
$node_(101) set Y_ 499 
$node_(101) set Z_ 0.0 
$ns at 0.0 "$node_(101) off" 
$ns at 100.0 "$node_(101) on" 
$node_(102) set X_ 1490 
$node_(102) set Y_ 717 
$node_(102) set Z_ 0.0 
$ns at 0.0 "$node_(102) off" 
$ns at 100.0 "$node_(102) on" 
$node_(103) set X_ 1775 
$node_(103) set Y_ 149 
$node_(103) set Z_ 0.0 
$ns at 0.0 "$node_(103) off" 
$ns at 100.0 "$node_(103) on" 
$node_(104) set X_ 663 
$node_(104) set Y_ 653 
$node_(104) set Z_ 0.0 
$ns at 0.0 "$node_(104) off" 
$ns at 100.0 "$node_(104) on" 
$node_(105) set X_ 1784 
$node_(105) set Y_ 511 
$node_(105) set Z_ 0.0 
$ns at 0.0 "$node_(105) off" 
$ns at 100.0 "$node_(105) on" 
$node_(106) set X_ 1497 
$node_(106) set Y_ 622 
$node_(106) set Z_ 0.0 
$ns at 0.0 "$node_(106) off" 
$ns at 100.0 "$node_(106) on" 
$node_(107) set X_ 387 
$node_(107) set Y_ 227 
$node_(107) set Z_ 0.0 
$ns at 0.0 "$node_(107) off" 
$ns at 100.0 "$node_(107) on" 
$node_(108) set X_ 2575 
$node_(108) set Y_ 996 
$node_(108) set Z_ 0.0 
$ns at 0.0 "$node_(108) off" 
$ns at 100.0 "$node_(108) on" 
$node_(109) set X_ 286 
$node_(109) set Y_ 603 
$node_(109) set Z_ 0.0 
$ns at 0.0 "$node_(109) off" 
$ns at 100.0 "$node_(109) on" 
$node_(110) set X_ 480 
$node_(110) set Y_ 151 
$node_(110) set Z_ 0.0 
$ns at 0.0 "$node_(110) off" 
$ns at 100.0 "$node_(110) on" 
$node_(111) set X_ 131 
$node_(111) set Y_ 357 
$node_(111) set Z_ 0.0 
$ns at 0.0 "$node_(111) off" 
$ns at 100.0 "$node_(111) on" 
$node_(112) set X_ 2891 
$node_(112) set Y_ 105 
$node_(112) set Z_ 0.0 
$ns at 0.0 "$node_(112) off" 
$ns at 100.0 "$node_(112) on" 
$node_(113) set X_ 242 
$node_(113) set Y_ 983 
$node_(113) set Z_ 0.0 
$ns at 0.0 "$node_(113) off" 
$ns at 100.0 "$node_(113) on" 
$node_(114) set X_ 1572 
$node_(114) set Y_ 605 
$node_(114) set Z_ 0.0 
$ns at 0.0 "$node_(114) off" 
$ns at 100.0 "$node_(114) on" 
$node_(115) set X_ 1900 
$node_(115) set Y_ 732 
$node_(115) set Z_ 0.0 
$ns at 0.0 "$node_(115) off" 
$ns at 100.0 "$node_(115) on" 
$node_(116) set X_ 2661 
$node_(116) set Y_ 510 
$node_(116) set Z_ 0.0 
$ns at 0.0 "$node_(116) off" 
$ns at 100.0 "$node_(116) on" 
$node_(117) set X_ 1409 
$node_(117) set Y_ 2 
$node_(117) set Z_ 0.0 
$ns at 0.0 "$node_(117) off" 
$ns at 100.0 "$node_(117) on" 
$node_(118) set X_ 1501 
$node_(118) set Y_ 826 
$node_(118) set Z_ 0.0 
$ns at 0.0 "$node_(118) off" 
$ns at 100.0 "$node_(118) on" 
$node_(119) set X_ 372 
$node_(119) set Y_ 302 
$node_(119) set Z_ 0.0 
$ns at 0.0 "$node_(119) off" 
$ns at 100.0 "$node_(119) on" 
$node_(120) set X_ 1806 
$node_(120) set Y_ 307 
$node_(120) set Z_ 0.0 
$ns at 0.0 "$node_(120) off" 
$ns at 100.0 "$node_(120) on" 
$node_(121) set X_ 226 
$node_(121) set Y_ 32 
$node_(121) set Z_ 0.0 
$ns at 0.0 "$node_(121) off" 
$ns at 100.0 "$node_(121) on" 
$node_(122) set X_ 1184 
$node_(122) set Y_ 333 
$node_(122) set Z_ 0.0 
$ns at 0.0 "$node_(122) off" 
$ns at 100.0 "$node_(122) on" 
$node_(123) set X_ 1788 
$node_(123) set Y_ 10 
$node_(123) set Z_ 0.0 
$ns at 0.0 "$node_(123) off" 
$ns at 100.0 "$node_(123) on" 
$node_(124) set X_ 2082 
$node_(124) set Y_ 675 
$node_(124) set Z_ 0.0 
$ns at 0.0 "$node_(124) off" 
$ns at 100.0 "$node_(124) on" 
$node_(125) set X_ 536 
$node_(125) set Y_ 102 
$node_(125) set Z_ 0.0 
$ns at 0.0 "$node_(125) off" 
$ns at 100.0 "$node_(125) on" 
$node_(126) set X_ 852 
$node_(126) set Y_ 846 
$node_(126) set Z_ 0.0 
$ns at 0.0 "$node_(126) off" 
$ns at 100.0 "$node_(126) on" 
$node_(127) set X_ 2549 
$node_(127) set Y_ 270 
$node_(127) set Z_ 0.0 
$ns at 0.0 "$node_(127) off" 
$ns at 100.0 "$node_(127) on" 
$node_(128) set X_ 2127 
$node_(128) set Y_ 951 
$node_(128) set Z_ 0.0 
$ns at 0.0 "$node_(128) off" 
$ns at 100.0 "$node_(128) on" 
$node_(129) set X_ 1430 
$node_(129) set Y_ 99 
$node_(129) set Z_ 0.0 
$ns at 0.0 "$node_(129) off" 
$ns at 100.0 "$node_(129) on" 
$node_(130) set X_ 1772 
$node_(130) set Y_ 359 
$node_(130) set Z_ 0.0 
$ns at 0.0 "$node_(130) off" 
$ns at 100.0 "$node_(130) on" 
$node_(131) set X_ 1146 
$node_(131) set Y_ 164 
$node_(131) set Z_ 0.0 
$ns at 0.0 "$node_(131) off" 
$ns at 100.0 "$node_(131) on" 
$node_(132) set X_ 2579 
$node_(132) set Y_ 40 
$node_(132) set Z_ 0.0 
$ns at 0.0 "$node_(132) off" 
$ns at 100.0 "$node_(132) on" 
$node_(133) set X_ 592 
$node_(133) set Y_ 622 
$node_(133) set Z_ 0.0 
$ns at 0.0 "$node_(133) off" 
$ns at 100.0 "$node_(133) on" 
$node_(134) set X_ 1428 
$node_(134) set Y_ 136 
$node_(134) set Z_ 0.0 
$ns at 0.0 "$node_(134) off" 
$ns at 100.0 "$node_(134) on" 
$node_(135) set X_ 2712 
$node_(135) set Y_ 43 
$node_(135) set Z_ 0.0 
$ns at 0.0 "$node_(135) off" 
$ns at 100.0 "$node_(135) on" 
$node_(136) set X_ 952 
$node_(136) set Y_ 165 
$node_(136) set Z_ 0.0 
$ns at 0.0 "$node_(136) off" 
$ns at 100.0 "$node_(136) on" 
$node_(137) set X_ 1315 
$node_(137) set Y_ 829 
$node_(137) set Z_ 0.0 
$ns at 0.0 "$node_(137) off" 
$ns at 100.0 "$node_(137) on" 
$node_(138) set X_ 2724 
$node_(138) set Y_ 291 
$node_(138) set Z_ 0.0 
$ns at 0.0 "$node_(138) off" 
$ns at 100.0 "$node_(138) on" 
$node_(139) set X_ 222 
$node_(139) set Y_ 509 
$node_(139) set Z_ 0.0 
$ns at 0.0 "$node_(139) off" 
$ns at 100.0 "$node_(139) on" 
$node_(140) set X_ 1765 
$node_(140) set Y_ 249 
$node_(140) set Z_ 0.0 
$ns at 0.0 "$node_(140) off" 
$ns at 100.0 "$node_(140) on" 
$node_(141) set X_ 74 
$node_(141) set Y_ 850 
$node_(141) set Z_ 0.0 
$ns at 0.0 "$node_(141) off" 
$ns at 100.0 "$node_(141) on" 
$node_(142) set X_ 1579 
$node_(142) set Y_ 842 
$node_(142) set Z_ 0.0 
$ns at 0.0 "$node_(142) off" 
$ns at 100.0 "$node_(142) on" 
$node_(143) set X_ 1110 
$node_(143) set Y_ 971 
$node_(143) set Z_ 0.0 
$ns at 0.0 "$node_(143) off" 
$ns at 100.0 "$node_(143) on" 
$node_(144) set X_ 2119 
$node_(144) set Y_ 421 
$node_(144) set Z_ 0.0 
$ns at 0.0 "$node_(144) off" 
$ns at 100.0 "$node_(144) on" 
$node_(145) set X_ 1325 
$node_(145) set Y_ 603 
$node_(145) set Z_ 0.0 
$ns at 0.0 "$node_(145) off" 
$ns at 100.0 "$node_(145) on" 
$node_(146) set X_ 1977 
$node_(146) set Y_ 372 
$node_(146) set Z_ 0.0 
$ns at 0.0 "$node_(146) off" 
$ns at 100.0 "$node_(146) on" 
$node_(147) set X_ 844 
$node_(147) set Y_ 234 
$node_(147) set Z_ 0.0 
$ns at 0.0 "$node_(147) off" 
$ns at 100.0 "$node_(147) on" 
$node_(148) set X_ 682 
$node_(148) set Y_ 445 
$node_(148) set Z_ 0.0 
$ns at 0.0 "$node_(148) off" 
$ns at 100.0 "$node_(148) on" 
$node_(149) set X_ 1915 
$node_(149) set Y_ 87 
$node_(149) set Z_ 0.0 
$ns at 0.0 "$node_(149) off" 
$ns at 100.0 "$node_(149) on" 
$node_(150) set X_ 332 
$node_(150) set Y_ 716 
$node_(150) set Z_ 0.0 
$ns at 0.0 "$node_(150) off" 
$ns at 100.0 "$node_(150) on" 
$node_(151) set X_ 718 
$node_(151) set Y_ 840 
$node_(151) set Z_ 0.0 
$ns at 0.0 "$node_(151) off" 
$ns at 100.0 "$node_(151) on" 
$node_(152) set X_ 827 
$node_(152) set Y_ 60 
$node_(152) set Z_ 0.0 
$ns at 0.0 "$node_(152) off" 
$ns at 100.0 "$node_(152) on" 
$node_(153) set X_ 2273 
$node_(153) set Y_ 501 
$node_(153) set Z_ 0.0 
$ns at 0.0 "$node_(153) off" 
$ns at 100.0 "$node_(153) on" 
$node_(154) set X_ 1742 
$node_(154) set Y_ 291 
$node_(154) set Z_ 0.0 
$ns at 0.0 "$node_(154) off" 
$ns at 100.0 "$node_(154) on" 
$node_(155) set X_ 2907 
$node_(155) set Y_ 104 
$node_(155) set Z_ 0.0 
$ns at 0.0 "$node_(155) off" 
$ns at 100.0 "$node_(155) on" 
$node_(156) set X_ 346 
$node_(156) set Y_ 534 
$node_(156) set Z_ 0.0 
$ns at 0.0 "$node_(156) off" 
$ns at 100.0 "$node_(156) on" 
$node_(157) set X_ 273 
$node_(157) set Y_ 752 
$node_(157) set Z_ 0.0 
$ns at 0.0 "$node_(157) off" 
$ns at 100.0 "$node_(157) on" 
$node_(158) set X_ 2487 
$node_(158) set Y_ 986 
$node_(158) set Z_ 0.0 
$ns at 0.0 "$node_(158) off" 
$ns at 100.0 "$node_(158) on" 
$node_(159) set X_ 553 
$node_(159) set Y_ 52 
$node_(159) set Z_ 0.0 
$ns at 0.0 "$node_(159) off" 
$ns at 100.0 "$node_(159) on" 
$node_(160) set X_ 2993 
$node_(160) set Y_ 923 
$node_(160) set Z_ 0.0 
$ns at 0.0 "$node_(160) off" 
$ns at 100.0 "$node_(160) on" 
$node_(161) set X_ 2419 
$node_(161) set Y_ 192 
$node_(161) set Z_ 0.0 
$ns at 0.0 "$node_(161) off" 
$ns at 100.0 "$node_(161) on" 
$node_(162) set X_ 2847 
$node_(162) set Y_ 741 
$node_(162) set Z_ 0.0 
$ns at 0.0 "$node_(162) off" 
$ns at 100.0 "$node_(162) on" 
$node_(163) set X_ 2409 
$node_(163) set Y_ 730 
$node_(163) set Z_ 0.0 
$ns at 0.0 "$node_(163) off" 
$ns at 100.0 "$node_(163) on" 
$node_(164) set X_ 796 
$node_(164) set Y_ 818 
$node_(164) set Z_ 0.0 
$ns at 0.0 "$node_(164) off" 
$ns at 100.0 "$node_(164) on" 
$node_(165) set X_ 767 
$node_(165) set Y_ 674 
$node_(165) set Z_ 0.0 
$ns at 0.0 "$node_(165) off" 
$ns at 100.0 "$node_(165) on" 
$node_(166) set X_ 1088 
$node_(166) set Y_ 219 
$node_(166) set Z_ 0.0 
$ns at 0.0 "$node_(166) off" 
$ns at 100.0 "$node_(166) on" 
$node_(167) set X_ 316 
$node_(167) set Y_ 586 
$node_(167) set Z_ 0.0 
$ns at 0.0 "$node_(167) off" 
$ns at 100.0 "$node_(167) on" 
$node_(168) set X_ 2861 
$node_(168) set Y_ 603 
$node_(168) set Z_ 0.0 
$ns at 0.0 "$node_(168) off" 
$ns at 100.0 "$node_(168) on" 
$node_(169) set X_ 2726 
$node_(169) set Y_ 243 
$node_(169) set Z_ 0.0 
$ns at 0.0 "$node_(169) off" 
$ns at 100.0 "$node_(169) on" 
$node_(170) set X_ 1203 
$node_(170) set Y_ 211 
$node_(170) set Z_ 0.0 
$ns at 0.0 "$node_(170) off" 
$ns at 100.0 "$node_(170) on" 
$node_(171) set X_ 1556 
$node_(171) set Y_ 870 
$node_(171) set Z_ 0.0 
$ns at 0.0 "$node_(171) off" 
$ns at 100.0 "$node_(171) on" 
$node_(172) set X_ 1137 
$node_(172) set Y_ 482 
$node_(172) set Z_ 0.0 
$ns at 0.0 "$node_(172) off" 
$ns at 100.0 "$node_(172) on" 
$node_(173) set X_ 639 
$node_(173) set Y_ 58 
$node_(173) set Z_ 0.0 
$ns at 0.0 "$node_(173) off" 
$ns at 100.0 "$node_(173) on" 
$node_(174) set X_ 1753 
$node_(174) set Y_ 670 
$node_(174) set Z_ 0.0 
$ns at 0.0 "$node_(174) off" 
$ns at 100.0 "$node_(174) on" 
$node_(175) set X_ 2831 
$node_(175) set Y_ 282 
$node_(175) set Z_ 0.0 
$ns at 0.0 "$node_(175) off" 
$ns at 100.0 "$node_(175) on" 
$node_(176) set X_ 1351 
$node_(176) set Y_ 806 
$node_(176) set Z_ 0.0 
$ns at 0.0 "$node_(176) off" 
$ns at 100.0 "$node_(176) on" 
$node_(177) set X_ 2806 
$node_(177) set Y_ 365 
$node_(177) set Z_ 0.0 
$ns at 0.0 "$node_(177) off" 
$ns at 100.0 "$node_(177) on" 
$node_(178) set X_ 2887 
$node_(178) set Y_ 516 
$node_(178) set Z_ 0.0 
$ns at 0.0 "$node_(178) off" 
$ns at 100.0 "$node_(178) on" 
$node_(179) set X_ 2425 
$node_(179) set Y_ 298 
$node_(179) set Z_ 0.0 
$ns at 0.0 "$node_(179) off" 
$ns at 100.0 "$node_(179) on" 
$node_(180) set X_ 2077 
$node_(180) set Y_ 457 
$node_(180) set Z_ 0.0 
$ns at 0.0 "$node_(180) off" 
$ns at 100.0 "$node_(180) on" 
$node_(181) set X_ 2345 
$node_(181) set Y_ 619 
$node_(181) set Z_ 0.0 
$ns at 0.0 "$node_(181) off" 
$ns at 100.0 "$node_(181) on" 
$node_(182) set X_ 391 
$node_(182) set Y_ 617 
$node_(182) set Z_ 0.0 
$ns at 0.0 "$node_(182) off" 
$ns at 100.0 "$node_(182) on" 
$node_(183) set X_ 799 
$node_(183) set Y_ 910 
$node_(183) set Z_ 0.0 
$ns at 0.0 "$node_(183) off" 
$ns at 100.0 "$node_(183) on" 
$node_(184) set X_ 662 
$node_(184) set Y_ 326 
$node_(184) set Z_ 0.0 
$ns at 0.0 "$node_(184) off" 
$ns at 100.0 "$node_(184) on" 
$node_(185) set X_ 1040 
$node_(185) set Y_ 70 
$node_(185) set Z_ 0.0 
$ns at 0.0 "$node_(185) off" 
$ns at 100.0 "$node_(185) on" 
$node_(186) set X_ 2353 
$node_(186) set Y_ 569 
$node_(186) set Z_ 0.0 
$ns at 0.0 "$node_(186) off" 
$ns at 100.0 "$node_(186) on" 
$node_(187) set X_ 675 
$node_(187) set Y_ 711 
$node_(187) set Z_ 0.0 
$ns at 0.0 "$node_(187) off" 
$ns at 100.0 "$node_(187) on" 
$node_(188) set X_ 462 
$node_(188) set Y_ 134 
$node_(188) set Z_ 0.0 
$ns at 0.0 "$node_(188) off" 
$ns at 100.0 "$node_(188) on" 
$node_(189) set X_ 2090 
$node_(189) set Y_ 404 
$node_(189) set Z_ 0.0 
$ns at 0.0 "$node_(189) off" 
$ns at 100.0 "$node_(189) on" 
$node_(190) set X_ 2779 
$node_(190) set Y_ 193 
$node_(190) set Z_ 0.0 
$ns at 0.0 "$node_(190) off" 
$ns at 100.0 "$node_(190) on" 
$node_(191) set X_ 355 
$node_(191) set Y_ 547 
$node_(191) set Z_ 0.0 
$ns at 0.0 "$node_(191) off" 
$ns at 100.0 "$node_(191) on" 
$node_(192) set X_ 614 
$node_(192) set Y_ 134 
$node_(192) set Z_ 0.0 
$ns at 0.0 "$node_(192) off" 
$ns at 100.0 "$node_(192) on" 
$node_(193) set X_ 393 
$node_(193) set Y_ 271 
$node_(193) set Z_ 0.0 
$ns at 0.0 "$node_(193) off" 
$ns at 100.0 "$node_(193) on" 
$node_(194) set X_ 259 
$node_(194) set Y_ 882 
$node_(194) set Z_ 0.0 
$ns at 0.0 "$node_(194) off" 
$ns at 100.0 "$node_(194) on" 
$node_(195) set X_ 1831 
$node_(195) set Y_ 194 
$node_(195) set Z_ 0.0 
$ns at 0.0 "$node_(195) off" 
$ns at 100.0 "$node_(195) on" 
$node_(196) set X_ 1305 
$node_(196) set Y_ 449 
$node_(196) set Z_ 0.0 
$ns at 0.0 "$node_(196) off" 
$ns at 100.0 "$node_(196) on" 
$node_(197) set X_ 2791 
$node_(197) set Y_ 780 
$node_(197) set Z_ 0.0 
$ns at 0.0 "$node_(197) off" 
$ns at 100.0 "$node_(197) on" 
$node_(198) set X_ 514 
$node_(198) set Y_ 192 
$node_(198) set Z_ 0.0 
$ns at 0.0 "$node_(198) off" 
$ns at 100.0 "$node_(198) on" 
$node_(199) set X_ 1942 
$node_(199) set Y_ 752 
$node_(199) set Z_ 0.0 
$ns at 0.0 "$node_(199) off" 
$ns at 100.0 "$node_(199) on" 
$node_(200) set X_ 1242 
$node_(200) set Y_ 79 
$node_(200) set Z_ 0.0 
$ns at 0.0 "$node_(200) off" 
$ns at 200.0 "$node_(200) on" 
$node_(201) set X_ 404 
$node_(201) set Y_ 291 
$node_(201) set Z_ 0.0 
$ns at 0.0 "$node_(201) off" 
$ns at 200.0 "$node_(201) on" 
$node_(202) set X_ 2417 
$node_(202) set Y_ 320 
$node_(202) set Z_ 0.0 
$ns at 0.0 "$node_(202) off" 
$ns at 200.0 "$node_(202) on" 
$node_(203) set X_ 1617 
$node_(203) set Y_ 735 
$node_(203) set Z_ 0.0 
$ns at 0.0 "$node_(203) off" 
$ns at 200.0 "$node_(203) on" 
$node_(204) set X_ 814 
$node_(204) set Y_ 830 
$node_(204) set Z_ 0.0 
$ns at 0.0 "$node_(204) off" 
$ns at 200.0 "$node_(204) on" 
$node_(205) set X_ 1974 
$node_(205) set Y_ 98 
$node_(205) set Z_ 0.0 
$ns at 0.0 "$node_(205) off" 
$ns at 200.0 "$node_(205) on" 
$node_(206) set X_ 833 
$node_(206) set Y_ 377 
$node_(206) set Z_ 0.0 
$ns at 0.0 "$node_(206) off" 
$ns at 200.0 "$node_(206) on" 
$node_(207) set X_ 2982 
$node_(207) set Y_ 42 
$node_(207) set Z_ 0.0 
$ns at 0.0 "$node_(207) off" 
$ns at 200.0 "$node_(207) on" 
$node_(208) set X_ 1129 
$node_(208) set Y_ 705 
$node_(208) set Z_ 0.0 
$ns at 0.0 "$node_(208) off" 
$ns at 200.0 "$node_(208) on" 
$node_(209) set X_ 862 
$node_(209) set Y_ 811 
$node_(209) set Z_ 0.0 
$ns at 0.0 "$node_(209) off" 
$ns at 200.0 "$node_(209) on" 
$node_(210) set X_ 1360 
$node_(210) set Y_ 580 
$node_(210) set Z_ 0.0 
$ns at 0.0 "$node_(210) off" 
$ns at 200.0 "$node_(210) on" 
$node_(211) set X_ 849 
$node_(211) set Y_ 288 
$node_(211) set Z_ 0.0 
$ns at 0.0 "$node_(211) off" 
$ns at 200.0 "$node_(211) on" 
$node_(212) set X_ 1916 
$node_(212) set Y_ 504 
$node_(212) set Z_ 0.0 
$ns at 0.0 "$node_(212) off" 
$ns at 200.0 "$node_(212) on" 
$node_(213) set X_ 1101 
$node_(213) set Y_ 545 
$node_(213) set Z_ 0.0 
$ns at 0.0 "$node_(213) off" 
$ns at 200.0 "$node_(213) on" 
$node_(214) set X_ 812 
$node_(214) set Y_ 772 
$node_(214) set Z_ 0.0 
$ns at 0.0 "$node_(214) off" 
$ns at 200.0 "$node_(214) on" 
$node_(215) set X_ 2870 
$node_(215) set Y_ 174 
$node_(215) set Z_ 0.0 
$ns at 0.0 "$node_(215) off" 
$ns at 200.0 "$node_(215) on" 
$node_(216) set X_ 1993 
$node_(216) set Y_ 676 
$node_(216) set Z_ 0.0 
$ns at 0.0 "$node_(216) off" 
$ns at 200.0 "$node_(216) on" 
$node_(217) set X_ 666 
$node_(217) set Y_ 234 
$node_(217) set Z_ 0.0 
$ns at 0.0 "$node_(217) off" 
$ns at 200.0 "$node_(217) on" 
$node_(218) set X_ 2041 
$node_(218) set Y_ 914 
$node_(218) set Z_ 0.0 
$ns at 0.0 "$node_(218) off" 
$ns at 200.0 "$node_(218) on" 
$node_(219) set X_ 2389 
$node_(219) set Y_ 888 
$node_(219) set Z_ 0.0 
$ns at 0.0 "$node_(219) off" 
$ns at 200.0 "$node_(219) on" 
$node_(220) set X_ 773 
$node_(220) set Y_ 670 
$node_(220) set Z_ 0.0 
$ns at 0.0 "$node_(220) off" 
$ns at 200.0 "$node_(220) on" 
$node_(221) set X_ 1842 
$node_(221) set Y_ 652 
$node_(221) set Z_ 0.0 
$ns at 0.0 "$node_(221) off" 
$ns at 200.0 "$node_(221) on" 
$node_(222) set X_ 426 
$node_(222) set Y_ 434 
$node_(222) set Z_ 0.0 
$ns at 0.0 "$node_(222) off" 
$ns at 200.0 "$node_(222) on" 
$node_(223) set X_ 2760 
$node_(223) set Y_ 715 
$node_(223) set Z_ 0.0 
$ns at 0.0 "$node_(223) off" 
$ns at 200.0 "$node_(223) on" 
$node_(224) set X_ 15 
$node_(224) set Y_ 321 
$node_(224) set Z_ 0.0 
$ns at 0.0 "$node_(224) off" 
$ns at 200.0 "$node_(224) on" 
$node_(225) set X_ 2373 
$node_(225) set Y_ 982 
$node_(225) set Z_ 0.0 
$ns at 0.0 "$node_(225) off" 
$ns at 200.0 "$node_(225) on" 
$node_(226) set X_ 135 
$node_(226) set Y_ 589 
$node_(226) set Z_ 0.0 
$ns at 0.0 "$node_(226) off" 
$ns at 200.0 "$node_(226) on" 
$node_(227) set X_ 658 
$node_(227) set Y_ 321 
$node_(227) set Z_ 0.0 
$ns at 0.0 "$node_(227) off" 
$ns at 200.0 "$node_(227) on" 
$node_(228) set X_ 2797 
$node_(228) set Y_ 36 
$node_(228) set Z_ 0.0 
$ns at 0.0 "$node_(228) off" 
$ns at 200.0 "$node_(228) on" 
$node_(229) set X_ 2765 
$node_(229) set Y_ 998 
$node_(229) set Z_ 0.0 
$ns at 0.0 "$node_(229) off" 
$ns at 200.0 "$node_(229) on" 
$node_(230) set X_ 1984 
$node_(230) set Y_ 226 
$node_(230) set Z_ 0.0 
$ns at 0.0 "$node_(230) off" 
$ns at 200.0 "$node_(230) on" 
$node_(231) set X_ 1674 
$node_(231) set Y_ 430 
$node_(231) set Z_ 0.0 
$ns at 0.0 "$node_(231) off" 
$ns at 200.0 "$node_(231) on" 
$node_(232) set X_ 1413 
$node_(232) set Y_ 789 
$node_(232) set Z_ 0.0 
$ns at 0.0 "$node_(232) off" 
$ns at 200.0 "$node_(232) on" 
$node_(233) set X_ 2918 
$node_(233) set Y_ 215 
$node_(233) set Z_ 0.0 
$ns at 0.0 "$node_(233) off" 
$ns at 200.0 "$node_(233) on" 
$node_(234) set X_ 1486 
$node_(234) set Y_ 589 
$node_(234) set Z_ 0.0 
$ns at 0.0 "$node_(234) off" 
$ns at 200.0 "$node_(234) on" 
$node_(235) set X_ 1203 
$node_(235) set Y_ 835 
$node_(235) set Z_ 0.0 
$ns at 0.0 "$node_(235) off" 
$ns at 200.0 "$node_(235) on" 
$node_(236) set X_ 664 
$node_(236) set Y_ 216 
$node_(236) set Z_ 0.0 
$ns at 0.0 "$node_(236) off" 
$ns at 200.0 "$node_(236) on" 
$node_(237) set X_ 972 
$node_(237) set Y_ 572 
$node_(237) set Z_ 0.0 
$ns at 0.0 "$node_(237) off" 
$ns at 200.0 "$node_(237) on" 
$node_(238) set X_ 441 
$node_(238) set Y_ 71 
$node_(238) set Z_ 0.0 
$ns at 0.0 "$node_(238) off" 
$ns at 200.0 "$node_(238) on" 
$node_(239) set X_ 2413 
$node_(239) set Y_ 956 
$node_(239) set Z_ 0.0 
$ns at 0.0 "$node_(239) off" 
$ns at 200.0 "$node_(239) on" 
$node_(240) set X_ 765 
$node_(240) set Y_ 311 
$node_(240) set Z_ 0.0 
$ns at 0.0 "$node_(240) off" 
$ns at 200.0 "$node_(240) on" 
$node_(241) set X_ 2032 
$node_(241) set Y_ 478 
$node_(241) set Z_ 0.0 
$ns at 0.0 "$node_(241) off" 
$ns at 200.0 "$node_(241) on" 
$node_(242) set X_ 149 
$node_(242) set Y_ 49 
$node_(242) set Z_ 0.0 
$ns at 0.0 "$node_(242) off" 
$ns at 200.0 "$node_(242) on" 
$node_(243) set X_ 2827 
$node_(243) set Y_ 411 
$node_(243) set Z_ 0.0 
$ns at 0.0 "$node_(243) off" 
$ns at 200.0 "$node_(243) on" 
$node_(244) set X_ 2818 
$node_(244) set Y_ 496 
$node_(244) set Z_ 0.0 
$ns at 0.0 "$node_(244) off" 
$ns at 200.0 "$node_(244) on" 
$node_(245) set X_ 165 
$node_(245) set Y_ 325 
$node_(245) set Z_ 0.0 
$ns at 0.0 "$node_(245) off" 
$ns at 200.0 "$node_(245) on" 
$node_(246) set X_ 2073 
$node_(246) set Y_ 197 
$node_(246) set Z_ 0.0 
$ns at 0.0 "$node_(246) off" 
$ns at 200.0 "$node_(246) on" 
$node_(247) set X_ 1777 
$node_(247) set Y_ 285 
$node_(247) set Z_ 0.0 
$ns at 0.0 "$node_(247) off" 
$ns at 200.0 "$node_(247) on" 
$node_(248) set X_ 1578 
$node_(248) set Y_ 93 
$node_(248) set Z_ 0.0 
$ns at 0.0 "$node_(248) off" 
$ns at 200.0 "$node_(248) on" 
$node_(249) set X_ 2831 
$node_(249) set Y_ 769 
$node_(249) set Z_ 0.0 
$ns at 0.0 "$node_(249) off" 
$ns at 200.0 "$node_(249) on" 
$node_(250) set X_ 574 
$node_(250) set Y_ 932 
$node_(250) set Z_ 0.0 
$ns at 0.0 "$node_(250) off" 
$ns at 200.0 "$node_(250) on" 
$node_(251) set X_ 779 
$node_(251) set Y_ 82 
$node_(251) set Z_ 0.0 
$ns at 0.0 "$node_(251) off" 
$ns at 200.0 "$node_(251) on" 
$node_(252) set X_ 2975 
$node_(252) set Y_ 456 
$node_(252) set Z_ 0.0 
$ns at 0.0 "$node_(252) off" 
$ns at 200.0 "$node_(252) on" 
$node_(253) set X_ 2641 
$node_(253) set Y_ 390 
$node_(253) set Z_ 0.0 
$ns at 0.0 "$node_(253) off" 
$ns at 200.0 "$node_(253) on" 
$node_(254) set X_ 1024 
$node_(254) set Y_ 867 
$node_(254) set Z_ 0.0 
$ns at 0.0 "$node_(254) off" 
$ns at 200.0 "$node_(254) on" 
$node_(255) set X_ 2591 
$node_(255) set Y_ 544 
$node_(255) set Z_ 0.0 
$ns at 0.0 "$node_(255) off" 
$ns at 200.0 "$node_(255) on" 
$node_(256) set X_ 2599 
$node_(256) set Y_ 298 
$node_(256) set Z_ 0.0 
$ns at 0.0 "$node_(256) off" 
$ns at 200.0 "$node_(256) on" 
$node_(257) set X_ 97 
$node_(257) set Y_ 540 
$node_(257) set Z_ 0.0 
$ns at 0.0 "$node_(257) off" 
$ns at 200.0 "$node_(257) on" 
$node_(258) set X_ 1403 
$node_(258) set Y_ 441 
$node_(258) set Z_ 0.0 
$ns at 0.0 "$node_(258) off" 
$ns at 200.0 "$node_(258) on" 
$node_(259) set X_ 493 
$node_(259) set Y_ 803 
$node_(259) set Z_ 0.0 
$ns at 0.0 "$node_(259) off" 
$ns at 200.0 "$node_(259) on" 
$node_(260) set X_ 123 
$node_(260) set Y_ 960 
$node_(260) set Z_ 0.0 
$ns at 0.0 "$node_(260) off" 
$ns at 200.0 "$node_(260) on" 
$node_(261) set X_ 1726 
$node_(261) set Y_ 479 
$node_(261) set Z_ 0.0 
$ns at 0.0 "$node_(261) off" 
$ns at 200.0 "$node_(261) on" 
$node_(262) set X_ 2228 
$node_(262) set Y_ 98 
$node_(262) set Z_ 0.0 
$ns at 0.0 "$node_(262) off" 
$ns at 200.0 "$node_(262) on" 
$node_(263) set X_ 1049 
$node_(263) set Y_ 579 
$node_(263) set Z_ 0.0 
$ns at 0.0 "$node_(263) off" 
$ns at 200.0 "$node_(263) on" 
$node_(264) set X_ 2374 
$node_(264) set Y_ 665 
$node_(264) set Z_ 0.0 
$ns at 0.0 "$node_(264) off" 
$ns at 200.0 "$node_(264) on" 
$node_(265) set X_ 2740 
$node_(265) set Y_ 118 
$node_(265) set Z_ 0.0 
$ns at 0.0 "$node_(265) off" 
$ns at 200.0 "$node_(265) on" 
$node_(266) set X_ 2383 
$node_(266) set Y_ 673 
$node_(266) set Z_ 0.0 
$ns at 0.0 "$node_(266) off" 
$ns at 200.0 "$node_(266) on" 
$node_(267) set X_ 1401 
$node_(267) set Y_ 367 
$node_(267) set Z_ 0.0 
$ns at 0.0 "$node_(267) off" 
$ns at 200.0 "$node_(267) on" 
$node_(268) set X_ 1516 
$node_(268) set Y_ 9 
$node_(268) set Z_ 0.0 
$ns at 0.0 "$node_(268) off" 
$ns at 200.0 "$node_(268) on" 
$node_(269) set X_ 144 
$node_(269) set Y_ 957 
$node_(269) set Z_ 0.0 
$ns at 0.0 "$node_(269) off" 
$ns at 200.0 "$node_(269) on" 
$node_(270) set X_ 2204 
$node_(270) set Y_ 875 
$node_(270) set Z_ 0.0 
$ns at 0.0 "$node_(270) off" 
$ns at 200.0 "$node_(270) on" 
$node_(271) set X_ 1854 
$node_(271) set Y_ 836 
$node_(271) set Z_ 0.0 
$ns at 0.0 "$node_(271) off" 
$ns at 200.0 "$node_(271) on" 
$node_(272) set X_ 2560 
$node_(272) set Y_ 222 
$node_(272) set Z_ 0.0 
$ns at 0.0 "$node_(272) off" 
$ns at 200.0 "$node_(272) on" 
$node_(273) set X_ 1939 
$node_(273) set Y_ 52 
$node_(273) set Z_ 0.0 
$ns at 0.0 "$node_(273) off" 
$ns at 200.0 "$node_(273) on" 
$node_(274) set X_ 2910 
$node_(274) set Y_ 10 
$node_(274) set Z_ 0.0 
$ns at 0.0 "$node_(274) off" 
$ns at 200.0 "$node_(274) on" 
$node_(275) set X_ 289 
$node_(275) set Y_ 880 
$node_(275) set Z_ 0.0 
$ns at 0.0 "$node_(275) off" 
$ns at 200.0 "$node_(275) on" 
$node_(276) set X_ 1168 
$node_(276) set Y_ 955 
$node_(276) set Z_ 0.0 
$ns at 0.0 "$node_(276) off" 
$ns at 200.0 "$node_(276) on" 
$node_(277) set X_ 1812 
$node_(277) set Y_ 90 
$node_(277) set Z_ 0.0 
$ns at 0.0 "$node_(277) off" 
$ns at 200.0 "$node_(277) on" 
$node_(278) set X_ 1210 
$node_(278) set Y_ 344 
$node_(278) set Z_ 0.0 
$ns at 0.0 "$node_(278) off" 
$ns at 200.0 "$node_(278) on" 
$node_(279) set X_ 2677 
$node_(279) set Y_ 46 
$node_(279) set Z_ 0.0 
$ns at 0.0 "$node_(279) off" 
$ns at 200.0 "$node_(279) on" 
$node_(280) set X_ 2468 
$node_(280) set Y_ 626 
$node_(280) set Z_ 0.0 
$ns at 0.0 "$node_(280) off" 
$ns at 200.0 "$node_(280) on" 
$node_(281) set X_ 477 
$node_(281) set Y_ 894 
$node_(281) set Z_ 0.0 
$ns at 0.0 "$node_(281) off" 
$ns at 200.0 "$node_(281) on" 
$node_(282) set X_ 2687 
$node_(282) set Y_ 743 
$node_(282) set Z_ 0.0 
$ns at 0.0 "$node_(282) off" 
$ns at 200.0 "$node_(282) on" 
$node_(283) set X_ 722 
$node_(283) set Y_ 281 
$node_(283) set Z_ 0.0 
$ns at 0.0 "$node_(283) off" 
$ns at 200.0 "$node_(283) on" 
$node_(284) set X_ 1335 
$node_(284) set Y_ 582 
$node_(284) set Z_ 0.0 
$ns at 0.0 "$node_(284) off" 
$ns at 200.0 "$node_(284) on" 
$node_(285) set X_ 2574 
$node_(285) set Y_ 971 
$node_(285) set Z_ 0.0 
$ns at 0.0 "$node_(285) off" 
$ns at 200.0 "$node_(285) on" 
$node_(286) set X_ 285 
$node_(286) set Y_ 496 
$node_(286) set Z_ 0.0 
$ns at 0.0 "$node_(286) off" 
$ns at 200.0 "$node_(286) on" 
$node_(287) set X_ 416 
$node_(287) set Y_ 211 
$node_(287) set Z_ 0.0 
$ns at 0.0 "$node_(287) off" 
$ns at 200.0 "$node_(287) on" 
$node_(288) set X_ 1368 
$node_(288) set Y_ 608 
$node_(288) set Z_ 0.0 
$ns at 0.0 "$node_(288) off" 
$ns at 200.0 "$node_(288) on" 
$node_(289) set X_ 2750 
$node_(289) set Y_ 892 
$node_(289) set Z_ 0.0 
$ns at 0.0 "$node_(289) off" 
$ns at 200.0 "$node_(289) on" 
$node_(290) set X_ 7 
$node_(290) set Y_ 445 
$node_(290) set Z_ 0.0 
$ns at 0.0 "$node_(290) off" 
$ns at 200.0 "$node_(290) on" 
$node_(291) set X_ 23 
$node_(291) set Y_ 413 
$node_(291) set Z_ 0.0 
$ns at 0.0 "$node_(291) off" 
$ns at 200.0 "$node_(291) on" 
$node_(292) set X_ 507 
$node_(292) set Y_ 545 
$node_(292) set Z_ 0.0 
$ns at 0.0 "$node_(292) off" 
$ns at 200.0 "$node_(292) on" 
$node_(293) set X_ 2370 
$node_(293) set Y_ 623 
$node_(293) set Z_ 0.0 
$ns at 0.0 "$node_(293) off" 
$ns at 200.0 "$node_(293) on" 
$node_(294) set X_ 2648 
$node_(294) set Y_ 846 
$node_(294) set Z_ 0.0 
$ns at 0.0 "$node_(294) off" 
$ns at 200.0 "$node_(294) on" 
$node_(295) set X_ 2775 
$node_(295) set Y_ 384 
$node_(295) set Z_ 0.0 
$ns at 0.0 "$node_(295) off" 
$ns at 200.0 "$node_(295) on" 
$node_(296) set X_ 1032 
$node_(296) set Y_ 37 
$node_(296) set Z_ 0.0 
$ns at 0.0 "$node_(296) off" 
$ns at 200.0 "$node_(296) on" 
$node_(297) set X_ 2962 
$node_(297) set Y_ 119 
$node_(297) set Z_ 0.0 
$ns at 0.0 "$node_(297) off" 
$ns at 200.0 "$node_(297) on" 
$node_(298) set X_ 1155 
$node_(298) set Y_ 572 
$node_(298) set Z_ 0.0 
$ns at 0.0 "$node_(298) off" 
$ns at 200.0 "$node_(298) on" 
$node_(299) set X_ 312 
$node_(299) set Y_ 151 
$node_(299) set Z_ 0.0 
$ns at 0.0 "$node_(299) off" 
$ns at 200.0 "$node_(299) on" 
$node_(300) set X_ 380 
$node_(300) set Y_ 680 
$node_(300) set Z_ 0.0 
$ns at 0.0 "$node_(300) off" 
$ns at 300.0 "$node_(300) on" 
$node_(301) set X_ 1335 
$node_(301) set Y_ 770 
$node_(301) set Z_ 0.0 
$ns at 0.0 "$node_(301) off" 
$ns at 300.0 "$node_(301) on" 
$node_(302) set X_ 2973 
$node_(302) set Y_ 587 
$node_(302) set Z_ 0.0 
$ns at 0.0 "$node_(302) off" 
$ns at 300.0 "$node_(302) on" 
$node_(303) set X_ 1636 
$node_(303) set Y_ 761 
$node_(303) set Z_ 0.0 
$ns at 0.0 "$node_(303) off" 
$ns at 300.0 "$node_(303) on" 
$node_(304) set X_ 1021 
$node_(304) set Y_ 91 
$node_(304) set Z_ 0.0 
$ns at 0.0 "$node_(304) off" 
$ns at 300.0 "$node_(304) on" 
$node_(305) set X_ 6 
$node_(305) set Y_ 527 
$node_(305) set Z_ 0.0 
$ns at 0.0 "$node_(305) off" 
$ns at 300.0 "$node_(305) on" 
$node_(306) set X_ 431 
$node_(306) set Y_ 806 
$node_(306) set Z_ 0.0 
$ns at 0.0 "$node_(306) off" 
$ns at 300.0 "$node_(306) on" 
$node_(307) set X_ 106 
$node_(307) set Y_ 69 
$node_(307) set Z_ 0.0 
$ns at 0.0 "$node_(307) off" 
$ns at 300.0 "$node_(307) on" 
$node_(308) set X_ 335 
$node_(308) set Y_ 667 
$node_(308) set Z_ 0.0 
$ns at 0.0 "$node_(308) off" 
$ns at 300.0 "$node_(308) on" 
$node_(309) set X_ 2333 
$node_(309) set Y_ 795 
$node_(309) set Z_ 0.0 
$ns at 0.0 "$node_(309) off" 
$ns at 300.0 "$node_(309) on" 
$node_(310) set X_ 2043 
$node_(310) set Y_ 749 
$node_(310) set Z_ 0.0 
$ns at 0.0 "$node_(310) off" 
$ns at 300.0 "$node_(310) on" 
$node_(311) set X_ 2756 
$node_(311) set Y_ 565 
$node_(311) set Z_ 0.0 
$ns at 0.0 "$node_(311) off" 
$ns at 300.0 "$node_(311) on" 
$node_(312) set X_ 225 
$node_(312) set Y_ 48 
$node_(312) set Z_ 0.0 
$ns at 0.0 "$node_(312) off" 
$ns at 300.0 "$node_(312) on" 
$node_(313) set X_ 1528 
$node_(313) set Y_ 421 
$node_(313) set Z_ 0.0 
$ns at 0.0 "$node_(313) off" 
$ns at 300.0 "$node_(313) on" 
$node_(314) set X_ 1294 
$node_(314) set Y_ 640 
$node_(314) set Z_ 0.0 
$ns at 0.0 "$node_(314) off" 
$ns at 300.0 "$node_(314) on" 
$node_(315) set X_ 968 
$node_(315) set Y_ 171 
$node_(315) set Z_ 0.0 
$ns at 0.0 "$node_(315) off" 
$ns at 300.0 "$node_(315) on" 
$node_(316) set X_ 1911 
$node_(316) set Y_ 565 
$node_(316) set Z_ 0.0 
$ns at 0.0 "$node_(316) off" 
$ns at 300.0 "$node_(316) on" 
$node_(317) set X_ 424 
$node_(317) set Y_ 364 
$node_(317) set Z_ 0.0 
$ns at 0.0 "$node_(317) off" 
$ns at 300.0 "$node_(317) on" 
$node_(318) set X_ 258 
$node_(318) set Y_ 829 
$node_(318) set Z_ 0.0 
$ns at 0.0 "$node_(318) off" 
$ns at 300.0 "$node_(318) on" 
$node_(319) set X_ 2259 
$node_(319) set Y_ 235 
$node_(319) set Z_ 0.0 
$ns at 0.0 "$node_(319) off" 
$ns at 300.0 "$node_(319) on" 
$node_(320) set X_ 143 
$node_(320) set Y_ 182 
$node_(320) set Z_ 0.0 
$ns at 0.0 "$node_(320) off" 
$ns at 300.0 "$node_(320) on" 
$node_(321) set X_ 674 
$node_(321) set Y_ 867 
$node_(321) set Z_ 0.0 
$ns at 0.0 "$node_(321) off" 
$ns at 300.0 "$node_(321) on" 
$node_(322) set X_ 2132 
$node_(322) set Y_ 696 
$node_(322) set Z_ 0.0 
$ns at 0.0 "$node_(322) off" 
$ns at 300.0 "$node_(322) on" 
$node_(323) set X_ 731 
$node_(323) set Y_ 163 
$node_(323) set Z_ 0.0 
$ns at 0.0 "$node_(323) off" 
$ns at 300.0 "$node_(323) on" 
$node_(324) set X_ 771 
$node_(324) set Y_ 707 
$node_(324) set Z_ 0.0 
$ns at 0.0 "$node_(324) off" 
$ns at 300.0 "$node_(324) on" 
$node_(325) set X_ 2765 
$node_(325) set Y_ 232 
$node_(325) set Z_ 0.0 
$ns at 0.0 "$node_(325) off" 
$ns at 300.0 "$node_(325) on" 
$node_(326) set X_ 1532 
$node_(326) set Y_ 422 
$node_(326) set Z_ 0.0 
$ns at 0.0 "$node_(326) off" 
$ns at 300.0 "$node_(326) on" 
$node_(327) set X_ 1446 
$node_(327) set Y_ 412 
$node_(327) set Z_ 0.0 
$ns at 0.0 "$node_(327) off" 
$ns at 300.0 "$node_(327) on" 
$node_(328) set X_ 2413 
$node_(328) set Y_ 286 
$node_(328) set Z_ 0.0 
$ns at 0.0 "$node_(328) off" 
$ns at 300.0 "$node_(328) on" 
$node_(329) set X_ 2017 
$node_(329) set Y_ 514 
$node_(329) set Z_ 0.0 
$ns at 0.0 "$node_(329) off" 
$ns at 300.0 "$node_(329) on" 
$node_(330) set X_ 2142 
$node_(330) set Y_ 282 
$node_(330) set Z_ 0.0 
$ns at 0.0 "$node_(330) off" 
$ns at 300.0 "$node_(330) on" 
$node_(331) set X_ 1763 
$node_(331) set Y_ 781 
$node_(331) set Z_ 0.0 
$ns at 0.0 "$node_(331) off" 
$ns at 300.0 "$node_(331) on" 
$node_(332) set X_ 665 
$node_(332) set Y_ 460 
$node_(332) set Z_ 0.0 
$ns at 0.0 "$node_(332) off" 
$ns at 300.0 "$node_(332) on" 
$node_(333) set X_ 2446 
$node_(333) set Y_ 721 
$node_(333) set Z_ 0.0 
$ns at 0.0 "$node_(333) off" 
$ns at 300.0 "$node_(333) on" 
$node_(334) set X_ 2047 
$node_(334) set Y_ 338 
$node_(334) set Z_ 0.0 
$ns at 0.0 "$node_(334) off" 
$ns at 300.0 "$node_(334) on" 
$node_(335) set X_ 1407 
$node_(335) set Y_ 230 
$node_(335) set Z_ 0.0 
$ns at 0.0 "$node_(335) off" 
$ns at 300.0 "$node_(335) on" 
$node_(336) set X_ 2085 
$node_(336) set Y_ 291 
$node_(336) set Z_ 0.0 
$ns at 0.0 "$node_(336) off" 
$ns at 300.0 "$node_(336) on" 
$node_(337) set X_ 2174 
$node_(337) set Y_ 358 
$node_(337) set Z_ 0.0 
$ns at 0.0 "$node_(337) off" 
$ns at 300.0 "$node_(337) on" 
$node_(338) set X_ 1845 
$node_(338) set Y_ 693 
$node_(338) set Z_ 0.0 
$ns at 0.0 "$node_(338) off" 
$ns at 300.0 "$node_(338) on" 
$node_(339) set X_ 2804 
$node_(339) set Y_ 666 
$node_(339) set Z_ 0.0 
$ns at 0.0 "$node_(339) off" 
$ns at 300.0 "$node_(339) on" 
$node_(340) set X_ 2896 
$node_(340) set Y_ 342 
$node_(340) set Z_ 0.0 
$ns at 0.0 "$node_(340) off" 
$ns at 300.0 "$node_(340) on" 
$node_(341) set X_ 757 
$node_(341) set Y_ 380 
$node_(341) set Z_ 0.0 
$ns at 0.0 "$node_(341) off" 
$ns at 300.0 "$node_(341) on" 
$node_(342) set X_ 1387 
$node_(342) set Y_ 697 
$node_(342) set Z_ 0.0 
$ns at 0.0 "$node_(342) off" 
$ns at 300.0 "$node_(342) on" 
$node_(343) set X_ 2949 
$node_(343) set Y_ 408 
$node_(343) set Z_ 0.0 
$ns at 0.0 "$node_(343) off" 
$ns at 300.0 "$node_(343) on" 
$node_(344) set X_ 2145 
$node_(344) set Y_ 511 
$node_(344) set Z_ 0.0 
$ns at 0.0 "$node_(344) off" 
$ns at 300.0 "$node_(344) on" 
$node_(345) set X_ 1605 
$node_(345) set Y_ 915 
$node_(345) set Z_ 0.0 
$ns at 0.0 "$node_(345) off" 
$ns at 300.0 "$node_(345) on" 
$node_(346) set X_ 2713 
$node_(346) set Y_ 739 
$node_(346) set Z_ 0.0 
$ns at 0.0 "$node_(346) off" 
$ns at 300.0 "$node_(346) on" 
$node_(347) set X_ 2852 
$node_(347) set Y_ 296 
$node_(347) set Z_ 0.0 
$ns at 0.0 "$node_(347) off" 
$ns at 300.0 "$node_(347) on" 
$node_(348) set X_ 2768 
$node_(348) set Y_ 11 
$node_(348) set Z_ 0.0 
$ns at 0.0 "$node_(348) off" 
$ns at 300.0 "$node_(348) on" 
$node_(349) set X_ 1390 
$node_(349) set Y_ 308 
$node_(349) set Z_ 0.0 
$ns at 0.0 "$node_(349) off" 
$ns at 300.0 "$node_(349) on" 
$node_(350) set X_ 1543 
$node_(350) set Y_ 531 
$node_(350) set Z_ 0.0 
$ns at 0.0 "$node_(350) off" 
$ns at 300.0 "$node_(350) on" 
$node_(351) set X_ 1322 
$node_(351) set Y_ 636 
$node_(351) set Z_ 0.0 
$ns at 0.0 "$node_(351) off" 
$ns at 300.0 "$node_(351) on" 
$node_(352) set X_ 2778 
$node_(352) set Y_ 996 
$node_(352) set Z_ 0.0 
$ns at 0.0 "$node_(352) off" 
$ns at 300.0 "$node_(352) on" 
$node_(353) set X_ 1090 
$node_(353) set Y_ 335 
$node_(353) set Z_ 0.0 
$ns at 0.0 "$node_(353) off" 
$ns at 300.0 "$node_(353) on" 
$node_(354) set X_ 1414 
$node_(354) set Y_ 25 
$node_(354) set Z_ 0.0 
$ns at 0.0 "$node_(354) off" 
$ns at 300.0 "$node_(354) on" 
$node_(355) set X_ 618 
$node_(355) set Y_ 458 
$node_(355) set Z_ 0.0 
$ns at 0.0 "$node_(355) off" 
$ns at 300.0 "$node_(355) on" 
$node_(356) set X_ 546 
$node_(356) set Y_ 614 
$node_(356) set Z_ 0.0 
$ns at 0.0 "$node_(356) off" 
$ns at 300.0 "$node_(356) on" 
$node_(357) set X_ 2076 
$node_(357) set Y_ 669 
$node_(357) set Z_ 0.0 
$ns at 0.0 "$node_(357) off" 
$ns at 300.0 "$node_(357) on" 
$node_(358) set X_ 1279 
$node_(358) set Y_ 356 
$node_(358) set Z_ 0.0 
$ns at 0.0 "$node_(358) off" 
$ns at 300.0 "$node_(358) on" 
$node_(359) set X_ 1265 
$node_(359) set Y_ 770 
$node_(359) set Z_ 0.0 
$ns at 0.0 "$node_(359) off" 
$ns at 300.0 "$node_(359) on" 
$node_(360) set X_ 2884 
$node_(360) set Y_ 501 
$node_(360) set Z_ 0.0 
$ns at 0.0 "$node_(360) off" 
$ns at 300.0 "$node_(360) on" 
$node_(361) set X_ 2396 
$node_(361) set Y_ 926 
$node_(361) set Z_ 0.0 
$ns at 0.0 "$node_(361) off" 
$ns at 300.0 "$node_(361) on" 
$node_(362) set X_ 1192 
$node_(362) set Y_ 457 
$node_(362) set Z_ 0.0 
$ns at 0.0 "$node_(362) off" 
$ns at 300.0 "$node_(362) on" 
$node_(363) set X_ 27 
$node_(363) set Y_ 786 
$node_(363) set Z_ 0.0 
$ns at 0.0 "$node_(363) off" 
$ns at 300.0 "$node_(363) on" 
$node_(364) set X_ 1399 
$node_(364) set Y_ 994 
$node_(364) set Z_ 0.0 
$ns at 0.0 "$node_(364) off" 
$ns at 300.0 "$node_(364) on" 
$node_(365) set X_ 151 
$node_(365) set Y_ 870 
$node_(365) set Z_ 0.0 
$ns at 0.0 "$node_(365) off" 
$ns at 300.0 "$node_(365) on" 
$node_(366) set X_ 2383 
$node_(366) set Y_ 242 
$node_(366) set Z_ 0.0 
$ns at 0.0 "$node_(366) off" 
$ns at 300.0 "$node_(366) on" 
$node_(367) set X_ 2853 
$node_(367) set Y_ 324 
$node_(367) set Z_ 0.0 
$ns at 0.0 "$node_(367) off" 
$ns at 300.0 "$node_(367) on" 
$node_(368) set X_ 332 
$node_(368) set Y_ 565 
$node_(368) set Z_ 0.0 
$ns at 0.0 "$node_(368) off" 
$ns at 300.0 "$node_(368) on" 
$node_(369) set X_ 2625 
$node_(369) set Y_ 618 
$node_(369) set Z_ 0.0 
$ns at 0.0 "$node_(369) off" 
$ns at 300.0 "$node_(369) on" 
$node_(370) set X_ 2852 
$node_(370) set Y_ 496 
$node_(370) set Z_ 0.0 
$ns at 0.0 "$node_(370) off" 
$ns at 300.0 "$node_(370) on" 
$node_(371) set X_ 2288 
$node_(371) set Y_ 833 
$node_(371) set Z_ 0.0 
$ns at 0.0 "$node_(371) off" 
$ns at 300.0 "$node_(371) on" 
$node_(372) set X_ 2846 
$node_(372) set Y_ 269 
$node_(372) set Z_ 0.0 
$ns at 0.0 "$node_(372) off" 
$ns at 300.0 "$node_(372) on" 
$node_(373) set X_ 1562 
$node_(373) set Y_ 921 
$node_(373) set Z_ 0.0 
$ns at 0.0 "$node_(373) off" 
$ns at 300.0 "$node_(373) on" 
$node_(374) set X_ 2279 
$node_(374) set Y_ 873 
$node_(374) set Z_ 0.0 
$ns at 0.0 "$node_(374) off" 
$ns at 300.0 "$node_(374) on" 
$node_(375) set X_ 1656 
$node_(375) set Y_ 761 
$node_(375) set Z_ 0.0 
$ns at 0.0 "$node_(375) off" 
$ns at 300.0 "$node_(375) on" 
$node_(376) set X_ 1474 
$node_(376) set Y_ 205 
$node_(376) set Z_ 0.0 
$ns at 0.0 "$node_(376) off" 
$ns at 300.0 "$node_(376) on" 
$node_(377) set X_ 1748 
$node_(377) set Y_ 848 
$node_(377) set Z_ 0.0 
$ns at 0.0 "$node_(377) off" 
$ns at 300.0 "$node_(377) on" 
$node_(378) set X_ 879 
$node_(378) set Y_ 643 
$node_(378) set Z_ 0.0 
$ns at 0.0 "$node_(378) off" 
$ns at 300.0 "$node_(378) on" 
$node_(379) set X_ 1018 
$node_(379) set Y_ 208 
$node_(379) set Z_ 0.0 
$ns at 0.0 "$node_(379) off" 
$ns at 300.0 "$node_(379) on" 
$node_(380) set X_ 1200 
$node_(380) set Y_ 270 
$node_(380) set Z_ 0.0 
$ns at 0.0 "$node_(380) off" 
$ns at 300.0 "$node_(380) on" 
$node_(381) set X_ 1802 
$node_(381) set Y_ 471 
$node_(381) set Z_ 0.0 
$ns at 0.0 "$node_(381) off" 
$ns at 300.0 "$node_(381) on" 
$node_(382) set X_ 1514 
$node_(382) set Y_ 84 
$node_(382) set Z_ 0.0 
$ns at 0.0 "$node_(382) off" 
$ns at 300.0 "$node_(382) on" 
$node_(383) set X_ 1703 
$node_(383) set Y_ 90 
$node_(383) set Z_ 0.0 
$ns at 0.0 "$node_(383) off" 
$ns at 300.0 "$node_(383) on" 
$node_(384) set X_ 2386 
$node_(384) set Y_ 725 
$node_(384) set Z_ 0.0 
$ns at 0.0 "$node_(384) off" 
$ns at 300.0 "$node_(384) on" 
$node_(385) set X_ 818 
$node_(385) set Y_ 364 
$node_(385) set Z_ 0.0 
$ns at 0.0 "$node_(385) off" 
$ns at 300.0 "$node_(385) on" 
$node_(386) set X_ 1168 
$node_(386) set Y_ 664 
$node_(386) set Z_ 0.0 
$ns at 0.0 "$node_(386) off" 
$ns at 300.0 "$node_(386) on" 
$node_(387) set X_ 2923 
$node_(387) set Y_ 254 
$node_(387) set Z_ 0.0 
$ns at 0.0 "$node_(387) off" 
$ns at 300.0 "$node_(387) on" 
$node_(388) set X_ 500 
$node_(388) set Y_ 339 
$node_(388) set Z_ 0.0 
$ns at 0.0 "$node_(388) off" 
$ns at 300.0 "$node_(388) on" 
$node_(389) set X_ 277 
$node_(389) set Y_ 14 
$node_(389) set Z_ 0.0 
$ns at 0.0 "$node_(389) off" 
$ns at 300.0 "$node_(389) on" 
$node_(390) set X_ 617 
$node_(390) set Y_ 402 
$node_(390) set Z_ 0.0 
$ns at 0.0 "$node_(390) off" 
$ns at 300.0 "$node_(390) on" 
$node_(391) set X_ 760 
$node_(391) set Y_ 260 
$node_(391) set Z_ 0.0 
$ns at 0.0 "$node_(391) off" 
$ns at 300.0 "$node_(391) on" 
$node_(392) set X_ 373 
$node_(392) set Y_ 134 
$node_(392) set Z_ 0.0 
$ns at 0.0 "$node_(392) off" 
$ns at 300.0 "$node_(392) on" 
$node_(393) set X_ 1367 
$node_(393) set Y_ 465 
$node_(393) set Z_ 0.0 
$ns at 0.0 "$node_(393) off" 
$ns at 300.0 "$node_(393) on" 
$node_(394) set X_ 1884 
$node_(394) set Y_ 61 
$node_(394) set Z_ 0.0 
$ns at 0.0 "$node_(394) off" 
$ns at 300.0 "$node_(394) on" 
$node_(395) set X_ 546 
$node_(395) set Y_ 784 
$node_(395) set Z_ 0.0 
$ns at 0.0 "$node_(395) off" 
$ns at 300.0 "$node_(395) on" 
$node_(396) set X_ 1445 
$node_(396) set Y_ 998 
$node_(396) set Z_ 0.0 
$ns at 0.0 "$node_(396) off" 
$ns at 300.0 "$node_(396) on" 
$node_(397) set X_ 1616 
$node_(397) set Y_ 779 
$node_(397) set Z_ 0.0 
$ns at 0.0 "$node_(397) off" 
$ns at 300.0 "$node_(397) on" 
$node_(398) set X_ 2826 
$node_(398) set Y_ 62 
$node_(398) set Z_ 0.0 
$ns at 0.0 "$node_(398) off" 
$ns at 300.0 "$node_(398) on" 
$node_(399) set X_ 415 
$node_(399) set Y_ 852 
$node_(399) set Z_ 0.0 
$ns at 0.0 "$node_(399) off" 
$ns at 300.0 "$node_(399) on" 
$node_(400) set X_ 1208 
$node_(400) set Y_ 683 
$node_(400) set Z_ 0.0 
$ns at 0.0 "$node_(400) off" 
$ns at 400.0 "$node_(400) on" 
$node_(401) set X_ 1496 
$node_(401) set Y_ 160 
$node_(401) set Z_ 0.0 
$ns at 0.0 "$node_(401) off" 
$ns at 400.0 "$node_(401) on" 
$node_(402) set X_ 1933 
$node_(402) set Y_ 267 
$node_(402) set Z_ 0.0 
$ns at 0.0 "$node_(402) off" 
$ns at 400.0 "$node_(402) on" 
$node_(403) set X_ 560 
$node_(403) set Y_ 360 
$node_(403) set Z_ 0.0 
$ns at 0.0 "$node_(403) off" 
$ns at 400.0 "$node_(403) on" 
$node_(404) set X_ 1825 
$node_(404) set Y_ 973 
$node_(404) set Z_ 0.0 
$ns at 0.0 "$node_(404) off" 
$ns at 400.0 "$node_(404) on" 
$node_(405) set X_ 2400 
$node_(405) set Y_ 791 
$node_(405) set Z_ 0.0 
$ns at 0.0 "$node_(405) off" 
$ns at 400.0 "$node_(405) on" 
$node_(406) set X_ 189 
$node_(406) set Y_ 18 
$node_(406) set Z_ 0.0 
$ns at 0.0 "$node_(406) off" 
$ns at 400.0 "$node_(406) on" 
$node_(407) set X_ 463 
$node_(407) set Y_ 580 
$node_(407) set Z_ 0.0 
$ns at 0.0 "$node_(407) off" 
$ns at 400.0 "$node_(407) on" 
$node_(408) set X_ 2625 
$node_(408) set Y_ 10 
$node_(408) set Z_ 0.0 
$ns at 0.0 "$node_(408) off" 
$ns at 400.0 "$node_(408) on" 
$node_(409) set X_ 2134 
$node_(409) set Y_ 757 
$node_(409) set Z_ 0.0 
$ns at 0.0 "$node_(409) off" 
$ns at 400.0 "$node_(409) on" 
$node_(410) set X_ 2569 
$node_(410) set Y_ 91 
$node_(410) set Z_ 0.0 
$ns at 0.0 "$node_(410) off" 
$ns at 400.0 "$node_(410) on" 
$node_(411) set X_ 1132 
$node_(411) set Y_ 630 
$node_(411) set Z_ 0.0 
$ns at 0.0 "$node_(411) off" 
$ns at 400.0 "$node_(411) on" 
$node_(412) set X_ 946 
$node_(412) set Y_ 88 
$node_(412) set Z_ 0.0 
$ns at 0.0 "$node_(412) off" 
$ns at 400.0 "$node_(412) on" 
$node_(413) set X_ 840 
$node_(413) set Y_ 604 
$node_(413) set Z_ 0.0 
$ns at 0.0 "$node_(413) off" 
$ns at 400.0 "$node_(413) on" 
$node_(414) set X_ 1535 
$node_(414) set Y_ 441 
$node_(414) set Z_ 0.0 
$ns at 0.0 "$node_(414) off" 
$ns at 400.0 "$node_(414) on" 
$node_(415) set X_ 116 
$node_(415) set Y_ 86 
$node_(415) set Z_ 0.0 
$ns at 0.0 "$node_(415) off" 
$ns at 400.0 "$node_(415) on" 
$node_(416) set X_ 549 
$node_(416) set Y_ 399 
$node_(416) set Z_ 0.0 
$ns at 0.0 "$node_(416) off" 
$ns at 400.0 "$node_(416) on" 
$node_(417) set X_ 992 
$node_(417) set Y_ 375 
$node_(417) set Z_ 0.0 
$ns at 0.0 "$node_(417) off" 
$ns at 400.0 "$node_(417) on" 
$node_(418) set X_ 601 
$node_(418) set Y_ 898 
$node_(418) set Z_ 0.0 
$ns at 0.0 "$node_(418) off" 
$ns at 400.0 "$node_(418) on" 
$node_(419) set X_ 838 
$node_(419) set Y_ 215 
$node_(419) set Z_ 0.0 
$ns at 0.0 "$node_(419) off" 
$ns at 400.0 "$node_(419) on" 
$node_(420) set X_ 547 
$node_(420) set Y_ 521 
$node_(420) set Z_ 0.0 
$ns at 0.0 "$node_(420) off" 
$ns at 400.0 "$node_(420) on" 
$node_(421) set X_ 876 
$node_(421) set Y_ 220 
$node_(421) set Z_ 0.0 
$ns at 0.0 "$node_(421) off" 
$ns at 400.0 "$node_(421) on" 
$node_(422) set X_ 1815 
$node_(422) set Y_ 203 
$node_(422) set Z_ 0.0 
$ns at 0.0 "$node_(422) off" 
$ns at 400.0 "$node_(422) on" 
$node_(423) set X_ 1507 
$node_(423) set Y_ 535 
$node_(423) set Z_ 0.0 
$ns at 0.0 "$node_(423) off" 
$ns at 400.0 "$node_(423) on" 
$node_(424) set X_ 1585 
$node_(424) set Y_ 658 
$node_(424) set Z_ 0.0 
$ns at 0.0 "$node_(424) off" 
$ns at 400.0 "$node_(424) on" 
$node_(425) set X_ 2695 
$node_(425) set Y_ 883 
$node_(425) set Z_ 0.0 
$ns at 0.0 "$node_(425) off" 
$ns at 400.0 "$node_(425) on" 
$node_(426) set X_ 1745 
$node_(426) set Y_ 25 
$node_(426) set Z_ 0.0 
$ns at 0.0 "$node_(426) off" 
$ns at 400.0 "$node_(426) on" 
$node_(427) set X_ 1644 
$node_(427) set Y_ 640 
$node_(427) set Z_ 0.0 
$ns at 0.0 "$node_(427) off" 
$ns at 400.0 "$node_(427) on" 
$node_(428) set X_ 723 
$node_(428) set Y_ 915 
$node_(428) set Z_ 0.0 
$ns at 0.0 "$node_(428) off" 
$ns at 400.0 "$node_(428) on" 
$node_(429) set X_ 217 
$node_(429) set Y_ 677 
$node_(429) set Z_ 0.0 
$ns at 0.0 "$node_(429) off" 
$ns at 400.0 "$node_(429) on" 
$node_(430) set X_ 2315 
$node_(430) set Y_ 856 
$node_(430) set Z_ 0.0 
$ns at 0.0 "$node_(430) off" 
$ns at 400.0 "$node_(430) on" 
$node_(431) set X_ 2008 
$node_(431) set Y_ 520 
$node_(431) set Z_ 0.0 
$ns at 0.0 "$node_(431) off" 
$ns at 400.0 "$node_(431) on" 
$node_(432) set X_ 1240 
$node_(432) set Y_ 102 
$node_(432) set Z_ 0.0 
$ns at 0.0 "$node_(432) off" 
$ns at 400.0 "$node_(432) on" 
$node_(433) set X_ 1600 
$node_(433) set Y_ 762 
$node_(433) set Z_ 0.0 
$ns at 0.0 "$node_(433) off" 
$ns at 400.0 "$node_(433) on" 
$node_(434) set X_ 1576 
$node_(434) set Y_ 936 
$node_(434) set Z_ 0.0 
$ns at 0.0 "$node_(434) off" 
$ns at 400.0 "$node_(434) on" 
$node_(435) set X_ 1433 
$node_(435) set Y_ 821 
$node_(435) set Z_ 0.0 
$ns at 0.0 "$node_(435) off" 
$ns at 400.0 "$node_(435) on" 
$node_(436) set X_ 1332 
$node_(436) set Y_ 868 
$node_(436) set Z_ 0.0 
$ns at 0.0 "$node_(436) off" 
$ns at 400.0 "$node_(436) on" 
$node_(437) set X_ 2813 
$node_(437) set Y_ 811 
$node_(437) set Z_ 0.0 
$ns at 0.0 "$node_(437) off" 
$ns at 400.0 "$node_(437) on" 
$node_(438) set X_ 2243 
$node_(438) set Y_ 589 
$node_(438) set Z_ 0.0 
$ns at 0.0 "$node_(438) off" 
$ns at 400.0 "$node_(438) on" 
$node_(439) set X_ 862 
$node_(439) set Y_ 755 
$node_(439) set Z_ 0.0 
$ns at 0.0 "$node_(439) off" 
$ns at 400.0 "$node_(439) on" 
$node_(440) set X_ 1399 
$node_(440) set Y_ 155 
$node_(440) set Z_ 0.0 
$ns at 0.0 "$node_(440) off" 
$ns at 400.0 "$node_(440) on" 
$node_(441) set X_ 1794 
$node_(441) set Y_ 399 
$node_(441) set Z_ 0.0 
$ns at 0.0 "$node_(441) off" 
$ns at 400.0 "$node_(441) on" 
$node_(442) set X_ 1615 
$node_(442) set Y_ 620 
$node_(442) set Z_ 0.0 
$ns at 0.0 "$node_(442) off" 
$ns at 400.0 "$node_(442) on" 
$node_(443) set X_ 1606 
$node_(443) set Y_ 609 
$node_(443) set Z_ 0.0 
$ns at 0.0 "$node_(443) off" 
$ns at 400.0 "$node_(443) on" 
$node_(444) set X_ 1411 
$node_(444) set Y_ 270 
$node_(444) set Z_ 0.0 
$ns at 0.0 "$node_(444) off" 
$ns at 400.0 "$node_(444) on" 
$node_(445) set X_ 257 
$node_(445) set Y_ 697 
$node_(445) set Z_ 0.0 
$ns at 0.0 "$node_(445) off" 
$ns at 400.0 "$node_(445) on" 
$node_(446) set X_ 2180 
$node_(446) set Y_ 681 
$node_(446) set Z_ 0.0 
$ns at 0.0 "$node_(446) off" 
$ns at 400.0 "$node_(446) on" 
$node_(447) set X_ 609 
$node_(447) set Y_ 79 
$node_(447) set Z_ 0.0 
$ns at 0.0 "$node_(447) off" 
$ns at 400.0 "$node_(447) on" 
$node_(448) set X_ 2545 
$node_(448) set Y_ 64 
$node_(448) set Z_ 0.0 
$ns at 0.0 "$node_(448) off" 
$ns at 400.0 "$node_(448) on" 
$node_(449) set X_ 784 
$node_(449) set Y_ 300 
$node_(449) set Z_ 0.0 
$ns at 0.0 "$node_(449) off" 
$ns at 400.0 "$node_(449) on" 
$node_(450) set X_ 2032 
$node_(450) set Y_ 720 
$node_(450) set Z_ 0.0 
$ns at 0.0 "$node_(450) off" 
$ns at 400.0 "$node_(450) on" 
$node_(451) set X_ 1230 
$node_(451) set Y_ 867 
$node_(451) set Z_ 0.0 
$ns at 0.0 "$node_(451) off" 
$ns at 400.0 "$node_(451) on" 
$node_(452) set X_ 1076 
$node_(452) set Y_ 16 
$node_(452) set Z_ 0.0 
$ns at 0.0 "$node_(452) off" 
$ns at 400.0 "$node_(452) on" 
$node_(453) set X_ 1629 
$node_(453) set Y_ 269 
$node_(453) set Z_ 0.0 
$ns at 0.0 "$node_(453) off" 
$ns at 400.0 "$node_(453) on" 
$node_(454) set X_ 2910 
$node_(454) set Y_ 943 
$node_(454) set Z_ 0.0 
$ns at 0.0 "$node_(454) off" 
$ns at 400.0 "$node_(454) on" 
$node_(455) set X_ 1840 
$node_(455) set Y_ 256 
$node_(455) set Z_ 0.0 
$ns at 0.0 "$node_(455) off" 
$ns at 400.0 "$node_(455) on" 
$node_(456) set X_ 2224 
$node_(456) set Y_ 223 
$node_(456) set Z_ 0.0 
$ns at 0.0 "$node_(456) off" 
$ns at 400.0 "$node_(456) on" 
$node_(457) set X_ 1359 
$node_(457) set Y_ 733 
$node_(457) set Z_ 0.0 
$ns at 0.0 "$node_(457) off" 
$ns at 400.0 "$node_(457) on" 
$node_(458) set X_ 2469 
$node_(458) set Y_ 904 
$node_(458) set Z_ 0.0 
$ns at 0.0 "$node_(458) off" 
$ns at 400.0 "$node_(458) on" 
$node_(459) set X_ 250 
$node_(459) set Y_ 619 
$node_(459) set Z_ 0.0 
$ns at 0.0 "$node_(459) off" 
$ns at 400.0 "$node_(459) on" 
$node_(460) set X_ 1427 
$node_(460) set Y_ 573 
$node_(460) set Z_ 0.0 
$ns at 0.0 "$node_(460) off" 
$ns at 400.0 "$node_(460) on" 
$node_(461) set X_ 2261 
$node_(461) set Y_ 608 
$node_(461) set Z_ 0.0 
$ns at 0.0 "$node_(461) off" 
$ns at 400.0 "$node_(461) on" 
$node_(462) set X_ 1114 
$node_(462) set Y_ 640 
$node_(462) set Z_ 0.0 
$ns at 0.0 "$node_(462) off" 
$ns at 400.0 "$node_(462) on" 
$node_(463) set X_ 1743 
$node_(463) set Y_ 75 
$node_(463) set Z_ 0.0 
$ns at 0.0 "$node_(463) off" 
$ns at 400.0 "$node_(463) on" 
$node_(464) set X_ 1259 
$node_(464) set Y_ 618 
$node_(464) set Z_ 0.0 
$ns at 0.0 "$node_(464) off" 
$ns at 400.0 "$node_(464) on" 
$node_(465) set X_ 2144 
$node_(465) set Y_ 296 
$node_(465) set Z_ 0.0 
$ns at 0.0 "$node_(465) off" 
$ns at 400.0 "$node_(465) on" 
$node_(466) set X_ 486 
$node_(466) set Y_ 975 
$node_(466) set Z_ 0.0 
$ns at 0.0 "$node_(466) off" 
$ns at 400.0 "$node_(466) on" 
$node_(467) set X_ 1256 
$node_(467) set Y_ 734 
$node_(467) set Z_ 0.0 
$ns at 0.0 "$node_(467) off" 
$ns at 400.0 "$node_(467) on" 
$node_(468) set X_ 945 
$node_(468) set Y_ 917 
$node_(468) set Z_ 0.0 
$ns at 0.0 "$node_(468) off" 
$ns at 400.0 "$node_(468) on" 
$node_(469) set X_ 951 
$node_(469) set Y_ 412 
$node_(469) set Z_ 0.0 
$ns at 0.0 "$node_(469) off" 
$ns at 400.0 "$node_(469) on" 
$node_(470) set X_ 1443 
$node_(470) set Y_ 410 
$node_(470) set Z_ 0.0 
$ns at 0.0 "$node_(470) off" 
$ns at 400.0 "$node_(470) on" 
$node_(471) set X_ 965 
$node_(471) set Y_ 257 
$node_(471) set Z_ 0.0 
$ns at 0.0 "$node_(471) off" 
$ns at 400.0 "$node_(471) on" 
$node_(472) set X_ 1206 
$node_(472) set Y_ 875 
$node_(472) set Z_ 0.0 
$ns at 0.0 "$node_(472) off" 
$ns at 400.0 "$node_(472) on" 
$node_(473) set X_ 1335 
$node_(473) set Y_ 908 
$node_(473) set Z_ 0.0 
$ns at 0.0 "$node_(473) off" 
$ns at 400.0 "$node_(473) on" 
$node_(474) set X_ 1128 
$node_(474) set Y_ 220 
$node_(474) set Z_ 0.0 
$ns at 0.0 "$node_(474) off" 
$ns at 400.0 "$node_(474) on" 
$node_(475) set X_ 2316 
$node_(475) set Y_ 668 
$node_(475) set Z_ 0.0 
$ns at 0.0 "$node_(475) off" 
$ns at 400.0 "$node_(475) on" 
$node_(476) set X_ 1883 
$node_(476) set Y_ 330 
$node_(476) set Z_ 0.0 
$ns at 0.0 "$node_(476) off" 
$ns at 400.0 "$node_(476) on" 
$node_(477) set X_ 1094 
$node_(477) set Y_ 140 
$node_(477) set Z_ 0.0 
$ns at 0.0 "$node_(477) off" 
$ns at 400.0 "$node_(477) on" 
$node_(478) set X_ 1454 
$node_(478) set Y_ 670 
$node_(478) set Z_ 0.0 
$ns at 0.0 "$node_(478) off" 
$ns at 400.0 "$node_(478) on" 
$node_(479) set X_ 2283 
$node_(479) set Y_ 651 
$node_(479) set Z_ 0.0 
$ns at 0.0 "$node_(479) off" 
$ns at 400.0 "$node_(479) on" 
$node_(480) set X_ 561 
$node_(480) set Y_ 431 
$node_(480) set Z_ 0.0 
$ns at 0.0 "$node_(480) off" 
$ns at 400.0 "$node_(480) on" 
$node_(481) set X_ 118 
$node_(481) set Y_ 733 
$node_(481) set Z_ 0.0 
$ns at 0.0 "$node_(481) off" 
$ns at 400.0 "$node_(481) on" 
$node_(482) set X_ 111 
$node_(482) set Y_ 491 
$node_(482) set Z_ 0.0 
$ns at 0.0 "$node_(482) off" 
$ns at 400.0 "$node_(482) on" 
$node_(483) set X_ 358 
$node_(483) set Y_ 755 
$node_(483) set Z_ 0.0 
$ns at 0.0 "$node_(483) off" 
$ns at 400.0 "$node_(483) on" 
$node_(484) set X_ 1160 
$node_(484) set Y_ 557 
$node_(484) set Z_ 0.0 
$ns at 0.0 "$node_(484) off" 
$ns at 400.0 "$node_(484) on" 
$node_(485) set X_ 261 
$node_(485) set Y_ 328 
$node_(485) set Z_ 0.0 
$ns at 0.0 "$node_(485) off" 
$ns at 400.0 "$node_(485) on" 
$node_(486) set X_ 1922 
$node_(486) set Y_ 2 
$node_(486) set Z_ 0.0 
$ns at 0.0 "$node_(486) off" 
$ns at 400.0 "$node_(486) on" 
$node_(487) set X_ 2581 
$node_(487) set Y_ 246 
$node_(487) set Z_ 0.0 
$ns at 0.0 "$node_(487) off" 
$ns at 400.0 "$node_(487) on" 
$node_(488) set X_ 207 
$node_(488) set Y_ 311 
$node_(488) set Z_ 0.0 
$ns at 0.0 "$node_(488) off" 
$ns at 400.0 "$node_(488) on" 
$node_(489) set X_ 1271 
$node_(489) set Y_ 519 
$node_(489) set Z_ 0.0 
$ns at 0.0 "$node_(489) off" 
$ns at 400.0 "$node_(489) on" 
$node_(490) set X_ 2136 
$node_(490) set Y_ 534 
$node_(490) set Z_ 0.0 
$ns at 0.0 "$node_(490) off" 
$ns at 400.0 "$node_(490) on" 
$node_(491) set X_ 614 
$node_(491) set Y_ 547 
$node_(491) set Z_ 0.0 
$ns at 0.0 "$node_(491) off" 
$ns at 400.0 "$node_(491) on" 
$node_(492) set X_ 245 
$node_(492) set Y_ 839 
$node_(492) set Z_ 0.0 
$ns at 0.0 "$node_(492) off" 
$ns at 400.0 "$node_(492) on" 
$node_(493) set X_ 2704 
$node_(493) set Y_ 591 
$node_(493) set Z_ 0.0 
$ns at 0.0 "$node_(493) off" 
$ns at 400.0 "$node_(493) on" 
$node_(494) set X_ 2021 
$node_(494) set Y_ 41 
$node_(494) set Z_ 0.0 
$ns at 0.0 "$node_(494) off" 
$ns at 400.0 "$node_(494) on" 
$node_(495) set X_ 640 
$node_(495) set Y_ 471 
$node_(495) set Z_ 0.0 
$ns at 0.0 "$node_(495) off" 
$ns at 400.0 "$node_(495) on" 
$node_(496) set X_ 1613 
$node_(496) set Y_ 23 
$node_(496) set Z_ 0.0 
$ns at 0.0 "$node_(496) off" 
$ns at 400.0 "$node_(496) on" 
$node_(497) set X_ 1450 
$node_(497) set Y_ 872 
$node_(497) set Z_ 0.0 
$ns at 0.0 "$node_(497) off" 
$ns at 400.0 "$node_(497) on" 
$node_(498) set X_ 812 
$node_(498) set Y_ 48 
$node_(498) set Z_ 0.0 
$ns at 0.0 "$node_(498) off" 
$ns at 400.0 "$node_(498) on" 
$node_(499) set X_ 629 
$node_(499) set Y_ 713 
$node_(499) set Z_ 0.0 
$ns at 0.0 "$node_(499) off" 
$ns at 400.0 "$node_(499) on" 
$node_(500) set X_ 2539 
$node_(500) set Y_ 288 
$node_(500) set Z_ 0.0 
$ns at 0.0 "$node_(500) off" 
$ns at 500.0 "$node_(500) on" 
$node_(501) set X_ 2294 
$node_(501) set Y_ 788 
$node_(501) set Z_ 0.0 
$ns at 0.0 "$node_(501) off" 
$ns at 500.0 "$node_(501) on" 
$node_(502) set X_ 1881 
$node_(502) set Y_ 335 
$node_(502) set Z_ 0.0 
$ns at 0.0 "$node_(502) off" 
$ns at 500.0 "$node_(502) on" 
$node_(503) set X_ 1228 
$node_(503) set Y_ 301 
$node_(503) set Z_ 0.0 
$ns at 0.0 "$node_(503) off" 
$ns at 500.0 "$node_(503) on" 
$node_(504) set X_ 2278 
$node_(504) set Y_ 63 
$node_(504) set Z_ 0.0 
$ns at 0.0 "$node_(504) off" 
$ns at 500.0 "$node_(504) on" 
$node_(505) set X_ 2655 
$node_(505) set Y_ 952 
$node_(505) set Z_ 0.0 
$ns at 0.0 "$node_(505) off" 
$ns at 500.0 "$node_(505) on" 
$node_(506) set X_ 2711 
$node_(506) set Y_ 986 
$node_(506) set Z_ 0.0 
$ns at 0.0 "$node_(506) off" 
$ns at 500.0 "$node_(506) on" 
$node_(507) set X_ 1319 
$node_(507) set Y_ 973 
$node_(507) set Z_ 0.0 
$ns at 0.0 "$node_(507) off" 
$ns at 500.0 "$node_(507) on" 
$node_(508) set X_ 2752 
$node_(508) set Y_ 151 
$node_(508) set Z_ 0.0 
$ns at 0.0 "$node_(508) off" 
$ns at 500.0 "$node_(508) on" 
$node_(509) set X_ 399 
$node_(509) set Y_ 870 
$node_(509) set Z_ 0.0 
$ns at 0.0 "$node_(509) off" 
$ns at 500.0 "$node_(509) on" 
$node_(510) set X_ 2006 
$node_(510) set Y_ 712 
$node_(510) set Z_ 0.0 
$ns at 0.0 "$node_(510) off" 
$ns at 500.0 "$node_(510) on" 
$node_(511) set X_ 2008 
$node_(511) set Y_ 665 
$node_(511) set Z_ 0.0 
$ns at 0.0 "$node_(511) off" 
$ns at 500.0 "$node_(511) on" 
$node_(512) set X_ 1914 
$node_(512) set Y_ 538 
$node_(512) set Z_ 0.0 
$ns at 0.0 "$node_(512) off" 
$ns at 500.0 "$node_(512) on" 
$node_(513) set X_ 2391 
$node_(513) set Y_ 95 
$node_(513) set Z_ 0.0 
$ns at 0.0 "$node_(513) off" 
$ns at 500.0 "$node_(513) on" 
$node_(514) set X_ 1039 
$node_(514) set Y_ 594 
$node_(514) set Z_ 0.0 
$ns at 0.0 "$node_(514) off" 
$ns at 500.0 "$node_(514) on" 
$node_(515) set X_ 1591 
$node_(515) set Y_ 600 
$node_(515) set Z_ 0.0 
$ns at 0.0 "$node_(515) off" 
$ns at 500.0 "$node_(515) on" 
$node_(516) set X_ 2781 
$node_(516) set Y_ 411 
$node_(516) set Z_ 0.0 
$ns at 0.0 "$node_(516) off" 
$ns at 500.0 "$node_(516) on" 
$node_(517) set X_ 186 
$node_(517) set Y_ 906 
$node_(517) set Z_ 0.0 
$ns at 0.0 "$node_(517) off" 
$ns at 500.0 "$node_(517) on" 
$node_(518) set X_ 1071 
$node_(518) set Y_ 619 
$node_(518) set Z_ 0.0 
$ns at 0.0 "$node_(518) off" 
$ns at 500.0 "$node_(518) on" 
$node_(519) set X_ 750 
$node_(519) set Y_ 652 
$node_(519) set Z_ 0.0 
$ns at 0.0 "$node_(519) off" 
$ns at 500.0 "$node_(519) on" 
$node_(520) set X_ 2886 
$node_(520) set Y_ 393 
$node_(520) set Z_ 0.0 
$ns at 0.0 "$node_(520) off" 
$ns at 500.0 "$node_(520) on" 
$node_(521) set X_ 2997 
$node_(521) set Y_ 860 
$node_(521) set Z_ 0.0 
$ns at 0.0 "$node_(521) off" 
$ns at 500.0 "$node_(521) on" 
$node_(522) set X_ 2430 
$node_(522) set Y_ 688 
$node_(522) set Z_ 0.0 
$ns at 0.0 "$node_(522) off" 
$ns at 500.0 "$node_(522) on" 
$node_(523) set X_ 2029 
$node_(523) set Y_ 964 
$node_(523) set Z_ 0.0 
$ns at 0.0 "$node_(523) off" 
$ns at 500.0 "$node_(523) on" 
$node_(524) set X_ 1576 
$node_(524) set Y_ 275 
$node_(524) set Z_ 0.0 
$ns at 0.0 "$node_(524) off" 
$ns at 500.0 "$node_(524) on" 
$node_(525) set X_ 2866 
$node_(525) set Y_ 776 
$node_(525) set Z_ 0.0 
$ns at 0.0 "$node_(525) off" 
$ns at 500.0 "$node_(525) on" 
$node_(526) set X_ 2593 
$node_(526) set Y_ 955 
$node_(526) set Z_ 0.0 
$ns at 0.0 "$node_(526) off" 
$ns at 500.0 "$node_(526) on" 
$node_(527) set X_ 352 
$node_(527) set Y_ 20 
$node_(527) set Z_ 0.0 
$ns at 0.0 "$node_(527) off" 
$ns at 500.0 "$node_(527) on" 
$node_(528) set X_ 393 
$node_(528) set Y_ 764 
$node_(528) set Z_ 0.0 
$ns at 0.0 "$node_(528) off" 
$ns at 500.0 "$node_(528) on" 
$node_(529) set X_ 2669 
$node_(529) set Y_ 5 
$node_(529) set Z_ 0.0 
$ns at 0.0 "$node_(529) off" 
$ns at 500.0 "$node_(529) on" 
$node_(530) set X_ 361 
$node_(530) set Y_ 669 
$node_(530) set Z_ 0.0 
$ns at 0.0 "$node_(530) off" 
$ns at 500.0 "$node_(530) on" 
$node_(531) set X_ 1122 
$node_(531) set Y_ 624 
$node_(531) set Z_ 0.0 
$ns at 0.0 "$node_(531) off" 
$ns at 500.0 "$node_(531) on" 
$node_(532) set X_ 2507 
$node_(532) set Y_ 9 
$node_(532) set Z_ 0.0 
$ns at 0.0 "$node_(532) off" 
$ns at 500.0 "$node_(532) on" 
$node_(533) set X_ 1369 
$node_(533) set Y_ 51 
$node_(533) set Z_ 0.0 
$ns at 0.0 "$node_(533) off" 
$ns at 500.0 "$node_(533) on" 
$node_(534) set X_ 1962 
$node_(534) set Y_ 897 
$node_(534) set Z_ 0.0 
$ns at 0.0 "$node_(534) off" 
$ns at 500.0 "$node_(534) on" 
$node_(535) set X_ 1167 
$node_(535) set Y_ 502 
$node_(535) set Z_ 0.0 
$ns at 0.0 "$node_(535) off" 
$ns at 500.0 "$node_(535) on" 
$node_(536) set X_ 2891 
$node_(536) set Y_ 933 
$node_(536) set Z_ 0.0 
$ns at 0.0 "$node_(536) off" 
$ns at 500.0 "$node_(536) on" 
$node_(537) set X_ 2666 
$node_(537) set Y_ 886 
$node_(537) set Z_ 0.0 
$ns at 0.0 "$node_(537) off" 
$ns at 500.0 "$node_(537) on" 
$node_(538) set X_ 1683 
$node_(538) set Y_ 779 
$node_(538) set Z_ 0.0 
$ns at 0.0 "$node_(538) off" 
$ns at 500.0 "$node_(538) on" 
$node_(539) set X_ 569 
$node_(539) set Y_ 477 
$node_(539) set Z_ 0.0 
$ns at 0.0 "$node_(539) off" 
$ns at 500.0 "$node_(539) on" 
$node_(540) set X_ 732 
$node_(540) set Y_ 640 
$node_(540) set Z_ 0.0 
$ns at 0.0 "$node_(540) off" 
$ns at 500.0 "$node_(540) on" 
$node_(541) set X_ 2947 
$node_(541) set Y_ 538 
$node_(541) set Z_ 0.0 
$ns at 0.0 "$node_(541) off" 
$ns at 500.0 "$node_(541) on" 
$node_(542) set X_ 352 
$node_(542) set Y_ 209 
$node_(542) set Z_ 0.0 
$ns at 0.0 "$node_(542) off" 
$ns at 500.0 "$node_(542) on" 
$node_(543) set X_ 148 
$node_(543) set Y_ 421 
$node_(543) set Z_ 0.0 
$ns at 0.0 "$node_(543) off" 
$ns at 500.0 "$node_(543) on" 
$node_(544) set X_ 270 
$node_(544) set Y_ 404 
$node_(544) set Z_ 0.0 
$ns at 0.0 "$node_(544) off" 
$ns at 500.0 "$node_(544) on" 
$node_(545) set X_ 2192 
$node_(545) set Y_ 780 
$node_(545) set Z_ 0.0 
$ns at 0.0 "$node_(545) off" 
$ns at 500.0 "$node_(545) on" 
$node_(546) set X_ 2783 
$node_(546) set Y_ 88 
$node_(546) set Z_ 0.0 
$ns at 0.0 "$node_(546) off" 
$ns at 500.0 "$node_(546) on" 
$node_(547) set X_ 132 
$node_(547) set Y_ 456 
$node_(547) set Z_ 0.0 
$ns at 0.0 "$node_(547) off" 
$ns at 500.0 "$node_(547) on" 
$node_(548) set X_ 47 
$node_(548) set Y_ 30 
$node_(548) set Z_ 0.0 
$ns at 0.0 "$node_(548) off" 
$ns at 500.0 "$node_(548) on" 
$node_(549) set X_ 1222 
$node_(549) set Y_ 9 
$node_(549) set Z_ 0.0 
$ns at 0.0 "$node_(549) off" 
$ns at 500.0 "$node_(549) on" 
$node_(550) set X_ 2002 
$node_(550) set Y_ 538 
$node_(550) set Z_ 0.0 
$ns at 0.0 "$node_(550) off" 
$ns at 500.0 "$node_(550) on" 
$node_(551) set X_ 1288 
$node_(551) set Y_ 94 
$node_(551) set Z_ 0.0 
$ns at 0.0 "$node_(551) off" 
$ns at 500.0 "$node_(551) on" 
$node_(552) set X_ 1269 
$node_(552) set Y_ 587 
$node_(552) set Z_ 0.0 
$ns at 0.0 "$node_(552) off" 
$ns at 500.0 "$node_(552) on" 
$node_(553) set X_ 472 
$node_(553) set Y_ 639 
$node_(553) set Z_ 0.0 
$ns at 0.0 "$node_(553) off" 
$ns at 500.0 "$node_(553) on" 
$node_(554) set X_ 859 
$node_(554) set Y_ 728 
$node_(554) set Z_ 0.0 
$ns at 0.0 "$node_(554) off" 
$ns at 500.0 "$node_(554) on" 
$node_(555) set X_ 1545 
$node_(555) set Y_ 279 
$node_(555) set Z_ 0.0 
$ns at 0.0 "$node_(555) off" 
$ns at 500.0 "$node_(555) on" 
$node_(556) set X_ 748 
$node_(556) set Y_ 798 
$node_(556) set Z_ 0.0 
$ns at 0.0 "$node_(556) off" 
$ns at 500.0 "$node_(556) on" 
$node_(557) set X_ 1157 
$node_(557) set Y_ 600 
$node_(557) set Z_ 0.0 
$ns at 0.0 "$node_(557) off" 
$ns at 500.0 "$node_(557) on" 
$node_(558) set X_ 2362 
$node_(558) set Y_ 203 
$node_(558) set Z_ 0.0 
$ns at 0.0 "$node_(558) off" 
$ns at 500.0 "$node_(558) on" 
$node_(559) set X_ 2879 
$node_(559) set Y_ 547 
$node_(559) set Z_ 0.0 
$ns at 0.0 "$node_(559) off" 
$ns at 500.0 "$node_(559) on" 
$node_(560) set X_ 646 
$node_(560) set Y_ 597 
$node_(560) set Z_ 0.0 
$ns at 0.0 "$node_(560) off" 
$ns at 500.0 "$node_(560) on" 
$node_(561) set X_ 1507 
$node_(561) set Y_ 765 
$node_(561) set Z_ 0.0 
$ns at 0.0 "$node_(561) off" 
$ns at 500.0 "$node_(561) on" 
$node_(562) set X_ 2817 
$node_(562) set Y_ 861 
$node_(562) set Z_ 0.0 
$ns at 0.0 "$node_(562) off" 
$ns at 500.0 "$node_(562) on" 
$node_(563) set X_ 1995 
$node_(563) set Y_ 745 
$node_(563) set Z_ 0.0 
$ns at 0.0 "$node_(563) off" 
$ns at 500.0 "$node_(563) on" 
$node_(564) set X_ 1978 
$node_(564) set Y_ 621 
$node_(564) set Z_ 0.0 
$ns at 0.0 "$node_(564) off" 
$ns at 500.0 "$node_(564) on" 
$node_(565) set X_ 2467 
$node_(565) set Y_ 391 
$node_(565) set Z_ 0.0 
$ns at 0.0 "$node_(565) off" 
$ns at 500.0 "$node_(565) on" 
$node_(566) set X_ 1621 
$node_(566) set Y_ 970 
$node_(566) set Z_ 0.0 
$ns at 0.0 "$node_(566) off" 
$ns at 500.0 "$node_(566) on" 
$node_(567) set X_ 2077 
$node_(567) set Y_ 27 
$node_(567) set Z_ 0.0 
$ns at 0.0 "$node_(567) off" 
$ns at 500.0 "$node_(567) on" 
$node_(568) set X_ 587 
$node_(568) set Y_ 670 
$node_(568) set Z_ 0.0 
$ns at 0.0 "$node_(568) off" 
$ns at 500.0 "$node_(568) on" 
$node_(569) set X_ 2007 
$node_(569) set Y_ 913 
$node_(569) set Z_ 0.0 
$ns at 0.0 "$node_(569) off" 
$ns at 500.0 "$node_(569) on" 
$node_(570) set X_ 295 
$node_(570) set Y_ 882 
$node_(570) set Z_ 0.0 
$ns at 0.0 "$node_(570) off" 
$ns at 500.0 "$node_(570) on" 
$node_(571) set X_ 2644 
$node_(571) set Y_ 85 
$node_(571) set Z_ 0.0 
$ns at 0.0 "$node_(571) off" 
$ns at 500.0 "$node_(571) on" 
$node_(572) set X_ 2073 
$node_(572) set Y_ 386 
$node_(572) set Z_ 0.0 
$ns at 0.0 "$node_(572) off" 
$ns at 500.0 "$node_(572) on" 
$node_(573) set X_ 2959 
$node_(573) set Y_ 658 
$node_(573) set Z_ 0.0 
$ns at 0.0 "$node_(573) off" 
$ns at 500.0 "$node_(573) on" 
$node_(574) set X_ 96 
$node_(574) set Y_ 315 
$node_(574) set Z_ 0.0 
$ns at 0.0 "$node_(574) off" 
$ns at 500.0 "$node_(574) on" 
$node_(575) set X_ 273 
$node_(575) set Y_ 811 
$node_(575) set Z_ 0.0 
$ns at 0.0 "$node_(575) off" 
$ns at 500.0 "$node_(575) on" 
$node_(576) set X_ 863 
$node_(576) set Y_ 686 
$node_(576) set Z_ 0.0 
$ns at 0.0 "$node_(576) off" 
$ns at 500.0 "$node_(576) on" 
$node_(577) set X_ 17 
$node_(577) set Y_ 322 
$node_(577) set Z_ 0.0 
$ns at 0.0 "$node_(577) off" 
$ns at 500.0 "$node_(577) on" 
$node_(578) set X_ 2300 
$node_(578) set Y_ 371 
$node_(578) set Z_ 0.0 
$ns at 0.0 "$node_(578) off" 
$ns at 500.0 "$node_(578) on" 
$node_(579) set X_ 727 
$node_(579) set Y_ 864 
$node_(579) set Z_ 0.0 
$ns at 0.0 "$node_(579) off" 
$ns at 500.0 "$node_(579) on" 
$node_(580) set X_ 1411 
$node_(580) set Y_ 711 
$node_(580) set Z_ 0.0 
$ns at 0.0 "$node_(580) off" 
$ns at 500.0 "$node_(580) on" 
$node_(581) set X_ 2314 
$node_(581) set Y_ 298 
$node_(581) set Z_ 0.0 
$ns at 0.0 "$node_(581) off" 
$ns at 500.0 "$node_(581) on" 
$node_(582) set X_ 994 
$node_(582) set Y_ 674 
$node_(582) set Z_ 0.0 
$ns at 0.0 "$node_(582) off" 
$ns at 500.0 "$node_(582) on" 
$node_(583) set X_ 1773 
$node_(583) set Y_ 825 
$node_(583) set Z_ 0.0 
$ns at 0.0 "$node_(583) off" 
$ns at 500.0 "$node_(583) on" 
$node_(584) set X_ 1233 
$node_(584) set Y_ 310 
$node_(584) set Z_ 0.0 
$ns at 0.0 "$node_(584) off" 
$ns at 500.0 "$node_(584) on" 
$node_(585) set X_ 1723 
$node_(585) set Y_ 165 
$node_(585) set Z_ 0.0 
$ns at 0.0 "$node_(585) off" 
$ns at 500.0 "$node_(585) on" 
$node_(586) set X_ 970 
$node_(586) set Y_ 270 
$node_(586) set Z_ 0.0 
$ns at 0.0 "$node_(586) off" 
$ns at 500.0 "$node_(586) on" 
$node_(587) set X_ 2693 
$node_(587) set Y_ 930 
$node_(587) set Z_ 0.0 
$ns at 0.0 "$node_(587) off" 
$ns at 500.0 "$node_(587) on" 
$node_(588) set X_ 242 
$node_(588) set Y_ 331 
$node_(588) set Z_ 0.0 
$ns at 0.0 "$node_(588) off" 
$ns at 500.0 "$node_(588) on" 
$node_(589) set X_ 1788 
$node_(589) set Y_ 943 
$node_(589) set Z_ 0.0 
$ns at 0.0 "$node_(589) off" 
$ns at 500.0 "$node_(589) on" 
$node_(590) set X_ 1053 
$node_(590) set Y_ 187 
$node_(590) set Z_ 0.0 
$ns at 0.0 "$node_(590) off" 
$ns at 500.0 "$node_(590) on" 
$node_(591) set X_ 1293 
$node_(591) set Y_ 553 
$node_(591) set Z_ 0.0 
$ns at 0.0 "$node_(591) off" 
$ns at 500.0 "$node_(591) on" 
$node_(592) set X_ 2596 
$node_(592) set Y_ 243 
$node_(592) set Z_ 0.0 
$ns at 0.0 "$node_(592) off" 
$ns at 500.0 "$node_(592) on" 
$node_(593) set X_ 936 
$node_(593) set Y_ 933 
$node_(593) set Z_ 0.0 
$ns at 0.0 "$node_(593) off" 
$ns at 500.0 "$node_(593) on" 
$node_(594) set X_ 962 
$node_(594) set Y_ 806 
$node_(594) set Z_ 0.0 
$ns at 0.0 "$node_(594) off" 
$ns at 500.0 "$node_(594) on" 
$node_(595) set X_ 2915 
$node_(595) set Y_ 920 
$node_(595) set Z_ 0.0 
$ns at 0.0 "$node_(595) off" 
$ns at 500.0 "$node_(595) on" 
$node_(596) set X_ 2031 
$node_(596) set Y_ 842 
$node_(596) set Z_ 0.0 
$ns at 0.0 "$node_(596) off" 
$ns at 500.0 "$node_(596) on" 
$node_(597) set X_ 1363 
$node_(597) set Y_ 230 
$node_(597) set Z_ 0.0 
$ns at 0.0 "$node_(597) off" 
$ns at 500.0 "$node_(597) on" 
$node_(598) set X_ 542 
$node_(598) set Y_ 422 
$node_(598) set Z_ 0.0 
$ns at 0.0 "$node_(598) off" 
$ns at 500.0 "$node_(598) on" 
$node_(599) set X_ 751 
$node_(599) set Y_ 755 
$node_(599) set Z_ 0.0 
$ns at 0.0 "$node_(599) off" 
$ns at 500.0 "$node_(599) on" 
$node_(600) set X_ 2386 
$node_(600) set Y_ 89 
$node_(600) set Z_ 0.0 
$ns at 0.0 "$node_(600) off" 
$ns at 600.0 "$node_(600) on" 
$node_(601) set X_ 1770 
$node_(601) set Y_ 237 
$node_(601) set Z_ 0.0 
$ns at 0.0 "$node_(601) off" 
$ns at 600.0 "$node_(601) on" 
$node_(602) set X_ 2949 
$node_(602) set Y_ 653 
$node_(602) set Z_ 0.0 
$ns at 0.0 "$node_(602) off" 
$ns at 600.0 "$node_(602) on" 
$node_(603) set X_ 1458 
$node_(603) set Y_ 807 
$node_(603) set Z_ 0.0 
$ns at 0.0 "$node_(603) off" 
$ns at 600.0 "$node_(603) on" 
$node_(604) set X_ 2787 
$node_(604) set Y_ 312 
$node_(604) set Z_ 0.0 
$ns at 0.0 "$node_(604) off" 
$ns at 600.0 "$node_(604) on" 
$node_(605) set X_ 1820 
$node_(605) set Y_ 763 
$node_(605) set Z_ 0.0 
$ns at 0.0 "$node_(605) off" 
$ns at 600.0 "$node_(605) on" 
$node_(606) set X_ 1141 
$node_(606) set Y_ 592 
$node_(606) set Z_ 0.0 
$ns at 0.0 "$node_(606) off" 
$ns at 600.0 "$node_(606) on" 
$node_(607) set X_ 2881 
$node_(607) set Y_ 480 
$node_(607) set Z_ 0.0 
$ns at 0.0 "$node_(607) off" 
$ns at 600.0 "$node_(607) on" 
$node_(608) set X_ 712 
$node_(608) set Y_ 334 
$node_(608) set Z_ 0.0 
$ns at 0.0 "$node_(608) off" 
$ns at 600.0 "$node_(608) on" 
$node_(609) set X_ 1996 
$node_(609) set Y_ 542 
$node_(609) set Z_ 0.0 
$ns at 0.0 "$node_(609) off" 
$ns at 600.0 "$node_(609) on" 
$node_(610) set X_ 2750 
$node_(610) set Y_ 829 
$node_(610) set Z_ 0.0 
$ns at 0.0 "$node_(610) off" 
$ns at 600.0 "$node_(610) on" 
$node_(611) set X_ 2395 
$node_(611) set Y_ 8 
$node_(611) set Z_ 0.0 
$ns at 0.0 "$node_(611) off" 
$ns at 600.0 "$node_(611) on" 
$node_(612) set X_ 887 
$node_(612) set Y_ 254 
$node_(612) set Z_ 0.0 
$ns at 0.0 "$node_(612) off" 
$ns at 600.0 "$node_(612) on" 
$node_(613) set X_ 1249 
$node_(613) set Y_ 245 
$node_(613) set Z_ 0.0 
$ns at 0.0 "$node_(613) off" 
$ns at 600.0 "$node_(613) on" 
$node_(614) set X_ 2190 
$node_(614) set Y_ 763 
$node_(614) set Z_ 0.0 
$ns at 0.0 "$node_(614) off" 
$ns at 600.0 "$node_(614) on" 
$node_(615) set X_ 1142 
$node_(615) set Y_ 889 
$node_(615) set Z_ 0.0 
$ns at 0.0 "$node_(615) off" 
$ns at 600.0 "$node_(615) on" 
$node_(616) set X_ 746 
$node_(616) set Y_ 939 
$node_(616) set Z_ 0.0 
$ns at 0.0 "$node_(616) off" 
$ns at 600.0 "$node_(616) on" 
$node_(617) set X_ 1583 
$node_(617) set Y_ 327 
$node_(617) set Z_ 0.0 
$ns at 0.0 "$node_(617) off" 
$ns at 600.0 "$node_(617) on" 
$node_(618) set X_ 1575 
$node_(618) set Y_ 830 
$node_(618) set Z_ 0.0 
$ns at 0.0 "$node_(618) off" 
$ns at 600.0 "$node_(618) on" 
$node_(619) set X_ 200 
$node_(619) set Y_ 539 
$node_(619) set Z_ 0.0 
$ns at 0.0 "$node_(619) off" 
$ns at 600.0 "$node_(619) on" 
$node_(620) set X_ 1904 
$node_(620) set Y_ 464 
$node_(620) set Z_ 0.0 
$ns at 0.0 "$node_(620) off" 
$ns at 600.0 "$node_(620) on" 
$node_(621) set X_ 2496 
$node_(621) set Y_ 284 
$node_(621) set Z_ 0.0 
$ns at 0.0 "$node_(621) off" 
$ns at 600.0 "$node_(621) on" 
$node_(622) set X_ 2806 
$node_(622) set Y_ 545 
$node_(622) set Z_ 0.0 
$ns at 0.0 "$node_(622) off" 
$ns at 600.0 "$node_(622) on" 
$node_(623) set X_ 449 
$node_(623) set Y_ 364 
$node_(623) set Z_ 0.0 
$ns at 0.0 "$node_(623) off" 
$ns at 600.0 "$node_(623) on" 
$node_(624) set X_ 1862 
$node_(624) set Y_ 45 
$node_(624) set Z_ 0.0 
$ns at 0.0 "$node_(624) off" 
$ns at 600.0 "$node_(624) on" 
$node_(625) set X_ 1916 
$node_(625) set Y_ 160 
$node_(625) set Z_ 0.0 
$ns at 0.0 "$node_(625) off" 
$ns at 600.0 "$node_(625) on" 
$node_(626) set X_ 1893 
$node_(626) set Y_ 509 
$node_(626) set Z_ 0.0 
$ns at 0.0 "$node_(626) off" 
$ns at 600.0 "$node_(626) on" 
$node_(627) set X_ 679 
$node_(627) set Y_ 716 
$node_(627) set Z_ 0.0 
$ns at 0.0 "$node_(627) off" 
$ns at 600.0 "$node_(627) on" 
$node_(628) set X_ 1923 
$node_(628) set Y_ 217 
$node_(628) set Z_ 0.0 
$ns at 0.0 "$node_(628) off" 
$ns at 600.0 "$node_(628) on" 
$node_(629) set X_ 38 
$node_(629) set Y_ 376 
$node_(629) set Z_ 0.0 
$ns at 0.0 "$node_(629) off" 
$ns at 600.0 "$node_(629) on" 
$node_(630) set X_ 2376 
$node_(630) set Y_ 770 
$node_(630) set Z_ 0.0 
$ns at 0.0 "$node_(630) off" 
$ns at 600.0 "$node_(630) on" 
$node_(631) set X_ 1199 
$node_(631) set Y_ 430 
$node_(631) set Z_ 0.0 
$ns at 0.0 "$node_(631) off" 
$ns at 600.0 "$node_(631) on" 
$node_(632) set X_ 2009 
$node_(632) set Y_ 290 
$node_(632) set Z_ 0.0 
$ns at 0.0 "$node_(632) off" 
$ns at 600.0 "$node_(632) on" 
$node_(633) set X_ 212 
$node_(633) set Y_ 218 
$node_(633) set Z_ 0.0 
$ns at 0.0 "$node_(633) off" 
$ns at 600.0 "$node_(633) on" 
$node_(634) set X_ 2418 
$node_(634) set Y_ 185 
$node_(634) set Z_ 0.0 
$ns at 0.0 "$node_(634) off" 
$ns at 600.0 "$node_(634) on" 
$node_(635) set X_ 2979 
$node_(635) set Y_ 914 
$node_(635) set Z_ 0.0 
$ns at 0.0 "$node_(635) off" 
$ns at 600.0 "$node_(635) on" 
$node_(636) set X_ 1862 
$node_(636) set Y_ 337 
$node_(636) set Z_ 0.0 
$ns at 0.0 "$node_(636) off" 
$ns at 600.0 "$node_(636) on" 
$node_(637) set X_ 1795 
$node_(637) set Y_ 568 
$node_(637) set Z_ 0.0 
$ns at 0.0 "$node_(637) off" 
$ns at 600.0 "$node_(637) on" 
$node_(638) set X_ 916 
$node_(638) set Y_ 669 
$node_(638) set Z_ 0.0 
$ns at 0.0 "$node_(638) off" 
$ns at 600.0 "$node_(638) on" 
$node_(639) set X_ 2118 
$node_(639) set Y_ 977 
$node_(639) set Z_ 0.0 
$ns at 0.0 "$node_(639) off" 
$ns at 600.0 "$node_(639) on" 
$node_(640) set X_ 1841 
$node_(640) set Y_ 248 
$node_(640) set Z_ 0.0 
$ns at 0.0 "$node_(640) off" 
$ns at 600.0 "$node_(640) on" 
$node_(641) set X_ 1603 
$node_(641) set Y_ 710 
$node_(641) set Z_ 0.0 
$ns at 0.0 "$node_(641) off" 
$ns at 600.0 "$node_(641) on" 
$node_(642) set X_ 2721 
$node_(642) set Y_ 496 
$node_(642) set Z_ 0.0 
$ns at 0.0 "$node_(642) off" 
$ns at 600.0 "$node_(642) on" 
$node_(643) set X_ 1138 
$node_(643) set Y_ 876 
$node_(643) set Z_ 0.0 
$ns at 0.0 "$node_(643) off" 
$ns at 600.0 "$node_(643) on" 
$node_(644) set X_ 275 
$node_(644) set Y_ 615 
$node_(644) set Z_ 0.0 
$ns at 0.0 "$node_(644) off" 
$ns at 600.0 "$node_(644) on" 
$node_(645) set X_ 377 
$node_(645) set Y_ 287 
$node_(645) set Z_ 0.0 
$ns at 0.0 "$node_(645) off" 
$ns at 600.0 "$node_(645) on" 
$node_(646) set X_ 806 
$node_(646) set Y_ 22 
$node_(646) set Z_ 0.0 
$ns at 0.0 "$node_(646) off" 
$ns at 600.0 "$node_(646) on" 
$node_(647) set X_ 2409 
$node_(647) set Y_ 273 
$node_(647) set Z_ 0.0 
$ns at 0.0 "$node_(647) off" 
$ns at 600.0 "$node_(647) on" 
$node_(648) set X_ 88 
$node_(648) set Y_ 464 
$node_(648) set Z_ 0.0 
$ns at 0.0 "$node_(648) off" 
$ns at 600.0 "$node_(648) on" 
$node_(649) set X_ 2414 
$node_(649) set Y_ 747 
$node_(649) set Z_ 0.0 
$ns at 0.0 "$node_(649) off" 
$ns at 600.0 "$node_(649) on" 
$node_(650) set X_ 963 
$node_(650) set Y_ 490 
$node_(650) set Z_ 0.0 
$ns at 0.0 "$node_(650) off" 
$ns at 600.0 "$node_(650) on" 
$node_(651) set X_ 708 
$node_(651) set Y_ 65 
$node_(651) set Z_ 0.0 
$ns at 0.0 "$node_(651) off" 
$ns at 600.0 "$node_(651) on" 
$node_(652) set X_ 2168 
$node_(652) set Y_ 106 
$node_(652) set Z_ 0.0 
$ns at 0.0 "$node_(652) off" 
$ns at 600.0 "$node_(652) on" 
$node_(653) set X_ 258 
$node_(653) set Y_ 858 
$node_(653) set Z_ 0.0 
$ns at 0.0 "$node_(653) off" 
$ns at 600.0 "$node_(653) on" 
$node_(654) set X_ 2391 
$node_(654) set Y_ 809 
$node_(654) set Z_ 0.0 
$ns at 0.0 "$node_(654) off" 
$ns at 600.0 "$node_(654) on" 
$node_(655) set X_ 1710 
$node_(655) set Y_ 291 
$node_(655) set Z_ 0.0 
$ns at 0.0 "$node_(655) off" 
$ns at 600.0 "$node_(655) on" 
$node_(656) set X_ 2678 
$node_(656) set Y_ 624 
$node_(656) set Z_ 0.0 
$ns at 0.0 "$node_(656) off" 
$ns at 600.0 "$node_(656) on" 
$node_(657) set X_ 117 
$node_(657) set Y_ 124 
$node_(657) set Z_ 0.0 
$ns at 0.0 "$node_(657) off" 
$ns at 600.0 "$node_(657) on" 
$node_(658) set X_ 1240 
$node_(658) set Y_ 448 
$node_(658) set Z_ 0.0 
$ns at 0.0 "$node_(658) off" 
$ns at 600.0 "$node_(658) on" 
$node_(659) set X_ 926 
$node_(659) set Y_ 576 
$node_(659) set Z_ 0.0 
$ns at 0.0 "$node_(659) off" 
$ns at 600.0 "$node_(659) on" 
$node_(660) set X_ 300 
$node_(660) set Y_ 777 
$node_(660) set Z_ 0.0 
$ns at 0.0 "$node_(660) off" 
$ns at 600.0 "$node_(660) on" 
$node_(661) set X_ 391 
$node_(661) set Y_ 186 
$node_(661) set Z_ 0.0 
$ns at 0.0 "$node_(661) off" 
$ns at 600.0 "$node_(661) on" 
$node_(662) set X_ 961 
$node_(662) set Y_ 844 
$node_(662) set Z_ 0.0 
$ns at 0.0 "$node_(662) off" 
$ns at 600.0 "$node_(662) on" 
$node_(663) set X_ 2365 
$node_(663) set Y_ 824 
$node_(663) set Z_ 0.0 
$ns at 0.0 "$node_(663) off" 
$ns at 600.0 "$node_(663) on" 
$node_(664) set X_ 2096 
$node_(664) set Y_ 319 
$node_(664) set Z_ 0.0 
$ns at 0.0 "$node_(664) off" 
$ns at 600.0 "$node_(664) on" 
$node_(665) set X_ 1479 
$node_(665) set Y_ 533 
$node_(665) set Z_ 0.0 
$ns at 0.0 "$node_(665) off" 
$ns at 600.0 "$node_(665) on" 
$node_(666) set X_ 2061 
$node_(666) set Y_ 958 
$node_(666) set Z_ 0.0 
$ns at 0.0 "$node_(666) off" 
$ns at 600.0 "$node_(666) on" 
$node_(667) set X_ 954 
$node_(667) set Y_ 96 
$node_(667) set Z_ 0.0 
$ns at 0.0 "$node_(667) off" 
$ns at 600.0 "$node_(667) on" 
$node_(668) set X_ 2481 
$node_(668) set Y_ 26 
$node_(668) set Z_ 0.0 
$ns at 0.0 "$node_(668) off" 
$ns at 600.0 "$node_(668) on" 
$node_(669) set X_ 2755 
$node_(669) set Y_ 118 
$node_(669) set Z_ 0.0 
$ns at 0.0 "$node_(669) off" 
$ns at 600.0 "$node_(669) on" 
$node_(670) set X_ 1589 
$node_(670) set Y_ 895 
$node_(670) set Z_ 0.0 
$ns at 0.0 "$node_(670) off" 
$ns at 600.0 "$node_(670) on" 
$node_(671) set X_ 493 
$node_(671) set Y_ 913 
$node_(671) set Z_ 0.0 
$ns at 0.0 "$node_(671) off" 
$ns at 600.0 "$node_(671) on" 
$node_(672) set X_ 498 
$node_(672) set Y_ 934 
$node_(672) set Z_ 0.0 
$ns at 0.0 "$node_(672) off" 
$ns at 600.0 "$node_(672) on" 
$node_(673) set X_ 379 
$node_(673) set Y_ 698 
$node_(673) set Z_ 0.0 
$ns at 0.0 "$node_(673) off" 
$ns at 600.0 "$node_(673) on" 
$node_(674) set X_ 443 
$node_(674) set Y_ 710 
$node_(674) set Z_ 0.0 
$ns at 0.0 "$node_(674) off" 
$ns at 600.0 "$node_(674) on" 
$node_(675) set X_ 1664 
$node_(675) set Y_ 410 
$node_(675) set Z_ 0.0 
$ns at 0.0 "$node_(675) off" 
$ns at 600.0 "$node_(675) on" 
$node_(676) set X_ 1372 
$node_(676) set Y_ 562 
$node_(676) set Z_ 0.0 
$ns at 0.0 "$node_(676) off" 
$ns at 600.0 "$node_(676) on" 
$node_(677) set X_ 330 
$node_(677) set Y_ 985 
$node_(677) set Z_ 0.0 
$ns at 0.0 "$node_(677) off" 
$ns at 600.0 "$node_(677) on" 
$node_(678) set X_ 2355 
$node_(678) set Y_ 800 
$node_(678) set Z_ 0.0 
$ns at 0.0 "$node_(678) off" 
$ns at 600.0 "$node_(678) on" 
$node_(679) set X_ 379 
$node_(679) set Y_ 67 
$node_(679) set Z_ 0.0 
$ns at 0.0 "$node_(679) off" 
$ns at 600.0 "$node_(679) on" 
$node_(680) set X_ 65 
$node_(680) set Y_ 146 
$node_(680) set Z_ 0.0 
$ns at 0.0 "$node_(680) off" 
$ns at 600.0 "$node_(680) on" 
$node_(681) set X_ 1823 
$node_(681) set Y_ 944 
$node_(681) set Z_ 0.0 
$ns at 0.0 "$node_(681) off" 
$ns at 600.0 "$node_(681) on" 
$node_(682) set X_ 1120 
$node_(682) set Y_ 545 
$node_(682) set Z_ 0.0 
$ns at 0.0 "$node_(682) off" 
$ns at 600.0 "$node_(682) on" 
$node_(683) set X_ 1495 
$node_(683) set Y_ 965 
$node_(683) set Z_ 0.0 
$ns at 0.0 "$node_(683) off" 
$ns at 600.0 "$node_(683) on" 
$node_(684) set X_ 2274 
$node_(684) set Y_ 144 
$node_(684) set Z_ 0.0 
$ns at 0.0 "$node_(684) off" 
$ns at 600.0 "$node_(684) on" 
$node_(685) set X_ 13 
$node_(685) set Y_ 813 
$node_(685) set Z_ 0.0 
$ns at 0.0 "$node_(685) off" 
$ns at 600.0 "$node_(685) on" 
$node_(686) set X_ 1431 
$node_(686) set Y_ 60 
$node_(686) set Z_ 0.0 
$ns at 0.0 "$node_(686) off" 
$ns at 600.0 "$node_(686) on" 
$node_(687) set X_ 2665 
$node_(687) set Y_ 784 
$node_(687) set Z_ 0.0 
$ns at 0.0 "$node_(687) off" 
$ns at 600.0 "$node_(687) on" 
$node_(688) set X_ 1111 
$node_(688) set Y_ 537 
$node_(688) set Z_ 0.0 
$ns at 0.0 "$node_(688) off" 
$ns at 600.0 "$node_(688) on" 
$node_(689) set X_ 632 
$node_(689) set Y_ 682 
$node_(689) set Z_ 0.0 
$ns at 0.0 "$node_(689) off" 
$ns at 600.0 "$node_(689) on" 
$node_(690) set X_ 2387 
$node_(690) set Y_ 235 
$node_(690) set Z_ 0.0 
$ns at 0.0 "$node_(690) off" 
$ns at 600.0 "$node_(690) on" 
$node_(691) set X_ 2862 
$node_(691) set Y_ 982 
$node_(691) set Z_ 0.0 
$ns at 0.0 "$node_(691) off" 
$ns at 600.0 "$node_(691) on" 
$node_(692) set X_ 2417 
$node_(692) set Y_ 692 
$node_(692) set Z_ 0.0 
$ns at 0.0 "$node_(692) off" 
$ns at 600.0 "$node_(692) on" 
$node_(693) set X_ 965 
$node_(693) set Y_ 714 
$node_(693) set Z_ 0.0 
$ns at 0.0 "$node_(693) off" 
$ns at 600.0 "$node_(693) on" 
$node_(694) set X_ 2540 
$node_(694) set Y_ 431 
$node_(694) set Z_ 0.0 
$ns at 0.0 "$node_(694) off" 
$ns at 600.0 "$node_(694) on" 
$node_(695) set X_ 850 
$node_(695) set Y_ 883 
$node_(695) set Z_ 0.0 
$ns at 0.0 "$node_(695) off" 
$ns at 600.0 "$node_(695) on" 
$node_(696) set X_ 425 
$node_(696) set Y_ 816 
$node_(696) set Z_ 0.0 
$ns at 0.0 "$node_(696) off" 
$ns at 600.0 "$node_(696) on" 
$node_(697) set X_ 320 
$node_(697) set Y_ 328 
$node_(697) set Z_ 0.0 
$ns at 0.0 "$node_(697) off" 
$ns at 600.0 "$node_(697) on" 
$node_(698) set X_ 2049 
$node_(698) set Y_ 500 
$node_(698) set Z_ 0.0 
$ns at 0.0 "$node_(698) off" 
$ns at 600.0 "$node_(698) on" 
$node_(699) set X_ 622 
$node_(699) set Y_ 615 
$node_(699) set Z_ 0.0 
$ns at 0.0 "$node_(699) off" 
$ns at 600.0 "$node_(699) on" 
$node_(700) set X_ 1245 
$node_(700) set Y_ 253 
$node_(700) set Z_ 0.0 
$ns at 0.0 "$node_(700) off" 
$ns at 700.0 "$node_(700) on" 
$node_(701) set X_ 1887 
$node_(701) set Y_ 950 
$node_(701) set Z_ 0.0 
$ns at 0.0 "$node_(701) off" 
$ns at 700.0 "$node_(701) on" 
$node_(702) set X_ 2289 
$node_(702) set Y_ 999 
$node_(702) set Z_ 0.0 
$ns at 0.0 "$node_(702) off" 
$ns at 700.0 "$node_(702) on" 
$node_(703) set X_ 2601 
$node_(703) set Y_ 118 
$node_(703) set Z_ 0.0 
$ns at 0.0 "$node_(703) off" 
$ns at 700.0 "$node_(703) on" 
$node_(704) set X_ 372 
$node_(704) set Y_ 162 
$node_(704) set Z_ 0.0 
$ns at 0.0 "$node_(704) off" 
$ns at 700.0 "$node_(704) on" 
$node_(705) set X_ 1651 
$node_(705) set Y_ 138 
$node_(705) set Z_ 0.0 
$ns at 0.0 "$node_(705) off" 
$ns at 700.0 "$node_(705) on" 
$node_(706) set X_ 1007 
$node_(706) set Y_ 768 
$node_(706) set Z_ 0.0 
$ns at 0.0 "$node_(706) off" 
$ns at 700.0 "$node_(706) on" 
$node_(707) set X_ 2104 
$node_(707) set Y_ 666 
$node_(707) set Z_ 0.0 
$ns at 0.0 "$node_(707) off" 
$ns at 700.0 "$node_(707) on" 
$node_(708) set X_ 1198 
$node_(708) set Y_ 334 
$node_(708) set Z_ 0.0 
$ns at 0.0 "$node_(708) off" 
$ns at 700.0 "$node_(708) on" 
$node_(709) set X_ 2739 
$node_(709) set Y_ 178 
$node_(709) set Z_ 0.0 
$ns at 0.0 "$node_(709) off" 
$ns at 700.0 "$node_(709) on" 
$node_(710) set X_ 2865 
$node_(710) set Y_ 242 
$node_(710) set Z_ 0.0 
$ns at 0.0 "$node_(710) off" 
$ns at 700.0 "$node_(710) on" 
$node_(711) set X_ 2375 
$node_(711) set Y_ 616 
$node_(711) set Z_ 0.0 
$ns at 0.0 "$node_(711) off" 
$ns at 700.0 "$node_(711) on" 
$node_(712) set X_ 230 
$node_(712) set Y_ 172 
$node_(712) set Z_ 0.0 
$ns at 0.0 "$node_(712) off" 
$ns at 700.0 "$node_(712) on" 
$node_(713) set X_ 1384 
$node_(713) set Y_ 482 
$node_(713) set Z_ 0.0 
$ns at 0.0 "$node_(713) off" 
$ns at 700.0 "$node_(713) on" 
$node_(714) set X_ 2952 
$node_(714) set Y_ 168 
$node_(714) set Z_ 0.0 
$ns at 0.0 "$node_(714) off" 
$ns at 700.0 "$node_(714) on" 
$node_(715) set X_ 2193 
$node_(715) set Y_ 349 
$node_(715) set Z_ 0.0 
$ns at 0.0 "$node_(715) off" 
$ns at 700.0 "$node_(715) on" 
$node_(716) set X_ 485 
$node_(716) set Y_ 100 
$node_(716) set Z_ 0.0 
$ns at 0.0 "$node_(716) off" 
$ns at 700.0 "$node_(716) on" 
$node_(717) set X_ 2381 
$node_(717) set Y_ 363 
$node_(717) set Z_ 0.0 
$ns at 0.0 "$node_(717) off" 
$ns at 700.0 "$node_(717) on" 
$node_(718) set X_ 614 
$node_(718) set Y_ 587 
$node_(718) set Z_ 0.0 
$ns at 0.0 "$node_(718) off" 
$ns at 700.0 "$node_(718) on" 
$node_(719) set X_ 2843 
$node_(719) set Y_ 594 
$node_(719) set Z_ 0.0 
$ns at 0.0 "$node_(719) off" 
$ns at 700.0 "$node_(719) on" 
$node_(720) set X_ 1278 
$node_(720) set Y_ 929 
$node_(720) set Z_ 0.0 
$ns at 0.0 "$node_(720) off" 
$ns at 700.0 "$node_(720) on" 
$node_(721) set X_ 2700 
$node_(721) set Y_ 30 
$node_(721) set Z_ 0.0 
$ns at 0.0 "$node_(721) off" 
$ns at 700.0 "$node_(721) on" 
$node_(722) set X_ 2689 
$node_(722) set Y_ 267 
$node_(722) set Z_ 0.0 
$ns at 0.0 "$node_(722) off" 
$ns at 700.0 "$node_(722) on" 
$node_(723) set X_ 1974 
$node_(723) set Y_ 604 
$node_(723) set Z_ 0.0 
$ns at 0.0 "$node_(723) off" 
$ns at 700.0 "$node_(723) on" 
$node_(724) set X_ 360 
$node_(724) set Y_ 933 
$node_(724) set Z_ 0.0 
$ns at 0.0 "$node_(724) off" 
$ns at 700.0 "$node_(724) on" 
$node_(725) set X_ 2660 
$node_(725) set Y_ 873 
$node_(725) set Z_ 0.0 
$ns at 0.0 "$node_(725) off" 
$ns at 700.0 "$node_(725) on" 
$node_(726) set X_ 2981 
$node_(726) set Y_ 944 
$node_(726) set Z_ 0.0 
$ns at 0.0 "$node_(726) off" 
$ns at 700.0 "$node_(726) on" 
$node_(727) set X_ 2625 
$node_(727) set Y_ 891 
$node_(727) set Z_ 0.0 
$ns at 0.0 "$node_(727) off" 
$ns at 700.0 "$node_(727) on" 
$node_(728) set X_ 131 
$node_(728) set Y_ 678 
$node_(728) set Z_ 0.0 
$ns at 0.0 "$node_(728) off" 
$ns at 700.0 "$node_(728) on" 
$node_(729) set X_ 2809 
$node_(729) set Y_ 377 
$node_(729) set Z_ 0.0 
$ns at 0.0 "$node_(729) off" 
$ns at 700.0 "$node_(729) on" 
$node_(730) set X_ 575 
$node_(730) set Y_ 40 
$node_(730) set Z_ 0.0 
$ns at 0.0 "$node_(730) off" 
$ns at 700.0 "$node_(730) on" 
$node_(731) set X_ 436 
$node_(731) set Y_ 465 
$node_(731) set Z_ 0.0 
$ns at 0.0 "$node_(731) off" 
$ns at 700.0 "$node_(731) on" 
$node_(732) set X_ 1387 
$node_(732) set Y_ 850 
$node_(732) set Z_ 0.0 
$ns at 0.0 "$node_(732) off" 
$ns at 700.0 "$node_(732) on" 
$node_(733) set X_ 2420 
$node_(733) set Y_ 247 
$node_(733) set Z_ 0.0 
$ns at 0.0 "$node_(733) off" 
$ns at 700.0 "$node_(733) on" 
$node_(734) set X_ 323 
$node_(734) set Y_ 741 
$node_(734) set Z_ 0.0 
$ns at 0.0 "$node_(734) off" 
$ns at 700.0 "$node_(734) on" 
$node_(735) set X_ 2839 
$node_(735) set Y_ 798 
$node_(735) set Z_ 0.0 
$ns at 0.0 "$node_(735) off" 
$ns at 700.0 "$node_(735) on" 
$node_(736) set X_ 1817 
$node_(736) set Y_ 619 
$node_(736) set Z_ 0.0 
$ns at 0.0 "$node_(736) off" 
$ns at 700.0 "$node_(736) on" 
$node_(737) set X_ 1248 
$node_(737) set Y_ 579 
$node_(737) set Z_ 0.0 
$ns at 0.0 "$node_(737) off" 
$ns at 700.0 "$node_(737) on" 
$node_(738) set X_ 2587 
$node_(738) set Y_ 583 
$node_(738) set Z_ 0.0 
$ns at 0.0 "$node_(738) off" 
$ns at 700.0 "$node_(738) on" 
$node_(739) set X_ 2734 
$node_(739) set Y_ 969 
$node_(739) set Z_ 0.0 
$ns at 0.0 "$node_(739) off" 
$ns at 700.0 "$node_(739) on" 
$node_(740) set X_ 2210 
$node_(740) set Y_ 295 
$node_(740) set Z_ 0.0 
$ns at 0.0 "$node_(740) off" 
$ns at 700.0 "$node_(740) on" 
$node_(741) set X_ 953 
$node_(741) set Y_ 142 
$node_(741) set Z_ 0.0 
$ns at 0.0 "$node_(741) off" 
$ns at 700.0 "$node_(741) on" 
$node_(742) set X_ 2098 
$node_(742) set Y_ 940 
$node_(742) set Z_ 0.0 
$ns at 0.0 "$node_(742) off" 
$ns at 700.0 "$node_(742) on" 
$node_(743) set X_ 951 
$node_(743) set Y_ 682 
$node_(743) set Z_ 0.0 
$ns at 0.0 "$node_(743) off" 
$ns at 700.0 "$node_(743) on" 
$node_(744) set X_ 103 
$node_(744) set Y_ 311 
$node_(744) set Z_ 0.0 
$ns at 0.0 "$node_(744) off" 
$ns at 700.0 "$node_(744) on" 
$node_(745) set X_ 352 
$node_(745) set Y_ 131 
$node_(745) set Z_ 0.0 
$ns at 0.0 "$node_(745) off" 
$ns at 700.0 "$node_(745) on" 
$node_(746) set X_ 1499 
$node_(746) set Y_ 59 
$node_(746) set Z_ 0.0 
$ns at 0.0 "$node_(746) off" 
$ns at 700.0 "$node_(746) on" 
$node_(747) set X_ 1505 
$node_(747) set Y_ 132 
$node_(747) set Z_ 0.0 
$ns at 0.0 "$node_(747) off" 
$ns at 700.0 "$node_(747) on" 
$node_(748) set X_ 2310 
$node_(748) set Y_ 785 
$node_(748) set Z_ 0.0 
$ns at 0.0 "$node_(748) off" 
$ns at 700.0 "$node_(748) on" 
$node_(749) set X_ 377 
$node_(749) set Y_ 948 
$node_(749) set Z_ 0.0 
$ns at 0.0 "$node_(749) off" 
$ns at 700.0 "$node_(749) on" 
$node_(750) set X_ 922 
$node_(750) set Y_ 538 
$node_(750) set Z_ 0.0 
$ns at 0.0 "$node_(750) off" 
$ns at 700.0 "$node_(750) on" 
$node_(751) set X_ 437 
$node_(751) set Y_ 919 
$node_(751) set Z_ 0.0 
$ns at 0.0 "$node_(751) off" 
$ns at 700.0 "$node_(751) on" 
$node_(752) set X_ 1569 
$node_(752) set Y_ 194 
$node_(752) set Z_ 0.0 
$ns at 0.0 "$node_(752) off" 
$ns at 700.0 "$node_(752) on" 
$node_(753) set X_ 2422 
$node_(753) set Y_ 857 
$node_(753) set Z_ 0.0 
$ns at 0.0 "$node_(753) off" 
$ns at 700.0 "$node_(753) on" 
$node_(754) set X_ 692 
$node_(754) set Y_ 386 
$node_(754) set Z_ 0.0 
$ns at 0.0 "$node_(754) off" 
$ns at 700.0 "$node_(754) on" 
$node_(755) set X_ 1753 
$node_(755) set Y_ 462 
$node_(755) set Z_ 0.0 
$ns at 0.0 "$node_(755) off" 
$ns at 700.0 "$node_(755) on" 
$node_(756) set X_ 1262 
$node_(756) set Y_ 922 
$node_(756) set Z_ 0.0 
$ns at 0.0 "$node_(756) off" 
$ns at 700.0 "$node_(756) on" 
$node_(757) set X_ 2455 
$node_(757) set Y_ 590 
$node_(757) set Z_ 0.0 
$ns at 0.0 "$node_(757) off" 
$ns at 700.0 "$node_(757) on" 
$node_(758) set X_ 993 
$node_(758) set Y_ 68 
$node_(758) set Z_ 0.0 
$ns at 0.0 "$node_(758) off" 
$ns at 700.0 "$node_(758) on" 
$node_(759) set X_ 1755 
$node_(759) set Y_ 626 
$node_(759) set Z_ 0.0 
$ns at 0.0 "$node_(759) off" 
$ns at 700.0 "$node_(759) on" 
$node_(760) set X_ 1922 
$node_(760) set Y_ 712 
$node_(760) set Z_ 0.0 
$ns at 0.0 "$node_(760) off" 
$ns at 700.0 "$node_(760) on" 
$node_(761) set X_ 2065 
$node_(761) set Y_ 235 
$node_(761) set Z_ 0.0 
$ns at 0.0 "$node_(761) off" 
$ns at 700.0 "$node_(761) on" 
$node_(762) set X_ 1081 
$node_(762) set Y_ 166 
$node_(762) set Z_ 0.0 
$ns at 0.0 "$node_(762) off" 
$ns at 700.0 "$node_(762) on" 
$node_(763) set X_ 780 
$node_(763) set Y_ 525 
$node_(763) set Z_ 0.0 
$ns at 0.0 "$node_(763) off" 
$ns at 700.0 "$node_(763) on" 
$node_(764) set X_ 1992 
$node_(764) set Y_ 270 
$node_(764) set Z_ 0.0 
$ns at 0.0 "$node_(764) off" 
$ns at 700.0 "$node_(764) on" 
$node_(765) set X_ 1340 
$node_(765) set Y_ 995 
$node_(765) set Z_ 0.0 
$ns at 0.0 "$node_(765) off" 
$ns at 700.0 "$node_(765) on" 
$node_(766) set X_ 1396 
$node_(766) set Y_ 574 
$node_(766) set Z_ 0.0 
$ns at 0.0 "$node_(766) off" 
$ns at 700.0 "$node_(766) on" 
$node_(767) set X_ 124 
$node_(767) set Y_ 688 
$node_(767) set Z_ 0.0 
$ns at 0.0 "$node_(767) off" 
$ns at 700.0 "$node_(767) on" 
$node_(768) set X_ 61 
$node_(768) set Y_ 568 
$node_(768) set Z_ 0.0 
$ns at 0.0 "$node_(768) off" 
$ns at 700.0 "$node_(768) on" 
$node_(769) set X_ 2223 
$node_(769) set Y_ 641 
$node_(769) set Z_ 0.0 
$ns at 0.0 "$node_(769) off" 
$ns at 700.0 "$node_(769) on" 
$node_(770) set X_ 655 
$node_(770) set Y_ 342 
$node_(770) set Z_ 0.0 
$ns at 0.0 "$node_(770) off" 
$ns at 700.0 "$node_(770) on" 
$node_(771) set X_ 2687 
$node_(771) set Y_ 71 
$node_(771) set Z_ 0.0 
$ns at 0.0 "$node_(771) off" 
$ns at 700.0 "$node_(771) on" 
$node_(772) set X_ 1522 
$node_(772) set Y_ 592 
$node_(772) set Z_ 0.0 
$ns at 0.0 "$node_(772) off" 
$ns at 700.0 "$node_(772) on" 
$node_(773) set X_ 761 
$node_(773) set Y_ 743 
$node_(773) set Z_ 0.0 
$ns at 0.0 "$node_(773) off" 
$ns at 700.0 "$node_(773) on" 
$node_(774) set X_ 1767 
$node_(774) set Y_ 587 
$node_(774) set Z_ 0.0 
$ns at 0.0 "$node_(774) off" 
$ns at 700.0 "$node_(774) on" 
$node_(775) set X_ 609 
$node_(775) set Y_ 595 
$node_(775) set Z_ 0.0 
$ns at 0.0 "$node_(775) off" 
$ns at 700.0 "$node_(775) on" 
$node_(776) set X_ 387 
$node_(776) set Y_ 574 
$node_(776) set Z_ 0.0 
$ns at 0.0 "$node_(776) off" 
$ns at 700.0 "$node_(776) on" 
$node_(777) set X_ 1385 
$node_(777) set Y_ 23 
$node_(777) set Z_ 0.0 
$ns at 0.0 "$node_(777) off" 
$ns at 700.0 "$node_(777) on" 
$node_(778) set X_ 2154 
$node_(778) set Y_ 106 
$node_(778) set Z_ 0.0 
$ns at 0.0 "$node_(778) off" 
$ns at 700.0 "$node_(778) on" 
$node_(779) set X_ 2925 
$node_(779) set Y_ 198 
$node_(779) set Z_ 0.0 
$ns at 0.0 "$node_(779) off" 
$ns at 700.0 "$node_(779) on" 
$node_(780) set X_ 716 
$node_(780) set Y_ 956 
$node_(780) set Z_ 0.0 
$ns at 0.0 "$node_(780) off" 
$ns at 700.0 "$node_(780) on" 
$node_(781) set X_ 136 
$node_(781) set Y_ 389 
$node_(781) set Z_ 0.0 
$ns at 0.0 "$node_(781) off" 
$ns at 700.0 "$node_(781) on" 
$node_(782) set X_ 1838 
$node_(782) set Y_ 582 
$node_(782) set Z_ 0.0 
$ns at 0.0 "$node_(782) off" 
$ns at 700.0 "$node_(782) on" 
$node_(783) set X_ 1020 
$node_(783) set Y_ 572 
$node_(783) set Z_ 0.0 
$ns at 0.0 "$node_(783) off" 
$ns at 700.0 "$node_(783) on" 
$node_(784) set X_ 1861 
$node_(784) set Y_ 628 
$node_(784) set Z_ 0.0 
$ns at 0.0 "$node_(784) off" 
$ns at 700.0 "$node_(784) on" 
$node_(785) set X_ 1482 
$node_(785) set Y_ 504 
$node_(785) set Z_ 0.0 
$ns at 0.0 "$node_(785) off" 
$ns at 700.0 "$node_(785) on" 
$node_(786) set X_ 352 
$node_(786) set Y_ 537 
$node_(786) set Z_ 0.0 
$ns at 0.0 "$node_(786) off" 
$ns at 700.0 "$node_(786) on" 
$node_(787) set X_ 1409 
$node_(787) set Y_ 76 
$node_(787) set Z_ 0.0 
$ns at 0.0 "$node_(787) off" 
$ns at 700.0 "$node_(787) on" 
$node_(788) set X_ 1524 
$node_(788) set Y_ 194 
$node_(788) set Z_ 0.0 
$ns at 0.0 "$node_(788) off" 
$ns at 700.0 "$node_(788) on" 
$node_(789) set X_ 2125 
$node_(789) set Y_ 961 
$node_(789) set Z_ 0.0 
$ns at 0.0 "$node_(789) off" 
$ns at 700.0 "$node_(789) on" 
$node_(790) set X_ 2348 
$node_(790) set Y_ 421 
$node_(790) set Z_ 0.0 
$ns at 0.0 "$node_(790) off" 
$ns at 700.0 "$node_(790) on" 
$node_(791) set X_ 1115 
$node_(791) set Y_ 511 
$node_(791) set Z_ 0.0 
$ns at 0.0 "$node_(791) off" 
$ns at 700.0 "$node_(791) on" 
$node_(792) set X_ 2301 
$node_(792) set Y_ 293 
$node_(792) set Z_ 0.0 
$ns at 0.0 "$node_(792) off" 
$ns at 700.0 "$node_(792) on" 
$node_(793) set X_ 1965 
$node_(793) set Y_ 399 
$node_(793) set Z_ 0.0 
$ns at 0.0 "$node_(793) off" 
$ns at 700.0 "$node_(793) on" 
$node_(794) set X_ 1469 
$node_(794) set Y_ 479 
$node_(794) set Z_ 0.0 
$ns at 0.0 "$node_(794) off" 
$ns at 700.0 "$node_(794) on" 
$node_(795) set X_ 688 
$node_(795) set Y_ 719 
$node_(795) set Z_ 0.0 
$ns at 0.0 "$node_(795) off" 
$ns at 700.0 "$node_(795) on" 
$node_(796) set X_ 2217 
$node_(796) set Y_ 239 
$node_(796) set Z_ 0.0 
$ns at 0.0 "$node_(796) off" 
$ns at 700.0 "$node_(796) on" 
$node_(797) set X_ 1107 
$node_(797) set Y_ 138 
$node_(797) set Z_ 0.0 
$ns at 0.0 "$node_(797) off" 
$ns at 700.0 "$node_(797) on" 
$node_(798) set X_ 2829 
$node_(798) set Y_ 295 
$node_(798) set Z_ 0.0 
$ns at 0.0 "$node_(798) off" 
$ns at 700.0 "$node_(798) on" 
$node_(799) set X_ 616 
$node_(799) set Y_ 213 
$node_(799) set Z_ 0.0 
$ns at 0.0 "$node_(799) off" 
$ns at 700.0 "$node_(799) on" 

# Generation of movements
$ns at 0.0 "$node_(0) setdest 45363 15898 17.0" 
$ns at 59.15581892673681 "$node_(0) setdest 38071 5010 18.0" 
$ns at 143.78348929041425 "$node_(0) setdest 35502 25611 14.0" 
$ns at 257.3056082206602 "$node_(0) setdest 41355 35154 17.0" 
$ns at 357.5632432375788 "$node_(0) setdest 75293 54625 8.0" 
$ns at 452.1343469850702 "$node_(0) setdest 62681 2813 16.0" 
$ns at 569.7465707535249 "$node_(0) setdest 104754 75197 18.0" 
$ns at 607.3746838540173 "$node_(0) setdest 199321 43449 15.0" 
$ns at 656.2647637604034 "$node_(0) setdest 145624 7224 6.0" 
$ns at 693.2049014930417 "$node_(0) setdest 20883 34996 11.0" 
$ns at 792.5046629373405 "$node_(0) setdest 2608 4314 13.0" 
$ns at 875.5677915025184 "$node_(0) setdest 8726 19002 1.0" 
$ns at 0.0 "$node_(1) setdest 24821 639 12.0" 
$ns at 85.08361724455159 "$node_(1) setdest 41918 7968 4.0" 
$ns at 121.77091930905374 "$node_(1) setdest 79338 13072 3.0" 
$ns at 173.79060804453476 "$node_(1) setdest 34772 31561 16.0" 
$ns at 305.84814938795773 "$node_(1) setdest 32034 44112 6.0" 
$ns at 360.13014580471383 "$node_(1) setdest 60795 46268 12.0" 
$ns at 478.7315345643067 "$node_(1) setdest 6950 44347 12.0" 
$ns at 535.1933685249321 "$node_(1) setdest 165247 69005 8.0" 
$ns at 571.2396887447906 "$node_(1) setdest 18699 49315 17.0" 
$ns at 738.0816921294488 "$node_(1) setdest 38078 7419 2.0" 
$ns at 777.3178265156432 "$node_(1) setdest 247668 40136 3.0" 
$ns at 836.0817867240021 "$node_(1) setdest 25389 13294 18.0" 
$ns at 880.462958296607 "$node_(1) setdest 153820 57366 4.0" 
$ns at 0.0 "$node_(2) setdest 25784 4506 7.0" 
$ns at 38.547223690154226 "$node_(2) setdest 74878 6552 3.0" 
$ns at 93.6167693796358 "$node_(2) setdest 88280 28261 3.0" 
$ns at 141.89661365939008 "$node_(2) setdest 35422 11703 16.0" 
$ns at 213.22226211997202 "$node_(2) setdest 6216 3776 13.0" 
$ns at 288.44531873461307 "$node_(2) setdest 154625 2002 18.0" 
$ns at 339.12028974649706 "$node_(2) setdest 24718 14568 9.0" 
$ns at 389.8862823553129 "$node_(2) setdest 170425 25353 16.0" 
$ns at 438.1460313970244 "$node_(2) setdest 38703 87 19.0" 
$ns at 532.8429344865478 "$node_(2) setdest 130568 33529 15.0" 
$ns at 591.9696041460949 "$node_(2) setdest 30549 41484 17.0" 
$ns at 717.3161841237976 "$node_(2) setdest 9206 46570 11.0" 
$ns at 765.9105107524059 "$node_(2) setdest 235281 56974 5.0" 
$ns at 828.5928091226014 "$node_(2) setdest 56564 82485 8.0" 
$ns at 861.6397356703346 "$node_(2) setdest 25738 45220 8.0" 
$ns at 892.3359145523298 "$node_(2) setdest 130298 21100 16.0" 
$ns at 0.0 "$node_(3) setdest 80438 28188 18.0" 
$ns at 124.20262385653378 "$node_(3) setdest 33256 14942 1.0" 
$ns at 162.0661881019052 "$node_(3) setdest 120693 36606 17.0" 
$ns at 246.22774278036414 "$node_(3) setdest 22549 15959 12.0" 
$ns at 281.92703015788965 "$node_(3) setdest 83071 30621 7.0" 
$ns at 329.36730514513346 "$node_(3) setdest 46150 32578 9.0" 
$ns at 362.82090410407716 "$node_(3) setdest 147485 47496 17.0" 
$ns at 463.22662142084897 "$node_(3) setdest 49615 29313 1.0" 
$ns at 500.93432922875377 "$node_(3) setdest 1090 56938 6.0" 
$ns at 538.4839710813695 "$node_(3) setdest 21047 13295 15.0" 
$ns at 615.4720339900654 "$node_(3) setdest 126759 77168 11.0" 
$ns at 650.1922372683101 "$node_(3) setdest 35622 12671 18.0" 
$ns at 687.0013112456095 "$node_(3) setdest 34504 73637 17.0" 
$ns at 789.4217647318726 "$node_(3) setdest 84641 44284 6.0" 
$ns at 830.5661242640083 "$node_(3) setdest 204377 83690 2.0" 
$ns at 875.0027608533089 "$node_(3) setdest 87100 30534 3.0" 
$ns at 0.0 "$node_(4) setdest 38369 18089 3.0" 
$ns at 58.004092235049825 "$node_(4) setdest 23208 12047 8.0" 
$ns at 135.83392414395385 "$node_(4) setdest 32369 28401 20.0" 
$ns at 262.538776722155 "$node_(4) setdest 153540 10217 17.0" 
$ns at 401.63677374930023 "$node_(4) setdest 152111 56802 4.0" 
$ns at 452.73063289247335 "$node_(4) setdest 155329 33492 19.0" 
$ns at 643.5572489415185 "$node_(4) setdest 30402 70291 16.0" 
$ns at 821.28218541397 "$node_(4) setdest 46261 74059 12.0" 
$ns at 0.0 "$node_(5) setdest 76669 16886 19.0" 
$ns at 90.22810160525364 "$node_(5) setdest 67449 21158 16.0" 
$ns at 239.6339631595526 "$node_(5) setdest 126028 18728 13.0" 
$ns at 275.7290829658059 "$node_(5) setdest 114816 25706 2.0" 
$ns at 319.5719781793597 "$node_(5) setdest 13622 26355 13.0" 
$ns at 457.17246358161213 "$node_(5) setdest 19101 35261 6.0" 
$ns at 515.3232855998913 "$node_(5) setdest 111452 38363 14.0" 
$ns at 604.0117801188744 "$node_(5) setdest 145314 47527 14.0" 
$ns at 650.6029406602689 "$node_(5) setdest 92534 39587 8.0" 
$ns at 739.5773100513542 "$node_(5) setdest 119506 72002 7.0" 
$ns at 808.6912160161735 "$node_(5) setdest 11273 23001 15.0" 
$ns at 855.7241137034787 "$node_(5) setdest 158408 81710 5.0" 
$ns at 0.0 "$node_(6) setdest 9749 19590 7.0" 
$ns at 76.39859343645671 "$node_(6) setdest 21491 19420 18.0" 
$ns at 218.1946015966203 "$node_(6) setdest 58845 4915 1.0" 
$ns at 257.8131620160225 "$node_(6) setdest 68189 7410 1.0" 
$ns at 290.1394817275133 "$node_(6) setdest 38579 43175 10.0" 
$ns at 370.1184025623765 "$node_(6) setdest 63448 33978 16.0" 
$ns at 430.667789529982 "$node_(6) setdest 60642 57293 10.0" 
$ns at 521.2253795164979 "$node_(6) setdest 178626 51972 18.0" 
$ns at 679.2880610441882 "$node_(6) setdest 188605 18990 8.0" 
$ns at 774.0645321974771 "$node_(6) setdest 173302 13212 14.0" 
$ns at 842.4258512194938 "$node_(6) setdest 204028 79207 17.0" 
$ns at 0.0 "$node_(7) setdest 81276 17359 4.0" 
$ns at 66.59598069585368 "$node_(7) setdest 38735 29138 17.0" 
$ns at 225.8659480557011 "$node_(7) setdest 121989 39677 3.0" 
$ns at 257.8116221035482 "$node_(7) setdest 95299 48768 16.0" 
$ns at 416.43255763223385 "$node_(7) setdest 16940 6135 15.0" 
$ns at 486.1311047910625 "$node_(7) setdest 35827 13653 13.0" 
$ns at 531.2465150650149 "$node_(7) setdest 33181 11945 4.0" 
$ns at 574.8686796014625 "$node_(7) setdest 132722 1298 1.0" 
$ns at 608.4529572696958 "$node_(7) setdest 185873 77405 13.0" 
$ns at 751.747888161251 "$node_(7) setdest 228175 3112 5.0" 
$ns at 820.7161041883993 "$node_(7) setdest 245771 70503 1.0" 
$ns at 851.0182625140077 "$node_(7) setdest 50227 23103 18.0" 
$ns at 0.0 "$node_(8) setdest 89678 190 8.0" 
$ns at 40.41097696501546 "$node_(8) setdest 45209 21646 17.0" 
$ns at 135.25283245417808 "$node_(8) setdest 71957 6229 12.0" 
$ns at 220.4831346166821 "$node_(8) setdest 24942 28456 1.0" 
$ns at 255.0437346974262 "$node_(8) setdest 136035 7711 14.0" 
$ns at 318.6273968352163 "$node_(8) setdest 137683 51351 11.0" 
$ns at 395.55040542878703 "$node_(8) setdest 127924 8889 19.0" 
$ns at 572.8814829977312 "$node_(8) setdest 169777 24682 19.0" 
$ns at 772.3066685874958 "$node_(8) setdest 221726 40878 1.0" 
$ns at 803.8176215443252 "$node_(8) setdest 203538 62342 2.0" 
$ns at 843.514461789521 "$node_(8) setdest 209837 14205 15.0" 
$ns at 878.8671032116038 "$node_(8) setdest 120235 20283 4.0" 
$ns at 0.0 "$node_(9) setdest 67221 28709 5.0" 
$ns at 51.86991206346229 "$node_(9) setdest 54091 8300 11.0" 
$ns at 184.87972655293396 "$node_(9) setdest 116866 20118 4.0" 
$ns at 234.43044329893274 "$node_(9) setdest 126616 28224 17.0" 
$ns at 433.3951511017545 "$node_(9) setdest 5085 52436 7.0" 
$ns at 504.9533599707933 "$node_(9) setdest 62211 60605 12.0" 
$ns at 626.9810657518115 "$node_(9) setdest 63716 46261 11.0" 
$ns at 714.0283757623347 "$node_(9) setdest 68660 19639 7.0" 
$ns at 782.7973833017986 "$node_(9) setdest 25303 47904 3.0" 
$ns at 820.5949893043895 "$node_(9) setdest 6729 79852 10.0" 
$ns at 0.0 "$node_(10) setdest 54394 20885 15.0" 
$ns at 145.4277312428635 "$node_(10) setdest 82844 7756 6.0" 
$ns at 212.17783136125874 "$node_(10) setdest 5976 23741 16.0" 
$ns at 381.4850120443871 "$node_(10) setdest 6601 29967 8.0" 
$ns at 464.1667042524759 "$node_(10) setdest 135175 9103 12.0" 
$ns at 607.7003399463724 "$node_(10) setdest 103287 72434 10.0" 
$ns at 697.8352424324888 "$node_(10) setdest 118507 69452 6.0" 
$ns at 741.6644281753278 "$node_(10) setdest 16487 53446 10.0" 
$ns at 830.028479211948 "$node_(10) setdest 131637 21297 8.0" 
$ns at 0.0 "$node_(11) setdest 28259 6006 9.0" 
$ns at 105.01774619887736 "$node_(11) setdest 14795 28339 9.0" 
$ns at 181.36946918240164 "$node_(11) setdest 46193 37592 18.0" 
$ns at 312.3660754615174 "$node_(11) setdest 84792 8306 16.0" 
$ns at 458.64065901879866 "$node_(11) setdest 138600 38564 13.0" 
$ns at 549.086025144203 "$node_(11) setdest 77242 48733 14.0" 
$ns at 606.7960016812405 "$node_(11) setdest 185131 12772 9.0" 
$ns at 664.3519872331906 "$node_(11) setdest 122359 42100 7.0" 
$ns at 743.5027990193703 "$node_(11) setdest 99733 17759 2.0" 
$ns at 778.6270557097474 "$node_(11) setdest 64726 29454 8.0" 
$ns at 840.9132437013012 "$node_(11) setdest 260699 70376 19.0" 
$ns at 0.0 "$node_(12) setdest 88787 25428 16.0" 
$ns at 138.24440816487487 "$node_(12) setdest 75605 18650 9.0" 
$ns at 225.40654934863625 "$node_(12) setdest 104297 39027 17.0" 
$ns at 286.94234519112456 "$node_(12) setdest 28059 9093 17.0" 
$ns at 371.61622538672367 "$node_(12) setdest 65808 13509 16.0" 
$ns at 450.8625834026317 "$node_(12) setdest 142421 54248 19.0" 
$ns at 587.3233712882861 "$node_(12) setdest 199728 54284 18.0" 
$ns at 658.8455702068837 "$node_(12) setdest 71875 40141 15.0" 
$ns at 821.7649468017897 "$node_(12) setdest 185208 15386 19.0" 
$ns at 0.0 "$node_(13) setdest 49348 16243 4.0" 
$ns at 57.412118024305016 "$node_(13) setdest 85798 730 7.0" 
$ns at 121.6794698222379 "$node_(13) setdest 80176 25129 12.0" 
$ns at 242.88562948021888 "$node_(13) setdest 104925 17788 2.0" 
$ns at 292.09759721118184 "$node_(13) setdest 17846 14050 8.0" 
$ns at 347.98246356079267 "$node_(13) setdest 94335 54374 15.0" 
$ns at 412.75010843254285 "$node_(13) setdest 144181 30122 15.0" 
$ns at 500.1306407598613 "$node_(13) setdest 207502 52829 5.0" 
$ns at 547.7762785221915 "$node_(13) setdest 2137 38727 2.0" 
$ns at 592.062078306194 "$node_(13) setdest 16994 72501 2.0" 
$ns at 622.6226020819038 "$node_(13) setdest 66907 26137 19.0" 
$ns at 822.7479279361786 "$node_(13) setdest 187826 39149 15.0" 
$ns at 0.0 "$node_(14) setdest 57442 16392 8.0" 
$ns at 37.117212885404314 "$node_(14) setdest 50066 6147 16.0" 
$ns at 92.25534003104919 "$node_(14) setdest 66060 774 15.0" 
$ns at 204.38655369682922 "$node_(14) setdest 39226 6035 19.0" 
$ns at 343.5994396564612 "$node_(14) setdest 6539 45029 16.0" 
$ns at 379.7881585998277 "$node_(14) setdest 179738 5099 19.0" 
$ns at 588.258758360766 "$node_(14) setdest 31288 10996 17.0" 
$ns at 728.7952336272976 "$node_(14) setdest 179085 33635 1.0" 
$ns at 767.0012509377625 "$node_(14) setdest 170480 50642 7.0" 
$ns at 844.7598635574477 "$node_(14) setdest 71819 40031 11.0" 
$ns at 0.0 "$node_(15) setdest 20318 19468 7.0" 
$ns at 70.81014611953657 "$node_(15) setdest 52808 408 14.0" 
$ns at 209.84315865385685 "$node_(15) setdest 35219 32694 18.0" 
$ns at 264.1791040648442 "$node_(15) setdest 160456 20288 13.0" 
$ns at 350.1709669982271 "$node_(15) setdest 150769 50191 12.0" 
$ns at 422.2461852876945 "$node_(15) setdest 171567 39773 13.0" 
$ns at 480.17702549091183 "$node_(15) setdest 35461 40890 16.0" 
$ns at 634.8621991598695 "$node_(15) setdest 190748 34263 7.0" 
$ns at 731.146093702794 "$node_(15) setdest 119892 65748 17.0" 
$ns at 793.5349417686367 "$node_(15) setdest 137832 30246 19.0" 
$ns at 844.611141401359 "$node_(15) setdest 202675 48898 8.0" 
$ns at 0.0 "$node_(16) setdest 9149 5798 2.0" 
$ns at 47.5415034660287 "$node_(16) setdest 29168 17143 10.0" 
$ns at 150.66052504244766 "$node_(16) setdest 112073 24999 13.0" 
$ns at 259.00566713999467 "$node_(16) setdest 137153 7494 17.0" 
$ns at 411.96712607082685 "$node_(16) setdest 3658 3944 14.0" 
$ns at 462.73097797032716 "$node_(16) setdest 37834 11866 15.0" 
$ns at 522.9310773244465 "$node_(16) setdest 76935 56980 11.0" 
$ns at 618.0015958015158 "$node_(16) setdest 188996 21966 10.0" 
$ns at 723.6582310082475 "$node_(16) setdest 170459 52931 7.0" 
$ns at 765.5256311093622 "$node_(16) setdest 120605 87525 2.0" 
$ns at 799.3212387055876 "$node_(16) setdest 218447 73236 15.0" 
$ns at 0.0 "$node_(17) setdest 33703 22683 1.0" 
$ns at 35.92467087456504 "$node_(17) setdest 7121 8869 13.0" 
$ns at 149.7828290790654 "$node_(17) setdest 25277 25066 9.0" 
$ns at 220.83877516581032 "$node_(17) setdest 86827 24899 8.0" 
$ns at 322.9645155413829 "$node_(17) setdest 163225 44524 8.0" 
$ns at 354.32760863385755 "$node_(17) setdest 139088 5511 19.0" 
$ns at 443.99720331197705 "$node_(17) setdest 17099 60843 5.0" 
$ns at 488.6209219489611 "$node_(17) setdest 85838 39118 15.0" 
$ns at 642.8565160031059 "$node_(17) setdest 46206 33124 9.0" 
$ns at 719.400038782287 "$node_(17) setdest 101810 25449 14.0" 
$ns at 765.5936330462617 "$node_(17) setdest 250158 57377 5.0" 
$ns at 842.3529337360761 "$node_(17) setdest 105347 12142 16.0" 
$ns at 0.0 "$node_(18) setdest 38723 7169 17.0" 
$ns at 56.46204883118679 "$node_(18) setdest 33528 29785 1.0" 
$ns at 89.26284730448137 "$node_(18) setdest 75750 25179 1.0" 
$ns at 124.54718257729853 "$node_(18) setdest 18087 278 4.0" 
$ns at 164.25239955493169 "$node_(18) setdest 68004 44611 7.0" 
$ns at 211.56650700353055 "$node_(18) setdest 95116 43430 13.0" 
$ns at 351.441681149022 "$node_(18) setdest 158960 28301 5.0" 
$ns at 388.3301828062626 "$node_(18) setdest 93745 44236 13.0" 
$ns at 483.6873901488794 "$node_(18) setdest 57327 31973 5.0" 
$ns at 530.4685010405435 "$node_(18) setdest 89579 45152 6.0" 
$ns at 566.4205420238808 "$node_(18) setdest 162593 50856 1.0" 
$ns at 599.568404329484 "$node_(18) setdest 183132 28408 10.0" 
$ns at 667.1750832716059 "$node_(18) setdest 65589 1488 9.0" 
$ns at 784.4788626226057 "$node_(18) setdest 77483 35305 3.0" 
$ns at 827.945561389851 "$node_(18) setdest 160435 66839 6.0" 
$ns at 0.0 "$node_(19) setdest 33586 14998 1.0" 
$ns at 30.33444782902546 "$node_(19) setdest 65051 3664 18.0" 
$ns at 201.55598958777156 "$node_(19) setdest 74971 41861 13.0" 
$ns at 259.343045874792 "$node_(19) setdest 95526 14597 1.0" 
$ns at 291.8581537297729 "$node_(19) setdest 17708 45235 18.0" 
$ns at 471.9605110883292 "$node_(19) setdest 149238 30356 18.0" 
$ns at 569.7518647280614 "$node_(19) setdest 146327 66577 19.0" 
$ns at 760.459738362744 "$node_(19) setdest 137394 16370 2.0" 
$ns at 797.1992753687291 "$node_(19) setdest 206594 41565 2.0" 
$ns at 831.0971050211892 "$node_(19) setdest 187385 58854 9.0" 
$ns at 0.0 "$node_(20) setdest 30302 13628 8.0" 
$ns at 36.035121388828216 "$node_(20) setdest 23721 26080 17.0" 
$ns at 172.5092055018074 "$node_(20) setdest 116489 41844 4.0" 
$ns at 228.04321503667316 "$node_(20) setdest 430 11745 10.0" 
$ns at 356.06479064211567 "$node_(20) setdest 42217 61140 19.0" 
$ns at 477.7482005095706 "$node_(20) setdest 115719 3818 13.0" 
$ns at 617.9546992937398 "$node_(20) setdest 16734 31834 3.0" 
$ns at 663.3306373132639 "$node_(20) setdest 146473 58293 13.0" 
$ns at 709.7670943599605 "$node_(20) setdest 162645 27452 17.0" 
$ns at 0.0 "$node_(21) setdest 13062 5741 2.0" 
$ns at 33.3906967904821 "$node_(21) setdest 33998 5666 6.0" 
$ns at 116.76773387899428 "$node_(21) setdest 16830 19830 2.0" 
$ns at 160.4302048724074 "$node_(21) setdest 85768 1333 18.0" 
$ns at 335.62631118997285 "$node_(21) setdest 92180 6482 20.0" 
$ns at 489.65308410083753 "$node_(21) setdest 108380 70517 19.0" 
$ns at 546.0850115157982 "$node_(21) setdest 83215 45420 9.0" 
$ns at 601.1309900441319 "$node_(21) setdest 133878 35708 16.0" 
$ns at 668.8727916070948 "$node_(21) setdest 39676 22248 18.0" 
$ns at 709.4902073177979 "$node_(21) setdest 112948 67450 5.0" 
$ns at 773.3418663495322 "$node_(21) setdest 69608 84969 19.0" 
$ns at 0.0 "$node_(22) setdest 81455 22768 19.0" 
$ns at 218.18894883647198 "$node_(22) setdest 107328 28842 1.0" 
$ns at 250.17076465672258 "$node_(22) setdest 147127 16959 9.0" 
$ns at 315.3459939336275 "$node_(22) setdest 122396 30756 1.0" 
$ns at 353.86338952013347 "$node_(22) setdest 32865 35563 8.0" 
$ns at 413.680927827313 "$node_(22) setdest 154304 48196 3.0" 
$ns at 448.9272230115936 "$node_(22) setdest 163308 57939 10.0" 
$ns at 502.9457270655173 "$node_(22) setdest 152250 32950 17.0" 
$ns at 549.2780255938544 "$node_(22) setdest 178362 67999 4.0" 
$ns at 615.4660842899013 "$node_(22) setdest 142723 55386 18.0" 
$ns at 676.8739266075003 "$node_(22) setdest 120490 45522 6.0" 
$ns at 738.881418785867 "$node_(22) setdest 219668 24404 12.0" 
$ns at 862.7662750380464 "$node_(22) setdest 200376 70171 7.0" 
$ns at 0.0 "$node_(23) setdest 52176 1145 8.0" 
$ns at 78.37418439189834 "$node_(23) setdest 63232 25012 3.0" 
$ns at 119.77568227926055 "$node_(23) setdest 11853 30241 4.0" 
$ns at 156.29098448859543 "$node_(23) setdest 47368 3485 4.0" 
$ns at 199.97171944354076 "$node_(23) setdest 59978 34618 3.0" 
$ns at 239.57505200750342 "$node_(23) setdest 13815 43135 8.0" 
$ns at 335.05138690793126 "$node_(23) setdest 151888 44099 16.0" 
$ns at 520.9740561527244 "$node_(23) setdest 62044 33259 9.0" 
$ns at 639.7360387334769 "$node_(23) setdest 85102 24282 20.0" 
$ns at 749.3369885780301 "$node_(23) setdest 16204 40038 20.0" 
$ns at 803.3625253927539 "$node_(23) setdest 20608 66001 6.0" 
$ns at 889.000979054758 "$node_(23) setdest 11992 16652 5.0" 
$ns at 0.0 "$node_(24) setdest 6179 13710 13.0" 
$ns at 155.37809384172806 "$node_(24) setdest 76942 4956 17.0" 
$ns at 316.1310136734148 "$node_(24) setdest 79682 45101 1.0" 
$ns at 351.0671627413806 "$node_(24) setdest 36914 10954 2.0" 
$ns at 396.47572748151117 "$node_(24) setdest 126651 6611 6.0" 
$ns at 460.7660267768264 "$node_(24) setdest 81830 44214 4.0" 
$ns at 515.4689720536976 "$node_(24) setdest 76594 63848 2.0" 
$ns at 555.4314368309692 "$node_(24) setdest 179465 65340 10.0" 
$ns at 651.2636080953437 "$node_(24) setdest 9934 43714 10.0" 
$ns at 743.7748517755764 "$node_(24) setdest 77765 21478 15.0" 
$ns at 881.2923070292131 "$node_(24) setdest 105889 60957 8.0" 
$ns at 0.0 "$node_(25) setdest 16678 29338 2.0" 
$ns at 40.23657384557436 "$node_(25) setdest 35429 27903 7.0" 
$ns at 95.69814041544055 "$node_(25) setdest 33918 17686 14.0" 
$ns at 171.1045435201572 "$node_(25) setdest 50509 36127 18.0" 
$ns at 206.06374865949124 "$node_(25) setdest 23472 42143 12.0" 
$ns at 265.49715947837194 "$node_(25) setdest 78473 21332 20.0" 
$ns at 473.062889003898 "$node_(25) setdest 48108 8339 18.0" 
$ns at 608.6844632128025 "$node_(25) setdest 181353 34245 10.0" 
$ns at 687.1212476653778 "$node_(25) setdest 124970 64461 2.0" 
$ns at 722.8822909582424 "$node_(25) setdest 68815 756 9.0" 
$ns at 819.4871126417493 "$node_(25) setdest 165429 55756 11.0" 
$ns at 893.2963824738895 "$node_(25) setdest 215114 72677 12.0" 
$ns at 0.0 "$node_(26) setdest 47382 27063 8.0" 
$ns at 107.48199556482805 "$node_(26) setdest 357 14365 8.0" 
$ns at 180.386228829106 "$node_(26) setdest 117191 36230 2.0" 
$ns at 229.0816401869779 "$node_(26) setdest 47281 11620 19.0" 
$ns at 282.63557450782054 "$node_(26) setdest 67617 27935 15.0" 
$ns at 436.20383555043827 "$node_(26) setdest 120806 57711 12.0" 
$ns at 483.90233899022877 "$node_(26) setdest 99968 53604 15.0" 
$ns at 568.546793776708 "$node_(26) setdest 119497 20914 2.0" 
$ns at 617.3998829561459 "$node_(26) setdest 156956 64543 2.0" 
$ns at 654.1029832611936 "$node_(26) setdest 248919 808 7.0" 
$ns at 749.3508349955218 "$node_(26) setdest 206083 4767 6.0" 
$ns at 793.3146834453232 "$node_(26) setdest 254324 89049 8.0" 
$ns at 868.2091113575784 "$node_(26) setdest 229838 66896 10.0" 
$ns at 0.0 "$node_(27) setdest 5836 16229 7.0" 
$ns at 66.37418117034122 "$node_(27) setdest 86790 10582 3.0" 
$ns at 97.14002065033188 "$node_(27) setdest 72050 24196 14.0" 
$ns at 261.0424824269762 "$node_(27) setdest 105268 35377 7.0" 
$ns at 316.6656242982645 "$node_(27) setdest 7458 14959 17.0" 
$ns at 456.2451515340988 "$node_(27) setdest 63697 45824 3.0" 
$ns at 498.40013575761384 "$node_(27) setdest 68911 5710 1.0" 
$ns at 531.4281392792072 "$node_(27) setdest 87482 10530 7.0" 
$ns at 571.9121638315307 "$node_(27) setdest 136847 69802 17.0" 
$ns at 692.270688337138 "$node_(27) setdest 222812 19913 11.0" 
$ns at 790.9531684061727 "$node_(27) setdest 152820 54048 7.0" 
$ns at 825.8425457571761 "$node_(27) setdest 245806 43131 18.0" 
$ns at 0.0 "$node_(28) setdest 69303 21776 14.0" 
$ns at 76.29617082851695 "$node_(28) setdest 8473 4646 3.0" 
$ns at 124.75251438551717 "$node_(28) setdest 19615 19967 13.0" 
$ns at 209.4879850459077 "$node_(28) setdest 66811 43002 4.0" 
$ns at 269.9883933180665 "$node_(28) setdest 9105 14364 4.0" 
$ns at 304.1691514109987 "$node_(28) setdest 129843 10947 8.0" 
$ns at 354.46904685990756 "$node_(28) setdest 82006 35062 8.0" 
$ns at 417.51323786137397 "$node_(28) setdest 81811 5912 6.0" 
$ns at 457.4023399521089 "$node_(28) setdest 117971 33827 10.0" 
$ns at 573.89220065131 "$node_(28) setdest 151383 65773 8.0" 
$ns at 627.9538362095809 "$node_(28) setdest 133780 62950 15.0" 
$ns at 732.3419174615623 "$node_(28) setdest 206341 65989 3.0" 
$ns at 769.1522083082833 "$node_(28) setdest 187929 4958 15.0" 
$ns at 823.3318788354023 "$node_(28) setdest 65843 34138 8.0" 
$ns at 894.7781534447583 "$node_(28) setdest 56349 74441 3.0" 
$ns at 0.0 "$node_(29) setdest 56837 5984 1.0" 
$ns at 35.5606229108738 "$node_(29) setdest 19533 14061 14.0" 
$ns at 166.23505791942415 "$node_(29) setdest 70127 44285 1.0" 
$ns at 200.84154271243028 "$node_(29) setdest 29072 20256 9.0" 
$ns at 303.52865850556924 "$node_(29) setdest 13719 33304 1.0" 
$ns at 343.3573447281891 "$node_(29) setdest 3656 24056 10.0" 
$ns at 436.3794779440028 "$node_(29) setdest 21192 13128 9.0" 
$ns at 506.38955595721 "$node_(29) setdest 65543 24320 10.0" 
$ns at 597.9624012188393 "$node_(29) setdest 149156 6417 14.0" 
$ns at 635.7397153735226 "$node_(29) setdest 4579 1659 6.0" 
$ns at 701.2877102594541 "$node_(29) setdest 238336 17054 1.0" 
$ns at 733.194564267266 "$node_(29) setdest 128409 75973 11.0" 
$ns at 848.8790499098327 "$node_(29) setdest 247181 3801 13.0" 
$ns at 0.0 "$node_(30) setdest 83971 29993 9.0" 
$ns at 93.11056169111805 "$node_(30) setdest 70735 14151 16.0" 
$ns at 226.18487395683343 "$node_(30) setdest 13114 7769 15.0" 
$ns at 367.758954176913 "$node_(30) setdest 31393 37128 12.0" 
$ns at 500.66725257999985 "$node_(30) setdest 153794 40743 6.0" 
$ns at 548.1465402272696 "$node_(30) setdest 164759 16222 14.0" 
$ns at 643.9308949427673 "$node_(30) setdest 112245 13608 7.0" 
$ns at 720.6615914551518 "$node_(30) setdest 28756 73699 10.0" 
$ns at 817.6707958239666 "$node_(30) setdest 234842 37681 9.0" 
$ns at 877.3452170257563 "$node_(30) setdest 138028 49206 14.0" 
$ns at 0.0 "$node_(31) setdest 54684 10234 13.0" 
$ns at 33.087148784281055 "$node_(31) setdest 93462 5038 10.0" 
$ns at 89.28448400257336 "$node_(31) setdest 39678 30414 16.0" 
$ns at 256.7323669750794 "$node_(31) setdest 96061 47683 1.0" 
$ns at 288.6980090519377 "$node_(31) setdest 14512 14213 2.0" 
$ns at 328.8695387173435 "$node_(31) setdest 5523 46463 11.0" 
$ns at 366.52392612735173 "$node_(31) setdest 172114 11109 7.0" 
$ns at 465.9583606517453 "$node_(31) setdest 118531 15976 1.0" 
$ns at 505.3908535735703 "$node_(31) setdest 62694 49682 1.0" 
$ns at 542.8730617451469 "$node_(31) setdest 42589 21037 13.0" 
$ns at 592.0919171619472 "$node_(31) setdest 185074 24631 18.0" 
$ns at 794.1653375005427 "$node_(31) setdest 20767 18148 1.0" 
$ns at 828.9098705324081 "$node_(31) setdest 204855 70078 4.0" 
$ns at 871.1777787090706 "$node_(31) setdest 90988 56054 13.0" 
$ns at 0.0 "$node_(32) setdest 7637 13793 6.0" 
$ns at 71.38218051946822 "$node_(32) setdest 76422 8858 2.0" 
$ns at 104.06496884228966 "$node_(32) setdest 49808 11566 4.0" 
$ns at 153.85042286599835 "$node_(32) setdest 69977 8288 20.0" 
$ns at 323.2661494739869 "$node_(32) setdest 104909 6762 14.0" 
$ns at 421.75304890708213 "$node_(32) setdest 136681 2024 20.0" 
$ns at 481.5253138950964 "$node_(32) setdest 46038 60542 5.0" 
$ns at 535.465585075642 "$node_(32) setdest 197871 8869 11.0" 
$ns at 594.4558067366733 "$node_(32) setdest 182740 843 5.0" 
$ns at 634.7273024785642 "$node_(32) setdest 53566 53890 3.0" 
$ns at 690.3323568794171 "$node_(32) setdest 168953 294 16.0" 
$ns at 751.1198528893696 "$node_(32) setdest 225886 52576 17.0" 
$ns at 843.6955791345509 "$node_(32) setdest 143977 44486 3.0" 
$ns at 888.472411748524 "$node_(32) setdest 168459 53805 16.0" 
$ns at 0.0 "$node_(33) setdest 44983 5847 16.0" 
$ns at 117.39853255797145 "$node_(33) setdest 14951 50 2.0" 
$ns at 153.01283520378726 "$node_(33) setdest 8539 9752 15.0" 
$ns at 274.04135182579563 "$node_(33) setdest 60938 52938 14.0" 
$ns at 415.8474345748827 "$node_(33) setdest 181265 43081 1.0" 
$ns at 450.2517080771725 "$node_(33) setdest 13945 70488 13.0" 
$ns at 495.77175126821606 "$node_(33) setdest 186227 53118 19.0" 
$ns at 574.5022571453167 "$node_(33) setdest 162807 42700 15.0" 
$ns at 715.9646327923896 "$node_(33) setdest 42798 36816 19.0" 
$ns at 760.6342714200414 "$node_(33) setdest 66511 38525 9.0" 
$ns at 824.7004349658588 "$node_(33) setdest 55128 5626 2.0" 
$ns at 854.7406514828086 "$node_(33) setdest 23636 60834 1.0" 
$ns at 889.4146978499509 "$node_(33) setdest 84101 74043 1.0" 
$ns at 0.0 "$node_(34) setdest 17338 844 15.0" 
$ns at 162.48079884354945 "$node_(34) setdest 10161 8521 16.0" 
$ns at 305.7299441290706 "$node_(34) setdest 2304 6838 19.0" 
$ns at 409.17083474410344 "$node_(34) setdest 18238 54978 4.0" 
$ns at 474.33723068036915 "$node_(34) setdest 6257 8995 17.0" 
$ns at 618.1181061627383 "$node_(34) setdest 143075 51451 10.0" 
$ns at 702.5255065757872 "$node_(34) setdest 145736 29365 14.0" 
$ns at 742.2663914929765 "$node_(34) setdest 146645 39809 11.0" 
$ns at 880.496105133041 "$node_(34) setdest 159057 5321 2.0" 
$ns at 0.0 "$node_(35) setdest 4857 5272 13.0" 
$ns at 35.169931234740616 "$node_(35) setdest 43195 19864 16.0" 
$ns at 176.53548810836207 "$node_(35) setdest 132749 7241 1.0" 
$ns at 210.9472372396646 "$node_(35) setdest 116739 27494 14.0" 
$ns at 247.01976571911524 "$node_(35) setdest 122823 41653 17.0" 
$ns at 393.68490157425106 "$node_(35) setdest 122670 31831 3.0" 
$ns at 444.317525970976 "$node_(35) setdest 174333 47431 10.0" 
$ns at 492.38115902307584 "$node_(35) setdest 144517 9952 8.0" 
$ns at 573.4164753447433 "$node_(35) setdest 224126 29337 14.0" 
$ns at 686.2691763275432 "$node_(35) setdest 153485 11470 1.0" 
$ns at 716.436378023997 "$node_(35) setdest 145900 47112 3.0" 
$ns at 765.2267555750565 "$node_(35) setdest 235960 66824 7.0" 
$ns at 848.9599656120587 "$node_(35) setdest 80359 43912 7.0" 
$ns at 0.0 "$node_(36) setdest 18609 129 10.0" 
$ns at 98.86000312957094 "$node_(36) setdest 42801 19187 11.0" 
$ns at 141.49507600777994 "$node_(36) setdest 61145 3948 2.0" 
$ns at 173.99044609668755 "$node_(36) setdest 26352 19002 18.0" 
$ns at 380.29533845168817 "$node_(36) setdest 172089 28815 15.0" 
$ns at 545.6067873050425 "$node_(36) setdest 188513 16829 6.0" 
$ns at 612.4563871184828 "$node_(36) setdest 83429 37043 15.0" 
$ns at 692.5729367788338 "$node_(36) setdest 35772 72237 12.0" 
$ns at 766.1802591534541 "$node_(36) setdest 4005 57805 6.0" 
$ns at 819.2178894761292 "$node_(36) setdest 58323 73670 2.0" 
$ns at 854.083757600597 "$node_(36) setdest 151570 6313 7.0" 
$ns at 0.0 "$node_(37) setdest 55009 19120 13.0" 
$ns at 91.66141999026942 "$node_(37) setdest 94045 10237 11.0" 
$ns at 165.6710633261438 "$node_(37) setdest 101811 39632 7.0" 
$ns at 202.172789983156 "$node_(37) setdest 67512 39490 3.0" 
$ns at 248.93619700233353 "$node_(37) setdest 114829 39801 1.0" 
$ns at 279.92522131361704 "$node_(37) setdest 127498 53762 7.0" 
$ns at 375.86469826741825 "$node_(37) setdest 61544 15079 4.0" 
$ns at 439.7185273006865 "$node_(37) setdest 139608 56078 5.0" 
$ns at 512.6550087436096 "$node_(37) setdest 186918 68601 15.0" 
$ns at 637.7209894546767 "$node_(37) setdest 87574 67826 10.0" 
$ns at 726.6576695968286 "$node_(37) setdest 166492 50694 7.0" 
$ns at 805.7932240504912 "$node_(37) setdest 93536 38273 14.0" 
$ns at 0.0 "$node_(38) setdest 94284 12948 5.0" 
$ns at 34.7722968983848 "$node_(38) setdest 28715 12761 20.0" 
$ns at 174.43182179716024 "$node_(38) setdest 49516 10654 3.0" 
$ns at 207.2981755941151 "$node_(38) setdest 31825 10161 12.0" 
$ns at 295.17676174592924 "$node_(38) setdest 87349 34418 8.0" 
$ns at 339.6585755322268 "$node_(38) setdest 53641 19035 11.0" 
$ns at 409.8401894167347 "$node_(38) setdest 140706 514 4.0" 
$ns at 468.8118852108874 "$node_(38) setdest 206745 34723 19.0" 
$ns at 538.2096479526102 "$node_(38) setdest 129416 13062 2.0" 
$ns at 585.8031124787033 "$node_(38) setdest 19012 37226 10.0" 
$ns at 697.5085903677073 "$node_(38) setdest 26901 41754 16.0" 
$ns at 786.8526113940396 "$node_(38) setdest 204092 56994 4.0" 
$ns at 824.6189964654116 "$node_(38) setdest 163372 26167 19.0" 
$ns at 880.2494541817857 "$node_(38) setdest 265955 3201 20.0" 
$ns at 0.0 "$node_(39) setdest 9037 18374 8.0" 
$ns at 32.30751286134434 "$node_(39) setdest 90467 4212 1.0" 
$ns at 65.00767021820295 "$node_(39) setdest 81975 2524 10.0" 
$ns at 100.76436375656175 "$node_(39) setdest 2442 17045 18.0" 
$ns at 212.15194141705703 "$node_(39) setdest 49931 43595 20.0" 
$ns at 407.80929440772854 "$node_(39) setdest 129828 59967 9.0" 
$ns at 506.85927288905776 "$node_(39) setdest 14517 5944 7.0" 
$ns at 550.1419448764129 "$node_(39) setdest 185424 39108 12.0" 
$ns at 677.2398998438299 "$node_(39) setdest 83318 25450 17.0" 
$ns at 751.9149404170389 "$node_(39) setdest 13712 10546 11.0" 
$ns at 805.6334206737286 "$node_(39) setdest 235526 43510 19.0" 
$ns at 896.3054964480494 "$node_(39) setdest 130246 44361 17.0" 
$ns at 0.0 "$node_(40) setdest 23171 4324 18.0" 
$ns at 69.0296286704661 "$node_(40) setdest 37797 29201 4.0" 
$ns at 117.46664895846398 "$node_(40) setdest 21356 18473 4.0" 
$ns at 161.2807630178241 "$node_(40) setdest 11719 2029 5.0" 
$ns at 237.62271000648752 "$node_(40) setdest 48191 22932 7.0" 
$ns at 288.20541620364554 "$node_(40) setdest 28904 9982 2.0" 
$ns at 332.3814292647103 "$node_(40) setdest 138291 49 17.0" 
$ns at 480.4043039663427 "$node_(40) setdest 108798 66644 19.0" 
$ns at 662.8372625818595 "$node_(40) setdest 117793 38701 3.0" 
$ns at 721.2260533039553 "$node_(40) setdest 221013 12867 10.0" 
$ns at 850.7019214885288 "$node_(40) setdest 129967 12145 15.0" 
$ns at 0.0 "$node_(41) setdest 117 12081 16.0" 
$ns at 166.46892443218303 "$node_(41) setdest 57481 531 18.0" 
$ns at 359.1072599478797 "$node_(41) setdest 110118 35242 15.0" 
$ns at 476.07899613479935 "$node_(41) setdest 78792 24794 11.0" 
$ns at 512.1978123559787 "$node_(41) setdest 79376 33692 2.0" 
$ns at 558.6744270302515 "$node_(41) setdest 29700 13616 19.0" 
$ns at 665.5194064235882 "$node_(41) setdest 130625 16993 5.0" 
$ns at 734.1151217774167 "$node_(41) setdest 81283 33069 13.0" 
$ns at 765.959211837928 "$node_(41) setdest 166472 56498 4.0" 
$ns at 800.3030539106346 "$node_(41) setdest 115101 39421 11.0" 
$ns at 0.0 "$node_(42) setdest 29463 23345 7.0" 
$ns at 77.12313619613525 "$node_(42) setdest 10873 18065 7.0" 
$ns at 168.4147660262102 "$node_(42) setdest 41844 12778 5.0" 
$ns at 243.26673780123622 "$node_(42) setdest 74303 10508 3.0" 
$ns at 289.00077710320903 "$node_(42) setdest 32116 196 8.0" 
$ns at 347.2345717965173 "$node_(42) setdest 86234 7342 7.0" 
$ns at 392.839926060196 "$node_(42) setdest 66859 32338 14.0" 
$ns at 562.638830269405 "$node_(42) setdest 100343 68710 7.0" 
$ns at 624.2017420561853 "$node_(42) setdest 210646 39173 2.0" 
$ns at 673.1290382169848 "$node_(42) setdest 152263 36236 11.0" 
$ns at 728.4351582432507 "$node_(42) setdest 140019 82076 9.0" 
$ns at 834.155522942932 "$node_(42) setdest 135210 51243 7.0" 
$ns at 0.0 "$node_(43) setdest 56519 15856 19.0" 
$ns at 64.06378178812518 "$node_(43) setdest 62002 9189 2.0" 
$ns at 112.72828528952999 "$node_(43) setdest 53982 25176 11.0" 
$ns at 158.92610914572793 "$node_(43) setdest 64906 33589 15.0" 
$ns at 226.05114376103592 "$node_(43) setdest 47252 8745 13.0" 
$ns at 362.4321429583164 "$node_(43) setdest 71625 7468 11.0" 
$ns at 398.3210617094643 "$node_(43) setdest 113063 42935 19.0" 
$ns at 577.0272783234548 "$node_(43) setdest 133858 45395 6.0" 
$ns at 628.8729849872852 "$node_(43) setdest 185778 42780 17.0" 
$ns at 751.8798240860249 "$node_(43) setdest 212765 24319 7.0" 
$ns at 842.7874422117767 "$node_(43) setdest 132634 2455 18.0" 
$ns at 0.0 "$node_(44) setdest 61790 27200 16.0" 
$ns at 105.94304932259854 "$node_(44) setdest 26196 6943 20.0" 
$ns at 289.5792255200264 "$node_(44) setdest 50640 8017 1.0" 
$ns at 326.01998384512564 "$node_(44) setdest 110835 18342 14.0" 
$ns at 435.06394860375894 "$node_(44) setdest 166709 55248 8.0" 
$ns at 487.7430172349512 "$node_(44) setdest 20746 4727 8.0" 
$ns at 584.1997241671552 "$node_(44) setdest 121687 39160 17.0" 
$ns at 630.0673175221734 "$node_(44) setdest 79453 36465 16.0" 
$ns at 705.4633971950503 "$node_(44) setdest 78943 69665 2.0" 
$ns at 747.7516838857922 "$node_(44) setdest 100698 69955 2.0" 
$ns at 781.4297823339875 "$node_(44) setdest 63617 49485 10.0" 
$ns at 853.2412013388544 "$node_(44) setdest 152833 29203 3.0" 
$ns at 895.5260847448434 "$node_(44) setdest 254758 20274 16.0" 
$ns at 0.0 "$node_(45) setdest 6677 12847 10.0" 
$ns at 125.63193408016988 "$node_(45) setdest 14789 7629 10.0" 
$ns at 193.35767421215107 "$node_(45) setdest 94322 14478 9.0" 
$ns at 263.31736640996365 "$node_(45) setdest 116829 37931 17.0" 
$ns at 372.58267677771147 "$node_(45) setdest 46480 10786 9.0" 
$ns at 444.0606080800294 "$node_(45) setdest 154913 19975 7.0" 
$ns at 538.1363843183458 "$node_(45) setdest 126639 20232 1.0" 
$ns at 576.4324966487303 "$node_(45) setdest 214822 67237 4.0" 
$ns at 641.7045638892304 "$node_(45) setdest 211546 2141 1.0" 
$ns at 672.9609508397174 "$node_(45) setdest 52859 50421 8.0" 
$ns at 770.2151938553154 "$node_(45) setdest 49373 15587 20.0" 
$ns at 806.2613690048606 "$node_(45) setdest 195857 65592 18.0" 
$ns at 0.0 "$node_(46) setdest 6637 15358 19.0" 
$ns at 96.59688910907428 "$node_(46) setdest 58710 941 11.0" 
$ns at 132.50585295484902 "$node_(46) setdest 83048 5821 17.0" 
$ns at 296.50689105550316 "$node_(46) setdest 157242 51527 11.0" 
$ns at 392.75293988399824 "$node_(46) setdest 189661 24012 19.0" 
$ns at 572.7596792049351 "$node_(46) setdest 35100 68870 16.0" 
$ns at 735.042539427292 "$node_(46) setdest 73792 59267 5.0" 
$ns at 767.9072177893717 "$node_(46) setdest 256486 56587 9.0" 
$ns at 887.4745304148896 "$node_(46) setdest 22472 62817 3.0" 
$ns at 0.0 "$node_(47) setdest 46828 26439 7.0" 
$ns at 74.38616905350858 "$node_(47) setdest 79591 20924 19.0" 
$ns at 125.44843242649192 "$node_(47) setdest 84086 7839 7.0" 
$ns at 221.81377864933836 "$node_(47) setdest 98469 2145 12.0" 
$ns at 356.39855176144675 "$node_(47) setdest 69105 8062 14.0" 
$ns at 391.0088336249275 "$node_(47) setdest 110567 42269 17.0" 
$ns at 476.52020979891466 "$node_(47) setdest 204251 57718 12.0" 
$ns at 517.2576990905196 "$node_(47) setdest 188626 12011 9.0" 
$ns at 600.8766955655374 "$node_(47) setdest 40252 46307 7.0" 
$ns at 637.5499475516087 "$node_(47) setdest 232360 47567 15.0" 
$ns at 689.4830231727557 "$node_(47) setdest 39460 20205 19.0" 
$ns at 841.3614287514498 "$node_(47) setdest 160553 13483 8.0" 
$ns at 890.7005770059761 "$node_(47) setdest 105254 78155 9.0" 
$ns at 0.0 "$node_(48) setdest 2675 1916 9.0" 
$ns at 94.07423156844243 "$node_(48) setdest 81417 2289 11.0" 
$ns at 219.22858591444458 "$node_(48) setdest 24771 30709 2.0" 
$ns at 266.6746867496313 "$node_(48) setdest 21334 17911 19.0" 
$ns at 395.3063263567997 "$node_(48) setdest 182407 1490 3.0" 
$ns at 445.632798230542 "$node_(48) setdest 187491 16576 2.0" 
$ns at 481.7606487135427 "$node_(48) setdest 104386 69594 3.0" 
$ns at 524.9651239284051 "$node_(48) setdest 87810 18747 15.0" 
$ns at 584.300566300626 "$node_(48) setdest 156690 47551 9.0" 
$ns at 676.9599282577667 "$node_(48) setdest 19221 34806 15.0" 
$ns at 758.5491837822068 "$node_(48) setdest 191609 68932 15.0" 
$ns at 796.1457325285736 "$node_(48) setdest 182921 77027 13.0" 
$ns at 0.0 "$node_(49) setdest 64506 1336 5.0" 
$ns at 34.18087534155559 "$node_(49) setdest 75024 876 1.0" 
$ns at 69.54161354866305 "$node_(49) setdest 28834 29032 16.0" 
$ns at 203.61774825957326 "$node_(49) setdest 130957 14367 16.0" 
$ns at 391.53482739768845 "$node_(49) setdest 98386 30804 17.0" 
$ns at 448.2227243854562 "$node_(49) setdest 80414 12847 5.0" 
$ns at 491.7161335687309 "$node_(49) setdest 99158 12716 17.0" 
$ns at 630.8661671009218 "$node_(49) setdest 81243 61216 3.0" 
$ns at 678.095078711114 "$node_(49) setdest 245610 27220 10.0" 
$ns at 783.0856837293918 "$node_(49) setdest 225070 33388 5.0" 
$ns at 823.6024157263305 "$node_(49) setdest 197879 48404 16.0" 
$ns at 0.0 "$node_(50) setdest 92502 15699 14.0" 
$ns at 124.93456570860037 "$node_(50) setdest 61648 7188 4.0" 
$ns at 171.04995264579438 "$node_(50) setdest 49773 22135 14.0" 
$ns at 208.13855269081364 "$node_(50) setdest 17526 30527 19.0" 
$ns at 400.7200754589762 "$node_(50) setdest 87907 40060 5.0" 
$ns at 437.07136298134157 "$node_(50) setdest 58610 38829 9.0" 
$ns at 532.7470836305622 "$node_(50) setdest 39572 16965 4.0" 
$ns at 565.2667974117296 "$node_(50) setdest 89707 4401 13.0" 
$ns at 680.0046300300714 "$node_(50) setdest 222916 40263 5.0" 
$ns at 731.792901605757 "$node_(50) setdest 159642 81823 4.0" 
$ns at 780.1804672378557 "$node_(50) setdest 160528 60128 6.0" 
$ns at 867.2062702319722 "$node_(50) setdest 210873 7030 5.0" 
$ns at 0.0 "$node_(51) setdest 1705 8394 2.0" 
$ns at 34.89424556648356 "$node_(51) setdest 72524 17967 16.0" 
$ns at 169.7540090094173 "$node_(51) setdest 112489 40878 16.0" 
$ns at 279.63266707405614 "$node_(51) setdest 9569 50851 14.0" 
$ns at 350.41348511526985 "$node_(51) setdest 48375 16076 13.0" 
$ns at 485.75617132294155 "$node_(51) setdest 34315 66237 18.0" 
$ns at 624.9204844268043 "$node_(51) setdest 183315 23198 17.0" 
$ns at 745.4087812052063 "$node_(51) setdest 216319 39231 15.0" 
$ns at 823.0031964112098 "$node_(51) setdest 209472 53129 19.0" 
$ns at 861.8034002436123 "$node_(51) setdest 92029 76044 14.0" 
$ns at 0.0 "$node_(52) setdest 15901 16344 4.0" 
$ns at 56.521287591750465 "$node_(52) setdest 33476 24505 20.0" 
$ns at 153.8825325029256 "$node_(52) setdest 54887 17155 1.0" 
$ns at 190.03824786744116 "$node_(52) setdest 122900 2838 19.0" 
$ns at 250.7625909767368 "$node_(52) setdest 110597 13101 9.0" 
$ns at 312.3002913103979 "$node_(52) setdest 54852 42541 4.0" 
$ns at 366.7229678175811 "$node_(52) setdest 122708 30743 15.0" 
$ns at 482.6590796249542 "$node_(52) setdest 97397 32326 20.0" 
$ns at 709.636818879382 "$node_(52) setdest 146813 62181 3.0" 
$ns at 762.2705212249606 "$node_(52) setdest 129950 46187 18.0" 
$ns at 890.352315699356 "$node_(52) setdest 123261 51820 13.0" 
$ns at 0.0 "$node_(53) setdest 69254 1211 8.0" 
$ns at 71.55518540866322 "$node_(53) setdest 30557 511 3.0" 
$ns at 128.334402446984 "$node_(53) setdest 16505 16374 13.0" 
$ns at 166.64419687945315 "$node_(53) setdest 33045 42255 7.0" 
$ns at 234.6221611220037 "$node_(53) setdest 94909 13604 1.0" 
$ns at 267.1057928071343 "$node_(53) setdest 75245 46631 1.0" 
$ns at 303.07710426305044 "$node_(53) setdest 58747 42143 3.0" 
$ns at 345.3038145626335 "$node_(53) setdest 85659 27089 9.0" 
$ns at 386.06707610990105 "$node_(53) setdest 183015 29706 4.0" 
$ns at 433.48244736522764 "$node_(53) setdest 131315 27308 1.0" 
$ns at 471.2096512430421 "$node_(53) setdest 10928 58052 18.0" 
$ns at 655.1664983335485 "$node_(53) setdest 200980 44874 17.0" 
$ns at 745.5425772998051 "$node_(53) setdest 219533 4814 14.0" 
$ns at 880.4204424258792 "$node_(53) setdest 75083 80669 17.0" 
$ns at 0.0 "$node_(54) setdest 84762 15583 5.0" 
$ns at 73.79315907353796 "$node_(54) setdest 18844 24585 8.0" 
$ns at 118.34940399830639 "$node_(54) setdest 14059 11142 14.0" 
$ns at 227.17972526162265 "$node_(54) setdest 56081 19146 8.0" 
$ns at 271.0019316596038 "$node_(54) setdest 46479 38273 13.0" 
$ns at 327.3096677670045 "$node_(54) setdest 37623 3632 19.0" 
$ns at 423.3210797728292 "$node_(54) setdest 38474 13749 11.0" 
$ns at 500.76385206718976 "$node_(54) setdest 18745 17470 15.0" 
$ns at 546.1550927214754 "$node_(54) setdest 128159 62418 17.0" 
$ns at 632.8718127882319 "$node_(54) setdest 73132 28886 7.0" 
$ns at 726.7068135210252 "$node_(54) setdest 216984 64859 10.0" 
$ns at 780.7058094776272 "$node_(54) setdest 230128 18106 4.0" 
$ns at 832.1322930639944 "$node_(54) setdest 8555 50775 9.0" 
$ns at 0.0 "$node_(55) setdest 47824 16031 20.0" 
$ns at 89.53887510876177 "$node_(55) setdest 85528 14263 6.0" 
$ns at 151.62417781380788 "$node_(55) setdest 18090 12077 11.0" 
$ns at 196.66190885398936 "$node_(55) setdest 56057 23197 10.0" 
$ns at 308.7640824229219 "$node_(55) setdest 146891 4084 11.0" 
$ns at 381.5123601387517 "$node_(55) setdest 168861 55634 14.0" 
$ns at 484.82982096431977 "$node_(55) setdest 81776 40389 17.0" 
$ns at 601.0771806497269 "$node_(55) setdest 176624 1464 4.0" 
$ns at 650.037759674051 "$node_(55) setdest 65204 14519 17.0" 
$ns at 710.7737063190918 "$node_(55) setdest 228707 14704 13.0" 
$ns at 774.0897854737268 "$node_(55) setdest 215462 33472 12.0" 
$ns at 870.0191851436139 "$node_(55) setdest 202387 67865 18.0" 
$ns at 0.0 "$node_(56) setdest 37310 10317 6.0" 
$ns at 59.03069739109214 "$node_(56) setdest 55190 2126 19.0" 
$ns at 179.8449128507875 "$node_(56) setdest 125685 26139 6.0" 
$ns at 217.60071871470146 "$node_(56) setdest 124334 37507 17.0" 
$ns at 361.4747805259279 "$node_(56) setdest 122679 9579 7.0" 
$ns at 403.5846107120513 "$node_(56) setdest 173628 24789 20.0" 
$ns at 565.7195268254753 "$node_(56) setdest 180782 17231 18.0" 
$ns at 693.4055192366951 "$node_(56) setdest 213311 32212 18.0" 
$ns at 798.8222364644145 "$node_(56) setdest 49266 24501 2.0" 
$ns at 838.6624929364016 "$node_(56) setdest 138250 40949 5.0" 
$ns at 0.0 "$node_(57) setdest 76025 12340 5.0" 
$ns at 44.03895947014748 "$node_(57) setdest 89100 8822 4.0" 
$ns at 90.4820454351597 "$node_(57) setdest 41603 30759 15.0" 
$ns at 256.50633027305014 "$node_(57) setdest 99012 41958 17.0" 
$ns at 429.6325069994065 "$node_(57) setdest 88282 14309 13.0" 
$ns at 537.1604390284022 "$node_(57) setdest 70622 35304 5.0" 
$ns at 587.3798508574462 "$node_(57) setdest 65347 5216 10.0" 
$ns at 618.3813097107183 "$node_(57) setdest 86385 46297 16.0" 
$ns at 672.5724689122815 "$node_(57) setdest 167583 29146 9.0" 
$ns at 736.0061867486633 "$node_(57) setdest 88607 48339 2.0" 
$ns at 767.8685914862972 "$node_(57) setdest 104535 48542 12.0" 
$ns at 0.0 "$node_(58) setdest 17214 30471 7.0" 
$ns at 53.39949907054097 "$node_(58) setdest 62591 9016 9.0" 
$ns at 154.0871681728161 "$node_(58) setdest 6545 29894 6.0" 
$ns at 206.0694003713906 "$node_(58) setdest 44173 18419 16.0" 
$ns at 246.80574333216163 "$node_(58) setdest 10241 18666 20.0" 
$ns at 297.59916363207304 "$node_(58) setdest 150614 21650 14.0" 
$ns at 367.3072168793554 "$node_(58) setdest 61121 46155 16.0" 
$ns at 476.16346439430026 "$node_(58) setdest 178180 22431 16.0" 
$ns at 616.6091957206906 "$node_(58) setdest 32739 17979 14.0" 
$ns at 754.8924563795464 "$node_(58) setdest 124633 69390 16.0" 
$ns at 840.4822542866399 "$node_(58) setdest 36241 28633 19.0" 
$ns at 0.0 "$node_(59) setdest 78660 11707 11.0" 
$ns at 85.52489671557386 "$node_(59) setdest 17589 13907 15.0" 
$ns at 193.1069250383536 "$node_(59) setdest 22218 29421 16.0" 
$ns at 313.4240872909188 "$node_(59) setdest 49147 27758 14.0" 
$ns at 464.8372703891158 "$node_(59) setdest 121476 51540 18.0" 
$ns at 509.30484422033425 "$node_(59) setdest 55994 16571 10.0" 
$ns at 620.0746504844633 "$node_(59) setdest 106816 61309 12.0" 
$ns at 710.0719706362919 "$node_(59) setdest 87046 32464 1.0" 
$ns at 741.8128235677194 "$node_(59) setdest 156151 34653 13.0" 
$ns at 850.676941388708 "$node_(59) setdest 140713 21296 5.0" 
$ns at 0.0 "$node_(60) setdest 5928 10056 14.0" 
$ns at 151.62214437480085 "$node_(60) setdest 132187 32573 5.0" 
$ns at 196.72046970182151 "$node_(60) setdest 123416 38644 13.0" 
$ns at 246.58321383075713 "$node_(60) setdest 119463 5861 13.0" 
$ns at 310.2494804661812 "$node_(60) setdest 19999 34569 19.0" 
$ns at 436.76007088911786 "$node_(60) setdest 119856 13123 16.0" 
$ns at 561.2969816539083 "$node_(60) setdest 144194 56274 8.0" 
$ns at 669.5659034397507 "$node_(60) setdest 18967 12041 11.0" 
$ns at 726.5709150759542 "$node_(60) setdest 82693 60782 1.0" 
$ns at 763.0793960082051 "$node_(60) setdest 142477 69953 19.0" 
$ns at 851.9958498744244 "$node_(60) setdest 32081 34866 16.0" 
$ns at 0.0 "$node_(61) setdest 40735 28907 1.0" 
$ns at 35.34052994966144 "$node_(61) setdest 46684 17036 8.0" 
$ns at 65.42028974633527 "$node_(61) setdest 90627 20907 15.0" 
$ns at 143.9517960785762 "$node_(61) setdest 74882 23794 2.0" 
$ns at 187.50062840535668 "$node_(61) setdest 15503 9177 19.0" 
$ns at 367.4840690125923 "$node_(61) setdest 10814 48551 17.0" 
$ns at 415.75753565109574 "$node_(61) setdest 187038 24940 20.0" 
$ns at 581.8842171160334 "$node_(61) setdest 214171 56556 4.0" 
$ns at 633.046582103684 "$node_(61) setdest 28354 76649 1.0" 
$ns at 665.9034318251396 "$node_(61) setdest 24176 57927 7.0" 
$ns at 733.7648226388487 "$node_(61) setdest 94418 48034 12.0" 
$ns at 839.7298049143376 "$node_(61) setdest 101335 153 8.0" 
$ns at 0.0 "$node_(62) setdest 57224 12467 1.0" 
$ns at 35.73705046582054 "$node_(62) setdest 23513 14972 15.0" 
$ns at 121.21759509300327 "$node_(62) setdest 94732 20573 14.0" 
$ns at 232.03474780694816 "$node_(62) setdest 59659 22058 2.0" 
$ns at 272.41450486651394 "$node_(62) setdest 8907 570 14.0" 
$ns at 347.73278251883517 "$node_(62) setdest 18544 24308 11.0" 
$ns at 426.00634753587894 "$node_(62) setdest 70417 22761 9.0" 
$ns at 494.07023545634684 "$node_(62) setdest 84870 7081 15.0" 
$ns at 535.555058836957 "$node_(62) setdest 173341 4645 11.0" 
$ns at 658.4101030017711 "$node_(62) setdest 153350 74265 18.0" 
$ns at 858.7152689251753 "$node_(62) setdest 206037 23793 10.0" 
$ns at 0.0 "$node_(63) setdest 26770 4681 12.0" 
$ns at 128.77888082507738 "$node_(63) setdest 39779 30358 16.0" 
$ns at 282.96523056882074 "$node_(63) setdest 130155 44231 1.0" 
$ns at 321.1958392440601 "$node_(63) setdest 67437 50146 14.0" 
$ns at 381.0324327923633 "$node_(63) setdest 69856 5784 1.0" 
$ns at 419.23314991158315 "$node_(63) setdest 46219 42036 20.0" 
$ns at 542.0141714817424 "$node_(63) setdest 128427 12741 14.0" 
$ns at 629.9430550454708 "$node_(63) setdest 56216 8214 3.0" 
$ns at 684.4928719529294 "$node_(63) setdest 215637 79568 13.0" 
$ns at 831.5476158946485 "$node_(63) setdest 8263 43351 9.0" 
$ns at 0.0 "$node_(64) setdest 11887 6326 7.0" 
$ns at 96.91418128887997 "$node_(64) setdest 74269 24267 6.0" 
$ns at 148.72170570697716 "$node_(64) setdest 25796 31275 8.0" 
$ns at 257.73242735400396 "$node_(64) setdest 117322 37493 18.0" 
$ns at 458.7159567916798 "$node_(64) setdest 155783 812 10.0" 
$ns at 524.9129247086049 "$node_(64) setdest 120700 67653 1.0" 
$ns at 562.4217354080462 "$node_(64) setdest 8912 9521 1.0" 
$ns at 602.0692177706645 "$node_(64) setdest 19750 36945 14.0" 
$ns at 736.3126589327373 "$node_(64) setdest 191643 35903 11.0" 
$ns at 854.4750629276377 "$node_(64) setdest 180095 41721 4.0" 
$ns at 0.0 "$node_(65) setdest 76952 18266 16.0" 
$ns at 125.11764965152707 "$node_(65) setdest 75203 27676 2.0" 
$ns at 170.29471616334445 "$node_(65) setdest 11944 6553 12.0" 
$ns at 270.3736683754811 "$node_(65) setdest 131038 29875 19.0" 
$ns at 363.65004859894486 "$node_(65) setdest 185384 17424 11.0" 
$ns at 502.56172389285683 "$node_(65) setdest 36853 64241 9.0" 
$ns at 537.782673114911 "$node_(65) setdest 39584 65980 8.0" 
$ns at 635.2089697319223 "$node_(65) setdest 110852 18120 10.0" 
$ns at 712.7690435059831 "$node_(65) setdest 220126 38922 17.0" 
$ns at 766.0672303400304 "$node_(65) setdest 111282 62690 5.0" 
$ns at 837.2365636343465 "$node_(65) setdest 38255 28557 8.0" 
$ns at 0.0 "$node_(66) setdest 78375 25651 16.0" 
$ns at 162.9675450123359 "$node_(66) setdest 31287 3951 15.0" 
$ns at 337.76904435256046 "$node_(66) setdest 89892 50016 18.0" 
$ns at 449.31412451481197 "$node_(66) setdest 23155 17082 14.0" 
$ns at 500.24096718142675 "$node_(66) setdest 84075 60584 16.0" 
$ns at 669.3746398048502 "$node_(66) setdest 71126 32187 6.0" 
$ns at 727.7437044667513 "$node_(66) setdest 194108 4040 16.0" 
$ns at 811.8603530538852 "$node_(66) setdest 213077 31024 1.0" 
$ns at 851.3340884490203 "$node_(66) setdest 162163 38026 20.0" 
$ns at 0.0 "$node_(67) setdest 11570 7451 15.0" 
$ns at 89.8608406738483 "$node_(67) setdest 59386 3793 16.0" 
$ns at 250.3938394165197 "$node_(67) setdest 35165 46956 15.0" 
$ns at 384.60234115937976 "$node_(67) setdest 46367 52696 5.0" 
$ns at 448.8701120440353 "$node_(67) setdest 141988 47160 20.0" 
$ns at 668.9190207916275 "$node_(67) setdest 114931 15433 19.0" 
$ns at 850.217437604476 "$node_(67) setdest 177783 44170 20.0" 
$ns at 0.0 "$node_(68) setdest 55226 17753 13.0" 
$ns at 104.15665841341078 "$node_(68) setdest 30564 17795 1.0" 
$ns at 134.90218018431932 "$node_(68) setdest 72583 7463 3.0" 
$ns at 181.93091360200344 "$node_(68) setdest 126418 42943 12.0" 
$ns at 322.6965737784817 "$node_(68) setdest 87263 42069 9.0" 
$ns at 405.5295087260112 "$node_(68) setdest 23837 27582 20.0" 
$ns at 593.2529533290392 "$node_(68) setdest 195528 74743 4.0" 
$ns at 634.2484683242117 "$node_(68) setdest 146574 6699 5.0" 
$ns at 713.87242810241 "$node_(68) setdest 103044 76730 7.0" 
$ns at 748.8398392928704 "$node_(68) setdest 183934 42937 3.0" 
$ns at 780.4769951522825 "$node_(68) setdest 71179 78681 8.0" 
$ns at 856.5384562461154 "$node_(68) setdest 212273 83358 13.0" 
$ns at 0.0 "$node_(69) setdest 74575 589 14.0" 
$ns at 123.86862787053063 "$node_(69) setdest 84058 27646 7.0" 
$ns at 203.42480675050115 "$node_(69) setdest 96376 13042 13.0" 
$ns at 359.7468913993562 "$node_(69) setdest 121282 23843 10.0" 
$ns at 449.02040495109213 "$node_(69) setdest 169192 62189 1.0" 
$ns at 483.54961545778406 "$node_(69) setdest 122905 56950 18.0" 
$ns at 682.0894658259987 "$node_(69) setdest 159742 55516 10.0" 
$ns at 743.5806170219628 "$node_(69) setdest 167735 58769 13.0" 
$ns at 866.7968755878817 "$node_(69) setdest 35996 52746 11.0" 
$ns at 0.0 "$node_(70) setdest 80536 9810 5.0" 
$ns at 70.44212772379822 "$node_(70) setdest 18235 25962 1.0" 
$ns at 110.35324418486411 "$node_(70) setdest 69270 20801 8.0" 
$ns at 203.21762156833552 "$node_(70) setdest 24041 25275 3.0" 
$ns at 234.74751745784687 "$node_(70) setdest 103361 16067 9.0" 
$ns at 296.81725974025386 "$node_(70) setdest 18103 28883 4.0" 
$ns at 337.942224576599 "$node_(70) setdest 94317 28349 11.0" 
$ns at 382.6857342818189 "$node_(70) setdest 22788 17682 15.0" 
$ns at 415.2046060576746 "$node_(70) setdest 31038 23906 9.0" 
$ns at 508.42138726544306 "$node_(70) setdest 172544 65182 18.0" 
$ns at 606.8534458326591 "$node_(70) setdest 79365 48473 14.0" 
$ns at 662.0972957501832 "$node_(70) setdest 57223 46248 20.0" 
$ns at 723.9891615545446 "$node_(70) setdest 126465 39580 2.0" 
$ns at 768.8939656132361 "$node_(70) setdest 108000 28710 4.0" 
$ns at 824.4151677228941 "$node_(70) setdest 139486 83075 6.0" 
$ns at 0.0 "$node_(71) setdest 74396 2376 18.0" 
$ns at 145.7103229171817 "$node_(71) setdest 51299 28362 1.0" 
$ns at 184.61145527781173 "$node_(71) setdest 129690 39507 12.0" 
$ns at 264.3944751335485 "$node_(71) setdest 139797 54585 1.0" 
$ns at 295.6748598205502 "$node_(71) setdest 81314 51560 10.0" 
$ns at 338.7543988856633 "$node_(71) setdest 20305 13705 19.0" 
$ns at 431.98580102031843 "$node_(71) setdest 137840 40330 14.0" 
$ns at 484.0974084718034 "$node_(71) setdest 147998 2266 19.0" 
$ns at 673.7909413548942 "$node_(71) setdest 247804 66735 1.0" 
$ns at 707.5341384076692 "$node_(71) setdest 184235 77264 6.0" 
$ns at 761.154812360536 "$node_(71) setdest 136596 33414 6.0" 
$ns at 799.3212169843481 "$node_(71) setdest 98991 32986 1.0" 
$ns at 830.9841550851247 "$node_(71) setdest 238412 9124 20.0" 
$ns at 0.0 "$node_(72) setdest 21419 8726 2.0" 
$ns at 38.053585653451705 "$node_(72) setdest 5218 28359 17.0" 
$ns at 128.06094472331122 "$node_(72) setdest 85254 30267 1.0" 
$ns at 161.83785654217235 "$node_(72) setdest 132275 44636 4.0" 
$ns at 194.6525713932374 "$node_(72) setdest 36397 2388 1.0" 
$ns at 231.00216534388466 "$node_(72) setdest 88213 6554 9.0" 
$ns at 273.2433182099132 "$node_(72) setdest 128903 18527 4.0" 
$ns at 331.65574849566474 "$node_(72) setdest 159344 16544 9.0" 
$ns at 425.0975259673641 "$node_(72) setdest 2928 34413 14.0" 
$ns at 566.7325170367312 "$node_(72) setdest 147193 52435 1.0" 
$ns at 605.7449777881279 "$node_(72) setdest 42328 47015 6.0" 
$ns at 639.4966779943161 "$node_(72) setdest 59883 7965 18.0" 
$ns at 779.9535613580899 "$node_(72) setdest 117057 87026 13.0" 
$ns at 883.5117552285939 "$node_(72) setdest 33929 95 4.0" 
$ns at 0.0 "$node_(73) setdest 5445 27269 5.0" 
$ns at 79.78109480666083 "$node_(73) setdest 38105 15042 17.0" 
$ns at 227.32479242501202 "$node_(73) setdest 122459 28353 18.0" 
$ns at 378.49214123382444 "$node_(73) setdest 140831 18907 19.0" 
$ns at 466.42179602921783 "$node_(73) setdest 168572 45742 5.0" 
$ns at 523.1570651544357 "$node_(73) setdest 122259 57201 9.0" 
$ns at 587.7184012777775 "$node_(73) setdest 116131 20221 7.0" 
$ns at 621.083424436192 "$node_(73) setdest 119826 76556 10.0" 
$ns at 707.3469534708097 "$node_(73) setdest 191505 73130 8.0" 
$ns at 758.9824518310002 "$node_(73) setdest 174393 21849 16.0" 
$ns at 829.8772900414133 "$node_(73) setdest 109916 12248 4.0" 
$ns at 880.0678227072324 "$node_(73) setdest 190481 58938 1.0" 
$ns at 0.0 "$node_(74) setdest 32140 23523 18.0" 
$ns at 77.07887214685829 "$node_(74) setdest 31963 23081 1.0" 
$ns at 116.90016055349716 "$node_(74) setdest 19098 13936 13.0" 
$ns at 209.72092148906495 "$node_(74) setdest 127164 38910 17.0" 
$ns at 325.4701166713336 "$node_(74) setdest 145562 8032 10.0" 
$ns at 379.2760546658284 "$node_(74) setdest 176995 11838 12.0" 
$ns at 441.729453279366 "$node_(74) setdest 33407 21075 19.0" 
$ns at 536.4260596863833 "$node_(74) setdest 37185 22010 2.0" 
$ns at 576.9108066693335 "$node_(74) setdest 44660 4314 5.0" 
$ns at 637.1805614573456 "$node_(74) setdest 30460 22529 10.0" 
$ns at 687.4907946367466 "$node_(74) setdest 120613 23518 14.0" 
$ns at 814.4480455480774 "$node_(74) setdest 256618 73926 19.0" 
$ns at 859.1184935056937 "$node_(74) setdest 231823 36443 10.0" 
$ns at 0.0 "$node_(75) setdest 40002 11446 2.0" 
$ns at 40.18123615160227 "$node_(75) setdest 39525 3756 6.0" 
$ns at 88.60282900255675 "$node_(75) setdest 56987 25347 15.0" 
$ns at 255.83669553498737 "$node_(75) setdest 29002 53152 17.0" 
$ns at 309.8013827881555 "$node_(75) setdest 94022 47895 15.0" 
$ns at 378.8202388096211 "$node_(75) setdest 87007 22079 16.0" 
$ns at 416.3068664617274 "$node_(75) setdest 118204 26210 1.0" 
$ns at 448.0150170153471 "$node_(75) setdest 167417 44421 5.0" 
$ns at 515.2367663883442 "$node_(75) setdest 146521 5303 9.0" 
$ns at 589.6212212328751 "$node_(75) setdest 110821 14092 2.0" 
$ns at 626.9051669263072 "$node_(75) setdest 7968 19334 16.0" 
$ns at 718.2033158807243 "$node_(75) setdest 119550 7986 18.0" 
$ns at 788.3018968489704 "$node_(75) setdest 99443 19323 2.0" 
$ns at 823.4639277523722 "$node_(75) setdest 179656 72555 1.0" 
$ns at 861.9255430365807 "$node_(75) setdest 259073 69320 1.0" 
$ns at 893.8546303913987 "$node_(75) setdest 111991 905 10.0" 
$ns at 0.0 "$node_(76) setdest 39617 28527 9.0" 
$ns at 83.25636499533769 "$node_(76) setdest 66398 13603 5.0" 
$ns at 128.7575526414978 "$node_(76) setdest 11658 5775 14.0" 
$ns at 189.34568632653017 "$node_(76) setdest 108410 22220 19.0" 
$ns at 371.8120819306498 "$node_(76) setdest 124990 3124 10.0" 
$ns at 493.5398270498457 "$node_(76) setdest 114975 34300 1.0" 
$ns at 533.0416553221472 "$node_(76) setdest 122075 6515 5.0" 
$ns at 593.3043920401286 "$node_(76) setdest 7049 8248 1.0" 
$ns at 631.3333360107965 "$node_(76) setdest 77485 74271 14.0" 
$ns at 713.0912657302076 "$node_(76) setdest 133679 55798 8.0" 
$ns at 745.9324704362946 "$node_(76) setdest 94041 51711 6.0" 
$ns at 821.0213112445705 "$node_(76) setdest 225125 16871 17.0" 
$ns at 0.0 "$node_(77) setdest 53738 66 17.0" 
$ns at 122.96939370011293 "$node_(77) setdest 12369 4477 10.0" 
$ns at 218.72675866375 "$node_(77) setdest 67866 13420 2.0" 
$ns at 262.92300667901424 "$node_(77) setdest 67646 37162 9.0" 
$ns at 308.9301392351874 "$node_(77) setdest 69511 23068 11.0" 
$ns at 359.44498073485073 "$node_(77) setdest 167392 32778 11.0" 
$ns at 392.69761009897906 "$node_(77) setdest 127478 25085 14.0" 
$ns at 529.7386488069952 "$node_(77) setdest 181629 61656 13.0" 
$ns at 677.0219935628935 "$node_(77) setdest 11551 62003 2.0" 
$ns at 712.396825557772 "$node_(77) setdest 24202 4706 8.0" 
$ns at 809.2874332829698 "$node_(77) setdest 109687 3735 6.0" 
$ns at 880.3797770757083 "$node_(77) setdest 181073 61608 11.0" 
$ns at 0.0 "$node_(78) setdest 35577 9357 12.0" 
$ns at 35.371586090855665 "$node_(78) setdest 68581 19283 4.0" 
$ns at 70.72584667689277 "$node_(78) setdest 3172 24203 12.0" 
$ns at 119.1353243697299 "$node_(78) setdest 65028 29234 4.0" 
$ns at 155.84572105160203 "$node_(78) setdest 127122 16464 20.0" 
$ns at 284.0347914228501 "$node_(78) setdest 154564 44437 12.0" 
$ns at 350.34937137643976 "$node_(78) setdest 175171 55440 6.0" 
$ns at 432.62074522291647 "$node_(78) setdest 170783 62603 11.0" 
$ns at 509.94741552430975 "$node_(78) setdest 59850 31200 8.0" 
$ns at 595.0619721352323 "$node_(78) setdest 221209 76930 14.0" 
$ns at 701.7401045467437 "$node_(78) setdest 157570 17617 12.0" 
$ns at 832.2872390541679 "$node_(78) setdest 230803 57197 15.0" 
$ns at 0.0 "$node_(79) setdest 32624 2071 11.0" 
$ns at 99.45903072539836 "$node_(79) setdest 45894 10980 1.0" 
$ns at 133.98551233927213 "$node_(79) setdest 29665 23354 12.0" 
$ns at 200.9593937445953 "$node_(79) setdest 124607 8413 7.0" 
$ns at 290.65061578847707 "$node_(79) setdest 97177 45855 5.0" 
$ns at 368.3449112257399 "$node_(79) setdest 94165 52059 17.0" 
$ns at 412.4488781016003 "$node_(79) setdest 6716 34212 5.0" 
$ns at 488.6161452474727 "$node_(79) setdest 8555 50580 13.0" 
$ns at 618.4940047702543 "$node_(79) setdest 24689 76775 8.0" 
$ns at 655.830606264569 "$node_(79) setdest 150139 22135 14.0" 
$ns at 705.5074802036379 "$node_(79) setdest 88575 53896 16.0" 
$ns at 818.6646445266229 "$node_(79) setdest 109175 67843 17.0" 
$ns at 0.0 "$node_(80) setdest 28865 3360 9.0" 
$ns at 62.72235278834138 "$node_(80) setdest 63477 8983 9.0" 
$ns at 152.9259847742517 "$node_(80) setdest 102186 9857 10.0" 
$ns at 194.0901055715599 "$node_(80) setdest 91442 44471 12.0" 
$ns at 314.21701401252324 "$node_(80) setdest 119782 23256 15.0" 
$ns at 416.26761976572783 "$node_(80) setdest 35921 23766 4.0" 
$ns at 478.63852168578643 "$node_(80) setdest 99589 46010 13.0" 
$ns at 580.2663759533384 "$node_(80) setdest 18417 31640 19.0" 
$ns at 612.7811163257998 "$node_(80) setdest 99195 21977 12.0" 
$ns at 760.3432223578639 "$node_(80) setdest 208241 68590 15.0" 
$ns at 806.4202445600645 "$node_(80) setdest 268166 85088 8.0" 
$ns at 865.4066913269123 "$node_(80) setdest 255971 40498 2.0" 
$ns at 0.0 "$node_(81) setdest 38418 5128 8.0" 
$ns at 36.93733202097163 "$node_(81) setdest 40531 16028 5.0" 
$ns at 110.45038498264043 "$node_(81) setdest 11923 2015 8.0" 
$ns at 160.75509214110662 "$node_(81) setdest 44739 30960 6.0" 
$ns at 235.30730071844772 "$node_(81) setdest 89912 37491 6.0" 
$ns at 295.3192662916087 "$node_(81) setdest 159699 16191 7.0" 
$ns at 330.6734308970762 "$node_(81) setdest 105446 27785 5.0" 
$ns at 400.8622053066852 "$node_(81) setdest 172848 27772 16.0" 
$ns at 589.4745949910125 "$node_(81) setdest 81523 12594 16.0" 
$ns at 716.2160609490221 "$node_(81) setdest 57214 45949 19.0" 
$ns at 809.5496127631005 "$node_(81) setdest 123459 80110 6.0" 
$ns at 888.9461732272339 "$node_(81) setdest 266646 78296 14.0" 
$ns at 0.0 "$node_(82) setdest 37966 29811 4.0" 
$ns at 54.324290460911726 "$node_(82) setdest 34794 6464 2.0" 
$ns at 92.07814103743478 "$node_(82) setdest 51666 25814 12.0" 
$ns at 229.39204660004611 "$node_(82) setdest 121901 7339 15.0" 
$ns at 373.6638558833544 "$node_(82) setdest 72488 27989 16.0" 
$ns at 420.61091061217746 "$node_(82) setdest 186869 48148 11.0" 
$ns at 526.1339055952574 "$node_(82) setdest 36977 40545 11.0" 
$ns at 620.3424187250001 "$node_(82) setdest 84790 3758 11.0" 
$ns at 709.8892382936212 "$node_(82) setdest 210391 83159 16.0" 
$ns at 831.0883302685318 "$node_(82) setdest 102701 5732 16.0" 
$ns at 0.0 "$node_(83) setdest 3762 9289 15.0" 
$ns at 154.98537015475193 "$node_(83) setdest 36762 19662 4.0" 
$ns at 223.56815954634544 "$node_(83) setdest 99043 9932 9.0" 
$ns at 277.3347905035083 "$node_(83) setdest 90438 17553 5.0" 
$ns at 308.64470726777745 "$node_(83) setdest 110190 49099 8.0" 
$ns at 340.63228131557264 "$node_(83) setdest 86479 26955 11.0" 
$ns at 454.3674961744836 "$node_(83) setdest 108387 27150 5.0" 
$ns at 488.60183398846414 "$node_(83) setdest 76427 60739 2.0" 
$ns at 522.9776142621768 "$node_(83) setdest 147803 30072 14.0" 
$ns at 584.089754646578 "$node_(83) setdest 52225 51763 1.0" 
$ns at 619.7621952691622 "$node_(83) setdest 36770 24804 15.0" 
$ns at 773.948123319235 "$node_(83) setdest 125338 11159 14.0" 
$ns at 865.0525015439613 "$node_(83) setdest 117963 21908 6.0" 
$ns at 0.0 "$node_(84) setdest 83091 9186 17.0" 
$ns at 140.7514215237921 "$node_(84) setdest 90192 16450 15.0" 
$ns at 228.03388129962252 "$node_(84) setdest 55626 18500 1.0" 
$ns at 266.18036651292425 "$node_(84) setdest 55340 32864 13.0" 
$ns at 423.08651708433354 "$node_(84) setdest 7123 5190 13.0" 
$ns at 510.7062646186399 "$node_(84) setdest 43577 56596 6.0" 
$ns at 561.4160791666295 "$node_(84) setdest 104449 65418 17.0" 
$ns at 696.7334709836547 "$node_(84) setdest 175240 3151 17.0" 
$ns at 846.046638184564 "$node_(84) setdest 247913 17530 2.0" 
$ns at 883.2565666649732 "$node_(84) setdest 173255 8586 9.0" 
$ns at 0.0 "$node_(85) setdest 51439 2207 9.0" 
$ns at 44.769459094345805 "$node_(85) setdest 27924 6115 16.0" 
$ns at 152.29965891094966 "$node_(85) setdest 62697 10389 9.0" 
$ns at 221.81425214529148 "$node_(85) setdest 113078 38727 10.0" 
$ns at 265.43068868595526 "$node_(85) setdest 18919 12287 9.0" 
$ns at 365.20851212011326 "$node_(85) setdest 52521 27829 4.0" 
$ns at 417.98124656219454 "$node_(85) setdest 63975 47024 2.0" 
$ns at 453.22662066675286 "$node_(85) setdest 50927 43214 17.0" 
$ns at 523.8123984117559 "$node_(85) setdest 207311 43325 19.0" 
$ns at 613.0132760863768 "$node_(85) setdest 216203 69731 6.0" 
$ns at 644.3536300160519 "$node_(85) setdest 96688 56429 5.0" 
$ns at 708.9413039626334 "$node_(85) setdest 64848 483 13.0" 
$ns at 806.2073950806963 "$node_(85) setdest 259313 56757 1.0" 
$ns at 843.5220684634796 "$node_(85) setdest 203279 28802 10.0" 
$ns at 893.8193191871076 "$node_(85) setdest 62442 54963 8.0" 
$ns at 0.0 "$node_(86) setdest 93377 4502 19.0" 
$ns at 86.97233105816055 "$node_(86) setdest 75712 14178 13.0" 
$ns at 144.64599508479688 "$node_(86) setdest 37470 10049 4.0" 
$ns at 191.09763233421597 "$node_(86) setdest 114298 10180 9.0" 
$ns at 238.7626277736632 "$node_(86) setdest 126113 17424 12.0" 
$ns at 301.8016291300461 "$node_(86) setdest 102154 47835 3.0" 
$ns at 341.4966632205471 "$node_(86) setdest 141591 25543 1.0" 
$ns at 373.6115480839794 "$node_(86) setdest 136961 15898 11.0" 
$ns at 422.55300828457996 "$node_(86) setdest 82565 23013 17.0" 
$ns at 468.47290471040037 "$node_(86) setdest 166211 2117 18.0" 
$ns at 631.6757933735237 "$node_(86) setdest 148701 60315 10.0" 
$ns at 754.7814453832801 "$node_(86) setdest 262407 60246 16.0" 
$ns at 884.4369412164694 "$node_(86) setdest 256 45948 8.0" 
$ns at 0.0 "$node_(87) setdest 28172 6900 15.0" 
$ns at 33.45441550950588 "$node_(87) setdest 8279 834 20.0" 
$ns at 230.60260045721537 "$node_(87) setdest 94473 32274 1.0" 
$ns at 268.47901114101074 "$node_(87) setdest 66732 44795 1.0" 
$ns at 305.815695818098 "$node_(87) setdest 85367 29287 12.0" 
$ns at 448.1571197386737 "$node_(87) setdest 129306 27446 4.0" 
$ns at 497.36835024500874 "$node_(87) setdest 138129 55591 6.0" 
$ns at 550.429244383558 "$node_(87) setdest 175434 7461 10.0" 
$ns at 581.1707011050227 "$node_(87) setdest 124829 56373 14.0" 
$ns at 726.1098118533209 "$node_(87) setdest 149837 19582 1.0" 
$ns at 763.4590912840434 "$node_(87) setdest 244551 74453 20.0" 
$ns at 0.0 "$node_(88) setdest 15884 13755 3.0" 
$ns at 51.18426167490857 "$node_(88) setdest 71669 25006 19.0" 
$ns at 180.08791379309923 "$node_(88) setdest 15190 26210 16.0" 
$ns at 368.1276441912636 "$node_(88) setdest 9769 50636 3.0" 
$ns at 426.7391379787175 "$node_(88) setdest 102709 14112 17.0" 
$ns at 569.9951860283131 "$node_(88) setdest 45958 61483 5.0" 
$ns at 617.7055497010349 "$node_(88) setdest 82661 27738 15.0" 
$ns at 651.1111459979173 "$node_(88) setdest 50549 41353 16.0" 
$ns at 726.3026728342634 "$node_(88) setdest 224979 25502 10.0" 
$ns at 828.1617622793362 "$node_(88) setdest 2854 40577 13.0" 
$ns at 0.0 "$node_(89) setdest 82383 8600 2.0" 
$ns at 31.47033271243616 "$node_(89) setdest 56990 14441 5.0" 
$ns at 83.03613508236504 "$node_(89) setdest 75921 23491 14.0" 
$ns at 220.57076158536665 "$node_(89) setdest 90699 42146 8.0" 
$ns at 273.52317822934486 "$node_(89) setdest 85185 49942 11.0" 
$ns at 364.38756329489115 "$node_(89) setdest 19371 21242 6.0" 
$ns at 398.40047084875255 "$node_(89) setdest 71585 44054 16.0" 
$ns at 556.156226664001 "$node_(89) setdest 100089 33574 6.0" 
$ns at 639.5559110044516 "$node_(89) setdest 54121 7426 20.0" 
$ns at 861.5656402572826 "$node_(89) setdest 35266 21275 15.0" 
$ns at 0.0 "$node_(90) setdest 37763 28860 17.0" 
$ns at 81.53211686386011 "$node_(90) setdest 37245 28035 5.0" 
$ns at 158.5467883914207 "$node_(90) setdest 9073 4977 14.0" 
$ns at 252.62750213200673 "$node_(90) setdest 99480 31113 15.0" 
$ns at 378.36089927390026 "$node_(90) setdest 180652 20827 19.0" 
$ns at 530.3059314289374 "$node_(90) setdest 189680 40381 12.0" 
$ns at 624.8010719562589 "$node_(90) setdest 25069 24213 19.0" 
$ns at 775.1367538639752 "$node_(90) setdest 82076 77001 1.0" 
$ns at 813.1778943595483 "$node_(90) setdest 54240 26272 9.0" 
$ns at 0.0 "$node_(91) setdest 49605 26157 17.0" 
$ns at 59.31337412064979 "$node_(91) setdest 66525 18443 19.0" 
$ns at 265.9648544014235 "$node_(91) setdest 34712 5372 12.0" 
$ns at 308.0649111711987 "$node_(91) setdest 118351 48896 8.0" 
$ns at 355.01250735127434 "$node_(91) setdest 69956 35763 11.0" 
$ns at 391.355056161369 "$node_(91) setdest 99123 10139 5.0" 
$ns at 434.0590716670931 "$node_(91) setdest 54083 932 16.0" 
$ns at 567.0409363607639 "$node_(91) setdest 210640 69467 9.0" 
$ns at 656.8492627858074 "$node_(91) setdest 245608 430 16.0" 
$ns at 768.147839504748 "$node_(91) setdest 260332 28892 11.0" 
$ns at 826.9894266167219 "$node_(91) setdest 59401 79963 2.0" 
$ns at 862.3114136919015 "$node_(91) setdest 265354 73115 6.0" 
$ns at 0.0 "$node_(92) setdest 49118 4745 7.0" 
$ns at 91.11633639363113 "$node_(92) setdest 37593 14032 15.0" 
$ns at 243.92567501918955 "$node_(92) setdest 86872 15652 5.0" 
$ns at 282.16590306448643 "$node_(92) setdest 17505 31637 17.0" 
$ns at 384.1942651440465 "$node_(92) setdest 121212 31826 17.0" 
$ns at 502.3839170297688 "$node_(92) setdest 141323 63843 14.0" 
$ns at 551.0042679327283 "$node_(92) setdest 65860 46383 4.0" 
$ns at 614.7965039872943 "$node_(92) setdest 226169 22901 5.0" 
$ns at 647.9299215798859 "$node_(92) setdest 129409 40252 11.0" 
$ns at 717.7014049338002 "$node_(92) setdest 138669 30699 19.0" 
$ns at 761.1353302252928 "$node_(92) setdest 149839 64228 1.0" 
$ns at 799.794073204538 "$node_(92) setdest 167640 61036 19.0" 
$ns at 0.0 "$node_(93) setdest 78955 9408 19.0" 
$ns at 115.93494723997945 "$node_(93) setdest 43580 29397 4.0" 
$ns at 151.58874311091589 "$node_(93) setdest 24792 17650 1.0" 
$ns at 190.48399886109183 "$node_(93) setdest 100180 24667 4.0" 
$ns at 240.2285443461189 "$node_(93) setdest 48332 323 20.0" 
$ns at 292.4415320527612 "$node_(93) setdest 161055 33768 1.0" 
$ns at 329.05644224133573 "$node_(93) setdest 30965 36182 16.0" 
$ns at 443.34911872011594 "$node_(93) setdest 16227 59670 14.0" 
$ns at 608.3673728972165 "$node_(93) setdest 15745 43331 7.0" 
$ns at 646.277286396672 "$node_(93) setdest 182645 58315 3.0" 
$ns at 694.0910143831419 "$node_(93) setdest 225056 9818 4.0" 
$ns at 743.5709608915864 "$node_(93) setdest 110670 30282 15.0" 
$ns at 0.0 "$node_(94) setdest 77509 333 4.0" 
$ns at 46.98740411525432 "$node_(94) setdest 32932 21965 12.0" 
$ns at 144.40012651874576 "$node_(94) setdest 36307 4695 12.0" 
$ns at 237.61160990687063 "$node_(94) setdest 99342 27935 14.0" 
$ns at 406.89034861974744 "$node_(94) setdest 3100 13112 1.0" 
$ns at 446.8049705326676 "$node_(94) setdest 187099 26744 1.0" 
$ns at 482.2092397456483 "$node_(94) setdest 184091 43862 14.0" 
$ns at 610.2815629515586 "$node_(94) setdest 161787 64025 6.0" 
$ns at 658.7008078599769 "$node_(94) setdest 109905 14143 15.0" 
$ns at 700.0190982447972 "$node_(94) setdest 191435 41973 1.0" 
$ns at 737.2448024929294 "$node_(94) setdest 145515 47792 1.0" 
$ns at 771.3573939409315 "$node_(94) setdest 145850 82003 3.0" 
$ns at 805.4935625182021 "$node_(94) setdest 199218 63361 7.0" 
$ns at 880.6016337602362 "$node_(94) setdest 185505 80386 7.0" 
$ns at 0.0 "$node_(95) setdest 53957 12300 15.0" 
$ns at 144.3456873492367 "$node_(95) setdest 34310 12295 16.0" 
$ns at 311.2825788848338 "$node_(95) setdest 34735 43299 8.0" 
$ns at 366.1828458978933 "$node_(95) setdest 149931 10742 14.0" 
$ns at 534.2750441557527 "$node_(95) setdest 207978 69037 1.0" 
$ns at 571.372847709743 "$node_(95) setdest 110719 45193 3.0" 
$ns at 605.5223880943832 "$node_(95) setdest 43088 10093 3.0" 
$ns at 645.2594956533623 "$node_(95) setdest 107483 39217 16.0" 
$ns at 803.4203236299795 "$node_(95) setdest 76607 36234 3.0" 
$ns at 848.8974610025126 "$node_(95) setdest 119474 9484 17.0" 
$ns at 0.0 "$node_(96) setdest 67407 16695 15.0" 
$ns at 46.45231773468806 "$node_(96) setdest 67344 4607 6.0" 
$ns at 91.34848272667286 "$node_(96) setdest 91728 17658 15.0" 
$ns at 121.80520176812743 "$node_(96) setdest 11726 27070 3.0" 
$ns at 154.5565427575222 "$node_(96) setdest 119533 19809 16.0" 
$ns at 322.2591257641544 "$node_(96) setdest 111312 35386 6.0" 
$ns at 397.7337006194381 "$node_(96) setdest 31038 16506 16.0" 
$ns at 445.1029853114879 "$node_(96) setdest 59605 10771 10.0" 
$ns at 556.436049602739 "$node_(96) setdest 104356 23715 1.0" 
$ns at 593.2655703717049 "$node_(96) setdest 7294 40529 17.0" 
$ns at 770.6697239860777 "$node_(96) setdest 207038 35630 6.0" 
$ns at 815.0944560121039 "$node_(96) setdest 133473 51848 14.0" 
$ns at 0.0 "$node_(97) setdest 94157 2223 10.0" 
$ns at 108.70841409527556 "$node_(97) setdest 63405 23761 3.0" 
$ns at 148.22422886599765 "$node_(97) setdest 47625 16558 4.0" 
$ns at 215.56777451427004 "$node_(97) setdest 19432 30350 17.0" 
$ns at 318.6773986605964 "$node_(97) setdest 80195 27313 1.0" 
$ns at 351.0050411514624 "$node_(97) setdest 48703 39660 19.0" 
$ns at 443.0407997577022 "$node_(97) setdest 75151 28645 16.0" 
$ns at 522.2033622634734 "$node_(97) setdest 24085 43031 14.0" 
$ns at 634.0648495908978 "$node_(97) setdest 102897 53612 8.0" 
$ns at 721.9889713019277 "$node_(97) setdest 27607 41529 7.0" 
$ns at 789.6861134343167 "$node_(97) setdest 79747 31225 18.0" 
$ns at 0.0 "$node_(98) setdest 59139 20673 17.0" 
$ns at 123.6666003543127 "$node_(98) setdest 27720 11208 13.0" 
$ns at 277.841683642102 "$node_(98) setdest 146665 46301 6.0" 
$ns at 316.61491719645574 "$node_(98) setdest 128183 43469 8.0" 
$ns at 414.00661432708876 "$node_(98) setdest 59948 28549 10.0" 
$ns at 477.16414674009025 "$node_(98) setdest 105049 20910 20.0" 
$ns at 508.61621219848644 "$node_(98) setdest 139366 17952 2.0" 
$ns at 552.4543775296848 "$node_(98) setdest 8578 26864 5.0" 
$ns at 606.8936149396208 "$node_(98) setdest 208108 24347 18.0" 
$ns at 652.7873082495913 "$node_(98) setdest 209937 56431 6.0" 
$ns at 700.5214250267575 "$node_(98) setdest 179081 59628 6.0" 
$ns at 733.1046638735834 "$node_(98) setdest 55326 8053 8.0" 
$ns at 787.5352307636675 "$node_(98) setdest 228688 14947 8.0" 
$ns at 828.9831907584878 "$node_(98) setdest 116786 42721 15.0" 
$ns at 0.0 "$node_(99) setdest 78899 25413 12.0" 
$ns at 35.251644126375666 "$node_(99) setdest 70601 21936 7.0" 
$ns at 80.47346364791522 "$node_(99) setdest 72769 18839 4.0" 
$ns at 146.67358710694023 "$node_(99) setdest 91279 23366 15.0" 
$ns at 244.67768326204092 "$node_(99) setdest 36773 10880 4.0" 
$ns at 288.3612908253467 "$node_(99) setdest 6554 20810 7.0" 
$ns at 338.93954754308544 "$node_(99) setdest 114834 27941 11.0" 
$ns at 393.4473776196283 "$node_(99) setdest 106626 62965 4.0" 
$ns at 425.94301350724936 "$node_(99) setdest 30701 18342 8.0" 
$ns at 527.3922262978913 "$node_(99) setdest 57571 35244 7.0" 
$ns at 614.111530080076 "$node_(99) setdest 35725 71297 20.0" 
$ns at 776.8141485742947 "$node_(99) setdest 264035 43236 2.0" 
$ns at 809.5553528730568 "$node_(99) setdest 180348 45965 20.0" 
$ns at 0.0 "$node_(100) setdest 67922 44568 11.0" 
$ns at 42.26298040744541 "$node_(100) setdest 18255 14582 17.0" 
$ns at 109.09632370440485 "$node_(100) setdest 39797 18024 19.0" 
$ns at 187.0743065678458 "$node_(100) setdest 76234 19246 9.0" 
$ns at 294.26685291078854 "$node_(100) setdest 138676 22779 17.0" 
$ns at 456.31025095834195 "$node_(100) setdest 165833 15452 10.0" 
$ns at 578.7409293576899 "$node_(100) setdest 126861 71739 5.0" 
$ns at 637.1940820828038 "$node_(100) setdest 130349 38483 6.0" 
$ns at 709.5082605467782 "$node_(100) setdest 309 72789 8.0" 
$ns at 786.2399359696916 "$node_(100) setdest 19699 17630 7.0" 
$ns at 881.8176891997905 "$node_(100) setdest 74692 83710 8.0" 
$ns at 103.81484156140141 "$node_(101) setdest 81067 16166 19.0" 
$ns at 281.3805153959827 "$node_(101) setdest 22636 10855 10.0" 
$ns at 360.83605638056076 "$node_(101) setdest 138107 53411 8.0" 
$ns at 450.08023865921325 "$node_(101) setdest 87461 10103 13.0" 
$ns at 566.0151857618641 "$node_(101) setdest 102096 76313 10.0" 
$ns at 608.8684619931608 "$node_(101) setdest 145186 26149 15.0" 
$ns at 689.1414451967145 "$node_(101) setdest 217622 12111 17.0" 
$ns at 773.8453101500414 "$node_(101) setdest 89817 36134 14.0" 
$ns at 896.782447919825 "$node_(101) setdest 243319 33459 13.0" 
$ns at 210.6343312226275 "$node_(102) setdest 3895 31955 18.0" 
$ns at 308.0788717873677 "$node_(102) setdest 153960 6994 11.0" 
$ns at 345.6590024864337 "$node_(102) setdest 153408 40502 3.0" 
$ns at 397.4666909080309 "$node_(102) setdest 67033 7336 5.0" 
$ns at 435.93477792467024 "$node_(102) setdest 93194 57422 1.0" 
$ns at 470.0310715679513 "$node_(102) setdest 23231 34161 18.0" 
$ns at 621.1005931102867 "$node_(102) setdest 54437 23143 2.0" 
$ns at 668.447837363233 "$node_(102) setdest 210851 68950 17.0" 
$ns at 764.7403890209201 "$node_(102) setdest 82578 32989 19.0" 
$ns at 819.36449766528 "$node_(102) setdest 196194 78054 1.0" 
$ns at 851.4108263523723 "$node_(102) setdest 66572 50793 19.0" 
$ns at 112.80169719140153 "$node_(103) setdest 58852 25929 6.0" 
$ns at 150.10215892159698 "$node_(103) setdest 107659 29574 11.0" 
$ns at 197.1985090153596 "$node_(103) setdest 76180 36983 8.0" 
$ns at 266.24805388561333 "$node_(103) setdest 41327 54242 16.0" 
$ns at 381.72464186146294 "$node_(103) setdest 66172 52136 13.0" 
$ns at 493.30275577117214 "$node_(103) setdest 52269 57035 9.0" 
$ns at 582.7594677385189 "$node_(103) setdest 122063 32884 1.0" 
$ns at 613.0316115417766 "$node_(103) setdest 194904 65900 4.0" 
$ns at 678.7266674433672 "$node_(103) setdest 110428 61381 8.0" 
$ns at 736.3346952161395 "$node_(103) setdest 101506 40131 14.0" 
$ns at 790.3031120024151 "$node_(103) setdest 127087 26129 7.0" 
$ns at 878.12530833209 "$node_(103) setdest 62395 24530 11.0" 
$ns at 127.07420046475735 "$node_(104) setdest 85616 8328 14.0" 
$ns at 216.07471882571582 "$node_(104) setdest 61147 2452 9.0" 
$ns at 258.7090232622771 "$node_(104) setdest 54611 8779 5.0" 
$ns at 335.45070825831846 "$node_(104) setdest 26912 38031 8.0" 
$ns at 430.41507809859706 "$node_(104) setdest 95798 3757 3.0" 
$ns at 477.47329291371244 "$node_(104) setdest 79194 6716 5.0" 
$ns at 548.4106572422002 "$node_(104) setdest 181995 11758 7.0" 
$ns at 632.7309696102112 "$node_(104) setdest 225101 22924 4.0" 
$ns at 688.5128175267131 "$node_(104) setdest 140823 30280 2.0" 
$ns at 735.4927229009411 "$node_(104) setdest 184752 38487 16.0" 
$ns at 823.0427340686442 "$node_(104) setdest 158352 68047 5.0" 
$ns at 855.7892186429169 "$node_(104) setdest 152723 51714 3.0" 
$ns at 897.8682842683443 "$node_(104) setdest 259537 81502 18.0" 
$ns at 177.51247082952924 "$node_(105) setdest 5160 16882 10.0" 
$ns at 288.30673552647465 "$node_(105) setdest 137536 51180 17.0" 
$ns at 427.666399251255 "$node_(105) setdest 14021 5431 3.0" 
$ns at 460.7338759379909 "$node_(105) setdest 125912 742 14.0" 
$ns at 606.5460093704601 "$node_(105) setdest 186305 76267 9.0" 
$ns at 646.1928969705378 "$node_(105) setdest 40765 73951 10.0" 
$ns at 698.1755550177645 "$node_(105) setdest 47368 16277 10.0" 
$ns at 731.8850490725321 "$node_(105) setdest 225858 28536 20.0" 
$ns at 809.4598270251731 "$node_(105) setdest 187821 32795 10.0" 
$ns at 205.5512437763088 "$node_(106) setdest 35003 5721 15.0" 
$ns at 271.9974028688372 "$node_(106) setdest 99457 52446 5.0" 
$ns at 334.8213935148779 "$node_(106) setdest 47712 27655 5.0" 
$ns at 376.14101667273593 "$node_(106) setdest 152045 45930 19.0" 
$ns at 481.9795343940888 "$node_(106) setdest 143596 50115 11.0" 
$ns at 620.9725014611283 "$node_(106) setdest 204647 64723 2.0" 
$ns at 665.1859911589197 "$node_(106) setdest 183642 23628 5.0" 
$ns at 729.8683947891866 "$node_(106) setdest 128231 50717 4.0" 
$ns at 771.4205304179856 "$node_(106) setdest 265659 28845 6.0" 
$ns at 827.820046474514 "$node_(106) setdest 44339 59304 9.0" 
$ns at 164.06726895476555 "$node_(107) setdest 132012 5869 17.0" 
$ns at 229.60817934716633 "$node_(107) setdest 20919 13263 5.0" 
$ns at 261.32277947434693 "$node_(107) setdest 107938 24943 2.0" 
$ns at 295.476464300597 "$node_(107) setdest 19308 24852 18.0" 
$ns at 396.19153758939774 "$node_(107) setdest 53687 10079 15.0" 
$ns at 485.5693226343966 "$node_(107) setdest 203457 26384 7.0" 
$ns at 576.8982908545786 "$node_(107) setdest 200877 50238 18.0" 
$ns at 677.278449409064 "$node_(107) setdest 219732 62268 15.0" 
$ns at 770.5721486894242 "$node_(107) setdest 42417 39853 5.0" 
$ns at 850.4401509262044 "$node_(107) setdest 158076 59232 9.0" 
$ns at 893.7577213995265 "$node_(107) setdest 184656 2875 15.0" 
$ns at 104.07658676867959 "$node_(108) setdest 51247 29511 17.0" 
$ns at 283.78951128707365 "$node_(108) setdest 49078 42799 16.0" 
$ns at 324.1061936553103 "$node_(108) setdest 90097 23959 8.0" 
$ns at 374.06570793726473 "$node_(108) setdest 126377 59260 10.0" 
$ns at 447.2417052097438 "$node_(108) setdest 140420 37872 3.0" 
$ns at 501.37814230547013 "$node_(108) setdest 51218 54801 7.0" 
$ns at 573.4355205199121 "$node_(108) setdest 35195 32056 17.0" 
$ns at 632.5529598701704 "$node_(108) setdest 209868 48358 11.0" 
$ns at 755.9356154667516 "$node_(108) setdest 100792 28527 15.0" 
$ns at 111.82975142433656 "$node_(109) setdest 570 30846 14.0" 
$ns at 247.2519186128394 "$node_(109) setdest 32862 9489 18.0" 
$ns at 370.2232990481894 "$node_(109) setdest 115953 25131 9.0" 
$ns at 419.36862213391873 "$node_(109) setdest 76164 17878 5.0" 
$ns at 481.94616669744545 "$node_(109) setdest 206375 21113 19.0" 
$ns at 637.2273308257451 "$node_(109) setdest 169289 13420 4.0" 
$ns at 704.6015268429979 "$node_(109) setdest 78177 49912 14.0" 
$ns at 821.0650487898112 "$node_(109) setdest 197807 7412 7.0" 
$ns at 888.4123305360968 "$node_(109) setdest 254536 84891 6.0" 
$ns at 137.00121904453346 "$node_(110) setdest 15552 17060 19.0" 
$ns at 176.47080814634757 "$node_(110) setdest 54315 32427 1.0" 
$ns at 208.48204827483596 "$node_(110) setdest 92793 15113 7.0" 
$ns at 266.47709926327525 "$node_(110) setdest 15901 27349 20.0" 
$ns at 377.7124101638468 "$node_(110) setdest 89219 14800 9.0" 
$ns at 484.7544656971665 "$node_(110) setdest 53365 56691 1.0" 
$ns at 523.6023540641393 "$node_(110) setdest 107921 48402 1.0" 
$ns at 563.2073571950261 "$node_(110) setdest 61309 3242 17.0" 
$ns at 690.2390491928824 "$node_(110) setdest 246713 64527 18.0" 
$ns at 843.3776335051587 "$node_(110) setdest 223050 70892 16.0" 
$ns at 135.33052419095424 "$node_(111) setdest 70656 25485 18.0" 
$ns at 171.41673545452852 "$node_(111) setdest 7634 8449 1.0" 
$ns at 203.92774536011552 "$node_(111) setdest 51873 6065 4.0" 
$ns at 250.1184600877069 "$node_(111) setdest 18312 14353 7.0" 
$ns at 304.3035847585111 "$node_(111) setdest 92378 23685 9.0" 
$ns at 400.898951545857 "$node_(111) setdest 38396 43552 17.0" 
$ns at 496.00517201993 "$node_(111) setdest 160594 31549 12.0" 
$ns at 582.7109184202566 "$node_(111) setdest 154572 14271 15.0" 
$ns at 657.0454354261537 "$node_(111) setdest 207603 17810 11.0" 
$ns at 751.1413711415718 "$node_(111) setdest 33423 54934 4.0" 
$ns at 791.3779291884048 "$node_(111) setdest 161222 10954 11.0" 
$ns at 866.9945382345809 "$node_(111) setdest 136044 47771 6.0" 
$ns at 196.03146755454273 "$node_(112) setdest 22541 22386 1.0" 
$ns at 229.9587322228519 "$node_(112) setdest 59018 5921 12.0" 
$ns at 324.04107692617276 "$node_(112) setdest 56118 13466 7.0" 
$ns at 359.2929749309701 "$node_(112) setdest 73182 51118 18.0" 
$ns at 463.71069720496115 "$node_(112) setdest 97154 44152 1.0" 
$ns at 495.10165562109665 "$node_(112) setdest 71124 58441 11.0" 
$ns at 548.9129625700084 "$node_(112) setdest 155498 8667 6.0" 
$ns at 636.0931912132643 "$node_(112) setdest 24190 18633 10.0" 
$ns at 691.5693930414701 "$node_(112) setdest 175327 45785 19.0" 
$ns at 848.3603890366493 "$node_(112) setdest 157142 46787 1.0" 
$ns at 881.8962970005 "$node_(112) setdest 117760 56293 11.0" 
$ns at 190.04693697988475 "$node_(113) setdest 68966 31733 11.0" 
$ns at 276.14372324265577 "$node_(113) setdest 132426 29207 17.0" 
$ns at 368.3089439902831 "$node_(113) setdest 179100 23536 17.0" 
$ns at 399.3763849186488 "$node_(113) setdest 148303 25377 1.0" 
$ns at 429.5748588970006 "$node_(113) setdest 45690 60923 1.0" 
$ns at 466.4715342696428 "$node_(113) setdest 191568 16595 12.0" 
$ns at 600.1365474425759 "$node_(113) setdest 124402 33809 3.0" 
$ns at 647.6800198189208 "$node_(113) setdest 41833 22031 14.0" 
$ns at 695.6607077965862 "$node_(113) setdest 127279 79417 15.0" 
$ns at 820.648593011104 "$node_(113) setdest 26751 47231 12.0" 
$ns at 254.26578291460552 "$node_(114) setdest 119344 53423 13.0" 
$ns at 345.0894569552727 "$node_(114) setdest 134273 28128 18.0" 
$ns at 421.7956365255357 "$node_(114) setdest 34867 59031 1.0" 
$ns at 457.51389487498756 "$node_(114) setdest 78113 43911 19.0" 
$ns at 552.9804535528217 "$node_(114) setdest 73667 30454 11.0" 
$ns at 601.8482958891013 "$node_(114) setdest 120498 52392 1.0" 
$ns at 632.9188245798533 "$node_(114) setdest 165448 63381 10.0" 
$ns at 721.4677989758648 "$node_(114) setdest 90581 74534 3.0" 
$ns at 756.2727682536324 "$node_(114) setdest 250684 85221 5.0" 
$ns at 827.6514864450464 "$node_(114) setdest 212514 44612 9.0" 
$ns at 895.3050319850781 "$node_(114) setdest 35838 66648 12.0" 
$ns at 135.96130573339238 "$node_(115) setdest 40586 11079 16.0" 
$ns at 263.5316494523091 "$node_(115) setdest 96543 15722 14.0" 
$ns at 358.1789783134199 "$node_(115) setdest 16549 33583 3.0" 
$ns at 414.42247060663 "$node_(115) setdest 125457 53861 10.0" 
$ns at 474.2880395542597 "$node_(115) setdest 67430 52864 11.0" 
$ns at 538.7325693096411 "$node_(115) setdest 146982 41484 3.0" 
$ns at 576.120361050303 "$node_(115) setdest 202987 42409 5.0" 
$ns at 627.1524361593215 "$node_(115) setdest 141085 61643 6.0" 
$ns at 698.8958840481232 "$node_(115) setdest 109787 80571 8.0" 
$ns at 774.1007849858036 "$node_(115) setdest 227469 70733 12.0" 
$ns at 841.8483310425207 "$node_(115) setdest 250550 67492 12.0" 
$ns at 108.11510409407634 "$node_(116) setdest 81649 10999 16.0" 
$ns at 204.1577849200113 "$node_(116) setdest 63149 1361 7.0" 
$ns at 303.1391905168262 "$node_(116) setdest 116681 7348 4.0" 
$ns at 363.17972681508525 "$node_(116) setdest 4404 34152 12.0" 
$ns at 498.74573979761493 "$node_(116) setdest 87818 47259 11.0" 
$ns at 616.7809889875398 "$node_(116) setdest 66726 61421 11.0" 
$ns at 678.4731112392942 "$node_(116) setdest 239451 16035 17.0" 
$ns at 816.9139461289003 "$node_(116) setdest 158852 3890 17.0" 
$ns at 126.88914202261704 "$node_(117) setdest 64498 12029 8.0" 
$ns at 210.73853899541052 "$node_(117) setdest 127093 32891 12.0" 
$ns at 357.2738171912157 "$node_(117) setdest 1561 2217 15.0" 
$ns at 515.0082625357431 "$node_(117) setdest 178929 39751 7.0" 
$ns at 558.6908137082249 "$node_(117) setdest 183714 32538 2.0" 
$ns at 590.8891338365814 "$node_(117) setdest 118168 75777 7.0" 
$ns at 622.8840672659915 "$node_(117) setdest 148221 42006 19.0" 
$ns at 699.021735576661 "$node_(117) setdest 67991 67069 2.0" 
$ns at 731.5233359454072 "$node_(117) setdest 229401 57355 17.0" 
$ns at 817.5775164024781 "$node_(117) setdest 26137 43598 16.0" 
$ns at 150.13587764051837 "$node_(118) setdest 12328 69 20.0" 
$ns at 191.64363098787427 "$node_(118) setdest 35241 42120 18.0" 
$ns at 317.5383434631169 "$node_(118) setdest 75564 50287 4.0" 
$ns at 358.44558278249565 "$node_(118) setdest 8109 35527 8.0" 
$ns at 415.77684062931587 "$node_(118) setdest 81169 704 2.0" 
$ns at 451.0519154796087 "$node_(118) setdest 146265 19750 15.0" 
$ns at 540.4647159837884 "$node_(118) setdest 181352 60784 13.0" 
$ns at 626.4684065658925 "$node_(118) setdest 21326 42286 3.0" 
$ns at 677.2146037131935 "$node_(118) setdest 132026 19713 15.0" 
$ns at 727.6645759896347 "$node_(118) setdest 217464 36422 17.0" 
$ns at 164.47945938159845 "$node_(119) setdest 6375 37566 16.0" 
$ns at 232.80557115393705 "$node_(119) setdest 56437 27043 3.0" 
$ns at 273.3078985895802 "$node_(119) setdest 128204 9525 9.0" 
$ns at 364.5904736388844 "$node_(119) setdest 53048 60137 8.0" 
$ns at 406.8679125885658 "$node_(119) setdest 35382 19998 8.0" 
$ns at 479.6696501025644 "$node_(119) setdest 112021 16831 16.0" 
$ns at 583.6260114698624 "$node_(119) setdest 135974 46396 19.0" 
$ns at 662.5593286017827 "$node_(119) setdest 170916 4637 1.0" 
$ns at 697.3714489285463 "$node_(119) setdest 30559 76406 5.0" 
$ns at 741.5388389570417 "$node_(119) setdest 116245 27487 11.0" 
$ns at 815.4380303928004 "$node_(119) setdest 134167 11184 3.0" 
$ns at 847.3656713713748 "$node_(119) setdest 136330 58643 19.0" 
$ns at 200.08674714322672 "$node_(120) setdest 16754 30057 18.0" 
$ns at 309.9070636354134 "$node_(120) setdest 60345 10506 13.0" 
$ns at 408.90775491253 "$node_(120) setdest 10217 55458 14.0" 
$ns at 552.9977198746983 "$node_(120) setdest 94839 54660 12.0" 
$ns at 633.678896667395 "$node_(120) setdest 36547 42693 16.0" 
$ns at 808.1617710644086 "$node_(120) setdest 115974 81057 10.0" 
$ns at 884.7907401232637 "$node_(120) setdest 11943 43498 18.0" 
$ns at 184.24179591703472 "$node_(121) setdest 6239 27101 16.0" 
$ns at 330.88013831403055 "$node_(121) setdest 102904 10584 4.0" 
$ns at 367.4138409385815 "$node_(121) setdest 21172 28729 4.0" 
$ns at 420.3628740261197 "$node_(121) setdest 83999 43464 11.0" 
$ns at 465.53877936905076 "$node_(121) setdest 118128 66510 15.0" 
$ns at 550.5451299562399 "$node_(121) setdest 86354 4419 3.0" 
$ns at 600.9768182601262 "$node_(121) setdest 8589 67860 14.0" 
$ns at 679.3291227480918 "$node_(121) setdest 224402 49305 1.0" 
$ns at 716.8552029584347 "$node_(121) setdest 185592 55456 2.0" 
$ns at 765.4819755532313 "$node_(121) setdest 16517 28178 12.0" 
$ns at 876.1456441039811 "$node_(121) setdest 238626 24205 12.0" 
$ns at 171.64595450045073 "$node_(122) setdest 61416 35956 1.0" 
$ns at 202.7381769745207 "$node_(122) setdest 68700 11616 7.0" 
$ns at 286.6367245274415 "$node_(122) setdest 6481 48320 10.0" 
$ns at 405.847575860433 "$node_(122) setdest 18412 289 3.0" 
$ns at 439.59793277045287 "$node_(122) setdest 52246 49058 1.0" 
$ns at 479.5782788512182 "$node_(122) setdest 81403 27686 4.0" 
$ns at 530.7941087732545 "$node_(122) setdest 180963 55350 10.0" 
$ns at 647.7179359183563 "$node_(122) setdest 17637 29892 10.0" 
$ns at 725.4613865855879 "$node_(122) setdest 212439 6526 16.0" 
$ns at 882.8382790195137 "$node_(122) setdest 244514 85798 19.0" 
$ns at 133.25012283197677 "$node_(123) setdest 70230 26083 8.0" 
$ns at 173.7602702611802 "$node_(123) setdest 40967 41753 6.0" 
$ns at 217.47863907896948 "$node_(123) setdest 123571 4509 14.0" 
$ns at 291.5076417530764 "$node_(123) setdest 128698 2716 19.0" 
$ns at 331.81814021123 "$node_(123) setdest 138283 2931 18.0" 
$ns at 419.7681422088227 "$node_(123) setdest 102082 32159 17.0" 
$ns at 475.23257851385137 "$node_(123) setdest 101057 41772 9.0" 
$ns at 591.6202973468494 "$node_(123) setdest 84584 26735 13.0" 
$ns at 719.3053505483557 "$node_(123) setdest 96433 72913 4.0" 
$ns at 757.1663034672624 "$node_(123) setdest 236654 67926 19.0" 
$ns at 887.9910869526477 "$node_(123) setdest 234663 50069 5.0" 
$ns at 217.85203279150932 "$node_(124) setdest 71384 40974 17.0" 
$ns at 392.74763762708716 "$node_(124) setdest 64658 5660 8.0" 
$ns at 494.88089025240345 "$node_(124) setdest 66840 7485 8.0" 
$ns at 537.0072250337853 "$node_(124) setdest 81473 24632 19.0" 
$ns at 736.8550274687855 "$node_(124) setdest 203043 62572 19.0" 
$ns at 826.5164663800555 "$node_(124) setdest 101867 88467 2.0" 
$ns at 866.3901828990043 "$node_(124) setdest 247256 28605 8.0" 
$ns at 140.6270400538245 "$node_(125) setdest 51213 26604 2.0" 
$ns at 186.63023147304878 "$node_(125) setdest 28178 36937 10.0" 
$ns at 235.89186389988538 "$node_(125) setdest 60295 14078 3.0" 
$ns at 276.46262240088004 "$node_(125) setdest 37272 42035 20.0" 
$ns at 309.6705676334543 "$node_(125) setdest 68586 35659 14.0" 
$ns at 422.85449609613187 "$node_(125) setdest 134799 25154 11.0" 
$ns at 466.1269334559949 "$node_(125) setdest 13354 24037 11.0" 
$ns at 564.2817879921985 "$node_(125) setdest 28087 75772 12.0" 
$ns at 713.785483498678 "$node_(125) setdest 173620 71459 17.0" 
$ns at 127.62827046792728 "$node_(126) setdest 88935 31609 8.0" 
$ns at 186.1464732563798 "$node_(126) setdest 20227 22909 17.0" 
$ns at 270.60988202606177 "$node_(126) setdest 143949 25596 3.0" 
$ns at 309.30460598582926 "$node_(126) setdest 80014 3155 2.0" 
$ns at 354.2203359766543 "$node_(126) setdest 150532 43277 3.0" 
$ns at 408.10083751851164 "$node_(126) setdest 61694 21513 1.0" 
$ns at 443.41415390644795 "$node_(126) setdest 132789 12028 11.0" 
$ns at 552.2632565981789 "$node_(126) setdest 142484 31383 14.0" 
$ns at 597.8114697488522 "$node_(126) setdest 144117 73033 17.0" 
$ns at 678.3837666692201 "$node_(126) setdest 103513 63957 18.0" 
$ns at 736.9285630587694 "$node_(126) setdest 184935 77335 7.0" 
$ns at 768.8590093056289 "$node_(126) setdest 121530 6990 19.0" 
$ns at 820.009232461045 "$node_(126) setdest 128315 19303 12.0" 
$ns at 138.53895684628048 "$node_(127) setdest 63090 13772 18.0" 
$ns at 340.347475479015 "$node_(127) setdest 82672 34475 16.0" 
$ns at 489.862668167092 "$node_(127) setdest 16413 48388 14.0" 
$ns at 601.8528437516875 "$node_(127) setdest 190408 43955 9.0" 
$ns at 633.7353559677925 "$node_(127) setdest 13166 30477 7.0" 
$ns at 706.9403417800133 "$node_(127) setdest 228281 18197 19.0" 
$ns at 858.0329686446064 "$node_(127) setdest 1388 64309 19.0" 
$ns at 171.4976726098594 "$node_(128) setdest 132873 27945 9.0" 
$ns at 238.96212647984845 "$node_(128) setdest 21683 3005 12.0" 
$ns at 321.34513540892846 "$node_(128) setdest 135996 39057 19.0" 
$ns at 354.6898463019311 "$node_(128) setdest 106096 55035 13.0" 
$ns at 507.54547949805817 "$node_(128) setdest 178758 62899 12.0" 
$ns at 603.9867736977919 "$node_(128) setdest 209430 21562 19.0" 
$ns at 706.9094281979604 "$node_(128) setdest 78770 30171 7.0" 
$ns at 779.6353892828087 "$node_(128) setdest 198514 66161 8.0" 
$ns at 822.3098677778905 "$node_(128) setdest 142127 4435 16.0" 
$ns at 868.7348924612116 "$node_(128) setdest 102537 77617 16.0" 
$ns at 266.3057064403585 "$node_(129) setdest 102203 39360 17.0" 
$ns at 331.2306611722297 "$node_(129) setdest 781 46023 4.0" 
$ns at 375.6230921339868 "$node_(129) setdest 65633 20201 13.0" 
$ns at 495.6419018422599 "$node_(129) setdest 147367 33343 2.0" 
$ns at 536.1963040183119 "$node_(129) setdest 161477 15708 9.0" 
$ns at 639.3599764028777 "$node_(129) setdest 114407 8264 9.0" 
$ns at 674.9654177028424 "$node_(129) setdest 142603 72599 19.0" 
$ns at 710.646206014205 "$node_(129) setdest 243694 8358 14.0" 
$ns at 756.341515779826 "$node_(129) setdest 8864 58708 10.0" 
$ns at 855.8397636302964 "$node_(129) setdest 142760 84901 15.0" 
$ns at 156.42143242979915 "$node_(130) setdest 17202 28585 8.0" 
$ns at 226.38905975762967 "$node_(130) setdest 126205 13545 1.0" 
$ns at 257.9735301476215 "$node_(130) setdest 60687 32572 1.0" 
$ns at 293.18820247823555 "$node_(130) setdest 138074 21183 19.0" 
$ns at 500.09165960482517 "$node_(130) setdest 53367 18761 4.0" 
$ns at 540.8963236828106 "$node_(130) setdest 30019 56707 6.0" 
$ns at 577.3320525477263 "$node_(130) setdest 231697 47261 7.0" 
$ns at 658.0451014474795 "$node_(130) setdest 125804 10230 2.0" 
$ns at 697.9372297138783 "$node_(130) setdest 186327 169 1.0" 
$ns at 733.0530672960654 "$node_(130) setdest 135116 20577 4.0" 
$ns at 781.7105948846041 "$node_(130) setdest 17205 28745 10.0" 
$ns at 862.6760836227514 "$node_(130) setdest 245349 12362 8.0" 
$ns at 173.17815484678658 "$node_(131) setdest 15562 4243 1.0" 
$ns at 206.00771764315755 "$node_(131) setdest 105061 14986 13.0" 
$ns at 313.87629122889405 "$node_(131) setdest 27715 26343 15.0" 
$ns at 432.49466041101294 "$node_(131) setdest 143127 20702 1.0" 
$ns at 468.7009229869856 "$node_(131) setdest 141598 69511 19.0" 
$ns at 507.1764666373586 "$node_(131) setdest 20400 57301 17.0" 
$ns at 601.6568697235815 "$node_(131) setdest 60058 32219 3.0" 
$ns at 641.3270576627167 "$node_(131) setdest 75622 45446 5.0" 
$ns at 716.2161271871664 "$node_(131) setdest 152466 19451 10.0" 
$ns at 808.0939203121294 "$node_(131) setdest 35198 64683 19.0" 
$ns at 134.7270944244849 "$node_(132) setdest 86784 4672 1.0" 
$ns at 169.8063663356817 "$node_(132) setdest 110657 35536 4.0" 
$ns at 234.7179951258198 "$node_(132) setdest 27586 14789 12.0" 
$ns at 307.1676394722275 "$node_(132) setdest 136411 47494 3.0" 
$ns at 359.04837084296287 "$node_(132) setdest 121471 26222 15.0" 
$ns at 439.1785877847523 "$node_(132) setdest 6257 12734 2.0" 
$ns at 480.58004161432893 "$node_(132) setdest 30368 36757 19.0" 
$ns at 700.3456193580673 "$node_(132) setdest 12855 31727 14.0" 
$ns at 808.9586929056629 "$node_(132) setdest 145315 39400 12.0" 
$ns at 186.88376286218195 "$node_(133) setdest 89998 25322 10.0" 
$ns at 315.6308630963674 "$node_(133) setdest 119188 29926 13.0" 
$ns at 382.37638776566496 "$node_(133) setdest 167616 4848 20.0" 
$ns at 478.58915483740935 "$node_(133) setdest 124404 68878 9.0" 
$ns at 508.68755543334737 "$node_(133) setdest 29533 34509 9.0" 
$ns at 543.013541983348 "$node_(133) setdest 97362 18642 9.0" 
$ns at 650.6213940039713 "$node_(133) setdest 169137 56301 1.0" 
$ns at 685.7065624913431 "$node_(133) setdest 241402 49080 1.0" 
$ns at 719.5239084491859 "$node_(133) setdest 171062 48393 11.0" 
$ns at 769.035795714195 "$node_(133) setdest 111669 56239 20.0" 
$ns at 129.1444545034779 "$node_(134) setdest 2518 6213 7.0" 
$ns at 170.54117362157166 "$node_(134) setdest 50934 20849 15.0" 
$ns at 211.03517008392578 "$node_(134) setdest 87844 9015 3.0" 
$ns at 261.0070719235482 "$node_(134) setdest 80598 8922 9.0" 
$ns at 292.55991129804164 "$node_(134) setdest 76857 2270 3.0" 
$ns at 345.9890240028109 "$node_(134) setdest 147978 8735 12.0" 
$ns at 450.1684715848491 "$node_(134) setdest 37933 30960 17.0" 
$ns at 605.556659429355 "$node_(134) setdest 185644 3446 20.0" 
$ns at 769.1238845178495 "$node_(134) setdest 202917 83234 6.0" 
$ns at 835.6861794171793 "$node_(134) setdest 111424 36730 17.0" 
$ns at 113.55588036202725 "$node_(135) setdest 63554 12325 5.0" 
$ns at 143.7827038682331 "$node_(135) setdest 30906 13927 5.0" 
$ns at 199.4765262855189 "$node_(135) setdest 42764 21823 6.0" 
$ns at 260.50274872534663 "$node_(135) setdest 124640 24109 5.0" 
$ns at 320.9983136414591 "$node_(135) setdest 157262 47466 19.0" 
$ns at 389.53858355531213 "$node_(135) setdest 66379 57640 14.0" 
$ns at 463.2099618226091 "$node_(135) setdest 105114 32669 3.0" 
$ns at 507.49545245205326 "$node_(135) setdest 6741 22275 12.0" 
$ns at 623.4150634081769 "$node_(135) setdest 225677 45714 14.0" 
$ns at 781.204028451377 "$node_(135) setdest 35054 28224 4.0" 
$ns at 815.6688872852333 "$node_(135) setdest 216579 83158 4.0" 
$ns at 846.7739350583455 "$node_(135) setdest 9138 38408 14.0" 
$ns at 142.59354807714158 "$node_(136) setdest 3517 22997 19.0" 
$ns at 271.3682901230926 "$node_(136) setdest 96556 51129 14.0" 
$ns at 423.4597558941971 "$node_(136) setdest 159356 9276 13.0" 
$ns at 493.752317480486 "$node_(136) setdest 100471 15581 10.0" 
$ns at 560.3270090583663 "$node_(136) setdest 184129 10101 12.0" 
$ns at 694.5516263515553 "$node_(136) setdest 150608 69999 9.0" 
$ns at 739.7210127945989 "$node_(136) setdest 68209 24242 19.0" 
$ns at 874.6217243605913 "$node_(136) setdest 116471 64398 2.0" 
$ns at 110.06675743086626 "$node_(137) setdest 4749 29395 6.0" 
$ns at 164.66350679290312 "$node_(137) setdest 71800 30420 17.0" 
$ns at 235.47768441223076 "$node_(137) setdest 9709 33497 6.0" 
$ns at 323.8548240778423 "$node_(137) setdest 16733 21428 14.0" 
$ns at 377.244061188238 "$node_(137) setdest 137509 13395 8.0" 
$ns at 478.43486370340895 "$node_(137) setdest 78315 15675 16.0" 
$ns at 651.2393928078084 "$node_(137) setdest 83392 69581 18.0" 
$ns at 841.0375628308643 "$node_(137) setdest 153902 19315 12.0" 
$ns at 140.838134157305 "$node_(138) setdest 3643 5700 5.0" 
$ns at 217.0351716479596 "$node_(138) setdest 101062 32698 14.0" 
$ns at 271.74395603455486 "$node_(138) setdest 124044 10638 5.0" 
$ns at 347.2136743042213 "$node_(138) setdest 155828 28890 13.0" 
$ns at 493.26730172660365 "$node_(138) setdest 52137 1337 13.0" 
$ns at 585.2622089037403 "$node_(138) setdest 124409 19911 9.0" 
$ns at 689.3918592981003 "$node_(138) setdest 70508 80679 12.0" 
$ns at 789.0988178840414 "$node_(138) setdest 139724 30966 13.0" 
$ns at 196.29458485125383 "$node_(139) setdest 17342 38383 2.0" 
$ns at 231.3754181552301 "$node_(139) setdest 87729 19168 14.0" 
$ns at 374.30069037854526 "$node_(139) setdest 162035 26338 6.0" 
$ns at 440.42989189224727 "$node_(139) setdest 184280 35694 5.0" 
$ns at 489.3002612600866 "$node_(139) setdest 177206 22458 1.0" 
$ns at 526.9100366435423 "$node_(139) setdest 180546 27834 1.0" 
$ns at 564.9349303251201 "$node_(139) setdest 25432 51126 4.0" 
$ns at 599.6483236818707 "$node_(139) setdest 94973 63398 10.0" 
$ns at 651.0633092349692 "$node_(139) setdest 64551 78478 10.0" 
$ns at 736.5854743756497 "$node_(139) setdest 30492 48549 7.0" 
$ns at 807.279690740903 "$node_(139) setdest 75970 10372 16.0" 
$ns at 870.435478828077 "$node_(139) setdest 180055 75515 17.0" 
$ns at 127.70771527414573 "$node_(140) setdest 28288 9594 7.0" 
$ns at 222.73380024502842 "$node_(140) setdest 82213 10799 17.0" 
$ns at 409.1241987372136 "$node_(140) setdest 69339 34366 5.0" 
$ns at 478.7656155910737 "$node_(140) setdest 156417 4596 3.0" 
$ns at 515.6652662768017 "$node_(140) setdest 63694 12466 7.0" 
$ns at 568.0538962660773 "$node_(140) setdest 124969 32779 12.0" 
$ns at 699.0308021487488 "$node_(140) setdest 100866 71362 16.0" 
$ns at 835.3745595221685 "$node_(140) setdest 44133 30027 15.0" 
$ns at 165.8372027932187 "$node_(141) setdest 102093 10890 6.0" 
$ns at 223.2204714785778 "$node_(141) setdest 7693 39445 9.0" 
$ns at 334.1199573253478 "$node_(141) setdest 146011 28418 19.0" 
$ns at 368.95841243236725 "$node_(141) setdest 60557 34739 9.0" 
$ns at 420.1950985739462 "$node_(141) setdest 124442 16214 3.0" 
$ns at 464.29715686330684 "$node_(141) setdest 37412 46927 16.0" 
$ns at 569.0768328190995 "$node_(141) setdest 13460 3317 5.0" 
$ns at 629.6771980486291 "$node_(141) setdest 66022 58508 11.0" 
$ns at 767.5000419856337 "$node_(141) setdest 92141 35735 12.0" 
$ns at 131.06423372283473 "$node_(142) setdest 55869 29862 8.0" 
$ns at 217.4372269424687 "$node_(142) setdest 132780 2448 20.0" 
$ns at 270.80038843591285 "$node_(142) setdest 52240 878 13.0" 
$ns at 365.92794471704957 "$node_(142) setdest 84748 53557 10.0" 
$ns at 429.531120596101 "$node_(142) setdest 86652 62622 10.0" 
$ns at 499.2735080945324 "$node_(142) setdest 78044 52862 8.0" 
$ns at 552.027668808439 "$node_(142) setdest 33577 60325 1.0" 
$ns at 589.0632803750779 "$node_(142) setdest 230804 13346 11.0" 
$ns at 667.2522711814954 "$node_(142) setdest 245545 50654 3.0" 
$ns at 724.227449537734 "$node_(142) setdest 222854 23507 12.0" 
$ns at 847.4167519390095 "$node_(142) setdest 28153 58354 11.0" 
$ns at 121.84372650382758 "$node_(143) setdest 62277 419 5.0" 
$ns at 159.6076787572701 "$node_(143) setdest 61426 10369 12.0" 
$ns at 300.76545458278264 "$node_(143) setdest 23283 18826 4.0" 
$ns at 366.9626570338076 "$node_(143) setdest 44222 12558 19.0" 
$ns at 561.7582744595932 "$node_(143) setdest 152780 66363 1.0" 
$ns at 596.9451783140221 "$node_(143) setdest 157610 24115 5.0" 
$ns at 666.3645845220343 "$node_(143) setdest 8226 46450 19.0" 
$ns at 726.5685100723784 "$node_(143) setdest 39427 80585 5.0" 
$ns at 799.5931207035393 "$node_(143) setdest 72250 75792 19.0" 
$ns at 135.57432254743503 "$node_(144) setdest 39808 18132 15.0" 
$ns at 232.28859115787233 "$node_(144) setdest 83244 24320 4.0" 
$ns at 295.06287237745903 "$node_(144) setdest 63101 11815 4.0" 
$ns at 337.9531196428081 "$node_(144) setdest 46966 28140 9.0" 
$ns at 429.0072546578332 "$node_(144) setdest 188697 11033 5.0" 
$ns at 497.7009035615993 "$node_(144) setdest 176115 16860 18.0" 
$ns at 705.8599278642744 "$node_(144) setdest 228513 35988 17.0" 
$ns at 847.8841322335331 "$node_(144) setdest 241386 10962 5.0" 
$ns at 102.00773209536715 "$node_(145) setdest 86160 6603 14.0" 
$ns at 223.94140808471246 "$node_(145) setdest 19201 24978 19.0" 
$ns at 275.854117935152 "$node_(145) setdest 54312 735 15.0" 
$ns at 427.0396351745352 "$node_(145) setdest 28128 60408 5.0" 
$ns at 488.4421892436943 "$node_(145) setdest 70167 27336 10.0" 
$ns at 604.5156441592254 "$node_(145) setdest 167683 58676 20.0" 
$ns at 653.6057699060493 "$node_(145) setdest 246702 56677 10.0" 
$ns at 729.7771807243654 "$node_(145) setdest 23783 76672 20.0" 
$ns at 824.5090780758737 "$node_(145) setdest 109007 65371 18.0" 
$ns at 883.5706444487869 "$node_(145) setdest 143900 30991 1.0" 
$ns at 199.81533449595236 "$node_(146) setdest 67230 26537 8.0" 
$ns at 243.42071107008005 "$node_(146) setdest 72978 29667 9.0" 
$ns at 274.9856560799319 "$node_(146) setdest 132930 9589 7.0" 
$ns at 314.9753459390888 "$node_(146) setdest 69808 8548 2.0" 
$ns at 352.1608447460553 "$node_(146) setdest 42494 9938 2.0" 
$ns at 390.49153941415136 "$node_(146) setdest 109803 48569 20.0" 
$ns at 548.1077608455738 "$node_(146) setdest 90968 20065 11.0" 
$ns at 676.3843249325357 "$node_(146) setdest 913 74304 7.0" 
$ns at 737.3819899625003 "$node_(146) setdest 62066 19149 5.0" 
$ns at 800.3934329482638 "$node_(146) setdest 98254 83593 18.0" 
$ns at 126.22644769113708 "$node_(147) setdest 31881 24355 19.0" 
$ns at 298.9959890181033 "$node_(147) setdest 60707 27858 15.0" 
$ns at 443.58564213927923 "$node_(147) setdest 39048 15240 3.0" 
$ns at 486.4086136173215 "$node_(147) setdest 21599 41664 5.0" 
$ns at 544.1627641341806 "$node_(147) setdest 17736 47133 1.0" 
$ns at 579.5980743782561 "$node_(147) setdest 224798 48446 8.0" 
$ns at 683.949243075439 "$node_(147) setdest 77481 79339 8.0" 
$ns at 783.4916538115565 "$node_(147) setdest 175703 27797 2.0" 
$ns at 833.1916529393409 "$node_(147) setdest 229240 21011 15.0" 
$ns at 159.14831272144784 "$node_(148) setdest 104737 44331 16.0" 
$ns at 227.43790454146125 "$node_(148) setdest 58159 43351 18.0" 
$ns at 345.4688790877 "$node_(148) setdest 71285 18597 3.0" 
$ns at 376.7750879517738 "$node_(148) setdest 116055 59070 2.0" 
$ns at 416.57089292533465 "$node_(148) setdest 131968 62478 14.0" 
$ns at 506.9283066295394 "$node_(148) setdest 187552 1783 20.0" 
$ns at 594.2116677024744 "$node_(148) setdest 206819 55704 10.0" 
$ns at 713.8588563176405 "$node_(148) setdest 213898 34680 9.0" 
$ns at 763.8214263063187 "$node_(148) setdest 231616 9643 10.0" 
$ns at 891.3960935976913 "$node_(148) setdest 29744 84196 2.0" 
$ns at 105.63102601906172 "$node_(149) setdest 9943 4751 10.0" 
$ns at 224.10803249324073 "$node_(149) setdest 84631 4505 10.0" 
$ns at 325.90735300942396 "$node_(149) setdest 66377 18515 14.0" 
$ns at 398.8703565744442 "$node_(149) setdest 106557 42120 13.0" 
$ns at 434.5441727746484 "$node_(149) setdest 150044 3859 11.0" 
$ns at 517.9994248410271 "$node_(149) setdest 10937 30365 3.0" 
$ns at 564.6892768765838 "$node_(149) setdest 213653 77229 8.0" 
$ns at 616.0677509722747 "$node_(149) setdest 218514 47189 16.0" 
$ns at 691.4417913158853 "$node_(149) setdest 154263 16811 18.0" 
$ns at 733.8435619148075 "$node_(149) setdest 189786 69748 14.0" 
$ns at 827.1322253073923 "$node_(149) setdest 2649 88573 14.0" 
$ns at 884.9963229921912 "$node_(149) setdest 67699 24109 5.0" 
$ns at 116.08126540126277 "$node_(150) setdest 27978 27678 10.0" 
$ns at 167.98766928160612 "$node_(150) setdest 85338 11923 3.0" 
$ns at 200.91905994974778 "$node_(150) setdest 28766 30098 3.0" 
$ns at 249.53733673332283 "$node_(150) setdest 104894 3962 13.0" 
$ns at 344.79641614772595 "$node_(150) setdest 161815 10156 6.0" 
$ns at 414.98903887023835 "$node_(150) setdest 136422 24491 16.0" 
$ns at 463.5882160865721 "$node_(150) setdest 178916 30403 7.0" 
$ns at 557.199190775821 "$node_(150) setdest 55848 49011 5.0" 
$ns at 612.8170336653048 "$node_(150) setdest 49978 9045 16.0" 
$ns at 728.5433270550155 "$node_(150) setdest 34738 31617 3.0" 
$ns at 777.6984980341397 "$node_(150) setdest 14219 84409 12.0" 
$ns at 881.3501324836017 "$node_(150) setdest 184777 29351 9.0" 
$ns at 180.03060078211485 "$node_(151) setdest 75554 42236 15.0" 
$ns at 289.3011966786487 "$node_(151) setdest 116310 33276 4.0" 
$ns at 330.1488213052139 "$node_(151) setdest 68027 32791 16.0" 
$ns at 510.7051606254538 "$node_(151) setdest 527 31128 6.0" 
$ns at 595.1678847681665 "$node_(151) setdest 142642 42717 15.0" 
$ns at 633.4428151253067 "$node_(151) setdest 147519 37936 1.0" 
$ns at 671.081161919796 "$node_(151) setdest 223997 22693 17.0" 
$ns at 702.510640855762 "$node_(151) setdest 88808 29144 1.0" 
$ns at 737.1270224177649 "$node_(151) setdest 215177 72332 4.0" 
$ns at 806.8633811309446 "$node_(151) setdest 24458 658 16.0" 
$ns at 854.0122488889308 "$node_(151) setdest 170830 56990 3.0" 
$ns at 116.65350182725685 "$node_(152) setdest 12629 1750 13.0" 
$ns at 198.69578334801662 "$node_(152) setdest 25433 3923 12.0" 
$ns at 292.9512064958859 "$node_(152) setdest 102904 34324 7.0" 
$ns at 339.33082595817433 "$node_(152) setdest 35490 6554 1.0" 
$ns at 375.2569800471151 "$node_(152) setdest 135159 29751 1.0" 
$ns at 410.93350184363044 "$node_(152) setdest 148106 20151 5.0" 
$ns at 460.36017877086607 "$node_(152) setdest 173900 42179 8.0" 
$ns at 567.8466714946829 "$node_(152) setdest 153626 60339 9.0" 
$ns at 641.247044903699 "$node_(152) setdest 183120 12621 1.0" 
$ns at 677.745243952188 "$node_(152) setdest 73230 49081 7.0" 
$ns at 728.7118724318763 "$node_(152) setdest 62466 19331 19.0" 
$ns at 846.176492149684 "$node_(152) setdest 157753 47732 15.0" 
$ns at 177.56528448863855 "$node_(153) setdest 111053 25639 5.0" 
$ns at 216.92165433442693 "$node_(153) setdest 10602 16150 18.0" 
$ns at 424.910403181339 "$node_(153) setdest 76793 33030 11.0" 
$ns at 512.7174143724013 "$node_(153) setdest 200465 4894 15.0" 
$ns at 642.1710049190783 "$node_(153) setdest 82580 69682 19.0" 
$ns at 782.8209298320386 "$node_(153) setdest 95175 33959 18.0" 
$ns at 134.51703681390282 "$node_(154) setdest 15692 27231 18.0" 
$ns at 337.6069154119998 "$node_(154) setdest 90867 44268 10.0" 
$ns at 402.40620013064176 "$node_(154) setdest 127999 62060 13.0" 
$ns at 461.5197721478586 "$node_(154) setdest 143296 38518 13.0" 
$ns at 615.6622765461923 "$node_(154) setdest 82655 33040 3.0" 
$ns at 672.983387254242 "$node_(154) setdest 114874 35698 12.0" 
$ns at 778.4960056876997 "$node_(154) setdest 196000 35579 10.0" 
$ns at 830.5088355477865 "$node_(154) setdest 64965 51999 7.0" 
$ns at 121.96948086232828 "$node_(155) setdest 92420 22627 18.0" 
$ns at 266.9373976387571 "$node_(155) setdest 62040 23 16.0" 
$ns at 326.52813047203307 "$node_(155) setdest 120644 8224 18.0" 
$ns at 454.62019493376454 "$node_(155) setdest 112076 4429 11.0" 
$ns at 547.7716759144354 "$node_(155) setdest 161786 56676 17.0" 
$ns at 694.32968175038 "$node_(155) setdest 38149 43857 1.0" 
$ns at 726.5822826136971 "$node_(155) setdest 71131 11677 5.0" 
$ns at 775.402456757001 "$node_(155) setdest 12237 83849 10.0" 
$ns at 859.7579573900514 "$node_(155) setdest 52844 45298 3.0" 
$ns at 895.4417269197685 "$node_(155) setdest 111334 43731 19.0" 
$ns at 144.8009503091727 "$node_(156) setdest 9261 30243 11.0" 
$ns at 206.06301212722803 "$node_(156) setdest 10051 8827 10.0" 
$ns at 335.6671115139604 "$node_(156) setdest 103143 14541 19.0" 
$ns at 536.1751235263679 "$node_(156) setdest 137332 4588 16.0" 
$ns at 576.3916467964299 "$node_(156) setdest 146233 70912 5.0" 
$ns at 621.0817526111158 "$node_(156) setdest 186111 60349 15.0" 
$ns at 750.6830396022432 "$node_(156) setdest 74600 70937 17.0" 
$ns at 138.39609926683292 "$node_(157) setdest 71356 22241 4.0" 
$ns at 206.8362258551146 "$node_(157) setdest 50483 32493 16.0" 
$ns at 383.5149965256712 "$node_(157) setdest 11888 13067 15.0" 
$ns at 552.2545355572132 "$node_(157) setdest 128142 30989 9.0" 
$ns at 646.5305253003963 "$node_(157) setdest 140044 36139 16.0" 
$ns at 782.2437886336261 "$node_(157) setdest 143352 62307 8.0" 
$ns at 860.4392110566232 "$node_(157) setdest 187219 64252 9.0" 
$ns at 290.7749988018311 "$node_(158) setdest 161263 25390 17.0" 
$ns at 475.6919768325166 "$node_(158) setdest 192275 37254 18.0" 
$ns at 551.534691997721 "$node_(158) setdest 190851 9616 13.0" 
$ns at 618.0417639406977 "$node_(158) setdest 6527 39071 17.0" 
$ns at 774.5885902135426 "$node_(158) setdest 181935 49510 1.0" 
$ns at 806.9938947418656 "$node_(158) setdest 205042 12821 4.0" 
$ns at 842.5343307526973 "$node_(158) setdest 89002 49247 2.0" 
$ns at 875.7942420957193 "$node_(158) setdest 120508 36931 2.0" 
$ns at 138.3785888231596 "$node_(159) setdest 35321 9287 16.0" 
$ns at 179.7263521425241 "$node_(159) setdest 44457 36368 19.0" 
$ns at 316.13851107935125 "$node_(159) setdest 58963 5424 6.0" 
$ns at 356.8315453537835 "$node_(159) setdest 98577 54738 4.0" 
$ns at 419.66078003224044 "$node_(159) setdest 85566 39792 18.0" 
$ns at 502.08704349389643 "$node_(159) setdest 178623 6134 1.0" 
$ns at 535.9072042058807 "$node_(159) setdest 58025 21134 13.0" 
$ns at 594.6781953156809 "$node_(159) setdest 68011 62340 2.0" 
$ns at 641.5492560192897 "$node_(159) setdest 95648 9119 11.0" 
$ns at 695.2277672132702 "$node_(159) setdest 111293 44521 16.0" 
$ns at 866.8748163067562 "$node_(159) setdest 58721 72623 1.0" 
$ns at 897.0562804159929 "$node_(159) setdest 70707 10976 16.0" 
$ns at 133.52669113132194 "$node_(160) setdest 59853 22473 7.0" 
$ns at 233.0305648466209 "$node_(160) setdest 124282 29364 19.0" 
$ns at 310.1117805971727 "$node_(160) setdest 21256 11167 15.0" 
$ns at 486.8341213732328 "$node_(160) setdest 157236 10818 14.0" 
$ns at 584.3564152407287 "$node_(160) setdest 125452 35885 6.0" 
$ns at 645.9094952616595 "$node_(160) setdest 46463 2963 14.0" 
$ns at 718.5388002829928 "$node_(160) setdest 187216 44343 17.0" 
$ns at 790.8694358304444 "$node_(160) setdest 167032 5275 10.0" 
$ns at 845.2649542676714 "$node_(160) setdest 180503 23070 3.0" 
$ns at 884.1255403836167 "$node_(160) setdest 193978 64209 16.0" 
$ns at 153.78967420783792 "$node_(161) setdest 102405 2891 13.0" 
$ns at 205.93599889095108 "$node_(161) setdest 131617 15721 2.0" 
$ns at 243.87234055821443 "$node_(161) setdest 104908 36541 13.0" 
$ns at 324.2629839932101 "$node_(161) setdest 128564 13164 3.0" 
$ns at 373.7367228288665 "$node_(161) setdest 108027 59190 12.0" 
$ns at 422.2402111286691 "$node_(161) setdest 145446 3272 5.0" 
$ns at 471.80972638169663 "$node_(161) setdest 9835 60354 10.0" 
$ns at 523.9591489055238 "$node_(161) setdest 157399 25112 19.0" 
$ns at 556.6618770063371 "$node_(161) setdest 22427 3496 1.0" 
$ns at 595.4491399045237 "$node_(161) setdest 109182 102 2.0" 
$ns at 641.4202713985524 "$node_(161) setdest 4167 29923 6.0" 
$ns at 679.5315267708622 "$node_(161) setdest 114667 14496 15.0" 
$ns at 750.5725613251914 "$node_(161) setdest 142031 86234 10.0" 
$ns at 795.5157894560195 "$node_(161) setdest 188509 83251 4.0" 
$ns at 826.2765725415103 "$node_(161) setdest 118903 21071 12.0" 
$ns at 869.7603793473751 "$node_(161) setdest 37371 68762 11.0" 
$ns at 196.97870002020218 "$node_(162) setdest 8504 14566 1.0" 
$ns at 228.89766819108794 "$node_(162) setdest 83777 30927 17.0" 
$ns at 414.33032637773357 "$node_(162) setdest 53216 53042 2.0" 
$ns at 445.23769411711567 "$node_(162) setdest 71114 18665 13.0" 
$ns at 525.124282212079 "$node_(162) setdest 53304 70386 4.0" 
$ns at 558.2197320357127 "$node_(162) setdest 176932 3110 2.0" 
$ns at 603.8043861172522 "$node_(162) setdest 32688 58653 5.0" 
$ns at 672.1203839878882 "$node_(162) setdest 101456 25904 19.0" 
$ns at 708.9900600927657 "$node_(162) setdest 26014 24789 16.0" 
$ns at 826.5866553581294 "$node_(162) setdest 237785 13233 19.0" 
$ns at 118.59025304367549 "$node_(163) setdest 46657 24652 15.0" 
$ns at 173.63300630640936 "$node_(163) setdest 117639 17117 4.0" 
$ns at 223.47359808884875 "$node_(163) setdest 7305 23468 18.0" 
$ns at 322.77742368885333 "$node_(163) setdest 163501 32260 6.0" 
$ns at 394.8247352154974 "$node_(163) setdest 107926 17151 10.0" 
$ns at 504.683344133672 "$node_(163) setdest 61641 39559 16.0" 
$ns at 650.7681426649475 "$node_(163) setdest 76211 46218 3.0" 
$ns at 682.1911458040946 "$node_(163) setdest 219398 6365 19.0" 
$ns at 800.594639526096 "$node_(163) setdest 62708 12085 16.0" 
$ns at 897.1256526499856 "$node_(163) setdest 22253 41683 8.0" 
$ns at 149.82613225696474 "$node_(164) setdest 5004 16602 9.0" 
$ns at 244.28203715390163 "$node_(164) setdest 54858 133 18.0" 
$ns at 401.05301139776213 "$node_(164) setdest 87569 46224 11.0" 
$ns at 516.049257757314 "$node_(164) setdest 131970 23524 8.0" 
$ns at 569.406257646129 "$node_(164) setdest 32035 9606 16.0" 
$ns at 605.0848965273713 "$node_(164) setdest 1425 33753 11.0" 
$ns at 734.713231132796 "$node_(164) setdest 50532 53629 19.0" 
$ns at 863.8724713175302 "$node_(164) setdest 28489 5419 12.0" 
$ns at 116.86182692638933 "$node_(165) setdest 84934 9092 3.0" 
$ns at 166.2622142195729 "$node_(165) setdest 130645 18811 6.0" 
$ns at 250.12630446349638 "$node_(165) setdest 41259 10254 10.0" 
$ns at 365.7865725599029 "$node_(165) setdest 47836 11673 2.0" 
$ns at 402.41191935231024 "$node_(165) setdest 162671 34945 7.0" 
$ns at 492.6690041054384 "$node_(165) setdest 186735 4277 19.0" 
$ns at 542.0017715757432 "$node_(165) setdest 113363 11354 16.0" 
$ns at 677.6754666169898 "$node_(165) setdest 222634 59910 1.0" 
$ns at 715.2233453127561 "$node_(165) setdest 226297 52392 11.0" 
$ns at 806.1099336797888 "$node_(165) setdest 22066 21271 3.0" 
$ns at 841.0476417060615 "$node_(165) setdest 13424 23174 6.0" 
$ns at 872.3254836559158 "$node_(165) setdest 162621 78039 20.0" 
$ns at 116.8817065381136 "$node_(166) setdest 29303 65 6.0" 
$ns at 189.3040788461187 "$node_(166) setdest 24102 22286 9.0" 
$ns at 297.14787731778813 "$node_(166) setdest 71517 54090 10.0" 
$ns at 386.24098737990244 "$node_(166) setdest 71263 21995 1.0" 
$ns at 417.44481786133406 "$node_(166) setdest 139470 8319 4.0" 
$ns at 484.4694331841078 "$node_(166) setdest 102405 49321 3.0" 
$ns at 534.3596554102074 "$node_(166) setdest 146522 53729 8.0" 
$ns at 579.7487626863899 "$node_(166) setdest 24331 35679 10.0" 
$ns at 638.9284938160407 "$node_(166) setdest 56580 59675 15.0" 
$ns at 720.6243047770183 "$node_(166) setdest 239031 73546 8.0" 
$ns at 797.3815337189651 "$node_(166) setdest 91385 22433 13.0" 
$ns at 885.9019790350619 "$node_(166) setdest 253446 16773 6.0" 
$ns at 125.1528074122515 "$node_(167) setdest 64234 18248 12.0" 
$ns at 182.14243674290898 "$node_(167) setdest 120190 26809 2.0" 
$ns at 215.58007606772972 "$node_(167) setdest 38209 37401 9.0" 
$ns at 288.46354456704785 "$node_(167) setdest 44006 50228 6.0" 
$ns at 359.4939219635275 "$node_(167) setdest 158035 62333 10.0" 
$ns at 394.0737184217478 "$node_(167) setdest 34171 33252 17.0" 
$ns at 578.1460079344513 "$node_(167) setdest 162111 51850 14.0" 
$ns at 637.6932051661333 "$node_(167) setdest 14668 8746 6.0" 
$ns at 705.4787459731349 "$node_(167) setdest 36584 55055 2.0" 
$ns at 747.8878868344989 "$node_(167) setdest 43057 36274 1.0" 
$ns at 780.5077057806429 "$node_(167) setdest 82322 5141 11.0" 
$ns at 147.85004825147416 "$node_(168) setdest 62734 5399 4.0" 
$ns at 191.71629215191768 "$node_(168) setdest 18824 44046 17.0" 
$ns at 329.6949189136018 "$node_(168) setdest 48717 39611 4.0" 
$ns at 365.1541506359053 "$node_(168) setdest 48500 11976 12.0" 
$ns at 475.44258564269023 "$node_(168) setdest 202233 5093 16.0" 
$ns at 654.5452007092399 "$node_(168) setdest 195725 43319 2.0" 
$ns at 690.4691557806473 "$node_(168) setdest 181487 63612 8.0" 
$ns at 747.8882441073698 "$node_(168) setdest 234324 55245 6.0" 
$ns at 822.9437917217008 "$node_(168) setdest 78570 83033 9.0" 
$ns at 899.6214925566641 "$node_(168) setdest 36856 78692 8.0" 
$ns at 115.11343700671972 "$node_(169) setdest 11958 10102 18.0" 
$ns at 249.26408755952298 "$node_(169) setdest 92487 23102 10.0" 
$ns at 324.5699126816591 "$node_(169) setdest 108231 50930 8.0" 
$ns at 402.8014438874788 "$node_(169) setdest 125321 9936 3.0" 
$ns at 462.06507330295864 "$node_(169) setdest 146969 57278 14.0" 
$ns at 558.0641586988772 "$node_(169) setdest 155048 50180 14.0" 
$ns at 646.2787933753465 "$node_(169) setdest 122400 3277 15.0" 
$ns at 824.0558818803926 "$node_(169) setdest 163072 86627 7.0" 
$ns at 117.7023490905033 "$node_(170) setdest 87712 2926 17.0" 
$ns at 177.66413172147122 "$node_(170) setdest 111424 21955 12.0" 
$ns at 311.6822495615796 "$node_(170) setdest 73251 47973 7.0" 
$ns at 343.99616732575015 "$node_(170) setdest 38863 2852 8.0" 
$ns at 439.5466554172773 "$node_(170) setdest 106318 46739 9.0" 
$ns at 484.4777051857258 "$node_(170) setdest 175281 41312 8.0" 
$ns at 533.947236033656 "$node_(170) setdest 127409 6403 1.0" 
$ns at 573.3253698618116 "$node_(170) setdest 15988 75751 13.0" 
$ns at 678.7625101967685 "$node_(170) setdest 192701 1200 15.0" 
$ns at 796.2175333373766 "$node_(170) setdest 245221 1592 3.0" 
$ns at 849.180703926136 "$node_(170) setdest 260377 49930 12.0" 
$ns at 141.11013884687475 "$node_(171) setdest 3580 19247 10.0" 
$ns at 234.85826975151812 "$node_(171) setdest 107898 19435 14.0" 
$ns at 354.6900449399402 "$node_(171) setdest 174627 47141 8.0" 
$ns at 434.397890321379 "$node_(171) setdest 49643 39458 19.0" 
$ns at 647.3077498071306 "$node_(171) setdest 172340 55862 14.0" 
$ns at 772.2592307145386 "$node_(171) setdest 141527 68603 18.0" 
$ns at 113.73293625957564 "$node_(172) setdest 92975 22898 14.0" 
$ns at 187.50847938242134 "$node_(172) setdest 46869 21281 5.0" 
$ns at 259.98509201892267 "$node_(172) setdest 148002 45272 12.0" 
$ns at 361.50391788177876 "$node_(172) setdest 79093 6891 1.0" 
$ns at 393.7702234438792 "$node_(172) setdest 26371 4071 18.0" 
$ns at 527.5913803151027 "$node_(172) setdest 4208 46144 4.0" 
$ns at 588.6138484170004 "$node_(172) setdest 38878 56984 4.0" 
$ns at 657.361921762578 "$node_(172) setdest 43518 8219 1.0" 
$ns at 695.6680924839442 "$node_(172) setdest 163892 75655 1.0" 
$ns at 732.2263707853708 "$node_(172) setdest 214203 40543 17.0" 
$ns at 773.624375097798 "$node_(172) setdest 171141 26825 19.0" 
$ns at 856.9190060046782 "$node_(172) setdest 132523 2638 14.0" 
$ns at 141.53964373524045 "$node_(173) setdest 13435 18474 17.0" 
$ns at 269.7047495117906 "$node_(173) setdest 104622 42976 14.0" 
$ns at 329.3861668021402 "$node_(173) setdest 1114 50889 20.0" 
$ns at 499.0116121787869 "$node_(173) setdest 159995 22425 14.0" 
$ns at 658.8437464333424 "$node_(173) setdest 99809 56945 20.0" 
$ns at 836.4947343689201 "$node_(173) setdest 135975 47609 10.0" 
$ns at 174.89892571031208 "$node_(174) setdest 125160 7837 18.0" 
$ns at 310.3016949647447 "$node_(174) setdest 46680 20498 14.0" 
$ns at 351.4906448597273 "$node_(174) setdest 92813 12036 19.0" 
$ns at 527.13271852718 "$node_(174) setdest 163348 28745 15.0" 
$ns at 660.4504779170477 "$node_(174) setdest 66636 5043 6.0" 
$ns at 748.1915187802913 "$node_(174) setdest 208464 2580 7.0" 
$ns at 820.8808912275878 "$node_(174) setdest 54625 84324 3.0" 
$ns at 852.5854008886472 "$node_(174) setdest 208247 4659 19.0" 
$ns at 146.77621092289053 "$node_(175) setdest 67022 20052 3.0" 
$ns at 188.25213685417825 "$node_(175) setdest 78016 3075 11.0" 
$ns at 279.5696066288588 "$node_(175) setdest 115872 53638 5.0" 
$ns at 317.30969939377906 "$node_(175) setdest 131292 23677 16.0" 
$ns at 419.31927898597246 "$node_(175) setdest 82188 12339 16.0" 
$ns at 561.4882371587889 "$node_(175) setdest 166696 44047 8.0" 
$ns at 664.8416155131463 "$node_(175) setdest 52300 25540 8.0" 
$ns at 772.6355248701881 "$node_(175) setdest 177506 44633 11.0" 
$ns at 883.9221918285104 "$node_(175) setdest 262115 73090 15.0" 
$ns at 133.29892460348947 "$node_(176) setdest 60507 23470 2.0" 
$ns at 178.8117577515157 "$node_(176) setdest 23992 19816 15.0" 
$ns at 346.3095330976267 "$node_(176) setdest 43204 18052 17.0" 
$ns at 510.2814561315022 "$node_(176) setdest 150595 32622 6.0" 
$ns at 550.9120847650086 "$node_(176) setdest 162101 71074 11.0" 
$ns at 650.6936647402534 "$node_(176) setdest 201002 31063 14.0" 
$ns at 781.117260398811 "$node_(176) setdest 128565 68921 12.0" 
$ns at 888.4775619331812 "$node_(176) setdest 119055 80811 11.0" 
$ns at 100.79448002842112 "$node_(177) setdest 1192 10724 1.0" 
$ns at 132.88957677048705 "$node_(177) setdest 41836 21409 18.0" 
$ns at 264.1402891657647 "$node_(177) setdest 59393 34073 5.0" 
$ns at 319.0250791401283 "$node_(177) setdest 10103 28681 2.0" 
$ns at 358.99850710779486 "$node_(177) setdest 49356 60494 18.0" 
$ns at 509.8542544612013 "$node_(177) setdest 90713 11620 3.0" 
$ns at 549.5995718895924 "$node_(177) setdest 163639 9837 8.0" 
$ns at 584.4896566541884 "$node_(177) setdest 5683 11297 1.0" 
$ns at 619.3447638565902 "$node_(177) setdest 215468 20637 16.0" 
$ns at 707.0755357769962 "$node_(177) setdest 239704 37985 1.0" 
$ns at 741.116759481926 "$node_(177) setdest 103037 55643 19.0" 
$ns at 177.7815537106802 "$node_(178) setdest 84393 17525 2.0" 
$ns at 207.99146993626906 "$node_(178) setdest 96181 32857 10.0" 
$ns at 319.38774856756453 "$node_(178) setdest 38004 43391 2.0" 
$ns at 350.3851903354389 "$node_(178) setdest 106352 15647 13.0" 
$ns at 392.5004042443255 "$node_(178) setdest 127328 31362 16.0" 
$ns at 580.5597427391265 "$node_(178) setdest 133140 30904 10.0" 
$ns at 624.7736722725928 "$node_(178) setdest 67284 29647 6.0" 
$ns at 683.5175140158148 "$node_(178) setdest 243244 66602 2.0" 
$ns at 726.4170475936427 "$node_(178) setdest 78040 19583 15.0" 
$ns at 775.2541185080639 "$node_(178) setdest 247385 43318 16.0" 
$ns at 808.9026604245366 "$node_(178) setdest 152481 76792 1.0" 
$ns at 846.9531865479373 "$node_(178) setdest 144953 83754 1.0" 
$ns at 882.5466135887191 "$node_(178) setdest 137323 14829 14.0" 
$ns at 110.28435814210307 "$node_(179) setdest 55539 10559 8.0" 
$ns at 169.6569871582799 "$node_(179) setdest 70749 19961 17.0" 
$ns at 347.0454527463743 "$node_(179) setdest 12374 31574 5.0" 
$ns at 419.1037736033717 "$node_(179) setdest 24853 50739 6.0" 
$ns at 508.3387217444093 "$node_(179) setdest 63551 57139 6.0" 
$ns at 543.9398245054407 "$node_(179) setdest 167755 13768 3.0" 
$ns at 575.2151411761066 "$node_(179) setdest 4320 22060 1.0" 
$ns at 613.702961359399 "$node_(179) setdest 170830 50489 19.0" 
$ns at 822.3134643909982 "$node_(179) setdest 178256 66054 18.0" 
$ns at 205.2497106319828 "$node_(180) setdest 35855 10609 12.0" 
$ns at 311.74449929272265 "$node_(180) setdest 9688 38833 2.0" 
$ns at 348.55603994043963 "$node_(180) setdest 57625 35014 12.0" 
$ns at 403.8611508954862 "$node_(180) setdest 1503 42365 4.0" 
$ns at 454.3303431446327 "$node_(180) setdest 70079 69467 14.0" 
$ns at 487.46739254595724 "$node_(180) setdest 16596 62936 16.0" 
$ns at 639.7103110768962 "$node_(180) setdest 14240 61071 4.0" 
$ns at 685.6505785065308 "$node_(180) setdest 99914 67240 18.0" 
$ns at 825.1742480905947 "$node_(180) setdest 175022 29470 12.0" 
$ns at 864.1863488045868 "$node_(180) setdest 15321 58994 4.0" 
$ns at 189.33120247520984 "$node_(181) setdest 48400 8522 6.0" 
$ns at 239.7790684241363 "$node_(181) setdest 54506 19178 19.0" 
$ns at 389.574682029096 "$node_(181) setdest 152280 60845 18.0" 
$ns at 423.0273478451088 "$node_(181) setdest 58124 13504 9.0" 
$ns at 470.84206862898037 "$node_(181) setdest 78067 56191 4.0" 
$ns at 521.0227378121713 "$node_(181) setdest 130221 31293 15.0" 
$ns at 644.2734803200015 "$node_(181) setdest 7589 70153 8.0" 
$ns at 725.612416181008 "$node_(181) setdest 226768 10771 3.0" 
$ns at 764.734552073258 "$node_(181) setdest 152588 59316 2.0" 
$ns at 809.5458118605155 "$node_(181) setdest 34766 85961 5.0" 
$ns at 851.9883765271226 "$node_(181) setdest 5942 8779 13.0" 
$ns at 119.40401145586131 "$node_(182) setdest 67135 1045 7.0" 
$ns at 189.6088659309537 "$node_(182) setdest 128213 9859 10.0" 
$ns at 240.77563320526113 "$node_(182) setdest 129442 1686 19.0" 
$ns at 453.68550085205425 "$node_(182) setdest 128928 9857 16.0" 
$ns at 490.77383337437504 "$node_(182) setdest 138120 21829 9.0" 
$ns at 524.6639497336678 "$node_(182) setdest 103416 23970 12.0" 
$ns at 629.3395488902938 "$node_(182) setdest 114105 76056 5.0" 
$ns at 708.2293072705324 "$node_(182) setdest 149375 81869 8.0" 
$ns at 811.0356006821235 "$node_(182) setdest 145513 71214 10.0" 
$ns at 884.002278659801 "$node_(182) setdest 2373 40794 4.0" 
$ns at 251.94066663517054 "$node_(183) setdest 19969 43749 14.0" 
$ns at 379.06291975004024 "$node_(183) setdest 84844 47845 6.0" 
$ns at 455.05576405261843 "$node_(183) setdest 211586 26727 18.0" 
$ns at 642.8081582702193 "$node_(183) setdest 198582 4741 5.0" 
$ns at 690.6623861353539 "$node_(183) setdest 205637 28912 4.0" 
$ns at 741.3180846056413 "$node_(183) setdest 180476 7572 7.0" 
$ns at 815.56298946703 "$node_(183) setdest 139604 82537 10.0" 
$ns at 870.0232462235906 "$node_(183) setdest 151390 3531 14.0" 
$ns at 195.501531189433 "$node_(184) setdest 69080 38483 6.0" 
$ns at 230.02465563797057 "$node_(184) setdest 111983 19542 12.0" 
$ns at 370.7463944938749 "$node_(184) setdest 178286 35062 13.0" 
$ns at 451.65776578861926 "$node_(184) setdest 131760 11951 18.0" 
$ns at 628.0563813728478 "$node_(184) setdest 154294 3049 10.0" 
$ns at 676.3223711861959 "$node_(184) setdest 120470 72303 11.0" 
$ns at 808.6703893261504 "$node_(184) setdest 224560 970 8.0" 
$ns at 884.5128152415679 "$node_(184) setdest 22409 29464 1.0" 
$ns at 232.01592769805447 "$node_(185) setdest 77191 6843 2.0" 
$ns at 279.034646759975 "$node_(185) setdest 2856 41455 4.0" 
$ns at 318.7325909426618 "$node_(185) setdest 64538 9778 18.0" 
$ns at 468.2581846711135 "$node_(185) setdest 123724 31873 8.0" 
$ns at 505.07952285876723 "$node_(185) setdest 179830 31061 20.0" 
$ns at 576.8973404371579 "$node_(185) setdest 187251 25889 18.0" 
$ns at 654.9503081365667 "$node_(185) setdest 132360 81760 11.0" 
$ns at 718.7724329919508 "$node_(185) setdest 147602 26388 12.0" 
$ns at 751.4684143913628 "$node_(185) setdest 164186 17292 9.0" 
$ns at 828.8830607480749 "$node_(185) setdest 104209 68737 9.0" 
$ns at 108.20715889587896 "$node_(186) setdest 7681 27366 3.0" 
$ns at 161.6876009367969 "$node_(186) setdest 42127 2994 17.0" 
$ns at 234.9501871952882 "$node_(186) setdest 91621 36992 5.0" 
$ns at 271.4925359497933 "$node_(186) setdest 128005 34976 9.0" 
$ns at 352.49090003512345 "$node_(186) setdest 110613 59361 1.0" 
$ns at 387.5937153167112 "$node_(186) setdest 178903 47366 6.0" 
$ns at 476.62094832259265 "$node_(186) setdest 19403 21728 6.0" 
$ns at 514.9415547880915 "$node_(186) setdest 72999 8250 9.0" 
$ns at 558.976272985899 "$node_(186) setdest 130746 61048 7.0" 
$ns at 656.3221211828553 "$node_(186) setdest 79591 13296 11.0" 
$ns at 718.5052576067866 "$node_(186) setdest 234476 36057 8.0" 
$ns at 816.5016182346465 "$node_(186) setdest 209503 44111 6.0" 
$ns at 857.0545793571475 "$node_(186) setdest 53510 14910 18.0" 
$ns at 101.75780248480885 "$node_(187) setdest 67007 3797 10.0" 
$ns at 207.2125325905339 "$node_(187) setdest 24611 10486 16.0" 
$ns at 252.4553043041285 "$node_(187) setdest 102159 37934 3.0" 
$ns at 299.713653336598 "$node_(187) setdest 81278 53752 1.0" 
$ns at 332.9272247357748 "$node_(187) setdest 142082 6867 19.0" 
$ns at 519.8674613240746 "$node_(187) setdest 142543 35502 13.0" 
$ns at 660.1704517098061 "$node_(187) setdest 247450 74930 16.0" 
$ns at 780.0349827445045 "$node_(187) setdest 41240 78095 8.0" 
$ns at 847.5572861678962 "$node_(187) setdest 219006 77174 1.0" 
$ns at 881.1958167848877 "$node_(187) setdest 188577 68146 11.0" 
$ns at 155.7659925760737 "$node_(188) setdest 75786 22706 5.0" 
$ns at 185.78315993108777 "$node_(188) setdest 95407 6435 14.0" 
$ns at 339.20798174454814 "$node_(188) setdest 25915 20035 5.0" 
$ns at 404.08077713941293 "$node_(188) setdest 73099 20287 4.0" 
$ns at 456.5876366490894 "$node_(188) setdest 132758 24223 1.0" 
$ns at 492.73042902653685 "$node_(188) setdest 174750 17777 12.0" 
$ns at 631.244933578465 "$node_(188) setdest 164398 47072 13.0" 
$ns at 702.3913173534746 "$node_(188) setdest 15716 1061 11.0" 
$ns at 834.8523683818582 "$node_(188) setdest 31249 78245 2.0" 
$ns at 875.6850232204963 "$node_(188) setdest 178255 48443 5.0" 
$ns at 225.3730248268144 "$node_(189) setdest 49966 26951 8.0" 
$ns at 316.44146546635454 "$node_(189) setdest 117480 35 1.0" 
$ns at 349.88309575076676 "$node_(189) setdest 26763 17270 2.0" 
$ns at 394.72783218088284 "$node_(189) setdest 166650 43985 3.0" 
$ns at 431.7730622042853 "$node_(189) setdest 6236 18140 3.0" 
$ns at 468.33074364344867 "$node_(189) setdest 113455 1917 15.0" 
$ns at 565.5627915977045 "$node_(189) setdest 66037 27393 17.0" 
$ns at 617.88917037916 "$node_(189) setdest 155054 10195 9.0" 
$ns at 733.8877563168203 "$node_(189) setdest 174711 26066 11.0" 
$ns at 794.4100338088498 "$node_(189) setdest 213454 16167 8.0" 
$ns at 865.4549503127687 "$node_(189) setdest 200315 52454 19.0" 
$ns at 140.51907039101235 "$node_(190) setdest 85244 1405 20.0" 
$ns at 250.23623480646063 "$node_(190) setdest 123183 28033 7.0" 
$ns at 309.62738592170507 "$node_(190) setdest 125100 42791 5.0" 
$ns at 387.230176985691 "$node_(190) setdest 66943 7664 7.0" 
$ns at 437.1160232398435 "$node_(190) setdest 128115 44235 5.0" 
$ns at 504.2565381542712 "$node_(190) setdest 158548 18299 1.0" 
$ns at 535.0708114733951 "$node_(190) setdest 121511 1079 17.0" 
$ns at 626.7129402773998 "$node_(190) setdest 148289 67932 6.0" 
$ns at 692.3109368605465 "$node_(190) setdest 167679 26257 18.0" 
$ns at 731.8285167287598 "$node_(190) setdest 223491 49771 19.0" 
$ns at 875.2139966044529 "$node_(190) setdest 94556 58629 4.0" 
$ns at 139.23399779218641 "$node_(191) setdest 46913 10895 14.0" 
$ns at 200.28501436916002 "$node_(191) setdest 23618 7684 2.0" 
$ns at 237.1565273204876 "$node_(191) setdest 84779 28133 1.0" 
$ns at 268.2213348431662 "$node_(191) setdest 119037 36275 7.0" 
$ns at 332.48805891445954 "$node_(191) setdest 130266 46676 19.0" 
$ns at 546.9744888823127 "$node_(191) setdest 170799 36033 13.0" 
$ns at 611.2563536700438 "$node_(191) setdest 217563 63768 5.0" 
$ns at 650.5398079733438 "$node_(191) setdest 117103 20768 11.0" 
$ns at 730.0415681280797 "$node_(191) setdest 62608 35946 16.0" 
$ns at 875.014630828906 "$node_(191) setdest 66013 19563 17.0" 
$ns at 144.40208826473807 "$node_(192) setdest 19853 7703 4.0" 
$ns at 189.34436611934512 "$node_(192) setdest 67774 42975 15.0" 
$ns at 287.6311254322961 "$node_(192) setdest 90972 34014 16.0" 
$ns at 407.1338955153161 "$node_(192) setdest 183872 27527 8.0" 
$ns at 495.68180637265704 "$node_(192) setdest 77860 48754 5.0" 
$ns at 553.4603088859468 "$node_(192) setdest 24486 50198 5.0" 
$ns at 594.6379469163024 "$node_(192) setdest 138994 13054 1.0" 
$ns at 629.2940031664828 "$node_(192) setdest 22017 62363 1.0" 
$ns at 660.7002829012606 "$node_(192) setdest 10376 13371 10.0" 
$ns at 764.764733522863 "$node_(192) setdest 72614 33900 16.0" 
$ns at 817.7506890245686 "$node_(192) setdest 81296 88184 16.0" 
$ns at 203.9243992968445 "$node_(193) setdest 109754 27526 14.0" 
$ns at 335.37747644184736 "$node_(193) setdest 64531 33642 16.0" 
$ns at 440.9299258676847 "$node_(193) setdest 51269 19534 5.0" 
$ns at 498.818721773004 "$node_(193) setdest 10662 9254 13.0" 
$ns at 614.6585645268318 "$node_(193) setdest 59744 7405 11.0" 
$ns at 753.982608457994 "$node_(193) setdest 27632 3471 12.0" 
$ns at 819.619910728195 "$node_(193) setdest 17106 82093 1.0" 
$ns at 857.7368072190302 "$node_(193) setdest 202360 80626 11.0" 
$ns at 195.02479706913127 "$node_(194) setdest 91077 1866 4.0" 
$ns at 247.52410349225323 "$node_(194) setdest 6275 23514 17.0" 
$ns at 320.34640285443027 "$node_(194) setdest 55044 30971 8.0" 
$ns at 424.527127099962 "$node_(194) setdest 66790 48766 7.0" 
$ns at 480.30241137031203 "$node_(194) setdest 149637 64849 18.0" 
$ns at 561.0652708570127 "$node_(194) setdest 6612 45541 18.0" 
$ns at 656.7562791727069 "$node_(194) setdest 177984 82708 4.0" 
$ns at 690.1676164106116 "$node_(194) setdest 69651 32128 14.0" 
$ns at 741.6676791342682 "$node_(194) setdest 193311 4171 11.0" 
$ns at 828.6980013236841 "$node_(194) setdest 122343 17132 15.0" 
$ns at 896.8413817530065 "$node_(194) setdest 75755 1923 1.0" 
$ns at 159.3337101409461 "$node_(195) setdest 51317 10268 9.0" 
$ns at 272.6323826315766 "$node_(195) setdest 48966 3368 11.0" 
$ns at 375.29703611724995 "$node_(195) setdest 12279 31499 8.0" 
$ns at 412.26824183565117 "$node_(195) setdest 128291 37775 4.0" 
$ns at 455.13676528656003 "$node_(195) setdest 83302 4416 3.0" 
$ns at 511.3151533885828 "$node_(195) setdest 162732 51381 13.0" 
$ns at 548.7206857739676 "$node_(195) setdest 204624 41956 16.0" 
$ns at 643.6528613338297 "$node_(195) setdest 73386 41127 15.0" 
$ns at 755.8160056440706 "$node_(195) setdest 264208 15023 13.0" 
$ns at 846.2095143842635 "$node_(195) setdest 128912 12844 4.0" 
$ns at 879.1108091737741 "$node_(195) setdest 133928 56328 19.0" 
$ns at 200.5231156370373 "$node_(196) setdest 80836 15596 14.0" 
$ns at 360.73926024251944 "$node_(196) setdest 23577 2809 6.0" 
$ns at 440.2571191711089 "$node_(196) setdest 115111 39321 16.0" 
$ns at 563.7886068025406 "$node_(196) setdest 224653 39815 13.0" 
$ns at 640.8235716908677 "$node_(196) setdest 80884 23425 14.0" 
$ns at 728.605690875346 "$node_(196) setdest 174671 41583 20.0" 
$ns at 793.7116419329938 "$node_(196) setdest 140944 84282 7.0" 
$ns at 883.9868449314648 "$node_(196) setdest 203783 88015 18.0" 
$ns at 111.10936986624557 "$node_(197) setdest 85638 12768 11.0" 
$ns at 165.6517972250056 "$node_(197) setdest 60363 13204 15.0" 
$ns at 216.95814599430165 "$node_(197) setdest 110665 12761 8.0" 
$ns at 290.67854852670536 "$node_(197) setdest 74878 18016 11.0" 
$ns at 335.354145550007 "$node_(197) setdest 31548 9810 1.0" 
$ns at 367.20527249233027 "$node_(197) setdest 136598 37296 18.0" 
$ns at 519.5933488142919 "$node_(197) setdest 32379 64609 13.0" 
$ns at 644.0437514335132 "$node_(197) setdest 110745 9652 20.0" 
$ns at 797.4666720121124 "$node_(197) setdest 61015 43613 1.0" 
$ns at 836.9444114697491 "$node_(197) setdest 98594 41565 15.0" 
$ns at 876.5772034399743 "$node_(197) setdest 225869 84950 17.0" 
$ns at 120.68782065770081 "$node_(198) setdest 94396 26773 17.0" 
$ns at 168.40899752806337 "$node_(198) setdest 116884 8051 1.0" 
$ns at 205.60905487016203 "$node_(198) setdest 57469 16989 5.0" 
$ns at 262.1774015792347 "$node_(198) setdest 152716 40151 6.0" 
$ns at 331.43474658756264 "$node_(198) setdest 148803 36670 11.0" 
$ns at 366.484907223394 "$node_(198) setdest 102418 55915 13.0" 
$ns at 467.92285088683883 "$node_(198) setdest 99688 54200 17.0" 
$ns at 548.6432073881859 "$node_(198) setdest 172783 62261 8.0" 
$ns at 652.6901542084314 "$node_(198) setdest 198235 25954 4.0" 
$ns at 684.9430404428083 "$node_(198) setdest 191245 77089 5.0" 
$ns at 727.0349681337658 "$node_(198) setdest 240208 81515 10.0" 
$ns at 840.7587787308616 "$node_(198) setdest 90713 6074 12.0" 
$ns at 232.44092268489936 "$node_(199) setdest 83569 7161 13.0" 
$ns at 347.54939588712284 "$node_(199) setdest 94419 46538 6.0" 
$ns at 410.38038073597414 "$node_(199) setdest 75788 62642 15.0" 
$ns at 477.00415091975594 "$node_(199) setdest 66335 24670 7.0" 
$ns at 560.3664117506147 "$node_(199) setdest 133752 30061 8.0" 
$ns at 611.1882501685611 "$node_(199) setdest 138271 30730 11.0" 
$ns at 653.4565999576666 "$node_(199) setdest 99197 3583 9.0" 
$ns at 738.802334403734 "$node_(199) setdest 233237 52578 12.0" 
$ns at 783.3406557996336 "$node_(199) setdest 231187 66193 12.0" 
$ns at 840.3851124099831 "$node_(199) setdest 139231 50565 18.0" 
$ns at 231.25402269663797 "$node_(200) setdest 94720 7658 14.0" 
$ns at 332.6318327996155 "$node_(200) setdest 23047 17541 1.0" 
$ns at 365.44070233570915 "$node_(200) setdest 50624 13326 4.0" 
$ns at 407.3360360938742 "$node_(200) setdest 8541 42331 3.0" 
$ns at 452.83439040565105 "$node_(200) setdest 933 22014 19.0" 
$ns at 573.2991517576176 "$node_(200) setdest 79323 40487 13.0" 
$ns at 604.0195700222544 "$node_(200) setdest 81462 3137 12.0" 
$ns at 682.6023810255199 "$node_(200) setdest 70867 7682 16.0" 
$ns at 775.3769144938058 "$node_(200) setdest 61427 32678 8.0" 
$ns at 847.6208631106501 "$node_(200) setdest 106066 11299 5.0" 
$ns at 219.64116932763503 "$node_(201) setdest 88286 130 20.0" 
$ns at 275.3078025376768 "$node_(201) setdest 109894 34640 8.0" 
$ns at 352.1390761820996 "$node_(201) setdest 37103 24766 2.0" 
$ns at 386.4154131259756 "$node_(201) setdest 33433 3841 16.0" 
$ns at 455.00075927611533 "$node_(201) setdest 14367 12696 15.0" 
$ns at 592.4198430571705 "$node_(201) setdest 131485 13836 3.0" 
$ns at 636.8094247420589 "$node_(201) setdest 74233 29617 6.0" 
$ns at 708.002212328399 "$node_(201) setdest 32268 10255 2.0" 
$ns at 750.2287728462275 "$node_(201) setdest 86805 32325 13.0" 
$ns at 833.0521611982691 "$node_(201) setdest 116350 25861 20.0" 
$ns at 877.2621716974484 "$node_(201) setdest 93312 7789 2.0" 
$ns at 219.94372276895007 "$node_(202) setdest 51405 36490 8.0" 
$ns at 277.2657687976827 "$node_(202) setdest 97290 13934 6.0" 
$ns at 317.65725945365796 "$node_(202) setdest 69026 22950 10.0" 
$ns at 352.29148845490676 "$node_(202) setdest 112602 44615 19.0" 
$ns at 474.6397353285919 "$node_(202) setdest 36423 42061 2.0" 
$ns at 522.0155822426827 "$node_(202) setdest 125001 18398 7.0" 
$ns at 618.1730730341279 "$node_(202) setdest 16750 29621 4.0" 
$ns at 652.3065684969947 "$node_(202) setdest 45062 14263 2.0" 
$ns at 700.5262905866181 "$node_(202) setdest 105501 2290 12.0" 
$ns at 801.5534899117673 "$node_(202) setdest 9363 5720 2.0" 
$ns at 849.072731863579 "$node_(202) setdest 81475 10644 10.0" 
$ns at 888.3397940060609 "$node_(202) setdest 106671 4566 1.0" 
$ns at 219.1077447297169 "$node_(203) setdest 116236 41338 4.0" 
$ns at 268.6245605924878 "$node_(203) setdest 46732 8241 12.0" 
$ns at 334.83782255069036 "$node_(203) setdest 19168 38053 19.0" 
$ns at 436.42174151944306 "$node_(203) setdest 15124 42378 4.0" 
$ns at 477.45279648578247 "$node_(203) setdest 50031 30907 1.0" 
$ns at 511.80320654057033 "$node_(203) setdest 121611 34365 13.0" 
$ns at 598.7689557001555 "$node_(203) setdest 14137 25641 5.0" 
$ns at 653.1248908115084 "$node_(203) setdest 46933 33586 10.0" 
$ns at 717.4159459446399 "$node_(203) setdest 99625 18466 15.0" 
$ns at 893.9010640565593 "$node_(203) setdest 3757 24751 9.0" 
$ns at 231.58977463474326 "$node_(204) setdest 72819 38956 12.0" 
$ns at 357.6676124484472 "$node_(204) setdest 102272 13976 14.0" 
$ns at 413.92924179872875 "$node_(204) setdest 57624 390 7.0" 
$ns at 503.793642344806 "$node_(204) setdest 45879 27712 13.0" 
$ns at 545.9649911792294 "$node_(204) setdest 106742 21334 19.0" 
$ns at 646.2460543764423 "$node_(204) setdest 51717 41283 17.0" 
$ns at 836.3608340247124 "$node_(204) setdest 102667 36989 19.0" 
$ns at 216.07411370198264 "$node_(205) setdest 14153 12086 4.0" 
$ns at 283.3737666590754 "$node_(205) setdest 69803 42995 10.0" 
$ns at 326.18279598244675 "$node_(205) setdest 48432 30236 16.0" 
$ns at 426.34161887019144 "$node_(205) setdest 5603 20743 1.0" 
$ns at 456.97971973608816 "$node_(205) setdest 85147 900 7.0" 
$ns at 538.2073325789343 "$node_(205) setdest 66244 17455 1.0" 
$ns at 571.5582999543631 "$node_(205) setdest 14373 34377 2.0" 
$ns at 604.5043574149673 "$node_(205) setdest 71296 7721 12.0" 
$ns at 658.1472647786004 "$node_(205) setdest 69612 23818 7.0" 
$ns at 694.6671030276502 "$node_(205) setdest 14466 29469 3.0" 
$ns at 753.7060018427383 "$node_(205) setdest 1990 27805 17.0" 
$ns at 823.2494437189221 "$node_(205) setdest 85902 13865 12.0" 
$ns at 222.97349478195088 "$node_(206) setdest 46161 36613 12.0" 
$ns at 260.4150479818279 "$node_(206) setdest 119185 3404 3.0" 
$ns at 317.17922932020343 "$node_(206) setdest 40007 19082 2.0" 
$ns at 347.25363890582395 "$node_(206) setdest 60917 29305 15.0" 
$ns at 417.29195855258297 "$node_(206) setdest 45756 33494 17.0" 
$ns at 601.3996888108909 "$node_(206) setdest 1876 4028 17.0" 
$ns at 637.1745630586706 "$node_(206) setdest 74369 10375 1.0" 
$ns at 671.2707737072027 "$node_(206) setdest 27114 44236 11.0" 
$ns at 725.0680254468398 "$node_(206) setdest 13522 37404 15.0" 
$ns at 881.3521350005243 "$node_(206) setdest 34082 1405 6.0" 
$ns at 293.63520378685416 "$node_(207) setdest 115938 8017 14.0" 
$ns at 415.4794006910122 "$node_(207) setdest 109056 26003 12.0" 
$ns at 530.5148527313347 "$node_(207) setdest 84995 41570 2.0" 
$ns at 578.0956045047495 "$node_(207) setdest 29425 5796 7.0" 
$ns at 617.0671313327318 "$node_(207) setdest 107048 39850 4.0" 
$ns at 680.3390589035358 "$node_(207) setdest 73354 16254 16.0" 
$ns at 865.6188415429132 "$node_(207) setdest 79714 38161 8.0" 
$ns at 264.4328179460027 "$node_(208) setdest 70094 36285 1.0" 
$ns at 295.01300227281513 "$node_(208) setdest 122736 19566 8.0" 
$ns at 401.5611007858443 "$node_(208) setdest 26269 39751 13.0" 
$ns at 523.2030328491026 "$node_(208) setdest 124350 43523 3.0" 
$ns at 563.7925024842006 "$node_(208) setdest 60017 37783 11.0" 
$ns at 688.9226156423189 "$node_(208) setdest 26614 28552 16.0" 
$ns at 870.5744941984977 "$node_(208) setdest 94196 31480 12.0" 
$ns at 230.54962294656642 "$node_(209) setdest 14168 27298 10.0" 
$ns at 261.1954456990806 "$node_(209) setdest 49260 41474 6.0" 
$ns at 311.93258017152925 "$node_(209) setdest 52747 25815 11.0" 
$ns at 362.48177034820117 "$node_(209) setdest 66119 10819 8.0" 
$ns at 457.2670469108879 "$node_(209) setdest 102063 9169 4.0" 
$ns at 500.9577659033818 "$node_(209) setdest 107136 14396 16.0" 
$ns at 647.8728540724137 "$node_(209) setdest 73299 41798 17.0" 
$ns at 708.6773749673051 "$node_(209) setdest 42616 28261 13.0" 
$ns at 800.136521991896 "$node_(209) setdest 39365 7822 15.0" 
$ns at 893.0603891155884 "$node_(209) setdest 107016 21599 14.0" 
$ns at 204.86833022267456 "$node_(210) setdest 33332 17976 19.0" 
$ns at 237.40980643134225 "$node_(210) setdest 104238 25997 19.0" 
$ns at 372.9043725319795 "$node_(210) setdest 2549 7601 4.0" 
$ns at 435.94526106039996 "$node_(210) setdest 116413 21853 7.0" 
$ns at 501.2527046226516 "$node_(210) setdest 78134 10033 11.0" 
$ns at 603.2705216138089 "$node_(210) setdest 51751 3408 13.0" 
$ns at 721.4662059516845 "$node_(210) setdest 113409 42230 19.0" 
$ns at 322.20293280908066 "$node_(211) setdest 95546 6201 5.0" 
$ns at 358.59155295674685 "$node_(211) setdest 5896 28865 9.0" 
$ns at 429.97286176289504 "$node_(211) setdest 58089 22673 16.0" 
$ns at 531.2328456815659 "$node_(211) setdest 105714 42177 15.0" 
$ns at 619.63966649901 "$node_(211) setdest 48421 16386 8.0" 
$ns at 715.958549064498 "$node_(211) setdest 3751 42956 4.0" 
$ns at 766.5176551568519 "$node_(211) setdest 88776 31595 7.0" 
$ns at 830.2058812404626 "$node_(211) setdest 91470 41940 2.0" 
$ns at 873.8419585987216 "$node_(211) setdest 104767 30148 10.0" 
$ns at 223.3659574046947 "$node_(212) setdest 65815 17228 9.0" 
$ns at 258.2098990927094 "$node_(212) setdest 25416 15765 16.0" 
$ns at 439.40741059204555 "$node_(212) setdest 41099 39261 2.0" 
$ns at 471.3725097758758 "$node_(212) setdest 29850 40883 6.0" 
$ns at 538.4221932978563 "$node_(212) setdest 53914 38872 1.0" 
$ns at 577.150981045892 "$node_(212) setdest 111165 44318 17.0" 
$ns at 763.69588532265 "$node_(212) setdest 17375 7226 5.0" 
$ns at 821.356896705898 "$node_(212) setdest 44827 28329 12.0" 
$ns at 895.7630836381363 "$node_(212) setdest 14009 5742 13.0" 
$ns at 229.30082673998146 "$node_(213) setdest 41462 41001 7.0" 
$ns at 262.59529443073603 "$node_(213) setdest 2162 22578 5.0" 
$ns at 333.40854973468595 "$node_(213) setdest 100884 25789 16.0" 
$ns at 508.886085823014 "$node_(213) setdest 56534 41607 5.0" 
$ns at 546.6802391489621 "$node_(213) setdest 96052 27281 5.0" 
$ns at 609.4437934061533 "$node_(213) setdest 96453 5884 10.0" 
$ns at 651.5921492924798 "$node_(213) setdest 80286 26129 20.0" 
$ns at 826.8973221158725 "$node_(213) setdest 115775 22298 13.0" 
$ns at 879.9981812303173 "$node_(213) setdest 67557 43755 10.0" 
$ns at 301.8557951556876 "$node_(214) setdest 94599 40775 6.0" 
$ns at 361.21220145124835 "$node_(214) setdest 93539 28666 8.0" 
$ns at 426.2189658025801 "$node_(214) setdest 50708 32282 17.0" 
$ns at 496.671391979337 "$node_(214) setdest 16871 43886 18.0" 
$ns at 602.1986758914268 "$node_(214) setdest 105448 13647 13.0" 
$ns at 650.9484339524695 "$node_(214) setdest 19483 41269 2.0" 
$ns at 696.7638841485655 "$node_(214) setdest 6613 6470 20.0" 
$ns at 381.56111373883607 "$node_(215) setdest 74889 3221 4.0" 
$ns at 428.41030511553174 "$node_(215) setdest 31714 28736 5.0" 
$ns at 489.08330192348575 "$node_(215) setdest 20699 42524 7.0" 
$ns at 539.7135036795214 "$node_(215) setdest 10122 7426 8.0" 
$ns at 570.5375693308779 "$node_(215) setdest 71118 42803 2.0" 
$ns at 618.7634775297693 "$node_(215) setdest 9855 21107 12.0" 
$ns at 702.7617779351668 "$node_(215) setdest 67719 9448 12.0" 
$ns at 848.2827932842977 "$node_(215) setdest 1852 16428 1.0" 
$ns at 882.6032872743066 "$node_(215) setdest 110195 24881 19.0" 
$ns at 247.3482391574913 "$node_(216) setdest 16540 10415 12.0" 
$ns at 356.32820447073743 "$node_(216) setdest 120234 12045 4.0" 
$ns at 388.44955236815395 "$node_(216) setdest 75652 7467 11.0" 
$ns at 461.8574663307605 "$node_(216) setdest 61125 14415 16.0" 
$ns at 520.3161769560222 "$node_(216) setdest 21910 27863 3.0" 
$ns at 565.6106056227771 "$node_(216) setdest 53513 2021 12.0" 
$ns at 688.7283517358759 "$node_(216) setdest 121667 36283 3.0" 
$ns at 725.1903167018519 "$node_(216) setdest 111234 8722 16.0" 
$ns at 866.4555142867235 "$node_(216) setdest 64938 5927 9.0" 
$ns at 896.9708337345917 "$node_(216) setdest 133899 1509 1.0" 
$ns at 222.5185615462699 "$node_(217) setdest 62397 12645 7.0" 
$ns at 256.1126367272733 "$node_(217) setdest 75064 6694 4.0" 
$ns at 323.96390278716603 "$node_(217) setdest 74653 13769 13.0" 
$ns at 448.14953395252405 "$node_(217) setdest 56436 42522 19.0" 
$ns at 611.8022027105882 "$node_(217) setdest 110524 17757 17.0" 
$ns at 807.1026080544386 "$node_(217) setdest 66122 4701 13.0" 
$ns at 252.32647298158594 "$node_(218) setdest 126803 40850 4.0" 
$ns at 287.6548278500116 "$node_(218) setdest 85971 32264 16.0" 
$ns at 396.98019551646814 "$node_(218) setdest 99805 4859 20.0" 
$ns at 560.092865203716 "$node_(218) setdest 2062 9740 9.0" 
$ns at 651.4908400164155 "$node_(218) setdest 3165 18110 3.0" 
$ns at 711.3472992605681 "$node_(218) setdest 16939 6990 8.0" 
$ns at 816.793246518368 "$node_(218) setdest 17483 12407 13.0" 
$ns at 875.5912614728799 "$node_(218) setdest 47895 31399 2.0" 
$ns at 236.07370403599333 "$node_(219) setdest 16895 31696 18.0" 
$ns at 431.0335811221315 "$node_(219) setdest 78570 35138 17.0" 
$ns at 579.5435891847084 "$node_(219) setdest 126989 3806 8.0" 
$ns at 663.747572713657 "$node_(219) setdest 65496 19637 11.0" 
$ns at 710.5110790155468 "$node_(219) setdest 3878 43351 18.0" 
$ns at 789.9124886149623 "$node_(219) setdest 9081 28954 14.0" 
$ns at 872.2763349864236 "$node_(219) setdest 112357 36185 6.0" 
$ns at 259.5883452955389 "$node_(220) setdest 110607 5323 8.0" 
$ns at 342.2406315253489 "$node_(220) setdest 62008 6763 18.0" 
$ns at 453.8912389866092 "$node_(220) setdest 69028 12775 14.0" 
$ns at 495.8941530571194 "$node_(220) setdest 21980 43011 11.0" 
$ns at 567.0087268356398 "$node_(220) setdest 106490 17885 16.0" 
$ns at 736.0741523265197 "$node_(220) setdest 24263 29912 18.0" 
$ns at 856.0762948793723 "$node_(220) setdest 128103 35638 18.0" 
$ns at 233.4585320998622 "$node_(221) setdest 7568 14848 16.0" 
$ns at 395.25679114774476 "$node_(221) setdest 34298 5603 11.0" 
$ns at 465.87647971486655 "$node_(221) setdest 15701 26684 14.0" 
$ns at 614.3623742199688 "$node_(221) setdest 90287 27669 7.0" 
$ns at 657.7054017684575 "$node_(221) setdest 48119 13577 6.0" 
$ns at 736.3677551120951 "$node_(221) setdest 33659 33138 19.0" 
$ns at 796.5169432973158 "$node_(221) setdest 39056 6641 6.0" 
$ns at 831.245584909378 "$node_(221) setdest 49831 7813 14.0" 
$ns at 243.49039652525883 "$node_(222) setdest 52898 36988 5.0" 
$ns at 318.86526823194373 "$node_(222) setdest 4351 13355 16.0" 
$ns at 491.0422606047423 "$node_(222) setdest 36329 1578 8.0" 
$ns at 531.1050980244638 "$node_(222) setdest 4417 18988 5.0" 
$ns at 563.2085400786409 "$node_(222) setdest 17470 39067 12.0" 
$ns at 636.9164348388074 "$node_(222) setdest 102986 13658 4.0" 
$ns at 681.8365716034015 "$node_(222) setdest 38487 12918 15.0" 
$ns at 830.3960008744192 "$node_(222) setdest 114788 31268 8.0" 
$ns at 893.0236157375263 "$node_(222) setdest 50683 39494 1.0" 
$ns at 277.0763776002217 "$node_(223) setdest 73757 44447 5.0" 
$ns at 325.649711685225 "$node_(223) setdest 77820 18837 3.0" 
$ns at 376.3601851797492 "$node_(223) setdest 99816 7721 16.0" 
$ns at 540.1324238221603 "$node_(223) setdest 84643 17859 10.0" 
$ns at 638.0264723319044 "$node_(223) setdest 121928 25245 16.0" 
$ns at 671.4630933883032 "$node_(223) setdest 114260 31204 1.0" 
$ns at 705.5684887272405 "$node_(223) setdest 57278 17777 18.0" 
$ns at 749.0020792550813 "$node_(223) setdest 36668 31062 8.0" 
$ns at 838.4079198158469 "$node_(223) setdest 45641 37557 7.0" 
$ns at 868.6022997214229 "$node_(223) setdest 41539 8304 10.0" 
$ns at 264.6569569369981 "$node_(224) setdest 10968 4681 1.0" 
$ns at 303.61359107481655 "$node_(224) setdest 27775 32111 3.0" 
$ns at 354.539460233388 "$node_(224) setdest 84583 23411 10.0" 
$ns at 399.39611942555155 "$node_(224) setdest 111698 28113 14.0" 
$ns at 498.8356698811971 "$node_(224) setdest 122194 36957 8.0" 
$ns at 540.7704338583882 "$node_(224) setdest 66755 29875 1.0" 
$ns at 575.4319947407961 "$node_(224) setdest 102642 32543 8.0" 
$ns at 663.9669612554121 "$node_(224) setdest 129786 39615 7.0" 
$ns at 710.4391831488117 "$node_(224) setdest 38641 12750 17.0" 
$ns at 763.5540006657338 "$node_(224) setdest 132057 26501 15.0" 
$ns at 828.7162694926105 "$node_(224) setdest 127476 15241 15.0" 
$ns at 217.76680538784973 "$node_(225) setdest 73870 21845 2.0" 
$ns at 252.41639206216496 "$node_(225) setdest 96410 6260 16.0" 
$ns at 437.8747167069516 "$node_(225) setdest 108463 3916 4.0" 
$ns at 504.46508025819577 "$node_(225) setdest 68416 35755 11.0" 
$ns at 628.2151820851125 "$node_(225) setdest 130541 7262 10.0" 
$ns at 736.8597466375431 "$node_(225) setdest 99256 14939 11.0" 
$ns at 863.49882697872 "$node_(225) setdest 75794 26927 16.0" 
$ns at 201.35597835105114 "$node_(226) setdest 88444 31172 6.0" 
$ns at 248.54752257722848 "$node_(226) setdest 116025 38827 14.0" 
$ns at 352.80596444398924 "$node_(226) setdest 122050 5881 2.0" 
$ns at 384.0038995061887 "$node_(226) setdest 26080 35811 4.0" 
$ns at 444.87201277931797 "$node_(226) setdest 84407 33463 1.0" 
$ns at 476.4991463221772 "$node_(226) setdest 63860 14523 1.0" 
$ns at 514.8553327727127 "$node_(226) setdest 121750 134 1.0" 
$ns at 547.07670637902 "$node_(226) setdest 42138 3750 11.0" 
$ns at 617.1988499929387 "$node_(226) setdest 74198 9912 8.0" 
$ns at 684.7965284059884 "$node_(226) setdest 53491 4574 5.0" 
$ns at 738.526047124627 "$node_(226) setdest 57455 15097 9.0" 
$ns at 773.0896005288527 "$node_(226) setdest 61244 23618 1.0" 
$ns at 806.2537449088774 "$node_(226) setdest 56270 21910 2.0" 
$ns at 836.5720234659868 "$node_(226) setdest 40096 37628 15.0" 
$ns at 879.5008533741731 "$node_(226) setdest 37430 22472 5.0" 
$ns at 238.32968127954362 "$node_(227) setdest 34863 12180 10.0" 
$ns at 332.6402515587768 "$node_(227) setdest 130518 32186 3.0" 
$ns at 391.90732395723256 "$node_(227) setdest 70488 39445 19.0" 
$ns at 599.1422429857968 "$node_(227) setdest 52757 20914 20.0" 
$ns at 828.4904053337334 "$node_(227) setdest 6888 44361 2.0" 
$ns at 861.5791062958103 "$node_(227) setdest 23169 22509 2.0" 
$ns at 203.10096563824334 "$node_(228) setdest 91689 38111 15.0" 
$ns at 301.8391122600431 "$node_(228) setdest 13505 7708 11.0" 
$ns at 404.28352910728904 "$node_(228) setdest 69385 43809 14.0" 
$ns at 532.4258523874186 "$node_(228) setdest 91091 17927 2.0" 
$ns at 578.543325412106 "$node_(228) setdest 11629 34862 10.0" 
$ns at 683.3343459076724 "$node_(228) setdest 19677 28163 16.0" 
$ns at 818.065549910247 "$node_(228) setdest 64388 23377 19.0" 
$ns at 232.82616391042404 "$node_(229) setdest 128535 29996 8.0" 
$ns at 280.9179328964052 "$node_(229) setdest 84167 15552 2.0" 
$ns at 315.17068605915244 "$node_(229) setdest 42099 37910 17.0" 
$ns at 395.24285122348783 "$node_(229) setdest 96838 2375 1.0" 
$ns at 428.60162295042613 "$node_(229) setdest 73568 24051 4.0" 
$ns at 494.7855185350416 "$node_(229) setdest 29213 44286 10.0" 
$ns at 565.8834239001532 "$node_(229) setdest 81995 4855 7.0" 
$ns at 649.6340747601091 "$node_(229) setdest 75290 36873 3.0" 
$ns at 687.0076435531162 "$node_(229) setdest 89511 33967 13.0" 
$ns at 807.0976045627475 "$node_(229) setdest 91236 620 12.0" 
$ns at 890.3656434712871 "$node_(229) setdest 40698 33466 13.0" 
$ns at 208.35643561063068 "$node_(230) setdest 129198 7846 17.0" 
$ns at 293.9427358565987 "$node_(230) setdest 15979 30160 11.0" 
$ns at 378.4324505725036 "$node_(230) setdest 31169 13381 14.0" 
$ns at 545.1653249344192 "$node_(230) setdest 123158 37682 16.0" 
$ns at 666.6425331686241 "$node_(230) setdest 12489 33478 4.0" 
$ns at 719.2684692152101 "$node_(230) setdest 1621 27778 8.0" 
$ns at 769.7012848772606 "$node_(230) setdest 65664 4073 13.0" 
$ns at 868.593853430017 "$node_(230) setdest 74313 32806 15.0" 
$ns at 207.32892458607506 "$node_(231) setdest 103639 7828 5.0" 
$ns at 252.51173381163218 "$node_(231) setdest 131528 208 2.0" 
$ns at 284.127563798056 "$node_(231) setdest 35283 10118 15.0" 
$ns at 340.40325305595985 "$node_(231) setdest 42812 22216 8.0" 
$ns at 389.08524379555627 "$node_(231) setdest 13858 16015 2.0" 
$ns at 423.91422705365164 "$node_(231) setdest 118649 2533 15.0" 
$ns at 501.6834570084708 "$node_(231) setdest 134085 36066 14.0" 
$ns at 619.6625360322382 "$node_(231) setdest 8860 23893 14.0" 
$ns at 668.2847362662368 "$node_(231) setdest 127541 41923 12.0" 
$ns at 717.8516768927111 "$node_(231) setdest 31336 28495 9.0" 
$ns at 809.5649713858214 "$node_(231) setdest 34948 14095 14.0" 
$ns at 226.84047682531374 "$node_(232) setdest 29875 16204 17.0" 
$ns at 260.24904000792816 "$node_(232) setdest 102978 34713 11.0" 
$ns at 309.76891059108806 "$node_(232) setdest 31718 39571 12.0" 
$ns at 395.8860436225052 "$node_(232) setdest 25508 14895 7.0" 
$ns at 453.7772551035279 "$node_(232) setdest 130899 35822 20.0" 
$ns at 574.8792279383906 "$node_(232) setdest 25144 39101 9.0" 
$ns at 656.3864675937903 "$node_(232) setdest 21073 474 13.0" 
$ns at 720.3898284542561 "$node_(232) setdest 28010 43544 10.0" 
$ns at 781.7532840498457 "$node_(232) setdest 85858 4002 1.0" 
$ns at 815.7698177664938 "$node_(232) setdest 69484 36393 12.0" 
$ns at 848.7039033187416 "$node_(232) setdest 56190 17748 6.0" 
$ns at 233.3256014819165 "$node_(233) setdest 76922 20892 11.0" 
$ns at 369.5049006986162 "$node_(233) setdest 82596 24640 10.0" 
$ns at 447.5708975417225 "$node_(233) setdest 78847 39833 4.0" 
$ns at 497.1220269883118 "$node_(233) setdest 15851 1765 18.0" 
$ns at 678.4277581118885 "$node_(233) setdest 106082 24713 14.0" 
$ns at 754.8212314041707 "$node_(233) setdest 49491 23128 13.0" 
$ns at 212.06619661969566 "$node_(234) setdest 89828 36788 10.0" 
$ns at 258.48067439040153 "$node_(234) setdest 36960 40935 11.0" 
$ns at 294.9138677105951 "$node_(234) setdest 50119 39041 15.0" 
$ns at 329.23855244455876 "$node_(234) setdest 90976 14859 8.0" 
$ns at 378.9256239872321 "$node_(234) setdest 7030 35176 6.0" 
$ns at 464.09259310052335 "$node_(234) setdest 53005 37576 1.0" 
$ns at 495.88014517362876 "$node_(234) setdest 6290 3402 15.0" 
$ns at 608.1416565123876 "$node_(234) setdest 96429 26535 6.0" 
$ns at 642.4969492611847 "$node_(234) setdest 13730 30987 12.0" 
$ns at 675.3193710735434 "$node_(234) setdest 52625 34004 10.0" 
$ns at 770.6168375213142 "$node_(234) setdest 123712 5833 3.0" 
$ns at 819.5654011736141 "$node_(234) setdest 133797 26973 9.0" 
$ns at 331.3302389095174 "$node_(235) setdest 60594 33949 6.0" 
$ns at 403.3032043978451 "$node_(235) setdest 20809 16530 1.0" 
$ns at 439.6815031869543 "$node_(235) setdest 7805 23015 11.0" 
$ns at 494.07950714852603 "$node_(235) setdest 37483 33646 6.0" 
$ns at 577.2438265063345 "$node_(235) setdest 86778 38153 10.0" 
$ns at 679.4262464407932 "$node_(235) setdest 105027 7581 5.0" 
$ns at 713.2651329865859 "$node_(235) setdest 131247 25140 15.0" 
$ns at 863.8222185676923 "$node_(235) setdest 57614 28115 14.0" 
$ns at 211.33290252426627 "$node_(236) setdest 55150 38017 5.0" 
$ns at 263.82457663416653 "$node_(236) setdest 28604 35081 8.0" 
$ns at 339.809922818039 "$node_(236) setdest 113945 37896 5.0" 
$ns at 382.3277871768833 "$node_(236) setdest 119234 11480 4.0" 
$ns at 434.60444620232886 "$node_(236) setdest 54360 14305 8.0" 
$ns at 518.1080936958002 "$node_(236) setdest 122404 19989 19.0" 
$ns at 709.1210409037595 "$node_(236) setdest 60205 30109 13.0" 
$ns at 771.8726074179048 "$node_(236) setdest 71481 18912 2.0" 
$ns at 813.5039511767492 "$node_(236) setdest 58082 32472 11.0" 
$ns at 898.470901137847 "$node_(236) setdest 110990 33106 7.0" 
$ns at 234.88538297199324 "$node_(237) setdest 72405 39182 10.0" 
$ns at 359.55639821599675 "$node_(237) setdest 23935 36880 18.0" 
$ns at 434.4049474111492 "$node_(237) setdest 127286 12955 16.0" 
$ns at 516.0409110489065 "$node_(237) setdest 64145 7323 12.0" 
$ns at 618.0017784317633 "$node_(237) setdest 75280 6468 7.0" 
$ns at 653.6194787202372 "$node_(237) setdest 36305 17069 7.0" 
$ns at 722.7230795620347 "$node_(237) setdest 812 24852 2.0" 
$ns at 770.7282234199521 "$node_(237) setdest 93389 9552 14.0" 
$ns at 221.46603369343703 "$node_(238) setdest 11240 43205 15.0" 
$ns at 278.647576200867 "$node_(238) setdest 41903 38107 9.0" 
$ns at 371.87215706250555 "$node_(238) setdest 44543 27467 6.0" 
$ns at 420.2344311435825 "$node_(238) setdest 37184 39104 18.0" 
$ns at 577.4390852629642 "$node_(238) setdest 38496 12932 19.0" 
$ns at 664.9565612081486 "$node_(238) setdest 94910 22079 9.0" 
$ns at 778.4241315074698 "$node_(238) setdest 10190 40072 4.0" 
$ns at 825.3589214362205 "$node_(238) setdest 71607 29359 16.0" 
$ns at 303.8052455464484 "$node_(239) setdest 88801 36193 7.0" 
$ns at 393.2127625042041 "$node_(239) setdest 94001 13797 7.0" 
$ns at 479.70110112271436 "$node_(239) setdest 97473 38021 14.0" 
$ns at 598.2845064377774 "$node_(239) setdest 112811 35995 6.0" 
$ns at 659.4574914295766 "$node_(239) setdest 122139 35827 14.0" 
$ns at 757.4759870168566 "$node_(239) setdest 27460 40425 6.0" 
$ns at 834.8728865842282 "$node_(239) setdest 52201 372 14.0" 
$ns at 227.28843652766912 "$node_(240) setdest 44679 32079 8.0" 
$ns at 264.7335673007614 "$node_(240) setdest 70687 22367 6.0" 
$ns at 305.89473379594267 "$node_(240) setdest 24654 37426 12.0" 
$ns at 395.5292184511969 "$node_(240) setdest 94785 1997 6.0" 
$ns at 427.7805736264605 "$node_(240) setdest 74063 2661 8.0" 
$ns at 479.2291684432642 "$node_(240) setdest 69667 26754 9.0" 
$ns at 593.4270156345382 "$node_(240) setdest 25675 28284 11.0" 
$ns at 685.4785162966825 "$node_(240) setdest 68410 34456 8.0" 
$ns at 781.3813587466998 "$node_(240) setdest 116542 36352 9.0" 
$ns at 822.3002973711019 "$node_(240) setdest 58063 25577 17.0" 
$ns at 227.73770277928014 "$node_(241) setdest 31117 39392 16.0" 
$ns at 269.23792839838217 "$node_(241) setdest 66169 4253 19.0" 
$ns at 323.9086779139737 "$node_(241) setdest 74946 3736 2.0" 
$ns at 371.63503117054427 "$node_(241) setdest 400 21156 15.0" 
$ns at 494.2184228259059 "$node_(241) setdest 131093 39457 7.0" 
$ns at 578.4045223826575 "$node_(241) setdest 35200 30834 10.0" 
$ns at 698.5236522397431 "$node_(241) setdest 58528 32629 20.0" 
$ns at 793.3746282980301 "$node_(241) setdest 21218 17950 12.0" 
$ns at 896.4366594135574 "$node_(241) setdest 104253 16284 6.0" 
$ns at 251.52071844468628 "$node_(242) setdest 50407 11177 17.0" 
$ns at 293.8522488638205 "$node_(242) setdest 93712 25305 16.0" 
$ns at 342.49633312633034 "$node_(242) setdest 88341 17657 18.0" 
$ns at 381.82380737516934 "$node_(242) setdest 11763 44398 16.0" 
$ns at 453.2537698376213 "$node_(242) setdest 106116 29087 10.0" 
$ns at 513.5391392281441 "$node_(242) setdest 17799 8408 5.0" 
$ns at 573.4531694075717 "$node_(242) setdest 127206 42618 7.0" 
$ns at 606.290771937139 "$node_(242) setdest 100405 4314 2.0" 
$ns at 653.9003902931591 "$node_(242) setdest 46789 14487 3.0" 
$ns at 713.7216860540157 "$node_(242) setdest 15974 39806 15.0" 
$ns at 777.5066757159576 "$node_(242) setdest 3558 15174 1.0" 
$ns at 814.1671172387796 "$node_(242) setdest 70098 17056 15.0" 
$ns at 260.20091008405313 "$node_(243) setdest 82939 18396 8.0" 
$ns at 300.18739400985305 "$node_(243) setdest 119924 9481 16.0" 
$ns at 440.5309542211297 "$node_(243) setdest 105786 16539 11.0" 
$ns at 568.1572975728416 "$node_(243) setdest 66377 38703 4.0" 
$ns at 619.6374090169187 "$node_(243) setdest 56251 5399 15.0" 
$ns at 770.6968678671024 "$node_(243) setdest 99611 18919 15.0" 
$ns at 827.5484842938821 "$node_(243) setdest 13772 25748 3.0" 
$ns at 878.9192321399283 "$node_(243) setdest 127041 10806 11.0" 
$ns at 211.6300044472424 "$node_(244) setdest 97996 32449 14.0" 
$ns at 284.26416151458716 "$node_(244) setdest 77523 5875 4.0" 
$ns at 352.70277364892564 "$node_(244) setdest 72938 10401 1.0" 
$ns at 388.32223984553895 "$node_(244) setdest 123683 12142 19.0" 
$ns at 425.61196405600043 "$node_(244) setdest 80072 38975 16.0" 
$ns at 531.3008953873511 "$node_(244) setdest 113390 2045 19.0" 
$ns at 595.7894200828445 "$node_(244) setdest 59655 9507 11.0" 
$ns at 667.9216674302891 "$node_(244) setdest 6793 7766 9.0" 
$ns at 769.4874651009168 "$node_(244) setdest 95666 7986 18.0" 
$ns at 818.796290337901 "$node_(244) setdest 29989 23557 9.0" 
$ns at 899.7254234275638 "$node_(244) setdest 94750 28503 3.0" 
$ns at 274.0092878409931 "$node_(245) setdest 58243 4353 9.0" 
$ns at 315.06335317421133 "$node_(245) setdest 76595 8315 7.0" 
$ns at 404.81846519961925 "$node_(245) setdest 62972 37808 4.0" 
$ns at 435.8579510708229 "$node_(245) setdest 16281 44633 16.0" 
$ns at 550.2751660425236 "$node_(245) setdest 69524 21657 17.0" 
$ns at 584.5532588505534 "$node_(245) setdest 4665 1680 11.0" 
$ns at 720.9479226370296 "$node_(245) setdest 49219 40011 6.0" 
$ns at 770.4625408568805 "$node_(245) setdest 27888 26013 3.0" 
$ns at 825.466077553638 "$node_(245) setdest 60286 34494 16.0" 
$ns at 297.73761732702667 "$node_(246) setdest 29099 1875 14.0" 
$ns at 461.9750650618731 "$node_(246) setdest 119873 4237 5.0" 
$ns at 536.4742937682704 "$node_(246) setdest 46906 1403 4.0" 
$ns at 594.3713012902954 "$node_(246) setdest 39724 14190 11.0" 
$ns at 709.6496303425888 "$node_(246) setdest 19077 40352 4.0" 
$ns at 777.691032999242 "$node_(246) setdest 34135 9784 3.0" 
$ns at 813.3391892570594 "$node_(246) setdest 8957 14407 17.0" 
$ns at 222.26150996957816 "$node_(247) setdest 18776 36780 6.0" 
$ns at 300.7711808281944 "$node_(247) setdest 119172 28960 18.0" 
$ns at 338.9743186628227 "$node_(247) setdest 17047 18822 6.0" 
$ns at 402.73170946987597 "$node_(247) setdest 39677 13534 11.0" 
$ns at 491.0402336325917 "$node_(247) setdest 86199 40191 17.0" 
$ns at 675.899814461493 "$node_(247) setdest 113770 35220 17.0" 
$ns at 820.3527552709605 "$node_(247) setdest 27150 23266 10.0" 
$ns at 861.9523712452453 "$node_(247) setdest 4693 25443 15.0" 
$ns at 259.35878262674476 "$node_(248) setdest 73550 18124 14.0" 
$ns at 363.5645916806815 "$node_(248) setdest 92109 1448 16.0" 
$ns at 537.6453923682889 "$node_(248) setdest 37570 35970 6.0" 
$ns at 607.5621785790178 "$node_(248) setdest 88305 23048 19.0" 
$ns at 695.4829157748231 "$node_(248) setdest 1420 11650 14.0" 
$ns at 798.1891753693935 "$node_(248) setdest 49292 780 14.0" 
$ns at 246.8138396623417 "$node_(249) setdest 104577 19477 13.0" 
$ns at 285.0506236585639 "$node_(249) setdest 125304 29636 6.0" 
$ns at 325.29488607343853 "$node_(249) setdest 64813 28523 19.0" 
$ns at 421.73253414381304 "$node_(249) setdest 48559 1623 4.0" 
$ns at 470.4278834306491 "$node_(249) setdest 71768 15849 3.0" 
$ns at 526.1153499477011 "$node_(249) setdest 78417 14498 13.0" 
$ns at 604.5278278344051 "$node_(249) setdest 112116 12578 3.0" 
$ns at 662.7266331861599 "$node_(249) setdest 84015 23563 12.0" 
$ns at 737.7178863506599 "$node_(249) setdest 133263 28845 7.0" 
$ns at 813.5682256830688 "$node_(249) setdest 82484 36226 6.0" 
$ns at 893.3528236081514 "$node_(249) setdest 42607 15773 16.0" 
$ns at 223.85733906242484 "$node_(250) setdest 106307 8256 4.0" 
$ns at 293.7332213663156 "$node_(250) setdest 11203 38275 4.0" 
$ns at 358.19528319597765 "$node_(250) setdest 130212 33354 13.0" 
$ns at 391.45318642241745 "$node_(250) setdest 126599 17102 3.0" 
$ns at 428.6347978794879 "$node_(250) setdest 130830 40502 2.0" 
$ns at 468.6121979169025 "$node_(250) setdest 2493 24534 18.0" 
$ns at 649.1780547614545 "$node_(250) setdest 127741 12453 17.0" 
$ns at 709.482630938277 "$node_(250) setdest 87302 37151 15.0" 
$ns at 820.0983803643462 "$node_(250) setdest 16614 28194 5.0" 
$ns at 852.3625170533039 "$node_(250) setdest 109812 23021 2.0" 
$ns at 886.1259586076831 "$node_(250) setdest 34017 33339 17.0" 
$ns at 236.1141066941951 "$node_(251) setdest 98821 43346 18.0" 
$ns at 344.71362843514385 "$node_(251) setdest 15884 11425 3.0" 
$ns at 381.3731610068073 "$node_(251) setdest 66723 12072 19.0" 
$ns at 596.0799288082248 "$node_(251) setdest 45834 3191 19.0" 
$ns at 708.5382156212659 "$node_(251) setdest 97787 17932 5.0" 
$ns at 782.2766292069607 "$node_(251) setdest 103444 9073 18.0" 
$ns at 257.9286672300239 "$node_(252) setdest 77824 42466 16.0" 
$ns at 440.67913100478097 "$node_(252) setdest 124494 29869 9.0" 
$ns at 473.1698302919132 "$node_(252) setdest 60355 7882 6.0" 
$ns at 558.1022471766958 "$node_(252) setdest 32889 26133 4.0" 
$ns at 625.3864306207349 "$node_(252) setdest 24006 44468 17.0" 
$ns at 718.3729431074154 "$node_(252) setdest 92226 28855 14.0" 
$ns at 806.6278076986056 "$node_(252) setdest 74767 28226 16.0" 
$ns at 270.28004859189593 "$node_(253) setdest 129761 39246 16.0" 
$ns at 374.03102301274475 "$node_(253) setdest 11467 28321 5.0" 
$ns at 425.42806440797455 "$node_(253) setdest 3482 4166 18.0" 
$ns at 627.2901724018648 "$node_(253) setdest 89771 581 4.0" 
$ns at 696.3529745489246 "$node_(253) setdest 58365 20078 10.0" 
$ns at 794.141615538391 "$node_(253) setdest 103111 9371 3.0" 
$ns at 852.5291406939369 "$node_(253) setdest 46675 8565 2.0" 
$ns at 220.34820790712035 "$node_(254) setdest 8167 26865 18.0" 
$ns at 325.75744954740424 "$node_(254) setdest 52435 10143 19.0" 
$ns at 501.0045267128703 "$node_(254) setdest 32796 25486 19.0" 
$ns at 672.4016918980445 "$node_(254) setdest 118835 28470 17.0" 
$ns at 862.30334807075 "$node_(254) setdest 2710 1653 9.0" 
$ns at 254.43572828302467 "$node_(255) setdest 87386 39385 16.0" 
$ns at 290.5355165349887 "$node_(255) setdest 42986 34298 16.0" 
$ns at 349.3326967124628 "$node_(255) setdest 60760 8190 15.0" 
$ns at 479.2046719990499 "$node_(255) setdest 36261 36756 8.0" 
$ns at 551.9048683042743 "$node_(255) setdest 344 26240 9.0" 
$ns at 601.710354648032 "$node_(255) setdest 99116 30219 15.0" 
$ns at 698.5146040944718 "$node_(255) setdest 25227 22567 6.0" 
$ns at 733.7806460723693 "$node_(255) setdest 67388 14236 16.0" 
$ns at 771.7624993971524 "$node_(255) setdest 105265 25491 12.0" 
$ns at 899.1145165686726 "$node_(255) setdest 38614 23933 14.0" 
$ns at 201.6684444506921 "$node_(256) setdest 34229 42204 10.0" 
$ns at 324.6298056828194 "$node_(256) setdest 64976 7023 16.0" 
$ns at 428.6964370938484 "$node_(256) setdest 63122 18824 9.0" 
$ns at 514.6851365878649 "$node_(256) setdest 111041 42573 8.0" 
$ns at 558.2657676064697 "$node_(256) setdest 65089 36450 20.0" 
$ns at 696.8646792905482 "$node_(256) setdest 8101 29127 9.0" 
$ns at 771.5396401535955 "$node_(256) setdest 51241 3913 2.0" 
$ns at 816.3673599089914 "$node_(256) setdest 49294 36460 11.0" 
$ns at 869.8048551393906 "$node_(256) setdest 121174 12445 11.0" 
$ns at 204.39110682337179 "$node_(257) setdest 102719 16369 9.0" 
$ns at 270.26751818446337 "$node_(257) setdest 77741 41911 3.0" 
$ns at 314.4279931899176 "$node_(257) setdest 38134 28762 13.0" 
$ns at 471.95963062478165 "$node_(257) setdest 110399 33406 5.0" 
$ns at 533.494160641821 "$node_(257) setdest 32033 27910 11.0" 
$ns at 571.7107973183035 "$node_(257) setdest 734 29994 9.0" 
$ns at 676.8109169973293 "$node_(257) setdest 82979 35941 17.0" 
$ns at 727.1591149057213 "$node_(257) setdest 48781 26168 18.0" 
$ns at 795.2803487509374 "$node_(257) setdest 78806 30181 7.0" 
$ns at 838.7830220730855 "$node_(257) setdest 15166 6190 1.0" 
$ns at 874.6130997189728 "$node_(257) setdest 89586 5388 1.0" 
$ns at 214.5697773115466 "$node_(258) setdest 15311 12041 12.0" 
$ns at 249.3679751558591 "$node_(258) setdest 37390 21702 5.0" 
$ns at 298.7773141299715 "$node_(258) setdest 89967 14552 9.0" 
$ns at 331.150077538937 "$node_(258) setdest 37102 9968 15.0" 
$ns at 468.2950220989128 "$node_(258) setdest 86062 24168 3.0" 
$ns at 511.8160717299548 "$node_(258) setdest 62518 39723 5.0" 
$ns at 568.48998580364 "$node_(258) setdest 23640 37364 12.0" 
$ns at 672.2667419169846 "$node_(258) setdest 83073 29986 18.0" 
$ns at 835.0121426772539 "$node_(258) setdest 114731 8541 13.0" 
$ns at 247.57849994598678 "$node_(259) setdest 124800 43810 1.0" 
$ns at 280.31896833715365 "$node_(259) setdest 108447 3074 7.0" 
$ns at 311.64786006172903 "$node_(259) setdest 86785 28628 11.0" 
$ns at 357.2719645709953 "$node_(259) setdest 25010 44396 1.0" 
$ns at 394.483275597554 "$node_(259) setdest 1563 29603 12.0" 
$ns at 536.4815112066083 "$node_(259) setdest 57544 31580 9.0" 
$ns at 568.8898291141063 "$node_(259) setdest 97234 1629 16.0" 
$ns at 646.9486937558622 "$node_(259) setdest 116865 9725 12.0" 
$ns at 760.09121796158 "$node_(259) setdest 33248 30389 18.0" 
$ns at 798.8539794264262 "$node_(259) setdest 48944 42511 15.0" 
$ns at 866.437588049336 "$node_(259) setdest 118344 15326 7.0" 
$ns at 288.9549140898042 "$node_(260) setdest 37021 2655 1.0" 
$ns at 322.9591362503336 "$node_(260) setdest 20746 14998 19.0" 
$ns at 407.50717879738056 "$node_(260) setdest 11145 8196 16.0" 
$ns at 579.1758005010059 "$node_(260) setdest 34678 26717 9.0" 
$ns at 655.2259980586214 "$node_(260) setdest 44253 16915 15.0" 
$ns at 686.7234563354333 "$node_(260) setdest 71324 42460 15.0" 
$ns at 724.6389327960733 "$node_(260) setdest 126012 32783 11.0" 
$ns at 769.7415815645031 "$node_(260) setdest 60287 40492 12.0" 
$ns at 814.2160955586522 "$node_(260) setdest 37580 2639 10.0" 
$ns at 308.5403220464967 "$node_(261) setdest 37321 7131 9.0" 
$ns at 390.3718745012917 "$node_(261) setdest 113932 10598 15.0" 
$ns at 531.7828858989355 "$node_(261) setdest 110617 1490 6.0" 
$ns at 591.0149091735406 "$node_(261) setdest 47753 25172 12.0" 
$ns at 681.6785408107035 "$node_(261) setdest 83441 5265 16.0" 
$ns at 832.4946216456484 "$node_(261) setdest 75612 25480 18.0" 
$ns at 215.8968386740224 "$node_(262) setdest 44696 21054 3.0" 
$ns at 272.16031814239125 "$node_(262) setdest 47030 30545 7.0" 
$ns at 371.94050314702434 "$node_(262) setdest 116072 33813 9.0" 
$ns at 430.5955189299087 "$node_(262) setdest 70998 18029 1.0" 
$ns at 462.2434678649924 "$node_(262) setdest 27079 26006 1.0" 
$ns at 495.8162156522007 "$node_(262) setdest 23365 11223 11.0" 
$ns at 605.8100446911474 "$node_(262) setdest 33830 14719 6.0" 
$ns at 661.0778561102885 "$node_(262) setdest 45121 16092 14.0" 
$ns at 774.0438908766029 "$node_(262) setdest 60746 10456 13.0" 
$ns at 205.19902967767945 "$node_(263) setdest 57468 11638 17.0" 
$ns at 263.53213398912226 "$node_(263) setdest 34601 22323 15.0" 
$ns at 363.0571975401391 "$node_(263) setdest 18986 6440 5.0" 
$ns at 399.0772841174436 "$node_(263) setdest 33671 9856 19.0" 
$ns at 453.0420035320824 "$node_(263) setdest 80189 32249 16.0" 
$ns at 621.3204345171403 "$node_(263) setdest 124250 37822 12.0" 
$ns at 676.1945298172451 "$node_(263) setdest 94420 8439 5.0" 
$ns at 733.4347479354147 "$node_(263) setdest 88534 13714 14.0" 
$ns at 853.9637289011873 "$node_(263) setdest 56675 42553 18.0" 
$ns at 241.9739891394767 "$node_(264) setdest 71979 22022 10.0" 
$ns at 298.98218957864214 "$node_(264) setdest 24103 33938 13.0" 
$ns at 392.6683449333609 "$node_(264) setdest 73437 24930 5.0" 
$ns at 444.666994774259 "$node_(264) setdest 57184 6198 6.0" 
$ns at 499.79197768627665 "$node_(264) setdest 45355 15789 16.0" 
$ns at 627.4818213768999 "$node_(264) setdest 90049 38963 10.0" 
$ns at 725.1547827444006 "$node_(264) setdest 111598 43428 18.0" 
$ns at 846.0110393114567 "$node_(264) setdest 106750 15135 18.0" 
$ns at 229.4868392001769 "$node_(265) setdest 52324 29973 11.0" 
$ns at 341.0539092543459 "$node_(265) setdest 34717 14079 11.0" 
$ns at 373.14793007385026 "$node_(265) setdest 67913 14428 8.0" 
$ns at 454.8396990602611 "$node_(265) setdest 99466 9030 9.0" 
$ns at 522.3601475268333 "$node_(265) setdest 91853 17147 17.0" 
$ns at 624.6109821572951 "$node_(265) setdest 1445 43849 15.0" 
$ns at 725.3493731237176 "$node_(265) setdest 106993 8993 11.0" 
$ns at 773.0377715382413 "$node_(265) setdest 55574 28596 12.0" 
$ns at 210.38457241792287 "$node_(266) setdest 10330 40586 7.0" 
$ns at 251.6373295570999 "$node_(266) setdest 18364 12556 1.0" 
$ns at 285.30164491296483 "$node_(266) setdest 30397 18764 19.0" 
$ns at 370.151978647238 "$node_(266) setdest 102659 18550 19.0" 
$ns at 409.9836589033828 "$node_(266) setdest 30004 33949 13.0" 
$ns at 444.5521476094172 "$node_(266) setdest 8334 4809 19.0" 
$ns at 516.6804925038964 "$node_(266) setdest 18300 24764 16.0" 
$ns at 686.6792859833702 "$node_(266) setdest 91343 33964 10.0" 
$ns at 802.0235766677546 "$node_(266) setdest 9989 5779 13.0" 
$ns at 855.3449318237896 "$node_(266) setdest 80717 10588 7.0" 
$ns at 352.8552838899657 "$node_(267) setdest 11824 26483 13.0" 
$ns at 453.1132636167545 "$node_(267) setdest 48823 7803 16.0" 
$ns at 540.0430694794824 "$node_(267) setdest 87071 22434 10.0" 
$ns at 654.4770657406395 "$node_(267) setdest 54706 37145 19.0" 
$ns at 754.9609450362788 "$node_(267) setdest 82760 30207 14.0" 
$ns at 886.3239898164729 "$node_(267) setdest 51715 8610 14.0" 
$ns at 217.8179701970265 "$node_(268) setdest 82961 19914 12.0" 
$ns at 299.4222825029658 "$node_(268) setdest 80999 31008 10.0" 
$ns at 352.85410931553065 "$node_(268) setdest 77396 7749 10.0" 
$ns at 391.92933374721105 "$node_(268) setdest 70690 23620 18.0" 
$ns at 553.4777176052199 "$node_(268) setdest 56982 19133 9.0" 
$ns at 666.23651494017 "$node_(268) setdest 99953 31853 20.0" 
$ns at 813.3988881137773 "$node_(268) setdest 115308 8598 15.0" 
$ns at 216.42428459190938 "$node_(269) setdest 116345 11754 18.0" 
$ns at 263.09628773848834 "$node_(269) setdest 95766 474 10.0" 
$ns at 332.05237887617983 "$node_(269) setdest 12220 14774 13.0" 
$ns at 399.5989050707801 "$node_(269) setdest 73288 27925 13.0" 
$ns at 552.7374706423582 "$node_(269) setdest 113840 9948 20.0" 
$ns at 769.0056114999547 "$node_(269) setdest 50559 14263 20.0" 
$ns at 214.5769983399626 "$node_(270) setdest 44134 43542 8.0" 
$ns at 308.59062613172284 "$node_(270) setdest 1016 23966 19.0" 
$ns at 425.1318925512688 "$node_(270) setdest 113908 5011 13.0" 
$ns at 516.952715226211 "$node_(270) setdest 110417 37970 20.0" 
$ns at 742.3422911129811 "$node_(270) setdest 91496 11719 4.0" 
$ns at 775.2532534336788 "$node_(270) setdest 120279 13156 1.0" 
$ns at 810.7537844272889 "$node_(270) setdest 132005 26930 10.0" 
$ns at 254.86466157236276 "$node_(271) setdest 31115 7558 13.0" 
$ns at 328.96383849653023 "$node_(271) setdest 17659 28442 11.0" 
$ns at 404.4104616083109 "$node_(271) setdest 130591 35962 5.0" 
$ns at 438.0242471511579 "$node_(271) setdest 68014 10937 1.0" 
$ns at 476.28593404663894 "$node_(271) setdest 57694 13599 6.0" 
$ns at 541.9296907893636 "$node_(271) setdest 81789 30118 12.0" 
$ns at 683.5587588680603 "$node_(271) setdest 91792 22855 2.0" 
$ns at 721.2265300889262 "$node_(271) setdest 87649 15926 14.0" 
$ns at 863.854137667837 "$node_(271) setdest 50867 39854 12.0" 
$ns at 205.17909236982106 "$node_(272) setdest 15382 11062 1.0" 
$ns at 244.77310425216882 "$node_(272) setdest 80678 10346 3.0" 
$ns at 299.7157142907987 "$node_(272) setdest 84913 39659 16.0" 
$ns at 379.93228217071356 "$node_(272) setdest 128273 40365 9.0" 
$ns at 456.08405343013953 "$node_(272) setdest 25811 29977 6.0" 
$ns at 500.11927179549167 "$node_(272) setdest 7262 24876 2.0" 
$ns at 539.5195206735024 "$node_(272) setdest 81008 21031 3.0" 
$ns at 571.6801415165373 "$node_(272) setdest 66878 28483 1.0" 
$ns at 602.4146033400674 "$node_(272) setdest 60000 762 12.0" 
$ns at 648.6211530970451 "$node_(272) setdest 40484 23692 1.0" 
$ns at 680.9228449304629 "$node_(272) setdest 40187 3563 7.0" 
$ns at 710.9498753837433 "$node_(272) setdest 131860 18231 2.0" 
$ns at 744.4973356365856 "$node_(272) setdest 30707 42616 5.0" 
$ns at 778.9213668235998 "$node_(272) setdest 86334 10642 2.0" 
$ns at 819.7657660275725 "$node_(272) setdest 39459 34459 3.0" 
$ns at 859.4925122337988 "$node_(272) setdest 52056 4219 1.0" 
$ns at 890.743937215474 "$node_(272) setdest 5083 18496 20.0" 
$ns at 207.37419163897 "$node_(273) setdest 85004 5264 6.0" 
$ns at 278.3835703911891 "$node_(273) setdest 29416 20784 19.0" 
$ns at 366.63063627178053 "$node_(273) setdest 127592 29983 8.0" 
$ns at 412.2103186193131 "$node_(273) setdest 3015 1253 6.0" 
$ns at 470.61230138735147 "$node_(273) setdest 72220 26289 14.0" 
$ns at 562.0706641621516 "$node_(273) setdest 65513 23504 14.0" 
$ns at 685.6782488896936 "$node_(273) setdest 99821 18892 14.0" 
$ns at 806.0368818656771 "$node_(273) setdest 56992 18587 7.0" 
$ns at 873.3985787452635 "$node_(273) setdest 65128 30883 12.0" 
$ns at 345.51533575965465 "$node_(274) setdest 131641 139 16.0" 
$ns at 446.60897066826817 "$node_(274) setdest 112570 27954 16.0" 
$ns at 500.11187898274073 "$node_(274) setdest 36963 40939 8.0" 
$ns at 586.459913531598 "$node_(274) setdest 107979 40347 8.0" 
$ns at 688.5095471936637 "$node_(274) setdest 116415 5416 9.0" 
$ns at 725.522983235276 "$node_(274) setdest 71758 42983 7.0" 
$ns at 809.7487871894431 "$node_(274) setdest 42039 2773 17.0" 
$ns at 861.7956797522556 "$node_(274) setdest 87725 25708 5.0" 
$ns at 245.63482559586245 "$node_(275) setdest 10990 36374 16.0" 
$ns at 332.82476148847434 "$node_(275) setdest 20107 38795 4.0" 
$ns at 392.79402914828137 "$node_(275) setdest 78930 43849 12.0" 
$ns at 534.2750959701716 "$node_(275) setdest 15289 9965 17.0" 
$ns at 707.9772726994285 "$node_(275) setdest 74698 9450 1.0" 
$ns at 740.9357811493287 "$node_(275) setdest 108934 28084 10.0" 
$ns at 849.6405168629426 "$node_(275) setdest 44437 35811 15.0" 
$ns at 276.2082367095263 "$node_(276) setdest 105638 14282 2.0" 
$ns at 321.44686028923877 "$node_(276) setdest 3287 24469 18.0" 
$ns at 352.60267481184826 "$node_(276) setdest 36801 22038 20.0" 
$ns at 525.2759662448929 "$node_(276) setdest 71430 23183 19.0" 
$ns at 622.1940126037636 "$node_(276) setdest 24579 21782 2.0" 
$ns at 659.8389150459562 "$node_(276) setdest 128909 20323 7.0" 
$ns at 695.8466167036206 "$node_(276) setdest 17273 18172 20.0" 
$ns at 885.1215370084052 "$node_(276) setdest 45336 40065 11.0" 
$ns at 202.07493566444595 "$node_(277) setdest 5847 29627 4.0" 
$ns at 254.8512938667813 "$node_(277) setdest 102468 2675 16.0" 
$ns at 392.42506361710946 "$node_(277) setdest 23439 30690 2.0" 
$ns at 440.466651197281 "$node_(277) setdest 44828 11272 9.0" 
$ns at 525.8705156436286 "$node_(277) setdest 2768 28350 14.0" 
$ns at 627.6549911129072 "$node_(277) setdest 66193 33865 8.0" 
$ns at 732.0683564907266 "$node_(277) setdest 89683 116 17.0" 
$ns at 892.4709404558174 "$node_(277) setdest 33858 17794 8.0" 
$ns at 248.72235836227094 "$node_(278) setdest 105320 42021 12.0" 
$ns at 344.54999153080024 "$node_(278) setdest 17187 15101 6.0" 
$ns at 383.77189470526037 "$node_(278) setdest 124261 14303 8.0" 
$ns at 428.7083522003001 "$node_(278) setdest 82675 17340 2.0" 
$ns at 467.5202177025786 "$node_(278) setdest 131047 5751 4.0" 
$ns at 534.7139902673249 "$node_(278) setdest 141 14985 1.0" 
$ns at 573.3645419511349 "$node_(278) setdest 32709 36521 1.0" 
$ns at 608.8371740338763 "$node_(278) setdest 19092 20560 15.0" 
$ns at 750.0903069218668 "$node_(278) setdest 130572 22931 8.0" 
$ns at 857.1043983069527 "$node_(278) setdest 23348 28961 15.0" 
$ns at 284.71441773201707 "$node_(279) setdest 31261 40497 5.0" 
$ns at 363.28145588037825 "$node_(279) setdest 94403 7031 13.0" 
$ns at 483.15691163760295 "$node_(279) setdest 111168 27720 9.0" 
$ns at 523.5910522797165 "$node_(279) setdest 93095 17098 1.0" 
$ns at 558.4324039264122 "$node_(279) setdest 109615 11096 13.0" 
$ns at 599.7700141929797 "$node_(279) setdest 133892 6732 15.0" 
$ns at 688.8068727866802 "$node_(279) setdest 25183 2710 12.0" 
$ns at 738.3590076473928 "$node_(279) setdest 80372 1272 11.0" 
$ns at 772.4364381204106 "$node_(279) setdest 17945 27114 1.0" 
$ns at 803.9799769102126 "$node_(279) setdest 128001 29652 14.0" 
$ns at 841.0911698754663 "$node_(279) setdest 92392 23263 4.0" 
$ns at 890.3917194370987 "$node_(279) setdest 44245 18488 10.0" 
$ns at 224.20364546543465 "$node_(280) setdest 93410 14869 8.0" 
$ns at 318.8768840482445 "$node_(280) setdest 91447 26434 18.0" 
$ns at 457.1360699843671 "$node_(280) setdest 24376 29409 13.0" 
$ns at 603.9928073992862 "$node_(280) setdest 104540 40028 8.0" 
$ns at 636.7701692192284 "$node_(280) setdest 92084 13060 12.0" 
$ns at 671.4374931895067 "$node_(280) setdest 50220 12501 2.0" 
$ns at 712.6336692525176 "$node_(280) setdest 63150 3560 4.0" 
$ns at 778.4753273672791 "$node_(280) setdest 67054 41846 15.0" 
$ns at 835.1600019853017 "$node_(280) setdest 77332 16524 2.0" 
$ns at 884.8778627324419 "$node_(280) setdest 81315 24942 17.0" 
$ns at 274.7889163918197 "$node_(281) setdest 75748 2275 5.0" 
$ns at 342.6399161541981 "$node_(281) setdest 29120 40703 4.0" 
$ns at 378.90727832344334 "$node_(281) setdest 58462 7811 3.0" 
$ns at 426.90584024315274 "$node_(281) setdest 99362 21356 10.0" 
$ns at 514.024313208769 "$node_(281) setdest 53020 4646 15.0" 
$ns at 622.9896567431263 "$node_(281) setdest 86469 36943 15.0" 
$ns at 691.268724686829 "$node_(281) setdest 93455 19639 6.0" 
$ns at 771.2554306273819 "$node_(281) setdest 91221 38262 13.0" 
$ns at 879.9476088089073 "$node_(281) setdest 16920 19821 2.0" 
$ns at 208.8789824699299 "$node_(282) setdest 65611 18620 1.0" 
$ns at 245.03165919067317 "$node_(282) setdest 653 43483 12.0" 
$ns at 282.8262777408563 "$node_(282) setdest 121837 12086 9.0" 
$ns at 326.7827740146364 "$node_(282) setdest 8958 8152 3.0" 
$ns at 368.2138264186656 "$node_(282) setdest 106225 22250 18.0" 
$ns at 547.5180873876019 "$node_(282) setdest 76517 26349 6.0" 
$ns at 597.3396747373687 "$node_(282) setdest 67158 89 17.0" 
$ns at 680.3054589375732 "$node_(282) setdest 63412 32833 8.0" 
$ns at 718.3783631715621 "$node_(282) setdest 32262 37766 12.0" 
$ns at 836.0722613459316 "$node_(282) setdest 71492 1222 17.0" 
$ns at 212.23102256783798 "$node_(283) setdest 29291 36665 15.0" 
$ns at 299.78408979337513 "$node_(283) setdest 52195 40277 19.0" 
$ns at 385.7897321837727 "$node_(283) setdest 84238 21654 16.0" 
$ns at 512.3390853943419 "$node_(283) setdest 106521 20922 7.0" 
$ns at 587.0874132599707 "$node_(283) setdest 33498 43288 1.0" 
$ns at 618.763158493012 "$node_(283) setdest 56783 44402 2.0" 
$ns at 659.9426177680074 "$node_(283) setdest 72787 26337 1.0" 
$ns at 691.7796384245739 "$node_(283) setdest 74498 24855 19.0" 
$ns at 254.47955612967596 "$node_(284) setdest 58072 31456 15.0" 
$ns at 425.81819934566346 "$node_(284) setdest 20223 23968 12.0" 
$ns at 563.6524537612734 "$node_(284) setdest 11912 36261 18.0" 
$ns at 708.217248619764 "$node_(284) setdest 108334 43852 17.0" 
$ns at 793.2193655900193 "$node_(284) setdest 108260 21336 16.0" 
$ns at 230.14627600805136 "$node_(285) setdest 113946 32855 13.0" 
$ns at 383.71043838274136 "$node_(285) setdest 83475 38785 6.0" 
$ns at 431.69755282115176 "$node_(285) setdest 54267 2806 1.0" 
$ns at 465.16297911375705 "$node_(285) setdest 13643 12072 1.0" 
$ns at 500.6746372592473 "$node_(285) setdest 39733 21302 2.0" 
$ns at 550.2882961949787 "$node_(285) setdest 96125 6513 1.0" 
$ns at 581.845243625913 "$node_(285) setdest 37849 16117 6.0" 
$ns at 648.312081420045 "$node_(285) setdest 70845 9785 16.0" 
$ns at 770.1963624001868 "$node_(285) setdest 16911 9141 18.0" 
$ns at 225.66680681094311 "$node_(286) setdest 27229 20187 11.0" 
$ns at 300.002824685194 "$node_(286) setdest 97721 9917 10.0" 
$ns at 417.83131564076643 "$node_(286) setdest 3131 10133 6.0" 
$ns at 464.3629555987998 "$node_(286) setdest 17890 234 13.0" 
$ns at 612.6559654604957 "$node_(286) setdest 33702 7657 5.0" 
$ns at 660.2673185900493 "$node_(286) setdest 35751 3817 20.0" 
$ns at 825.5404785472064 "$node_(286) setdest 8159 15765 8.0" 
$ns at 294.41704175331415 "$node_(287) setdest 21299 39759 11.0" 
$ns at 397.54214782083807 "$node_(287) setdest 42568 8862 19.0" 
$ns at 446.66577662170494 "$node_(287) setdest 85229 15328 19.0" 
$ns at 496.7714543293549 "$node_(287) setdest 3915 17953 1.0" 
$ns at 531.4914598613051 "$node_(287) setdest 30442 29260 16.0" 
$ns at 708.8206900422317 "$node_(287) setdest 30533 26824 7.0" 
$ns at 784.6133329658425 "$node_(287) setdest 19476 18636 14.0" 
$ns at 860.8906090007094 "$node_(287) setdest 84438 10295 11.0" 
$ns at 259.60100622996606 "$node_(288) setdest 33382 1501 18.0" 
$ns at 294.42823433869785 "$node_(288) setdest 23177 19629 11.0" 
$ns at 349.62834211098175 "$node_(288) setdest 63924 34513 9.0" 
$ns at 419.4925471743487 "$node_(288) setdest 104711 21661 20.0" 
$ns at 598.3278668871909 "$node_(288) setdest 29336 15123 19.0" 
$ns at 710.118888866077 "$node_(288) setdest 80788 29211 11.0" 
$ns at 802.7494403072221 "$node_(288) setdest 113099 28726 4.0" 
$ns at 851.3385159590091 "$node_(288) setdest 13233 12801 18.0" 
$ns at 256.11687015928277 "$node_(289) setdest 29243 19734 15.0" 
$ns at 406.78252925431485 "$node_(289) setdest 75305 22981 5.0" 
$ns at 465.4409132307105 "$node_(289) setdest 30946 35619 15.0" 
$ns at 613.4432724494307 "$node_(289) setdest 30733 21541 6.0" 
$ns at 654.0482514986859 "$node_(289) setdest 85933 27365 20.0" 
$ns at 720.6951707421315 "$node_(289) setdest 56787 34189 7.0" 
$ns at 795.0199974200099 "$node_(289) setdest 24316 40596 17.0" 
$ns at 209.53473964220836 "$node_(290) setdest 125801 8289 10.0" 
$ns at 276.6415032858574 "$node_(290) setdest 78387 6949 1.0" 
$ns at 315.74319872307694 "$node_(290) setdest 115763 24988 8.0" 
$ns at 370.21313965293336 "$node_(290) setdest 62383 26421 19.0" 
$ns at 526.7369795195957 "$node_(290) setdest 75002 25692 16.0" 
$ns at 705.9154240084631 "$node_(290) setdest 104 24362 11.0" 
$ns at 811.9223364384168 "$node_(290) setdest 19052 34822 14.0" 
$ns at 257.6740824417024 "$node_(291) setdest 68749 30019 14.0" 
$ns at 349.94991148535723 "$node_(291) setdest 1353 11816 19.0" 
$ns at 427.5583979629914 "$node_(291) setdest 97024 7816 1.0" 
$ns at 461.3874546084086 "$node_(291) setdest 91409 40779 17.0" 
$ns at 543.3917179501769 "$node_(291) setdest 132263 17222 1.0" 
$ns at 580.5024611947435 "$node_(291) setdest 57058 39556 18.0" 
$ns at 643.0693410792244 "$node_(291) setdest 121909 30538 10.0" 
$ns at 747.2170592253367 "$node_(291) setdest 97925 33695 10.0" 
$ns at 803.9752316087723 "$node_(291) setdest 104227 42593 18.0" 
$ns at 836.6349201435847 "$node_(291) setdest 107618 1243 7.0" 
$ns at 218.89214498137872 "$node_(292) setdest 87143 5230 13.0" 
$ns at 375.01602976068705 "$node_(292) setdest 102244 15331 1.0" 
$ns at 412.84938929742117 "$node_(292) setdest 15960 6866 4.0" 
$ns at 445.4910766422882 "$node_(292) setdest 83922 21594 19.0" 
$ns at 481.55466000952316 "$node_(292) setdest 122875 16226 18.0" 
$ns at 642.3473280854402 "$node_(292) setdest 116843 4444 18.0" 
$ns at 707.662915016647 "$node_(292) setdest 2380 43277 16.0" 
$ns at 883.3233275332598 "$node_(292) setdest 106534 10791 9.0" 
$ns at 230.23865948081487 "$node_(293) setdest 49126 9075 5.0" 
$ns at 263.2194500334489 "$node_(293) setdest 96122 13331 1.0" 
$ns at 298.2459400194874 "$node_(293) setdest 97893 40354 18.0" 
$ns at 469.2345396128467 "$node_(293) setdest 9928 17167 19.0" 
$ns at 560.1709767181821 "$node_(293) setdest 92451 7790 5.0" 
$ns at 636.9525418241128 "$node_(293) setdest 46906 20919 8.0" 
$ns at 730.8513075480128 "$node_(293) setdest 114958 37 3.0" 
$ns at 763.73959295161 "$node_(293) setdest 48859 3675 9.0" 
$ns at 877.5223700475153 "$node_(293) setdest 25706 29283 4.0" 
$ns at 202.41406763531037 "$node_(294) setdest 120330 15409 19.0" 
$ns at 263.62244120288466 "$node_(294) setdest 80917 38620 4.0" 
$ns at 329.49069433248917 "$node_(294) setdest 60832 21417 9.0" 
$ns at 444.31772416480896 "$node_(294) setdest 68636 5295 3.0" 
$ns at 488.11841550370207 "$node_(294) setdest 14888 27367 1.0" 
$ns at 521.0989448326743 "$node_(294) setdest 34194 16905 5.0" 
$ns at 588.5691060346534 "$node_(294) setdest 56311 9980 16.0" 
$ns at 664.0693872200569 "$node_(294) setdest 59815 30921 10.0" 
$ns at 747.292411214887 "$node_(294) setdest 2440 32464 4.0" 
$ns at 779.5541582999655 "$node_(294) setdest 129216 39651 1.0" 
$ns at 813.6055397212247 "$node_(294) setdest 29104 253 14.0" 
$ns at 209.0524133897144 "$node_(295) setdest 133414 24820 19.0" 
$ns at 345.1340515159379 "$node_(295) setdest 77507 2871 2.0" 
$ns at 394.4115879717698 "$node_(295) setdest 121475 39810 16.0" 
$ns at 452.61568177694267 "$node_(295) setdest 106397 32228 14.0" 
$ns at 506.3836294957279 "$node_(295) setdest 82218 22578 3.0" 
$ns at 536.9448761337372 "$node_(295) setdest 12974 19209 6.0" 
$ns at 572.5964642815658 "$node_(295) setdest 52282 33247 7.0" 
$ns at 610.8486509619111 "$node_(295) setdest 47268 12649 2.0" 
$ns at 643.7752985045038 "$node_(295) setdest 95160 40543 15.0" 
$ns at 729.0874604622386 "$node_(295) setdest 19599 25115 4.0" 
$ns at 761.7724221725106 "$node_(295) setdest 116302 16545 9.0" 
$ns at 810.621159166827 "$node_(295) setdest 59557 42588 12.0" 
$ns at 225.54819302405488 "$node_(296) setdest 15472 11723 4.0" 
$ns at 263.7669847237139 "$node_(296) setdest 51568 37451 12.0" 
$ns at 396.47862372150036 "$node_(296) setdest 87694 26756 15.0" 
$ns at 452.5830467280073 "$node_(296) setdest 102220 20293 16.0" 
$ns at 504.0093183680676 "$node_(296) setdest 47572 37542 1.0" 
$ns at 543.3615824672603 "$node_(296) setdest 92741 16463 18.0" 
$ns at 735.1634951276005 "$node_(296) setdest 118164 28286 7.0" 
$ns at 829.5381880371717 "$node_(296) setdest 90933 34236 12.0" 
$ns at 301.4123726065713 "$node_(297) setdest 82377 9400 2.0" 
$ns at 335.3407140467025 "$node_(297) setdest 126521 22034 9.0" 
$ns at 381.85503191804827 "$node_(297) setdest 82777 4145 17.0" 
$ns at 418.00157996405426 "$node_(297) setdest 88222 5931 9.0" 
$ns at 521.4291408713668 "$node_(297) setdest 39730 26371 9.0" 
$ns at 600.7190169987293 "$node_(297) setdest 91885 4391 13.0" 
$ns at 695.927996864741 "$node_(297) setdest 96328 33709 20.0" 
$ns at 726.5908344372352 "$node_(297) setdest 29256 10688 18.0" 
$ns at 765.4750166245794 "$node_(297) setdest 108715 7425 20.0" 
$ns at 202.37830683838098 "$node_(298) setdest 85307 20862 1.0" 
$ns at 236.09351641199785 "$node_(298) setdest 19230 43649 8.0" 
$ns at 290.89503045906423 "$node_(298) setdest 126656 32372 12.0" 
$ns at 355.30651834604964 "$node_(298) setdest 10030 8785 12.0" 
$ns at 418.997730273908 "$node_(298) setdest 18206 7550 19.0" 
$ns at 509.74204634528365 "$node_(298) setdest 78213 31827 4.0" 
$ns at 557.819100433702 "$node_(298) setdest 119816 40800 15.0" 
$ns at 696.7306612513311 "$node_(298) setdest 56078 13195 10.0" 
$ns at 777.7137043886127 "$node_(298) setdest 80300 23786 5.0" 
$ns at 834.6285434199865 "$node_(298) setdest 128505 35691 6.0" 
$ns at 287.2699426574058 "$node_(299) setdest 43174 2985 2.0" 
$ns at 333.5203577590406 "$node_(299) setdest 75459 11527 1.0" 
$ns at 369.86278096061415 "$node_(299) setdest 98496 27311 10.0" 
$ns at 415.5625158326694 "$node_(299) setdest 15397 2283 11.0" 
$ns at 514.8508129642827 "$node_(299) setdest 85852 43 12.0" 
$ns at 605.2544862723503 "$node_(299) setdest 9578 29653 9.0" 
$ns at 688.54041213142 "$node_(299) setdest 8355 36391 9.0" 
$ns at 798.210573256909 "$node_(299) setdest 88149 7256 12.0" 
$ns at 863.9150020389875 "$node_(299) setdest 53012 43372 3.0" 
$ns at 347.0624438933372 "$node_(300) setdest 118055 28423 9.0" 
$ns at 433.9579370267733 "$node_(300) setdest 88399 37887 16.0" 
$ns at 583.3937810945786 "$node_(300) setdest 77162 15681 17.0" 
$ns at 653.2240086949605 "$node_(300) setdest 111220 21885 4.0" 
$ns at 720.3954770155067 "$node_(300) setdest 16222 30688 17.0" 
$ns at 809.4933277565808 "$node_(300) setdest 79552 37690 11.0" 
$ns at 875.1928773952872 "$node_(300) setdest 132210 18247 1.0" 
$ns at 406.78079737435706 "$node_(301) setdest 127399 31305 15.0" 
$ns at 551.7934591029953 "$node_(301) setdest 79525 11014 12.0" 
$ns at 654.6151104373856 "$node_(301) setdest 126831 9719 6.0" 
$ns at 730.1349516279266 "$node_(301) setdest 54909 27995 7.0" 
$ns at 777.3951603856747 "$node_(301) setdest 111213 35287 10.0" 
$ns at 855.8265093698373 "$node_(301) setdest 66446 17359 16.0" 
$ns at 887.5558321926179 "$node_(301) setdest 9053 28868 13.0" 
$ns at 331.70472652110186 "$node_(302) setdest 57132 26796 17.0" 
$ns at 472.25718589571557 "$node_(302) setdest 123831 2233 3.0" 
$ns at 523.123614474011 "$node_(302) setdest 91235 40929 14.0" 
$ns at 685.8014425525712 "$node_(302) setdest 60130 23215 17.0" 
$ns at 869.4331173617031 "$node_(302) setdest 108285 35236 8.0" 
$ns at 320.5847553502013 "$node_(303) setdest 35402 25673 18.0" 
$ns at 487.90573957510435 "$node_(303) setdest 22788 18130 14.0" 
$ns at 566.1927953218869 "$node_(303) setdest 45884 42813 17.0" 
$ns at 610.1793813208993 "$node_(303) setdest 28742 38078 17.0" 
$ns at 736.1020220215581 "$node_(303) setdest 62258 13664 1.0" 
$ns at 773.1986779355274 "$node_(303) setdest 91511 34954 14.0" 
$ns at 885.0149615844971 "$node_(303) setdest 121876 30626 1.0" 
$ns at 397.598330338214 "$node_(304) setdest 45276 8939 4.0" 
$ns at 456.3386310972745 "$node_(304) setdest 56855 15573 13.0" 
$ns at 567.1432418999696 "$node_(304) setdest 86382 7950 19.0" 
$ns at 606.411578976357 "$node_(304) setdest 39058 2937 8.0" 
$ns at 643.2006554055391 "$node_(304) setdest 101322 22092 1.0" 
$ns at 675.455514737265 "$node_(304) setdest 71338 21660 2.0" 
$ns at 720.2295794646328 "$node_(304) setdest 61604 26066 20.0" 
$ns at 884.6674729292708 "$node_(304) setdest 123163 25155 6.0" 
$ns at 384.4409440385198 "$node_(305) setdest 105306 15780 12.0" 
$ns at 530.7641674519743 "$node_(305) setdest 18707 38645 6.0" 
$ns at 597.0284748632034 "$node_(305) setdest 64545 21720 4.0" 
$ns at 646.7962731325969 "$node_(305) setdest 62449 10359 17.0" 
$ns at 690.865085334153 "$node_(305) setdest 119812 26961 5.0" 
$ns at 759.8507737900425 "$node_(305) setdest 5059 31866 9.0" 
$ns at 793.1961782536398 "$node_(305) setdest 68504 22083 4.0" 
$ns at 852.381878247214 "$node_(305) setdest 90665 12968 15.0" 
$ns at 308.8556819866674 "$node_(306) setdest 58382 20995 13.0" 
$ns at 455.600147073423 "$node_(306) setdest 85585 36229 7.0" 
$ns at 536.7286081902275 "$node_(306) setdest 14623 16273 1.0" 
$ns at 569.6609275539172 "$node_(306) setdest 19018 12519 9.0" 
$ns at 668.0850885337545 "$node_(306) setdest 93750 18675 13.0" 
$ns at 795.0093759140731 "$node_(306) setdest 82817 10928 7.0" 
$ns at 840.2087645028688 "$node_(306) setdest 53534 7296 12.0" 
$ns at 876.9345910314928 "$node_(306) setdest 41774 27492 2.0" 
$ns at 316.6853078935001 "$node_(307) setdest 94631 21470 13.0" 
$ns at 395.07595653373903 "$node_(307) setdest 23152 43395 20.0" 
$ns at 446.82616959336457 "$node_(307) setdest 61473 19712 4.0" 
$ns at 478.2217126042064 "$node_(307) setdest 113997 37618 15.0" 
$ns at 508.3962070199799 "$node_(307) setdest 71257 44608 3.0" 
$ns at 546.616266759775 "$node_(307) setdest 110505 1274 5.0" 
$ns at 584.8503393241444 "$node_(307) setdest 32705 39043 4.0" 
$ns at 631.6844401948647 "$node_(307) setdest 114328 27460 17.0" 
$ns at 684.0868425809196 "$node_(307) setdest 87553 37083 14.0" 
$ns at 839.4554300915478 "$node_(307) setdest 133119 40212 9.0" 
$ns at 423.0672738227366 "$node_(308) setdest 125524 32610 5.0" 
$ns at 499.23222562576973 "$node_(308) setdest 24413 15937 1.0" 
$ns at 535.9511379604932 "$node_(308) setdest 62172 34826 9.0" 
$ns at 643.3306708027312 "$node_(308) setdest 130679 19551 3.0" 
$ns at 694.5880596423225 "$node_(308) setdest 67502 27510 10.0" 
$ns at 759.3064873824808 "$node_(308) setdest 64353 11099 16.0" 
$ns at 838.8148962793342 "$node_(308) setdest 49658 36884 14.0" 
$ns at 375.7644977007148 "$node_(309) setdest 129845 23699 14.0" 
$ns at 544.3851102411327 "$node_(309) setdest 6323 41420 10.0" 
$ns at 637.7692498902164 "$node_(309) setdest 12274 2299 14.0" 
$ns at 746.9717153439714 "$node_(309) setdest 49480 42204 13.0" 
$ns at 848.6958140802936 "$node_(309) setdest 55774 43249 7.0" 
$ns at 887.2202996069097 "$node_(309) setdest 3072 13049 1.0" 
$ns at 334.5150269080182 "$node_(310) setdest 48722 41551 19.0" 
$ns at 432.5503602110258 "$node_(310) setdest 62532 22977 2.0" 
$ns at 480.1821860236565 "$node_(310) setdest 8167 12956 7.0" 
$ns at 553.4785526333173 "$node_(310) setdest 20738 10955 15.0" 
$ns at 660.1922612206914 "$node_(310) setdest 16609 9976 18.0" 
$ns at 802.5608383326689 "$node_(310) setdest 32643 11020 8.0" 
$ns at 846.3458968600866 "$node_(310) setdest 38207 24312 5.0" 
$ns at 324.1365317033131 "$node_(311) setdest 42454 7727 4.0" 
$ns at 388.9240293530416 "$node_(311) setdest 88241 41353 16.0" 
$ns at 496.72199453635943 "$node_(311) setdest 120290 6565 18.0" 
$ns at 625.7980351022497 "$node_(311) setdest 129940 24354 2.0" 
$ns at 674.6912728000415 "$node_(311) setdest 98955 2851 1.0" 
$ns at 707.9324737769613 "$node_(311) setdest 22451 37355 5.0" 
$ns at 741.7606210245143 "$node_(311) setdest 36755 10664 17.0" 
$ns at 821.7934478283893 "$node_(311) setdest 42721 5690 16.0" 
$ns at 318.94050251041494 "$node_(312) setdest 118286 44018 13.0" 
$ns at 450.5011167336846 "$node_(312) setdest 118224 9486 7.0" 
$ns at 505.14471342439634 "$node_(312) setdest 56553 41916 10.0" 
$ns at 603.0892126991257 "$node_(312) setdest 44100 35236 9.0" 
$ns at 717.2320360855157 "$node_(312) setdest 72789 12483 16.0" 
$ns at 825.6542290956666 "$node_(312) setdest 54354 8560 10.0" 
$ns at 857.0978347910831 "$node_(312) setdest 64444 39747 13.0" 
$ns at 899.0743157579685 "$node_(312) setdest 81533 20681 15.0" 
$ns at 349.60485267490174 "$node_(313) setdest 72036 20250 8.0" 
$ns at 428.9237006687522 "$node_(313) setdest 21634 10662 19.0" 
$ns at 545.8945374963316 "$node_(313) setdest 115758 9807 9.0" 
$ns at 647.0982470530666 "$node_(313) setdest 123021 39778 2.0" 
$ns at 682.4767726826747 "$node_(313) setdest 316 28024 7.0" 
$ns at 745.444333863172 "$node_(313) setdest 45109 13364 1.0" 
$ns at 775.8144926720423 "$node_(313) setdest 106304 20642 11.0" 
$ns at 342.15700825862734 "$node_(314) setdest 83365 5775 14.0" 
$ns at 405.61876004357356 "$node_(314) setdest 58198 40950 13.0" 
$ns at 488.6614552804012 "$node_(314) setdest 68153 27490 17.0" 
$ns at 626.6609653773746 "$node_(314) setdest 3612 39536 7.0" 
$ns at 708.0125004559795 "$node_(314) setdest 10515 1294 2.0" 
$ns at 750.0085540761363 "$node_(314) setdest 67192 32802 1.0" 
$ns at 780.4850079365872 "$node_(314) setdest 11322 5046 7.0" 
$ns at 864.1138469949468 "$node_(314) setdest 96487 12587 1.0" 
$ns at 897.3217003347639 "$node_(314) setdest 91443 44271 3.0" 
$ns at 360.3850744480974 "$node_(315) setdest 47468 2450 17.0" 
$ns at 410.9343018205368 "$node_(315) setdest 106448 34426 11.0" 
$ns at 466.01768569253636 "$node_(315) setdest 34923 19291 9.0" 
$ns at 574.116142373329 "$node_(315) setdest 73996 40597 1.0" 
$ns at 605.1100101830766 "$node_(315) setdest 84154 2136 16.0" 
$ns at 666.3196313549488 "$node_(315) setdest 50446 39380 6.0" 
$ns at 713.2455513786299 "$node_(315) setdest 50522 8556 8.0" 
$ns at 783.0001237378266 "$node_(315) setdest 13136 39196 8.0" 
$ns at 862.6429139231182 "$node_(315) setdest 35586 1257 16.0" 
$ns at 411.24729449875633 "$node_(316) setdest 63875 16834 14.0" 
$ns at 517.1655095610508 "$node_(316) setdest 43192 38674 15.0" 
$ns at 579.6287323285045 "$node_(316) setdest 18936 17478 1.0" 
$ns at 610.849459593897 "$node_(316) setdest 133929 21852 18.0" 
$ns at 705.077441184713 "$node_(316) setdest 37947 862 12.0" 
$ns at 807.0562225887832 "$node_(316) setdest 4263 13126 12.0" 
$ns at 344.1324265157749 "$node_(317) setdest 121820 41937 4.0" 
$ns at 394.67067698884574 "$node_(317) setdest 99107 27045 6.0" 
$ns at 434.08191810932453 "$node_(317) setdest 130721 20750 3.0" 
$ns at 467.4545919935755 "$node_(317) setdest 36926 38403 5.0" 
$ns at 515.7666154325752 "$node_(317) setdest 99789 12179 1.0" 
$ns at 554.685799720942 "$node_(317) setdest 65223 24747 10.0" 
$ns at 648.7867573581564 "$node_(317) setdest 133649 27423 9.0" 
$ns at 747.5050369511408 "$node_(317) setdest 106748 8091 8.0" 
$ns at 784.1609347816991 "$node_(317) setdest 107479 22096 20.0" 
$ns at 302.25247821238975 "$node_(318) setdest 44614 14974 7.0" 
$ns at 350.91237104509486 "$node_(318) setdest 49778 37340 15.0" 
$ns at 489.190473208251 "$node_(318) setdest 51273 32301 17.0" 
$ns at 654.594768770089 "$node_(318) setdest 17049 18603 11.0" 
$ns at 743.3976634191406 "$node_(318) setdest 125472 10640 2.0" 
$ns at 793.2912684764251 "$node_(318) setdest 42959 40507 6.0" 
$ns at 872.6322905689747 "$node_(318) setdest 51724 12956 19.0" 
$ns at 392.96595346992825 "$node_(319) setdest 55443 7310 12.0" 
$ns at 436.2004615354235 "$node_(319) setdest 63172 32183 15.0" 
$ns at 544.8633130699084 "$node_(319) setdest 122818 10149 18.0" 
$ns at 732.5503838657169 "$node_(319) setdest 53222 33300 14.0" 
$ns at 777.2445942972096 "$node_(319) setdest 5264 13586 18.0" 
$ns at 335.2574495677573 "$node_(320) setdest 103276 28535 18.0" 
$ns at 437.9605851773983 "$node_(320) setdest 41840 41828 15.0" 
$ns at 569.8508180101957 "$node_(320) setdest 60914 4582 2.0" 
$ns at 605.5540958019674 "$node_(320) setdest 46578 36633 8.0" 
$ns at 665.2207321626026 "$node_(320) setdest 47562 23622 5.0" 
$ns at 715.3329522013697 "$node_(320) setdest 20840 21307 14.0" 
$ns at 874.1321820156456 "$node_(320) setdest 64497 32788 17.0" 
$ns at 325.37407251644964 "$node_(321) setdest 22107 13888 1.0" 
$ns at 361.3630490202627 "$node_(321) setdest 129680 6174 13.0" 
$ns at 404.2912372381009 "$node_(321) setdest 107363 33594 11.0" 
$ns at 502.737116303423 "$node_(321) setdest 37838 32945 14.0" 
$ns at 659.247518708692 "$node_(321) setdest 85461 37540 8.0" 
$ns at 698.1173687809373 "$node_(321) setdest 99431 36546 19.0" 
$ns at 788.5727430300867 "$node_(321) setdest 41138 27761 18.0" 
$ns at 313.96589707842895 "$node_(322) setdest 60056 16499 9.0" 
$ns at 348.36552937163526 "$node_(322) setdest 86906 39232 14.0" 
$ns at 513.5981340936488 "$node_(322) setdest 111150 18823 11.0" 
$ns at 631.2870891678748 "$node_(322) setdest 17440 9500 14.0" 
$ns at 688.2912493421093 "$node_(322) setdest 85934 10594 12.0" 
$ns at 757.1254903370414 "$node_(322) setdest 69356 21981 1.0" 
$ns at 791.5369788822725 "$node_(322) setdest 16900 16225 19.0" 
$ns at 441.78815439393753 "$node_(323) setdest 114965 41979 5.0" 
$ns at 483.38575308950686 "$node_(323) setdest 116076 2357 6.0" 
$ns at 566.4656290449464 "$node_(323) setdest 19122 40990 17.0" 
$ns at 753.9021164444729 "$node_(323) setdest 58684 7412 9.0" 
$ns at 816.83833997831 "$node_(323) setdest 34333 7990 8.0" 
$ns at 334.7947109021293 "$node_(324) setdest 84507 3409 16.0" 
$ns at 418.5255276779434 "$node_(324) setdest 51264 610 11.0" 
$ns at 536.8756895823435 "$node_(324) setdest 108094 2932 8.0" 
$ns at 599.0589871935614 "$node_(324) setdest 9655 30596 1.0" 
$ns at 635.7886275382368 "$node_(324) setdest 108569 32399 13.0" 
$ns at 689.926638830237 "$node_(324) setdest 84520 41033 1.0" 
$ns at 722.480554848129 "$node_(324) setdest 58315 33106 9.0" 
$ns at 765.4092302705949 "$node_(324) setdest 125658 40048 12.0" 
$ns at 879.2071524365823 "$node_(324) setdest 64784 11267 10.0" 
$ns at 315.5703572871127 "$node_(325) setdest 77638 22248 8.0" 
$ns at 400.23905679487984 "$node_(325) setdest 99072 26278 16.0" 
$ns at 542.6917982771092 "$node_(325) setdest 119378 15410 20.0" 
$ns at 755.2012934282686 "$node_(325) setdest 120698 6392 19.0" 
$ns at 404.461430632585 "$node_(326) setdest 76316 11526 14.0" 
$ns at 544.9712251775543 "$node_(326) setdest 50482 39153 19.0" 
$ns at 612.1332704087906 "$node_(326) setdest 30408 21831 17.0" 
$ns at 793.297663034334 "$node_(326) setdest 85773 41376 3.0" 
$ns at 826.103965782965 "$node_(326) setdest 109151 30459 16.0" 
$ns at 891.0022500830876 "$node_(326) setdest 120633 11320 12.0" 
$ns at 314.67538142092377 "$node_(327) setdest 102273 19370 18.0" 
$ns at 448.271875389897 "$node_(327) setdest 128237 30404 6.0" 
$ns at 494.2426350876715 "$node_(327) setdest 97702 18916 17.0" 
$ns at 657.1317776431567 "$node_(327) setdest 4447 20233 16.0" 
$ns at 770.8610528488886 "$node_(327) setdest 7231 3549 2.0" 
$ns at 811.4553228342363 "$node_(327) setdest 12855 25827 8.0" 
$ns at 850.094218222865 "$node_(327) setdest 99308 44524 16.0" 
$ns at 314.39138295199734 "$node_(328) setdest 129421 7833 14.0" 
$ns at 465.23549914257944 "$node_(328) setdest 13716 4022 17.0" 
$ns at 518.2181036730537 "$node_(328) setdest 43301 714 6.0" 
$ns at 592.3304753786542 "$node_(328) setdest 72182 36492 16.0" 
$ns at 778.0167446616833 "$node_(328) setdest 110788 32121 7.0" 
$ns at 870.1535281023912 "$node_(328) setdest 126246 20574 18.0" 
$ns at 417.2917765293897 "$node_(329) setdest 101957 26374 13.0" 
$ns at 526.331333340727 "$node_(329) setdest 119144 40776 18.0" 
$ns at 727.152256658462 "$node_(329) setdest 6704 6643 16.0" 
$ns at 819.0403147019583 "$node_(329) setdest 120144 16376 10.0" 
$ns at 354.00684915870454 "$node_(330) setdest 71442 26175 3.0" 
$ns at 408.3003853869975 "$node_(330) setdest 65804 865 10.0" 
$ns at 464.33013106684234 "$node_(330) setdest 8978 987 16.0" 
$ns at 532.5957027221527 "$node_(330) setdest 15050 1927 17.0" 
$ns at 631.839655744752 "$node_(330) setdest 60346 22945 12.0" 
$ns at 678.8603701743841 "$node_(330) setdest 72773 40375 3.0" 
$ns at 718.2845149695594 "$node_(330) setdest 51678 2873 14.0" 
$ns at 821.7189319112947 "$node_(330) setdest 73774 13888 4.0" 
$ns at 867.4352220253861 "$node_(330) setdest 100009 28730 11.0" 
$ns at 329.7727944002583 "$node_(331) setdest 110604 35582 6.0" 
$ns at 390.73998982433943 "$node_(331) setdest 36438 8333 4.0" 
$ns at 443.5957406793664 "$node_(331) setdest 81342 18839 7.0" 
$ns at 535.020097943819 "$node_(331) setdest 14253 31775 15.0" 
$ns at 585.0288480461 "$node_(331) setdest 117013 6884 1.0" 
$ns at 615.5546512175467 "$node_(331) setdest 10197 32032 12.0" 
$ns at 738.6594148954638 "$node_(331) setdest 11790 2370 4.0" 
$ns at 805.9343541524261 "$node_(331) setdest 70591 16023 12.0" 
$ns at 847.5934741901829 "$node_(331) setdest 79466 10357 4.0" 
$ns at 885.0585358196009 "$node_(331) setdest 37026 24212 16.0" 
$ns at 406.9845360340695 "$node_(332) setdest 65839 1402 18.0" 
$ns at 514.5689579922805 "$node_(332) setdest 77837 23777 19.0" 
$ns at 605.7484386819858 "$node_(332) setdest 126753 39799 10.0" 
$ns at 671.0815785909101 "$node_(332) setdest 68174 13758 7.0" 
$ns at 764.7711563472795 "$node_(332) setdest 118108 21167 2.0" 
$ns at 813.1335121366906 "$node_(332) setdest 118531 2363 16.0" 
$ns at 370.99894574110834 "$node_(333) setdest 63275 37618 5.0" 
$ns at 418.46766970739793 "$node_(333) setdest 13491 1312 19.0" 
$ns at 590.9930399527506 "$node_(333) setdest 54853 41237 1.0" 
$ns at 626.0154410542419 "$node_(333) setdest 124444 1020 19.0" 
$ns at 793.1351214257902 "$node_(333) setdest 64820 26508 18.0" 
$ns at 350.93263368776337 "$node_(334) setdest 74691 37392 14.0" 
$ns at 467.4932217352117 "$node_(334) setdest 66961 41199 9.0" 
$ns at 535.5838704046464 "$node_(334) setdest 126555 18940 1.0" 
$ns at 575.5737199065197 "$node_(334) setdest 91729 9250 17.0" 
$ns at 661.4568494208878 "$node_(334) setdest 32784 8378 13.0" 
$ns at 698.0406895097026 "$node_(334) setdest 105424 34416 18.0" 
$ns at 858.8346867983222 "$node_(334) setdest 2612 11697 6.0" 
$ns at 385.42894616918454 "$node_(335) setdest 127569 38872 17.0" 
$ns at 427.1890850459147 "$node_(335) setdest 133296 1588 2.0" 
$ns at 469.39260759154615 "$node_(335) setdest 38572 5149 3.0" 
$ns at 522.8346196621185 "$node_(335) setdest 117399 43959 11.0" 
$ns at 623.7128083156126 "$node_(335) setdest 92791 37346 9.0" 
$ns at 700.9552612990984 "$node_(335) setdest 72209 36772 12.0" 
$ns at 825.2095706182103 "$node_(335) setdest 68843 13985 15.0" 
$ns at 394.7541806135598 "$node_(336) setdest 261 25886 14.0" 
$ns at 522.8102136764003 "$node_(336) setdest 32517 16710 8.0" 
$ns at 627.0902657804656 "$node_(336) setdest 106742 18228 14.0" 
$ns at 752.862962284761 "$node_(336) setdest 133011 4368 19.0" 
$ns at 841.258160827969 "$node_(336) setdest 13422 28039 20.0" 
$ns at 342.5553359059488 "$node_(337) setdest 86453 21652 9.0" 
$ns at 448.64719148638966 "$node_(337) setdest 19863 15319 3.0" 
$ns at 490.7587823084992 "$node_(337) setdest 95385 9351 16.0" 
$ns at 670.0238706740323 "$node_(337) setdest 26537 37974 12.0" 
$ns at 806.4890624184691 "$node_(337) setdest 108602 8373 11.0" 
$ns at 867.2761185721605 "$node_(337) setdest 78824 2807 12.0" 
$ns at 319.4506686051335 "$node_(338) setdest 110165 42100 15.0" 
$ns at 406.95497489053474 "$node_(338) setdest 124163 36274 14.0" 
$ns at 537.8779502099519 "$node_(338) setdest 60657 17978 4.0" 
$ns at 570.115427426528 "$node_(338) setdest 98078 28050 14.0" 
$ns at 658.8125442784483 "$node_(338) setdest 112618 14706 18.0" 
$ns at 802.4795317901726 "$node_(338) setdest 28663 26938 3.0" 
$ns at 839.565732745686 "$node_(338) setdest 40840 515 9.0" 
$ns at 874.5337645540073 "$node_(338) setdest 113 19564 13.0" 
$ns at 333.3408009823852 "$node_(339) setdest 10152 23802 14.0" 
$ns at 405.99986659524143 "$node_(339) setdest 101040 7924 8.0" 
$ns at 502.854055599334 "$node_(339) setdest 113019 858 16.0" 
$ns at 594.3338461146878 "$node_(339) setdest 15842 1621 2.0" 
$ns at 636.5007497817505 "$node_(339) setdest 73658 37660 7.0" 
$ns at 677.085052823936 "$node_(339) setdest 68491 18939 11.0" 
$ns at 771.3616984145661 "$node_(339) setdest 93722 6987 3.0" 
$ns at 804.6350783781878 "$node_(339) setdest 113165 36182 10.0" 
$ns at 874.6367321340892 "$node_(339) setdest 110623 33822 7.0" 
$ns at 316.4120392143525 "$node_(340) setdest 53851 44420 12.0" 
$ns at 364.4432582504377 "$node_(340) setdest 118071 4003 5.0" 
$ns at 425.68412635458174 "$node_(340) setdest 18706 4389 2.0" 
$ns at 464.4711286184731 "$node_(340) setdest 132067 23106 9.0" 
$ns at 552.2869550491521 "$node_(340) setdest 42541 6849 7.0" 
$ns at 582.578578905906 "$node_(340) setdest 127070 12661 11.0" 
$ns at 711.0539371172707 "$node_(340) setdest 37837 24017 7.0" 
$ns at 779.5577721618691 "$node_(340) setdest 71459 27858 14.0" 
$ns at 856.9494707346346 "$node_(340) setdest 34856 30856 16.0" 
$ns at 323.7859111254543 "$node_(341) setdest 20390 3024 8.0" 
$ns at 361.1184331592707 "$node_(341) setdest 22282 22081 14.0" 
$ns at 500.75692688469576 "$node_(341) setdest 876 29557 2.0" 
$ns at 531.2456760116836 "$node_(341) setdest 69958 35027 9.0" 
$ns at 605.2296748332386 "$node_(341) setdest 115404 817 19.0" 
$ns at 734.2127489817062 "$node_(341) setdest 67884 30992 6.0" 
$ns at 814.0186497661098 "$node_(341) setdest 60307 14514 14.0" 
$ns at 324.43676492516596 "$node_(342) setdest 14825 28955 13.0" 
$ns at 384.1265470426196 "$node_(342) setdest 33056 30891 3.0" 
$ns at 426.21853144983345 "$node_(342) setdest 63330 22133 11.0" 
$ns at 508.3336961864579 "$node_(342) setdest 131264 14620 1.0" 
$ns at 542.9207629316784 "$node_(342) setdest 108545 27844 1.0" 
$ns at 582.2324930628116 "$node_(342) setdest 64848 42622 15.0" 
$ns at 713.8680896235878 "$node_(342) setdest 59641 35031 2.0" 
$ns at 757.6931155652481 "$node_(342) setdest 87435 22732 10.0" 
$ns at 821.0415013994534 "$node_(342) setdest 64800 38354 20.0" 
$ns at 307.20157712961463 "$node_(343) setdest 428 19339 15.0" 
$ns at 477.9030897403021 "$node_(343) setdest 762 6313 5.0" 
$ns at 550.5625800990622 "$node_(343) setdest 111128 4738 9.0" 
$ns at 639.3469912295503 "$node_(343) setdest 72631 7067 8.0" 
$ns at 674.4848415140658 "$node_(343) setdest 107777 3241 1.0" 
$ns at 704.8112109007454 "$node_(343) setdest 100674 36984 15.0" 
$ns at 860.6875334848895 "$node_(343) setdest 31648 42416 1.0" 
$ns at 897.5800953935458 "$node_(343) setdest 61436 22517 2.0" 
$ns at 334.8523908921263 "$node_(344) setdest 54977 36634 18.0" 
$ns at 536.4859270507017 "$node_(344) setdest 31008 23977 18.0" 
$ns at 626.5386148275198 "$node_(344) setdest 93258 1140 11.0" 
$ns at 734.8510668370766 "$node_(344) setdest 31669 11181 6.0" 
$ns at 777.7345801112538 "$node_(344) setdest 58769 20982 13.0" 
$ns at 890.2581116492265 "$node_(344) setdest 78909 5767 2.0" 
$ns at 385.6821257188112 "$node_(345) setdest 25601 23470 19.0" 
$ns at 501.95696730550407 "$node_(345) setdest 97352 23906 16.0" 
$ns at 586.6895832544329 "$node_(345) setdest 36151 35673 20.0" 
$ns at 629.9616839418504 "$node_(345) setdest 108906 21103 1.0" 
$ns at 666.9350916313629 "$node_(345) setdest 6662 20488 6.0" 
$ns at 754.9510813492471 "$node_(345) setdest 56933 16692 1.0" 
$ns at 789.1249680325712 "$node_(345) setdest 96750 20616 7.0" 
$ns at 886.5899090340903 "$node_(345) setdest 5447 8759 4.0" 
$ns at 306.8896184527447 "$node_(346) setdest 85810 15339 15.0" 
$ns at 350.9122355748437 "$node_(346) setdest 75938 30251 10.0" 
$ns at 456.2599103271231 "$node_(346) setdest 92794 34596 6.0" 
$ns at 532.714693967536 "$node_(346) setdest 6062 8323 7.0" 
$ns at 588.6890910070744 "$node_(346) setdest 84023 18889 1.0" 
$ns at 627.3679926902681 "$node_(346) setdest 20100 39606 13.0" 
$ns at 717.4425830878776 "$node_(346) setdest 131023 13396 17.0" 
$ns at 893.4710059335504 "$node_(346) setdest 118308 25609 14.0" 
$ns at 353.08530450709236 "$node_(347) setdest 114209 7380 11.0" 
$ns at 433.567615830808 "$node_(347) setdest 26570 32442 15.0" 
$ns at 555.1077060632749 "$node_(347) setdest 91437 29820 20.0" 
$ns at 585.5163490881187 "$node_(347) setdest 28358 20341 13.0" 
$ns at 688.0328916997921 "$node_(347) setdest 59241 18714 8.0" 
$ns at 757.2743649004957 "$node_(347) setdest 71006 11440 1.0" 
$ns at 790.4288959450438 "$node_(347) setdest 107193 32035 2.0" 
$ns at 828.1516416978101 "$node_(347) setdest 82059 39980 5.0" 
$ns at 410.7545517220035 "$node_(348) setdest 40350 24918 11.0" 
$ns at 442.2171102242235 "$node_(348) setdest 3347 15363 2.0" 
$ns at 483.0596260608532 "$node_(348) setdest 60953 9147 7.0" 
$ns at 514.768984986672 "$node_(348) setdest 44083 35158 9.0" 
$ns at 581.2578316352424 "$node_(348) setdest 37299 18207 12.0" 
$ns at 657.5247758256409 "$node_(348) setdest 132838 26959 4.0" 
$ns at 689.0865099448113 "$node_(348) setdest 964 9242 9.0" 
$ns at 775.536663419502 "$node_(348) setdest 127488 22050 16.0" 
$ns at 821.7875195354715 "$node_(348) setdest 8475 34113 8.0" 
$ns at 859.8962396578117 "$node_(348) setdest 130936 34147 1.0" 
$ns at 892.0630576324616 "$node_(348) setdest 66662 22728 17.0" 
$ns at 338.3867339639747 "$node_(349) setdest 26940 34136 14.0" 
$ns at 490.8422844292117 "$node_(349) setdest 22339 27388 5.0" 
$ns at 539.3868136750153 "$node_(349) setdest 56132 17171 1.0" 
$ns at 569.5636797054242 "$node_(349) setdest 68096 18817 7.0" 
$ns at 609.1334557661307 "$node_(349) setdest 128591 30585 9.0" 
$ns at 658.4716794292992 "$node_(349) setdest 36307 43282 13.0" 
$ns at 762.5165831250412 "$node_(349) setdest 98728 12939 11.0" 
$ns at 304.66440731615637 "$node_(350) setdest 52521 4004 6.0" 
$ns at 384.5010679665121 "$node_(350) setdest 92386 14886 2.0" 
$ns at 420.37334644503346 "$node_(350) setdest 104629 23003 3.0" 
$ns at 473.2421165755826 "$node_(350) setdest 8454 33364 16.0" 
$ns at 647.3205804868971 "$node_(350) setdest 90138 35663 1.0" 
$ns at 685.3051335930156 "$node_(350) setdest 3268 17720 4.0" 
$ns at 729.8751648255089 "$node_(350) setdest 117636 38443 1.0" 
$ns at 764.5993187757208 "$node_(350) setdest 58494 24565 14.0" 
$ns at 804.0191197739599 "$node_(350) setdest 87074 32031 7.0" 
$ns at 865.2890151448757 "$node_(350) setdest 35412 23899 16.0" 
$ns at 300.15452306884 "$node_(351) setdest 35972 38576 12.0" 
$ns at 335.60529215563486 "$node_(351) setdest 10779 1586 10.0" 
$ns at 454.0936958007713 "$node_(351) setdest 73770 25954 16.0" 
$ns at 604.3187783434328 "$node_(351) setdest 26553 42938 6.0" 
$ns at 658.4866506319122 "$node_(351) setdest 107954 10590 19.0" 
$ns at 803.7145456168575 "$node_(351) setdest 95656 21490 7.0" 
$ns at 853.6924566473647 "$node_(351) setdest 112667 39209 16.0" 
$ns at 359.6728514342346 "$node_(352) setdest 79928 41712 18.0" 
$ns at 508.906404204496 "$node_(352) setdest 91255 7714 18.0" 
$ns at 699.1780054258886 "$node_(352) setdest 10828 16912 13.0" 
$ns at 829.7821107863854 "$node_(352) setdest 51969 2474 14.0" 
$ns at 306.8450776336365 "$node_(353) setdest 51579 21513 4.0" 
$ns at 354.0591982645022 "$node_(353) setdest 24251 17493 13.0" 
$ns at 435.98722631869316 "$node_(353) setdest 12419 44639 11.0" 
$ns at 472.8144593243232 "$node_(353) setdest 91260 32793 14.0" 
$ns at 591.2439470549265 "$node_(353) setdest 10188 35413 8.0" 
$ns at 638.9231026798541 "$node_(353) setdest 20976 3528 2.0" 
$ns at 683.4286180481507 "$node_(353) setdest 69762 41145 9.0" 
$ns at 752.1382517835519 "$node_(353) setdest 6149 509 6.0" 
$ns at 840.7471079857407 "$node_(353) setdest 37875 13994 11.0" 
$ns at 870.905682163161 "$node_(353) setdest 39684 43726 13.0" 
$ns at 381.53441205818785 "$node_(354) setdest 69837 14012 2.0" 
$ns at 413.80712207667966 "$node_(354) setdest 99209 32848 7.0" 
$ns at 465.21825374637365 "$node_(354) setdest 130714 37442 3.0" 
$ns at 511.15716012253597 "$node_(354) setdest 116610 9347 2.0" 
$ns at 543.4818141488058 "$node_(354) setdest 97888 11337 9.0" 
$ns at 608.1768184246623 "$node_(354) setdest 102553 40419 3.0" 
$ns at 639.4505142610786 "$node_(354) setdest 113270 26650 11.0" 
$ns at 694.4948094033556 "$node_(354) setdest 109314 38188 17.0" 
$ns at 735.2129748957797 "$node_(354) setdest 62575 18490 19.0" 
$ns at 768.3336415106595 "$node_(354) setdest 32197 24194 5.0" 
$ns at 828.6575077401735 "$node_(354) setdest 83809 4237 1.0" 
$ns at 866.7404121384902 "$node_(354) setdest 133106 40989 16.0" 
$ns at 899.5005103319209 "$node_(354) setdest 40599 15413 9.0" 
$ns at 324.79026138492884 "$node_(355) setdest 69857 12633 4.0" 
$ns at 370.41139480797773 "$node_(355) setdest 67366 24023 11.0" 
$ns at 411.11942542977465 "$node_(355) setdest 63214 995 16.0" 
$ns at 469.10048091724934 "$node_(355) setdest 45980 33637 4.0" 
$ns at 534.3558842167675 "$node_(355) setdest 28825 11861 8.0" 
$ns at 631.3405961105843 "$node_(355) setdest 50760 6075 5.0" 
$ns at 676.9918050524286 "$node_(355) setdest 1827 39806 18.0" 
$ns at 707.4050020973172 "$node_(355) setdest 59028 28142 11.0" 
$ns at 769.4629076616769 "$node_(355) setdest 46833 33133 18.0" 
$ns at 810.690589101403 "$node_(355) setdest 124561 13771 6.0" 
$ns at 885.8385746329412 "$node_(355) setdest 21501 9637 6.0" 
$ns at 343.0972124896084 "$node_(356) setdest 41058 10673 4.0" 
$ns at 390.07144893014913 "$node_(356) setdest 82796 918 8.0" 
$ns at 456.90791965688686 "$node_(356) setdest 52825 38935 1.0" 
$ns at 495.8047524024817 "$node_(356) setdest 12528 7820 7.0" 
$ns at 538.100101474151 "$node_(356) setdest 32068 10211 11.0" 
$ns at 581.3544403110544 "$node_(356) setdest 54419 318 15.0" 
$ns at 745.1898950675483 "$node_(356) setdest 1015 44461 19.0" 
$ns at 302.55845929458127 "$node_(357) setdest 64821 9901 13.0" 
$ns at 384.793057086492 "$node_(357) setdest 87835 9837 8.0" 
$ns at 455.1625816830068 "$node_(357) setdest 130378 25454 16.0" 
$ns at 574.8673126612367 "$node_(357) setdest 98708 11309 1.0" 
$ns at 612.216795473825 "$node_(357) setdest 125775 44629 14.0" 
$ns at 777.0293809037662 "$node_(357) setdest 109632 40831 8.0" 
$ns at 841.2892375922141 "$node_(357) setdest 131631 36842 17.0" 
$ns at 369.34911126461657 "$node_(358) setdest 23468 800 15.0" 
$ns at 439.4153471504924 "$node_(358) setdest 65742 12739 18.0" 
$ns at 526.1189321661266 "$node_(358) setdest 1639 35130 11.0" 
$ns at 611.87605677962 "$node_(358) setdest 95194 23808 17.0" 
$ns at 746.3874903041992 "$node_(358) setdest 10043 6532 13.0" 
$ns at 790.7128395134715 "$node_(358) setdest 134020 23276 14.0" 
$ns at 836.1993219829872 "$node_(358) setdest 30258 20914 17.0" 
$ns at 874.4177738912882 "$node_(358) setdest 110558 23688 7.0" 
$ns at 378.0915180882232 "$node_(359) setdest 88896 43821 5.0" 
$ns at 437.1513400578896 "$node_(359) setdest 37947 6814 8.0" 
$ns at 530.5040617518221 "$node_(359) setdest 30079 1953 4.0" 
$ns at 578.8390561202028 "$node_(359) setdest 2087 7989 17.0" 
$ns at 755.5421068001937 "$node_(359) setdest 87885 40614 9.0" 
$ns at 812.3754370654765 "$node_(359) setdest 96765 6109 6.0" 
$ns at 878.6615465852981 "$node_(359) setdest 89154 23058 14.0" 
$ns at 396.70680407068437 "$node_(360) setdest 69996 4968 10.0" 
$ns at 459.74043118183124 "$node_(360) setdest 3862 13870 12.0" 
$ns at 561.6002962236229 "$node_(360) setdest 98391 30195 18.0" 
$ns at 602.1782914039177 "$node_(360) setdest 57733 13043 14.0" 
$ns at 670.3126631173477 "$node_(360) setdest 33809 39063 12.0" 
$ns at 718.4004696453454 "$node_(360) setdest 102494 5009 18.0" 
$ns at 885.6742903002236 "$node_(360) setdest 124736 22385 8.0" 
$ns at 313.48080997713356 "$node_(361) setdest 25129 21714 19.0" 
$ns at 459.1494175373148 "$node_(361) setdest 4304 19403 15.0" 
$ns at 490.8683425150378 "$node_(361) setdest 6094 41027 10.0" 
$ns at 598.4701967822069 "$node_(361) setdest 93459 5239 19.0" 
$ns at 784.7089059900228 "$node_(361) setdest 108150 5871 11.0" 
$ns at 851.6190226961921 "$node_(361) setdest 84099 42675 1.0" 
$ns at 885.6262348839521 "$node_(361) setdest 64490 6003 1.0" 
$ns at 306.5139554236787 "$node_(362) setdest 36636 18294 12.0" 
$ns at 416.87619504108704 "$node_(362) setdest 99616 14647 11.0" 
$ns at 495.87377103278175 "$node_(362) setdest 85342 37938 8.0" 
$ns at 562.1346494369238 "$node_(362) setdest 119335 15453 8.0" 
$ns at 622.0610471598242 "$node_(362) setdest 28246 30281 4.0" 
$ns at 671.7462226404277 "$node_(362) setdest 89366 36005 14.0" 
$ns at 807.1917622280682 "$node_(362) setdest 97777 14432 4.0" 
$ns at 850.6490430393666 "$node_(362) setdest 39259 11858 14.0" 
$ns at 306.27479095784804 "$node_(363) setdest 47205 39138 5.0" 
$ns at 352.8234712534358 "$node_(363) setdest 3992 18056 9.0" 
$ns at 402.6983281565766 "$node_(363) setdest 21042 32851 15.0" 
$ns at 547.1111869297013 "$node_(363) setdest 100792 10219 5.0" 
$ns at 590.3231134229111 "$node_(363) setdest 105963 39669 9.0" 
$ns at 690.0079991980832 "$node_(363) setdest 130459 11060 3.0" 
$ns at 730.2996371901439 "$node_(363) setdest 108614 42825 4.0" 
$ns at 783.0920585167844 "$node_(363) setdest 76931 13176 19.0" 
$ns at 420.70268975724906 "$node_(364) setdest 25646 11997 9.0" 
$ns at 518.2945401901329 "$node_(364) setdest 120753 25478 9.0" 
$ns at 560.0533180407272 "$node_(364) setdest 18940 34674 4.0" 
$ns at 601.8172198975772 "$node_(364) setdest 27270 1210 13.0" 
$ns at 645.9355095171677 "$node_(364) setdest 93711 27340 5.0" 
$ns at 722.8586319865112 "$node_(364) setdest 105879 29443 1.0" 
$ns at 756.6603181041364 "$node_(364) setdest 39589 10999 12.0" 
$ns at 802.6464002324783 "$node_(364) setdest 45950 39570 5.0" 
$ns at 854.5653496250249 "$node_(364) setdest 38144 41889 1.0" 
$ns at 885.0006947943635 "$node_(364) setdest 79637 11064 8.0" 
$ns at 312.6184317478992 "$node_(365) setdest 58405 7617 18.0" 
$ns at 411.0939668031468 "$node_(365) setdest 99842 1222 2.0" 
$ns at 460.7891073048407 "$node_(365) setdest 10516 35477 12.0" 
$ns at 592.3081957494721 "$node_(365) setdest 97361 1935 5.0" 
$ns at 661.8066506327993 "$node_(365) setdest 23166 14476 2.0" 
$ns at 692.3802278285705 "$node_(365) setdest 122305 43064 2.0" 
$ns at 724.6918120719286 "$node_(365) setdest 40010 19233 3.0" 
$ns at 780.0028835572276 "$node_(365) setdest 127450 7635 17.0" 
$ns at 333.29270762006337 "$node_(366) setdest 82608 14749 3.0" 
$ns at 363.5131422654531 "$node_(366) setdest 69482 25462 1.0" 
$ns at 395.84772342342336 "$node_(366) setdest 77422 20108 18.0" 
$ns at 478.07074729960965 "$node_(366) setdest 42786 19828 3.0" 
$ns at 522.7273817692026 "$node_(366) setdest 119377 26092 10.0" 
$ns at 649.3226584387249 "$node_(366) setdest 109737 13185 14.0" 
$ns at 795.8531560011893 "$node_(366) setdest 25151 22498 13.0" 
$ns at 341.7370370887445 "$node_(367) setdest 51472 6623 14.0" 
$ns at 418.7380366129437 "$node_(367) setdest 82317 19968 10.0" 
$ns at 478.8101238970382 "$node_(367) setdest 100086 35150 15.0" 
$ns at 614.3261783328026 "$node_(367) setdest 29706 3193 20.0" 
$ns at 745.9667630012883 "$node_(367) setdest 54078 8119 20.0" 
$ns at 867.9209208564142 "$node_(367) setdest 126732 42131 11.0" 
$ns at 374.9700733511222 "$node_(368) setdest 37525 40472 20.0" 
$ns at 524.7685233140529 "$node_(368) setdest 92756 35666 14.0" 
$ns at 635.5256136521627 "$node_(368) setdest 55808 32607 8.0" 
$ns at 742.3470257537676 "$node_(368) setdest 89792 2567 9.0" 
$ns at 845.9659931120012 "$node_(368) setdest 49919 5948 11.0" 
$ns at 336.9752199681031 "$node_(369) setdest 91857 35615 10.0" 
$ns at 391.31536635250006 "$node_(369) setdest 119961 2269 1.0" 
$ns at 428.6112106494159 "$node_(369) setdest 112027 26124 5.0" 
$ns at 483.37111293117044 "$node_(369) setdest 124220 19305 2.0" 
$ns at 531.1214472432513 "$node_(369) setdest 51844 12363 9.0" 
$ns at 609.0602419571561 "$node_(369) setdest 103719 37099 3.0" 
$ns at 653.326811139224 "$node_(369) setdest 134014 40370 6.0" 
$ns at 738.4518594948204 "$node_(369) setdest 9121 19231 17.0" 
$ns at 769.5309628780177 "$node_(369) setdest 39177 21903 20.0" 
$ns at 868.8698015882874 "$node_(369) setdest 26512 14594 19.0" 
$ns at 309.3795716737959 "$node_(370) setdest 130738 21778 18.0" 
$ns at 397.06966858485833 "$node_(370) setdest 5669 10977 11.0" 
$ns at 428.3497665377869 "$node_(370) setdest 67163 21519 19.0" 
$ns at 557.2065562098018 "$node_(370) setdest 106979 22373 4.0" 
$ns at 588.3981370812281 "$node_(370) setdest 98961 24031 9.0" 
$ns at 626.0143356160363 "$node_(370) setdest 14999 25873 3.0" 
$ns at 673.3933191164354 "$node_(370) setdest 94356 26486 2.0" 
$ns at 722.4814960292949 "$node_(370) setdest 118114 33913 18.0" 
$ns at 792.8533828203451 "$node_(370) setdest 27100 11955 4.0" 
$ns at 858.6505349099833 "$node_(370) setdest 80000 17878 15.0" 
$ns at 349.5657393124577 "$node_(371) setdest 62872 15347 4.0" 
$ns at 414.368379274641 "$node_(371) setdest 99109 29243 4.0" 
$ns at 468.49260683731245 "$node_(371) setdest 76060 31433 1.0" 
$ns at 507.7262671379138 "$node_(371) setdest 59621 12690 10.0" 
$ns at 543.0057793509313 "$node_(371) setdest 64266 41535 18.0" 
$ns at 627.6394120640128 "$node_(371) setdest 78944 37011 17.0" 
$ns at 803.7310146615988 "$node_(371) setdest 23401 27182 8.0" 
$ns at 469.395007601557 "$node_(372) setdest 18017 12561 1.0" 
$ns at 506.4706985729233 "$node_(372) setdest 76474 33426 18.0" 
$ns at 555.2703618966087 "$node_(372) setdest 73402 26590 9.0" 
$ns at 643.4266443332735 "$node_(372) setdest 93068 42136 10.0" 
$ns at 723.6115788759658 "$node_(372) setdest 7231 32338 14.0" 
$ns at 838.6494072449534 "$node_(372) setdest 34229 32832 1.0" 
$ns at 870.301940351843 "$node_(372) setdest 88027 29762 7.0" 
$ns at 334.63857759848145 "$node_(373) setdest 72886 16563 12.0" 
$ns at 403.7022646629774 "$node_(373) setdest 107977 12440 16.0" 
$ns at 593.0140215832815 "$node_(373) setdest 45771 22576 13.0" 
$ns at 751.5088151830582 "$node_(373) setdest 17475 35612 10.0" 
$ns at 838.8662043084852 "$node_(373) setdest 38369 18855 13.0" 
$ns at 354.76781911970255 "$node_(374) setdest 88998 2420 19.0" 
$ns at 422.1432305845439 "$node_(374) setdest 58607 38314 10.0" 
$ns at 539.6597514104079 "$node_(374) setdest 29272 28439 20.0" 
$ns at 718.1440924278903 "$node_(374) setdest 42948 35618 15.0" 
$ns at 863.3445814871475 "$node_(374) setdest 7028 17404 16.0" 
$ns at 333.26383635096965 "$node_(375) setdest 95967 33104 12.0" 
$ns at 387.1997274533891 "$node_(375) setdest 129030 8413 10.0" 
$ns at 435.3322864693452 "$node_(375) setdest 6080 36367 14.0" 
$ns at 489.975012949083 "$node_(375) setdest 119039 15639 18.0" 
$ns at 689.9086022030033 "$node_(375) setdest 99978 43614 6.0" 
$ns at 726.9531727749674 "$node_(375) setdest 106629 33910 3.0" 
$ns at 765.0724690395285 "$node_(375) setdest 17498 6093 18.0" 
$ns at 350.25917057163974 "$node_(376) setdest 7224 39193 17.0" 
$ns at 465.01725745526016 "$node_(376) setdest 4565 36311 4.0" 
$ns at 511.9085064825413 "$node_(376) setdest 128162 9883 3.0" 
$ns at 560.6366403923545 "$node_(376) setdest 124759 40853 8.0" 
$ns at 617.5456843168839 "$node_(376) setdest 15127 3195 8.0" 
$ns at 679.8330230266696 "$node_(376) setdest 108069 38360 1.0" 
$ns at 713.9043228822402 "$node_(376) setdest 130840 32115 13.0" 
$ns at 768.2184264627408 "$node_(376) setdest 40476 41562 15.0" 
$ns at 801.9257538218092 "$node_(376) setdest 58435 1104 17.0" 
$ns at 436.84243799886315 "$node_(377) setdest 5698 28546 20.0" 
$ns at 572.9199300943055 "$node_(377) setdest 86839 30348 17.0" 
$ns at 763.4896015504238 "$node_(377) setdest 17136 25162 12.0" 
$ns at 867.7899170146417 "$node_(377) setdest 80879 20807 13.0" 
$ns at 357.4903347522562 "$node_(378) setdest 113053 5126 14.0" 
$ns at 411.8725189655399 "$node_(378) setdest 115099 39069 6.0" 
$ns at 490.7955804803188 "$node_(378) setdest 68804 28815 18.0" 
$ns at 542.7222825335964 "$node_(378) setdest 24100 38604 2.0" 
$ns at 580.2158896128977 "$node_(378) setdest 30011 40012 7.0" 
$ns at 674.049269959637 "$node_(378) setdest 103702 25613 8.0" 
$ns at 739.9181284789939 "$node_(378) setdest 16381 41778 13.0" 
$ns at 834.9388025142855 "$node_(378) setdest 56567 39796 4.0" 
$ns at 882.0117520542373 "$node_(378) setdest 133329 34827 19.0" 
$ns at 437.3204952150038 "$node_(379) setdest 68208 27194 9.0" 
$ns at 530.5013841953902 "$node_(379) setdest 46722 18442 1.0" 
$ns at 563.8610672862442 "$node_(379) setdest 75030 6924 8.0" 
$ns at 600.0156019117248 "$node_(379) setdest 39719 18729 1.0" 
$ns at 630.6264151412237 "$node_(379) setdest 38056 35053 4.0" 
$ns at 695.679322649086 "$node_(379) setdest 1569 12286 2.0" 
$ns at 738.0339362580168 "$node_(379) setdest 58206 24135 4.0" 
$ns at 796.3169766075804 "$node_(379) setdest 126513 9730 5.0" 
$ns at 833.4470127803867 "$node_(379) setdest 128871 1358 9.0" 
$ns at 364.3829819275926 "$node_(380) setdest 89180 40079 16.0" 
$ns at 513.6226344432016 "$node_(380) setdest 83878 27198 5.0" 
$ns at 558.8982446483261 "$node_(380) setdest 92906 11053 1.0" 
$ns at 598.6788658719695 "$node_(380) setdest 73127 13616 7.0" 
$ns at 673.8025366702786 "$node_(380) setdest 131028 27440 12.0" 
$ns at 774.9164698641312 "$node_(380) setdest 133612 31021 16.0" 
$ns at 821.537317059063 "$node_(380) setdest 98042 44187 3.0" 
$ns at 869.1171849036514 "$node_(380) setdest 42954 32639 7.0" 
$ns at 409.4386410502241 "$node_(381) setdest 17395 17701 12.0" 
$ns at 521.2321502086928 "$node_(381) setdest 50499 13670 17.0" 
$ns at 615.1878938789968 "$node_(381) setdest 112335 23657 20.0" 
$ns at 778.7937982645975 "$node_(381) setdest 69822 901 10.0" 
$ns at 865.5294573543567 "$node_(381) setdest 119165 33402 1.0" 
$ns at 897.0092422634909 "$node_(381) setdest 132858 2236 18.0" 
$ns at 307.7232422921104 "$node_(382) setdest 69835 3147 15.0" 
$ns at 400.50324960018213 "$node_(382) setdest 20235 35444 5.0" 
$ns at 469.98262111296566 "$node_(382) setdest 124736 25932 9.0" 
$ns at 548.0749403044962 "$node_(382) setdest 126561 29503 17.0" 
$ns at 745.8871135352281 "$node_(382) setdest 117315 10701 15.0" 
$ns at 372.2682466839848 "$node_(383) setdest 43023 22244 7.0" 
$ns at 461.9519601271382 "$node_(383) setdest 4154 39182 20.0" 
$ns at 572.9856218041369 "$node_(383) setdest 58743 29607 1.0" 
$ns at 604.7551373162943 "$node_(383) setdest 20565 11999 2.0" 
$ns at 635.7835117137153 "$node_(383) setdest 4342 36335 9.0" 
$ns at 726.9918830150217 "$node_(383) setdest 113017 24587 5.0" 
$ns at 798.1310868298003 "$node_(383) setdest 114564 25184 12.0" 
$ns at 884.5059504436357 "$node_(383) setdest 60115 27334 15.0" 
$ns at 416.63658711247734 "$node_(384) setdest 58017 15625 4.0" 
$ns at 476.4191883537237 "$node_(384) setdest 125784 9689 3.0" 
$ns at 528.478357559376 "$node_(384) setdest 127102 19014 6.0" 
$ns at 597.5379400298297 "$node_(384) setdest 38043 2756 3.0" 
$ns at 633.9303388582459 "$node_(384) setdest 21422 22879 7.0" 
$ns at 695.7490644136575 "$node_(384) setdest 18091 17247 7.0" 
$ns at 730.2253190099193 "$node_(384) setdest 113451 14115 9.0" 
$ns at 795.6283583498016 "$node_(384) setdest 44909 27111 10.0" 
$ns at 871.8027520781785 "$node_(384) setdest 86435 14918 9.0" 
$ns at 309.0716399485528 "$node_(385) setdest 88763 15316 3.0" 
$ns at 350.8433954498778 "$node_(385) setdest 120864 25672 10.0" 
$ns at 468.35671538400635 "$node_(385) setdest 100943 11070 3.0" 
$ns at 523.7948024445604 "$node_(385) setdest 77011 1340 2.0" 
$ns at 572.1337403512874 "$node_(385) setdest 13807 20716 6.0" 
$ns at 616.7208232751352 "$node_(385) setdest 116625 38630 9.0" 
$ns at 728.8118332734509 "$node_(385) setdest 127636 42243 5.0" 
$ns at 803.8657855700163 "$node_(385) setdest 32220 38145 5.0" 
$ns at 860.1676312946184 "$node_(385) setdest 123240 5037 14.0" 
$ns at 404.2215795348314 "$node_(386) setdest 21389 29007 1.0" 
$ns at 436.12661095055387 "$node_(386) setdest 17767 41913 1.0" 
$ns at 476.0861273848349 "$node_(386) setdest 21109 41299 12.0" 
$ns at 589.3706116224123 "$node_(386) setdest 124561 22025 12.0" 
$ns at 711.5562847861454 "$node_(386) setdest 47544 30130 7.0" 
$ns at 788.6976164041303 "$node_(386) setdest 113358 37893 9.0" 
$ns at 890.0696028577805 "$node_(386) setdest 17898 13847 16.0" 
$ns at 325.6139376380784 "$node_(387) setdest 96181 38253 3.0" 
$ns at 365.05846129913016 "$node_(387) setdest 95611 8166 19.0" 
$ns at 460.4543021439089 "$node_(387) setdest 62534 44208 12.0" 
$ns at 546.8792910915209 "$node_(387) setdest 133054 32607 13.0" 
$ns at 645.4809949372685 "$node_(387) setdest 106763 44687 17.0" 
$ns at 713.2160382051711 "$node_(387) setdest 120315 25261 17.0" 
$ns at 772.6119733686317 "$node_(387) setdest 60490 6802 3.0" 
$ns at 808.9737688736265 "$node_(387) setdest 19098 38780 16.0" 
$ns at 349.6550175664165 "$node_(388) setdest 60218 26786 13.0" 
$ns at 403.8253253309457 "$node_(388) setdest 126625 20169 11.0" 
$ns at 516.1652718668175 "$node_(388) setdest 105664 43468 1.0" 
$ns at 552.827066495069 "$node_(388) setdest 17220 13680 9.0" 
$ns at 611.1803674500621 "$node_(388) setdest 119771 4018 14.0" 
$ns at 666.7715473787367 "$node_(388) setdest 133386 34090 4.0" 
$ns at 728.5056700046039 "$node_(388) setdest 99240 4522 7.0" 
$ns at 796.6959431669999 "$node_(388) setdest 195 5585 11.0" 
$ns at 887.6411573780168 "$node_(388) setdest 105988 2854 12.0" 
$ns at 301.0342688337858 "$node_(389) setdest 95742 22057 2.0" 
$ns at 348.2545725879644 "$node_(389) setdest 125966 22246 3.0" 
$ns at 386.9604477119064 "$node_(389) setdest 23208 14529 2.0" 
$ns at 426.1940428406759 "$node_(389) setdest 132501 23230 9.0" 
$ns at 508.88705294538573 "$node_(389) setdest 41449 27930 15.0" 
$ns at 545.0489166044889 "$node_(389) setdest 119627 39513 14.0" 
$ns at 596.759385606819 "$node_(389) setdest 84026 4397 4.0" 
$ns at 634.4964396005272 "$node_(389) setdest 116617 44391 13.0" 
$ns at 704.6354789031644 "$node_(389) setdest 124215 39278 13.0" 
$ns at 810.8687178835255 "$node_(389) setdest 89576 1247 9.0" 
$ns at 876.1888369209686 "$node_(389) setdest 2306 41183 13.0" 
$ns at 397.32545081179995 "$node_(390) setdest 18703 27914 4.0" 
$ns at 452.99403940483313 "$node_(390) setdest 86517 27510 12.0" 
$ns at 582.9480847564913 "$node_(390) setdest 37528 15729 6.0" 
$ns at 665.9031559469906 "$node_(390) setdest 31071 28378 19.0" 
$ns at 825.949822769664 "$node_(390) setdest 6334 34186 4.0" 
$ns at 882.3757907746584 "$node_(390) setdest 28968 41605 7.0" 
$ns at 312.30008625653454 "$node_(391) setdest 91073 20301 19.0" 
$ns at 345.8762349942651 "$node_(391) setdest 27701 30921 17.0" 
$ns at 491.49053721404556 "$node_(391) setdest 72157 37425 19.0" 
$ns at 653.4114516700198 "$node_(391) setdest 4629 5511 12.0" 
$ns at 696.530867253212 "$node_(391) setdest 57497 38572 7.0" 
$ns at 788.7764350598435 "$node_(391) setdest 131885 25641 11.0" 
$ns at 870.3488731938098 "$node_(391) setdest 123551 38503 16.0" 
$ns at 325.45955827158116 "$node_(392) setdest 35620 6178 11.0" 
$ns at 403.1592806171241 "$node_(392) setdest 58020 35043 10.0" 
$ns at 450.4149687106742 "$node_(392) setdest 105145 42854 3.0" 
$ns at 482.5657428700509 "$node_(392) setdest 16911 43549 6.0" 
$ns at 557.773318105003 "$node_(392) setdest 15444 40078 14.0" 
$ns at 620.9229682095028 "$node_(392) setdest 127798 42444 1.0" 
$ns at 656.7658476255901 "$node_(392) setdest 12667 36626 17.0" 
$ns at 828.253433813901 "$node_(392) setdest 79200 41509 19.0" 
$ns at 401.2383467986949 "$node_(393) setdest 87320 38042 19.0" 
$ns at 598.5760811240436 "$node_(393) setdest 7341 8461 2.0" 
$ns at 629.1251810340193 "$node_(393) setdest 131222 15065 20.0" 
$ns at 762.61226327 "$node_(393) setdest 68516 26023 13.0" 
$ns at 864.9244946767174 "$node_(393) setdest 95054 11773 18.0" 
$ns at 318.45453984890474 "$node_(394) setdest 928 24560 12.0" 
$ns at 420.2052249653569 "$node_(394) setdest 98849 5717 16.0" 
$ns at 456.8178091086479 "$node_(394) setdest 22213 4345 17.0" 
$ns at 575.7039481211336 "$node_(394) setdest 49818 40551 5.0" 
$ns at 622.3251876159105 "$node_(394) setdest 104647 40381 5.0" 
$ns at 697.1562664438414 "$node_(394) setdest 68574 40580 6.0" 
$ns at 727.7370570630851 "$node_(394) setdest 104903 22954 12.0" 
$ns at 812.2433997306713 "$node_(394) setdest 22005 933 5.0" 
$ns at 867.939773808671 "$node_(394) setdest 108002 33943 20.0" 
$ns at 389.8208980379946 "$node_(395) setdest 74108 30149 16.0" 
$ns at 567.3644393137608 "$node_(395) setdest 123291 33055 11.0" 
$ns at 636.3869217640444 "$node_(395) setdest 89304 16340 4.0" 
$ns at 680.439779335184 "$node_(395) setdest 62973 8052 15.0" 
$ns at 792.5282022408423 "$node_(395) setdest 89150 17619 7.0" 
$ns at 829.4225243718726 "$node_(395) setdest 50315 2946 17.0" 
$ns at 445.485805375096 "$node_(396) setdest 79324 26251 7.0" 
$ns at 523.4005445549965 "$node_(396) setdest 68902 2468 8.0" 
$ns at 585.0936418227775 "$node_(396) setdest 57126 30262 14.0" 
$ns at 680.9489891402989 "$node_(396) setdest 102014 35896 3.0" 
$ns at 738.7733394020031 "$node_(396) setdest 30589 28290 12.0" 
$ns at 888.6724853924793 "$node_(396) setdest 134087 38961 10.0" 
$ns at 357.2306458940242 "$node_(397) setdest 81830 17604 17.0" 
$ns at 391.22342545781146 "$node_(397) setdest 785 40881 9.0" 
$ns at 454.2932178146819 "$node_(397) setdest 94284 36079 11.0" 
$ns at 552.1944653584917 "$node_(397) setdest 21420 3825 9.0" 
$ns at 606.7226011868287 "$node_(397) setdest 124776 18601 18.0" 
$ns at 794.2037758650305 "$node_(397) setdest 27705 12678 13.0" 
$ns at 364.6296020901169 "$node_(398) setdest 73720 34594 8.0" 
$ns at 461.61725890906644 "$node_(398) setdest 73094 30769 9.0" 
$ns at 546.6204260380226 "$node_(398) setdest 131854 32398 1.0" 
$ns at 582.4609632911533 "$node_(398) setdest 112986 14377 8.0" 
$ns at 692.192861128574 "$node_(398) setdest 14675 39016 13.0" 
$ns at 799.2516092786648 "$node_(398) setdest 71537 40975 1.0" 
$ns at 837.3581168851189 "$node_(398) setdest 10652 28905 12.0" 
$ns at 329.8340858262761 "$node_(399) setdest 114353 20117 3.0" 
$ns at 363.39734615603817 "$node_(399) setdest 39076 4776 9.0" 
$ns at 479.8989562318195 "$node_(399) setdest 13435 42047 3.0" 
$ns at 525.080042543436 "$node_(399) setdest 56549 33950 2.0" 
$ns at 558.3908076348512 "$node_(399) setdest 46714 31795 16.0" 
$ns at 592.6648957067582 "$node_(399) setdest 107753 3351 7.0" 
$ns at 666.5931234904918 "$node_(399) setdest 23201 8424 13.0" 
$ns at 802.784825171913 "$node_(399) setdest 128180 37446 8.0" 
$ns at 405.2431371522733 "$node_(400) setdest 350 6144 20.0" 
$ns at 524.0817227465409 "$node_(400) setdest 133886 16918 5.0" 
$ns at 558.7423294564052 "$node_(400) setdest 126372 43748 19.0" 
$ns at 720.7548595055833 "$node_(400) setdest 76512 28189 8.0" 
$ns at 790.0571575921734 "$node_(400) setdest 109531 27709 19.0" 
$ns at 407.81380546384275 "$node_(401) setdest 131159 7970 3.0" 
$ns at 467.59434855175334 "$node_(401) setdest 42149 27404 20.0" 
$ns at 574.0088256210515 "$node_(401) setdest 58012 914 18.0" 
$ns at 623.505571167739 "$node_(401) setdest 47588 11568 9.0" 
$ns at 738.0625234245445 "$node_(401) setdest 69546 2206 5.0" 
$ns at 784.2883334147805 "$node_(401) setdest 127689 41254 14.0" 
$ns at 881.486622868938 "$node_(401) setdest 61987 8955 17.0" 
$ns at 472.194139612501 "$node_(402) setdest 33121 40763 1.0" 
$ns at 511.861923716295 "$node_(402) setdest 4667 32857 16.0" 
$ns at 681.427145199769 "$node_(402) setdest 9846 13227 15.0" 
$ns at 810.647309587911 "$node_(402) setdest 114428 18241 5.0" 
$ns at 869.7219314926806 "$node_(402) setdest 20612 31802 5.0" 
$ns at 483.0223792187912 "$node_(403) setdest 52298 30644 8.0" 
$ns at 536.0768407620575 "$node_(403) setdest 29750 8476 7.0" 
$ns at 572.9468004452054 "$node_(403) setdest 81453 40935 12.0" 
$ns at 638.5666640143293 "$node_(403) setdest 63116 28105 16.0" 
$ns at 747.522205485473 "$node_(403) setdest 6242 30445 16.0" 
$ns at 562.4281679183853 "$node_(404) setdest 34388 39042 14.0" 
$ns at 688.8643829748518 "$node_(404) setdest 56633 13496 2.0" 
$ns at 735.780459508361 "$node_(404) setdest 51103 27881 12.0" 
$ns at 844.3310583599892 "$node_(404) setdest 3787 1478 16.0" 
$ns at 540.3824569224469 "$node_(405) setdest 30296 1303 2.0" 
$ns at 586.1610553967846 "$node_(405) setdest 43936 37183 18.0" 
$ns at 675.5270378886797 "$node_(405) setdest 25469 20517 18.0" 
$ns at 753.7905815139401 "$node_(405) setdest 69516 32894 12.0" 
$ns at 877.0308453782917 "$node_(405) setdest 26606 27621 1.0" 
$ns at 418.2360454184776 "$node_(406) setdest 54021 23063 1.0" 
$ns at 457.68210559545054 "$node_(406) setdest 63119 30394 14.0" 
$ns at 614.49240570704 "$node_(406) setdest 69867 26590 7.0" 
$ns at 664.2970682711282 "$node_(406) setdest 10064 22063 1.0" 
$ns at 701.1197823580278 "$node_(406) setdest 102524 15782 16.0" 
$ns at 747.227761432885 "$node_(406) setdest 124298 24281 6.0" 
$ns at 803.7479133088472 "$node_(406) setdest 114388 30677 20.0" 
$ns at 423.52572263452515 "$node_(407) setdest 17194 2934 2.0" 
$ns at 456.86953070480894 "$node_(407) setdest 39959 40777 9.0" 
$ns at 494.14049272537557 "$node_(407) setdest 128067 40092 8.0" 
$ns at 553.513246643453 "$node_(407) setdest 131742 27839 6.0" 
$ns at 639.9749175340661 "$node_(407) setdest 69294 30493 18.0" 
$ns at 713.1087223449917 "$node_(407) setdest 15321 13353 8.0" 
$ns at 773.3713916186803 "$node_(407) setdest 33656 42701 16.0" 
$ns at 846.5250462150257 "$node_(407) setdest 42587 21292 9.0" 
$ns at 406.8698005747841 "$node_(408) setdest 102654 20717 19.0" 
$ns at 481.1857356471568 "$node_(408) setdest 85854 7624 16.0" 
$ns at 593.877967342421 "$node_(408) setdest 3607 837 20.0" 
$ns at 790.2548359162473 "$node_(408) setdest 124915 38482 9.0" 
$ns at 883.7810842953832 "$node_(408) setdest 35903 16980 10.0" 
$ns at 414.4633794954853 "$node_(409) setdest 129024 39403 8.0" 
$ns at 467.7493108757796 "$node_(409) setdest 10941 3118 15.0" 
$ns at 562.665803927018 "$node_(409) setdest 88996 31261 11.0" 
$ns at 662.1612893629151 "$node_(409) setdest 31968 14322 19.0" 
$ns at 806.7936814163991 "$node_(409) setdest 72935 39666 19.0" 
$ns at 450.18209449688186 "$node_(410) setdest 89199 2332 2.0" 
$ns at 499.30745273522757 "$node_(410) setdest 14210 44393 2.0" 
$ns at 546.2832153763964 "$node_(410) setdest 111867 36885 15.0" 
$ns at 631.7005863463626 "$node_(410) setdest 56799 4861 3.0" 
$ns at 677.1249094941492 "$node_(410) setdest 102335 31435 14.0" 
$ns at 834.6343754558599 "$node_(410) setdest 131769 35518 14.0" 
$ns at 893.2288300309853 "$node_(410) setdest 41126 19988 5.0" 
$ns at 476.9610914672497 "$node_(411) setdest 73517 13672 14.0" 
$ns at 631.3699320455321 "$node_(411) setdest 10251 1779 11.0" 
$ns at 727.0761815488319 "$node_(411) setdest 74334 21113 12.0" 
$ns at 770.6721264594507 "$node_(411) setdest 133281 34011 6.0" 
$ns at 816.9133722159277 "$node_(411) setdest 40518 44710 11.0" 
$ns at 863.504186434667 "$node_(411) setdest 34216 2674 8.0" 
$ns at 485.666261689447 "$node_(412) setdest 49917 28283 10.0" 
$ns at 539.2088375187748 "$node_(412) setdest 14254 6605 6.0" 
$ns at 576.1817966124876 "$node_(412) setdest 31051 32713 20.0" 
$ns at 610.1993179020147 "$node_(412) setdest 116223 14622 3.0" 
$ns at 655.1954144799101 "$node_(412) setdest 99162 20033 1.0" 
$ns at 688.098055552293 "$node_(412) setdest 75422 20572 16.0" 
$ns at 823.114223698948 "$node_(412) setdest 99493 22951 5.0" 
$ns at 868.7827043498821 "$node_(412) setdest 70390 11011 10.0" 
$ns at 514.7764677434022 "$node_(413) setdest 133991 10657 3.0" 
$ns at 554.5549305054795 "$node_(413) setdest 101498 40107 2.0" 
$ns at 592.0250002750431 "$node_(413) setdest 24837 25008 16.0" 
$ns at 645.097719853341 "$node_(413) setdest 120994 6236 4.0" 
$ns at 700.2300352154972 "$node_(413) setdest 32036 24059 18.0" 
$ns at 767.164103427465 "$node_(413) setdest 119299 27354 17.0" 
$ns at 883.1242997961973 "$node_(413) setdest 118884 28159 5.0" 
$ns at 425.7754381444718 "$node_(414) setdest 96353 32608 19.0" 
$ns at 478.65713557782425 "$node_(414) setdest 125677 33301 10.0" 
$ns at 538.1361913487294 "$node_(414) setdest 75641 22754 4.0" 
$ns at 576.8922152856833 "$node_(414) setdest 46716 24432 15.0" 
$ns at 718.128614900603 "$node_(414) setdest 59 15442 5.0" 
$ns at 794.0579781360171 "$node_(414) setdest 33205 765 7.0" 
$ns at 877.3601401463516 "$node_(414) setdest 43231 40041 17.0" 
$ns at 421.7122496743749 "$node_(415) setdest 58317 6446 3.0" 
$ns at 457.7165070147487 "$node_(415) setdest 216 12591 6.0" 
$ns at 509.89802381412176 "$node_(415) setdest 66638 9962 9.0" 
$ns at 544.2301851390584 "$node_(415) setdest 35607 41289 8.0" 
$ns at 626.809681365751 "$node_(415) setdest 109484 14369 1.0" 
$ns at 663.7044521650142 "$node_(415) setdest 111780 21863 18.0" 
$ns at 744.8529190255475 "$node_(415) setdest 83840 15181 17.0" 
$ns at 807.0879513173602 "$node_(415) setdest 23575 17619 7.0" 
$ns at 454.0335624790131 "$node_(416) setdest 95192 5453 13.0" 
$ns at 501.3844012980105 "$node_(416) setdest 18650 38712 1.0" 
$ns at 539.7285673848821 "$node_(416) setdest 37300 30793 3.0" 
$ns at 569.9264980729616 "$node_(416) setdest 102319 24748 3.0" 
$ns at 627.9858941532559 "$node_(416) setdest 116299 2117 15.0" 
$ns at 702.1932442460596 "$node_(416) setdest 17955 22162 11.0" 
$ns at 818.2979441876573 "$node_(416) setdest 65292 3584 17.0" 
$ns at 437.8577087861969 "$node_(417) setdest 37071 36990 10.0" 
$ns at 549.0743838886143 "$node_(417) setdest 63347 36078 16.0" 
$ns at 737.1817993128213 "$node_(417) setdest 38313 28321 3.0" 
$ns at 767.7529531998466 "$node_(417) setdest 32171 2641 19.0" 
$ns at 463.3900096921286 "$node_(418) setdest 117528 2202 9.0" 
$ns at 520.0333716313505 "$node_(418) setdest 81449 16885 13.0" 
$ns at 582.9593409359748 "$node_(418) setdest 117248 2454 9.0" 
$ns at 641.0192718292744 "$node_(418) setdest 130921 18874 2.0" 
$ns at 684.6119154328458 "$node_(418) setdest 80905 38830 14.0" 
$ns at 816.6592776815482 "$node_(418) setdest 5766 6434 7.0" 
$ns at 863.6548085206672 "$node_(418) setdest 100955 27767 2.0" 
$ns at 430.24850512513854 "$node_(419) setdest 126099 35134 13.0" 
$ns at 529.8047652851585 "$node_(419) setdest 133719 8403 5.0" 
$ns at 566.3795004295447 "$node_(419) setdest 115221 10258 17.0" 
$ns at 743.2467998455065 "$node_(419) setdest 40120 26795 8.0" 
$ns at 792.2882976518638 "$node_(419) setdest 119141 34302 15.0" 
$ns at 842.6814079170507 "$node_(419) setdest 40488 37425 5.0" 
$ns at 433.640463825467 "$node_(420) setdest 23275 7217 18.0" 
$ns at 490.3689015678838 "$node_(420) setdest 101453 40077 6.0" 
$ns at 551.4010147015825 "$node_(420) setdest 56356 22181 7.0" 
$ns at 588.7660660049106 "$node_(420) setdest 131187 13525 14.0" 
$ns at 639.8784291424806 "$node_(420) setdest 131415 40497 10.0" 
$ns at 676.5034072487754 "$node_(420) setdest 102742 20577 8.0" 
$ns at 769.6922722900049 "$node_(420) setdest 67126 33609 8.0" 
$ns at 836.2455647803102 "$node_(420) setdest 27963 15051 16.0" 
$ns at 418.81172573153026 "$node_(421) setdest 77658 25279 4.0" 
$ns at 477.05872758440097 "$node_(421) setdest 69393 41377 1.0" 
$ns at 508.6271119595149 "$node_(421) setdest 129521 23705 8.0" 
$ns at 539.8613148547898 "$node_(421) setdest 112680 6421 8.0" 
$ns at 576.1676583449736 "$node_(421) setdest 14619 20325 17.0" 
$ns at 771.2642075046109 "$node_(421) setdest 71016 17896 12.0" 
$ns at 440.4561941792767 "$node_(422) setdest 62880 21050 13.0" 
$ns at 491.56295252028565 "$node_(422) setdest 133094 40280 1.0" 
$ns at 523.3384576531303 "$node_(422) setdest 38156 4978 10.0" 
$ns at 633.3781892113311 "$node_(422) setdest 131173 43600 12.0" 
$ns at 675.1828723082629 "$node_(422) setdest 39806 44318 11.0" 
$ns at 722.7587093400682 "$node_(422) setdest 54242 41553 9.0" 
$ns at 773.7655371727385 "$node_(422) setdest 68277 14300 1.0" 
$ns at 807.0925543337892 "$node_(422) setdest 123267 32576 14.0" 
$ns at 847.1974694132261 "$node_(422) setdest 6131 3460 12.0" 
$ns at 486.16532798433286 "$node_(423) setdest 123951 7359 15.0" 
$ns at 549.243892573704 "$node_(423) setdest 18222 38150 1.0" 
$ns at 587.4493088431484 "$node_(423) setdest 92858 31966 14.0" 
$ns at 754.123211588427 "$node_(423) setdest 14536 25914 5.0" 
$ns at 794.1736514352629 "$node_(423) setdest 24305 855 5.0" 
$ns at 873.0784199813712 "$node_(423) setdest 111587 21897 1.0" 
$ns at 417.58034853541113 "$node_(424) setdest 34423 34070 3.0" 
$ns at 457.3505112308822 "$node_(424) setdest 91108 12941 1.0" 
$ns at 496.85049919794324 "$node_(424) setdest 126419 41119 5.0" 
$ns at 542.4809946242331 "$node_(424) setdest 55033 40672 3.0" 
$ns at 597.0393113995872 "$node_(424) setdest 67019 13460 5.0" 
$ns at 672.414988495325 "$node_(424) setdest 7484 34175 1.0" 
$ns at 707.2433567016265 "$node_(424) setdest 22557 34321 2.0" 
$ns at 752.3759659252331 "$node_(424) setdest 103466 28342 9.0" 
$ns at 794.5315495022151 "$node_(424) setdest 89587 26316 12.0" 
$ns at 455.09126365710256 "$node_(425) setdest 89966 9278 19.0" 
$ns at 585.1979122301641 "$node_(425) setdest 12740 41462 14.0" 
$ns at 698.6610992396386 "$node_(425) setdest 124016 24268 19.0" 
$ns at 499.16936227419023 "$node_(426) setdest 79149 15287 8.0" 
$ns at 529.3372407931475 "$node_(426) setdest 111368 42406 16.0" 
$ns at 561.5402234364345 "$node_(426) setdest 81614 23890 20.0" 
$ns at 621.6302316750771 "$node_(426) setdest 114515 2015 14.0" 
$ns at 721.7578078080431 "$node_(426) setdest 90674 4709 5.0" 
$ns at 775.351747592458 "$node_(426) setdest 87303 40428 18.0" 
$ns at 431.2597988343537 "$node_(427) setdest 102141 10919 16.0" 
$ns at 469.5768848025472 "$node_(427) setdest 36023 17049 4.0" 
$ns at 502.93207435732 "$node_(427) setdest 42279 7133 16.0" 
$ns at 577.723721267729 "$node_(427) setdest 98759 3984 12.0" 
$ns at 615.2914228437727 "$node_(427) setdest 75836 11985 6.0" 
$ns at 697.0909276515581 "$node_(427) setdest 49272 26446 4.0" 
$ns at 732.527919857214 "$node_(427) setdest 110780 9135 7.0" 
$ns at 798.2876784769212 "$node_(427) setdest 83930 33768 5.0" 
$ns at 871.6644415228176 "$node_(427) setdest 40053 28745 4.0" 
$ns at 400.0641852201687 "$node_(428) setdest 50362 15891 12.0" 
$ns at 510.27068314636165 "$node_(428) setdest 94738 18081 1.0" 
$ns at 546.013227233205 "$node_(428) setdest 44321 12331 3.0" 
$ns at 593.4107758246018 "$node_(428) setdest 34198 27800 9.0" 
$ns at 663.579643506633 "$node_(428) setdest 42132 9899 7.0" 
$ns at 701.2361958576103 "$node_(428) setdest 1352 31041 4.0" 
$ns at 753.530889604651 "$node_(428) setdest 89712 38096 6.0" 
$ns at 805.539780757754 "$node_(428) setdest 74035 9848 12.0" 
$ns at 890.5724964704198 "$node_(428) setdest 106669 10610 19.0" 
$ns at 475.24289872356394 "$node_(429) setdest 27144 5805 13.0" 
$ns at 624.8880955517182 "$node_(429) setdest 90486 4862 17.0" 
$ns at 714.11824022625 "$node_(429) setdest 110540 41950 19.0" 
$ns at 772.6413204007274 "$node_(429) setdest 121551 11251 8.0" 
$ns at 869.7453435875477 "$node_(429) setdest 58414 33231 13.0" 
$ns at 401.2239221742665 "$node_(430) setdest 39773 7162 3.0" 
$ns at 433.9072689036447 "$node_(430) setdest 81006 19806 18.0" 
$ns at 576.6940793839369 "$node_(430) setdest 70427 15827 9.0" 
$ns at 619.660032524691 "$node_(430) setdest 121765 26930 1.0" 
$ns at 655.3377745832726 "$node_(430) setdest 29471 29687 10.0" 
$ns at 746.7846040803327 "$node_(430) setdest 8288 32147 1.0" 
$ns at 779.9881772251563 "$node_(430) setdest 117109 42206 10.0" 
$ns at 898.9780846333333 "$node_(430) setdest 120122 26301 12.0" 
$ns at 409.3073474142309 "$node_(431) setdest 124780 12352 19.0" 
$ns at 519.5167499657811 "$node_(431) setdest 10371 29667 17.0" 
$ns at 688.721127478439 "$node_(431) setdest 106091 6097 9.0" 
$ns at 719.6118843957252 "$node_(431) setdest 73545 34189 10.0" 
$ns at 838.7788902503975 "$node_(431) setdest 68154 30818 7.0" 
$ns at 892.1971648687489 "$node_(431) setdest 47601 30334 17.0" 
$ns at 531.4169736998588 "$node_(432) setdest 767 28833 10.0" 
$ns at 581.3104111852982 "$node_(432) setdest 121810 28184 6.0" 
$ns at 655.7009235764851 "$node_(432) setdest 95806 18178 5.0" 
$ns at 707.1180469941629 "$node_(432) setdest 81994 5995 16.0" 
$ns at 860.9648796826332 "$node_(432) setdest 59509 31798 4.0" 
$ns at 893.3556155363389 "$node_(432) setdest 97974 10103 10.0" 
$ns at 405.4172495214716 "$node_(433) setdest 23897 33130 2.0" 
$ns at 451.2795556790819 "$node_(433) setdest 89262 31763 1.0" 
$ns at 491.1831500305249 "$node_(433) setdest 77041 33707 19.0" 
$ns at 573.5082455518182 "$node_(433) setdest 71861 4641 6.0" 
$ns at 605.9669400688018 "$node_(433) setdest 5716 10161 8.0" 
$ns at 700.1019535374102 "$node_(433) setdest 81306 16473 9.0" 
$ns at 819.4718143467221 "$node_(433) setdest 29337 5261 6.0" 
$ns at 877.6651845204626 "$node_(433) setdest 11240 15450 12.0" 
$ns at 467.43564569396585 "$node_(434) setdest 92599 22542 2.0" 
$ns at 498.3118903251827 "$node_(434) setdest 99909 36943 14.0" 
$ns at 654.4547032201589 "$node_(434) setdest 68541 13812 14.0" 
$ns at 764.1623490106809 "$node_(434) setdest 50952 20735 17.0" 
$ns at 857.5871870749891 "$node_(434) setdest 29554 11532 2.0" 
$ns at 888.3078704328353 "$node_(434) setdest 557 42639 8.0" 
$ns at 446.85620186680893 "$node_(435) setdest 110952 7169 16.0" 
$ns at 507.20841159124444 "$node_(435) setdest 47283 30631 2.0" 
$ns at 544.1077949018664 "$node_(435) setdest 127855 1030 18.0" 
$ns at 700.749489144253 "$node_(435) setdest 131516 1399 5.0" 
$ns at 744.818883171155 "$node_(435) setdest 106110 38138 9.0" 
$ns at 823.0289957291704 "$node_(435) setdest 91626 5281 17.0" 
$ns at 424.7027517967272 "$node_(436) setdest 72365 6224 10.0" 
$ns at 531.4239538936264 "$node_(436) setdest 96747 9341 6.0" 
$ns at 615.1733899366856 "$node_(436) setdest 127601 40487 10.0" 
$ns at 671.2295399924458 "$node_(436) setdest 74064 14888 2.0" 
$ns at 705.0677088227245 "$node_(436) setdest 88870 28101 9.0" 
$ns at 784.5030640952987 "$node_(436) setdest 9750 24778 13.0" 
$ns at 846.5816779398152 "$node_(436) setdest 30232 18754 13.0" 
$ns at 450.24470307499456 "$node_(437) setdest 91966 29380 6.0" 
$ns at 484.42002322420745 "$node_(437) setdest 32370 6490 16.0" 
$ns at 651.1580257927396 "$node_(437) setdest 35507 20846 11.0" 
$ns at 693.4468159161537 "$node_(437) setdest 64964 23030 1.0" 
$ns at 728.5886185570049 "$node_(437) setdest 715 39986 4.0" 
$ns at 763.7875390668336 "$node_(437) setdest 9725 38754 7.0" 
$ns at 841.215789010982 "$node_(437) setdest 94026 42349 1.0" 
$ns at 877.4205898437839 "$node_(437) setdest 112771 13981 8.0" 
$ns at 426.722496550638 "$node_(438) setdest 13102 12036 19.0" 
$ns at 576.6996775918392 "$node_(438) setdest 119874 9757 13.0" 
$ns at 656.1162816535859 "$node_(438) setdest 64209 25866 13.0" 
$ns at 708.0236428652352 "$node_(438) setdest 97684 37280 8.0" 
$ns at 748.5205656409671 "$node_(438) setdest 9907 11651 5.0" 
$ns at 786.8214581046852 "$node_(438) setdest 58255 18913 2.0" 
$ns at 834.8541051337514 "$node_(438) setdest 128377 3971 3.0" 
$ns at 886.190203312432 "$node_(438) setdest 15289 10281 15.0" 
$ns at 556.9641130790708 "$node_(439) setdest 109285 11216 15.0" 
$ns at 591.6182684225387 "$node_(439) setdest 56646 36201 1.0" 
$ns at 630.0874726228708 "$node_(439) setdest 73436 34720 7.0" 
$ns at 692.1539686314924 "$node_(439) setdest 94189 6446 5.0" 
$ns at 763.5996995076579 "$node_(439) setdest 50717 28830 1.0" 
$ns at 799.87027092508 "$node_(439) setdest 122125 18805 3.0" 
$ns at 837.7609167653264 "$node_(439) setdest 101696 14984 20.0" 
$ns at 566.7688274801448 "$node_(440) setdest 123369 16307 14.0" 
$ns at 676.5287011263867 "$node_(440) setdest 78815 23424 8.0" 
$ns at 728.5872528517345 "$node_(440) setdest 57617 24898 7.0" 
$ns at 772.3158432846739 "$node_(440) setdest 100565 32861 6.0" 
$ns at 823.6411085571717 "$node_(440) setdest 125731 15500 4.0" 
$ns at 855.2291475470876 "$node_(440) setdest 32152 22972 20.0" 
$ns at 402.3155879404118 "$node_(441) setdest 30623 22694 18.0" 
$ns at 456.3805681964235 "$node_(441) setdest 53337 11865 8.0" 
$ns at 537.8338030962169 "$node_(441) setdest 58635 42414 17.0" 
$ns at 699.7029617096638 "$node_(441) setdest 133279 44641 16.0" 
$ns at 812.0955863507646 "$node_(441) setdest 89753 24464 13.0" 
$ns at 413.5300945074729 "$node_(442) setdest 46013 22544 8.0" 
$ns at 500.26811541639483 "$node_(442) setdest 49594 43393 3.0" 
$ns at 545.0650780065705 "$node_(442) setdest 88147 13851 15.0" 
$ns at 662.6684275509415 "$node_(442) setdest 92842 29854 14.0" 
$ns at 756.9073421671801 "$node_(442) setdest 32015 8516 20.0" 
$ns at 812.0038018238165 "$node_(442) setdest 57695 4407 11.0" 
$ns at 855.5950500283733 "$node_(442) setdest 41127 38927 9.0" 
$ns at 892.7058457190271 "$node_(442) setdest 42722 24402 7.0" 
$ns at 413.1196166602849 "$node_(443) setdest 104933 29678 16.0" 
$ns at 492.23303361113096 "$node_(443) setdest 43209 41721 12.0" 
$ns at 565.7343855295562 "$node_(443) setdest 77399 6776 13.0" 
$ns at 703.1884804698726 "$node_(443) setdest 105748 30912 2.0" 
$ns at 749.8177327073462 "$node_(443) setdest 94162 17271 9.0" 
$ns at 805.6987448620762 "$node_(443) setdest 40155 37906 13.0" 
$ns at 841.6292731244582 "$node_(443) setdest 38836 28625 13.0" 
$ns at 428.28545149271184 "$node_(444) setdest 59386 25310 9.0" 
$ns at 486.526551827018 "$node_(444) setdest 56193 40455 3.0" 
$ns at 534.1936907738157 "$node_(444) setdest 76138 354 2.0" 
$ns at 572.4659580423368 "$node_(444) setdest 50186 27658 13.0" 
$ns at 655.5523557201561 "$node_(444) setdest 9363 39564 2.0" 
$ns at 695.6376058866092 "$node_(444) setdest 113757 29665 9.0" 
$ns at 786.1897546231053 "$node_(444) setdest 45487 11446 4.0" 
$ns at 819.214807879807 "$node_(444) setdest 115702 34766 12.0" 
$ns at 859.4066027222023 "$node_(444) setdest 84416 12231 17.0" 
$ns at 460.4936265096207 "$node_(445) setdest 49180 34452 1.0" 
$ns at 495.3262468725905 "$node_(445) setdest 18973 5489 6.0" 
$ns at 556.6487882757722 "$node_(445) setdest 60860 13029 1.0" 
$ns at 588.1723014436664 "$node_(445) setdest 33229 7113 18.0" 
$ns at 624.1944787397488 "$node_(445) setdest 53984 34072 17.0" 
$ns at 773.523221131539 "$node_(445) setdest 116400 12748 18.0" 
$ns at 404.45058904061943 "$node_(446) setdest 56274 19435 17.0" 
$ns at 518.396186484522 "$node_(446) setdest 66642 26314 5.0" 
$ns at 579.5975877574746 "$node_(446) setdest 17657 30308 17.0" 
$ns at 621.3130446378717 "$node_(446) setdest 104338 18100 3.0" 
$ns at 652.9082381935509 "$node_(446) setdest 39025 33539 11.0" 
$ns at 696.3289788758883 "$node_(446) setdest 131619 3441 3.0" 
$ns at 740.6924148865936 "$node_(446) setdest 61429 32394 2.0" 
$ns at 783.1879675306562 "$node_(446) setdest 68104 42775 16.0" 
$ns at 557.1255867054663 "$node_(447) setdest 114294 35444 18.0" 
$ns at 593.2709076741606 "$node_(447) setdest 1518 42048 12.0" 
$ns at 737.0054699978477 "$node_(447) setdest 29513 27553 9.0" 
$ns at 826.5157385465961 "$node_(447) setdest 29755 22449 5.0" 
$ns at 859.4777688553887 "$node_(447) setdest 102491 35393 13.0" 
$ns at 438.62372956606407 "$node_(448) setdest 83261 33901 11.0" 
$ns at 519.1217935554797 "$node_(448) setdest 38406 37056 6.0" 
$ns at 577.9499593163629 "$node_(448) setdest 70029 30178 1.0" 
$ns at 611.7318879659389 "$node_(448) setdest 62396 10433 15.0" 
$ns at 690.7050658170173 "$node_(448) setdest 106233 4967 6.0" 
$ns at 773.1179356445717 "$node_(448) setdest 81920 32807 15.0" 
$ns at 849.5274886813522 "$node_(448) setdest 107814 1354 3.0" 
$ns at 887.2518285492079 "$node_(448) setdest 73177 9335 1.0" 
$ns at 441.24145381513904 "$node_(449) setdest 65848 32249 2.0" 
$ns at 475.36014504831064 "$node_(449) setdest 4648 22812 19.0" 
$ns at 687.230311067472 "$node_(449) setdest 60842 22471 19.0" 
$ns at 855.5100077414502 "$node_(449) setdest 30228 14550 17.0" 
$ns at 420.0809039754622 "$node_(450) setdest 11123 32291 4.0" 
$ns at 483.89433750890294 "$node_(450) setdest 55365 30 17.0" 
$ns at 647.1065822737501 "$node_(450) setdest 92642 1513 15.0" 
$ns at 712.6211203780026 "$node_(450) setdest 28884 9713 15.0" 
$ns at 829.6931159811545 "$node_(450) setdest 114836 19176 9.0" 
$ns at 441.39098518022433 "$node_(451) setdest 105439 36357 15.0" 
$ns at 525.5482142863826 "$node_(451) setdest 57453 38929 1.0" 
$ns at 559.4345456119669 "$node_(451) setdest 45113 37986 3.0" 
$ns at 603.7646117871673 "$node_(451) setdest 91075 25949 14.0" 
$ns at 638.6049652595588 "$node_(451) setdest 42159 31901 10.0" 
$ns at 756.779328648196 "$node_(451) setdest 71926 12972 8.0" 
$ns at 804.3065118022024 "$node_(451) setdest 69074 13147 6.0" 
$ns at 839.0942055816984 "$node_(451) setdest 109928 28596 10.0" 
$ns at 416.93574279261856 "$node_(452) setdest 4044 27586 12.0" 
$ns at 474.8675486655809 "$node_(452) setdest 9869 43680 6.0" 
$ns at 552.3866435202605 "$node_(452) setdest 25900 13227 6.0" 
$ns at 620.7636784103508 "$node_(452) setdest 55751 10482 3.0" 
$ns at 661.509883586497 "$node_(452) setdest 39192 846 20.0" 
$ns at 752.5136895215546 "$node_(452) setdest 132368 1403 2.0" 
$ns at 800.943709819812 "$node_(452) setdest 124420 9972 14.0" 
$ns at 878.1159972529206 "$node_(452) setdest 68022 11989 6.0" 
$ns at 509.3174779807773 "$node_(453) setdest 5088 30309 19.0" 
$ns at 608.1404423216226 "$node_(453) setdest 104808 38744 1.0" 
$ns at 645.1101846681387 "$node_(453) setdest 107149 1013 17.0" 
$ns at 713.6037159479033 "$node_(453) setdest 110373 34650 2.0" 
$ns at 743.6076494445329 "$node_(453) setdest 21657 39245 6.0" 
$ns at 818.8433064794895 "$node_(453) setdest 79750 29209 9.0" 
$ns at 899.7285358608655 "$node_(453) setdest 88057 26295 15.0" 
$ns at 445.95998395725707 "$node_(454) setdest 82866 23347 1.0" 
$ns at 483.6809296560469 "$node_(454) setdest 50977 29992 15.0" 
$ns at 654.081223007498 "$node_(454) setdest 64014 8239 12.0" 
$ns at 757.7977600815268 "$node_(454) setdest 56130 18861 4.0" 
$ns at 801.4167138007907 "$node_(454) setdest 12100 29963 3.0" 
$ns at 853.541733575665 "$node_(454) setdest 15706 31561 6.0" 
$ns at 892.6394685421826 "$node_(454) setdest 94054 35496 8.0" 
$ns at 413.95940691499743 "$node_(455) setdest 20861 44632 15.0" 
$ns at 538.243221535131 "$node_(455) setdest 119588 7692 5.0" 
$ns at 618.1620233666638 "$node_(455) setdest 106379 26002 7.0" 
$ns at 714.3443365640145 "$node_(455) setdest 117129 13342 17.0" 
$ns at 466.85056009645467 "$node_(456) setdest 78214 19339 18.0" 
$ns at 500.5741483232456 "$node_(456) setdest 128458 30030 14.0" 
$ns at 540.5797354905036 "$node_(456) setdest 41928 15469 11.0" 
$ns at 675.0982838499295 "$node_(456) setdest 80116 41964 4.0" 
$ns at 739.8904103112748 "$node_(456) setdest 104596 26167 9.0" 
$ns at 798.7533337624048 "$node_(456) setdest 79700 20664 8.0" 
$ns at 415.5557187567099 "$node_(457) setdest 129002 43415 10.0" 
$ns at 508.38307121542914 "$node_(457) setdest 64206 40656 4.0" 
$ns at 572.0830382792366 "$node_(457) setdest 113924 42870 2.0" 
$ns at 615.7159016537515 "$node_(457) setdest 27845 21809 2.0" 
$ns at 658.1177072506366 "$node_(457) setdest 92392 30938 18.0" 
$ns at 801.9475844151168 "$node_(457) setdest 54496 9206 1.0" 
$ns at 834.2081287660958 "$node_(457) setdest 110152 37257 7.0" 
$ns at 408.62417273122657 "$node_(458) setdest 5162 17242 15.0" 
$ns at 474.08060770222176 "$node_(458) setdest 65363 3795 17.0" 
$ns at 654.1293213181434 "$node_(458) setdest 67900 20127 20.0" 
$ns at 831.388097332353 "$node_(458) setdest 108656 34105 4.0" 
$ns at 884.6005196042993 "$node_(458) setdest 44296 4925 11.0" 
$ns at 463.0282219556593 "$node_(459) setdest 18775 12300 14.0" 
$ns at 623.0051492646635 "$node_(459) setdest 30341 4939 5.0" 
$ns at 686.0294215333282 "$node_(459) setdest 91418 32548 12.0" 
$ns at 827.6734149717065 "$node_(459) setdest 43371 29974 3.0" 
$ns at 863.2649535630574 "$node_(459) setdest 11154 41896 6.0" 
$ns at 422.5445371561544 "$node_(460) setdest 82282 8757 18.0" 
$ns at 622.2572748323049 "$node_(460) setdest 18931 26178 16.0" 
$ns at 727.7339812041554 "$node_(460) setdest 1690 14455 17.0" 
$ns at 839.1183289656849 "$node_(460) setdest 107448 11781 11.0" 
$ns at 497.0050250387526 "$node_(461) setdest 93952 41314 13.0" 
$ns at 527.3431547962954 "$node_(461) setdest 13566 25903 4.0" 
$ns at 586.9789490753061 "$node_(461) setdest 127373 17184 4.0" 
$ns at 654.2503858781807 "$node_(461) setdest 116354 3838 15.0" 
$ns at 802.5126118122458 "$node_(461) setdest 83930 7767 19.0" 
$ns at 557.4264382275677 "$node_(462) setdest 5254 27747 20.0" 
$ns at 774.5150414352094 "$node_(462) setdest 84265 41361 17.0" 
$ns at 899.9867375436221 "$node_(462) setdest 122033 38477 19.0" 
$ns at 433.6848064887084 "$node_(463) setdest 27628 3913 1.0" 
$ns at 465.1842163341416 "$node_(463) setdest 76532 22583 13.0" 
$ns at 526.204560034086 "$node_(463) setdest 124167 14966 19.0" 
$ns at 731.2080776237169 "$node_(463) setdest 22775 10622 18.0" 
$ns at 801.2876691266952 "$node_(463) setdest 96276 35797 3.0" 
$ns at 857.8605330040618 "$node_(463) setdest 103550 1336 16.0" 
$ns at 409.23581546036274 "$node_(464) setdest 12428 21693 2.0" 
$ns at 456.8172844310949 "$node_(464) setdest 70664 3530 2.0" 
$ns at 495.2133289311208 "$node_(464) setdest 77541 23296 6.0" 
$ns at 557.7185624951823 "$node_(464) setdest 132189 44456 20.0" 
$ns at 607.8937982133955 "$node_(464) setdest 44633 43945 14.0" 
$ns at 759.446735092686 "$node_(464) setdest 30500 6559 17.0" 
$ns at 861.6161249872847 "$node_(464) setdest 14237 2911 3.0" 
$ns at 497.02306477759976 "$node_(465) setdest 32669 31448 6.0" 
$ns at 536.7421525561881 "$node_(465) setdest 91574 13436 19.0" 
$ns at 710.4550548112018 "$node_(465) setdest 83835 30303 14.0" 
$ns at 825.4579597496707 "$node_(465) setdest 81770 43109 16.0" 
$ns at 880.7909708315519 "$node_(465) setdest 8310 4222 18.0" 
$ns at 437.8357338876357 "$node_(466) setdest 53300 6414 10.0" 
$ns at 539.736693184276 "$node_(466) setdest 65119 1627 4.0" 
$ns at 585.5598092330756 "$node_(466) setdest 56580 447 16.0" 
$ns at 671.0178701381826 "$node_(466) setdest 36062 2748 10.0" 
$ns at 733.8386315959766 "$node_(466) setdest 74937 15680 15.0" 
$ns at 884.8331969232345 "$node_(466) setdest 14734 39169 14.0" 
$ns at 526.8188903615419 "$node_(467) setdest 1067 41368 9.0" 
$ns at 602.8857103230306 "$node_(467) setdest 106172 17927 12.0" 
$ns at 703.8311044620186 "$node_(467) setdest 46092 16033 10.0" 
$ns at 755.0636696666351 "$node_(467) setdest 128757 21723 4.0" 
$ns at 814.7437510728744 "$node_(467) setdest 55561 16124 6.0" 
$ns at 878.8106039471452 "$node_(467) setdest 71295 43708 6.0" 
$ns at 480.06736093459364 "$node_(468) setdest 76648 17633 1.0" 
$ns at 510.8975064821986 "$node_(468) setdest 72087 12524 12.0" 
$ns at 654.3558693449479 "$node_(468) setdest 92999 37634 12.0" 
$ns at 720.8570520438701 "$node_(468) setdest 74009 41223 7.0" 
$ns at 770.4032784479047 "$node_(468) setdest 113484 30107 1.0" 
$ns at 806.0550881998448 "$node_(468) setdest 19354 18004 7.0" 
$ns at 846.3463384820346 "$node_(468) setdest 20080 19784 3.0" 
$ns at 886.4427922476791 "$node_(468) setdest 67324 1523 9.0" 
$ns at 410.3192233045858 "$node_(469) setdest 113711 30370 6.0" 
$ns at 450.79531933063345 "$node_(469) setdest 8669 21434 1.0" 
$ns at 485.3405855188058 "$node_(469) setdest 75756 34744 2.0" 
$ns at 530.5342787077581 "$node_(469) setdest 58276 307 11.0" 
$ns at 596.2441487591042 "$node_(469) setdest 64508 20223 11.0" 
$ns at 713.3243519722946 "$node_(469) setdest 52368 8098 1.0" 
$ns at 749.1123794126718 "$node_(469) setdest 104875 10324 9.0" 
$ns at 855.5788086096118 "$node_(469) setdest 129934 27476 7.0" 
$ns at 435.6177430703717 "$node_(470) setdest 34696 23366 5.0" 
$ns at 488.18700639345593 "$node_(470) setdest 117443 2215 5.0" 
$ns at 556.4213921028961 "$node_(470) setdest 72094 32293 6.0" 
$ns at 618.9148489326315 "$node_(470) setdest 122390 24570 11.0" 
$ns at 683.1545644923372 "$node_(470) setdest 133590 26251 8.0" 
$ns at 718.1471724755354 "$node_(470) setdest 51265 15133 17.0" 
$ns at 511.25860529246495 "$node_(471) setdest 117675 25393 2.0" 
$ns at 551.392344090014 "$node_(471) setdest 9538 24627 2.0" 
$ns at 593.2027998426294 "$node_(471) setdest 77856 9942 12.0" 
$ns at 641.6386747912127 "$node_(471) setdest 66476 14938 10.0" 
$ns at 682.4575330121886 "$node_(471) setdest 59632 24606 13.0" 
$ns at 840.1300173487707 "$node_(471) setdest 95441 15063 6.0" 
$ns at 886.4932884831909 "$node_(471) setdest 116282 34133 11.0" 
$ns at 458.4623316378662 "$node_(472) setdest 90673 29470 19.0" 
$ns at 520.4911853108067 "$node_(472) setdest 636 24015 19.0" 
$ns at 646.6891845639719 "$node_(472) setdest 85693 7476 16.0" 
$ns at 748.7042337346329 "$node_(472) setdest 8813 5841 6.0" 
$ns at 781.3823987632879 "$node_(472) setdest 87936 35458 10.0" 
$ns at 828.2679891590333 "$node_(472) setdest 114328 39622 10.0" 
$ns at 533.379386742562 "$node_(473) setdest 91908 9753 6.0" 
$ns at 597.7552972116741 "$node_(473) setdest 73227 24281 15.0" 
$ns at 631.98018766515 "$node_(473) setdest 63815 18835 8.0" 
$ns at 692.1046749459564 "$node_(473) setdest 94429 43580 1.0" 
$ns at 722.9441219657286 "$node_(473) setdest 33801 42985 4.0" 
$ns at 781.3114479559313 "$node_(473) setdest 124850 23994 9.0" 
$ns at 864.6814578471805 "$node_(473) setdest 14845 1911 12.0" 
$ns at 479.7769501066784 "$node_(474) setdest 98641 11588 11.0" 
$ns at 545.8757202117724 "$node_(474) setdest 102932 1660 1.0" 
$ns at 584.6033461976881 "$node_(474) setdest 102518 23019 18.0" 
$ns at 687.97619563755 "$node_(474) setdest 124132 42429 18.0" 
$ns at 722.2171983631401 "$node_(474) setdest 115584 34006 1.0" 
$ns at 756.3251602954958 "$node_(474) setdest 104880 25974 3.0" 
$ns at 815.8167827971652 "$node_(474) setdest 5755 44347 13.0" 
$ns at 400.3412996568627 "$node_(475) setdest 104920 5443 11.0" 
$ns at 510.12556729391775 "$node_(475) setdest 104991 1273 6.0" 
$ns at 589.4018909967007 "$node_(475) setdest 126562 7260 4.0" 
$ns at 629.5533230642756 "$node_(475) setdest 117312 26362 18.0" 
$ns at 703.362801487089 "$node_(475) setdest 60936 10446 19.0" 
$ns at 867.8723859264508 "$node_(475) setdest 35553 29936 10.0" 
$ns at 423.1838549449601 "$node_(476) setdest 47268 42589 3.0" 
$ns at 461.8086520985467 "$node_(476) setdest 110489 27170 9.0" 
$ns at 576.3621843343625 "$node_(476) setdest 94320 41102 15.0" 
$ns at 690.0651094792395 "$node_(476) setdest 83859 26391 7.0" 
$ns at 762.4526340819739 "$node_(476) setdest 36754 22484 5.0" 
$ns at 808.6525864690908 "$node_(476) setdest 60640 12101 17.0" 
$ns at 848.5243095021946 "$node_(476) setdest 33621 40274 14.0" 
$ns at 547.636930936536 "$node_(477) setdest 45824 9937 5.0" 
$ns at 588.5366900070748 "$node_(477) setdest 57053 5111 9.0" 
$ns at 656.7196949741907 "$node_(477) setdest 89445 24409 17.0" 
$ns at 798.878996830774 "$node_(477) setdest 4767 31932 17.0" 
$ns at 829.0231855320774 "$node_(477) setdest 24227 36279 13.0" 
$ns at 584.5795777821209 "$node_(478) setdest 54100 24837 3.0" 
$ns at 643.7374209735902 "$node_(478) setdest 38342 12675 17.0" 
$ns at 745.8692323938125 "$node_(478) setdest 16594 4154 12.0" 
$ns at 815.1629495584392 "$node_(478) setdest 1991 31928 12.0" 
$ns at 894.3889974086991 "$node_(478) setdest 35107 38016 11.0" 
$ns at 486.7760880345595 "$node_(479) setdest 46826 38520 17.0" 
$ns at 644.8965826764752 "$node_(479) setdest 24602 10276 12.0" 
$ns at 781.2099398520745 "$node_(479) setdest 55394 27405 13.0" 
$ns at 885.5772473009939 "$node_(479) setdest 24230 18221 14.0" 
$ns at 530.7881864540624 "$node_(480) setdest 95601 1687 17.0" 
$ns at 710.1532751131864 "$node_(480) setdest 28000 34720 15.0" 
$ns at 778.6583790029717 "$node_(480) setdest 122368 11719 2.0" 
$ns at 814.0802697885692 "$node_(480) setdest 68606 33114 15.0" 
$ns at 445.99918086578936 "$node_(481) setdest 127585 691 11.0" 
$ns at 546.5900750793245 "$node_(481) setdest 62878 27228 11.0" 
$ns at 586.6704583671733 "$node_(481) setdest 18391 12757 8.0" 
$ns at 634.0991215990509 "$node_(481) setdest 2513 15072 10.0" 
$ns at 681.3538442087988 "$node_(481) setdest 22835 29315 2.0" 
$ns at 725.595408905347 "$node_(481) setdest 6867 12587 19.0" 
$ns at 777.818992383058 "$node_(481) setdest 9489 22490 2.0" 
$ns at 811.8282636216554 "$node_(481) setdest 57448 25331 12.0" 
$ns at 885.6231302073581 "$node_(481) setdest 46834 23189 4.0" 
$ns at 500.5252270392826 "$node_(482) setdest 115320 38997 3.0" 
$ns at 558.1179498734767 "$node_(482) setdest 16387 25848 13.0" 
$ns at 596.2916650078087 "$node_(482) setdest 17865 34468 9.0" 
$ns at 640.13298218869 "$node_(482) setdest 28372 40205 9.0" 
$ns at 727.6278072304661 "$node_(482) setdest 77877 16376 1.0" 
$ns at 763.4974331551492 "$node_(482) setdest 133618 11295 4.0" 
$ns at 807.8654833301407 "$node_(482) setdest 83049 7426 4.0" 
$ns at 862.3173177101869 "$node_(482) setdest 16094 10722 5.0" 
$ns at 406.25282140063587 "$node_(483) setdest 131732 39103 19.0" 
$ns at 490.3711274112816 "$node_(483) setdest 7902 5065 16.0" 
$ns at 594.5486661405884 "$node_(483) setdest 96755 10224 6.0" 
$ns at 657.9581069434549 "$node_(483) setdest 19902 4523 5.0" 
$ns at 715.5751095923491 "$node_(483) setdest 62631 12320 7.0" 
$ns at 805.8808225279319 "$node_(483) setdest 93300 22324 11.0" 
$ns at 850.7726501741647 "$node_(483) setdest 116501 48 18.0" 
$ns at 416.7888536054025 "$node_(484) setdest 30052 12208 7.0" 
$ns at 482.09062797018186 "$node_(484) setdest 8954 33687 15.0" 
$ns at 636.5890362311696 "$node_(484) setdest 101579 22172 13.0" 
$ns at 789.9140060992465 "$node_(484) setdest 104283 21255 2.0" 
$ns at 825.3499272771844 "$node_(484) setdest 24525 8922 7.0" 
$ns at 512.3452565001044 "$node_(485) setdest 98908 13449 11.0" 
$ns at 601.104494132218 "$node_(485) setdest 35662 6414 17.0" 
$ns at 782.9649014966833 "$node_(485) setdest 117825 9797 10.0" 
$ns at 850.0774369298729 "$node_(485) setdest 107791 16591 5.0" 
$ns at 880.6590214987293 "$node_(485) setdest 69782 39624 18.0" 
$ns at 450.8207435975992 "$node_(486) setdest 38889 43021 6.0" 
$ns at 507.3639794606469 "$node_(486) setdest 29398 38406 18.0" 
$ns at 538.1282647473873 "$node_(486) setdest 50123 22094 11.0" 
$ns at 568.8305514962057 "$node_(486) setdest 10847 15345 5.0" 
$ns at 608.5358081081127 "$node_(486) setdest 930 19207 4.0" 
$ns at 641.4241603760604 "$node_(486) setdest 6730 24497 1.0" 
$ns at 676.9957725546844 "$node_(486) setdest 40734 38303 16.0" 
$ns at 738.4264534359606 "$node_(486) setdest 74678 32164 18.0" 
$ns at 899.2343578945362 "$node_(486) setdest 100307 5485 14.0" 
$ns at 449.3609608043356 "$node_(487) setdest 67362 14626 5.0" 
$ns at 495.8396686337334 "$node_(487) setdest 66731 10294 3.0" 
$ns at 527.2693445103259 "$node_(487) setdest 65178 14654 19.0" 
$ns at 654.1355707174865 "$node_(487) setdest 93238 2802 15.0" 
$ns at 734.6076727992422 "$node_(487) setdest 37433 18725 15.0" 
$ns at 806.8801023980749 "$node_(487) setdest 35805 42595 14.0" 
$ns at 839.0306983030903 "$node_(487) setdest 51513 18776 2.0" 
$ns at 882.0009644191176 "$node_(487) setdest 20983 40924 8.0" 
$ns at 441.96581370936036 "$node_(488) setdest 20498 32560 4.0" 
$ns at 484.3443604340088 "$node_(488) setdest 69426 44479 4.0" 
$ns at 520.7010888837684 "$node_(488) setdest 114191 31559 12.0" 
$ns at 579.0185308757531 "$node_(488) setdest 6896 43752 20.0" 
$ns at 795.404766977468 "$node_(488) setdest 111125 9614 8.0" 
$ns at 840.2590534408923 "$node_(488) setdest 120476 6817 19.0" 
$ns at 871.3524832240586 "$node_(488) setdest 11871 30336 6.0" 
$ns at 461.70175409666706 "$node_(489) setdest 38269 17292 6.0" 
$ns at 549.1806205812087 "$node_(489) setdest 94521 43926 15.0" 
$ns at 671.3280125113367 "$node_(489) setdest 124967 15899 16.0" 
$ns at 763.6785281256739 "$node_(489) setdest 37266 33565 6.0" 
$ns at 801.2894102762251 "$node_(489) setdest 53871 41228 15.0" 
$ns at 855.975618338459 "$node_(489) setdest 87341 38072 17.0" 
$ns at 895.5000579618243 "$node_(489) setdest 45140 29587 4.0" 
$ns at 424.828761720121 "$node_(490) setdest 116678 2728 11.0" 
$ns at 564.0668609302079 "$node_(490) setdest 17374 24462 2.0" 
$ns at 594.4609390374378 "$node_(490) setdest 47840 16904 20.0" 
$ns at 793.9687100781657 "$node_(490) setdest 33482 20848 16.0" 
$ns at 555.2958394243599 "$node_(491) setdest 5273 25350 10.0" 
$ns at 647.8837605295396 "$node_(491) setdest 102738 14522 7.0" 
$ns at 689.6620113487016 "$node_(491) setdest 42728 9353 9.0" 
$ns at 803.2282530536577 "$node_(491) setdest 35716 43428 2.0" 
$ns at 840.211403347014 "$node_(491) setdest 59687 22891 17.0" 
$ns at 883.2726548043572 "$node_(491) setdest 20414 44296 19.0" 
$ns at 515.6870056307603 "$node_(492) setdest 43682 1993 13.0" 
$ns at 603.1450321978691 "$node_(492) setdest 125731 37297 16.0" 
$ns at 718.1564982785123 "$node_(492) setdest 59963 11599 18.0" 
$ns at 873.1092634120695 "$node_(492) setdest 17215 27326 11.0" 
$ns at 434.8204454105208 "$node_(493) setdest 17392 23019 8.0" 
$ns at 518.8736509540115 "$node_(493) setdest 113654 7773 8.0" 
$ns at 597.4629249416182 "$node_(493) setdest 105497 27506 9.0" 
$ns at 648.2111639075295 "$node_(493) setdest 39567 1631 4.0" 
$ns at 700.4098154963774 "$node_(493) setdest 40111 12503 18.0" 
$ns at 807.7463648064837 "$node_(493) setdest 14954 33421 1.0" 
$ns at 845.4318553546952 "$node_(493) setdest 9560 44598 17.0" 
$ns at 529.6845437032944 "$node_(494) setdest 110195 44230 10.0" 
$ns at 562.3761589313344 "$node_(494) setdest 56094 10486 7.0" 
$ns at 623.3970132278442 "$node_(494) setdest 117330 14460 2.0" 
$ns at 655.9586410779012 "$node_(494) setdest 121382 43379 10.0" 
$ns at 686.9216581181264 "$node_(494) setdest 68043 36617 17.0" 
$ns at 875.0340055355687 "$node_(494) setdest 41098 24655 18.0" 
$ns at 411.2724685368218 "$node_(495) setdest 40232 15931 14.0" 
$ns at 558.2833945045099 "$node_(495) setdest 130887 38488 3.0" 
$ns at 613.4408976423342 "$node_(495) setdest 45379 18159 6.0" 
$ns at 653.2987753441502 "$node_(495) setdest 89275 3639 13.0" 
$ns at 789.2069645668148 "$node_(495) setdest 44831 44000 15.0" 
$ns at 531.9703493582488 "$node_(496) setdest 128670 18505 6.0" 
$ns at 600.4171490339589 "$node_(496) setdest 51368 20217 12.0" 
$ns at 692.118190593066 "$node_(496) setdest 54705 16196 8.0" 
$ns at 730.3981036194255 "$node_(496) setdest 6341 4793 8.0" 
$ns at 809.985855150876 "$node_(496) setdest 15818 29519 11.0" 
$ns at 450.59076312820935 "$node_(497) setdest 65588 30891 18.0" 
$ns at 590.8046652532219 "$node_(497) setdest 72227 44186 18.0" 
$ns at 778.9890458619245 "$node_(497) setdest 21248 22166 12.0" 
$ns at 818.830674989583 "$node_(497) setdest 79963 9704 18.0" 
$ns at 543.893327459376 "$node_(498) setdest 124598 24311 6.0" 
$ns at 606.4952762227032 "$node_(498) setdest 111394 19680 2.0" 
$ns at 651.1827110040082 "$node_(498) setdest 25108 2476 19.0" 
$ns at 686.9257399926993 "$node_(498) setdest 79786 7008 14.0" 
$ns at 747.1901740575436 "$node_(498) setdest 111128 36484 8.0" 
$ns at 853.297092806845 "$node_(498) setdest 129142 28878 8.0" 
$ns at 507.3420455479778 "$node_(499) setdest 7028 32183 5.0" 
$ns at 581.8149347096411 "$node_(499) setdest 39272 3815 9.0" 
$ns at 627.4040336210278 "$node_(499) setdest 110459 43810 15.0" 
$ns at 726.8023384163248 "$node_(499) setdest 1407 43325 11.0" 
$ns at 850.8988244485989 "$node_(499) setdest 44645 1898 15.0" 
$ns at 643.7928090182619 "$node_(500) setdest 20254 1920 18.0" 
$ns at 845.0486936887245 "$node_(500) setdest 46987 29480 9.0" 
$ns at 534.6471957303429 "$node_(501) setdest 45765 17996 10.0" 
$ns at 636.3759611334385 "$node_(501) setdest 78902 32754 12.0" 
$ns at 735.2198450680942 "$node_(501) setdest 61617 13916 4.0" 
$ns at 785.5262420054411 "$node_(501) setdest 80545 28845 18.0" 
$ns at 830.2919575205519 "$node_(501) setdest 125911 24320 2.0" 
$ns at 878.8841047748692 "$node_(501) setdest 50352 26652 16.0" 
$ns at 577.5539523427566 "$node_(502) setdest 25387 14426 18.0" 
$ns at 654.5990390910966 "$node_(502) setdest 88723 8332 15.0" 
$ns at 689.5582624936534 "$node_(502) setdest 99526 28398 2.0" 
$ns at 722.7675557027355 "$node_(502) setdest 69198 18174 17.0" 
$ns at 770.5626382882288 "$node_(502) setdest 73515 17353 7.0" 
$ns at 809.7939302597787 "$node_(502) setdest 87314 16296 3.0" 
$ns at 857.6348731922218 "$node_(502) setdest 97050 10442 5.0" 
$ns at 897.7494245549424 "$node_(502) setdest 49474 44201 15.0" 
$ns at 611.8156914976058 "$node_(503) setdest 118912 2050 13.0" 
$ns at 771.7434454398146 "$node_(503) setdest 119216 19794 10.0" 
$ns at 858.569383402018 "$node_(503) setdest 96645 16860 11.0" 
$ns at 561.5003300477008 "$node_(504) setdest 94459 20958 11.0" 
$ns at 661.156468403876 "$node_(504) setdest 13055 44458 1.0" 
$ns at 698.1440674963064 "$node_(504) setdest 99608 10651 17.0" 
$ns at 820.631870134729 "$node_(504) setdest 53632 43154 8.0" 
$ns at 873.7350628460146 "$node_(504) setdest 67439 28875 15.0" 
$ns at 516.1281959121347 "$node_(505) setdest 45711 26565 19.0" 
$ns at 588.7115006971408 "$node_(505) setdest 59377 33830 17.0" 
$ns at 745.362203352175 "$node_(505) setdest 97928 16083 10.0" 
$ns at 808.2872927058374 "$node_(505) setdest 47387 10360 16.0" 
$ns at 550.9194863702411 "$node_(506) setdest 69424 29135 18.0" 
$ns at 617.0336125979129 "$node_(506) setdest 68740 43306 2.0" 
$ns at 661.450070450303 "$node_(506) setdest 45156 19223 6.0" 
$ns at 732.9461592519758 "$node_(506) setdest 46786 39469 20.0" 
$ns at 886.3591606932637 "$node_(506) setdest 45145 5451 17.0" 
$ns at 597.0244226235909 "$node_(507) setdest 13351 22260 17.0" 
$ns at 712.7520363263312 "$node_(507) setdest 67852 43080 1.0" 
$ns at 742.8424847217649 "$node_(507) setdest 56666 18027 7.0" 
$ns at 817.2058717310736 "$node_(507) setdest 69244 3945 15.0" 
$ns at 883.8209022235446 "$node_(507) setdest 97793 15688 3.0" 
$ns at 524.0073989576806 "$node_(508) setdest 49411 20927 2.0" 
$ns at 564.2541152642261 "$node_(508) setdest 72978 21041 16.0" 
$ns at 665.1321313262347 "$node_(508) setdest 31525 38910 3.0" 
$ns at 723.9238020023349 "$node_(508) setdest 62192 11446 12.0" 
$ns at 829.9518496991923 "$node_(508) setdest 16225 4846 9.0" 
$ns at 530.416459495011 "$node_(509) setdest 34438 11380 17.0" 
$ns at 672.030976014418 "$node_(509) setdest 124911 3467 9.0" 
$ns at 719.9569206353356 "$node_(509) setdest 83893 15737 19.0" 
$ns at 878.6379748804104 "$node_(509) setdest 76132 1355 3.0" 
$ns at 524.6564024348784 "$node_(510) setdest 21552 31732 3.0" 
$ns at 562.7393576431975 "$node_(510) setdest 98668 25376 1.0" 
$ns at 599.9151889650113 "$node_(510) setdest 95201 7490 4.0" 
$ns at 637.8030532191084 "$node_(510) setdest 2530 13684 20.0" 
$ns at 822.0925034740394 "$node_(510) setdest 7340 34792 8.0" 
$ns at 863.2279126510861 "$node_(510) setdest 4723 4960 7.0" 
$ns at 534.1298098497946 "$node_(511) setdest 21197 21687 18.0" 
$ns at 621.0981929664571 "$node_(511) setdest 97772 34702 13.0" 
$ns at 684.6090553774654 "$node_(511) setdest 71000 3394 12.0" 
$ns at 743.6102333544734 "$node_(511) setdest 95581 29205 14.0" 
$ns at 807.8369807628183 "$node_(511) setdest 90102 16000 2.0" 
$ns at 841.9664306958127 "$node_(511) setdest 100483 15108 7.0" 
$ns at 579.0343549967316 "$node_(512) setdest 130782 4759 16.0" 
$ns at 627.5446898872551 "$node_(512) setdest 88888 7322 14.0" 
$ns at 765.4022471280568 "$node_(512) setdest 78421 17947 3.0" 
$ns at 816.8899229097602 "$node_(512) setdest 21579 33036 5.0" 
$ns at 880.0917782719515 "$node_(512) setdest 63007 25148 4.0" 
$ns at 536.9491326215617 "$node_(513) setdest 95733 43478 16.0" 
$ns at 718.9167273967954 "$node_(513) setdest 31031 35282 3.0" 
$ns at 764.1156536829861 "$node_(513) setdest 18699 16373 15.0" 
$ns at 848.944881508338 "$node_(513) setdest 110278 8945 7.0" 
$ns at 539.9386199925544 "$node_(514) setdest 73045 18523 16.0" 
$ns at 702.0046228248013 "$node_(514) setdest 8912 11699 19.0" 
$ns at 753.6953958438993 "$node_(514) setdest 34238 22231 13.0" 
$ns at 797.2246975765725 "$node_(514) setdest 34161 20783 19.0" 
$ns at 572.644021264631 "$node_(515) setdest 14674 6626 3.0" 
$ns at 607.13725803353 "$node_(515) setdest 63038 8588 15.0" 
$ns at 786.808287619785 "$node_(515) setdest 17042 12396 5.0" 
$ns at 845.445786394491 "$node_(515) setdest 58436 42292 18.0" 
$ns at 570.3375234397058 "$node_(516) setdest 73126 28845 15.0" 
$ns at 616.1115628363901 "$node_(516) setdest 27553 23463 6.0" 
$ns at 677.8256301769525 "$node_(516) setdest 35100 20594 18.0" 
$ns at 834.5300456541881 "$node_(516) setdest 131852 28325 6.0" 
$ns at 560.1889842458661 "$node_(517) setdest 12127 16553 13.0" 
$ns at 707.0026582104697 "$node_(517) setdest 33001 18070 16.0" 
$ns at 870.1768206753999 "$node_(517) setdest 50492 19128 11.0" 
$ns at 529.5432270821112 "$node_(518) setdest 97444 14095 10.0" 
$ns at 613.6372254180876 "$node_(518) setdest 21408 16748 19.0" 
$ns at 769.7556041576589 "$node_(518) setdest 106831 26108 16.0" 
$ns at 869.0644583615716 "$node_(518) setdest 25329 25010 7.0" 
$ns at 525.5023879586315 "$node_(519) setdest 113143 21719 19.0" 
$ns at 585.3558498117152 "$node_(519) setdest 132529 25449 4.0" 
$ns at 622.6561804691652 "$node_(519) setdest 14749 28426 7.0" 
$ns at 712.6956535697518 "$node_(519) setdest 75240 33086 2.0" 
$ns at 761.6156788090128 "$node_(519) setdest 75515 40927 7.0" 
$ns at 835.7618122971834 "$node_(519) setdest 36018 35748 1.0" 
$ns at 871.9850368731203 "$node_(519) setdest 119671 44336 14.0" 
$ns at 532.3284417231754 "$node_(520) setdest 82773 40855 3.0" 
$ns at 575.0867200354445 "$node_(520) setdest 88159 36450 20.0" 
$ns at 614.2792142762788 "$node_(520) setdest 67982 20912 4.0" 
$ns at 674.8110472425119 "$node_(520) setdest 114166 1948 1.0" 
$ns at 712.6168984670005 "$node_(520) setdest 56049 16012 5.0" 
$ns at 789.302611558114 "$node_(520) setdest 81076 26327 7.0" 
$ns at 877.6784795288819 "$node_(520) setdest 130652 5842 15.0" 
$ns at 567.1847575452654 "$node_(521) setdest 71626 4255 7.0" 
$ns at 611.1893815030951 "$node_(521) setdest 47699 8237 19.0" 
$ns at 764.971461724147 "$node_(521) setdest 45731 14054 1.0" 
$ns at 799.5407946525578 "$node_(521) setdest 130920 28586 3.0" 
$ns at 838.2563749891603 "$node_(521) setdest 129374 6117 17.0" 
$ns at 509.529544564053 "$node_(522) setdest 66556 33899 19.0" 
$ns at 727.9130830834847 "$node_(522) setdest 45933 13406 15.0" 
$ns at 778.4195452767221 "$node_(522) setdest 83329 31953 12.0" 
$ns at 894.4531699431442 "$node_(522) setdest 16839 4710 6.0" 
$ns at 606.1735806792135 "$node_(523) setdest 112322 42251 7.0" 
$ns at 658.4636965272391 "$node_(523) setdest 35744 37004 18.0" 
$ns at 792.3735543699454 "$node_(523) setdest 86526 43790 12.0" 
$ns at 830.4055456784833 "$node_(523) setdest 132069 31591 15.0" 
$ns at 541.1486812422461 "$node_(524) setdest 33384 17026 14.0" 
$ns at 708.3616715188517 "$node_(524) setdest 65704 22530 7.0" 
$ns at 767.4775974854787 "$node_(524) setdest 14262 32018 13.0" 
$ns at 822.3088683946767 "$node_(524) setdest 23266 35644 16.0" 
$ns at 505.1159570759158 "$node_(525) setdest 51133 44232 18.0" 
$ns at 570.103916255038 "$node_(525) setdest 121814 12277 15.0" 
$ns at 614.0401856256173 "$node_(525) setdest 66163 10813 20.0" 
$ns at 681.657882425831 "$node_(525) setdest 123350 37402 1.0" 
$ns at 712.105707637085 "$node_(525) setdest 30379 6101 10.0" 
$ns at 826.1682135324982 "$node_(525) setdest 113007 28897 17.0" 
$ns at 533.5306457966265 "$node_(526) setdest 3068 11136 10.0" 
$ns at 576.7313807109325 "$node_(526) setdest 126658 1217 11.0" 
$ns at 673.9990394097484 "$node_(526) setdest 6355 39674 9.0" 
$ns at 775.1548447963964 "$node_(526) setdest 10148 39682 7.0" 
$ns at 862.3403139271225 "$node_(526) setdest 125628 34110 13.0" 
$ns at 543.0183159283026 "$node_(527) setdest 76445 17135 18.0" 
$ns at 585.4869598964026 "$node_(527) setdest 66976 41505 14.0" 
$ns at 639.9662543698212 "$node_(527) setdest 122080 22753 7.0" 
$ns at 678.7597555205548 "$node_(527) setdest 115208 19600 15.0" 
$ns at 733.2531027577503 "$node_(527) setdest 68099 6928 18.0" 
$ns at 891.7926057710879 "$node_(527) setdest 91594 3669 19.0" 
$ns at 520.7073863893204 "$node_(528) setdest 128171 29073 3.0" 
$ns at 553.8835463146813 "$node_(528) setdest 7836 12675 8.0" 
$ns at 599.2806162114714 "$node_(528) setdest 33307 17773 8.0" 
$ns at 656.85471505187 "$node_(528) setdest 100409 35850 15.0" 
$ns at 774.6230202938663 "$node_(528) setdest 18469 40555 3.0" 
$ns at 806.8045164701105 "$node_(528) setdest 30613 6360 16.0" 
$ns at 637.4502803128564 "$node_(529) setdest 22041 13926 14.0" 
$ns at 674.320731035347 "$node_(529) setdest 22033 29122 14.0" 
$ns at 828.7275016102615 "$node_(529) setdest 10110 4264 18.0" 
$ns at 875.6022667829966 "$node_(529) setdest 109545 16047 15.0" 
$ns at 534.9654776368093 "$node_(530) setdest 23326 16530 11.0" 
$ns at 658.5428319001413 "$node_(530) setdest 110627 39096 13.0" 
$ns at 805.1235435068545 "$node_(530) setdest 51946 8092 1.0" 
$ns at 838.712292550916 "$node_(530) setdest 98392 15898 20.0" 
$ns at 501.926683314119 "$node_(531) setdest 71507 6750 14.0" 
$ns at 583.6361004532124 "$node_(531) setdest 121693 22518 13.0" 
$ns at 652.581817395308 "$node_(531) setdest 68299 39756 9.0" 
$ns at 748.9664403961517 "$node_(531) setdest 39570 37678 8.0" 
$ns at 814.2270095048237 "$node_(531) setdest 79817 20422 4.0" 
$ns at 857.8087712073132 "$node_(531) setdest 125395 36529 9.0" 
$ns at 545.309253795107 "$node_(532) setdest 133375 42215 7.0" 
$ns at 615.4314769130835 "$node_(532) setdest 71975 1566 12.0" 
$ns at 724.6761143391506 "$node_(532) setdest 106733 9446 12.0" 
$ns at 811.7214644206177 "$node_(532) setdest 79232 32455 4.0" 
$ns at 855.0479412181414 "$node_(532) setdest 39004 12626 6.0" 
$ns at 533.3875897700132 "$node_(533) setdest 69142 20032 14.0" 
$ns at 601.1299921564932 "$node_(533) setdest 16760 42770 8.0" 
$ns at 660.3439458599031 "$node_(533) setdest 20755 3520 17.0" 
$ns at 816.0668454585631 "$node_(533) setdest 68627 1320 11.0" 
$ns at 553.3124028637574 "$node_(534) setdest 55087 14261 14.0" 
$ns at 615.3949746506479 "$node_(534) setdest 23876 1139 7.0" 
$ns at 671.5361546643675 "$node_(534) setdest 15184 22664 10.0" 
$ns at 796.3950313118904 "$node_(534) setdest 69285 44376 2.0" 
$ns at 834.4073782904155 "$node_(534) setdest 108129 6010 19.0" 
$ns at 541.754715659586 "$node_(535) setdest 112582 10203 16.0" 
$ns at 634.93331061599 "$node_(535) setdest 27785 15972 17.0" 
$ns at 781.4481384932926 "$node_(535) setdest 21194 14801 3.0" 
$ns at 831.9576646617087 "$node_(535) setdest 133507 3530 14.0" 
$ns at 529.3633048725866 "$node_(536) setdest 77798 29798 14.0" 
$ns at 568.8519746360118 "$node_(536) setdest 88604 11015 18.0" 
$ns at 599.1780578595599 "$node_(536) setdest 130149 164 6.0" 
$ns at 656.5572842664146 "$node_(536) setdest 90955 12678 10.0" 
$ns at 692.3349390553477 "$node_(536) setdest 123878 14200 9.0" 
$ns at 810.8327225887157 "$node_(536) setdest 51840 15996 16.0" 
$ns at 866.4004362586479 "$node_(536) setdest 110002 18409 17.0" 
$ns at 548.423487516997 "$node_(537) setdest 14610 26722 16.0" 
$ns at 698.03300815794 "$node_(537) setdest 109975 3694 20.0" 
$ns at 842.801625952369 "$node_(537) setdest 116987 17912 20.0" 
$ns at 520.8501927186392 "$node_(538) setdest 48582 29774 1.0" 
$ns at 560.3171288790318 "$node_(538) setdest 70471 43069 1.0" 
$ns at 591.3295729415727 "$node_(538) setdest 112261 16519 19.0" 
$ns at 695.5338234816447 "$node_(538) setdest 104377 30462 1.0" 
$ns at 728.9941860727479 "$node_(538) setdest 55935 3905 3.0" 
$ns at 784.5052074795767 "$node_(538) setdest 61460 7010 15.0" 
$ns at 556.7558074348209 "$node_(539) setdest 13426 19765 9.0" 
$ns at 670.6819272868336 "$node_(539) setdest 62447 3820 20.0" 
$ns at 729.3759773295293 "$node_(539) setdest 99987 9890 4.0" 
$ns at 776.743007982352 "$node_(539) setdest 5796 37597 6.0" 
$ns at 849.7807764228014 "$node_(539) setdest 89743 39791 16.0" 
$ns at 543.5592527577642 "$node_(540) setdest 679 21804 4.0" 
$ns at 587.5755637689426 "$node_(540) setdest 54599 16246 8.0" 
$ns at 620.2852969219579 "$node_(540) setdest 104084 27281 18.0" 
$ns at 785.1062063005211 "$node_(540) setdest 96739 3663 18.0" 
$ns at 890.8579288586645 "$node_(540) setdest 94436 28864 19.0" 
$ns at 531.0789965456531 "$node_(541) setdest 39217 5707 5.0" 
$ns at 584.5301835772702 "$node_(541) setdest 91181 39311 17.0" 
$ns at 662.7905187977055 "$node_(541) setdest 45138 4285 16.0" 
$ns at 776.566171077829 "$node_(541) setdest 71843 18347 18.0" 
$ns at 500.32199096488335 "$node_(542) setdest 11514 20043 16.0" 
$ns at 533.2352738960742 "$node_(542) setdest 60267 24190 2.0" 
$ns at 563.5216480665255 "$node_(542) setdest 10257 4671 10.0" 
$ns at 605.3587305163126 "$node_(542) setdest 46802 4066 15.0" 
$ns at 641.9825131761438 "$node_(542) setdest 19331 26413 17.0" 
$ns at 767.6512475121124 "$node_(542) setdest 63940 31935 6.0" 
$ns at 806.8419807380403 "$node_(542) setdest 57913 28964 3.0" 
$ns at 846.8091511749018 "$node_(542) setdest 26661 19324 8.0" 
$ns at 884.0528190877669 "$node_(542) setdest 123368 8186 14.0" 
$ns at 537.3518679428656 "$node_(543) setdest 116149 27223 15.0" 
$ns at 688.9115070399203 "$node_(543) setdest 105462 26563 16.0" 
$ns at 763.1891316345091 "$node_(543) setdest 89803 36097 10.0" 
$ns at 828.5257889034453 "$node_(543) setdest 98061 39370 17.0" 
$ns at 540.4032044789542 "$node_(544) setdest 75503 17520 9.0" 
$ns at 597.625635141148 "$node_(544) setdest 61632 41103 18.0" 
$ns at 665.050435022764 "$node_(544) setdest 48974 39559 1.0" 
$ns at 702.2165037949455 "$node_(544) setdest 45860 25341 10.0" 
$ns at 799.5937013593436 "$node_(544) setdest 115752 2797 5.0" 
$ns at 854.3859887117193 "$node_(544) setdest 87699 11136 15.0" 
$ns at 535.6247218726264 "$node_(545) setdest 84000 16084 14.0" 
$ns at 625.9140027635522 "$node_(545) setdest 116664 44369 9.0" 
$ns at 735.7897975426079 "$node_(545) setdest 114491 37431 12.0" 
$ns at 796.9651461883061 "$node_(545) setdest 34291 12060 4.0" 
$ns at 866.7912138299776 "$node_(545) setdest 2998 39421 5.0" 
$ns at 561.2949352095078 "$node_(546) setdest 89882 40190 7.0" 
$ns at 596.4919252218637 "$node_(546) setdest 11974 29512 19.0" 
$ns at 682.1396003712762 "$node_(546) setdest 95510 2462 16.0" 
$ns at 751.873229314556 "$node_(546) setdest 110244 6664 15.0" 
$ns at 637.5676399801246 "$node_(547) setdest 9520 26801 16.0" 
$ns at 797.9766248237881 "$node_(547) setdest 91930 30013 18.0" 
$ns at 616.1010280894837 "$node_(548) setdest 29025 1379 2.0" 
$ns at 665.0729346576 "$node_(548) setdest 109249 5536 11.0" 
$ns at 719.3585051972466 "$node_(548) setdest 98663 3678 7.0" 
$ns at 776.7207209622204 "$node_(548) setdest 13933 39072 18.0" 
$ns at 511.40136393748816 "$node_(549) setdest 93637 15111 17.0" 
$ns at 576.1031957817506 "$node_(549) setdest 2160 987 8.0" 
$ns at 662.4521993701449 "$node_(549) setdest 7614 1342 2.0" 
$ns at 709.0044902950193 "$node_(549) setdest 53810 20008 13.0" 
$ns at 846.0932825812752 "$node_(549) setdest 16430 19702 13.0" 
$ns at 509.9262608510972 "$node_(550) setdest 22322 10323 1.0" 
$ns at 545.7941859105434 "$node_(550) setdest 43879 4350 7.0" 
$ns at 600.0974721557714 "$node_(550) setdest 11730 39003 4.0" 
$ns at 665.7847792766628 "$node_(550) setdest 3723 13507 17.0" 
$ns at 734.3014449867992 "$node_(550) setdest 98599 43672 12.0" 
$ns at 869.5998643174753 "$node_(550) setdest 101507 24733 6.0" 
$ns at 555.3761366462314 "$node_(551) setdest 72550 19398 1.0" 
$ns at 589.0875850359631 "$node_(551) setdest 38597 30098 15.0" 
$ns at 620.214353030196 "$node_(551) setdest 63666 43426 7.0" 
$ns at 711.5798138812079 "$node_(551) setdest 70971 25968 4.0" 
$ns at 743.6672053483437 "$node_(551) setdest 74130 14522 17.0" 
$ns at 782.5759726905361 "$node_(551) setdest 103635 22722 1.0" 
$ns at 821.0997141082557 "$node_(551) setdest 104155 18412 19.0" 
$ns at 527.8335642174343 "$node_(552) setdest 130119 26649 10.0" 
$ns at 639.4292087035403 "$node_(552) setdest 111292 12153 19.0" 
$ns at 763.5919463108597 "$node_(552) setdest 125832 10848 13.0" 
$ns at 508.4975611251241 "$node_(553) setdest 35352 25644 6.0" 
$ns at 575.3686423394001 "$node_(553) setdest 2960 18636 18.0" 
$ns at 678.453104257835 "$node_(553) setdest 19760 13773 7.0" 
$ns at 737.0334303883332 "$node_(553) setdest 13012 7728 18.0" 
$ns at 534.7511867930405 "$node_(554) setdest 119042 17328 13.0" 
$ns at 666.0474990763059 "$node_(554) setdest 11707 9799 8.0" 
$ns at 701.9443569455891 "$node_(554) setdest 112807 2414 7.0" 
$ns at 746.327091442868 "$node_(554) setdest 94704 7696 15.0" 
$ns at 832.2080974988488 "$node_(554) setdest 121889 993 16.0" 
$ns at 516.4566294365209 "$node_(555) setdest 71529 28661 14.0" 
$ns at 589.6261123019854 "$node_(555) setdest 106582 39457 1.0" 
$ns at 628.2671184816131 "$node_(555) setdest 128622 33872 1.0" 
$ns at 658.6983138462724 "$node_(555) setdest 113890 14421 3.0" 
$ns at 706.6026459344798 "$node_(555) setdest 11768 5776 16.0" 
$ns at 881.0126973140802 "$node_(555) setdest 105352 41731 9.0" 
$ns at 613.5358562861786 "$node_(556) setdest 11548 3608 11.0" 
$ns at 751.9838199272756 "$node_(556) setdest 23859 32075 6.0" 
$ns at 805.5260635161719 "$node_(556) setdest 32320 2923 2.0" 
$ns at 838.7611305195983 "$node_(556) setdest 27679 36729 2.0" 
$ns at 871.1061220203494 "$node_(556) setdest 133510 27303 14.0" 
$ns at 612.5446502549034 "$node_(557) setdest 84785 5877 6.0" 
$ns at 672.4476611881057 "$node_(557) setdest 93773 10013 1.0" 
$ns at 707.006535391183 "$node_(557) setdest 110125 15360 15.0" 
$ns at 862.4816746898899 "$node_(557) setdest 33592 28450 19.0" 
$ns at 521.6801989714788 "$node_(558) setdest 27977 6284 8.0" 
$ns at 602.6909264932455 "$node_(558) setdest 120552 38031 5.0" 
$ns at 670.7739824671169 "$node_(558) setdest 99847 44368 7.0" 
$ns at 702.6575298859132 "$node_(558) setdest 131429 24141 16.0" 
$ns at 866.8504116768269 "$node_(558) setdest 124361 21368 2.0" 
$ns at 899.9287404342659 "$node_(558) setdest 88296 21624 17.0" 
$ns at 518.8006785457477 "$node_(559) setdest 90742 30740 4.0" 
$ns at 559.6251853278814 "$node_(559) setdest 111258 27107 5.0" 
$ns at 630.8495679083936 "$node_(559) setdest 2337 11744 6.0" 
$ns at 679.5946485726885 "$node_(559) setdest 72569 37724 6.0" 
$ns at 710.0116115869417 "$node_(559) setdest 31502 35605 16.0" 
$ns at 833.961690213365 "$node_(559) setdest 95654 40875 1.0" 
$ns at 867.3293390699466 "$node_(559) setdest 118124 22356 13.0" 
$ns at 538.0101654115908 "$node_(560) setdest 55475 40975 13.0" 
$ns at 695.3544426006035 "$node_(560) setdest 48373 25409 7.0" 
$ns at 737.6214960002627 "$node_(560) setdest 117718 31051 14.0" 
$ns at 878.40346478881 "$node_(560) setdest 69898 4311 1.0" 
$ns at 628.4814663651017 "$node_(561) setdest 104513 44238 9.0" 
$ns at 689.1331270129647 "$node_(561) setdest 61489 12750 12.0" 
$ns at 823.9389930821972 "$node_(561) setdest 68769 13962 12.0" 
$ns at 892.8554884626458 "$node_(561) setdest 100010 8516 6.0" 
$ns at 595.9682212509215 "$node_(562) setdest 7949 20099 10.0" 
$ns at 718.2502665290614 "$node_(562) setdest 63331 17401 1.0" 
$ns at 751.4580768818314 "$node_(562) setdest 79994 22403 16.0" 
$ns at 892.0663168247503 "$node_(562) setdest 53654 42405 16.0" 
$ns at 577.9474602420964 "$node_(563) setdest 5309 36714 5.0" 
$ns at 626.113784469739 "$node_(563) setdest 49762 33319 14.0" 
$ns at 668.7485352530992 "$node_(563) setdest 21499 33319 1.0" 
$ns at 700.6043354653807 "$node_(563) setdest 129279 17049 2.0" 
$ns at 736.5295667657784 "$node_(563) setdest 29248 33908 3.0" 
$ns at 794.1552655653547 "$node_(563) setdest 90028 14739 13.0" 
$ns at 880.7080626766897 "$node_(563) setdest 25727 34856 1.0" 
$ns at 568.0817093936005 "$node_(564) setdest 96132 28817 16.0" 
$ns at 726.362055399315 "$node_(564) setdest 2376 39540 12.0" 
$ns at 856.9000641768911 "$node_(564) setdest 121011 38326 16.0" 
$ns at 626.68504223316 "$node_(565) setdest 47267 8734 6.0" 
$ns at 715.7311914678951 "$node_(565) setdest 82825 35416 1.0" 
$ns at 751.6012870333448 "$node_(565) setdest 123984 38067 10.0" 
$ns at 848.4290117607765 "$node_(565) setdest 102073 25914 12.0" 
$ns at 542.0732308416905 "$node_(566) setdest 91670 39550 18.0" 
$ns at 720.1245282420867 "$node_(566) setdest 4361 18006 11.0" 
$ns at 786.1943588534261 "$node_(566) setdest 118575 25631 10.0" 
$ns at 845.5108517685685 "$node_(566) setdest 133662 23413 15.0" 
$ns at 604.407004502078 "$node_(567) setdest 121552 11130 15.0" 
$ns at 750.374199677324 "$node_(567) setdest 62848 4326 9.0" 
$ns at 832.1649569004328 "$node_(567) setdest 62112 39118 4.0" 
$ns at 896.7950321063371 "$node_(567) setdest 96459 1736 14.0" 
$ns at 560.2133930558595 "$node_(568) setdest 72034 16527 1.0" 
$ns at 597.7052256685131 "$node_(568) setdest 55963 43937 16.0" 
$ns at 781.2533582826793 "$node_(568) setdest 120985 11405 5.0" 
$ns at 841.2707761489868 "$node_(568) setdest 100248 26208 15.0" 
$ns at 881.3656184967064 "$node_(568) setdest 120158 44262 6.0" 
$ns at 558.8800806352223 "$node_(569) setdest 55992 12175 5.0" 
$ns at 598.4266413098374 "$node_(569) setdest 7474 9578 10.0" 
$ns at 677.5367496354629 "$node_(569) setdest 124379 11548 16.0" 
$ns at 801.3475214268642 "$node_(569) setdest 41557 16528 9.0" 
$ns at 883.6263606323561 "$node_(569) setdest 124115 17674 10.0" 
$ns at 573.8534912584128 "$node_(570) setdest 58869 13444 6.0" 
$ns at 659.8042127987885 "$node_(570) setdest 88406 7126 18.0" 
$ns at 766.9760236286959 "$node_(570) setdest 98065 27799 1.0" 
$ns at 803.0710036925045 "$node_(570) setdest 25222 21175 16.0" 
$ns at 869.4179016156434 "$node_(570) setdest 67489 8899 4.0" 
$ns at 698.5483993092462 "$node_(571) setdest 100053 29762 9.0" 
$ns at 746.5995563980052 "$node_(571) setdest 119400 24788 7.0" 
$ns at 842.0326302088396 "$node_(571) setdest 22242 14105 9.0" 
$ns at 505.4678479724115 "$node_(572) setdest 45361 39502 2.0" 
$ns at 551.8276224106804 "$node_(572) setdest 28646 20830 17.0" 
$ns at 687.5336947411633 "$node_(572) setdest 31005 5476 15.0" 
$ns at 733.0272016266184 "$node_(572) setdest 24274 35922 15.0" 
$ns at 871.5342966185783 "$node_(572) setdest 15477 2156 2.0" 
$ns at 501.4397261415145 "$node_(573) setdest 127854 16299 11.0" 
$ns at 531.6588578293885 "$node_(573) setdest 44402 19495 5.0" 
$ns at 565.1195149258532 "$node_(573) setdest 69892 33838 4.0" 
$ns at 632.7925435113816 "$node_(573) setdest 36586 21836 16.0" 
$ns at 724.5827864731989 "$node_(573) setdest 72445 20496 1.0" 
$ns at 757.4037833147777 "$node_(573) setdest 34483 34597 20.0" 
$ns at 553.8925837139768 "$node_(574) setdest 12886 4280 17.0" 
$ns at 590.8418560383615 "$node_(574) setdest 106190 32212 19.0" 
$ns at 635.6436386444846 "$node_(574) setdest 40110 38637 16.0" 
$ns at 669.2582542620995 "$node_(574) setdest 88320 24173 7.0" 
$ns at 761.7260562209423 "$node_(574) setdest 122625 14165 18.0" 
$ns at 795.9097754942414 "$node_(574) setdest 98831 41362 7.0" 
$ns at 890.0760638349976 "$node_(574) setdest 1187 4432 9.0" 
$ns at 572.429173270328 "$node_(575) setdest 118531 15969 18.0" 
$ns at 643.2401787920821 "$node_(575) setdest 127122 15118 3.0" 
$ns at 674.2705934048421 "$node_(575) setdest 74575 2772 6.0" 
$ns at 736.9576907890495 "$node_(575) setdest 76094 39922 14.0" 
$ns at 879.046910352709 "$node_(575) setdest 21345 31976 7.0" 
$ns at 554.2377816737502 "$node_(576) setdest 115711 35631 5.0" 
$ns at 633.902412297586 "$node_(576) setdest 35495 10 6.0" 
$ns at 664.9801371457186 "$node_(576) setdest 28201 31956 20.0" 
$ns at 820.5916421816954 "$node_(576) setdest 61329 13222 5.0" 
$ns at 873.8719871903446 "$node_(576) setdest 111760 13255 3.0" 
$ns at 550.3801579250592 "$node_(577) setdest 62005 28547 8.0" 
$ns at 605.8098050865352 "$node_(577) setdest 92081 12428 4.0" 
$ns at 652.4261246420292 "$node_(577) setdest 121037 27826 12.0" 
$ns at 771.1101703677442 "$node_(577) setdest 132774 40275 7.0" 
$ns at 817.800533504044 "$node_(577) setdest 27732 544 15.0" 
$ns at 533.5593910089326 "$node_(578) setdest 82084 29501 1.0" 
$ns at 566.896062590648 "$node_(578) setdest 39986 19282 10.0" 
$ns at 689.2374832747292 "$node_(578) setdest 13646 18044 11.0" 
$ns at 792.8120749804667 "$node_(578) setdest 5299 9025 13.0" 
$ns at 549.7819227081295 "$node_(579) setdest 105748 11524 13.0" 
$ns at 616.0850791406051 "$node_(579) setdest 7494 7792 15.0" 
$ns at 787.9836968708111 "$node_(579) setdest 2870 762 3.0" 
$ns at 847.4778094586036 "$node_(579) setdest 70312 19496 7.0" 
$ns at 886.7318735771274 "$node_(579) setdest 12457 34357 19.0" 
$ns at 530.63644504275 "$node_(580) setdest 95147 25741 1.0" 
$ns at 565.9232208932926 "$node_(580) setdest 3370 23859 13.0" 
$ns at 718.5827787696069 "$node_(580) setdest 46140 5377 7.0" 
$ns at 781.2781316582866 "$node_(580) setdest 110214 17317 10.0" 
$ns at 542.4675844974272 "$node_(581) setdest 133719 3966 17.0" 
$ns at 725.088857352805 "$node_(581) setdest 84477 34639 13.0" 
$ns at 868.5786244073805 "$node_(581) setdest 35757 9320 18.0" 
$ns at 516.8141090586032 "$node_(582) setdest 61930 40532 5.0" 
$ns at 555.2352739583014 "$node_(582) setdest 98642 12714 15.0" 
$ns at 728.9492883358705 "$node_(582) setdest 8918 26617 18.0" 
$ns at 872.4031757501456 "$node_(582) setdest 33095 34839 20.0" 
$ns at 523.8019469661749 "$node_(583) setdest 51637 40091 15.0" 
$ns at 619.4202908777584 "$node_(583) setdest 3267 16699 3.0" 
$ns at 651.7741089462684 "$node_(583) setdest 14980 37719 10.0" 
$ns at 713.5065921036442 "$node_(583) setdest 80371 38153 5.0" 
$ns at 780.590392289379 "$node_(583) setdest 50532 18786 13.0" 
$ns at 849.0782801821805 "$node_(583) setdest 118133 4336 15.0" 
$ns at 511.4012923947209 "$node_(584) setdest 106971 40537 13.0" 
$ns at 567.6126438337058 "$node_(584) setdest 127038 41890 14.0" 
$ns at 643.7567086276831 "$node_(584) setdest 38127 18321 5.0" 
$ns at 707.1771728215683 "$node_(584) setdest 59896 18593 8.0" 
$ns at 738.1991987924778 "$node_(584) setdest 73701 16525 15.0" 
$ns at 828.3252074657393 "$node_(584) setdest 120873 43682 14.0" 
$ns at 528.948703587495 "$node_(585) setdest 85753 4558 16.0" 
$ns at 585.0135290504578 "$node_(585) setdest 40382 42848 13.0" 
$ns at 701.7795977689086 "$node_(585) setdest 99752 1874 19.0" 
$ns at 887.2077216088394 "$node_(585) setdest 4255 18059 11.0" 
$ns at 509.1203169315726 "$node_(586) setdest 72138 4886 10.0" 
$ns at 612.3212257544508 "$node_(586) setdest 5112 7660 16.0" 
$ns at 697.3500930833304 "$node_(586) setdest 58088 21986 13.0" 
$ns at 784.2433415903942 "$node_(586) setdest 25403 16338 14.0" 
$ns at 829.2813345181181 "$node_(586) setdest 5365 12382 12.0" 
$ns at 869.8673923715071 "$node_(586) setdest 10220 34285 5.0" 
$ns at 501.60927332240544 "$node_(587) setdest 42629 19086 13.0" 
$ns at 568.3625554281319 "$node_(587) setdest 108075 15857 1.0" 
$ns at 607.516914774558 "$node_(587) setdest 43511 32963 1.0" 
$ns at 640.6210177794156 "$node_(587) setdest 119210 39364 3.0" 
$ns at 677.1328631823777 "$node_(587) setdest 37297 19085 15.0" 
$ns at 734.6312385083685 "$node_(587) setdest 55619 42677 3.0" 
$ns at 776.823562803363 "$node_(587) setdest 81634 34931 8.0" 
$ns at 855.4999444433365 "$node_(587) setdest 5334 17275 17.0" 
$ns at 553.0374757047907 "$node_(588) setdest 103830 11778 2.0" 
$ns at 592.6098980899485 "$node_(588) setdest 74712 31471 13.0" 
$ns at 684.5454386737074 "$node_(588) setdest 47560 5650 6.0" 
$ns at 757.5939414957263 "$node_(588) setdest 11544 3384 19.0" 
$ns at 593.3417518458414 "$node_(589) setdest 46098 38138 1.0" 
$ns at 623.6117376223235 "$node_(589) setdest 62882 7184 14.0" 
$ns at 675.2851455779761 "$node_(589) setdest 4120 18594 5.0" 
$ns at 733.896431293513 "$node_(589) setdest 124190 8046 2.0" 
$ns at 767.9897067404489 "$node_(589) setdest 46837 14359 11.0" 
$ns at 857.6172958221988 "$node_(589) setdest 42557 7477 2.0" 
$ns at 892.0529514254295 "$node_(589) setdest 127885 16627 11.0" 
$ns at 584.5819703835748 "$node_(590) setdest 55207 33471 19.0" 
$ns at 730.8195260450196 "$node_(590) setdest 93817 29903 14.0" 
$ns at 892.9981598746489 "$node_(590) setdest 58674 26348 8.0" 
$ns at 510.33543545924596 "$node_(591) setdest 107449 37219 2.0" 
$ns at 553.117538112749 "$node_(591) setdest 30303 17441 16.0" 
$ns at 661.4050645716098 "$node_(591) setdest 132810 5555 3.0" 
$ns at 694.4075607223114 "$node_(591) setdest 49334 30856 4.0" 
$ns at 752.1346531897433 "$node_(591) setdest 68470 38491 17.0" 
$ns at 519.2030133132971 "$node_(592) setdest 104851 23340 6.0" 
$ns at 596.7105231875902 "$node_(592) setdest 103664 19694 17.0" 
$ns at 725.1061235151979 "$node_(592) setdest 74162 28506 8.0" 
$ns at 831.2183601352082 "$node_(592) setdest 74678 776 11.0" 
$ns at 890.0051642157267 "$node_(592) setdest 51459 17238 5.0" 
$ns at 538.6063955995332 "$node_(593) setdest 14434 1901 16.0" 
$ns at 715.5404778135628 "$node_(593) setdest 93342 35135 15.0" 
$ns at 866.1778280014307 "$node_(593) setdest 51849 36429 8.0" 
$ns at 598.4988852813434 "$node_(594) setdest 60073 6303 14.0" 
$ns at 692.5902231801249 "$node_(594) setdest 74819 32088 12.0" 
$ns at 762.2752058339784 "$node_(594) setdest 9344 11526 12.0" 
$ns at 815.1879518385264 "$node_(594) setdest 132387 12147 12.0" 
$ns at 591.6863533115886 "$node_(595) setdest 87481 43061 5.0" 
$ns at 650.3547615928536 "$node_(595) setdest 108257 11229 5.0" 
$ns at 706.1869482051293 "$node_(595) setdest 41115 13142 11.0" 
$ns at 742.3748429810676 "$node_(595) setdest 45653 20873 9.0" 
$ns at 822.7780333964306 "$node_(595) setdest 91106 33286 3.0" 
$ns at 875.370098151469 "$node_(595) setdest 50388 10485 12.0" 
$ns at 510.67657065522866 "$node_(596) setdest 21308 6117 8.0" 
$ns at 579.3246992940626 "$node_(596) setdest 25456 31095 6.0" 
$ns at 628.4783827010936 "$node_(596) setdest 117002 2234 20.0" 
$ns at 793.1782902117817 "$node_(596) setdest 13969 31178 1.0" 
$ns at 825.8508370879246 "$node_(596) setdest 53765 27795 11.0" 
$ns at 508.87425635236536 "$node_(597) setdest 14469 33151 14.0" 
$ns at 609.2054012947121 "$node_(597) setdest 2852 30157 11.0" 
$ns at 713.8380596992284 "$node_(597) setdest 13325 19573 4.0" 
$ns at 771.1875987422483 "$node_(597) setdest 30672 11798 12.0" 
$ns at 518.433384757767 "$node_(598) setdest 132266 9659 19.0" 
$ns at 627.4937680432913 "$node_(598) setdest 98126 15121 5.0" 
$ns at 704.3932483373525 "$node_(598) setdest 133481 34028 6.0" 
$ns at 775.3787593172839 "$node_(598) setdest 35545 36008 18.0" 
$ns at 514.5151353277157 "$node_(599) setdest 71290 14263 14.0" 
$ns at 672.6954194412185 "$node_(599) setdest 70460 38158 2.0" 
$ns at 710.2146205389433 "$node_(599) setdest 21062 34806 20.0" 
$ns at 855.7808266030921 "$node_(599) setdest 16208 19287 12.0" 
$ns at 684.9049539663531 "$node_(600) setdest 25794 40228 9.0" 
$ns at 790.58815995888 "$node_(600) setdest 40883 27637 7.0" 
$ns at 823.751436397579 "$node_(600) setdest 83705 16922 5.0" 
$ns at 865.8799429985729 "$node_(600) setdest 83938 31582 6.0" 
$ns at 896.6874493121707 "$node_(600) setdest 94892 12650 11.0" 
$ns at 706.4430891085489 "$node_(601) setdest 25691 6437 18.0" 
$ns at 769.3911233642043 "$node_(601) setdest 16204 32422 1.0" 
$ns at 807.3025888483418 "$node_(601) setdest 120210 30029 13.0" 
$ns at 864.1285516100379 "$node_(601) setdest 37590 20381 5.0" 
$ns at 604.024972936598 "$node_(602) setdest 121221 10682 18.0" 
$ns at 659.0563764238817 "$node_(602) setdest 116999 9456 17.0" 
$ns at 698.8984665181339 "$node_(602) setdest 103116 26935 8.0" 
$ns at 758.8768976757405 "$node_(602) setdest 47620 41232 4.0" 
$ns at 809.3708520311715 "$node_(602) setdest 60317 28502 12.0" 
$ns at 863.0214969962892 "$node_(602) setdest 104525 2159 3.0" 
$ns at 679.1162732980148 "$node_(603) setdest 74291 8253 4.0" 
$ns at 736.6571101157467 "$node_(603) setdest 20858 37908 13.0" 
$ns at 878.1504310778139 "$node_(603) setdest 58365 9368 18.0" 
$ns at 628.307064500977 "$node_(604) setdest 78941 5051 20.0" 
$ns at 667.0525782946089 "$node_(604) setdest 109964 40079 9.0" 
$ns at 744.176374564975 "$node_(604) setdest 52805 35344 10.0" 
$ns at 797.1391261830788 "$node_(604) setdest 111368 32287 4.0" 
$ns at 851.5821434369315 "$node_(604) setdest 46362 33908 11.0" 
$ns at 735.908714061668 "$node_(605) setdest 96940 25101 3.0" 
$ns at 794.4555419982955 "$node_(605) setdest 120033 38045 5.0" 
$ns at 849.9927188013795 "$node_(605) setdest 125820 33486 12.0" 
$ns at 624.1588378749921 "$node_(606) setdest 26857 41304 16.0" 
$ns at 658.9482609749932 "$node_(606) setdest 63185 6007 1.0" 
$ns at 696.106231327107 "$node_(606) setdest 19158 17121 2.0" 
$ns at 735.769526281522 "$node_(606) setdest 26076 28035 1.0" 
$ns at 774.0295098821077 "$node_(606) setdest 50340 36236 10.0" 
$ns at 843.2500677018791 "$node_(606) setdest 58307 37820 10.0" 
$ns at 637.2130603217809 "$node_(607) setdest 90198 17731 17.0" 
$ns at 785.024446655671 "$node_(607) setdest 58443 6826 17.0" 
$ns at 704.4346839144307 "$node_(608) setdest 25801 11355 14.0" 
$ns at 756.7185490189821 "$node_(608) setdest 30284 31672 8.0" 
$ns at 854.3217645847905 "$node_(608) setdest 34353 41337 20.0" 
$ns at 633.522248244865 "$node_(609) setdest 49801 23191 7.0" 
$ns at 718.2047477922431 "$node_(609) setdest 52323 18650 20.0" 
$ns at 856.6333597001676 "$node_(609) setdest 22176 18370 17.0" 
$ns at 657.2027222467101 "$node_(610) setdest 36286 13023 4.0" 
$ns at 694.6358720408643 "$node_(610) setdest 124309 17613 15.0" 
$ns at 778.9728569709539 "$node_(610) setdest 129855 13631 7.0" 
$ns at 864.8704082760037 "$node_(610) setdest 12164 21180 9.0" 
$ns at 720.3168841938755 "$node_(611) setdest 17911 14145 3.0" 
$ns at 767.5760555183037 "$node_(611) setdest 111603 15246 3.0" 
$ns at 820.961100295183 "$node_(611) setdest 36648 35644 16.0" 
$ns at 875.3736118595731 "$node_(611) setdest 60137 36838 4.0" 
$ns at 674.9462672741827 "$node_(612) setdest 100917 38584 16.0" 
$ns at 706.973638546845 "$node_(612) setdest 86849 26974 7.0" 
$ns at 776.3176013855193 "$node_(612) setdest 73139 36068 16.0" 
$ns at 676.3175261288789 "$node_(613) setdest 99494 32463 9.0" 
$ns at 745.6594042444702 "$node_(613) setdest 25655 6952 14.0" 
$ns at 649.1308514962298 "$node_(614) setdest 99470 39488 8.0" 
$ns at 705.8852067917757 "$node_(614) setdest 43881 19745 1.0" 
$ns at 738.4402224189614 "$node_(614) setdest 114920 36204 1.0" 
$ns at 776.4398836521739 "$node_(614) setdest 86004 38838 19.0" 
$ns at 614.1578630434426 "$node_(615) setdest 110734 44290 19.0" 
$ns at 757.6269561929751 "$node_(615) setdest 58079 37140 4.0" 
$ns at 795.9236669931929 "$node_(615) setdest 112294 11841 3.0" 
$ns at 838.6354679417143 "$node_(615) setdest 78023 31542 10.0" 
$ns at 889.3575499624204 "$node_(615) setdest 32355 24439 5.0" 
$ns at 635.5044738311166 "$node_(616) setdest 103394 12012 1.0" 
$ns at 674.5844801480224 "$node_(616) setdest 59401 43559 3.0" 
$ns at 710.2784787274304 "$node_(616) setdest 90256 3902 13.0" 
$ns at 762.4337168720139 "$node_(616) setdest 72982 17743 4.0" 
$ns at 809.617527375789 "$node_(616) setdest 30253 14647 10.0" 
$ns at 623.8292965104555 "$node_(617) setdest 93949 44143 13.0" 
$ns at 732.2313017631665 "$node_(617) setdest 20039 13090 19.0" 
$ns at 872.2948278687406 "$node_(617) setdest 25323 12716 18.0" 
$ns at 657.9058181869593 "$node_(618) setdest 119195 16575 5.0" 
$ns at 712.8173276266228 "$node_(618) setdest 73095 27247 1.0" 
$ns at 750.8620652884536 "$node_(618) setdest 28645 22025 16.0" 
$ns at 606.5679910148253 "$node_(619) setdest 78956 29292 3.0" 
$ns at 663.643767604912 "$node_(619) setdest 36286 33594 3.0" 
$ns at 697.9995666403443 "$node_(619) setdest 104866 15274 1.0" 
$ns at 733.8098989091122 "$node_(619) setdest 4097 19989 12.0" 
$ns at 850.0616190094305 "$node_(619) setdest 91642 31041 13.0" 
$ns at 679.7982526419042 "$node_(620) setdest 131857 33078 1.0" 
$ns at 719.119721421501 "$node_(620) setdest 114260 15620 2.0" 
$ns at 762.3661598071768 "$node_(620) setdest 107849 40961 15.0" 
$ns at 810.4734255778113 "$node_(620) setdest 105361 4068 15.0" 
$ns at 849.2752431469495 "$node_(620) setdest 18406 4392 2.0" 
$ns at 893.71894468191 "$node_(620) setdest 96580 19083 5.0" 
$ns at 639.1699303700954 "$node_(621) setdest 52855 25031 2.0" 
$ns at 676.3257817008125 "$node_(621) setdest 63557 29904 3.0" 
$ns at 716.3784534405464 "$node_(621) setdest 16834 21174 17.0" 
$ns at 780.6249514460136 "$node_(621) setdest 19892 16621 6.0" 
$ns at 866.4806288511979 "$node_(621) setdest 80277 11320 8.0" 
$ns at 644.9690388118487 "$node_(622) setdest 106511 21212 20.0" 
$ns at 768.3145878403786 "$node_(622) setdest 47608 19598 16.0" 
$ns at 602.0413470983202 "$node_(623) setdest 716 32802 18.0" 
$ns at 775.3633595368862 "$node_(623) setdest 77263 16167 15.0" 
$ns at 687.9991782330558 "$node_(624) setdest 37529 27794 15.0" 
$ns at 797.1856614195016 "$node_(624) setdest 92332 40788 14.0" 
$ns at 607.9885198521868 "$node_(625) setdest 77210 44161 1.0" 
$ns at 645.6172217103285 "$node_(625) setdest 111121 21070 4.0" 
$ns at 707.2094944574992 "$node_(625) setdest 2221 33762 4.0" 
$ns at 769.7242745478316 "$node_(625) setdest 23724 10467 15.0" 
$ns at 875.4930635690027 "$node_(625) setdest 86264 11120 2.0" 
$ns at 619.3511845984075 "$node_(626) setdest 94378 11086 9.0" 
$ns at 701.8954405420486 "$node_(626) setdest 131502 26926 5.0" 
$ns at 760.0233310854428 "$node_(626) setdest 23491 964 11.0" 
$ns at 843.1697253840194 "$node_(626) setdest 114153 18745 3.0" 
$ns at 887.2672555040731 "$node_(626) setdest 49520 20594 20.0" 
$ns at 628.7008389736369 "$node_(627) setdest 119933 24664 4.0" 
$ns at 659.865628001196 "$node_(627) setdest 67582 20195 18.0" 
$ns at 780.5977474916752 "$node_(627) setdest 15780 20328 10.0" 
$ns at 871.7198110048312 "$node_(627) setdest 72273 21979 18.0" 
$ns at 613.2547836693409 "$node_(628) setdest 79543 38417 19.0" 
$ns at 691.5057561610554 "$node_(628) setdest 115381 16895 19.0" 
$ns at 695.884842139395 "$node_(629) setdest 120238 11501 13.0" 
$ns at 798.5909296441507 "$node_(629) setdest 114798 42655 19.0" 
$ns at 645.4823740332041 "$node_(630) setdest 1529 18363 1.0" 
$ns at 675.7655919521388 "$node_(630) setdest 100366 36819 12.0" 
$ns at 722.446337540252 "$node_(630) setdest 22879 20964 4.0" 
$ns at 774.5314849368181 "$node_(630) setdest 23036 26582 6.0" 
$ns at 811.8960698266445 "$node_(630) setdest 23895 25156 18.0" 
$ns at 629.101003792397 "$node_(631) setdest 86114 40773 18.0" 
$ns at 780.8808389677598 "$node_(631) setdest 86748 35813 8.0" 
$ns at 813.605865473437 "$node_(631) setdest 134150 3642 17.0" 
$ns at 859.3049122671187 "$node_(631) setdest 129290 39463 1.0" 
$ns at 889.6235652609975 "$node_(631) setdest 10481 24261 8.0" 
$ns at 691.370529590454 "$node_(632) setdest 61507 43424 7.0" 
$ns at 738.5072785903327 "$node_(632) setdest 93567 13703 5.0" 
$ns at 791.3455893139093 "$node_(632) setdest 31152 25542 1.0" 
$ns at 825.7467579300389 "$node_(632) setdest 60620 13593 8.0" 
$ns at 882.6598411936093 "$node_(632) setdest 86284 34752 13.0" 
$ns at 705.032220150704 "$node_(633) setdest 128141 22149 6.0" 
$ns at 743.2508477775059 "$node_(633) setdest 44186 25100 20.0" 
$ns at 881.1998088183675 "$node_(633) setdest 52180 6157 1.0" 
$ns at 658.8390561695142 "$node_(634) setdest 93999 42974 18.0" 
$ns at 848.9577434539333 "$node_(634) setdest 58034 21283 19.0" 
$ns at 683.7047068874767 "$node_(635) setdest 65163 2112 5.0" 
$ns at 740.2682999394212 "$node_(635) setdest 97165 29176 12.0" 
$ns at 792.5393058608518 "$node_(635) setdest 115614 14604 6.0" 
$ns at 858.6457051923876 "$node_(635) setdest 43164 15214 18.0" 
$ns at 613.4848873930199 "$node_(636) setdest 66396 33305 16.0" 
$ns at 717.0297868730457 "$node_(636) setdest 55034 19625 8.0" 
$ns at 771.5775820699403 "$node_(636) setdest 110374 29747 9.0" 
$ns at 880.6934409484046 "$node_(636) setdest 37686 1794 5.0" 
$ns at 618.4345697655979 "$node_(637) setdest 99133 14007 7.0" 
$ns at 709.3863215765261 "$node_(637) setdest 112973 38305 7.0" 
$ns at 744.0212991820994 "$node_(637) setdest 64508 5030 13.0" 
$ns at 791.1082310580073 "$node_(637) setdest 20062 29723 7.0" 
$ns at 827.9026622302381 "$node_(637) setdest 107407 32140 16.0" 
$ns at 682.4109195186425 "$node_(638) setdest 40735 19147 1.0" 
$ns at 714.707391250672 "$node_(638) setdest 50713 6686 16.0" 
$ns at 750.7548043040516 "$node_(638) setdest 18994 24283 19.0" 
$ns at 868.2856758525244 "$node_(638) setdest 5052 37404 1.0" 
$ns at 603.085844069351 "$node_(639) setdest 31076 31497 8.0" 
$ns at 704.3632726534922 "$node_(639) setdest 15666 21523 8.0" 
$ns at 773.7568557603486 "$node_(639) setdest 75205 21060 14.0" 
$ns at 643.0314149934136 "$node_(640) setdest 83340 9412 16.0" 
$ns at 717.8404706308494 "$node_(640) setdest 75301 44057 5.0" 
$ns at 752.3299341950627 "$node_(640) setdest 131004 44606 14.0" 
$ns at 813.7749982120126 "$node_(640) setdest 37244 30701 17.0" 
$ns at 643.5189661502734 "$node_(641) setdest 80792 27199 14.0" 
$ns at 812.9014175093133 "$node_(641) setdest 108817 31610 18.0" 
$ns at 867.9622055996834 "$node_(641) setdest 105416 13339 1.0" 
$ns at 610.8212506730167 "$node_(642) setdest 112111 6563 6.0" 
$ns at 698.4018838364536 "$node_(642) setdest 81379 14706 16.0" 
$ns at 860.1635773034569 "$node_(642) setdest 91124 7147 13.0" 
$ns at 705.4592699694678 "$node_(643) setdest 111344 3488 12.0" 
$ns at 776.1129654576837 "$node_(643) setdest 21561 4034 14.0" 
$ns at 855.2969572344474 "$node_(643) setdest 58663 21968 2.0" 
$ns at 898.8086579709319 "$node_(643) setdest 28434 38671 14.0" 
$ns at 651.0211377675334 "$node_(644) setdest 39531 21223 12.0" 
$ns at 713.7011123113712 "$node_(644) setdest 94729 13126 6.0" 
$ns at 776.9420166441773 "$node_(644) setdest 89681 37663 11.0" 
$ns at 877.1861035787986 "$node_(644) setdest 107174 34965 9.0" 
$ns at 697.260567471021 "$node_(645) setdest 102560 21273 2.0" 
$ns at 731.8184480283018 "$node_(645) setdest 111031 10162 13.0" 
$ns at 792.369332713917 "$node_(645) setdest 114439 34615 15.0" 
$ns at 647.2114198674794 "$node_(646) setdest 98049 6228 18.0" 
$ns at 690.8754815774038 "$node_(646) setdest 124865 41485 14.0" 
$ns at 856.2727326483566 "$node_(646) setdest 25011 5377 7.0" 
$ns at 627.3373482032787 "$node_(647) setdest 43803 32931 2.0" 
$ns at 660.3599388021811 "$node_(647) setdest 119086 4843 14.0" 
$ns at 824.766847466582 "$node_(647) setdest 16623 28330 13.0" 
$ns at 664.6505249615202 "$node_(648) setdest 44267 15569 3.0" 
$ns at 710.412514041045 "$node_(648) setdest 117084 6995 5.0" 
$ns at 772.2708384047642 "$node_(648) setdest 27046 19007 16.0" 
$ns at 841.1320207476753 "$node_(648) setdest 86646 5786 8.0" 
$ns at 605.0569205692905 "$node_(649) setdest 45870 25151 8.0" 
$ns at 682.378207407171 "$node_(649) setdest 21464 573 14.0" 
$ns at 759.2825708877355 "$node_(649) setdest 43607 36615 19.0" 
$ns at 866.2197229840096 "$node_(649) setdest 32833 16527 9.0" 
$ns at 614.2130330265048 "$node_(650) setdest 39688 38050 4.0" 
$ns at 673.9584781541432 "$node_(650) setdest 58197 21959 17.0" 
$ns at 752.150815050702 "$node_(650) setdest 101081 14835 16.0" 
$ns at 635.6540020086637 "$node_(651) setdest 74137 20654 19.0" 
$ns at 672.9925360391061 "$node_(651) setdest 103267 19876 9.0" 
$ns at 791.505754444331 "$node_(651) setdest 41418 26713 19.0" 
$ns at 852.5591715043315 "$node_(651) setdest 38117 42580 10.0" 
$ns at 889.2179791740144 "$node_(651) setdest 120983 40764 15.0" 
$ns at 706.2017724708272 "$node_(652) setdest 76579 15271 3.0" 
$ns at 752.2172572839536 "$node_(652) setdest 35318 3320 17.0" 
$ns at 794.6033698039862 "$node_(652) setdest 12153 7760 20.0" 
$ns at 847.7060170170986 "$node_(652) setdest 18894 2254 17.0" 
$ns at 661.9287130390074 "$node_(653) setdest 1829 27527 9.0" 
$ns at 726.5262999411758 "$node_(653) setdest 131345 19247 7.0" 
$ns at 768.6302014189332 "$node_(653) setdest 126343 34231 10.0" 
$ns at 862.3748588922527 "$node_(653) setdest 47136 37212 9.0" 
$ns at 614.9792970620974 "$node_(654) setdest 44766 14666 1.0" 
$ns at 646.3274570152417 "$node_(654) setdest 130564 37930 17.0" 
$ns at 827.7351904180653 "$node_(654) setdest 114904 37954 19.0" 
$ns at 732.891159631432 "$node_(655) setdest 6256 26802 3.0" 
$ns at 771.0913105605491 "$node_(655) setdest 115192 3799 18.0" 
$ns at 625.0992542606124 "$node_(656) setdest 22487 5109 1.0" 
$ns at 663.1182629386719 "$node_(656) setdest 115161 20558 19.0" 
$ns at 715.7634092478904 "$node_(656) setdest 24608 22697 3.0" 
$ns at 767.9500400575166 "$node_(656) setdest 126402 12188 8.0" 
$ns at 798.3361617768593 "$node_(656) setdest 85564 41431 3.0" 
$ns at 828.8638397898188 "$node_(656) setdest 53148 39072 9.0" 
$ns at 642.07306885869 "$node_(657) setdest 76429 33005 3.0" 
$ns at 677.8302601706753 "$node_(657) setdest 110827 34163 13.0" 
$ns at 826.6087643373651 "$node_(657) setdest 125429 3725 13.0" 
$ns at 612.28240511325 "$node_(658) setdest 65789 24840 17.0" 
$ns at 645.9458634457676 "$node_(658) setdest 81147 12901 11.0" 
$ns at 764.248286493792 "$node_(658) setdest 1026 41135 1.0" 
$ns at 800.330310754126 "$node_(658) setdest 93171 1366 11.0" 
$ns at 895.9624200790959 "$node_(658) setdest 125374 22126 16.0" 
$ns at 604.4482240909571 "$node_(659) setdest 70203 23271 10.0" 
$ns at 668.8838149103856 "$node_(659) setdest 19124 4721 2.0" 
$ns at 705.1718009820876 "$node_(659) setdest 4016 43842 18.0" 
$ns at 788.1941518950349 "$node_(659) setdest 85881 39540 4.0" 
$ns at 833.9802843077922 "$node_(659) setdest 112472 456 7.0" 
$ns at 656.8831173104857 "$node_(660) setdest 9139 31252 7.0" 
$ns at 698.1974042967513 "$node_(660) setdest 112400 6079 17.0" 
$ns at 864.8337167439081 "$node_(660) setdest 92550 1619 3.0" 
$ns at 615.1583233900059 "$node_(661) setdest 50441 40841 13.0" 
$ns at 769.5566495886625 "$node_(661) setdest 82133 36099 5.0" 
$ns at 817.5728048330999 "$node_(661) setdest 91340 1598 11.0" 
$ns at 697.7624498092763 "$node_(662) setdest 36109 40314 16.0" 
$ns at 799.1098685582891 "$node_(662) setdest 6025 3481 15.0" 
$ns at 657.7644335773276 "$node_(663) setdest 63947 1848 12.0" 
$ns at 725.7865099391774 "$node_(663) setdest 116909 24294 8.0" 
$ns at 756.482947576206 "$node_(663) setdest 31501 19055 13.0" 
$ns at 807.8204955294881 "$node_(663) setdest 89677 37611 18.0" 
$ns at 881.0658705478002 "$node_(663) setdest 15217 26534 1.0" 
$ns at 668.1413435488712 "$node_(664) setdest 41251 32059 16.0" 
$ns at 786.8643908738014 "$node_(664) setdest 44908 6236 1.0" 
$ns at 821.8155711915023 "$node_(664) setdest 107337 14656 15.0" 
$ns at 679.5732842365269 "$node_(665) setdest 33071 35919 19.0" 
$ns at 784.97849047898 "$node_(665) setdest 4627 40456 19.0" 
$ns at 671.8893014065613 "$node_(666) setdest 118261 11777 11.0" 
$ns at 761.5253794173422 "$node_(666) setdest 7877 30907 19.0" 
$ns at 619.3352420162121 "$node_(667) setdest 11029 3167 14.0" 
$ns at 739.9821684762229 "$node_(667) setdest 123593 33644 7.0" 
$ns at 804.2029985367788 "$node_(667) setdest 60407 13625 3.0" 
$ns at 863.2631512252093 "$node_(667) setdest 14743 29363 16.0" 
$ns at 646.7345250828613 "$node_(668) setdest 42287 11070 12.0" 
$ns at 782.4131101313499 "$node_(668) setdest 118541 1674 4.0" 
$ns at 824.0904924576923 "$node_(668) setdest 69471 19338 19.0" 
$ns at 672.8884259557431 "$node_(669) setdest 96256 18915 2.0" 
$ns at 703.8779224832934 "$node_(669) setdest 71543 15987 18.0" 
$ns at 821.5165637120207 "$node_(669) setdest 50833 34164 7.0" 
$ns at 863.13323979118 "$node_(669) setdest 91069 24821 3.0" 
$ns at 608.6104143064892 "$node_(670) setdest 56895 36086 10.0" 
$ns at 683.1496838907347 "$node_(670) setdest 128899 31894 13.0" 
$ns at 796.3614391531572 "$node_(670) setdest 133706 7421 4.0" 
$ns at 833.5188685969651 "$node_(670) setdest 85076 11151 11.0" 
$ns at 879.8121948888082 "$node_(670) setdest 73532 20444 19.0" 
$ns at 670.9381727584973 "$node_(671) setdest 31131 9191 1.0" 
$ns at 704.875067234137 "$node_(671) setdest 17710 13902 16.0" 
$ns at 841.3665917372741 "$node_(671) setdest 13409 35129 15.0" 
$ns at 699.3842893445781 "$node_(672) setdest 41719 32512 13.0" 
$ns at 830.2147558195122 "$node_(672) setdest 106855 24983 10.0" 
$ns at 612.1611390333376 "$node_(673) setdest 6399 22276 11.0" 
$ns at 693.5674645641484 "$node_(673) setdest 39230 5862 11.0" 
$ns at 767.549725488137 "$node_(673) setdest 24061 37783 6.0" 
$ns at 846.6602013111294 "$node_(673) setdest 67887 30268 1.0" 
$ns at 881.5741658477742 "$node_(673) setdest 74824 13987 1.0" 
$ns at 654.7246524299414 "$node_(674) setdest 14210 35606 19.0" 
$ns at 737.1796557303313 "$node_(674) setdest 11195 41476 11.0" 
$ns at 814.6842491913574 "$node_(674) setdest 15727 1427 15.0" 
$ns at 859.0936313246177 "$node_(674) setdest 32009 5466 13.0" 
$ns at 638.1835863563202 "$node_(675) setdest 47370 39964 17.0" 
$ns at 764.4372500947579 "$node_(675) setdest 29360 34182 9.0" 
$ns at 866.0232350994424 "$node_(675) setdest 5023 35936 4.0" 
$ns at 667.5651270254275 "$node_(676) setdest 99448 30619 12.0" 
$ns at 817.1854587095946 "$node_(676) setdest 8945 8512 16.0" 
$ns at 856.3837613564472 "$node_(676) setdest 91616 39520 19.0" 
$ns at 647.5691246907879 "$node_(677) setdest 82710 17532 7.0" 
$ns at 709.2053742471885 "$node_(677) setdest 89393 36533 19.0" 
$ns at 891.6432340206682 "$node_(677) setdest 52239 10803 10.0" 
$ns at 723.1715237285107 "$node_(678) setdest 44802 43152 8.0" 
$ns at 812.0691193649698 "$node_(678) setdest 63582 31266 2.0" 
$ns at 847.5654372938587 "$node_(678) setdest 107608 35310 5.0" 
$ns at 879.2731412100263 "$node_(678) setdest 89030 32958 9.0" 
$ns at 693.8708781331106 "$node_(679) setdest 97594 19574 12.0" 
$ns at 813.1936673157658 "$node_(679) setdest 119280 43784 18.0" 
$ns at 662.9378658817408 "$node_(680) setdest 99968 1441 17.0" 
$ns at 820.0022852715488 "$node_(680) setdest 106836 40542 1.0" 
$ns at 852.1448077795696 "$node_(680) setdest 127762 15062 15.0" 
$ns at 656.4785263568526 "$node_(681) setdest 86839 28540 11.0" 
$ns at 769.1550752472543 "$node_(681) setdest 27372 11004 10.0" 
$ns at 888.2611636528994 "$node_(681) setdest 124435 38666 8.0" 
$ns at 638.7331279942067 "$node_(682) setdest 73349 42333 16.0" 
$ns at 814.411275206701 "$node_(682) setdest 104199 28541 6.0" 
$ns at 886.7989471161034 "$node_(682) setdest 74078 38757 9.0" 
$ns at 682.1897670158637 "$node_(683) setdest 24890 5338 16.0" 
$ns at 719.5064678800923 "$node_(683) setdest 121793 36677 19.0" 
$ns at 830.7457283437739 "$node_(683) setdest 14221 42174 19.0" 
$ns at 868.0930468476018 "$node_(683) setdest 95446 42161 1.0" 
$ns at 634.5779996717006 "$node_(684) setdest 125800 39050 7.0" 
$ns at 703.178157491575 "$node_(684) setdest 88738 38529 8.0" 
$ns at 748.9368584721382 "$node_(684) setdest 119102 28233 1.0" 
$ns at 782.8341683510225 "$node_(684) setdest 84890 40136 12.0" 
$ns at 879.8022181186058 "$node_(684) setdest 55873 1851 2.0" 
$ns at 684.5648761800423 "$node_(685) setdest 17377 22221 14.0" 
$ns at 837.8742374570329 "$node_(685) setdest 96797 36037 10.0" 
$ns at 691.4172819859156 "$node_(686) setdest 57112 21938 10.0" 
$ns at 792.3600713287121 "$node_(686) setdest 101740 33589 19.0" 
$ns at 850.6681687760166 "$node_(686) setdest 109454 1611 8.0" 
$ns at 645.1857813008824 "$node_(687) setdest 23829 6792 14.0" 
$ns at 691.1354717456239 "$node_(687) setdest 47583 32584 5.0" 
$ns at 731.3400159061223 "$node_(687) setdest 30056 13108 3.0" 
$ns at 762.076787194554 "$node_(687) setdest 42939 10313 3.0" 
$ns at 796.3445198566576 "$node_(687) setdest 28035 1118 15.0" 
$ns at 827.4385526907353 "$node_(687) setdest 65489 30450 7.0" 
$ns at 888.1529357480521 "$node_(687) setdest 59732 35016 4.0" 
$ns at 617.623279490403 "$node_(688) setdest 19197 19408 6.0" 
$ns at 655.5174950368846 "$node_(688) setdest 12756 26493 8.0" 
$ns at 721.7958608666536 "$node_(688) setdest 69809 15084 20.0" 
$ns at 617.6274985183525 "$node_(689) setdest 67181 3175 11.0" 
$ns at 657.6969413860784 "$node_(689) setdest 16977 39966 3.0" 
$ns at 711.8594003655321 "$node_(689) setdest 93088 43279 13.0" 
$ns at 826.7898760676427 "$node_(689) setdest 13329 19676 8.0" 
$ns at 894.050754143657 "$node_(689) setdest 17561 9387 3.0" 
$ns at 619.3816788404457 "$node_(690) setdest 87075 22446 5.0" 
$ns at 679.9046709402643 "$node_(690) setdest 99981 9542 6.0" 
$ns at 715.4830028971136 "$node_(690) setdest 118818 40767 3.0" 
$ns at 751.1461046554953 "$node_(690) setdest 79867 869 9.0" 
$ns at 791.9082003058213 "$node_(690) setdest 14129 29593 15.0" 
$ns at 888.4687726245198 "$node_(690) setdest 85992 3590 12.0" 
$ns at 627.3134691425205 "$node_(691) setdest 91650 36158 2.0" 
$ns at 672.5012972795411 "$node_(691) setdest 130185 2356 2.0" 
$ns at 707.7658002384055 "$node_(691) setdest 79666 620 10.0" 
$ns at 812.4929558100664 "$node_(691) setdest 106772 42964 12.0" 
$ns at 876.0630727575501 "$node_(691) setdest 127849 14245 2.0" 
$ns at 681.4222003820009 "$node_(692) setdest 76739 13337 7.0" 
$ns at 735.9343251933999 "$node_(692) setdest 11170 42637 9.0" 
$ns at 815.7615741356202 "$node_(692) setdest 48207 32298 19.0" 
$ns at 626.5740410903483 "$node_(693) setdest 123522 65 13.0" 
$ns at 755.579334029097 "$node_(693) setdest 79370 33523 1.0" 
$ns at 789.7860950030148 "$node_(693) setdest 85259 26235 20.0" 
$ns at 742.7856722003477 "$node_(694) setdest 109813 20038 9.0" 
$ns at 798.5118791171905 "$node_(694) setdest 126373 10276 1.0" 
$ns at 831.6318008403646 "$node_(694) setdest 65365 22793 6.0" 
$ns at 628.0514732401149 "$node_(695) setdest 128338 19869 20.0" 
$ns at 743.9109999063593 "$node_(695) setdest 86931 4849 9.0" 
$ns at 779.0754664518992 "$node_(695) setdest 9988 30914 14.0" 
$ns at 868.9605595230956 "$node_(695) setdest 124222 31441 12.0" 
$ns at 721.5585868355518 "$node_(696) setdest 72418 43669 6.0" 
$ns at 811.5257709490672 "$node_(696) setdest 132290 34990 8.0" 
$ns at 892.4092394268059 "$node_(696) setdest 84105 28140 6.0" 
$ns at 641.0178982047181 "$node_(697) setdest 11900 26562 8.0" 
$ns at 747.5234321412076 "$node_(697) setdest 103938 29509 16.0" 
$ns at 876.011361466579 "$node_(697) setdest 133348 11107 15.0" 
$ns at 702.8598198880479 "$node_(698) setdest 99622 10257 14.0" 
$ns at 740.8432410883065 "$node_(698) setdest 69541 538 8.0" 
$ns at 810.6605707389626 "$node_(698) setdest 101534 27868 3.0" 
$ns at 856.7379501819287 "$node_(698) setdest 87202 4088 2.0" 
$ns at 893.0492331719303 "$node_(698) setdest 66006 9279 10.0" 
$ns at 627.7802231131909 "$node_(699) setdest 100605 1608 1.0" 
$ns at 661.5381822559648 "$node_(699) setdest 23709 41655 2.0" 
$ns at 711.353820297571 "$node_(699) setdest 109968 21854 17.0" 
$ns at 802.0324799979603 "$node_(699) setdest 38573 7858 14.0" 
$ns at 821.5539402020556 "$node_(700) setdest 32483 12494 7.0" 
$ns at 729.605509277913 "$node_(701) setdest 119454 20873 19.0" 
$ns at 729.2848268392668 "$node_(702) setdest 31583 4406 10.0" 
$ns at 845.7842124235981 "$node_(702) setdest 77160 28038 5.0" 
$ns at 878.7451474213908 "$node_(702) setdest 84121 16397 12.0" 
$ns at 755.0627680107907 "$node_(703) setdest 109420 11398 14.0" 
$ns at 796.3577665947906 "$node_(703) setdest 8059 30845 2.0" 
$ns at 832.7548973672447 "$node_(703) setdest 100489 28077 3.0" 
$ns at 889.8051417935862 "$node_(703) setdest 105038 26186 8.0" 
$ns at 760.1812345962896 "$node_(704) setdest 68823 40755 9.0" 
$ns at 800.6374643782351 "$node_(704) setdest 33682 902 20.0" 
$ns at 844.6008592596586 "$node_(704) setdest 81283 35515 9.0" 
$ns at 735.8886717756105 "$node_(705) setdest 123904 9672 13.0" 
$ns at 875.9229415001629 "$node_(705) setdest 71196 4457 4.0" 
$ns at 726.0391364572702 "$node_(706) setdest 27324 43781 5.0" 
$ns at 776.0062352501433 "$node_(706) setdest 129615 41547 11.0" 
$ns at 827.1439530475249 "$node_(706) setdest 46509 16159 10.0" 
$ns at 714.5448684116321 "$node_(707) setdest 78188 12395 15.0" 
$ns at 889.6430890978356 "$node_(707) setdest 102007 34053 12.0" 
$ns at 764.6943377266523 "$node_(708) setdest 73812 35722 19.0" 
$ns at 885.0514341161634 "$node_(708) setdest 17382 16782 9.0" 
$ns at 771.8734933787947 "$node_(709) setdest 81280 31187 5.0" 
$ns at 845.8249147367698 "$node_(709) setdest 79974 43277 9.0" 
$ns at 885.5750717362131 "$node_(709) setdest 107400 29934 3.0" 
$ns at 706.3691849479416 "$node_(710) setdest 7443 9023 13.0" 
$ns at 841.0986321435743 "$node_(710) setdest 71791 8012 13.0" 
$ns at 878.7652278845828 "$node_(710) setdest 23542 9146 7.0" 
$ns at 760.6233327751806 "$node_(711) setdest 129056 23230 5.0" 
$ns at 801.6689966988455 "$node_(711) setdest 133736 5811 6.0" 
$ns at 833.2846082530592 "$node_(711) setdest 82433 38050 12.0" 
$ns at 756.632408148826 "$node_(712) setdest 108143 2036 14.0" 
$ns at 876.9118003985994 "$node_(712) setdest 23034 39834 3.0" 
$ns at 745.072027382304 "$node_(713) setdest 96748 15924 17.0" 
$ns at 778.4426930239027 "$node_(713) setdest 60126 10739 12.0" 
$ns at 825.7487749524985 "$node_(713) setdest 115543 18156 16.0" 
$ns at 898.1439491609829 "$node_(713) setdest 48234 28810 12.0" 
$ns at 767.2860472688227 "$node_(714) setdest 126891 28754 4.0" 
$ns at 802.3522127135543 "$node_(714) setdest 61316 37607 19.0" 
$ns at 853.0987734036688 "$node_(714) setdest 8531 22279 4.0" 
$ns at 701.0418369337038 "$node_(715) setdest 98745 21246 16.0" 
$ns at 806.8311982460684 "$node_(715) setdest 130597 17291 15.0" 
$ns at 742.2190003995886 "$node_(716) setdest 3490 4669 2.0" 
$ns at 776.7368886212374 "$node_(716) setdest 122672 26958 17.0" 
$ns at 873.1310512517829 "$node_(716) setdest 9296 17380 18.0" 
$ns at 705.5172214323044 "$node_(717) setdest 6080 700 3.0" 
$ns at 735.7107718784281 "$node_(717) setdest 81780 32943 8.0" 
$ns at 809.1319949132479 "$node_(717) setdest 125413 1840 7.0" 
$ns at 847.2569388999739 "$node_(717) setdest 58026 40433 1.0" 
$ns at 882.9187225035391 "$node_(717) setdest 78824 24030 6.0" 
$ns at 701.5144968077042 "$node_(718) setdest 33588 2100 14.0" 
$ns at 757.1831813049423 "$node_(718) setdest 110403 21613 7.0" 
$ns at 850.5580337986642 "$node_(718) setdest 115032 35116 1.0" 
$ns at 883.1079970119447 "$node_(718) setdest 59635 22065 2.0" 
$ns at 729.4324808860321 "$node_(719) setdest 5485 43814 17.0" 
$ns at 781.4632635227238 "$node_(719) setdest 55052 17049 9.0" 
$ns at 828.3094765308326 "$node_(719) setdest 65373 6286 10.0" 
$ns at 773.8898507447614 "$node_(720) setdest 92526 27286 18.0" 
$ns at 762.704602584854 "$node_(721) setdest 17721 20478 9.0" 
$ns at 829.0300513944823 "$node_(721) setdest 60856 41878 19.0" 
$ns at 871.5548605630818 "$node_(721) setdest 40050 15689 3.0" 
$ns at 740.9185194080258 "$node_(722) setdest 34438 12474 3.0" 
$ns at 784.4023337256309 "$node_(722) setdest 117270 20529 17.0" 
$ns at 803.4063455909944 "$node_(723) setdest 125960 12968 16.0" 
$ns at 846.4557276536377 "$node_(723) setdest 95378 26693 12.0" 
$ns at 796.1219940223474 "$node_(724) setdest 7744 30287 19.0" 
$ns at 816.7069132091808 "$node_(725) setdest 82969 38759 9.0" 
$ns at 705.0417494344875 "$node_(726) setdest 7986 506 15.0" 
$ns at 855.6792520165375 "$node_(726) setdest 111291 18225 4.0" 
$ns at 894.6702969560658 "$node_(726) setdest 21241 28359 1.0" 
$ns at 748.0397858751985 "$node_(727) setdest 73086 15399 11.0" 
$ns at 791.9759010728933 "$node_(727) setdest 58508 8027 4.0" 
$ns at 828.7115753564196 "$node_(727) setdest 85736 19622 11.0" 
$ns at 770.4938464298992 "$node_(728) setdest 60105 42182 14.0" 
$ns at 878.8859927091324 "$node_(728) setdest 103855 1543 6.0" 
$ns at 767.8027944218784 "$node_(729) setdest 115081 41793 2.0" 
$ns at 800.8058328347465 "$node_(729) setdest 33108 41811 18.0" 
$ns at 833.1915242060097 "$node_(729) setdest 128845 38234 11.0" 
$ns at 774.8153924866959 "$node_(730) setdest 12109 37342 14.0" 
$ns at 808.1129623405852 "$node_(731) setdest 101071 41963 11.0" 
$ns at 893.6851219907281 "$node_(731) setdest 67449 41686 13.0" 
$ns at 806.3261372695758 "$node_(732) setdest 10201 32021 8.0" 
$ns at 849.9937870685467 "$node_(732) setdest 44644 36514 10.0" 
$ns at 897.3330980814495 "$node_(732) setdest 70538 10197 14.0" 
$ns at 723.4278821215008 "$node_(733) setdest 111893 43564 2.0" 
$ns at 762.8342462033255 "$node_(733) setdest 78047 40536 2.0" 
$ns at 810.2021224347186 "$node_(733) setdest 89763 16827 15.0" 
$ns at 856.7661889441625 "$node_(733) setdest 120665 34828 6.0" 
$ns at 705.3692367643154 "$node_(734) setdest 3171 7491 10.0" 
$ns at 753.1543496938276 "$node_(734) setdest 63116 30700 18.0" 
$ns at 826.0640100855913 "$node_(734) setdest 110370 11981 19.0" 
$ns at 863.4955440343375 "$node_(735) setdest 37852 13846 2.0" 
$ns at 894.1478080655926 "$node_(735) setdest 30823 16270 8.0" 
$ns at 711.8974618056841 "$node_(736) setdest 28400 2878 15.0" 
$ns at 806.5724806680419 "$node_(736) setdest 97983 13450 20.0" 
$ns at 840.8253936990575 "$node_(737) setdest 130291 25564 5.0" 
$ns at 885.8145732250994 "$node_(737) setdest 51567 23052 16.0" 
$ns at 778.5328508256687 "$node_(738) setdest 22711 32999 13.0" 
$ns at 847.9510140094233 "$node_(738) setdest 34985 28593 15.0" 
$ns at 703.01028047514 "$node_(739) setdest 11353 27379 17.0" 
$ns at 828.6952755665354 "$node_(739) setdest 27426 38507 14.0" 
$ns at 893.1148847723866 "$node_(739) setdest 82118 15579 20.0" 
$ns at 715.5712740041408 "$node_(740) setdest 89779 43105 4.0" 
$ns at 769.187534648774 "$node_(740) setdest 21711 36641 5.0" 
$ns at 822.7108970078119 "$node_(740) setdest 93157 23560 1.0" 
$ns at 853.4308180061632 "$node_(740) setdest 67233 15847 5.0" 
$ns at 895.5186381269962 "$node_(740) setdest 61187 24141 8.0" 
$ns at 701.4514137364246 "$node_(741) setdest 128008 6163 11.0" 
$ns at 832.1593101394644 "$node_(741) setdest 131142 12451 4.0" 
$ns at 881.5853841963725 "$node_(741) setdest 99258 21064 10.0" 
$ns at 734.9590242464031 "$node_(742) setdest 50459 22841 17.0" 
$ns at 861.8923213619879 "$node_(742) setdest 69745 14721 2.0" 
$ns at 787.8175147449106 "$node_(743) setdest 68391 32205 4.0" 
$ns at 818.2482791878924 "$node_(743) setdest 121031 4972 1.0" 
$ns at 852.1798965983064 "$node_(743) setdest 7763 18515 17.0" 
$ns at 719.5648512530083 "$node_(744) setdest 82889 4043 4.0" 
$ns at 779.2292851467171 "$node_(744) setdest 127490 19961 1.0" 
$ns at 814.7988554394021 "$node_(744) setdest 122787 10812 5.0" 
$ns at 872.8658943440174 "$node_(744) setdest 125851 13028 18.0" 
$ns at 701.7289892217862 "$node_(745) setdest 45817 10792 12.0" 
$ns at 772.044448284476 "$node_(745) setdest 21232 7766 8.0" 
$ns at 808.3180228322193 "$node_(745) setdest 105580 13933 9.0" 
$ns at 855.4121187428084 "$node_(745) setdest 46429 19589 11.0" 
$ns at 751.4272365173524 "$node_(746) setdest 59995 39967 15.0" 
$ns at 766.5024001290603 "$node_(747) setdest 91340 4529 1.0" 
$ns at 803.018125670499 "$node_(747) setdest 110257 40600 1.0" 
$ns at 839.6546204885666 "$node_(747) setdest 21941 39014 12.0" 
$ns at 865.5861771390464 "$node_(748) setdest 108824 28439 5.0" 
$ns at 725.718805957968 "$node_(749) setdest 38006 31291 7.0" 
$ns at 784.244482510314 "$node_(749) setdest 108550 3952 18.0" 
$ns at 748.6266158733861 "$node_(750) setdest 84708 33692 4.0" 
$ns at 804.8778640623136 "$node_(750) setdest 102017 28859 15.0" 
$ns at 882.3954062170195 "$node_(750) setdest 24099 6354 12.0" 
$ns at 720.9691476396532 "$node_(751) setdest 45684 34184 18.0" 
$ns at 805.6757552039955 "$node_(751) setdest 41401 21968 13.0" 
$ns at 715.5088697950276 "$node_(752) setdest 128561 24338 3.0" 
$ns at 772.0391800583266 "$node_(752) setdest 123961 32212 15.0" 
$ns at 835.0611991120026 "$node_(752) setdest 87570 14026 14.0" 
$ns at 700.1269242401544 "$node_(753) setdest 17730 40073 1.0" 
$ns at 739.0884742920545 "$node_(753) setdest 91259 17501 20.0" 
$ns at 772.7244076034964 "$node_(753) setdest 34320 17693 13.0" 
$ns at 710.4747039398446 "$node_(754) setdest 75104 4883 3.0" 
$ns at 753.3577559721981 "$node_(754) setdest 88484 23760 6.0" 
$ns at 830.6508257239673 "$node_(754) setdest 130637 36441 3.0" 
$ns at 862.0144069731311 "$node_(754) setdest 32293 25573 17.0" 
$ns at 729.872331947816 "$node_(755) setdest 115254 4811 8.0" 
$ns at 792.8821714510365 "$node_(755) setdest 65081 8244 3.0" 
$ns at 839.0320257221244 "$node_(755) setdest 39785 15216 5.0" 
$ns at 872.5421878585759 "$node_(755) setdest 99603 8284 10.0" 
$ns at 723.2638675668727 "$node_(756) setdest 130885 25906 10.0" 
$ns at 784.0810824073612 "$node_(756) setdest 28325 42338 19.0" 
$ns at 717.7418278951426 "$node_(757) setdest 35111 7064 9.0" 
$ns at 787.0483076551496 "$node_(757) setdest 40811 41919 9.0" 
$ns at 819.681303107804 "$node_(757) setdest 107713 19542 11.0" 
$ns at 799.1926465332969 "$node_(758) setdest 111110 12825 8.0" 
$ns at 838.5515109922533 "$node_(758) setdest 129844 8732 19.0" 
$ns at 727.5340314569722 "$node_(759) setdest 115586 17844 1.0" 
$ns at 760.2254534466042 "$node_(759) setdest 1590 41527 13.0" 
$ns at 793.3510124134633 "$node_(759) setdest 130024 13802 18.0" 
$ns at 787.389133226311 "$node_(760) setdest 10567 21252 19.0" 
$ns at 721.0082714210271 "$node_(761) setdest 14760 39688 6.0" 
$ns at 751.2022342853829 "$node_(761) setdest 61132 18571 2.0" 
$ns at 782.8221512352201 "$node_(761) setdest 118769 23521 19.0" 
$ns at 851.223432282068 "$node_(761) setdest 71493 33457 4.0" 
$ns at 897.274884187452 "$node_(761) setdest 66537 39121 6.0" 
$ns at 707.300165960771 "$node_(762) setdest 36371 40114 4.0" 
$ns at 776.6390174898384 "$node_(762) setdest 68136 25149 14.0" 
$ns at 805.1998740761607 "$node_(763) setdest 95619 35224 8.0" 
$ns at 885.7977107614 "$node_(763) setdest 67178 20627 17.0" 
$ns at 741.2945386449863 "$node_(764) setdest 91715 43861 5.0" 
$ns at 780.7351597395639 "$node_(764) setdest 39413 22913 18.0" 
$ns at 881.7321564033932 "$node_(764) setdest 132620 31570 17.0" 
$ns at 734.3715893293233 "$node_(765) setdest 6211 21437 8.0" 
$ns at 823.4398519775687 "$node_(765) setdest 82060 37554 13.0" 
$ns at 885.6988392936212 "$node_(765) setdest 68733 7238 14.0" 
$ns at 822.5503572462399 "$node_(766) setdest 22436 14953 1.0" 
$ns at 861.420546169992 "$node_(766) setdest 98560 7511 20.0" 
$ns at 775.7594649101932 "$node_(767) setdest 107576 36109 8.0" 
$ns at 841.4575142270648 "$node_(767) setdest 51147 8835 14.0" 
$ns at 895.1630311866454 "$node_(767) setdest 47930 27933 17.0" 
$ns at 706.1460998008238 "$node_(768) setdest 34989 9702 7.0" 
$ns at 763.9760375646481 "$node_(768) setdest 44337 33619 16.0" 
$ns at 785.8335936271405 "$node_(769) setdest 106002 13153 1.0" 
$ns at 817.3334539028795 "$node_(769) setdest 66692 2407 7.0" 
$ns at 756.433158688874 "$node_(770) setdest 99947 22159 3.0" 
$ns at 812.6523908945233 "$node_(770) setdest 127667 8502 13.0" 
$ns at 749.7625820674748 "$node_(771) setdest 48167 25409 10.0" 
$ns at 803.3892141834737 "$node_(771) setdest 65650 21497 10.0" 
$ns at 710.2959743536677 "$node_(772) setdest 127776 8132 17.0" 
$ns at 777.2328629868421 "$node_(773) setdest 132126 10042 3.0" 
$ns at 808.5225379857495 "$node_(773) setdest 131298 2914 16.0" 
$ns at 723.8730771129106 "$node_(774) setdest 50655 11461 1.0" 
$ns at 757.5722592959344 "$node_(774) setdest 32640 39393 6.0" 
$ns at 807.8849596711722 "$node_(774) setdest 42250 42679 17.0" 
$ns at 707.774887520987 "$node_(775) setdest 9093 17643 7.0" 
$ns at 742.3570032740917 "$node_(775) setdest 30962 44470 3.0" 
$ns at 790.7644463944143 "$node_(775) setdest 110345 2893 2.0" 
$ns at 823.8218954241927 "$node_(775) setdest 43281 13821 7.0" 
$ns at 870.2802903118436 "$node_(775) setdest 74068 37180 10.0" 
$ns at 743.4438404286085 "$node_(776) setdest 127643 38549 12.0" 
$ns at 891.1954331990568 "$node_(776) setdest 57950 44335 7.0" 
$ns at 811.7455011424854 "$node_(777) setdest 48337 22474 5.0" 
$ns at 858.9827779735216 "$node_(777) setdest 96574 36105 17.0" 
$ns at 736.5487822972325 "$node_(778) setdest 103282 33356 4.0" 
$ns at 801.8752675438241 "$node_(778) setdest 41364 36575 18.0" 
$ns at 870.5955074793612 "$node_(778) setdest 16199 43320 17.0" 
$ns at 700.3013650568298 "$node_(779) setdest 16961 5551 1.0" 
$ns at 737.272924166797 "$node_(779) setdest 81182 38864 15.0" 
$ns at 777.3815604466566 "$node_(779) setdest 1812 2074 2.0" 
$ns at 808.9659293980179 "$node_(779) setdest 33075 34589 19.0" 
$ns at 882.5700572767878 "$node_(779) setdest 96812 34523 1.0" 
$ns at 738.2570642240285 "$node_(780) setdest 34033 2736 9.0" 
$ns at 831.5361213164238 "$node_(780) setdest 48591 4540 20.0" 
$ns at 729.0442647674986 "$node_(781) setdest 129131 19944 2.0" 
$ns at 769.888847009855 "$node_(781) setdest 80291 29864 3.0" 
$ns at 811.3969122110617 "$node_(781) setdest 2225 7834 1.0" 
$ns at 848.7762720718108 "$node_(781) setdest 43094 43286 1.0" 
$ns at 885.3763419340133 "$node_(781) setdest 119527 13213 20.0" 
$ns at 733.660396194375 "$node_(782) setdest 59873 26650 8.0" 
$ns at 775.6933025370761 "$node_(782) setdest 117046 39192 3.0" 
$ns at 810.0105948125369 "$node_(782) setdest 76545 12339 19.0" 
$ns at 858.3512428345086 "$node_(782) setdest 127997 19657 4.0" 
$ns at 709.408608300318 "$node_(783) setdest 75006 29077 4.0" 
$ns at 778.5542460155849 "$node_(783) setdest 37853 24773 10.0" 
$ns at 875.3350049826266 "$node_(783) setdest 99494 14398 18.0" 
$ns at 703.6343089812098 "$node_(784) setdest 108632 20935 6.0" 
$ns at 776.9872195416033 "$node_(784) setdest 56373 10450 12.0" 
$ns at 752.3408766467304 "$node_(785) setdest 129660 43483 20.0" 
$ns at 731.7201317236264 "$node_(786) setdest 29195 41869 19.0" 
$ns at 855.8669426484478 "$node_(786) setdest 119523 11285 3.0" 
$ns at 896.3559445331402 "$node_(786) setdest 21454 42077 18.0" 
$ns at 711.4371974739795 "$node_(787) setdest 126660 43569 2.0" 
$ns at 760.780088358297 "$node_(787) setdest 123766 27494 19.0" 
$ns at 808.9240128358468 "$node_(787) setdest 40155 19193 11.0" 
$ns at 718.3527590679089 "$node_(788) setdest 500 566 10.0" 
$ns at 843.1611064074601 "$node_(788) setdest 123730 10406 13.0" 
$ns at 888.7010605213569 "$node_(788) setdest 108266 900 5.0" 
$ns at 710.7664355667583 "$node_(789) setdest 41202 17703 10.0" 
$ns at 799.3711733365983 "$node_(789) setdest 122284 19515 9.0" 
$ns at 878.7468656002561 "$node_(789) setdest 41474 38174 10.0" 
$ns at 711.1053580209614 "$node_(790) setdest 125038 32103 6.0" 
$ns at 760.5612410981576 "$node_(790) setdest 118109 3540 18.0" 
$ns at 799.1907455871839 "$node_(790) setdest 119378 19204 5.0" 
$ns at 867.6092864362507 "$node_(790) setdest 7939 5636 11.0" 
$ns at 811.503373619815 "$node_(791) setdest 117346 21355 18.0" 
$ns at 886.7076548789381 "$node_(791) setdest 99377 15422 1.0" 
$ns at 786.3072459645219 "$node_(792) setdest 15551 9761 10.0" 
$ns at 886.6679595335049 "$node_(792) setdest 12709 949 8.0" 
$ns at 745.6744288979728 "$node_(793) setdest 65039 11668 7.0" 
$ns at 822.0376319042838 "$node_(793) setdest 81771 41550 7.0" 
$ns at 864.988083725702 "$node_(793) setdest 98497 25173 10.0" 
$ns at 702.2681391578678 "$node_(794) setdest 59439 1443 9.0" 
$ns at 779.9144291509341 "$node_(794) setdest 124509 38690 14.0" 
$ns at 700.0881940586498 "$node_(795) setdest 98176 37706 10.0" 
$ns at 802.831538723405 "$node_(795) setdest 119284 12635 9.0" 
$ns at 879.2854208295062 "$node_(795) setdest 95382 34215 13.0" 
$ns at 748.3318005169347 "$node_(796) setdest 60133 16283 8.0" 
$ns at 818.4504171471795 "$node_(796) setdest 115849 11432 12.0" 
$ns at 753.1088130971066 "$node_(797) setdest 127517 1476 12.0" 
$ns at 895.5565514888401 "$node_(797) setdest 63188 22993 18.0" 
$ns at 711.4122178403479 "$node_(798) setdest 43947 15305 17.0" 
$ns at 798.7912507277407 "$node_(798) setdest 80247 7267 6.0" 
$ns at 867.9046290164838 "$node_(798) setdest 126976 30920 3.0" 
$ns at 756.4414398247477 "$node_(799) setdest 3487 19023 1.0" 
$ns at 789.4394925448714 "$node_(799) setdest 113865 23209 8.0" 
$ns at 886.3243230793607 "$node_(799) setdest 6949 7577 10.0" 


#Set a TCP connection between node_(30) and node_(49)
set tcp_(0) [new Agent/TCP/Newreno]
$tcp_(0) set class_ 2
set sink_(0) [new Agent/TCPSink]
$ns attach-agent $node_(30) $tcp_(0)
$ns attach-agent $node_(49) $sink_(0)
$ns connect $tcp_(0) $sink_(0)
set ftp_(0) [new Application/FTP]
$ftp_(0) attach-agent $tcp_(0)
$ns at 0.2 "$ftp_(0) start"
$ns at 180.0 "$ftp_(0) stop"

#Set a TCP connection between node_(42) and node_(98)
set tcp_(1) [new Agent/TCP/Newreno]
$tcp_(1) set class_ 2
set sink_(1) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(1)
$ns attach-agent $node_(98) $sink_(1)
$ns connect $tcp_(1) $sink_(1)
set ftp_(1) [new Application/FTP]
$ftp_(1) attach-agent $tcp_(1)
$ns at 180.2 "$ftp_(1) start"
$ns at 360.0 "$ftp_(1) stop"

#Set a TCP connection between node_(89) and node_(85)
set tcp_(2) [new Agent/TCP/Newreno]
$tcp_(2) set class_ 2
set sink_(2) [new Agent/TCPSink]
$ns attach-agent $node_(89) $tcp_(2)
$ns attach-agent $node_(85) $sink_(2)
$ns connect $tcp_(2) $sink_(2)
set ftp_(2) [new Application/FTP]
$ftp_(2) attach-agent $tcp_(2)
$ns at 360.2 "$ftp_(2) start"
$ns at 540.0 "$ftp_(2) stop"

#Set a TCP connection between node_(4) and node_(85)
set tcp_(3) [new Agent/TCP/Newreno]
$tcp_(3) set class_ 2
set sink_(3) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(3)
$ns attach-agent $node_(85) $sink_(3)
$ns connect $tcp_(3) $sink_(3)
set ftp_(3) [new Application/FTP]
$ftp_(3) attach-agent $tcp_(3)
$ns at 540.2 "$ftp_(3) start"
$ns at 720.0 "$ftp_(3) stop"

#Set a TCP connection between node_(84) and node_(59)
set tcp_(4) [new Agent/TCP/Newreno]
$tcp_(4) set class_ 2
set sink_(4) [new Agent/TCPSink]
$ns attach-agent $node_(84) $tcp_(4)
$ns attach-agent $node_(59) $sink_(4)
$ns connect $tcp_(4) $sink_(4)
set ftp_(4) [new Application/FTP]
$ftp_(4) attach-agent $tcp_(4)
$ns at 720.2 "$ftp_(4) start"
$ns at 900.0 "$ftp_(4) stop"

#Set a TCP connection between node_(64) and node_(34)
set tcp_(5) [new Agent/TCP/Newreno]
$tcp_(5) set class_ 2
set sink_(5) [new Agent/TCPSink]
$ns attach-agent $node_(64) $tcp_(5)
$ns attach-agent $node_(34) $sink_(5)
$ns connect $tcp_(5) $sink_(5)
set ftp_(5) [new Application/FTP]
$ftp_(5) attach-agent $tcp_(5)
$ns at 0.2 "$ftp_(5) start"
$ns at 180.0 "$ftp_(5) stop"

#Set a TCP connection between node_(48) and node_(32)
set tcp_(6) [new Agent/TCP/Newreno]
$tcp_(6) set class_ 2
set sink_(6) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(6)
$ns attach-agent $node_(32) $sink_(6)
$ns connect $tcp_(6) $sink_(6)
set ftp_(6) [new Application/FTP]
$ftp_(6) attach-agent $tcp_(6)
$ns at 180.2 "$ftp_(6) start"
$ns at 360.0 "$ftp_(6) stop"

#Set a TCP connection between node_(1) and node_(82)
set tcp_(7) [new Agent/TCP/Newreno]
$tcp_(7) set class_ 2
set sink_(7) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(7)
$ns attach-agent $node_(82) $sink_(7)
$ns connect $tcp_(7) $sink_(7)
set ftp_(7) [new Application/FTP]
$ftp_(7) attach-agent $tcp_(7)
$ns at 360.2 "$ftp_(7) start"
$ns at 540.0 "$ftp_(7) stop"

#Set a TCP connection between node_(26) and node_(19)
set tcp_(8) [new Agent/TCP/Newreno]
$tcp_(8) set class_ 2
set sink_(8) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(8)
$ns attach-agent $node_(19) $sink_(8)
$ns connect $tcp_(8) $sink_(8)
set ftp_(8) [new Application/FTP]
$ftp_(8) attach-agent $tcp_(8)
$ns at 540.2 "$ftp_(8) start"
$ns at 720.0 "$ftp_(8) stop"

#Set a TCP connection between node_(91) and node_(65)
set tcp_(9) [new Agent/TCP/Newreno]
$tcp_(9) set class_ 2
set sink_(9) [new Agent/TCPSink]
$ns attach-agent $node_(91) $tcp_(9)
$ns attach-agent $node_(65) $sink_(9)
$ns connect $tcp_(9) $sink_(9)
set ftp_(9) [new Application/FTP]
$ftp_(9) attach-agent $tcp_(9)
$ns at 720.2 "$ftp_(9) start"
$ns at 900.0 "$ftp_(9) stop"

#Set a TCP connection between node_(59) and node_(90)
set tcp_(10) [new Agent/TCP/Newreno]
$tcp_(10) set class_ 2
set sink_(10) [new Agent/TCPSink]
$ns attach-agent $node_(59) $tcp_(10)
$ns attach-agent $node_(90) $sink_(10)
$ns connect $tcp_(10) $sink_(10)
set ftp_(10) [new Application/FTP]
$ftp_(10) attach-agent $tcp_(10)
$ns at 0.2 "$ftp_(10) start"
$ns at 180.0 "$ftp_(10) stop"

#Set a TCP connection between node_(68) and node_(23)
set tcp_(11) [new Agent/TCP/Newreno]
$tcp_(11) set class_ 2
set sink_(11) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(11)
$ns attach-agent $node_(23) $sink_(11)
$ns connect $tcp_(11) $sink_(11)
set ftp_(11) [new Application/FTP]
$ftp_(11) attach-agent $tcp_(11)
$ns at 180.2 "$ftp_(11) start"
$ns at 360.0 "$ftp_(11) stop"

#Set a TCP connection between node_(47) and node_(86)
set tcp_(12) [new Agent/TCP/Newreno]
$tcp_(12) set class_ 2
set sink_(12) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(12)
$ns attach-agent $node_(86) $sink_(12)
$ns connect $tcp_(12) $sink_(12)
set ftp_(12) [new Application/FTP]
$ftp_(12) attach-agent $tcp_(12)
$ns at 360.2 "$ftp_(12) start"
$ns at 540.0 "$ftp_(12) stop"

#Set a TCP connection between node_(1) and node_(20)
set tcp_(13) [new Agent/TCP/Newreno]
$tcp_(13) set class_ 2
set sink_(13) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(13)
$ns attach-agent $node_(20) $sink_(13)
$ns connect $tcp_(13) $sink_(13)
set ftp_(13) [new Application/FTP]
$ftp_(13) attach-agent $tcp_(13)
$ns at 540.2 "$ftp_(13) start"
$ns at 720.0 "$ftp_(13) stop"

#Set a TCP connection between node_(66) and node_(21)
set tcp_(14) [new Agent/TCP/Newreno]
$tcp_(14) set class_ 2
set sink_(14) [new Agent/TCPSink]
$ns attach-agent $node_(66) $tcp_(14)
$ns attach-agent $node_(21) $sink_(14)
$ns connect $tcp_(14) $sink_(14)
set ftp_(14) [new Application/FTP]
$ftp_(14) attach-agent $tcp_(14)
$ns at 720.2 "$ftp_(14) start"
$ns at 900.0 "$ftp_(14) stop"

#Set a TCP connection between node_(62) and node_(76)
set tcp_(15) [new Agent/TCP/Newreno]
$tcp_(15) set class_ 2
set sink_(15) [new Agent/TCPSink]
$ns attach-agent $node_(62) $tcp_(15)
$ns attach-agent $node_(76) $sink_(15)
$ns connect $tcp_(15) $sink_(15)
set ftp_(15) [new Application/FTP]
$ftp_(15) attach-agent $tcp_(15)
$ns at 0.2 "$ftp_(15) start"
$ns at 180.0 "$ftp_(15) stop"

#Set a TCP connection between node_(96) and node_(88)
set tcp_(16) [new Agent/TCP/Newreno]
$tcp_(16) set class_ 2
set sink_(16) [new Agent/TCPSink]
$ns attach-agent $node_(96) $tcp_(16)
$ns attach-agent $node_(88) $sink_(16)
$ns connect $tcp_(16) $sink_(16)
set ftp_(16) [new Application/FTP]
$ftp_(16) attach-agent $tcp_(16)
$ns at 180.2 "$ftp_(16) start"
$ns at 360.0 "$ftp_(16) stop"

#Set a TCP connection between node_(16) and node_(40)
set tcp_(17) [new Agent/TCP/Newreno]
$tcp_(17) set class_ 2
set sink_(17) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(17)
$ns attach-agent $node_(40) $sink_(17)
$ns connect $tcp_(17) $sink_(17)
set ftp_(17) [new Application/FTP]
$ftp_(17) attach-agent $tcp_(17)
$ns at 360.2 "$ftp_(17) start"
$ns at 540.0 "$ftp_(17) stop"

#Set a TCP connection between node_(71) and node_(13)
set tcp_(18) [new Agent/TCP/Newreno]
$tcp_(18) set class_ 2
set sink_(18) [new Agent/TCPSink]
$ns attach-agent $node_(71) $tcp_(18)
$ns attach-agent $node_(13) $sink_(18)
$ns connect $tcp_(18) $sink_(18)
set ftp_(18) [new Application/FTP]
$ftp_(18) attach-agent $tcp_(18)
$ns at 540.2 "$ftp_(18) start"
$ns at 720.0 "$ftp_(18) stop"

#Set a TCP connection between node_(32) and node_(38)
set tcp_(19) [new Agent/TCP/Newreno]
$tcp_(19) set class_ 2
set sink_(19) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(19)
$ns attach-agent $node_(38) $sink_(19)
$ns connect $tcp_(19) $sink_(19)
set ftp_(19) [new Application/FTP]
$ftp_(19) attach-agent $tcp_(19)
$ns at 720.2 "$ftp_(19) start"
$ns at 900.0 "$ftp_(19) stop"

#Set a TCP connection between node_(63) and node_(60)
set tcp_(20) [new Agent/TCP/Newreno]
$tcp_(20) set class_ 2
set sink_(20) [new Agent/TCPSink]
$ns attach-agent $node_(63) $tcp_(20)
$ns attach-agent $node_(60) $sink_(20)
$ns connect $tcp_(20) $sink_(20)
set ftp_(20) [new Application/FTP]
$ftp_(20) attach-agent $tcp_(20)
$ns at 0.2 "$ftp_(20) start"
$ns at 180.0 "$ftp_(20) stop"

#Set a TCP connection between node_(15) and node_(72)
set tcp_(21) [new Agent/TCP/Newreno]
$tcp_(21) set class_ 2
set sink_(21) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(21)
$ns attach-agent $node_(72) $sink_(21)
$ns connect $tcp_(21) $sink_(21)
set ftp_(21) [new Application/FTP]
$ftp_(21) attach-agent $tcp_(21)
$ns at 180.2 "$ftp_(21) start"
$ns at 360.0 "$ftp_(21) stop"

#Set a TCP connection between node_(22) and node_(19)
set tcp_(22) [new Agent/TCP/Newreno]
$tcp_(22) set class_ 2
set sink_(22) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(22)
$ns attach-agent $node_(19) $sink_(22)
$ns connect $tcp_(22) $sink_(22)
set ftp_(22) [new Application/FTP]
$ftp_(22) attach-agent $tcp_(22)
$ns at 360.2 "$ftp_(22) start"
$ns at 540.0 "$ftp_(22) stop"

#Set a TCP connection between node_(6) and node_(95)
set tcp_(23) [new Agent/TCP/Newreno]
$tcp_(23) set class_ 2
set sink_(23) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(23)
$ns attach-agent $node_(95) $sink_(23)
$ns connect $tcp_(23) $sink_(23)
set ftp_(23) [new Application/FTP]
$ftp_(23) attach-agent $tcp_(23)
$ns at 540.2 "$ftp_(23) start"
$ns at 720.0 "$ftp_(23) stop"

#Set a TCP connection between node_(63) and node_(14)
set tcp_(24) [new Agent/TCP/Newreno]
$tcp_(24) set class_ 2
set sink_(24) [new Agent/TCPSink]
$ns attach-agent $node_(63) $tcp_(24)
$ns attach-agent $node_(14) $sink_(24)
$ns connect $tcp_(24) $sink_(24)
set ftp_(24) [new Application/FTP]
$ftp_(24) attach-agent $tcp_(24)
$ns at 720.2 "$ftp_(24) start"
$ns at 900.0 "$ftp_(24) stop"

#Set a TCP connection between node_(35) and node_(47)
set tcp_(25) [new Agent/TCP/Newreno]
$tcp_(25) set class_ 2
set sink_(25) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(25)
$ns attach-agent $node_(47) $sink_(25)
$ns connect $tcp_(25) $sink_(25)
set ftp_(25) [new Application/FTP]
$ftp_(25) attach-agent $tcp_(25)
$ns at 0.2 "$ftp_(25) start"
$ns at 180.0 "$ftp_(25) stop"

#Set a TCP connection between node_(39) and node_(96)
set tcp_(26) [new Agent/TCP/Newreno]
$tcp_(26) set class_ 2
set sink_(26) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(26)
$ns attach-agent $node_(96) $sink_(26)
$ns connect $tcp_(26) $sink_(26)
set ftp_(26) [new Application/FTP]
$ftp_(26) attach-agent $tcp_(26)
$ns at 180.2 "$ftp_(26) start"
$ns at 360.0 "$ftp_(26) stop"

#Set a TCP connection between node_(87) and node_(9)
set tcp_(27) [new Agent/TCP/Newreno]
$tcp_(27) set class_ 2
set sink_(27) [new Agent/TCPSink]
$ns attach-agent $node_(87) $tcp_(27)
$ns attach-agent $node_(9) $sink_(27)
$ns connect $tcp_(27) $sink_(27)
set ftp_(27) [new Application/FTP]
$ftp_(27) attach-agent $tcp_(27)
$ns at 360.2 "$ftp_(27) start"
$ns at 540.0 "$ftp_(27) stop"

#Set a TCP connection between node_(12) and node_(89)
set tcp_(28) [new Agent/TCP/Newreno]
$tcp_(28) set class_ 2
set sink_(28) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(28)
$ns attach-agent $node_(89) $sink_(28)
$ns connect $tcp_(28) $sink_(28)
set ftp_(28) [new Application/FTP]
$ftp_(28) attach-agent $tcp_(28)
$ns at 540.2 "$ftp_(28) start"
$ns at 720.0 "$ftp_(28) stop"

#Set a TCP connection between node_(44) and node_(69)
set tcp_(29) [new Agent/TCP/Newreno]
$tcp_(29) set class_ 2
set sink_(29) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(29)
$ns attach-agent $node_(69) $sink_(29)
$ns connect $tcp_(29) $sink_(29)
set ftp_(29) [new Application/FTP]
$ftp_(29) attach-agent $tcp_(29)
$ns at 720.2 "$ftp_(29) start"
$ns at 900.0 "$ftp_(29) stop"

#Set a TCP connection between node_(21) and node_(98)
set tcp_(30) [new Agent/TCP/Newreno]
$tcp_(30) set class_ 2
set sink_(30) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(30)
$ns attach-agent $node_(98) $sink_(30)
$ns connect $tcp_(30) $sink_(30)
set ftp_(30) [new Application/FTP]
$ftp_(30) attach-agent $tcp_(30)
$ns at 0.2 "$ftp_(30) start"
$ns at 180.0 "$ftp_(30) stop"

#Set a TCP connection between node_(1) and node_(49)
set tcp_(31) [new Agent/TCP/Newreno]
$tcp_(31) set class_ 2
set sink_(31) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(31)
$ns attach-agent $node_(49) $sink_(31)
$ns connect $tcp_(31) $sink_(31)
set ftp_(31) [new Application/FTP]
$ftp_(31) attach-agent $tcp_(31)
$ns at 180.2 "$ftp_(31) start"
$ns at 360.0 "$ftp_(31) stop"

#Set a TCP connection between node_(94) and node_(93)
set tcp_(32) [new Agent/TCP/Newreno]
$tcp_(32) set class_ 2
set sink_(32) [new Agent/TCPSink]
$ns attach-agent $node_(94) $tcp_(32)
$ns attach-agent $node_(93) $sink_(32)
$ns connect $tcp_(32) $sink_(32)
set ftp_(32) [new Application/FTP]
$ftp_(32) attach-agent $tcp_(32)
$ns at 360.2 "$ftp_(32) start"
$ns at 540.0 "$ftp_(32) stop"

#Set a TCP connection between node_(76) and node_(11)
set tcp_(33) [new Agent/TCP/Newreno]
$tcp_(33) set class_ 2
set sink_(33) [new Agent/TCPSink]
$ns attach-agent $node_(76) $tcp_(33)
$ns attach-agent $node_(11) $sink_(33)
$ns connect $tcp_(33) $sink_(33)
set ftp_(33) [new Application/FTP]
$ftp_(33) attach-agent $tcp_(33)
$ns at 540.2 "$ftp_(33) start"
$ns at 720.0 "$ftp_(33) stop"

#Set a TCP connection between node_(88) and node_(60)
set tcp_(34) [new Agent/TCP/Newreno]
$tcp_(34) set class_ 2
set sink_(34) [new Agent/TCPSink]
$ns attach-agent $node_(88) $tcp_(34)
$ns attach-agent $node_(60) $sink_(34)
$ns connect $tcp_(34) $sink_(34)
set ftp_(34) [new Application/FTP]
$ftp_(34) attach-agent $tcp_(34)
$ns at 720.2 "$ftp_(34) start"
$ns at 900.0 "$ftp_(34) stop"

#Set a TCP connection between node_(39) and node_(91)
set tcp_(35) [new Agent/TCP/Newreno]
$tcp_(35) set class_ 2
set sink_(35) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(35)
$ns attach-agent $node_(91) $sink_(35)
$ns connect $tcp_(35) $sink_(35)
set ftp_(35) [new Application/FTP]
$ftp_(35) attach-agent $tcp_(35)
$ns at 0.2 "$ftp_(35) start"
$ns at 180.0 "$ftp_(35) stop"

#Set a TCP connection between node_(81) and node_(29)
set tcp_(36) [new Agent/TCP/Newreno]
$tcp_(36) set class_ 2
set sink_(36) [new Agent/TCPSink]
$ns attach-agent $node_(81) $tcp_(36)
$ns attach-agent $node_(29) $sink_(36)
$ns connect $tcp_(36) $sink_(36)
set ftp_(36) [new Application/FTP]
$ftp_(36) attach-agent $tcp_(36)
$ns at 180.2 "$ftp_(36) start"
$ns at 360.0 "$ftp_(36) stop"

#Set a TCP connection between node_(40) and node_(73)
set tcp_(37) [new Agent/TCP/Newreno]
$tcp_(37) set class_ 2
set sink_(37) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(37)
$ns attach-agent $node_(73) $sink_(37)
$ns connect $tcp_(37) $sink_(37)
set ftp_(37) [new Application/FTP]
$ftp_(37) attach-agent $tcp_(37)
$ns at 360.2 "$ftp_(37) start"
$ns at 540.0 "$ftp_(37) stop"

#Set a TCP connection between node_(98) and node_(54)
set tcp_(38) [new Agent/TCP/Newreno]
$tcp_(38) set class_ 2
set sink_(38) [new Agent/TCPSink]
$ns attach-agent $node_(98) $tcp_(38)
$ns attach-agent $node_(54) $sink_(38)
$ns connect $tcp_(38) $sink_(38)
set ftp_(38) [new Application/FTP]
$ftp_(38) attach-agent $tcp_(38)
$ns at 540.2 "$ftp_(38) start"
$ns at 720.0 "$ftp_(38) stop"

#Set a TCP connection between node_(94) and node_(62)
set tcp_(39) [new Agent/TCP/Newreno]
$tcp_(39) set class_ 2
set sink_(39) [new Agent/TCPSink]
$ns attach-agent $node_(94) $tcp_(39)
$ns attach-agent $node_(62) $sink_(39)
$ns connect $tcp_(39) $sink_(39)
set ftp_(39) [new Application/FTP]
$ftp_(39) attach-agent $tcp_(39)
$ns at 720.2 "$ftp_(39) start"
$ns at 900.0 "$ftp_(39) stop"

#Set a TCP connection between node_(28) and node_(61)
set tcp_(40) [new Agent/TCP/Newreno]
$tcp_(40) set class_ 2
set sink_(40) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(40)
$ns attach-agent $node_(61) $sink_(40)
$ns connect $tcp_(40) $sink_(40)
set ftp_(40) [new Application/FTP]
$ftp_(40) attach-agent $tcp_(40)
$ns at 0.2 "$ftp_(40) start"
$ns at 180.0 "$ftp_(40) stop"

#Set a TCP connection between node_(45) and node_(74)
set tcp_(41) [new Agent/TCP/Newreno]
$tcp_(41) set class_ 2
set sink_(41) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(41)
$ns attach-agent $node_(74) $sink_(41)
$ns connect $tcp_(41) $sink_(41)
set ftp_(41) [new Application/FTP]
$ftp_(41) attach-agent $tcp_(41)
$ns at 180.2 "$ftp_(41) start"
$ns at 360.0 "$ftp_(41) stop"

#Set a TCP connection between node_(20) and node_(30)
set tcp_(42) [new Agent/TCP/Newreno]
$tcp_(42) set class_ 2
set sink_(42) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(42)
$ns attach-agent $node_(30) $sink_(42)
$ns connect $tcp_(42) $sink_(42)
set ftp_(42) [new Application/FTP]
$ftp_(42) attach-agent $tcp_(42)
$ns at 360.2 "$ftp_(42) start"
$ns at 540.0 "$ftp_(42) stop"

#Set a TCP connection between node_(82) and node_(70)
set tcp_(43) [new Agent/TCP/Newreno]
$tcp_(43) set class_ 2
set sink_(43) [new Agent/TCPSink]
$ns attach-agent $node_(82) $tcp_(43)
$ns attach-agent $node_(70) $sink_(43)
$ns connect $tcp_(43) $sink_(43)
set ftp_(43) [new Application/FTP]
$ftp_(43) attach-agent $tcp_(43)
$ns at 540.2 "$ftp_(43) start"
$ns at 720.0 "$ftp_(43) stop"

#Set a TCP connection between node_(68) and node_(77)
set tcp_(44) [new Agent/TCP/Newreno]
$tcp_(44) set class_ 2
set sink_(44) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(44)
$ns attach-agent $node_(77) $sink_(44)
$ns connect $tcp_(44) $sink_(44)
set ftp_(44) [new Application/FTP]
$ftp_(44) attach-agent $tcp_(44)
$ns at 720.2 "$ftp_(44) start"
$ns at 900.0 "$ftp_(44) stop"

#Set a TCP connection between node_(20) and node_(74)
set tcp_(45) [new Agent/TCP/Newreno]
$tcp_(45) set class_ 2
set sink_(45) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(45)
$ns attach-agent $node_(74) $sink_(45)
$ns connect $tcp_(45) $sink_(45)
set ftp_(45) [new Application/FTP]
$ftp_(45) attach-agent $tcp_(45)
$ns at 0.2 "$ftp_(45) start"
$ns at 180.0 "$ftp_(45) stop"

#Set a TCP connection between node_(34) and node_(51)
set tcp_(46) [new Agent/TCP/Newreno]
$tcp_(46) set class_ 2
set sink_(46) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(46)
$ns attach-agent $node_(51) $sink_(46)
$ns connect $tcp_(46) $sink_(46)
set ftp_(46) [new Application/FTP]
$ftp_(46) attach-agent $tcp_(46)
$ns at 180.2 "$ftp_(46) start"
$ns at 360.0 "$ftp_(46) stop"

#Set a TCP connection between node_(69) and node_(91)
set tcp_(47) [new Agent/TCP/Newreno]
$tcp_(47) set class_ 2
set sink_(47) [new Agent/TCPSink]
$ns attach-agent $node_(69) $tcp_(47)
$ns attach-agent $node_(91) $sink_(47)
$ns connect $tcp_(47) $sink_(47)
set ftp_(47) [new Application/FTP]
$ftp_(47) attach-agent $tcp_(47)
$ns at 360.2 "$ftp_(47) start"
$ns at 540.0 "$ftp_(47) stop"

#Set a TCP connection between node_(96) and node_(40)
set tcp_(48) [new Agent/TCP/Newreno]
$tcp_(48) set class_ 2
set sink_(48) [new Agent/TCPSink]
$ns attach-agent $node_(96) $tcp_(48)
$ns attach-agent $node_(40) $sink_(48)
$ns connect $tcp_(48) $sink_(48)
set ftp_(48) [new Application/FTP]
$ftp_(48) attach-agent $tcp_(48)
$ns at 540.2 "$ftp_(48) start"
$ns at 720.0 "$ftp_(48) stop"

#Set a TCP connection between node_(11) and node_(34)
set tcp_(49) [new Agent/TCP/Newreno]
$tcp_(49) set class_ 2
set sink_(49) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(49)
$ns attach-agent $node_(34) $sink_(49)
$ns connect $tcp_(49) $sink_(49)
set ftp_(49) [new Application/FTP]
$ftp_(49) attach-agent $tcp_(49)
$ns at 720.2 "$ftp_(49) start"
$ns at 900.0 "$ftp_(49) stop"

#Set a TCP connection between node_(38) and node_(86)
set tcp_(50) [new Agent/TCP/Newreno]
$tcp_(50) set class_ 2
set sink_(50) [new Agent/TCPSink]
$ns attach-agent $node_(38) $tcp_(50)
$ns attach-agent $node_(86) $sink_(50)
$ns connect $tcp_(50) $sink_(50)
set ftp_(50) [new Application/FTP]
$ftp_(50) attach-agent $tcp_(50)
$ns at 0.2 "$ftp_(50) start"
$ns at 180.0 "$ftp_(50) stop"

#Set a TCP connection between node_(89) and node_(86)
set tcp_(51) [new Agent/TCP/Newreno]
$tcp_(51) set class_ 2
set sink_(51) [new Agent/TCPSink]
$ns attach-agent $node_(89) $tcp_(51)
$ns attach-agent $node_(86) $sink_(51)
$ns connect $tcp_(51) $sink_(51)
set ftp_(51) [new Application/FTP]
$ftp_(51) attach-agent $tcp_(51)
$ns at 180.2 "$ftp_(51) start"
$ns at 360.0 "$ftp_(51) stop"

#Set a TCP connection between node_(86) and node_(38)
set tcp_(52) [new Agent/TCP/Newreno]
$tcp_(52) set class_ 2
set sink_(52) [new Agent/TCPSink]
$ns attach-agent $node_(86) $tcp_(52)
$ns attach-agent $node_(38) $sink_(52)
$ns connect $tcp_(52) $sink_(52)
set ftp_(52) [new Application/FTP]
$ftp_(52) attach-agent $tcp_(52)
$ns at 360.2 "$ftp_(52) start"
$ns at 540.0 "$ftp_(52) stop"

#Set a TCP connection between node_(68) and node_(87)
set tcp_(53) [new Agent/TCP/Newreno]
$tcp_(53) set class_ 2
set sink_(53) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(53)
$ns attach-agent $node_(87) $sink_(53)
$ns connect $tcp_(53) $sink_(53)
set ftp_(53) [new Application/FTP]
$ftp_(53) attach-agent $tcp_(53)
$ns at 540.2 "$ftp_(53) start"
$ns at 720.0 "$ftp_(53) stop"

#Set a TCP connection between node_(41) and node_(35)
set tcp_(54) [new Agent/TCP/Newreno]
$tcp_(54) set class_ 2
set sink_(54) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(54)
$ns attach-agent $node_(35) $sink_(54)
$ns connect $tcp_(54) $sink_(54)
set ftp_(54) [new Application/FTP]
$ftp_(54) attach-agent $tcp_(54)
$ns at 720.2 "$ftp_(54) start"
$ns at 900.0 "$ftp_(54) stop"

#Set a TCP connection between node_(3) and node_(46)
set tcp_(55) [new Agent/TCP/Newreno]
$tcp_(55) set class_ 2
set sink_(55) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(55)
$ns attach-agent $node_(46) $sink_(55)
$ns connect $tcp_(55) $sink_(55)
set ftp_(55) [new Application/FTP]
$ftp_(55) attach-agent $tcp_(55)
$ns at 0.2 "$ftp_(55) start"
$ns at 180.0 "$ftp_(55) stop"

#Set a TCP connection between node_(96) and node_(82)
set tcp_(56) [new Agent/TCP/Newreno]
$tcp_(56) set class_ 2
set sink_(56) [new Agent/TCPSink]
$ns attach-agent $node_(96) $tcp_(56)
$ns attach-agent $node_(82) $sink_(56)
$ns connect $tcp_(56) $sink_(56)
set ftp_(56) [new Application/FTP]
$ftp_(56) attach-agent $tcp_(56)
$ns at 180.2 "$ftp_(56) start"
$ns at 360.0 "$ftp_(56) stop"

#Set a TCP connection between node_(86) and node_(60)
set tcp_(57) [new Agent/TCP/Newreno]
$tcp_(57) set class_ 2
set sink_(57) [new Agent/TCPSink]
$ns attach-agent $node_(86) $tcp_(57)
$ns attach-agent $node_(60) $sink_(57)
$ns connect $tcp_(57) $sink_(57)
set ftp_(57) [new Application/FTP]
$ftp_(57) attach-agent $tcp_(57)
$ns at 360.2 "$ftp_(57) start"
$ns at 540.0 "$ftp_(57) stop"

#Set a TCP connection between node_(79) and node_(80)
set tcp_(58) [new Agent/TCP/Newreno]
$tcp_(58) set class_ 2
set sink_(58) [new Agent/TCPSink]
$ns attach-agent $node_(79) $tcp_(58)
$ns attach-agent $node_(80) $sink_(58)
$ns connect $tcp_(58) $sink_(58)
set ftp_(58) [new Application/FTP]
$ftp_(58) attach-agent $tcp_(58)
$ns at 540.2 "$ftp_(58) start"
$ns at 720.0 "$ftp_(58) stop"

#Set a TCP connection between node_(20) and node_(24)
set tcp_(59) [new Agent/TCP/Newreno]
$tcp_(59) set class_ 2
set sink_(59) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(59)
$ns attach-agent $node_(24) $sink_(59)
$ns connect $tcp_(59) $sink_(59)
set ftp_(59) [new Application/FTP]
$ftp_(59) attach-agent $tcp_(59)
$ns at 720.2 "$ftp_(59) start"
$ns at 900.0 "$ftp_(59) stop"

#Set a TCP connection between node_(60) and node_(9)
set tcp_(60) [new Agent/TCP/Newreno]
$tcp_(60) set class_ 2
set sink_(60) [new Agent/TCPSink]
$ns attach-agent $node_(60) $tcp_(60)
$ns attach-agent $node_(9) $sink_(60)
$ns connect $tcp_(60) $sink_(60)
set ftp_(60) [new Application/FTP]
$ftp_(60) attach-agent $tcp_(60)
$ns at 0.2 "$ftp_(60) start"
$ns at 180.0 "$ftp_(60) stop"

#Set a TCP connection between node_(39) and node_(61)
set tcp_(61) [new Agent/TCP/Newreno]
$tcp_(61) set class_ 2
set sink_(61) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(61)
$ns attach-agent $node_(61) $sink_(61)
$ns connect $tcp_(61) $sink_(61)
set ftp_(61) [new Application/FTP]
$ftp_(61) attach-agent $tcp_(61)
$ns at 180.2 "$ftp_(61) start"
$ns at 360.0 "$ftp_(61) stop"

#Set a TCP connection between node_(5) and node_(12)
set tcp_(62) [new Agent/TCP/Newreno]
$tcp_(62) set class_ 2
set sink_(62) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(62)
$ns attach-agent $node_(12) $sink_(62)
$ns connect $tcp_(62) $sink_(62)
set ftp_(62) [new Application/FTP]
$ftp_(62) attach-agent $tcp_(62)
$ns at 360.2 "$ftp_(62) start"
$ns at 540.0 "$ftp_(62) stop"

#Set a TCP connection between node_(5) and node_(84)
set tcp_(63) [new Agent/TCP/Newreno]
$tcp_(63) set class_ 2
set sink_(63) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(63)
$ns attach-agent $node_(84) $sink_(63)
$ns connect $tcp_(63) $sink_(63)
set ftp_(63) [new Application/FTP]
$ftp_(63) attach-agent $tcp_(63)
$ns at 540.2 "$ftp_(63) start"
$ns at 720.0 "$ftp_(63) stop"

#Set a TCP connection between node_(58) and node_(70)
set tcp_(64) [new Agent/TCP/Newreno]
$tcp_(64) set class_ 2
set sink_(64) [new Agent/TCPSink]
$ns attach-agent $node_(58) $tcp_(64)
$ns attach-agent $node_(70) $sink_(64)
$ns connect $tcp_(64) $sink_(64)
set ftp_(64) [new Application/FTP]
$ftp_(64) attach-agent $tcp_(64)
$ns at 720.2 "$ftp_(64) start"
$ns at 900.0 "$ftp_(64) stop"

#Set a TCP connection between node_(22) and node_(49)
set tcp_(65) [new Agent/TCP/Newreno]
$tcp_(65) set class_ 2
set sink_(65) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(65)
$ns attach-agent $node_(49) $sink_(65)
$ns connect $tcp_(65) $sink_(65)
set ftp_(65) [new Application/FTP]
$ftp_(65) attach-agent $tcp_(65)
$ns at 0.2 "$ftp_(65) start"
$ns at 180.0 "$ftp_(65) stop"

#Set a TCP connection between node_(9) and node_(49)
set tcp_(66) [new Agent/TCP/Newreno]
$tcp_(66) set class_ 2
set sink_(66) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(66)
$ns attach-agent $node_(49) $sink_(66)
$ns connect $tcp_(66) $sink_(66)
set ftp_(66) [new Application/FTP]
$ftp_(66) attach-agent $tcp_(66)
$ns at 180.2 "$ftp_(66) start"
$ns at 360.0 "$ftp_(66) stop"

#Set a TCP connection between node_(30) and node_(76)
set tcp_(67) [new Agent/TCP/Newreno]
$tcp_(67) set class_ 2
set sink_(67) [new Agent/TCPSink]
$ns attach-agent $node_(30) $tcp_(67)
$ns attach-agent $node_(76) $sink_(67)
$ns connect $tcp_(67) $sink_(67)
set ftp_(67) [new Application/FTP]
$ftp_(67) attach-agent $tcp_(67)
$ns at 360.2 "$ftp_(67) start"
$ns at 540.0 "$ftp_(67) stop"

#Set a TCP connection between node_(27) and node_(48)
set tcp_(68) [new Agent/TCP/Newreno]
$tcp_(68) set class_ 2
set sink_(68) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(68)
$ns attach-agent $node_(48) $sink_(68)
$ns connect $tcp_(68) $sink_(68)
set ftp_(68) [new Application/FTP]
$ftp_(68) attach-agent $tcp_(68)
$ns at 540.2 "$ftp_(68) start"
$ns at 720.0 "$ftp_(68) stop"

#Set a TCP connection between node_(12) and node_(29)
set tcp_(69) [new Agent/TCP/Newreno]
$tcp_(69) set class_ 2
set sink_(69) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(69)
$ns attach-agent $node_(29) $sink_(69)
$ns connect $tcp_(69) $sink_(69)
set ftp_(69) [new Application/FTP]
$ftp_(69) attach-agent $tcp_(69)
$ns at 720.2 "$ftp_(69) start"
$ns at 900.0 "$ftp_(69) stop"

#Set a TCP connection between node_(93) and node_(66)
set tcp_(70) [new Agent/TCP/Newreno]
$tcp_(70) set class_ 2
set sink_(70) [new Agent/TCPSink]
$ns attach-agent $node_(93) $tcp_(70)
$ns attach-agent $node_(66) $sink_(70)
$ns connect $tcp_(70) $sink_(70)
set ftp_(70) [new Application/FTP]
$ftp_(70) attach-agent $tcp_(70)
$ns at 0.2 "$ftp_(70) start"
$ns at 180.0 "$ftp_(70) stop"

#Set a TCP connection between node_(54) and node_(23)
set tcp_(71) [new Agent/TCP/Newreno]
$tcp_(71) set class_ 2
set sink_(71) [new Agent/TCPSink]
$ns attach-agent $node_(54) $tcp_(71)
$ns attach-agent $node_(23) $sink_(71)
$ns connect $tcp_(71) $sink_(71)
set ftp_(71) [new Application/FTP]
$ftp_(71) attach-agent $tcp_(71)
$ns at 180.2 "$ftp_(71) start"
$ns at 360.0 "$ftp_(71) stop"

#Set a TCP connection between node_(48) and node_(7)
set tcp_(72) [new Agent/TCP/Newreno]
$tcp_(72) set class_ 2
set sink_(72) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(72)
$ns attach-agent $node_(7) $sink_(72)
$ns connect $tcp_(72) $sink_(72)
set ftp_(72) [new Application/FTP]
$ftp_(72) attach-agent $tcp_(72)
$ns at 360.2 "$ftp_(72) start"
$ns at 540.0 "$ftp_(72) stop"

#Set a TCP connection between node_(80) and node_(48)
set tcp_(73) [new Agent/TCP/Newreno]
$tcp_(73) set class_ 2
set sink_(73) [new Agent/TCPSink]
$ns attach-agent $node_(80) $tcp_(73)
$ns attach-agent $node_(48) $sink_(73)
$ns connect $tcp_(73) $sink_(73)
set ftp_(73) [new Application/FTP]
$ftp_(73) attach-agent $tcp_(73)
$ns at 540.2 "$ftp_(73) start"
$ns at 720.0 "$ftp_(73) stop"

#Set a TCP connection between node_(10) and node_(98)
set tcp_(74) [new Agent/TCP/Newreno]
$tcp_(74) set class_ 2
set sink_(74) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(74)
$ns attach-agent $node_(98) $sink_(74)
$ns connect $tcp_(74) $sink_(74)
set ftp_(74) [new Application/FTP]
$ftp_(74) attach-agent $tcp_(74)
$ns at 720.2 "$ftp_(74) start"
$ns at 900.0 "$ftp_(74) stop"

#Set a TCP connection between node_(18) and node_(65)
set tcp_(75) [new Agent/TCP/Newreno]
$tcp_(75) set class_ 2
set sink_(75) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(75)
$ns attach-agent $node_(65) $sink_(75)
$ns connect $tcp_(75) $sink_(75)
set ftp_(75) [new Application/FTP]
$ftp_(75) attach-agent $tcp_(75)
$ns at 0.2 "$ftp_(75) start"
$ns at 180.0 "$ftp_(75) stop"

#Set a TCP connection between node_(14) and node_(61)
set tcp_(76) [new Agent/TCP/Newreno]
$tcp_(76) set class_ 2
set sink_(76) [new Agent/TCPSink]
$ns attach-agent $node_(14) $tcp_(76)
$ns attach-agent $node_(61) $sink_(76)
$ns connect $tcp_(76) $sink_(76)
set ftp_(76) [new Application/FTP]
$ftp_(76) attach-agent $tcp_(76)
$ns at 180.2 "$ftp_(76) start"
$ns at 360.0 "$ftp_(76) stop"

#Set a TCP connection between node_(47) and node_(79)
set tcp_(77) [new Agent/TCP/Newreno]
$tcp_(77) set class_ 2
set sink_(77) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(77)
$ns attach-agent $node_(79) $sink_(77)
$ns connect $tcp_(77) $sink_(77)
set ftp_(77) [new Application/FTP]
$ftp_(77) attach-agent $tcp_(77)
$ns at 360.2 "$ftp_(77) start"
$ns at 540.0 "$ftp_(77) stop"

#Set a TCP connection between node_(3) and node_(73)
set tcp_(78) [new Agent/TCP/Newreno]
$tcp_(78) set class_ 2
set sink_(78) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(78)
$ns attach-agent $node_(73) $sink_(78)
$ns connect $tcp_(78) $sink_(78)
set ftp_(78) [new Application/FTP]
$ftp_(78) attach-agent $tcp_(78)
$ns at 540.2 "$ftp_(78) start"
$ns at 720.0 "$ftp_(78) stop"

#Set a TCP connection between node_(14) and node_(22)
set tcp_(79) [new Agent/TCP/Newreno]
$tcp_(79) set class_ 2
set sink_(79) [new Agent/TCPSink]
$ns attach-agent $node_(14) $tcp_(79)
$ns attach-agent $node_(22) $sink_(79)
$ns connect $tcp_(79) $sink_(79)
set ftp_(79) [new Application/FTP]
$ftp_(79) attach-agent $tcp_(79)
$ns at 720.2 "$ftp_(79) start"
$ns at 900.0 "$ftp_(79) stop"

#Set a TCP connection between node_(81) and node_(56)
set tcp_(80) [new Agent/TCP/Newreno]
$tcp_(80) set class_ 2
set sink_(80) [new Agent/TCPSink]
$ns attach-agent $node_(81) $tcp_(80)
$ns attach-agent $node_(56) $sink_(80)
$ns connect $tcp_(80) $sink_(80)
set ftp_(80) [new Application/FTP]
$ftp_(80) attach-agent $tcp_(80)
$ns at 0.2 "$ftp_(80) start"
$ns at 180.0 "$ftp_(80) stop"

#Set a TCP connection between node_(39) and node_(24)
set tcp_(81) [new Agent/TCP/Newreno]
$tcp_(81) set class_ 2
set sink_(81) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(81)
$ns attach-agent $node_(24) $sink_(81)
$ns connect $tcp_(81) $sink_(81)
set ftp_(81) [new Application/FTP]
$ftp_(81) attach-agent $tcp_(81)
$ns at 180.2 "$ftp_(81) start"
$ns at 360.0 "$ftp_(81) stop"

#Set a TCP connection between node_(50) and node_(4)
set tcp_(82) [new Agent/TCP/Newreno]
$tcp_(82) set class_ 2
set sink_(82) [new Agent/TCPSink]
$ns attach-agent $node_(50) $tcp_(82)
$ns attach-agent $node_(4) $sink_(82)
$ns connect $tcp_(82) $sink_(82)
set ftp_(82) [new Application/FTP]
$ftp_(82) attach-agent $tcp_(82)
$ns at 360.2 "$ftp_(82) start"
$ns at 540.0 "$ftp_(82) stop"

#Set a TCP connection between node_(57) and node_(44)
set tcp_(83) [new Agent/TCP/Newreno]
$tcp_(83) set class_ 2
set sink_(83) [new Agent/TCPSink]
$ns attach-agent $node_(57) $tcp_(83)
$ns attach-agent $node_(44) $sink_(83)
$ns connect $tcp_(83) $sink_(83)
set ftp_(83) [new Application/FTP]
$ftp_(83) attach-agent $tcp_(83)
$ns at 540.2 "$ftp_(83) start"
$ns at 720.0 "$ftp_(83) stop"

#Set a TCP connection between node_(41) and node_(57)
set tcp_(84) [new Agent/TCP/Newreno]
$tcp_(84) set class_ 2
set sink_(84) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(84)
$ns attach-agent $node_(57) $sink_(84)
$ns connect $tcp_(84) $sink_(84)
set ftp_(84) [new Application/FTP]
$ftp_(84) attach-agent $tcp_(84)
$ns at 720.2 "$ftp_(84) start"
$ns at 900.0 "$ftp_(84) stop"

#Set a TCP connection between node_(97) and node_(72)
set tcp_(85) [new Agent/TCP/Newreno]
$tcp_(85) set class_ 2
set sink_(85) [new Agent/TCPSink]
$ns attach-agent $node_(97) $tcp_(85)
$ns attach-agent $node_(72) $sink_(85)
$ns connect $tcp_(85) $sink_(85)
set ftp_(85) [new Application/FTP]
$ftp_(85) attach-agent $tcp_(85)
$ns at 0.2 "$ftp_(85) start"
$ns at 180.0 "$ftp_(85) stop"

#Set a TCP connection between node_(88) and node_(38)
set tcp_(86) [new Agent/TCP/Newreno]
$tcp_(86) set class_ 2
set sink_(86) [new Agent/TCPSink]
$ns attach-agent $node_(88) $tcp_(86)
$ns attach-agent $node_(38) $sink_(86)
$ns connect $tcp_(86) $sink_(86)
set ftp_(86) [new Application/FTP]
$ftp_(86) attach-agent $tcp_(86)
$ns at 180.2 "$ftp_(86) start"
$ns at 360.0 "$ftp_(86) stop"

#Set a TCP connection between node_(54) and node_(74)
set tcp_(87) [new Agent/TCP/Newreno]
$tcp_(87) set class_ 2
set sink_(87) [new Agent/TCPSink]
$ns attach-agent $node_(54) $tcp_(87)
$ns attach-agent $node_(74) $sink_(87)
$ns connect $tcp_(87) $sink_(87)
set ftp_(87) [new Application/FTP]
$ftp_(87) attach-agent $tcp_(87)
$ns at 360.2 "$ftp_(87) start"
$ns at 540.0 "$ftp_(87) stop"

#Set a TCP connection between node_(74) and node_(93)
set tcp_(88) [new Agent/TCP/Newreno]
$tcp_(88) set class_ 2
set sink_(88) [new Agent/TCPSink]
$ns attach-agent $node_(74) $tcp_(88)
$ns attach-agent $node_(93) $sink_(88)
$ns connect $tcp_(88) $sink_(88)
set ftp_(88) [new Application/FTP]
$ftp_(88) attach-agent $tcp_(88)
$ns at 540.2 "$ftp_(88) start"
$ns at 720.0 "$ftp_(88) stop"

#Set a TCP connection between node_(66) and node_(95)
set tcp_(89) [new Agent/TCP/Newreno]
$tcp_(89) set class_ 2
set sink_(89) [new Agent/TCPSink]
$ns attach-agent $node_(66) $tcp_(89)
$ns attach-agent $node_(95) $sink_(89)
$ns connect $tcp_(89) $sink_(89)
set ftp_(89) [new Application/FTP]
$ftp_(89) attach-agent $tcp_(89)
$ns at 720.2 "$ftp_(89) start"
$ns at 900.0 "$ftp_(89) stop"

#Set a TCP connection between node_(43) and node_(55)
set tcp_(90) [new Agent/TCP/Newreno]
$tcp_(90) set class_ 2
set sink_(90) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(90)
$ns attach-agent $node_(55) $sink_(90)
$ns connect $tcp_(90) $sink_(90)
set ftp_(90) [new Application/FTP]
$ftp_(90) attach-agent $tcp_(90)
$ns at 0.2 "$ftp_(90) start"
$ns at 180.0 "$ftp_(90) stop"

#Set a TCP connection between node_(72) and node_(46)
set tcp_(91) [new Agent/TCP/Newreno]
$tcp_(91) set class_ 2
set sink_(91) [new Agent/TCPSink]
$ns attach-agent $node_(72) $tcp_(91)
$ns attach-agent $node_(46) $sink_(91)
$ns connect $tcp_(91) $sink_(91)
set ftp_(91) [new Application/FTP]
$ftp_(91) attach-agent $tcp_(91)
$ns at 180.2 "$ftp_(91) start"
$ns at 360.0 "$ftp_(91) stop"

#Set a TCP connection between node_(83) and node_(38)
set tcp_(92) [new Agent/TCP/Newreno]
$tcp_(92) set class_ 2
set sink_(92) [new Agent/TCPSink]
$ns attach-agent $node_(83) $tcp_(92)
$ns attach-agent $node_(38) $sink_(92)
$ns connect $tcp_(92) $sink_(92)
set ftp_(92) [new Application/FTP]
$ftp_(92) attach-agent $tcp_(92)
$ns at 360.2 "$ftp_(92) start"
$ns at 540.0 "$ftp_(92) stop"

#Set a TCP connection between node_(18) and node_(63)
set tcp_(93) [new Agent/TCP/Newreno]
$tcp_(93) set class_ 2
set sink_(93) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(93)
$ns attach-agent $node_(63) $sink_(93)
$ns connect $tcp_(93) $sink_(93)
set ftp_(93) [new Application/FTP]
$ftp_(93) attach-agent $tcp_(93)
$ns at 540.2 "$ftp_(93) start"
$ns at 720.0 "$ftp_(93) stop"

#Set a TCP connection between node_(28) and node_(29)
set tcp_(94) [new Agent/TCP/Newreno]
$tcp_(94) set class_ 2
set sink_(94) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(94)
$ns attach-agent $node_(29) $sink_(94)
$ns connect $tcp_(94) $sink_(94)
set ftp_(94) [new Application/FTP]
$ftp_(94) attach-agent $tcp_(94)
$ns at 720.2 "$ftp_(94) start"
$ns at 900.0 "$ftp_(94) stop"

#Set a TCP connection between node_(36) and node_(75)
set tcp_(95) [new Agent/TCP/Newreno]
$tcp_(95) set class_ 2
set sink_(95) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(95)
$ns attach-agent $node_(75) $sink_(95)
$ns connect $tcp_(95) $sink_(95)
set ftp_(95) [new Application/FTP]
$ftp_(95) attach-agent $tcp_(95)
$ns at 0.2 "$ftp_(95) start"
$ns at 180.0 "$ftp_(95) stop"

#Set a TCP connection between node_(89) and node_(84)
set tcp_(96) [new Agent/TCP/Newreno]
$tcp_(96) set class_ 2
set sink_(96) [new Agent/TCPSink]
$ns attach-agent $node_(89) $tcp_(96)
$ns attach-agent $node_(84) $sink_(96)
$ns connect $tcp_(96) $sink_(96)
set ftp_(96) [new Application/FTP]
$ftp_(96) attach-agent $tcp_(96)
$ns at 180.2 "$ftp_(96) start"
$ns at 360.0 "$ftp_(96) stop"

#Set a TCP connection between node_(32) and node_(9)
set tcp_(97) [new Agent/TCP/Newreno]
$tcp_(97) set class_ 2
set sink_(97) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(97)
$ns attach-agent $node_(9) $sink_(97)
$ns connect $tcp_(97) $sink_(97)
set ftp_(97) [new Application/FTP]
$ftp_(97) attach-agent $tcp_(97)
$ns at 360.2 "$ftp_(97) start"
$ns at 540.0 "$ftp_(97) stop"

#Set a TCP connection between node_(70) and node_(33)
set tcp_(98) [new Agent/TCP/Newreno]
$tcp_(98) set class_ 2
set sink_(98) [new Agent/TCPSink]
$ns attach-agent $node_(70) $tcp_(98)
$ns attach-agent $node_(33) $sink_(98)
$ns connect $tcp_(98) $sink_(98)
set ftp_(98) [new Application/FTP]
$ftp_(98) attach-agent $tcp_(98)
$ns at 540.2 "$ftp_(98) start"
$ns at 720.0 "$ftp_(98) stop"

#Set a TCP connection between node_(4) and node_(32)
set tcp_(99) [new Agent/TCP/Newreno]
$tcp_(99) set class_ 2
set sink_(99) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(99)
$ns attach-agent $node_(32) $sink_(99)
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
