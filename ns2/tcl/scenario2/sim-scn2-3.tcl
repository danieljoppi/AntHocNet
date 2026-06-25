#sim-scn2-3.tcl 
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
set tracefd       [open sim-scn2-3-$val(rp)-trace.tr w]
set windowVsTime2 [open sim-scn2-3-$val(rp)-win-.tr w]
set namtrace      [open sim-scn2-3-$val(rp).nam w]

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
$node_(0) set X_ 1165 
$node_(0) set Y_ 287 
$node_(0) set Z_ 0.0 
$node_(1) set X_ 91 
$node_(1) set Y_ 347 
$node_(1) set Z_ 0.0 
$node_(2) set X_ 1790 
$node_(2) set Y_ 326 
$node_(2) set Z_ 0.0 
$node_(3) set X_ 730 
$node_(3) set Y_ 471 
$node_(3) set Z_ 0.0 
$node_(4) set X_ 1417 
$node_(4) set Y_ 152 
$node_(4) set Z_ 0.0 
$node_(5) set X_ 1913 
$node_(5) set Y_ 209 
$node_(5) set Z_ 0.0 
$node_(6) set X_ 2680 
$node_(6) set Y_ 138 
$node_(6) set Z_ 0.0 
$node_(7) set X_ 1653 
$node_(7) set Y_ 853 
$node_(7) set Z_ 0.0 
$node_(8) set X_ 2647 
$node_(8) set Y_ 669 
$node_(8) set Z_ 0.0 
$node_(9) set X_ 543 
$node_(9) set Y_ 253 
$node_(9) set Z_ 0.0 
$node_(10) set X_ 431 
$node_(10) set Y_ 262 
$node_(10) set Z_ 0.0 
$node_(11) set X_ 269 
$node_(11) set Y_ 482 
$node_(11) set Z_ 0.0 
$node_(12) set X_ 1086 
$node_(12) set Y_ 798 
$node_(12) set Z_ 0.0 
$node_(13) set X_ 258 
$node_(13) set Y_ 588 
$node_(13) set Z_ 0.0 
$node_(14) set X_ 2660 
$node_(14) set Y_ 274 
$node_(14) set Z_ 0.0 
$node_(15) set X_ 2155 
$node_(15) set Y_ 94 
$node_(15) set Z_ 0.0 
$node_(16) set X_ 1826 
$node_(16) set Y_ 515 
$node_(16) set Z_ 0.0 
$node_(17) set X_ 1090 
$node_(17) set Y_ 666 
$node_(17) set Z_ 0.0 
$node_(18) set X_ 1264 
$node_(18) set Y_ 26 
$node_(18) set Z_ 0.0 
$node_(19) set X_ 1661 
$node_(19) set Y_ 271 
$node_(19) set Z_ 0.0 
$node_(20) set X_ 1934 
$node_(20) set Y_ 514 
$node_(20) set Z_ 0.0 
$node_(21) set X_ 2284 
$node_(21) set Y_ 246 
$node_(21) set Z_ 0.0 
$node_(22) set X_ 549 
$node_(22) set Y_ 665 
$node_(22) set Z_ 0.0 
$node_(23) set X_ 962 
$node_(23) set Y_ 923 
$node_(23) set Z_ 0.0 
$node_(24) set X_ 2993 
$node_(24) set Y_ 412 
$node_(24) set Z_ 0.0 
$node_(25) set X_ 1680 
$node_(25) set Y_ 824 
$node_(25) set Z_ 0.0 
$node_(26) set X_ 2024 
$node_(26) set Y_ 302 
$node_(26) set Z_ 0.0 
$node_(27) set X_ 1480 
$node_(27) set Y_ 24 
$node_(27) set Z_ 0.0 
$node_(28) set X_ 1463 
$node_(28) set Y_ 552 
$node_(28) set Z_ 0.0 
$node_(29) set X_ 1854 
$node_(29) set Y_ 933 
$node_(29) set Z_ 0.0 
$node_(30) set X_ 1123 
$node_(30) set Y_ 29 
$node_(30) set Z_ 0.0 
$node_(31) set X_ 1387 
$node_(31) set Y_ 644 
$node_(31) set Z_ 0.0 
$node_(32) set X_ 2017 
$node_(32) set Y_ 729 
$node_(32) set Z_ 0.0 
$node_(33) set X_ 1601 
$node_(33) set Y_ 973 
$node_(33) set Z_ 0.0 
$node_(34) set X_ 880 
$node_(34) set Y_ 249 
$node_(34) set Z_ 0.0 
$node_(35) set X_ 666 
$node_(35) set Y_ 530 
$node_(35) set Z_ 0.0 
$node_(36) set X_ 757 
$node_(36) set Y_ 423 
$node_(36) set Z_ 0.0 
$node_(37) set X_ 124 
$node_(37) set Y_ 429 
$node_(37) set Z_ 0.0 
$node_(38) set X_ 348 
$node_(38) set Y_ 520 
$node_(38) set Z_ 0.0 
$node_(39) set X_ 929 
$node_(39) set Y_ 772 
$node_(39) set Z_ 0.0 
$node_(40) set X_ 2959 
$node_(40) set Y_ 372 
$node_(40) set Z_ 0.0 
$node_(41) set X_ 2983 
$node_(41) set Y_ 665 
$node_(41) set Z_ 0.0 
$node_(42) set X_ 271 
$node_(42) set Y_ 376 
$node_(42) set Z_ 0.0 
$node_(43) set X_ 2978 
$node_(43) set Y_ 304 
$node_(43) set Z_ 0.0 
$node_(44) set X_ 2748 
$node_(44) set Y_ 561 
$node_(44) set Z_ 0.0 
$node_(45) set X_ 1676 
$node_(45) set Y_ 650 
$node_(45) set Z_ 0.0 
$node_(46) set X_ 302 
$node_(46) set Y_ 822 
$node_(46) set Z_ 0.0 
$node_(47) set X_ 2794 
$node_(47) set Y_ 277 
$node_(47) set Z_ 0.0 
$node_(48) set X_ 2867 
$node_(48) set Y_ 969 
$node_(48) set Z_ 0.0 
$node_(49) set X_ 1428 
$node_(49) set Y_ 289 
$node_(49) set Z_ 0.0 
$node_(50) set X_ 1792 
$node_(50) set Y_ 474 
$node_(50) set Z_ 0.0 
$node_(51) set X_ 2455 
$node_(51) set Y_ 568 
$node_(51) set Z_ 0.0 
$ns at 0.0 "$node_(51) off" 
$ns at 165.0 "$node_(51) on" 
$node_(52) set X_ 420 
$node_(52) set Y_ 649 
$node_(52) set Z_ 0.0 
$ns at 0.0 "$node_(52) off" 
$ns at 165.0 "$node_(52) on" 
$node_(53) set X_ 1519 
$node_(53) set Y_ 238 
$node_(53) set Z_ 0.0 
$ns at 0.0 "$node_(53) off" 
$ns at 165.0 "$node_(53) on" 
$node_(54) set X_ 910 
$node_(54) set Y_ 537 
$node_(54) set Z_ 0.0 
$ns at 0.0 "$node_(54) off" 
$ns at 165.0 "$node_(54) on" 
$node_(55) set X_ 2162 
$node_(55) set Y_ 934 
$node_(55) set Z_ 0.0 
$ns at 0.0 "$node_(55) off" 
$ns at 165.0 "$node_(55) on" 
$node_(56) set X_ 264 
$node_(56) set Y_ 971 
$node_(56) set Z_ 0.0 
$ns at 0.0 "$node_(56) off" 
$ns at 165.0 "$node_(56) on" 
$node_(57) set X_ 1265 
$node_(57) set Y_ 348 
$node_(57) set Z_ 0.0 
$ns at 0.0 "$node_(57) off" 
$ns at 165.0 "$node_(57) on" 
$node_(58) set X_ 2649 
$node_(58) set Y_ 90 
$node_(58) set Z_ 0.0 
$ns at 0.0 "$node_(58) off" 
$ns at 165.0 "$node_(58) on" 
$node_(59) set X_ 367 
$node_(59) set Y_ 601 
$node_(59) set Z_ 0.0 
$ns at 0.0 "$node_(59) off" 
$ns at 165.0 "$node_(59) on" 
$node_(60) set X_ 1441 
$node_(60) set Y_ 124 
$node_(60) set Z_ 0.0 
$ns at 0.0 "$node_(60) off" 
$ns at 165.0 "$node_(60) on" 
$node_(61) set X_ 463 
$node_(61) set Y_ 144 
$node_(61) set Z_ 0.0 
$ns at 0.0 "$node_(61) off" 
$ns at 165.0 "$node_(61) on" 
$node_(62) set X_ 2978 
$node_(62) set Y_ 377 
$node_(62) set Z_ 0.0 
$ns at 0.0 "$node_(62) off" 
$ns at 165.0 "$node_(62) on" 
$node_(63) set X_ 2700 
$node_(63) set Y_ 291 
$node_(63) set Z_ 0.0 
$ns at 0.0 "$node_(63) off" 
$ns at 165.0 "$node_(63) on" 
$node_(64) set X_ 1804 
$node_(64) set Y_ 186 
$node_(64) set Z_ 0.0 
$ns at 0.0 "$node_(64) off" 
$ns at 165.0 "$node_(64) on" 
$node_(65) set X_ 2916 
$node_(65) set Y_ 968 
$node_(65) set Z_ 0.0 
$ns at 0.0 "$node_(65) off" 
$ns at 165.0 "$node_(65) on" 
$node_(66) set X_ 1162 
$node_(66) set Y_ 62 
$node_(66) set Z_ 0.0 
$ns at 0.0 "$node_(66) off" 
$ns at 165.0 "$node_(66) on" 
$node_(67) set X_ 2165 
$node_(67) set Y_ 955 
$node_(67) set Z_ 0.0 
$ns at 0.0 "$node_(67) off" 
$ns at 165.0 "$node_(67) on" 
$node_(68) set X_ 736 
$node_(68) set Y_ 367 
$node_(68) set Z_ 0.0 
$ns at 0.0 "$node_(68) off" 
$ns at 165.0 "$node_(68) on" 
$node_(69) set X_ 2360 
$node_(69) set Y_ 694 
$node_(69) set Z_ 0.0 
$ns at 0.0 "$node_(69) off" 
$ns at 165.0 "$node_(69) on" 
$node_(70) set X_ 51 
$node_(70) set Y_ 658 
$node_(70) set Z_ 0.0 
$ns at 0.0 "$node_(70) off" 
$ns at 165.0 "$node_(70) on" 
$node_(71) set X_ 1822 
$node_(71) set Y_ 753 
$node_(71) set Z_ 0.0 
$ns at 0.0 "$node_(71) off" 
$ns at 165.0 "$node_(71) on" 
$node_(72) set X_ 1627 
$node_(72) set Y_ 240 
$node_(72) set Z_ 0.0 
$ns at 0.0 "$node_(72) off" 
$ns at 165.0 "$node_(72) on" 
$node_(73) set X_ 2891 
$node_(73) set Y_ 148 
$node_(73) set Z_ 0.0 
$ns at 0.0 "$node_(73) off" 
$ns at 165.0 "$node_(73) on" 
$node_(74) set X_ 833 
$node_(74) set Y_ 592 
$node_(74) set Z_ 0.0 
$ns at 0.0 "$node_(74) off" 
$ns at 165.0 "$node_(74) on" 
$node_(75) set X_ 1920 
$node_(75) set Y_ 22 
$node_(75) set Z_ 0.0 
$ns at 0.0 "$node_(75) off" 
$ns at 330.0 "$node_(75) on" 
$node_(76) set X_ 1488 
$node_(76) set Y_ 55 
$node_(76) set Z_ 0.0 
$ns at 0.0 "$node_(76) off" 
$ns at 330.0 "$node_(76) on" 
$node_(77) set X_ 727 
$node_(77) set Y_ 642 
$node_(77) set Z_ 0.0 
$ns at 0.0 "$node_(77) off" 
$ns at 330.0 "$node_(77) on" 
$node_(78) set X_ 2564 
$node_(78) set Y_ 591 
$node_(78) set Z_ 0.0 
$ns at 0.0 "$node_(78) off" 
$ns at 330.0 "$node_(78) on" 
$node_(79) set X_ 191 
$node_(79) set Y_ 273 
$node_(79) set Z_ 0.0 
$ns at 0.0 "$node_(79) off" 
$ns at 330.0 "$node_(79) on" 
$node_(80) set X_ 888 
$node_(80) set Y_ 457 
$node_(80) set Z_ 0.0 
$ns at 0.0 "$node_(80) off" 
$ns at 330.0 "$node_(80) on" 
$node_(81) set X_ 1902 
$node_(81) set Y_ 248 
$node_(81) set Z_ 0.0 
$ns at 0.0 "$node_(81) off" 
$ns at 330.0 "$node_(81) on" 
$node_(82) set X_ 2469 
$node_(82) set Y_ 383 
$node_(82) set Z_ 0.0 
$ns at 0.0 "$node_(82) off" 
$ns at 330.0 "$node_(82) on" 
$node_(83) set X_ 773 
$node_(83) set Y_ 477 
$node_(83) set Z_ 0.0 
$ns at 0.0 "$node_(83) off" 
$ns at 330.0 "$node_(83) on" 
$node_(84) set X_ 2074 
$node_(84) set Y_ 198 
$node_(84) set Z_ 0.0 
$ns at 0.0 "$node_(84) off" 
$ns at 330.0 "$node_(84) on" 
$node_(85) set X_ 1225 
$node_(85) set Y_ 721 
$node_(85) set Z_ 0.0 
$ns at 0.0 "$node_(85) off" 
$ns at 330.0 "$node_(85) on" 
$node_(86) set X_ 2814 
$node_(86) set Y_ 877 
$node_(86) set Z_ 0.0 
$ns at 0.0 "$node_(86) off" 
$ns at 330.0 "$node_(86) on" 
$node_(87) set X_ 975 
$node_(87) set Y_ 161 
$node_(87) set Z_ 0.0 
$ns at 0.0 "$node_(87) off" 
$ns at 330.0 "$node_(87) on" 
$node_(88) set X_ 2973 
$node_(88) set Y_ 671 
$node_(88) set Z_ 0.0 
$ns at 0.0 "$node_(88) off" 
$ns at 330.0 "$node_(88) on" 
$node_(89) set X_ 1595 
$node_(89) set Y_ 215 
$node_(89) set Z_ 0.0 
$ns at 0.0 "$node_(89) off" 
$ns at 330.0 "$node_(89) on" 
$node_(90) set X_ 868 
$node_(90) set Y_ 320 
$node_(90) set Z_ 0.0 
$ns at 0.0 "$node_(90) off" 
$ns at 330.0 "$node_(90) on" 
$node_(91) set X_ 861 
$node_(91) set Y_ 81 
$node_(91) set Z_ 0.0 
$ns at 0.0 "$node_(91) off" 
$ns at 330.0 "$node_(91) on" 
$node_(92) set X_ 1434 
$node_(92) set Y_ 349 
$node_(92) set Z_ 0.0 
$ns at 0.0 "$node_(92) off" 
$ns at 330.0 "$node_(92) on" 
$node_(93) set X_ 518 
$node_(93) set Y_ 173 
$node_(93) set Z_ 0.0 
$ns at 0.0 "$node_(93) off" 
$ns at 330.0 "$node_(93) on" 
$node_(94) set X_ 2230 
$node_(94) set Y_ 102 
$node_(94) set Z_ 0.0 
$ns at 0.0 "$node_(94) off" 
$ns at 330.0 "$node_(94) on" 
$node_(95) set X_ 340 
$node_(95) set Y_ 502 
$node_(95) set Z_ 0.0 
$ns at 0.0 "$node_(95) off" 
$ns at 330.0 "$node_(95) on" 
$node_(96) set X_ 898 
$node_(96) set Y_ 462 
$node_(96) set Z_ 0.0 
$ns at 0.0 "$node_(96) off" 
$ns at 330.0 "$node_(96) on" 
$node_(97) set X_ 407 
$node_(97) set Y_ 50 
$node_(97) set Z_ 0.0 
$ns at 0.0 "$node_(97) off" 
$ns at 330.0 "$node_(97) on" 
$node_(98) set X_ 2558 
$node_(98) set Y_ 199 
$node_(98) set Z_ 0.0 
$ns at 0.0 "$node_(98) off" 
$ns at 330.0 "$node_(98) on" 
$node_(99) set X_ 259 
$node_(99) set Y_ 340 
$node_(99) set Z_ 0.0 
$ns at 0.0 "$node_(99) off" 
$ns at 330.0 "$node_(99) on" 
$node_(100) set X_ 376 
$node_(100) set Y_ 490 
$node_(100) set Z_ 0.0 
$ns at 0.0 "$node_(100) off" 
$ns at 495.0 "$node_(100) on" 
$node_(101) set X_ 1008 
$node_(101) set Y_ 766 
$node_(101) set Z_ 0.0 
$ns at 0.0 "$node_(101) off" 
$ns at 495.0 "$node_(101) on" 
$node_(102) set X_ 460 
$node_(102) set Y_ 431 
$node_(102) set Z_ 0.0 
$ns at 0.0 "$node_(102) off" 
$ns at 495.0 "$node_(102) on" 
$node_(103) set X_ 694 
$node_(103) set Y_ 694 
$node_(103) set Z_ 0.0 
$ns at 0.0 "$node_(103) off" 
$ns at 495.0 "$node_(103) on" 
$node_(104) set X_ 394 
$node_(104) set Y_ 314 
$node_(104) set Z_ 0.0 
$ns at 0.0 "$node_(104) off" 
$ns at 495.0 "$node_(104) on" 
$node_(105) set X_ 2045 
$node_(105) set Y_ 7 
$node_(105) set Z_ 0.0 
$ns at 0.0 "$node_(105) off" 
$ns at 495.0 "$node_(105) on" 
$node_(106) set X_ 99 
$node_(106) set Y_ 15 
$node_(106) set Z_ 0.0 
$ns at 0.0 "$node_(106) off" 
$ns at 495.0 "$node_(106) on" 
$node_(107) set X_ 2404 
$node_(107) set Y_ 539 
$node_(107) set Z_ 0.0 
$ns at 0.0 "$node_(107) off" 
$ns at 495.0 "$node_(107) on" 
$node_(108) set X_ 313 
$node_(108) set Y_ 92 
$node_(108) set Z_ 0.0 
$ns at 0.0 "$node_(108) off" 
$ns at 495.0 "$node_(108) on" 
$node_(109) set X_ 2925 
$node_(109) set Y_ 811 
$node_(109) set Z_ 0.0 
$ns at 0.0 "$node_(109) off" 
$ns at 495.0 "$node_(109) on" 
$node_(110) set X_ 1763 
$node_(110) set Y_ 106 
$node_(110) set Z_ 0.0 
$ns at 0.0 "$node_(110) off" 
$ns at 495.0 "$node_(110) on" 
$node_(111) set X_ 179 
$node_(111) set Y_ 591 
$node_(111) set Z_ 0.0 
$ns at 0.0 "$node_(111) off" 
$ns at 495.0 "$node_(111) on" 
$node_(112) set X_ 2169 
$node_(112) set Y_ 207 
$node_(112) set Z_ 0.0 
$ns at 0.0 "$node_(112) off" 
$ns at 495.0 "$node_(112) on" 
$node_(113) set X_ 2081 
$node_(113) set Y_ 37 
$node_(113) set Z_ 0.0 
$ns at 0.0 "$node_(113) off" 
$ns at 495.0 "$node_(113) on" 
$node_(114) set X_ 445 
$node_(114) set Y_ 292 
$node_(114) set Z_ 0.0 
$ns at 0.0 "$node_(114) off" 
$ns at 495.0 "$node_(114) on" 
$node_(115) set X_ 2522 
$node_(115) set Y_ 627 
$node_(115) set Z_ 0.0 
$ns at 0.0 "$node_(115) off" 
$ns at 495.0 "$node_(115) on" 
$node_(116) set X_ 933 
$node_(116) set Y_ 856 
$node_(116) set Z_ 0.0 
$ns at 0.0 "$node_(116) off" 
$ns at 495.0 "$node_(116) on" 
$node_(117) set X_ 2307 
$node_(117) set Y_ 654 
$node_(117) set Z_ 0.0 
$ns at 0.0 "$node_(117) off" 
$ns at 495.0 "$node_(117) on" 
$node_(118) set X_ 1207 
$node_(118) set Y_ 241 
$node_(118) set Z_ 0.0 
$ns at 0.0 "$node_(118) off" 
$ns at 495.0 "$node_(118) on" 
$node_(119) set X_ 1905 
$node_(119) set Y_ 765 
$node_(119) set Z_ 0.0 
$ns at 0.0 "$node_(119) off" 
$ns at 495.0 "$node_(119) on" 
$node_(120) set X_ 1861 
$node_(120) set Y_ 125 
$node_(120) set Z_ 0.0 
$ns at 0.0 "$node_(120) off" 
$ns at 495.0 "$node_(120) on" 
$node_(121) set X_ 2170 
$node_(121) set Y_ 963 
$node_(121) set Z_ 0.0 
$ns at 0.0 "$node_(121) off" 
$ns at 495.0 "$node_(121) on" 
$node_(122) set X_ 854 
$node_(122) set Y_ 970 
$node_(122) set Z_ 0.0 
$ns at 0.0 "$node_(122) off" 
$ns at 495.0 "$node_(122) on" 
$node_(123) set X_ 546 
$node_(123) set Y_ 480 
$node_(123) set Z_ 0.0 
$ns at 0.0 "$node_(123) off" 
$ns at 495.0 "$node_(123) on" 
$node_(124) set X_ 1304 
$node_(124) set Y_ 622 
$node_(124) set Z_ 0.0 
$ns at 0.0 "$node_(124) off" 
$ns at 495.0 "$node_(124) on" 
$node_(125) set X_ 2335 
$node_(125) set Y_ 164 
$node_(125) set Z_ 0.0 
$ns at 0.0 "$node_(125) off" 
$ns at 660.0 "$node_(125) on" 
$node_(126) set X_ 184 
$node_(126) set Y_ 423 
$node_(126) set Z_ 0.0 
$ns at 0.0 "$node_(126) off" 
$ns at 660.0 "$node_(126) on" 
$node_(127) set X_ 2430 
$node_(127) set Y_ 381 
$node_(127) set Z_ 0.0 
$ns at 0.0 "$node_(127) off" 
$ns at 660.0 "$node_(127) on" 
$node_(128) set X_ 170 
$node_(128) set Y_ 999 
$node_(128) set Z_ 0.0 
$ns at 0.0 "$node_(128) off" 
$ns at 660.0 "$node_(128) on" 
$node_(129) set X_ 2395 
$node_(129) set Y_ 905 
$node_(129) set Z_ 0.0 
$ns at 0.0 "$node_(129) off" 
$ns at 660.0 "$node_(129) on" 
$node_(130) set X_ 872 
$node_(130) set Y_ 342 
$node_(130) set Z_ 0.0 
$ns at 0.0 "$node_(130) off" 
$ns at 660.0 "$node_(130) on" 
$node_(131) set X_ 37 
$node_(131) set Y_ 9 
$node_(131) set Z_ 0.0 
$ns at 0.0 "$node_(131) off" 
$ns at 660.0 "$node_(131) on" 
$node_(132) set X_ 2908 
$node_(132) set Y_ 960 
$node_(132) set Z_ 0.0 
$ns at 0.0 "$node_(132) off" 
$ns at 660.0 "$node_(132) on" 
$node_(133) set X_ 551 
$node_(133) set Y_ 709 
$node_(133) set Z_ 0.0 
$ns at 0.0 "$node_(133) off" 
$ns at 660.0 "$node_(133) on" 
$node_(134) set X_ 1723 
$node_(134) set Y_ 608 
$node_(134) set Z_ 0.0 
$ns at 0.0 "$node_(134) off" 
$ns at 660.0 "$node_(134) on" 
$node_(135) set X_ 2991 
$node_(135) set Y_ 181 
$node_(135) set Z_ 0.0 
$ns at 0.0 "$node_(135) off" 
$ns at 660.0 "$node_(135) on" 
$node_(136) set X_ 679 
$node_(136) set Y_ 567 
$node_(136) set Z_ 0.0 
$ns at 0.0 "$node_(136) off" 
$ns at 660.0 "$node_(136) on" 
$node_(137) set X_ 223 
$node_(137) set Y_ 430 
$node_(137) set Z_ 0.0 
$ns at 0.0 "$node_(137) off" 
$ns at 660.0 "$node_(137) on" 
$node_(138) set X_ 864 
$node_(138) set Y_ 537 
$node_(138) set Z_ 0.0 
$ns at 0.0 "$node_(138) off" 
$ns at 660.0 "$node_(138) on" 
$node_(139) set X_ 597 
$node_(139) set Y_ 649 
$node_(139) set Z_ 0.0 
$ns at 0.0 "$node_(139) off" 
$ns at 660.0 "$node_(139) on" 
$node_(140) set X_ 1120 
$node_(140) set Y_ 937 
$node_(140) set Z_ 0.0 
$ns at 0.0 "$node_(140) off" 
$ns at 660.0 "$node_(140) on" 
$node_(141) set X_ 1439 
$node_(141) set Y_ 115 
$node_(141) set Z_ 0.0 
$ns at 0.0 "$node_(141) off" 
$ns at 660.0 "$node_(141) on" 
$node_(142) set X_ 2119 
$node_(142) set Y_ 819 
$node_(142) set Z_ 0.0 
$ns at 0.0 "$node_(142) off" 
$ns at 660.0 "$node_(142) on" 
$node_(143) set X_ 2976 
$node_(143) set Y_ 89 
$node_(143) set Z_ 0.0 
$ns at 0.0 "$node_(143) off" 
$ns at 660.0 "$node_(143) on" 
$node_(144) set X_ 2848 
$node_(144) set Y_ 668 
$node_(144) set Z_ 0.0 
$ns at 0.0 "$node_(144) off" 
$ns at 660.0 "$node_(144) on" 
$node_(145) set X_ 590 
$node_(145) set Y_ 946 
$node_(145) set Z_ 0.0 
$ns at 0.0 "$node_(145) off" 
$ns at 660.0 "$node_(145) on" 
$node_(146) set X_ 610 
$node_(146) set Y_ 62 
$node_(146) set Z_ 0.0 
$ns at 0.0 "$node_(146) off" 
$ns at 660.0 "$node_(146) on" 
$node_(147) set X_ 275 
$node_(147) set Y_ 699 
$node_(147) set Z_ 0.0 
$ns at 0.0 "$node_(147) off" 
$ns at 660.0 "$node_(147) on" 
$node_(148) set X_ 2606 
$node_(148) set Y_ 554 
$node_(148) set Z_ 0.0 
$ns at 0.0 "$node_(148) off" 
$ns at 660.0 "$node_(148) on" 
$node_(149) set X_ 1883 
$node_(149) set Y_ 119 
$node_(149) set Z_ 0.0 
$ns at 0.0 "$node_(149) off" 
$ns at 660.0 "$node_(149) on" 

# Generation of movements
$ns at 0.0 "$node_(0) setdest 1367 151 8.0" 
$ns at 103.45313363730979 "$node_(0) setdest 704 455 17.0" 
$ns at 276.19065603779904 "$node_(0) setdest 2453 883 3.0" 
$ns at 307.17878733303564 "$node_(0) setdest 1163 364 13.0" 
$ns at 442.12327394095917 "$node_(0) setdest 908 568 1.0" 
$ns at 479.1590136696191 "$node_(0) setdest 705 40 2.0" 
$ns at 525.9907297297092 "$node_(0) setdest 2513 573 19.0" 
$ns at 682.5894326908833 "$node_(0) setdest 496 764 5.0" 
$ns at 739.787122886611 "$node_(0) setdest 2179 5 3.0" 
$ns at 773.9435216000961 "$node_(0) setdest 295 59 16.0" 
$ns at 826.0621626751315 "$node_(0) setdest 1457 992 18.0" 
$ns at 0.0 "$node_(1) setdest 1416 462 15.0" 
$ns at 162.85645092889706 "$node_(1) setdest 1476 271 9.0" 
$ns at 249.5148396872451 "$node_(1) setdest 637 665 16.0" 
$ns at 394.46691414157374 "$node_(1) setdest 321 36 10.0" 
$ns at 433.2146417177515 "$node_(1) setdest 2987 622 3.0" 
$ns at 492.7924956350611 "$node_(1) setdest 624 256 19.0" 
$ns at 610.668826123079 "$node_(1) setdest 1032 448 6.0" 
$ns at 668.2178917727488 "$node_(1) setdest 906 922 3.0" 
$ns at 723.8113777733026 "$node_(1) setdest 1093 186 10.0" 
$ns at 852.5113453608607 "$node_(1) setdest 1950 927 11.0" 
$ns at 0.0 "$node_(2) setdest 520 783 1.0" 
$ns at 34.492523891357976 "$node_(2) setdest 214 533 11.0" 
$ns at 70.98654449199138 "$node_(2) setdest 948 861 7.0" 
$ns at 164.04467046077124 "$node_(2) setdest 1079 640 16.0" 
$ns at 272.2287517189088 "$node_(2) setdest 2169 94 14.0" 
$ns at 309.4805002598856 "$node_(2) setdest 1456 309 16.0" 
$ns at 374.8538530288809 "$node_(2) setdest 35 300 11.0" 
$ns at 457.3953629988294 "$node_(2) setdest 21 244 1.0" 
$ns at 494.76649067534936 "$node_(2) setdest 541 556 11.0" 
$ns at 547.2518993333534 "$node_(2) setdest 1115 194 18.0" 
$ns at 676.9258507742347 "$node_(2) setdest 2981 941 2.0" 
$ns at 718.1877912640907 "$node_(2) setdest 80 483 14.0" 
$ns at 827.2053688389994 "$node_(2) setdest 1848 715 2.0" 
$ns at 866.3659238428794 "$node_(2) setdest 1564 124 20.0" 
$ns at 0.0 "$node_(3) setdest 861 36 9.0" 
$ns at 69.92270035647229 "$node_(3) setdest 64 211 6.0" 
$ns at 107.04586507753405 "$node_(3) setdest 286 536 16.0" 
$ns at 177.66823422736604 "$node_(3) setdest 2746 578 18.0" 
$ns at 320.8666051509034 "$node_(3) setdest 443 344 10.0" 
$ns at 418.8620835832353 "$node_(3) setdest 1307 893 5.0" 
$ns at 489.1900902942373 "$node_(3) setdest 2058 378 2.0" 
$ns at 537.9670986502712 "$node_(3) setdest 1415 673 17.0" 
$ns at 675.9586800248107 "$node_(3) setdest 2860 7 13.0" 
$ns at 826.7804937640224 "$node_(3) setdest 1 916 12.0" 
$ns at 887.0722590132214 "$node_(3) setdest 2575 391 12.0" 
$ns at 0.0 "$node_(4) setdest 2428 306 19.0" 
$ns at 198.0081181442634 "$node_(4) setdest 2219 102 3.0" 
$ns at 235.67841806626947 "$node_(4) setdest 1329 201 11.0" 
$ns at 306.5667820252131 "$node_(4) setdest 2345 844 16.0" 
$ns at 360.7588775939839 "$node_(4) setdest 1606 857 19.0" 
$ns at 401.79025399165357 "$node_(4) setdest 2642 364 6.0" 
$ns at 457.4466827783891 "$node_(4) setdest 2919 609 15.0" 
$ns at 495.97443237880003 "$node_(4) setdest 44 876 1.0" 
$ns at 529.7130048988257 "$node_(4) setdest 1640 936 6.0" 
$ns at 569.9257250515308 "$node_(4) setdest 1244 590 8.0" 
$ns at 656.3929352868515 "$node_(4) setdest 93 656 10.0" 
$ns at 784.0765076290822 "$node_(4) setdest 272 170 7.0" 
$ns at 819.3050884530207 "$node_(4) setdest 2572 677 14.0" 
$ns at 0.0 "$node_(5) setdest 1537 213 8.0" 
$ns at 79.43301412945158 "$node_(5) setdest 2438 22 16.0" 
$ns at 267.8233400053654 "$node_(5) setdest 1486 61 5.0" 
$ns at 307.71177380338406 "$node_(5) setdest 1318 94 9.0" 
$ns at 386.8202195395678 "$node_(5) setdest 1776 558 7.0" 
$ns at 432.33116715513114 "$node_(5) setdest 170 367 4.0" 
$ns at 489.1214839101971 "$node_(5) setdest 1627 557 9.0" 
$ns at 536.0761973198485 "$node_(5) setdest 1763 981 3.0" 
$ns at 594.6328963959145 "$node_(5) setdest 1736 271 4.0" 
$ns at 638.8912068336981 "$node_(5) setdest 1825 939 7.0" 
$ns at 700.0074877508514 "$node_(5) setdest 1926 801 13.0" 
$ns at 752.9335419426003 "$node_(5) setdest 908 859 5.0" 
$ns at 807.2341512885969 "$node_(5) setdest 2419 420 15.0" 
$ns at 894.8148093098305 "$node_(5) setdest 740 494 12.0" 
$ns at 0.0 "$node_(6) setdest 1388 446 3.0" 
$ns at 56.9258301966014 "$node_(6) setdest 576 481 19.0" 
$ns at 274.7028859932947 "$node_(6) setdest 197 781 1.0" 
$ns at 313.853726170467 "$node_(6) setdest 858 8 10.0" 
$ns at 383.23203507221496 "$node_(6) setdest 1469 462 11.0" 
$ns at 507.1306515469814 "$node_(6) setdest 1177 385 15.0" 
$ns at 588.3269196739826 "$node_(6) setdest 893 788 10.0" 
$ns at 621.1005356242925 "$node_(6) setdest 1335 692 12.0" 
$ns at 715.6194525794325 "$node_(6) setdest 1428 869 3.0" 
$ns at 751.9292594190965 "$node_(6) setdest 32 997 14.0" 
$ns at 843.9713697042304 "$node_(6) setdest 1286 670 18.0" 
$ns at 0.0 "$node_(7) setdest 1449 812 17.0" 
$ns at 78.75748328007312 "$node_(7) setdest 872 892 15.0" 
$ns at 248.80809310224657 "$node_(7) setdest 1757 786 1.0" 
$ns at 279.24924716001846 "$node_(7) setdest 2559 257 17.0" 
$ns at 369.86339620519647 "$node_(7) setdest 333 802 2.0" 
$ns at 417.80663137361535 "$node_(7) setdest 1975 47 19.0" 
$ns at 574.1001865016103 "$node_(7) setdest 203 968 10.0" 
$ns at 698.7454475082466 "$node_(7) setdest 176 962 2.0" 
$ns at 745.6252134433195 "$node_(7) setdest 2002 185 1.0" 
$ns at 777.565788664565 "$node_(7) setdest 888 647 13.0" 
$ns at 0.0 "$node_(8) setdest 2457 264 6.0" 
$ns at 34.05523109022737 "$node_(8) setdest 2692 445 13.0" 
$ns at 103.8730661307957 "$node_(8) setdest 197 793 9.0" 
$ns at 134.28108682596962 "$node_(8) setdest 2827 239 12.0" 
$ns at 224.8865877847402 "$node_(8) setdest 396 206 10.0" 
$ns at 341.5370727319511 "$node_(8) setdest 2997 440 3.0" 
$ns at 386.23001822752866 "$node_(8) setdest 1535 781 17.0" 
$ns at 450.720817349892 "$node_(8) setdest 2348 463 8.0" 
$ns at 519.0757667136191 "$node_(8) setdest 2310 493 5.0" 
$ns at 580.7489017466042 "$node_(8) setdest 2499 275 16.0" 
$ns at 636.3114964676707 "$node_(8) setdest 1466 955 6.0" 
$ns at 718.4826190785336 "$node_(8) setdest 2305 841 8.0" 
$ns at 757.2005448549248 "$node_(8) setdest 74 900 4.0" 
$ns at 792.9194998506264 "$node_(8) setdest 2730 554 19.0" 
$ns at 0.0 "$node_(9) setdest 1544 889 14.0" 
$ns at 38.828125247507295 "$node_(9) setdest 994 983 8.0" 
$ns at 98.39470560236649 "$node_(9) setdest 2383 239 16.0" 
$ns at 155.60645005301708 "$node_(9) setdest 1897 516 5.0" 
$ns at 206.15179707679619 "$node_(9) setdest 497 345 9.0" 
$ns at 299.6710854138191 "$node_(9) setdest 2970 732 5.0" 
$ns at 362.8756900170633 "$node_(9) setdest 543 869 7.0" 
$ns at 418.7662625910745 "$node_(9) setdest 856 583 3.0" 
$ns at 456.84536376128256 "$node_(9) setdest 2620 502 2.0" 
$ns at 488.49020555567535 "$node_(9) setdest 1067 724 18.0" 
$ns at 674.1673786897028 "$node_(9) setdest 326 253 20.0" 
$ns at 708.237596444943 "$node_(9) setdest 2031 564 19.0" 
$ns at 0.0 "$node_(10) setdest 2957 473 19.0" 
$ns at 115.75737265898833 "$node_(10) setdest 78 877 14.0" 
$ns at 159.02214125793563 "$node_(10) setdest 1374 72 19.0" 
$ns at 213.4445745319704 "$node_(10) setdest 2755 51 18.0" 
$ns at 402.33396560549835 "$node_(10) setdest 1814 634 7.0" 
$ns at 451.3410346452535 "$node_(10) setdest 2641 308 6.0" 
$ns at 526.1123861641897 "$node_(10) setdest 676 389 19.0" 
$ns at 632.0811833873979 "$node_(10) setdest 2552 481 19.0" 
$ns at 675.9488647559093 "$node_(10) setdest 2061 248 15.0" 
$ns at 786.8383154987775 "$node_(10) setdest 791 172 18.0" 
$ns at 859.8210504232709 "$node_(10) setdest 586 358 10.0" 
$ns at 0.0 "$node_(11) setdest 1850 381 17.0" 
$ns at 107.5769609122827 "$node_(11) setdest 2756 888 18.0" 
$ns at 270.9456850814468 "$node_(11) setdest 1707 931 2.0" 
$ns at 301.2464960025639 "$node_(11) setdest 1915 992 9.0" 
$ns at 385.66800799741134 "$node_(11) setdest 2631 281 7.0" 
$ns at 472.063452074639 "$node_(11) setdest 2567 169 7.0" 
$ns at 566.3175507170931 "$node_(11) setdest 2138 544 2.0" 
$ns at 601.8042651283823 "$node_(11) setdest 1572 473 8.0" 
$ns at 651.9236134610084 "$node_(11) setdest 508 810 1.0" 
$ns at 683.9322827555329 "$node_(11) setdest 2516 272 8.0" 
$ns at 741.5256215180027 "$node_(11) setdest 10 87 9.0" 
$ns at 856.6049495478849 "$node_(11) setdest 2269 523 9.0" 
$ns at 0.0 "$node_(12) setdest 2741 464 14.0" 
$ns at 38.11078623641104 "$node_(12) setdest 515 771 11.0" 
$ns at 103.49465559945031 "$node_(12) setdest 2724 299 1.0" 
$ns at 137.45969240138334 "$node_(12) setdest 2780 315 19.0" 
$ns at 207.80283606178816 "$node_(12) setdest 1684 549 12.0" 
$ns at 255.32867430092662 "$node_(12) setdest 226 266 11.0" 
$ns at 348.8933956021297 "$node_(12) setdest 631 545 19.0" 
$ns at 452.0605279318538 "$node_(12) setdest 263 442 3.0" 
$ns at 484.3470904901369 "$node_(12) setdest 1171 805 5.0" 
$ns at 519.0062573091487 "$node_(12) setdest 2719 311 18.0" 
$ns at 691.4466429760412 "$node_(12) setdest 192 721 4.0" 
$ns at 751.2146065734594 "$node_(12) setdest 138 437 2.0" 
$ns at 787.4964863016976 "$node_(12) setdest 1323 197 4.0" 
$ns at 852.6921489844273 "$node_(12) setdest 444 143 13.0" 
$ns at 0.0 "$node_(13) setdest 1324 568 11.0" 
$ns at 63.91106612961435 "$node_(13) setdest 2026 337 16.0" 
$ns at 207.57004946832538 "$node_(13) setdest 304 390 5.0" 
$ns at 278.63970944564807 "$node_(13) setdest 2008 717 2.0" 
$ns at 317.5330358422491 "$node_(13) setdest 1428 923 6.0" 
$ns at 382.14446755641376 "$node_(13) setdest 2239 806 20.0" 
$ns at 576.1495251326843 "$node_(13) setdest 2502 397 5.0" 
$ns at 633.0466239072749 "$node_(13) setdest 2267 533 16.0" 
$ns at 700.0028264702729 "$node_(13) setdest 601 390 17.0" 
$ns at 834.8101344292794 "$node_(13) setdest 2343 303 9.0" 
$ns at 871.1840953014439 "$node_(13) setdest 1639 899 6.0" 
$ns at 0.0 "$node_(14) setdest 1217 775 12.0" 
$ns at 89.62615264423036 "$node_(14) setdest 528 940 8.0" 
$ns at 175.72247986735113 "$node_(14) setdest 1263 804 2.0" 
$ns at 210.2979985364754 "$node_(14) setdest 331 750 15.0" 
$ns at 246.67882983969105 "$node_(14) setdest 1203 241 6.0" 
$ns at 300.6317316397066 "$node_(14) setdest 1566 937 11.0" 
$ns at 351.62130087453727 "$node_(14) setdest 2461 572 7.0" 
$ns at 432.5064954321085 "$node_(14) setdest 1561 146 10.0" 
$ns at 479.0573463605495 "$node_(14) setdest 1929 576 12.0" 
$ns at 572.7989921725924 "$node_(14) setdest 2502 84 15.0" 
$ns at 625.0011522324392 "$node_(14) setdest 1661 482 10.0" 
$ns at 690.7416085051702 "$node_(14) setdest 601 979 17.0" 
$ns at 821.3938300073339 "$node_(14) setdest 783 313 3.0" 
$ns at 858.4009435325889 "$node_(14) setdest 1502 804 1.0" 
$ns at 890.3348699267692 "$node_(14) setdest 1641 393 20.0" 
$ns at 0.0 "$node_(15) setdest 2863 862 2.0" 
$ns at 42.26015264525923 "$node_(15) setdest 2965 204 5.0" 
$ns at 73.22120262938633 "$node_(15) setdest 2738 539 7.0" 
$ns at 110.14204916968802 "$node_(15) setdest 1578 71 5.0" 
$ns at 173.86137843329178 "$node_(15) setdest 179 333 12.0" 
$ns at 251.89006179834232 "$node_(15) setdest 928 359 15.0" 
$ns at 373.50465583152913 "$node_(15) setdest 202 477 16.0" 
$ns at 502.6074073657914 "$node_(15) setdest 1460 164 1.0" 
$ns at 533.155953742325 "$node_(15) setdest 22 733 1.0" 
$ns at 572.1076579403164 "$node_(15) setdest 2625 682 4.0" 
$ns at 605.7740163699117 "$node_(15) setdest 207 208 8.0" 
$ns at 640.8071318517472 "$node_(15) setdest 2039 729 7.0" 
$ns at 732.5906714224785 "$node_(15) setdest 1156 256 16.0" 
$ns at 872.2393824906153 "$node_(15) setdest 2067 112 5.0" 
$ns at 0.0 "$node_(16) setdest 59 803 2.0" 
$ns at 31.97299106742937 "$node_(16) setdest 1868 808 1.0" 
$ns at 70.38019437464331 "$node_(16) setdest 1220 685 10.0" 
$ns at 137.29427779036382 "$node_(16) setdest 1683 162 1.0" 
$ns at 172.88067490223017 "$node_(16) setdest 2429 817 6.0" 
$ns at 221.09762892272076 "$node_(16) setdest 1872 554 13.0" 
$ns at 348.91524831993445 "$node_(16) setdest 1747 292 1.0" 
$ns at 388.00881148894547 "$node_(16) setdest 1001 254 14.0" 
$ns at 482.5493829271487 "$node_(16) setdest 896 722 17.0" 
$ns at 673.6162759219924 "$node_(16) setdest 992 407 12.0" 
$ns at 801.5797181540701 "$node_(16) setdest 116 422 10.0" 
$ns at 879.0062946426646 "$node_(16) setdest 1123 367 11.0" 
$ns at 0.0 "$node_(17) setdest 1179 260 11.0" 
$ns at 86.70745839509424 "$node_(17) setdest 2387 830 20.0" 
$ns at 157.63203755174015 "$node_(17) setdest 2935 249 8.0" 
$ns at 209.03720975414382 "$node_(17) setdest 2520 475 11.0" 
$ns at 330.8289210332194 "$node_(17) setdest 1554 230 3.0" 
$ns at 374.9378266250987 "$node_(17) setdest 1686 79 16.0" 
$ns at 488.86188083830336 "$node_(17) setdest 2366 210 3.0" 
$ns at 544.2524638221712 "$node_(17) setdest 632 289 15.0" 
$ns at 602.3509220984882 "$node_(17) setdest 2949 195 9.0" 
$ns at 699.9425628969366 "$node_(17) setdest 809 540 20.0" 
$ns at 858.6188952423872 "$node_(17) setdest 871 610 16.0" 
$ns at 0.0 "$node_(18) setdest 1771 799 13.0" 
$ns at 107.04171629548128 "$node_(18) setdest 2228 614 9.0" 
$ns at 183.08986378449697 "$node_(18) setdest 838 107 18.0" 
$ns at 280.8882869305331 "$node_(18) setdest 1901 913 16.0" 
$ns at 419.9967655505558 "$node_(18) setdest 843 122 6.0" 
$ns at 453.0778620539535 "$node_(18) setdest 156 901 6.0" 
$ns at 518.902899138869 "$node_(18) setdest 2453 116 11.0" 
$ns at 608.2364604008933 "$node_(18) setdest 1018 195 4.0" 
$ns at 658.9599275667506 "$node_(18) setdest 370 143 6.0" 
$ns at 741.8933902498718 "$node_(18) setdest 1549 915 10.0" 
$ns at 797.6621280499443 "$node_(18) setdest 421 324 1.0" 
$ns at 836.2712988892854 "$node_(18) setdest 2945 283 16.0" 
$ns at 0.0 "$node_(19) setdest 324 462 8.0" 
$ns at 70.4472422743871 "$node_(19) setdest 104 367 11.0" 
$ns at 166.67309821975195 "$node_(19) setdest 652 445 1.0" 
$ns at 199.30115929845877 "$node_(19) setdest 55 67 13.0" 
$ns at 277.332228773548 "$node_(19) setdest 2272 140 8.0" 
$ns at 374.57465720714055 "$node_(19) setdest 419 659 3.0" 
$ns at 413.21736511863185 "$node_(19) setdest 1300 736 12.0" 
$ns at 443.2386958557745 "$node_(19) setdest 789 489 18.0" 
$ns at 521.6203751956331 "$node_(19) setdest 2322 746 9.0" 
$ns at 624.9944244183862 "$node_(19) setdest 691 648 16.0" 
$ns at 807.373771282578 "$node_(19) setdest 2439 126 10.0" 
$ns at 853.9961262997491 "$node_(19) setdest 1516 703 11.0" 
$ns at 884.1791388267372 "$node_(19) setdest 1387 206 6.0" 
$ns at 0.0 "$node_(20) setdest 599 829 17.0" 
$ns at 179.21993775785563 "$node_(20) setdest 783 408 7.0" 
$ns at 213.42275257060427 "$node_(20) setdest 2314 913 14.0" 
$ns at 382.7278292315064 "$node_(20) setdest 1251 947 10.0" 
$ns at 442.5427154151728 "$node_(20) setdest 2872 458 2.0" 
$ns at 480.529730590452 "$node_(20) setdest 975 971 2.0" 
$ns at 528.8845157508867 "$node_(20) setdest 2196 393 14.0" 
$ns at 609.860601946514 "$node_(20) setdest 2944 853 7.0" 
$ns at 702.0242372032317 "$node_(20) setdest 1041 86 15.0" 
$ns at 814.3167844224532 "$node_(20) setdest 2926 590 7.0" 
$ns at 879.7954380952372 "$node_(20) setdest 2262 175 15.0" 
$ns at 0.0 "$node_(21) setdest 2933 512 12.0" 
$ns at 41.40604023380037 "$node_(21) setdest 2870 25 15.0" 
$ns at 136.79602871135438 "$node_(21) setdest 2724 763 19.0" 
$ns at 182.74295581207934 "$node_(21) setdest 291 912 16.0" 
$ns at 264.72666670669685 "$node_(21) setdest 609 264 3.0" 
$ns at 310.1473928358238 "$node_(21) setdest 975 245 17.0" 
$ns at 488.27030624545307 "$node_(21) setdest 2587 99 10.0" 
$ns at 539.8348387406426 "$node_(21) setdest 2259 427 2.0" 
$ns at 576.5813097314501 "$node_(21) setdest 593 558 10.0" 
$ns at 625.6155051113711 "$node_(21) setdest 129 183 18.0" 
$ns at 785.8353276927394 "$node_(21) setdest 1387 260 4.0" 
$ns at 854.3502181486718 "$node_(21) setdest 1300 425 18.0" 
$ns at 0.0 "$node_(22) setdest 2349 101 18.0" 
$ns at 196.18241248477764 "$node_(22) setdest 743 997 11.0" 
$ns at 283.05501499490913 "$node_(22) setdest 227 948 4.0" 
$ns at 350.18644268568687 "$node_(22) setdest 589 888 3.0" 
$ns at 391.51441535484616 "$node_(22) setdest 2598 313 12.0" 
$ns at 503.4092886577861 "$node_(22) setdest 34 725 17.0" 
$ns at 664.0285836600625 "$node_(22) setdest 577 449 1.0" 
$ns at 700.6999643351768 "$node_(22) setdest 671 648 14.0" 
$ns at 841.6431560516965 "$node_(22) setdest 52 580 15.0" 
$ns at 0.0 "$node_(23) setdest 383 886 9.0" 
$ns at 80.32817999263006 "$node_(23) setdest 2469 224 1.0" 
$ns at 119.9415694702821 "$node_(23) setdest 714 627 12.0" 
$ns at 156.52008424416465 "$node_(23) setdest 947 809 3.0" 
$ns at 195.6521123769073 "$node_(23) setdest 2363 999 6.0" 
$ns at 276.5931232297594 "$node_(23) setdest 1249 51 13.0" 
$ns at 365.97903824590406 "$node_(23) setdest 200 263 7.0" 
$ns at 398.20748820586203 "$node_(23) setdest 2889 785 18.0" 
$ns at 481.32069882972365 "$node_(23) setdest 1966 530 1.0" 
$ns at 511.5739296463526 "$node_(23) setdest 2395 221 4.0" 
$ns at 548.1399053081133 "$node_(23) setdest 2549 602 17.0" 
$ns at 606.1125346645358 "$node_(23) setdest 512 825 15.0" 
$ns at 665.2510076396101 "$node_(23) setdest 2499 760 2.0" 
$ns at 699.1004719233199 "$node_(23) setdest 1879 279 10.0" 
$ns at 761.3511452172477 "$node_(23) setdest 1175 576 2.0" 
$ns at 792.6170209688615 "$node_(23) setdest 2435 237 11.0" 
$ns at 826.9063368152728 "$node_(23) setdest 679 92 5.0" 
$ns at 891.838872328823 "$node_(23) setdest 2606 821 12.0" 
$ns at 0.0 "$node_(24) setdest 481 945 9.0" 
$ns at 83.22287846238969 "$node_(24) setdest 1035 77 1.0" 
$ns at 122.37982006544115 "$node_(24) setdest 2393 265 17.0" 
$ns at 220.5768955228495 "$node_(24) setdest 2393 839 11.0" 
$ns at 340.59481485365075 "$node_(24) setdest 1278 428 15.0" 
$ns at 511.1318245646768 "$node_(24) setdest 1530 709 2.0" 
$ns at 544.5269643011437 "$node_(24) setdest 661 10 17.0" 
$ns at 603.425832787964 "$node_(24) setdest 22 118 12.0" 
$ns at 710.0204245527398 "$node_(24) setdest 146 498 1.0" 
$ns at 741.7521593672367 "$node_(24) setdest 862 663 9.0" 
$ns at 837.3152403565415 "$node_(24) setdest 1269 622 5.0" 
$ns at 873.7997413520101 "$node_(24) setdest 2842 184 14.0" 
$ns at 0.0 "$node_(25) setdest 1227 360 20.0" 
$ns at 191.39099828131512 "$node_(25) setdest 1898 295 1.0" 
$ns at 221.76340231776663 "$node_(25) setdest 1590 965 1.0" 
$ns at 253.1580220342861 "$node_(25) setdest 1436 303 2.0" 
$ns at 291.041978251317 "$node_(25) setdest 2947 600 4.0" 
$ns at 353.65857765382816 "$node_(25) setdest 1435 752 15.0" 
$ns at 400.0051470780886 "$node_(25) setdest 2090 393 8.0" 
$ns at 430.93409663985716 "$node_(25) setdest 2838 26 1.0" 
$ns at 465.7606840065838 "$node_(25) setdest 178 17 18.0" 
$ns at 616.5610496305567 "$node_(25) setdest 1513 728 10.0" 
$ns at 665.2538249554527 "$node_(25) setdest 1014 109 12.0" 
$ns at 811.4411734871106 "$node_(25) setdest 819 793 6.0" 
$ns at 898.7437218241439 "$node_(25) setdest 330 122 17.0" 
$ns at 0.0 "$node_(26) setdest 539 532 6.0" 
$ns at 61.240003465170155 "$node_(26) setdest 760 437 5.0" 
$ns at 133.04802908678528 "$node_(26) setdest 1725 81 11.0" 
$ns at 226.19871343060646 "$node_(26) setdest 873 817 4.0" 
$ns at 270.58965734141475 "$node_(26) setdest 1717 946 7.0" 
$ns at 353.4688264289601 "$node_(26) setdest 436 534 1.0" 
$ns at 388.2716323012278 "$node_(26) setdest 2374 608 10.0" 
$ns at 513.6822260500057 "$node_(26) setdest 1804 754 16.0" 
$ns at 651.8902210265824 "$node_(26) setdest 1288 396 13.0" 
$ns at 738.3937625456501 "$node_(26) setdest 93 12 15.0" 
$ns at 0.0 "$node_(27) setdest 2514 82 11.0" 
$ns at 91.3383962462051 "$node_(27) setdest 533 858 19.0" 
$ns at 268.63991613507216 "$node_(27) setdest 81 910 13.0" 
$ns at 313.71040608300643 "$node_(27) setdest 154 1 2.0" 
$ns at 343.9941161317238 "$node_(27) setdest 2337 6 8.0" 
$ns at 418.43277135438944 "$node_(27) setdest 715 541 12.0" 
$ns at 517.0640606660396 "$node_(27) setdest 868 390 14.0" 
$ns at 631.0816622630741 "$node_(27) setdest 516 122 12.0" 
$ns at 668.1705288360052 "$node_(27) setdest 1556 31 10.0" 
$ns at 703.1816595412831 "$node_(27) setdest 508 78 11.0" 
$ns at 775.1078696017288 "$node_(27) setdest 2028 672 4.0" 
$ns at 836.0601643048893 "$node_(27) setdest 842 906 9.0" 
$ns at 0.0 "$node_(28) setdest 1533 359 2.0" 
$ns at 33.24176724310023 "$node_(28) setdest 768 668 7.0" 
$ns at 123.47479296163274 "$node_(28) setdest 1026 900 16.0" 
$ns at 243.8700837397003 "$node_(28) setdest 532 117 20.0" 
$ns at 454.9053769576317 "$node_(28) setdest 2975 701 14.0" 
$ns at 552.1077955956371 "$node_(28) setdest 1675 668 17.0" 
$ns at 742.1472351306502 "$node_(28) setdest 192 689 6.0" 
$ns at 802.8699376418443 "$node_(28) setdest 2884 515 14.0" 
$ns at 851.8035714611244 "$node_(28) setdest 681 281 6.0" 
$ns at 0.0 "$node_(29) setdest 1298 499 7.0" 
$ns at 47.43128449141422 "$node_(29) setdest 1315 599 5.0" 
$ns at 99.73993443626502 "$node_(29) setdest 929 541 16.0" 
$ns at 240.6034747914686 "$node_(29) setdest 847 395 2.0" 
$ns at 284.0109184308558 "$node_(29) setdest 585 735 10.0" 
$ns at 364.98922618088085 "$node_(29) setdest 2541 397 16.0" 
$ns at 520.8727199541145 "$node_(29) setdest 462 427 14.0" 
$ns at 682.2236649098471 "$node_(29) setdest 2442 16 14.0" 
$ns at 739.4930679382564 "$node_(29) setdest 1296 861 5.0" 
$ns at 791.8807487890209 "$node_(29) setdest 2083 637 18.0" 
$ns at 0.0 "$node_(30) setdest 741 230 17.0" 
$ns at 96.5184419898657 "$node_(30) setdest 1125 951 5.0" 
$ns at 160.1082969178708 "$node_(30) setdest 1360 209 16.0" 
$ns at 297.1451204527356 "$node_(30) setdest 1238 22 12.0" 
$ns at 371.8778701674679 "$node_(30) setdest 388 300 18.0" 
$ns at 410.5595522911522 "$node_(30) setdest 2232 57 11.0" 
$ns at 494.77453835114045 "$node_(30) setdest 1177 577 3.0" 
$ns at 525.8012377363139 "$node_(30) setdest 2214 84 3.0" 
$ns at 575.132879925412 "$node_(30) setdest 2957 662 13.0" 
$ns at 661.7641379210702 "$node_(30) setdest 2319 994 9.0" 
$ns at 767.8600052088642 "$node_(30) setdest 1341 8 8.0" 
$ns at 799.4557349219297 "$node_(30) setdest 2262 651 20.0" 
$ns at 881.2545834296938 "$node_(30) setdest 2694 831 3.0" 
$ns at 0.0 "$node_(31) setdest 765 37 9.0" 
$ns at 93.55597146216276 "$node_(31) setdest 2306 260 11.0" 
$ns at 185.9908863855809 "$node_(31) setdest 621 623 5.0" 
$ns at 239.77437263765958 "$node_(31) setdest 2982 553 3.0" 
$ns at 289.40027041806314 "$node_(31) setdest 927 440 12.0" 
$ns at 342.9600665160949 "$node_(31) setdest 1484 445 13.0" 
$ns at 492.7063644794415 "$node_(31) setdest 1768 547 12.0" 
$ns at 617.992443694931 "$node_(31) setdest 2961 971 11.0" 
$ns at 649.7210090571118 "$node_(31) setdest 2365 849 15.0" 
$ns at 799.9985426900282 "$node_(31) setdest 1270 342 13.0" 
$ns at 0.0 "$node_(32) setdest 1483 490 11.0" 
$ns at 89.71489167432189 "$node_(32) setdest 1844 711 17.0" 
$ns at 195.37005409247746 "$node_(32) setdest 613 258 11.0" 
$ns at 330.49672411406243 "$node_(32) setdest 2510 893 18.0" 
$ns at 446.48505862287595 "$node_(32) setdest 2210 718 12.0" 
$ns at 486.2930687905699 "$node_(32) setdest 1405 404 1.0" 
$ns at 524.0524438773673 "$node_(32) setdest 2017 32 15.0" 
$ns at 626.6336493745977 "$node_(32) setdest 2897 364 15.0" 
$ns at 664.9282987704694 "$node_(32) setdest 2242 669 7.0" 
$ns at 703.0683781323304 "$node_(32) setdest 2158 127 4.0" 
$ns at 741.1750485020017 "$node_(32) setdest 1132 465 8.0" 
$ns at 804.347818126248 "$node_(32) setdest 1801 695 6.0" 
$ns at 881.2028648784519 "$node_(32) setdest 2203 735 13.0" 
$ns at 0.0 "$node_(33) setdest 717 270 8.0" 
$ns at 70.17666837786295 "$node_(33) setdest 170 399 7.0" 
$ns at 145.7549015686103 "$node_(33) setdest 1034 511 6.0" 
$ns at 209.6170383810043 "$node_(33) setdest 341 334 18.0" 
$ns at 403.1381528548677 "$node_(33) setdest 1836 331 4.0" 
$ns at 472.93469338218 "$node_(33) setdest 14 389 14.0" 
$ns at 503.9008415602787 "$node_(33) setdest 47 323 9.0" 
$ns at 569.6502962564815 "$node_(33) setdest 2138 797 20.0" 
$ns at 645.4648756627437 "$node_(33) setdest 1641 136 7.0" 
$ns at 727.5012947616588 "$node_(33) setdest 289 919 1.0" 
$ns at 758.5545681387518 "$node_(33) setdest 2065 395 15.0" 
$ns at 804.8016821632386 "$node_(33) setdest 715 540 8.0" 
$ns at 882.3663497688193 "$node_(33) setdest 541 985 4.0" 
$ns at 0.0 "$node_(34) setdest 989 170 16.0" 
$ns at 132.6781409880109 "$node_(34) setdest 2646 792 1.0" 
$ns at 163.75427741838152 "$node_(34) setdest 1554 51 16.0" 
$ns at 214.83671757151546 "$node_(34) setdest 2316 223 8.0" 
$ns at 311.2726659407437 "$node_(34) setdest 1165 841 19.0" 
$ns at 438.0095752657935 "$node_(34) setdest 1185 99 18.0" 
$ns at 579.2941925505281 "$node_(34) setdest 31 167 13.0" 
$ns at 685.0865614381776 "$node_(34) setdest 903 737 3.0" 
$ns at 719.0271463032872 "$node_(34) setdest 2168 515 17.0" 
$ns at 797.8395940628014 "$node_(34) setdest 845 321 13.0" 
$ns at 0.0 "$node_(35) setdest 248 158 10.0" 
$ns at 71.41709249852934 "$node_(35) setdest 1354 878 20.0" 
$ns at 237.08524861500254 "$node_(35) setdest 1960 80 4.0" 
$ns at 290.8490698299266 "$node_(35) setdest 1423 455 10.0" 
$ns at 415.093955527928 "$node_(35) setdest 1683 110 10.0" 
$ns at 448.68897357078185 "$node_(35) setdest 1479 313 14.0" 
$ns at 558.2534970943732 "$node_(35) setdest 2971 703 14.0" 
$ns at 700.6306027647512 "$node_(35) setdest 1647 241 2.0" 
$ns at 734.4887115566977 "$node_(35) setdest 145 109 2.0" 
$ns at 777.2603338585243 "$node_(35) setdest 1679 297 3.0" 
$ns at 832.3894735259354 "$node_(35) setdest 2020 846 12.0" 
$ns at 0.0 "$node_(36) setdest 414 584 19.0" 
$ns at 165.0172969368566 "$node_(36) setdest 1533 724 4.0" 
$ns at 200.6050449608218 "$node_(36) setdest 2457 873 3.0" 
$ns at 240.47367941547265 "$node_(36) setdest 2803 843 4.0" 
$ns at 271.3814249499759 "$node_(36) setdest 1451 159 12.0" 
$ns at 344.073190888781 "$node_(36) setdest 1912 295 14.0" 
$ns at 478.44465829325645 "$node_(36) setdest 113 499 2.0" 
$ns at 524.3717541805408 "$node_(36) setdest 1421 521 12.0" 
$ns at 563.5032079028095 "$node_(36) setdest 1921 683 8.0" 
$ns at 629.3538512731584 "$node_(36) setdest 1395 517 4.0" 
$ns at 684.3664735953306 "$node_(36) setdest 124 602 18.0" 
$ns at 849.1457867372786 "$node_(36) setdest 487 373 11.0" 
$ns at 888.9434291048079 "$node_(36) setdest 2452 370 17.0" 
$ns at 0.0 "$node_(37) setdest 2328 825 5.0" 
$ns at 39.960243847546025 "$node_(37) setdest 1707 551 7.0" 
$ns at 107.17856752778883 "$node_(37) setdest 2276 789 6.0" 
$ns at 176.3446505974002 "$node_(37) setdest 1108 58 1.0" 
$ns at 215.7477803602597 "$node_(37) setdest 2288 87 15.0" 
$ns at 326.6154289410688 "$node_(37) setdest 69 566 1.0" 
$ns at 358.08645335563284 "$node_(37) setdest 441 821 8.0" 
$ns at 390.8410951629609 "$node_(37) setdest 2789 514 9.0" 
$ns at 427.10721641646586 "$node_(37) setdest 1393 89 16.0" 
$ns at 518.4110881749261 "$node_(37) setdest 1830 41 15.0" 
$ns at 595.1791298098021 "$node_(37) setdest 1789 20 18.0" 
$ns at 703.6319758401957 "$node_(37) setdest 563 413 13.0" 
$ns at 843.6989792747386 "$node_(37) setdest 1415 322 15.0" 
$ns at 0.0 "$node_(38) setdest 1147 804 3.0" 
$ns at 37.615140349519585 "$node_(38) setdest 1607 805 9.0" 
$ns at 122.97221554933859 "$node_(38) setdest 2440 491 9.0" 
$ns at 234.4862808469883 "$node_(38) setdest 1202 578 15.0" 
$ns at 301.3225694120548 "$node_(38) setdest 2001 799 3.0" 
$ns at 353.747204705949 "$node_(38) setdest 1058 896 8.0" 
$ns at 413.4653757875516 "$node_(38) setdest 69 383 6.0" 
$ns at 477.3753902409884 "$node_(38) setdest 1914 836 9.0" 
$ns at 578.0877438538992 "$node_(38) setdest 1188 684 10.0" 
$ns at 696.7085984746402 "$node_(38) setdest 2127 290 1.0" 
$ns at 730.6485065986877 "$node_(38) setdest 874 621 12.0" 
$ns at 869.5300629203127 "$node_(38) setdest 2558 955 6.0" 
$ns at 0.0 "$node_(39) setdest 2475 875 1.0" 
$ns at 30.94095095951845 "$node_(39) setdest 2630 292 6.0" 
$ns at 119.30502889337582 "$node_(39) setdest 2127 325 12.0" 
$ns at 190.88283254869197 "$node_(39) setdest 2344 665 16.0" 
$ns at 256.3733499340563 "$node_(39) setdest 456 494 6.0" 
$ns at 338.90513017169445 "$node_(39) setdest 1777 94 12.0" 
$ns at 377.767387887153 "$node_(39) setdest 1444 55 2.0" 
$ns at 411.4679822258802 "$node_(39) setdest 2336 364 9.0" 
$ns at 463.57025260936524 "$node_(39) setdest 1579 760 12.0" 
$ns at 589.9455246197889 "$node_(39) setdest 2801 407 19.0" 
$ns at 672.7001961061726 "$node_(39) setdest 229 349 15.0" 
$ns at 801.4388853649621 "$node_(39) setdest 1926 207 17.0" 
$ns at 0.0 "$node_(40) setdest 2862 294 9.0" 
$ns at 51.95661933884281 "$node_(40) setdest 2139 642 3.0" 
$ns at 84.35815018008643 "$node_(40) setdest 1537 434 7.0" 
$ns at 182.05601512446052 "$node_(40) setdest 603 5 1.0" 
$ns at 216.1852991181978 "$node_(40) setdest 1795 859 15.0" 
$ns at 294.7969087389117 "$node_(40) setdest 2675 142 16.0" 
$ns at 333.95465997766865 "$node_(40) setdest 881 608 6.0" 
$ns at 411.91663085920464 "$node_(40) setdest 539 417 9.0" 
$ns at 514.0824968934305 "$node_(40) setdest 2919 18 4.0" 
$ns at 569.3333471515172 "$node_(40) setdest 1537 968 15.0" 
$ns at 658.3867812774978 "$node_(40) setdest 1469 805 8.0" 
$ns at 755.5107546995357 "$node_(40) setdest 2481 949 19.0" 
$ns at 853.7795840579739 "$node_(40) setdest 1596 219 19.0" 
$ns at 0.0 "$node_(41) setdest 1963 731 4.0" 
$ns at 40.9374336388271 "$node_(41) setdest 1374 831 16.0" 
$ns at 193.2032464806079 "$node_(41) setdest 2454 249 6.0" 
$ns at 282.85637919799746 "$node_(41) setdest 456 815 8.0" 
$ns at 390.58290802435437 "$node_(41) setdest 2711 975 8.0" 
$ns at 471.35020705905663 "$node_(41) setdest 2136 778 2.0" 
$ns at 506.0034124923961 "$node_(41) setdest 2767 204 18.0" 
$ns at 588.078799311717 "$node_(41) setdest 32 496 12.0" 
$ns at 636.0934826733646 "$node_(41) setdest 2540 619 19.0" 
$ns at 815.6601556726273 "$node_(41) setdest 1306 112 17.0" 
$ns at 0.0 "$node_(42) setdest 2832 344 19.0" 
$ns at 217.74442830174596 "$node_(42) setdest 1076 655 17.0" 
$ns at 319.16787656863323 "$node_(42) setdest 245 937 14.0" 
$ns at 404.3711238770579 "$node_(42) setdest 410 939 19.0" 
$ns at 465.7940016304271 "$node_(42) setdest 1294 33 19.0" 
$ns at 513.9009341391711 "$node_(42) setdest 2063 182 5.0" 
$ns at 546.8957097023425 "$node_(42) setdest 747 597 18.0" 
$ns at 633.852729118878 "$node_(42) setdest 2858 943 11.0" 
$ns at 724.9246236238395 "$node_(42) setdest 1961 978 9.0" 
$ns at 763.0278918484918 "$node_(42) setdest 2368 175 18.0" 
$ns at 888.4389376547167 "$node_(42) setdest 1749 252 12.0" 
$ns at 0.0 "$node_(43) setdest 284 508 18.0" 
$ns at 71.31678301376174 "$node_(43) setdest 1053 523 1.0" 
$ns at 108.84642234450301 "$node_(43) setdest 644 82 14.0" 
$ns at 187.0706603442187 "$node_(43) setdest 1445 175 19.0" 
$ns at 339.4404967881463 "$node_(43) setdest 2813 504 15.0" 
$ns at 388.3243459485088 "$node_(43) setdest 2249 253 18.0" 
$ns at 437.44247245432035 "$node_(43) setdest 1864 774 4.0" 
$ns at 494.60677899508113 "$node_(43) setdest 1788 451 9.0" 
$ns at 564.4854737537471 "$node_(43) setdest 772 258 12.0" 
$ns at 694.274746308128 "$node_(43) setdest 1054 399 14.0" 
$ns at 859.6251315413461 "$node_(43) setdest 1563 32 10.0" 
$ns at 0.0 "$node_(44) setdest 2819 218 17.0" 
$ns at 42.91573437261808 "$node_(44) setdest 328 196 4.0" 
$ns at 92.42331669217631 "$node_(44) setdest 2964 538 11.0" 
$ns at 189.87950256953613 "$node_(44) setdest 2752 968 20.0" 
$ns at 369.1644772853069 "$node_(44) setdest 1555 453 4.0" 
$ns at 410.00403678204304 "$node_(44) setdest 2558 665 14.0" 
$ns at 535.3932205962531 "$node_(44) setdest 1947 97 7.0" 
$ns at 569.9836989449876 "$node_(44) setdest 1022 874 18.0" 
$ns at 772.6767795219283 "$node_(44) setdest 2932 820 2.0" 
$ns at 805.659060528363 "$node_(44) setdest 2459 427 7.0" 
$ns at 893.4954051326229 "$node_(44) setdest 1727 160 16.0" 
$ns at 0.0 "$node_(45) setdest 2332 985 5.0" 
$ns at 31.96556342662813 "$node_(45) setdest 2308 62 19.0" 
$ns at 83.12351103763466 "$node_(45) setdest 389 329 16.0" 
$ns at 198.1412464535938 "$node_(45) setdest 383 73 8.0" 
$ns at 239.97831603468805 "$node_(45) setdest 2975 682 8.0" 
$ns at 305.86437913603436 "$node_(45) setdest 1027 441 2.0" 
$ns at 347.65238885516925 "$node_(45) setdest 434 651 13.0" 
$ns at 437.21812514095984 "$node_(45) setdest 2751 350 18.0" 
$ns at 580.759948940107 "$node_(45) setdest 2232 612 10.0" 
$ns at 657.7572583913985 "$node_(45) setdest 2540 734 13.0" 
$ns at 708.4947127963025 "$node_(45) setdest 225 629 20.0" 
$ns at 771.6980931392451 "$node_(45) setdest 2136 380 18.0" 
$ns at 887.7212835850038 "$node_(45) setdest 1210 235 7.0" 
$ns at 0.0 "$node_(46) setdest 2583 280 9.0" 
$ns at 76.78089212982039 "$node_(46) setdest 671 653 5.0" 
$ns at 129.05817639529238 "$node_(46) setdest 1834 435 7.0" 
$ns at 164.70116517109977 "$node_(46) setdest 1362 299 11.0" 
$ns at 302.7522306640453 "$node_(46) setdest 1916 572 4.0" 
$ns at 365.97484232893004 "$node_(46) setdest 1138 639 5.0" 
$ns at 428.01975697726823 "$node_(46) setdest 2963 479 11.0" 
$ns at 472.3430082802709 "$node_(46) setdest 1188 738 6.0" 
$ns at 521.8377718000651 "$node_(46) setdest 1118 909 12.0" 
$ns at 662.0288780800429 "$node_(46) setdest 2555 82 12.0" 
$ns at 747.2031911198494 "$node_(46) setdest 2099 276 4.0" 
$ns at 784.8396670163221 "$node_(46) setdest 1626 501 12.0" 
$ns at 842.2638502823721 "$node_(46) setdest 2945 586 13.0" 
$ns at 0.0 "$node_(47) setdest 1957 282 18.0" 
$ns at 168.96168624471537 "$node_(47) setdest 226 306 7.0" 
$ns at 260.9837552805059 "$node_(47) setdest 622 799 15.0" 
$ns at 440.73785158633507 "$node_(47) setdest 2741 150 17.0" 
$ns at 526.1300515951855 "$node_(47) setdest 960 242 13.0" 
$ns at 672.6402880963622 "$node_(47) setdest 487 967 19.0" 
$ns at 740.1553491158911 "$node_(47) setdest 2385 283 13.0" 
$ns at 834.6623290271248 "$node_(47) setdest 1413 195 15.0" 
$ns at 0.0 "$node_(48) setdest 2667 750 2.0" 
$ns at 47.500756449981935 "$node_(48) setdest 2254 594 9.0" 
$ns at 111.55398640207494 "$node_(48) setdest 821 650 2.0" 
$ns at 158.49786815005086 "$node_(48) setdest 459 210 8.0" 
$ns at 252.864795175018 "$node_(48) setdest 1516 125 3.0" 
$ns at 290.01264644490726 "$node_(48) setdest 1996 770 3.0" 
$ns at 349.39309185421973 "$node_(48) setdest 1661 165 1.0" 
$ns at 388.2402596482033 "$node_(48) setdest 1560 984 15.0" 
$ns at 496.5023685195159 "$node_(48) setdest 553 157 18.0" 
$ns at 662.3326430518285 "$node_(48) setdest 2462 437 5.0" 
$ns at 716.7127665394315 "$node_(48) setdest 763 622 17.0" 
$ns at 888.443154260253 "$node_(48) setdest 227 54 13.0" 
$ns at 0.0 "$node_(49) setdest 641 698 1.0" 
$ns at 36.71569504012765 "$node_(49) setdest 1673 314 1.0" 
$ns at 67.51177381911538 "$node_(49) setdest 1102 219 8.0" 
$ns at 156.08585213983787 "$node_(49) setdest 2008 708 6.0" 
$ns at 209.24923842468422 "$node_(49) setdest 2103 456 8.0" 
$ns at 314.73417331412804 "$node_(49) setdest 2216 109 12.0" 
$ns at 463.17096927854533 "$node_(49) setdest 942 868 5.0" 
$ns at 497.72216636063825 "$node_(49) setdest 2754 40 2.0" 
$ns at 534.2651470871998 "$node_(49) setdest 2304 439 5.0" 
$ns at 611.6866512528871 "$node_(49) setdest 356 35 10.0" 
$ns at 739.2463698594313 "$node_(49) setdest 2692 423 14.0" 
$ns at 810.1478425469356 "$node_(49) setdest 443 549 15.0" 
$ns at 0.0 "$node_(50) setdest 2653 597 2.0" 
$ns at 33.843394685561556 "$node_(50) setdest 1448 128 10.0" 
$ns at 107.65392916012746 "$node_(50) setdest 1945 339 16.0" 
$ns at 173.62934191774247 "$node_(50) setdest 1058 797 19.0" 
$ns at 245.8842691730793 "$node_(50) setdest 2554 123 1.0" 
$ns at 280.9038021007476 "$node_(50) setdest 164 865 9.0" 
$ns at 364.8650977590778 "$node_(50) setdest 205 255 10.0" 
$ns at 460.9080869936531 "$node_(50) setdest 2038 615 15.0" 
$ns at 534.7649243282629 "$node_(50) setdest 2781 940 11.0" 
$ns at 587.5829027884389 "$node_(50) setdest 2024 579 18.0" 
$ns at 678.1546552669633 "$node_(50) setdest 790 4 8.0" 
$ns at 777.3723933538555 "$node_(50) setdest 2766 356 9.0" 
$ns at 857.5648568934698 "$node_(50) setdest 1789 859 19.0" 
$ns at 240.3578409949401 "$node_(51) setdest 1637 703 18.0" 
$ns at 421.3868860483932 "$node_(51) setdest 1460 914 9.0" 
$ns at 509.19683680155595 "$node_(51) setdest 2861 677 16.0" 
$ns at 620.3317046514383 "$node_(51) setdest 9 324 11.0" 
$ns at 701.8442642528466 "$node_(51) setdest 2169 527 1.0" 
$ns at 733.0488723324507 "$node_(51) setdest 2781 375 9.0" 
$ns at 764.052590927286 "$node_(51) setdest 2239 991 19.0" 
$ns at 295.39283680201146 "$node_(52) setdest 1954 930 13.0" 
$ns at 368.95085736647167 "$node_(52) setdest 1790 584 8.0" 
$ns at 458.92401056609816 "$node_(52) setdest 2486 980 15.0" 
$ns at 544.1348358601059 "$node_(52) setdest 1030 532 8.0" 
$ns at 591.5108303837313 "$node_(52) setdest 445 554 16.0" 
$ns at 743.9983403091999 "$node_(52) setdest 74 380 17.0" 
$ns at 272.57021889909123 "$node_(53) setdest 1176 482 1.0" 
$ns at 309.91466548811513 "$node_(53) setdest 1040 841 6.0" 
$ns at 344.6047650504086 "$node_(53) setdest 129 885 16.0" 
$ns at 435.64749709700334 "$node_(53) setdest 2364 223 3.0" 
$ns at 476.8242041924468 "$node_(53) setdest 1402 202 14.0" 
$ns at 519.3873649316697 "$node_(53) setdest 1577 508 12.0" 
$ns at 610.3505791299947 "$node_(53) setdest 1689 166 15.0" 
$ns at 669.1001432350613 "$node_(53) setdest 2517 855 19.0" 
$ns at 881.2194686252801 "$node_(53) setdest 2279 883 10.0" 
$ns at 172.19044619486345 "$node_(54) setdest 2062 185 11.0" 
$ns at 216.85762261115144 "$node_(54) setdest 368 23 9.0" 
$ns at 264.3093236326864 "$node_(54) setdest 848 614 15.0" 
$ns at 325.0598212363091 "$node_(54) setdest 2380 404 12.0" 
$ns at 421.9424364401573 "$node_(54) setdest 1139 193 15.0" 
$ns at 473.712035197435 "$node_(54) setdest 378 202 13.0" 
$ns at 514.9719427469105 "$node_(54) setdest 89 203 19.0" 
$ns at 629.030757276884 "$node_(54) setdest 2859 165 3.0" 
$ns at 664.4564591728824 "$node_(54) setdest 1025 507 17.0" 
$ns at 858.5792813408614 "$node_(54) setdest 2098 310 7.0" 
$ns at 167.67538258798012 "$node_(55) setdest 1630 571 6.0" 
$ns at 240.03959850689634 "$node_(55) setdest 2663 659 14.0" 
$ns at 303.31713715581475 "$node_(55) setdest 649 991 15.0" 
$ns at 466.91654597164484 "$node_(55) setdest 1473 58 4.0" 
$ns at 507.5968154847585 "$node_(55) setdest 2436 876 15.0" 
$ns at 636.657709062488 "$node_(55) setdest 1156 741 5.0" 
$ns at 713.8132055712817 "$node_(55) setdest 417 204 7.0" 
$ns at 796.2270742673584 "$node_(55) setdest 2697 15 11.0" 
$ns at 893.9722354252126 "$node_(55) setdest 1689 908 2.0" 
$ns at 172.2257539979671 "$node_(56) setdest 2885 289 6.0" 
$ns at 204.09475214712197 "$node_(56) setdest 1437 574 14.0" 
$ns at 237.31400631180935 "$node_(56) setdest 1096 554 3.0" 
$ns at 270.9587671273114 "$node_(56) setdest 2905 247 19.0" 
$ns at 369.010138969081 "$node_(56) setdest 908 667 6.0" 
$ns at 457.6427304033261 "$node_(56) setdest 1073 234 4.0" 
$ns at 508.12039697464877 "$node_(56) setdest 2293 188 18.0" 
$ns at 691.9514432029895 "$node_(56) setdest 2424 518 19.0" 
$ns at 816.7578663024584 "$node_(56) setdest 2267 280 11.0" 
$ns at 869.8678753280865 "$node_(56) setdest 2611 235 19.0" 
$ns at 191.72477165908597 "$node_(57) setdest 1778 749 6.0" 
$ns at 236.59905991567234 "$node_(57) setdest 278 240 6.0" 
$ns at 302.6950439574931 "$node_(57) setdest 2583 898 17.0" 
$ns at 382.42648182574106 "$node_(57) setdest 1400 868 14.0" 
$ns at 440.57912143737695 "$node_(57) setdest 1181 13 14.0" 
$ns at 516.7058371879875 "$node_(57) setdest 909 865 2.0" 
$ns at 557.1587854635331 "$node_(57) setdest 369 683 5.0" 
$ns at 620.7915082884285 "$node_(57) setdest 1897 871 18.0" 
$ns at 794.9179492751674 "$node_(57) setdest 198 322 3.0" 
$ns at 835.7562078176668 "$node_(57) setdest 1648 107 1.0" 
$ns at 867.947924843622 "$node_(57) setdest 2506 522 8.0" 
$ns at 898.9864937839645 "$node_(57) setdest 2725 706 1.0" 
$ns at 182.62373184236364 "$node_(58) setdest 1177 881 5.0" 
$ns at 254.58359450870984 "$node_(58) setdest 2986 568 15.0" 
$ns at 320.0505843173708 "$node_(58) setdest 1422 506 13.0" 
$ns at 457.9205670038964 "$node_(58) setdest 1292 547 7.0" 
$ns at 547.2001426020904 "$node_(58) setdest 1986 657 4.0" 
$ns at 608.9915185188296 "$node_(58) setdest 101 820 15.0" 
$ns at 744.6792650248129 "$node_(58) setdest 168 806 12.0" 
$ns at 857.4510254180675 "$node_(58) setdest 1253 821 13.0" 
$ns at 261.32475569337544 "$node_(59) setdest 641 499 1.0" 
$ns at 298.346292390499 "$node_(59) setdest 2748 364 4.0" 
$ns at 341.0284207940085 "$node_(59) setdest 1462 157 20.0" 
$ns at 388.5063773899916 "$node_(59) setdest 539 251 3.0" 
$ns at 446.2172185031384 "$node_(59) setdest 817 56 17.0" 
$ns at 508.17391943004674 "$node_(59) setdest 202 853 16.0" 
$ns at 625.2391772692677 "$node_(59) setdest 567 804 3.0" 
$ns at 673.3741496360408 "$node_(59) setdest 1042 140 9.0" 
$ns at 726.1149379868789 "$node_(59) setdest 507 825 4.0" 
$ns at 777.5782888356512 "$node_(59) setdest 1552 971 9.0" 
$ns at 824.9599084619557 "$node_(59) setdest 2930 897 7.0" 
$ns at 868.4224136019312 "$node_(59) setdest 2422 997 4.0" 
$ns at 306.2091266925576 "$node_(60) setdest 1724 603 1.0" 
$ns at 343.48057526196084 "$node_(60) setdest 1234 210 15.0" 
$ns at 409.2493277497115 "$node_(60) setdest 1774 653 7.0" 
$ns at 490.720613024296 "$node_(60) setdest 298 448 8.0" 
$ns at 558.0136322778959 "$node_(60) setdest 2037 563 15.0" 
$ns at 686.777414460599 "$node_(60) setdest 2277 67 17.0" 
$ns at 856.5404359152806 "$node_(60) setdest 2592 997 17.0" 
$ns at 182.1159591319859 "$node_(61) setdest 1492 754 13.0" 
$ns at 213.92101466453397 "$node_(61) setdest 2652 41 20.0" 
$ns at 329.3205529296169 "$node_(61) setdest 1912 255 5.0" 
$ns at 398.04342193020216 "$node_(61) setdest 2815 31 14.0" 
$ns at 482.6356795932325 "$node_(61) setdest 1011 583 17.0" 
$ns at 599.0346381036069 "$node_(61) setdest 333 407 11.0" 
$ns at 656.8745691267997 "$node_(61) setdest 40 743 11.0" 
$ns at 720.7282901311612 "$node_(61) setdest 2827 343 13.0" 
$ns at 825.8820526834855 "$node_(61) setdest 740 155 15.0" 
$ns at 169.92469733506297 "$node_(62) setdest 826 674 19.0" 
$ns at 362.5585985862908 "$node_(62) setdest 2568 3 9.0" 
$ns at 475.09053405600076 "$node_(62) setdest 1828 924 17.0" 
$ns at 635.6093340182792 "$node_(62) setdest 1400 674 17.0" 
$ns at 711.1672129735973 "$node_(62) setdest 1695 47 13.0" 
$ns at 811.0685640620372 "$node_(62) setdest 371 372 4.0" 
$ns at 843.695139630761 "$node_(62) setdest 2312 181 4.0" 
$ns at 217.81122544196455 "$node_(63) setdest 1453 964 1.0" 
$ns at 251.13038423206172 "$node_(63) setdest 104 984 5.0" 
$ns at 287.18786102679286 "$node_(63) setdest 2137 910 19.0" 
$ns at 481.0437636784985 "$node_(63) setdest 1705 841 3.0" 
$ns at 533.3446004594866 "$node_(63) setdest 2251 396 1.0" 
$ns at 570.2456064404317 "$node_(63) setdest 717 489 4.0" 
$ns at 618.2240439077254 "$node_(63) setdest 1205 298 10.0" 
$ns at 707.7566427791081 "$node_(63) setdest 1855 868 20.0" 
$ns at 879.8278473596206 "$node_(63) setdest 1644 950 13.0" 
$ns at 190.74984951260774 "$node_(64) setdest 2513 351 13.0" 
$ns at 350.3668713777257 "$node_(64) setdest 2895 133 12.0" 
$ns at 427.94827122343213 "$node_(64) setdest 302 814 3.0" 
$ns at 482.47566422811883 "$node_(64) setdest 278 600 6.0" 
$ns at 564.9823493718052 "$node_(64) setdest 2595 542 16.0" 
$ns at 640.5353089215755 "$node_(64) setdest 654 105 1.0" 
$ns at 680.3224610659686 "$node_(64) setdest 2772 84 11.0" 
$ns at 767.3452382985115 "$node_(64) setdest 95 428 5.0" 
$ns at 817.9540516002263 "$node_(64) setdest 233 916 12.0" 
$ns at 237.93692295198898 "$node_(65) setdest 664 527 4.0" 
$ns at 293.9570894229602 "$node_(65) setdest 2455 920 20.0" 
$ns at 436.31978445215447 "$node_(65) setdest 438 476 14.0" 
$ns at 499.0564390400465 "$node_(65) setdest 2502 625 6.0" 
$ns at 547.2654067682905 "$node_(65) setdest 1350 631 12.0" 
$ns at 581.975428005022 "$node_(65) setdest 1180 528 18.0" 
$ns at 772.4606500763218 "$node_(65) setdest 1887 939 7.0" 
$ns at 815.4347975790196 "$node_(65) setdest 2998 888 15.0" 
$ns at 207.10679450641385 "$node_(66) setdest 1507 468 12.0" 
$ns at 336.0936114983913 "$node_(66) setdest 1916 64 1.0" 
$ns at 374.02943827107373 "$node_(66) setdest 1408 975 19.0" 
$ns at 566.743073897076 "$node_(66) setdest 1148 779 19.0" 
$ns at 668.0556690167275 "$node_(66) setdest 1883 559 11.0" 
$ns at 701.684159543065 "$node_(66) setdest 2223 461 17.0" 
$ns at 777.8844264327291 "$node_(66) setdest 476 551 2.0" 
$ns at 811.155241699118 "$node_(66) setdest 2172 1 7.0" 
$ns at 894.0189425649464 "$node_(66) setdest 1564 460 1.0" 
$ns at 195.02747649751797 "$node_(67) setdest 2364 381 7.0" 
$ns at 282.7201336476381 "$node_(67) setdest 264 662 8.0" 
$ns at 372.70439440656776 "$node_(67) setdest 2078 801 14.0" 
$ns at 514.0932029438206 "$node_(67) setdest 1049 937 13.0" 
$ns at 614.9037401927503 "$node_(67) setdest 2939 498 16.0" 
$ns at 742.4233958616733 "$node_(67) setdest 1229 494 15.0" 
$ns at 791.1214273607363 "$node_(67) setdest 432 851 8.0" 
$ns at 850.6649498891279 "$node_(67) setdest 69 165 16.0" 
$ns at 173.1636564707936 "$node_(68) setdest 784 344 6.0" 
$ns at 257.30428381389186 "$node_(68) setdest 2018 265 3.0" 
$ns at 307.1057185095681 "$node_(68) setdest 2717 176 3.0" 
$ns at 360.2003576291106 "$node_(68) setdest 2606 323 6.0" 
$ns at 414.59931276989727 "$node_(68) setdest 2557 852 5.0" 
$ns at 471.25551302980716 "$node_(68) setdest 2088 544 11.0" 
$ns at 521.6256939916185 "$node_(68) setdest 658 258 3.0" 
$ns at 553.8175617091204 "$node_(68) setdest 2080 461 9.0" 
$ns at 591.468592490839 "$node_(68) setdest 577 178 16.0" 
$ns at 768.5143886931634 "$node_(68) setdest 332 275 1.0" 
$ns at 807.1328660484673 "$node_(68) setdest 24 242 17.0" 
$ns at 210.98044904007236 "$node_(69) setdest 1002 891 12.0" 
$ns at 328.17335177139483 "$node_(69) setdest 1967 270 16.0" 
$ns at 449.5462274393944 "$node_(69) setdest 2295 162 13.0" 
$ns at 501.3476746087299 "$node_(69) setdest 903 803 1.0" 
$ns at 534.4431899660276 "$node_(69) setdest 1137 88 14.0" 
$ns at 699.5630269252379 "$node_(69) setdest 1292 361 7.0" 
$ns at 770.9215946719628 "$node_(69) setdest 2093 573 15.0" 
$ns at 247.89555699522035 "$node_(70) setdest 1676 559 9.0" 
$ns at 280.49289468236844 "$node_(70) setdest 2378 45 10.0" 
$ns at 338.08677779350523 "$node_(70) setdest 519 788 19.0" 
$ns at 370.99328759420825 "$node_(70) setdest 2395 834 12.0" 
$ns at 460.6404742546682 "$node_(70) setdest 1333 264 18.0" 
$ns at 512.7360447479216 "$node_(70) setdest 1726 177 10.0" 
$ns at 583.7815780649846 "$node_(70) setdest 1206 444 16.0" 
$ns at 635.2189623228544 "$node_(70) setdest 2272 809 11.0" 
$ns at 703.3585076092843 "$node_(70) setdest 1604 236 11.0" 
$ns at 741.7067425532092 "$node_(70) setdest 2544 451 16.0" 
$ns at 884.425732321942 "$node_(70) setdest 2566 312 4.0" 
$ns at 193.3586045721578 "$node_(71) setdest 982 768 20.0" 
$ns at 235.16685283601174 "$node_(71) setdest 1 595 9.0" 
$ns at 275.2708825936096 "$node_(71) setdest 2083 449 16.0" 
$ns at 331.0234201181685 "$node_(71) setdest 1377 284 5.0" 
$ns at 407.9247301330392 "$node_(71) setdest 73 546 4.0" 
$ns at 465.9345732370865 "$node_(71) setdest 1772 244 9.0" 
$ns at 502.0781483710956 "$node_(71) setdest 1528 264 4.0" 
$ns at 568.3107908673672 "$node_(71) setdest 908 259 19.0" 
$ns at 629.3844551892336 "$node_(71) setdest 990 678 11.0" 
$ns at 721.3168736183369 "$node_(71) setdest 2078 411 5.0" 
$ns at 756.4725673942763 "$node_(71) setdest 1883 76 7.0" 
$ns at 830.8144568761104 "$node_(71) setdest 2214 198 2.0" 
$ns at 863.9894055972562 "$node_(71) setdest 2678 400 19.0" 
$ns at 245.83491019965112 "$node_(72) setdest 2677 957 6.0" 
$ns at 316.1383096626731 "$node_(72) setdest 2400 614 6.0" 
$ns at 346.19195286595675 "$node_(72) setdest 1107 825 16.0" 
$ns at 473.47208080810225 "$node_(72) setdest 1992 440 9.0" 
$ns at 535.1948125418695 "$node_(72) setdest 812 163 19.0" 
$ns at 728.892111222926 "$node_(72) setdest 1376 943 17.0" 
$ns at 849.7828401288265 "$node_(72) setdest 1857 908 16.0" 
$ns at 227.15839822525732 "$node_(73) setdest 247 452 1.0" 
$ns at 260.8796300161648 "$node_(73) setdest 1934 690 3.0" 
$ns at 296.75452784676605 "$node_(73) setdest 975 408 17.0" 
$ns at 352.6320177015233 "$node_(73) setdest 1045 319 11.0" 
$ns at 480.91059673089813 "$node_(73) setdest 1237 904 13.0" 
$ns at 632.783063070564 "$node_(73) setdest 1329 956 2.0" 
$ns at 680.8926709257255 "$node_(73) setdest 2937 301 12.0" 
$ns at 751.0976735136028 "$node_(73) setdest 1664 41 3.0" 
$ns at 795.9170182007701 "$node_(73) setdest 901 615 5.0" 
$ns at 865.314127873809 "$node_(73) setdest 598 609 15.0" 
$ns at 182.87703742765052 "$node_(74) setdest 2094 334 11.0" 
$ns at 259.53930040971886 "$node_(74) setdest 2092 320 2.0" 
$ns at 297.0682269737322 "$node_(74) setdest 2515 882 13.0" 
$ns at 429.7583413577578 "$node_(74) setdest 835 532 14.0" 
$ns at 512.7372108225004 "$node_(74) setdest 62 878 1.0" 
$ns at 546.1924512748158 "$node_(74) setdest 1219 865 5.0" 
$ns at 579.214662543398 "$node_(74) setdest 330 352 5.0" 
$ns at 655.656423812142 "$node_(74) setdest 2456 262 9.0" 
$ns at 705.7206658361188 "$node_(74) setdest 1484 386 15.0" 
$ns at 837.6135621608482 "$node_(74) setdest 673 414 19.0" 
$ns at 338.2296386251687 "$node_(75) setdest 1228 690 19.0" 
$ns at 395.41014235962587 "$node_(75) setdest 1756 899 20.0" 
$ns at 536.3055320961129 "$node_(75) setdest 1186 137 13.0" 
$ns at 681.7425909937366 "$node_(75) setdest 413 201 15.0" 
$ns at 738.4857200799041 "$node_(75) setdest 2337 730 15.0" 
$ns at 847.8490642108399 "$node_(75) setdest 344 860 1.0" 
$ns at 880.2801111235124 "$node_(75) setdest 1199 676 1.0" 
$ns at 386.32884358326874 "$node_(76) setdest 2200 523 9.0" 
$ns at 436.73837401611246 "$node_(76) setdest 2934 713 11.0" 
$ns at 570.0051501199708 "$node_(76) setdest 2351 480 5.0" 
$ns at 628.6586987821637 "$node_(76) setdest 1160 1 11.0" 
$ns at 753.9855439631074 "$node_(76) setdest 2013 85 18.0" 
$ns at 840.5921766554417 "$node_(76) setdest 684 686 1.0" 
$ns at 875.7197421105856 "$node_(76) setdest 281 473 13.0" 
$ns at 372.14343874943387 "$node_(77) setdest 1078 21 18.0" 
$ns at 423.997957836721 "$node_(77) setdest 2552 15 7.0" 
$ns at 488.0339812953146 "$node_(77) setdest 2673 351 16.0" 
$ns at 614.4994757311138 "$node_(77) setdest 1711 285 9.0" 
$ns at 712.2586073793237 "$node_(77) setdest 1590 356 14.0" 
$ns at 822.0672726188249 "$node_(77) setdest 1570 31 11.0" 
$ns at 341.2479457847418 "$node_(78) setdest 2525 29 20.0" 
$ns at 459.6994257594426 "$node_(78) setdest 2516 656 13.0" 
$ns at 569.0430860936401 "$node_(78) setdest 2721 874 6.0" 
$ns at 636.6439369335292 "$node_(78) setdest 2482 820 13.0" 
$ns at 719.0749606745347 "$node_(78) setdest 1941 176 7.0" 
$ns at 810.7972233656441 "$node_(78) setdest 566 749 2.0" 
$ns at 844.9239134821281 "$node_(78) setdest 56 723 14.0" 
$ns at 435.60016466228626 "$node_(79) setdest 742 269 6.0" 
$ns at 491.36568196983467 "$node_(79) setdest 1005 660 6.0" 
$ns at 557.9071663826437 "$node_(79) setdest 2799 464 1.0" 
$ns at 595.5517071695361 "$node_(79) setdest 1965 333 12.0" 
$ns at 731.5622607673306 "$node_(79) setdest 72 255 18.0" 
$ns at 810.0267936842392 "$node_(79) setdest 557 364 4.0" 
$ns at 856.2317393132878 "$node_(79) setdest 271 536 10.0" 
$ns at 332.7234769244798 "$node_(80) setdest 2860 365 6.0" 
$ns at 421.8796445009092 "$node_(80) setdest 367 565 7.0" 
$ns at 490.1765044031704 "$node_(80) setdest 1987 775 1.0" 
$ns at 522.1310010809336 "$node_(80) setdest 1882 58 11.0" 
$ns at 629.8396128452333 "$node_(80) setdest 2741 353 1.0" 
$ns at 662.0592687412695 "$node_(80) setdest 2234 374 1.0" 
$ns at 695.1636281242073 "$node_(80) setdest 2195 63 11.0" 
$ns at 827.1963541499388 "$node_(80) setdest 856 961 1.0" 
$ns at 866.8758740387011 "$node_(80) setdest 1412 310 11.0" 
$ns at 357.7620270613657 "$node_(81) setdest 304 80 1.0" 
$ns at 392.0630129443929 "$node_(81) setdest 1910 353 12.0" 
$ns at 458.08119590256115 "$node_(81) setdest 351 695 2.0" 
$ns at 488.9205416169517 "$node_(81) setdest 1384 543 8.0" 
$ns at 591.2470628045298 "$node_(81) setdest 689 254 4.0" 
$ns at 633.1416550262404 "$node_(81) setdest 1294 102 17.0" 
$ns at 744.1870953864798 "$node_(81) setdest 698 606 9.0" 
$ns at 846.906859759271 "$node_(81) setdest 2956 449 11.0" 
$ns at 436.34431465827106 "$node_(82) setdest 380 134 13.0" 
$ns at 466.59187054732666 "$node_(82) setdest 2645 967 19.0" 
$ns at 680.8311062798334 "$node_(82) setdest 2924 391 12.0" 
$ns at 760.065219020295 "$node_(82) setdest 822 534 7.0" 
$ns at 799.362590640796 "$node_(82) setdest 245 167 16.0" 
$ns at 355.8243013670928 "$node_(83) setdest 1530 505 17.0" 
$ns at 454.50143265374516 "$node_(83) setdest 412 662 14.0" 
$ns at 486.56725686395066 "$node_(83) setdest 616 540 5.0" 
$ns at 552.1095664490383 "$node_(83) setdest 2675 632 8.0" 
$ns at 600.1416746148152 "$node_(83) setdest 2475 911 5.0" 
$ns at 661.9383320223786 "$node_(83) setdest 2074 627 20.0" 
$ns at 716.1458358054631 "$node_(83) setdest 2490 28 11.0" 
$ns at 766.9027923406429 "$node_(83) setdest 1809 794 12.0" 
$ns at 380.1851075119748 "$node_(84) setdest 201 13 3.0" 
$ns at 417.62283227935154 "$node_(84) setdest 114 925 13.0" 
$ns at 553.1339233964648 "$node_(84) setdest 775 764 20.0" 
$ns at 729.438086403545 "$node_(84) setdest 2990 215 20.0" 
$ns at 375.4787870743234 "$node_(85) setdest 2641 986 19.0" 
$ns at 421.1700452057107 "$node_(85) setdest 2260 121 11.0" 
$ns at 515.9464674780436 "$node_(85) setdest 1933 701 2.0" 
$ns at 564.7303960910871 "$node_(85) setdest 1848 225 7.0" 
$ns at 631.8790065317628 "$node_(85) setdest 1802 306 19.0" 
$ns at 703.2700334343817 "$node_(85) setdest 779 723 7.0" 
$ns at 759.3359384748419 "$node_(85) setdest 1744 375 13.0" 
$ns at 860.4423770974159 "$node_(85) setdest 2201 856 14.0" 
$ns at 359.661216677398 "$node_(86) setdest 228 830 5.0" 
$ns at 428.5933080959908 "$node_(86) setdest 2625 417 11.0" 
$ns at 527.9721436300141 "$node_(86) setdest 2669 288 9.0" 
$ns at 577.9136736620034 "$node_(86) setdest 969 756 9.0" 
$ns at 658.4845874782247 "$node_(86) setdest 653 66 6.0" 
$ns at 732.2798251772847 "$node_(86) setdest 2581 715 8.0" 
$ns at 842.0845776401246 "$node_(86) setdest 2828 59 19.0" 
$ns at 894.5571831273479 "$node_(86) setdest 1793 451 11.0" 
$ns at 423.4329450458824 "$node_(87) setdest 1953 158 6.0" 
$ns at 489.54836721027385 "$node_(87) setdest 694 761 7.0" 
$ns at 538.5955109549145 "$node_(87) setdest 2932 461 5.0" 
$ns at 588.6493874078361 "$node_(87) setdest 879 199 11.0" 
$ns at 653.6608527282286 "$node_(87) setdest 2156 327 10.0" 
$ns at 748.4449148989665 "$node_(87) setdest 1868 64 17.0" 
$ns at 780.2966558493433 "$node_(87) setdest 2798 53 14.0" 
$ns at 426.35676744649396 "$node_(88) setdest 548 249 4.0" 
$ns at 477.7045600267427 "$node_(88) setdest 202 686 10.0" 
$ns at 537.8806829692523 "$node_(88) setdest 292 602 10.0" 
$ns at 636.4202506824906 "$node_(88) setdest 2885 971 11.0" 
$ns at 693.0464981897491 "$node_(88) setdest 282 645 10.0" 
$ns at 738.6942774109607 "$node_(88) setdest 1324 996 1.0" 
$ns at 769.7737145956427 "$node_(88) setdest 2083 278 9.0" 
$ns at 870.1322468062936 "$node_(88) setdest 881 451 2.0" 
$ns at 375.2433516482155 "$node_(89) setdest 2542 385 14.0" 
$ns at 410.37075690828243 "$node_(89) setdest 2047 987 3.0" 
$ns at 456.7625472549985 "$node_(89) setdest 611 496 3.0" 
$ns at 499.8618637552147 "$node_(89) setdest 163 185 12.0" 
$ns at 642.5059784028667 "$node_(89) setdest 512 118 5.0" 
$ns at 678.6708227822793 "$node_(89) setdest 1950 567 2.0" 
$ns at 714.6583047806939 "$node_(89) setdest 1489 310 6.0" 
$ns at 798.3106572062218 "$node_(89) setdest 234 579 9.0" 
$ns at 354.67100254462264 "$node_(90) setdest 1287 748 12.0" 
$ns at 480.24057956525473 "$node_(90) setdest 2393 826 3.0" 
$ns at 533.3846558519165 "$node_(90) setdest 529 201 19.0" 
$ns at 658.4724929842944 "$node_(90) setdest 84 553 12.0" 
$ns at 725.0102714509758 "$node_(90) setdest 153 650 10.0" 
$ns at 826.2680266917907 "$node_(90) setdest 1651 599 1.0" 
$ns at 860.7503983399514 "$node_(90) setdest 987 347 10.0" 
$ns at 352.12762043584485 "$node_(91) setdest 1702 439 11.0" 
$ns at 389.5575424077603 "$node_(91) setdest 2587 852 14.0" 
$ns at 452.3954449944958 "$node_(91) setdest 2639 715 17.0" 
$ns at 538.1961659406716 "$node_(91) setdest 1686 824 11.0" 
$ns at 626.6615316364031 "$node_(91) setdest 2691 29 8.0" 
$ns at 662.5475049015594 "$node_(91) setdest 2846 242 4.0" 
$ns at 720.2797262839683 "$node_(91) setdest 1522 637 11.0" 
$ns at 840.6819087896749 "$node_(91) setdest 2490 590 2.0" 
$ns at 876.5591399242642 "$node_(91) setdest 237 731 17.0" 
$ns at 345.51792998108283 "$node_(92) setdest 2862 119 4.0" 
$ns at 378.47026018726837 "$node_(92) setdest 186 946 8.0" 
$ns at 436.85383147984265 "$node_(92) setdest 1715 453 3.0" 
$ns at 485.79701083655954 "$node_(92) setdest 736 300 7.0" 
$ns at 561.5170050482011 "$node_(92) setdest 2366 129 18.0" 
$ns at 733.919655757558 "$node_(92) setdest 2275 600 6.0" 
$ns at 769.9557572656472 "$node_(92) setdest 571 402 12.0" 
$ns at 846.3156716814221 "$node_(92) setdest 734 386 14.0" 
$ns at 379.17094417867247 "$node_(93) setdest 483 624 15.0" 
$ns at 493.2519416210234 "$node_(93) setdest 1026 634 14.0" 
$ns at 549.9634852848508 "$node_(93) setdest 501 196 9.0" 
$ns at 629.7082635685856 "$node_(93) setdest 1857 340 4.0" 
$ns at 660.533681348588 "$node_(93) setdest 211 648 13.0" 
$ns at 729.5747318571028 "$node_(93) setdest 254 457 4.0" 
$ns at 773.9177484067252 "$node_(93) setdest 2195 140 9.0" 
$ns at 857.2088710406099 "$node_(93) setdest 1536 887 1.0" 
$ns at 893.0876166670708 "$node_(93) setdest 1576 561 5.0" 
$ns at 351.99351713858323 "$node_(94) setdest 139 599 9.0" 
$ns at 455.575699127215 "$node_(94) setdest 1879 745 1.0" 
$ns at 494.47206229021367 "$node_(94) setdest 532 879 3.0" 
$ns at 548.5910103247168 "$node_(94) setdest 2659 532 10.0" 
$ns at 635.5301453998087 "$node_(94) setdest 2503 158 14.0" 
$ns at 751.0767270186976 "$node_(94) setdest 1523 151 15.0" 
$ns at 891.1784402603242 "$node_(94) setdest 2533 940 17.0" 
$ns at 352.86323388024175 "$node_(95) setdest 683 693 7.0" 
$ns at 424.0214780821039 "$node_(95) setdest 1972 869 4.0" 
$ns at 474.16522055330915 "$node_(95) setdest 2707 467 9.0" 
$ns at 506.65527354658957 "$node_(95) setdest 2357 983 17.0" 
$ns at 610.809354377699 "$node_(95) setdest 2730 222 17.0" 
$ns at 656.0656595846359 "$node_(95) setdest 988 467 13.0" 
$ns at 702.7827402664237 "$node_(95) setdest 613 307 2.0" 
$ns at 750.3882860061703 "$node_(95) setdest 2019 925 9.0" 
$ns at 814.0916277796811 "$node_(95) setdest 236 120 5.0" 
$ns at 848.6939776088493 "$node_(95) setdest 2943 579 1.0" 
$ns at 888.3174457811828 "$node_(95) setdest 318 706 18.0" 
$ns at 392.5048549847592 "$node_(96) setdest 2831 629 17.0" 
$ns at 460.2266365962555 "$node_(96) setdest 1297 47 17.0" 
$ns at 498.06338489874713 "$node_(96) setdest 2226 291 18.0" 
$ns at 658.5116528860987 "$node_(96) setdest 1822 143 15.0" 
$ns at 778.8949987626589 "$node_(96) setdest 2235 58 3.0" 
$ns at 830.8665827762412 "$node_(96) setdest 1994 348 16.0" 
$ns at 398.6869015605446 "$node_(97) setdest 617 863 8.0" 
$ns at 506.55877811023777 "$node_(97) setdest 116 320 10.0" 
$ns at 555.4963854755022 "$node_(97) setdest 1401 65 10.0" 
$ns at 639.292270027966 "$node_(97) setdest 1445 137 13.0" 
$ns at 680.9145383021628 "$node_(97) setdest 1864 990 15.0" 
$ns at 843.16764412375 "$node_(97) setdest 2414 57 16.0" 
$ns at 356.5736250933976 "$node_(98) setdest 2476 101 10.0" 
$ns at 430.7492799928418 "$node_(98) setdest 2484 173 14.0" 
$ns at 538.2845007070738 "$node_(98) setdest 2867 317 18.0" 
$ns at 583.2527828539356 "$node_(98) setdest 2444 372 1.0" 
$ns at 616.1988915778821 "$node_(98) setdest 2374 985 11.0" 
$ns at 683.1729867002974 "$node_(98) setdest 1618 159 8.0" 
$ns at 739.9067078314152 "$node_(98) setdest 683 74 13.0" 
$ns at 773.5301882282496 "$node_(98) setdest 1472 598 19.0" 
$ns at 891.510997742152 "$node_(98) setdest 2810 660 15.0" 
$ns at 356.6599941792506 "$node_(99) setdest 277 393 19.0" 
$ns at 575.137419624941 "$node_(99) setdest 2317 40 1.0" 
$ns at 612.3087312469987 "$node_(99) setdest 2578 673 14.0" 
$ns at 672.3093754938054 "$node_(99) setdest 1600 654 15.0" 
$ns at 786.4796516169587 "$node_(99) setdest 404 88 7.0" 
$ns at 858.9150211515323 "$node_(99) setdest 1441 247 18.0" 
$ns at 588.5530922340671 "$node_(100) setdest 174 69 10.0" 
$ns at 706.083829498202 "$node_(100) setdest 386 829 19.0" 
$ns at 769.5254096071276 "$node_(100) setdest 2195 300 8.0" 
$ns at 879.5219373016745 "$node_(100) setdest 1150 617 19.0" 
$ns at 539.5033556361398 "$node_(101) setdest 2328 100 17.0" 
$ns at 676.029116039409 "$node_(101) setdest 2983 554 3.0" 
$ns at 717.6040535469067 "$node_(101) setdest 1079 866 6.0" 
$ns at 749.8568832637704 "$node_(101) setdest 730 712 2.0" 
$ns at 780.6583383545367 "$node_(101) setdest 2839 999 16.0" 
$ns at 531.6122764529518 "$node_(102) setdest 997 55 6.0" 
$ns at 562.5027659132104 "$node_(102) setdest 1797 219 9.0" 
$ns at 669.4081596869934 "$node_(102) setdest 46 340 13.0" 
$ns at 765.6576970715615 "$node_(102) setdest 2824 332 11.0" 
$ns at 810.9443409638709 "$node_(102) setdest 923 730 11.0" 
$ns at 600.2682703331882 "$node_(103) setdest 1774 867 20.0" 
$ns at 774.7651587414634 "$node_(103) setdest 2914 993 9.0" 
$ns at 835.3847067189618 "$node_(103) setdest 2087 9 9.0" 
$ns at 563.8259902357158 "$node_(104) setdest 2582 256 6.0" 
$ns at 631.5102462137787 "$node_(104) setdest 922 513 7.0" 
$ns at 703.9264015240028 "$node_(104) setdest 2557 999 6.0" 
$ns at 757.2426054689457 "$node_(104) setdest 2514 762 12.0" 
$ns at 839.8872950437199 "$node_(104) setdest 571 495 3.0" 
$ns at 895.790814114879 "$node_(104) setdest 132 724 13.0" 
$ns at 550.9540718391071 "$node_(105) setdest 2904 652 1.0" 
$ns at 588.332008625835 "$node_(105) setdest 541 206 3.0" 
$ns at 636.9402923589865 "$node_(105) setdest 2489 185 18.0" 
$ns at 827.7457737092691 "$node_(105) setdest 1532 362 5.0" 
$ns at 519.5424297361177 "$node_(106) setdest 1126 533 13.0" 
$ns at 639.8599965681728 "$node_(106) setdest 667 101 18.0" 
$ns at 692.4616299308175 "$node_(106) setdest 563 637 2.0" 
$ns at 725.3151168492733 "$node_(106) setdest 463 98 13.0" 
$ns at 819.2812373196452 "$node_(106) setdest 193 643 2.0" 
$ns at 868.3367289059468 "$node_(106) setdest 640 151 6.0" 
$ns at 501.4235856924804 "$node_(107) setdest 2479 506 10.0" 
$ns at 561.2056495512367 "$node_(107) setdest 2740 606 6.0" 
$ns at 633.4529886947802 "$node_(107) setdest 2181 324 7.0" 
$ns at 721.7223637626362 "$node_(107) setdest 1383 556 16.0" 
$ns at 856.763289927775 "$node_(107) setdest 986 531 10.0" 
$ns at 591.524715460815 "$node_(108) setdest 76 128 15.0" 
$ns at 738.4342013983467 "$node_(108) setdest 1524 375 16.0" 
$ns at 839.8197569972274 "$node_(108) setdest 2249 503 8.0" 
$ns at 497.6888500572088 "$node_(109) setdest 1448 146 9.0" 
$ns at 606.4552843722179 "$node_(109) setdest 1602 321 11.0" 
$ns at 651.5294381153486 "$node_(109) setdest 286 578 16.0" 
$ns at 690.0015026742493 "$node_(109) setdest 2541 14 1.0" 
$ns at 724.1121890788139 "$node_(109) setdest 1324 185 12.0" 
$ns at 821.1310144105383 "$node_(109) setdest 814 451 11.0" 
$ns at 877.9662909859018 "$node_(109) setdest 561 311 16.0" 
$ns at 602.2928315418299 "$node_(110) setdest 854 493 5.0" 
$ns at 664.5282601532879 "$node_(110) setdest 1173 431 1.0" 
$ns at 701.5251558677658 "$node_(110) setdest 2511 440 14.0" 
$ns at 822.6184912412109 "$node_(110) setdest 832 749 16.0" 
$ns at 513.8951985552998 "$node_(111) setdest 686 791 18.0" 
$ns at 642.5447076314738 "$node_(111) setdest 336 724 1.0" 
$ns at 676.2188437961394 "$node_(111) setdest 2297 737 9.0" 
$ns at 767.3255328999425 "$node_(111) setdest 314 655 4.0" 
$ns at 833.7824055697015 "$node_(111) setdest 852 666 11.0" 
$ns at 610.7141104840273 "$node_(112) setdest 198 261 17.0" 
$ns at 777.8533848748582 "$node_(112) setdest 1229 189 17.0" 
$ns at 531.3062738387871 "$node_(113) setdest 675 495 2.0" 
$ns at 576.2384412648208 "$node_(113) setdest 2596 902 18.0" 
$ns at 761.412075500367 "$node_(113) setdest 211 605 8.0" 
$ns at 859.7891509556086 "$node_(113) setdest 2889 122 16.0" 
$ns at 552.2561438198163 "$node_(114) setdest 1917 834 2.0" 
$ns at 584.8221152428572 "$node_(114) setdest 2555 407 14.0" 
$ns at 687.4176017059108 "$node_(114) setdest 1560 442 8.0" 
$ns at 792.4235021588764 "$node_(114) setdest 1926 622 18.0" 
$ns at 531.433868414487 "$node_(115) setdest 625 116 5.0" 
$ns at 572.0039701536309 "$node_(115) setdest 1082 661 3.0" 
$ns at 615.4982717030118 "$node_(115) setdest 1308 739 10.0" 
$ns at 678.0435916161794 "$node_(115) setdest 2037 413 11.0" 
$ns at 788.0925278826734 "$node_(115) setdest 1248 554 19.0" 
$ns at 504.929303927995 "$node_(116) setdest 1665 401 20.0" 
$ns at 676.2711513367635 "$node_(116) setdest 2306 497 12.0" 
$ns at 792.7941680201012 "$node_(116) setdest 2724 691 6.0" 
$ns at 842.6976482395133 "$node_(116) setdest 319 165 1.0" 
$ns at 873.2720787604733 "$node_(116) setdest 535 416 19.0" 
$ns at 530.0723396210332 "$node_(117) setdest 1537 561 5.0" 
$ns at 605.1693367296934 "$node_(117) setdest 1263 430 8.0" 
$ns at 656.0941495511612 "$node_(117) setdest 1889 279 3.0" 
$ns at 686.491217386751 "$node_(117) setdest 2626 480 13.0" 
$ns at 751.9228989230838 "$node_(117) setdest 2755 94 15.0" 
$ns at 809.4273707693636 "$node_(117) setdest 1874 545 11.0" 
$ns at 571.5075722685257 "$node_(118) setdest 1869 96 1.0" 
$ns at 608.5331938677609 "$node_(118) setdest 330 523 10.0" 
$ns at 654.2722451283295 "$node_(118) setdest 1749 913 8.0" 
$ns at 703.8972717289779 "$node_(118) setdest 2493 294 7.0" 
$ns at 780.6506838947134 "$node_(118) setdest 967 34 6.0" 
$ns at 860.0847450106736 "$node_(118) setdest 1364 151 8.0" 
$ns at 570.4357023495435 "$node_(119) setdest 2455 391 4.0" 
$ns at 607.0316788162693 "$node_(119) setdest 2633 645 4.0" 
$ns at 643.7446040264344 "$node_(119) setdest 2370 198 9.0" 
$ns at 729.4572365372507 "$node_(119) setdest 2177 134 14.0" 
$ns at 800.257051396944 "$node_(119) setdest 1735 966 8.0" 
$ns at 894.8462083168016 "$node_(119) setdest 1146 526 3.0" 
$ns at 535.5760629744494 "$node_(120) setdest 950 246 2.0" 
$ns at 584.0860539777797 "$node_(120) setdest 2848 81 10.0" 
$ns at 645.2674715543769 "$node_(120) setdest 1905 608 8.0" 
$ns at 691.6103921003503 "$node_(120) setdest 570 404 17.0" 
$ns at 857.2166331471108 "$node_(120) setdest 2811 409 11.0" 
$ns at 563.5504984734359 "$node_(121) setdest 515 390 13.0" 
$ns at 683.8152001014228 "$node_(121) setdest 2444 174 14.0" 
$ns at 715.069724629193 "$node_(121) setdest 408 190 10.0" 
$ns at 843.3018220707238 "$node_(121) setdest 860 863 13.0" 
$ns at 887.316148645442 "$node_(121) setdest 864 566 1.0" 
$ns at 521.7517321508999 "$node_(122) setdest 2843 211 7.0" 
$ns at 555.3604056736236 "$node_(122) setdest 2255 944 7.0" 
$ns at 613.1152913699282 "$node_(122) setdest 629 560 6.0" 
$ns at 655.3688051905775 "$node_(122) setdest 2008 56 3.0" 
$ns at 692.5554040178192 "$node_(122) setdest 2648 511 15.0" 
$ns at 777.7415081778427 "$node_(122) setdest 2741 5 8.0" 
$ns at 881.5443171819128 "$node_(122) setdest 2138 543 8.0" 
$ns at 508.7928107230938 "$node_(123) setdest 2075 62 17.0" 
$ns at 691.9976643437706 "$node_(123) setdest 886 991 14.0" 
$ns at 818.9494281692143 "$node_(123) setdest 1750 178 16.0" 
$ns at 896.759737973273 "$node_(123) setdest 2740 612 13.0" 
$ns at 521.9085124868975 "$node_(124) setdest 442 460 4.0" 
$ns at 568.5367249220228 "$node_(124) setdest 2795 630 8.0" 
$ns at 659.3997196533078 "$node_(124) setdest 2914 873 1.0" 
$ns at 691.2348712622979 "$node_(124) setdest 2368 419 6.0" 
$ns at 721.9811862088405 "$node_(124) setdest 169 586 6.0" 
$ns at 769.2970278018031 "$node_(124) setdest 2782 448 11.0" 
$ns at 886.7630455962452 "$node_(124) setdest 2797 754 8.0" 
$ns at 680.0867604011551 "$node_(125) setdest 2814 758 16.0" 
$ns at 741.4291339794077 "$node_(125) setdest 2865 988 14.0" 
$ns at 811.6161379740028 "$node_(125) setdest 2756 59 4.0" 
$ns at 848.3728197471715 "$node_(125) setdest 1359 352 10.0" 
$ns at 701.9495975981852 "$node_(126) setdest 1364 947 12.0" 
$ns at 769.840582941664 "$node_(126) setdest 1200 557 9.0" 
$ns at 831.3535065119572 "$node_(126) setdest 2668 668 15.0" 
$ns at 667.4283641720866 "$node_(127) setdest 1787 879 3.0" 
$ns at 700.4440651970435 "$node_(127) setdest 2356 346 12.0" 
$ns at 782.1795263921663 "$node_(127) setdest 72 518 19.0" 
$ns at 818.4615747940303 "$node_(127) setdest 2585 74 16.0" 
$ns at 689.5262580145858 "$node_(128) setdest 2880 353 7.0" 
$ns at 741.067093969113 "$node_(128) setdest 660 961 8.0" 
$ns at 828.571697132005 "$node_(128) setdest 2348 568 9.0" 
$ns at 891.4126857145648 "$node_(128) setdest 2079 918 17.0" 
$ns at 692.370330744088 "$node_(129) setdest 1628 79 17.0" 
$ns at 730.711237386241 "$node_(129) setdest 2582 734 15.0" 
$ns at 877.7339552167117 "$node_(129) setdest 1378 481 13.0" 
$ns at 703.6079741215252 "$node_(130) setdest 1259 452 19.0" 
$ns at 875.9848324793693 "$node_(130) setdest 1867 132 15.0" 
$ns at 667.3910472417949 "$node_(131) setdest 2841 810 19.0" 
$ns at 868.5511810844022 "$node_(131) setdest 1047 954 9.0" 
$ns at 736.4928316960287 "$node_(132) setdest 2519 433 20.0" 
$ns at 879.1681419140882 "$node_(132) setdest 2996 397 8.0" 
$ns at 742.4929391995936 "$node_(133) setdest 853 370 10.0" 
$ns at 867.4023682060558 "$node_(133) setdest 2070 35 17.0" 
$ns at 712.6511267633427 "$node_(134) setdest 1833 680 18.0" 
$ns at 853.8198450838636 "$node_(134) setdest 1733 545 12.0" 
$ns at 661.7017821668401 "$node_(135) setdest 1405 202 10.0" 
$ns at 788.6498125758375 "$node_(135) setdest 2642 450 14.0" 
$ns at 858.2511729456874 "$node_(135) setdest 46 468 12.0" 
$ns at 829.1085353197699 "$node_(136) setdest 2259 102 12.0" 
$ns at 703.5193203393326 "$node_(137) setdest 2767 851 8.0" 
$ns at 738.7696072885647 "$node_(137) setdest 2691 3 16.0" 
$ns at 820.4631320461282 "$node_(137) setdest 2070 137 13.0" 
$ns at 740.0816148294537 "$node_(138) setdest 2188 10 20.0" 
$ns at 679.218273680576 "$node_(139) setdest 2739 299 10.0" 
$ns at 717.1884320974477 "$node_(139) setdest 310 432 19.0" 
$ns at 854.6467988735457 "$node_(139) setdest 1129 111 18.0" 
$ns at 702.6118805697613 "$node_(140) setdest 103 67 19.0" 
$ns at 766.1598397422082 "$node_(140) setdest 2034 960 7.0" 
$ns at 851.3080711183954 "$node_(140) setdest 220 223 8.0" 
$ns at 882.5570844785512 "$node_(140) setdest 1485 552 2.0" 
$ns at 721.3913808765097 "$node_(141) setdest 1599 722 19.0" 
$ns at 703.3348059849048 "$node_(142) setdest 2209 616 6.0" 
$ns at 781.0648493634711 "$node_(142) setdest 2747 861 5.0" 
$ns at 847.3002874913907 "$node_(142) setdest 2333 557 19.0" 
$ns at 750.191316574872 "$node_(143) setdest 1044 502 12.0" 
$ns at 878.8435006364651 "$node_(143) setdest 893 167 1.0" 
$ns at 682.5374566891786 "$node_(144) setdest 160 385 17.0" 
$ns at 795.5092629575544 "$node_(144) setdest 294 556 5.0" 
$ns at 851.8394308329517 "$node_(144) setdest 102 794 20.0" 
$ns at 675.5085697155719 "$node_(145) setdest 2554 860 5.0" 
$ns at 737.3448549498953 "$node_(145) setdest 1058 348 9.0" 
$ns at 853.5307996866371 "$node_(145) setdest 354 231 18.0" 
$ns at 675.4092155247082 "$node_(146) setdest 1836 92 7.0" 
$ns at 710.2704104504129 "$node_(146) setdest 967 988 13.0" 
$ns at 820.8159426632058 "$node_(146) setdest 1587 75 5.0" 
$ns at 860.7436041872949 "$node_(146) setdest 733 242 5.0" 
$ns at 681.4147081202373 "$node_(147) setdest 2155 364 5.0" 
$ns at 749.1285159618842 "$node_(147) setdest 1868 407 9.0" 
$ns at 841.4478826167409 "$node_(147) setdest 2195 914 7.0" 
$ns at 716.2537572222179 "$node_(148) setdest 2508 881 17.0" 
$ns at 747.4462298822965 "$node_(148) setdest 1427 812 11.0" 
$ns at 794.465195253545 "$node_(148) setdest 276 905 13.0" 
$ns at 884.3982111381208 "$node_(148) setdest 2269 869 7.0" 
$ns at 660.3050256246279 "$node_(149) setdest 2164 159 10.0" 
$ns at 784.6416663942146 "$node_(149) setdest 2322 843 20.0" 


#Set a TCP connection between node_(7) and node_(20)
set tcp_(0) [new Agent/TCP/Newreno]
$tcp_(0) set class_ 2
set sink_(0) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(0)
$ns attach-agent $node_(20) $sink_(0)
$ns connect $tcp_(0) $sink_(0)
set ftp_(0) [new Application/FTP]
$ftp_(0) attach-agent $tcp_(0)
$ns at 0.2 "$ftp_(0) start"
$ns at 180.0 "$ftp_(0) stop"

#Set a TCP connection between node_(19) and node_(5)
set tcp_(1) [new Agent/TCP/Newreno]
$tcp_(1) set class_ 2
set sink_(1) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(1)
$ns attach-agent $node_(5) $sink_(1)
$ns connect $tcp_(1) $sink_(1)
set ftp_(1) [new Application/FTP]
$ftp_(1) attach-agent $tcp_(1)
$ns at 180.2 "$ftp_(1) start"
$ns at 360.0 "$ftp_(1) stop"

#Set a TCP connection between node_(14) and node_(31)
set tcp_(2) [new Agent/TCP/Newreno]
$tcp_(2) set class_ 2
set sink_(2) [new Agent/TCPSink]
$ns attach-agent $node_(14) $tcp_(2)
$ns attach-agent $node_(31) $sink_(2)
$ns connect $tcp_(2) $sink_(2)
set ftp_(2) [new Application/FTP]
$ftp_(2) attach-agent $tcp_(2)
$ns at 360.2 "$ftp_(2) start"
$ns at 540.0 "$ftp_(2) stop"

#Set a TCP connection between node_(44) and node_(16)
set tcp_(3) [new Agent/TCP/Newreno]
$tcp_(3) set class_ 2
set sink_(3) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(3)
$ns attach-agent $node_(16) $sink_(3)
$ns connect $tcp_(3) $sink_(3)
set ftp_(3) [new Application/FTP]
$ftp_(3) attach-agent $tcp_(3)
$ns at 540.2 "$ftp_(3) start"
$ns at 720.0 "$ftp_(3) stop"

#Set a TCP connection between node_(22) and node_(4)
set tcp_(4) [new Agent/TCP/Newreno]
$tcp_(4) set class_ 2
set sink_(4) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(4)
$ns attach-agent $node_(4) $sink_(4)
$ns connect $tcp_(4) $sink_(4)
set ftp_(4) [new Application/FTP]
$ftp_(4) attach-agent $tcp_(4)
$ns at 720.2 "$ftp_(4) start"
$ns at 900.0 "$ftp_(4) stop"

#Set a TCP connection between node_(33) and node_(14)
set tcp_(5) [new Agent/TCP/Newreno]
$tcp_(5) set class_ 2
set sink_(5) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(5)
$ns attach-agent $node_(14) $sink_(5)
$ns connect $tcp_(5) $sink_(5)
set ftp_(5) [new Application/FTP]
$ftp_(5) attach-agent $tcp_(5)
$ns at 0.2 "$ftp_(5) start"
$ns at 180.0 "$ftp_(5) stop"

#Set a TCP connection between node_(15) and node_(22)
set tcp_(6) [new Agent/TCP/Newreno]
$tcp_(6) set class_ 2
set sink_(6) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(6)
$ns attach-agent $node_(22) $sink_(6)
$ns connect $tcp_(6) $sink_(6)
set ftp_(6) [new Application/FTP]
$ftp_(6) attach-agent $tcp_(6)
$ns at 180.2 "$ftp_(6) start"
$ns at 360.0 "$ftp_(6) stop"

#Set a TCP connection between node_(11) and node_(49)
set tcp_(7) [new Agent/TCP/Newreno]
$tcp_(7) set class_ 2
set sink_(7) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(7)
$ns attach-agent $node_(49) $sink_(7)
$ns connect $tcp_(7) $sink_(7)
set ftp_(7) [new Application/FTP]
$ftp_(7) attach-agent $tcp_(7)
$ns at 360.2 "$ftp_(7) start"
$ns at 540.0 "$ftp_(7) stop"

#Set a TCP connection between node_(3) and node_(31)
set tcp_(8) [new Agent/TCP/Newreno]
$tcp_(8) set class_ 2
set sink_(8) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(8)
$ns attach-agent $node_(31) $sink_(8)
$ns connect $tcp_(8) $sink_(8)
set ftp_(8) [new Application/FTP]
$ftp_(8) attach-agent $tcp_(8)
$ns at 540.2 "$ftp_(8) start"
$ns at 720.0 "$ftp_(8) stop"

#Set a TCP connection between node_(14) and node_(22)
set tcp_(9) [new Agent/TCP/Newreno]
$tcp_(9) set class_ 2
set sink_(9) [new Agent/TCPSink]
$ns attach-agent $node_(14) $tcp_(9)
$ns attach-agent $node_(22) $sink_(9)
$ns connect $tcp_(9) $sink_(9)
set ftp_(9) [new Application/FTP]
$ftp_(9) attach-agent $tcp_(9)
$ns at 720.2 "$ftp_(9) start"
$ns at 900.0 "$ftp_(9) stop"

#Set a TCP connection between node_(35) and node_(40)
set tcp_(10) [new Agent/TCP/Newreno]
$tcp_(10) set class_ 2
set sink_(10) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(10)
$ns attach-agent $node_(40) $sink_(10)
$ns connect $tcp_(10) $sink_(10)
set ftp_(10) [new Application/FTP]
$ftp_(10) attach-agent $tcp_(10)
$ns at 0.2 "$ftp_(10) start"
$ns at 180.0 "$ftp_(10) stop"

#Set a TCP connection between node_(4) and node_(8)
set tcp_(11) [new Agent/TCP/Newreno]
$tcp_(11) set class_ 2
set sink_(11) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(11)
$ns attach-agent $node_(8) $sink_(11)
$ns connect $tcp_(11) $sink_(11)
set ftp_(11) [new Application/FTP]
$ftp_(11) attach-agent $tcp_(11)
$ns at 180.2 "$ftp_(11) start"
$ns at 360.0 "$ftp_(11) stop"

#Set a TCP connection between node_(12) and node_(35)
set tcp_(12) [new Agent/TCP/Newreno]
$tcp_(12) set class_ 2
set sink_(12) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(12)
$ns attach-agent $node_(35) $sink_(12)
$ns connect $tcp_(12) $sink_(12)
set ftp_(12) [new Application/FTP]
$ftp_(12) attach-agent $tcp_(12)
$ns at 360.2 "$ftp_(12) start"
$ns at 540.0 "$ftp_(12) stop"

#Set a TCP connection between node_(39) and node_(36)
set tcp_(13) [new Agent/TCP/Newreno]
$tcp_(13) set class_ 2
set sink_(13) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(13)
$ns attach-agent $node_(36) $sink_(13)
$ns connect $tcp_(13) $sink_(13)
set ftp_(13) [new Application/FTP]
$ftp_(13) attach-agent $tcp_(13)
$ns at 540.2 "$ftp_(13) start"
$ns at 720.0 "$ftp_(13) stop"

#Set a TCP connection between node_(39) and node_(9)
set tcp_(14) [new Agent/TCP/Newreno]
$tcp_(14) set class_ 2
set sink_(14) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(14)
$ns attach-agent $node_(9) $sink_(14)
$ns connect $tcp_(14) $sink_(14)
set ftp_(14) [new Application/FTP]
$ftp_(14) attach-agent $tcp_(14)
$ns at 720.2 "$ftp_(14) start"
$ns at 900.0 "$ftp_(14) stop"

#Set a TCP connection between node_(12) and node_(24)
set tcp_(15) [new Agent/TCP/Newreno]
$tcp_(15) set class_ 2
set sink_(15) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(15)
$ns attach-agent $node_(24) $sink_(15)
$ns connect $tcp_(15) $sink_(15)
set ftp_(15) [new Application/FTP]
$ftp_(15) attach-agent $tcp_(15)
$ns at 0.2 "$ftp_(15) start"
$ns at 180.0 "$ftp_(15) stop"

#Set a TCP connection between node_(17) and node_(16)
set tcp_(16) [new Agent/TCP/Newreno]
$tcp_(16) set class_ 2
set sink_(16) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(16)
$ns attach-agent $node_(16) $sink_(16)
$ns connect $tcp_(16) $sink_(16)
set ftp_(16) [new Application/FTP]
$ftp_(16) attach-agent $tcp_(16)
$ns at 180.2 "$ftp_(16) start"
$ns at 360.0 "$ftp_(16) stop"

#Set a TCP connection between node_(32) and node_(7)
set tcp_(17) [new Agent/TCP/Newreno]
$tcp_(17) set class_ 2
set sink_(17) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(17)
$ns attach-agent $node_(7) $sink_(17)
$ns connect $tcp_(17) $sink_(17)
set ftp_(17) [new Application/FTP]
$ftp_(17) attach-agent $tcp_(17)
$ns at 360.2 "$ftp_(17) start"
$ns at 540.0 "$ftp_(17) stop"

#Set a TCP connection between node_(44) and node_(7)
set tcp_(18) [new Agent/TCP/Newreno]
$tcp_(18) set class_ 2
set sink_(18) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(18)
$ns attach-agent $node_(7) $sink_(18)
$ns connect $tcp_(18) $sink_(18)
set ftp_(18) [new Application/FTP]
$ftp_(18) attach-agent $tcp_(18)
$ns at 540.2 "$ftp_(18) start"
$ns at 720.0 "$ftp_(18) stop"

#Set a TCP connection between node_(25) and node_(42)
set tcp_(19) [new Agent/TCP/Newreno]
$tcp_(19) set class_ 2
set sink_(19) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(19)
$ns attach-agent $node_(42) $sink_(19)
$ns connect $tcp_(19) $sink_(19)
set ftp_(19) [new Application/FTP]
$ftp_(19) attach-agent $tcp_(19)
$ns at 720.2 "$ftp_(19) start"
$ns at 900.0 "$ftp_(19) stop"

#Set a TCP connection between node_(3) and node_(46)
set tcp_(20) [new Agent/TCP/Newreno]
$tcp_(20) set class_ 2
set sink_(20) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(20)
$ns attach-agent $node_(46) $sink_(20)
$ns connect $tcp_(20) $sink_(20)
set ftp_(20) [new Application/FTP]
$ftp_(20) attach-agent $tcp_(20)
$ns at 0.2 "$ftp_(20) start"
$ns at 180.0 "$ftp_(20) stop"

#Set a TCP connection between node_(8) and node_(18)
set tcp_(21) [new Agent/TCP/Newreno]
$tcp_(21) set class_ 2
set sink_(21) [new Agent/TCPSink]
$ns attach-agent $node_(8) $tcp_(21)
$ns attach-agent $node_(18) $sink_(21)
$ns connect $tcp_(21) $sink_(21)
set ftp_(21) [new Application/FTP]
$ftp_(21) attach-agent $tcp_(21)
$ns at 180.2 "$ftp_(21) start"
$ns at 360.0 "$ftp_(21) stop"

#Set a TCP connection between node_(30) and node_(14)
set tcp_(22) [new Agent/TCP/Newreno]
$tcp_(22) set class_ 2
set sink_(22) [new Agent/TCPSink]
$ns attach-agent $node_(30) $tcp_(22)
$ns attach-agent $node_(14) $sink_(22)
$ns connect $tcp_(22) $sink_(22)
set ftp_(22) [new Application/FTP]
$ftp_(22) attach-agent $tcp_(22)
$ns at 360.2 "$ftp_(22) start"
$ns at 540.0 "$ftp_(22) stop"

#Set a TCP connection between node_(31) and node_(4)
set tcp_(23) [new Agent/TCP/Newreno]
$tcp_(23) set class_ 2
set sink_(23) [new Agent/TCPSink]
$ns attach-agent $node_(31) $tcp_(23)
$ns attach-agent $node_(4) $sink_(23)
$ns connect $tcp_(23) $sink_(23)
set ftp_(23) [new Application/FTP]
$ftp_(23) attach-agent $tcp_(23)
$ns at 540.2 "$ftp_(23) start"
$ns at 720.0 "$ftp_(23) stop"

#Set a TCP connection between node_(48) and node_(39)
set tcp_(24) [new Agent/TCP/Newreno]
$tcp_(24) set class_ 2
set sink_(24) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(24)
$ns attach-agent $node_(39) $sink_(24)
$ns connect $tcp_(24) $sink_(24)
set ftp_(24) [new Application/FTP]
$ftp_(24) attach-agent $tcp_(24)
$ns at 720.2 "$ftp_(24) start"
$ns at 900.0 "$ftp_(24) stop"

#Set a TCP connection between node_(26) and node_(42)
set tcp_(25) [new Agent/TCP/Newreno]
$tcp_(25) set class_ 2
set sink_(25) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(25)
$ns attach-agent $node_(42) $sink_(25)
$ns connect $tcp_(25) $sink_(25)
set ftp_(25) [new Application/FTP]
$ftp_(25) attach-agent $tcp_(25)
$ns at 0.2 "$ftp_(25) start"
$ns at 180.0 "$ftp_(25) stop"

#Set a TCP connection between node_(23) and node_(12)
set tcp_(26) [new Agent/TCP/Newreno]
$tcp_(26) set class_ 2
set sink_(26) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(26)
$ns attach-agent $node_(12) $sink_(26)
$ns connect $tcp_(26) $sink_(26)
set ftp_(26) [new Application/FTP]
$ftp_(26) attach-agent $tcp_(26)
$ns at 180.2 "$ftp_(26) start"
$ns at 360.0 "$ftp_(26) stop"

#Set a TCP connection between node_(47) and node_(13)
set tcp_(27) [new Agent/TCP/Newreno]
$tcp_(27) set class_ 2
set sink_(27) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(27)
$ns attach-agent $node_(13) $sink_(27)
$ns connect $tcp_(27) $sink_(27)
set ftp_(27) [new Application/FTP]
$ftp_(27) attach-agent $tcp_(27)
$ns at 360.2 "$ftp_(27) start"
$ns at 540.0 "$ftp_(27) stop"

#Set a TCP connection between node_(21) and node_(0)
set tcp_(28) [new Agent/TCP/Newreno]
$tcp_(28) set class_ 2
set sink_(28) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(28)
$ns attach-agent $node_(0) $sink_(28)
$ns connect $tcp_(28) $sink_(28)
set ftp_(28) [new Application/FTP]
$ftp_(28) attach-agent $tcp_(28)
$ns at 540.2 "$ftp_(28) start"
$ns at 720.0 "$ftp_(28) stop"

#Set a TCP connection between node_(12) and node_(15)
set tcp_(29) [new Agent/TCP/Newreno]
$tcp_(29) set class_ 2
set sink_(29) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(29)
$ns attach-agent $node_(15) $sink_(29)
$ns connect $tcp_(29) $sink_(29)
set ftp_(29) [new Application/FTP]
$ftp_(29) attach-agent $tcp_(29)
$ns at 720.2 "$ftp_(29) start"
$ns at 900.0 "$ftp_(29) stop"

#Set a TCP connection between node_(39) and node_(27)
set tcp_(30) [new Agent/TCP/Newreno]
$tcp_(30) set class_ 2
set sink_(30) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(30)
$ns attach-agent $node_(27) $sink_(30)
$ns connect $tcp_(30) $sink_(30)
set ftp_(30) [new Application/FTP]
$ftp_(30) attach-agent $tcp_(30)
$ns at 0.2 "$ftp_(30) start"
$ns at 180.0 "$ftp_(30) stop"

#Set a TCP connection between node_(44) and node_(31)
set tcp_(31) [new Agent/TCP/Newreno]
$tcp_(31) set class_ 2
set sink_(31) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(31)
$ns attach-agent $node_(31) $sink_(31)
$ns connect $tcp_(31) $sink_(31)
set ftp_(31) [new Application/FTP]
$ftp_(31) attach-agent $tcp_(31)
$ns at 180.2 "$ftp_(31) start"
$ns at 360.0 "$ftp_(31) stop"

#Set a TCP connection between node_(24) and node_(21)
set tcp_(32) [new Agent/TCP/Newreno]
$tcp_(32) set class_ 2
set sink_(32) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(32)
$ns attach-agent $node_(21) $sink_(32)
$ns connect $tcp_(32) $sink_(32)
set ftp_(32) [new Application/FTP]
$ftp_(32) attach-agent $tcp_(32)
$ns at 360.2 "$ftp_(32) start"
$ns at 540.0 "$ftp_(32) stop"

#Set a TCP connection between node_(18) and node_(32)
set tcp_(33) [new Agent/TCP/Newreno]
$tcp_(33) set class_ 2
set sink_(33) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(33)
$ns attach-agent $node_(32) $sink_(33)
$ns connect $tcp_(33) $sink_(33)
set ftp_(33) [new Application/FTP]
$ftp_(33) attach-agent $tcp_(33)
$ns at 540.2 "$ftp_(33) start"
$ns at 720.0 "$ftp_(33) stop"

#Set a TCP connection between node_(20) and node_(13)
set tcp_(34) [new Agent/TCP/Newreno]
$tcp_(34) set class_ 2
set sink_(34) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(34)
$ns attach-agent $node_(13) $sink_(34)
$ns connect $tcp_(34) $sink_(34)
set ftp_(34) [new Application/FTP]
$ftp_(34) attach-agent $tcp_(34)
$ns at 720.2 "$ftp_(34) start"
$ns at 900.0 "$ftp_(34) stop"

#Set a TCP connection between node_(38) and node_(7)
set tcp_(35) [new Agent/TCP/Newreno]
$tcp_(35) set class_ 2
set sink_(35) [new Agent/TCPSink]
$ns attach-agent $node_(38) $tcp_(35)
$ns attach-agent $node_(7) $sink_(35)
$ns connect $tcp_(35) $sink_(35)
set ftp_(35) [new Application/FTP]
$ftp_(35) attach-agent $tcp_(35)
$ns at 0.2 "$ftp_(35) start"
$ns at 180.0 "$ftp_(35) stop"

#Set a TCP connection between node_(37) and node_(9)
set tcp_(36) [new Agent/TCP/Newreno]
$tcp_(36) set class_ 2
set sink_(36) [new Agent/TCPSink]
$ns attach-agent $node_(37) $tcp_(36)
$ns attach-agent $node_(9) $sink_(36)
$ns connect $tcp_(36) $sink_(36)
set ftp_(36) [new Application/FTP]
$ftp_(36) attach-agent $tcp_(36)
$ns at 180.2 "$ftp_(36) start"
$ns at 360.0 "$ftp_(36) stop"

#Set a TCP connection between node_(45) and node_(48)
set tcp_(37) [new Agent/TCP/Newreno]
$tcp_(37) set class_ 2
set sink_(37) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(37)
$ns attach-agent $node_(48) $sink_(37)
$ns connect $tcp_(37) $sink_(37)
set ftp_(37) [new Application/FTP]
$ftp_(37) attach-agent $tcp_(37)
$ns at 360.2 "$ftp_(37) start"
$ns at 540.0 "$ftp_(37) stop"

#Set a TCP connection between node_(46) and node_(34)
set tcp_(38) [new Agent/TCP/Newreno]
$tcp_(38) set class_ 2
set sink_(38) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(38)
$ns attach-agent $node_(34) $sink_(38)
$ns connect $tcp_(38) $sink_(38)
set ftp_(38) [new Application/FTP]
$ftp_(38) attach-agent $tcp_(38)
$ns at 540.2 "$ftp_(38) start"
$ns at 720.0 "$ftp_(38) stop"

#Set a TCP connection between node_(44) and node_(21)
set tcp_(39) [new Agent/TCP/Newreno]
$tcp_(39) set class_ 2
set sink_(39) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(39)
$ns attach-agent $node_(21) $sink_(39)
$ns connect $tcp_(39) $sink_(39)
set ftp_(39) [new Application/FTP]
$ftp_(39) attach-agent $tcp_(39)
$ns at 720.2 "$ftp_(39) start"
$ns at 900.0 "$ftp_(39) stop"

#Set a TCP connection between node_(1) and node_(13)
set tcp_(40) [new Agent/TCP/Newreno]
$tcp_(40) set class_ 2
set sink_(40) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(40)
$ns attach-agent $node_(13) $sink_(40)
$ns connect $tcp_(40) $sink_(40)
set ftp_(40) [new Application/FTP]
$ftp_(40) attach-agent $tcp_(40)
$ns at 0.2 "$ftp_(40) start"
$ns at 180.0 "$ftp_(40) stop"

#Set a TCP connection between node_(33) and node_(43)
set tcp_(41) [new Agent/TCP/Newreno]
$tcp_(41) set class_ 2
set sink_(41) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(41)
$ns attach-agent $node_(43) $sink_(41)
$ns connect $tcp_(41) $sink_(41)
set ftp_(41) [new Application/FTP]
$ftp_(41) attach-agent $tcp_(41)
$ns at 180.2 "$ftp_(41) start"
$ns at 360.0 "$ftp_(41) stop"

#Set a TCP connection between node_(43) and node_(19)
set tcp_(42) [new Agent/TCP/Newreno]
$tcp_(42) set class_ 2
set sink_(42) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(42)
$ns attach-agent $node_(19) $sink_(42)
$ns connect $tcp_(42) $sink_(42)
set ftp_(42) [new Application/FTP]
$ftp_(42) attach-agent $tcp_(42)
$ns at 360.2 "$ftp_(42) start"
$ns at 540.0 "$ftp_(42) stop"

#Set a TCP connection between node_(27) and node_(39)
set tcp_(43) [new Agent/TCP/Newreno]
$tcp_(43) set class_ 2
set sink_(43) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(43)
$ns attach-agent $node_(39) $sink_(43)
$ns connect $tcp_(43) $sink_(43)
set ftp_(43) [new Application/FTP]
$ftp_(43) attach-agent $tcp_(43)
$ns at 540.2 "$ftp_(43) start"
$ns at 720.0 "$ftp_(43) stop"

#Set a TCP connection between node_(47) and node_(40)
set tcp_(44) [new Agent/TCP/Newreno]
$tcp_(44) set class_ 2
set sink_(44) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(44)
$ns attach-agent $node_(40) $sink_(44)
$ns connect $tcp_(44) $sink_(44)
set ftp_(44) [new Application/FTP]
$ftp_(44) attach-agent $tcp_(44)
$ns at 720.2 "$ftp_(44) start"
$ns at 900.0 "$ftp_(44) stop"

#Set a TCP connection between node_(9) and node_(19)
set tcp_(45) [new Agent/TCP/Newreno]
$tcp_(45) set class_ 2
set sink_(45) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(45)
$ns attach-agent $node_(19) $sink_(45)
$ns connect $tcp_(45) $sink_(45)
set ftp_(45) [new Application/FTP]
$ftp_(45) attach-agent $tcp_(45)
$ns at 0.2 "$ftp_(45) start"
$ns at 180.0 "$ftp_(45) stop"

#Set a TCP connection between node_(10) and node_(26)
set tcp_(46) [new Agent/TCP/Newreno]
$tcp_(46) set class_ 2
set sink_(46) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(46)
$ns attach-agent $node_(26) $sink_(46)
$ns connect $tcp_(46) $sink_(46)
set ftp_(46) [new Application/FTP]
$ftp_(46) attach-agent $tcp_(46)
$ns at 180.2 "$ftp_(46) start"
$ns at 360.0 "$ftp_(46) stop"

#Set a TCP connection between node_(24) and node_(16)
set tcp_(47) [new Agent/TCP/Newreno]
$tcp_(47) set class_ 2
set sink_(47) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(47)
$ns attach-agent $node_(16) $sink_(47)
$ns connect $tcp_(47) $sink_(47)
set ftp_(47) [new Application/FTP]
$ftp_(47) attach-agent $tcp_(47)
$ns at 360.2 "$ftp_(47) start"
$ns at 540.0 "$ftp_(47) stop"

#Set a TCP connection between node_(42) and node_(46)
set tcp_(48) [new Agent/TCP/Newreno]
$tcp_(48) set class_ 2
set sink_(48) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(48)
$ns attach-agent $node_(46) $sink_(48)
$ns connect $tcp_(48) $sink_(48)
set ftp_(48) [new Application/FTP]
$ftp_(48) attach-agent $tcp_(48)
$ns at 540.2 "$ftp_(48) start"
$ns at 720.0 "$ftp_(48) stop"

#Set a TCP connection between node_(19) and node_(35)
set tcp_(49) [new Agent/TCP/Newreno]
$tcp_(49) set class_ 2
set sink_(49) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(49)
$ns attach-agent $node_(35) $sink_(49)
$ns connect $tcp_(49) $sink_(49)
set ftp_(49) [new Application/FTP]
$ftp_(49) attach-agent $tcp_(49)
$ns at 720.2 "$ftp_(49) start"
$ns at 900.0 "$ftp_(49) stop"

#Set a TCP connection between node_(12) and node_(10)
set tcp_(50) [new Agent/TCP/Newreno]
$tcp_(50) set class_ 2
set sink_(50) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(50)
$ns attach-agent $node_(10) $sink_(50)
$ns connect $tcp_(50) $sink_(50)
set ftp_(50) [new Application/FTP]
$ftp_(50) attach-agent $tcp_(50)
$ns at 0.2 "$ftp_(50) start"
$ns at 180.0 "$ftp_(50) stop"

#Set a TCP connection between node_(19) and node_(26)
set tcp_(51) [new Agent/TCP/Newreno]
$tcp_(51) set class_ 2
set sink_(51) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(51)
$ns attach-agent $node_(26) $sink_(51)
$ns connect $tcp_(51) $sink_(51)
set ftp_(51) [new Application/FTP]
$ftp_(51) attach-agent $tcp_(51)
$ns at 180.2 "$ftp_(51) start"
$ns at 360.0 "$ftp_(51) stop"

#Set a TCP connection between node_(46) and node_(38)
set tcp_(52) [new Agent/TCP/Newreno]
$tcp_(52) set class_ 2
set sink_(52) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(52)
$ns attach-agent $node_(38) $sink_(52)
$ns connect $tcp_(52) $sink_(52)
set ftp_(52) [new Application/FTP]
$ftp_(52) attach-agent $tcp_(52)
$ns at 360.2 "$ftp_(52) start"
$ns at 540.0 "$ftp_(52) stop"

#Set a TCP connection between node_(0) and node_(18)
set tcp_(53) [new Agent/TCP/Newreno]
$tcp_(53) set class_ 2
set sink_(53) [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp_(53)
$ns attach-agent $node_(18) $sink_(53)
$ns connect $tcp_(53) $sink_(53)
set ftp_(53) [new Application/FTP]
$ftp_(53) attach-agent $tcp_(53)
$ns at 540.2 "$ftp_(53) start"
$ns at 720.0 "$ftp_(53) stop"

#Set a TCP connection between node_(19) and node_(33)
set tcp_(54) [new Agent/TCP/Newreno]
$tcp_(54) set class_ 2
set sink_(54) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(54)
$ns attach-agent $node_(33) $sink_(54)
$ns connect $tcp_(54) $sink_(54)
set ftp_(54) [new Application/FTP]
$ftp_(54) attach-agent $tcp_(54)
$ns at 720.2 "$ftp_(54) start"
$ns at 900.0 "$ftp_(54) stop"

#Set a TCP connection between node_(48) and node_(0)
set tcp_(55) [new Agent/TCP/Newreno]
$tcp_(55) set class_ 2
set sink_(55) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(55)
$ns attach-agent $node_(0) $sink_(55)
$ns connect $tcp_(55) $sink_(55)
set ftp_(55) [new Application/FTP]
$ftp_(55) attach-agent $tcp_(55)
$ns at 0.2 "$ftp_(55) start"
$ns at 180.0 "$ftp_(55) stop"

#Set a TCP connection between node_(32) and node_(20)
set tcp_(56) [new Agent/TCP/Newreno]
$tcp_(56) set class_ 2
set sink_(56) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(56)
$ns attach-agent $node_(20) $sink_(56)
$ns connect $tcp_(56) $sink_(56)
set ftp_(56) [new Application/FTP]
$ftp_(56) attach-agent $tcp_(56)
$ns at 180.2 "$ftp_(56) start"
$ns at 360.0 "$ftp_(56) stop"

#Set a TCP connection between node_(29) and node_(35)
set tcp_(57) [new Agent/TCP/Newreno]
$tcp_(57) set class_ 2
set sink_(57) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(57)
$ns attach-agent $node_(35) $sink_(57)
$ns connect $tcp_(57) $sink_(57)
set ftp_(57) [new Application/FTP]
$ftp_(57) attach-agent $tcp_(57)
$ns at 360.2 "$ftp_(57) start"
$ns at 540.0 "$ftp_(57) stop"

#Set a TCP connection between node_(0) and node_(42)
set tcp_(58) [new Agent/TCP/Newreno]
$tcp_(58) set class_ 2
set sink_(58) [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp_(58)
$ns attach-agent $node_(42) $sink_(58)
$ns connect $tcp_(58) $sink_(58)
set ftp_(58) [new Application/FTP]
$ftp_(58) attach-agent $tcp_(58)
$ns at 540.2 "$ftp_(58) start"
$ns at 720.0 "$ftp_(58) stop"

#Set a TCP connection between node_(39) and node_(49)
set tcp_(59) [new Agent/TCP/Newreno]
$tcp_(59) set class_ 2
set sink_(59) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(59)
$ns attach-agent $node_(49) $sink_(59)
$ns connect $tcp_(59) $sink_(59)
set ftp_(59) [new Application/FTP]
$ftp_(59) attach-agent $tcp_(59)
$ns at 720.2 "$ftp_(59) start"
$ns at 900.0 "$ftp_(59) stop"

#Set a TCP connection between node_(4) and node_(20)
set tcp_(60) [new Agent/TCP/Newreno]
$tcp_(60) set class_ 2
set sink_(60) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(60)
$ns attach-agent $node_(20) $sink_(60)
$ns connect $tcp_(60) $sink_(60)
set ftp_(60) [new Application/FTP]
$ftp_(60) attach-agent $tcp_(60)
$ns at 0.2 "$ftp_(60) start"
$ns at 180.0 "$ftp_(60) stop"

#Set a TCP connection between node_(17) and node_(34)
set tcp_(61) [new Agent/TCP/Newreno]
$tcp_(61) set class_ 2
set sink_(61) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(61)
$ns attach-agent $node_(34) $sink_(61)
$ns connect $tcp_(61) $sink_(61)
set ftp_(61) [new Application/FTP]
$ftp_(61) attach-agent $tcp_(61)
$ns at 180.2 "$ftp_(61) start"
$ns at 360.0 "$ftp_(61) stop"

#Set a TCP connection between node_(18) and node_(39)
set tcp_(62) [new Agent/TCP/Newreno]
$tcp_(62) set class_ 2
set sink_(62) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(62)
$ns attach-agent $node_(39) $sink_(62)
$ns connect $tcp_(62) $sink_(62)
set ftp_(62) [new Application/FTP]
$ftp_(62) attach-agent $tcp_(62)
$ns at 360.2 "$ftp_(62) start"
$ns at 540.0 "$ftp_(62) stop"

#Set a TCP connection between node_(42) and node_(43)
set tcp_(63) [new Agent/TCP/Newreno]
$tcp_(63) set class_ 2
set sink_(63) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(63)
$ns attach-agent $node_(43) $sink_(63)
$ns connect $tcp_(63) $sink_(63)
set ftp_(63) [new Application/FTP]
$ftp_(63) attach-agent $tcp_(63)
$ns at 540.2 "$ftp_(63) start"
$ns at 720.0 "$ftp_(63) stop"

#Set a TCP connection between node_(24) and node_(47)
set tcp_(64) [new Agent/TCP/Newreno]
$tcp_(64) set class_ 2
set sink_(64) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(64)
$ns attach-agent $node_(47) $sink_(64)
$ns connect $tcp_(64) $sink_(64)
set ftp_(64) [new Application/FTP]
$ftp_(64) attach-agent $tcp_(64)
$ns at 720.2 "$ftp_(64) start"
$ns at 900.0 "$ftp_(64) stop"

#Set a TCP connection between node_(23) and node_(38)
set tcp_(65) [new Agent/TCP/Newreno]
$tcp_(65) set class_ 2
set sink_(65) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(65)
$ns attach-agent $node_(38) $sink_(65)
$ns connect $tcp_(65) $sink_(65)
set ftp_(65) [new Application/FTP]
$ftp_(65) attach-agent $tcp_(65)
$ns at 0.2 "$ftp_(65) start"
$ns at 180.0 "$ftp_(65) stop"

#Set a TCP connection between node_(21) and node_(5)
set tcp_(66) [new Agent/TCP/Newreno]
$tcp_(66) set class_ 2
set sink_(66) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(66)
$ns attach-agent $node_(5) $sink_(66)
$ns connect $tcp_(66) $sink_(66)
set ftp_(66) [new Application/FTP]
$ftp_(66) attach-agent $tcp_(66)
$ns at 180.2 "$ftp_(66) start"
$ns at 360.0 "$ftp_(66) stop"

#Set a TCP connection between node_(11) and node_(39)
set tcp_(67) [new Agent/TCP/Newreno]
$tcp_(67) set class_ 2
set sink_(67) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(67)
$ns attach-agent $node_(39) $sink_(67)
$ns connect $tcp_(67) $sink_(67)
set ftp_(67) [new Application/FTP]
$ftp_(67) attach-agent $tcp_(67)
$ns at 360.2 "$ftp_(67) start"
$ns at 540.0 "$ftp_(67) stop"

#Set a TCP connection between node_(36) and node_(33)
set tcp_(68) [new Agent/TCP/Newreno]
$tcp_(68) set class_ 2
set sink_(68) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(68)
$ns attach-agent $node_(33) $sink_(68)
$ns connect $tcp_(68) $sink_(68)
set ftp_(68) [new Application/FTP]
$ftp_(68) attach-agent $tcp_(68)
$ns at 540.2 "$ftp_(68) start"
$ns at 720.0 "$ftp_(68) stop"

#Set a TCP connection between node_(19) and node_(4)
set tcp_(69) [new Agent/TCP/Newreno]
$tcp_(69) set class_ 2
set sink_(69) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(69)
$ns attach-agent $node_(4) $sink_(69)
$ns connect $tcp_(69) $sink_(69)
set ftp_(69) [new Application/FTP]
$ftp_(69) attach-agent $tcp_(69)
$ns at 720.2 "$ftp_(69) start"
$ns at 900.0 "$ftp_(69) stop"

#Set a TCP connection between node_(44) and node_(21)
set tcp_(70) [new Agent/TCP/Newreno]
$tcp_(70) set class_ 2
set sink_(70) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(70)
$ns attach-agent $node_(21) $sink_(70)
$ns connect $tcp_(70) $sink_(70)
set ftp_(70) [new Application/FTP]
$ftp_(70) attach-agent $tcp_(70)
$ns at 0.2 "$ftp_(70) start"
$ns at 180.0 "$ftp_(70) stop"

#Set a TCP connection between node_(6) and node_(30)
set tcp_(71) [new Agent/TCP/Newreno]
$tcp_(71) set class_ 2
set sink_(71) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(71)
$ns attach-agent $node_(30) $sink_(71)
$ns connect $tcp_(71) $sink_(71)
set ftp_(71) [new Application/FTP]
$ftp_(71) attach-agent $tcp_(71)
$ns at 180.2 "$ftp_(71) start"
$ns at 360.0 "$ftp_(71) stop"

#Set a TCP connection between node_(48) and node_(33)
set tcp_(72) [new Agent/TCP/Newreno]
$tcp_(72) set class_ 2
set sink_(72) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(72)
$ns attach-agent $node_(33) $sink_(72)
$ns connect $tcp_(72) $sink_(72)
set ftp_(72) [new Application/FTP]
$ftp_(72) attach-agent $tcp_(72)
$ns at 360.2 "$ftp_(72) start"
$ns at 540.0 "$ftp_(72) stop"

#Set a TCP connection between node_(35) and node_(26)
set tcp_(73) [new Agent/TCP/Newreno]
$tcp_(73) set class_ 2
set sink_(73) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(73)
$ns attach-agent $node_(26) $sink_(73)
$ns connect $tcp_(73) $sink_(73)
set ftp_(73) [new Application/FTP]
$ftp_(73) attach-agent $tcp_(73)
$ns at 540.2 "$ftp_(73) start"
$ns at 720.0 "$ftp_(73) stop"

#Set a TCP connection between node_(49) and node_(11)
set tcp_(74) [new Agent/TCP/Newreno]
$tcp_(74) set class_ 2
set sink_(74) [new Agent/TCPSink]
$ns attach-agent $node_(49) $tcp_(74)
$ns attach-agent $node_(11) $sink_(74)
$ns connect $tcp_(74) $sink_(74)
set ftp_(74) [new Application/FTP]
$ftp_(74) attach-agent $tcp_(74)
$ns at 720.2 "$ftp_(74) start"
$ns at 900.0 "$ftp_(74) stop"

#Set a TCP connection between node_(22) and node_(5)
set tcp_(75) [new Agent/TCP/Newreno]
$tcp_(75) set class_ 2
set sink_(75) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(75)
$ns attach-agent $node_(5) $sink_(75)
$ns connect $tcp_(75) $sink_(75)
set ftp_(75) [new Application/FTP]
$ftp_(75) attach-agent $tcp_(75)
$ns at 0.2 "$ftp_(75) start"
$ns at 180.0 "$ftp_(75) stop"

#Set a TCP connection between node_(36) and node_(33)
set tcp_(76) [new Agent/TCP/Newreno]
$tcp_(76) set class_ 2
set sink_(76) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(76)
$ns attach-agent $node_(33) $sink_(76)
$ns connect $tcp_(76) $sink_(76)
set ftp_(76) [new Application/FTP]
$ftp_(76) attach-agent $tcp_(76)
$ns at 180.2 "$ftp_(76) start"
$ns at 360.0 "$ftp_(76) stop"

#Set a TCP connection between node_(49) and node_(3)
set tcp_(77) [new Agent/TCP/Newreno]
$tcp_(77) set class_ 2
set sink_(77) [new Agent/TCPSink]
$ns attach-agent $node_(49) $tcp_(77)
$ns attach-agent $node_(3) $sink_(77)
$ns connect $tcp_(77) $sink_(77)
set ftp_(77) [new Application/FTP]
$ftp_(77) attach-agent $tcp_(77)
$ns at 360.2 "$ftp_(77) start"
$ns at 540.0 "$ftp_(77) stop"

#Set a TCP connection between node_(13) and node_(17)
set tcp_(78) [new Agent/TCP/Newreno]
$tcp_(78) set class_ 2
set sink_(78) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(78)
$ns attach-agent $node_(17) $sink_(78)
$ns connect $tcp_(78) $sink_(78)
set ftp_(78) [new Application/FTP]
$ftp_(78) attach-agent $tcp_(78)
$ns at 540.2 "$ftp_(78) start"
$ns at 720.0 "$ftp_(78) stop"

#Set a TCP connection between node_(35) and node_(5)
set tcp_(79) [new Agent/TCP/Newreno]
$tcp_(79) set class_ 2
set sink_(79) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(79)
$ns attach-agent $node_(5) $sink_(79)
$ns connect $tcp_(79) $sink_(79)
set ftp_(79) [new Application/FTP]
$ftp_(79) attach-agent $tcp_(79)
$ns at 720.2 "$ftp_(79) start"
$ns at 900.0 "$ftp_(79) stop"

#Set a TCP connection between node_(21) and node_(30)
set tcp_(80) [new Agent/TCP/Newreno]
$tcp_(80) set class_ 2
set sink_(80) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(80)
$ns attach-agent $node_(30) $sink_(80)
$ns connect $tcp_(80) $sink_(80)
set ftp_(80) [new Application/FTP]
$ftp_(80) attach-agent $tcp_(80)
$ns at 0.2 "$ftp_(80) start"
$ns at 180.0 "$ftp_(80) stop"

#Set a TCP connection between node_(42) and node_(9)
set tcp_(81) [new Agent/TCP/Newreno]
$tcp_(81) set class_ 2
set sink_(81) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(81)
$ns attach-agent $node_(9) $sink_(81)
$ns connect $tcp_(81) $sink_(81)
set ftp_(81) [new Application/FTP]
$ftp_(81) attach-agent $tcp_(81)
$ns at 180.2 "$ftp_(81) start"
$ns at 360.0 "$ftp_(81) stop"

#Set a TCP connection between node_(24) and node_(25)
set tcp_(82) [new Agent/TCP/Newreno]
$tcp_(82) set class_ 2
set sink_(82) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(82)
$ns attach-agent $node_(25) $sink_(82)
$ns connect $tcp_(82) $sink_(82)
set ftp_(82) [new Application/FTP]
$ftp_(82) attach-agent $tcp_(82)
$ns at 360.2 "$ftp_(82) start"
$ns at 540.0 "$ftp_(82) stop"

#Set a TCP connection between node_(14) and node_(13)
set tcp_(83) [new Agent/TCP/Newreno]
$tcp_(83) set class_ 2
set sink_(83) [new Agent/TCPSink]
$ns attach-agent $node_(14) $tcp_(83)
$ns attach-agent $node_(13) $sink_(83)
$ns connect $tcp_(83) $sink_(83)
set ftp_(83) [new Application/FTP]
$ftp_(83) attach-agent $tcp_(83)
$ns at 540.2 "$ftp_(83) start"
$ns at 720.0 "$ftp_(83) stop"

#Set a TCP connection between node_(33) and node_(6)
set tcp_(84) [new Agent/TCP/Newreno]
$tcp_(84) set class_ 2
set sink_(84) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(84)
$ns attach-agent $node_(6) $sink_(84)
$ns connect $tcp_(84) $sink_(84)
set ftp_(84) [new Application/FTP]
$ftp_(84) attach-agent $tcp_(84)
$ns at 720.2 "$ftp_(84) start"
$ns at 900.0 "$ftp_(84) stop"

#Set a TCP connection between node_(33) and node_(12)
set tcp_(85) [new Agent/TCP/Newreno]
$tcp_(85) set class_ 2
set sink_(85) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(85)
$ns attach-agent $node_(12) $sink_(85)
$ns connect $tcp_(85) $sink_(85)
set ftp_(85) [new Application/FTP]
$ftp_(85) attach-agent $tcp_(85)
$ns at 0.2 "$ftp_(85) start"
$ns at 180.0 "$ftp_(85) stop"

#Set a TCP connection between node_(30) and node_(10)
set tcp_(86) [new Agent/TCP/Newreno]
$tcp_(86) set class_ 2
set sink_(86) [new Agent/TCPSink]
$ns attach-agent $node_(30) $tcp_(86)
$ns attach-agent $node_(10) $sink_(86)
$ns connect $tcp_(86) $sink_(86)
set ftp_(86) [new Application/FTP]
$ftp_(86) attach-agent $tcp_(86)
$ns at 180.2 "$ftp_(86) start"
$ns at 360.0 "$ftp_(86) stop"

#Set a TCP connection between node_(48) and node_(19)
set tcp_(87) [new Agent/TCP/Newreno]
$tcp_(87) set class_ 2
set sink_(87) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(87)
$ns attach-agent $node_(19) $sink_(87)
$ns connect $tcp_(87) $sink_(87)
set ftp_(87) [new Application/FTP]
$ftp_(87) attach-agent $tcp_(87)
$ns at 360.2 "$ftp_(87) start"
$ns at 540.0 "$ftp_(87) stop"

#Set a TCP connection between node_(29) and node_(16)
set tcp_(88) [new Agent/TCP/Newreno]
$tcp_(88) set class_ 2
set sink_(88) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(88)
$ns attach-agent $node_(16) $sink_(88)
$ns connect $tcp_(88) $sink_(88)
set ftp_(88) [new Application/FTP]
$ftp_(88) attach-agent $tcp_(88)
$ns at 540.2 "$ftp_(88) start"
$ns at 720.0 "$ftp_(88) stop"

#Set a TCP connection between node_(23) and node_(25)
set tcp_(89) [new Agent/TCP/Newreno]
$tcp_(89) set class_ 2
set sink_(89) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(89)
$ns attach-agent $node_(25) $sink_(89)
$ns connect $tcp_(89) $sink_(89)
set ftp_(89) [new Application/FTP]
$ftp_(89) attach-agent $tcp_(89)
$ns at 720.2 "$ftp_(89) start"
$ns at 900.0 "$ftp_(89) stop"

#Set a TCP connection between node_(34) and node_(14)
set tcp_(90) [new Agent/TCP/Newreno]
$tcp_(90) set class_ 2
set sink_(90) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(90)
$ns attach-agent $node_(14) $sink_(90)
$ns connect $tcp_(90) $sink_(90)
set ftp_(90) [new Application/FTP]
$ftp_(90) attach-agent $tcp_(90)
$ns at 0.2 "$ftp_(90) start"
$ns at 180.0 "$ftp_(90) stop"

#Set a TCP connection between node_(19) and node_(44)
set tcp_(91) [new Agent/TCP/Newreno]
$tcp_(91) set class_ 2
set sink_(91) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(91)
$ns attach-agent $node_(44) $sink_(91)
$ns connect $tcp_(91) $sink_(91)
set ftp_(91) [new Application/FTP]
$ftp_(91) attach-agent $tcp_(91)
$ns at 180.2 "$ftp_(91) start"
$ns at 360.0 "$ftp_(91) stop"

#Set a TCP connection between node_(27) and node_(35)
set tcp_(92) [new Agent/TCP/Newreno]
$tcp_(92) set class_ 2
set sink_(92) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(92)
$ns attach-agent $node_(35) $sink_(92)
$ns connect $tcp_(92) $sink_(92)
set ftp_(92) [new Application/FTP]
$ftp_(92) attach-agent $tcp_(92)
$ns at 360.2 "$ftp_(92) start"
$ns at 540.0 "$ftp_(92) stop"

#Set a TCP connection between node_(3) and node_(30)
set tcp_(93) [new Agent/TCP/Newreno]
$tcp_(93) set class_ 2
set sink_(93) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(93)
$ns attach-agent $node_(30) $sink_(93)
$ns connect $tcp_(93) $sink_(93)
set ftp_(93) [new Application/FTP]
$ftp_(93) attach-agent $tcp_(93)
$ns at 540.2 "$ftp_(93) start"
$ns at 720.0 "$ftp_(93) stop"

#Set a TCP connection between node_(48) and node_(42)
set tcp_(94) [new Agent/TCP/Newreno]
$tcp_(94) set class_ 2
set sink_(94) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(94)
$ns attach-agent $node_(42) $sink_(94)
$ns connect $tcp_(94) $sink_(94)
set ftp_(94) [new Application/FTP]
$ftp_(94) attach-agent $tcp_(94)
$ns at 720.2 "$ftp_(94) start"
$ns at 900.0 "$ftp_(94) stop"

#Set a TCP connection between node_(2) and node_(22)
set tcp_(95) [new Agent/TCP/Newreno]
$tcp_(95) set class_ 2
set sink_(95) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(95)
$ns attach-agent $node_(22) $sink_(95)
$ns connect $tcp_(95) $sink_(95)
set ftp_(95) [new Application/FTP]
$ftp_(95) attach-agent $tcp_(95)
$ns at 0.2 "$ftp_(95) start"
$ns at 180.0 "$ftp_(95) stop"

#Set a TCP connection between node_(13) and node_(35)
set tcp_(96) [new Agent/TCP/Newreno]
$tcp_(96) set class_ 2
set sink_(96) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(96)
$ns attach-agent $node_(35) $sink_(96)
$ns connect $tcp_(96) $sink_(96)
set ftp_(96) [new Application/FTP]
$ftp_(96) attach-agent $tcp_(96)
$ns at 180.2 "$ftp_(96) start"
$ns at 360.0 "$ftp_(96) stop"

#Set a TCP connection between node_(43) and node_(1)
set tcp_(97) [new Agent/TCP/Newreno]
$tcp_(97) set class_ 2
set sink_(97) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(97)
$ns attach-agent $node_(1) $sink_(97)
$ns connect $tcp_(97) $sink_(97)
set ftp_(97) [new Application/FTP]
$ftp_(97) attach-agent $tcp_(97)
$ns at 360.2 "$ftp_(97) start"
$ns at 540.0 "$ftp_(97) stop"

#Set a TCP connection between node_(14) and node_(11)
set tcp_(98) [new Agent/TCP/Newreno]
$tcp_(98) set class_ 2
set sink_(98) [new Agent/TCPSink]
$ns attach-agent $node_(14) $tcp_(98)
$ns attach-agent $node_(11) $sink_(98)
$ns connect $tcp_(98) $sink_(98)
set ftp_(98) [new Application/FTP]
$ftp_(98) attach-agent $tcp_(98)
$ns at 540.2 "$ftp_(98) start"
$ns at 720.0 "$ftp_(98) stop"

#Set a TCP connection between node_(6) and node_(17)
set tcp_(99) [new Agent/TCP/Newreno]
$tcp_(99) set class_ 2
set sink_(99) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(99)
$ns attach-agent $node_(17) $sink_(99)
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
