#sim-scn3-7.tcl 
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
set tracefd       [open sim-scn3-7-$val(rp)-trace.tr w]
set windowVsTime2 [open sim-scn3-7-$val(rp)-win-.tr w]
set namtrace      [open sim-scn3-7-$val(rp).nam w]

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
$node_(0) set X_ 553 
$node_(0) set Y_ 248 
$node_(0) set Z_ 0.0 
$node_(1) set X_ 341 
$node_(1) set Y_ 253 
$node_(1) set Z_ 0.0 
$node_(2) set X_ 1914 
$node_(2) set Y_ 473 
$node_(2) set Z_ 0.0 
$node_(3) set X_ 817 
$node_(3) set Y_ 244 
$node_(3) set Z_ 0.0 
$node_(4) set X_ 1614 
$node_(4) set Y_ 521 
$node_(4) set Z_ 0.0 
$node_(5) set X_ 1451 
$node_(5) set Y_ 866 
$node_(5) set Z_ 0.0 
$node_(6) set X_ 2409 
$node_(6) set Y_ 387 
$node_(6) set Z_ 0.0 
$node_(7) set X_ 724 
$node_(7) set Y_ 951 
$node_(7) set Z_ 0.0 
$node_(8) set X_ 262 
$node_(8) set Y_ 818 
$node_(8) set Z_ 0.0 
$node_(9) set X_ 2275 
$node_(9) set Y_ 350 
$node_(9) set Z_ 0.0 
$node_(10) set X_ 2105 
$node_(10) set Y_ 35 
$node_(10) set Z_ 0.0 
$node_(11) set X_ 625 
$node_(11) set Y_ 917 
$node_(11) set Z_ 0.0 
$node_(12) set X_ 58 
$node_(12) set Y_ 395 
$node_(12) set Z_ 0.0 
$node_(13) set X_ 1177 
$node_(13) set Y_ 896 
$node_(13) set Z_ 0.0 
$node_(14) set X_ 728 
$node_(14) set Y_ 102 
$node_(14) set Z_ 0.0 
$node_(15) set X_ 220 
$node_(15) set Y_ 650 
$node_(15) set Z_ 0.0 
$node_(16) set X_ 653 
$node_(16) set Y_ 421 
$node_(16) set Z_ 0.0 
$node_(17) set X_ 2541 
$node_(17) set Y_ 973 
$node_(17) set Z_ 0.0 
$node_(18) set X_ 2134 
$node_(18) set Y_ 338 
$node_(18) set Z_ 0.0 
$node_(19) set X_ 1431 
$node_(19) set Y_ 149 
$node_(19) set Z_ 0.0 
$node_(20) set X_ 586 
$node_(20) set Y_ 217 
$node_(20) set Z_ 0.0 
$node_(21) set X_ 256 
$node_(21) set Y_ 522 
$node_(21) set Z_ 0.0 
$node_(22) set X_ 2142 
$node_(22) set Y_ 833 
$node_(22) set Z_ 0.0 
$node_(23) set X_ 1325 
$node_(23) set Y_ 576 
$node_(23) set Z_ 0.0 
$node_(24) set X_ 2581 
$node_(24) set Y_ 83 
$node_(24) set Z_ 0.0 
$node_(25) set X_ 2624 
$node_(25) set Y_ 444 
$node_(25) set Z_ 0.0 
$node_(26) set X_ 688 
$node_(26) set Y_ 797 
$node_(26) set Z_ 0.0 
$node_(27) set X_ 9 
$node_(27) set Y_ 305 
$node_(27) set Z_ 0.0 
$node_(28) set X_ 2923 
$node_(28) set Y_ 337 
$node_(28) set Z_ 0.0 
$node_(29) set X_ 1697 
$node_(29) set Y_ 359 
$node_(29) set Z_ 0.0 
$node_(30) set X_ 762 
$node_(30) set Y_ 81 
$node_(30) set Z_ 0.0 
$node_(31) set X_ 366 
$node_(31) set Y_ 937 
$node_(31) set Z_ 0.0 
$node_(32) set X_ 1261 
$node_(32) set Y_ 465 
$node_(32) set Z_ 0.0 
$node_(33) set X_ 846 
$node_(33) set Y_ 828 
$node_(33) set Z_ 0.0 
$node_(34) set X_ 2346 
$node_(34) set Y_ 997 
$node_(34) set Z_ 0.0 
$node_(35) set X_ 1326 
$node_(35) set Y_ 99 
$node_(35) set Z_ 0.0 
$node_(36) set X_ 1923 
$node_(36) set Y_ 535 
$node_(36) set Z_ 0.0 
$node_(37) set X_ 2072 
$node_(37) set Y_ 507 
$node_(37) set Z_ 0.0 
$node_(38) set X_ 318 
$node_(38) set Y_ 171 
$node_(38) set Z_ 0.0 
$node_(39) set X_ 2045 
$node_(39) set Y_ 126 
$node_(39) set Z_ 0.0 
$node_(40) set X_ 2582 
$node_(40) set Y_ 257 
$node_(40) set Z_ 0.0 
$node_(41) set X_ 2339 
$node_(41) set Y_ 934 
$node_(41) set Z_ 0.0 
$node_(42) set X_ 2031 
$node_(42) set Y_ 472 
$node_(42) set Z_ 0.0 
$node_(43) set X_ 2147 
$node_(43) set Y_ 941 
$node_(43) set Z_ 0.0 
$node_(44) set X_ 2873 
$node_(44) set Y_ 341 
$node_(44) set Z_ 0.0 
$node_(45) set X_ 964 
$node_(45) set Y_ 898 
$node_(45) set Z_ 0.0 
$node_(46) set X_ 43 
$node_(46) set Y_ 278 
$node_(46) set Z_ 0.0 
$node_(47) set X_ 1952 
$node_(47) set Y_ 725 
$node_(47) set Z_ 0.0 
$node_(48) set X_ 283 
$node_(48) set Y_ 54 
$node_(48) set Z_ 0.0 
$node_(49) set X_ 2831 
$node_(49) set Y_ 622 
$node_(49) set Z_ 0.0 
$node_(50) set X_ 1202 
$node_(50) set Y_ 596 
$node_(50) set Z_ 0.0 
$node_(51) set X_ 1314 
$node_(51) set Y_ 210 
$node_(51) set Z_ 0.0 
$node_(52) set X_ 1425 
$node_(52) set Y_ 99 
$node_(52) set Z_ 0.0 
$node_(53) set X_ 2967 
$node_(53) set Y_ 183 
$node_(53) set Z_ 0.0 
$node_(54) set X_ 1056 
$node_(54) set Y_ 813 
$node_(54) set Z_ 0.0 
$node_(55) set X_ 2497 
$node_(55) set Y_ 668 
$node_(55) set Z_ 0.0 
$node_(56) set X_ 2511 
$node_(56) set Y_ 234 
$node_(56) set Z_ 0.0 
$node_(57) set X_ 1745 
$node_(57) set Y_ 908 
$node_(57) set Z_ 0.0 
$node_(58) set X_ 301 
$node_(58) set Y_ 92 
$node_(58) set Z_ 0.0 
$node_(59) set X_ 2221 
$node_(59) set Y_ 944 
$node_(59) set Z_ 0.0 
$node_(60) set X_ 1645 
$node_(60) set Y_ 265 
$node_(60) set Z_ 0.0 
$node_(61) set X_ 1752 
$node_(61) set Y_ 681 
$node_(61) set Z_ 0.0 
$node_(62) set X_ 1738 
$node_(62) set Y_ 678 
$node_(62) set Z_ 0.0 
$node_(63) set X_ 791 
$node_(63) set Y_ 93 
$node_(63) set Z_ 0.0 
$node_(64) set X_ 1241 
$node_(64) set Y_ 305 
$node_(64) set Z_ 0.0 
$node_(65) set X_ 1099 
$node_(65) set Y_ 373 
$node_(65) set Z_ 0.0 
$node_(66) set X_ 1939 
$node_(66) set Y_ 651 
$node_(66) set Z_ 0.0 
$node_(67) set X_ 2964 
$node_(67) set Y_ 472 
$node_(67) set Z_ 0.0 
$node_(68) set X_ 1687 
$node_(68) set Y_ 449 
$node_(68) set Z_ 0.0 
$node_(69) set X_ 1686 
$node_(69) set Y_ 868 
$node_(69) set Z_ 0.0 
$node_(70) set X_ 1607 
$node_(70) set Y_ 873 
$node_(70) set Z_ 0.0 
$node_(71) set X_ 947 
$node_(71) set Y_ 362 
$node_(71) set Z_ 0.0 
$node_(72) set X_ 74 
$node_(72) set Y_ 257 
$node_(72) set Z_ 0.0 
$node_(73) set X_ 723 
$node_(73) set Y_ 365 
$node_(73) set Z_ 0.0 
$node_(74) set X_ 2330 
$node_(74) set Y_ 166 
$node_(74) set Z_ 0.0 
$node_(75) set X_ 2682 
$node_(75) set Y_ 452 
$node_(75) set Z_ 0.0 
$node_(76) set X_ 2587 
$node_(76) set Y_ 689 
$node_(76) set Z_ 0.0 
$node_(77) set X_ 510 
$node_(77) set Y_ 929 
$node_(77) set Z_ 0.0 
$node_(78) set X_ 193 
$node_(78) set Y_ 979 
$node_(78) set Z_ 0.0 
$node_(79) set X_ 1326 
$node_(79) set Y_ 762 
$node_(79) set Z_ 0.0 
$node_(80) set X_ 2903 
$node_(80) set Y_ 392 
$node_(80) set Z_ 0.0 
$node_(81) set X_ 276 
$node_(81) set Y_ 509 
$node_(81) set Z_ 0.0 
$node_(82) set X_ 2476 
$node_(82) set Y_ 75 
$node_(82) set Z_ 0.0 
$node_(83) set X_ 1570 
$node_(83) set Y_ 850 
$node_(83) set Z_ 0.0 
$node_(84) set X_ 2675 
$node_(84) set Y_ 469 
$node_(84) set Z_ 0.0 
$node_(85) set X_ 580 
$node_(85) set Y_ 847 
$node_(85) set Z_ 0.0 
$node_(86) set X_ 1395 
$node_(86) set Y_ 995 
$node_(86) set Z_ 0.0 
$node_(87) set X_ 208 
$node_(87) set Y_ 374 
$node_(87) set Z_ 0.0 
$node_(88) set X_ 950 
$node_(88) set Y_ 149 
$node_(88) set Z_ 0.0 
$node_(89) set X_ 578 
$node_(89) set Y_ 20 
$node_(89) set Z_ 0.0 
$node_(90) set X_ 1591 
$node_(90) set Y_ 326 
$node_(90) set Z_ 0.0 
$node_(91) set X_ 2092 
$node_(91) set Y_ 340 
$node_(91) set Z_ 0.0 
$node_(92) set X_ 110 
$node_(92) set Y_ 971 
$node_(92) set Z_ 0.0 
$node_(93) set X_ 2160 
$node_(93) set Y_ 551 
$node_(93) set Z_ 0.0 
$node_(94) set X_ 852 
$node_(94) set Y_ 45 
$node_(94) set Z_ 0.0 
$node_(95) set X_ 402 
$node_(95) set Y_ 630 
$node_(95) set Z_ 0.0 
$node_(96) set X_ 1672 
$node_(96) set Y_ 411 
$node_(96) set Z_ 0.0 
$node_(97) set X_ 2750 
$node_(97) set Y_ 305 
$node_(97) set Z_ 0.0 
$node_(98) set X_ 1272 
$node_(98) set Y_ 446 
$node_(98) set Z_ 0.0 
$node_(99) set X_ 858 
$node_(99) set Y_ 627 
$node_(99) set Z_ 0.0 
$node_(100) set X_ 2039 
$node_(100) set Y_ 66 
$node_(100) set Z_ 0.0 
$node_(101) set X_ 1283 
$node_(101) set Y_ 619 
$node_(101) set Z_ 0.0 
$ns at 0.0 "$node_(101) off" 
$ns at 100.0 "$node_(101) on" 
$node_(102) set X_ 2800 
$node_(102) set Y_ 440 
$node_(102) set Z_ 0.0 
$ns at 0.0 "$node_(102) off" 
$ns at 100.0 "$node_(102) on" 
$node_(103) set X_ 2287 
$node_(103) set Y_ 33 
$node_(103) set Z_ 0.0 
$ns at 0.0 "$node_(103) off" 
$ns at 100.0 "$node_(103) on" 
$node_(104) set X_ 2044 
$node_(104) set Y_ 807 
$node_(104) set Z_ 0.0 
$ns at 0.0 "$node_(104) off" 
$ns at 100.0 "$node_(104) on" 
$node_(105) set X_ 656 
$node_(105) set Y_ 381 
$node_(105) set Z_ 0.0 
$ns at 0.0 "$node_(105) off" 
$ns at 100.0 "$node_(105) on" 
$node_(106) set X_ 923 
$node_(106) set Y_ 225 
$node_(106) set Z_ 0.0 
$ns at 0.0 "$node_(106) off" 
$ns at 100.0 "$node_(106) on" 
$node_(107) set X_ 2704 
$node_(107) set Y_ 200 
$node_(107) set Z_ 0.0 
$ns at 0.0 "$node_(107) off" 
$ns at 100.0 "$node_(107) on" 
$node_(108) set X_ 2872 
$node_(108) set Y_ 546 
$node_(108) set Z_ 0.0 
$ns at 0.0 "$node_(108) off" 
$ns at 100.0 "$node_(108) on" 
$node_(109) set X_ 2657 
$node_(109) set Y_ 18 
$node_(109) set Z_ 0.0 
$ns at 0.0 "$node_(109) off" 
$ns at 100.0 "$node_(109) on" 
$node_(110) set X_ 1920 
$node_(110) set Y_ 614 
$node_(110) set Z_ 0.0 
$ns at 0.0 "$node_(110) off" 
$ns at 100.0 "$node_(110) on" 
$node_(111) set X_ 1790 
$node_(111) set Y_ 563 
$node_(111) set Z_ 0.0 
$ns at 0.0 "$node_(111) off" 
$ns at 100.0 "$node_(111) on" 
$node_(112) set X_ 708 
$node_(112) set Y_ 496 
$node_(112) set Z_ 0.0 
$ns at 0.0 "$node_(112) off" 
$ns at 100.0 "$node_(112) on" 
$node_(113) set X_ 1164 
$node_(113) set Y_ 580 
$node_(113) set Z_ 0.0 
$ns at 0.0 "$node_(113) off" 
$ns at 100.0 "$node_(113) on" 
$node_(114) set X_ 917 
$node_(114) set Y_ 524 
$node_(114) set Z_ 0.0 
$ns at 0.0 "$node_(114) off" 
$ns at 100.0 "$node_(114) on" 
$node_(115) set X_ 1443 
$node_(115) set Y_ 8 
$node_(115) set Z_ 0.0 
$ns at 0.0 "$node_(115) off" 
$ns at 100.0 "$node_(115) on" 
$node_(116) set X_ 2185 
$node_(116) set Y_ 91 
$node_(116) set Z_ 0.0 
$ns at 0.0 "$node_(116) off" 
$ns at 100.0 "$node_(116) on" 
$node_(117) set X_ 1143 
$node_(117) set Y_ 408 
$node_(117) set Z_ 0.0 
$ns at 0.0 "$node_(117) off" 
$ns at 100.0 "$node_(117) on" 
$node_(118) set X_ 700 
$node_(118) set Y_ 415 
$node_(118) set Z_ 0.0 
$ns at 0.0 "$node_(118) off" 
$ns at 100.0 "$node_(118) on" 
$node_(119) set X_ 788 
$node_(119) set Y_ 249 
$node_(119) set Z_ 0.0 
$ns at 0.0 "$node_(119) off" 
$ns at 100.0 "$node_(119) on" 
$node_(120) set X_ 2496 
$node_(120) set Y_ 942 
$node_(120) set Z_ 0.0 
$ns at 0.0 "$node_(120) off" 
$ns at 100.0 "$node_(120) on" 
$node_(121) set X_ 1708 
$node_(121) set Y_ 63 
$node_(121) set Z_ 0.0 
$ns at 0.0 "$node_(121) off" 
$ns at 100.0 "$node_(121) on" 
$node_(122) set X_ 9 
$node_(122) set Y_ 678 
$node_(122) set Z_ 0.0 
$ns at 0.0 "$node_(122) off" 
$ns at 100.0 "$node_(122) on" 
$node_(123) set X_ 801 
$node_(123) set Y_ 561 
$node_(123) set Z_ 0.0 
$ns at 0.0 "$node_(123) off" 
$ns at 100.0 "$node_(123) on" 
$node_(124) set X_ 733 
$node_(124) set Y_ 479 
$node_(124) set Z_ 0.0 
$ns at 0.0 "$node_(124) off" 
$ns at 100.0 "$node_(124) on" 
$node_(125) set X_ 2286 
$node_(125) set Y_ 493 
$node_(125) set Z_ 0.0 
$ns at 0.0 "$node_(125) off" 
$ns at 100.0 "$node_(125) on" 
$node_(126) set X_ 772 
$node_(126) set Y_ 261 
$node_(126) set Z_ 0.0 
$ns at 0.0 "$node_(126) off" 
$ns at 100.0 "$node_(126) on" 
$node_(127) set X_ 1458 
$node_(127) set Y_ 428 
$node_(127) set Z_ 0.0 
$ns at 0.0 "$node_(127) off" 
$ns at 100.0 "$node_(127) on" 
$node_(128) set X_ 1819 
$node_(128) set Y_ 180 
$node_(128) set Z_ 0.0 
$ns at 0.0 "$node_(128) off" 
$ns at 100.0 "$node_(128) on" 
$node_(129) set X_ 1658 
$node_(129) set Y_ 635 
$node_(129) set Z_ 0.0 
$ns at 0.0 "$node_(129) off" 
$ns at 100.0 "$node_(129) on" 
$node_(130) set X_ 492 
$node_(130) set Y_ 29 
$node_(130) set Z_ 0.0 
$ns at 0.0 "$node_(130) off" 
$ns at 100.0 "$node_(130) on" 
$node_(131) set X_ 2044 
$node_(131) set Y_ 963 
$node_(131) set Z_ 0.0 
$ns at 0.0 "$node_(131) off" 
$ns at 100.0 "$node_(131) on" 
$node_(132) set X_ 97 
$node_(132) set Y_ 524 
$node_(132) set Z_ 0.0 
$ns at 0.0 "$node_(132) off" 
$ns at 100.0 "$node_(132) on" 
$node_(133) set X_ 2400 
$node_(133) set Y_ 917 
$node_(133) set Z_ 0.0 
$ns at 0.0 "$node_(133) off" 
$ns at 100.0 "$node_(133) on" 
$node_(134) set X_ 2761 
$node_(134) set Y_ 661 
$node_(134) set Z_ 0.0 
$ns at 0.0 "$node_(134) off" 
$ns at 100.0 "$node_(134) on" 
$node_(135) set X_ 1050 
$node_(135) set Y_ 167 
$node_(135) set Z_ 0.0 
$ns at 0.0 "$node_(135) off" 
$ns at 100.0 "$node_(135) on" 
$node_(136) set X_ 437 
$node_(136) set Y_ 64 
$node_(136) set Z_ 0.0 
$ns at 0.0 "$node_(136) off" 
$ns at 100.0 "$node_(136) on" 
$node_(137) set X_ 1007 
$node_(137) set Y_ 355 
$node_(137) set Z_ 0.0 
$ns at 0.0 "$node_(137) off" 
$ns at 100.0 "$node_(137) on" 
$node_(138) set X_ 1601 
$node_(138) set Y_ 61 
$node_(138) set Z_ 0.0 
$ns at 0.0 "$node_(138) off" 
$ns at 100.0 "$node_(138) on" 
$node_(139) set X_ 1779 
$node_(139) set Y_ 362 
$node_(139) set Z_ 0.0 
$ns at 0.0 "$node_(139) off" 
$ns at 100.0 "$node_(139) on" 
$node_(140) set X_ 1442 
$node_(140) set Y_ 266 
$node_(140) set Z_ 0.0 
$ns at 0.0 "$node_(140) off" 
$ns at 100.0 "$node_(140) on" 
$node_(141) set X_ 1722 
$node_(141) set Y_ 217 
$node_(141) set Z_ 0.0 
$ns at 0.0 "$node_(141) off" 
$ns at 100.0 "$node_(141) on" 
$node_(142) set X_ 1119 
$node_(142) set Y_ 599 
$node_(142) set Z_ 0.0 
$ns at 0.0 "$node_(142) off" 
$ns at 100.0 "$node_(142) on" 
$node_(143) set X_ 595 
$node_(143) set Y_ 377 
$node_(143) set Z_ 0.0 
$ns at 0.0 "$node_(143) off" 
$ns at 100.0 "$node_(143) on" 
$node_(144) set X_ 1088 
$node_(144) set Y_ 10 
$node_(144) set Z_ 0.0 
$ns at 0.0 "$node_(144) off" 
$ns at 100.0 "$node_(144) on" 
$node_(145) set X_ 2856 
$node_(145) set Y_ 450 
$node_(145) set Z_ 0.0 
$ns at 0.0 "$node_(145) off" 
$ns at 100.0 "$node_(145) on" 
$node_(146) set X_ 663 
$node_(146) set Y_ 656 
$node_(146) set Z_ 0.0 
$ns at 0.0 "$node_(146) off" 
$ns at 100.0 "$node_(146) on" 
$node_(147) set X_ 1443 
$node_(147) set Y_ 332 
$node_(147) set Z_ 0.0 
$ns at 0.0 "$node_(147) off" 
$ns at 100.0 "$node_(147) on" 
$node_(148) set X_ 1901 
$node_(148) set Y_ 892 
$node_(148) set Z_ 0.0 
$ns at 0.0 "$node_(148) off" 
$ns at 100.0 "$node_(148) on" 
$node_(149) set X_ 1114 
$node_(149) set Y_ 328 
$node_(149) set Z_ 0.0 
$ns at 0.0 "$node_(149) off" 
$ns at 100.0 "$node_(149) on" 
$node_(150) set X_ 2468 
$node_(150) set Y_ 281 
$node_(150) set Z_ 0.0 
$ns at 0.0 "$node_(150) off" 
$ns at 100.0 "$node_(150) on" 
$node_(151) set X_ 2052 
$node_(151) set Y_ 83 
$node_(151) set Z_ 0.0 
$ns at 0.0 "$node_(151) off" 
$ns at 100.0 "$node_(151) on" 
$node_(152) set X_ 2497 
$node_(152) set Y_ 724 
$node_(152) set Z_ 0.0 
$ns at 0.0 "$node_(152) off" 
$ns at 100.0 "$node_(152) on" 
$node_(153) set X_ 216 
$node_(153) set Y_ 35 
$node_(153) set Z_ 0.0 
$ns at 0.0 "$node_(153) off" 
$ns at 100.0 "$node_(153) on" 
$node_(154) set X_ 493 
$node_(154) set Y_ 955 
$node_(154) set Z_ 0.0 
$ns at 0.0 "$node_(154) off" 
$ns at 100.0 "$node_(154) on" 
$node_(155) set X_ 2979 
$node_(155) set Y_ 678 
$node_(155) set Z_ 0.0 
$ns at 0.0 "$node_(155) off" 
$ns at 100.0 "$node_(155) on" 
$node_(156) set X_ 2082 
$node_(156) set Y_ 889 
$node_(156) set Z_ 0.0 
$ns at 0.0 "$node_(156) off" 
$ns at 100.0 "$node_(156) on" 
$node_(157) set X_ 1831 
$node_(157) set Y_ 133 
$node_(157) set Z_ 0.0 
$ns at 0.0 "$node_(157) off" 
$ns at 100.0 "$node_(157) on" 
$node_(158) set X_ 2922 
$node_(158) set Y_ 743 
$node_(158) set Z_ 0.0 
$ns at 0.0 "$node_(158) off" 
$ns at 100.0 "$node_(158) on" 
$node_(159) set X_ 1383 
$node_(159) set Y_ 389 
$node_(159) set Z_ 0.0 
$ns at 0.0 "$node_(159) off" 
$ns at 100.0 "$node_(159) on" 
$node_(160) set X_ 254 
$node_(160) set Y_ 416 
$node_(160) set Z_ 0.0 
$ns at 0.0 "$node_(160) off" 
$ns at 100.0 "$node_(160) on" 
$node_(161) set X_ 2612 
$node_(161) set Y_ 123 
$node_(161) set Z_ 0.0 
$ns at 0.0 "$node_(161) off" 
$ns at 100.0 "$node_(161) on" 
$node_(162) set X_ 534 
$node_(162) set Y_ 345 
$node_(162) set Z_ 0.0 
$ns at 0.0 "$node_(162) off" 
$ns at 100.0 "$node_(162) on" 
$node_(163) set X_ 1191 
$node_(163) set Y_ 169 
$node_(163) set Z_ 0.0 
$ns at 0.0 "$node_(163) off" 
$ns at 100.0 "$node_(163) on" 
$node_(164) set X_ 2189 
$node_(164) set Y_ 952 
$node_(164) set Z_ 0.0 
$ns at 0.0 "$node_(164) off" 
$ns at 100.0 "$node_(164) on" 
$node_(165) set X_ 844 
$node_(165) set Y_ 565 
$node_(165) set Z_ 0.0 
$ns at 0.0 "$node_(165) off" 
$ns at 100.0 "$node_(165) on" 
$node_(166) set X_ 920 
$node_(166) set Y_ 827 
$node_(166) set Z_ 0.0 
$ns at 0.0 "$node_(166) off" 
$ns at 100.0 "$node_(166) on" 
$node_(167) set X_ 60 
$node_(167) set Y_ 603 
$node_(167) set Z_ 0.0 
$ns at 0.0 "$node_(167) off" 
$ns at 100.0 "$node_(167) on" 
$node_(168) set X_ 1059 
$node_(168) set Y_ 5 
$node_(168) set Z_ 0.0 
$ns at 0.0 "$node_(168) off" 
$ns at 100.0 "$node_(168) on" 
$node_(169) set X_ 2002 
$node_(169) set Y_ 444 
$node_(169) set Z_ 0.0 
$ns at 0.0 "$node_(169) off" 
$ns at 100.0 "$node_(169) on" 
$node_(170) set X_ 248 
$node_(170) set Y_ 42 
$node_(170) set Z_ 0.0 
$ns at 0.0 "$node_(170) off" 
$ns at 100.0 "$node_(170) on" 
$node_(171) set X_ 1279 
$node_(171) set Y_ 692 
$node_(171) set Z_ 0.0 
$ns at 0.0 "$node_(171) off" 
$ns at 100.0 "$node_(171) on" 
$node_(172) set X_ 269 
$node_(172) set Y_ 112 
$node_(172) set Z_ 0.0 
$ns at 0.0 "$node_(172) off" 
$ns at 100.0 "$node_(172) on" 
$node_(173) set X_ 1223 
$node_(173) set Y_ 766 
$node_(173) set Z_ 0.0 
$ns at 0.0 "$node_(173) off" 
$ns at 100.0 "$node_(173) on" 
$node_(174) set X_ 2051 
$node_(174) set Y_ 15 
$node_(174) set Z_ 0.0 
$ns at 0.0 "$node_(174) off" 
$ns at 100.0 "$node_(174) on" 
$node_(175) set X_ 517 
$node_(175) set Y_ 50 
$node_(175) set Z_ 0.0 
$ns at 0.0 "$node_(175) off" 
$ns at 100.0 "$node_(175) on" 
$node_(176) set X_ 846 
$node_(176) set Y_ 816 
$node_(176) set Z_ 0.0 
$ns at 0.0 "$node_(176) off" 
$ns at 100.0 "$node_(176) on" 
$node_(177) set X_ 2498 
$node_(177) set Y_ 564 
$node_(177) set Z_ 0.0 
$ns at 0.0 "$node_(177) off" 
$ns at 100.0 "$node_(177) on" 
$node_(178) set X_ 1248 
$node_(178) set Y_ 805 
$node_(178) set Z_ 0.0 
$ns at 0.0 "$node_(178) off" 
$ns at 100.0 "$node_(178) on" 
$node_(179) set X_ 71 
$node_(179) set Y_ 341 
$node_(179) set Z_ 0.0 
$ns at 0.0 "$node_(179) off" 
$ns at 100.0 "$node_(179) on" 
$node_(180) set X_ 84 
$node_(180) set Y_ 615 
$node_(180) set Z_ 0.0 
$ns at 0.0 "$node_(180) off" 
$ns at 100.0 "$node_(180) on" 
$node_(181) set X_ 77 
$node_(181) set Y_ 790 
$node_(181) set Z_ 0.0 
$ns at 0.0 "$node_(181) off" 
$ns at 100.0 "$node_(181) on" 
$node_(182) set X_ 2366 
$node_(182) set Y_ 630 
$node_(182) set Z_ 0.0 
$ns at 0.0 "$node_(182) off" 
$ns at 100.0 "$node_(182) on" 
$node_(183) set X_ 2020 
$node_(183) set Y_ 53 
$node_(183) set Z_ 0.0 
$ns at 0.0 "$node_(183) off" 
$ns at 100.0 "$node_(183) on" 
$node_(184) set X_ 269 
$node_(184) set Y_ 257 
$node_(184) set Z_ 0.0 
$ns at 0.0 "$node_(184) off" 
$ns at 100.0 "$node_(184) on" 
$node_(185) set X_ 1402 
$node_(185) set Y_ 798 
$node_(185) set Z_ 0.0 
$ns at 0.0 "$node_(185) off" 
$ns at 100.0 "$node_(185) on" 
$node_(186) set X_ 676 
$node_(186) set Y_ 250 
$node_(186) set Z_ 0.0 
$ns at 0.0 "$node_(186) off" 
$ns at 100.0 "$node_(186) on" 
$node_(187) set X_ 1423 
$node_(187) set Y_ 920 
$node_(187) set Z_ 0.0 
$ns at 0.0 "$node_(187) off" 
$ns at 100.0 "$node_(187) on" 
$node_(188) set X_ 92 
$node_(188) set Y_ 36 
$node_(188) set Z_ 0.0 
$ns at 0.0 "$node_(188) off" 
$ns at 100.0 "$node_(188) on" 
$node_(189) set X_ 556 
$node_(189) set Y_ 358 
$node_(189) set Z_ 0.0 
$ns at 0.0 "$node_(189) off" 
$ns at 100.0 "$node_(189) on" 
$node_(190) set X_ 2703 
$node_(190) set Y_ 901 
$node_(190) set Z_ 0.0 
$ns at 0.0 "$node_(190) off" 
$ns at 100.0 "$node_(190) on" 
$node_(191) set X_ 1482 
$node_(191) set Y_ 593 
$node_(191) set Z_ 0.0 
$ns at 0.0 "$node_(191) off" 
$ns at 100.0 "$node_(191) on" 
$node_(192) set X_ 2066 
$node_(192) set Y_ 990 
$node_(192) set Z_ 0.0 
$ns at 0.0 "$node_(192) off" 
$ns at 100.0 "$node_(192) on" 
$node_(193) set X_ 1046 
$node_(193) set Y_ 435 
$node_(193) set Z_ 0.0 
$ns at 0.0 "$node_(193) off" 
$ns at 100.0 "$node_(193) on" 
$node_(194) set X_ 1335 
$node_(194) set Y_ 284 
$node_(194) set Z_ 0.0 
$ns at 0.0 "$node_(194) off" 
$ns at 100.0 "$node_(194) on" 
$node_(195) set X_ 1311 
$node_(195) set Y_ 381 
$node_(195) set Z_ 0.0 
$ns at 0.0 "$node_(195) off" 
$ns at 100.0 "$node_(195) on" 
$node_(196) set X_ 1064 
$node_(196) set Y_ 126 
$node_(196) set Z_ 0.0 
$ns at 0.0 "$node_(196) off" 
$ns at 100.0 "$node_(196) on" 
$node_(197) set X_ 1407 
$node_(197) set Y_ 166 
$node_(197) set Z_ 0.0 
$ns at 0.0 "$node_(197) off" 
$ns at 100.0 "$node_(197) on" 
$node_(198) set X_ 1491 
$node_(198) set Y_ 386 
$node_(198) set Z_ 0.0 
$ns at 0.0 "$node_(198) off" 
$ns at 100.0 "$node_(198) on" 
$node_(199) set X_ 708 
$node_(199) set Y_ 144 
$node_(199) set Z_ 0.0 
$ns at 0.0 "$node_(199) off" 
$ns at 100.0 "$node_(199) on" 
$node_(200) set X_ 791 
$node_(200) set Y_ 89 
$node_(200) set Z_ 0.0 
$ns at 0.0 "$node_(200) off" 
$ns at 200.0 "$node_(200) on" 
$node_(201) set X_ 1941 
$node_(201) set Y_ 755 
$node_(201) set Z_ 0.0 
$ns at 0.0 "$node_(201) off" 
$ns at 200.0 "$node_(201) on" 
$node_(202) set X_ 1056 
$node_(202) set Y_ 150 
$node_(202) set Z_ 0.0 
$ns at 0.0 "$node_(202) off" 
$ns at 200.0 "$node_(202) on" 
$node_(203) set X_ 1107 
$node_(203) set Y_ 683 
$node_(203) set Z_ 0.0 
$ns at 0.0 "$node_(203) off" 
$ns at 200.0 "$node_(203) on" 
$node_(204) set X_ 808 
$node_(204) set Y_ 903 
$node_(204) set Z_ 0.0 
$ns at 0.0 "$node_(204) off" 
$ns at 200.0 "$node_(204) on" 
$node_(205) set X_ 1591 
$node_(205) set Y_ 243 
$node_(205) set Z_ 0.0 
$ns at 0.0 "$node_(205) off" 
$ns at 200.0 "$node_(205) on" 
$node_(206) set X_ 562 
$node_(206) set Y_ 264 
$node_(206) set Z_ 0.0 
$ns at 0.0 "$node_(206) off" 
$ns at 200.0 "$node_(206) on" 
$node_(207) set X_ 572 
$node_(207) set Y_ 184 
$node_(207) set Z_ 0.0 
$ns at 0.0 "$node_(207) off" 
$ns at 200.0 "$node_(207) on" 
$node_(208) set X_ 2418 
$node_(208) set Y_ 687 
$node_(208) set Z_ 0.0 
$ns at 0.0 "$node_(208) off" 
$ns at 200.0 "$node_(208) on" 
$node_(209) set X_ 2740 
$node_(209) set Y_ 348 
$node_(209) set Z_ 0.0 
$ns at 0.0 "$node_(209) off" 
$ns at 200.0 "$node_(209) on" 
$node_(210) set X_ 1818 
$node_(210) set Y_ 586 
$node_(210) set Z_ 0.0 
$ns at 0.0 "$node_(210) off" 
$ns at 200.0 "$node_(210) on" 
$node_(211) set X_ 2535 
$node_(211) set Y_ 579 
$node_(211) set Z_ 0.0 
$ns at 0.0 "$node_(211) off" 
$ns at 200.0 "$node_(211) on" 
$node_(212) set X_ 1527 
$node_(212) set Y_ 484 
$node_(212) set Z_ 0.0 
$ns at 0.0 "$node_(212) off" 
$ns at 200.0 "$node_(212) on" 
$node_(213) set X_ 462 
$node_(213) set Y_ 856 
$node_(213) set Z_ 0.0 
$ns at 0.0 "$node_(213) off" 
$ns at 200.0 "$node_(213) on" 
$node_(214) set X_ 1456 
$node_(214) set Y_ 986 
$node_(214) set Z_ 0.0 
$ns at 0.0 "$node_(214) off" 
$ns at 200.0 "$node_(214) on" 
$node_(215) set X_ 1630 
$node_(215) set Y_ 880 
$node_(215) set Z_ 0.0 
$ns at 0.0 "$node_(215) off" 
$ns at 200.0 "$node_(215) on" 
$node_(216) set X_ 314 
$node_(216) set Y_ 609 
$node_(216) set Z_ 0.0 
$ns at 0.0 "$node_(216) off" 
$ns at 200.0 "$node_(216) on" 
$node_(217) set X_ 2499 
$node_(217) set Y_ 238 
$node_(217) set Z_ 0.0 
$ns at 0.0 "$node_(217) off" 
$ns at 200.0 "$node_(217) on" 
$node_(218) set X_ 1113 
$node_(218) set Y_ 599 
$node_(218) set Z_ 0.0 
$ns at 0.0 "$node_(218) off" 
$ns at 200.0 "$node_(218) on" 
$node_(219) set X_ 815 
$node_(219) set Y_ 831 
$node_(219) set Z_ 0.0 
$ns at 0.0 "$node_(219) off" 
$ns at 200.0 "$node_(219) on" 
$node_(220) set X_ 1288 
$node_(220) set Y_ 144 
$node_(220) set Z_ 0.0 
$ns at 0.0 "$node_(220) off" 
$ns at 200.0 "$node_(220) on" 
$node_(221) set X_ 995 
$node_(221) set Y_ 476 
$node_(221) set Z_ 0.0 
$ns at 0.0 "$node_(221) off" 
$ns at 200.0 "$node_(221) on" 
$node_(222) set X_ 2715 
$node_(222) set Y_ 794 
$node_(222) set Z_ 0.0 
$ns at 0.0 "$node_(222) off" 
$ns at 200.0 "$node_(222) on" 
$node_(223) set X_ 664 
$node_(223) set Y_ 455 
$node_(223) set Z_ 0.0 
$ns at 0.0 "$node_(223) off" 
$ns at 200.0 "$node_(223) on" 
$node_(224) set X_ 2090 
$node_(224) set Y_ 494 
$node_(224) set Z_ 0.0 
$ns at 0.0 "$node_(224) off" 
$ns at 200.0 "$node_(224) on" 
$node_(225) set X_ 758 
$node_(225) set Y_ 301 
$node_(225) set Z_ 0.0 
$ns at 0.0 "$node_(225) off" 
$ns at 200.0 "$node_(225) on" 
$node_(226) set X_ 58 
$node_(226) set Y_ 346 
$node_(226) set Z_ 0.0 
$ns at 0.0 "$node_(226) off" 
$ns at 200.0 "$node_(226) on" 
$node_(227) set X_ 1484 
$node_(227) set Y_ 339 
$node_(227) set Z_ 0.0 
$ns at 0.0 "$node_(227) off" 
$ns at 200.0 "$node_(227) on" 
$node_(228) set X_ 1116 
$node_(228) set Y_ 126 
$node_(228) set Z_ 0.0 
$ns at 0.0 "$node_(228) off" 
$ns at 200.0 "$node_(228) on" 
$node_(229) set X_ 2585 
$node_(229) set Y_ 281 
$node_(229) set Z_ 0.0 
$ns at 0.0 "$node_(229) off" 
$ns at 200.0 "$node_(229) on" 
$node_(230) set X_ 2685 
$node_(230) set Y_ 600 
$node_(230) set Z_ 0.0 
$ns at 0.0 "$node_(230) off" 
$ns at 200.0 "$node_(230) on" 
$node_(231) set X_ 2664 
$node_(231) set Y_ 720 
$node_(231) set Z_ 0.0 
$ns at 0.0 "$node_(231) off" 
$ns at 200.0 "$node_(231) on" 
$node_(232) set X_ 810 
$node_(232) set Y_ 909 
$node_(232) set Z_ 0.0 
$ns at 0.0 "$node_(232) off" 
$ns at 200.0 "$node_(232) on" 
$node_(233) set X_ 2923 
$node_(233) set Y_ 494 
$node_(233) set Z_ 0.0 
$ns at 0.0 "$node_(233) off" 
$ns at 200.0 "$node_(233) on" 
$node_(234) set X_ 2746 
$node_(234) set Y_ 638 
$node_(234) set Z_ 0.0 
$ns at 0.0 "$node_(234) off" 
$ns at 200.0 "$node_(234) on" 
$node_(235) set X_ 2407 
$node_(235) set Y_ 717 
$node_(235) set Z_ 0.0 
$ns at 0.0 "$node_(235) off" 
$ns at 200.0 "$node_(235) on" 
$node_(236) set X_ 2210 
$node_(236) set Y_ 681 
$node_(236) set Z_ 0.0 
$ns at 0.0 "$node_(236) off" 
$ns at 200.0 "$node_(236) on" 
$node_(237) set X_ 2894 
$node_(237) set Y_ 720 
$node_(237) set Z_ 0.0 
$ns at 0.0 "$node_(237) off" 
$ns at 200.0 "$node_(237) on" 
$node_(238) set X_ 308 
$node_(238) set Y_ 725 
$node_(238) set Z_ 0.0 
$ns at 0.0 "$node_(238) off" 
$ns at 200.0 "$node_(238) on" 
$node_(239) set X_ 1739 
$node_(239) set Y_ 293 
$node_(239) set Z_ 0.0 
$ns at 0.0 "$node_(239) off" 
$ns at 200.0 "$node_(239) on" 
$node_(240) set X_ 88 
$node_(240) set Y_ 947 
$node_(240) set Z_ 0.0 
$ns at 0.0 "$node_(240) off" 
$ns at 200.0 "$node_(240) on" 
$node_(241) set X_ 2460 
$node_(241) set Y_ 373 
$node_(241) set Z_ 0.0 
$ns at 0.0 "$node_(241) off" 
$ns at 200.0 "$node_(241) on" 
$node_(242) set X_ 2355 
$node_(242) set Y_ 547 
$node_(242) set Z_ 0.0 
$ns at 0.0 "$node_(242) off" 
$ns at 200.0 "$node_(242) on" 
$node_(243) set X_ 2468 
$node_(243) set Y_ 771 
$node_(243) set Z_ 0.0 
$ns at 0.0 "$node_(243) off" 
$ns at 200.0 "$node_(243) on" 
$node_(244) set X_ 780 
$node_(244) set Y_ 850 
$node_(244) set Z_ 0.0 
$ns at 0.0 "$node_(244) off" 
$ns at 200.0 "$node_(244) on" 
$node_(245) set X_ 1262 
$node_(245) set Y_ 624 
$node_(245) set Z_ 0.0 
$ns at 0.0 "$node_(245) off" 
$ns at 200.0 "$node_(245) on" 
$node_(246) set X_ 1407 
$node_(246) set Y_ 11 
$node_(246) set Z_ 0.0 
$ns at 0.0 "$node_(246) off" 
$ns at 200.0 "$node_(246) on" 
$node_(247) set X_ 1463 
$node_(247) set Y_ 988 
$node_(247) set Z_ 0.0 
$ns at 0.0 "$node_(247) off" 
$ns at 200.0 "$node_(247) on" 
$node_(248) set X_ 1539 
$node_(248) set Y_ 812 
$node_(248) set Z_ 0.0 
$ns at 0.0 "$node_(248) off" 
$ns at 200.0 "$node_(248) on" 
$node_(249) set X_ 1397 
$node_(249) set Y_ 420 
$node_(249) set Z_ 0.0 
$ns at 0.0 "$node_(249) off" 
$ns at 200.0 "$node_(249) on" 
$node_(250) set X_ 497 
$node_(250) set Y_ 636 
$node_(250) set Z_ 0.0 
$ns at 0.0 "$node_(250) off" 
$ns at 200.0 "$node_(250) on" 
$node_(251) set X_ 2446 
$node_(251) set Y_ 423 
$node_(251) set Z_ 0.0 
$ns at 0.0 "$node_(251) off" 
$ns at 200.0 "$node_(251) on" 
$node_(252) set X_ 3 
$node_(252) set Y_ 482 
$node_(252) set Z_ 0.0 
$ns at 0.0 "$node_(252) off" 
$ns at 200.0 "$node_(252) on" 
$node_(253) set X_ 2176 
$node_(253) set Y_ 367 
$node_(253) set Z_ 0.0 
$ns at 0.0 "$node_(253) off" 
$ns at 200.0 "$node_(253) on" 
$node_(254) set X_ 1970 
$node_(254) set Y_ 786 
$node_(254) set Z_ 0.0 
$ns at 0.0 "$node_(254) off" 
$ns at 200.0 "$node_(254) on" 
$node_(255) set X_ 1157 
$node_(255) set Y_ 877 
$node_(255) set Z_ 0.0 
$ns at 0.0 "$node_(255) off" 
$ns at 200.0 "$node_(255) on" 
$node_(256) set X_ 1117 
$node_(256) set Y_ 898 
$node_(256) set Z_ 0.0 
$ns at 0.0 "$node_(256) off" 
$ns at 200.0 "$node_(256) on" 
$node_(257) set X_ 1632 
$node_(257) set Y_ 668 
$node_(257) set Z_ 0.0 
$ns at 0.0 "$node_(257) off" 
$ns at 200.0 "$node_(257) on" 
$node_(258) set X_ 1305 
$node_(258) set Y_ 292 
$node_(258) set Z_ 0.0 
$ns at 0.0 "$node_(258) off" 
$ns at 200.0 "$node_(258) on" 
$node_(259) set X_ 2577 
$node_(259) set Y_ 544 
$node_(259) set Z_ 0.0 
$ns at 0.0 "$node_(259) off" 
$ns at 200.0 "$node_(259) on" 
$node_(260) set X_ 1602 
$node_(260) set Y_ 992 
$node_(260) set Z_ 0.0 
$ns at 0.0 "$node_(260) off" 
$ns at 200.0 "$node_(260) on" 
$node_(261) set X_ 2299 
$node_(261) set Y_ 583 
$node_(261) set Z_ 0.0 
$ns at 0.0 "$node_(261) off" 
$ns at 200.0 "$node_(261) on" 
$node_(262) set X_ 936 
$node_(262) set Y_ 199 
$node_(262) set Z_ 0.0 
$ns at 0.0 "$node_(262) off" 
$ns at 200.0 "$node_(262) on" 
$node_(263) set X_ 599 
$node_(263) set Y_ 537 
$node_(263) set Z_ 0.0 
$ns at 0.0 "$node_(263) off" 
$ns at 200.0 "$node_(263) on" 
$node_(264) set X_ 1808 
$node_(264) set Y_ 852 
$node_(264) set Z_ 0.0 
$ns at 0.0 "$node_(264) off" 
$ns at 200.0 "$node_(264) on" 
$node_(265) set X_ 1556 
$node_(265) set Y_ 125 
$node_(265) set Z_ 0.0 
$ns at 0.0 "$node_(265) off" 
$ns at 200.0 "$node_(265) on" 
$node_(266) set X_ 2784 
$node_(266) set Y_ 685 
$node_(266) set Z_ 0.0 
$ns at 0.0 "$node_(266) off" 
$ns at 200.0 "$node_(266) on" 
$node_(267) set X_ 1292 
$node_(267) set Y_ 228 
$node_(267) set Z_ 0.0 
$ns at 0.0 "$node_(267) off" 
$ns at 200.0 "$node_(267) on" 
$node_(268) set X_ 2543 
$node_(268) set Y_ 359 
$node_(268) set Z_ 0.0 
$ns at 0.0 "$node_(268) off" 
$ns at 200.0 "$node_(268) on" 
$node_(269) set X_ 1550 
$node_(269) set Y_ 925 
$node_(269) set Z_ 0.0 
$ns at 0.0 "$node_(269) off" 
$ns at 200.0 "$node_(269) on" 
$node_(270) set X_ 1966 
$node_(270) set Y_ 413 
$node_(270) set Z_ 0.0 
$ns at 0.0 "$node_(270) off" 
$ns at 200.0 "$node_(270) on" 
$node_(271) set X_ 675 
$node_(271) set Y_ 961 
$node_(271) set Z_ 0.0 
$ns at 0.0 "$node_(271) off" 
$ns at 200.0 "$node_(271) on" 
$node_(272) set X_ 2211 
$node_(272) set Y_ 126 
$node_(272) set Z_ 0.0 
$ns at 0.0 "$node_(272) off" 
$ns at 200.0 "$node_(272) on" 
$node_(273) set X_ 2477 
$node_(273) set Y_ 503 
$node_(273) set Z_ 0.0 
$ns at 0.0 "$node_(273) off" 
$ns at 200.0 "$node_(273) on" 
$node_(274) set X_ 1892 
$node_(274) set Y_ 826 
$node_(274) set Z_ 0.0 
$ns at 0.0 "$node_(274) off" 
$ns at 200.0 "$node_(274) on" 
$node_(275) set X_ 2646 
$node_(275) set Y_ 980 
$node_(275) set Z_ 0.0 
$ns at 0.0 "$node_(275) off" 
$ns at 200.0 "$node_(275) on" 
$node_(276) set X_ 1361 
$node_(276) set Y_ 854 
$node_(276) set Z_ 0.0 
$ns at 0.0 "$node_(276) off" 
$ns at 200.0 "$node_(276) on" 
$node_(277) set X_ 754 
$node_(277) set Y_ 381 
$node_(277) set Z_ 0.0 
$ns at 0.0 "$node_(277) off" 
$ns at 200.0 "$node_(277) on" 
$node_(278) set X_ 2718 
$node_(278) set Y_ 169 
$node_(278) set Z_ 0.0 
$ns at 0.0 "$node_(278) off" 
$ns at 200.0 "$node_(278) on" 
$node_(279) set X_ 1460 
$node_(279) set Y_ 656 
$node_(279) set Z_ 0.0 
$ns at 0.0 "$node_(279) off" 
$ns at 200.0 "$node_(279) on" 
$node_(280) set X_ 1476 
$node_(280) set Y_ 519 
$node_(280) set Z_ 0.0 
$ns at 0.0 "$node_(280) off" 
$ns at 200.0 "$node_(280) on" 
$node_(281) set X_ 2356 
$node_(281) set Y_ 747 
$node_(281) set Z_ 0.0 
$ns at 0.0 "$node_(281) off" 
$ns at 200.0 "$node_(281) on" 
$node_(282) set X_ 2874 
$node_(282) set Y_ 249 
$node_(282) set Z_ 0.0 
$ns at 0.0 "$node_(282) off" 
$ns at 200.0 "$node_(282) on" 
$node_(283) set X_ 929 
$node_(283) set Y_ 337 
$node_(283) set Z_ 0.0 
$ns at 0.0 "$node_(283) off" 
$ns at 200.0 "$node_(283) on" 
$node_(284) set X_ 596 
$node_(284) set Y_ 21 
$node_(284) set Z_ 0.0 
$ns at 0.0 "$node_(284) off" 
$ns at 200.0 "$node_(284) on" 
$node_(285) set X_ 2342 
$node_(285) set Y_ 642 
$node_(285) set Z_ 0.0 
$ns at 0.0 "$node_(285) off" 
$ns at 200.0 "$node_(285) on" 
$node_(286) set X_ 116 
$node_(286) set Y_ 204 
$node_(286) set Z_ 0.0 
$ns at 0.0 "$node_(286) off" 
$ns at 200.0 "$node_(286) on" 
$node_(287) set X_ 2227 
$node_(287) set Y_ 411 
$node_(287) set Z_ 0.0 
$ns at 0.0 "$node_(287) off" 
$ns at 200.0 "$node_(287) on" 
$node_(288) set X_ 1119 
$node_(288) set Y_ 205 
$node_(288) set Z_ 0.0 
$ns at 0.0 "$node_(288) off" 
$ns at 200.0 "$node_(288) on" 
$node_(289) set X_ 2354 
$node_(289) set Y_ 857 
$node_(289) set Z_ 0.0 
$ns at 0.0 "$node_(289) off" 
$ns at 200.0 "$node_(289) on" 
$node_(290) set X_ 343 
$node_(290) set Y_ 802 
$node_(290) set Z_ 0.0 
$ns at 0.0 "$node_(290) off" 
$ns at 200.0 "$node_(290) on" 
$node_(291) set X_ 958 
$node_(291) set Y_ 409 
$node_(291) set Z_ 0.0 
$ns at 0.0 "$node_(291) off" 
$ns at 200.0 "$node_(291) on" 
$node_(292) set X_ 858 
$node_(292) set Y_ 380 
$node_(292) set Z_ 0.0 
$ns at 0.0 "$node_(292) off" 
$ns at 200.0 "$node_(292) on" 
$node_(293) set X_ 613 
$node_(293) set Y_ 14 
$node_(293) set Z_ 0.0 
$ns at 0.0 "$node_(293) off" 
$ns at 200.0 "$node_(293) on" 
$node_(294) set X_ 1114 
$node_(294) set Y_ 39 
$node_(294) set Z_ 0.0 
$ns at 0.0 "$node_(294) off" 
$ns at 200.0 "$node_(294) on" 
$node_(295) set X_ 1900 
$node_(295) set Y_ 237 
$node_(295) set Z_ 0.0 
$ns at 0.0 "$node_(295) off" 
$ns at 200.0 "$node_(295) on" 
$node_(296) set X_ 2211 
$node_(296) set Y_ 749 
$node_(296) set Z_ 0.0 
$ns at 0.0 "$node_(296) off" 
$ns at 200.0 "$node_(296) on" 
$node_(297) set X_ 684 
$node_(297) set Y_ 525 
$node_(297) set Z_ 0.0 
$ns at 0.0 "$node_(297) off" 
$ns at 200.0 "$node_(297) on" 
$node_(298) set X_ 1606 
$node_(298) set Y_ 54 
$node_(298) set Z_ 0.0 
$ns at 0.0 "$node_(298) off" 
$ns at 200.0 "$node_(298) on" 
$node_(299) set X_ 556 
$node_(299) set Y_ 852 
$node_(299) set Z_ 0.0 
$ns at 0.0 "$node_(299) off" 
$ns at 200.0 "$node_(299) on" 
$node_(300) set X_ 12 
$node_(300) set Y_ 379 
$node_(300) set Z_ 0.0 
$ns at 0.0 "$node_(300) off" 
$ns at 300.0 "$node_(300) on" 
$node_(301) set X_ 2053 
$node_(301) set Y_ 391 
$node_(301) set Z_ 0.0 
$ns at 0.0 "$node_(301) off" 
$ns at 300.0 "$node_(301) on" 
$node_(302) set X_ 1457 
$node_(302) set Y_ 629 
$node_(302) set Z_ 0.0 
$ns at 0.0 "$node_(302) off" 
$ns at 300.0 "$node_(302) on" 
$node_(303) set X_ 1437 
$node_(303) set Y_ 993 
$node_(303) set Z_ 0.0 
$ns at 0.0 "$node_(303) off" 
$ns at 300.0 "$node_(303) on" 
$node_(304) set X_ 2431 
$node_(304) set Y_ 615 
$node_(304) set Z_ 0.0 
$ns at 0.0 "$node_(304) off" 
$ns at 300.0 "$node_(304) on" 
$node_(305) set X_ 2273 
$node_(305) set Y_ 57 
$node_(305) set Z_ 0.0 
$ns at 0.0 "$node_(305) off" 
$ns at 300.0 "$node_(305) on" 
$node_(306) set X_ 2730 
$node_(306) set Y_ 808 
$node_(306) set Z_ 0.0 
$ns at 0.0 "$node_(306) off" 
$ns at 300.0 "$node_(306) on" 
$node_(307) set X_ 2711 
$node_(307) set Y_ 762 
$node_(307) set Z_ 0.0 
$ns at 0.0 "$node_(307) off" 
$ns at 300.0 "$node_(307) on" 
$node_(308) set X_ 1981 
$node_(308) set Y_ 81 
$node_(308) set Z_ 0.0 
$ns at 0.0 "$node_(308) off" 
$ns at 300.0 "$node_(308) on" 
$node_(309) set X_ 2218 
$node_(309) set Y_ 763 
$node_(309) set Z_ 0.0 
$ns at 0.0 "$node_(309) off" 
$ns at 300.0 "$node_(309) on" 
$node_(310) set X_ 2938 
$node_(310) set Y_ 373 
$node_(310) set Z_ 0.0 
$ns at 0.0 "$node_(310) off" 
$ns at 300.0 "$node_(310) on" 
$node_(311) set X_ 637 
$node_(311) set Y_ 178 
$node_(311) set Z_ 0.0 
$ns at 0.0 "$node_(311) off" 
$ns at 300.0 "$node_(311) on" 
$node_(312) set X_ 498 
$node_(312) set Y_ 659 
$node_(312) set Z_ 0.0 
$ns at 0.0 "$node_(312) off" 
$ns at 300.0 "$node_(312) on" 
$node_(313) set X_ 730 
$node_(313) set Y_ 111 
$node_(313) set Z_ 0.0 
$ns at 0.0 "$node_(313) off" 
$ns at 300.0 "$node_(313) on" 
$node_(314) set X_ 868 
$node_(314) set Y_ 238 
$node_(314) set Z_ 0.0 
$ns at 0.0 "$node_(314) off" 
$ns at 300.0 "$node_(314) on" 
$node_(315) set X_ 1920 
$node_(315) set Y_ 997 
$node_(315) set Z_ 0.0 
$ns at 0.0 "$node_(315) off" 
$ns at 300.0 "$node_(315) on" 
$node_(316) set X_ 671 
$node_(316) set Y_ 91 
$node_(316) set Z_ 0.0 
$ns at 0.0 "$node_(316) off" 
$ns at 300.0 "$node_(316) on" 
$node_(317) set X_ 1665 
$node_(317) set Y_ 796 
$node_(317) set Z_ 0.0 
$ns at 0.0 "$node_(317) off" 
$ns at 300.0 "$node_(317) on" 
$node_(318) set X_ 1654 
$node_(318) set Y_ 990 
$node_(318) set Z_ 0.0 
$ns at 0.0 "$node_(318) off" 
$ns at 300.0 "$node_(318) on" 
$node_(319) set X_ 2899 
$node_(319) set Y_ 407 
$node_(319) set Z_ 0.0 
$ns at 0.0 "$node_(319) off" 
$ns at 300.0 "$node_(319) on" 
$node_(320) set X_ 465 
$node_(320) set Y_ 109 
$node_(320) set Z_ 0.0 
$ns at 0.0 "$node_(320) off" 
$ns at 300.0 "$node_(320) on" 
$node_(321) set X_ 131 
$node_(321) set Y_ 723 
$node_(321) set Z_ 0.0 
$ns at 0.0 "$node_(321) off" 
$ns at 300.0 "$node_(321) on" 
$node_(322) set X_ 2317 
$node_(322) set Y_ 131 
$node_(322) set Z_ 0.0 
$ns at 0.0 "$node_(322) off" 
$ns at 300.0 "$node_(322) on" 
$node_(323) set X_ 220 
$node_(323) set Y_ 423 
$node_(323) set Z_ 0.0 
$ns at 0.0 "$node_(323) off" 
$ns at 300.0 "$node_(323) on" 
$node_(324) set X_ 523 
$node_(324) set Y_ 217 
$node_(324) set Z_ 0.0 
$ns at 0.0 "$node_(324) off" 
$ns at 300.0 "$node_(324) on" 
$node_(325) set X_ 2450 
$node_(325) set Y_ 943 
$node_(325) set Z_ 0.0 
$ns at 0.0 "$node_(325) off" 
$ns at 300.0 "$node_(325) on" 
$node_(326) set X_ 2748 
$node_(326) set Y_ 760 
$node_(326) set Z_ 0.0 
$ns at 0.0 "$node_(326) off" 
$ns at 300.0 "$node_(326) on" 
$node_(327) set X_ 2396 
$node_(327) set Y_ 54 
$node_(327) set Z_ 0.0 
$ns at 0.0 "$node_(327) off" 
$ns at 300.0 "$node_(327) on" 
$node_(328) set X_ 2395 
$node_(328) set Y_ 539 
$node_(328) set Z_ 0.0 
$ns at 0.0 "$node_(328) off" 
$ns at 300.0 "$node_(328) on" 
$node_(329) set X_ 100 
$node_(329) set Y_ 142 
$node_(329) set Z_ 0.0 
$ns at 0.0 "$node_(329) off" 
$ns at 300.0 "$node_(329) on" 
$node_(330) set X_ 827 
$node_(330) set Y_ 745 
$node_(330) set Z_ 0.0 
$ns at 0.0 "$node_(330) off" 
$ns at 300.0 "$node_(330) on" 
$node_(331) set X_ 398 
$node_(331) set Y_ 589 
$node_(331) set Z_ 0.0 
$ns at 0.0 "$node_(331) off" 
$ns at 300.0 "$node_(331) on" 
$node_(332) set X_ 175 
$node_(332) set Y_ 372 
$node_(332) set Z_ 0.0 
$ns at 0.0 "$node_(332) off" 
$ns at 300.0 "$node_(332) on" 
$node_(333) set X_ 1687 
$node_(333) set Y_ 617 
$node_(333) set Z_ 0.0 
$ns at 0.0 "$node_(333) off" 
$ns at 300.0 "$node_(333) on" 
$node_(334) set X_ 164 
$node_(334) set Y_ 624 
$node_(334) set Z_ 0.0 
$ns at 0.0 "$node_(334) off" 
$ns at 300.0 "$node_(334) on" 
$node_(335) set X_ 196 
$node_(335) set Y_ 577 
$node_(335) set Z_ 0.0 
$ns at 0.0 "$node_(335) off" 
$ns at 300.0 "$node_(335) on" 
$node_(336) set X_ 1896 
$node_(336) set Y_ 325 
$node_(336) set Z_ 0.0 
$ns at 0.0 "$node_(336) off" 
$ns at 300.0 "$node_(336) on" 
$node_(337) set X_ 2710 
$node_(337) set Y_ 961 
$node_(337) set Z_ 0.0 
$ns at 0.0 "$node_(337) off" 
$ns at 300.0 "$node_(337) on" 
$node_(338) set X_ 2662 
$node_(338) set Y_ 782 
$node_(338) set Z_ 0.0 
$ns at 0.0 "$node_(338) off" 
$ns at 300.0 "$node_(338) on" 
$node_(339) set X_ 1885 
$node_(339) set Y_ 325 
$node_(339) set Z_ 0.0 
$ns at 0.0 "$node_(339) off" 
$ns at 300.0 "$node_(339) on" 
$node_(340) set X_ 757 
$node_(340) set Y_ 216 
$node_(340) set Z_ 0.0 
$ns at 0.0 "$node_(340) off" 
$ns at 300.0 "$node_(340) on" 
$node_(341) set X_ 1654 
$node_(341) set Y_ 911 
$node_(341) set Z_ 0.0 
$ns at 0.0 "$node_(341) off" 
$ns at 300.0 "$node_(341) on" 
$node_(342) set X_ 881 
$node_(342) set Y_ 651 
$node_(342) set Z_ 0.0 
$ns at 0.0 "$node_(342) off" 
$ns at 300.0 "$node_(342) on" 
$node_(343) set X_ 2810 
$node_(343) set Y_ 18 
$node_(343) set Z_ 0.0 
$ns at 0.0 "$node_(343) off" 
$ns at 300.0 "$node_(343) on" 
$node_(344) set X_ 40 
$node_(344) set Y_ 92 
$node_(344) set Z_ 0.0 
$ns at 0.0 "$node_(344) off" 
$ns at 300.0 "$node_(344) on" 
$node_(345) set X_ 683 
$node_(345) set Y_ 54 
$node_(345) set Z_ 0.0 
$ns at 0.0 "$node_(345) off" 
$ns at 300.0 "$node_(345) on" 
$node_(346) set X_ 898 
$node_(346) set Y_ 970 
$node_(346) set Z_ 0.0 
$ns at 0.0 "$node_(346) off" 
$ns at 300.0 "$node_(346) on" 
$node_(347) set X_ 837 
$node_(347) set Y_ 765 
$node_(347) set Z_ 0.0 
$ns at 0.0 "$node_(347) off" 
$ns at 300.0 "$node_(347) on" 
$node_(348) set X_ 1296 
$node_(348) set Y_ 36 
$node_(348) set Z_ 0.0 
$ns at 0.0 "$node_(348) off" 
$ns at 300.0 "$node_(348) on" 
$node_(349) set X_ 1968 
$node_(349) set Y_ 371 
$node_(349) set Z_ 0.0 
$ns at 0.0 "$node_(349) off" 
$ns at 300.0 "$node_(349) on" 
$node_(350) set X_ 2152 
$node_(350) set Y_ 364 
$node_(350) set Z_ 0.0 
$ns at 0.0 "$node_(350) off" 
$ns at 300.0 "$node_(350) on" 
$node_(351) set X_ 1674 
$node_(351) set Y_ 179 
$node_(351) set Z_ 0.0 
$ns at 0.0 "$node_(351) off" 
$ns at 300.0 "$node_(351) on" 
$node_(352) set X_ 1140 
$node_(352) set Y_ 651 
$node_(352) set Z_ 0.0 
$ns at 0.0 "$node_(352) off" 
$ns at 300.0 "$node_(352) on" 
$node_(353) set X_ 2411 
$node_(353) set Y_ 806 
$node_(353) set Z_ 0.0 
$ns at 0.0 "$node_(353) off" 
$ns at 300.0 "$node_(353) on" 
$node_(354) set X_ 2470 
$node_(354) set Y_ 764 
$node_(354) set Z_ 0.0 
$ns at 0.0 "$node_(354) off" 
$ns at 300.0 "$node_(354) on" 
$node_(355) set X_ 1895 
$node_(355) set Y_ 301 
$node_(355) set Z_ 0.0 
$ns at 0.0 "$node_(355) off" 
$ns at 300.0 "$node_(355) on" 
$node_(356) set X_ 751 
$node_(356) set Y_ 359 
$node_(356) set Z_ 0.0 
$ns at 0.0 "$node_(356) off" 
$ns at 300.0 "$node_(356) on" 
$node_(357) set X_ 2316 
$node_(357) set Y_ 319 
$node_(357) set Z_ 0.0 
$ns at 0.0 "$node_(357) off" 
$ns at 300.0 "$node_(357) on" 
$node_(358) set X_ 1242 
$node_(358) set Y_ 438 
$node_(358) set Z_ 0.0 
$ns at 0.0 "$node_(358) off" 
$ns at 300.0 "$node_(358) on" 
$node_(359) set X_ 1067 
$node_(359) set Y_ 970 
$node_(359) set Z_ 0.0 
$ns at 0.0 "$node_(359) off" 
$ns at 300.0 "$node_(359) on" 
$node_(360) set X_ 2908 
$node_(360) set Y_ 921 
$node_(360) set Z_ 0.0 
$ns at 0.0 "$node_(360) off" 
$ns at 300.0 "$node_(360) on" 
$node_(361) set X_ 2268 
$node_(361) set Y_ 151 
$node_(361) set Z_ 0.0 
$ns at 0.0 "$node_(361) off" 
$ns at 300.0 "$node_(361) on" 
$node_(362) set X_ 1471 
$node_(362) set Y_ 655 
$node_(362) set Z_ 0.0 
$ns at 0.0 "$node_(362) off" 
$ns at 300.0 "$node_(362) on" 
$node_(363) set X_ 1135 
$node_(363) set Y_ 954 
$node_(363) set Z_ 0.0 
$ns at 0.0 "$node_(363) off" 
$ns at 300.0 "$node_(363) on" 
$node_(364) set X_ 2164 
$node_(364) set Y_ 809 
$node_(364) set Z_ 0.0 
$ns at 0.0 "$node_(364) off" 
$ns at 300.0 "$node_(364) on" 
$node_(365) set X_ 2244 
$node_(365) set Y_ 223 
$node_(365) set Z_ 0.0 
$ns at 0.0 "$node_(365) off" 
$ns at 300.0 "$node_(365) on" 
$node_(366) set X_ 151 
$node_(366) set Y_ 248 
$node_(366) set Z_ 0.0 
$ns at 0.0 "$node_(366) off" 
$ns at 300.0 "$node_(366) on" 
$node_(367) set X_ 2962 
$node_(367) set Y_ 437 
$node_(367) set Z_ 0.0 
$ns at 0.0 "$node_(367) off" 
$ns at 300.0 "$node_(367) on" 
$node_(368) set X_ 1482 
$node_(368) set Y_ 340 
$node_(368) set Z_ 0.0 
$ns at 0.0 "$node_(368) off" 
$ns at 300.0 "$node_(368) on" 
$node_(369) set X_ 2750 
$node_(369) set Y_ 909 
$node_(369) set Z_ 0.0 
$ns at 0.0 "$node_(369) off" 
$ns at 300.0 "$node_(369) on" 
$node_(370) set X_ 2188 
$node_(370) set Y_ 596 
$node_(370) set Z_ 0.0 
$ns at 0.0 "$node_(370) off" 
$ns at 300.0 "$node_(370) on" 
$node_(371) set X_ 1692 
$node_(371) set Y_ 682 
$node_(371) set Z_ 0.0 
$ns at 0.0 "$node_(371) off" 
$ns at 300.0 "$node_(371) on" 
$node_(372) set X_ 2437 
$node_(372) set Y_ 701 
$node_(372) set Z_ 0.0 
$ns at 0.0 "$node_(372) off" 
$ns at 300.0 "$node_(372) on" 
$node_(373) set X_ 2499 
$node_(373) set Y_ 623 
$node_(373) set Z_ 0.0 
$ns at 0.0 "$node_(373) off" 
$ns at 300.0 "$node_(373) on" 
$node_(374) set X_ 844 
$node_(374) set Y_ 793 
$node_(374) set Z_ 0.0 
$ns at 0.0 "$node_(374) off" 
$ns at 300.0 "$node_(374) on" 
$node_(375) set X_ 1308 
$node_(375) set Y_ 964 
$node_(375) set Z_ 0.0 
$ns at 0.0 "$node_(375) off" 
$ns at 300.0 "$node_(375) on" 
$node_(376) set X_ 819 
$node_(376) set Y_ 269 
$node_(376) set Z_ 0.0 
$ns at 0.0 "$node_(376) off" 
$ns at 300.0 "$node_(376) on" 
$node_(377) set X_ 2908 
$node_(377) set Y_ 922 
$node_(377) set Z_ 0.0 
$ns at 0.0 "$node_(377) off" 
$ns at 300.0 "$node_(377) on" 
$node_(378) set X_ 391 
$node_(378) set Y_ 36 
$node_(378) set Z_ 0.0 
$ns at 0.0 "$node_(378) off" 
$ns at 300.0 "$node_(378) on" 
$node_(379) set X_ 578 
$node_(379) set Y_ 100 
$node_(379) set Z_ 0.0 
$ns at 0.0 "$node_(379) off" 
$ns at 300.0 "$node_(379) on" 
$node_(380) set X_ 2221 
$node_(380) set Y_ 871 
$node_(380) set Z_ 0.0 
$ns at 0.0 "$node_(380) off" 
$ns at 300.0 "$node_(380) on" 
$node_(381) set X_ 444 
$node_(381) set Y_ 106 
$node_(381) set Z_ 0.0 
$ns at 0.0 "$node_(381) off" 
$ns at 300.0 "$node_(381) on" 
$node_(382) set X_ 1473 
$node_(382) set Y_ 475 
$node_(382) set Z_ 0.0 
$ns at 0.0 "$node_(382) off" 
$ns at 300.0 "$node_(382) on" 
$node_(383) set X_ 2249 
$node_(383) set Y_ 152 
$node_(383) set Z_ 0.0 
$ns at 0.0 "$node_(383) off" 
$ns at 300.0 "$node_(383) on" 
$node_(384) set X_ 963 
$node_(384) set Y_ 874 
$node_(384) set Z_ 0.0 
$ns at 0.0 "$node_(384) off" 
$ns at 300.0 "$node_(384) on" 
$node_(385) set X_ 2599 
$node_(385) set Y_ 489 
$node_(385) set Z_ 0.0 
$ns at 0.0 "$node_(385) off" 
$ns at 300.0 "$node_(385) on" 
$node_(386) set X_ 2363 
$node_(386) set Y_ 77 
$node_(386) set Z_ 0.0 
$ns at 0.0 "$node_(386) off" 
$ns at 300.0 "$node_(386) on" 
$node_(387) set X_ 2177 
$node_(387) set Y_ 143 
$node_(387) set Z_ 0.0 
$ns at 0.0 "$node_(387) off" 
$ns at 300.0 "$node_(387) on" 
$node_(388) set X_ 1434 
$node_(388) set Y_ 249 
$node_(388) set Z_ 0.0 
$ns at 0.0 "$node_(388) off" 
$ns at 300.0 "$node_(388) on" 
$node_(389) set X_ 2014 
$node_(389) set Y_ 831 
$node_(389) set Z_ 0.0 
$ns at 0.0 "$node_(389) off" 
$ns at 300.0 "$node_(389) on" 
$node_(390) set X_ 1094 
$node_(390) set Y_ 245 
$node_(390) set Z_ 0.0 
$ns at 0.0 "$node_(390) off" 
$ns at 300.0 "$node_(390) on" 
$node_(391) set X_ 2773 
$node_(391) set Y_ 871 
$node_(391) set Z_ 0.0 
$ns at 0.0 "$node_(391) off" 
$ns at 300.0 "$node_(391) on" 
$node_(392) set X_ 2690 
$node_(392) set Y_ 9 
$node_(392) set Z_ 0.0 
$ns at 0.0 "$node_(392) off" 
$ns at 300.0 "$node_(392) on" 
$node_(393) set X_ 39 
$node_(393) set Y_ 609 
$node_(393) set Z_ 0.0 
$ns at 0.0 "$node_(393) off" 
$ns at 300.0 "$node_(393) on" 
$node_(394) set X_ 2179 
$node_(394) set Y_ 233 
$node_(394) set Z_ 0.0 
$ns at 0.0 "$node_(394) off" 
$ns at 300.0 "$node_(394) on" 
$node_(395) set X_ 2925 
$node_(395) set Y_ 137 
$node_(395) set Z_ 0.0 
$ns at 0.0 "$node_(395) off" 
$ns at 300.0 "$node_(395) on" 
$node_(396) set X_ 2903 
$node_(396) set Y_ 663 
$node_(396) set Z_ 0.0 
$ns at 0.0 "$node_(396) off" 
$ns at 300.0 "$node_(396) on" 
$node_(397) set X_ 745 
$node_(397) set Y_ 106 
$node_(397) set Z_ 0.0 
$ns at 0.0 "$node_(397) off" 
$ns at 300.0 "$node_(397) on" 
$node_(398) set X_ 2379 
$node_(398) set Y_ 612 
$node_(398) set Z_ 0.0 
$ns at 0.0 "$node_(398) off" 
$ns at 300.0 "$node_(398) on" 
$node_(399) set X_ 1300 
$node_(399) set Y_ 992 
$node_(399) set Z_ 0.0 
$ns at 0.0 "$node_(399) off" 
$ns at 300.0 "$node_(399) on" 
$node_(400) set X_ 8 
$node_(400) set Y_ 577 
$node_(400) set Z_ 0.0 
$ns at 0.0 "$node_(400) off" 
$ns at 400.0 "$node_(400) on" 
$node_(401) set X_ 2174 
$node_(401) set Y_ 516 
$node_(401) set Z_ 0.0 
$ns at 0.0 "$node_(401) off" 
$ns at 400.0 "$node_(401) on" 
$node_(402) set X_ 2735 
$node_(402) set Y_ 313 
$node_(402) set Z_ 0.0 
$ns at 0.0 "$node_(402) off" 
$ns at 400.0 "$node_(402) on" 
$node_(403) set X_ 2674 
$node_(403) set Y_ 808 
$node_(403) set Z_ 0.0 
$ns at 0.0 "$node_(403) off" 
$ns at 400.0 "$node_(403) on" 
$node_(404) set X_ 1615 
$node_(404) set Y_ 390 
$node_(404) set Z_ 0.0 
$ns at 0.0 "$node_(404) off" 
$ns at 400.0 "$node_(404) on" 
$node_(405) set X_ 353 
$node_(405) set Y_ 515 
$node_(405) set Z_ 0.0 
$ns at 0.0 "$node_(405) off" 
$ns at 400.0 "$node_(405) on" 
$node_(406) set X_ 1831 
$node_(406) set Y_ 16 
$node_(406) set Z_ 0.0 
$ns at 0.0 "$node_(406) off" 
$ns at 400.0 "$node_(406) on" 
$node_(407) set X_ 2697 
$node_(407) set Y_ 289 
$node_(407) set Z_ 0.0 
$ns at 0.0 "$node_(407) off" 
$ns at 400.0 "$node_(407) on" 
$node_(408) set X_ 1048 
$node_(408) set Y_ 884 
$node_(408) set Z_ 0.0 
$ns at 0.0 "$node_(408) off" 
$ns at 400.0 "$node_(408) on" 
$node_(409) set X_ 1346 
$node_(409) set Y_ 22 
$node_(409) set Z_ 0.0 
$ns at 0.0 "$node_(409) off" 
$ns at 400.0 "$node_(409) on" 
$node_(410) set X_ 1010 
$node_(410) set Y_ 905 
$node_(410) set Z_ 0.0 
$ns at 0.0 "$node_(410) off" 
$ns at 400.0 "$node_(410) on" 
$node_(411) set X_ 2241 
$node_(411) set Y_ 712 
$node_(411) set Z_ 0.0 
$ns at 0.0 "$node_(411) off" 
$ns at 400.0 "$node_(411) on" 
$node_(412) set X_ 97 
$node_(412) set Y_ 937 
$node_(412) set Z_ 0.0 
$ns at 0.0 "$node_(412) off" 
$ns at 400.0 "$node_(412) on" 
$node_(413) set X_ 1374 
$node_(413) set Y_ 93 
$node_(413) set Z_ 0.0 
$ns at 0.0 "$node_(413) off" 
$ns at 400.0 "$node_(413) on" 
$node_(414) set X_ 1986 
$node_(414) set Y_ 57 
$node_(414) set Z_ 0.0 
$ns at 0.0 "$node_(414) off" 
$ns at 400.0 "$node_(414) on" 
$node_(415) set X_ 1234 
$node_(415) set Y_ 24 
$node_(415) set Z_ 0.0 
$ns at 0.0 "$node_(415) off" 
$ns at 400.0 "$node_(415) on" 
$node_(416) set X_ 809 
$node_(416) set Y_ 480 
$node_(416) set Z_ 0.0 
$ns at 0.0 "$node_(416) off" 
$ns at 400.0 "$node_(416) on" 
$node_(417) set X_ 780 
$node_(417) set Y_ 157 
$node_(417) set Z_ 0.0 
$ns at 0.0 "$node_(417) off" 
$ns at 400.0 "$node_(417) on" 
$node_(418) set X_ 2093 
$node_(418) set Y_ 985 
$node_(418) set Z_ 0.0 
$ns at 0.0 "$node_(418) off" 
$ns at 400.0 "$node_(418) on" 
$node_(419) set X_ 637 
$node_(419) set Y_ 591 
$node_(419) set Z_ 0.0 
$ns at 0.0 "$node_(419) off" 
$ns at 400.0 "$node_(419) on" 
$node_(420) set X_ 423 
$node_(420) set Y_ 568 
$node_(420) set Z_ 0.0 
$ns at 0.0 "$node_(420) off" 
$ns at 400.0 "$node_(420) on" 
$node_(421) set X_ 1365 
$node_(421) set Y_ 60 
$node_(421) set Z_ 0.0 
$ns at 0.0 "$node_(421) off" 
$ns at 400.0 "$node_(421) on" 
$node_(422) set X_ 2117 
$node_(422) set Y_ 103 
$node_(422) set Z_ 0.0 
$ns at 0.0 "$node_(422) off" 
$ns at 400.0 "$node_(422) on" 
$node_(423) set X_ 2963 
$node_(423) set Y_ 703 
$node_(423) set Z_ 0.0 
$ns at 0.0 "$node_(423) off" 
$ns at 400.0 "$node_(423) on" 
$node_(424) set X_ 285 
$node_(424) set Y_ 992 
$node_(424) set Z_ 0.0 
$ns at 0.0 "$node_(424) off" 
$ns at 400.0 "$node_(424) on" 
$node_(425) set X_ 374 
$node_(425) set Y_ 611 
$node_(425) set Z_ 0.0 
$ns at 0.0 "$node_(425) off" 
$ns at 400.0 "$node_(425) on" 
$node_(426) set X_ 437 
$node_(426) set Y_ 135 
$node_(426) set Z_ 0.0 
$ns at 0.0 "$node_(426) off" 
$ns at 400.0 "$node_(426) on" 
$node_(427) set X_ 2485 
$node_(427) set Y_ 158 
$node_(427) set Z_ 0.0 
$ns at 0.0 "$node_(427) off" 
$ns at 400.0 "$node_(427) on" 
$node_(428) set X_ 1326 
$node_(428) set Y_ 60 
$node_(428) set Z_ 0.0 
$ns at 0.0 "$node_(428) off" 
$ns at 400.0 "$node_(428) on" 
$node_(429) set X_ 1160 
$node_(429) set Y_ 597 
$node_(429) set Z_ 0.0 
$ns at 0.0 "$node_(429) off" 
$ns at 400.0 "$node_(429) on" 
$node_(430) set X_ 1932 
$node_(430) set Y_ 741 
$node_(430) set Z_ 0.0 
$ns at 0.0 "$node_(430) off" 
$ns at 400.0 "$node_(430) on" 
$node_(431) set X_ 2045 
$node_(431) set Y_ 507 
$node_(431) set Z_ 0.0 
$ns at 0.0 "$node_(431) off" 
$ns at 400.0 "$node_(431) on" 
$node_(432) set X_ 1457 
$node_(432) set Y_ 437 
$node_(432) set Z_ 0.0 
$ns at 0.0 "$node_(432) off" 
$ns at 400.0 "$node_(432) on" 
$node_(433) set X_ 1299 
$node_(433) set Y_ 473 
$node_(433) set Z_ 0.0 
$ns at 0.0 "$node_(433) off" 
$ns at 400.0 "$node_(433) on" 
$node_(434) set X_ 1874 
$node_(434) set Y_ 869 
$node_(434) set Z_ 0.0 
$ns at 0.0 "$node_(434) off" 
$ns at 400.0 "$node_(434) on" 
$node_(435) set X_ 1113 
$node_(435) set Y_ 800 
$node_(435) set Z_ 0.0 
$ns at 0.0 "$node_(435) off" 
$ns at 400.0 "$node_(435) on" 
$node_(436) set X_ 1948 
$node_(436) set Y_ 208 
$node_(436) set Z_ 0.0 
$ns at 0.0 "$node_(436) off" 
$ns at 400.0 "$node_(436) on" 
$node_(437) set X_ 688 
$node_(437) set Y_ 175 
$node_(437) set Z_ 0.0 
$ns at 0.0 "$node_(437) off" 
$ns at 400.0 "$node_(437) on" 
$node_(438) set X_ 1769 
$node_(438) set Y_ 612 
$node_(438) set Z_ 0.0 
$ns at 0.0 "$node_(438) off" 
$ns at 400.0 "$node_(438) on" 
$node_(439) set X_ 2494 
$node_(439) set Y_ 901 
$node_(439) set Z_ 0.0 
$ns at 0.0 "$node_(439) off" 
$ns at 400.0 "$node_(439) on" 
$node_(440) set X_ 661 
$node_(440) set Y_ 532 
$node_(440) set Z_ 0.0 
$ns at 0.0 "$node_(440) off" 
$ns at 400.0 "$node_(440) on" 
$node_(441) set X_ 903 
$node_(441) set Y_ 778 
$node_(441) set Z_ 0.0 
$ns at 0.0 "$node_(441) off" 
$ns at 400.0 "$node_(441) on" 
$node_(442) set X_ 866 
$node_(442) set Y_ 583 
$node_(442) set Z_ 0.0 
$ns at 0.0 "$node_(442) off" 
$ns at 400.0 "$node_(442) on" 
$node_(443) set X_ 1841 
$node_(443) set Y_ 718 
$node_(443) set Z_ 0.0 
$ns at 0.0 "$node_(443) off" 
$ns at 400.0 "$node_(443) on" 
$node_(444) set X_ 1698 
$node_(444) set Y_ 560 
$node_(444) set Z_ 0.0 
$ns at 0.0 "$node_(444) off" 
$ns at 400.0 "$node_(444) on" 
$node_(445) set X_ 844 
$node_(445) set Y_ 940 
$node_(445) set Z_ 0.0 
$ns at 0.0 "$node_(445) off" 
$ns at 400.0 "$node_(445) on" 
$node_(446) set X_ 788 
$node_(446) set Y_ 90 
$node_(446) set Z_ 0.0 
$ns at 0.0 "$node_(446) off" 
$ns at 400.0 "$node_(446) on" 
$node_(447) set X_ 2872 
$node_(447) set Y_ 921 
$node_(447) set Z_ 0.0 
$ns at 0.0 "$node_(447) off" 
$ns at 400.0 "$node_(447) on" 
$node_(448) set X_ 2823 
$node_(448) set Y_ 487 
$node_(448) set Z_ 0.0 
$ns at 0.0 "$node_(448) off" 
$ns at 400.0 "$node_(448) on" 
$node_(449) set X_ 434 
$node_(449) set Y_ 351 
$node_(449) set Z_ 0.0 
$ns at 0.0 "$node_(449) off" 
$ns at 400.0 "$node_(449) on" 
$node_(450) set X_ 1512 
$node_(450) set Y_ 607 
$node_(450) set Z_ 0.0 
$ns at 0.0 "$node_(450) off" 
$ns at 400.0 "$node_(450) on" 
$node_(451) set X_ 2946 
$node_(451) set Y_ 983 
$node_(451) set Z_ 0.0 
$ns at 0.0 "$node_(451) off" 
$ns at 400.0 "$node_(451) on" 
$node_(452) set X_ 740 
$node_(452) set Y_ 895 
$node_(452) set Z_ 0.0 
$ns at 0.0 "$node_(452) off" 
$ns at 400.0 "$node_(452) on" 
$node_(453) set X_ 925 
$node_(453) set Y_ 641 
$node_(453) set Z_ 0.0 
$ns at 0.0 "$node_(453) off" 
$ns at 400.0 "$node_(453) on" 
$node_(454) set X_ 655 
$node_(454) set Y_ 340 
$node_(454) set Z_ 0.0 
$ns at 0.0 "$node_(454) off" 
$ns at 400.0 "$node_(454) on" 
$node_(455) set X_ 2403 
$node_(455) set Y_ 630 
$node_(455) set Z_ 0.0 
$ns at 0.0 "$node_(455) off" 
$ns at 400.0 "$node_(455) on" 
$node_(456) set X_ 1066 
$node_(456) set Y_ 787 
$node_(456) set Z_ 0.0 
$ns at 0.0 "$node_(456) off" 
$ns at 400.0 "$node_(456) on" 
$node_(457) set X_ 58 
$node_(457) set Y_ 449 
$node_(457) set Z_ 0.0 
$ns at 0.0 "$node_(457) off" 
$ns at 400.0 "$node_(457) on" 
$node_(458) set X_ 2787 
$node_(458) set Y_ 880 
$node_(458) set Z_ 0.0 
$ns at 0.0 "$node_(458) off" 
$ns at 400.0 "$node_(458) on" 
$node_(459) set X_ 1809 
$node_(459) set Y_ 21 
$node_(459) set Z_ 0.0 
$ns at 0.0 "$node_(459) off" 
$ns at 400.0 "$node_(459) on" 
$node_(460) set X_ 2597 
$node_(460) set Y_ 936 
$node_(460) set Z_ 0.0 
$ns at 0.0 "$node_(460) off" 
$ns at 400.0 "$node_(460) on" 
$node_(461) set X_ 2124 
$node_(461) set Y_ 615 
$node_(461) set Z_ 0.0 
$ns at 0.0 "$node_(461) off" 
$ns at 400.0 "$node_(461) on" 
$node_(462) set X_ 1225 
$node_(462) set Y_ 231 
$node_(462) set Z_ 0.0 
$ns at 0.0 "$node_(462) off" 
$ns at 400.0 "$node_(462) on" 
$node_(463) set X_ 26 
$node_(463) set Y_ 256 
$node_(463) set Z_ 0.0 
$ns at 0.0 "$node_(463) off" 
$ns at 400.0 "$node_(463) on" 
$node_(464) set X_ 1192 
$node_(464) set Y_ 467 
$node_(464) set Z_ 0.0 
$ns at 0.0 "$node_(464) off" 
$ns at 400.0 "$node_(464) on" 
$node_(465) set X_ 698 
$node_(465) set Y_ 707 
$node_(465) set Z_ 0.0 
$ns at 0.0 "$node_(465) off" 
$ns at 400.0 "$node_(465) on" 
$node_(466) set X_ 541 
$node_(466) set Y_ 728 
$node_(466) set Z_ 0.0 
$ns at 0.0 "$node_(466) off" 
$ns at 400.0 "$node_(466) on" 
$node_(467) set X_ 746 
$node_(467) set Y_ 27 
$node_(467) set Z_ 0.0 
$ns at 0.0 "$node_(467) off" 
$ns at 400.0 "$node_(467) on" 
$node_(468) set X_ 2380 
$node_(468) set Y_ 803 
$node_(468) set Z_ 0.0 
$ns at 0.0 "$node_(468) off" 
$ns at 400.0 "$node_(468) on" 
$node_(469) set X_ 574 
$node_(469) set Y_ 321 
$node_(469) set Z_ 0.0 
$ns at 0.0 "$node_(469) off" 
$ns at 400.0 "$node_(469) on" 
$node_(470) set X_ 1725 
$node_(470) set Y_ 610 
$node_(470) set Z_ 0.0 
$ns at 0.0 "$node_(470) off" 
$ns at 400.0 "$node_(470) on" 
$node_(471) set X_ 2888 
$node_(471) set Y_ 507 
$node_(471) set Z_ 0.0 
$ns at 0.0 "$node_(471) off" 
$ns at 400.0 "$node_(471) on" 
$node_(472) set X_ 2525 
$node_(472) set Y_ 367 
$node_(472) set Z_ 0.0 
$ns at 0.0 "$node_(472) off" 
$ns at 400.0 "$node_(472) on" 
$node_(473) set X_ 2175 
$node_(473) set Y_ 887 
$node_(473) set Z_ 0.0 
$ns at 0.0 "$node_(473) off" 
$ns at 400.0 "$node_(473) on" 
$node_(474) set X_ 1740 
$node_(474) set Y_ 269 
$node_(474) set Z_ 0.0 
$ns at 0.0 "$node_(474) off" 
$ns at 400.0 "$node_(474) on" 
$node_(475) set X_ 2031 
$node_(475) set Y_ 801 
$node_(475) set Z_ 0.0 
$ns at 0.0 "$node_(475) off" 
$ns at 400.0 "$node_(475) on" 
$node_(476) set X_ 1132 
$node_(476) set Y_ 703 
$node_(476) set Z_ 0.0 
$ns at 0.0 "$node_(476) off" 
$ns at 400.0 "$node_(476) on" 
$node_(477) set X_ 1466 
$node_(477) set Y_ 919 
$node_(477) set Z_ 0.0 
$ns at 0.0 "$node_(477) off" 
$ns at 400.0 "$node_(477) on" 
$node_(478) set X_ 2923 
$node_(478) set Y_ 450 
$node_(478) set Z_ 0.0 
$ns at 0.0 "$node_(478) off" 
$ns at 400.0 "$node_(478) on" 
$node_(479) set X_ 759 
$node_(479) set Y_ 551 
$node_(479) set Z_ 0.0 
$ns at 0.0 "$node_(479) off" 
$ns at 400.0 "$node_(479) on" 
$node_(480) set X_ 2642 
$node_(480) set Y_ 882 
$node_(480) set Z_ 0.0 
$ns at 0.0 "$node_(480) off" 
$ns at 400.0 "$node_(480) on" 
$node_(481) set X_ 2157 
$node_(481) set Y_ 922 
$node_(481) set Z_ 0.0 
$ns at 0.0 "$node_(481) off" 
$ns at 400.0 "$node_(481) on" 
$node_(482) set X_ 1445 
$node_(482) set Y_ 917 
$node_(482) set Z_ 0.0 
$ns at 0.0 "$node_(482) off" 
$ns at 400.0 "$node_(482) on" 
$node_(483) set X_ 2590 
$node_(483) set Y_ 510 
$node_(483) set Z_ 0.0 
$ns at 0.0 "$node_(483) off" 
$ns at 400.0 "$node_(483) on" 
$node_(484) set X_ 2801 
$node_(484) set Y_ 365 
$node_(484) set Z_ 0.0 
$ns at 0.0 "$node_(484) off" 
$ns at 400.0 "$node_(484) on" 
$node_(485) set X_ 1707 
$node_(485) set Y_ 412 
$node_(485) set Z_ 0.0 
$ns at 0.0 "$node_(485) off" 
$ns at 400.0 "$node_(485) on" 
$node_(486) set X_ 2803 
$node_(486) set Y_ 351 
$node_(486) set Z_ 0.0 
$ns at 0.0 "$node_(486) off" 
$ns at 400.0 "$node_(486) on" 
$node_(487) set X_ 886 
$node_(487) set Y_ 186 
$node_(487) set Z_ 0.0 
$ns at 0.0 "$node_(487) off" 
$ns at 400.0 "$node_(487) on" 
$node_(488) set X_ 454 
$node_(488) set Y_ 698 
$node_(488) set Z_ 0.0 
$ns at 0.0 "$node_(488) off" 
$ns at 400.0 "$node_(488) on" 
$node_(489) set X_ 421 
$node_(489) set Y_ 764 
$node_(489) set Z_ 0.0 
$ns at 0.0 "$node_(489) off" 
$ns at 400.0 "$node_(489) on" 
$node_(490) set X_ 2050 
$node_(490) set Y_ 508 
$node_(490) set Z_ 0.0 
$ns at 0.0 "$node_(490) off" 
$ns at 400.0 "$node_(490) on" 
$node_(491) set X_ 1886 
$node_(491) set Y_ 875 
$node_(491) set Z_ 0.0 
$ns at 0.0 "$node_(491) off" 
$ns at 400.0 "$node_(491) on" 
$node_(492) set X_ 1328 
$node_(492) set Y_ 698 
$node_(492) set Z_ 0.0 
$ns at 0.0 "$node_(492) off" 
$ns at 400.0 "$node_(492) on" 
$node_(493) set X_ 2655 
$node_(493) set Y_ 827 
$node_(493) set Z_ 0.0 
$ns at 0.0 "$node_(493) off" 
$ns at 400.0 "$node_(493) on" 
$node_(494) set X_ 2234 
$node_(494) set Y_ 904 
$node_(494) set Z_ 0.0 
$ns at 0.0 "$node_(494) off" 
$ns at 400.0 "$node_(494) on" 
$node_(495) set X_ 1785 
$node_(495) set Y_ 674 
$node_(495) set Z_ 0.0 
$ns at 0.0 "$node_(495) off" 
$ns at 400.0 "$node_(495) on" 
$node_(496) set X_ 2178 
$node_(496) set Y_ 13 
$node_(496) set Z_ 0.0 
$ns at 0.0 "$node_(496) off" 
$ns at 400.0 "$node_(496) on" 
$node_(497) set X_ 919 
$node_(497) set Y_ 536 
$node_(497) set Z_ 0.0 
$ns at 0.0 "$node_(497) off" 
$ns at 400.0 "$node_(497) on" 
$node_(498) set X_ 1257 
$node_(498) set Y_ 537 
$node_(498) set Z_ 0.0 
$ns at 0.0 "$node_(498) off" 
$ns at 400.0 "$node_(498) on" 
$node_(499) set X_ 488 
$node_(499) set Y_ 292 
$node_(499) set Z_ 0.0 
$ns at 0.0 "$node_(499) off" 
$ns at 400.0 "$node_(499) on" 
$node_(500) set X_ 1356 
$node_(500) set Y_ 206 
$node_(500) set Z_ 0.0 
$ns at 0.0 "$node_(500) off" 
$ns at 500.0 "$node_(500) on" 
$node_(501) set X_ 397 
$node_(501) set Y_ 954 
$node_(501) set Z_ 0.0 
$ns at 0.0 "$node_(501) off" 
$ns at 500.0 "$node_(501) on" 
$node_(502) set X_ 1126 
$node_(502) set Y_ 431 
$node_(502) set Z_ 0.0 
$ns at 0.0 "$node_(502) off" 
$ns at 500.0 "$node_(502) on" 
$node_(503) set X_ 460 
$node_(503) set Y_ 761 
$node_(503) set Z_ 0.0 
$ns at 0.0 "$node_(503) off" 
$ns at 500.0 "$node_(503) on" 
$node_(504) set X_ 1666 
$node_(504) set Y_ 757 
$node_(504) set Z_ 0.0 
$ns at 0.0 "$node_(504) off" 
$ns at 500.0 "$node_(504) on" 
$node_(505) set X_ 1157 
$node_(505) set Y_ 475 
$node_(505) set Z_ 0.0 
$ns at 0.0 "$node_(505) off" 
$ns at 500.0 "$node_(505) on" 
$node_(506) set X_ 1298 
$node_(506) set Y_ 9 
$node_(506) set Z_ 0.0 
$ns at 0.0 "$node_(506) off" 
$ns at 500.0 "$node_(506) on" 
$node_(507) set X_ 2818 
$node_(507) set Y_ 364 
$node_(507) set Z_ 0.0 
$ns at 0.0 "$node_(507) off" 
$ns at 500.0 "$node_(507) on" 
$node_(508) set X_ 2069 
$node_(508) set Y_ 628 
$node_(508) set Z_ 0.0 
$ns at 0.0 "$node_(508) off" 
$ns at 500.0 "$node_(508) on" 
$node_(509) set X_ 97 
$node_(509) set Y_ 129 
$node_(509) set Z_ 0.0 
$ns at 0.0 "$node_(509) off" 
$ns at 500.0 "$node_(509) on" 
$node_(510) set X_ 1598 
$node_(510) set Y_ 572 
$node_(510) set Z_ 0.0 
$ns at 0.0 "$node_(510) off" 
$ns at 500.0 "$node_(510) on" 
$node_(511) set X_ 1558 
$node_(511) set Y_ 364 
$node_(511) set Z_ 0.0 
$ns at 0.0 "$node_(511) off" 
$ns at 500.0 "$node_(511) on" 
$node_(512) set X_ 2612 
$node_(512) set Y_ 284 
$node_(512) set Z_ 0.0 
$ns at 0.0 "$node_(512) off" 
$ns at 500.0 "$node_(512) on" 
$node_(513) set X_ 378 
$node_(513) set Y_ 191 
$node_(513) set Z_ 0.0 
$ns at 0.0 "$node_(513) off" 
$ns at 500.0 "$node_(513) on" 
$node_(514) set X_ 1910 
$node_(514) set Y_ 401 
$node_(514) set Z_ 0.0 
$ns at 0.0 "$node_(514) off" 
$ns at 500.0 "$node_(514) on" 
$node_(515) set X_ 1589 
$node_(515) set Y_ 373 
$node_(515) set Z_ 0.0 
$ns at 0.0 "$node_(515) off" 
$ns at 500.0 "$node_(515) on" 
$node_(516) set X_ 2637 
$node_(516) set Y_ 319 
$node_(516) set Z_ 0.0 
$ns at 0.0 "$node_(516) off" 
$ns at 500.0 "$node_(516) on" 
$node_(517) set X_ 1897 
$node_(517) set Y_ 577 
$node_(517) set Z_ 0.0 
$ns at 0.0 "$node_(517) off" 
$ns at 500.0 "$node_(517) on" 
$node_(518) set X_ 1627 
$node_(518) set Y_ 246 
$node_(518) set Z_ 0.0 
$ns at 0.0 "$node_(518) off" 
$ns at 500.0 "$node_(518) on" 
$node_(519) set X_ 2957 
$node_(519) set Y_ 436 
$node_(519) set Z_ 0.0 
$ns at 0.0 "$node_(519) off" 
$ns at 500.0 "$node_(519) on" 
$node_(520) set X_ 131 
$node_(520) set Y_ 68 
$node_(520) set Z_ 0.0 
$ns at 0.0 "$node_(520) off" 
$ns at 500.0 "$node_(520) on" 
$node_(521) set X_ 1057 
$node_(521) set Y_ 707 
$node_(521) set Z_ 0.0 
$ns at 0.0 "$node_(521) off" 
$ns at 500.0 "$node_(521) on" 
$node_(522) set X_ 2547 
$node_(522) set Y_ 237 
$node_(522) set Z_ 0.0 
$ns at 0.0 "$node_(522) off" 
$ns at 500.0 "$node_(522) on" 
$node_(523) set X_ 2422 
$node_(523) set Y_ 167 
$node_(523) set Z_ 0.0 
$ns at 0.0 "$node_(523) off" 
$ns at 500.0 "$node_(523) on" 
$node_(524) set X_ 797 
$node_(524) set Y_ 874 
$node_(524) set Z_ 0.0 
$ns at 0.0 "$node_(524) off" 
$ns at 500.0 "$node_(524) on" 
$node_(525) set X_ 1876 
$node_(525) set Y_ 801 
$node_(525) set Z_ 0.0 
$ns at 0.0 "$node_(525) off" 
$ns at 500.0 "$node_(525) on" 
$node_(526) set X_ 1704 
$node_(526) set Y_ 469 
$node_(526) set Z_ 0.0 
$ns at 0.0 "$node_(526) off" 
$ns at 500.0 "$node_(526) on" 
$node_(527) set X_ 1290 
$node_(527) set Y_ 513 
$node_(527) set Z_ 0.0 
$ns at 0.0 "$node_(527) off" 
$ns at 500.0 "$node_(527) on" 
$node_(528) set X_ 1199 
$node_(528) set Y_ 877 
$node_(528) set Z_ 0.0 
$ns at 0.0 "$node_(528) off" 
$ns at 500.0 "$node_(528) on" 
$node_(529) set X_ 2203 
$node_(529) set Y_ 823 
$node_(529) set Z_ 0.0 
$ns at 0.0 "$node_(529) off" 
$ns at 500.0 "$node_(529) on" 
$node_(530) set X_ 341 
$node_(530) set Y_ 786 
$node_(530) set Z_ 0.0 
$ns at 0.0 "$node_(530) off" 
$ns at 500.0 "$node_(530) on" 
$node_(531) set X_ 146 
$node_(531) set Y_ 983 
$node_(531) set Z_ 0.0 
$ns at 0.0 "$node_(531) off" 
$ns at 500.0 "$node_(531) on" 
$node_(532) set X_ 1045 
$node_(532) set Y_ 487 
$node_(532) set Z_ 0.0 
$ns at 0.0 "$node_(532) off" 
$ns at 500.0 "$node_(532) on" 
$node_(533) set X_ 572 
$node_(533) set Y_ 517 
$node_(533) set Z_ 0.0 
$ns at 0.0 "$node_(533) off" 
$ns at 500.0 "$node_(533) on" 
$node_(534) set X_ 1979 
$node_(534) set Y_ 543 
$node_(534) set Z_ 0.0 
$ns at 0.0 "$node_(534) off" 
$ns at 500.0 "$node_(534) on" 
$node_(535) set X_ 899 
$node_(535) set Y_ 428 
$node_(535) set Z_ 0.0 
$ns at 0.0 "$node_(535) off" 
$ns at 500.0 "$node_(535) on" 
$node_(536) set X_ 1480 
$node_(536) set Y_ 937 
$node_(536) set Z_ 0.0 
$ns at 0.0 "$node_(536) off" 
$ns at 500.0 "$node_(536) on" 
$node_(537) set X_ 971 
$node_(537) set Y_ 256 
$node_(537) set Z_ 0.0 
$ns at 0.0 "$node_(537) off" 
$ns at 500.0 "$node_(537) on" 
$node_(538) set X_ 316 
$node_(538) set Y_ 355 
$node_(538) set Z_ 0.0 
$ns at 0.0 "$node_(538) off" 
$ns at 500.0 "$node_(538) on" 
$node_(539) set X_ 1283 
$node_(539) set Y_ 686 
$node_(539) set Z_ 0.0 
$ns at 0.0 "$node_(539) off" 
$ns at 500.0 "$node_(539) on" 
$node_(540) set X_ 953 
$node_(540) set Y_ 545 
$node_(540) set Z_ 0.0 
$ns at 0.0 "$node_(540) off" 
$ns at 500.0 "$node_(540) on" 
$node_(541) set X_ 2556 
$node_(541) set Y_ 646 
$node_(541) set Z_ 0.0 
$ns at 0.0 "$node_(541) off" 
$ns at 500.0 "$node_(541) on" 
$node_(542) set X_ 405 
$node_(542) set Y_ 100 
$node_(542) set Z_ 0.0 
$ns at 0.0 "$node_(542) off" 
$ns at 500.0 "$node_(542) on" 
$node_(543) set X_ 725 
$node_(543) set Y_ 705 
$node_(543) set Z_ 0.0 
$ns at 0.0 "$node_(543) off" 
$ns at 500.0 "$node_(543) on" 
$node_(544) set X_ 1011 
$node_(544) set Y_ 593 
$node_(544) set Z_ 0.0 
$ns at 0.0 "$node_(544) off" 
$ns at 500.0 "$node_(544) on" 
$node_(545) set X_ 1080 
$node_(545) set Y_ 104 
$node_(545) set Z_ 0.0 
$ns at 0.0 "$node_(545) off" 
$ns at 500.0 "$node_(545) on" 
$node_(546) set X_ 337 
$node_(546) set Y_ 713 
$node_(546) set Z_ 0.0 
$ns at 0.0 "$node_(546) off" 
$ns at 500.0 "$node_(546) on" 
$node_(547) set X_ 1219 
$node_(547) set Y_ 939 
$node_(547) set Z_ 0.0 
$ns at 0.0 "$node_(547) off" 
$ns at 500.0 "$node_(547) on" 
$node_(548) set X_ 2108 
$node_(548) set Y_ 966 
$node_(548) set Z_ 0.0 
$ns at 0.0 "$node_(548) off" 
$ns at 500.0 "$node_(548) on" 
$node_(549) set X_ 2573 
$node_(549) set Y_ 859 
$node_(549) set Z_ 0.0 
$ns at 0.0 "$node_(549) off" 
$ns at 500.0 "$node_(549) on" 
$node_(550) set X_ 2380 
$node_(550) set Y_ 514 
$node_(550) set Z_ 0.0 
$ns at 0.0 "$node_(550) off" 
$ns at 500.0 "$node_(550) on" 
$node_(551) set X_ 2631 
$node_(551) set Y_ 131 
$node_(551) set Z_ 0.0 
$ns at 0.0 "$node_(551) off" 
$ns at 500.0 "$node_(551) on" 
$node_(552) set X_ 264 
$node_(552) set Y_ 942 
$node_(552) set Z_ 0.0 
$ns at 0.0 "$node_(552) off" 
$ns at 500.0 "$node_(552) on" 
$node_(553) set X_ 2543 
$node_(553) set Y_ 93 
$node_(553) set Z_ 0.0 
$ns at 0.0 "$node_(553) off" 
$ns at 500.0 "$node_(553) on" 
$node_(554) set X_ 311 
$node_(554) set Y_ 117 
$node_(554) set Z_ 0.0 
$ns at 0.0 "$node_(554) off" 
$ns at 500.0 "$node_(554) on" 
$node_(555) set X_ 1555 
$node_(555) set Y_ 798 
$node_(555) set Z_ 0.0 
$ns at 0.0 "$node_(555) off" 
$ns at 500.0 "$node_(555) on" 
$node_(556) set X_ 2170 
$node_(556) set Y_ 774 
$node_(556) set Z_ 0.0 
$ns at 0.0 "$node_(556) off" 
$ns at 500.0 "$node_(556) on" 
$node_(557) set X_ 1734 
$node_(557) set Y_ 164 
$node_(557) set Z_ 0.0 
$ns at 0.0 "$node_(557) off" 
$ns at 500.0 "$node_(557) on" 
$node_(558) set X_ 1379 
$node_(558) set Y_ 172 
$node_(558) set Z_ 0.0 
$ns at 0.0 "$node_(558) off" 
$ns at 500.0 "$node_(558) on" 
$node_(559) set X_ 660 
$node_(559) set Y_ 0 
$node_(559) set Z_ 0.0 
$ns at 0.0 "$node_(559) off" 
$ns at 500.0 "$node_(559) on" 
$node_(560) set X_ 2077 
$node_(560) set Y_ 971 
$node_(560) set Z_ 0.0 
$ns at 0.0 "$node_(560) off" 
$ns at 500.0 "$node_(560) on" 
$node_(561) set X_ 1203 
$node_(561) set Y_ 135 
$node_(561) set Z_ 0.0 
$ns at 0.0 "$node_(561) off" 
$ns at 500.0 "$node_(561) on" 
$node_(562) set X_ 1136 
$node_(562) set Y_ 459 
$node_(562) set Z_ 0.0 
$ns at 0.0 "$node_(562) off" 
$ns at 500.0 "$node_(562) on" 
$node_(563) set X_ 142 
$node_(563) set Y_ 235 
$node_(563) set Z_ 0.0 
$ns at 0.0 "$node_(563) off" 
$ns at 500.0 "$node_(563) on" 
$node_(564) set X_ 2553 
$node_(564) set Y_ 408 
$node_(564) set Z_ 0.0 
$ns at 0.0 "$node_(564) off" 
$ns at 500.0 "$node_(564) on" 
$node_(565) set X_ 1269 
$node_(565) set Y_ 51 
$node_(565) set Z_ 0.0 
$ns at 0.0 "$node_(565) off" 
$ns at 500.0 "$node_(565) on" 
$node_(566) set X_ 1090 
$node_(566) set Y_ 118 
$node_(566) set Z_ 0.0 
$ns at 0.0 "$node_(566) off" 
$ns at 500.0 "$node_(566) on" 
$node_(567) set X_ 721 
$node_(567) set Y_ 532 
$node_(567) set Z_ 0.0 
$ns at 0.0 "$node_(567) off" 
$ns at 500.0 "$node_(567) on" 
$node_(568) set X_ 2958 
$node_(568) set Y_ 672 
$node_(568) set Z_ 0.0 
$ns at 0.0 "$node_(568) off" 
$ns at 500.0 "$node_(568) on" 
$node_(569) set X_ 2578 
$node_(569) set Y_ 683 
$node_(569) set Z_ 0.0 
$ns at 0.0 "$node_(569) off" 
$ns at 500.0 "$node_(569) on" 
$node_(570) set X_ 893 
$node_(570) set Y_ 18 
$node_(570) set Z_ 0.0 
$ns at 0.0 "$node_(570) off" 
$ns at 500.0 "$node_(570) on" 
$node_(571) set X_ 301 
$node_(571) set Y_ 80 
$node_(571) set Z_ 0.0 
$ns at 0.0 "$node_(571) off" 
$ns at 500.0 "$node_(571) on" 
$node_(572) set X_ 222 
$node_(572) set Y_ 275 
$node_(572) set Z_ 0.0 
$ns at 0.0 "$node_(572) off" 
$ns at 500.0 "$node_(572) on" 
$node_(573) set X_ 2344 
$node_(573) set Y_ 686 
$node_(573) set Z_ 0.0 
$ns at 0.0 "$node_(573) off" 
$ns at 500.0 "$node_(573) on" 
$node_(574) set X_ 2540 
$node_(574) set Y_ 548 
$node_(574) set Z_ 0.0 
$ns at 0.0 "$node_(574) off" 
$ns at 500.0 "$node_(574) on" 
$node_(575) set X_ 220 
$node_(575) set Y_ 972 
$node_(575) set Z_ 0.0 
$ns at 0.0 "$node_(575) off" 
$ns at 500.0 "$node_(575) on" 
$node_(576) set X_ 2260 
$node_(576) set Y_ 649 
$node_(576) set Z_ 0.0 
$ns at 0.0 "$node_(576) off" 
$ns at 500.0 "$node_(576) on" 
$node_(577) set X_ 516 
$node_(577) set Y_ 387 
$node_(577) set Z_ 0.0 
$ns at 0.0 "$node_(577) off" 
$ns at 500.0 "$node_(577) on" 
$node_(578) set X_ 1782 
$node_(578) set Y_ 334 
$node_(578) set Z_ 0.0 
$ns at 0.0 "$node_(578) off" 
$ns at 500.0 "$node_(578) on" 
$node_(579) set X_ 1728 
$node_(579) set Y_ 897 
$node_(579) set Z_ 0.0 
$ns at 0.0 "$node_(579) off" 
$ns at 500.0 "$node_(579) on" 
$node_(580) set X_ 1123 
$node_(580) set Y_ 38 
$node_(580) set Z_ 0.0 
$ns at 0.0 "$node_(580) off" 
$ns at 500.0 "$node_(580) on" 
$node_(581) set X_ 1425 
$node_(581) set Y_ 654 
$node_(581) set Z_ 0.0 
$ns at 0.0 "$node_(581) off" 
$ns at 500.0 "$node_(581) on" 
$node_(582) set X_ 2721 
$node_(582) set Y_ 674 
$node_(582) set Z_ 0.0 
$ns at 0.0 "$node_(582) off" 
$ns at 500.0 "$node_(582) on" 
$node_(583) set X_ 1107 
$node_(583) set Y_ 863 
$node_(583) set Z_ 0.0 
$ns at 0.0 "$node_(583) off" 
$ns at 500.0 "$node_(583) on" 
$node_(584) set X_ 722 
$node_(584) set Y_ 716 
$node_(584) set Z_ 0.0 
$ns at 0.0 "$node_(584) off" 
$ns at 500.0 "$node_(584) on" 
$node_(585) set X_ 157 
$node_(585) set Y_ 553 
$node_(585) set Z_ 0.0 
$ns at 0.0 "$node_(585) off" 
$ns at 500.0 "$node_(585) on" 
$node_(586) set X_ 2310 
$node_(586) set Y_ 686 
$node_(586) set Z_ 0.0 
$ns at 0.0 "$node_(586) off" 
$ns at 500.0 "$node_(586) on" 
$node_(587) set X_ 1576 
$node_(587) set Y_ 281 
$node_(587) set Z_ 0.0 
$ns at 0.0 "$node_(587) off" 
$ns at 500.0 "$node_(587) on" 
$node_(588) set X_ 2715 
$node_(588) set Y_ 143 
$node_(588) set Z_ 0.0 
$ns at 0.0 "$node_(588) off" 
$ns at 500.0 "$node_(588) on" 
$node_(589) set X_ 712 
$node_(589) set Y_ 756 
$node_(589) set Z_ 0.0 
$ns at 0.0 "$node_(589) off" 
$ns at 500.0 "$node_(589) on" 
$node_(590) set X_ 209 
$node_(590) set Y_ 456 
$node_(590) set Z_ 0.0 
$ns at 0.0 "$node_(590) off" 
$ns at 500.0 "$node_(590) on" 
$node_(591) set X_ 879 
$node_(591) set Y_ 994 
$node_(591) set Z_ 0.0 
$ns at 0.0 "$node_(591) off" 
$ns at 500.0 "$node_(591) on" 
$node_(592) set X_ 1891 
$node_(592) set Y_ 978 
$node_(592) set Z_ 0.0 
$ns at 0.0 "$node_(592) off" 
$ns at 500.0 "$node_(592) on" 
$node_(593) set X_ 2703 
$node_(593) set Y_ 898 
$node_(593) set Z_ 0.0 
$ns at 0.0 "$node_(593) off" 
$ns at 500.0 "$node_(593) on" 
$node_(594) set X_ 221 
$node_(594) set Y_ 696 
$node_(594) set Z_ 0.0 
$ns at 0.0 "$node_(594) off" 
$ns at 500.0 "$node_(594) on" 
$node_(595) set X_ 1230 
$node_(595) set Y_ 80 
$node_(595) set Z_ 0.0 
$ns at 0.0 "$node_(595) off" 
$ns at 500.0 "$node_(595) on" 
$node_(596) set X_ 1147 
$node_(596) set Y_ 83 
$node_(596) set Z_ 0.0 
$ns at 0.0 "$node_(596) off" 
$ns at 500.0 "$node_(596) on" 
$node_(597) set X_ 2128 
$node_(597) set Y_ 350 
$node_(597) set Z_ 0.0 
$ns at 0.0 "$node_(597) off" 
$ns at 500.0 "$node_(597) on" 
$node_(598) set X_ 278 
$node_(598) set Y_ 687 
$node_(598) set Z_ 0.0 
$ns at 0.0 "$node_(598) off" 
$ns at 500.0 "$node_(598) on" 
$node_(599) set X_ 1992 
$node_(599) set Y_ 521 
$node_(599) set Z_ 0.0 
$ns at 0.0 "$node_(599) off" 
$ns at 500.0 "$node_(599) on" 
$node_(600) set X_ 2903 
$node_(600) set Y_ 905 
$node_(600) set Z_ 0.0 
$ns at 0.0 "$node_(600) off" 
$ns at 600.0 "$node_(600) on" 
$node_(601) set X_ 1502 
$node_(601) set Y_ 109 
$node_(601) set Z_ 0.0 
$ns at 0.0 "$node_(601) off" 
$ns at 600.0 "$node_(601) on" 
$node_(602) set X_ 1671 
$node_(602) set Y_ 529 
$node_(602) set Z_ 0.0 
$ns at 0.0 "$node_(602) off" 
$ns at 600.0 "$node_(602) on" 
$node_(603) set X_ 2259 
$node_(603) set Y_ 48 
$node_(603) set Z_ 0.0 
$ns at 0.0 "$node_(603) off" 
$ns at 600.0 "$node_(603) on" 
$node_(604) set X_ 532 
$node_(604) set Y_ 904 
$node_(604) set Z_ 0.0 
$ns at 0.0 "$node_(604) off" 
$ns at 600.0 "$node_(604) on" 
$node_(605) set X_ 1361 
$node_(605) set Y_ 756 
$node_(605) set Z_ 0.0 
$ns at 0.0 "$node_(605) off" 
$ns at 600.0 "$node_(605) on" 
$node_(606) set X_ 18 
$node_(606) set Y_ 951 
$node_(606) set Z_ 0.0 
$ns at 0.0 "$node_(606) off" 
$ns at 600.0 "$node_(606) on" 
$node_(607) set X_ 2232 
$node_(607) set Y_ 772 
$node_(607) set Z_ 0.0 
$ns at 0.0 "$node_(607) off" 
$ns at 600.0 "$node_(607) on" 
$node_(608) set X_ 149 
$node_(608) set Y_ 890 
$node_(608) set Z_ 0.0 
$ns at 0.0 "$node_(608) off" 
$ns at 600.0 "$node_(608) on" 
$node_(609) set X_ 2930 
$node_(609) set Y_ 706 
$node_(609) set Z_ 0.0 
$ns at 0.0 "$node_(609) off" 
$ns at 600.0 "$node_(609) on" 
$node_(610) set X_ 2154 
$node_(610) set Y_ 225 
$node_(610) set Z_ 0.0 
$ns at 0.0 "$node_(610) off" 
$ns at 600.0 "$node_(610) on" 
$node_(611) set X_ 2053 
$node_(611) set Y_ 415 
$node_(611) set Z_ 0.0 
$ns at 0.0 "$node_(611) off" 
$ns at 600.0 "$node_(611) on" 
$node_(612) set X_ 1860 
$node_(612) set Y_ 445 
$node_(612) set Z_ 0.0 
$ns at 0.0 "$node_(612) off" 
$ns at 600.0 "$node_(612) on" 
$node_(613) set X_ 1472 
$node_(613) set Y_ 194 
$node_(613) set Z_ 0.0 
$ns at 0.0 "$node_(613) off" 
$ns at 600.0 "$node_(613) on" 
$node_(614) set X_ 2939 
$node_(614) set Y_ 935 
$node_(614) set Z_ 0.0 
$ns at 0.0 "$node_(614) off" 
$ns at 600.0 "$node_(614) on" 
$node_(615) set X_ 494 
$node_(615) set Y_ 222 
$node_(615) set Z_ 0.0 
$ns at 0.0 "$node_(615) off" 
$ns at 600.0 "$node_(615) on" 
$node_(616) set X_ 2296 
$node_(616) set Y_ 798 
$node_(616) set Z_ 0.0 
$ns at 0.0 "$node_(616) off" 
$ns at 600.0 "$node_(616) on" 
$node_(617) set X_ 1595 
$node_(617) set Y_ 700 
$node_(617) set Z_ 0.0 
$ns at 0.0 "$node_(617) off" 
$ns at 600.0 "$node_(617) on" 
$node_(618) set X_ 669 
$node_(618) set Y_ 629 
$node_(618) set Z_ 0.0 
$ns at 0.0 "$node_(618) off" 
$ns at 600.0 "$node_(618) on" 
$node_(619) set X_ 2645 
$node_(619) set Y_ 896 
$node_(619) set Z_ 0.0 
$ns at 0.0 "$node_(619) off" 
$ns at 600.0 "$node_(619) on" 
$node_(620) set X_ 25 
$node_(620) set Y_ 819 
$node_(620) set Z_ 0.0 
$ns at 0.0 "$node_(620) off" 
$ns at 600.0 "$node_(620) on" 
$node_(621) set X_ 2559 
$node_(621) set Y_ 789 
$node_(621) set Z_ 0.0 
$ns at 0.0 "$node_(621) off" 
$ns at 600.0 "$node_(621) on" 
$node_(622) set X_ 1579 
$node_(622) set Y_ 617 
$node_(622) set Z_ 0.0 
$ns at 0.0 "$node_(622) off" 
$ns at 600.0 "$node_(622) on" 
$node_(623) set X_ 1518 
$node_(623) set Y_ 138 
$node_(623) set Z_ 0.0 
$ns at 0.0 "$node_(623) off" 
$ns at 600.0 "$node_(623) on" 
$node_(624) set X_ 1195 
$node_(624) set Y_ 6 
$node_(624) set Z_ 0.0 
$ns at 0.0 "$node_(624) off" 
$ns at 600.0 "$node_(624) on" 
$node_(625) set X_ 1337 
$node_(625) set Y_ 553 
$node_(625) set Z_ 0.0 
$ns at 0.0 "$node_(625) off" 
$ns at 600.0 "$node_(625) on" 
$node_(626) set X_ 636 
$node_(626) set Y_ 443 
$node_(626) set Z_ 0.0 
$ns at 0.0 "$node_(626) off" 
$ns at 600.0 "$node_(626) on" 
$node_(627) set X_ 1213 
$node_(627) set Y_ 610 
$node_(627) set Z_ 0.0 
$ns at 0.0 "$node_(627) off" 
$ns at 600.0 "$node_(627) on" 
$node_(628) set X_ 2472 
$node_(628) set Y_ 631 
$node_(628) set Z_ 0.0 
$ns at 0.0 "$node_(628) off" 
$ns at 600.0 "$node_(628) on" 
$node_(629) set X_ 1979 
$node_(629) set Y_ 119 
$node_(629) set Z_ 0.0 
$ns at 0.0 "$node_(629) off" 
$ns at 600.0 "$node_(629) on" 
$node_(630) set X_ 1601 
$node_(630) set Y_ 800 
$node_(630) set Z_ 0.0 
$ns at 0.0 "$node_(630) off" 
$ns at 600.0 "$node_(630) on" 
$node_(631) set X_ 42 
$node_(631) set Y_ 416 
$node_(631) set Z_ 0.0 
$ns at 0.0 "$node_(631) off" 
$ns at 600.0 "$node_(631) on" 
$node_(632) set X_ 1147 
$node_(632) set Y_ 423 
$node_(632) set Z_ 0.0 
$ns at 0.0 "$node_(632) off" 
$ns at 600.0 "$node_(632) on" 
$node_(633) set X_ 2543 
$node_(633) set Y_ 941 
$node_(633) set Z_ 0.0 
$ns at 0.0 "$node_(633) off" 
$ns at 600.0 "$node_(633) on" 
$node_(634) set X_ 2058 
$node_(634) set Y_ 890 
$node_(634) set Z_ 0.0 
$ns at 0.0 "$node_(634) off" 
$ns at 600.0 "$node_(634) on" 
$node_(635) set X_ 2773 
$node_(635) set Y_ 436 
$node_(635) set Z_ 0.0 
$ns at 0.0 "$node_(635) off" 
$ns at 600.0 "$node_(635) on" 
$node_(636) set X_ 1966 
$node_(636) set Y_ 436 
$node_(636) set Z_ 0.0 
$ns at 0.0 "$node_(636) off" 
$ns at 600.0 "$node_(636) on" 
$node_(637) set X_ 628 
$node_(637) set Y_ 811 
$node_(637) set Z_ 0.0 
$ns at 0.0 "$node_(637) off" 
$ns at 600.0 "$node_(637) on" 
$node_(638) set X_ 1894 
$node_(638) set Y_ 528 
$node_(638) set Z_ 0.0 
$ns at 0.0 "$node_(638) off" 
$ns at 600.0 "$node_(638) on" 
$node_(639) set X_ 2894 
$node_(639) set Y_ 78 
$node_(639) set Z_ 0.0 
$ns at 0.0 "$node_(639) off" 
$ns at 600.0 "$node_(639) on" 
$node_(640) set X_ 51 
$node_(640) set Y_ 6 
$node_(640) set Z_ 0.0 
$ns at 0.0 "$node_(640) off" 
$ns at 600.0 "$node_(640) on" 
$node_(641) set X_ 2275 
$node_(641) set Y_ 817 
$node_(641) set Z_ 0.0 
$ns at 0.0 "$node_(641) off" 
$ns at 600.0 "$node_(641) on" 
$node_(642) set X_ 1427 
$node_(642) set Y_ 485 
$node_(642) set Z_ 0.0 
$ns at 0.0 "$node_(642) off" 
$ns at 600.0 "$node_(642) on" 
$node_(643) set X_ 2545 
$node_(643) set Y_ 295 
$node_(643) set Z_ 0.0 
$ns at 0.0 "$node_(643) off" 
$ns at 600.0 "$node_(643) on" 
$node_(644) set X_ 986 
$node_(644) set Y_ 930 
$node_(644) set Z_ 0.0 
$ns at 0.0 "$node_(644) off" 
$ns at 600.0 "$node_(644) on" 
$node_(645) set X_ 1783 
$node_(645) set Y_ 695 
$node_(645) set Z_ 0.0 
$ns at 0.0 "$node_(645) off" 
$ns at 600.0 "$node_(645) on" 
$node_(646) set X_ 1163 
$node_(646) set Y_ 850 
$node_(646) set Z_ 0.0 
$ns at 0.0 "$node_(646) off" 
$ns at 600.0 "$node_(646) on" 
$node_(647) set X_ 523 
$node_(647) set Y_ 950 
$node_(647) set Z_ 0.0 
$ns at 0.0 "$node_(647) off" 
$ns at 600.0 "$node_(647) on" 
$node_(648) set X_ 1914 
$node_(648) set Y_ 263 
$node_(648) set Z_ 0.0 
$ns at 0.0 "$node_(648) off" 
$ns at 600.0 "$node_(648) on" 
$node_(649) set X_ 2694 
$node_(649) set Y_ 276 
$node_(649) set Z_ 0.0 
$ns at 0.0 "$node_(649) off" 
$ns at 600.0 "$node_(649) on" 
$node_(650) set X_ 880 
$node_(650) set Y_ 431 
$node_(650) set Z_ 0.0 
$ns at 0.0 "$node_(650) off" 
$ns at 600.0 "$node_(650) on" 
$node_(651) set X_ 2514 
$node_(651) set Y_ 847 
$node_(651) set Z_ 0.0 
$ns at 0.0 "$node_(651) off" 
$ns at 600.0 "$node_(651) on" 
$node_(652) set X_ 2234 
$node_(652) set Y_ 389 
$node_(652) set Z_ 0.0 
$ns at 0.0 "$node_(652) off" 
$ns at 600.0 "$node_(652) on" 
$node_(653) set X_ 997 
$node_(653) set Y_ 4 
$node_(653) set Z_ 0.0 
$ns at 0.0 "$node_(653) off" 
$ns at 600.0 "$node_(653) on" 
$node_(654) set X_ 2520 
$node_(654) set Y_ 457 
$node_(654) set Z_ 0.0 
$ns at 0.0 "$node_(654) off" 
$ns at 600.0 "$node_(654) on" 
$node_(655) set X_ 454 
$node_(655) set Y_ 22 
$node_(655) set Z_ 0.0 
$ns at 0.0 "$node_(655) off" 
$ns at 600.0 "$node_(655) on" 
$node_(656) set X_ 2237 
$node_(656) set Y_ 241 
$node_(656) set Z_ 0.0 
$ns at 0.0 "$node_(656) off" 
$ns at 600.0 "$node_(656) on" 
$node_(657) set X_ 2305 
$node_(657) set Y_ 713 
$node_(657) set Z_ 0.0 
$ns at 0.0 "$node_(657) off" 
$ns at 600.0 "$node_(657) on" 
$node_(658) set X_ 1095 
$node_(658) set Y_ 116 
$node_(658) set Z_ 0.0 
$ns at 0.0 "$node_(658) off" 
$ns at 600.0 "$node_(658) on" 
$node_(659) set X_ 665 
$node_(659) set Y_ 126 
$node_(659) set Z_ 0.0 
$ns at 0.0 "$node_(659) off" 
$ns at 600.0 "$node_(659) on" 
$node_(660) set X_ 2770 
$node_(660) set Y_ 836 
$node_(660) set Z_ 0.0 
$ns at 0.0 "$node_(660) off" 
$ns at 600.0 "$node_(660) on" 
$node_(661) set X_ 1558 
$node_(661) set Y_ 128 
$node_(661) set Z_ 0.0 
$ns at 0.0 "$node_(661) off" 
$ns at 600.0 "$node_(661) on" 
$node_(662) set X_ 2569 
$node_(662) set Y_ 677 
$node_(662) set Z_ 0.0 
$ns at 0.0 "$node_(662) off" 
$ns at 600.0 "$node_(662) on" 
$node_(663) set X_ 1183 
$node_(663) set Y_ 973 
$node_(663) set Z_ 0.0 
$ns at 0.0 "$node_(663) off" 
$ns at 600.0 "$node_(663) on" 
$node_(664) set X_ 1771 
$node_(664) set Y_ 503 
$node_(664) set Z_ 0.0 
$ns at 0.0 "$node_(664) off" 
$ns at 600.0 "$node_(664) on" 
$node_(665) set X_ 1503 
$node_(665) set Y_ 797 
$node_(665) set Z_ 0.0 
$ns at 0.0 "$node_(665) off" 
$ns at 600.0 "$node_(665) on" 
$node_(666) set X_ 440 
$node_(666) set Y_ 233 
$node_(666) set Z_ 0.0 
$ns at 0.0 "$node_(666) off" 
$ns at 600.0 "$node_(666) on" 
$node_(667) set X_ 2408 
$node_(667) set Y_ 595 
$node_(667) set Z_ 0.0 
$ns at 0.0 "$node_(667) off" 
$ns at 600.0 "$node_(667) on" 
$node_(668) set X_ 2263 
$node_(668) set Y_ 454 
$node_(668) set Z_ 0.0 
$ns at 0.0 "$node_(668) off" 
$ns at 600.0 "$node_(668) on" 
$node_(669) set X_ 3 
$node_(669) set Y_ 414 
$node_(669) set Z_ 0.0 
$ns at 0.0 "$node_(669) off" 
$ns at 600.0 "$node_(669) on" 
$node_(670) set X_ 2483 
$node_(670) set Y_ 333 
$node_(670) set Z_ 0.0 
$ns at 0.0 "$node_(670) off" 
$ns at 600.0 "$node_(670) on" 
$node_(671) set X_ 1004 
$node_(671) set Y_ 381 
$node_(671) set Z_ 0.0 
$ns at 0.0 "$node_(671) off" 
$ns at 600.0 "$node_(671) on" 
$node_(672) set X_ 2146 
$node_(672) set Y_ 597 
$node_(672) set Z_ 0.0 
$ns at 0.0 "$node_(672) off" 
$ns at 600.0 "$node_(672) on" 
$node_(673) set X_ 2931 
$node_(673) set Y_ 729 
$node_(673) set Z_ 0.0 
$ns at 0.0 "$node_(673) off" 
$ns at 600.0 "$node_(673) on" 
$node_(674) set X_ 1862 
$node_(674) set Y_ 7 
$node_(674) set Z_ 0.0 
$ns at 0.0 "$node_(674) off" 
$ns at 600.0 "$node_(674) on" 
$node_(675) set X_ 1681 
$node_(675) set Y_ 129 
$node_(675) set Z_ 0.0 
$ns at 0.0 "$node_(675) off" 
$ns at 600.0 "$node_(675) on" 
$node_(676) set X_ 2872 
$node_(676) set Y_ 729 
$node_(676) set Z_ 0.0 
$ns at 0.0 "$node_(676) off" 
$ns at 600.0 "$node_(676) on" 
$node_(677) set X_ 194 
$node_(677) set Y_ 520 
$node_(677) set Z_ 0.0 
$ns at 0.0 "$node_(677) off" 
$ns at 600.0 "$node_(677) on" 
$node_(678) set X_ 589 
$node_(678) set Y_ 973 
$node_(678) set Z_ 0.0 
$ns at 0.0 "$node_(678) off" 
$ns at 600.0 "$node_(678) on" 
$node_(679) set X_ 1270 
$node_(679) set Y_ 102 
$node_(679) set Z_ 0.0 
$ns at 0.0 "$node_(679) off" 
$ns at 600.0 "$node_(679) on" 
$node_(680) set X_ 2865 
$node_(680) set Y_ 509 
$node_(680) set Z_ 0.0 
$ns at 0.0 "$node_(680) off" 
$ns at 600.0 "$node_(680) on" 
$node_(681) set X_ 2148 
$node_(681) set Y_ 312 
$node_(681) set Z_ 0.0 
$ns at 0.0 "$node_(681) off" 
$ns at 600.0 "$node_(681) on" 
$node_(682) set X_ 2029 
$node_(682) set Y_ 36 
$node_(682) set Z_ 0.0 
$ns at 0.0 "$node_(682) off" 
$ns at 600.0 "$node_(682) on" 
$node_(683) set X_ 2244 
$node_(683) set Y_ 416 
$node_(683) set Z_ 0.0 
$ns at 0.0 "$node_(683) off" 
$ns at 600.0 "$node_(683) on" 
$node_(684) set X_ 2237 
$node_(684) set Y_ 845 
$node_(684) set Z_ 0.0 
$ns at 0.0 "$node_(684) off" 
$ns at 600.0 "$node_(684) on" 
$node_(685) set X_ 448 
$node_(685) set Y_ 823 
$node_(685) set Z_ 0.0 
$ns at 0.0 "$node_(685) off" 
$ns at 600.0 "$node_(685) on" 
$node_(686) set X_ 935 
$node_(686) set Y_ 948 
$node_(686) set Z_ 0.0 
$ns at 0.0 "$node_(686) off" 
$ns at 600.0 "$node_(686) on" 
$node_(687) set X_ 2585 
$node_(687) set Y_ 332 
$node_(687) set Z_ 0.0 
$ns at 0.0 "$node_(687) off" 
$ns at 600.0 "$node_(687) on" 
$node_(688) set X_ 1179 
$node_(688) set Y_ 608 
$node_(688) set Z_ 0.0 
$ns at 0.0 "$node_(688) off" 
$ns at 600.0 "$node_(688) on" 
$node_(689) set X_ 97 
$node_(689) set Y_ 320 
$node_(689) set Z_ 0.0 
$ns at 0.0 "$node_(689) off" 
$ns at 600.0 "$node_(689) on" 
$node_(690) set X_ 209 
$node_(690) set Y_ 250 
$node_(690) set Z_ 0.0 
$ns at 0.0 "$node_(690) off" 
$ns at 600.0 "$node_(690) on" 
$node_(691) set X_ 2649 
$node_(691) set Y_ 300 
$node_(691) set Z_ 0.0 
$ns at 0.0 "$node_(691) off" 
$ns at 600.0 "$node_(691) on" 
$node_(692) set X_ 2096 
$node_(692) set Y_ 800 
$node_(692) set Z_ 0.0 
$ns at 0.0 "$node_(692) off" 
$ns at 600.0 "$node_(692) on" 
$node_(693) set X_ 229 
$node_(693) set Y_ 370 
$node_(693) set Z_ 0.0 
$ns at 0.0 "$node_(693) off" 
$ns at 600.0 "$node_(693) on" 
$node_(694) set X_ 365 
$node_(694) set Y_ 868 
$node_(694) set Z_ 0.0 
$ns at 0.0 "$node_(694) off" 
$ns at 600.0 "$node_(694) on" 
$node_(695) set X_ 1434 
$node_(695) set Y_ 834 
$node_(695) set Z_ 0.0 
$ns at 0.0 "$node_(695) off" 
$ns at 600.0 "$node_(695) on" 
$node_(696) set X_ 2324 
$node_(696) set Y_ 576 
$node_(696) set Z_ 0.0 
$ns at 0.0 "$node_(696) off" 
$ns at 600.0 "$node_(696) on" 
$node_(697) set X_ 2897 
$node_(697) set Y_ 662 
$node_(697) set Z_ 0.0 
$ns at 0.0 "$node_(697) off" 
$ns at 600.0 "$node_(697) on" 
$node_(698) set X_ 1404 
$node_(698) set Y_ 478 
$node_(698) set Z_ 0.0 
$ns at 0.0 "$node_(698) off" 
$ns at 600.0 "$node_(698) on" 
$node_(699) set X_ 399 
$node_(699) set Y_ 532 
$node_(699) set Z_ 0.0 
$ns at 0.0 "$node_(699) off" 
$ns at 600.0 "$node_(699) on" 
$node_(700) set X_ 1030 
$node_(700) set Y_ 773 
$node_(700) set Z_ 0.0 
$ns at 0.0 "$node_(700) off" 
$ns at 700.0 "$node_(700) on" 
$node_(701) set X_ 900 
$node_(701) set Y_ 886 
$node_(701) set Z_ 0.0 
$ns at 0.0 "$node_(701) off" 
$ns at 700.0 "$node_(701) on" 
$node_(702) set X_ 577 
$node_(702) set Y_ 914 
$node_(702) set Z_ 0.0 
$ns at 0.0 "$node_(702) off" 
$ns at 700.0 "$node_(702) on" 
$node_(703) set X_ 742 
$node_(703) set Y_ 853 
$node_(703) set Z_ 0.0 
$ns at 0.0 "$node_(703) off" 
$ns at 700.0 "$node_(703) on" 
$node_(704) set X_ 2631 
$node_(704) set Y_ 826 
$node_(704) set Z_ 0.0 
$ns at 0.0 "$node_(704) off" 
$ns at 700.0 "$node_(704) on" 
$node_(705) set X_ 1425 
$node_(705) set Y_ 854 
$node_(705) set Z_ 0.0 
$ns at 0.0 "$node_(705) off" 
$ns at 700.0 "$node_(705) on" 
$node_(706) set X_ 224 
$node_(706) set Y_ 133 
$node_(706) set Z_ 0.0 
$ns at 0.0 "$node_(706) off" 
$ns at 700.0 "$node_(706) on" 
$node_(707) set X_ 1786 
$node_(707) set Y_ 456 
$node_(707) set Z_ 0.0 
$ns at 0.0 "$node_(707) off" 
$ns at 700.0 "$node_(707) on" 
$node_(708) set X_ 2815 
$node_(708) set Y_ 226 
$node_(708) set Z_ 0.0 
$ns at 0.0 "$node_(708) off" 
$ns at 700.0 "$node_(708) on" 
$node_(709) set X_ 2027 
$node_(709) set Y_ 332 
$node_(709) set Z_ 0.0 
$ns at 0.0 "$node_(709) off" 
$ns at 700.0 "$node_(709) on" 
$node_(710) set X_ 1692 
$node_(710) set Y_ 513 
$node_(710) set Z_ 0.0 
$ns at 0.0 "$node_(710) off" 
$ns at 700.0 "$node_(710) on" 
$node_(711) set X_ 2873 
$node_(711) set Y_ 200 
$node_(711) set Z_ 0.0 
$ns at 0.0 "$node_(711) off" 
$ns at 700.0 "$node_(711) on" 
$node_(712) set X_ 1013 
$node_(712) set Y_ 912 
$node_(712) set Z_ 0.0 
$ns at 0.0 "$node_(712) off" 
$ns at 700.0 "$node_(712) on" 
$node_(713) set X_ 1225 
$node_(713) set Y_ 287 
$node_(713) set Z_ 0.0 
$ns at 0.0 "$node_(713) off" 
$ns at 700.0 "$node_(713) on" 
$node_(714) set X_ 1010 
$node_(714) set Y_ 501 
$node_(714) set Z_ 0.0 
$ns at 0.0 "$node_(714) off" 
$ns at 700.0 "$node_(714) on" 
$node_(715) set X_ 2921 
$node_(715) set Y_ 125 
$node_(715) set Z_ 0.0 
$ns at 0.0 "$node_(715) off" 
$ns at 700.0 "$node_(715) on" 
$node_(716) set X_ 2907 
$node_(716) set Y_ 241 
$node_(716) set Z_ 0.0 
$ns at 0.0 "$node_(716) off" 
$ns at 700.0 "$node_(716) on" 
$node_(717) set X_ 749 
$node_(717) set Y_ 508 
$node_(717) set Z_ 0.0 
$ns at 0.0 "$node_(717) off" 
$ns at 700.0 "$node_(717) on" 
$node_(718) set X_ 2811 
$node_(718) set Y_ 877 
$node_(718) set Z_ 0.0 
$ns at 0.0 "$node_(718) off" 
$ns at 700.0 "$node_(718) on" 
$node_(719) set X_ 1552 
$node_(719) set Y_ 11 
$node_(719) set Z_ 0.0 
$ns at 0.0 "$node_(719) off" 
$ns at 700.0 "$node_(719) on" 
$node_(720) set X_ 1315 
$node_(720) set Y_ 426 
$node_(720) set Z_ 0.0 
$ns at 0.0 "$node_(720) off" 
$ns at 700.0 "$node_(720) on" 
$node_(721) set X_ 2208 
$node_(721) set Y_ 799 
$node_(721) set Z_ 0.0 
$ns at 0.0 "$node_(721) off" 
$ns at 700.0 "$node_(721) on" 
$node_(722) set X_ 703 
$node_(722) set Y_ 157 
$node_(722) set Z_ 0.0 
$ns at 0.0 "$node_(722) off" 
$ns at 700.0 "$node_(722) on" 
$node_(723) set X_ 432 
$node_(723) set Y_ 330 
$node_(723) set Z_ 0.0 
$ns at 0.0 "$node_(723) off" 
$ns at 700.0 "$node_(723) on" 
$node_(724) set X_ 2543 
$node_(724) set Y_ 600 
$node_(724) set Z_ 0.0 
$ns at 0.0 "$node_(724) off" 
$ns at 700.0 "$node_(724) on" 
$node_(725) set X_ 1704 
$node_(725) set Y_ 217 
$node_(725) set Z_ 0.0 
$ns at 0.0 "$node_(725) off" 
$ns at 700.0 "$node_(725) on" 
$node_(726) set X_ 2064 
$node_(726) set Y_ 909 
$node_(726) set Z_ 0.0 
$ns at 0.0 "$node_(726) off" 
$ns at 700.0 "$node_(726) on" 
$node_(727) set X_ 1232 
$node_(727) set Y_ 686 
$node_(727) set Z_ 0.0 
$ns at 0.0 "$node_(727) off" 
$ns at 700.0 "$node_(727) on" 
$node_(728) set X_ 1041 
$node_(728) set Y_ 880 
$node_(728) set Z_ 0.0 
$ns at 0.0 "$node_(728) off" 
$ns at 700.0 "$node_(728) on" 
$node_(729) set X_ 1677 
$node_(729) set Y_ 45 
$node_(729) set Z_ 0.0 
$ns at 0.0 "$node_(729) off" 
$ns at 700.0 "$node_(729) on" 
$node_(730) set X_ 1958 
$node_(730) set Y_ 986 
$node_(730) set Z_ 0.0 
$ns at 0.0 "$node_(730) off" 
$ns at 700.0 "$node_(730) on" 
$node_(731) set X_ 365 
$node_(731) set Y_ 67 
$node_(731) set Z_ 0.0 
$ns at 0.0 "$node_(731) off" 
$ns at 700.0 "$node_(731) on" 
$node_(732) set X_ 963 
$node_(732) set Y_ 99 
$node_(732) set Z_ 0.0 
$ns at 0.0 "$node_(732) off" 
$ns at 700.0 "$node_(732) on" 
$node_(733) set X_ 9 
$node_(733) set Y_ 470 
$node_(733) set Z_ 0.0 
$ns at 0.0 "$node_(733) off" 
$ns at 700.0 "$node_(733) on" 
$node_(734) set X_ 663 
$node_(734) set Y_ 967 
$node_(734) set Z_ 0.0 
$ns at 0.0 "$node_(734) off" 
$ns at 700.0 "$node_(734) on" 
$node_(735) set X_ 2390 
$node_(735) set Y_ 498 
$node_(735) set Z_ 0.0 
$ns at 0.0 "$node_(735) off" 
$ns at 700.0 "$node_(735) on" 
$node_(736) set X_ 950 
$node_(736) set Y_ 79 
$node_(736) set Z_ 0.0 
$ns at 0.0 "$node_(736) off" 
$ns at 700.0 "$node_(736) on" 
$node_(737) set X_ 1149 
$node_(737) set Y_ 169 
$node_(737) set Z_ 0.0 
$ns at 0.0 "$node_(737) off" 
$ns at 700.0 "$node_(737) on" 
$node_(738) set X_ 1002 
$node_(738) set Y_ 312 
$node_(738) set Z_ 0.0 
$ns at 0.0 "$node_(738) off" 
$ns at 700.0 "$node_(738) on" 
$node_(739) set X_ 2753 
$node_(739) set Y_ 922 
$node_(739) set Z_ 0.0 
$ns at 0.0 "$node_(739) off" 
$ns at 700.0 "$node_(739) on" 
$node_(740) set X_ 254 
$node_(740) set Y_ 605 
$node_(740) set Z_ 0.0 
$ns at 0.0 "$node_(740) off" 
$ns at 700.0 "$node_(740) on" 
$node_(741) set X_ 1809 
$node_(741) set Y_ 250 
$node_(741) set Z_ 0.0 
$ns at 0.0 "$node_(741) off" 
$ns at 700.0 "$node_(741) on" 
$node_(742) set X_ 452 
$node_(742) set Y_ 995 
$node_(742) set Z_ 0.0 
$ns at 0.0 "$node_(742) off" 
$ns at 700.0 "$node_(742) on" 
$node_(743) set X_ 2251 
$node_(743) set Y_ 386 
$node_(743) set Z_ 0.0 
$ns at 0.0 "$node_(743) off" 
$ns at 700.0 "$node_(743) on" 
$node_(744) set X_ 1019 
$node_(744) set Y_ 485 
$node_(744) set Z_ 0.0 
$ns at 0.0 "$node_(744) off" 
$ns at 700.0 "$node_(744) on" 
$node_(745) set X_ 490 
$node_(745) set Y_ 278 
$node_(745) set Z_ 0.0 
$ns at 0.0 "$node_(745) off" 
$ns at 700.0 "$node_(745) on" 
$node_(746) set X_ 2747 
$node_(746) set Y_ 654 
$node_(746) set Z_ 0.0 
$ns at 0.0 "$node_(746) off" 
$ns at 700.0 "$node_(746) on" 
$node_(747) set X_ 2378 
$node_(747) set Y_ 886 
$node_(747) set Z_ 0.0 
$ns at 0.0 "$node_(747) off" 
$ns at 700.0 "$node_(747) on" 
$node_(748) set X_ 318 
$node_(748) set Y_ 347 
$node_(748) set Z_ 0.0 
$ns at 0.0 "$node_(748) off" 
$ns at 700.0 "$node_(748) on" 
$node_(749) set X_ 2873 
$node_(749) set Y_ 317 
$node_(749) set Z_ 0.0 
$ns at 0.0 "$node_(749) off" 
$ns at 700.0 "$node_(749) on" 
$node_(750) set X_ 2441 
$node_(750) set Y_ 512 
$node_(750) set Z_ 0.0 
$ns at 0.0 "$node_(750) off" 
$ns at 700.0 "$node_(750) on" 
$node_(751) set X_ 457 
$node_(751) set Y_ 416 
$node_(751) set Z_ 0.0 
$ns at 0.0 "$node_(751) off" 
$ns at 700.0 "$node_(751) on" 
$node_(752) set X_ 2288 
$node_(752) set Y_ 62 
$node_(752) set Z_ 0.0 
$ns at 0.0 "$node_(752) off" 
$ns at 700.0 "$node_(752) on" 
$node_(753) set X_ 1856 
$node_(753) set Y_ 215 
$node_(753) set Z_ 0.0 
$ns at 0.0 "$node_(753) off" 
$ns at 700.0 "$node_(753) on" 
$node_(754) set X_ 1635 
$node_(754) set Y_ 588 
$node_(754) set Z_ 0.0 
$ns at 0.0 "$node_(754) off" 
$ns at 700.0 "$node_(754) on" 
$node_(755) set X_ 1209 
$node_(755) set Y_ 95 
$node_(755) set Z_ 0.0 
$ns at 0.0 "$node_(755) off" 
$ns at 700.0 "$node_(755) on" 
$node_(756) set X_ 453 
$node_(756) set Y_ 945 
$node_(756) set Z_ 0.0 
$ns at 0.0 "$node_(756) off" 
$ns at 700.0 "$node_(756) on" 
$node_(757) set X_ 1755 
$node_(757) set Y_ 575 
$node_(757) set Z_ 0.0 
$ns at 0.0 "$node_(757) off" 
$ns at 700.0 "$node_(757) on" 
$node_(758) set X_ 1851 
$node_(758) set Y_ 976 
$node_(758) set Z_ 0.0 
$ns at 0.0 "$node_(758) off" 
$ns at 700.0 "$node_(758) on" 
$node_(759) set X_ 2159 
$node_(759) set Y_ 419 
$node_(759) set Z_ 0.0 
$ns at 0.0 "$node_(759) off" 
$ns at 700.0 "$node_(759) on" 
$node_(760) set X_ 1064 
$node_(760) set Y_ 116 
$node_(760) set Z_ 0.0 
$ns at 0.0 "$node_(760) off" 
$ns at 700.0 "$node_(760) on" 
$node_(761) set X_ 951 
$node_(761) set Y_ 132 
$node_(761) set Z_ 0.0 
$ns at 0.0 "$node_(761) off" 
$ns at 700.0 "$node_(761) on" 
$node_(762) set X_ 1744 
$node_(762) set Y_ 214 
$node_(762) set Z_ 0.0 
$ns at 0.0 "$node_(762) off" 
$ns at 700.0 "$node_(762) on" 
$node_(763) set X_ 1033 
$node_(763) set Y_ 993 
$node_(763) set Z_ 0.0 
$ns at 0.0 "$node_(763) off" 
$ns at 700.0 "$node_(763) on" 
$node_(764) set X_ 64 
$node_(764) set Y_ 683 
$node_(764) set Z_ 0.0 
$ns at 0.0 "$node_(764) off" 
$ns at 700.0 "$node_(764) on" 
$node_(765) set X_ 1014 
$node_(765) set Y_ 480 
$node_(765) set Z_ 0.0 
$ns at 0.0 "$node_(765) off" 
$ns at 700.0 "$node_(765) on" 
$node_(766) set X_ 2146 
$node_(766) set Y_ 994 
$node_(766) set Z_ 0.0 
$ns at 0.0 "$node_(766) off" 
$ns at 700.0 "$node_(766) on" 
$node_(767) set X_ 2050 
$node_(767) set Y_ 312 
$node_(767) set Z_ 0.0 
$ns at 0.0 "$node_(767) off" 
$ns at 700.0 "$node_(767) on" 
$node_(768) set X_ 1002 
$node_(768) set Y_ 621 
$node_(768) set Z_ 0.0 
$ns at 0.0 "$node_(768) off" 
$ns at 700.0 "$node_(768) on" 
$node_(769) set X_ 79 
$node_(769) set Y_ 367 
$node_(769) set Z_ 0.0 
$ns at 0.0 "$node_(769) off" 
$ns at 700.0 "$node_(769) on" 
$node_(770) set X_ 2627 
$node_(770) set Y_ 755 
$node_(770) set Z_ 0.0 
$ns at 0.0 "$node_(770) off" 
$ns at 700.0 "$node_(770) on" 
$node_(771) set X_ 1759 
$node_(771) set Y_ 427 
$node_(771) set Z_ 0.0 
$ns at 0.0 "$node_(771) off" 
$ns at 700.0 "$node_(771) on" 
$node_(772) set X_ 2992 
$node_(772) set Y_ 514 
$node_(772) set Z_ 0.0 
$ns at 0.0 "$node_(772) off" 
$ns at 700.0 "$node_(772) on" 
$node_(773) set X_ 992 
$node_(773) set Y_ 7 
$node_(773) set Z_ 0.0 
$ns at 0.0 "$node_(773) off" 
$ns at 700.0 "$node_(773) on" 
$node_(774) set X_ 1564 
$node_(774) set Y_ 912 
$node_(774) set Z_ 0.0 
$ns at 0.0 "$node_(774) off" 
$ns at 700.0 "$node_(774) on" 
$node_(775) set X_ 1825 
$node_(775) set Y_ 584 
$node_(775) set Z_ 0.0 
$ns at 0.0 "$node_(775) off" 
$ns at 700.0 "$node_(775) on" 
$node_(776) set X_ 2559 
$node_(776) set Y_ 533 
$node_(776) set Z_ 0.0 
$ns at 0.0 "$node_(776) off" 
$ns at 700.0 "$node_(776) on" 
$node_(777) set X_ 2520 
$node_(777) set Y_ 121 
$node_(777) set Z_ 0.0 
$ns at 0.0 "$node_(777) off" 
$ns at 700.0 "$node_(777) on" 
$node_(778) set X_ 408 
$node_(778) set Y_ 751 
$node_(778) set Z_ 0.0 
$ns at 0.0 "$node_(778) off" 
$ns at 700.0 "$node_(778) on" 
$node_(779) set X_ 914 
$node_(779) set Y_ 158 
$node_(779) set Z_ 0.0 
$ns at 0.0 "$node_(779) off" 
$ns at 700.0 "$node_(779) on" 
$node_(780) set X_ 2958 
$node_(780) set Y_ 308 
$node_(780) set Z_ 0.0 
$ns at 0.0 "$node_(780) off" 
$ns at 700.0 "$node_(780) on" 
$node_(781) set X_ 2644 
$node_(781) set Y_ 661 
$node_(781) set Z_ 0.0 
$ns at 0.0 "$node_(781) off" 
$ns at 700.0 "$node_(781) on" 
$node_(782) set X_ 1642 
$node_(782) set Y_ 255 
$node_(782) set Z_ 0.0 
$ns at 0.0 "$node_(782) off" 
$ns at 700.0 "$node_(782) on" 
$node_(783) set X_ 2582 
$node_(783) set Y_ 468 
$node_(783) set Z_ 0.0 
$ns at 0.0 "$node_(783) off" 
$ns at 700.0 "$node_(783) on" 
$node_(784) set X_ 1312 
$node_(784) set Y_ 589 
$node_(784) set Z_ 0.0 
$ns at 0.0 "$node_(784) off" 
$ns at 700.0 "$node_(784) on" 
$node_(785) set X_ 1704 
$node_(785) set Y_ 430 
$node_(785) set Z_ 0.0 
$ns at 0.0 "$node_(785) off" 
$ns at 700.0 "$node_(785) on" 
$node_(786) set X_ 2614 
$node_(786) set Y_ 379 
$node_(786) set Z_ 0.0 
$ns at 0.0 "$node_(786) off" 
$ns at 700.0 "$node_(786) on" 
$node_(787) set X_ 1820 
$node_(787) set Y_ 309 
$node_(787) set Z_ 0.0 
$ns at 0.0 "$node_(787) off" 
$ns at 700.0 "$node_(787) on" 
$node_(788) set X_ 2642 
$node_(788) set Y_ 832 
$node_(788) set Z_ 0.0 
$ns at 0.0 "$node_(788) off" 
$ns at 700.0 "$node_(788) on" 
$node_(789) set X_ 2940 
$node_(789) set Y_ 42 
$node_(789) set Z_ 0.0 
$ns at 0.0 "$node_(789) off" 
$ns at 700.0 "$node_(789) on" 
$node_(790) set X_ 240 
$node_(790) set Y_ 544 
$node_(790) set Z_ 0.0 
$ns at 0.0 "$node_(790) off" 
$ns at 700.0 "$node_(790) on" 
$node_(791) set X_ 652 
$node_(791) set Y_ 278 
$node_(791) set Z_ 0.0 
$ns at 0.0 "$node_(791) off" 
$ns at 700.0 "$node_(791) on" 
$node_(792) set X_ 2656 
$node_(792) set Y_ 106 
$node_(792) set Z_ 0.0 
$ns at 0.0 "$node_(792) off" 
$ns at 700.0 "$node_(792) on" 
$node_(793) set X_ 2696 
$node_(793) set Y_ 947 
$node_(793) set Z_ 0.0 
$ns at 0.0 "$node_(793) off" 
$ns at 700.0 "$node_(793) on" 
$node_(794) set X_ 1264 
$node_(794) set Y_ 378 
$node_(794) set Z_ 0.0 
$ns at 0.0 "$node_(794) off" 
$ns at 700.0 "$node_(794) on" 
$node_(795) set X_ 1952 
$node_(795) set Y_ 229 
$node_(795) set Z_ 0.0 
$ns at 0.0 "$node_(795) off" 
$ns at 700.0 "$node_(795) on" 
$node_(796) set X_ 1865 
$node_(796) set Y_ 977 
$node_(796) set Z_ 0.0 
$ns at 0.0 "$node_(796) off" 
$ns at 700.0 "$node_(796) on" 
$node_(797) set X_ 2312 
$node_(797) set Y_ 461 
$node_(797) set Z_ 0.0 
$ns at 0.0 "$node_(797) off" 
$ns at 700.0 "$node_(797) on" 
$node_(798) set X_ 562 
$node_(798) set Y_ 959 
$node_(798) set Z_ 0.0 
$ns at 0.0 "$node_(798) off" 
$ns at 700.0 "$node_(798) on" 
$node_(799) set X_ 362 
$node_(799) set Y_ 434 
$node_(799) set Z_ 0.0 
$ns at 0.0 "$node_(799) off" 
$ns at 700.0 "$node_(799) on" 

# Generation of movements
$ns at 0.0 "$node_(0) setdest 11651 7866 17.0" 
$ns at 33.32124085905267 "$node_(0) setdest 53520 2926 13.0" 
$ns at 101.10999976107084 "$node_(0) setdest 44622 22592 11.0" 
$ns at 142.7990314269803 "$node_(0) setdest 52633 12113 2.0" 
$ns at 185.82963467561808 "$node_(0) setdest 68867 13720 18.0" 
$ns at 317.7854419092995 "$node_(0) setdest 34491 7003 7.0" 
$ns at 355.3581720708883 "$node_(0) setdest 186809 18913 16.0" 
$ns at 426.871037818369 "$node_(0) setdest 124907 18737 14.0" 
$ns at 571.000329043779 "$node_(0) setdest 29953 34429 11.0" 
$ns at 629.6190762695638 "$node_(0) setdest 156504 9036 3.0" 
$ns at 680.1095781389354 "$node_(0) setdest 51455 16969 15.0" 
$ns at 719.7680069321343 "$node_(0) setdest 191912 3375 18.0" 
$ns at 753.8839334775844 "$node_(0) setdest 127546 39940 10.0" 
$ns at 834.5188493503313 "$node_(0) setdest 8252 9088 1.0" 
$ns at 874.2778293420357 "$node_(0) setdest 146703 26116 18.0" 
$ns at 0.0 "$node_(1) setdest 25274 29842 15.0" 
$ns at 76.22687115239513 "$node_(1) setdest 16622 30043 5.0" 
$ns at 142.48840935972447 "$node_(1) setdest 5353 947 2.0" 
$ns at 180.56464228088808 "$node_(1) setdest 120518 33110 2.0" 
$ns at 230.04650639939234 "$node_(1) setdest 113885 36237 7.0" 
$ns at 297.7156331467122 "$node_(1) setdest 17741 36398 4.0" 
$ns at 345.0748822979691 "$node_(1) setdest 40090 47186 7.0" 
$ns at 428.4864846220928 "$node_(1) setdest 81161 11478 13.0" 
$ns at 496.8200469022469 "$node_(1) setdest 209525 19236 12.0" 
$ns at 645.1882705720409 "$node_(1) setdest 117819 6273 8.0" 
$ns at 725.5582107899993 "$node_(1) setdest 102312 66095 16.0" 
$ns at 768.0161022042967 "$node_(1) setdest 159878 53555 1.0" 
$ns at 798.9195847642051 "$node_(1) setdest 75139 45093 18.0" 
$ns at 843.7787621636114 "$node_(1) setdest 137870 15063 15.0" 
$ns at 0.0 "$node_(2) setdest 34747 2458 15.0" 
$ns at 161.29348567193503 "$node_(2) setdest 117523 20310 8.0" 
$ns at 239.74866941747848 "$node_(2) setdest 14295 35953 10.0" 
$ns at 353.4454495708512 "$node_(2) setdest 130734 35375 11.0" 
$ns at 413.3907919576333 "$node_(2) setdest 39765 219 14.0" 
$ns at 497.32550858786294 "$node_(2) setdest 144571 39242 16.0" 
$ns at 546.606951398262 "$node_(2) setdest 26791 37679 3.0" 
$ns at 589.8553613742174 "$node_(2) setdest 227893 56010 2.0" 
$ns at 635.2584118622608 "$node_(2) setdest 150117 32818 7.0" 
$ns at 676.9333849190878 "$node_(2) setdest 250979 13305 7.0" 
$ns at 746.9772087853092 "$node_(2) setdest 25880 77130 6.0" 
$ns at 809.7696635315407 "$node_(2) setdest 174257 56145 19.0" 
$ns at 0.0 "$node_(3) setdest 88499 14132 12.0" 
$ns at 109.19641154658193 "$node_(3) setdest 22194 25869 18.0" 
$ns at 270.4513053397888 "$node_(3) setdest 92717 13147 6.0" 
$ns at 343.18294065488385 "$node_(3) setdest 106903 21362 12.0" 
$ns at 470.953883426278 "$node_(3) setdest 188474 51022 14.0" 
$ns at 523.8552193944857 "$node_(3) setdest 159076 32481 18.0" 
$ns at 628.9466182291227 "$node_(3) setdest 183830 64006 12.0" 
$ns at 723.4455902591814 "$node_(3) setdest 244395 34619 1.0" 
$ns at 761.3631885281226 "$node_(3) setdest 130486 74862 20.0" 
$ns at 0.0 "$node_(4) setdest 60042 6509 9.0" 
$ns at 56.385105779956824 "$node_(4) setdest 60869 15334 15.0" 
$ns at 230.93860432835424 "$node_(4) setdest 58838 23099 4.0" 
$ns at 261.0972087462451 "$node_(4) setdest 87266 18498 15.0" 
$ns at 371.70228759313534 "$node_(4) setdest 28323 27467 12.0" 
$ns at 482.41353427123386 "$node_(4) setdest 149629 52579 3.0" 
$ns at 520.0343980459868 "$node_(4) setdest 95181 38487 14.0" 
$ns at 573.5196842479892 "$node_(4) setdest 213122 65932 15.0" 
$ns at 612.3419159566075 "$node_(4) setdest 96617 44292 6.0" 
$ns at 696.7154534707206 "$node_(4) setdest 72764 39779 3.0" 
$ns at 731.1901235721472 "$node_(4) setdest 50618 81569 5.0" 
$ns at 809.250057053855 "$node_(4) setdest 259876 74090 2.0" 
$ns at 855.8317668740808 "$node_(4) setdest 208235 11693 17.0" 
$ns at 0.0 "$node_(5) setdest 70179 12143 7.0" 
$ns at 78.8834061882995 "$node_(5) setdest 81254 300 9.0" 
$ns at 191.22083236646188 "$node_(5) setdest 48472 17807 1.0" 
$ns at 221.30312093778616 "$node_(5) setdest 51519 21542 13.0" 
$ns at 333.73277344044624 "$node_(5) setdest 96472 46629 12.0" 
$ns at 395.70474437994903 "$node_(5) setdest 29981 41235 6.0" 
$ns at 431.9044506711663 "$node_(5) setdest 24271 52799 9.0" 
$ns at 499.93498586469786 "$node_(5) setdest 104842 61166 3.0" 
$ns at 533.2798807725059 "$node_(5) setdest 7353 45948 3.0" 
$ns at 569.7807090694575 "$node_(5) setdest 4276 21485 18.0" 
$ns at 624.5434599899262 "$node_(5) setdest 56585 10725 9.0" 
$ns at 701.5978905405708 "$node_(5) setdest 240838 11743 19.0" 
$ns at 735.2489274450161 "$node_(5) setdest 67887 1411 5.0" 
$ns at 803.7132070256829 "$node_(5) setdest 149083 16810 3.0" 
$ns at 862.4547911531772 "$node_(5) setdest 78938 20507 12.0" 
$ns at 0.0 "$node_(6) setdest 41297 24498 10.0" 
$ns at 111.87051757787557 "$node_(6) setdest 10891 18758 3.0" 
$ns at 157.9394850574289 "$node_(6) setdest 11922 29419 9.0" 
$ns at 271.5170693168943 "$node_(6) setdest 119549 13953 10.0" 
$ns at 395.08682653890025 "$node_(6) setdest 150128 35954 15.0" 
$ns at 550.4614817802965 "$node_(6) setdest 115979 56089 13.0" 
$ns at 610.1704439870866 "$node_(6) setdest 137402 74823 7.0" 
$ns at 691.3601387140063 "$node_(6) setdest 46446 42684 8.0" 
$ns at 789.8646442703498 "$node_(6) setdest 61635 55479 5.0" 
$ns at 844.5361111832641 "$node_(6) setdest 74290 55840 17.0" 
$ns at 882.703311040035 "$node_(6) setdest 26673 82024 7.0" 
$ns at 0.0 "$node_(7) setdest 39507 14943 2.0" 
$ns at 31.51289759366755 "$node_(7) setdest 58006 929 6.0" 
$ns at 67.19252763901918 "$node_(7) setdest 82221 28645 3.0" 
$ns at 104.48768277500534 "$node_(7) setdest 55001 11108 14.0" 
$ns at 151.92015092095738 "$node_(7) setdest 37072 20021 17.0" 
$ns at 341.948289268135 "$node_(7) setdest 80215 45847 16.0" 
$ns at 477.09172802217313 "$node_(7) setdest 48201 68539 6.0" 
$ns at 528.0510447375012 "$node_(7) setdest 159653 10017 1.0" 
$ns at 567.3762785707746 "$node_(7) setdest 70318 25612 11.0" 
$ns at 665.1167150443173 "$node_(7) setdest 85903 59045 16.0" 
$ns at 742.7789652936095 "$node_(7) setdest 166720 63460 17.0" 
$ns at 875.0396420544747 "$node_(7) setdest 99951 16140 4.0" 
$ns at 0.0 "$node_(8) setdest 35774 30970 17.0" 
$ns at 117.53890120757319 "$node_(8) setdest 50595 26461 19.0" 
$ns at 274.64305288420115 "$node_(8) setdest 159329 20715 1.0" 
$ns at 304.87809599782094 "$node_(8) setdest 76578 46723 7.0" 
$ns at 352.6332126867479 "$node_(8) setdest 183679 44376 15.0" 
$ns at 483.4878635812767 "$node_(8) setdest 95898 44284 9.0" 
$ns at 598.4503735532264 "$node_(8) setdest 91252 5835 2.0" 
$ns at 642.2981993631304 "$node_(8) setdest 6188 38789 5.0" 
$ns at 707.7629385358371 "$node_(8) setdest 114182 29738 18.0" 
$ns at 833.131010545175 "$node_(8) setdest 102225 50033 5.0" 
$ns at 0.0 "$node_(9) setdest 89458 2630 19.0" 
$ns at 159.08440558817549 "$node_(9) setdest 89379 16617 13.0" 
$ns at 318.36977291606297 "$node_(9) setdest 5705 30802 12.0" 
$ns at 426.732289094899 "$node_(9) setdest 106640 53296 7.0" 
$ns at 476.52810697666456 "$node_(9) setdest 111519 58639 7.0" 
$ns at 518.1555895683506 "$node_(9) setdest 153579 39548 16.0" 
$ns at 650.276915555956 "$node_(9) setdest 178460 44721 3.0" 
$ns at 706.4796588082437 "$node_(9) setdest 243890 23005 14.0" 
$ns at 861.1991912683532 "$node_(9) setdest 109700 559 19.0" 
$ns at 0.0 "$node_(10) setdest 31536 13626 11.0" 
$ns at 38.244017900717985 "$node_(10) setdest 82005 460 9.0" 
$ns at 100.26501270385128 "$node_(10) setdest 28696 27077 19.0" 
$ns at 191.06692423770355 "$node_(10) setdest 70073 271 17.0" 
$ns at 364.8460599263805 "$node_(10) setdest 178344 2675 3.0" 
$ns at 396.2512718024783 "$node_(10) setdest 171794 52431 10.0" 
$ns at 435.39866866915366 "$node_(10) setdest 123735 40175 16.0" 
$ns at 533.600478917543 "$node_(10) setdest 18940 15380 3.0" 
$ns at 577.4644005291326 "$node_(10) setdest 183795 3267 5.0" 
$ns at 622.833745723645 "$node_(10) setdest 118332 43000 6.0" 
$ns at 671.8864419549819 "$node_(10) setdest 105250 24654 9.0" 
$ns at 708.4072315981475 "$node_(10) setdest 22472 57486 3.0" 
$ns at 765.0556248310905 "$node_(10) setdest 231436 50480 16.0" 
$ns at 815.0967430123707 "$node_(10) setdest 250171 71609 10.0" 
$ns at 881.2617037316031 "$node_(10) setdest 243275 87250 10.0" 
$ns at 0.0 "$node_(11) setdest 5179 20334 1.0" 
$ns at 37.556262641642085 "$node_(11) setdest 71973 19237 1.0" 
$ns at 68.4481644155284 "$node_(11) setdest 86484 18878 15.0" 
$ns at 160.35005319277172 "$node_(11) setdest 17516 37510 15.0" 
$ns at 201.26584847660814 "$node_(11) setdest 93278 17110 9.0" 
$ns at 248.8681663359517 "$node_(11) setdest 8196 18240 9.0" 
$ns at 343.09350698345645 "$node_(11) setdest 105996 22231 15.0" 
$ns at 480.6750681858085 "$node_(11) setdest 71802 61257 17.0" 
$ns at 513.7850331022586 "$node_(11) setdest 182616 1617 8.0" 
$ns at 558.6954279004456 "$node_(11) setdest 148092 22332 19.0" 
$ns at 654.2551649521242 "$node_(11) setdest 89026 20010 11.0" 
$ns at 761.4451930618211 "$node_(11) setdest 196603 35712 10.0" 
$ns at 803.8803799852986 "$node_(11) setdest 88752 54966 6.0" 
$ns at 838.4220587491236 "$node_(11) setdest 108824 45786 12.0" 
$ns at 0.0 "$node_(12) setdest 88365 12386 3.0" 
$ns at 45.61881961202481 "$node_(12) setdest 85522 28944 12.0" 
$ns at 127.56812068822686 "$node_(12) setdest 88962 3769 15.0" 
$ns at 274.42264721677077 "$node_(12) setdest 9387 33486 19.0" 
$ns at 441.10504615046045 "$node_(12) setdest 30790 18199 1.0" 
$ns at 476.40508701605324 "$node_(12) setdest 96986 38439 5.0" 
$ns at 521.7151775426587 "$node_(12) setdest 111051 53011 11.0" 
$ns at 568.6441262993939 "$node_(12) setdest 54654 55143 18.0" 
$ns at 721.8241061731788 "$node_(12) setdest 9777 78707 1.0" 
$ns at 753.6962693113111 "$node_(12) setdest 102335 73237 2.0" 
$ns at 785.1634439882704 "$node_(12) setdest 60682 15571 18.0" 
$ns at 824.1240648716758 "$node_(12) setdest 180079 30528 19.0" 
$ns at 857.6748625681006 "$node_(12) setdest 174207 47047 5.0" 
$ns at 0.0 "$node_(13) setdest 54732 5458 3.0" 
$ns at 36.83510451371183 "$node_(13) setdest 56898 2611 12.0" 
$ns at 130.89804338040767 "$node_(13) setdest 73766 7229 5.0" 
$ns at 178.5383955231042 "$node_(13) setdest 20104 25361 19.0" 
$ns at 238.70490931904214 "$node_(13) setdest 17076 29689 11.0" 
$ns at 343.02220511133675 "$node_(13) setdest 10834 33837 15.0" 
$ns at 491.9025680484066 "$node_(13) setdest 42154 41771 12.0" 
$ns at 630.3781207828068 "$node_(13) setdest 74730 18213 1.0" 
$ns at 669.8900134654573 "$node_(13) setdest 191411 37419 17.0" 
$ns at 790.6973560506848 "$node_(13) setdest 52965 15072 17.0" 
$ns at 856.1842265958041 "$node_(13) setdest 219361 36452 16.0" 
$ns at 0.0 "$node_(14) setdest 19585 8275 2.0" 
$ns at 32.54392229108394 "$node_(14) setdest 3139 15169 9.0" 
$ns at 150.9441246139336 "$node_(14) setdest 44757 1185 8.0" 
$ns at 190.1463513389246 "$node_(14) setdest 96584 8286 14.0" 
$ns at 336.7744438056533 "$node_(14) setdest 53689 52836 6.0" 
$ns at 369.5533351650192 "$node_(14) setdest 130769 61065 7.0" 
$ns at 445.7778116250728 "$node_(14) setdest 5399 25719 10.0" 
$ns at 548.016757582559 "$node_(14) setdest 130697 50069 7.0" 
$ns at 626.3769153738588 "$node_(14) setdest 229195 68766 12.0" 
$ns at 717.3536084150437 "$node_(14) setdest 193022 3314 3.0" 
$ns at 751.0200417961064 "$node_(14) setdest 222703 29560 10.0" 
$ns at 853.5156039974183 "$node_(14) setdest 58778 24861 8.0" 
$ns at 0.0 "$node_(15) setdest 14578 17487 18.0" 
$ns at 143.82628944909538 "$node_(15) setdest 84670 5978 7.0" 
$ns at 232.39763712908453 "$node_(15) setdest 119670 39037 6.0" 
$ns at 267.2211771478322 "$node_(15) setdest 13078 51642 1.0" 
$ns at 300.8735041760117 "$node_(15) setdest 70222 45270 15.0" 
$ns at 355.5671348951921 "$node_(15) setdest 49892 57731 18.0" 
$ns at 428.9372996134697 "$node_(15) setdest 174159 17211 17.0" 
$ns at 538.1767256119066 "$node_(15) setdest 80394 15082 9.0" 
$ns at 572.0229435713163 "$node_(15) setdest 135503 30821 9.0" 
$ns at 665.7473580546957 "$node_(15) setdest 219721 10036 19.0" 
$ns at 761.0465945116754 "$node_(15) setdest 251306 36050 2.0" 
$ns at 809.2720623733617 "$node_(15) setdest 47838 68597 20.0" 
$ns at 0.0 "$node_(16) setdest 19278 27590 8.0" 
$ns at 60.4547602219509 "$node_(16) setdest 40979 24223 1.0" 
$ns at 94.25485699974826 "$node_(16) setdest 38894 3599 6.0" 
$ns at 130.5265784989156 "$node_(16) setdest 59273 20293 12.0" 
$ns at 185.1011691662186 "$node_(16) setdest 119108 43695 6.0" 
$ns at 239.0190966882655 "$node_(16) setdest 62309 10176 8.0" 
$ns at 270.337296180082 "$node_(16) setdest 28460 50699 19.0" 
$ns at 467.0807642441974 "$node_(16) setdest 130581 29494 16.0" 
$ns at 564.6592591706018 "$node_(16) setdest 127395 29360 17.0" 
$ns at 609.1084176578739 "$node_(16) setdest 38036 70897 9.0" 
$ns at 693.7484423562696 "$node_(16) setdest 177260 49867 14.0" 
$ns at 774.7905284914393 "$node_(16) setdest 112129 79041 8.0" 
$ns at 869.4597683013873 "$node_(16) setdest 75812 55322 5.0" 
$ns at 0.0 "$node_(17) setdest 39487 19768 20.0" 
$ns at 30.04326426533252 "$node_(17) setdest 22566 1426 2.0" 
$ns at 66.78541060644037 "$node_(17) setdest 70850 22171 11.0" 
$ns at 150.84951798705754 "$node_(17) setdest 44649 29249 20.0" 
$ns at 245.7506222401352 "$node_(17) setdest 73497 5716 2.0" 
$ns at 283.6696017473238 "$node_(17) setdest 29864 7961 6.0" 
$ns at 326.57980613392397 "$node_(17) setdest 131428 29800 5.0" 
$ns at 365.6488367634343 "$node_(17) setdest 118508 32967 19.0" 
$ns at 414.70191774720695 "$node_(17) setdest 51978 31412 13.0" 
$ns at 542.8094622062363 "$node_(17) setdest 85754 61847 15.0" 
$ns at 610.8883359835714 "$node_(17) setdest 173907 18354 14.0" 
$ns at 751.4667388051301 "$node_(17) setdest 104251 54130 6.0" 
$ns at 840.7511255330295 "$node_(17) setdest 95944 60253 1.0" 
$ns at 873.3121065175573 "$node_(17) setdest 221236 29735 8.0" 
$ns at 0.0 "$node_(18) setdest 17690 11900 12.0" 
$ns at 72.34885728899779 "$node_(18) setdest 34505 809 18.0" 
$ns at 261.1927575580148 "$node_(18) setdest 77832 42378 5.0" 
$ns at 306.6524622668177 "$node_(18) setdest 139086 6539 9.0" 
$ns at 368.9942028330429 "$node_(18) setdest 6914 59583 15.0" 
$ns at 512.0341139706378 "$node_(18) setdest 17688 44946 12.0" 
$ns at 635.6455571713675 "$node_(18) setdest 181498 48602 17.0" 
$ns at 769.8376225915467 "$node_(18) setdest 32981 51884 4.0" 
$ns at 809.9464730203822 "$node_(18) setdest 110450 35483 7.0" 
$ns at 892.1358053111289 "$node_(18) setdest 199209 11971 15.0" 
$ns at 0.0 "$node_(19) setdest 66495 1960 13.0" 
$ns at 129.78477444955752 "$node_(19) setdest 14390 12942 11.0" 
$ns at 221.78795502582355 "$node_(19) setdest 125584 34558 9.0" 
$ns at 321.7548497291788 "$node_(19) setdest 24148 43237 16.0" 
$ns at 422.8177130193751 "$node_(19) setdest 76419 26577 11.0" 
$ns at 555.9225538253701 "$node_(19) setdest 47322 9382 15.0" 
$ns at 687.1915611274007 "$node_(19) setdest 5335 20809 14.0" 
$ns at 733.6958395198811 "$node_(19) setdest 61777 23484 6.0" 
$ns at 778.5592526961759 "$node_(19) setdest 133372 73186 9.0" 
$ns at 814.224547506947 "$node_(19) setdest 22258 78894 13.0" 
$ns at 0.0 "$node_(20) setdest 56924 22552 7.0" 
$ns at 84.72612147219635 "$node_(20) setdest 70735 4648 15.0" 
$ns at 150.21496450000984 "$node_(20) setdest 58369 28672 15.0" 
$ns at 199.09532304662292 "$node_(20) setdest 29412 9238 7.0" 
$ns at 262.7793166646343 "$node_(20) setdest 134296 44757 5.0" 
$ns at 330.61613068760124 "$node_(20) setdest 49860 19376 13.0" 
$ns at 461.29536141261497 "$node_(20) setdest 24550 54942 13.0" 
$ns at 616.4411400228107 "$node_(20) setdest 137514 1277 19.0" 
$ns at 650.0020046750514 "$node_(20) setdest 44659 1240 1.0" 
$ns at 680.3074996209756 "$node_(20) setdest 202729 39390 17.0" 
$ns at 820.851507911083 "$node_(20) setdest 53540 7981 7.0" 
$ns at 859.9839999605613 "$node_(20) setdest 264520 50404 5.0" 
$ns at 0.0 "$node_(21) setdest 61820 2924 1.0" 
$ns at 39.196510479851874 "$node_(21) setdest 22414 30488 15.0" 
$ns at 87.53913899315674 "$node_(21) setdest 59707 19835 19.0" 
$ns at 178.93944727755763 "$node_(21) setdest 10843 31979 5.0" 
$ns at 218.0765539669389 "$node_(21) setdest 31521 30666 7.0" 
$ns at 261.9408245394626 "$node_(21) setdest 98380 5515 3.0" 
$ns at 303.5817115680021 "$node_(21) setdest 141068 4119 18.0" 
$ns at 484.4768044141334 "$node_(21) setdest 184727 7301 9.0" 
$ns at 549.491306750962 "$node_(21) setdest 99713 20157 1.0" 
$ns at 584.7638057074207 "$node_(21) setdest 106905 74887 13.0" 
$ns at 742.1468123020554 "$node_(21) setdest 71677 78588 13.0" 
$ns at 849.4808888029498 "$node_(21) setdest 245975 57000 8.0" 
$ns at 0.0 "$node_(22) setdest 39931 7262 7.0" 
$ns at 78.07319955879771 "$node_(22) setdest 51854 3144 12.0" 
$ns at 178.45267179842227 "$node_(22) setdest 53194 43520 14.0" 
$ns at 236.70087804005465 "$node_(22) setdest 124860 39315 13.0" 
$ns at 348.2811521871482 "$node_(22) setdest 99601 10375 6.0" 
$ns at 384.61763365103036 "$node_(22) setdest 177201 14624 20.0" 
$ns at 574.645960213299 "$node_(22) setdest 26389 26453 15.0" 
$ns at 691.212462765503 "$node_(22) setdest 48331 65462 1.0" 
$ns at 728.4462423596297 "$node_(22) setdest 97690 53162 13.0" 
$ns at 783.7271954748327 "$node_(22) setdest 85001 57988 13.0" 
$ns at 851.3733061254147 "$node_(22) setdest 228491 1996 19.0" 
$ns at 0.0 "$node_(23) setdest 28310 9318 14.0" 
$ns at 148.35485359614114 "$node_(23) setdest 30863 25250 7.0" 
$ns at 246.8597050872466 "$node_(23) setdest 115513 29600 10.0" 
$ns at 366.7532654621105 "$node_(23) setdest 148121 59892 3.0" 
$ns at 409.44031175125315 "$node_(23) setdest 140565 20412 15.0" 
$ns at 504.73542517814667 "$node_(23) setdest 204863 43568 4.0" 
$ns at 556.007085958754 "$node_(23) setdest 31952 53647 17.0" 
$ns at 615.2806776691073 "$node_(23) setdest 185165 29349 6.0" 
$ns at 678.8963437603395 "$node_(23) setdest 206211 46985 5.0" 
$ns at 725.7924309181531 "$node_(23) setdest 155294 14043 16.0" 
$ns at 869.4702387383303 "$node_(23) setdest 171301 41916 1.0" 
$ns at 0.0 "$node_(24) setdest 66285 961 6.0" 
$ns at 83.6356680243795 "$node_(24) setdest 37564 21705 18.0" 
$ns at 230.97921596898797 "$node_(24) setdest 76181 4404 1.0" 
$ns at 267.8741784317209 "$node_(24) setdest 61610 45838 3.0" 
$ns at 313.2891776225522 "$node_(24) setdest 11829 22880 4.0" 
$ns at 361.4833590111903 "$node_(24) setdest 180181 25786 10.0" 
$ns at 417.1105409640656 "$node_(24) setdest 46880 33524 18.0" 
$ns at 590.7305051258344 "$node_(24) setdest 13400 53243 14.0" 
$ns at 739.9742050063396 "$node_(24) setdest 95510 79875 2.0" 
$ns at 787.281772773226 "$node_(24) setdest 136043 79637 10.0" 
$ns at 868.5497271732074 "$node_(24) setdest 234304 86035 8.0" 
$ns at 0.0 "$node_(25) setdest 34006 15525 17.0" 
$ns at 101.77900876931119 "$node_(25) setdest 72538 8985 6.0" 
$ns at 180.6179634499886 "$node_(25) setdest 116982 1569 5.0" 
$ns at 242.79495583919928 "$node_(25) setdest 4676 29464 1.0" 
$ns at 278.92076034102433 "$node_(25) setdest 124020 52058 4.0" 
$ns at 310.50611401997367 "$node_(25) setdest 7612 19058 13.0" 
$ns at 351.0152740457936 "$node_(25) setdest 132892 7826 11.0" 
$ns at 412.46035107713635 "$node_(25) setdest 140206 1767 2.0" 
$ns at 452.14522182044345 "$node_(25) setdest 96673 18732 9.0" 
$ns at 509.7744486450518 "$node_(25) setdest 93699 49182 3.0" 
$ns at 558.198530318961 "$node_(25) setdest 210351 25397 9.0" 
$ns at 653.0806819959886 "$node_(25) setdest 103913 40440 20.0" 
$ns at 801.813789508249 "$node_(25) setdest 244282 45367 11.0" 
$ns at 845.1323962588109 "$node_(25) setdest 128852 47408 19.0" 
$ns at 0.0 "$node_(26) setdest 84685 18353 9.0" 
$ns at 55.165738603004556 "$node_(26) setdest 35142 9470 6.0" 
$ns at 91.77111723552704 "$node_(26) setdest 37754 19446 4.0" 
$ns at 145.90014621129004 "$node_(26) setdest 59865 31415 4.0" 
$ns at 212.95121687125516 "$node_(26) setdest 17627 13886 9.0" 
$ns at 281.093176110319 "$node_(26) setdest 35822 52167 17.0" 
$ns at 428.3935159874602 "$node_(26) setdest 37968 31278 18.0" 
$ns at 630.4588286373405 "$node_(26) setdest 31734 14670 1.0" 
$ns at 668.8530343278792 "$node_(26) setdest 138812 45360 14.0" 
$ns at 699.2925207918819 "$node_(26) setdest 185797 37642 3.0" 
$ns at 741.8532362371843 "$node_(26) setdest 214648 61807 7.0" 
$ns at 824.0153530172696 "$node_(26) setdest 148312 39793 17.0" 
$ns at 0.0 "$node_(27) setdest 27058 27054 4.0" 
$ns at 37.5185513823339 "$node_(27) setdest 68856 4711 17.0" 
$ns at 76.45799262704801 "$node_(27) setdest 94356 14461 15.0" 
$ns at 122.76289705348337 "$node_(27) setdest 47106 9796 6.0" 
$ns at 183.10141812729321 "$node_(27) setdest 29011 31835 16.0" 
$ns at 305.54778383575996 "$node_(27) setdest 42250 30813 2.0" 
$ns at 336.79534949394315 "$node_(27) setdest 42929 39488 19.0" 
$ns at 440.86514763273465 "$node_(27) setdest 19086 50256 17.0" 
$ns at 534.108339597434 "$node_(27) setdest 189230 45377 3.0" 
$ns at 593.6780427225386 "$node_(27) setdest 222095 50657 19.0" 
$ns at 809.2946079315755 "$node_(27) setdest 217297 10627 10.0" 
$ns at 0.0 "$node_(28) setdest 63989 10976 1.0" 
$ns at 39.21843535761965 "$node_(28) setdest 23252 25181 14.0" 
$ns at 124.97217357621471 "$node_(28) setdest 64984 3788 2.0" 
$ns at 165.53109974531674 "$node_(28) setdest 119304 41537 4.0" 
$ns at 231.15657098751717 "$node_(28) setdest 9876 2968 6.0" 
$ns at 278.4872022028718 "$node_(28) setdest 107691 19833 11.0" 
$ns at 375.7797174149522 "$node_(28) setdest 39748 10181 18.0" 
$ns at 422.9611697067779 "$node_(28) setdest 1362 25397 14.0" 
$ns at 521.7799505462657 "$node_(28) setdest 58217 46389 2.0" 
$ns at 556.7166997010542 "$node_(28) setdest 195969 26267 18.0" 
$ns at 594.5645931391082 "$node_(28) setdest 72454 18771 9.0" 
$ns at 710.4274732082885 "$node_(28) setdest 44300 55013 5.0" 
$ns at 741.477473512897 "$node_(28) setdest 165005 51455 5.0" 
$ns at 786.1709393388679 "$node_(28) setdest 25428 16266 3.0" 
$ns at 822.7670012678741 "$node_(28) setdest 232375 30431 8.0" 
$ns at 0.0 "$node_(29) setdest 70561 22055 8.0" 
$ns at 50.95462420037454 "$node_(29) setdest 47094 5281 7.0" 
$ns at 101.05370878436798 "$node_(29) setdest 30178 25427 14.0" 
$ns at 192.44949279904299 "$node_(29) setdest 49438 7985 7.0" 
$ns at 236.34445947346728 "$node_(29) setdest 40237 1157 3.0" 
$ns at 294.7855330145883 "$node_(29) setdest 25570 23446 18.0" 
$ns at 347.9432624781955 "$node_(29) setdest 71197 24452 20.0" 
$ns at 399.64794645893005 "$node_(29) setdest 80736 60273 13.0" 
$ns at 434.00498509317435 "$node_(29) setdest 32749 24566 1.0" 
$ns at 467.7858307043065 "$node_(29) setdest 104591 22107 7.0" 
$ns at 497.91203819700866 "$node_(29) setdest 125778 64191 8.0" 
$ns at 549.0676688388571 "$node_(29) setdest 148072 3085 9.0" 
$ns at 593.0917185517749 "$node_(29) setdest 250 9426 7.0" 
$ns at 655.0220269038152 "$node_(29) setdest 243827 56692 7.0" 
$ns at 731.1187619445153 "$node_(29) setdest 184588 53503 11.0" 
$ns at 844.4155901054103 "$node_(29) setdest 215570 19297 1.0" 
$ns at 874.7540808486476 "$node_(29) setdest 239528 55189 17.0" 
$ns at 0.0 "$node_(30) setdest 92585 6477 13.0" 
$ns at 63.461827675156776 "$node_(30) setdest 92035 6419 7.0" 
$ns at 136.89861520910043 "$node_(30) setdest 63960 25581 16.0" 
$ns at 218.81350808658684 "$node_(30) setdest 88752 17767 18.0" 
$ns at 324.533847299899 "$node_(30) setdest 137858 28587 18.0" 
$ns at 399.9764475630958 "$node_(30) setdest 55900 37375 20.0" 
$ns at 452.51874546904276 "$node_(30) setdest 185429 29312 6.0" 
$ns at 526.0015760863321 "$node_(30) setdest 137733 21699 14.0" 
$ns at 621.0159752178254 "$node_(30) setdest 16751 4746 19.0" 
$ns at 809.2481067687654 "$node_(30) setdest 38575 81510 14.0" 
$ns at 0.0 "$node_(31) setdest 35169 17115 14.0" 
$ns at 117.39878721299128 "$node_(31) setdest 59564 9966 13.0" 
$ns at 216.49346095688418 "$node_(31) setdest 40888 7037 5.0" 
$ns at 267.1418217214059 "$node_(31) setdest 44546 51209 16.0" 
$ns at 317.1245422185296 "$node_(31) setdest 43597 42125 12.0" 
$ns at 354.1784775337983 "$node_(31) setdest 53920 27390 15.0" 
$ns at 392.84018656903174 "$node_(31) setdest 81661 55805 14.0" 
$ns at 517.2166632143046 "$node_(31) setdest 98024 451 16.0" 
$ns at 567.3834995843655 "$node_(31) setdest 227737 69081 11.0" 
$ns at 648.4069275666366 "$node_(31) setdest 182885 18838 13.0" 
$ns at 713.0816300782416 "$node_(31) setdest 115249 10039 12.0" 
$ns at 821.7988608393393 "$node_(31) setdest 155482 73156 13.0" 
$ns at 0.0 "$node_(32) setdest 38096 17305 1.0" 
$ns at 37.29928218639549 "$node_(32) setdest 88774 17166 17.0" 
$ns at 99.69380155109019 "$node_(32) setdest 54839 11947 18.0" 
$ns at 201.61568276021757 "$node_(32) setdest 59094 24458 9.0" 
$ns at 232.8108031128298 "$node_(32) setdest 64713 37389 18.0" 
$ns at 273.23740310173554 "$node_(32) setdest 64314 32893 6.0" 
$ns at 310.21452272563766 "$node_(32) setdest 150814 45869 19.0" 
$ns at 461.95023295010475 "$node_(32) setdest 5599 60565 9.0" 
$ns at 573.172898806048 "$node_(32) setdest 185537 33233 11.0" 
$ns at 615.8894188125839 "$node_(32) setdest 113699 40741 16.0" 
$ns at 799.1931274112042 "$node_(32) setdest 141418 12842 2.0" 
$ns at 830.2801774133089 "$node_(32) setdest 140576 23215 14.0" 
$ns at 0.0 "$node_(33) setdest 53560 20945 1.0" 
$ns at 39.94770029552882 "$node_(33) setdest 12725 7995 19.0" 
$ns at 80.50296427376759 "$node_(33) setdest 5040 13619 1.0" 
$ns at 115.99883847346265 "$node_(33) setdest 66261 10932 14.0" 
$ns at 273.31830925030647 "$node_(33) setdest 99634 6634 13.0" 
$ns at 364.3184665870075 "$node_(33) setdest 52558 40183 18.0" 
$ns at 555.7560768709266 "$node_(33) setdest 146514 6854 18.0" 
$ns at 606.5563993710151 "$node_(33) setdest 23200 28819 18.0" 
$ns at 794.4623301167414 "$node_(33) setdest 211770 18919 3.0" 
$ns at 826.0689363463484 "$node_(33) setdest 127248 14113 9.0" 
$ns at 880.2803340843448 "$node_(33) setdest 127625 68475 2.0" 
$ns at 0.0 "$node_(34) setdest 56887 22665 2.0" 
$ns at 47.56904728496262 "$node_(34) setdest 38390 6985 20.0" 
$ns at 150.08458425098593 "$node_(34) setdest 3819 33873 2.0" 
$ns at 186.7396664219684 "$node_(34) setdest 92474 4967 4.0" 
$ns at 246.6203420019378 "$node_(34) setdest 102073 31132 17.0" 
$ns at 310.51689504165245 "$node_(34) setdest 2201 20056 15.0" 
$ns at 381.27733903676216 "$node_(34) setdest 40177 16491 12.0" 
$ns at 426.14277537528443 "$node_(34) setdest 145249 47746 2.0" 
$ns at 466.434380279977 "$node_(34) setdest 114378 17331 9.0" 
$ns at 547.5487168620236 "$node_(34) setdest 52077 23391 12.0" 
$ns at 622.925539898282 "$node_(34) setdest 16405 72256 1.0" 
$ns at 662.7264767297364 "$node_(34) setdest 77367 2196 7.0" 
$ns at 714.0209211723778 "$node_(34) setdest 205099 80370 5.0" 
$ns at 768.058127830266 "$node_(34) setdest 15484 70634 9.0" 
$ns at 821.6786777879016 "$node_(34) setdest 84007 57258 18.0" 
$ns at 0.0 "$node_(35) setdest 43077 28778 3.0" 
$ns at 44.1111343089373 "$node_(35) setdest 25536 272 10.0" 
$ns at 94.74518143135609 "$node_(35) setdest 89904 13366 14.0" 
$ns at 131.9595828265691 "$node_(35) setdest 73806 4006 8.0" 
$ns at 225.1700914097558 "$node_(35) setdest 67470 33190 1.0" 
$ns at 256.06131913669884 "$node_(35) setdest 9797 21596 7.0" 
$ns at 353.5406281232728 "$node_(35) setdest 118631 57923 8.0" 
$ns at 446.091319448473 "$node_(35) setdest 187088 57116 13.0" 
$ns at 571.2618246470896 "$node_(35) setdest 59263 11043 5.0" 
$ns at 634.2321220102053 "$node_(35) setdest 202706 7390 11.0" 
$ns at 749.849332070876 "$node_(35) setdest 160830 37800 16.0" 
$ns at 790.066892977145 "$node_(35) setdest 73264 22302 12.0" 
$ns at 826.0265731964131 "$node_(35) setdest 149098 61437 9.0" 
$ns at 887.9916710764709 "$node_(35) setdest 207223 50008 3.0" 
$ns at 0.0 "$node_(36) setdest 44634 5933 18.0" 
$ns at 128.39890565150614 "$node_(36) setdest 488 26269 3.0" 
$ns at 170.28406057207187 "$node_(36) setdest 73271 36502 4.0" 
$ns at 213.4138429612903 "$node_(36) setdest 53606 2768 1.0" 
$ns at 249.02337463225538 "$node_(36) setdest 74989 9901 17.0" 
$ns at 395.32252200754664 "$node_(36) setdest 71371 26987 14.0" 
$ns at 527.4778882439138 "$node_(36) setdest 25967 34310 4.0" 
$ns at 579.9590983402838 "$node_(36) setdest 231207 33540 8.0" 
$ns at 670.6115757539169 "$node_(36) setdest 205392 45757 8.0" 
$ns at 724.7097380849351 "$node_(36) setdest 71980 22906 6.0" 
$ns at 767.9357796686456 "$node_(36) setdest 26966 4339 13.0" 
$ns at 898.8061187089672 "$node_(36) setdest 203356 57320 2.0" 
$ns at 0.0 "$node_(37) setdest 8058 15708 14.0" 
$ns at 94.61553542687878 "$node_(37) setdest 76461 16471 11.0" 
$ns at 133.8553048496387 "$node_(37) setdest 55868 27998 16.0" 
$ns at 304.7464177282302 "$node_(37) setdest 5934 40696 1.0" 
$ns at 340.13755644755906 "$node_(37) setdest 5394 9500 10.0" 
$ns at 383.6607558271881 "$node_(37) setdest 135538 18868 5.0" 
$ns at 455.67112807374394 "$node_(37) setdest 14452 18570 16.0" 
$ns at 563.0870791172034 "$node_(37) setdest 197023 54169 1.0" 
$ns at 596.033644748941 "$node_(37) setdest 10242 28611 20.0" 
$ns at 659.6406005738312 "$node_(37) setdest 158009 75338 5.0" 
$ns at 714.534972932787 "$node_(37) setdest 169979 78300 18.0" 
$ns at 0.0 "$node_(38) setdest 22338 17338 4.0" 
$ns at 51.37227719546319 "$node_(38) setdest 50894 14998 5.0" 
$ns at 83.9178142870266 "$node_(38) setdest 20260 18370 13.0" 
$ns at 135.41420123221144 "$node_(38) setdest 19665 31276 16.0" 
$ns at 244.72001201383648 "$node_(38) setdest 127658 19978 8.0" 
$ns at 321.6576519111544 "$node_(38) setdest 40763 47737 20.0" 
$ns at 549.7617037499499 "$node_(38) setdest 204166 32628 15.0" 
$ns at 667.768832426816 "$node_(38) setdest 75847 34478 10.0" 
$ns at 784.8950822370875 "$node_(38) setdest 262072 6525 14.0" 
$ns at 841.2001151765076 "$node_(38) setdest 262642 28874 20.0" 
$ns at 0.0 "$node_(39) setdest 7357 1715 13.0" 
$ns at 43.50757029839966 "$node_(39) setdest 34722 29007 19.0" 
$ns at 82.46274608147144 "$node_(39) setdest 35089 28234 12.0" 
$ns at 183.69690931317288 "$node_(39) setdest 38788 37582 20.0" 
$ns at 408.3625719435163 "$node_(39) setdest 174402 56746 13.0" 
$ns at 509.1562126432452 "$node_(39) setdest 143797 34880 12.0" 
$ns at 597.3479308658484 "$node_(39) setdest 220787 61146 17.0" 
$ns at 774.8611492569613 "$node_(39) setdest 175910 49045 1.0" 
$ns at 813.3957344184939 "$node_(39) setdest 145461 71801 15.0" 
$ns at 0.0 "$node_(40) setdest 20253 6258 13.0" 
$ns at 87.9858832206962 "$node_(40) setdest 29480 17573 18.0" 
$ns at 270.2836611953651 "$node_(40) setdest 95912 1750 13.0" 
$ns at 392.6596500713974 "$node_(40) setdest 154285 13886 12.0" 
$ns at 511.8063603559516 "$node_(40) setdest 142972 48724 19.0" 
$ns at 703.8898626517092 "$node_(40) setdest 167027 62830 7.0" 
$ns at 753.2436092067135 "$node_(40) setdest 47650 60377 19.0" 
$ns at 0.0 "$node_(41) setdest 57949 6579 6.0" 
$ns at 62.15204869766999 "$node_(41) setdest 21019 31431 20.0" 
$ns at 132.5669441515803 "$node_(41) setdest 2505 13277 6.0" 
$ns at 200.6103151000528 "$node_(41) setdest 89445 21730 18.0" 
$ns at 282.5566147327446 "$node_(41) setdest 99738 28961 9.0" 
$ns at 364.6771554436692 "$node_(41) setdest 80134 1037 3.0" 
$ns at 395.44620911295624 "$node_(41) setdest 40686 11081 8.0" 
$ns at 434.47061603978534 "$node_(41) setdest 73932 57641 14.0" 
$ns at 504.9339011770906 "$node_(41) setdest 27667 24347 11.0" 
$ns at 628.3030309306474 "$node_(41) setdest 208244 21909 8.0" 
$ns at 690.8366846208881 "$node_(41) setdest 50509 12053 1.0" 
$ns at 723.7632884105876 "$node_(41) setdest 184517 11661 16.0" 
$ns at 830.2763906007455 "$node_(41) setdest 164401 3073 2.0" 
$ns at 871.78252947602 "$node_(41) setdest 46507 38121 19.0" 
$ns at 0.0 "$node_(42) setdest 26901 8752 8.0" 
$ns at 108.59416389974453 "$node_(42) setdest 51192 12313 10.0" 
$ns at 218.98557867620804 "$node_(42) setdest 15530 27907 4.0" 
$ns at 273.44443932127655 "$node_(42) setdest 42504 49747 10.0" 
$ns at 339.73872177221335 "$node_(42) setdest 96864 28457 4.0" 
$ns at 399.2783582125806 "$node_(42) setdest 83926 43733 18.0" 
$ns at 461.1807883722673 "$node_(42) setdest 93727 23022 5.0" 
$ns at 527.5193278009012 "$node_(42) setdest 85338 33955 13.0" 
$ns at 582.3574651760897 "$node_(42) setdest 96844 27140 10.0" 
$ns at 668.2881712206965 "$node_(42) setdest 174992 54693 11.0" 
$ns at 791.9683583215584 "$node_(42) setdest 87246 62012 13.0" 
$ns at 864.4982601215825 "$node_(42) setdest 154971 78856 8.0" 
$ns at 0.0 "$node_(43) setdest 85663 5626 8.0" 
$ns at 50.45357036030733 "$node_(43) setdest 89336 22687 12.0" 
$ns at 92.79001915238442 "$node_(43) setdest 19522 28202 14.0" 
$ns at 136.88923217947266 "$node_(43) setdest 15751 8779 5.0" 
$ns at 192.17409769299195 "$node_(43) setdest 70849 4649 12.0" 
$ns at 341.78564071767363 "$node_(43) setdest 69499 21975 6.0" 
$ns at 414.3408020651367 "$node_(43) setdest 16232 36524 16.0" 
$ns at 458.59861532857377 "$node_(43) setdest 74157 66054 3.0" 
$ns at 498.5148261869043 "$node_(43) setdest 201245 38827 18.0" 
$ns at 624.2736401501548 "$node_(43) setdest 41993 2546 2.0" 
$ns at 668.9485388196764 "$node_(43) setdest 242432 74733 12.0" 
$ns at 781.1295054810093 "$node_(43) setdest 190312 56522 4.0" 
$ns at 832.2520741920276 "$node_(43) setdest 178289 21605 11.0" 
$ns at 0.0 "$node_(44) setdest 65206 14860 11.0" 
$ns at 41.60106656372286 "$node_(44) setdest 34885 2422 6.0" 
$ns at 74.85245180279551 "$node_(44) setdest 50417 10067 5.0" 
$ns at 113.61852404855422 "$node_(44) setdest 1573 2197 4.0" 
$ns at 181.42120622766782 "$node_(44) setdest 59694 13779 4.0" 
$ns at 231.54054158778217 "$node_(44) setdest 58172 8099 4.0" 
$ns at 280.98227526713487 "$node_(44) setdest 52740 27262 18.0" 
$ns at 366.6525116692568 "$node_(44) setdest 3467 18744 14.0" 
$ns at 491.88936337063274 "$node_(44) setdest 8372 5547 9.0" 
$ns at 525.3102998411777 "$node_(44) setdest 23642 29053 10.0" 
$ns at 571.955481031616 "$node_(44) setdest 4910 66615 15.0" 
$ns at 669.2238166528713 "$node_(44) setdest 129824 53533 6.0" 
$ns at 705.1299822847961 "$node_(44) setdest 38119 78006 13.0" 
$ns at 766.3190844324554 "$node_(44) setdest 247075 50849 15.0" 
$ns at 0.0 "$node_(45) setdest 41833 20472 1.0" 
$ns at 36.653389059060686 "$node_(45) setdest 18045 22571 8.0" 
$ns at 133.0479481901537 "$node_(45) setdest 2487 9967 19.0" 
$ns at 322.84616700021434 "$node_(45) setdest 131569 6370 5.0" 
$ns at 359.3868595981139 "$node_(45) setdest 73874 16426 8.0" 
$ns at 446.15376234441385 "$node_(45) setdest 164985 21084 14.0" 
$ns at 561.2344934796049 "$node_(45) setdest 207968 9916 11.0" 
$ns at 686.1420587533567 "$node_(45) setdest 135512 29343 13.0" 
$ns at 742.7553211109047 "$node_(45) setdest 4083 50012 15.0" 
$ns at 875.0560112194884 "$node_(45) setdest 188317 16475 8.0" 
$ns at 0.0 "$node_(46) setdest 81689 27753 8.0" 
$ns at 70.20096043308055 "$node_(46) setdest 27405 6011 12.0" 
$ns at 176.60229801976277 "$node_(46) setdest 115518 28840 20.0" 
$ns at 358.4648086653349 "$node_(46) setdest 121133 22368 10.0" 
$ns at 402.13907614335153 "$node_(46) setdest 139928 19917 7.0" 
$ns at 454.61708091027555 "$node_(46) setdest 138745 5355 16.0" 
$ns at 583.7213350543589 "$node_(46) setdest 24993 60968 6.0" 
$ns at 641.9023628760883 "$node_(46) setdest 176208 17540 10.0" 
$ns at 703.5665974090059 "$node_(46) setdest 86132 5147 8.0" 
$ns at 752.090262186526 "$node_(46) setdest 234505 43485 16.0" 
$ns at 0.0 "$node_(47) setdest 51865 11741 4.0" 
$ns at 30.762857812443674 "$node_(47) setdest 87515 7677 13.0" 
$ns at 149.63996543516114 "$node_(47) setdest 71775 22914 10.0" 
$ns at 258.43834508106676 "$node_(47) setdest 94874 30936 7.0" 
$ns at 301.937481257909 "$node_(47) setdest 122518 92 14.0" 
$ns at 355.5014057283612 "$node_(47) setdest 49537 1286 10.0" 
$ns at 463.906021046703 "$node_(47) setdest 5529 15 17.0" 
$ns at 540.7982506666312 "$node_(47) setdest 132310 25509 10.0" 
$ns at 575.2726740430296 "$node_(47) setdest 214731 5799 9.0" 
$ns at 619.7645710082184 "$node_(47) setdest 230466 26271 14.0" 
$ns at 666.1639088591962 "$node_(47) setdest 210116 22136 18.0" 
$ns at 714.617736395156 "$node_(47) setdest 131807 15308 9.0" 
$ns at 767.7640803318119 "$node_(47) setdest 10149 4710 19.0" 
$ns at 836.1904568108288 "$node_(47) setdest 18975 43824 10.0" 
$ns at 0.0 "$node_(48) setdest 60422 4868 12.0" 
$ns at 148.68263913486464 "$node_(48) setdest 90213 17954 10.0" 
$ns at 254.77003986493392 "$node_(48) setdest 93534 53327 1.0" 
$ns at 294.6492725643601 "$node_(48) setdest 28818 26605 9.0" 
$ns at 411.264199602192 "$node_(48) setdest 135790 40004 9.0" 
$ns at 482.864958244882 "$node_(48) setdest 172652 25417 11.0" 
$ns at 513.4696279145662 "$node_(48) setdest 111265 49690 5.0" 
$ns at 582.7256089038333 "$node_(48) setdest 120689 49310 8.0" 
$ns at 667.191203105526 "$node_(48) setdest 187051 4091 13.0" 
$ns at 716.4400197787775 "$node_(48) setdest 110081 33835 6.0" 
$ns at 797.0575784556501 "$node_(48) setdest 37129 37495 10.0" 
$ns at 883.3602317866302 "$node_(48) setdest 268130 88360 4.0" 
$ns at 0.0 "$node_(49) setdest 26039 21522 11.0" 
$ns at 70.19241619543658 "$node_(49) setdest 29578 11331 16.0" 
$ns at 154.66590745170828 "$node_(49) setdest 105384 37697 14.0" 
$ns at 279.13275031698026 "$node_(49) setdest 28527 6665 10.0" 
$ns at 320.9008181902103 "$node_(49) setdest 112053 14612 10.0" 
$ns at 402.9659460291182 "$node_(49) setdest 173602 6747 5.0" 
$ns at 433.43206620041224 "$node_(49) setdest 113664 44194 14.0" 
$ns at 546.0248904601216 "$node_(49) setdest 121725 58084 1.0" 
$ns at 583.4150822970067 "$node_(49) setdest 19830 2298 8.0" 
$ns at 677.6880790204896 "$node_(49) setdest 34803 25001 12.0" 
$ns at 824.4424392432791 "$node_(49) setdest 79545 82238 16.0" 
$ns at 882.9317800277156 "$node_(49) setdest 227310 8938 9.0" 
$ns at 0.0 "$node_(50) setdest 67189 21623 15.0" 
$ns at 132.3815237068975 "$node_(50) setdest 73904 15648 16.0" 
$ns at 250.47240416558145 "$node_(50) setdest 116949 4746 4.0" 
$ns at 282.1748044772503 "$node_(50) setdest 38065 4965 6.0" 
$ns at 346.920919432491 "$node_(50) setdest 33458 51138 1.0" 
$ns at 383.95364886783136 "$node_(50) setdest 116933 26949 11.0" 
$ns at 498.7318932253199 "$node_(50) setdest 113580 43155 18.0" 
$ns at 601.7817519903389 "$node_(50) setdest 200632 23411 12.0" 
$ns at 742.8451927221167 "$node_(50) setdest 109089 80317 20.0" 
$ns at 789.843693483643 "$node_(50) setdest 154399 77718 1.0" 
$ns at 822.9425224621572 "$node_(50) setdest 204229 13080 17.0" 
$ns at 860.5696550960495 "$node_(50) setdest 111426 65860 13.0" 
$ns at 0.0 "$node_(51) setdest 20129 12449 18.0" 
$ns at 141.57246947143693 "$node_(51) setdest 44452 19970 14.0" 
$ns at 221.54537201260055 "$node_(51) setdest 45513 33636 4.0" 
$ns at 282.6549486412906 "$node_(51) setdest 93381 20197 8.0" 
$ns at 339.17702076347894 "$node_(51) setdest 80481 15260 20.0" 
$ns at 443.59821254548694 "$node_(51) setdest 155548 9755 8.0" 
$ns at 545.8650332773739 "$node_(51) setdest 114070 19915 1.0" 
$ns at 575.8739149343329 "$node_(51) setdest 189318 38245 1.0" 
$ns at 608.5126803644781 "$node_(51) setdest 119740 40460 13.0" 
$ns at 726.6937327082303 "$node_(51) setdest 68197 18674 14.0" 
$ns at 890.9532514769296 "$node_(51) setdest 136826 46236 10.0" 
$ns at 0.0 "$node_(52) setdest 8822 13655 1.0" 
$ns at 32.78298815142286 "$node_(52) setdest 41702 10602 18.0" 
$ns at 233.46510385421058 "$node_(52) setdest 9930 13280 18.0" 
$ns at 298.416467108476 "$node_(52) setdest 93540 29547 11.0" 
$ns at 435.61715697402735 "$node_(52) setdest 143306 6362 19.0" 
$ns at 547.7892224678487 "$node_(52) setdest 187222 11172 19.0" 
$ns at 723.4325940413279 "$node_(52) setdest 38756 79205 16.0" 
$ns at 834.541388541381 "$node_(52) setdest 180105 75033 18.0" 
$ns at 0.0 "$node_(53) setdest 34764 30013 13.0" 
$ns at 133.88715172421914 "$node_(53) setdest 90688 18251 3.0" 
$ns at 187.7477095570203 "$node_(53) setdest 36384 40675 2.0" 
$ns at 218.07696368348437 "$node_(53) setdest 80777 29542 5.0" 
$ns at 264.0551314188349 "$node_(53) setdest 137263 41361 5.0" 
$ns at 324.53776419223414 "$node_(53) setdest 39935 39933 19.0" 
$ns at 540.2558221913655 "$node_(53) setdest 158696 18048 9.0" 
$ns at 658.6544166297878 "$node_(53) setdest 94111 7617 18.0" 
$ns at 722.8056534504174 "$node_(53) setdest 94930 65795 4.0" 
$ns at 775.7520767602854 "$node_(53) setdest 63284 61928 19.0" 
$ns at 0.0 "$node_(54) setdest 27613 5255 19.0" 
$ns at 58.25492753699743 "$node_(54) setdest 31554 12077 9.0" 
$ns at 138.5916064017146 "$node_(54) setdest 77208 26063 15.0" 
$ns at 299.7278212109415 "$node_(54) setdest 119771 20168 13.0" 
$ns at 368.9169805345309 "$node_(54) setdest 73448 52525 13.0" 
$ns at 401.0355283602266 "$node_(54) setdest 86810 763 14.0" 
$ns at 456.53391203005765 "$node_(54) setdest 146603 38957 3.0" 
$ns at 496.7040270220291 "$node_(54) setdest 142189 24695 15.0" 
$ns at 642.6364051518576 "$node_(54) setdest 182444 73474 7.0" 
$ns at 710.261780211273 "$node_(54) setdest 97597 82672 5.0" 
$ns at 766.0954575210868 "$node_(54) setdest 200739 71636 10.0" 
$ns at 824.7866148837103 "$node_(54) setdest 260178 24742 15.0" 
$ns at 0.0 "$node_(55) setdest 53015 11158 5.0" 
$ns at 66.965776716684 "$node_(55) setdest 61320 27926 17.0" 
$ns at 134.40487393084567 "$node_(55) setdest 19340 5504 2.0" 
$ns at 175.4228173140753 "$node_(55) setdest 102389 8292 9.0" 
$ns at 260.4864027243316 "$node_(55) setdest 41364 13201 4.0" 
$ns at 321.3323779323779 "$node_(55) setdest 92300 6212 7.0" 
$ns at 399.91581685715227 "$node_(55) setdest 72387 32455 1.0" 
$ns at 431.678383179269 "$node_(55) setdest 120637 21395 10.0" 
$ns at 525.8507404681529 "$node_(55) setdest 128126 36920 12.0" 
$ns at 661.2897069202556 "$node_(55) setdest 104501 79846 16.0" 
$ns at 719.9579631651662 "$node_(55) setdest 41146 62283 19.0" 
$ns at 805.9747957754583 "$node_(55) setdest 80571 4229 1.0" 
$ns at 841.2103279790138 "$node_(55) setdest 96995 69441 16.0" 
$ns at 0.0 "$node_(56) setdest 27195 25088 17.0" 
$ns at 183.5257046664014 "$node_(56) setdest 104807 25993 18.0" 
$ns at 335.0141629923446 "$node_(56) setdest 38313 53907 2.0" 
$ns at 382.16327024808277 "$node_(56) setdest 126512 20741 10.0" 
$ns at 422.92625916753593 "$node_(56) setdest 18257 7719 7.0" 
$ns at 507.32527266592456 "$node_(56) setdest 91232 41794 16.0" 
$ns at 608.8701622087956 "$node_(56) setdest 178517 37109 9.0" 
$ns at 673.8741581509503 "$node_(56) setdest 133590 77911 6.0" 
$ns at 759.4668989468928 "$node_(56) setdest 100599 68551 9.0" 
$ns at 802.4872001767615 "$node_(56) setdest 60562 11267 14.0" 
$ns at 0.0 "$node_(57) setdest 13893 9701 2.0" 
$ns at 44.39869756566818 "$node_(57) setdest 84912 18033 7.0" 
$ns at 119.48437570099065 "$node_(57) setdest 21357 27040 11.0" 
$ns at 158.2990036631821 "$node_(57) setdest 132164 27555 12.0" 
$ns at 198.65132705608846 "$node_(57) setdest 3138 20673 16.0" 
$ns at 359.9671554756527 "$node_(57) setdest 143139 55119 9.0" 
$ns at 479.62122286629904 "$node_(57) setdest 211084 1842 1.0" 
$ns at 517.0085139386348 "$node_(57) setdest 72715 51392 1.0" 
$ns at 547.1891084133994 "$node_(57) setdest 198002 29970 2.0" 
$ns at 594.039764116418 "$node_(57) setdest 206952 48792 12.0" 
$ns at 635.9244201163798 "$node_(57) setdest 36939 28795 13.0" 
$ns at 699.3354084258197 "$node_(57) setdest 175330 73483 17.0" 
$ns at 755.4638061294472 "$node_(57) setdest 56585 36202 12.0" 
$ns at 873.1833488763622 "$node_(57) setdest 178744 84800 14.0" 
$ns at 0.0 "$node_(58) setdest 85804 19675 1.0" 
$ns at 37.04179938152901 "$node_(58) setdest 47147 19912 16.0" 
$ns at 142.77718056996395 "$node_(58) setdest 82412 2945 19.0" 
$ns at 199.44676758672645 "$node_(58) setdest 54896 21873 6.0" 
$ns at 263.96715895837764 "$node_(58) setdest 152302 3644 10.0" 
$ns at 352.3897099097758 "$node_(58) setdest 64392 26900 12.0" 
$ns at 426.21934766274796 "$node_(58) setdest 177112 24042 8.0" 
$ns at 468.1000623814994 "$node_(58) setdest 186354 24195 9.0" 
$ns at 525.1202819930899 "$node_(58) setdest 197422 50420 17.0" 
$ns at 621.2126594901742 "$node_(58) setdest 99310 15885 17.0" 
$ns at 750.1386173534358 "$node_(58) setdest 198009 51559 15.0" 
$ns at 821.0408464438765 "$node_(58) setdest 83427 171 19.0" 
$ns at 854.1309847504754 "$node_(58) setdest 90615 16721 1.0" 
$ns at 891.1389542538294 "$node_(58) setdest 225054 33757 12.0" 
$ns at 0.0 "$node_(59) setdest 63608 19511 17.0" 
$ns at 78.63556611352065 "$node_(59) setdest 52235 30384 9.0" 
$ns at 160.01654846628048 "$node_(59) setdest 94300 38774 11.0" 
$ns at 228.40769043614375 "$node_(59) setdest 18145 29342 19.0" 
$ns at 313.27080103429364 "$node_(59) setdest 144845 41294 12.0" 
$ns at 383.4992255801514 "$node_(59) setdest 144269 26236 19.0" 
$ns at 566.2907483964555 "$node_(59) setdest 78171 58880 5.0" 
$ns at 601.9483677696425 "$node_(59) setdest 186489 20146 14.0" 
$ns at 656.0505472117962 "$node_(59) setdest 112166 19917 11.0" 
$ns at 780.4335085385925 "$node_(59) setdest 57689 52100 18.0" 
$ns at 820.80662270785 "$node_(59) setdest 169962 54944 11.0" 
$ns at 0.0 "$node_(60) setdest 2074 30879 13.0" 
$ns at 135.26050138585555 "$node_(60) setdest 46349 15441 1.0" 
$ns at 173.28735509539766 "$node_(60) setdest 90792 6134 12.0" 
$ns at 276.38046566397435 "$node_(60) setdest 100312 42161 18.0" 
$ns at 477.38502109179586 "$node_(60) setdest 58168 41518 16.0" 
$ns at 630.7030502078551 "$node_(60) setdest 174762 19333 12.0" 
$ns at 738.3951319881822 "$node_(60) setdest 214008 21133 3.0" 
$ns at 784.3908391806335 "$node_(60) setdest 40017 22240 5.0" 
$ns at 834.1535142986122 "$node_(60) setdest 74074 14165 15.0" 
$ns at 0.0 "$node_(61) setdest 13378 7561 7.0" 
$ns at 80.4670427014 "$node_(61) setdest 41179 24087 2.0" 
$ns at 120.2170107295741 "$node_(61) setdest 42359 18426 5.0" 
$ns at 198.58376030284722 "$node_(61) setdest 100281 31026 11.0" 
$ns at 238.7194496624361 "$node_(61) setdest 95104 34908 5.0" 
$ns at 284.9019970021671 "$node_(61) setdest 35853 50875 1.0" 
$ns at 324.14972291280355 "$node_(61) setdest 28409 48159 2.0" 
$ns at 355.2862070646197 "$node_(61) setdest 97142 41151 17.0" 
$ns at 466.6113811855246 "$node_(61) setdest 128852 65554 12.0" 
$ns at 514.5687946165053 "$node_(61) setdest 172143 23696 6.0" 
$ns at 558.4114920253918 "$node_(61) setdest 194380 48474 7.0" 
$ns at 644.6263480574997 "$node_(61) setdest 99649 63476 14.0" 
$ns at 694.3073150123478 "$node_(61) setdest 123630 47854 12.0" 
$ns at 785.4614282283903 "$node_(61) setdest 111431 33718 14.0" 
$ns at 855.7258578077498 "$node_(61) setdest 229412 65505 9.0" 
$ns at 0.0 "$node_(62) setdest 62310 2111 6.0" 
$ns at 44.23925885880635 "$node_(62) setdest 84141 1525 6.0" 
$ns at 125.50216942952162 "$node_(62) setdest 18343 27779 15.0" 
$ns at 300.0622681144181 "$node_(62) setdest 137094 17125 18.0" 
$ns at 416.85247442725296 "$node_(62) setdest 142399 27899 13.0" 
$ns at 500.32502176356513 "$node_(62) setdest 212067 50627 16.0" 
$ns at 546.2063872686666 "$node_(62) setdest 153065 22349 18.0" 
$ns at 581.3512135771406 "$node_(62) setdest 128860 54464 8.0" 
$ns at 670.3822706550993 "$node_(62) setdest 22186 11941 2.0" 
$ns at 717.4826302506955 "$node_(62) setdest 126321 3201 19.0" 
$ns at 794.836017066054 "$node_(62) setdest 5218 14104 8.0" 
$ns at 0.0 "$node_(63) setdest 15399 6971 9.0" 
$ns at 45.42635656091234 "$node_(63) setdest 12615 27067 18.0" 
$ns at 174.76514867550355 "$node_(63) setdest 102923 28858 11.0" 
$ns at 295.5003793115843 "$node_(63) setdest 109103 44591 8.0" 
$ns at 355.893751758781 "$node_(63) setdest 13482 9948 3.0" 
$ns at 403.65823600857175 "$node_(63) setdest 4366 59782 7.0" 
$ns at 447.21177810302 "$node_(63) setdest 9236 56082 4.0" 
$ns at 500.7739366858079 "$node_(63) setdest 102926 49801 19.0" 
$ns at 703.4795454601292 "$node_(63) setdest 16949 43209 8.0" 
$ns at 748.2210269163746 "$node_(63) setdest 250424 1215 6.0" 
$ns at 794.6057559520452 "$node_(63) setdest 37829 33310 10.0" 
$ns at 832.0539069388806 "$node_(63) setdest 92304 83505 3.0" 
$ns at 865.7364915782894 "$node_(63) setdest 33763 87924 2.0" 
$ns at 0.0 "$node_(64) setdest 14517 10422 18.0" 
$ns at 183.5292403399366 "$node_(64) setdest 131186 59 1.0" 
$ns at 217.64843665965293 "$node_(64) setdest 65991 3829 17.0" 
$ns at 405.2208287725194 "$node_(64) setdest 81259 40167 18.0" 
$ns at 477.67419515541707 "$node_(64) setdest 6339 42700 2.0" 
$ns at 517.8787718935481 "$node_(64) setdest 147525 69213 8.0" 
$ns at 624.6212686587957 "$node_(64) setdest 2957 48563 15.0" 
$ns at 738.7422211509339 "$node_(64) setdest 23423 74681 20.0" 
$ns at 864.6501839921182 "$node_(64) setdest 143440 57927 2.0" 
$ns at 0.0 "$node_(65) setdest 61826 10188 7.0" 
$ns at 46.20225913702168 "$node_(65) setdest 80328 13455 11.0" 
$ns at 130.4640263062853 "$node_(65) setdest 10488 6468 9.0" 
$ns at 245.75953240416044 "$node_(65) setdest 92712 17008 10.0" 
$ns at 359.18478217563035 "$node_(65) setdest 171122 22407 17.0" 
$ns at 496.4473252983779 "$node_(65) setdest 190104 62365 7.0" 
$ns at 578.527263332554 "$node_(65) setdest 228353 75468 8.0" 
$ns at 664.0901571305975 "$node_(65) setdest 182045 59070 17.0" 
$ns at 726.0572235875627 "$node_(65) setdest 158578 57393 9.0" 
$ns at 799.1915574157124 "$node_(65) setdest 191396 15623 17.0" 
$ns at 851.4045760748052 "$node_(65) setdest 154160 19988 1.0" 
$ns at 887.4329232671832 "$node_(65) setdest 263445 67318 6.0" 
$ns at 0.0 "$node_(66) setdest 4530 5886 1.0" 
$ns at 38.49096265567589 "$node_(66) setdest 25648 3716 9.0" 
$ns at 153.27902826056575 "$node_(66) setdest 89775 22088 6.0" 
$ns at 216.53809665439434 "$node_(66) setdest 23074 43554 1.0" 
$ns at 247.3074115029024 "$node_(66) setdest 30016 19697 9.0" 
$ns at 340.0627117740598 "$node_(66) setdest 51180 7195 10.0" 
$ns at 423.7566057132385 "$node_(66) setdest 138678 30857 9.0" 
$ns at 467.2889862314696 "$node_(66) setdest 96436 43486 18.0" 
$ns at 573.1485995865024 "$node_(66) setdest 94213 15368 3.0" 
$ns at 627.1057925328089 "$node_(66) setdest 182799 64198 10.0" 
$ns at 693.9364367459855 "$node_(66) setdest 94260 79212 3.0" 
$ns at 738.4459987365752 "$node_(66) setdest 212932 3444 4.0" 
$ns at 789.8465886257416 "$node_(66) setdest 72830 27585 2.0" 
$ns at 839.4495663861173 "$node_(66) setdest 232852 63666 1.0" 
$ns at 878.7901863131169 "$node_(66) setdest 12727 23953 15.0" 
$ns at 0.0 "$node_(67) setdest 45187 13596 9.0" 
$ns at 48.42189223057054 "$node_(67) setdest 61789 20280 6.0" 
$ns at 87.83724119044629 "$node_(67) setdest 4439 15277 3.0" 
$ns at 122.42666758341217 "$node_(67) setdest 38295 11362 19.0" 
$ns at 185.60613649306816 "$node_(67) setdest 19135 14593 2.0" 
$ns at 228.4538942632335 "$node_(67) setdest 26960 22456 12.0" 
$ns at 338.5701275614442 "$node_(67) setdest 134015 25778 5.0" 
$ns at 401.90283112385765 "$node_(67) setdest 171776 14803 5.0" 
$ns at 473.40040004192474 "$node_(67) setdest 157187 39701 11.0" 
$ns at 578.9958058565753 "$node_(67) setdest 124244 2343 12.0" 
$ns at 658.4030957036007 "$node_(67) setdest 107491 55653 3.0" 
$ns at 705.4184942389143 "$node_(67) setdest 29056 70360 13.0" 
$ns at 828.5691140109183 "$node_(67) setdest 267079 3089 1.0" 
$ns at 865.4051519805564 "$node_(67) setdest 84391 7834 4.0" 
$ns at 0.0 "$node_(68) setdest 23262 27560 5.0" 
$ns at 32.53186153520841 "$node_(68) setdest 19520 20083 8.0" 
$ns at 121.37818745904491 "$node_(68) setdest 3087 27131 11.0" 
$ns at 210.23126052253576 "$node_(68) setdest 106873 6050 14.0" 
$ns at 300.1513827609858 "$node_(68) setdest 26176 25892 9.0" 
$ns at 374.8218977673063 "$node_(68) setdest 31491 24401 1.0" 
$ns at 414.57968549749774 "$node_(68) setdest 54452 23131 4.0" 
$ns at 461.93186582248336 "$node_(68) setdest 70926 42331 5.0" 
$ns at 529.1986530523053 "$node_(68) setdest 128161 21754 4.0" 
$ns at 578.073391131183 "$node_(68) setdest 52562 56046 3.0" 
$ns at 633.2887780705629 "$node_(68) setdest 55175 37590 20.0" 
$ns at 816.5767888505314 "$node_(68) setdest 90956 19700 3.0" 
$ns at 854.5438456432994 "$node_(68) setdest 172876 14485 6.0" 
$ns at 894.3775383650444 "$node_(68) setdest 263434 82681 11.0" 
$ns at 0.0 "$node_(69) setdest 45128 30751 2.0" 
$ns at 43.8970800290963 "$node_(69) setdest 18664 28507 6.0" 
$ns at 120.21990067519847 "$node_(69) setdest 61416 11768 7.0" 
$ns at 201.65396043927362 "$node_(69) setdest 97530 19378 11.0" 
$ns at 258.98056857874997 "$node_(69) setdest 99808 532 8.0" 
$ns at 362.0499328190829 "$node_(69) setdest 122087 33652 10.0" 
$ns at 416.69511489680184 "$node_(69) setdest 7348 2724 19.0" 
$ns at 466.6295614242607 "$node_(69) setdest 105087 44228 5.0" 
$ns at 497.9537810994819 "$node_(69) setdest 102870 47229 11.0" 
$ns at 536.9155944614469 "$node_(69) setdest 20344 21817 18.0" 
$ns at 676.9202239214576 "$node_(69) setdest 159985 31681 2.0" 
$ns at 720.1397009795784 "$node_(69) setdest 77200 25601 12.0" 
$ns at 751.1630194400565 "$node_(69) setdest 73020 65382 2.0" 
$ns at 789.8106168160875 "$node_(69) setdest 118152 3581 7.0" 
$ns at 838.8681415207046 "$node_(69) setdest 20038 55977 4.0" 
$ns at 884.4579993857715 "$node_(69) setdest 33628 40051 13.0" 
$ns at 0.0 "$node_(70) setdest 79809 12147 12.0" 
$ns at 36.8834312804026 "$node_(70) setdest 73803 29827 1.0" 
$ns at 76.5198083084614 "$node_(70) setdest 75371 4171 8.0" 
$ns at 181.55432571125135 "$node_(70) setdest 1789 29866 4.0" 
$ns at 246.37307885753793 "$node_(70) setdest 257 11863 12.0" 
$ns at 320.275491202389 "$node_(70) setdest 103111 23277 13.0" 
$ns at 401.17375565964676 "$node_(70) setdest 25757 948 15.0" 
$ns at 445.816322359779 "$node_(70) setdest 1464 59561 4.0" 
$ns at 515.2212407934476 "$node_(70) setdest 13139 26851 3.0" 
$ns at 551.8618426403216 "$node_(70) setdest 19718 27398 5.0" 
$ns at 590.8610789108991 "$node_(70) setdest 231664 73435 6.0" 
$ns at 633.9152547879903 "$node_(70) setdest 44529 4371 8.0" 
$ns at 687.0514303911817 "$node_(70) setdest 55325 31645 18.0" 
$ns at 762.6093377492523 "$node_(70) setdest 117931 28498 8.0" 
$ns at 841.9838210197745 "$node_(70) setdest 156279 49714 5.0" 
$ns at 873.9988171263971 "$node_(70) setdest 128216 26948 2.0" 
$ns at 0.0 "$node_(71) setdest 27767 22076 5.0" 
$ns at 72.17626968424491 "$node_(71) setdest 70995 11939 19.0" 
$ns at 235.63196595234683 "$node_(71) setdest 98095 41382 4.0" 
$ns at 284.22842933144227 "$node_(71) setdest 98333 49157 5.0" 
$ns at 348.22224435566613 "$node_(71) setdest 43929 3723 8.0" 
$ns at 401.54219036208497 "$node_(71) setdest 164368 50142 10.0" 
$ns at 530.9271835925467 "$node_(71) setdest 69398 51593 18.0" 
$ns at 693.3585774760229 "$node_(71) setdest 201173 55687 16.0" 
$ns at 764.3157588203266 "$node_(71) setdest 52417 78296 2.0" 
$ns at 807.3426352737199 "$node_(71) setdest 116439 22869 18.0" 
$ns at 0.0 "$node_(72) setdest 27702 14691 11.0" 
$ns at 91.23837712621874 "$node_(72) setdest 71605 13647 7.0" 
$ns at 185.82850935549845 "$node_(72) setdest 122237 40163 11.0" 
$ns at 298.06855019662567 "$node_(72) setdest 52968 5409 17.0" 
$ns at 483.66499759265093 "$node_(72) setdest 139931 21163 2.0" 
$ns at 526.2978078677863 "$node_(72) setdest 33205 47434 1.0" 
$ns at 559.7577777300896 "$node_(72) setdest 19890 69587 2.0" 
$ns at 607.073647477743 "$node_(72) setdest 8084 77219 15.0" 
$ns at 681.7034303998457 "$node_(72) setdest 58445 3309 12.0" 
$ns at 727.3144667670755 "$node_(72) setdest 138846 74533 18.0" 
$ns at 778.5375610367389 "$node_(72) setdest 29931 51938 12.0" 
$ns at 882.7492428017267 "$node_(72) setdest 151747 58699 17.0" 
$ns at 0.0 "$node_(73) setdest 30549 22285 15.0" 
$ns at 116.87936172615763 "$node_(73) setdest 81987 7965 20.0" 
$ns at 175.98161215587055 "$node_(73) setdest 43016 18455 4.0" 
$ns at 225.48204369874836 "$node_(73) setdest 28937 44358 7.0" 
$ns at 269.13660823482587 "$node_(73) setdest 10815 11922 17.0" 
$ns at 414.93498856939755 "$node_(73) setdest 21636 58562 6.0" 
$ns at 480.36333227708155 "$node_(73) setdest 6925 57228 7.0" 
$ns at 548.3221074814337 "$node_(73) setdest 183715 20725 16.0" 
$ns at 637.07314291698 "$node_(73) setdest 193799 54868 7.0" 
$ns at 706.0367925093404 "$node_(73) setdest 218556 58082 14.0" 
$ns at 856.3567967085535 "$node_(73) setdest 251382 16153 9.0" 
$ns at 0.0 "$node_(74) setdest 19636 27755 17.0" 
$ns at 146.11983210883182 "$node_(74) setdest 20113 29420 2.0" 
$ns at 194.39352208202448 "$node_(74) setdest 119694 12637 5.0" 
$ns at 231.65183808377162 "$node_(74) setdest 40943 15299 12.0" 
$ns at 376.86830809977783 "$node_(74) setdest 80713 46427 19.0" 
$ns at 556.4302010445449 "$node_(74) setdest 15814 22522 8.0" 
$ns at 637.8580814887355 "$node_(74) setdest 111224 72467 12.0" 
$ns at 670.0863352686164 "$node_(74) setdest 134935 66034 19.0" 
$ns at 760.9526549010554 "$node_(74) setdest 227699 58302 1.0" 
$ns at 791.4366513916258 "$node_(74) setdest 54113 88869 9.0" 
$ns at 851.8255775016829 "$node_(74) setdest 8891 65148 20.0" 
$ns at 0.0 "$node_(75) setdest 51175 10581 9.0" 
$ns at 77.40834106072319 "$node_(75) setdest 4299 10767 9.0" 
$ns at 189.81366120807434 "$node_(75) setdest 10029 35600 10.0" 
$ns at 243.92609761762867 "$node_(75) setdest 44030 5258 19.0" 
$ns at 389.7407144275537 "$node_(75) setdest 81739 38485 17.0" 
$ns at 505.7940940126636 "$node_(75) setdest 187485 2590 9.0" 
$ns at 587.4597486688568 "$node_(75) setdest 28903 68050 16.0" 
$ns at 636.3371104980233 "$node_(75) setdest 227699 17785 2.0" 
$ns at 674.29437570982 "$node_(75) setdest 22072 77220 2.0" 
$ns at 719.7288269129131 "$node_(75) setdest 11735 8304 1.0" 
$ns at 753.7544899967055 "$node_(75) setdest 42338 29287 2.0" 
$ns at 794.8078352637589 "$node_(75) setdest 168761 34690 7.0" 
$ns at 856.6350761213766 "$node_(75) setdest 4483 89347 12.0" 
$ns at 0.0 "$node_(76) setdest 47758 2954 20.0" 
$ns at 176.29693077845874 "$node_(76) setdest 44177 32726 12.0" 
$ns at 227.0695647793909 "$node_(76) setdest 44127 16903 1.0" 
$ns at 266.04894949386915 "$node_(76) setdest 9542 3110 17.0" 
$ns at 297.8533755446838 "$node_(76) setdest 72094 47225 6.0" 
$ns at 351.94104480623025 "$node_(76) setdest 37805 24835 19.0" 
$ns at 438.99581375655254 "$node_(76) setdest 121644 60174 16.0" 
$ns at 603.6849288990367 "$node_(76) setdest 98891 59643 15.0" 
$ns at 762.0452766717669 "$node_(76) setdest 37433 7771 9.0" 
$ns at 848.1108078039362 "$node_(76) setdest 100680 57797 10.0" 
$ns at 0.0 "$node_(77) setdest 88889 2130 6.0" 
$ns at 50.643079582042645 "$node_(77) setdest 54534 18412 4.0" 
$ns at 100.88923596439555 "$node_(77) setdest 32012 26418 15.0" 
$ns at 226.36828131267237 "$node_(77) setdest 31505 35762 10.0" 
$ns at 326.5708983294012 "$node_(77) setdest 66889 20412 15.0" 
$ns at 417.2098973481043 "$node_(77) setdest 76897 56151 14.0" 
$ns at 537.8808688742272 "$node_(77) setdest 108074 42369 17.0" 
$ns at 682.4567673813802 "$node_(77) setdest 57979 15151 14.0" 
$ns at 837.1835338194378 "$node_(77) setdest 74440 37616 15.0" 
$ns at 0.0 "$node_(78) setdest 27848 18186 7.0" 
$ns at 91.55281101094926 "$node_(78) setdest 60237 10064 18.0" 
$ns at 251.182260960676 "$node_(78) setdest 45841 43921 16.0" 
$ns at 392.34714701946166 "$node_(78) setdest 139022 8034 14.0" 
$ns at 457.4419628956812 "$node_(78) setdest 97414 30650 16.0" 
$ns at 522.1121532820507 "$node_(78) setdest 193029 63242 5.0" 
$ns at 580.89669152782 "$node_(78) setdest 168601 10300 7.0" 
$ns at 649.1020690846675 "$node_(78) setdest 10826 74831 4.0" 
$ns at 696.6973919348254 "$node_(78) setdest 40777 77271 1.0" 
$ns at 734.4025151503188 "$node_(78) setdest 230527 57972 13.0" 
$ns at 858.0448913957696 "$node_(78) setdest 107367 44183 9.0" 
$ns at 0.0 "$node_(79) setdest 39746 12736 16.0" 
$ns at 85.18645052282432 "$node_(79) setdest 22176 25636 10.0" 
$ns at 125.33476485474682 "$node_(79) setdest 72173 16840 15.0" 
$ns at 226.9178972807071 "$node_(79) setdest 33286 24862 1.0" 
$ns at 260.989394915874 "$node_(79) setdest 3341 3551 1.0" 
$ns at 295.23725230991005 "$node_(79) setdest 71569 8845 7.0" 
$ns at 377.78106416997815 "$node_(79) setdest 121225 41962 17.0" 
$ns at 574.0251940062024 "$node_(79) setdest 10666 35409 17.0" 
$ns at 754.8214192311626 "$node_(79) setdest 199422 13650 16.0" 
$ns at 806.5696884404423 "$node_(79) setdest 41886 18253 7.0" 
$ns at 867.75545127926 "$node_(79) setdest 107036 20932 16.0" 
$ns at 0.0 "$node_(80) setdest 66258 1019 19.0" 
$ns at 104.2047038018572 "$node_(80) setdest 15220 18562 15.0" 
$ns at 177.0835872165519 "$node_(80) setdest 125466 24652 1.0" 
$ns at 211.9060135594081 "$node_(80) setdest 71140 33328 4.0" 
$ns at 248.87076821616375 "$node_(80) setdest 82946 29279 18.0" 
$ns at 290.9912043662815 "$node_(80) setdest 31341 21680 5.0" 
$ns at 342.87333704229707 "$node_(80) setdest 52896 15723 8.0" 
$ns at 435.5316956980738 "$node_(80) setdest 23219 62861 9.0" 
$ns at 471.8775192379591 "$node_(80) setdest 145733 13624 15.0" 
$ns at 502.9110322641395 "$node_(80) setdest 205994 59301 10.0" 
$ns at 619.4215566077876 "$node_(80) setdest 131228 32285 18.0" 
$ns at 672.953812446803 "$node_(80) setdest 69809 333 10.0" 
$ns at 767.7417390834134 "$node_(80) setdest 80147 51674 9.0" 
$ns at 887.5178064194756 "$node_(80) setdest 117042 68835 17.0" 
$ns at 0.0 "$node_(81) setdest 60056 5690 13.0" 
$ns at 39.907169164851084 "$node_(81) setdest 45940 14104 7.0" 
$ns at 110.64340332618168 "$node_(81) setdest 93462 15410 3.0" 
$ns at 146.97400916312534 "$node_(81) setdest 9979 23358 10.0" 
$ns at 255.28186847331716 "$node_(81) setdest 11730 39802 11.0" 
$ns at 288.0762470651637 "$node_(81) setdest 72133 2474 17.0" 
$ns at 481.8186561823346 "$node_(81) setdest 26205 45277 15.0" 
$ns at 558.8076130143123 "$node_(81) setdest 133621 25643 5.0" 
$ns at 622.962835499057 "$node_(81) setdest 43035 50946 3.0" 
$ns at 682.9407827678133 "$node_(81) setdest 209980 39932 16.0" 
$ns at 851.7123043345784 "$node_(81) setdest 60504 18406 11.0" 
$ns at 0.0 "$node_(82) setdest 20973 7756 1.0" 
$ns at 34.43769841699121 "$node_(82) setdest 5581 29316 9.0" 
$ns at 115.79275032401846 "$node_(82) setdest 57770 8010 5.0" 
$ns at 182.11899264231903 "$node_(82) setdest 41455 36906 7.0" 
$ns at 279.38420927081813 "$node_(82) setdest 99392 33350 18.0" 
$ns at 399.1235926952551 "$node_(82) setdest 171830 38476 14.0" 
$ns at 495.8463259928943 "$node_(82) setdest 26368 6505 12.0" 
$ns at 526.024699213904 "$node_(82) setdest 180669 52885 20.0" 
$ns at 608.7557967132117 "$node_(82) setdest 20607 2563 5.0" 
$ns at 653.2302066547447 "$node_(82) setdest 62714 2057 18.0" 
$ns at 756.4752889722265 "$node_(82) setdest 226141 25136 13.0" 
$ns at 871.5220151678344 "$node_(82) setdest 221761 51832 18.0" 
$ns at 0.0 "$node_(83) setdest 14909 28625 6.0" 
$ns at 34.67242730514774 "$node_(83) setdest 41824 23421 12.0" 
$ns at 120.81944324683269 "$node_(83) setdest 88152 16637 20.0" 
$ns at 335.1359840730445 "$node_(83) setdest 52424 7895 1.0" 
$ns at 368.92952533843777 "$node_(83) setdest 179515 26539 17.0" 
$ns at 450.9060621514696 "$node_(83) setdest 211947 65029 17.0" 
$ns at 620.6808667027747 "$node_(83) setdest 75014 61085 20.0" 
$ns at 828.6391045815177 "$node_(83) setdest 61082 85836 14.0" 
$ns at 0.0 "$node_(84) setdest 45377 26788 8.0" 
$ns at 30.650948265098652 "$node_(84) setdest 27929 17146 18.0" 
$ns at 61.46383444959172 "$node_(84) setdest 72473 19334 4.0" 
$ns at 106.24103461268226 "$node_(84) setdest 51659 26125 12.0" 
$ns at 143.9806065465725 "$node_(84) setdest 10069 17145 5.0" 
$ns at 212.78726439835273 "$node_(84) setdest 7495 44237 5.0" 
$ns at 263.4282537992931 "$node_(84) setdest 45665 23714 10.0" 
$ns at 350.5739991897717 "$node_(84) setdest 136575 1745 20.0" 
$ns at 423.6073561842212 "$node_(84) setdest 125504 11939 6.0" 
$ns at 499.84842080440626 "$node_(84) setdest 45470 34475 13.0" 
$ns at 591.6749655246563 "$node_(84) setdest 143106 30192 9.0" 
$ns at 629.2265416959991 "$node_(84) setdest 141059 50135 4.0" 
$ns at 698.1553157129782 "$node_(84) setdest 203936 65637 13.0" 
$ns at 765.4934852482377 "$node_(84) setdest 154696 82263 5.0" 
$ns at 845.2285162926701 "$node_(84) setdest 40901 9575 8.0" 
$ns at 0.0 "$node_(85) setdest 46576 15677 19.0" 
$ns at 66.92777716784535 "$node_(85) setdest 12112 27286 1.0" 
$ns at 100.6379577808301 "$node_(85) setdest 78852 15686 8.0" 
$ns at 143.7695384512683 "$node_(85) setdest 70293 30915 2.0" 
$ns at 178.63617245202397 "$node_(85) setdest 93568 6840 3.0" 
$ns at 224.9986236344169 "$node_(85) setdest 46485 20291 17.0" 
$ns at 422.17777541739906 "$node_(85) setdest 73523 49995 8.0" 
$ns at 513.3386852229637 "$node_(85) setdest 5330 30345 15.0" 
$ns at 686.306591782493 "$node_(85) setdest 71532 52104 9.0" 
$ns at 781.4884870811045 "$node_(85) setdest 95928 25265 3.0" 
$ns at 818.0489075791792 "$node_(85) setdest 146346 57237 5.0" 
$ns at 849.7119485863531 "$node_(85) setdest 189982 60804 10.0" 
$ns at 895.4969608578549 "$node_(85) setdest 85576 9075 11.0" 
$ns at 0.0 "$node_(86) setdest 36362 22355 1.0" 
$ns at 30.71847996695359 "$node_(86) setdest 47229 12848 1.0" 
$ns at 67.82622868332889 "$node_(86) setdest 26385 15241 12.0" 
$ns at 158.90613751698544 "$node_(86) setdest 30449 16058 15.0" 
$ns at 310.6180658618994 "$node_(86) setdest 143355 48906 12.0" 
$ns at 371.47477417805084 "$node_(86) setdest 126224 6474 13.0" 
$ns at 500.559335034614 "$node_(86) setdest 146860 25051 4.0" 
$ns at 539.0318662652493 "$node_(86) setdest 156389 16562 14.0" 
$ns at 598.4830824076525 "$node_(86) setdest 139086 56386 13.0" 
$ns at 703.5321405609689 "$node_(86) setdest 216340 73677 19.0" 
$ns at 785.7831883046347 "$node_(86) setdest 138421 71741 6.0" 
$ns at 822.2328193121479 "$node_(86) setdest 241014 66387 8.0" 
$ns at 0.0 "$node_(87) setdest 44236 30778 20.0" 
$ns at 98.73352947757598 "$node_(87) setdest 75365 12187 2.0" 
$ns at 129.38330966010454 "$node_(87) setdest 1862 824 10.0" 
$ns at 164.99959089018603 "$node_(87) setdest 91320 13253 17.0" 
$ns at 322.3935592412934 "$node_(87) setdest 86204 8446 18.0" 
$ns at 414.85761788211005 "$node_(87) setdest 74400 29633 11.0" 
$ns at 473.7702215251917 "$node_(87) setdest 155711 43776 4.0" 
$ns at 508.59456184896453 "$node_(87) setdest 140350 38363 14.0" 
$ns at 578.9167137756389 "$node_(87) setdest 159579 53332 1.0" 
$ns at 617.7090087209199 "$node_(87) setdest 109143 59487 8.0" 
$ns at 652.8419388503467 "$node_(87) setdest 241028 62881 6.0" 
$ns at 685.8907410412188 "$node_(87) setdest 72896 25702 1.0" 
$ns at 718.8070995820699 "$node_(87) setdest 164973 63038 4.0" 
$ns at 761.0332505302897 "$node_(87) setdest 59453 58127 18.0" 
$ns at 791.9655908032634 "$node_(87) setdest 198162 30845 9.0" 
$ns at 873.1992446191676 "$node_(87) setdest 63532 14177 6.0" 
$ns at 0.0 "$node_(88) setdest 53752 12359 19.0" 
$ns at 160.7885844849573 "$node_(88) setdest 6528 624 15.0" 
$ns at 251.05571290875997 "$node_(88) setdest 127014 40148 15.0" 
$ns at 424.611007652432 "$node_(88) setdest 60864 5112 6.0" 
$ns at 465.729284318246 "$node_(88) setdest 172229 24778 20.0" 
$ns at 687.748817853692 "$node_(88) setdest 54416 38659 6.0" 
$ns at 763.9070935686193 "$node_(88) setdest 218509 27983 2.0" 
$ns at 802.7205658700873 "$node_(88) setdest 140910 68193 12.0" 
$ns at 0.0 "$node_(89) setdest 57442 5429 1.0" 
$ns at 31.49053545275258 "$node_(89) setdest 80399 10439 14.0" 
$ns at 194.57833316689897 "$node_(89) setdest 134006 30517 19.0" 
$ns at 391.74746011432666 "$node_(89) setdest 111800 63028 18.0" 
$ns at 584.8445048040462 "$node_(89) setdest 169659 287 18.0" 
$ns at 642.6373070542811 "$node_(89) setdest 172068 6446 18.0" 
$ns at 748.2418155072687 "$node_(89) setdest 161803 64200 13.0" 
$ns at 811.4877032370613 "$node_(89) setdest 183891 62229 4.0" 
$ns at 868.9505154359349 "$node_(89) setdest 304 59344 1.0" 
$ns at 0.0 "$node_(90) setdest 50137 18157 10.0" 
$ns at 56.28200440324159 "$node_(90) setdest 494 13789 3.0" 
$ns at 100.09251312350497 "$node_(90) setdest 64201 614 3.0" 
$ns at 134.76960574610834 "$node_(90) setdest 88803 13676 19.0" 
$ns at 178.95385430961494 "$node_(90) setdest 89087 29746 13.0" 
$ns at 251.95849875869317 "$node_(90) setdest 78802 5622 10.0" 
$ns at 370.59992933536813 "$node_(90) setdest 86934 7256 20.0" 
$ns at 594.7862479893512 "$node_(90) setdest 30398 7075 7.0" 
$ns at 683.1425734552301 "$node_(90) setdest 185220 59634 14.0" 
$ns at 723.425725336183 "$node_(90) setdest 195722 68492 12.0" 
$ns at 791.6106979574914 "$node_(90) setdest 235567 86827 6.0" 
$ns at 834.2973634585998 "$node_(90) setdest 226223 62000 3.0" 
$ns at 879.4125134287801 "$node_(90) setdest 169158 37239 14.0" 
$ns at 0.0 "$node_(91) setdest 52678 11146 16.0" 
$ns at 129.6974173032429 "$node_(91) setdest 70401 28014 11.0" 
$ns at 205.0789496588085 "$node_(91) setdest 37951 25706 1.0" 
$ns at 237.57677508697395 "$node_(91) setdest 133314 23679 1.0" 
$ns at 268.4439406813369 "$node_(91) setdest 160111 41497 9.0" 
$ns at 365.39785776769196 "$node_(91) setdest 76114 3073 14.0" 
$ns at 468.6015939944649 "$node_(91) setdest 23311 7526 5.0" 
$ns at 514.9388462005437 "$node_(91) setdest 120241 66114 15.0" 
$ns at 572.909878788226 "$node_(91) setdest 177265 71962 14.0" 
$ns at 671.7975446413516 "$node_(91) setdest 104943 61196 5.0" 
$ns at 716.2203617400751 "$node_(91) setdest 160162 56863 9.0" 
$ns at 810.267983960577 "$node_(91) setdest 220785 52136 12.0" 
$ns at 841.71402500101 "$node_(91) setdest 53422 57908 4.0" 
$ns at 897.3666041269717 "$node_(91) setdest 219749 53512 3.0" 
$ns at 0.0 "$node_(92) setdest 23452 13713 20.0" 
$ns at 86.96789153896205 "$node_(92) setdest 42434 25045 12.0" 
$ns at 131.57947227806216 "$node_(92) setdest 53805 19367 14.0" 
$ns at 276.7570144204839 "$node_(92) setdest 69859 34228 20.0" 
$ns at 314.9119743694847 "$node_(92) setdest 82361 12030 12.0" 
$ns at 352.4414195718619 "$node_(92) setdest 28372 26213 17.0" 
$ns at 526.9850549202646 "$node_(92) setdest 120056 68141 18.0" 
$ns at 686.5487279116558 "$node_(92) setdest 192768 11120 8.0" 
$ns at 790.4020432489434 "$node_(92) setdest 127223 27173 2.0" 
$ns at 840.0249989737742 "$node_(92) setdest 81965 32552 10.0" 
$ns at 0.0 "$node_(93) setdest 16698 24981 3.0" 
$ns at 31.95220542615419 "$node_(93) setdest 8086 13808 11.0" 
$ns at 62.00166154849495 "$node_(93) setdest 74222 9747 9.0" 
$ns at 157.6441157129064 "$node_(93) setdest 125127 299 11.0" 
$ns at 234.90485043480734 "$node_(93) setdest 64817 5698 5.0" 
$ns at 311.74799261758585 "$node_(93) setdest 147791 33075 10.0" 
$ns at 408.4767465200983 "$node_(93) setdest 156459 56310 3.0" 
$ns at 442.53094412292995 "$node_(93) setdest 94351 57945 18.0" 
$ns at 610.3132406789548 "$node_(93) setdest 222834 73209 5.0" 
$ns at 683.1732752342022 "$node_(93) setdest 170338 69378 5.0" 
$ns at 731.2148203741604 "$node_(93) setdest 182826 55256 16.0" 
$ns at 857.2762072019409 "$node_(93) setdest 14311 43916 11.0" 
$ns at 0.0 "$node_(94) setdest 66286 19593 5.0" 
$ns at 39.520300444273026 "$node_(94) setdest 7491 29136 9.0" 
$ns at 152.78182807397715 "$node_(94) setdest 67601 37464 3.0" 
$ns at 185.41019280677514 "$node_(94) setdest 28660 41849 8.0" 
$ns at 244.75273457561127 "$node_(94) setdest 15578 17761 3.0" 
$ns at 285.0263396040706 "$node_(94) setdest 44220 22074 12.0" 
$ns at 363.18437257814696 "$node_(94) setdest 171614 9136 1.0" 
$ns at 394.75667415812677 "$node_(94) setdest 85932 6692 12.0" 
$ns at 452.2965088904691 "$node_(94) setdest 126181 24394 14.0" 
$ns at 518.8541898723056 "$node_(94) setdest 177585 51250 19.0" 
$ns at 690.1377503653192 "$node_(94) setdest 124207 36676 18.0" 
$ns at 820.1403611432004 "$node_(94) setdest 65227 63910 1.0" 
$ns at 851.3396112508995 "$node_(94) setdest 160315 25946 5.0" 
$ns at 0.0 "$node_(95) setdest 73908 2900 5.0" 
$ns at 78.04934910602636 "$node_(95) setdest 40366 18452 9.0" 
$ns at 184.88381799623954 "$node_(95) setdest 69819 18093 3.0" 
$ns at 231.96264021049257 "$node_(95) setdest 98122 11035 12.0" 
$ns at 262.5513779531658 "$node_(95) setdest 11429 22100 18.0" 
$ns at 325.82498613315624 "$node_(95) setdest 68143 3245 16.0" 
$ns at 457.76278570056377 "$node_(95) setdest 208872 12868 10.0" 
$ns at 514.6004329056412 "$node_(95) setdest 57581 58844 19.0" 
$ns at 572.517526194113 "$node_(95) setdest 73140 62573 12.0" 
$ns at 621.9856028895157 "$node_(95) setdest 101649 62555 9.0" 
$ns at 719.120373805352 "$node_(95) setdest 183319 59712 10.0" 
$ns at 820.2391455942039 "$node_(95) setdest 171752 15250 19.0" 
$ns at 0.0 "$node_(96) setdest 93630 11607 6.0" 
$ns at 70.49593657338092 "$node_(96) setdest 58928 25892 19.0" 
$ns at 113.09450927736574 "$node_(96) setdest 67382 31256 7.0" 
$ns at 144.10787399850523 "$node_(96) setdest 32641 24824 8.0" 
$ns at 225.00002209029878 "$node_(96) setdest 99480 15121 18.0" 
$ns at 324.1915611210065 "$node_(96) setdest 139487 52318 13.0" 
$ns at 402.57403652233353 "$node_(96) setdest 100647 53164 19.0" 
$ns at 511.04312543374044 "$node_(96) setdest 184239 69201 10.0" 
$ns at 562.5822117415573 "$node_(96) setdest 73315 43830 9.0" 
$ns at 646.7968198325822 "$node_(96) setdest 132234 39778 13.0" 
$ns at 770.1486947178636 "$node_(96) setdest 20871 74942 8.0" 
$ns at 874.5926609061527 "$node_(96) setdest 7475 18144 12.0" 
$ns at 0.0 "$node_(97) setdest 48272 15473 6.0" 
$ns at 59.243777885022475 "$node_(97) setdest 29648 796 5.0" 
$ns at 133.37999950356027 "$node_(97) setdest 45465 1002 14.0" 
$ns at 265.13652156420125 "$node_(97) setdest 45004 50095 9.0" 
$ns at 295.2467981577314 "$node_(97) setdest 122737 14331 8.0" 
$ns at 338.5992790794479 "$node_(97) setdest 68467 43542 10.0" 
$ns at 404.9123973256728 "$node_(97) setdest 169513 4504 6.0" 
$ns at 472.1145526223771 "$node_(97) setdest 97740 29831 20.0" 
$ns at 511.94355571292397 "$node_(97) setdest 153969 34172 17.0" 
$ns at 590.4550344897075 "$node_(97) setdest 106064 52539 18.0" 
$ns at 696.0268708387898 "$node_(97) setdest 159089 15101 6.0" 
$ns at 743.1417307306974 "$node_(97) setdest 142337 18166 10.0" 
$ns at 796.4561505587645 "$node_(97) setdest 171429 4295 10.0" 
$ns at 874.2532725244874 "$node_(97) setdest 236753 53326 15.0" 
$ns at 0.0 "$node_(98) setdest 11815 15781 17.0" 
$ns at 136.8663408619015 "$node_(98) setdest 83016 9468 16.0" 
$ns at 325.9713436670347 "$node_(98) setdest 79869 33021 14.0" 
$ns at 393.80908233173056 "$node_(98) setdest 69382 18289 7.0" 
$ns at 476.1405205474382 "$node_(98) setdest 39785 20185 4.0" 
$ns at 539.634744719732 "$node_(98) setdest 22614 69611 1.0" 
$ns at 577.4216602419679 "$node_(98) setdest 224200 9364 6.0" 
$ns at 661.629624420414 "$node_(98) setdest 88022 67669 17.0" 
$ns at 772.1524203503208 "$node_(98) setdest 43577 43351 18.0" 
$ns at 0.0 "$node_(99) setdest 1561 22237 1.0" 
$ns at 39.466461874191 "$node_(99) setdest 42033 2761 14.0" 
$ns at 151.44681847877794 "$node_(99) setdest 42085 11091 19.0" 
$ns at 206.47534328894443 "$node_(99) setdest 47992 7071 12.0" 
$ns at 240.67162575375016 "$node_(99) setdest 126447 12908 10.0" 
$ns at 369.1608399951912 "$node_(99) setdest 97610 50536 18.0" 
$ns at 519.4585624194517 "$node_(99) setdest 48638 14813 6.0" 
$ns at 564.6472791045478 "$node_(99) setdest 77797 21485 20.0" 
$ns at 737.4307984455379 "$node_(99) setdest 204021 20977 16.0" 
$ns at 850.2945613370684 "$node_(99) setdest 170473 24822 2.0" 
$ns at 885.29134969218 "$node_(99) setdest 199552 45822 17.0" 
$ns at 0.0 "$node_(100) setdest 70201 17041 10.0" 
$ns at 76.8732095832545 "$node_(100) setdest 14792 24143 9.0" 
$ns at 162.7302925213404 "$node_(100) setdest 46141 13175 20.0" 
$ns at 333.3587335196745 "$node_(100) setdest 91184 34887 13.0" 
$ns at 482.1303842960183 "$node_(100) setdest 141853 42077 20.0" 
$ns at 570.8187068082586 "$node_(100) setdest 68166 23111 4.0" 
$ns at 638.0987816749634 "$node_(100) setdest 130494 924 13.0" 
$ns at 750.047385848653 "$node_(100) setdest 134217 36545 16.0" 
$ns at 887.2459445795639 "$node_(100) setdest 164331 46144 3.0" 
$ns at 197.1652027523715 "$node_(101) setdest 114063 18718 15.0" 
$ns at 343.8243073876598 "$node_(101) setdest 148394 25060 2.0" 
$ns at 389.22386209082833 "$node_(101) setdest 143679 11427 9.0" 
$ns at 495.0022997241142 "$node_(101) setdest 107325 19218 17.0" 
$ns at 553.3687649442262 "$node_(101) setdest 72137 53001 19.0" 
$ns at 637.1515800168718 "$node_(101) setdest 172088 43481 10.0" 
$ns at 673.9753348887868 "$node_(101) setdest 6208 12525 10.0" 
$ns at 780.9664322419359 "$node_(101) setdest 228002 38130 6.0" 
$ns at 851.4842300846478 "$node_(101) setdest 61654 4215 10.0" 
$ns at 164.46915358643835 "$node_(102) setdest 69195 36189 7.0" 
$ns at 221.08325170121066 "$node_(102) setdest 13101 29566 3.0" 
$ns at 279.12185967422647 "$node_(102) setdest 150428 43667 10.0" 
$ns at 400.3203870714877 "$node_(102) setdest 99022 24546 5.0" 
$ns at 437.31660309192955 "$node_(102) setdest 143644 6812 10.0" 
$ns at 496.047294859521 "$node_(102) setdest 88031 10824 10.0" 
$ns at 602.9319722014385 "$node_(102) setdest 220058 66948 18.0" 
$ns at 734.0772032456673 "$node_(102) setdest 53708 52728 9.0" 
$ns at 846.8872544229791 "$node_(102) setdest 14256 47213 18.0" 
$ns at 144.68176440492292 "$node_(103) setdest 10998 3466 16.0" 
$ns at 234.90162653948133 "$node_(103) setdest 6777 20317 3.0" 
$ns at 271.58371501716147 "$node_(103) setdest 56572 29128 20.0" 
$ns at 357.0453424610794 "$node_(103) setdest 121940 55597 1.0" 
$ns at 393.8484374699651 "$node_(103) setdest 170726 45236 13.0" 
$ns at 474.65492308472307 "$node_(103) setdest 145647 46706 11.0" 
$ns at 608.8901584748323 "$node_(103) setdest 164686 24957 11.0" 
$ns at 707.4494945844954 "$node_(103) setdest 173862 34858 15.0" 
$ns at 876.0857797927688 "$node_(103) setdest 140266 51641 13.0" 
$ns at 156.26026505876825 "$node_(104) setdest 33959 43052 11.0" 
$ns at 211.26372642697652 "$node_(104) setdest 46888 17174 14.0" 
$ns at 282.73426595370404 "$node_(104) setdest 139418 18600 7.0" 
$ns at 363.31874844827973 "$node_(104) setdest 92711 9834 17.0" 
$ns at 492.8869312635746 "$node_(104) setdest 43610 54334 12.0" 
$ns at 523.4562922796276 "$node_(104) setdest 174514 55912 20.0" 
$ns at 683.1525344829275 "$node_(104) setdest 213546 45542 18.0" 
$ns at 887.0598933989932 "$node_(104) setdest 153919 51606 1.0" 
$ns at 126.53899365313379 "$node_(105) setdest 85301 19969 16.0" 
$ns at 207.9979367418582 "$node_(105) setdest 76700 17470 6.0" 
$ns at 271.19649803541523 "$node_(105) setdest 154905 11219 18.0" 
$ns at 405.4732245603444 "$node_(105) setdest 60424 34542 9.0" 
$ns at 494.58666757992677 "$node_(105) setdest 132850 3563 5.0" 
$ns at 571.4618465931616 "$node_(105) setdest 179752 38477 4.0" 
$ns at 640.449026619759 "$node_(105) setdest 839 48529 8.0" 
$ns at 699.4984957089429 "$node_(105) setdest 16899 65762 12.0" 
$ns at 830.6466506484999 "$node_(105) setdest 235493 88108 17.0" 
$ns at 101.42989379776797 "$node_(106) setdest 52102 27535 10.0" 
$ns at 206.33531516786496 "$node_(106) setdest 91443 40734 20.0" 
$ns at 240.10018974851903 "$node_(106) setdest 32642 8623 9.0" 
$ns at 302.85928960021647 "$node_(106) setdest 105650 5116 12.0" 
$ns at 346.74348478423923 "$node_(106) setdest 32926 35047 9.0" 
$ns at 392.45944733977655 "$node_(106) setdest 88675 50118 5.0" 
$ns at 458.0058237465306 "$node_(106) setdest 142437 32240 2.0" 
$ns at 502.8020855635634 "$node_(106) setdest 78281 21327 3.0" 
$ns at 533.7217163430881 "$node_(106) setdest 64704 45851 7.0" 
$ns at 593.826237648955 "$node_(106) setdest 68438 75841 8.0" 
$ns at 700.4176864003806 "$node_(106) setdest 166708 12289 20.0" 
$ns at 125.42522254430996 "$node_(107) setdest 70617 23285 8.0" 
$ns at 182.28441653613214 "$node_(107) setdest 74483 18183 1.0" 
$ns at 220.64978746083025 "$node_(107) setdest 79271 4341 7.0" 
$ns at 290.78585955310047 "$node_(107) setdest 127961 28557 14.0" 
$ns at 403.1910397164322 "$node_(107) setdest 40740 36420 13.0" 
$ns at 471.03414282839947 "$node_(107) setdest 78383 30845 18.0" 
$ns at 573.9486305401404 "$node_(107) setdest 184993 23079 18.0" 
$ns at 776.6776577637839 "$node_(107) setdest 256761 20143 14.0" 
$ns at 813.839856434603 "$node_(107) setdest 129239 69113 11.0" 
$ns at 873.0208133373925 "$node_(107) setdest 205398 35953 15.0" 
$ns at 100.48906615165912 "$node_(108) setdest 52974 14339 18.0" 
$ns at 289.7327048813245 "$node_(108) setdest 40818 42260 20.0" 
$ns at 325.5200424472135 "$node_(108) setdest 6703 6673 1.0" 
$ns at 365.32338180995475 "$node_(108) setdest 184437 11213 1.0" 
$ns at 399.3284907391966 "$node_(108) setdest 61943 22450 13.0" 
$ns at 501.0373271168317 "$node_(108) setdest 126327 34598 1.0" 
$ns at 540.8546121145656 "$node_(108) setdest 36778 34687 12.0" 
$ns at 621.3673457749871 "$node_(108) setdest 22113 18850 4.0" 
$ns at 683.4074464851944 "$node_(108) setdest 150273 19293 1.0" 
$ns at 723.3744296578759 "$node_(108) setdest 168278 63347 13.0" 
$ns at 782.92867035983 "$node_(108) setdest 5922 17030 1.0" 
$ns at 813.4705634218282 "$node_(108) setdest 36785 30042 9.0" 
$ns at 894.1212960268087 "$node_(108) setdest 33490 82463 6.0" 
$ns at 128.07099970524538 "$node_(109) setdest 68987 14539 18.0" 
$ns at 305.8706755434969 "$node_(109) setdest 35541 40177 8.0" 
$ns at 359.8823745688657 "$node_(109) setdest 32845 2970 17.0" 
$ns at 527.3215641354086 "$node_(109) setdest 147574 69548 6.0" 
$ns at 575.9962959121738 "$node_(109) setdest 54589 11485 1.0" 
$ns at 610.3546213097203 "$node_(109) setdest 181563 10423 14.0" 
$ns at 759.1539721210796 "$node_(109) setdest 9666 73587 9.0" 
$ns at 798.3682270839254 "$node_(109) setdest 54027 64168 6.0" 
$ns at 862.6605382220002 "$node_(109) setdest 268256 68279 20.0" 
$ns at 112.9084487811931 "$node_(110) setdest 55328 21944 15.0" 
$ns at 144.43742815547367 "$node_(110) setdest 46879 11501 3.0" 
$ns at 203.05412745867847 "$node_(110) setdest 44247 1277 9.0" 
$ns at 241.0786799794937 "$node_(110) setdest 116377 1062 17.0" 
$ns at 428.73707208286305 "$node_(110) setdest 41545 56995 13.0" 
$ns at 520.5683240768132 "$node_(110) setdest 104265 15200 11.0" 
$ns at 628.4948463073421 "$node_(110) setdest 116213 33589 6.0" 
$ns at 701.8941876365906 "$node_(110) setdest 181104 27274 3.0" 
$ns at 741.4916488338887 "$node_(110) setdest 155749 51747 17.0" 
$ns at 796.3931567299343 "$node_(110) setdest 88030 29335 1.0" 
$ns at 832.5667688143686 "$node_(110) setdest 109177 83748 14.0" 
$ns at 167.29357295910674 "$node_(111) setdest 100247 4895 3.0" 
$ns at 220.049409013617 "$node_(111) setdest 9355 215 16.0" 
$ns at 250.3756201335537 "$node_(111) setdest 16323 52975 10.0" 
$ns at 325.4393737697078 "$node_(111) setdest 71105 26056 19.0" 
$ns at 525.847504638483 "$node_(111) setdest 175122 44295 15.0" 
$ns at 673.9742608807142 "$node_(111) setdest 189218 10759 8.0" 
$ns at 775.8162485735179 "$node_(111) setdest 47435 66684 17.0" 
$ns at 884.3937421779649 "$node_(111) setdest 168258 50742 4.0" 
$ns at 185.73432044166168 "$node_(112) setdest 51398 11175 3.0" 
$ns at 233.16866312233304 "$node_(112) setdest 82949 35350 3.0" 
$ns at 291.5337466732121 "$node_(112) setdest 10512 17270 17.0" 
$ns at 402.47215204001213 "$node_(112) setdest 132413 7905 16.0" 
$ns at 544.2027135126423 "$node_(112) setdest 197981 4426 9.0" 
$ns at 589.4517086004097 "$node_(112) setdest 16066 75267 8.0" 
$ns at 648.3023888071614 "$node_(112) setdest 122634 68745 19.0" 
$ns at 775.1932489096844 "$node_(112) setdest 6815 17358 18.0" 
$ns at 894.1792890701583 "$node_(112) setdest 162878 2217 15.0" 
$ns at 124.10267692624637 "$node_(113) setdest 83800 31493 1.0" 
$ns at 164.06464311289378 "$node_(113) setdest 64580 8850 14.0" 
$ns at 266.812644676819 "$node_(113) setdest 75435 30691 6.0" 
$ns at 303.1274232302824 "$node_(113) setdest 6770 49456 14.0" 
$ns at 338.5847371305248 "$node_(113) setdest 32145 4975 2.0" 
$ns at 386.3977511266403 "$node_(113) setdest 94058 11924 6.0" 
$ns at 434.2240441746377 "$node_(113) setdest 25260 6889 5.0" 
$ns at 507.45454171886877 "$node_(113) setdest 152180 4764 2.0" 
$ns at 553.4547331587645 "$node_(113) setdest 58876 70808 1.0" 
$ns at 589.4147730970436 "$node_(113) setdest 81036 26074 8.0" 
$ns at 656.8522033990935 "$node_(113) setdest 67971 83566 19.0" 
$ns at 737.7807262285761 "$node_(113) setdest 237502 76650 19.0" 
$ns at 822.2780140156606 "$node_(113) setdest 100963 67272 12.0" 
$ns at 146.69548293981475 "$node_(114) setdest 62298 28703 2.0" 
$ns at 191.17647080832592 "$node_(114) setdest 37737 42787 14.0" 
$ns at 278.74375635438264 "$node_(114) setdest 142363 16599 19.0" 
$ns at 388.01801517624284 "$node_(114) setdest 168208 43644 17.0" 
$ns at 573.9899175416942 "$node_(114) setdest 148245 49351 8.0" 
$ns at 666.9897112693769 "$node_(114) setdest 165189 75165 19.0" 
$ns at 821.3967867167157 "$node_(114) setdest 119287 22093 8.0" 
$ns at 204.1295750065217 "$node_(115) setdest 60641 7013 11.0" 
$ns at 244.49468827445827 "$node_(115) setdest 108176 841 14.0" 
$ns at 380.0489226289436 "$node_(115) setdest 74152 40405 1.0" 
$ns at 415.3118743627598 "$node_(115) setdest 176860 55047 12.0" 
$ns at 529.3830423178474 "$node_(115) setdest 74906 31869 5.0" 
$ns at 599.2581591768994 "$node_(115) setdest 120943 51266 19.0" 
$ns at 738.7753445001497 "$node_(115) setdest 1988 57309 13.0" 
$ns at 847.707926358897 "$node_(115) setdest 202167 34785 12.0" 
$ns at 204.12516978653784 "$node_(116) setdest 36091 9419 1.0" 
$ns at 240.4708347087447 "$node_(116) setdest 82433 25308 14.0" 
$ns at 363.4156333952311 "$node_(116) setdest 50366 2244 3.0" 
$ns at 405.71413016639605 "$node_(116) setdest 66528 28934 1.0" 
$ns at 444.94719283241744 "$node_(116) setdest 12927 58299 5.0" 
$ns at 477.095440913254 "$node_(116) setdest 167901 4726 16.0" 
$ns at 540.8195505744388 "$node_(116) setdest 84165 22036 19.0" 
$ns at 755.617054703231 "$node_(116) setdest 230296 167 13.0" 
$ns at 230.04581145004556 "$node_(117) setdest 19538 41930 3.0" 
$ns at 271.2138392400856 "$node_(117) setdest 118984 14860 7.0" 
$ns at 326.8347313317528 "$node_(117) setdest 115827 49203 7.0" 
$ns at 375.1597309619291 "$node_(117) setdest 15327 47735 15.0" 
$ns at 445.0833165170735 "$node_(117) setdest 155335 58767 3.0" 
$ns at 496.82737170670293 "$node_(117) setdest 202533 32431 5.0" 
$ns at 536.2046661705524 "$node_(117) setdest 187613 67443 3.0" 
$ns at 595.2848163675035 "$node_(117) setdest 66813 19610 12.0" 
$ns at 648.1683183449159 "$node_(117) setdest 197905 61028 18.0" 
$ns at 717.002096707359 "$node_(117) setdest 147432 81624 1.0" 
$ns at 756.9700036098805 "$node_(117) setdest 17360 67706 16.0" 
$ns at 800.003703340502 "$node_(117) setdest 91912 30182 17.0" 
$ns at 179.86108214165802 "$node_(118) setdest 49731 38321 7.0" 
$ns at 221.12897619754534 "$node_(118) setdest 3385 25182 16.0" 
$ns at 400.4895003439271 "$node_(118) setdest 72849 29981 14.0" 
$ns at 442.9080456334422 "$node_(118) setdest 38164 3887 6.0" 
$ns at 501.65007889649036 "$node_(118) setdest 12893 2847 16.0" 
$ns at 606.1592994668868 "$node_(118) setdest 182948 47502 4.0" 
$ns at 656.9402678006207 "$node_(118) setdest 234659 2464 9.0" 
$ns at 687.7152471262666 "$node_(118) setdest 99156 51473 1.0" 
$ns at 727.3001236385313 "$node_(118) setdest 143628 8836 6.0" 
$ns at 798.9211541552745 "$node_(118) setdest 240583 83114 2.0" 
$ns at 829.8623063814638 "$node_(118) setdest 178336 7239 1.0" 
$ns at 862.4447045886969 "$node_(118) setdest 88390 31695 11.0" 
$ns at 183.74433244228544 "$node_(119) setdest 5140 14731 14.0" 
$ns at 313.553165667258 "$node_(119) setdest 55197 20507 8.0" 
$ns at 386.4791675277512 "$node_(119) setdest 174274 32267 6.0" 
$ns at 434.453598046855 "$node_(119) setdest 56586 52050 6.0" 
$ns at 471.3729986309819 "$node_(119) setdest 185139 8214 12.0" 
$ns at 587.754828290156 "$node_(119) setdest 229496 51195 19.0" 
$ns at 799.9338489776071 "$node_(119) setdest 226996 17081 8.0" 
$ns at 237.52438683491147 "$node_(120) setdest 32986 18291 14.0" 
$ns at 292.43515307098806 "$node_(120) setdest 43158 23841 1.0" 
$ns at 329.5392996198077 "$node_(120) setdest 30352 29574 12.0" 
$ns at 436.4990271320364 "$node_(120) setdest 136392 16096 16.0" 
$ns at 545.060594470456 "$node_(120) setdest 125325 59810 1.0" 
$ns at 584.1046508222116 "$node_(120) setdest 163971 20226 1.0" 
$ns at 621.633282525868 "$node_(120) setdest 64983 148 4.0" 
$ns at 676.0139801140865 "$node_(120) setdest 180837 268 20.0" 
$ns at 750.7111925319422 "$node_(120) setdest 77007 76551 20.0" 
$ns at 153.94352435984308 "$node_(121) setdest 33083 7188 2.0" 
$ns at 195.34220995705653 "$node_(121) setdest 63931 9310 15.0" 
$ns at 254.1188357004755 "$node_(121) setdest 26297 6205 14.0" 
$ns at 420.46051360949286 "$node_(121) setdest 19107 22172 15.0" 
$ns at 488.1735008052734 "$node_(121) setdest 59499 1082 7.0" 
$ns at 568.0445125667718 "$node_(121) setdest 126971 5170 4.0" 
$ns at 604.6627601777069 "$node_(121) setdest 84300 43710 8.0" 
$ns at 691.4042553587249 "$node_(121) setdest 13403 38124 17.0" 
$ns at 788.9473880232426 "$node_(121) setdest 48690 40947 13.0" 
$ns at 153.75853695863844 "$node_(122) setdest 94061 7286 18.0" 
$ns at 263.68725093461876 "$node_(122) setdest 78450 8369 9.0" 
$ns at 363.0824302366618 "$node_(122) setdest 108523 9143 8.0" 
$ns at 426.8093789933904 "$node_(122) setdest 19855 30433 5.0" 
$ns at 499.7523628167648 "$node_(122) setdest 93268 58127 19.0" 
$ns at 613.4841425273477 "$node_(122) setdest 178288 5098 1.0" 
$ns at 646.9540641458176 "$node_(122) setdest 187466 59913 20.0" 
$ns at 705.7232552140468 "$node_(122) setdest 18358 41517 1.0" 
$ns at 745.2644704738657 "$node_(122) setdest 109066 80129 15.0" 
$ns at 805.4877125480298 "$node_(122) setdest 236391 66115 18.0" 
$ns at 211.66670831783438 "$node_(123) setdest 114017 25224 7.0" 
$ns at 295.41171984896505 "$node_(123) setdest 26747 34111 1.0" 
$ns at 328.643321422457 "$node_(123) setdest 159217 6996 7.0" 
$ns at 422.3776357223809 "$node_(123) setdest 147707 19331 19.0" 
$ns at 600.6132323014053 "$node_(123) setdest 100056 66968 5.0" 
$ns at 657.8096945387967 "$node_(123) setdest 146656 287 10.0" 
$ns at 740.5403403431242 "$node_(123) setdest 115184 6262 10.0" 
$ns at 825.3269237322756 "$node_(123) setdest 68993 78916 14.0" 
$ns at 876.3204046009937 "$node_(123) setdest 257324 76674 5.0" 
$ns at 177.4450218097725 "$node_(124) setdest 10174 4153 13.0" 
$ns at 297.5681051973854 "$node_(124) setdest 30376 50895 12.0" 
$ns at 435.37443248711264 "$node_(124) setdest 143286 53560 18.0" 
$ns at 484.5955656924506 "$node_(124) setdest 96333 17576 6.0" 
$ns at 537.8862138040004 "$node_(124) setdest 139808 67032 6.0" 
$ns at 570.2342397655792 "$node_(124) setdest 146300 21811 7.0" 
$ns at 636.2888276768099 "$node_(124) setdest 56292 70159 17.0" 
$ns at 714.6418416683665 "$node_(124) setdest 92547 62289 19.0" 
$ns at 764.4577338034953 "$node_(124) setdest 53959 47834 15.0" 
$ns at 892.1111147564438 "$node_(124) setdest 257213 49565 2.0" 
$ns at 134.7456966424816 "$node_(125) setdest 19864 2725 10.0" 
$ns at 173.3138747854738 "$node_(125) setdest 8168 30785 18.0" 
$ns at 350.6309797898758 "$node_(125) setdest 149143 23747 2.0" 
$ns at 391.22438035796813 "$node_(125) setdest 11556 44283 7.0" 
$ns at 424.9213719935034 "$node_(125) setdest 119533 10292 11.0" 
$ns at 474.49312062411246 "$node_(125) setdest 71193 37376 7.0" 
$ns at 507.63452865769324 "$node_(125) setdest 171867 40126 13.0" 
$ns at 603.3437672562994 "$node_(125) setdest 94937 59593 6.0" 
$ns at 662.1989363427492 "$node_(125) setdest 13799 37532 2.0" 
$ns at 705.2213838090601 "$node_(125) setdest 172062 55335 19.0" 
$ns at 882.870048381397 "$node_(125) setdest 235149 47338 17.0" 
$ns at 245.97782003857697 "$node_(126) setdest 96278 44437 1.0" 
$ns at 277.3902414899938 "$node_(126) setdest 110516 54261 2.0" 
$ns at 320.71472218858503 "$node_(126) setdest 98733 44685 9.0" 
$ns at 381.30209706586083 "$node_(126) setdest 63593 4306 19.0" 
$ns at 548.128303168347 "$node_(126) setdest 138054 40191 6.0" 
$ns at 610.0262413273862 "$node_(126) setdest 15485 10318 1.0" 
$ns at 644.8197258741292 "$node_(126) setdest 159279 37087 17.0" 
$ns at 710.5636423930638 "$node_(126) setdest 155579 11133 4.0" 
$ns at 767.0018431264025 "$node_(126) setdest 115506 10667 9.0" 
$ns at 875.3632900023796 "$node_(126) setdest 211455 19644 9.0" 
$ns at 228.84189952193375 "$node_(127) setdest 73824 38598 8.0" 
$ns at 332.4097143677996 "$node_(127) setdest 72653 4752 7.0" 
$ns at 405.3263598074359 "$node_(127) setdest 125717 11948 6.0" 
$ns at 483.60900397232774 "$node_(127) setdest 116892 44608 2.0" 
$ns at 525.3277291619461 "$node_(127) setdest 17119 2180 4.0" 
$ns at 560.921820105254 "$node_(127) setdest 82780 125 14.0" 
$ns at 715.2519097644113 "$node_(127) setdest 38569 50304 12.0" 
$ns at 807.1380401332044 "$node_(127) setdest 112715 21328 9.0" 
$ns at 883.506754103358 "$node_(127) setdest 108684 56955 1.0" 
$ns at 128.1677397745999 "$node_(128) setdest 46400 20308 12.0" 
$ns at 226.21258893627646 "$node_(128) setdest 23715 40984 7.0" 
$ns at 288.76431898330435 "$node_(128) setdest 26611 54005 9.0" 
$ns at 360.70326228972516 "$node_(128) setdest 148718 55212 14.0" 
$ns at 434.984165859202 "$node_(128) setdest 167140 15293 8.0" 
$ns at 499.01655434450277 "$node_(128) setdest 189317 40330 8.0" 
$ns at 556.1453535880926 "$node_(128) setdest 208069 32544 20.0" 
$ns at 678.2330063281318 "$node_(128) setdest 207028 25545 15.0" 
$ns at 760.5160009693434 "$node_(128) setdest 252932 88123 2.0" 
$ns at 794.5988608841179 "$node_(128) setdest 91960 43551 6.0" 
$ns at 829.6651100226316 "$node_(128) setdest 244555 71682 1.0" 
$ns at 869.4830626229001 "$node_(128) setdest 187085 88747 5.0" 
$ns at 180.51020753441983 "$node_(129) setdest 71799 34094 14.0" 
$ns at 218.84690891379148 "$node_(129) setdest 112972 10510 18.0" 
$ns at 283.4866974841481 "$node_(129) setdest 24731 49735 17.0" 
$ns at 320.7686762149109 "$node_(129) setdest 144925 41170 4.0" 
$ns at 357.76291088024465 "$node_(129) setdest 155427 53387 14.0" 
$ns at 433.77345240544327 "$node_(129) setdest 78975 33491 3.0" 
$ns at 484.48328408573576 "$node_(129) setdest 43559 15764 7.0" 
$ns at 521.4254871369312 "$node_(129) setdest 182521 54986 13.0" 
$ns at 594.0520069547434 "$node_(129) setdest 18059 53117 12.0" 
$ns at 669.8300431371601 "$node_(129) setdest 235368 74972 8.0" 
$ns at 717.9024379782404 "$node_(129) setdest 206794 58720 6.0" 
$ns at 776.7032808468241 "$node_(129) setdest 78132 87307 16.0" 
$ns at 867.877814028147 "$node_(129) setdest 134481 1348 20.0" 
$ns at 208.99881912597533 "$node_(130) setdest 54219 37268 13.0" 
$ns at 286.1394249186202 "$node_(130) setdest 72833 11824 13.0" 
$ns at 345.36781719011947 "$node_(130) setdest 119717 30824 15.0" 
$ns at 500.12024046564494 "$node_(130) setdest 138825 44055 19.0" 
$ns at 592.9716694868398 "$node_(130) setdest 133216 43281 4.0" 
$ns at 627.6303513200259 "$node_(130) setdest 199558 24979 15.0" 
$ns at 741.9927783447196 "$node_(130) setdest 170528 77217 8.0" 
$ns at 798.2994341640831 "$node_(130) setdest 48178 22089 2.0" 
$ns at 836.8867724792855 "$node_(130) setdest 256747 72052 13.0" 
$ns at 108.24578172840965 "$node_(131) setdest 53080 7568 5.0" 
$ns at 167.28073076405406 "$node_(131) setdest 12660 39324 20.0" 
$ns at 246.51948923068804 "$node_(131) setdest 85476 18123 2.0" 
$ns at 285.5173273350922 "$node_(131) setdest 52594 25342 1.0" 
$ns at 319.62342573881597 "$node_(131) setdest 22980 29588 1.0" 
$ns at 356.24660679422476 "$node_(131) setdest 182294 59126 4.0" 
$ns at 413.3511302862244 "$node_(131) setdest 960 15318 5.0" 
$ns at 459.45172256167007 "$node_(131) setdest 103098 23634 12.0" 
$ns at 562.0568644141116 "$node_(131) setdest 46979 16101 16.0" 
$ns at 602.6449688370178 "$node_(131) setdest 227159 51241 4.0" 
$ns at 659.1230983767372 "$node_(131) setdest 202493 40917 19.0" 
$ns at 728.1226417417295 "$node_(131) setdest 111369 64229 2.0" 
$ns at 763.0923390317739 "$node_(131) setdest 257235 76994 5.0" 
$ns at 833.0617371968492 "$node_(131) setdest 129024 85562 13.0" 
$ns at 133.01194078051185 "$node_(132) setdest 13926 2758 2.0" 
$ns at 182.37260745256367 "$node_(132) setdest 102475 40551 16.0" 
$ns at 241.77468152254932 "$node_(132) setdest 98492 43403 11.0" 
$ns at 356.5301576694285 "$node_(132) setdest 160799 37515 11.0" 
$ns at 407.7675512807662 "$node_(132) setdest 165759 53142 18.0" 
$ns at 453.29685647955284 "$node_(132) setdest 124218 14712 10.0" 
$ns at 509.05166936563523 "$node_(132) setdest 126553 30707 8.0" 
$ns at 562.5259649579752 "$node_(132) setdest 152562 60045 5.0" 
$ns at 608.0847685323089 "$node_(132) setdest 144307 12450 11.0" 
$ns at 684.8304307724384 "$node_(132) setdest 195809 72702 9.0" 
$ns at 731.0925921370658 "$node_(132) setdest 154066 62765 3.0" 
$ns at 777.7234236487084 "$node_(132) setdest 87595 51411 9.0" 
$ns at 817.2516629633898 "$node_(132) setdest 189512 69633 4.0" 
$ns at 868.5945300680085 "$node_(132) setdest 255845 65827 17.0" 
$ns at 105.68522699961014 "$node_(133) setdest 5486 10216 7.0" 
$ns at 145.61702275917202 "$node_(133) setdest 66740 15322 8.0" 
$ns at 218.0187019044763 "$node_(133) setdest 13471 33928 1.0" 
$ns at 256.3414763999304 "$node_(133) setdest 38938 50906 4.0" 
$ns at 311.2000107040512 "$node_(133) setdest 152070 23374 8.0" 
$ns at 361.1970426823972 "$node_(133) setdest 87315 54381 6.0" 
$ns at 432.5777709076858 "$node_(133) setdest 1822 36346 18.0" 
$ns at 558.5234176100472 "$node_(133) setdest 50319 40616 8.0" 
$ns at 660.4677763412848 "$node_(133) setdest 137481 26454 5.0" 
$ns at 716.4153805288431 "$node_(133) setdest 227880 2598 19.0" 
$ns at 832.494618457873 "$node_(133) setdest 244998 26635 3.0" 
$ns at 884.8712667104508 "$node_(133) setdest 1204 13415 16.0" 
$ns at 101.39811104411217 "$node_(134) setdest 23569 1994 14.0" 
$ns at 215.97288618714157 "$node_(134) setdest 97643 35803 1.0" 
$ns at 255.18999606747047 "$node_(134) setdest 108098 16282 13.0" 
$ns at 407.35196251633226 "$node_(134) setdest 93649 30067 6.0" 
$ns at 476.77308735894616 "$node_(134) setdest 175845 17396 18.0" 
$ns at 659.9753174048923 "$node_(134) setdest 37933 36109 15.0" 
$ns at 707.7169800411801 "$node_(134) setdest 243886 81392 10.0" 
$ns at 782.4214643615536 "$node_(134) setdest 59315 87642 6.0" 
$ns at 823.5010670430206 "$node_(134) setdest 146983 85018 14.0" 
$ns at 115.68244306034072 "$node_(135) setdest 69951 7722 16.0" 
$ns at 175.0840189270805 "$node_(135) setdest 38864 10515 10.0" 
$ns at 292.393132106439 "$node_(135) setdest 9599 13941 12.0" 
$ns at 331.1302404262337 "$node_(135) setdest 100271 8079 2.0" 
$ns at 363.0192195083316 "$node_(135) setdest 133553 52773 8.0" 
$ns at 395.63480249560115 "$node_(135) setdest 104261 36520 8.0" 
$ns at 475.1428377329719 "$node_(135) setdest 51398 29908 7.0" 
$ns at 555.107863994145 "$node_(135) setdest 94002 28159 11.0" 
$ns at 614.5509444701711 "$node_(135) setdest 184223 18927 17.0" 
$ns at 730.9647444960649 "$node_(135) setdest 64702 6442 3.0" 
$ns at 782.2935433954023 "$node_(135) setdest 262953 19443 17.0" 
$ns at 837.6270191049624 "$node_(135) setdest 92945 72838 1.0" 
$ns at 874.918408111484 "$node_(135) setdest 49174 3819 19.0" 
$ns at 110.67010697720235 "$node_(136) setdest 53927 23303 3.0" 
$ns at 147.65940479797885 "$node_(136) setdest 43105 11620 6.0" 
$ns at 213.0788633142452 "$node_(136) setdest 85905 5971 13.0" 
$ns at 358.4645326077817 "$node_(136) setdest 61302 27852 8.0" 
$ns at 443.89192635150505 "$node_(136) setdest 57714 7582 7.0" 
$ns at 540.6264465597943 "$node_(136) setdest 65483 19829 3.0" 
$ns at 575.903382821849 "$node_(136) setdest 156869 48788 8.0" 
$ns at 665.8881774020387 "$node_(136) setdest 12157 64748 6.0" 
$ns at 698.4414800971339 "$node_(136) setdest 30658 55362 14.0" 
$ns at 731.2538619343269 "$node_(136) setdest 198025 14663 19.0" 
$ns at 106.71455031974298 "$node_(137) setdest 5621 24591 7.0" 
$ns at 142.36196852608185 "$node_(137) setdest 6350 9360 13.0" 
$ns at 254.28669159437482 "$node_(137) setdest 44183 49 18.0" 
$ns at 298.2130498245287 "$node_(137) setdest 129993 47724 5.0" 
$ns at 333.5029957398854 "$node_(137) setdest 15531 29707 11.0" 
$ns at 366.977368898192 "$node_(137) setdest 18193 59385 16.0" 
$ns at 542.3036178217953 "$node_(137) setdest 162941 34228 12.0" 
$ns at 656.2994858515887 "$node_(137) setdest 55051 28167 13.0" 
$ns at 762.8507134940545 "$node_(137) setdest 169079 44854 7.0" 
$ns at 850.6086259947557 "$node_(137) setdest 191659 17618 14.0" 
$ns at 135.03907394077768 "$node_(138) setdest 89408 29654 12.0" 
$ns at 282.5367686842219 "$node_(138) setdest 121933 18715 5.0" 
$ns at 349.88992681542607 "$node_(138) setdest 16125 35847 20.0" 
$ns at 574.2079862910754 "$node_(138) setdest 150171 31900 13.0" 
$ns at 678.3586284322572 "$node_(138) setdest 28896 18764 18.0" 
$ns at 723.7530418405682 "$node_(138) setdest 62684 79647 16.0" 
$ns at 843.1309682197208 "$node_(138) setdest 6539 26243 15.0" 
$ns at 140.62999185146833 "$node_(139) setdest 80196 348 19.0" 
$ns at 306.97630305778495 "$node_(139) setdest 117330 8766 1.0" 
$ns at 346.75383513599877 "$node_(139) setdest 44571 20398 11.0" 
$ns at 476.76826155165895 "$node_(139) setdest 174794 57460 5.0" 
$ns at 508.9062194722022 "$node_(139) setdest 116769 69780 6.0" 
$ns at 591.0710503605045 "$node_(139) setdest 63172 6658 2.0" 
$ns at 624.0859054325872 "$node_(139) setdest 15978 6965 9.0" 
$ns at 664.5161843307883 "$node_(139) setdest 111115 59552 12.0" 
$ns at 778.9864427693468 "$node_(139) setdest 10938 7528 4.0" 
$ns at 840.5075944204284 "$node_(139) setdest 49661 6490 8.0" 
$ns at 136.5219992437336 "$node_(140) setdest 56314 24127 15.0" 
$ns at 286.85946965094047 "$node_(140) setdest 81679 6201 4.0" 
$ns at 336.12952788354386 "$node_(140) setdest 132196 43688 9.0" 
$ns at 424.53183085123067 "$node_(140) setdest 137143 23525 5.0" 
$ns at 495.7057204004249 "$node_(140) setdest 62059 51956 20.0" 
$ns at 693.3403970307089 "$node_(140) setdest 103746 70850 15.0" 
$ns at 813.2746346202656 "$node_(140) setdest 109299 21025 6.0" 
$ns at 877.2664484989812 "$node_(140) setdest 42099 2634 8.0" 
$ns at 113.89293678526467 "$node_(141) setdest 32444 28080 19.0" 
$ns at 171.49906149668846 "$node_(141) setdest 26684 195 12.0" 
$ns at 239.57809770281966 "$node_(141) setdest 125171 6293 12.0" 
$ns at 322.14223923502016 "$node_(141) setdest 117359 48881 12.0" 
$ns at 406.2231405841885 "$node_(141) setdest 143292 8535 1.0" 
$ns at 445.322889439282 "$node_(141) setdest 183748 23003 1.0" 
$ns at 485.2615768379911 "$node_(141) setdest 30461 37688 15.0" 
$ns at 663.3612386318941 "$node_(141) setdest 81041 51270 6.0" 
$ns at 726.5966534626483 "$node_(141) setdest 100649 15880 12.0" 
$ns at 837.019650281312 "$node_(141) setdest 62176 62685 2.0" 
$ns at 873.2974265193023 "$node_(141) setdest 183410 27399 16.0" 
$ns at 120.21771987892114 "$node_(142) setdest 43033 4027 13.0" 
$ns at 218.39911489878313 "$node_(142) setdest 71782 12656 9.0" 
$ns at 324.0525555818186 "$node_(142) setdest 145515 2495 4.0" 
$ns at 373.37163627939077 "$node_(142) setdest 165188 50905 19.0" 
$ns at 444.7702103613602 "$node_(142) setdest 105659 31824 11.0" 
$ns at 512.5904366150331 "$node_(142) setdest 148544 51886 7.0" 
$ns at 592.434127681165 "$node_(142) setdest 104600 14010 11.0" 
$ns at 694.5793862028927 "$node_(142) setdest 167680 15984 17.0" 
$ns at 827.5890479568279 "$node_(142) setdest 238370 36224 3.0" 
$ns at 865.3959171200373 "$node_(142) setdest 264237 60078 12.0" 
$ns at 221.86281555279896 "$node_(143) setdest 119708 14891 9.0" 
$ns at 331.2294760003221 "$node_(143) setdest 18612 483 17.0" 
$ns at 497.07257397060084 "$node_(143) setdest 24135 12577 8.0" 
$ns at 537.0240465781217 "$node_(143) setdest 37127 16142 14.0" 
$ns at 628.7159261756349 "$node_(143) setdest 230146 50789 6.0" 
$ns at 708.9504644213022 "$node_(143) setdest 169986 6400 9.0" 
$ns at 826.5795225312728 "$node_(143) setdest 60849 47714 7.0" 
$ns at 199.82176302351513 "$node_(144) setdest 55623 392 13.0" 
$ns at 294.7838015417583 "$node_(144) setdest 149 51742 1.0" 
$ns at 334.7454286192625 "$node_(144) setdest 138356 30448 2.0" 
$ns at 379.0838850549679 "$node_(144) setdest 147175 8831 1.0" 
$ns at 415.326588216828 "$node_(144) setdest 60985 30934 7.0" 
$ns at 454.1897022811196 "$node_(144) setdest 193945 34580 5.0" 
$ns at 529.323957978221 "$node_(144) setdest 63214 27217 16.0" 
$ns at 694.7745391497672 "$node_(144) setdest 3904 18485 12.0" 
$ns at 800.4756829988104 "$node_(144) setdest 25691 32241 18.0" 
$ns at 876.754755276907 "$node_(144) setdest 27547 51662 7.0" 
$ns at 146.28541779339014 "$node_(145) setdest 39212 18928 19.0" 
$ns at 191.3400808698175 "$node_(145) setdest 14632 7144 16.0" 
$ns at 313.8947309141593 "$node_(145) setdest 144486 54208 5.0" 
$ns at 383.1449134329582 "$node_(145) setdest 91809 62434 16.0" 
$ns at 442.0431469134577 "$node_(145) setdest 101599 9383 1.0" 
$ns at 475.7847574742541 "$node_(145) setdest 125159 29431 20.0" 
$ns at 684.1977041639004 "$node_(145) setdest 165819 13926 10.0" 
$ns at 812.9915685934268 "$node_(145) setdest 225326 14739 2.0" 
$ns at 857.9110139577974 "$node_(145) setdest 200939 11104 18.0" 
$ns at 107.63450393837095 "$node_(146) setdest 3426 1597 19.0" 
$ns at 313.55054341838456 "$node_(146) setdest 22584 47786 1.0" 
$ns at 344.04680370589307 "$node_(146) setdest 17693 22333 12.0" 
$ns at 432.0882972019732 "$node_(146) setdest 16777 50937 4.0" 
$ns at 489.6253623530884 "$node_(146) setdest 180233 40536 12.0" 
$ns at 522.6710156490625 "$node_(146) setdest 39537 28185 3.0" 
$ns at 573.3365143888216 "$node_(146) setdest 181717 56860 18.0" 
$ns at 611.8234326682161 "$node_(146) setdest 107498 62862 5.0" 
$ns at 690.7946017524857 "$node_(146) setdest 194135 63414 6.0" 
$ns at 766.3945346229484 "$node_(146) setdest 192645 58705 17.0" 
$ns at 133.36256286880283 "$node_(147) setdest 44388 17490 10.0" 
$ns at 179.766303792335 "$node_(147) setdest 88483 8985 5.0" 
$ns at 234.33506003551753 "$node_(147) setdest 4497 8577 4.0" 
$ns at 270.91820063737663 "$node_(147) setdest 43974 33242 20.0" 
$ns at 393.6567908153665 "$node_(147) setdest 174187 56724 14.0" 
$ns at 500.6207157083951 "$node_(147) setdest 30457 49867 13.0" 
$ns at 571.8185196694214 "$node_(147) setdest 161619 47389 7.0" 
$ns at 658.2697883939561 "$node_(147) setdest 243439 77208 2.0" 
$ns at 701.6861580074204 "$node_(147) setdest 200391 43655 4.0" 
$ns at 732.3748084101253 "$node_(147) setdest 110382 70234 10.0" 
$ns at 808.0632271481895 "$node_(147) setdest 248754 18024 5.0" 
$ns at 855.0548232019137 "$node_(147) setdest 140412 15086 16.0" 
$ns at 112.02387639389775 "$node_(148) setdest 50224 29069 9.0" 
$ns at 166.54042012510507 "$node_(148) setdest 84765 22750 7.0" 
$ns at 228.19032582238842 "$node_(148) setdest 87109 21687 6.0" 
$ns at 273.2545118727484 "$node_(148) setdest 82524 6978 1.0" 
$ns at 307.9082067575807 "$node_(148) setdest 99160 31000 11.0" 
$ns at 361.49474969820795 "$node_(148) setdest 106496 55724 20.0" 
$ns at 563.3509969027187 "$node_(148) setdest 191565 25150 1.0" 
$ns at 600.2436633043208 "$node_(148) setdest 97467 39581 9.0" 
$ns at 664.7772925344964 "$node_(148) setdest 101895 54855 15.0" 
$ns at 835.8304662644899 "$node_(148) setdest 14024 29671 17.0" 
$ns at 883.318699106717 "$node_(148) setdest 6290 67389 19.0" 
$ns at 146.61238587954495 "$node_(149) setdest 71751 26627 13.0" 
$ns at 228.39286612032134 "$node_(149) setdest 126413 20959 3.0" 
$ns at 262.84531539556673 "$node_(149) setdest 49876 18386 6.0" 
$ns at 324.1988450317139 "$node_(149) setdest 68697 40465 10.0" 
$ns at 436.07734199606654 "$node_(149) setdest 62359 60149 3.0" 
$ns at 481.8849700644325 "$node_(149) setdest 62292 1690 8.0" 
$ns at 541.8996466064186 "$node_(149) setdest 195944 38140 13.0" 
$ns at 674.0049127411091 "$node_(149) setdest 88198 21012 17.0" 
$ns at 750.1354305217478 "$node_(149) setdest 115241 58966 6.0" 
$ns at 832.5540075092287 "$node_(149) setdest 55784 73876 12.0" 
$ns at 167.63738777758164 "$node_(150) setdest 47958 12763 4.0" 
$ns at 203.19209261947583 "$node_(150) setdest 113515 22823 18.0" 
$ns at 359.4534094080531 "$node_(150) setdest 113867 6238 13.0" 
$ns at 472.33654533782374 "$node_(150) setdest 202975 14985 19.0" 
$ns at 611.2242002925818 "$node_(150) setdest 196417 15125 20.0" 
$ns at 670.3831831822562 "$node_(150) setdest 39430 39196 12.0" 
$ns at 720.8727194023312 "$node_(150) setdest 163430 2206 10.0" 
$ns at 844.1813376754224 "$node_(150) setdest 9081 6791 8.0" 
$ns at 887.757343603783 "$node_(150) setdest 22356 28630 1.0" 
$ns at 193.13841413472022 "$node_(151) setdest 110794 12878 6.0" 
$ns at 228.6193434982465 "$node_(151) setdest 113808 40816 1.0" 
$ns at 266.3231549933481 "$node_(151) setdest 84327 13816 20.0" 
$ns at 427.9762534624588 "$node_(151) setdest 163088 32006 3.0" 
$ns at 458.8113259467657 "$node_(151) setdest 16640 47273 15.0" 
$ns at 635.8523283814557 "$node_(151) setdest 119579 64839 9.0" 
$ns at 725.0415494896953 "$node_(151) setdest 12962 51474 16.0" 
$ns at 815.7683081050361 "$node_(151) setdest 5507 20502 20.0" 
$ns at 116.3596723810641 "$node_(152) setdest 8446 25555 6.0" 
$ns at 150.35572498255505 "$node_(152) setdest 80020 40989 1.0" 
$ns at 183.69050471043772 "$node_(152) setdest 46975 25870 19.0" 
$ns at 228.75602158135914 "$node_(152) setdest 85145 6180 6.0" 
$ns at 284.46017788565825 "$node_(152) setdest 32821 6359 15.0" 
$ns at 393.4861870337138 "$node_(152) setdest 89289 26597 4.0" 
$ns at 441.75847443352296 "$node_(152) setdest 119050 21304 5.0" 
$ns at 489.86030232265006 "$node_(152) setdest 132134 65465 1.0" 
$ns at 523.5808084848316 "$node_(152) setdest 57650 2788 2.0" 
$ns at 562.4145371155744 "$node_(152) setdest 121421 69164 3.0" 
$ns at 604.619126131264 "$node_(152) setdest 208822 1543 2.0" 
$ns at 642.5799513297533 "$node_(152) setdest 205672 37311 16.0" 
$ns at 712.7578897920836 "$node_(152) setdest 182428 33544 10.0" 
$ns at 813.391851604903 "$node_(152) setdest 189253 22193 1.0" 
$ns at 853.3777700700211 "$node_(152) setdest 124415 73344 2.0" 
$ns at 100.9354169807473 "$node_(153) setdest 15595 11754 14.0" 
$ns at 155.97989702317955 "$node_(153) setdest 76971 8492 17.0" 
$ns at 281.0232546325038 "$node_(153) setdest 45697 24535 1.0" 
$ns at 318.54847981808564 "$node_(153) setdest 30716 38533 18.0" 
$ns at 392.2460040079654 "$node_(153) setdest 93741 55097 6.0" 
$ns at 471.277154858228 "$node_(153) setdest 9796 17597 3.0" 
$ns at 520.9212889394344 "$node_(153) setdest 53299 68219 16.0" 
$ns at 700.0495023106668 "$node_(153) setdest 106172 35937 13.0" 
$ns at 825.951734901054 "$node_(153) setdest 6619 40732 1.0" 
$ns at 857.116677999445 "$node_(153) setdest 200989 83517 4.0" 
$ns at 221.83565876194245 "$node_(154) setdest 1431 8666 1.0" 
$ns at 255.31492739156513 "$node_(154) setdest 72741 27143 3.0" 
$ns at 293.1911463262942 "$node_(154) setdest 134519 17439 10.0" 
$ns at 331.98170341756594 "$node_(154) setdest 133567 26666 7.0" 
$ns at 371.6551578750282 "$node_(154) setdest 29490 2142 10.0" 
$ns at 411.4210152530162 "$node_(154) setdest 5644 50928 16.0" 
$ns at 539.918945246314 "$node_(154) setdest 123710 60075 11.0" 
$ns at 587.245893724479 "$node_(154) setdest 15783 30497 9.0" 
$ns at 667.2647126456073 "$node_(154) setdest 143468 12934 10.0" 
$ns at 757.9570693406797 "$node_(154) setdest 173168 75538 12.0" 
$ns at 862.5847259035952 "$node_(154) setdest 105363 88522 10.0" 
$ns at 897.7034004620648 "$node_(154) setdest 199225 53709 10.0" 
$ns at 294.6166092131168 "$node_(155) setdest 23861 20056 1.0" 
$ns at 332.4594230197143 "$node_(155) setdest 47673 5854 4.0" 
$ns at 398.1872173212388 "$node_(155) setdest 128361 9329 17.0" 
$ns at 562.441730575038 "$node_(155) setdest 181476 64377 12.0" 
$ns at 648.7943175247958 "$node_(155) setdest 76649 73637 13.0" 
$ns at 732.3397813037059 "$node_(155) setdest 128701 38904 15.0" 
$ns at 887.5099375667247 "$node_(155) setdest 182099 49098 14.0" 
$ns at 161.96024261166278 "$node_(156) setdest 36760 24990 12.0" 
$ns at 235.04533053260167 "$node_(156) setdest 83894 27014 1.0" 
$ns at 265.085291303349 "$node_(156) setdest 114829 50049 19.0" 
$ns at 351.41807570558205 "$node_(156) setdest 33707 51551 10.0" 
$ns at 451.6842410221631 "$node_(156) setdest 20787 41591 10.0" 
$ns at 561.8582221242973 "$node_(156) setdest 151675 40178 12.0" 
$ns at 657.798925696854 "$node_(156) setdest 74691 38932 10.0" 
$ns at 772.5171220127943 "$node_(156) setdest 202143 66287 11.0" 
$ns at 838.3792800021993 "$node_(156) setdest 235216 44226 5.0" 
$ns at 898.3157806930235 "$node_(156) setdest 176757 28645 14.0" 
$ns at 113.41275513206378 "$node_(157) setdest 48152 16000 8.0" 
$ns at 165.34002931025913 "$node_(157) setdest 41192 6780 18.0" 
$ns at 290.99563470296414 "$node_(157) setdest 78513 44618 8.0" 
$ns at 342.1936264846537 "$node_(157) setdest 68770 40437 5.0" 
$ns at 411.36249887430665 "$node_(157) setdest 149368 4835 14.0" 
$ns at 518.4443092832726 "$node_(157) setdest 53881 32880 1.0" 
$ns at 548.632195340111 "$node_(157) setdest 25684 46213 15.0" 
$ns at 662.5676425316192 "$node_(157) setdest 194659 80342 15.0" 
$ns at 813.4593208676167 "$node_(157) setdest 51829 51533 1.0" 
$ns at 852.7972518907146 "$node_(157) setdest 234485 14619 9.0" 
$ns at 166.10039758007224 "$node_(158) setdest 117222 32252 5.0" 
$ns at 238.4523527599548 "$node_(158) setdest 109441 4706 19.0" 
$ns at 292.25807696325586 "$node_(158) setdest 25739 54747 2.0" 
$ns at 332.16811914303867 "$node_(158) setdest 93175 42353 3.0" 
$ns at 385.6939951533317 "$node_(158) setdest 65438 15250 17.0" 
$ns at 554.598094861984 "$node_(158) setdest 207407 36537 15.0" 
$ns at 643.1314993084925 "$node_(158) setdest 192927 40914 14.0" 
$ns at 772.5901031991452 "$node_(158) setdest 155953 33155 1.0" 
$ns at 807.7883827163507 "$node_(158) setdest 105688 25488 8.0" 
$ns at 854.6367401974453 "$node_(158) setdest 215278 44578 1.0" 
$ns at 894.4613534316256 "$node_(158) setdest 125771 8265 9.0" 
$ns at 102.94459685198098 "$node_(159) setdest 65451 2064 9.0" 
$ns at 134.87643754519672 "$node_(159) setdest 17183 2198 1.0" 
$ns at 170.44025947198418 "$node_(159) setdest 113661 30686 3.0" 
$ns at 227.87430825912287 "$node_(159) setdest 16004 25969 16.0" 
$ns at 412.45281038515463 "$node_(159) setdest 114227 15225 18.0" 
$ns at 480.02778661292353 "$node_(159) setdest 103623 47761 3.0" 
$ns at 521.5064429944679 "$node_(159) setdest 123723 17601 13.0" 
$ns at 617.1455807983286 "$node_(159) setdest 32491 65089 17.0" 
$ns at 806.8636577393218 "$node_(159) setdest 194226 48009 3.0" 
$ns at 839.4314797681336 "$node_(159) setdest 60183 20916 17.0" 
$ns at 110.23644297562437 "$node_(160) setdest 46964 9077 3.0" 
$ns at 159.74090103384026 "$node_(160) setdest 81225 4684 4.0" 
$ns at 200.09237328917567 "$node_(160) setdest 131240 12245 11.0" 
$ns at 272.3953055154701 "$node_(160) setdest 26861 44847 1.0" 
$ns at 310.44342297047734 "$node_(160) setdest 41128 47757 7.0" 
$ns at 373.64452320026237 "$node_(160) setdest 36458 7540 3.0" 
$ns at 422.2192953565493 "$node_(160) setdest 153851 62194 8.0" 
$ns at 487.5059554243069 "$node_(160) setdest 123744 33222 1.0" 
$ns at 525.1774591138116 "$node_(160) setdest 61153 23598 18.0" 
$ns at 584.8476101233922 "$node_(160) setdest 109369 8792 18.0" 
$ns at 773.7429128138023 "$node_(160) setdest 125358 55489 19.0" 
$ns at 893.9378333355601 "$node_(160) setdest 115108 60272 11.0" 
$ns at 137.06775224352916 "$node_(161) setdest 87434 24872 12.0" 
$ns at 285.29224274453657 "$node_(161) setdest 67190 1314 18.0" 
$ns at 438.2202395180098 "$node_(161) setdest 154238 4706 18.0" 
$ns at 564.4018996061523 "$node_(161) setdest 134816 11644 12.0" 
$ns at 619.8765268433681 "$node_(161) setdest 175598 5008 2.0" 
$ns at 669.439878614674 "$node_(161) setdest 206970 79261 15.0" 
$ns at 835.4709006158487 "$node_(161) setdest 43786 9403 19.0" 
$ns at 881.5579258138679 "$node_(161) setdest 81056 36655 7.0" 
$ns at 138.0575137363159 "$node_(162) setdest 53810 4514 9.0" 
$ns at 173.70409293577572 "$node_(162) setdest 32015 41242 19.0" 
$ns at 344.97518469008537 "$node_(162) setdest 1818 30758 9.0" 
$ns at 439.77003365791006 "$node_(162) setdest 178216 1465 3.0" 
$ns at 498.12454267478756 "$node_(162) setdest 29103 5600 14.0" 
$ns at 534.1505052459681 "$node_(162) setdest 109710 62838 9.0" 
$ns at 602.5261642635795 "$node_(162) setdest 156755 52230 20.0" 
$ns at 684.4483903095025 "$node_(162) setdest 128893 8801 2.0" 
$ns at 717.5644395166373 "$node_(162) setdest 234435 39576 16.0" 
$ns at 816.783704610712 "$node_(162) setdest 142063 34580 18.0" 
$ns at 134.61474078311136 "$node_(163) setdest 2516 27620 2.0" 
$ns at 172.63790992644576 "$node_(163) setdest 97549 36519 20.0" 
$ns at 353.07302062999173 "$node_(163) setdest 38241 137 6.0" 
$ns at 430.09391043196706 "$node_(163) setdest 24831 36089 5.0" 
$ns at 462.7809359842285 "$node_(163) setdest 89338 30271 8.0" 
$ns at 532.5750706806759 "$node_(163) setdest 54025 57188 19.0" 
$ns at 645.1430674140483 "$node_(163) setdest 154876 4356 17.0" 
$ns at 772.6289566580011 "$node_(163) setdest 90426 60571 1.0" 
$ns at 805.0005614587459 "$node_(163) setdest 213797 20718 19.0" 
$ns at 156.10765154309615 "$node_(164) setdest 16620 35115 2.0" 
$ns at 202.68254841739122 "$node_(164) setdest 104387 10895 10.0" 
$ns at 233.376849581247 "$node_(164) setdest 127242 19583 4.0" 
$ns at 298.26339530354267 "$node_(164) setdest 29629 23974 9.0" 
$ns at 387.31806670959304 "$node_(164) setdest 34753 23212 4.0" 
$ns at 417.39605411157015 "$node_(164) setdest 85159 12261 19.0" 
$ns at 487.36946756638645 "$node_(164) setdest 81204 41120 17.0" 
$ns at 572.1888378543546 "$node_(164) setdest 118473 24610 12.0" 
$ns at 622.1480912130381 "$node_(164) setdest 161696 17596 9.0" 
$ns at 727.6463314272588 "$node_(164) setdest 154142 1365 2.0" 
$ns at 759.4253167376118 "$node_(164) setdest 235090 17819 5.0" 
$ns at 825.545085729965 "$node_(164) setdest 92774 9849 1.0" 
$ns at 860.13209511541 "$node_(164) setdest 43181 1878 6.0" 
$ns at 111.59798814465117 "$node_(165) setdest 33438 24287 10.0" 
$ns at 216.67878558454137 "$node_(165) setdest 120702 43854 18.0" 
$ns at 412.21209538534083 "$node_(165) setdest 181533 38232 4.0" 
$ns at 469.08849714459154 "$node_(165) setdest 62313 40044 1.0" 
$ns at 506.2241911206444 "$node_(165) setdest 133026 61926 9.0" 
$ns at 560.2500125947495 "$node_(165) setdest 187477 25146 20.0" 
$ns at 641.8970876596932 "$node_(165) setdest 40912 62526 2.0" 
$ns at 685.02219798964 "$node_(165) setdest 130663 79 13.0" 
$ns at 729.3765222847055 "$node_(165) setdest 250160 73475 2.0" 
$ns at 763.7729766576938 "$node_(165) setdest 82903 36351 14.0" 
$ns at 878.7028559571795 "$node_(165) setdest 51864 75077 11.0" 
$ns at 143.32393881662833 "$node_(166) setdest 2875 3172 7.0" 
$ns at 223.3897297820296 "$node_(166) setdest 101579 23094 8.0" 
$ns at 313.0152405408878 "$node_(166) setdest 112928 21524 17.0" 
$ns at 431.40263496362314 "$node_(166) setdest 158727 51656 17.0" 
$ns at 563.1351507857522 "$node_(166) setdest 154468 71761 9.0" 
$ns at 600.7125907839895 "$node_(166) setdest 96911 18498 10.0" 
$ns at 660.7561907760112 "$node_(166) setdest 46000 78833 16.0" 
$ns at 790.0267680341248 "$node_(166) setdest 116647 53055 5.0" 
$ns at 829.3641925481922 "$node_(166) setdest 149052 36986 6.0" 
$ns at 118.83638150501595 "$node_(167) setdest 60459 24551 11.0" 
$ns at 207.9800716808872 "$node_(167) setdest 7009 8776 15.0" 
$ns at 385.07502514746915 "$node_(167) setdest 91403 12662 8.0" 
$ns at 490.285004207476 "$node_(167) setdest 40336 41730 20.0" 
$ns at 681.583986115551 "$node_(167) setdest 202911 66203 18.0" 
$ns at 722.5871273699336 "$node_(167) setdest 250042 64864 9.0" 
$ns at 776.0749709868593 "$node_(167) setdest 40803 33499 8.0" 
$ns at 844.8488836398667 "$node_(167) setdest 70641 7236 9.0" 
$ns at 150.72307573760222 "$node_(168) setdest 121428 24674 9.0" 
$ns at 196.08703441484363 "$node_(168) setdest 74623 35033 5.0" 
$ns at 241.42510262214216 "$node_(168) setdest 42643 6931 16.0" 
$ns at 283.8256493057191 "$node_(168) setdest 23720 30250 6.0" 
$ns at 341.6389170822666 "$node_(168) setdest 19230 10423 11.0" 
$ns at 465.51337887874803 "$node_(168) setdest 19344 34428 16.0" 
$ns at 644.9408672514062 "$node_(168) setdest 194219 49982 11.0" 
$ns at 736.1751414330472 "$node_(168) setdest 178697 26961 13.0" 
$ns at 807.5796605770984 "$node_(168) setdest 219093 57809 2.0" 
$ns at 846.2905775077663 "$node_(168) setdest 81294 79968 2.0" 
$ns at 896.0346396927424 "$node_(168) setdest 76307 29785 11.0" 
$ns at 139.01797849991885 "$node_(169) setdest 576 14741 5.0" 
$ns at 202.93038839971535 "$node_(169) setdest 74178 27440 4.0" 
$ns at 257.47996362724933 "$node_(169) setdest 106332 36420 6.0" 
$ns at 306.4999573442311 "$node_(169) setdest 163892 51991 1.0" 
$ns at 345.94662582591974 "$node_(169) setdest 31383 22852 18.0" 
$ns at 477.18333126348546 "$node_(169) setdest 100769 36515 11.0" 
$ns at 540.8560195503328 "$node_(169) setdest 7091 18210 19.0" 
$ns at 618.1632390994444 "$node_(169) setdest 40988 63043 5.0" 
$ns at 653.95814620967 "$node_(169) setdest 154363 63371 5.0" 
$ns at 719.0110735439401 "$node_(169) setdest 164224 79900 11.0" 
$ns at 772.9854301880367 "$node_(169) setdest 189298 19928 17.0" 
$ns at 108.96207640797957 "$node_(170) setdest 12955 10946 7.0" 
$ns at 184.82982160349493 "$node_(170) setdest 75390 21577 12.0" 
$ns at 251.77745367344943 "$node_(170) setdest 104607 40646 12.0" 
$ns at 318.09799360952513 "$node_(170) setdest 34703 20347 19.0" 
$ns at 382.8610495667699 "$node_(170) setdest 51407 39018 7.0" 
$ns at 429.91200608545284 "$node_(170) setdest 109818 36069 11.0" 
$ns at 547.4662794644669 "$node_(170) setdest 65348 58190 12.0" 
$ns at 636.3853850311226 "$node_(170) setdest 135548 28774 1.0" 
$ns at 669.7234798122628 "$node_(170) setdest 96370 1151 19.0" 
$ns at 751.2070216098273 "$node_(170) setdest 189783 37815 17.0" 
$ns at 804.1349915726655 "$node_(170) setdest 63500 17303 4.0" 
$ns at 845.6980401859939 "$node_(170) setdest 4044 37498 8.0" 
$ns at 100.65933510299011 "$node_(171) setdest 69129 20814 16.0" 
$ns at 279.2736539049151 "$node_(171) setdest 48537 36624 2.0" 
$ns at 322.4435962519548 "$node_(171) setdest 119100 32981 8.0" 
$ns at 393.9521319384413 "$node_(171) setdest 115464 10577 18.0" 
$ns at 495.1110316735943 "$node_(171) setdest 120135 59657 7.0" 
$ns at 555.4210417678055 "$node_(171) setdest 160714 50484 17.0" 
$ns at 650.1749700994388 "$node_(171) setdest 233806 9790 13.0" 
$ns at 705.4268547389344 "$node_(171) setdest 245155 32060 14.0" 
$ns at 865.341331802439 "$node_(171) setdest 148772 22443 6.0" 
$ns at 102.73431201745495 "$node_(172) setdest 886 25465 2.0" 
$ns at 146.4797146930172 "$node_(172) setdest 15582 18970 11.0" 
$ns at 256.46581310761655 "$node_(172) setdest 118752 50249 6.0" 
$ns at 311.1501383040221 "$node_(172) setdest 87299 18530 19.0" 
$ns at 485.7785830442957 "$node_(172) setdest 32769 9236 19.0" 
$ns at 624.0498606501264 "$node_(172) setdest 159620 22529 16.0" 
$ns at 718.807865143837 "$node_(172) setdest 205509 35767 1.0" 
$ns at 752.0381022643486 "$node_(172) setdest 17481 9964 7.0" 
$ns at 851.3166600560512 "$node_(172) setdest 95424 76935 13.0" 
$ns at 160.38451279749825 "$node_(173) setdest 17777 22503 5.0" 
$ns at 201.13000508285415 "$node_(173) setdest 37910 18582 13.0" 
$ns at 279.51339887718456 "$node_(173) setdest 90399 35645 15.0" 
$ns at 447.7726299554198 "$node_(173) setdest 101023 32411 6.0" 
$ns at 479.5790837902348 "$node_(173) setdest 167841 54966 5.0" 
$ns at 518.060155348472 "$node_(173) setdest 174079 22466 5.0" 
$ns at 583.4137681719147 "$node_(173) setdest 232320 2393 15.0" 
$ns at 720.02225559115 "$node_(173) setdest 20830 14249 13.0" 
$ns at 771.609456305389 "$node_(173) setdest 34897 24993 17.0" 
$ns at 861.1897761955966 "$node_(173) setdest 8663 17146 1.0" 
$ns at 894.5190447428197 "$node_(173) setdest 255710 87567 11.0" 
$ns at 224.00023819508414 "$node_(174) setdest 18752 38732 20.0" 
$ns at 262.91786217412766 "$node_(174) setdest 101304 16156 16.0" 
$ns at 425.04802021700084 "$node_(174) setdest 171928 23387 18.0" 
$ns at 468.63799145881666 "$node_(174) setdest 156480 22793 7.0" 
$ns at 568.4814998331407 "$node_(174) setdest 138966 20179 18.0" 
$ns at 691.4833141668728 "$node_(174) setdest 220793 69877 6.0" 
$ns at 772.6525977883441 "$node_(174) setdest 95860 8769 10.0" 
$ns at 880.8649662930486 "$node_(174) setdest 240479 31543 6.0" 
$ns at 284.4901914600234 "$node_(175) setdest 75328 16243 1.0" 
$ns at 320.184032616357 "$node_(175) setdest 73542 45305 12.0" 
$ns at 458.12033941260256 "$node_(175) setdest 64453 50090 4.0" 
$ns at 510.1371687206499 "$node_(175) setdest 99125 27893 14.0" 
$ns at 668.0292351677011 "$node_(175) setdest 179463 80529 16.0" 
$ns at 702.0645603679015 "$node_(175) setdest 218867 77064 19.0" 
$ns at 898.6156848315713 "$node_(175) setdest 68293 19737 16.0" 
$ns at 117.52540828960791 "$node_(176) setdest 50663 28199 18.0" 
$ns at 170.77352061902138 "$node_(176) setdest 115411 36299 5.0" 
$ns at 210.66207758325632 "$node_(176) setdest 104346 1353 14.0" 
$ns at 351.20783513512026 "$node_(176) setdest 27691 14525 9.0" 
$ns at 461.9585139664325 "$node_(176) setdest 74649 61859 17.0" 
$ns at 602.1551496579482 "$node_(176) setdest 166902 25770 12.0" 
$ns at 690.7214598088806 "$node_(176) setdest 182485 9793 15.0" 
$ns at 844.2485131403157 "$node_(176) setdest 165831 32699 4.0" 
$ns at 885.5691983101844 "$node_(176) setdest 46611 82234 12.0" 
$ns at 178.27673727856748 "$node_(177) setdest 576 17968 10.0" 
$ns at 274.45517826064673 "$node_(177) setdest 16986 34693 14.0" 
$ns at 383.41873817425943 "$node_(177) setdest 68500 48131 17.0" 
$ns at 436.4410100546264 "$node_(177) setdest 176686 13308 6.0" 
$ns at 481.87363767336734 "$node_(177) setdest 34696 29515 12.0" 
$ns at 627.6241335287635 "$node_(177) setdest 42279 27557 17.0" 
$ns at 824.9336591884035 "$node_(177) setdest 21256 74502 7.0" 
$ns at 124.8743759960895 "$node_(178) setdest 54969 28758 11.0" 
$ns at 263.7670081996914 "$node_(178) setdest 130623 877 1.0" 
$ns at 299.4198709639796 "$node_(178) setdest 1736 35377 1.0" 
$ns at 332.5025085539166 "$node_(178) setdest 120777 17793 4.0" 
$ns at 381.30528231626914 "$node_(178) setdest 158566 58139 4.0" 
$ns at 435.87601512921054 "$node_(178) setdest 91202 39617 14.0" 
$ns at 472.8577712501492 "$node_(178) setdest 50987 31956 9.0" 
$ns at 548.5898460869082 "$node_(178) setdest 152409 70116 19.0" 
$ns at 680.970684707009 "$node_(178) setdest 139366 47320 2.0" 
$ns at 726.697906375033 "$node_(178) setdest 6573 11876 5.0" 
$ns at 789.0253800681394 "$node_(178) setdest 199977 2582 19.0" 
$ns at 172.72905853853757 "$node_(179) setdest 99209 22570 7.0" 
$ns at 207.4270105692817 "$node_(179) setdest 47915 7454 10.0" 
$ns at 333.95653374400126 "$node_(179) setdest 14850 47456 11.0" 
$ns at 436.73678736883096 "$node_(179) setdest 88101 55268 19.0" 
$ns at 543.5048154183673 "$node_(179) setdest 148753 63827 4.0" 
$ns at 585.9221868544781 "$node_(179) setdest 176764 10345 16.0" 
$ns at 707.8463715986056 "$node_(179) setdest 152838 15042 2.0" 
$ns at 741.4622492048128 "$node_(179) setdest 146241 75423 13.0" 
$ns at 788.5924717542694 "$node_(179) setdest 16469 7377 16.0" 
$ns at 103.0439331488661 "$node_(180) setdest 93034 9433 18.0" 
$ns at 244.76787722384066 "$node_(180) setdest 43896 12726 7.0" 
$ns at 275.72170886547934 "$node_(180) setdest 23686 8486 12.0" 
$ns at 340.03826454627466 "$node_(180) setdest 3678 23707 11.0" 
$ns at 405.37456887546716 "$node_(180) setdest 160744 6982 17.0" 
$ns at 520.0541705490923 "$node_(180) setdest 117296 2850 5.0" 
$ns at 577.9967345511625 "$node_(180) setdest 77733 68252 14.0" 
$ns at 618.9742520115551 "$node_(180) setdest 199840 20760 5.0" 
$ns at 688.2979080963789 "$node_(180) setdest 86884 59008 15.0" 
$ns at 834.2056394014867 "$node_(180) setdest 156310 58953 16.0" 
$ns at 870.6683574516138 "$node_(180) setdest 31843 41710 12.0" 
$ns at 182.6051733024792 "$node_(181) setdest 41778 10483 10.0" 
$ns at 215.99344068557028 "$node_(181) setdest 50188 14698 5.0" 
$ns at 250.93406262781866 "$node_(181) setdest 118491 47647 1.0" 
$ns at 284.2439082216237 "$node_(181) setdest 161347 694 13.0" 
$ns at 396.44019636691684 "$node_(181) setdest 170463 36941 18.0" 
$ns at 597.7758827124267 "$node_(181) setdest 210659 25435 1.0" 
$ns at 628.5438983668806 "$node_(181) setdest 6739 46541 18.0" 
$ns at 801.2482816712062 "$node_(181) setdest 65693 35658 15.0" 
$ns at 879.189051633592 "$node_(181) setdest 186003 28134 7.0" 
$ns at 203.7355317133802 "$node_(182) setdest 34844 32180 6.0" 
$ns at 293.3800890279972 "$node_(182) setdest 127832 4784 12.0" 
$ns at 437.38565043185247 "$node_(182) setdest 138209 61298 8.0" 
$ns at 503.3194110563873 "$node_(182) setdest 101630 55945 6.0" 
$ns at 591.0910911652074 "$node_(182) setdest 115310 46128 8.0" 
$ns at 627.6996757646826 "$node_(182) setdest 59053 6275 17.0" 
$ns at 740.5616052496977 "$node_(182) setdest 97476 11366 8.0" 
$ns at 806.1015286088038 "$node_(182) setdest 58357 3995 12.0" 
$ns at 839.2279596794506 "$node_(182) setdest 246945 86897 14.0" 
$ns at 883.8470623103246 "$node_(182) setdest 193761 80061 14.0" 
$ns at 124.54013422901878 "$node_(183) setdest 41600 20444 12.0" 
$ns at 265.60033401583075 "$node_(183) setdest 75199 42643 6.0" 
$ns at 325.03269900960777 "$node_(183) setdest 35868 24230 17.0" 
$ns at 473.5669869338509 "$node_(183) setdest 184650 12672 7.0" 
$ns at 540.6513974430748 "$node_(183) setdest 128445 12768 8.0" 
$ns at 610.4501936977324 "$node_(183) setdest 183310 35421 17.0" 
$ns at 653.8875965837223 "$node_(183) setdest 27343 27550 9.0" 
$ns at 771.7636038943347 "$node_(183) setdest 129906 55470 17.0" 
$ns at 810.280230613735 "$node_(183) setdest 160691 7072 9.0" 
$ns at 163.64307320720823 "$node_(184) setdest 59199 10056 15.0" 
$ns at 200.45536228385635 "$node_(184) setdest 88607 28761 11.0" 
$ns at 241.90538988658426 "$node_(184) setdest 31258 18920 14.0" 
$ns at 278.3404804547615 "$node_(184) setdest 70048 50918 9.0" 
$ns at 394.1074244895424 "$node_(184) setdest 47673 45396 5.0" 
$ns at 440.14604167171336 "$node_(184) setdest 5360 34321 5.0" 
$ns at 496.15701344078303 "$node_(184) setdest 207955 34018 10.0" 
$ns at 587.969788253508 "$node_(184) setdest 156851 74103 19.0" 
$ns at 782.936719539664 "$node_(184) setdest 88281 14457 16.0" 
$ns at 100.35423226907437 "$node_(185) setdest 49068 13072 1.0" 
$ns at 140.02071670582075 "$node_(185) setdest 89225 277 10.0" 
$ns at 195.15519633513847 "$node_(185) setdest 59204 2345 12.0" 
$ns at 315.95922791888245 "$node_(185) setdest 129473 8292 13.0" 
$ns at 391.4135406394885 "$node_(185) setdest 182032 23139 5.0" 
$ns at 431.56220701581384 "$node_(185) setdest 1322 8348 16.0" 
$ns at 567.0240416023557 "$node_(185) setdest 21971 23754 6.0" 
$ns at 602.1291831047971 "$node_(185) setdest 115740 32756 10.0" 
$ns at 663.0305959695154 "$node_(185) setdest 127357 55501 16.0" 
$ns at 709.3690363106288 "$node_(185) setdest 60436 53127 17.0" 
$ns at 857.8074603485372 "$node_(185) setdest 95374 67799 19.0" 
$ns at 128.06919383402206 "$node_(186) setdest 76195 26990 19.0" 
$ns at 330.11736359415085 "$node_(186) setdest 117941 50743 12.0" 
$ns at 418.6743314243233 "$node_(186) setdest 93271 55180 3.0" 
$ns at 474.7470160474275 "$node_(186) setdest 112992 44406 17.0" 
$ns at 622.0279242383639 "$node_(186) setdest 196162 1223 11.0" 
$ns at 656.3143940806053 "$node_(186) setdest 79219 28124 19.0" 
$ns at 744.9133024257214 "$node_(186) setdest 168992 26661 1.0" 
$ns at 780.3904483332282 "$node_(186) setdest 159817 54298 7.0" 
$ns at 868.796244761365 "$node_(186) setdest 93671 49747 9.0" 
$ns at 161.12194425440345 "$node_(187) setdest 117015 31326 1.0" 
$ns at 200.05806745362943 "$node_(187) setdest 77631 14421 9.0" 
$ns at 251.19740599243727 "$node_(187) setdest 75986 46125 16.0" 
$ns at 285.4168337940945 "$node_(187) setdest 61530 13943 5.0" 
$ns at 347.6540762417895 "$node_(187) setdest 156469 12502 5.0" 
$ns at 397.9541957512519 "$node_(187) setdest 99746 10824 7.0" 
$ns at 468.64343308493886 "$node_(187) setdest 30072 9034 6.0" 
$ns at 525.1479425948157 "$node_(187) setdest 44554 19100 18.0" 
$ns at 713.3189644103559 "$node_(187) setdest 249971 18880 3.0" 
$ns at 745.7068655349498 "$node_(187) setdest 204982 10399 7.0" 
$ns at 798.868861287557 "$node_(187) setdest 89250 3537 17.0" 
$ns at 874.2916265794718 "$node_(187) setdest 206013 40224 1.0" 
$ns at 105.97604764016674 "$node_(188) setdest 79215 15959 1.0" 
$ns at 139.9195065632056 "$node_(188) setdest 29736 25752 10.0" 
$ns at 207.31359390654637 "$node_(188) setdest 101467 32431 4.0" 
$ns at 249.76822031091345 "$node_(188) setdest 75445 39549 19.0" 
$ns at 467.77649459904785 "$node_(188) setdest 165885 10009 5.0" 
$ns at 512.0869360040492 "$node_(188) setdest 177593 33185 11.0" 
$ns at 649.111950698432 "$node_(188) setdest 51246 61608 9.0" 
$ns at 720.2670895232229 "$node_(188) setdest 172433 11490 11.0" 
$ns at 853.6018449225172 "$node_(188) setdest 206176 22840 15.0" 
$ns at 122.00258491545618 "$node_(189) setdest 38578 3503 2.0" 
$ns at 164.0528690252146 "$node_(189) setdest 21695 15054 3.0" 
$ns at 213.335455981913 "$node_(189) setdest 26249 25793 2.0" 
$ns at 261.5950238044629 "$node_(189) setdest 68017 23390 12.0" 
$ns at 352.61605324017967 "$node_(189) setdest 72608 738 19.0" 
$ns at 398.6549878617631 "$node_(189) setdest 15651 31244 1.0" 
$ns at 429.9279682840723 "$node_(189) setdest 22976 1340 5.0" 
$ns at 488.17742232437797 "$node_(189) setdest 114291 49996 16.0" 
$ns at 652.1605270596195 "$node_(189) setdest 133845 80243 9.0" 
$ns at 700.6092155100324 "$node_(189) setdest 132852 26020 17.0" 
$ns at 795.38504202048 "$node_(189) setdest 6174 83670 1.0" 
$ns at 830.7800642211494 "$node_(189) setdest 145457 16132 12.0" 
$ns at 101.71599896187243 "$node_(190) setdest 51542 7162 1.0" 
$ns at 137.33740637720473 "$node_(190) setdest 66876 29346 5.0" 
$ns at 203.156739020394 "$node_(190) setdest 16671 15583 19.0" 
$ns at 306.4517727976135 "$node_(190) setdest 76230 27407 15.0" 
$ns at 370.948222303318 "$node_(190) setdest 14121 31494 3.0" 
$ns at 420.62812754772904 "$node_(190) setdest 107060 30399 2.0" 
$ns at 465.56611159338684 "$node_(190) setdest 18921 2461 9.0" 
$ns at 547.8176642128876 "$node_(190) setdest 139384 52331 2.0" 
$ns at 596.3525113137935 "$node_(190) setdest 145011 27478 17.0" 
$ns at 652.1160721082907 "$node_(190) setdest 86571 16599 2.0" 
$ns at 695.2366091650473 "$node_(190) setdest 158632 41017 9.0" 
$ns at 754.7647590067194 "$node_(190) setdest 74045 67804 8.0" 
$ns at 808.5485106035978 "$node_(190) setdest 103750 84558 3.0" 
$ns at 860.9695573839826 "$node_(190) setdest 194206 45918 17.0" 
$ns at 164.3705122135538 "$node_(191) setdest 70091 10874 6.0" 
$ns at 201.66561637609186 "$node_(191) setdest 57124 23968 19.0" 
$ns at 404.03603778883644 "$node_(191) setdest 126683 55953 7.0" 
$ns at 463.6946418569054 "$node_(191) setdest 188235 58572 14.0" 
$ns at 630.8788067846185 "$node_(191) setdest 149383 43778 11.0" 
$ns at 726.2369877688856 "$node_(191) setdest 38188 43849 16.0" 
$ns at 757.4668296904352 "$node_(191) setdest 155666 43220 1.0" 
$ns at 790.4759046084982 "$node_(191) setdest 267178 72955 12.0" 
$ns at 857.0656860605955 "$node_(191) setdest 135103 74230 3.0" 
$ns at 897.2640720429752 "$node_(191) setdest 91350 64051 18.0" 
$ns at 189.63220205031192 "$node_(192) setdest 121668 33175 18.0" 
$ns at 298.3719891674947 "$node_(192) setdest 66377 2900 13.0" 
$ns at 413.19212205244395 "$node_(192) setdest 48730 1676 7.0" 
$ns at 499.41164165545894 "$node_(192) setdest 59962 57299 4.0" 
$ns at 534.6220742529708 "$node_(192) setdest 205116 27315 13.0" 
$ns at 587.2948839929626 "$node_(192) setdest 184633 45002 11.0" 
$ns at 700.7356292365087 "$node_(192) setdest 230989 8808 16.0" 
$ns at 843.9350616700908 "$node_(192) setdest 87289 5487 1.0" 
$ns at 877.318671251843 "$node_(192) setdest 256311 41247 15.0" 
$ns at 101.67848234806678 "$node_(193) setdest 82910 9488 1.0" 
$ns at 132.06174115763477 "$node_(193) setdest 89556 28546 1.0" 
$ns at 169.16463197813994 "$node_(193) setdest 92785 7459 18.0" 
$ns at 319.4804935750587 "$node_(193) setdest 114674 40733 9.0" 
$ns at 358.61298696079064 "$node_(193) setdest 91888 27889 16.0" 
$ns at 442.97249260944244 "$node_(193) setdest 45598 49102 4.0" 
$ns at 501.85525921228236 "$node_(193) setdest 45104 1132 1.0" 
$ns at 538.203071513986 "$node_(193) setdest 123138 63622 8.0" 
$ns at 568.694355822709 "$node_(193) setdest 223290 6326 12.0" 
$ns at 636.8292594613496 "$node_(193) setdest 211414 22854 4.0" 
$ns at 692.0110081773233 "$node_(193) setdest 229879 32556 3.0" 
$ns at 728.1476552167807 "$node_(193) setdest 105344 56766 17.0" 
$ns at 769.880184848404 "$node_(193) setdest 89386 44407 18.0" 
$ns at 843.7680240631933 "$node_(193) setdest 102624 40291 3.0" 
$ns at 887.1257491007674 "$node_(193) setdest 95056 57153 16.0" 
$ns at 146.56221664191196 "$node_(194) setdest 20895 11313 9.0" 
$ns at 185.6359361050243 "$node_(194) setdest 108511 24448 4.0" 
$ns at 252.47200382890037 "$node_(194) setdest 10077 584 17.0" 
$ns at 451.70308061329604 "$node_(194) setdest 103833 43481 8.0" 
$ns at 516.3363121644079 "$node_(194) setdest 85245 55071 7.0" 
$ns at 549.0649672147417 "$node_(194) setdest 202481 18329 19.0" 
$ns at 744.043829228985 "$node_(194) setdest 196406 68849 9.0" 
$ns at 830.8646785426606 "$node_(194) setdest 109336 68987 5.0" 
$ns at 893.6684869824292 "$node_(194) setdest 65927 82039 1.0" 
$ns at 201.0612217992099 "$node_(195) setdest 64663 18564 18.0" 
$ns at 323.4483119734683 "$node_(195) setdest 86627 51930 6.0" 
$ns at 397.3138707312688 "$node_(195) setdest 160748 23397 20.0" 
$ns at 562.525068098991 "$node_(195) setdest 80393 71181 4.0" 
$ns at 614.4300239126892 "$node_(195) setdest 214813 28652 16.0" 
$ns at 790.5419857927359 "$node_(195) setdest 168421 28950 17.0" 
$ns at 851.6231308410406 "$node_(195) setdest 185156 74142 13.0" 
$ns at 142.38287949244875 "$node_(196) setdest 63422 28649 9.0" 
$ns at 205.60347592211411 "$node_(196) setdest 56155 5733 6.0" 
$ns at 255.44118451077932 "$node_(196) setdest 142231 45644 19.0" 
$ns at 384.6689240012021 "$node_(196) setdest 170862 35308 10.0" 
$ns at 488.11481854807096 "$node_(196) setdest 116771 47017 10.0" 
$ns at 598.1800417916273 "$node_(196) setdest 81940 13286 11.0" 
$ns at 641.884187292249 "$node_(196) setdest 203437 16543 7.0" 
$ns at 692.0307572709817 "$node_(196) setdest 130157 78042 1.0" 
$ns at 730.83953527829 "$node_(196) setdest 143285 16512 8.0" 
$ns at 821.7628151179309 "$node_(196) setdest 70347 28690 9.0" 
$ns at 111.75415643040927 "$node_(197) setdest 70109 19414 14.0" 
$ns at 224.78758279421498 "$node_(197) setdest 48889 25502 8.0" 
$ns at 270.64712216847465 "$node_(197) setdest 64091 21297 5.0" 
$ns at 331.11310415292076 "$node_(197) setdest 146846 23769 4.0" 
$ns at 370.6394252031592 "$node_(197) setdest 189556 53737 9.0" 
$ns at 400.9505577841311 "$node_(197) setdest 184735 22121 18.0" 
$ns at 476.3919481077153 "$node_(197) setdest 91961 43077 15.0" 
$ns at 625.4545507130665 "$node_(197) setdest 181886 49794 18.0" 
$ns at 693.6818096308483 "$node_(197) setdest 185269 3469 7.0" 
$ns at 763.7657690859232 "$node_(197) setdest 112894 51086 11.0" 
$ns at 816.3432439598209 "$node_(197) setdest 8102 39024 8.0" 
$ns at 888.1297259657599 "$node_(197) setdest 150861 40893 8.0" 
$ns at 124.57675167010655 "$node_(198) setdest 13424 19152 6.0" 
$ns at 158.01423137958443 "$node_(198) setdest 127196 2415 2.0" 
$ns at 205.72535059861985 "$node_(198) setdest 72551 40678 14.0" 
$ns at 288.56321543306785 "$node_(198) setdest 32807 46236 16.0" 
$ns at 370.59496367880035 "$node_(198) setdest 74954 49050 7.0" 
$ns at 444.4749759879407 "$node_(198) setdest 101116 61338 4.0" 
$ns at 491.24754636511045 "$node_(198) setdest 67071 60377 5.0" 
$ns at 553.1780012836948 "$node_(198) setdest 104154 68498 9.0" 
$ns at 671.4311356589513 "$node_(198) setdest 205173 40888 14.0" 
$ns at 751.5538840094725 "$node_(198) setdest 165788 82183 16.0" 
$ns at 898.0759811031932 "$node_(198) setdest 22802 74984 15.0" 
$ns at 132.53387943651552 "$node_(199) setdest 47498 18946 13.0" 
$ns at 165.7730588099248 "$node_(199) setdest 59538 28556 3.0" 
$ns at 201.16507743495868 "$node_(199) setdest 36558 38660 8.0" 
$ns at 285.51276518224336 "$node_(199) setdest 162919 52028 4.0" 
$ns at 340.87305229741924 "$node_(199) setdest 118564 54076 5.0" 
$ns at 403.77706684283135 "$node_(199) setdest 133593 55423 8.0" 
$ns at 484.78011857070857 "$node_(199) setdest 133135 55819 1.0" 
$ns at 522.7044026513053 "$node_(199) setdest 7490 66844 20.0" 
$ns at 709.2050673847378 "$node_(199) setdest 192140 51986 13.0" 
$ns at 772.6844024989132 "$node_(199) setdest 127427 17048 8.0" 
$ns at 847.7559884551822 "$node_(199) setdest 80465 88002 11.0" 
$ns at 223.74212276372828 "$node_(200) setdest 51926 24673 6.0" 
$ns at 268.0845320286883 "$node_(200) setdest 53866 9000 10.0" 
$ns at 373.3717029707751 "$node_(200) setdest 72355 246 17.0" 
$ns at 525.151500345738 "$node_(200) setdest 42208 42655 18.0" 
$ns at 616.7696571239954 "$node_(200) setdest 98436 6779 13.0" 
$ns at 745.9961891183632 "$node_(200) setdest 54904 18412 8.0" 
$ns at 842.0987118136139 "$node_(200) setdest 124499 44266 6.0" 
$ns at 207.75714904443163 "$node_(201) setdest 90661 39402 18.0" 
$ns at 258.61309865385743 "$node_(201) setdest 101464 29167 5.0" 
$ns at 299.0646029007932 "$node_(201) setdest 62918 16466 18.0" 
$ns at 448.7497855847149 "$node_(201) setdest 40817 30326 7.0" 
$ns at 496.273840600768 "$node_(201) setdest 126737 35199 13.0" 
$ns at 637.2782882018673 "$node_(201) setdest 97611 33080 10.0" 
$ns at 714.1160806168218 "$node_(201) setdest 133868 36158 6.0" 
$ns at 803.6146029495458 "$node_(201) setdest 114290 6596 8.0" 
$ns at 865.4671693996269 "$node_(201) setdest 96239 14310 20.0" 
$ns at 260.30083444427225 "$node_(202) setdest 20759 39506 4.0" 
$ns at 297.57220914289593 "$node_(202) setdest 86147 10660 16.0" 
$ns at 406.55897993649506 "$node_(202) setdest 40276 31020 9.0" 
$ns at 513.342366429797 "$node_(202) setdest 26910 19301 11.0" 
$ns at 632.7691113231126 "$node_(202) setdest 58519 12669 14.0" 
$ns at 783.8682397626989 "$node_(202) setdest 36720 9281 13.0" 
$ns at 853.5670903779796 "$node_(202) setdest 105289 39388 3.0" 
$ns at 899.967701076594 "$node_(202) setdest 77616 12181 7.0" 
$ns at 274.0578723201054 "$node_(203) setdest 68617 39324 4.0" 
$ns at 315.4032317483657 "$node_(203) setdest 92858 39430 10.0" 
$ns at 386.7607396689459 "$node_(203) setdest 58638 8111 6.0" 
$ns at 448.6156820402316 "$node_(203) setdest 23363 35617 1.0" 
$ns at 482.0805886219922 "$node_(203) setdest 66505 25919 16.0" 
$ns at 512.9266356500051 "$node_(203) setdest 99895 10842 8.0" 
$ns at 554.2090640383824 "$node_(203) setdest 55446 34834 20.0" 
$ns at 729.0303844762383 "$node_(203) setdest 109204 14903 18.0" 
$ns at 860.4335519411266 "$node_(203) setdest 35240 26923 13.0" 
$ns at 237.2506003367295 "$node_(204) setdest 33376 25966 2.0" 
$ns at 285.51176095611305 "$node_(204) setdest 18085 10891 9.0" 
$ns at 382.8312360128515 "$node_(204) setdest 120568 481 20.0" 
$ns at 431.9336475138076 "$node_(204) setdest 46884 2060 17.0" 
$ns at 560.5605258101705 "$node_(204) setdest 102964 15153 16.0" 
$ns at 743.281433559012 "$node_(204) setdest 73096 33888 17.0" 
$ns at 235.5311237504385 "$node_(205) setdest 1935 12039 7.0" 
$ns at 328.6380787453732 "$node_(205) setdest 47159 26542 14.0" 
$ns at 360.2793235246981 "$node_(205) setdest 36374 14215 11.0" 
$ns at 407.8521116735889 "$node_(205) setdest 113599 25752 9.0" 
$ns at 486.3673994903717 "$node_(205) setdest 10222 35743 10.0" 
$ns at 615.7674488450605 "$node_(205) setdest 9328 13212 15.0" 
$ns at 675.8225224211099 "$node_(205) setdest 7536 9899 1.0" 
$ns at 714.8934486278522 "$node_(205) setdest 65838 32891 13.0" 
$ns at 790.4779895786903 "$node_(205) setdest 47377 19396 4.0" 
$ns at 829.7551936535551 "$node_(205) setdest 62124 29376 18.0" 
$ns at 224.09766638958092 "$node_(206) setdest 14040 19199 1.0" 
$ns at 254.83548612707452 "$node_(206) setdest 63460 17825 12.0" 
$ns at 314.9356540528258 "$node_(206) setdest 91132 37970 14.0" 
$ns at 391.8909041497158 "$node_(206) setdest 34255 15229 1.0" 
$ns at 427.8719288100221 "$node_(206) setdest 69274 6499 5.0" 
$ns at 485.7252207142631 "$node_(206) setdest 118621 27800 5.0" 
$ns at 539.1167260219995 "$node_(206) setdest 80101 8416 10.0" 
$ns at 641.1450242995319 "$node_(206) setdest 53404 4334 6.0" 
$ns at 674.7232850628171 "$node_(206) setdest 52681 24815 5.0" 
$ns at 722.6337727739424 "$node_(206) setdest 103507 11712 8.0" 
$ns at 763.0756134254553 "$node_(206) setdest 67754 4318 5.0" 
$ns at 798.3931147388364 "$node_(206) setdest 58263 22855 18.0" 
$ns at 215.65661230703182 "$node_(207) setdest 35247 15059 13.0" 
$ns at 297.66192789873276 "$node_(207) setdest 55162 14225 7.0" 
$ns at 361.2978469263272 "$node_(207) setdest 12385 20163 17.0" 
$ns at 472.9896878256341 "$node_(207) setdest 78021 8007 1.0" 
$ns at 506.85947315557473 "$node_(207) setdest 97264 25423 19.0" 
$ns at 699.8411606827815 "$node_(207) setdest 83174 3847 5.0" 
$ns at 752.798470739332 "$node_(207) setdest 43351 1576 10.0" 
$ns at 802.3250524968238 "$node_(207) setdest 3748 2388 7.0" 
$ns at 853.4060987483051 "$node_(207) setdest 58964 27676 12.0" 
$ns at 292.7818054839261 "$node_(208) setdest 129539 7520 3.0" 
$ns at 342.39387284791405 "$node_(208) setdest 90787 27534 3.0" 
$ns at 396.10094260558077 "$node_(208) setdest 13823 19665 1.0" 
$ns at 432.7497267959746 "$node_(208) setdest 61494 9505 1.0" 
$ns at 471.7601560144289 "$node_(208) setdest 72565 13752 20.0" 
$ns at 653.5437021100086 "$node_(208) setdest 39076 21654 20.0" 
$ns at 686.8372824764077 "$node_(208) setdest 67984 12627 12.0" 
$ns at 828.6831108283872 "$node_(208) setdest 19332 9257 19.0" 
$ns at 216.53454264334087 "$node_(209) setdest 70952 1981 19.0" 
$ns at 429.4795108652295 "$node_(209) setdest 127349 29414 12.0" 
$ns at 525.7539481859316 "$node_(209) setdest 86673 40837 19.0" 
$ns at 673.1090277989757 "$node_(209) setdest 132521 2163 10.0" 
$ns at 741.6446468895687 "$node_(209) setdest 52431 33463 1.0" 
$ns at 778.3238454092273 "$node_(209) setdest 110265 15633 17.0" 
$ns at 251.2062760473436 "$node_(210) setdest 10958 13775 7.0" 
$ns at 311.3856099056285 "$node_(210) setdest 27206 38014 12.0" 
$ns at 429.32269125113066 "$node_(210) setdest 29156 19056 8.0" 
$ns at 502.7290018956458 "$node_(210) setdest 76430 15161 8.0" 
$ns at 612.2824556011643 "$node_(210) setdest 129195 38830 10.0" 
$ns at 680.5567776081228 "$node_(210) setdest 71546 15183 11.0" 
$ns at 789.6902440845894 "$node_(210) setdest 19938 44253 15.0" 
$ns at 203.11976453737762 "$node_(211) setdest 88128 28981 12.0" 
$ns at 314.22204511274015 "$node_(211) setdest 127394 14054 3.0" 
$ns at 367.038616248247 "$node_(211) setdest 254 11428 15.0" 
$ns at 421.1659801349743 "$node_(211) setdest 125503 17436 14.0" 
$ns at 482.6452589813683 "$node_(211) setdest 78881 38685 19.0" 
$ns at 610.0891817095165 "$node_(211) setdest 78380 14855 2.0" 
$ns at 651.7037364810317 "$node_(211) setdest 121831 31357 3.0" 
$ns at 687.0793788521188 "$node_(211) setdest 14462 34738 11.0" 
$ns at 717.7502100255526 "$node_(211) setdest 120310 36407 5.0" 
$ns at 784.7105395665482 "$node_(211) setdest 60104 36881 9.0" 
$ns at 843.8934797659406 "$node_(211) setdest 16524 18571 9.0" 
$ns at 204.28455008521018 "$node_(212) setdest 82681 26160 12.0" 
$ns at 332.48181759667443 "$node_(212) setdest 48311 22755 4.0" 
$ns at 370.1261671114509 "$node_(212) setdest 71495 25375 7.0" 
$ns at 448.59131847520365 "$node_(212) setdest 35599 42098 5.0" 
$ns at 527.489262911596 "$node_(212) setdest 68333 16785 3.0" 
$ns at 581.8179909220783 "$node_(212) setdest 18501 4869 8.0" 
$ns at 616.6865194403823 "$node_(212) setdest 1523 15235 4.0" 
$ns at 678.7607762274921 "$node_(212) setdest 100096 26773 13.0" 
$ns at 762.7733610288901 "$node_(212) setdest 19648 16493 4.0" 
$ns at 794.2764487842549 "$node_(212) setdest 52361 21168 18.0" 
$ns at 245.37086373074834 "$node_(213) setdest 65055 20371 1.0" 
$ns at 281.03729686382195 "$node_(213) setdest 96796 26994 11.0" 
$ns at 311.25513548380894 "$node_(213) setdest 29883 12721 12.0" 
$ns at 428.2532170427688 "$node_(213) setdest 37073 44622 10.0" 
$ns at 472.323134980336 "$node_(213) setdest 64175 24769 18.0" 
$ns at 563.4607129291209 "$node_(213) setdest 113066 9212 1.0" 
$ns at 598.3796585696733 "$node_(213) setdest 114359 41511 14.0" 
$ns at 665.0225616270286 "$node_(213) setdest 91801 13393 5.0" 
$ns at 728.820807617926 "$node_(213) setdest 126194 13969 7.0" 
$ns at 771.9725168785744 "$node_(213) setdest 29807 19558 11.0" 
$ns at 872.9545535366537 "$node_(213) setdest 106122 19761 11.0" 
$ns at 291.08549767478655 "$node_(214) setdest 50309 22534 18.0" 
$ns at 356.9091627264116 "$node_(214) setdest 50429 13859 14.0" 
$ns at 483.3630788746773 "$node_(214) setdest 78313 24978 6.0" 
$ns at 571.2614616273771 "$node_(214) setdest 34887 36227 1.0" 
$ns at 602.2961472414453 "$node_(214) setdest 130843 5223 8.0" 
$ns at 671.2921942103427 "$node_(214) setdest 19367 15282 12.0" 
$ns at 756.7698540969826 "$node_(214) setdest 82423 40075 14.0" 
$ns at 803.1494981617367 "$node_(214) setdest 51724 25316 11.0" 
$ns at 242.2914418893463 "$node_(215) setdest 32491 31461 7.0" 
$ns at 321.93065464041865 "$node_(215) setdest 48445 6651 12.0" 
$ns at 372.0642794248804 "$node_(215) setdest 3512 1447 18.0" 
$ns at 485.11958323262326 "$node_(215) setdest 94622 3012 13.0" 
$ns at 591.7766624860029 "$node_(215) setdest 3707 42081 18.0" 
$ns at 732.263517056 "$node_(215) setdest 123667 41415 10.0" 
$ns at 768.2244572099183 "$node_(215) setdest 7193 10432 11.0" 
$ns at 848.0719444231871 "$node_(215) setdest 119922 27460 13.0" 
$ns at 203.61550335131736 "$node_(216) setdest 116596 8404 7.0" 
$ns at 287.2994246047279 "$node_(216) setdest 17230 10721 1.0" 
$ns at 322.0003610598651 "$node_(216) setdest 17343 18094 13.0" 
$ns at 438.7331003962754 "$node_(216) setdest 109058 6153 13.0" 
$ns at 594.9623078435864 "$node_(216) setdest 52398 44357 9.0" 
$ns at 683.1390779417835 "$node_(216) setdest 617 28592 12.0" 
$ns at 759.6520309103407 "$node_(216) setdest 26447 25491 3.0" 
$ns at 800.6000928100818 "$node_(216) setdest 84692 30505 11.0" 
$ns at 884.5656658813114 "$node_(216) setdest 18719 27451 8.0" 
$ns at 254.9044557882183 "$node_(217) setdest 128850 4517 15.0" 
$ns at 360.98358741158063 "$node_(217) setdest 12309 14833 11.0" 
$ns at 403.42304272894376 "$node_(217) setdest 31208 11646 12.0" 
$ns at 537.0464994319572 "$node_(217) setdest 24164 4420 2.0" 
$ns at 584.4429132168248 "$node_(217) setdest 67507 8282 13.0" 
$ns at 688.9083969286955 "$node_(217) setdest 68262 22561 1.0" 
$ns at 721.5904677947558 "$node_(217) setdest 15564 3484 3.0" 
$ns at 752.0314518536459 "$node_(217) setdest 128534 40778 1.0" 
$ns at 789.4560084042045 "$node_(217) setdest 59679 38708 2.0" 
$ns at 829.4874842860547 "$node_(217) setdest 112010 27792 1.0" 
$ns at 865.1717914697607 "$node_(217) setdest 79075 41332 13.0" 
$ns at 214.91669730400682 "$node_(218) setdest 17711 35662 3.0" 
$ns at 274.6625673673599 "$node_(218) setdest 103538 33312 1.0" 
$ns at 311.40463133095324 "$node_(218) setdest 3716 6674 12.0" 
$ns at 341.45171668213214 "$node_(218) setdest 53793 1258 4.0" 
$ns at 383.5529694306233 "$node_(218) setdest 118351 24449 6.0" 
$ns at 414.85594719169075 "$node_(218) setdest 82899 18378 4.0" 
$ns at 457.98023184420714 "$node_(218) setdest 35278 24166 8.0" 
$ns at 532.2256478862702 "$node_(218) setdest 75549 13194 15.0" 
$ns at 663.9694230830748 "$node_(218) setdest 109111 17286 18.0" 
$ns at 772.585829341128 "$node_(218) setdest 112576 27585 17.0" 
$ns at 895.4351432133863 "$node_(218) setdest 8387 33848 6.0" 
$ns at 224.46583725091426 "$node_(219) setdest 107846 30207 6.0" 
$ns at 298.23580074795564 "$node_(219) setdest 113514 17641 10.0" 
$ns at 404.49618911460055 "$node_(219) setdest 33214 14225 14.0" 
$ns at 443.4698958944785 "$node_(219) setdest 123424 17957 11.0" 
$ns at 565.0974576095834 "$node_(219) setdest 31718 23258 17.0" 
$ns at 737.9114231755171 "$node_(219) setdest 43493 24129 1.0" 
$ns at 772.7889999701724 "$node_(219) setdest 1705 32197 1.0" 
$ns at 809.8263633511851 "$node_(219) setdest 127809 2117 15.0" 
$ns at 858.7872743940999 "$node_(219) setdest 40286 43710 3.0" 
$ns at 234.13549240513035 "$node_(220) setdest 108296 2083 14.0" 
$ns at 273.6786037806561 "$node_(220) setdest 52120 12477 10.0" 
$ns at 345.50537592780404 "$node_(220) setdest 120305 4602 5.0" 
$ns at 378.09650937319043 "$node_(220) setdest 100906 8863 5.0" 
$ns at 453.1766160417502 "$node_(220) setdest 19722 27734 16.0" 
$ns at 499.76187603117694 "$node_(220) setdest 16259 13906 14.0" 
$ns at 624.4389139518958 "$node_(220) setdest 118522 4359 1.0" 
$ns at 660.3235421543106 "$node_(220) setdest 55838 5797 19.0" 
$ns at 693.7738482797248 "$node_(220) setdest 33588 14271 16.0" 
$ns at 829.2638399278746 "$node_(220) setdest 6720 4551 17.0" 
$ns at 209.05838264115363 "$node_(221) setdest 33022 28376 6.0" 
$ns at 247.69340303012507 "$node_(221) setdest 83595 16274 5.0" 
$ns at 296.45333938237087 "$node_(221) setdest 69785 18125 11.0" 
$ns at 351.32021308072825 "$node_(221) setdest 72104 17079 7.0" 
$ns at 437.9579811006991 "$node_(221) setdest 125049 34185 11.0" 
$ns at 470.8010049091703 "$node_(221) setdest 81662 6222 18.0" 
$ns at 516.2743616105776 "$node_(221) setdest 131704 16876 16.0" 
$ns at 692.1225541521551 "$node_(221) setdest 12891 16457 2.0" 
$ns at 737.7001059301147 "$node_(221) setdest 124854 34466 17.0" 
$ns at 221.86157465920124 "$node_(222) setdest 80186 32112 11.0" 
$ns at 254.73762097596403 "$node_(222) setdest 124141 25245 14.0" 
$ns at 422.63579006172415 "$node_(222) setdest 60153 14603 17.0" 
$ns at 559.3024711393617 "$node_(222) setdest 53809 41526 15.0" 
$ns at 607.5361396789009 "$node_(222) setdest 52347 16752 19.0" 
$ns at 770.7555930838382 "$node_(222) setdest 125808 25920 12.0" 
$ns at 834.4616999699842 "$node_(222) setdest 40325 37124 12.0" 
$ns at 368.0011700733229 "$node_(223) setdest 106715 35705 17.0" 
$ns at 558.5679316155523 "$node_(223) setdest 47044 21200 6.0" 
$ns at 598.7433015849205 "$node_(223) setdest 81425 10831 1.0" 
$ns at 635.433569576951 "$node_(223) setdest 845 24353 6.0" 
$ns at 693.1768947084121 "$node_(223) setdest 53336 23328 18.0" 
$ns at 860.4195940231949 "$node_(223) setdest 46863 15496 5.0" 
$ns at 289.13207139638496 "$node_(224) setdest 76879 37528 12.0" 
$ns at 360.1386610411598 "$node_(224) setdest 47977 30108 8.0" 
$ns at 433.8065803840052 "$node_(224) setdest 111255 16332 4.0" 
$ns at 494.1312765085267 "$node_(224) setdest 91075 15126 6.0" 
$ns at 544.1906309710363 "$node_(224) setdest 95320 34420 8.0" 
$ns at 649.8794980675577 "$node_(224) setdest 94229 5735 5.0" 
$ns at 708.4238440671697 "$node_(224) setdest 60201 27600 8.0" 
$ns at 754.3942242063174 "$node_(224) setdest 3562 4107 15.0" 
$ns at 787.6278966931059 "$node_(224) setdest 116210 36456 12.0" 
$ns at 828.6266248802672 "$node_(224) setdest 86921 16272 6.0" 
$ns at 882.0504164730572 "$node_(224) setdest 52991 4681 7.0" 
$ns at 237.6129870738099 "$node_(225) setdest 78635 38810 10.0" 
$ns at 341.79357637073844 "$node_(225) setdest 31687 23950 1.0" 
$ns at 375.015359926011 "$node_(225) setdest 46894 18146 4.0" 
$ns at 412.60930567921537 "$node_(225) setdest 95369 13245 5.0" 
$ns at 471.4454639394893 "$node_(225) setdest 70512 17326 9.0" 
$ns at 555.7633768745706 "$node_(225) setdest 9711 27802 16.0" 
$ns at 621.600669622062 "$node_(225) setdest 108295 4322 13.0" 
$ns at 764.7527484082106 "$node_(225) setdest 125621 16035 19.0" 
$ns at 216.6046678204658 "$node_(226) setdest 8705 35565 9.0" 
$ns at 330.75085003195 "$node_(226) setdest 61223 25624 1.0" 
$ns at 363.3230208169082 "$node_(226) setdest 15935 28435 2.0" 
$ns at 401.38785128536017 "$node_(226) setdest 87333 7692 14.0" 
$ns at 448.4522936511138 "$node_(226) setdest 13146 20301 12.0" 
$ns at 551.6528810761322 "$node_(226) setdest 27 1985 14.0" 
$ns at 601.8528653590186 "$node_(226) setdest 32678 44006 10.0" 
$ns at 702.9910528573347 "$node_(226) setdest 30353 42665 8.0" 
$ns at 741.0123584721229 "$node_(226) setdest 127954 11753 11.0" 
$ns at 796.3621150810238 "$node_(226) setdest 91258 23182 8.0" 
$ns at 862.8001894390029 "$node_(226) setdest 83834 805 13.0" 
$ns at 312.0007970233501 "$node_(227) setdest 41618 23128 17.0" 
$ns at 360.2899914763763 "$node_(227) setdest 38992 68 9.0" 
$ns at 459.3268429111274 "$node_(227) setdest 74461 32333 11.0" 
$ns at 554.9949691351624 "$node_(227) setdest 104379 38005 18.0" 
$ns at 664.1948207688383 "$node_(227) setdest 120405 16820 4.0" 
$ns at 728.9355274104778 "$node_(227) setdest 30600 25686 2.0" 
$ns at 771.0860869473499 "$node_(227) setdest 56967 6317 7.0" 
$ns at 835.9413912159962 "$node_(227) setdest 88272 10645 16.0" 
$ns at 230.27073480528566 "$node_(228) setdest 54958 40800 11.0" 
$ns at 290.1053553995242 "$node_(228) setdest 130139 26552 19.0" 
$ns at 479.3463593588088 "$node_(228) setdest 7155 12278 3.0" 
$ns at 510.66601371274896 "$node_(228) setdest 71242 24274 6.0" 
$ns at 573.6322987778136 "$node_(228) setdest 83766 40135 12.0" 
$ns at 676.2005619628076 "$node_(228) setdest 18601 32995 16.0" 
$ns at 773.0686940589729 "$node_(228) setdest 42325 20750 5.0" 
$ns at 821.4550153994995 "$node_(228) setdest 21267 43286 16.0" 
$ns at 873.7812577290232 "$node_(228) setdest 113009 24851 10.0" 
$ns at 221.63074386379932 "$node_(229) setdest 102309 18402 11.0" 
$ns at 282.8287865947824 "$node_(229) setdest 13373 27111 1.0" 
$ns at 313.5342334284039 "$node_(229) setdest 56894 41135 11.0" 
$ns at 411.6151507066679 "$node_(229) setdest 24423 41874 1.0" 
$ns at 451.02325149866545 "$node_(229) setdest 4322 39911 4.0" 
$ns at 485.5186896086067 "$node_(229) setdest 89292 32260 12.0" 
$ns at 596.3722192653064 "$node_(229) setdest 57132 553 6.0" 
$ns at 651.1462488794936 "$node_(229) setdest 11594 11944 10.0" 
$ns at 691.6067108837141 "$node_(229) setdest 90557 28102 5.0" 
$ns at 722.7936831827797 "$node_(229) setdest 91371 9269 19.0" 
$ns at 221.91241097133263 "$node_(230) setdest 11407 25733 2.0" 
$ns at 260.62468815819017 "$node_(230) setdest 28838 14178 1.0" 
$ns at 296.40083700241235 "$node_(230) setdest 82820 14853 5.0" 
$ns at 328.9707801640325 "$node_(230) setdest 125690 28906 11.0" 
$ns at 400.80733133074295 "$node_(230) setdest 77152 35314 19.0" 
$ns at 616.569568264119 "$node_(230) setdest 130823 12748 4.0" 
$ns at 686.2047738627449 "$node_(230) setdest 45481 28100 12.0" 
$ns at 826.2722203581416 "$node_(230) setdest 106054 28962 16.0" 
$ns at 202.39918724959423 "$node_(231) setdest 71641 16933 11.0" 
$ns at 308.5177628851718 "$node_(231) setdest 12448 897 5.0" 
$ns at 381.18185844839286 "$node_(231) setdest 11674 23896 18.0" 
$ns at 531.2370637566717 "$node_(231) setdest 19456 22411 17.0" 
$ns at 621.1156180010435 "$node_(231) setdest 20655 33336 3.0" 
$ns at 680.1969546236464 "$node_(231) setdest 60688 40447 11.0" 
$ns at 725.0124631236367 "$node_(231) setdest 78675 19902 14.0" 
$ns at 793.5152078901715 "$node_(231) setdest 131239 30973 19.0" 
$ns at 832.7479579269332 "$node_(231) setdest 18748 43679 12.0" 
$ns at 230.2145486234658 "$node_(232) setdest 56269 40865 18.0" 
$ns at 274.6573372481093 "$node_(232) setdest 32670 12950 2.0" 
$ns at 306.39031701052284 "$node_(232) setdest 46528 7639 15.0" 
$ns at 387.51306534411697 "$node_(232) setdest 64338 24660 7.0" 
$ns at 424.70816427776236 "$node_(232) setdest 17127 29669 1.0" 
$ns at 462.0518643653352 "$node_(232) setdest 132147 44653 2.0" 
$ns at 500.3879419335849 "$node_(232) setdest 57109 35307 9.0" 
$ns at 539.7044558215175 "$node_(232) setdest 76614 15798 12.0" 
$ns at 643.0832530214362 "$node_(232) setdest 94705 5108 20.0" 
$ns at 798.4342344978459 "$node_(232) setdest 116325 31497 18.0" 
$ns at 243.43924973546834 "$node_(233) setdest 64372 42679 8.0" 
$ns at 324.7319286264315 "$node_(233) setdest 19512 7568 10.0" 
$ns at 395.03418542549883 "$node_(233) setdest 95452 28214 1.0" 
$ns at 429.60510805081236 "$node_(233) setdest 93304 32328 6.0" 
$ns at 463.80372273225106 "$node_(233) setdest 131915 25204 9.0" 
$ns at 565.4542162000414 "$node_(233) setdest 93855 36929 6.0" 
$ns at 616.678288127936 "$node_(233) setdest 74957 26590 1.0" 
$ns at 648.5787023524081 "$node_(233) setdest 9580 13375 17.0" 
$ns at 706.3870565719097 "$node_(233) setdest 124364 9051 13.0" 
$ns at 759.124984026818 "$node_(233) setdest 96270 24222 4.0" 
$ns at 814.5818356570556 "$node_(233) setdest 124445 7695 18.0" 
$ns at 203.296055643403 "$node_(234) setdest 119361 2123 16.0" 
$ns at 311.3449540075475 "$node_(234) setdest 53588 43348 5.0" 
$ns at 391.2155610207599 "$node_(234) setdest 14939 41364 13.0" 
$ns at 543.3167585200196 "$node_(234) setdest 49304 20080 20.0" 
$ns at 623.2824344488223 "$node_(234) setdest 54094 33114 9.0" 
$ns at 707.626895419171 "$node_(234) setdest 100831 37487 3.0" 
$ns at 763.0924519718499 "$node_(234) setdest 9023 32297 18.0" 
$ns at 881.3420144719869 "$node_(234) setdest 5145 23835 15.0" 
$ns at 259.721905227681 "$node_(235) setdest 16189 26018 4.0" 
$ns at 299.55968081310886 "$node_(235) setdest 47110 31585 14.0" 
$ns at 400.51237486157413 "$node_(235) setdest 105959 37865 13.0" 
$ns at 539.4590206690225 "$node_(235) setdest 3062 33039 4.0" 
$ns at 602.2763127520527 "$node_(235) setdest 82838 24938 15.0" 
$ns at 737.4827295480378 "$node_(235) setdest 59813 7238 14.0" 
$ns at 776.9391759008396 "$node_(235) setdest 132611 30405 13.0" 
$ns at 842.6785810700483 "$node_(235) setdest 57327 27029 5.0" 
$ns at 873.7923146662598 "$node_(235) setdest 125978 40911 6.0" 
$ns at 231.02004780570394 "$node_(236) setdest 90161 10229 13.0" 
$ns at 353.7135284884428 "$node_(236) setdest 124157 23821 3.0" 
$ns at 403.9838356727627 "$node_(236) setdest 47033 12600 19.0" 
$ns at 477.9953383428344 "$node_(236) setdest 132111 27371 1.0" 
$ns at 514.9489758246787 "$node_(236) setdest 97500 2807 16.0" 
$ns at 653.7797535293174 "$node_(236) setdest 110173 35115 17.0" 
$ns at 764.4153436815291 "$node_(236) setdest 99884 32452 10.0" 
$ns at 796.908380398903 "$node_(236) setdest 103846 34373 4.0" 
$ns at 852.0353034861404 "$node_(236) setdest 120843 9558 11.0" 
$ns at 227.40643434997986 "$node_(237) setdest 60416 21419 16.0" 
$ns at 382.6611763680098 "$node_(237) setdest 97970 7540 13.0" 
$ns at 447.9076243427519 "$node_(237) setdest 18008 26132 18.0" 
$ns at 608.5002037035289 "$node_(237) setdest 87018 13126 15.0" 
$ns at 694.1404791603954 "$node_(237) setdest 2182 28814 10.0" 
$ns at 759.5192348373137 "$node_(237) setdest 99267 16840 11.0" 
$ns at 865.9847391558894 "$node_(237) setdest 40583 68 7.0" 
$ns at 223.46685015245748 "$node_(238) setdest 127092 7811 8.0" 
$ns at 281.1810893774973 "$node_(238) setdest 38532 23 5.0" 
$ns at 353.50019614231485 "$node_(238) setdest 93070 20746 5.0" 
$ns at 402.281316235083 "$node_(238) setdest 95263 34522 4.0" 
$ns at 463.7898612051634 "$node_(238) setdest 73312 33532 14.0" 
$ns at 600.9691720221222 "$node_(238) setdest 13711 15925 16.0" 
$ns at 703.8307118453372 "$node_(238) setdest 49923 4774 7.0" 
$ns at 744.1556348934341 "$node_(238) setdest 108371 15546 11.0" 
$ns at 782.0343683184306 "$node_(238) setdest 82579 44030 9.0" 
$ns at 856.687714173852 "$node_(238) setdest 38992 4712 13.0" 
$ns at 899.6052463695747 "$node_(238) setdest 122098 40679 15.0" 
$ns at 217.03234138144617 "$node_(239) setdest 119460 42172 10.0" 
$ns at 248.9925457250676 "$node_(239) setdest 7097 17838 20.0" 
$ns at 360.6492457016168 "$node_(239) setdest 91271 36500 19.0" 
$ns at 575.0747589993853 "$node_(239) setdest 48009 5985 13.0" 
$ns at 687.4668460459634 "$node_(239) setdest 27556 18762 20.0" 
$ns at 894.2340084637578 "$node_(239) setdest 2905 24821 8.0" 
$ns at 237.68918282821357 "$node_(240) setdest 49937 1733 19.0" 
$ns at 311.1674316505495 "$node_(240) setdest 12693 43022 2.0" 
$ns at 359.0830652589228 "$node_(240) setdest 69145 41344 14.0" 
$ns at 406.1411250918172 "$node_(240) setdest 1100 40122 13.0" 
$ns at 476.81488779384523 "$node_(240) setdest 127920 37691 19.0" 
$ns at 640.2613535189867 "$node_(240) setdest 33043 4865 1.0" 
$ns at 677.6846169263216 "$node_(240) setdest 22994 12954 17.0" 
$ns at 746.0683564959186 "$node_(240) setdest 49463 4364 19.0" 
$ns at 801.6485460942829 "$node_(240) setdest 91385 15883 1.0" 
$ns at 839.0080904636105 "$node_(240) setdest 87209 42726 10.0" 
$ns at 246.48390393634782 "$node_(241) setdest 37368 29299 4.0" 
$ns at 312.8077259379098 "$node_(241) setdest 114268 8558 19.0" 
$ns at 420.58126612714267 "$node_(241) setdest 85013 12906 14.0" 
$ns at 509.7054547778084 "$node_(241) setdest 18783 14068 6.0" 
$ns at 585.9794290888149 "$node_(241) setdest 94118 35264 17.0" 
$ns at 777.0899659346476 "$node_(241) setdest 61017 5470 12.0" 
$ns at 201.7397429849067 "$node_(242) setdest 52343 6151 5.0" 
$ns at 278.53244809873627 "$node_(242) setdest 80950 29058 6.0" 
$ns at 311.7426308677212 "$node_(242) setdest 54474 9356 20.0" 
$ns at 473.2968498594439 "$node_(242) setdest 38475 26443 17.0" 
$ns at 639.8773340643537 "$node_(242) setdest 99626 23767 18.0" 
$ns at 756.615790445627 "$node_(242) setdest 12749 29580 10.0" 
$ns at 873.2252890273426 "$node_(242) setdest 106336 11726 15.0" 
$ns at 208.6703867810625 "$node_(243) setdest 36423 35109 14.0" 
$ns at 258.05761913282845 "$node_(243) setdest 6704 31414 14.0" 
$ns at 406.0554776444318 "$node_(243) setdest 64709 282 4.0" 
$ns at 460.7784528268539 "$node_(243) setdest 47153 11408 10.0" 
$ns at 528.8903602818401 "$node_(243) setdest 65256 848 10.0" 
$ns at 634.9948657162706 "$node_(243) setdest 78075 1193 17.0" 
$ns at 743.2409996225897 "$node_(243) setdest 106354 23634 5.0" 
$ns at 791.7553652368297 "$node_(243) setdest 8798 28567 12.0" 
$ns at 312.2211467916181 "$node_(244) setdest 65186 27665 8.0" 
$ns at 369.67177475880703 "$node_(244) setdest 124573 21200 7.0" 
$ns at 464.44261880990234 "$node_(244) setdest 41507 35565 16.0" 
$ns at 602.7583756087274 "$node_(244) setdest 131347 25976 9.0" 
$ns at 647.7869108107417 "$node_(244) setdest 99599 37987 17.0" 
$ns at 770.7702179286927 "$node_(244) setdest 110142 44143 5.0" 
$ns at 803.3356144302221 "$node_(244) setdest 25863 18427 18.0" 
$ns at 271.97420959179783 "$node_(245) setdest 129095 2346 1.0" 
$ns at 310.06193670454513 "$node_(245) setdest 26310 43261 11.0" 
$ns at 429.29090942794176 "$node_(245) setdest 97329 10825 14.0" 
$ns at 472.14737996226074 "$node_(245) setdest 28741 22734 15.0" 
$ns at 606.8034865626166 "$node_(245) setdest 27150 8058 9.0" 
$ns at 685.1293390834373 "$node_(245) setdest 125028 23460 19.0" 
$ns at 811.315047488042 "$node_(245) setdest 77742 30691 1.0" 
$ns at 845.1636731921935 "$node_(245) setdest 386 108 2.0" 
$ns at 891.2320823755445 "$node_(245) setdest 27986 35798 8.0" 
$ns at 332.8660836210169 "$node_(246) setdest 41281 6723 5.0" 
$ns at 390.1946777009407 "$node_(246) setdest 97759 8036 7.0" 
$ns at 432.650310396294 "$node_(246) setdest 54027 4162 5.0" 
$ns at 493.1841835258335 "$node_(246) setdest 39147 29991 9.0" 
$ns at 543.435655819865 "$node_(246) setdest 34964 87 18.0" 
$ns at 590.6115930494458 "$node_(246) setdest 25225 43654 13.0" 
$ns at 696.2076514501218 "$node_(246) setdest 89012 29739 9.0" 
$ns at 742.9129845365815 "$node_(246) setdest 49941 23498 9.0" 
$ns at 774.0086884874015 "$node_(246) setdest 33168 3540 5.0" 
$ns at 821.4363090594888 "$node_(246) setdest 46198 27513 5.0" 
$ns at 887.829452934375 "$node_(246) setdest 24889 22570 7.0" 
$ns at 237.76565465863501 "$node_(247) setdest 88385 35082 7.0" 
$ns at 289.64197329971967 "$node_(247) setdest 69482 14316 10.0" 
$ns at 384.7345760487458 "$node_(247) setdest 37497 10896 7.0" 
$ns at 463.3469869382541 "$node_(247) setdest 15910 38364 19.0" 
$ns at 584.7799043765203 "$node_(247) setdest 53423 37129 14.0" 
$ns at 702.9722921374316 "$node_(247) setdest 123174 20770 12.0" 
$ns at 798.0580360068096 "$node_(247) setdest 30879 28998 1.0" 
$ns at 831.1865165063256 "$node_(247) setdest 62941 4554 19.0" 
$ns at 233.5408301885477 "$node_(248) setdest 111189 12643 18.0" 
$ns at 333.3481559773409 "$node_(248) setdest 7611 12184 6.0" 
$ns at 384.2044923741384 "$node_(248) setdest 78191 33367 15.0" 
$ns at 468.8375372520743 "$node_(248) setdest 110627 28804 13.0" 
$ns at 607.6819204033428 "$node_(248) setdest 82463 4380 15.0" 
$ns at 698.9556215627483 "$node_(248) setdest 63878 35849 17.0" 
$ns at 784.5548905807432 "$node_(248) setdest 127377 28549 19.0" 
$ns at 874.511945541803 "$node_(248) setdest 76044 7604 13.0" 
$ns at 317.2232578671652 "$node_(249) setdest 78261 35791 15.0" 
$ns at 491.9568756667633 "$node_(249) setdest 126672 35058 13.0" 
$ns at 543.3994090265495 "$node_(249) setdest 32160 36936 17.0" 
$ns at 588.6800909244039 "$node_(249) setdest 109578 11044 17.0" 
$ns at 638.7380846310049 "$node_(249) setdest 19047 35422 19.0" 
$ns at 829.212473663738 "$node_(249) setdest 119577 6907 7.0" 
$ns at 225.3315067301827 "$node_(250) setdest 58461 18689 17.0" 
$ns at 282.1272682415656 "$node_(250) setdest 11248 24688 20.0" 
$ns at 461.81848851673124 "$node_(250) setdest 22315 44337 9.0" 
$ns at 501.3472349552642 "$node_(250) setdest 133863 44677 6.0" 
$ns at 573.5056825306467 "$node_(250) setdest 88020 6882 6.0" 
$ns at 638.1915916051829 "$node_(250) setdest 36181 39420 4.0" 
$ns at 697.1173162401968 "$node_(250) setdest 119856 43012 18.0" 
$ns at 809.0845109359942 "$node_(250) setdest 30719 41943 1.0" 
$ns at 839.6158836129003 "$node_(250) setdest 39745 42643 7.0" 
$ns at 217.53203026238666 "$node_(251) setdest 45876 10011 19.0" 
$ns at 383.20367882220677 "$node_(251) setdest 98597 8746 19.0" 
$ns at 567.6154173131409 "$node_(251) setdest 24517 38885 14.0" 
$ns at 674.3379573829237 "$node_(251) setdest 87066 12742 16.0" 
$ns at 794.1701765686289 "$node_(251) setdest 55999 41978 3.0" 
$ns at 852.3177620477416 "$node_(251) setdest 4893 19481 2.0" 
$ns at 895.4185382017573 "$node_(251) setdest 117650 17889 5.0" 
$ns at 261.95744254406026 "$node_(252) setdest 78406 40642 19.0" 
$ns at 446.41288659244094 "$node_(252) setdest 62719 33084 8.0" 
$ns at 497.9189048119581 "$node_(252) setdest 43744 7248 7.0" 
$ns at 555.429695244833 "$node_(252) setdest 61865 16437 9.0" 
$ns at 644.8598116695866 "$node_(252) setdest 106849 28871 19.0" 
$ns at 749.2122651455411 "$node_(252) setdest 114233 5628 18.0" 
$ns at 857.8143524851864 "$node_(252) setdest 106489 13369 20.0" 
$ns at 206.41261708178013 "$node_(253) setdest 17464 1508 1.0" 
$ns at 242.88927850906614 "$node_(253) setdest 123487 44586 12.0" 
$ns at 335.7954413488111 "$node_(253) setdest 22883 5139 16.0" 
$ns at 415.6965914017014 "$node_(253) setdest 70259 35411 3.0" 
$ns at 471.9253154157921 "$node_(253) setdest 133364 43013 14.0" 
$ns at 547.4049075184791 "$node_(253) setdest 56982 12442 12.0" 
$ns at 665.1458046405742 "$node_(253) setdest 92042 9814 7.0" 
$ns at 742.9917299389443 "$node_(253) setdest 78448 21928 15.0" 
$ns at 220.5888202138262 "$node_(254) setdest 81510 38501 2.0" 
$ns at 266.0858647805704 "$node_(254) setdest 111991 19996 1.0" 
$ns at 298.5040379583317 "$node_(254) setdest 32528 43515 8.0" 
$ns at 358.7016151929669 "$node_(254) setdest 24438 18588 17.0" 
$ns at 460.3708845962791 "$node_(254) setdest 130712 34285 17.0" 
$ns at 568.4163981318947 "$node_(254) setdest 110907 11598 14.0" 
$ns at 626.3687017921399 "$node_(254) setdest 47259 13713 1.0" 
$ns at 658.7398250141389 "$node_(254) setdest 115519 2772 11.0" 
$ns at 757.4657825841476 "$node_(254) setdest 81364 23586 2.0" 
$ns at 798.8397019839848 "$node_(254) setdest 10393 13533 16.0" 
$ns at 239.57871393097733 "$node_(255) setdest 50995 33147 13.0" 
$ns at 367.5782118549013 "$node_(255) setdest 8709 14440 7.0" 
$ns at 413.7582395912835 "$node_(255) setdest 102448 44700 5.0" 
$ns at 453.3156543997643 "$node_(255) setdest 91772 33939 12.0" 
$ns at 546.5125797237956 "$node_(255) setdest 47935 40043 12.0" 
$ns at 635.3808643403003 "$node_(255) setdest 110162 8531 6.0" 
$ns at 709.9266096908365 "$node_(255) setdest 23410 26889 12.0" 
$ns at 781.2549361170018 "$node_(255) setdest 28994 33952 15.0" 
$ns at 239.2048861252492 "$node_(256) setdest 110382 28382 19.0" 
$ns at 280.07033434828173 "$node_(256) setdest 65262 7116 16.0" 
$ns at 381.5420980925742 "$node_(256) setdest 106236 4190 2.0" 
$ns at 411.56403140854 "$node_(256) setdest 127571 41256 6.0" 
$ns at 473.1753179443526 "$node_(256) setdest 52701 30368 12.0" 
$ns at 607.0555707815265 "$node_(256) setdest 44792 41718 9.0" 
$ns at 722.5082960530785 "$node_(256) setdest 45315 25485 5.0" 
$ns at 763.2708542229767 "$node_(256) setdest 94080 17383 19.0" 
$ns at 264.9058908771865 "$node_(257) setdest 81995 37448 11.0" 
$ns at 403.4362975910894 "$node_(257) setdest 106347 2267 10.0" 
$ns at 441.11353997799785 "$node_(257) setdest 72661 547 5.0" 
$ns at 498.83618420342776 "$node_(257) setdest 83616 35763 8.0" 
$ns at 563.0742326761865 "$node_(257) setdest 31177 12847 7.0" 
$ns at 608.6413844592398 "$node_(257) setdest 118169 2777 2.0" 
$ns at 649.0061565570674 "$node_(257) setdest 13316 33501 12.0" 
$ns at 779.5985449565621 "$node_(257) setdest 54818 43921 14.0" 
$ns at 277.31443344195054 "$node_(258) setdest 133125 19980 6.0" 
$ns at 351.2530419006347 "$node_(258) setdest 35463 35597 17.0" 
$ns at 429.90347232863684 "$node_(258) setdest 68642 14127 11.0" 
$ns at 500.47847875806565 "$node_(258) setdest 16664 29942 19.0" 
$ns at 568.5217502499883 "$node_(258) setdest 5789 31603 2.0" 
$ns at 611.7680200586935 "$node_(258) setdest 45079 16592 18.0" 
$ns at 773.963335893515 "$node_(258) setdest 82219 42883 15.0" 
$ns at 349.6016930176863 "$node_(259) setdest 27548 17598 11.0" 
$ns at 446.5479106436678 "$node_(259) setdest 5360 42776 14.0" 
$ns at 590.933575557589 "$node_(259) setdest 56919 41722 3.0" 
$ns at 633.8973474519192 "$node_(259) setdest 57629 35083 6.0" 
$ns at 694.6949992418034 "$node_(259) setdest 85909 8259 1.0" 
$ns at 728.5690872792458 "$node_(259) setdest 8752 40963 9.0" 
$ns at 844.991903541249 "$node_(259) setdest 27813 34258 8.0" 
$ns at 250.20419943585796 "$node_(260) setdest 114457 13446 8.0" 
$ns at 324.0750276528926 "$node_(260) setdest 105025 29713 2.0" 
$ns at 354.8082366277667 "$node_(260) setdest 21621 10039 19.0" 
$ns at 443.77842950848174 "$node_(260) setdest 127685 31147 4.0" 
$ns at 482.0867701276428 "$node_(260) setdest 86606 17404 7.0" 
$ns at 581.7260758630489 "$node_(260) setdest 52334 10980 9.0" 
$ns at 686.1333422411562 "$node_(260) setdest 1229 15538 18.0" 
$ns at 730.9734707079143 "$node_(260) setdest 62646 43752 9.0" 
$ns at 829.8575087349732 "$node_(260) setdest 90940 19887 9.0" 
$ns at 214.7363192064491 "$node_(261) setdest 122793 17038 7.0" 
$ns at 305.4362114071374 "$node_(261) setdest 15927 17396 19.0" 
$ns at 482.1607521853073 "$node_(261) setdest 47848 9159 19.0" 
$ns at 695.0144607982331 "$node_(261) setdest 105606 15102 15.0" 
$ns at 757.4278218413826 "$node_(261) setdest 69896 32632 11.0" 
$ns at 808.9938190623908 "$node_(261) setdest 75181 9558 13.0" 
$ns at 228.31913782261097 "$node_(262) setdest 109557 13466 17.0" 
$ns at 263.34420575140257 "$node_(262) setdest 43004 18812 13.0" 
$ns at 402.28675062387947 "$node_(262) setdest 79772 21477 11.0" 
$ns at 498.94829146214704 "$node_(262) setdest 24465 26028 1.0" 
$ns at 532.1950061128035 "$node_(262) setdest 8907 5247 10.0" 
$ns at 661.5072306241641 "$node_(262) setdest 38277 31583 13.0" 
$ns at 762.882630871778 "$node_(262) setdest 103283 39851 4.0" 
$ns at 822.9709670497967 "$node_(262) setdest 129445 5110 18.0" 
$ns at 873.8436007069907 "$node_(262) setdest 12079 2392 17.0" 
$ns at 301.07906881317024 "$node_(263) setdest 81410 27385 17.0" 
$ns at 452.6515259943928 "$node_(263) setdest 90234 21610 16.0" 
$ns at 612.5377383326991 "$node_(263) setdest 30988 28538 1.0" 
$ns at 651.9281876626151 "$node_(263) setdest 76407 2464 7.0" 
$ns at 701.7494115208585 "$node_(263) setdest 48139 28367 9.0" 
$ns at 756.6927792238262 "$node_(263) setdest 114082 7799 8.0" 
$ns at 820.9925241820415 "$node_(263) setdest 47529 32967 3.0" 
$ns at 863.6402882818494 "$node_(263) setdest 108805 34488 1.0" 
$ns at 253.93510841831574 "$node_(264) setdest 113245 37631 2.0" 
$ns at 287.63680076312517 "$node_(264) setdest 53098 17433 14.0" 
$ns at 325.98424212735046 "$node_(264) setdest 119286 137 2.0" 
$ns at 371.6645274883964 "$node_(264) setdest 47455 17920 14.0" 
$ns at 512.7761387514895 "$node_(264) setdest 105926 35586 10.0" 
$ns at 571.993078688045 "$node_(264) setdest 108412 7746 12.0" 
$ns at 603.3133681267445 "$node_(264) setdest 119333 37948 1.0" 
$ns at 639.1312114737423 "$node_(264) setdest 91844 39227 6.0" 
$ns at 703.9446864872848 "$node_(264) setdest 123557 1134 14.0" 
$ns at 788.6972366251771 "$node_(264) setdest 68148 13678 9.0" 
$ns at 889.8787955122059 "$node_(264) setdest 50774 23777 20.0" 
$ns at 246.38592527921298 "$node_(265) setdest 74222 37860 1.0" 
$ns at 279.1607845385275 "$node_(265) setdest 113056 13994 17.0" 
$ns at 353.97649885411147 "$node_(265) setdest 4620 37998 19.0" 
$ns at 493.6466090438918 "$node_(265) setdest 40153 26430 3.0" 
$ns at 551.4878451818366 "$node_(265) setdest 42854 14950 6.0" 
$ns at 599.3833713816715 "$node_(265) setdest 4592 13672 17.0" 
$ns at 729.9507303223086 "$node_(265) setdest 94407 27622 8.0" 
$ns at 828.5370444229362 "$node_(265) setdest 755 6102 8.0" 
$ns at 869.6121110153161 "$node_(265) setdest 94024 35952 20.0" 
$ns at 316.45392076629423 "$node_(266) setdest 91675 22790 10.0" 
$ns at 429.58033162537157 "$node_(266) setdest 94706 37658 13.0" 
$ns at 587.0921216126607 "$node_(266) setdest 14891 24212 19.0" 
$ns at 778.0518802822595 "$node_(266) setdest 107513 36007 10.0" 
$ns at 871.1577480833074 "$node_(266) setdest 62742 360 8.0" 
$ns at 225.19116444771052 "$node_(267) setdest 19563 20781 3.0" 
$ns at 282.9450394653644 "$node_(267) setdest 126590 37232 10.0" 
$ns at 411.06863073881806 "$node_(267) setdest 121583 34383 6.0" 
$ns at 486.9833836846784 "$node_(267) setdest 34601 29295 20.0" 
$ns at 668.8435378960311 "$node_(267) setdest 39687 38707 11.0" 
$ns at 749.7421754215935 "$node_(267) setdest 42207 11914 5.0" 
$ns at 812.5837327411286 "$node_(267) setdest 51660 3184 3.0" 
$ns at 862.8159157721185 "$node_(267) setdest 27200 29888 2.0" 
$ns at 897.402727329515 "$node_(267) setdest 34562 14800 15.0" 
$ns at 262.0931529092764 "$node_(268) setdest 64831 10964 13.0" 
$ns at 386.07908751785953 "$node_(268) setdest 20007 23673 4.0" 
$ns at 428.4343902094565 "$node_(268) setdest 9491 21750 18.0" 
$ns at 575.5682435918911 "$node_(268) setdest 58651 1697 18.0" 
$ns at 681.4197520157024 "$node_(268) setdest 123085 35282 9.0" 
$ns at 785.2050889488083 "$node_(268) setdest 105354 44029 1.0" 
$ns at 816.5000465235828 "$node_(268) setdest 94242 19936 8.0" 
$ns at 883.7533523852312 "$node_(268) setdest 71511 4808 17.0" 
$ns at 224.00670276947258 "$node_(269) setdest 53920 9317 18.0" 
$ns at 425.6385518317486 "$node_(269) setdest 129239 18017 19.0" 
$ns at 635.1319463359099 "$node_(269) setdest 106562 42264 5.0" 
$ns at 701.3601224819218 "$node_(269) setdest 4361 43352 7.0" 
$ns at 772.9239654434306 "$node_(269) setdest 120555 22482 13.0" 
$ns at 288.1943461631939 "$node_(270) setdest 104324 41773 16.0" 
$ns at 367.19968596712897 "$node_(270) setdest 31919 9560 8.0" 
$ns at 475.017134008337 "$node_(270) setdest 52513 30979 13.0" 
$ns at 630.4454252579536 "$node_(270) setdest 30251 21472 5.0" 
$ns at 683.1473848478538 "$node_(270) setdest 11096 36126 4.0" 
$ns at 713.2440889803323 "$node_(270) setdest 98744 29040 2.0" 
$ns at 751.4445143213727 "$node_(270) setdest 51813 36514 8.0" 
$ns at 783.7219426940616 "$node_(270) setdest 43439 40973 7.0" 
$ns at 842.5667769774436 "$node_(270) setdest 16938 30931 11.0" 
$ns at 203.7490563304282 "$node_(271) setdest 823 9671 13.0" 
$ns at 255.1035667375549 "$node_(271) setdest 81607 39038 1.0" 
$ns at 290.3138777533651 "$node_(271) setdest 63817 38193 15.0" 
$ns at 464.30523775875156 "$node_(271) setdest 14064 10664 11.0" 
$ns at 540.2761998912698 "$node_(271) setdest 44255 27454 18.0" 
$ns at 668.4826751909264 "$node_(271) setdest 78046 19102 13.0" 
$ns at 760.4378053569026 "$node_(271) setdest 122972 39688 8.0" 
$ns at 861.4077195890861 "$node_(271) setdest 124214 34525 13.0" 
$ns at 298.47343379165955 "$node_(272) setdest 125351 22648 3.0" 
$ns at 344.4692200866325 "$node_(272) setdest 72065 16364 8.0" 
$ns at 401.25112730582 "$node_(272) setdest 103393 9316 4.0" 
$ns at 442.7677157529993 "$node_(272) setdest 91875 16824 17.0" 
$ns at 543.1264979296247 "$node_(272) setdest 12337 20753 2.0" 
$ns at 583.1327006059573 "$node_(272) setdest 131467 20088 16.0" 
$ns at 681.7652712195256 "$node_(272) setdest 97589 26548 10.0" 
$ns at 748.9498179283989 "$node_(272) setdest 132275 36636 1.0" 
$ns at 787.6783707460211 "$node_(272) setdest 117736 13474 10.0" 
$ns at 850.5110606594852 "$node_(272) setdest 114166 10162 14.0" 
$ns at 335.29378941610855 "$node_(273) setdest 117455 34214 2.0" 
$ns at 378.7977815330836 "$node_(273) setdest 29103 1861 8.0" 
$ns at 466.3482582328571 "$node_(273) setdest 124484 43981 2.0" 
$ns at 503.47267630954565 "$node_(273) setdest 15982 20063 9.0" 
$ns at 566.4475281502208 "$node_(273) setdest 9666 28300 16.0" 
$ns at 611.4674633129084 "$node_(273) setdest 34080 11355 13.0" 
$ns at 739.2828995987114 "$node_(273) setdest 116775 33398 16.0" 
$ns at 813.6489708870585 "$node_(273) setdest 97067 41518 10.0" 
$ns at 882.4947804591208 "$node_(273) setdest 96200 29926 15.0" 
$ns at 296.99322556643614 "$node_(274) setdest 8665 30992 17.0" 
$ns at 410.50991647155956 "$node_(274) setdest 100865 21624 4.0" 
$ns at 461.00255327171703 "$node_(274) setdest 43499 14415 7.0" 
$ns at 550.0595648799601 "$node_(274) setdest 30955 42170 15.0" 
$ns at 630.8118409235203 "$node_(274) setdest 83192 8297 19.0" 
$ns at 717.5962842735948 "$node_(274) setdest 93675 20683 9.0" 
$ns at 761.3175469269985 "$node_(274) setdest 11641 34666 1.0" 
$ns at 793.6004201001807 "$node_(274) setdest 2330 40527 5.0" 
$ns at 866.5242946607857 "$node_(274) setdest 73072 23281 16.0" 
$ns at 278.5448790212947 "$node_(275) setdest 48460 13880 7.0" 
$ns at 336.8766306317934 "$node_(275) setdest 36913 18074 6.0" 
$ns at 371.8993185281789 "$node_(275) setdest 114246 11117 1.0" 
$ns at 402.99891085435326 "$node_(275) setdest 37747 9235 1.0" 
$ns at 442.2070233791328 "$node_(275) setdest 60716 39383 15.0" 
$ns at 512.3310351493135 "$node_(275) setdest 11301 31246 16.0" 
$ns at 666.3531910315639 "$node_(275) setdest 12039 7705 16.0" 
$ns at 827.9694823148114 "$node_(275) setdest 29926 1212 2.0" 
$ns at 866.4860740237293 "$node_(275) setdest 25829 24078 6.0" 
$ns at 245.3849631904628 "$node_(276) setdest 39935 29268 7.0" 
$ns at 339.02677423226805 "$node_(276) setdest 66746 9758 10.0" 
$ns at 464.0918080948116 "$node_(276) setdest 79929 37883 14.0" 
$ns at 601.0889309521804 "$node_(276) setdest 24143 32671 2.0" 
$ns at 642.9193980277583 "$node_(276) setdest 11869 41499 8.0" 
$ns at 730.0092016506395 "$node_(276) setdest 71674 21556 14.0" 
$ns at 855.6606650818543 "$node_(276) setdest 97614 32516 1.0" 
$ns at 892.3968262038292 "$node_(276) setdest 43574 4357 7.0" 
$ns at 218.54077926136745 "$node_(277) setdest 78912 39181 15.0" 
$ns at 266.4367803906844 "$node_(277) setdest 36223 37675 16.0" 
$ns at 378.8485750591434 "$node_(277) setdest 58375 43941 18.0" 
$ns at 551.1233691645573 "$node_(277) setdest 52313 18891 8.0" 
$ns at 660.5639976244441 "$node_(277) setdest 89348 41447 4.0" 
$ns at 705.6582575264588 "$node_(277) setdest 131339 12811 17.0" 
$ns at 857.1625863185722 "$node_(277) setdest 18935 10903 17.0" 
$ns at 291.41034188635535 "$node_(278) setdest 71261 11774 4.0" 
$ns at 341.80618736323464 "$node_(278) setdest 86658 9475 11.0" 
$ns at 404.4154634242975 "$node_(278) setdest 111855 33017 7.0" 
$ns at 485.9401530857142 "$node_(278) setdest 16103 7676 16.0" 
$ns at 574.081087500012 "$node_(278) setdest 17734 20030 17.0" 
$ns at 748.805668404469 "$node_(278) setdest 49947 29602 10.0" 
$ns at 794.9918089691101 "$node_(278) setdest 117057 39910 18.0" 
$ns at 296.4948836046593 "$node_(279) setdest 86314 10063 2.0" 
$ns at 330.0156657459468 "$node_(279) setdest 11049 21261 16.0" 
$ns at 402.5848708998713 "$node_(279) setdest 3853 4307 8.0" 
$ns at 508.3820478267754 "$node_(279) setdest 123258 10619 19.0" 
$ns at 558.7640296202933 "$node_(279) setdest 83609 5460 7.0" 
$ns at 632.1911212110633 "$node_(279) setdest 54956 13659 2.0" 
$ns at 676.7260826570237 "$node_(279) setdest 132139 8228 11.0" 
$ns at 749.8385417910886 "$node_(279) setdest 54925 11941 6.0" 
$ns at 790.6761015425282 "$node_(279) setdest 116032 18864 16.0" 
$ns at 272.32594193217415 "$node_(280) setdest 131603 22228 15.0" 
$ns at 340.8255613541582 "$node_(280) setdest 92307 20889 1.0" 
$ns at 380.14145555327497 "$node_(280) setdest 15821 10207 2.0" 
$ns at 411.2726468023204 "$node_(280) setdest 18563 34634 17.0" 
$ns at 464.438311243309 "$node_(280) setdest 90169 19750 16.0" 
$ns at 501.4130002773673 "$node_(280) setdest 110950 6533 7.0" 
$ns at 580.0393824412375 "$node_(280) setdest 122639 35362 8.0" 
$ns at 669.6555800742199 "$node_(280) setdest 13940 28924 9.0" 
$ns at 710.2599305620474 "$node_(280) setdest 84837 41898 12.0" 
$ns at 745.3137921993717 "$node_(280) setdest 71855 18841 12.0" 
$ns at 873.4229469348801 "$node_(280) setdest 116191 23246 13.0" 
$ns at 235.69856793166488 "$node_(281) setdest 20007 37867 10.0" 
$ns at 273.4693132255874 "$node_(281) setdest 124708 17000 19.0" 
$ns at 465.41275297132717 "$node_(281) setdest 58680 26963 1.0" 
$ns at 498.761468114993 "$node_(281) setdest 50011 5019 17.0" 
$ns at 695.7018976431639 "$node_(281) setdest 80946 25647 12.0" 
$ns at 816.5504202158876 "$node_(281) setdest 56411 28975 18.0" 
$ns at 259.7956453937966 "$node_(282) setdest 83290 24247 12.0" 
$ns at 400.639502911578 "$node_(282) setdest 77675 25872 9.0" 
$ns at 450.0267124162921 "$node_(282) setdest 35675 26633 8.0" 
$ns at 537.3967112063168 "$node_(282) setdest 79373 43451 5.0" 
$ns at 602.8594250803003 "$node_(282) setdest 129660 43371 9.0" 
$ns at 673.9498494482133 "$node_(282) setdest 89790 13397 13.0" 
$ns at 814.94337577874 "$node_(282) setdest 61576 336 20.0" 
$ns at 233.06741279934286 "$node_(283) setdest 1004 32958 9.0" 
$ns at 290.62062706715636 "$node_(283) setdest 108415 33664 18.0" 
$ns at 331.4361434837897 "$node_(283) setdest 103993 29260 7.0" 
$ns at 379.8601050060786 "$node_(283) setdest 115405 25166 10.0" 
$ns at 410.4606063302873 "$node_(283) setdest 84218 1944 17.0" 
$ns at 603.9103052185435 "$node_(283) setdest 105309 29040 19.0" 
$ns at 645.4499216239052 "$node_(283) setdest 126206 43639 13.0" 
$ns at 787.7814432761501 "$node_(283) setdest 21652 16076 6.0" 
$ns at 860.69331425762 "$node_(283) setdest 128635 41530 19.0" 
$ns at 264.1117276477434 "$node_(284) setdest 107910 27727 10.0" 
$ns at 335.68838598552566 "$node_(284) setdest 32806 39035 5.0" 
$ns at 407.46362964238165 "$node_(284) setdest 114089 44395 6.0" 
$ns at 479.28774921833224 "$node_(284) setdest 26565 29407 18.0" 
$ns at 550.8030343933452 "$node_(284) setdest 18888 8653 18.0" 
$ns at 722.0451771634694 "$node_(284) setdest 113275 14516 6.0" 
$ns at 795.5698241041505 "$node_(284) setdest 117394 31724 8.0" 
$ns at 831.3784516997555 "$node_(284) setdest 63535 2727 8.0" 
$ns at 862.6059287036613 "$node_(284) setdest 133237 11419 7.0" 
$ns at 351.7854923512445 "$node_(285) setdest 55846 20163 12.0" 
$ns at 431.93697672318854 "$node_(285) setdest 85390 27732 7.0" 
$ns at 475.908135465786 "$node_(285) setdest 112238 8968 15.0" 
$ns at 554.7640284993828 "$node_(285) setdest 64234 24368 6.0" 
$ns at 609.8536641959214 "$node_(285) setdest 3763 2635 5.0" 
$ns at 648.0693119821101 "$node_(285) setdest 118401 4061 20.0" 
$ns at 800.2847786946791 "$node_(285) setdest 976 23045 3.0" 
$ns at 840.2948187193938 "$node_(285) setdest 78036 3358 13.0" 
$ns at 262.0393797429559 "$node_(286) setdest 14565 20390 8.0" 
$ns at 296.07280134033095 "$node_(286) setdest 32521 17122 6.0" 
$ns at 378.9345515724726 "$node_(286) setdest 64651 22984 7.0" 
$ns at 441.24504248558617 "$node_(286) setdest 88852 4288 10.0" 
$ns at 545.6074084384309 "$node_(286) setdest 102102 15905 6.0" 
$ns at 630.8685722702405 "$node_(286) setdest 19516 32068 11.0" 
$ns at 684.4693644998953 "$node_(286) setdest 75882 13233 2.0" 
$ns at 734.2326673505528 "$node_(286) setdest 110468 42515 18.0" 
$ns at 897.7630701180309 "$node_(286) setdest 99536 16383 2.0" 
$ns at 202.88561644192527 "$node_(287) setdest 14539 17024 16.0" 
$ns at 325.3472651691525 "$node_(287) setdest 4318 18771 8.0" 
$ns at 391.2639363309665 "$node_(287) setdest 105156 309 18.0" 
$ns at 484.6494970059557 "$node_(287) setdest 111733 35494 8.0" 
$ns at 554.4878393964632 "$node_(287) setdest 35689 8468 15.0" 
$ns at 614.4201491070719 "$node_(287) setdest 46508 26415 9.0" 
$ns at 661.0939268614638 "$node_(287) setdest 8616 35863 7.0" 
$ns at 710.5745823436866 "$node_(287) setdest 97483 28524 18.0" 
$ns at 765.7790320819033 "$node_(287) setdest 28747 34688 6.0" 
$ns at 843.9761680952843 "$node_(287) setdest 132777 6957 4.0" 
$ns at 890.2033796424404 "$node_(287) setdest 44915 27510 15.0" 
$ns at 216.98374090651947 "$node_(288) setdest 111200 19848 11.0" 
$ns at 324.4390380647513 "$node_(288) setdest 83462 16213 15.0" 
$ns at 435.10052595907274 "$node_(288) setdest 64450 9381 10.0" 
$ns at 479.80484329541395 "$node_(288) setdest 37968 25603 8.0" 
$ns at 548.9854834269092 "$node_(288) setdest 77412 18310 2.0" 
$ns at 589.2757534408063 "$node_(288) setdest 88282 34872 2.0" 
$ns at 636.6527063247019 "$node_(288) setdest 45970 28157 16.0" 
$ns at 667.0514700186336 "$node_(288) setdest 20322 7252 12.0" 
$ns at 780.3799082661264 "$node_(288) setdest 105081 32935 8.0" 
$ns at 882.7067362145176 "$node_(288) setdest 111022 36448 18.0" 
$ns at 242.29165759455086 "$node_(289) setdest 45253 32543 20.0" 
$ns at 407.5212291876054 "$node_(289) setdest 37328 41281 11.0" 
$ns at 479.4122604878861 "$node_(289) setdest 28799 43469 11.0" 
$ns at 539.1185636307184 "$node_(289) setdest 65509 12236 1.0" 
$ns at 569.421687119948 "$node_(289) setdest 59733 231 8.0" 
$ns at 648.3900763612371 "$node_(289) setdest 43259 34557 1.0" 
$ns at 680.9874016676117 "$node_(289) setdest 62407 29394 10.0" 
$ns at 731.9492666136548 "$node_(289) setdest 45719 23346 9.0" 
$ns at 839.6246926171274 "$node_(289) setdest 114089 33146 4.0" 
$ns at 317.9167157887996 "$node_(290) setdest 51868 33661 13.0" 
$ns at 446.25623195850727 "$node_(290) setdest 119263 9195 8.0" 
$ns at 509.7977169447972 "$node_(290) setdest 38686 30215 2.0" 
$ns at 553.357850510358 "$node_(290) setdest 81898 28089 6.0" 
$ns at 605.8612486992527 "$node_(290) setdest 48757 42890 5.0" 
$ns at 682.3777292826882 "$node_(290) setdest 86755 24633 1.0" 
$ns at 720.150006590742 "$node_(290) setdest 125147 17379 18.0" 
$ns at 897.5052637094186 "$node_(290) setdest 31570 42238 19.0" 
$ns at 204.7789441307808 "$node_(291) setdest 52357 19435 7.0" 
$ns at 248.6203113211232 "$node_(291) setdest 43701 14766 1.0" 
$ns at 285.58198008431077 "$node_(291) setdest 95150 4615 1.0" 
$ns at 318.080491764396 "$node_(291) setdest 113646 2365 7.0" 
$ns at 350.2674848291148 "$node_(291) setdest 74114 11592 11.0" 
$ns at 414.8179978635573 "$node_(291) setdest 44220 43082 17.0" 
$ns at 502.21238196539855 "$node_(291) setdest 37351 22538 20.0" 
$ns at 656.2529532874612 "$node_(291) setdest 23489 38190 18.0" 
$ns at 791.2503339511971 "$node_(291) setdest 130676 37920 14.0" 
$ns at 293.42714535748644 "$node_(292) setdest 32373 9474 3.0" 
$ns at 344.1028517388657 "$node_(292) setdest 48880 29410 7.0" 
$ns at 442.99541572631114 "$node_(292) setdest 33882 8358 13.0" 
$ns at 514.0843836847705 "$node_(292) setdest 25766 22506 12.0" 
$ns at 546.798845115854 "$node_(292) setdest 26811 37535 19.0" 
$ns at 709.2037912649203 "$node_(292) setdest 77280 922 13.0" 
$ns at 796.2649345907621 "$node_(292) setdest 124019 40556 20.0" 
$ns at 839.2887073382602 "$node_(292) setdest 46300 4302 2.0" 
$ns at 877.531917502647 "$node_(292) setdest 21983 31154 2.0" 
$ns at 268.7374280754343 "$node_(293) setdest 128476 26473 18.0" 
$ns at 303.67999020766126 "$node_(293) setdest 73481 31405 16.0" 
$ns at 482.79575889973273 "$node_(293) setdest 102076 11459 10.0" 
$ns at 587.7403964684321 "$node_(293) setdest 52365 1072 8.0" 
$ns at 649.2054489706917 "$node_(293) setdest 38762 18002 20.0" 
$ns at 776.4818048812652 "$node_(293) setdest 2392 42873 20.0" 
$ns at 209.0937621166786 "$node_(294) setdest 128068 29746 8.0" 
$ns at 275.204324352587 "$node_(294) setdest 110348 15266 4.0" 
$ns at 312.558493601227 "$node_(294) setdest 71509 26490 1.0" 
$ns at 347.3200263344137 "$node_(294) setdest 126103 24595 6.0" 
$ns at 414.84070157999673 "$node_(294) setdest 50692 1335 10.0" 
$ns at 488.0394426739954 "$node_(294) setdest 97239 59 14.0" 
$ns at 585.2690479339174 "$node_(294) setdest 99814 38794 19.0" 
$ns at 795.8448069252186 "$node_(294) setdest 109802 22701 2.0" 
$ns at 830.4693000513745 "$node_(294) setdest 131220 3450 14.0" 
$ns at 873.7529264977173 "$node_(294) setdest 108900 34052 15.0" 
$ns at 202.33793693438963 "$node_(295) setdest 39489 29212 4.0" 
$ns at 260.5896886310372 "$node_(295) setdest 87154 10718 9.0" 
$ns at 373.48323723255817 "$node_(295) setdest 48706 30869 13.0" 
$ns at 423.6134521473799 "$node_(295) setdest 54772 28545 16.0" 
$ns at 454.40889709750917 "$node_(295) setdest 102652 19759 11.0" 
$ns at 489.586299173002 "$node_(295) setdest 104699 31987 15.0" 
$ns at 553.6097354193093 "$node_(295) setdest 106122 7152 1.0" 
$ns at 590.7195123325581 "$node_(295) setdest 4199 18078 18.0" 
$ns at 641.2223733238222 "$node_(295) setdest 55285 28600 13.0" 
$ns at 676.9740308720885 "$node_(295) setdest 31318 3052 7.0" 
$ns at 749.0188985486873 "$node_(295) setdest 36697 25490 8.0" 
$ns at 841.9374300082872 "$node_(295) setdest 131583 23880 5.0" 
$ns at 251.74560206737667 "$node_(296) setdest 127351 24331 5.0" 
$ns at 330.90932171455313 "$node_(296) setdest 29369 5647 8.0" 
$ns at 366.3877772529279 "$node_(296) setdest 106362 7692 3.0" 
$ns at 416.0792738328074 "$node_(296) setdest 107253 7050 19.0" 
$ns at 566.4578483220749 "$node_(296) setdest 69793 43218 13.0" 
$ns at 642.6674906441435 "$node_(296) setdest 76784 42977 7.0" 
$ns at 712.0611273653834 "$node_(296) setdest 36880 11123 19.0" 
$ns at 801.821483995244 "$node_(296) setdest 6359 35860 5.0" 
$ns at 834.6671913140674 "$node_(296) setdest 101516 30115 12.0" 
$ns at 212.97544079117495 "$node_(297) setdest 55293 26532 13.0" 
$ns at 291.8680533054927 "$node_(297) setdest 80353 8666 13.0" 
$ns at 354.38396178495793 "$node_(297) setdest 71723 9047 20.0" 
$ns at 543.7247962795404 "$node_(297) setdest 91425 28390 8.0" 
$ns at 638.9978924990941 "$node_(297) setdest 18332 4464 2.0" 
$ns at 671.4467174748773 "$node_(297) setdest 33799 22165 9.0" 
$ns at 720.0259423315005 "$node_(297) setdest 95102 7657 20.0" 
$ns at 875.6686239871779 "$node_(297) setdest 47490 44577 18.0" 
$ns at 270.018900791359 "$node_(298) setdest 52532 16648 6.0" 
$ns at 350.59890486471954 "$node_(298) setdest 112938 31206 7.0" 
$ns at 429.8246778692629 "$node_(298) setdest 133864 17108 9.0" 
$ns at 518.0075435316808 "$node_(298) setdest 116237 6289 6.0" 
$ns at 561.440902426686 "$node_(298) setdest 73419 20148 1.0" 
$ns at 596.4096302305262 "$node_(298) setdest 75101 42257 3.0" 
$ns at 655.0850404336348 "$node_(298) setdest 29887 3986 19.0" 
$ns at 827.00544800907 "$node_(298) setdest 102128 25091 17.0" 
$ns at 225.82449766403013 "$node_(299) setdest 100060 1330 13.0" 
$ns at 297.6072591981551 "$node_(299) setdest 28064 32704 3.0" 
$ns at 352.1543288170722 "$node_(299) setdest 60632 12403 10.0" 
$ns at 442.8143238556934 "$node_(299) setdest 20506 6636 14.0" 
$ns at 531.5272509510759 "$node_(299) setdest 22875 43643 12.0" 
$ns at 636.0692092432506 "$node_(299) setdest 97790 32034 15.0" 
$ns at 715.3966236762191 "$node_(299) setdest 61045 11991 8.0" 
$ns at 824.765298433501 "$node_(299) setdest 109305 18299 3.0" 
$ns at 874.9517916622041 "$node_(299) setdest 50042 36591 6.0" 
$ns at 323.693498562087 "$node_(300) setdest 68284 7728 9.0" 
$ns at 392.50652142766796 "$node_(300) setdest 105244 38144 5.0" 
$ns at 472.18719291604737 "$node_(300) setdest 80363 32797 5.0" 
$ns at 535.344544565535 "$node_(300) setdest 95468 691 7.0" 
$ns at 589.5941974213933 "$node_(300) setdest 10346 2268 18.0" 
$ns at 628.2165969665455 "$node_(300) setdest 44013 12845 11.0" 
$ns at 680.1999688220208 "$node_(300) setdest 125389 31705 19.0" 
$ns at 836.7051827137792 "$node_(300) setdest 56075 26711 8.0" 
$ns at 323.95729103135017 "$node_(301) setdest 24299 32495 16.0" 
$ns at 362.1772940985574 "$node_(301) setdest 105014 21944 10.0" 
$ns at 453.92525708689243 "$node_(301) setdest 803 31749 18.0" 
$ns at 552.576686285889 "$node_(301) setdest 130993 31674 2.0" 
$ns at 601.9983938034663 "$node_(301) setdest 62350 22553 19.0" 
$ns at 689.5668901434021 "$node_(301) setdest 22788 15463 1.0" 
$ns at 723.614676118752 "$node_(301) setdest 29928 43290 18.0" 
$ns at 896.7378201190713 "$node_(301) setdest 41837 11861 13.0" 
$ns at 388.7642096285691 "$node_(302) setdest 98424 28523 16.0" 
$ns at 538.4558886309867 "$node_(302) setdest 29034 33366 6.0" 
$ns at 616.7201419581443 "$node_(302) setdest 95688 11922 12.0" 
$ns at 691.4846879054367 "$node_(302) setdest 72533 35449 9.0" 
$ns at 784.5373823009814 "$node_(302) setdest 46028 29666 6.0" 
$ns at 829.6917064451156 "$node_(302) setdest 70696 16499 9.0" 
$ns at 347.4939419169939 "$node_(303) setdest 37284 21467 6.0" 
$ns at 378.77424680004526 "$node_(303) setdest 37662 30519 14.0" 
$ns at 479.2866143297689 "$node_(303) setdest 118346 37373 7.0" 
$ns at 541.2395691315733 "$node_(303) setdest 110404 35148 19.0" 
$ns at 653.003581024467 "$node_(303) setdest 100843 10920 6.0" 
$ns at 727.9993231445953 "$node_(303) setdest 13778 34445 5.0" 
$ns at 789.4982955962187 "$node_(303) setdest 7582 4386 16.0" 
$ns at 842.1481423215926 "$node_(303) setdest 82163 24087 4.0" 
$ns at 340.1824273166896 "$node_(304) setdest 43241 7512 19.0" 
$ns at 420.419565554918 "$node_(304) setdest 91976 4802 7.0" 
$ns at 454.901150202046 "$node_(304) setdest 85226 9498 10.0" 
$ns at 491.8835930639866 "$node_(304) setdest 61077 37564 4.0" 
$ns at 553.4964411524153 "$node_(304) setdest 10353 4998 2.0" 
$ns at 587.9554773122918 "$node_(304) setdest 38347 43818 3.0" 
$ns at 635.9349392234901 "$node_(304) setdest 93667 21266 12.0" 
$ns at 675.2639505936799 "$node_(304) setdest 53764 4432 2.0" 
$ns at 710.255236997569 "$node_(304) setdest 14038 1738 2.0" 
$ns at 750.4558262749115 "$node_(304) setdest 74653 35646 7.0" 
$ns at 793.4475755242788 "$node_(304) setdest 97936 37705 18.0" 
$ns at 380.23139804594666 "$node_(305) setdest 123820 25015 12.0" 
$ns at 529.8633290029034 "$node_(305) setdest 128066 731 5.0" 
$ns at 583.6579203822913 "$node_(305) setdest 39297 1807 20.0" 
$ns at 667.7036725204504 "$node_(305) setdest 58601 34076 12.0" 
$ns at 803.7461380612656 "$node_(305) setdest 111953 5120 1.0" 
$ns at 838.694842023145 "$node_(305) setdest 39273 32783 4.0" 
$ns at 891.0106692395659 "$node_(305) setdest 88307 28270 19.0" 
$ns at 394.2707172426414 "$node_(306) setdest 63599 12498 14.0" 
$ns at 468.29896202982206 "$node_(306) setdest 110006 34316 9.0" 
$ns at 527.2750253328575 "$node_(306) setdest 48242 26568 7.0" 
$ns at 574.4135400801338 "$node_(306) setdest 79532 11700 16.0" 
$ns at 635.2734521924992 "$node_(306) setdest 98121 17786 19.0" 
$ns at 669.5093883819261 "$node_(306) setdest 77013 23168 17.0" 
$ns at 716.5600182133089 "$node_(306) setdest 114057 37590 5.0" 
$ns at 785.4457086666785 "$node_(306) setdest 102256 40620 18.0" 
$ns at 399.8966806024371 "$node_(307) setdest 29640 24194 2.0" 
$ns at 440.6716338383124 "$node_(307) setdest 18553 28268 14.0" 
$ns at 514.5090029183661 "$node_(307) setdest 75883 17356 5.0" 
$ns at 591.1842012200361 "$node_(307) setdest 14184 11079 10.0" 
$ns at 647.1111766330207 "$node_(307) setdest 55027 24499 14.0" 
$ns at 687.5688074958185 "$node_(307) setdest 60919 38124 9.0" 
$ns at 718.9670804649805 "$node_(307) setdest 108642 8393 15.0" 
$ns at 785.3679913911521 "$node_(307) setdest 120159 34779 16.0" 
$ns at 829.2335645216363 "$node_(307) setdest 78939 24551 11.0" 
$ns at 860.220607043786 "$node_(307) setdest 121373 21982 14.0" 
$ns at 890.8036709305158 "$node_(307) setdest 91287 42483 9.0" 
$ns at 334.0929230372146 "$node_(308) setdest 74001 1303 10.0" 
$ns at 390.61169173080594 "$node_(308) setdest 49230 11003 16.0" 
$ns at 516.5604886193228 "$node_(308) setdest 16378 9033 13.0" 
$ns at 560.1843608581939 "$node_(308) setdest 38742 12429 18.0" 
$ns at 644.6062536145778 "$node_(308) setdest 71475 19662 16.0" 
$ns at 698.362559770346 "$node_(308) setdest 86268 18688 1.0" 
$ns at 738.235099155322 "$node_(308) setdest 84086 3229 6.0" 
$ns at 769.3841354628449 "$node_(308) setdest 36222 43627 1.0" 
$ns at 801.8408903030235 "$node_(308) setdest 62938 12005 1.0" 
$ns at 840.01069376671 "$node_(308) setdest 73705 92 2.0" 
$ns at 876.6396521932282 "$node_(308) setdest 81041 22930 18.0" 
$ns at 457.90832826546114 "$node_(309) setdest 41137 35986 8.0" 
$ns at 522.3293978306067 "$node_(309) setdest 30265 8513 16.0" 
$ns at 650.7069679559759 "$node_(309) setdest 70119 30459 13.0" 
$ns at 751.3633747591289 "$node_(309) setdest 127014 7218 11.0" 
$ns at 852.4858895388963 "$node_(309) setdest 90640 10335 7.0" 
$ns at 378.79740793425447 "$node_(310) setdest 63109 40061 9.0" 
$ns at 412.0945108820453 "$node_(310) setdest 60694 26233 7.0" 
$ns at 484.4193821105383 "$node_(310) setdest 116604 9120 15.0" 
$ns at 573.0727726640323 "$node_(310) setdest 60903 43409 3.0" 
$ns at 603.8374212418897 "$node_(310) setdest 43697 2645 14.0" 
$ns at 718.6737659074016 "$node_(310) setdest 55020 7100 13.0" 
$ns at 853.1067171186753 "$node_(310) setdest 49858 14769 20.0" 
$ns at 305.2577224781976 "$node_(311) setdest 126135 2754 3.0" 
$ns at 363.9094781883 "$node_(311) setdest 77212 23013 3.0" 
$ns at 405.62938286225403 "$node_(311) setdest 98735 36052 11.0" 
$ns at 529.9787330676669 "$node_(311) setdest 3317 21638 12.0" 
$ns at 602.8299709442205 "$node_(311) setdest 6855 13664 12.0" 
$ns at 744.1459272841379 "$node_(311) setdest 129550 33660 15.0" 
$ns at 363.5907415837878 "$node_(312) setdest 70549 39270 2.0" 
$ns at 403.0662731283693 "$node_(312) setdest 7592 43339 19.0" 
$ns at 612.987792650196 "$node_(312) setdest 38805 22340 5.0" 
$ns at 646.6838812007816 "$node_(312) setdest 48324 7868 14.0" 
$ns at 763.4945616414666 "$node_(312) setdest 104555 22503 17.0" 
$ns at 819.0206375282061 "$node_(312) setdest 1904 11374 16.0" 
$ns at 314.7597285170848 "$node_(313) setdest 33506 5968 18.0" 
$ns at 441.9272826694379 "$node_(313) setdest 109152 6037 6.0" 
$ns at 473.72348871063946 "$node_(313) setdest 43178 15546 8.0" 
$ns at 568.2216353238142 "$node_(313) setdest 112822 9108 1.0" 
$ns at 604.6314311237338 "$node_(313) setdest 115347 11264 13.0" 
$ns at 640.2208719173993 "$node_(313) setdest 95773 10522 13.0" 
$ns at 765.2795133373335 "$node_(313) setdest 101447 9519 13.0" 
$ns at 802.7803956824189 "$node_(313) setdest 63386 4370 15.0" 
$ns at 840.5630967875891 "$node_(313) setdest 66500 33425 19.0" 
$ns at 446.2455891997895 "$node_(314) setdest 102409 4761 20.0" 
$ns at 607.0340348229165 "$node_(314) setdest 133247 23335 8.0" 
$ns at 691.6636537581353 "$node_(314) setdest 122342 36301 1.0" 
$ns at 729.3111639449749 "$node_(314) setdest 48759 13470 10.0" 
$ns at 772.0876798075467 "$node_(314) setdest 97555 20081 9.0" 
$ns at 867.113831150491 "$node_(314) setdest 107420 21627 18.0" 
$ns at 318.46945737928263 "$node_(315) setdest 97906 23799 1.0" 
$ns at 350.8685791528182 "$node_(315) setdest 111589 17734 14.0" 
$ns at 512.1428600714023 "$node_(315) setdest 44166 42341 11.0" 
$ns at 578.3904899856176 "$node_(315) setdest 48234 40428 13.0" 
$ns at 623.7310906213588 "$node_(315) setdest 100899 17204 16.0" 
$ns at 768.9879251973178 "$node_(315) setdest 82574 27294 4.0" 
$ns at 815.4308328412851 "$node_(315) setdest 26056 40858 8.0" 
$ns at 860.7681502534947 "$node_(315) setdest 112208 21813 16.0" 
$ns at 313.9157059550615 "$node_(316) setdest 115691 33274 7.0" 
$ns at 381.7543681595306 "$node_(316) setdest 52346 34961 4.0" 
$ns at 416.9874796484299 "$node_(316) setdest 45533 21855 6.0" 
$ns at 493.18164149231575 "$node_(316) setdest 47361 43411 10.0" 
$ns at 545.6946487393672 "$node_(316) setdest 30671 11539 5.0" 
$ns at 599.1868630611749 "$node_(316) setdest 83700 8218 16.0" 
$ns at 654.817753515985 "$node_(316) setdest 100826 38034 11.0" 
$ns at 738.2145666564837 "$node_(316) setdest 44886 28865 16.0" 
$ns at 857.46331812341 "$node_(316) setdest 88543 37587 19.0" 
$ns at 312.24780234608966 "$node_(317) setdest 115661 14193 1.0" 
$ns at 343.29885541667136 "$node_(317) setdest 113807 9268 6.0" 
$ns at 373.4682691758169 "$node_(317) setdest 34357 19541 17.0" 
$ns at 567.9653722158891 "$node_(317) setdest 103153 25913 1.0" 
$ns at 606.2600361002918 "$node_(317) setdest 8977 658 7.0" 
$ns at 658.6266397489329 "$node_(317) setdest 102681 27061 3.0" 
$ns at 709.0709921718624 "$node_(317) setdest 41092 44695 16.0" 
$ns at 853.1298052154534 "$node_(317) setdest 18788 30907 20.0" 
$ns at 337.46975129599497 "$node_(318) setdest 107143 12856 7.0" 
$ns at 409.7373549216972 "$node_(318) setdest 13585 24797 9.0" 
$ns at 491.79499653206045 "$node_(318) setdest 42328 30284 15.0" 
$ns at 661.5479022645027 "$node_(318) setdest 130773 29646 14.0" 
$ns at 711.1520814659999 "$node_(318) setdest 99847 141 15.0" 
$ns at 867.8689735567206 "$node_(318) setdest 23409 42341 7.0" 
$ns at 370.4872906245494 "$node_(319) setdest 8607 8042 3.0" 
$ns at 412.6459634622816 "$node_(319) setdest 26034 5967 15.0" 
$ns at 457.78287525004293 "$node_(319) setdest 104905 20862 5.0" 
$ns at 510.35138758594917 "$node_(319) setdest 116235 5476 11.0" 
$ns at 586.0322210123277 "$node_(319) setdest 131164 33613 6.0" 
$ns at 629.5443223418836 "$node_(319) setdest 57529 6019 5.0" 
$ns at 680.1421927868307 "$node_(319) setdest 10323 9496 9.0" 
$ns at 712.4046261107011 "$node_(319) setdest 121076 12700 8.0" 
$ns at 796.4777670777999 "$node_(319) setdest 5439 21364 12.0" 
$ns at 829.520472545892 "$node_(319) setdest 12290 13407 20.0" 
$ns at 342.96776347378255 "$node_(320) setdest 32737 32071 19.0" 
$ns at 486.69836263658505 "$node_(320) setdest 52015 32826 3.0" 
$ns at 529.8933877200076 "$node_(320) setdest 7799 10625 6.0" 
$ns at 588.5360260224078 "$node_(320) setdest 62984 15961 7.0" 
$ns at 670.0964181159486 "$node_(320) setdest 80310 28301 16.0" 
$ns at 780.1754915945294 "$node_(320) setdest 5120 18096 3.0" 
$ns at 837.125006652841 "$node_(320) setdest 14109 1516 6.0" 
$ns at 870.9757754403377 "$node_(320) setdest 3794 16139 13.0" 
$ns at 423.96777698079444 "$node_(321) setdest 133165 15655 8.0" 
$ns at 475.67150699830995 "$node_(321) setdest 4613 12982 18.0" 
$ns at 608.1445031954947 "$node_(321) setdest 81847 33732 13.0" 
$ns at 750.4605344475992 "$node_(321) setdest 69933 32488 10.0" 
$ns at 815.6722887798236 "$node_(321) setdest 123855 1779 15.0" 
$ns at 413.0269565968525 "$node_(322) setdest 111900 35350 10.0" 
$ns at 498.2772864587581 "$node_(322) setdest 31139 3479 8.0" 
$ns at 603.2155738600643 "$node_(322) setdest 28218 7793 8.0" 
$ns at 709.0622517254345 "$node_(322) setdest 32419 37071 11.0" 
$ns at 807.3617967089768 "$node_(322) setdest 85582 39994 17.0" 
$ns at 312.9473475583795 "$node_(323) setdest 30623 14124 5.0" 
$ns at 347.6312277221638 "$node_(323) setdest 128173 15266 10.0" 
$ns at 411.18169513414057 "$node_(323) setdest 81468 7781 12.0" 
$ns at 495.816507282002 "$node_(323) setdest 27888 8940 16.0" 
$ns at 612.9651038416556 "$node_(323) setdest 121264 11232 15.0" 
$ns at 661.2168522049774 "$node_(323) setdest 10906 31738 16.0" 
$ns at 834.9003401421445 "$node_(323) setdest 43442 38347 4.0" 
$ns at 436.7163867010109 "$node_(324) setdest 23891 2624 20.0" 
$ns at 520.8507706586852 "$node_(324) setdest 17938 33357 14.0" 
$ns at 689.5046587026559 "$node_(324) setdest 13552 22534 11.0" 
$ns at 728.1447843178903 "$node_(324) setdest 1753 13976 15.0" 
$ns at 417.9496711718657 "$node_(325) setdest 10899 25261 1.0" 
$ns at 451.77416566200094 "$node_(325) setdest 79909 19776 19.0" 
$ns at 597.0000943893708 "$node_(325) setdest 34984 44291 6.0" 
$ns at 637.4281119736901 "$node_(325) setdest 117485 36950 4.0" 
$ns at 692.418428896739 "$node_(325) setdest 37442 467 16.0" 
$ns at 756.3854551316671 "$node_(325) setdest 70336 25974 3.0" 
$ns at 788.792050440435 "$node_(325) setdest 74526 20624 16.0" 
$ns at 865.5882313623396 "$node_(325) setdest 25876 22405 19.0" 
$ns at 363.7905804426725 "$node_(326) setdest 58130 29253 6.0" 
$ns at 416.96335251317186 "$node_(326) setdest 131972 14581 2.0" 
$ns at 452.5130195652877 "$node_(326) setdest 35629 41382 14.0" 
$ns at 528.7510290351232 "$node_(326) setdest 50205 18717 1.0" 
$ns at 561.8066342669172 "$node_(326) setdest 85266 37639 10.0" 
$ns at 654.8162192454097 "$node_(326) setdest 90778 21748 1.0" 
$ns at 693.5952925871117 "$node_(326) setdest 83169 489 7.0" 
$ns at 762.7297922219759 "$node_(326) setdest 7120 19144 18.0" 
$ns at 389.5079718161443 "$node_(327) setdest 52048 30415 9.0" 
$ns at 445.23792597303645 "$node_(327) setdest 49194 17465 14.0" 
$ns at 531.8400478716794 "$node_(327) setdest 91729 29651 11.0" 
$ns at 568.4738737386488 "$node_(327) setdest 127918 9627 13.0" 
$ns at 631.7476402656381 "$node_(327) setdest 45905 4401 16.0" 
$ns at 714.4356080935092 "$node_(327) setdest 108465 39238 10.0" 
$ns at 790.1399741015648 "$node_(327) setdest 65193 38433 17.0" 
$ns at 834.6434744686245 "$node_(327) setdest 98061 35154 7.0" 
$ns at 334.43671711687017 "$node_(328) setdest 90357 15683 8.0" 
$ns at 367.5332843003897 "$node_(328) setdest 29551 12484 10.0" 
$ns at 447.0446146443644 "$node_(328) setdest 69832 21697 1.0" 
$ns at 478.2684508875344 "$node_(328) setdest 123757 17947 9.0" 
$ns at 576.3296942654819 "$node_(328) setdest 39324 14408 1.0" 
$ns at 607.7943822307162 "$node_(328) setdest 801 32770 10.0" 
$ns at 649.2243023832376 "$node_(328) setdest 24979 23118 16.0" 
$ns at 781.919298268198 "$node_(328) setdest 15092 19612 18.0" 
$ns at 393.90112685394627 "$node_(329) setdest 124643 4674 1.0" 
$ns at 427.7985227473631 "$node_(329) setdest 129403 6793 20.0" 
$ns at 596.6027949673377 "$node_(329) setdest 52435 19728 17.0" 
$ns at 661.9793352599174 "$node_(329) setdest 47401 4962 1.0" 
$ns at 693.7936602073132 "$node_(329) setdest 30076 43849 18.0" 
$ns at 796.8267959026857 "$node_(329) setdest 34957 27729 19.0" 
$ns at 867.9230063252883 "$node_(329) setdest 6839 31307 10.0" 
$ns at 313.67607652041636 "$node_(330) setdest 129764 22535 14.0" 
$ns at 438.1863068970602 "$node_(330) setdest 101141 13193 16.0" 
$ns at 548.388679341455 "$node_(330) setdest 51819 34063 1.0" 
$ns at 579.4411949378126 "$node_(330) setdest 75841 68 14.0" 
$ns at 705.4946996828758 "$node_(330) setdest 101457 6832 1.0" 
$ns at 737.8539082553821 "$node_(330) setdest 130026 10570 9.0" 
$ns at 848.3002023158833 "$node_(330) setdest 128268 17143 10.0" 
$ns at 320.1176562197459 "$node_(331) setdest 69430 41815 11.0" 
$ns at 369.49632540992087 "$node_(331) setdest 29119 19903 8.0" 
$ns at 474.89858899142183 "$node_(331) setdest 66819 34620 1.0" 
$ns at 511.2396458724721 "$node_(331) setdest 129781 17975 16.0" 
$ns at 544.2930634900692 "$node_(331) setdest 27597 41827 11.0" 
$ns at 600.092557047867 "$node_(331) setdest 26432 8432 17.0" 
$ns at 768.1102569010291 "$node_(331) setdest 616 3804 19.0" 
$ns at 313.801368013427 "$node_(332) setdest 12539 34970 6.0" 
$ns at 346.9223713327457 "$node_(332) setdest 60305 16647 2.0" 
$ns at 381.49979987172884 "$node_(332) setdest 29489 38657 14.0" 
$ns at 448.2094667108726 "$node_(332) setdest 30948 35132 14.0" 
$ns at 581.8982913173784 "$node_(332) setdest 118217 38744 16.0" 
$ns at 692.6852920335518 "$node_(332) setdest 24688 34184 4.0" 
$ns at 746.7360124744841 "$node_(332) setdest 11828 16664 13.0" 
$ns at 898.86931721355 "$node_(332) setdest 61767 42571 6.0" 
$ns at 317.1924754515276 "$node_(333) setdest 4424 33313 13.0" 
$ns at 368.8208205918681 "$node_(333) setdest 41108 22407 12.0" 
$ns at 442.9212352745558 "$node_(333) setdest 37012 32415 15.0" 
$ns at 596.3342143156169 "$node_(333) setdest 70323 29523 12.0" 
$ns at 713.3535895489018 "$node_(333) setdest 114097 37036 12.0" 
$ns at 747.0582061569258 "$node_(333) setdest 77995 23848 17.0" 
$ns at 840.1910674115203 "$node_(333) setdest 83825 25592 10.0" 
$ns at 883.0303358739535 "$node_(333) setdest 5656 27713 18.0" 
$ns at 306.6353029188183 "$node_(334) setdest 114236 20272 13.0" 
$ns at 385.8464309275373 "$node_(334) setdest 14777 5996 6.0" 
$ns at 452.1460404596115 "$node_(334) setdest 109433 16857 10.0" 
$ns at 536.5592507242109 "$node_(334) setdest 55006 43104 13.0" 
$ns at 570.0285295544095 "$node_(334) setdest 52324 13731 2.0" 
$ns at 600.1120246362168 "$node_(334) setdest 28493 18934 18.0" 
$ns at 787.9421949370816 "$node_(334) setdest 21096 217 8.0" 
$ns at 840.6668228695836 "$node_(334) setdest 103460 11387 8.0" 
$ns at 876.7656135536656 "$node_(334) setdest 102580 18837 12.0" 
$ns at 329.1264473933209 "$node_(335) setdest 120234 35079 18.0" 
$ns at 370.6610189443714 "$node_(335) setdest 31206 24429 1.0" 
$ns at 410.39866758094865 "$node_(335) setdest 49182 20888 15.0" 
$ns at 551.2844799115239 "$node_(335) setdest 3349 22369 17.0" 
$ns at 723.158781988324 "$node_(335) setdest 52793 41338 13.0" 
$ns at 815.6326162982057 "$node_(335) setdest 125174 30867 7.0" 
$ns at 306.23677318583265 "$node_(336) setdest 123515 23104 16.0" 
$ns at 474.33641045561785 "$node_(336) setdest 78569 6780 12.0" 
$ns at 534.9106586052624 "$node_(336) setdest 109378 20332 12.0" 
$ns at 654.8470157068335 "$node_(336) setdest 45674 19523 12.0" 
$ns at 788.8070804607449 "$node_(336) setdest 95177 28304 8.0" 
$ns at 847.671492604822 "$node_(336) setdest 81686 5287 2.0" 
$ns at 892.3746709377856 "$node_(336) setdest 66596 24144 14.0" 
$ns at 383.1722570040255 "$node_(337) setdest 16488 11649 2.0" 
$ns at 427.5432326894242 "$node_(337) setdest 9315 4206 4.0" 
$ns at 479.46813670133844 "$node_(337) setdest 115306 27907 1.0" 
$ns at 510.3625899024563 "$node_(337) setdest 25078 43166 8.0" 
$ns at 585.5018421959123 "$node_(337) setdest 80606 9717 15.0" 
$ns at 706.9153768261076 "$node_(337) setdest 116323 27405 17.0" 
$ns at 815.4489128396497 "$node_(337) setdest 75492 24774 5.0" 
$ns at 845.6723541395502 "$node_(337) setdest 69261 44236 1.0" 
$ns at 880.0551372974813 "$node_(337) setdest 66181 27982 9.0" 
$ns at 341.5448666972994 "$node_(338) setdest 83324 38709 7.0" 
$ns at 431.20338214787887 "$node_(338) setdest 73211 39614 19.0" 
$ns at 628.5680714849344 "$node_(338) setdest 51372 43579 19.0" 
$ns at 833.2416194255568 "$node_(338) setdest 71510 22611 17.0" 
$ns at 391.9938910006015 "$node_(339) setdest 60170 3018 14.0" 
$ns at 425.37465689267367 "$node_(339) setdest 50787 28027 18.0" 
$ns at 572.9520855136627 "$node_(339) setdest 63482 31129 2.0" 
$ns at 616.7250920443395 "$node_(339) setdest 88738 36655 11.0" 
$ns at 705.0934346894192 "$node_(339) setdest 73462 16980 1.0" 
$ns at 743.8089688599237 "$node_(339) setdest 114057 6016 16.0" 
$ns at 813.7683364156845 "$node_(339) setdest 84530 22300 1.0" 
$ns at 845.0545662014368 "$node_(339) setdest 60327 44294 5.0" 
$ns at 349.57224158570307 "$node_(340) setdest 122806 37366 8.0" 
$ns at 390.86315873376805 "$node_(340) setdest 94286 24517 6.0" 
$ns at 423.84531719731564 "$node_(340) setdest 118045 29374 8.0" 
$ns at 470.274799840852 "$node_(340) setdest 9089 24854 19.0" 
$ns at 602.4153623896314 "$node_(340) setdest 119697 7570 18.0" 
$ns at 786.7485063492189 "$node_(340) setdest 129785 17822 2.0" 
$ns at 828.1898101184797 "$node_(340) setdest 12506 1461 1.0" 
$ns at 864.616429189491 "$node_(340) setdest 69462 26647 1.0" 
$ns at 300.7993126619733 "$node_(341) setdest 66894 11988 12.0" 
$ns at 406.5037065700911 "$node_(341) setdest 54748 34035 15.0" 
$ns at 511.0084333273776 "$node_(341) setdest 27632 8598 8.0" 
$ns at 601.616084475516 "$node_(341) setdest 37723 13497 16.0" 
$ns at 662.0357558593587 "$node_(341) setdest 65611 26574 4.0" 
$ns at 731.8848808490047 "$node_(341) setdest 119026 39824 1.0" 
$ns at 770.4963475641749 "$node_(341) setdest 131041 33429 13.0" 
$ns at 819.6573002464478 "$node_(341) setdest 83758 29366 8.0" 
$ns at 854.5313708086837 "$node_(341) setdest 113292 42303 16.0" 
$ns at 451.85796464411226 "$node_(342) setdest 94175 7523 4.0" 
$ns at 498.32962261732587 "$node_(342) setdest 131067 13119 20.0" 
$ns at 712.3192376459797 "$node_(342) setdest 60487 8623 10.0" 
$ns at 759.1226808571155 "$node_(342) setdest 79210 25968 9.0" 
$ns at 871.1125599289177 "$node_(342) setdest 79836 44661 5.0" 
$ns at 320.08644511579604 "$node_(343) setdest 114837 41081 10.0" 
$ns at 431.221995603431 "$node_(343) setdest 48613 26454 8.0" 
$ns at 525.093413209973 "$node_(343) setdest 92891 41591 14.0" 
$ns at 630.9312893731105 "$node_(343) setdest 87866 27068 18.0" 
$ns at 710.9723514891812 "$node_(343) setdest 44658 13161 8.0" 
$ns at 752.22619334317 "$node_(343) setdest 41216 9366 6.0" 
$ns at 805.9916749726175 "$node_(343) setdest 81346 21146 12.0" 
$ns at 319.964893055868 "$node_(344) setdest 132295 12735 3.0" 
$ns at 357.5162858101434 "$node_(344) setdest 75287 23397 12.0" 
$ns at 388.30986804929256 "$node_(344) setdest 44523 29244 16.0" 
$ns at 460.5397653420558 "$node_(344) setdest 12640 4905 2.0" 
$ns at 494.4141766639328 "$node_(344) setdest 74982 11952 13.0" 
$ns at 594.7965295565767 "$node_(344) setdest 23814 8592 3.0" 
$ns at 645.3468401109653 "$node_(344) setdest 64782 31169 5.0" 
$ns at 676.3206505327263 "$node_(344) setdest 31052 23299 4.0" 
$ns at 734.7689512906181 "$node_(344) setdest 35765 3295 15.0" 
$ns at 833.2961404292467 "$node_(344) setdest 74689 43873 20.0" 
$ns at 888.7451300149443 "$node_(344) setdest 41021 27840 2.0" 
$ns at 306.8816375830787 "$node_(345) setdest 82263 33595 15.0" 
$ns at 365.3333022438012 "$node_(345) setdest 112794 20286 1.0" 
$ns at 403.68793161795196 "$node_(345) setdest 48548 7798 7.0" 
$ns at 454.4995881460632 "$node_(345) setdest 16694 41897 1.0" 
$ns at 488.90990985209 "$node_(345) setdest 41285 43129 16.0" 
$ns at 650.012686223204 "$node_(345) setdest 13025 31014 19.0" 
$ns at 750.7505302705962 "$node_(345) setdest 90448 1140 2.0" 
$ns at 791.6015897812741 "$node_(345) setdest 72329 25777 16.0" 
$ns at 830.1239240709227 "$node_(345) setdest 55202 36745 9.0" 
$ns at 359.611816204089 "$node_(346) setdest 98419 17259 10.0" 
$ns at 443.0729423433876 "$node_(346) setdest 108552 18161 7.0" 
$ns at 479.48848472402614 "$node_(346) setdest 123769 30903 10.0" 
$ns at 596.1922925039935 "$node_(346) setdest 55002 7691 1.0" 
$ns at 629.6089156385835 "$node_(346) setdest 8491 42544 15.0" 
$ns at 757.8439957120377 "$node_(346) setdest 129641 13008 4.0" 
$ns at 807.6526173755958 "$node_(346) setdest 117164 39185 15.0" 
$ns at 349.65881855906696 "$node_(347) setdest 43819 25690 9.0" 
$ns at 382.74200123410924 "$node_(347) setdest 106276 8918 1.0" 
$ns at 418.49027055093694 "$node_(347) setdest 28333 8699 1.0" 
$ns at 448.98608637712044 "$node_(347) setdest 127838 28154 18.0" 
$ns at 552.0291079744428 "$node_(347) setdest 121428 34307 7.0" 
$ns at 598.9458012357957 "$node_(347) setdest 55204 5842 11.0" 
$ns at 652.8582888538281 "$node_(347) setdest 91051 21447 6.0" 
$ns at 722.3949968871684 "$node_(347) setdest 119776 34443 3.0" 
$ns at 774.7893174238101 "$node_(347) setdest 9384 9883 13.0" 
$ns at 827.6605433954877 "$node_(347) setdest 48048 36010 3.0" 
$ns at 867.7476220504184 "$node_(347) setdest 14180 37862 19.0" 
$ns at 346.7309317186863 "$node_(348) setdest 28034 17521 4.0" 
$ns at 378.86433796642103 "$node_(348) setdest 77323 10312 5.0" 
$ns at 436.12449764013274 "$node_(348) setdest 63794 41058 10.0" 
$ns at 558.319477039956 "$node_(348) setdest 112680 21006 9.0" 
$ns at 654.9311259057182 "$node_(348) setdest 96076 26499 16.0" 
$ns at 697.8767728470743 "$node_(348) setdest 5555 31896 1.0" 
$ns at 737.2265895639056 "$node_(348) setdest 48184 34612 4.0" 
$ns at 784.9333050862547 "$node_(348) setdest 88544 41975 9.0" 
$ns at 881.8309833876554 "$node_(348) setdest 122741 33070 6.0" 
$ns at 415.7710101324506 "$node_(349) setdest 90489 5924 14.0" 
$ns at 511.73241718109045 "$node_(349) setdest 79948 42537 16.0" 
$ns at 571.0330689260171 "$node_(349) setdest 112441 17938 8.0" 
$ns at 676.0409533444641 "$node_(349) setdest 66429 5795 18.0" 
$ns at 820.4738650587061 "$node_(349) setdest 66007 32480 10.0" 
$ns at 885.908148193184 "$node_(349) setdest 101383 19271 19.0" 
$ns at 335.7321552824954 "$node_(350) setdest 85620 11882 15.0" 
$ns at 476.3780441223453 "$node_(350) setdest 21957 7915 11.0" 
$ns at 561.0757036673596 "$node_(350) setdest 42938 27699 16.0" 
$ns at 672.4789421887352 "$node_(350) setdest 63855 11168 1.0" 
$ns at 706.2566021637679 "$node_(350) setdest 88683 34511 18.0" 
$ns at 758.896040033956 "$node_(350) setdest 83561 4834 10.0" 
$ns at 883.8968929025932 "$node_(350) setdest 52877 13001 13.0" 
$ns at 337.2910170834046 "$node_(351) setdest 111222 20259 1.0" 
$ns at 369.1340066654336 "$node_(351) setdest 81789 16487 17.0" 
$ns at 486.426064271261 "$node_(351) setdest 78820 44566 15.0" 
$ns at 614.0013545408848 "$node_(351) setdest 23909 31889 10.0" 
$ns at 717.3087893318356 "$node_(351) setdest 2090 28382 10.0" 
$ns at 762.6674391604619 "$node_(351) setdest 121864 32295 8.0" 
$ns at 872.2598751517608 "$node_(351) setdest 28939 8240 19.0" 
$ns at 354.1200639367447 "$node_(352) setdest 125797 17675 17.0" 
$ns at 440.08556884524694 "$node_(352) setdest 30897 3757 15.0" 
$ns at 546.1289767496042 "$node_(352) setdest 58342 22792 1.0" 
$ns at 580.9073819022782 "$node_(352) setdest 60648 34345 10.0" 
$ns at 637.7664282017223 "$node_(352) setdest 18828 43365 9.0" 
$ns at 753.0194689519452 "$node_(352) setdest 45435 6412 15.0" 
$ns at 898.9758657786599 "$node_(352) setdest 14723 12724 16.0" 
$ns at 319.8518833682425 "$node_(353) setdest 86503 7650 14.0" 
$ns at 438.9289417858699 "$node_(353) setdest 54313 6194 2.0" 
$ns at 474.9150106248584 "$node_(353) setdest 35836 19667 18.0" 
$ns at 662.7980938559035 "$node_(353) setdest 68461 20537 4.0" 
$ns at 712.757885858677 "$node_(353) setdest 52694 14035 20.0" 
$ns at 839.4419663681798 "$node_(353) setdest 88858 26831 1.0" 
$ns at 874.8418136654631 "$node_(353) setdest 39333 7967 14.0" 
$ns at 317.91661643241997 "$node_(354) setdest 63215 21645 17.0" 
$ns at 364.25204054218966 "$node_(354) setdest 70612 11233 4.0" 
$ns at 425.6778221139038 "$node_(354) setdest 97450 35267 18.0" 
$ns at 470.35707888425577 "$node_(354) setdest 23666 38884 20.0" 
$ns at 523.663705736228 "$node_(354) setdest 71899 28293 11.0" 
$ns at 611.1873616755843 "$node_(354) setdest 45358 13954 8.0" 
$ns at 675.3676639917419 "$node_(354) setdest 33077 32407 3.0" 
$ns at 727.7226496915748 "$node_(354) setdest 58919 20918 1.0" 
$ns at 762.8313057609532 "$node_(354) setdest 4339 11443 4.0" 
$ns at 829.174169217935 "$node_(354) setdest 11990 20882 1.0" 
$ns at 861.8272501907195 "$node_(354) setdest 39191 34005 10.0" 
$ns at 309.0535279413615 "$node_(355) setdest 73075 37467 18.0" 
$ns at 494.73614209400284 "$node_(355) setdest 128437 20139 1.0" 
$ns at 525.9087689314524 "$node_(355) setdest 103265 30961 3.0" 
$ns at 558.7623485733179 "$node_(355) setdest 95634 17761 20.0" 
$ns at 751.4489683132217 "$node_(355) setdest 25057 44415 8.0" 
$ns at 824.9066312252488 "$node_(355) setdest 37321 25628 4.0" 
$ns at 857.3937662134349 "$node_(355) setdest 81372 26676 13.0" 
$ns at 891.0135072059436 "$node_(355) setdest 99373 27287 8.0" 
$ns at 315.7323428281647 "$node_(356) setdest 60661 35199 16.0" 
$ns at 426.0535958187472 "$node_(356) setdest 72209 25088 8.0" 
$ns at 527.5636751551167 "$node_(356) setdest 124959 796 18.0" 
$ns at 573.2736293496995 "$node_(356) setdest 114488 21449 8.0" 
$ns at 649.2724635796112 "$node_(356) setdest 118457 22598 14.0" 
$ns at 751.547628960922 "$node_(356) setdest 49850 15636 2.0" 
$ns at 797.5830799454322 "$node_(356) setdest 69751 28571 18.0" 
$ns at 845.813240073847 "$node_(356) setdest 17404 33790 6.0" 
$ns at 350.7031192838124 "$node_(357) setdest 89307 17644 7.0" 
$ns at 398.88366309009666 "$node_(357) setdest 128199 3443 19.0" 
$ns at 481.23516189131664 "$node_(357) setdest 49887 7040 19.0" 
$ns at 639.9731574486536 "$node_(357) setdest 56430 20755 17.0" 
$ns at 760.9242791802217 "$node_(357) setdest 111640 13657 18.0" 
$ns at 343.4880205662936 "$node_(358) setdest 34753 26348 6.0" 
$ns at 423.88762707255563 "$node_(358) setdest 46827 33485 11.0" 
$ns at 547.3680041390295 "$node_(358) setdest 107859 8545 2.0" 
$ns at 587.8850269265793 "$node_(358) setdest 122168 20043 2.0" 
$ns at 636.6328676426924 "$node_(358) setdest 117683 38283 11.0" 
$ns at 732.3114330405599 "$node_(358) setdest 72318 1465 18.0" 
$ns at 828.1572017963665 "$node_(358) setdest 130438 13760 4.0" 
$ns at 860.269686635137 "$node_(358) setdest 77623 36829 11.0" 
$ns at 317.00236776108966 "$node_(359) setdest 11675 16322 16.0" 
$ns at 427.07930367039705 "$node_(359) setdest 97263 16130 3.0" 
$ns at 478.2687115375278 "$node_(359) setdest 18165 6137 19.0" 
$ns at 622.8128616867798 "$node_(359) setdest 50092 39792 12.0" 
$ns at 666.0167535879903 "$node_(359) setdest 107982 25152 18.0" 
$ns at 793.6560693198111 "$node_(359) setdest 11367 22450 15.0" 
$ns at 841.560712510372 "$node_(359) setdest 8864 11441 14.0" 
$ns at 320.2009206454262 "$node_(360) setdest 42568 28471 10.0" 
$ns at 381.42070506862035 "$node_(360) setdest 118911 8742 1.0" 
$ns at 420.6018451881901 "$node_(360) setdest 112917 30522 3.0" 
$ns at 461.4248166922147 "$node_(360) setdest 77017 4257 18.0" 
$ns at 664.2238946334273 "$node_(360) setdest 61356 13159 15.0" 
$ns at 782.7868077414195 "$node_(360) setdest 127557 42885 9.0" 
$ns at 882.9388301682549 "$node_(360) setdest 106823 44051 9.0" 
$ns at 353.6861235798964 "$node_(361) setdest 19832 17952 15.0" 
$ns at 466.64446056615435 "$node_(361) setdest 10644 14948 14.0" 
$ns at 536.879961292818 "$node_(361) setdest 45045 28020 7.0" 
$ns at 567.7086470521909 "$node_(361) setdest 70849 33093 9.0" 
$ns at 631.513471866109 "$node_(361) setdest 116040 27210 9.0" 
$ns at 702.2967848023098 "$node_(361) setdest 72163 21400 1.0" 
$ns at 739.1389719718029 "$node_(361) setdest 8339 34036 14.0" 
$ns at 846.5617545957186 "$node_(361) setdest 5382 25389 4.0" 
$ns at 340.6918793474145 "$node_(362) setdest 122600 15069 12.0" 
$ns at 426.9857785312895 "$node_(362) setdest 101054 25299 10.0" 
$ns at 508.9607838834221 "$node_(362) setdest 102897 31671 3.0" 
$ns at 559.2271107593959 "$node_(362) setdest 35125 28806 4.0" 
$ns at 603.1210826812866 "$node_(362) setdest 78643 17026 10.0" 
$ns at 698.1508124170655 "$node_(362) setdest 5695 5158 18.0" 
$ns at 884.114282256693 "$node_(362) setdest 109987 15846 16.0" 
$ns at 371.7398069082127 "$node_(363) setdest 25459 18619 19.0" 
$ns at 491.6589102567199 "$node_(363) setdest 68833 37742 18.0" 
$ns at 539.5744340291839 "$node_(363) setdest 45296 1272 9.0" 
$ns at 585.4252580959247 "$node_(363) setdest 95862 2435 16.0" 
$ns at 698.8521208324267 "$node_(363) setdest 106599 36079 3.0" 
$ns at 750.7615341791347 "$node_(363) setdest 44567 17966 2.0" 
$ns at 793.3829413711659 "$node_(363) setdest 25308 6735 1.0" 
$ns at 830.7329910013339 "$node_(363) setdest 90440 13238 1.0" 
$ns at 869.3309891323813 "$node_(363) setdest 81282 2523 16.0" 
$ns at 331.53946993991013 "$node_(364) setdest 96192 43992 5.0" 
$ns at 393.2151208539075 "$node_(364) setdest 52493 36600 9.0" 
$ns at 448.93169401241676 "$node_(364) setdest 133283 13948 5.0" 
$ns at 525.3270628240044 "$node_(364) setdest 42056 20072 2.0" 
$ns at 574.1489222691255 "$node_(364) setdest 27842 12720 7.0" 
$ns at 626.8290524539282 "$node_(364) setdest 124954 38878 14.0" 
$ns at 662.5594934050858 "$node_(364) setdest 53899 20264 12.0" 
$ns at 773.2172128661708 "$node_(364) setdest 51452 9673 20.0" 
$ns at 892.5970135568466 "$node_(364) setdest 55921 4724 6.0" 
$ns at 327.45593479306046 "$node_(365) setdest 5116 22411 8.0" 
$ns at 400.00565154547905 "$node_(365) setdest 67821 31619 17.0" 
$ns at 451.05285883485504 "$node_(365) setdest 14202 4287 14.0" 
$ns at 520.9671446453718 "$node_(365) setdest 5613 19847 2.0" 
$ns at 551.2260082660398 "$node_(365) setdest 39432 5542 13.0" 
$ns at 701.8870284523108 "$node_(365) setdest 53614 19263 7.0" 
$ns at 757.9823855046512 "$node_(365) setdest 51304 6541 3.0" 
$ns at 792.044777370972 "$node_(365) setdest 99188 16525 7.0" 
$ns at 857.0281099402433 "$node_(365) setdest 121051 6371 18.0" 
$ns at 466.18662279746536 "$node_(366) setdest 127157 35166 8.0" 
$ns at 547.6410492833851 "$node_(366) setdest 23596 20756 7.0" 
$ns at 646.3560460390598 "$node_(366) setdest 124533 17960 2.0" 
$ns at 687.0042789731366 "$node_(366) setdest 55215 42861 5.0" 
$ns at 728.7348539768791 "$node_(366) setdest 64651 990 13.0" 
$ns at 762.9423781442025 "$node_(366) setdest 123927 33042 11.0" 
$ns at 808.619809643541 "$node_(366) setdest 117909 32608 16.0" 
$ns at 348.0485799707461 "$node_(367) setdest 112062 25061 7.0" 
$ns at 426.30583719264047 "$node_(367) setdest 95365 4515 17.0" 
$ns at 568.7621919065493 "$node_(367) setdest 124435 29819 16.0" 
$ns at 621.6228545682227 "$node_(367) setdest 86177 2167 2.0" 
$ns at 654.5176164722325 "$node_(367) setdest 6713 325 10.0" 
$ns at 757.9678330812762 "$node_(367) setdest 124511 16721 1.0" 
$ns at 797.0058811355077 "$node_(367) setdest 118706 42376 16.0" 
$ns at 317.1991064386725 "$node_(368) setdest 44942 36212 14.0" 
$ns at 462.88128691708215 "$node_(368) setdest 108374 29607 13.0" 
$ns at 590.3925365193663 "$node_(368) setdest 95784 18731 13.0" 
$ns at 654.197850616324 "$node_(368) setdest 97675 29432 4.0" 
$ns at 688.5220310873821 "$node_(368) setdest 2370 15892 5.0" 
$ns at 749.5430114089722 "$node_(368) setdest 22635 42794 5.0" 
$ns at 795.3806112848163 "$node_(368) setdest 118256 2196 18.0" 
$ns at 858.1505603874457 "$node_(368) setdest 84044 43363 15.0" 
$ns at 323.00707997617064 "$node_(369) setdest 46392 12712 8.0" 
$ns at 371.74740438503125 "$node_(369) setdest 52660 2322 8.0" 
$ns at 405.00132130927483 "$node_(369) setdest 36463 26459 1.0" 
$ns at 440.3354258566892 "$node_(369) setdest 99562 22667 9.0" 
$ns at 500.1793957810925 "$node_(369) setdest 51275 22635 14.0" 
$ns at 567.5065661868041 "$node_(369) setdest 102102 34947 11.0" 
$ns at 685.2780248138201 "$node_(369) setdest 70764 13392 18.0" 
$ns at 868.7240649918085 "$node_(369) setdest 73357 17597 5.0" 
$ns at 370.245714399822 "$node_(370) setdest 76112 2799 19.0" 
$ns at 538.1035484382905 "$node_(370) setdest 1549 3750 1.0" 
$ns at 575.7565643137996 "$node_(370) setdest 53910 30839 7.0" 
$ns at 667.684188070771 "$node_(370) setdest 55581 1470 8.0" 
$ns at 707.5460912254498 "$node_(370) setdest 33283 20850 18.0" 
$ns at 859.5176781314119 "$node_(370) setdest 3949 31554 5.0" 
$ns at 896.4935319059181 "$node_(370) setdest 107100 31592 17.0" 
$ns at 350.07931886231177 "$node_(371) setdest 71699 24176 1.0" 
$ns at 381.8791241212753 "$node_(371) setdest 112279 4567 12.0" 
$ns at 449.12267514168025 "$node_(371) setdest 105866 35928 1.0" 
$ns at 481.5342201494012 "$node_(371) setdest 65119 20323 16.0" 
$ns at 630.1141604240381 "$node_(371) setdest 94304 10493 15.0" 
$ns at 703.9199471398404 "$node_(371) setdest 44996 1606 19.0" 
$ns at 742.4235548356971 "$node_(371) setdest 44582 3578 10.0" 
$ns at 819.7085827775352 "$node_(371) setdest 71751 39475 6.0" 
$ns at 852.6546386538682 "$node_(371) setdest 61754 24894 19.0" 
$ns at 323.69328388631743 "$node_(372) setdest 121148 41783 12.0" 
$ns at 447.7347378887389 "$node_(372) setdest 119223 13134 14.0" 
$ns at 601.6185139244884 "$node_(372) setdest 52978 3282 3.0" 
$ns at 658.2292952475714 "$node_(372) setdest 52696 42759 12.0" 
$ns at 747.9967834801821 "$node_(372) setdest 66157 36600 10.0" 
$ns at 842.8443311383685 "$node_(372) setdest 67693 38433 13.0" 
$ns at 329.58748744979175 "$node_(373) setdest 115532 41575 8.0" 
$ns at 426.19723120758914 "$node_(373) setdest 74045 225 1.0" 
$ns at 464.51623727850654 "$node_(373) setdest 129748 31008 17.0" 
$ns at 561.6982469273628 "$node_(373) setdest 124859 6311 14.0" 
$ns at 636.4251754667691 "$node_(373) setdest 102540 11102 11.0" 
$ns at 770.9828780641083 "$node_(373) setdest 96814 43256 18.0" 
$ns at 811.4781814606489 "$node_(373) setdest 4676 22565 17.0" 
$ns at 868.6392912533053 "$node_(373) setdest 128487 30302 18.0" 
$ns at 392.47352889098846 "$node_(374) setdest 109041 409 17.0" 
$ns at 437.33390392744366 "$node_(374) setdest 35124 7892 7.0" 
$ns at 534.3925166421794 "$node_(374) setdest 91004 32213 4.0" 
$ns at 585.9792299920382 "$node_(374) setdest 72068 17670 18.0" 
$ns at 671.3167023585806 "$node_(374) setdest 132905 18139 10.0" 
$ns at 759.4702692056371 "$node_(374) setdest 75276 10326 7.0" 
$ns at 830.6293214046157 "$node_(374) setdest 13372 28487 18.0" 
$ns at 431.13226180188417 "$node_(375) setdest 89282 6742 4.0" 
$ns at 488.7605284576617 "$node_(375) setdest 111446 11256 1.0" 
$ns at 525.2608171252643 "$node_(375) setdest 81485 25894 12.0" 
$ns at 612.8620285643188 "$node_(375) setdest 20071 37530 16.0" 
$ns at 714.1773148844032 "$node_(375) setdest 58322 10098 17.0" 
$ns at 855.8000330576608 "$node_(375) setdest 74305 21271 17.0" 
$ns at 342.2341391588697 "$node_(376) setdest 9817 41774 19.0" 
$ns at 432.20158691662476 "$node_(376) setdest 97950 15333 5.0" 
$ns at 504.0356485755093 "$node_(376) setdest 20061 14155 6.0" 
$ns at 589.0359684449576 "$node_(376) setdest 123983 3009 19.0" 
$ns at 736.5916900694217 "$node_(376) setdest 15540 44188 15.0" 
$ns at 798.2145728018601 "$node_(376) setdest 114820 24000 9.0" 
$ns at 354.8543173720037 "$node_(377) setdest 16743 26742 7.0" 
$ns at 428.4078372217642 "$node_(377) setdest 40394 21307 13.0" 
$ns at 575.2892800775369 "$node_(377) setdest 8732 19460 2.0" 
$ns at 617.5147131612644 "$node_(377) setdest 77343 17371 18.0" 
$ns at 682.8470813984956 "$node_(377) setdest 49819 1636 14.0" 
$ns at 811.3863362000957 "$node_(377) setdest 108613 32127 5.0" 
$ns at 849.285037372655 "$node_(377) setdest 20730 43517 4.0" 
$ns at 890.9988643395683 "$node_(377) setdest 75598 26508 10.0" 
$ns at 305.28416310465354 "$node_(378) setdest 92227 9075 19.0" 
$ns at 433.0823196743409 "$node_(378) setdest 122328 29004 7.0" 
$ns at 469.1618174842821 "$node_(378) setdest 79692 20852 11.0" 
$ns at 566.6584602827379 "$node_(378) setdest 97125 37063 12.0" 
$ns at 714.5378095919673 "$node_(378) setdest 57956 12123 4.0" 
$ns at 774.4132035271883 "$node_(378) setdest 112123 21619 12.0" 
$ns at 853.1551632781006 "$node_(378) setdest 24896 1003 16.0" 
$ns at 362.7536236862058 "$node_(379) setdest 24068 41464 13.0" 
$ns at 474.42342028919035 "$node_(379) setdest 49702 19020 20.0" 
$ns at 562.9757805218857 "$node_(379) setdest 72430 1715 2.0" 
$ns at 599.1478348691666 "$node_(379) setdest 109934 36182 9.0" 
$ns at 654.9338524583359 "$node_(379) setdest 21071 13500 4.0" 
$ns at 685.8308313589253 "$node_(379) setdest 5896 10011 16.0" 
$ns at 862.2452864322122 "$node_(379) setdest 59782 30423 9.0" 
$ns at 347.7597939305962 "$node_(380) setdest 59555 1285 19.0" 
$ns at 380.84185351901004 "$node_(380) setdest 96081 9041 13.0" 
$ns at 419.4664445787519 "$node_(380) setdest 129413 38429 2.0" 
$ns at 459.35891455249305 "$node_(380) setdest 7501 34177 8.0" 
$ns at 552.2339917266174 "$node_(380) setdest 69033 26639 15.0" 
$ns at 605.9425953951062 "$node_(380) setdest 51600 24566 13.0" 
$ns at 685.7773542935918 "$node_(380) setdest 134140 27861 15.0" 
$ns at 733.1994769890741 "$node_(380) setdest 55513 26697 9.0" 
$ns at 810.1730077001673 "$node_(380) setdest 129653 9082 8.0" 
$ns at 332.63884282042744 "$node_(381) setdest 112970 4851 1.0" 
$ns at 368.45613751767536 "$node_(381) setdest 52249 5629 2.0" 
$ns at 415.055180928214 "$node_(381) setdest 66399 19648 13.0" 
$ns at 491.5084186052951 "$node_(381) setdest 106224 34296 12.0" 
$ns at 573.2020711608811 "$node_(381) setdest 19323 42932 6.0" 
$ns at 608.3917043125741 "$node_(381) setdest 124388 44610 1.0" 
$ns at 641.4234756131691 "$node_(381) setdest 79120 5954 3.0" 
$ns at 673.4094838720825 "$node_(381) setdest 77507 29636 12.0" 
$ns at 802.0348478186622 "$node_(381) setdest 123999 33868 14.0" 
$ns at 867.8207086827176 "$node_(381) setdest 126086 42399 18.0" 
$ns at 323.5407368168851 "$node_(382) setdest 103553 29357 7.0" 
$ns at 420.3394383366816 "$node_(382) setdest 97979 2086 19.0" 
$ns at 577.2326517353752 "$node_(382) setdest 122733 7546 12.0" 
$ns at 715.5105840764105 "$node_(382) setdest 122487 4126 3.0" 
$ns at 750.4362413985806 "$node_(382) setdest 73404 27532 19.0" 
$ns at 337.4883822920886 "$node_(383) setdest 8604 17396 10.0" 
$ns at 386.87267268724236 "$node_(383) setdest 22950 35633 11.0" 
$ns at 476.722566039002 "$node_(383) setdest 115699 38760 14.0" 
$ns at 619.340848266098 "$node_(383) setdest 66199 24970 18.0" 
$ns at 762.1014893491215 "$node_(383) setdest 70492 23583 1.0" 
$ns at 800.2503355550531 "$node_(383) setdest 29237 2004 8.0" 
$ns at 873.3490464501614 "$node_(383) setdest 68002 16616 16.0" 
$ns at 303.91394055165335 "$node_(384) setdest 49414 28648 8.0" 
$ns at 389.4180349836725 "$node_(384) setdest 8967 13243 12.0" 
$ns at 534.0970311682585 "$node_(384) setdest 33795 11274 4.0" 
$ns at 568.2620047064723 "$node_(384) setdest 92681 43254 18.0" 
$ns at 773.1309054425116 "$node_(384) setdest 11825 28709 11.0" 
$ns at 810.7951978359424 "$node_(384) setdest 74036 35843 16.0" 
$ns at 380.25353807470674 "$node_(385) setdest 50743 6006 11.0" 
$ns at 454.1952406613613 "$node_(385) setdest 131456 24386 18.0" 
$ns at 634.6718141270928 "$node_(385) setdest 49664 41676 7.0" 
$ns at 720.5768626707311 "$node_(385) setdest 121001 9076 6.0" 
$ns at 791.3812369222888 "$node_(385) setdest 87593 991 14.0" 
$ns at 311.98974180763753 "$node_(386) setdest 67447 37002 14.0" 
$ns at 370.2010272511247 "$node_(386) setdest 19823 24186 11.0" 
$ns at 465.25992241459824 "$node_(386) setdest 107510 19033 1.0" 
$ns at 501.70963632997126 "$node_(386) setdest 25924 33512 10.0" 
$ns at 608.9966223046061 "$node_(386) setdest 30167 14766 6.0" 
$ns at 686.702245201694 "$node_(386) setdest 5485 27728 2.0" 
$ns at 725.1521453982886 "$node_(386) setdest 102264 32935 9.0" 
$ns at 803.009043024851 "$node_(386) setdest 11163 10081 7.0" 
$ns at 894.477675892048 "$node_(386) setdest 109362 10099 15.0" 
$ns at 387.54554446114946 "$node_(387) setdest 38527 38489 8.0" 
$ns at 488.0548133752425 "$node_(387) setdest 52323 16727 4.0" 
$ns at 536.596215647786 "$node_(387) setdest 79720 34862 9.0" 
$ns at 649.4977792467587 "$node_(387) setdest 10422 37903 11.0" 
$ns at 714.9964616023929 "$node_(387) setdest 25678 32128 10.0" 
$ns at 765.9418782727861 "$node_(387) setdest 88196 1348 6.0" 
$ns at 844.6989315678567 "$node_(387) setdest 27935 27256 2.0" 
$ns at 884.2895867692691 "$node_(387) setdest 88242 6976 6.0" 
$ns at 328.05000589219816 "$node_(388) setdest 107072 9147 11.0" 
$ns at 465.1755403782519 "$node_(388) setdest 30352 33757 3.0" 
$ns at 499.3832507599841 "$node_(388) setdest 52006 41805 6.0" 
$ns at 550.6239815751591 "$node_(388) setdest 82709 853 13.0" 
$ns at 636.2082803231791 "$node_(388) setdest 115973 4456 6.0" 
$ns at 721.9245624337505 "$node_(388) setdest 110222 42629 7.0" 
$ns at 808.4688735806247 "$node_(388) setdest 112819 8997 5.0" 
$ns at 867.2652061247353 "$node_(388) setdest 9144 20683 1.0" 
$ns at 443.26372541416885 "$node_(389) setdest 64252 834 6.0" 
$ns at 524.3874471199879 "$node_(389) setdest 73164 44312 11.0" 
$ns at 571.609132004603 "$node_(389) setdest 122045 42244 11.0" 
$ns at 652.4986967061571 "$node_(389) setdest 24581 39477 6.0" 
$ns at 687.3298615499101 "$node_(389) setdest 51221 13434 6.0" 
$ns at 746.4426711376242 "$node_(389) setdest 117104 42624 13.0" 
$ns at 824.7444179226234 "$node_(389) setdest 19420 1792 2.0" 
$ns at 872.3385339625488 "$node_(389) setdest 89968 43308 1.0" 
$ns at 310.5872777564492 "$node_(390) setdest 8829 24819 7.0" 
$ns at 382.63953556155116 "$node_(390) setdest 60948 16999 15.0" 
$ns at 494.8655938418581 "$node_(390) setdest 36921 20241 13.0" 
$ns at 525.3656438374999 "$node_(390) setdest 85729 8084 7.0" 
$ns at 567.1240379489559 "$node_(390) setdest 99889 20144 16.0" 
$ns at 687.9729360635315 "$node_(390) setdest 116181 42409 15.0" 
$ns at 724.9297268815004 "$node_(390) setdest 51385 15727 14.0" 
$ns at 771.8438231385477 "$node_(390) setdest 66899 23026 13.0" 
$ns at 836.2810237204965 "$node_(390) setdest 39334 35602 15.0" 
$ns at 324.49507172905925 "$node_(391) setdest 44851 10630 7.0" 
$ns at 371.27191894597036 "$node_(391) setdest 99119 16663 15.0" 
$ns at 533.9176857772661 "$node_(391) setdest 109081 30633 19.0" 
$ns at 698.537334857577 "$node_(391) setdest 111452 9341 13.0" 
$ns at 728.9748202092818 "$node_(391) setdest 87615 9372 17.0" 
$ns at 849.1755071352196 "$node_(391) setdest 31616 11853 10.0" 
$ns at 330.59990188233746 "$node_(392) setdest 95129 13194 5.0" 
$ns at 383.07051841929376 "$node_(392) setdest 2921 14917 7.0" 
$ns at 476.32568823419655 "$node_(392) setdest 10 27775 14.0" 
$ns at 507.34604511612497 "$node_(392) setdest 39459 28207 8.0" 
$ns at 555.6626950465404 "$node_(392) setdest 36830 29829 5.0" 
$ns at 598.2634299768602 "$node_(392) setdest 78426 34294 7.0" 
$ns at 670.389552719241 "$node_(392) setdest 90480 40874 19.0" 
$ns at 820.9392972221076 "$node_(392) setdest 128592 39753 20.0" 
$ns at 422.47020215699786 "$node_(393) setdest 11285 25244 1.0" 
$ns at 457.8505491351209 "$node_(393) setdest 20833 34027 3.0" 
$ns at 495.62265167498845 "$node_(393) setdest 70764 19170 15.0" 
$ns at 628.0058366440202 "$node_(393) setdest 115335 31368 6.0" 
$ns at 702.8728645066898 "$node_(393) setdest 33647 17589 16.0" 
$ns at 780.6662313139564 "$node_(393) setdest 62 13063 7.0" 
$ns at 830.7452317437076 "$node_(393) setdest 39831 28647 19.0" 
$ns at 395.76259850067436 "$node_(394) setdest 48087 13866 8.0" 
$ns at 478.1920669300623 "$node_(394) setdest 20481 39061 10.0" 
$ns at 600.4066669484857 "$node_(394) setdest 5583 35524 4.0" 
$ns at 654.4540184586014 "$node_(394) setdest 7100 22551 12.0" 
$ns at 687.9466292179605 "$node_(394) setdest 16465 36681 2.0" 
$ns at 737.5809046871439 "$node_(394) setdest 11494 33054 1.0" 
$ns at 769.1619044230192 "$node_(394) setdest 101186 7766 2.0" 
$ns at 814.683630519993 "$node_(394) setdest 96641 5930 10.0" 
$ns at 368.30137304925097 "$node_(395) setdest 120524 9281 6.0" 
$ns at 434.0369727591157 "$node_(395) setdest 78446 40554 6.0" 
$ns at 472.2287396955095 "$node_(395) setdest 106437 17199 14.0" 
$ns at 539.0413037904999 "$node_(395) setdest 116361 11662 19.0" 
$ns at 749.4918065747725 "$node_(395) setdest 53367 30124 13.0" 
$ns at 851.1631164358454 "$node_(395) setdest 16115 2561 1.0" 
$ns at 890.1966769490353 "$node_(395) setdest 1033 18683 8.0" 
$ns at 336.90069757373067 "$node_(396) setdest 23702 38451 3.0" 
$ns at 387.04749765227393 "$node_(396) setdest 82390 1922 2.0" 
$ns at 432.3662786568883 "$node_(396) setdest 73826 6036 16.0" 
$ns at 522.1180089217835 "$node_(396) setdest 133549 41687 13.0" 
$ns at 626.3279773439128 "$node_(396) setdest 84263 17804 16.0" 
$ns at 665.8025298362319 "$node_(396) setdest 51 25457 16.0" 
$ns at 837.9042984537517 "$node_(396) setdest 51268 41318 5.0" 
$ns at 304.8629977696059 "$node_(397) setdest 35539 41050 11.0" 
$ns at 350.5930341680919 "$node_(397) setdest 26024 26134 12.0" 
$ns at 470.75602637596694 "$node_(397) setdest 63971 34011 12.0" 
$ns at 559.1219513125034 "$node_(397) setdest 68030 34949 2.0" 
$ns at 603.514990269056 "$node_(397) setdest 49386 43965 18.0" 
$ns at 784.4949091393001 "$node_(397) setdest 13890 9286 17.0" 
$ns at 338.1760114423648 "$node_(398) setdest 125238 38515 16.0" 
$ns at 473.12732940288663 "$node_(398) setdest 100228 2304 8.0" 
$ns at 513.5673801663831 "$node_(398) setdest 32414 43140 18.0" 
$ns at 579.5308118648147 "$node_(398) setdest 17827 31853 6.0" 
$ns at 625.4930582136175 "$node_(398) setdest 84624 23555 9.0" 
$ns at 742.8591254960319 "$node_(398) setdest 41614 13636 20.0" 
$ns at 787.0011512289257 "$node_(398) setdest 80023 19970 1.0" 
$ns at 823.2496095983059 "$node_(398) setdest 50860 43797 10.0" 
$ns at 357.9731183289646 "$node_(399) setdest 68074 23790 2.0" 
$ns at 399.6180557090113 "$node_(399) setdest 114227 31353 4.0" 
$ns at 465.38346549894953 "$node_(399) setdest 111253 31185 12.0" 
$ns at 526.1429044496564 "$node_(399) setdest 92115 39068 18.0" 
$ns at 622.1538996914205 "$node_(399) setdest 111556 34596 9.0" 
$ns at 675.1245338305137 "$node_(399) setdest 40142 22237 17.0" 
$ns at 783.8620080213406 "$node_(399) setdest 118736 7810 5.0" 
$ns at 859.2790296997621 "$node_(399) setdest 61079 5888 10.0" 
$ns at 542.9483075196534 "$node_(400) setdest 69787 31082 11.0" 
$ns at 625.1612140377338 "$node_(400) setdest 105091 33344 10.0" 
$ns at 735.3419636179667 "$node_(400) setdest 20363 2869 17.0" 
$ns at 766.4228751480795 "$node_(400) setdest 126071 14980 13.0" 
$ns at 849.9803333736736 "$node_(400) setdest 71657 23553 3.0" 
$ns at 880.0278832699547 "$node_(400) setdest 26135 20385 6.0" 
$ns at 481.7077013624839 "$node_(401) setdest 58855 25612 16.0" 
$ns at 553.4861577692017 "$node_(401) setdest 104151 30663 19.0" 
$ns at 693.6000200187189 "$node_(401) setdest 117807 5223 19.0" 
$ns at 408.056677562916 "$node_(402) setdest 26497 4328 15.0" 
$ns at 523.9247153531836 "$node_(402) setdest 114161 488 9.0" 
$ns at 607.2915392190635 "$node_(402) setdest 56679 18350 19.0" 
$ns at 795.8400385596747 "$node_(402) setdest 60744 24548 16.0" 
$ns at 433.3318938262226 "$node_(403) setdest 65722 13065 1.0" 
$ns at 466.05494051528933 "$node_(403) setdest 58035 13967 6.0" 
$ns at 546.2295370073645 "$node_(403) setdest 101779 37402 5.0" 
$ns at 597.5869711421557 "$node_(403) setdest 77996 22393 18.0" 
$ns at 639.5465841660422 "$node_(403) setdest 32954 30587 2.0" 
$ns at 675.4635770686258 "$node_(403) setdest 92465 41890 16.0" 
$ns at 767.8975718708436 "$node_(403) setdest 70358 10933 15.0" 
$ns at 429.03080180438224 "$node_(404) setdest 70922 22527 6.0" 
$ns at 492.84637938494575 "$node_(404) setdest 106664 2589 12.0" 
$ns at 613.5963205637214 "$node_(404) setdest 24658 31017 12.0" 
$ns at 746.219861980043 "$node_(404) setdest 1501 35303 17.0" 
$ns at 853.6178217305736 "$node_(404) setdest 23620 37246 6.0" 
$ns at 422.14329321824584 "$node_(405) setdest 52758 18930 7.0" 
$ns at 506.7536516396367 "$node_(405) setdest 92930 13111 11.0" 
$ns at 570.9499119572154 "$node_(405) setdest 30272 9269 16.0" 
$ns at 611.5857318950707 "$node_(405) setdest 33226 27750 19.0" 
$ns at 695.8174203550107 "$node_(405) setdest 11468 32993 1.0" 
$ns at 727.714486384455 "$node_(405) setdest 94456 37640 10.0" 
$ns at 842.346087947706 "$node_(405) setdest 98017 6733 3.0" 
$ns at 883.6584123208473 "$node_(405) setdest 53459 11806 10.0" 
$ns at 507.089367522412 "$node_(406) setdest 57116 2713 1.0" 
$ns at 543.0355663274371 "$node_(406) setdest 14862 38608 6.0" 
$ns at 622.9492692563987 "$node_(406) setdest 22542 43288 9.0" 
$ns at 675.3828998753938 "$node_(406) setdest 35851 13193 3.0" 
$ns at 729.799596293414 "$node_(406) setdest 48791 32122 5.0" 
$ns at 774.3851439388977 "$node_(406) setdest 123468 17297 15.0" 
$ns at 519.9091962978896 "$node_(407) setdest 31456 39397 7.0" 
$ns at 564.8682187733701 "$node_(407) setdest 67795 1860 15.0" 
$ns at 701.8330512342513 "$node_(407) setdest 91895 9751 1.0" 
$ns at 738.3166470629028 "$node_(407) setdest 125538 18085 1.0" 
$ns at 777.6665805094146 "$node_(407) setdest 114687 20693 14.0" 
$ns at 818.6167072010957 "$node_(407) setdest 95051 8093 19.0" 
$ns at 511.0987109020721 "$node_(408) setdest 126867 42247 5.0" 
$ns at 566.2489620324066 "$node_(408) setdest 109477 18724 5.0" 
$ns at 602.5598800633828 "$node_(408) setdest 113253 32506 15.0" 
$ns at 738.2644072319811 "$node_(408) setdest 83236 22026 17.0" 
$ns at 777.0616326812406 "$node_(408) setdest 71795 19348 13.0" 
$ns at 415.6041945458557 "$node_(409) setdest 63905 28303 4.0" 
$ns at 457.12662995478803 "$node_(409) setdest 82536 28596 2.0" 
$ns at 493.09441621663103 "$node_(409) setdest 19738 27862 10.0" 
$ns at 585.7657738705211 "$node_(409) setdest 83498 19516 6.0" 
$ns at 661.9035436859276 "$node_(409) setdest 14883 44200 17.0" 
$ns at 860.153790924061 "$node_(409) setdest 104847 18441 4.0" 
$ns at 470.93347825357205 "$node_(410) setdest 52228 44157 1.0" 
$ns at 506.30470164554526 "$node_(410) setdest 91168 20028 4.0" 
$ns at 568.0488626937134 "$node_(410) setdest 15323 14612 7.0" 
$ns at 637.56155836518 "$node_(410) setdest 47100 27893 6.0" 
$ns at 705.5386610156869 "$node_(410) setdest 7817 13443 4.0" 
$ns at 742.5595213501374 "$node_(410) setdest 102514 6995 12.0" 
$ns at 796.4184318536466 "$node_(410) setdest 39597 42403 20.0" 
$ns at 857.6706437277427 "$node_(410) setdest 116810 17437 10.0" 
$ns at 470.7801857378972 "$node_(411) setdest 88081 35330 14.0" 
$ns at 611.7982807967956 "$node_(411) setdest 126448 43627 1.0" 
$ns at 644.2321254710845 "$node_(411) setdest 18478 32958 15.0" 
$ns at 730.3151678166683 "$node_(411) setdest 67726 41825 15.0" 
$ns at 830.373383160246 "$node_(411) setdest 83222 19396 9.0" 
$ns at 868.4927405811474 "$node_(411) setdest 118438 12867 2.0" 
$ns at 488.6412654873142 "$node_(412) setdest 75956 41975 12.0" 
$ns at 571.593316580749 "$node_(412) setdest 86558 27722 15.0" 
$ns at 659.5592323970285 "$node_(412) setdest 82902 17106 20.0" 
$ns at 780.1064426271054 "$node_(412) setdest 102924 39269 10.0" 
$ns at 859.1463217885008 "$node_(412) setdest 97996 24415 19.0" 
$ns at 400.0383773539544 "$node_(413) setdest 43517 14492 16.0" 
$ns at 442.96772334583335 "$node_(413) setdest 95822 44661 12.0" 
$ns at 479.5108092579798 "$node_(413) setdest 111599 44396 15.0" 
$ns at 618.1040075280482 "$node_(413) setdest 61217 5856 7.0" 
$ns at 650.968100160767 "$node_(413) setdest 11590 4511 14.0" 
$ns at 682.9148084707108 "$node_(413) setdest 99946 391 14.0" 
$ns at 772.8191918520162 "$node_(413) setdest 22106 1621 19.0" 
$ns at 477.7994636750338 "$node_(414) setdest 102941 13042 5.0" 
$ns at 513.3696227291304 "$node_(414) setdest 60622 36894 11.0" 
$ns at 549.1437869026305 "$node_(414) setdest 74846 3943 20.0" 
$ns at 757.4494489356606 "$node_(414) setdest 73429 23544 9.0" 
$ns at 852.4345822408927 "$node_(414) setdest 1933 44153 12.0" 
$ns at 516.6319376401173 "$node_(415) setdest 29043 5048 8.0" 
$ns at 564.1137635017317 "$node_(415) setdest 87798 34262 17.0" 
$ns at 610.2214328456433 "$node_(415) setdest 127577 9263 2.0" 
$ns at 655.2934595835693 "$node_(415) setdest 50494 4176 9.0" 
$ns at 712.0597917262508 "$node_(415) setdest 110055 13263 5.0" 
$ns at 774.769900058564 "$node_(415) setdest 100072 8934 19.0" 
$ns at 433.1738356385516 "$node_(416) setdest 57123 22375 3.0" 
$ns at 472.4179037337316 "$node_(416) setdest 109533 31251 13.0" 
$ns at 574.6912467455064 "$node_(416) setdest 72695 38078 9.0" 
$ns at 622.1800138343253 "$node_(416) setdest 124280 17865 20.0" 
$ns at 776.2727825940003 "$node_(416) setdest 19371 7954 1.0" 
$ns at 814.8546431707384 "$node_(416) setdest 70428 25679 6.0" 
$ns at 889.1954675485033 "$node_(416) setdest 28272 3977 18.0" 
$ns at 449.08683590968326 "$node_(417) setdest 103519 18407 16.0" 
$ns at 620.4723651686065 "$node_(417) setdest 100874 41110 13.0" 
$ns at 697.0522430653583 "$node_(417) setdest 105375 9676 16.0" 
$ns at 778.6225610023704 "$node_(417) setdest 31829 7890 1.0" 
$ns at 812.5034969622016 "$node_(417) setdest 78280 8014 18.0" 
$ns at 462.92562173436727 "$node_(418) setdest 101119 16659 20.0" 
$ns at 544.6366916116989 "$node_(418) setdest 95016 39524 14.0" 
$ns at 679.1807439316892 "$node_(418) setdest 66506 28757 18.0" 
$ns at 780.0554390791002 "$node_(418) setdest 42058 18827 18.0" 
$ns at 400.63477969634397 "$node_(419) setdest 80803 11452 13.0" 
$ns at 478.170934510963 "$node_(419) setdest 122915 32036 17.0" 
$ns at 626.4482919413009 "$node_(419) setdest 66925 42115 15.0" 
$ns at 729.9037239284811 "$node_(419) setdest 56518 8613 9.0" 
$ns at 775.1640635508161 "$node_(419) setdest 59045 31736 8.0" 
$ns at 812.6601521340016 "$node_(419) setdest 130410 27781 15.0" 
$ns at 480.94255977850196 "$node_(420) setdest 48110 35020 1.0" 
$ns at 513.6673596153224 "$node_(420) setdest 81234 24548 14.0" 
$ns at 643.57051402416 "$node_(420) setdest 47039 40930 7.0" 
$ns at 703.0523598482933 "$node_(420) setdest 81906 1253 1.0" 
$ns at 736.8138322230071 "$node_(420) setdest 58091 36439 19.0" 
$ns at 428.38427965668023 "$node_(421) setdest 130823 2587 1.0" 
$ns at 463.9300842760156 "$node_(421) setdest 57405 3752 12.0" 
$ns at 557.9507506407987 "$node_(421) setdest 121569 21898 13.0" 
$ns at 688.5528457433795 "$node_(421) setdest 96210 11458 18.0" 
$ns at 829.2006538379135 "$node_(421) setdest 74440 39403 16.0" 
$ns at 446.1265225432442 "$node_(422) setdest 126070 22448 7.0" 
$ns at 513.804342903325 "$node_(422) setdest 115992 23642 19.0" 
$ns at 666.388394642954 "$node_(422) setdest 34564 17177 4.0" 
$ns at 734.3547742100136 "$node_(422) setdest 33265 5088 1.0" 
$ns at 772.1500485199531 "$node_(422) setdest 130814 9043 19.0" 
$ns at 856.6640293375353 "$node_(422) setdest 85797 39569 19.0" 
$ns at 436.60484171364254 "$node_(423) setdest 60399 7472 13.0" 
$ns at 581.2309635664136 "$node_(423) setdest 46163 44676 8.0" 
$ns at 615.7673706378112 "$node_(423) setdest 17763 29319 16.0" 
$ns at 775.0340382419784 "$node_(423) setdest 39519 41276 20.0" 
$ns at 477.00797751814594 "$node_(424) setdest 55160 37586 4.0" 
$ns at 542.6651682559301 "$node_(424) setdest 7502 26898 9.0" 
$ns at 637.2425015057844 "$node_(424) setdest 39392 18488 3.0" 
$ns at 671.9006824967461 "$node_(424) setdest 31372 10996 4.0" 
$ns at 736.2872834065555 "$node_(424) setdest 128590 12979 13.0" 
$ns at 871.8697130681044 "$node_(424) setdest 70358 38630 8.0" 
$ns at 458.4518270648002 "$node_(425) setdest 65807 8862 2.0" 
$ns at 497.656608064925 "$node_(425) setdest 19512 23412 11.0" 
$ns at 591.6691660012254 "$node_(425) setdest 49780 20213 12.0" 
$ns at 721.2549061897482 "$node_(425) setdest 110304 8336 1.0" 
$ns at 753.5493153692971 "$node_(425) setdest 131226 31276 9.0" 
$ns at 791.4167960808245 "$node_(425) setdest 90675 4736 13.0" 
$ns at 854.9414792710819 "$node_(425) setdest 61489 10455 7.0" 
$ns at 457.5436362681347 "$node_(426) setdest 18102 35384 4.0" 
$ns at 495.2996687264777 "$node_(426) setdest 22995 18046 2.0" 
$ns at 533.4589392294214 "$node_(426) setdest 58237 26397 17.0" 
$ns at 620.2895465910211 "$node_(426) setdest 34285 490 1.0" 
$ns at 659.7145468577401 "$node_(426) setdest 125080 37530 18.0" 
$ns at 727.1159102382976 "$node_(426) setdest 37287 28616 9.0" 
$ns at 797.364537234878 "$node_(426) setdest 78901 12080 2.0" 
$ns at 836.3288850402132 "$node_(426) setdest 25791 32001 8.0" 
$ns at 884.3816367861556 "$node_(426) setdest 103607 35167 17.0" 
$ns at 441.50706856336456 "$node_(427) setdest 11405 41430 14.0" 
$ns at 533.1508324219839 "$node_(427) setdest 96134 4849 15.0" 
$ns at 674.6375293526803 "$node_(427) setdest 61091 4976 17.0" 
$ns at 724.9477183935132 "$node_(427) setdest 55152 19470 6.0" 
$ns at 774.3019565081937 "$node_(427) setdest 54456 7212 3.0" 
$ns at 806.567385847448 "$node_(427) setdest 33205 4539 19.0" 
$ns at 429.2669173563845 "$node_(428) setdest 91615 220 11.0" 
$ns at 513.8822670695625 "$node_(428) setdest 120748 26390 4.0" 
$ns at 561.5737734491622 "$node_(428) setdest 22339 23529 9.0" 
$ns at 621.4942080206497 "$node_(428) setdest 64575 42212 14.0" 
$ns at 727.7382590834677 "$node_(428) setdest 88904 15502 10.0" 
$ns at 818.7908438869695 "$node_(428) setdest 9213 17462 13.0" 
$ns at 430.5772137391169 "$node_(429) setdest 60040 3366 17.0" 
$ns at 513.237360795888 "$node_(429) setdest 22720 13096 10.0" 
$ns at 623.2436558432278 "$node_(429) setdest 112692 42506 1.0" 
$ns at 659.9530492307347 "$node_(429) setdest 31725 42737 13.0" 
$ns at 799.6032295049113 "$node_(429) setdest 35729 15914 5.0" 
$ns at 865.9106920933771 "$node_(429) setdest 133030 22424 17.0" 
$ns at 436.6163095465842 "$node_(430) setdest 130395 43511 8.0" 
$ns at 492.06750539806586 "$node_(430) setdest 126126 22821 10.0" 
$ns at 593.1017220570352 "$node_(430) setdest 125529 2880 7.0" 
$ns at 667.7301459511316 "$node_(430) setdest 89130 30220 10.0" 
$ns at 793.4584251439493 "$node_(430) setdest 57514 18023 11.0" 
$ns at 451.2616481269069 "$node_(431) setdest 51667 492 8.0" 
$ns at 500.2272285784025 "$node_(431) setdest 9358 42950 9.0" 
$ns at 562.6946848024405 "$node_(431) setdest 76372 13600 15.0" 
$ns at 650.6793092297293 "$node_(431) setdest 30446 44509 5.0" 
$ns at 714.5407610744951 "$node_(431) setdest 80252 38323 8.0" 
$ns at 807.2656197473457 "$node_(431) setdest 71158 22535 5.0" 
$ns at 840.2716006119952 "$node_(431) setdest 16874 8930 16.0" 
$ns at 407.3216822116557 "$node_(432) setdest 77009 41219 16.0" 
$ns at 471.05896999188496 "$node_(432) setdest 18059 34985 19.0" 
$ns at 652.8459810234756 "$node_(432) setdest 28234 28192 8.0" 
$ns at 721.6652449636434 "$node_(432) setdest 130724 854 4.0" 
$ns at 790.4642051409 "$node_(432) setdest 115158 38826 15.0" 
$ns at 853.8257881910617 "$node_(432) setdest 129445 44264 17.0" 
$ns at 481.6636838273429 "$node_(433) setdest 61964 31837 1.0" 
$ns at 519.037202234283 "$node_(433) setdest 73002 36296 2.0" 
$ns at 559.4024713094101 "$node_(433) setdest 57444 19544 15.0" 
$ns at 695.8097207911376 "$node_(433) setdest 119999 30063 2.0" 
$ns at 737.4170890805503 "$node_(433) setdest 4592 30313 19.0" 
$ns at 457.50037167726566 "$node_(434) setdest 69450 1867 4.0" 
$ns at 508.5480347670825 "$node_(434) setdest 103755 11310 19.0" 
$ns at 691.3811567720145 "$node_(434) setdest 13485 18836 3.0" 
$ns at 740.2205686584094 "$node_(434) setdest 128139 668 5.0" 
$ns at 811.4423522318233 "$node_(434) setdest 18127 29173 3.0" 
$ns at 842.409821500498 "$node_(434) setdest 79834 33713 15.0" 
$ns at 495.89202629363933 "$node_(435) setdest 85350 40991 2.0" 
$ns at 537.0821819312079 "$node_(435) setdest 37777 5960 9.0" 
$ns at 594.0884851092612 "$node_(435) setdest 130070 23623 5.0" 
$ns at 630.1926641780068 "$node_(435) setdest 60912 26401 3.0" 
$ns at 676.9891649881139 "$node_(435) setdest 117198 30178 17.0" 
$ns at 800.3430762236583 "$node_(435) setdest 4702 11382 17.0" 
$ns at 891.9170276933372 "$node_(435) setdest 3223 34205 5.0" 
$ns at 485.277627805815 "$node_(436) setdest 73482 16002 15.0" 
$ns at 649.7352326047976 "$node_(436) setdest 12799 32396 6.0" 
$ns at 684.5628903434507 "$node_(436) setdest 44341 29746 20.0" 
$ns at 747.2872308357497 "$node_(436) setdest 59180 23681 14.0" 
$ns at 855.6527453977046 "$node_(436) setdest 42532 16169 19.0" 
$ns at 447.70640846712047 "$node_(437) setdest 38723 4375 10.0" 
$ns at 524.0811910571974 "$node_(437) setdest 40782 150 3.0" 
$ns at 573.0018602784208 "$node_(437) setdest 122516 7120 19.0" 
$ns at 790.5630969414665 "$node_(437) setdest 122043 12512 10.0" 
$ns at 850.4455265613962 "$node_(437) setdest 109023 40138 12.0" 
$ns at 462.77460337135483 "$node_(438) setdest 25509 13262 20.0" 
$ns at 644.744968429595 "$node_(438) setdest 66220 29356 15.0" 
$ns at 709.9721437533331 "$node_(438) setdest 51571 33792 20.0" 
$ns at 882.6302821971881 "$node_(438) setdest 109083 15592 9.0" 
$ns at 408.01788896050584 "$node_(439) setdest 58515 18623 7.0" 
$ns at 502.23938056315114 "$node_(439) setdest 28160 12813 14.0" 
$ns at 591.7567029685426 "$node_(439) setdest 18531 21661 10.0" 
$ns at 652.9150461415566 "$node_(439) setdest 88343 14934 7.0" 
$ns at 709.8217508495882 "$node_(439) setdest 25269 44325 1.0" 
$ns at 741.6462357144187 "$node_(439) setdest 109025 31257 1.0" 
$ns at 780.6685708437464 "$node_(439) setdest 51724 25596 9.0" 
$ns at 819.5871343155786 "$node_(439) setdest 90532 18034 20.0" 
$ns at 409.04687566789346 "$node_(440) setdest 68679 24297 14.0" 
$ns at 456.3627596199636 "$node_(440) setdest 54153 18670 19.0" 
$ns at 591.2710426990991 "$node_(440) setdest 117990 29819 1.0" 
$ns at 628.8004858847196 "$node_(440) setdest 79760 42664 6.0" 
$ns at 660.0180598642319 "$node_(440) setdest 66550 41874 6.0" 
$ns at 732.6064139052245 "$node_(440) setdest 133112 20182 4.0" 
$ns at 788.4888493403863 "$node_(440) setdest 100092 26877 10.0" 
$ns at 870.4050396177469 "$node_(440) setdest 16295 20492 6.0" 
$ns at 419.6432884968502 "$node_(441) setdest 24170 15355 6.0" 
$ns at 471.69826109201614 "$node_(441) setdest 41129 32521 13.0" 
$ns at 551.6149499062444 "$node_(441) setdest 116220 14314 6.0" 
$ns at 607.9576311562157 "$node_(441) setdest 65725 12940 6.0" 
$ns at 662.926781584762 "$node_(441) setdest 60073 32344 20.0" 
$ns at 803.8277390630981 "$node_(441) setdest 52181 36860 11.0" 
$ns at 881.9509246681604 "$node_(441) setdest 23064 6428 4.0" 
$ns at 530.5354462917173 "$node_(442) setdest 32028 3868 1.0" 
$ns at 563.177536656826 "$node_(442) setdest 110541 39932 8.0" 
$ns at 655.2690974859934 "$node_(442) setdest 43150 17202 9.0" 
$ns at 747.5279364396017 "$node_(442) setdest 90717 36921 14.0" 
$ns at 865.836999871437 "$node_(442) setdest 86012 38386 8.0" 
$ns at 436.2501602189163 "$node_(443) setdest 38983 33577 10.0" 
$ns at 548.4653052163947 "$node_(443) setdest 36064 22336 1.0" 
$ns at 583.1800001101846 "$node_(443) setdest 1566 37769 11.0" 
$ns at 617.9012865250954 "$node_(443) setdest 53093 33457 20.0" 
$ns at 727.6211322978115 "$node_(443) setdest 117351 41244 16.0" 
$ns at 822.33692854919 "$node_(443) setdest 87106 40691 7.0" 
$ns at 532.5631713559226 "$node_(444) setdest 124684 10455 3.0" 
$ns at 565.1505909138115 "$node_(444) setdest 55988 29640 18.0" 
$ns at 657.0292118965663 "$node_(444) setdest 127548 10297 13.0" 
$ns at 749.7686927461226 "$node_(444) setdest 113540 16397 19.0" 
$ns at 483.59125716309194 "$node_(445) setdest 116635 39924 6.0" 
$ns at 515.3444037725372 "$node_(445) setdest 46593 8512 15.0" 
$ns at 663.3469782984441 "$node_(445) setdest 40052 4015 16.0" 
$ns at 776.5440789219917 "$node_(445) setdest 1104 27819 6.0" 
$ns at 835.5885251204666 "$node_(445) setdest 59570 2560 15.0" 
$ns at 882.354395990914 "$node_(445) setdest 96157 6507 7.0" 
$ns at 404.4219048660895 "$node_(446) setdest 107359 17907 4.0" 
$ns at 448.8118301103226 "$node_(446) setdest 78631 41864 6.0" 
$ns at 492.5745869010405 "$node_(446) setdest 88561 1157 17.0" 
$ns at 551.3032602768257 "$node_(446) setdest 110968 22260 2.0" 
$ns at 596.4817929263737 "$node_(446) setdest 13906 39412 15.0" 
$ns at 652.7433466478969 "$node_(446) setdest 10638 44396 16.0" 
$ns at 717.263410587458 "$node_(446) setdest 57789 17119 9.0" 
$ns at 752.5437030155023 "$node_(446) setdest 36698 3781 16.0" 
$ns at 785.0804147249389 "$node_(446) setdest 114546 18937 13.0" 
$ns at 424.5217533658326 "$node_(447) setdest 57850 36991 17.0" 
$ns at 470.12749403443854 "$node_(447) setdest 4269 35028 16.0" 
$ns at 606.2866215838166 "$node_(447) setdest 7687 3732 18.0" 
$ns at 670.0183257050958 "$node_(447) setdest 128167 15192 12.0" 
$ns at 748.1644059099358 "$node_(447) setdest 16546 43542 15.0" 
$ns at 885.0139254528672 "$node_(447) setdest 124433 31386 14.0" 
$ns at 544.2346456715911 "$node_(448) setdest 27389 40417 8.0" 
$ns at 580.3723351040026 "$node_(448) setdest 19662 21356 1.0" 
$ns at 619.6185272819232 "$node_(448) setdest 125513 11603 2.0" 
$ns at 662.1216273761327 "$node_(448) setdest 113191 25470 18.0" 
$ns at 695.2668197830814 "$node_(448) setdest 1762 31775 8.0" 
$ns at 795.0783894668365 "$node_(448) setdest 95673 41434 1.0" 
$ns at 833.0730481152905 "$node_(448) setdest 31624 7784 19.0" 
$ns at 407.07544925582744 "$node_(449) setdest 5138 11521 13.0" 
$ns at 461.8091250375465 "$node_(449) setdest 99367 29065 13.0" 
$ns at 601.0037120878015 "$node_(449) setdest 74201 31676 4.0" 
$ns at 659.6411421016828 "$node_(449) setdest 41030 4632 18.0" 
$ns at 860.8517367016838 "$node_(449) setdest 83544 11252 11.0" 
$ns at 448.0109590205107 "$node_(450) setdest 118428 43290 14.0" 
$ns at 595.9901167235646 "$node_(450) setdest 77312 43089 8.0" 
$ns at 631.9686466592885 "$node_(450) setdest 112025 21678 14.0" 
$ns at 716.8157683637003 "$node_(450) setdest 5355 41200 8.0" 
$ns at 779.9284657882512 "$node_(450) setdest 120315 4657 7.0" 
$ns at 811.6937947623975 "$node_(450) setdest 105810 15363 16.0" 
$ns at 449.7876273404991 "$node_(451) setdest 87643 36048 4.0" 
$ns at 486.037469144262 "$node_(451) setdest 115838 38332 15.0" 
$ns at 663.7970577047968 "$node_(451) setdest 76167 20981 11.0" 
$ns at 743.7713861978629 "$node_(451) setdest 103005 10032 4.0" 
$ns at 813.6328026730916 "$node_(451) setdest 113622 22844 1.0" 
$ns at 850.0141997924683 "$node_(451) setdest 58405 16542 12.0" 
$ns at 474.117375551676 "$node_(452) setdest 49757 15229 10.0" 
$ns at 507.12643647810825 "$node_(452) setdest 50352 39452 8.0" 
$ns at 540.6967781104399 "$node_(452) setdest 79116 15418 18.0" 
$ns at 654.6617812296945 "$node_(452) setdest 49120 23506 20.0" 
$ns at 711.1601291895902 "$node_(452) setdest 118333 21444 19.0" 
$ns at 421.11611840834155 "$node_(453) setdest 23192 40776 7.0" 
$ns at 514.5568321344562 "$node_(453) setdest 12124 22174 1.0" 
$ns at 546.2479692967801 "$node_(453) setdest 77271 40283 16.0" 
$ns at 627.5444771898275 "$node_(453) setdest 68897 35372 1.0" 
$ns at 663.744551764067 "$node_(453) setdest 48767 42348 11.0" 
$ns at 754.2013657233618 "$node_(453) setdest 28651 23497 1.0" 
$ns at 784.250372964834 "$node_(453) setdest 73078 22910 4.0" 
$ns at 832.9243635396484 "$node_(453) setdest 27956 23083 16.0" 
$ns at 414.335570160031 "$node_(454) setdest 117556 26164 9.0" 
$ns at 474.4100515623817 "$node_(454) setdest 20701 10525 9.0" 
$ns at 535.831120351784 "$node_(454) setdest 12529 3189 8.0" 
$ns at 569.5980852648622 "$node_(454) setdest 119384 37200 12.0" 
$ns at 674.3876445902944 "$node_(454) setdest 130766 38810 2.0" 
$ns at 710.3665513407554 "$node_(454) setdest 128077 19835 13.0" 
$ns at 771.8647452994574 "$node_(454) setdest 132250 34529 10.0" 
$ns at 821.5936610105665 "$node_(454) setdest 43203 34532 13.0" 
$ns at 447.5093901479414 "$node_(455) setdest 24624 28848 1.0" 
$ns at 479.4175264860141 "$node_(455) setdest 53067 13354 19.0" 
$ns at 605.6508404757566 "$node_(455) setdest 123923 12991 18.0" 
$ns at 782.3294379358033 "$node_(455) setdest 28726 44616 12.0" 
$ns at 899.7589068015379 "$node_(455) setdest 18917 27840 7.0" 
$ns at 500.73961385990543 "$node_(456) setdest 72516 4985 18.0" 
$ns at 540.3016621075558 "$node_(456) setdest 49671 22418 17.0" 
$ns at 595.9319824707553 "$node_(456) setdest 4829 6735 16.0" 
$ns at 740.8004682203665 "$node_(456) setdest 24078 17182 1.0" 
$ns at 771.8952359778402 "$node_(456) setdest 113 25137 16.0" 
$ns at 874.0342132980473 "$node_(456) setdest 22637 19220 13.0" 
$ns at 486.10813808768756 "$node_(457) setdest 126389 41769 6.0" 
$ns at 539.8842261684076 "$node_(457) setdest 54242 11267 2.0" 
$ns at 582.4110847377464 "$node_(457) setdest 18935 13616 10.0" 
$ns at 642.5576074750664 "$node_(457) setdest 23767 19612 18.0" 
$ns at 833.1491435386386 "$node_(457) setdest 129827 17045 16.0" 
$ns at 537.6480307755463 "$node_(458) setdest 23433 34838 12.0" 
$ns at 634.6983598031928 "$node_(458) setdest 35746 24283 7.0" 
$ns at 674.2681509062546 "$node_(458) setdest 109219 10819 16.0" 
$ns at 728.0392118145464 "$node_(458) setdest 101275 14009 3.0" 
$ns at 770.7251651213365 "$node_(458) setdest 66741 10259 13.0" 
$ns at 857.3407115791297 "$node_(458) setdest 30319 8902 11.0" 
$ns at 434.96908300332933 "$node_(459) setdest 82515 13194 12.0" 
$ns at 490.983651169268 "$node_(459) setdest 41180 11755 14.0" 
$ns at 618.8075645352492 "$node_(459) setdest 79222 11764 13.0" 
$ns at 733.0493427432016 "$node_(459) setdest 13258 38577 14.0" 
$ns at 874.6285616205196 "$node_(459) setdest 127527 16863 2.0" 
$ns at 431.04750504719726 "$node_(460) setdest 39801 19067 10.0" 
$ns at 529.0003010103101 "$node_(460) setdest 38072 20046 14.0" 
$ns at 690.0490445588808 "$node_(460) setdest 29542 28534 13.0" 
$ns at 841.4646099893725 "$node_(460) setdest 32370 40057 8.0" 
$ns at 884.8999724498034 "$node_(460) setdest 108095 28004 2.0" 
$ns at 482.06666744213334 "$node_(461) setdest 117211 39687 20.0" 
$ns at 553.0947436444189 "$node_(461) setdest 65559 6171 3.0" 
$ns at 608.595742383804 "$node_(461) setdest 110400 26382 9.0" 
$ns at 693.2339777188089 "$node_(461) setdest 64372 37499 2.0" 
$ns at 736.7924308057703 "$node_(461) setdest 10553 28423 1.0" 
$ns at 769.2881497719426 "$node_(461) setdest 122376 7595 9.0" 
$ns at 871.6981358962893 "$node_(461) setdest 16516 18164 11.0" 
$ns at 436.06779248473634 "$node_(462) setdest 95957 36002 5.0" 
$ns at 491.1497832542629 "$node_(462) setdest 89196 6982 4.0" 
$ns at 532.3250139389135 "$node_(462) setdest 24743 3575 9.0" 
$ns at 635.0777660600647 "$node_(462) setdest 760 27197 2.0" 
$ns at 675.1281648442344 "$node_(462) setdest 87898 26142 9.0" 
$ns at 782.5735555033895 "$node_(462) setdest 7830 29441 19.0" 
$ns at 840.7293167794082 "$node_(462) setdest 42340 27799 18.0" 
$ns at 453.4790912071319 "$node_(463) setdest 66866 16797 13.0" 
$ns at 540.9864542856491 "$node_(463) setdest 9261 20968 8.0" 
$ns at 633.92348295659 "$node_(463) setdest 9391 25266 4.0" 
$ns at 676.6629260232842 "$node_(463) setdest 69740 31550 5.0" 
$ns at 727.0341679743341 "$node_(463) setdest 26926 9880 17.0" 
$ns at 777.0903938097553 "$node_(463) setdest 11527 5115 13.0" 
$ns at 453.64288231792557 "$node_(464) setdest 74158 7310 6.0" 
$ns at 507.9780282700698 "$node_(464) setdest 81868 22611 14.0" 
$ns at 552.7285805396746 "$node_(464) setdest 26390 17925 12.0" 
$ns at 657.808279049929 "$node_(464) setdest 68505 31909 7.0" 
$ns at 713.4832672664784 "$node_(464) setdest 7481 1829 16.0" 
$ns at 793.4320937530932 "$node_(464) setdest 77312 27793 19.0" 
$ns at 883.5401572623689 "$node_(464) setdest 30004 13165 17.0" 
$ns at 414.7925600858796 "$node_(465) setdest 81785 5433 18.0" 
$ns at 571.1175527771724 "$node_(465) setdest 60823 42868 12.0" 
$ns at 717.0237921759804 "$node_(465) setdest 16360 37482 10.0" 
$ns at 755.2438030142285 "$node_(465) setdest 34217 10061 18.0" 
$ns at 832.3930250947564 "$node_(465) setdest 29603 20676 11.0" 
$ns at 441.28359510872355 "$node_(466) setdest 45812 13584 14.0" 
$ns at 593.3451884854986 "$node_(466) setdest 83688 17979 6.0" 
$ns at 661.9051593562119 "$node_(466) setdest 37994 13687 1.0" 
$ns at 692.4488858608506 "$node_(466) setdest 93626 6681 13.0" 
$ns at 797.9358058592177 "$node_(466) setdest 119654 14413 13.0" 
$ns at 404.52388062645736 "$node_(467) setdest 69233 23958 18.0" 
$ns at 544.1617408680069 "$node_(467) setdest 10204 11164 1.0" 
$ns at 582.0282142369307 "$node_(467) setdest 48139 8484 9.0" 
$ns at 645.910636916951 "$node_(467) setdest 38190 33249 7.0" 
$ns at 704.3569653393621 "$node_(467) setdest 4372 26636 2.0" 
$ns at 741.7893045386696 "$node_(467) setdest 44558 43317 7.0" 
$ns at 825.5578869232609 "$node_(467) setdest 58973 43442 15.0" 
$ns at 894.2981041998294 "$node_(467) setdest 115485 3262 15.0" 
$ns at 415.359043824581 "$node_(468) setdest 54060 33751 20.0" 
$ns at 632.7769678371087 "$node_(468) setdest 81442 26798 7.0" 
$ns at 674.5441731563517 "$node_(468) setdest 46484 35356 5.0" 
$ns at 710.7314328242361 "$node_(468) setdest 113280 31644 1.0" 
$ns at 749.497480522376 "$node_(468) setdest 9275 17398 6.0" 
$ns at 836.1951824682496 "$node_(468) setdest 90897 17083 3.0" 
$ns at 892.9225373892026 "$node_(468) setdest 127816 4222 3.0" 
$ns at 560.2984078942736 "$node_(469) setdest 3287 9273 14.0" 
$ns at 692.9845202326328 "$node_(469) setdest 60922 9594 4.0" 
$ns at 743.4516933583647 "$node_(469) setdest 93741 33356 3.0" 
$ns at 791.8261675341719 "$node_(469) setdest 32883 2807 11.0" 
$ns at 845.417056364208 "$node_(469) setdest 103087 6645 13.0" 
$ns at 462.0859730945981 "$node_(470) setdest 88589 32625 6.0" 
$ns at 512.1289564270805 "$node_(470) setdest 109726 21588 1.0" 
$ns at 550.0492573050484 "$node_(470) setdest 23085 18936 5.0" 
$ns at 593.1824046000896 "$node_(470) setdest 117214 9746 10.0" 
$ns at 626.81492150486 "$node_(470) setdest 121156 10113 4.0" 
$ns at 657.1597916286612 "$node_(470) setdest 62833 27987 2.0" 
$ns at 690.6337765328077 "$node_(470) setdest 83617 21785 12.0" 
$ns at 780.9105699443002 "$node_(470) setdest 31803 8812 13.0" 
$ns at 855.3023414931081 "$node_(470) setdest 10567 12142 8.0" 
$ns at 890.383047785502 "$node_(470) setdest 42106 17315 9.0" 
$ns at 412.9479760051026 "$node_(471) setdest 36707 36737 3.0" 
$ns at 452.63594716516656 "$node_(471) setdest 36410 30343 9.0" 
$ns at 496.26643877896504 "$node_(471) setdest 91246 38004 11.0" 
$ns at 570.8255260927026 "$node_(471) setdest 7320 36679 17.0" 
$ns at 732.2414163951703 "$node_(471) setdest 62865 39903 4.0" 
$ns at 764.3763073713382 "$node_(471) setdest 54769 83 18.0" 
$ns at 877.3982207882673 "$node_(471) setdest 11620 40564 10.0" 
$ns at 543.6443678270797 "$node_(472) setdest 11305 9612 1.0" 
$ns at 576.5406712995709 "$node_(472) setdest 65647 36802 3.0" 
$ns at 612.403544998724 "$node_(472) setdest 112210 23574 1.0" 
$ns at 646.9871858759219 "$node_(472) setdest 79790 41628 13.0" 
$ns at 760.8934121192614 "$node_(472) setdest 15533 35838 17.0" 
$ns at 809.9840837198253 "$node_(472) setdest 3935 17826 16.0" 
$ns at 410.6927733972367 "$node_(473) setdest 100708 42363 6.0" 
$ns at 450.6058820989883 "$node_(473) setdest 76030 20417 19.0" 
$ns at 668.2957691061545 "$node_(473) setdest 78377 26283 4.0" 
$ns at 733.8235104322523 "$node_(473) setdest 12650 10152 1.0" 
$ns at 766.0777505859805 "$node_(473) setdest 124804 38175 13.0" 
$ns at 877.4856748212525 "$node_(473) setdest 76392 36458 14.0" 
$ns at 524.1081084649423 "$node_(474) setdest 43572 26499 16.0" 
$ns at 670.4652996419775 "$node_(474) setdest 101415 32668 8.0" 
$ns at 778.4500657075475 "$node_(474) setdest 62154 5462 19.0" 
$ns at 857.1377401914577 "$node_(474) setdest 22783 38734 8.0" 
$ns at 447.9309832726481 "$node_(475) setdest 16974 15410 8.0" 
$ns at 510.7721391380422 "$node_(475) setdest 5641 43799 14.0" 
$ns at 628.4188231485823 "$node_(475) setdest 63474 12463 7.0" 
$ns at 691.6242525946697 "$node_(475) setdest 109379 35009 2.0" 
$ns at 729.5941947823211 "$node_(475) setdest 38623 41206 2.0" 
$ns at 770.3311419914061 "$node_(475) setdest 56355 17514 3.0" 
$ns at 819.4214237760458 "$node_(475) setdest 78131 33398 12.0" 
$ns at 456.1655215885095 "$node_(476) setdest 114776 35090 18.0" 
$ns at 536.4551215318395 "$node_(476) setdest 12757 6680 11.0" 
$ns at 578.906367667704 "$node_(476) setdest 119328 10823 7.0" 
$ns at 640.2159533006384 "$node_(476) setdest 107992 1631 16.0" 
$ns at 672.3640468779795 "$node_(476) setdest 73422 21055 8.0" 
$ns at 727.4210368119797 "$node_(476) setdest 77687 10596 19.0" 
$ns at 469.2073495687426 "$node_(477) setdest 43226 24570 7.0" 
$ns at 549.5540607037507 "$node_(477) setdest 24415 14410 4.0" 
$ns at 585.1576991628974 "$node_(477) setdest 14265 20105 8.0" 
$ns at 678.0146770105987 "$node_(477) setdest 91175 6335 2.0" 
$ns at 714.9398379131144 "$node_(477) setdest 46283 31445 1.0" 
$ns at 748.989748980138 "$node_(477) setdest 21271 9136 18.0" 
$ns at 427.6839662184126 "$node_(478) setdest 71819 30765 10.0" 
$ns at 514.7705177769745 "$node_(478) setdest 109005 15360 19.0" 
$ns at 565.4910274657883 "$node_(478) setdest 13604 37775 14.0" 
$ns at 709.669653446698 "$node_(478) setdest 110935 26486 11.0" 
$ns at 842.4071575513998 "$node_(478) setdest 908 5712 1.0" 
$ns at 878.9405383386935 "$node_(478) setdest 133660 27125 5.0" 
$ns at 516.9038595827842 "$node_(479) setdest 85346 11103 11.0" 
$ns at 614.1285795397471 "$node_(479) setdest 22134 22240 17.0" 
$ns at 649.1249301531412 "$node_(479) setdest 1300 39377 12.0" 
$ns at 709.8801782992642 "$node_(479) setdest 1642 35318 19.0" 
$ns at 887.4682909422497 "$node_(479) setdest 132459 8858 2.0" 
$ns at 446.124944739939 "$node_(480) setdest 108769 7788 1.0" 
$ns at 478.6139890311563 "$node_(480) setdest 29141 8133 1.0" 
$ns at 516.5946869531341 "$node_(480) setdest 64698 16514 10.0" 
$ns at 583.785206099983 "$node_(480) setdest 17492 25909 6.0" 
$ns at 652.0153522963662 "$node_(480) setdest 92468 36659 1.0" 
$ns at 688.171506676285 "$node_(480) setdest 31054 26365 18.0" 
$ns at 722.0704207723107 "$node_(480) setdest 26218 33058 15.0" 
$ns at 810.3660341115963 "$node_(480) setdest 105816 40817 1.0" 
$ns at 849.4714899422117 "$node_(480) setdest 25706 35367 14.0" 
$ns at 428.9399716097652 "$node_(481) setdest 80041 18274 20.0" 
$ns at 463.07717876985873 "$node_(481) setdest 8890 6550 1.0" 
$ns at 497.217584734036 "$node_(481) setdest 97695 6254 9.0" 
$ns at 539.2002180698937 "$node_(481) setdest 121075 10438 14.0" 
$ns at 681.7492315244937 "$node_(481) setdest 96812 13319 14.0" 
$ns at 820.5491725672405 "$node_(481) setdest 85772 17067 3.0" 
$ns at 854.9755976482265 "$node_(481) setdest 58939 40440 19.0" 
$ns at 524.7358235592114 "$node_(482) setdest 21891 17655 16.0" 
$ns at 628.9564683867804 "$node_(482) setdest 130783 3374 9.0" 
$ns at 730.479270980237 "$node_(482) setdest 4962 28740 6.0" 
$ns at 779.9717084145889 "$node_(482) setdest 23838 38633 16.0" 
$ns at 813.0781408214945 "$node_(482) setdest 113575 14898 8.0" 
$ns at 502.6783098727859 "$node_(483) setdest 115709 34934 14.0" 
$ns at 643.1167253299587 "$node_(483) setdest 78168 30028 20.0" 
$ns at 767.1778331252028 "$node_(483) setdest 129040 7031 6.0" 
$ns at 810.5190540240704 "$node_(483) setdest 75428 35636 17.0" 
$ns at 416.76629343056777 "$node_(484) setdest 36733 29745 14.0" 
$ns at 579.0025728511833 "$node_(484) setdest 132889 31417 14.0" 
$ns at 641.4753967972513 "$node_(484) setdest 107874 22489 1.0" 
$ns at 674.8828906915212 "$node_(484) setdest 23750 19914 1.0" 
$ns at 711.9768690128295 "$node_(484) setdest 94117 16614 12.0" 
$ns at 766.8768885890031 "$node_(484) setdest 81198 39259 12.0" 
$ns at 830.9961527150708 "$node_(484) setdest 62684 6683 15.0" 
$ns at 450.5855119824644 "$node_(485) setdest 25181 4242 16.0" 
$ns at 628.7709557353263 "$node_(485) setdest 82956 10691 12.0" 
$ns at 673.5929516539175 "$node_(485) setdest 76327 17516 9.0" 
$ns at 784.4956787086893 "$node_(485) setdest 129161 21480 16.0" 
$ns at 432.7674040509091 "$node_(486) setdest 25450 10726 14.0" 
$ns at 490.8176241611195 "$node_(486) setdest 38286 30996 16.0" 
$ns at 616.8958007463524 "$node_(486) setdest 79068 38595 16.0" 
$ns at 794.9655205287829 "$node_(486) setdest 88009 2824 5.0" 
$ns at 837.6940234665835 "$node_(486) setdest 131454 32596 7.0" 
$ns at 415.45490131757754 "$node_(487) setdest 133380 9206 2.0" 
$ns at 457.4013293543264 "$node_(487) setdest 124408 29939 1.0" 
$ns at 488.05859750556056 "$node_(487) setdest 102833 26991 4.0" 
$ns at 530.0259679482092 "$node_(487) setdest 11622 13782 15.0" 
$ns at 660.9330232513807 "$node_(487) setdest 63211 9655 14.0" 
$ns at 727.5034298688429 "$node_(487) setdest 56559 18498 1.0" 
$ns at 764.4143162131018 "$node_(487) setdest 112062 14597 17.0" 
$ns at 879.5828573847692 "$node_(487) setdest 55692 34203 6.0" 
$ns at 444.74801532585457 "$node_(488) setdest 96880 24430 15.0" 
$ns at 599.5899613290751 "$node_(488) setdest 44476 26498 2.0" 
$ns at 633.3343370476975 "$node_(488) setdest 78910 25130 3.0" 
$ns at 675.4405556667477 "$node_(488) setdest 16140 9555 16.0" 
$ns at 803.450678119804 "$node_(488) setdest 82160 32738 8.0" 
$ns at 863.9048011783866 "$node_(488) setdest 9698 12574 7.0" 
$ns at 454.72669560583427 "$node_(489) setdest 96700 35759 1.0" 
$ns at 491.88691051813856 "$node_(489) setdest 123831 2297 13.0" 
$ns at 572.6270674601635 "$node_(489) setdest 51992 32067 8.0" 
$ns at 651.8900517598573 "$node_(489) setdest 102883 33894 10.0" 
$ns at 711.4397852991393 "$node_(489) setdest 19800 5967 2.0" 
$ns at 742.0561149547194 "$node_(489) setdest 122965 7368 6.0" 
$ns at 784.0591818851134 "$node_(489) setdest 19557 12616 9.0" 
$ns at 849.1323515217041 "$node_(489) setdest 114406 24059 16.0" 
$ns at 428.1151715132948 "$node_(490) setdest 107387 4982 3.0" 
$ns at 463.6021033035736 "$node_(490) setdest 102023 28411 11.0" 
$ns at 540.7430387474144 "$node_(490) setdest 38732 3575 2.0" 
$ns at 583.085915935998 "$node_(490) setdest 35322 13984 11.0" 
$ns at 658.203863102513 "$node_(490) setdest 26846 34193 12.0" 
$ns at 733.6851726684529 "$node_(490) setdest 124428 14871 2.0" 
$ns at 766.1180830063374 "$node_(490) setdest 55217 10755 4.0" 
$ns at 800.9036839530497 "$node_(490) setdest 100185 33538 7.0" 
$ns at 852.3581635010437 "$node_(490) setdest 85857 19450 9.0" 
$ns at 891.0312650512277 "$node_(490) setdest 126717 32147 11.0" 
$ns at 451.85897364247603 "$node_(491) setdest 88633 33766 9.0" 
$ns at 539.544650263394 "$node_(491) setdest 102363 22719 3.0" 
$ns at 580.5810359211239 "$node_(491) setdest 41517 39063 19.0" 
$ns at 687.3227129879764 "$node_(491) setdest 59376 1623 4.0" 
$ns at 751.2565160070365 "$node_(491) setdest 16249 32938 9.0" 
$ns at 857.4974478982188 "$node_(491) setdest 112829 25089 13.0" 
$ns at 446.1436574353326 "$node_(492) setdest 82391 41447 1.0" 
$ns at 478.05275240992813 "$node_(492) setdest 5327 41026 18.0" 
$ns at 647.0505789220108 "$node_(492) setdest 5314 1355 7.0" 
$ns at 743.3235163526057 "$node_(492) setdest 126769 44326 8.0" 
$ns at 824.7297796813898 "$node_(492) setdest 52222 17323 7.0" 
$ns at 857.8126384836083 "$node_(492) setdest 99860 8703 12.0" 
$ns at 465.86593588093194 "$node_(493) setdest 90413 20702 13.0" 
$ns at 496.06367347091106 "$node_(493) setdest 37175 13514 14.0" 
$ns at 637.5258846809586 "$node_(493) setdest 23929 33693 3.0" 
$ns at 684.7398374910516 "$node_(493) setdest 72516 41408 1.0" 
$ns at 723.7418649180865 "$node_(493) setdest 106908 43426 9.0" 
$ns at 837.1340946939473 "$node_(493) setdest 69135 17229 6.0" 
$ns at 442.3680128111559 "$node_(494) setdest 47225 32825 1.0" 
$ns at 476.2420190252958 "$node_(494) setdest 54388 38967 3.0" 
$ns at 536.2218490763634 "$node_(494) setdest 93949 28631 4.0" 
$ns at 567.4434659735693 "$node_(494) setdest 109350 2975 17.0" 
$ns at 641.5979099387964 "$node_(494) setdest 4074 43217 9.0" 
$ns at 706.4689471243821 "$node_(494) setdest 91170 26982 6.0" 
$ns at 791.9163454664279 "$node_(494) setdest 80350 8209 2.0" 
$ns at 827.9877035584234 "$node_(494) setdest 96104 33300 11.0" 
$ns at 859.6707737723522 "$node_(494) setdest 59889 28280 12.0" 
$ns at 409.2343595843601 "$node_(495) setdest 119531 4172 6.0" 
$ns at 478.46335808214644 "$node_(495) setdest 28233 5993 18.0" 
$ns at 641.3781941311981 "$node_(495) setdest 48237 28162 15.0" 
$ns at 732.9862125152547 "$node_(495) setdest 103630 2212 9.0" 
$ns at 810.2320557974966 "$node_(495) setdest 110859 16635 19.0" 
$ns at 850.6108843517165 "$node_(495) setdest 53523 15050 16.0" 
$ns at 406.6422691299268 "$node_(496) setdest 37869 23136 13.0" 
$ns at 447.4763985843598 "$node_(496) setdest 123310 12144 11.0" 
$ns at 487.3763595941815 "$node_(496) setdest 12704 30554 19.0" 
$ns at 647.4892891430061 "$node_(496) setdest 20638 35420 3.0" 
$ns at 706.0331239010591 "$node_(496) setdest 34846 2381 1.0" 
$ns at 742.9941774470988 "$node_(496) setdest 120614 20134 8.0" 
$ns at 821.4837292415029 "$node_(496) setdest 7879 38369 5.0" 
$ns at 895.3736468561225 "$node_(496) setdest 120652 29304 7.0" 
$ns at 534.6622256896526 "$node_(497) setdest 66649 39908 3.0" 
$ns at 584.138988015568 "$node_(497) setdest 36076 21854 14.0" 
$ns at 621.6919705535734 "$node_(497) setdest 56447 9979 19.0" 
$ns at 819.4961758691917 "$node_(497) setdest 15455 6755 19.0" 
$ns at 448.56227791335283 "$node_(498) setdest 39798 10857 10.0" 
$ns at 557.8124318283752 "$node_(498) setdest 113037 36662 8.0" 
$ns at 640.7345300111209 "$node_(498) setdest 37850 29911 1.0" 
$ns at 677.2956210429786 "$node_(498) setdest 65283 36970 12.0" 
$ns at 741.1257958352296 "$node_(498) setdest 49452 3520 1.0" 
$ns at 779.3338090607649 "$node_(498) setdest 129893 26382 1.0" 
$ns at 811.6612597082259 "$node_(498) setdest 14588 18553 6.0" 
$ns at 882.4378312427579 "$node_(498) setdest 12096 42807 2.0" 
$ns at 430.47321124066764 "$node_(499) setdest 60515 28363 4.0" 
$ns at 473.5931011645086 "$node_(499) setdest 92870 10581 2.0" 
$ns at 517.9876102732308 "$node_(499) setdest 128566 6045 6.0" 
$ns at 602.9005423534294 "$node_(499) setdest 58034 6948 5.0" 
$ns at 668.947683524865 "$node_(499) setdest 113160 11215 3.0" 
$ns at 709.1336726659002 "$node_(499) setdest 69402 5623 15.0" 
$ns at 883.7073332397772 "$node_(499) setdest 66079 21840 5.0" 
$ns at 536.7192292279462 "$node_(500) setdest 13320 12237 12.0" 
$ns at 576.984986483022 "$node_(500) setdest 48523 34656 6.0" 
$ns at 649.0879805856581 "$node_(500) setdest 61626 1516 7.0" 
$ns at 739.145524624172 "$node_(500) setdest 25132 42480 7.0" 
$ns at 777.3597667149356 "$node_(500) setdest 110787 18112 17.0" 
$ns at 885.7713277312824 "$node_(500) setdest 73827 24159 16.0" 
$ns at 632.9646298064908 "$node_(501) setdest 104425 21837 19.0" 
$ns at 694.1648791834356 "$node_(501) setdest 49094 40508 17.0" 
$ns at 763.0763321036742 "$node_(501) setdest 81056 43352 16.0" 
$ns at 894.9047582852365 "$node_(501) setdest 82811 21521 1.0" 
$ns at 555.532833792646 "$node_(502) setdest 43850 14937 12.0" 
$ns at 611.2497552706659 "$node_(502) setdest 53266 6713 18.0" 
$ns at 701.3590567863127 "$node_(502) setdest 56245 20885 10.0" 
$ns at 793.6756409903784 "$node_(502) setdest 19215 43138 3.0" 
$ns at 824.5537411597335 "$node_(502) setdest 92044 34254 1.0" 
$ns at 861.5835650203722 "$node_(502) setdest 101957 9226 20.0" 
$ns at 543.8876388679754 "$node_(503) setdest 52917 5531 2.0" 
$ns at 581.9272703805497 "$node_(503) setdest 108749 42744 9.0" 
$ns at 663.6695811617897 "$node_(503) setdest 77771 39401 3.0" 
$ns at 701.4807003741691 "$node_(503) setdest 44048 25531 12.0" 
$ns at 794.3227193253517 "$node_(503) setdest 127601 14618 8.0" 
$ns at 875.3604061917732 "$node_(503) setdest 109996 18757 5.0" 
$ns at 683.556121627988 "$node_(504) setdest 3253 40701 6.0" 
$ns at 742.4561165297564 "$node_(504) setdest 58992 4670 20.0" 
$ns at 560.1304520516258 "$node_(505) setdest 98735 35354 13.0" 
$ns at 612.6291498904214 "$node_(505) setdest 131911 8541 5.0" 
$ns at 692.0773375563522 "$node_(505) setdest 120560 39079 7.0" 
$ns at 787.1925145383443 "$node_(505) setdest 63820 18774 3.0" 
$ns at 844.4089203143994 "$node_(505) setdest 31908 32590 14.0" 
$ns at 526.7834582455756 "$node_(506) setdest 20810 24391 8.0" 
$ns at 620.775392351438 "$node_(506) setdest 37135 1590 9.0" 
$ns at 675.5556669412284 "$node_(506) setdest 64752 41600 10.0" 
$ns at 711.3175106905467 "$node_(506) setdest 107199 31650 11.0" 
$ns at 793.1111648156025 "$node_(506) setdest 99410 15929 15.0" 
$ns at 525.2202879498433 "$node_(507) setdest 35846 39326 8.0" 
$ns at 601.7455966364041 "$node_(507) setdest 101240 34888 19.0" 
$ns at 709.3245132224995 "$node_(507) setdest 69948 9104 19.0" 
$ns at 857.7607424319791 "$node_(507) setdest 34572 35280 17.0" 
$ns at 572.6383231920844 "$node_(508) setdest 130179 27445 1.0" 
$ns at 605.2650733633512 "$node_(508) setdest 133607 30476 1.0" 
$ns at 637.3314571790742 "$node_(508) setdest 49512 9172 2.0" 
$ns at 669.6974872433939 "$node_(508) setdest 53736 5010 10.0" 
$ns at 759.5845141210265 "$node_(508) setdest 41178 16744 16.0" 
$ns at 822.2328272464483 "$node_(508) setdest 121878 19197 11.0" 
$ns at 606.6302894342018 "$node_(509) setdest 90808 40367 14.0" 
$ns at 699.6604496862547 "$node_(509) setdest 103830 17058 5.0" 
$ns at 769.334004182185 "$node_(509) setdest 52548 37766 15.0" 
$ns at 573.570765793093 "$node_(510) setdest 26776 19870 10.0" 
$ns at 635.5962088373741 "$node_(510) setdest 15740 24610 1.0" 
$ns at 670.2889462008599 "$node_(510) setdest 98203 28915 17.0" 
$ns at 717.1087198396297 "$node_(510) setdest 42266 31673 11.0" 
$ns at 798.3520500633697 "$node_(510) setdest 81188 5287 9.0" 
$ns at 867.1468550088134 "$node_(510) setdest 86102 10316 14.0" 
$ns at 535.9423957966502 "$node_(511) setdest 13540 32386 5.0" 
$ns at 582.4296573601748 "$node_(511) setdest 120158 27937 3.0" 
$ns at 636.2407576599365 "$node_(511) setdest 125382 38775 6.0" 
$ns at 718.5194970778288 "$node_(511) setdest 39640 29887 11.0" 
$ns at 757.9288575888422 "$node_(511) setdest 68658 21844 1.0" 
$ns at 795.8966200556667 "$node_(511) setdest 69810 26504 13.0" 
$ns at 869.4792548805099 "$node_(511) setdest 64913 19112 2.0" 
$ns at 524.3275883934684 "$node_(512) setdest 57463 11154 18.0" 
$ns at 632.6652692285887 "$node_(512) setdest 118497 11157 1.0" 
$ns at 672.0571064402762 "$node_(512) setdest 104437 39908 14.0" 
$ns at 747.607077995558 "$node_(512) setdest 5688 17191 6.0" 
$ns at 827.4041344691184 "$node_(512) setdest 126888 41253 9.0" 
$ns at 657.2291096874944 "$node_(513) setdest 63205 17663 1.0" 
$ns at 694.9814292370697 "$node_(513) setdest 39732 9166 13.0" 
$ns at 735.118517430991 "$node_(513) setdest 134082 14372 5.0" 
$ns at 776.143065345834 "$node_(513) setdest 64508 6460 19.0" 
$ns at 658.2544876001773 "$node_(514) setdest 113289 17419 17.0" 
$ns at 709.8411877312905 "$node_(514) setdest 94506 5543 9.0" 
$ns at 811.0563318661655 "$node_(514) setdest 12318 3525 1.0" 
$ns at 843.1590218645981 "$node_(514) setdest 23914 39852 8.0" 
$ns at 875.6882694459063 "$node_(514) setdest 75314 10133 12.0" 
$ns at 583.4289660524325 "$node_(515) setdest 59087 25031 11.0" 
$ns at 632.4090140532563 "$node_(515) setdest 57158 9917 14.0" 
$ns at 777.6506010754442 "$node_(515) setdest 16256 19717 13.0" 
$ns at 861.4737187139373 "$node_(515) setdest 11405 43936 8.0" 
$ns at 559.342407905168 "$node_(516) setdest 101804 4638 2.0" 
$ns at 590.9655568305744 "$node_(516) setdest 37461 10965 5.0" 
$ns at 670.2997360939481 "$node_(516) setdest 69345 10328 9.0" 
$ns at 704.0808651292436 "$node_(516) setdest 53592 9816 19.0" 
$ns at 800.6944872156774 "$node_(516) setdest 119623 32331 14.0" 
$ns at 861.3984270524799 "$node_(516) setdest 24203 8434 6.0" 
$ns at 528.4972092313789 "$node_(517) setdest 67258 22011 15.0" 
$ns at 591.7878021835104 "$node_(517) setdest 20111 24546 2.0" 
$ns at 629.9747799662273 "$node_(517) setdest 101748 10428 2.0" 
$ns at 670.7460195214369 "$node_(517) setdest 48730 4079 13.0" 
$ns at 750.7825830373547 "$node_(517) setdest 36145 21341 16.0" 
$ns at 844.5011274321078 "$node_(517) setdest 99019 814 5.0" 
$ns at 620.3151266619786 "$node_(518) setdest 18807 2875 3.0" 
$ns at 664.1748060111494 "$node_(518) setdest 75836 21702 10.0" 
$ns at 730.6600013004092 "$node_(518) setdest 37218 9647 10.0" 
$ns at 856.6292357848333 "$node_(518) setdest 96652 32613 17.0" 
$ns at 516.102756511677 "$node_(519) setdest 107557 7931 10.0" 
$ns at 576.7053037878552 "$node_(519) setdest 68504 17212 5.0" 
$ns at 621.8630051143506 "$node_(519) setdest 119574 22616 5.0" 
$ns at 674.3181145985981 "$node_(519) setdest 115334 3264 13.0" 
$ns at 733.2583546717011 "$node_(519) setdest 119090 791 8.0" 
$ns at 769.20178904501 "$node_(519) setdest 28555 18706 1.0" 
$ns at 804.2261956025038 "$node_(519) setdest 130493 12569 4.0" 
$ns at 837.55771935978 "$node_(519) setdest 83367 24209 15.0" 
$ns at 868.5236260245885 "$node_(519) setdest 116602 16171 3.0" 
$ns at 506.20590797089403 "$node_(520) setdest 73359 39837 3.0" 
$ns at 555.0691394411044 "$node_(520) setdest 16148 25998 8.0" 
$ns at 596.3951178438213 "$node_(520) setdest 37939 21957 2.0" 
$ns at 644.9114560168401 "$node_(520) setdest 108075 245 16.0" 
$ns at 708.751073174648 "$node_(520) setdest 34048 4064 7.0" 
$ns at 804.6332678432487 "$node_(520) setdest 120650 35876 14.0" 
$ns at 548.1385133214537 "$node_(521) setdest 32679 27526 16.0" 
$ns at 646.9259114328573 "$node_(521) setdest 12810 26212 13.0" 
$ns at 692.3691661807097 "$node_(521) setdest 115536 40528 2.0" 
$ns at 742.3296947594104 "$node_(521) setdest 72119 7447 1.0" 
$ns at 780.4871805712806 "$node_(521) setdest 11258 6206 10.0" 
$ns at 846.3625648879179 "$node_(521) setdest 47172 1398 11.0" 
$ns at 520.7398696597168 "$node_(522) setdest 115967 31008 7.0" 
$ns at 564.8647802623912 "$node_(522) setdest 48756 6916 16.0" 
$ns at 714.0862286343638 "$node_(522) setdest 83679 44027 11.0" 
$ns at 815.9221208511084 "$node_(522) setdest 946 9591 18.0" 
$ns at 642.1515939718496 "$node_(523) setdest 66720 23786 17.0" 
$ns at 730.8705537763635 "$node_(523) setdest 75133 35394 9.0" 
$ns at 808.6371237115388 "$node_(523) setdest 5757 14890 2.0" 
$ns at 850.3807249981738 "$node_(523) setdest 115888 35726 8.0" 
$ns at 599.279848806363 "$node_(524) setdest 90474 7615 10.0" 
$ns at 641.6591461007889 "$node_(524) setdest 102819 42858 18.0" 
$ns at 721.312914298939 "$node_(524) setdest 63381 9257 18.0" 
$ns at 836.4012686706883 "$node_(524) setdest 123310 6179 5.0" 
$ns at 873.906364096628 "$node_(524) setdest 22608 9564 2.0" 
$ns at 502.3075280747652 "$node_(525) setdest 36955 5246 11.0" 
$ns at 588.110955297966 "$node_(525) setdest 110892 41889 1.0" 
$ns at 620.8490158579729 "$node_(525) setdest 5867 13456 20.0" 
$ns at 825.1538222741133 "$node_(525) setdest 55536 27154 7.0" 
$ns at 547.6749254476656 "$node_(526) setdest 83090 12139 14.0" 
$ns at 681.2690952299201 "$node_(526) setdest 75939 36768 3.0" 
$ns at 711.4911974315706 "$node_(526) setdest 3510 5571 1.0" 
$ns at 751.3310728407953 "$node_(526) setdest 51428 5971 6.0" 
$ns at 809.9720938902427 "$node_(526) setdest 21465 33571 8.0" 
$ns at 870.4257084223766 "$node_(526) setdest 110272 35368 12.0" 
$ns at 539.7434802721214 "$node_(527) setdest 95182 31503 15.0" 
$ns at 639.1360322443621 "$node_(527) setdest 120806 29664 14.0" 
$ns at 719.1774639674596 "$node_(527) setdest 103654 10749 5.0" 
$ns at 796.9290030995221 "$node_(527) setdest 67268 29515 17.0" 
$ns at 610.6804883247961 "$node_(528) setdest 93050 36844 11.0" 
$ns at 680.0264404928257 "$node_(528) setdest 22635 16866 1.0" 
$ns at 719.4246678921656 "$node_(528) setdest 20989 11399 13.0" 
$ns at 869.711883805297 "$node_(528) setdest 15495 40747 7.0" 
$ns at 512.7016361587979 "$node_(529) setdest 77789 1708 11.0" 
$ns at 651.5608283323145 "$node_(529) setdest 35840 29651 20.0" 
$ns at 838.956641828662 "$node_(529) setdest 84997 32034 11.0" 
$ns at 643.0013025109781 "$node_(530) setdest 88042 23973 5.0" 
$ns at 682.087051689982 "$node_(530) setdest 131808 27363 18.0" 
$ns at 715.2102881979853 "$node_(530) setdest 21904 41731 13.0" 
$ns at 783.450997117315 "$node_(530) setdest 97403 12921 1.0" 
$ns at 814.3820901116267 "$node_(530) setdest 23908 18962 2.0" 
$ns at 864.2482484664075 "$node_(530) setdest 56074 38706 12.0" 
$ns at 550.3766874723473 "$node_(531) setdest 114426 43143 19.0" 
$ns at 599.1121216983881 "$node_(531) setdest 36042 24310 10.0" 
$ns at 647.0503035960431 "$node_(531) setdest 24120 19421 3.0" 
$ns at 701.4790098293905 "$node_(531) setdest 120172 37318 1.0" 
$ns at 739.3806483992323 "$node_(531) setdest 48237 20853 1.0" 
$ns at 773.9541340334604 "$node_(531) setdest 35318 43068 10.0" 
$ns at 842.3998487085972 "$node_(531) setdest 120796 28319 6.0" 
$ns at 877.6263801254328 "$node_(531) setdest 26023 26666 11.0" 
$ns at 557.3794943761199 "$node_(532) setdest 805 5534 15.0" 
$ns at 700.4175558143913 "$node_(532) setdest 133840 2156 11.0" 
$ns at 757.5069104140712 "$node_(532) setdest 50254 13142 4.0" 
$ns at 813.8850201450962 "$node_(532) setdest 24948 20397 2.0" 
$ns at 860.495087995304 "$node_(532) setdest 124384 10670 14.0" 
$ns at 574.9941247120603 "$node_(533) setdest 44010 19 4.0" 
$ns at 610.6627934486564 "$node_(533) setdest 94761 17080 16.0" 
$ns at 714.9313979244246 "$node_(533) setdest 54391 4009 17.0" 
$ns at 753.006321388861 "$node_(533) setdest 119595 35361 9.0" 
$ns at 806.0759188917934 "$node_(533) setdest 43247 18711 15.0" 
$ns at 896.3150032799817 "$node_(533) setdest 22489 18999 10.0" 
$ns at 538.9969432606343 "$node_(534) setdest 11403 22568 9.0" 
$ns at 632.0574363667081 "$node_(534) setdest 81277 23810 13.0" 
$ns at 676.633670844476 "$node_(534) setdest 12065 26791 4.0" 
$ns at 725.4036194476016 "$node_(534) setdest 120726 9736 15.0" 
$ns at 796.2825206182542 "$node_(534) setdest 78300 19361 8.0" 
$ns at 890.2116773474429 "$node_(534) setdest 26725 18693 1.0" 
$ns at 533.4494033959338 "$node_(535) setdest 126365 9869 7.0" 
$ns at 609.2996365442901 "$node_(535) setdest 118711 11562 15.0" 
$ns at 643.0321773288241 "$node_(535) setdest 112918 35872 6.0" 
$ns at 677.3980133650667 "$node_(535) setdest 16732 17859 2.0" 
$ns at 727.0352869071737 "$node_(535) setdest 35239 13416 16.0" 
$ns at 759.3174477852024 "$node_(535) setdest 91470 8 11.0" 
$ns at 829.544914322281 "$node_(535) setdest 91601 24100 3.0" 
$ns at 872.7508585386583 "$node_(535) setdest 29092 22996 20.0" 
$ns at 555.1223440143397 "$node_(536) setdest 96996 41672 1.0" 
$ns at 588.1896601513506 "$node_(536) setdest 8392 17700 14.0" 
$ns at 627.0794517056125 "$node_(536) setdest 20478 22071 18.0" 
$ns at 817.9542940276694 "$node_(536) setdest 123283 23308 9.0" 
$ns at 888.2879051441239 "$node_(536) setdest 27664 44368 1.0" 
$ns at 636.96108507915 "$node_(537) setdest 23805 31510 16.0" 
$ns at 749.7695909863301 "$node_(537) setdest 50235 39427 14.0" 
$ns at 843.3087030952039 "$node_(537) setdest 133335 13327 6.0" 
$ns at 880.8657184012756 "$node_(537) setdest 130239 15040 12.0" 
$ns at 530.4170824495541 "$node_(538) setdest 63582 32860 4.0" 
$ns at 598.5058443984962 "$node_(538) setdest 87570 25929 4.0" 
$ns at 663.3763241514831 "$node_(538) setdest 86773 25856 10.0" 
$ns at 742.8743921832729 "$node_(538) setdest 85787 31518 10.0" 
$ns at 815.2325376242095 "$node_(538) setdest 91096 30884 17.0" 
$ns at 537.0644446942897 "$node_(539) setdest 33460 40527 16.0" 
$ns at 619.6080628427 "$node_(539) setdest 24723 24350 1.0" 
$ns at 651.4872875175695 "$node_(539) setdest 89769 16522 6.0" 
$ns at 725.1250996379533 "$node_(539) setdest 51190 1726 13.0" 
$ns at 790.5366651518946 "$node_(539) setdest 93349 4321 12.0" 
$ns at 865.5563261538402 "$node_(539) setdest 133769 40158 5.0" 
$ns at 555.6910576196569 "$node_(540) setdest 29108 37451 9.0" 
$ns at 611.5925858306764 "$node_(540) setdest 1333 18270 19.0" 
$ns at 810.8728028377416 "$node_(540) setdest 99666 39878 5.0" 
$ns at 859.9550242407038 "$node_(540) setdest 53514 5516 1.0" 
$ns at 899.4924300436053 "$node_(540) setdest 125933 13663 15.0" 
$ns at 553.1299168854678 "$node_(541) setdest 7226 10760 8.0" 
$ns at 623.1736454929295 "$node_(541) setdest 58631 29007 1.0" 
$ns at 654.6445931519027 "$node_(541) setdest 128283 44065 8.0" 
$ns at 763.3252350227187 "$node_(541) setdest 100942 9284 3.0" 
$ns at 802.3354105473006 "$node_(541) setdest 119657 10172 14.0" 
$ns at 868.2794357102111 "$node_(541) setdest 41625 21286 2.0" 
$ns at 504.8089864622491 "$node_(542) setdest 1710 26154 8.0" 
$ns at 548.748750699707 "$node_(542) setdest 66315 43694 7.0" 
$ns at 604.9770517537892 "$node_(542) setdest 132823 31470 6.0" 
$ns at 664.8947260205568 "$node_(542) setdest 23538 41915 18.0" 
$ns at 853.7158735200919 "$node_(542) setdest 92059 11679 8.0" 
$ns at 532.8717156336072 "$node_(543) setdest 885 22478 14.0" 
$ns at 609.4106193096718 "$node_(543) setdest 10069 21036 19.0" 
$ns at 787.0781860948875 "$node_(543) setdest 34046 17252 16.0" 
$ns at 610.6686745770701 "$node_(544) setdest 20025 35178 15.0" 
$ns at 784.3686342558988 "$node_(544) setdest 15481 7938 15.0" 
$ns at 887.8344897081244 "$node_(544) setdest 76496 36592 4.0" 
$ns at 633.284381321605 "$node_(545) setdest 107828 39317 9.0" 
$ns at 693.4315420863071 "$node_(545) setdest 52790 11303 10.0" 
$ns at 732.703236741033 "$node_(545) setdest 81456 17878 14.0" 
$ns at 882.8666095887447 "$node_(545) setdest 26433 13085 13.0" 
$ns at 601.5937345957996 "$node_(546) setdest 123085 3093 13.0" 
$ns at 663.0477875563988 "$node_(546) setdest 63174 15642 8.0" 
$ns at 769.5929120991586 "$node_(546) setdest 26449 40719 19.0" 
$ns at 897.8376686375389 "$node_(546) setdest 49965 24505 3.0" 
$ns at 665.9034450840758 "$node_(547) setdest 50338 26940 16.0" 
$ns at 790.2968210538295 "$node_(547) setdest 45785 41958 7.0" 
$ns at 849.9911384272827 "$node_(547) setdest 127605 34105 10.0" 
$ns at 515.1084440601019 "$node_(548) setdest 47471 219 18.0" 
$ns at 723.4470688696605 "$node_(548) setdest 74290 11808 11.0" 
$ns at 759.2458839705411 "$node_(548) setdest 64340 25032 10.0" 
$ns at 888.7946347183661 "$node_(548) setdest 28115 12017 11.0" 
$ns at 576.8395023930427 "$node_(549) setdest 50919 29758 16.0" 
$ns at 691.2555493029662 "$node_(549) setdest 78891 18997 20.0" 
$ns at 895.3040868192173 "$node_(549) setdest 21324 33335 17.0" 
$ns at 515.8282150674377 "$node_(550) setdest 78945 9987 17.0" 
$ns at 547.3661747575132 "$node_(550) setdest 16504 5919 17.0" 
$ns at 720.2825851648884 "$node_(550) setdest 69120 8037 2.0" 
$ns at 764.5059322794413 "$node_(550) setdest 18184 4069 1.0" 
$ns at 799.9572520564961 "$node_(550) setdest 19538 2931 14.0" 
$ns at 570.8895101702351 "$node_(551) setdest 32096 35 1.0" 
$ns at 603.4664988526905 "$node_(551) setdest 51722 21525 19.0" 
$ns at 705.1292494841242 "$node_(551) setdest 108981 7275 7.0" 
$ns at 783.436746840967 "$node_(551) setdest 75354 3848 13.0" 
$ns at 817.6864479072276 "$node_(551) setdest 46451 24508 5.0" 
$ns at 876.2425513123087 "$node_(551) setdest 55119 38994 20.0" 
$ns at 514.0638850557593 "$node_(552) setdest 102267 23973 20.0" 
$ns at 563.710307504993 "$node_(552) setdest 12304 16428 11.0" 
$ns at 594.3784189320455 "$node_(552) setdest 110414 7759 6.0" 
$ns at 677.4789495964417 "$node_(552) setdest 6322 21062 16.0" 
$ns at 773.5249313052909 "$node_(552) setdest 61816 38334 1.0" 
$ns at 803.586347950939 "$node_(552) setdest 25973 40096 19.0" 
$ns at 516.9202087668963 "$node_(553) setdest 36378 38136 8.0" 
$ns at 614.1049108432095 "$node_(553) setdest 67519 15881 17.0" 
$ns at 758.5633159792453 "$node_(553) setdest 15197 24653 19.0" 
$ns at 523.6815346481944 "$node_(554) setdest 46177 14433 11.0" 
$ns at 566.0173326803017 "$node_(554) setdest 129809 42488 1.0" 
$ns at 596.6786254547926 "$node_(554) setdest 34185 35858 1.0" 
$ns at 631.0884041503183 "$node_(554) setdest 54111 3784 1.0" 
$ns at 669.6014933708659 "$node_(554) setdest 93313 23190 18.0" 
$ns at 818.8886161404027 "$node_(554) setdest 37325 31412 16.0" 
$ns at 514.1406689473256 "$node_(555) setdest 50332 27286 12.0" 
$ns at 608.4501711373622 "$node_(555) setdest 63034 20079 16.0" 
$ns at 778.9905388014679 "$node_(555) setdest 45561 93 12.0" 
$ns at 895.4325452207383 "$node_(555) setdest 97841 33276 8.0" 
$ns at 506.54374640742134 "$node_(556) setdest 16396 1025 8.0" 
$ns at 570.7803182929423 "$node_(556) setdest 106138 31734 5.0" 
$ns at 645.7581009180079 "$node_(556) setdest 33673 39819 9.0" 
$ns at 689.2589050633934 "$node_(556) setdest 30649 31850 20.0" 
$ns at 730.2749805951165 "$node_(556) setdest 104930 16801 9.0" 
$ns at 760.8792417883878 "$node_(556) setdest 85486 15596 15.0" 
$ns at 821.1160888993699 "$node_(556) setdest 12563 43581 13.0" 
$ns at 862.6727672207122 "$node_(556) setdest 57054 14095 8.0" 
$ns at 501.22726533953795 "$node_(557) setdest 32686 37970 13.0" 
$ns at 607.6755773759301 "$node_(557) setdest 19258 41494 7.0" 
$ns at 703.8249967287727 "$node_(557) setdest 16020 25282 7.0" 
$ns at 754.3130582051557 "$node_(557) setdest 124723 19241 11.0" 
$ns at 874.5743475643694 "$node_(557) setdest 27698 38721 2.0" 
$ns at 504.00851371636367 "$node_(558) setdest 54087 32135 10.0" 
$ns at 602.790336642759 "$node_(558) setdest 4885 12488 10.0" 
$ns at 712.1527549317591 "$node_(558) setdest 73247 5621 12.0" 
$ns at 818.4156494219699 "$node_(558) setdest 13203 25200 6.0" 
$ns at 864.0245524981724 "$node_(558) setdest 126264 31724 10.0" 
$ns at 560.3231127155685 "$node_(559) setdest 130127 4615 8.0" 
$ns at 629.8079658053865 "$node_(559) setdest 73417 7463 17.0" 
$ns at 720.5079575864759 "$node_(559) setdest 11111 29705 17.0" 
$ns at 878.0204094171731 "$node_(559) setdest 124534 3295 17.0" 
$ns at 521.6625555415503 "$node_(560) setdest 130554 25031 6.0" 
$ns at 591.0725888727183 "$node_(560) setdest 30386 39580 4.0" 
$ns at 640.1669243018088 "$node_(560) setdest 538 9230 16.0" 
$ns at 735.399126651224 "$node_(560) setdest 124968 29783 2.0" 
$ns at 774.4594117964492 "$node_(560) setdest 35748 29179 19.0" 
$ns at 519.713006279303 "$node_(561) setdest 114202 2231 9.0" 
$ns at 561.3282664973918 "$node_(561) setdest 74983 24481 19.0" 
$ns at 654.7072002813687 "$node_(561) setdest 61733 43790 16.0" 
$ns at 835.3355311398556 "$node_(561) setdest 78802 29375 20.0" 
$ns at 514.0265236886452 "$node_(562) setdest 10005 28346 19.0" 
$ns at 552.8845740035132 "$node_(562) setdest 4491 32794 1.0" 
$ns at 584.8659159667865 "$node_(562) setdest 112801 30386 7.0" 
$ns at 663.774433604826 "$node_(562) setdest 126113 5740 3.0" 
$ns at 710.446688299386 "$node_(562) setdest 29583 43804 16.0" 
$ns at 545.5328854781953 "$node_(563) setdest 24158 5423 7.0" 
$ns at 615.152552126429 "$node_(563) setdest 21327 7113 5.0" 
$ns at 672.1818846538681 "$node_(563) setdest 1100 32671 7.0" 
$ns at 734.5206560014481 "$node_(563) setdest 97444 29044 17.0" 
$ns at 765.9168533246881 "$node_(563) setdest 53634 439 7.0" 
$ns at 860.7616388652121 "$node_(563) setdest 30737 2942 13.0" 
$ns at 533.053319487324 "$node_(564) setdest 12606 7405 5.0" 
$ns at 584.9695558907522 "$node_(564) setdest 128486 8178 3.0" 
$ns at 620.2862496969735 "$node_(564) setdest 75267 37874 15.0" 
$ns at 755.7301635041962 "$node_(564) setdest 132861 4141 10.0" 
$ns at 858.1945690998359 "$node_(564) setdest 91503 23822 16.0" 
$ns at 550.2773730587551 "$node_(565) setdest 67123 9418 2.0" 
$ns at 583.2572643968914 "$node_(565) setdest 128892 19633 1.0" 
$ns at 613.4483206662348 "$node_(565) setdest 15229 1371 2.0" 
$ns at 648.2607858919004 "$node_(565) setdest 1470 41759 6.0" 
$ns at 720.5354490857537 "$node_(565) setdest 5708 41601 20.0" 
$ns at 560.767903772676 "$node_(566) setdest 53662 35059 16.0" 
$ns at 594.7080965891619 "$node_(566) setdest 28178 40668 9.0" 
$ns at 654.2463696670187 "$node_(566) setdest 46158 44341 12.0" 
$ns at 747.3314191699409 "$node_(566) setdest 4850 20902 4.0" 
$ns at 802.6868799167096 "$node_(566) setdest 82483 15939 4.0" 
$ns at 848.7314474758892 "$node_(566) setdest 18080 41668 18.0" 
$ns at 526.3997343480636 "$node_(567) setdest 41732 39763 6.0" 
$ns at 557.4320300403203 "$node_(567) setdest 17237 30792 12.0" 
$ns at 703.4287954129297 "$node_(567) setdest 24994 6685 14.0" 
$ns at 772.3744580778091 "$node_(567) setdest 76789 29696 6.0" 
$ns at 848.9985948734709 "$node_(567) setdest 123792 24554 6.0" 
$ns at 501.71907461067735 "$node_(568) setdest 90316 23367 2.0" 
$ns at 532.2113531456179 "$node_(568) setdest 57813 41336 15.0" 
$ns at 645.4628074378444 "$node_(568) setdest 26432 33498 8.0" 
$ns at 740.4810724396821 "$node_(568) setdest 28191 32426 8.0" 
$ns at 847.8674383924205 "$node_(568) setdest 77619 3366 18.0" 
$ns at 583.5239078112196 "$node_(569) setdest 5973 6336 16.0" 
$ns at 752.816464091744 "$node_(569) setdest 97369 345 4.0" 
$ns at 795.5752473685818 "$node_(569) setdest 2559 20626 13.0" 
$ns at 882.5895900997174 "$node_(569) setdest 54832 22685 7.0" 
$ns at 560.029492685533 "$node_(570) setdest 125476 36092 4.0" 
$ns at 602.6034381644748 "$node_(570) setdest 52969 23946 13.0" 
$ns at 638.7473869406219 "$node_(570) setdest 118957 4978 10.0" 
$ns at 698.3776894527981 "$node_(570) setdest 100167 32806 13.0" 
$ns at 732.1959992359834 "$node_(570) setdest 64472 7401 12.0" 
$ns at 796.9840508079428 "$node_(570) setdest 9153 38527 20.0" 
$ns at 897.6559810319558 "$node_(570) setdest 130749 23447 10.0" 
$ns at 519.52575102499 "$node_(571) setdest 110857 40906 20.0" 
$ns at 599.4264704393669 "$node_(571) setdest 68765 36298 19.0" 
$ns at 732.2714000957895 "$node_(571) setdest 63287 22867 19.0" 
$ns at 843.5489054750077 "$node_(571) setdest 99331 7433 14.0" 
$ns at 509.3606631477116 "$node_(572) setdest 13452 44076 16.0" 
$ns at 574.9734168198341 "$node_(572) setdest 133341 10144 5.0" 
$ns at 607.1936268597017 "$node_(572) setdest 22096 40522 13.0" 
$ns at 645.7991057125416 "$node_(572) setdest 54138 15079 5.0" 
$ns at 694.3843704308799 "$node_(572) setdest 9353 38437 16.0" 
$ns at 734.7054715019283 "$node_(572) setdest 120726 14321 19.0" 
$ns at 854.5309960543588 "$node_(572) setdest 86727 34341 9.0" 
$ns at 510.81914569242144 "$node_(573) setdest 127195 16859 17.0" 
$ns at 692.6301616415668 "$node_(573) setdest 39761 32628 17.0" 
$ns at 727.3659206064983 "$node_(573) setdest 128941 5614 16.0" 
$ns at 842.3862978715825 "$node_(573) setdest 71986 2887 12.0" 
$ns at 542.5645190174149 "$node_(574) setdest 53138 38444 7.0" 
$ns at 633.1676112574327 "$node_(574) setdest 9888 19915 13.0" 
$ns at 735.1663974182782 "$node_(574) setdest 124677 2929 1.0" 
$ns at 766.1141918440027 "$node_(574) setdest 98320 13356 19.0" 
$ns at 844.4056971154774 "$node_(574) setdest 93108 40499 12.0" 
$ns at 546.5791099723881 "$node_(575) setdest 20666 11462 15.0" 
$ns at 705.1460019937599 "$node_(575) setdest 83939 23624 4.0" 
$ns at 736.6979812135419 "$node_(575) setdest 64854 37555 19.0" 
$ns at 855.7130708725949 "$node_(575) setdest 65424 2828 6.0" 
$ns at 509.90866467060323 "$node_(576) setdest 47531 5910 6.0" 
$ns at 574.2049615406804 "$node_(576) setdest 28367 35265 16.0" 
$ns at 694.4212824692213 "$node_(576) setdest 75976 37696 9.0" 
$ns at 798.1445349810124 "$node_(576) setdest 68657 20265 5.0" 
$ns at 865.3957313283856 "$node_(576) setdest 65749 3610 1.0" 
$ns at 514.2579927176894 "$node_(577) setdest 74285 42470 10.0" 
$ns at 584.5839048157733 "$node_(577) setdest 92042 8601 4.0" 
$ns at 625.342847558623 "$node_(577) setdest 24640 13640 4.0" 
$ns at 681.8901786558271 "$node_(577) setdest 36115 30854 13.0" 
$ns at 815.4803423778537 "$node_(577) setdest 51873 30913 18.0" 
$ns at 561.5882318017875 "$node_(578) setdest 120821 17218 10.0" 
$ns at 682.2109419039373 "$node_(578) setdest 37388 44222 20.0" 
$ns at 745.7470529708638 "$node_(578) setdest 116726 13548 20.0" 
$ns at 630.9410838907697 "$node_(579) setdest 105549 3914 7.0" 
$ns at 708.3980469537674 "$node_(579) setdest 66506 14541 14.0" 
$ns at 783.2220860724158 "$node_(579) setdest 11938 4591 9.0" 
$ns at 821.3155493434374 "$node_(579) setdest 19207 27060 6.0" 
$ns at 624.1193241042628 "$node_(580) setdest 43990 31770 4.0" 
$ns at 658.5927260066471 "$node_(580) setdest 105767 36566 5.0" 
$ns at 726.0282110138073 "$node_(580) setdest 72796 22088 6.0" 
$ns at 771.8719655138796 "$node_(580) setdest 9046 16364 3.0" 
$ns at 804.0998672499363 "$node_(580) setdest 88668 32483 12.0" 
$ns at 514.206816828006 "$node_(581) setdest 108985 33414 1.0" 
$ns at 550.50361475146 "$node_(581) setdest 129842 35629 3.0" 
$ns at 609.6993778499343 "$node_(581) setdest 103873 641 14.0" 
$ns at 679.6509093271443 "$node_(581) setdest 64901 18543 16.0" 
$ns at 805.265052982556 "$node_(581) setdest 109044 34134 14.0" 
$ns at 863.9416648485375 "$node_(581) setdest 1933 34203 2.0" 
$ns at 558.388260938797 "$node_(582) setdest 132243 15916 3.0" 
$ns at 598.218783425968 "$node_(582) setdest 4143 21302 6.0" 
$ns at 677.8613864942632 "$node_(582) setdest 24251 20107 17.0" 
$ns at 843.6210705010678 "$node_(582) setdest 60581 38306 4.0" 
$ns at 874.5177707726414 "$node_(582) setdest 84533 44120 18.0" 
$ns at 501.7838428877047 "$node_(583) setdest 116513 41902 17.0" 
$ns at 657.9837606894208 "$node_(583) setdest 83841 12099 7.0" 
$ns at 689.5060085593745 "$node_(583) setdest 89643 34514 9.0" 
$ns at 749.771616086041 "$node_(583) setdest 91632 40431 3.0" 
$ns at 809.5894255080107 "$node_(583) setdest 113108 4961 15.0" 
$ns at 517.0640361456028 "$node_(584) setdest 7748 8868 17.0" 
$ns at 557.6050197667129 "$node_(584) setdest 124672 21921 4.0" 
$ns at 606.6913487234488 "$node_(584) setdest 63549 32995 2.0" 
$ns at 647.6636063555825 "$node_(584) setdest 87931 42454 4.0" 
$ns at 692.6845143174339 "$node_(584) setdest 6182 16264 2.0" 
$ns at 723.5935710519777 "$node_(584) setdest 17560 18069 9.0" 
$ns at 827.0262847004053 "$node_(584) setdest 6114 3531 15.0" 
$ns at 540.625652909247 "$node_(585) setdest 116961 13679 11.0" 
$ns at 626.2548297303885 "$node_(585) setdest 16277 37473 2.0" 
$ns at 667.8018903323845 "$node_(585) setdest 133119 44108 1.0" 
$ns at 699.2436423055968 "$node_(585) setdest 13207 11598 11.0" 
$ns at 811.7180299127301 "$node_(585) setdest 103766 4804 3.0" 
$ns at 870.9174086475006 "$node_(585) setdest 12001 42974 13.0" 
$ns at 528.0310224057864 "$node_(586) setdest 125860 19446 1.0" 
$ns at 564.4764584259032 "$node_(586) setdest 23197 43537 2.0" 
$ns at 599.4208588212085 "$node_(586) setdest 120299 33739 4.0" 
$ns at 669.3484604769425 "$node_(586) setdest 48089 24493 19.0" 
$ns at 729.0526784034406 "$node_(586) setdest 59937 27204 16.0" 
$ns at 892.5904273796573 "$node_(586) setdest 23128 33270 16.0" 
$ns at 518.5562535113519 "$node_(587) setdest 48100 40602 12.0" 
$ns at 631.1609605218201 "$node_(587) setdest 101950 584 16.0" 
$ns at 717.4935034978413 "$node_(587) setdest 131630 24968 13.0" 
$ns at 783.6747971996309 "$node_(587) setdest 19651 1841 3.0" 
$ns at 836.4619240240164 "$node_(587) setdest 12436 7833 9.0" 
$ns at 580.1675465253038 "$node_(588) setdest 70353 28389 20.0" 
$ns at 696.0854271322785 "$node_(588) setdest 119160 30420 16.0" 
$ns at 872.0700602159175 "$node_(588) setdest 17191 30065 1.0" 
$ns at 550.7081487885125 "$node_(589) setdest 41317 43502 7.0" 
$ns at 640.4564837283099 "$node_(589) setdest 81544 13716 5.0" 
$ns at 698.040046929656 "$node_(589) setdest 45313 28025 13.0" 
$ns at 741.8591882481066 "$node_(589) setdest 9906 34729 12.0" 
$ns at 800.3471638040405 "$node_(589) setdest 69165 3187 15.0" 
$ns at 536.0403286146529 "$node_(590) setdest 15877 536 19.0" 
$ns at 743.6170304559492 "$node_(590) setdest 88228 1732 16.0" 
$ns at 884.6082879243982 "$node_(590) setdest 97801 43507 3.0" 
$ns at 524.7698223758167 "$node_(591) setdest 5507 37920 6.0" 
$ns at 589.6952467818321 "$node_(591) setdest 132080 13635 19.0" 
$ns at 743.6494429756908 "$node_(591) setdest 104435 22697 8.0" 
$ns at 831.7763900942246 "$node_(591) setdest 4669 27114 1.0" 
$ns at 867.1174987843467 "$node_(591) setdest 122887 20355 14.0" 
$ns at 561.5830746213888 "$node_(592) setdest 67821 11381 17.0" 
$ns at 624.3465992169795 "$node_(592) setdest 20795 39620 4.0" 
$ns at 656.4381713653313 "$node_(592) setdest 32261 23244 20.0" 
$ns at 728.218970554143 "$node_(592) setdest 133242 4016 1.0" 
$ns at 763.2973372972091 "$node_(592) setdest 92352 4001 8.0" 
$ns at 849.2253902228547 "$node_(592) setdest 73538 13140 15.0" 
$ns at 899.2306991697254 "$node_(592) setdest 38120 21261 4.0" 
$ns at 665.6359308783753 "$node_(593) setdest 63291 17387 9.0" 
$ns at 701.5099398779945 "$node_(593) setdest 7783 6655 4.0" 
$ns at 746.6653842107047 "$node_(593) setdest 87424 26707 20.0" 
$ns at 528.4358858942147 "$node_(594) setdest 44363 25634 18.0" 
$ns at 606.9708543949755 "$node_(594) setdest 10031 36579 10.0" 
$ns at 652.3530259105895 "$node_(594) setdest 55319 1220 10.0" 
$ns at 710.3547110070597 "$node_(594) setdest 57613 20780 15.0" 
$ns at 864.2433490753405 "$node_(594) setdest 130304 31637 12.0" 
$ns at 584.9918824319674 "$node_(595) setdest 22544 34126 2.0" 
$ns at 630.6211036864423 "$node_(595) setdest 84797 16834 7.0" 
$ns at 703.4078217837991 "$node_(595) setdest 99964 10853 15.0" 
$ns at 750.9744805312438 "$node_(595) setdest 72879 15771 9.0" 
$ns at 786.7851492802998 "$node_(595) setdest 50367 42756 8.0" 
$ns at 818.4813743794002 "$node_(595) setdest 81310 29017 15.0" 
$ns at 892.902118415122 "$node_(595) setdest 132911 23874 1.0" 
$ns at 540.7406582296263 "$node_(596) setdest 49165 12386 1.0" 
$ns at 579.4475290975614 "$node_(596) setdest 55934 11025 8.0" 
$ns at 628.5562380158982 "$node_(596) setdest 69118 39585 15.0" 
$ns at 785.2977720335057 "$node_(596) setdest 127991 17873 7.0" 
$ns at 850.3802078446154 "$node_(596) setdest 132937 17524 16.0" 
$ns at 532.1182489743442 "$node_(597) setdest 36002 36246 9.0" 
$ns at 568.0584228497428 "$node_(597) setdest 119811 13377 2.0" 
$ns at 614.5513749400038 "$node_(597) setdest 41473 24493 18.0" 
$ns at 770.9887984872882 "$node_(597) setdest 61093 23400 19.0" 
$ns at 805.5048012330109 "$node_(597) setdest 30759 9226 18.0" 
$ns at 885.7537578317697 "$node_(597) setdest 90587 5290 1.0" 
$ns at 530.2744265175479 "$node_(598) setdest 38586 2526 1.0" 
$ns at 568.652433788197 "$node_(598) setdest 97148 43207 2.0" 
$ns at 600.1756057678026 "$node_(598) setdest 109892 28601 10.0" 
$ns at 679.7801100000642 "$node_(598) setdest 33966 40558 8.0" 
$ns at 739.8922485250328 "$node_(598) setdest 89686 44256 12.0" 
$ns at 786.4755875825903 "$node_(598) setdest 116941 32723 4.0" 
$ns at 826.6387933557984 "$node_(598) setdest 4412 43070 3.0" 
$ns at 878.6234817365463 "$node_(598) setdest 79698 13480 17.0" 
$ns at 504.69820372172194 "$node_(599) setdest 118063 31892 14.0" 
$ns at 632.7914320671314 "$node_(599) setdest 131273 34251 8.0" 
$ns at 735.039475412248 "$node_(599) setdest 59430 724 3.0" 
$ns at 766.0083072598668 "$node_(599) setdest 23621 8114 6.0" 
$ns at 820.6671218428024 "$node_(599) setdest 28789 43196 3.0" 
$ns at 868.9590560785394 "$node_(599) setdest 118687 20475 10.0" 
$ns at 686.7068133867022 "$node_(600) setdest 99200 13034 11.0" 
$ns at 778.2834706197272 "$node_(600) setdest 107908 32369 15.0" 
$ns at 810.5010209795151 "$node_(600) setdest 69648 8341 2.0" 
$ns at 846.13285744866 "$node_(600) setdest 110566 37853 10.0" 
$ns at 659.4066053343322 "$node_(601) setdest 96109 27428 16.0" 
$ns at 737.9996325262113 "$node_(601) setdest 28279 5426 15.0" 
$ns at 641.0489788978695 "$node_(602) setdest 82196 19497 20.0" 
$ns at 702.6888869290461 "$node_(602) setdest 100963 38695 3.0" 
$ns at 761.897374134287 "$node_(602) setdest 17112 21768 7.0" 
$ns at 811.0676029809977 "$node_(602) setdest 97098 43848 15.0" 
$ns at 607.3179572392429 "$node_(603) setdest 105623 22991 10.0" 
$ns at 675.0662065357558 "$node_(603) setdest 67218 9336 12.0" 
$ns at 737.7696387543843 "$node_(603) setdest 119503 9307 14.0" 
$ns at 829.9728242644826 "$node_(603) setdest 114051 44469 9.0" 
$ns at 659.7177513547433 "$node_(604) setdest 16194 12485 1.0" 
$ns at 699.2652064190269 "$node_(604) setdest 117864 34374 1.0" 
$ns at 732.3254900830373 "$node_(604) setdest 132363 17994 20.0" 
$ns at 648.5281296235612 "$node_(605) setdest 130226 34427 13.0" 
$ns at 726.6793285900558 "$node_(605) setdest 103535 20725 17.0" 
$ns at 765.7844205244623 "$node_(605) setdest 60734 17464 10.0" 
$ns at 799.8921561627717 "$node_(605) setdest 93836 3926 1.0" 
$ns at 835.3836709779516 "$node_(605) setdest 17857 21801 12.0" 
$ns at 638.119371190847 "$node_(606) setdest 25259 24853 9.0" 
$ns at 701.0401684916312 "$node_(606) setdest 57543 24166 16.0" 
$ns at 763.2225077573346 "$node_(606) setdest 130180 42208 8.0" 
$ns at 819.9664600212266 "$node_(606) setdest 48841 17732 9.0" 
$ns at 890.6323084621297 "$node_(606) setdest 78118 34289 17.0" 
$ns at 715.7991915614793 "$node_(607) setdest 6422 27373 14.0" 
$ns at 787.0261874862024 "$node_(607) setdest 1231 20370 3.0" 
$ns at 828.7016655215222 "$node_(607) setdest 92525 20385 5.0" 
$ns at 871.3161163660709 "$node_(607) setdest 22961 22355 2.0" 
$ns at 637.2124866910667 "$node_(608) setdest 16230 26202 19.0" 
$ns at 751.8198787388731 "$node_(608) setdest 71886 23345 18.0" 
$ns at 668.5744472747863 "$node_(609) setdest 92964 17832 15.0" 
$ns at 728.70365320875 "$node_(609) setdest 87009 12020 7.0" 
$ns at 768.3054059814713 "$node_(609) setdest 2452 6549 12.0" 
$ns at 883.8157075784542 "$node_(609) setdest 100315 38861 15.0" 
$ns at 768.8560417673585 "$node_(610) setdest 123385 3226 1.0" 
$ns at 801.348935610136 "$node_(610) setdest 84815 12471 13.0" 
$ns at 884.0034505615369 "$node_(610) setdest 101901 10470 20.0" 
$ns at 734.4541752511072 "$node_(611) setdest 73442 41046 18.0" 
$ns at 812.7529751092441 "$node_(611) setdest 107640 38192 5.0" 
$ns at 877.2577148838454 "$node_(611) setdest 68632 31126 10.0" 
$ns at 600.2288411878178 "$node_(612) setdest 63917 36139 2.0" 
$ns at 633.6347107311611 "$node_(612) setdest 109055 23722 4.0" 
$ns at 667.1383894458727 "$node_(612) setdest 26565 33494 19.0" 
$ns at 739.8429962089754 "$node_(612) setdest 4189 18211 12.0" 
$ns at 777.6318370160559 "$node_(612) setdest 43274 20598 12.0" 
$ns at 671.4474815494023 "$node_(613) setdest 108708 10040 1.0" 
$ns at 704.8235297398654 "$node_(613) setdest 129948 38237 19.0" 
$ns at 894.0155007171675 "$node_(613) setdest 65592 13175 2.0" 
$ns at 645.0778475669531 "$node_(614) setdest 48250 41640 1.0" 
$ns at 680.4557359139166 "$node_(614) setdest 102712 19675 9.0" 
$ns at 734.8812949364545 "$node_(614) setdest 37055 41083 6.0" 
$ns at 771.1428730563232 "$node_(614) setdest 13433 22832 20.0" 
$ns at 879.6845831962067 "$node_(614) setdest 27120 882 17.0" 
$ns at 632.1538506525858 "$node_(615) setdest 68563 23393 4.0" 
$ns at 697.5038452337575 "$node_(615) setdest 120498 18569 14.0" 
$ns at 803.749351760255 "$node_(615) setdest 35396 16131 19.0" 
$ns at 705.4627396120906 "$node_(616) setdest 105392 19218 19.0" 
$ns at 893.0723989977226 "$node_(616) setdest 60678 19051 13.0" 
$ns at 681.1516115646556 "$node_(617) setdest 71339 32731 3.0" 
$ns at 726.7050217020827 "$node_(617) setdest 70209 36952 5.0" 
$ns at 779.041042361277 "$node_(617) setdest 86355 12674 19.0" 
$ns at 652.5812576038211 "$node_(618) setdest 117708 41166 1.0" 
$ns at 688.1064083124488 "$node_(618) setdest 24797 24746 19.0" 
$ns at 718.8141347797944 "$node_(618) setdest 98233 42379 5.0" 
$ns at 778.1103169436351 "$node_(618) setdest 112569 20404 8.0" 
$ns at 870.5059062991421 "$node_(618) setdest 24617 24373 14.0" 
$ns at 672.6969182385575 "$node_(619) setdest 83918 16052 1.0" 
$ns at 711.0468214858774 "$node_(619) setdest 44657 34733 9.0" 
$ns at 755.391331425099 "$node_(619) setdest 52142 40789 13.0" 
$ns at 794.7219952342779 "$node_(619) setdest 3288 7154 4.0" 
$ns at 832.9529440346481 "$node_(619) setdest 129615 35410 7.0" 
$ns at 897.4051385077274 "$node_(619) setdest 13288 15195 14.0" 
$ns at 664.5168899170304 "$node_(620) setdest 114270 14761 10.0" 
$ns at 778.2065770069917 "$node_(620) setdest 45737 33006 17.0" 
$ns at 635.3969672050955 "$node_(621) setdest 56926 5726 15.0" 
$ns at 669.2872450439387 "$node_(621) setdest 112740 10153 5.0" 
$ns at 708.215456549035 "$node_(621) setdest 110505 11526 1.0" 
$ns at 746.6054252746105 "$node_(621) setdest 100115 36484 11.0" 
$ns at 781.0240921421359 "$node_(621) setdest 49008 20908 15.0" 
$ns at 870.6145215211909 "$node_(621) setdest 108017 2636 7.0" 
$ns at 628.5631138483495 "$node_(622) setdest 99554 2054 13.0" 
$ns at 699.1134050379436 "$node_(622) setdest 22272 9273 12.0" 
$ns at 822.9144442783028 "$node_(622) setdest 62103 44017 9.0" 
$ns at 860.2916667628081 "$node_(622) setdest 57239 11504 14.0" 
$ns at 735.4242638852569 "$node_(623) setdest 40140 21319 16.0" 
$ns at 784.6385971668897 "$node_(623) setdest 24296 13263 1.0" 
$ns at 823.8702644290105 "$node_(623) setdest 72585 32435 17.0" 
$ns at 883.5830976187729 "$node_(623) setdest 114733 520 6.0" 
$ns at 685.183456388786 "$node_(624) setdest 109907 954 11.0" 
$ns at 743.9737299469616 "$node_(624) setdest 6239 20946 19.0" 
$ns at 791.699125823805 "$node_(624) setdest 51114 37477 19.0" 
$ns at 896.9469017216288 "$node_(624) setdest 76675 37106 7.0" 
$ns at 654.2646195424545 "$node_(625) setdest 5777 40554 14.0" 
$ns at 725.7138169308013 "$node_(625) setdest 51657 25640 10.0" 
$ns at 777.5323505277554 "$node_(625) setdest 23657 31342 18.0" 
$ns at 653.5034786124725 "$node_(626) setdest 132586 37483 3.0" 
$ns at 703.8698611054962 "$node_(626) setdest 80676 22280 10.0" 
$ns at 802.560918781808 "$node_(626) setdest 60756 31068 5.0" 
$ns at 873.1105044729361 "$node_(626) setdest 79325 39889 8.0" 
$ns at 623.6518472686428 "$node_(627) setdest 4535 22998 18.0" 
$ns at 710.4453397100182 "$node_(627) setdest 84172 5855 19.0" 
$ns at 860.1654254977852 "$node_(627) setdest 44869 26415 4.0" 
$ns at 626.0141796941048 "$node_(628) setdest 18928 7834 12.0" 
$ns at 747.866462423972 "$node_(628) setdest 30395 39058 20.0" 
$ns at 855.9324376399437 "$node_(628) setdest 67811 38307 13.0" 
$ns at 620.2679663931224 "$node_(629) setdest 97887 2373 13.0" 
$ns at 658.1726848157125 "$node_(629) setdest 71631 26318 6.0" 
$ns at 734.8267177231509 "$node_(629) setdest 113605 41498 16.0" 
$ns at 789.7887102534991 "$node_(629) setdest 25572 41492 2.0" 
$ns at 832.197737181023 "$node_(629) setdest 127508 29492 19.0" 
$ns at 628.9396165525136 "$node_(630) setdest 32342 17896 14.0" 
$ns at 718.060478474303 "$node_(630) setdest 24334 34560 17.0" 
$ns at 813.1113077035583 "$node_(630) setdest 49183 10497 11.0" 
$ns at 872.5455225379565 "$node_(630) setdest 43944 32278 13.0" 
$ns at 693.9780808400754 "$node_(631) setdest 58261 21702 8.0" 
$ns at 737.3199649749348 "$node_(631) setdest 39657 26221 3.0" 
$ns at 771.1512176003287 "$node_(631) setdest 106781 5617 14.0" 
$ns at 871.7893274007065 "$node_(631) setdest 15713 41174 3.0" 
$ns at 644.4364388078603 "$node_(632) setdest 98624 11847 2.0" 
$ns at 680.9085327063692 "$node_(632) setdest 49300 33125 16.0" 
$ns at 818.4213226368797 "$node_(632) setdest 44572 29975 13.0" 
$ns at 609.9838737783002 "$node_(633) setdest 29779 32683 10.0" 
$ns at 733.6362152563938 "$node_(633) setdest 30547 24647 17.0" 
$ns at 788.2349506899689 "$node_(633) setdest 5213 35685 7.0" 
$ns at 871.7687603062766 "$node_(633) setdest 114476 29168 14.0" 
$ns at 701.2222146790958 "$node_(634) setdest 96573 27544 17.0" 
$ns at 849.8842505184447 "$node_(634) setdest 97878 26653 17.0" 
$ns at 628.794260916614 "$node_(635) setdest 21827 30204 2.0" 
$ns at 660.8492121527481 "$node_(635) setdest 12085 11718 10.0" 
$ns at 694.2307039167915 "$node_(635) setdest 41304 38667 18.0" 
$ns at 743.8985068879227 "$node_(635) setdest 102585 22156 9.0" 
$ns at 812.7042065927669 "$node_(635) setdest 58785 39598 4.0" 
$ns at 859.3393048566111 "$node_(635) setdest 123346 43978 13.0" 
$ns at 644.1778682877631 "$node_(636) setdest 43468 22229 8.0" 
$ns at 707.2841454383891 "$node_(636) setdest 37465 42767 14.0" 
$ns at 826.5299482393724 "$node_(636) setdest 95897 18903 1.0" 
$ns at 865.49747041694 "$node_(636) setdest 87434 9586 11.0" 
$ns at 652.0851936669422 "$node_(637) setdest 38744 15877 5.0" 
$ns at 693.8678133252544 "$node_(637) setdest 85045 38418 1.0" 
$ns at 733.2675126156099 "$node_(637) setdest 117214 40383 1.0" 
$ns at 765.4019267702697 "$node_(637) setdest 13649 5275 8.0" 
$ns at 830.2683532439304 "$node_(637) setdest 10219 17760 13.0" 
$ns at 610.1850241338468 "$node_(638) setdest 27660 25613 5.0" 
$ns at 646.6153558747299 "$node_(638) setdest 102788 42638 1.0" 
$ns at 679.8818158408492 "$node_(638) setdest 85896 19271 5.0" 
$ns at 722.2861674305609 "$node_(638) setdest 87352 17923 3.0" 
$ns at 780.0816578415514 "$node_(638) setdest 128054 15183 7.0" 
$ns at 858.8105808719743 "$node_(638) setdest 41039 30703 8.0" 
$ns at 610.9504842395451 "$node_(639) setdest 108471 19876 8.0" 
$ns at 696.0545677710327 "$node_(639) setdest 6129 26721 13.0" 
$ns at 757.1830080266241 "$node_(639) setdest 115284 9187 9.0" 
$ns at 832.652264390299 "$node_(639) setdest 88002 12738 1.0" 
$ns at 866.9960139330358 "$node_(639) setdest 124079 27529 7.0" 
$ns at 639.6965338770824 "$node_(640) setdest 67511 29825 10.0" 
$ns at 741.1977193786541 "$node_(640) setdest 37144 12149 16.0" 
$ns at 797.2407513334387 "$node_(640) setdest 101112 24781 14.0" 
$ns at 853.6087889584085 "$node_(640) setdest 51291 16951 5.0" 
$ns at 635.6732001862734 "$node_(641) setdest 48548 36188 2.0" 
$ns at 683.1530796572633 "$node_(641) setdest 2244 34284 5.0" 
$ns at 755.6805336935008 "$node_(641) setdest 37059 18509 6.0" 
$ns at 802.1493919130392 "$node_(641) setdest 54098 10471 9.0" 
$ns at 868.6783293259225 "$node_(641) setdest 91497 42753 10.0" 
$ns at 653.7490605791103 "$node_(642) setdest 25611 44053 8.0" 
$ns at 748.3615970629924 "$node_(642) setdest 59546 21196 14.0" 
$ns at 882.5409942050059 "$node_(642) setdest 87694 31283 20.0" 
$ns at 636.7558725331205 "$node_(643) setdest 38864 43144 5.0" 
$ns at 687.7287847991497 "$node_(643) setdest 74553 20812 4.0" 
$ns at 737.3522810871125 "$node_(643) setdest 68803 15488 14.0" 
$ns at 892.6615909580762 "$node_(643) setdest 31617 8456 1.0" 
$ns at 701.2795308948344 "$node_(644) setdest 31271 30349 6.0" 
$ns at 768.7955200736229 "$node_(644) setdest 69943 19539 19.0" 
$ns at 876.6281623835109 "$node_(644) setdest 25555 22451 18.0" 
$ns at 710.0254947512907 "$node_(645) setdest 34948 28218 2.0" 
$ns at 751.0025641777617 "$node_(645) setdest 1331 29951 10.0" 
$ns at 784.3449003988019 "$node_(645) setdest 57234 35523 6.0" 
$ns at 857.8298117575421 "$node_(645) setdest 98731 2392 17.0" 
$ns at 753.1006983580271 "$node_(646) setdest 23915 29314 9.0" 
$ns at 794.7783146803155 "$node_(646) setdest 81170 16700 12.0" 
$ns at 625.2684239264072 "$node_(647) setdest 128817 26201 18.0" 
$ns at 699.6867517622126 "$node_(647) setdest 120545 34746 13.0" 
$ns at 747.4925274600785 "$node_(647) setdest 62538 7039 2.0" 
$ns at 782.79259752706 "$node_(647) setdest 100633 30052 9.0" 
$ns at 848.0403863290835 "$node_(647) setdest 110605 28995 15.0" 
$ns at 641.2241275951766 "$node_(648) setdest 123043 9646 3.0" 
$ns at 692.3337462250685 "$node_(648) setdest 38463 9736 4.0" 
$ns at 762.0813342019142 "$node_(648) setdest 27909 17868 18.0" 
$ns at 858.6260957182028 "$node_(648) setdest 110559 23903 8.0" 
$ns at 727.6286632818737 "$node_(649) setdest 99152 10945 20.0" 
$ns at 804.1015021071673 "$node_(649) setdest 15878 41541 5.0" 
$ns at 841.9903577207936 "$node_(649) setdest 103477 42902 8.0" 
$ns at 603.6377263137218 "$node_(650) setdest 97964 16789 16.0" 
$ns at 747.4906184730826 "$node_(650) setdest 101735 33997 13.0" 
$ns at 796.9316165911757 "$node_(650) setdest 56215 1759 9.0" 
$ns at 882.2171464134761 "$node_(650) setdest 83547 5009 9.0" 
$ns at 671.5017760463305 "$node_(651) setdest 129884 1979 13.0" 
$ns at 784.7693285668887 "$node_(651) setdest 115949 31746 10.0" 
$ns at 850.7160670515577 "$node_(651) setdest 29080 30094 19.0" 
$ns at 640.9476878527595 "$node_(652) setdest 35452 26605 2.0" 
$ns at 679.874927039841 "$node_(652) setdest 53604 31421 2.0" 
$ns at 727.7149137513868 "$node_(652) setdest 61619 32296 18.0" 
$ns at 852.3913781235125 "$node_(652) setdest 110681 29727 6.0" 
$ns at 695.1188338274094 "$node_(653) setdest 97440 25352 7.0" 
$ns at 780.961839239671 "$node_(653) setdest 50408 43583 11.0" 
$ns at 619.087363933053 "$node_(654) setdest 108530 2059 6.0" 
$ns at 694.546947792121 "$node_(654) setdest 119730 15409 3.0" 
$ns at 726.4642391280897 "$node_(654) setdest 123203 23900 5.0" 
$ns at 794.3193401713836 "$node_(654) setdest 81433 3991 8.0" 
$ns at 872.1262116801796 "$node_(654) setdest 110203 4724 10.0" 
$ns at 669.7723832696862 "$node_(655) setdest 62560 26438 16.0" 
$ns at 711.7316230376729 "$node_(655) setdest 121055 3001 10.0" 
$ns at 745.7343778876377 "$node_(655) setdest 124405 27555 18.0" 
$ns at 718.9724770028148 "$node_(656) setdest 81255 43990 5.0" 
$ns at 786.9693224573853 "$node_(656) setdest 89363 37609 5.0" 
$ns at 821.6591822740603 "$node_(656) setdest 3406 34079 3.0" 
$ns at 867.9588259460531 "$node_(656) setdest 102120 29242 8.0" 
$ns at 600.3033798839009 "$node_(657) setdest 5345 14382 5.0" 
$ns at 659.3657825519981 "$node_(657) setdest 60927 22927 12.0" 
$ns at 785.4608501704565 "$node_(657) setdest 129573 6449 3.0" 
$ns at 822.4908307255675 "$node_(657) setdest 37687 22594 16.0" 
$ns at 635.2015101762761 "$node_(658) setdest 7112 6444 19.0" 
$ns at 832.7296783333163 "$node_(658) setdest 14028 39133 1.0" 
$ns at 866.0985479356923 "$node_(658) setdest 117187 26114 13.0" 
$ns at 626.8431042371656 "$node_(659) setdest 93099 42513 1.0" 
$ns at 660.4222728658883 "$node_(659) setdest 44086 27193 14.0" 
$ns at 715.2666381829432 "$node_(659) setdest 38620 8419 7.0" 
$ns at 750.8224405982714 "$node_(659) setdest 98496 41412 2.0" 
$ns at 791.1109588466552 "$node_(659) setdest 3114 18217 5.0" 
$ns at 852.8275551617119 "$node_(659) setdest 50529 7373 1.0" 
$ns at 885.644300862993 "$node_(659) setdest 11934 16972 9.0" 
$ns at 654.268186089424 "$node_(660) setdest 59717 5291 14.0" 
$ns at 704.4590044200601 "$node_(660) setdest 81315 32103 6.0" 
$ns at 759.3337082747487 "$node_(660) setdest 118325 15809 6.0" 
$ns at 817.6665682340157 "$node_(660) setdest 64879 18337 11.0" 
$ns at 700.5060662368744 "$node_(661) setdest 12007 30565 7.0" 
$ns at 785.5168346677846 "$node_(661) setdest 91391 22152 1.0" 
$ns at 819.0295966434132 "$node_(661) setdest 32617 37382 7.0" 
$ns at 854.2441098176703 "$node_(661) setdest 11386 8656 14.0" 
$ns at 720.7414241930351 "$node_(662) setdest 75688 33041 16.0" 
$ns at 876.3316376605021 "$node_(662) setdest 23168 30639 4.0" 
$ns at 657.1908202600455 "$node_(663) setdest 99021 13546 18.0" 
$ns at 805.374427508161 "$node_(663) setdest 104715 36357 16.0" 
$ns at 886.4102012960117 "$node_(663) setdest 114457 37544 11.0" 
$ns at 692.026033427072 "$node_(664) setdest 77266 41793 2.0" 
$ns at 730.0597063213587 "$node_(664) setdest 50356 1507 2.0" 
$ns at 777.8946744078723 "$node_(664) setdest 73189 28358 7.0" 
$ns at 839.4400747475484 "$node_(664) setdest 70305 38194 12.0" 
$ns at 712.7643441473157 "$node_(665) setdest 7431 28900 6.0" 
$ns at 793.4894167138664 "$node_(665) setdest 129662 39467 8.0" 
$ns at 853.787004702313 "$node_(665) setdest 74072 21256 7.0" 
$ns at 696.598084767976 "$node_(666) setdest 7351 27637 17.0" 
$ns at 822.5621583244408 "$node_(666) setdest 116589 485 3.0" 
$ns at 872.4082077343813 "$node_(666) setdest 106507 8426 5.0" 
$ns at 645.4879027929152 "$node_(667) setdest 118121 1282 10.0" 
$ns at 774.7040496897168 "$node_(667) setdest 17011 9767 15.0" 
$ns at 641.3799203718086 "$node_(668) setdest 2072 28440 19.0" 
$ns at 790.9018600504407 "$node_(668) setdest 119310 44693 2.0" 
$ns at 830.6740855428707 "$node_(668) setdest 48467 35984 18.0" 
$ns at 645.4354890872565 "$node_(669) setdest 87188 15084 9.0" 
$ns at 696.0882642697774 "$node_(669) setdest 30176 24129 14.0" 
$ns at 861.8792290292329 "$node_(669) setdest 103610 31000 11.0" 
$ns at 618.2131293812569 "$node_(670) setdest 52427 30796 17.0" 
$ns at 753.3688213200004 "$node_(670) setdest 14832 3440 18.0" 
$ns at 879.8897069230804 "$node_(670) setdest 97503 4574 10.0" 
$ns at 618.2536670376865 "$node_(671) setdest 118469 5650 4.0" 
$ns at 650.3493333781021 "$node_(671) setdest 71919 19224 19.0" 
$ns at 811.0133454358169 "$node_(671) setdest 107128 7764 16.0" 
$ns at 616.3043617701525 "$node_(672) setdest 108195 26194 4.0" 
$ns at 659.1391325541039 "$node_(672) setdest 27530 34851 12.0" 
$ns at 785.1632322269373 "$node_(672) setdest 48540 21805 8.0" 
$ns at 886.1555317935074 "$node_(672) setdest 21943 32273 16.0" 
$ns at 640.0380588102784 "$node_(673) setdest 34069 1702 4.0" 
$ns at 670.7691398013919 "$node_(673) setdest 47736 19118 12.0" 
$ns at 793.5699343125816 "$node_(673) setdest 96698 21105 12.0" 
$ns at 873.6772913106963 "$node_(673) setdest 92334 27311 19.0" 
$ns at 609.1847449793903 "$node_(674) setdest 37061 2234 10.0" 
$ns at 716.6134698336211 "$node_(674) setdest 30735 9438 4.0" 
$ns at 775.3031230698135 "$node_(674) setdest 134142 41516 9.0" 
$ns at 856.358906132926 "$node_(674) setdest 55000 24406 1.0" 
$ns at 891.764685434983 "$node_(674) setdest 108007 5203 5.0" 
$ns at 628.1238564108759 "$node_(675) setdest 69154 18893 10.0" 
$ns at 664.3386425639412 "$node_(675) setdest 62210 42500 15.0" 
$ns at 834.6724427848501 "$node_(675) setdest 113892 29136 17.0" 
$ns at 704.4151406962592 "$node_(676) setdest 15495 12998 1.0" 
$ns at 734.7510648073485 "$node_(676) setdest 126199 27600 17.0" 
$ns at 887.3912147935315 "$node_(676) setdest 396 9308 2.0" 
$ns at 616.6871644366008 "$node_(677) setdest 24274 29609 19.0" 
$ns at 674.2746841533223 "$node_(677) setdest 130622 26826 17.0" 
$ns at 774.5543667146501 "$node_(677) setdest 53804 22426 6.0" 
$ns at 862.2317112259703 "$node_(677) setdest 682 23399 11.0" 
$ns at 678.8121797884698 "$node_(678) setdest 34374 15951 14.0" 
$ns at 738.6033772789546 "$node_(678) setdest 119326 14626 1.0" 
$ns at 778.5555545214153 "$node_(678) setdest 115527 30061 14.0" 
$ns at 879.8909855472469 "$node_(678) setdest 25649 29732 6.0" 
$ns at 690.487613308507 "$node_(679) setdest 59173 23051 16.0" 
$ns at 791.3551341262166 "$node_(679) setdest 108119 27877 16.0" 
$ns at 615.4724312992837 "$node_(680) setdest 93683 24357 18.0" 
$ns at 657.7527553808967 "$node_(680) setdest 72962 14090 13.0" 
$ns at 809.6921264669948 "$node_(680) setdest 52817 16476 3.0" 
$ns at 844.2669914208578 "$node_(680) setdest 80707 12518 18.0" 
$ns at 663.1064214762491 "$node_(681) setdest 38851 32836 12.0" 
$ns at 717.549079318918 "$node_(681) setdest 79976 26898 16.0" 
$ns at 778.4467768745046 "$node_(681) setdest 51709 7694 12.0" 
$ns at 689.2063616550325 "$node_(682) setdest 94545 14246 9.0" 
$ns at 766.8566865310593 "$node_(682) setdest 24633 10345 15.0" 
$ns at 819.1808011258873 "$node_(682) setdest 68427 1713 3.0" 
$ns at 853.3704862334716 "$node_(682) setdest 75991 24842 15.0" 
$ns at 685.7399194461227 "$node_(683) setdest 57184 10362 1.0" 
$ns at 719.2631588357441 "$node_(683) setdest 117022 29480 11.0" 
$ns at 792.4529366643081 "$node_(683) setdest 107287 1627 15.0" 
$ns at 630.929310385804 "$node_(684) setdest 105536 10741 12.0" 
$ns at 739.3966201219174 "$node_(684) setdest 101592 17960 5.0" 
$ns at 779.1138684159248 "$node_(684) setdest 121990 38358 13.0" 
$ns at 890.2255887777106 "$node_(684) setdest 39370 32195 16.0" 
$ns at 657.5368540054243 "$node_(685) setdest 109878 18556 1.0" 
$ns at 691.2090826435898 "$node_(685) setdest 18159 43392 18.0" 
$ns at 775.1057910421378 "$node_(685) setdest 53814 21852 16.0" 
$ns at 773.3277102102143 "$node_(686) setdest 114640 5709 16.0" 
$ns at 657.9669310872541 "$node_(687) setdest 118116 43567 18.0" 
$ns at 726.6636542750048 "$node_(687) setdest 83475 24832 1.0" 
$ns at 764.3517145105486 "$node_(687) setdest 72323 43978 11.0" 
$ns at 856.4568005009119 "$node_(687) setdest 77625 17347 17.0" 
$ns at 893.1400676670467 "$node_(687) setdest 72256 30356 6.0" 
$ns at 634.4144344206184 "$node_(688) setdest 112742 23834 5.0" 
$ns at 704.6519502194693 "$node_(688) setdest 24210 9712 17.0" 
$ns at 737.9021179507308 "$node_(688) setdest 113164 35362 7.0" 
$ns at 832.5467599688424 "$node_(688) setdest 46687 33425 6.0" 
$ns at 870.9922483997406 "$node_(688) setdest 99776 44017 8.0" 
$ns at 657.782993400215 "$node_(689) setdest 57947 37515 3.0" 
$ns at 692.1467829306141 "$node_(689) setdest 63555 4758 11.0" 
$ns at 741.6331623919283 "$node_(689) setdest 95094 21291 13.0" 
$ns at 798.5377872126554 "$node_(689) setdest 21646 26005 2.0" 
$ns at 840.4300142945862 "$node_(689) setdest 95956 31413 14.0" 
$ns at 600.3299185655393 "$node_(690) setdest 59 359 5.0" 
$ns at 674.2335444963005 "$node_(690) setdest 4862 36623 8.0" 
$ns at 743.7826700861793 "$node_(690) setdest 12424 27230 2.0" 
$ns at 778.4523481771994 "$node_(690) setdest 91287 44542 13.0" 
$ns at 811.5373715692996 "$node_(690) setdest 21295 28653 18.0" 
$ns at 605.1052155500831 "$node_(691) setdest 66212 14649 14.0" 
$ns at 750.4264779795365 "$node_(691) setdest 78733 37748 17.0" 
$ns at 626.1746265709693 "$node_(692) setdest 90543 44071 13.0" 
$ns at 718.4630968217407 "$node_(692) setdest 105125 44331 17.0" 
$ns at 749.1886692539829 "$node_(692) setdest 37714 23793 16.0" 
$ns at 780.2822297088456 "$node_(692) setdest 93846 4371 4.0" 
$ns at 821.6874407452525 "$node_(692) setdest 82161 5495 19.0" 
$ns at 669.8986894448744 "$node_(693) setdest 119871 23934 17.0" 
$ns at 766.5301006290096 "$node_(693) setdest 133444 9432 13.0" 
$ns at 799.0158416604361 "$node_(693) setdest 122111 32212 13.0" 
$ns at 878.1303390020128 "$node_(693) setdest 103201 28963 8.0" 
$ns at 641.0620311444142 "$node_(694) setdest 31322 37939 9.0" 
$ns at 737.0809345871194 "$node_(694) setdest 84331 33507 3.0" 
$ns at 772.6102236448625 "$node_(694) setdest 111116 4423 5.0" 
$ns at 843.5983774474114 "$node_(694) setdest 125267 26767 1.0" 
$ns at 880.1426056116908 "$node_(694) setdest 69007 40263 17.0" 
$ns at 621.5185057462234 "$node_(695) setdest 24145 22423 1.0" 
$ns at 656.5697678288402 "$node_(695) setdest 20439 18209 6.0" 
$ns at 742.2324490891617 "$node_(695) setdest 43093 9307 11.0" 
$ns at 822.2428819962417 "$node_(695) setdest 110553 43011 9.0" 
$ns at 731.9503397700166 "$node_(696) setdest 51073 33448 2.0" 
$ns at 769.1555601631387 "$node_(696) setdest 673 24312 5.0" 
$ns at 818.6853992711774 "$node_(696) setdest 61010 34282 17.0" 
$ns at 875.2287301969394 "$node_(696) setdest 115360 3196 19.0" 
$ns at 621.8937326953103 "$node_(697) setdest 91876 16920 13.0" 
$ns at 779.83538152598 "$node_(697) setdest 170 24557 15.0" 
$ns at 880.41185378579 "$node_(697) setdest 1010 44282 11.0" 
$ns at 730.6442828018415 "$node_(698) setdest 102616 4303 6.0" 
$ns at 776.0830647090359 "$node_(698) setdest 2413 33039 2.0" 
$ns at 806.1384008571579 "$node_(698) setdest 47131 23917 1.0" 
$ns at 840.579402981855 "$node_(698) setdest 61638 13773 6.0" 
$ns at 892.6835621230067 "$node_(698) setdest 14801 15700 18.0" 
$ns at 643.128817051749 "$node_(699) setdest 51095 25953 4.0" 
$ns at 675.1455429918655 "$node_(699) setdest 102038 33016 19.0" 
$ns at 792.3700971828937 "$node_(699) setdest 2935 22 1.0" 
$ns at 831.5589720480083 "$node_(699) setdest 18193 18252 11.0" 
$ns at 866.0617263397123 "$node_(699) setdest 78481 19986 6.0" 
$ns at 850.6301497276039 "$node_(700) setdest 118618 6861 19.0" 
$ns at 897.9207363932132 "$node_(700) setdest 20434 40502 15.0" 
$ns at 709.9788704406942 "$node_(701) setdest 97765 25166 14.0" 
$ns at 746.8729666396948 "$node_(701) setdest 80219 39556 6.0" 
$ns at 823.3882324487735 "$node_(701) setdest 59804 34688 18.0" 
$ns at 819.4838202000282 "$node_(702) setdest 12457 19069 15.0" 
$ns at 723.6875748457448 "$node_(703) setdest 120919 7774 13.0" 
$ns at 849.0307938152489 "$node_(703) setdest 132240 19877 12.0" 
$ns at 794.4715991508448 "$node_(704) setdest 88039 10728 1.0" 
$ns at 832.3049144754929 "$node_(704) setdest 81573 5570 17.0" 
$ns at 735.7646852134005 "$node_(705) setdest 97649 17325 5.0" 
$ns at 804.9403240447384 "$node_(705) setdest 128268 22478 16.0" 
$ns at 898.4534455159279 "$node_(705) setdest 69496 14733 8.0" 
$ns at 723.2569866140178 "$node_(706) setdest 123249 12025 3.0" 
$ns at 773.3388014609079 "$node_(706) setdest 17654 43287 20.0" 
$ns at 849.9903970078066 "$node_(706) setdest 9157 582 6.0" 
$ns at 881.108352964942 "$node_(706) setdest 72043 28887 4.0" 
$ns at 722.5127404568935 "$node_(707) setdest 97207 34999 4.0" 
$ns at 782.4119894182899 "$node_(707) setdest 16127 10159 19.0" 
$ns at 815.8871180346389 "$node_(707) setdest 56850 30717 13.0" 
$ns at 850.6604233300143 "$node_(707) setdest 54486 27292 7.0" 
$ns at 881.4929639474992 "$node_(707) setdest 91701 16408 12.0" 
$ns at 736.4304249474259 "$node_(708) setdest 14164 34038 13.0" 
$ns at 781.0783468066762 "$node_(708) setdest 16068 37991 14.0" 
$ns at 875.8507804274229 "$node_(708) setdest 80294 20224 3.0" 
$ns at 752.4736012868956 "$node_(709) setdest 10998 24565 19.0" 
$ns at 875.4803299485162 "$node_(709) setdest 62705 15023 12.0" 
$ns at 724.3297139789044 "$node_(710) setdest 15654 14671 7.0" 
$ns at 808.293944518235 "$node_(710) setdest 121527 15467 9.0" 
$ns at 883.4524489764588 "$node_(710) setdest 118988 21877 1.0" 
$ns at 710.2368792942591 "$node_(711) setdest 102635 25441 9.0" 
$ns at 791.5217820631707 "$node_(711) setdest 7069 13687 5.0" 
$ns at 822.6225710998148 "$node_(711) setdest 44937 3412 6.0" 
$ns at 899.3382678803017 "$node_(711) setdest 68423 14509 11.0" 
$ns at 762.1267104004812 "$node_(712) setdest 60312 3927 18.0" 
$ns at 843.7419110157546 "$node_(712) setdest 57271 28860 7.0" 
$ns at 819.950921165844 "$node_(713) setdest 127829 7144 6.0" 
$ns at 871.0904906350041 "$node_(713) setdest 79779 40174 4.0" 
$ns at 759.074883146388 "$node_(714) setdest 94294 41967 18.0" 
$ns at 719.0913934855138 "$node_(715) setdest 3464 8258 7.0" 
$ns at 806.884105209974 "$node_(715) setdest 6939 36087 2.0" 
$ns at 846.4164755348266 "$node_(715) setdest 57265 1782 2.0" 
$ns at 896.3469071130152 "$node_(715) setdest 132580 6082 10.0" 
$ns at 700.460747827697 "$node_(716) setdest 128510 20678 15.0" 
$ns at 868.3722405628492 "$node_(716) setdest 41231 40834 9.0" 
$ns at 706.9585276912769 "$node_(717) setdest 3910 12994 4.0" 
$ns at 737.6949658657753 "$node_(717) setdest 7874 39690 7.0" 
$ns at 776.829553485373 "$node_(717) setdest 61884 18072 2.0" 
$ns at 808.4278393319644 "$node_(717) setdest 61096 111 11.0" 
$ns at 704.8121131475252 "$node_(718) setdest 119758 20159 10.0" 
$ns at 782.3046108452952 "$node_(718) setdest 121262 43744 2.0" 
$ns at 831.8744755351715 "$node_(718) setdest 32680 19762 13.0" 
$ns at 862.9285984057201 "$node_(718) setdest 1128 13562 20.0" 
$ns at 727.2004198556237 "$node_(719) setdest 128623 29546 1.0" 
$ns at 758.4517313050922 "$node_(719) setdest 115363 40268 5.0" 
$ns at 837.4436022761811 "$node_(719) setdest 123983 29527 18.0" 
$ns at 746.184826174241 "$node_(720) setdest 70971 43967 12.0" 
$ns at 832.875751725629 "$node_(720) setdest 13492 27157 10.0" 
$ns at 740.658323134247 "$node_(721) setdest 3723 11996 4.0" 
$ns at 780.8596226572529 "$node_(721) setdest 115417 2842 3.0" 
$ns at 824.7040442177614 "$node_(721) setdest 78708 27639 16.0" 
$ns at 857.1486719346963 "$node_(721) setdest 78218 10762 5.0" 
$ns at 746.6513531542145 "$node_(722) setdest 107357 23015 8.0" 
$ns at 825.4178936851589 "$node_(722) setdest 67290 5994 19.0" 
$ns at 736.8026918030044 "$node_(723) setdest 9903 26501 20.0" 
$ns at 858.9230520496071 "$node_(723) setdest 28812 39705 14.0" 
$ns at 753.2079017433922 "$node_(724) setdest 71871 40501 15.0" 
$ns at 891.888496768706 "$node_(724) setdest 7019 24516 2.0" 
$ns at 789.9605736347305 "$node_(725) setdest 25484 32604 5.0" 
$ns at 858.4279048320468 "$node_(725) setdest 132246 5383 4.0" 
$ns at 776.9631215554896 "$node_(726) setdest 69813 36739 1.0" 
$ns at 814.9245005411541 "$node_(726) setdest 122313 44563 14.0" 
$ns at 709.2112759238717 "$node_(727) setdest 64016 18171 14.0" 
$ns at 778.1166616696291 "$node_(727) setdest 128479 44443 10.0" 
$ns at 888.6671338588199 "$node_(727) setdest 33833 43890 12.0" 
$ns at 843.9122244766297 "$node_(728) setdest 106693 21909 10.0" 
$ns at 701.9825541072584 "$node_(729) setdest 1806 11931 1.0" 
$ns at 737.535371951918 "$node_(729) setdest 4957 18278 13.0" 
$ns at 808.500432994756 "$node_(729) setdest 35297 34174 14.0" 
$ns at 867.6646429751086 "$node_(729) setdest 8867 23419 19.0" 
$ns at 700.4171185884492 "$node_(730) setdest 19756 24460 14.0" 
$ns at 848.995051818537 "$node_(730) setdest 75517 19048 14.0" 
$ns at 716.333185791331 "$node_(731) setdest 4452 8071 2.0" 
$ns at 765.3719308947203 "$node_(731) setdest 40700 41475 15.0" 
$ns at 782.6536362043423 "$node_(732) setdest 106586 12827 14.0" 
$ns at 826.708869929361 "$node_(732) setdest 38519 35530 5.0" 
$ns at 858.7028457773016 "$node_(732) setdest 117307 29192 16.0" 
$ns at 742.0686700176319 "$node_(733) setdest 88011 19475 5.0" 
$ns at 800.3772504275818 "$node_(733) setdest 99145 41953 6.0" 
$ns at 871.9174607601849 "$node_(733) setdest 113592 34718 19.0" 
$ns at 714.5422617982834 "$node_(734) setdest 12900 12627 18.0" 
$ns at 881.5680290600205 "$node_(734) setdest 73602 27283 20.0" 
$ns at 731.7852358697462 "$node_(735) setdest 88053 43870 3.0" 
$ns at 768.1098143225664 "$node_(735) setdest 81411 18070 18.0" 
$ns at 828.5400397918498 "$node_(735) setdest 34991 14014 3.0" 
$ns at 876.4124369310252 "$node_(735) setdest 35711 37726 13.0" 
$ns at 771.4858048678196 "$node_(736) setdest 30297 20622 1.0" 
$ns at 808.0427187454882 "$node_(736) setdest 99508 12806 5.0" 
$ns at 873.3512247960805 "$node_(736) setdest 328 17923 17.0" 
$ns at 787.2924187188405 "$node_(737) setdest 68650 19323 1.0" 
$ns at 826.288699396174 "$node_(737) setdest 95964 19138 11.0" 
$ns at 768.6322093102635 "$node_(738) setdest 22678 18502 15.0" 
$ns at 886.9187866976343 "$node_(738) setdest 85416 10574 11.0" 
$ns at 706.3500686198456 "$node_(739) setdest 44352 11533 13.0" 
$ns at 862.8695425625199 "$node_(739) setdest 113506 22169 2.0" 
$ns at 899.8460907265721 "$node_(739) setdest 76420 7632 5.0" 
$ns at 736.0598585754491 "$node_(740) setdest 61868 38513 6.0" 
$ns at 778.2960365981489 "$node_(740) setdest 25852 26745 6.0" 
$ns at 849.8270447832858 "$node_(740) setdest 42577 21559 8.0" 
$ns at 782.8551484634826 "$node_(741) setdest 32444 14728 9.0" 
$ns at 876.8191941423688 "$node_(741) setdest 101176 35779 20.0" 
$ns at 751.8733847187915 "$node_(742) setdest 63596 35001 10.0" 
$ns at 834.5442818640955 "$node_(742) setdest 81355 6606 15.0" 
$ns at 757.375584764246 "$node_(743) setdest 46661 33690 14.0" 
$ns at 867.8599819923387 "$node_(743) setdest 42747 17681 18.0" 
$ns at 719.1450730657283 "$node_(744) setdest 25218 24176 16.0" 
$ns at 885.3197932778648 "$node_(744) setdest 78404 25016 1.0" 
$ns at 790.4110152004449 "$node_(745) setdest 28504 18507 16.0" 
$ns at 711.0051446318773 "$node_(746) setdest 98422 7776 4.0" 
$ns at 744.569156364959 "$node_(746) setdest 12799 42020 18.0" 
$ns at 850.2769322644205 "$node_(746) setdest 50789 11539 10.0" 
$ns at 773.0644428202621 "$node_(747) setdest 52117 5222 20.0" 
$ns at 892.7522341166336 "$node_(747) setdest 12717 39317 2.0" 
$ns at 700.3692384263182 "$node_(748) setdest 57086 13799 5.0" 
$ns at 770.0698470132457 "$node_(748) setdest 65661 42406 16.0" 
$ns at 892.2440272164738 "$node_(748) setdest 67881 32506 3.0" 
$ns at 700.2548102594535 "$node_(750) setdest 19668 16605 17.0" 
$ns at 847.2371707959737 "$node_(750) setdest 119911 15688 7.0" 
$ns at 734.2990894796767 "$node_(751) setdest 65330 40127 11.0" 
$ns at 791.3683236896126 "$node_(751) setdest 130708 35128 7.0" 
$ns at 838.6155395052067 "$node_(751) setdest 35161 20535 4.0" 
$ns at 707.7064462073794 "$node_(752) setdest 10468 22616 5.0" 
$ns at 778.4234699873003 "$node_(752) setdest 70012 27128 19.0" 
$ns at 713.529888707208 "$node_(753) setdest 42490 37008 19.0" 
$ns at 811.0532795301399 "$node_(753) setdest 66184 1435 4.0" 
$ns at 855.9751982993807 "$node_(753) setdest 76414 29168 1.0" 
$ns at 890.2844216508701 "$node_(753) setdest 53946 42172 14.0" 
$ns at 722.744353065857 "$node_(754) setdest 116373 4923 12.0" 
$ns at 803.1179561789272 "$node_(754) setdest 61480 7950 1.0" 
$ns at 840.9081690264172 "$node_(754) setdest 80781 12099 8.0" 
$ns at 728.5722044034248 "$node_(755) setdest 49303 32212 18.0" 
$ns at 786.5354607156945 "$node_(755) setdest 31947 38066 2.0" 
$ns at 832.2428958215585 "$node_(755) setdest 69211 33977 14.0" 
$ns at 760.8995507765904 "$node_(756) setdest 67398 40482 6.0" 
$ns at 814.7537949928751 "$node_(756) setdest 8092 10376 11.0" 
$ns at 892.1690384608951 "$node_(756) setdest 80196 30942 4.0" 
$ns at 710.073379640547 "$node_(757) setdest 95097 17633 2.0" 
$ns at 748.6685448369825 "$node_(757) setdest 121159 16537 2.0" 
$ns at 798.2311851555286 "$node_(757) setdest 80775 34523 1.0" 
$ns at 837.5077784545285 "$node_(757) setdest 131578 5058 7.0" 
$ns at 872.8560327757903 "$node_(757) setdest 23087 3564 18.0" 
$ns at 709.7597985503153 "$node_(758) setdest 79288 9603 6.0" 
$ns at 742.01761088868 "$node_(758) setdest 72753 26028 8.0" 
$ns at 782.278775592792 "$node_(758) setdest 56895 28695 11.0" 
$ns at 878.8204149128914 "$node_(758) setdest 36709 32314 7.0" 
$ns at 715.5519957254237 "$node_(759) setdest 51267 11201 6.0" 
$ns at 802.1254753783342 "$node_(759) setdest 55411 43384 2.0" 
$ns at 837.6181069709896 "$node_(759) setdest 15664 25332 17.0" 
$ns at 744.2678829526708 "$node_(760) setdest 75497 26452 11.0" 
$ns at 816.1525917586041 "$node_(760) setdest 116742 33043 4.0" 
$ns at 852.0464481197067 "$node_(760) setdest 95446 29131 18.0" 
$ns at 708.343701680096 "$node_(761) setdest 10306 41938 9.0" 
$ns at 770.7970828777962 "$node_(761) setdest 10581 42950 19.0" 
$ns at 851.4259951753102 "$node_(761) setdest 69677 15289 6.0" 
$ns at 728.707395726819 "$node_(762) setdest 83549 12164 3.0" 
$ns at 765.3967738443455 "$node_(762) setdest 53758 8047 11.0" 
$ns at 764.1351284132163 "$node_(763) setdest 72860 18936 9.0" 
$ns at 864.4724322642522 "$node_(763) setdest 9485 23646 2.0" 
$ns at 895.3086281065855 "$node_(763) setdest 22557 24637 12.0" 
$ns at 797.9564927558808 "$node_(764) setdest 40716 11418 7.0" 
$ns at 877.009056061786 "$node_(764) setdest 82977 33432 13.0" 
$ns at 719.859172123453 "$node_(765) setdest 3745 25910 3.0" 
$ns at 756.4836705492443 "$node_(765) setdest 7890 39635 6.0" 
$ns at 807.7724094324954 "$node_(765) setdest 12318 34347 1.0" 
$ns at 847.6056747804654 "$node_(765) setdest 59728 21462 19.0" 
$ns at 890.2073178136318 "$node_(765) setdest 114676 15166 9.0" 
$ns at 738.4639951029856 "$node_(766) setdest 63397 40062 3.0" 
$ns at 781.5486273582227 "$node_(766) setdest 107540 29521 1.0" 
$ns at 815.0298637926882 "$node_(766) setdest 101940 5362 1.0" 
$ns at 850.4435211899179 "$node_(766) setdest 51697 40274 2.0" 
$ns at 881.145144048677 "$node_(766) setdest 127427 8874 8.0" 
$ns at 842.2975313983759 "$node_(767) setdest 4239 9057 18.0" 
$ns at 730.2614351851093 "$node_(768) setdest 94160 16642 19.0" 
$ns at 841.7535946745636 "$node_(768) setdest 123964 17165 12.0" 
$ns at 710.8168268964574 "$node_(769) setdest 37436 18127 14.0" 
$ns at 783.335226765072 "$node_(769) setdest 55078 26248 5.0" 
$ns at 839.0427696179818 "$node_(769) setdest 4400 40299 19.0" 
$ns at 762.1636851717059 "$node_(770) setdest 6925 31342 18.0" 
$ns at 805.1373477707579 "$node_(770) setdest 90172 4151 2.0" 
$ns at 841.495541669607 "$node_(770) setdest 15616 35417 13.0" 
$ns at 879.887126837992 "$node_(770) setdest 97419 5811 1.0" 
$ns at 755.8984646109903 "$node_(771) setdest 68416 19424 18.0" 
$ns at 729.2237944004446 "$node_(772) setdest 94516 40905 10.0" 
$ns at 819.793578212836 "$node_(772) setdest 48257 40235 13.0" 
$ns at 883.8544414264113 "$node_(772) setdest 11884 34687 3.0" 
$ns at 705.0849517606717 "$node_(773) setdest 122767 262 4.0" 
$ns at 761.4311019440655 "$node_(773) setdest 52933 13448 1.0" 
$ns at 798.2430523734306 "$node_(773) setdest 12936 31176 3.0" 
$ns at 829.1972835897046 "$node_(773) setdest 18709 26916 10.0" 
$ns at 899.040957366791 "$node_(773) setdest 120463 37913 15.0" 
$ns at 713.1590254098384 "$node_(774) setdest 92259 10916 8.0" 
$ns at 781.0908466050525 "$node_(774) setdest 98490 12587 6.0" 
$ns at 857.2330527027503 "$node_(774) setdest 33960 11814 15.0" 
$ns at 704.1201623141372 "$node_(775) setdest 38151 41165 3.0" 
$ns at 756.6514523528757 "$node_(775) setdest 48190 19151 12.0" 
$ns at 862.1585735454859 "$node_(775) setdest 32434 36439 17.0" 
$ns at 703.6904604011455 "$node_(776) setdest 56843 91 19.0" 
$ns at 781.2272793407385 "$node_(776) setdest 62045 17157 2.0" 
$ns at 813.8648281314822 "$node_(776) setdest 35647 22808 1.0" 
$ns at 844.1702212541958 "$node_(776) setdest 98220 7605 2.0" 
$ns at 890.9893006038615 "$node_(776) setdest 84015 11264 1.0" 
$ns at 726.3076105153943 "$node_(777) setdest 90206 19185 8.0" 
$ns at 796.9308379043435 "$node_(777) setdest 121957 18533 1.0" 
$ns at 830.3945381668116 "$node_(777) setdest 71062 30374 3.0" 
$ns at 874.1964564412885 "$node_(777) setdest 92117 41429 8.0" 
$ns at 707.9157961186144 "$node_(778) setdest 112141 29343 3.0" 
$ns at 760.0765445307212 "$node_(778) setdest 95242 30661 7.0" 
$ns at 840.6870663899545 "$node_(778) setdest 130095 24663 9.0" 
$ns at 874.6976200543203 "$node_(778) setdest 86549 21386 5.0" 
$ns at 719.1120820702963 "$node_(779) setdest 86073 27243 6.0" 
$ns at 768.0892204557992 "$node_(779) setdest 112003 33832 8.0" 
$ns at 872.4469814575363 "$node_(779) setdest 28330 29825 3.0" 
$ns at 739.0530203419574 "$node_(780) setdest 133096 1381 19.0" 
$ns at 831.3328673692793 "$node_(780) setdest 98009 32805 18.0" 
$ns at 805.416607610829 "$node_(781) setdest 77969 11994 2.0" 
$ns at 852.864885870029 "$node_(781) setdest 65962 35709 3.0" 
$ns at 709.5033480063873 "$node_(782) setdest 27216 23164 15.0" 
$ns at 819.500559752549 "$node_(782) setdest 65708 4676 14.0" 
$ns at 884.3110583569347 "$node_(782) setdest 115126 22222 6.0" 
$ns at 709.2920934175886 "$node_(783) setdest 53774 12760 8.0" 
$ns at 774.4184657200229 "$node_(783) setdest 39945 31280 6.0" 
$ns at 833.0556228858759 "$node_(783) setdest 89389 32777 8.0" 
$ns at 888.0259954813029 "$node_(783) setdest 13066 23498 17.0" 
$ns at 804.410641054088 "$node_(784) setdest 42481 23498 18.0" 
$ns at 895.3075740353833 "$node_(784) setdest 113135 198 17.0" 
$ns at 755.2992010306856 "$node_(785) setdest 19390 2438 16.0" 
$ns at 883.5385599765435 "$node_(785) setdest 19032 23517 19.0" 
$ns at 765.8470303079325 "$node_(786) setdest 127957 23420 4.0" 
$ns at 814.5910186071887 "$node_(786) setdest 24019 7379 6.0" 
$ns at 873.7705832320975 "$node_(786) setdest 38368 14849 15.0" 
$ns at 744.0217812735757 "$node_(787) setdest 24669 27045 2.0" 
$ns at 793.8092503038563 "$node_(787) setdest 81258 2654 5.0" 
$ns at 862.5208206824366 "$node_(787) setdest 5388 32609 1.0" 
$ns at 717.8918249336082 "$node_(788) setdest 108734 25647 1.0" 
$ns at 750.9596649943352 "$node_(788) setdest 4992 34300 11.0" 
$ns at 883.8414310358309 "$node_(788) setdest 10915 17436 18.0" 
$ns at 714.0202212950962 "$node_(789) setdest 95895 9416 3.0" 
$ns at 747.7422560864269 "$node_(789) setdest 36290 34523 7.0" 
$ns at 803.7753301674506 "$node_(789) setdest 106361 31552 11.0" 
$ns at 857.7452019400404 "$node_(789) setdest 100250 19218 2.0" 
$ns at 895.9131888937261 "$node_(789) setdest 120362 5205 9.0" 
$ns at 785.1880958237549 "$node_(790) setdest 94481 23589 5.0" 
$ns at 820.9304171771494 "$node_(790) setdest 89323 4548 5.0" 
$ns at 854.5598846065091 "$node_(790) setdest 71682 8937 8.0" 
$ns at 893.1057844387527 "$node_(790) setdest 88764 1237 15.0" 
$ns at 727.6365125159044 "$node_(791) setdest 20493 13133 13.0" 
$ns at 758.9456634532586 "$node_(791) setdest 98787 36583 6.0" 
$ns at 805.1626677708173 "$node_(791) setdest 78483 19313 9.0" 
$ns at 865.0107392396698 "$node_(791) setdest 41022 10603 5.0" 
$ns at 784.5006381940227 "$node_(792) setdest 88895 11592 1.0" 
$ns at 823.497245406144 "$node_(792) setdest 84595 34118 2.0" 
$ns at 869.9960736067707 "$node_(792) setdest 62037 24684 10.0" 
$ns at 787.6077939677185 "$node_(793) setdest 11884 20564 14.0" 
$ns at 843.3751699991832 "$node_(793) setdest 27110 20010 14.0" 
$ns at 883.2969035013346 "$node_(793) setdest 100853 40185 15.0" 
$ns at 783.6263551929837 "$node_(794) setdest 37325 13753 19.0" 
$ns at 830.7294578198798 "$node_(794) setdest 42233 36179 14.0" 
$ns at 871.2115760584082 "$node_(794) setdest 74966 11672 9.0" 
$ns at 722.1787837875851 "$node_(795) setdest 45496 28554 17.0" 
$ns at 899.8590339303613 "$node_(795) setdest 80578 7441 14.0" 
$ns at 792.5403368116237 "$node_(796) setdest 126120 11951 11.0" 
$ns at 758.6598925337466 "$node_(797) setdest 127270 36018 3.0" 
$ns at 799.1786466984969 "$node_(797) setdest 71944 26447 17.0" 
$ns at 861.6154491673135 "$node_(797) setdest 79143 29665 4.0" 
$ns at 892.3803947778829 "$node_(797) setdest 62541 22395 16.0" 
$ns at 744.4320684369998 "$node_(798) setdest 110857 3707 6.0" 
$ns at 778.3724165172001 "$node_(798) setdest 107530 2398 4.0" 
$ns at 819.695804587436 "$node_(798) setdest 71741 12610 13.0" 
$ns at 735.1276546737706 "$node_(799) setdest 34113 21540 9.0" 
$ns at 849.7490986932573 "$node_(799) setdest 129263 23250 3.0" 
$ns at 885.7968086172591 "$node_(799) setdest 51281 35863 18.0" 


#Set a TCP connection between node_(39) and node_(48)
set tcp_(0) [new Agent/TCP/Newreno]
$tcp_(0) set class_ 2
set sink_(0) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(0)
$ns attach-agent $node_(48) $sink_(0)
$ns connect $tcp_(0) $sink_(0)
set ftp_(0) [new Application/FTP]
$ftp_(0) attach-agent $tcp_(0)
$ns at 0.2 "$ftp_(0) start"
$ns at 180.0 "$ftp_(0) stop"

#Set a TCP connection between node_(66) and node_(26)
set tcp_(1) [new Agent/TCP/Newreno]
$tcp_(1) set class_ 2
set sink_(1) [new Agent/TCPSink]
$ns attach-agent $node_(66) $tcp_(1)
$ns attach-agent $node_(26) $sink_(1)
$ns connect $tcp_(1) $sink_(1)
set ftp_(1) [new Application/FTP]
$ftp_(1) attach-agent $tcp_(1)
$ns at 180.2 "$ftp_(1) start"
$ns at 360.0 "$ftp_(1) stop"

#Set a TCP connection between node_(48) and node_(22)
set tcp_(2) [new Agent/TCP/Newreno]
$tcp_(2) set class_ 2
set sink_(2) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(2)
$ns attach-agent $node_(22) $sink_(2)
$ns connect $tcp_(2) $sink_(2)
set ftp_(2) [new Application/FTP]
$ftp_(2) attach-agent $tcp_(2)
$ns at 360.2 "$ftp_(2) start"
$ns at 540.0 "$ftp_(2) stop"

#Set a TCP connection between node_(59) and node_(66)
set tcp_(3) [new Agent/TCP/Newreno]
$tcp_(3) set class_ 2
set sink_(3) [new Agent/TCPSink]
$ns attach-agent $node_(59) $tcp_(3)
$ns attach-agent $node_(66) $sink_(3)
$ns connect $tcp_(3) $sink_(3)
set ftp_(3) [new Application/FTP]
$ftp_(3) attach-agent $tcp_(3)
$ns at 540.2 "$ftp_(3) start"
$ns at 720.0 "$ftp_(3) stop"

#Set a TCP connection between node_(63) and node_(45)
set tcp_(4) [new Agent/TCP/Newreno]
$tcp_(4) set class_ 2
set sink_(4) [new Agent/TCPSink]
$ns attach-agent $node_(63) $tcp_(4)
$ns attach-agent $node_(45) $sink_(4)
$ns connect $tcp_(4) $sink_(4)
set ftp_(4) [new Application/FTP]
$ftp_(4) attach-agent $tcp_(4)
$ns at 720.2 "$ftp_(4) start"
$ns at 900.0 "$ftp_(4) stop"

#Set a TCP connection between node_(40) and node_(85)
set tcp_(5) [new Agent/TCP/Newreno]
$tcp_(5) set class_ 2
set sink_(5) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(5)
$ns attach-agent $node_(85) $sink_(5)
$ns connect $tcp_(5) $sink_(5)
set ftp_(5) [new Application/FTP]
$ftp_(5) attach-agent $tcp_(5)
$ns at 0.2 "$ftp_(5) start"
$ns at 180.0 "$ftp_(5) stop"

#Set a TCP connection between node_(62) and node_(13)
set tcp_(6) [new Agent/TCP/Newreno]
$tcp_(6) set class_ 2
set sink_(6) [new Agent/TCPSink]
$ns attach-agent $node_(62) $tcp_(6)
$ns attach-agent $node_(13) $sink_(6)
$ns connect $tcp_(6) $sink_(6)
set ftp_(6) [new Application/FTP]
$ftp_(6) attach-agent $tcp_(6)
$ns at 180.2 "$ftp_(6) start"
$ns at 360.0 "$ftp_(6) stop"

#Set a TCP connection between node_(3) and node_(20)
set tcp_(7) [new Agent/TCP/Newreno]
$tcp_(7) set class_ 2
set sink_(7) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(7)
$ns attach-agent $node_(20) $sink_(7)
$ns connect $tcp_(7) $sink_(7)
set ftp_(7) [new Application/FTP]
$ftp_(7) attach-agent $tcp_(7)
$ns at 360.2 "$ftp_(7) start"
$ns at 540.0 "$ftp_(7) stop"

#Set a TCP connection between node_(33) and node_(97)
set tcp_(8) [new Agent/TCP/Newreno]
$tcp_(8) set class_ 2
set sink_(8) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(8)
$ns attach-agent $node_(97) $sink_(8)
$ns connect $tcp_(8) $sink_(8)
set ftp_(8) [new Application/FTP]
$ftp_(8) attach-agent $tcp_(8)
$ns at 540.2 "$ftp_(8) start"
$ns at 720.0 "$ftp_(8) stop"

#Set a TCP connection between node_(15) and node_(81)
set tcp_(9) [new Agent/TCP/Newreno]
$tcp_(9) set class_ 2
set sink_(9) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(9)
$ns attach-agent $node_(81) $sink_(9)
$ns connect $tcp_(9) $sink_(9)
set ftp_(9) [new Application/FTP]
$ftp_(9) attach-agent $tcp_(9)
$ns at 720.2 "$ftp_(9) start"
$ns at 900.0 "$ftp_(9) stop"

#Set a TCP connection between node_(27) and node_(68)
set tcp_(10) [new Agent/TCP/Newreno]
$tcp_(10) set class_ 2
set sink_(10) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(10)
$ns attach-agent $node_(68) $sink_(10)
$ns connect $tcp_(10) $sink_(10)
set ftp_(10) [new Application/FTP]
$ftp_(10) attach-agent $tcp_(10)
$ns at 0.2 "$ftp_(10) start"
$ns at 180.0 "$ftp_(10) stop"

#Set a TCP connection between node_(51) and node_(60)
set tcp_(11) [new Agent/TCP/Newreno]
$tcp_(11) set class_ 2
set sink_(11) [new Agent/TCPSink]
$ns attach-agent $node_(51) $tcp_(11)
$ns attach-agent $node_(60) $sink_(11)
$ns connect $tcp_(11) $sink_(11)
set ftp_(11) [new Application/FTP]
$ftp_(11) attach-agent $tcp_(11)
$ns at 180.2 "$ftp_(11) start"
$ns at 360.0 "$ftp_(11) stop"

#Set a TCP connection between node_(28) and node_(82)
set tcp_(12) [new Agent/TCP/Newreno]
$tcp_(12) set class_ 2
set sink_(12) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(12)
$ns attach-agent $node_(82) $sink_(12)
$ns connect $tcp_(12) $sink_(12)
set ftp_(12) [new Application/FTP]
$ftp_(12) attach-agent $tcp_(12)
$ns at 360.2 "$ftp_(12) start"
$ns at 540.0 "$ftp_(12) stop"

#Set a TCP connection between node_(82) and node_(1)
set tcp_(13) [new Agent/TCP/Newreno]
$tcp_(13) set class_ 2
set sink_(13) [new Agent/TCPSink]
$ns attach-agent $node_(82) $tcp_(13)
$ns attach-agent $node_(1) $sink_(13)
$ns connect $tcp_(13) $sink_(13)
set ftp_(13) [new Application/FTP]
$ftp_(13) attach-agent $tcp_(13)
$ns at 540.2 "$ftp_(13) start"
$ns at 720.0 "$ftp_(13) stop"

#Set a TCP connection between node_(77) and node_(64)
set tcp_(14) [new Agent/TCP/Newreno]
$tcp_(14) set class_ 2
set sink_(14) [new Agent/TCPSink]
$ns attach-agent $node_(77) $tcp_(14)
$ns attach-agent $node_(64) $sink_(14)
$ns connect $tcp_(14) $sink_(14)
set ftp_(14) [new Application/FTP]
$ftp_(14) attach-agent $tcp_(14)
$ns at 720.2 "$ftp_(14) start"
$ns at 900.0 "$ftp_(14) stop"

#Set a TCP connection between node_(40) and node_(92)
set tcp_(15) [new Agent/TCP/Newreno]
$tcp_(15) set class_ 2
set sink_(15) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(15)
$ns attach-agent $node_(92) $sink_(15)
$ns connect $tcp_(15) $sink_(15)
set ftp_(15) [new Application/FTP]
$ftp_(15) attach-agent $tcp_(15)
$ns at 0.2 "$ftp_(15) start"
$ns at 180.0 "$ftp_(15) stop"

#Set a TCP connection between node_(26) and node_(76)
set tcp_(16) [new Agent/TCP/Newreno]
$tcp_(16) set class_ 2
set sink_(16) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(16)
$ns attach-agent $node_(76) $sink_(16)
$ns connect $tcp_(16) $sink_(16)
set ftp_(16) [new Application/FTP]
$ftp_(16) attach-agent $tcp_(16)
$ns at 180.2 "$ftp_(16) start"
$ns at 360.0 "$ftp_(16) stop"

#Set a TCP connection between node_(41) and node_(20)
set tcp_(17) [new Agent/TCP/Newreno]
$tcp_(17) set class_ 2
set sink_(17) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(17)
$ns attach-agent $node_(20) $sink_(17)
$ns connect $tcp_(17) $sink_(17)
set ftp_(17) [new Application/FTP]
$ftp_(17) attach-agent $tcp_(17)
$ns at 360.2 "$ftp_(17) start"
$ns at 540.0 "$ftp_(17) stop"

#Set a TCP connection between node_(33) and node_(49)
set tcp_(18) [new Agent/TCP/Newreno]
$tcp_(18) set class_ 2
set sink_(18) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(18)
$ns attach-agent $node_(49) $sink_(18)
$ns connect $tcp_(18) $sink_(18)
set ftp_(18) [new Application/FTP]
$ftp_(18) attach-agent $tcp_(18)
$ns at 540.2 "$ftp_(18) start"
$ns at 720.0 "$ftp_(18) stop"

#Set a TCP connection between node_(86) and node_(97)
set tcp_(19) [new Agent/TCP/Newreno]
$tcp_(19) set class_ 2
set sink_(19) [new Agent/TCPSink]
$ns attach-agent $node_(86) $tcp_(19)
$ns attach-agent $node_(97) $sink_(19)
$ns connect $tcp_(19) $sink_(19)
set ftp_(19) [new Application/FTP]
$ftp_(19) attach-agent $tcp_(19)
$ns at 720.2 "$ftp_(19) start"
$ns at 900.0 "$ftp_(19) stop"

#Set a TCP connection between node_(42) and node_(39)
set tcp_(20) [new Agent/TCP/Newreno]
$tcp_(20) set class_ 2
set sink_(20) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(20)
$ns attach-agent $node_(39) $sink_(20)
$ns connect $tcp_(20) $sink_(20)
set ftp_(20) [new Application/FTP]
$ftp_(20) attach-agent $tcp_(20)
$ns at 0.2 "$ftp_(20) start"
$ns at 180.0 "$ftp_(20) stop"

#Set a TCP connection between node_(93) and node_(74)
set tcp_(21) [new Agent/TCP/Newreno]
$tcp_(21) set class_ 2
set sink_(21) [new Agent/TCPSink]
$ns attach-agent $node_(93) $tcp_(21)
$ns attach-agent $node_(74) $sink_(21)
$ns connect $tcp_(21) $sink_(21)
set ftp_(21) [new Application/FTP]
$ftp_(21) attach-agent $tcp_(21)
$ns at 180.2 "$ftp_(21) start"
$ns at 360.0 "$ftp_(21) stop"

#Set a TCP connection between node_(75) and node_(16)
set tcp_(22) [new Agent/TCP/Newreno]
$tcp_(22) set class_ 2
set sink_(22) [new Agent/TCPSink]
$ns attach-agent $node_(75) $tcp_(22)
$ns attach-agent $node_(16) $sink_(22)
$ns connect $tcp_(22) $sink_(22)
set ftp_(22) [new Application/FTP]
$ftp_(22) attach-agent $tcp_(22)
$ns at 360.2 "$ftp_(22) start"
$ns at 540.0 "$ftp_(22) stop"

#Set a TCP connection between node_(2) and node_(70)
set tcp_(23) [new Agent/TCP/Newreno]
$tcp_(23) set class_ 2
set sink_(23) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(23)
$ns attach-agent $node_(70) $sink_(23)
$ns connect $tcp_(23) $sink_(23)
set ftp_(23) [new Application/FTP]
$ftp_(23) attach-agent $tcp_(23)
$ns at 540.2 "$ftp_(23) start"
$ns at 720.0 "$ftp_(23) stop"

#Set a TCP connection between node_(10) and node_(77)
set tcp_(24) [new Agent/TCP/Newreno]
$tcp_(24) set class_ 2
set sink_(24) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(24)
$ns attach-agent $node_(77) $sink_(24)
$ns connect $tcp_(24) $sink_(24)
set ftp_(24) [new Application/FTP]
$ftp_(24) attach-agent $tcp_(24)
$ns at 720.2 "$ftp_(24) start"
$ns at 900.0 "$ftp_(24) stop"

#Set a TCP connection between node_(67) and node_(15)
set tcp_(25) [new Agent/TCP/Newreno]
$tcp_(25) set class_ 2
set sink_(25) [new Agent/TCPSink]
$ns attach-agent $node_(67) $tcp_(25)
$ns attach-agent $node_(15) $sink_(25)
$ns connect $tcp_(25) $sink_(25)
set ftp_(25) [new Application/FTP]
$ftp_(25) attach-agent $tcp_(25)
$ns at 0.2 "$ftp_(25) start"
$ns at 180.0 "$ftp_(25) stop"

#Set a TCP connection between node_(62) and node_(65)
set tcp_(26) [new Agent/TCP/Newreno]
$tcp_(26) set class_ 2
set sink_(26) [new Agent/TCPSink]
$ns attach-agent $node_(62) $tcp_(26)
$ns attach-agent $node_(65) $sink_(26)
$ns connect $tcp_(26) $sink_(26)
set ftp_(26) [new Application/FTP]
$ftp_(26) attach-agent $tcp_(26)
$ns at 180.2 "$ftp_(26) start"
$ns at 360.0 "$ftp_(26) stop"

#Set a TCP connection between node_(96) and node_(77)
set tcp_(27) [new Agent/TCP/Newreno]
$tcp_(27) set class_ 2
set sink_(27) [new Agent/TCPSink]
$ns attach-agent $node_(96) $tcp_(27)
$ns attach-agent $node_(77) $sink_(27)
$ns connect $tcp_(27) $sink_(27)
set ftp_(27) [new Application/FTP]
$ftp_(27) attach-agent $tcp_(27)
$ns at 360.2 "$ftp_(27) start"
$ns at 540.0 "$ftp_(27) stop"

#Set a TCP connection between node_(31) and node_(96)
set tcp_(28) [new Agent/TCP/Newreno]
$tcp_(28) set class_ 2
set sink_(28) [new Agent/TCPSink]
$ns attach-agent $node_(31) $tcp_(28)
$ns attach-agent $node_(96) $sink_(28)
$ns connect $tcp_(28) $sink_(28)
set ftp_(28) [new Application/FTP]
$ftp_(28) attach-agent $tcp_(28)
$ns at 540.2 "$ftp_(28) start"
$ns at 720.0 "$ftp_(28) stop"

#Set a TCP connection between node_(21) and node_(86)
set tcp_(29) [new Agent/TCP/Newreno]
$tcp_(29) set class_ 2
set sink_(29) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(29)
$ns attach-agent $node_(86) $sink_(29)
$ns connect $tcp_(29) $sink_(29)
set ftp_(29) [new Application/FTP]
$ftp_(29) attach-agent $tcp_(29)
$ns at 720.2 "$ftp_(29) start"
$ns at 900.0 "$ftp_(29) stop"

#Set a TCP connection between node_(78) and node_(18)
set tcp_(30) [new Agent/TCP/Newreno]
$tcp_(30) set class_ 2
set sink_(30) [new Agent/TCPSink]
$ns attach-agent $node_(78) $tcp_(30)
$ns attach-agent $node_(18) $sink_(30)
$ns connect $tcp_(30) $sink_(30)
set ftp_(30) [new Application/FTP]
$ftp_(30) attach-agent $tcp_(30)
$ns at 0.2 "$ftp_(30) start"
$ns at 180.0 "$ftp_(30) stop"

#Set a TCP connection between node_(44) and node_(24)
set tcp_(31) [new Agent/TCP/Newreno]
$tcp_(31) set class_ 2
set sink_(31) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(31)
$ns attach-agent $node_(24) $sink_(31)
$ns connect $tcp_(31) $sink_(31)
set ftp_(31) [new Application/FTP]
$ftp_(31) attach-agent $tcp_(31)
$ns at 180.2 "$ftp_(31) start"
$ns at 360.0 "$ftp_(31) stop"

#Set a TCP connection between node_(47) and node_(56)
set tcp_(32) [new Agent/TCP/Newreno]
$tcp_(32) set class_ 2
set sink_(32) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(32)
$ns attach-agent $node_(56) $sink_(32)
$ns connect $tcp_(32) $sink_(32)
set ftp_(32) [new Application/FTP]
$ftp_(32) attach-agent $tcp_(32)
$ns at 360.2 "$ftp_(32) start"
$ns at 540.0 "$ftp_(32) stop"

#Set a TCP connection between node_(12) and node_(85)
set tcp_(33) [new Agent/TCP/Newreno]
$tcp_(33) set class_ 2
set sink_(33) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(33)
$ns attach-agent $node_(85) $sink_(33)
$ns connect $tcp_(33) $sink_(33)
set ftp_(33) [new Application/FTP]
$ftp_(33) attach-agent $tcp_(33)
$ns at 540.2 "$ftp_(33) start"
$ns at 720.0 "$ftp_(33) stop"

#Set a TCP connection between node_(21) and node_(81)
set tcp_(34) [new Agent/TCP/Newreno]
$tcp_(34) set class_ 2
set sink_(34) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(34)
$ns attach-agent $node_(81) $sink_(34)
$ns connect $tcp_(34) $sink_(34)
set ftp_(34) [new Application/FTP]
$ftp_(34) attach-agent $tcp_(34)
$ns at 720.2 "$ftp_(34) start"
$ns at 900.0 "$ftp_(34) stop"

#Set a TCP connection between node_(94) and node_(47)
set tcp_(35) [new Agent/TCP/Newreno]
$tcp_(35) set class_ 2
set sink_(35) [new Agent/TCPSink]
$ns attach-agent $node_(94) $tcp_(35)
$ns attach-agent $node_(47) $sink_(35)
$ns connect $tcp_(35) $sink_(35)
set ftp_(35) [new Application/FTP]
$ftp_(35) attach-agent $tcp_(35)
$ns at 0.2 "$ftp_(35) start"
$ns at 180.0 "$ftp_(35) stop"

#Set a TCP connection between node_(6) and node_(91)
set tcp_(36) [new Agent/TCP/Newreno]
$tcp_(36) set class_ 2
set sink_(36) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(36)
$ns attach-agent $node_(91) $sink_(36)
$ns connect $tcp_(36) $sink_(36)
set ftp_(36) [new Application/FTP]
$ftp_(36) attach-agent $tcp_(36)
$ns at 180.2 "$ftp_(36) start"
$ns at 360.0 "$ftp_(36) stop"

#Set a TCP connection between node_(35) and node_(85)
set tcp_(37) [new Agent/TCP/Newreno]
$tcp_(37) set class_ 2
set sink_(37) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(37)
$ns attach-agent $node_(85) $sink_(37)
$ns connect $tcp_(37) $sink_(37)
set ftp_(37) [new Application/FTP]
$ftp_(37) attach-agent $tcp_(37)
$ns at 360.2 "$ftp_(37) start"
$ns at 540.0 "$ftp_(37) stop"

#Set a TCP connection between node_(63) and node_(73)
set tcp_(38) [new Agent/TCP/Newreno]
$tcp_(38) set class_ 2
set sink_(38) [new Agent/TCPSink]
$ns attach-agent $node_(63) $tcp_(38)
$ns attach-agent $node_(73) $sink_(38)
$ns connect $tcp_(38) $sink_(38)
set ftp_(38) [new Application/FTP]
$ftp_(38) attach-agent $tcp_(38)
$ns at 540.2 "$ftp_(38) start"
$ns at 720.0 "$ftp_(38) stop"

#Set a TCP connection between node_(55) and node_(98)
set tcp_(39) [new Agent/TCP/Newreno]
$tcp_(39) set class_ 2
set sink_(39) [new Agent/TCPSink]
$ns attach-agent $node_(55) $tcp_(39)
$ns attach-agent $node_(98) $sink_(39)
$ns connect $tcp_(39) $sink_(39)
set ftp_(39) [new Application/FTP]
$ftp_(39) attach-agent $tcp_(39)
$ns at 720.2 "$ftp_(39) start"
$ns at 900.0 "$ftp_(39) stop"

#Set a TCP connection between node_(10) and node_(74)
set tcp_(40) [new Agent/TCP/Newreno]
$tcp_(40) set class_ 2
set sink_(40) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(40)
$ns attach-agent $node_(74) $sink_(40)
$ns connect $tcp_(40) $sink_(40)
set ftp_(40) [new Application/FTP]
$ftp_(40) attach-agent $tcp_(40)
$ns at 0.2 "$ftp_(40) start"
$ns at 180.0 "$ftp_(40) stop"

#Set a TCP connection between node_(56) and node_(27)
set tcp_(41) [new Agent/TCP/Newreno]
$tcp_(41) set class_ 2
set sink_(41) [new Agent/TCPSink]
$ns attach-agent $node_(56) $tcp_(41)
$ns attach-agent $node_(27) $sink_(41)
$ns connect $tcp_(41) $sink_(41)
set ftp_(41) [new Application/FTP]
$ftp_(41) attach-agent $tcp_(41)
$ns at 180.2 "$ftp_(41) start"
$ns at 360.0 "$ftp_(41) stop"

#Set a TCP connection between node_(61) and node_(42)
set tcp_(42) [new Agent/TCP/Newreno]
$tcp_(42) set class_ 2
set sink_(42) [new Agent/TCPSink]
$ns attach-agent $node_(61) $tcp_(42)
$ns attach-agent $node_(42) $sink_(42)
$ns connect $tcp_(42) $sink_(42)
set ftp_(42) [new Application/FTP]
$ftp_(42) attach-agent $tcp_(42)
$ns at 360.2 "$ftp_(42) start"
$ns at 540.0 "$ftp_(42) stop"

#Set a TCP connection between node_(80) and node_(58)
set tcp_(43) [new Agent/TCP/Newreno]
$tcp_(43) set class_ 2
set sink_(43) [new Agent/TCPSink]
$ns attach-agent $node_(80) $tcp_(43)
$ns attach-agent $node_(58) $sink_(43)
$ns connect $tcp_(43) $sink_(43)
set ftp_(43) [new Application/FTP]
$ftp_(43) attach-agent $tcp_(43)
$ns at 540.2 "$ftp_(43) start"
$ns at 720.0 "$ftp_(43) stop"

#Set a TCP connection between node_(91) and node_(18)
set tcp_(44) [new Agent/TCP/Newreno]
$tcp_(44) set class_ 2
set sink_(44) [new Agent/TCPSink]
$ns attach-agent $node_(91) $tcp_(44)
$ns attach-agent $node_(18) $sink_(44)
$ns connect $tcp_(44) $sink_(44)
set ftp_(44) [new Application/FTP]
$ftp_(44) attach-agent $tcp_(44)
$ns at 720.2 "$ftp_(44) start"
$ns at 900.0 "$ftp_(44) stop"

#Set a TCP connection between node_(4) and node_(23)
set tcp_(45) [new Agent/TCP/Newreno]
$tcp_(45) set class_ 2
set sink_(45) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(45)
$ns attach-agent $node_(23) $sink_(45)
$ns connect $tcp_(45) $sink_(45)
set ftp_(45) [new Application/FTP]
$ftp_(45) attach-agent $tcp_(45)
$ns at 0.2 "$ftp_(45) start"
$ns at 180.0 "$ftp_(45) stop"

#Set a TCP connection between node_(71) and node_(55)
set tcp_(46) [new Agent/TCP/Newreno]
$tcp_(46) set class_ 2
set sink_(46) [new Agent/TCPSink]
$ns attach-agent $node_(71) $tcp_(46)
$ns attach-agent $node_(55) $sink_(46)
$ns connect $tcp_(46) $sink_(46)
set ftp_(46) [new Application/FTP]
$ftp_(46) attach-agent $tcp_(46)
$ns at 180.2 "$ftp_(46) start"
$ns at 360.0 "$ftp_(46) stop"

#Set a TCP connection between node_(43) and node_(6)
set tcp_(47) [new Agent/TCP/Newreno]
$tcp_(47) set class_ 2
set sink_(47) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(47)
$ns attach-agent $node_(6) $sink_(47)
$ns connect $tcp_(47) $sink_(47)
set ftp_(47) [new Application/FTP]
$ftp_(47) attach-agent $tcp_(47)
$ns at 360.2 "$ftp_(47) start"
$ns at 540.0 "$ftp_(47) stop"

#Set a TCP connection between node_(48) and node_(38)
set tcp_(48) [new Agent/TCP/Newreno]
$tcp_(48) set class_ 2
set sink_(48) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(48)
$ns attach-agent $node_(38) $sink_(48)
$ns connect $tcp_(48) $sink_(48)
set ftp_(48) [new Application/FTP]
$ftp_(48) attach-agent $tcp_(48)
$ns at 540.2 "$ftp_(48) start"
$ns at 720.0 "$ftp_(48) stop"

#Set a TCP connection between node_(83) and node_(17)
set tcp_(49) [new Agent/TCP/Newreno]
$tcp_(49) set class_ 2
set sink_(49) [new Agent/TCPSink]
$ns attach-agent $node_(83) $tcp_(49)
$ns attach-agent $node_(17) $sink_(49)
$ns connect $tcp_(49) $sink_(49)
set ftp_(49) [new Application/FTP]
$ftp_(49) attach-agent $tcp_(49)
$ns at 720.2 "$ftp_(49) start"
$ns at 900.0 "$ftp_(49) stop"

#Set a TCP connection between node_(19) and node_(38)
set tcp_(50) [new Agent/TCP/Newreno]
$tcp_(50) set class_ 2
set sink_(50) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(50)
$ns attach-agent $node_(38) $sink_(50)
$ns connect $tcp_(50) $sink_(50)
set ftp_(50) [new Application/FTP]
$ftp_(50) attach-agent $tcp_(50)
$ns at 0.2 "$ftp_(50) start"
$ns at 180.0 "$ftp_(50) stop"

#Set a TCP connection between node_(69) and node_(49)
set tcp_(51) [new Agent/TCP/Newreno]
$tcp_(51) set class_ 2
set sink_(51) [new Agent/TCPSink]
$ns attach-agent $node_(69) $tcp_(51)
$ns attach-agent $node_(49) $sink_(51)
$ns connect $tcp_(51) $sink_(51)
set ftp_(51) [new Application/FTP]
$ftp_(51) attach-agent $tcp_(51)
$ns at 180.2 "$ftp_(51) start"
$ns at 360.0 "$ftp_(51) stop"

#Set a TCP connection between node_(9) and node_(52)
set tcp_(52) [new Agent/TCP/Newreno]
$tcp_(52) set class_ 2
set sink_(52) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(52)
$ns attach-agent $node_(52) $sink_(52)
$ns connect $tcp_(52) $sink_(52)
set ftp_(52) [new Application/FTP]
$ftp_(52) attach-agent $tcp_(52)
$ns at 360.2 "$ftp_(52) start"
$ns at 540.0 "$ftp_(52) stop"

#Set a TCP connection between node_(48) and node_(92)
set tcp_(53) [new Agent/TCP/Newreno]
$tcp_(53) set class_ 2
set sink_(53) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(53)
$ns attach-agent $node_(92) $sink_(53)
$ns connect $tcp_(53) $sink_(53)
set ftp_(53) [new Application/FTP]
$ftp_(53) attach-agent $tcp_(53)
$ns at 540.2 "$ftp_(53) start"
$ns at 720.0 "$ftp_(53) stop"

#Set a TCP connection between node_(27) and node_(86)
set tcp_(54) [new Agent/TCP/Newreno]
$tcp_(54) set class_ 2
set sink_(54) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(54)
$ns attach-agent $node_(86) $sink_(54)
$ns connect $tcp_(54) $sink_(54)
set ftp_(54) [new Application/FTP]
$ftp_(54) attach-agent $tcp_(54)
$ns at 720.2 "$ftp_(54) start"
$ns at 900.0 "$ftp_(54) stop"

#Set a TCP connection between node_(67) and node_(64)
set tcp_(55) [new Agent/TCP/Newreno]
$tcp_(55) set class_ 2
set sink_(55) [new Agent/TCPSink]
$ns attach-agent $node_(67) $tcp_(55)
$ns attach-agent $node_(64) $sink_(55)
$ns connect $tcp_(55) $sink_(55)
set ftp_(55) [new Application/FTP]
$ftp_(55) attach-agent $tcp_(55)
$ns at 0.2 "$ftp_(55) start"
$ns at 180.0 "$ftp_(55) stop"

#Set a TCP connection between node_(48) and node_(60)
set tcp_(56) [new Agent/TCP/Newreno]
$tcp_(56) set class_ 2
set sink_(56) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(56)
$ns attach-agent $node_(60) $sink_(56)
$ns connect $tcp_(56) $sink_(56)
set ftp_(56) [new Application/FTP]
$ftp_(56) attach-agent $tcp_(56)
$ns at 180.2 "$ftp_(56) start"
$ns at 360.0 "$ftp_(56) stop"

#Set a TCP connection between node_(20) and node_(38)
set tcp_(57) [new Agent/TCP/Newreno]
$tcp_(57) set class_ 2
set sink_(57) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(57)
$ns attach-agent $node_(38) $sink_(57)
$ns connect $tcp_(57) $sink_(57)
set ftp_(57) [new Application/FTP]
$ftp_(57) attach-agent $tcp_(57)
$ns at 360.2 "$ftp_(57) start"
$ns at 540.0 "$ftp_(57) stop"

#Set a TCP connection between node_(83) and node_(75)
set tcp_(58) [new Agent/TCP/Newreno]
$tcp_(58) set class_ 2
set sink_(58) [new Agent/TCPSink]
$ns attach-agent $node_(83) $tcp_(58)
$ns attach-agent $node_(75) $sink_(58)
$ns connect $tcp_(58) $sink_(58)
set ftp_(58) [new Application/FTP]
$ftp_(58) attach-agent $tcp_(58)
$ns at 540.2 "$ftp_(58) start"
$ns at 720.0 "$ftp_(58) stop"

#Set a TCP connection between node_(86) and node_(17)
set tcp_(59) [new Agent/TCP/Newreno]
$tcp_(59) set class_ 2
set sink_(59) [new Agent/TCPSink]
$ns attach-agent $node_(86) $tcp_(59)
$ns attach-agent $node_(17) $sink_(59)
$ns connect $tcp_(59) $sink_(59)
set ftp_(59) [new Application/FTP]
$ftp_(59) attach-agent $tcp_(59)
$ns at 720.2 "$ftp_(59) start"
$ns at 900.0 "$ftp_(59) stop"

#Set a TCP connection between node_(58) and node_(32)
set tcp_(60) [new Agent/TCP/Newreno]
$tcp_(60) set class_ 2
set sink_(60) [new Agent/TCPSink]
$ns attach-agent $node_(58) $tcp_(60)
$ns attach-agent $node_(32) $sink_(60)
$ns connect $tcp_(60) $sink_(60)
set ftp_(60) [new Application/FTP]
$ftp_(60) attach-agent $tcp_(60)
$ns at 0.2 "$ftp_(60) start"
$ns at 180.0 "$ftp_(60) stop"

#Set a TCP connection between node_(47) and node_(97)
set tcp_(61) [new Agent/TCP/Newreno]
$tcp_(61) set class_ 2
set sink_(61) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(61)
$ns attach-agent $node_(97) $sink_(61)
$ns connect $tcp_(61) $sink_(61)
set ftp_(61) [new Application/FTP]
$ftp_(61) attach-agent $tcp_(61)
$ns at 180.2 "$ftp_(61) start"
$ns at 360.0 "$ftp_(61) stop"

#Set a TCP connection between node_(31) and node_(55)
set tcp_(62) [new Agent/TCP/Newreno]
$tcp_(62) set class_ 2
set sink_(62) [new Agent/TCPSink]
$ns attach-agent $node_(31) $tcp_(62)
$ns attach-agent $node_(55) $sink_(62)
$ns connect $tcp_(62) $sink_(62)
set ftp_(62) [new Application/FTP]
$ftp_(62) attach-agent $tcp_(62)
$ns at 360.2 "$ftp_(62) start"
$ns at 540.0 "$ftp_(62) stop"

#Set a TCP connection between node_(72) and node_(53)
set tcp_(63) [new Agent/TCP/Newreno]
$tcp_(63) set class_ 2
set sink_(63) [new Agent/TCPSink]
$ns attach-agent $node_(72) $tcp_(63)
$ns attach-agent $node_(53) $sink_(63)
$ns connect $tcp_(63) $sink_(63)
set ftp_(63) [new Application/FTP]
$ftp_(63) attach-agent $tcp_(63)
$ns at 540.2 "$ftp_(63) start"
$ns at 720.0 "$ftp_(63) stop"

#Set a TCP connection between node_(21) and node_(18)
set tcp_(64) [new Agent/TCP/Newreno]
$tcp_(64) set class_ 2
set sink_(64) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(64)
$ns attach-agent $node_(18) $sink_(64)
$ns connect $tcp_(64) $sink_(64)
set ftp_(64) [new Application/FTP]
$ftp_(64) attach-agent $tcp_(64)
$ns at 720.2 "$ftp_(64) start"
$ns at 900.0 "$ftp_(64) stop"

#Set a TCP connection between node_(55) and node_(66)
set tcp_(65) [new Agent/TCP/Newreno]
$tcp_(65) set class_ 2
set sink_(65) [new Agent/TCPSink]
$ns attach-agent $node_(55) $tcp_(65)
$ns attach-agent $node_(66) $sink_(65)
$ns connect $tcp_(65) $sink_(65)
set ftp_(65) [new Application/FTP]
$ftp_(65) attach-agent $tcp_(65)
$ns at 0.2 "$ftp_(65) start"
$ns at 180.0 "$ftp_(65) stop"

#Set a TCP connection between node_(76) and node_(90)
set tcp_(66) [new Agent/TCP/Newreno]
$tcp_(66) set class_ 2
set sink_(66) [new Agent/TCPSink]
$ns attach-agent $node_(76) $tcp_(66)
$ns attach-agent $node_(90) $sink_(66)
$ns connect $tcp_(66) $sink_(66)
set ftp_(66) [new Application/FTP]
$ftp_(66) attach-agent $tcp_(66)
$ns at 180.2 "$ftp_(66) start"
$ns at 360.0 "$ftp_(66) stop"

#Set a TCP connection between node_(10) and node_(4)
set tcp_(67) [new Agent/TCP/Newreno]
$tcp_(67) set class_ 2
set sink_(67) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(67)
$ns attach-agent $node_(4) $sink_(67)
$ns connect $tcp_(67) $sink_(67)
set ftp_(67) [new Application/FTP]
$ftp_(67) attach-agent $tcp_(67)
$ns at 360.2 "$ftp_(67) start"
$ns at 540.0 "$ftp_(67) stop"

#Set a TCP connection between node_(76) and node_(42)
set tcp_(68) [new Agent/TCP/Newreno]
$tcp_(68) set class_ 2
set sink_(68) [new Agent/TCPSink]
$ns attach-agent $node_(76) $tcp_(68)
$ns attach-agent $node_(42) $sink_(68)
$ns connect $tcp_(68) $sink_(68)
set ftp_(68) [new Application/FTP]
$ftp_(68) attach-agent $tcp_(68)
$ns at 540.2 "$ftp_(68) start"
$ns at 720.0 "$ftp_(68) stop"

#Set a TCP connection between node_(21) and node_(22)
set tcp_(69) [new Agent/TCP/Newreno]
$tcp_(69) set class_ 2
set sink_(69) [new Agent/TCPSink]
$ns attach-agent $node_(21) $tcp_(69)
$ns attach-agent $node_(22) $sink_(69)
$ns connect $tcp_(69) $sink_(69)
set ftp_(69) [new Application/FTP]
$ftp_(69) attach-agent $tcp_(69)
$ns at 720.2 "$ftp_(69) start"
$ns at 900.0 "$ftp_(69) stop"

#Set a TCP connection between node_(80) and node_(95)
set tcp_(70) [new Agent/TCP/Newreno]
$tcp_(70) set class_ 2
set sink_(70) [new Agent/TCPSink]
$ns attach-agent $node_(80) $tcp_(70)
$ns attach-agent $node_(95) $sink_(70)
$ns connect $tcp_(70) $sink_(70)
set ftp_(70) [new Application/FTP]
$ftp_(70) attach-agent $tcp_(70)
$ns at 0.2 "$ftp_(70) start"
$ns at 180.0 "$ftp_(70) stop"

#Set a TCP connection between node_(80) and node_(10)
set tcp_(71) [new Agent/TCP/Newreno]
$tcp_(71) set class_ 2
set sink_(71) [new Agent/TCPSink]
$ns attach-agent $node_(80) $tcp_(71)
$ns attach-agent $node_(10) $sink_(71)
$ns connect $tcp_(71) $sink_(71)
set ftp_(71) [new Application/FTP]
$ftp_(71) attach-agent $tcp_(71)
$ns at 180.2 "$ftp_(71) start"
$ns at 360.0 "$ftp_(71) stop"

#Set a TCP connection between node_(68) and node_(44)
set tcp_(72) [new Agent/TCP/Newreno]
$tcp_(72) set class_ 2
set sink_(72) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(72)
$ns attach-agent $node_(44) $sink_(72)
$ns connect $tcp_(72) $sink_(72)
set ftp_(72) [new Application/FTP]
$ftp_(72) attach-agent $tcp_(72)
$ns at 360.2 "$ftp_(72) start"
$ns at 540.0 "$ftp_(72) stop"

#Set a TCP connection between node_(65) and node_(80)
set tcp_(73) [new Agent/TCP/Newreno]
$tcp_(73) set class_ 2
set sink_(73) [new Agent/TCPSink]
$ns attach-agent $node_(65) $tcp_(73)
$ns attach-agent $node_(80) $sink_(73)
$ns connect $tcp_(73) $sink_(73)
set ftp_(73) [new Application/FTP]
$ftp_(73) attach-agent $tcp_(73)
$ns at 540.2 "$ftp_(73) start"
$ns at 720.0 "$ftp_(73) stop"

#Set a TCP connection between node_(66) and node_(63)
set tcp_(74) [new Agent/TCP/Newreno]
$tcp_(74) set class_ 2
set sink_(74) [new Agent/TCPSink]
$ns attach-agent $node_(66) $tcp_(74)
$ns attach-agent $node_(63) $sink_(74)
$ns connect $tcp_(74) $sink_(74)
set ftp_(74) [new Application/FTP]
$ftp_(74) attach-agent $tcp_(74)
$ns at 720.2 "$ftp_(74) start"
$ns at 900.0 "$ftp_(74) stop"

#Set a TCP connection between node_(67) and node_(80)
set tcp_(75) [new Agent/TCP/Newreno]
$tcp_(75) set class_ 2
set sink_(75) [new Agent/TCPSink]
$ns attach-agent $node_(67) $tcp_(75)
$ns attach-agent $node_(80) $sink_(75)
$ns connect $tcp_(75) $sink_(75)
set ftp_(75) [new Application/FTP]
$ftp_(75) attach-agent $tcp_(75)
$ns at 0.2 "$ftp_(75) start"
$ns at 180.0 "$ftp_(75) stop"

#Set a TCP connection between node_(90) and node_(77)
set tcp_(76) [new Agent/TCP/Newreno]
$tcp_(76) set class_ 2
set sink_(76) [new Agent/TCPSink]
$ns attach-agent $node_(90) $tcp_(76)
$ns attach-agent $node_(77) $sink_(76)
$ns connect $tcp_(76) $sink_(76)
set ftp_(76) [new Application/FTP]
$ftp_(76) attach-agent $tcp_(76)
$ns at 180.2 "$ftp_(76) start"
$ns at 360.0 "$ftp_(76) stop"

#Set a TCP connection between node_(64) and node_(39)
set tcp_(77) [new Agent/TCP/Newreno]
$tcp_(77) set class_ 2
set sink_(77) [new Agent/TCPSink]
$ns attach-agent $node_(64) $tcp_(77)
$ns attach-agent $node_(39) $sink_(77)
$ns connect $tcp_(77) $sink_(77)
set ftp_(77) [new Application/FTP]
$ftp_(77) attach-agent $tcp_(77)
$ns at 360.2 "$ftp_(77) start"
$ns at 540.0 "$ftp_(77) stop"

#Set a TCP connection between node_(48) and node_(94)
set tcp_(78) [new Agent/TCP/Newreno]
$tcp_(78) set class_ 2
set sink_(78) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(78)
$ns attach-agent $node_(94) $sink_(78)
$ns connect $tcp_(78) $sink_(78)
set ftp_(78) [new Application/FTP]
$ftp_(78) attach-agent $tcp_(78)
$ns at 540.2 "$ftp_(78) start"
$ns at 720.0 "$ftp_(78) stop"

#Set a TCP connection between node_(76) and node_(45)
set tcp_(79) [new Agent/TCP/Newreno]
$tcp_(79) set class_ 2
set sink_(79) [new Agent/TCPSink]
$ns attach-agent $node_(76) $tcp_(79)
$ns attach-agent $node_(45) $sink_(79)
$ns connect $tcp_(79) $sink_(79)
set ftp_(79) [new Application/FTP]
$ftp_(79) attach-agent $tcp_(79)
$ns at 720.2 "$ftp_(79) start"
$ns at 900.0 "$ftp_(79) stop"

#Set a TCP connection between node_(96) and node_(3)
set tcp_(80) [new Agent/TCP/Newreno]
$tcp_(80) set class_ 2
set sink_(80) [new Agent/TCPSink]
$ns attach-agent $node_(96) $tcp_(80)
$ns attach-agent $node_(3) $sink_(80)
$ns connect $tcp_(80) $sink_(80)
set ftp_(80) [new Application/FTP]
$ftp_(80) attach-agent $tcp_(80)
$ns at 0.2 "$ftp_(80) start"
$ns at 180.0 "$ftp_(80) stop"

#Set a TCP connection between node_(6) and node_(32)
set tcp_(81) [new Agent/TCP/Newreno]
$tcp_(81) set class_ 2
set sink_(81) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(81)
$ns attach-agent $node_(32) $sink_(81)
$ns connect $tcp_(81) $sink_(81)
set ftp_(81) [new Application/FTP]
$ftp_(81) attach-agent $tcp_(81)
$ns at 180.2 "$ftp_(81) start"
$ns at 360.0 "$ftp_(81) stop"

#Set a TCP connection between node_(83) and node_(80)
set tcp_(82) [new Agent/TCP/Newreno]
$tcp_(82) set class_ 2
set sink_(82) [new Agent/TCPSink]
$ns attach-agent $node_(83) $tcp_(82)
$ns attach-agent $node_(80) $sink_(82)
$ns connect $tcp_(82) $sink_(82)
set ftp_(82) [new Application/FTP]
$ftp_(82) attach-agent $tcp_(82)
$ns at 360.2 "$ftp_(82) start"
$ns at 540.0 "$ftp_(82) stop"

#Set a TCP connection between node_(76) and node_(46)
set tcp_(83) [new Agent/TCP/Newreno]
$tcp_(83) set class_ 2
set sink_(83) [new Agent/TCPSink]
$ns attach-agent $node_(76) $tcp_(83)
$ns attach-agent $node_(46) $sink_(83)
$ns connect $tcp_(83) $sink_(83)
set ftp_(83) [new Application/FTP]
$ftp_(83) attach-agent $tcp_(83)
$ns at 540.2 "$ftp_(83) start"
$ns at 720.0 "$ftp_(83) stop"

#Set a TCP connection between node_(30) and node_(98)
set tcp_(84) [new Agent/TCP/Newreno]
$tcp_(84) set class_ 2
set sink_(84) [new Agent/TCPSink]
$ns attach-agent $node_(30) $tcp_(84)
$ns attach-agent $node_(98) $sink_(84)
$ns connect $tcp_(84) $sink_(84)
set ftp_(84) [new Application/FTP]
$ftp_(84) attach-agent $tcp_(84)
$ns at 720.2 "$ftp_(84) start"
$ns at 900.0 "$ftp_(84) stop"

#Set a TCP connection between node_(60) and node_(12)
set tcp_(85) [new Agent/TCP/Newreno]
$tcp_(85) set class_ 2
set sink_(85) [new Agent/TCPSink]
$ns attach-agent $node_(60) $tcp_(85)
$ns attach-agent $node_(12) $sink_(85)
$ns connect $tcp_(85) $sink_(85)
set ftp_(85) [new Application/FTP]
$ftp_(85) attach-agent $tcp_(85)
$ns at 0.2 "$ftp_(85) start"
$ns at 180.0 "$ftp_(85) stop"

#Set a TCP connection between node_(90) and node_(76)
set tcp_(86) [new Agent/TCP/Newreno]
$tcp_(86) set class_ 2
set sink_(86) [new Agent/TCPSink]
$ns attach-agent $node_(90) $tcp_(86)
$ns attach-agent $node_(76) $sink_(86)
$ns connect $tcp_(86) $sink_(86)
set ftp_(86) [new Application/FTP]
$ftp_(86) attach-agent $tcp_(86)
$ns at 180.2 "$ftp_(86) start"
$ns at 360.0 "$ftp_(86) stop"

#Set a TCP connection between node_(54) and node_(4)
set tcp_(87) [new Agent/TCP/Newreno]
$tcp_(87) set class_ 2
set sink_(87) [new Agent/TCPSink]
$ns attach-agent $node_(54) $tcp_(87)
$ns attach-agent $node_(4) $sink_(87)
$ns connect $tcp_(87) $sink_(87)
set ftp_(87) [new Application/FTP]
$ftp_(87) attach-agent $tcp_(87)
$ns at 360.2 "$ftp_(87) start"
$ns at 540.0 "$ftp_(87) stop"

#Set a TCP connection between node_(93) and node_(5)
set tcp_(88) [new Agent/TCP/Newreno]
$tcp_(88) set class_ 2
set sink_(88) [new Agent/TCPSink]
$ns attach-agent $node_(93) $tcp_(88)
$ns attach-agent $node_(5) $sink_(88)
$ns connect $tcp_(88) $sink_(88)
set ftp_(88) [new Application/FTP]
$ftp_(88) attach-agent $tcp_(88)
$ns at 540.2 "$ftp_(88) start"
$ns at 720.0 "$ftp_(88) stop"

#Set a TCP connection between node_(19) and node_(40)
set tcp_(89) [new Agent/TCP/Newreno]
$tcp_(89) set class_ 2
set sink_(89) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(89)
$ns attach-agent $node_(40) $sink_(89)
$ns connect $tcp_(89) $sink_(89)
set ftp_(89) [new Application/FTP]
$ftp_(89) attach-agent $tcp_(89)
$ns at 720.2 "$ftp_(89) start"
$ns at 900.0 "$ftp_(89) stop"

#Set a TCP connection between node_(84) and node_(97)
set tcp_(90) [new Agent/TCP/Newreno]
$tcp_(90) set class_ 2
set sink_(90) [new Agent/TCPSink]
$ns attach-agent $node_(84) $tcp_(90)
$ns attach-agent $node_(97) $sink_(90)
$ns connect $tcp_(90) $sink_(90)
set ftp_(90) [new Application/FTP]
$ftp_(90) attach-agent $tcp_(90)
$ns at 0.2 "$ftp_(90) start"
$ns at 180.0 "$ftp_(90) stop"

#Set a TCP connection between node_(56) and node_(19)
set tcp_(91) [new Agent/TCP/Newreno]
$tcp_(91) set class_ 2
set sink_(91) [new Agent/TCPSink]
$ns attach-agent $node_(56) $tcp_(91)
$ns attach-agent $node_(19) $sink_(91)
$ns connect $tcp_(91) $sink_(91)
set ftp_(91) [new Application/FTP]
$ftp_(91) attach-agent $tcp_(91)
$ns at 180.2 "$ftp_(91) start"
$ns at 360.0 "$ftp_(91) stop"

#Set a TCP connection between node_(53) and node_(63)
set tcp_(92) [new Agent/TCP/Newreno]
$tcp_(92) set class_ 2
set sink_(92) [new Agent/TCPSink]
$ns attach-agent $node_(53) $tcp_(92)
$ns attach-agent $node_(63) $sink_(92)
$ns connect $tcp_(92) $sink_(92)
set ftp_(92) [new Application/FTP]
$ftp_(92) attach-agent $tcp_(92)
$ns at 360.2 "$ftp_(92) start"
$ns at 540.0 "$ftp_(92) stop"

#Set a TCP connection between node_(41) and node_(40)
set tcp_(93) [new Agent/TCP/Newreno]
$tcp_(93) set class_ 2
set sink_(93) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(93)
$ns attach-agent $node_(40) $sink_(93)
$ns connect $tcp_(93) $sink_(93)
set ftp_(93) [new Application/FTP]
$ftp_(93) attach-agent $tcp_(93)
$ns at 540.2 "$ftp_(93) start"
$ns at 720.0 "$ftp_(93) stop"

#Set a TCP connection between node_(27) and node_(3)
set tcp_(94) [new Agent/TCP/Newreno]
$tcp_(94) set class_ 2
set sink_(94) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(94)
$ns attach-agent $node_(3) $sink_(94)
$ns connect $tcp_(94) $sink_(94)
set ftp_(94) [new Application/FTP]
$ftp_(94) attach-agent $tcp_(94)
$ns at 720.2 "$ftp_(94) start"
$ns at 900.0 "$ftp_(94) stop"

#Set a TCP connection between node_(57) and node_(36)
set tcp_(95) [new Agent/TCP/Newreno]
$tcp_(95) set class_ 2
set sink_(95) [new Agent/TCPSink]
$ns attach-agent $node_(57) $tcp_(95)
$ns attach-agent $node_(36) $sink_(95)
$ns connect $tcp_(95) $sink_(95)
set ftp_(95) [new Application/FTP]
$ftp_(95) attach-agent $tcp_(95)
$ns at 0.2 "$ftp_(95) start"
$ns at 180.0 "$ftp_(95) stop"

#Set a TCP connection between node_(58) and node_(9)
set tcp_(96) [new Agent/TCP/Newreno]
$tcp_(96) set class_ 2
set sink_(96) [new Agent/TCPSink]
$ns attach-agent $node_(58) $tcp_(96)
$ns attach-agent $node_(9) $sink_(96)
$ns connect $tcp_(96) $sink_(96)
set ftp_(96) [new Application/FTP]
$ftp_(96) attach-agent $tcp_(96)
$ns at 180.2 "$ftp_(96) start"
$ns at 360.0 "$ftp_(96) stop"

#Set a TCP connection between node_(3) and node_(53)
set tcp_(97) [new Agent/TCP/Newreno]
$tcp_(97) set class_ 2
set sink_(97) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(97)
$ns attach-agent $node_(53) $sink_(97)
$ns connect $tcp_(97) $sink_(97)
set ftp_(97) [new Application/FTP]
$ftp_(97) attach-agent $tcp_(97)
$ns at 360.2 "$ftp_(97) start"
$ns at 540.0 "$ftp_(97) stop"

#Set a TCP connection between node_(2) and node_(51)
set tcp_(98) [new Agent/TCP/Newreno]
$tcp_(98) set class_ 2
set sink_(98) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(98)
$ns attach-agent $node_(51) $sink_(98)
$ns connect $tcp_(98) $sink_(98)
set ftp_(98) [new Application/FTP]
$ftp_(98) attach-agent $tcp_(98)
$ns at 540.2 "$ftp_(98) start"
$ns at 720.0 "$ftp_(98) stop"

#Set a TCP connection between node_(64) and node_(46)
set tcp_(99) [new Agent/TCP/Newreno]
$tcp_(99) set class_ 2
set sink_(99) [new Agent/TCPSink]
$ns attach-agent $node_(64) $tcp_(99)
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
