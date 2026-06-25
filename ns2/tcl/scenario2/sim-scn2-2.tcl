#sim-scn2-2.tcl 
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
set tracefd       [open sim-scn2-2-$val(rp)-trace.tr w]
set windowVsTime2 [open sim-scn2-2-$val(rp)-win-.tr w]
set namtrace      [open sim-scn2-2-$val(rp).nam w]

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
$node_(0) set X_ 1856 
$node_(0) set Y_ 32 
$node_(0) set Z_ 0.0 
$node_(1) set X_ 2642 
$node_(1) set Y_ 442 
$node_(1) set Z_ 0.0 
$node_(2) set X_ 2035 
$node_(2) set Y_ 493 
$node_(2) set Z_ 0.0 
$node_(3) set X_ 904 
$node_(3) set Y_ 700 
$node_(3) set Z_ 0.0 
$node_(4) set X_ 526 
$node_(4) set Y_ 536 
$node_(4) set Z_ 0.0 
$node_(5) set X_ 21 
$node_(5) set Y_ 620 
$node_(5) set Z_ 0.0 
$node_(6) set X_ 81 
$node_(6) set Y_ 279 
$node_(6) set Z_ 0.0 
$node_(7) set X_ 971 
$node_(7) set Y_ 508 
$node_(7) set Z_ 0.0 
$node_(8) set X_ 120 
$node_(8) set Y_ 238 
$node_(8) set Z_ 0.0 
$node_(9) set X_ 2255 
$node_(9) set Y_ 815 
$node_(9) set Z_ 0.0 
$node_(10) set X_ 469 
$node_(10) set Y_ 546 
$node_(10) set Z_ 0.0 
$node_(11) set X_ 468 
$node_(11) set Y_ 289 
$node_(11) set Z_ 0.0 
$node_(12) set X_ 2890 
$node_(12) set Y_ 310 
$node_(12) set Z_ 0.0 
$node_(13) set X_ 729 
$node_(13) set Y_ 934 
$node_(13) set Z_ 0.0 
$node_(14) set X_ 2747 
$node_(14) set Y_ 933 
$node_(14) set Z_ 0.0 
$node_(15) set X_ 2144 
$node_(15) set Y_ 744 
$node_(15) set Z_ 0.0 
$node_(16) set X_ 624 
$node_(16) set Y_ 690 
$node_(16) set Z_ 0.0 
$node_(17) set X_ 2487 
$node_(17) set Y_ 656 
$node_(17) set Z_ 0.0 
$node_(18) set X_ 1987 
$node_(18) set Y_ 561 
$node_(18) set Z_ 0.0 
$node_(19) set X_ 2484 
$node_(19) set Y_ 286 
$node_(19) set Z_ 0.0 
$node_(20) set X_ 890 
$node_(20) set Y_ 126 
$node_(20) set Z_ 0.0 
$node_(21) set X_ 2532 
$node_(21) set Y_ 800 
$node_(21) set Z_ 0.0 
$node_(22) set X_ 1436 
$node_(22) set Y_ 305 
$node_(22) set Z_ 0.0 
$node_(23) set X_ 1352 
$node_(23) set Y_ 681 
$node_(23) set Z_ 0.0 
$node_(24) set X_ 2076 
$node_(24) set Y_ 878 
$node_(24) set Z_ 0.0 
$node_(25) set X_ 2912 
$node_(25) set Y_ 273 
$node_(25) set Z_ 0.0 
$node_(26) set X_ 2918 
$node_(26) set Y_ 11 
$node_(26) set Z_ 0.0 
$node_(27) set X_ 96 
$node_(27) set Y_ 715 
$node_(27) set Z_ 0.0 
$node_(28) set X_ 96 
$node_(28) set Y_ 450 
$node_(28) set Z_ 0.0 
$node_(29) set X_ 1873 
$node_(29) set Y_ 280 
$node_(29) set Z_ 0.0 
$node_(30) set X_ 2727 
$node_(30) set Y_ 671 
$node_(30) set Z_ 0.0 
$node_(31) set X_ 260 
$node_(31) set Y_ 201 
$node_(31) set Z_ 0.0 
$node_(32) set X_ 2325 
$node_(32) set Y_ 22 
$node_(32) set Z_ 0.0 
$node_(33) set X_ 124 
$node_(33) set Y_ 775 
$node_(33) set Z_ 0.0 
$node_(34) set X_ 448 
$node_(34) set Y_ 823 
$node_(34) set Z_ 0.0 
$node_(35) set X_ 833 
$node_(35) set Y_ 914 
$node_(35) set Z_ 0.0 
$node_(36) set X_ 1120 
$node_(36) set Y_ 453 
$node_(36) set Z_ 0.0 
$node_(37) set X_ 2964 
$node_(37) set Y_ 339 
$node_(37) set Z_ 0.0 
$node_(38) set X_ 1945 
$node_(38) set Y_ 699 
$node_(38) set Z_ 0.0 
$node_(39) set X_ 1652 
$node_(39) set Y_ 289 
$node_(39) set Z_ 0.0 
$node_(40) set X_ 1006 
$node_(40) set Y_ 16 
$node_(40) set Z_ 0.0 
$node_(41) set X_ 824 
$node_(41) set Y_ 969 
$node_(41) set Z_ 0.0 
$node_(42) set X_ 1464 
$node_(42) set Y_ 897 
$node_(42) set Z_ 0.0 
$node_(43) set X_ 385 
$node_(43) set Y_ 961 
$node_(43) set Z_ 0.0 
$node_(44) set X_ 2380 
$node_(44) set Y_ 257 
$node_(44) set Z_ 0.0 
$node_(45) set X_ 1478 
$node_(45) set Y_ 454 
$node_(45) set Z_ 0.0 
$node_(46) set X_ 570 
$node_(46) set Y_ 581 
$node_(46) set Z_ 0.0 
$node_(47) set X_ 1241 
$node_(47) set Y_ 481 
$node_(47) set Z_ 0.0 
$node_(48) set X_ 1302 
$node_(48) set Y_ 609 
$node_(48) set Z_ 0.0 
$node_(49) set X_ 1970 
$node_(49) set Y_ 316 
$node_(49) set Z_ 0.0 
$node_(50) set X_ 2395 
$node_(50) set Y_ 492 
$node_(50) set Z_ 0.0 
$node_(51) set X_ 307 
$node_(51) set Y_ 782 
$node_(51) set Z_ 0.0 
$ns at 0.0 "$node_(51) off" 
$ns at 165.0 "$node_(51) on" 
$node_(52) set X_ 2737 
$node_(52) set Y_ 679 
$node_(52) set Z_ 0.0 
$ns at 0.0 "$node_(52) off" 
$ns at 165.0 "$node_(52) on" 
$node_(53) set X_ 2029 
$node_(53) set Y_ 527 
$node_(53) set Z_ 0.0 
$ns at 0.0 "$node_(53) off" 
$ns at 165.0 "$node_(53) on" 
$node_(54) set X_ 1385 
$node_(54) set Y_ 287 
$node_(54) set Z_ 0.0 
$ns at 0.0 "$node_(54) off" 
$ns at 165.0 "$node_(54) on" 
$node_(55) set X_ 159 
$node_(55) set Y_ 247 
$node_(55) set Z_ 0.0 
$ns at 0.0 "$node_(55) off" 
$ns at 165.0 "$node_(55) on" 
$node_(56) set X_ 322 
$node_(56) set Y_ 328 
$node_(56) set Z_ 0.0 
$ns at 0.0 "$node_(56) off" 
$ns at 165.0 "$node_(56) on" 
$node_(57) set X_ 2483 
$node_(57) set Y_ 429 
$node_(57) set Z_ 0.0 
$ns at 0.0 "$node_(57) off" 
$ns at 165.0 "$node_(57) on" 
$node_(58) set X_ 1546 
$node_(58) set Y_ 969 
$node_(58) set Z_ 0.0 
$ns at 0.0 "$node_(58) off" 
$ns at 165.0 "$node_(58) on" 
$node_(59) set X_ 2168 
$node_(59) set Y_ 429 
$node_(59) set Z_ 0.0 
$ns at 0.0 "$node_(59) off" 
$ns at 165.0 "$node_(59) on" 
$node_(60) set X_ 2498 
$node_(60) set Y_ 957 
$node_(60) set Z_ 0.0 
$ns at 0.0 "$node_(60) off" 
$ns at 165.0 "$node_(60) on" 
$node_(61) set X_ 1980 
$node_(61) set Y_ 605 
$node_(61) set Z_ 0.0 
$ns at 0.0 "$node_(61) off" 
$ns at 165.0 "$node_(61) on" 
$node_(62) set X_ 870 
$node_(62) set Y_ 434 
$node_(62) set Z_ 0.0 
$ns at 0.0 "$node_(62) off" 
$ns at 165.0 "$node_(62) on" 
$node_(63) set X_ 627 
$node_(63) set Y_ 795 
$node_(63) set Z_ 0.0 
$ns at 0.0 "$node_(63) off" 
$ns at 165.0 "$node_(63) on" 
$node_(64) set X_ 2610 
$node_(64) set Y_ 637 
$node_(64) set Z_ 0.0 
$ns at 0.0 "$node_(64) off" 
$ns at 165.0 "$node_(64) on" 
$node_(65) set X_ 11 
$node_(65) set Y_ 626 
$node_(65) set Z_ 0.0 
$ns at 0.0 "$node_(65) off" 
$ns at 165.0 "$node_(65) on" 
$node_(66) set X_ 430 
$node_(66) set Y_ 405 
$node_(66) set Z_ 0.0 
$ns at 0.0 "$node_(66) off" 
$ns at 165.0 "$node_(66) on" 
$node_(67) set X_ 626 
$node_(67) set Y_ 37 
$node_(67) set Z_ 0.0 
$ns at 0.0 "$node_(67) off" 
$ns at 165.0 "$node_(67) on" 
$node_(68) set X_ 1296 
$node_(68) set Y_ 969 
$node_(68) set Z_ 0.0 
$ns at 0.0 "$node_(68) off" 
$ns at 165.0 "$node_(68) on" 
$node_(69) set X_ 42 
$node_(69) set Y_ 894 
$node_(69) set Z_ 0.0 
$ns at 0.0 "$node_(69) off" 
$ns at 165.0 "$node_(69) on" 
$node_(70) set X_ 1346 
$node_(70) set Y_ 263 
$node_(70) set Z_ 0.0 
$ns at 0.0 "$node_(70) off" 
$ns at 165.0 "$node_(70) on" 
$node_(71) set X_ 1312 
$node_(71) set Y_ 807 
$node_(71) set Z_ 0.0 
$ns at 0.0 "$node_(71) off" 
$ns at 165.0 "$node_(71) on" 
$node_(72) set X_ 1271 
$node_(72) set Y_ 838 
$node_(72) set Z_ 0.0 
$ns at 0.0 "$node_(72) off" 
$ns at 165.0 "$node_(72) on" 
$node_(73) set X_ 1255 
$node_(73) set Y_ 38 
$node_(73) set Z_ 0.0 
$ns at 0.0 "$node_(73) off" 
$ns at 165.0 "$node_(73) on" 
$node_(74) set X_ 1593 
$node_(74) set Y_ 563 
$node_(74) set Z_ 0.0 
$ns at 0.0 "$node_(74) off" 
$ns at 165.0 "$node_(74) on" 
$node_(75) set X_ 938 
$node_(75) set Y_ 955 
$node_(75) set Z_ 0.0 
$ns at 0.0 "$node_(75) off" 
$ns at 330.0 "$node_(75) on" 
$node_(76) set X_ 336 
$node_(76) set Y_ 435 
$node_(76) set Z_ 0.0 
$ns at 0.0 "$node_(76) off" 
$ns at 330.0 "$node_(76) on" 
$node_(77) set X_ 1197 
$node_(77) set Y_ 572 
$node_(77) set Z_ 0.0 
$ns at 0.0 "$node_(77) off" 
$ns at 330.0 "$node_(77) on" 
$node_(78) set X_ 2363 
$node_(78) set Y_ 231 
$node_(78) set Z_ 0.0 
$ns at 0.0 "$node_(78) off" 
$ns at 330.0 "$node_(78) on" 
$node_(79) set X_ 2866 
$node_(79) set Y_ 590 
$node_(79) set Z_ 0.0 
$ns at 0.0 "$node_(79) off" 
$ns at 330.0 "$node_(79) on" 
$node_(80) set X_ 210 
$node_(80) set Y_ 204 
$node_(80) set Z_ 0.0 
$ns at 0.0 "$node_(80) off" 
$ns at 330.0 "$node_(80) on" 
$node_(81) set X_ 2350 
$node_(81) set Y_ 759 
$node_(81) set Z_ 0.0 
$ns at 0.0 "$node_(81) off" 
$ns at 330.0 "$node_(81) on" 
$node_(82) set X_ 1442 
$node_(82) set Y_ 731 
$node_(82) set Z_ 0.0 
$ns at 0.0 "$node_(82) off" 
$ns at 330.0 "$node_(82) on" 
$node_(83) set X_ 2404 
$node_(83) set Y_ 557 
$node_(83) set Z_ 0.0 
$ns at 0.0 "$node_(83) off" 
$ns at 330.0 "$node_(83) on" 
$node_(84) set X_ 1515 
$node_(84) set Y_ 610 
$node_(84) set Z_ 0.0 
$ns at 0.0 "$node_(84) off" 
$ns at 330.0 "$node_(84) on" 
$node_(85) set X_ 1414 
$node_(85) set Y_ 910 
$node_(85) set Z_ 0.0 
$ns at 0.0 "$node_(85) off" 
$ns at 330.0 "$node_(85) on" 
$node_(86) set X_ 2831 
$node_(86) set Y_ 716 
$node_(86) set Z_ 0.0 
$ns at 0.0 "$node_(86) off" 
$ns at 330.0 "$node_(86) on" 
$node_(87) set X_ 1152 
$node_(87) set Y_ 163 
$node_(87) set Z_ 0.0 
$ns at 0.0 "$node_(87) off" 
$ns at 330.0 "$node_(87) on" 
$node_(88) set X_ 1010 
$node_(88) set Y_ 855 
$node_(88) set Z_ 0.0 
$ns at 0.0 "$node_(88) off" 
$ns at 330.0 "$node_(88) on" 
$node_(89) set X_ 808 
$node_(89) set Y_ 552 
$node_(89) set Z_ 0.0 
$ns at 0.0 "$node_(89) off" 
$ns at 330.0 "$node_(89) on" 
$node_(90) set X_ 558 
$node_(90) set Y_ 922 
$node_(90) set Z_ 0.0 
$ns at 0.0 "$node_(90) off" 
$ns at 330.0 "$node_(90) on" 
$node_(91) set X_ 244 
$node_(91) set Y_ 222 
$node_(91) set Z_ 0.0 
$ns at 0.0 "$node_(91) off" 
$ns at 330.0 "$node_(91) on" 
$node_(92) set X_ 1915 
$node_(92) set Y_ 967 
$node_(92) set Z_ 0.0 
$ns at 0.0 "$node_(92) off" 
$ns at 330.0 "$node_(92) on" 
$node_(93) set X_ 1691 
$node_(93) set Y_ 190 
$node_(93) set Z_ 0.0 
$ns at 0.0 "$node_(93) off" 
$ns at 330.0 "$node_(93) on" 
$node_(94) set X_ 406 
$node_(94) set Y_ 340 
$node_(94) set Z_ 0.0 
$ns at 0.0 "$node_(94) off" 
$ns at 330.0 "$node_(94) on" 
$node_(95) set X_ 2648 
$node_(95) set Y_ 767 
$node_(95) set Z_ 0.0 
$ns at 0.0 "$node_(95) off" 
$ns at 330.0 "$node_(95) on" 
$node_(96) set X_ 911 
$node_(96) set Y_ 870 
$node_(96) set Z_ 0.0 
$ns at 0.0 "$node_(96) off" 
$ns at 330.0 "$node_(96) on" 
$node_(97) set X_ 1514 
$node_(97) set Y_ 608 
$node_(97) set Z_ 0.0 
$ns at 0.0 "$node_(97) off" 
$ns at 330.0 "$node_(97) on" 
$node_(98) set X_ 19 
$node_(98) set Y_ 932 
$node_(98) set Z_ 0.0 
$ns at 0.0 "$node_(98) off" 
$ns at 330.0 "$node_(98) on" 
$node_(99) set X_ 1413 
$node_(99) set Y_ 995 
$node_(99) set Z_ 0.0 
$ns at 0.0 "$node_(99) off" 
$ns at 330.0 "$node_(99) on" 
$node_(100) set X_ 159 
$node_(100) set Y_ 366 
$node_(100) set Z_ 0.0 
$ns at 0.0 "$node_(100) off" 
$ns at 495.0 "$node_(100) on" 
$node_(101) set X_ 1889 
$node_(101) set Y_ 923 
$node_(101) set Z_ 0.0 
$ns at 0.0 "$node_(101) off" 
$ns at 495.0 "$node_(101) on" 
$node_(102) set X_ 1609 
$node_(102) set Y_ 397 
$node_(102) set Z_ 0.0 
$ns at 0.0 "$node_(102) off" 
$ns at 495.0 "$node_(102) on" 
$node_(103) set X_ 539 
$node_(103) set Y_ 295 
$node_(103) set Z_ 0.0 
$ns at 0.0 "$node_(103) off" 
$ns at 495.0 "$node_(103) on" 
$node_(104) set X_ 425 
$node_(104) set Y_ 141 
$node_(104) set Z_ 0.0 
$ns at 0.0 "$node_(104) off" 
$ns at 495.0 "$node_(104) on" 
$node_(105) set X_ 290 
$node_(105) set Y_ 848 
$node_(105) set Z_ 0.0 
$ns at 0.0 "$node_(105) off" 
$ns at 495.0 "$node_(105) on" 
$node_(106) set X_ 206 
$node_(106) set Y_ 776 
$node_(106) set Z_ 0.0 
$ns at 0.0 "$node_(106) off" 
$ns at 495.0 "$node_(106) on" 
$node_(107) set X_ 1842 
$node_(107) set Y_ 422 
$node_(107) set Z_ 0.0 
$ns at 0.0 "$node_(107) off" 
$ns at 495.0 "$node_(107) on" 
$node_(108) set X_ 1151 
$node_(108) set Y_ 213 
$node_(108) set Z_ 0.0 
$ns at 0.0 "$node_(108) off" 
$ns at 495.0 "$node_(108) on" 
$node_(109) set X_ 2887 
$node_(109) set Y_ 867 
$node_(109) set Z_ 0.0 
$ns at 0.0 "$node_(109) off" 
$ns at 495.0 "$node_(109) on" 
$node_(110) set X_ 2202 
$node_(110) set Y_ 901 
$node_(110) set Z_ 0.0 
$ns at 0.0 "$node_(110) off" 
$ns at 495.0 "$node_(110) on" 
$node_(111) set X_ 2992 
$node_(111) set Y_ 159 
$node_(111) set Z_ 0.0 
$ns at 0.0 "$node_(111) off" 
$ns at 495.0 "$node_(111) on" 
$node_(112) set X_ 1065 
$node_(112) set Y_ 458 
$node_(112) set Z_ 0.0 
$ns at 0.0 "$node_(112) off" 
$ns at 495.0 "$node_(112) on" 
$node_(113) set X_ 508 
$node_(113) set Y_ 284 
$node_(113) set Z_ 0.0 
$ns at 0.0 "$node_(113) off" 
$ns at 495.0 "$node_(113) on" 
$node_(114) set X_ 614 
$node_(114) set Y_ 967 
$node_(114) set Z_ 0.0 
$ns at 0.0 "$node_(114) off" 
$ns at 495.0 "$node_(114) on" 
$node_(115) set X_ 1615 
$node_(115) set Y_ 59 
$node_(115) set Z_ 0.0 
$ns at 0.0 "$node_(115) off" 
$ns at 495.0 "$node_(115) on" 
$node_(116) set X_ 2671 
$node_(116) set Y_ 103 
$node_(116) set Z_ 0.0 
$ns at 0.0 "$node_(116) off" 
$ns at 495.0 "$node_(116) on" 
$node_(117) set X_ 538 
$node_(117) set Y_ 351 
$node_(117) set Z_ 0.0 
$ns at 0.0 "$node_(117) off" 
$ns at 495.0 "$node_(117) on" 
$node_(118) set X_ 2310 
$node_(118) set Y_ 741 
$node_(118) set Z_ 0.0 
$ns at 0.0 "$node_(118) off" 
$ns at 495.0 "$node_(118) on" 
$node_(119) set X_ 1110 
$node_(119) set Y_ 71 
$node_(119) set Z_ 0.0 
$ns at 0.0 "$node_(119) off" 
$ns at 495.0 "$node_(119) on" 
$node_(120) set X_ 698 
$node_(120) set Y_ 341 
$node_(120) set Z_ 0.0 
$ns at 0.0 "$node_(120) off" 
$ns at 495.0 "$node_(120) on" 
$node_(121) set X_ 1263 
$node_(121) set Y_ 928 
$node_(121) set Z_ 0.0 
$ns at 0.0 "$node_(121) off" 
$ns at 495.0 "$node_(121) on" 
$node_(122) set X_ 2153 
$node_(122) set Y_ 177 
$node_(122) set Z_ 0.0 
$ns at 0.0 "$node_(122) off" 
$ns at 495.0 "$node_(122) on" 
$node_(123) set X_ 2588 
$node_(123) set Y_ 163 
$node_(123) set Z_ 0.0 
$ns at 0.0 "$node_(123) off" 
$ns at 495.0 "$node_(123) on" 
$node_(124) set X_ 1359 
$node_(124) set Y_ 457 
$node_(124) set Z_ 0.0 
$ns at 0.0 "$node_(124) off" 
$ns at 495.0 "$node_(124) on" 
$node_(125) set X_ 2938 
$node_(125) set Y_ 394 
$node_(125) set Z_ 0.0 
$ns at 0.0 "$node_(125) off" 
$ns at 660.0 "$node_(125) on" 
$node_(126) set X_ 776 
$node_(126) set Y_ 461 
$node_(126) set Z_ 0.0 
$ns at 0.0 "$node_(126) off" 
$ns at 660.0 "$node_(126) on" 
$node_(127) set X_ 1079 
$node_(127) set Y_ 256 
$node_(127) set Z_ 0.0 
$ns at 0.0 "$node_(127) off" 
$ns at 660.0 "$node_(127) on" 
$node_(128) set X_ 14 
$node_(128) set Y_ 105 
$node_(128) set Z_ 0.0 
$ns at 0.0 "$node_(128) off" 
$ns at 660.0 "$node_(128) on" 
$node_(129) set X_ 616 
$node_(129) set Y_ 748 
$node_(129) set Z_ 0.0 
$ns at 0.0 "$node_(129) off" 
$ns at 660.0 "$node_(129) on" 
$node_(130) set X_ 1452 
$node_(130) set Y_ 750 
$node_(130) set Z_ 0.0 
$ns at 0.0 "$node_(130) off" 
$ns at 660.0 "$node_(130) on" 
$node_(131) set X_ 1926 
$node_(131) set Y_ 51 
$node_(131) set Z_ 0.0 
$ns at 0.0 "$node_(131) off" 
$ns at 660.0 "$node_(131) on" 
$node_(132) set X_ 1554 
$node_(132) set Y_ 645 
$node_(132) set Z_ 0.0 
$ns at 0.0 "$node_(132) off" 
$ns at 660.0 "$node_(132) on" 
$node_(133) set X_ 501 
$node_(133) set Y_ 127 
$node_(133) set Z_ 0.0 
$ns at 0.0 "$node_(133) off" 
$ns at 660.0 "$node_(133) on" 
$node_(134) set X_ 281 
$node_(134) set Y_ 136 
$node_(134) set Z_ 0.0 
$ns at 0.0 "$node_(134) off" 
$ns at 660.0 "$node_(134) on" 
$node_(135) set X_ 1988 
$node_(135) set Y_ 592 
$node_(135) set Z_ 0.0 
$ns at 0.0 "$node_(135) off" 
$ns at 660.0 "$node_(135) on" 
$node_(136) set X_ 626 
$node_(136) set Y_ 663 
$node_(136) set Z_ 0.0 
$ns at 0.0 "$node_(136) off" 
$ns at 660.0 "$node_(136) on" 
$node_(137) set X_ 375 
$node_(137) set Y_ 180 
$node_(137) set Z_ 0.0 
$ns at 0.0 "$node_(137) off" 
$ns at 660.0 "$node_(137) on" 
$node_(138) set X_ 2653 
$node_(138) set Y_ 582 
$node_(138) set Z_ 0.0 
$ns at 0.0 "$node_(138) off" 
$ns at 660.0 "$node_(138) on" 
$node_(139) set X_ 1090 
$node_(139) set Y_ 637 
$node_(139) set Z_ 0.0 
$ns at 0.0 "$node_(139) off" 
$ns at 660.0 "$node_(139) on" 
$node_(140) set X_ 1514 
$node_(140) set Y_ 94 
$node_(140) set Z_ 0.0 
$ns at 0.0 "$node_(140) off" 
$ns at 660.0 "$node_(140) on" 
$node_(141) set X_ 1344 
$node_(141) set Y_ 17 
$node_(141) set Z_ 0.0 
$ns at 0.0 "$node_(141) off" 
$ns at 660.0 "$node_(141) on" 
$node_(142) set X_ 697 
$node_(142) set Y_ 878 
$node_(142) set Z_ 0.0 
$ns at 0.0 "$node_(142) off" 
$ns at 660.0 "$node_(142) on" 
$node_(143) set X_ 1840 
$node_(143) set Y_ 172 
$node_(143) set Z_ 0.0 
$ns at 0.0 "$node_(143) off" 
$ns at 660.0 "$node_(143) on" 
$node_(144) set X_ 2280 
$node_(144) set Y_ 569 
$node_(144) set Z_ 0.0 
$ns at 0.0 "$node_(144) off" 
$ns at 660.0 "$node_(144) on" 
$node_(145) set X_ 1958 
$node_(145) set Y_ 688 
$node_(145) set Z_ 0.0 
$ns at 0.0 "$node_(145) off" 
$ns at 660.0 "$node_(145) on" 
$node_(146) set X_ 201 
$node_(146) set Y_ 863 
$node_(146) set Z_ 0.0 
$ns at 0.0 "$node_(146) off" 
$ns at 660.0 "$node_(146) on" 
$node_(147) set X_ 1743 
$node_(147) set Y_ 651 
$node_(147) set Z_ 0.0 
$ns at 0.0 "$node_(147) off" 
$ns at 660.0 "$node_(147) on" 
$node_(148) set X_ 502 
$node_(148) set Y_ 892 
$node_(148) set Z_ 0.0 
$ns at 0.0 "$node_(148) off" 
$ns at 660.0 "$node_(148) on" 
$node_(149) set X_ 1477 
$node_(149) set Y_ 390 
$node_(149) set Z_ 0.0 
$ns at 0.0 "$node_(149) off" 
$ns at 660.0 "$node_(149) on" 

# Generation of movements
$ns at 0.0 "$node_(0) setdest 187 445 2.0" 
$ns at 45.87550399556422 "$node_(0) setdest 694 799 5.0" 
$ns at 119.67397557637108 "$node_(0) setdest 137 185 14.0" 
$ns at 152.9869109504647 "$node_(0) setdest 1251 371 15.0" 
$ns at 296.12790807318663 "$node_(0) setdest 2558 464 15.0" 
$ns at 457.3687256443705 "$node_(0) setdest 2513 772 12.0" 
$ns at 565.3705122226512 "$node_(0) setdest 378 508 8.0" 
$ns at 671.8063257173208 "$node_(0) setdest 285 185 13.0" 
$ns at 757.3202843985466 "$node_(0) setdest 2355 776 7.0" 
$ns at 807.9070842752368 "$node_(0) setdest 1891 105 3.0" 
$ns at 865.8380340827256 "$node_(0) setdest 501 498 5.0" 
$ns at 0.0 "$node_(1) setdest 628 375 6.0" 
$ns at 87.59866739032448 "$node_(1) setdest 201 379 4.0" 
$ns at 143.89881146488466 "$node_(1) setdest 1185 611 17.0" 
$ns at 245.10076480816036 "$node_(1) setdest 517 719 15.0" 
$ns at 389.43397159208575 "$node_(1) setdest 375 918 15.0" 
$ns at 549.2971368908057 "$node_(1) setdest 1883 501 13.0" 
$ns at 643.207071469031 "$node_(1) setdest 2280 29 11.0" 
$ns at 772.944021582839 "$node_(1) setdest 2145 191 1.0" 
$ns at 807.2504355988249 "$node_(1) setdest 632 272 18.0" 
$ns at 863.4502961447783 "$node_(1) setdest 2688 275 20.0" 
$ns at 0.0 "$node_(2) setdest 30 2 18.0" 
$ns at 146.41432019872747 "$node_(2) setdest 2081 817 9.0" 
$ns at 186.00467475639425 "$node_(2) setdest 1334 402 14.0" 
$ns at 232.4414993035339 "$node_(2) setdest 482 531 5.0" 
$ns at 308.16536951891874 "$node_(2) setdest 319 784 9.0" 
$ns at 362.11531558120134 "$node_(2) setdest 2760 166 2.0" 
$ns at 411.48164713205983 "$node_(2) setdest 1431 798 1.0" 
$ns at 441.9339123358477 "$node_(2) setdest 34 199 8.0" 
$ns at 540.0071482842031 "$node_(2) setdest 1245 188 2.0" 
$ns at 584.6849876873067 "$node_(2) setdest 122 121 7.0" 
$ns at 618.0175674252293 "$node_(2) setdest 1943 982 17.0" 
$ns at 659.6909796098009 "$node_(2) setdest 1086 830 2.0" 
$ns at 706.0704114302354 "$node_(2) setdest 1927 276 13.0" 
$ns at 850.325428776182 "$node_(2) setdest 864 896 19.0" 
$ns at 885.17726876032 "$node_(2) setdest 1388 998 9.0" 
$ns at 0.0 "$node_(3) setdest 1676 728 12.0" 
$ns at 58.37934805006671 "$node_(3) setdest 1429 285 1.0" 
$ns at 97.96024610916767 "$node_(3) setdest 1697 906 8.0" 
$ns at 184.3153702118586 "$node_(3) setdest 83 398 10.0" 
$ns at 216.73315400562387 "$node_(3) setdest 194 192 15.0" 
$ns at 252.45643571114164 "$node_(3) setdest 1308 286 1.0" 
$ns at 290.2165149736407 "$node_(3) setdest 1094 8 1.0" 
$ns at 326.7715982739721 "$node_(3) setdest 2812 212 2.0" 
$ns at 360.64571098335307 "$node_(3) setdest 701 375 18.0" 
$ns at 453.36681930700865 "$node_(3) setdest 1281 89 6.0" 
$ns at 534.6496735093324 "$node_(3) setdest 33 606 1.0" 
$ns at 570.0714836694733 "$node_(3) setdest 368 404 3.0" 
$ns at 627.0390167964467 "$node_(3) setdest 1976 256 8.0" 
$ns at 663.4781793224199 "$node_(3) setdest 1516 886 12.0" 
$ns at 712.0438595522454 "$node_(3) setdest 2242 112 3.0" 
$ns at 760.6233566216564 "$node_(3) setdest 467 320 6.0" 
$ns at 798.6074520453546 "$node_(3) setdest 1824 225 16.0" 
$ns at 0.0 "$node_(4) setdest 1041 125 7.0" 
$ns at 89.2605618114103 "$node_(4) setdest 434 278 15.0" 
$ns at 255.48367258918142 "$node_(4) setdest 1528 625 11.0" 
$ns at 358.1485324650039 "$node_(4) setdest 121 781 11.0" 
$ns at 440.78048525597745 "$node_(4) setdest 2777 128 7.0" 
$ns at 515.1162532297831 "$node_(4) setdest 1044 887 3.0" 
$ns at 561.5277757854685 "$node_(4) setdest 830 225 19.0" 
$ns at 601.4841084638696 "$node_(4) setdest 2110 839 12.0" 
$ns at 663.1278674548262 "$node_(4) setdest 2687 948 17.0" 
$ns at 714.1776414739658 "$node_(4) setdest 1952 308 16.0" 
$ns at 875.0579137785314 "$node_(4) setdest 2537 679 7.0" 
$ns at 0.0 "$node_(5) setdest 2439 162 5.0" 
$ns at 49.36352210667743 "$node_(5) setdest 555 961 17.0" 
$ns at 207.94291015469153 "$node_(5) setdest 2716 415 18.0" 
$ns at 300.7522719837938 "$node_(5) setdest 96 598 6.0" 
$ns at 364.4924316659766 "$node_(5) setdest 2451 392 4.0" 
$ns at 398.07168785496356 "$node_(5) setdest 878 697 16.0" 
$ns at 551.8772192352333 "$node_(5) setdest 790 368 11.0" 
$ns at 690.9778154564852 "$node_(5) setdest 500 536 14.0" 
$ns at 774.6610216391152 "$node_(5) setdest 2211 205 11.0" 
$ns at 852.3298446877707 "$node_(5) setdest 2378 412 7.0" 
$ns at 0.0 "$node_(6) setdest 2245 760 10.0" 
$ns at 117.64897328338473 "$node_(6) setdest 1935 863 15.0" 
$ns at 170.28859463063236 "$node_(6) setdest 1791 74 3.0" 
$ns at 211.80534159225914 "$node_(6) setdest 1648 895 11.0" 
$ns at 259.5039948058849 "$node_(6) setdest 477 624 14.0" 
$ns at 309.1472145038273 "$node_(6) setdest 1281 133 9.0" 
$ns at 341.40682918084553 "$node_(6) setdest 1289 146 1.0" 
$ns at 379.538065315131 "$node_(6) setdest 400 15 4.0" 
$ns at 430.42510631272074 "$node_(6) setdest 2425 805 16.0" 
$ns at 593.8019890134543 "$node_(6) setdest 1 437 20.0" 
$ns at 624.0137596726722 "$node_(6) setdest 1103 733 17.0" 
$ns at 812.268795600125 "$node_(6) setdest 2852 503 11.0" 
$ns at 0.0 "$node_(7) setdest 1771 196 14.0" 
$ns at 100.12150513062397 "$node_(7) setdest 886 242 2.0" 
$ns at 141.10931450957935 "$node_(7) setdest 947 919 17.0" 
$ns at 280.17348122492444 "$node_(7) setdest 1724 481 6.0" 
$ns at 365.84116092889155 "$node_(7) setdest 2647 334 1.0" 
$ns at 405.21851022204265 "$node_(7) setdest 185 223 7.0" 
$ns at 439.26368928547583 "$node_(7) setdest 2114 772 4.0" 
$ns at 482.3101000719518 "$node_(7) setdest 2360 218 12.0" 
$ns at 514.5936781084321 "$node_(7) setdest 2328 864 19.0" 
$ns at 663.1093654017607 "$node_(7) setdest 594 580 12.0" 
$ns at 761.9127996186791 "$node_(7) setdest 2484 679 14.0" 
$ns at 869.0270135473311 "$node_(7) setdest 2471 632 17.0" 
$ns at 0.0 "$node_(8) setdest 433 362 15.0" 
$ns at 79.64936186733317 "$node_(8) setdest 1626 344 11.0" 
$ns at 147.683585982851 "$node_(8) setdest 780 291 4.0" 
$ns at 185.70442322123324 "$node_(8) setdest 998 28 4.0" 
$ns at 236.63631064787396 "$node_(8) setdest 111 26 11.0" 
$ns at 311.54475011367913 "$node_(8) setdest 1842 173 19.0" 
$ns at 469.0538689495531 "$node_(8) setdest 2569 574 9.0" 
$ns at 547.5561748973416 "$node_(8) setdest 1598 573 13.0" 
$ns at 580.889406992209 "$node_(8) setdest 2730 723 8.0" 
$ns at 630.1941881635521 "$node_(8) setdest 2464 134 6.0" 
$ns at 692.390121343199 "$node_(8) setdest 2510 487 2.0" 
$ns at 736.2656835588244 "$node_(8) setdest 248 13 7.0" 
$ns at 790.1338214963204 "$node_(8) setdest 558 908 17.0" 
$ns at 886.2156770620672 "$node_(8) setdest 1852 975 3.0" 
$ns at 0.0 "$node_(9) setdest 1347 761 13.0" 
$ns at 38.881773452241966 "$node_(9) setdest 471 122 3.0" 
$ns at 96.4385729860285 "$node_(9) setdest 1943 900 1.0" 
$ns at 135.37392915297167 "$node_(9) setdest 351 381 15.0" 
$ns at 280.30988290299825 "$node_(9) setdest 2147 297 14.0" 
$ns at 335.26467343573665 "$node_(9) setdest 688 396 8.0" 
$ns at 418.8784124846438 "$node_(9) setdest 489 21 18.0" 
$ns at 497.6167143295945 "$node_(9) setdest 2017 726 10.0" 
$ns at 584.9759970638374 "$node_(9) setdest 2287 679 8.0" 
$ns at 648.1445192886302 "$node_(9) setdest 180 483 2.0" 
$ns at 680.2446610079334 "$node_(9) setdest 726 106 19.0" 
$ns at 837.6589439595184 "$node_(9) setdest 2704 809 11.0" 
$ns at 0.0 "$node_(10) setdest 687 295 17.0" 
$ns at 69.51039629714117 "$node_(10) setdest 1187 846 5.0" 
$ns at 125.27992311728329 "$node_(10) setdest 2777 866 9.0" 
$ns at 219.84826287442013 "$node_(10) setdest 2031 73 5.0" 
$ns at 264.5007337234879 "$node_(10) setdest 784 573 14.0" 
$ns at 331.6108184611897 "$node_(10) setdest 2610 176 9.0" 
$ns at 425.80362822006646 "$node_(10) setdest 1520 623 18.0" 
$ns at 550.2384713970708 "$node_(10) setdest 1713 825 16.0" 
$ns at 718.1214397865094 "$node_(10) setdest 1760 835 3.0" 
$ns at 774.0580894716545 "$node_(10) setdest 1851 28 17.0" 
$ns at 0.0 "$node_(11) setdest 1751 899 18.0" 
$ns at 99.33985227040455 "$node_(11) setdest 770 929 1.0" 
$ns at 134.8443011544915 "$node_(11) setdest 507 257 13.0" 
$ns at 238.6042630302943 "$node_(11) setdest 261 212 7.0" 
$ns at 310.0113778242447 "$node_(11) setdest 2838 379 14.0" 
$ns at 429.346926472165 "$node_(11) setdest 1100 502 12.0" 
$ns at 480.6740078988499 "$node_(11) setdest 2851 448 2.0" 
$ns at 530.4016528619356 "$node_(11) setdest 1716 407 17.0" 
$ns at 702.0294704504407 "$node_(11) setdest 2370 730 15.0" 
$ns at 763.5801496540319 "$node_(11) setdest 927 88 2.0" 
$ns at 805.3941461431841 "$node_(11) setdest 503 140 1.0" 
$ns at 841.6762184995112 "$node_(11) setdest 2816 522 6.0" 
$ns at 890.450853099755 "$node_(11) setdest 2307 785 13.0" 
$ns at 0.0 "$node_(12) setdest 1621 824 8.0" 
$ns at 95.3915413808514 "$node_(12) setdest 2279 490 5.0" 
$ns at 132.22507485746797 "$node_(12) setdest 194 296 9.0" 
$ns at 231.1171445949284 "$node_(12) setdest 1126 589 1.0" 
$ns at 270.564575557808 "$node_(12) setdest 2388 92 10.0" 
$ns at 352.5697247572182 "$node_(12) setdest 1045 496 14.0" 
$ns at 447.22658988519873 "$node_(12) setdest 1462 631 1.0" 
$ns at 481.5285168155475 "$node_(12) setdest 455 815 2.0" 
$ns at 516.3625813018128 "$node_(12) setdest 2329 168 3.0" 
$ns at 553.8382343563302 "$node_(12) setdest 922 31 17.0" 
$ns at 661.1698076266587 "$node_(12) setdest 2263 164 12.0" 
$ns at 768.3718618274474 "$node_(12) setdest 715 31 6.0" 
$ns at 854.9111896142052 "$node_(12) setdest 2373 343 12.0" 
$ns at 0.0 "$node_(13) setdest 1232 983 1.0" 
$ns at 33.88823801755984 "$node_(13) setdest 2958 585 1.0" 
$ns at 73.69606132400054 "$node_(13) setdest 2247 343 11.0" 
$ns at 180.54487179757945 "$node_(13) setdest 2577 50 6.0" 
$ns at 244.15466639609775 "$node_(13) setdest 1691 9 11.0" 
$ns at 373.6877090359054 "$node_(13) setdest 418 181 14.0" 
$ns at 466.88644171280566 "$node_(13) setdest 1444 892 15.0" 
$ns at 526.1379512693462 "$node_(13) setdest 2307 467 16.0" 
$ns at 585.2378195189923 "$node_(13) setdest 344 413 17.0" 
$ns at 765.6244352429882 "$node_(13) setdest 1455 130 16.0" 
$ns at 834.27656850699 "$node_(13) setdest 1375 720 19.0" 
$ns at 0.0 "$node_(14) setdest 1774 112 4.0" 
$ns at 30.935897617212404 "$node_(14) setdest 756 619 11.0" 
$ns at 143.2484879111865 "$node_(14) setdest 2358 24 17.0" 
$ns at 259.9522774235855 "$node_(14) setdest 2400 498 9.0" 
$ns at 345.655513159331 "$node_(14) setdest 460 930 9.0" 
$ns at 457.9918731868544 "$node_(14) setdest 2938 775 20.0" 
$ns at 623.6370999592175 "$node_(14) setdest 2064 137 18.0" 
$ns at 785.7288057893695 "$node_(14) setdest 1296 614 17.0" 
$ns at 885.3489465936542 "$node_(14) setdest 2895 360 14.0" 
$ns at 0.0 "$node_(15) setdest 525 959 14.0" 
$ns at 67.60411522339538 "$node_(15) setdest 2438 927 3.0" 
$ns at 100.75624893789858 "$node_(15) setdest 358 127 18.0" 
$ns at 237.04628382961192 "$node_(15) setdest 326 901 7.0" 
$ns at 279.1346857049614 "$node_(15) setdest 700 503 20.0" 
$ns at 329.28737766868744 "$node_(15) setdest 180 279 17.0" 
$ns at 440.56591546947413 "$node_(15) setdest 1020 87 9.0" 
$ns at 480.7280987062813 "$node_(15) setdest 1736 654 19.0" 
$ns at 621.5692424605681 "$node_(15) setdest 2363 929 1.0" 
$ns at 659.0126952768212 "$node_(15) setdest 1855 984 13.0" 
$ns at 736.8430583409328 "$node_(15) setdest 1447 712 19.0" 
$ns at 0.0 "$node_(16) setdest 1754 366 19.0" 
$ns at 173.25355447028815 "$node_(16) setdest 46 999 9.0" 
$ns at 264.8294047286395 "$node_(16) setdest 542 959 15.0" 
$ns at 369.6852888683766 "$node_(16) setdest 2647 932 6.0" 
$ns at 449.93747827324864 "$node_(16) setdest 920 448 13.0" 
$ns at 579.1065027752011 "$node_(16) setdest 74 376 16.0" 
$ns at 716.7826611902597 "$node_(16) setdest 2601 700 18.0" 
$ns at 819.7324888835697 "$node_(16) setdest 561 799 1.0" 
$ns at 859.2399157949021 "$node_(16) setdest 1831 494 5.0" 
$ns at 0.0 "$node_(17) setdest 2473 401 8.0" 
$ns at 30.78624509716418 "$node_(17) setdest 1064 483 5.0" 
$ns at 89.80223812234485 "$node_(17) setdest 1658 254 17.0" 
$ns at 189.3882135580842 "$node_(17) setdest 655 778 9.0" 
$ns at 232.4175717801951 "$node_(17) setdest 1124 484 3.0" 
$ns at 269.75055467702845 "$node_(17) setdest 2150 792 14.0" 
$ns at 394.8143841808618 "$node_(17) setdest 524 760 2.0" 
$ns at 439.195404656815 "$node_(17) setdest 2515 249 17.0" 
$ns at 486.45245364240793 "$node_(17) setdest 659 605 17.0" 
$ns at 653.666794157198 "$node_(17) setdest 1395 493 3.0" 
$ns at 691.753053441396 "$node_(17) setdest 1949 303 10.0" 
$ns at 730.2281552916381 "$node_(17) setdest 2243 503 9.0" 
$ns at 777.6080470918041 "$node_(17) setdest 613 428 15.0" 
$ns at 817.3252990962235 "$node_(17) setdest 907 243 16.0" 
$ns at 0.0 "$node_(18) setdest 2003 247 13.0" 
$ns at 110.15383423570592 "$node_(18) setdest 1013 256 1.0" 
$ns at 143.27891552976698 "$node_(18) setdest 2312 534 15.0" 
$ns at 218.61460141286207 "$node_(18) setdest 242 638 12.0" 
$ns at 264.58468066737595 "$node_(18) setdest 1621 559 15.0" 
$ns at 401.3733809466955 "$node_(18) setdest 332 792 19.0" 
$ns at 471.6755207720639 "$node_(18) setdest 1009 262 1.0" 
$ns at 502.97399923137925 "$node_(18) setdest 1399 600 6.0" 
$ns at 568.2962104188516 "$node_(18) setdest 170 899 8.0" 
$ns at 607.3600405457692 "$node_(18) setdest 1916 913 8.0" 
$ns at 707.0521083866676 "$node_(18) setdest 773 663 6.0" 
$ns at 786.0453633331355 "$node_(18) setdest 2440 503 5.0" 
$ns at 829.0950911232632 "$node_(18) setdest 520 63 12.0" 
$ns at 876.1074034807001 "$node_(18) setdest 2926 865 1.0" 
$ns at 0.0 "$node_(19) setdest 2615 69 1.0" 
$ns at 30.488482779532866 "$node_(19) setdest 2224 531 1.0" 
$ns at 68.92295399255546 "$node_(19) setdest 114 303 4.0" 
$ns at 123.17726389285254 "$node_(19) setdest 82 760 11.0" 
$ns at 244.24614702630836 "$node_(19) setdest 367 781 1.0" 
$ns at 280.4010714319633 "$node_(19) setdest 2770 786 1.0" 
$ns at 310.6198245026508 "$node_(19) setdest 2523 999 10.0" 
$ns at 429.5331171929802 "$node_(19) setdest 1143 983 8.0" 
$ns at 518.338884990438 "$node_(19) setdest 801 356 13.0" 
$ns at 615.68209265914 "$node_(19) setdest 1739 622 4.0" 
$ns at 648.9617664793849 "$node_(19) setdest 8 201 14.0" 
$ns at 777.8171598954036 "$node_(19) setdest 263 88 3.0" 
$ns at 821.6393234321114 "$node_(19) setdest 501 21 15.0" 
$ns at 852.695895335267 "$node_(19) setdest 530 725 12.0" 
$ns at 890.8275385045486 "$node_(19) setdest 573 531 3.0" 
$ns at 0.0 "$node_(20) setdest 2716 683 8.0" 
$ns at 42.44715657935976 "$node_(20) setdest 1974 696 11.0" 
$ns at 77.31753891335063 "$node_(20) setdest 2509 430 7.0" 
$ns at 176.65597655247956 "$node_(20) setdest 2018 949 13.0" 
$ns at 307.0543315219824 "$node_(20) setdest 1492 804 1.0" 
$ns at 344.230003338713 "$node_(20) setdest 1515 125 7.0" 
$ns at 422.5596566609402 "$node_(20) setdest 2851 773 18.0" 
$ns at 558.5824991369374 "$node_(20) setdest 1476 882 13.0" 
$ns at 644.775183662461 "$node_(20) setdest 259 273 11.0" 
$ns at 703.8896158457275 "$node_(20) setdest 1309 628 1.0" 
$ns at 743.0775396734491 "$node_(20) setdest 1503 787 12.0" 
$ns at 789.8583846244403 "$node_(20) setdest 2968 221 20.0" 
$ns at 0.0 "$node_(21) setdest 211 550 19.0" 
$ns at 202.62908942430585 "$node_(21) setdest 2286 964 18.0" 
$ns at 296.4757810491551 "$node_(21) setdest 1771 529 1.0" 
$ns at 334.6676725260291 "$node_(21) setdest 430 670 2.0" 
$ns at 365.2185254709929 "$node_(21) setdest 266 568 1.0" 
$ns at 398.50791465783993 "$node_(21) setdest 220 802 11.0" 
$ns at 476.98336136545856 "$node_(21) setdest 2030 350 17.0" 
$ns at 526.5299566544874 "$node_(21) setdest 754 972 13.0" 
$ns at 680.8897839343522 "$node_(21) setdest 155 61 19.0" 
$ns at 834.1286819564274 "$node_(21) setdest 1573 312 1.0" 
$ns at 869.4031414462178 "$node_(21) setdest 49 907 3.0" 
$ns at 0.0 "$node_(22) setdest 1317 488 7.0" 
$ns at 72.8183906348975 "$node_(22) setdest 1870 878 17.0" 
$ns at 121.45021143314031 "$node_(22) setdest 589 370 18.0" 
$ns at 221.76274737735122 "$node_(22) setdest 2442 402 17.0" 
$ns at 403.97358730326107 "$node_(22) setdest 1505 643 5.0" 
$ns at 477.28936116959653 "$node_(22) setdest 1984 784 14.0" 
$ns at 514.2399491911825 "$node_(22) setdest 124 865 15.0" 
$ns at 645.240022604907 "$node_(22) setdest 1739 572 17.0" 
$ns at 732.331786755532 "$node_(22) setdest 1740 739 15.0" 
$ns at 865.2591668464931 "$node_(22) setdest 351 251 6.0" 
$ns at 0.0 "$node_(23) setdest 2739 636 10.0" 
$ns at 105.44677204822122 "$node_(23) setdest 576 906 15.0" 
$ns at 208.1251563805528 "$node_(23) setdest 497 621 8.0" 
$ns at 249.95318522918905 "$node_(23) setdest 2664 739 13.0" 
$ns at 301.1437845036174 "$node_(23) setdest 522 509 5.0" 
$ns at 358.2841063435972 "$node_(23) setdest 508 609 15.0" 
$ns at 440.69004443915946 "$node_(23) setdest 2816 720 12.0" 
$ns at 546.6773359276064 "$node_(23) setdest 394 960 5.0" 
$ns at 601.2966903184059 "$node_(23) setdest 1163 952 17.0" 
$ns at 749.7683812332588 "$node_(23) setdest 1944 802 12.0" 
$ns at 874.5760282125841 "$node_(23) setdest 2816 945 12.0" 
$ns at 0.0 "$node_(24) setdest 1597 635 9.0" 
$ns at 90.47006045269511 "$node_(24) setdest 1784 845 1.0" 
$ns at 128.17696841463544 "$node_(24) setdest 1703 455 5.0" 
$ns at 172.46367172088242 "$node_(24) setdest 1704 951 10.0" 
$ns at 215.15324117585357 "$node_(24) setdest 91 241 17.0" 
$ns at 363.5570837776854 "$node_(24) setdest 1996 859 5.0" 
$ns at 432.808694843077 "$node_(24) setdest 1684 567 10.0" 
$ns at 538.1582239138515 "$node_(24) setdest 2772 264 8.0" 
$ns at 619.1254830817951 "$node_(24) setdest 1506 236 15.0" 
$ns at 774.1805405300681 "$node_(24) setdest 718 955 5.0" 
$ns at 840.4222720963772 "$node_(24) setdest 173 74 16.0" 
$ns at 0.0 "$node_(25) setdest 2903 764 2.0" 
$ns at 45.88497031330916 "$node_(25) setdest 2704 285 5.0" 
$ns at 111.17090085323309 "$node_(25) setdest 2240 487 20.0" 
$ns at 233.5924852632383 "$node_(25) setdest 250 8 11.0" 
$ns at 343.9076595341853 "$node_(25) setdest 61 47 16.0" 
$ns at 466.1799512487787 "$node_(25) setdest 1067 969 3.0" 
$ns at 516.3527188014107 "$node_(25) setdest 20 427 11.0" 
$ns at 612.8740405496554 "$node_(25) setdest 837 381 15.0" 
$ns at 693.971369624454 "$node_(25) setdest 285 131 19.0" 
$ns at 748.000936202756 "$node_(25) setdest 2166 476 19.0" 
$ns at 780.8728864320192 "$node_(25) setdest 2744 198 10.0" 
$ns at 887.9788716568332 "$node_(25) setdest 1856 319 11.0" 
$ns at 0.0 "$node_(26) setdest 1677 40 12.0" 
$ns at 50.906786837527456 "$node_(26) setdest 288 795 11.0" 
$ns at 127.21972512761451 "$node_(26) setdest 2121 622 19.0" 
$ns at 307.35630689250866 "$node_(26) setdest 1006 924 9.0" 
$ns at 357.803787002002 "$node_(26) setdest 1884 747 19.0" 
$ns at 509.4051124975479 "$node_(26) setdest 2343 881 15.0" 
$ns at 579.7026779767162 "$node_(26) setdest 927 482 1.0" 
$ns at 612.9844906650237 "$node_(26) setdest 1673 383 9.0" 
$ns at 664.8248994741749 "$node_(26) setdest 579 974 10.0" 
$ns at 785.802489917201 "$node_(26) setdest 642 322 12.0" 
$ns at 841.4610072482359 "$node_(26) setdest 796 195 13.0" 
$ns at 0.0 "$node_(27) setdest 448 807 14.0" 
$ns at 76.52349922321038 "$node_(27) setdest 1435 367 12.0" 
$ns at 141.046031175755 "$node_(27) setdest 1037 987 1.0" 
$ns at 176.81190120528453 "$node_(27) setdest 2254 103 3.0" 
$ns at 223.21443436695753 "$node_(27) setdest 773 319 8.0" 
$ns at 291.3890912625126 "$node_(27) setdest 99 523 2.0" 
$ns at 323.87283479094606 "$node_(27) setdest 2949 166 8.0" 
$ns at 356.1819674559734 "$node_(27) setdest 505 869 1.0" 
$ns at 389.58321501826066 "$node_(27) setdest 210 868 17.0" 
$ns at 461.7594400434398 "$node_(27) setdest 1660 386 16.0" 
$ns at 510.93848818576663 "$node_(27) setdest 1745 693 19.0" 
$ns at 556.6835725794693 "$node_(27) setdest 2459 495 2.0" 
$ns at 588.8969056283479 "$node_(27) setdest 821 291 17.0" 
$ns at 726.3224257471268 "$node_(27) setdest 110 510 3.0" 
$ns at 765.4761300223342 "$node_(27) setdest 9 566 10.0" 
$ns at 883.5094738333577 "$node_(27) setdest 502 449 13.0" 
$ns at 0.0 "$node_(28) setdest 2186 106 7.0" 
$ns at 58.607258739716 "$node_(28) setdest 2308 673 18.0" 
$ns at 123.80835304410354 "$node_(28) setdest 2164 547 20.0" 
$ns at 310.3088353927719 "$node_(28) setdest 524 405 17.0" 
$ns at 458.9818420346877 "$node_(28) setdest 2521 551 5.0" 
$ns at 517.9550197494568 "$node_(28) setdest 1934 369 4.0" 
$ns at 572.883946783707 "$node_(28) setdest 2982 253 4.0" 
$ns at 613.3203514025822 "$node_(28) setdest 681 98 16.0" 
$ns at 645.9936929379112 "$node_(28) setdest 438 355 19.0" 
$ns at 741.5605703718219 "$node_(28) setdest 943 653 15.0" 
$ns at 883.0952766722947 "$node_(28) setdest 1450 237 3.0" 
$ns at 0.0 "$node_(29) setdest 406 792 14.0" 
$ns at 163.7018666423657 "$node_(29) setdest 1811 749 6.0" 
$ns at 201.83371097359154 "$node_(29) setdest 2010 851 11.0" 
$ns at 310.8389550172225 "$node_(29) setdest 2521 558 1.0" 
$ns at 349.1805806510317 "$node_(29) setdest 2175 858 2.0" 
$ns at 392.00142243499084 "$node_(29) setdest 266 216 16.0" 
$ns at 452.42875408256015 "$node_(29) setdest 481 641 4.0" 
$ns at 505.37269826270466 "$node_(29) setdest 2224 331 15.0" 
$ns at 633.0918249871739 "$node_(29) setdest 1507 970 2.0" 
$ns at 677.4723573149661 "$node_(29) setdest 1804 480 5.0" 
$ns at 716.9125720350726 "$node_(29) setdest 1305 982 4.0" 
$ns at 776.3174967914897 "$node_(29) setdest 2654 779 11.0" 
$ns at 847.7796770175806 "$node_(29) setdest 2714 414 3.0" 
$ns at 897.5527669387765 "$node_(29) setdest 2024 230 7.0" 
$ns at 0.0 "$node_(30) setdest 2479 424 20.0" 
$ns at 177.48753865787572 "$node_(30) setdest 1327 261 18.0" 
$ns at 373.54793312682455 "$node_(30) setdest 1902 4 11.0" 
$ns at 457.757648454437 "$node_(30) setdest 1488 87 18.0" 
$ns at 502.30912878654414 "$node_(30) setdest 475 268 4.0" 
$ns at 556.7193383405746 "$node_(30) setdest 1413 796 3.0" 
$ns at 615.870335598744 "$node_(30) setdest 1715 121 7.0" 
$ns at 679.0785074888606 "$node_(30) setdest 691 305 16.0" 
$ns at 857.2304407392152 "$node_(30) setdest 1173 96 9.0" 
$ns at 0.0 "$node_(31) setdest 2331 570 5.0" 
$ns at 78.76579571957345 "$node_(31) setdest 2319 357 2.0" 
$ns at 112.12303511929787 "$node_(31) setdest 164 713 2.0" 
$ns at 146.84207739958873 "$node_(31) setdest 1782 160 7.0" 
$ns at 219.36568772705093 "$node_(31) setdest 2221 936 11.0" 
$ns at 298.7558801555729 "$node_(31) setdest 143 274 8.0" 
$ns at 365.5399398652081 "$node_(31) setdest 1191 393 9.0" 
$ns at 407.7111974876424 "$node_(31) setdest 2265 139 1.0" 
$ns at 439.71815272077754 "$node_(31) setdest 1790 396 13.0" 
$ns at 478.9218669427314 "$node_(31) setdest 1858 782 13.0" 
$ns at 638.6700271003167 "$node_(31) setdest 2647 602 8.0" 
$ns at 671.9564718265667 "$node_(31) setdest 2754 755 18.0" 
$ns at 720.7283490900002 "$node_(31) setdest 2020 82 3.0" 
$ns at 753.1217151261712 "$node_(31) setdest 1105 623 16.0" 
$ns at 872.1040891491857 "$node_(31) setdest 1462 419 14.0" 
$ns at 0.0 "$node_(32) setdest 463 757 7.0" 
$ns at 48.48897327871073 "$node_(32) setdest 254 212 10.0" 
$ns at 126.03152635858301 "$node_(32) setdest 469 472 15.0" 
$ns at 279.535999322098 "$node_(32) setdest 1203 651 2.0" 
$ns at 329.0497859878752 "$node_(32) setdest 2600 760 16.0" 
$ns at 459.5199674656879 "$node_(32) setdest 1152 45 17.0" 
$ns at 577.5420158734865 "$node_(32) setdest 2201 150 3.0" 
$ns at 611.1683035143943 "$node_(32) setdest 276 454 2.0" 
$ns at 659.8823557544747 "$node_(32) setdest 2768 459 7.0" 
$ns at 708.1985202422345 "$node_(32) setdest 2018 817 17.0" 
$ns at 743.0203430116475 "$node_(32) setdest 2180 452 18.0" 
$ns at 870.8304003277685 "$node_(32) setdest 250 213 4.0" 
$ns at 0.0 "$node_(33) setdest 371 694 16.0" 
$ns at 52.65475749622374 "$node_(33) setdest 1995 171 17.0" 
$ns at 251.2819598097213 "$node_(33) setdest 629 87 13.0" 
$ns at 284.75476441733434 "$node_(33) setdest 2805 145 9.0" 
$ns at 345.18190907284685 "$node_(33) setdest 1510 890 19.0" 
$ns at 398.4238245730413 "$node_(33) setdest 636 572 7.0" 
$ns at 495.54696717628764 "$node_(33) setdest 1070 228 8.0" 
$ns at 592.8334289479934 "$node_(33) setdest 2798 148 2.0" 
$ns at 625.6951071580608 "$node_(33) setdest 2876 350 8.0" 
$ns at 702.1306512980233 "$node_(33) setdest 2341 211 5.0" 
$ns at 769.5665948866106 "$node_(33) setdest 2030 184 5.0" 
$ns at 800.0784317084515 "$node_(33) setdest 2947 389 13.0" 
$ns at 874.1986209464341 "$node_(33) setdest 2141 919 10.0" 
$ns at 0.0 "$node_(34) setdest 1172 895 15.0" 
$ns at 173.07578870710591 "$node_(34) setdest 993 676 6.0" 
$ns at 212.45524419394337 "$node_(34) setdest 644 123 1.0" 
$ns at 247.1185362190257 "$node_(34) setdest 344 503 6.0" 
$ns at 315.38997786939444 "$node_(34) setdest 1530 431 6.0" 
$ns at 390.06625992733666 "$node_(34) setdest 93 233 13.0" 
$ns at 455.2366932805565 "$node_(34) setdest 2386 261 6.0" 
$ns at 488.99268129718166 "$node_(34) setdest 770 965 20.0" 
$ns at 689.9120502897858 "$node_(34) setdest 1212 993 8.0" 
$ns at 757.9010223161067 "$node_(34) setdest 59 196 16.0" 
$ns at 0.0 "$node_(35) setdest 1320 166 6.0" 
$ns at 36.58436744551209 "$node_(35) setdest 2833 866 15.0" 
$ns at 186.80847638447904 "$node_(35) setdest 1332 979 1.0" 
$ns at 222.69207676428783 "$node_(35) setdest 1902 839 16.0" 
$ns at 303.5515700766034 "$node_(35) setdest 421 194 16.0" 
$ns at 337.7816728811333 "$node_(35) setdest 1448 587 19.0" 
$ns at 514.663049146201 "$node_(35) setdest 2617 857 7.0" 
$ns at 567.4785191747354 "$node_(35) setdest 2854 102 14.0" 
$ns at 734.0544413107086 "$node_(35) setdest 1781 468 1.0" 
$ns at 771.1905271760883 "$node_(35) setdest 2401 299 16.0" 
$ns at 0.0 "$node_(36) setdest 1575 498 15.0" 
$ns at 140.02167683192212 "$node_(36) setdest 41 437 7.0" 
$ns at 175.0790528045827 "$node_(36) setdest 2528 398 17.0" 
$ns at 230.6201994978245 "$node_(36) setdest 1214 311 7.0" 
$ns at 276.06503833802253 "$node_(36) setdest 31 498 1.0" 
$ns at 310.7718085448496 "$node_(36) setdest 418 267 3.0" 
$ns at 352.97334228084947 "$node_(36) setdest 1856 432 3.0" 
$ns at 384.17469902709564 "$node_(36) setdest 2011 268 18.0" 
$ns at 474.72420666526307 "$node_(36) setdest 2534 990 12.0" 
$ns at 615.1900880613264 "$node_(36) setdest 2439 563 17.0" 
$ns at 681.2477278748868 "$node_(36) setdest 2684 546 13.0" 
$ns at 712.3993408312614 "$node_(36) setdest 2875 719 18.0" 
$ns at 748.1517317362711 "$node_(36) setdest 138 440 4.0" 
$ns at 782.1415631349904 "$node_(36) setdest 1973 24 14.0" 
$ns at 869.1373445050019 "$node_(36) setdest 436 978 11.0" 
$ns at 0.0 "$node_(37) setdest 202 550 16.0" 
$ns at 106.74600214922565 "$node_(37) setdest 2054 933 12.0" 
$ns at 241.10342331841264 "$node_(37) setdest 2976 380 14.0" 
$ns at 379.3115826025392 "$node_(37) setdest 2434 693 1.0" 
$ns at 412.6868194323463 "$node_(37) setdest 1551 776 6.0" 
$ns at 446.05553180938165 "$node_(37) setdest 2669 452 2.0" 
$ns at 495.0199749768508 "$node_(37) setdest 1394 305 16.0" 
$ns at 613.9541321913796 "$node_(37) setdest 1424 92 8.0" 
$ns at 647.7482228309185 "$node_(37) setdest 494 196 11.0" 
$ns at 688.2499312682789 "$node_(37) setdest 2440 639 4.0" 
$ns at 727.1579914004523 "$node_(37) setdest 829 441 11.0" 
$ns at 866.7000888168566 "$node_(37) setdest 711 456 6.0" 
$ns at 0.0 "$node_(38) setdest 1956 416 5.0" 
$ns at 70.89922766391298 "$node_(38) setdest 159 547 11.0" 
$ns at 195.8283049690557 "$node_(38) setdest 1436 39 15.0" 
$ns at 267.9407983595745 "$node_(38) setdest 2425 631 2.0" 
$ns at 298.5529304153867 "$node_(38) setdest 556 733 17.0" 
$ns at 487.49681354296456 "$node_(38) setdest 85 877 5.0" 
$ns at 554.2917907036875 "$node_(38) setdest 2576 713 2.0" 
$ns at 592.8184532326211 "$node_(38) setdest 2403 444 15.0" 
$ns at 761.8962603564637 "$node_(38) setdest 442 377 4.0" 
$ns at 809.0577740304302 "$node_(38) setdest 2453 212 20.0" 
$ns at 0.0 "$node_(39) setdest 2711 801 5.0" 
$ns at 59.10391042765751 "$node_(39) setdest 2194 370 18.0" 
$ns at 152.21059056038214 "$node_(39) setdest 121 627 13.0" 
$ns at 183.56214465363544 "$node_(39) setdest 2850 729 7.0" 
$ns at 264.10564869469874 "$node_(39) setdest 1045 849 16.0" 
$ns at 336.155175880129 "$node_(39) setdest 679 927 1.0" 
$ns at 371.2006160269339 "$node_(39) setdest 786 280 12.0" 
$ns at 491.0542797424526 "$node_(39) setdest 1963 905 20.0" 
$ns at 719.5089935743375 "$node_(39) setdest 2414 701 14.0" 
$ns at 750.3578746264548 "$node_(39) setdest 2826 310 6.0" 
$ns at 814.9664025966744 "$node_(39) setdest 642 989 2.0" 
$ns at 852.5913945180769 "$node_(39) setdest 200 710 2.0" 
$ns at 897.450909353526 "$node_(39) setdest 2916 706 5.0" 
$ns at 0.0 "$node_(40) setdest 2050 771 1.0" 
$ns at 39.44441001194207 "$node_(40) setdest 723 963 9.0" 
$ns at 141.06049003705203 "$node_(40) setdest 2677 789 11.0" 
$ns at 178.32348657542417 "$node_(40) setdest 2796 535 1.0" 
$ns at 217.00936314371694 "$node_(40) setdest 705 224 8.0" 
$ns at 281.3926490144859 "$node_(40) setdest 2711 531 10.0" 
$ns at 330.429415725946 "$node_(40) setdest 83 129 5.0" 
$ns at 388.0241236551358 "$node_(40) setdest 69 117 7.0" 
$ns at 421.7929533510646 "$node_(40) setdest 1193 607 2.0" 
$ns at 453.9389382549985 "$node_(40) setdest 243 68 20.0" 
$ns at 565.6588436277448 "$node_(40) setdest 1911 721 9.0" 
$ns at 668.4978201701049 "$node_(40) setdest 2392 178 20.0" 
$ns at 844.25934029055 "$node_(40) setdest 2195 462 14.0" 
$ns at 896.809132770192 "$node_(40) setdest 1221 780 14.0" 
$ns at 0.0 "$node_(41) setdest 563 704 6.0" 
$ns at 47.14802729475447 "$node_(41) setdest 1686 909 3.0" 
$ns at 86.37652265470709 "$node_(41) setdest 1522 267 20.0" 
$ns at 175.02202509377597 "$node_(41) setdest 1619 867 11.0" 
$ns at 222.33480108923914 "$node_(41) setdest 2821 497 18.0" 
$ns at 412.32064029281037 "$node_(41) setdest 2995 229 17.0" 
$ns at 461.4945223917638 "$node_(41) setdest 1087 1 15.0" 
$ns at 518.9524945505751 "$node_(41) setdest 2278 529 13.0" 
$ns at 559.142757211336 "$node_(41) setdest 1200 427 1.0" 
$ns at 598.221259053749 "$node_(41) setdest 1102 177 13.0" 
$ns at 629.9219347143115 "$node_(41) setdest 501 450 15.0" 
$ns at 734.4574080653435 "$node_(41) setdest 1206 352 18.0" 
$ns at 855.2780776703422 "$node_(41) setdest 658 336 5.0" 
$ns at 0.0 "$node_(42) setdest 2381 908 10.0" 
$ns at 78.7131957098675 "$node_(42) setdest 1789 748 15.0" 
$ns at 251.04945924831637 "$node_(42) setdest 1865 548 5.0" 
$ns at 315.2987003094271 "$node_(42) setdest 186 680 15.0" 
$ns at 480.26002931052165 "$node_(42) setdest 405 804 19.0" 
$ns at 626.7013925916883 "$node_(42) setdest 2721 658 7.0" 
$ns at 720.5732455197605 "$node_(42) setdest 2967 563 15.0" 
$ns at 782.995016582791 "$node_(42) setdest 2772 619 7.0" 
$ns at 873.9558812674624 "$node_(42) setdest 2789 201 20.0" 
$ns at 0.0 "$node_(43) setdest 1275 92 10.0" 
$ns at 38.2446373300982 "$node_(43) setdest 1253 545 12.0" 
$ns at 141.1456090059765 "$node_(43) setdest 1223 593 7.0" 
$ns at 185.43270549669705 "$node_(43) setdest 2789 227 14.0" 
$ns at 291.6304363131421 "$node_(43) setdest 712 368 17.0" 
$ns at 438.6492945157463 "$node_(43) setdest 2773 174 5.0" 
$ns at 469.79385309644795 "$node_(43) setdest 1374 883 15.0" 
$ns at 568.311745743255 "$node_(43) setdest 2141 255 9.0" 
$ns at 631.4165340226102 "$node_(43) setdest 1778 705 13.0" 
$ns at 759.9569618202562 "$node_(43) setdest 2167 366 1.0" 
$ns at 796.9330229626352 "$node_(43) setdest 155 666 1.0" 
$ns at 831.1016374138034 "$node_(43) setdest 2649 465 15.0" 
$ns at 0.0 "$node_(44) setdest 1520 459 14.0" 
$ns at 160.5159608975266 "$node_(44) setdest 433 324 3.0" 
$ns at 206.45751325394968 "$node_(44) setdest 1039 55 8.0" 
$ns at 246.8857163550008 "$node_(44) setdest 1019 26 13.0" 
$ns at 377.34861851915224 "$node_(44) setdest 232 593 1.0" 
$ns at 410.6518574164961 "$node_(44) setdest 2698 464 20.0" 
$ns at 512.0694329240346 "$node_(44) setdest 2352 628 13.0" 
$ns at 571.9236573947759 "$node_(44) setdest 437 383 1.0" 
$ns at 611.5933559299566 "$node_(44) setdest 18 890 3.0" 
$ns at 670.5723662174651 "$node_(44) setdest 483 701 20.0" 
$ns at 777.6104559412244 "$node_(44) setdest 1963 944 10.0" 
$ns at 813.8663621987926 "$node_(44) setdest 1394 168 5.0" 
$ns at 876.9960724398321 "$node_(44) setdest 2470 399 7.0" 
$ns at 0.0 "$node_(45) setdest 2964 598 15.0" 
$ns at 78.6082068540625 "$node_(45) setdest 1840 552 6.0" 
$ns at 115.93784116285734 "$node_(45) setdest 260 215 14.0" 
$ns at 208.14628642175165 "$node_(45) setdest 982 626 6.0" 
$ns at 287.96065112060944 "$node_(45) setdest 1729 876 10.0" 
$ns at 385.5586045817206 "$node_(45) setdest 1974 981 11.0" 
$ns at 446.0738419685895 "$node_(45) setdest 98 189 15.0" 
$ns at 560.229427141186 "$node_(45) setdest 2166 956 5.0" 
$ns at 591.0081481090378 "$node_(45) setdest 2528 793 8.0" 
$ns at 677.7307911379773 "$node_(45) setdest 183 223 16.0" 
$ns at 756.4598744539558 "$node_(45) setdest 2232 335 11.0" 
$ns at 860.4715063220051 "$node_(45) setdest 2907 816 19.0" 
$ns at 898.0149396577915 "$node_(45) setdest 2529 883 8.0" 
$ns at 0.0 "$node_(46) setdest 2282 205 18.0" 
$ns at 69.47643901253656 "$node_(46) setdest 1051 834 9.0" 
$ns at 101.65949074921782 "$node_(46) setdest 2528 84 6.0" 
$ns at 186.19838440086943 "$node_(46) setdest 1556 553 9.0" 
$ns at 241.4980261319578 "$node_(46) setdest 2118 747 1.0" 
$ns at 280.59636422175396 "$node_(46) setdest 1572 276 15.0" 
$ns at 392.0421947467642 "$node_(46) setdest 579 218 1.0" 
$ns at 427.9195168185032 "$node_(46) setdest 835 54 5.0" 
$ns at 477.546424384502 "$node_(46) setdest 1991 507 4.0" 
$ns at 530.3645005969099 "$node_(46) setdest 1235 742 14.0" 
$ns at 611.3743978076639 "$node_(46) setdest 2747 647 15.0" 
$ns at 681.8552580753828 "$node_(46) setdest 2731 310 3.0" 
$ns at 711.9768179089182 "$node_(46) setdest 2931 418 1.0" 
$ns at 746.3389375699795 "$node_(46) setdest 458 4 11.0" 
$ns at 807.3414883587902 "$node_(46) setdest 390 877 3.0" 
$ns at 843.3815950027914 "$node_(46) setdest 981 105 15.0" 
$ns at 0.0 "$node_(47) setdest 2356 113 8.0" 
$ns at 55.45413247591702 "$node_(47) setdest 1423 334 11.0" 
$ns at 153.98923069332642 "$node_(47) setdest 187 853 13.0" 
$ns at 255.91514803945677 "$node_(47) setdest 1921 143 11.0" 
$ns at 376.38642111389595 "$node_(47) setdest 594 833 6.0" 
$ns at 432.7574580044966 "$node_(47) setdest 2625 433 13.0" 
$ns at 469.4768417998607 "$node_(47) setdest 412 51 5.0" 
$ns at 541.7787406825156 "$node_(47) setdest 217 463 5.0" 
$ns at 609.261705307915 "$node_(47) setdest 2785 329 13.0" 
$ns at 648.6717806652069 "$node_(47) setdest 2651 962 9.0" 
$ns at 750.2460705139291 "$node_(47) setdest 2331 805 9.0" 
$ns at 818.3995806207253 "$node_(47) setdest 584 724 7.0" 
$ns at 897.2528854654988 "$node_(47) setdest 2644 253 19.0" 
$ns at 0.0 "$node_(48) setdest 2717 200 9.0" 
$ns at 101.87038166398588 "$node_(48) setdest 1213 387 18.0" 
$ns at 218.40608026177554 "$node_(48) setdest 4 851 6.0" 
$ns at 282.21915602045186 "$node_(48) setdest 602 529 1.0" 
$ns at 318.548205809132 "$node_(48) setdest 445 302 4.0" 
$ns at 360.6617818224298 "$node_(48) setdest 474 303 14.0" 
$ns at 409.7227890210704 "$node_(48) setdest 939 538 11.0" 
$ns at 538.1739670819619 "$node_(48) setdest 816 223 6.0" 
$ns at 585.7263091166169 "$node_(48) setdest 387 684 16.0" 
$ns at 671.877025528323 "$node_(48) setdest 2428 350 11.0" 
$ns at 708.7721096609015 "$node_(48) setdest 44 126 15.0" 
$ns at 783.4991318471175 "$node_(48) setdest 549 392 19.0" 
$ns at 0.0 "$node_(49) setdest 798 4 7.0" 
$ns at 80.26479668433521 "$node_(49) setdest 1171 895 15.0" 
$ns at 134.82528606906416 "$node_(49) setdest 1872 332 14.0" 
$ns at 237.2964355638848 "$node_(49) setdest 423 429 8.0" 
$ns at 289.16696041878475 "$node_(49) setdest 148 276 17.0" 
$ns at 449.79252378964384 "$node_(49) setdest 78 900 18.0" 
$ns at 624.1857192400502 "$node_(49) setdest 2076 353 1.0" 
$ns at 661.122695443621 "$node_(49) setdest 1045 392 17.0" 
$ns at 772.0655712419974 "$node_(49) setdest 892 581 15.0" 
$ns at 0.0 "$node_(50) setdest 1427 182 5.0" 
$ns at 33.99175452080726 "$node_(50) setdest 1606 826 2.0" 
$ns at 69.89267824461476 "$node_(50) setdest 2493 819 7.0" 
$ns at 108.86450726905109 "$node_(50) setdest 2972 900 4.0" 
$ns at 176.47022296850002 "$node_(50) setdest 2639 414 19.0" 
$ns at 333.3265703662933 "$node_(50) setdest 2408 148 9.0" 
$ns at 383.7949656630737 "$node_(50) setdest 2192 538 14.0" 
$ns at 541.8381701965368 "$node_(50) setdest 578 559 2.0" 
$ns at 579.9394330637502 "$node_(50) setdest 644 364 5.0" 
$ns at 644.2809238383913 "$node_(50) setdest 1108 672 10.0" 
$ns at 736.0713572030718 "$node_(50) setdest 1644 961 6.0" 
$ns at 816.2612549653697 "$node_(50) setdest 1643 785 7.0" 
$ns at 876.6271806481202 "$node_(50) setdest 2862 869 20.0" 
$ns at 177.24885692623707 "$node_(51) setdest 2535 365 3.0" 
$ns at 217.91778172411912 "$node_(51) setdest 2598 874 6.0" 
$ns at 283.1172301779557 "$node_(51) setdest 1313 50 5.0" 
$ns at 332.92844707619514 "$node_(51) setdest 2257 661 17.0" 
$ns at 503.10265405474115 "$node_(51) setdest 2720 664 1.0" 
$ns at 541.5013439876741 "$node_(51) setdest 856 481 7.0" 
$ns at 613.0747093794171 "$node_(51) setdest 1341 265 15.0" 
$ns at 676.0308108996478 "$node_(51) setdest 541 369 2.0" 
$ns at 716.4600789161914 "$node_(51) setdest 2564 169 4.0" 
$ns at 778.8386181627758 "$node_(51) setdest 1562 512 10.0" 
$ns at 878.1220825908608 "$node_(51) setdest 1462 301 15.0" 
$ns at 189.26556814408173 "$node_(52) setdest 2069 136 11.0" 
$ns at 317.2328914020449 "$node_(52) setdest 835 301 3.0" 
$ns at 367.55043869590867 "$node_(52) setdest 160 249 9.0" 
$ns at 408.5725739570474 "$node_(52) setdest 2972 501 1.0" 
$ns at 439.8779593805597 "$node_(52) setdest 675 409 15.0" 
$ns at 567.813965024055 "$node_(52) setdest 2848 937 16.0" 
$ns at 732.7133810692052 "$node_(52) setdest 781 928 6.0" 
$ns at 789.5599251071972 "$node_(52) setdest 188 603 16.0" 
$ns at 167.1311871213606 "$node_(53) setdest 2210 594 12.0" 
$ns at 213.7492529951187 "$node_(53) setdest 1899 87 3.0" 
$ns at 254.794457180647 "$node_(53) setdest 428 857 13.0" 
$ns at 330.76706822884137 "$node_(53) setdest 1581 669 9.0" 
$ns at 361.10936413013246 "$node_(53) setdest 1484 251 17.0" 
$ns at 432.62674935045027 "$node_(53) setdest 1880 412 9.0" 
$ns at 548.7874617874297 "$node_(53) setdest 665 768 15.0" 
$ns at 665.8267305648137 "$node_(53) setdest 517 892 17.0" 
$ns at 724.324161618859 "$node_(53) setdest 1734 587 8.0" 
$ns at 757.2927451062263 "$node_(53) setdest 2414 993 1.0" 
$ns at 788.0976483209758 "$node_(53) setdest 1842 395 17.0" 
$ns at 893.8828132158475 "$node_(53) setdest 2411 935 20.0" 
$ns at 194.2603542289068 "$node_(54) setdest 1074 378 7.0" 
$ns at 227.85559571855424 "$node_(54) setdest 874 217 14.0" 
$ns at 386.6727141694691 "$node_(54) setdest 1087 42 7.0" 
$ns at 428.98444042702044 "$node_(54) setdest 2002 59 4.0" 
$ns at 494.40103312984115 "$node_(54) setdest 1144 901 9.0" 
$ns at 600.2120002690956 "$node_(54) setdest 1377 359 8.0" 
$ns at 694.8716208604325 "$node_(54) setdest 358 221 8.0" 
$ns at 786.1396240735831 "$node_(54) setdest 1711 283 19.0" 
$ns at 824.6612362312693 "$node_(54) setdest 641 607 9.0" 
$ns at 303.99966113762247 "$node_(55) setdest 96 369 10.0" 
$ns at 391.61191559404983 "$node_(55) setdest 2939 72 16.0" 
$ns at 575.2336495897241 "$node_(55) setdest 1136 106 4.0" 
$ns at 609.1565608598089 "$node_(55) setdest 214 423 17.0" 
$ns at 699.9337262867431 "$node_(55) setdest 1616 427 16.0" 
$ns at 831.5808072670897 "$node_(55) setdest 2158 130 2.0" 
$ns at 876.3064388016331 "$node_(55) setdest 1082 255 15.0" 
$ns at 169.32964941492793 "$node_(56) setdest 791 961 20.0" 
$ns at 209.09213870085367 "$node_(56) setdest 91 518 11.0" 
$ns at 313.8373082139065 "$node_(56) setdest 414 598 11.0" 
$ns at 430.345997574184 "$node_(56) setdest 214 958 11.0" 
$ns at 567.1691463955231 "$node_(56) setdest 2034 305 5.0" 
$ns at 626.8644559921796 "$node_(56) setdest 1817 782 12.0" 
$ns at 658.6409633956587 "$node_(56) setdest 2412 354 20.0" 
$ns at 733.7632513694447 "$node_(56) setdest 580 195 3.0" 
$ns at 771.6629141225401 "$node_(56) setdest 932 668 10.0" 
$ns at 874.5759595584424 "$node_(56) setdest 1183 121 10.0" 
$ns at 227.964596222833 "$node_(57) setdest 1631 446 10.0" 
$ns at 266.2403394611437 "$node_(57) setdest 2591 596 7.0" 
$ns at 328.4512700360109 "$node_(57) setdest 2958 918 18.0" 
$ns at 422.2223362870214 "$node_(57) setdest 1099 260 16.0" 
$ns at 609.4974066705087 "$node_(57) setdest 1731 869 1.0" 
$ns at 641.1449028475308 "$node_(57) setdest 2052 901 18.0" 
$ns at 749.0604375379156 "$node_(57) setdest 2938 257 6.0" 
$ns at 795.5563509069591 "$node_(57) setdest 1982 934 10.0" 
$ns at 867.1022612872677 "$node_(57) setdest 1948 439 5.0" 
$ns at 236.3689080567031 "$node_(58) setdest 615 907 10.0" 
$ns at 355.5205001649263 "$node_(58) setdest 2532 482 18.0" 
$ns at 546.5641564231769 "$node_(58) setdest 1044 567 3.0" 
$ns at 589.7405609254378 "$node_(58) setdest 1406 983 9.0" 
$ns at 639.9888082617014 "$node_(58) setdest 2105 355 18.0" 
$ns at 740.8579168637763 "$node_(58) setdest 2931 305 3.0" 
$ns at 789.160228176917 "$node_(58) setdest 2023 497 4.0" 
$ns at 825.74466455814 "$node_(58) setdest 2960 266 14.0" 
$ns at 857.8170877030866 "$node_(58) setdest 646 595 3.0" 
$ns at 186.11338077083025 "$node_(59) setdest 9 450 6.0" 
$ns at 256.10006192029607 "$node_(59) setdest 2528 80 8.0" 
$ns at 349.3300704578122 "$node_(59) setdest 2627 718 17.0" 
$ns at 545.09566724119 "$node_(59) setdest 1232 48 4.0" 
$ns at 593.4793692760651 "$node_(59) setdest 1080 287 15.0" 
$ns at 731.7345908817078 "$node_(59) setdest 1022 895 19.0" 
$ns at 842.4048840310595 "$node_(59) setdest 194 896 17.0" 
$ns at 230.6269454435996 "$node_(60) setdest 1159 650 19.0" 
$ns at 328.5194863289511 "$node_(60) setdest 1451 569 5.0" 
$ns at 382.67286929407277 "$node_(60) setdest 1246 47 4.0" 
$ns at 418.0548581857645 "$node_(60) setdest 2258 347 11.0" 
$ns at 529.7142621298696 "$node_(60) setdest 1480 116 5.0" 
$ns at 585.2783108654977 "$node_(60) setdest 1500 68 17.0" 
$ns at 730.6649435301501 "$node_(60) setdest 488 39 4.0" 
$ns at 792.4426027473223 "$node_(60) setdest 1617 542 7.0" 
$ns at 846.5603114964462 "$node_(60) setdest 2448 270 18.0" 
$ns at 181.63343208458681 "$node_(61) setdest 2691 581 17.0" 
$ns at 342.5879881033917 "$node_(61) setdest 69 381 12.0" 
$ns at 375.79130911526386 "$node_(61) setdest 633 645 12.0" 
$ns at 496.23562679859646 "$node_(61) setdest 1444 563 11.0" 
$ns at 585.4075153788654 "$node_(61) setdest 2428 129 13.0" 
$ns at 674.4669308632318 "$node_(61) setdest 1694 85 10.0" 
$ns at 753.0654117528616 "$node_(61) setdest 1086 750 17.0" 
$ns at 839.2236991078424 "$node_(61) setdest 25 371 13.0" 
$ns at 179.75039823892422 "$node_(62) setdest 1363 217 18.0" 
$ns at 368.13131588359533 "$node_(62) setdest 1518 546 11.0" 
$ns at 503.62092814181364 "$node_(62) setdest 593 445 5.0" 
$ns at 572.2084511994063 "$node_(62) setdest 597 338 4.0" 
$ns at 629.2893269554529 "$node_(62) setdest 41 404 8.0" 
$ns at 668.0774966823648 "$node_(62) setdest 1344 82 9.0" 
$ns at 750.5100355855583 "$node_(62) setdest 1644 781 2.0" 
$ns at 786.9247190214484 "$node_(62) setdest 423 187 2.0" 
$ns at 830.3344754388006 "$node_(62) setdest 2216 204 15.0" 
$ns at 861.1593213002832 "$node_(62) setdest 317 375 5.0" 
$ns at 896.5476765674873 "$node_(62) setdest 685 542 6.0" 
$ns at 165.68189584799592 "$node_(63) setdest 1199 494 1.0" 
$ns at 199.53805404029652 "$node_(63) setdest 628 970 1.0" 
$ns at 237.71408440471572 "$node_(63) setdest 1475 701 14.0" 
$ns at 391.29693704077795 "$node_(63) setdest 2994 555 6.0" 
$ns at 477.06791370946956 "$node_(63) setdest 1742 806 20.0" 
$ns at 523.6774541744948 "$node_(63) setdest 595 550 19.0" 
$ns at 623.4436207641984 "$node_(63) setdest 1286 937 12.0" 
$ns at 654.9188704630567 "$node_(63) setdest 1494 126 3.0" 
$ns at 713.5243717671317 "$node_(63) setdest 732 473 11.0" 
$ns at 814.6777581999547 "$node_(63) setdest 2253 362 13.0" 
$ns at 858.7514432176908 "$node_(63) setdest 1854 997 2.0" 
$ns at 899.0707519367371 "$node_(63) setdest 2837 675 9.0" 
$ns at 195.64189992767177 "$node_(64) setdest 513 507 5.0" 
$ns at 263.69144074797805 "$node_(64) setdest 479 298 6.0" 
$ns at 294.6390199312516 "$node_(64) setdest 1589 478 18.0" 
$ns at 428.0730841090656 "$node_(64) setdest 1187 487 5.0" 
$ns at 481.227389691858 "$node_(64) setdest 185 179 17.0" 
$ns at 667.1720796587124 "$node_(64) setdest 2049 600 4.0" 
$ns at 733.2589815316944 "$node_(64) setdest 2524 623 19.0" 
$ns at 214.21888827810707 "$node_(65) setdest 1297 443 11.0" 
$ns at 254.6853991158932 "$node_(65) setdest 1093 765 8.0" 
$ns at 328.49317061553484 "$node_(65) setdest 461 895 14.0" 
$ns at 493.17688374975427 "$node_(65) setdest 2514 586 13.0" 
$ns at 612.0406408841834 "$node_(65) setdest 1664 427 14.0" 
$ns at 725.5992680906201 "$node_(65) setdest 749 637 18.0" 
$ns at 768.2447951411245 "$node_(65) setdest 205 826 11.0" 
$ns at 831.6960526353976 "$node_(65) setdest 522 539 15.0" 
$ns at 209.21757947930192 "$node_(66) setdest 1847 24 7.0" 
$ns at 304.8051033910605 "$node_(66) setdest 1161 61 5.0" 
$ns at 335.2911795120483 "$node_(66) setdest 766 988 19.0" 
$ns at 487.2278026733413 "$node_(66) setdest 164 426 11.0" 
$ns at 622.0808526880908 "$node_(66) setdest 2526 520 14.0" 
$ns at 678.382841506545 "$node_(66) setdest 2597 569 12.0" 
$ns at 754.3758482936385 "$node_(66) setdest 2678 154 17.0" 
$ns at 843.0959397056814 "$node_(66) setdest 2905 208 9.0" 
$ns at 275.1705674500893 "$node_(67) setdest 1215 610 18.0" 
$ns at 309.9930304600005 "$node_(67) setdest 2297 612 1.0" 
$ns at 347.3291731704887 "$node_(67) setdest 2729 63 14.0" 
$ns at 492.79606521670524 "$node_(67) setdest 1604 251 9.0" 
$ns at 586.4896177455926 "$node_(67) setdest 2180 247 13.0" 
$ns at 627.7697002886755 "$node_(67) setdest 1313 567 11.0" 
$ns at 691.4710526258425 "$node_(67) setdest 417 489 13.0" 
$ns at 845.6086135142361 "$node_(67) setdest 180 125 2.0" 
$ns at 893.9650293729221 "$node_(67) setdest 2123 927 13.0" 
$ns at 267.8481161952024 "$node_(68) setdest 1607 500 19.0" 
$ns at 382.7592793879938 "$node_(68) setdest 1594 570 7.0" 
$ns at 420.1632713696638 "$node_(68) setdest 1190 587 10.0" 
$ns at 509.4574908158341 "$node_(68) setdest 2284 635 12.0" 
$ns at 575.0786400314826 "$node_(68) setdest 1919 73 6.0" 
$ns at 606.3698819712014 "$node_(68) setdest 1953 53 19.0" 
$ns at 656.5490846447072 "$node_(68) setdest 1794 454 3.0" 
$ns at 694.0701624623105 "$node_(68) setdest 196 158 6.0" 
$ns at 754.8242915062714 "$node_(68) setdest 2562 90 18.0" 
$ns at 191.3525996664768 "$node_(69) setdest 1753 187 4.0" 
$ns at 226.67697130232153 "$node_(69) setdest 969 617 14.0" 
$ns at 296.3735668676867 "$node_(69) setdest 2583 34 10.0" 
$ns at 415.775202678902 "$node_(69) setdest 817 440 19.0" 
$ns at 559.3146883965157 "$node_(69) setdest 1219 290 3.0" 
$ns at 602.6262793086989 "$node_(69) setdest 236 907 20.0" 
$ns at 666.7028679238521 "$node_(69) setdest 2741 177 17.0" 
$ns at 857.9325738776711 "$node_(69) setdest 840 141 6.0" 
$ns at 181.9425141184115 "$node_(70) setdest 285 504 14.0" 
$ns at 224.9878333234996 "$node_(70) setdest 31 857 6.0" 
$ns at 277.87255038067855 "$node_(70) setdest 557 79 9.0" 
$ns at 372.9234440333657 "$node_(70) setdest 929 219 20.0" 
$ns at 540.2315047486769 "$node_(70) setdest 141 890 16.0" 
$ns at 727.5383999357546 "$node_(70) setdest 2872 969 4.0" 
$ns at 771.3649483945017 "$node_(70) setdest 2711 857 7.0" 
$ns at 854.703649259635 "$node_(70) setdest 1554 587 5.0" 
$ns at 894.7773663845887 "$node_(70) setdest 276 434 16.0" 
$ns at 175.72754199510325 "$node_(71) setdest 1919 626 17.0" 
$ns at 205.92166392929576 "$node_(71) setdest 2781 85 20.0" 
$ns at 240.47331202354238 "$node_(71) setdest 2051 586 6.0" 
$ns at 276.5126420537082 "$node_(71) setdest 659 726 5.0" 
$ns at 316.8343255763099 "$node_(71) setdest 283 359 12.0" 
$ns at 433.1550927075149 "$node_(71) setdest 2560 477 8.0" 
$ns at 529.1519199671934 "$node_(71) setdest 1448 750 5.0" 
$ns at 585.00879940112 "$node_(71) setdest 1354 454 6.0" 
$ns at 624.0989241405819 "$node_(71) setdest 2442 859 7.0" 
$ns at 675.700149224335 "$node_(71) setdest 1064 690 1.0" 
$ns at 707.6033672467938 "$node_(71) setdest 455 914 4.0" 
$ns at 773.4321989494146 "$node_(71) setdest 834 944 16.0" 
$ns at 246.25584960371708 "$node_(72) setdest 2792 359 1.0" 
$ns at 278.1787994495512 "$node_(72) setdest 1739 405 17.0" 
$ns at 396.3891508285161 "$node_(72) setdest 2247 481 8.0" 
$ns at 504.84936057125026 "$node_(72) setdest 736 849 16.0" 
$ns at 570.5463253627053 "$node_(72) setdest 1011 926 1.0" 
$ns at 609.7407020088616 "$node_(72) setdest 1041 845 18.0" 
$ns at 808.17682696779 "$node_(72) setdest 779 103 1.0" 
$ns at 847.4027524743542 "$node_(72) setdest 1068 772 15.0" 
$ns at 189.16426522665753 "$node_(73) setdest 330 326 5.0" 
$ns at 262.93929749219296 "$node_(73) setdest 2993 465 13.0" 
$ns at 399.9445677591265 "$node_(73) setdest 845 409 6.0" 
$ns at 469.85804271413775 "$node_(73) setdest 2329 623 2.0" 
$ns at 502.3497130265496 "$node_(73) setdest 965 239 2.0" 
$ns at 536.3639575068786 "$node_(73) setdest 1075 909 3.0" 
$ns at 588.6179732839298 "$node_(73) setdest 62 821 9.0" 
$ns at 670.4409890885879 "$node_(73) setdest 1371 359 16.0" 
$ns at 742.5882544670899 "$node_(73) setdest 1063 209 16.0" 
$ns at 892.7911336960319 "$node_(73) setdest 2365 90 16.0" 
$ns at 181.69879123410522 "$node_(74) setdest 1498 674 1.0" 
$ns at 211.9967342107335 "$node_(74) setdest 2530 69 20.0" 
$ns at 393.38316274926393 "$node_(74) setdest 314 251 3.0" 
$ns at 443.3308630942843 "$node_(74) setdest 1136 391 2.0" 
$ns at 489.60522173394486 "$node_(74) setdest 510 396 13.0" 
$ns at 562.791199100835 "$node_(74) setdest 145 525 10.0" 
$ns at 668.7803853963201 "$node_(74) setdest 697 12 15.0" 
$ns at 817.0392564325019 "$node_(74) setdest 1360 717 17.0" 
$ns at 398.7310308770026 "$node_(75) setdest 227 47 16.0" 
$ns at 519.9584056822148 "$node_(75) setdest 1169 636 11.0" 
$ns at 600.3634072508319 "$node_(75) setdest 951 441 7.0" 
$ns at 646.3805135932047 "$node_(75) setdest 2755 508 4.0" 
$ns at 691.5066510855216 "$node_(75) setdest 1539 218 4.0" 
$ns at 741.9134169472436 "$node_(75) setdest 241 196 10.0" 
$ns at 865.1459166479248 "$node_(75) setdest 181 372 1.0" 
$ns at 895.8751354464052 "$node_(75) setdest 1233 245 5.0" 
$ns at 378.66410306158144 "$node_(76) setdest 525 937 8.0" 
$ns at 426.74911009663384 "$node_(76) setdest 2847 901 13.0" 
$ns at 522.8130108594333 "$node_(76) setdest 2325 29 9.0" 
$ns at 566.4325050396014 "$node_(76) setdest 1787 577 12.0" 
$ns at 681.133196014108 "$node_(76) setdest 2392 744 4.0" 
$ns at 737.0110504075247 "$node_(76) setdest 944 492 10.0" 
$ns at 798.8370078395048 "$node_(76) setdest 2962 517 16.0" 
$ns at 337.76041671820144 "$node_(77) setdest 923 848 8.0" 
$ns at 438.93313002302557 "$node_(77) setdest 1170 135 19.0" 
$ns at 529.5755557193577 "$node_(77) setdest 235 57 13.0" 
$ns at 561.7075664052641 "$node_(77) setdest 2062 667 20.0" 
$ns at 670.6518993478754 "$node_(77) setdest 675 853 17.0" 
$ns at 768.9154721777721 "$node_(77) setdest 2507 531 18.0" 
$ns at 844.2937379490158 "$node_(77) setdest 629 958 6.0" 
$ns at 337.2840866303794 "$node_(78) setdest 133 714 9.0" 
$ns at 455.1821284967478 "$node_(78) setdest 425 317 6.0" 
$ns at 511.5826476376112 "$node_(78) setdest 701 434 1.0" 
$ns at 547.9934388761701 "$node_(78) setdest 918 200 11.0" 
$ns at 631.7440432728457 "$node_(78) setdest 69 391 9.0" 
$ns at 661.9229728427589 "$node_(78) setdest 2525 38 20.0" 
$ns at 725.7056386880806 "$node_(78) setdest 1546 851 3.0" 
$ns at 785.6759412282639 "$node_(78) setdest 168 254 19.0" 
$ns at 881.5350115570269 "$node_(78) setdest 2573 541 1.0" 
$ns at 335.24824735772074 "$node_(79) setdest 1010 827 15.0" 
$ns at 407.4664864538122 "$node_(79) setdest 1700 204 6.0" 
$ns at 484.0267586603024 "$node_(79) setdest 1109 516 11.0" 
$ns at 521.8191108685891 "$node_(79) setdest 2155 406 4.0" 
$ns at 570.3248432211217 "$node_(79) setdest 2657 395 1.0" 
$ns at 602.9441203718075 "$node_(79) setdest 1067 758 16.0" 
$ns at 711.9729861404508 "$node_(79) setdest 1954 802 4.0" 
$ns at 743.5833355219138 "$node_(79) setdest 2259 369 8.0" 
$ns at 818.7199115420722 "$node_(79) setdest 24 338 17.0" 
$ns at 347.92873854481263 "$node_(80) setdest 440 369 8.0" 
$ns at 385.11134253823644 "$node_(80) setdest 2470 419 3.0" 
$ns at 428.1227496557195 "$node_(80) setdest 397 897 13.0" 
$ns at 472.29925572615446 "$node_(80) setdest 2819 990 4.0" 
$ns at 530.8077377296688 "$node_(80) setdest 675 969 5.0" 
$ns at 563.525943219881 "$node_(80) setdest 685 299 3.0" 
$ns at 604.6489613220286 "$node_(80) setdest 1899 631 16.0" 
$ns at 660.5983697531142 "$node_(80) setdest 1571 436 2.0" 
$ns at 703.2274697709378 "$node_(80) setdest 1398 648 3.0" 
$ns at 742.1433036164992 "$node_(80) setdest 1809 503 17.0" 
$ns at 874.0767374225937 "$node_(80) setdest 314 694 12.0" 
$ns at 363.5412944779696 "$node_(81) setdest 1549 244 15.0" 
$ns at 524.1022106717135 "$node_(81) setdest 1623 422 7.0" 
$ns at 566.8118013372035 "$node_(81) setdest 2131 152 17.0" 
$ns at 695.0567463463711 "$node_(81) setdest 1678 472 18.0" 
$ns at 851.2440950467312 "$node_(81) setdest 2982 688 12.0" 
$ns at 452.3062310646387 "$node_(82) setdest 2958 801 17.0" 
$ns at 605.1056108519706 "$node_(82) setdest 441 279 16.0" 
$ns at 776.8193383694331 "$node_(82) setdest 54 63 20.0" 
$ns at 839.0780697812355 "$node_(82) setdest 2095 907 10.0" 
$ns at 379.06975109102586 "$node_(83) setdest 2501 1 16.0" 
$ns at 492.16218302113424 "$node_(83) setdest 324 174 19.0" 
$ns at 580.014621602689 "$node_(83) setdest 1035 808 11.0" 
$ns at 637.2859793795697 "$node_(83) setdest 1880 871 4.0" 
$ns at 687.9546704166453 "$node_(83) setdest 465 483 15.0" 
$ns at 777.2186543352836 "$node_(83) setdest 1581 151 19.0" 
$ns at 818.6507389240096 "$node_(83) setdest 270 639 3.0" 
$ns at 872.4530868621704 "$node_(83) setdest 1155 774 20.0" 
$ns at 358.8998127778614 "$node_(84) setdest 2067 106 14.0" 
$ns at 475.99873346417434 "$node_(84) setdest 1746 950 6.0" 
$ns at 560.7627751441365 "$node_(84) setdest 2988 60 14.0" 
$ns at 646.3036635407994 "$node_(84) setdest 957 183 20.0" 
$ns at 693.6311455676301 "$node_(84) setdest 1393 938 15.0" 
$ns at 818.0608934633115 "$node_(84) setdest 1972 594 18.0" 
$ns at 354.0019568937782 "$node_(85) setdest 2301 858 2.0" 
$ns at 385.70277889725463 "$node_(85) setdest 1635 568 8.0" 
$ns at 418.5872968417999 "$node_(85) setdest 2873 265 16.0" 
$ns at 509.1310923054985 "$node_(85) setdest 1477 26 7.0" 
$ns at 575.845724520367 "$node_(85) setdest 747 447 20.0" 
$ns at 764.8875046113701 "$node_(85) setdest 2945 825 16.0" 
$ns at 829.9845378082903 "$node_(85) setdest 2226 715 3.0" 
$ns at 881.2030409656792 "$node_(85) setdest 1219 899 12.0" 
$ns at 455.0008567169272 "$node_(86) setdest 2475 801 14.0" 
$ns at 580.168824410388 "$node_(86) setdest 1778 510 9.0" 
$ns at 691.8519061850108 "$node_(86) setdest 2215 213 9.0" 
$ns at 742.5954858243431 "$node_(86) setdest 2217 366 13.0" 
$ns at 825.4781903371419 "$node_(86) setdest 1363 708 19.0" 
$ns at 857.0472020352843 "$node_(86) setdest 1245 274 4.0" 
$ns at 896.0970746960102 "$node_(86) setdest 797 518 12.0" 
$ns at 368.21558377863687 "$node_(87) setdest 1468 455 14.0" 
$ns at 440.27898489896853 "$node_(87) setdest 642 875 17.0" 
$ns at 554.2910742443114 "$node_(87) setdest 2423 240 16.0" 
$ns at 667.7065801671388 "$node_(87) setdest 1979 903 7.0" 
$ns at 743.5165964383821 "$node_(87) setdest 2388 498 10.0" 
$ns at 827.7529936879725 "$node_(87) setdest 1780 157 11.0" 
$ns at 359.54361459711265 "$node_(88) setdest 1729 253 7.0" 
$ns at 445.0724682580539 "$node_(88) setdest 2941 377 9.0" 
$ns at 559.3849337929081 "$node_(88) setdest 1093 473 16.0" 
$ns at 702.7908155875177 "$node_(88) setdest 2958 578 9.0" 
$ns at 790.7330311950836 "$node_(88) setdest 657 612 13.0" 
$ns at 863.3676671635258 "$node_(88) setdest 838 463 6.0" 
$ns at 374.8935018914286 "$node_(89) setdest 2434 143 6.0" 
$ns at 432.03769178256084 "$node_(89) setdest 1494 869 11.0" 
$ns at 557.6122804704117 "$node_(89) setdest 1564 375 5.0" 
$ns at 618.4834292683763 "$node_(89) setdest 1063 760 18.0" 
$ns at 815.7948118491895 "$node_(89) setdest 2915 930 15.0" 
$ns at 422.584144903312 "$node_(90) setdest 2934 552 17.0" 
$ns at 528.2235154276777 "$node_(90) setdest 1217 600 2.0" 
$ns at 560.288921426223 "$node_(90) setdest 1107 494 19.0" 
$ns at 642.8448528032709 "$node_(90) setdest 1339 776 16.0" 
$ns at 828.2139887426781 "$node_(90) setdest 936 653 10.0" 
$ns at 362.2587382417438 "$node_(91) setdest 2350 566 14.0" 
$ns at 518.3946768098789 "$node_(91) setdest 942 278 20.0" 
$ns at 715.4777203486985 "$node_(91) setdest 2571 623 19.0" 
$ns at 793.232828164724 "$node_(91) setdest 1629 499 19.0" 
$ns at 358.444407106452 "$node_(92) setdest 1859 965 17.0" 
$ns at 494.59130264524305 "$node_(92) setdest 637 876 3.0" 
$ns at 542.5249393399456 "$node_(92) setdest 545 533 15.0" 
$ns at 649.9276803739476 "$node_(92) setdest 963 529 20.0" 
$ns at 833.2082568199887 "$node_(92) setdest 1407 85 13.0" 
$ns at 343.82424055160686 "$node_(93) setdest 2332 670 17.0" 
$ns at 521.7085013973957 "$node_(93) setdest 2934 634 18.0" 
$ns at 603.6817635190615 "$node_(93) setdest 2138 100 8.0" 
$ns at 688.0573931378648 "$node_(93) setdest 2019 258 15.0" 
$ns at 821.9060531930684 "$node_(93) setdest 803 449 15.0" 
$ns at 344.5479029267696 "$node_(94) setdest 867 513 12.0" 
$ns at 469.8656908744325 "$node_(94) setdest 1115 712 14.0" 
$ns at 633.7034083213632 "$node_(94) setdest 285 599 13.0" 
$ns at 777.751919614554 "$node_(94) setdest 1007 610 1.0" 
$ns at 809.5996561977192 "$node_(94) setdest 2284 187 3.0" 
$ns at 855.8504087037063 "$node_(94) setdest 2735 853 19.0" 
$ns at 340.90161900693033 "$node_(95) setdest 531 576 6.0" 
$ns at 376.39972824899684 "$node_(95) setdest 380 556 12.0" 
$ns at 430.3721308157375 "$node_(95) setdest 2143 340 15.0" 
$ns at 476.42953617297394 "$node_(95) setdest 2771 58 9.0" 
$ns at 542.1999515856355 "$node_(95) setdest 2863 861 8.0" 
$ns at 647.5916013801324 "$node_(95) setdest 691 332 5.0" 
$ns at 715.8011659220881 "$node_(95) setdest 1105 463 20.0" 
$ns at 799.7697874321044 "$node_(95) setdest 802 906 15.0" 
$ns at 376.93730639074965 "$node_(96) setdest 863 297 1.0" 
$ns at 408.93832094789894 "$node_(96) setdest 694 556 13.0" 
$ns at 490.95870615065877 "$node_(96) setdest 2627 960 17.0" 
$ns at 530.6597528973963 "$node_(96) setdest 168 334 5.0" 
$ns at 563.2829977473892 "$node_(96) setdest 1732 966 18.0" 
$ns at 624.0982784959156 "$node_(96) setdest 1893 42 11.0" 
$ns at 723.3730874433573 "$node_(96) setdest 341 635 8.0" 
$ns at 766.8644755294443 "$node_(96) setdest 1358 504 1.0" 
$ns at 801.7513692108922 "$node_(96) setdest 2350 930 4.0" 
$ns at 841.6282270498285 "$node_(96) setdest 1306 958 17.0" 
$ns at 355.53051085902166 "$node_(97) setdest 2374 267 9.0" 
$ns at 386.47156082442905 "$node_(97) setdest 2550 709 12.0" 
$ns at 475.44890630202707 "$node_(97) setdest 2526 920 3.0" 
$ns at 509.54488906317283 "$node_(97) setdest 1968 336 6.0" 
$ns at 552.6635088044104 "$node_(97) setdest 2802 396 12.0" 
$ns at 587.5325141101314 "$node_(97) setdest 2998 131 10.0" 
$ns at 655.1017628087066 "$node_(97) setdest 2053 170 6.0" 
$ns at 709.2601260527223 "$node_(97) setdest 548 518 3.0" 
$ns at 749.4319801062252 "$node_(97) setdest 2583 829 4.0" 
$ns at 789.7492763180038 "$node_(97) setdest 2108 331 14.0" 
$ns at 890.3925430068365 "$node_(97) setdest 2000 237 7.0" 
$ns at 332.73867002426874 "$node_(98) setdest 1087 382 12.0" 
$ns at 472.0292753401761 "$node_(98) setdest 2491 566 3.0" 
$ns at 528.9809959926914 "$node_(98) setdest 1775 981 3.0" 
$ns at 564.6727826848617 "$node_(98) setdest 1748 927 17.0" 
$ns at 755.8512636326255 "$node_(98) setdest 2685 1 4.0" 
$ns at 819.3028378682859 "$node_(98) setdest 46 391 3.0" 
$ns at 874.2256337320669 "$node_(98) setdest 2908 437 2.0" 
$ns at 376.82878560280443 "$node_(99) setdest 1024 556 3.0" 
$ns at 422.6627139414742 "$node_(99) setdest 2079 371 18.0" 
$ns at 472.5321444892964 "$node_(99) setdest 2495 363 1.0" 
$ns at 508.8160811153322 "$node_(99) setdest 1586 87 10.0" 
$ns at 601.0378000294463 "$node_(99) setdest 321 856 17.0" 
$ns at 777.7857233549723 "$node_(99) setdest 294 928 1.0" 
$ns at 814.7336940834908 "$node_(99) setdest 213 395 20.0" 
$ns at 499.0782314886855 "$node_(100) setdest 2239 897 9.0" 
$ns at 580.6016921984644 "$node_(100) setdest 2198 161 10.0" 
$ns at 654.1487147632839 "$node_(100) setdest 271 655 11.0" 
$ns at 720.0325013358893 "$node_(100) setdest 1998 797 3.0" 
$ns at 752.7211127564876 "$node_(100) setdest 2931 96 19.0" 
$ns at 898.4888812606295 "$node_(100) setdest 1590 753 14.0" 
$ns at 517.0533689153077 "$node_(101) setdest 2812 399 1.0" 
$ns at 553.376848551301 "$node_(101) setdest 2759 981 7.0" 
$ns at 585.3608185142479 "$node_(101) setdest 587 682 11.0" 
$ns at 619.2905416821563 "$node_(101) setdest 2080 245 3.0" 
$ns at 674.1709394113568 "$node_(101) setdest 2083 432 17.0" 
$ns at 754.075804692716 "$node_(101) setdest 640 904 10.0" 
$ns at 811.4455961718268 "$node_(101) setdest 471 544 9.0" 
$ns at 550.1622311889096 "$node_(102) setdest 1404 515 19.0" 
$ns at 580.3798442907848 "$node_(102) setdest 131 328 10.0" 
$ns at 698.2663229071227 "$node_(102) setdest 2861 318 12.0" 
$ns at 836.6623441049032 "$node_(102) setdest 959 648 10.0" 
$ns at 884.0288781407878 "$node_(102) setdest 2290 418 15.0" 
$ns at 516.271539321285 "$node_(103) setdest 2379 19 19.0" 
$ns at 591.8421642255025 "$node_(103) setdest 2577 833 20.0" 
$ns at 640.5999361819058 "$node_(103) setdest 2185 141 19.0" 
$ns at 701.5583162388717 "$node_(103) setdest 2964 352 16.0" 
$ns at 817.779904399934 "$node_(103) setdest 1116 934 17.0" 
$ns at 546.0629957662035 "$node_(104) setdest 889 164 4.0" 
$ns at 590.1904835099007 "$node_(104) setdest 2545 619 7.0" 
$ns at 669.4009908561534 "$node_(104) setdest 978 633 11.0" 
$ns at 745.3126753580912 "$node_(104) setdest 1623 817 2.0" 
$ns at 778.408037842533 "$node_(104) setdest 2464 494 11.0" 
$ns at 621.9064568463534 "$node_(105) setdest 1673 361 12.0" 
$ns at 673.401208640172 "$node_(105) setdest 1448 643 7.0" 
$ns at 773.3125494086605 "$node_(105) setdest 1786 50 16.0" 
$ns at 863.1752383947712 "$node_(105) setdest 2882 212 17.0" 
$ns at 550.6037872739611 "$node_(106) setdest 2313 800 15.0" 
$ns at 663.709407623046 "$node_(106) setdest 175 496 12.0" 
$ns at 750.4016479303054 "$node_(106) setdest 1844 929 18.0" 
$ns at 557.7407474367888 "$node_(107) setdest 1956 706 9.0" 
$ns at 601.767715535793 "$node_(107) setdest 1972 580 13.0" 
$ns at 638.0240360695095 "$node_(107) setdest 737 315 13.0" 
$ns at 746.1954794132062 "$node_(107) setdest 2813 91 7.0" 
$ns at 806.3188400170607 "$node_(107) setdest 1847 831 11.0" 
$ns at 525.162706402888 "$node_(108) setdest 2824 88 8.0" 
$ns at 595.5652022469462 "$node_(108) setdest 986 991 12.0" 
$ns at 699.5443014680934 "$node_(108) setdest 303 923 20.0" 
$ns at 838.83703705812 "$node_(108) setdest 95 99 10.0" 
$ns at 498.93149122513944 "$node_(109) setdest 653 250 17.0" 
$ns at 555.7097650082385 "$node_(109) setdest 53 160 1.0" 
$ns at 593.2311058769588 "$node_(109) setdest 2771 465 12.0" 
$ns at 652.2717433309639 "$node_(109) setdest 1647 82 12.0" 
$ns at 715.2151621013876 "$node_(109) setdest 2175 363 12.0" 
$ns at 799.6269480761764 "$node_(109) setdest 1177 517 9.0" 
$ns at 521.9843946811961 "$node_(110) setdest 312 117 13.0" 
$ns at 617.03520690779 "$node_(110) setdest 559 829 8.0" 
$ns at 715.5468463365531 "$node_(110) setdest 1270 761 20.0" 
$ns at 792.6754359802583 "$node_(110) setdest 26 936 1.0" 
$ns at 826.9318638680604 "$node_(110) setdest 1723 145 8.0" 
$ns at 887.445318080067 "$node_(110) setdest 2537 759 16.0" 
$ns at 579.4895554603336 "$node_(111) setdest 2860 729 15.0" 
$ns at 732.3559103982774 "$node_(111) setdest 2752 155 20.0" 
$ns at 588.3737622512101 "$node_(112) setdest 1824 320 18.0" 
$ns at 689.680310002014 "$node_(112) setdest 2250 939 1.0" 
$ns at 727.5574048335596 "$node_(112) setdest 1690 360 11.0" 
$ns at 784.2292531682424 "$node_(112) setdest 443 224 8.0" 
$ns at 815.7826148450102 "$node_(112) setdest 629 932 12.0" 
$ns at 526.2574779157834 "$node_(113) setdest 1272 438 4.0" 
$ns at 570.5785665511835 "$node_(113) setdest 243 135 18.0" 
$ns at 732.3775746116341 "$node_(113) setdest 1200 316 1.0" 
$ns at 765.5743615730024 "$node_(113) setdest 1695 785 17.0" 
$ns at 831.5095174413186 "$node_(113) setdest 1934 432 2.0" 
$ns at 868.2794601016079 "$node_(113) setdest 1131 925 7.0" 
$ns at 513.1194186553437 "$node_(114) setdest 657 819 9.0" 
$ns at 571.5685653082218 "$node_(114) setdest 323 373 14.0" 
$ns at 690.9647145396576 "$node_(114) setdest 2646 890 10.0" 
$ns at 729.969624596565 "$node_(114) setdest 2139 767 1.0" 
$ns at 764.0583044629224 "$node_(114) setdest 687 327 19.0" 
$ns at 869.5924986544006 "$node_(114) setdest 804 200 6.0" 
$ns at 534.8918020515323 "$node_(115) setdest 1219 768 1.0" 
$ns at 568.4753007025198 "$node_(115) setdest 2819 632 5.0" 
$ns at 611.6431924697545 "$node_(115) setdest 2268 942 15.0" 
$ns at 691.8420862258935 "$node_(115) setdest 2917 107 18.0" 
$ns at 839.8702796040378 "$node_(115) setdest 1077 549 14.0" 
$ns at 598.8914432149286 "$node_(116) setdest 1973 671 15.0" 
$ns at 690.7620317280504 "$node_(116) setdest 1523 800 7.0" 
$ns at 777.8616213917026 "$node_(116) setdest 2790 152 8.0" 
$ns at 881.9633999914353 "$node_(116) setdest 592 720 10.0" 
$ns at 523.7168824321975 "$node_(117) setdest 2669 514 8.0" 
$ns at 600.3126355462383 "$node_(117) setdest 2088 186 13.0" 
$ns at 656.4144846252684 "$node_(117) setdest 373 573 2.0" 
$ns at 687.3789333331456 "$node_(117) setdest 2980 242 7.0" 
$ns at 769.4225626962528 "$node_(117) setdest 2597 415 14.0" 
$ns at 563.3123665807933 "$node_(118) setdest 553 424 9.0" 
$ns at 649.984997469747 "$node_(118) setdest 2007 44 2.0" 
$ns at 682.4515963489174 "$node_(118) setdest 220 531 12.0" 
$ns at 821.5181243085451 "$node_(118) setdest 2991 696 18.0" 
$ns at 584.6267055330761 "$node_(119) setdest 903 693 9.0" 
$ns at 690.7526176329127 "$node_(119) setdest 679 724 11.0" 
$ns at 775.3600309484212 "$node_(119) setdest 861 861 13.0" 
$ns at 823.3660303191583 "$node_(119) setdest 949 483 11.0" 
$ns at 608.5499449456123 "$node_(120) setdest 2450 907 9.0" 
$ns at 644.4152133272456 "$node_(120) setdest 1018 636 3.0" 
$ns at 687.4497116000183 "$node_(120) setdest 691 317 14.0" 
$ns at 794.488076322927 "$node_(120) setdest 1467 536 19.0" 
$ns at 856.4589089325794 "$node_(120) setdest 731 520 1.0" 
$ns at 891.4938780592976 "$node_(120) setdest 855 400 17.0" 
$ns at 497.08469424922123 "$node_(121) setdest 2864 246 3.0" 
$ns at 535.0581600604738 "$node_(121) setdest 1468 633 13.0" 
$ns at 587.4379241254057 "$node_(121) setdest 542 121 8.0" 
$ns at 626.0000038124267 "$node_(121) setdest 143 172 3.0" 
$ns at 681.8131902078305 "$node_(121) setdest 1413 768 11.0" 
$ns at 724.7816365855628 "$node_(121) setdest 2950 615 4.0" 
$ns at 789.6646615802699 "$node_(121) setdest 1274 90 12.0" 
$ns at 522.0271182763089 "$node_(122) setdest 1910 621 19.0" 
$ns at 600.3777260484488 "$node_(122) setdest 1724 423 18.0" 
$ns at 709.6690305768758 "$node_(122) setdest 2359 997 14.0" 
$ns at 755.6653483876423 "$node_(122) setdest 2999 432 16.0" 
$ns at 790.738097898152 "$node_(122) setdest 1142 162 3.0" 
$ns at 833.9666423420202 "$node_(122) setdest 1497 531 4.0" 
$ns at 894.5705953420393 "$node_(122) setdest 204 944 12.0" 
$ns at 514.9412635372668 "$node_(123) setdest 46 447 4.0" 
$ns at 582.3706289477309 "$node_(123) setdest 104 897 11.0" 
$ns at 703.9240724392697 "$node_(123) setdest 452 180 10.0" 
$ns at 831.2125883232619 "$node_(123) setdest 2146 391 1.0" 
$ns at 869.8342030972512 "$node_(123) setdest 1303 195 14.0" 
$ns at 608.2514254620036 "$node_(124) setdest 893 20 10.0" 
$ns at 647.7293932886485 "$node_(124) setdest 494 210 3.0" 
$ns at 690.3863795692041 "$node_(124) setdest 1768 585 18.0" 
$ns at 857.6675400596175 "$node_(124) setdest 2836 725 10.0" 
$ns at 688.3677527298703 "$node_(125) setdest 1844 700 12.0" 
$ns at 751.2830314979964 "$node_(125) setdest 569 279 7.0" 
$ns at 792.1520479994558 "$node_(125) setdest 1032 960 11.0" 
$ns at 885.4152045888898 "$node_(125) setdest 2013 781 5.0" 
$ns at 662.3504060873283 "$node_(126) setdest 2851 454 6.0" 
$ns at 694.1335758243962 "$node_(126) setdest 2973 151 19.0" 
$ns at 808.4205202052456 "$node_(126) setdest 20 895 4.0" 
$ns at 841.6002035776005 "$node_(126) setdest 197 93 12.0" 
$ns at 749.9625427148585 "$node_(127) setdest 2216 260 1.0" 
$ns at 783.9048774638832 "$node_(127) setdest 2814 739 3.0" 
$ns at 835.5550889290047 "$node_(127) setdest 564 719 1.0" 
$ns at 870.3467660815459 "$node_(127) setdest 2719 666 17.0" 
$ns at 710.4622967005116 "$node_(128) setdest 258 37 13.0" 
$ns at 814.9103428403442 "$node_(128) setdest 105 912 10.0" 
$ns at 816.5062295997556 "$node_(129) setdest 2741 279 8.0" 
$ns at 883.6078837723844 "$node_(129) setdest 400 167 17.0" 
$ns at 754.7989113909064 "$node_(130) setdest 1037 474 17.0" 
$ns at 821.5085737338861 "$node_(130) setdest 741 88 18.0" 
$ns at 761.8099395994677 "$node_(131) setdest 650 676 14.0" 
$ns at 892.5800746002102 "$node_(131) setdest 2402 790 4.0" 
$ns at 677.5047920888361 "$node_(132) setdest 28 127 7.0" 
$ns at 734.8617491434337 "$node_(132) setdest 1600 731 1.0" 
$ns at 766.9130321486151 "$node_(132) setdest 642 593 14.0" 
$ns at 814.5533566829273 "$node_(132) setdest 1772 224 12.0" 
$ns at 667.0849411494094 "$node_(133) setdest 2121 152 17.0" 
$ns at 780.6628654040328 "$node_(133) setdest 607 262 5.0" 
$ns at 851.2329956311461 "$node_(133) setdest 1616 582 11.0" 
$ns at 678.5033473532986 "$node_(134) setdest 2872 288 7.0" 
$ns at 755.2505943099052 "$node_(134) setdest 412 373 8.0" 
$ns at 833.5714144585013 "$node_(134) setdest 302 317 3.0" 
$ns at 871.4893319930974 "$node_(134) setdest 1711 393 3.0" 
$ns at 686.6380970496668 "$node_(135) setdest 2176 223 4.0" 
$ns at 731.9222566440303 "$node_(135) setdest 2672 123 6.0" 
$ns at 770.6922726744014 "$node_(135) setdest 2619 900 17.0" 
$ns at 690.7651653136858 "$node_(136) setdest 1307 307 20.0" 
$ns at 826.5313427975404 "$node_(136) setdest 1376 384 11.0" 
$ns at 876.3719857123141 "$node_(136) setdest 1747 79 15.0" 
$ns at 691.0265955523164 "$node_(137) setdest 1821 302 14.0" 
$ns at 807.1471799185193 "$node_(137) setdest 1576 278 4.0" 
$ns at 844.3663690563521 "$node_(137) setdest 2815 118 17.0" 
$ns at 700.4771519265464 "$node_(138) setdest 133 434 3.0" 
$ns at 758.2303342539399 "$node_(138) setdest 96 142 12.0" 
$ns at 845.9208193869262 "$node_(138) setdest 1341 760 14.0" 
$ns at 744.358447636051 "$node_(139) setdest 1252 526 12.0" 
$ns at 819.2059981604282 "$node_(139) setdest 396 851 8.0" 
$ns at 862.5796521428679 "$node_(139) setdest 1724 953 5.0" 
$ns at 710.0737148212113 "$node_(140) setdest 2742 187 1.0" 
$ns at 747.5479378619486 "$node_(140) setdest 2473 947 14.0" 
$ns at 814.5375206101573 "$node_(140) setdest 288 616 4.0" 
$ns at 848.7257577525305 "$node_(140) setdest 1328 990 1.0" 
$ns at 878.9664930333594 "$node_(140) setdest 2424 275 2.0" 
$ns at 671.83396826154 "$node_(141) setdest 2462 455 3.0" 
$ns at 714.1271745595201 "$node_(141) setdest 2125 315 8.0" 
$ns at 791.0520567712782 "$node_(141) setdest 1560 784 10.0" 
$ns at 861.8989454084949 "$node_(141) setdest 2296 498 6.0" 
$ns at 706.3101405541023 "$node_(142) setdest 999 746 16.0" 
$ns at 845.6891152911861 "$node_(142) setdest 2182 225 4.0" 
$ns at 691.2018867919702 "$node_(143) setdest 2299 822 7.0" 
$ns at 739.3701096600432 "$node_(143) setdest 2970 654 8.0" 
$ns at 807.4555308461612 "$node_(143) setdest 2912 252 2.0" 
$ns at 852.8726151450448 "$node_(143) setdest 2093 712 9.0" 
$ns at 744.3980201656941 "$node_(144) setdest 2165 941 13.0" 
$ns at 871.361102899278 "$node_(144) setdest 2785 237 19.0" 
$ns at 665.1926313817978 "$node_(145) setdest 840 41 12.0" 
$ns at 733.8687917599675 "$node_(145) setdest 1970 763 2.0" 
$ns at 763.912737417839 "$node_(145) setdest 1710 988 13.0" 
$ns at 809.5797263794638 "$node_(145) setdest 1375 220 5.0" 
$ns at 869.3404078544199 "$node_(145) setdest 362 724 6.0" 
$ns at 680.2747916284578 "$node_(146) setdest 1199 410 3.0" 
$ns at 720.0992612271158 "$node_(146) setdest 937 62 4.0" 
$ns at 773.9020754650246 "$node_(146) setdest 546 952 1.0" 
$ns at 806.5668701434026 "$node_(146) setdest 38 752 10.0" 
$ns at 883.471216552872 "$node_(146) setdest 2664 522 19.0" 
$ns at 736.1026312292728 "$node_(147) setdest 1711 59 5.0" 
$ns at 807.490566424077 "$node_(147) setdest 2264 317 13.0" 
$ns at 896.2203878911347 "$node_(147) setdest 55 882 1.0" 
$ns at 715.8066075824747 "$node_(148) setdest 997 768 17.0" 
$ns at 752.4171243185023 "$node_(148) setdest 1455 278 7.0" 
$ns at 789.6471655070065 "$node_(148) setdest 634 983 5.0" 
$ns at 838.959224388345 "$node_(148) setdest 599 289 11.0" 
$ns at 714.0002617002026 "$node_(149) setdest 1595 874 4.0" 
$ns at 781.4214490099544 "$node_(149) setdest 981 788 7.0" 
$ns at 876.2900768647766 "$node_(149) setdest 238 524 16.0" 


#Set a TCP connection between node_(24) and node_(23)
set tcp_(0) [new Agent/TCP/Newreno]
$tcp_(0) set class_ 2
set sink_(0) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(0)
$ns attach-agent $node_(23) $sink_(0)
$ns connect $tcp_(0) $sink_(0)
set ftp_(0) [new Application/FTP]
$ftp_(0) attach-agent $tcp_(0)
$ns at 0.2 "$ftp_(0) start"
$ns at 180.0 "$ftp_(0) stop"

#Set a TCP connection between node_(38) and node_(21)
set tcp_(1) [new Agent/TCP/Newreno]
$tcp_(1) set class_ 2
set sink_(1) [new Agent/TCPSink]
$ns attach-agent $node_(38) $tcp_(1)
$ns attach-agent $node_(21) $sink_(1)
$ns connect $tcp_(1) $sink_(1)
set ftp_(1) [new Application/FTP]
$ftp_(1) attach-agent $tcp_(1)
$ns at 180.2 "$ftp_(1) start"
$ns at 360.0 "$ftp_(1) stop"

#Set a TCP connection between node_(8) and node_(17)
set tcp_(2) [new Agent/TCP/Newreno]
$tcp_(2) set class_ 2
set sink_(2) [new Agent/TCPSink]
$ns attach-agent $node_(8) $tcp_(2)
$ns attach-agent $node_(17) $sink_(2)
$ns connect $tcp_(2) $sink_(2)
set ftp_(2) [new Application/FTP]
$ftp_(2) attach-agent $tcp_(2)
$ns at 360.2 "$ftp_(2) start"
$ns at 540.0 "$ftp_(2) stop"

#Set a TCP connection between node_(32) and node_(9)
set tcp_(3) [new Agent/TCP/Newreno]
$tcp_(3) set class_ 2
set sink_(3) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(3)
$ns attach-agent $node_(9) $sink_(3)
$ns connect $tcp_(3) $sink_(3)
set ftp_(3) [new Application/FTP]
$ftp_(3) attach-agent $tcp_(3)
$ns at 540.2 "$ftp_(3) start"
$ns at 720.0 "$ftp_(3) stop"

#Set a TCP connection between node_(2) and node_(28)
set tcp_(4) [new Agent/TCP/Newreno]
$tcp_(4) set class_ 2
set sink_(4) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(4)
$ns attach-agent $node_(28) $sink_(4)
$ns connect $tcp_(4) $sink_(4)
set ftp_(4) [new Application/FTP]
$ftp_(4) attach-agent $tcp_(4)
$ns at 720.2 "$ftp_(4) start"
$ns at 900.0 "$ftp_(4) stop"

#Set a TCP connection between node_(1) and node_(26)
set tcp_(5) [new Agent/TCP/Newreno]
$tcp_(5) set class_ 2
set sink_(5) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(5)
$ns attach-agent $node_(26) $sink_(5)
$ns connect $tcp_(5) $sink_(5)
set ftp_(5) [new Application/FTP]
$ftp_(5) attach-agent $tcp_(5)
$ns at 0.2 "$ftp_(5) start"
$ns at 180.0 "$ftp_(5) stop"

#Set a TCP connection between node_(9) and node_(29)
set tcp_(6) [new Agent/TCP/Newreno]
$tcp_(6) set class_ 2
set sink_(6) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(6)
$ns attach-agent $node_(29) $sink_(6)
$ns connect $tcp_(6) $sink_(6)
set ftp_(6) [new Application/FTP]
$ftp_(6) attach-agent $tcp_(6)
$ns at 180.2 "$ftp_(6) start"
$ns at 360.0 "$ftp_(6) stop"

#Set a TCP connection between node_(30) and node_(20)
set tcp_(7) [new Agent/TCP/Newreno]
$tcp_(7) set class_ 2
set sink_(7) [new Agent/TCPSink]
$ns attach-agent $node_(30) $tcp_(7)
$ns attach-agent $node_(20) $sink_(7)
$ns connect $tcp_(7) $sink_(7)
set ftp_(7) [new Application/FTP]
$ftp_(7) attach-agent $tcp_(7)
$ns at 360.2 "$ftp_(7) start"
$ns at 540.0 "$ftp_(7) stop"

#Set a TCP connection between node_(21) and node_(12)
set tcp_(8) [new Agent/TCP/Newreno]
$tcp_(8) set class_ 2
set sink_(8) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(8)
$ns attach-agent $node_(12) $sink_(8)
$ns connect $tcp_(8) $sink_(8)
set ftp_(8) [new Application/FTP]
$ftp_(8) attach-agent $tcp_(8)
$ns at 540.2 "$ftp_(8) start"
$ns at 720.0 "$ftp_(8) stop"

#Set a TCP connection between node_(27) and node_(47)
set tcp_(9) [new Agent/TCP/Newreno]
$tcp_(9) set class_ 2
set sink_(9) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(9)
$ns attach-agent $node_(47) $sink_(9)
$ns connect $tcp_(9) $sink_(9)
set ftp_(9) [new Application/FTP]
$ftp_(9) attach-agent $tcp_(9)
$ns at 720.2 "$ftp_(9) start"
$ns at 900.0 "$ftp_(9) stop"

#Set a TCP connection between node_(36) and node_(33)
set tcp_(10) [new Agent/TCP/Newreno]
$tcp_(10) set class_ 2
set sink_(10) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(10)
$ns attach-agent $node_(33) $sink_(10)
$ns connect $tcp_(10) $sink_(10)
set ftp_(10) [new Application/FTP]
$ftp_(10) attach-agent $tcp_(10)
$ns at 0.2 "$ftp_(10) start"
$ns at 180.0 "$ftp_(10) stop"

#Set a TCP connection between node_(34) and node_(47)
set tcp_(11) [new Agent/TCP/Newreno]
$tcp_(11) set class_ 2
set sink_(11) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(11)
$ns attach-agent $node_(47) $sink_(11)
$ns connect $tcp_(11) $sink_(11)
set ftp_(11) [new Application/FTP]
$ftp_(11) attach-agent $tcp_(11)
$ns at 180.2 "$ftp_(11) start"
$ns at 360.0 "$ftp_(11) stop"

#Set a TCP connection between node_(41) and node_(43)
set tcp_(12) [new Agent/TCP/Newreno]
$tcp_(12) set class_ 2
set sink_(12) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(12)
$ns attach-agent $node_(43) $sink_(12)
$ns connect $tcp_(12) $sink_(12)
set ftp_(12) [new Application/FTP]
$ftp_(12) attach-agent $tcp_(12)
$ns at 360.2 "$ftp_(12) start"
$ns at 540.0 "$ftp_(12) stop"

#Set a TCP connection between node_(3) and node_(40)
set tcp_(13) [new Agent/TCP/Newreno]
$tcp_(13) set class_ 2
set sink_(13) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(13)
$ns attach-agent $node_(40) $sink_(13)
$ns connect $tcp_(13) $sink_(13)
set ftp_(13) [new Application/FTP]
$ftp_(13) attach-agent $tcp_(13)
$ns at 540.2 "$ftp_(13) start"
$ns at 720.0 "$ftp_(13) stop"

#Set a TCP connection between node_(25) and node_(46)
set tcp_(14) [new Agent/TCP/Newreno]
$tcp_(14) set class_ 2
set sink_(14) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(14)
$ns attach-agent $node_(46) $sink_(14)
$ns connect $tcp_(14) $sink_(14)
set ftp_(14) [new Application/FTP]
$ftp_(14) attach-agent $tcp_(14)
$ns at 720.2 "$ftp_(14) start"
$ns at 900.0 "$ftp_(14) stop"

#Set a TCP connection between node_(40) and node_(41)
set tcp_(15) [new Agent/TCP/Newreno]
$tcp_(15) set class_ 2
set sink_(15) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(15)
$ns attach-agent $node_(41) $sink_(15)
$ns connect $tcp_(15) $sink_(15)
set ftp_(15) [new Application/FTP]
$ftp_(15) attach-agent $tcp_(15)
$ns at 0.2 "$ftp_(15) start"
$ns at 180.0 "$ftp_(15) stop"

#Set a TCP connection between node_(12) and node_(42)
set tcp_(16) [new Agent/TCP/Newreno]
$tcp_(16) set class_ 2
set sink_(16) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(16)
$ns attach-agent $node_(42) $sink_(16)
$ns connect $tcp_(16) $sink_(16)
set ftp_(16) [new Application/FTP]
$ftp_(16) attach-agent $tcp_(16)
$ns at 180.2 "$ftp_(16) start"
$ns at 360.0 "$ftp_(16) stop"

#Set a TCP connection between node_(25) and node_(47)
set tcp_(17) [new Agent/TCP/Newreno]
$tcp_(17) set class_ 2
set sink_(17) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(17)
$ns attach-agent $node_(47) $sink_(17)
$ns connect $tcp_(17) $sink_(17)
set ftp_(17) [new Application/FTP]
$ftp_(17) attach-agent $tcp_(17)
$ns at 360.2 "$ftp_(17) start"
$ns at 540.0 "$ftp_(17) stop"

#Set a TCP connection between node_(46) and node_(47)
set tcp_(18) [new Agent/TCP/Newreno]
$tcp_(18) set class_ 2
set sink_(18) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(18)
$ns attach-agent $node_(47) $sink_(18)
$ns connect $tcp_(18) $sink_(18)
set ftp_(18) [new Application/FTP]
$ftp_(18) attach-agent $tcp_(18)
$ns at 540.2 "$ftp_(18) start"
$ns at 720.0 "$ftp_(18) stop"

#Set a TCP connection between node_(12) and node_(15)
set tcp_(19) [new Agent/TCP/Newreno]
$tcp_(19) set class_ 2
set sink_(19) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(19)
$ns attach-agent $node_(15) $sink_(19)
$ns connect $tcp_(19) $sink_(19)
set ftp_(19) [new Application/FTP]
$ftp_(19) attach-agent $tcp_(19)
$ns at 720.2 "$ftp_(19) start"
$ns at 900.0 "$ftp_(19) stop"

#Set a TCP connection between node_(22) and node_(29)
set tcp_(20) [new Agent/TCP/Newreno]
$tcp_(20) set class_ 2
set sink_(20) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(20)
$ns attach-agent $node_(29) $sink_(20)
$ns connect $tcp_(20) $sink_(20)
set ftp_(20) [new Application/FTP]
$ftp_(20) attach-agent $tcp_(20)
$ns at 0.2 "$ftp_(20) start"
$ns at 180.0 "$ftp_(20) stop"

#Set a TCP connection between node_(18) and node_(28)
set tcp_(21) [new Agent/TCP/Newreno]
$tcp_(21) set class_ 2
set sink_(21) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(21)
$ns attach-agent $node_(28) $sink_(21)
$ns connect $tcp_(21) $sink_(21)
set ftp_(21) [new Application/FTP]
$ftp_(21) attach-agent $tcp_(21)
$ns at 180.2 "$ftp_(21) start"
$ns at 360.0 "$ftp_(21) stop"

#Set a TCP connection between node_(37) and node_(41)
set tcp_(22) [new Agent/TCP/Newreno]
$tcp_(22) set class_ 2
set sink_(22) [new Agent/TCPSink]
$ns attach-agent $node_(37) $tcp_(22)
$ns attach-agent $node_(41) $sink_(22)
$ns connect $tcp_(22) $sink_(22)
set ftp_(22) [new Application/FTP]
$ftp_(22) attach-agent $tcp_(22)
$ns at 360.2 "$ftp_(22) start"
$ns at 540.0 "$ftp_(22) stop"

#Set a TCP connection between node_(5) and node_(24)
set tcp_(23) [new Agent/TCP/Newreno]
$tcp_(23) set class_ 2
set sink_(23) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(23)
$ns attach-agent $node_(24) $sink_(23)
$ns connect $tcp_(23) $sink_(23)
set ftp_(23) [new Application/FTP]
$ftp_(23) attach-agent $tcp_(23)
$ns at 540.2 "$ftp_(23) start"
$ns at 720.0 "$ftp_(23) stop"

#Set a TCP connection between node_(1) and node_(19)
set tcp_(24) [new Agent/TCP/Newreno]
$tcp_(24) set class_ 2
set sink_(24) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(24)
$ns attach-agent $node_(19) $sink_(24)
$ns connect $tcp_(24) $sink_(24)
set ftp_(24) [new Application/FTP]
$ftp_(24) attach-agent $tcp_(24)
$ns at 720.2 "$ftp_(24) start"
$ns at 900.0 "$ftp_(24) stop"

#Set a TCP connection between node_(32) and node_(45)
set tcp_(25) [new Agent/TCP/Newreno]
$tcp_(25) set class_ 2
set sink_(25) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(25)
$ns attach-agent $node_(45) $sink_(25)
$ns connect $tcp_(25) $sink_(25)
set ftp_(25) [new Application/FTP]
$ftp_(25) attach-agent $tcp_(25)
$ns at 0.2 "$ftp_(25) start"
$ns at 180.0 "$ftp_(25) stop"

#Set a TCP connection between node_(41) and node_(9)
set tcp_(26) [new Agent/TCP/Newreno]
$tcp_(26) set class_ 2
set sink_(26) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(26)
$ns attach-agent $node_(9) $sink_(26)
$ns connect $tcp_(26) $sink_(26)
set ftp_(26) [new Application/FTP]
$ftp_(26) attach-agent $tcp_(26)
$ns at 180.2 "$ftp_(26) start"
$ns at 360.0 "$ftp_(26) stop"

#Set a TCP connection between node_(0) and node_(47)
set tcp_(27) [new Agent/TCP/Newreno]
$tcp_(27) set class_ 2
set sink_(27) [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp_(27)
$ns attach-agent $node_(47) $sink_(27)
$ns connect $tcp_(27) $sink_(27)
set ftp_(27) [new Application/FTP]
$ftp_(27) attach-agent $tcp_(27)
$ns at 360.2 "$ftp_(27) start"
$ns at 540.0 "$ftp_(27) stop"

#Set a TCP connection between node_(39) and node_(20)
set tcp_(28) [new Agent/TCP/Newreno]
$tcp_(28) set class_ 2
set sink_(28) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(28)
$ns attach-agent $node_(20) $sink_(28)
$ns connect $tcp_(28) $sink_(28)
set ftp_(28) [new Application/FTP]
$ftp_(28) attach-agent $tcp_(28)
$ns at 540.2 "$ftp_(28) start"
$ns at 720.0 "$ftp_(28) stop"

#Set a TCP connection between node_(28) and node_(13)
set tcp_(29) [new Agent/TCP/Newreno]
$tcp_(29) set class_ 2
set sink_(29) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(29)
$ns attach-agent $node_(13) $sink_(29)
$ns connect $tcp_(29) $sink_(29)
set ftp_(29) [new Application/FTP]
$ftp_(29) attach-agent $tcp_(29)
$ns at 720.2 "$ftp_(29) start"
$ns at 900.0 "$ftp_(29) stop"

#Set a TCP connection between node_(49) and node_(30)
set tcp_(30) [new Agent/TCP/Newreno]
$tcp_(30) set class_ 2
set sink_(30) [new Agent/TCPSink]
$ns attach-agent $node_(49) $tcp_(30)
$ns attach-agent $node_(30) $sink_(30)
$ns connect $tcp_(30) $sink_(30)
set ftp_(30) [new Application/FTP]
$ftp_(30) attach-agent $tcp_(30)
$ns at 0.2 "$ftp_(30) start"
$ns at 180.0 "$ftp_(30) stop"

#Set a TCP connection between node_(40) and node_(8)
set tcp_(31) [new Agent/TCP/Newreno]
$tcp_(31) set class_ 2
set sink_(31) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(31)
$ns attach-agent $node_(8) $sink_(31)
$ns connect $tcp_(31) $sink_(31)
set ftp_(31) [new Application/FTP]
$ftp_(31) attach-agent $tcp_(31)
$ns at 180.2 "$ftp_(31) start"
$ns at 360.0 "$ftp_(31) stop"

#Set a TCP connection between node_(39) and node_(33)
set tcp_(32) [new Agent/TCP/Newreno]
$tcp_(32) set class_ 2
set sink_(32) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(32)
$ns attach-agent $node_(33) $sink_(32)
$ns connect $tcp_(32) $sink_(32)
set ftp_(32) [new Application/FTP]
$ftp_(32) attach-agent $tcp_(32)
$ns at 360.2 "$ftp_(32) start"
$ns at 540.0 "$ftp_(32) stop"

#Set a TCP connection between node_(22) and node_(34)
set tcp_(33) [new Agent/TCP/Newreno]
$tcp_(33) set class_ 2
set sink_(33) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(33)
$ns attach-agent $node_(34) $sink_(33)
$ns connect $tcp_(33) $sink_(33)
set ftp_(33) [new Application/FTP]
$ftp_(33) attach-agent $tcp_(33)
$ns at 540.2 "$ftp_(33) start"
$ns at 720.0 "$ftp_(33) stop"

#Set a TCP connection between node_(2) and node_(11)
set tcp_(34) [new Agent/TCP/Newreno]
$tcp_(34) set class_ 2
set sink_(34) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(34)
$ns attach-agent $node_(11) $sink_(34)
$ns connect $tcp_(34) $sink_(34)
set ftp_(34) [new Application/FTP]
$ftp_(34) attach-agent $tcp_(34)
$ns at 720.2 "$ftp_(34) start"
$ns at 900.0 "$ftp_(34) stop"

#Set a TCP connection between node_(47) and node_(7)
set tcp_(35) [new Agent/TCP/Newreno]
$tcp_(35) set class_ 2
set sink_(35) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(35)
$ns attach-agent $node_(7) $sink_(35)
$ns connect $tcp_(35) $sink_(35)
set ftp_(35) [new Application/FTP]
$ftp_(35) attach-agent $tcp_(35)
$ns at 0.2 "$ftp_(35) start"
$ns at 180.0 "$ftp_(35) stop"

#Set a TCP connection between node_(5) and node_(37)
set tcp_(36) [new Agent/TCP/Newreno]
$tcp_(36) set class_ 2
set sink_(36) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(36)
$ns attach-agent $node_(37) $sink_(36)
$ns connect $tcp_(36) $sink_(36)
set ftp_(36) [new Application/FTP]
$ftp_(36) attach-agent $tcp_(36)
$ns at 180.2 "$ftp_(36) start"
$ns at 360.0 "$ftp_(36) stop"

#Set a TCP connection between node_(43) and node_(9)
set tcp_(37) [new Agent/TCP/Newreno]
$tcp_(37) set class_ 2
set sink_(37) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(37)
$ns attach-agent $node_(9) $sink_(37)
$ns connect $tcp_(37) $sink_(37)
set ftp_(37) [new Application/FTP]
$ftp_(37) attach-agent $tcp_(37)
$ns at 360.2 "$ftp_(37) start"
$ns at 540.0 "$ftp_(37) stop"

#Set a TCP connection between node_(21) and node_(32)
set tcp_(38) [new Agent/TCP/Newreno]
$tcp_(38) set class_ 2
set sink_(38) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(38)
$ns attach-agent $node_(32) $sink_(38)
$ns connect $tcp_(38) $sink_(38)
set ftp_(38) [new Application/FTP]
$ftp_(38) attach-agent $tcp_(38)
$ns at 540.2 "$ftp_(38) start"
$ns at 720.0 "$ftp_(38) stop"

#Set a TCP connection between node_(26) and node_(7)
set tcp_(39) [new Agent/TCP/Newreno]
$tcp_(39) set class_ 2
set sink_(39) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(39)
$ns attach-agent $node_(7) $sink_(39)
$ns connect $tcp_(39) $sink_(39)
set ftp_(39) [new Application/FTP]
$ftp_(39) attach-agent $tcp_(39)
$ns at 720.2 "$ftp_(39) start"
$ns at 900.0 "$ftp_(39) stop"

#Set a TCP connection between node_(11) and node_(10)
set tcp_(40) [new Agent/TCP/Newreno]
$tcp_(40) set class_ 2
set sink_(40) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(40)
$ns attach-agent $node_(10) $sink_(40)
$ns connect $tcp_(40) $sink_(40)
set ftp_(40) [new Application/FTP]
$ftp_(40) attach-agent $tcp_(40)
$ns at 0.2 "$ftp_(40) start"
$ns at 180.0 "$ftp_(40) stop"

#Set a TCP connection between node_(34) and node_(39)
set tcp_(41) [new Agent/TCP/Newreno]
$tcp_(41) set class_ 2
set sink_(41) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(41)
$ns attach-agent $node_(39) $sink_(41)
$ns connect $tcp_(41) $sink_(41)
set ftp_(41) [new Application/FTP]
$ftp_(41) attach-agent $tcp_(41)
$ns at 180.2 "$ftp_(41) start"
$ns at 360.0 "$ftp_(41) stop"

#Set a TCP connection between node_(38) and node_(21)
set tcp_(42) [new Agent/TCP/Newreno]
$tcp_(42) set class_ 2
set sink_(42) [new Agent/TCPSink]
$ns attach-agent $node_(38) $tcp_(42)
$ns attach-agent $node_(21) $sink_(42)
$ns connect $tcp_(42) $sink_(42)
set ftp_(42) [new Application/FTP]
$ftp_(42) attach-agent $tcp_(42)
$ns at 360.2 "$ftp_(42) start"
$ns at 540.0 "$ftp_(42) stop"

#Set a TCP connection between node_(48) and node_(36)
set tcp_(43) [new Agent/TCP/Newreno]
$tcp_(43) set class_ 2
set sink_(43) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(43)
$ns attach-agent $node_(36) $sink_(43)
$ns connect $tcp_(43) $sink_(43)
set ftp_(43) [new Application/FTP]
$ftp_(43) attach-agent $tcp_(43)
$ns at 540.2 "$ftp_(43) start"
$ns at 720.0 "$ftp_(43) stop"

#Set a TCP connection between node_(20) and node_(13)
set tcp_(44) [new Agent/TCP/Newreno]
$tcp_(44) set class_ 2
set sink_(44) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(44)
$ns attach-agent $node_(13) $sink_(44)
$ns connect $tcp_(44) $sink_(44)
set ftp_(44) [new Application/FTP]
$ftp_(44) attach-agent $tcp_(44)
$ns at 720.2 "$ftp_(44) start"
$ns at 900.0 "$ftp_(44) stop"

#Set a TCP connection between node_(31) and node_(10)
set tcp_(45) [new Agent/TCP/Newreno]
$tcp_(45) set class_ 2
set sink_(45) [new Agent/TCPSink]
$ns attach-agent $node_(31) $tcp_(45)
$ns attach-agent $node_(10) $sink_(45)
$ns connect $tcp_(45) $sink_(45)
set ftp_(45) [new Application/FTP]
$ftp_(45) attach-agent $tcp_(45)
$ns at 0.2 "$ftp_(45) start"
$ns at 180.0 "$ftp_(45) stop"

#Set a TCP connection between node_(4) and node_(36)
set tcp_(46) [new Agent/TCP/Newreno]
$tcp_(46) set class_ 2
set sink_(46) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(46)
$ns attach-agent $node_(36) $sink_(46)
$ns connect $tcp_(46) $sink_(46)
set ftp_(46) [new Application/FTP]
$ftp_(46) attach-agent $tcp_(46)
$ns at 180.2 "$ftp_(46) start"
$ns at 360.0 "$ftp_(46) stop"

#Set a TCP connection between node_(15) and node_(44)
set tcp_(47) [new Agent/TCP/Newreno]
$tcp_(47) set class_ 2
set sink_(47) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(47)
$ns attach-agent $node_(44) $sink_(47)
$ns connect $tcp_(47) $sink_(47)
set ftp_(47) [new Application/FTP]
$ftp_(47) attach-agent $tcp_(47)
$ns at 360.2 "$ftp_(47) start"
$ns at 540.0 "$ftp_(47) stop"

#Set a TCP connection between node_(44) and node_(12)
set tcp_(48) [new Agent/TCP/Newreno]
$tcp_(48) set class_ 2
set sink_(48) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(48)
$ns attach-agent $node_(12) $sink_(48)
$ns connect $tcp_(48) $sink_(48)
set ftp_(48) [new Application/FTP]
$ftp_(48) attach-agent $tcp_(48)
$ns at 540.2 "$ftp_(48) start"
$ns at 720.0 "$ftp_(48) stop"

#Set a TCP connection between node_(44) and node_(38)
set tcp_(49) [new Agent/TCP/Newreno]
$tcp_(49) set class_ 2
set sink_(49) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(49)
$ns attach-agent $node_(38) $sink_(49)
$ns connect $tcp_(49) $sink_(49)
set ftp_(49) [new Application/FTP]
$ftp_(49) attach-agent $tcp_(49)
$ns at 720.2 "$ftp_(49) start"
$ns at 900.0 "$ftp_(49) stop"

#Set a TCP connection between node_(21) and node_(2)
set tcp_(50) [new Agent/TCP/Newreno]
$tcp_(50) set class_ 2
set sink_(50) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(50)
$ns attach-agent $node_(2) $sink_(50)
$ns connect $tcp_(50) $sink_(50)
set ftp_(50) [new Application/FTP]
$ftp_(50) attach-agent $tcp_(50)
$ns at 0.2 "$ftp_(50) start"
$ns at 180.0 "$ftp_(50) stop"

#Set a TCP connection between node_(26) and node_(20)
set tcp_(51) [new Agent/TCP/Newreno]
$tcp_(51) set class_ 2
set sink_(51) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(51)
$ns attach-agent $node_(20) $sink_(51)
$ns connect $tcp_(51) $sink_(51)
set ftp_(51) [new Application/FTP]
$ftp_(51) attach-agent $tcp_(51)
$ns at 180.2 "$ftp_(51) start"
$ns at 360.0 "$ftp_(51) stop"

#Set a TCP connection between node_(44) and node_(36)
set tcp_(52) [new Agent/TCP/Newreno]
$tcp_(52) set class_ 2
set sink_(52) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(52)
$ns attach-agent $node_(36) $sink_(52)
$ns connect $tcp_(52) $sink_(52)
set ftp_(52) [new Application/FTP]
$ftp_(52) attach-agent $tcp_(52)
$ns at 360.2 "$ftp_(52) start"
$ns at 540.0 "$ftp_(52) stop"

#Set a TCP connection between node_(22) and node_(24)
set tcp_(53) [new Agent/TCP/Newreno]
$tcp_(53) set class_ 2
set sink_(53) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(53)
$ns attach-agent $node_(24) $sink_(53)
$ns connect $tcp_(53) $sink_(53)
set ftp_(53) [new Application/FTP]
$ftp_(53) attach-agent $tcp_(53)
$ns at 540.2 "$ftp_(53) start"
$ns at 720.0 "$ftp_(53) stop"

#Set a TCP connection between node_(46) and node_(8)
set tcp_(54) [new Agent/TCP/Newreno]
$tcp_(54) set class_ 2
set sink_(54) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(54)
$ns attach-agent $node_(8) $sink_(54)
$ns connect $tcp_(54) $sink_(54)
set ftp_(54) [new Application/FTP]
$ftp_(54) attach-agent $tcp_(54)
$ns at 720.2 "$ftp_(54) start"
$ns at 900.0 "$ftp_(54) stop"

#Set a TCP connection between node_(47) and node_(41)
set tcp_(55) [new Agent/TCP/Newreno]
$tcp_(55) set class_ 2
set sink_(55) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(55)
$ns attach-agent $node_(41) $sink_(55)
$ns connect $tcp_(55) $sink_(55)
set ftp_(55) [new Application/FTP]
$ftp_(55) attach-agent $tcp_(55)
$ns at 0.2 "$ftp_(55) start"
$ns at 180.0 "$ftp_(55) stop"

#Set a TCP connection between node_(24) and node_(2)
set tcp_(56) [new Agent/TCP/Newreno]
$tcp_(56) set class_ 2
set sink_(56) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(56)
$ns attach-agent $node_(2) $sink_(56)
$ns connect $tcp_(56) $sink_(56)
set ftp_(56) [new Application/FTP]
$ftp_(56) attach-agent $tcp_(56)
$ns at 180.2 "$ftp_(56) start"
$ns at 360.0 "$ftp_(56) stop"

#Set a TCP connection between node_(0) and node_(17)
set tcp_(57) [new Agent/TCP/Newreno]
$tcp_(57) set class_ 2
set sink_(57) [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp_(57)
$ns attach-agent $node_(17) $sink_(57)
$ns connect $tcp_(57) $sink_(57)
set ftp_(57) [new Application/FTP]
$ftp_(57) attach-agent $tcp_(57)
$ns at 360.2 "$ftp_(57) start"
$ns at 540.0 "$ftp_(57) stop"

#Set a TCP connection between node_(30) and node_(48)
set tcp_(58) [new Agent/TCP/Newreno]
$tcp_(58) set class_ 2
set sink_(58) [new Agent/TCPSink]
$ns attach-agent $node_(30) $tcp_(58)
$ns attach-agent $node_(48) $sink_(58)
$ns connect $tcp_(58) $sink_(58)
set ftp_(58) [new Application/FTP]
$ftp_(58) attach-agent $tcp_(58)
$ns at 540.2 "$ftp_(58) start"
$ns at 720.0 "$ftp_(58) stop"

#Set a TCP connection between node_(38) and node_(30)
set tcp_(59) [new Agent/TCP/Newreno]
$tcp_(59) set class_ 2
set sink_(59) [new Agent/TCPSink]
$ns attach-agent $node_(38) $tcp_(59)
$ns attach-agent $node_(30) $sink_(59)
$ns connect $tcp_(59) $sink_(59)
set ftp_(59) [new Application/FTP]
$ftp_(59) attach-agent $tcp_(59)
$ns at 720.2 "$ftp_(59) start"
$ns at 900.0 "$ftp_(59) stop"

#Set a TCP connection between node_(1) and node_(42)
set tcp_(60) [new Agent/TCP/Newreno]
$tcp_(60) set class_ 2
set sink_(60) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(60)
$ns attach-agent $node_(42) $sink_(60)
$ns connect $tcp_(60) $sink_(60)
set ftp_(60) [new Application/FTP]
$ftp_(60) attach-agent $tcp_(60)
$ns at 0.2 "$ftp_(60) start"
$ns at 180.0 "$ftp_(60) stop"

#Set a TCP connection between node_(2) and node_(44)
set tcp_(61) [new Agent/TCP/Newreno]
$tcp_(61) set class_ 2
set sink_(61) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(61)
$ns attach-agent $node_(44) $sink_(61)
$ns connect $tcp_(61) $sink_(61)
set ftp_(61) [new Application/FTP]
$ftp_(61) attach-agent $tcp_(61)
$ns at 180.2 "$ftp_(61) start"
$ns at 360.0 "$ftp_(61) stop"

#Set a TCP connection between node_(43) and node_(49)
set tcp_(62) [new Agent/TCP/Newreno]
$tcp_(62) set class_ 2
set sink_(62) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(62)
$ns attach-agent $node_(49) $sink_(62)
$ns connect $tcp_(62) $sink_(62)
set ftp_(62) [new Application/FTP]
$ftp_(62) attach-agent $tcp_(62)
$ns at 360.2 "$ftp_(62) start"
$ns at 540.0 "$ftp_(62) stop"

#Set a TCP connection between node_(13) and node_(31)
set tcp_(63) [new Agent/TCP/Newreno]
$tcp_(63) set class_ 2
set sink_(63) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(63)
$ns attach-agent $node_(31) $sink_(63)
$ns connect $tcp_(63) $sink_(63)
set ftp_(63) [new Application/FTP]
$ftp_(63) attach-agent $tcp_(63)
$ns at 540.2 "$ftp_(63) start"
$ns at 720.0 "$ftp_(63) stop"

#Set a TCP connection between node_(25) and node_(20)
set tcp_(64) [new Agent/TCP/Newreno]
$tcp_(64) set class_ 2
set sink_(64) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(64)
$ns attach-agent $node_(20) $sink_(64)
$ns connect $tcp_(64) $sink_(64)
set ftp_(64) [new Application/FTP]
$ftp_(64) attach-agent $tcp_(64)
$ns at 720.2 "$ftp_(64) start"
$ns at 900.0 "$ftp_(64) stop"

#Set a TCP connection between node_(33) and node_(49)
set tcp_(65) [new Agent/TCP/Newreno]
$tcp_(65) set class_ 2
set sink_(65) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(65)
$ns attach-agent $node_(49) $sink_(65)
$ns connect $tcp_(65) $sink_(65)
set ftp_(65) [new Application/FTP]
$ftp_(65) attach-agent $tcp_(65)
$ns at 0.2 "$ftp_(65) start"
$ns at 180.0 "$ftp_(65) stop"

#Set a TCP connection between node_(4) and node_(7)
set tcp_(66) [new Agent/TCP/Newreno]
$tcp_(66) set class_ 2
set sink_(66) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(66)
$ns attach-agent $node_(7) $sink_(66)
$ns connect $tcp_(66) $sink_(66)
set ftp_(66) [new Application/FTP]
$ftp_(66) attach-agent $tcp_(66)
$ns at 180.2 "$ftp_(66) start"
$ns at 360.0 "$ftp_(66) stop"

#Set a TCP connection between node_(47) and node_(34)
set tcp_(67) [new Agent/TCP/Newreno]
$tcp_(67) set class_ 2
set sink_(67) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(67)
$ns attach-agent $node_(34) $sink_(67)
$ns connect $tcp_(67) $sink_(67)
set ftp_(67) [new Application/FTP]
$ftp_(67) attach-agent $tcp_(67)
$ns at 360.2 "$ftp_(67) start"
$ns at 540.0 "$ftp_(67) stop"

#Set a TCP connection between node_(15) and node_(4)
set tcp_(68) [new Agent/TCP/Newreno]
$tcp_(68) set class_ 2
set sink_(68) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(68)
$ns attach-agent $node_(4) $sink_(68)
$ns connect $tcp_(68) $sink_(68)
set ftp_(68) [new Application/FTP]
$ftp_(68) attach-agent $tcp_(68)
$ns at 540.2 "$ftp_(68) start"
$ns at 720.0 "$ftp_(68) stop"

#Set a TCP connection between node_(43) and node_(27)
set tcp_(69) [new Agent/TCP/Newreno]
$tcp_(69) set class_ 2
set sink_(69) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(69)
$ns attach-agent $node_(27) $sink_(69)
$ns connect $tcp_(69) $sink_(69)
set ftp_(69) [new Application/FTP]
$ftp_(69) attach-agent $tcp_(69)
$ns at 720.2 "$ftp_(69) start"
$ns at 900.0 "$ftp_(69) stop"

#Set a TCP connection between node_(12) and node_(33)
set tcp_(70) [new Agent/TCP/Newreno]
$tcp_(70) set class_ 2
set sink_(70) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(70)
$ns attach-agent $node_(33) $sink_(70)
$ns connect $tcp_(70) $sink_(70)
set ftp_(70) [new Application/FTP]
$ftp_(70) attach-agent $tcp_(70)
$ns at 0.2 "$ftp_(70) start"
$ns at 180.0 "$ftp_(70) stop"

#Set a TCP connection between node_(2) and node_(46)
set tcp_(71) [new Agent/TCP/Newreno]
$tcp_(71) set class_ 2
set sink_(71) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(71)
$ns attach-agent $node_(46) $sink_(71)
$ns connect $tcp_(71) $sink_(71)
set ftp_(71) [new Application/FTP]
$ftp_(71) attach-agent $tcp_(71)
$ns at 180.2 "$ftp_(71) start"
$ns at 360.0 "$ftp_(71) stop"

#Set a TCP connection between node_(19) and node_(12)
set tcp_(72) [new Agent/TCP/Newreno]
$tcp_(72) set class_ 2
set sink_(72) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(72)
$ns attach-agent $node_(12) $sink_(72)
$ns connect $tcp_(72) $sink_(72)
set ftp_(72) [new Application/FTP]
$ftp_(72) attach-agent $tcp_(72)
$ns at 360.2 "$ftp_(72) start"
$ns at 540.0 "$ftp_(72) stop"

#Set a TCP connection between node_(36) and node_(27)
set tcp_(73) [new Agent/TCP/Newreno]
$tcp_(73) set class_ 2
set sink_(73) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(73)
$ns attach-agent $node_(27) $sink_(73)
$ns connect $tcp_(73) $sink_(73)
set ftp_(73) [new Application/FTP]
$ftp_(73) attach-agent $tcp_(73)
$ns at 540.2 "$ftp_(73) start"
$ns at 720.0 "$ftp_(73) stop"

#Set a TCP connection between node_(36) and node_(45)
set tcp_(74) [new Agent/TCP/Newreno]
$tcp_(74) set class_ 2
set sink_(74) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(74)
$ns attach-agent $node_(45) $sink_(74)
$ns connect $tcp_(74) $sink_(74)
set ftp_(74) [new Application/FTP]
$ftp_(74) attach-agent $tcp_(74)
$ns at 720.2 "$ftp_(74) start"
$ns at 900.0 "$ftp_(74) stop"

#Set a TCP connection between node_(18) and node_(8)
set tcp_(75) [new Agent/TCP/Newreno]
$tcp_(75) set class_ 2
set sink_(75) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(75)
$ns attach-agent $node_(8) $sink_(75)
$ns connect $tcp_(75) $sink_(75)
set ftp_(75) [new Application/FTP]
$ftp_(75) attach-agent $tcp_(75)
$ns at 0.2 "$ftp_(75) start"
$ns at 180.0 "$ftp_(75) stop"

#Set a TCP connection between node_(6) and node_(31)
set tcp_(76) [new Agent/TCP/Newreno]
$tcp_(76) set class_ 2
set sink_(76) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(76)
$ns attach-agent $node_(31) $sink_(76)
$ns connect $tcp_(76) $sink_(76)
set ftp_(76) [new Application/FTP]
$ftp_(76) attach-agent $tcp_(76)
$ns at 180.2 "$ftp_(76) start"
$ns at 360.0 "$ftp_(76) stop"

#Set a TCP connection between node_(42) and node_(41)
set tcp_(77) [new Agent/TCP/Newreno]
$tcp_(77) set class_ 2
set sink_(77) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(77)
$ns attach-agent $node_(41) $sink_(77)
$ns connect $tcp_(77) $sink_(77)
set ftp_(77) [new Application/FTP]
$ftp_(77) attach-agent $tcp_(77)
$ns at 360.2 "$ftp_(77) start"
$ns at 540.0 "$ftp_(77) stop"

#Set a TCP connection between node_(40) and node_(38)
set tcp_(78) [new Agent/TCP/Newreno]
$tcp_(78) set class_ 2
set sink_(78) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(78)
$ns attach-agent $node_(38) $sink_(78)
$ns connect $tcp_(78) $sink_(78)
set ftp_(78) [new Application/FTP]
$ftp_(78) attach-agent $tcp_(78)
$ns at 540.2 "$ftp_(78) start"
$ns at 720.0 "$ftp_(78) stop"

#Set a TCP connection between node_(35) and node_(44)
set tcp_(79) [new Agent/TCP/Newreno]
$tcp_(79) set class_ 2
set sink_(79) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(79)
$ns attach-agent $node_(44) $sink_(79)
$ns connect $tcp_(79) $sink_(79)
set ftp_(79) [new Application/FTP]
$ftp_(79) attach-agent $tcp_(79)
$ns at 720.2 "$ftp_(79) start"
$ns at 900.0 "$ftp_(79) stop"

#Set a TCP connection between node_(27) and node_(12)
set tcp_(80) [new Agent/TCP/Newreno]
$tcp_(80) set class_ 2
set sink_(80) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(80)
$ns attach-agent $node_(12) $sink_(80)
$ns connect $tcp_(80) $sink_(80)
set ftp_(80) [new Application/FTP]
$ftp_(80) attach-agent $tcp_(80)
$ns at 0.2 "$ftp_(80) start"
$ns at 180.0 "$ftp_(80) stop"

#Set a TCP connection between node_(23) and node_(13)
set tcp_(81) [new Agent/TCP/Newreno]
$tcp_(81) set class_ 2
set sink_(81) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(81)
$ns attach-agent $node_(13) $sink_(81)
$ns connect $tcp_(81) $sink_(81)
set ftp_(81) [new Application/FTP]
$ftp_(81) attach-agent $tcp_(81)
$ns at 180.2 "$ftp_(81) start"
$ns at 360.0 "$ftp_(81) stop"

#Set a TCP connection between node_(41) and node_(10)
set tcp_(82) [new Agent/TCP/Newreno]
$tcp_(82) set class_ 2
set sink_(82) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(82)
$ns attach-agent $node_(10) $sink_(82)
$ns connect $tcp_(82) $sink_(82)
set ftp_(82) [new Application/FTP]
$ftp_(82) attach-agent $tcp_(82)
$ns at 360.2 "$ftp_(82) start"
$ns at 540.0 "$ftp_(82) stop"

#Set a TCP connection between node_(10) and node_(44)
set tcp_(83) [new Agent/TCP/Newreno]
$tcp_(83) set class_ 2
set sink_(83) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(83)
$ns attach-agent $node_(44) $sink_(83)
$ns connect $tcp_(83) $sink_(83)
set ftp_(83) [new Application/FTP]
$ftp_(83) attach-agent $tcp_(83)
$ns at 540.2 "$ftp_(83) start"
$ns at 720.0 "$ftp_(83) stop"

#Set a TCP connection between node_(43) and node_(46)
set tcp_(84) [new Agent/TCP/Newreno]
$tcp_(84) set class_ 2
set sink_(84) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(84)
$ns attach-agent $node_(46) $sink_(84)
$ns connect $tcp_(84) $sink_(84)
set ftp_(84) [new Application/FTP]
$ftp_(84) attach-agent $tcp_(84)
$ns at 720.2 "$ftp_(84) start"
$ns at 900.0 "$ftp_(84) stop"

#Set a TCP connection between node_(35) and node_(1)
set tcp_(85) [new Agent/TCP/Newreno]
$tcp_(85) set class_ 2
set sink_(85) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(85)
$ns attach-agent $node_(1) $sink_(85)
$ns connect $tcp_(85) $sink_(85)
set ftp_(85) [new Application/FTP]
$ftp_(85) attach-agent $tcp_(85)
$ns at 0.2 "$ftp_(85) start"
$ns at 180.0 "$ftp_(85) stop"

#Set a TCP connection between node_(45) and node_(33)
set tcp_(86) [new Agent/TCP/Newreno]
$tcp_(86) set class_ 2
set sink_(86) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(86)
$ns attach-agent $node_(33) $sink_(86)
$ns connect $tcp_(86) $sink_(86)
set ftp_(86) [new Application/FTP]
$ftp_(86) attach-agent $tcp_(86)
$ns at 180.2 "$ftp_(86) start"
$ns at 360.0 "$ftp_(86) stop"

#Set a TCP connection between node_(32) and node_(18)
set tcp_(87) [new Agent/TCP/Newreno]
$tcp_(87) set class_ 2
set sink_(87) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(87)
$ns attach-agent $node_(18) $sink_(87)
$ns connect $tcp_(87) $sink_(87)
set ftp_(87) [new Application/FTP]
$ftp_(87) attach-agent $tcp_(87)
$ns at 360.2 "$ftp_(87) start"
$ns at 540.0 "$ftp_(87) stop"

#Set a TCP connection between node_(7) and node_(9)
set tcp_(88) [new Agent/TCP/Newreno]
$tcp_(88) set class_ 2
set sink_(88) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(88)
$ns attach-agent $node_(9) $sink_(88)
$ns connect $tcp_(88) $sink_(88)
set ftp_(88) [new Application/FTP]
$ftp_(88) attach-agent $tcp_(88)
$ns at 540.2 "$ftp_(88) start"
$ns at 720.0 "$ftp_(88) stop"

#Set a TCP connection between node_(10) and node_(13)
set tcp_(89) [new Agent/TCP/Newreno]
$tcp_(89) set class_ 2
set sink_(89) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(89)
$ns attach-agent $node_(13) $sink_(89)
$ns connect $tcp_(89) $sink_(89)
set ftp_(89) [new Application/FTP]
$ftp_(89) attach-agent $tcp_(89)
$ns at 720.2 "$ftp_(89) start"
$ns at 900.0 "$ftp_(89) stop"

#Set a TCP connection between node_(39) and node_(25)
set tcp_(90) [new Agent/TCP/Newreno]
$tcp_(90) set class_ 2
set sink_(90) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(90)
$ns attach-agent $node_(25) $sink_(90)
$ns connect $tcp_(90) $sink_(90)
set ftp_(90) [new Application/FTP]
$ftp_(90) attach-agent $tcp_(90)
$ns at 0.2 "$ftp_(90) start"
$ns at 180.0 "$ftp_(90) stop"

#Set a TCP connection between node_(22) and node_(16)
set tcp_(91) [new Agent/TCP/Newreno]
$tcp_(91) set class_ 2
set sink_(91) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(91)
$ns attach-agent $node_(16) $sink_(91)
$ns connect $tcp_(91) $sink_(91)
set ftp_(91) [new Application/FTP]
$ftp_(91) attach-agent $tcp_(91)
$ns at 180.2 "$ftp_(91) start"
$ns at 360.0 "$ftp_(91) stop"

#Set a TCP connection between node_(12) and node_(36)
set tcp_(92) [new Agent/TCP/Newreno]
$tcp_(92) set class_ 2
set sink_(92) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(92)
$ns attach-agent $node_(36) $sink_(92)
$ns connect $tcp_(92) $sink_(92)
set ftp_(92) [new Application/FTP]
$ftp_(92) attach-agent $tcp_(92)
$ns at 360.2 "$ftp_(92) start"
$ns at 540.0 "$ftp_(92) stop"

#Set a TCP connection between node_(37) and node_(8)
set tcp_(93) [new Agent/TCP/Newreno]
$tcp_(93) set class_ 2
set sink_(93) [new Agent/TCPSink]
$ns attach-agent $node_(37) $tcp_(93)
$ns attach-agent $node_(8) $sink_(93)
$ns connect $tcp_(93) $sink_(93)
set ftp_(93) [new Application/FTP]
$ftp_(93) attach-agent $tcp_(93)
$ns at 540.2 "$ftp_(93) start"
$ns at 720.0 "$ftp_(93) stop"

#Set a TCP connection between node_(45) and node_(33)
set tcp_(94) [new Agent/TCP/Newreno]
$tcp_(94) set class_ 2
set sink_(94) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(94)
$ns attach-agent $node_(33) $sink_(94)
$ns connect $tcp_(94) $sink_(94)
set ftp_(94) [new Application/FTP]
$ftp_(94) attach-agent $tcp_(94)
$ns at 720.2 "$ftp_(94) start"
$ns at 900.0 "$ftp_(94) stop"

#Set a TCP connection between node_(47) and node_(44)
set tcp_(95) [new Agent/TCP/Newreno]
$tcp_(95) set class_ 2
set sink_(95) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(95)
$ns attach-agent $node_(44) $sink_(95)
$ns connect $tcp_(95) $sink_(95)
set ftp_(95) [new Application/FTP]
$ftp_(95) attach-agent $tcp_(95)
$ns at 0.2 "$ftp_(95) start"
$ns at 180.0 "$ftp_(95) stop"

#Set a TCP connection between node_(35) and node_(5)
set tcp_(96) [new Agent/TCP/Newreno]
$tcp_(96) set class_ 2
set sink_(96) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(96)
$ns attach-agent $node_(5) $sink_(96)
$ns connect $tcp_(96) $sink_(96)
set ftp_(96) [new Application/FTP]
$ftp_(96) attach-agent $tcp_(96)
$ns at 180.2 "$ftp_(96) start"
$ns at 360.0 "$ftp_(96) stop"

#Set a TCP connection between node_(31) and node_(14)
set tcp_(97) [new Agent/TCP/Newreno]
$tcp_(97) set class_ 2
set sink_(97) [new Agent/TCPSink]
$ns attach-agent $node_(31) $tcp_(97)
$ns attach-agent $node_(14) $sink_(97)
$ns connect $tcp_(97) $sink_(97)
set ftp_(97) [new Application/FTP]
$ftp_(97) attach-agent $tcp_(97)
$ns at 360.2 "$ftp_(97) start"
$ns at 540.0 "$ftp_(97) stop"

#Set a TCP connection between node_(23) and node_(34)
set tcp_(98) [new Agent/TCP/Newreno]
$tcp_(98) set class_ 2
set sink_(98) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(98)
$ns attach-agent $node_(34) $sink_(98)
$ns connect $tcp_(98) $sink_(98)
set ftp_(98) [new Application/FTP]
$ftp_(98) attach-agent $tcp_(98)
$ns at 540.2 "$ftp_(98) start"
$ns at 720.0 "$ftp_(98) stop"

#Set a TCP connection between node_(1) and node_(23)
set tcp_(99) [new Agent/TCP/Newreno]
$tcp_(99) set class_ 2
set sink_(99) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(99)
$ns attach-agent $node_(23) $sink_(99)
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
