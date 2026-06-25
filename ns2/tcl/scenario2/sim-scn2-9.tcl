#sim-scn2-9.tcl 
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
set tracefd       [open sim-scn2-9-$val(rp)-trace.tr w]
set windowVsTime2 [open sim-scn2-9-$val(rp)-win-.tr w]
set namtrace      [open sim-scn2-9-$val(rp).nam w]

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
$node_(0) set X_ 2697 
$node_(0) set Y_ 341 
$node_(0) set Z_ 0.0 
$node_(1) set X_ 646 
$node_(1) set Y_ 569 
$node_(1) set Z_ 0.0 
$node_(2) set X_ 2845 
$node_(2) set Y_ 21 
$node_(2) set Z_ 0.0 
$node_(3) set X_ 1166 
$node_(3) set Y_ 430 
$node_(3) set Z_ 0.0 
$node_(4) set X_ 1548 
$node_(4) set Y_ 305 
$node_(4) set Z_ 0.0 
$node_(5) set X_ 923 
$node_(5) set Y_ 661 
$node_(5) set Z_ 0.0 
$node_(6) set X_ 2057 
$node_(6) set Y_ 310 
$node_(6) set Z_ 0.0 
$node_(7) set X_ 59 
$node_(7) set Y_ 653 
$node_(7) set Z_ 0.0 
$node_(8) set X_ 1421 
$node_(8) set Y_ 284 
$node_(8) set Z_ 0.0 
$node_(9) set X_ 1870 
$node_(9) set Y_ 871 
$node_(9) set Z_ 0.0 
$node_(10) set X_ 1871 
$node_(10) set Y_ 477 
$node_(10) set Z_ 0.0 
$node_(11) set X_ 1753 
$node_(11) set Y_ 450 
$node_(11) set Z_ 0.0 
$node_(12) set X_ 2248 
$node_(12) set Y_ 366 
$node_(12) set Z_ 0.0 
$node_(13) set X_ 345 
$node_(13) set Y_ 38 
$node_(13) set Z_ 0.0 
$node_(14) set X_ 1214 
$node_(14) set Y_ 644 
$node_(14) set Z_ 0.0 
$node_(15) set X_ 128 
$node_(15) set Y_ 387 
$node_(15) set Z_ 0.0 
$node_(16) set X_ 816 
$node_(16) set Y_ 557 
$node_(16) set Z_ 0.0 
$node_(17) set X_ 1970 
$node_(17) set Y_ 955 
$node_(17) set Z_ 0.0 
$node_(18) set X_ 1220 
$node_(18) set Y_ 769 
$node_(18) set Z_ 0.0 
$node_(19) set X_ 2183 
$node_(19) set Y_ 467 
$node_(19) set Z_ 0.0 
$node_(20) set X_ 1246 
$node_(20) set Y_ 900 
$node_(20) set Z_ 0.0 
$node_(21) set X_ 824 
$node_(21) set Y_ 899 
$node_(21) set Z_ 0.0 
$node_(22) set X_ 1501 
$node_(22) set Y_ 306 
$node_(22) set Z_ 0.0 
$node_(23) set X_ 2046 
$node_(23) set Y_ 887 
$node_(23) set Z_ 0.0 
$node_(24) set X_ 1654 
$node_(24) set Y_ 456 
$node_(24) set Z_ 0.0 
$node_(25) set X_ 1347 
$node_(25) set Y_ 874 
$node_(25) set Z_ 0.0 
$node_(26) set X_ 2523 
$node_(26) set Y_ 464 
$node_(26) set Z_ 0.0 
$node_(27) set X_ 598 
$node_(27) set Y_ 662 
$node_(27) set Z_ 0.0 
$node_(28) set X_ 1295 
$node_(28) set Y_ 964 
$node_(28) set Z_ 0.0 
$node_(29) set X_ 1723 
$node_(29) set Y_ 168 
$node_(29) set Z_ 0.0 
$node_(30) set X_ 291 
$node_(30) set Y_ 521 
$node_(30) set Z_ 0.0 
$node_(31) set X_ 852 
$node_(31) set Y_ 331 
$node_(31) set Z_ 0.0 
$node_(32) set X_ 1265 
$node_(32) set Y_ 214 
$node_(32) set Z_ 0.0 
$node_(33) set X_ 2717 
$node_(33) set Y_ 83 
$node_(33) set Z_ 0.0 
$node_(34) set X_ 2261 
$node_(34) set Y_ 841 
$node_(34) set Z_ 0.0 
$node_(35) set X_ 2935 
$node_(35) set Y_ 243 
$node_(35) set Z_ 0.0 
$node_(36) set X_ 2552 
$node_(36) set Y_ 448 
$node_(36) set Z_ 0.0 
$node_(37) set X_ 1714 
$node_(37) set Y_ 968 
$node_(37) set Z_ 0.0 
$node_(38) set X_ 1176 
$node_(38) set Y_ 536 
$node_(38) set Z_ 0.0 
$node_(39) set X_ 2318 
$node_(39) set Y_ 169 
$node_(39) set Z_ 0.0 
$node_(40) set X_ 9 
$node_(40) set Y_ 326 
$node_(40) set Z_ 0.0 
$node_(41) set X_ 1476 
$node_(41) set Y_ 893 
$node_(41) set Z_ 0.0 
$node_(42) set X_ 248 
$node_(42) set Y_ 949 
$node_(42) set Z_ 0.0 
$node_(43) set X_ 1648 
$node_(43) set Y_ 209 
$node_(43) set Z_ 0.0 
$node_(44) set X_ 1543 
$node_(44) set Y_ 275 
$node_(44) set Z_ 0.0 
$node_(45) set X_ 835 
$node_(45) set Y_ 609 
$node_(45) set Z_ 0.0 
$node_(46) set X_ 875 
$node_(46) set Y_ 372 
$node_(46) set Z_ 0.0 
$node_(47) set X_ 2310 
$node_(47) set Y_ 248 
$node_(47) set Z_ 0.0 
$node_(48) set X_ 596 
$node_(48) set Y_ 256 
$node_(48) set Z_ 0.0 
$node_(49) set X_ 1337 
$node_(49) set Y_ 625 
$node_(49) set Z_ 0.0 
$node_(50) set X_ 2831 
$node_(50) set Y_ 688 
$node_(50) set Z_ 0.0 
$node_(51) set X_ 2589 
$node_(51) set Y_ 450 
$node_(51) set Z_ 0.0 
$ns at 0.0 "$node_(51) off" 
$ns at 165.0 "$node_(51) on" 
$node_(52) set X_ 1709 
$node_(52) set Y_ 253 
$node_(52) set Z_ 0.0 
$ns at 0.0 "$node_(52) off" 
$ns at 165.0 "$node_(52) on" 
$node_(53) set X_ 1582 
$node_(53) set Y_ 540 
$node_(53) set Z_ 0.0 
$ns at 0.0 "$node_(53) off" 
$ns at 165.0 "$node_(53) on" 
$node_(54) set X_ 1600 
$node_(54) set Y_ 853 
$node_(54) set Z_ 0.0 
$ns at 0.0 "$node_(54) off" 
$ns at 165.0 "$node_(54) on" 
$node_(55) set X_ 54 
$node_(55) set Y_ 512 
$node_(55) set Z_ 0.0 
$ns at 0.0 "$node_(55) off" 
$ns at 165.0 "$node_(55) on" 
$node_(56) set X_ 1741 
$node_(56) set Y_ 48 
$node_(56) set Z_ 0.0 
$ns at 0.0 "$node_(56) off" 
$ns at 165.0 "$node_(56) on" 
$node_(57) set X_ 2740 
$node_(57) set Y_ 979 
$node_(57) set Z_ 0.0 
$ns at 0.0 "$node_(57) off" 
$ns at 165.0 "$node_(57) on" 
$node_(58) set X_ 1302 
$node_(58) set Y_ 402 
$node_(58) set Z_ 0.0 
$ns at 0.0 "$node_(58) off" 
$ns at 165.0 "$node_(58) on" 
$node_(59) set X_ 2534 
$node_(59) set Y_ 684 
$node_(59) set Z_ 0.0 
$ns at 0.0 "$node_(59) off" 
$ns at 165.0 "$node_(59) on" 
$node_(60) set X_ 1045 
$node_(60) set Y_ 64 
$node_(60) set Z_ 0.0 
$ns at 0.0 "$node_(60) off" 
$ns at 165.0 "$node_(60) on" 
$node_(61) set X_ 1520 
$node_(61) set Y_ 753 
$node_(61) set Z_ 0.0 
$ns at 0.0 "$node_(61) off" 
$ns at 165.0 "$node_(61) on" 
$node_(62) set X_ 2386 
$node_(62) set Y_ 397 
$node_(62) set Z_ 0.0 
$ns at 0.0 "$node_(62) off" 
$ns at 165.0 "$node_(62) on" 
$node_(63) set X_ 1807 
$node_(63) set Y_ 789 
$node_(63) set Z_ 0.0 
$ns at 0.0 "$node_(63) off" 
$ns at 165.0 "$node_(63) on" 
$node_(64) set X_ 2661 
$node_(64) set Y_ 333 
$node_(64) set Z_ 0.0 
$ns at 0.0 "$node_(64) off" 
$ns at 165.0 "$node_(64) on" 
$node_(65) set X_ 1545 
$node_(65) set Y_ 103 
$node_(65) set Z_ 0.0 
$ns at 0.0 "$node_(65) off" 
$ns at 165.0 "$node_(65) on" 
$node_(66) set X_ 2024 
$node_(66) set Y_ 499 
$node_(66) set Z_ 0.0 
$ns at 0.0 "$node_(66) off" 
$ns at 165.0 "$node_(66) on" 
$node_(67) set X_ 2871 
$node_(67) set Y_ 717 
$node_(67) set Z_ 0.0 
$ns at 0.0 "$node_(67) off" 
$ns at 165.0 "$node_(67) on" 
$node_(68) set X_ 331 
$node_(68) set Y_ 904 
$node_(68) set Z_ 0.0 
$ns at 0.0 "$node_(68) off" 
$ns at 165.0 "$node_(68) on" 
$node_(69) set X_ 2928 
$node_(69) set Y_ 145 
$node_(69) set Z_ 0.0 
$ns at 0.0 "$node_(69) off" 
$ns at 165.0 "$node_(69) on" 
$node_(70) set X_ 893 
$node_(70) set Y_ 85 
$node_(70) set Z_ 0.0 
$ns at 0.0 "$node_(70) off" 
$ns at 165.0 "$node_(70) on" 
$node_(71) set X_ 1425 
$node_(71) set Y_ 158 
$node_(71) set Z_ 0.0 
$ns at 0.0 "$node_(71) off" 
$ns at 165.0 "$node_(71) on" 
$node_(72) set X_ 1907 
$node_(72) set Y_ 217 
$node_(72) set Z_ 0.0 
$ns at 0.0 "$node_(72) off" 
$ns at 165.0 "$node_(72) on" 
$node_(73) set X_ 2499 
$node_(73) set Y_ 872 
$node_(73) set Z_ 0.0 
$ns at 0.0 "$node_(73) off" 
$ns at 165.0 "$node_(73) on" 
$node_(74) set X_ 1777 
$node_(74) set Y_ 589 
$node_(74) set Z_ 0.0 
$ns at 0.0 "$node_(74) off" 
$ns at 165.0 "$node_(74) on" 
$node_(75) set X_ 925 
$node_(75) set Y_ 536 
$node_(75) set Z_ 0.0 
$ns at 0.0 "$node_(75) off" 
$ns at 330.0 "$node_(75) on" 
$node_(76) set X_ 444 
$node_(76) set Y_ 266 
$node_(76) set Z_ 0.0 
$ns at 0.0 "$node_(76) off" 
$ns at 330.0 "$node_(76) on" 
$node_(77) set X_ 1966 
$node_(77) set Y_ 339 
$node_(77) set Z_ 0.0 
$ns at 0.0 "$node_(77) off" 
$ns at 330.0 "$node_(77) on" 
$node_(78) set X_ 1168 
$node_(78) set Y_ 491 
$node_(78) set Z_ 0.0 
$ns at 0.0 "$node_(78) off" 
$ns at 330.0 "$node_(78) on" 
$node_(79) set X_ 2337 
$node_(79) set Y_ 400 
$node_(79) set Z_ 0.0 
$ns at 0.0 "$node_(79) off" 
$ns at 330.0 "$node_(79) on" 
$node_(80) set X_ 1045 
$node_(80) set Y_ 583 
$node_(80) set Z_ 0.0 
$ns at 0.0 "$node_(80) off" 
$ns at 330.0 "$node_(80) on" 
$node_(81) set X_ 982 
$node_(81) set Y_ 875 
$node_(81) set Z_ 0.0 
$ns at 0.0 "$node_(81) off" 
$ns at 330.0 "$node_(81) on" 
$node_(82) set X_ 2813 
$node_(82) set Y_ 635 
$node_(82) set Z_ 0.0 
$ns at 0.0 "$node_(82) off" 
$ns at 330.0 "$node_(82) on" 
$node_(83) set X_ 2456 
$node_(83) set Y_ 747 
$node_(83) set Z_ 0.0 
$ns at 0.0 "$node_(83) off" 
$ns at 330.0 "$node_(83) on" 
$node_(84) set X_ 2273 
$node_(84) set Y_ 364 
$node_(84) set Z_ 0.0 
$ns at 0.0 "$node_(84) off" 
$ns at 330.0 "$node_(84) on" 
$node_(85) set X_ 874 
$node_(85) set Y_ 461 
$node_(85) set Z_ 0.0 
$ns at 0.0 "$node_(85) off" 
$ns at 330.0 "$node_(85) on" 
$node_(86) set X_ 1871 
$node_(86) set Y_ 788 
$node_(86) set Z_ 0.0 
$ns at 0.0 "$node_(86) off" 
$ns at 330.0 "$node_(86) on" 
$node_(87) set X_ 1422 
$node_(87) set Y_ 29 
$node_(87) set Z_ 0.0 
$ns at 0.0 "$node_(87) off" 
$ns at 330.0 "$node_(87) on" 
$node_(88) set X_ 2670 
$node_(88) set Y_ 270 
$node_(88) set Z_ 0.0 
$ns at 0.0 "$node_(88) off" 
$ns at 330.0 "$node_(88) on" 
$node_(89) set X_ 531 
$node_(89) set Y_ 606 
$node_(89) set Z_ 0.0 
$ns at 0.0 "$node_(89) off" 
$ns at 330.0 "$node_(89) on" 
$node_(90) set X_ 131 
$node_(90) set Y_ 635 
$node_(90) set Z_ 0.0 
$ns at 0.0 "$node_(90) off" 
$ns at 330.0 "$node_(90) on" 
$node_(91) set X_ 2789 
$node_(91) set Y_ 824 
$node_(91) set Z_ 0.0 
$ns at 0.0 "$node_(91) off" 
$ns at 330.0 "$node_(91) on" 
$node_(92) set X_ 1715 
$node_(92) set Y_ 708 
$node_(92) set Z_ 0.0 
$ns at 0.0 "$node_(92) off" 
$ns at 330.0 "$node_(92) on" 
$node_(93) set X_ 2694 
$node_(93) set Y_ 371 
$node_(93) set Z_ 0.0 
$ns at 0.0 "$node_(93) off" 
$ns at 330.0 "$node_(93) on" 
$node_(94) set X_ 2466 
$node_(94) set Y_ 619 
$node_(94) set Z_ 0.0 
$ns at 0.0 "$node_(94) off" 
$ns at 330.0 "$node_(94) on" 
$node_(95) set X_ 2284 
$node_(95) set Y_ 405 
$node_(95) set Z_ 0.0 
$ns at 0.0 "$node_(95) off" 
$ns at 330.0 "$node_(95) on" 
$node_(96) set X_ 1259 
$node_(96) set Y_ 658 
$node_(96) set Z_ 0.0 
$ns at 0.0 "$node_(96) off" 
$ns at 330.0 "$node_(96) on" 
$node_(97) set X_ 1640 
$node_(97) set Y_ 366 
$node_(97) set Z_ 0.0 
$ns at 0.0 "$node_(97) off" 
$ns at 330.0 "$node_(97) on" 
$node_(98) set X_ 2460 
$node_(98) set Y_ 311 
$node_(98) set Z_ 0.0 
$ns at 0.0 "$node_(98) off" 
$ns at 330.0 "$node_(98) on" 
$node_(99) set X_ 1111 
$node_(99) set Y_ 709 
$node_(99) set Z_ 0.0 
$ns at 0.0 "$node_(99) off" 
$ns at 330.0 "$node_(99) on" 
$node_(100) set X_ 2260 
$node_(100) set Y_ 316 
$node_(100) set Z_ 0.0 
$ns at 0.0 "$node_(100) off" 
$ns at 495.0 "$node_(100) on" 
$node_(101) set X_ 2022 
$node_(101) set Y_ 860 
$node_(101) set Z_ 0.0 
$ns at 0.0 "$node_(101) off" 
$ns at 495.0 "$node_(101) on" 
$node_(102) set X_ 1884 
$node_(102) set Y_ 239 
$node_(102) set Z_ 0.0 
$ns at 0.0 "$node_(102) off" 
$ns at 495.0 "$node_(102) on" 
$node_(103) set X_ 2435 
$node_(103) set Y_ 430 
$node_(103) set Z_ 0.0 
$ns at 0.0 "$node_(103) off" 
$ns at 495.0 "$node_(103) on" 
$node_(104) set X_ 1367 
$node_(104) set Y_ 141 
$node_(104) set Z_ 0.0 
$ns at 0.0 "$node_(104) off" 
$ns at 495.0 "$node_(104) on" 
$node_(105) set X_ 2336 
$node_(105) set Y_ 365 
$node_(105) set Z_ 0.0 
$ns at 0.0 "$node_(105) off" 
$ns at 495.0 "$node_(105) on" 
$node_(106) set X_ 1466 
$node_(106) set Y_ 330 
$node_(106) set Z_ 0.0 
$ns at 0.0 "$node_(106) off" 
$ns at 495.0 "$node_(106) on" 
$node_(107) set X_ 1411 
$node_(107) set Y_ 233 
$node_(107) set Z_ 0.0 
$ns at 0.0 "$node_(107) off" 
$ns at 495.0 "$node_(107) on" 
$node_(108) set X_ 1671 
$node_(108) set Y_ 75 
$node_(108) set Z_ 0.0 
$ns at 0.0 "$node_(108) off" 
$ns at 495.0 "$node_(108) on" 
$node_(109) set X_ 288 
$node_(109) set Y_ 289 
$node_(109) set Z_ 0.0 
$ns at 0.0 "$node_(109) off" 
$ns at 495.0 "$node_(109) on" 
$node_(110) set X_ 137 
$node_(110) set Y_ 430 
$node_(110) set Z_ 0.0 
$ns at 0.0 "$node_(110) off" 
$ns at 495.0 "$node_(110) on" 
$node_(111) set X_ 875 
$node_(111) set Y_ 325 
$node_(111) set Z_ 0.0 
$ns at 0.0 "$node_(111) off" 
$ns at 495.0 "$node_(111) on" 
$node_(112) set X_ 1667 
$node_(112) set Y_ 1 
$node_(112) set Z_ 0.0 
$ns at 0.0 "$node_(112) off" 
$ns at 495.0 "$node_(112) on" 
$node_(113) set X_ 36 
$node_(113) set Y_ 543 
$node_(113) set Z_ 0.0 
$ns at 0.0 "$node_(113) off" 
$ns at 495.0 "$node_(113) on" 
$node_(114) set X_ 1667 
$node_(114) set Y_ 534 
$node_(114) set Z_ 0.0 
$ns at 0.0 "$node_(114) off" 
$ns at 495.0 "$node_(114) on" 
$node_(115) set X_ 1578 
$node_(115) set Y_ 872 
$node_(115) set Z_ 0.0 
$ns at 0.0 "$node_(115) off" 
$ns at 495.0 "$node_(115) on" 
$node_(116) set X_ 2254 
$node_(116) set Y_ 747 
$node_(116) set Z_ 0.0 
$ns at 0.0 "$node_(116) off" 
$ns at 495.0 "$node_(116) on" 
$node_(117) set X_ 2062 
$node_(117) set Y_ 202 
$node_(117) set Z_ 0.0 
$ns at 0.0 "$node_(117) off" 
$ns at 495.0 "$node_(117) on" 
$node_(118) set X_ 1412 
$node_(118) set Y_ 682 
$node_(118) set Z_ 0.0 
$ns at 0.0 "$node_(118) off" 
$ns at 495.0 "$node_(118) on" 
$node_(119) set X_ 577 
$node_(119) set Y_ 993 
$node_(119) set Z_ 0.0 
$ns at 0.0 "$node_(119) off" 
$ns at 495.0 "$node_(119) on" 
$node_(120) set X_ 317 
$node_(120) set Y_ 167 
$node_(120) set Z_ 0.0 
$ns at 0.0 "$node_(120) off" 
$ns at 495.0 "$node_(120) on" 
$node_(121) set X_ 2176 
$node_(121) set Y_ 586 
$node_(121) set Z_ 0.0 
$ns at 0.0 "$node_(121) off" 
$ns at 495.0 "$node_(121) on" 
$node_(122) set X_ 1563 
$node_(122) set Y_ 693 
$node_(122) set Z_ 0.0 
$ns at 0.0 "$node_(122) off" 
$ns at 495.0 "$node_(122) on" 
$node_(123) set X_ 2152 
$node_(123) set Y_ 337 
$node_(123) set Z_ 0.0 
$ns at 0.0 "$node_(123) off" 
$ns at 495.0 "$node_(123) on" 
$node_(124) set X_ 1209 
$node_(124) set Y_ 119 
$node_(124) set Z_ 0.0 
$ns at 0.0 "$node_(124) off" 
$ns at 495.0 "$node_(124) on" 
$node_(125) set X_ 2884 
$node_(125) set Y_ 383 
$node_(125) set Z_ 0.0 
$ns at 0.0 "$node_(125) off" 
$ns at 660.0 "$node_(125) on" 
$node_(126) set X_ 2119 
$node_(126) set Y_ 141 
$node_(126) set Z_ 0.0 
$ns at 0.0 "$node_(126) off" 
$ns at 660.0 "$node_(126) on" 
$node_(127) set X_ 1379 
$node_(127) set Y_ 457 
$node_(127) set Z_ 0.0 
$ns at 0.0 "$node_(127) off" 
$ns at 660.0 "$node_(127) on" 
$node_(128) set X_ 2181 
$node_(128) set Y_ 378 
$node_(128) set Z_ 0.0 
$ns at 0.0 "$node_(128) off" 
$ns at 660.0 "$node_(128) on" 
$node_(129) set X_ 2125 
$node_(129) set Y_ 656 
$node_(129) set Z_ 0.0 
$ns at 0.0 "$node_(129) off" 
$ns at 660.0 "$node_(129) on" 
$node_(130) set X_ 2486 
$node_(130) set Y_ 283 
$node_(130) set Z_ 0.0 
$ns at 0.0 "$node_(130) off" 
$ns at 660.0 "$node_(130) on" 
$node_(131) set X_ 220 
$node_(131) set Y_ 493 
$node_(131) set Z_ 0.0 
$ns at 0.0 "$node_(131) off" 
$ns at 660.0 "$node_(131) on" 
$node_(132) set X_ 1584 
$node_(132) set Y_ 794 
$node_(132) set Z_ 0.0 
$ns at 0.0 "$node_(132) off" 
$ns at 660.0 "$node_(132) on" 
$node_(133) set X_ 129 
$node_(133) set Y_ 877 
$node_(133) set Z_ 0.0 
$ns at 0.0 "$node_(133) off" 
$ns at 660.0 "$node_(133) on" 
$node_(134) set X_ 1408 
$node_(134) set Y_ 831 
$node_(134) set Z_ 0.0 
$ns at 0.0 "$node_(134) off" 
$ns at 660.0 "$node_(134) on" 
$node_(135) set X_ 2764 
$node_(135) set Y_ 885 
$node_(135) set Z_ 0.0 
$ns at 0.0 "$node_(135) off" 
$ns at 660.0 "$node_(135) on" 
$node_(136) set X_ 2382 
$node_(136) set Y_ 236 
$node_(136) set Z_ 0.0 
$ns at 0.0 "$node_(136) off" 
$ns at 660.0 "$node_(136) on" 
$node_(137) set X_ 2871 
$node_(137) set Y_ 323 
$node_(137) set Z_ 0.0 
$ns at 0.0 "$node_(137) off" 
$ns at 660.0 "$node_(137) on" 
$node_(138) set X_ 1657 
$node_(138) set Y_ 775 
$node_(138) set Z_ 0.0 
$ns at 0.0 "$node_(138) off" 
$ns at 660.0 "$node_(138) on" 
$node_(139) set X_ 2972 
$node_(139) set Y_ 112 
$node_(139) set Z_ 0.0 
$ns at 0.0 "$node_(139) off" 
$ns at 660.0 "$node_(139) on" 
$node_(140) set X_ 308 
$node_(140) set Y_ 133 
$node_(140) set Z_ 0.0 
$ns at 0.0 "$node_(140) off" 
$ns at 660.0 "$node_(140) on" 
$node_(141) set X_ 1394 
$node_(141) set Y_ 467 
$node_(141) set Z_ 0.0 
$ns at 0.0 "$node_(141) off" 
$ns at 660.0 "$node_(141) on" 
$node_(142) set X_ 2652 
$node_(142) set Y_ 648 
$node_(142) set Z_ 0.0 
$ns at 0.0 "$node_(142) off" 
$ns at 660.0 "$node_(142) on" 
$node_(143) set X_ 63 
$node_(143) set Y_ 697 
$node_(143) set Z_ 0.0 
$ns at 0.0 "$node_(143) off" 
$ns at 660.0 "$node_(143) on" 
$node_(144) set X_ 1695 
$node_(144) set Y_ 654 
$node_(144) set Z_ 0.0 
$ns at 0.0 "$node_(144) off" 
$ns at 660.0 "$node_(144) on" 
$node_(145) set X_ 2980 
$node_(145) set Y_ 212 
$node_(145) set Z_ 0.0 
$ns at 0.0 "$node_(145) off" 
$ns at 660.0 "$node_(145) on" 
$node_(146) set X_ 968 
$node_(146) set Y_ 948 
$node_(146) set Z_ 0.0 
$ns at 0.0 "$node_(146) off" 
$ns at 660.0 "$node_(146) on" 
$node_(147) set X_ 2407 
$node_(147) set Y_ 958 
$node_(147) set Z_ 0.0 
$ns at 0.0 "$node_(147) off" 
$ns at 660.0 "$node_(147) on" 
$node_(148) set X_ 2818 
$node_(148) set Y_ 834 
$node_(148) set Z_ 0.0 
$ns at 0.0 "$node_(148) off" 
$ns at 660.0 "$node_(148) on" 
$node_(149) set X_ 1914 
$node_(149) set Y_ 102 
$node_(149) set Z_ 0.0 
$ns at 0.0 "$node_(149) off" 
$ns at 660.0 "$node_(149) on" 

# Generation of movements
$ns at 0.0 "$node_(0) setdest 1391 612 17.0" 
$ns at 72.80118075398997 "$node_(0) setdest 1282 196 2.0" 
$ns at 119.74155015560183 "$node_(0) setdest 2969 724 18.0" 
$ns at 275.56063915878127 "$node_(0) setdest 2779 662 10.0" 
$ns at 385.0746539483648 "$node_(0) setdest 243 903 19.0" 
$ns at 532.2741245683304 "$node_(0) setdest 2268 819 1.0" 
$ns at 564.3752146401738 "$node_(0) setdest 1576 15 18.0" 
$ns at 623.7610035520333 "$node_(0) setdest 387 821 17.0" 
$ns at 732.4027078204492 "$node_(0) setdest 1284 159 11.0" 
$ns at 863.714302963025 "$node_(0) setdest 2653 502 13.0" 
$ns at 0.0 "$node_(1) setdest 1990 96 7.0" 
$ns at 58.924255191269424 "$node_(1) setdest 766 470 16.0" 
$ns at 126.20945475248058 "$node_(1) setdest 1384 539 7.0" 
$ns at 211.3660054307005 "$node_(1) setdest 2066 271 14.0" 
$ns at 328.34329571980464 "$node_(1) setdest 2334 995 10.0" 
$ns at 374.41294374272366 "$node_(1) setdest 2957 883 1.0" 
$ns at 411.47997091853676 "$node_(1) setdest 1014 67 16.0" 
$ns at 497.8437704624251 "$node_(1) setdest 860 124 3.0" 
$ns at 552.5287572893186 "$node_(1) setdest 1504 406 15.0" 
$ns at 584.1909772606333 "$node_(1) setdest 1992 756 1.0" 
$ns at 620.9306931343058 "$node_(1) setdest 1019 735 5.0" 
$ns at 668.8124240802089 "$node_(1) setdest 1045 343 4.0" 
$ns at 703.6514225566084 "$node_(1) setdest 1734 614 15.0" 
$ns at 739.6170173784935 "$node_(1) setdest 2559 158 7.0" 
$ns at 824.9524344101055 "$node_(1) setdest 851 883 4.0" 
$ns at 888.4241884743359 "$node_(1) setdest 1559 702 19.0" 
$ns at 0.0 "$node_(2) setdest 1376 948 12.0" 
$ns at 54.10071482867956 "$node_(2) setdest 759 621 9.0" 
$ns at 147.95658096294972 "$node_(2) setdest 2766 343 8.0" 
$ns at 247.85552872954216 "$node_(2) setdest 1387 77 14.0" 
$ns at 287.6580335821295 "$node_(2) setdest 394 246 14.0" 
$ns at 327.13003996747705 "$node_(2) setdest 1454 885 17.0" 
$ns at 386.19785734378365 "$node_(2) setdest 2498 857 5.0" 
$ns at 463.5888952174048 "$node_(2) setdest 8 942 19.0" 
$ns at 657.1673492968667 "$node_(2) setdest 2076 846 5.0" 
$ns at 707.4448915261041 "$node_(2) setdest 698 779 2.0" 
$ns at 748.4056752500984 "$node_(2) setdest 880 260 5.0" 
$ns at 796.4032923336541 "$node_(2) setdest 2691 260 8.0" 
$ns at 886.0886824923931 "$node_(2) setdest 459 595 17.0" 
$ns at 0.0 "$node_(3) setdest 766 749 12.0" 
$ns at 72.02263440293787 "$node_(3) setdest 1941 938 7.0" 
$ns at 118.87844136753287 "$node_(3) setdest 2128 276 17.0" 
$ns at 149.86443736767382 "$node_(3) setdest 2965 371 15.0" 
$ns at 296.2416339495975 "$node_(3) setdest 2267 530 5.0" 
$ns at 335.4285609681938 "$node_(3) setdest 1970 49 6.0" 
$ns at 403.88979079995534 "$node_(3) setdest 905 696 14.0" 
$ns at 549.4080186174342 "$node_(3) setdest 2760 635 16.0" 
$ns at 595.5819293460311 "$node_(3) setdest 1850 467 7.0" 
$ns at 672.4231925054164 "$node_(3) setdest 1035 19 8.0" 
$ns at 718.7078486973969 "$node_(3) setdest 1315 764 6.0" 
$ns at 786.3309323158023 "$node_(3) setdest 1320 493 7.0" 
$ns at 848.01405336693 "$node_(3) setdest 1 971 3.0" 
$ns at 0.0 "$node_(4) setdest 2474 808 17.0" 
$ns at 186.04649003297163 "$node_(4) setdest 12 736 15.0" 
$ns at 232.99542100083104 "$node_(4) setdest 1716 788 18.0" 
$ns at 310.9788410097476 "$node_(4) setdest 2420 632 7.0" 
$ns at 365.61241589491453 "$node_(4) setdest 1850 438 9.0" 
$ns at 436.69975047828257 "$node_(4) setdest 1002 243 11.0" 
$ns at 522.8313132638791 "$node_(4) setdest 1116 698 14.0" 
$ns at 563.9877764411077 "$node_(4) setdest 1507 463 14.0" 
$ns at 666.2221503962281 "$node_(4) setdest 2868 299 7.0" 
$ns at 737.73681877516 "$node_(4) setdest 472 57 18.0" 
$ns at 862.5369003736162 "$node_(4) setdest 1993 366 14.0" 
$ns at 0.0 "$node_(5) setdest 2418 801 6.0" 
$ns at 77.96002550168178 "$node_(5) setdest 1762 720 13.0" 
$ns at 134.33774227629226 "$node_(5) setdest 1969 738 11.0" 
$ns at 220.6355063115939 "$node_(5) setdest 1558 41 19.0" 
$ns at 358.27908283563374 "$node_(5) setdest 2221 346 19.0" 
$ns at 416.8312239208164 "$node_(5) setdest 1641 313 3.0" 
$ns at 457.1963339502938 "$node_(5) setdest 403 691 5.0" 
$ns at 503.4880880325597 "$node_(5) setdest 2904 247 2.0" 
$ns at 534.4633188842355 "$node_(5) setdest 1644 840 11.0" 
$ns at 579.1136654745417 "$node_(5) setdest 1300 581 6.0" 
$ns at 664.8464702418275 "$node_(5) setdest 2407 106 11.0" 
$ns at 740.4985048819161 "$node_(5) setdest 1361 460 9.0" 
$ns at 779.5886736863688 "$node_(5) setdest 2901 906 2.0" 
$ns at 820.4933707193585 "$node_(5) setdest 2006 299 1.0" 
$ns at 855.0543893255157 "$node_(5) setdest 520 301 3.0" 
$ns at 0.0 "$node_(6) setdest 1571 817 1.0" 
$ns at 38.56769805356248 "$node_(6) setdest 1125 511 18.0" 
$ns at 246.76749719065523 "$node_(6) setdest 734 167 12.0" 
$ns at 319.22422543726475 "$node_(6) setdest 1727 950 19.0" 
$ns at 356.2488297071901 "$node_(6) setdest 777 334 5.0" 
$ns at 406.84440471217255 "$node_(6) setdest 876 591 12.0" 
$ns at 545.8196858574172 "$node_(6) setdest 1375 228 12.0" 
$ns at 621.7500065756768 "$node_(6) setdest 821 713 5.0" 
$ns at 700.3202434812091 "$node_(6) setdest 2825 151 9.0" 
$ns at 794.5518221446836 "$node_(6) setdest 2244 313 2.0" 
$ns at 835.8527706492786 "$node_(6) setdest 417 558 1.0" 
$ns at 872.1568579462619 "$node_(6) setdest 2123 761 13.0" 
$ns at 0.0 "$node_(7) setdest 1380 293 7.0" 
$ns at 49.72993374098818 "$node_(7) setdest 47 477 12.0" 
$ns at 139.2134298471947 "$node_(7) setdest 2571 723 6.0" 
$ns at 204.34726302631626 "$node_(7) setdest 1025 690 16.0" 
$ns at 335.7121755654106 "$node_(7) setdest 2862 449 5.0" 
$ns at 378.804063518042 "$node_(7) setdest 609 575 3.0" 
$ns at 435.9925450164208 "$node_(7) setdest 1884 511 9.0" 
$ns at 537.5404898910454 "$node_(7) setdest 1884 332 17.0" 
$ns at 612.043125213835 "$node_(7) setdest 591 276 15.0" 
$ns at 688.5196639848634 "$node_(7) setdest 636 982 14.0" 
$ns at 793.1518384679788 "$node_(7) setdest 1799 425 4.0" 
$ns at 847.2340337750896 "$node_(7) setdest 1753 962 3.0" 
$ns at 892.9987207929241 "$node_(7) setdest 651 717 17.0" 
$ns at 0.0 "$node_(8) setdest 1678 797 8.0" 
$ns at 66.66259393890662 "$node_(8) setdest 690 457 6.0" 
$ns at 124.71618770706289 "$node_(8) setdest 1453 402 6.0" 
$ns at 162.19405274953112 "$node_(8) setdest 1964 843 3.0" 
$ns at 219.91410767824902 "$node_(8) setdest 1684 831 12.0" 
$ns at 295.8495902067815 "$node_(8) setdest 1360 619 13.0" 
$ns at 374.2553595931913 "$node_(8) setdest 475 508 6.0" 
$ns at 454.7750810114058 "$node_(8) setdest 1087 708 14.0" 
$ns at 620.7856983747907 "$node_(8) setdest 1138 237 2.0" 
$ns at 667.909598264225 "$node_(8) setdest 1002 753 19.0" 
$ns at 850.3200002445001 "$node_(8) setdest 1241 566 12.0" 
$ns at 0.0 "$node_(9) setdest 2212 734 10.0" 
$ns at 94.42750830315578 "$node_(9) setdest 1300 279 12.0" 
$ns at 240.06075429112954 "$node_(9) setdest 2125 104 11.0" 
$ns at 359.64300266150855 "$node_(9) setdest 185 76 19.0" 
$ns at 533.8728370541961 "$node_(9) setdest 896 101 4.0" 
$ns at 585.916022936477 "$node_(9) setdest 2022 756 4.0" 
$ns at 654.7034271364795 "$node_(9) setdest 946 171 9.0" 
$ns at 746.5271757915137 "$node_(9) setdest 188 426 15.0" 
$ns at 894.5500013205626 "$node_(9) setdest 2989 675 4.0" 
$ns at 0.0 "$node_(10) setdest 663 565 14.0" 
$ns at 88.73815391589137 "$node_(10) setdest 2747 316 8.0" 
$ns at 170.6643247026002 "$node_(10) setdest 844 971 19.0" 
$ns at 279.63985314203353 "$node_(10) setdest 2293 937 18.0" 
$ns at 432.6534502099266 "$node_(10) setdest 2589 907 11.0" 
$ns at 484.31011565177914 "$node_(10) setdest 2696 652 12.0" 
$ns at 537.6344862197016 "$node_(10) setdest 1074 994 1.0" 
$ns at 569.3515360549485 "$node_(10) setdest 2420 445 4.0" 
$ns at 610.0793288266175 "$node_(10) setdest 2766 640 9.0" 
$ns at 643.575880725558 "$node_(10) setdest 2632 698 3.0" 
$ns at 687.8423932104021 "$node_(10) setdest 568 75 6.0" 
$ns at 726.5268586450352 "$node_(10) setdest 383 306 14.0" 
$ns at 787.3818959449304 "$node_(10) setdest 2942 276 19.0" 
$ns at 818.960588228715 "$node_(10) setdest 2319 301 17.0" 
$ns at 896.8183925498636 "$node_(10) setdest 1580 344 2.0" 
$ns at 0.0 "$node_(11) setdest 2381 177 14.0" 
$ns at 104.90939998017487 "$node_(11) setdest 2918 124 17.0" 
$ns at 206.7901763645104 "$node_(11) setdest 2656 328 15.0" 
$ns at 251.23686420473072 "$node_(11) setdest 557 132 7.0" 
$ns at 348.0939207090034 "$node_(11) setdest 1320 277 14.0" 
$ns at 429.74453171008184 "$node_(11) setdest 408 74 16.0" 
$ns at 578.2821984948703 "$node_(11) setdest 1364 632 19.0" 
$ns at 748.9098399810857 "$node_(11) setdest 1103 519 6.0" 
$ns at 798.0233817769322 "$node_(11) setdest 1530 924 9.0" 
$ns at 0.0 "$node_(12) setdest 993 527 8.0" 
$ns at 102.39250153135124 "$node_(12) setdest 630 782 8.0" 
$ns at 139.78854390948803 "$node_(12) setdest 1790 271 10.0" 
$ns at 196.05039997674066 "$node_(12) setdest 2211 88 17.0" 
$ns at 324.41643479288587 "$node_(12) setdest 658 973 17.0" 
$ns at 463.508087301834 "$node_(12) setdest 1213 67 14.0" 
$ns at 549.0828477654939 "$node_(12) setdest 2310 681 9.0" 
$ns at 593.270958696695 "$node_(12) setdest 1086 466 11.0" 
$ns at 630.106068274397 "$node_(12) setdest 2428 710 14.0" 
$ns at 690.8389535774451 "$node_(12) setdest 2524 264 17.0" 
$ns at 831.1414099802181 "$node_(12) setdest 2458 789 9.0" 
$ns at 0.0 "$node_(13) setdest 1770 576 7.0" 
$ns at 77.56157345683926 "$node_(13) setdest 2584 205 7.0" 
$ns at 118.9225412373132 "$node_(13) setdest 1163 683 12.0" 
$ns at 216.57856118986973 "$node_(13) setdest 1460 515 8.0" 
$ns at 318.660453499259 "$node_(13) setdest 2360 369 15.0" 
$ns at 435.54498811480687 "$node_(13) setdest 1975 607 17.0" 
$ns at 537.1272256317108 "$node_(13) setdest 1428 974 18.0" 
$ns at 680.4043696400819 "$node_(13) setdest 2146 173 16.0" 
$ns at 743.5136118311856 "$node_(13) setdest 2727 863 16.0" 
$ns at 816.6313701632247 "$node_(13) setdest 1920 896 2.0" 
$ns at 856.675874785931 "$node_(13) setdest 278 210 8.0" 
$ns at 0.0 "$node_(14) setdest 455 885 5.0" 
$ns at 43.02894009910513 "$node_(14) setdest 2037 296 18.0" 
$ns at 249.3029283058534 "$node_(14) setdest 1195 185 11.0" 
$ns at 285.1188423889116 "$node_(14) setdest 2274 732 4.0" 
$ns at 351.19493534315734 "$node_(14) setdest 780 387 12.0" 
$ns at 476.4884116988686 "$node_(14) setdest 2978 293 16.0" 
$ns at 562.9012693060432 "$node_(14) setdest 1617 659 5.0" 
$ns at 613.063224308384 "$node_(14) setdest 2976 275 6.0" 
$ns at 676.1634687429513 "$node_(14) setdest 1659 733 17.0" 
$ns at 835.2154298571937 "$node_(14) setdest 204 565 16.0" 
$ns at 0.0 "$node_(15) setdest 2710 663 6.0" 
$ns at 63.96528304301216 "$node_(15) setdest 2305 848 9.0" 
$ns at 176.22264374874007 "$node_(15) setdest 1302 392 11.0" 
$ns at 315.354380910042 "$node_(15) setdest 2494 613 3.0" 
$ns at 352.1362447600231 "$node_(15) setdest 1968 435 18.0" 
$ns at 416.9061475363852 "$node_(15) setdest 1374 901 14.0" 
$ns at 583.2323771549626 "$node_(15) setdest 457 236 4.0" 
$ns at 616.7071906345647 "$node_(15) setdest 129 962 1.0" 
$ns at 656.5117463427302 "$node_(15) setdest 2203 978 12.0" 
$ns at 805.1544415956959 "$node_(15) setdest 2285 246 11.0" 
$ns at 892.0751214541709 "$node_(15) setdest 1116 929 20.0" 
$ns at 0.0 "$node_(16) setdest 1975 409 13.0" 
$ns at 110.39598514189589 "$node_(16) setdest 484 585 5.0" 
$ns at 144.38875176240768 "$node_(16) setdest 382 256 6.0" 
$ns at 219.89083485109214 "$node_(16) setdest 2565 206 8.0" 
$ns at 306.51647599267693 "$node_(16) setdest 2795 795 12.0" 
$ns at 442.7721644274892 "$node_(16) setdest 2165 500 18.0" 
$ns at 624.7624769310246 "$node_(16) setdest 477 834 7.0" 
$ns at 657.8471012541136 "$node_(16) setdest 2267 547 8.0" 
$ns at 764.5703372349798 "$node_(16) setdest 2257 791 12.0" 
$ns at 803.8165810779645 "$node_(16) setdest 1510 229 16.0" 
$ns at 0.0 "$node_(17) setdest 1541 647 19.0" 
$ns at 57.71968904126375 "$node_(17) setdest 93 747 12.0" 
$ns at 173.67162523756957 "$node_(17) setdest 2178 209 14.0" 
$ns at 211.6075467996192 "$node_(17) setdest 2395 996 4.0" 
$ns at 254.47154387025392 "$node_(17) setdest 2354 130 6.0" 
$ns at 322.29740463515293 "$node_(17) setdest 1383 879 8.0" 
$ns at 407.75051911652963 "$node_(17) setdest 1464 328 9.0" 
$ns at 492.27741744385077 "$node_(17) setdest 2610 837 19.0" 
$ns at 691.1318989512772 "$node_(17) setdest 2624 766 9.0" 
$ns at 794.3043168673227 "$node_(17) setdest 2358 155 13.0" 
$ns at 0.0 "$node_(18) setdest 2278 743 10.0" 
$ns at 90.60887333152786 "$node_(18) setdest 248 848 7.0" 
$ns at 169.07418760622136 "$node_(18) setdest 1069 129 11.0" 
$ns at 286.342241331507 "$node_(18) setdest 1360 174 7.0" 
$ns at 329.03752061963434 "$node_(18) setdest 1916 230 13.0" 
$ns at 430.93055204481965 "$node_(18) setdest 2683 70 14.0" 
$ns at 569.0380809346824 "$node_(18) setdest 969 194 19.0" 
$ns at 612.899709437628 "$node_(18) setdest 1443 74 7.0" 
$ns at 664.7958257472989 "$node_(18) setdest 1898 137 2.0" 
$ns at 712.8458202441915 "$node_(18) setdest 636 521 13.0" 
$ns at 870.4151983725083 "$node_(18) setdest 673 428 8.0" 
$ns at 0.0 "$node_(19) setdest 2796 71 15.0" 
$ns at 130.29928878173382 "$node_(19) setdest 2782 786 17.0" 
$ns at 287.5777547202938 "$node_(19) setdest 1838 872 17.0" 
$ns at 319.7859453408657 "$node_(19) setdest 580 138 4.0" 
$ns at 362.80818208862524 "$node_(19) setdest 1510 897 12.0" 
$ns at 446.66570057832155 "$node_(19) setdest 1177 398 13.0" 
$ns at 520.1238370696816 "$node_(19) setdest 2775 272 4.0" 
$ns at 585.5069882983471 "$node_(19) setdest 1080 598 14.0" 
$ns at 618.011454267143 "$node_(19) setdest 2182 631 16.0" 
$ns at 787.47911780032 "$node_(19) setdest 2489 45 2.0" 
$ns at 835.3323420557513 "$node_(19) setdest 2024 809 3.0" 
$ns at 876.67937498861 "$node_(19) setdest 1964 438 8.0" 
$ns at 0.0 "$node_(20) setdest 860 422 6.0" 
$ns at 61.863114595728945 "$node_(20) setdest 2867 105 3.0" 
$ns at 101.52583045146176 "$node_(20) setdest 2685 124 18.0" 
$ns at 300.5129757664949 "$node_(20) setdest 1790 806 14.0" 
$ns at 427.1949985834246 "$node_(20) setdest 2832 612 1.0" 
$ns at 461.79522465749426 "$node_(20) setdest 1874 755 14.0" 
$ns at 518.6816334153006 "$node_(20) setdest 2396 662 15.0" 
$ns at 627.9980532092602 "$node_(20) setdest 1727 805 19.0" 
$ns at 713.6467322421241 "$node_(20) setdest 1747 751 14.0" 
$ns at 799.9023709772702 "$node_(20) setdest 2365 969 17.0" 
$ns at 0.0 "$node_(21) setdest 2440 75 16.0" 
$ns at 180.41050706106512 "$node_(21) setdest 353 687 6.0" 
$ns at 214.15214061020436 "$node_(21) setdest 2579 2 3.0" 
$ns at 267.7863494522541 "$node_(21) setdest 2089 544 19.0" 
$ns at 345.09988804309774 "$node_(21) setdest 1443 265 5.0" 
$ns at 378.2548829959332 "$node_(21) setdest 1918 328 19.0" 
$ns at 558.8438805609869 "$node_(21) setdest 2936 449 3.0" 
$ns at 616.5153231547745 "$node_(21) setdest 2494 642 12.0" 
$ns at 722.7847982716945 "$node_(21) setdest 2163 569 5.0" 
$ns at 783.421490060951 "$node_(21) setdest 585 465 2.0" 
$ns at 831.994755477622 "$node_(21) setdest 202 792 9.0" 
$ns at 0.0 "$node_(22) setdest 259 354 6.0" 
$ns at 41.908901545704204 "$node_(22) setdest 2864 597 12.0" 
$ns at 169.26221349185911 "$node_(22) setdest 2117 210 3.0" 
$ns at 214.41908480002246 "$node_(22) setdest 2019 942 17.0" 
$ns at 342.9085926105344 "$node_(22) setdest 2031 780 17.0" 
$ns at 471.1682488172565 "$node_(22) setdest 1782 208 15.0" 
$ns at 580.4494865134817 "$node_(22) setdest 543 325 1.0" 
$ns at 612.1121073083864 "$node_(22) setdest 2618 7 7.0" 
$ns at 686.8471196592329 "$node_(22) setdest 884 130 15.0" 
$ns at 731.2120447016072 "$node_(22) setdest 1186 126 5.0" 
$ns at 780.1576888004392 "$node_(22) setdest 1281 774 7.0" 
$ns at 863.8549810174478 "$node_(22) setdest 1474 174 18.0" 
$ns at 0.0 "$node_(23) setdest 2989 348 5.0" 
$ns at 34.26333046890787 "$node_(23) setdest 522 718 13.0" 
$ns at 100.0735138335828 "$node_(23) setdest 2234 38 10.0" 
$ns at 135.91734018920025 "$node_(23) setdest 2817 985 16.0" 
$ns at 226.0914301979952 "$node_(23) setdest 999 749 8.0" 
$ns at 300.4376524683255 "$node_(23) setdest 1146 395 18.0" 
$ns at 499.8332232300536 "$node_(23) setdest 338 705 9.0" 
$ns at 615.541139774202 "$node_(23) setdest 474 509 15.0" 
$ns at 760.2390088813094 "$node_(23) setdest 648 183 8.0" 
$ns at 844.6120980132021 "$node_(23) setdest 157 171 14.0" 
$ns at 0.0 "$node_(24) setdest 1089 829 16.0" 
$ns at 169.2290605022129 "$node_(24) setdest 549 904 12.0" 
$ns at 258.32931582358225 "$node_(24) setdest 72 211 11.0" 
$ns at 358.00794892173565 "$node_(24) setdest 1807 863 3.0" 
$ns at 396.5969957516377 "$node_(24) setdest 2525 551 11.0" 
$ns at 500.6285780340052 "$node_(24) setdest 2453 883 16.0" 
$ns at 586.8180382224045 "$node_(24) setdest 1334 804 1.0" 
$ns at 619.2368906547897 "$node_(24) setdest 10 440 1.0" 
$ns at 653.8317569891623 "$node_(24) setdest 178 503 4.0" 
$ns at 710.7671899560369 "$node_(24) setdest 2760 562 7.0" 
$ns at 774.8170083503992 "$node_(24) setdest 1668 65 10.0" 
$ns at 0.0 "$node_(25) setdest 2438 2 14.0" 
$ns at 45.46004511608154 "$node_(25) setdest 2486 466 14.0" 
$ns at 107.60902749957671 "$node_(25) setdest 2417 211 1.0" 
$ns at 139.14318131843777 "$node_(25) setdest 1947 466 14.0" 
$ns at 277.4668599013339 "$node_(25) setdest 1702 924 19.0" 
$ns at 340.5870759397005 "$node_(25) setdest 1178 814 17.0" 
$ns at 442.3344924593238 "$node_(25) setdest 779 401 4.0" 
$ns at 479.4989295896656 "$node_(25) setdest 847 103 5.0" 
$ns at 519.2840524043181 "$node_(25) setdest 134 629 8.0" 
$ns at 594.1362396216898 "$node_(25) setdest 113 210 1.0" 
$ns at 627.2466337962275 "$node_(25) setdest 2001 36 9.0" 
$ns at 714.0892066702888 "$node_(25) setdest 247 477 2.0" 
$ns at 752.3061424102875 "$node_(25) setdest 2648 512 1.0" 
$ns at 785.942216853738 "$node_(25) setdest 2094 88 20.0" 
$ns at 871.4306869171596 "$node_(25) setdest 2254 791 4.0" 
$ns at 0.0 "$node_(26) setdest 2323 288 19.0" 
$ns at 127.9937723129341 "$node_(26) setdest 194 505 18.0" 
$ns at 163.28831170053633 "$node_(26) setdest 137 393 8.0" 
$ns at 268.86699856088654 "$node_(26) setdest 1288 435 4.0" 
$ns at 329.2664201481997 "$node_(26) setdest 2878 753 3.0" 
$ns at 379.82615747760786 "$node_(26) setdest 2309 793 3.0" 
$ns at 439.24967830297624 "$node_(26) setdest 1719 96 18.0" 
$ns at 502.25429594804166 "$node_(26) setdest 837 555 14.0" 
$ns at 630.2735305044462 "$node_(26) setdest 368 940 15.0" 
$ns at 758.6091455483747 "$node_(26) setdest 242 169 12.0" 
$ns at 812.4123473244086 "$node_(26) setdest 473 977 17.0" 
$ns at 0.0 "$node_(27) setdest 361 172 5.0" 
$ns at 49.17085501466519 "$node_(27) setdest 1155 627 6.0" 
$ns at 81.48045675719554 "$node_(27) setdest 189 531 15.0" 
$ns at 150.3602760657015 "$node_(27) setdest 1862 176 4.0" 
$ns at 208.010503570372 "$node_(27) setdest 626 749 5.0" 
$ns at 256.49477184593934 "$node_(27) setdest 1469 173 2.0" 
$ns at 305.87375686386434 "$node_(27) setdest 2101 34 6.0" 
$ns at 355.810846489713 "$node_(27) setdest 2311 18 13.0" 
$ns at 401.85368538263094 "$node_(27) setdest 1626 99 3.0" 
$ns at 456.56241205242895 "$node_(27) setdest 1587 913 14.0" 
$ns at 568.2617387620903 "$node_(27) setdest 588 373 15.0" 
$ns at 692.9230679832551 "$node_(27) setdest 1307 602 9.0" 
$ns at 726.1158163536926 "$node_(27) setdest 2345 686 5.0" 
$ns at 787.7807157276242 "$node_(27) setdest 2729 576 20.0" 
$ns at 0.0 "$node_(28) setdest 418 724 18.0" 
$ns at 178.15397002481413 "$node_(28) setdest 2960 666 13.0" 
$ns at 269.0419412035735 "$node_(28) setdest 861 814 5.0" 
$ns at 335.8292056423883 "$node_(28) setdest 162 211 18.0" 
$ns at 387.13170727035293 "$node_(28) setdest 96 819 7.0" 
$ns at 479.88354842558664 "$node_(28) setdest 2535 212 20.0" 
$ns at 601.5705662598957 "$node_(28) setdest 2284 221 11.0" 
$ns at 648.0268162783519 "$node_(28) setdest 1028 150 11.0" 
$ns at 708.7466833109378 "$node_(28) setdest 2039 669 15.0" 
$ns at 886.2967315765636 "$node_(28) setdest 1441 411 8.0" 
$ns at 0.0 "$node_(29) setdest 38 559 1.0" 
$ns at 32.14757205724859 "$node_(29) setdest 2377 470 4.0" 
$ns at 77.66448345316317 "$node_(29) setdest 2843 436 3.0" 
$ns at 126.9286764563067 "$node_(29) setdest 1193 272 18.0" 
$ns at 298.37723739582447 "$node_(29) setdest 985 275 12.0" 
$ns at 393.061589088171 "$node_(29) setdest 2924 492 1.0" 
$ns at 432.0072319544274 "$node_(29) setdest 1131 941 5.0" 
$ns at 466.6055567497037 "$node_(29) setdest 1830 581 2.0" 
$ns at 502.4033257047034 "$node_(29) setdest 2880 379 11.0" 
$ns at 549.114586884957 "$node_(29) setdest 2015 792 2.0" 
$ns at 591.0618043741373 "$node_(29) setdest 502 326 11.0" 
$ns at 721.2322768251929 "$node_(29) setdest 307 608 9.0" 
$ns at 773.8943919670182 "$node_(29) setdest 678 614 8.0" 
$ns at 833.1179433911318 "$node_(29) setdest 2311 230 1.0" 
$ns at 872.5730439778915 "$node_(29) setdest 58 349 6.0" 
$ns at 0.0 "$node_(30) setdest 2347 88 10.0" 
$ns at 80.35553640464018 "$node_(30) setdest 2171 518 10.0" 
$ns at 194.47802856202208 "$node_(30) setdest 2681 502 2.0" 
$ns at 227.96611673454274 "$node_(30) setdest 1033 838 12.0" 
$ns at 272.26062457569765 "$node_(30) setdest 1255 968 11.0" 
$ns at 365.42044796109764 "$node_(30) setdest 469 878 5.0" 
$ns at 413.7590866403892 "$node_(30) setdest 822 707 11.0" 
$ns at 528.769851013825 "$node_(30) setdest 1002 776 5.0" 
$ns at 563.8671677357873 "$node_(30) setdest 204 425 19.0" 
$ns at 643.3531301194743 "$node_(30) setdest 821 81 4.0" 
$ns at 706.7865001846292 "$node_(30) setdest 1077 444 17.0" 
$ns at 869.7548793404228 "$node_(30) setdest 1185 539 13.0" 
$ns at 0.0 "$node_(31) setdest 1481 651 14.0" 
$ns at 69.14908534419108 "$node_(31) setdest 1275 859 7.0" 
$ns at 164.8101035582287 "$node_(31) setdest 1985 915 19.0" 
$ns at 276.07198596064313 "$node_(31) setdest 1340 773 11.0" 
$ns at 336.85944435694813 "$node_(31) setdest 196 914 20.0" 
$ns at 467.7105576528735 "$node_(31) setdest 676 929 18.0" 
$ns at 507.5263578164267 "$node_(31) setdest 1033 554 2.0" 
$ns at 549.1629167314694 "$node_(31) setdest 1745 424 14.0" 
$ns at 601.7881606768357 "$node_(31) setdest 1964 378 18.0" 
$ns at 681.9894699756085 "$node_(31) setdest 2509 28 15.0" 
$ns at 841.1627417702657 "$node_(31) setdest 130 679 13.0" 
$ns at 0.0 "$node_(32) setdest 1769 400 11.0" 
$ns at 117.55395564672472 "$node_(32) setdest 42 204 1.0" 
$ns at 150.74436260474272 "$node_(32) setdest 1078 839 11.0" 
$ns at 195.94277755619652 "$node_(32) setdest 1291 658 9.0" 
$ns at 293.022316774755 "$node_(32) setdest 2536 388 15.0" 
$ns at 394.07962729311066 "$node_(32) setdest 438 411 2.0" 
$ns at 437.9183029541218 "$node_(32) setdest 2522 317 13.0" 
$ns at 505.2760978067686 "$node_(32) setdest 41 95 6.0" 
$ns at 568.4768349317917 "$node_(32) setdest 175 312 10.0" 
$ns at 614.690956882626 "$node_(32) setdest 481 14 3.0" 
$ns at 656.0753240329863 "$node_(32) setdest 1179 903 8.0" 
$ns at 690.5632154509997 "$node_(32) setdest 2031 540 19.0" 
$ns at 761.9955779815434 "$node_(32) setdest 1165 935 7.0" 
$ns at 810.8878387090876 "$node_(32) setdest 356 926 16.0" 
$ns at 0.0 "$node_(33) setdest 2783 142 14.0" 
$ns at 165.56312816804916 "$node_(33) setdest 1365 212 3.0" 
$ns at 223.10602711085795 "$node_(33) setdest 1262 107 18.0" 
$ns at 319.55283870265697 "$node_(33) setdest 1109 135 11.0" 
$ns at 421.1663478833566 "$node_(33) setdest 2 183 7.0" 
$ns at 518.5511784368721 "$node_(33) setdest 153 247 5.0" 
$ns at 585.1305636928666 "$node_(33) setdest 1524 152 15.0" 
$ns at 671.3413120440837 "$node_(33) setdest 2609 640 11.0" 
$ns at 809.8726625939391 "$node_(33) setdest 820 686 1.0" 
$ns at 847.2482687784094 "$node_(33) setdest 1764 965 16.0" 
$ns at 0.0 "$node_(34) setdest 2922 910 19.0" 
$ns at 159.24650164889576 "$node_(34) setdest 2980 673 14.0" 
$ns at 236.8671175404472 "$node_(34) setdest 251 614 3.0" 
$ns at 275.972362713388 "$node_(34) setdest 308 651 15.0" 
$ns at 315.91624793431373 "$node_(34) setdest 2040 915 17.0" 
$ns at 473.61925022640946 "$node_(34) setdest 996 675 10.0" 
$ns at 511.7462292724405 "$node_(34) setdest 1904 426 20.0" 
$ns at 590.1628724624475 "$node_(34) setdest 822 364 16.0" 
$ns at 698.4347069022181 "$node_(34) setdest 1364 220 8.0" 
$ns at 782.4549112695045 "$node_(34) setdest 2942 551 6.0" 
$ns at 818.1221326988966 "$node_(34) setdest 875 159 20.0" 
$ns at 882.5748231107116 "$node_(34) setdest 2678 257 2.0" 
$ns at 0.0 "$node_(35) setdest 2669 365 15.0" 
$ns at 55.41884235150432 "$node_(35) setdest 2438 687 6.0" 
$ns at 110.37567748150124 "$node_(35) setdest 1488 909 7.0" 
$ns at 205.0313525688863 "$node_(35) setdest 1700 924 3.0" 
$ns at 244.63441202666718 "$node_(35) setdest 2984 995 11.0" 
$ns at 334.52820102093625 "$node_(35) setdest 732 249 20.0" 
$ns at 455.11948637119326 "$node_(35) setdest 2375 208 8.0" 
$ns at 558.4602373687644 "$node_(35) setdest 504 262 2.0" 
$ns at 606.2850871484318 "$node_(35) setdest 653 616 5.0" 
$ns at 642.5826010290717 "$node_(35) setdest 2951 234 20.0" 
$ns at 729.5471495820087 "$node_(35) setdest 1391 785 18.0" 
$ns at 804.6028405674216 "$node_(35) setdest 1541 353 7.0" 
$ns at 855.3487153117977 "$node_(35) setdest 988 997 11.0" 
$ns at 0.0 "$node_(36) setdest 821 808 14.0" 
$ns at 106.4725540568754 "$node_(36) setdest 873 236 9.0" 
$ns at 226.0752954980502 "$node_(36) setdest 2369 868 9.0" 
$ns at 260.64497038749613 "$node_(36) setdest 2009 723 1.0" 
$ns at 290.76743311998933 "$node_(36) setdest 356 399 10.0" 
$ns at 360.01317773326093 "$node_(36) setdest 2737 78 3.0" 
$ns at 395.94730696426785 "$node_(36) setdest 627 485 4.0" 
$ns at 430.3458700896031 "$node_(36) setdest 772 381 18.0" 
$ns at 502.2948203115661 "$node_(36) setdest 3 73 2.0" 
$ns at 533.2273434322362 "$node_(36) setdest 916 704 15.0" 
$ns at 575.9046609917539 "$node_(36) setdest 1230 836 5.0" 
$ns at 638.1772596402506 "$node_(36) setdest 788 902 9.0" 
$ns at 716.2400552085271 "$node_(36) setdest 1756 664 20.0" 
$ns at 832.0455240224771 "$node_(36) setdest 2637 724 6.0" 
$ns at 0.0 "$node_(37) setdest 280 463 14.0" 
$ns at 51.36031113090418 "$node_(37) setdest 1038 537 7.0" 
$ns at 125.52881531221315 "$node_(37) setdest 2739 191 1.0" 
$ns at 159.21325425232493 "$node_(37) setdest 2041 213 12.0" 
$ns at 241.1669285538427 "$node_(37) setdest 1190 302 7.0" 
$ns at 298.490588463271 "$node_(37) setdest 1068 989 5.0" 
$ns at 347.4925920957233 "$node_(37) setdest 1746 29 20.0" 
$ns at 556.5962872639744 "$node_(37) setdest 633 341 8.0" 
$ns at 589.4386201394158 "$node_(37) setdest 1522 178 1.0" 
$ns at 625.9717007622266 "$node_(37) setdest 2677 179 17.0" 
$ns at 723.6718252127833 "$node_(37) setdest 1253 359 19.0" 
$ns at 776.1203455515782 "$node_(37) setdest 1086 907 4.0" 
$ns at 824.9345042029977 "$node_(37) setdest 39 831 4.0" 
$ns at 889.9550400354891 "$node_(37) setdest 702 161 4.0" 
$ns at 0.0 "$node_(38) setdest 386 386 3.0" 
$ns at 35.367669172743824 "$node_(38) setdest 2876 261 17.0" 
$ns at 107.66625900679384 "$node_(38) setdest 1478 949 2.0" 
$ns at 138.9941337627631 "$node_(38) setdest 384 686 16.0" 
$ns at 318.87921330320523 "$node_(38) setdest 1368 821 11.0" 
$ns at 436.2810522945716 "$node_(38) setdest 1255 125 7.0" 
$ns at 512.6718705748962 "$node_(38) setdest 2527 730 17.0" 
$ns at 641.0634061986576 "$node_(38) setdest 2824 900 14.0" 
$ns at 738.0675428941496 "$node_(38) setdest 915 140 16.0" 
$ns at 0.0 "$node_(39) setdest 70 808 3.0" 
$ns at 43.258265569667124 "$node_(39) setdest 2530 460 2.0" 
$ns at 87.43564949578274 "$node_(39) setdest 2038 696 12.0" 
$ns at 150.16447846465542 "$node_(39) setdest 1107 111 13.0" 
$ns at 276.24044153489524 "$node_(39) setdest 921 309 8.0" 
$ns at 355.7618195616054 "$node_(39) setdest 1397 608 1.0" 
$ns at 387.0450625029414 "$node_(39) setdest 1091 207 9.0" 
$ns at 466.0399865479394 "$node_(39) setdest 2221 84 4.0" 
$ns at 511.06529605225523 "$node_(39) setdest 153 825 20.0" 
$ns at 561.2428275403402 "$node_(39) setdest 1228 944 7.0" 
$ns at 636.6224479568104 "$node_(39) setdest 825 943 11.0" 
$ns at 677.6604867839952 "$node_(39) setdest 29 558 12.0" 
$ns at 747.9457631629102 "$node_(39) setdest 1196 149 18.0" 
$ns at 858.5120224564952 "$node_(39) setdest 1163 180 19.0" 
$ns at 0.0 "$node_(40) setdest 1683 73 6.0" 
$ns at 68.92562190952441 "$node_(40) setdest 1059 516 19.0" 
$ns at 226.1699705492221 "$node_(40) setdest 1738 457 4.0" 
$ns at 270.4903952113943 "$node_(40) setdest 1936 618 10.0" 
$ns at 384.5279455168881 "$node_(40) setdest 2111 351 15.0" 
$ns at 425.9111485052461 "$node_(40) setdest 325 26 9.0" 
$ns at 497.4555940618685 "$node_(40) setdest 2239 996 13.0" 
$ns at 574.6016519219465 "$node_(40) setdest 645 334 15.0" 
$ns at 658.2022573706631 "$node_(40) setdest 1058 188 7.0" 
$ns at 700.7945272338934 "$node_(40) setdest 1017 615 6.0" 
$ns at 757.3517417173239 "$node_(40) setdest 1294 170 7.0" 
$ns at 802.9965122797906 "$node_(40) setdest 1245 367 17.0" 
$ns at 0.0 "$node_(41) setdest 65 369 9.0" 
$ns at 62.549118703697914 "$node_(41) setdest 2660 913 18.0" 
$ns at 126.19319505375616 "$node_(41) setdest 318 509 12.0" 
$ns at 221.08297391281747 "$node_(41) setdest 245 437 17.0" 
$ns at 405.7008131594705 "$node_(41) setdest 442 912 15.0" 
$ns at 551.6013806265635 "$node_(41) setdest 1235 63 1.0" 
$ns at 585.4945837594815 "$node_(41) setdest 1089 41 14.0" 
$ns at 624.8470994319606 "$node_(41) setdest 126 678 1.0" 
$ns at 663.0750754976115 "$node_(41) setdest 35 572 13.0" 
$ns at 747.6605577616333 "$node_(41) setdest 2766 402 19.0" 
$ns at 0.0 "$node_(42) setdest 619 559 5.0" 
$ns at 41.355477069694004 "$node_(42) setdest 977 893 17.0" 
$ns at 127.2532609480434 "$node_(42) setdest 85 490 13.0" 
$ns at 251.84988216848683 "$node_(42) setdest 873 914 15.0" 
$ns at 400.63979484083166 "$node_(42) setdest 2872 276 14.0" 
$ns at 479.37470053494536 "$node_(42) setdest 1834 826 16.0" 
$ns at 622.1575246396073 "$node_(42) setdest 2673 490 13.0" 
$ns at 659.5297397779459 "$node_(42) setdest 786 950 11.0" 
$ns at 759.1966977838918 "$node_(42) setdest 813 384 8.0" 
$ns at 796.5724423606937 "$node_(42) setdest 1250 956 5.0" 
$ns at 860.867549953712 "$node_(42) setdest 258 514 18.0" 
$ns at 0.0 "$node_(43) setdest 1329 718 19.0" 
$ns at 95.54156173338843 "$node_(43) setdest 2310 996 14.0" 
$ns at 209.50554035918563 "$node_(43) setdest 1565 308 7.0" 
$ns at 242.907459198448 "$node_(43) setdest 805 708 7.0" 
$ns at 323.03330084103055 "$node_(43) setdest 2363 44 8.0" 
$ns at 374.0131992072191 "$node_(43) setdest 2362 992 13.0" 
$ns at 512.9656561430947 "$node_(43) setdest 399 787 2.0" 
$ns at 543.5267906384106 "$node_(43) setdest 1 645 11.0" 
$ns at 630.5695341498501 "$node_(43) setdest 203 896 13.0" 
$ns at 690.5286453190519 "$node_(43) setdest 2177 258 2.0" 
$ns at 733.6818045620538 "$node_(43) setdest 859 527 9.0" 
$ns at 769.6314920880033 "$node_(43) setdest 1060 202 9.0" 
$ns at 801.7695196534952 "$node_(43) setdest 2488 191 6.0" 
$ns at 859.1627650869987 "$node_(43) setdest 1585 814 18.0" 
$ns at 899.0579332605012 "$node_(43) setdest 2960 765 2.0" 
$ns at 0.0 "$node_(44) setdest 2622 574 14.0" 
$ns at 107.62376826302813 "$node_(44) setdest 1023 357 5.0" 
$ns at 159.78673190980348 "$node_(44) setdest 2289 341 5.0" 
$ns at 196.92928347959904 "$node_(44) setdest 1759 728 5.0" 
$ns at 273.62854238661185 "$node_(44) setdest 1238 933 20.0" 
$ns at 419.8683278577988 "$node_(44) setdest 87 171 11.0" 
$ns at 505.4222977831089 "$node_(44) setdest 2464 606 8.0" 
$ns at 561.6239961163534 "$node_(44) setdest 2706 45 17.0" 
$ns at 602.7920272563622 "$node_(44) setdest 947 239 19.0" 
$ns at 811.467995966669 "$node_(44) setdest 2702 371 14.0" 
$ns at 892.7299656801197 "$node_(44) setdest 2188 270 5.0" 
$ns at 0.0 "$node_(45) setdest 1712 179 2.0" 
$ns at 43.61734790749513 "$node_(45) setdest 1441 684 19.0" 
$ns at 75.4332453942572 "$node_(45) setdest 1368 528 13.0" 
$ns at 149.73527939482454 "$node_(45) setdest 213 605 9.0" 
$ns at 232.96161276135862 "$node_(45) setdest 425 371 4.0" 
$ns at 267.07653300618006 "$node_(45) setdest 2321 292 10.0" 
$ns at 331.0254172521803 "$node_(45) setdest 1765 695 9.0" 
$ns at 414.5834434828702 "$node_(45) setdest 1583 594 8.0" 
$ns at 480.02376773113093 "$node_(45) setdest 1227 612 13.0" 
$ns at 552.2939639038307 "$node_(45) setdest 943 154 14.0" 
$ns at 616.3970724797204 "$node_(45) setdest 2915 322 3.0" 
$ns at 676.1388351083804 "$node_(45) setdest 1583 930 8.0" 
$ns at 765.3148951137914 "$node_(45) setdest 1447 131 5.0" 
$ns at 799.5097263944609 "$node_(45) setdest 352 814 17.0" 
$ns at 0.0 "$node_(46) setdest 1314 942 10.0" 
$ns at 31.434668084484635 "$node_(46) setdest 1535 414 9.0" 
$ns at 84.67588281458393 "$node_(46) setdest 281 901 6.0" 
$ns at 130.43852249958456 "$node_(46) setdest 1811 297 16.0" 
$ns at 172.5398254673084 "$node_(46) setdest 2525 124 1.0" 
$ns at 205.33128764094403 "$node_(46) setdest 927 237 10.0" 
$ns at 283.26673173731814 "$node_(46) setdest 1932 669 2.0" 
$ns at 315.85408641723944 "$node_(46) setdest 1413 281 20.0" 
$ns at 374.8720244212339 "$node_(46) setdest 2741 201 17.0" 
$ns at 425.57199439977546 "$node_(46) setdest 391 667 10.0" 
$ns at 476.9899188829225 "$node_(46) setdest 1469 1 15.0" 
$ns at 642.6725210006358 "$node_(46) setdest 1287 914 18.0" 
$ns at 843.5842731750762 "$node_(46) setdest 1805 261 18.0" 
$ns at 0.0 "$node_(47) setdest 2009 621 6.0" 
$ns at 56.25683523458091 "$node_(47) setdest 2893 845 6.0" 
$ns at 96.01537348239023 "$node_(47) setdest 892 778 3.0" 
$ns at 154.52303626301398 "$node_(47) setdest 1203 914 15.0" 
$ns at 275.1106825375001 "$node_(47) setdest 2473 645 17.0" 
$ns at 446.00318077365444 "$node_(47) setdest 1918 127 1.0" 
$ns at 481.6486196629363 "$node_(47) setdest 2905 494 9.0" 
$ns at 512.0545896621865 "$node_(47) setdest 515 320 19.0" 
$ns at 728.2365372578588 "$node_(47) setdest 1569 770 8.0" 
$ns at 799.7150092010941 "$node_(47) setdest 979 844 6.0" 
$ns at 855.0665178694821 "$node_(47) setdest 2190 470 12.0" 
$ns at 0.0 "$node_(48) setdest 2836 995 19.0" 
$ns at 60.65003323682923 "$node_(48) setdest 516 781 5.0" 
$ns at 117.83533887158589 "$node_(48) setdest 935 198 9.0" 
$ns at 201.57480736159653 "$node_(48) setdest 1369 302 11.0" 
$ns at 272.2003046077573 "$node_(48) setdest 659 885 13.0" 
$ns at 407.8549993297467 "$node_(48) setdest 632 368 4.0" 
$ns at 458.22119179479864 "$node_(48) setdest 1006 235 3.0" 
$ns at 495.00014440216137 "$node_(48) setdest 469 310 1.0" 
$ns at 527.5487095390973 "$node_(48) setdest 722 203 6.0" 
$ns at 592.5647053199493 "$node_(48) setdest 850 675 11.0" 
$ns at 727.7026694509974 "$node_(48) setdest 2413 513 1.0" 
$ns at 765.5515817337932 "$node_(48) setdest 1174 724 9.0" 
$ns at 859.0894313744966 "$node_(48) setdest 2327 544 3.0" 
$ns at 897.2712411084692 "$node_(48) setdest 1568 748 20.0" 
$ns at 0.0 "$node_(49) setdest 2237 281 10.0" 
$ns at 128.07503571366945 "$node_(49) setdest 152 13 12.0" 
$ns at 221.29577666724057 "$node_(49) setdest 2610 763 11.0" 
$ns at 259.5166915631297 "$node_(49) setdest 1340 371 1.0" 
$ns at 292.5018536908906 "$node_(49) setdest 2991 688 3.0" 
$ns at 351.7967227638403 "$node_(49) setdest 2983 856 1.0" 
$ns at 381.834635610438 "$node_(49) setdest 292 128 12.0" 
$ns at 460.8669786877361 "$node_(49) setdest 2909 798 5.0" 
$ns at 499.53608262247127 "$node_(49) setdest 411 499 1.0" 
$ns at 534.0181216628109 "$node_(49) setdest 172 265 1.0" 
$ns at 568.3784490645849 "$node_(49) setdest 2380 239 8.0" 
$ns at 664.6352555942383 "$node_(49) setdest 73 885 17.0" 
$ns at 724.1086386507936 "$node_(49) setdest 1955 843 10.0" 
$ns at 851.5230829878146 "$node_(49) setdest 2750 343 10.0" 
$ns at 0.0 "$node_(50) setdest 2347 214 16.0" 
$ns at 112.38830501580762 "$node_(50) setdest 904 109 8.0" 
$ns at 206.01478880933524 "$node_(50) setdest 2524 470 13.0" 
$ns at 269.27901245151656 "$node_(50) setdest 971 193 1.0" 
$ns at 307.3861451696273 "$node_(50) setdest 264 655 16.0" 
$ns at 473.74244194355697 "$node_(50) setdest 1792 986 17.0" 
$ns at 594.0792758138031 "$node_(50) setdest 2894 34 3.0" 
$ns at 644.2210155273189 "$node_(50) setdest 592 472 12.0" 
$ns at 745.0579241279548 "$node_(50) setdest 404 870 6.0" 
$ns at 809.9979648633442 "$node_(50) setdest 837 383 10.0" 
$ns at 858.6748525218806 "$node_(50) setdest 360 895 11.0" 
$ns at 166.9576289686911 "$node_(51) setdest 1106 937 16.0" 
$ns at 267.4877050365468 "$node_(51) setdest 1417 513 13.0" 
$ns at 315.6363380952807 "$node_(51) setdest 2330 649 10.0" 
$ns at 445.4081773437721 "$node_(51) setdest 2081 86 8.0" 
$ns at 507.21326564423174 "$node_(51) setdest 1771 910 1.0" 
$ns at 542.8075202492805 "$node_(51) setdest 1464 332 6.0" 
$ns at 593.3937703563078 "$node_(51) setdest 2607 200 10.0" 
$ns at 675.3392424182767 "$node_(51) setdest 2310 203 12.0" 
$ns at 811.8059483336225 "$node_(51) setdest 1753 786 14.0" 
$ns at 311.55300964834714 "$node_(52) setdest 2077 687 4.0" 
$ns at 381.0595773999962 "$node_(52) setdest 743 281 11.0" 
$ns at 430.79492346051455 "$node_(52) setdest 1311 119 1.0" 
$ns at 469.47110809031307 "$node_(52) setdest 2767 554 5.0" 
$ns at 507.3598091746473 "$node_(52) setdest 1577 114 6.0" 
$ns at 596.3927019357592 "$node_(52) setdest 1367 967 15.0" 
$ns at 679.2622960822572 "$node_(52) setdest 92 119 11.0" 
$ns at 785.4361562491024 "$node_(52) setdest 1992 20 15.0" 
$ns at 885.7616223687319 "$node_(52) setdest 557 691 16.0" 
$ns at 361.43936557299776 "$node_(53) setdest 1128 573 17.0" 
$ns at 461.3920864267715 "$node_(53) setdest 1865 832 18.0" 
$ns at 508.9661341642867 "$node_(53) setdest 1127 407 16.0" 
$ns at 663.8078555698128 "$node_(53) setdest 1967 878 4.0" 
$ns at 726.7006330714576 "$node_(53) setdest 2665 384 11.0" 
$ns at 809.7568062017206 "$node_(53) setdest 2151 301 7.0" 
$ns at 851.5533725009311 "$node_(53) setdest 2221 648 12.0" 
$ns at 211.69876602502254 "$node_(54) setdest 251 40 9.0" 
$ns at 262.73512629461936 "$node_(54) setdest 1260 384 12.0" 
$ns at 400.54501084726576 "$node_(54) setdest 1466 659 3.0" 
$ns at 437.76262232476404 "$node_(54) setdest 698 307 17.0" 
$ns at 628.4622261380488 "$node_(54) setdest 2878 91 9.0" 
$ns at 684.7371887016953 "$node_(54) setdest 1344 27 2.0" 
$ns at 725.073444598593 "$node_(54) setdest 1204 84 19.0" 
$ns at 811.7610998414177 "$node_(54) setdest 891 504 12.0" 
$ns at 899.2514947476939 "$node_(54) setdest 1792 333 6.0" 
$ns at 175.21994363416349 "$node_(55) setdest 1484 122 6.0" 
$ns at 221.7900205498399 "$node_(55) setdest 746 538 19.0" 
$ns at 440.5399251862498 "$node_(55) setdest 1898 147 9.0" 
$ns at 537.1583542835871 "$node_(55) setdest 461 198 11.0" 
$ns at 604.7247090870242 "$node_(55) setdest 856 571 17.0" 
$ns at 775.6759404982718 "$node_(55) setdest 2633 942 16.0" 
$ns at 834.8254104104526 "$node_(55) setdest 630 276 3.0" 
$ns at 871.1142376347833 "$node_(55) setdest 369 655 1.0" 
$ns at 245.1471854698349 "$node_(56) setdest 2783 698 4.0" 
$ns at 284.6214480595362 "$node_(56) setdest 1800 228 2.0" 
$ns at 331.6728867904352 "$node_(56) setdest 1038 56 2.0" 
$ns at 370.0905757613739 "$node_(56) setdest 2945 696 13.0" 
$ns at 498.0928536596924 "$node_(56) setdest 74 904 1.0" 
$ns at 529.5637266647375 "$node_(56) setdest 587 892 15.0" 
$ns at 658.1598276572062 "$node_(56) setdest 2511 631 14.0" 
$ns at 728.8434621553049 "$node_(56) setdest 2287 284 12.0" 
$ns at 763.1573054905292 "$node_(56) setdest 681 77 14.0" 
$ns at 862.690319430772 "$node_(56) setdest 99 527 17.0" 
$ns at 217.1461232733586 "$node_(57) setdest 126 225 9.0" 
$ns at 329.16763849438655 "$node_(57) setdest 182 199 2.0" 
$ns at 377.54493127140955 "$node_(57) setdest 428 979 19.0" 
$ns at 476.73492400374204 "$node_(57) setdest 2528 157 14.0" 
$ns at 546.2734459504653 "$node_(57) setdest 784 521 15.0" 
$ns at 692.3998465594384 "$node_(57) setdest 1254 60 16.0" 
$ns at 849.6488436529132 "$node_(57) setdest 114 463 10.0" 
$ns at 165.0799521298748 "$node_(58) setdest 2725 125 6.0" 
$ns at 254.41723220021834 "$node_(58) setdest 2140 242 5.0" 
$ns at 288.53949224496205 "$node_(58) setdest 1893 389 5.0" 
$ns at 357.21203954960004 "$node_(58) setdest 1773 504 3.0" 
$ns at 392.4031780494299 "$node_(58) setdest 2016 362 12.0" 
$ns at 514.9940324292802 "$node_(58) setdest 1660 342 8.0" 
$ns at 595.627838627935 "$node_(58) setdest 778 515 8.0" 
$ns at 687.2050458583968 "$node_(58) setdest 405 395 2.0" 
$ns at 731.5310206124436 "$node_(58) setdest 2257 254 16.0" 
$ns at 172.5967298396634 "$node_(59) setdest 2092 62 18.0" 
$ns at 265.52154548179175 "$node_(59) setdest 1601 516 8.0" 
$ns at 303.7859582934309 "$node_(59) setdest 72 322 5.0" 
$ns at 364.22094597925985 "$node_(59) setdest 5 582 1.0" 
$ns at 395.7655345117645 "$node_(59) setdest 1194 117 1.0" 
$ns at 428.17457440707136 "$node_(59) setdest 305 699 6.0" 
$ns at 461.1985433668227 "$node_(59) setdest 148 517 2.0" 
$ns at 497.22090013906836 "$node_(59) setdest 2845 1 10.0" 
$ns at 551.8481036449218 "$node_(59) setdest 2005 628 5.0" 
$ns at 587.7012391418642 "$node_(59) setdest 400 182 10.0" 
$ns at 692.6984121469163 "$node_(59) setdest 1486 175 10.0" 
$ns at 771.4649902846919 "$node_(59) setdest 1444 891 5.0" 
$ns at 836.347830887305 "$node_(59) setdest 178 512 20.0" 
$ns at 198.61832472261813 "$node_(60) setdest 1655 672 9.0" 
$ns at 241.69053455123097 "$node_(60) setdest 1243 738 8.0" 
$ns at 289.1683154580908 "$node_(60) setdest 18 960 18.0" 
$ns at 427.88833337820785 "$node_(60) setdest 645 660 10.0" 
$ns at 523.7882545288896 "$node_(60) setdest 2703 762 13.0" 
$ns at 594.4716660042242 "$node_(60) setdest 1983 695 16.0" 
$ns at 669.6124451996525 "$node_(60) setdest 2641 655 10.0" 
$ns at 773.3012256990862 "$node_(60) setdest 1314 888 5.0" 
$ns at 822.4033080383022 "$node_(60) setdest 1267 230 7.0" 
$ns at 855.2496995173609 "$node_(60) setdest 1031 83 8.0" 
$ns at 180.90600294450894 "$node_(61) setdest 847 557 12.0" 
$ns at 316.76908016684786 "$node_(61) setdest 223 786 13.0" 
$ns at 411.55744090490106 "$node_(61) setdest 835 980 16.0" 
$ns at 559.5079434723962 "$node_(61) setdest 1869 433 11.0" 
$ns at 601.6422177729676 "$node_(61) setdest 2757 525 18.0" 
$ns at 776.1483072530411 "$node_(61) setdest 831 317 15.0" 
$ns at 814.0554864323354 "$node_(61) setdest 9 1 12.0" 
$ns at 858.7731230976859 "$node_(61) setdest 1500 581 13.0" 
$ns at 217.8234533740664 "$node_(62) setdest 592 441 17.0" 
$ns at 317.1920582785792 "$node_(62) setdest 1809 940 10.0" 
$ns at 430.90994659452656 "$node_(62) setdest 10 134 14.0" 
$ns at 595.4421591041158 "$node_(62) setdest 1900 472 1.0" 
$ns at 629.6407236495166 "$node_(62) setdest 2725 638 1.0" 
$ns at 666.541760269572 "$node_(62) setdest 1072 230 3.0" 
$ns at 724.1046366520208 "$node_(62) setdest 2678 482 5.0" 
$ns at 772.0059140467172 "$node_(62) setdest 1395 55 17.0" 
$ns at 195.66983464738595 "$node_(63) setdest 2223 177 1.0" 
$ns at 228.55632094908145 "$node_(63) setdest 2244 683 20.0" 
$ns at 386.67281770517644 "$node_(63) setdest 2654 101 13.0" 
$ns at 542.2463691681539 "$node_(63) setdest 2754 908 19.0" 
$ns at 637.4978808033006 "$node_(63) setdest 614 330 1.0" 
$ns at 668.4685397731994 "$node_(63) setdest 886 582 20.0" 
$ns at 769.6018749927779 "$node_(63) setdest 411 912 15.0" 
$ns at 812.9531786222511 "$node_(63) setdest 62 930 12.0" 
$ns at 866.2956431786957 "$node_(63) setdest 58 866 19.0" 
$ns at 203.40647580546008 "$node_(64) setdest 1899 421 2.0" 
$ns at 244.39964965335474 "$node_(64) setdest 2746 948 7.0" 
$ns at 280.27025806202374 "$node_(64) setdest 2787 259 11.0" 
$ns at 366.6360159842286 "$node_(64) setdest 2909 237 9.0" 
$ns at 465.6170861712968 "$node_(64) setdest 2129 544 18.0" 
$ns at 641.5317033717182 "$node_(64) setdest 2279 765 7.0" 
$ns at 719.3383671870562 "$node_(64) setdest 861 798 5.0" 
$ns at 772.7147779839629 "$node_(64) setdest 2774 10 14.0" 
$ns at 817.2837359580536 "$node_(64) setdest 1138 930 6.0" 
$ns at 892.5859726494368 "$node_(64) setdest 1395 872 18.0" 
$ns at 213.1720008551983 "$node_(65) setdest 2679 268 1.0" 
$ns at 247.58148965426128 "$node_(65) setdest 2270 190 10.0" 
$ns at 352.40303014757586 "$node_(65) setdest 1763 358 6.0" 
$ns at 439.6702612961027 "$node_(65) setdest 241 5 14.0" 
$ns at 555.063279023146 "$node_(65) setdest 1628 549 5.0" 
$ns at 626.137609522855 "$node_(65) setdest 2058 579 5.0" 
$ns at 688.66757948899 "$node_(65) setdest 1264 732 20.0" 
$ns at 745.9593136074046 "$node_(65) setdest 809 780 2.0" 
$ns at 779.1706363154897 "$node_(65) setdest 663 759 15.0" 
$ns at 249.03445739122907 "$node_(66) setdest 623 523 4.0" 
$ns at 290.08007518799474 "$node_(66) setdest 942 655 19.0" 
$ns at 387.71001257277055 "$node_(66) setdest 109 15 16.0" 
$ns at 477.8840533154762 "$node_(66) setdest 12 622 15.0" 
$ns at 548.3730167724849 "$node_(66) setdest 1209 943 14.0" 
$ns at 632.6065096262079 "$node_(66) setdest 395 273 10.0" 
$ns at 664.2477403820297 "$node_(66) setdest 2968 564 12.0" 
$ns at 696.6727724738323 "$node_(66) setdest 726 97 8.0" 
$ns at 790.9440953800347 "$node_(66) setdest 2901 759 1.0" 
$ns at 823.885349403328 "$node_(66) setdest 2485 512 14.0" 
$ns at 855.1391229179291 "$node_(66) setdest 913 831 3.0" 
$ns at 226.38341154496823 "$node_(67) setdest 1531 291 1.0" 
$ns at 264.45648038288977 "$node_(67) setdest 2429 133 1.0" 
$ns at 301.9868924336519 "$node_(67) setdest 1167 639 5.0" 
$ns at 373.5445327434545 "$node_(67) setdest 2757 917 3.0" 
$ns at 420.4426618808186 "$node_(67) setdest 1232 562 12.0" 
$ns at 543.286178026541 "$node_(67) setdest 633 532 3.0" 
$ns at 594.2440411810969 "$node_(67) setdest 1341 659 15.0" 
$ns at 650.1223755236379 "$node_(67) setdest 1604 672 12.0" 
$ns at 704.7403258276212 "$node_(67) setdest 1846 699 19.0" 
$ns at 814.9686030361152 "$node_(67) setdest 635 701 5.0" 
$ns at 890.5864980048111 "$node_(67) setdest 2905 208 11.0" 
$ns at 237.75996342548848 "$node_(68) setdest 229 158 18.0" 
$ns at 412.3236597689321 "$node_(68) setdest 1083 979 16.0" 
$ns at 514.416320767675 "$node_(68) setdest 889 901 2.0" 
$ns at 559.8819028434187 "$node_(68) setdest 1791 237 9.0" 
$ns at 668.9262640736924 "$node_(68) setdest 717 675 1.0" 
$ns at 701.3371258477772 "$node_(68) setdest 226 326 10.0" 
$ns at 749.3009739330677 "$node_(68) setdest 547 215 17.0" 
$ns at 834.3928003393814 "$node_(68) setdest 1330 222 13.0" 
$ns at 880.0014234162608 "$node_(68) setdest 969 278 15.0" 
$ns at 168.57313053324515 "$node_(69) setdest 422 156 10.0" 
$ns at 281.76379371378334 "$node_(69) setdest 2463 457 16.0" 
$ns at 384.97176948672785 "$node_(69) setdest 1651 498 20.0" 
$ns at 457.1769149552039 "$node_(69) setdest 559 725 14.0" 
$ns at 496.5607782274199 "$node_(69) setdest 2941 262 8.0" 
$ns at 595.6338715669403 "$node_(69) setdest 1832 885 1.0" 
$ns at 630.5838746480142 "$node_(69) setdest 231 862 16.0" 
$ns at 810.6887086708628 "$node_(69) setdest 2044 722 19.0" 
$ns at 867.2489301039648 "$node_(69) setdest 1892 674 7.0" 
$ns at 181.98604110786647 "$node_(70) setdest 2479 601 3.0" 
$ns at 238.01693848133147 "$node_(70) setdest 1610 860 2.0" 
$ns at 280.08148448888375 "$node_(70) setdest 966 577 4.0" 
$ns at 311.41276039003105 "$node_(70) setdest 1650 403 5.0" 
$ns at 368.5482001479668 "$node_(70) setdest 2564 827 20.0" 
$ns at 408.94947224075617 "$node_(70) setdest 466 165 14.0" 
$ns at 517.3550724647336 "$node_(70) setdest 1308 896 8.0" 
$ns at 594.1723859523698 "$node_(70) setdest 2742 524 19.0" 
$ns at 744.526377602074 "$node_(70) setdest 1751 17 4.0" 
$ns at 787.5693626539007 "$node_(70) setdest 1941 258 14.0" 
$ns at 850.0787315634493 "$node_(70) setdest 2983 648 19.0" 
$ns at 187.02264342309695 "$node_(71) setdest 1366 690 13.0" 
$ns at 327.482953615145 "$node_(71) setdest 2775 524 18.0" 
$ns at 378.42123720899565 "$node_(71) setdest 2121 889 19.0" 
$ns at 434.14263711738704 "$node_(71) setdest 903 905 20.0" 
$ns at 505.84005196364285 "$node_(71) setdest 2508 537 1.0" 
$ns at 539.2827191252757 "$node_(71) setdest 2970 700 14.0" 
$ns at 689.0745572528217 "$node_(71) setdest 1172 192 5.0" 
$ns at 723.6919716057066 "$node_(71) setdest 2856 338 9.0" 
$ns at 815.5734764708559 "$node_(71) setdest 2964 446 5.0" 
$ns at 894.8071832979196 "$node_(71) setdest 1481 780 15.0" 
$ns at 244.2361289730663 "$node_(72) setdest 1275 710 14.0" 
$ns at 322.37304668057607 "$node_(72) setdest 2556 388 17.0" 
$ns at 425.33164153476605 "$node_(72) setdest 2060 89 20.0" 
$ns at 528.4102259367203 "$node_(72) setdest 82 453 5.0" 
$ns at 599.6091887537763 "$node_(72) setdest 258 856 12.0" 
$ns at 641.3766987524593 "$node_(72) setdest 1589 905 11.0" 
$ns at 770.1008589957213 "$node_(72) setdest 2169 537 18.0" 
$ns at 816.3624932540833 "$node_(72) setdest 870 889 1.0" 
$ns at 846.5252885407192 "$node_(72) setdest 2038 252 13.0" 
$ns at 897.1069279592857 "$node_(72) setdest 2503 846 6.0" 
$ns at 174.19546749435534 "$node_(73) setdest 240 387 16.0" 
$ns at 242.14530771645738 "$node_(73) setdest 765 708 19.0" 
$ns at 298.64412048612667 "$node_(73) setdest 1753 322 8.0" 
$ns at 387.05647993432825 "$node_(73) setdest 331 281 6.0" 
$ns at 424.6039501234598 "$node_(73) setdest 1828 529 1.0" 
$ns at 461.01799690776727 "$node_(73) setdest 663 671 18.0" 
$ns at 621.2003876235641 "$node_(73) setdest 1830 553 5.0" 
$ns at 686.8976705784959 "$node_(73) setdest 2053 626 5.0" 
$ns at 759.7940979105247 "$node_(73) setdest 547 420 6.0" 
$ns at 843.5977118127922 "$node_(73) setdest 2699 215 11.0" 
$ns at 170.8397101063706 "$node_(74) setdest 1397 916 10.0" 
$ns at 213.5426102396159 "$node_(74) setdest 760 813 17.0" 
$ns at 349.65415753640144 "$node_(74) setdest 1346 625 16.0" 
$ns at 478.11410759864816 "$node_(74) setdest 1521 700 3.0" 
$ns at 509.5104652598511 "$node_(74) setdest 128 27 14.0" 
$ns at 663.8953682523612 "$node_(74) setdest 1013 379 16.0" 
$ns at 694.1282621889533 "$node_(74) setdest 953 783 16.0" 
$ns at 751.5185600160203 "$node_(74) setdest 1046 360 14.0" 
$ns at 835.4509487176924 "$node_(74) setdest 2094 608 5.0" 
$ns at 867.9504860583374 "$node_(74) setdest 386 671 13.0" 
$ns at 390.18978281075675 "$node_(75) setdest 1246 350 1.0" 
$ns at 430.0343283630535 "$node_(75) setdest 2569 710 2.0" 
$ns at 469.0271802370426 "$node_(75) setdest 124 203 12.0" 
$ns at 530.8726935525705 "$node_(75) setdest 2370 800 8.0" 
$ns at 626.3151809902154 "$node_(75) setdest 1193 834 13.0" 
$ns at 762.4644618217886 "$node_(75) setdest 1005 664 3.0" 
$ns at 803.5966708911074 "$node_(75) setdest 1142 887 1.0" 
$ns at 838.0414953271127 "$node_(75) setdest 11 718 3.0" 
$ns at 885.2667046065469 "$node_(75) setdest 2356 705 19.0" 
$ns at 426.2761542596186 "$node_(76) setdest 1657 998 18.0" 
$ns at 489.82901505202733 "$node_(76) setdest 2740 71 19.0" 
$ns at 609.5683662960877 "$node_(76) setdest 483 956 6.0" 
$ns at 688.9892777703856 "$node_(76) setdest 2422 473 19.0" 
$ns at 871.475484152461 "$node_(76) setdest 1019 660 14.0" 
$ns at 330.7522946348671 "$node_(77) setdest 2104 328 14.0" 
$ns at 440.7979258734972 "$node_(77) setdest 995 355 12.0" 
$ns at 550.8330256928166 "$node_(77) setdest 772 308 3.0" 
$ns at 582.333083758696 "$node_(77) setdest 2466 398 13.0" 
$ns at 698.3749231488673 "$node_(77) setdest 664 633 15.0" 
$ns at 802.4159169810631 "$node_(77) setdest 2237 177 12.0" 
$ns at 863.7851210471645 "$node_(77) setdest 292 364 5.0" 
$ns at 341.5137203055873 "$node_(78) setdest 1135 126 12.0" 
$ns at 489.51441634554476 "$node_(78) setdest 1149 136 8.0" 
$ns at 556.5189700671557 "$node_(78) setdest 1352 151 7.0" 
$ns at 622.5682932734555 "$node_(78) setdest 2655 182 1.0" 
$ns at 659.1230531206216 "$node_(78) setdest 579 704 12.0" 
$ns at 704.1008606052258 "$node_(78) setdest 1255 397 8.0" 
$ns at 779.8050589157916 "$node_(78) setdest 2567 10 20.0" 
$ns at 853.1046823961692 "$node_(78) setdest 801 980 8.0" 
$ns at 896.5244257180179 "$node_(78) setdest 558 226 16.0" 
$ns at 371.2994310648847 "$node_(79) setdest 2433 360 17.0" 
$ns at 494.2495325034256 "$node_(79) setdest 1868 813 18.0" 
$ns at 585.3476625240903 "$node_(79) setdest 1788 979 7.0" 
$ns at 617.094579065295 "$node_(79) setdest 556 134 11.0" 
$ns at 732.5315885949983 "$node_(79) setdest 2588 791 8.0" 
$ns at 779.0862746964652 "$node_(79) setdest 2568 736 17.0" 
$ns at 368.1196349738139 "$node_(80) setdest 2998 7 16.0" 
$ns at 551.6669196230839 "$node_(80) setdest 1294 980 4.0" 
$ns at 593.1456387915655 "$node_(80) setdest 555 912 7.0" 
$ns at 649.4676553232769 "$node_(80) setdest 2504 265 6.0" 
$ns at 684.1145963410738 "$node_(80) setdest 1917 432 1.0" 
$ns at 721.214761509716 "$node_(80) setdest 2788 408 3.0" 
$ns at 771.0464365621663 "$node_(80) setdest 1402 873 13.0" 
$ns at 331.7675875922705 "$node_(81) setdest 1012 337 13.0" 
$ns at 399.4328514212009 "$node_(81) setdest 2067 893 11.0" 
$ns at 500.71110580472305 "$node_(81) setdest 1756 105 13.0" 
$ns at 642.0143747360921 "$node_(81) setdest 2963 212 3.0" 
$ns at 691.5497352289026 "$node_(81) setdest 2622 846 14.0" 
$ns at 825.161484426085 "$node_(81) setdest 193 238 3.0" 
$ns at 860.3556464578214 "$node_(81) setdest 1345 320 2.0" 
$ns at 346.1914674778086 "$node_(82) setdest 2185 684 5.0" 
$ns at 416.7165264739561 "$node_(82) setdest 2069 352 4.0" 
$ns at 458.66672991349856 "$node_(82) setdest 2076 351 4.0" 
$ns at 497.53501371489574 "$node_(82) setdest 2741 849 17.0" 
$ns at 573.5682481445218 "$node_(82) setdest 28 989 12.0" 
$ns at 628.2032766211855 "$node_(82) setdest 1501 216 19.0" 
$ns at 687.702882103088 "$node_(82) setdest 868 534 12.0" 
$ns at 728.9552101340245 "$node_(82) setdest 2533 254 5.0" 
$ns at 766.3111841407027 "$node_(82) setdest 770 232 19.0" 
$ns at 421.85009789323726 "$node_(83) setdest 2832 401 11.0" 
$ns at 542.7208704721362 "$node_(83) setdest 481 350 4.0" 
$ns at 581.9798148107666 "$node_(83) setdest 1597 497 8.0" 
$ns at 649.1022085265519 "$node_(83) setdest 1968 648 12.0" 
$ns at 703.2257710321036 "$node_(83) setdest 397 969 5.0" 
$ns at 742.0039437513783 "$node_(83) setdest 2993 993 3.0" 
$ns at 775.5417526311812 "$node_(83) setdest 2797 678 17.0" 
$ns at 355.511689246076 "$node_(84) setdest 562 410 8.0" 
$ns at 454.2227204168519 "$node_(84) setdest 940 574 13.0" 
$ns at 510.37207911793445 "$node_(84) setdest 1362 386 1.0" 
$ns at 547.7436561211995 "$node_(84) setdest 2442 707 4.0" 
$ns at 588.1439537404041 "$node_(84) setdest 963 623 4.0" 
$ns at 647.1796859086583 "$node_(84) setdest 485 2 10.0" 
$ns at 731.3109150208531 "$node_(84) setdest 1817 574 1.0" 
$ns at 763.2655884337179 "$node_(84) setdest 2403 994 19.0" 
$ns at 801.7991508440058 "$node_(84) setdest 882 758 18.0" 
$ns at 398.8950143480271 "$node_(85) setdest 1581 851 13.0" 
$ns at 464.03954176825596 "$node_(85) setdest 1902 382 1.0" 
$ns at 496.4337449432635 "$node_(85) setdest 2555 191 12.0" 
$ns at 638.1138279322818 "$node_(85) setdest 494 274 15.0" 
$ns at 684.565124052852 "$node_(85) setdest 81 147 14.0" 
$ns at 738.1649023213668 "$node_(85) setdest 2659 556 2.0" 
$ns at 773.7152040334295 "$node_(85) setdest 1135 882 15.0" 
$ns at 879.2803133594788 "$node_(85) setdest 133 545 1.0" 
$ns at 415.5873629159669 "$node_(86) setdest 1905 985 19.0" 
$ns at 608.8433205809295 "$node_(86) setdest 2186 614 5.0" 
$ns at 680.4723583442295 "$node_(86) setdest 1777 388 1.0" 
$ns at 718.4976889285149 "$node_(86) setdest 2523 314 18.0" 
$ns at 818.0612637845247 "$node_(86) setdest 1987 445 19.0" 
$ns at 896.7240355662142 "$node_(86) setdest 399 196 13.0" 
$ns at 353.46520861217 "$node_(87) setdest 1733 699 9.0" 
$ns at 408.9631894552174 "$node_(87) setdest 1790 600 16.0" 
$ns at 593.4983673321818 "$node_(87) setdest 2546 588 12.0" 
$ns at 626.2263042456383 "$node_(87) setdest 1561 112 12.0" 
$ns at 680.0907876250182 "$node_(87) setdest 1097 368 10.0" 
$ns at 745.1247727105298 "$node_(87) setdest 679 557 13.0" 
$ns at 827.0270728690497 "$node_(87) setdest 369 103 19.0" 
$ns at 381.5965581070884 "$node_(88) setdest 2341 113 14.0" 
$ns at 537.2457137697436 "$node_(88) setdest 357 772 10.0" 
$ns at 585.857379093321 "$node_(88) setdest 2376 958 14.0" 
$ns at 643.092260295577 "$node_(88) setdest 1323 734 10.0" 
$ns at 715.9173172610231 "$node_(88) setdest 184 158 10.0" 
$ns at 795.5137183628246 "$node_(88) setdest 2101 312 4.0" 
$ns at 834.4598014169763 "$node_(88) setdest 2746 872 17.0" 
$ns at 451.6460048540819 "$node_(89) setdest 2665 513 6.0" 
$ns at 510.6531084005542 "$node_(89) setdest 1102 724 14.0" 
$ns at 597.2881697495486 "$node_(89) setdest 1832 533 5.0" 
$ns at 653.1480046475956 "$node_(89) setdest 804 817 4.0" 
$ns at 685.6104660159147 "$node_(89) setdest 281 31 5.0" 
$ns at 761.9879588449759 "$node_(89) setdest 2821 253 9.0" 
$ns at 829.4857402479827 "$node_(89) setdest 934 128 1.0" 
$ns at 865.7962401922595 "$node_(89) setdest 2821 605 2.0" 
$ns at 454.5652047635774 "$node_(90) setdest 2358 191 1.0" 
$ns at 487.1255414246875 "$node_(90) setdest 2553 188 16.0" 
$ns at 535.2053643747519 "$node_(90) setdest 2019 927 6.0" 
$ns at 610.1124470918855 "$node_(90) setdest 2204 539 14.0" 
$ns at 703.4708530119103 "$node_(90) setdest 454 425 19.0" 
$ns at 794.5112951075405 "$node_(90) setdest 1160 598 3.0" 
$ns at 838.9842350123779 "$node_(90) setdest 1147 516 15.0" 
$ns at 457.1996693517834 "$node_(91) setdest 1993 340 13.0" 
$ns at 494.3560408358403 "$node_(91) setdest 885 320 12.0" 
$ns at 623.876034861097 "$node_(91) setdest 230 811 11.0" 
$ns at 762.7529591676503 "$node_(91) setdest 2126 206 6.0" 
$ns at 834.1959333629608 "$node_(91) setdest 2696 149 11.0" 
$ns at 403.81239070736206 "$node_(92) setdest 1158 55 16.0" 
$ns at 492.5969713753754 "$node_(92) setdest 3 819 16.0" 
$ns at 677.9720364414779 "$node_(92) setdest 1234 762 20.0" 
$ns at 857.5485092423751 "$node_(92) setdest 2558 329 8.0" 
$ns at 403.7004538462471 "$node_(93) setdest 1826 146 11.0" 
$ns at 473.8453232452581 "$node_(93) setdest 1921 3 19.0" 
$ns at 577.6224222543678 "$node_(93) setdest 439 351 18.0" 
$ns at 783.3510161930265 "$node_(93) setdest 1649 100 19.0" 
$ns at 433.2460190147124 "$node_(94) setdest 242 269 12.0" 
$ns at 541.4674946957076 "$node_(94) setdest 1489 239 9.0" 
$ns at 638.2769333794914 "$node_(94) setdest 478 396 8.0" 
$ns at 693.5584724604115 "$node_(94) setdest 1185 328 19.0" 
$ns at 834.3567402812727 "$node_(94) setdest 2722 999 1.0" 
$ns at 866.2006189681467 "$node_(94) setdest 949 587 19.0" 
$ns at 341.3145338379975 "$node_(95) setdest 2670 525 14.0" 
$ns at 422.74920489409453 "$node_(95) setdest 1894 429 1.0" 
$ns at 457.4161617076533 "$node_(95) setdest 1434 344 2.0" 
$ns at 487.5139565892217 "$node_(95) setdest 2325 517 10.0" 
$ns at 528.1541142508194 "$node_(95) setdest 627 968 7.0" 
$ns at 604.9613552393312 "$node_(95) setdest 434 951 2.0" 
$ns at 641.164047139573 "$node_(95) setdest 1168 106 13.0" 
$ns at 755.8771336091804 "$node_(95) setdest 2108 401 7.0" 
$ns at 811.3189958514824 "$node_(95) setdest 1269 356 3.0" 
$ns at 867.8217779070009 "$node_(95) setdest 2461 845 7.0" 
$ns at 358.50663222159676 "$node_(96) setdest 1176 671 3.0" 
$ns at 392.166203275265 "$node_(96) setdest 1467 269 6.0" 
$ns at 456.92933748623705 "$node_(96) setdest 1269 256 5.0" 
$ns at 513.1325614055195 "$node_(96) setdest 400 235 13.0" 
$ns at 587.6851893676319 "$node_(96) setdest 606 904 20.0" 
$ns at 784.3667056860344 "$node_(96) setdest 454 154 13.0" 
$ns at 448.12279972504723 "$node_(97) setdest 2222 524 4.0" 
$ns at 502.56948639737453 "$node_(97) setdest 2051 740 8.0" 
$ns at 574.4972362487258 "$node_(97) setdest 1986 824 2.0" 
$ns at 620.758105322018 "$node_(97) setdest 1696 38 1.0" 
$ns at 653.9064884675518 "$node_(97) setdest 623 795 5.0" 
$ns at 729.0036574650995 "$node_(97) setdest 977 569 4.0" 
$ns at 774.8434846241134 "$node_(97) setdest 1836 819 18.0" 
$ns at 845.9685832302371 "$node_(97) setdest 2476 348 5.0" 
$ns at 882.2795562597306 "$node_(97) setdest 475 457 3.0" 
$ns at 339.48860710790996 "$node_(98) setdest 1899 767 18.0" 
$ns at 446.40644529861066 "$node_(98) setdest 2506 872 11.0" 
$ns at 526.0101894405142 "$node_(98) setdest 1061 146 10.0" 
$ns at 556.0175352765627 "$node_(98) setdest 1925 592 12.0" 
$ns at 624.3909145134755 "$node_(98) setdest 2417 990 2.0" 
$ns at 655.338017224587 "$node_(98) setdest 1029 930 17.0" 
$ns at 713.9911833563283 "$node_(98) setdest 2663 682 9.0" 
$ns at 813.5012169183676 "$node_(98) setdest 472 694 7.0" 
$ns at 394.9938855058068 "$node_(99) setdest 2604 908 6.0" 
$ns at 443.61529804887095 "$node_(99) setdest 1278 822 17.0" 
$ns at 552.1395212302558 "$node_(99) setdest 2541 523 19.0" 
$ns at 624.0633453516326 "$node_(99) setdest 1263 342 4.0" 
$ns at 686.181774928064 "$node_(99) setdest 2638 333 10.0" 
$ns at 756.0728390939323 "$node_(99) setdest 288 828 6.0" 
$ns at 835.9302500005526 "$node_(99) setdest 2670 565 11.0" 
$ns at 895.5933546277272 "$node_(99) setdest 2653 166 1.0" 
$ns at 542.0976420540484 "$node_(100) setdest 2267 683 5.0" 
$ns at 572.1309207390249 "$node_(100) setdest 1869 825 12.0" 
$ns at 631.2280827333966 "$node_(100) setdest 1888 41 8.0" 
$ns at 669.5161870476709 "$node_(100) setdest 1567 967 2.0" 
$ns at 709.6815861900295 "$node_(100) setdest 976 928 17.0" 
$ns at 865.0852740553546 "$node_(100) setdest 2081 844 17.0" 
$ns at 533.13547747628 "$node_(101) setdest 1715 388 10.0" 
$ns at 601.2618199245067 "$node_(101) setdest 1192 16 15.0" 
$ns at 722.9691745224577 "$node_(101) setdest 1273 654 5.0" 
$ns at 768.8423212314156 "$node_(101) setdest 1378 407 19.0" 
$ns at 603.7765215531713 "$node_(102) setdest 1526 264 14.0" 
$ns at 749.0121700922746 "$node_(102) setdest 728 391 10.0" 
$ns at 821.1440347770787 "$node_(102) setdest 916 521 9.0" 
$ns at 876.7713202433014 "$node_(102) setdest 822 119 20.0" 
$ns at 541.9473503551934 "$node_(103) setdest 1088 997 3.0" 
$ns at 589.0079937950138 "$node_(103) setdest 485 993 12.0" 
$ns at 703.2673519005518 "$node_(103) setdest 2743 175 18.0" 
$ns at 851.465872791528 "$node_(103) setdest 2946 262 5.0" 
$ns at 588.0952471605406 "$node_(104) setdest 363 597 15.0" 
$ns at 759.6011543701939 "$node_(104) setdest 992 987 1.0" 
$ns at 797.322303290445 "$node_(104) setdest 2339 927 2.0" 
$ns at 828.9693413193347 "$node_(104) setdest 861 652 5.0" 
$ns at 863.0891279862566 "$node_(104) setdest 2610 834 7.0" 
$ns at 707.0001200824961 "$node_(105) setdest 756 755 14.0" 
$ns at 753.3943308294729 "$node_(105) setdest 1152 334 11.0" 
$ns at 791.1548424153394 "$node_(105) setdest 403 6 18.0" 
$ns at 548.205050902812 "$node_(106) setdest 2558 243 11.0" 
$ns at 611.4018444618339 "$node_(106) setdest 1575 682 2.0" 
$ns at 660.0970050520328 "$node_(106) setdest 387 307 20.0" 
$ns at 723.1035949851299 "$node_(106) setdest 2784 95 1.0" 
$ns at 759.7477953267934 "$node_(106) setdest 698 429 11.0" 
$ns at 897.2638598591174 "$node_(106) setdest 897 999 4.0" 
$ns at 513.5149439372127 "$node_(107) setdest 1687 722 18.0" 
$ns at 636.1982195907214 "$node_(107) setdest 1313 957 11.0" 
$ns at 695.7964197396881 "$node_(107) setdest 1916 767 11.0" 
$ns at 811.7492110941384 "$node_(107) setdest 92 286 17.0" 
$ns at 524.1199846141345 "$node_(108) setdest 847 657 8.0" 
$ns at 633.320320291162 "$node_(108) setdest 2546 942 3.0" 
$ns at 686.8136941950085 "$node_(108) setdest 1667 848 18.0" 
$ns at 778.6468200821434 "$node_(108) setdest 487 149 13.0" 
$ns at 889.661207546698 "$node_(108) setdest 1332 404 17.0" 
$ns at 522.1219523186595 "$node_(109) setdest 2396 911 7.0" 
$ns at 562.8329233012 "$node_(109) setdest 1082 301 2.0" 
$ns at 609.6132139257928 "$node_(109) setdest 2125 640 2.0" 
$ns at 650.9945328445967 "$node_(109) setdest 1280 242 17.0" 
$ns at 801.3337653394462 "$node_(109) setdest 945 941 2.0" 
$ns at 839.1077511612177 "$node_(109) setdest 2578 62 20.0" 
$ns at 546.6794446825152 "$node_(110) setdest 2417 474 4.0" 
$ns at 593.2107519561195 "$node_(110) setdest 883 769 5.0" 
$ns at 646.3872399032136 "$node_(110) setdest 128 434 12.0" 
$ns at 784.1415515837878 "$node_(110) setdest 2866 675 15.0" 
$ns at 495.31904946405666 "$node_(111) setdest 2184 428 16.0" 
$ns at 558.7872626903496 "$node_(111) setdest 1759 507 5.0" 
$ns at 601.8001876997895 "$node_(111) setdest 2568 262 6.0" 
$ns at 658.3566478834523 "$node_(111) setdest 2293 462 7.0" 
$ns at 697.9379401888548 "$node_(111) setdest 1760 881 5.0" 
$ns at 730.3797838404453 "$node_(111) setdest 2303 945 13.0" 
$ns at 883.8175201692452 "$node_(111) setdest 2431 324 9.0" 
$ns at 528.4813067406831 "$node_(112) setdest 2654 234 17.0" 
$ns at 574.0887258744459 "$node_(112) setdest 2585 530 15.0" 
$ns at 624.3937285612883 "$node_(112) setdest 1718 291 2.0" 
$ns at 673.6000365521421 "$node_(112) setdest 2211 560 2.0" 
$ns at 704.8231971843842 "$node_(112) setdest 2192 217 18.0" 
$ns at 878.2980743373596 "$node_(112) setdest 1403 967 18.0" 
$ns at 565.6478941691312 "$node_(113) setdest 869 489 10.0" 
$ns at 635.9415710867698 "$node_(113) setdest 822 496 8.0" 
$ns at 691.7913170460769 "$node_(113) setdest 945 874 13.0" 
$ns at 844.4783262987132 "$node_(113) setdest 590 847 4.0" 
$ns at 582.7145234672295 "$node_(114) setdest 859 170 8.0" 
$ns at 669.6423622793371 "$node_(114) setdest 284 986 13.0" 
$ns at 702.031202877774 "$node_(114) setdest 1766 819 3.0" 
$ns at 746.0238079943274 "$node_(114) setdest 2621 221 8.0" 
$ns at 790.7428779419454 "$node_(114) setdest 1432 82 5.0" 
$ns at 856.4163900183387 "$node_(114) setdest 365 99 12.0" 
$ns at 599.727490437884 "$node_(115) setdest 2725 962 10.0" 
$ns at 715.6725855767187 "$node_(115) setdest 2206 57 19.0" 
$ns at 803.3881030530707 "$node_(115) setdest 1737 559 4.0" 
$ns at 841.4969988260566 "$node_(115) setdest 2690 925 6.0" 
$ns at 893.6487373328914 "$node_(115) setdest 2839 371 3.0" 
$ns at 508.66892418328933 "$node_(116) setdest 1885 35 9.0" 
$ns at 558.0099097111057 "$node_(116) setdest 96 39 9.0" 
$ns at 588.1903738153516 "$node_(116) setdest 2710 927 16.0" 
$ns at 651.5880885514324 "$node_(116) setdest 993 984 13.0" 
$ns at 738.6272486415908 "$node_(116) setdest 825 362 18.0" 
$ns at 776.2723530726288 "$node_(116) setdest 2163 883 1.0" 
$ns at 808.2375055081598 "$node_(116) setdest 335 243 17.0" 
$ns at 510.71215847208225 "$node_(117) setdest 2260 355 19.0" 
$ns at 629.336637309552 "$node_(117) setdest 735 393 10.0" 
$ns at 694.6589705026854 "$node_(117) setdest 2858 279 19.0" 
$ns at 873.77230305796 "$node_(117) setdest 610 911 14.0" 
$ns at 524.3969326345602 "$node_(118) setdest 161 297 3.0" 
$ns at 559.7302739555169 "$node_(118) setdest 2961 686 17.0" 
$ns at 712.7859914324705 "$node_(118) setdest 655 209 13.0" 
$ns at 771.7427432693252 "$node_(118) setdest 1622 984 1.0" 
$ns at 810.4008927049582 "$node_(118) setdest 287 326 1.0" 
$ns at 842.4274396040502 "$node_(118) setdest 175 213 9.0" 
$ns at 500.22347525155146 "$node_(119) setdest 2164 995 7.0" 
$ns at 580.9402609395742 "$node_(119) setdest 265 664 10.0" 
$ns at 686.4599689318604 "$node_(119) setdest 408 144 8.0" 
$ns at 781.9185580485008 "$node_(119) setdest 1745 130 6.0" 
$ns at 845.6476960946751 "$node_(119) setdest 719 723 20.0" 
$ns at 542.6239859597264 "$node_(120) setdest 775 897 6.0" 
$ns at 583.2867311382581 "$node_(120) setdest 2767 760 1.0" 
$ns at 615.3119196691463 "$node_(120) setdest 2485 81 11.0" 
$ns at 688.6924794073027 "$node_(120) setdest 2761 973 16.0" 
$ns at 805.9186917720333 "$node_(120) setdest 1325 672 6.0" 
$ns at 861.1430047480762 "$node_(120) setdest 170 862 14.0" 
$ns at 514.0661092857182 "$node_(121) setdest 2873 137 13.0" 
$ns at 595.9352959491465 "$node_(121) setdest 2686 527 15.0" 
$ns at 725.8982425676337 "$node_(121) setdest 8 890 8.0" 
$ns at 817.0871218935818 "$node_(121) setdest 1082 409 17.0" 
$ns at 573.372510039559 "$node_(122) setdest 2414 433 10.0" 
$ns at 647.2141116732548 "$node_(122) setdest 1330 913 12.0" 
$ns at 725.5634314197811 "$node_(122) setdest 2649 440 1.0" 
$ns at 761.3954769361242 "$node_(122) setdest 1054 712 12.0" 
$ns at 812.1912065020381 "$node_(122) setdest 2678 894 2.0" 
$ns at 846.2336045121078 "$node_(122) setdest 119 338 6.0" 
$ns at 536.8842270282282 "$node_(123) setdest 1089 469 7.0" 
$ns at 615.1792980735203 "$node_(123) setdest 166 12 19.0" 
$ns at 800.4252696686922 "$node_(123) setdest 2962 491 4.0" 
$ns at 866.9505402420265 "$node_(123) setdest 2151 649 17.0" 
$ns at 512.0332264895701 "$node_(124) setdest 860 611 3.0" 
$ns at 565.4868078625022 "$node_(124) setdest 1817 134 15.0" 
$ns at 741.889812521631 "$node_(124) setdest 2005 833 15.0" 
$ns at 686.1830571100187 "$node_(125) setdest 1910 495 1.0" 
$ns at 717.389632349828 "$node_(125) setdest 2992 603 7.0" 
$ns at 748.2737717279192 "$node_(125) setdest 629 905 10.0" 
$ns at 788.6683062791092 "$node_(125) setdest 1441 776 17.0" 
$ns at 721.1861532302268 "$node_(126) setdest 694 234 13.0" 
$ns at 767.3579209974498 "$node_(126) setdest 1935 563 4.0" 
$ns at 808.0205057843709 "$node_(126) setdest 2670 888 10.0" 
$ns at 843.0248913980406 "$node_(126) setdest 572 108 5.0" 
$ns at 749.066083207498 "$node_(127) setdest 2647 152 18.0" 
$ns at 693.7282259369903 "$node_(128) setdest 864 945 13.0" 
$ns at 781.4806583246603 "$node_(128) setdest 2149 278 1.0" 
$ns at 812.4464675439863 "$node_(128) setdest 2157 195 7.0" 
$ns at 748.6616857585961 "$node_(129) setdest 1357 274 4.0" 
$ns at 791.2693349792049 "$node_(129) setdest 741 836 1.0" 
$ns at 821.3074276288356 "$node_(129) setdest 2490 743 15.0" 
$ns at 679.5319107993131 "$node_(130) setdest 2358 555 16.0" 
$ns at 838.5139523573548 "$node_(130) setdest 2456 51 14.0" 
$ns at 881.0982160997658 "$node_(130) setdest 2307 196 5.0" 
$ns at 723.4767346578726 "$node_(131) setdest 2838 997 17.0" 
$ns at 803.9110313783569 "$node_(131) setdest 287 392 10.0" 
$ns at 732.2630903044459 "$node_(132) setdest 2904 616 19.0" 
$ns at 754.751646727063 "$node_(133) setdest 775 82 15.0" 
$ns at 849.1612596634437 "$node_(133) setdest 1211 410 12.0" 
$ns at 734.1443182190839 "$node_(134) setdest 269 273 18.0" 
$ns at 829.5631531133956 "$node_(134) setdest 2878 464 8.0" 
$ns at 678.2351531733166 "$node_(135) setdest 2192 301 11.0" 
$ns at 812.8815843832286 "$node_(135) setdest 299 46 1.0" 
$ns at 850.7952962842616 "$node_(135) setdest 693 902 7.0" 
$ns at 817.3388425883566 "$node_(136) setdest 642 661 7.0" 
$ns at 874.5260350826162 "$node_(136) setdest 2790 301 14.0" 
$ns at 662.6751650268179 "$node_(137) setdest 2624 494 18.0" 
$ns at 721.7905969705972 "$node_(137) setdest 165 293 7.0" 
$ns at 785.436575760277 "$node_(137) setdest 1333 113 18.0" 
$ns at 738.729224995541 "$node_(138) setdest 2465 511 16.0" 
$ns at 796.2634816095126 "$node_(138) setdest 616 86 18.0" 
$ns at 722.368228439781 "$node_(139) setdest 1101 556 9.0" 
$ns at 837.3105178619248 "$node_(139) setdest 2216 986 6.0" 
$ns at 883.2092824536544 "$node_(139) setdest 2619 176 19.0" 
$ns at 677.9996897468818 "$node_(140) setdest 872 257 3.0" 
$ns at 734.1265880479837 "$node_(140) setdest 2502 422 7.0" 
$ns at 813.8504719672027 "$node_(140) setdest 2898 693 1.0" 
$ns at 849.0688011271791 "$node_(140) setdest 99 783 12.0" 
$ns at 675.4670879506859 "$node_(141) setdest 1837 401 5.0" 
$ns at 713.8184059777745 "$node_(141) setdest 2701 474 11.0" 
$ns at 787.1484840134983 "$node_(141) setdest 305 723 18.0" 
$ns at 820.7734424321063 "$node_(141) setdest 2129 770 8.0" 
$ns at 700.0562448434475 "$node_(142) setdest 1877 442 14.0" 
$ns at 775.3909343298176 "$node_(142) setdest 1268 813 9.0" 
$ns at 807.1546879766988 "$node_(142) setdest 2923 314 8.0" 
$ns at 871.0310914657271 "$node_(142) setdest 780 365 17.0" 
$ns at 662.7835251913615 "$node_(143) setdest 2954 347 19.0" 
$ns at 878.6662961331083 "$node_(143) setdest 2974 746 14.0" 
$ns at 691.1028262102695 "$node_(144) setdest 2094 752 8.0" 
$ns at 755.6433747061224 "$node_(144) setdest 2707 251 6.0" 
$ns at 816.6968140922811 "$node_(144) setdest 664 860 19.0" 
$ns at 700.4470423648074 "$node_(145) setdest 2613 721 3.0" 
$ns at 748.5637791097589 "$node_(145) setdest 1469 282 10.0" 
$ns at 861.2145581137644 "$node_(145) setdest 1146 115 12.0" 
$ns at 694.6372475988452 "$node_(146) setdest 1393 6 5.0" 
$ns at 755.9023443685239 "$node_(146) setdest 1039 268 16.0" 
$ns at 720.8286842110543 "$node_(147) setdest 1142 992 3.0" 
$ns at 774.7054085296622 "$node_(147) setdest 798 228 10.0" 
$ns at 871.3506892984626 "$node_(147) setdest 1352 69 3.0" 
$ns at 685.5488864526674 "$node_(148) setdest 2994 922 8.0" 
$ns at 777.7251043319052 "$node_(148) setdest 749 32 7.0" 
$ns at 871.9454556248185 "$node_(148) setdest 1453 282 12.0" 
$ns at 677.2722701936693 "$node_(149) setdest 1080 281 8.0" 
$ns at 783.2055952915462 "$node_(149) setdest 2643 125 10.0" 


#Set a TCP connection between node_(46) and node_(7)
set tcp_(0) [new Agent/TCP/Newreno]
$tcp_(0) set class_ 2
set sink_(0) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(0)
$ns attach-agent $node_(7) $sink_(0)
$ns connect $tcp_(0) $sink_(0)
set ftp_(0) [new Application/FTP]
$ftp_(0) attach-agent $tcp_(0)
$ns at 0.2 "$ftp_(0) start"
$ns at 180.0 "$ftp_(0) stop"

#Set a TCP connection between node_(21) and node_(41)
set tcp_(1) [new Agent/TCP/Newreno]
$tcp_(1) set class_ 2
set sink_(1) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(1)
$ns attach-agent $node_(41) $sink_(1)
$ns connect $tcp_(1) $sink_(1)
set ftp_(1) [new Application/FTP]
$ftp_(1) attach-agent $tcp_(1)
$ns at 180.2 "$ftp_(1) start"
$ns at 360.0 "$ftp_(1) stop"

#Set a TCP connection between node_(2) and node_(17)
set tcp_(2) [new Agent/TCP/Newreno]
$tcp_(2) set class_ 2
set sink_(2) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(2)
$ns attach-agent $node_(17) $sink_(2)
$ns connect $tcp_(2) $sink_(2)
set ftp_(2) [new Application/FTP]
$ftp_(2) attach-agent $tcp_(2)
$ns at 360.2 "$ftp_(2) start"
$ns at 540.0 "$ftp_(2) stop"

#Set a TCP connection between node_(7) and node_(32)
set tcp_(3) [new Agent/TCP/Newreno]
$tcp_(3) set class_ 2
set sink_(3) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(3)
$ns attach-agent $node_(32) $sink_(3)
$ns connect $tcp_(3) $sink_(3)
set ftp_(3) [new Application/FTP]
$ftp_(3) attach-agent $tcp_(3)
$ns at 540.2 "$ftp_(3) start"
$ns at 720.0 "$ftp_(3) stop"

#Set a TCP connection between node_(21) and node_(42)
set tcp_(4) [new Agent/TCP/Newreno]
$tcp_(4) set class_ 2
set sink_(4) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(4)
$ns attach-agent $node_(42) $sink_(4)
$ns connect $tcp_(4) $sink_(4)
set ftp_(4) [new Application/FTP]
$ftp_(4) attach-agent $tcp_(4)
$ns at 720.2 "$ftp_(4) start"
$ns at 900.0 "$ftp_(4) stop"

#Set a TCP connection between node_(13) and node_(26)
set tcp_(5) [new Agent/TCP/Newreno]
$tcp_(5) set class_ 2
set sink_(5) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(5)
$ns attach-agent $node_(26) $sink_(5)
$ns connect $tcp_(5) $sink_(5)
set ftp_(5) [new Application/FTP]
$ftp_(5) attach-agent $tcp_(5)
$ns at 0.2 "$ftp_(5) start"
$ns at 180.0 "$ftp_(5) stop"

#Set a TCP connection between node_(35) and node_(48)
set tcp_(6) [new Agent/TCP/Newreno]
$tcp_(6) set class_ 2
set sink_(6) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(6)
$ns attach-agent $node_(48) $sink_(6)
$ns connect $tcp_(6) $sink_(6)
set ftp_(6) [new Application/FTP]
$ftp_(6) attach-agent $tcp_(6)
$ns at 180.2 "$ftp_(6) start"
$ns at 360.0 "$ftp_(6) stop"

#Set a TCP connection between node_(37) and node_(34)
set tcp_(7) [new Agent/TCP/Newreno]
$tcp_(7) set class_ 2
set sink_(7) [new Agent/TCPSink]
$ns attach-agent $node_(37) $tcp_(7)
$ns attach-agent $node_(34) $sink_(7)
$ns connect $tcp_(7) $sink_(7)
set ftp_(7) [new Application/FTP]
$ftp_(7) attach-agent $tcp_(7)
$ns at 360.2 "$ftp_(7) start"
$ns at 540.0 "$ftp_(7) stop"

#Set a TCP connection between node_(47) and node_(20)
set tcp_(8) [new Agent/TCP/Newreno]
$tcp_(8) set class_ 2
set sink_(8) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(8)
$ns attach-agent $node_(20) $sink_(8)
$ns connect $tcp_(8) $sink_(8)
set ftp_(8) [new Application/FTP]
$ftp_(8) attach-agent $tcp_(8)
$ns at 540.2 "$ftp_(8) start"
$ns at 720.0 "$ftp_(8) stop"

#Set a TCP connection between node_(8) and node_(3)
set tcp_(9) [new Agent/TCP/Newreno]
$tcp_(9) set class_ 2
set sink_(9) [new Agent/TCPSink]
$ns attach-agent $node_(8) $tcp_(9)
$ns attach-agent $node_(3) $sink_(9)
$ns connect $tcp_(9) $sink_(9)
set ftp_(9) [new Application/FTP]
$ftp_(9) attach-agent $tcp_(9)
$ns at 720.2 "$ftp_(9) start"
$ns at 900.0 "$ftp_(9) stop"

#Set a TCP connection between node_(29) and node_(17)
set tcp_(10) [new Agent/TCP/Newreno]
$tcp_(10) set class_ 2
set sink_(10) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(10)
$ns attach-agent $node_(17) $sink_(10)
$ns connect $tcp_(10) $sink_(10)
set ftp_(10) [new Application/FTP]
$ftp_(10) attach-agent $tcp_(10)
$ns at 0.2 "$ftp_(10) start"
$ns at 180.0 "$ftp_(10) stop"

#Set a TCP connection between node_(30) and node_(38)
set tcp_(11) [new Agent/TCP/Newreno]
$tcp_(11) set class_ 2
set sink_(11) [new Agent/TCPSink]
$ns attach-agent $node_(30) $tcp_(11)
$ns attach-agent $node_(38) $sink_(11)
$ns connect $tcp_(11) $sink_(11)
set ftp_(11) [new Application/FTP]
$ftp_(11) attach-agent $tcp_(11)
$ns at 180.2 "$ftp_(11) start"
$ns at 360.0 "$ftp_(11) stop"

#Set a TCP connection between node_(4) and node_(18)
set tcp_(12) [new Agent/TCP/Newreno]
$tcp_(12) set class_ 2
set sink_(12) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(12)
$ns attach-agent $node_(18) $sink_(12)
$ns connect $tcp_(12) $sink_(12)
set ftp_(12) [new Application/FTP]
$ftp_(12) attach-agent $tcp_(12)
$ns at 360.2 "$ftp_(12) start"
$ns at 540.0 "$ftp_(12) stop"

#Set a TCP connection between node_(45) and node_(21)
set tcp_(13) [new Agent/TCP/Newreno]
$tcp_(13) set class_ 2
set sink_(13) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(13)
$ns attach-agent $node_(21) $sink_(13)
$ns connect $tcp_(13) $sink_(13)
set ftp_(13) [new Application/FTP]
$ftp_(13) attach-agent $tcp_(13)
$ns at 540.2 "$ftp_(13) start"
$ns at 720.0 "$ftp_(13) stop"

#Set a TCP connection between node_(36) and node_(30)
set tcp_(14) [new Agent/TCP/Newreno]
$tcp_(14) set class_ 2
set sink_(14) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(14)
$ns attach-agent $node_(30) $sink_(14)
$ns connect $tcp_(14) $sink_(14)
set ftp_(14) [new Application/FTP]
$ftp_(14) attach-agent $tcp_(14)
$ns at 720.2 "$ftp_(14) start"
$ns at 900.0 "$ftp_(14) stop"

#Set a TCP connection between node_(47) and node_(26)
set tcp_(15) [new Agent/TCP/Newreno]
$tcp_(15) set class_ 2
set sink_(15) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(15)
$ns attach-agent $node_(26) $sink_(15)
$ns connect $tcp_(15) $sink_(15)
set ftp_(15) [new Application/FTP]
$ftp_(15) attach-agent $tcp_(15)
$ns at 0.2 "$ftp_(15) start"
$ns at 180.0 "$ftp_(15) stop"

#Set a TCP connection between node_(14) and node_(31)
set tcp_(16) [new Agent/TCP/Newreno]
$tcp_(16) set class_ 2
set sink_(16) [new Agent/TCPSink]
$ns attach-agent $node_(14) $tcp_(16)
$ns attach-agent $node_(31) $sink_(16)
$ns connect $tcp_(16) $sink_(16)
set ftp_(16) [new Application/FTP]
$ftp_(16) attach-agent $tcp_(16)
$ns at 180.2 "$ftp_(16) start"
$ns at 360.0 "$ftp_(16) stop"

#Set a TCP connection between node_(26) and node_(17)
set tcp_(17) [new Agent/TCP/Newreno]
$tcp_(17) set class_ 2
set sink_(17) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(17)
$ns attach-agent $node_(17) $sink_(17)
$ns connect $tcp_(17) $sink_(17)
set ftp_(17) [new Application/FTP]
$ftp_(17) attach-agent $tcp_(17)
$ns at 360.2 "$ftp_(17) start"
$ns at 540.0 "$ftp_(17) stop"

#Set a TCP connection between node_(25) and node_(48)
set tcp_(18) [new Agent/TCP/Newreno]
$tcp_(18) set class_ 2
set sink_(18) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(18)
$ns attach-agent $node_(48) $sink_(18)
$ns connect $tcp_(18) $sink_(18)
set ftp_(18) [new Application/FTP]
$ftp_(18) attach-agent $tcp_(18)
$ns at 540.2 "$ftp_(18) start"
$ns at 720.0 "$ftp_(18) stop"

#Set a TCP connection between node_(4) and node_(3)
set tcp_(19) [new Agent/TCP/Newreno]
$tcp_(19) set class_ 2
set sink_(19) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(19)
$ns attach-agent $node_(3) $sink_(19)
$ns connect $tcp_(19) $sink_(19)
set ftp_(19) [new Application/FTP]
$ftp_(19) attach-agent $tcp_(19)
$ns at 720.2 "$ftp_(19) start"
$ns at 900.0 "$ftp_(19) stop"

#Set a TCP connection between node_(47) and node_(33)
set tcp_(20) [new Agent/TCP/Newreno]
$tcp_(20) set class_ 2
set sink_(20) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(20)
$ns attach-agent $node_(33) $sink_(20)
$ns connect $tcp_(20) $sink_(20)
set ftp_(20) [new Application/FTP]
$ftp_(20) attach-agent $tcp_(20)
$ns at 0.2 "$ftp_(20) start"
$ns at 180.0 "$ftp_(20) stop"

#Set a TCP connection between node_(26) and node_(8)
set tcp_(21) [new Agent/TCP/Newreno]
$tcp_(21) set class_ 2
set sink_(21) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(21)
$ns attach-agent $node_(8) $sink_(21)
$ns connect $tcp_(21) $sink_(21)
set ftp_(21) [new Application/FTP]
$ftp_(21) attach-agent $tcp_(21)
$ns at 180.2 "$ftp_(21) start"
$ns at 360.0 "$ftp_(21) stop"

#Set a TCP connection between node_(37) and node_(16)
set tcp_(22) [new Agent/TCP/Newreno]
$tcp_(22) set class_ 2
set sink_(22) [new Agent/TCPSink]
$ns attach-agent $node_(37) $tcp_(22)
$ns attach-agent $node_(16) $sink_(22)
$ns connect $tcp_(22) $sink_(22)
set ftp_(22) [new Application/FTP]
$ftp_(22) attach-agent $tcp_(22)
$ns at 360.2 "$ftp_(22) start"
$ns at 540.0 "$ftp_(22) stop"

#Set a TCP connection between node_(13) and node_(33)
set tcp_(23) [new Agent/TCP/Newreno]
$tcp_(23) set class_ 2
set sink_(23) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(23)
$ns attach-agent $node_(33) $sink_(23)
$ns connect $tcp_(23) $sink_(23)
set ftp_(23) [new Application/FTP]
$ftp_(23) attach-agent $tcp_(23)
$ns at 540.2 "$ftp_(23) start"
$ns at 720.0 "$ftp_(23) stop"

#Set a TCP connection between node_(42) and node_(20)
set tcp_(24) [new Agent/TCP/Newreno]
$tcp_(24) set class_ 2
set sink_(24) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(24)
$ns attach-agent $node_(20) $sink_(24)
$ns connect $tcp_(24) $sink_(24)
set ftp_(24) [new Application/FTP]
$ftp_(24) attach-agent $tcp_(24)
$ns at 720.2 "$ftp_(24) start"
$ns at 900.0 "$ftp_(24) stop"

#Set a TCP connection between node_(46) and node_(16)
set tcp_(25) [new Agent/TCP/Newreno]
$tcp_(25) set class_ 2
set sink_(25) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(25)
$ns attach-agent $node_(16) $sink_(25)
$ns connect $tcp_(25) $sink_(25)
set ftp_(25) [new Application/FTP]
$ftp_(25) attach-agent $tcp_(25)
$ns at 0.2 "$ftp_(25) start"
$ns at 180.0 "$ftp_(25) stop"

#Set a TCP connection between node_(23) and node_(7)
set tcp_(26) [new Agent/TCP/Newreno]
$tcp_(26) set class_ 2
set sink_(26) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(26)
$ns attach-agent $node_(7) $sink_(26)
$ns connect $tcp_(26) $sink_(26)
set ftp_(26) [new Application/FTP]
$ftp_(26) attach-agent $tcp_(26)
$ns at 180.2 "$ftp_(26) start"
$ns at 360.0 "$ftp_(26) stop"

#Set a TCP connection between node_(16) and node_(3)
set tcp_(27) [new Agent/TCP/Newreno]
$tcp_(27) set class_ 2
set sink_(27) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(27)
$ns attach-agent $node_(3) $sink_(27)
$ns connect $tcp_(27) $sink_(27)
set ftp_(27) [new Application/FTP]
$ftp_(27) attach-agent $tcp_(27)
$ns at 360.2 "$ftp_(27) start"
$ns at 540.0 "$ftp_(27) stop"

#Set a TCP connection between node_(27) and node_(34)
set tcp_(28) [new Agent/TCP/Newreno]
$tcp_(28) set class_ 2
set sink_(28) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(28)
$ns attach-agent $node_(34) $sink_(28)
$ns connect $tcp_(28) $sink_(28)
set ftp_(28) [new Application/FTP]
$ftp_(28) attach-agent $tcp_(28)
$ns at 540.2 "$ftp_(28) start"
$ns at 720.0 "$ftp_(28) stop"

#Set a TCP connection between node_(30) and node_(14)
set tcp_(29) [new Agent/TCP/Newreno]
$tcp_(29) set class_ 2
set sink_(29) [new Agent/TCPSink]
$ns attach-agent $node_(30) $tcp_(29)
$ns attach-agent $node_(14) $sink_(29)
$ns connect $tcp_(29) $sink_(29)
set ftp_(29) [new Application/FTP]
$ftp_(29) attach-agent $tcp_(29)
$ns at 720.2 "$ftp_(29) start"
$ns at 900.0 "$ftp_(29) stop"

#Set a TCP connection between node_(3) and node_(27)
set tcp_(30) [new Agent/TCP/Newreno]
$tcp_(30) set class_ 2
set sink_(30) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(30)
$ns attach-agent $node_(27) $sink_(30)
$ns connect $tcp_(30) $sink_(30)
set ftp_(30) [new Application/FTP]
$ftp_(30) attach-agent $tcp_(30)
$ns at 0.2 "$ftp_(30) start"
$ns at 180.0 "$ftp_(30) stop"

#Set a TCP connection between node_(25) and node_(34)
set tcp_(31) [new Agent/TCP/Newreno]
$tcp_(31) set class_ 2
set sink_(31) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(31)
$ns attach-agent $node_(34) $sink_(31)
$ns connect $tcp_(31) $sink_(31)
set ftp_(31) [new Application/FTP]
$ftp_(31) attach-agent $tcp_(31)
$ns at 180.2 "$ftp_(31) start"
$ns at 360.0 "$ftp_(31) stop"

#Set a TCP connection between node_(34) and node_(6)
set tcp_(32) [new Agent/TCP/Newreno]
$tcp_(32) set class_ 2
set sink_(32) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(32)
$ns attach-agent $node_(6) $sink_(32)
$ns connect $tcp_(32) $sink_(32)
set ftp_(32) [new Application/FTP]
$ftp_(32) attach-agent $tcp_(32)
$ns at 360.2 "$ftp_(32) start"
$ns at 540.0 "$ftp_(32) stop"

#Set a TCP connection between node_(45) and node_(43)
set tcp_(33) [new Agent/TCP/Newreno]
$tcp_(33) set class_ 2
set sink_(33) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(33)
$ns attach-agent $node_(43) $sink_(33)
$ns connect $tcp_(33) $sink_(33)
set ftp_(33) [new Application/FTP]
$ftp_(33) attach-agent $tcp_(33)
$ns at 540.2 "$ftp_(33) start"
$ns at 720.0 "$ftp_(33) stop"

#Set a TCP connection between node_(38) and node_(11)
set tcp_(34) [new Agent/TCP/Newreno]
$tcp_(34) set class_ 2
set sink_(34) [new Agent/TCPSink]
$ns attach-agent $node_(38) $tcp_(34)
$ns attach-agent $node_(11) $sink_(34)
$ns connect $tcp_(34) $sink_(34)
set ftp_(34) [new Application/FTP]
$ftp_(34) attach-agent $tcp_(34)
$ns at 720.2 "$ftp_(34) start"
$ns at 900.0 "$ftp_(34) stop"

#Set a TCP connection between node_(21) and node_(20)
set tcp_(35) [new Agent/TCP/Newreno]
$tcp_(35) set class_ 2
set sink_(35) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(35)
$ns attach-agent $node_(20) $sink_(35)
$ns connect $tcp_(35) $sink_(35)
set ftp_(35) [new Application/FTP]
$ftp_(35) attach-agent $tcp_(35)
$ns at 0.2 "$ftp_(35) start"
$ns at 180.0 "$ftp_(35) stop"

#Set a TCP connection between node_(23) and node_(4)
set tcp_(36) [new Agent/TCP/Newreno]
$tcp_(36) set class_ 2
set sink_(36) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(36)
$ns attach-agent $node_(4) $sink_(36)
$ns connect $tcp_(36) $sink_(36)
set ftp_(36) [new Application/FTP]
$ftp_(36) attach-agent $tcp_(36)
$ns at 180.2 "$ftp_(36) start"
$ns at 360.0 "$ftp_(36) stop"

#Set a TCP connection between node_(25) and node_(37)
set tcp_(37) [new Agent/TCP/Newreno]
$tcp_(37) set class_ 2
set sink_(37) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(37)
$ns attach-agent $node_(37) $sink_(37)
$ns connect $tcp_(37) $sink_(37)
set ftp_(37) [new Application/FTP]
$ftp_(37) attach-agent $tcp_(37)
$ns at 360.2 "$ftp_(37) start"
$ns at 540.0 "$ftp_(37) stop"

#Set a TCP connection between node_(5) and node_(3)
set tcp_(38) [new Agent/TCP/Newreno]
$tcp_(38) set class_ 2
set sink_(38) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(38)
$ns attach-agent $node_(3) $sink_(38)
$ns connect $tcp_(38) $sink_(38)
set ftp_(38) [new Application/FTP]
$ftp_(38) attach-agent $tcp_(38)
$ns at 540.2 "$ftp_(38) start"
$ns at 720.0 "$ftp_(38) stop"

#Set a TCP connection between node_(15) and node_(10)
set tcp_(39) [new Agent/TCP/Newreno]
$tcp_(39) set class_ 2
set sink_(39) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(39)
$ns attach-agent $node_(10) $sink_(39)
$ns connect $tcp_(39) $sink_(39)
set ftp_(39) [new Application/FTP]
$ftp_(39) attach-agent $tcp_(39)
$ns at 720.2 "$ftp_(39) start"
$ns at 900.0 "$ftp_(39) stop"

#Set a TCP connection between node_(43) and node_(22)
set tcp_(40) [new Agent/TCP/Newreno]
$tcp_(40) set class_ 2
set sink_(40) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(40)
$ns attach-agent $node_(22) $sink_(40)
$ns connect $tcp_(40) $sink_(40)
set ftp_(40) [new Application/FTP]
$ftp_(40) attach-agent $tcp_(40)
$ns at 0.2 "$ftp_(40) start"
$ns at 180.0 "$ftp_(40) stop"

#Set a TCP connection between node_(20) and node_(42)
set tcp_(41) [new Agent/TCP/Newreno]
$tcp_(41) set class_ 2
set sink_(41) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(41)
$ns attach-agent $node_(42) $sink_(41)
$ns connect $tcp_(41) $sink_(41)
set ftp_(41) [new Application/FTP]
$ftp_(41) attach-agent $tcp_(41)
$ns at 180.2 "$ftp_(41) start"
$ns at 360.0 "$ftp_(41) stop"

#Set a TCP connection between node_(43) and node_(36)
set tcp_(42) [new Agent/TCP/Newreno]
$tcp_(42) set class_ 2
set sink_(42) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(42)
$ns attach-agent $node_(36) $sink_(42)
$ns connect $tcp_(42) $sink_(42)
set ftp_(42) [new Application/FTP]
$ftp_(42) attach-agent $tcp_(42)
$ns at 360.2 "$ftp_(42) start"
$ns at 540.0 "$ftp_(42) stop"

#Set a TCP connection between node_(46) and node_(16)
set tcp_(43) [new Agent/TCP/Newreno]
$tcp_(43) set class_ 2
set sink_(43) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(43)
$ns attach-agent $node_(16) $sink_(43)
$ns connect $tcp_(43) $sink_(43)
set ftp_(43) [new Application/FTP]
$ftp_(43) attach-agent $tcp_(43)
$ns at 540.2 "$ftp_(43) start"
$ns at 720.0 "$ftp_(43) stop"

#Set a TCP connection between node_(33) and node_(21)
set tcp_(44) [new Agent/TCP/Newreno]
$tcp_(44) set class_ 2
set sink_(44) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(44)
$ns attach-agent $node_(21) $sink_(44)
$ns connect $tcp_(44) $sink_(44)
set ftp_(44) [new Application/FTP]
$ftp_(44) attach-agent $tcp_(44)
$ns at 720.2 "$ftp_(44) start"
$ns at 900.0 "$ftp_(44) stop"

#Set a TCP connection between node_(16) and node_(29)
set tcp_(45) [new Agent/TCP/Newreno]
$tcp_(45) set class_ 2
set sink_(45) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(45)
$ns attach-agent $node_(29) $sink_(45)
$ns connect $tcp_(45) $sink_(45)
set ftp_(45) [new Application/FTP]
$ftp_(45) attach-agent $tcp_(45)
$ns at 0.2 "$ftp_(45) start"
$ns at 180.0 "$ftp_(45) stop"

#Set a TCP connection between node_(38) and node_(44)
set tcp_(46) [new Agent/TCP/Newreno]
$tcp_(46) set class_ 2
set sink_(46) [new Agent/TCPSink]
$ns attach-agent $node_(38) $tcp_(46)
$ns attach-agent $node_(44) $sink_(46)
$ns connect $tcp_(46) $sink_(46)
set ftp_(46) [new Application/FTP]
$ftp_(46) attach-agent $tcp_(46)
$ns at 180.2 "$ftp_(46) start"
$ns at 360.0 "$ftp_(46) stop"

#Set a TCP connection between node_(18) and node_(45)
set tcp_(47) [new Agent/TCP/Newreno]
$tcp_(47) set class_ 2
set sink_(47) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(47)
$ns attach-agent $node_(45) $sink_(47)
$ns connect $tcp_(47) $sink_(47)
set ftp_(47) [new Application/FTP]
$ftp_(47) attach-agent $tcp_(47)
$ns at 360.2 "$ftp_(47) start"
$ns at 540.0 "$ftp_(47) stop"

#Set a TCP connection between node_(2) and node_(11)
set tcp_(48) [new Agent/TCP/Newreno]
$tcp_(48) set class_ 2
set sink_(48) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(48)
$ns attach-agent $node_(11) $sink_(48)
$ns connect $tcp_(48) $sink_(48)
set ftp_(48) [new Application/FTP]
$ftp_(48) attach-agent $tcp_(48)
$ns at 540.2 "$ftp_(48) start"
$ns at 720.0 "$ftp_(48) stop"

#Set a TCP connection between node_(21) and node_(23)
set tcp_(49) [new Agent/TCP/Newreno]
$tcp_(49) set class_ 2
set sink_(49) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(49)
$ns attach-agent $node_(23) $sink_(49)
$ns connect $tcp_(49) $sink_(49)
set ftp_(49) [new Application/FTP]
$ftp_(49) attach-agent $tcp_(49)
$ns at 720.2 "$ftp_(49) start"
$ns at 900.0 "$ftp_(49) stop"

#Set a TCP connection between node_(49) and node_(1)
set tcp_(50) [new Agent/TCP/Newreno]
$tcp_(50) set class_ 2
set sink_(50) [new Agent/TCPSink]
$ns attach-agent $node_(49) $tcp_(50)
$ns attach-agent $node_(1) $sink_(50)
$ns connect $tcp_(50) $sink_(50)
set ftp_(50) [new Application/FTP]
$ftp_(50) attach-agent $tcp_(50)
$ns at 0.2 "$ftp_(50) start"
$ns at 180.0 "$ftp_(50) stop"

#Set a TCP connection between node_(28) and node_(48)
set tcp_(51) [new Agent/TCP/Newreno]
$tcp_(51) set class_ 2
set sink_(51) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(51)
$ns attach-agent $node_(48) $sink_(51)
$ns connect $tcp_(51) $sink_(51)
set ftp_(51) [new Application/FTP]
$ftp_(51) attach-agent $tcp_(51)
$ns at 180.2 "$ftp_(51) start"
$ns at 360.0 "$ftp_(51) stop"

#Set a TCP connection between node_(31) and node_(17)
set tcp_(52) [new Agent/TCP/Newreno]
$tcp_(52) set class_ 2
set sink_(52) [new Agent/TCPSink]
$ns attach-agent $node_(31) $tcp_(52)
$ns attach-agent $node_(17) $sink_(52)
$ns connect $tcp_(52) $sink_(52)
set ftp_(52) [new Application/FTP]
$ftp_(52) attach-agent $tcp_(52)
$ns at 360.2 "$ftp_(52) start"
$ns at 540.0 "$ftp_(52) stop"

#Set a TCP connection between node_(13) and node_(45)
set tcp_(53) [new Agent/TCP/Newreno]
$tcp_(53) set class_ 2
set sink_(53) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(53)
$ns attach-agent $node_(45) $sink_(53)
$ns connect $tcp_(53) $sink_(53)
set ftp_(53) [new Application/FTP]
$ftp_(53) attach-agent $tcp_(53)
$ns at 540.2 "$ftp_(53) start"
$ns at 720.0 "$ftp_(53) stop"

#Set a TCP connection between node_(16) and node_(47)
set tcp_(54) [new Agent/TCP/Newreno]
$tcp_(54) set class_ 2
set sink_(54) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(54)
$ns attach-agent $node_(47) $sink_(54)
$ns connect $tcp_(54) $sink_(54)
set ftp_(54) [new Application/FTP]
$ftp_(54) attach-agent $tcp_(54)
$ns at 720.2 "$ftp_(54) start"
$ns at 900.0 "$ftp_(54) stop"

#Set a TCP connection between node_(29) and node_(0)
set tcp_(55) [new Agent/TCP/Newreno]
$tcp_(55) set class_ 2
set sink_(55) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(55)
$ns attach-agent $node_(0) $sink_(55)
$ns connect $tcp_(55) $sink_(55)
set ftp_(55) [new Application/FTP]
$ftp_(55) attach-agent $tcp_(55)
$ns at 0.2 "$ftp_(55) start"
$ns at 180.0 "$ftp_(55) stop"

#Set a TCP connection between node_(36) and node_(7)
set tcp_(56) [new Agent/TCP/Newreno]
$tcp_(56) set class_ 2
set sink_(56) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(56)
$ns attach-agent $node_(7) $sink_(56)
$ns connect $tcp_(56) $sink_(56)
set ftp_(56) [new Application/FTP]
$ftp_(56) attach-agent $tcp_(56)
$ns at 180.2 "$ftp_(56) start"
$ns at 360.0 "$ftp_(56) stop"

#Set a TCP connection between node_(48) and node_(35)
set tcp_(57) [new Agent/TCP/Newreno]
$tcp_(57) set class_ 2
set sink_(57) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(57)
$ns attach-agent $node_(35) $sink_(57)
$ns connect $tcp_(57) $sink_(57)
set ftp_(57) [new Application/FTP]
$ftp_(57) attach-agent $tcp_(57)
$ns at 360.2 "$ftp_(57) start"
$ns at 540.0 "$ftp_(57) stop"

#Set a TCP connection between node_(24) and node_(34)
set tcp_(58) [new Agent/TCP/Newreno]
$tcp_(58) set class_ 2
set sink_(58) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(58)
$ns attach-agent $node_(34) $sink_(58)
$ns connect $tcp_(58) $sink_(58)
set ftp_(58) [new Application/FTP]
$ftp_(58) attach-agent $tcp_(58)
$ns at 540.2 "$ftp_(58) start"
$ns at 720.0 "$ftp_(58) stop"

#Set a TCP connection between node_(35) and node_(39)
set tcp_(59) [new Agent/TCP/Newreno]
$tcp_(59) set class_ 2
set sink_(59) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(59)
$ns attach-agent $node_(39) $sink_(59)
$ns connect $tcp_(59) $sink_(59)
set ftp_(59) [new Application/FTP]
$ftp_(59) attach-agent $tcp_(59)
$ns at 720.2 "$ftp_(59) start"
$ns at 900.0 "$ftp_(59) stop"

#Set a TCP connection between node_(37) and node_(18)
set tcp_(60) [new Agent/TCP/Newreno]
$tcp_(60) set class_ 2
set sink_(60) [new Agent/TCPSink]
$ns attach-agent $node_(37) $tcp_(60)
$ns attach-agent $node_(18) $sink_(60)
$ns connect $tcp_(60) $sink_(60)
set ftp_(60) [new Application/FTP]
$ftp_(60) attach-agent $tcp_(60)
$ns at 0.2 "$ftp_(60) start"
$ns at 180.0 "$ftp_(60) stop"

#Set a TCP connection between node_(18) and node_(41)
set tcp_(61) [new Agent/TCP/Newreno]
$tcp_(61) set class_ 2
set sink_(61) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(61)
$ns attach-agent $node_(41) $sink_(61)
$ns connect $tcp_(61) $sink_(61)
set ftp_(61) [new Application/FTP]
$ftp_(61) attach-agent $tcp_(61)
$ns at 180.2 "$ftp_(61) start"
$ns at 360.0 "$ftp_(61) stop"

#Set a TCP connection between node_(44) and node_(46)
set tcp_(62) [new Agent/TCP/Newreno]
$tcp_(62) set class_ 2
set sink_(62) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(62)
$ns attach-agent $node_(46) $sink_(62)
$ns connect $tcp_(62) $sink_(62)
set ftp_(62) [new Application/FTP]
$ftp_(62) attach-agent $tcp_(62)
$ns at 360.2 "$ftp_(62) start"
$ns at 540.0 "$ftp_(62) stop"

#Set a TCP connection between node_(48) and node_(41)
set tcp_(63) [new Agent/TCP/Newreno]
$tcp_(63) set class_ 2
set sink_(63) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(63)
$ns attach-agent $node_(41) $sink_(63)
$ns connect $tcp_(63) $sink_(63)
set ftp_(63) [new Application/FTP]
$ftp_(63) attach-agent $tcp_(63)
$ns at 540.2 "$ftp_(63) start"
$ns at 720.0 "$ftp_(63) stop"

#Set a TCP connection between node_(26) and node_(0)
set tcp_(64) [new Agent/TCP/Newreno]
$tcp_(64) set class_ 2
set sink_(64) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(64)
$ns attach-agent $node_(0) $sink_(64)
$ns connect $tcp_(64) $sink_(64)
set ftp_(64) [new Application/FTP]
$ftp_(64) attach-agent $tcp_(64)
$ns at 720.2 "$ftp_(64) start"
$ns at 900.0 "$ftp_(64) stop"

#Set a TCP connection between node_(30) and node_(46)
set tcp_(65) [new Agent/TCP/Newreno]
$tcp_(65) set class_ 2
set sink_(65) [new Agent/TCPSink]
$ns attach-agent $node_(30) $tcp_(65)
$ns attach-agent $node_(46) $sink_(65)
$ns connect $tcp_(65) $sink_(65)
set ftp_(65) [new Application/FTP]
$ftp_(65) attach-agent $tcp_(65)
$ns at 0.2 "$ftp_(65) start"
$ns at 180.0 "$ftp_(65) stop"

#Set a TCP connection between node_(38) and node_(44)
set tcp_(66) [new Agent/TCP/Newreno]
$tcp_(66) set class_ 2
set sink_(66) [new Agent/TCPSink]
$ns attach-agent $node_(38) $tcp_(66)
$ns attach-agent $node_(44) $sink_(66)
$ns connect $tcp_(66) $sink_(66)
set ftp_(66) [new Application/FTP]
$ftp_(66) attach-agent $tcp_(66)
$ns at 180.2 "$ftp_(66) start"
$ns at 360.0 "$ftp_(66) stop"

#Set a TCP connection between node_(35) and node_(41)
set tcp_(67) [new Agent/TCP/Newreno]
$tcp_(67) set class_ 2
set sink_(67) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(67)
$ns attach-agent $node_(41) $sink_(67)
$ns connect $tcp_(67) $sink_(67)
set ftp_(67) [new Application/FTP]
$ftp_(67) attach-agent $tcp_(67)
$ns at 360.2 "$ftp_(67) start"
$ns at 540.0 "$ftp_(67) stop"

#Set a TCP connection between node_(44) and node_(18)
set tcp_(68) [new Agent/TCP/Newreno]
$tcp_(68) set class_ 2
set sink_(68) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(68)
$ns attach-agent $node_(18) $sink_(68)
$ns connect $tcp_(68) $sink_(68)
set ftp_(68) [new Application/FTP]
$ftp_(68) attach-agent $tcp_(68)
$ns at 540.2 "$ftp_(68) start"
$ns at 720.0 "$ftp_(68) stop"

#Set a TCP connection between node_(32) and node_(39)
set tcp_(69) [new Agent/TCP/Newreno]
$tcp_(69) set class_ 2
set sink_(69) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(69)
$ns attach-agent $node_(39) $sink_(69)
$ns connect $tcp_(69) $sink_(69)
set ftp_(69) [new Application/FTP]
$ftp_(69) attach-agent $tcp_(69)
$ns at 720.2 "$ftp_(69) start"
$ns at 900.0 "$ftp_(69) stop"

#Set a TCP connection between node_(33) and node_(12)
set tcp_(70) [new Agent/TCP/Newreno]
$tcp_(70) set class_ 2
set sink_(70) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(70)
$ns attach-agent $node_(12) $sink_(70)
$ns connect $tcp_(70) $sink_(70)
set ftp_(70) [new Application/FTP]
$ftp_(70) attach-agent $tcp_(70)
$ns at 0.2 "$ftp_(70) start"
$ns at 180.0 "$ftp_(70) stop"

#Set a TCP connection between node_(31) and node_(44)
set tcp_(71) [new Agent/TCP/Newreno]
$tcp_(71) set class_ 2
set sink_(71) [new Agent/TCPSink]
$ns attach-agent $node_(31) $tcp_(71)
$ns attach-agent $node_(44) $sink_(71)
$ns connect $tcp_(71) $sink_(71)
set ftp_(71) [new Application/FTP]
$ftp_(71) attach-agent $tcp_(71)
$ns at 180.2 "$ftp_(71) start"
$ns at 360.0 "$ftp_(71) stop"

#Set a TCP connection between node_(42) and node_(29)
set tcp_(72) [new Agent/TCP/Newreno]
$tcp_(72) set class_ 2
set sink_(72) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(72)
$ns attach-agent $node_(29) $sink_(72)
$ns connect $tcp_(72) $sink_(72)
set ftp_(72) [new Application/FTP]
$ftp_(72) attach-agent $tcp_(72)
$ns at 360.2 "$ftp_(72) start"
$ns at 540.0 "$ftp_(72) stop"

#Set a TCP connection between node_(35) and node_(9)
set tcp_(73) [new Agent/TCP/Newreno]
$tcp_(73) set class_ 2
set sink_(73) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(73)
$ns attach-agent $node_(9) $sink_(73)
$ns connect $tcp_(73) $sink_(73)
set ftp_(73) [new Application/FTP]
$ftp_(73) attach-agent $tcp_(73)
$ns at 540.2 "$ftp_(73) start"
$ns at 720.0 "$ftp_(73) stop"

#Set a TCP connection between node_(11) and node_(27)
set tcp_(74) [new Agent/TCP/Newreno]
$tcp_(74) set class_ 2
set sink_(74) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(74)
$ns attach-agent $node_(27) $sink_(74)
$ns connect $tcp_(74) $sink_(74)
set ftp_(74) [new Application/FTP]
$ftp_(74) attach-agent $tcp_(74)
$ns at 720.2 "$ftp_(74) start"
$ns at 900.0 "$ftp_(74) stop"

#Set a TCP connection between node_(13) and node_(23)
set tcp_(75) [new Agent/TCP/Newreno]
$tcp_(75) set class_ 2
set sink_(75) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(75)
$ns attach-agent $node_(23) $sink_(75)
$ns connect $tcp_(75) $sink_(75)
set ftp_(75) [new Application/FTP]
$ftp_(75) attach-agent $tcp_(75)
$ns at 0.2 "$ftp_(75) start"
$ns at 180.0 "$ftp_(75) stop"

#Set a TCP connection between node_(35) and node_(22)
set tcp_(76) [new Agent/TCP/Newreno]
$tcp_(76) set class_ 2
set sink_(76) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(76)
$ns attach-agent $node_(22) $sink_(76)
$ns connect $tcp_(76) $sink_(76)
set ftp_(76) [new Application/FTP]
$ftp_(76) attach-agent $tcp_(76)
$ns at 180.2 "$ftp_(76) start"
$ns at 360.0 "$ftp_(76) stop"

#Set a TCP connection between node_(24) and node_(11)
set tcp_(77) [new Agent/TCP/Newreno]
$tcp_(77) set class_ 2
set sink_(77) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(77)
$ns attach-agent $node_(11) $sink_(77)
$ns connect $tcp_(77) $sink_(77)
set ftp_(77) [new Application/FTP]
$ftp_(77) attach-agent $tcp_(77)
$ns at 360.2 "$ftp_(77) start"
$ns at 540.0 "$ftp_(77) stop"

#Set a TCP connection between node_(26) and node_(2)
set tcp_(78) [new Agent/TCP/Newreno]
$tcp_(78) set class_ 2
set sink_(78) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(78)
$ns attach-agent $node_(2) $sink_(78)
$ns connect $tcp_(78) $sink_(78)
set ftp_(78) [new Application/FTP]
$ftp_(78) attach-agent $tcp_(78)
$ns at 540.2 "$ftp_(78) start"
$ns at 720.0 "$ftp_(78) stop"

#Set a TCP connection between node_(30) and node_(19)
set tcp_(79) [new Agent/TCP/Newreno]
$tcp_(79) set class_ 2
set sink_(79) [new Agent/TCPSink]
$ns attach-agent $node_(30) $tcp_(79)
$ns attach-agent $node_(19) $sink_(79)
$ns connect $tcp_(79) $sink_(79)
set ftp_(79) [new Application/FTP]
$ftp_(79) attach-agent $tcp_(79)
$ns at 720.2 "$ftp_(79) start"
$ns at 900.0 "$ftp_(79) stop"

#Set a TCP connection between node_(35) and node_(20)
set tcp_(80) [new Agent/TCP/Newreno]
$tcp_(80) set class_ 2
set sink_(80) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(80)
$ns attach-agent $node_(20) $sink_(80)
$ns connect $tcp_(80) $sink_(80)
set ftp_(80) [new Application/FTP]
$ftp_(80) attach-agent $tcp_(80)
$ns at 0.2 "$ftp_(80) start"
$ns at 180.0 "$ftp_(80) stop"

#Set a TCP connection between node_(16) and node_(49)
set tcp_(81) [new Agent/TCP/Newreno]
$tcp_(81) set class_ 2
set sink_(81) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(81)
$ns attach-agent $node_(49) $sink_(81)
$ns connect $tcp_(81) $sink_(81)
set ftp_(81) [new Application/FTP]
$ftp_(81) attach-agent $tcp_(81)
$ns at 180.2 "$ftp_(81) start"
$ns at 360.0 "$ftp_(81) stop"

#Set a TCP connection between node_(6) and node_(21)
set tcp_(82) [new Agent/TCP/Newreno]
$tcp_(82) set class_ 2
set sink_(82) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(82)
$ns attach-agent $node_(21) $sink_(82)
$ns connect $tcp_(82) $sink_(82)
set ftp_(82) [new Application/FTP]
$ftp_(82) attach-agent $tcp_(82)
$ns at 360.2 "$ftp_(82) start"
$ns at 540.0 "$ftp_(82) stop"

#Set a TCP connection between node_(10) and node_(45)
set tcp_(83) [new Agent/TCP/Newreno]
$tcp_(83) set class_ 2
set sink_(83) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(83)
$ns attach-agent $node_(45) $sink_(83)
$ns connect $tcp_(83) $sink_(83)
set ftp_(83) [new Application/FTP]
$ftp_(83) attach-agent $tcp_(83)
$ns at 540.2 "$ftp_(83) start"
$ns at 720.0 "$ftp_(83) stop"

#Set a TCP connection between node_(32) and node_(43)
set tcp_(84) [new Agent/TCP/Newreno]
$tcp_(84) set class_ 2
set sink_(84) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(84)
$ns attach-agent $node_(43) $sink_(84)
$ns connect $tcp_(84) $sink_(84)
set ftp_(84) [new Application/FTP]
$ftp_(84) attach-agent $tcp_(84)
$ns at 720.2 "$ftp_(84) start"
$ns at 900.0 "$ftp_(84) stop"

#Set a TCP connection between node_(28) and node_(37)
set tcp_(85) [new Agent/TCP/Newreno]
$tcp_(85) set class_ 2
set sink_(85) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(85)
$ns attach-agent $node_(37) $sink_(85)
$ns connect $tcp_(85) $sink_(85)
set ftp_(85) [new Application/FTP]
$ftp_(85) attach-agent $tcp_(85)
$ns at 0.2 "$ftp_(85) start"
$ns at 180.0 "$ftp_(85) stop"

#Set a TCP connection between node_(18) and node_(42)
set tcp_(86) [new Agent/TCP/Newreno]
$tcp_(86) set class_ 2
set sink_(86) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(86)
$ns attach-agent $node_(42) $sink_(86)
$ns connect $tcp_(86) $sink_(86)
set ftp_(86) [new Application/FTP]
$ftp_(86) attach-agent $tcp_(86)
$ns at 180.2 "$ftp_(86) start"
$ns at 360.0 "$ftp_(86) stop"

#Set a TCP connection between node_(32) and node_(23)
set tcp_(87) [new Agent/TCP/Newreno]
$tcp_(87) set class_ 2
set sink_(87) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(87)
$ns attach-agent $node_(23) $sink_(87)
$ns connect $tcp_(87) $sink_(87)
set ftp_(87) [new Application/FTP]
$ftp_(87) attach-agent $tcp_(87)
$ns at 360.2 "$ftp_(87) start"
$ns at 540.0 "$ftp_(87) stop"

#Set a TCP connection between node_(48) and node_(3)
set tcp_(88) [new Agent/TCP/Newreno]
$tcp_(88) set class_ 2
set sink_(88) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(88)
$ns attach-agent $node_(3) $sink_(88)
$ns connect $tcp_(88) $sink_(88)
set ftp_(88) [new Application/FTP]
$ftp_(88) attach-agent $tcp_(88)
$ns at 540.2 "$ftp_(88) start"
$ns at 720.0 "$ftp_(88) stop"

#Set a TCP connection between node_(21) and node_(23)
set tcp_(89) [new Agent/TCP/Newreno]
$tcp_(89) set class_ 2
set sink_(89) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(89)
$ns attach-agent $node_(23) $sink_(89)
$ns connect $tcp_(89) $sink_(89)
set ftp_(89) [new Application/FTP]
$ftp_(89) attach-agent $tcp_(89)
$ns at 720.2 "$ftp_(89) start"
$ns at 900.0 "$ftp_(89) stop"

#Set a TCP connection between node_(45) and node_(18)
set tcp_(90) [new Agent/TCP/Newreno]
$tcp_(90) set class_ 2
set sink_(90) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(90)
$ns attach-agent $node_(18) $sink_(90)
$ns connect $tcp_(90) $sink_(90)
set ftp_(90) [new Application/FTP]
$ftp_(90) attach-agent $tcp_(90)
$ns at 0.2 "$ftp_(90) start"
$ns at 180.0 "$ftp_(90) stop"

#Set a TCP connection between node_(46) and node_(11)
set tcp_(91) [new Agent/TCP/Newreno]
$tcp_(91) set class_ 2
set sink_(91) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(91)
$ns attach-agent $node_(11) $sink_(91)
$ns connect $tcp_(91) $sink_(91)
set ftp_(91) [new Application/FTP]
$ftp_(91) attach-agent $tcp_(91)
$ns at 180.2 "$ftp_(91) start"
$ns at 360.0 "$ftp_(91) stop"

#Set a TCP connection between node_(22) and node_(28)
set tcp_(92) [new Agent/TCP/Newreno]
$tcp_(92) set class_ 2
set sink_(92) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(92)
$ns attach-agent $node_(28) $sink_(92)
$ns connect $tcp_(92) $sink_(92)
set ftp_(92) [new Application/FTP]
$ftp_(92) attach-agent $tcp_(92)
$ns at 360.2 "$ftp_(92) start"
$ns at 540.0 "$ftp_(92) stop"

#Set a TCP connection between node_(17) and node_(15)
set tcp_(93) [new Agent/TCP/Newreno]
$tcp_(93) set class_ 2
set sink_(93) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(93)
$ns attach-agent $node_(15) $sink_(93)
$ns connect $tcp_(93) $sink_(93)
set ftp_(93) [new Application/FTP]
$ftp_(93) attach-agent $tcp_(93)
$ns at 540.2 "$ftp_(93) start"
$ns at 720.0 "$ftp_(93) stop"

#Set a TCP connection between node_(28) and node_(34)
set tcp_(94) [new Agent/TCP/Newreno]
$tcp_(94) set class_ 2
set sink_(94) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(94)
$ns attach-agent $node_(34) $sink_(94)
$ns connect $tcp_(94) $sink_(94)
set ftp_(94) [new Application/FTP]
$ftp_(94) attach-agent $tcp_(94)
$ns at 720.2 "$ftp_(94) start"
$ns at 900.0 "$ftp_(94) stop"

#Set a TCP connection between node_(30) and node_(16)
set tcp_(95) [new Agent/TCP/Newreno]
$tcp_(95) set class_ 2
set sink_(95) [new Agent/TCPSink]
$ns attach-agent $node_(30) $tcp_(95)
$ns attach-agent $node_(16) $sink_(95)
$ns connect $tcp_(95) $sink_(95)
set ftp_(95) [new Application/FTP]
$ftp_(95) attach-agent $tcp_(95)
$ns at 0.2 "$ftp_(95) start"
$ns at 180.0 "$ftp_(95) stop"

#Set a TCP connection between node_(33) and node_(42)
set tcp_(96) [new Agent/TCP/Newreno]
$tcp_(96) set class_ 2
set sink_(96) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(96)
$ns attach-agent $node_(42) $sink_(96)
$ns connect $tcp_(96) $sink_(96)
set ftp_(96) [new Application/FTP]
$ftp_(96) attach-agent $tcp_(96)
$ns at 180.2 "$ftp_(96) start"
$ns at 360.0 "$ftp_(96) stop"

#Set a TCP connection between node_(42) and node_(13)
set tcp_(97) [new Agent/TCP/Newreno]
$tcp_(97) set class_ 2
set sink_(97) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(97)
$ns attach-agent $node_(13) $sink_(97)
$ns connect $tcp_(97) $sink_(97)
set ftp_(97) [new Application/FTP]
$ftp_(97) attach-agent $tcp_(97)
$ns at 360.2 "$ftp_(97) start"
$ns at 540.0 "$ftp_(97) stop"

#Set a TCP connection between node_(30) and node_(44)
set tcp_(98) [new Agent/TCP/Newreno]
$tcp_(98) set class_ 2
set sink_(98) [new Agent/TCPSink]
$ns attach-agent $node_(30) $tcp_(98)
$ns attach-agent $node_(44) $sink_(98)
$ns connect $tcp_(98) $sink_(98)
set ftp_(98) [new Application/FTP]
$ftp_(98) attach-agent $tcp_(98)
$ns at 540.2 "$ftp_(98) start"
$ns at 720.0 "$ftp_(98) stop"

#Set a TCP connection between node_(40) and node_(46)
set tcp_(99) [new Agent/TCP/Newreno]
$tcp_(99) set class_ 2
set sink_(99) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(99)
$ns attach-agent $node_(46) $sink_(99)
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
