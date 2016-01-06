#sim-scn2-5.tcl 
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
set tracefd       [open sim-scn2-5-$val(rp)-trace.tr w]
set windowVsTime2 [open sim-scn2-5-$val(rp)-win-.tr w]
set namtrace      [open sim-scn2-5-$val(rp).nam w]

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
$node_(0) set X_ 628 
$node_(0) set Y_ 389 
$node_(0) set Z_ 0.0 
$node_(1) set X_ 330 
$node_(1) set Y_ 792 
$node_(1) set Z_ 0.0 
$node_(2) set X_ 2786 
$node_(2) set Y_ 909 
$node_(2) set Z_ 0.0 
$node_(3) set X_ 1013 
$node_(3) set Y_ 899 
$node_(3) set Z_ 0.0 
$node_(4) set X_ 1140 
$node_(4) set Y_ 598 
$node_(4) set Z_ 0.0 
$node_(5) set X_ 1630 
$node_(5) set Y_ 100 
$node_(5) set Z_ 0.0 
$node_(6) set X_ 2817 
$node_(6) set Y_ 266 
$node_(6) set Z_ 0.0 
$node_(7) set X_ 1781 
$node_(7) set Y_ 383 
$node_(7) set Z_ 0.0 
$node_(8) set X_ 686 
$node_(8) set Y_ 824 
$node_(8) set Z_ 0.0 
$node_(9) set X_ 1453 
$node_(9) set Y_ 877 
$node_(9) set Z_ 0.0 
$node_(10) set X_ 1808 
$node_(10) set Y_ 969 
$node_(10) set Z_ 0.0 
$node_(11) set X_ 1410 
$node_(11) set Y_ 252 
$node_(11) set Z_ 0.0 
$node_(12) set X_ 951 
$node_(12) set Y_ 674 
$node_(12) set Z_ 0.0 
$node_(13) set X_ 1547 
$node_(13) set Y_ 306 
$node_(13) set Z_ 0.0 
$node_(14) set X_ 2783 
$node_(14) set Y_ 238 
$node_(14) set Z_ 0.0 
$node_(15) set X_ 703 
$node_(15) set Y_ 56 
$node_(15) set Z_ 0.0 
$node_(16) set X_ 578 
$node_(16) set Y_ 761 
$node_(16) set Z_ 0.0 
$node_(17) set X_ 2414 
$node_(17) set Y_ 436 
$node_(17) set Z_ 0.0 
$node_(18) set X_ 2699 
$node_(18) set Y_ 723 
$node_(18) set Z_ 0.0 
$node_(19) set X_ 1721 
$node_(19) set Y_ 723 
$node_(19) set Z_ 0.0 
$node_(20) set X_ 1788 
$node_(20) set Y_ 732 
$node_(20) set Z_ 0.0 
$node_(21) set X_ 556 
$node_(21) set Y_ 917 
$node_(21) set Z_ 0.0 
$node_(22) set X_ 452 
$node_(22) set Y_ 641 
$node_(22) set Z_ 0.0 
$node_(23) set X_ 341 
$node_(23) set Y_ 622 
$node_(23) set Z_ 0.0 
$node_(24) set X_ 1343 
$node_(24) set Y_ 946 
$node_(24) set Z_ 0.0 
$node_(25) set X_ 1252 
$node_(25) set Y_ 405 
$node_(25) set Z_ 0.0 
$node_(26) set X_ 830 
$node_(26) set Y_ 814 
$node_(26) set Z_ 0.0 
$node_(27) set X_ 1150 
$node_(27) set Y_ 222 
$node_(27) set Z_ 0.0 
$node_(28) set X_ 1995 
$node_(28) set Y_ 111 
$node_(28) set Z_ 0.0 
$node_(29) set X_ 1449 
$node_(29) set Y_ 279 
$node_(29) set Z_ 0.0 
$node_(30) set X_ 1440 
$node_(30) set Y_ 561 
$node_(30) set Z_ 0.0 
$node_(31) set X_ 2164 
$node_(31) set Y_ 588 
$node_(31) set Z_ 0.0 
$node_(32) set X_ 339 
$node_(32) set Y_ 484 
$node_(32) set Z_ 0.0 
$node_(33) set X_ 104 
$node_(33) set Y_ 567 
$node_(33) set Z_ 0.0 
$node_(34) set X_ 1389 
$node_(34) set Y_ 657 
$node_(34) set Z_ 0.0 
$node_(35) set X_ 2569 
$node_(35) set Y_ 271 
$node_(35) set Z_ 0.0 
$node_(36) set X_ 695 
$node_(36) set Y_ 451 
$node_(36) set Z_ 0.0 
$node_(37) set X_ 1076 
$node_(37) set Y_ 217 
$node_(37) set Z_ 0.0 
$node_(38) set X_ 2237 
$node_(38) set Y_ 811 
$node_(38) set Z_ 0.0 
$node_(39) set X_ 473 
$node_(39) set Y_ 317 
$node_(39) set Z_ 0.0 
$node_(40) set X_ 457 
$node_(40) set Y_ 579 
$node_(40) set Z_ 0.0 
$node_(41) set X_ 1402 
$node_(41) set Y_ 121 
$node_(41) set Z_ 0.0 
$node_(42) set X_ 2508 
$node_(42) set Y_ 368 
$node_(42) set Z_ 0.0 
$node_(43) set X_ 2351 
$node_(43) set Y_ 458 
$node_(43) set Z_ 0.0 
$node_(44) set X_ 1029 
$node_(44) set Y_ 461 
$node_(44) set Z_ 0.0 
$node_(45) set X_ 544 
$node_(45) set Y_ 527 
$node_(45) set Z_ 0.0 
$node_(46) set X_ 2789 
$node_(46) set Y_ 200 
$node_(46) set Z_ 0.0 
$node_(47) set X_ 680 
$node_(47) set Y_ 721 
$node_(47) set Z_ 0.0 
$node_(48) set X_ 270 
$node_(48) set Y_ 951 
$node_(48) set Z_ 0.0 
$node_(49) set X_ 952 
$node_(49) set Y_ 731 
$node_(49) set Z_ 0.0 
$node_(50) set X_ 183 
$node_(50) set Y_ 987 
$node_(50) set Z_ 0.0 
$node_(51) set X_ 2960 
$node_(51) set Y_ 998 
$node_(51) set Z_ 0.0 
$ns at 0.0 "$node_(51) off" 
$ns at 165.0 "$node_(51) on" 
$node_(52) set X_ 1090 
$node_(52) set Y_ 607 
$node_(52) set Z_ 0.0 
$ns at 0.0 "$node_(52) off" 
$ns at 165.0 "$node_(52) on" 
$node_(53) set X_ 1036 
$node_(53) set Y_ 209 
$node_(53) set Z_ 0.0 
$ns at 0.0 "$node_(53) off" 
$ns at 165.0 "$node_(53) on" 
$node_(54) set X_ 2649 
$node_(54) set Y_ 345 
$node_(54) set Z_ 0.0 
$ns at 0.0 "$node_(54) off" 
$ns at 165.0 "$node_(54) on" 
$node_(55) set X_ 1083 
$node_(55) set Y_ 325 
$node_(55) set Z_ 0.0 
$ns at 0.0 "$node_(55) off" 
$ns at 165.0 "$node_(55) on" 
$node_(56) set X_ 2611 
$node_(56) set Y_ 430 
$node_(56) set Z_ 0.0 
$ns at 0.0 "$node_(56) off" 
$ns at 165.0 "$node_(56) on" 
$node_(57) set X_ 373 
$node_(57) set Y_ 565 
$node_(57) set Z_ 0.0 
$ns at 0.0 "$node_(57) off" 
$ns at 165.0 "$node_(57) on" 
$node_(58) set X_ 1514 
$node_(58) set Y_ 509 
$node_(58) set Z_ 0.0 
$ns at 0.0 "$node_(58) off" 
$ns at 165.0 "$node_(58) on" 
$node_(59) set X_ 1787 
$node_(59) set Y_ 915 
$node_(59) set Z_ 0.0 
$ns at 0.0 "$node_(59) off" 
$ns at 165.0 "$node_(59) on" 
$node_(60) set X_ 1028 
$node_(60) set Y_ 236 
$node_(60) set Z_ 0.0 
$ns at 0.0 "$node_(60) off" 
$ns at 165.0 "$node_(60) on" 
$node_(61) set X_ 1756 
$node_(61) set Y_ 946 
$node_(61) set Z_ 0.0 
$ns at 0.0 "$node_(61) off" 
$ns at 165.0 "$node_(61) on" 
$node_(62) set X_ 172 
$node_(62) set Y_ 535 
$node_(62) set Z_ 0.0 
$ns at 0.0 "$node_(62) off" 
$ns at 165.0 "$node_(62) on" 
$node_(63) set X_ 2630 
$node_(63) set Y_ 186 
$node_(63) set Z_ 0.0 
$ns at 0.0 "$node_(63) off" 
$ns at 165.0 "$node_(63) on" 
$node_(64) set X_ 1090 
$node_(64) set Y_ 227 
$node_(64) set Z_ 0.0 
$ns at 0.0 "$node_(64) off" 
$ns at 165.0 "$node_(64) on" 
$node_(65) set X_ 1413 
$node_(65) set Y_ 829 
$node_(65) set Z_ 0.0 
$ns at 0.0 "$node_(65) off" 
$ns at 165.0 "$node_(65) on" 
$node_(66) set X_ 2750 
$node_(66) set Y_ 210 
$node_(66) set Z_ 0.0 
$ns at 0.0 "$node_(66) off" 
$ns at 165.0 "$node_(66) on" 
$node_(67) set X_ 2725 
$node_(67) set Y_ 331 
$node_(67) set Z_ 0.0 
$ns at 0.0 "$node_(67) off" 
$ns at 165.0 "$node_(67) on" 
$node_(68) set X_ 843 
$node_(68) set Y_ 616 
$node_(68) set Z_ 0.0 
$ns at 0.0 "$node_(68) off" 
$ns at 165.0 "$node_(68) on" 
$node_(69) set X_ 1488 
$node_(69) set Y_ 306 
$node_(69) set Z_ 0.0 
$ns at 0.0 "$node_(69) off" 
$ns at 165.0 "$node_(69) on" 
$node_(70) set X_ 2282 
$node_(70) set Y_ 151 
$node_(70) set Z_ 0.0 
$ns at 0.0 "$node_(70) off" 
$ns at 165.0 "$node_(70) on" 
$node_(71) set X_ 185 
$node_(71) set Y_ 179 
$node_(71) set Z_ 0.0 
$ns at 0.0 "$node_(71) off" 
$ns at 165.0 "$node_(71) on" 
$node_(72) set X_ 40 
$node_(72) set Y_ 371 
$node_(72) set Z_ 0.0 
$ns at 0.0 "$node_(72) off" 
$ns at 165.0 "$node_(72) on" 
$node_(73) set X_ 1634 
$node_(73) set Y_ 279 
$node_(73) set Z_ 0.0 
$ns at 0.0 "$node_(73) off" 
$ns at 165.0 "$node_(73) on" 
$node_(74) set X_ 2641 
$node_(74) set Y_ 777 
$node_(74) set Z_ 0.0 
$ns at 0.0 "$node_(74) off" 
$ns at 165.0 "$node_(74) on" 
$node_(75) set X_ 998 
$node_(75) set Y_ 375 
$node_(75) set Z_ 0.0 
$ns at 0.0 "$node_(75) off" 
$ns at 330.0 "$node_(75) on" 
$node_(76) set X_ 2368 
$node_(76) set Y_ 410 
$node_(76) set Z_ 0.0 
$ns at 0.0 "$node_(76) off" 
$ns at 330.0 "$node_(76) on" 
$node_(77) set X_ 2283 
$node_(77) set Y_ 197 
$node_(77) set Z_ 0.0 
$ns at 0.0 "$node_(77) off" 
$ns at 330.0 "$node_(77) on" 
$node_(78) set X_ 1291 
$node_(78) set Y_ 129 
$node_(78) set Z_ 0.0 
$ns at 0.0 "$node_(78) off" 
$ns at 330.0 "$node_(78) on" 
$node_(79) set X_ 1793 
$node_(79) set Y_ 149 
$node_(79) set Z_ 0.0 
$ns at 0.0 "$node_(79) off" 
$ns at 330.0 "$node_(79) on" 
$node_(80) set X_ 401 
$node_(80) set Y_ 840 
$node_(80) set Z_ 0.0 
$ns at 0.0 "$node_(80) off" 
$ns at 330.0 "$node_(80) on" 
$node_(81) set X_ 1970 
$node_(81) set Y_ 232 
$node_(81) set Z_ 0.0 
$ns at 0.0 "$node_(81) off" 
$ns at 330.0 "$node_(81) on" 
$node_(82) set X_ 1600 
$node_(82) set Y_ 736 
$node_(82) set Z_ 0.0 
$ns at 0.0 "$node_(82) off" 
$ns at 330.0 "$node_(82) on" 
$node_(83) set X_ 2727 
$node_(83) set Y_ 195 
$node_(83) set Z_ 0.0 
$ns at 0.0 "$node_(83) off" 
$ns at 330.0 "$node_(83) on" 
$node_(84) set X_ 1923 
$node_(84) set Y_ 65 
$node_(84) set Z_ 0.0 
$ns at 0.0 "$node_(84) off" 
$ns at 330.0 "$node_(84) on" 
$node_(85) set X_ 1761 
$node_(85) set Y_ 51 
$node_(85) set Z_ 0.0 
$ns at 0.0 "$node_(85) off" 
$ns at 330.0 "$node_(85) on" 
$node_(86) set X_ 1275 
$node_(86) set Y_ 982 
$node_(86) set Z_ 0.0 
$ns at 0.0 "$node_(86) off" 
$ns at 330.0 "$node_(86) on" 
$node_(87) set X_ 2432 
$node_(87) set Y_ 419 
$node_(87) set Z_ 0.0 
$ns at 0.0 "$node_(87) off" 
$ns at 330.0 "$node_(87) on" 
$node_(88) set X_ 1031 
$node_(88) set Y_ 846 
$node_(88) set Z_ 0.0 
$ns at 0.0 "$node_(88) off" 
$ns at 330.0 "$node_(88) on" 
$node_(89) set X_ 656 
$node_(89) set Y_ 555 
$node_(89) set Z_ 0.0 
$ns at 0.0 "$node_(89) off" 
$ns at 330.0 "$node_(89) on" 
$node_(90) set X_ 172 
$node_(90) set Y_ 687 
$node_(90) set Z_ 0.0 
$ns at 0.0 "$node_(90) off" 
$ns at 330.0 "$node_(90) on" 
$node_(91) set X_ 2757 
$node_(91) set Y_ 594 
$node_(91) set Z_ 0.0 
$ns at 0.0 "$node_(91) off" 
$ns at 330.0 "$node_(91) on" 
$node_(92) set X_ 2163 
$node_(92) set Y_ 640 
$node_(92) set Z_ 0.0 
$ns at 0.0 "$node_(92) off" 
$ns at 330.0 "$node_(92) on" 
$node_(93) set X_ 2538 
$node_(93) set Y_ 252 
$node_(93) set Z_ 0.0 
$ns at 0.0 "$node_(93) off" 
$ns at 330.0 "$node_(93) on" 
$node_(94) set X_ 2516 
$node_(94) set Y_ 862 
$node_(94) set Z_ 0.0 
$ns at 0.0 "$node_(94) off" 
$ns at 330.0 "$node_(94) on" 
$node_(95) set X_ 768 
$node_(95) set Y_ 169 
$node_(95) set Z_ 0.0 
$ns at 0.0 "$node_(95) off" 
$ns at 330.0 "$node_(95) on" 
$node_(96) set X_ 1959 
$node_(96) set Y_ 815 
$node_(96) set Z_ 0.0 
$ns at 0.0 "$node_(96) off" 
$ns at 330.0 "$node_(96) on" 
$node_(97) set X_ 2022 
$node_(97) set Y_ 147 
$node_(97) set Z_ 0.0 
$ns at 0.0 "$node_(97) off" 
$ns at 330.0 "$node_(97) on" 
$node_(98) set X_ 1317 
$node_(98) set Y_ 830 
$node_(98) set Z_ 0.0 
$ns at 0.0 "$node_(98) off" 
$ns at 330.0 "$node_(98) on" 
$node_(99) set X_ 210 
$node_(99) set Y_ 774 
$node_(99) set Z_ 0.0 
$ns at 0.0 "$node_(99) off" 
$ns at 330.0 "$node_(99) on" 
$node_(100) set X_ 2606 
$node_(100) set Y_ 551 
$node_(100) set Z_ 0.0 
$ns at 0.0 "$node_(100) off" 
$ns at 495.0 "$node_(100) on" 
$node_(101) set X_ 1276 
$node_(101) set Y_ 297 
$node_(101) set Z_ 0.0 
$ns at 0.0 "$node_(101) off" 
$ns at 495.0 "$node_(101) on" 
$node_(102) set X_ 2492 
$node_(102) set Y_ 188 
$node_(102) set Z_ 0.0 
$ns at 0.0 "$node_(102) off" 
$ns at 495.0 "$node_(102) on" 
$node_(103) set X_ 406 
$node_(103) set Y_ 173 
$node_(103) set Z_ 0.0 
$ns at 0.0 "$node_(103) off" 
$ns at 495.0 "$node_(103) on" 
$node_(104) set X_ 2066 
$node_(104) set Y_ 531 
$node_(104) set Z_ 0.0 
$ns at 0.0 "$node_(104) off" 
$ns at 495.0 "$node_(104) on" 
$node_(105) set X_ 2671 
$node_(105) set Y_ 416 
$node_(105) set Z_ 0.0 
$ns at 0.0 "$node_(105) off" 
$ns at 495.0 "$node_(105) on" 
$node_(106) set X_ 2992 
$node_(106) set Y_ 302 
$node_(106) set Z_ 0.0 
$ns at 0.0 "$node_(106) off" 
$ns at 495.0 "$node_(106) on" 
$node_(107) set X_ 2303 
$node_(107) set Y_ 695 
$node_(107) set Z_ 0.0 
$ns at 0.0 "$node_(107) off" 
$ns at 495.0 "$node_(107) on" 
$node_(108) set X_ 344 
$node_(108) set Y_ 741 
$node_(108) set Z_ 0.0 
$ns at 0.0 "$node_(108) off" 
$ns at 495.0 "$node_(108) on" 
$node_(109) set X_ 846 
$node_(109) set Y_ 199 
$node_(109) set Z_ 0.0 
$ns at 0.0 "$node_(109) off" 
$ns at 495.0 "$node_(109) on" 
$node_(110) set X_ 2936 
$node_(110) set Y_ 308 
$node_(110) set Z_ 0.0 
$ns at 0.0 "$node_(110) off" 
$ns at 495.0 "$node_(110) on" 
$node_(111) set X_ 133 
$node_(111) set Y_ 404 
$node_(111) set Z_ 0.0 
$ns at 0.0 "$node_(111) off" 
$ns at 495.0 "$node_(111) on" 
$node_(112) set X_ 1698 
$node_(112) set Y_ 961 
$node_(112) set Z_ 0.0 
$ns at 0.0 "$node_(112) off" 
$ns at 495.0 "$node_(112) on" 
$node_(113) set X_ 1513 
$node_(113) set Y_ 228 
$node_(113) set Z_ 0.0 
$ns at 0.0 "$node_(113) off" 
$ns at 495.0 "$node_(113) on" 
$node_(114) set X_ 554 
$node_(114) set Y_ 806 
$node_(114) set Z_ 0.0 
$ns at 0.0 "$node_(114) off" 
$ns at 495.0 "$node_(114) on" 
$node_(115) set X_ 2899 
$node_(115) set Y_ 542 
$node_(115) set Z_ 0.0 
$ns at 0.0 "$node_(115) off" 
$ns at 495.0 "$node_(115) on" 
$node_(116) set X_ 2438 
$node_(116) set Y_ 785 
$node_(116) set Z_ 0.0 
$ns at 0.0 "$node_(116) off" 
$ns at 495.0 "$node_(116) on" 
$node_(117) set X_ 2121 
$node_(117) set Y_ 629 
$node_(117) set Z_ 0.0 
$ns at 0.0 "$node_(117) off" 
$ns at 495.0 "$node_(117) on" 
$node_(118) set X_ 447 
$node_(118) set Y_ 724 
$node_(118) set Z_ 0.0 
$ns at 0.0 "$node_(118) off" 
$ns at 495.0 "$node_(118) on" 
$node_(119) set X_ 1659 
$node_(119) set Y_ 995 
$node_(119) set Z_ 0.0 
$ns at 0.0 "$node_(119) off" 
$ns at 495.0 "$node_(119) on" 
$node_(120) set X_ 2721 
$node_(120) set Y_ 251 
$node_(120) set Z_ 0.0 
$ns at 0.0 "$node_(120) off" 
$ns at 495.0 "$node_(120) on" 
$node_(121) set X_ 2181 
$node_(121) set Y_ 862 
$node_(121) set Z_ 0.0 
$ns at 0.0 "$node_(121) off" 
$ns at 495.0 "$node_(121) on" 
$node_(122) set X_ 458 
$node_(122) set Y_ 46 
$node_(122) set Z_ 0.0 
$ns at 0.0 "$node_(122) off" 
$ns at 495.0 "$node_(122) on" 
$node_(123) set X_ 312 
$node_(123) set Y_ 815 
$node_(123) set Z_ 0.0 
$ns at 0.0 "$node_(123) off" 
$ns at 495.0 "$node_(123) on" 
$node_(124) set X_ 498 
$node_(124) set Y_ 408 
$node_(124) set Z_ 0.0 
$ns at 0.0 "$node_(124) off" 
$ns at 495.0 "$node_(124) on" 
$node_(125) set X_ 885 
$node_(125) set Y_ 293 
$node_(125) set Z_ 0.0 
$ns at 0.0 "$node_(125) off" 
$ns at 660.0 "$node_(125) on" 
$node_(126) set X_ 1163 
$node_(126) set Y_ 365 
$node_(126) set Z_ 0.0 
$ns at 0.0 "$node_(126) off" 
$ns at 660.0 "$node_(126) on" 
$node_(127) set X_ 359 
$node_(127) set Y_ 71 
$node_(127) set Z_ 0.0 
$ns at 0.0 "$node_(127) off" 
$ns at 660.0 "$node_(127) on" 
$node_(128) set X_ 1501 
$node_(128) set Y_ 406 
$node_(128) set Z_ 0.0 
$ns at 0.0 "$node_(128) off" 
$ns at 660.0 "$node_(128) on" 
$node_(129) set X_ 314 
$node_(129) set Y_ 441 
$node_(129) set Z_ 0.0 
$ns at 0.0 "$node_(129) off" 
$ns at 660.0 "$node_(129) on" 
$node_(130) set X_ 1776 
$node_(130) set Y_ 466 
$node_(130) set Z_ 0.0 
$ns at 0.0 "$node_(130) off" 
$ns at 660.0 "$node_(130) on" 
$node_(131) set X_ 1852 
$node_(131) set Y_ 525 
$node_(131) set Z_ 0.0 
$ns at 0.0 "$node_(131) off" 
$ns at 660.0 "$node_(131) on" 
$node_(132) set X_ 1943 
$node_(132) set Y_ 941 
$node_(132) set Z_ 0.0 
$ns at 0.0 "$node_(132) off" 
$ns at 660.0 "$node_(132) on" 
$node_(133) set X_ 365 
$node_(133) set Y_ 47 
$node_(133) set Z_ 0.0 
$ns at 0.0 "$node_(133) off" 
$ns at 660.0 "$node_(133) on" 
$node_(134) set X_ 987 
$node_(134) set Y_ 404 
$node_(134) set Z_ 0.0 
$ns at 0.0 "$node_(134) off" 
$ns at 660.0 "$node_(134) on" 
$node_(135) set X_ 2498 
$node_(135) set Y_ 941 
$node_(135) set Z_ 0.0 
$ns at 0.0 "$node_(135) off" 
$ns at 660.0 "$node_(135) on" 
$node_(136) set X_ 318 
$node_(136) set Y_ 136 
$node_(136) set Z_ 0.0 
$ns at 0.0 "$node_(136) off" 
$ns at 660.0 "$node_(136) on" 
$node_(137) set X_ 2210 
$node_(137) set Y_ 356 
$node_(137) set Z_ 0.0 
$ns at 0.0 "$node_(137) off" 
$ns at 660.0 "$node_(137) on" 
$node_(138) set X_ 1014 
$node_(138) set Y_ 775 
$node_(138) set Z_ 0.0 
$ns at 0.0 "$node_(138) off" 
$ns at 660.0 "$node_(138) on" 
$node_(139) set X_ 1623 
$node_(139) set Y_ 3 
$node_(139) set Z_ 0.0 
$ns at 0.0 "$node_(139) off" 
$ns at 660.0 "$node_(139) on" 
$node_(140) set X_ 2452 
$node_(140) set Y_ 192 
$node_(140) set Z_ 0.0 
$ns at 0.0 "$node_(140) off" 
$ns at 660.0 "$node_(140) on" 
$node_(141) set X_ 1884 
$node_(141) set Y_ 257 
$node_(141) set Z_ 0.0 
$ns at 0.0 "$node_(141) off" 
$ns at 660.0 "$node_(141) on" 
$node_(142) set X_ 1884 
$node_(142) set Y_ 138 
$node_(142) set Z_ 0.0 
$ns at 0.0 "$node_(142) off" 
$ns at 660.0 "$node_(142) on" 
$node_(143) set X_ 1472 
$node_(143) set Y_ 152 
$node_(143) set Z_ 0.0 
$ns at 0.0 "$node_(143) off" 
$ns at 660.0 "$node_(143) on" 
$node_(144) set X_ 2722 
$node_(144) set Y_ 385 
$node_(144) set Z_ 0.0 
$ns at 0.0 "$node_(144) off" 
$ns at 660.0 "$node_(144) on" 
$node_(145) set X_ 1354 
$node_(145) set Y_ 180 
$node_(145) set Z_ 0.0 
$ns at 0.0 "$node_(145) off" 
$ns at 660.0 "$node_(145) on" 
$node_(146) set X_ 747 
$node_(146) set Y_ 796 
$node_(146) set Z_ 0.0 
$ns at 0.0 "$node_(146) off" 
$ns at 660.0 "$node_(146) on" 
$node_(147) set X_ 2060 
$node_(147) set Y_ 827 
$node_(147) set Z_ 0.0 
$ns at 0.0 "$node_(147) off" 
$ns at 660.0 "$node_(147) on" 
$node_(148) set X_ 86 
$node_(148) set Y_ 251 
$node_(148) set Z_ 0.0 
$ns at 0.0 "$node_(148) off" 
$ns at 660.0 "$node_(148) on" 
$node_(149) set X_ 2133 
$node_(149) set Y_ 888 
$node_(149) set Z_ 0.0 
$ns at 0.0 "$node_(149) off" 
$ns at 660.0 "$node_(149) on" 

# Generation of movements
$ns at 0.0 "$node_(0) setdest 2719 405 10.0" 
$ns at 120.8393885309775 "$node_(0) setdest 315 32 9.0" 
$ns at 201.5856534176492 "$node_(0) setdest 2555 92 18.0" 
$ns at 296.3070768464512 "$node_(0) setdest 1608 719 10.0" 
$ns at 409.8840347996794 "$node_(0) setdest 2169 65 3.0" 
$ns at 450.5083122501759 "$node_(0) setdest 463 273 17.0" 
$ns at 587.4987187052861 "$node_(0) setdest 774 908 19.0" 
$ns at 693.0280151580282 "$node_(0) setdest 1476 858 9.0" 
$ns at 723.1615221996149 "$node_(0) setdest 186 22 13.0" 
$ns at 781.3459657704602 "$node_(0) setdest 458 167 16.0" 
$ns at 866.1579958012427 "$node_(0) setdest 2548 913 6.0" 
$ns at 0.0 "$node_(1) setdest 1027 171 19.0" 
$ns at 143.00330110983862 "$node_(1) setdest 2520 300 10.0" 
$ns at 204.69837816901696 "$node_(1) setdest 2590 874 8.0" 
$ns at 265.0967043610679 "$node_(1) setdest 699 231 18.0" 
$ns at 304.6554758486311 "$node_(1) setdest 337 910 4.0" 
$ns at 341.96270199887823 "$node_(1) setdest 2802 673 17.0" 
$ns at 446.70145860088 "$node_(1) setdest 2678 56 6.0" 
$ns at 535.587553128959 "$node_(1) setdest 2894 288 10.0" 
$ns at 654.1403949153822 "$node_(1) setdest 268 3 2.0" 
$ns at 703.624447393448 "$node_(1) setdest 680 340 18.0" 
$ns at 746.1203800712248 "$node_(1) setdest 1510 957 19.0" 
$ns at 831.5371914671073 "$node_(1) setdest 1636 951 18.0" 
$ns at 0.0 "$node_(2) setdest 1205 913 14.0" 
$ns at 148.0484110593831 "$node_(2) setdest 524 156 10.0" 
$ns at 226.9126421390986 "$node_(2) setdest 1738 666 12.0" 
$ns at 339.7127387266612 "$node_(2) setdest 546 468 7.0" 
$ns at 393.76337459070186 "$node_(2) setdest 2966 919 1.0" 
$ns at 429.66227939780674 "$node_(2) setdest 1180 908 13.0" 
$ns at 555.7346553632292 "$node_(2) setdest 692 42 20.0" 
$ns at 707.411100837009 "$node_(2) setdest 2468 710 4.0" 
$ns at 741.2029096656138 "$node_(2) setdest 1400 327 18.0" 
$ns at 0.0 "$node_(3) setdest 2286 150 6.0" 
$ns at 86.789913588844 "$node_(3) setdest 1632 827 17.0" 
$ns at 174.1966761715178 "$node_(3) setdest 2874 218 17.0" 
$ns at 304.28642514408637 "$node_(3) setdest 1172 98 18.0" 
$ns at 475.59723262366015 "$node_(3) setdest 1648 80 2.0" 
$ns at 515.7853211731591 "$node_(3) setdest 2937 432 20.0" 
$ns at 610.2461086449213 "$node_(3) setdest 2082 542 7.0" 
$ns at 649.6200899683931 "$node_(3) setdest 1227 415 14.0" 
$ns at 701.1765901783484 "$node_(3) setdest 174 973 2.0" 
$ns at 744.1736260039926 "$node_(3) setdest 2727 892 20.0" 
$ns at 862.7745049882465 "$node_(3) setdest 1782 390 19.0" 
$ns at 0.0 "$node_(4) setdest 2438 663 17.0" 
$ns at 103.47024867323267 "$node_(4) setdest 862 665 1.0" 
$ns at 141.7547933853155 "$node_(4) setdest 2408 506 19.0" 
$ns at 321.49176274884076 "$node_(4) setdest 2367 69 3.0" 
$ns at 362.14945882676983 "$node_(4) setdest 2941 344 15.0" 
$ns at 438.96408486378516 "$node_(4) setdest 356 586 16.0" 
$ns at 552.5335155634782 "$node_(4) setdest 1668 648 12.0" 
$ns at 632.0719187630473 "$node_(4) setdest 2577 736 3.0" 
$ns at 687.7787725485608 "$node_(4) setdest 649 409 15.0" 
$ns at 865.4827225029986 "$node_(4) setdest 1551 840 4.0" 
$ns at 0.0 "$node_(5) setdest 1392 251 5.0" 
$ns at 59.35646326990299 "$node_(5) setdest 2949 942 8.0" 
$ns at 166.8078194710814 "$node_(5) setdest 1455 527 11.0" 
$ns at 204.37649503798238 "$node_(5) setdest 763 846 12.0" 
$ns at 313.27030734379923 "$node_(5) setdest 1021 476 10.0" 
$ns at 346.43165774483236 "$node_(5) setdest 2578 979 17.0" 
$ns at 534.2952921614224 "$node_(5) setdest 1611 772 15.0" 
$ns at 681.1144100083836 "$node_(5) setdest 1952 21 9.0" 
$ns at 731.1968632375393 "$node_(5) setdest 832 48 12.0" 
$ns at 838.2136719364912 "$node_(5) setdest 2685 533 2.0" 
$ns at 876.6522579423794 "$node_(5) setdest 2801 232 15.0" 
$ns at 0.0 "$node_(6) setdest 2512 15 12.0" 
$ns at 108.21935221322953 "$node_(6) setdest 1670 768 8.0" 
$ns at 154.27818215569778 "$node_(6) setdest 491 127 5.0" 
$ns at 230.5782345159145 "$node_(6) setdest 1385 58 8.0" 
$ns at 307.3916718804162 "$node_(6) setdest 111 1 13.0" 
$ns at 452.7848166170069 "$node_(6) setdest 593 709 7.0" 
$ns at 523.3676248348493 "$node_(6) setdest 1905 879 19.0" 
$ns at 586.9074198353358 "$node_(6) setdest 1339 421 18.0" 
$ns at 784.7539513781012 "$node_(6) setdest 1092 512 11.0" 
$ns at 835.4331012199273 "$node_(6) setdest 1967 580 15.0" 
$ns at 0.0 "$node_(7) setdest 518 44 11.0" 
$ns at 56.8196860135598 "$node_(7) setdest 1369 912 18.0" 
$ns at 160.75593115124093 "$node_(7) setdest 1938 326 3.0" 
$ns at 204.09257989257674 "$node_(7) setdest 487 765 2.0" 
$ns at 241.0548308304701 "$node_(7) setdest 2403 873 2.0" 
$ns at 285.51266791516724 "$node_(7) setdest 2717 853 1.0" 
$ns at 316.1753762176648 "$node_(7) setdest 2286 915 16.0" 
$ns at 484.97235207440315 "$node_(7) setdest 629 547 19.0" 
$ns at 622.3732366824634 "$node_(7) setdest 2227 263 1.0" 
$ns at 657.7418136172608 "$node_(7) setdest 139 45 9.0" 
$ns at 737.2883239421303 "$node_(7) setdest 11 926 8.0" 
$ns at 809.922290246295 "$node_(7) setdest 2045 998 10.0" 
$ns at 847.7009790935359 "$node_(7) setdest 2174 708 19.0" 
$ns at 0.0 "$node_(8) setdest 2581 434 4.0" 
$ns at 68.23243970347485 "$node_(8) setdest 2855 225 14.0" 
$ns at 139.36959466700148 "$node_(8) setdest 383 48 17.0" 
$ns at 220.5488164380438 "$node_(8) setdest 168 57 18.0" 
$ns at 361.3389207368098 "$node_(8) setdest 1028 206 1.0" 
$ns at 400.23066670195806 "$node_(8) setdest 1129 991 18.0" 
$ns at 529.958792945049 "$node_(8) setdest 2042 231 3.0" 
$ns at 565.889983182749 "$node_(8) setdest 2913 566 12.0" 
$ns at 617.863143452058 "$node_(8) setdest 2037 810 8.0" 
$ns at 670.6229881752932 "$node_(8) setdest 1963 359 19.0" 
$ns at 777.6893408701568 "$node_(8) setdest 366 608 3.0" 
$ns at 834.5824334663477 "$node_(8) setdest 2238 754 16.0" 
$ns at 0.0 "$node_(9) setdest 2463 404 7.0" 
$ns at 61.709059758853755 "$node_(9) setdest 617 110 4.0" 
$ns at 116.88817106985078 "$node_(9) setdest 1764 361 20.0" 
$ns at 306.7043429593233 "$node_(9) setdest 249 563 1.0" 
$ns at 345.89166937310245 "$node_(9) setdest 2857 225 8.0" 
$ns at 445.6426251432945 "$node_(9) setdest 1357 917 7.0" 
$ns at 479.79915895568513 "$node_(9) setdest 1271 568 15.0" 
$ns at 611.1971306399138 "$node_(9) setdest 796 309 6.0" 
$ns at 657.5147510755482 "$node_(9) setdest 1054 387 5.0" 
$ns at 698.0895368512845 "$node_(9) setdest 2378 640 11.0" 
$ns at 817.0856780186754 "$node_(9) setdest 2036 649 19.0" 
$ns at 894.5209397368167 "$node_(9) setdest 1740 944 18.0" 
$ns at 0.0 "$node_(10) setdest 443 608 13.0" 
$ns at 43.05828280673997 "$node_(10) setdest 297 175 1.0" 
$ns at 81.68562516426066 "$node_(10) setdest 2247 991 10.0" 
$ns at 188.35505953666186 "$node_(10) setdest 1535 114 15.0" 
$ns at 339.54429419503015 "$node_(10) setdest 1422 358 20.0" 
$ns at 395.4022556348841 "$node_(10) setdest 697 345 5.0" 
$ns at 451.8468929556209 "$node_(10) setdest 1991 251 10.0" 
$ns at 487.6455991474021 "$node_(10) setdest 614 518 11.0" 
$ns at 602.6563115556733 "$node_(10) setdest 1534 933 4.0" 
$ns at 656.3493713170744 "$node_(10) setdest 233 350 10.0" 
$ns at 712.080306178311 "$node_(10) setdest 1543 826 17.0" 
$ns at 841.9086418106132 "$node_(10) setdest 2091 70 4.0" 
$ns at 895.3812130738462 "$node_(10) setdest 2788 956 1.0" 
$ns at 0.0 "$node_(11) setdest 1795 268 11.0" 
$ns at 65.13288239161321 "$node_(11) setdest 1593 9 1.0" 
$ns at 105.00952400320556 "$node_(11) setdest 1259 358 6.0" 
$ns at 177.19607169422437 "$node_(11) setdest 667 808 3.0" 
$ns at 211.27898712742797 "$node_(11) setdest 1233 100 5.0" 
$ns at 283.86786430209423 "$node_(11) setdest 906 315 9.0" 
$ns at 366.71395679079365 "$node_(11) setdest 1412 906 4.0" 
$ns at 411.89171527247026 "$node_(11) setdest 1309 475 2.0" 
$ns at 448.6288018217594 "$node_(11) setdest 1134 869 3.0" 
$ns at 501.5261247164324 "$node_(11) setdest 1911 485 14.0" 
$ns at 590.550516434894 "$node_(11) setdest 463 738 10.0" 
$ns at 715.961302919335 "$node_(11) setdest 2387 330 6.0" 
$ns at 797.772824557316 "$node_(11) setdest 2165 277 10.0" 
$ns at 828.2589847347756 "$node_(11) setdest 1731 661 2.0" 
$ns at 862.98587142684 "$node_(11) setdest 877 741 13.0" 
$ns at 0.0 "$node_(12) setdest 2159 338 5.0" 
$ns at 54.842206730051345 "$node_(12) setdest 470 398 3.0" 
$ns at 105.94588632002407 "$node_(12) setdest 141 246 8.0" 
$ns at 214.04871034722078 "$node_(12) setdest 2410 328 15.0" 
$ns at 244.57487998985246 "$node_(12) setdest 2209 182 20.0" 
$ns at 409.8394802309946 "$node_(12) setdest 1624 937 5.0" 
$ns at 472.756563395851 "$node_(12) setdest 1958 931 18.0" 
$ns at 550.2695644747914 "$node_(12) setdest 158 906 6.0" 
$ns at 617.9384121780461 "$node_(12) setdest 2368 824 11.0" 
$ns at 693.046470073662 "$node_(12) setdest 1653 529 17.0" 
$ns at 842.2738180666298 "$node_(12) setdest 375 402 8.0" 
$ns at 0.0 "$node_(13) setdest 1415 638 9.0" 
$ns at 101.51595346976553 "$node_(13) setdest 1323 981 3.0" 
$ns at 159.2031640834715 "$node_(13) setdest 2607 592 10.0" 
$ns at 231.2094792169645 "$node_(13) setdest 2716 223 14.0" 
$ns at 281.92598594864154 "$node_(13) setdest 2839 11 7.0" 
$ns at 336.4474735350105 "$node_(13) setdest 1405 37 13.0" 
$ns at 437.00110162846045 "$node_(13) setdest 1189 236 16.0" 
$ns at 586.1241484211075 "$node_(13) setdest 1131 392 3.0" 
$ns at 631.6404076047997 "$node_(13) setdest 1422 705 4.0" 
$ns at 671.9162405286507 "$node_(13) setdest 1060 874 14.0" 
$ns at 747.4382185752512 "$node_(13) setdest 2948 714 13.0" 
$ns at 894.040992937357 "$node_(13) setdest 724 75 13.0" 
$ns at 0.0 "$node_(14) setdest 1780 259 3.0" 
$ns at 49.83191569510167 "$node_(14) setdest 511 133 18.0" 
$ns at 244.81183175507022 "$node_(14) setdest 533 929 13.0" 
$ns at 301.4564955516476 "$node_(14) setdest 1616 19 2.0" 
$ns at 350.10819490321694 "$node_(14) setdest 239 41 3.0" 
$ns at 382.4007310563409 "$node_(14) setdest 1096 394 2.0" 
$ns at 415.50418925207725 "$node_(14) setdest 1494 491 10.0" 
$ns at 473.30266445414645 "$node_(14) setdest 2437 128 5.0" 
$ns at 544.605607221029 "$node_(14) setdest 1236 16 8.0" 
$ns at 588.9302959056671 "$node_(14) setdest 2790 793 8.0" 
$ns at 691.7860823927276 "$node_(14) setdest 2154 827 15.0" 
$ns at 728.8285371403938 "$node_(14) setdest 2757 736 13.0" 
$ns at 798.5424606283558 "$node_(14) setdest 1531 821 17.0" 
$ns at 0.0 "$node_(15) setdest 1416 552 7.0" 
$ns at 76.34232048530711 "$node_(15) setdest 2032 834 4.0" 
$ns at 113.03320288007322 "$node_(15) setdest 2945 33 11.0" 
$ns at 167.54943992474915 "$node_(15) setdest 721 630 8.0" 
$ns at 199.90288775085503 "$node_(15) setdest 2036 945 14.0" 
$ns at 273.7751946047681 "$node_(15) setdest 330 593 15.0" 
$ns at 346.54415287458073 "$node_(15) setdest 2968 185 9.0" 
$ns at 411.1157567708624 "$node_(15) setdest 565 330 1.0" 
$ns at 447.9938594549378 "$node_(15) setdest 2023 186 18.0" 
$ns at 612.7332549411306 "$node_(15) setdest 2970 628 6.0" 
$ns at 682.7526953345842 "$node_(15) setdest 1618 617 8.0" 
$ns at 745.5603757179663 "$node_(15) setdest 624 493 12.0" 
$ns at 864.2319982573313 "$node_(15) setdest 2325 739 8.0" 
$ns at 0.0 "$node_(16) setdest 2704 213 8.0" 
$ns at 85.39796897344638 "$node_(16) setdest 675 979 2.0" 
$ns at 117.11424076225077 "$node_(16) setdest 696 650 16.0" 
$ns at 158.2555594817781 "$node_(16) setdest 399 563 3.0" 
$ns at 215.19671123594964 "$node_(16) setdest 2765 238 10.0" 
$ns at 316.2396404078945 "$node_(16) setdest 504 289 6.0" 
$ns at 388.12380271306233 "$node_(16) setdest 2577 365 10.0" 
$ns at 456.27894701514913 "$node_(16) setdest 2345 772 1.0" 
$ns at 492.31212684582874 "$node_(16) setdest 1591 121 15.0" 
$ns at 636.0628333176279 "$node_(16) setdest 586 742 12.0" 
$ns at 769.4113307475425 "$node_(16) setdest 611 608 7.0" 
$ns at 818.985078911697 "$node_(16) setdest 1711 227 1.0" 
$ns at 852.4955981649439 "$node_(16) setdest 101 267 7.0" 
$ns at 0.0 "$node_(17) setdest 480 707 3.0" 
$ns at 39.941875042258786 "$node_(17) setdest 1569 936 15.0" 
$ns at 216.02911983677564 "$node_(17) setdest 1486 557 12.0" 
$ns at 255.43661176744735 "$node_(17) setdest 29 587 11.0" 
$ns at 384.0435194284822 "$node_(17) setdest 2718 391 16.0" 
$ns at 463.4395117276181 "$node_(17) setdest 320 963 6.0" 
$ns at 499.1213509733821 "$node_(17) setdest 2776 96 16.0" 
$ns at 614.267337403229 "$node_(17) setdest 819 557 3.0" 
$ns at 646.2230161461664 "$node_(17) setdest 1143 683 10.0" 
$ns at 749.0417916010379 "$node_(17) setdest 2817 646 6.0" 
$ns at 786.2920829710321 "$node_(17) setdest 668 253 14.0" 
$ns at 0.0 "$node_(18) setdest 2580 340 17.0" 
$ns at 183.4799580111021 "$node_(18) setdest 1164 675 9.0" 
$ns at 216.94413079897873 "$node_(18) setdest 1895 853 17.0" 
$ns at 403.59068582272187 "$node_(18) setdest 768 809 4.0" 
$ns at 462.6589636145461 "$node_(18) setdest 1595 446 10.0" 
$ns at 582.2269349786018 "$node_(18) setdest 1463 351 1.0" 
$ns at 621.9202026422502 "$node_(18) setdest 374 752 3.0" 
$ns at 679.2451266986208 "$node_(18) setdest 932 633 11.0" 
$ns at 786.430866753697 "$node_(18) setdest 891 452 19.0" 
$ns at 0.0 "$node_(19) setdest 1620 963 16.0" 
$ns at 155.90368531059408 "$node_(19) setdest 1966 484 1.0" 
$ns at 189.07048658251273 "$node_(19) setdest 2677 331 18.0" 
$ns at 220.42908150402195 "$node_(19) setdest 1369 270 9.0" 
$ns at 315.6110175566037 "$node_(19) setdest 1180 572 4.0" 
$ns at 367.1198860635202 "$node_(19) setdest 1503 646 4.0" 
$ns at 399.58398182529777 "$node_(19) setdest 2773 312 16.0" 
$ns at 515.954772193808 "$node_(19) setdest 1991 465 9.0" 
$ns at 556.2860862525848 "$node_(19) setdest 653 274 6.0" 
$ns at 633.1290299558623 "$node_(19) setdest 2958 73 2.0" 
$ns at 678.2867656529803 "$node_(19) setdest 2524 793 16.0" 
$ns at 774.1795650339573 "$node_(19) setdest 1523 123 8.0" 
$ns at 834.9642541441943 "$node_(19) setdest 2947 597 1.0" 
$ns at 868.0399174095932 "$node_(19) setdest 789 421 1.0" 
$ns at 0.0 "$node_(20) setdest 225 215 16.0" 
$ns at 127.07603525303185 "$node_(20) setdest 346 774 14.0" 
$ns at 219.58198286125955 "$node_(20) setdest 1729 570 20.0" 
$ns at 319.8573253719315 "$node_(20) setdest 1082 44 1.0" 
$ns at 356.4951456005768 "$node_(20) setdest 1314 598 7.0" 
$ns at 412.2369266461168 "$node_(20) setdest 810 858 7.0" 
$ns at 497.5686152892785 "$node_(20) setdest 232 980 8.0" 
$ns at 590.2563807010794 "$node_(20) setdest 6 688 15.0" 
$ns at 633.0615426924882 "$node_(20) setdest 2694 309 2.0" 
$ns at 679.5970922474121 "$node_(20) setdest 1666 254 8.0" 
$ns at 754.7720243598952 "$node_(20) setdest 1981 287 4.0" 
$ns at 816.7414487643292 "$node_(20) setdest 2079 465 15.0" 
$ns at 0.0 "$node_(21) setdest 752 767 3.0" 
$ns at 41.137847067307064 "$node_(21) setdest 35 343 15.0" 
$ns at 73.59985000383858 "$node_(21) setdest 1964 736 9.0" 
$ns at 156.73144597589754 "$node_(21) setdest 1735 646 20.0" 
$ns at 256.60164052487426 "$node_(21) setdest 547 568 3.0" 
$ns at 294.07966037128966 "$node_(21) setdest 2455 141 11.0" 
$ns at 411.8056405852439 "$node_(21) setdest 733 124 16.0" 
$ns at 523.0578662163932 "$node_(21) setdest 1711 743 7.0" 
$ns at 561.7092067640621 "$node_(21) setdest 699 536 14.0" 
$ns at 719.5203294229675 "$node_(21) setdest 1477 965 7.0" 
$ns at 793.8369597138404 "$node_(21) setdest 932 757 6.0" 
$ns at 836.5223825458224 "$node_(21) setdest 728 397 2.0" 
$ns at 882.464536494805 "$node_(21) setdest 444 202 8.0" 
$ns at 0.0 "$node_(22) setdest 318 163 11.0" 
$ns at 123.87711450110223 "$node_(22) setdest 2771 77 5.0" 
$ns at 169.28313531618835 "$node_(22) setdest 2998 566 4.0" 
$ns at 235.50538298037483 "$node_(22) setdest 385 207 18.0" 
$ns at 383.3369935366738 "$node_(22) setdest 78 386 16.0" 
$ns at 459.5890742995824 "$node_(22) setdest 2926 467 14.0" 
$ns at 626.6108085668199 "$node_(22) setdest 24 515 3.0" 
$ns at 663.3597488464802 "$node_(22) setdest 1422 130 5.0" 
$ns at 697.5555878094272 "$node_(22) setdest 2012 917 11.0" 
$ns at 730.7856013661426 "$node_(22) setdest 1370 728 8.0" 
$ns at 768.208327802883 "$node_(22) setdest 1217 99 1.0" 
$ns at 802.2016336592336 "$node_(22) setdest 365 245 15.0" 
$ns at 0.0 "$node_(23) setdest 2363 548 12.0" 
$ns at 95.29401898047877 "$node_(23) setdest 2645 737 14.0" 
$ns at 168.93840460589854 "$node_(23) setdest 818 861 4.0" 
$ns at 206.1982208230606 "$node_(23) setdest 1733 701 19.0" 
$ns at 318.87111774788855 "$node_(23) setdest 2250 504 1.0" 
$ns at 355.5578229694273 "$node_(23) setdest 1061 778 1.0" 
$ns at 392.36219018851517 "$node_(23) setdest 2633 418 14.0" 
$ns at 532.5843538871527 "$node_(23) setdest 2233 628 14.0" 
$ns at 569.94158565615 "$node_(23) setdest 1121 927 13.0" 
$ns at 723.7236872070664 "$node_(23) setdest 2335 46 10.0" 
$ns at 774.4034806725 "$node_(23) setdest 2073 654 18.0" 
$ns at 0.0 "$node_(24) setdest 428 670 18.0" 
$ns at 69.66583633048086 "$node_(24) setdest 2256 402 1.0" 
$ns at 108.35731628463043 "$node_(24) setdest 2156 835 4.0" 
$ns at 175.55365103360745 "$node_(24) setdest 2000 211 8.0" 
$ns at 250.84277082652636 "$node_(24) setdest 81 443 15.0" 
$ns at 427.828050398203 "$node_(24) setdest 1836 38 9.0" 
$ns at 493.3226490218783 "$node_(24) setdest 1191 892 11.0" 
$ns at 630.7146315503754 "$node_(24) setdest 890 784 7.0" 
$ns at 678.8553916801428 "$node_(24) setdest 2692 421 20.0" 
$ns at 786.8454784812465 "$node_(24) setdest 2068 601 16.0" 
$ns at 887.4130698653769 "$node_(24) setdest 1020 451 4.0" 
$ns at 0.0 "$node_(25) setdest 2796 714 2.0" 
$ns at 36.3436282559147 "$node_(25) setdest 2707 741 5.0" 
$ns at 103.99264586400517 "$node_(25) setdest 1865 192 18.0" 
$ns at 253.1734047867132 "$node_(25) setdest 505 450 6.0" 
$ns at 297.45212233663585 "$node_(25) setdest 2624 384 2.0" 
$ns at 338.41678237888163 "$node_(25) setdest 1926 442 10.0" 
$ns at 376.3814656818068 "$node_(25) setdest 2591 982 11.0" 
$ns at 419.04026324469777 "$node_(25) setdest 95 406 6.0" 
$ns at 478.2140269926769 "$node_(25) setdest 2217 910 5.0" 
$ns at 544.5735286638435 "$node_(25) setdest 2576 626 15.0" 
$ns at 618.3106521152396 "$node_(25) setdest 363 496 13.0" 
$ns at 686.0017507465457 "$node_(25) setdest 561 487 6.0" 
$ns at 725.2550308479324 "$node_(25) setdest 1747 643 11.0" 
$ns at 836.9745978881409 "$node_(25) setdest 1586 45 17.0" 
$ns at 0.0 "$node_(26) setdest 2404 946 17.0" 
$ns at 30.072111550138725 "$node_(26) setdest 670 244 10.0" 
$ns at 84.08339397774336 "$node_(26) setdest 917 964 18.0" 
$ns at 268.6329141860593 "$node_(26) setdest 2531 612 1.0" 
$ns at 308.60649459850794 "$node_(26) setdest 2967 114 16.0" 
$ns at 440.78623264025566 "$node_(26) setdest 1285 523 16.0" 
$ns at 618.1849066212371 "$node_(26) setdest 2468 878 10.0" 
$ns at 706.7444314624876 "$node_(26) setdest 1768 343 6.0" 
$ns at 739.767405252049 "$node_(26) setdest 1309 292 15.0" 
$ns at 813.6775154552142 "$node_(26) setdest 2405 61 13.0" 
$ns at 0.0 "$node_(27) setdest 1499 919 11.0" 
$ns at 103.72146039106056 "$node_(27) setdest 1252 219 8.0" 
$ns at 188.16832108645065 "$node_(27) setdest 223 766 1.0" 
$ns at 220.4504256245804 "$node_(27) setdest 638 240 5.0" 
$ns at 275.8696012113895 "$node_(27) setdest 1094 846 19.0" 
$ns at 437.73378579743303 "$node_(27) setdest 1539 474 15.0" 
$ns at 504.6576999117456 "$node_(27) setdest 1636 352 16.0" 
$ns at 571.8011845623481 "$node_(27) setdest 603 540 12.0" 
$ns at 706.7818191907744 "$node_(27) setdest 1757 642 19.0" 
$ns at 886.4079619067929 "$node_(27) setdest 466 817 9.0" 
$ns at 0.0 "$node_(28) setdest 761 488 16.0" 
$ns at 81.35191468885398 "$node_(28) setdest 2770 144 6.0" 
$ns at 150.19406452878764 "$node_(28) setdest 2155 316 5.0" 
$ns at 228.02935464129655 "$node_(28) setdest 2024 70 3.0" 
$ns at 262.3804678308152 "$node_(28) setdest 1301 367 6.0" 
$ns at 311.0578979879947 "$node_(28) setdest 2232 239 17.0" 
$ns at 473.4777548079942 "$node_(28) setdest 669 8 11.0" 
$ns at 561.0520580004068 "$node_(28) setdest 907 734 17.0" 
$ns at 688.6539954813288 "$node_(28) setdest 2228 634 15.0" 
$ns at 831.805302581812 "$node_(28) setdest 2911 476 20.0" 
$ns at 876.116822239763 "$node_(28) setdest 2260 885 6.0" 
$ns at 0.0 "$node_(29) setdest 1245 987 17.0" 
$ns at 129.70966145697582 "$node_(29) setdest 2604 117 4.0" 
$ns at 189.04135111875632 "$node_(29) setdest 699 123 6.0" 
$ns at 253.85502552147804 "$node_(29) setdest 2133 350 13.0" 
$ns at 303.1678380736235 "$node_(29) setdest 2026 597 8.0" 
$ns at 356.28039627190776 "$node_(29) setdest 1968 130 17.0" 
$ns at 390.38461493725634 "$node_(29) setdest 25 374 1.0" 
$ns at 420.4366357542047 "$node_(29) setdest 1720 43 4.0" 
$ns at 489.47584542849506 "$node_(29) setdest 1697 273 10.0" 
$ns at 585.092151536716 "$node_(29) setdest 784 803 16.0" 
$ns at 634.2578444317252 "$node_(29) setdest 2370 354 6.0" 
$ns at 698.6077518614426 "$node_(29) setdest 1463 147 9.0" 
$ns at 765.6853998883443 "$node_(29) setdest 2451 931 10.0" 
$ns at 855.0429821636391 "$node_(29) setdest 2444 982 16.0" 
$ns at 0.0 "$node_(30) setdest 1201 283 16.0" 
$ns at 174.4332733501897 "$node_(30) setdest 1913 494 3.0" 
$ns at 232.12896046497147 "$node_(30) setdest 693 395 17.0" 
$ns at 302.4624627260768 "$node_(30) setdest 328 173 19.0" 
$ns at 421.5569886254853 "$node_(30) setdest 2846 326 18.0" 
$ns at 517.8114106423113 "$node_(30) setdest 2630 969 11.0" 
$ns at 582.0729824430064 "$node_(30) setdest 1197 13 13.0" 
$ns at 741.146227851305 "$node_(30) setdest 2425 30 19.0" 
$ns at 884.2522040635844 "$node_(30) setdest 2804 616 15.0" 
$ns at 0.0 "$node_(31) setdest 399 722 7.0" 
$ns at 96.28362022542137 "$node_(31) setdest 2441 712 3.0" 
$ns at 150.66325908080154 "$node_(31) setdest 2015 907 11.0" 
$ns at 220.63301995317198 "$node_(31) setdest 2982 950 10.0" 
$ns at 301.8420046802355 "$node_(31) setdest 249 668 13.0" 
$ns at 346.6888412984771 "$node_(31) setdest 2627 967 6.0" 
$ns at 389.33049127808266 "$node_(31) setdest 906 949 4.0" 
$ns at 436.39004622339644 "$node_(31) setdest 2373 667 1.0" 
$ns at 473.82237676760576 "$node_(31) setdest 1786 807 11.0" 
$ns at 610.7735433024446 "$node_(31) setdest 884 199 8.0" 
$ns at 682.0937573589281 "$node_(31) setdest 2730 243 17.0" 
$ns at 784.9072442143358 "$node_(31) setdest 1661 193 12.0" 
$ns at 856.5101981729712 "$node_(31) setdest 1326 821 11.0" 
$ns at 0.0 "$node_(32) setdest 1159 109 3.0" 
$ns at 56.00609943315972 "$node_(32) setdest 1796 511 8.0" 
$ns at 91.58943144597049 "$node_(32) setdest 2265 771 16.0" 
$ns at 265.4524700514366 "$node_(32) setdest 2347 494 6.0" 
$ns at 344.5508668978189 "$node_(32) setdest 2282 419 8.0" 
$ns at 409.43054555370077 "$node_(32) setdest 2009 860 15.0" 
$ns at 445.3579924143952 "$node_(32) setdest 1315 860 16.0" 
$ns at 495.4144009597726 "$node_(32) setdest 2743 419 5.0" 
$ns at 561.303685191655 "$node_(32) setdest 2728 555 4.0" 
$ns at 607.4598819000328 "$node_(32) setdest 1339 82 14.0" 
$ns at 680.4872117673656 "$node_(32) setdest 2058 714 14.0" 
$ns at 804.7373691912073 "$node_(32) setdest 2387 510 3.0" 
$ns at 845.0372273346452 "$node_(32) setdest 549 747 9.0" 
$ns at 889.7199037386983 "$node_(32) setdest 350 3 14.0" 
$ns at 0.0 "$node_(33) setdest 2202 633 2.0" 
$ns at 37.54208112173522 "$node_(33) setdest 2506 816 10.0" 
$ns at 75.96248554224557 "$node_(33) setdest 1998 59 12.0" 
$ns at 137.61183922466935 "$node_(33) setdest 296 383 7.0" 
$ns at 190.5412319826441 "$node_(33) setdest 693 395 19.0" 
$ns at 317.3425375040805 "$node_(33) setdest 1358 132 9.0" 
$ns at 422.9932286413729 "$node_(33) setdest 1336 845 13.0" 
$ns at 530.5397520877904 "$node_(33) setdest 1262 868 3.0" 
$ns at 565.1703785867612 "$node_(33) setdest 422 357 9.0" 
$ns at 642.0420425773415 "$node_(33) setdest 2729 916 7.0" 
$ns at 691.3644256293829 "$node_(33) setdest 2318 122 9.0" 
$ns at 749.6722825978518 "$node_(33) setdest 1875 493 17.0" 
$ns at 874.5676144207894 "$node_(33) setdest 2373 738 10.0" 
$ns at 0.0 "$node_(34) setdest 2725 3 18.0" 
$ns at 153.04732193088662 "$node_(34) setdest 1868 385 11.0" 
$ns at 292.2783022425796 "$node_(34) setdest 2068 231 1.0" 
$ns at 322.62056818343774 "$node_(34) setdest 1695 575 14.0" 
$ns at 454.7306309444713 "$node_(34) setdest 1383 619 7.0" 
$ns at 552.2622809910317 "$node_(34) setdest 433 331 15.0" 
$ns at 661.3668606567458 "$node_(34) setdest 1406 102 2.0" 
$ns at 706.353472138713 "$node_(34) setdest 2214 853 9.0" 
$ns at 755.476467917387 "$node_(34) setdest 1584 199 16.0" 
$ns at 820.9793597300733 "$node_(34) setdest 1527 22 13.0" 
$ns at 886.0295258345154 "$node_(34) setdest 464 323 1.0" 
$ns at 0.0 "$node_(35) setdest 2879 315 8.0" 
$ns at 33.52417549292656 "$node_(35) setdest 2780 508 11.0" 
$ns at 114.58190432053141 "$node_(35) setdest 1947 965 1.0" 
$ns at 153.61241606656023 "$node_(35) setdest 774 18 16.0" 
$ns at 232.62222505427061 "$node_(35) setdest 2637 445 13.0" 
$ns at 360.48654640019083 "$node_(35) setdest 25 550 4.0" 
$ns at 427.53881467633244 "$node_(35) setdest 1188 620 10.0" 
$ns at 513.05487750789 "$node_(35) setdest 1818 968 5.0" 
$ns at 577.3911325675252 "$node_(35) setdest 1246 127 2.0" 
$ns at 622.1658867001967 "$node_(35) setdest 1818 797 19.0" 
$ns at 747.3636931309171 "$node_(35) setdest 1529 838 15.0" 
$ns at 874.6948532375394 "$node_(35) setdest 2593 922 11.0" 
$ns at 0.0 "$node_(36) setdest 518 478 14.0" 
$ns at 90.34307884662047 "$node_(36) setdest 2252 202 18.0" 
$ns at 261.56843343970115 "$node_(36) setdest 306 721 20.0" 
$ns at 489.9816366505275 "$node_(36) setdest 225 955 1.0" 
$ns at 527.031891988483 "$node_(36) setdest 1502 365 4.0" 
$ns at 594.3968187807677 "$node_(36) setdest 1972 523 6.0" 
$ns at 638.527653010163 "$node_(36) setdest 2874 404 5.0" 
$ns at 698.7947811851525 "$node_(36) setdest 2141 372 8.0" 
$ns at 741.9171862787013 "$node_(36) setdest 2089 84 1.0" 
$ns at 778.5396129293158 "$node_(36) setdest 1446 440 11.0" 
$ns at 0.0 "$node_(37) setdest 745 273 13.0" 
$ns at 132.45496833260194 "$node_(37) setdest 2310 673 6.0" 
$ns at 215.70248821269854 "$node_(37) setdest 2563 729 7.0" 
$ns at 278.0443606294176 "$node_(37) setdest 1036 983 1.0" 
$ns at 313.36058980824833 "$node_(37) setdest 415 98 15.0" 
$ns at 481.80320232211426 "$node_(37) setdest 1032 58 11.0" 
$ns at 517.2167637049492 "$node_(37) setdest 2578 725 8.0" 
$ns at 605.1014782030413 "$node_(37) setdest 384 750 12.0" 
$ns at 709.6519223230114 "$node_(37) setdest 2370 601 11.0" 
$ns at 796.6545108860544 "$node_(37) setdest 786 989 9.0" 
$ns at 835.8657337100466 "$node_(37) setdest 72 47 17.0" 
$ns at 0.0 "$node_(38) setdest 1609 432 7.0" 
$ns at 63.44784055039156 "$node_(38) setdest 781 942 17.0" 
$ns at 261.56731216216576 "$node_(38) setdest 647 305 13.0" 
$ns at 406.63864883921303 "$node_(38) setdest 2612 604 12.0" 
$ns at 495.83597825009116 "$node_(38) setdest 2803 140 15.0" 
$ns at 558.7139851371976 "$node_(38) setdest 2378 634 4.0" 
$ns at 615.7582595744983 "$node_(38) setdest 2750 378 15.0" 
$ns at 734.3514025767964 "$node_(38) setdest 1676 312 13.0" 
$ns at 807.7393802221326 "$node_(38) setdest 1344 25 17.0" 
$ns at 864.5151930743727 "$node_(38) setdest 9 387 1.0" 
$ns at 0.0 "$node_(39) setdest 2317 833 10.0" 
$ns at 39.899254305959644 "$node_(39) setdest 1363 328 4.0" 
$ns at 87.51298091671724 "$node_(39) setdest 2517 708 6.0" 
$ns at 162.57818844762284 "$node_(39) setdest 1383 374 16.0" 
$ns at 268.7734698006735 "$node_(39) setdest 1744 304 8.0" 
$ns at 312.67966167636996 "$node_(39) setdest 1046 971 1.0" 
$ns at 344.4304565269022 "$node_(39) setdest 1935 5 2.0" 
$ns at 387.8198488429809 "$node_(39) setdest 498 419 13.0" 
$ns at 471.0253040308933 "$node_(39) setdest 2244 756 4.0" 
$ns at 501.8725841668871 "$node_(39) setdest 2446 814 19.0" 
$ns at 695.8921101627275 "$node_(39) setdest 283 455 7.0" 
$ns at 758.9178177612189 "$node_(39) setdest 1252 622 14.0" 
$ns at 0.0 "$node_(40) setdest 1554 847 10.0" 
$ns at 101.21366906654399 "$node_(40) setdest 651 455 9.0" 
$ns at 205.23362887346138 "$node_(40) setdest 856 149 12.0" 
$ns at 283.0500627060656 "$node_(40) setdest 1730 899 16.0" 
$ns at 403.0721659848505 "$node_(40) setdest 2188 843 9.0" 
$ns at 520.2455149912553 "$node_(40) setdest 2564 456 19.0" 
$ns at 622.3863195276713 "$node_(40) setdest 418 357 8.0" 
$ns at 714.4741457425907 "$node_(40) setdest 689 952 5.0" 
$ns at 745.6935315639215 "$node_(40) setdest 1766 587 12.0" 
$ns at 873.175636361382 "$node_(40) setdest 2281 971 10.0" 
$ns at 0.0 "$node_(41) setdest 1858 460 2.0" 
$ns at 40.7140466499025 "$node_(41) setdest 716 168 17.0" 
$ns at 183.9228925612316 "$node_(41) setdest 2888 15 16.0" 
$ns at 306.31819455201764 "$node_(41) setdest 1909 534 11.0" 
$ns at 409.5263256631206 "$node_(41) setdest 2165 680 3.0" 
$ns at 449.8531310870604 "$node_(41) setdest 573 936 10.0" 
$ns at 531.8747800679963 "$node_(41) setdest 2070 729 2.0" 
$ns at 577.5930097429567 "$node_(41) setdest 1316 536 3.0" 
$ns at 610.199105123829 "$node_(41) setdest 2204 110 16.0" 
$ns at 776.0895406314999 "$node_(41) setdest 2220 896 2.0" 
$ns at 824.9192875026105 "$node_(41) setdest 1246 108 15.0" 
$ns at 0.0 "$node_(42) setdest 308 872 2.0" 
$ns at 38.88435238987363 "$node_(42) setdest 807 548 14.0" 
$ns at 144.11681282274373 "$node_(42) setdest 1037 614 17.0" 
$ns at 260.3618008825937 "$node_(42) setdest 1313 488 10.0" 
$ns at 376.05252133792794 "$node_(42) setdest 2751 263 9.0" 
$ns at 492.5082728184593 "$node_(42) setdest 1666 629 7.0" 
$ns at 571.8526798301153 "$node_(42) setdest 2709 176 8.0" 
$ns at 654.5657765653632 "$node_(42) setdest 253 873 10.0" 
$ns at 751.5243197459665 "$node_(42) setdest 118 755 4.0" 
$ns at 810.5637425862775 "$node_(42) setdest 1538 759 12.0" 
$ns at 845.7476061016715 "$node_(42) setdest 2310 218 2.0" 
$ns at 887.3402046965126 "$node_(42) setdest 300 715 1.0" 
$ns at 0.0 "$node_(43) setdest 1970 895 5.0" 
$ns at 61.61499522208721 "$node_(43) setdest 261 350 11.0" 
$ns at 128.58573724464506 "$node_(43) setdest 2065 874 12.0" 
$ns at 256.0111889314335 "$node_(43) setdest 1670 231 8.0" 
$ns at 327.55614230912477 "$node_(43) setdest 878 84 4.0" 
$ns at 369.4406445096386 "$node_(43) setdest 1074 856 15.0" 
$ns at 515.1401636286721 "$node_(43) setdest 296 151 9.0" 
$ns at 555.2412835773279 "$node_(43) setdest 2352 780 14.0" 
$ns at 690.0791894330372 "$node_(43) setdest 2266 597 3.0" 
$ns at 734.3385921601672 "$node_(43) setdest 2747 105 15.0" 
$ns at 819.0744677671225 "$node_(43) setdest 1050 231 11.0" 
$ns at 854.0084320613215 "$node_(43) setdest 2454 782 5.0" 
$ns at 892.9834444995815 "$node_(43) setdest 702 793 13.0" 
$ns at 0.0 "$node_(44) setdest 22 440 20.0" 
$ns at 229.77611860551417 "$node_(44) setdest 913 203 10.0" 
$ns at 341.0932945015277 "$node_(44) setdest 2609 698 5.0" 
$ns at 418.7565674785287 "$node_(44) setdest 113 986 18.0" 
$ns at 622.771472244106 "$node_(44) setdest 2860 158 2.0" 
$ns at 664.2192285997372 "$node_(44) setdest 2508 709 19.0" 
$ns at 851.8956780011957 "$node_(44) setdest 940 553 7.0" 
$ns at 0.0 "$node_(45) setdest 1432 505 7.0" 
$ns at 31.285498299361688 "$node_(45) setdest 996 741 7.0" 
$ns at 114.90209518556964 "$node_(45) setdest 2175 30 4.0" 
$ns at 165.90883382068688 "$node_(45) setdest 2082 512 12.0" 
$ns at 218.4817448200965 "$node_(45) setdest 1190 420 20.0" 
$ns at 308.8102661938658 "$node_(45) setdest 1308 406 10.0" 
$ns at 430.718230518989 "$node_(45) setdest 1333 88 2.0" 
$ns at 478.5842757181201 "$node_(45) setdest 765 9 5.0" 
$ns at 529.1771459426517 "$node_(45) setdest 2529 447 11.0" 
$ns at 616.885628018945 "$node_(45) setdest 1483 433 4.0" 
$ns at 667.7312483880479 "$node_(45) setdest 1029 877 14.0" 
$ns at 736.5676740897676 "$node_(45) setdest 1456 923 11.0" 
$ns at 778.7568515155963 "$node_(45) setdest 1154 533 5.0" 
$ns at 821.6183687206633 "$node_(45) setdest 510 817 6.0" 
$ns at 0.0 "$node_(46) setdest 2172 819 1.0" 
$ns at 38.92570718913137 "$node_(46) setdest 552 307 1.0" 
$ns at 76.18483241993671 "$node_(46) setdest 1723 609 7.0" 
$ns at 159.45642606358408 "$node_(46) setdest 2459 702 18.0" 
$ns at 192.525531470016 "$node_(46) setdest 941 549 16.0" 
$ns at 316.4875231089368 "$node_(46) setdest 1646 168 11.0" 
$ns at 433.3337482012371 "$node_(46) setdest 161 24 3.0" 
$ns at 472.55007554272566 "$node_(46) setdest 90 126 12.0" 
$ns at 579.679926822569 "$node_(46) setdest 1890 620 18.0" 
$ns at 671.4121840663479 "$node_(46) setdest 2335 797 4.0" 
$ns at 731.4208911449681 "$node_(46) setdest 2415 156 6.0" 
$ns at 790.3987965734565 "$node_(46) setdest 2755 564 15.0" 
$ns at 888.7683107336147 "$node_(46) setdest 2226 637 1.0" 
$ns at 0.0 "$node_(47) setdest 2101 149 19.0" 
$ns at 155.59894585348883 "$node_(47) setdest 139 690 18.0" 
$ns at 363.07913304757733 "$node_(47) setdest 2117 772 15.0" 
$ns at 471.50412749763984 "$node_(47) setdest 2777 321 10.0" 
$ns at 580.9373376419367 "$node_(47) setdest 2740 779 16.0" 
$ns at 647.8717414210454 "$node_(47) setdest 816 87 7.0" 
$ns at 706.3930494187332 "$node_(47) setdest 174 432 18.0" 
$ns at 895.605652466185 "$node_(47) setdest 2139 991 2.0" 
$ns at 0.0 "$node_(48) setdest 2856 819 7.0" 
$ns at 81.72765531476082 "$node_(48) setdest 2809 711 1.0" 
$ns at 116.75759344140347 "$node_(48) setdest 2094 96 1.0" 
$ns at 150.15117092243412 "$node_(48) setdest 2509 973 5.0" 
$ns at 193.04719151821277 "$node_(48) setdest 2911 512 1.0" 
$ns at 226.18029465722984 "$node_(48) setdest 851 150 4.0" 
$ns at 274.2731820919899 "$node_(48) setdest 2356 933 12.0" 
$ns at 405.1772497257767 "$node_(48) setdest 1705 442 16.0" 
$ns at 546.6180749893344 "$node_(48) setdest 1334 802 3.0" 
$ns at 578.7641239730574 "$node_(48) setdest 2461 192 6.0" 
$ns at 645.1731140771279 "$node_(48) setdest 1703 777 11.0" 
$ns at 676.046527581003 "$node_(48) setdest 2860 183 2.0" 
$ns at 723.7076750587696 "$node_(48) setdest 1191 462 2.0" 
$ns at 766.2202911013266 "$node_(48) setdest 2805 1 6.0" 
$ns at 809.7536474832988 "$node_(48) setdest 2397 975 2.0" 
$ns at 844.7247371662693 "$node_(48) setdest 1309 780 8.0" 
$ns at 0.0 "$node_(49) setdest 1906 284 12.0" 
$ns at 83.96920273493768 "$node_(49) setdest 475 943 10.0" 
$ns at 183.9280393152332 "$node_(49) setdest 1293 533 10.0" 
$ns at 313.6018672094363 "$node_(49) setdest 1156 726 3.0" 
$ns at 370.1202886210881 "$node_(49) setdest 1551 811 1.0" 
$ns at 406.2331185806139 "$node_(49) setdest 1718 613 19.0" 
$ns at 581.4853397613838 "$node_(49) setdest 210 67 3.0" 
$ns at 628.3699241256335 "$node_(49) setdest 26 972 5.0" 
$ns at 673.648666530555 "$node_(49) setdest 2186 132 17.0" 
$ns at 765.7523449329037 "$node_(49) setdest 2588 517 1.0" 
$ns at 797.7641288418541 "$node_(49) setdest 2123 55 9.0" 
$ns at 836.4903206934596 "$node_(49) setdest 493 384 2.0" 
$ns at 880.8187517696228 "$node_(49) setdest 1766 211 3.0" 
$ns at 0.0 "$node_(50) setdest 1536 942 1.0" 
$ns at 35.25076121115258 "$node_(50) setdest 648 884 5.0" 
$ns at 73.54860510321336 "$node_(50) setdest 1707 641 1.0" 
$ns at 105.42346027091004 "$node_(50) setdest 1095 283 5.0" 
$ns at 146.35932364437048 "$node_(50) setdest 1928 498 6.0" 
$ns at 186.16711737912004 "$node_(50) setdest 353 205 8.0" 
$ns at 251.63586124988058 "$node_(50) setdest 2690 48 1.0" 
$ns at 286.68281698541875 "$node_(50) setdest 348 789 7.0" 
$ns at 330.8194481956246 "$node_(50) setdest 6 835 3.0" 
$ns at 379.45485587855967 "$node_(50) setdest 363 83 18.0" 
$ns at 411.7625974506348 "$node_(50) setdest 819 784 6.0" 
$ns at 487.73650400337687 "$node_(50) setdest 1653 368 5.0" 
$ns at 556.5945929325737 "$node_(50) setdest 1774 36 9.0" 
$ns at 598.7072327189093 "$node_(50) setdest 2785 454 6.0" 
$ns at 675.7932695794319 "$node_(50) setdest 2002 68 15.0" 
$ns at 813.5123889867821 "$node_(50) setdest 1221 401 4.0" 
$ns at 854.2483203045117 "$node_(50) setdest 1324 190 1.0" 
$ns at 887.3862624777694 "$node_(50) setdest 2429 375 5.0" 
$ns at 241.84220883257927 "$node_(51) setdest 88 633 11.0" 
$ns at 301.8951560911158 "$node_(51) setdest 1353 580 12.0" 
$ns at 332.4443855508264 "$node_(51) setdest 582 848 17.0" 
$ns at 379.10021255565755 "$node_(51) setdest 1149 138 9.0" 
$ns at 440.33484932177225 "$node_(51) setdest 2533 370 8.0" 
$ns at 530.360171529468 "$node_(51) setdest 1703 837 17.0" 
$ns at 686.6681585756515 "$node_(51) setdest 1512 469 19.0" 
$ns at 833.2547711646042 "$node_(51) setdest 2411 878 8.0" 
$ns at 896.0408748183395 "$node_(51) setdest 1782 176 17.0" 
$ns at 266.47911162834356 "$node_(52) setdest 1920 81 19.0" 
$ns at 430.22138577411545 "$node_(52) setdest 1670 863 12.0" 
$ns at 574.6780663864687 "$node_(52) setdest 944 484 14.0" 
$ns at 703.8494318467618 "$node_(52) setdest 2097 905 13.0" 
$ns at 814.2897040408155 "$node_(52) setdest 1915 215 3.0" 
$ns at 858.5183580048521 "$node_(52) setdest 1741 231 5.0" 
$ns at 897.3076750895193 "$node_(52) setdest 2504 986 16.0" 
$ns at 168.8800581323889 "$node_(53) setdest 2268 305 9.0" 
$ns at 259.0437124443514 "$node_(53) setdest 664 192 1.0" 
$ns at 289.6660919213663 "$node_(53) setdest 678 83 15.0" 
$ns at 338.06183561885905 "$node_(53) setdest 2041 804 9.0" 
$ns at 426.32098048512603 "$node_(53) setdest 536 321 13.0" 
$ns at 572.059144057094 "$node_(53) setdest 1599 571 2.0" 
$ns at 618.8192892047462 "$node_(53) setdest 1543 69 11.0" 
$ns at 727.7551372736314 "$node_(53) setdest 533 227 3.0" 
$ns at 763.4255868154672 "$node_(53) setdest 2559 134 20.0" 
$ns at 195.47766977556122 "$node_(54) setdest 129 506 4.0" 
$ns at 260.63433845378455 "$node_(54) setdest 258 966 7.0" 
$ns at 321.6289234274448 "$node_(54) setdest 864 768 14.0" 
$ns at 378.81167465244835 "$node_(54) setdest 2709 185 1.0" 
$ns at 414.0280401181394 "$node_(54) setdest 1211 646 9.0" 
$ns at 516.4396970379695 "$node_(54) setdest 31 851 8.0" 
$ns at 570.9174833763511 "$node_(54) setdest 17 632 12.0" 
$ns at 720.2619959409408 "$node_(54) setdest 1572 915 1.0" 
$ns at 756.1388006687152 "$node_(54) setdest 225 806 1.0" 
$ns at 786.3990883377878 "$node_(54) setdest 162 219 16.0" 
$ns at 185.34759260848685 "$node_(55) setdest 882 430 4.0" 
$ns at 253.34071627734227 "$node_(55) setdest 295 107 14.0" 
$ns at 415.6597648162882 "$node_(55) setdest 1806 740 16.0" 
$ns at 515.2642605111649 "$node_(55) setdest 1960 485 20.0" 
$ns at 667.3495857445923 "$node_(55) setdest 86 360 19.0" 
$ns at 790.5073464024521 "$node_(55) setdest 2316 452 10.0" 
$ns at 893.1717406757205 "$node_(55) setdest 1061 441 12.0" 
$ns at 185.04898149011527 "$node_(56) setdest 1224 429 1.0" 
$ns at 222.36865571417744 "$node_(56) setdest 1510 45 13.0" 
$ns at 312.32830180844576 "$node_(56) setdest 2067 642 18.0" 
$ns at 388.8584461430152 "$node_(56) setdest 607 842 13.0" 
$ns at 429.02814654464856 "$node_(56) setdest 2447 70 11.0" 
$ns at 562.8020656354066 "$node_(56) setdest 2400 984 3.0" 
$ns at 594.1905711766223 "$node_(56) setdest 983 531 1.0" 
$ns at 631.1749844732431 "$node_(56) setdest 534 467 10.0" 
$ns at 670.0399446414731 "$node_(56) setdest 1661 955 12.0" 
$ns at 738.4510660990804 "$node_(56) setdest 384 352 15.0" 
$ns at 898.516919213731 "$node_(56) setdest 615 405 7.0" 
$ns at 210.60895230606604 "$node_(57) setdest 846 768 4.0" 
$ns at 244.35280280178156 "$node_(57) setdest 1629 692 19.0" 
$ns at 410.3760674255337 "$node_(57) setdest 1401 84 6.0" 
$ns at 493.82993630331447 "$node_(57) setdest 780 630 9.0" 
$ns at 578.7914790855001 "$node_(57) setdest 2984 516 1.0" 
$ns at 612.1221645629746 "$node_(57) setdest 2296 37 20.0" 
$ns at 691.5188413112577 "$node_(57) setdest 256 374 18.0" 
$ns at 816.4498449228304 "$node_(57) setdest 419 74 12.0" 
$ns at 893.3495036258139 "$node_(57) setdest 2113 110 10.0" 
$ns at 232.11883892004224 "$node_(58) setdest 596 795 17.0" 
$ns at 312.5514009184535 "$node_(58) setdest 1629 316 20.0" 
$ns at 419.887996038705 "$node_(58) setdest 2435 669 8.0" 
$ns at 462.20131143376886 "$node_(58) setdest 1964 217 7.0" 
$ns at 528.0073606486453 "$node_(58) setdest 2919 259 10.0" 
$ns at 605.9916821187123 "$node_(58) setdest 1767 285 3.0" 
$ns at 662.2233849812212 "$node_(58) setdest 1411 617 6.0" 
$ns at 730.851028395668 "$node_(58) setdest 1511 610 15.0" 
$ns at 212.92569223922817 "$node_(59) setdest 2222 582 8.0" 
$ns at 270.50496290517515 "$node_(59) setdest 22 377 15.0" 
$ns at 313.36612036034205 "$node_(59) setdest 2280 671 11.0" 
$ns at 356.58224141518343 "$node_(59) setdest 2513 396 9.0" 
$ns at 446.3741202207666 "$node_(59) setdest 188 405 13.0" 
$ns at 595.1100819338233 "$node_(59) setdest 2162 4 14.0" 
$ns at 652.876846350946 "$node_(59) setdest 1566 814 11.0" 
$ns at 790.8025174006987 "$node_(59) setdest 2298 816 2.0" 
$ns at 834.3318322709817 "$node_(59) setdest 1195 492 3.0" 
$ns at 881.9286240646929 "$node_(59) setdest 2997 747 5.0" 
$ns at 228.03734825572866 "$node_(60) setdest 2875 862 9.0" 
$ns at 320.16512276634114 "$node_(60) setdest 1592 277 8.0" 
$ns at 395.22121573352547 "$node_(60) setdest 2825 504 18.0" 
$ns at 441.0648684559536 "$node_(60) setdest 2856 783 17.0" 
$ns at 597.5101922673757 "$node_(60) setdest 314 922 5.0" 
$ns at 675.8265103938649 "$node_(60) setdest 1291 867 17.0" 
$ns at 750.0630512306753 "$node_(60) setdest 2895 295 10.0" 
$ns at 844.5002206452699 "$node_(60) setdest 2843 440 7.0" 
$ns at 172.38076383721457 "$node_(61) setdest 370 773 19.0" 
$ns at 312.1056832925067 "$node_(61) setdest 2771 843 7.0" 
$ns at 403.90828356172597 "$node_(61) setdest 2602 927 12.0" 
$ns at 447.49224432289753 "$node_(61) setdest 728 745 16.0" 
$ns at 487.664260607314 "$node_(61) setdest 830 351 19.0" 
$ns at 562.8615572108432 "$node_(61) setdest 2876 770 20.0" 
$ns at 616.0960917567162 "$node_(61) setdest 2570 482 1.0" 
$ns at 647.4570552662004 "$node_(61) setdest 1387 717 10.0" 
$ns at 744.5608081145031 "$node_(61) setdest 2717 707 16.0" 
$ns at 802.6571267474015 "$node_(61) setdest 1782 869 7.0" 
$ns at 882.5619948570894 "$node_(61) setdest 1300 416 20.0" 
$ns at 207.7434731402837 "$node_(62) setdest 2575 872 7.0" 
$ns at 288.2500490426045 "$node_(62) setdest 1279 406 17.0" 
$ns at 417.43824195898964 "$node_(62) setdest 1903 910 18.0" 
$ns at 516.7938723425842 "$node_(62) setdest 2904 27 14.0" 
$ns at 548.6210270811017 "$node_(62) setdest 2428 368 1.0" 
$ns at 587.8070366775235 "$node_(62) setdest 52 86 11.0" 
$ns at 654.2396358820151 "$node_(62) setdest 724 846 3.0" 
$ns at 707.872058732318 "$node_(62) setdest 361 774 11.0" 
$ns at 847.0319067005175 "$node_(62) setdest 290 617 13.0" 
$ns at 177.632155025964 "$node_(63) setdest 131 919 17.0" 
$ns at 333.9877370173707 "$node_(63) setdest 1856 336 1.0" 
$ns at 372.4268679933749 "$node_(63) setdest 489 365 9.0" 
$ns at 432.2424556070388 "$node_(63) setdest 456 821 13.0" 
$ns at 504.4973574597256 "$node_(63) setdest 2247 38 9.0" 
$ns at 535.6390451639215 "$node_(63) setdest 1408 830 6.0" 
$ns at 618.8237229575368 "$node_(63) setdest 686 53 2.0" 
$ns at 657.8049417221602 "$node_(63) setdest 2236 216 9.0" 
$ns at 754.3650074610343 "$node_(63) setdest 2121 169 8.0" 
$ns at 850.1194409860018 "$node_(63) setdest 2961 181 17.0" 
$ns at 187.80722027286242 "$node_(64) setdest 2577 242 15.0" 
$ns at 359.97451093339896 "$node_(64) setdest 372 584 13.0" 
$ns at 420.0052479170356 "$node_(64) setdest 2115 95 14.0" 
$ns at 487.0001096436623 "$node_(64) setdest 2514 408 5.0" 
$ns at 554.2306040161568 "$node_(64) setdest 221 338 17.0" 
$ns at 667.5606049278626 "$node_(64) setdest 123 74 1.0" 
$ns at 702.7646073517686 "$node_(64) setdest 1734 893 4.0" 
$ns at 758.0914114329032 "$node_(64) setdest 1717 846 2.0" 
$ns at 791.3478606868171 "$node_(64) setdest 2985 627 6.0" 
$ns at 856.4338857471203 "$node_(64) setdest 500 284 1.0" 
$ns at 894.1349254979497 "$node_(64) setdest 746 507 16.0" 
$ns at 287.9067274486401 "$node_(65) setdest 2076 134 3.0" 
$ns at 345.08959123009544 "$node_(65) setdest 757 666 20.0" 
$ns at 437.25135872483446 "$node_(65) setdest 1362 51 15.0" 
$ns at 475.7576923665924 "$node_(65) setdest 85 936 1.0" 
$ns at 512.1483702606414 "$node_(65) setdest 2743 798 11.0" 
$ns at 575.130937935148 "$node_(65) setdest 2182 761 3.0" 
$ns at 634.5175669906714 "$node_(65) setdest 1406 775 4.0" 
$ns at 685.7852582109048 "$node_(65) setdest 2463 257 8.0" 
$ns at 783.2113145975901 "$node_(65) setdest 638 173 6.0" 
$ns at 853.4487335395839 "$node_(65) setdest 194 241 19.0" 
$ns at 200.24814344908663 "$node_(66) setdest 353 637 6.0" 
$ns at 232.08929176159938 "$node_(66) setdest 2856 959 10.0" 
$ns at 335.36958515558473 "$node_(66) setdest 1411 290 1.0" 
$ns at 373.00090738602216 "$node_(66) setdest 2707 813 8.0" 
$ns at 403.05331612259874 "$node_(66) setdest 2208 542 11.0" 
$ns at 438.59364392223364 "$node_(66) setdest 1081 312 11.0" 
$ns at 567.4048643646287 "$node_(66) setdest 1809 141 1.0" 
$ns at 607.1810118100368 "$node_(66) setdest 19 769 18.0" 
$ns at 770.6429599152347 "$node_(66) setdest 8 311 9.0" 
$ns at 865.899850787997 "$node_(66) setdest 2540 822 3.0" 
$ns at 899.6441883380912 "$node_(66) setdest 861 83 18.0" 
$ns at 269.15545182607343 "$node_(67) setdest 1010 544 20.0" 
$ns at 424.66527241059043 "$node_(67) setdest 2602 151 19.0" 
$ns at 515.6279650346203 "$node_(67) setdest 366 702 14.0" 
$ns at 665.8026932144014 "$node_(67) setdest 1687 303 14.0" 
$ns at 698.1051706245271 "$node_(67) setdest 381 575 14.0" 
$ns at 861.6567282937986 "$node_(67) setdest 2134 973 9.0" 
$ns at 369.5162379575726 "$node_(68) setdest 1062 314 18.0" 
$ns at 430.54474269424134 "$node_(68) setdest 2547 586 19.0" 
$ns at 633.3613387311248 "$node_(68) setdest 1173 230 7.0" 
$ns at 725.650604036422 "$node_(68) setdest 1272 511 11.0" 
$ns at 856.9570060730514 "$node_(68) setdest 2364 782 6.0" 
$ns at 176.41926507506236 "$node_(69) setdest 1065 764 9.0" 
$ns at 213.39925743745607 "$node_(69) setdest 1194 214 13.0" 
$ns at 330.3626201157715 "$node_(69) setdest 375 120 14.0" 
$ns at 496.92576628768563 "$node_(69) setdest 1353 81 13.0" 
$ns at 585.1570177001199 "$node_(69) setdest 2346 35 7.0" 
$ns at 669.9240875952935 "$node_(69) setdest 118 239 18.0" 
$ns at 870.958112605269 "$node_(69) setdest 719 911 17.0" 
$ns at 199.39321691162542 "$node_(70) setdest 2928 564 18.0" 
$ns at 335.1829143003261 "$node_(70) setdest 655 918 9.0" 
$ns at 404.1900068150301 "$node_(70) setdest 2037 136 6.0" 
$ns at 446.94736232045926 "$node_(70) setdest 557 203 15.0" 
$ns at 497.7491823340938 "$node_(70) setdest 1659 216 10.0" 
$ns at 578.875152790901 "$node_(70) setdest 903 834 4.0" 
$ns at 621.7394596580231 "$node_(70) setdest 1435 736 14.0" 
$ns at 684.7712580058653 "$node_(70) setdest 1194 118 7.0" 
$ns at 745.2387776879618 "$node_(70) setdest 1876 704 17.0" 
$ns at 227.49454609057335 "$node_(71) setdest 146 313 19.0" 
$ns at 269.41336786357346 "$node_(71) setdest 796 803 13.0" 
$ns at 369.55979859956705 "$node_(71) setdest 2819 306 16.0" 
$ns at 441.85421877919134 "$node_(71) setdest 1004 489 12.0" 
$ns at 563.4828174014551 "$node_(71) setdest 2658 694 4.0" 
$ns at 632.7955590445083 "$node_(71) setdest 1081 957 17.0" 
$ns at 769.350162940981 "$node_(71) setdest 1473 452 11.0" 
$ns at 808.0239010497417 "$node_(71) setdest 938 929 19.0" 
$ns at 214.97972148798635 "$node_(72) setdest 2178 992 14.0" 
$ns at 328.249877139682 "$node_(72) setdest 1494 282 9.0" 
$ns at 439.2725531928174 "$node_(72) setdest 2994 727 13.0" 
$ns at 515.7088409389233 "$node_(72) setdest 354 665 19.0" 
$ns at 571.5645522530991 "$node_(72) setdest 2913 448 3.0" 
$ns at 620.732941948926 "$node_(72) setdest 2944 392 13.0" 
$ns at 672.4396385137075 "$node_(72) setdest 2292 656 7.0" 
$ns at 751.1893316763428 "$node_(72) setdest 2883 641 4.0" 
$ns at 808.0240301884885 "$node_(72) setdest 1498 669 18.0" 
$ns at 196.46493519322104 "$node_(73) setdest 1987 485 14.0" 
$ns at 364.7497504061257 "$node_(73) setdest 1930 280 10.0" 
$ns at 402.6955426682561 "$node_(73) setdest 2067 709 20.0" 
$ns at 626.6933861534931 "$node_(73) setdest 90 609 1.0" 
$ns at 665.4974179636444 "$node_(73) setdest 211 108 1.0" 
$ns at 700.4435199106334 "$node_(73) setdest 292 10 16.0" 
$ns at 855.9656552231306 "$node_(73) setdest 674 976 1.0" 
$ns at 891.3117710195531 "$node_(73) setdest 1194 225 9.0" 
$ns at 185.21766205470513 "$node_(74) setdest 1967 335 11.0" 
$ns at 305.06616824475464 "$node_(74) setdest 1060 359 7.0" 
$ns at 335.5951810311993 "$node_(74) setdest 1314 845 2.0" 
$ns at 384.5983148145034 "$node_(74) setdest 2577 289 9.0" 
$ns at 436.360148375548 "$node_(74) setdest 2873 277 3.0" 
$ns at 482.18592427385636 "$node_(74) setdest 697 849 1.0" 
$ns at 512.7275462242739 "$node_(74) setdest 1486 154 10.0" 
$ns at 594.6553719541195 "$node_(74) setdest 957 282 10.0" 
$ns at 631.7868870557132 "$node_(74) setdest 883 392 10.0" 
$ns at 741.6279823240108 "$node_(74) setdest 2084 221 6.0" 
$ns at 812.4989872917963 "$node_(74) setdest 1730 642 1.0" 
$ns at 850.2856293057694 "$node_(74) setdest 704 170 3.0" 
$ns at 891.2888912365396 "$node_(74) setdest 529 250 17.0" 
$ns at 441.16476153325374 "$node_(75) setdest 1519 384 8.0" 
$ns at 507.38348501006834 "$node_(75) setdest 144 610 6.0" 
$ns at 562.6181594002667 "$node_(75) setdest 1743 245 5.0" 
$ns at 593.2882200366868 "$node_(75) setdest 152 977 19.0" 
$ns at 739.4077104881939 "$node_(75) setdest 1688 192 2.0" 
$ns at 770.633653656264 "$node_(75) setdest 2292 800 2.0" 
$ns at 814.0517788689589 "$node_(75) setdest 2313 46 1.0" 
$ns at 848.7021039352874 "$node_(75) setdest 1815 368 6.0" 
$ns at 879.9328384144043 "$node_(75) setdest 751 150 1.0" 
$ns at 333.69426611719837 "$node_(76) setdest 1058 910 1.0" 
$ns at 373.61041031000315 "$node_(76) setdest 2011 196 10.0" 
$ns at 450.36231472337056 "$node_(76) setdest 461 406 2.0" 
$ns at 488.5639584783344 "$node_(76) setdest 895 693 7.0" 
$ns at 584.1258898488526 "$node_(76) setdest 744 276 1.0" 
$ns at 614.7396623095369 "$node_(76) setdest 1162 746 1.0" 
$ns at 654.6380906964038 "$node_(76) setdest 205 644 1.0" 
$ns at 689.2671435489605 "$node_(76) setdest 852 962 2.0" 
$ns at 731.0420781309269 "$node_(76) setdest 966 823 9.0" 
$ns at 844.2376053384996 "$node_(76) setdest 283 896 4.0" 
$ns at 876.2729399468873 "$node_(76) setdest 2637 20 5.0" 
$ns at 398.3590067541261 "$node_(77) setdest 841 927 14.0" 
$ns at 434.4889009738403 "$node_(77) setdest 352 20 4.0" 
$ns at 485.8020867530123 "$node_(77) setdest 313 763 3.0" 
$ns at 534.5779884704975 "$node_(77) setdest 2978 984 6.0" 
$ns at 587.013923931861 "$node_(77) setdest 2381 245 2.0" 
$ns at 630.4492831456804 "$node_(77) setdest 1733 469 9.0" 
$ns at 738.6111086346021 "$node_(77) setdest 2607 661 16.0" 
$ns at 822.494565193599 "$node_(77) setdest 2234 203 5.0" 
$ns at 863.3187913330129 "$node_(77) setdest 2739 969 19.0" 
$ns at 396.2278242939195 "$node_(78) setdest 1086 424 6.0" 
$ns at 479.17428459034875 "$node_(78) setdest 1566 536 7.0" 
$ns at 571.9244342631581 "$node_(78) setdest 2535 916 10.0" 
$ns at 668.213277992148 "$node_(78) setdest 1054 641 13.0" 
$ns at 739.0553035959445 "$node_(78) setdest 505 173 9.0" 
$ns at 858.4124878575435 "$node_(78) setdest 1525 830 3.0" 
$ns at 892.7430201406233 "$node_(78) setdest 1043 864 11.0" 
$ns at 350.814653124154 "$node_(79) setdest 1849 768 7.0" 
$ns at 408.7914273704703 "$node_(79) setdest 18 164 13.0" 
$ns at 480.22801086684217 "$node_(79) setdest 1001 473 12.0" 
$ns at 559.2046987924573 "$node_(79) setdest 584 487 10.0" 
$ns at 682.1773764091882 "$node_(79) setdest 2215 619 17.0" 
$ns at 781.7187250275982 "$node_(79) setdest 2591 725 15.0" 
$ns at 419.30655185174817 "$node_(80) setdest 1177 258 11.0" 
$ns at 530.314801150819 "$node_(80) setdest 1070 300 5.0" 
$ns at 597.9615961376501 "$node_(80) setdest 1341 893 4.0" 
$ns at 660.860847874874 "$node_(80) setdest 2695 539 18.0" 
$ns at 801.2500150862841 "$node_(80) setdest 1312 134 13.0" 
$ns at 889.4169356773045 "$node_(80) setdest 2506 450 13.0" 
$ns at 483.4552893583349 "$node_(81) setdest 1690 394 13.0" 
$ns at 597.2195471288733 "$node_(81) setdest 539 967 16.0" 
$ns at 695.605443279682 "$node_(81) setdest 2833 594 14.0" 
$ns at 861.7541559982913 "$node_(81) setdest 2199 706 8.0" 
$ns at 332.0590716668613 "$node_(82) setdest 1247 718 7.0" 
$ns at 385.87780054985353 "$node_(82) setdest 693 125 14.0" 
$ns at 502.8277637544652 "$node_(82) setdest 1969 321 12.0" 
$ns at 651.9118578716857 "$node_(82) setdest 452 452 14.0" 
$ns at 757.2449857033982 "$node_(82) setdest 331 822 9.0" 
$ns at 842.8085248740666 "$node_(82) setdest 940 673 14.0" 
$ns at 339.8638001685494 "$node_(83) setdest 1099 49 13.0" 
$ns at 427.5347768556946 "$node_(83) setdest 1627 958 20.0" 
$ns at 544.3169385779914 "$node_(83) setdest 206 185 12.0" 
$ns at 619.8243073215135 "$node_(83) setdest 485 417 1.0" 
$ns at 658.0300931827244 "$node_(83) setdest 1977 647 20.0" 
$ns at 791.8201041860868 "$node_(83) setdest 508 809 1.0" 
$ns at 831.6861955295736 "$node_(83) setdest 2731 78 9.0" 
$ns at 897.6134519191398 "$node_(83) setdest 1103 353 15.0" 
$ns at 414.09006106632364 "$node_(84) setdest 185 93 9.0" 
$ns at 472.3189240217214 "$node_(84) setdest 2623 133 8.0" 
$ns at 545.5347768845782 "$node_(84) setdest 528 40 9.0" 
$ns at 664.6413063905198 "$node_(84) setdest 2903 981 14.0" 
$ns at 791.4155477827597 "$node_(84) setdest 2653 331 9.0" 
$ns at 823.2326570360091 "$node_(84) setdest 297 968 1.0" 
$ns at 858.4798486652734 "$node_(84) setdest 276 555 6.0" 
$ns at 424.75817148733404 "$node_(85) setdest 1508 416 20.0" 
$ns at 624.0549403772409 "$node_(85) setdest 764 147 6.0" 
$ns at 680.3006845580323 "$node_(85) setdest 342 862 18.0" 
$ns at 754.5495635479117 "$node_(85) setdest 1819 420 14.0" 
$ns at 841.5770594828556 "$node_(85) setdest 999 102 1.0" 
$ns at 880.9715669502523 "$node_(85) setdest 99 210 19.0" 
$ns at 381.39906874453936 "$node_(86) setdest 1453 475 5.0" 
$ns at 418.80309433369723 "$node_(86) setdest 761 320 6.0" 
$ns at 453.4791395131398 "$node_(86) setdest 2479 912 4.0" 
$ns at 509.51593710283066 "$node_(86) setdest 1552 55 10.0" 
$ns at 621.2025044095828 "$node_(86) setdest 1414 641 16.0" 
$ns at 743.2828630756061 "$node_(86) setdest 451 790 12.0" 
$ns at 832.9457822866077 "$node_(86) setdest 32 215 12.0" 
$ns at 356.4215996881287 "$node_(87) setdest 2459 399 13.0" 
$ns at 434.2899733018048 "$node_(87) setdest 2382 713 16.0" 
$ns at 525.1480907339028 "$node_(87) setdest 193 798 3.0" 
$ns at 584.9494525866147 "$node_(87) setdest 1460 194 12.0" 
$ns at 730.2940381903802 "$node_(87) setdest 1592 988 2.0" 
$ns at 767.3811059604299 "$node_(87) setdest 2526 484 5.0" 
$ns at 823.8703965568907 "$node_(87) setdest 2722 314 2.0" 
$ns at 866.1486302114454 "$node_(87) setdest 538 90 5.0" 
$ns at 896.4089503638302 "$node_(87) setdest 1483 297 5.0" 
$ns at 486.56968152607413 "$node_(88) setdest 2916 893 19.0" 
$ns at 606.5924298103249 "$node_(88) setdest 729 926 9.0" 
$ns at 718.6621327899279 "$node_(88) setdest 1807 998 9.0" 
$ns at 790.4048185917759 "$node_(88) setdest 704 198 1.0" 
$ns at 820.9450310723231 "$node_(88) setdest 1575 117 15.0" 
$ns at 867.9828006375274 "$node_(88) setdest 1816 237 5.0" 
$ns at 366.1224414999063 "$node_(89) setdest 1569 525 2.0" 
$ns at 415.03227921093236 "$node_(89) setdest 181 697 11.0" 
$ns at 519.0392515640783 "$node_(89) setdest 292 996 7.0" 
$ns at 605.9216851330551 "$node_(89) setdest 2538 789 13.0" 
$ns at 701.6293718841187 "$node_(89) setdest 149 180 4.0" 
$ns at 770.6646419004495 "$node_(89) setdest 1560 490 17.0" 
$ns at 424.9168809284985 "$node_(90) setdest 1440 940 19.0" 
$ns at 466.80921979162224 "$node_(90) setdest 2628 405 18.0" 
$ns at 588.301105018358 "$node_(90) setdest 894 706 9.0" 
$ns at 691.6206129547401 "$node_(90) setdest 1440 478 8.0" 
$ns at 755.153521753954 "$node_(90) setdest 719 649 11.0" 
$ns at 795.981269092714 "$node_(90) setdest 2017 466 19.0" 
$ns at 335.3111315258987 "$node_(91) setdest 224 75 12.0" 
$ns at 482.0908030568261 "$node_(91) setdest 582 507 16.0" 
$ns at 652.3962068176306 "$node_(91) setdest 1438 159 2.0" 
$ns at 685.4063686025659 "$node_(91) setdest 1138 492 12.0" 
$ns at 772.6655152863191 "$node_(91) setdest 1245 788 20.0" 
$ns at 812.501626305447 "$node_(91) setdest 1459 782 18.0" 
$ns at 534.8336538323362 "$node_(92) setdest 2199 255 18.0" 
$ns at 711.8834330201805 "$node_(92) setdest 2499 830 5.0" 
$ns at 742.2536677537774 "$node_(92) setdest 564 574 4.0" 
$ns at 803.0492757105404 "$node_(92) setdest 2406 312 7.0" 
$ns at 864.2720289881721 "$node_(92) setdest 2198 320 4.0" 
$ns at 402.1921198492522 "$node_(93) setdest 2610 92 15.0" 
$ns at 532.0036201485933 "$node_(93) setdest 2750 541 10.0" 
$ns at 573.58962133578 "$node_(93) setdest 487 764 18.0" 
$ns at 743.3370913873548 "$node_(93) setdest 2485 764 16.0" 
$ns at 866.3321719452217 "$node_(93) setdest 1512 14 18.0" 
$ns at 371.8474850609778 "$node_(94) setdest 2269 898 12.0" 
$ns at 428.4049581504248 "$node_(94) setdest 1181 530 14.0" 
$ns at 558.5822486465829 "$node_(94) setdest 2502 224 9.0" 
$ns at 616.6809192565523 "$node_(94) setdest 36 142 9.0" 
$ns at 696.9482632387882 "$node_(94) setdest 718 207 10.0" 
$ns at 808.605974739446 "$node_(94) setdest 84 805 1.0" 
$ns at 839.4201772327445 "$node_(94) setdest 1344 492 18.0" 
$ns at 884.6116569887926 "$node_(94) setdest 1013 480 16.0" 
$ns at 383.48680443142655 "$node_(95) setdest 617 649 12.0" 
$ns at 427.8852624206626 "$node_(95) setdest 15 200 8.0" 
$ns at 501.2300911007819 "$node_(95) setdest 1891 562 6.0" 
$ns at 545.0752262425833 "$node_(95) setdest 119 906 1.0" 
$ns at 578.4738326846712 "$node_(95) setdest 834 71 17.0" 
$ns at 711.4612368150666 "$node_(95) setdest 2288 200 19.0" 
$ns at 846.2560354716894 "$node_(95) setdest 930 34 3.0" 
$ns at 883.6596447138952 "$node_(95) setdest 2058 60 12.0" 
$ns at 363.471112764385 "$node_(96) setdest 273 895 13.0" 
$ns at 397.27266384079945 "$node_(96) setdest 2766 379 18.0" 
$ns at 574.238579710574 "$node_(96) setdest 2583 512 12.0" 
$ns at 666.0457351143319 "$node_(96) setdest 2639 361 8.0" 
$ns at 771.8031513062169 "$node_(96) setdest 73 206 2.0" 
$ns at 807.8013883667356 "$node_(96) setdest 654 616 7.0" 
$ns at 891.4293352773827 "$node_(96) setdest 1637 345 15.0" 
$ns at 430.02472605717236 "$node_(97) setdest 155 330 1.0" 
$ns at 465.1765076931477 "$node_(97) setdest 2659 989 7.0" 
$ns at 515.2113822078335 "$node_(97) setdest 2722 319 14.0" 
$ns at 604.7540906059949 "$node_(97) setdest 381 108 6.0" 
$ns at 691.1010698433629 "$node_(97) setdest 1531 309 14.0" 
$ns at 814.4506269161759 "$node_(97) setdest 2876 887 16.0" 
$ns at 885.1125764073186 "$node_(97) setdest 1644 127 9.0" 
$ns at 359.90523556727584 "$node_(98) setdest 1161 371 2.0" 
$ns at 391.140362398228 "$node_(98) setdest 1481 237 13.0" 
$ns at 426.0960486807784 "$node_(98) setdest 1788 169 1.0" 
$ns at 459.8943817191759 "$node_(98) setdest 307 449 18.0" 
$ns at 553.4014310908649 "$node_(98) setdest 2247 381 7.0" 
$ns at 609.74036749932 "$node_(98) setdest 1366 331 11.0" 
$ns at 747.1222409581624 "$node_(98) setdest 1249 707 7.0" 
$ns at 782.6007265574433 "$node_(98) setdest 1471 762 3.0" 
$ns at 822.4144411730214 "$node_(98) setdest 517 761 1.0" 
$ns at 856.8605919891617 "$node_(98) setdest 274 276 16.0" 
$ns at 511.0378584814081 "$node_(99) setdest 2617 865 13.0" 
$ns at 619.9911832382237 "$node_(99) setdest 43 122 11.0" 
$ns at 720.0034869414116 "$node_(99) setdest 838 495 15.0" 
$ns at 865.5182917295947 "$node_(99) setdest 2137 5 5.0" 
$ns at 576.5392547391929 "$node_(100) setdest 2406 727 20.0" 
$ns at 703.7702849177007 "$node_(100) setdest 123 206 19.0" 
$ns at 840.490622412725 "$node_(100) setdest 2180 229 19.0" 
$ns at 594.1561241340917 "$node_(101) setdest 2514 577 15.0" 
$ns at 675.8924775119544 "$node_(101) setdest 1407 226 19.0" 
$ns at 809.5808472669687 "$node_(101) setdest 1103 156 19.0" 
$ns at 585.5410047578225 "$node_(102) setdest 188 231 13.0" 
$ns at 619.2497273016292 "$node_(102) setdest 2240 233 1.0" 
$ns at 657.773786325603 "$node_(102) setdest 2789 323 6.0" 
$ns at 712.3002877462573 "$node_(102) setdest 591 511 11.0" 
$ns at 769.6391771275049 "$node_(102) setdest 1002 755 19.0" 
$ns at 567.5904794070678 "$node_(103) setdest 1647 767 20.0" 
$ns at 716.1523512509973 "$node_(103) setdest 2964 899 10.0" 
$ns at 765.7704392771634 "$node_(103) setdest 1792 941 2.0" 
$ns at 813.0817835303957 "$node_(103) setdest 2244 944 9.0" 
$ns at 873.8317257914656 "$node_(103) setdest 84 72 7.0" 
$ns at 516.3147064735381 "$node_(104) setdest 1800 513 8.0" 
$ns at 588.7100306917735 "$node_(104) setdest 1821 992 16.0" 
$ns at 675.4083131368723 "$node_(104) setdest 1169 934 7.0" 
$ns at 730.2787387859212 "$node_(104) setdest 2705 717 1.0" 
$ns at 767.4605187776112 "$node_(104) setdest 1780 945 17.0" 
$ns at 827.1704172995425 "$node_(104) setdest 2172 150 16.0" 
$ns at 895.183153880099 "$node_(104) setdest 721 772 18.0" 
$ns at 512.9935228887401 "$node_(105) setdest 2176 595 4.0" 
$ns at 571.8231362040023 "$node_(105) setdest 2963 502 8.0" 
$ns at 667.7701324039458 "$node_(105) setdest 2901 375 10.0" 
$ns at 782.6137044484317 "$node_(105) setdest 800 803 20.0" 
$ns at 539.7509180733689 "$node_(106) setdest 1656 999 1.0" 
$ns at 570.4512551076999 "$node_(106) setdest 2202 753 9.0" 
$ns at 601.3429742855915 "$node_(106) setdest 2545 402 14.0" 
$ns at 656.6992845823639 "$node_(106) setdest 2137 474 10.0" 
$ns at 708.3505659940707 "$node_(106) setdest 2526 209 13.0" 
$ns at 830.1335276238492 "$node_(106) setdest 1843 402 2.0" 
$ns at 862.3217865136205 "$node_(106) setdest 2199 625 19.0" 
$ns at 893.4677409820409 "$node_(106) setdest 2173 98 13.0" 
$ns at 597.1282605446072 "$node_(107) setdest 2712 486 12.0" 
$ns at 707.4792795028211 "$node_(107) setdest 2592 897 6.0" 
$ns at 780.1138140463657 "$node_(107) setdest 1946 836 4.0" 
$ns at 810.9207030402633 "$node_(107) setdest 577 132 16.0" 
$ns at 856.1035927705507 "$node_(107) setdest 153 252 15.0" 
$ns at 651.7271501696312 "$node_(108) setdest 2240 840 14.0" 
$ns at 785.1671934964893 "$node_(108) setdest 2299 993 11.0" 
$ns at 883.609428426731 "$node_(108) setdest 1343 229 11.0" 
$ns at 566.0724357507419 "$node_(109) setdest 2410 379 4.0" 
$ns at 619.4965377556304 "$node_(109) setdest 731 849 12.0" 
$ns at 711.7758663877044 "$node_(109) setdest 1881 576 2.0" 
$ns at 755.2042936975297 "$node_(109) setdest 1952 809 12.0" 
$ns at 895.754965881765 "$node_(109) setdest 324 485 16.0" 
$ns at 562.8318436651405 "$node_(110) setdest 989 810 6.0" 
$ns at 643.3196240132662 "$node_(110) setdest 1700 982 3.0" 
$ns at 680.5794128396333 "$node_(110) setdest 2498 798 7.0" 
$ns at 757.1165072958892 "$node_(110) setdest 2386 683 18.0" 
$ns at 812.6899533192377 "$node_(110) setdest 2096 762 1.0" 
$ns at 849.3415071076064 "$node_(110) setdest 917 246 6.0" 
$ns at 597.8400964533033 "$node_(111) setdest 1879 112 13.0" 
$ns at 647.5316290679123 "$node_(111) setdest 955 331 14.0" 
$ns at 734.7365083554832 "$node_(111) setdest 1553 978 15.0" 
$ns at 880.3410590837342 "$node_(111) setdest 667 665 7.0" 
$ns at 546.379434390557 "$node_(112) setdest 2499 163 18.0" 
$ns at 593.6666814046702 "$node_(112) setdest 1236 42 6.0" 
$ns at 677.7389187357696 "$node_(112) setdest 194 254 2.0" 
$ns at 723.1601614409558 "$node_(112) setdest 464 299 19.0" 
$ns at 811.5431378221298 "$node_(112) setdest 2332 777 15.0" 
$ns at 503.8966187884935 "$node_(113) setdest 944 668 12.0" 
$ns at 552.3979058934478 "$node_(113) setdest 1292 319 2.0" 
$ns at 587.1136027735163 "$node_(113) setdest 487 561 5.0" 
$ns at 660.4900515455984 "$node_(113) setdest 331 676 8.0" 
$ns at 692.1866474194183 "$node_(113) setdest 1092 988 9.0" 
$ns at 760.2921996982606 "$node_(113) setdest 1331 895 17.0" 
$ns at 520.4983489813994 "$node_(114) setdest 693 117 18.0" 
$ns at 686.7253503382121 "$node_(114) setdest 723 562 7.0" 
$ns at 730.7819956155944 "$node_(114) setdest 2249 886 10.0" 
$ns at 841.6508595934789 "$node_(114) setdest 1979 529 6.0" 
$ns at 514.5355735285862 "$node_(115) setdest 2411 767 1.0" 
$ns at 549.8209596359027 "$node_(115) setdest 190 22 11.0" 
$ns at 636.7224239565938 "$node_(115) setdest 1043 249 4.0" 
$ns at 691.8463934147592 "$node_(115) setdest 2521 819 4.0" 
$ns at 727.306842920438 "$node_(115) setdest 345 431 8.0" 
$ns at 781.4454902923294 "$node_(115) setdest 1904 856 6.0" 
$ns at 850.5216640349066 "$node_(115) setdest 575 307 5.0" 
$ns at 882.6776467655507 "$node_(115) setdest 1827 650 12.0" 
$ns at 515.4883648188776 "$node_(116) setdest 2336 591 4.0" 
$ns at 553.7395995336229 "$node_(116) setdest 646 688 19.0" 
$ns at 626.2449247614268 "$node_(116) setdest 429 534 2.0" 
$ns at 666.4455679367527 "$node_(116) setdest 285 276 6.0" 
$ns at 751.7182739196212 "$node_(116) setdest 2335 860 1.0" 
$ns at 790.5196277791813 "$node_(116) setdest 529 444 4.0" 
$ns at 860.3906246231282 "$node_(116) setdest 746 511 4.0" 
$ns at 537.6471170505982 "$node_(117) setdest 216 479 17.0" 
$ns at 581.8063693322975 "$node_(117) setdest 1764 691 18.0" 
$ns at 700.3589623006427 "$node_(117) setdest 2027 460 12.0" 
$ns at 737.4657427630674 "$node_(117) setdest 1263 37 11.0" 
$ns at 857.0952170527851 "$node_(117) setdest 2671 463 1.0" 
$ns at 896.0402991986867 "$node_(117) setdest 1407 571 4.0" 
$ns at 504.032902933883 "$node_(118) setdest 181 231 12.0" 
$ns at 583.860399526614 "$node_(118) setdest 488 669 16.0" 
$ns at 699.3043473211236 "$node_(118) setdest 344 406 7.0" 
$ns at 760.3830708067277 "$node_(118) setdest 144 864 10.0" 
$ns at 804.9241505344307 "$node_(118) setdest 2739 269 3.0" 
$ns at 852.3614890096552 "$node_(118) setdest 2099 5 14.0" 
$ns at 892.5731252475439 "$node_(118) setdest 163 89 19.0" 
$ns at 519.4480099840633 "$node_(119) setdest 1841 927 8.0" 
$ns at 593.8204204696999 "$node_(119) setdest 999 96 1.0" 
$ns at 625.2147083747765 "$node_(119) setdest 1426 817 7.0" 
$ns at 708.0067911076765 "$node_(119) setdest 1658 494 15.0" 
$ns at 855.9633171932201 "$node_(119) setdest 2935 566 18.0" 
$ns at 593.699771740095 "$node_(120) setdest 1392 784 16.0" 
$ns at 648.6857721836423 "$node_(120) setdest 2603 470 18.0" 
$ns at 810.0958011870323 "$node_(120) setdest 694 87 1.0" 
$ns at 844.2726670266422 "$node_(120) setdest 211 538 11.0" 
$ns at 632.6079105520007 "$node_(121) setdest 215 256 16.0" 
$ns at 698.5103782377336 "$node_(121) setdest 2916 971 8.0" 
$ns at 751.7983472067938 "$node_(121) setdest 1760 358 19.0" 
$ns at 543.6935758001928 "$node_(122) setdest 2467 106 6.0" 
$ns at 614.4407824891645 "$node_(122) setdest 1651 847 15.0" 
$ns at 792.8836688465922 "$node_(122) setdest 1275 703 9.0" 
$ns at 886.1424809978537 "$node_(122) setdest 865 710 2.0" 
$ns at 590.5357740576144 "$node_(123) setdest 1984 999 15.0" 
$ns at 680.347330608981 "$node_(123) setdest 1281 890 14.0" 
$ns at 736.524658743972 "$node_(123) setdest 2806 283 17.0" 
$ns at 809.0459095326368 "$node_(123) setdest 1134 675 7.0" 
$ns at 877.8826966519414 "$node_(123) setdest 1823 625 13.0" 
$ns at 630.344144890212 "$node_(124) setdest 28 524 7.0" 
$ns at 669.8602899785444 "$node_(124) setdest 2747 715 5.0" 
$ns at 720.7795948574136 "$node_(124) setdest 2007 1 12.0" 
$ns at 774.4248046688417 "$node_(124) setdest 2434 437 11.0" 
$ns at 892.6186993129386 "$node_(124) setdest 2004 195 17.0" 
$ns at 734.1576281835673 "$node_(125) setdest 201 19 18.0" 
$ns at 816.0585465956227 "$node_(125) setdest 1235 685 3.0" 
$ns at 867.2228272375248 "$node_(125) setdest 247 548 8.0" 
$ns at 737.5857298233225 "$node_(126) setdest 686 651 2.0" 
$ns at 783.6243033913765 "$node_(126) setdest 1924 782 13.0" 
$ns at 676.1999014527032 "$node_(127) setdest 2046 405 2.0" 
$ns at 717.5238493469831 "$node_(127) setdest 1827 488 8.0" 
$ns at 801.7153085662229 "$node_(127) setdest 1967 143 15.0" 
$ns at 677.3770024548027 "$node_(128) setdest 513 661 11.0" 
$ns at 746.003037912505 "$node_(128) setdest 2189 603 11.0" 
$ns at 825.7825056085871 "$node_(128) setdest 2080 63 12.0" 
$ns at 705.5203687604139 "$node_(129) setdest 1286 746 17.0" 
$ns at 786.0774642046604 "$node_(129) setdest 2329 435 2.0" 
$ns at 832.7818533594268 "$node_(129) setdest 752 399 2.0" 
$ns at 876.9606528827782 "$node_(129) setdest 968 914 4.0" 
$ns at 675.2832192312093 "$node_(130) setdest 334 264 1.0" 
$ns at 712.4184940459975 "$node_(130) setdest 1420 169 18.0" 
$ns at 814.9072678406659 "$node_(130) setdest 1995 63 3.0" 
$ns at 872.069007947405 "$node_(130) setdest 541 720 10.0" 
$ns at 673.2526180375359 "$node_(131) setdest 2531 253 1.0" 
$ns at 710.6837535692058 "$node_(131) setdest 1698 650 6.0" 
$ns at 777.8556223636157 "$node_(131) setdest 528 333 17.0" 
$ns at 870.6159672916058 "$node_(131) setdest 1507 10 9.0" 
$ns at 710.1282695699807 "$node_(132) setdest 1 845 1.0" 
$ns at 743.9463484330281 "$node_(132) setdest 519 9 14.0" 
$ns at 882.3445847164969 "$node_(132) setdest 2146 876 10.0" 
$ns at 737.9055345800148 "$node_(133) setdest 2558 930 1.0" 
$ns at 777.5647352814399 "$node_(133) setdest 1979 959 13.0" 
$ns at 808.7739528973145 "$node_(133) setdest 2787 179 1.0" 
$ns at 840.1215352349126 "$node_(133) setdest 1118 122 13.0" 
$ns at 669.8208536895863 "$node_(134) setdest 1225 751 19.0" 
$ns at 875.6258840549094 "$node_(134) setdest 1762 459 17.0" 
$ns at 714.3933089557078 "$node_(135) setdest 2390 892 14.0" 
$ns at 872.5549311668161 "$node_(135) setdest 1982 485 9.0" 
$ns at 706.1042086186881 "$node_(136) setdest 327 386 3.0" 
$ns at 760.8246551959236 "$node_(136) setdest 688 800 5.0" 
$ns at 792.137579414049 "$node_(136) setdest 163 395 17.0" 
$ns at 862.4199169109556 "$node_(136) setdest 437 764 3.0" 
$ns at 718.4282181530307 "$node_(137) setdest 2613 62 9.0" 
$ns at 801.7999767404965 "$node_(137) setdest 2187 695 13.0" 
$ns at 885.4389912394755 "$node_(137) setdest 1419 762 16.0" 
$ns at 660.8009816509428 "$node_(138) setdest 2286 938 17.0" 
$ns at 757.1860707379393 "$node_(138) setdest 2072 497 13.0" 
$ns at 816.8430145435218 "$node_(138) setdest 2310 748 18.0" 
$ns at 848.4809361934687 "$node_(138) setdest 1748 861 8.0" 
$ns at 891.7234498697744 "$node_(138) setdest 392 430 19.0" 
$ns at 695.7070593542823 "$node_(139) setdest 894 503 17.0" 
$ns at 857.4111543847538 "$node_(139) setdest 2077 792 18.0" 
$ns at 895.1548420360803 "$node_(139) setdest 2058 879 10.0" 
$ns at 763.6734183209007 "$node_(140) setdest 829 856 3.0" 
$ns at 800.9970493442707 "$node_(140) setdest 695 648 10.0" 
$ns at 718.5801511574781 "$node_(141) setdest 2155 61 13.0" 
$ns at 828.2758100067117 "$node_(141) setdest 82 31 1.0" 
$ns at 862.3980473448994 "$node_(141) setdest 655 278 5.0" 
$ns at 691.2809692050869 "$node_(142) setdest 2346 673 9.0" 
$ns at 739.9606316501882 "$node_(142) setdest 1737 292 16.0" 
$ns at 832.9848410692779 "$node_(142) setdest 332 164 10.0" 
$ns at 766.2240280369751 "$node_(143) setdest 2557 603 11.0" 
$ns at 823.8856586177395 "$node_(143) setdest 2191 237 8.0" 
$ns at 702.1240326478809 "$node_(144) setdest 159 184 19.0" 
$ns at 745.0903890705192 "$node_(144) setdest 2801 33 12.0" 
$ns at 851.6480839913576 "$node_(144) setdest 31 995 18.0" 
$ns at 713.3247610435544 "$node_(145) setdest 2839 82 7.0" 
$ns at 756.3284753265968 "$node_(145) setdest 388 274 4.0" 
$ns at 791.2462591399043 "$node_(145) setdest 621 846 5.0" 
$ns at 859.3831070404334 "$node_(145) setdest 1089 85 11.0" 
$ns at 772.3601429141698 "$node_(146) setdest 521 241 7.0" 
$ns at 815.1230000822449 "$node_(146) setdest 1191 338 14.0" 
$ns at 796.61281054837 "$node_(147) setdest 698 450 5.0" 
$ns at 839.2819424689673 "$node_(147) setdest 2851 367 13.0" 
$ns at 709.0167423125984 "$node_(148) setdest 1232 265 2.0" 
$ns at 758.4604333408354 "$node_(148) setdest 283 912 10.0" 
$ns at 881.3543021960655 "$node_(148) setdest 443 824 18.0" 
$ns at 723.0979322544957 "$node_(149) setdest 616 233 11.0" 
$ns at 762.7640572272394 "$node_(149) setdest 2263 565 5.0" 
$ns at 796.9221354749611 "$node_(149) setdest 391 157 18.0" 
$ns at 880.2330675589582 "$node_(149) setdest 742 425 7.0" 


#Set a TCP connection between node_(30) and node_(2)
set tcp_(0) [new Agent/TCP/Newreno]
$tcp_(0) set class_ 2
set sink_(0) [new Agent/TCPSink]
$ns attach-agent $node_(30) $tcp_(0)
$ns attach-agent $node_(2) $sink_(0)
$ns connect $tcp_(0) $sink_(0)
set ftp_(0) [new Application/FTP]
$ftp_(0) attach-agent $tcp_(0)
$ns at 0.2 "$ftp_(0) start"
$ns at 180.0 "$ftp_(0) stop"

#Set a TCP connection between node_(27) and node_(17)
set tcp_(1) [new Agent/TCP/Newreno]
$tcp_(1) set class_ 2
set sink_(1) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(1)
$ns attach-agent $node_(17) $sink_(1)
$ns connect $tcp_(1) $sink_(1)
set ftp_(1) [new Application/FTP]
$ftp_(1) attach-agent $tcp_(1)
$ns at 180.2 "$ftp_(1) start"
$ns at 360.0 "$ftp_(1) stop"

#Set a TCP connection between node_(44) and node_(27)
set tcp_(2) [new Agent/TCP/Newreno]
$tcp_(2) set class_ 2
set sink_(2) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(2)
$ns attach-agent $node_(27) $sink_(2)
$ns connect $tcp_(2) $sink_(2)
set ftp_(2) [new Application/FTP]
$ftp_(2) attach-agent $tcp_(2)
$ns at 360.2 "$ftp_(2) start"
$ns at 540.0 "$ftp_(2) stop"

#Set a TCP connection between node_(8) and node_(22)
set tcp_(3) [new Agent/TCP/Newreno]
$tcp_(3) set class_ 2
set sink_(3) [new Agent/TCPSink]
$ns attach-agent $node_(8) $tcp_(3)
$ns attach-agent $node_(22) $sink_(3)
$ns connect $tcp_(3) $sink_(3)
set ftp_(3) [new Application/FTP]
$ftp_(3) attach-agent $tcp_(3)
$ns at 540.2 "$ftp_(3) start"
$ns at 720.0 "$ftp_(3) stop"

#Set a TCP connection between node_(13) and node_(4)
set tcp_(4) [new Agent/TCP/Newreno]
$tcp_(4) set class_ 2
set sink_(4) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(4)
$ns attach-agent $node_(4) $sink_(4)
$ns connect $tcp_(4) $sink_(4)
set ftp_(4) [new Application/FTP]
$ftp_(4) attach-agent $tcp_(4)
$ns at 720.2 "$ftp_(4) start"
$ns at 900.0 "$ftp_(4) stop"

#Set a TCP connection between node_(8) and node_(30)
set tcp_(5) [new Agent/TCP/Newreno]
$tcp_(5) set class_ 2
set sink_(5) [new Agent/TCPSink]
$ns attach-agent $node_(8) $tcp_(5)
$ns attach-agent $node_(30) $sink_(5)
$ns connect $tcp_(5) $sink_(5)
set ftp_(5) [new Application/FTP]
$ftp_(5) attach-agent $tcp_(5)
$ns at 0.2 "$ftp_(5) start"
$ns at 180.0 "$ftp_(5) stop"

#Set a TCP connection between node_(29) and node_(26)
set tcp_(6) [new Agent/TCP/Newreno]
$tcp_(6) set class_ 2
set sink_(6) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(6)
$ns attach-agent $node_(26) $sink_(6)
$ns connect $tcp_(6) $sink_(6)
set ftp_(6) [new Application/FTP]
$ftp_(6) attach-agent $tcp_(6)
$ns at 180.2 "$ftp_(6) start"
$ns at 360.0 "$ftp_(6) stop"

#Set a TCP connection between node_(35) and node_(20)
set tcp_(7) [new Agent/TCP/Newreno]
$tcp_(7) set class_ 2
set sink_(7) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(7)
$ns attach-agent $node_(20) $sink_(7)
$ns connect $tcp_(7) $sink_(7)
set ftp_(7) [new Application/FTP]
$ftp_(7) attach-agent $tcp_(7)
$ns at 360.2 "$ftp_(7) start"
$ns at 540.0 "$ftp_(7) stop"

#Set a TCP connection between node_(4) and node_(31)
set tcp_(8) [new Agent/TCP/Newreno]
$tcp_(8) set class_ 2
set sink_(8) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(8)
$ns attach-agent $node_(31) $sink_(8)
$ns connect $tcp_(8) $sink_(8)
set ftp_(8) [new Application/FTP]
$ftp_(8) attach-agent $tcp_(8)
$ns at 540.2 "$ftp_(8) start"
$ns at 720.0 "$ftp_(8) stop"

#Set a TCP connection between node_(7) and node_(13)
set tcp_(9) [new Agent/TCP/Newreno]
$tcp_(9) set class_ 2
set sink_(9) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(9)
$ns attach-agent $node_(13) $sink_(9)
$ns connect $tcp_(9) $sink_(9)
set ftp_(9) [new Application/FTP]
$ftp_(9) attach-agent $tcp_(9)
$ns at 720.2 "$ftp_(9) start"
$ns at 900.0 "$ftp_(9) stop"

#Set a TCP connection between node_(8) and node_(6)
set tcp_(10) [new Agent/TCP/Newreno]
$tcp_(10) set class_ 2
set sink_(10) [new Agent/TCPSink]
$ns attach-agent $node_(8) $tcp_(10)
$ns attach-agent $node_(6) $sink_(10)
$ns connect $tcp_(10) $sink_(10)
set ftp_(10) [new Application/FTP]
$ftp_(10) attach-agent $tcp_(10)
$ns at 0.2 "$ftp_(10) start"
$ns at 180.0 "$ftp_(10) stop"

#Set a TCP connection between node_(14) and node_(18)
set tcp_(11) [new Agent/TCP/Newreno]
$tcp_(11) set class_ 2
set sink_(11) [new Agent/TCPSink]
$ns attach-agent $node_(14) $tcp_(11)
$ns attach-agent $node_(18) $sink_(11)
$ns connect $tcp_(11) $sink_(11)
set ftp_(11) [new Application/FTP]
$ftp_(11) attach-agent $tcp_(11)
$ns at 180.2 "$ftp_(11) start"
$ns at 360.0 "$ftp_(11) stop"

#Set a TCP connection between node_(15) and node_(12)
set tcp_(12) [new Agent/TCP/Newreno]
$tcp_(12) set class_ 2
set sink_(12) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(12)
$ns attach-agent $node_(12) $sink_(12)
$ns connect $tcp_(12) $sink_(12)
set ftp_(12) [new Application/FTP]
$ftp_(12) attach-agent $tcp_(12)
$ns at 360.2 "$ftp_(12) start"
$ns at 540.0 "$ftp_(12) stop"

#Set a TCP connection between node_(21) and node_(19)
set tcp_(13) [new Agent/TCP/Newreno]
$tcp_(13) set class_ 2
set sink_(13) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(13)
$ns attach-agent $node_(19) $sink_(13)
$ns connect $tcp_(13) $sink_(13)
set ftp_(13) [new Application/FTP]
$ftp_(13) attach-agent $tcp_(13)
$ns at 540.2 "$ftp_(13) start"
$ns at 720.0 "$ftp_(13) stop"

#Set a TCP connection between node_(32) and node_(18)
set tcp_(14) [new Agent/TCP/Newreno]
$tcp_(14) set class_ 2
set sink_(14) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(14)
$ns attach-agent $node_(18) $sink_(14)
$ns connect $tcp_(14) $sink_(14)
set ftp_(14) [new Application/FTP]
$ftp_(14) attach-agent $tcp_(14)
$ns at 720.2 "$ftp_(14) start"
$ns at 900.0 "$ftp_(14) stop"

#Set a TCP connection between node_(17) and node_(2)
set tcp_(15) [new Agent/TCP/Newreno]
$tcp_(15) set class_ 2
set sink_(15) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(15)
$ns attach-agent $node_(2) $sink_(15)
$ns connect $tcp_(15) $sink_(15)
set ftp_(15) [new Application/FTP]
$ftp_(15) attach-agent $tcp_(15)
$ns at 0.2 "$ftp_(15) start"
$ns at 180.0 "$ftp_(15) stop"

#Set a TCP connection between node_(16) and node_(27)
set tcp_(16) [new Agent/TCP/Newreno]
$tcp_(16) set class_ 2
set sink_(16) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(16)
$ns attach-agent $node_(27) $sink_(16)
$ns connect $tcp_(16) $sink_(16)
set ftp_(16) [new Application/FTP]
$ftp_(16) attach-agent $tcp_(16)
$ns at 180.2 "$ftp_(16) start"
$ns at 360.0 "$ftp_(16) stop"

#Set a TCP connection between node_(2) and node_(3)
set tcp_(17) [new Agent/TCP/Newreno]
$tcp_(17) set class_ 2
set sink_(17) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(17)
$ns attach-agent $node_(3) $sink_(17)
$ns connect $tcp_(17) $sink_(17)
set ftp_(17) [new Application/FTP]
$ftp_(17) attach-agent $tcp_(17)
$ns at 360.2 "$ftp_(17) start"
$ns at 540.0 "$ftp_(17) stop"

#Set a TCP connection between node_(41) and node_(15)
set tcp_(18) [new Agent/TCP/Newreno]
$tcp_(18) set class_ 2
set sink_(18) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(18)
$ns attach-agent $node_(15) $sink_(18)
$ns connect $tcp_(18) $sink_(18)
set ftp_(18) [new Application/FTP]
$ftp_(18) attach-agent $tcp_(18)
$ns at 540.2 "$ftp_(18) start"
$ns at 720.0 "$ftp_(18) stop"

#Set a TCP connection between node_(16) and node_(17)
set tcp_(19) [new Agent/TCP/Newreno]
$tcp_(19) set class_ 2
set sink_(19) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(19)
$ns attach-agent $node_(17) $sink_(19)
$ns connect $tcp_(19) $sink_(19)
set ftp_(19) [new Application/FTP]
$ftp_(19) attach-agent $tcp_(19)
$ns at 720.2 "$ftp_(19) start"
$ns at 900.0 "$ftp_(19) stop"

#Set a TCP connection between node_(32) and node_(47)
set tcp_(20) [new Agent/TCP/Newreno]
$tcp_(20) set class_ 2
set sink_(20) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(20)
$ns attach-agent $node_(47) $sink_(20)
$ns connect $tcp_(20) $sink_(20)
set ftp_(20) [new Application/FTP]
$ftp_(20) attach-agent $tcp_(20)
$ns at 0.2 "$ftp_(20) start"
$ns at 180.0 "$ftp_(20) stop"

#Set a TCP connection between node_(17) and node_(25)
set tcp_(21) [new Agent/TCP/Newreno]
$tcp_(21) set class_ 2
set sink_(21) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(21)
$ns attach-agent $node_(25) $sink_(21)
$ns connect $tcp_(21) $sink_(21)
set ftp_(21) [new Application/FTP]
$ftp_(21) attach-agent $tcp_(21)
$ns at 180.2 "$ftp_(21) start"
$ns at 360.0 "$ftp_(21) stop"

#Set a TCP connection between node_(3) and node_(7)
set tcp_(22) [new Agent/TCP/Newreno]
$tcp_(22) set class_ 2
set sink_(22) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(22)
$ns attach-agent $node_(7) $sink_(22)
$ns connect $tcp_(22) $sink_(22)
set ftp_(22) [new Application/FTP]
$ftp_(22) attach-agent $tcp_(22)
$ns at 360.2 "$ftp_(22) start"
$ns at 540.0 "$ftp_(22) stop"

#Set a TCP connection between node_(41) and node_(27)
set tcp_(23) [new Agent/TCP/Newreno]
$tcp_(23) set class_ 2
set sink_(23) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(23)
$ns attach-agent $node_(27) $sink_(23)
$ns connect $tcp_(23) $sink_(23)
set ftp_(23) [new Application/FTP]
$ftp_(23) attach-agent $tcp_(23)
$ns at 540.2 "$ftp_(23) start"
$ns at 720.0 "$ftp_(23) stop"

#Set a TCP connection between node_(37) and node_(12)
set tcp_(24) [new Agent/TCP/Newreno]
$tcp_(24) set class_ 2
set sink_(24) [new Agent/TCPSink]
$ns attach-agent $node_(37) $tcp_(24)
$ns attach-agent $node_(12) $sink_(24)
$ns connect $tcp_(24) $sink_(24)
set ftp_(24) [new Application/FTP]
$ftp_(24) attach-agent $tcp_(24)
$ns at 720.2 "$ftp_(24) start"
$ns at 900.0 "$ftp_(24) stop"

#Set a TCP connection between node_(28) and node_(14)
set tcp_(25) [new Agent/TCP/Newreno]
$tcp_(25) set class_ 2
set sink_(25) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(25)
$ns attach-agent $node_(14) $sink_(25)
$ns connect $tcp_(25) $sink_(25)
set ftp_(25) [new Application/FTP]
$ftp_(25) attach-agent $tcp_(25)
$ns at 0.2 "$ftp_(25) start"
$ns at 180.0 "$ftp_(25) stop"

#Set a TCP connection between node_(20) and node_(21)
set tcp_(26) [new Agent/TCP/Newreno]
$tcp_(26) set class_ 2
set sink_(26) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(26)
$ns attach-agent $node_(21) $sink_(26)
$ns connect $tcp_(26) $sink_(26)
set ftp_(26) [new Application/FTP]
$ftp_(26) attach-agent $tcp_(26)
$ns at 180.2 "$ftp_(26) start"
$ns at 360.0 "$ftp_(26) stop"

#Set a TCP connection between node_(40) and node_(20)
set tcp_(27) [new Agent/TCP/Newreno]
$tcp_(27) set class_ 2
set sink_(27) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(27)
$ns attach-agent $node_(20) $sink_(27)
$ns connect $tcp_(27) $sink_(27)
set ftp_(27) [new Application/FTP]
$ftp_(27) attach-agent $tcp_(27)
$ns at 360.2 "$ftp_(27) start"
$ns at 540.0 "$ftp_(27) stop"

#Set a TCP connection between node_(27) and node_(23)
set tcp_(28) [new Agent/TCP/Newreno]
$tcp_(28) set class_ 2
set sink_(28) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(28)
$ns attach-agent $node_(23) $sink_(28)
$ns connect $tcp_(28) $sink_(28)
set ftp_(28) [new Application/FTP]
$ftp_(28) attach-agent $tcp_(28)
$ns at 540.2 "$ftp_(28) start"
$ns at 720.0 "$ftp_(28) stop"

#Set a TCP connection between node_(20) and node_(10)
set tcp_(29) [new Agent/TCP/Newreno]
$tcp_(29) set class_ 2
set sink_(29) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(29)
$ns attach-agent $node_(10) $sink_(29)
$ns connect $tcp_(29) $sink_(29)
set ftp_(29) [new Application/FTP]
$ftp_(29) attach-agent $tcp_(29)
$ns at 720.2 "$ftp_(29) start"
$ns at 900.0 "$ftp_(29) stop"

#Set a TCP connection between node_(20) and node_(24)
set tcp_(30) [new Agent/TCP/Newreno]
$tcp_(30) set class_ 2
set sink_(30) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(30)
$ns attach-agent $node_(24) $sink_(30)
$ns connect $tcp_(30) $sink_(30)
set ftp_(30) [new Application/FTP]
$ftp_(30) attach-agent $tcp_(30)
$ns at 0.2 "$ftp_(30) start"
$ns at 180.0 "$ftp_(30) stop"

#Set a TCP connection between node_(24) and node_(16)
set tcp_(31) [new Agent/TCP/Newreno]
$tcp_(31) set class_ 2
set sink_(31) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(31)
$ns attach-agent $node_(16) $sink_(31)
$ns connect $tcp_(31) $sink_(31)
set ftp_(31) [new Application/FTP]
$ftp_(31) attach-agent $tcp_(31)
$ns at 180.2 "$ftp_(31) start"
$ns at 360.0 "$ftp_(31) stop"

#Set a TCP connection between node_(29) and node_(18)
set tcp_(32) [new Agent/TCP/Newreno]
$tcp_(32) set class_ 2
set sink_(32) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(32)
$ns attach-agent $node_(18) $sink_(32)
$ns connect $tcp_(32) $sink_(32)
set ftp_(32) [new Application/FTP]
$ftp_(32) attach-agent $tcp_(32)
$ns at 360.2 "$ftp_(32) start"
$ns at 540.0 "$ftp_(32) stop"

#Set a TCP connection between node_(36) and node_(41)
set tcp_(33) [new Agent/TCP/Newreno]
$tcp_(33) set class_ 2
set sink_(33) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(33)
$ns attach-agent $node_(41) $sink_(33)
$ns connect $tcp_(33) $sink_(33)
set ftp_(33) [new Application/FTP]
$ftp_(33) attach-agent $tcp_(33)
$ns at 540.2 "$ftp_(33) start"
$ns at 720.0 "$ftp_(33) stop"

#Set a TCP connection between node_(11) and node_(41)
set tcp_(34) [new Agent/TCP/Newreno]
$tcp_(34) set class_ 2
set sink_(34) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(34)
$ns attach-agent $node_(41) $sink_(34)
$ns connect $tcp_(34) $sink_(34)
set ftp_(34) [new Application/FTP]
$ftp_(34) attach-agent $tcp_(34)
$ns at 720.2 "$ftp_(34) start"
$ns at 900.0 "$ftp_(34) stop"

#Set a TCP connection between node_(37) and node_(42)
set tcp_(35) [new Agent/TCP/Newreno]
$tcp_(35) set class_ 2
set sink_(35) [new Agent/TCPSink]
$ns attach-agent $node_(37) $tcp_(35)
$ns attach-agent $node_(42) $sink_(35)
$ns connect $tcp_(35) $sink_(35)
set ftp_(35) [new Application/FTP]
$ftp_(35) attach-agent $tcp_(35)
$ns at 0.2 "$ftp_(35) start"
$ns at 180.0 "$ftp_(35) stop"

#Set a TCP connection between node_(13) and node_(33)
set tcp_(36) [new Agent/TCP/Newreno]
$tcp_(36) set class_ 2
set sink_(36) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(36)
$ns attach-agent $node_(33) $sink_(36)
$ns connect $tcp_(36) $sink_(36)
set ftp_(36) [new Application/FTP]
$ftp_(36) attach-agent $tcp_(36)
$ns at 180.2 "$ftp_(36) start"
$ns at 360.0 "$ftp_(36) stop"

#Set a TCP connection between node_(33) and node_(26)
set tcp_(37) [new Agent/TCP/Newreno]
$tcp_(37) set class_ 2
set sink_(37) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(37)
$ns attach-agent $node_(26) $sink_(37)
$ns connect $tcp_(37) $sink_(37)
set ftp_(37) [new Application/FTP]
$ftp_(37) attach-agent $tcp_(37)
$ns at 360.2 "$ftp_(37) start"
$ns at 540.0 "$ftp_(37) stop"

#Set a TCP connection between node_(48) and node_(8)
set tcp_(38) [new Agent/TCP/Newreno]
$tcp_(38) set class_ 2
set sink_(38) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(38)
$ns attach-agent $node_(8) $sink_(38)
$ns connect $tcp_(38) $sink_(38)
set ftp_(38) [new Application/FTP]
$ftp_(38) attach-agent $tcp_(38)
$ns at 540.2 "$ftp_(38) start"
$ns at 720.0 "$ftp_(38) stop"

#Set a TCP connection between node_(1) and node_(24)
set tcp_(39) [new Agent/TCP/Newreno]
$tcp_(39) set class_ 2
set sink_(39) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(39)
$ns attach-agent $node_(24) $sink_(39)
$ns connect $tcp_(39) $sink_(39)
set ftp_(39) [new Application/FTP]
$ftp_(39) attach-agent $tcp_(39)
$ns at 720.2 "$ftp_(39) start"
$ns at 900.0 "$ftp_(39) stop"

#Set a TCP connection between node_(27) and node_(6)
set tcp_(40) [new Agent/TCP/Newreno]
$tcp_(40) set class_ 2
set sink_(40) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(40)
$ns attach-agent $node_(6) $sink_(40)
$ns connect $tcp_(40) $sink_(40)
set ftp_(40) [new Application/FTP]
$ftp_(40) attach-agent $tcp_(40)
$ns at 0.2 "$ftp_(40) start"
$ns at 180.0 "$ftp_(40) stop"

#Set a TCP connection between node_(12) and node_(28)
set tcp_(41) [new Agent/TCP/Newreno]
$tcp_(41) set class_ 2
set sink_(41) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(41)
$ns attach-agent $node_(28) $sink_(41)
$ns connect $tcp_(41) $sink_(41)
set ftp_(41) [new Application/FTP]
$ftp_(41) attach-agent $tcp_(41)
$ns at 180.2 "$ftp_(41) start"
$ns at 360.0 "$ftp_(41) stop"

#Set a TCP connection between node_(23) and node_(45)
set tcp_(42) [new Agent/TCP/Newreno]
$tcp_(42) set class_ 2
set sink_(42) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(42)
$ns attach-agent $node_(45) $sink_(42)
$ns connect $tcp_(42) $sink_(42)
set ftp_(42) [new Application/FTP]
$ftp_(42) attach-agent $tcp_(42)
$ns at 360.2 "$ftp_(42) start"
$ns at 540.0 "$ftp_(42) stop"

#Set a TCP connection between node_(16) and node_(35)
set tcp_(43) [new Agent/TCP/Newreno]
$tcp_(43) set class_ 2
set sink_(43) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(43)
$ns attach-agent $node_(35) $sink_(43)
$ns connect $tcp_(43) $sink_(43)
set ftp_(43) [new Application/FTP]
$ftp_(43) attach-agent $tcp_(43)
$ns at 540.2 "$ftp_(43) start"
$ns at 720.0 "$ftp_(43) stop"

#Set a TCP connection between node_(26) and node_(42)
set tcp_(44) [new Agent/TCP/Newreno]
$tcp_(44) set class_ 2
set sink_(44) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(44)
$ns attach-agent $node_(42) $sink_(44)
$ns connect $tcp_(44) $sink_(44)
set ftp_(44) [new Application/FTP]
$ftp_(44) attach-agent $tcp_(44)
$ns at 720.2 "$ftp_(44) start"
$ns at 900.0 "$ftp_(44) stop"

#Set a TCP connection between node_(28) and node_(17)
set tcp_(45) [new Agent/TCP/Newreno]
$tcp_(45) set class_ 2
set sink_(45) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(45)
$ns attach-agent $node_(17) $sink_(45)
$ns connect $tcp_(45) $sink_(45)
set ftp_(45) [new Application/FTP]
$ftp_(45) attach-agent $tcp_(45)
$ns at 0.2 "$ftp_(45) start"
$ns at 180.0 "$ftp_(45) stop"

#Set a TCP connection between node_(47) and node_(24)
set tcp_(46) [new Agent/TCP/Newreno]
$tcp_(46) set class_ 2
set sink_(46) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(46)
$ns attach-agent $node_(24) $sink_(46)
$ns connect $tcp_(46) $sink_(46)
set ftp_(46) [new Application/FTP]
$ftp_(46) attach-agent $tcp_(46)
$ns at 180.2 "$ftp_(46) start"
$ns at 360.0 "$ftp_(46) stop"

#Set a TCP connection between node_(35) and node_(38)
set tcp_(47) [new Agent/TCP/Newreno]
$tcp_(47) set class_ 2
set sink_(47) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(47)
$ns attach-agent $node_(38) $sink_(47)
$ns connect $tcp_(47) $sink_(47)
set ftp_(47) [new Application/FTP]
$ftp_(47) attach-agent $tcp_(47)
$ns at 360.2 "$ftp_(47) start"
$ns at 540.0 "$ftp_(47) stop"

#Set a TCP connection between node_(17) and node_(3)
set tcp_(48) [new Agent/TCP/Newreno]
$tcp_(48) set class_ 2
set sink_(48) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(48)
$ns attach-agent $node_(3) $sink_(48)
$ns connect $tcp_(48) $sink_(48)
set ftp_(48) [new Application/FTP]
$ftp_(48) attach-agent $tcp_(48)
$ns at 540.2 "$ftp_(48) start"
$ns at 720.0 "$ftp_(48) stop"

#Set a TCP connection between node_(8) and node_(27)
set tcp_(49) [new Agent/TCP/Newreno]
$tcp_(49) set class_ 2
set sink_(49) [new Agent/TCPSink]
$ns attach-agent $node_(8) $tcp_(49)
$ns attach-agent $node_(27) $sink_(49)
$ns connect $tcp_(49) $sink_(49)
set ftp_(49) [new Application/FTP]
$ftp_(49) attach-agent $tcp_(49)
$ns at 720.2 "$ftp_(49) start"
$ns at 900.0 "$ftp_(49) stop"

#Set a TCP connection between node_(32) and node_(45)
set tcp_(50) [new Agent/TCP/Newreno]
$tcp_(50) set class_ 2
set sink_(50) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(50)
$ns attach-agent $node_(45) $sink_(50)
$ns connect $tcp_(50) $sink_(50)
set ftp_(50) [new Application/FTP]
$ftp_(50) attach-agent $tcp_(50)
$ns at 0.2 "$ftp_(50) start"
$ns at 180.0 "$ftp_(50) stop"

#Set a TCP connection between node_(7) and node_(2)
set tcp_(51) [new Agent/TCP/Newreno]
$tcp_(51) set class_ 2
set sink_(51) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(51)
$ns attach-agent $node_(2) $sink_(51)
$ns connect $tcp_(51) $sink_(51)
set ftp_(51) [new Application/FTP]
$ftp_(51) attach-agent $tcp_(51)
$ns at 180.2 "$ftp_(51) start"
$ns at 360.0 "$ftp_(51) stop"

#Set a TCP connection between node_(10) and node_(42)
set tcp_(52) [new Agent/TCP/Newreno]
$tcp_(52) set class_ 2
set sink_(52) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(52)
$ns attach-agent $node_(42) $sink_(52)
$ns connect $tcp_(52) $sink_(52)
set ftp_(52) [new Application/FTP]
$ftp_(52) attach-agent $tcp_(52)
$ns at 360.2 "$ftp_(52) start"
$ns at 540.0 "$ftp_(52) stop"

#Set a TCP connection between node_(12) and node_(39)
set tcp_(53) [new Agent/TCP/Newreno]
$tcp_(53) set class_ 2
set sink_(53) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(53)
$ns attach-agent $node_(39) $sink_(53)
$ns connect $tcp_(53) $sink_(53)
set ftp_(53) [new Application/FTP]
$ftp_(53) attach-agent $tcp_(53)
$ns at 540.2 "$ftp_(53) start"
$ns at 720.0 "$ftp_(53) stop"

#Set a TCP connection between node_(26) and node_(33)
set tcp_(54) [new Agent/TCP/Newreno]
$tcp_(54) set class_ 2
set sink_(54) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(54)
$ns attach-agent $node_(33) $sink_(54)
$ns connect $tcp_(54) $sink_(54)
set ftp_(54) [new Application/FTP]
$ftp_(54) attach-agent $tcp_(54)
$ns at 720.2 "$ftp_(54) start"
$ns at 900.0 "$ftp_(54) stop"

#Set a TCP connection between node_(17) and node_(22)
set tcp_(55) [new Agent/TCP/Newreno]
$tcp_(55) set class_ 2
set sink_(55) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(55)
$ns attach-agent $node_(22) $sink_(55)
$ns connect $tcp_(55) $sink_(55)
set ftp_(55) [new Application/FTP]
$ftp_(55) attach-agent $tcp_(55)
$ns at 0.2 "$ftp_(55) start"
$ns at 180.0 "$ftp_(55) stop"

#Set a TCP connection between node_(2) and node_(11)
set tcp_(56) [new Agent/TCP/Newreno]
$tcp_(56) set class_ 2
set sink_(56) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(56)
$ns attach-agent $node_(11) $sink_(56)
$ns connect $tcp_(56) $sink_(56)
set ftp_(56) [new Application/FTP]
$ftp_(56) attach-agent $tcp_(56)
$ns at 180.2 "$ftp_(56) start"
$ns at 360.0 "$ftp_(56) stop"

#Set a TCP connection between node_(9) and node_(18)
set tcp_(57) [new Agent/TCP/Newreno]
$tcp_(57) set class_ 2
set sink_(57) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(57)
$ns attach-agent $node_(18) $sink_(57)
$ns connect $tcp_(57) $sink_(57)
set ftp_(57) [new Application/FTP]
$ftp_(57) attach-agent $tcp_(57)
$ns at 360.2 "$ftp_(57) start"
$ns at 540.0 "$ftp_(57) stop"

#Set a TCP connection between node_(3) and node_(1)
set tcp_(58) [new Agent/TCP/Newreno]
$tcp_(58) set class_ 2
set sink_(58) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(58)
$ns attach-agent $node_(1) $sink_(58)
$ns connect $tcp_(58) $sink_(58)
set ftp_(58) [new Application/FTP]
$ftp_(58) attach-agent $tcp_(58)
$ns at 540.2 "$ftp_(58) start"
$ns at 720.0 "$ftp_(58) stop"

#Set a TCP connection between node_(24) and node_(21)
set tcp_(59) [new Agent/TCP/Newreno]
$tcp_(59) set class_ 2
set sink_(59) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(59)
$ns attach-agent $node_(21) $sink_(59)
$ns connect $tcp_(59) $sink_(59)
set ftp_(59) [new Application/FTP]
$ftp_(59) attach-agent $tcp_(59)
$ns at 720.2 "$ftp_(59) start"
$ns at 900.0 "$ftp_(59) stop"

#Set a TCP connection between node_(36) and node_(49)
set tcp_(60) [new Agent/TCP/Newreno]
$tcp_(60) set class_ 2
set sink_(60) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(60)
$ns attach-agent $node_(49) $sink_(60)
$ns connect $tcp_(60) $sink_(60)
set ftp_(60) [new Application/FTP]
$ftp_(60) attach-agent $tcp_(60)
$ns at 0.2 "$ftp_(60) start"
$ns at 180.0 "$ftp_(60) stop"

#Set a TCP connection between node_(48) and node_(4)
set tcp_(61) [new Agent/TCP/Newreno]
$tcp_(61) set class_ 2
set sink_(61) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(61)
$ns attach-agent $node_(4) $sink_(61)
$ns connect $tcp_(61) $sink_(61)
set ftp_(61) [new Application/FTP]
$ftp_(61) attach-agent $tcp_(61)
$ns at 180.2 "$ftp_(61) start"
$ns at 360.0 "$ftp_(61) stop"

#Set a TCP connection between node_(40) and node_(38)
set tcp_(62) [new Agent/TCP/Newreno]
$tcp_(62) set class_ 2
set sink_(62) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(62)
$ns attach-agent $node_(38) $sink_(62)
$ns connect $tcp_(62) $sink_(62)
set ftp_(62) [new Application/FTP]
$ftp_(62) attach-agent $tcp_(62)
$ns at 360.2 "$ftp_(62) start"
$ns at 540.0 "$ftp_(62) stop"

#Set a TCP connection between node_(41) and node_(22)
set tcp_(63) [new Agent/TCP/Newreno]
$tcp_(63) set class_ 2
set sink_(63) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(63)
$ns attach-agent $node_(22) $sink_(63)
$ns connect $tcp_(63) $sink_(63)
set ftp_(63) [new Application/FTP]
$ftp_(63) attach-agent $tcp_(63)
$ns at 540.2 "$ftp_(63) start"
$ns at 720.0 "$ftp_(63) stop"

#Set a TCP connection between node_(45) and node_(29)
set tcp_(64) [new Agent/TCP/Newreno]
$tcp_(64) set class_ 2
set sink_(64) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(64)
$ns attach-agent $node_(29) $sink_(64)
$ns connect $tcp_(64) $sink_(64)
set ftp_(64) [new Application/FTP]
$ftp_(64) attach-agent $tcp_(64)
$ns at 720.2 "$ftp_(64) start"
$ns at 900.0 "$ftp_(64) stop"

#Set a TCP connection between node_(20) and node_(2)
set tcp_(65) [new Agent/TCP/Newreno]
$tcp_(65) set class_ 2
set sink_(65) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(65)
$ns attach-agent $node_(2) $sink_(65)
$ns connect $tcp_(65) $sink_(65)
set ftp_(65) [new Application/FTP]
$ftp_(65) attach-agent $tcp_(65)
$ns at 0.2 "$ftp_(65) start"
$ns at 180.0 "$ftp_(65) stop"

#Set a TCP connection between node_(23) and node_(20)
set tcp_(66) [new Agent/TCP/Newreno]
$tcp_(66) set class_ 2
set sink_(66) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(66)
$ns attach-agent $node_(20) $sink_(66)
$ns connect $tcp_(66) $sink_(66)
set ftp_(66) [new Application/FTP]
$ftp_(66) attach-agent $tcp_(66)
$ns at 180.2 "$ftp_(66) start"
$ns at 360.0 "$ftp_(66) stop"

#Set a TCP connection between node_(1) and node_(10)
set tcp_(67) [new Agent/TCP/Newreno]
$tcp_(67) set class_ 2
set sink_(67) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(67)
$ns attach-agent $node_(10) $sink_(67)
$ns connect $tcp_(67) $sink_(67)
set ftp_(67) [new Application/FTP]
$ftp_(67) attach-agent $tcp_(67)
$ns at 360.2 "$ftp_(67) start"
$ns at 540.0 "$ftp_(67) stop"

#Set a TCP connection between node_(18) and node_(36)
set tcp_(68) [new Agent/TCP/Newreno]
$tcp_(68) set class_ 2
set sink_(68) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(68)
$ns attach-agent $node_(36) $sink_(68)
$ns connect $tcp_(68) $sink_(68)
set ftp_(68) [new Application/FTP]
$ftp_(68) attach-agent $tcp_(68)
$ns at 540.2 "$ftp_(68) start"
$ns at 720.0 "$ftp_(68) stop"

#Set a TCP connection between node_(5) and node_(25)
set tcp_(69) [new Agent/TCP/Newreno]
$tcp_(69) set class_ 2
set sink_(69) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(69)
$ns attach-agent $node_(25) $sink_(69)
$ns connect $tcp_(69) $sink_(69)
set ftp_(69) [new Application/FTP]
$ftp_(69) attach-agent $tcp_(69)
$ns at 720.2 "$ftp_(69) start"
$ns at 900.0 "$ftp_(69) stop"

#Set a TCP connection between node_(32) and node_(17)
set tcp_(70) [new Agent/TCP/Newreno]
$tcp_(70) set class_ 2
set sink_(70) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(70)
$ns attach-agent $node_(17) $sink_(70)
$ns connect $tcp_(70) $sink_(70)
set ftp_(70) [new Application/FTP]
$ftp_(70) attach-agent $tcp_(70)
$ns at 0.2 "$ftp_(70) start"
$ns at 180.0 "$ftp_(70) stop"

#Set a TCP connection between node_(10) and node_(17)
set tcp_(71) [new Agent/TCP/Newreno]
$tcp_(71) set class_ 2
set sink_(71) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(71)
$ns attach-agent $node_(17) $sink_(71)
$ns connect $tcp_(71) $sink_(71)
set ftp_(71) [new Application/FTP]
$ftp_(71) attach-agent $tcp_(71)
$ns at 180.2 "$ftp_(71) start"
$ns at 360.0 "$ftp_(71) stop"

#Set a TCP connection between node_(28) and node_(13)
set tcp_(72) [new Agent/TCP/Newreno]
$tcp_(72) set class_ 2
set sink_(72) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(72)
$ns attach-agent $node_(13) $sink_(72)
$ns connect $tcp_(72) $sink_(72)
set ftp_(72) [new Application/FTP]
$ftp_(72) attach-agent $tcp_(72)
$ns at 360.2 "$ftp_(72) start"
$ns at 540.0 "$ftp_(72) stop"

#Set a TCP connection between node_(29) and node_(25)
set tcp_(73) [new Agent/TCP/Newreno]
$tcp_(73) set class_ 2
set sink_(73) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(73)
$ns attach-agent $node_(25) $sink_(73)
$ns connect $tcp_(73) $sink_(73)
set ftp_(73) [new Application/FTP]
$ftp_(73) attach-agent $tcp_(73)
$ns at 540.2 "$ftp_(73) start"
$ns at 720.0 "$ftp_(73) stop"

#Set a TCP connection between node_(9) and node_(19)
set tcp_(74) [new Agent/TCP/Newreno]
$tcp_(74) set class_ 2
set sink_(74) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(74)
$ns attach-agent $node_(19) $sink_(74)
$ns connect $tcp_(74) $sink_(74)
set ftp_(74) [new Application/FTP]
$ftp_(74) attach-agent $tcp_(74)
$ns at 720.2 "$ftp_(74) start"
$ns at 900.0 "$ftp_(74) stop"

#Set a TCP connection between node_(26) and node_(6)
set tcp_(75) [new Agent/TCP/Newreno]
$tcp_(75) set class_ 2
set sink_(75) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(75)
$ns attach-agent $node_(6) $sink_(75)
$ns connect $tcp_(75) $sink_(75)
set ftp_(75) [new Application/FTP]
$ftp_(75) attach-agent $tcp_(75)
$ns at 0.2 "$ftp_(75) start"
$ns at 180.0 "$ftp_(75) stop"

#Set a TCP connection between node_(22) and node_(1)
set tcp_(76) [new Agent/TCP/Newreno]
$tcp_(76) set class_ 2
set sink_(76) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(76)
$ns attach-agent $node_(1) $sink_(76)
$ns connect $tcp_(76) $sink_(76)
set ftp_(76) [new Application/FTP]
$ftp_(76) attach-agent $tcp_(76)
$ns at 180.2 "$ftp_(76) start"
$ns at 360.0 "$ftp_(76) stop"

#Set a TCP connection between node_(17) and node_(21)
set tcp_(77) [new Agent/TCP/Newreno]
$tcp_(77) set class_ 2
set sink_(77) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(77)
$ns attach-agent $node_(21) $sink_(77)
$ns connect $tcp_(77) $sink_(77)
set ftp_(77) [new Application/FTP]
$ftp_(77) attach-agent $tcp_(77)
$ns at 360.2 "$ftp_(77) start"
$ns at 540.0 "$ftp_(77) stop"

#Set a TCP connection between node_(35) and node_(25)
set tcp_(78) [new Agent/TCP/Newreno]
$tcp_(78) set class_ 2
set sink_(78) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(78)
$ns attach-agent $node_(25) $sink_(78)
$ns connect $tcp_(78) $sink_(78)
set ftp_(78) [new Application/FTP]
$ftp_(78) attach-agent $tcp_(78)
$ns at 540.2 "$ftp_(78) start"
$ns at 720.0 "$ftp_(78) stop"

#Set a TCP connection between node_(36) and node_(21)
set tcp_(79) [new Agent/TCP/Newreno]
$tcp_(79) set class_ 2
set sink_(79) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(79)
$ns attach-agent $node_(21) $sink_(79)
$ns connect $tcp_(79) $sink_(79)
set ftp_(79) [new Application/FTP]
$ftp_(79) attach-agent $tcp_(79)
$ns at 720.2 "$ftp_(79) start"
$ns at 900.0 "$ftp_(79) stop"

#Set a TCP connection between node_(1) and node_(4)
set tcp_(80) [new Agent/TCP/Newreno]
$tcp_(80) set class_ 2
set sink_(80) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(80)
$ns attach-agent $node_(4) $sink_(80)
$ns connect $tcp_(80) $sink_(80)
set ftp_(80) [new Application/FTP]
$ftp_(80) attach-agent $tcp_(80)
$ns at 0.2 "$ftp_(80) start"
$ns at 180.0 "$ftp_(80) stop"

#Set a TCP connection between node_(17) and node_(9)
set tcp_(81) [new Agent/TCP/Newreno]
$tcp_(81) set class_ 2
set sink_(81) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(81)
$ns attach-agent $node_(9) $sink_(81)
$ns connect $tcp_(81) $sink_(81)
set ftp_(81) [new Application/FTP]
$ftp_(81) attach-agent $tcp_(81)
$ns at 180.2 "$ftp_(81) start"
$ns at 360.0 "$ftp_(81) stop"

#Set a TCP connection between node_(48) and node_(10)
set tcp_(82) [new Agent/TCP/Newreno]
$tcp_(82) set class_ 2
set sink_(82) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(82)
$ns attach-agent $node_(10) $sink_(82)
$ns connect $tcp_(82) $sink_(82)
set ftp_(82) [new Application/FTP]
$ftp_(82) attach-agent $tcp_(82)
$ns at 360.2 "$ftp_(82) start"
$ns at 540.0 "$ftp_(82) stop"

#Set a TCP connection between node_(33) and node_(45)
set tcp_(83) [new Agent/TCP/Newreno]
$tcp_(83) set class_ 2
set sink_(83) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(83)
$ns attach-agent $node_(45) $sink_(83)
$ns connect $tcp_(83) $sink_(83)
set ftp_(83) [new Application/FTP]
$ftp_(83) attach-agent $tcp_(83)
$ns at 540.2 "$ftp_(83) start"
$ns at 720.0 "$ftp_(83) stop"

#Set a TCP connection between node_(26) and node_(46)
set tcp_(84) [new Agent/TCP/Newreno]
$tcp_(84) set class_ 2
set sink_(84) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(84)
$ns attach-agent $node_(46) $sink_(84)
$ns connect $tcp_(84) $sink_(84)
set ftp_(84) [new Application/FTP]
$ftp_(84) attach-agent $tcp_(84)
$ns at 720.2 "$ftp_(84) start"
$ns at 900.0 "$ftp_(84) stop"

#Set a TCP connection between node_(28) and node_(39)
set tcp_(85) [new Agent/TCP/Newreno]
$tcp_(85) set class_ 2
set sink_(85) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(85)
$ns attach-agent $node_(39) $sink_(85)
$ns connect $tcp_(85) $sink_(85)
set ftp_(85) [new Application/FTP]
$ftp_(85) attach-agent $tcp_(85)
$ns at 0.2 "$ftp_(85) start"
$ns at 180.0 "$ftp_(85) stop"

#Set a TCP connection between node_(0) and node_(42)
set tcp_(86) [new Agent/TCP/Newreno]
$tcp_(86) set class_ 2
set sink_(86) [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp_(86)
$ns attach-agent $node_(42) $sink_(86)
$ns connect $tcp_(86) $sink_(86)
set ftp_(86) [new Application/FTP]
$ftp_(86) attach-agent $tcp_(86)
$ns at 180.2 "$ftp_(86) start"
$ns at 360.0 "$ftp_(86) stop"

#Set a TCP connection between node_(11) and node_(18)
set tcp_(87) [new Agent/TCP/Newreno]
$tcp_(87) set class_ 2
set sink_(87) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(87)
$ns attach-agent $node_(18) $sink_(87)
$ns connect $tcp_(87) $sink_(87)
set ftp_(87) [new Application/FTP]
$ftp_(87) attach-agent $tcp_(87)
$ns at 360.2 "$ftp_(87) start"
$ns at 540.0 "$ftp_(87) stop"

#Set a TCP connection between node_(21) and node_(34)
set tcp_(88) [new Agent/TCP/Newreno]
$tcp_(88) set class_ 2
set sink_(88) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(88)
$ns attach-agent $node_(34) $sink_(88)
$ns connect $tcp_(88) $sink_(88)
set ftp_(88) [new Application/FTP]
$ftp_(88) attach-agent $tcp_(88)
$ns at 540.2 "$ftp_(88) start"
$ns at 720.0 "$ftp_(88) stop"

#Set a TCP connection between node_(17) and node_(46)
set tcp_(89) [new Agent/TCP/Newreno]
$tcp_(89) set class_ 2
set sink_(89) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(89)
$ns attach-agent $node_(46) $sink_(89)
$ns connect $tcp_(89) $sink_(89)
set ftp_(89) [new Application/FTP]
$ftp_(89) attach-agent $tcp_(89)
$ns at 720.2 "$ftp_(89) start"
$ns at 900.0 "$ftp_(89) stop"

#Set a TCP connection between node_(2) and node_(40)
set tcp_(90) [new Agent/TCP/Newreno]
$tcp_(90) set class_ 2
set sink_(90) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(90)
$ns attach-agent $node_(40) $sink_(90)
$ns connect $tcp_(90) $sink_(90)
set ftp_(90) [new Application/FTP]
$ftp_(90) attach-agent $tcp_(90)
$ns at 0.2 "$ftp_(90) start"
$ns at 180.0 "$ftp_(90) stop"

#Set a TCP connection between node_(47) and node_(28)
set tcp_(91) [new Agent/TCP/Newreno]
$tcp_(91) set class_ 2
set sink_(91) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(91)
$ns attach-agent $node_(28) $sink_(91)
$ns connect $tcp_(91) $sink_(91)
set ftp_(91) [new Application/FTP]
$ftp_(91) attach-agent $tcp_(91)
$ns at 180.2 "$ftp_(91) start"
$ns at 360.0 "$ftp_(91) stop"

#Set a TCP connection between node_(5) and node_(42)
set tcp_(92) [new Agent/TCP/Newreno]
$tcp_(92) set class_ 2
set sink_(92) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(92)
$ns attach-agent $node_(42) $sink_(92)
$ns connect $tcp_(92) $sink_(92)
set ftp_(92) [new Application/FTP]
$ftp_(92) attach-agent $tcp_(92)
$ns at 360.2 "$ftp_(92) start"
$ns at 540.0 "$ftp_(92) stop"

#Set a TCP connection between node_(36) and node_(4)
set tcp_(93) [new Agent/TCP/Newreno]
$tcp_(93) set class_ 2
set sink_(93) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(93)
$ns attach-agent $node_(4) $sink_(93)
$ns connect $tcp_(93) $sink_(93)
set ftp_(93) [new Application/FTP]
$ftp_(93) attach-agent $tcp_(93)
$ns at 540.2 "$ftp_(93) start"
$ns at 720.0 "$ftp_(93) stop"

#Set a TCP connection between node_(45) and node_(44)
set tcp_(94) [new Agent/TCP/Newreno]
$tcp_(94) set class_ 2
set sink_(94) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(94)
$ns attach-agent $node_(44) $sink_(94)
$ns connect $tcp_(94) $sink_(94)
set ftp_(94) [new Application/FTP]
$ftp_(94) attach-agent $tcp_(94)
$ns at 720.2 "$ftp_(94) start"
$ns at 900.0 "$ftp_(94) stop"

#Set a TCP connection between node_(17) and node_(46)
set tcp_(95) [new Agent/TCP/Newreno]
$tcp_(95) set class_ 2
set sink_(95) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(95)
$ns attach-agent $node_(46) $sink_(95)
$ns connect $tcp_(95) $sink_(95)
set ftp_(95) [new Application/FTP]
$ftp_(95) attach-agent $tcp_(95)
$ns at 0.2 "$ftp_(95) start"
$ns at 180.0 "$ftp_(95) stop"

#Set a TCP connection between node_(22) and node_(31)
set tcp_(96) [new Agent/TCP/Newreno]
$tcp_(96) set class_ 2
set sink_(96) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(96)
$ns attach-agent $node_(31) $sink_(96)
$ns connect $tcp_(96) $sink_(96)
set ftp_(96) [new Application/FTP]
$ftp_(96) attach-agent $tcp_(96)
$ns at 180.2 "$ftp_(96) start"
$ns at 360.0 "$ftp_(96) stop"

#Set a TCP connection between node_(19) and node_(41)
set tcp_(97) [new Agent/TCP/Newreno]
$tcp_(97) set class_ 2
set sink_(97) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(97)
$ns attach-agent $node_(41) $sink_(97)
$ns connect $tcp_(97) $sink_(97)
set ftp_(97) [new Application/FTP]
$ftp_(97) attach-agent $tcp_(97)
$ns at 360.2 "$ftp_(97) start"
$ns at 540.0 "$ftp_(97) stop"

#Set a TCP connection between node_(22) and node_(16)
set tcp_(98) [new Agent/TCP/Newreno]
$tcp_(98) set class_ 2
set sink_(98) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(98)
$ns attach-agent $node_(16) $sink_(98)
$ns connect $tcp_(98) $sink_(98)
set ftp_(98) [new Application/FTP]
$ftp_(98) attach-agent $tcp_(98)
$ns at 540.2 "$ftp_(98) start"
$ns at 720.0 "$ftp_(98) stop"

#Set a TCP connection between node_(23) and node_(8)
set tcp_(99) [new Agent/TCP/Newreno]
$tcp_(99) set class_ 2
set sink_(99) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(99)
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
