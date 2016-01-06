#sim-scn2-6.tcl 
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
set tracefd       [open sim-scn2-6-$val(rp)-trace.tr w]
set windowVsTime2 [open sim-scn2-6-$val(rp)-win-.tr w]
set namtrace      [open sim-scn2-6-$val(rp).nam w]

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
$node_(0) set X_ 1220 
$node_(0) set Y_ 845 
$node_(0) set Z_ 0.0 
$node_(1) set X_ 329 
$node_(1) set Y_ 350 
$node_(1) set Z_ 0.0 
$node_(2) set X_ 2321 
$node_(2) set Y_ 58 
$node_(2) set Z_ 0.0 
$node_(3) set X_ 1294 
$node_(3) set Y_ 395 
$node_(3) set Z_ 0.0 
$node_(4) set X_ 662 
$node_(4) set Y_ 667 
$node_(4) set Z_ 0.0 
$node_(5) set X_ 1524 
$node_(5) set Y_ 985 
$node_(5) set Z_ 0.0 
$node_(6) set X_ 2084 
$node_(6) set Y_ 395 
$node_(6) set Z_ 0.0 
$node_(7) set X_ 266 
$node_(7) set Y_ 506 
$node_(7) set Z_ 0.0 
$node_(8) set X_ 66 
$node_(8) set Y_ 846 
$node_(8) set Z_ 0.0 
$node_(9) set X_ 1432 
$node_(9) set Y_ 644 
$node_(9) set Z_ 0.0 
$node_(10) set X_ 2452 
$node_(10) set Y_ 66 
$node_(10) set Z_ 0.0 
$node_(11) set X_ 2027 
$node_(11) set Y_ 983 
$node_(11) set Z_ 0.0 
$node_(12) set X_ 168 
$node_(12) set Y_ 263 
$node_(12) set Z_ 0.0 
$node_(13) set X_ 8 
$node_(13) set Y_ 238 
$node_(13) set Z_ 0.0 
$node_(14) set X_ 1851 
$node_(14) set Y_ 242 
$node_(14) set Z_ 0.0 
$node_(15) set X_ 1323 
$node_(15) set Y_ 25 
$node_(15) set Z_ 0.0 
$node_(16) set X_ 1400 
$node_(16) set Y_ 861 
$node_(16) set Z_ 0.0 
$node_(17) set X_ 2712 
$node_(17) set Y_ 529 
$node_(17) set Z_ 0.0 
$node_(18) set X_ 2785 
$node_(18) set Y_ 214 
$node_(18) set Z_ 0.0 
$node_(19) set X_ 1402 
$node_(19) set Y_ 35 
$node_(19) set Z_ 0.0 
$node_(20) set X_ 1966 
$node_(20) set Y_ 301 
$node_(20) set Z_ 0.0 
$node_(21) set X_ 1083 
$node_(21) set Y_ 55 
$node_(21) set Z_ 0.0 
$node_(22) set X_ 1520 
$node_(22) set Y_ 676 
$node_(22) set Z_ 0.0 
$node_(23) set X_ 544 
$node_(23) set Y_ 697 
$node_(23) set Z_ 0.0 
$node_(24) set X_ 1573 
$node_(24) set Y_ 919 
$node_(24) set Z_ 0.0 
$node_(25) set X_ 1035 
$node_(25) set Y_ 997 
$node_(25) set Z_ 0.0 
$node_(26) set X_ 1764 
$node_(26) set Y_ 817 
$node_(26) set Z_ 0.0 
$node_(27) set X_ 876 
$node_(27) set Y_ 175 
$node_(27) set Z_ 0.0 
$node_(28) set X_ 447 
$node_(28) set Y_ 821 
$node_(28) set Z_ 0.0 
$node_(29) set X_ 929 
$node_(29) set Y_ 154 
$node_(29) set Z_ 0.0 
$node_(30) set X_ 1878 
$node_(30) set Y_ 685 
$node_(30) set Z_ 0.0 
$node_(31) set X_ 433 
$node_(31) set Y_ 217 
$node_(31) set Z_ 0.0 
$node_(32) set X_ 2057 
$node_(32) set Y_ 193 
$node_(32) set Z_ 0.0 
$node_(33) set X_ 2295 
$node_(33) set Y_ 416 
$node_(33) set Z_ 0.0 
$node_(34) set X_ 1892 
$node_(34) set Y_ 529 
$node_(34) set Z_ 0.0 
$node_(35) set X_ 2174 
$node_(35) set Y_ 149 
$node_(35) set Z_ 0.0 
$node_(36) set X_ 1678 
$node_(36) set Y_ 162 
$node_(36) set Z_ 0.0 
$node_(37) set X_ 1772 
$node_(37) set Y_ 373 
$node_(37) set Z_ 0.0 
$node_(38) set X_ 2351 
$node_(38) set Y_ 74 
$node_(38) set Z_ 0.0 
$node_(39) set X_ 2430 
$node_(39) set Y_ 77 
$node_(39) set Z_ 0.0 
$node_(40) set X_ 717 
$node_(40) set Y_ 789 
$node_(40) set Z_ 0.0 
$node_(41) set X_ 610 
$node_(41) set Y_ 961 
$node_(41) set Z_ 0.0 
$node_(42) set X_ 779 
$node_(42) set Y_ 939 
$node_(42) set Z_ 0.0 
$node_(43) set X_ 2992 
$node_(43) set Y_ 764 
$node_(43) set Z_ 0.0 
$node_(44) set X_ 443 
$node_(44) set Y_ 25 
$node_(44) set Z_ 0.0 
$node_(45) set X_ 2831 
$node_(45) set Y_ 287 
$node_(45) set Z_ 0.0 
$node_(46) set X_ 1272 
$node_(46) set Y_ 652 
$node_(46) set Z_ 0.0 
$node_(47) set X_ 1800 
$node_(47) set Y_ 999 
$node_(47) set Z_ 0.0 
$node_(48) set X_ 1517 
$node_(48) set Y_ 714 
$node_(48) set Z_ 0.0 
$node_(49) set X_ 886 
$node_(49) set Y_ 27 
$node_(49) set Z_ 0.0 
$node_(50) set X_ 2509 
$node_(50) set Y_ 973 
$node_(50) set Z_ 0.0 
$node_(51) set X_ 1960 
$node_(51) set Y_ 442 
$node_(51) set Z_ 0.0 
$ns at 0.0 "$node_(51) off" 
$ns at 165.0 "$node_(51) on" 
$node_(52) set X_ 488 
$node_(52) set Y_ 971 
$node_(52) set Z_ 0.0 
$ns at 0.0 "$node_(52) off" 
$ns at 165.0 "$node_(52) on" 
$node_(53) set X_ 2386 
$node_(53) set Y_ 46 
$node_(53) set Z_ 0.0 
$ns at 0.0 "$node_(53) off" 
$ns at 165.0 "$node_(53) on" 
$node_(54) set X_ 2211 
$node_(54) set Y_ 477 
$node_(54) set Z_ 0.0 
$ns at 0.0 "$node_(54) off" 
$ns at 165.0 "$node_(54) on" 
$node_(55) set X_ 1535 
$node_(55) set Y_ 234 
$node_(55) set Z_ 0.0 
$ns at 0.0 "$node_(55) off" 
$ns at 165.0 "$node_(55) on" 
$node_(56) set X_ 2156 
$node_(56) set Y_ 522 
$node_(56) set Z_ 0.0 
$ns at 0.0 "$node_(56) off" 
$ns at 165.0 "$node_(56) on" 
$node_(57) set X_ 2266 
$node_(57) set Y_ 130 
$node_(57) set Z_ 0.0 
$ns at 0.0 "$node_(57) off" 
$ns at 165.0 "$node_(57) on" 
$node_(58) set X_ 2808 
$node_(58) set Y_ 604 
$node_(58) set Z_ 0.0 
$ns at 0.0 "$node_(58) off" 
$ns at 165.0 "$node_(58) on" 
$node_(59) set X_ 2348 
$node_(59) set Y_ 888 
$node_(59) set Z_ 0.0 
$ns at 0.0 "$node_(59) off" 
$ns at 165.0 "$node_(59) on" 
$node_(60) set X_ 1434 
$node_(60) set Y_ 836 
$node_(60) set Z_ 0.0 
$ns at 0.0 "$node_(60) off" 
$ns at 165.0 "$node_(60) on" 
$node_(61) set X_ 460 
$node_(61) set Y_ 970 
$node_(61) set Z_ 0.0 
$ns at 0.0 "$node_(61) off" 
$ns at 165.0 "$node_(61) on" 
$node_(62) set X_ 863 
$node_(62) set Y_ 644 
$node_(62) set Z_ 0.0 
$ns at 0.0 "$node_(62) off" 
$ns at 165.0 "$node_(62) on" 
$node_(63) set X_ 1739 
$node_(63) set Y_ 222 
$node_(63) set Z_ 0.0 
$ns at 0.0 "$node_(63) off" 
$ns at 165.0 "$node_(63) on" 
$node_(64) set X_ 146 
$node_(64) set Y_ 130 
$node_(64) set Z_ 0.0 
$ns at 0.0 "$node_(64) off" 
$ns at 165.0 "$node_(64) on" 
$node_(65) set X_ 930 
$node_(65) set Y_ 806 
$node_(65) set Z_ 0.0 
$ns at 0.0 "$node_(65) off" 
$ns at 165.0 "$node_(65) on" 
$node_(66) set X_ 519 
$node_(66) set Y_ 348 
$node_(66) set Z_ 0.0 
$ns at 0.0 "$node_(66) off" 
$ns at 165.0 "$node_(66) on" 
$node_(67) set X_ 1011 
$node_(67) set Y_ 368 
$node_(67) set Z_ 0.0 
$ns at 0.0 "$node_(67) off" 
$ns at 165.0 "$node_(67) on" 
$node_(68) set X_ 1879 
$node_(68) set Y_ 579 
$node_(68) set Z_ 0.0 
$ns at 0.0 "$node_(68) off" 
$ns at 165.0 "$node_(68) on" 
$node_(69) set X_ 634 
$node_(69) set Y_ 364 
$node_(69) set Z_ 0.0 
$ns at 0.0 "$node_(69) off" 
$ns at 165.0 "$node_(69) on" 
$node_(70) set X_ 1989 
$node_(70) set Y_ 130 
$node_(70) set Z_ 0.0 
$ns at 0.0 "$node_(70) off" 
$ns at 165.0 "$node_(70) on" 
$node_(71) set X_ 2013 
$node_(71) set Y_ 114 
$node_(71) set Z_ 0.0 
$ns at 0.0 "$node_(71) off" 
$ns at 165.0 "$node_(71) on" 
$node_(72) set X_ 817 
$node_(72) set Y_ 316 
$node_(72) set Z_ 0.0 
$ns at 0.0 "$node_(72) off" 
$ns at 165.0 "$node_(72) on" 
$node_(73) set X_ 1785 
$node_(73) set Y_ 985 
$node_(73) set Z_ 0.0 
$ns at 0.0 "$node_(73) off" 
$ns at 165.0 "$node_(73) on" 
$node_(74) set X_ 891 
$node_(74) set Y_ 73 
$node_(74) set Z_ 0.0 
$ns at 0.0 "$node_(74) off" 
$ns at 165.0 "$node_(74) on" 
$node_(75) set X_ 90 
$node_(75) set Y_ 103 
$node_(75) set Z_ 0.0 
$ns at 0.0 "$node_(75) off" 
$ns at 330.0 "$node_(75) on" 
$node_(76) set X_ 2188 
$node_(76) set Y_ 51 
$node_(76) set Z_ 0.0 
$ns at 0.0 "$node_(76) off" 
$ns at 330.0 "$node_(76) on" 
$node_(77) set X_ 475 
$node_(77) set Y_ 88 
$node_(77) set Z_ 0.0 
$ns at 0.0 "$node_(77) off" 
$ns at 330.0 "$node_(77) on" 
$node_(78) set X_ 1923 
$node_(78) set Y_ 182 
$node_(78) set Z_ 0.0 
$ns at 0.0 "$node_(78) off" 
$ns at 330.0 "$node_(78) on" 
$node_(79) set X_ 345 
$node_(79) set Y_ 662 
$node_(79) set Z_ 0.0 
$ns at 0.0 "$node_(79) off" 
$ns at 330.0 "$node_(79) on" 
$node_(80) set X_ 1753 
$node_(80) set Y_ 391 
$node_(80) set Z_ 0.0 
$ns at 0.0 "$node_(80) off" 
$ns at 330.0 "$node_(80) on" 
$node_(81) set X_ 1515 
$node_(81) set Y_ 366 
$node_(81) set Z_ 0.0 
$ns at 0.0 "$node_(81) off" 
$ns at 330.0 "$node_(81) on" 
$node_(82) set X_ 179 
$node_(82) set Y_ 604 
$node_(82) set Z_ 0.0 
$ns at 0.0 "$node_(82) off" 
$ns at 330.0 "$node_(82) on" 
$node_(83) set X_ 954 
$node_(83) set Y_ 276 
$node_(83) set Z_ 0.0 
$ns at 0.0 "$node_(83) off" 
$ns at 330.0 "$node_(83) on" 
$node_(84) set X_ 2458 
$node_(84) set Y_ 193 
$node_(84) set Z_ 0.0 
$ns at 0.0 "$node_(84) off" 
$ns at 330.0 "$node_(84) on" 
$node_(85) set X_ 2083 
$node_(85) set Y_ 353 
$node_(85) set Z_ 0.0 
$ns at 0.0 "$node_(85) off" 
$ns at 330.0 "$node_(85) on" 
$node_(86) set X_ 1130 
$node_(86) set Y_ 765 
$node_(86) set Z_ 0.0 
$ns at 0.0 "$node_(86) off" 
$ns at 330.0 "$node_(86) on" 
$node_(87) set X_ 1976 
$node_(87) set Y_ 972 
$node_(87) set Z_ 0.0 
$ns at 0.0 "$node_(87) off" 
$ns at 330.0 "$node_(87) on" 
$node_(88) set X_ 174 
$node_(88) set Y_ 541 
$node_(88) set Z_ 0.0 
$ns at 0.0 "$node_(88) off" 
$ns at 330.0 "$node_(88) on" 
$node_(89) set X_ 1504 
$node_(89) set Y_ 267 
$node_(89) set Z_ 0.0 
$ns at 0.0 "$node_(89) off" 
$ns at 330.0 "$node_(89) on" 
$node_(90) set X_ 1038 
$node_(90) set Y_ 630 
$node_(90) set Z_ 0.0 
$ns at 0.0 "$node_(90) off" 
$ns at 330.0 "$node_(90) on" 
$node_(91) set X_ 2886 
$node_(91) set Y_ 150 
$node_(91) set Z_ 0.0 
$ns at 0.0 "$node_(91) off" 
$ns at 330.0 "$node_(91) on" 
$node_(92) set X_ 173 
$node_(92) set Y_ 156 
$node_(92) set Z_ 0.0 
$ns at 0.0 "$node_(92) off" 
$ns at 330.0 "$node_(92) on" 
$node_(93) set X_ 2270 
$node_(93) set Y_ 259 
$node_(93) set Z_ 0.0 
$ns at 0.0 "$node_(93) off" 
$ns at 330.0 "$node_(93) on" 
$node_(94) set X_ 333 
$node_(94) set Y_ 554 
$node_(94) set Z_ 0.0 
$ns at 0.0 "$node_(94) off" 
$ns at 330.0 "$node_(94) on" 
$node_(95) set X_ 786 
$node_(95) set Y_ 610 
$node_(95) set Z_ 0.0 
$ns at 0.0 "$node_(95) off" 
$ns at 330.0 "$node_(95) on" 
$node_(96) set X_ 734 
$node_(96) set Y_ 354 
$node_(96) set Z_ 0.0 
$ns at 0.0 "$node_(96) off" 
$ns at 330.0 "$node_(96) on" 
$node_(97) set X_ 1132 
$node_(97) set Y_ 476 
$node_(97) set Z_ 0.0 
$ns at 0.0 "$node_(97) off" 
$ns at 330.0 "$node_(97) on" 
$node_(98) set X_ 244 
$node_(98) set Y_ 410 
$node_(98) set Z_ 0.0 
$ns at 0.0 "$node_(98) off" 
$ns at 330.0 "$node_(98) on" 
$node_(99) set X_ 2022 
$node_(99) set Y_ 805 
$node_(99) set Z_ 0.0 
$ns at 0.0 "$node_(99) off" 
$ns at 330.0 "$node_(99) on" 
$node_(100) set X_ 1041 
$node_(100) set Y_ 850 
$node_(100) set Z_ 0.0 
$ns at 0.0 "$node_(100) off" 
$ns at 495.0 "$node_(100) on" 
$node_(101) set X_ 2849 
$node_(101) set Y_ 575 
$node_(101) set Z_ 0.0 
$ns at 0.0 "$node_(101) off" 
$ns at 495.0 "$node_(101) on" 
$node_(102) set X_ 2688 
$node_(102) set Y_ 980 
$node_(102) set Z_ 0.0 
$ns at 0.0 "$node_(102) off" 
$ns at 495.0 "$node_(102) on" 
$node_(103) set X_ 656 
$node_(103) set Y_ 589 
$node_(103) set Z_ 0.0 
$ns at 0.0 "$node_(103) off" 
$ns at 495.0 "$node_(103) on" 
$node_(104) set X_ 1270 
$node_(104) set Y_ 18 
$node_(104) set Z_ 0.0 
$ns at 0.0 "$node_(104) off" 
$ns at 495.0 "$node_(104) on" 
$node_(105) set X_ 2943 
$node_(105) set Y_ 583 
$node_(105) set Z_ 0.0 
$ns at 0.0 "$node_(105) off" 
$ns at 495.0 "$node_(105) on" 
$node_(106) set X_ 1213 
$node_(106) set Y_ 782 
$node_(106) set Z_ 0.0 
$ns at 0.0 "$node_(106) off" 
$ns at 495.0 "$node_(106) on" 
$node_(107) set X_ 1026 
$node_(107) set Y_ 979 
$node_(107) set Z_ 0.0 
$ns at 0.0 "$node_(107) off" 
$ns at 495.0 "$node_(107) on" 
$node_(108) set X_ 2515 
$node_(108) set Y_ 419 
$node_(108) set Z_ 0.0 
$ns at 0.0 "$node_(108) off" 
$ns at 495.0 "$node_(108) on" 
$node_(109) set X_ 547 
$node_(109) set Y_ 253 
$node_(109) set Z_ 0.0 
$ns at 0.0 "$node_(109) off" 
$ns at 495.0 "$node_(109) on" 
$node_(110) set X_ 2521 
$node_(110) set Y_ 826 
$node_(110) set Z_ 0.0 
$ns at 0.0 "$node_(110) off" 
$ns at 495.0 "$node_(110) on" 
$node_(111) set X_ 339 
$node_(111) set Y_ 700 
$node_(111) set Z_ 0.0 
$ns at 0.0 "$node_(111) off" 
$ns at 495.0 "$node_(111) on" 
$node_(112) set X_ 2970 
$node_(112) set Y_ 693 
$node_(112) set Z_ 0.0 
$ns at 0.0 "$node_(112) off" 
$ns at 495.0 "$node_(112) on" 
$node_(113) set X_ 1180 
$node_(113) set Y_ 302 
$node_(113) set Z_ 0.0 
$ns at 0.0 "$node_(113) off" 
$ns at 495.0 "$node_(113) on" 
$node_(114) set X_ 1830 
$node_(114) set Y_ 971 
$node_(114) set Z_ 0.0 
$ns at 0.0 "$node_(114) off" 
$ns at 495.0 "$node_(114) on" 
$node_(115) set X_ 1025 
$node_(115) set Y_ 531 
$node_(115) set Z_ 0.0 
$ns at 0.0 "$node_(115) off" 
$ns at 495.0 "$node_(115) on" 
$node_(116) set X_ 2494 
$node_(116) set Y_ 138 
$node_(116) set Z_ 0.0 
$ns at 0.0 "$node_(116) off" 
$ns at 495.0 "$node_(116) on" 
$node_(117) set X_ 45 
$node_(117) set Y_ 182 
$node_(117) set Z_ 0.0 
$ns at 0.0 "$node_(117) off" 
$ns at 495.0 "$node_(117) on" 
$node_(118) set X_ 1130 
$node_(118) set Y_ 871 
$node_(118) set Z_ 0.0 
$ns at 0.0 "$node_(118) off" 
$ns at 495.0 "$node_(118) on" 
$node_(119) set X_ 319 
$node_(119) set Y_ 724 
$node_(119) set Z_ 0.0 
$ns at 0.0 "$node_(119) off" 
$ns at 495.0 "$node_(119) on" 
$node_(120) set X_ 1486 
$node_(120) set Y_ 563 
$node_(120) set Z_ 0.0 
$ns at 0.0 "$node_(120) off" 
$ns at 495.0 "$node_(120) on" 
$node_(121) set X_ 193 
$node_(121) set Y_ 279 
$node_(121) set Z_ 0.0 
$ns at 0.0 "$node_(121) off" 
$ns at 495.0 "$node_(121) on" 
$node_(122) set X_ 1087 
$node_(122) set Y_ 697 
$node_(122) set Z_ 0.0 
$ns at 0.0 "$node_(122) off" 
$ns at 495.0 "$node_(122) on" 
$node_(123) set X_ 1273 
$node_(123) set Y_ 14 
$node_(123) set Z_ 0.0 
$ns at 0.0 "$node_(123) off" 
$ns at 495.0 "$node_(123) on" 
$node_(124) set X_ 1711 
$node_(124) set Y_ 242 
$node_(124) set Z_ 0.0 
$ns at 0.0 "$node_(124) off" 
$ns at 495.0 "$node_(124) on" 
$node_(125) set X_ 630 
$node_(125) set Y_ 677 
$node_(125) set Z_ 0.0 
$ns at 0.0 "$node_(125) off" 
$ns at 660.0 "$node_(125) on" 
$node_(126) set X_ 135 
$node_(126) set Y_ 93 
$node_(126) set Z_ 0.0 
$ns at 0.0 "$node_(126) off" 
$ns at 660.0 "$node_(126) on" 
$node_(127) set X_ 174 
$node_(127) set Y_ 994 
$node_(127) set Z_ 0.0 
$ns at 0.0 "$node_(127) off" 
$ns at 660.0 "$node_(127) on" 
$node_(128) set X_ 2474 
$node_(128) set Y_ 61 
$node_(128) set Z_ 0.0 
$ns at 0.0 "$node_(128) off" 
$ns at 660.0 "$node_(128) on" 
$node_(129) set X_ 1222 
$node_(129) set Y_ 894 
$node_(129) set Z_ 0.0 
$ns at 0.0 "$node_(129) off" 
$ns at 660.0 "$node_(129) on" 
$node_(130) set X_ 2030 
$node_(130) set Y_ 90 
$node_(130) set Z_ 0.0 
$ns at 0.0 "$node_(130) off" 
$ns at 660.0 "$node_(130) on" 
$node_(131) set X_ 2078 
$node_(131) set Y_ 861 
$node_(131) set Z_ 0.0 
$ns at 0.0 "$node_(131) off" 
$ns at 660.0 "$node_(131) on" 
$node_(132) set X_ 1309 
$node_(132) set Y_ 174 
$node_(132) set Z_ 0.0 
$ns at 0.0 "$node_(132) off" 
$ns at 660.0 "$node_(132) on" 
$node_(133) set X_ 2975 
$node_(133) set Y_ 215 
$node_(133) set Z_ 0.0 
$ns at 0.0 "$node_(133) off" 
$ns at 660.0 "$node_(133) on" 
$node_(134) set X_ 893 
$node_(134) set Y_ 911 
$node_(134) set Z_ 0.0 
$ns at 0.0 "$node_(134) off" 
$ns at 660.0 "$node_(134) on" 
$node_(135) set X_ 2928 
$node_(135) set Y_ 825 
$node_(135) set Z_ 0.0 
$ns at 0.0 "$node_(135) off" 
$ns at 660.0 "$node_(135) on" 
$node_(136) set X_ 69 
$node_(136) set Y_ 769 
$node_(136) set Z_ 0.0 
$ns at 0.0 "$node_(136) off" 
$ns at 660.0 "$node_(136) on" 
$node_(137) set X_ 1043 
$node_(137) set Y_ 546 
$node_(137) set Z_ 0.0 
$ns at 0.0 "$node_(137) off" 
$ns at 660.0 "$node_(137) on" 
$node_(138) set X_ 518 
$node_(138) set Y_ 896 
$node_(138) set Z_ 0.0 
$ns at 0.0 "$node_(138) off" 
$ns at 660.0 "$node_(138) on" 
$node_(139) set X_ 463 
$node_(139) set Y_ 681 
$node_(139) set Z_ 0.0 
$ns at 0.0 "$node_(139) off" 
$ns at 660.0 "$node_(139) on" 
$node_(140) set X_ 87 
$node_(140) set Y_ 761 
$node_(140) set Z_ 0.0 
$ns at 0.0 "$node_(140) off" 
$ns at 660.0 "$node_(140) on" 
$node_(141) set X_ 1537 
$node_(141) set Y_ 898 
$node_(141) set Z_ 0.0 
$ns at 0.0 "$node_(141) off" 
$ns at 660.0 "$node_(141) on" 
$node_(142) set X_ 2473 
$node_(142) set Y_ 988 
$node_(142) set Z_ 0.0 
$ns at 0.0 "$node_(142) off" 
$ns at 660.0 "$node_(142) on" 
$node_(143) set X_ 900 
$node_(143) set Y_ 314 
$node_(143) set Z_ 0.0 
$ns at 0.0 "$node_(143) off" 
$ns at 660.0 "$node_(143) on" 
$node_(144) set X_ 792 
$node_(144) set Y_ 499 
$node_(144) set Z_ 0.0 
$ns at 0.0 "$node_(144) off" 
$ns at 660.0 "$node_(144) on" 
$node_(145) set X_ 993 
$node_(145) set Y_ 928 
$node_(145) set Z_ 0.0 
$ns at 0.0 "$node_(145) off" 
$ns at 660.0 "$node_(145) on" 
$node_(146) set X_ 281 
$node_(146) set Y_ 493 
$node_(146) set Z_ 0.0 
$ns at 0.0 "$node_(146) off" 
$ns at 660.0 "$node_(146) on" 
$node_(147) set X_ 1078 
$node_(147) set Y_ 177 
$node_(147) set Z_ 0.0 
$ns at 0.0 "$node_(147) off" 
$ns at 660.0 "$node_(147) on" 
$node_(148) set X_ 1946 
$node_(148) set Y_ 822 
$node_(148) set Z_ 0.0 
$ns at 0.0 "$node_(148) off" 
$ns at 660.0 "$node_(148) on" 
$node_(149) set X_ 76 
$node_(149) set Y_ 160 
$node_(149) set Z_ 0.0 
$ns at 0.0 "$node_(149) off" 
$ns at 660.0 "$node_(149) on" 

# Generation of movements
$ns at 0.0 "$node_(0) setdest 2684 79 10.0" 
$ns at 128.6951913461781 "$node_(0) setdest 1397 43 6.0" 
$ns at 206.12674442518482 "$node_(0) setdest 1798 200 12.0" 
$ns at 256.5266159142147 "$node_(0) setdest 2006 691 5.0" 
$ns at 297.3872605412525 "$node_(0) setdest 664 431 12.0" 
$ns at 426.69527028313325 "$node_(0) setdest 144 101 1.0" 
$ns at 463.6305398471734 "$node_(0) setdest 2478 392 6.0" 
$ns at 507.8162494859728 "$node_(0) setdest 915 173 11.0" 
$ns at 619.7426451517704 "$node_(0) setdest 2533 238 17.0" 
$ns at 676.3094471657664 "$node_(0) setdest 1010 891 15.0" 
$ns at 743.1730490588925 "$node_(0) setdest 646 916 15.0" 
$ns at 842.6423517351666 "$node_(0) setdest 835 426 1.0" 
$ns at 875.6675471071645 "$node_(0) setdest 1594 640 7.0" 
$ns at 0.0 "$node_(1) setdest 329 921 12.0" 
$ns at 70.0017689681665 "$node_(1) setdest 1844 302 3.0" 
$ns at 124.36891270214181 "$node_(1) setdest 2613 264 14.0" 
$ns at 293.41367240970783 "$node_(1) setdest 601 773 3.0" 
$ns at 341.21470853705813 "$node_(1) setdest 2375 455 16.0" 
$ns at 504.99938424566204 "$node_(1) setdest 1942 284 5.0" 
$ns at 565.0242637046845 "$node_(1) setdest 2645 389 15.0" 
$ns at 724.1486265921122 "$node_(1) setdest 2584 380 15.0" 
$ns at 764.5406716342841 "$node_(1) setdest 2366 136 12.0" 
$ns at 834.4403677260802 "$node_(1) setdest 2545 112 16.0" 
$ns at 0.0 "$node_(2) setdest 2905 51 4.0" 
$ns at 51.08964831800803 "$node_(2) setdest 1730 459 11.0" 
$ns at 144.69372427611728 "$node_(2) setdest 1413 300 14.0" 
$ns at 215.60027469713123 "$node_(2) setdest 226 169 17.0" 
$ns at 279.9994154251952 "$node_(2) setdest 2679 629 6.0" 
$ns at 343.9915588229502 "$node_(2) setdest 2823 473 8.0" 
$ns at 421.73085585241705 "$node_(2) setdest 895 457 17.0" 
$ns at 495.563278464488 "$node_(2) setdest 2053 396 3.0" 
$ns at 535.1865781137013 "$node_(2) setdest 463 638 4.0" 
$ns at 569.9121067291716 "$node_(2) setdest 1748 602 5.0" 
$ns at 618.3568357471352 "$node_(2) setdest 1770 450 7.0" 
$ns at 684.3669518453177 "$node_(2) setdest 2934 1 14.0" 
$ns at 747.8707889941238 "$node_(2) setdest 1560 669 19.0" 
$ns at 823.0915771919194 "$node_(2) setdest 544 552 19.0" 
$ns at 0.0 "$node_(3) setdest 1323 792 6.0" 
$ns at 74.83224837005871 "$node_(3) setdest 1265 988 4.0" 
$ns at 112.82823558309764 "$node_(3) setdest 2849 746 9.0" 
$ns at 186.75966341958159 "$node_(3) setdest 1524 412 18.0" 
$ns at 290.4779455178231 "$node_(3) setdest 840 673 12.0" 
$ns at 343.0132256939932 "$node_(3) setdest 392 970 2.0" 
$ns at 374.07174743608914 "$node_(3) setdest 1248 610 4.0" 
$ns at 414.644842341606 "$node_(3) setdest 2950 62 5.0" 
$ns at 452.5344584994207 "$node_(3) setdest 1724 152 7.0" 
$ns at 534.940788402732 "$node_(3) setdest 372 794 11.0" 
$ns at 623.1697943783516 "$node_(3) setdest 350 436 1.0" 
$ns at 656.793032722635 "$node_(3) setdest 768 633 8.0" 
$ns at 749.8663690154382 "$node_(3) setdest 537 16 6.0" 
$ns at 818.6148577028586 "$node_(3) setdest 2556 465 9.0" 
$ns at 0.0 "$node_(4) setdest 1752 470 1.0" 
$ns at 32.82084476541173 "$node_(4) setdest 898 518 12.0" 
$ns at 68.20543539536726 "$node_(4) setdest 2482 819 19.0" 
$ns at 100.06066779482781 "$node_(4) setdest 1469 862 15.0" 
$ns at 220.78818710284264 "$node_(4) setdest 563 88 19.0" 
$ns at 397.17560812278975 "$node_(4) setdest 1589 429 10.0" 
$ns at 521.7606662961035 "$node_(4) setdest 815 595 3.0" 
$ns at 581.306668501453 "$node_(4) setdest 1503 770 8.0" 
$ns at 619.6082054475197 "$node_(4) setdest 1593 792 3.0" 
$ns at 652.6711610314001 "$node_(4) setdest 1325 11 1.0" 
$ns at 686.5851410011131 "$node_(4) setdest 1692 751 12.0" 
$ns at 814.6024632919174 "$node_(4) setdest 2924 698 4.0" 
$ns at 879.1230134436507 "$node_(4) setdest 732 619 19.0" 
$ns at 0.0 "$node_(5) setdest 796 505 3.0" 
$ns at 48.96899356307734 "$node_(5) setdest 2946 628 1.0" 
$ns at 83.25388114326262 "$node_(5) setdest 674 6 8.0" 
$ns at 158.3043813182864 "$node_(5) setdest 2008 487 10.0" 
$ns at 276.92380872287043 "$node_(5) setdest 425 960 10.0" 
$ns at 317.1993749298 "$node_(5) setdest 306 246 1.0" 
$ns at 357.04042235518256 "$node_(5) setdest 497 833 6.0" 
$ns at 403.65439026005305 "$node_(5) setdest 2829 959 1.0" 
$ns at 437.5653740567025 "$node_(5) setdest 953 496 16.0" 
$ns at 486.1785618958073 "$node_(5) setdest 1539 721 14.0" 
$ns at 647.9991577115292 "$node_(5) setdest 2862 321 6.0" 
$ns at 680.0643823178006 "$node_(5) setdest 2913 935 9.0" 
$ns at 761.7204311905411 "$node_(5) setdest 2582 120 9.0" 
$ns at 874.9883053978202 "$node_(5) setdest 2033 855 13.0" 
$ns at 0.0 "$node_(6) setdest 1202 643 11.0" 
$ns at 30.164518874455794 "$node_(6) setdest 2393 774 15.0" 
$ns at 120.45828694408446 "$node_(6) setdest 1181 589 2.0" 
$ns at 163.31109484612386 "$node_(6) setdest 1311 408 6.0" 
$ns at 198.99126353852796 "$node_(6) setdest 1956 333 8.0" 
$ns at 290.6938751735966 "$node_(6) setdest 2614 333 10.0" 
$ns at 376.6424386029825 "$node_(6) setdest 1045 832 8.0" 
$ns at 448.9511282866096 "$node_(6) setdest 1981 539 10.0" 
$ns at 577.1722132725513 "$node_(6) setdest 1925 413 11.0" 
$ns at 636.787818324523 "$node_(6) setdest 2111 441 1.0" 
$ns at 675.7577167797524 "$node_(6) setdest 715 408 14.0" 
$ns at 725.3643341667771 "$node_(6) setdest 1614 931 15.0" 
$ns at 782.0958804339514 "$node_(6) setdest 2432 825 10.0" 
$ns at 889.2268822194673 "$node_(6) setdest 1267 294 18.0" 
$ns at 0.0 "$node_(7) setdest 1358 533 4.0" 
$ns at 63.63011927969556 "$node_(7) setdest 60 82 8.0" 
$ns at 132.4275586474035 "$node_(7) setdest 1792 658 6.0" 
$ns at 194.5570446345665 "$node_(7) setdest 2158 272 2.0" 
$ns at 238.66436744718624 "$node_(7) setdest 204 142 10.0" 
$ns at 286.61596900452673 "$node_(7) setdest 2701 281 13.0" 
$ns at 390.29923126433715 "$node_(7) setdest 592 683 11.0" 
$ns at 480.4195620681788 "$node_(7) setdest 2084 693 5.0" 
$ns at 514.5889820279878 "$node_(7) setdest 540 510 1.0" 
$ns at 550.8669051458318 "$node_(7) setdest 127 753 14.0" 
$ns at 639.719740775429 "$node_(7) setdest 280 686 15.0" 
$ns at 800.8362213339681 "$node_(7) setdest 277 983 16.0" 
$ns at 834.2638858367443 "$node_(7) setdest 767 923 19.0" 
$ns at 898.8736908948483 "$node_(7) setdest 757 483 4.0" 
$ns at 0.0 "$node_(8) setdest 2558 94 3.0" 
$ns at 34.32016830660907 "$node_(8) setdest 1299 772 3.0" 
$ns at 72.5213330445232 "$node_(8) setdest 11 901 7.0" 
$ns at 125.60651910133251 "$node_(8) setdest 883 217 5.0" 
$ns at 197.18790409562462 "$node_(8) setdest 2089 419 15.0" 
$ns at 320.621713322249 "$node_(8) setdest 1617 423 18.0" 
$ns at 432.77648004993443 "$node_(8) setdest 796 462 14.0" 
$ns at 585.5893955600302 "$node_(8) setdest 1662 132 16.0" 
$ns at 633.7980136285141 "$node_(8) setdest 1011 983 13.0" 
$ns at 717.898630512507 "$node_(8) setdest 2871 480 11.0" 
$ns at 766.3632652870438 "$node_(8) setdest 1272 954 1.0" 
$ns at 797.7878849913195 "$node_(8) setdest 2523 693 3.0" 
$ns at 842.0516292161242 "$node_(8) setdest 1756 459 17.0" 
$ns at 0.0 "$node_(9) setdest 2316 545 19.0" 
$ns at 94.65250035441123 "$node_(9) setdest 2509 922 10.0" 
$ns at 125.67039083188797 "$node_(9) setdest 2522 176 1.0" 
$ns at 157.8756130245008 "$node_(9) setdest 684 707 6.0" 
$ns at 220.3633273352351 "$node_(9) setdest 951 80 19.0" 
$ns at 313.99595947055343 "$node_(9) setdest 2336 532 19.0" 
$ns at 410.5815686135008 "$node_(9) setdest 2128 370 4.0" 
$ns at 463.0382203122117 "$node_(9) setdest 2020 406 3.0" 
$ns at 512.389364839458 "$node_(9) setdest 837 632 8.0" 
$ns at 564.2592702336839 "$node_(9) setdest 1256 50 8.0" 
$ns at 618.3062373465542 "$node_(9) setdest 935 957 2.0" 
$ns at 648.4539412198665 "$node_(9) setdest 2603 999 13.0" 
$ns at 781.7851110915644 "$node_(9) setdest 2087 991 2.0" 
$ns at 813.9378499227173 "$node_(9) setdest 902 863 17.0" 
$ns at 0.0 "$node_(10) setdest 1819 65 18.0" 
$ns at 163.40086834728615 "$node_(10) setdest 2940 425 2.0" 
$ns at 197.8690328002253 "$node_(10) setdest 1054 766 10.0" 
$ns at 320.69594708979827 "$node_(10) setdest 2569 559 19.0" 
$ns at 474.240984003701 "$node_(10) setdest 2018 497 7.0" 
$ns at 538.0955266532566 "$node_(10) setdest 1075 161 6.0" 
$ns at 602.1917800935664 "$node_(10) setdest 187 891 15.0" 
$ns at 633.8398773490064 "$node_(10) setdest 1289 552 3.0" 
$ns at 672.3464886417371 "$node_(10) setdest 2652 136 10.0" 
$ns at 737.0959780276895 "$node_(10) setdest 758 62 4.0" 
$ns at 801.6147785185746 "$node_(10) setdest 1085 557 1.0" 
$ns at 832.6295232850326 "$node_(10) setdest 972 758 3.0" 
$ns at 880.6622934871054 "$node_(10) setdest 2176 29 19.0" 
$ns at 0.0 "$node_(11) setdest 2433 502 19.0" 
$ns at 151.81706680769315 "$node_(11) setdest 225 64 17.0" 
$ns at 256.35894205791334 "$node_(11) setdest 1109 829 9.0" 
$ns at 333.122718881069 "$node_(11) setdest 2264 640 15.0" 
$ns at 495.7336302928703 "$node_(11) setdest 2522 315 6.0" 
$ns at 564.9719888483654 "$node_(11) setdest 879 112 1.0" 
$ns at 595.1240967376186 "$node_(11) setdest 1525 427 20.0" 
$ns at 633.7862624813324 "$node_(11) setdest 627 787 2.0" 
$ns at 668.8672564614756 "$node_(11) setdest 2528 35 7.0" 
$ns at 747.9310784792555 "$node_(11) setdest 707 999 18.0" 
$ns at 882.1473646103917 "$node_(11) setdest 2700 58 16.0" 
$ns at 0.0 "$node_(12) setdest 2270 748 1.0" 
$ns at 37.642087391344376 "$node_(12) setdest 2443 946 10.0" 
$ns at 75.0098599157964 "$node_(12) setdest 1547 262 11.0" 
$ns at 200.6180808439019 "$node_(12) setdest 139 952 16.0" 
$ns at 258.33843038745374 "$node_(12) setdest 2673 44 4.0" 
$ns at 323.22822453644096 "$node_(12) setdest 965 417 19.0" 
$ns at 374.8002600396697 "$node_(12) setdest 875 236 11.0" 
$ns at 470.07817678528454 "$node_(12) setdest 1305 493 13.0" 
$ns at 625.6050369630581 "$node_(12) setdest 1415 402 17.0" 
$ns at 706.6661631603567 "$node_(12) setdest 1020 53 5.0" 
$ns at 755.7595222751759 "$node_(12) setdest 2454 36 4.0" 
$ns at 811.449561684825 "$node_(12) setdest 619 704 12.0" 
$ns at 0.0 "$node_(13) setdest 2723 392 8.0" 
$ns at 94.51277413598538 "$node_(13) setdest 1100 140 11.0" 
$ns at 228.352866018581 "$node_(13) setdest 2670 470 7.0" 
$ns at 261.2689698346999 "$node_(13) setdest 998 279 15.0" 
$ns at 360.4462674028902 "$node_(13) setdest 1465 232 11.0" 
$ns at 494.21335582094787 "$node_(13) setdest 901 888 14.0" 
$ns at 561.5024974945749 "$node_(13) setdest 2045 379 8.0" 
$ns at 603.0513764089744 "$node_(13) setdest 2475 666 16.0" 
$ns at 682.7792021711867 "$node_(13) setdest 1066 283 8.0" 
$ns at 737.3296341234991 "$node_(13) setdest 1777 979 5.0" 
$ns at 778.670514987534 "$node_(13) setdest 1441 895 1.0" 
$ns at 814.2611941957086 "$node_(13) setdest 1362 707 9.0" 
$ns at 871.8800813948644 "$node_(13) setdest 1862 709 20.0" 
$ns at 0.0 "$node_(14) setdest 498 918 5.0" 
$ns at 66.92375811584915 "$node_(14) setdest 2439 133 4.0" 
$ns at 109.64895085573445 "$node_(14) setdest 1476 317 16.0" 
$ns at 197.92153812342147 "$node_(14) setdest 391 816 14.0" 
$ns at 258.01946998264896 "$node_(14) setdest 1821 678 13.0" 
$ns at 351.26989674562003 "$node_(14) setdest 1408 804 15.0" 
$ns at 498.78767213840155 "$node_(14) setdest 2923 724 7.0" 
$ns at 562.8726177872339 "$node_(14) setdest 1113 566 4.0" 
$ns at 602.0863600029427 "$node_(14) setdest 360 151 5.0" 
$ns at 646.0178252298983 "$node_(14) setdest 2757 256 5.0" 
$ns at 715.552300098972 "$node_(14) setdest 2946 758 12.0" 
$ns at 849.1057887469133 "$node_(14) setdest 64 769 10.0" 
$ns at 0.0 "$node_(15) setdest 2280 896 7.0" 
$ns at 65.57926091424926 "$node_(15) setdest 1867 438 14.0" 
$ns at 170.02082572907273 "$node_(15) setdest 1323 683 14.0" 
$ns at 245.04145521415398 "$node_(15) setdest 1945 449 2.0" 
$ns at 277.4633112651911 "$node_(15) setdest 1282 694 6.0" 
$ns at 321.36859142494495 "$node_(15) setdest 2210 297 1.0" 
$ns at 358.12286793506536 "$node_(15) setdest 2827 93 15.0" 
$ns at 486.29961986473876 "$node_(15) setdest 145 886 11.0" 
$ns at 517.3904734797737 "$node_(15) setdest 414 398 8.0" 
$ns at 576.044496626911 "$node_(15) setdest 2151 87 1.0" 
$ns at 608.311381457673 "$node_(15) setdest 251 348 16.0" 
$ns at 686.3203278592024 "$node_(15) setdest 2197 836 20.0" 
$ns at 884.4454047852297 "$node_(15) setdest 175 581 10.0" 
$ns at 0.0 "$node_(16) setdest 933 120 9.0" 
$ns at 86.13709078146519 "$node_(16) setdest 2478 63 5.0" 
$ns at 160.6689358307351 "$node_(16) setdest 166 418 19.0" 
$ns at 202.57818764509932 "$node_(16) setdest 2439 497 14.0" 
$ns at 324.1329779216298 "$node_(16) setdest 1345 432 17.0" 
$ns at 451.67607500073757 "$node_(16) setdest 1123 152 1.0" 
$ns at 483.31212958296607 "$node_(16) setdest 1472 193 12.0" 
$ns at 617.7597286629489 "$node_(16) setdest 1681 830 17.0" 
$ns at 682.1827617518938 "$node_(16) setdest 1573 877 3.0" 
$ns at 715.9872191887681 "$node_(16) setdest 226 919 7.0" 
$ns at 797.4591543299304 "$node_(16) setdest 1648 902 18.0" 
$ns at 0.0 "$node_(17) setdest 1016 750 16.0" 
$ns at 43.6687096124945 "$node_(17) setdest 1740 150 15.0" 
$ns at 146.84635886239283 "$node_(17) setdest 2507 700 11.0" 
$ns at 203.07836944355083 "$node_(17) setdest 2530 389 1.0" 
$ns at 238.23601149347542 "$node_(17) setdest 540 768 7.0" 
$ns at 288.6975230481721 "$node_(17) setdest 2619 231 3.0" 
$ns at 320.7176791248335 "$node_(17) setdest 1677 557 12.0" 
$ns at 389.45338132991895 "$node_(17) setdest 2379 201 6.0" 
$ns at 454.3992602670869 "$node_(17) setdest 1491 894 9.0" 
$ns at 501.0443887518628 "$node_(17) setdest 1044 761 4.0" 
$ns at 541.8401039946093 "$node_(17) setdest 309 523 16.0" 
$ns at 574.8680367169522 "$node_(17) setdest 1439 356 14.0" 
$ns at 730.202401465355 "$node_(17) setdest 705 594 17.0" 
$ns at 841.8931734224417 "$node_(17) setdest 1490 833 11.0" 
$ns at 0.0 "$node_(18) setdest 765 896 8.0" 
$ns at 107.24944495860511 "$node_(18) setdest 431 792 5.0" 
$ns at 142.0628607894774 "$node_(18) setdest 891 46 10.0" 
$ns at 206.85980269535895 "$node_(18) setdest 347 724 12.0" 
$ns at 240.91874937060715 "$node_(18) setdest 690 85 15.0" 
$ns at 270.95677010155157 "$node_(18) setdest 2471 996 5.0" 
$ns at 309.94555296932776 "$node_(18) setdest 2210 199 9.0" 
$ns at 350.51915433168773 "$node_(18) setdest 1371 39 3.0" 
$ns at 404.81146603195754 "$node_(18) setdest 554 507 13.0" 
$ns at 514.4473523564677 "$node_(18) setdest 1936 298 13.0" 
$ns at 616.2682601129142 "$node_(18) setdest 661 137 13.0" 
$ns at 659.7300153319758 "$node_(18) setdest 823 790 4.0" 
$ns at 705.0594421928901 "$node_(18) setdest 758 35 1.0" 
$ns at 742.6773043124805 "$node_(18) setdest 749 349 2.0" 
$ns at 774.3166165404916 "$node_(18) setdest 783 232 5.0" 
$ns at 806.3702858906126 "$node_(18) setdest 793 892 7.0" 
$ns at 892.4048862197955 "$node_(18) setdest 1797 495 9.0" 
$ns at 0.0 "$node_(19) setdest 2608 275 9.0" 
$ns at 87.02193988579299 "$node_(19) setdest 2157 611 11.0" 
$ns at 186.8551835921943 "$node_(19) setdest 1197 596 13.0" 
$ns at 260.81432378010595 "$node_(19) setdest 2986 716 12.0" 
$ns at 326.80127678363743 "$node_(19) setdest 1645 1 5.0" 
$ns at 386.56925086083396 "$node_(19) setdest 218 416 16.0" 
$ns at 532.1406908223391 "$node_(19) setdest 1974 338 19.0" 
$ns at 649.5314399956425 "$node_(19) setdest 1236 629 7.0" 
$ns at 707.0857224954395 "$node_(19) setdest 15 252 16.0" 
$ns at 879.7179939094183 "$node_(19) setdest 2885 366 12.0" 
$ns at 0.0 "$node_(20) setdest 1951 518 9.0" 
$ns at 76.05925545916949 "$node_(20) setdest 397 916 5.0" 
$ns at 136.60859021700762 "$node_(20) setdest 1928 740 1.0" 
$ns at 176.4455167342938 "$node_(20) setdest 1485 120 11.0" 
$ns at 279.1405149858172 "$node_(20) setdest 1901 706 6.0" 
$ns at 348.43024746404785 "$node_(20) setdest 2655 717 14.0" 
$ns at 410.4627944161079 "$node_(20) setdest 601 11 16.0" 
$ns at 498.3059750365412 "$node_(20) setdest 2497 944 7.0" 
$ns at 591.3587379866262 "$node_(20) setdest 1284 767 18.0" 
$ns at 718.0655108377284 "$node_(20) setdest 1489 874 16.0" 
$ns at 831.993196093149 "$node_(20) setdest 1660 478 6.0" 
$ns at 863.2021648657769 "$node_(20) setdest 1598 172 20.0" 
$ns at 899.2934468995188 "$node_(20) setdest 2165 425 3.0" 
$ns at 0.0 "$node_(21) setdest 1687 243 9.0" 
$ns at 42.26809537295246 "$node_(21) setdest 460 128 19.0" 
$ns at 153.40517132301824 "$node_(21) setdest 525 975 11.0" 
$ns at 233.64816233392818 "$node_(21) setdest 825 737 2.0" 
$ns at 278.5377714733646 "$node_(21) setdest 1918 538 8.0" 
$ns at 371.42704445292804 "$node_(21) setdest 1846 404 19.0" 
$ns at 491.9850659516875 "$node_(21) setdest 2235 927 3.0" 
$ns at 539.2196532138584 "$node_(21) setdest 1546 4 19.0" 
$ns at 603.3891443092318 "$node_(21) setdest 1366 242 15.0" 
$ns at 763.3616847099593 "$node_(21) setdest 2854 759 12.0" 
$ns at 0.0 "$node_(22) setdest 882 871 7.0" 
$ns at 45.558519055304494 "$node_(22) setdest 89 605 10.0" 
$ns at 84.23413504492206 "$node_(22) setdest 1922 62 19.0" 
$ns at 188.39191099465125 "$node_(22) setdest 2829 395 9.0" 
$ns at 296.05862810236204 "$node_(22) setdest 1099 587 14.0" 
$ns at 431.26539621994334 "$node_(22) setdest 1348 253 3.0" 
$ns at 475.08974516291386 "$node_(22) setdest 1431 433 7.0" 
$ns at 561.3677435091336 "$node_(22) setdest 494 671 18.0" 
$ns at 690.7508070165384 "$node_(22) setdest 2092 763 16.0" 
$ns at 754.1215312631557 "$node_(22) setdest 690 182 6.0" 
$ns at 803.1794726487896 "$node_(22) setdest 502 572 16.0" 
$ns at 859.388609304195 "$node_(22) setdest 438 684 17.0" 
$ns at 0.0 "$node_(23) setdest 2036 764 13.0" 
$ns at 46.97768151424173 "$node_(23) setdest 2484 755 5.0" 
$ns at 103.59760140081744 "$node_(23) setdest 377 594 17.0" 
$ns at 163.47738710564846 "$node_(23) setdest 553 534 11.0" 
$ns at 237.00137848855098 "$node_(23) setdest 289 700 8.0" 
$ns at 303.32890607535194 "$node_(23) setdest 2301 5 8.0" 
$ns at 366.7395213367502 "$node_(23) setdest 2351 161 18.0" 
$ns at 504.45299394067956 "$node_(23) setdest 886 762 18.0" 
$ns at 595.6626406860372 "$node_(23) setdest 1904 302 1.0" 
$ns at 626.0343445376207 "$node_(23) setdest 312 592 6.0" 
$ns at 688.3906442904315 "$node_(23) setdest 1263 198 8.0" 
$ns at 759.1258634367636 "$node_(23) setdest 2444 456 11.0" 
$ns at 886.0494924972637 "$node_(23) setdest 1958 89 4.0" 
$ns at 0.0 "$node_(24) setdest 2360 693 11.0" 
$ns at 59.81186218096275 "$node_(24) setdest 1533 150 1.0" 
$ns at 99.15173229446023 "$node_(24) setdest 417 546 11.0" 
$ns at 161.4539375939725 "$node_(24) setdest 2185 343 6.0" 
$ns at 218.34465120003028 "$node_(24) setdest 1218 318 16.0" 
$ns at 342.2596055875847 "$node_(24) setdest 265 290 9.0" 
$ns at 402.8535403928013 "$node_(24) setdest 344 765 3.0" 
$ns at 458.1958670043807 "$node_(24) setdest 1421 384 1.0" 
$ns at 497.0493029587051 "$node_(24) setdest 2534 542 13.0" 
$ns at 604.0793461496895 "$node_(24) setdest 1909 588 5.0" 
$ns at 658.6557240788109 "$node_(24) setdest 1705 788 11.0" 
$ns at 703.1048553958 "$node_(24) setdest 353 642 3.0" 
$ns at 737.2380738727641 "$node_(24) setdest 953 181 9.0" 
$ns at 793.6664522796207 "$node_(24) setdest 2976 615 2.0" 
$ns at 827.0670442449841 "$node_(24) setdest 1458 50 6.0" 
$ns at 0.0 "$node_(25) setdest 1082 33 14.0" 
$ns at 165.55454400604003 "$node_(25) setdest 929 372 5.0" 
$ns at 200.7647297339321 "$node_(25) setdest 2319 12 14.0" 
$ns at 266.6223511729607 "$node_(25) setdest 998 735 7.0" 
$ns at 359.0411929769703 "$node_(25) setdest 2991 136 11.0" 
$ns at 397.0475394576451 "$node_(25) setdest 2717 600 9.0" 
$ns at 480.3142828656617 "$node_(25) setdest 2464 1 6.0" 
$ns at 550.8674557096849 "$node_(25) setdest 54 446 1.0" 
$ns at 581.6941856981073 "$node_(25) setdest 2421 668 20.0" 
$ns at 790.8444894716938 "$node_(25) setdest 48 630 13.0" 
$ns at 0.0 "$node_(26) setdest 509 450 14.0" 
$ns at 129.39970530734305 "$node_(26) setdest 20 43 7.0" 
$ns at 161.971512780652 "$node_(26) setdest 657 763 5.0" 
$ns at 194.88273269850146 "$node_(26) setdest 2992 885 3.0" 
$ns at 248.29052015389115 "$node_(26) setdest 74 988 15.0" 
$ns at 303.2327180197352 "$node_(26) setdest 222 167 8.0" 
$ns at 385.50561744540477 "$node_(26) setdest 727 549 10.0" 
$ns at 505.47094576443857 "$node_(26) setdest 500 734 16.0" 
$ns at 604.7173555469885 "$node_(26) setdest 812 672 16.0" 
$ns at 781.1953262696852 "$node_(26) setdest 613 932 4.0" 
$ns at 848.847716881479 "$node_(26) setdest 499 527 3.0" 
$ns at 897.8316325197301 "$node_(26) setdest 2131 215 10.0" 
$ns at 0.0 "$node_(27) setdest 2980 705 7.0" 
$ns at 50.32627556774647 "$node_(27) setdest 408 297 9.0" 
$ns at 104.95871133464692 "$node_(27) setdest 1597 253 14.0" 
$ns at 220.63080390271992 "$node_(27) setdest 1464 676 16.0" 
$ns at 381.95902616060835 "$node_(27) setdest 1570 702 9.0" 
$ns at 488.28562512263557 "$node_(27) setdest 142 607 13.0" 
$ns at 600.4795398362252 "$node_(27) setdest 2620 816 7.0" 
$ns at 645.4881185969185 "$node_(27) setdest 690 855 6.0" 
$ns at 730.3063258960191 "$node_(27) setdest 1492 7 15.0" 
$ns at 0.0 "$node_(28) setdest 2678 822 9.0" 
$ns at 60.53113357016318 "$node_(28) setdest 2173 622 13.0" 
$ns at 199.12241827470697 "$node_(28) setdest 1895 867 7.0" 
$ns at 274.24800064791367 "$node_(28) setdest 1323 567 17.0" 
$ns at 470.7423378019213 "$node_(28) setdest 2634 909 5.0" 
$ns at 539.6289615256694 "$node_(28) setdest 1200 971 19.0" 
$ns at 663.8063327754422 "$node_(28) setdest 2515 636 5.0" 
$ns at 706.430212728175 "$node_(28) setdest 1108 846 11.0" 
$ns at 817.418490387882 "$node_(28) setdest 1748 919 13.0" 
$ns at 0.0 "$node_(29) setdest 136 948 10.0" 
$ns at 86.36824788383356 "$node_(29) setdest 2486 238 16.0" 
$ns at 126.60357343604294 "$node_(29) setdest 2728 303 14.0" 
$ns at 172.0282716197054 "$node_(29) setdest 681 233 14.0" 
$ns at 331.72516448249587 "$node_(29) setdest 1356 100 12.0" 
$ns at 372.4545788560696 "$node_(29) setdest 573 677 10.0" 
$ns at 414.73236385473035 "$node_(29) setdest 1317 908 1.0" 
$ns at 454.0358046220972 "$node_(29) setdest 1748 490 15.0" 
$ns at 488.01490315027377 "$node_(29) setdest 444 424 10.0" 
$ns at 543.2813837427439 "$node_(29) setdest 2379 587 1.0" 
$ns at 578.8432848219584 "$node_(29) setdest 2245 215 13.0" 
$ns at 667.7852702816843 "$node_(29) setdest 85 685 3.0" 
$ns at 727.6882193265819 "$node_(29) setdest 760 150 20.0" 
$ns at 842.5250821165884 "$node_(29) setdest 2543 357 8.0" 
$ns at 886.9471616094127 "$node_(29) setdest 2154 488 18.0" 
$ns at 0.0 "$node_(30) setdest 752 949 6.0" 
$ns at 85.20347538236848 "$node_(30) setdest 1825 828 3.0" 
$ns at 125.40702889798331 "$node_(30) setdest 2620 180 1.0" 
$ns at 163.8399841988383 "$node_(30) setdest 1560 373 16.0" 
$ns at 348.5837067990181 "$node_(30) setdest 260 497 19.0" 
$ns at 381.6900123463064 "$node_(30) setdest 2008 218 12.0" 
$ns at 518.4625200484828 "$node_(30) setdest 145 537 7.0" 
$ns at 548.9802253249974 "$node_(30) setdest 2504 623 10.0" 
$ns at 646.2445856697723 "$node_(30) setdest 46 260 14.0" 
$ns at 715.5735534450994 "$node_(30) setdest 2021 472 16.0" 
$ns at 748.2347425109629 "$node_(30) setdest 1376 595 8.0" 
$ns at 783.7217587315306 "$node_(30) setdest 1769 375 9.0" 
$ns at 898.114364576852 "$node_(30) setdest 2370 685 11.0" 
$ns at 0.0 "$node_(31) setdest 1731 126 1.0" 
$ns at 32.32693576177285 "$node_(31) setdest 2229 40 5.0" 
$ns at 108.07714228259644 "$node_(31) setdest 2153 472 5.0" 
$ns at 163.15995022766745 "$node_(31) setdest 2152 218 18.0" 
$ns at 268.8911418001032 "$node_(31) setdest 771 389 4.0" 
$ns at 308.7326904507655 "$node_(31) setdest 1890 828 1.0" 
$ns at 340.96708269112105 "$node_(31) setdest 1301 346 1.0" 
$ns at 379.0920661952082 "$node_(31) setdest 238 960 12.0" 
$ns at 498.3954835215116 "$node_(31) setdest 1466 233 18.0" 
$ns at 564.7053038208503 "$node_(31) setdest 2610 369 17.0" 
$ns at 763.7140143685031 "$node_(31) setdest 1595 942 6.0" 
$ns at 794.4239654201223 "$node_(31) setdest 602 993 4.0" 
$ns at 857.5057850996113 "$node_(31) setdest 563 781 10.0" 
$ns at 891.097789731509 "$node_(31) setdest 191 633 14.0" 
$ns at 0.0 "$node_(32) setdest 603 197 10.0" 
$ns at 58.320313913208054 "$node_(32) setdest 1983 892 9.0" 
$ns at 106.87390517188766 "$node_(32) setdest 1271 503 18.0" 
$ns at 216.68183599784913 "$node_(32) setdest 2648 682 10.0" 
$ns at 288.4735050548935 "$node_(32) setdest 2585 572 4.0" 
$ns at 321.02020027465073 "$node_(32) setdest 455 907 3.0" 
$ns at 359.34959612772764 "$node_(32) setdest 2116 706 9.0" 
$ns at 475.58019406647816 "$node_(32) setdest 557 128 17.0" 
$ns at 648.0772812007998 "$node_(32) setdest 1563 129 15.0" 
$ns at 770.8754777683308 "$node_(32) setdest 1426 319 16.0" 
$ns at 857.393144954197 "$node_(32) setdest 90 826 6.0" 
$ns at 0.0 "$node_(33) setdest 1590 17 1.0" 
$ns at 39.929907537699364 "$node_(33) setdest 441 663 7.0" 
$ns at 103.53742552632136 "$node_(33) setdest 577 477 1.0" 
$ns at 135.585183975316 "$node_(33) setdest 626 23 18.0" 
$ns at 331.04829868965487 "$node_(33) setdest 1724 640 12.0" 
$ns at 464.4968763638419 "$node_(33) setdest 1692 385 7.0" 
$ns at 511.8501131833737 "$node_(33) setdest 1232 8 13.0" 
$ns at 619.4793769817672 "$node_(33) setdest 2868 579 1.0" 
$ns at 658.9042743866173 "$node_(33) setdest 2649 764 4.0" 
$ns at 727.3686228690127 "$node_(33) setdest 1099 654 4.0" 
$ns at 767.5509802261945 "$node_(33) setdest 659 700 7.0" 
$ns at 819.2092390252491 "$node_(33) setdest 757 586 6.0" 
$ns at 860.079275752328 "$node_(33) setdest 1843 802 8.0" 
$ns at 0.0 "$node_(34) setdest 1053 260 15.0" 
$ns at 118.98203318468627 "$node_(34) setdest 809 567 7.0" 
$ns at 159.0756438880357 "$node_(34) setdest 1422 450 7.0" 
$ns at 226.9692103193026 "$node_(34) setdest 1843 390 1.0" 
$ns at 257.50141417784465 "$node_(34) setdest 2916 756 16.0" 
$ns at 288.92475755100327 "$node_(34) setdest 2987 586 10.0" 
$ns at 361.473202714017 "$node_(34) setdest 2381 683 1.0" 
$ns at 397.78885174614885 "$node_(34) setdest 1193 906 4.0" 
$ns at 438.81519468191493 "$node_(34) setdest 937 348 6.0" 
$ns at 477.99944060000865 "$node_(34) setdest 2955 607 3.0" 
$ns at 522.5357095090602 "$node_(34) setdest 1052 502 16.0" 
$ns at 654.393190017892 "$node_(34) setdest 1578 410 11.0" 
$ns at 770.8824073742185 "$node_(34) setdest 226 828 1.0" 
$ns at 807.8970834429812 "$node_(34) setdest 2971 946 18.0" 
$ns at 0.0 "$node_(35) setdest 2069 730 4.0" 
$ns at 42.175447295449395 "$node_(35) setdest 2641 501 19.0" 
$ns at 89.31562755216399 "$node_(35) setdest 293 58 19.0" 
$ns at 278.00172299906626 "$node_(35) setdest 259 149 16.0" 
$ns at 329.0386615617527 "$node_(35) setdest 2910 490 15.0" 
$ns at 440.9719002528109 "$node_(35) setdest 983 614 17.0" 
$ns at 474.3603517260018 "$node_(35) setdest 2640 511 6.0" 
$ns at 539.4667444804071 "$node_(35) setdest 1414 430 8.0" 
$ns at 619.7299547279576 "$node_(35) setdest 1332 213 7.0" 
$ns at 660.2567250019307 "$node_(35) setdest 850 235 17.0" 
$ns at 837.7497578829573 "$node_(35) setdest 1910 358 17.0" 
$ns at 0.0 "$node_(36) setdest 1242 291 10.0" 
$ns at 91.06778599694306 "$node_(36) setdest 2116 430 17.0" 
$ns at 139.5789689200103 "$node_(36) setdest 1997 541 2.0" 
$ns at 184.69723046084422 "$node_(36) setdest 1102 606 5.0" 
$ns at 235.45404029390775 "$node_(36) setdest 2532 810 12.0" 
$ns at 304.5938354731572 "$node_(36) setdest 616 881 20.0" 
$ns at 346.11594248066194 "$node_(36) setdest 2241 965 12.0" 
$ns at 465.76466814402926 "$node_(36) setdest 1339 787 11.0" 
$ns at 604.8040623428487 "$node_(36) setdest 261 114 1.0" 
$ns at 641.7984377395475 "$node_(36) setdest 1624 415 15.0" 
$ns at 721.2440447707895 "$node_(36) setdest 1199 196 8.0" 
$ns at 766.4572780599912 "$node_(36) setdest 693 702 7.0" 
$ns at 859.9737986324465 "$node_(36) setdest 732 519 16.0" 
$ns at 0.0 "$node_(37) setdest 38 190 15.0" 
$ns at 48.2910855574784 "$node_(37) setdest 702 94 3.0" 
$ns at 102.49310801635818 "$node_(37) setdest 577 707 1.0" 
$ns at 140.7318264891381 "$node_(37) setdest 2150 849 4.0" 
$ns at 207.37016500710098 "$node_(37) setdest 2838 683 10.0" 
$ns at 264.9009621879849 "$node_(37) setdest 400 34 3.0" 
$ns at 295.34097690975614 "$node_(37) setdest 184 59 13.0" 
$ns at 383.34222652547896 "$node_(37) setdest 1128 433 1.0" 
$ns at 414.0568495729388 "$node_(37) setdest 878 990 8.0" 
$ns at 457.46194503595177 "$node_(37) setdest 2047 179 9.0" 
$ns at 576.5946152716375 "$node_(37) setdest 1496 807 9.0" 
$ns at 688.6788568766156 "$node_(37) setdest 2625 279 12.0" 
$ns at 749.7098144612451 "$node_(37) setdest 2978 935 9.0" 
$ns at 799.5159547256093 "$node_(37) setdest 2972 174 5.0" 
$ns at 877.9747249138952 "$node_(37) setdest 2340 736 1.0" 
$ns at 0.0 "$node_(38) setdest 1820 913 7.0" 
$ns at 37.903047343276455 "$node_(38) setdest 1826 474 7.0" 
$ns at 104.12804611658758 "$node_(38) setdest 1228 773 14.0" 
$ns at 173.90769811191007 "$node_(38) setdest 17 861 15.0" 
$ns at 347.12343867059064 "$node_(38) setdest 2424 410 6.0" 
$ns at 388.82924346720165 "$node_(38) setdest 2195 902 7.0" 
$ns at 421.6935070511407 "$node_(38) setdest 1935 879 4.0" 
$ns at 477.41287578833874 "$node_(38) setdest 972 973 10.0" 
$ns at 561.5382812103576 "$node_(38) setdest 913 86 4.0" 
$ns at 624.5257060043959 "$node_(38) setdest 1964 364 7.0" 
$ns at 655.5131382322039 "$node_(38) setdest 2294 527 7.0" 
$ns at 695.5520377613911 "$node_(38) setdest 2042 731 16.0" 
$ns at 774.8800202179365 "$node_(38) setdest 1209 376 4.0" 
$ns at 840.9561457672457 "$node_(38) setdest 2443 161 10.0" 
$ns at 0.0 "$node_(39) setdest 1794 276 15.0" 
$ns at 109.00234804254703 "$node_(39) setdest 1745 816 20.0" 
$ns at 155.1666135349492 "$node_(39) setdest 1287 383 11.0" 
$ns at 209.13848180094362 "$node_(39) setdest 1515 360 11.0" 
$ns at 270.9926708204192 "$node_(39) setdest 99 538 4.0" 
$ns at 307.77069881011636 "$node_(39) setdest 1135 621 10.0" 
$ns at 344.6877630438214 "$node_(39) setdest 1214 603 10.0" 
$ns at 450.0242114337392 "$node_(39) setdest 1086 204 10.0" 
$ns at 575.6339113756067 "$node_(39) setdest 2119 331 8.0" 
$ns at 630.746789517222 "$node_(39) setdest 1724 4 2.0" 
$ns at 676.7361630884732 "$node_(39) setdest 1126 327 12.0" 
$ns at 762.5404181399513 "$node_(39) setdest 332 826 10.0" 
$ns at 821.1889861983863 "$node_(39) setdest 1766 949 18.0" 
$ns at 857.7059937593878 "$node_(39) setdest 1946 583 8.0" 
$ns at 0.0 "$node_(40) setdest 2638 217 1.0" 
$ns at 30.610180747614965 "$node_(40) setdest 271 756 1.0" 
$ns at 69.39178354012176 "$node_(40) setdest 2887 73 13.0" 
$ns at 158.29761703780946 "$node_(40) setdest 2689 92 5.0" 
$ns at 228.0063816060135 "$node_(40) setdest 185 564 6.0" 
$ns at 273.84575037552554 "$node_(40) setdest 135 738 14.0" 
$ns at 307.7974380149636 "$node_(40) setdest 894 794 4.0" 
$ns at 364.4801789638331 "$node_(40) setdest 2390 273 8.0" 
$ns at 406.365034897133 "$node_(40) setdest 2798 709 15.0" 
$ns at 445.7914052040777 "$node_(40) setdest 2045 340 19.0" 
$ns at 641.6228431530217 "$node_(40) setdest 1561 68 19.0" 
$ns at 851.9963969393137 "$node_(40) setdest 1177 835 2.0" 
$ns at 888.5658750194959 "$node_(40) setdest 813 156 17.0" 
$ns at 0.0 "$node_(41) setdest 1508 871 9.0" 
$ns at 87.56284607303928 "$node_(41) setdest 519 99 3.0" 
$ns at 137.41166967114629 "$node_(41) setdest 580 953 17.0" 
$ns at 270.8817228545636 "$node_(41) setdest 2020 844 5.0" 
$ns at 309.0074830900294 "$node_(41) setdest 1214 95 11.0" 
$ns at 395.5242046455778 "$node_(41) setdest 2925 141 8.0" 
$ns at 458.79578589582076 "$node_(41) setdest 294 819 4.0" 
$ns at 500.41412742919846 "$node_(41) setdest 730 111 7.0" 
$ns at 591.502611745642 "$node_(41) setdest 1639 247 9.0" 
$ns at 677.0529197900494 "$node_(41) setdest 823 232 2.0" 
$ns at 726.5014244405918 "$node_(41) setdest 2503 749 16.0" 
$ns at 864.537723246088 "$node_(41) setdest 1294 821 14.0" 
$ns at 0.0 "$node_(42) setdest 2967 847 3.0" 
$ns at 48.02385159183167 "$node_(42) setdest 2676 351 7.0" 
$ns at 104.36009916220186 "$node_(42) setdest 1265 335 19.0" 
$ns at 305.51064041771247 "$node_(42) setdest 1542 174 1.0" 
$ns at 340.3558897425088 "$node_(42) setdest 1808 822 7.0" 
$ns at 394.8686830430765 "$node_(42) setdest 2596 499 1.0" 
$ns at 433.1858571849424 "$node_(42) setdest 448 153 6.0" 
$ns at 471.6683477964508 "$node_(42) setdest 665 688 5.0" 
$ns at 515.8762345077407 "$node_(42) setdest 2237 420 1.0" 
$ns at 548.924887479003 "$node_(42) setdest 1748 213 10.0" 
$ns at 660.48664092134 "$node_(42) setdest 1737 515 10.0" 
$ns at 757.5581785545554 "$node_(42) setdest 21 859 10.0" 
$ns at 860.6465600015557 "$node_(42) setdest 631 432 1.0" 
$ns at 899.5504697256409 "$node_(42) setdest 2443 994 1.0" 
$ns at 0.0 "$node_(43) setdest 186 780 12.0" 
$ns at 64.6197341718313 "$node_(43) setdest 1384 998 19.0" 
$ns at 207.7263457714211 "$node_(43) setdest 2821 209 6.0" 
$ns at 271.5629050271976 "$node_(43) setdest 408 174 20.0" 
$ns at 498.14721200476816 "$node_(43) setdest 837 709 7.0" 
$ns at 570.8508854937171 "$node_(43) setdest 1122 738 4.0" 
$ns at 606.9078302482042 "$node_(43) setdest 51 985 5.0" 
$ns at 685.5669219350358 "$node_(43) setdest 747 697 9.0" 
$ns at 790.6194831468367 "$node_(43) setdest 897 373 13.0" 
$ns at 0.0 "$node_(44) setdest 2806 724 3.0" 
$ns at 54.33428863215386 "$node_(44) setdest 1243 996 9.0" 
$ns at 149.88792741264584 "$node_(44) setdest 2082 335 1.0" 
$ns at 184.3116446912074 "$node_(44) setdest 1970 115 18.0" 
$ns at 337.65142792559413 "$node_(44) setdest 1759 975 5.0" 
$ns at 379.99682165920746 "$node_(44) setdest 78 902 15.0" 
$ns at 453.1659222532687 "$node_(44) setdest 1377 824 15.0" 
$ns at 585.2739006559225 "$node_(44) setdest 2852 57 15.0" 
$ns at 681.4232220841265 "$node_(44) setdest 33 420 12.0" 
$ns at 771.7511226796161 "$node_(44) setdest 1373 13 15.0" 
$ns at 870.2135469026632 "$node_(44) setdest 2947 426 11.0" 
$ns at 0.0 "$node_(45) setdest 1379 660 9.0" 
$ns at 77.45149227022333 "$node_(45) setdest 2324 115 10.0" 
$ns at 166.7981915442484 "$node_(45) setdest 281 809 7.0" 
$ns at 266.6498553332053 "$node_(45) setdest 149 422 1.0" 
$ns at 297.5230745416771 "$node_(45) setdest 839 841 19.0" 
$ns at 365.1255393534591 "$node_(45) setdest 317 630 6.0" 
$ns at 400.6666743355985 "$node_(45) setdest 2789 266 3.0" 
$ns at 456.4590598104171 "$node_(45) setdest 260 26 2.0" 
$ns at 489.0981454893348 "$node_(45) setdest 1441 129 4.0" 
$ns at 534.6874149867916 "$node_(45) setdest 964 117 19.0" 
$ns at 603.990101571771 "$node_(45) setdest 2030 482 9.0" 
$ns at 680.0717812102386 "$node_(45) setdest 1034 224 9.0" 
$ns at 740.3036489876251 "$node_(45) setdest 2341 380 13.0" 
$ns at 777.4387578074326 "$node_(45) setdest 1203 550 9.0" 
$ns at 883.2899888498932 "$node_(45) setdest 1899 100 8.0" 
$ns at 0.0 "$node_(46) setdest 1447 43 6.0" 
$ns at 31.98889854445108 "$node_(46) setdest 729 544 13.0" 
$ns at 108.39133062007573 "$node_(46) setdest 599 642 19.0" 
$ns at 168.16689471937238 "$node_(46) setdest 2485 37 13.0" 
$ns at 263.71468778614025 "$node_(46) setdest 121 741 7.0" 
$ns at 349.63969412289 "$node_(46) setdest 1469 974 18.0" 
$ns at 421.0588822858111 "$node_(46) setdest 2430 939 10.0" 
$ns at 460.71898393006063 "$node_(46) setdest 2803 13 5.0" 
$ns at 492.17471740685437 "$node_(46) setdest 937 430 1.0" 
$ns at 526.3959924670258 "$node_(46) setdest 2808 795 6.0" 
$ns at 604.5000735495362 "$node_(46) setdest 1698 589 9.0" 
$ns at 673.2736026989662 "$node_(46) setdest 1341 374 17.0" 
$ns at 734.6234857098331 "$node_(46) setdest 326 614 1.0" 
$ns at 770.781905824976 "$node_(46) setdest 1635 822 8.0" 
$ns at 815.0320432236451 "$node_(46) setdest 577 283 14.0" 
$ns at 0.0 "$node_(47) setdest 1911 727 4.0" 
$ns at 33.80678839402294 "$node_(47) setdest 2747 165 9.0" 
$ns at 150.77133457523016 "$node_(47) setdest 1797 522 10.0" 
$ns at 190.13211320717437 "$node_(47) setdest 1797 880 12.0" 
$ns at 226.05329954514974 "$node_(47) setdest 2314 867 5.0" 
$ns at 297.0033697538514 "$node_(47) setdest 2848 214 9.0" 
$ns at 382.7932807469086 "$node_(47) setdest 2984 535 5.0" 
$ns at 458.93762652037555 "$node_(47) setdest 2457 200 11.0" 
$ns at 496.5153983318619 "$node_(47) setdest 308 507 2.0" 
$ns at 536.0666202294987 "$node_(47) setdest 1814 473 18.0" 
$ns at 603.6630368471087 "$node_(47) setdest 1663 241 14.0" 
$ns at 711.6007481894906 "$node_(47) setdest 1776 497 7.0" 
$ns at 771.6394780279439 "$node_(47) setdest 387 310 19.0" 
$ns at 896.8920881554894 "$node_(47) setdest 2387 485 9.0" 
$ns at 0.0 "$node_(48) setdest 2574 880 8.0" 
$ns at 81.25773376101375 "$node_(48) setdest 273 107 2.0" 
$ns at 121.74966538131763 "$node_(48) setdest 1870 722 10.0" 
$ns at 200.51725825092052 "$node_(48) setdest 2086 296 18.0" 
$ns at 297.2726167196064 "$node_(48) setdest 284 724 12.0" 
$ns at 408.6073185604747 "$node_(48) setdest 882 769 19.0" 
$ns at 628.2098032205599 "$node_(48) setdest 2798 105 12.0" 
$ns at 678.8740360380324 "$node_(48) setdest 1095 52 1.0" 
$ns at 711.8915642517096 "$node_(48) setdest 1302 794 2.0" 
$ns at 751.7588953650986 "$node_(48) setdest 1505 128 13.0" 
$ns at 806.0233001203118 "$node_(48) setdest 134 669 13.0" 
$ns at 837.7610041121751 "$node_(48) setdest 2351 23 20.0" 
$ns at 0.0 "$node_(49) setdest 1247 633 20.0" 
$ns at 142.86412931865505 "$node_(49) setdest 1495 907 11.0" 
$ns at 179.31129367586593 "$node_(49) setdest 2783 709 8.0" 
$ns at 280.5428609334552 "$node_(49) setdest 2294 557 2.0" 
$ns at 329.65775024387284 "$node_(49) setdest 2583 632 14.0" 
$ns at 459.19301769471787 "$node_(49) setdest 2567 257 10.0" 
$ns at 502.72026269662445 "$node_(49) setdest 1908 637 8.0" 
$ns at 565.877091912887 "$node_(49) setdest 825 456 4.0" 
$ns at 607.304643627168 "$node_(49) setdest 2403 397 12.0" 
$ns at 715.5919573139653 "$node_(49) setdest 2657 788 9.0" 
$ns at 826.9142028309114 "$node_(49) setdest 2066 323 5.0" 
$ns at 874.5722427305911 "$node_(49) setdest 1929 272 2.0" 
$ns at 0.0 "$node_(50) setdest 2780 678 9.0" 
$ns at 113.25737097559632 "$node_(50) setdest 2198 768 12.0" 
$ns at 169.17737843839834 "$node_(50) setdest 643 225 15.0" 
$ns at 299.4169115303413 "$node_(50) setdest 489 41 2.0" 
$ns at 341.1077891025112 "$node_(50) setdest 170 342 3.0" 
$ns at 391.0512730646243 "$node_(50) setdest 342 998 8.0" 
$ns at 435.35946367343263 "$node_(50) setdest 1103 835 2.0" 
$ns at 478.69424364724193 "$node_(50) setdest 1783 934 8.0" 
$ns at 544.3893676733633 "$node_(50) setdest 381 896 5.0" 
$ns at 611.9743497732169 "$node_(50) setdest 611 874 5.0" 
$ns at 643.4209576086901 "$node_(50) setdest 1545 909 4.0" 
$ns at 704.0238741538799 "$node_(50) setdest 167 337 4.0" 
$ns at 743.9582538228018 "$node_(50) setdest 591 69 17.0" 
$ns at 215.74800210065166 "$node_(51) setdest 2435 855 6.0" 
$ns at 287.3835989317976 "$node_(51) setdest 2932 934 10.0" 
$ns at 379.8073739282796 "$node_(51) setdest 2392 644 10.0" 
$ns at 426.60666602412095 "$node_(51) setdest 2444 860 17.0" 
$ns at 516.7325694786099 "$node_(51) setdest 1368 742 2.0" 
$ns at 559.987752959182 "$node_(51) setdest 1131 88 1.0" 
$ns at 592.8377072079489 "$node_(51) setdest 2722 224 7.0" 
$ns at 644.4274220280088 "$node_(51) setdest 599 949 6.0" 
$ns at 715.7828815631473 "$node_(51) setdest 2969 261 1.0" 
$ns at 753.1311345115881 "$node_(51) setdest 1709 382 11.0" 
$ns at 879.5521638859923 "$node_(51) setdest 2147 158 9.0" 
$ns at 285.68201671103213 "$node_(52) setdest 237 697 16.0" 
$ns at 458.68819386624125 "$node_(52) setdest 2976 754 16.0" 
$ns at 488.9363607067943 "$node_(52) setdest 2288 748 1.0" 
$ns at 519.8380709442312 "$node_(52) setdest 1436 899 5.0" 
$ns at 565.6183689481337 "$node_(52) setdest 1152 277 2.0" 
$ns at 597.1375169543227 "$node_(52) setdest 899 921 20.0" 
$ns at 818.1102691141095 "$node_(52) setdest 2112 377 20.0" 
$ns at 232.69709864468015 "$node_(53) setdest 1041 853 19.0" 
$ns at 377.8766098499476 "$node_(53) setdest 2233 525 13.0" 
$ns at 461.5617260179338 "$node_(53) setdest 1951 615 10.0" 
$ns at 590.6972485990466 "$node_(53) setdest 2971 345 16.0" 
$ns at 764.5974705502879 "$node_(53) setdest 1392 831 6.0" 
$ns at 804.4629253644333 "$node_(53) setdest 773 747 14.0" 
$ns at 293.09136808831823 "$node_(54) setdest 426 553 2.0" 
$ns at 333.10201918469556 "$node_(54) setdest 200 558 14.0" 
$ns at 369.58157107771945 "$node_(54) setdest 908 851 12.0" 
$ns at 495.31824242862956 "$node_(54) setdest 224 243 2.0" 
$ns at 539.5760474062479 "$node_(54) setdest 2711 303 15.0" 
$ns at 669.0966703936003 "$node_(54) setdest 1574 176 20.0" 
$ns at 879.5646515981339 "$node_(54) setdest 1830 135 10.0" 
$ns at 184.9973044229831 "$node_(55) setdest 957 766 17.0" 
$ns at 343.6423128979442 "$node_(55) setdest 2172 741 7.0" 
$ns at 395.3596895916289 "$node_(55) setdest 2503 633 1.0" 
$ns at 425.9936257797458 "$node_(55) setdest 1494 767 19.0" 
$ns at 483.67214167460395 "$node_(55) setdest 2201 277 16.0" 
$ns at 670.8837152489457 "$node_(55) setdest 2323 965 14.0" 
$ns at 766.6892104582419 "$node_(55) setdest 229 301 9.0" 
$ns at 854.7142076445019 "$node_(55) setdest 1058 894 18.0" 
$ns at 172.10543786957726 "$node_(56) setdest 2945 137 3.0" 
$ns at 203.36933375519172 "$node_(56) setdest 2635 401 2.0" 
$ns at 235.67854129666716 "$node_(56) setdest 1893 569 6.0" 
$ns at 301.9824337160339 "$node_(56) setdest 2925 137 7.0" 
$ns at 385.21686392961465 "$node_(56) setdest 1636 785 5.0" 
$ns at 428.8714343268588 "$node_(56) setdest 611 988 17.0" 
$ns at 617.8776120287915 "$node_(56) setdest 156 198 8.0" 
$ns at 680.1013604686038 "$node_(56) setdest 333 918 12.0" 
$ns at 740.3312567359051 "$node_(56) setdest 214 279 8.0" 
$ns at 813.4590947116019 "$node_(56) setdest 1084 700 16.0" 
$ns at 881.2163997010955 "$node_(56) setdest 23 852 3.0" 
$ns at 284.1581836295769 "$node_(57) setdest 789 655 12.0" 
$ns at 403.6918431322142 "$node_(57) setdest 1672 282 6.0" 
$ns at 443.812654909241 "$node_(57) setdest 2337 211 1.0" 
$ns at 476.7607588138461 "$node_(57) setdest 2643 107 18.0" 
$ns at 648.4484681889578 "$node_(57) setdest 872 741 17.0" 
$ns at 696.533639083483 "$node_(57) setdest 356 303 5.0" 
$ns at 736.5661992251693 "$node_(57) setdest 1494 647 15.0" 
$ns at 771.1173399521908 "$node_(57) setdest 2949 834 18.0" 
$ns at 894.2888732869736 "$node_(57) setdest 137 826 19.0" 
$ns at 176.2124288483007 "$node_(58) setdest 1150 453 4.0" 
$ns at 217.40871801746127 "$node_(58) setdest 1108 39 17.0" 
$ns at 397.51328471312036 "$node_(58) setdest 975 586 12.0" 
$ns at 497.4406590351088 "$node_(58) setdest 1485 654 17.0" 
$ns at 633.365174566013 "$node_(58) setdest 1869 413 10.0" 
$ns at 762.0938458904095 "$node_(58) setdest 57 163 19.0" 
$ns at 869.0744000396073 "$node_(58) setdest 2316 283 9.0" 
$ns at 213.08054390604147 "$node_(59) setdest 929 344 18.0" 
$ns at 419.992886907123 "$node_(59) setdest 2394 496 3.0" 
$ns at 461.7975949661747 "$node_(59) setdest 2156 17 2.0" 
$ns at 500.94445354255015 "$node_(59) setdest 51 874 2.0" 
$ns at 538.227529626971 "$node_(59) setdest 2720 798 9.0" 
$ns at 630.6013683778606 "$node_(59) setdest 2360 691 4.0" 
$ns at 684.5573716306457 "$node_(59) setdest 2810 233 1.0" 
$ns at 722.1666837556897 "$node_(59) setdest 968 525 18.0" 
$ns at 899.5133823327582 "$node_(59) setdest 925 166 13.0" 
$ns at 198.70360958099565 "$node_(60) setdest 2985 11 14.0" 
$ns at 247.0642184512986 "$node_(60) setdest 1060 236 14.0" 
$ns at 379.33794751846335 "$node_(60) setdest 903 487 19.0" 
$ns at 595.7629850072818 "$node_(60) setdest 26 811 7.0" 
$ns at 688.6088791058128 "$node_(60) setdest 489 876 8.0" 
$ns at 777.0612139261158 "$node_(60) setdest 327 51 18.0" 
$ns at 838.7407110713501 "$node_(60) setdest 1128 940 11.0" 
$ns at 233.53239326864784 "$node_(61) setdest 1155 767 19.0" 
$ns at 354.48903033902104 "$node_(61) setdest 449 240 6.0" 
$ns at 389.03366366209866 "$node_(61) setdest 2104 5 15.0" 
$ns at 451.72289795677074 "$node_(61) setdest 506 70 16.0" 
$ns at 560.2596418320758 "$node_(61) setdest 1986 786 5.0" 
$ns at 612.2134712601986 "$node_(61) setdest 78 931 2.0" 
$ns at 651.0338981911431 "$node_(61) setdest 1175 646 19.0" 
$ns at 797.637977382042 "$node_(61) setdest 551 684 20.0" 
$ns at 880.5393415120866 "$node_(61) setdest 73 89 17.0" 
$ns at 167.21295663655695 "$node_(62) setdest 99 232 17.0" 
$ns at 255.59438231852099 "$node_(62) setdest 2069 646 3.0" 
$ns at 302.17294333883973 "$node_(62) setdest 2009 683 11.0" 
$ns at 368.7728797632763 "$node_(62) setdest 2790 617 15.0" 
$ns at 526.2002864873334 "$node_(62) setdest 560 691 13.0" 
$ns at 681.4319245448727 "$node_(62) setdest 1652 620 17.0" 
$ns at 781.5465081142016 "$node_(62) setdest 713 776 8.0" 
$ns at 877.1874842721804 "$node_(62) setdest 489 123 13.0" 
$ns at 250.26860539079314 "$node_(63) setdest 205 319 8.0" 
$ns at 290.56355191800776 "$node_(63) setdest 1037 717 5.0" 
$ns at 370.09367797384334 "$node_(63) setdest 1627 698 9.0" 
$ns at 481.67686326194644 "$node_(63) setdest 2061 539 7.0" 
$ns at 515.2856865412305 "$node_(63) setdest 1664 118 14.0" 
$ns at 675.0254040185237 "$node_(63) setdest 1431 302 8.0" 
$ns at 736.369845369518 "$node_(63) setdest 220 726 6.0" 
$ns at 783.8139837438497 "$node_(63) setdest 84 76 18.0" 
$ns at 266.9460616419136 "$node_(64) setdest 232 689 13.0" 
$ns at 415.82934729227014 "$node_(64) setdest 1034 953 8.0" 
$ns at 472.00000325623756 "$node_(64) setdest 466 778 15.0" 
$ns at 649.2808503342303 "$node_(64) setdest 202 813 20.0" 
$ns at 823.5944268105106 "$node_(64) setdest 1121 182 17.0" 
$ns at 897.1592541410338 "$node_(64) setdest 1057 879 19.0" 
$ns at 166.32270242124773 "$node_(65) setdest 1067 952 2.0" 
$ns at 211.75573378589118 "$node_(65) setdest 2868 713 15.0" 
$ns at 287.11571725491115 "$node_(65) setdest 1062 7 1.0" 
$ns at 321.82698103812606 "$node_(65) setdest 297 888 19.0" 
$ns at 401.9894175011402 "$node_(65) setdest 2314 345 6.0" 
$ns at 437.3806848583068 "$node_(65) setdest 2192 75 16.0" 
$ns at 513.0788282506614 "$node_(65) setdest 1056 319 17.0" 
$ns at 610.038551930631 "$node_(65) setdest 1200 385 15.0" 
$ns at 752.5382130006612 "$node_(65) setdest 1935 99 18.0" 
$ns at 190.70725704665836 "$node_(66) setdest 2212 177 2.0" 
$ns at 223.12606611420526 "$node_(66) setdest 1175 597 12.0" 
$ns at 291.40011964250215 "$node_(66) setdest 2999 991 6.0" 
$ns at 333.32370483430384 "$node_(66) setdest 169 23 17.0" 
$ns at 365.6008920923304 "$node_(66) setdest 2293 184 14.0" 
$ns at 447.8222444141239 "$node_(66) setdest 1079 265 16.0" 
$ns at 538.7563833209217 "$node_(66) setdest 785 671 6.0" 
$ns at 623.0599290863053 "$node_(66) setdest 223 804 3.0" 
$ns at 678.5825600915736 "$node_(66) setdest 1175 549 13.0" 
$ns at 813.8570250567843 "$node_(66) setdest 2090 377 18.0" 
$ns at 868.1949253800759 "$node_(66) setdest 1151 688 16.0" 
$ns at 314.06696337587425 "$node_(67) setdest 1859 131 14.0" 
$ns at 427.0683312535144 "$node_(67) setdest 1298 129 20.0" 
$ns at 632.092703174161 "$node_(67) setdest 1952 916 2.0" 
$ns at 670.35017032529 "$node_(67) setdest 1225 510 8.0" 
$ns at 743.8579793777744 "$node_(67) setdest 733 495 4.0" 
$ns at 775.3024508807846 "$node_(67) setdest 1519 724 15.0" 
$ns at 205.21275732934413 "$node_(68) setdest 1128 169 17.0" 
$ns at 295.63965085664955 "$node_(68) setdest 2161 908 4.0" 
$ns at 334.70508382306355 "$node_(68) setdest 1196 672 4.0" 
$ns at 390.2771481028557 "$node_(68) setdest 2655 212 5.0" 
$ns at 422.12417259575477 "$node_(68) setdest 1321 602 7.0" 
$ns at 486.72262087490446 "$node_(68) setdest 2934 423 1.0" 
$ns at 518.1576070592172 "$node_(68) setdest 247 465 13.0" 
$ns at 654.949802180936 "$node_(68) setdest 1307 592 18.0" 
$ns at 716.5337074387243 "$node_(68) setdest 2346 650 5.0" 
$ns at 767.3266711258656 "$node_(68) setdest 2456 200 13.0" 
$ns at 798.6731934873318 "$node_(68) setdest 279 417 15.0" 
$ns at 253.5806815558263 "$node_(69) setdest 1080 795 18.0" 
$ns at 368.26310255955656 "$node_(69) setdest 1236 808 15.0" 
$ns at 493.0208392746758 "$node_(69) setdest 2827 319 13.0" 
$ns at 551.9329825338314 "$node_(69) setdest 2854 447 5.0" 
$ns at 600.8100708058263 "$node_(69) setdest 883 928 18.0" 
$ns at 719.6924345588919 "$node_(69) setdest 1825 197 1.0" 
$ns at 756.4642941684162 "$node_(69) setdest 1675 221 6.0" 
$ns at 791.6078050518244 "$node_(69) setdest 2213 912 1.0" 
$ns at 830.8695557072152 "$node_(69) setdest 284 353 2.0" 
$ns at 860.914270064256 "$node_(69) setdest 2197 183 12.0" 
$ns at 891.5304925264244 "$node_(69) setdest 838 214 12.0" 
$ns at 205.3243514982151 "$node_(70) setdest 1252 805 15.0" 
$ns at 327.55883753815306 "$node_(70) setdest 765 473 2.0" 
$ns at 358.3994452872264 "$node_(70) setdest 737 618 19.0" 
$ns at 522.0218416865187 "$node_(70) setdest 299 620 7.0" 
$ns at 573.4253072771792 "$node_(70) setdest 2766 226 10.0" 
$ns at 621.1016405496131 "$node_(70) setdest 751 325 4.0" 
$ns at 678.2630853112645 "$node_(70) setdest 2731 621 4.0" 
$ns at 741.1158037800951 "$node_(70) setdest 2665 848 18.0" 
$ns at 223.84864205307008 "$node_(71) setdest 1739 909 6.0" 
$ns at 267.26072479534366 "$node_(71) setdest 2079 772 19.0" 
$ns at 424.42776383371006 "$node_(71) setdest 940 506 15.0" 
$ns at 492.7411842666751 "$node_(71) setdest 740 433 6.0" 
$ns at 582.1981222159551 "$node_(71) setdest 499 969 2.0" 
$ns at 619.1033871631923 "$node_(71) setdest 1870 852 3.0" 
$ns at 672.551573521546 "$node_(71) setdest 2422 799 1.0" 
$ns at 709.207773822243 "$node_(71) setdest 2282 957 6.0" 
$ns at 783.4901361052256 "$node_(71) setdest 105 713 17.0" 
$ns at 852.307903028708 "$node_(71) setdest 1508 232 3.0" 
$ns at 172.9717275410237 "$node_(72) setdest 413 488 17.0" 
$ns at 303.0286534917828 "$node_(72) setdest 2632 736 1.0" 
$ns at 335.54521700923874 "$node_(72) setdest 536 935 1.0" 
$ns at 371.6880206106578 "$node_(72) setdest 1240 303 17.0" 
$ns at 461.19256251002395 "$node_(72) setdest 1092 99 9.0" 
$ns at 550.9699227544193 "$node_(72) setdest 274 36 1.0" 
$ns at 581.5042817283534 "$node_(72) setdest 993 985 6.0" 
$ns at 661.1067315132402 "$node_(72) setdest 2168 904 17.0" 
$ns at 742.8095933179002 "$node_(72) setdest 2290 668 5.0" 
$ns at 799.2818968225589 "$node_(72) setdest 1093 840 7.0" 
$ns at 857.7540592298955 "$node_(72) setdest 853 457 12.0" 
$ns at 199.38724632467398 "$node_(73) setdest 41 43 1.0" 
$ns at 237.9137628789187 "$node_(73) setdest 1794 439 6.0" 
$ns at 296.6850871440895 "$node_(73) setdest 1141 463 4.0" 
$ns at 328.5744698950768 "$node_(73) setdest 1844 28 1.0" 
$ns at 360.7187481424047 "$node_(73) setdest 1934 169 9.0" 
$ns at 405.05267571099074 "$node_(73) setdest 2029 216 7.0" 
$ns at 463.6626097760883 "$node_(73) setdest 2197 293 9.0" 
$ns at 562.2385282632983 "$node_(73) setdest 1507 751 20.0" 
$ns at 675.2471493523852 "$node_(73) setdest 1411 686 3.0" 
$ns at 724.9440029738201 "$node_(73) setdest 2365 911 9.0" 
$ns at 838.0160298424346 "$node_(73) setdest 2556 638 18.0" 
$ns at 179.54166201145097 "$node_(74) setdest 2150 909 1.0" 
$ns at 215.68760163812482 "$node_(74) setdest 713 167 12.0" 
$ns at 265.3977101048918 "$node_(74) setdest 2623 272 1.0" 
$ns at 304.95467203149036 "$node_(74) setdest 1469 92 3.0" 
$ns at 358.66975776479524 "$node_(74) setdest 2139 139 11.0" 
$ns at 461.3925111209537 "$node_(74) setdest 1086 869 2.0" 
$ns at 491.5191034985628 "$node_(74) setdest 674 408 20.0" 
$ns at 647.6716855199251 "$node_(74) setdest 1207 759 7.0" 
$ns at 747.5288291421654 "$node_(74) setdest 1064 652 18.0" 
$ns at 378.50678995860693 "$node_(75) setdest 1352 634 12.0" 
$ns at 476.31675884795317 "$node_(75) setdest 1634 30 1.0" 
$ns at 506.53468464451026 "$node_(75) setdest 824 672 2.0" 
$ns at 548.6436111486786 "$node_(75) setdest 126 933 16.0" 
$ns at 701.1826007680487 "$node_(75) setdest 1709 845 10.0" 
$ns at 781.1481046391726 "$node_(75) setdest 1095 664 3.0" 
$ns at 837.5442158052069 "$node_(75) setdest 906 824 18.0" 
$ns at 354.62332521004936 "$node_(76) setdest 1676 399 1.0" 
$ns at 390.94281744021043 "$node_(76) setdest 2739 450 7.0" 
$ns at 433.03090316506984 "$node_(76) setdest 146 522 3.0" 
$ns at 471.3398562822324 "$node_(76) setdest 1347 471 17.0" 
$ns at 534.1520985471323 "$node_(76) setdest 377 455 10.0" 
$ns at 607.6461160587809 "$node_(76) setdest 1647 457 19.0" 
$ns at 661.5276458416776 "$node_(76) setdest 1695 521 8.0" 
$ns at 710.4470016562351 "$node_(76) setdest 1324 415 9.0" 
$ns at 817.5060885813413 "$node_(76) setdest 2050 567 18.0" 
$ns at 474.05334399125263 "$node_(77) setdest 315 882 14.0" 
$ns at 637.0980863673615 "$node_(77) setdest 2175 364 13.0" 
$ns at 680.8490736370514 "$node_(77) setdest 2194 606 17.0" 
$ns at 802.3976110266758 "$node_(77) setdest 2943 584 6.0" 
$ns at 841.7935696399487 "$node_(77) setdest 1967 889 19.0" 
$ns at 458.46518430403836 "$node_(78) setdest 1893 649 9.0" 
$ns at 489.8616395006383 "$node_(78) setdest 875 341 1.0" 
$ns at 521.1818951492736 "$node_(78) setdest 2038 896 13.0" 
$ns at 674.5907336481213 "$node_(78) setdest 682 465 18.0" 
$ns at 883.5996482802315 "$node_(78) setdest 2761 304 1.0" 
$ns at 380.1365315027374 "$node_(79) setdest 2111 991 3.0" 
$ns at 411.10863820623956 "$node_(79) setdest 607 1 12.0" 
$ns at 456.5252909837947 "$node_(79) setdest 2149 455 10.0" 
$ns at 566.40390130107 "$node_(79) setdest 2707 912 5.0" 
$ns at 626.7248978761086 "$node_(79) setdest 2961 60 5.0" 
$ns at 684.7144100023922 "$node_(79) setdest 2390 854 13.0" 
$ns at 717.5841836152601 "$node_(79) setdest 896 230 11.0" 
$ns at 749.8226741045326 "$node_(79) setdest 1155 469 19.0" 
$ns at 339.395885897817 "$node_(80) setdest 2071 390 19.0" 
$ns at 428.5863963432282 "$node_(80) setdest 94 146 4.0" 
$ns at 462.38306795967355 "$node_(80) setdest 2344 509 20.0" 
$ns at 531.1383579702408 "$node_(80) setdest 2453 816 9.0" 
$ns at 609.0205954262073 "$node_(80) setdest 151 107 20.0" 
$ns at 758.3887779972999 "$node_(80) setdest 1489 157 19.0" 
$ns at 378.72369802889375 "$node_(81) setdest 1027 620 19.0" 
$ns at 541.9136953658888 "$node_(81) setdest 2513 703 10.0" 
$ns at 582.8265783045528 "$node_(81) setdest 2417 961 7.0" 
$ns at 668.7163497956681 "$node_(81) setdest 1417 398 11.0" 
$ns at 726.1589453358077 "$node_(81) setdest 1808 146 15.0" 
$ns at 811.9793387722121 "$node_(81) setdest 984 416 16.0" 
$ns at 889.3682529693342 "$node_(81) setdest 684 789 13.0" 
$ns at 428.1015231073268 "$node_(82) setdest 1092 930 15.0" 
$ns at 522.6158406317776 "$node_(82) setdest 1042 827 13.0" 
$ns at 625.5690099830397 "$node_(82) setdest 543 922 12.0" 
$ns at 729.720637497283 "$node_(82) setdest 2100 372 12.0" 
$ns at 864.6899010554919 "$node_(82) setdest 1002 910 6.0" 
$ns at 366.77358911963927 "$node_(83) setdest 2594 337 17.0" 
$ns at 523.495255801388 "$node_(83) setdest 1373 217 3.0" 
$ns at 582.2699467726371 "$node_(83) setdest 988 915 16.0" 
$ns at 677.3253092836422 "$node_(83) setdest 2571 239 17.0" 
$ns at 829.237768912523 "$node_(83) setdest 1437 610 18.0" 
$ns at 386.52912546048054 "$node_(84) setdest 588 979 12.0" 
$ns at 481.800051763596 "$node_(84) setdest 2603 825 12.0" 
$ns at 558.4798009084822 "$node_(84) setdest 60 347 11.0" 
$ns at 601.5702052962897 "$node_(84) setdest 1675 685 7.0" 
$ns at 693.3719791656599 "$node_(84) setdest 2529 399 14.0" 
$ns at 745.1622175495869 "$node_(84) setdest 1796 528 20.0" 
$ns at 880.4642359670001 "$node_(84) setdest 736 244 5.0" 
$ns at 373.1806217175169 "$node_(85) setdest 1903 670 12.0" 
$ns at 421.25096899303475 "$node_(85) setdest 472 7 5.0" 
$ns at 475.5297952582796 "$node_(85) setdest 2225 958 14.0" 
$ns at 632.7142880984378 "$node_(85) setdest 1314 434 12.0" 
$ns at 690.3191531488842 "$node_(85) setdest 913 23 13.0" 
$ns at 820.2647759179383 "$node_(85) setdest 319 726 11.0" 
$ns at 360.3739350079798 "$node_(86) setdest 172 440 1.0" 
$ns at 393.1319927043071 "$node_(86) setdest 1363 752 2.0" 
$ns at 426.07233648096246 "$node_(86) setdest 2055 244 1.0" 
$ns at 457.7170568396694 "$node_(86) setdest 2300 209 10.0" 
$ns at 563.6062927612261 "$node_(86) setdest 361 290 5.0" 
$ns at 629.05481054427 "$node_(86) setdest 1563 805 13.0" 
$ns at 702.4532541018393 "$node_(86) setdest 2871 972 2.0" 
$ns at 732.9835440660089 "$node_(86) setdest 766 813 2.0" 
$ns at 766.7755291763732 "$node_(86) setdest 1619 862 1.0" 
$ns at 798.5576281308338 "$node_(86) setdest 595 808 6.0" 
$ns at 861.8952534408452 "$node_(86) setdest 199 839 14.0" 
$ns at 393.06451987235073 "$node_(87) setdest 1682 196 8.0" 
$ns at 463.05509467484876 "$node_(87) setdest 2271 765 19.0" 
$ns at 569.566246262269 "$node_(87) setdest 2812 738 20.0" 
$ns at 751.9506220719908 "$node_(87) setdest 2243 125 8.0" 
$ns at 859.1250364795476 "$node_(87) setdest 2608 167 18.0" 
$ns at 897.3526300243013 "$node_(87) setdest 250 627 7.0" 
$ns at 338.0681269363475 "$node_(88) setdest 2927 648 13.0" 
$ns at 478.87812044192043 "$node_(88) setdest 327 821 12.0" 
$ns at 576.6497007176122 "$node_(88) setdest 2559 280 19.0" 
$ns at 756.9946639835457 "$node_(88) setdest 218 524 12.0" 
$ns at 796.5603345720739 "$node_(88) setdest 343 73 1.0" 
$ns at 830.0664352153092 "$node_(88) setdest 851 363 10.0" 
$ns at 863.7846714164141 "$node_(88) setdest 1126 981 5.0" 
$ns at 342.639254603245 "$node_(89) setdest 33 852 6.0" 
$ns at 378.6094787423875 "$node_(89) setdest 554 127 14.0" 
$ns at 499.65112130619434 "$node_(89) setdest 745 117 1.0" 
$ns at 532.527887094238 "$node_(89) setdest 2660 167 12.0" 
$ns at 664.3284958360838 "$node_(89) setdest 978 72 2.0" 
$ns at 713.2834297618708 "$node_(89) setdest 2718 741 7.0" 
$ns at 780.1723071971733 "$node_(89) setdest 1137 874 19.0" 
$ns at 873.751816646566 "$node_(89) setdest 154 95 15.0" 
$ns at 437.89692266210704 "$node_(90) setdest 940 493 15.0" 
$ns at 530.5735575463918 "$node_(90) setdest 421 88 5.0" 
$ns at 583.7678610309378 "$node_(90) setdest 114 333 14.0" 
$ns at 733.8673787814384 "$node_(90) setdest 1750 100 19.0" 
$ns at 831.9736557375109 "$node_(90) setdest 339 155 4.0" 
$ns at 885.6217873930873 "$node_(90) setdest 2321 771 19.0" 
$ns at 388.89956034039216 "$node_(91) setdest 1921 632 1.0" 
$ns at 423.57111956472033 "$node_(91) setdest 633 543 1.0" 
$ns at 463.11773210285276 "$node_(91) setdest 1807 796 13.0" 
$ns at 497.6364711756754 "$node_(91) setdest 1115 4 2.0" 
$ns at 535.2847828818723 "$node_(91) setdest 1523 713 16.0" 
$ns at 587.8992219794054 "$node_(91) setdest 1037 855 9.0" 
$ns at 641.0727558420894 "$node_(91) setdest 792 665 7.0" 
$ns at 735.6656407735635 "$node_(91) setdest 412 916 6.0" 
$ns at 788.6767359211111 "$node_(91) setdest 2727 416 4.0" 
$ns at 842.6706432175235 "$node_(91) setdest 1368 345 1.0" 
$ns at 878.9631072168136 "$node_(91) setdest 372 381 16.0" 
$ns at 359.7543192912197 "$node_(92) setdest 1156 880 11.0" 
$ns at 445.4919242107376 "$node_(92) setdest 1888 306 17.0" 
$ns at 490.8827511479919 "$node_(92) setdest 30 509 3.0" 
$ns at 522.8667368714866 "$node_(92) setdest 2408 640 12.0" 
$ns at 652.21698844261 "$node_(92) setdest 2565 972 13.0" 
$ns at 783.0701269631716 "$node_(92) setdest 2488 697 3.0" 
$ns at 831.6206032619041 "$node_(92) setdest 570 25 14.0" 
$ns at 861.6232606998645 "$node_(92) setdest 1471 777 5.0" 
$ns at 428.10603848306914 "$node_(93) setdest 257 60 15.0" 
$ns at 606.6089374203573 "$node_(93) setdest 2346 599 20.0" 
$ns at 657.551603130433 "$node_(93) setdest 1071 832 15.0" 
$ns at 694.2793844131681 "$node_(93) setdest 2362 408 18.0" 
$ns at 752.5697233248131 "$node_(93) setdest 2916 222 2.0" 
$ns at 789.0097981498005 "$node_(93) setdest 593 285 9.0" 
$ns at 875.2078334016041 "$node_(93) setdest 1819 155 4.0" 
$ns at 359.91487659179853 "$node_(94) setdest 2275 709 7.0" 
$ns at 451.9842682731597 "$node_(94) setdest 1900 106 4.0" 
$ns at 517.9286350964612 "$node_(94) setdest 2735 71 3.0" 
$ns at 577.9090607943801 "$node_(94) setdest 2987 881 19.0" 
$ns at 718.3148919547415 "$node_(94) setdest 8 449 2.0" 
$ns at 753.9924762857995 "$node_(94) setdest 1027 542 11.0" 
$ns at 855.734145243563 "$node_(94) setdest 671 670 1.0" 
$ns at 889.3426622417203 "$node_(94) setdest 2285 569 12.0" 
$ns at 376.3441360652804 "$node_(95) setdest 788 210 6.0" 
$ns at 437.83772185522776 "$node_(95) setdest 2080 123 15.0" 
$ns at 532.0910002535908 "$node_(95) setdest 123 153 8.0" 
$ns at 609.3801914580786 "$node_(95) setdest 1407 434 17.0" 
$ns at 708.4645351024875 "$node_(95) setdest 912 985 15.0" 
$ns at 825.3506937689618 "$node_(95) setdest 2646 304 8.0" 
$ns at 421.24830523483985 "$node_(96) setdest 897 405 7.0" 
$ns at 453.5418125021555 "$node_(96) setdest 119 636 5.0" 
$ns at 521.9513681584201 "$node_(96) setdest 1546 722 2.0" 
$ns at 562.5159252329075 "$node_(96) setdest 2418 174 11.0" 
$ns at 596.088257040444 "$node_(96) setdest 2836 53 16.0" 
$ns at 667.3307787139985 "$node_(96) setdest 1496 750 18.0" 
$ns at 785.1132467588254 "$node_(96) setdest 1425 377 10.0" 
$ns at 887.3739421139541 "$node_(96) setdest 170 163 3.0" 
$ns at 332.03867245145955 "$node_(97) setdest 2053 220 2.0" 
$ns at 373.3246191908741 "$node_(97) setdest 116 219 14.0" 
$ns at 532.0664835084186 "$node_(97) setdest 2565 711 9.0" 
$ns at 569.8087274345668 "$node_(97) setdest 1012 464 20.0" 
$ns at 659.4129704079835 "$node_(97) setdest 1517 682 2.0" 
$ns at 697.4289415160335 "$node_(97) setdest 1454 920 14.0" 
$ns at 801.1272864889518 "$node_(97) setdest 42 399 1.0" 
$ns at 837.5268758487256 "$node_(97) setdest 2939 521 14.0" 
$ns at 330.47707665807934 "$node_(98) setdest 325 642 14.0" 
$ns at 498.0646150069407 "$node_(98) setdest 1324 104 11.0" 
$ns at 539.4607958946908 "$node_(98) setdest 511 785 3.0" 
$ns at 570.9919624982299 "$node_(98) setdest 1878 913 12.0" 
$ns at 705.2487400072098 "$node_(98) setdest 414 462 5.0" 
$ns at 772.3433339995878 "$node_(98) setdest 221 281 4.0" 
$ns at 836.9311014535772 "$node_(98) setdest 1184 710 16.0" 
$ns at 361.6563417586219 "$node_(99) setdest 2061 496 1.0" 
$ns at 401.2124471135011 "$node_(99) setdest 1276 715 7.0" 
$ns at 477.5984204417499 "$node_(99) setdest 2670 440 14.0" 
$ns at 593.070203670407 "$node_(99) setdest 311 949 2.0" 
$ns at 631.23501069976 "$node_(99) setdest 2746 287 15.0" 
$ns at 739.1574212877706 "$node_(99) setdest 1565 432 4.0" 
$ns at 798.7630917793409 "$node_(99) setdest 1246 211 6.0" 
$ns at 859.9805484834985 "$node_(99) setdest 659 123 2.0" 
$ns at 701.1332986273691 "$node_(100) setdest 826 347 11.0" 
$ns at 744.146632390995 "$node_(100) setdest 2427 95 12.0" 
$ns at 812.0715441348686 "$node_(100) setdest 1882 69 2.0" 
$ns at 844.9829257746622 "$node_(100) setdest 2954 215 9.0" 
$ns at 696.4286570184337 "$node_(101) setdest 2181 540 17.0" 
$ns at 785.6486016743172 "$node_(101) setdest 1138 328 1.0" 
$ns at 825.4914347633367 "$node_(101) setdest 2853 169 14.0" 
$ns at 532.5324559675053 "$node_(102) setdest 151 801 17.0" 
$ns at 713.7405427104794 "$node_(102) setdest 1035 982 3.0" 
$ns at 757.6347122929566 "$node_(102) setdest 258 847 9.0" 
$ns at 839.4247431662478 "$node_(102) setdest 119 677 18.0" 
$ns at 586.8701144275147 "$node_(103) setdest 1668 2 1.0" 
$ns at 618.6585301619473 "$node_(103) setdest 1662 19 16.0" 
$ns at 738.6642560788696 "$node_(103) setdest 1422 520 18.0" 
$ns at 771.9566358231942 "$node_(103) setdest 1842 99 4.0" 
$ns at 830.1006775931905 "$node_(103) setdest 1758 915 1.0" 
$ns at 869.978972257554 "$node_(103) setdest 1943 908 15.0" 
$ns at 604.7997604921624 "$node_(104) setdest 493 167 8.0" 
$ns at 652.9834828347965 "$node_(104) setdest 1355 920 15.0" 
$ns at 797.5166469836413 "$node_(104) setdest 2848 592 12.0" 
$ns at 892.8419242264185 "$node_(104) setdest 477 525 13.0" 
$ns at 591.2104416602477 "$node_(105) setdest 1991 394 1.0" 
$ns at 623.3590485121366 "$node_(105) setdest 2452 764 12.0" 
$ns at 766.819181638566 "$node_(105) setdest 2336 990 1.0" 
$ns at 800.6470666796447 "$node_(105) setdest 2241 917 14.0" 
$ns at 546.8421978181448 "$node_(106) setdest 1962 725 2.0" 
$ns at 587.8905656641762 "$node_(106) setdest 83 317 1.0" 
$ns at 622.3358061836977 "$node_(106) setdest 2844 78 9.0" 
$ns at 732.7919577810788 "$node_(106) setdest 1697 736 15.0" 
$ns at 764.4178101854907 "$node_(106) setdest 1605 833 11.0" 
$ns at 831.8380668185036 "$node_(106) setdest 985 960 19.0" 
$ns at 549.0793931500272 "$node_(107) setdest 1328 165 2.0" 
$ns at 584.743594016548 "$node_(107) setdest 565 940 10.0" 
$ns at 668.6484650191262 "$node_(107) setdest 890 231 20.0" 
$ns at 773.6115146074204 "$node_(107) setdest 867 348 4.0" 
$ns at 810.1344421979097 "$node_(107) setdest 52 765 8.0" 
$ns at 585.1403935049044 "$node_(108) setdest 1413 316 9.0" 
$ns at 616.182130095125 "$node_(108) setdest 308 110 2.0" 
$ns at 647.6796820983222 "$node_(108) setdest 2574 535 10.0" 
$ns at 680.5608160656637 "$node_(108) setdest 875 692 4.0" 
$ns at 713.0989427287824 "$node_(108) setdest 924 770 16.0" 
$ns at 892.4206790914011 "$node_(108) setdest 266 259 19.0" 
$ns at 521.915917577337 "$node_(109) setdest 1830 379 15.0" 
$ns at 599.0918107034374 "$node_(109) setdest 2945 206 20.0" 
$ns at 653.6750837914909 "$node_(109) setdest 2919 665 12.0" 
$ns at 801.0795925588492 "$node_(109) setdest 2803 400 5.0" 
$ns at 863.9888273999964 "$node_(109) setdest 2664 320 2.0" 
$ns at 509.06986570954075 "$node_(110) setdest 962 738 16.0" 
$ns at 561.1084296637725 "$node_(110) setdest 2511 782 5.0" 
$ns at 604.6685543419958 "$node_(110) setdest 447 34 5.0" 
$ns at 636.8408982521295 "$node_(110) setdest 133 280 12.0" 
$ns at 775.2648555985261 "$node_(110) setdest 1866 981 18.0" 
$ns at 856.0532986438723 "$node_(110) setdest 1497 225 12.0" 
$ns at 509.56666887398967 "$node_(111) setdest 1780 706 16.0" 
$ns at 549.7940869252407 "$node_(111) setdest 1323 352 18.0" 
$ns at 695.290553171207 "$node_(111) setdest 2664 390 6.0" 
$ns at 747.5819508455851 "$node_(111) setdest 15 367 8.0" 
$ns at 786.2054061637001 "$node_(111) setdest 2094 171 19.0" 
$ns at 870.7449127571675 "$node_(111) setdest 1421 433 17.0" 
$ns at 568.6432140630702 "$node_(112) setdest 819 783 17.0" 
$ns at 638.2049615848098 "$node_(112) setdest 1488 993 17.0" 
$ns at 780.2612682997817 "$node_(112) setdest 2860 572 7.0" 
$ns at 834.7428362152835 "$node_(112) setdest 2332 731 7.0" 
$ns at 871.539962133498 "$node_(112) setdest 2862 119 2.0" 
$ns at 496.3485789814264 "$node_(113) setdest 962 128 2.0" 
$ns at 534.1651263298577 "$node_(113) setdest 1697 770 12.0" 
$ns at 623.1762205251725 "$node_(113) setdest 2113 703 12.0" 
$ns at 703.1208534087938 "$node_(113) setdest 1334 622 17.0" 
$ns at 899.01873817535 "$node_(113) setdest 1895 676 7.0" 
$ns at 515.5476004528595 "$node_(114) setdest 1257 835 9.0" 
$ns at 629.9288883485249 "$node_(114) setdest 2361 568 5.0" 
$ns at 701.3421506772723 "$node_(114) setdest 1367 118 2.0" 
$ns at 738.616820483978 "$node_(114) setdest 673 489 7.0" 
$ns at 769.7029939456261 "$node_(114) setdest 320 976 11.0" 
$ns at 882.8054588493294 "$node_(114) setdest 2382 888 1.0" 
$ns at 540.2075700751474 "$node_(115) setdest 420 277 14.0" 
$ns at 649.0099567352959 "$node_(115) setdest 1536 656 1.0" 
$ns at 681.5244617218711 "$node_(115) setdest 2538 571 9.0" 
$ns at 730.6664701825672 "$node_(115) setdest 2300 219 7.0" 
$ns at 800.6583060200295 "$node_(115) setdest 1132 851 14.0" 
$ns at 878.3097742114126 "$node_(115) setdest 2053 720 1.0" 
$ns at 525.634733052348 "$node_(116) setdest 2685 990 5.0" 
$ns at 570.0119590020405 "$node_(116) setdest 53 727 7.0" 
$ns at 616.5681484918026 "$node_(116) setdest 921 92 2.0" 
$ns at 662.2581549543946 "$node_(116) setdest 2873 333 6.0" 
$ns at 751.9412312025254 "$node_(116) setdest 2049 778 19.0" 
$ns at 500.3756533183213 "$node_(117) setdest 2089 630 20.0" 
$ns at 602.832047079523 "$node_(117) setdest 2928 391 1.0" 
$ns at 638.8256668396026 "$node_(117) setdest 912 479 10.0" 
$ns at 699.9077498065753 "$node_(117) setdest 2768 387 13.0" 
$ns at 733.6743419592797 "$node_(117) setdest 641 572 11.0" 
$ns at 834.967623313356 "$node_(117) setdest 410 352 16.0" 
$ns at 675.101528001956 "$node_(118) setdest 1632 228 2.0" 
$ns at 710.2735171656998 "$node_(118) setdest 708 330 1.0" 
$ns at 740.9175331760631 "$node_(118) setdest 2660 566 8.0" 
$ns at 830.8905510831561 "$node_(118) setdest 928 319 9.0" 
$ns at 593.636165155572 "$node_(119) setdest 976 103 7.0" 
$ns at 666.2859177051025 "$node_(119) setdest 2845 710 13.0" 
$ns at 721.7800302354223 "$node_(119) setdest 251 338 17.0" 
$ns at 835.4021724778315 "$node_(119) setdest 1000 533 1.0" 
$ns at 869.3460323026999 "$node_(119) setdest 1725 894 4.0" 
$ns at 513.4604623764824 "$node_(120) setdest 1246 291 7.0" 
$ns at 603.633768529868 "$node_(120) setdest 779 516 7.0" 
$ns at 639.2403546118255 "$node_(120) setdest 2789 521 8.0" 
$ns at 720.9022678750084 "$node_(120) setdest 2980 252 5.0" 
$ns at 800.189618645849 "$node_(120) setdest 184 676 11.0" 
$ns at 832.9769741081033 "$node_(120) setdest 124 357 2.0" 
$ns at 879.7635127802075 "$node_(120) setdest 2662 100 19.0" 
$ns at 516.4663564882203 "$node_(121) setdest 1656 958 14.0" 
$ns at 627.9511660706916 "$node_(121) setdest 682 600 9.0" 
$ns at 691.176426570829 "$node_(121) setdest 715 994 16.0" 
$ns at 794.5088798727437 "$node_(121) setdest 1976 888 1.0" 
$ns at 828.9487948647976 "$node_(121) setdest 1565 158 5.0" 
$ns at 880.0120901334014 "$node_(121) setdest 480 985 4.0" 
$ns at 546.4467449588985 "$node_(122) setdest 546 966 5.0" 
$ns at 591.6745642631807 "$node_(122) setdest 2429 889 1.0" 
$ns at 628.9768462905911 "$node_(122) setdest 2409 853 14.0" 
$ns at 733.6810827144674 "$node_(122) setdest 1282 482 6.0" 
$ns at 773.6240211772259 "$node_(122) setdest 1100 557 18.0" 
$ns at 533.5806713410302 "$node_(123) setdest 2333 603 3.0" 
$ns at 578.3637185342712 "$node_(123) setdest 1044 338 17.0" 
$ns at 608.451461061823 "$node_(123) setdest 1849 352 12.0" 
$ns at 711.364890069787 "$node_(123) setdest 1619 419 6.0" 
$ns at 757.5559645515875 "$node_(123) setdest 1286 730 17.0" 
$ns at 882.8559650267356 "$node_(123) setdest 266 21 10.0" 
$ns at 560.2969783863566 "$node_(124) setdest 952 779 14.0" 
$ns at 627.956454167994 "$node_(124) setdest 1859 51 18.0" 
$ns at 801.7888131267586 "$node_(124) setdest 93 561 12.0" 
$ns at 660.6711856704683 "$node_(125) setdest 958 583 2.0" 
$ns at 701.5165246116841 "$node_(125) setdest 877 494 14.0" 
$ns at 751.2781903327616 "$node_(125) setdest 1195 456 7.0" 
$ns at 840.6372582259174 "$node_(125) setdest 1649 329 20.0" 
$ns at 672.5305060546688 "$node_(126) setdest 747 810 4.0" 
$ns at 709.777870805619 "$node_(126) setdest 2735 456 2.0" 
$ns at 745.3945124864638 "$node_(126) setdest 2568 294 12.0" 
$ns at 870.3983578255542 "$node_(126) setdest 1838 718 6.0" 
$ns at 687.9351567313686 "$node_(127) setdest 596 378 3.0" 
$ns at 720.5174206523972 "$node_(127) setdest 667 573 1.0" 
$ns at 750.990371785926 "$node_(127) setdest 640 233 5.0" 
$ns at 801.0312315349098 "$node_(127) setdest 2789 16 17.0" 
$ns at 747.003490171652 "$node_(128) setdest 2679 579 11.0" 
$ns at 877.8971336416475 "$node_(128) setdest 432 708 7.0" 
$ns at 728.1081266862602 "$node_(129) setdest 2471 362 20.0" 
$ns at 666.9143347301818 "$node_(130) setdest 2422 954 6.0" 
$ns at 753.7216045409136 "$node_(130) setdest 1425 971 14.0" 
$ns at 728.1254380084603 "$node_(131) setdest 1379 127 8.0" 
$ns at 779.1001643613378 "$node_(131) setdest 921 720 1.0" 
$ns at 810.5360005039406 "$node_(131) setdest 345 452 10.0" 
$ns at 748.1824693606451 "$node_(132) setdest 979 981 15.0" 
$ns at 837.2277533357618 "$node_(132) setdest 2368 629 3.0" 
$ns at 869.7238335017316 "$node_(132) setdest 2059 295 17.0" 
$ns at 684.035575625228 "$node_(133) setdest 1788 373 7.0" 
$ns at 761.7652933312529 "$node_(133) setdest 2934 38 10.0" 
$ns at 820.5272565249766 "$node_(133) setdest 2867 836 15.0" 
$ns at 861.3674581208719 "$node_(133) setdest 2773 41 17.0" 
$ns at 667.6370486169557 "$node_(134) setdest 1868 122 13.0" 
$ns at 736.2756421270728 "$node_(134) setdest 1761 871 7.0" 
$ns at 771.4910803205819 "$node_(134) setdest 640 958 18.0" 
$ns at 821.5852280345723 "$node_(134) setdest 2929 852 3.0" 
$ns at 861.2196188025699 "$node_(134) setdest 2710 218 20.0" 
$ns at 718.2101982932218 "$node_(135) setdest 2713 579 13.0" 
$ns at 844.8770567862525 "$node_(135) setdest 680 959 4.0" 
$ns at 883.171859319364 "$node_(135) setdest 1679 513 12.0" 
$ns at 701.809964646392 "$node_(136) setdest 617 234 19.0" 
$ns at 805.2767460175478 "$node_(136) setdest 915 637 15.0" 
$ns at 878.6068832377389 "$node_(136) setdest 599 921 15.0" 
$ns at 685.4071609065682 "$node_(137) setdest 1741 597 6.0" 
$ns at 725.7746325271734 "$node_(137) setdest 1601 917 8.0" 
$ns at 799.1426831234661 "$node_(137) setdest 1856 503 13.0" 
$ns at 662.7166231575518 "$node_(138) setdest 2096 569 13.0" 
$ns at 699.3079963129271 "$node_(138) setdest 533 149 20.0" 
$ns at 863.4728994281969 "$node_(138) setdest 884 914 3.0" 
$ns at 895.3339857836854 "$node_(138) setdest 958 819 1.0" 
$ns at 744.203740750546 "$node_(139) setdest 2879 245 5.0" 
$ns at 799.7824344882658 "$node_(139) setdest 395 532 11.0" 
$ns at 834.2577282790252 "$node_(139) setdest 2495 353 12.0" 
$ns at 881.4147730709236 "$node_(139) setdest 1714 651 5.0" 
$ns at 668.8746570571087 "$node_(140) setdest 1213 290 17.0" 
$ns at 737.6012907760311 "$node_(140) setdest 449 513 4.0" 
$ns at 787.3242722411354 "$node_(140) setdest 1037 899 18.0" 
$ns at 875.081677296902 "$node_(140) setdest 880 576 7.0" 
$ns at 705.6403438597946 "$node_(141) setdest 1965 748 13.0" 
$ns at 801.1088395055006 "$node_(141) setdest 2144 822 10.0" 
$ns at 688.5534351989348 "$node_(142) setdest 982 637 4.0" 
$ns at 729.9360877130109 "$node_(142) setdest 1388 495 6.0" 
$ns at 764.5323096289125 "$node_(142) setdest 7 272 12.0" 
$ns at 826.7701067218188 "$node_(142) setdest 1083 121 16.0" 
$ns at 665.7755866214585 "$node_(143) setdest 2858 38 1.0" 
$ns at 704.8432707510077 "$node_(143) setdest 2894 880 5.0" 
$ns at 744.1012970468926 "$node_(143) setdest 277 662 1.0" 
$ns at 780.8055327504921 "$node_(143) setdest 2901 31 14.0" 
$ns at 879.7036108803968 "$node_(143) setdest 2866 486 8.0" 
$ns at 786.3123920624099 "$node_(144) setdest 1757 210 12.0" 
$ns at 824.4308367085686 "$node_(144) setdest 2056 587 10.0" 
$ns at 705.2713700719893 "$node_(145) setdest 1969 479 7.0" 
$ns at 778.8169113578047 "$node_(145) setdest 2111 824 4.0" 
$ns at 834.5239487886852 "$node_(145) setdest 1617 573 11.0" 
$ns at 893.5622376708295 "$node_(145) setdest 2098 145 17.0" 
$ns at 668.347686178837 "$node_(146) setdest 1496 101 18.0" 
$ns at 739.5573328201267 "$node_(146) setdest 1203 428 12.0" 
$ns at 878.9441605476419 "$node_(146) setdest 2698 800 13.0" 
$ns at 668.7706035302973 "$node_(147) setdest 2381 362 10.0" 
$ns at 772.7901074822308 "$node_(147) setdest 1512 159 12.0" 
$ns at 837.8402238056603 "$node_(147) setdest 2277 62 9.0" 
$ns at 838.3615970783409 "$node_(148) setdest 2913 934 10.0" 
$ns at 895.1889611573956 "$node_(148) setdest 287 792 3.0" 
$ns at 672.1519482478882 "$node_(149) setdest 1618 412 18.0" 
$ns at 831.8281539186721 "$node_(149) setdest 2596 258 19.0" 


#Set a TCP connection between node_(41) and node_(36)
set tcp_(0) [new Agent/TCP/Newreno]
$tcp_(0) set class_ 2
set sink_(0) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(0)
$ns attach-agent $node_(36) $sink_(0)
$ns connect $tcp_(0) $sink_(0)
set ftp_(0) [new Application/FTP]
$ftp_(0) attach-agent $tcp_(0)
$ns at 0.2 "$ftp_(0) start"
$ns at 180.0 "$ftp_(0) stop"

#Set a TCP connection between node_(2) and node_(18)
set tcp_(1) [new Agent/TCP/Newreno]
$tcp_(1) set class_ 2
set sink_(1) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(1)
$ns attach-agent $node_(18) $sink_(1)
$ns connect $tcp_(1) $sink_(1)
set ftp_(1) [new Application/FTP]
$ftp_(1) attach-agent $tcp_(1)
$ns at 180.2 "$ftp_(1) start"
$ns at 360.0 "$ftp_(1) stop"

#Set a TCP connection between node_(25) and node_(48)
set tcp_(2) [new Agent/TCP/Newreno]
$tcp_(2) set class_ 2
set sink_(2) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(2)
$ns attach-agent $node_(48) $sink_(2)
$ns connect $tcp_(2) $sink_(2)
set ftp_(2) [new Application/FTP]
$ftp_(2) attach-agent $tcp_(2)
$ns at 360.2 "$ftp_(2) start"
$ns at 540.0 "$ftp_(2) stop"

#Set a TCP connection between node_(28) and node_(39)
set tcp_(3) [new Agent/TCP/Newreno]
$tcp_(3) set class_ 2
set sink_(3) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(3)
$ns attach-agent $node_(39) $sink_(3)
$ns connect $tcp_(3) $sink_(3)
set ftp_(3) [new Application/FTP]
$ftp_(3) attach-agent $tcp_(3)
$ns at 540.2 "$ftp_(3) start"
$ns at 720.0 "$ftp_(3) stop"

#Set a TCP connection between node_(27) and node_(35)
set tcp_(4) [new Agent/TCP/Newreno]
$tcp_(4) set class_ 2
set sink_(4) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(4)
$ns attach-agent $node_(35) $sink_(4)
$ns connect $tcp_(4) $sink_(4)
set ftp_(4) [new Application/FTP]
$ftp_(4) attach-agent $tcp_(4)
$ns at 720.2 "$ftp_(4) start"
$ns at 900.0 "$ftp_(4) stop"

#Set a TCP connection between node_(26) and node_(46)
set tcp_(5) [new Agent/TCP/Newreno]
$tcp_(5) set class_ 2
set sink_(5) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(5)
$ns attach-agent $node_(46) $sink_(5)
$ns connect $tcp_(5) $sink_(5)
set ftp_(5) [new Application/FTP]
$ftp_(5) attach-agent $tcp_(5)
$ns at 0.2 "$ftp_(5) start"
$ns at 180.0 "$ftp_(5) stop"

#Set a TCP connection between node_(24) and node_(0)
set tcp_(6) [new Agent/TCP/Newreno]
$tcp_(6) set class_ 2
set sink_(6) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(6)
$ns attach-agent $node_(0) $sink_(6)
$ns connect $tcp_(6) $sink_(6)
set ftp_(6) [new Application/FTP]
$ftp_(6) attach-agent $tcp_(6)
$ns at 180.2 "$ftp_(6) start"
$ns at 360.0 "$ftp_(6) stop"

#Set a TCP connection between node_(47) and node_(36)
set tcp_(7) [new Agent/TCP/Newreno]
$tcp_(7) set class_ 2
set sink_(7) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(7)
$ns attach-agent $node_(36) $sink_(7)
$ns connect $tcp_(7) $sink_(7)
set ftp_(7) [new Application/FTP]
$ftp_(7) attach-agent $tcp_(7)
$ns at 360.2 "$ftp_(7) start"
$ns at 540.0 "$ftp_(7) stop"

#Set a TCP connection between node_(25) and node_(33)
set tcp_(8) [new Agent/TCP/Newreno]
$tcp_(8) set class_ 2
set sink_(8) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(8)
$ns attach-agent $node_(33) $sink_(8)
$ns connect $tcp_(8) $sink_(8)
set ftp_(8) [new Application/FTP]
$ftp_(8) attach-agent $tcp_(8)
$ns at 540.2 "$ftp_(8) start"
$ns at 720.0 "$ftp_(8) stop"

#Set a TCP connection between node_(24) and node_(48)
set tcp_(9) [new Agent/TCP/Newreno]
$tcp_(9) set class_ 2
set sink_(9) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(9)
$ns attach-agent $node_(48) $sink_(9)
$ns connect $tcp_(9) $sink_(9)
set ftp_(9) [new Application/FTP]
$ftp_(9) attach-agent $tcp_(9)
$ns at 720.2 "$ftp_(9) start"
$ns at 900.0 "$ftp_(9) stop"

#Set a TCP connection between node_(40) and node_(6)
set tcp_(10) [new Agent/TCP/Newreno]
$tcp_(10) set class_ 2
set sink_(10) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(10)
$ns attach-agent $node_(6) $sink_(10)
$ns connect $tcp_(10) $sink_(10)
set ftp_(10) [new Application/FTP]
$ftp_(10) attach-agent $tcp_(10)
$ns at 0.2 "$ftp_(10) start"
$ns at 180.0 "$ftp_(10) stop"

#Set a TCP connection between node_(18) and node_(31)
set tcp_(11) [new Agent/TCP/Newreno]
$tcp_(11) set class_ 2
set sink_(11) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(11)
$ns attach-agent $node_(31) $sink_(11)
$ns connect $tcp_(11) $sink_(11)
set ftp_(11) [new Application/FTP]
$ftp_(11) attach-agent $tcp_(11)
$ns at 180.2 "$ftp_(11) start"
$ns at 360.0 "$ftp_(11) stop"

#Set a TCP connection between node_(17) and node_(11)
set tcp_(12) [new Agent/TCP/Newreno]
$tcp_(12) set class_ 2
set sink_(12) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(12)
$ns attach-agent $node_(11) $sink_(12)
$ns connect $tcp_(12) $sink_(12)
set ftp_(12) [new Application/FTP]
$ftp_(12) attach-agent $tcp_(12)
$ns at 360.2 "$ftp_(12) start"
$ns at 540.0 "$ftp_(12) stop"

#Set a TCP connection between node_(48) and node_(30)
set tcp_(13) [new Agent/TCP/Newreno]
$tcp_(13) set class_ 2
set sink_(13) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(13)
$ns attach-agent $node_(30) $sink_(13)
$ns connect $tcp_(13) $sink_(13)
set ftp_(13) [new Application/FTP]
$ftp_(13) attach-agent $tcp_(13)
$ns at 540.2 "$ftp_(13) start"
$ns at 720.0 "$ftp_(13) stop"

#Set a TCP connection between node_(45) and node_(14)
set tcp_(14) [new Agent/TCP/Newreno]
$tcp_(14) set class_ 2
set sink_(14) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(14)
$ns attach-agent $node_(14) $sink_(14)
$ns connect $tcp_(14) $sink_(14)
set ftp_(14) [new Application/FTP]
$ftp_(14) attach-agent $tcp_(14)
$ns at 720.2 "$ftp_(14) start"
$ns at 900.0 "$ftp_(14) stop"

#Set a TCP connection between node_(41) and node_(35)
set tcp_(15) [new Agent/TCP/Newreno]
$tcp_(15) set class_ 2
set sink_(15) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(15)
$ns attach-agent $node_(35) $sink_(15)
$ns connect $tcp_(15) $sink_(15)
set ftp_(15) [new Application/FTP]
$ftp_(15) attach-agent $tcp_(15)
$ns at 0.2 "$ftp_(15) start"
$ns at 180.0 "$ftp_(15) stop"

#Set a TCP connection between node_(32) and node_(27)
set tcp_(16) [new Agent/TCP/Newreno]
$tcp_(16) set class_ 2
set sink_(16) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(16)
$ns attach-agent $node_(27) $sink_(16)
$ns connect $tcp_(16) $sink_(16)
set ftp_(16) [new Application/FTP]
$ftp_(16) attach-agent $tcp_(16)
$ns at 180.2 "$ftp_(16) start"
$ns at 360.0 "$ftp_(16) stop"

#Set a TCP connection between node_(49) and node_(10)
set tcp_(17) [new Agent/TCP/Newreno]
$tcp_(17) set class_ 2
set sink_(17) [new Agent/TCPSink]
$ns attach-agent $node_(49) $tcp_(17)
$ns attach-agent $node_(10) $sink_(17)
$ns connect $tcp_(17) $sink_(17)
set ftp_(17) [new Application/FTP]
$ftp_(17) attach-agent $tcp_(17)
$ns at 360.2 "$ftp_(17) start"
$ns at 540.0 "$ftp_(17) stop"

#Set a TCP connection between node_(41) and node_(43)
set tcp_(18) [new Agent/TCP/Newreno]
$tcp_(18) set class_ 2
set sink_(18) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(18)
$ns attach-agent $node_(43) $sink_(18)
$ns connect $tcp_(18) $sink_(18)
set ftp_(18) [new Application/FTP]
$ftp_(18) attach-agent $tcp_(18)
$ns at 540.2 "$ftp_(18) start"
$ns at 720.0 "$ftp_(18) stop"

#Set a TCP connection between node_(13) and node_(14)
set tcp_(19) [new Agent/TCP/Newreno]
$tcp_(19) set class_ 2
set sink_(19) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(19)
$ns attach-agent $node_(14) $sink_(19)
$ns connect $tcp_(19) $sink_(19)
set ftp_(19) [new Application/FTP]
$ftp_(19) attach-agent $tcp_(19)
$ns at 720.2 "$ftp_(19) start"
$ns at 900.0 "$ftp_(19) stop"

#Set a TCP connection between node_(29) and node_(20)
set tcp_(20) [new Agent/TCP/Newreno]
$tcp_(20) set class_ 2
set sink_(20) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(20)
$ns attach-agent $node_(20) $sink_(20)
$ns connect $tcp_(20) $sink_(20)
set ftp_(20) [new Application/FTP]
$ftp_(20) attach-agent $tcp_(20)
$ns at 0.2 "$ftp_(20) start"
$ns at 180.0 "$ftp_(20) stop"

#Set a TCP connection between node_(28) and node_(23)
set tcp_(21) [new Agent/TCP/Newreno]
$tcp_(21) set class_ 2
set sink_(21) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(21)
$ns attach-agent $node_(23) $sink_(21)
$ns connect $tcp_(21) $sink_(21)
set ftp_(21) [new Application/FTP]
$ftp_(21) attach-agent $tcp_(21)
$ns at 180.2 "$ftp_(21) start"
$ns at 360.0 "$ftp_(21) stop"

#Set a TCP connection between node_(6) and node_(20)
set tcp_(22) [new Agent/TCP/Newreno]
$tcp_(22) set class_ 2
set sink_(22) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(22)
$ns attach-agent $node_(20) $sink_(22)
$ns connect $tcp_(22) $sink_(22)
set ftp_(22) [new Application/FTP]
$ftp_(22) attach-agent $tcp_(22)
$ns at 360.2 "$ftp_(22) start"
$ns at 540.0 "$ftp_(22) stop"

#Set a TCP connection between node_(11) and node_(8)
set tcp_(23) [new Agent/TCP/Newreno]
$tcp_(23) set class_ 2
set sink_(23) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(23)
$ns attach-agent $node_(8) $sink_(23)
$ns connect $tcp_(23) $sink_(23)
set ftp_(23) [new Application/FTP]
$ftp_(23) attach-agent $tcp_(23)
$ns at 540.2 "$ftp_(23) start"
$ns at 720.0 "$ftp_(23) stop"

#Set a TCP connection between node_(7) and node_(42)
set tcp_(24) [new Agent/TCP/Newreno]
$tcp_(24) set class_ 2
set sink_(24) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(24)
$ns attach-agent $node_(42) $sink_(24)
$ns connect $tcp_(24) $sink_(24)
set ftp_(24) [new Application/FTP]
$ftp_(24) attach-agent $tcp_(24)
$ns at 720.2 "$ftp_(24) start"
$ns at 900.0 "$ftp_(24) stop"

#Set a TCP connection between node_(41) and node_(19)
set tcp_(25) [new Agent/TCP/Newreno]
$tcp_(25) set class_ 2
set sink_(25) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(25)
$ns attach-agent $node_(19) $sink_(25)
$ns connect $tcp_(25) $sink_(25)
set ftp_(25) [new Application/FTP]
$ftp_(25) attach-agent $tcp_(25)
$ns at 0.2 "$ftp_(25) start"
$ns at 180.0 "$ftp_(25) stop"

#Set a TCP connection between node_(18) and node_(11)
set tcp_(26) [new Agent/TCP/Newreno]
$tcp_(26) set class_ 2
set sink_(26) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(26)
$ns attach-agent $node_(11) $sink_(26)
$ns connect $tcp_(26) $sink_(26)
set ftp_(26) [new Application/FTP]
$ftp_(26) attach-agent $tcp_(26)
$ns at 180.2 "$ftp_(26) start"
$ns at 360.0 "$ftp_(26) stop"

#Set a TCP connection between node_(7) and node_(1)
set tcp_(27) [new Agent/TCP/Newreno]
$tcp_(27) set class_ 2
set sink_(27) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(27)
$ns attach-agent $node_(1) $sink_(27)
$ns connect $tcp_(27) $sink_(27)
set ftp_(27) [new Application/FTP]
$ftp_(27) attach-agent $tcp_(27)
$ns at 360.2 "$ftp_(27) start"
$ns at 540.0 "$ftp_(27) stop"

#Set a TCP connection between node_(41) and node_(15)
set tcp_(28) [new Agent/TCP/Newreno]
$tcp_(28) set class_ 2
set sink_(28) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(28)
$ns attach-agent $node_(15) $sink_(28)
$ns connect $tcp_(28) $sink_(28)
set ftp_(28) [new Application/FTP]
$ftp_(28) attach-agent $tcp_(28)
$ns at 540.2 "$ftp_(28) start"
$ns at 720.0 "$ftp_(28) stop"

#Set a TCP connection between node_(33) and node_(37)
set tcp_(29) [new Agent/TCP/Newreno]
$tcp_(29) set class_ 2
set sink_(29) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(29)
$ns attach-agent $node_(37) $sink_(29)
$ns connect $tcp_(29) $sink_(29)
set ftp_(29) [new Application/FTP]
$ftp_(29) attach-agent $tcp_(29)
$ns at 720.2 "$ftp_(29) start"
$ns at 900.0 "$ftp_(29) stop"

#Set a TCP connection between node_(22) and node_(21)
set tcp_(30) [new Agent/TCP/Newreno]
$tcp_(30) set class_ 2
set sink_(30) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(30)
$ns attach-agent $node_(21) $sink_(30)
$ns connect $tcp_(30) $sink_(30)
set ftp_(30) [new Application/FTP]
$ftp_(30) attach-agent $tcp_(30)
$ns at 0.2 "$ftp_(30) start"
$ns at 180.0 "$ftp_(30) stop"

#Set a TCP connection between node_(44) and node_(40)
set tcp_(31) [new Agent/TCP/Newreno]
$tcp_(31) set class_ 2
set sink_(31) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(31)
$ns attach-agent $node_(40) $sink_(31)
$ns connect $tcp_(31) $sink_(31)
set ftp_(31) [new Application/FTP]
$ftp_(31) attach-agent $tcp_(31)
$ns at 180.2 "$ftp_(31) start"
$ns at 360.0 "$ftp_(31) stop"

#Set a TCP connection between node_(10) and node_(7)
set tcp_(32) [new Agent/TCP/Newreno]
$tcp_(32) set class_ 2
set sink_(32) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(32)
$ns attach-agent $node_(7) $sink_(32)
$ns connect $tcp_(32) $sink_(32)
set ftp_(32) [new Application/FTP]
$ftp_(32) attach-agent $tcp_(32)
$ns at 360.2 "$ftp_(32) start"
$ns at 540.0 "$ftp_(32) stop"

#Set a TCP connection between node_(16) and node_(46)
set tcp_(33) [new Agent/TCP/Newreno]
$tcp_(33) set class_ 2
set sink_(33) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(33)
$ns attach-agent $node_(46) $sink_(33)
$ns connect $tcp_(33) $sink_(33)
set ftp_(33) [new Application/FTP]
$ftp_(33) attach-agent $tcp_(33)
$ns at 540.2 "$ftp_(33) start"
$ns at 720.0 "$ftp_(33) stop"

#Set a TCP connection between node_(44) and node_(41)
set tcp_(34) [new Agent/TCP/Newreno]
$tcp_(34) set class_ 2
set sink_(34) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(34)
$ns attach-agent $node_(41) $sink_(34)
$ns connect $tcp_(34) $sink_(34)
set ftp_(34) [new Application/FTP]
$ftp_(34) attach-agent $tcp_(34)
$ns at 720.2 "$ftp_(34) start"
$ns at 900.0 "$ftp_(34) stop"

#Set a TCP connection between node_(44) and node_(27)
set tcp_(35) [new Agent/TCP/Newreno]
$tcp_(35) set class_ 2
set sink_(35) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(35)
$ns attach-agent $node_(27) $sink_(35)
$ns connect $tcp_(35) $sink_(35)
set ftp_(35) [new Application/FTP]
$ftp_(35) attach-agent $tcp_(35)
$ns at 0.2 "$ftp_(35) start"
$ns at 180.0 "$ftp_(35) stop"

#Set a TCP connection between node_(39) and node_(6)
set tcp_(36) [new Agent/TCP/Newreno]
$tcp_(36) set class_ 2
set sink_(36) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(36)
$ns attach-agent $node_(6) $sink_(36)
$ns connect $tcp_(36) $sink_(36)
set ftp_(36) [new Application/FTP]
$ftp_(36) attach-agent $tcp_(36)
$ns at 180.2 "$ftp_(36) start"
$ns at 360.0 "$ftp_(36) stop"

#Set a TCP connection between node_(12) and node_(18)
set tcp_(37) [new Agent/TCP/Newreno]
$tcp_(37) set class_ 2
set sink_(37) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(37)
$ns attach-agent $node_(18) $sink_(37)
$ns connect $tcp_(37) $sink_(37)
set ftp_(37) [new Application/FTP]
$ftp_(37) attach-agent $tcp_(37)
$ns at 360.2 "$ftp_(37) start"
$ns at 540.0 "$ftp_(37) stop"

#Set a TCP connection between node_(17) and node_(39)
set tcp_(38) [new Agent/TCP/Newreno]
$tcp_(38) set class_ 2
set sink_(38) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(38)
$ns attach-agent $node_(39) $sink_(38)
$ns connect $tcp_(38) $sink_(38)
set ftp_(38) [new Application/FTP]
$ftp_(38) attach-agent $tcp_(38)
$ns at 540.2 "$ftp_(38) start"
$ns at 720.0 "$ftp_(38) stop"

#Set a TCP connection between node_(28) and node_(29)
set tcp_(39) [new Agent/TCP/Newreno]
$tcp_(39) set class_ 2
set sink_(39) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(39)
$ns attach-agent $node_(29) $sink_(39)
$ns connect $tcp_(39) $sink_(39)
set ftp_(39) [new Application/FTP]
$ftp_(39) attach-agent $tcp_(39)
$ns at 720.2 "$ftp_(39) start"
$ns at 900.0 "$ftp_(39) stop"

#Set a TCP connection between node_(5) and node_(8)
set tcp_(40) [new Agent/TCP/Newreno]
$tcp_(40) set class_ 2
set sink_(40) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(40)
$ns attach-agent $node_(8) $sink_(40)
$ns connect $tcp_(40) $sink_(40)
set ftp_(40) [new Application/FTP]
$ftp_(40) attach-agent $tcp_(40)
$ns at 0.2 "$ftp_(40) start"
$ns at 180.0 "$ftp_(40) stop"

#Set a TCP connection between node_(28) and node_(38)
set tcp_(41) [new Agent/TCP/Newreno]
$tcp_(41) set class_ 2
set sink_(41) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(41)
$ns attach-agent $node_(38) $sink_(41)
$ns connect $tcp_(41) $sink_(41)
set ftp_(41) [new Application/FTP]
$ftp_(41) attach-agent $tcp_(41)
$ns at 180.2 "$ftp_(41) start"
$ns at 360.0 "$ftp_(41) stop"

#Set a TCP connection between node_(23) and node_(18)
set tcp_(42) [new Agent/TCP/Newreno]
$tcp_(42) set class_ 2
set sink_(42) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(42)
$ns attach-agent $node_(18) $sink_(42)
$ns connect $tcp_(42) $sink_(42)
set ftp_(42) [new Application/FTP]
$ftp_(42) attach-agent $tcp_(42)
$ns at 360.2 "$ftp_(42) start"
$ns at 540.0 "$ftp_(42) stop"

#Set a TCP connection between node_(9) and node_(13)
set tcp_(43) [new Agent/TCP/Newreno]
$tcp_(43) set class_ 2
set sink_(43) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(43)
$ns attach-agent $node_(13) $sink_(43)
$ns connect $tcp_(43) $sink_(43)
set ftp_(43) [new Application/FTP]
$ftp_(43) attach-agent $tcp_(43)
$ns at 540.2 "$ftp_(43) start"
$ns at 720.0 "$ftp_(43) stop"

#Set a TCP connection between node_(0) and node_(20)
set tcp_(44) [new Agent/TCP/Newreno]
$tcp_(44) set class_ 2
set sink_(44) [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp_(44)
$ns attach-agent $node_(20) $sink_(44)
$ns connect $tcp_(44) $sink_(44)
set ftp_(44) [new Application/FTP]
$ftp_(44) attach-agent $tcp_(44)
$ns at 720.2 "$ftp_(44) start"
$ns at 900.0 "$ftp_(44) stop"

#Set a TCP connection between node_(26) and node_(9)
set tcp_(45) [new Agent/TCP/Newreno]
$tcp_(45) set class_ 2
set sink_(45) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(45)
$ns attach-agent $node_(9) $sink_(45)
$ns connect $tcp_(45) $sink_(45)
set ftp_(45) [new Application/FTP]
$ftp_(45) attach-agent $tcp_(45)
$ns at 0.2 "$ftp_(45) start"
$ns at 180.0 "$ftp_(45) stop"

#Set a TCP connection between node_(10) and node_(43)
set tcp_(46) [new Agent/TCP/Newreno]
$tcp_(46) set class_ 2
set sink_(46) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(46)
$ns attach-agent $node_(43) $sink_(46)
$ns connect $tcp_(46) $sink_(46)
set ftp_(46) [new Application/FTP]
$ftp_(46) attach-agent $tcp_(46)
$ns at 180.2 "$ftp_(46) start"
$ns at 360.0 "$ftp_(46) stop"

#Set a TCP connection between node_(6) and node_(1)
set tcp_(47) [new Agent/TCP/Newreno]
$tcp_(47) set class_ 2
set sink_(47) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(47)
$ns attach-agent $node_(1) $sink_(47)
$ns connect $tcp_(47) $sink_(47)
set ftp_(47) [new Application/FTP]
$ftp_(47) attach-agent $tcp_(47)
$ns at 360.2 "$ftp_(47) start"
$ns at 540.0 "$ftp_(47) stop"

#Set a TCP connection between node_(22) and node_(29)
set tcp_(48) [new Agent/TCP/Newreno]
$tcp_(48) set class_ 2
set sink_(48) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(48)
$ns attach-agent $node_(29) $sink_(48)
$ns connect $tcp_(48) $sink_(48)
set ftp_(48) [new Application/FTP]
$ftp_(48) attach-agent $tcp_(48)
$ns at 540.2 "$ftp_(48) start"
$ns at 720.0 "$ftp_(48) stop"

#Set a TCP connection between node_(18) and node_(11)
set tcp_(49) [new Agent/TCP/Newreno]
$tcp_(49) set class_ 2
set sink_(49) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(49)
$ns attach-agent $node_(11) $sink_(49)
$ns connect $tcp_(49) $sink_(49)
set ftp_(49) [new Application/FTP]
$ftp_(49) attach-agent $tcp_(49)
$ns at 720.2 "$ftp_(49) start"
$ns at 900.0 "$ftp_(49) stop"

#Set a TCP connection between node_(1) and node_(2)
set tcp_(50) [new Agent/TCP/Newreno]
$tcp_(50) set class_ 2
set sink_(50) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(50)
$ns attach-agent $node_(2) $sink_(50)
$ns connect $tcp_(50) $sink_(50)
set ftp_(50) [new Application/FTP]
$ftp_(50) attach-agent $tcp_(50)
$ns at 0.2 "$ftp_(50) start"
$ns at 180.0 "$ftp_(50) stop"

#Set a TCP connection between node_(31) and node_(38)
set tcp_(51) [new Agent/TCP/Newreno]
$tcp_(51) set class_ 2
set sink_(51) [new Agent/TCPSink]
$ns attach-agent $node_(31) $tcp_(51)
$ns attach-agent $node_(38) $sink_(51)
$ns connect $tcp_(51) $sink_(51)
set ftp_(51) [new Application/FTP]
$ftp_(51) attach-agent $tcp_(51)
$ns at 180.2 "$ftp_(51) start"
$ns at 360.0 "$ftp_(51) stop"

#Set a TCP connection between node_(22) and node_(2)
set tcp_(52) [new Agent/TCP/Newreno]
$tcp_(52) set class_ 2
set sink_(52) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(52)
$ns attach-agent $node_(2) $sink_(52)
$ns connect $tcp_(52) $sink_(52)
set ftp_(52) [new Application/FTP]
$ftp_(52) attach-agent $tcp_(52)
$ns at 360.2 "$ftp_(52) start"
$ns at 540.0 "$ftp_(52) stop"

#Set a TCP connection between node_(32) and node_(7)
set tcp_(53) [new Agent/TCP/Newreno]
$tcp_(53) set class_ 2
set sink_(53) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(53)
$ns attach-agent $node_(7) $sink_(53)
$ns connect $tcp_(53) $sink_(53)
set ftp_(53) [new Application/FTP]
$ftp_(53) attach-agent $tcp_(53)
$ns at 540.2 "$ftp_(53) start"
$ns at 720.0 "$ftp_(53) stop"

#Set a TCP connection between node_(32) and node_(7)
set tcp_(54) [new Agent/TCP/Newreno]
$tcp_(54) set class_ 2
set sink_(54) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(54)
$ns attach-agent $node_(7) $sink_(54)
$ns connect $tcp_(54) $sink_(54)
set ftp_(54) [new Application/FTP]
$ftp_(54) attach-agent $tcp_(54)
$ns at 720.2 "$ftp_(54) start"
$ns at 900.0 "$ftp_(54) stop"

#Set a TCP connection between node_(29) and node_(9)
set tcp_(55) [new Agent/TCP/Newreno]
$tcp_(55) set class_ 2
set sink_(55) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(55)
$ns attach-agent $node_(9) $sink_(55)
$ns connect $tcp_(55) $sink_(55)
set ftp_(55) [new Application/FTP]
$ftp_(55) attach-agent $tcp_(55)
$ns at 0.2 "$ftp_(55) start"
$ns at 180.0 "$ftp_(55) stop"

#Set a TCP connection between node_(35) and node_(48)
set tcp_(56) [new Agent/TCP/Newreno]
$tcp_(56) set class_ 2
set sink_(56) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(56)
$ns attach-agent $node_(48) $sink_(56)
$ns connect $tcp_(56) $sink_(56)
set ftp_(56) [new Application/FTP]
$ftp_(56) attach-agent $tcp_(56)
$ns at 180.2 "$ftp_(56) start"
$ns at 360.0 "$ftp_(56) stop"

#Set a TCP connection between node_(15) and node_(43)
set tcp_(57) [new Agent/TCP/Newreno]
$tcp_(57) set class_ 2
set sink_(57) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(57)
$ns attach-agent $node_(43) $sink_(57)
$ns connect $tcp_(57) $sink_(57)
set ftp_(57) [new Application/FTP]
$ftp_(57) attach-agent $tcp_(57)
$ns at 360.2 "$ftp_(57) start"
$ns at 540.0 "$ftp_(57) stop"

#Set a TCP connection between node_(18) and node_(49)
set tcp_(58) [new Agent/TCP/Newreno]
$tcp_(58) set class_ 2
set sink_(58) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(58)
$ns attach-agent $node_(49) $sink_(58)
$ns connect $tcp_(58) $sink_(58)
set ftp_(58) [new Application/FTP]
$ftp_(58) attach-agent $tcp_(58)
$ns at 540.2 "$ftp_(58) start"
$ns at 720.0 "$ftp_(58) stop"

#Set a TCP connection between node_(13) and node_(39)
set tcp_(59) [new Agent/TCP/Newreno]
$tcp_(59) set class_ 2
set sink_(59) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(59)
$ns attach-agent $node_(39) $sink_(59)
$ns connect $tcp_(59) $sink_(59)
set ftp_(59) [new Application/FTP]
$ftp_(59) attach-agent $tcp_(59)
$ns at 720.2 "$ftp_(59) start"
$ns at 900.0 "$ftp_(59) stop"

#Set a TCP connection between node_(22) and node_(36)
set tcp_(60) [new Agent/TCP/Newreno]
$tcp_(60) set class_ 2
set sink_(60) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(60)
$ns attach-agent $node_(36) $sink_(60)
$ns connect $tcp_(60) $sink_(60)
set ftp_(60) [new Application/FTP]
$ftp_(60) attach-agent $tcp_(60)
$ns at 0.2 "$ftp_(60) start"
$ns at 180.0 "$ftp_(60) stop"

#Set a TCP connection between node_(5) and node_(28)
set tcp_(61) [new Agent/TCP/Newreno]
$tcp_(61) set class_ 2
set sink_(61) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(61)
$ns attach-agent $node_(28) $sink_(61)
$ns connect $tcp_(61) $sink_(61)
set ftp_(61) [new Application/FTP]
$ftp_(61) attach-agent $tcp_(61)
$ns at 180.2 "$ftp_(61) start"
$ns at 360.0 "$ftp_(61) stop"

#Set a TCP connection between node_(43) and node_(22)
set tcp_(62) [new Agent/TCP/Newreno]
$tcp_(62) set class_ 2
set sink_(62) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(62)
$ns attach-agent $node_(22) $sink_(62)
$ns connect $tcp_(62) $sink_(62)
set ftp_(62) [new Application/FTP]
$ftp_(62) attach-agent $tcp_(62)
$ns at 360.2 "$ftp_(62) start"
$ns at 540.0 "$ftp_(62) stop"

#Set a TCP connection between node_(26) and node_(24)
set tcp_(63) [new Agent/TCP/Newreno]
$tcp_(63) set class_ 2
set sink_(63) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(63)
$ns attach-agent $node_(24) $sink_(63)
$ns connect $tcp_(63) $sink_(63)
set ftp_(63) [new Application/FTP]
$ftp_(63) attach-agent $tcp_(63)
$ns at 540.2 "$ftp_(63) start"
$ns at 720.0 "$ftp_(63) stop"

#Set a TCP connection between node_(10) and node_(17)
set tcp_(64) [new Agent/TCP/Newreno]
$tcp_(64) set class_ 2
set sink_(64) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(64)
$ns attach-agent $node_(17) $sink_(64)
$ns connect $tcp_(64) $sink_(64)
set ftp_(64) [new Application/FTP]
$ftp_(64) attach-agent $tcp_(64)
$ns at 720.2 "$ftp_(64) start"
$ns at 900.0 "$ftp_(64) stop"

#Set a TCP connection between node_(6) and node_(48)
set tcp_(65) [new Agent/TCP/Newreno]
$tcp_(65) set class_ 2
set sink_(65) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(65)
$ns attach-agent $node_(48) $sink_(65)
$ns connect $tcp_(65) $sink_(65)
set ftp_(65) [new Application/FTP]
$ftp_(65) attach-agent $tcp_(65)
$ns at 0.2 "$ftp_(65) start"
$ns at 180.0 "$ftp_(65) stop"

#Set a TCP connection between node_(22) and node_(48)
set tcp_(66) [new Agent/TCP/Newreno]
$tcp_(66) set class_ 2
set sink_(66) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(66)
$ns attach-agent $node_(48) $sink_(66)
$ns connect $tcp_(66) $sink_(66)
set ftp_(66) [new Application/FTP]
$ftp_(66) attach-agent $tcp_(66)
$ns at 180.2 "$ftp_(66) start"
$ns at 360.0 "$ftp_(66) stop"

#Set a TCP connection between node_(24) and node_(20)
set tcp_(67) [new Agent/TCP/Newreno]
$tcp_(67) set class_ 2
set sink_(67) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(67)
$ns attach-agent $node_(20) $sink_(67)
$ns connect $tcp_(67) $sink_(67)
set ftp_(67) [new Application/FTP]
$ftp_(67) attach-agent $tcp_(67)
$ns at 360.2 "$ftp_(67) start"
$ns at 540.0 "$ftp_(67) stop"

#Set a TCP connection between node_(28) and node_(18)
set tcp_(68) [new Agent/TCP/Newreno]
$tcp_(68) set class_ 2
set sink_(68) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(68)
$ns attach-agent $node_(18) $sink_(68)
$ns connect $tcp_(68) $sink_(68)
set ftp_(68) [new Application/FTP]
$ftp_(68) attach-agent $tcp_(68)
$ns at 540.2 "$ftp_(68) start"
$ns at 720.0 "$ftp_(68) stop"

#Set a TCP connection between node_(11) and node_(10)
set tcp_(69) [new Agent/TCP/Newreno]
$tcp_(69) set class_ 2
set sink_(69) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(69)
$ns attach-agent $node_(10) $sink_(69)
$ns connect $tcp_(69) $sink_(69)
set ftp_(69) [new Application/FTP]
$ftp_(69) attach-agent $tcp_(69)
$ns at 720.2 "$ftp_(69) start"
$ns at 900.0 "$ftp_(69) stop"

#Set a TCP connection between node_(24) and node_(31)
set tcp_(70) [new Agent/TCP/Newreno]
$tcp_(70) set class_ 2
set sink_(70) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(70)
$ns attach-agent $node_(31) $sink_(70)
$ns connect $tcp_(70) $sink_(70)
set ftp_(70) [new Application/FTP]
$ftp_(70) attach-agent $tcp_(70)
$ns at 0.2 "$ftp_(70) start"
$ns at 180.0 "$ftp_(70) stop"

#Set a TCP connection between node_(9) and node_(38)
set tcp_(71) [new Agent/TCP/Newreno]
$tcp_(71) set class_ 2
set sink_(71) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(71)
$ns attach-agent $node_(38) $sink_(71)
$ns connect $tcp_(71) $sink_(71)
set ftp_(71) [new Application/FTP]
$ftp_(71) attach-agent $tcp_(71)
$ns at 180.2 "$ftp_(71) start"
$ns at 360.0 "$ftp_(71) stop"

#Set a TCP connection between node_(21) and node_(1)
set tcp_(72) [new Agent/TCP/Newreno]
$tcp_(72) set class_ 2
set sink_(72) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(72)
$ns attach-agent $node_(1) $sink_(72)
$ns connect $tcp_(72) $sink_(72)
set ftp_(72) [new Application/FTP]
$ftp_(72) attach-agent $tcp_(72)
$ns at 360.2 "$ftp_(72) start"
$ns at 540.0 "$ftp_(72) stop"

#Set a TCP connection between node_(12) and node_(40)
set tcp_(73) [new Agent/TCP/Newreno]
$tcp_(73) set class_ 2
set sink_(73) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(73)
$ns attach-agent $node_(40) $sink_(73)
$ns connect $tcp_(73) $sink_(73)
set ftp_(73) [new Application/FTP]
$ftp_(73) attach-agent $tcp_(73)
$ns at 540.2 "$ftp_(73) start"
$ns at 720.0 "$ftp_(73) stop"

#Set a TCP connection between node_(17) and node_(40)
set tcp_(74) [new Agent/TCP/Newreno]
$tcp_(74) set class_ 2
set sink_(74) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(74)
$ns attach-agent $node_(40) $sink_(74)
$ns connect $tcp_(74) $sink_(74)
set ftp_(74) [new Application/FTP]
$ftp_(74) attach-agent $tcp_(74)
$ns at 720.2 "$ftp_(74) start"
$ns at 900.0 "$ftp_(74) stop"

#Set a TCP connection between node_(1) and node_(35)
set tcp_(75) [new Agent/TCP/Newreno]
$tcp_(75) set class_ 2
set sink_(75) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(75)
$ns attach-agent $node_(35) $sink_(75)
$ns connect $tcp_(75) $sink_(75)
set ftp_(75) [new Application/FTP]
$ftp_(75) attach-agent $tcp_(75)
$ns at 0.2 "$ftp_(75) start"
$ns at 180.0 "$ftp_(75) stop"

#Set a TCP connection between node_(42) and node_(44)
set tcp_(76) [new Agent/TCP/Newreno]
$tcp_(76) set class_ 2
set sink_(76) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(76)
$ns attach-agent $node_(44) $sink_(76)
$ns connect $tcp_(76) $sink_(76)
set ftp_(76) [new Application/FTP]
$ftp_(76) attach-agent $tcp_(76)
$ns at 180.2 "$ftp_(76) start"
$ns at 360.0 "$ftp_(76) stop"

#Set a TCP connection between node_(34) and node_(24)
set tcp_(77) [new Agent/TCP/Newreno]
$tcp_(77) set class_ 2
set sink_(77) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(77)
$ns attach-agent $node_(24) $sink_(77)
$ns connect $tcp_(77) $sink_(77)
set ftp_(77) [new Application/FTP]
$ftp_(77) attach-agent $tcp_(77)
$ns at 360.2 "$ftp_(77) start"
$ns at 540.0 "$ftp_(77) stop"

#Set a TCP connection between node_(18) and node_(24)
set tcp_(78) [new Agent/TCP/Newreno]
$tcp_(78) set class_ 2
set sink_(78) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(78)
$ns attach-agent $node_(24) $sink_(78)
$ns connect $tcp_(78) $sink_(78)
set ftp_(78) [new Application/FTP]
$ftp_(78) attach-agent $tcp_(78)
$ns at 540.2 "$ftp_(78) start"
$ns at 720.0 "$ftp_(78) stop"

#Set a TCP connection between node_(48) and node_(16)
set tcp_(79) [new Agent/TCP/Newreno]
$tcp_(79) set class_ 2
set sink_(79) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(79)
$ns attach-agent $node_(16) $sink_(79)
$ns connect $tcp_(79) $sink_(79)
set ftp_(79) [new Application/FTP]
$ftp_(79) attach-agent $tcp_(79)
$ns at 720.2 "$ftp_(79) start"
$ns at 900.0 "$ftp_(79) stop"

#Set a TCP connection between node_(46) and node_(1)
set tcp_(80) [new Agent/TCP/Newreno]
$tcp_(80) set class_ 2
set sink_(80) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(80)
$ns attach-agent $node_(1) $sink_(80)
$ns connect $tcp_(80) $sink_(80)
set ftp_(80) [new Application/FTP]
$ftp_(80) attach-agent $tcp_(80)
$ns at 0.2 "$ftp_(80) start"
$ns at 180.0 "$ftp_(80) stop"

#Set a TCP connection between node_(20) and node_(24)
set tcp_(81) [new Agent/TCP/Newreno]
$tcp_(81) set class_ 2
set sink_(81) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(81)
$ns attach-agent $node_(24) $sink_(81)
$ns connect $tcp_(81) $sink_(81)
set ftp_(81) [new Application/FTP]
$ftp_(81) attach-agent $tcp_(81)
$ns at 180.2 "$ftp_(81) start"
$ns at 360.0 "$ftp_(81) stop"

#Set a TCP connection between node_(36) and node_(8)
set tcp_(82) [new Agent/TCP/Newreno]
$tcp_(82) set class_ 2
set sink_(82) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(82)
$ns attach-agent $node_(8) $sink_(82)
$ns connect $tcp_(82) $sink_(82)
set ftp_(82) [new Application/FTP]
$ftp_(82) attach-agent $tcp_(82)
$ns at 360.2 "$ftp_(82) start"
$ns at 540.0 "$ftp_(82) stop"

#Set a TCP connection between node_(31) and node_(35)
set tcp_(83) [new Agent/TCP/Newreno]
$tcp_(83) set class_ 2
set sink_(83) [new Agent/TCPSink]
$ns attach-agent $node_(31) $tcp_(83)
$ns attach-agent $node_(35) $sink_(83)
$ns connect $tcp_(83) $sink_(83)
set ftp_(83) [new Application/FTP]
$ftp_(83) attach-agent $tcp_(83)
$ns at 540.2 "$ftp_(83) start"
$ns at 720.0 "$ftp_(83) stop"

#Set a TCP connection between node_(0) and node_(46)
set tcp_(84) [new Agent/TCP/Newreno]
$tcp_(84) set class_ 2
set sink_(84) [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp_(84)
$ns attach-agent $node_(46) $sink_(84)
$ns connect $tcp_(84) $sink_(84)
set ftp_(84) [new Application/FTP]
$ftp_(84) attach-agent $tcp_(84)
$ns at 720.2 "$ftp_(84) start"
$ns at 900.0 "$ftp_(84) stop"

#Set a TCP connection between node_(45) and node_(33)
set tcp_(85) [new Agent/TCP/Newreno]
$tcp_(85) set class_ 2
set sink_(85) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(85)
$ns attach-agent $node_(33) $sink_(85)
$ns connect $tcp_(85) $sink_(85)
set ftp_(85) [new Application/FTP]
$ftp_(85) attach-agent $tcp_(85)
$ns at 0.2 "$ftp_(85) start"
$ns at 180.0 "$ftp_(85) stop"

#Set a TCP connection between node_(1) and node_(2)
set tcp_(86) [new Agent/TCP/Newreno]
$tcp_(86) set class_ 2
set sink_(86) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(86)
$ns attach-agent $node_(2) $sink_(86)
$ns connect $tcp_(86) $sink_(86)
set ftp_(86) [new Application/FTP]
$ftp_(86) attach-agent $tcp_(86)
$ns at 180.2 "$ftp_(86) start"
$ns at 360.0 "$ftp_(86) stop"

#Set a TCP connection between node_(45) and node_(11)
set tcp_(87) [new Agent/TCP/Newreno]
$tcp_(87) set class_ 2
set sink_(87) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(87)
$ns attach-agent $node_(11) $sink_(87)
$ns connect $tcp_(87) $sink_(87)
set ftp_(87) [new Application/FTP]
$ftp_(87) attach-agent $tcp_(87)
$ns at 360.2 "$ftp_(87) start"
$ns at 540.0 "$ftp_(87) stop"

#Set a TCP connection between node_(16) and node_(39)
set tcp_(88) [new Agent/TCP/Newreno]
$tcp_(88) set class_ 2
set sink_(88) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(88)
$ns attach-agent $node_(39) $sink_(88)
$ns connect $tcp_(88) $sink_(88)
set ftp_(88) [new Application/FTP]
$ftp_(88) attach-agent $tcp_(88)
$ns at 540.2 "$ftp_(88) start"
$ns at 720.0 "$ftp_(88) stop"

#Set a TCP connection between node_(40) and node_(42)
set tcp_(89) [new Agent/TCP/Newreno]
$tcp_(89) set class_ 2
set sink_(89) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(89)
$ns attach-agent $node_(42) $sink_(89)
$ns connect $tcp_(89) $sink_(89)
set ftp_(89) [new Application/FTP]
$ftp_(89) attach-agent $tcp_(89)
$ns at 720.2 "$ftp_(89) start"
$ns at 900.0 "$ftp_(89) stop"

#Set a TCP connection between node_(39) and node_(5)
set tcp_(90) [new Agent/TCP/Newreno]
$tcp_(90) set class_ 2
set sink_(90) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(90)
$ns attach-agent $node_(5) $sink_(90)
$ns connect $tcp_(90) $sink_(90)
set ftp_(90) [new Application/FTP]
$ftp_(90) attach-agent $tcp_(90)
$ns at 0.2 "$ftp_(90) start"
$ns at 180.0 "$ftp_(90) stop"

#Set a TCP connection between node_(37) and node_(39)
set tcp_(91) [new Agent/TCP/Newreno]
$tcp_(91) set class_ 2
set sink_(91) [new Agent/TCPSink]
$ns attach-agent $node_(37) $tcp_(91)
$ns attach-agent $node_(39) $sink_(91)
$ns connect $tcp_(91) $sink_(91)
set ftp_(91) [new Application/FTP]
$ftp_(91) attach-agent $tcp_(91)
$ns at 180.2 "$ftp_(91) start"
$ns at 360.0 "$ftp_(91) stop"

#Set a TCP connection between node_(42) and node_(6)
set tcp_(92) [new Agent/TCP/Newreno]
$tcp_(92) set class_ 2
set sink_(92) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(92)
$ns attach-agent $node_(6) $sink_(92)
$ns connect $tcp_(92) $sink_(92)
set ftp_(92) [new Application/FTP]
$ftp_(92) attach-agent $tcp_(92)
$ns at 360.2 "$ftp_(92) start"
$ns at 540.0 "$ftp_(92) stop"

#Set a TCP connection between node_(18) and node_(47)
set tcp_(93) [new Agent/TCP/Newreno]
$tcp_(93) set class_ 2
set sink_(93) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(93)
$ns attach-agent $node_(47) $sink_(93)
$ns connect $tcp_(93) $sink_(93)
set ftp_(93) [new Application/FTP]
$ftp_(93) attach-agent $tcp_(93)
$ns at 540.2 "$ftp_(93) start"
$ns at 720.0 "$ftp_(93) stop"

#Set a TCP connection between node_(4) and node_(48)
set tcp_(94) [new Agent/TCP/Newreno]
$tcp_(94) set class_ 2
set sink_(94) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(94)
$ns attach-agent $node_(48) $sink_(94)
$ns connect $tcp_(94) $sink_(94)
set ftp_(94) [new Application/FTP]
$ftp_(94) attach-agent $tcp_(94)
$ns at 720.2 "$ftp_(94) start"
$ns at 900.0 "$ftp_(94) stop"

#Set a TCP connection between node_(12) and node_(27)
set tcp_(95) [new Agent/TCP/Newreno]
$tcp_(95) set class_ 2
set sink_(95) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(95)
$ns attach-agent $node_(27) $sink_(95)
$ns connect $tcp_(95) $sink_(95)
set ftp_(95) [new Application/FTP]
$ftp_(95) attach-agent $tcp_(95)
$ns at 0.2 "$ftp_(95) start"
$ns at 180.0 "$ftp_(95) stop"

#Set a TCP connection between node_(46) and node_(22)
set tcp_(96) [new Agent/TCP/Newreno]
$tcp_(96) set class_ 2
set sink_(96) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(96)
$ns attach-agent $node_(22) $sink_(96)
$ns connect $tcp_(96) $sink_(96)
set ftp_(96) [new Application/FTP]
$ftp_(96) attach-agent $tcp_(96)
$ns at 180.2 "$ftp_(96) start"
$ns at 360.0 "$ftp_(96) stop"

#Set a TCP connection between node_(3) and node_(37)
set tcp_(97) [new Agent/TCP/Newreno]
$tcp_(97) set class_ 2
set sink_(97) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(97)
$ns attach-agent $node_(37) $sink_(97)
$ns connect $tcp_(97) $sink_(97)
set ftp_(97) [new Application/FTP]
$ftp_(97) attach-agent $tcp_(97)
$ns at 360.2 "$ftp_(97) start"
$ns at 540.0 "$ftp_(97) stop"

#Set a TCP connection between node_(32) and node_(0)
set tcp_(98) [new Agent/TCP/Newreno]
$tcp_(98) set class_ 2
set sink_(98) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(98)
$ns attach-agent $node_(0) $sink_(98)
$ns connect $tcp_(98) $sink_(98)
set ftp_(98) [new Application/FTP]
$ftp_(98) attach-agent $tcp_(98)
$ns at 540.2 "$ftp_(98) start"
$ns at 720.0 "$ftp_(98) stop"

#Set a TCP connection between node_(41) and node_(18)
set tcp_(99) [new Agent/TCP/Newreno]
$tcp_(99) set class_ 2
set sink_(99) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(99)
$ns attach-agent $node_(18) $sink_(99)
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
