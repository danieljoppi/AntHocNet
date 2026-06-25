#sim-scn3-9.tcl 
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
set tracefd       [open sim-scn3-9-$val(rp)-trace.tr w]
set windowVsTime2 [open sim-scn3-9-$val(rp)-win-.tr w]
set namtrace      [open sim-scn3-9-$val(rp).nam w]

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
$node_(0) set X_ 1982 
$node_(0) set Y_ 577 
$node_(0) set Z_ 0.0 
$node_(1) set X_ 783 
$node_(1) set Y_ 835 
$node_(1) set Z_ 0.0 
$node_(2) set X_ 2085 
$node_(2) set Y_ 408 
$node_(2) set Z_ 0.0 
$node_(3) set X_ 530 
$node_(3) set Y_ 19 
$node_(3) set Z_ 0.0 
$node_(4) set X_ 939 
$node_(4) set Y_ 844 
$node_(4) set Z_ 0.0 
$node_(5) set X_ 2589 
$node_(5) set Y_ 825 
$node_(5) set Z_ 0.0 
$node_(6) set X_ 452 
$node_(6) set Y_ 333 
$node_(6) set Z_ 0.0 
$node_(7) set X_ 294 
$node_(7) set Y_ 670 
$node_(7) set Z_ 0.0 
$node_(8) set X_ 659 
$node_(8) set Y_ 1000 
$node_(8) set Z_ 0.0 
$node_(9) set X_ 2116 
$node_(9) set Y_ 210 
$node_(9) set Z_ 0.0 
$node_(10) set X_ 190 
$node_(10) set Y_ 474 
$node_(10) set Z_ 0.0 
$node_(11) set X_ 596 
$node_(11) set Y_ 636 
$node_(11) set Z_ 0.0 
$node_(12) set X_ 991 
$node_(12) set Y_ 684 
$node_(12) set Z_ 0.0 
$node_(13) set X_ 2080 
$node_(13) set Y_ 946 
$node_(13) set Z_ 0.0 
$node_(14) set X_ 1546 
$node_(14) set Y_ 23 
$node_(14) set Z_ 0.0 
$node_(15) set X_ 1755 
$node_(15) set Y_ 43 
$node_(15) set Z_ 0.0 
$node_(16) set X_ 2206 
$node_(16) set Y_ 388 
$node_(16) set Z_ 0.0 
$node_(17) set X_ 1388 
$node_(17) set Y_ 644 
$node_(17) set Z_ 0.0 
$node_(18) set X_ 1339 
$node_(18) set Y_ 925 
$node_(18) set Z_ 0.0 
$node_(19) set X_ 246 
$node_(19) set Y_ 692 
$node_(19) set Z_ 0.0 
$node_(20) set X_ 2871 
$node_(20) set Y_ 739 
$node_(20) set Z_ 0.0 
$node_(21) set X_ 2993 
$node_(21) set Y_ 385 
$node_(21) set Z_ 0.0 
$node_(22) set X_ 1296 
$node_(22) set Y_ 441 
$node_(22) set Z_ 0.0 
$node_(23) set X_ 1894 
$node_(23) set Y_ 10 
$node_(23) set Z_ 0.0 
$node_(24) set X_ 2523 
$node_(24) set Y_ 167 
$node_(24) set Z_ 0.0 
$node_(25) set X_ 397 
$node_(25) set Y_ 445 
$node_(25) set Z_ 0.0 
$node_(26) set X_ 2904 
$node_(26) set Y_ 632 
$node_(26) set Z_ 0.0 
$node_(27) set X_ 1140 
$node_(27) set Y_ 613 
$node_(27) set Z_ 0.0 
$node_(28) set X_ 486 
$node_(28) set Y_ 835 
$node_(28) set Z_ 0.0 
$node_(29) set X_ 2602 
$node_(29) set Y_ 155 
$node_(29) set Z_ 0.0 
$node_(30) set X_ 2963 
$node_(30) set Y_ 283 
$node_(30) set Z_ 0.0 
$node_(31) set X_ 49 
$node_(31) set Y_ 317 
$node_(31) set Z_ 0.0 
$node_(32) set X_ 918 
$node_(32) set Y_ 988 
$node_(32) set Z_ 0.0 
$node_(33) set X_ 2018 
$node_(33) set Y_ 341 
$node_(33) set Z_ 0.0 
$node_(34) set X_ 1839 
$node_(34) set Y_ 17 
$node_(34) set Z_ 0.0 
$node_(35) set X_ 448 
$node_(35) set Y_ 686 
$node_(35) set Z_ 0.0 
$node_(36) set X_ 1936 
$node_(36) set Y_ 103 
$node_(36) set Z_ 0.0 
$node_(37) set X_ 622 
$node_(37) set Y_ 48 
$node_(37) set Z_ 0.0 
$node_(38) set X_ 1105 
$node_(38) set Y_ 650 
$node_(38) set Z_ 0.0 
$node_(39) set X_ 2354 
$node_(39) set Y_ 430 
$node_(39) set Z_ 0.0 
$node_(40) set X_ 1394 
$node_(40) set Y_ 505 
$node_(40) set Z_ 0.0 
$node_(41) set X_ 380 
$node_(41) set Y_ 525 
$node_(41) set Z_ 0.0 
$node_(42) set X_ 1047 
$node_(42) set Y_ 28 
$node_(42) set Z_ 0.0 
$node_(43) set X_ 591 
$node_(43) set Y_ 260 
$node_(43) set Z_ 0.0 
$node_(44) set X_ 1675 
$node_(44) set Y_ 312 
$node_(44) set Z_ 0.0 
$node_(45) set X_ 2724 
$node_(45) set Y_ 646 
$node_(45) set Z_ 0.0 
$node_(46) set X_ 255 
$node_(46) set Y_ 887 
$node_(46) set Z_ 0.0 
$node_(47) set X_ 2253 
$node_(47) set Y_ 8 
$node_(47) set Z_ 0.0 
$node_(48) set X_ 2564 
$node_(48) set Y_ 892 
$node_(48) set Z_ 0.0 
$node_(49) set X_ 2602 
$node_(49) set Y_ 256 
$node_(49) set Z_ 0.0 
$node_(50) set X_ 246 
$node_(50) set Y_ 484 
$node_(50) set Z_ 0.0 
$node_(51) set X_ 1410 
$node_(51) set Y_ 115 
$node_(51) set Z_ 0.0 
$node_(52) set X_ 2056 
$node_(52) set Y_ 190 
$node_(52) set Z_ 0.0 
$node_(53) set X_ 2373 
$node_(53) set Y_ 128 
$node_(53) set Z_ 0.0 
$node_(54) set X_ 852 
$node_(54) set Y_ 45 
$node_(54) set Z_ 0.0 
$node_(55) set X_ 1211 
$node_(55) set Y_ 803 
$node_(55) set Z_ 0.0 
$node_(56) set X_ 1689 
$node_(56) set Y_ 596 
$node_(56) set Z_ 0.0 
$node_(57) set X_ 2594 
$node_(57) set Y_ 499 
$node_(57) set Z_ 0.0 
$node_(58) set X_ 2831 
$node_(58) set Y_ 274 
$node_(58) set Z_ 0.0 
$node_(59) set X_ 284 
$node_(59) set Y_ 519 
$node_(59) set Z_ 0.0 
$node_(60) set X_ 1733 
$node_(60) set Y_ 235 
$node_(60) set Z_ 0.0 
$node_(61) set X_ 2458 
$node_(61) set Y_ 383 
$node_(61) set Z_ 0.0 
$node_(62) set X_ 1911 
$node_(62) set Y_ 457 
$node_(62) set Z_ 0.0 
$node_(63) set X_ 2096 
$node_(63) set Y_ 487 
$node_(63) set Z_ 0.0 
$node_(64) set X_ 2333 
$node_(64) set Y_ 826 
$node_(64) set Z_ 0.0 
$node_(65) set X_ 1411 
$node_(65) set Y_ 128 
$node_(65) set Z_ 0.0 
$node_(66) set X_ 1238 
$node_(66) set Y_ 929 
$node_(66) set Z_ 0.0 
$node_(67) set X_ 1661 
$node_(67) set Y_ 446 
$node_(67) set Z_ 0.0 
$node_(68) set X_ 444 
$node_(68) set Y_ 512 
$node_(68) set Z_ 0.0 
$node_(69) set X_ 245 
$node_(69) set Y_ 917 
$node_(69) set Z_ 0.0 
$node_(70) set X_ 943 
$node_(70) set Y_ 918 
$node_(70) set Z_ 0.0 
$node_(71) set X_ 755 
$node_(71) set Y_ 901 
$node_(71) set Z_ 0.0 
$node_(72) set X_ 141 
$node_(72) set Y_ 289 
$node_(72) set Z_ 0.0 
$node_(73) set X_ 665 
$node_(73) set Y_ 170 
$node_(73) set Z_ 0.0 
$node_(74) set X_ 2291 
$node_(74) set Y_ 46 
$node_(74) set Z_ 0.0 
$node_(75) set X_ 1543 
$node_(75) set Y_ 484 
$node_(75) set Z_ 0.0 
$node_(76) set X_ 660 
$node_(76) set Y_ 945 
$node_(76) set Z_ 0.0 
$node_(77) set X_ 131 
$node_(77) set Y_ 63 
$node_(77) set Z_ 0.0 
$node_(78) set X_ 1621 
$node_(78) set Y_ 990 
$node_(78) set Z_ 0.0 
$node_(79) set X_ 1265 
$node_(79) set Y_ 234 
$node_(79) set Z_ 0.0 
$node_(80) set X_ 2237 
$node_(80) set Y_ 650 
$node_(80) set Z_ 0.0 
$node_(81) set X_ 497 
$node_(81) set Y_ 606 
$node_(81) set Z_ 0.0 
$node_(82) set X_ 1057 
$node_(82) set Y_ 89 
$node_(82) set Z_ 0.0 
$node_(83) set X_ 2387 
$node_(83) set Y_ 908 
$node_(83) set Z_ 0.0 
$node_(84) set X_ 1609 
$node_(84) set Y_ 583 
$node_(84) set Z_ 0.0 
$node_(85) set X_ 1708 
$node_(85) set Y_ 999 
$node_(85) set Z_ 0.0 
$node_(86) set X_ 688 
$node_(86) set Y_ 910 
$node_(86) set Z_ 0.0 
$node_(87) set X_ 2370 
$node_(87) set Y_ 624 
$node_(87) set Z_ 0.0 
$node_(88) set X_ 745 
$node_(88) set Y_ 248 
$node_(88) set Z_ 0.0 
$node_(89) set X_ 611 
$node_(89) set Y_ 221 
$node_(89) set Z_ 0.0 
$node_(90) set X_ 694 
$node_(90) set Y_ 40 
$node_(90) set Z_ 0.0 
$node_(91) set X_ 2952 
$node_(91) set Y_ 438 
$node_(91) set Z_ 0.0 
$node_(92) set X_ 2165 
$node_(92) set Y_ 373 
$node_(92) set Z_ 0.0 
$node_(93) set X_ 632 
$node_(93) set Y_ 53 
$node_(93) set Z_ 0.0 
$node_(94) set X_ 621 
$node_(94) set Y_ 623 
$node_(94) set Z_ 0.0 
$node_(95) set X_ 1608 
$node_(95) set Y_ 685 
$node_(95) set Z_ 0.0 
$node_(96) set X_ 926 
$node_(96) set Y_ 534 
$node_(96) set Z_ 0.0 
$node_(97) set X_ 2861 
$node_(97) set Y_ 3 
$node_(97) set Z_ 0.0 
$node_(98) set X_ 1790 
$node_(98) set Y_ 422 
$node_(98) set Z_ 0.0 
$node_(99) set X_ 575 
$node_(99) set Y_ 160 
$node_(99) set Z_ 0.0 
$node_(100) set X_ 2114 
$node_(100) set Y_ 904 
$node_(100) set Z_ 0.0 
$node_(101) set X_ 813 
$node_(101) set Y_ 823 
$node_(101) set Z_ 0.0 
$ns at 0.0 "$node_(101) off" 
$ns at 100.0 "$node_(101) on" 
$node_(102) set X_ 1527 
$node_(102) set Y_ 413 
$node_(102) set Z_ 0.0 
$ns at 0.0 "$node_(102) off" 
$ns at 100.0 "$node_(102) on" 
$node_(103) set X_ 612 
$node_(103) set Y_ 467 
$node_(103) set Z_ 0.0 
$ns at 0.0 "$node_(103) off" 
$ns at 100.0 "$node_(103) on" 
$node_(104) set X_ 445 
$node_(104) set Y_ 759 
$node_(104) set Z_ 0.0 
$ns at 0.0 "$node_(104) off" 
$ns at 100.0 "$node_(104) on" 
$node_(105) set X_ 1902 
$node_(105) set Y_ 596 
$node_(105) set Z_ 0.0 
$ns at 0.0 "$node_(105) off" 
$ns at 100.0 "$node_(105) on" 
$node_(106) set X_ 1707 
$node_(106) set Y_ 182 
$node_(106) set Z_ 0.0 
$ns at 0.0 "$node_(106) off" 
$ns at 100.0 "$node_(106) on" 
$node_(107) set X_ 1379 
$node_(107) set Y_ 139 
$node_(107) set Z_ 0.0 
$ns at 0.0 "$node_(107) off" 
$ns at 100.0 "$node_(107) on" 
$node_(108) set X_ 292 
$node_(108) set Y_ 652 
$node_(108) set Z_ 0.0 
$ns at 0.0 "$node_(108) off" 
$ns at 100.0 "$node_(108) on" 
$node_(109) set X_ 397 
$node_(109) set Y_ 585 
$node_(109) set Z_ 0.0 
$ns at 0.0 "$node_(109) off" 
$ns at 100.0 "$node_(109) on" 
$node_(110) set X_ 799 
$node_(110) set Y_ 660 
$node_(110) set Z_ 0.0 
$ns at 0.0 "$node_(110) off" 
$ns at 100.0 "$node_(110) on" 
$node_(111) set X_ 1101 
$node_(111) set Y_ 330 
$node_(111) set Z_ 0.0 
$ns at 0.0 "$node_(111) off" 
$ns at 100.0 "$node_(111) on" 
$node_(112) set X_ 2253 
$node_(112) set Y_ 390 
$node_(112) set Z_ 0.0 
$ns at 0.0 "$node_(112) off" 
$ns at 100.0 "$node_(112) on" 
$node_(113) set X_ 1392 
$node_(113) set Y_ 302 
$node_(113) set Z_ 0.0 
$ns at 0.0 "$node_(113) off" 
$ns at 100.0 "$node_(113) on" 
$node_(114) set X_ 2411 
$node_(114) set Y_ 938 
$node_(114) set Z_ 0.0 
$ns at 0.0 "$node_(114) off" 
$ns at 100.0 "$node_(114) on" 
$node_(115) set X_ 915 
$node_(115) set Y_ 193 
$node_(115) set Z_ 0.0 
$ns at 0.0 "$node_(115) off" 
$ns at 100.0 "$node_(115) on" 
$node_(116) set X_ 84 
$node_(116) set Y_ 206 
$node_(116) set Z_ 0.0 
$ns at 0.0 "$node_(116) off" 
$ns at 100.0 "$node_(116) on" 
$node_(117) set X_ 1066 
$node_(117) set Y_ 514 
$node_(117) set Z_ 0.0 
$ns at 0.0 "$node_(117) off" 
$ns at 100.0 "$node_(117) on" 
$node_(118) set X_ 2008 
$node_(118) set Y_ 208 
$node_(118) set Z_ 0.0 
$ns at 0.0 "$node_(118) off" 
$ns at 100.0 "$node_(118) on" 
$node_(119) set X_ 2050 
$node_(119) set Y_ 252 
$node_(119) set Z_ 0.0 
$ns at 0.0 "$node_(119) off" 
$ns at 100.0 "$node_(119) on" 
$node_(120) set X_ 2588 
$node_(120) set Y_ 777 
$node_(120) set Z_ 0.0 
$ns at 0.0 "$node_(120) off" 
$ns at 100.0 "$node_(120) on" 
$node_(121) set X_ 261 
$node_(121) set Y_ 132 
$node_(121) set Z_ 0.0 
$ns at 0.0 "$node_(121) off" 
$ns at 100.0 "$node_(121) on" 
$node_(122) set X_ 1308 
$node_(122) set Y_ 86 
$node_(122) set Z_ 0.0 
$ns at 0.0 "$node_(122) off" 
$ns at 100.0 "$node_(122) on" 
$node_(123) set X_ 2743 
$node_(123) set Y_ 356 
$node_(123) set Z_ 0.0 
$ns at 0.0 "$node_(123) off" 
$ns at 100.0 "$node_(123) on" 
$node_(124) set X_ 2807 
$node_(124) set Y_ 983 
$node_(124) set Z_ 0.0 
$ns at 0.0 "$node_(124) off" 
$ns at 100.0 "$node_(124) on" 
$node_(125) set X_ 150 
$node_(125) set Y_ 197 
$node_(125) set Z_ 0.0 
$ns at 0.0 "$node_(125) off" 
$ns at 100.0 "$node_(125) on" 
$node_(126) set X_ 1544 
$node_(126) set Y_ 838 
$node_(126) set Z_ 0.0 
$ns at 0.0 "$node_(126) off" 
$ns at 100.0 "$node_(126) on" 
$node_(127) set X_ 2550 
$node_(127) set Y_ 61 
$node_(127) set Z_ 0.0 
$ns at 0.0 "$node_(127) off" 
$ns at 100.0 "$node_(127) on" 
$node_(128) set X_ 602 
$node_(128) set Y_ 543 
$node_(128) set Z_ 0.0 
$ns at 0.0 "$node_(128) off" 
$ns at 100.0 "$node_(128) on" 
$node_(129) set X_ 1536 
$node_(129) set Y_ 413 
$node_(129) set Z_ 0.0 
$ns at 0.0 "$node_(129) off" 
$ns at 100.0 "$node_(129) on" 
$node_(130) set X_ 2567 
$node_(130) set Y_ 279 
$node_(130) set Z_ 0.0 
$ns at 0.0 "$node_(130) off" 
$ns at 100.0 "$node_(130) on" 
$node_(131) set X_ 1441 
$node_(131) set Y_ 501 
$node_(131) set Z_ 0.0 
$ns at 0.0 "$node_(131) off" 
$ns at 100.0 "$node_(131) on" 
$node_(132) set X_ 2458 
$node_(132) set Y_ 935 
$node_(132) set Z_ 0.0 
$ns at 0.0 "$node_(132) off" 
$ns at 100.0 "$node_(132) on" 
$node_(133) set X_ 38 
$node_(133) set Y_ 947 
$node_(133) set Z_ 0.0 
$ns at 0.0 "$node_(133) off" 
$ns at 100.0 "$node_(133) on" 
$node_(134) set X_ 2508 
$node_(134) set Y_ 368 
$node_(134) set Z_ 0.0 
$ns at 0.0 "$node_(134) off" 
$ns at 100.0 "$node_(134) on" 
$node_(135) set X_ 2847 
$node_(135) set Y_ 93 
$node_(135) set Z_ 0.0 
$ns at 0.0 "$node_(135) off" 
$ns at 100.0 "$node_(135) on" 
$node_(136) set X_ 1109 
$node_(136) set Y_ 229 
$node_(136) set Z_ 0.0 
$ns at 0.0 "$node_(136) off" 
$ns at 100.0 "$node_(136) on" 
$node_(137) set X_ 219 
$node_(137) set Y_ 437 
$node_(137) set Z_ 0.0 
$ns at 0.0 "$node_(137) off" 
$ns at 100.0 "$node_(137) on" 
$node_(138) set X_ 2449 
$node_(138) set Y_ 759 
$node_(138) set Z_ 0.0 
$ns at 0.0 "$node_(138) off" 
$ns at 100.0 "$node_(138) on" 
$node_(139) set X_ 546 
$node_(139) set Y_ 655 
$node_(139) set Z_ 0.0 
$ns at 0.0 "$node_(139) off" 
$ns at 100.0 "$node_(139) on" 
$node_(140) set X_ 1328 
$node_(140) set Y_ 744 
$node_(140) set Z_ 0.0 
$ns at 0.0 "$node_(140) off" 
$ns at 100.0 "$node_(140) on" 
$node_(141) set X_ 402 
$node_(141) set Y_ 426 
$node_(141) set Z_ 0.0 
$ns at 0.0 "$node_(141) off" 
$ns at 100.0 "$node_(141) on" 
$node_(142) set X_ 342 
$node_(142) set Y_ 850 
$node_(142) set Z_ 0.0 
$ns at 0.0 "$node_(142) off" 
$ns at 100.0 "$node_(142) on" 
$node_(143) set X_ 2060 
$node_(143) set Y_ 772 
$node_(143) set Z_ 0.0 
$ns at 0.0 "$node_(143) off" 
$ns at 100.0 "$node_(143) on" 
$node_(144) set X_ 2951 
$node_(144) set Y_ 662 
$node_(144) set Z_ 0.0 
$ns at 0.0 "$node_(144) off" 
$ns at 100.0 "$node_(144) on" 
$node_(145) set X_ 2732 
$node_(145) set Y_ 674 
$node_(145) set Z_ 0.0 
$ns at 0.0 "$node_(145) off" 
$ns at 100.0 "$node_(145) on" 
$node_(146) set X_ 1119 
$node_(146) set Y_ 59 
$node_(146) set Z_ 0.0 
$ns at 0.0 "$node_(146) off" 
$ns at 100.0 "$node_(146) on" 
$node_(147) set X_ 936 
$node_(147) set Y_ 482 
$node_(147) set Z_ 0.0 
$ns at 0.0 "$node_(147) off" 
$ns at 100.0 "$node_(147) on" 
$node_(148) set X_ 1 
$node_(148) set Y_ 997 
$node_(148) set Z_ 0.0 
$ns at 0.0 "$node_(148) off" 
$ns at 100.0 "$node_(148) on" 
$node_(149) set X_ 1734 
$node_(149) set Y_ 59 
$node_(149) set Z_ 0.0 
$ns at 0.0 "$node_(149) off" 
$ns at 100.0 "$node_(149) on" 
$node_(150) set X_ 1713 
$node_(150) set Y_ 397 
$node_(150) set Z_ 0.0 
$ns at 0.0 "$node_(150) off" 
$ns at 100.0 "$node_(150) on" 
$node_(151) set X_ 96 
$node_(151) set Y_ 625 
$node_(151) set Z_ 0.0 
$ns at 0.0 "$node_(151) off" 
$ns at 100.0 "$node_(151) on" 
$node_(152) set X_ 1484 
$node_(152) set Y_ 569 
$node_(152) set Z_ 0.0 
$ns at 0.0 "$node_(152) off" 
$ns at 100.0 "$node_(152) on" 
$node_(153) set X_ 1416 
$node_(153) set Y_ 20 
$node_(153) set Z_ 0.0 
$ns at 0.0 "$node_(153) off" 
$ns at 100.0 "$node_(153) on" 
$node_(154) set X_ 469 
$node_(154) set Y_ 563 
$node_(154) set Z_ 0.0 
$ns at 0.0 "$node_(154) off" 
$ns at 100.0 "$node_(154) on" 
$node_(155) set X_ 137 
$node_(155) set Y_ 437 
$node_(155) set Z_ 0.0 
$ns at 0.0 "$node_(155) off" 
$ns at 100.0 "$node_(155) on" 
$node_(156) set X_ 2207 
$node_(156) set Y_ 862 
$node_(156) set Z_ 0.0 
$ns at 0.0 "$node_(156) off" 
$ns at 100.0 "$node_(156) on" 
$node_(157) set X_ 682 
$node_(157) set Y_ 752 
$node_(157) set Z_ 0.0 
$ns at 0.0 "$node_(157) off" 
$ns at 100.0 "$node_(157) on" 
$node_(158) set X_ 135 
$node_(158) set Y_ 111 
$node_(158) set Z_ 0.0 
$ns at 0.0 "$node_(158) off" 
$ns at 100.0 "$node_(158) on" 
$node_(159) set X_ 2236 
$node_(159) set Y_ 209 
$node_(159) set Z_ 0.0 
$ns at 0.0 "$node_(159) off" 
$ns at 100.0 "$node_(159) on" 
$node_(160) set X_ 693 
$node_(160) set Y_ 932 
$node_(160) set Z_ 0.0 
$ns at 0.0 "$node_(160) off" 
$ns at 100.0 "$node_(160) on" 
$node_(161) set X_ 1588 
$node_(161) set Y_ 609 
$node_(161) set Z_ 0.0 
$ns at 0.0 "$node_(161) off" 
$ns at 100.0 "$node_(161) on" 
$node_(162) set X_ 1425 
$node_(162) set Y_ 438 
$node_(162) set Z_ 0.0 
$ns at 0.0 "$node_(162) off" 
$ns at 100.0 "$node_(162) on" 
$node_(163) set X_ 1072 
$node_(163) set Y_ 108 
$node_(163) set Z_ 0.0 
$ns at 0.0 "$node_(163) off" 
$ns at 100.0 "$node_(163) on" 
$node_(164) set X_ 59 
$node_(164) set Y_ 742 
$node_(164) set Z_ 0.0 
$ns at 0.0 "$node_(164) off" 
$ns at 100.0 "$node_(164) on" 
$node_(165) set X_ 2708 
$node_(165) set Y_ 417 
$node_(165) set Z_ 0.0 
$ns at 0.0 "$node_(165) off" 
$ns at 100.0 "$node_(165) on" 
$node_(166) set X_ 2844 
$node_(166) set Y_ 630 
$node_(166) set Z_ 0.0 
$ns at 0.0 "$node_(166) off" 
$ns at 100.0 "$node_(166) on" 
$node_(167) set X_ 908 
$node_(167) set Y_ 478 
$node_(167) set Z_ 0.0 
$ns at 0.0 "$node_(167) off" 
$ns at 100.0 "$node_(167) on" 
$node_(168) set X_ 417 
$node_(168) set Y_ 574 
$node_(168) set Z_ 0.0 
$ns at 0.0 "$node_(168) off" 
$ns at 100.0 "$node_(168) on" 
$node_(169) set X_ 658 
$node_(169) set Y_ 669 
$node_(169) set Z_ 0.0 
$ns at 0.0 "$node_(169) off" 
$ns at 100.0 "$node_(169) on" 
$node_(170) set X_ 2257 
$node_(170) set Y_ 419 
$node_(170) set Z_ 0.0 
$ns at 0.0 "$node_(170) off" 
$ns at 100.0 "$node_(170) on" 
$node_(171) set X_ 1738 
$node_(171) set Y_ 220 
$node_(171) set Z_ 0.0 
$ns at 0.0 "$node_(171) off" 
$ns at 100.0 "$node_(171) on" 
$node_(172) set X_ 1159 
$node_(172) set Y_ 422 
$node_(172) set Z_ 0.0 
$ns at 0.0 "$node_(172) off" 
$ns at 100.0 "$node_(172) on" 
$node_(173) set X_ 2536 
$node_(173) set Y_ 787 
$node_(173) set Z_ 0.0 
$ns at 0.0 "$node_(173) off" 
$ns at 100.0 "$node_(173) on" 
$node_(174) set X_ 2414 
$node_(174) set Y_ 786 
$node_(174) set Z_ 0.0 
$ns at 0.0 "$node_(174) off" 
$ns at 100.0 "$node_(174) on" 
$node_(175) set X_ 2149 
$node_(175) set Y_ 65 
$node_(175) set Z_ 0.0 
$ns at 0.0 "$node_(175) off" 
$ns at 100.0 "$node_(175) on" 
$node_(176) set X_ 2206 
$node_(176) set Y_ 488 
$node_(176) set Z_ 0.0 
$ns at 0.0 "$node_(176) off" 
$ns at 100.0 "$node_(176) on" 
$node_(177) set X_ 1808 
$node_(177) set Y_ 930 
$node_(177) set Z_ 0.0 
$ns at 0.0 "$node_(177) off" 
$ns at 100.0 "$node_(177) on" 
$node_(178) set X_ 2383 
$node_(178) set Y_ 964 
$node_(178) set Z_ 0.0 
$ns at 0.0 "$node_(178) off" 
$ns at 100.0 "$node_(178) on" 
$node_(179) set X_ 314 
$node_(179) set Y_ 830 
$node_(179) set Z_ 0.0 
$ns at 0.0 "$node_(179) off" 
$ns at 100.0 "$node_(179) on" 
$node_(180) set X_ 67 
$node_(180) set Y_ 204 
$node_(180) set Z_ 0.0 
$ns at 0.0 "$node_(180) off" 
$ns at 100.0 "$node_(180) on" 
$node_(181) set X_ 2931 
$node_(181) set Y_ 40 
$node_(181) set Z_ 0.0 
$ns at 0.0 "$node_(181) off" 
$ns at 100.0 "$node_(181) on" 
$node_(182) set X_ 2626 
$node_(182) set Y_ 877 
$node_(182) set Z_ 0.0 
$ns at 0.0 "$node_(182) off" 
$ns at 100.0 "$node_(182) on" 
$node_(183) set X_ 2242 
$node_(183) set Y_ 996 
$node_(183) set Z_ 0.0 
$ns at 0.0 "$node_(183) off" 
$ns at 100.0 "$node_(183) on" 
$node_(184) set X_ 2290 
$node_(184) set Y_ 402 
$node_(184) set Z_ 0.0 
$ns at 0.0 "$node_(184) off" 
$ns at 100.0 "$node_(184) on" 
$node_(185) set X_ 721 
$node_(185) set Y_ 85 
$node_(185) set Z_ 0.0 
$ns at 0.0 "$node_(185) off" 
$ns at 100.0 "$node_(185) on" 
$node_(186) set X_ 1167 
$node_(186) set Y_ 270 
$node_(186) set Z_ 0.0 
$ns at 0.0 "$node_(186) off" 
$ns at 100.0 "$node_(186) on" 
$node_(187) set X_ 2215 
$node_(187) set Y_ 180 
$node_(187) set Z_ 0.0 
$ns at 0.0 "$node_(187) off" 
$ns at 100.0 "$node_(187) on" 
$node_(188) set X_ 651 
$node_(188) set Y_ 531 
$node_(188) set Z_ 0.0 
$ns at 0.0 "$node_(188) off" 
$ns at 100.0 "$node_(188) on" 
$node_(189) set X_ 1264 
$node_(189) set Y_ 720 
$node_(189) set Z_ 0.0 
$ns at 0.0 "$node_(189) off" 
$ns at 100.0 "$node_(189) on" 
$node_(190) set X_ 1074 
$node_(190) set Y_ 55 
$node_(190) set Z_ 0.0 
$ns at 0.0 "$node_(190) off" 
$ns at 100.0 "$node_(190) on" 
$node_(191) set X_ 44 
$node_(191) set Y_ 329 
$node_(191) set Z_ 0.0 
$ns at 0.0 "$node_(191) off" 
$ns at 100.0 "$node_(191) on" 
$node_(192) set X_ 173 
$node_(192) set Y_ 84 
$node_(192) set Z_ 0.0 
$ns at 0.0 "$node_(192) off" 
$ns at 100.0 "$node_(192) on" 
$node_(193) set X_ 876 
$node_(193) set Y_ 797 
$node_(193) set Z_ 0.0 
$ns at 0.0 "$node_(193) off" 
$ns at 100.0 "$node_(193) on" 
$node_(194) set X_ 2218 
$node_(194) set Y_ 650 
$node_(194) set Z_ 0.0 
$ns at 0.0 "$node_(194) off" 
$ns at 100.0 "$node_(194) on" 
$node_(195) set X_ 562 
$node_(195) set Y_ 742 
$node_(195) set Z_ 0.0 
$ns at 0.0 "$node_(195) off" 
$ns at 100.0 "$node_(195) on" 
$node_(196) set X_ 802 
$node_(196) set Y_ 595 
$node_(196) set Z_ 0.0 
$ns at 0.0 "$node_(196) off" 
$ns at 100.0 "$node_(196) on" 
$node_(197) set X_ 2405 
$node_(197) set Y_ 460 
$node_(197) set Z_ 0.0 
$ns at 0.0 "$node_(197) off" 
$ns at 100.0 "$node_(197) on" 
$node_(198) set X_ 2024 
$node_(198) set Y_ 319 
$node_(198) set Z_ 0.0 
$ns at 0.0 "$node_(198) off" 
$ns at 100.0 "$node_(198) on" 
$node_(199) set X_ 1493 
$node_(199) set Y_ 216 
$node_(199) set Z_ 0.0 
$ns at 0.0 "$node_(199) off" 
$ns at 100.0 "$node_(199) on" 
$node_(200) set X_ 351 
$node_(200) set Y_ 886 
$node_(200) set Z_ 0.0 
$ns at 0.0 "$node_(200) off" 
$ns at 200.0 "$node_(200) on" 
$node_(201) set X_ 1899 
$node_(201) set Y_ 760 
$node_(201) set Z_ 0.0 
$ns at 0.0 "$node_(201) off" 
$ns at 200.0 "$node_(201) on" 
$node_(202) set X_ 679 
$node_(202) set Y_ 782 
$node_(202) set Z_ 0.0 
$ns at 0.0 "$node_(202) off" 
$ns at 200.0 "$node_(202) on" 
$node_(203) set X_ 603 
$node_(203) set Y_ 931 
$node_(203) set Z_ 0.0 
$ns at 0.0 "$node_(203) off" 
$ns at 200.0 "$node_(203) on" 
$node_(204) set X_ 1025 
$node_(204) set Y_ 437 
$node_(204) set Z_ 0.0 
$ns at 0.0 "$node_(204) off" 
$ns at 200.0 "$node_(204) on" 
$node_(205) set X_ 2412 
$node_(205) set Y_ 7 
$node_(205) set Z_ 0.0 
$ns at 0.0 "$node_(205) off" 
$ns at 200.0 "$node_(205) on" 
$node_(206) set X_ 1014 
$node_(206) set Y_ 633 
$node_(206) set Z_ 0.0 
$ns at 0.0 "$node_(206) off" 
$ns at 200.0 "$node_(206) on" 
$node_(207) set X_ 2800 
$node_(207) set Y_ 891 
$node_(207) set Z_ 0.0 
$ns at 0.0 "$node_(207) off" 
$ns at 200.0 "$node_(207) on" 
$node_(208) set X_ 2647 
$node_(208) set Y_ 24 
$node_(208) set Z_ 0.0 
$ns at 0.0 "$node_(208) off" 
$ns at 200.0 "$node_(208) on" 
$node_(209) set X_ 1476 
$node_(209) set Y_ 315 
$node_(209) set Z_ 0.0 
$ns at 0.0 "$node_(209) off" 
$ns at 200.0 "$node_(209) on" 
$node_(210) set X_ 17 
$node_(210) set Y_ 309 
$node_(210) set Z_ 0.0 
$ns at 0.0 "$node_(210) off" 
$ns at 200.0 "$node_(210) on" 
$node_(211) set X_ 2554 
$node_(211) set Y_ 993 
$node_(211) set Z_ 0.0 
$ns at 0.0 "$node_(211) off" 
$ns at 200.0 "$node_(211) on" 
$node_(212) set X_ 2395 
$node_(212) set Y_ 37 
$node_(212) set Z_ 0.0 
$ns at 0.0 "$node_(212) off" 
$ns at 200.0 "$node_(212) on" 
$node_(213) set X_ 1532 
$node_(213) set Y_ 45 
$node_(213) set Z_ 0.0 
$ns at 0.0 "$node_(213) off" 
$ns at 200.0 "$node_(213) on" 
$node_(214) set X_ 2707 
$node_(214) set Y_ 650 
$node_(214) set Z_ 0.0 
$ns at 0.0 "$node_(214) off" 
$ns at 200.0 "$node_(214) on" 
$node_(215) set X_ 1825 
$node_(215) set Y_ 87 
$node_(215) set Z_ 0.0 
$ns at 0.0 "$node_(215) off" 
$ns at 200.0 "$node_(215) on" 
$node_(216) set X_ 666 
$node_(216) set Y_ 96 
$node_(216) set Z_ 0.0 
$ns at 0.0 "$node_(216) off" 
$ns at 200.0 "$node_(216) on" 
$node_(217) set X_ 316 
$node_(217) set Y_ 106 
$node_(217) set Z_ 0.0 
$ns at 0.0 "$node_(217) off" 
$ns at 200.0 "$node_(217) on" 
$node_(218) set X_ 2810 
$node_(218) set Y_ 310 
$node_(218) set Z_ 0.0 
$ns at 0.0 "$node_(218) off" 
$ns at 200.0 "$node_(218) on" 
$node_(219) set X_ 1378 
$node_(219) set Y_ 571 
$node_(219) set Z_ 0.0 
$ns at 0.0 "$node_(219) off" 
$ns at 200.0 "$node_(219) on" 
$node_(220) set X_ 1388 
$node_(220) set Y_ 887 
$node_(220) set Z_ 0.0 
$ns at 0.0 "$node_(220) off" 
$ns at 200.0 "$node_(220) on" 
$node_(221) set X_ 14 
$node_(221) set Y_ 318 
$node_(221) set Z_ 0.0 
$ns at 0.0 "$node_(221) off" 
$ns at 200.0 "$node_(221) on" 
$node_(222) set X_ 1483 
$node_(222) set Y_ 546 
$node_(222) set Z_ 0.0 
$ns at 0.0 "$node_(222) off" 
$ns at 200.0 "$node_(222) on" 
$node_(223) set X_ 139 
$node_(223) set Y_ 380 
$node_(223) set Z_ 0.0 
$ns at 0.0 "$node_(223) off" 
$ns at 200.0 "$node_(223) on" 
$node_(224) set X_ 1877 
$node_(224) set Y_ 340 
$node_(224) set Z_ 0.0 
$ns at 0.0 "$node_(224) off" 
$ns at 200.0 "$node_(224) on" 
$node_(225) set X_ 2681 
$node_(225) set Y_ 296 
$node_(225) set Z_ 0.0 
$ns at 0.0 "$node_(225) off" 
$ns at 200.0 "$node_(225) on" 
$node_(226) set X_ 1022 
$node_(226) set Y_ 136 
$node_(226) set Z_ 0.0 
$ns at 0.0 "$node_(226) off" 
$ns at 200.0 "$node_(226) on" 
$node_(227) set X_ 2006 
$node_(227) set Y_ 445 
$node_(227) set Z_ 0.0 
$ns at 0.0 "$node_(227) off" 
$ns at 200.0 "$node_(227) on" 
$node_(228) set X_ 1084 
$node_(228) set Y_ 558 
$node_(228) set Z_ 0.0 
$ns at 0.0 "$node_(228) off" 
$ns at 200.0 "$node_(228) on" 
$node_(229) set X_ 2226 
$node_(229) set Y_ 561 
$node_(229) set Z_ 0.0 
$ns at 0.0 "$node_(229) off" 
$ns at 200.0 "$node_(229) on" 
$node_(230) set X_ 1283 
$node_(230) set Y_ 478 
$node_(230) set Z_ 0.0 
$ns at 0.0 "$node_(230) off" 
$ns at 200.0 "$node_(230) on" 
$node_(231) set X_ 260 
$node_(231) set Y_ 948 
$node_(231) set Z_ 0.0 
$ns at 0.0 "$node_(231) off" 
$ns at 200.0 "$node_(231) on" 
$node_(232) set X_ 1809 
$node_(232) set Y_ 131 
$node_(232) set Z_ 0.0 
$ns at 0.0 "$node_(232) off" 
$ns at 200.0 "$node_(232) on" 
$node_(233) set X_ 1973 
$node_(233) set Y_ 834 
$node_(233) set Z_ 0.0 
$ns at 0.0 "$node_(233) off" 
$ns at 200.0 "$node_(233) on" 
$node_(234) set X_ 284 
$node_(234) set Y_ 101 
$node_(234) set Z_ 0.0 
$ns at 0.0 "$node_(234) off" 
$ns at 200.0 "$node_(234) on" 
$node_(235) set X_ 476 
$node_(235) set Y_ 955 
$node_(235) set Z_ 0.0 
$ns at 0.0 "$node_(235) off" 
$ns at 200.0 "$node_(235) on" 
$node_(236) set X_ 1237 
$node_(236) set Y_ 747 
$node_(236) set Z_ 0.0 
$ns at 0.0 "$node_(236) off" 
$ns at 200.0 "$node_(236) on" 
$node_(237) set X_ 584 
$node_(237) set Y_ 724 
$node_(237) set Z_ 0.0 
$ns at 0.0 "$node_(237) off" 
$ns at 200.0 "$node_(237) on" 
$node_(238) set X_ 1190 
$node_(238) set Y_ 144 
$node_(238) set Z_ 0.0 
$ns at 0.0 "$node_(238) off" 
$ns at 200.0 "$node_(238) on" 
$node_(239) set X_ 2588 
$node_(239) set Y_ 272 
$node_(239) set Z_ 0.0 
$ns at 0.0 "$node_(239) off" 
$ns at 200.0 "$node_(239) on" 
$node_(240) set X_ 872 
$node_(240) set Y_ 215 
$node_(240) set Z_ 0.0 
$ns at 0.0 "$node_(240) off" 
$ns at 200.0 "$node_(240) on" 
$node_(241) set X_ 874 
$node_(241) set Y_ 262 
$node_(241) set Z_ 0.0 
$ns at 0.0 "$node_(241) off" 
$ns at 200.0 "$node_(241) on" 
$node_(242) set X_ 1663 
$node_(242) set Y_ 544 
$node_(242) set Z_ 0.0 
$ns at 0.0 "$node_(242) off" 
$ns at 200.0 "$node_(242) on" 
$node_(243) set X_ 1518 
$node_(243) set Y_ 587 
$node_(243) set Z_ 0.0 
$ns at 0.0 "$node_(243) off" 
$ns at 200.0 "$node_(243) on" 
$node_(244) set X_ 1721 
$node_(244) set Y_ 325 
$node_(244) set Z_ 0.0 
$ns at 0.0 "$node_(244) off" 
$ns at 200.0 "$node_(244) on" 
$node_(245) set X_ 785 
$node_(245) set Y_ 996 
$node_(245) set Z_ 0.0 
$ns at 0.0 "$node_(245) off" 
$ns at 200.0 "$node_(245) on" 
$node_(246) set X_ 2270 
$node_(246) set Y_ 967 
$node_(246) set Z_ 0.0 
$ns at 0.0 "$node_(246) off" 
$ns at 200.0 "$node_(246) on" 
$node_(247) set X_ 508 
$node_(247) set Y_ 248 
$node_(247) set Z_ 0.0 
$ns at 0.0 "$node_(247) off" 
$ns at 200.0 "$node_(247) on" 
$node_(248) set X_ 2304 
$node_(248) set Y_ 177 
$node_(248) set Z_ 0.0 
$ns at 0.0 "$node_(248) off" 
$ns at 200.0 "$node_(248) on" 
$node_(249) set X_ 1554 
$node_(249) set Y_ 588 
$node_(249) set Z_ 0.0 
$ns at 0.0 "$node_(249) off" 
$ns at 200.0 "$node_(249) on" 
$node_(250) set X_ 2436 
$node_(250) set Y_ 752 
$node_(250) set Z_ 0.0 
$ns at 0.0 "$node_(250) off" 
$ns at 200.0 "$node_(250) on" 
$node_(251) set X_ 2068 
$node_(251) set Y_ 244 
$node_(251) set Z_ 0.0 
$ns at 0.0 "$node_(251) off" 
$ns at 200.0 "$node_(251) on" 
$node_(252) set X_ 2844 
$node_(252) set Y_ 862 
$node_(252) set Z_ 0.0 
$ns at 0.0 "$node_(252) off" 
$ns at 200.0 "$node_(252) on" 
$node_(253) set X_ 2855 
$node_(253) set Y_ 141 
$node_(253) set Z_ 0.0 
$ns at 0.0 "$node_(253) off" 
$ns at 200.0 "$node_(253) on" 
$node_(254) set X_ 1145 
$node_(254) set Y_ 379 
$node_(254) set Z_ 0.0 
$ns at 0.0 "$node_(254) off" 
$ns at 200.0 "$node_(254) on" 
$node_(255) set X_ 2188 
$node_(255) set Y_ 234 
$node_(255) set Z_ 0.0 
$ns at 0.0 "$node_(255) off" 
$ns at 200.0 "$node_(255) on" 
$node_(256) set X_ 1724 
$node_(256) set Y_ 660 
$node_(256) set Z_ 0.0 
$ns at 0.0 "$node_(256) off" 
$ns at 200.0 "$node_(256) on" 
$node_(257) set X_ 430 
$node_(257) set Y_ 697 
$node_(257) set Z_ 0.0 
$ns at 0.0 "$node_(257) off" 
$ns at 200.0 "$node_(257) on" 
$node_(258) set X_ 2351 
$node_(258) set Y_ 243 
$node_(258) set Z_ 0.0 
$ns at 0.0 "$node_(258) off" 
$ns at 200.0 "$node_(258) on" 
$node_(259) set X_ 2215 
$node_(259) set Y_ 693 
$node_(259) set Z_ 0.0 
$ns at 0.0 "$node_(259) off" 
$ns at 200.0 "$node_(259) on" 
$node_(260) set X_ 1033 
$node_(260) set Y_ 141 
$node_(260) set Z_ 0.0 
$ns at 0.0 "$node_(260) off" 
$ns at 200.0 "$node_(260) on" 
$node_(261) set X_ 2501 
$node_(261) set Y_ 620 
$node_(261) set Z_ 0.0 
$ns at 0.0 "$node_(261) off" 
$ns at 200.0 "$node_(261) on" 
$node_(262) set X_ 1823 
$node_(262) set Y_ 734 
$node_(262) set Z_ 0.0 
$ns at 0.0 "$node_(262) off" 
$ns at 200.0 "$node_(262) on" 
$node_(263) set X_ 2554 
$node_(263) set Y_ 521 
$node_(263) set Z_ 0.0 
$ns at 0.0 "$node_(263) off" 
$ns at 200.0 "$node_(263) on" 
$node_(264) set X_ 2824 
$node_(264) set Y_ 806 
$node_(264) set Z_ 0.0 
$ns at 0.0 "$node_(264) off" 
$ns at 200.0 "$node_(264) on" 
$node_(265) set X_ 983 
$node_(265) set Y_ 821 
$node_(265) set Z_ 0.0 
$ns at 0.0 "$node_(265) off" 
$ns at 200.0 "$node_(265) on" 
$node_(266) set X_ 1885 
$node_(266) set Y_ 919 
$node_(266) set Z_ 0.0 
$ns at 0.0 "$node_(266) off" 
$ns at 200.0 "$node_(266) on" 
$node_(267) set X_ 84 
$node_(267) set Y_ 682 
$node_(267) set Z_ 0.0 
$ns at 0.0 "$node_(267) off" 
$ns at 200.0 "$node_(267) on" 
$node_(268) set X_ 2391 
$node_(268) set Y_ 171 
$node_(268) set Z_ 0.0 
$ns at 0.0 "$node_(268) off" 
$ns at 200.0 "$node_(268) on" 
$node_(269) set X_ 2272 
$node_(269) set Y_ 26 
$node_(269) set Z_ 0.0 
$ns at 0.0 "$node_(269) off" 
$ns at 200.0 "$node_(269) on" 
$node_(270) set X_ 2265 
$node_(270) set Y_ 320 
$node_(270) set Z_ 0.0 
$ns at 0.0 "$node_(270) off" 
$ns at 200.0 "$node_(270) on" 
$node_(271) set X_ 2953 
$node_(271) set Y_ 724 
$node_(271) set Z_ 0.0 
$ns at 0.0 "$node_(271) off" 
$ns at 200.0 "$node_(271) on" 
$node_(272) set X_ 672 
$node_(272) set Y_ 446 
$node_(272) set Z_ 0.0 
$ns at 0.0 "$node_(272) off" 
$ns at 200.0 "$node_(272) on" 
$node_(273) set X_ 1142 
$node_(273) set Y_ 555 
$node_(273) set Z_ 0.0 
$ns at 0.0 "$node_(273) off" 
$ns at 200.0 "$node_(273) on" 
$node_(274) set X_ 11 
$node_(274) set Y_ 576 
$node_(274) set Z_ 0.0 
$ns at 0.0 "$node_(274) off" 
$ns at 200.0 "$node_(274) on" 
$node_(275) set X_ 2149 
$node_(275) set Y_ 238 
$node_(275) set Z_ 0.0 
$ns at 0.0 "$node_(275) off" 
$ns at 200.0 "$node_(275) on" 
$node_(276) set X_ 1624 
$node_(276) set Y_ 176 
$node_(276) set Z_ 0.0 
$ns at 0.0 "$node_(276) off" 
$ns at 200.0 "$node_(276) on" 
$node_(277) set X_ 1030 
$node_(277) set Y_ 309 
$node_(277) set Z_ 0.0 
$ns at 0.0 "$node_(277) off" 
$ns at 200.0 "$node_(277) on" 
$node_(278) set X_ 2207 
$node_(278) set Y_ 994 
$node_(278) set Z_ 0.0 
$ns at 0.0 "$node_(278) off" 
$ns at 200.0 "$node_(278) on" 
$node_(279) set X_ 1995 
$node_(279) set Y_ 610 
$node_(279) set Z_ 0.0 
$ns at 0.0 "$node_(279) off" 
$ns at 200.0 "$node_(279) on" 
$node_(280) set X_ 135 
$node_(280) set Y_ 527 
$node_(280) set Z_ 0.0 
$ns at 0.0 "$node_(280) off" 
$ns at 200.0 "$node_(280) on" 
$node_(281) set X_ 1720 
$node_(281) set Y_ 926 
$node_(281) set Z_ 0.0 
$ns at 0.0 "$node_(281) off" 
$ns at 200.0 "$node_(281) on" 
$node_(282) set X_ 1939 
$node_(282) set Y_ 278 
$node_(282) set Z_ 0.0 
$ns at 0.0 "$node_(282) off" 
$ns at 200.0 "$node_(282) on" 
$node_(283) set X_ 2483 
$node_(283) set Y_ 637 
$node_(283) set Z_ 0.0 
$ns at 0.0 "$node_(283) off" 
$ns at 200.0 "$node_(283) on" 
$node_(284) set X_ 2844 
$node_(284) set Y_ 76 
$node_(284) set Z_ 0.0 
$ns at 0.0 "$node_(284) off" 
$ns at 200.0 "$node_(284) on" 
$node_(285) set X_ 2231 
$node_(285) set Y_ 313 
$node_(285) set Z_ 0.0 
$ns at 0.0 "$node_(285) off" 
$ns at 200.0 "$node_(285) on" 
$node_(286) set X_ 722 
$node_(286) set Y_ 926 
$node_(286) set Z_ 0.0 
$ns at 0.0 "$node_(286) off" 
$ns at 200.0 "$node_(286) on" 
$node_(287) set X_ 1083 
$node_(287) set Y_ 839 
$node_(287) set Z_ 0.0 
$ns at 0.0 "$node_(287) off" 
$ns at 200.0 "$node_(287) on" 
$node_(288) set X_ 1929 
$node_(288) set Y_ 274 
$node_(288) set Z_ 0.0 
$ns at 0.0 "$node_(288) off" 
$ns at 200.0 "$node_(288) on" 
$node_(289) set X_ 1406 
$node_(289) set Y_ 13 
$node_(289) set Z_ 0.0 
$ns at 0.0 "$node_(289) off" 
$ns at 200.0 "$node_(289) on" 
$node_(290) set X_ 2374 
$node_(290) set Y_ 100 
$node_(290) set Z_ 0.0 
$ns at 0.0 "$node_(290) off" 
$ns at 200.0 "$node_(290) on" 
$node_(291) set X_ 1441 
$node_(291) set Y_ 554 
$node_(291) set Z_ 0.0 
$ns at 0.0 "$node_(291) off" 
$ns at 200.0 "$node_(291) on" 
$node_(292) set X_ 2734 
$node_(292) set Y_ 961 
$node_(292) set Z_ 0.0 
$ns at 0.0 "$node_(292) off" 
$ns at 200.0 "$node_(292) on" 
$node_(293) set X_ 508 
$node_(293) set Y_ 107 
$node_(293) set Z_ 0.0 
$ns at 0.0 "$node_(293) off" 
$ns at 200.0 "$node_(293) on" 
$node_(294) set X_ 28 
$node_(294) set Y_ 955 
$node_(294) set Z_ 0.0 
$ns at 0.0 "$node_(294) off" 
$ns at 200.0 "$node_(294) on" 
$node_(295) set X_ 2122 
$node_(295) set Y_ 142 
$node_(295) set Z_ 0.0 
$ns at 0.0 "$node_(295) off" 
$ns at 200.0 "$node_(295) on" 
$node_(296) set X_ 2787 
$node_(296) set Y_ 591 
$node_(296) set Z_ 0.0 
$ns at 0.0 "$node_(296) off" 
$ns at 200.0 "$node_(296) on" 
$node_(297) set X_ 824 
$node_(297) set Y_ 617 
$node_(297) set Z_ 0.0 
$ns at 0.0 "$node_(297) off" 
$ns at 200.0 "$node_(297) on" 
$node_(298) set X_ 2760 
$node_(298) set Y_ 726 
$node_(298) set Z_ 0.0 
$ns at 0.0 "$node_(298) off" 
$ns at 200.0 "$node_(298) on" 
$node_(299) set X_ 2276 
$node_(299) set Y_ 885 
$node_(299) set Z_ 0.0 
$ns at 0.0 "$node_(299) off" 
$ns at 200.0 "$node_(299) on" 
$node_(300) set X_ 592 
$node_(300) set Y_ 48 
$node_(300) set Z_ 0.0 
$ns at 0.0 "$node_(300) off" 
$ns at 300.0 "$node_(300) on" 
$node_(301) set X_ 2073 
$node_(301) set Y_ 613 
$node_(301) set Z_ 0.0 
$ns at 0.0 "$node_(301) off" 
$ns at 300.0 "$node_(301) on" 
$node_(302) set X_ 2047 
$node_(302) set Y_ 65 
$node_(302) set Z_ 0.0 
$ns at 0.0 "$node_(302) off" 
$ns at 300.0 "$node_(302) on" 
$node_(303) set X_ 1918 
$node_(303) set Y_ 414 
$node_(303) set Z_ 0.0 
$ns at 0.0 "$node_(303) off" 
$ns at 300.0 "$node_(303) on" 
$node_(304) set X_ 2246 
$node_(304) set Y_ 206 
$node_(304) set Z_ 0.0 
$ns at 0.0 "$node_(304) off" 
$ns at 300.0 "$node_(304) on" 
$node_(305) set X_ 2142 
$node_(305) set Y_ 479 
$node_(305) set Z_ 0.0 
$ns at 0.0 "$node_(305) off" 
$ns at 300.0 "$node_(305) on" 
$node_(306) set X_ 1016 
$node_(306) set Y_ 420 
$node_(306) set Z_ 0.0 
$ns at 0.0 "$node_(306) off" 
$ns at 300.0 "$node_(306) on" 
$node_(307) set X_ 2185 
$node_(307) set Y_ 744 
$node_(307) set Z_ 0.0 
$ns at 0.0 "$node_(307) off" 
$ns at 300.0 "$node_(307) on" 
$node_(308) set X_ 744 
$node_(308) set Y_ 627 
$node_(308) set Z_ 0.0 
$ns at 0.0 "$node_(308) off" 
$ns at 300.0 "$node_(308) on" 
$node_(309) set X_ 2417 
$node_(309) set Y_ 46 
$node_(309) set Z_ 0.0 
$ns at 0.0 "$node_(309) off" 
$ns at 300.0 "$node_(309) on" 
$node_(310) set X_ 2203 
$node_(310) set Y_ 464 
$node_(310) set Z_ 0.0 
$ns at 0.0 "$node_(310) off" 
$ns at 300.0 "$node_(310) on" 
$node_(311) set X_ 2754 
$node_(311) set Y_ 246 
$node_(311) set Z_ 0.0 
$ns at 0.0 "$node_(311) off" 
$ns at 300.0 "$node_(311) on" 
$node_(312) set X_ 2560 
$node_(312) set Y_ 42 
$node_(312) set Z_ 0.0 
$ns at 0.0 "$node_(312) off" 
$ns at 300.0 "$node_(312) on" 
$node_(313) set X_ 2748 
$node_(313) set Y_ 556 
$node_(313) set Z_ 0.0 
$ns at 0.0 "$node_(313) off" 
$ns at 300.0 "$node_(313) on" 
$node_(314) set X_ 280 
$node_(314) set Y_ 847 
$node_(314) set Z_ 0.0 
$ns at 0.0 "$node_(314) off" 
$ns at 300.0 "$node_(314) on" 
$node_(315) set X_ 298 
$node_(315) set Y_ 145 
$node_(315) set Z_ 0.0 
$ns at 0.0 "$node_(315) off" 
$ns at 300.0 "$node_(315) on" 
$node_(316) set X_ 2826 
$node_(316) set Y_ 498 
$node_(316) set Z_ 0.0 
$ns at 0.0 "$node_(316) off" 
$ns at 300.0 "$node_(316) on" 
$node_(317) set X_ 825 
$node_(317) set Y_ 647 
$node_(317) set Z_ 0.0 
$ns at 0.0 "$node_(317) off" 
$ns at 300.0 "$node_(317) on" 
$node_(318) set X_ 2975 
$node_(318) set Y_ 787 
$node_(318) set Z_ 0.0 
$ns at 0.0 "$node_(318) off" 
$ns at 300.0 "$node_(318) on" 
$node_(319) set X_ 1654 
$node_(319) set Y_ 370 
$node_(319) set Z_ 0.0 
$ns at 0.0 "$node_(319) off" 
$ns at 300.0 "$node_(319) on" 
$node_(320) set X_ 230 
$node_(320) set Y_ 340 
$node_(320) set Z_ 0.0 
$ns at 0.0 "$node_(320) off" 
$ns at 300.0 "$node_(320) on" 
$node_(321) set X_ 2477 
$node_(321) set Y_ 841 
$node_(321) set Z_ 0.0 
$ns at 0.0 "$node_(321) off" 
$ns at 300.0 "$node_(321) on" 
$node_(322) set X_ 2140 
$node_(322) set Y_ 273 
$node_(322) set Z_ 0.0 
$ns at 0.0 "$node_(322) off" 
$ns at 300.0 "$node_(322) on" 
$node_(323) set X_ 90 
$node_(323) set Y_ 843 
$node_(323) set Z_ 0.0 
$ns at 0.0 "$node_(323) off" 
$ns at 300.0 "$node_(323) on" 
$node_(324) set X_ 2438 
$node_(324) set Y_ 394 
$node_(324) set Z_ 0.0 
$ns at 0.0 "$node_(324) off" 
$ns at 300.0 "$node_(324) on" 
$node_(325) set X_ 2199 
$node_(325) set Y_ 216 
$node_(325) set Z_ 0.0 
$ns at 0.0 "$node_(325) off" 
$ns at 300.0 "$node_(325) on" 
$node_(326) set X_ 688 
$node_(326) set Y_ 903 
$node_(326) set Z_ 0.0 
$ns at 0.0 "$node_(326) off" 
$ns at 300.0 "$node_(326) on" 
$node_(327) set X_ 1829 
$node_(327) set Y_ 535 
$node_(327) set Z_ 0.0 
$ns at 0.0 "$node_(327) off" 
$ns at 300.0 "$node_(327) on" 
$node_(328) set X_ 658 
$node_(328) set Y_ 14 
$node_(328) set Z_ 0.0 
$ns at 0.0 "$node_(328) off" 
$ns at 300.0 "$node_(328) on" 
$node_(329) set X_ 1900 
$node_(329) set Y_ 237 
$node_(329) set Z_ 0.0 
$ns at 0.0 "$node_(329) off" 
$ns at 300.0 "$node_(329) on" 
$node_(330) set X_ 863 
$node_(330) set Y_ 614 
$node_(330) set Z_ 0.0 
$ns at 0.0 "$node_(330) off" 
$ns at 300.0 "$node_(330) on" 
$node_(331) set X_ 1733 
$node_(331) set Y_ 870 
$node_(331) set Z_ 0.0 
$ns at 0.0 "$node_(331) off" 
$ns at 300.0 "$node_(331) on" 
$node_(332) set X_ 671 
$node_(332) set Y_ 890 
$node_(332) set Z_ 0.0 
$ns at 0.0 "$node_(332) off" 
$ns at 300.0 "$node_(332) on" 
$node_(333) set X_ 1687 
$node_(333) set Y_ 949 
$node_(333) set Z_ 0.0 
$ns at 0.0 "$node_(333) off" 
$ns at 300.0 "$node_(333) on" 
$node_(334) set X_ 1053 
$node_(334) set Y_ 842 
$node_(334) set Z_ 0.0 
$ns at 0.0 "$node_(334) off" 
$ns at 300.0 "$node_(334) on" 
$node_(335) set X_ 2803 
$node_(335) set Y_ 314 
$node_(335) set Z_ 0.0 
$ns at 0.0 "$node_(335) off" 
$ns at 300.0 "$node_(335) on" 
$node_(336) set X_ 420 
$node_(336) set Y_ 739 
$node_(336) set Z_ 0.0 
$ns at 0.0 "$node_(336) off" 
$ns at 300.0 "$node_(336) on" 
$node_(337) set X_ 2174 
$node_(337) set Y_ 980 
$node_(337) set Z_ 0.0 
$ns at 0.0 "$node_(337) off" 
$ns at 300.0 "$node_(337) on" 
$node_(338) set X_ 1121 
$node_(338) set Y_ 859 
$node_(338) set Z_ 0.0 
$ns at 0.0 "$node_(338) off" 
$ns at 300.0 "$node_(338) on" 
$node_(339) set X_ 881 
$node_(339) set Y_ 229 
$node_(339) set Z_ 0.0 
$ns at 0.0 "$node_(339) off" 
$ns at 300.0 "$node_(339) on" 
$node_(340) set X_ 3 
$node_(340) set Y_ 307 
$node_(340) set Z_ 0.0 
$ns at 0.0 "$node_(340) off" 
$ns at 300.0 "$node_(340) on" 
$node_(341) set X_ 1625 
$node_(341) set Y_ 76 
$node_(341) set Z_ 0.0 
$ns at 0.0 "$node_(341) off" 
$ns at 300.0 "$node_(341) on" 
$node_(342) set X_ 1955 
$node_(342) set Y_ 332 
$node_(342) set Z_ 0.0 
$ns at 0.0 "$node_(342) off" 
$ns at 300.0 "$node_(342) on" 
$node_(343) set X_ 731 
$node_(343) set Y_ 323 
$node_(343) set Z_ 0.0 
$ns at 0.0 "$node_(343) off" 
$ns at 300.0 "$node_(343) on" 
$node_(344) set X_ 1657 
$node_(344) set Y_ 290 
$node_(344) set Z_ 0.0 
$ns at 0.0 "$node_(344) off" 
$ns at 300.0 "$node_(344) on" 
$node_(345) set X_ 1942 
$node_(345) set Y_ 113 
$node_(345) set Z_ 0.0 
$ns at 0.0 "$node_(345) off" 
$ns at 300.0 "$node_(345) on" 
$node_(346) set X_ 715 
$node_(346) set Y_ 349 
$node_(346) set Z_ 0.0 
$ns at 0.0 "$node_(346) off" 
$ns at 300.0 "$node_(346) on" 
$node_(347) set X_ 1384 
$node_(347) set Y_ 278 
$node_(347) set Z_ 0.0 
$ns at 0.0 "$node_(347) off" 
$ns at 300.0 "$node_(347) on" 
$node_(348) set X_ 67 
$node_(348) set Y_ 100 
$node_(348) set Z_ 0.0 
$ns at 0.0 "$node_(348) off" 
$ns at 300.0 "$node_(348) on" 
$node_(349) set X_ 2280 
$node_(349) set Y_ 798 
$node_(349) set Z_ 0.0 
$ns at 0.0 "$node_(349) off" 
$ns at 300.0 "$node_(349) on" 
$node_(350) set X_ 1983 
$node_(350) set Y_ 451 
$node_(350) set Z_ 0.0 
$ns at 0.0 "$node_(350) off" 
$ns at 300.0 "$node_(350) on" 
$node_(351) set X_ 396 
$node_(351) set Y_ 385 
$node_(351) set Z_ 0.0 
$ns at 0.0 "$node_(351) off" 
$ns at 300.0 "$node_(351) on" 
$node_(352) set X_ 98 
$node_(352) set Y_ 604 
$node_(352) set Z_ 0.0 
$ns at 0.0 "$node_(352) off" 
$ns at 300.0 "$node_(352) on" 
$node_(353) set X_ 1807 
$node_(353) set Y_ 516 
$node_(353) set Z_ 0.0 
$ns at 0.0 "$node_(353) off" 
$ns at 300.0 "$node_(353) on" 
$node_(354) set X_ 2789 
$node_(354) set Y_ 425 
$node_(354) set Z_ 0.0 
$ns at 0.0 "$node_(354) off" 
$ns at 300.0 "$node_(354) on" 
$node_(355) set X_ 1443 
$node_(355) set Y_ 281 
$node_(355) set Z_ 0.0 
$ns at 0.0 "$node_(355) off" 
$ns at 300.0 "$node_(355) on" 
$node_(356) set X_ 790 
$node_(356) set Y_ 232 
$node_(356) set Z_ 0.0 
$ns at 0.0 "$node_(356) off" 
$ns at 300.0 "$node_(356) on" 
$node_(357) set X_ 910 
$node_(357) set Y_ 27 
$node_(357) set Z_ 0.0 
$ns at 0.0 "$node_(357) off" 
$ns at 300.0 "$node_(357) on" 
$node_(358) set X_ 214 
$node_(358) set Y_ 889 
$node_(358) set Z_ 0.0 
$ns at 0.0 "$node_(358) off" 
$ns at 300.0 "$node_(358) on" 
$node_(359) set X_ 1383 
$node_(359) set Y_ 101 
$node_(359) set Z_ 0.0 
$ns at 0.0 "$node_(359) off" 
$ns at 300.0 "$node_(359) on" 
$node_(360) set X_ 2192 
$node_(360) set Y_ 97 
$node_(360) set Z_ 0.0 
$ns at 0.0 "$node_(360) off" 
$ns at 300.0 "$node_(360) on" 
$node_(361) set X_ 2846 
$node_(361) set Y_ 976 
$node_(361) set Z_ 0.0 
$ns at 0.0 "$node_(361) off" 
$ns at 300.0 "$node_(361) on" 
$node_(362) set X_ 2050 
$node_(362) set Y_ 933 
$node_(362) set Z_ 0.0 
$ns at 0.0 "$node_(362) off" 
$ns at 300.0 "$node_(362) on" 
$node_(363) set X_ 2694 
$node_(363) set Y_ 640 
$node_(363) set Z_ 0.0 
$ns at 0.0 "$node_(363) off" 
$ns at 300.0 "$node_(363) on" 
$node_(364) set X_ 2402 
$node_(364) set Y_ 39 
$node_(364) set Z_ 0.0 
$ns at 0.0 "$node_(364) off" 
$ns at 300.0 "$node_(364) on" 
$node_(365) set X_ 630 
$node_(365) set Y_ 420 
$node_(365) set Z_ 0.0 
$ns at 0.0 "$node_(365) off" 
$ns at 300.0 "$node_(365) on" 
$node_(366) set X_ 729 
$node_(366) set Y_ 329 
$node_(366) set Z_ 0.0 
$ns at 0.0 "$node_(366) off" 
$ns at 300.0 "$node_(366) on" 
$node_(367) set X_ 1950 
$node_(367) set Y_ 358 
$node_(367) set Z_ 0.0 
$ns at 0.0 "$node_(367) off" 
$ns at 300.0 "$node_(367) on" 
$node_(368) set X_ 867 
$node_(368) set Y_ 704 
$node_(368) set Z_ 0.0 
$ns at 0.0 "$node_(368) off" 
$ns at 300.0 "$node_(368) on" 
$node_(369) set X_ 695 
$node_(369) set Y_ 820 
$node_(369) set Z_ 0.0 
$ns at 0.0 "$node_(369) off" 
$ns at 300.0 "$node_(369) on" 
$node_(370) set X_ 471 
$node_(370) set Y_ 98 
$node_(370) set Z_ 0.0 
$ns at 0.0 "$node_(370) off" 
$ns at 300.0 "$node_(370) on" 
$node_(371) set X_ 1724 
$node_(371) set Y_ 297 
$node_(371) set Z_ 0.0 
$ns at 0.0 "$node_(371) off" 
$ns at 300.0 "$node_(371) on" 
$node_(372) set X_ 819 
$node_(372) set Y_ 87 
$node_(372) set Z_ 0.0 
$ns at 0.0 "$node_(372) off" 
$ns at 300.0 "$node_(372) on" 
$node_(373) set X_ 581 
$node_(373) set Y_ 226 
$node_(373) set Z_ 0.0 
$ns at 0.0 "$node_(373) off" 
$ns at 300.0 "$node_(373) on" 
$node_(374) set X_ 2391 
$node_(374) set Y_ 433 
$node_(374) set Z_ 0.0 
$ns at 0.0 "$node_(374) off" 
$ns at 300.0 "$node_(374) on" 
$node_(375) set X_ 1074 
$node_(375) set Y_ 260 
$node_(375) set Z_ 0.0 
$ns at 0.0 "$node_(375) off" 
$ns at 300.0 "$node_(375) on" 
$node_(376) set X_ 1409 
$node_(376) set Y_ 165 
$node_(376) set Z_ 0.0 
$ns at 0.0 "$node_(376) off" 
$ns at 300.0 "$node_(376) on" 
$node_(377) set X_ 694 
$node_(377) set Y_ 589 
$node_(377) set Z_ 0.0 
$ns at 0.0 "$node_(377) off" 
$ns at 300.0 "$node_(377) on" 
$node_(378) set X_ 4 
$node_(378) set Y_ 259 
$node_(378) set Z_ 0.0 
$ns at 0.0 "$node_(378) off" 
$ns at 300.0 "$node_(378) on" 
$node_(379) set X_ 1524 
$node_(379) set Y_ 817 
$node_(379) set Z_ 0.0 
$ns at 0.0 "$node_(379) off" 
$ns at 300.0 "$node_(379) on" 
$node_(380) set X_ 894 
$node_(380) set Y_ 510 
$node_(380) set Z_ 0.0 
$ns at 0.0 "$node_(380) off" 
$ns at 300.0 "$node_(380) on" 
$node_(381) set X_ 1916 
$node_(381) set Y_ 422 
$node_(381) set Z_ 0.0 
$ns at 0.0 "$node_(381) off" 
$ns at 300.0 "$node_(381) on" 
$node_(382) set X_ 2361 
$node_(382) set Y_ 951 
$node_(382) set Z_ 0.0 
$ns at 0.0 "$node_(382) off" 
$ns at 300.0 "$node_(382) on" 
$node_(383) set X_ 177 
$node_(383) set Y_ 985 
$node_(383) set Z_ 0.0 
$ns at 0.0 "$node_(383) off" 
$ns at 300.0 "$node_(383) on" 
$node_(384) set X_ 2963 
$node_(384) set Y_ 50 
$node_(384) set Z_ 0.0 
$ns at 0.0 "$node_(384) off" 
$ns at 300.0 "$node_(384) on" 
$node_(385) set X_ 1578 
$node_(385) set Y_ 266 
$node_(385) set Z_ 0.0 
$ns at 0.0 "$node_(385) off" 
$ns at 300.0 "$node_(385) on" 
$node_(386) set X_ 777 
$node_(386) set Y_ 968 
$node_(386) set Z_ 0.0 
$ns at 0.0 "$node_(386) off" 
$ns at 300.0 "$node_(386) on" 
$node_(387) set X_ 2375 
$node_(387) set Y_ 648 
$node_(387) set Z_ 0.0 
$ns at 0.0 "$node_(387) off" 
$ns at 300.0 "$node_(387) on" 
$node_(388) set X_ 1039 
$node_(388) set Y_ 341 
$node_(388) set Z_ 0.0 
$ns at 0.0 "$node_(388) off" 
$ns at 300.0 "$node_(388) on" 
$node_(389) set X_ 1089 
$node_(389) set Y_ 656 
$node_(389) set Z_ 0.0 
$ns at 0.0 "$node_(389) off" 
$ns at 300.0 "$node_(389) on" 
$node_(390) set X_ 2856 
$node_(390) set Y_ 437 
$node_(390) set Z_ 0.0 
$ns at 0.0 "$node_(390) off" 
$ns at 300.0 "$node_(390) on" 
$node_(391) set X_ 49 
$node_(391) set Y_ 66 
$node_(391) set Z_ 0.0 
$ns at 0.0 "$node_(391) off" 
$ns at 300.0 "$node_(391) on" 
$node_(392) set X_ 153 
$node_(392) set Y_ 20 
$node_(392) set Z_ 0.0 
$ns at 0.0 "$node_(392) off" 
$ns at 300.0 "$node_(392) on" 
$node_(393) set X_ 239 
$node_(393) set Y_ 561 
$node_(393) set Z_ 0.0 
$ns at 0.0 "$node_(393) off" 
$ns at 300.0 "$node_(393) on" 
$node_(394) set X_ 295 
$node_(394) set Y_ 947 
$node_(394) set Z_ 0.0 
$ns at 0.0 "$node_(394) off" 
$ns at 300.0 "$node_(394) on" 
$node_(395) set X_ 669 
$node_(395) set Y_ 46 
$node_(395) set Z_ 0.0 
$ns at 0.0 "$node_(395) off" 
$ns at 300.0 "$node_(395) on" 
$node_(396) set X_ 1722 
$node_(396) set Y_ 327 
$node_(396) set Z_ 0.0 
$ns at 0.0 "$node_(396) off" 
$ns at 300.0 "$node_(396) on" 
$node_(397) set X_ 1956 
$node_(397) set Y_ 490 
$node_(397) set Z_ 0.0 
$ns at 0.0 "$node_(397) off" 
$ns at 300.0 "$node_(397) on" 
$node_(398) set X_ 1663 
$node_(398) set Y_ 77 
$node_(398) set Z_ 0.0 
$ns at 0.0 "$node_(398) off" 
$ns at 300.0 "$node_(398) on" 
$node_(399) set X_ 440 
$node_(399) set Y_ 601 
$node_(399) set Z_ 0.0 
$ns at 0.0 "$node_(399) off" 
$ns at 300.0 "$node_(399) on" 
$node_(400) set X_ 327 
$node_(400) set Y_ 826 
$node_(400) set Z_ 0.0 
$ns at 0.0 "$node_(400) off" 
$ns at 400.0 "$node_(400) on" 
$node_(401) set X_ 1043 
$node_(401) set Y_ 735 
$node_(401) set Z_ 0.0 
$ns at 0.0 "$node_(401) off" 
$ns at 400.0 "$node_(401) on" 
$node_(402) set X_ 1136 
$node_(402) set Y_ 420 
$node_(402) set Z_ 0.0 
$ns at 0.0 "$node_(402) off" 
$ns at 400.0 "$node_(402) on" 
$node_(403) set X_ 156 
$node_(403) set Y_ 193 
$node_(403) set Z_ 0.0 
$ns at 0.0 "$node_(403) off" 
$ns at 400.0 "$node_(403) on" 
$node_(404) set X_ 331 
$node_(404) set Y_ 742 
$node_(404) set Z_ 0.0 
$ns at 0.0 "$node_(404) off" 
$ns at 400.0 "$node_(404) on" 
$node_(405) set X_ 180 
$node_(405) set Y_ 442 
$node_(405) set Z_ 0.0 
$ns at 0.0 "$node_(405) off" 
$ns at 400.0 "$node_(405) on" 
$node_(406) set X_ 892 
$node_(406) set Y_ 138 
$node_(406) set Z_ 0.0 
$ns at 0.0 "$node_(406) off" 
$ns at 400.0 "$node_(406) on" 
$node_(407) set X_ 845 
$node_(407) set Y_ 883 
$node_(407) set Z_ 0.0 
$ns at 0.0 "$node_(407) off" 
$ns at 400.0 "$node_(407) on" 
$node_(408) set X_ 918 
$node_(408) set Y_ 545 
$node_(408) set Z_ 0.0 
$ns at 0.0 "$node_(408) off" 
$ns at 400.0 "$node_(408) on" 
$node_(409) set X_ 1202 
$node_(409) set Y_ 484 
$node_(409) set Z_ 0.0 
$ns at 0.0 "$node_(409) off" 
$ns at 400.0 "$node_(409) on" 
$node_(410) set X_ 1638 
$node_(410) set Y_ 296 
$node_(410) set Z_ 0.0 
$ns at 0.0 "$node_(410) off" 
$ns at 400.0 "$node_(410) on" 
$node_(411) set X_ 1135 
$node_(411) set Y_ 973 
$node_(411) set Z_ 0.0 
$ns at 0.0 "$node_(411) off" 
$ns at 400.0 "$node_(411) on" 
$node_(412) set X_ 909 
$node_(412) set Y_ 675 
$node_(412) set Z_ 0.0 
$ns at 0.0 "$node_(412) off" 
$ns at 400.0 "$node_(412) on" 
$node_(413) set X_ 1450 
$node_(413) set Y_ 330 
$node_(413) set Z_ 0.0 
$ns at 0.0 "$node_(413) off" 
$ns at 400.0 "$node_(413) on" 
$node_(414) set X_ 2477 
$node_(414) set Y_ 520 
$node_(414) set Z_ 0.0 
$ns at 0.0 "$node_(414) off" 
$ns at 400.0 "$node_(414) on" 
$node_(415) set X_ 968 
$node_(415) set Y_ 967 
$node_(415) set Z_ 0.0 
$ns at 0.0 "$node_(415) off" 
$ns at 400.0 "$node_(415) on" 
$node_(416) set X_ 427 
$node_(416) set Y_ 560 
$node_(416) set Z_ 0.0 
$ns at 0.0 "$node_(416) off" 
$ns at 400.0 "$node_(416) on" 
$node_(417) set X_ 1708 
$node_(417) set Y_ 371 
$node_(417) set Z_ 0.0 
$ns at 0.0 "$node_(417) off" 
$ns at 400.0 "$node_(417) on" 
$node_(418) set X_ 1089 
$node_(418) set Y_ 721 
$node_(418) set Z_ 0.0 
$ns at 0.0 "$node_(418) off" 
$ns at 400.0 "$node_(418) on" 
$node_(419) set X_ 2074 
$node_(419) set Y_ 940 
$node_(419) set Z_ 0.0 
$ns at 0.0 "$node_(419) off" 
$ns at 400.0 "$node_(419) on" 
$node_(420) set X_ 1265 
$node_(420) set Y_ 316 
$node_(420) set Z_ 0.0 
$ns at 0.0 "$node_(420) off" 
$ns at 400.0 "$node_(420) on" 
$node_(421) set X_ 7 
$node_(421) set Y_ 417 
$node_(421) set Z_ 0.0 
$ns at 0.0 "$node_(421) off" 
$ns at 400.0 "$node_(421) on" 
$node_(422) set X_ 926 
$node_(422) set Y_ 930 
$node_(422) set Z_ 0.0 
$ns at 0.0 "$node_(422) off" 
$ns at 400.0 "$node_(422) on" 
$node_(423) set X_ 2371 
$node_(423) set Y_ 646 
$node_(423) set Z_ 0.0 
$ns at 0.0 "$node_(423) off" 
$ns at 400.0 "$node_(423) on" 
$node_(424) set X_ 2535 
$node_(424) set Y_ 774 
$node_(424) set Z_ 0.0 
$ns at 0.0 "$node_(424) off" 
$ns at 400.0 "$node_(424) on" 
$node_(425) set X_ 327 
$node_(425) set Y_ 307 
$node_(425) set Z_ 0.0 
$ns at 0.0 "$node_(425) off" 
$ns at 400.0 "$node_(425) on" 
$node_(426) set X_ 2908 
$node_(426) set Y_ 494 
$node_(426) set Z_ 0.0 
$ns at 0.0 "$node_(426) off" 
$ns at 400.0 "$node_(426) on" 
$node_(427) set X_ 161 
$node_(427) set Y_ 945 
$node_(427) set Z_ 0.0 
$ns at 0.0 "$node_(427) off" 
$ns at 400.0 "$node_(427) on" 
$node_(428) set X_ 951 
$node_(428) set Y_ 728 
$node_(428) set Z_ 0.0 
$ns at 0.0 "$node_(428) off" 
$ns at 400.0 "$node_(428) on" 
$node_(429) set X_ 2974 
$node_(429) set Y_ 858 
$node_(429) set Z_ 0.0 
$ns at 0.0 "$node_(429) off" 
$ns at 400.0 "$node_(429) on" 
$node_(430) set X_ 1809 
$node_(430) set Y_ 166 
$node_(430) set Z_ 0.0 
$ns at 0.0 "$node_(430) off" 
$ns at 400.0 "$node_(430) on" 
$node_(431) set X_ 810 
$node_(431) set Y_ 372 
$node_(431) set Z_ 0.0 
$ns at 0.0 "$node_(431) off" 
$ns at 400.0 "$node_(431) on" 
$node_(432) set X_ 2823 
$node_(432) set Y_ 557 
$node_(432) set Z_ 0.0 
$ns at 0.0 "$node_(432) off" 
$ns at 400.0 "$node_(432) on" 
$node_(433) set X_ 1148 
$node_(433) set Y_ 587 
$node_(433) set Z_ 0.0 
$ns at 0.0 "$node_(433) off" 
$ns at 400.0 "$node_(433) on" 
$node_(434) set X_ 2324 
$node_(434) set Y_ 846 
$node_(434) set Z_ 0.0 
$ns at 0.0 "$node_(434) off" 
$ns at 400.0 "$node_(434) on" 
$node_(435) set X_ 1290 
$node_(435) set Y_ 955 
$node_(435) set Z_ 0.0 
$ns at 0.0 "$node_(435) off" 
$ns at 400.0 "$node_(435) on" 
$node_(436) set X_ 1611 
$node_(436) set Y_ 602 
$node_(436) set Z_ 0.0 
$ns at 0.0 "$node_(436) off" 
$ns at 400.0 "$node_(436) on" 
$node_(437) set X_ 0 
$node_(437) set Y_ 942 
$node_(437) set Z_ 0.0 
$ns at 0.0 "$node_(437) off" 
$ns at 400.0 "$node_(437) on" 
$node_(438) set X_ 1504 
$node_(438) set Y_ 11 
$node_(438) set Z_ 0.0 
$ns at 0.0 "$node_(438) off" 
$ns at 400.0 "$node_(438) on" 
$node_(439) set X_ 747 
$node_(439) set Y_ 585 
$node_(439) set Z_ 0.0 
$ns at 0.0 "$node_(439) off" 
$ns at 400.0 "$node_(439) on" 
$node_(440) set X_ 1624 
$node_(440) set Y_ 947 
$node_(440) set Z_ 0.0 
$ns at 0.0 "$node_(440) off" 
$ns at 400.0 "$node_(440) on" 
$node_(441) set X_ 189 
$node_(441) set Y_ 970 
$node_(441) set Z_ 0.0 
$ns at 0.0 "$node_(441) off" 
$ns at 400.0 "$node_(441) on" 
$node_(442) set X_ 2052 
$node_(442) set Y_ 78 
$node_(442) set Z_ 0.0 
$ns at 0.0 "$node_(442) off" 
$ns at 400.0 "$node_(442) on" 
$node_(443) set X_ 1987 
$node_(443) set Y_ 539 
$node_(443) set Z_ 0.0 
$ns at 0.0 "$node_(443) off" 
$ns at 400.0 "$node_(443) on" 
$node_(444) set X_ 1203 
$node_(444) set Y_ 510 
$node_(444) set Z_ 0.0 
$ns at 0.0 "$node_(444) off" 
$ns at 400.0 "$node_(444) on" 
$node_(445) set X_ 2715 
$node_(445) set Y_ 645 
$node_(445) set Z_ 0.0 
$ns at 0.0 "$node_(445) off" 
$ns at 400.0 "$node_(445) on" 
$node_(446) set X_ 1676 
$node_(446) set Y_ 246 
$node_(446) set Z_ 0.0 
$ns at 0.0 "$node_(446) off" 
$ns at 400.0 "$node_(446) on" 
$node_(447) set X_ 2552 
$node_(447) set Y_ 981 
$node_(447) set Z_ 0.0 
$ns at 0.0 "$node_(447) off" 
$ns at 400.0 "$node_(447) on" 
$node_(448) set X_ 2489 
$node_(448) set Y_ 571 
$node_(448) set Z_ 0.0 
$ns at 0.0 "$node_(448) off" 
$ns at 400.0 "$node_(448) on" 
$node_(449) set X_ 2571 
$node_(449) set Y_ 317 
$node_(449) set Z_ 0.0 
$ns at 0.0 "$node_(449) off" 
$ns at 400.0 "$node_(449) on" 
$node_(450) set X_ 464 
$node_(450) set Y_ 568 
$node_(450) set Z_ 0.0 
$ns at 0.0 "$node_(450) off" 
$ns at 400.0 "$node_(450) on" 
$node_(451) set X_ 1759 
$node_(451) set Y_ 527 
$node_(451) set Z_ 0.0 
$ns at 0.0 "$node_(451) off" 
$ns at 400.0 "$node_(451) on" 
$node_(452) set X_ 1591 
$node_(452) set Y_ 139 
$node_(452) set Z_ 0.0 
$ns at 0.0 "$node_(452) off" 
$ns at 400.0 "$node_(452) on" 
$node_(453) set X_ 2481 
$node_(453) set Y_ 973 
$node_(453) set Z_ 0.0 
$ns at 0.0 "$node_(453) off" 
$ns at 400.0 "$node_(453) on" 
$node_(454) set X_ 13 
$node_(454) set Y_ 275 
$node_(454) set Z_ 0.0 
$ns at 0.0 "$node_(454) off" 
$ns at 400.0 "$node_(454) on" 
$node_(455) set X_ 2887 
$node_(455) set Y_ 198 
$node_(455) set Z_ 0.0 
$ns at 0.0 "$node_(455) off" 
$ns at 400.0 "$node_(455) on" 
$node_(456) set X_ 780 
$node_(456) set Y_ 815 
$node_(456) set Z_ 0.0 
$ns at 0.0 "$node_(456) off" 
$ns at 400.0 "$node_(456) on" 
$node_(457) set X_ 741 
$node_(457) set Y_ 278 
$node_(457) set Z_ 0.0 
$ns at 0.0 "$node_(457) off" 
$ns at 400.0 "$node_(457) on" 
$node_(458) set X_ 1755 
$node_(458) set Y_ 637 
$node_(458) set Z_ 0.0 
$ns at 0.0 "$node_(458) off" 
$ns at 400.0 "$node_(458) on" 
$node_(459) set X_ 2384 
$node_(459) set Y_ 354 
$node_(459) set Z_ 0.0 
$ns at 0.0 "$node_(459) off" 
$ns at 400.0 "$node_(459) on" 
$node_(460) set X_ 1008 
$node_(460) set Y_ 14 
$node_(460) set Z_ 0.0 
$ns at 0.0 "$node_(460) off" 
$ns at 400.0 "$node_(460) on" 
$node_(461) set X_ 968 
$node_(461) set Y_ 611 
$node_(461) set Z_ 0.0 
$ns at 0.0 "$node_(461) off" 
$ns at 400.0 "$node_(461) on" 
$node_(462) set X_ 705 
$node_(462) set Y_ 858 
$node_(462) set Z_ 0.0 
$ns at 0.0 "$node_(462) off" 
$ns at 400.0 "$node_(462) on" 
$node_(463) set X_ 771 
$node_(463) set Y_ 432 
$node_(463) set Z_ 0.0 
$ns at 0.0 "$node_(463) off" 
$ns at 400.0 "$node_(463) on" 
$node_(464) set X_ 2880 
$node_(464) set Y_ 732 
$node_(464) set Z_ 0.0 
$ns at 0.0 "$node_(464) off" 
$ns at 400.0 "$node_(464) on" 
$node_(465) set X_ 2254 
$node_(465) set Y_ 525 
$node_(465) set Z_ 0.0 
$ns at 0.0 "$node_(465) off" 
$ns at 400.0 "$node_(465) on" 
$node_(466) set X_ 1606 
$node_(466) set Y_ 785 
$node_(466) set Z_ 0.0 
$ns at 0.0 "$node_(466) off" 
$ns at 400.0 "$node_(466) on" 
$node_(467) set X_ 1631 
$node_(467) set Y_ 574 
$node_(467) set Z_ 0.0 
$ns at 0.0 "$node_(467) off" 
$ns at 400.0 "$node_(467) on" 
$node_(468) set X_ 2890 
$node_(468) set Y_ 212 
$node_(468) set Z_ 0.0 
$ns at 0.0 "$node_(468) off" 
$ns at 400.0 "$node_(468) on" 
$node_(469) set X_ 1027 
$node_(469) set Y_ 375 
$node_(469) set Z_ 0.0 
$ns at 0.0 "$node_(469) off" 
$ns at 400.0 "$node_(469) on" 
$node_(470) set X_ 1163 
$node_(470) set Y_ 463 
$node_(470) set Z_ 0.0 
$ns at 0.0 "$node_(470) off" 
$ns at 400.0 "$node_(470) on" 
$node_(471) set X_ 1835 
$node_(471) set Y_ 476 
$node_(471) set Z_ 0.0 
$ns at 0.0 "$node_(471) off" 
$ns at 400.0 "$node_(471) on" 
$node_(472) set X_ 2525 
$node_(472) set Y_ 184 
$node_(472) set Z_ 0.0 
$ns at 0.0 "$node_(472) off" 
$ns at 400.0 "$node_(472) on" 
$node_(473) set X_ 623 
$node_(473) set Y_ 40 
$node_(473) set Z_ 0.0 
$ns at 0.0 "$node_(473) off" 
$ns at 400.0 "$node_(473) on" 
$node_(474) set X_ 848 
$node_(474) set Y_ 778 
$node_(474) set Z_ 0.0 
$ns at 0.0 "$node_(474) off" 
$ns at 400.0 "$node_(474) on" 
$node_(475) set X_ 918 
$node_(475) set Y_ 46 
$node_(475) set Z_ 0.0 
$ns at 0.0 "$node_(475) off" 
$ns at 400.0 "$node_(475) on" 
$node_(476) set X_ 580 
$node_(476) set Y_ 561 
$node_(476) set Z_ 0.0 
$ns at 0.0 "$node_(476) off" 
$ns at 400.0 "$node_(476) on" 
$node_(477) set X_ 1375 
$node_(477) set Y_ 961 
$node_(477) set Z_ 0.0 
$ns at 0.0 "$node_(477) off" 
$ns at 400.0 "$node_(477) on" 
$node_(478) set X_ 1491 
$node_(478) set Y_ 732 
$node_(478) set Z_ 0.0 
$ns at 0.0 "$node_(478) off" 
$ns at 400.0 "$node_(478) on" 
$node_(479) set X_ 1250 
$node_(479) set Y_ 687 
$node_(479) set Z_ 0.0 
$ns at 0.0 "$node_(479) off" 
$ns at 400.0 "$node_(479) on" 
$node_(480) set X_ 2756 
$node_(480) set Y_ 727 
$node_(480) set Z_ 0.0 
$ns at 0.0 "$node_(480) off" 
$ns at 400.0 "$node_(480) on" 
$node_(481) set X_ 1715 
$node_(481) set Y_ 955 
$node_(481) set Z_ 0.0 
$ns at 0.0 "$node_(481) off" 
$ns at 400.0 "$node_(481) on" 
$node_(482) set X_ 610 
$node_(482) set Y_ 110 
$node_(482) set Z_ 0.0 
$ns at 0.0 "$node_(482) off" 
$ns at 400.0 "$node_(482) on" 
$node_(483) set X_ 1398 
$node_(483) set Y_ 308 
$node_(483) set Z_ 0.0 
$ns at 0.0 "$node_(483) off" 
$ns at 400.0 "$node_(483) on" 
$node_(484) set X_ 2407 
$node_(484) set Y_ 832 
$node_(484) set Z_ 0.0 
$ns at 0.0 "$node_(484) off" 
$ns at 400.0 "$node_(484) on" 
$node_(485) set X_ 2591 
$node_(485) set Y_ 495 
$node_(485) set Z_ 0.0 
$ns at 0.0 "$node_(485) off" 
$ns at 400.0 "$node_(485) on" 
$node_(486) set X_ 2204 
$node_(486) set Y_ 554 
$node_(486) set Z_ 0.0 
$ns at 0.0 "$node_(486) off" 
$ns at 400.0 "$node_(486) on" 
$node_(487) set X_ 850 
$node_(487) set Y_ 377 
$node_(487) set Z_ 0.0 
$ns at 0.0 "$node_(487) off" 
$ns at 400.0 "$node_(487) on" 
$node_(488) set X_ 997 
$node_(488) set Y_ 726 
$node_(488) set Z_ 0.0 
$ns at 0.0 "$node_(488) off" 
$ns at 400.0 "$node_(488) on" 
$node_(489) set X_ 2214 
$node_(489) set Y_ 439 
$node_(489) set Z_ 0.0 
$ns at 0.0 "$node_(489) off" 
$ns at 400.0 "$node_(489) on" 
$node_(490) set X_ 1476 
$node_(490) set Y_ 324 
$node_(490) set Z_ 0.0 
$ns at 0.0 "$node_(490) off" 
$ns at 400.0 "$node_(490) on" 
$node_(491) set X_ 1981 
$node_(491) set Y_ 612 
$node_(491) set Z_ 0.0 
$ns at 0.0 "$node_(491) off" 
$ns at 400.0 "$node_(491) on" 
$node_(492) set X_ 2633 
$node_(492) set Y_ 416 
$node_(492) set Z_ 0.0 
$ns at 0.0 "$node_(492) off" 
$ns at 400.0 "$node_(492) on" 
$node_(493) set X_ 1916 
$node_(493) set Y_ 385 
$node_(493) set Z_ 0.0 
$ns at 0.0 "$node_(493) off" 
$ns at 400.0 "$node_(493) on" 
$node_(494) set X_ 689 
$node_(494) set Y_ 257 
$node_(494) set Z_ 0.0 
$ns at 0.0 "$node_(494) off" 
$ns at 400.0 "$node_(494) on" 
$node_(495) set X_ 1932 
$node_(495) set Y_ 130 
$node_(495) set Z_ 0.0 
$ns at 0.0 "$node_(495) off" 
$ns at 400.0 "$node_(495) on" 
$node_(496) set X_ 1746 
$node_(496) set Y_ 221 
$node_(496) set Z_ 0.0 
$ns at 0.0 "$node_(496) off" 
$ns at 400.0 "$node_(496) on" 
$node_(497) set X_ 2642 
$node_(497) set Y_ 139 
$node_(497) set Z_ 0.0 
$ns at 0.0 "$node_(497) off" 
$ns at 400.0 "$node_(497) on" 
$node_(498) set X_ 2133 
$node_(498) set Y_ 696 
$node_(498) set Z_ 0.0 
$ns at 0.0 "$node_(498) off" 
$ns at 400.0 "$node_(498) on" 
$node_(499) set X_ 791 
$node_(499) set Y_ 145 
$node_(499) set Z_ 0.0 
$ns at 0.0 "$node_(499) off" 
$ns at 400.0 "$node_(499) on" 
$node_(500) set X_ 1769 
$node_(500) set Y_ 986 
$node_(500) set Z_ 0.0 
$ns at 0.0 "$node_(500) off" 
$ns at 500.0 "$node_(500) on" 
$node_(501) set X_ 2366 
$node_(501) set Y_ 974 
$node_(501) set Z_ 0.0 
$ns at 0.0 "$node_(501) off" 
$ns at 500.0 "$node_(501) on" 
$node_(502) set X_ 2911 
$node_(502) set Y_ 411 
$node_(502) set Z_ 0.0 
$ns at 0.0 "$node_(502) off" 
$ns at 500.0 "$node_(502) on" 
$node_(503) set X_ 2240 
$node_(503) set Y_ 546 
$node_(503) set Z_ 0.0 
$ns at 0.0 "$node_(503) off" 
$ns at 500.0 "$node_(503) on" 
$node_(504) set X_ 1396 
$node_(504) set Y_ 21 
$node_(504) set Z_ 0.0 
$ns at 0.0 "$node_(504) off" 
$ns at 500.0 "$node_(504) on" 
$node_(505) set X_ 2435 
$node_(505) set Y_ 668 
$node_(505) set Z_ 0.0 
$ns at 0.0 "$node_(505) off" 
$ns at 500.0 "$node_(505) on" 
$node_(506) set X_ 2009 
$node_(506) set Y_ 781 
$node_(506) set Z_ 0.0 
$ns at 0.0 "$node_(506) off" 
$ns at 500.0 "$node_(506) on" 
$node_(507) set X_ 1556 
$node_(507) set Y_ 926 
$node_(507) set Z_ 0.0 
$ns at 0.0 "$node_(507) off" 
$ns at 500.0 "$node_(507) on" 
$node_(508) set X_ 2768 
$node_(508) set Y_ 655 
$node_(508) set Z_ 0.0 
$ns at 0.0 "$node_(508) off" 
$ns at 500.0 "$node_(508) on" 
$node_(509) set X_ 1650 
$node_(509) set Y_ 495 
$node_(509) set Z_ 0.0 
$ns at 0.0 "$node_(509) off" 
$ns at 500.0 "$node_(509) on" 
$node_(510) set X_ 870 
$node_(510) set Y_ 747 
$node_(510) set Z_ 0.0 
$ns at 0.0 "$node_(510) off" 
$ns at 500.0 "$node_(510) on" 
$node_(511) set X_ 1635 
$node_(511) set Y_ 912 
$node_(511) set Z_ 0.0 
$ns at 0.0 "$node_(511) off" 
$ns at 500.0 "$node_(511) on" 
$node_(512) set X_ 670 
$node_(512) set Y_ 540 
$node_(512) set Z_ 0.0 
$ns at 0.0 "$node_(512) off" 
$ns at 500.0 "$node_(512) on" 
$node_(513) set X_ 2578 
$node_(513) set Y_ 651 
$node_(513) set Z_ 0.0 
$ns at 0.0 "$node_(513) off" 
$ns at 500.0 "$node_(513) on" 
$node_(514) set X_ 422 
$node_(514) set Y_ 325 
$node_(514) set Z_ 0.0 
$ns at 0.0 "$node_(514) off" 
$ns at 500.0 "$node_(514) on" 
$node_(515) set X_ 2428 
$node_(515) set Y_ 867 
$node_(515) set Z_ 0.0 
$ns at 0.0 "$node_(515) off" 
$ns at 500.0 "$node_(515) on" 
$node_(516) set X_ 2583 
$node_(516) set Y_ 116 
$node_(516) set Z_ 0.0 
$ns at 0.0 "$node_(516) off" 
$ns at 500.0 "$node_(516) on" 
$node_(517) set X_ 1400 
$node_(517) set Y_ 819 
$node_(517) set Z_ 0.0 
$ns at 0.0 "$node_(517) off" 
$ns at 500.0 "$node_(517) on" 
$node_(518) set X_ 1301 
$node_(518) set Y_ 681 
$node_(518) set Z_ 0.0 
$ns at 0.0 "$node_(518) off" 
$ns at 500.0 "$node_(518) on" 
$node_(519) set X_ 2947 
$node_(519) set Y_ 294 
$node_(519) set Z_ 0.0 
$ns at 0.0 "$node_(519) off" 
$ns at 500.0 "$node_(519) on" 
$node_(520) set X_ 1180 
$node_(520) set Y_ 869 
$node_(520) set Z_ 0.0 
$ns at 0.0 "$node_(520) off" 
$ns at 500.0 "$node_(520) on" 
$node_(521) set X_ 2303 
$node_(521) set Y_ 811 
$node_(521) set Z_ 0.0 
$ns at 0.0 "$node_(521) off" 
$ns at 500.0 "$node_(521) on" 
$node_(522) set X_ 2706 
$node_(522) set Y_ 41 
$node_(522) set Z_ 0.0 
$ns at 0.0 "$node_(522) off" 
$ns at 500.0 "$node_(522) on" 
$node_(523) set X_ 1744 
$node_(523) set Y_ 528 
$node_(523) set Z_ 0.0 
$ns at 0.0 "$node_(523) off" 
$ns at 500.0 "$node_(523) on" 
$node_(524) set X_ 1602 
$node_(524) set Y_ 275 
$node_(524) set Z_ 0.0 
$ns at 0.0 "$node_(524) off" 
$ns at 500.0 "$node_(524) on" 
$node_(525) set X_ 2207 
$node_(525) set Y_ 519 
$node_(525) set Z_ 0.0 
$ns at 0.0 "$node_(525) off" 
$ns at 500.0 "$node_(525) on" 
$node_(526) set X_ 2119 
$node_(526) set Y_ 964 
$node_(526) set Z_ 0.0 
$ns at 0.0 "$node_(526) off" 
$ns at 500.0 "$node_(526) on" 
$node_(527) set X_ 511 
$node_(527) set Y_ 557 
$node_(527) set Z_ 0.0 
$ns at 0.0 "$node_(527) off" 
$ns at 500.0 "$node_(527) on" 
$node_(528) set X_ 2608 
$node_(528) set Y_ 591 
$node_(528) set Z_ 0.0 
$ns at 0.0 "$node_(528) off" 
$ns at 500.0 "$node_(528) on" 
$node_(529) set X_ 342 
$node_(529) set Y_ 615 
$node_(529) set Z_ 0.0 
$ns at 0.0 "$node_(529) off" 
$ns at 500.0 "$node_(529) on" 
$node_(530) set X_ 1850 
$node_(530) set Y_ 740 
$node_(530) set Z_ 0.0 
$ns at 0.0 "$node_(530) off" 
$ns at 500.0 "$node_(530) on" 
$node_(531) set X_ 1212 
$node_(531) set Y_ 31 
$node_(531) set Z_ 0.0 
$ns at 0.0 "$node_(531) off" 
$ns at 500.0 "$node_(531) on" 
$node_(532) set X_ 2445 
$node_(532) set Y_ 866 
$node_(532) set Z_ 0.0 
$ns at 0.0 "$node_(532) off" 
$ns at 500.0 "$node_(532) on" 
$node_(533) set X_ 965 
$node_(533) set Y_ 716 
$node_(533) set Z_ 0.0 
$ns at 0.0 "$node_(533) off" 
$ns at 500.0 "$node_(533) on" 
$node_(534) set X_ 2114 
$node_(534) set Y_ 934 
$node_(534) set Z_ 0.0 
$ns at 0.0 "$node_(534) off" 
$ns at 500.0 "$node_(534) on" 
$node_(535) set X_ 2885 
$node_(535) set Y_ 816 
$node_(535) set Z_ 0.0 
$ns at 0.0 "$node_(535) off" 
$ns at 500.0 "$node_(535) on" 
$node_(536) set X_ 2007 
$node_(536) set Y_ 831 
$node_(536) set Z_ 0.0 
$ns at 0.0 "$node_(536) off" 
$ns at 500.0 "$node_(536) on" 
$node_(537) set X_ 2236 
$node_(537) set Y_ 966 
$node_(537) set Z_ 0.0 
$ns at 0.0 "$node_(537) off" 
$ns at 500.0 "$node_(537) on" 
$node_(538) set X_ 124 
$node_(538) set Y_ 341 
$node_(538) set Z_ 0.0 
$ns at 0.0 "$node_(538) off" 
$ns at 500.0 "$node_(538) on" 
$node_(539) set X_ 2036 
$node_(539) set Y_ 659 
$node_(539) set Z_ 0.0 
$ns at 0.0 "$node_(539) off" 
$ns at 500.0 "$node_(539) on" 
$node_(540) set X_ 2647 
$node_(540) set Y_ 561 
$node_(540) set Z_ 0.0 
$ns at 0.0 "$node_(540) off" 
$ns at 500.0 "$node_(540) on" 
$node_(541) set X_ 1029 
$node_(541) set Y_ 244 
$node_(541) set Z_ 0.0 
$ns at 0.0 "$node_(541) off" 
$ns at 500.0 "$node_(541) on" 
$node_(542) set X_ 388 
$node_(542) set Y_ 887 
$node_(542) set Z_ 0.0 
$ns at 0.0 "$node_(542) off" 
$ns at 500.0 "$node_(542) on" 
$node_(543) set X_ 1254 
$node_(543) set Y_ 803 
$node_(543) set Z_ 0.0 
$ns at 0.0 "$node_(543) off" 
$ns at 500.0 "$node_(543) on" 
$node_(544) set X_ 2720 
$node_(544) set Y_ 44 
$node_(544) set Z_ 0.0 
$ns at 0.0 "$node_(544) off" 
$ns at 500.0 "$node_(544) on" 
$node_(545) set X_ 2212 
$node_(545) set Y_ 452 
$node_(545) set Z_ 0.0 
$ns at 0.0 "$node_(545) off" 
$ns at 500.0 "$node_(545) on" 
$node_(546) set X_ 203 
$node_(546) set Y_ 225 
$node_(546) set Z_ 0.0 
$ns at 0.0 "$node_(546) off" 
$ns at 500.0 "$node_(546) on" 
$node_(547) set X_ 1475 
$node_(547) set Y_ 631 
$node_(547) set Z_ 0.0 
$ns at 0.0 "$node_(547) off" 
$ns at 500.0 "$node_(547) on" 
$node_(548) set X_ 695 
$node_(548) set Y_ 66 
$node_(548) set Z_ 0.0 
$ns at 0.0 "$node_(548) off" 
$ns at 500.0 "$node_(548) on" 
$node_(549) set X_ 672 
$node_(549) set Y_ 601 
$node_(549) set Z_ 0.0 
$ns at 0.0 "$node_(549) off" 
$ns at 500.0 "$node_(549) on" 
$node_(550) set X_ 2039 
$node_(550) set Y_ 61 
$node_(550) set Z_ 0.0 
$ns at 0.0 "$node_(550) off" 
$ns at 500.0 "$node_(550) on" 
$node_(551) set X_ 2019 
$node_(551) set Y_ 670 
$node_(551) set Z_ 0.0 
$ns at 0.0 "$node_(551) off" 
$ns at 500.0 "$node_(551) on" 
$node_(552) set X_ 1429 
$node_(552) set Y_ 41 
$node_(552) set Z_ 0.0 
$ns at 0.0 "$node_(552) off" 
$ns at 500.0 "$node_(552) on" 
$node_(553) set X_ 1105 
$node_(553) set Y_ 633 
$node_(553) set Z_ 0.0 
$ns at 0.0 "$node_(553) off" 
$ns at 500.0 "$node_(553) on" 
$node_(554) set X_ 288 
$node_(554) set Y_ 471 
$node_(554) set Z_ 0.0 
$ns at 0.0 "$node_(554) off" 
$ns at 500.0 "$node_(554) on" 
$node_(555) set X_ 332 
$node_(555) set Y_ 546 
$node_(555) set Z_ 0.0 
$ns at 0.0 "$node_(555) off" 
$ns at 500.0 "$node_(555) on" 
$node_(556) set X_ 1949 
$node_(556) set Y_ 700 
$node_(556) set Z_ 0.0 
$ns at 0.0 "$node_(556) off" 
$ns at 500.0 "$node_(556) on" 
$node_(557) set X_ 361 
$node_(557) set Y_ 209 
$node_(557) set Z_ 0.0 
$ns at 0.0 "$node_(557) off" 
$ns at 500.0 "$node_(557) on" 
$node_(558) set X_ 1594 
$node_(558) set Y_ 733 
$node_(558) set Z_ 0.0 
$ns at 0.0 "$node_(558) off" 
$ns at 500.0 "$node_(558) on" 
$node_(559) set X_ 2062 
$node_(559) set Y_ 707 
$node_(559) set Z_ 0.0 
$ns at 0.0 "$node_(559) off" 
$ns at 500.0 "$node_(559) on" 
$node_(560) set X_ 2814 
$node_(560) set Y_ 757 
$node_(560) set Z_ 0.0 
$ns at 0.0 "$node_(560) off" 
$ns at 500.0 "$node_(560) on" 
$node_(561) set X_ 1854 
$node_(561) set Y_ 894 
$node_(561) set Z_ 0.0 
$ns at 0.0 "$node_(561) off" 
$ns at 500.0 "$node_(561) on" 
$node_(562) set X_ 722 
$node_(562) set Y_ 441 
$node_(562) set Z_ 0.0 
$ns at 0.0 "$node_(562) off" 
$ns at 500.0 "$node_(562) on" 
$node_(563) set X_ 1881 
$node_(563) set Y_ 10 
$node_(563) set Z_ 0.0 
$ns at 0.0 "$node_(563) off" 
$ns at 500.0 "$node_(563) on" 
$node_(564) set X_ 1925 
$node_(564) set Y_ 974 
$node_(564) set Z_ 0.0 
$ns at 0.0 "$node_(564) off" 
$ns at 500.0 "$node_(564) on" 
$node_(565) set X_ 335 
$node_(565) set Y_ 474 
$node_(565) set Z_ 0.0 
$ns at 0.0 "$node_(565) off" 
$ns at 500.0 "$node_(565) on" 
$node_(566) set X_ 2685 
$node_(566) set Y_ 924 
$node_(566) set Z_ 0.0 
$ns at 0.0 "$node_(566) off" 
$ns at 500.0 "$node_(566) on" 
$node_(567) set X_ 1206 
$node_(567) set Y_ 496 
$node_(567) set Z_ 0.0 
$ns at 0.0 "$node_(567) off" 
$ns at 500.0 "$node_(567) on" 
$node_(568) set X_ 340 
$node_(568) set Y_ 251 
$node_(568) set Z_ 0.0 
$ns at 0.0 "$node_(568) off" 
$ns at 500.0 "$node_(568) on" 
$node_(569) set X_ 2039 
$node_(569) set Y_ 338 
$node_(569) set Z_ 0.0 
$ns at 0.0 "$node_(569) off" 
$ns at 500.0 "$node_(569) on" 
$node_(570) set X_ 2600 
$node_(570) set Y_ 234 
$node_(570) set Z_ 0.0 
$ns at 0.0 "$node_(570) off" 
$ns at 500.0 "$node_(570) on" 
$node_(571) set X_ 720 
$node_(571) set Y_ 937 
$node_(571) set Z_ 0.0 
$ns at 0.0 "$node_(571) off" 
$ns at 500.0 "$node_(571) on" 
$node_(572) set X_ 2461 
$node_(572) set Y_ 645 
$node_(572) set Z_ 0.0 
$ns at 0.0 "$node_(572) off" 
$ns at 500.0 "$node_(572) on" 
$node_(573) set X_ 1992 
$node_(573) set Y_ 145 
$node_(573) set Z_ 0.0 
$ns at 0.0 "$node_(573) off" 
$ns at 500.0 "$node_(573) on" 
$node_(574) set X_ 471 
$node_(574) set Y_ 228 
$node_(574) set Z_ 0.0 
$ns at 0.0 "$node_(574) off" 
$ns at 500.0 "$node_(574) on" 
$node_(575) set X_ 2345 
$node_(575) set Y_ 987 
$node_(575) set Z_ 0.0 
$ns at 0.0 "$node_(575) off" 
$ns at 500.0 "$node_(575) on" 
$node_(576) set X_ 2666 
$node_(576) set Y_ 452 
$node_(576) set Z_ 0.0 
$ns at 0.0 "$node_(576) off" 
$ns at 500.0 "$node_(576) on" 
$node_(577) set X_ 2998 
$node_(577) set Y_ 233 
$node_(577) set Z_ 0.0 
$ns at 0.0 "$node_(577) off" 
$ns at 500.0 "$node_(577) on" 
$node_(578) set X_ 2883 
$node_(578) set Y_ 507 
$node_(578) set Z_ 0.0 
$ns at 0.0 "$node_(578) off" 
$ns at 500.0 "$node_(578) on" 
$node_(579) set X_ 2069 
$node_(579) set Y_ 22 
$node_(579) set Z_ 0.0 
$ns at 0.0 "$node_(579) off" 
$ns at 500.0 "$node_(579) on" 
$node_(580) set X_ 2237 
$node_(580) set Y_ 766 
$node_(580) set Z_ 0.0 
$ns at 0.0 "$node_(580) off" 
$ns at 500.0 "$node_(580) on" 
$node_(581) set X_ 2590 
$node_(581) set Y_ 471 
$node_(581) set Z_ 0.0 
$ns at 0.0 "$node_(581) off" 
$ns at 500.0 "$node_(581) on" 
$node_(582) set X_ 310 
$node_(582) set Y_ 244 
$node_(582) set Z_ 0.0 
$ns at 0.0 "$node_(582) off" 
$ns at 500.0 "$node_(582) on" 
$node_(583) set X_ 775 
$node_(583) set Y_ 994 
$node_(583) set Z_ 0.0 
$ns at 0.0 "$node_(583) off" 
$ns at 500.0 "$node_(583) on" 
$node_(584) set X_ 2167 
$node_(584) set Y_ 135 
$node_(584) set Z_ 0.0 
$ns at 0.0 "$node_(584) off" 
$ns at 500.0 "$node_(584) on" 
$node_(585) set X_ 978 
$node_(585) set Y_ 514 
$node_(585) set Z_ 0.0 
$ns at 0.0 "$node_(585) off" 
$ns at 500.0 "$node_(585) on" 
$node_(586) set X_ 2500 
$node_(586) set Y_ 151 
$node_(586) set Z_ 0.0 
$ns at 0.0 "$node_(586) off" 
$ns at 500.0 "$node_(586) on" 
$node_(587) set X_ 991 
$node_(587) set Y_ 893 
$node_(587) set Z_ 0.0 
$ns at 0.0 "$node_(587) off" 
$ns at 500.0 "$node_(587) on" 
$node_(588) set X_ 2183 
$node_(588) set Y_ 227 
$node_(588) set Z_ 0.0 
$ns at 0.0 "$node_(588) off" 
$ns at 500.0 "$node_(588) on" 
$node_(589) set X_ 2748 
$node_(589) set Y_ 669 
$node_(589) set Z_ 0.0 
$ns at 0.0 "$node_(589) off" 
$ns at 500.0 "$node_(589) on" 
$node_(590) set X_ 2170 
$node_(590) set Y_ 127 
$node_(590) set Z_ 0.0 
$ns at 0.0 "$node_(590) off" 
$ns at 500.0 "$node_(590) on" 
$node_(591) set X_ 188 
$node_(591) set Y_ 628 
$node_(591) set Z_ 0.0 
$ns at 0.0 "$node_(591) off" 
$ns at 500.0 "$node_(591) on" 
$node_(592) set X_ 1088 
$node_(592) set Y_ 642 
$node_(592) set Z_ 0.0 
$ns at 0.0 "$node_(592) off" 
$ns at 500.0 "$node_(592) on" 
$node_(593) set X_ 869 
$node_(593) set Y_ 828 
$node_(593) set Z_ 0.0 
$ns at 0.0 "$node_(593) off" 
$ns at 500.0 "$node_(593) on" 
$node_(594) set X_ 1947 
$node_(594) set Y_ 336 
$node_(594) set Z_ 0.0 
$ns at 0.0 "$node_(594) off" 
$ns at 500.0 "$node_(594) on" 
$node_(595) set X_ 1052 
$node_(595) set Y_ 439 
$node_(595) set Z_ 0.0 
$ns at 0.0 "$node_(595) off" 
$ns at 500.0 "$node_(595) on" 
$node_(596) set X_ 247 
$node_(596) set Y_ 273 
$node_(596) set Z_ 0.0 
$ns at 0.0 "$node_(596) off" 
$ns at 500.0 "$node_(596) on" 
$node_(597) set X_ 1262 
$node_(597) set Y_ 177 
$node_(597) set Z_ 0.0 
$ns at 0.0 "$node_(597) off" 
$ns at 500.0 "$node_(597) on" 
$node_(598) set X_ 296 
$node_(598) set Y_ 751 
$node_(598) set Z_ 0.0 
$ns at 0.0 "$node_(598) off" 
$ns at 500.0 "$node_(598) on" 
$node_(599) set X_ 2867 
$node_(599) set Y_ 144 
$node_(599) set Z_ 0.0 
$ns at 0.0 "$node_(599) off" 
$ns at 500.0 "$node_(599) on" 
$node_(600) set X_ 813 
$node_(600) set Y_ 840 
$node_(600) set Z_ 0.0 
$ns at 0.0 "$node_(600) off" 
$ns at 600.0 "$node_(600) on" 
$node_(601) set X_ 2976 
$node_(601) set Y_ 635 
$node_(601) set Z_ 0.0 
$ns at 0.0 "$node_(601) off" 
$ns at 600.0 "$node_(601) on" 
$node_(602) set X_ 885 
$node_(602) set Y_ 420 
$node_(602) set Z_ 0.0 
$ns at 0.0 "$node_(602) off" 
$ns at 600.0 "$node_(602) on" 
$node_(603) set X_ 1916 
$node_(603) set Y_ 816 
$node_(603) set Z_ 0.0 
$ns at 0.0 "$node_(603) off" 
$ns at 600.0 "$node_(603) on" 
$node_(604) set X_ 1038 
$node_(604) set Y_ 523 
$node_(604) set Z_ 0.0 
$ns at 0.0 "$node_(604) off" 
$ns at 600.0 "$node_(604) on" 
$node_(605) set X_ 2729 
$node_(605) set Y_ 226 
$node_(605) set Z_ 0.0 
$ns at 0.0 "$node_(605) off" 
$ns at 600.0 "$node_(605) on" 
$node_(606) set X_ 2610 
$node_(606) set Y_ 985 
$node_(606) set Z_ 0.0 
$ns at 0.0 "$node_(606) off" 
$ns at 600.0 "$node_(606) on" 
$node_(607) set X_ 2556 
$node_(607) set Y_ 725 
$node_(607) set Z_ 0.0 
$ns at 0.0 "$node_(607) off" 
$ns at 600.0 "$node_(607) on" 
$node_(608) set X_ 752 
$node_(608) set Y_ 810 
$node_(608) set Z_ 0.0 
$ns at 0.0 "$node_(608) off" 
$ns at 600.0 "$node_(608) on" 
$node_(609) set X_ 365 
$node_(609) set Y_ 859 
$node_(609) set Z_ 0.0 
$ns at 0.0 "$node_(609) off" 
$ns at 600.0 "$node_(609) on" 
$node_(610) set X_ 236 
$node_(610) set Y_ 215 
$node_(610) set Z_ 0.0 
$ns at 0.0 "$node_(610) off" 
$ns at 600.0 "$node_(610) on" 
$node_(611) set X_ 2366 
$node_(611) set Y_ 618 
$node_(611) set Z_ 0.0 
$ns at 0.0 "$node_(611) off" 
$ns at 600.0 "$node_(611) on" 
$node_(612) set X_ 2844 
$node_(612) set Y_ 970 
$node_(612) set Z_ 0.0 
$ns at 0.0 "$node_(612) off" 
$ns at 600.0 "$node_(612) on" 
$node_(613) set X_ 478 
$node_(613) set Y_ 196 
$node_(613) set Z_ 0.0 
$ns at 0.0 "$node_(613) off" 
$ns at 600.0 "$node_(613) on" 
$node_(614) set X_ 2374 
$node_(614) set Y_ 580 
$node_(614) set Z_ 0.0 
$ns at 0.0 "$node_(614) off" 
$ns at 600.0 "$node_(614) on" 
$node_(615) set X_ 2515 
$node_(615) set Y_ 680 
$node_(615) set Z_ 0.0 
$ns at 0.0 "$node_(615) off" 
$ns at 600.0 "$node_(615) on" 
$node_(616) set X_ 2356 
$node_(616) set Y_ 789 
$node_(616) set Z_ 0.0 
$ns at 0.0 "$node_(616) off" 
$ns at 600.0 "$node_(616) on" 
$node_(617) set X_ 257 
$node_(617) set Y_ 589 
$node_(617) set Z_ 0.0 
$ns at 0.0 "$node_(617) off" 
$ns at 600.0 "$node_(617) on" 
$node_(618) set X_ 2267 
$node_(618) set Y_ 124 
$node_(618) set Z_ 0.0 
$ns at 0.0 "$node_(618) off" 
$ns at 600.0 "$node_(618) on" 
$node_(619) set X_ 2268 
$node_(619) set Y_ 742 
$node_(619) set Z_ 0.0 
$ns at 0.0 "$node_(619) off" 
$ns at 600.0 "$node_(619) on" 
$node_(620) set X_ 2508 
$node_(620) set Y_ 470 
$node_(620) set Z_ 0.0 
$ns at 0.0 "$node_(620) off" 
$ns at 600.0 "$node_(620) on" 
$node_(621) set X_ 2306 
$node_(621) set Y_ 283 
$node_(621) set Z_ 0.0 
$ns at 0.0 "$node_(621) off" 
$ns at 600.0 "$node_(621) on" 
$node_(622) set X_ 2580 
$node_(622) set Y_ 175 
$node_(622) set Z_ 0.0 
$ns at 0.0 "$node_(622) off" 
$ns at 600.0 "$node_(622) on" 
$node_(623) set X_ 260 
$node_(623) set Y_ 583 
$node_(623) set Z_ 0.0 
$ns at 0.0 "$node_(623) off" 
$ns at 600.0 "$node_(623) on" 
$node_(624) set X_ 1752 
$node_(624) set Y_ 833 
$node_(624) set Z_ 0.0 
$ns at 0.0 "$node_(624) off" 
$ns at 600.0 "$node_(624) on" 
$node_(625) set X_ 1986 
$node_(625) set Y_ 333 
$node_(625) set Z_ 0.0 
$ns at 0.0 "$node_(625) off" 
$ns at 600.0 "$node_(625) on" 
$node_(626) set X_ 1179 
$node_(626) set Y_ 638 
$node_(626) set Z_ 0.0 
$ns at 0.0 "$node_(626) off" 
$ns at 600.0 "$node_(626) on" 
$node_(627) set X_ 1964 
$node_(627) set Y_ 407 
$node_(627) set Z_ 0.0 
$ns at 0.0 "$node_(627) off" 
$ns at 600.0 "$node_(627) on" 
$node_(628) set X_ 1696 
$node_(628) set Y_ 219 
$node_(628) set Z_ 0.0 
$ns at 0.0 "$node_(628) off" 
$ns at 600.0 "$node_(628) on" 
$node_(629) set X_ 1534 
$node_(629) set Y_ 965 
$node_(629) set Z_ 0.0 
$ns at 0.0 "$node_(629) off" 
$ns at 600.0 "$node_(629) on" 
$node_(630) set X_ 1601 
$node_(630) set Y_ 912 
$node_(630) set Z_ 0.0 
$ns at 0.0 "$node_(630) off" 
$ns at 600.0 "$node_(630) on" 
$node_(631) set X_ 484 
$node_(631) set Y_ 817 
$node_(631) set Z_ 0.0 
$ns at 0.0 "$node_(631) off" 
$ns at 600.0 "$node_(631) on" 
$node_(632) set X_ 2491 
$node_(632) set Y_ 732 
$node_(632) set Z_ 0.0 
$ns at 0.0 "$node_(632) off" 
$ns at 600.0 "$node_(632) on" 
$node_(633) set X_ 2015 
$node_(633) set Y_ 315 
$node_(633) set Z_ 0.0 
$ns at 0.0 "$node_(633) off" 
$ns at 600.0 "$node_(633) on" 
$node_(634) set X_ 1687 
$node_(634) set Y_ 692 
$node_(634) set Z_ 0.0 
$ns at 0.0 "$node_(634) off" 
$ns at 600.0 "$node_(634) on" 
$node_(635) set X_ 594 
$node_(635) set Y_ 872 
$node_(635) set Z_ 0.0 
$ns at 0.0 "$node_(635) off" 
$ns at 600.0 "$node_(635) on" 
$node_(636) set X_ 1013 
$node_(636) set Y_ 724 
$node_(636) set Z_ 0.0 
$ns at 0.0 "$node_(636) off" 
$ns at 600.0 "$node_(636) on" 
$node_(637) set X_ 2857 
$node_(637) set Y_ 767 
$node_(637) set Z_ 0.0 
$ns at 0.0 "$node_(637) off" 
$ns at 600.0 "$node_(637) on" 
$node_(638) set X_ 1584 
$node_(638) set Y_ 164 
$node_(638) set Z_ 0.0 
$ns at 0.0 "$node_(638) off" 
$ns at 600.0 "$node_(638) on" 
$node_(639) set X_ 663 
$node_(639) set Y_ 67 
$node_(639) set Z_ 0.0 
$ns at 0.0 "$node_(639) off" 
$ns at 600.0 "$node_(639) on" 
$node_(640) set X_ 1930 
$node_(640) set Y_ 658 
$node_(640) set Z_ 0.0 
$ns at 0.0 "$node_(640) off" 
$ns at 600.0 "$node_(640) on" 
$node_(641) set X_ 511 
$node_(641) set Y_ 338 
$node_(641) set Z_ 0.0 
$ns at 0.0 "$node_(641) off" 
$ns at 600.0 "$node_(641) on" 
$node_(642) set X_ 1097 
$node_(642) set Y_ 392 
$node_(642) set Z_ 0.0 
$ns at 0.0 "$node_(642) off" 
$ns at 600.0 "$node_(642) on" 
$node_(643) set X_ 866 
$node_(643) set Y_ 309 
$node_(643) set Z_ 0.0 
$ns at 0.0 "$node_(643) off" 
$ns at 600.0 "$node_(643) on" 
$node_(644) set X_ 1508 
$node_(644) set Y_ 753 
$node_(644) set Z_ 0.0 
$ns at 0.0 "$node_(644) off" 
$ns at 600.0 "$node_(644) on" 
$node_(645) set X_ 2514 
$node_(645) set Y_ 827 
$node_(645) set Z_ 0.0 
$ns at 0.0 "$node_(645) off" 
$ns at 600.0 "$node_(645) on" 
$node_(646) set X_ 2085 
$node_(646) set Y_ 877 
$node_(646) set Z_ 0.0 
$ns at 0.0 "$node_(646) off" 
$ns at 600.0 "$node_(646) on" 
$node_(647) set X_ 1849 
$node_(647) set Y_ 220 
$node_(647) set Z_ 0.0 
$ns at 0.0 "$node_(647) off" 
$ns at 600.0 "$node_(647) on" 
$node_(648) set X_ 723 
$node_(648) set Y_ 48 
$node_(648) set Z_ 0.0 
$ns at 0.0 "$node_(648) off" 
$ns at 600.0 "$node_(648) on" 
$node_(649) set X_ 1974 
$node_(649) set Y_ 678 
$node_(649) set Z_ 0.0 
$ns at 0.0 "$node_(649) off" 
$ns at 600.0 "$node_(649) on" 
$node_(650) set X_ 2381 
$node_(650) set Y_ 600 
$node_(650) set Z_ 0.0 
$ns at 0.0 "$node_(650) off" 
$ns at 600.0 "$node_(650) on" 
$node_(651) set X_ 738 
$node_(651) set Y_ 364 
$node_(651) set Z_ 0.0 
$ns at 0.0 "$node_(651) off" 
$ns at 600.0 "$node_(651) on" 
$node_(652) set X_ 42 
$node_(652) set Y_ 781 
$node_(652) set Z_ 0.0 
$ns at 0.0 "$node_(652) off" 
$ns at 600.0 "$node_(652) on" 
$node_(653) set X_ 2261 
$node_(653) set Y_ 763 
$node_(653) set Z_ 0.0 
$ns at 0.0 "$node_(653) off" 
$ns at 600.0 "$node_(653) on" 
$node_(654) set X_ 1451 
$node_(654) set Y_ 28 
$node_(654) set Z_ 0.0 
$ns at 0.0 "$node_(654) off" 
$ns at 600.0 "$node_(654) on" 
$node_(655) set X_ 1140 
$node_(655) set Y_ 201 
$node_(655) set Z_ 0.0 
$ns at 0.0 "$node_(655) off" 
$ns at 600.0 "$node_(655) on" 
$node_(656) set X_ 942 
$node_(656) set Y_ 233 
$node_(656) set Z_ 0.0 
$ns at 0.0 "$node_(656) off" 
$ns at 600.0 "$node_(656) on" 
$node_(657) set X_ 2430 
$node_(657) set Y_ 548 
$node_(657) set Z_ 0.0 
$ns at 0.0 "$node_(657) off" 
$ns at 600.0 "$node_(657) on" 
$node_(658) set X_ 2743 
$node_(658) set Y_ 886 
$node_(658) set Z_ 0.0 
$ns at 0.0 "$node_(658) off" 
$ns at 600.0 "$node_(658) on" 
$node_(659) set X_ 556 
$node_(659) set Y_ 891 
$node_(659) set Z_ 0.0 
$ns at 0.0 "$node_(659) off" 
$ns at 600.0 "$node_(659) on" 
$node_(660) set X_ 1026 
$node_(660) set Y_ 420 
$node_(660) set Z_ 0.0 
$ns at 0.0 "$node_(660) off" 
$ns at 600.0 "$node_(660) on" 
$node_(661) set X_ 1653 
$node_(661) set Y_ 343 
$node_(661) set Z_ 0.0 
$ns at 0.0 "$node_(661) off" 
$ns at 600.0 "$node_(661) on" 
$node_(662) set X_ 1457 
$node_(662) set Y_ 692 
$node_(662) set Z_ 0.0 
$ns at 0.0 "$node_(662) off" 
$ns at 600.0 "$node_(662) on" 
$node_(663) set X_ 338 
$node_(663) set Y_ 232 
$node_(663) set Z_ 0.0 
$ns at 0.0 "$node_(663) off" 
$ns at 600.0 "$node_(663) on" 
$node_(664) set X_ 313 
$node_(664) set Y_ 297 
$node_(664) set Z_ 0.0 
$ns at 0.0 "$node_(664) off" 
$ns at 600.0 "$node_(664) on" 
$node_(665) set X_ 683 
$node_(665) set Y_ 599 
$node_(665) set Z_ 0.0 
$ns at 0.0 "$node_(665) off" 
$ns at 600.0 "$node_(665) on" 
$node_(666) set X_ 1190 
$node_(666) set Y_ 337 
$node_(666) set Z_ 0.0 
$ns at 0.0 "$node_(666) off" 
$ns at 600.0 "$node_(666) on" 
$node_(667) set X_ 110 
$node_(667) set Y_ 361 
$node_(667) set Z_ 0.0 
$ns at 0.0 "$node_(667) off" 
$ns at 600.0 "$node_(667) on" 
$node_(668) set X_ 1038 
$node_(668) set Y_ 339 
$node_(668) set Z_ 0.0 
$ns at 0.0 "$node_(668) off" 
$ns at 600.0 "$node_(668) on" 
$node_(669) set X_ 138 
$node_(669) set Y_ 453 
$node_(669) set Z_ 0.0 
$ns at 0.0 "$node_(669) off" 
$ns at 600.0 "$node_(669) on" 
$node_(670) set X_ 1676 
$node_(670) set Y_ 225 
$node_(670) set Z_ 0.0 
$ns at 0.0 "$node_(670) off" 
$ns at 600.0 "$node_(670) on" 
$node_(671) set X_ 2290 
$node_(671) set Y_ 14 
$node_(671) set Z_ 0.0 
$ns at 0.0 "$node_(671) off" 
$ns at 600.0 "$node_(671) on" 
$node_(672) set X_ 2077 
$node_(672) set Y_ 680 
$node_(672) set Z_ 0.0 
$ns at 0.0 "$node_(672) off" 
$ns at 600.0 "$node_(672) on" 
$node_(673) set X_ 2120 
$node_(673) set Y_ 979 
$node_(673) set Z_ 0.0 
$ns at 0.0 "$node_(673) off" 
$ns at 600.0 "$node_(673) on" 
$node_(674) set X_ 2588 
$node_(674) set Y_ 738 
$node_(674) set Z_ 0.0 
$ns at 0.0 "$node_(674) off" 
$ns at 600.0 "$node_(674) on" 
$node_(675) set X_ 2130 
$node_(675) set Y_ 447 
$node_(675) set Z_ 0.0 
$ns at 0.0 "$node_(675) off" 
$ns at 600.0 "$node_(675) on" 
$node_(676) set X_ 1799 
$node_(676) set Y_ 170 
$node_(676) set Z_ 0.0 
$ns at 0.0 "$node_(676) off" 
$ns at 600.0 "$node_(676) on" 
$node_(677) set X_ 1455 
$node_(677) set Y_ 864 
$node_(677) set Z_ 0.0 
$ns at 0.0 "$node_(677) off" 
$ns at 600.0 "$node_(677) on" 
$node_(678) set X_ 104 
$node_(678) set Y_ 60 
$node_(678) set Z_ 0.0 
$ns at 0.0 "$node_(678) off" 
$ns at 600.0 "$node_(678) on" 
$node_(679) set X_ 2412 
$node_(679) set Y_ 343 
$node_(679) set Z_ 0.0 
$ns at 0.0 "$node_(679) off" 
$ns at 600.0 "$node_(679) on" 
$node_(680) set X_ 2971 
$node_(680) set Y_ 19 
$node_(680) set Z_ 0.0 
$ns at 0.0 "$node_(680) off" 
$ns at 600.0 "$node_(680) on" 
$node_(681) set X_ 1578 
$node_(681) set Y_ 439 
$node_(681) set Z_ 0.0 
$ns at 0.0 "$node_(681) off" 
$ns at 600.0 "$node_(681) on" 
$node_(682) set X_ 1723 
$node_(682) set Y_ 609 
$node_(682) set Z_ 0.0 
$ns at 0.0 "$node_(682) off" 
$ns at 600.0 "$node_(682) on" 
$node_(683) set X_ 2715 
$node_(683) set Y_ 286 
$node_(683) set Z_ 0.0 
$ns at 0.0 "$node_(683) off" 
$ns at 600.0 "$node_(683) on" 
$node_(684) set X_ 2031 
$node_(684) set Y_ 908 
$node_(684) set Z_ 0.0 
$ns at 0.0 "$node_(684) off" 
$ns at 600.0 "$node_(684) on" 
$node_(685) set X_ 842 
$node_(685) set Y_ 307 
$node_(685) set Z_ 0.0 
$ns at 0.0 "$node_(685) off" 
$ns at 600.0 "$node_(685) on" 
$node_(686) set X_ 1527 
$node_(686) set Y_ 615 
$node_(686) set Z_ 0.0 
$ns at 0.0 "$node_(686) off" 
$ns at 600.0 "$node_(686) on" 
$node_(687) set X_ 895 
$node_(687) set Y_ 640 
$node_(687) set Z_ 0.0 
$ns at 0.0 "$node_(687) off" 
$ns at 600.0 "$node_(687) on" 
$node_(688) set X_ 2829 
$node_(688) set Y_ 723 
$node_(688) set Z_ 0.0 
$ns at 0.0 "$node_(688) off" 
$ns at 600.0 "$node_(688) on" 
$node_(689) set X_ 773 
$node_(689) set Y_ 993 
$node_(689) set Z_ 0.0 
$ns at 0.0 "$node_(689) off" 
$ns at 600.0 "$node_(689) on" 
$node_(690) set X_ 2858 
$node_(690) set Y_ 606 
$node_(690) set Z_ 0.0 
$ns at 0.0 "$node_(690) off" 
$ns at 600.0 "$node_(690) on" 
$node_(691) set X_ 192 
$node_(691) set Y_ 911 
$node_(691) set Z_ 0.0 
$ns at 0.0 "$node_(691) off" 
$ns at 600.0 "$node_(691) on" 
$node_(692) set X_ 2679 
$node_(692) set Y_ 293 
$node_(692) set Z_ 0.0 
$ns at 0.0 "$node_(692) off" 
$ns at 600.0 "$node_(692) on" 
$node_(693) set X_ 1557 
$node_(693) set Y_ 342 
$node_(693) set Z_ 0.0 
$ns at 0.0 "$node_(693) off" 
$ns at 600.0 "$node_(693) on" 
$node_(694) set X_ 2137 
$node_(694) set Y_ 816 
$node_(694) set Z_ 0.0 
$ns at 0.0 "$node_(694) off" 
$ns at 600.0 "$node_(694) on" 
$node_(695) set X_ 1100 
$node_(695) set Y_ 918 
$node_(695) set Z_ 0.0 
$ns at 0.0 "$node_(695) off" 
$ns at 600.0 "$node_(695) on" 
$node_(696) set X_ 1304 
$node_(696) set Y_ 791 
$node_(696) set Z_ 0.0 
$ns at 0.0 "$node_(696) off" 
$ns at 600.0 "$node_(696) on" 
$node_(697) set X_ 1781 
$node_(697) set Y_ 624 
$node_(697) set Z_ 0.0 
$ns at 0.0 "$node_(697) off" 
$ns at 600.0 "$node_(697) on" 
$node_(698) set X_ 1274 
$node_(698) set Y_ 794 
$node_(698) set Z_ 0.0 
$ns at 0.0 "$node_(698) off" 
$ns at 600.0 "$node_(698) on" 
$node_(699) set X_ 2918 
$node_(699) set Y_ 371 
$node_(699) set Z_ 0.0 
$ns at 0.0 "$node_(699) off" 
$ns at 600.0 "$node_(699) on" 
$node_(700) set X_ 12 
$node_(700) set Y_ 681 
$node_(700) set Z_ 0.0 
$ns at 0.0 "$node_(700) off" 
$ns at 700.0 "$node_(700) on" 
$node_(701) set X_ 2201 
$node_(701) set Y_ 530 
$node_(701) set Z_ 0.0 
$ns at 0.0 "$node_(701) off" 
$ns at 700.0 "$node_(701) on" 
$node_(702) set X_ 2892 
$node_(702) set Y_ 731 
$node_(702) set Z_ 0.0 
$ns at 0.0 "$node_(702) off" 
$ns at 700.0 "$node_(702) on" 
$node_(703) set X_ 1629 
$node_(703) set Y_ 668 
$node_(703) set Z_ 0.0 
$ns at 0.0 "$node_(703) off" 
$ns at 700.0 "$node_(703) on" 
$node_(704) set X_ 1213 
$node_(704) set Y_ 365 
$node_(704) set Z_ 0.0 
$ns at 0.0 "$node_(704) off" 
$ns at 700.0 "$node_(704) on" 
$node_(705) set X_ 2079 
$node_(705) set Y_ 550 
$node_(705) set Z_ 0.0 
$ns at 0.0 "$node_(705) off" 
$ns at 700.0 "$node_(705) on" 
$node_(706) set X_ 326 
$node_(706) set Y_ 269 
$node_(706) set Z_ 0.0 
$ns at 0.0 "$node_(706) off" 
$ns at 700.0 "$node_(706) on" 
$node_(707) set X_ 1503 
$node_(707) set Y_ 12 
$node_(707) set Z_ 0.0 
$ns at 0.0 "$node_(707) off" 
$ns at 700.0 "$node_(707) on" 
$node_(708) set X_ 1084 
$node_(708) set Y_ 911 
$node_(708) set Z_ 0.0 
$ns at 0.0 "$node_(708) off" 
$ns at 700.0 "$node_(708) on" 
$node_(709) set X_ 1350 
$node_(709) set Y_ 406 
$node_(709) set Z_ 0.0 
$ns at 0.0 "$node_(709) off" 
$ns at 700.0 "$node_(709) on" 
$node_(710) set X_ 2122 
$node_(710) set Y_ 821 
$node_(710) set Z_ 0.0 
$ns at 0.0 "$node_(710) off" 
$ns at 700.0 "$node_(710) on" 
$node_(711) set X_ 1586 
$node_(711) set Y_ 169 
$node_(711) set Z_ 0.0 
$ns at 0.0 "$node_(711) off" 
$ns at 700.0 "$node_(711) on" 
$node_(712) set X_ 2004 
$node_(712) set Y_ 524 
$node_(712) set Z_ 0.0 
$ns at 0.0 "$node_(712) off" 
$ns at 700.0 "$node_(712) on" 
$node_(713) set X_ 1653 
$node_(713) set Y_ 528 
$node_(713) set Z_ 0.0 
$ns at 0.0 "$node_(713) off" 
$ns at 700.0 "$node_(713) on" 
$node_(714) set X_ 2480 
$node_(714) set Y_ 657 
$node_(714) set Z_ 0.0 
$ns at 0.0 "$node_(714) off" 
$ns at 700.0 "$node_(714) on" 
$node_(715) set X_ 2974 
$node_(715) set Y_ 447 
$node_(715) set Z_ 0.0 
$ns at 0.0 "$node_(715) off" 
$ns at 700.0 "$node_(715) on" 
$node_(716) set X_ 75 
$node_(716) set Y_ 645 
$node_(716) set Z_ 0.0 
$ns at 0.0 "$node_(716) off" 
$ns at 700.0 "$node_(716) on" 
$node_(717) set X_ 6 
$node_(717) set Y_ 751 
$node_(717) set Z_ 0.0 
$ns at 0.0 "$node_(717) off" 
$ns at 700.0 "$node_(717) on" 
$node_(718) set X_ 1882 
$node_(718) set Y_ 299 
$node_(718) set Z_ 0.0 
$ns at 0.0 "$node_(718) off" 
$ns at 700.0 "$node_(718) on" 
$node_(719) set X_ 2519 
$node_(719) set Y_ 737 
$node_(719) set Z_ 0.0 
$ns at 0.0 "$node_(719) off" 
$ns at 700.0 "$node_(719) on" 
$node_(720) set X_ 2837 
$node_(720) set Y_ 815 
$node_(720) set Z_ 0.0 
$ns at 0.0 "$node_(720) off" 
$ns at 700.0 "$node_(720) on" 
$node_(721) set X_ 2651 
$node_(721) set Y_ 719 
$node_(721) set Z_ 0.0 
$ns at 0.0 "$node_(721) off" 
$ns at 700.0 "$node_(721) on" 
$node_(722) set X_ 2850 
$node_(722) set Y_ 965 
$node_(722) set Z_ 0.0 
$ns at 0.0 "$node_(722) off" 
$ns at 700.0 "$node_(722) on" 
$node_(723) set X_ 2376 
$node_(723) set Y_ 691 
$node_(723) set Z_ 0.0 
$ns at 0.0 "$node_(723) off" 
$ns at 700.0 "$node_(723) on" 
$node_(724) set X_ 1000 
$node_(724) set Y_ 715 
$node_(724) set Z_ 0.0 
$ns at 0.0 "$node_(724) off" 
$ns at 700.0 "$node_(724) on" 
$node_(725) set X_ 340 
$node_(725) set Y_ 671 
$node_(725) set Z_ 0.0 
$ns at 0.0 "$node_(725) off" 
$ns at 700.0 "$node_(725) on" 
$node_(726) set X_ 2552 
$node_(726) set Y_ 108 
$node_(726) set Z_ 0.0 
$ns at 0.0 "$node_(726) off" 
$ns at 700.0 "$node_(726) on" 
$node_(727) set X_ 2543 
$node_(727) set Y_ 378 
$node_(727) set Z_ 0.0 
$ns at 0.0 "$node_(727) off" 
$ns at 700.0 "$node_(727) on" 
$node_(728) set X_ 1798 
$node_(728) set Y_ 19 
$node_(728) set Z_ 0.0 
$ns at 0.0 "$node_(728) off" 
$ns at 700.0 "$node_(728) on" 
$node_(729) set X_ 103 
$node_(729) set Y_ 601 
$node_(729) set Z_ 0.0 
$ns at 0.0 "$node_(729) off" 
$ns at 700.0 "$node_(729) on" 
$node_(730) set X_ 1736 
$node_(730) set Y_ 303 
$node_(730) set Z_ 0.0 
$ns at 0.0 "$node_(730) off" 
$ns at 700.0 "$node_(730) on" 
$node_(731) set X_ 1295 
$node_(731) set Y_ 980 
$node_(731) set Z_ 0.0 
$ns at 0.0 "$node_(731) off" 
$ns at 700.0 "$node_(731) on" 
$node_(732) set X_ 1290 
$node_(732) set Y_ 943 
$node_(732) set Z_ 0.0 
$ns at 0.0 "$node_(732) off" 
$ns at 700.0 "$node_(732) on" 
$node_(733) set X_ 2257 
$node_(733) set Y_ 966 
$node_(733) set Z_ 0.0 
$ns at 0.0 "$node_(733) off" 
$ns at 700.0 "$node_(733) on" 
$node_(734) set X_ 2181 
$node_(734) set Y_ 8 
$node_(734) set Z_ 0.0 
$ns at 0.0 "$node_(734) off" 
$ns at 700.0 "$node_(734) on" 
$node_(735) set X_ 2155 
$node_(735) set Y_ 389 
$node_(735) set Z_ 0.0 
$ns at 0.0 "$node_(735) off" 
$ns at 700.0 "$node_(735) on" 
$node_(736) set X_ 1720 
$node_(736) set Y_ 662 
$node_(736) set Z_ 0.0 
$ns at 0.0 "$node_(736) off" 
$ns at 700.0 "$node_(736) on" 
$node_(737) set X_ 1202 
$node_(737) set Y_ 428 
$node_(737) set Z_ 0.0 
$ns at 0.0 "$node_(737) off" 
$ns at 700.0 "$node_(737) on" 
$node_(738) set X_ 1654 
$node_(738) set Y_ 968 
$node_(738) set Z_ 0.0 
$ns at 0.0 "$node_(738) off" 
$ns at 700.0 "$node_(738) on" 
$node_(739) set X_ 2827 
$node_(739) set Y_ 760 
$node_(739) set Z_ 0.0 
$ns at 0.0 "$node_(739) off" 
$ns at 700.0 "$node_(739) on" 
$node_(740) set X_ 742 
$node_(740) set Y_ 957 
$node_(740) set Z_ 0.0 
$ns at 0.0 "$node_(740) off" 
$ns at 700.0 "$node_(740) on" 
$node_(741) set X_ 2266 
$node_(741) set Y_ 311 
$node_(741) set Z_ 0.0 
$ns at 0.0 "$node_(741) off" 
$ns at 700.0 "$node_(741) on" 
$node_(742) set X_ 2076 
$node_(742) set Y_ 279 
$node_(742) set Z_ 0.0 
$ns at 0.0 "$node_(742) off" 
$ns at 700.0 "$node_(742) on" 
$node_(743) set X_ 2218 
$node_(743) set Y_ 369 
$node_(743) set Z_ 0.0 
$ns at 0.0 "$node_(743) off" 
$ns at 700.0 "$node_(743) on" 
$node_(744) set X_ 139 
$node_(744) set Y_ 762 
$node_(744) set Z_ 0.0 
$ns at 0.0 "$node_(744) off" 
$ns at 700.0 "$node_(744) on" 
$node_(745) set X_ 2636 
$node_(745) set Y_ 750 
$node_(745) set Z_ 0.0 
$ns at 0.0 "$node_(745) off" 
$ns at 700.0 "$node_(745) on" 
$node_(746) set X_ 2360 
$node_(746) set Y_ 387 
$node_(746) set Z_ 0.0 
$ns at 0.0 "$node_(746) off" 
$ns at 700.0 "$node_(746) on" 
$node_(747) set X_ 2472 
$node_(747) set Y_ 355 
$node_(747) set Z_ 0.0 
$ns at 0.0 "$node_(747) off" 
$ns at 700.0 "$node_(747) on" 
$node_(748) set X_ 1342 
$node_(748) set Y_ 493 
$node_(748) set Z_ 0.0 
$ns at 0.0 "$node_(748) off" 
$ns at 700.0 "$node_(748) on" 
$node_(749) set X_ 2151 
$node_(749) set Y_ 730 
$node_(749) set Z_ 0.0 
$ns at 0.0 "$node_(749) off" 
$ns at 700.0 "$node_(749) on" 
$node_(750) set X_ 2144 
$node_(750) set Y_ 534 
$node_(750) set Z_ 0.0 
$ns at 0.0 "$node_(750) off" 
$ns at 700.0 "$node_(750) on" 
$node_(751) set X_ 1649 
$node_(751) set Y_ 166 
$node_(751) set Z_ 0.0 
$ns at 0.0 "$node_(751) off" 
$ns at 700.0 "$node_(751) on" 
$node_(752) set X_ 862 
$node_(752) set Y_ 308 
$node_(752) set Z_ 0.0 
$ns at 0.0 "$node_(752) off" 
$ns at 700.0 "$node_(752) on" 
$node_(753) set X_ 2481 
$node_(753) set Y_ 472 
$node_(753) set Z_ 0.0 
$ns at 0.0 "$node_(753) off" 
$ns at 700.0 "$node_(753) on" 
$node_(754) set X_ 1376 
$node_(754) set Y_ 427 
$node_(754) set Z_ 0.0 
$ns at 0.0 "$node_(754) off" 
$ns at 700.0 "$node_(754) on" 
$node_(755) set X_ 469 
$node_(755) set Y_ 811 
$node_(755) set Z_ 0.0 
$ns at 0.0 "$node_(755) off" 
$ns at 700.0 "$node_(755) on" 
$node_(756) set X_ 2459 
$node_(756) set Y_ 687 
$node_(756) set Z_ 0.0 
$ns at 0.0 "$node_(756) off" 
$ns at 700.0 "$node_(756) on" 
$node_(757) set X_ 1966 
$node_(757) set Y_ 874 
$node_(757) set Z_ 0.0 
$ns at 0.0 "$node_(757) off" 
$ns at 700.0 "$node_(757) on" 
$node_(758) set X_ 2471 
$node_(758) set Y_ 148 
$node_(758) set Z_ 0.0 
$ns at 0.0 "$node_(758) off" 
$ns at 700.0 "$node_(758) on" 
$node_(759) set X_ 2267 
$node_(759) set Y_ 238 
$node_(759) set Z_ 0.0 
$ns at 0.0 "$node_(759) off" 
$ns at 700.0 "$node_(759) on" 
$node_(760) set X_ 654 
$node_(760) set Y_ 985 
$node_(760) set Z_ 0.0 
$ns at 0.0 "$node_(760) off" 
$ns at 700.0 "$node_(760) on" 
$node_(761) set X_ 159 
$node_(761) set Y_ 970 
$node_(761) set Z_ 0.0 
$ns at 0.0 "$node_(761) off" 
$ns at 700.0 "$node_(761) on" 
$node_(762) set X_ 1505 
$node_(762) set Y_ 570 
$node_(762) set Z_ 0.0 
$ns at 0.0 "$node_(762) off" 
$ns at 700.0 "$node_(762) on" 
$node_(763) set X_ 1054 
$node_(763) set Y_ 414 
$node_(763) set Z_ 0.0 
$ns at 0.0 "$node_(763) off" 
$ns at 700.0 "$node_(763) on" 
$node_(764) set X_ 1908 
$node_(764) set Y_ 850 
$node_(764) set Z_ 0.0 
$ns at 0.0 "$node_(764) off" 
$ns at 700.0 "$node_(764) on" 
$node_(765) set X_ 2823 
$node_(765) set Y_ 601 
$node_(765) set Z_ 0.0 
$ns at 0.0 "$node_(765) off" 
$ns at 700.0 "$node_(765) on" 
$node_(766) set X_ 653 
$node_(766) set Y_ 803 
$node_(766) set Z_ 0.0 
$ns at 0.0 "$node_(766) off" 
$ns at 700.0 "$node_(766) on" 
$node_(767) set X_ 1347 
$node_(767) set Y_ 956 
$node_(767) set Z_ 0.0 
$ns at 0.0 "$node_(767) off" 
$ns at 700.0 "$node_(767) on" 
$node_(768) set X_ 561 
$node_(768) set Y_ 637 
$node_(768) set Z_ 0.0 
$ns at 0.0 "$node_(768) off" 
$ns at 700.0 "$node_(768) on" 
$node_(769) set X_ 943 
$node_(769) set Y_ 763 
$node_(769) set Z_ 0.0 
$ns at 0.0 "$node_(769) off" 
$ns at 700.0 "$node_(769) on" 
$node_(770) set X_ 2849 
$node_(770) set Y_ 444 
$node_(770) set Z_ 0.0 
$ns at 0.0 "$node_(770) off" 
$ns at 700.0 "$node_(770) on" 
$node_(771) set X_ 163 
$node_(771) set Y_ 382 
$node_(771) set Z_ 0.0 
$ns at 0.0 "$node_(771) off" 
$ns at 700.0 "$node_(771) on" 
$node_(772) set X_ 1388 
$node_(772) set Y_ 240 
$node_(772) set Z_ 0.0 
$ns at 0.0 "$node_(772) off" 
$ns at 700.0 "$node_(772) on" 
$node_(773) set X_ 2997 
$node_(773) set Y_ 350 
$node_(773) set Z_ 0.0 
$ns at 0.0 "$node_(773) off" 
$ns at 700.0 "$node_(773) on" 
$node_(774) set X_ 1370 
$node_(774) set Y_ 638 
$node_(774) set Z_ 0.0 
$ns at 0.0 "$node_(774) off" 
$ns at 700.0 "$node_(774) on" 
$node_(775) set X_ 339 
$node_(775) set Y_ 318 
$node_(775) set Z_ 0.0 
$ns at 0.0 "$node_(775) off" 
$ns at 700.0 "$node_(775) on" 
$node_(776) set X_ 1334 
$node_(776) set Y_ 960 
$node_(776) set Z_ 0.0 
$ns at 0.0 "$node_(776) off" 
$ns at 700.0 "$node_(776) on" 
$node_(777) set X_ 2535 
$node_(777) set Y_ 222 
$node_(777) set Z_ 0.0 
$ns at 0.0 "$node_(777) off" 
$ns at 700.0 "$node_(777) on" 
$node_(778) set X_ 1818 
$node_(778) set Y_ 229 
$node_(778) set Z_ 0.0 
$ns at 0.0 "$node_(778) off" 
$ns at 700.0 "$node_(778) on" 
$node_(779) set X_ 2063 
$node_(779) set Y_ 241 
$node_(779) set Z_ 0.0 
$ns at 0.0 "$node_(779) off" 
$ns at 700.0 "$node_(779) on" 
$node_(780) set X_ 2789 
$node_(780) set Y_ 317 
$node_(780) set Z_ 0.0 
$ns at 0.0 "$node_(780) off" 
$ns at 700.0 "$node_(780) on" 
$node_(781) set X_ 839 
$node_(781) set Y_ 830 
$node_(781) set Z_ 0.0 
$ns at 0.0 "$node_(781) off" 
$ns at 700.0 "$node_(781) on" 
$node_(782) set X_ 710 
$node_(782) set Y_ 521 
$node_(782) set Z_ 0.0 
$ns at 0.0 "$node_(782) off" 
$ns at 700.0 "$node_(782) on" 
$node_(783) set X_ 1286 
$node_(783) set Y_ 596 
$node_(783) set Z_ 0.0 
$ns at 0.0 "$node_(783) off" 
$ns at 700.0 "$node_(783) on" 
$node_(784) set X_ 2488 
$node_(784) set Y_ 947 
$node_(784) set Z_ 0.0 
$ns at 0.0 "$node_(784) off" 
$ns at 700.0 "$node_(784) on" 
$node_(785) set X_ 1185 
$node_(785) set Y_ 843 
$node_(785) set Z_ 0.0 
$ns at 0.0 "$node_(785) off" 
$ns at 700.0 "$node_(785) on" 
$node_(786) set X_ 1641 
$node_(786) set Y_ 411 
$node_(786) set Z_ 0.0 
$ns at 0.0 "$node_(786) off" 
$ns at 700.0 "$node_(786) on" 
$node_(787) set X_ 413 
$node_(787) set Y_ 364 
$node_(787) set Z_ 0.0 
$ns at 0.0 "$node_(787) off" 
$ns at 700.0 "$node_(787) on" 
$node_(788) set X_ 2867 
$node_(788) set Y_ 983 
$node_(788) set Z_ 0.0 
$ns at 0.0 "$node_(788) off" 
$ns at 700.0 "$node_(788) on" 
$node_(789) set X_ 2994 
$node_(789) set Y_ 489 
$node_(789) set Z_ 0.0 
$ns at 0.0 "$node_(789) off" 
$ns at 700.0 "$node_(789) on" 
$node_(790) set X_ 736 
$node_(790) set Y_ 926 
$node_(790) set Z_ 0.0 
$ns at 0.0 "$node_(790) off" 
$ns at 700.0 "$node_(790) on" 
$node_(791) set X_ 1413 
$node_(791) set Y_ 409 
$node_(791) set Z_ 0.0 
$ns at 0.0 "$node_(791) off" 
$ns at 700.0 "$node_(791) on" 
$node_(792) set X_ 479 
$node_(792) set Y_ 555 
$node_(792) set Z_ 0.0 
$ns at 0.0 "$node_(792) off" 
$ns at 700.0 "$node_(792) on" 
$node_(793) set X_ 887 
$node_(793) set Y_ 562 
$node_(793) set Z_ 0.0 
$ns at 0.0 "$node_(793) off" 
$ns at 700.0 "$node_(793) on" 
$node_(794) set X_ 2862 
$node_(794) set Y_ 415 
$node_(794) set Z_ 0.0 
$ns at 0.0 "$node_(794) off" 
$ns at 700.0 "$node_(794) on" 
$node_(795) set X_ 269 
$node_(795) set Y_ 199 
$node_(795) set Z_ 0.0 
$ns at 0.0 "$node_(795) off" 
$ns at 700.0 "$node_(795) on" 
$node_(796) set X_ 2797 
$node_(796) set Y_ 316 
$node_(796) set Z_ 0.0 
$ns at 0.0 "$node_(796) off" 
$ns at 700.0 "$node_(796) on" 
$node_(797) set X_ 434 
$node_(797) set Y_ 306 
$node_(797) set Z_ 0.0 
$ns at 0.0 "$node_(797) off" 
$ns at 700.0 "$node_(797) on" 
$node_(798) set X_ 1797 
$node_(798) set Y_ 935 
$node_(798) set Z_ 0.0 
$ns at 0.0 "$node_(798) off" 
$ns at 700.0 "$node_(798) on" 
$node_(799) set X_ 2407 
$node_(799) set Y_ 718 
$node_(799) set Z_ 0.0 
$ns at 0.0 "$node_(799) off" 
$ns at 700.0 "$node_(799) on" 

# Generation of movements
$ns at 0.0 "$node_(0) setdest 79049 3963 1.0" 
$ns at 36.291028169701335 "$node_(0) setdest 74163 18644 10.0" 
$ns at 132.60345348380613 "$node_(0) setdest 34382 9293 5.0" 
$ns at 180.87623062009862 "$node_(0) setdest 48769 37534 19.0" 
$ns at 258.4328368495536 "$node_(0) setdest 21727 1787 18.0" 
$ns at 382.67671100221037 "$node_(0) setdest 143502 3816 15.0" 
$ns at 445.1814761364993 "$node_(0) setdest 87188 63077 10.0" 
$ns at 549.788041545295 "$node_(0) setdest 139126 61035 17.0" 
$ns at 723.9027653719392 "$node_(0) setdest 185042 6320 19.0" 
$ns at 835.1064230879005 "$node_(0) setdest 55067 84598 16.0" 
$ns at 883.1720732388322 "$node_(0) setdest 53665 72489 9.0" 
$ns at 0.0 "$node_(1) setdest 78577 15794 9.0" 
$ns at 51.76444432051673 "$node_(1) setdest 89839 3337 9.0" 
$ns at 148.92235888433294 "$node_(1) setdest 20894 13782 7.0" 
$ns at 201.49362123710983 "$node_(1) setdest 44950 4688 2.0" 
$ns at 234.29815326139345 "$node_(1) setdest 31425 42777 13.0" 
$ns at 362.275922994146 "$node_(1) setdest 20039 24891 4.0" 
$ns at 399.54923213582106 "$node_(1) setdest 123688 14763 10.0" 
$ns at 492.9776370311924 "$node_(1) setdest 182151 64569 1.0" 
$ns at 527.2192157879681 "$node_(1) setdest 16202 15525 3.0" 
$ns at 569.8252682015253 "$node_(1) setdest 171215 18238 9.0" 
$ns at 676.8172851251408 "$node_(1) setdest 109430 71990 18.0" 
$ns at 784.6149228821308 "$node_(1) setdest 116170 8137 1.0" 
$ns at 819.0242437855081 "$node_(1) setdest 224521 20129 8.0" 
$ns at 852.7097303805261 "$node_(1) setdest 237457 26389 18.0" 
$ns at 0.0 "$node_(2) setdest 71361 10309 5.0" 
$ns at 62.35595126336548 "$node_(2) setdest 25632 14764 12.0" 
$ns at 212.07862855145288 "$node_(2) setdest 105830 29008 4.0" 
$ns at 269.333293576616 "$node_(2) setdest 26878 10189 4.0" 
$ns at 323.0491881640451 "$node_(2) setdest 84596 36062 20.0" 
$ns at 430.070023622889 "$node_(2) setdest 184478 30397 9.0" 
$ns at 505.73075396157066 "$node_(2) setdest 19446 56997 12.0" 
$ns at 538.7414349097611 "$node_(2) setdest 2212 55997 8.0" 
$ns at 633.9866845720107 "$node_(2) setdest 161563 61995 15.0" 
$ns at 773.6834107016963 "$node_(2) setdest 221885 72440 1.0" 
$ns at 813.453506014849 "$node_(2) setdest 259258 14982 19.0" 
$ns at 891.7866859189711 "$node_(2) setdest 174387 73724 17.0" 
$ns at 0.0 "$node_(3) setdest 92667 11616 17.0" 
$ns at 69.03018611505124 "$node_(3) setdest 5782 15345 9.0" 
$ns at 125.78136750346282 "$node_(3) setdest 43000 31154 19.0" 
$ns at 303.90465895960347 "$node_(3) setdest 43108 6530 9.0" 
$ns at 385.837746169156 "$node_(3) setdest 45800 48665 10.0" 
$ns at 469.629082126376 "$node_(3) setdest 116830 70222 7.0" 
$ns at 522.8676457740266 "$node_(3) setdest 53875 37775 1.0" 
$ns at 557.1183649948755 "$node_(3) setdest 199946 13351 1.0" 
$ns at 587.3922433313071 "$node_(3) setdest 90233 15208 2.0" 
$ns at 632.5841226393895 "$node_(3) setdest 113765 67184 9.0" 
$ns at 690.4299972281464 "$node_(3) setdest 38132 39053 18.0" 
$ns at 816.8682227307518 "$node_(3) setdest 99971 36833 20.0" 
$ns at 0.0 "$node_(4) setdest 93444 30532 5.0" 
$ns at 77.51323690665356 "$node_(4) setdest 48575 8509 6.0" 
$ns at 108.31749557865493 "$node_(4) setdest 49097 24652 20.0" 
$ns at 240.24261215251732 "$node_(4) setdest 58139 31731 5.0" 
$ns at 293.0527951468167 "$node_(4) setdest 41055 40198 14.0" 
$ns at 365.1441109837672 "$node_(4) setdest 147138 3451 14.0" 
$ns at 433.7845481852893 "$node_(4) setdest 74824 56571 6.0" 
$ns at 479.12846559802523 "$node_(4) setdest 80816 44627 13.0" 
$ns at 607.6550644530455 "$node_(4) setdest 201502 5643 7.0" 
$ns at 672.313958586942 "$node_(4) setdest 125140 69577 15.0" 
$ns at 742.8766517376436 "$node_(4) setdest 167533 29501 2.0" 
$ns at 774.4418850820754 "$node_(4) setdest 258079 82614 5.0" 
$ns at 853.7648656922532 "$node_(4) setdest 35890 81039 16.0" 
$ns at 0.0 "$node_(5) setdest 43324 15941 1.0" 
$ns at 31.0499055258637 "$node_(5) setdest 77207 19657 6.0" 
$ns at 90.2218847339283 "$node_(5) setdest 22945 23463 3.0" 
$ns at 121.1397166036794 "$node_(5) setdest 89013 9838 7.0" 
$ns at 151.40681031602637 "$node_(5) setdest 125381 35992 17.0" 
$ns at 218.44394036015512 "$node_(5) setdest 98578 23084 5.0" 
$ns at 269.88621091624253 "$node_(5) setdest 37035 6194 11.0" 
$ns at 370.03227778309576 "$node_(5) setdest 13626 11648 5.0" 
$ns at 442.1766409536717 "$node_(5) setdest 120625 20033 13.0" 
$ns at 481.5958050813392 "$node_(5) setdest 36135 51754 7.0" 
$ns at 543.592692589475 "$node_(5) setdest 144344 9841 5.0" 
$ns at 608.4519215697696 "$node_(5) setdest 86214 20759 6.0" 
$ns at 669.8518791411982 "$node_(5) setdest 12404 40359 18.0" 
$ns at 817.5153656294324 "$node_(5) setdest 52580 88764 7.0" 
$ns at 869.2520849871389 "$node_(5) setdest 180192 39216 15.0" 
$ns at 0.0 "$node_(6) setdest 18312 1365 2.0" 
$ns at 44.56702926000533 "$node_(6) setdest 73409 3208 13.0" 
$ns at 109.02048261619602 "$node_(6) setdest 28535 9796 20.0" 
$ns at 225.06137216971177 "$node_(6) setdest 40151 14515 13.0" 
$ns at 384.6600235364218 "$node_(6) setdest 137112 62146 11.0" 
$ns at 467.18500430075466 "$node_(6) setdest 62993 57764 17.0" 
$ns at 518.6552564683599 "$node_(6) setdest 116327 60683 15.0" 
$ns at 683.259577802055 "$node_(6) setdest 36900 18768 6.0" 
$ns at 772.5018157155482 "$node_(6) setdest 164018 59877 11.0" 
$ns at 881.2299107547506 "$node_(6) setdest 197073 7982 9.0" 
$ns at 0.0 "$node_(7) setdest 30282 30388 18.0" 
$ns at 83.59964713874801 "$node_(7) setdest 88669 26357 11.0" 
$ns at 152.4131960496985 "$node_(7) setdest 60108 12439 11.0" 
$ns at 191.00324657299964 "$node_(7) setdest 3233 7113 17.0" 
$ns at 263.8381143885836 "$node_(7) setdest 22232 37830 4.0" 
$ns at 294.31688706174623 "$node_(7) setdest 144488 27992 3.0" 
$ns at 330.9373450470508 "$node_(7) setdest 92503 50327 19.0" 
$ns at 423.7348101996312 "$node_(7) setdest 14747 31481 6.0" 
$ns at 461.4737833296564 "$node_(7) setdest 14196 41220 10.0" 
$ns at 534.5922889497828 "$node_(7) setdest 55828 29111 18.0" 
$ns at 587.4124695318428 "$node_(7) setdest 153866 26730 7.0" 
$ns at 686.4301395482255 "$node_(7) setdest 97879 20656 5.0" 
$ns at 730.5414761645577 "$node_(7) setdest 55516 80563 13.0" 
$ns at 838.4294415818154 "$node_(7) setdest 190028 76607 10.0" 
$ns at 883.8757431975228 "$node_(7) setdest 213279 46932 1.0" 
$ns at 0.0 "$node_(8) setdest 57305 4596 14.0" 
$ns at 101.08494897843848 "$node_(8) setdest 77109 12194 9.0" 
$ns at 201.24463163733736 "$node_(8) setdest 88287 19769 9.0" 
$ns at 287.41099670004274 "$node_(8) setdest 25116 31448 15.0" 
$ns at 350.741495297987 "$node_(8) setdest 101460 28153 10.0" 
$ns at 472.8624704160169 "$node_(8) setdest 67209 48732 15.0" 
$ns at 570.2836656061447 "$node_(8) setdest 131753 30034 10.0" 
$ns at 683.6175672748548 "$node_(8) setdest 50605 46512 19.0" 
$ns at 822.4484855597201 "$node_(8) setdest 39753 28207 4.0" 
$ns at 858.8945910452982 "$node_(8) setdest 54580 14453 13.0" 
$ns at 0.0 "$node_(9) setdest 28047 19649 13.0" 
$ns at 75.31464505647986 "$node_(9) setdest 61058 20218 8.0" 
$ns at 131.65300644518106 "$node_(9) setdest 94744 7412 18.0" 
$ns at 232.40565620229643 "$node_(9) setdest 101239 14337 2.0" 
$ns at 265.8662779799189 "$node_(9) setdest 35184 5637 13.0" 
$ns at 340.9244485636891 "$node_(9) setdest 117260 6836 9.0" 
$ns at 383.3365740905642 "$node_(9) setdest 118212 55054 6.0" 
$ns at 450.1910298729307 "$node_(9) setdest 98257 57054 6.0" 
$ns at 489.0813705888127 "$node_(9) setdest 108581 62720 4.0" 
$ns at 539.3811631832134 "$node_(9) setdest 64935 58754 3.0" 
$ns at 592.8398819570621 "$node_(9) setdest 90872 73620 14.0" 
$ns at 729.1489763608463 "$node_(9) setdest 128909 74512 8.0" 
$ns at 792.9841194161681 "$node_(9) setdest 57591 37831 2.0" 
$ns at 842.1459287119845 "$node_(9) setdest 116608 30879 9.0" 
$ns at 874.6677769040922 "$node_(9) setdest 84227 55171 18.0" 
$ns at 0.0 "$node_(10) setdest 80134 2884 8.0" 
$ns at 57.44779701309757 "$node_(10) setdest 38766 18779 4.0" 
$ns at 118.09894362534195 "$node_(10) setdest 49615 20185 2.0" 
$ns at 161.077246530837 "$node_(10) setdest 41455 34586 9.0" 
$ns at 234.8502775442582 "$node_(10) setdest 39558 18357 2.0" 
$ns at 272.2311433481165 "$node_(10) setdest 28176 54405 11.0" 
$ns at 355.6998188566647 "$node_(10) setdest 5549 34192 8.0" 
$ns at 395.46021602167417 "$node_(10) setdest 80092 58087 8.0" 
$ns at 488.35732785453774 "$node_(10) setdest 69743 47997 6.0" 
$ns at 521.332701036905 "$node_(10) setdest 150685 66531 8.0" 
$ns at 571.6123185456456 "$node_(10) setdest 209276 45185 4.0" 
$ns at 621.7475537318078 "$node_(10) setdest 117713 74909 15.0" 
$ns at 691.1363350185856 "$node_(10) setdest 212487 43074 19.0" 
$ns at 801.2274207670876 "$node_(10) setdest 55558 65800 16.0" 
$ns at 0.0 "$node_(11) setdest 34261 22195 9.0" 
$ns at 118.0036211610786 "$node_(11) setdest 81508 17748 1.0" 
$ns at 149.49251568151828 "$node_(11) setdest 54525 12603 14.0" 
$ns at 226.39215130200665 "$node_(11) setdest 116759 28981 18.0" 
$ns at 403.22175967916706 "$node_(11) setdest 100847 19168 14.0" 
$ns at 515.0537702433409 "$node_(11) setdest 66530 26042 1.0" 
$ns at 545.7141419540839 "$node_(11) setdest 114396 25255 8.0" 
$ns at 592.0799289141273 "$node_(11) setdest 161420 11609 7.0" 
$ns at 647.7068991715765 "$node_(11) setdest 88360 15140 14.0" 
$ns at 764.3123629785232 "$node_(11) setdest 77966 77603 5.0" 
$ns at 830.9922452147775 "$node_(11) setdest 32369 68408 16.0" 
$ns at 0.0 "$node_(12) setdest 40513 27920 17.0" 
$ns at 118.81099812684451 "$node_(12) setdest 48144 27919 12.0" 
$ns at 173.82984897073763 "$node_(12) setdest 40899 5633 13.0" 
$ns at 266.4426543038123 "$node_(12) setdest 31384 41367 9.0" 
$ns at 366.63740044088655 "$node_(12) setdest 45507 54740 9.0" 
$ns at 400.75774921458105 "$node_(12) setdest 49451 45624 4.0" 
$ns at 453.51232276168145 "$node_(12) setdest 91177 4274 9.0" 
$ns at 489.21627129276504 "$node_(12) setdest 176772 52880 12.0" 
$ns at 622.2134035016985 "$node_(12) setdest 142008 33893 10.0" 
$ns at 694.2958325404443 "$node_(12) setdest 171165 36762 5.0" 
$ns at 745.7774140748977 "$node_(12) setdest 54862 57767 8.0" 
$ns at 797.2678379037047 "$node_(12) setdest 38242 52488 11.0" 
$ns at 840.5405234159005 "$node_(12) setdest 244717 39691 5.0" 
$ns at 0.0 "$node_(13) setdest 74780 16482 3.0" 
$ns at 34.21577802844673 "$node_(13) setdest 55247 27745 1.0" 
$ns at 72.59590978530349 "$node_(13) setdest 57750 25112 14.0" 
$ns at 238.83880901769527 "$node_(13) setdest 26980 6940 11.0" 
$ns at 328.33020432353175 "$node_(13) setdest 112184 52230 7.0" 
$ns at 424.93808026695257 "$node_(13) setdest 23876 3343 19.0" 
$ns at 488.74744036822034 "$node_(13) setdest 123575 30753 2.0" 
$ns at 535.4399784078994 "$node_(13) setdest 153945 30343 3.0" 
$ns at 586.0953702762906 "$node_(13) setdest 232049 64758 12.0" 
$ns at 732.3919788644833 "$node_(13) setdest 110324 36413 16.0" 
$ns at 822.6191519674921 "$node_(13) setdest 86443 8684 20.0" 
$ns at 0.0 "$node_(14) setdest 59800 19196 14.0" 
$ns at 50.98118489299512 "$node_(14) setdest 16588 11187 5.0" 
$ns at 95.39294698634724 "$node_(14) setdest 80568 7406 17.0" 
$ns at 128.72077102561053 "$node_(14) setdest 11655 15289 13.0" 
$ns at 176.69277318009836 "$node_(14) setdest 49931 29120 11.0" 
$ns at 296.08312733127985 "$node_(14) setdest 10565 33661 6.0" 
$ns at 374.08160976714316 "$node_(14) setdest 23245 21761 1.0" 
$ns at 407.1718437449516 "$node_(14) setdest 5356 7438 1.0" 
$ns at 444.11698001883207 "$node_(14) setdest 65147 1200 10.0" 
$ns at 499.8946713854414 "$node_(14) setdest 79155 59998 7.0" 
$ns at 542.1640433195079 "$node_(14) setdest 134072 1752 11.0" 
$ns at 679.9613378460032 "$node_(14) setdest 156518 55454 1.0" 
$ns at 710.7620044942089 "$node_(14) setdest 50377 64950 18.0" 
$ns at 833.5380067039792 "$node_(14) setdest 116194 42134 14.0" 
$ns at 0.0 "$node_(15) setdest 45178 2266 15.0" 
$ns at 108.02173984850482 "$node_(15) setdest 39020 11206 9.0" 
$ns at 207.0079878075582 "$node_(15) setdest 53952 20053 5.0" 
$ns at 255.5937988912878 "$node_(15) setdest 132261 27919 17.0" 
$ns at 324.84802564782444 "$node_(15) setdest 9332 53307 18.0" 
$ns at 388.9455942439864 "$node_(15) setdest 50916 2856 5.0" 
$ns at 419.6661500664696 "$node_(15) setdest 85420 6930 12.0" 
$ns at 536.830549244734 "$node_(15) setdest 45609 63175 9.0" 
$ns at 608.6676162934871 "$node_(15) setdest 142517 43184 5.0" 
$ns at 655.6867707991775 "$node_(15) setdest 121886 30493 6.0" 
$ns at 725.2595946772583 "$node_(15) setdest 86031 17647 12.0" 
$ns at 815.382093279188 "$node_(15) setdest 86597 9457 12.0" 
$ns at 0.0 "$node_(16) setdest 20368 19800 14.0" 
$ns at 105.52272457320505 "$node_(16) setdest 84383 15499 13.0" 
$ns at 177.77399254154898 "$node_(16) setdest 98008 28907 15.0" 
$ns at 297.52936061715343 "$node_(16) setdest 134865 38397 15.0" 
$ns at 464.5231071164882 "$node_(16) setdest 150205 5466 14.0" 
$ns at 632.9826835307472 "$node_(16) setdest 126729 2628 7.0" 
$ns at 702.1151004846071 "$node_(16) setdest 70715 46612 16.0" 
$ns at 798.0505549088153 "$node_(16) setdest 98489 16468 11.0" 
$ns at 877.6708221959838 "$node_(16) setdest 33337 1502 9.0" 
$ns at 0.0 "$node_(17) setdest 51531 17085 9.0" 
$ns at 65.87698513276337 "$node_(17) setdest 71523 11833 10.0" 
$ns at 134.63356980875977 "$node_(17) setdest 80530 23811 10.0" 
$ns at 256.13322167811924 "$node_(17) setdest 6651 19558 9.0" 
$ns at 310.09922709458726 "$node_(17) setdest 59983 5378 18.0" 
$ns at 494.7200044336456 "$node_(17) setdest 57808 42380 14.0" 
$ns at 543.3821302321551 "$node_(17) setdest 101597 28630 19.0" 
$ns at 709.3694042972476 "$node_(17) setdest 100463 33883 15.0" 
$ns at 842.5068650515384 "$node_(17) setdest 89831 50673 16.0" 
$ns at 0.0 "$node_(18) setdest 30038 26069 9.0" 
$ns at 82.49243678238588 "$node_(18) setdest 21208 28646 3.0" 
$ns at 121.668983856095 "$node_(18) setdest 27511 29646 16.0" 
$ns at 231.02696228057584 "$node_(18) setdest 87155 40812 11.0" 
$ns at 262.2065934594603 "$node_(18) setdest 149835 26752 15.0" 
$ns at 398.6803889780309 "$node_(18) setdest 11907 7801 4.0" 
$ns at 445.5345177456362 "$node_(18) setdest 32797 16815 8.0" 
$ns at 550.0347995164102 "$node_(18) setdest 114763 12688 11.0" 
$ns at 688.8286505906668 "$node_(18) setdest 133058 73118 5.0" 
$ns at 733.2153643608635 "$node_(18) setdest 146205 18576 2.0" 
$ns at 783.183312973173 "$node_(18) setdest 21357 70487 1.0" 
$ns at 820.3596082650471 "$node_(18) setdest 197119 42300 10.0" 
$ns at 0.0 "$node_(19) setdest 18630 26578 7.0" 
$ns at 44.600494547967955 "$node_(19) setdest 37841 7059 19.0" 
$ns at 125.25719777004194 "$node_(19) setdest 24323 16741 6.0" 
$ns at 190.73856652353135 "$node_(19) setdest 93849 35615 10.0" 
$ns at 276.46370754081283 "$node_(19) setdest 49734 43667 12.0" 
$ns at 408.01299108922314 "$node_(19) setdest 173500 27025 6.0" 
$ns at 469.07104016838605 "$node_(19) setdest 163282 12127 13.0" 
$ns at 515.83380924531 "$node_(19) setdest 113800 48502 12.0" 
$ns at 642.1311063206235 "$node_(19) setdest 146140 32036 6.0" 
$ns at 730.5152482330865 "$node_(19) setdest 227491 16697 20.0" 
$ns at 770.4372764661268 "$node_(19) setdest 152502 6223 19.0" 
$ns at 871.9218003112393 "$node_(19) setdest 175885 62031 2.0" 
$ns at 0.0 "$node_(20) setdest 6715 17957 9.0" 
$ns at 95.41138210578758 "$node_(20) setdest 42394 19582 2.0" 
$ns at 141.1611301015077 "$node_(20) setdest 47641 23966 18.0" 
$ns at 311.2434900434077 "$node_(20) setdest 123656 48732 11.0" 
$ns at 425.8268324262606 "$node_(20) setdest 109081 2192 16.0" 
$ns at 476.3529406338566 "$node_(20) setdest 139076 34781 19.0" 
$ns at 521.3732469985963 "$node_(20) setdest 169357 31368 19.0" 
$ns at 724.2252342509377 "$node_(20) setdest 229765 83244 4.0" 
$ns at 759.8111437800511 "$node_(20) setdest 209459 36690 7.0" 
$ns at 835.3160583202535 "$node_(20) setdest 210336 20124 9.0" 
$ns at 880.3257698569518 "$node_(20) setdest 132594 88452 10.0" 
$ns at 0.0 "$node_(21) setdest 29553 19748 5.0" 
$ns at 64.36365674292045 "$node_(21) setdest 82448 24543 5.0" 
$ns at 111.14329043274067 "$node_(21) setdest 12445 2119 1.0" 
$ns at 149.4973031681568 "$node_(21) setdest 31031 27870 2.0" 
$ns at 185.4703629332216 "$node_(21) setdest 128526 6544 17.0" 
$ns at 344.94125659514276 "$node_(21) setdest 19622 32939 7.0" 
$ns at 442.79371748749986 "$node_(21) setdest 55710 13243 1.0" 
$ns at 480.1474275897701 "$node_(21) setdest 123472 48952 12.0" 
$ns at 527.0828760380498 "$node_(21) setdest 15579 46157 9.0" 
$ns at 626.782101057242 "$node_(21) setdest 156081 29642 16.0" 
$ns at 784.3961223502166 "$node_(21) setdest 65570 22559 18.0" 
$ns at 0.0 "$node_(22) setdest 37498 16578 5.0" 
$ns at 77.49954436961644 "$node_(22) setdest 48587 17228 20.0" 
$ns at 152.34813902924412 "$node_(22) setdest 133764 23385 11.0" 
$ns at 215.37348093399072 "$node_(22) setdest 100109 23831 17.0" 
$ns at 386.5317406121261 "$node_(22) setdest 2951 59816 1.0" 
$ns at 425.88829900768616 "$node_(22) setdest 147988 14554 14.0" 
$ns at 546.3872954020547 "$node_(22) setdest 121957 67041 17.0" 
$ns at 663.5988656893395 "$node_(22) setdest 149576 68454 16.0" 
$ns at 697.7792594734071 "$node_(22) setdest 131140 76558 18.0" 
$ns at 842.7029286488414 "$node_(22) setdest 35515 38854 11.0" 
$ns at 0.0 "$node_(23) setdest 26300 30437 13.0" 
$ns at 82.10485511771711 "$node_(23) setdest 19086 27183 8.0" 
$ns at 178.67119001199075 "$node_(23) setdest 67283 8571 17.0" 
$ns at 253.68277124191252 "$node_(23) setdest 41829 34265 8.0" 
$ns at 357.0342021121123 "$node_(23) setdest 182061 53251 15.0" 
$ns at 504.2753544271662 "$node_(23) setdest 209756 22061 4.0" 
$ns at 563.4881095211647 "$node_(23) setdest 40961 57061 11.0" 
$ns at 684.1089421273767 "$node_(23) setdest 5939 4333 10.0" 
$ns at 767.5975458370862 "$node_(23) setdest 203746 59546 6.0" 
$ns at 815.6733067477171 "$node_(23) setdest 39056 46095 6.0" 
$ns at 857.6988841079533 "$node_(23) setdest 133585 53743 3.0" 
$ns at 0.0 "$node_(24) setdest 80896 28214 5.0" 
$ns at 32.29076457548621 "$node_(24) setdest 57036 28030 18.0" 
$ns at 234.91613828331026 "$node_(24) setdest 25598 28628 8.0" 
$ns at 326.7804082424182 "$node_(24) setdest 113544 43903 20.0" 
$ns at 400.4313299089564 "$node_(24) setdest 22196 1360 17.0" 
$ns at 571.1008806707758 "$node_(24) setdest 95141 10690 11.0" 
$ns at 676.3298845571412 "$node_(24) setdest 221167 58199 1.0" 
$ns at 713.9380749926637 "$node_(24) setdest 190155 57502 16.0" 
$ns at 828.6304404789138 "$node_(24) setdest 43493 79375 2.0" 
$ns at 867.3922125593792 "$node_(24) setdest 141394 70019 4.0" 
$ns at 0.0 "$node_(25) setdest 89865 28512 12.0" 
$ns at 49.348235759111155 "$node_(25) setdest 41443 9205 19.0" 
$ns at 194.05980245584118 "$node_(25) setdest 52900 73 16.0" 
$ns at 231.61114575669188 "$node_(25) setdest 112970 31128 4.0" 
$ns at 282.13078479979254 "$node_(25) setdest 26702 50585 7.0" 
$ns at 328.9597916608707 "$node_(25) setdest 20177 9420 20.0" 
$ns at 468.0788894378587 "$node_(25) setdest 202107 38454 10.0" 
$ns at 577.296922937891 "$node_(25) setdest 28243 61104 9.0" 
$ns at 609.251168712588 "$node_(25) setdest 56658 36465 1.0" 
$ns at 642.1392427713662 "$node_(25) setdest 55465 18952 18.0" 
$ns at 834.0468090161191 "$node_(25) setdest 124449 51808 7.0" 
$ns at 0.0 "$node_(26) setdest 4876 24345 10.0" 
$ns at 121.46616260952368 "$node_(26) setdest 8015 23971 20.0" 
$ns at 162.31097049151327 "$node_(26) setdest 76261 4362 11.0" 
$ns at 235.52849805236582 "$node_(26) setdest 50624 17413 2.0" 
$ns at 279.50366916441044 "$node_(26) setdest 79541 35316 4.0" 
$ns at 317.1716130258717 "$node_(26) setdest 134578 18098 8.0" 
$ns at 375.20229955509717 "$node_(26) setdest 8550 18912 5.0" 
$ns at 429.16462246874886 "$node_(26) setdest 73073 26304 2.0" 
$ns at 462.0608524698825 "$node_(26) setdest 83375 32129 1.0" 
$ns at 495.12859960898 "$node_(26) setdest 46671 53144 1.0" 
$ns at 528.5410724019339 "$node_(26) setdest 105290 13589 17.0" 
$ns at 589.4642563981145 "$node_(26) setdest 97895 24640 18.0" 
$ns at 707.5426772111595 "$node_(26) setdest 8613 62801 16.0" 
$ns at 753.4976602472361 "$node_(26) setdest 248759 58577 12.0" 
$ns at 783.6334713673884 "$node_(26) setdest 227322 60599 13.0" 
$ns at 0.0 "$node_(27) setdest 70635 20342 6.0" 
$ns at 57.62160151730998 "$node_(27) setdest 77324 9843 4.0" 
$ns at 118.77409634846296 "$node_(27) setdest 735 20823 1.0" 
$ns at 151.2801348806506 "$node_(27) setdest 37471 21652 12.0" 
$ns at 247.00917049320384 "$node_(27) setdest 80899 27307 3.0" 
$ns at 287.0545436347075 "$node_(27) setdest 60661 32462 17.0" 
$ns at 394.2595109612776 "$node_(27) setdest 66507 40664 16.0" 
$ns at 467.1645668707278 "$node_(27) setdest 179842 30359 15.0" 
$ns at 634.1268461082494 "$node_(27) setdest 227779 39382 20.0" 
$ns at 819.2552214204388 "$node_(27) setdest 91179 37632 19.0" 
$ns at 0.0 "$node_(28) setdest 36979 28232 17.0" 
$ns at 111.20331863553866 "$node_(28) setdest 5197 5249 3.0" 
$ns at 143.9722512605279 "$node_(28) setdest 87664 6465 19.0" 
$ns at 286.9060722263997 "$node_(28) setdest 60657 23025 10.0" 
$ns at 396.76105513961124 "$node_(28) setdest 125786 37997 12.0" 
$ns at 512.1569421116677 "$node_(28) setdest 186705 64970 18.0" 
$ns at 568.0823355331778 "$node_(28) setdest 222424 20881 14.0" 
$ns at 729.7012579485535 "$node_(28) setdest 199558 57156 8.0" 
$ns at 816.3399769138218 "$node_(28) setdest 187664 21117 2.0" 
$ns at 847.3438655542388 "$node_(28) setdest 206362 63377 3.0" 
$ns at 879.6426207994888 "$node_(28) setdest 18632 19210 12.0" 
$ns at 0.0 "$node_(29) setdest 52630 5472 9.0" 
$ns at 31.491343166380897 "$node_(29) setdest 70359 8700 9.0" 
$ns at 136.72557425180221 "$node_(29) setdest 7300 17854 7.0" 
$ns at 222.5511116689511 "$node_(29) setdest 106361 15269 2.0" 
$ns at 264.7134327152235 "$node_(29) setdest 130743 20314 19.0" 
$ns at 412.72710760304494 "$node_(29) setdest 151519 50340 14.0" 
$ns at 493.7522256141568 "$node_(29) setdest 99928 15957 2.0" 
$ns at 531.0188662129478 "$node_(29) setdest 181932 49834 20.0" 
$ns at 675.8379366147676 "$node_(29) setdest 173956 54936 1.0" 
$ns at 706.7060478438354 "$node_(29) setdest 133125 36488 6.0" 
$ns at 781.7527903383578 "$node_(29) setdest 211809 74152 12.0" 
$ns at 815.4628138161265 "$node_(29) setdest 250023 61782 1.0" 
$ns at 852.5857308509031 "$node_(29) setdest 261607 83193 1.0" 
$ns at 882.9454187091686 "$node_(29) setdest 125027 19095 15.0" 
$ns at 0.0 "$node_(30) setdest 81239 2782 9.0" 
$ns at 84.80639845928292 "$node_(30) setdest 89264 22330 1.0" 
$ns at 120.71221745041126 "$node_(30) setdest 62038 30686 7.0" 
$ns at 156.85233918609967 "$node_(30) setdest 6974 31774 15.0" 
$ns at 199.2036186994673 "$node_(30) setdest 101406 20452 3.0" 
$ns at 247.51965956988778 "$node_(30) setdest 63264 21549 1.0" 
$ns at 279.39398998024234 "$node_(30) setdest 76584 1782 2.0" 
$ns at 326.36074853802523 "$node_(30) setdest 5637 6664 13.0" 
$ns at 436.0165592233653 "$node_(30) setdest 11575 49807 17.0" 
$ns at 586.0990111638434 "$node_(30) setdest 175575 37931 1.0" 
$ns at 616.7090170562927 "$node_(30) setdest 120078 14235 18.0" 
$ns at 728.1508104351271 "$node_(30) setdest 168451 55591 5.0" 
$ns at 764.8710698224655 "$node_(30) setdest 139837 86474 2.0" 
$ns at 814.4489971110795 "$node_(30) setdest 197815 86953 9.0" 
$ns at 0.0 "$node_(31) setdest 60107 27734 17.0" 
$ns at 56.344854301820156 "$node_(31) setdest 26408 26980 7.0" 
$ns at 86.84067463049878 "$node_(31) setdest 66949 1638 11.0" 
$ns at 169.32299618966798 "$node_(31) setdest 96851 3837 5.0" 
$ns at 212.5432214630838 "$node_(31) setdest 124310 11770 12.0" 
$ns at 299.39960144738217 "$node_(31) setdest 99739 7484 6.0" 
$ns at 347.3686176235618 "$node_(31) setdest 17299 21153 12.0" 
$ns at 446.02998276340065 "$node_(31) setdest 20291 41592 11.0" 
$ns at 486.12929210085235 "$node_(31) setdest 11624 52438 9.0" 
$ns at 550.6353826772473 "$node_(31) setdest 128376 30867 1.0" 
$ns at 589.4966590169303 "$node_(31) setdest 44049 16117 6.0" 
$ns at 656.3267039453258 "$node_(31) setdest 174354 4594 16.0" 
$ns at 687.8854894398821 "$node_(31) setdest 175893 20802 10.0" 
$ns at 723.7884617482433 "$node_(31) setdest 174689 68716 10.0" 
$ns at 825.7842738976857 "$node_(31) setdest 247514 21910 20.0" 
$ns at 0.0 "$node_(32) setdest 8261 21133 6.0" 
$ns at 54.81631889433896 "$node_(32) setdest 71271 24822 9.0" 
$ns at 145.2828612661589 "$node_(32) setdest 16903 19410 18.0" 
$ns at 315.8150803083495 "$node_(32) setdest 38459 43692 4.0" 
$ns at 380.7206330182138 "$node_(32) setdest 125815 32132 1.0" 
$ns at 418.06555082494583 "$node_(32) setdest 130063 43041 7.0" 
$ns at 499.4997853525928 "$node_(32) setdest 85778 7157 7.0" 
$ns at 543.4444188081327 "$node_(32) setdest 201509 57443 9.0" 
$ns at 645.5080772628291 "$node_(32) setdest 148107 32054 18.0" 
$ns at 691.4815861492508 "$node_(32) setdest 168224 8234 14.0" 
$ns at 791.3558028889086 "$node_(32) setdest 22050 60745 4.0" 
$ns at 823.6391494144086 "$node_(32) setdest 181674 39385 1.0" 
$ns at 858.7939433484421 "$node_(32) setdest 188166 33753 13.0" 
$ns at 0.0 "$node_(33) setdest 81770 8743 20.0" 
$ns at 210.3870384317491 "$node_(33) setdest 12214 5841 9.0" 
$ns at 273.0344343990654 "$node_(33) setdest 24178 32148 18.0" 
$ns at 416.9666930402852 "$node_(33) setdest 141560 30290 4.0" 
$ns at 473.63881218940287 "$node_(33) setdest 88251 538 6.0" 
$ns at 537.5019261088535 "$node_(33) setdest 145051 57015 16.0" 
$ns at 679.9504509964715 "$node_(33) setdest 129700 79326 14.0" 
$ns at 710.3060196487778 "$node_(33) setdest 42178 78359 9.0" 
$ns at 772.3977188764658 "$node_(33) setdest 188621 76745 5.0" 
$ns at 819.4250594904178 "$node_(33) setdest 139582 15055 1.0" 
$ns at 850.1186080647441 "$node_(33) setdest 33409 3185 6.0" 
$ns at 0.0 "$node_(34) setdest 24226 24317 8.0" 
$ns at 53.29852602511917 "$node_(34) setdest 21970 19738 6.0" 
$ns at 138.33429782223567 "$node_(34) setdest 3102 6227 10.0" 
$ns at 204.6445989069585 "$node_(34) setdest 27569 30862 2.0" 
$ns at 253.3369476832135 "$node_(34) setdest 25882 31302 5.0" 
$ns at 316.2969894057499 "$node_(34) setdest 128070 28887 3.0" 
$ns at 375.23700452479954 "$node_(34) setdest 118393 10165 12.0" 
$ns at 413.90126686421377 "$node_(34) setdest 11837 36872 14.0" 
$ns at 475.2120650555137 "$node_(34) setdest 198615 64024 2.0" 
$ns at 508.67133320481634 "$node_(34) setdest 48760 45789 7.0" 
$ns at 562.2969580635172 "$node_(34) setdest 45713 19388 2.0" 
$ns at 604.8350909694191 "$node_(34) setdest 45059 15979 19.0" 
$ns at 681.4812765179794 "$node_(34) setdest 49963 66986 4.0" 
$ns at 739.4449000585423 "$node_(34) setdest 154782 7886 16.0" 
$ns at 0.0 "$node_(35) setdest 48882 18175 1.0" 
$ns at 39.29996466785078 "$node_(35) setdest 83491 26901 1.0" 
$ns at 78.90270303645808 "$node_(35) setdest 77228 27555 16.0" 
$ns at 159.15240053946525 "$node_(35) setdest 117425 18642 9.0" 
$ns at 276.001853732177 "$node_(35) setdest 147792 1190 4.0" 
$ns at 328.52124894027554 "$node_(35) setdest 119080 3949 3.0" 
$ns at 377.8526249597442 "$node_(35) setdest 39383 34503 16.0" 
$ns at 453.58962957422995 "$node_(35) setdest 169923 53207 8.0" 
$ns at 513.5952350687229 "$node_(35) setdest 159156 34002 14.0" 
$ns at 567.1301757063889 "$node_(35) setdest 152142 11342 20.0" 
$ns at 788.5608796369394 "$node_(35) setdest 199447 81126 1.0" 
$ns at 823.3743237807869 "$node_(35) setdest 191858 19000 6.0" 
$ns at 864.1483519582516 "$node_(35) setdest 109446 83200 20.0" 
$ns at 0.0 "$node_(36) setdest 83169 396 5.0" 
$ns at 45.40856967990905 "$node_(36) setdest 64857 20600 1.0" 
$ns at 82.40292939514522 "$node_(36) setdest 31890 218 17.0" 
$ns at 274.5016459210212 "$node_(36) setdest 138239 48536 15.0" 
$ns at 407.95635905395727 "$node_(36) setdest 55071 12871 3.0" 
$ns at 438.71752477746975 "$node_(36) setdest 44241 41438 10.0" 
$ns at 511.72031536171255 "$node_(36) setdest 76549 57118 14.0" 
$ns at 644.0518308722552 "$node_(36) setdest 155764 55506 6.0" 
$ns at 679.6366155668503 "$node_(36) setdest 215526 22286 4.0" 
$ns at 742.5951204661252 "$node_(36) setdest 41124 55026 14.0" 
$ns at 848.016760560661 "$node_(36) setdest 66960 76031 14.0" 
$ns at 0.0 "$node_(37) setdest 1842 10033 6.0" 
$ns at 56.21188614233387 "$node_(37) setdest 41398 5371 7.0" 
$ns at 91.53893032592231 "$node_(37) setdest 49578 17611 19.0" 
$ns at 193.23522249895393 "$node_(37) setdest 96625 12129 4.0" 
$ns at 227.97786346259426 "$node_(37) setdest 94422 29138 1.0" 
$ns at 263.4685421877505 "$node_(37) setdest 90946 10986 5.0" 
$ns at 312.5365602773652 "$node_(37) setdest 151294 44820 5.0" 
$ns at 383.54724876559055 "$node_(37) setdest 85185 11955 15.0" 
$ns at 542.0481358274751 "$node_(37) setdest 52433 46204 18.0" 
$ns at 626.3654219746819 "$node_(37) setdest 152782 65643 5.0" 
$ns at 703.264353986101 "$node_(37) setdest 227267 41567 8.0" 
$ns at 791.3605692327451 "$node_(37) setdest 128193 1581 2.0" 
$ns at 825.791159606669 "$node_(37) setdest 62246 88875 12.0" 
$ns at 882.615876211494 "$node_(37) setdest 83664 15600 9.0" 
$ns at 0.0 "$node_(38) setdest 86641 11777 11.0" 
$ns at 65.92717270886007 "$node_(38) setdest 78635 16510 7.0" 
$ns at 124.59267946715777 "$node_(38) setdest 45656 6624 2.0" 
$ns at 160.34752935649897 "$node_(38) setdest 114249 8115 3.0" 
$ns at 203.0824669663158 "$node_(38) setdest 41020 31248 15.0" 
$ns at 238.89869053631344 "$node_(38) setdest 110935 4941 11.0" 
$ns at 288.52516043139735 "$node_(38) setdest 94121 38190 18.0" 
$ns at 386.29366684567515 "$node_(38) setdest 189016 41350 17.0" 
$ns at 466.67148954735035 "$node_(38) setdest 209347 4591 20.0" 
$ns at 537.768434518971 "$node_(38) setdest 132998 61197 6.0" 
$ns at 580.3095811286491 "$node_(38) setdest 43042 5330 14.0" 
$ns at 739.1770714857498 "$node_(38) setdest 230729 83628 8.0" 
$ns at 821.2878520320378 "$node_(38) setdest 27595 77915 12.0" 
$ns at 882.5087410369059 "$node_(38) setdest 121031 72720 1.0" 
$ns at 0.0 "$node_(39) setdest 73628 11720 7.0" 
$ns at 45.019661426114794 "$node_(39) setdest 26095 18199 8.0" 
$ns at 97.19730088331289 "$node_(39) setdest 30701 28992 1.0" 
$ns at 135.37623640637037 "$node_(39) setdest 2884 29416 19.0" 
$ns at 244.64824549095934 "$node_(39) setdest 12367 29808 11.0" 
$ns at 374.6514147103512 "$node_(39) setdest 129526 75 8.0" 
$ns at 452.9700487112708 "$node_(39) setdest 43832 42613 4.0" 
$ns at 490.65265204616145 "$node_(39) setdest 160247 27623 1.0" 
$ns at 526.0047910486041 "$node_(39) setdest 2425 34211 6.0" 
$ns at 566.6357180674011 "$node_(39) setdest 38694 74470 1.0" 
$ns at 603.4464141510601 "$node_(39) setdest 33112 19031 15.0" 
$ns at 758.9989777915547 "$node_(39) setdest 8725 49089 9.0" 
$ns at 822.6673649846654 "$node_(39) setdest 58349 55659 11.0" 
$ns at 858.9799021623844 "$node_(39) setdest 14600 89156 9.0" 
$ns at 0.0 "$node_(40) setdest 36310 241 15.0" 
$ns at 62.445189783531845 "$node_(40) setdest 33017 5131 1.0" 
$ns at 101.7331202628582 "$node_(40) setdest 19506 26148 10.0" 
$ns at 178.9997081227491 "$node_(40) setdest 111674 35010 13.0" 
$ns at 253.96348706838867 "$node_(40) setdest 106737 51294 17.0" 
$ns at 385.4178585167872 "$node_(40) setdest 102283 22271 8.0" 
$ns at 483.6150739428618 "$node_(40) setdest 25743 58221 16.0" 
$ns at 581.5734975654486 "$node_(40) setdest 106085 30760 12.0" 
$ns at 627.1821958640083 "$node_(40) setdest 192345 48150 16.0" 
$ns at 700.1514176578728 "$node_(40) setdest 193643 67118 13.0" 
$ns at 817.6971222004436 "$node_(40) setdest 249691 19462 19.0" 
$ns at 0.0 "$node_(41) setdest 59016 2364 18.0" 
$ns at 50.96092201707939 "$node_(41) setdest 22598 30415 13.0" 
$ns at 170.73068264407632 "$node_(41) setdest 97244 31124 8.0" 
$ns at 245.76265517780354 "$node_(41) setdest 56590 33885 3.0" 
$ns at 297.88753114443074 "$node_(41) setdest 80411 52162 15.0" 
$ns at 422.2051365860209 "$node_(41) setdest 188648 34585 8.0" 
$ns at 457.1622167928394 "$node_(41) setdest 102730 63074 19.0" 
$ns at 516.3282036302633 "$node_(41) setdest 114734 32511 5.0" 
$ns at 581.6728391953172 "$node_(41) setdest 85219 23236 14.0" 
$ns at 721.8265435718082 "$node_(41) setdest 235736 12746 13.0" 
$ns at 858.3744855397144 "$node_(41) setdest 171685 74942 11.0" 
$ns at 0.0 "$node_(42) setdest 52845 3063 15.0" 
$ns at 37.494176461688426 "$node_(42) setdest 80700 23450 18.0" 
$ns at 173.40849495569208 "$node_(42) setdest 89399 37912 13.0" 
$ns at 276.3041020925497 "$node_(42) setdest 15154 39546 8.0" 
$ns at 349.681303475042 "$node_(42) setdest 92283 30182 9.0" 
$ns at 400.56432453407695 "$node_(42) setdest 175100 60940 9.0" 
$ns at 456.8958675742156 "$node_(42) setdest 25671 15389 1.0" 
$ns at 495.8156339534719 "$node_(42) setdest 14016 25742 7.0" 
$ns at 595.1272896150342 "$node_(42) setdest 185523 40982 4.0" 
$ns at 651.3499956245735 "$node_(42) setdest 126588 34454 1.0" 
$ns at 687.3813181350521 "$node_(42) setdest 71404 16437 7.0" 
$ns at 766.6480184769716 "$node_(42) setdest 222709 30710 11.0" 
$ns at 844.106364942752 "$node_(42) setdest 87475 12610 4.0" 
$ns at 877.510520098949 "$node_(42) setdest 259351 42654 2.0" 
$ns at 0.0 "$node_(43) setdest 41742 517 16.0" 
$ns at 89.35227835138092 "$node_(43) setdest 59174 27383 10.0" 
$ns at 205.4255561784837 "$node_(43) setdest 68796 37666 14.0" 
$ns at 270.14611533620536 "$node_(43) setdest 16359 36558 14.0" 
$ns at 410.8902845128273 "$node_(43) setdest 98832 48597 6.0" 
$ns at 463.59887549813607 "$node_(43) setdest 62040 61483 7.0" 
$ns at 543.4131750563263 "$node_(43) setdest 183071 16902 3.0" 
$ns at 576.7422970538531 "$node_(43) setdest 8660 21079 14.0" 
$ns at 629.8385986784493 "$node_(43) setdest 9426 5961 13.0" 
$ns at 773.423226815554 "$node_(43) setdest 34291 77546 11.0" 
$ns at 806.7886648424479 "$node_(43) setdest 181309 22976 9.0" 
$ns at 866.7000616832183 "$node_(43) setdest 171627 845 8.0" 
$ns at 0.0 "$node_(44) setdest 9932 12258 6.0" 
$ns at 68.6405997872501 "$node_(44) setdest 39487 890 11.0" 
$ns at 175.8280957743499 "$node_(44) setdest 4717 7717 4.0" 
$ns at 221.43639531460587 "$node_(44) setdest 111607 7438 3.0" 
$ns at 261.7032699838724 "$node_(44) setdest 876 20161 10.0" 
$ns at 293.7092994902455 "$node_(44) setdest 31929 54748 2.0" 
$ns at 328.1537209630555 "$node_(44) setdest 104122 506 11.0" 
$ns at 455.63611435264744 "$node_(44) setdest 85043 51232 15.0" 
$ns at 625.5228515363524 "$node_(44) setdest 208467 71458 19.0" 
$ns at 694.5305862815617 "$node_(44) setdest 178464 80564 9.0" 
$ns at 772.1317769198622 "$node_(44) setdest 248519 71101 1.0" 
$ns at 807.3840440771494 "$node_(44) setdest 200846 87270 4.0" 
$ns at 841.819190896957 "$node_(44) setdest 14865 28547 5.0" 
$ns at 898.363630952386 "$node_(44) setdest 26035 38598 1.0" 
$ns at 0.0 "$node_(45) setdest 11102 5826 12.0" 
$ns at 62.49901113170556 "$node_(45) setdest 9659 3937 5.0" 
$ns at 134.92008063459372 "$node_(45) setdest 20552 29447 1.0" 
$ns at 166.28510846631178 "$node_(45) setdest 99435 12753 12.0" 
$ns at 287.3284250534954 "$node_(45) setdest 78659 51670 5.0" 
$ns at 326.14906961651945 "$node_(45) setdest 111836 20813 17.0" 
$ns at 483.6872531373579 "$node_(45) setdest 106173 6423 9.0" 
$ns at 565.6146477090782 "$node_(45) setdest 203029 42071 3.0" 
$ns at 622.6347212036075 "$node_(45) setdest 116799 61847 9.0" 
$ns at 687.9380017875881 "$node_(45) setdest 80768 2972 1.0" 
$ns at 725.4039290657727 "$node_(45) setdest 103988 46597 20.0" 
$ns at 0.0 "$node_(46) setdest 81298 11880 8.0" 
$ns at 51.9722784082878 "$node_(46) setdest 36236 4650 15.0" 
$ns at 209.2105691547103 "$node_(46) setdest 8157 1637 9.0" 
$ns at 246.90164166594695 "$node_(46) setdest 58928 4272 16.0" 
$ns at 337.3040614708705 "$node_(46) setdest 112164 46755 16.0" 
$ns at 397.2411075609424 "$node_(46) setdest 61950 8421 3.0" 
$ns at 430.61522985238105 "$node_(46) setdest 32280 33984 1.0" 
$ns at 461.8701671197095 "$node_(46) setdest 148233 47654 17.0" 
$ns at 550.2222673847572 "$node_(46) setdest 40959 72536 2.0" 
$ns at 588.3890409202996 "$node_(46) setdest 48684 45326 7.0" 
$ns at 683.1726887195791 "$node_(46) setdest 38863 79057 17.0" 
$ns at 786.2783287036738 "$node_(46) setdest 56121 68686 1.0" 
$ns at 816.7664526813329 "$node_(46) setdest 109738 17728 2.0" 
$ns at 853.8525468187202 "$node_(46) setdest 12507 28388 19.0" 
$ns at 0.0 "$node_(47) setdest 19453 30122 11.0" 
$ns at 102.79107791855643 "$node_(47) setdest 20078 8934 2.0" 
$ns at 145.3117679498419 "$node_(47) setdest 77393 25059 16.0" 
$ns at 226.38029615007764 "$node_(47) setdest 108247 13183 8.0" 
$ns at 333.11520716898025 "$node_(47) setdest 99509 3316 5.0" 
$ns at 402.01855178124794 "$node_(47) setdest 16531 37030 3.0" 
$ns at 453.1046604886164 "$node_(47) setdest 110607 10932 6.0" 
$ns at 498.62712955890737 "$node_(47) setdest 11766 11375 4.0" 
$ns at 560.367085978355 "$node_(47) setdest 140023 6647 9.0" 
$ns at 592.8447413974286 "$node_(47) setdest 81923 11994 1.0" 
$ns at 627.749480240865 "$node_(47) setdest 86601 73074 2.0" 
$ns at 670.236541289074 "$node_(47) setdest 233217 52626 8.0" 
$ns at 716.4743635643811 "$node_(47) setdest 56970 13350 8.0" 
$ns at 766.2107478451026 "$node_(47) setdest 64239 30317 19.0" 
$ns at 0.0 "$node_(48) setdest 16921 22766 3.0" 
$ns at 52.44611067112362 "$node_(48) setdest 89450 7495 13.0" 
$ns at 141.99249033668568 "$node_(48) setdest 54591 22554 8.0" 
$ns at 248.63685492768104 "$node_(48) setdest 47545 32664 4.0" 
$ns at 297.0952114601763 "$node_(48) setdest 107759 47405 13.0" 
$ns at 363.32343025859285 "$node_(48) setdest 24492 61024 12.0" 
$ns at 441.2125911400589 "$node_(48) setdest 9083 60262 3.0" 
$ns at 494.2679640092648 "$node_(48) setdest 195555 46164 4.0" 
$ns at 553.374969623213 "$node_(48) setdest 135846 18390 17.0" 
$ns at 611.7660936465127 "$node_(48) setdest 2016 16730 14.0" 
$ns at 739.9217065547255 "$node_(48) setdest 10588 26894 18.0" 
$ns at 872.315680896796 "$node_(48) setdest 29128 23380 7.0" 
$ns at 0.0 "$node_(49) setdest 63311 1999 5.0" 
$ns at 65.22442560678829 "$node_(49) setdest 84838 20916 6.0" 
$ns at 144.09456503326658 "$node_(49) setdest 57500 14235 3.0" 
$ns at 175.1102557480164 "$node_(49) setdest 124796 33809 5.0" 
$ns at 239.54589566953555 "$node_(49) setdest 80168 25633 1.0" 
$ns at 270.6512971253955 "$node_(49) setdest 4156 24521 6.0" 
$ns at 305.52634048818675 "$node_(49) setdest 89705 5315 12.0" 
$ns at 446.31247251445853 "$node_(49) setdest 45555 13180 4.0" 
$ns at 480.3729455458358 "$node_(49) setdest 176961 61590 14.0" 
$ns at 534.385324160236 "$node_(49) setdest 7461 18927 2.0" 
$ns at 574.9284775148438 "$node_(49) setdest 114415 44513 19.0" 
$ns at 734.7530115224718 "$node_(49) setdest 75314 42005 10.0" 
$ns at 840.7888234803482 "$node_(49) setdest 156666 48564 2.0" 
$ns at 879.395220589143 "$node_(49) setdest 67237 71089 19.0" 
$ns at 0.0 "$node_(50) setdest 40167 5240 18.0" 
$ns at 182.91945791034826 "$node_(50) setdest 58081 39610 1.0" 
$ns at 220.62083645334306 "$node_(50) setdest 65655 22588 13.0" 
$ns at 306.1024632533401 "$node_(50) setdest 53023 53712 12.0" 
$ns at 451.54051566579165 "$node_(50) setdest 30583 1904 2.0" 
$ns at 496.53894699067996 "$node_(50) setdest 54603 45251 6.0" 
$ns at 542.3004189016523 "$node_(50) setdest 111541 41642 17.0" 
$ns at 655.4025786852098 "$node_(50) setdest 173300 59878 13.0" 
$ns at 686.928839838239 "$node_(50) setdest 56197 6817 19.0" 
$ns at 718.5968086846493 "$node_(50) setdest 1244 29874 1.0" 
$ns at 751.0137223801562 "$node_(50) setdest 161925 32665 19.0" 
$ns at 890.1624084474049 "$node_(50) setdest 100864 31607 1.0" 
$ns at 0.0 "$node_(51) setdest 84415 12629 15.0" 
$ns at 82.77399044447725 "$node_(51) setdest 39704 10576 6.0" 
$ns at 133.97229827577763 "$node_(51) setdest 35833 22335 4.0" 
$ns at 190.54979794474932 "$node_(51) setdest 82048 26722 15.0" 
$ns at 361.15102550394215 "$node_(51) setdest 71754 35808 13.0" 
$ns at 418.67285659911664 "$node_(51) setdest 139158 36740 19.0" 
$ns at 464.3733717336776 "$node_(51) setdest 162520 41463 18.0" 
$ns at 531.4182990225862 "$node_(51) setdest 169649 17884 11.0" 
$ns at 605.4054054023677 "$node_(51) setdest 56299 41855 9.0" 
$ns at 692.5015027697915 "$node_(51) setdest 60314 78363 12.0" 
$ns at 827.6141562788089 "$node_(51) setdest 180426 55482 4.0" 
$ns at 861.8626485360753 "$node_(51) setdest 81579 30343 6.0" 
$ns at 0.0 "$node_(52) setdest 11142 15760 1.0" 
$ns at 39.8641901156504 "$node_(52) setdest 88224 25490 9.0" 
$ns at 131.8418490638105 "$node_(52) setdest 39608 26583 18.0" 
$ns at 302.0549864318352 "$node_(52) setdest 94103 3742 10.0" 
$ns at 363.3755912273198 "$node_(52) setdest 84094 10663 20.0" 
$ns at 585.9273960074378 "$node_(52) setdest 167413 344 12.0" 
$ns at 671.0205507354111 "$node_(52) setdest 94798 17806 11.0" 
$ns at 782.2965489451873 "$node_(52) setdest 25262 16506 6.0" 
$ns at 854.3899425359285 "$node_(52) setdest 172348 13681 19.0" 
$ns at 0.0 "$node_(53) setdest 72655 6870 2.0" 
$ns at 30.164591203689103 "$node_(53) setdest 31274 12297 14.0" 
$ns at 95.01292703467286 "$node_(53) setdest 64937 5334 20.0" 
$ns at 243.30619872995405 "$node_(53) setdest 34464 32976 14.0" 
$ns at 324.2819393547923 "$node_(53) setdest 57115 31394 15.0" 
$ns at 483.99391642815203 "$node_(53) setdest 580 14080 18.0" 
$ns at 607.1685494915298 "$node_(53) setdest 141062 62349 15.0" 
$ns at 724.9963115169235 "$node_(53) setdest 135951 57740 20.0" 
$ns at 775.8361650333001 "$node_(53) setdest 227332 74275 2.0" 
$ns at 816.1641219774817 "$node_(53) setdest 90698 34208 5.0" 
$ns at 893.5314647585554 "$node_(53) setdest 6396 54664 15.0" 
$ns at 0.0 "$node_(54) setdest 1335 17352 1.0" 
$ns at 32.20154018839967 "$node_(54) setdest 28616 21376 16.0" 
$ns at 156.09315033270292 "$node_(54) setdest 128072 2445 17.0" 
$ns at 344.72215412721766 "$node_(54) setdest 45902 34652 1.0" 
$ns at 383.48266772697343 "$node_(54) setdest 87591 56593 8.0" 
$ns at 469.1825132590389 "$node_(54) setdest 8525 45148 17.0" 
$ns at 573.6855287838366 "$node_(54) setdest 75018 32156 4.0" 
$ns at 632.18592913377 "$node_(54) setdest 119916 7662 4.0" 
$ns at 696.7880381833801 "$node_(54) setdest 227427 9850 5.0" 
$ns at 737.2600410333634 "$node_(54) setdest 226851 9561 3.0" 
$ns at 788.2596773865026 "$node_(54) setdest 38798 17160 19.0" 
$ns at 0.0 "$node_(55) setdest 11575 14035 1.0" 
$ns at 30.251830590969792 "$node_(55) setdest 2344 5246 12.0" 
$ns at 89.38900594379555 "$node_(55) setdest 51811 211 4.0" 
$ns at 128.29484962806654 "$node_(55) setdest 41800 10267 16.0" 
$ns at 201.35516223416414 "$node_(55) setdest 68524 8460 18.0" 
$ns at 319.9542671798406 "$node_(55) setdest 86868 43098 9.0" 
$ns at 394.9338559719349 "$node_(55) setdest 60122 30262 14.0" 
$ns at 559.0821972661238 "$node_(55) setdest 196314 29962 19.0" 
$ns at 606.726394653198 "$node_(55) setdest 170295 14820 10.0" 
$ns at 681.3985612766854 "$node_(55) setdest 250591 63204 18.0" 
$ns at 732.832751426284 "$node_(55) setdest 56941 26611 13.0" 
$ns at 797.3872942397536 "$node_(55) setdest 162501 21885 11.0" 
$ns at 0.0 "$node_(56) setdest 39813 23757 18.0" 
$ns at 132.64704979810688 "$node_(56) setdest 64121 18661 13.0" 
$ns at 187.42313875355612 "$node_(56) setdest 66470 18707 7.0" 
$ns at 227.45896052864904 "$node_(56) setdest 106588 20395 9.0" 
$ns at 305.99108959958585 "$node_(56) setdest 91902 4812 18.0" 
$ns at 457.92106460802995 "$node_(56) setdest 151531 18239 2.0" 
$ns at 489.3574680840194 "$node_(56) setdest 38130 61460 14.0" 
$ns at 643.25236877161 "$node_(56) setdest 51399 70207 10.0" 
$ns at 684.9741730198851 "$node_(56) setdest 151655 56433 19.0" 
$ns at 719.4226717432726 "$node_(56) setdest 96446 30736 12.0" 
$ns at 750.0610874820317 "$node_(56) setdest 103582 14613 11.0" 
$ns at 853.0972666020631 "$node_(56) setdest 149313 16403 13.0" 
$ns at 0.0 "$node_(57) setdest 39009 29692 7.0" 
$ns at 85.15664141711852 "$node_(57) setdest 69942 11058 17.0" 
$ns at 206.40450937492042 "$node_(57) setdest 75537 688 1.0" 
$ns at 241.8245336153482 "$node_(57) setdest 21644 8508 16.0" 
$ns at 305.32771655073265 "$node_(57) setdest 84328 45262 2.0" 
$ns at 340.01297925505014 "$node_(57) setdest 37206 7039 4.0" 
$ns at 379.36563232053874 "$node_(57) setdest 71594 18575 9.0" 
$ns at 445.6966518361495 "$node_(57) setdest 23477 31405 10.0" 
$ns at 508.1824597306725 "$node_(57) setdest 47371 51331 14.0" 
$ns at 544.3926005192038 "$node_(57) setdest 166287 55000 19.0" 
$ns at 613.5191892166279 "$node_(57) setdest 155901 43876 1.0" 
$ns at 646.6899244950408 "$node_(57) setdest 480 71880 4.0" 
$ns at 684.8577884491094 "$node_(57) setdest 17722 21784 12.0" 
$ns at 754.4454713376182 "$node_(57) setdest 229520 59738 15.0" 
$ns at 0.0 "$node_(58) setdest 37 24039 14.0" 
$ns at 144.8048352104542 "$node_(58) setdest 73595 28270 16.0" 
$ns at 248.4628251988421 "$node_(58) setdest 9148 19634 4.0" 
$ns at 311.217451899695 "$node_(58) setdest 146547 32854 19.0" 
$ns at 501.7913035580551 "$node_(58) setdest 54896 30549 9.0" 
$ns at 588.6926551265233 "$node_(58) setdest 116867 73897 3.0" 
$ns at 639.8997133757031 "$node_(58) setdest 72777 52219 20.0" 
$ns at 813.5057122875075 "$node_(58) setdest 214174 38314 1.0" 
$ns at 846.7828954622871 "$node_(58) setdest 235807 13874 6.0" 
$ns at 894.3650729860692 "$node_(58) setdest 49630 10882 2.0" 
$ns at 0.0 "$node_(59) setdest 39726 5069 1.0" 
$ns at 37.51177680295082 "$node_(59) setdest 79567 21271 1.0" 
$ns at 71.12393633475297 "$node_(59) setdest 11243 16356 18.0" 
$ns at 141.6408845353667 "$node_(59) setdest 32097 12886 15.0" 
$ns at 282.42335353699934 "$node_(59) setdest 45714 6429 5.0" 
$ns at 356.0801686578363 "$node_(59) setdest 94881 38942 18.0" 
$ns at 491.5998890199859 "$node_(59) setdest 197049 16459 16.0" 
$ns at 637.4065037987057 "$node_(59) setdest 179672 7729 1.0" 
$ns at 673.3754326468595 "$node_(59) setdest 165921 33182 11.0" 
$ns at 720.9286504119015 "$node_(59) setdest 203514 32792 2.0" 
$ns at 753.3198657630406 "$node_(59) setdest 242428 77639 7.0" 
$ns at 809.3891314369935 "$node_(59) setdest 21238 25390 9.0" 
$ns at 0.0 "$node_(60) setdest 13390 30040 17.0" 
$ns at 93.33950109444945 "$node_(60) setdest 58656 17799 1.0" 
$ns at 130.1339333711889 "$node_(60) setdest 76838 21496 9.0" 
$ns at 194.61719147243394 "$node_(60) setdest 42680 4451 20.0" 
$ns at 389.86780492441574 "$node_(60) setdest 162585 41915 1.0" 
$ns at 426.8882802797439 "$node_(60) setdest 61157 43094 6.0" 
$ns at 487.57153343761144 "$node_(60) setdest 43249 4730 10.0" 
$ns at 553.9504049458351 "$node_(60) setdest 98536 18341 12.0" 
$ns at 653.6614566146432 "$node_(60) setdest 151448 4161 18.0" 
$ns at 716.5605425179228 "$node_(60) setdest 142097 28785 15.0" 
$ns at 838.8016663183295 "$node_(60) setdest 167538 12137 7.0" 
$ns at 869.5243601651616 "$node_(60) setdest 217279 15195 16.0" 
$ns at 0.0 "$node_(61) setdest 71781 9939 14.0" 
$ns at 70.24019608902871 "$node_(61) setdest 36439 7333 8.0" 
$ns at 161.9341256988393 "$node_(61) setdest 116976 39272 17.0" 
$ns at 230.2222922365113 "$node_(61) setdest 91354 28161 8.0" 
$ns at 334.7404059389841 "$node_(61) setdest 87069 14835 19.0" 
$ns at 401.83859708515195 "$node_(61) setdest 58208 40427 11.0" 
$ns at 527.6441951993394 "$node_(61) setdest 184112 32781 17.0" 
$ns at 585.1072068967305 "$node_(61) setdest 129395 63076 15.0" 
$ns at 754.2025686100465 "$node_(61) setdest 16584 56419 18.0" 
$ns at 826.7782717008187 "$node_(61) setdest 247586 88633 17.0" 
$ns at 864.2636103309183 "$node_(61) setdest 160152 12847 4.0" 
$ns at 0.0 "$node_(62) setdest 47286 26494 1.0" 
$ns at 34.00381934880822 "$node_(62) setdest 79395 4790 17.0" 
$ns at 66.19265886612037 "$node_(62) setdest 37697 26821 8.0" 
$ns at 103.29839915383008 "$node_(62) setdest 59750 8551 1.0" 
$ns at 141.38519131504034 "$node_(62) setdest 51539 29016 3.0" 
$ns at 180.30348782227168 "$node_(62) setdest 125818 6647 12.0" 
$ns at 293.4960115979748 "$node_(62) setdest 73821 49393 17.0" 
$ns at 443.02066786230455 "$node_(62) setdest 138604 58697 14.0" 
$ns at 534.1105069078287 "$node_(62) setdest 179768 56541 6.0" 
$ns at 566.2539001111471 "$node_(62) setdest 146321 67542 12.0" 
$ns at 714.5632009405438 "$node_(62) setdest 70986 38056 11.0" 
$ns at 746.24668546331 "$node_(62) setdest 10814 56690 17.0" 
$ns at 808.1819218021067 "$node_(62) setdest 9297 82504 10.0" 
$ns at 850.5746823524048 "$node_(62) setdest 208385 21832 2.0" 
$ns at 886.2908395518966 "$node_(62) setdest 262558 79845 15.0" 
$ns at 0.0 "$node_(63) setdest 34355 28926 10.0" 
$ns at 83.29776944467841 "$node_(63) setdest 23937 25894 19.0" 
$ns at 271.11906742196413 "$node_(63) setdest 96964 25347 19.0" 
$ns at 395.7751697251217 "$node_(63) setdest 159351 40584 11.0" 
$ns at 502.22807380947523 "$node_(63) setdest 208866 24145 3.0" 
$ns at 559.1713733910512 "$node_(63) setdest 100991 19866 15.0" 
$ns at 650.0718577549678 "$node_(63) setdest 52585 80852 18.0" 
$ns at 686.8535879274285 "$node_(63) setdest 49604 9722 10.0" 
$ns at 763.5207984424601 "$node_(63) setdest 172749 4534 7.0" 
$ns at 806.8755469055612 "$node_(63) setdest 73134 55109 19.0" 
$ns at 0.0 "$node_(64) setdest 58297 8303 17.0" 
$ns at 115.54979157000342 "$node_(64) setdest 16215 4861 8.0" 
$ns at 218.57612254171175 "$node_(64) setdest 3407 32375 3.0" 
$ns at 256.0767236767694 "$node_(64) setdest 64296 483 18.0" 
$ns at 331.2355290830852 "$node_(64) setdest 60753 6602 1.0" 
$ns at 366.52470487514375 "$node_(64) setdest 167979 27730 17.0" 
$ns at 534.9015786793569 "$node_(64) setdest 77535 31303 19.0" 
$ns at 702.1715818646928 "$node_(64) setdest 58767 52775 12.0" 
$ns at 807.3305316988443 "$node_(64) setdest 188163 56005 5.0" 
$ns at 852.8499142088035 "$node_(64) setdest 173917 36935 4.0" 
$ns at 0.0 "$node_(65) setdest 59839 19379 19.0" 
$ns at 194.22224736735774 "$node_(65) setdest 20643 38322 15.0" 
$ns at 281.1408531562317 "$node_(65) setdest 66580 32898 11.0" 
$ns at 344.9342692181479 "$node_(65) setdest 95410 9768 4.0" 
$ns at 391.64671611005247 "$node_(65) setdest 148076 31771 14.0" 
$ns at 529.3056589639917 "$node_(65) setdest 44752 40485 15.0" 
$ns at 597.9459201549273 "$node_(65) setdest 20549 68357 9.0" 
$ns at 683.8315719845731 "$node_(65) setdest 52025 73837 16.0" 
$ns at 747.0241816256497 "$node_(65) setdest 153244 74665 14.0" 
$ns at 849.9050831307804 "$node_(65) setdest 47998 21758 1.0" 
$ns at 888.7152645185683 "$node_(65) setdest 64711 86991 4.0" 
$ns at 0.0 "$node_(66) setdest 47623 3063 20.0" 
$ns at 90.42186410181363 "$node_(66) setdest 64518 10807 19.0" 
$ns at 267.3197578443772 "$node_(66) setdest 42123 12232 15.0" 
$ns at 420.2043793955125 "$node_(66) setdest 121747 34325 1.0" 
$ns at 458.3475418532515 "$node_(66) setdest 189136 48160 14.0" 
$ns at 493.4601242768488 "$node_(66) setdest 173785 39885 7.0" 
$ns at 541.3626794211929 "$node_(66) setdest 209322 56721 14.0" 
$ns at 601.9013822191766 "$node_(66) setdest 137794 23801 4.0" 
$ns at 670.7288494682657 "$node_(66) setdest 179729 53242 10.0" 
$ns at 788.0425798987991 "$node_(66) setdest 193071 37481 1.0" 
$ns at 825.0750452357097 "$node_(66) setdest 237321 43743 6.0" 
$ns at 883.7476483765088 "$node_(66) setdest 131932 67816 16.0" 
$ns at 0.0 "$node_(67) setdest 61278 14133 12.0" 
$ns at 95.14978527478684 "$node_(67) setdest 10079 523 10.0" 
$ns at 196.43918322566117 "$node_(67) setdest 35984 1632 7.0" 
$ns at 260.1466466840168 "$node_(67) setdest 37579 14431 16.0" 
$ns at 448.48623858259543 "$node_(67) setdest 105637 25912 11.0" 
$ns at 587.0399559634294 "$node_(67) setdest 230655 33607 19.0" 
$ns at 622.1196762729346 "$node_(67) setdest 186289 54323 10.0" 
$ns at 739.5754915228495 "$node_(67) setdest 231441 2382 11.0" 
$ns at 794.2429739951077 "$node_(67) setdest 96741 40460 10.0" 
$ns at 884.0771031286724 "$node_(67) setdest 138478 48896 14.0" 
$ns at 0.0 "$node_(68) setdest 22837 7732 7.0" 
$ns at 92.64997223189698 "$node_(68) setdest 45715 13313 11.0" 
$ns at 137.54313732235198 "$node_(68) setdest 27908 29714 14.0" 
$ns at 204.82355050991788 "$node_(68) setdest 114973 21146 1.0" 
$ns at 244.16179042098304 "$node_(68) setdest 119157 7564 11.0" 
$ns at 302.16013644005955 "$node_(68) setdest 83310 8723 19.0" 
$ns at 458.5557475446113 "$node_(68) setdest 35017 68439 17.0" 
$ns at 610.7884198109305 "$node_(68) setdest 171614 10054 12.0" 
$ns at 669.2784661866672 "$node_(68) setdest 64001 58277 11.0" 
$ns at 762.0039306774037 "$node_(68) setdest 3805 77233 20.0" 
$ns at 0.0 "$node_(69) setdest 5081 20490 12.0" 
$ns at 110.27325456714456 "$node_(69) setdest 904 12811 20.0" 
$ns at 302.4978015499571 "$node_(69) setdest 70527 53723 3.0" 
$ns at 357.91284883103833 "$node_(69) setdest 94648 29756 3.0" 
$ns at 410.7170120381563 "$node_(69) setdest 184529 55431 3.0" 
$ns at 448.4587763756316 "$node_(69) setdest 153458 27845 19.0" 
$ns at 527.6546799342506 "$node_(69) setdest 138161 4369 15.0" 
$ns at 634.416629618988 "$node_(69) setdest 192439 905 14.0" 
$ns at 762.88751811209 "$node_(69) setdest 264077 8488 13.0" 
$ns at 832.4280399116469 "$node_(69) setdest 217748 47214 7.0" 
$ns at 0.0 "$node_(70) setdest 56618 1762 12.0" 
$ns at 89.5018266320953 "$node_(70) setdest 44199 8043 5.0" 
$ns at 135.54052419535194 "$node_(70) setdest 25925 17006 12.0" 
$ns at 267.2857198339615 "$node_(70) setdest 9506 6681 2.0" 
$ns at 304.44428508191993 "$node_(70) setdest 142311 4656 8.0" 
$ns at 404.1845432495023 "$node_(70) setdest 100515 44664 9.0" 
$ns at 519.3023817331182 "$node_(70) setdest 143887 33109 14.0" 
$ns at 619.3721387607915 "$node_(70) setdest 200676 35774 17.0" 
$ns at 750.79197984963 "$node_(70) setdest 48543 39866 1.0" 
$ns at 786.1703136741717 "$node_(70) setdest 48336 43220 3.0" 
$ns at 840.286101410404 "$node_(70) setdest 47969 80729 4.0" 
$ns at 873.9878405630084 "$node_(70) setdest 83850 27625 9.0" 
$ns at 0.0 "$node_(71) setdest 74781 16235 2.0" 
$ns at 39.10075486376017 "$node_(71) setdest 79819 17098 15.0" 
$ns at 148.2440768505845 "$node_(71) setdest 79708 10203 11.0" 
$ns at 191.7896892506296 "$node_(71) setdest 111514 13273 2.0" 
$ns at 222.24304056184337 "$node_(71) setdest 76611 39685 14.0" 
$ns at 383.0243976220955 "$node_(71) setdest 143220 48554 11.0" 
$ns at 451.2085328262073 "$node_(71) setdest 151832 62000 17.0" 
$ns at 567.9399393391494 "$node_(71) setdest 80304 30626 15.0" 
$ns at 650.1086394694892 "$node_(71) setdest 91809 22860 17.0" 
$ns at 760.6622474163852 "$node_(71) setdest 97710 39779 10.0" 
$ns at 836.3008122871087 "$node_(71) setdest 55019 50887 17.0" 
$ns at 890.3147337013894 "$node_(71) setdest 139440 88284 16.0" 
$ns at 0.0 "$node_(72) setdest 93692 19084 15.0" 
$ns at 127.42298561249049 "$node_(72) setdest 3064 17857 10.0" 
$ns at 162.9695024031193 "$node_(72) setdest 49646 41855 2.0" 
$ns at 207.4766955810762 "$node_(72) setdest 77307 2552 15.0" 
$ns at 310.4718836066902 "$node_(72) setdest 75908 49113 8.0" 
$ns at 384.6927720381086 "$node_(72) setdest 112120 32697 19.0" 
$ns at 522.6943537591849 "$node_(72) setdest 150154 50436 2.0" 
$ns at 561.6021989144804 "$node_(72) setdest 46353 77224 2.0" 
$ns at 595.75905818988 "$node_(72) setdest 223897 27479 1.0" 
$ns at 628.5795521457918 "$node_(72) setdest 51482 49207 17.0" 
$ns at 749.8760949996479 "$node_(72) setdest 221020 82758 10.0" 
$ns at 871.0205088465393 "$node_(72) setdest 5362 46603 4.0" 
$ns at 0.0 "$node_(73) setdest 91266 6279 14.0" 
$ns at 167.70380107811212 "$node_(73) setdest 22653 4831 20.0" 
$ns at 335.75165006618846 "$node_(73) setdest 148273 18979 7.0" 
$ns at 429.7909006833617 "$node_(73) setdest 34410 12426 15.0" 
$ns at 564.9913970537266 "$node_(73) setdest 17521 57459 11.0" 
$ns at 698.7732461625078 "$node_(73) setdest 197288 62984 1.0" 
$ns at 735.6675926276122 "$node_(73) setdest 71094 41308 2.0" 
$ns at 775.3278644995919 "$node_(73) setdest 131244 7732 16.0" 
$ns at 0.0 "$node_(74) setdest 12286 6423 16.0" 
$ns at 66.84426716652352 "$node_(74) setdest 39092 4854 10.0" 
$ns at 101.79775879625414 "$node_(74) setdest 59782 27934 5.0" 
$ns at 168.55099033846494 "$node_(74) setdest 86075 297 6.0" 
$ns at 237.89061268478454 "$node_(74) setdest 124139 33838 12.0" 
$ns at 314.5324254734495 "$node_(74) setdest 95508 36202 7.0" 
$ns at 396.0377180617851 "$node_(74) setdest 38889 51812 4.0" 
$ns at 427.5667484940168 "$node_(74) setdest 8099 56607 15.0" 
$ns at 459.73281733641284 "$node_(74) setdest 45120 22676 15.0" 
$ns at 592.2886207638453 "$node_(74) setdest 14973 58638 2.0" 
$ns at 641.0166701018961 "$node_(74) setdest 218311 42737 14.0" 
$ns at 806.1186637895672 "$node_(74) setdest 187037 71109 17.0" 
$ns at 849.6172213700911 "$node_(74) setdest 99780 52296 14.0" 
$ns at 0.0 "$node_(75) setdest 23014 8905 2.0" 
$ns at 40.21846788265648 "$node_(75) setdest 38660 27248 4.0" 
$ns at 92.26660637576225 "$node_(75) setdest 65155 30094 8.0" 
$ns at 195.96236140476836 "$node_(75) setdest 40394 34640 3.0" 
$ns at 245.9623992401767 "$node_(75) setdest 41888 1040 5.0" 
$ns at 306.6837647993674 "$node_(75) setdest 41755 34611 2.0" 
$ns at 343.77514953687495 "$node_(75) setdest 120053 28554 8.0" 
$ns at 428.99510510712184 "$node_(75) setdest 2281 41509 7.0" 
$ns at 486.7135659727672 "$node_(75) setdest 174561 12228 7.0" 
$ns at 586.5364654467588 "$node_(75) setdest 135137 70327 3.0" 
$ns at 640.9689892212735 "$node_(75) setdest 75474 30573 3.0" 
$ns at 691.7324850472982 "$node_(75) setdest 108384 23239 9.0" 
$ns at 783.7158325705647 "$node_(75) setdest 12551 12607 7.0" 
$ns at 847.4437195245436 "$node_(75) setdest 212658 84606 12.0" 
$ns at 0.0 "$node_(76) setdest 91661 20012 11.0" 
$ns at 127.74718924651108 "$node_(76) setdest 86546 30002 5.0" 
$ns at 175.41535844835963 "$node_(76) setdest 91258 10618 12.0" 
$ns at 218.85692949161668 "$node_(76) setdest 52389 33537 19.0" 
$ns at 273.7600923036348 "$node_(76) setdest 157326 915 11.0" 
$ns at 339.47844620909507 "$node_(76) setdest 155466 52560 1.0" 
$ns at 378.98836127612884 "$node_(76) setdest 71579 45272 2.0" 
$ns at 418.6400382769619 "$node_(76) setdest 44905 37735 19.0" 
$ns at 585.5959664126506 "$node_(76) setdest 68316 16263 19.0" 
$ns at 802.0353551183173 "$node_(76) setdest 158373 48099 17.0" 
$ns at 0.0 "$node_(77) setdest 58385 21499 2.0" 
$ns at 44.82434764299761 "$node_(77) setdest 72529 1547 5.0" 
$ns at 87.6980474981653 "$node_(77) setdest 12636 1102 16.0" 
$ns at 206.2459660377123 "$node_(77) setdest 12856 24272 20.0" 
$ns at 256.4921721440709 "$node_(77) setdest 64625 19370 9.0" 
$ns at 355.5742061093574 "$node_(77) setdest 123507 60540 17.0" 
$ns at 471.97550527615726 "$node_(77) setdest 73320 25575 12.0" 
$ns at 580.5710368993268 "$node_(77) setdest 57151 30941 17.0" 
$ns at 727.9154160316526 "$node_(77) setdest 65293 18009 19.0" 
$ns at 763.2281373882122 "$node_(77) setdest 119286 84942 9.0" 
$ns at 846.8180093146932 "$node_(77) setdest 173937 9960 3.0" 
$ns at 0.0 "$node_(78) setdest 85348 24339 13.0" 
$ns at 61.0085281795719 "$node_(78) setdest 16860 15599 7.0" 
$ns at 133.4089705781803 "$node_(78) setdest 61774 28783 18.0" 
$ns at 246.47679161101286 "$node_(78) setdest 109946 38960 19.0" 
$ns at 409.4979887995341 "$node_(78) setdest 46200 29216 5.0" 
$ns at 443.5831634113164 "$node_(78) setdest 135488 33333 16.0" 
$ns at 618.7786583738357 "$node_(78) setdest 180339 73188 17.0" 
$ns at 756.6720424200413 "$node_(78) setdest 133306 55822 5.0" 
$ns at 799.8415737002982 "$node_(78) setdest 67037 7123 3.0" 
$ns at 834.8897320004369 "$node_(78) setdest 18578 43798 4.0" 
$ns at 886.6931423919575 "$node_(78) setdest 220969 30125 2.0" 
$ns at 0.0 "$node_(79) setdest 5288 2883 14.0" 
$ns at 167.81006708422416 "$node_(79) setdest 113012 40575 13.0" 
$ns at 323.12632147900615 "$node_(79) setdest 71159 53397 15.0" 
$ns at 487.1443290528813 "$node_(79) setdest 159763 69945 4.0" 
$ns at 542.9482681800445 "$node_(79) setdest 15142 13232 18.0" 
$ns at 579.402241371909 "$node_(79) setdest 62378 41467 18.0" 
$ns at 772.6672322605547 "$node_(79) setdest 46986 84683 1.0" 
$ns at 810.9076561770412 "$node_(79) setdest 105575 76593 3.0" 
$ns at 858.0449844696279 "$node_(79) setdest 231208 8011 4.0" 
$ns at 0.0 "$node_(80) setdest 16962 22865 7.0" 
$ns at 93.99173289409553 "$node_(80) setdest 34770 17484 7.0" 
$ns at 131.98744491146874 "$node_(80) setdest 29635 27311 12.0" 
$ns at 236.30764000098787 "$node_(80) setdest 82218 18831 11.0" 
$ns at 314.06125736599745 "$node_(80) setdest 150163 54755 3.0" 
$ns at 357.183551631425 "$node_(80) setdest 25402 19017 11.0" 
$ns at 390.7465877993486 "$node_(80) setdest 27462 51559 17.0" 
$ns at 465.1244508143142 "$node_(80) setdest 124471 3176 15.0" 
$ns at 602.9502822768637 "$node_(80) setdest 115598 39051 8.0" 
$ns at 678.6815308404003 "$node_(80) setdest 86657 8142 20.0" 
$ns at 828.4512572427515 "$node_(80) setdest 235291 70660 3.0" 
$ns at 872.4013002196526 "$node_(80) setdest 244334 87096 4.0" 
$ns at 0.0 "$node_(81) setdest 79432 17791 19.0" 
$ns at 165.4641680678529 "$node_(81) setdest 17181 29182 13.0" 
$ns at 198.38823688635813 "$node_(81) setdest 78925 23540 12.0" 
$ns at 296.5503503077296 "$node_(81) setdest 73615 48852 15.0" 
$ns at 409.5554471874136 "$node_(81) setdest 120042 31918 5.0" 
$ns at 452.94871122771144 "$node_(81) setdest 152556 52675 9.0" 
$ns at 556.1427957185127 "$node_(81) setdest 34887 22829 11.0" 
$ns at 635.3274651705567 "$node_(81) setdest 58778 61244 17.0" 
$ns at 798.1085706486992 "$node_(81) setdest 131241 19472 15.0" 
$ns at 0.0 "$node_(82) setdest 13928 26930 3.0" 
$ns at 32.11208529335144 "$node_(82) setdest 36155 23985 8.0" 
$ns at 101.50549028479918 "$node_(82) setdest 9962 6860 7.0" 
$ns at 138.00464695192775 "$node_(82) setdest 70202 29710 3.0" 
$ns at 195.19444928547625 "$node_(82) setdest 32851 28657 15.0" 
$ns at 292.15957922077666 "$node_(82) setdest 26287 17715 7.0" 
$ns at 383.7987413834389 "$node_(82) setdest 118994 40184 2.0" 
$ns at 421.0323023503763 "$node_(82) setdest 90191 49909 7.0" 
$ns at 517.3783800041016 "$node_(82) setdest 105785 58563 19.0" 
$ns at 601.9091965896926 "$node_(82) setdest 231305 36810 19.0" 
$ns at 755.2647998650946 "$node_(82) setdest 130200 36087 3.0" 
$ns at 813.6361303134673 "$node_(82) setdest 74478 47958 8.0" 
$ns at 851.028373115897 "$node_(82) setdest 59954 80166 6.0" 
$ns at 0.0 "$node_(83) setdest 52422 19137 18.0" 
$ns at 43.011208248676226 "$node_(83) setdest 16096 27202 7.0" 
$ns at 92.55794480296085 "$node_(83) setdest 15574 3423 17.0" 
$ns at 158.73395547513394 "$node_(83) setdest 77037 7910 14.0" 
$ns at 227.81363331986097 "$node_(83) setdest 85497 36872 16.0" 
$ns at 391.5090445542322 "$node_(83) setdest 163012 1755 2.0" 
$ns at 439.2982407004613 "$node_(83) setdest 45088 21291 4.0" 
$ns at 489.8281506424868 "$node_(83) setdest 188402 56371 4.0" 
$ns at 532.0950737312693 "$node_(83) setdest 28923 18850 2.0" 
$ns at 572.3725158052886 "$node_(83) setdest 201312 33048 7.0" 
$ns at 626.1031123298728 "$node_(83) setdest 126008 34117 20.0" 
$ns at 774.942196535158 "$node_(83) setdest 230418 88472 1.0" 
$ns at 805.5496758498367 "$node_(83) setdest 111592 33786 8.0" 
$ns at 0.0 "$node_(84) setdest 15700 15943 3.0" 
$ns at 47.828250036368956 "$node_(84) setdest 59574 23683 11.0" 
$ns at 140.27228701467948 "$node_(84) setdest 3987 8276 15.0" 
$ns at 260.5574819506517 "$node_(84) setdest 111059 38131 18.0" 
$ns at 348.8464496760105 "$node_(84) setdest 82569 9633 6.0" 
$ns at 398.01653761352804 "$node_(84) setdest 60962 10240 13.0" 
$ns at 522.0662868965081 "$node_(84) setdest 41362 66241 11.0" 
$ns at 575.6050410426923 "$node_(84) setdest 177142 47961 12.0" 
$ns at 671.6338438662956 "$node_(84) setdest 147188 82056 5.0" 
$ns at 731.4669256778932 "$node_(84) setdest 51025 71028 4.0" 
$ns at 771.3082202936608 "$node_(84) setdest 253763 49043 8.0" 
$ns at 863.2645861034562 "$node_(84) setdest 251137 58912 13.0" 
$ns at 0.0 "$node_(85) setdest 81911 11044 18.0" 
$ns at 132.80180139587148 "$node_(85) setdest 27933 21703 17.0" 
$ns at 244.7924165789711 "$node_(85) setdest 39698 27039 7.0" 
$ns at 295.8192722902267 "$node_(85) setdest 16175 37519 17.0" 
$ns at 358.08234034515107 "$node_(85) setdest 70711 30665 14.0" 
$ns at 461.31341895447713 "$node_(85) setdest 94770 65929 10.0" 
$ns at 517.3237393333897 "$node_(85) setdest 96536 15130 18.0" 
$ns at 577.9836602548038 "$node_(85) setdest 226646 51054 17.0" 
$ns at 618.5013514535285 "$node_(85) setdest 42811 27796 17.0" 
$ns at 795.5158843125382 "$node_(85) setdest 252952 57384 11.0" 
$ns at 0.0 "$node_(86) setdest 48114 2328 14.0" 
$ns at 103.07233323003601 "$node_(86) setdest 71723 11155 15.0" 
$ns at 277.9926675093337 "$node_(86) setdest 150989 17440 14.0" 
$ns at 386.8930466879701 "$node_(86) setdest 152045 19998 14.0" 
$ns at 476.10884438931373 "$node_(86) setdest 86732 22768 8.0" 
$ns at 532.1363821036366 "$node_(86) setdest 146570 39406 6.0" 
$ns at 612.7235100368961 "$node_(86) setdest 197580 62583 6.0" 
$ns at 672.1588960192774 "$node_(86) setdest 73143 24828 2.0" 
$ns at 711.0784298192482 "$node_(86) setdest 205837 63084 3.0" 
$ns at 760.0477334338274 "$node_(86) setdest 39055 25088 10.0" 
$ns at 874.8216678770134 "$node_(86) setdest 23784 62938 18.0" 
$ns at 0.0 "$node_(87) setdest 14361 12351 4.0" 
$ns at 41.15627597450634 "$node_(87) setdest 25281 28463 6.0" 
$ns at 101.23050587563372 "$node_(87) setdest 58020 13657 1.0" 
$ns at 134.56881590186376 "$node_(87) setdest 32935 24082 19.0" 
$ns at 279.78105719741234 "$node_(87) setdest 2744 13071 16.0" 
$ns at 423.2749042207958 "$node_(87) setdest 25439 29601 13.0" 
$ns at 465.998273849016 "$node_(87) setdest 37163 35077 16.0" 
$ns at 598.3101558315304 "$node_(87) setdest 183519 52557 17.0" 
$ns at 654.9518665524357 "$node_(87) setdest 139031 77028 8.0" 
$ns at 763.6127185222379 "$node_(87) setdest 267167 57996 19.0" 
$ns at 883.2611523509267 "$node_(87) setdest 252781 62135 4.0" 
$ns at 0.0 "$node_(88) setdest 43754 8439 3.0" 
$ns at 55.09337670225868 "$node_(88) setdest 76076 9442 14.0" 
$ns at 152.16374244720532 "$node_(88) setdest 103249 35025 19.0" 
$ns at 278.8575563228141 "$node_(88) setdest 151134 7469 19.0" 
$ns at 365.84190638018276 "$node_(88) setdest 151679 15313 16.0" 
$ns at 503.05586645284797 "$node_(88) setdest 46708 42302 10.0" 
$ns at 576.289196827028 "$node_(88) setdest 48836 69523 14.0" 
$ns at 684.5719863209663 "$node_(88) setdest 215098 38073 9.0" 
$ns at 762.3353659280012 "$node_(88) setdest 195713 11082 6.0" 
$ns at 799.5426828522246 "$node_(88) setdest 253320 65230 13.0" 
$ns at 857.0116786698796 "$node_(88) setdest 61868 53229 8.0" 
$ns at 0.0 "$node_(89) setdest 51201 13809 8.0" 
$ns at 70.71814169675 "$node_(89) setdest 79639 23729 12.0" 
$ns at 210.6682261947103 "$node_(89) setdest 100232 37724 17.0" 
$ns at 350.02328782413724 "$node_(89) setdest 105758 51636 9.0" 
$ns at 462.7865284622824 "$node_(89) setdest 9496 9473 5.0" 
$ns at 507.83030367492415 "$node_(89) setdest 29617 64051 9.0" 
$ns at 610.7688623857744 "$node_(89) setdest 48864 48914 13.0" 
$ns at 756.6839718877371 "$node_(89) setdest 58329 85923 1.0" 
$ns at 790.332211149897 "$node_(89) setdest 120741 86738 1.0" 
$ns at 825.1824283289152 "$node_(89) setdest 241905 50217 6.0" 
$ns at 0.0 "$node_(90) setdest 56786 27102 2.0" 
$ns at 37.67834294326629 "$node_(90) setdest 33794 27529 1.0" 
$ns at 68.47794057437565 "$node_(90) setdest 47591 10383 17.0" 
$ns at 190.8381278693309 "$node_(90) setdest 10866 10268 5.0" 
$ns at 221.97328030418873 "$node_(90) setdest 126681 28207 6.0" 
$ns at 269.3847380049092 "$node_(90) setdest 146131 9904 9.0" 
$ns at 372.2759772979712 "$node_(90) setdest 140214 8556 9.0" 
$ns at 406.9913628678996 "$node_(90) setdest 155997 58895 4.0" 
$ns at 465.4808441997026 "$node_(90) setdest 177593 65131 7.0" 
$ns at 499.17366124135646 "$node_(90) setdest 102802 37457 1.0" 
$ns at 536.410778330737 "$node_(90) setdest 122089 65432 1.0" 
$ns at 568.1724814998961 "$node_(90) setdest 126398 21415 2.0" 
$ns at 602.8371592238818 "$node_(90) setdest 98203 62295 14.0" 
$ns at 698.1130995135744 "$node_(90) setdest 94731 11198 11.0" 
$ns at 813.1598721566162 "$node_(90) setdest 224758 80404 15.0" 
$ns at 0.0 "$node_(91) setdest 10265 5023 3.0" 
$ns at 35.30383395984813 "$node_(91) setdest 9994 30100 10.0" 
$ns at 146.17671808909859 "$node_(91) setdest 49077 7156 3.0" 
$ns at 197.98759786114573 "$node_(91) setdest 34877 20866 12.0" 
$ns at 338.2049146649152 "$node_(91) setdest 93723 30803 11.0" 
$ns at 382.27308498493596 "$node_(91) setdest 87567 54230 11.0" 
$ns at 469.8446546017634 "$node_(91) setdest 116051 60679 6.0" 
$ns at 522.722587871329 "$node_(91) setdest 92937 55284 2.0" 
$ns at 561.5726468071631 "$node_(91) setdest 2734 76086 2.0" 
$ns at 609.5902201072898 "$node_(91) setdest 199146 23306 1.0" 
$ns at 649.1018308057023 "$node_(91) setdest 26391 43613 4.0" 
$ns at 696.9004274988317 "$node_(91) setdest 185258 63788 14.0" 
$ns at 794.4289566231096 "$node_(91) setdest 255989 85742 1.0" 
$ns at 831.4366192071656 "$node_(91) setdest 73258 49287 6.0" 
$ns at 898.2850966010282 "$node_(91) setdest 2894 34466 8.0" 
$ns at 0.0 "$node_(92) setdest 62896 3151 3.0" 
$ns at 31.50287601119325 "$node_(92) setdest 81171 7074 16.0" 
$ns at 175.1504796816188 "$node_(92) setdest 112545 36091 19.0" 
$ns at 309.5791223288436 "$node_(92) setdest 107595 42241 19.0" 
$ns at 386.6181808560475 "$node_(92) setdest 33507 47824 14.0" 
$ns at 418.7800780504822 "$node_(92) setdest 36134 60856 11.0" 
$ns at 515.087167270706 "$node_(92) setdest 121222 26691 18.0" 
$ns at 580.2010836748226 "$node_(92) setdest 90823 63775 17.0" 
$ns at 678.8386462383313 "$node_(92) setdest 121504 37808 6.0" 
$ns at 751.0480460125283 "$node_(92) setdest 163215 61278 1.0" 
$ns at 785.8557885148585 "$node_(92) setdest 220576 8775 14.0" 
$ns at 861.1916040807383 "$node_(92) setdest 35509 37436 18.0" 
$ns at 0.0 "$node_(93) setdest 73017 20188 20.0" 
$ns at 188.66944586862283 "$node_(93) setdest 90880 9681 2.0" 
$ns at 233.47718622663533 "$node_(93) setdest 124767 21815 10.0" 
$ns at 316.6314667270945 "$node_(93) setdest 136713 37747 1.0" 
$ns at 348.32618339987613 "$node_(93) setdest 64315 25264 6.0" 
$ns at 379.3759511722333 "$node_(93) setdest 134559 18582 8.0" 
$ns at 438.3023639186501 "$node_(93) setdest 110683 9024 1.0" 
$ns at 476.03732021520557 "$node_(93) setdest 60468 25967 4.0" 
$ns at 531.1912226226802 "$node_(93) setdest 6980 14932 10.0" 
$ns at 577.3858339013217 "$node_(93) setdest 38310 21809 17.0" 
$ns at 628.4802564390546 "$node_(93) setdest 89914 67279 10.0" 
$ns at 703.7406412005471 "$node_(93) setdest 191820 41181 19.0" 
$ns at 801.2263089947626 "$node_(93) setdest 83756 68227 1.0" 
$ns at 839.8979844523572 "$node_(93) setdest 38644 44533 12.0" 
$ns at 899.7980854361767 "$node_(93) setdest 36713 4634 10.0" 
$ns at 0.0 "$node_(94) setdest 93646 31053 7.0" 
$ns at 54.348408383862676 "$node_(94) setdest 32946 15886 18.0" 
$ns at 215.71363328352385 "$node_(94) setdest 61102 29287 19.0" 
$ns at 429.47502633514017 "$node_(94) setdest 57376 48593 17.0" 
$ns at 519.9812019516111 "$node_(94) setdest 194166 40094 11.0" 
$ns at 594.2436787018191 "$node_(94) setdest 181150 18835 20.0" 
$ns at 665.2802206050753 "$node_(94) setdest 193208 76283 10.0" 
$ns at 746.3604524479415 "$node_(94) setdest 53999 10946 3.0" 
$ns at 780.1860453930984 "$node_(94) setdest 237649 52590 8.0" 
$ns at 830.5384512336726 "$node_(94) setdest 202077 56326 14.0" 
$ns at 0.0 "$node_(95) setdest 33615 1318 7.0" 
$ns at 32.40018520832839 "$node_(95) setdest 44070 11845 15.0" 
$ns at 131.79323775190977 "$node_(95) setdest 54418 4946 11.0" 
$ns at 260.6728340338214 "$node_(95) setdest 57831 29026 3.0" 
$ns at 294.54968184091626 "$node_(95) setdest 146235 11590 13.0" 
$ns at 449.11531552198824 "$node_(95) setdest 203 11453 2.0" 
$ns at 491.1225627709633 "$node_(95) setdest 61198 12652 1.0" 
$ns at 526.9787957172757 "$node_(95) setdest 210843 64736 16.0" 
$ns at 575.4271018628951 "$node_(95) setdest 202106 67819 19.0" 
$ns at 651.0513085214999 "$node_(95) setdest 111969 61952 6.0" 
$ns at 700.3832860097447 "$node_(95) setdest 25304 62287 8.0" 
$ns at 809.5887029623467 "$node_(95) setdest 75573 65370 1.0" 
$ns at 841.5825197328909 "$node_(95) setdest 21442 25134 3.0" 
$ns at 873.7168410211019 "$node_(95) setdest 29226 4626 16.0" 
$ns at 0.0 "$node_(96) setdest 28626 11860 13.0" 
$ns at 37.845872483434476 "$node_(96) setdest 76894 7913 6.0" 
$ns at 109.5420953734908 "$node_(96) setdest 62883 2810 1.0" 
$ns at 144.5221087239563 "$node_(96) setdest 19998 30408 13.0" 
$ns at 248.28251668744016 "$node_(96) setdest 93174 28602 8.0" 
$ns at 281.4674484827506 "$node_(96) setdest 71292 23171 3.0" 
$ns at 311.6322740584218 "$node_(96) setdest 43027 33209 13.0" 
$ns at 402.8813873062933 "$node_(96) setdest 154822 27917 13.0" 
$ns at 447.27495438289407 "$node_(96) setdest 41296 39914 12.0" 
$ns at 497.1218102515972 "$node_(96) setdest 102855 50023 7.0" 
$ns at 536.403881608059 "$node_(96) setdest 158722 9428 1.0" 
$ns at 574.5889582001672 "$node_(96) setdest 225371 46677 4.0" 
$ns at 641.3505324924647 "$node_(96) setdest 93151 62535 8.0" 
$ns at 714.6965487697847 "$node_(96) setdest 114392 74656 13.0" 
$ns at 872.6911084414637 "$node_(96) setdest 8096 82488 14.0" 
$ns at 0.0 "$node_(97) setdest 51605 30045 1.0" 
$ns at 31.536644380921082 "$node_(97) setdest 14434 21957 16.0" 
$ns at 172.19240731495603 "$node_(97) setdest 85053 18225 9.0" 
$ns at 290.9345123939296 "$node_(97) setdest 72938 13725 1.0" 
$ns at 327.51606599713085 "$node_(97) setdest 47379 20496 7.0" 
$ns at 388.38712788097837 "$node_(97) setdest 71634 60314 3.0" 
$ns at 426.8074800244351 "$node_(97) setdest 37040 39363 4.0" 
$ns at 476.33415123982775 "$node_(97) setdest 48063 7591 1.0" 
$ns at 515.5211093847299 "$node_(97) setdest 125261 26927 8.0" 
$ns at 595.1862086147163 "$node_(97) setdest 216727 24210 12.0" 
$ns at 687.590758329246 "$node_(97) setdest 63721 52905 3.0" 
$ns at 731.9881925288412 "$node_(97) setdest 143454 83039 12.0" 
$ns at 824.1479036078688 "$node_(97) setdest 118529 5340 2.0" 
$ns at 855.049200472354 "$node_(97) setdest 108990 76718 13.0" 
$ns at 0.0 "$node_(98) setdest 35100 1080 19.0" 
$ns at 48.951204086782155 "$node_(98) setdest 72602 10423 15.0" 
$ns at 181.02712515192133 "$node_(98) setdest 14816 13030 17.0" 
$ns at 368.7561596578714 "$node_(98) setdest 44719 12151 20.0" 
$ns at 530.3763378119851 "$node_(98) setdest 2908 13378 8.0" 
$ns at 596.2441875127594 "$node_(98) setdest 210707 76833 10.0" 
$ns at 705.4706411112254 "$node_(98) setdest 5587 57886 4.0" 
$ns at 745.2990344008924 "$node_(98) setdest 164438 79910 1.0" 
$ns at 783.0829482014484 "$node_(98) setdest 130540 42487 1.0" 
$ns at 815.1037171888062 "$node_(98) setdest 190056 39509 19.0" 
$ns at 0.0 "$node_(99) setdest 32966 25177 16.0" 
$ns at 140.28642451360275 "$node_(99) setdest 92463 6513 13.0" 
$ns at 238.6201255994095 "$node_(99) setdest 107261 1131 19.0" 
$ns at 368.7775913233576 "$node_(99) setdest 166808 62166 13.0" 
$ns at 511.4871031612564 "$node_(99) setdest 168728 69273 11.0" 
$ns at 559.6509776989401 "$node_(99) setdest 160858 13213 7.0" 
$ns at 625.4207780588025 "$node_(99) setdest 2049 35476 6.0" 
$ns at 703.0985723905751 "$node_(99) setdest 148208 52450 3.0" 
$ns at 751.9156714392004 "$node_(99) setdest 31005 55271 13.0" 
$ns at 827.2453728394896 "$node_(99) setdest 251545 76163 17.0" 
$ns at 0.0 "$node_(100) setdest 68166 4108 6.0" 
$ns at 65.77519090083233 "$node_(100) setdest 70127 3203 5.0" 
$ns at 119.20896343155283 "$node_(100) setdest 76491 31149 13.0" 
$ns at 251.6524916965305 "$node_(100) setdest 122806 70 19.0" 
$ns at 376.69051878352167 "$node_(100) setdest 147550 9557 17.0" 
$ns at 502.0494286002997 "$node_(100) setdest 211032 20801 19.0" 
$ns at 610.857704218721 "$node_(100) setdest 123193 30170 6.0" 
$ns at 644.3500352560353 "$node_(100) setdest 156675 74273 2.0" 
$ns at 687.5042917056386 "$node_(100) setdest 22898 38360 8.0" 
$ns at 755.2751230494162 "$node_(100) setdest 181320 22932 8.0" 
$ns at 806.3039491797581 "$node_(100) setdest 197554 4429 8.0" 
$ns at 873.6276637944412 "$node_(100) setdest 60465 75994 17.0" 
$ns at 211.49841118183937 "$node_(101) setdest 85196 29004 6.0" 
$ns at 295.4664699407374 "$node_(101) setdest 139577 37100 5.0" 
$ns at 367.9738401555283 "$node_(101) setdest 81839 12557 1.0" 
$ns at 405.0020130163956 "$node_(101) setdest 96594 61431 3.0" 
$ns at 455.25563194346995 "$node_(101) setdest 99365 42883 9.0" 
$ns at 519.4527474764812 "$node_(101) setdest 119715 21220 3.0" 
$ns at 577.1601477992223 "$node_(101) setdest 33403 74636 6.0" 
$ns at 635.2340777171087 "$node_(101) setdest 94817 32849 11.0" 
$ns at 754.2545442059852 "$node_(101) setdest 149595 48285 3.0" 
$ns at 788.6773131883956 "$node_(101) setdest 261865 35553 19.0" 
$ns at 143.5209115700899 "$node_(102) setdest 39571 8541 19.0" 
$ns at 252.1398241578064 "$node_(102) setdest 159659 25891 1.0" 
$ns at 292.1382923673723 "$node_(102) setdest 113985 39380 17.0" 
$ns at 342.1640225378393 "$node_(102) setdest 17202 11420 10.0" 
$ns at 464.7396301373066 "$node_(102) setdest 74364 16195 1.0" 
$ns at 501.6671954570371 "$node_(102) setdest 179620 48630 6.0" 
$ns at 538.474295599204 "$node_(102) setdest 186780 47519 1.0" 
$ns at 573.1842153703592 "$node_(102) setdest 147035 7612 6.0" 
$ns at 631.6495266742319 "$node_(102) setdest 179896 54763 15.0" 
$ns at 774.1842755935076 "$node_(102) setdest 104321 1703 12.0" 
$ns at 897.4580566029229 "$node_(102) setdest 129738 34064 15.0" 
$ns at 240.10630019498188 "$node_(103) setdest 69453 13703 16.0" 
$ns at 280.8100954057945 "$node_(103) setdest 81767 23021 10.0" 
$ns at 402.0723639506986 "$node_(103) setdest 55100 50822 6.0" 
$ns at 441.4788489737243 "$node_(103) setdest 74631 9009 17.0" 
$ns at 607.0625877101728 "$node_(103) setdest 138642 25067 1.0" 
$ns at 644.4656550357515 "$node_(103) setdest 28573 67335 11.0" 
$ns at 747.1044548966254 "$node_(103) setdest 232869 38663 11.0" 
$ns at 788.3958883759744 "$node_(103) setdest 83407 36491 7.0" 
$ns at 876.1720125681194 "$node_(103) setdest 124447 10446 1.0" 
$ns at 115.27410054788291 "$node_(104) setdest 43770 8661 14.0" 
$ns at 161.9904746913251 "$node_(104) setdest 23192 42423 11.0" 
$ns at 275.45166878041937 "$node_(104) setdest 89712 52384 16.0" 
$ns at 330.14483316068237 "$node_(104) setdest 147537 33659 4.0" 
$ns at 376.96722499827945 "$node_(104) setdest 75035 38180 12.0" 
$ns at 507.8136847152083 "$node_(104) setdest 155935 4210 1.0" 
$ns at 541.538608236835 "$node_(104) setdest 117590 28442 15.0" 
$ns at 574.6621998121511 "$node_(104) setdest 56741 7541 12.0" 
$ns at 658.7270933295939 "$node_(104) setdest 91859 28181 7.0" 
$ns at 722.4212095312099 "$node_(104) setdest 80354 48311 15.0" 
$ns at 165.2946673373396 "$node_(105) setdest 120321 13500 16.0" 
$ns at 292.7527145861449 "$node_(105) setdest 69436 49804 6.0" 
$ns at 342.199131602644 "$node_(105) setdest 142031 53789 16.0" 
$ns at 515.1443094949188 "$node_(105) setdest 100052 53511 8.0" 
$ns at 606.4895639405748 "$node_(105) setdest 229632 4360 2.0" 
$ns at 638.2118641965005 "$node_(105) setdest 179101 3860 14.0" 
$ns at 679.5276791037357 "$node_(105) setdest 105403 71467 19.0" 
$ns at 826.4441851012073 "$node_(105) setdest 224777 892 12.0" 
$ns at 250.00589160323884 "$node_(106) setdest 143784 40094 13.0" 
$ns at 335.33600512586634 "$node_(106) setdest 39844 54168 8.0" 
$ns at 386.84337864051616 "$node_(106) setdest 111636 4148 4.0" 
$ns at 453.3568825115211 "$node_(106) setdest 181865 49148 5.0" 
$ns at 490.657008377313 "$node_(106) setdest 35918 39836 1.0" 
$ns at 526.480876526432 "$node_(106) setdest 182195 6336 15.0" 
$ns at 674.984481450913 "$node_(106) setdest 105889 19934 6.0" 
$ns at 730.5842471968599 "$node_(106) setdest 44472 9899 10.0" 
$ns at 840.1976646489514 "$node_(106) setdest 247844 31741 10.0" 
$ns at 134.85609393924307 "$node_(107) setdest 19935 951 9.0" 
$ns at 213.2561748702212 "$node_(107) setdest 126245 28548 11.0" 
$ns at 343.0909254148686 "$node_(107) setdest 7834 27721 13.0" 
$ns at 438.7409425297477 "$node_(107) setdest 158246 34209 3.0" 
$ns at 475.685304623403 "$node_(107) setdest 191763 28339 20.0" 
$ns at 579.1192870306666 "$node_(107) setdest 35010 55904 9.0" 
$ns at 655.1062108272725 "$node_(107) setdest 244059 6856 4.0" 
$ns at 686.8451326582191 "$node_(107) setdest 4646 45828 16.0" 
$ns at 725.3991956065347 "$node_(107) setdest 29502 62881 17.0" 
$ns at 794.1519387734215 "$node_(107) setdest 78653 64042 13.0" 
$ns at 879.0019223869413 "$node_(107) setdest 251347 5006 2.0" 
$ns at 116.48613593626027 "$node_(108) setdest 60633 13192 18.0" 
$ns at 193.64156353044194 "$node_(108) setdest 103722 31289 6.0" 
$ns at 234.6738481489275 "$node_(108) setdest 35493 4847 18.0" 
$ns at 300.5949391836818 "$node_(108) setdest 150700 38178 12.0" 
$ns at 428.5697987842619 "$node_(108) setdest 133472 26150 17.0" 
$ns at 564.1091948713007 "$node_(108) setdest 6061 72291 6.0" 
$ns at 632.317989868397 "$node_(108) setdest 122442 15331 6.0" 
$ns at 708.5184295784233 "$node_(108) setdest 242948 6092 1.0" 
$ns at 745.8967957581737 "$node_(108) setdest 209861 56793 15.0" 
$ns at 112.00596748559879 "$node_(109) setdest 86347 14330 13.0" 
$ns at 155.98725249197872 "$node_(109) setdest 69840 18093 9.0" 
$ns at 248.02227939290725 "$node_(109) setdest 40937 21027 17.0" 
$ns at 426.1508760148356 "$node_(109) setdest 2631 37283 8.0" 
$ns at 510.67962122135873 "$node_(109) setdest 89709 50997 15.0" 
$ns at 599.3965859654375 "$node_(109) setdest 204271 44111 19.0" 
$ns at 722.2962270266153 "$node_(109) setdest 205609 78794 7.0" 
$ns at 783.1237741559391 "$node_(109) setdest 15955 23433 11.0" 
$ns at 894.0078159120457 "$node_(109) setdest 200924 55419 13.0" 
$ns at 252.66741686671077 "$node_(110) setdest 115448 34404 12.0" 
$ns at 329.78849890377205 "$node_(110) setdest 128458 35949 12.0" 
$ns at 395.37465787524866 "$node_(110) setdest 157963 52768 16.0" 
$ns at 514.5331802865585 "$node_(110) setdest 100547 18933 2.0" 
$ns at 554.357251543204 "$node_(110) setdest 176874 35209 1.0" 
$ns at 587.4578532059031 "$node_(110) setdest 48851 72688 20.0" 
$ns at 655.4967448986977 "$node_(110) setdest 57006 65493 18.0" 
$ns at 843.9896148851054 "$node_(110) setdest 196066 87638 3.0" 
$ns at 885.1194499176214 "$node_(110) setdest 197432 57130 7.0" 
$ns at 169.77402876047063 "$node_(111) setdest 89073 43840 12.0" 
$ns at 244.81545007124365 "$node_(111) setdest 70653 34442 14.0" 
$ns at 351.3106695131873 "$node_(111) setdest 173642 13238 10.0" 
$ns at 396.07282358255566 "$node_(111) setdest 161154 49220 18.0" 
$ns at 585.9388758220846 "$node_(111) setdest 189089 2800 3.0" 
$ns at 617.846045440136 "$node_(111) setdest 106619 63409 5.0" 
$ns at 663.1312401693172 "$node_(111) setdest 123587 43471 15.0" 
$ns at 700.8947558876939 "$node_(111) setdest 26458 17710 2.0" 
$ns at 738.4898536895549 "$node_(111) setdest 55438 67632 14.0" 
$ns at 804.895054485011 "$node_(111) setdest 188108 6988 17.0" 
$ns at 891.4052558973553 "$node_(111) setdest 108548 7497 5.0" 
$ns at 226.24992689914455 "$node_(112) setdest 123127 13091 13.0" 
$ns at 384.90089721860596 "$node_(112) setdest 68792 54788 9.0" 
$ns at 495.97054618461766 "$node_(112) setdest 85726 26321 1.0" 
$ns at 532.6159813402046 "$node_(112) setdest 19491 69662 14.0" 
$ns at 671.893843320732 "$node_(112) setdest 75495 14793 7.0" 
$ns at 717.2613414232029 "$node_(112) setdest 170879 79474 8.0" 
$ns at 811.6748406645527 "$node_(112) setdest 69793 49109 7.0" 
$ns at 160.706195273706 "$node_(113) setdest 120844 38423 1.0" 
$ns at 200.37391178803594 "$node_(113) setdest 126882 21099 12.0" 
$ns at 241.49491423340217 "$node_(113) setdest 41518 33233 16.0" 
$ns at 363.0904967479239 "$node_(113) setdest 186593 53031 4.0" 
$ns at 402.52237524034075 "$node_(113) setdest 175601 15600 9.0" 
$ns at 522.437737713651 "$node_(113) setdest 31959 12875 19.0" 
$ns at 628.4143372495743 "$node_(113) setdest 213755 20937 18.0" 
$ns at 814.8397730715859 "$node_(113) setdest 120266 24000 10.0" 
$ns at 104.405487747848 "$node_(114) setdest 46810 12754 12.0" 
$ns at 141.73062166872154 "$node_(114) setdest 27344 29481 9.0" 
$ns at 216.6549027827062 "$node_(114) setdest 95524 27788 4.0" 
$ns at 256.6258474399267 "$node_(114) setdest 5069 27221 12.0" 
$ns at 343.6305393606299 "$node_(114) setdest 43619 21817 19.0" 
$ns at 553.5882364408394 "$node_(114) setdest 99571 18654 4.0" 
$ns at 608.2103404582559 "$node_(114) setdest 105163 31712 19.0" 
$ns at 701.8000029581464 "$node_(114) setdest 194231 54172 10.0" 
$ns at 736.540066904541 "$node_(114) setdest 143795 8482 1.0" 
$ns at 771.3467070693993 "$node_(114) setdest 165349 56382 3.0" 
$ns at 825.618115184218 "$node_(114) setdest 131777 8822 8.0" 
$ns at 153.4614014660568 "$node_(115) setdest 52284 31862 1.0" 
$ns at 186.7230355756869 "$node_(115) setdest 106056 7103 8.0" 
$ns at 245.4245863498271 "$node_(115) setdest 60249 3275 1.0" 
$ns at 281.32805855112883 "$node_(115) setdest 8241 25797 19.0" 
$ns at 372.6403676971471 "$node_(115) setdest 84020 41429 14.0" 
$ns at 438.5728898983848 "$node_(115) setdest 78289 12440 15.0" 
$ns at 511.03402076860954 "$node_(115) setdest 103243 15001 6.0" 
$ns at 587.7206731568257 "$node_(115) setdest 228547 10871 5.0" 
$ns at 667.0309419014492 "$node_(115) setdest 107781 33215 19.0" 
$ns at 829.2271106914488 "$node_(115) setdest 75666 54067 5.0" 
$ns at 893.7899790962285 "$node_(115) setdest 167369 51801 1.0" 
$ns at 106.61282959789088 "$node_(116) setdest 76744 28410 17.0" 
$ns at 295.7418058331102 "$node_(116) setdest 23383 39782 13.0" 
$ns at 415.34688082794463 "$node_(116) setdest 108329 24199 19.0" 
$ns at 573.8955192337011 "$node_(116) setdest 109179 26430 4.0" 
$ns at 605.1190169504279 "$node_(116) setdest 56857 70046 5.0" 
$ns at 638.464519504686 "$node_(116) setdest 132802 8564 8.0" 
$ns at 688.4407385263427 "$node_(116) setdest 168801 40052 4.0" 
$ns at 736.5119567187207 "$node_(116) setdest 93385 14706 13.0" 
$ns at 814.1885346574787 "$node_(116) setdest 98763 35764 6.0" 
$ns at 849.2317213348174 "$node_(116) setdest 202396 11060 13.0" 
$ns at 222.1066195067022 "$node_(117) setdest 17408 10966 2.0" 
$ns at 261.97302840713337 "$node_(117) setdest 81562 12894 1.0" 
$ns at 301.3085972111652 "$node_(117) setdest 97215 16715 12.0" 
$ns at 342.23882733485067 "$node_(117) setdest 126539 17003 10.0" 
$ns at 383.5332073602422 "$node_(117) setdest 142877 31732 8.0" 
$ns at 466.4761199823316 "$node_(117) setdest 62999 53048 1.0" 
$ns at 502.3695120792369 "$node_(117) setdest 189582 19157 14.0" 
$ns at 628.8810566644862 "$node_(117) setdest 85060 11436 15.0" 
$ns at 739.8923971788275 "$node_(117) setdest 198764 3264 13.0" 
$ns at 831.5336948751582 "$node_(117) setdest 177582 60531 10.0" 
$ns at 120.57385779105213 "$node_(118) setdest 61293 4124 10.0" 
$ns at 229.57263180335258 "$node_(118) setdest 66804 9442 3.0" 
$ns at 282.04640714866565 "$node_(118) setdest 156353 45741 11.0" 
$ns at 368.3800498736572 "$node_(118) setdest 100116 31259 17.0" 
$ns at 409.95895111653516 "$node_(118) setdest 6294 33932 17.0" 
$ns at 474.2276550212683 "$node_(118) setdest 19253 23562 19.0" 
$ns at 665.4988389761869 "$node_(118) setdest 225428 78120 18.0" 
$ns at 856.9347005030082 "$node_(118) setdest 188461 64993 18.0" 
$ns at 158.93105430504193 "$node_(119) setdest 100914 14289 3.0" 
$ns at 210.99169945271098 "$node_(119) setdest 43878 32884 16.0" 
$ns at 255.44862503627877 "$node_(119) setdest 65237 37891 15.0" 
$ns at 435.2324964708929 "$node_(119) setdest 97889 34756 13.0" 
$ns at 476.3626976687257 "$node_(119) setdest 150926 24769 7.0" 
$ns at 562.3941749471036 "$node_(119) setdest 131674 4487 18.0" 
$ns at 630.3879684442393 "$node_(119) setdest 10484 76497 3.0" 
$ns at 668.3424636757098 "$node_(119) setdest 188717 39757 2.0" 
$ns at 713.1805984851718 "$node_(119) setdest 206895 29528 14.0" 
$ns at 825.5113467425158 "$node_(119) setdest 16358 41500 17.0" 
$ns at 184.6585929650127 "$node_(120) setdest 128585 22287 2.0" 
$ns at 224.88204082685778 "$node_(120) setdest 104919 4491 9.0" 
$ns at 289.99504694536483 "$node_(120) setdest 33299 46205 9.0" 
$ns at 346.65715159263607 "$node_(120) setdest 157765 53416 20.0" 
$ns at 431.5844158632541 "$node_(120) setdest 53424 56177 11.0" 
$ns at 492.62720393589916 "$node_(120) setdest 188065 17265 1.0" 
$ns at 524.1441175970024 "$node_(120) setdest 60558 45547 14.0" 
$ns at 692.6407888626037 "$node_(120) setdest 78578 62838 12.0" 
$ns at 779.6998010386039 "$node_(120) setdest 33491 28012 16.0" 
$ns at 895.5600657314972 "$node_(120) setdest 20604 21231 17.0" 
$ns at 129.45783543243095 "$node_(121) setdest 17465 1226 8.0" 
$ns at 181.59924769026946 "$node_(121) setdest 60556 15396 18.0" 
$ns at 263.71046044272975 "$node_(121) setdest 114314 20644 5.0" 
$ns at 339.31976165730873 "$node_(121) setdest 89746 41276 5.0" 
$ns at 407.9967671059321 "$node_(121) setdest 22505 57753 3.0" 
$ns at 445.99342446754474 "$node_(121) setdest 45874 34275 7.0" 
$ns at 540.7877914306569 "$node_(121) setdest 114203 48184 10.0" 
$ns at 576.5311236287532 "$node_(121) setdest 127445 20295 11.0" 
$ns at 647.51743925946 "$node_(121) setdest 56832 17595 1.0" 
$ns at 679.8945411468296 "$node_(121) setdest 89072 82553 13.0" 
$ns at 800.2410052411935 "$node_(121) setdest 237242 59885 18.0" 
$ns at 130.6758780574879 "$node_(122) setdest 35309 14828 6.0" 
$ns at 208.65430939560488 "$node_(122) setdest 83250 8916 9.0" 
$ns at 311.68803635179984 "$node_(122) setdest 38818 28882 2.0" 
$ns at 356.45403499535416 "$node_(122) setdest 20393 47674 12.0" 
$ns at 489.37748476216467 "$node_(122) setdest 107436 25166 6.0" 
$ns at 563.241070040307 "$node_(122) setdest 31407 70089 6.0" 
$ns at 640.8051028204527 "$node_(122) setdest 52062 55210 19.0" 
$ns at 787.7971386888845 "$node_(122) setdest 175532 52543 13.0" 
$ns at 834.1444027458715 "$node_(122) setdest 4038 46818 13.0" 
$ns at 173.25054997205066 "$node_(123) setdest 97068 38721 5.0" 
$ns at 241.07537802345215 "$node_(123) setdest 76542 34667 19.0" 
$ns at 422.2930675730106 "$node_(123) setdest 74739 49633 14.0" 
$ns at 491.84479960824626 "$node_(123) setdest 169406 1641 20.0" 
$ns at 684.6186878560565 "$node_(123) setdest 236989 17419 19.0" 
$ns at 727.1762028433902 "$node_(123) setdest 22114 20961 1.0" 
$ns at 765.9327987949314 "$node_(123) setdest 57791 26252 20.0" 
$ns at 885.8342686057841 "$node_(123) setdest 251007 10025 9.0" 
$ns at 160.41248272361315 "$node_(124) setdest 68476 14352 12.0" 
$ns at 252.22254910718374 "$node_(124) setdest 158850 19220 8.0" 
$ns at 348.77937482642517 "$node_(124) setdest 36352 40427 14.0" 
$ns at 486.36234079439737 "$node_(124) setdest 70750 8691 16.0" 
$ns at 661.21600955087 "$node_(124) setdest 12252 39665 16.0" 
$ns at 801.5444696195409 "$node_(124) setdest 88082 68921 6.0" 
$ns at 860.4602502188127 "$node_(124) setdest 137550 57803 8.0" 
$ns at 142.4302557723039 "$node_(125) setdest 44704 8066 16.0" 
$ns at 270.5021318290838 "$node_(125) setdest 81874 18974 16.0" 
$ns at 343.30227005122015 "$node_(125) setdest 138650 39178 4.0" 
$ns at 380.99181537140595 "$node_(125) setdest 59436 49727 8.0" 
$ns at 416.33478664990537 "$node_(125) setdest 17713 9155 3.0" 
$ns at 458.7445063898248 "$node_(125) setdest 4354 28698 14.0" 
$ns at 547.3128306491593 "$node_(125) setdest 17193 35866 13.0" 
$ns at 705.8835451951559 "$node_(125) setdest 95275 24970 4.0" 
$ns at 754.3286417149244 "$node_(125) setdest 9794 25012 12.0" 
$ns at 878.7935206196387 "$node_(125) setdest 162108 42947 18.0" 
$ns at 133.6149666541692 "$node_(126) setdest 65648 18421 11.0" 
$ns at 167.25044801083436 "$node_(126) setdest 21323 40242 7.0" 
$ns at 197.78962831758204 "$node_(126) setdest 16902 30270 16.0" 
$ns at 277.12374705909986 "$node_(126) setdest 123788 5928 1.0" 
$ns at 310.6732704757275 "$node_(126) setdest 14445 4988 20.0" 
$ns at 345.0642302644583 "$node_(126) setdest 120891 1027 20.0" 
$ns at 515.4317943181632 "$node_(126) setdest 100670 40432 4.0" 
$ns at 563.9494693803546 "$node_(126) setdest 148230 25100 4.0" 
$ns at 615.6958698920434 "$node_(126) setdest 24731 77056 16.0" 
$ns at 708.2943450603208 "$node_(126) setdest 164446 28998 11.0" 
$ns at 746.5904163692111 "$node_(126) setdest 55281 4477 11.0" 
$ns at 796.9877674666308 "$node_(126) setdest 100477 30959 12.0" 
$ns at 857.4106942279334 "$node_(126) setdest 249458 78478 6.0" 
$ns at 185.8218291633267 "$node_(127) setdest 90056 6253 17.0" 
$ns at 316.8225342422096 "$node_(127) setdest 40924 48955 3.0" 
$ns at 350.8242945699443 "$node_(127) setdest 5648 14810 7.0" 
$ns at 415.224179944487 "$node_(127) setdest 50198 50015 1.0" 
$ns at 452.28436708443644 "$node_(127) setdest 137259 67930 3.0" 
$ns at 499.7818534564309 "$node_(127) setdest 192758 21513 17.0" 
$ns at 628.7073370643434 "$node_(127) setdest 172750 3951 2.0" 
$ns at 660.065776171776 "$node_(127) setdest 180958 40589 5.0" 
$ns at 709.2725049336228 "$node_(127) setdest 88683 41430 18.0" 
$ns at 855.7216726788295 "$node_(127) setdest 238792 21525 1.0" 
$ns at 888.7506942722636 "$node_(127) setdest 197107 63793 4.0" 
$ns at 111.99185327438695 "$node_(128) setdest 61811 25691 13.0" 
$ns at 247.00438588522533 "$node_(128) setdest 121756 21086 5.0" 
$ns at 321.23622756540203 "$node_(128) setdest 24042 17801 11.0" 
$ns at 420.4124177348431 "$node_(128) setdest 70005 32243 5.0" 
$ns at 494.13906509235557 "$node_(128) setdest 140108 4992 5.0" 
$ns at 553.5822963287112 "$node_(128) setdest 217239 54010 3.0" 
$ns at 611.2244272836248 "$node_(128) setdest 144372 2946 6.0" 
$ns at 646.4882007117734 "$node_(128) setdest 191113 63852 14.0" 
$ns at 737.4901037373477 "$node_(128) setdest 214634 36057 18.0" 
$ns at 836.4303773260801 "$node_(128) setdest 99397 3527 18.0" 
$ns at 134.31714708077362 "$node_(129) setdest 82807 6631 4.0" 
$ns at 199.2320780095137 "$node_(129) setdest 71956 17559 12.0" 
$ns at 328.6714759375192 "$node_(129) setdest 103032 23173 13.0" 
$ns at 404.78705053698155 "$node_(129) setdest 62960 57151 17.0" 
$ns at 473.13978095676896 "$node_(129) setdest 111690 54319 1.0" 
$ns at 503.1582759775155 "$node_(129) setdest 1832 9909 4.0" 
$ns at 568.165034761011 "$node_(129) setdest 113149 43457 2.0" 
$ns at 605.9844682944138 "$node_(129) setdest 53223 61241 1.0" 
$ns at 643.9711501167111 "$node_(129) setdest 121870 49709 16.0" 
$ns at 833.2723413022451 "$node_(129) setdest 75127 65531 14.0" 
$ns at 106.65716547742625 "$node_(130) setdest 42120 14598 8.0" 
$ns at 140.01651397467555 "$node_(130) setdest 37734 12847 19.0" 
$ns at 347.6048179075707 "$node_(130) setdest 41749 34525 18.0" 
$ns at 380.47033145225055 "$node_(130) setdest 85160 34371 10.0" 
$ns at 453.1150885137422 "$node_(130) setdest 184812 50874 11.0" 
$ns at 575.1797280300561 "$node_(130) setdest 31239 60689 1.0" 
$ns at 608.9535427527337 "$node_(130) setdest 16792 8377 8.0" 
$ns at 706.6999206420971 "$node_(130) setdest 2660 268 5.0" 
$ns at 757.7962516156681 "$node_(130) setdest 157498 5754 6.0" 
$ns at 818.7714768075398 "$node_(130) setdest 5527 43325 5.0" 
$ns at 875.475752874146 "$node_(130) setdest 207181 37962 5.0" 
$ns at 129.33062475936936 "$node_(131) setdest 17904 9197 8.0" 
$ns at 198.67582356565705 "$node_(131) setdest 37313 38140 11.0" 
$ns at 253.31596776750317 "$node_(131) setdest 149671 54301 1.0" 
$ns at 283.61394725918535 "$node_(131) setdest 123584 18788 7.0" 
$ns at 377.12531513027983 "$node_(131) setdest 70765 55379 19.0" 
$ns at 595.1936946999052 "$node_(131) setdest 52109 6002 20.0" 
$ns at 750.5869501504872 "$node_(131) setdest 162782 8130 3.0" 
$ns at 785.4840410535281 "$node_(131) setdest 209725 37621 14.0" 
$ns at 881.1800074489862 "$node_(131) setdest 99653 76979 9.0" 
$ns at 121.16805041059058 "$node_(132) setdest 18423 465 17.0" 
$ns at 185.20994593096822 "$node_(132) setdest 95978 27439 3.0" 
$ns at 225.22101676127002 "$node_(132) setdest 37664 27649 5.0" 
$ns at 287.81807202772717 "$node_(132) setdest 157497 36884 20.0" 
$ns at 457.58042028361814 "$node_(132) setdest 62987 13757 12.0" 
$ns at 532.05696310993 "$node_(132) setdest 9762 19973 17.0" 
$ns at 665.771854522051 "$node_(132) setdest 65046 83450 9.0" 
$ns at 767.9757795647405 "$node_(132) setdest 218947 31924 3.0" 
$ns at 817.3450298946409 "$node_(132) setdest 102410 13650 10.0" 
$ns at 892.8445438881265 "$node_(132) setdest 187143 50905 7.0" 
$ns at 131.21647259345428 "$node_(133) setdest 69200 21248 9.0" 
$ns at 176.01800041678962 "$node_(133) setdest 132460 33107 10.0" 
$ns at 255.77180771332368 "$node_(133) setdest 130809 49374 14.0" 
$ns at 322.0392067859039 "$node_(133) setdest 30065 20009 2.0" 
$ns at 362.14273197638056 "$node_(133) setdest 37333 44701 10.0" 
$ns at 432.63468353769036 "$node_(133) setdest 135516 23869 7.0" 
$ns at 518.801190982512 "$node_(133) setdest 160827 42033 3.0" 
$ns at 558.0772967605283 "$node_(133) setdest 200852 4721 1.0" 
$ns at 590.3497819532989 "$node_(133) setdest 205425 44686 14.0" 
$ns at 712.8804532604297 "$node_(133) setdest 90951 30489 17.0" 
$ns at 894.9728813729018 "$node_(133) setdest 79285 75935 6.0" 
$ns at 130.1974905014461 "$node_(134) setdest 36600 8680 2.0" 
$ns at 166.30691287972627 "$node_(134) setdest 68799 27468 7.0" 
$ns at 248.44608040163303 "$node_(134) setdest 23874 20252 19.0" 
$ns at 325.62276875198796 "$node_(134) setdest 163822 23948 14.0" 
$ns at 358.02998087802825 "$node_(134) setdest 23416 24349 1.0" 
$ns at 391.38407223476486 "$node_(134) setdest 182573 2085 17.0" 
$ns at 462.29814463612036 "$node_(134) setdest 48858 599 13.0" 
$ns at 574.4911821655638 "$node_(134) setdest 208330 5183 13.0" 
$ns at 622.9935058309421 "$node_(134) setdest 60252 9357 4.0" 
$ns at 654.3062073961269 "$node_(134) setdest 12188 18660 3.0" 
$ns at 713.4216963639689 "$node_(134) setdest 244783 38567 8.0" 
$ns at 805.8320817757626 "$node_(134) setdest 159382 59782 6.0" 
$ns at 846.5370631093044 "$node_(134) setdest 186078 86622 9.0" 
$ns at 881.2194685545505 "$node_(134) setdest 183370 37916 13.0" 
$ns at 112.20061241285863 "$node_(135) setdest 60922 14200 2.0" 
$ns at 150.85011874434537 "$node_(135) setdest 79397 8574 16.0" 
$ns at 267.98048745072657 "$node_(135) setdest 132239 14301 13.0" 
$ns at 317.0430272769339 "$node_(135) setdest 63451 9718 13.0" 
$ns at 453.59534257493357 "$node_(135) setdest 63280 34778 19.0" 
$ns at 490.6898233140481 "$node_(135) setdest 54942 22393 17.0" 
$ns at 661.7639563661993 "$node_(135) setdest 215680 4184 9.0" 
$ns at 760.9430411265678 "$node_(135) setdest 204769 70701 11.0" 
$ns at 824.3597725258704 "$node_(135) setdest 19867 82407 17.0" 
$ns at 131.4222426304762 "$node_(136) setdest 41272 22864 2.0" 
$ns at 162.52070678102606 "$node_(136) setdest 124165 24930 4.0" 
$ns at 196.67864654596735 "$node_(136) setdest 32278 6438 1.0" 
$ns at 228.02599220791413 "$node_(136) setdest 130618 2496 14.0" 
$ns at 272.807183328572 "$node_(136) setdest 36382 23296 19.0" 
$ns at 392.1610335086976 "$node_(136) setdest 49189 27140 12.0" 
$ns at 460.4809218755396 "$node_(136) setdest 157957 13602 4.0" 
$ns at 504.88096948521263 "$node_(136) setdest 130932 70582 16.0" 
$ns at 637.2504090503719 "$node_(136) setdest 12057 30108 15.0" 
$ns at 752.9164997767213 "$node_(136) setdest 247191 53753 13.0" 
$ns at 799.0542398476574 "$node_(136) setdest 61536 70964 6.0" 
$ns at 830.3569860803977 "$node_(136) setdest 238534 61463 15.0" 
$ns at 113.63374744701531 "$node_(137) setdest 87938 399 12.0" 
$ns at 216.58156745109375 "$node_(137) setdest 118777 18352 5.0" 
$ns at 285.188831950553 "$node_(137) setdest 158807 45028 19.0" 
$ns at 399.7638075361974 "$node_(137) setdest 59890 33952 17.0" 
$ns at 557.858692075388 "$node_(137) setdest 83092 51081 7.0" 
$ns at 632.8395940165431 "$node_(137) setdest 29938 30785 7.0" 
$ns at 717.5858599285275 "$node_(137) setdest 210389 64285 14.0" 
$ns at 789.6014296933948 "$node_(137) setdest 263628 56918 1.0" 
$ns at 820.7534250450936 "$node_(137) setdest 60406 78070 6.0" 
$ns at 879.3708930445604 "$node_(137) setdest 8434 43027 12.0" 
$ns at 148.17545013996957 "$node_(138) setdest 1920 29887 11.0" 
$ns at 192.62057636214425 "$node_(138) setdest 92531 27770 11.0" 
$ns at 244.13063220055477 "$node_(138) setdest 107150 2837 2.0" 
$ns at 291.3645942177665 "$node_(138) setdest 50132 38326 9.0" 
$ns at 356.5249347608308 "$node_(138) setdest 157534 55913 11.0" 
$ns at 462.1843034619193 "$node_(138) setdest 108650 55952 14.0" 
$ns at 600.2877005981902 "$node_(138) setdest 107994 45625 20.0" 
$ns at 666.1692553223556 "$node_(138) setdest 135871 63623 14.0" 
$ns at 762.0392246193272 "$node_(138) setdest 229766 19101 8.0" 
$ns at 850.7540855506829 "$node_(138) setdest 48004 65399 17.0" 
$ns at 215.26081348436108 "$node_(139) setdest 18389 22904 9.0" 
$ns at 277.3760773475927 "$node_(139) setdest 71088 3221 18.0" 
$ns at 331.14032351474873 "$node_(139) setdest 102127 37895 19.0" 
$ns at 361.2588419800784 "$node_(139) setdest 52899 36727 10.0" 
$ns at 471.11820542316343 "$node_(139) setdest 207927 13444 4.0" 
$ns at 508.65355489027934 "$node_(139) setdest 42936 17570 15.0" 
$ns at 540.2419731952804 "$node_(139) setdest 87049 12689 3.0" 
$ns at 577.8251069199832 "$node_(139) setdest 209243 25947 16.0" 
$ns at 721.3954987363605 "$node_(139) setdest 150622 397 7.0" 
$ns at 751.4673499584683 "$node_(139) setdest 149992 86865 20.0" 
$ns at 102.12737949614542 "$node_(140) setdest 43950 25737 3.0" 
$ns at 142.76022396713412 "$node_(140) setdest 225 9434 18.0" 
$ns at 282.60445544558263 "$node_(140) setdest 140270 11845 1.0" 
$ns at 322.32099136413655 "$node_(140) setdest 57826 38354 1.0" 
$ns at 355.2935429997119 "$node_(140) setdest 159449 4289 4.0" 
$ns at 417.0089947210587 "$node_(140) setdest 110300 16997 10.0" 
$ns at 497.2115512721488 "$node_(140) setdest 135262 21889 16.0" 
$ns at 635.2069043517233 "$node_(140) setdest 154675 74169 3.0" 
$ns at 680.0118294378832 "$node_(140) setdest 16402 45132 4.0" 
$ns at 713.7530868639844 "$node_(140) setdest 86580 26703 8.0" 
$ns at 819.7888340001103 "$node_(140) setdest 234313 68249 4.0" 
$ns at 868.5852457073844 "$node_(140) setdest 112324 88009 13.0" 
$ns at 187.71261253886777 "$node_(141) setdest 52749 30791 10.0" 
$ns at 232.62796973157086 "$node_(141) setdest 47573 26749 1.0" 
$ns at 268.5152918473675 "$node_(141) setdest 35485 48678 17.0" 
$ns at 366.3004769891745 "$node_(141) setdest 124822 1300 12.0" 
$ns at 429.90529077992886 "$node_(141) setdest 116868 58147 10.0" 
$ns at 533.618556119507 "$node_(141) setdest 70094 45978 17.0" 
$ns at 685.537558916353 "$node_(141) setdest 89704 69620 3.0" 
$ns at 717.531231169948 "$node_(141) setdest 4922 41229 17.0" 
$ns at 836.1501713938485 "$node_(141) setdest 259534 68186 18.0" 
$ns at 163.97400530941013 "$node_(142) setdest 56113 26434 10.0" 
$ns at 251.2577024849522 "$node_(142) setdest 42409 12991 5.0" 
$ns at 325.1156261510947 "$node_(142) setdest 128803 31602 19.0" 
$ns at 408.6151124725169 "$node_(142) setdest 31527 52386 6.0" 
$ns at 496.4939901216681 "$node_(142) setdest 63465 29056 9.0" 
$ns at 614.3698812665103 "$node_(142) setdest 120939 23632 7.0" 
$ns at 690.6838756851512 "$node_(142) setdest 166077 10956 9.0" 
$ns at 720.7698719998284 "$node_(142) setdest 218070 78933 18.0" 
$ns at 110.41096932116268 "$node_(143) setdest 84641 10327 19.0" 
$ns at 221.3604602555646 "$node_(143) setdest 104531 3952 4.0" 
$ns at 255.4900862803742 "$node_(143) setdest 78438 33606 1.0" 
$ns at 291.3770930775582 "$node_(143) setdest 66142 3190 7.0" 
$ns at 387.4536257799047 "$node_(143) setdest 105559 33391 3.0" 
$ns at 441.7454623149436 "$node_(143) setdest 173099 31311 9.0" 
$ns at 502.58246095332123 "$node_(143) setdest 108743 34446 18.0" 
$ns at 538.8653643253261 "$node_(143) setdest 22641 18524 3.0" 
$ns at 588.8603778049113 "$node_(143) setdest 89616 51601 19.0" 
$ns at 632.7740825486744 "$node_(143) setdest 231446 39649 11.0" 
$ns at 718.3801803575492 "$node_(143) setdest 139022 8379 9.0" 
$ns at 757.3236076787351 "$node_(143) setdest 220370 42040 18.0" 
$ns at 856.5664337392876 "$node_(143) setdest 14949 5189 16.0" 
$ns at 122.04844271305693 "$node_(144) setdest 19781 11469 11.0" 
$ns at 187.92707399721348 "$node_(144) setdest 8263 15135 10.0" 
$ns at 242.52337073654786 "$node_(144) setdest 90091 34310 3.0" 
$ns at 291.40942571021094 "$node_(144) setdest 45762 36743 13.0" 
$ns at 330.4792465153474 "$node_(144) setdest 125118 37497 14.0" 
$ns at 472.39719655984834 "$node_(144) setdest 143228 425 20.0" 
$ns at 612.1808521492428 "$node_(144) setdest 65385 76877 19.0" 
$ns at 689.4228989966915 "$node_(144) setdest 229410 62864 2.0" 
$ns at 724.4123468831586 "$node_(144) setdest 210389 32701 12.0" 
$ns at 756.1058937944784 "$node_(144) setdest 130074 7321 4.0" 
$ns at 792.7433504508281 "$node_(144) setdest 153472 64273 13.0" 
$ns at 871.2438981306484 "$node_(144) setdest 43918 67949 18.0" 
$ns at 149.41716491791016 "$node_(145) setdest 1553 12070 5.0" 
$ns at 204.9106552306604 "$node_(145) setdest 122910 15018 6.0" 
$ns at 267.1960414292672 "$node_(145) setdest 71241 17727 6.0" 
$ns at 349.3061089644792 "$node_(145) setdest 37543 6783 10.0" 
$ns at 383.4203977133623 "$node_(145) setdest 177867 57005 11.0" 
$ns at 479.67470840835136 "$node_(145) setdest 102163 7263 13.0" 
$ns at 552.3773126192544 "$node_(145) setdest 173652 40093 15.0" 
$ns at 650.305878921891 "$node_(145) setdest 73752 22115 15.0" 
$ns at 736.4378166889825 "$node_(145) setdest 85910 68209 8.0" 
$ns at 777.415934488491 "$node_(145) setdest 215393 61609 20.0" 
$ns at 895.2848220231424 "$node_(145) setdest 136889 9402 6.0" 
$ns at 175.21669866769972 "$node_(146) setdest 14127 6497 14.0" 
$ns at 280.72624057515446 "$node_(146) setdest 83982 43873 2.0" 
$ns at 314.297964862827 "$node_(146) setdest 66137 38494 13.0" 
$ns at 348.77285417398105 "$node_(146) setdest 10078 53412 3.0" 
$ns at 398.9890514864742 "$node_(146) setdest 155908 29216 8.0" 
$ns at 495.2377254498068 "$node_(146) setdest 48984 8301 11.0" 
$ns at 623.2266637695644 "$node_(146) setdest 23098 38204 12.0" 
$ns at 734.8364606976203 "$node_(146) setdest 236923 24165 5.0" 
$ns at 814.6524787802626 "$node_(146) setdest 164886 42610 14.0" 
$ns at 154.8013193231268 "$node_(147) setdest 26434 40401 7.0" 
$ns at 206.03036269716526 "$node_(147) setdest 60339 25896 12.0" 
$ns at 349.7082046348787 "$node_(147) setdest 2093 29689 19.0" 
$ns at 424.33232095454207 "$node_(147) setdest 116294 32725 13.0" 
$ns at 475.16019946360944 "$node_(147) setdest 204741 57302 8.0" 
$ns at 559.5913269267606 "$node_(147) setdest 99403 55039 11.0" 
$ns at 667.9637719403984 "$node_(147) setdest 215459 73364 15.0" 
$ns at 842.6731503479094 "$node_(147) setdest 112907 45631 18.0" 
$ns at 128.04884151845516 "$node_(148) setdest 1339 16154 15.0" 
$ns at 245.0622567369694 "$node_(148) setdest 65289 6058 3.0" 
$ns at 296.02145966977764 "$node_(148) setdest 69629 54530 2.0" 
$ns at 334.6292871386333 "$node_(148) setdest 78168 21402 14.0" 
$ns at 496.74071979205763 "$node_(148) setdest 23972 42056 3.0" 
$ns at 542.888794993659 "$node_(148) setdest 148880 33864 11.0" 
$ns at 669.5738078332959 "$node_(148) setdest 71503 66182 8.0" 
$ns at 711.7960894875347 "$node_(148) setdest 52826 9908 19.0" 
$ns at 782.1650372672797 "$node_(148) setdest 262020 48666 15.0" 
$ns at 842.4323159704641 "$node_(148) setdest 210855 12829 10.0" 
$ns at 897.4339450518461 "$node_(148) setdest 92739 68180 7.0" 
$ns at 227.08822078690554 "$node_(149) setdest 57451 30173 4.0" 
$ns at 281.88837726416835 "$node_(149) setdest 65528 18811 12.0" 
$ns at 410.4157683095183 "$node_(149) setdest 7691 39455 1.0" 
$ns at 448.4786060523901 "$node_(149) setdest 83775 58560 8.0" 
$ns at 516.4974158572943 "$node_(149) setdest 135303 51254 4.0" 
$ns at 583.5625173395506 "$node_(149) setdest 217901 23670 13.0" 
$ns at 616.4407939322565 "$node_(149) setdest 102454 59434 12.0" 
$ns at 677.6600595415597 "$node_(149) setdest 123057 21921 10.0" 
$ns at 793.4628314166005 "$node_(149) setdest 214307 40649 11.0" 
$ns at 159.67930159422673 "$node_(150) setdest 125192 30096 17.0" 
$ns at 243.99542689669013 "$node_(150) setdest 36385 5300 8.0" 
$ns at 332.50757144993617 "$node_(150) setdest 36344 52768 5.0" 
$ns at 370.87730014955355 "$node_(150) setdest 174874 26371 5.0" 
$ns at 421.7672893024889 "$node_(150) setdest 127504 13729 1.0" 
$ns at 453.90143232995473 "$node_(150) setdest 201753 65945 13.0" 
$ns at 502.03941294679186 "$node_(150) setdest 38284 30383 14.0" 
$ns at 638.7256237321058 "$node_(150) setdest 195455 72927 7.0" 
$ns at 722.398201508715 "$node_(150) setdest 108361 5664 15.0" 
$ns at 865.3958335271745 "$node_(150) setdest 146052 6711 3.0" 
$ns at 132.69017901070063 "$node_(151) setdest 39274 25314 9.0" 
$ns at 175.59502643329478 "$node_(151) setdest 141 8546 15.0" 
$ns at 336.59724056732 "$node_(151) setdest 123951 15069 16.0" 
$ns at 385.7094258653113 "$node_(151) setdest 22683 12785 11.0" 
$ns at 502.74562409845885 "$node_(151) setdest 126189 53953 1.0" 
$ns at 532.8964968926279 "$node_(151) setdest 112384 47805 6.0" 
$ns at 621.2308232659042 "$node_(151) setdest 93230 52191 2.0" 
$ns at 663.8825237192262 "$node_(151) setdest 75644 46549 18.0" 
$ns at 748.4806500652287 "$node_(151) setdest 8513 24929 12.0" 
$ns at 812.5170347734629 "$node_(151) setdest 209536 32765 14.0" 
$ns at 210.03997283110175 "$node_(152) setdest 88962 3005 9.0" 
$ns at 265.1919967101065 "$node_(152) setdest 119408 24179 16.0" 
$ns at 451.1738079902767 "$node_(152) setdest 66060 44166 12.0" 
$ns at 559.133851140727 "$node_(152) setdest 211063 8224 12.0" 
$ns at 613.3006529503275 "$node_(152) setdest 186808 43960 8.0" 
$ns at 647.1063486288426 "$node_(152) setdest 33434 21954 8.0" 
$ns at 682.9095033868102 "$node_(152) setdest 75415 29216 5.0" 
$ns at 734.4542337769544 "$node_(152) setdest 6345 20074 18.0" 
$ns at 232.22481607495266 "$node_(153) setdest 68075 39249 8.0" 
$ns at 338.19825828235923 "$node_(153) setdest 71090 24021 14.0" 
$ns at 418.17482064102046 "$node_(153) setdest 115190 1065 14.0" 
$ns at 554.8146871834201 "$node_(153) setdest 55859 32162 7.0" 
$ns at 653.8952802321382 "$node_(153) setdest 82742 56887 7.0" 
$ns at 699.5042983003635 "$node_(153) setdest 13292 53290 19.0" 
$ns at 794.4245470453658 "$node_(153) setdest 40613 71205 2.0" 
$ns at 842.3901648684904 "$node_(153) setdest 247783 9035 3.0" 
$ns at 888.0500838925071 "$node_(153) setdest 14536 31989 8.0" 
$ns at 109.35894481809804 "$node_(154) setdest 9921 848 2.0" 
$ns at 146.91774340970017 "$node_(154) setdest 75062 15604 3.0" 
$ns at 199.28607255781267 "$node_(154) setdest 93085 21229 2.0" 
$ns at 248.85876553599894 "$node_(154) setdest 47268 16301 7.0" 
$ns at 339.6888596513191 "$node_(154) setdest 70312 12163 13.0" 
$ns at 488.7041602451022 "$node_(154) setdest 39969 3520 7.0" 
$ns at 582.9307820876279 "$node_(154) setdest 210454 103 7.0" 
$ns at 642.5134557898289 "$node_(154) setdest 129082 45928 12.0" 
$ns at 714.8918445471493 "$node_(154) setdest 219097 76095 15.0" 
$ns at 821.3341733262147 "$node_(154) setdest 102407 78090 4.0" 
$ns at 878.3753198965896 "$node_(154) setdest 131860 77941 12.0" 
$ns at 111.58610046324898 "$node_(155) setdest 24869 31461 3.0" 
$ns at 147.06363231536562 "$node_(155) setdest 92960 4837 5.0" 
$ns at 199.5982086045324 "$node_(155) setdest 5775 13133 6.0" 
$ns at 265.7749659162141 "$node_(155) setdest 130124 6366 16.0" 
$ns at 410.61096702177554 "$node_(155) setdest 991 9269 18.0" 
$ns at 542.7203776812729 "$node_(155) setdest 167881 23477 8.0" 
$ns at 598.2032741730657 "$node_(155) setdest 53611 68118 13.0" 
$ns at 631.6163130589293 "$node_(155) setdest 102620 42047 2.0" 
$ns at 666.9787627182088 "$node_(155) setdest 46927 43383 8.0" 
$ns at 710.983296414441 "$node_(155) setdest 121553 17553 7.0" 
$ns at 787.8301432893285 "$node_(155) setdest 252004 34714 18.0" 
$ns at 180.29688322886943 "$node_(156) setdest 24832 19550 13.0" 
$ns at 291.220068262902 "$node_(156) setdest 48014 11592 14.0" 
$ns at 445.7543665527077 "$node_(156) setdest 13897 28805 6.0" 
$ns at 511.57691381669287 "$node_(156) setdest 104097 36606 13.0" 
$ns at 669.00621215871 "$node_(156) setdest 240495 19369 9.0" 
$ns at 719.4031244604445 "$node_(156) setdest 48598 84 10.0" 
$ns at 830.6115448371014 "$node_(156) setdest 102368 32902 15.0" 
$ns at 108.26114000277144 "$node_(157) setdest 63990 15075 19.0" 
$ns at 238.40876931883525 "$node_(157) setdest 103078 28277 6.0" 
$ns at 287.14400413502347 "$node_(157) setdest 125017 28288 17.0" 
$ns at 321.8890578976569 "$node_(157) setdest 6380 26760 20.0" 
$ns at 468.5667006785123 "$node_(157) setdest 199711 45945 1.0" 
$ns at 504.90271131973066 "$node_(157) setdest 118494 50647 9.0" 
$ns at 612.8532571868184 "$node_(157) setdest 152539 610 1.0" 
$ns at 651.6911999995328 "$node_(157) setdest 215727 12086 4.0" 
$ns at 715.307088609122 "$node_(157) setdest 126679 49074 8.0" 
$ns at 823.9979665574721 "$node_(157) setdest 208050 76639 11.0" 
$ns at 264.43115000565194 "$node_(158) setdest 147157 39981 3.0" 
$ns at 316.16170050154966 "$node_(158) setdest 74841 40435 12.0" 
$ns at 401.8038225360891 "$node_(158) setdest 108496 34274 5.0" 
$ns at 477.3948802685899 "$node_(158) setdest 156846 60735 4.0" 
$ns at 541.7340219186101 "$node_(158) setdest 45717 41263 14.0" 
$ns at 643.9677895225562 "$node_(158) setdest 98177 12182 12.0" 
$ns at 738.7134965906009 "$node_(158) setdest 72367 36769 9.0" 
$ns at 832.9505251890928 "$node_(158) setdest 241948 45674 6.0" 
$ns at 144.9399530652991 "$node_(159) setdest 85225 16690 18.0" 
$ns at 256.57583007888104 "$node_(159) setdest 125127 50322 6.0" 
$ns at 290.4177076673134 "$node_(159) setdest 3128 21208 14.0" 
$ns at 459.8503464660341 "$node_(159) setdest 59727 19188 3.0" 
$ns at 518.1567745738835 "$node_(159) setdest 94245 36996 18.0" 
$ns at 703.7864994250438 "$node_(159) setdest 4280 51742 10.0" 
$ns at 802.0008114846133 "$node_(159) setdest 39704 79763 6.0" 
$ns at 891.5380787253229 "$node_(159) setdest 29118 85038 2.0" 
$ns at 115.34940758800074 "$node_(160) setdest 39784 4016 18.0" 
$ns at 203.2628883542319 "$node_(160) setdest 112317 17254 5.0" 
$ns at 273.73162014388663 "$node_(160) setdest 10099 36033 13.0" 
$ns at 430.4659764574182 "$node_(160) setdest 108783 42940 2.0" 
$ns at 480.3158057474995 "$node_(160) setdest 30783 62091 6.0" 
$ns at 548.1767684206421 "$node_(160) setdest 172597 36205 8.0" 
$ns at 648.4711280233478 "$node_(160) setdest 9365 51866 8.0" 
$ns at 738.1973972341889 "$node_(160) setdest 211730 54005 7.0" 
$ns at 825.2026092465168 "$node_(160) setdest 261701 64879 4.0" 
$ns at 858.35597517068 "$node_(160) setdest 108831 11226 13.0" 
$ns at 125.91281202365303 "$node_(161) setdest 9825 29433 8.0" 
$ns at 214.1430349812427 "$node_(161) setdest 36448 12131 3.0" 
$ns at 267.67291058926753 "$node_(161) setdest 160096 25568 15.0" 
$ns at 414.7931317474598 "$node_(161) setdest 68929 58332 1.0" 
$ns at 445.78632498585426 "$node_(161) setdest 111926 3320 13.0" 
$ns at 557.9983140888679 "$node_(161) setdest 72747 56614 17.0" 
$ns at 664.7058452537345 "$node_(161) setdest 76245 66324 7.0" 
$ns at 762.7757061566025 "$node_(161) setdest 247651 59743 14.0" 
$ns at 827.5975833772013 "$node_(161) setdest 135225 43158 9.0" 
$ns at 877.781278289 "$node_(161) setdest 223497 34507 12.0" 
$ns at 111.51012447323798 "$node_(162) setdest 77241 12289 12.0" 
$ns at 194.81459338611768 "$node_(162) setdest 52178 17936 14.0" 
$ns at 278.3686669303357 "$node_(162) setdest 44066 46907 13.0" 
$ns at 392.8373458714853 "$node_(162) setdest 17335 49048 13.0" 
$ns at 462.97120592052096 "$node_(162) setdest 162350 43462 20.0" 
$ns at 688.0825300939945 "$node_(162) setdest 16155 42296 9.0" 
$ns at 723.1080200617567 "$node_(162) setdest 212101 14429 10.0" 
$ns at 813.1398897450672 "$node_(162) setdest 140516 5995 4.0" 
$ns at 855.450512033009 "$node_(162) setdest 159520 35685 9.0" 
$ns at 148.45820605018497 "$node_(163) setdest 11748 21866 1.0" 
$ns at 187.79719861377586 "$node_(163) setdest 130092 19650 13.0" 
$ns at 259.1657815904896 "$node_(163) setdest 156853 18137 3.0" 
$ns at 312.07068951253507 "$node_(163) setdest 44261 46095 17.0" 
$ns at 396.14830323634885 "$node_(163) setdest 82502 58212 3.0" 
$ns at 443.37732814687234 "$node_(163) setdest 19474 42304 7.0" 
$ns at 511.789440420255 "$node_(163) setdest 115486 3314 18.0" 
$ns at 594.7959586408151 "$node_(163) setdest 129392 43289 4.0" 
$ns at 633.2511163986846 "$node_(163) setdest 163414 43996 17.0" 
$ns at 778.0474828570818 "$node_(163) setdest 244358 66519 5.0" 
$ns at 853.8298548471894 "$node_(163) setdest 119707 14428 1.0" 
$ns at 884.2052190435898 "$node_(163) setdest 55514 66221 9.0" 
$ns at 140.0365670904198 "$node_(164) setdest 63515 29744 8.0" 
$ns at 221.18285334978992 "$node_(164) setdest 10224 15823 18.0" 
$ns at 385.1985550240658 "$node_(164) setdest 2887 56320 11.0" 
$ns at 504.27026923046583 "$node_(164) setdest 203423 5068 5.0" 
$ns at 557.6731258311277 "$node_(164) setdest 93728 16386 13.0" 
$ns at 658.4871537722884 "$node_(164) setdest 183020 11848 1.0" 
$ns at 697.3444654594713 "$node_(164) setdest 81429 70460 4.0" 
$ns at 758.637582771713 "$node_(164) setdest 230196 85092 1.0" 
$ns at 796.8740571653935 "$node_(164) setdest 127139 896 15.0" 
$ns at 166.63677877892877 "$node_(165) setdest 57136 51 1.0" 
$ns at 197.0843825542166 "$node_(165) setdest 68424 20888 1.0" 
$ns at 229.1802284647659 "$node_(165) setdest 89813 12807 12.0" 
$ns at 346.8816983161293 "$node_(165) setdest 164309 41477 3.0" 
$ns at 392.5742908584763 "$node_(165) setdest 68924 4685 12.0" 
$ns at 488.82660673961175 "$node_(165) setdest 67086 30665 19.0" 
$ns at 573.302005563252 "$node_(165) setdest 3894 25382 2.0" 
$ns at 611.8389401246708 "$node_(165) setdest 120446 27061 18.0" 
$ns at 656.7631004469202 "$node_(165) setdest 179436 37658 14.0" 
$ns at 776.4975733464479 "$node_(165) setdest 255377 30740 16.0" 
$ns at 848.7389931223112 "$node_(165) setdest 262840 60375 20.0" 
$ns at 159.42284616730035 "$node_(166) setdest 2280 36453 3.0" 
$ns at 216.36274629365397 "$node_(166) setdest 25306 25013 2.0" 
$ns at 253.7627236557059 "$node_(166) setdest 103481 33978 5.0" 
$ns at 302.6113188973598 "$node_(166) setdest 65187 3956 11.0" 
$ns at 404.26373358986643 "$node_(166) setdest 122848 30963 17.0" 
$ns at 540.8756947954513 "$node_(166) setdest 24987 19463 13.0" 
$ns at 621.0491906845241 "$node_(166) setdest 73731 33916 6.0" 
$ns at 680.3675302829696 "$node_(166) setdest 144944 18346 3.0" 
$ns at 735.2026138885781 "$node_(166) setdest 179229 51039 1.0" 
$ns at 767.5040655178958 "$node_(166) setdest 161486 52244 19.0" 
$ns at 181.92314757011184 "$node_(167) setdest 71712 40351 15.0" 
$ns at 301.0113090876111 "$node_(167) setdest 120091 45843 1.0" 
$ns at 336.3633670183194 "$node_(167) setdest 112798 53684 2.0" 
$ns at 376.9986774498408 "$node_(167) setdest 165413 62959 11.0" 
$ns at 449.1467038004507 "$node_(167) setdest 10705 2227 14.0" 
$ns at 535.7478140175714 "$node_(167) setdest 205694 56762 9.0" 
$ns at 626.9309851664543 "$node_(167) setdest 72147 24795 16.0" 
$ns at 734.5759722307888 "$node_(167) setdest 2836 34243 5.0" 
$ns at 794.807867398584 "$node_(167) setdest 69516 22517 18.0" 
$ns at 839.7915751406716 "$node_(167) setdest 75601 80862 14.0" 
$ns at 120.24993334775745 "$node_(168) setdest 66711 8453 13.0" 
$ns at 158.5834343308765 "$node_(168) setdest 16987 37257 20.0" 
$ns at 388.45475732593354 "$node_(168) setdest 59392 24764 12.0" 
$ns at 509.6751988713198 "$node_(168) setdest 15213 40906 9.0" 
$ns at 586.9762692955553 "$node_(168) setdest 138044 66169 11.0" 
$ns at 622.9657491411193 "$node_(168) setdest 71488 26845 19.0" 
$ns at 661.7441027139555 "$node_(168) setdest 206039 33536 10.0" 
$ns at 714.7811836090268 "$node_(168) setdest 215495 36404 18.0" 
$ns at 100.72686990365368 "$node_(169) setdest 29883 22507 18.0" 
$ns at 132.39056639444343 "$node_(169) setdest 52923 12258 15.0" 
$ns at 303.8481970591358 "$node_(169) setdest 87271 14298 6.0" 
$ns at 348.0500131015536 "$node_(169) setdest 160221 41607 5.0" 
$ns at 421.8611766157337 "$node_(169) setdest 104511 9583 8.0" 
$ns at 517.0972292731916 "$node_(169) setdest 59713 68361 3.0" 
$ns at 566.6805062984021 "$node_(169) setdest 36068 21198 16.0" 
$ns at 622.6958632599478 "$node_(169) setdest 71590 58421 6.0" 
$ns at 701.6138994536841 "$node_(169) setdest 186155 26449 11.0" 
$ns at 804.9668415988899 "$node_(169) setdest 260800 83194 11.0" 
$ns at 192.89499677658384 "$node_(170) setdest 8719 33213 16.0" 
$ns at 286.7620840257728 "$node_(170) setdest 124437 2264 13.0" 
$ns at 421.50366690899 "$node_(170) setdest 80460 3213 10.0" 
$ns at 485.34100761598614 "$node_(170) setdest 133557 45464 13.0" 
$ns at 598.3936212675593 "$node_(170) setdest 162 34491 3.0" 
$ns at 639.210097692065 "$node_(170) setdest 177325 64844 7.0" 
$ns at 679.0205657378726 "$node_(170) setdest 55126 75656 12.0" 
$ns at 794.5814918084312 "$node_(170) setdest 224019 12115 3.0" 
$ns at 842.0769543256129 "$node_(170) setdest 386 28097 19.0" 
$ns at 206.0577760315798 "$node_(171) setdest 133487 39260 9.0" 
$ns at 265.0635747757161 "$node_(171) setdest 163705 923 19.0" 
$ns at 371.650754919337 "$node_(171) setdest 184306 24744 15.0" 
$ns at 431.404184078076 "$node_(171) setdest 140167 44348 14.0" 
$ns at 579.9590914985808 "$node_(171) setdest 50768 71976 1.0" 
$ns at 612.880474976768 "$node_(171) setdest 39006 6297 13.0" 
$ns at 749.6658250855135 "$node_(171) setdest 85853 68464 10.0" 
$ns at 791.1098528412899 "$node_(171) setdest 131586 8996 11.0" 
$ns at 150.2957572129357 "$node_(172) setdest 123440 35644 7.0" 
$ns at 222.2226847295911 "$node_(172) setdest 24458 34996 3.0" 
$ns at 254.44319695815588 "$node_(172) setdest 97675 11254 4.0" 
$ns at 315.82132200526524 "$node_(172) setdest 8880 42406 20.0" 
$ns at 481.63162499472514 "$node_(172) setdest 187667 47581 2.0" 
$ns at 528.9279475869957 "$node_(172) setdest 21708 14638 19.0" 
$ns at 600.0012817464176 "$node_(172) setdest 207217 30826 20.0" 
$ns at 767.9733777715707 "$node_(172) setdest 186208 20288 8.0" 
$ns at 845.621858736447 "$node_(172) setdest 150924 43948 15.0" 
$ns at 124.48096734321837 "$node_(173) setdest 20752 12211 8.0" 
$ns at 175.26639918196292 "$node_(173) setdest 118090 11775 19.0" 
$ns at 346.5846451037404 "$node_(173) setdest 100407 46484 20.0" 
$ns at 543.4201603584646 "$node_(173) setdest 60199 67472 1.0" 
$ns at 579.510720323198 "$node_(173) setdest 175117 51184 4.0" 
$ns at 629.5592696947103 "$node_(173) setdest 150419 66034 12.0" 
$ns at 731.6824580654926 "$node_(173) setdest 83093 53357 11.0" 
$ns at 824.1613124250174 "$node_(173) setdest 28487 75328 10.0" 
$ns at 102.716003893073 "$node_(174) setdest 39999 22141 18.0" 
$ns at 252.2684060245528 "$node_(174) setdest 109332 39511 3.0" 
$ns at 304.1316897287064 "$node_(174) setdest 45765 20581 18.0" 
$ns at 377.4520052184622 "$node_(174) setdest 177431 31653 13.0" 
$ns at 483.7855097350239 "$node_(174) setdest 101253 4101 16.0" 
$ns at 628.4661974206552 "$node_(174) setdest 199114 32521 13.0" 
$ns at 762.0166001674049 "$node_(174) setdest 150743 26386 19.0" 
$ns at 167.67356050910973 "$node_(175) setdest 47356 43642 16.0" 
$ns at 337.97746455746324 "$node_(175) setdest 158565 45555 4.0" 
$ns at 382.0729954307262 "$node_(175) setdest 135047 44447 1.0" 
$ns at 421.53653270205814 "$node_(175) setdest 37415 25852 14.0" 
$ns at 457.70149748963195 "$node_(175) setdest 173619 50864 10.0" 
$ns at 520.9643641518373 "$node_(175) setdest 194416 2267 11.0" 
$ns at 621.1503808100472 "$node_(175) setdest 164391 70901 16.0" 
$ns at 696.3302320475827 "$node_(175) setdest 182128 22782 10.0" 
$ns at 817.1585665044101 "$node_(175) setdest 12169 60514 18.0" 
$ns at 107.05763914090204 "$node_(176) setdest 66098 30232 7.0" 
$ns at 147.15422346527458 "$node_(176) setdest 40391 10863 13.0" 
$ns at 264.95133170879353 "$node_(176) setdest 79996 6039 8.0" 
$ns at 296.09495198126206 "$node_(176) setdest 146372 7087 11.0" 
$ns at 376.2415959008821 "$node_(176) setdest 46793 15994 4.0" 
$ns at 419.05316196617935 "$node_(176) setdest 42318 42506 19.0" 
$ns at 620.1036768751208 "$node_(176) setdest 197256 70707 7.0" 
$ns at 664.8005417578474 "$node_(176) setdest 31215 45896 10.0" 
$ns at 724.1345326504975 "$node_(176) setdest 231069 19066 6.0" 
$ns at 773.09665261174 "$node_(176) setdest 148824 25201 15.0" 
$ns at 177.908136249835 "$node_(177) setdest 27768 1542 9.0" 
$ns at 257.6470993388062 "$node_(177) setdest 100814 9196 3.0" 
$ns at 299.28679991041946 "$node_(177) setdest 2382 38210 8.0" 
$ns at 399.50244919839366 "$node_(177) setdest 106359 35966 12.0" 
$ns at 474.2825425149353 "$node_(177) setdest 165945 33428 16.0" 
$ns at 588.2126852010492 "$node_(177) setdest 33522 25604 12.0" 
$ns at 643.8563378959267 "$node_(177) setdest 33389 13463 1.0" 
$ns at 675.4921338361038 "$node_(177) setdest 169693 30370 9.0" 
$ns at 725.8085551255275 "$node_(177) setdest 170055 51961 11.0" 
$ns at 793.5948037250214 "$node_(177) setdest 65735 5659 11.0" 
$ns at 159.9367742392946 "$node_(178) setdest 53043 29096 16.0" 
$ns at 326.4304163716228 "$node_(178) setdest 155139 33880 14.0" 
$ns at 456.53531174137635 "$node_(178) setdest 104203 24153 1.0" 
$ns at 489.3458657803394 "$node_(178) setdest 203925 4603 15.0" 
$ns at 599.5754768153961 "$node_(178) setdest 159670 70278 16.0" 
$ns at 655.2805882101621 "$node_(178) setdest 190462 78360 19.0" 
$ns at 850.4898123622745 "$node_(178) setdest 229255 14194 15.0" 
$ns at 141.16425724641354 "$node_(179) setdest 2633 25391 1.0" 
$ns at 174.91266880813123 "$node_(179) setdest 2458 6390 12.0" 
$ns at 293.9789441187712 "$node_(179) setdest 13621 3778 19.0" 
$ns at 488.7331175381422 "$node_(179) setdest 74815 4045 16.0" 
$ns at 519.3247072269045 "$node_(179) setdest 195794 4940 13.0" 
$ns at 616.7601266823976 "$node_(179) setdest 149867 2662 15.0" 
$ns at 761.2874321733232 "$node_(179) setdest 110759 82297 16.0" 
$ns at 825.3971215294673 "$node_(179) setdest 155622 81909 10.0" 
$ns at 269.7841859163841 "$node_(180) setdest 26315 5814 11.0" 
$ns at 381.1709978837032 "$node_(180) setdest 41711 20222 14.0" 
$ns at 547.0181818850192 "$node_(180) setdest 113785 17766 12.0" 
$ns at 593.5983309820023 "$node_(180) setdest 173286 63662 10.0" 
$ns at 657.0050457971374 "$node_(180) setdest 63340 38619 11.0" 
$ns at 741.4810655205781 "$node_(180) setdest 49726 62474 17.0" 
$ns at 869.5252829724619 "$node_(180) setdest 9369 65934 5.0" 
$ns at 167.0378821933284 "$node_(181) setdest 105170 19637 1.0" 
$ns at 197.43551576733847 "$node_(181) setdest 43275 21694 10.0" 
$ns at 304.15008972332805 "$node_(181) setdest 21106 6531 17.0" 
$ns at 417.80168986065416 "$node_(181) setdest 106254 18161 4.0" 
$ns at 480.13968732338213 "$node_(181) setdest 153799 34670 11.0" 
$ns at 539.720491043315 "$node_(181) setdest 207677 28482 10.0" 
$ns at 668.5211876681026 "$node_(181) setdest 102922 36057 10.0" 
$ns at 724.9130478368769 "$node_(181) setdest 181635 12364 8.0" 
$ns at 785.8656480715388 "$node_(181) setdest 153159 15242 7.0" 
$ns at 843.3959851006753 "$node_(181) setdest 241196 75521 10.0" 
$ns at 164.71111483213713 "$node_(182) setdest 71100 21713 14.0" 
$ns at 289.7720425453931 "$node_(182) setdest 47729 23472 11.0" 
$ns at 416.2495537210223 "$node_(182) setdest 49861 5520 14.0" 
$ns at 470.83277522199376 "$node_(182) setdest 133671 49038 14.0" 
$ns at 513.0766103703252 "$node_(182) setdest 195335 69175 8.0" 
$ns at 602.1869976953448 "$node_(182) setdest 186403 16202 7.0" 
$ns at 675.2595552082082 "$node_(182) setdest 193202 67693 14.0" 
$ns at 805.0060605335432 "$node_(182) setdest 138728 40527 2.0" 
$ns at 848.2634667397633 "$node_(182) setdest 73586 4629 13.0" 
$ns at 122.27773304986071 "$node_(183) setdest 15868 15423 6.0" 
$ns at 185.16051914569437 "$node_(183) setdest 28563 3423 4.0" 
$ns at 230.63913848297867 "$node_(183) setdest 86339 1412 15.0" 
$ns at 405.8852190775292 "$node_(183) setdest 110793 16284 3.0" 
$ns at 439.35534889591247 "$node_(183) setdest 55161 18037 15.0" 
$ns at 560.6777383964031 "$node_(183) setdest 24618 61094 10.0" 
$ns at 626.9510151430834 "$node_(183) setdest 144426 36127 20.0" 
$ns at 742.6338525118188 "$node_(183) setdest 168034 28516 4.0" 
$ns at 795.6435135993984 "$node_(183) setdest 85818 54326 9.0" 
$ns at 847.5338724947622 "$node_(183) setdest 145406 35053 13.0" 
$ns at 104.9747976796194 "$node_(184) setdest 24358 3684 6.0" 
$ns at 190.86197689508168 "$node_(184) setdest 5863 20097 14.0" 
$ns at 280.8994474306279 "$node_(184) setdest 159238 27320 16.0" 
$ns at 431.3813222381402 "$node_(184) setdest 99303 30442 20.0" 
$ns at 605.1783412502957 "$node_(184) setdest 177825 72813 19.0" 
$ns at 669.5368525862935 "$node_(184) setdest 20824 19175 1.0" 
$ns at 702.3398583667981 "$node_(184) setdest 167001 73534 5.0" 
$ns at 768.092993543384 "$node_(184) setdest 102424 28066 17.0" 
$ns at 830.7100759968278 "$node_(184) setdest 82330 17501 13.0" 
$ns at 176.42735371145073 "$node_(185) setdest 63523 8 8.0" 
$ns at 260.78249471337574 "$node_(185) setdest 128050 44261 2.0" 
$ns at 296.3431796996349 "$node_(185) setdest 92012 10501 18.0" 
$ns at 391.8770748020189 "$node_(185) setdest 146497 11036 6.0" 
$ns at 468.69396083493774 "$node_(185) setdest 202939 19077 7.0" 
$ns at 504.40534175440666 "$node_(185) setdest 49250 63371 1.0" 
$ns at 535.6217721937436 "$node_(185) setdest 32378 10635 3.0" 
$ns at 575.306796144113 "$node_(185) setdest 87346 19588 2.0" 
$ns at 606.7574211850881 "$node_(185) setdest 115961 50390 3.0" 
$ns at 661.0582482846869 "$node_(185) setdest 184596 48975 18.0" 
$ns at 717.5493292511984 "$node_(185) setdest 83115 76963 3.0" 
$ns at 771.5544881940843 "$node_(185) setdest 200693 13218 17.0" 
$ns at 835.702837913731 "$node_(185) setdest 181887 72619 10.0" 
$ns at 221.53304127551178 "$node_(186) setdest 2798 27000 2.0" 
$ns at 252.79107311441052 "$node_(186) setdest 94661 52187 5.0" 
$ns at 284.43231554031826 "$node_(186) setdest 108965 19651 12.0" 
$ns at 321.24080183954965 "$node_(186) setdest 43259 27776 16.0" 
$ns at 420.9120661267606 "$node_(186) setdest 180953 36453 1.0" 
$ns at 451.7711038331436 "$node_(186) setdest 176108 12190 6.0" 
$ns at 536.0110460775111 "$node_(186) setdest 55445 30805 17.0" 
$ns at 572.8012925058096 "$node_(186) setdest 174096 6898 13.0" 
$ns at 632.95277787921 "$node_(186) setdest 18545 28200 11.0" 
$ns at 769.1938434911202 "$node_(186) setdest 206017 6001 1.0" 
$ns at 804.2623054836978 "$node_(186) setdest 139343 47418 16.0" 
$ns at 114.46668619178357 "$node_(187) setdest 85051 13953 4.0" 
$ns at 151.5509185966769 "$node_(187) setdest 57519 26822 5.0" 
$ns at 205.00052252049267 "$node_(187) setdest 64221 27533 15.0" 
$ns at 252.95382279382426 "$node_(187) setdest 35529 37537 17.0" 
$ns at 388.38270757310084 "$node_(187) setdest 78361 45153 13.0" 
$ns at 419.7114684049195 "$node_(187) setdest 17502 28627 15.0" 
$ns at 539.3400127839263 "$node_(187) setdest 175273 46721 2.0" 
$ns at 583.1783655352261 "$node_(187) setdest 113293 34412 12.0" 
$ns at 706.1689565768106 "$node_(187) setdest 239006 10364 15.0" 
$ns at 837.8537363330902 "$node_(187) setdest 228779 30418 3.0" 
$ns at 872.4088544359245 "$node_(187) setdest 263224 55242 7.0" 
$ns at 148.63612325276318 "$node_(188) setdest 382 20942 10.0" 
$ns at 246.34668637475147 "$node_(188) setdest 60236 20794 1.0" 
$ns at 277.4490302486462 "$node_(188) setdest 22197 11501 12.0" 
$ns at 362.91039641560616 "$node_(188) setdest 99916 35072 1.0" 
$ns at 398.8093793106508 "$node_(188) setdest 111098 18161 5.0" 
$ns at 468.32670961780343 "$node_(188) setdest 149350 43685 8.0" 
$ns at 542.4108140400647 "$node_(188) setdest 202943 54573 6.0" 
$ns at 597.8110266152813 "$node_(188) setdest 38796 64218 15.0" 
$ns at 720.6480507746996 "$node_(188) setdest 189852 82235 4.0" 
$ns at 775.2539019832615 "$node_(188) setdest 194332 69656 9.0" 
$ns at 840.8158627439273 "$node_(188) setdest 105144 39229 18.0" 
$ns at 215.6417209896939 "$node_(189) setdest 31580 1238 18.0" 
$ns at 286.92004118502814 "$node_(189) setdest 62167 50087 10.0" 
$ns at 413.72692919345604 "$node_(189) setdest 57971 18499 6.0" 
$ns at 469.72439131240475 "$node_(189) setdest 91408 38671 17.0" 
$ns at 587.3446533952559 "$node_(189) setdest 37579 50288 1.0" 
$ns at 624.7498607523095 "$node_(189) setdest 230115 60891 2.0" 
$ns at 664.3224322158256 "$node_(189) setdest 116733 23284 18.0" 
$ns at 724.5925398741947 "$node_(189) setdest 95684 77687 15.0" 
$ns at 791.243149869439 "$node_(189) setdest 210229 17805 19.0" 
$ns at 117.82963961877766 "$node_(190) setdest 28009 23949 19.0" 
$ns at 210.5122781481803 "$node_(190) setdest 85757 2926 8.0" 
$ns at 267.8441423610035 "$node_(190) setdest 16691 16886 16.0" 
$ns at 353.42400144610826 "$node_(190) setdest 94993 59311 2.0" 
$ns at 393.79429577327016 "$node_(190) setdest 144400 30940 5.0" 
$ns at 458.30384538836677 "$node_(190) setdest 205190 47759 2.0" 
$ns at 496.04305134922964 "$node_(190) setdest 192885 51330 17.0" 
$ns at 560.5900522399347 "$node_(190) setdest 183423 59452 14.0" 
$ns at 718.7404379857876 "$node_(190) setdest 19358 72663 1.0" 
$ns at 753.5518264639405 "$node_(190) setdest 194041 31227 11.0" 
$ns at 840.333781719531 "$node_(190) setdest 19020 8929 7.0" 
$ns at 169.54876978643702 "$node_(191) setdest 68096 44543 13.0" 
$ns at 279.2926686957818 "$node_(191) setdest 10062 53072 8.0" 
$ns at 379.77216118645913 "$node_(191) setdest 45879 21226 4.0" 
$ns at 443.0833803702186 "$node_(191) setdest 38909 4968 9.0" 
$ns at 542.2623371853753 "$node_(191) setdest 82741 46392 3.0" 
$ns at 586.1830090120375 "$node_(191) setdest 12669 61173 13.0" 
$ns at 706.1716616014993 "$node_(191) setdest 108000 51574 19.0" 
$ns at 751.9823031540257 "$node_(191) setdest 21334 69121 9.0" 
$ns at 809.9645563773798 "$node_(191) setdest 10328 88804 13.0" 
$ns at 125.72174017965446 "$node_(192) setdest 2779 10265 17.0" 
$ns at 190.5816291699436 "$node_(192) setdest 39240 11379 8.0" 
$ns at 277.9092296052294 "$node_(192) setdest 11544 42492 19.0" 
$ns at 381.63377649067877 "$node_(192) setdest 123162 21053 18.0" 
$ns at 447.6919622470351 "$node_(192) setdest 1701 21961 10.0" 
$ns at 499.6536718985335 "$node_(192) setdest 177820 318 2.0" 
$ns at 549.1271746246489 "$node_(192) setdest 178924 30744 2.0" 
$ns at 582.9655717465117 "$node_(192) setdest 187166 24744 19.0" 
$ns at 765.6542378417184 "$node_(192) setdest 191874 75575 19.0" 
$ns at 180.35649557835285 "$node_(193) setdest 94467 28583 5.0" 
$ns at 215.25654864239687 "$node_(193) setdest 109934 41922 7.0" 
$ns at 296.4514601584192 "$node_(193) setdest 140482 32178 8.0" 
$ns at 401.6187103716849 "$node_(193) setdest 80155 61739 14.0" 
$ns at 532.3077307006795 "$node_(193) setdest 60785 19479 6.0" 
$ns at 589.1775411600744 "$node_(193) setdest 220253 58734 10.0" 
$ns at 668.7920484021483 "$node_(193) setdest 99912 72364 3.0" 
$ns at 723.0528166665023 "$node_(193) setdest 218675 1557 6.0" 
$ns at 798.0852832965286 "$node_(193) setdest 45274 84921 1.0" 
$ns at 830.4122243800279 "$node_(193) setdest 214310 18516 11.0" 
$ns at 141.43182921907623 "$node_(194) setdest 28650 5376 9.0" 
$ns at 203.38678405958933 "$node_(194) setdest 124763 10243 5.0" 
$ns at 281.9932451968365 "$node_(194) setdest 160777 50367 5.0" 
$ns at 356.95866426022053 "$node_(194) setdest 36203 24034 8.0" 
$ns at 433.0191497636036 "$node_(194) setdest 83237 41850 8.0" 
$ns at 505.94011925653524 "$node_(194) setdest 84681 2887 10.0" 
$ns at 593.8120002103368 "$node_(194) setdest 112621 59396 4.0" 
$ns at 627.0188979168382 "$node_(194) setdest 167422 54945 8.0" 
$ns at 710.5846679687111 "$node_(194) setdest 224717 398 17.0" 
$ns at 747.156346175517 "$node_(194) setdest 211922 49830 1.0" 
$ns at 786.4912844001609 "$node_(194) setdest 45330 45413 2.0" 
$ns at 821.8012510902815 "$node_(194) setdest 11927 73021 7.0" 
$ns at 198.83174101660398 "$node_(195) setdest 102129 35184 19.0" 
$ns at 332.98000739167304 "$node_(195) setdest 63747 11188 14.0" 
$ns at 481.1324582264602 "$node_(195) setdest 187171 60451 8.0" 
$ns at 585.6878456607873 "$node_(195) setdest 97978 59353 3.0" 
$ns at 624.0397059289168 "$node_(195) setdest 122060 36094 13.0" 
$ns at 709.8144199585233 "$node_(195) setdest 233164 1844 17.0" 
$ns at 810.4477067727139 "$node_(195) setdest 169721 80508 3.0" 
$ns at 862.793746425697 "$node_(195) setdest 27700 22123 17.0" 
$ns at 144.51698223130865 "$node_(196) setdest 11145 10166 4.0" 
$ns at 175.28625190879737 "$node_(196) setdest 113328 30222 5.0" 
$ns at 245.79276241924606 "$node_(196) setdest 107480 947 1.0" 
$ns at 284.26019703500464 "$node_(196) setdest 39725 51143 18.0" 
$ns at 390.9642652979606 "$node_(196) setdest 31629 26719 8.0" 
$ns at 485.5056668790563 "$node_(196) setdest 108842 27250 16.0" 
$ns at 545.8830244180808 "$node_(196) setdest 78838 60636 5.0" 
$ns at 623.6007411532511 "$node_(196) setdest 38185 73009 15.0" 
$ns at 751.0447322117261 "$node_(196) setdest 26833 63327 17.0" 
$ns at 881.4709386384858 "$node_(196) setdest 137166 77676 1.0" 
$ns at 120.79551520302218 "$node_(197) setdest 33791 3993 15.0" 
$ns at 262.4811491496356 "$node_(197) setdest 154428 37942 2.0" 
$ns at 309.7267680853928 "$node_(197) setdest 112093 42956 18.0" 
$ns at 500.17722366187525 "$node_(197) setdest 209740 12801 10.0" 
$ns at 581.720399261981 "$node_(197) setdest 23498 77210 10.0" 
$ns at 706.9642749851098 "$node_(197) setdest 208469 37438 10.0" 
$ns at 761.7113837713407 "$node_(197) setdest 12439 29591 10.0" 
$ns at 830.689589860735 "$node_(197) setdest 235893 86496 2.0" 
$ns at 872.7192558517085 "$node_(197) setdest 253997 40954 2.0" 
$ns at 146.49265571435524 "$node_(198) setdest 82526 15175 5.0" 
$ns at 199.4784967642935 "$node_(198) setdest 5133 17782 17.0" 
$ns at 288.5636098261806 "$node_(198) setdest 61803 22439 15.0" 
$ns at 465.027632682637 "$node_(198) setdest 194651 55069 9.0" 
$ns at 509.0745639172505 "$node_(198) setdest 120001 40664 14.0" 
$ns at 646.9007152399863 "$node_(198) setdest 162340 70981 8.0" 
$ns at 747.6078814947729 "$node_(198) setdest 141448 80809 15.0" 
$ns at 788.8067613898195 "$node_(198) setdest 183829 47680 3.0" 
$ns at 832.6479776881322 "$node_(198) setdest 248482 70995 5.0" 
$ns at 863.9313130911104 "$node_(198) setdest 41958 41926 4.0" 
$ns at 204.30212683329052 "$node_(199) setdest 75144 36152 17.0" 
$ns at 352.58438255092426 "$node_(199) setdest 87104 756 8.0" 
$ns at 405.5000025373701 "$node_(199) setdest 181059 5754 1.0" 
$ns at 444.6808311220401 "$node_(199) setdest 81278 18413 15.0" 
$ns at 578.7899344262803 "$node_(199) setdest 152455 22590 19.0" 
$ns at 610.6879331468595 "$node_(199) setdest 209988 26366 9.0" 
$ns at 699.6124897147844 "$node_(199) setdest 5677 1167 16.0" 
$ns at 810.1190791225671 "$node_(199) setdest 213663 29746 14.0" 
$ns at 847.0081572463847 "$node_(199) setdest 265890 59072 1.0" 
$ns at 883.8091341339899 "$node_(199) setdest 177591 60643 9.0" 
$ns at 228.26114382609006 "$node_(200) setdest 73089 41732 14.0" 
$ns at 344.79921299966406 "$node_(200) setdest 101233 758 10.0" 
$ns at 464.52171415923283 "$node_(200) setdest 7251 33285 14.0" 
$ns at 503.16490920848173 "$node_(200) setdest 131475 25296 13.0" 
$ns at 607.1273644795262 "$node_(200) setdest 40561 18395 10.0" 
$ns at 671.8910453639805 "$node_(200) setdest 33686 39114 7.0" 
$ns at 703.3590102152042 "$node_(200) setdest 40150 36407 8.0" 
$ns at 780.8945469906953 "$node_(200) setdest 127511 17696 17.0" 
$ns at 221.6721250310751 "$node_(201) setdest 89138 29101 5.0" 
$ns at 264.8345632570223 "$node_(201) setdest 53210 8152 8.0" 
$ns at 314.9290326663326 "$node_(201) setdest 25225 41157 18.0" 
$ns at 501.7943195360615 "$node_(201) setdest 77293 1958 1.0" 
$ns at 536.7907641046022 "$node_(201) setdest 27224 13897 19.0" 
$ns at 705.6249378759649 "$node_(201) setdest 120895 41510 13.0" 
$ns at 737.0508092020737 "$node_(201) setdest 50551 31664 10.0" 
$ns at 774.9559764099516 "$node_(201) setdest 60957 39130 10.0" 
$ns at 857.1498023710808 "$node_(201) setdest 118672 8329 18.0" 
$ns at 281.4189309377666 "$node_(202) setdest 118509 8659 13.0" 
$ns at 440.02265340363317 "$node_(202) setdest 61166 20966 5.0" 
$ns at 510.5308406236952 "$node_(202) setdest 121690 8413 12.0" 
$ns at 568.6082648484805 "$node_(202) setdest 38647 33933 3.0" 
$ns at 612.6885312527355 "$node_(202) setdest 88086 31034 7.0" 
$ns at 676.9363077897441 "$node_(202) setdest 68601 23562 16.0" 
$ns at 853.6956080995401 "$node_(202) setdest 50741 17120 8.0" 
$ns at 234.14480910825796 "$node_(203) setdest 121918 9610 13.0" 
$ns at 342.7970883971895 "$node_(203) setdest 58408 30585 14.0" 
$ns at 388.64696209964904 "$node_(203) setdest 104342 39475 7.0" 
$ns at 463.5489226953625 "$node_(203) setdest 122319 28370 9.0" 
$ns at 557.7106226774905 "$node_(203) setdest 83960 40515 9.0" 
$ns at 620.4075449319075 "$node_(203) setdest 76342 5964 11.0" 
$ns at 669.7867091304427 "$node_(203) setdest 13776 18261 13.0" 
$ns at 706.7485770865701 "$node_(203) setdest 8004 20271 9.0" 
$ns at 741.8906677305372 "$node_(203) setdest 65586 1888 1.0" 
$ns at 780.2879019649536 "$node_(203) setdest 45917 18479 18.0" 
$ns at 815.2167227440386 "$node_(203) setdest 113779 11711 16.0" 
$ns at 227.5972976592146 "$node_(204) setdest 11110 11399 18.0" 
$ns at 321.5467811376915 "$node_(204) setdest 24694 2523 3.0" 
$ns at 376.1964243983697 "$node_(204) setdest 100150 25664 16.0" 
$ns at 558.809639089415 "$node_(204) setdest 13170 5487 5.0" 
$ns at 614.2076081278998 "$node_(204) setdest 32982 30418 20.0" 
$ns at 771.179717579545 "$node_(204) setdest 123872 22323 17.0" 
$ns at 278.48358279348156 "$node_(205) setdest 25363 30737 11.0" 
$ns at 389.26778858229943 "$node_(205) setdest 133397 35647 16.0" 
$ns at 526.289226918597 "$node_(205) setdest 77983 30481 5.0" 
$ns at 556.8230325974416 "$node_(205) setdest 83929 44261 3.0" 
$ns at 599.677127074655 "$node_(205) setdest 59200 11903 15.0" 
$ns at 742.1898074235562 "$node_(205) setdest 95645 28272 1.0" 
$ns at 782.1058936899587 "$node_(205) setdest 12640 13287 12.0" 
$ns at 841.6135740574422 "$node_(205) setdest 133178 44205 20.0" 
$ns at 205.1592934271207 "$node_(206) setdest 133971 11007 1.0" 
$ns at 238.85690056611043 "$node_(206) setdest 118152 24144 14.0" 
$ns at 348.61973745130393 "$node_(206) setdest 77655 6437 16.0" 
$ns at 388.49984162905537 "$node_(206) setdest 28724 35177 20.0" 
$ns at 588.6154944371912 "$node_(206) setdest 74338 15646 15.0" 
$ns at 748.3308130452447 "$node_(206) setdest 114477 12847 2.0" 
$ns at 794.8707690755322 "$node_(206) setdest 33793 30852 5.0" 
$ns at 866.2815505907145 "$node_(206) setdest 110686 31170 6.0" 
$ns at 897.6466591073948 "$node_(206) setdest 130537 13566 1.0" 
$ns at 232.13979756975357 "$node_(207) setdest 30354 23515 1.0" 
$ns at 266.5307749789401 "$node_(207) setdest 33029 37869 3.0" 
$ns at 318.80736789564304 "$node_(207) setdest 83907 23001 18.0" 
$ns at 494.4482755177763 "$node_(207) setdest 78254 34298 8.0" 
$ns at 534.7853899624776 "$node_(207) setdest 25069 44719 16.0" 
$ns at 575.7478073170914 "$node_(207) setdest 109627 25020 2.0" 
$ns at 609.366566767731 "$node_(207) setdest 36579 32296 4.0" 
$ns at 658.6599119532674 "$node_(207) setdest 9789 16932 1.0" 
$ns at 696.7989448328472 "$node_(207) setdest 121168 14522 16.0" 
$ns at 849.235572850806 "$node_(207) setdest 57365 27290 6.0" 
$ns at 250.93396305447004 "$node_(208) setdest 76042 15188 4.0" 
$ns at 306.7642535074121 "$node_(208) setdest 25029 29749 8.0" 
$ns at 379.815454050411 "$node_(208) setdest 72264 38041 1.0" 
$ns at 412.94034056053215 "$node_(208) setdest 51376 10067 2.0" 
$ns at 443.7988166823711 "$node_(208) setdest 105826 14975 5.0" 
$ns at 517.3828723342219 "$node_(208) setdest 44912 4488 13.0" 
$ns at 621.5928874186626 "$node_(208) setdest 9329 36288 18.0" 
$ns at 654.1154512259493 "$node_(208) setdest 56548 31533 1.0" 
$ns at 687.1664116307749 "$node_(208) setdest 54492 12967 16.0" 
$ns at 746.5369774406795 "$node_(208) setdest 73521 6967 6.0" 
$ns at 827.7627935025898 "$node_(208) setdest 121593 33053 18.0" 
$ns at 218.83931256868635 "$node_(209) setdest 37150 5413 19.0" 
$ns at 264.96202863939976 "$node_(209) setdest 47920 26484 15.0" 
$ns at 421.7022949878263 "$node_(209) setdest 12999 37467 9.0" 
$ns at 539.7411727599687 "$node_(209) setdest 32734 43128 1.0" 
$ns at 578.7011018231574 "$node_(209) setdest 88325 26502 15.0" 
$ns at 627.7442258760855 "$node_(209) setdest 155 30723 18.0" 
$ns at 758.4306937744154 "$node_(209) setdest 35760 21404 20.0" 
$ns at 215.1701313954438 "$node_(210) setdest 127885 5323 1.0" 
$ns at 246.37641767970925 "$node_(210) setdest 121496 17490 18.0" 
$ns at 306.32604709635467 "$node_(210) setdest 91549 12074 10.0" 
$ns at 426.00831973671285 "$node_(210) setdest 81231 39068 12.0" 
$ns at 549.1454257450138 "$node_(210) setdest 17842 3095 11.0" 
$ns at 603.5670113322233 "$node_(210) setdest 15975 6735 3.0" 
$ns at 645.7621561668539 "$node_(210) setdest 33109 1392 19.0" 
$ns at 798.0472408594694 "$node_(210) setdest 97325 2078 9.0" 
$ns at 898.9072141039933 "$node_(210) setdest 21582 35121 19.0" 
$ns at 260.0922557230905 "$node_(211) setdest 90059 24847 12.0" 
$ns at 348.35022057228576 "$node_(211) setdest 1644 33720 7.0" 
$ns at 394.8168397322403 "$node_(211) setdest 7382 2532 1.0" 
$ns at 434.5305667566389 "$node_(211) setdest 120836 21081 11.0" 
$ns at 483.26060500744484 "$node_(211) setdest 86289 22499 20.0" 
$ns at 578.1801276449802 "$node_(211) setdest 64628 38682 15.0" 
$ns at 608.3310305661863 "$node_(211) setdest 66653 17917 16.0" 
$ns at 756.2717978262483 "$node_(211) setdest 2219 21520 12.0" 
$ns at 829.1170472926882 "$node_(211) setdest 38253 8298 9.0" 
$ns at 336.7527661244762 "$node_(212) setdest 58957 33217 13.0" 
$ns at 423.8792071981122 "$node_(212) setdest 15501 38812 13.0" 
$ns at 554.5510594730096 "$node_(212) setdest 20936 33204 8.0" 
$ns at 642.6464717302407 "$node_(212) setdest 38972 10489 3.0" 
$ns at 688.5727720243091 "$node_(212) setdest 107127 22145 16.0" 
$ns at 769.4691104555901 "$node_(212) setdest 39852 13940 1.0" 
$ns at 805.886252374187 "$node_(212) setdest 98982 9967 19.0" 
$ns at 275.6327355010883 "$node_(213) setdest 11641 26667 10.0" 
$ns at 373.39343838569675 "$node_(213) setdest 101760 2201 15.0" 
$ns at 479.76093683675606 "$node_(213) setdest 6753 34674 1.0" 
$ns at 510.0948035875653 "$node_(213) setdest 33599 18628 12.0" 
$ns at 628.049344356174 "$node_(213) setdest 70722 27204 5.0" 
$ns at 660.5794353653022 "$node_(213) setdest 61293 1150 19.0" 
$ns at 818.8726472150404 "$node_(213) setdest 109124 10354 16.0" 
$ns at 259.9587900427883 "$node_(214) setdest 61701 14101 13.0" 
$ns at 411.33240624686107 "$node_(214) setdest 119823 17470 1.0" 
$ns at 451.1021328941981 "$node_(214) setdest 99108 22884 15.0" 
$ns at 622.9225458942403 "$node_(214) setdest 67207 40811 17.0" 
$ns at 761.3571126755709 "$node_(214) setdest 97684 37022 14.0" 
$ns at 893.7341211113013 "$node_(214) setdest 96833 34088 11.0" 
$ns at 241.1128048308207 "$node_(215) setdest 24774 5460 9.0" 
$ns at 291.26866665897523 "$node_(215) setdest 9488 344 2.0" 
$ns at 334.5749125891918 "$node_(215) setdest 35046 7346 9.0" 
$ns at 433.1360531238654 "$node_(215) setdest 69570 35254 4.0" 
$ns at 484.85864097393335 "$node_(215) setdest 32112 36335 10.0" 
$ns at 534.9264279878024 "$node_(215) setdest 48931 39531 18.0" 
$ns at 699.9763225609623 "$node_(215) setdest 24329 2241 1.0" 
$ns at 735.0280655384147 "$node_(215) setdest 39778 15353 9.0" 
$ns at 805.110861578941 "$node_(215) setdest 1556 40478 6.0" 
$ns at 893.2785754407375 "$node_(215) setdest 22568 40190 2.0" 
$ns at 228.46108216753575 "$node_(216) setdest 31044 27294 12.0" 
$ns at 316.41626804977307 "$node_(216) setdest 129038 24371 8.0" 
$ns at 409.74541808594523 "$node_(216) setdest 105918 727 6.0" 
$ns at 485.8909845723372 "$node_(216) setdest 81540 27400 12.0" 
$ns at 587.6759899566116 "$node_(216) setdest 34556 8912 6.0" 
$ns at 650.4845737139913 "$node_(216) setdest 74626 21143 10.0" 
$ns at 711.3095474197335 "$node_(216) setdest 78494 22863 2.0" 
$ns at 749.1783826965077 "$node_(216) setdest 61234 24550 12.0" 
$ns at 789.8948482193407 "$node_(216) setdest 67774 30823 1.0" 
$ns at 824.2244745526202 "$node_(216) setdest 64286 40490 5.0" 
$ns at 866.3198698306751 "$node_(216) setdest 112623 21205 18.0" 
$ns at 317.5207974941778 "$node_(217) setdest 64283 31141 13.0" 
$ns at 476.3255113584099 "$node_(217) setdest 34987 10712 6.0" 
$ns at 533.3420922820231 "$node_(217) setdest 21431 35982 7.0" 
$ns at 622.2743631849389 "$node_(217) setdest 77453 31497 14.0" 
$ns at 700.3899398893913 "$node_(217) setdest 126558 28738 10.0" 
$ns at 768.8576903002767 "$node_(217) setdest 5810 39032 9.0" 
$ns at 856.8452098098928 "$node_(217) setdest 57038 12163 13.0" 
$ns at 200.08173192901415 "$node_(218) setdest 12349 38290 13.0" 
$ns at 291.300650777599 "$node_(218) setdest 121675 25044 12.0" 
$ns at 363.93234891386976 "$node_(218) setdest 73088 31155 5.0" 
$ns at 408.52387426043305 "$node_(218) setdest 61227 5808 10.0" 
$ns at 469.2180520936039 "$node_(218) setdest 115031 20952 2.0" 
$ns at 516.8834455087325 "$node_(218) setdest 5294 8674 3.0" 
$ns at 575.3604904859732 "$node_(218) setdest 9754 27802 16.0" 
$ns at 673.4344099283788 "$node_(218) setdest 6175 23816 9.0" 
$ns at 736.685182275761 "$node_(218) setdest 74889 17214 18.0" 
$ns at 284.1783005460335 "$node_(219) setdest 131214 35941 14.0" 
$ns at 388.863228831353 "$node_(219) setdest 82945 16383 8.0" 
$ns at 453.22902292751473 "$node_(219) setdest 112402 39462 1.0" 
$ns at 490.67407701653855 "$node_(219) setdest 124083 28611 2.0" 
$ns at 520.9813450081934 "$node_(219) setdest 29316 2725 5.0" 
$ns at 585.9463217783172 "$node_(219) setdest 22483 39230 10.0" 
$ns at 679.83057973736 "$node_(219) setdest 47530 22461 11.0" 
$ns at 800.2977551941575 "$node_(219) setdest 33478 29297 10.0" 
$ns at 843.6632974482841 "$node_(219) setdest 122053 10466 18.0" 
$ns at 217.68924592807494 "$node_(220) setdest 50654 10414 6.0" 
$ns at 284.0664780075416 "$node_(220) setdest 12969 19207 14.0" 
$ns at 399.10032603008045 "$node_(220) setdest 94591 25781 17.0" 
$ns at 492.8380882863279 "$node_(220) setdest 86751 36672 13.0" 
$ns at 553.654273974736 "$node_(220) setdest 35966 39340 3.0" 
$ns at 612.9276530218149 "$node_(220) setdest 133526 14789 3.0" 
$ns at 648.3547650274886 "$node_(220) setdest 33589 34807 2.0" 
$ns at 682.6603165119541 "$node_(220) setdest 133972 30866 5.0" 
$ns at 744.5360264288864 "$node_(220) setdest 17317 21335 12.0" 
$ns at 859.2787124141382 "$node_(220) setdest 13406 17607 18.0" 
$ns at 893.6556379046156 "$node_(220) setdest 54410 43364 10.0" 
$ns at 293.1381940566896 "$node_(221) setdest 42026 42895 2.0" 
$ns at 342.16376205031685 "$node_(221) setdest 28977 5238 16.0" 
$ns at 401.70157335556723 "$node_(221) setdest 87204 43017 3.0" 
$ns at 459.7376118753213 "$node_(221) setdest 44586 23695 14.0" 
$ns at 529.5324955557098 "$node_(221) setdest 8672 44648 15.0" 
$ns at 585.4956072636218 "$node_(221) setdest 105193 39457 10.0" 
$ns at 665.392522406473 "$node_(221) setdest 73167 35977 16.0" 
$ns at 755.6291216781253 "$node_(221) setdest 31446 16882 17.0" 
$ns at 787.6103160598875 "$node_(221) setdest 109754 33370 13.0" 
$ns at 898.2619960056544 "$node_(221) setdest 113633 22761 14.0" 
$ns at 220.8751854793932 "$node_(222) setdest 43822 25219 10.0" 
$ns at 293.80786689263516 "$node_(222) setdest 128870 22161 8.0" 
$ns at 375.7587478342416 "$node_(222) setdest 20344 32712 13.0" 
$ns at 421.5627954560955 "$node_(222) setdest 85460 9932 11.0" 
$ns at 519.1381042623622 "$node_(222) setdest 117 4096 6.0" 
$ns at 578.464826124732 "$node_(222) setdest 129790 38840 15.0" 
$ns at 725.3907914367774 "$node_(222) setdest 64900 34397 7.0" 
$ns at 780.0363120174964 "$node_(222) setdest 83677 7479 13.0" 
$ns at 296.82153823917895 "$node_(223) setdest 99806 37247 6.0" 
$ns at 332.56416373713574 "$node_(223) setdest 36429 11768 16.0" 
$ns at 522.2031639389888 "$node_(223) setdest 35002 23084 1.0" 
$ns at 561.8722111317919 "$node_(223) setdest 7876 8518 18.0" 
$ns at 722.2392778280044 "$node_(223) setdest 21219 38307 3.0" 
$ns at 756.2582976031165 "$node_(223) setdest 31117 21917 2.0" 
$ns at 797.4989535227363 "$node_(223) setdest 26425 20546 13.0" 
$ns at 876.1619914644103 "$node_(223) setdest 45172 35384 1.0" 
$ns at 240.43198540674337 "$node_(224) setdest 82981 21132 10.0" 
$ns at 327.3549126040498 "$node_(224) setdest 121431 4428 12.0" 
$ns at 367.80471502034635 "$node_(224) setdest 6525 14577 19.0" 
$ns at 470.79115936809154 "$node_(224) setdest 31818 24019 14.0" 
$ns at 501.7570931117262 "$node_(224) setdest 66478 6635 10.0" 
$ns at 578.9136240981416 "$node_(224) setdest 46215 32242 10.0" 
$ns at 675.4709349981925 "$node_(224) setdest 109085 1204 1.0" 
$ns at 713.1099867034343 "$node_(224) setdest 46582 6092 19.0" 
$ns at 313.50176141962237 "$node_(225) setdest 81687 31343 1.0" 
$ns at 352.2154882368446 "$node_(225) setdest 119422 10333 9.0" 
$ns at 417.679532951077 "$node_(225) setdest 105393 21584 12.0" 
$ns at 511.650203605913 "$node_(225) setdest 89209 26179 1.0" 
$ns at 546.2043806423453 "$node_(225) setdest 83726 38471 7.0" 
$ns at 583.8089450916798 "$node_(225) setdest 105458 41539 8.0" 
$ns at 620.9557341585746 "$node_(225) setdest 31612 16953 12.0" 
$ns at 748.7677508389888 "$node_(225) setdest 50495 40052 17.0" 
$ns at 869.9799666679478 "$node_(225) setdest 122223 19350 3.0" 
$ns at 244.1678247379551 "$node_(226) setdest 7291 29631 6.0" 
$ns at 325.3244608425931 "$node_(226) setdest 16489 43106 9.0" 
$ns at 440.3418275956367 "$node_(226) setdest 102240 6055 6.0" 
$ns at 520.134281844949 "$node_(226) setdest 2398 9158 1.0" 
$ns at 556.9930455954969 "$node_(226) setdest 1573 9997 15.0" 
$ns at 601.0514378214515 "$node_(226) setdest 132476 24313 2.0" 
$ns at 643.9522761184849 "$node_(226) setdest 130805 3658 9.0" 
$ns at 738.7368810776462 "$node_(226) setdest 81353 36646 17.0" 
$ns at 896.0120485654832 "$node_(226) setdest 121439 14853 5.0" 
$ns at 219.0913222658293 "$node_(227) setdest 19377 32432 7.0" 
$ns at 249.6622536683441 "$node_(227) setdest 49101 22413 16.0" 
$ns at 307.2175577763583 "$node_(227) setdest 71273 1549 15.0" 
$ns at 399.659884750312 "$node_(227) setdest 57420 18973 14.0" 
$ns at 527.4620458875814 "$node_(227) setdest 51337 14 18.0" 
$ns at 599.8522735177147 "$node_(227) setdest 79835 39194 6.0" 
$ns at 633.2570912275373 "$node_(227) setdest 104126 33456 17.0" 
$ns at 778.2815331261297 "$node_(227) setdest 116722 1218 11.0" 
$ns at 860.2156721243043 "$node_(227) setdest 107829 36648 6.0" 
$ns at 222.94881959414045 "$node_(228) setdest 32445 21300 5.0" 
$ns at 295.51914142059957 "$node_(228) setdest 45898 23561 19.0" 
$ns at 379.7098535389232 "$node_(228) setdest 90682 20373 17.0" 
$ns at 492.7951401117874 "$node_(228) setdest 18160 40950 10.0" 
$ns at 549.2795782066253 "$node_(228) setdest 84945 14587 19.0" 
$ns at 661.1337365106895 "$node_(228) setdest 94423 33264 19.0" 
$ns at 780.1929839004604 "$node_(228) setdest 106983 3121 8.0" 
$ns at 835.4116908071207 "$node_(228) setdest 106468 889 5.0" 
$ns at 898.3511854759442 "$node_(228) setdest 40149 25941 18.0" 
$ns at 286.6172564618547 "$node_(229) setdest 75525 42985 11.0" 
$ns at 353.8760862341224 "$node_(229) setdest 101616 41770 7.0" 
$ns at 404.3480077003606 "$node_(229) setdest 52747 17311 1.0" 
$ns at 438.2779687621466 "$node_(229) setdest 114464 27344 20.0" 
$ns at 580.2199858838771 "$node_(229) setdest 26257 32440 2.0" 
$ns at 616.3053922071656 "$node_(229) setdest 58849 38000 10.0" 
$ns at 702.3770473646548 "$node_(229) setdest 84368 23862 12.0" 
$ns at 823.1281488779878 "$node_(229) setdest 63133 31282 8.0" 
$ns at 262.0345517536222 "$node_(230) setdest 83360 38952 18.0" 
$ns at 395.2818673218469 "$node_(230) setdest 54860 33669 9.0" 
$ns at 464.7653604958881 "$node_(230) setdest 67128 490 2.0" 
$ns at 510.7272232534581 "$node_(230) setdest 118053 35904 10.0" 
$ns at 552.0649778419693 "$node_(230) setdest 74921 1304 12.0" 
$ns at 679.7838910767988 "$node_(230) setdest 60880 20478 20.0" 
$ns at 808.2685805315169 "$node_(230) setdest 28484 5515 14.0" 
$ns at 220.53901008153179 "$node_(231) setdest 116977 22364 14.0" 
$ns at 323.77858679959206 "$node_(231) setdest 46880 6783 8.0" 
$ns at 415.373368256594 "$node_(231) setdest 60064 15817 9.0" 
$ns at 476.52164132559835 "$node_(231) setdest 69285 26124 4.0" 
$ns at 509.1618396842539 "$node_(231) setdest 2572 22994 7.0" 
$ns at 585.1181267787133 "$node_(231) setdest 27971 35927 18.0" 
$ns at 702.9132857633003 "$node_(231) setdest 94886 31245 19.0" 
$ns at 746.6739024529803 "$node_(231) setdest 21270 23016 4.0" 
$ns at 787.0201603468163 "$node_(231) setdest 128178 30448 17.0" 
$ns at 834.1467194666257 "$node_(231) setdest 109501 35955 6.0" 
$ns at 870.6439458217362 "$node_(231) setdest 84939 5002 4.0" 
$ns at 231.92733730717242 "$node_(232) setdest 73354 19198 14.0" 
$ns at 379.53615908931596 "$node_(232) setdest 115208 27658 12.0" 
$ns at 511.98697251219625 "$node_(232) setdest 116316 4701 13.0" 
$ns at 649.843371408708 "$node_(232) setdest 118511 41332 16.0" 
$ns at 753.179880487256 "$node_(232) setdest 25334 2177 9.0" 
$ns at 840.3520513466327 "$node_(232) setdest 32357 33405 15.0" 
$ns at 255.56831568390496 "$node_(233) setdest 95838 40487 3.0" 
$ns at 293.6069678765373 "$node_(233) setdest 7307 39478 9.0" 
$ns at 349.2822485099518 "$node_(233) setdest 121962 31450 4.0" 
$ns at 388.6815337777915 "$node_(233) setdest 88081 16747 2.0" 
$ns at 424.4249962927599 "$node_(233) setdest 55559 34614 3.0" 
$ns at 469.90754571787284 "$node_(233) setdest 59070 20104 2.0" 
$ns at 518.1773865711527 "$node_(233) setdest 114536 8197 9.0" 
$ns at 614.3004631647282 "$node_(233) setdest 84678 39281 15.0" 
$ns at 719.8143494527076 "$node_(233) setdest 72325 23529 7.0" 
$ns at 760.678149476092 "$node_(233) setdest 33818 16504 9.0" 
$ns at 845.4444332350901 "$node_(233) setdest 55869 39653 16.0" 
$ns at 311.26925442285983 "$node_(234) setdest 19626 11085 12.0" 
$ns at 346.4234235045306 "$node_(234) setdest 32841 31804 13.0" 
$ns at 478.96408756249645 "$node_(234) setdest 108062 18805 16.0" 
$ns at 649.4302225022076 "$node_(234) setdest 40995 13871 17.0" 
$ns at 803.4382170811955 "$node_(234) setdest 10051 14597 11.0" 
$ns at 853.8991044218301 "$node_(234) setdest 118687 120 12.0" 
$ns at 339.19869739641524 "$node_(235) setdest 54921 2882 2.0" 
$ns at 378.45626373487806 "$node_(235) setdest 69729 32802 2.0" 
$ns at 418.69117324682156 "$node_(235) setdest 75631 13688 8.0" 
$ns at 454.6433009916473 "$node_(235) setdest 33208 10677 9.0" 
$ns at 560.3346067108005 "$node_(235) setdest 125016 34994 8.0" 
$ns at 613.409388104823 "$node_(235) setdest 104874 36594 19.0" 
$ns at 828.2752326607183 "$node_(235) setdest 130046 27206 5.0" 
$ns at 877.1202698931888 "$node_(235) setdest 62803 23241 20.0" 
$ns at 215.60701511622455 "$node_(236) setdest 83518 5338 6.0" 
$ns at 252.9582258557948 "$node_(236) setdest 119902 43598 10.0" 
$ns at 351.2831568582096 "$node_(236) setdest 119313 31983 13.0" 
$ns at 457.78046221229823 "$node_(236) setdest 117408 43792 11.0" 
$ns at 545.0517756437409 "$node_(236) setdest 97483 30296 15.0" 
$ns at 596.9583784972954 "$node_(236) setdest 36255 34872 14.0" 
$ns at 720.3870096420011 "$node_(236) setdest 104059 22081 13.0" 
$ns at 871.4362796733402 "$node_(236) setdest 122044 22218 14.0" 
$ns at 298.19511775111766 "$node_(237) setdest 115107 12505 16.0" 
$ns at 339.28552783117493 "$node_(237) setdest 17878 25626 5.0" 
$ns at 395.4829529992217 "$node_(237) setdest 34520 23728 1.0" 
$ns at 434.9082350919433 "$node_(237) setdest 14875 16888 16.0" 
$ns at 614.784570694235 "$node_(237) setdest 93070 13790 14.0" 
$ns at 691.7021908384986 "$node_(237) setdest 115362 37948 5.0" 
$ns at 761.648437105843 "$node_(237) setdest 17081 33058 13.0" 
$ns at 836.1951982303343 "$node_(237) setdest 45924 36999 8.0" 
$ns at 894.8177702318852 "$node_(237) setdest 48156 37441 18.0" 
$ns at 255.829156749915 "$node_(238) setdest 103266 25547 15.0" 
$ns at 332.28263331903116 "$node_(238) setdest 116407 17108 19.0" 
$ns at 420.5131317839402 "$node_(238) setdest 79713 22255 10.0" 
$ns at 517.2108244271053 "$node_(238) setdest 20183 27352 8.0" 
$ns at 617.2466618115021 "$node_(238) setdest 57689 1462 14.0" 
$ns at 714.695909106539 "$node_(238) setdest 30193 14545 9.0" 
$ns at 817.128401130757 "$node_(238) setdest 63617 32172 20.0" 
$ns at 262.09838679554224 "$node_(239) setdest 46308 26644 11.0" 
$ns at 355.50264079662793 "$node_(239) setdest 13987 30112 15.0" 
$ns at 386.23467525199993 "$node_(239) setdest 19234 13093 17.0" 
$ns at 481.1794240209198 "$node_(239) setdest 17886 19798 16.0" 
$ns at 541.0983719819978 "$node_(239) setdest 49064 28253 1.0" 
$ns at 571.9443888582318 "$node_(239) setdest 42772 17581 20.0" 
$ns at 659.641010224372 "$node_(239) setdest 44556 13120 11.0" 
$ns at 692.4025804098478 "$node_(239) setdest 25307 17005 10.0" 
$ns at 779.065988373708 "$node_(239) setdest 84259 44041 18.0" 
$ns at 214.59303896347873 "$node_(240) setdest 56369 115 16.0" 
$ns at 335.82914537106717 "$node_(240) setdest 97915 17772 10.0" 
$ns at 456.49345980372226 "$node_(240) setdest 131604 33628 9.0" 
$ns at 569.4772208961202 "$node_(240) setdest 87126 31646 17.0" 
$ns at 712.8683044474353 "$node_(240) setdest 9386 39093 7.0" 
$ns at 756.9383525517053 "$node_(240) setdest 113685 13838 14.0" 
$ns at 856.7527774711652 "$node_(240) setdest 13654 38684 14.0" 
$ns at 306.1196582432391 "$node_(241) setdest 10234 7302 9.0" 
$ns at 425.7640223447711 "$node_(241) setdest 62218 103 14.0" 
$ns at 481.5641944766406 "$node_(241) setdest 79538 37583 15.0" 
$ns at 592.4651072227165 "$node_(241) setdest 41711 7758 6.0" 
$ns at 654.5072452923805 "$node_(241) setdest 66702 15175 13.0" 
$ns at 723.4853765075326 "$node_(241) setdest 33929 14490 16.0" 
$ns at 754.7268576860021 "$node_(241) setdest 8987 43146 16.0" 
$ns at 889.5894941148728 "$node_(241) setdest 2754 7585 17.0" 
$ns at 286.4998607598686 "$node_(242) setdest 125184 32282 1.0" 
$ns at 316.79838199596367 "$node_(242) setdest 47318 25530 10.0" 
$ns at 438.58871216699526 "$node_(242) setdest 5770 16292 14.0" 
$ns at 503.2145527358893 "$node_(242) setdest 76213 6167 14.0" 
$ns at 661.4721005056882 "$node_(242) setdest 74061 4408 7.0" 
$ns at 702.9070399832663 "$node_(242) setdest 103631 27129 19.0" 
$ns at 844.671892954196 "$node_(242) setdest 133323 781 16.0" 
$ns at 201.63050399394598 "$node_(243) setdest 28733 43493 19.0" 
$ns at 314.4957627447445 "$node_(243) setdest 73775 31446 4.0" 
$ns at 351.0045298455272 "$node_(243) setdest 115237 24458 1.0" 
$ns at 389.5741447065862 "$node_(243) setdest 132925 40287 13.0" 
$ns at 435.8149299609628 "$node_(243) setdest 92748 41503 14.0" 
$ns at 467.4082192700247 "$node_(243) setdest 48053 37349 12.0" 
$ns at 578.0241731495332 "$node_(243) setdest 127955 22961 19.0" 
$ns at 724.7059498267322 "$node_(243) setdest 16907 14752 1.0" 
$ns at 756.9178809749399 "$node_(243) setdest 79533 38828 1.0" 
$ns at 789.2280810800664 "$node_(243) setdest 101254 26288 7.0" 
$ns at 852.3759794119077 "$node_(243) setdest 43107 31053 14.0" 
$ns at 233.35893805088966 "$node_(244) setdest 57133 9510 11.0" 
$ns at 302.19077052433585 "$node_(244) setdest 63666 4502 5.0" 
$ns at 379.8774599627633 "$node_(244) setdest 32155 24930 5.0" 
$ns at 428.5510205593839 "$node_(244) setdest 8177 3472 16.0" 
$ns at 473.95127059588617 "$node_(244) setdest 5557 34686 12.0" 
$ns at 570.1449558981682 "$node_(244) setdest 92954 35031 1.0" 
$ns at 602.4035744286791 "$node_(244) setdest 46726 10737 16.0" 
$ns at 634.6800912804251 "$node_(244) setdest 83396 11507 19.0" 
$ns at 839.2150699812992 "$node_(244) setdest 106280 26778 15.0" 
$ns at 869.972595181131 "$node_(244) setdest 66812 14685 17.0" 
$ns at 349.89498045914263 "$node_(245) setdest 126275 33518 10.0" 
$ns at 402.71858241930045 "$node_(245) setdest 87711 13277 19.0" 
$ns at 546.4713621380643 "$node_(245) setdest 11110 12444 8.0" 
$ns at 588.3289847090591 "$node_(245) setdest 20299 6450 9.0" 
$ns at 676.2654546666772 "$node_(245) setdest 100450 25942 4.0" 
$ns at 728.737840418863 "$node_(245) setdest 84249 10531 13.0" 
$ns at 847.8173883056847 "$node_(245) setdest 45052 32449 16.0" 
$ns at 263.91635693060266 "$node_(246) setdest 476 39241 18.0" 
$ns at 366.9748526437239 "$node_(246) setdest 132572 43647 20.0" 
$ns at 451.8700893721616 "$node_(246) setdest 5382 43798 10.0" 
$ns at 507.4952090940135 "$node_(246) setdest 16465 38799 11.0" 
$ns at 544.240884990085 "$node_(246) setdest 43003 11814 12.0" 
$ns at 659.6697645966627 "$node_(246) setdest 65862 2316 18.0" 
$ns at 805.6182151440424 "$node_(246) setdest 85853 21210 13.0" 
$ns at 266.09295800018657 "$node_(247) setdest 111527 41297 1.0" 
$ns at 305.9960215916884 "$node_(247) setdest 70843 38309 20.0" 
$ns at 445.7689879739959 "$node_(247) setdest 80153 14278 8.0" 
$ns at 511.01570745432696 "$node_(247) setdest 121414 2102 7.0" 
$ns at 580.3224607709791 "$node_(247) setdest 17249 36563 17.0" 
$ns at 685.0505571072005 "$node_(247) setdest 16720 29282 1.0" 
$ns at 721.8830363969766 "$node_(247) setdest 119944 27456 15.0" 
$ns at 765.8154607852151 "$node_(247) setdest 122884 35873 2.0" 
$ns at 798.2351613734756 "$node_(247) setdest 112839 11963 10.0" 
$ns at 261.73255953880096 "$node_(248) setdest 69683 33735 12.0" 
$ns at 343.8333970855732 "$node_(248) setdest 85759 6636 17.0" 
$ns at 374.00101954026826 "$node_(248) setdest 82462 35586 8.0" 
$ns at 437.7265182138722 "$node_(248) setdest 3825 16401 15.0" 
$ns at 566.1135761384476 "$node_(248) setdest 94670 7817 19.0" 
$ns at 691.1695759509237 "$node_(248) setdest 94808 12815 4.0" 
$ns at 749.7375027042788 "$node_(248) setdest 71959 42179 10.0" 
$ns at 811.7828524006425 "$node_(248) setdest 124623 39856 10.0" 
$ns at 269.1078524574687 "$node_(249) setdest 20026 32201 15.0" 
$ns at 325.61263117203526 "$node_(249) setdest 93514 27399 4.0" 
$ns at 394.97277648987256 "$node_(249) setdest 50740 23266 12.0" 
$ns at 524.3365365151312 "$node_(249) setdest 66484 39629 7.0" 
$ns at 587.8525320487154 "$node_(249) setdest 107729 1308 8.0" 
$ns at 666.1983116901876 "$node_(249) setdest 126418 17288 1.0" 
$ns at 700.5234940968771 "$node_(249) setdest 50671 23900 19.0" 
$ns at 809.2752123685094 "$node_(249) setdest 126377 42073 16.0" 
$ns at 864.2132260907996 "$node_(249) setdest 119918 19853 2.0" 
$ns at 209.0540945250862 "$node_(250) setdest 133833 29092 20.0" 
$ns at 385.59348542790207 "$node_(250) setdest 44044 19419 6.0" 
$ns at 429.5973122969238 "$node_(250) setdest 28721 5223 1.0" 
$ns at 464.7055924909376 "$node_(250) setdest 57603 20200 5.0" 
$ns at 525.1759806913556 "$node_(250) setdest 87207 31909 4.0" 
$ns at 574.0890381346579 "$node_(250) setdest 4264 26642 10.0" 
$ns at 685.2149466890216 "$node_(250) setdest 36257 16826 7.0" 
$ns at 777.9854961627798 "$node_(250) setdest 21881 2745 6.0" 
$ns at 820.1499855281888 "$node_(250) setdest 35323 13146 19.0" 
$ns at 230.37583213831698 "$node_(251) setdest 52685 39442 5.0" 
$ns at 266.31524969287767 "$node_(251) setdest 39203 10322 3.0" 
$ns at 304.9366956859084 "$node_(251) setdest 67361 38281 13.0" 
$ns at 390.83714134631396 "$node_(251) setdest 86067 39382 15.0" 
$ns at 421.85294951853314 "$node_(251) setdest 41679 26738 6.0" 
$ns at 506.6281978872313 "$node_(251) setdest 107295 22439 5.0" 
$ns at 546.1960482001596 "$node_(251) setdest 133443 16805 13.0" 
$ns at 638.6005743966775 "$node_(251) setdest 75626 14135 17.0" 
$ns at 781.8163781676142 "$node_(251) setdest 115167 29973 7.0" 
$ns at 866.2298915308851 "$node_(251) setdest 29001 6135 4.0" 
$ns at 282.4325777978081 "$node_(252) setdest 29719 27072 9.0" 
$ns at 316.0827998062538 "$node_(252) setdest 61133 4976 19.0" 
$ns at 511.39173690700784 "$node_(252) setdest 124839 42962 13.0" 
$ns at 590.0214421802596 "$node_(252) setdest 95459 34145 3.0" 
$ns at 621.7576412438972 "$node_(252) setdest 20154 39525 4.0" 
$ns at 654.6035068807496 "$node_(252) setdest 54875 30893 3.0" 
$ns at 700.5633656696554 "$node_(252) setdest 88622 10823 18.0" 
$ns at 740.1863509055679 "$node_(252) setdest 35635 37803 18.0" 
$ns at 843.3448287414514 "$node_(252) setdest 48780 3761 7.0" 
$ns at 897.3900692222069 "$node_(252) setdest 46372 8271 13.0" 
$ns at 235.2303200591275 "$node_(253) setdest 82205 7727 11.0" 
$ns at 305.4831930827402 "$node_(253) setdest 121820 12625 1.0" 
$ns at 335.65698204330886 "$node_(253) setdest 125173 29988 18.0" 
$ns at 386.6367822590251 "$node_(253) setdest 128939 33167 3.0" 
$ns at 442.6713338422595 "$node_(253) setdest 49738 13333 12.0" 
$ns at 568.2988954949126 "$node_(253) setdest 46513 5870 5.0" 
$ns at 611.3961631897039 "$node_(253) setdest 107108 13352 6.0" 
$ns at 659.5949256208576 "$node_(253) setdest 121336 354 3.0" 
$ns at 690.6236893573956 "$node_(253) setdest 55793 22707 13.0" 
$ns at 812.8910537319096 "$node_(253) setdest 64335 956 20.0" 
$ns at 882.9522163908308 "$node_(253) setdest 37580 24909 7.0" 
$ns at 219.87012069665604 "$node_(254) setdest 31251 29323 6.0" 
$ns at 260.8217285547971 "$node_(254) setdest 10111 42036 2.0" 
$ns at 310.71721677560106 "$node_(254) setdest 37655 27765 9.0" 
$ns at 358.1312222518095 "$node_(254) setdest 100920 12359 4.0" 
$ns at 408.38019388745107 "$node_(254) setdest 67891 37170 15.0" 
$ns at 575.346897513768 "$node_(254) setdest 21221 863 6.0" 
$ns at 629.2813774132117 "$node_(254) setdest 10159 3639 12.0" 
$ns at 754.904399844299 "$node_(254) setdest 26750 25680 14.0" 
$ns at 887.020074802296 "$node_(254) setdest 128428 37530 19.0" 
$ns at 232.65815128979983 "$node_(255) setdest 108100 4598 4.0" 
$ns at 283.84918561863515 "$node_(255) setdest 40138 36275 4.0" 
$ns at 344.5307944001153 "$node_(255) setdest 62881 8106 2.0" 
$ns at 393.65597585351384 "$node_(255) setdest 11199 27577 9.0" 
$ns at 456.0814956704603 "$node_(255) setdest 79917 27099 1.0" 
$ns at 487.26296182530984 "$node_(255) setdest 37198 43522 8.0" 
$ns at 596.3080799900455 "$node_(255) setdest 34122 26357 3.0" 
$ns at 633.2905913903899 "$node_(255) setdest 109083 16788 19.0" 
$ns at 680.1266721472475 "$node_(255) setdest 98188 36385 4.0" 
$ns at 734.1741233292488 "$node_(255) setdest 91231 32606 18.0" 
$ns at 873.3082568101559 "$node_(255) setdest 122835 35913 19.0" 
$ns at 226.1553512551963 "$node_(256) setdest 105874 33554 6.0" 
$ns at 304.33253685524244 "$node_(256) setdest 65429 10333 7.0" 
$ns at 354.8097279030057 "$node_(256) setdest 65863 18135 4.0" 
$ns at 416.4556637757295 "$node_(256) setdest 1836 25236 1.0" 
$ns at 449.31216033898636 "$node_(256) setdest 52868 22363 8.0" 
$ns at 534.7413541590595 "$node_(256) setdest 40121 11270 16.0" 
$ns at 683.4180709848752 "$node_(256) setdest 68949 3733 7.0" 
$ns at 718.2615643191093 "$node_(256) setdest 63952 7553 19.0" 
$ns at 835.986168976498 "$node_(256) setdest 105510 1850 14.0" 
$ns at 202.06767526918765 "$node_(257) setdest 49825 2255 12.0" 
$ns at 325.23166944581754 "$node_(257) setdest 35218 25265 10.0" 
$ns at 387.5396271491676 "$node_(257) setdest 32957 43656 3.0" 
$ns at 444.2335109450787 "$node_(257) setdest 91168 30530 16.0" 
$ns at 621.2482529038324 "$node_(257) setdest 90166 6540 12.0" 
$ns at 740.1741180246105 "$node_(257) setdest 49368 33602 6.0" 
$ns at 805.9281741713028 "$node_(257) setdest 77892 42519 9.0" 
$ns at 862.1300009865754 "$node_(257) setdest 73843 17320 17.0" 
$ns at 286.94074527504074 "$node_(258) setdest 20175 32071 17.0" 
$ns at 354.4629589104641 "$node_(258) setdest 55812 33045 17.0" 
$ns at 425.33937600982864 "$node_(258) setdest 131311 21014 4.0" 
$ns at 460.2720922102576 "$node_(258) setdest 51330 29454 9.0" 
$ns at 579.2657739187697 "$node_(258) setdest 110256 2966 11.0" 
$ns at 708.4833445627021 "$node_(258) setdest 109275 14455 4.0" 
$ns at 745.0955461814332 "$node_(258) setdest 25725 9582 19.0" 
$ns at 801.6130102517996 "$node_(258) setdest 52947 28238 3.0" 
$ns at 852.8465726489372 "$node_(258) setdest 131869 26755 9.0" 
$ns at 893.5535986899022 "$node_(258) setdest 10231 4388 12.0" 
$ns at 242.7305802525177 "$node_(259) setdest 73855 10072 7.0" 
$ns at 279.6364582297754 "$node_(259) setdest 11602 25226 12.0" 
$ns at 361.43692762640785 "$node_(259) setdest 18964 38751 5.0" 
$ns at 408.4946901556699 "$node_(259) setdest 79532 43445 16.0" 
$ns at 577.8269757368935 "$node_(259) setdest 101326 44119 9.0" 
$ns at 641.1484112008975 "$node_(259) setdest 80814 27897 3.0" 
$ns at 699.3908265434436 "$node_(259) setdest 132701 23776 20.0" 
$ns at 829.2809392436677 "$node_(259) setdest 12168 19846 1.0" 
$ns at 869.1732205491195 "$node_(259) setdest 117280 14427 12.0" 
$ns at 226.5752711522304 "$node_(260) setdest 10306 22906 12.0" 
$ns at 305.61044928147294 "$node_(260) setdest 82460 10426 11.0" 
$ns at 420.2185612208681 "$node_(260) setdest 55445 16910 10.0" 
$ns at 544.2700057397192 "$node_(260) setdest 17759 9204 19.0" 
$ns at 583.6484324053536 "$node_(260) setdest 28804 2190 3.0" 
$ns at 635.0591281572355 "$node_(260) setdest 29857 13239 12.0" 
$ns at 726.7545743311807 "$node_(260) setdest 117819 23755 9.0" 
$ns at 843.2538849684132 "$node_(260) setdest 66429 21270 19.0" 
$ns at 214.1138123198084 "$node_(261) setdest 89384 10387 5.0" 
$ns at 250.36134258127274 "$node_(261) setdest 78131 15015 17.0" 
$ns at 444.41523386305437 "$node_(261) setdest 8445 7600 7.0" 
$ns at 534.0330577986651 "$node_(261) setdest 95875 8852 7.0" 
$ns at 583.8549741657876 "$node_(261) setdest 84732 3284 11.0" 
$ns at 723.0096331028203 "$node_(261) setdest 10601 16996 4.0" 
$ns at 767.9549302009771 "$node_(261) setdest 84386 36054 19.0" 
$ns at 250.62259188630713 "$node_(262) setdest 24954 19432 3.0" 
$ns at 282.58264350649273 "$node_(262) setdest 119723 26632 6.0" 
$ns at 365.2389041247116 "$node_(262) setdest 100336 33897 8.0" 
$ns at 406.6261391606954 "$node_(262) setdest 44322 35234 5.0" 
$ns at 482.0853478095131 "$node_(262) setdest 79137 35158 9.0" 
$ns at 593.2919935212495 "$node_(262) setdest 49126 6542 5.0" 
$ns at 630.5268382903336 "$node_(262) setdest 26069 19585 7.0" 
$ns at 694.9849278270605 "$node_(262) setdest 43846 8470 10.0" 
$ns at 788.5939196551857 "$node_(262) setdest 4266 34785 17.0" 
$ns at 856.4848457542607 "$node_(262) setdest 35156 41637 10.0" 
$ns at 204.71485149509732 "$node_(263) setdest 112011 35851 5.0" 
$ns at 274.45926118641694 "$node_(263) setdest 2121 11279 7.0" 
$ns at 349.7421882310388 "$node_(263) setdest 59032 27375 6.0" 
$ns at 394.712851601344 "$node_(263) setdest 106227 18552 4.0" 
$ns at 456.46984079065743 "$node_(263) setdest 31645 33814 10.0" 
$ns at 541.1401414618945 "$node_(263) setdest 35071 36017 13.0" 
$ns at 580.9075916559029 "$node_(263) setdest 28212 22644 6.0" 
$ns at 635.9534553225021 "$node_(263) setdest 106685 23093 9.0" 
$ns at 677.1743510917037 "$node_(263) setdest 110476 26971 8.0" 
$ns at 765.0542122613618 "$node_(263) setdest 21490 1854 2.0" 
$ns at 803.5896144126635 "$node_(263) setdest 92332 1656 18.0" 
$ns at 227.53399291627215 "$node_(264) setdest 32623 6685 12.0" 
$ns at 349.71981150216493 "$node_(264) setdest 13215 42650 11.0" 
$ns at 448.9054346044891 "$node_(264) setdest 83147 33064 7.0" 
$ns at 489.2229581577121 "$node_(264) setdest 29268 13171 15.0" 
$ns at 634.1833980903377 "$node_(264) setdest 27533 18689 14.0" 
$ns at 678.4083881153596 "$node_(264) setdest 118654 35167 11.0" 
$ns at 805.1490959925002 "$node_(264) setdest 73686 23258 12.0" 
$ns at 844.6318652724327 "$node_(264) setdest 30229 39286 7.0" 
$ns at 250.59922045266654 "$node_(265) setdest 43879 37277 3.0" 
$ns at 286.10283163999446 "$node_(265) setdest 102664 9229 6.0" 
$ns at 364.7396762765534 "$node_(265) setdest 839 21961 12.0" 
$ns at 433.0272679685022 "$node_(265) setdest 133316 25876 11.0" 
$ns at 491.62561604869353 "$node_(265) setdest 71303 37778 3.0" 
$ns at 540.6489874135954 "$node_(265) setdest 69463 14584 15.0" 
$ns at 591.1896042111049 "$node_(265) setdest 49008 30645 5.0" 
$ns at 634.7013620812484 "$node_(265) setdest 20274 19279 19.0" 
$ns at 775.9806202421279 "$node_(265) setdest 106338 27907 1.0" 
$ns at 806.4021664522235 "$node_(265) setdest 27959 9549 4.0" 
$ns at 869.6186596450125 "$node_(265) setdest 132824 10375 19.0" 
$ns at 208.9989139757858 "$node_(266) setdest 32649 21466 8.0" 
$ns at 309.24617640128196 "$node_(266) setdest 99969 21130 3.0" 
$ns at 363.64154208049393 "$node_(266) setdest 50365 21776 16.0" 
$ns at 542.9592178631425 "$node_(266) setdest 50852 14680 3.0" 
$ns at 601.2400096979319 "$node_(266) setdest 90795 42190 18.0" 
$ns at 662.4664155970372 "$node_(266) setdest 93728 3911 17.0" 
$ns at 822.743371299754 "$node_(266) setdest 70265 919 5.0" 
$ns at 887.4948153696631 "$node_(266) setdest 49570 35982 7.0" 
$ns at 224.41192513584997 "$node_(267) setdest 78281 37755 13.0" 
$ns at 373.0361416584547 "$node_(267) setdest 125717 12222 2.0" 
$ns at 403.7187343040597 "$node_(267) setdest 76570 26328 1.0" 
$ns at 442.0547607507865 "$node_(267) setdest 31587 42658 4.0" 
$ns at 477.44396069843384 "$node_(267) setdest 21239 10201 19.0" 
$ns at 659.2654837332794 "$node_(267) setdest 72717 9002 20.0" 
$ns at 877.9255799821028 "$node_(267) setdest 126099 38960 12.0" 
$ns at 222.17466137589014 "$node_(268) setdest 88776 23530 14.0" 
$ns at 366.2770639711591 "$node_(268) setdest 43542 34419 6.0" 
$ns at 434.91127132976146 "$node_(268) setdest 66804 25491 18.0" 
$ns at 636.6232558734334 "$node_(268) setdest 88369 36816 1.0" 
$ns at 668.7567914970701 "$node_(268) setdest 59565 17836 11.0" 
$ns at 723.9398113461092 "$node_(268) setdest 100357 37766 15.0" 
$ns at 815.141816908517 "$node_(268) setdest 52069 7004 12.0" 
$ns at 222.05106627352217 "$node_(269) setdest 43307 10920 18.0" 
$ns at 408.81078318853025 "$node_(269) setdest 26820 12045 19.0" 
$ns at 622.5645125405712 "$node_(269) setdest 77581 27888 18.0" 
$ns at 800.9900593977025 "$node_(269) setdest 16458 28619 1.0" 
$ns at 839.8456853651574 "$node_(269) setdest 132338 3208 10.0" 
$ns at 236.74519993039007 "$node_(270) setdest 100903 12294 13.0" 
$ns at 271.8650378964556 "$node_(270) setdest 40699 7101 2.0" 
$ns at 308.55034797903176 "$node_(270) setdest 78347 7419 13.0" 
$ns at 442.95694701564395 "$node_(270) setdest 31041 34691 13.0" 
$ns at 550.6436799545431 "$node_(270) setdest 27026 41107 6.0" 
$ns at 621.5139995883319 "$node_(270) setdest 111253 16915 13.0" 
$ns at 665.6856739210533 "$node_(270) setdest 30565 9175 5.0" 
$ns at 720.1741162607639 "$node_(270) setdest 23494 18236 14.0" 
$ns at 840.2644876139564 "$node_(270) setdest 44370 15475 16.0" 
$ns at 284.9565907014439 "$node_(271) setdest 41014 31449 15.0" 
$ns at 343.3046667376416 "$node_(271) setdest 33799 13568 12.0" 
$ns at 450.835591011036 "$node_(271) setdest 30690 40322 13.0" 
$ns at 590.6387706205214 "$node_(271) setdest 105247 8358 16.0" 
$ns at 739.5489876047175 "$node_(271) setdest 25554 25203 15.0" 
$ns at 788.9830718198215 "$node_(271) setdest 76843 42618 1.0" 
$ns at 823.1377590021924 "$node_(271) setdest 70084 5029 1.0" 
$ns at 857.5329236523726 "$node_(271) setdest 3110 22697 8.0" 
$ns at 206.21202706339375 "$node_(272) setdest 20913 41985 13.0" 
$ns at 240.19609702144976 "$node_(272) setdest 94986 32416 13.0" 
$ns at 313.2568649178643 "$node_(272) setdest 3132 21405 5.0" 
$ns at 347.8174215106892 "$node_(272) setdest 1336 6786 5.0" 
$ns at 383.68382231464204 "$node_(272) setdest 52795 7112 15.0" 
$ns at 478.68903688692393 "$node_(272) setdest 58421 26475 8.0" 
$ns at 539.1166979524639 "$node_(272) setdest 125080 38198 13.0" 
$ns at 672.7377658282786 "$node_(272) setdest 52088 39961 11.0" 
$ns at 713.7018026407272 "$node_(272) setdest 93269 7101 3.0" 
$ns at 773.1504538605204 "$node_(272) setdest 474 22797 17.0" 
$ns at 805.8947971402513 "$node_(272) setdest 96778 25870 17.0" 
$ns at 319.3618443088553 "$node_(273) setdest 37461 13808 19.0" 
$ns at 354.43802636854826 "$node_(273) setdest 80832 34770 12.0" 
$ns at 385.1180417257957 "$node_(273) setdest 84648 21992 1.0" 
$ns at 418.3867510676502 "$node_(273) setdest 2808 32690 7.0" 
$ns at 514.4771885501843 "$node_(273) setdest 85486 17527 17.0" 
$ns at 575.9623574390978 "$node_(273) setdest 123343 21978 16.0" 
$ns at 700.9222900596468 "$node_(273) setdest 52029 18854 19.0" 
$ns at 891.48952801779 "$node_(273) setdest 1157 3835 1.0" 
$ns at 288.3256537761466 "$node_(274) setdest 40823 44586 2.0" 
$ns at 333.3662153853761 "$node_(274) setdest 44946 30543 15.0" 
$ns at 435.7701969664539 "$node_(274) setdest 39275 38625 7.0" 
$ns at 476.95275796522765 "$node_(274) setdest 127965 1211 10.0" 
$ns at 525.7530593656705 "$node_(274) setdest 64596 7263 13.0" 
$ns at 631.7537564800394 "$node_(274) setdest 65128 20431 6.0" 
$ns at 718.5334487533954 "$node_(274) setdest 67602 31342 5.0" 
$ns at 758.2061474141917 "$node_(274) setdest 112498 3426 2.0" 
$ns at 801.0613703099 "$node_(274) setdest 78317 7762 19.0" 
$ns at 222.05485588233125 "$node_(275) setdest 39035 881 13.0" 
$ns at 295.30802085759365 "$node_(275) setdest 119744 7545 20.0" 
$ns at 407.18230203695987 "$node_(275) setdest 35530 36089 17.0" 
$ns at 515.1865612324946 "$node_(275) setdest 3274 621 2.0" 
$ns at 559.4811912035747 "$node_(275) setdest 121569 10863 9.0" 
$ns at 672.7892986402193 "$node_(275) setdest 3646 15617 3.0" 
$ns at 715.6041761008831 "$node_(275) setdest 60156 36600 14.0" 
$ns at 823.5426259486118 "$node_(275) setdest 111220 14455 1.0" 
$ns at 862.5413700175991 "$node_(275) setdest 114207 27826 10.0" 
$ns at 210.30069050298295 "$node_(276) setdest 116115 23569 9.0" 
$ns at 321.62993964476163 "$node_(276) setdest 57229 24432 7.0" 
$ns at 393.2098883903507 "$node_(276) setdest 119100 17108 11.0" 
$ns at 518.1571475287601 "$node_(276) setdest 120555 35515 12.0" 
$ns at 648.6625394114405 "$node_(276) setdest 6164 43576 6.0" 
$ns at 697.8432309535148 "$node_(276) setdest 95070 29985 13.0" 
$ns at 742.1780952169731 "$node_(276) setdest 50889 3460 1.0" 
$ns at 775.1225186994917 "$node_(276) setdest 50537 16137 4.0" 
$ns at 809.069915445773 "$node_(276) setdest 71134 26058 1.0" 
$ns at 842.0415925245164 "$node_(276) setdest 132706 39202 13.0" 
$ns at 894.7212851203495 "$node_(276) setdest 104610 42670 3.0" 
$ns at 286.14225267778545 "$node_(277) setdest 98 34401 19.0" 
$ns at 337.9979421827412 "$node_(277) setdest 115139 7386 1.0" 
$ns at 371.83948761354105 "$node_(277) setdest 5547 21131 18.0" 
$ns at 553.73461470827 "$node_(277) setdest 67185 18210 13.0" 
$ns at 602.6789494590711 "$node_(277) setdest 59249 40095 9.0" 
$ns at 715.3472147714022 "$node_(277) setdest 61445 30342 11.0" 
$ns at 759.4690906732799 "$node_(277) setdest 11354 5919 12.0" 
$ns at 864.9029747004275 "$node_(277) setdest 55407 12557 4.0" 
$ns at 209.50333990863913 "$node_(278) setdest 86531 30922 12.0" 
$ns at 271.6118782008993 "$node_(278) setdest 125928 40437 11.0" 
$ns at 344.36151787917834 "$node_(278) setdest 35673 38207 9.0" 
$ns at 391.4056331306796 "$node_(278) setdest 35607 37316 8.0" 
$ns at 430.8690505441087 "$node_(278) setdest 22602 4100 7.0" 
$ns at 513.4874358555246 "$node_(278) setdest 48996 24642 2.0" 
$ns at 544.659900902553 "$node_(278) setdest 39578 30936 8.0" 
$ns at 585.0316198072491 "$node_(278) setdest 77318 27350 16.0" 
$ns at 619.9548542300662 "$node_(278) setdest 94040 43874 16.0" 
$ns at 740.5018272612606 "$node_(278) setdest 125600 18609 20.0" 
$ns at 872.4199171322255 "$node_(278) setdest 40387 34812 1.0" 
$ns at 220.63035687484802 "$node_(279) setdest 82701 6528 12.0" 
$ns at 326.7500081499381 "$node_(279) setdest 110091 12859 13.0" 
$ns at 362.78875966632074 "$node_(279) setdest 10371 28537 1.0" 
$ns at 400.6183988853891 "$node_(279) setdest 94149 31160 1.0" 
$ns at 439.14160982052636 "$node_(279) setdest 123689 27771 10.0" 
$ns at 499.2637564642992 "$node_(279) setdest 57580 20530 20.0" 
$ns at 568.4452163717915 "$node_(279) setdest 64764 16849 14.0" 
$ns at 654.1315514456959 "$node_(279) setdest 108167 15759 3.0" 
$ns at 700.0848199192401 "$node_(279) setdest 69610 37013 5.0" 
$ns at 755.7018846665353 "$node_(279) setdest 34134 43368 19.0" 
$ns at 229.4347881157535 "$node_(280) setdest 26716 40047 18.0" 
$ns at 389.6905975725365 "$node_(280) setdest 12253 3253 8.0" 
$ns at 499.27808502765475 "$node_(280) setdest 71089 11503 17.0" 
$ns at 580.3954300439116 "$node_(280) setdest 52468 7232 2.0" 
$ns at 622.9655793206297 "$node_(280) setdest 26970 17243 5.0" 
$ns at 680.2731332056983 "$node_(280) setdest 28276 18673 15.0" 
$ns at 737.1475030382004 "$node_(280) setdest 60076 7790 15.0" 
$ns at 254.2308564259293 "$node_(281) setdest 130226 25878 18.0" 
$ns at 361.48696804310157 "$node_(281) setdest 45466 42846 12.0" 
$ns at 399.2043763026033 "$node_(281) setdest 84338 38695 3.0" 
$ns at 431.32363056521166 "$node_(281) setdest 92824 1396 15.0" 
$ns at 481.3096801089137 "$node_(281) setdest 95243 41420 12.0" 
$ns at 577.8594637247387 "$node_(281) setdest 46391 34086 5.0" 
$ns at 629.9886529277802 "$node_(281) setdest 101114 28018 19.0" 
$ns at 674.3319034939933 "$node_(281) setdest 124054 29060 14.0" 
$ns at 724.8968015847008 "$node_(281) setdest 81036 39162 10.0" 
$ns at 785.8949049768399 "$node_(281) setdest 90653 18658 12.0" 
$ns at 349.33258512814643 "$node_(282) setdest 2651 22858 11.0" 
$ns at 390.5734348643688 "$node_(282) setdest 113424 31204 11.0" 
$ns at 492.93389431277154 "$node_(282) setdest 64465 5761 8.0" 
$ns at 575.6412298348122 "$node_(282) setdest 30118 32383 19.0" 
$ns at 737.4202222661531 "$node_(282) setdest 57990 17521 12.0" 
$ns at 771.7565743643061 "$node_(282) setdest 35408 6689 5.0" 
$ns at 840.4379645095322 "$node_(282) setdest 77757 13974 6.0" 
$ns at 243.1706790786381 "$node_(283) setdest 133778 7648 17.0" 
$ns at 380.9960676732664 "$node_(283) setdest 127690 26010 10.0" 
$ns at 424.1501106277934 "$node_(283) setdest 104647 576 4.0" 
$ns at 469.7602886634619 "$node_(283) setdest 21173 9769 10.0" 
$ns at 558.6251796430861 "$node_(283) setdest 133061 33808 13.0" 
$ns at 654.8352393642751 "$node_(283) setdest 33406 9350 14.0" 
$ns at 696.2059916294 "$node_(283) setdest 64511 14425 18.0" 
$ns at 870.5170119175691 "$node_(283) setdest 35876 40133 18.0" 
$ns at 203.9406102990049 "$node_(284) setdest 130398 34283 7.0" 
$ns at 275.3362792709628 "$node_(284) setdest 130001 20364 3.0" 
$ns at 318.61784762099853 "$node_(284) setdest 75869 16710 4.0" 
$ns at 375.14418398145875 "$node_(284) setdest 127251 28269 16.0" 
$ns at 503.4377443838673 "$node_(284) setdest 63827 7382 3.0" 
$ns at 540.8664112724277 "$node_(284) setdest 114514 12674 1.0" 
$ns at 572.6061707388109 "$node_(284) setdest 32342 36776 10.0" 
$ns at 675.6810609410335 "$node_(284) setdest 34239 3154 14.0" 
$ns at 747.2048667260949 "$node_(284) setdest 18039 9395 16.0" 
$ns at 793.6341799903133 "$node_(284) setdest 68938 31231 1.0" 
$ns at 828.0508444715844 "$node_(284) setdest 48393 39268 17.0" 
$ns at 302.26816491082315 "$node_(285) setdest 83023 41757 5.0" 
$ns at 362.669253934974 "$node_(285) setdest 2288 35493 17.0" 
$ns at 506.06713735857784 "$node_(285) setdest 112283 9939 11.0" 
$ns at 635.2603991337546 "$node_(285) setdest 78046 27580 12.0" 
$ns at 765.0515398014825 "$node_(285) setdest 102706 2379 15.0" 
$ns at 878.8626257997125 "$node_(285) setdest 113117 17139 5.0" 
$ns at 232.96282860834336 "$node_(286) setdest 45726 23816 5.0" 
$ns at 302.71650072158377 "$node_(286) setdest 90654 42061 3.0" 
$ns at 343.6625714120111 "$node_(286) setdest 11019 22327 17.0" 
$ns at 539.327630042468 "$node_(286) setdest 14960 36898 2.0" 
$ns at 570.4545613802222 "$node_(286) setdest 39104 14429 2.0" 
$ns at 609.7142755193962 "$node_(286) setdest 45225 21456 4.0" 
$ns at 657.2362770283733 "$node_(286) setdest 56082 5796 13.0" 
$ns at 694.6626135760295 "$node_(286) setdest 12498 41453 17.0" 
$ns at 880.9133713175484 "$node_(286) setdest 100408 11936 11.0" 
$ns at 218.64034768350663 "$node_(287) setdest 31192 10232 13.0" 
$ns at 277.32613131031695 "$node_(287) setdest 64505 27378 8.0" 
$ns at 375.05757620086234 "$node_(287) setdest 87983 21750 3.0" 
$ns at 432.38913903815137 "$node_(287) setdest 105236 2135 2.0" 
$ns at 480.18503709687576 "$node_(287) setdest 22797 43122 10.0" 
$ns at 557.8757985829858 "$node_(287) setdest 130451 40410 2.0" 
$ns at 588.7772597113458 "$node_(287) setdest 57345 21334 14.0" 
$ns at 661.5761143291053 "$node_(287) setdest 122346 35383 18.0" 
$ns at 833.0464001604611 "$node_(287) setdest 8756 36393 18.0" 
$ns at 214.69076897042652 "$node_(288) setdest 68183 22104 15.0" 
$ns at 373.9295125984626 "$node_(288) setdest 12525 27296 19.0" 
$ns at 471.58683097669837 "$node_(288) setdest 130188 36738 7.0" 
$ns at 543.4013041864688 "$node_(288) setdest 111125 7917 18.0" 
$ns at 729.2400930740957 "$node_(288) setdest 49178 19723 6.0" 
$ns at 759.4438091191644 "$node_(288) setdest 112575 21435 6.0" 
$ns at 809.7167969806851 "$node_(288) setdest 55301 26418 19.0" 
$ns at 212.83623473131757 "$node_(289) setdest 45812 10742 1.0" 
$ns at 245.17694011224228 "$node_(289) setdest 13341 11245 2.0" 
$ns at 294.40742705741565 "$node_(289) setdest 103820 32161 4.0" 
$ns at 336.3990618034729 "$node_(289) setdest 84760 10847 13.0" 
$ns at 466.81258000581806 "$node_(289) setdest 63208 10602 9.0" 
$ns at 561.5428670558578 "$node_(289) setdest 92732 31530 17.0" 
$ns at 690.9840556907454 "$node_(289) setdest 39891 10085 12.0" 
$ns at 807.1794828850672 "$node_(289) setdest 66739 32633 1.0" 
$ns at 838.587286111043 "$node_(289) setdest 65732 3481 14.0" 
$ns at 889.2583497121186 "$node_(289) setdest 119690 2717 5.0" 
$ns at 302.78919092547625 "$node_(290) setdest 82482 27285 17.0" 
$ns at 397.74764624419697 "$node_(290) setdest 67965 110 8.0" 
$ns at 453.273250643415 "$node_(290) setdest 114136 31899 18.0" 
$ns at 491.6986728953079 "$node_(290) setdest 85083 2449 11.0" 
$ns at 599.3470920050406 "$node_(290) setdest 50479 7166 16.0" 
$ns at 646.6090497669481 "$node_(290) setdest 16994 10480 7.0" 
$ns at 679.5477905631501 "$node_(290) setdest 85881 8223 19.0" 
$ns at 748.9683933787438 "$node_(290) setdest 43392 10545 19.0" 
$ns at 227.18328056507445 "$node_(291) setdest 114219 33274 17.0" 
$ns at 291.654540811142 "$node_(291) setdest 57782 22636 9.0" 
$ns at 369.3559033337192 "$node_(291) setdest 6725 11622 4.0" 
$ns at 427.5787348374442 "$node_(291) setdest 129054 40956 17.0" 
$ns at 569.5221494052802 "$node_(291) setdest 99777 2741 10.0" 
$ns at 662.2739778648648 "$node_(291) setdest 4637 39399 4.0" 
$ns at 721.3854496469316 "$node_(291) setdest 96866 41797 6.0" 
$ns at 802.2052703717758 "$node_(291) setdest 25969 10898 13.0" 
$ns at 303.5128933048709 "$node_(292) setdest 42348 5352 8.0" 
$ns at 342.36059377974277 "$node_(292) setdest 120131 21932 8.0" 
$ns at 382.3531912591939 "$node_(292) setdest 25917 31994 11.0" 
$ns at 496.564912849092 "$node_(292) setdest 32699 23331 13.0" 
$ns at 551.2827923592881 "$node_(292) setdest 22229 40718 12.0" 
$ns at 596.853739264406 "$node_(292) setdest 90060 2972 8.0" 
$ns at 684.0903655702548 "$node_(292) setdest 38873 16538 10.0" 
$ns at 756.065063344496 "$node_(292) setdest 75254 19390 2.0" 
$ns at 793.7062903745383 "$node_(292) setdest 40716 31094 14.0" 
$ns at 886.2004057546908 "$node_(292) setdest 109749 38215 5.0" 
$ns at 262.10747676005053 "$node_(293) setdest 61162 18095 4.0" 
$ns at 311.7126215474757 "$node_(293) setdest 58833 9307 10.0" 
$ns at 440.7297210117282 "$node_(293) setdest 56191 13773 11.0" 
$ns at 556.0774851171435 "$node_(293) setdest 127224 23858 12.0" 
$ns at 679.5404501448245 "$node_(293) setdest 49057 16425 19.0" 
$ns at 760.5261670068087 "$node_(293) setdest 33681 13823 18.0" 
$ns at 860.7487556413657 "$node_(293) setdest 41020 14550 17.0" 
$ns at 203.87365611600637 "$node_(294) setdest 57962 44548 15.0" 
$ns at 294.1172655284982 "$node_(294) setdest 8757 30508 6.0" 
$ns at 357.2469383169989 "$node_(294) setdest 42106 18676 7.0" 
$ns at 446.0506729350376 "$node_(294) setdest 53751 40354 10.0" 
$ns at 517.9230145165245 "$node_(294) setdest 38970 16383 16.0" 
$ns at 557.0114106040465 "$node_(294) setdest 28216 32897 11.0" 
$ns at 672.4815876471862 "$node_(294) setdest 24186 40716 4.0" 
$ns at 738.7804570372998 "$node_(294) setdest 110678 22973 11.0" 
$ns at 847.8325556678569 "$node_(294) setdest 69940 22848 11.0" 
$ns at 216.82620492632037 "$node_(295) setdest 74356 27479 3.0" 
$ns at 268.00234816778647 "$node_(295) setdest 122949 44110 10.0" 
$ns at 364.54865708693984 "$node_(295) setdest 73158 35896 12.0" 
$ns at 411.7556586011281 "$node_(295) setdest 105787 15252 18.0" 
$ns at 558.1816995515421 "$node_(295) setdest 127587 10073 12.0" 
$ns at 618.8646452147433 "$node_(295) setdest 108614 11778 5.0" 
$ns at 673.8253514735038 "$node_(295) setdest 20533 7510 17.0" 
$ns at 763.7846311415927 "$node_(295) setdest 70418 12299 19.0" 
$ns at 827.5065182485644 "$node_(295) setdest 122492 20311 1.0" 
$ns at 862.0510264060664 "$node_(295) setdest 81183 28304 13.0" 
$ns at 212.98599828320184 "$node_(296) setdest 18776 12719 15.0" 
$ns at 378.6747053121047 "$node_(296) setdest 75193 8253 3.0" 
$ns at 414.350088185657 "$node_(296) setdest 77120 2284 5.0" 
$ns at 457.6461006625423 "$node_(296) setdest 55161 33545 13.0" 
$ns at 555.3049462606631 "$node_(296) setdest 83190 20881 19.0" 
$ns at 729.6761655597495 "$node_(296) setdest 131309 15645 10.0" 
$ns at 771.959523011746 "$node_(296) setdest 22357 4819 15.0" 
$ns at 290.80199636708085 "$node_(297) setdest 93116 20457 3.0" 
$ns at 333.92952664728375 "$node_(297) setdest 69237 38680 3.0" 
$ns at 373.57453580706135 "$node_(297) setdest 120248 43173 19.0" 
$ns at 471.10098214842947 "$node_(297) setdest 38902 3698 3.0" 
$ns at 511.1325593649574 "$node_(297) setdest 95455 34724 6.0" 
$ns at 583.8502502902999 "$node_(297) setdest 44753 13207 17.0" 
$ns at 710.6465206161257 "$node_(297) setdest 94346 15342 2.0" 
$ns at 740.7455456493145 "$node_(297) setdest 11049 23936 11.0" 
$ns at 820.0459043906502 "$node_(297) setdest 111731 26498 8.0" 
$ns at 892.1422296587629 "$node_(297) setdest 11004 6394 11.0" 
$ns at 237.53799576026117 "$node_(298) setdest 59786 34939 10.0" 
$ns at 357.24495562506036 "$node_(298) setdest 126330 24084 12.0" 
$ns at 422.30765015564646 "$node_(298) setdest 66360 39817 14.0" 
$ns at 535.0479100720775 "$node_(298) setdest 73556 3739 5.0" 
$ns at 574.4054809586772 "$node_(298) setdest 86414 12273 14.0" 
$ns at 716.8360599393636 "$node_(298) setdest 30872 24027 18.0" 
$ns at 826.4154291761041 "$node_(298) setdest 127233 42971 12.0" 
$ns at 204.31636345894805 "$node_(299) setdest 52627 13187 11.0" 
$ns at 254.5096122157938 "$node_(299) setdest 129080 40680 5.0" 
$ns at 304.5019779275767 "$node_(299) setdest 2141 35774 5.0" 
$ns at 368.37485429140844 "$node_(299) setdest 70022 43339 19.0" 
$ns at 532.2638471286546 "$node_(299) setdest 18959 26058 6.0" 
$ns at 595.5575776362389 "$node_(299) setdest 112441 18020 16.0" 
$ns at 706.6684481681077 "$node_(299) setdest 3283 21335 5.0" 
$ns at 754.0504092596559 "$node_(299) setdest 99733 28477 8.0" 
$ns at 841.348717307492 "$node_(299) setdest 73654 35119 11.0" 
$ns at 391.28617863451706 "$node_(300) setdest 53859 43187 14.0" 
$ns at 515.6784315870069 "$node_(300) setdest 96955 751 16.0" 
$ns at 584.2584905779808 "$node_(300) setdest 5725 23647 4.0" 
$ns at 638.3868086932812 "$node_(300) setdest 58554 40814 5.0" 
$ns at 675.2799389988629 "$node_(300) setdest 29572 25282 18.0" 
$ns at 761.3150920337182 "$node_(300) setdest 66406 23675 4.0" 
$ns at 794.3522349941485 "$node_(300) setdest 133018 37968 9.0" 
$ns at 851.9639068653709 "$node_(300) setdest 40016 38893 8.0" 
$ns at 321.1447928865564 "$node_(301) setdest 116198 15031 11.0" 
$ns at 438.1177478887452 "$node_(301) setdest 96651 8209 6.0" 
$ns at 484.92773397083823 "$node_(301) setdest 34178 41139 18.0" 
$ns at 545.9459355674616 "$node_(301) setdest 2285 24112 20.0" 
$ns at 742.9217160815798 "$node_(301) setdest 6518 29852 14.0" 
$ns at 843.5649323353986 "$node_(301) setdest 82386 2824 5.0" 
$ns at 372.2638815180005 "$node_(302) setdest 107202 25770 6.0" 
$ns at 444.00835961328085 "$node_(302) setdest 111316 8419 7.0" 
$ns at 474.36796861936443 "$node_(302) setdest 34179 22760 12.0" 
$ns at 533.6436047381591 "$node_(302) setdest 66214 9012 1.0" 
$ns at 567.9125540576354 "$node_(302) setdest 9208 40979 4.0" 
$ns at 627.6727531396828 "$node_(302) setdest 65299 1580 20.0" 
$ns at 659.7783441693891 "$node_(302) setdest 105886 36300 19.0" 
$ns at 708.9406703251528 "$node_(302) setdest 11930 26036 19.0" 
$ns at 780.4512103413552 "$node_(302) setdest 122465 10819 10.0" 
$ns at 842.393215439512 "$node_(302) setdest 78278 37613 16.0" 
$ns at 892.9957057689677 "$node_(302) setdest 25203 44155 8.0" 
$ns at 338.2033331505085 "$node_(303) setdest 130729 7911 4.0" 
$ns at 374.5591575826621 "$node_(303) setdest 32889 16455 5.0" 
$ns at 428.69979042227476 "$node_(303) setdest 91242 22501 1.0" 
$ns at 461.42963269793023 "$node_(303) setdest 79876 10882 20.0" 
$ns at 605.0055746747015 "$node_(303) setdest 19534 23146 2.0" 
$ns at 637.7883737754416 "$node_(303) setdest 125078 16214 19.0" 
$ns at 692.3517294614085 "$node_(303) setdest 56515 854 16.0" 
$ns at 834.273400053366 "$node_(303) setdest 42029 40962 9.0" 
$ns at 334.1238282904633 "$node_(304) setdest 116896 22406 1.0" 
$ns at 368.04638814322715 "$node_(304) setdest 118305 2817 12.0" 
$ns at 458.3976485888364 "$node_(304) setdest 123421 11355 15.0" 
$ns at 563.0284448115323 "$node_(304) setdest 124731 20172 14.0" 
$ns at 645.1389763082126 "$node_(304) setdest 115620 43047 6.0" 
$ns at 703.1285968565696 "$node_(304) setdest 100519 6528 11.0" 
$ns at 775.024996041408 "$node_(304) setdest 189 18366 10.0" 
$ns at 871.5120564554711 "$node_(304) setdest 119474 39911 1.0" 
$ns at 306.5669073342676 "$node_(305) setdest 87407 30957 6.0" 
$ns at 346.5671003693051 "$node_(305) setdest 15828 30838 12.0" 
$ns at 443.7925975391146 "$node_(305) setdest 74109 28887 13.0" 
$ns at 484.72845840943944 "$node_(305) setdest 120170 29943 15.0" 
$ns at 610.7118546272219 "$node_(305) setdest 108051 23619 7.0" 
$ns at 664.8439885282245 "$node_(305) setdest 7372 13979 8.0" 
$ns at 766.2004207391835 "$node_(305) setdest 88924 35182 13.0" 
$ns at 351.89742563668665 "$node_(306) setdest 14089 37835 17.0" 
$ns at 434.2270605547562 "$node_(306) setdest 128126 30866 3.0" 
$ns at 483.46895679903207 "$node_(306) setdest 130240 22671 14.0" 
$ns at 554.8083224335674 "$node_(306) setdest 103469 34078 1.0" 
$ns at 587.9957639061323 "$node_(306) setdest 101482 9413 6.0" 
$ns at 641.7461767558034 "$node_(306) setdest 60484 18616 18.0" 
$ns at 727.7296608817634 "$node_(306) setdest 38840 3951 10.0" 
$ns at 769.1904519543892 "$node_(306) setdest 75540 42597 19.0" 
$ns at 806.2475541497688 "$node_(306) setdest 7397 9022 14.0" 
$ns at 467.3341114089037 "$node_(307) setdest 21233 4360 12.0" 
$ns at 530.7690115749155 "$node_(307) setdest 14811 14065 17.0" 
$ns at 570.316623477177 "$node_(307) setdest 62465 22879 6.0" 
$ns at 638.7989702494906 "$node_(307) setdest 78662 16763 16.0" 
$ns at 694.5763314844609 "$node_(307) setdest 29749 18910 19.0" 
$ns at 842.6053421295449 "$node_(307) setdest 28366 40539 7.0" 
$ns at 880.2548423829605 "$node_(307) setdest 118870 41026 3.0" 
$ns at 395.9457752122585 "$node_(308) setdest 96485 42687 19.0" 
$ns at 490.97189293945826 "$node_(308) setdest 112392 24316 18.0" 
$ns at 686.0729955532047 "$node_(308) setdest 7145 33339 8.0" 
$ns at 784.5543767404464 "$node_(308) setdest 97763 12032 10.0" 
$ns at 845.801018969382 "$node_(308) setdest 109935 39358 14.0" 
$ns at 344.11784124569266 "$node_(309) setdest 115136 31486 14.0" 
$ns at 464.6604787600959 "$node_(309) setdest 134100 28176 3.0" 
$ns at 504.85156992212586 "$node_(309) setdest 16641 29621 16.0" 
$ns at 660.219813855531 "$node_(309) setdest 125495 1209 15.0" 
$ns at 769.0840448256398 "$node_(309) setdest 1584 17184 13.0" 
$ns at 815.6448755771835 "$node_(309) setdest 70915 24131 10.0" 
$ns at 899.4218805157599 "$node_(309) setdest 102490 11554 7.0" 
$ns at 370.8717906853803 "$node_(310) setdest 38567 1923 4.0" 
$ns at 416.42128295875426 "$node_(310) setdest 47662 18694 7.0" 
$ns at 473.3879049562829 "$node_(310) setdest 48239 31018 20.0" 
$ns at 700.7344493738478 "$node_(310) setdest 89757 2111 2.0" 
$ns at 748.4561153539034 "$node_(310) setdest 27657 25549 18.0" 
$ns at 308.988989759338 "$node_(311) setdest 126929 42251 5.0" 
$ns at 353.47637035971127 "$node_(311) setdest 38813 38631 3.0" 
$ns at 407.98987180953486 "$node_(311) setdest 87713 9747 14.0" 
$ns at 475.88438698831925 "$node_(311) setdest 106073 19818 16.0" 
$ns at 564.9876969245232 "$node_(311) setdest 19357 16443 19.0" 
$ns at 753.6228642327703 "$node_(311) setdest 34739 37879 10.0" 
$ns at 799.9873962423881 "$node_(311) setdest 40498 38552 2.0" 
$ns at 846.3275499101271 "$node_(311) setdest 21084 32034 6.0" 
$ns at 427.8065182474363 "$node_(312) setdest 84234 14109 16.0" 
$ns at 600.7438607189988 "$node_(312) setdest 46975 4449 18.0" 
$ns at 789.5599307476692 "$node_(312) setdest 129170 27305 7.0" 
$ns at 833.4484448893292 "$node_(312) setdest 75105 24829 19.0" 
$ns at 882.2063528151377 "$node_(312) setdest 40920 29281 13.0" 
$ns at 323.6162795990076 "$node_(313) setdest 54097 42463 6.0" 
$ns at 399.39794810215596 "$node_(313) setdest 15702 18770 15.0" 
$ns at 497.2281146871648 "$node_(313) setdest 61185 8283 6.0" 
$ns at 542.7241832668873 "$node_(313) setdest 133458 39731 10.0" 
$ns at 583.7852050513218 "$node_(313) setdest 56957 32536 16.0" 
$ns at 724.5038571394688 "$node_(313) setdest 116321 27383 2.0" 
$ns at 773.5276380524872 "$node_(313) setdest 131260 41063 17.0" 
$ns at 335.0074958846243 "$node_(314) setdest 55274 28948 14.0" 
$ns at 487.20955506825976 "$node_(314) setdest 46191 4011 10.0" 
$ns at 517.5558753944792 "$node_(314) setdest 31700 39929 16.0" 
$ns at 606.725048283319 "$node_(314) setdest 27451 13244 6.0" 
$ns at 648.049030791089 "$node_(314) setdest 120715 15500 1.0" 
$ns at 687.5147589970157 "$node_(314) setdest 16013 37436 7.0" 
$ns at 754.0541231928582 "$node_(314) setdest 11097 17003 12.0" 
$ns at 353.87050124938946 "$node_(315) setdest 74668 13322 4.0" 
$ns at 385.0857176173882 "$node_(315) setdest 46312 26129 17.0" 
$ns at 546.1252401537256 "$node_(315) setdest 65348 34839 16.0" 
$ns at 711.6302562849271 "$node_(315) setdest 2790 36717 12.0" 
$ns at 850.4900183836546 "$node_(315) setdest 101309 9190 1.0" 
$ns at 885.8890157978266 "$node_(315) setdest 31678 31758 1.0" 
$ns at 312.6180950888158 "$node_(316) setdest 77910 29433 1.0" 
$ns at 346.1883378713854 "$node_(316) setdest 42477 36319 18.0" 
$ns at 468.44627260663697 "$node_(316) setdest 110152 16165 19.0" 
$ns at 687.158603697932 "$node_(316) setdest 74914 33681 1.0" 
$ns at 719.3271251278277 "$node_(316) setdest 73270 6123 17.0" 
$ns at 778.0642700315108 "$node_(316) setdest 78090 19768 2.0" 
$ns at 812.8686524946639 "$node_(316) setdest 105061 32069 3.0" 
$ns at 859.5381338572187 "$node_(316) setdest 4381 42119 14.0" 
$ns at 307.8472984405706 "$node_(317) setdest 22576 1795 10.0" 
$ns at 343.36253758652515 "$node_(317) setdest 82773 4878 6.0" 
$ns at 381.16083694511025 "$node_(317) setdest 27974 19975 1.0" 
$ns at 412.8934374570754 "$node_(317) setdest 36385 16082 17.0" 
$ns at 607.4179588187992 "$node_(317) setdest 14873 28580 9.0" 
$ns at 682.3490758013965 "$node_(317) setdest 47921 2364 3.0" 
$ns at 731.2292123872185 "$node_(317) setdest 125351 7044 5.0" 
$ns at 761.8038935198069 "$node_(317) setdest 131741 32897 1.0" 
$ns at 792.0559730809688 "$node_(317) setdest 20459 896 8.0" 
$ns at 887.3009713131186 "$node_(317) setdest 95819 39328 4.0" 
$ns at 349.38392148724256 "$node_(318) setdest 59670 25223 15.0" 
$ns at 427.09995181786053 "$node_(318) setdest 64375 5717 4.0" 
$ns at 465.0151141450734 "$node_(318) setdest 37474 4090 10.0" 
$ns at 556.4871613328608 "$node_(318) setdest 52052 9506 3.0" 
$ns at 600.102032374257 "$node_(318) setdest 119181 43954 15.0" 
$ns at 724.6464328182449 "$node_(318) setdest 35060 23929 8.0" 
$ns at 787.3500000612717 "$node_(318) setdest 39388 42754 8.0" 
$ns at 887.9761322166287 "$node_(318) setdest 27840 23238 17.0" 
$ns at 448.4681602563544 "$node_(319) setdest 77888 16620 19.0" 
$ns at 549.9837270892988 "$node_(319) setdest 124151 8703 18.0" 
$ns at 639.0840005099365 "$node_(319) setdest 59168 28316 7.0" 
$ns at 705.4442746539227 "$node_(319) setdest 132254 11203 17.0" 
$ns at 831.338914933368 "$node_(319) setdest 80515 18186 14.0" 
$ns at 387.2211821915827 "$node_(320) setdest 83269 26057 18.0" 
$ns at 576.0130342514567 "$node_(320) setdest 64244 26396 12.0" 
$ns at 651.2751555533413 "$node_(320) setdest 88074 5343 15.0" 
$ns at 831.250085110987 "$node_(320) setdest 43929 5984 15.0" 
$ns at 893.4988032628125 "$node_(320) setdest 57814 23943 1.0" 
$ns at 347.9156515312844 "$node_(321) setdest 3491 27066 17.0" 
$ns at 406.55946212037145 "$node_(321) setdest 112668 429 9.0" 
$ns at 501.2356111743195 "$node_(321) setdest 9450 34072 18.0" 
$ns at 595.108163980877 "$node_(321) setdest 794 8055 10.0" 
$ns at 665.5160939940943 "$node_(321) setdest 46087 42613 18.0" 
$ns at 757.2736340974368 "$node_(321) setdest 120378 38201 16.0" 
$ns at 395.89435632521315 "$node_(322) setdest 90258 9519 9.0" 
$ns at 440.16435013561056 "$node_(322) setdest 70368 41025 8.0" 
$ns at 509.041663477248 "$node_(322) setdest 13346 2896 10.0" 
$ns at 565.6946918888149 "$node_(322) setdest 95285 30754 2.0" 
$ns at 606.4817907784739 "$node_(322) setdest 89349 21571 9.0" 
$ns at 673.5098508440992 "$node_(322) setdest 27765 32963 16.0" 
$ns at 737.4315954806228 "$node_(322) setdest 130126 33364 9.0" 
$ns at 776.4620588795372 "$node_(322) setdest 41453 9217 15.0" 
$ns at 313.1468095283613 "$node_(323) setdest 13985 18596 2.0" 
$ns at 347.80726651721744 "$node_(323) setdest 55376 35987 3.0" 
$ns at 381.82004352410405 "$node_(323) setdest 23611 43412 19.0" 
$ns at 444.3338602562192 "$node_(323) setdest 93603 33353 12.0" 
$ns at 586.4293811512034 "$node_(323) setdest 24890 25733 3.0" 
$ns at 624.6170907487451 "$node_(323) setdest 12294 11443 3.0" 
$ns at 679.2174382116076 "$node_(323) setdest 8780 37671 6.0" 
$ns at 718.1066956454089 "$node_(323) setdest 95764 30857 4.0" 
$ns at 758.6807012148168 "$node_(323) setdest 133192 10224 16.0" 
$ns at 340.90135902318116 "$node_(324) setdest 93330 29610 5.0" 
$ns at 414.4513664928808 "$node_(324) setdest 22371 20960 7.0" 
$ns at 503.02906254116306 "$node_(324) setdest 59543 37705 2.0" 
$ns at 539.7335350385514 "$node_(324) setdest 42279 43917 6.0" 
$ns at 609.4427526791899 "$node_(324) setdest 9816 41591 9.0" 
$ns at 717.0399049452597 "$node_(324) setdest 16260 31961 8.0" 
$ns at 769.0001960117629 "$node_(324) setdest 5674 26533 14.0" 
$ns at 879.1043235019499 "$node_(324) setdest 27010 38068 5.0" 
$ns at 364.8013423900107 "$node_(325) setdest 71235 8973 4.0" 
$ns at 405.84135215498117 "$node_(325) setdest 9873 43598 4.0" 
$ns at 473.6036288719331 "$node_(325) setdest 21662 7862 8.0" 
$ns at 531.107305589896 "$node_(325) setdest 99756 28844 5.0" 
$ns at 573.0155225555678 "$node_(325) setdest 54007 11265 19.0" 
$ns at 740.5398888989603 "$node_(325) setdest 112119 17920 6.0" 
$ns at 782.0849357161433 "$node_(325) setdest 96468 2804 14.0" 
$ns at 816.2885392589469 "$node_(325) setdest 52657 32510 4.0" 
$ns at 848.6274638689989 "$node_(325) setdest 24450 2198 15.0" 
$ns at 888.1917731372021 "$node_(325) setdest 62183 23355 7.0" 
$ns at 317.0404599306006 "$node_(326) setdest 80850 8670 7.0" 
$ns at 363.6539227057382 "$node_(326) setdest 100603 33944 6.0" 
$ns at 439.52573834871913 "$node_(326) setdest 104382 21219 5.0" 
$ns at 482.9080181187474 "$node_(326) setdest 21365 34668 12.0" 
$ns at 609.8367669190841 "$node_(326) setdest 40859 37418 14.0" 
$ns at 706.5701296948448 "$node_(326) setdest 74375 37494 4.0" 
$ns at 764.9444022375557 "$node_(326) setdest 45360 19597 19.0" 
$ns at 336.10004055689393 "$node_(327) setdest 64411 8809 2.0" 
$ns at 366.91176335171417 "$node_(327) setdest 100728 43625 2.0" 
$ns at 413.52816279038916 "$node_(327) setdest 116095 27284 6.0" 
$ns at 492.7216721098976 "$node_(327) setdest 53185 9217 5.0" 
$ns at 570.5484250623387 "$node_(327) setdest 22895 17888 14.0" 
$ns at 633.6932703044006 "$node_(327) setdest 28222 42403 6.0" 
$ns at 710.641265659088 "$node_(327) setdest 43211 14813 4.0" 
$ns at 755.8735595899026 "$node_(327) setdest 18850 14912 2.0" 
$ns at 803.5431354889835 "$node_(327) setdest 63468 38058 3.0" 
$ns at 851.9321266949573 "$node_(327) setdest 98307 28298 5.0" 
$ns at 898.2055068994863 "$node_(327) setdest 12752 11795 11.0" 
$ns at 392.1872727772177 "$node_(328) setdest 115841 43685 15.0" 
$ns at 448.2707312275759 "$node_(328) setdest 4634 16090 10.0" 
$ns at 540.2491735509115 "$node_(328) setdest 47517 4119 14.0" 
$ns at 679.292024942876 "$node_(328) setdest 132118 38495 15.0" 
$ns at 767.4380851936276 "$node_(328) setdest 39375 1858 5.0" 
$ns at 831.6299839425941 "$node_(328) setdest 110958 30235 18.0" 
$ns at 326.4851993107722 "$node_(329) setdest 72777 30976 9.0" 
$ns at 417.04191382252134 "$node_(329) setdest 14647 15637 3.0" 
$ns at 452.9828165222894 "$node_(329) setdest 5918 44565 9.0" 
$ns at 569.0604374951333 "$node_(329) setdest 105850 40367 3.0" 
$ns at 612.6958038364276 "$node_(329) setdest 45372 38727 14.0" 
$ns at 737.9812782564386 "$node_(329) setdest 39657 12513 1.0" 
$ns at 771.3625851853935 "$node_(329) setdest 81066 42386 1.0" 
$ns at 811.1235488704593 "$node_(329) setdest 30805 1346 1.0" 
$ns at 842.3379124941799 "$node_(329) setdest 90450 38523 13.0" 
$ns at 303.92093361539924 "$node_(330) setdest 73475 23042 17.0" 
$ns at 382.7622338814315 "$node_(330) setdest 54044 21139 19.0" 
$ns at 534.120313492047 "$node_(330) setdest 94365 33022 1.0" 
$ns at 564.5187348152045 "$node_(330) setdest 109303 474 9.0" 
$ns at 663.9495598673086 "$node_(330) setdest 11120 31973 9.0" 
$ns at 764.8699436022338 "$node_(330) setdest 111368 26418 17.0" 
$ns at 373.60827479349126 "$node_(331) setdest 80351 9091 4.0" 
$ns at 426.56673306659025 "$node_(331) setdest 23699 26219 17.0" 
$ns at 501.4312183135546 "$node_(331) setdest 29013 20527 8.0" 
$ns at 560.3983112942076 "$node_(331) setdest 4058 36472 5.0" 
$ns at 628.3638194393412 "$node_(331) setdest 18134 8511 1.0" 
$ns at 664.2777603882035 "$node_(331) setdest 14980 12017 2.0" 
$ns at 709.6637105786881 "$node_(331) setdest 43383 3485 19.0" 
$ns at 855.4282591280277 "$node_(331) setdest 35734 36696 14.0" 
$ns at 385.9358584262171 "$node_(332) setdest 97269 38650 2.0" 
$ns at 434.19133062209403 "$node_(332) setdest 22523 7532 4.0" 
$ns at 467.9652987564385 "$node_(332) setdest 108708 2705 9.0" 
$ns at 559.2012077032236 "$node_(332) setdest 91078 37105 7.0" 
$ns at 618.9532262418696 "$node_(332) setdest 18849 10547 19.0" 
$ns at 664.6261418626083 "$node_(332) setdest 40833 316 11.0" 
$ns at 760.9600802473371 "$node_(332) setdest 124824 3378 16.0" 
$ns at 894.5552426881068 "$node_(332) setdest 82070 9131 11.0" 
$ns at 347.87384002234205 "$node_(333) setdest 130109 28089 11.0" 
$ns at 433.0883242263222 "$node_(333) setdest 68992 36966 11.0" 
$ns at 498.63410253581867 "$node_(333) setdest 122566 6384 6.0" 
$ns at 552.5558943328496 "$node_(333) setdest 94609 2900 18.0" 
$ns at 654.152519201519 "$node_(333) setdest 22103 26690 10.0" 
$ns at 734.0269684319873 "$node_(333) setdest 31930 7196 13.0" 
$ns at 845.1509942568733 "$node_(333) setdest 128251 25326 16.0" 
$ns at 879.5832498362217 "$node_(333) setdest 94044 29346 11.0" 
$ns at 315.0377321366483 "$node_(334) setdest 121365 33295 17.0" 
$ns at 510.1565677530049 "$node_(334) setdest 76465 650 3.0" 
$ns at 563.21220974394 "$node_(334) setdest 97551 6574 8.0" 
$ns at 628.9810524650429 "$node_(334) setdest 45628 11092 2.0" 
$ns at 659.8920590859373 "$node_(334) setdest 352 10487 12.0" 
$ns at 700.0212998949282 "$node_(334) setdest 119813 1048 10.0" 
$ns at 811.6051012321932 "$node_(334) setdest 85767 11608 3.0" 
$ns at 855.5062014210221 "$node_(334) setdest 47529 40891 4.0" 
$ns at 387.01533043011545 "$node_(335) setdest 101193 15220 16.0" 
$ns at 446.52798224104635 "$node_(335) setdest 37235 12279 7.0" 
$ns at 529.5779724443481 "$node_(335) setdest 95405 12045 2.0" 
$ns at 564.778340698804 "$node_(335) setdest 75889 5395 9.0" 
$ns at 595.2825192432507 "$node_(335) setdest 96788 36627 15.0" 
$ns at 774.3603457604802 "$node_(335) setdest 51872 37350 17.0" 
$ns at 824.1870348785046 "$node_(335) setdest 59499 37089 17.0" 
$ns at 311.93440413850976 "$node_(336) setdest 64451 12780 5.0" 
$ns at 351.81297718486184 "$node_(336) setdest 93639 41710 20.0" 
$ns at 565.9400842072948 "$node_(336) setdest 92630 34177 10.0" 
$ns at 605.5447273894033 "$node_(336) setdest 6971 32127 20.0" 
$ns at 807.1756687788927 "$node_(336) setdest 5707 28798 5.0" 
$ns at 858.0668282765428 "$node_(336) setdest 133798 20606 3.0" 
$ns at 307.92059982410024 "$node_(337) setdest 130720 14913 4.0" 
$ns at 349.77126074772167 "$node_(337) setdest 50395 13007 2.0" 
$ns at 390.6285896324621 "$node_(337) setdest 51304 37259 4.0" 
$ns at 447.10013295190595 "$node_(337) setdest 53552 979 13.0" 
$ns at 528.4274776360343 "$node_(337) setdest 127607 42364 11.0" 
$ns at 588.2588155160448 "$node_(337) setdest 70977 14018 15.0" 
$ns at 662.6884811481655 "$node_(337) setdest 109869 23906 5.0" 
$ns at 726.6858005892991 "$node_(337) setdest 89787 14032 12.0" 
$ns at 781.2746855856843 "$node_(337) setdest 74874 15402 16.0" 
$ns at 331.66318917022505 "$node_(338) setdest 9123 30179 4.0" 
$ns at 372.29492432216296 "$node_(338) setdest 82343 5889 9.0" 
$ns at 454.7484216548893 "$node_(338) setdest 64157 30643 12.0" 
$ns at 575.516986754764 "$node_(338) setdest 29217 35434 7.0" 
$ns at 654.1043914119016 "$node_(338) setdest 101961 11820 14.0" 
$ns at 810.9249719751433 "$node_(338) setdest 19121 27048 2.0" 
$ns at 858.7718433563844 "$node_(338) setdest 49777 1831 11.0" 
$ns at 327.7572551773106 "$node_(339) setdest 67266 26184 1.0" 
$ns at 359.08064643692194 "$node_(339) setdest 39329 14469 7.0" 
$ns at 389.5837284678108 "$node_(339) setdest 73042 29356 2.0" 
$ns at 434.74794515203365 "$node_(339) setdest 44541 44517 1.0" 
$ns at 471.3354636268514 "$node_(339) setdest 5357 42614 4.0" 
$ns at 512.523514807898 "$node_(339) setdest 9278 32532 6.0" 
$ns at 594.8632713292019 "$node_(339) setdest 1682 13556 6.0" 
$ns at 664.8093451895678 "$node_(339) setdest 51650 15681 8.0" 
$ns at 736.1534757864471 "$node_(339) setdest 33854 43913 12.0" 
$ns at 834.0060293665002 "$node_(339) setdest 35526 41495 10.0" 
$ns at 326.12549205945743 "$node_(340) setdest 97669 33305 1.0" 
$ns at 361.4402704625839 "$node_(340) setdest 61877 38551 16.0" 
$ns at 533.8310227137822 "$node_(340) setdest 53550 4751 10.0" 
$ns at 612.4553100716842 "$node_(340) setdest 8571 16386 3.0" 
$ns at 654.8269591600041 "$node_(340) setdest 71112 13992 5.0" 
$ns at 725.091468251481 "$node_(340) setdest 95143 1896 3.0" 
$ns at 764.8710876113043 "$node_(340) setdest 56208 33743 8.0" 
$ns at 810.495792986476 "$node_(340) setdest 48752 10878 3.0" 
$ns at 869.4117089696816 "$node_(340) setdest 12417 19666 5.0" 
$ns at 312.6135299062604 "$node_(341) setdest 69929 17245 18.0" 
$ns at 435.7561764720549 "$node_(341) setdest 77202 17225 2.0" 
$ns at 480.2874661517144 "$node_(341) setdest 82725 10151 17.0" 
$ns at 600.6842756404176 "$node_(341) setdest 1969 36083 17.0" 
$ns at 637.1165272449872 "$node_(341) setdest 95767 34731 19.0" 
$ns at 672.185818069643 "$node_(341) setdest 24844 14188 19.0" 
$ns at 726.7078910789411 "$node_(341) setdest 75876 34587 20.0" 
$ns at 880.8386199579365 "$node_(341) setdest 103302 20349 7.0" 
$ns at 463.2007939859948 "$node_(342) setdest 107676 43245 10.0" 
$ns at 521.7997834820636 "$node_(342) setdest 24596 31153 12.0" 
$ns at 605.2920416261459 "$node_(342) setdest 89824 38126 7.0" 
$ns at 682.2075656419161 "$node_(342) setdest 107592 41691 11.0" 
$ns at 818.5546508233028 "$node_(342) setdest 52788 4379 4.0" 
$ns at 886.9636816092708 "$node_(342) setdest 123138 6072 6.0" 
$ns at 316.1970287150582 "$node_(343) setdest 7834 28498 1.0" 
$ns at 355.77896346057844 "$node_(343) setdest 28731 35254 7.0" 
$ns at 439.87010169858127 "$node_(343) setdest 116516 12929 20.0" 
$ns at 519.365605786395 "$node_(343) setdest 91576 8661 11.0" 
$ns at 658.4660069976446 "$node_(343) setdest 27912 39012 19.0" 
$ns at 851.4800184146284 "$node_(343) setdest 129174 1700 19.0" 
$ns at 333.506122487704 "$node_(344) setdest 73 21013 8.0" 
$ns at 407.32006090623815 "$node_(344) setdest 70509 21105 13.0" 
$ns at 489.863366489955 "$node_(344) setdest 29988 39688 2.0" 
$ns at 534.5771589729233 "$node_(344) setdest 39154 24475 18.0" 
$ns at 578.310166447271 "$node_(344) setdest 96827 42194 5.0" 
$ns at 644.0492092080184 "$node_(344) setdest 17619 43630 11.0" 
$ns at 718.6770841229551 "$node_(344) setdest 96180 41385 12.0" 
$ns at 762.6503508536101 "$node_(344) setdest 5723 17508 19.0" 
$ns at 328.90114362641674 "$node_(345) setdest 75731 38239 3.0" 
$ns at 369.72548618854 "$node_(345) setdest 84480 34211 1.0" 
$ns at 403.3677504328077 "$node_(345) setdest 104980 30462 1.0" 
$ns at 436.51557835285826 "$node_(345) setdest 14751 22205 9.0" 
$ns at 513.9202120115849 "$node_(345) setdest 115769 32156 10.0" 
$ns at 603.3093196693286 "$node_(345) setdest 11997 21306 16.0" 
$ns at 786.6672926587653 "$node_(345) setdest 23403 30105 1.0" 
$ns at 824.1667026483502 "$node_(345) setdest 67375 5415 7.0" 
$ns at 884.701796595679 "$node_(345) setdest 7742 36682 9.0" 
$ns at 362.3754658041472 "$node_(346) setdest 9348 11755 10.0" 
$ns at 451.51372480876074 "$node_(346) setdest 35850 39735 7.0" 
$ns at 534.1825922096875 "$node_(346) setdest 129481 17888 7.0" 
$ns at 596.9503264975591 "$node_(346) setdest 47240 34340 10.0" 
$ns at 687.7039300333274 "$node_(346) setdest 110979 42277 6.0" 
$ns at 758.5423232337853 "$node_(346) setdest 58451 36761 15.0" 
$ns at 866.7133091409198 "$node_(346) setdest 89813 7373 20.0" 
$ns at 376.3770592151978 "$node_(347) setdest 937 22874 4.0" 
$ns at 444.48935586265054 "$node_(347) setdest 127270 9002 9.0" 
$ns at 558.9120640678717 "$node_(347) setdest 15083 36936 11.0" 
$ns at 608.1186982144425 "$node_(347) setdest 11203 25252 13.0" 
$ns at 725.5521974892937 "$node_(347) setdest 118364 13753 8.0" 
$ns at 763.9838511343366 "$node_(347) setdest 83358 5642 9.0" 
$ns at 831.9369295165898 "$node_(347) setdest 69950 15037 4.0" 
$ns at 869.2647295728713 "$node_(347) setdest 80240 984 3.0" 
$ns at 336.31566476664 "$node_(348) setdest 107810 4803 16.0" 
$ns at 430.0225645451868 "$node_(348) setdest 45919 36982 20.0" 
$ns at 561.1823389121574 "$node_(348) setdest 46474 36016 19.0" 
$ns at 632.226110081944 "$node_(348) setdest 100783 33639 4.0" 
$ns at 680.9375780663238 "$node_(348) setdest 110745 12502 18.0" 
$ns at 792.8596541119548 "$node_(348) setdest 110757 17541 5.0" 
$ns at 833.893621550713 "$node_(348) setdest 103658 1468 19.0" 
$ns at 362.53348998984166 "$node_(349) setdest 78001 16514 16.0" 
$ns at 423.6140811997942 "$node_(349) setdest 104766 17345 6.0" 
$ns at 506.0740707525845 "$node_(349) setdest 49048 1502 12.0" 
$ns at 541.1064947606964 "$node_(349) setdest 95909 7567 4.0" 
$ns at 606.4740165543091 "$node_(349) setdest 17224 18762 12.0" 
$ns at 714.1288783460867 "$node_(349) setdest 52812 7351 17.0" 
$ns at 879.3856354755167 "$node_(349) setdest 126689 39212 9.0" 
$ns at 347.9110401837896 "$node_(350) setdest 2986 40006 11.0" 
$ns at 422.17774921578115 "$node_(350) setdest 66306 34207 11.0" 
$ns at 502.8162439629921 "$node_(350) setdest 6144 27529 8.0" 
$ns at 539.4342424088286 "$node_(350) setdest 17740 17989 9.0" 
$ns at 576.5000848182073 "$node_(350) setdest 86340 32978 10.0" 
$ns at 681.4857325872763 "$node_(350) setdest 67242 12100 16.0" 
$ns at 758.8526077446766 "$node_(350) setdest 9031 41246 17.0" 
$ns at 801.9943246013809 "$node_(350) setdest 27381 18130 8.0" 
$ns at 358.8097548181447 "$node_(351) setdest 102542 44619 13.0" 
$ns at 473.2410820141981 "$node_(351) setdest 127478 38454 12.0" 
$ns at 607.6998385658881 "$node_(351) setdest 84790 38662 15.0" 
$ns at 686.52827514103 "$node_(351) setdest 105232 41121 11.0" 
$ns at 724.2225389091259 "$node_(351) setdest 111579 12421 3.0" 
$ns at 777.4026285898229 "$node_(351) setdest 14802 35161 20.0" 
$ns at 821.502608906158 "$node_(351) setdest 29803 41319 15.0" 
$ns at 858.4239883439775 "$node_(351) setdest 107928 38099 20.0" 
$ns at 307.57145063113376 "$node_(352) setdest 685 32284 14.0" 
$ns at 370.58854162711214 "$node_(352) setdest 132366 33992 1.0" 
$ns at 406.1935773098252 "$node_(352) setdest 15994 28088 8.0" 
$ns at 507.6580636046242 "$node_(352) setdest 102220 19206 18.0" 
$ns at 636.2583448219218 "$node_(352) setdest 81129 36989 5.0" 
$ns at 666.7386355400923 "$node_(352) setdest 20714 39241 9.0" 
$ns at 759.6367931384948 "$node_(352) setdest 10390 13291 4.0" 
$ns at 825.8667038451255 "$node_(352) setdest 103383 25992 5.0" 
$ns at 874.2949937600548 "$node_(352) setdest 105253 29278 5.0" 
$ns at 398.3413413011009 "$node_(353) setdest 42999 16197 1.0" 
$ns at 432.3717291254784 "$node_(353) setdest 104613 24452 10.0" 
$ns at 473.70959505367756 "$node_(353) setdest 56874 42182 7.0" 
$ns at 506.87604973608603 "$node_(353) setdest 116880 27390 13.0" 
$ns at 596.1219452987284 "$node_(353) setdest 121319 35581 9.0" 
$ns at 635.8526372100121 "$node_(353) setdest 48901 34090 17.0" 
$ns at 731.656581664298 "$node_(353) setdest 73294 37508 16.0" 
$ns at 895.0303542054498 "$node_(353) setdest 44831 22383 6.0" 
$ns at 314.02960907622355 "$node_(354) setdest 16988 12455 7.0" 
$ns at 407.48306579560165 "$node_(354) setdest 71310 31542 1.0" 
$ns at 444.2599447360932 "$node_(354) setdest 183 5268 11.0" 
$ns at 567.2702838596126 "$node_(354) setdest 14451 24116 6.0" 
$ns at 639.1366461203031 "$node_(354) setdest 73991 31912 5.0" 
$ns at 692.8500670177802 "$node_(354) setdest 23977 5467 11.0" 
$ns at 815.4667785893705 "$node_(354) setdest 46043 11499 18.0" 
$ns at 333.4664688594811 "$node_(355) setdest 68456 4291 11.0" 
$ns at 429.97654475295485 "$node_(355) setdest 82860 38821 2.0" 
$ns at 470.29821453846444 "$node_(355) setdest 38578 22787 5.0" 
$ns at 509.5163103181776 "$node_(355) setdest 128909 4046 17.0" 
$ns at 651.9099116013101 "$node_(355) setdest 122321 2002 10.0" 
$ns at 750.3810673158255 "$node_(355) setdest 27562 13435 12.0" 
$ns at 793.8753592218258 "$node_(355) setdest 13354 21455 18.0" 
$ns at 310.05943984701236 "$node_(356) setdest 126000 23427 14.0" 
$ns at 427.23223990902704 "$node_(356) setdest 53280 5728 1.0" 
$ns at 463.7085940730263 "$node_(356) setdest 46425 33094 4.0" 
$ns at 526.754805553683 "$node_(356) setdest 32239 24393 1.0" 
$ns at 558.6745691654755 "$node_(356) setdest 40069 27465 17.0" 
$ns at 619.3924674763291 "$node_(356) setdest 117851 30472 15.0" 
$ns at 779.8194335548937 "$node_(356) setdest 53862 22305 19.0" 
$ns at 874.5511381298306 "$node_(356) setdest 115371 30534 15.0" 
$ns at 320.21059282362023 "$node_(357) setdest 35051 429 5.0" 
$ns at 371.4753791084087 "$node_(357) setdest 114020 3843 5.0" 
$ns at 411.5871995422124 "$node_(357) setdest 115360 19922 6.0" 
$ns at 473.65520067021293 "$node_(357) setdest 20386 34008 7.0" 
$ns at 517.8082519960938 "$node_(357) setdest 49620 41616 8.0" 
$ns at 566.8698428192897 "$node_(357) setdest 128046 20822 17.0" 
$ns at 662.3707522750888 "$node_(357) setdest 10223 5419 19.0" 
$ns at 867.8110614100649 "$node_(357) setdest 90073 32433 3.0" 
$ns at 329.4170489961525 "$node_(358) setdest 41736 34299 11.0" 
$ns at 454.504082274289 "$node_(358) setdest 29671 22947 6.0" 
$ns at 540.0004837462789 "$node_(358) setdest 100596 29635 9.0" 
$ns at 625.7240906635067 "$node_(358) setdest 56140 19356 14.0" 
$ns at 701.150404526137 "$node_(358) setdest 47896 21435 10.0" 
$ns at 735.7065542170457 "$node_(358) setdest 129249 2645 7.0" 
$ns at 770.2590029783048 "$node_(358) setdest 3112 23722 4.0" 
$ns at 837.1344214897013 "$node_(358) setdest 12856 15278 6.0" 
$ns at 875.392466255709 "$node_(358) setdest 89204 38551 18.0" 
$ns at 379.66874081006694 "$node_(359) setdest 3611 23409 15.0" 
$ns at 416.8186980580417 "$node_(359) setdest 43997 40260 15.0" 
$ns at 547.0625202158676 "$node_(359) setdest 61577 3382 9.0" 
$ns at 606.5254140026818 "$node_(359) setdest 100920 28318 9.0" 
$ns at 700.2556126951455 "$node_(359) setdest 33099 4201 5.0" 
$ns at 761.080449992558 "$node_(359) setdest 132537 24363 4.0" 
$ns at 825.6094482523431 "$node_(359) setdest 71397 762 4.0" 
$ns at 855.9487651433153 "$node_(359) setdest 78359 21485 2.0" 
$ns at 896.7845901757214 "$node_(359) setdest 34865 17682 12.0" 
$ns at 352.31554501207194 "$node_(360) setdest 86339 41774 1.0" 
$ns at 391.8426732658823 "$node_(360) setdest 95456 26800 1.0" 
$ns at 427.3169463685954 "$node_(360) setdest 107480 37218 19.0" 
$ns at 605.1410066839793 "$node_(360) setdest 16591 32518 10.0" 
$ns at 705.7248429233914 "$node_(360) setdest 10728 21169 18.0" 
$ns at 852.4687275687184 "$node_(360) setdest 65844 39022 9.0" 
$ns at 327.45650676308605 "$node_(361) setdest 96949 554 7.0" 
$ns at 423.40194574068823 "$node_(361) setdest 108335 39578 10.0" 
$ns at 460.12985522345207 "$node_(361) setdest 129854 302 14.0" 
$ns at 563.8487532551351 "$node_(361) setdest 64163 13191 19.0" 
$ns at 637.2836379550097 "$node_(361) setdest 96092 25426 17.0" 
$ns at 672.2799953757251 "$node_(361) setdest 43248 27611 11.0" 
$ns at 751.161795878297 "$node_(361) setdest 4797 34436 10.0" 
$ns at 798.9216644767899 "$node_(361) setdest 89643 798 10.0" 
$ns at 858.3210121185518 "$node_(361) setdest 49754 42692 9.0" 
$ns at 889.6436904946426 "$node_(361) setdest 127183 6529 14.0" 
$ns at 333.59023834187667 "$node_(362) setdest 107669 2640 16.0" 
$ns at 420.23493675433724 "$node_(362) setdest 113139 34595 3.0" 
$ns at 469.0004358717314 "$node_(362) setdest 95612 17288 12.0" 
$ns at 531.3399899470446 "$node_(362) setdest 85404 5364 13.0" 
$ns at 661.7537688425474 "$node_(362) setdest 32323 20550 17.0" 
$ns at 693.0154287051193 "$node_(362) setdest 61591 8372 2.0" 
$ns at 733.1486148695728 "$node_(362) setdest 12608 40240 12.0" 
$ns at 839.6749893202716 "$node_(362) setdest 5260 21536 12.0" 
$ns at 407.58922869856184 "$node_(363) setdest 92137 12172 9.0" 
$ns at 466.1954350571088 "$node_(363) setdest 56814 35592 1.0" 
$ns at 501.96139605560427 "$node_(363) setdest 43163 34619 14.0" 
$ns at 634.0575113114545 "$node_(363) setdest 58562 14096 2.0" 
$ns at 681.592677927154 "$node_(363) setdest 87029 5669 6.0" 
$ns at 764.0120744934135 "$node_(363) setdest 34154 11119 20.0" 
$ns at 377.14081347382466 "$node_(364) setdest 20393 33228 15.0" 
$ns at 513.1789416794793 "$node_(364) setdest 3874 39418 3.0" 
$ns at 572.8346344424455 "$node_(364) setdest 10657 26065 5.0" 
$ns at 637.4977628861526 "$node_(364) setdest 76444 17193 11.0" 
$ns at 738.3736606146431 "$node_(364) setdest 29262 30461 16.0" 
$ns at 773.1300013603653 "$node_(364) setdest 48363 3737 11.0" 
$ns at 803.494783691695 "$node_(364) setdest 78839 36793 20.0" 
$ns at 310.4556514011989 "$node_(365) setdest 32735 9598 14.0" 
$ns at 464.7890080951875 "$node_(365) setdest 14516 37363 18.0" 
$ns at 612.0019503406425 "$node_(365) setdest 52831 28445 19.0" 
$ns at 778.5840047946936 "$node_(365) setdest 14341 15250 8.0" 
$ns at 872.0178165039248 "$node_(365) setdest 91256 27760 4.0" 
$ns at 353.13484447527446 "$node_(366) setdest 125618 28312 6.0" 
$ns at 384.83770744583126 "$node_(366) setdest 108203 1245 10.0" 
$ns at 431.03550443390225 "$node_(366) setdest 86557 13395 4.0" 
$ns at 482.0002820766482 "$node_(366) setdest 90739 38557 11.0" 
$ns at 582.4288247618705 "$node_(366) setdest 65450 6490 19.0" 
$ns at 712.7707004840456 "$node_(366) setdest 54461 24546 16.0" 
$ns at 864.1421671264557 "$node_(366) setdest 99949 11085 4.0" 
$ns at 387.4433237222143 "$node_(367) setdest 30535 13371 5.0" 
$ns at 443.3492843845198 "$node_(367) setdest 34708 21653 14.0" 
$ns at 551.006401554644 "$node_(367) setdest 83733 27074 10.0" 
$ns at 614.0131880531995 "$node_(367) setdest 85768 9916 16.0" 
$ns at 803.9453733649157 "$node_(367) setdest 69420 37513 9.0" 
$ns at 850.0142378632321 "$node_(367) setdest 69087 38231 13.0" 
$ns at 882.6402744763161 "$node_(367) setdest 69715 29034 6.0" 
$ns at 303.7816870764625 "$node_(368) setdest 99109 41166 3.0" 
$ns at 359.43674588845175 "$node_(368) setdest 93805 32286 12.0" 
$ns at 436.7974224162462 "$node_(368) setdest 31860 38313 6.0" 
$ns at 502.4647569554518 "$node_(368) setdest 105445 8372 2.0" 
$ns at 543.0374364815781 "$node_(368) setdest 133671 43672 16.0" 
$ns at 594.6342507023608 "$node_(368) setdest 95415 9927 9.0" 
$ns at 697.6573068002072 "$node_(368) setdest 56899 27384 15.0" 
$ns at 767.3345221889358 "$node_(368) setdest 16462 21927 11.0" 
$ns at 843.0806417923493 "$node_(368) setdest 55432 9499 5.0" 
$ns at 879.8464392767743 "$node_(368) setdest 98790 20989 5.0" 
$ns at 331.7668957799662 "$node_(369) setdest 56134 7088 1.0" 
$ns at 362.9219601891634 "$node_(369) setdest 53432 33129 8.0" 
$ns at 433.77913447072 "$node_(369) setdest 61609 22844 7.0" 
$ns at 516.5537285866943 "$node_(369) setdest 69096 559 1.0" 
$ns at 547.1578935295995 "$node_(369) setdest 50632 30770 9.0" 
$ns at 611.2847520539069 "$node_(369) setdest 114530 27039 1.0" 
$ns at 643.5536020536939 "$node_(369) setdest 22517 7285 17.0" 
$ns at 810.6553717795746 "$node_(369) setdest 18287 25239 18.0" 
$ns at 311.54875175994715 "$node_(370) setdest 101805 19718 6.0" 
$ns at 395.78947121005035 "$node_(370) setdest 45966 42532 18.0" 
$ns at 483.2309252767824 "$node_(370) setdest 99423 19930 10.0" 
$ns at 524.0938447394941 "$node_(370) setdest 48911 33664 14.0" 
$ns at 566.1488550439635 "$node_(370) setdest 47462 40496 18.0" 
$ns at 624.4286644271465 "$node_(370) setdest 124308 14285 12.0" 
$ns at 668.684953044078 "$node_(370) setdest 39365 38615 1.0" 
$ns at 706.4781382780435 "$node_(370) setdest 93052 14167 17.0" 
$ns at 837.5069241035933 "$node_(370) setdest 90036 34801 12.0" 
$ns at 873.0578036918968 "$node_(370) setdest 24728 36963 4.0" 
$ns at 391.51218431476224 "$node_(371) setdest 108568 25312 4.0" 
$ns at 428.91886495585106 "$node_(371) setdest 4283 29604 17.0" 
$ns at 548.873938201521 "$node_(371) setdest 7253 28232 13.0" 
$ns at 661.6342002338667 "$node_(371) setdest 58363 10969 14.0" 
$ns at 699.8231092982062 "$node_(371) setdest 76797 16188 10.0" 
$ns at 749.6349335609569 "$node_(371) setdest 68704 40716 18.0" 
$ns at 806.8816750642441 "$node_(371) setdest 100209 7227 20.0" 
$ns at 319.6292438464245 "$node_(372) setdest 87591 4704 19.0" 
$ns at 511.3282720360144 "$node_(372) setdest 45506 756 1.0" 
$ns at 547.037329734748 "$node_(372) setdest 124583 44033 5.0" 
$ns at 611.0402960945661 "$node_(372) setdest 29520 42985 9.0" 
$ns at 726.2258239236542 "$node_(372) setdest 109612 497 8.0" 
$ns at 802.8381624150949 "$node_(372) setdest 122210 17588 6.0" 
$ns at 892.6140152207892 "$node_(372) setdest 63546 10835 13.0" 
$ns at 300.93103818175575 "$node_(373) setdest 106427 40602 6.0" 
$ns at 374.00650576507917 "$node_(373) setdest 1899 8640 8.0" 
$ns at 466.43830539495553 "$node_(373) setdest 45717 43212 20.0" 
$ns at 593.5364520856907 "$node_(373) setdest 99965 42735 1.0" 
$ns at 630.6137883427656 "$node_(373) setdest 53919 10990 18.0" 
$ns at 775.8323993904879 "$node_(373) setdest 84723 31406 5.0" 
$ns at 825.266433158956 "$node_(373) setdest 79791 7215 1.0" 
$ns at 855.6710535372472 "$node_(373) setdest 127585 26363 4.0" 
$ns at 349.6263888590221 "$node_(374) setdest 123321 43561 11.0" 
$ns at 405.56187686670535 "$node_(374) setdest 119561 27548 19.0" 
$ns at 482.2312564333064 "$node_(374) setdest 88010 31116 9.0" 
$ns at 588.9954537204802 "$node_(374) setdest 116695 20655 12.0" 
$ns at 716.7336436874474 "$node_(374) setdest 78528 31768 12.0" 
$ns at 811.5130513656892 "$node_(374) setdest 27978 21149 3.0" 
$ns at 858.0618805588729 "$node_(374) setdest 33926 20702 13.0" 
$ns at 335.0849858924747 "$node_(375) setdest 44205 40831 10.0" 
$ns at 395.0863873232529 "$node_(375) setdest 3777 5923 3.0" 
$ns at 426.58903670216705 "$node_(375) setdest 26961 15563 2.0" 
$ns at 461.4174756701007 "$node_(375) setdest 123970 15096 12.0" 
$ns at 596.9799237788789 "$node_(375) setdest 20186 18621 7.0" 
$ns at 629.8305420839878 "$node_(375) setdest 117286 12866 2.0" 
$ns at 673.1836744590413 "$node_(375) setdest 52538 38056 1.0" 
$ns at 711.74773582702 "$node_(375) setdest 14720 26439 13.0" 
$ns at 813.4557337877329 "$node_(375) setdest 14037 41761 19.0" 
$ns at 898.6991340400293 "$node_(375) setdest 39504 38921 8.0" 
$ns at 317.95661471401326 "$node_(376) setdest 51925 20424 10.0" 
$ns at 438.16052893879555 "$node_(376) setdest 95404 18164 18.0" 
$ns at 563.90136524679 "$node_(376) setdest 88039 39309 8.0" 
$ns at 629.3916107164664 "$node_(376) setdest 122630 40067 17.0" 
$ns at 666.8829063550164 "$node_(376) setdest 28925 13665 17.0" 
$ns at 760.1171089216523 "$node_(376) setdest 84130 22753 4.0" 
$ns at 794.3433346595236 "$node_(376) setdest 113253 18521 3.0" 
$ns at 841.3504513520282 "$node_(376) setdest 58306 15627 7.0" 
$ns at 880.8847577840347 "$node_(376) setdest 69073 20057 1.0" 
$ns at 342.0757162105184 "$node_(377) setdest 102588 5869 14.0" 
$ns at 412.17658013904895 "$node_(377) setdest 124223 20574 15.0" 
$ns at 545.4593207823089 "$node_(377) setdest 85679 16806 9.0" 
$ns at 655.4868653353686 "$node_(377) setdest 117567 30981 4.0" 
$ns at 725.2439579879583 "$node_(377) setdest 87948 29841 3.0" 
$ns at 771.4194519567943 "$node_(377) setdest 92055 3596 12.0" 
$ns at 887.4212950151182 "$node_(377) setdest 49742 26614 10.0" 
$ns at 345.9287020316142 "$node_(378) setdest 66383 644 8.0" 
$ns at 437.14711357432464 "$node_(378) setdest 36161 35102 15.0" 
$ns at 602.749131617623 "$node_(378) setdest 101949 31090 13.0" 
$ns at 709.551655063251 "$node_(378) setdest 50072 20871 5.0" 
$ns at 766.6656328243522 "$node_(378) setdest 105311 3349 18.0" 
$ns at 816.3437761070516 "$node_(378) setdest 33750 20490 17.0" 
$ns at 328.6967413571748 "$node_(379) setdest 95951 21508 13.0" 
$ns at 394.35636562515253 "$node_(379) setdest 119192 5164 7.0" 
$ns at 445.3364585530275 "$node_(379) setdest 54093 10268 13.0" 
$ns at 498.2160911823711 "$node_(379) setdest 128071 2380 3.0" 
$ns at 543.5951138085998 "$node_(379) setdest 45558 19841 15.0" 
$ns at 652.4694092922883 "$node_(379) setdest 23816 29348 5.0" 
$ns at 692.0594427790745 "$node_(379) setdest 52611 450 4.0" 
$ns at 736.8488435064505 "$node_(379) setdest 107831 27396 10.0" 
$ns at 818.2157889818391 "$node_(379) setdest 33283 39462 16.0" 
$ns at 867.5656848053629 "$node_(379) setdest 82151 15199 4.0" 
$ns at 327.3715938118947 "$node_(380) setdest 72650 34436 12.0" 
$ns at 449.3444400538385 "$node_(380) setdest 17692 41971 4.0" 
$ns at 493.39692255634975 "$node_(380) setdest 105279 37661 17.0" 
$ns at 620.3470356533718 "$node_(380) setdest 7871 5677 4.0" 
$ns at 680.6428107173181 "$node_(380) setdest 106143 22326 18.0" 
$ns at 768.4786246153299 "$node_(380) setdest 123759 31566 1.0" 
$ns at 798.9218687203771 "$node_(380) setdest 130756 41125 18.0" 
$ns at 391.98310868413813 "$node_(381) setdest 10618 27255 19.0" 
$ns at 456.1337801552158 "$node_(381) setdest 102301 6835 7.0" 
$ns at 490.5936255199349 "$node_(381) setdest 3647 24399 10.0" 
$ns at 538.6047846184179 "$node_(381) setdest 24721 38066 6.0" 
$ns at 604.6058036754087 "$node_(381) setdest 105013 32585 8.0" 
$ns at 698.4822616926776 "$node_(381) setdest 25705 6058 12.0" 
$ns at 831.5795260796714 "$node_(381) setdest 22471 16611 3.0" 
$ns at 882.7174623823499 "$node_(381) setdest 5356 16226 4.0" 
$ns at 407.4344546317478 "$node_(382) setdest 24613 3869 10.0" 
$ns at 484.15539828373403 "$node_(382) setdest 52550 37700 4.0" 
$ns at 546.2333831204287 "$node_(382) setdest 77264 4721 12.0" 
$ns at 591.1154086891181 "$node_(382) setdest 30157 13736 17.0" 
$ns at 766.5975542781092 "$node_(382) setdest 3908 28814 2.0" 
$ns at 809.3913188867396 "$node_(382) setdest 94544 22901 19.0" 
$ns at 379.70624910853167 "$node_(383) setdest 81713 37339 14.0" 
$ns at 475.6911993470082 "$node_(383) setdest 120138 6163 3.0" 
$ns at 523.3487945004678 "$node_(383) setdest 103677 13471 9.0" 
$ns at 599.6786602015321 "$node_(383) setdest 110841 13926 7.0" 
$ns at 638.3680373910234 "$node_(383) setdest 116561 33148 2.0" 
$ns at 687.2807232182217 "$node_(383) setdest 49273 2265 19.0" 
$ns at 885.6139301051429 "$node_(383) setdest 16609 3717 1.0" 
$ns at 351.1225240751254 "$node_(384) setdest 104773 44404 20.0" 
$ns at 411.5390298571569 "$node_(384) setdest 39996 30985 2.0" 
$ns at 455.6589179640469 "$node_(384) setdest 62083 44101 4.0" 
$ns at 502.5550503130292 "$node_(384) setdest 31931 20831 19.0" 
$ns at 722.0578900556029 "$node_(384) setdest 3956 1999 12.0" 
$ns at 802.2310180655578 "$node_(384) setdest 9551 251 12.0" 
$ns at 853.0186841113341 "$node_(384) setdest 1139 7475 9.0" 
$ns at 371.0983208500639 "$node_(385) setdest 48199 27538 1.0" 
$ns at 402.10277151873606 "$node_(385) setdest 130912 41933 5.0" 
$ns at 458.87507077981627 "$node_(385) setdest 20836 6302 5.0" 
$ns at 529.6533609858222 "$node_(385) setdest 102615 29292 10.0" 
$ns at 594.6003682624121 "$node_(385) setdest 91262 2493 2.0" 
$ns at 625.4105602096563 "$node_(385) setdest 54807 3685 5.0" 
$ns at 658.0772694389219 "$node_(385) setdest 6814 820 14.0" 
$ns at 705.0194168315174 "$node_(385) setdest 96884 8709 18.0" 
$ns at 850.025875048931 "$node_(385) setdest 90567 22998 14.0" 
$ns at 311.7634104368882 "$node_(386) setdest 83844 36720 2.0" 
$ns at 353.83405339958733 "$node_(386) setdest 33752 6679 10.0" 
$ns at 433.407557994469 "$node_(386) setdest 63628 42961 14.0" 
$ns at 468.50328340849035 "$node_(386) setdest 9319 31197 8.0" 
$ns at 506.5495769350799 "$node_(386) setdest 38777 15648 8.0" 
$ns at 563.2895580335925 "$node_(386) setdest 39452 8801 10.0" 
$ns at 679.4198317568555 "$node_(386) setdest 34367 42494 3.0" 
$ns at 712.9645504659339 "$node_(386) setdest 71054 9149 11.0" 
$ns at 748.7349454661799 "$node_(386) setdest 15533 18997 14.0" 
$ns at 806.8273203817776 "$node_(386) setdest 48884 8241 9.0" 
$ns at 845.2757331971728 "$node_(386) setdest 65215 178 3.0" 
$ns at 876.2402642889222 "$node_(386) setdest 132508 41862 1.0" 
$ns at 402.3623836736849 "$node_(387) setdest 47172 36163 20.0" 
$ns at 523.0139591117486 "$node_(387) setdest 104379 8881 17.0" 
$ns at 687.6356247288569 "$node_(387) setdest 106062 43143 14.0" 
$ns at 794.5965522030939 "$node_(387) setdest 79539 23096 8.0" 
$ns at 860.7840143075994 "$node_(387) setdest 103145 36060 18.0" 
$ns at 348.9914827708793 "$node_(388) setdest 66070 31361 12.0" 
$ns at 408.7201194672584 "$node_(388) setdest 15055 23740 19.0" 
$ns at 475.7859790994136 "$node_(388) setdest 28617 34858 3.0" 
$ns at 517.5733521415581 "$node_(388) setdest 120316 23570 8.0" 
$ns at 555.4988297336638 "$node_(388) setdest 38332 4402 11.0" 
$ns at 642.6330330051229 "$node_(388) setdest 107340 5043 1.0" 
$ns at 676.116690767689 "$node_(388) setdest 104877 23045 8.0" 
$ns at 723.7431040692345 "$node_(388) setdest 24523 22465 19.0" 
$ns at 780.552426777971 "$node_(388) setdest 67664 21520 11.0" 
$ns at 882.4604409847061 "$node_(388) setdest 74071 26652 4.0" 
$ns at 328.18893476459414 "$node_(389) setdest 90910 3626 17.0" 
$ns at 453.282930819993 "$node_(389) setdest 32615 32568 10.0" 
$ns at 528.1579547623793 "$node_(389) setdest 42746 1106 1.0" 
$ns at 558.3107713644862 "$node_(389) setdest 30517 7261 6.0" 
$ns at 589.7435159891579 "$node_(389) setdest 96718 684 14.0" 
$ns at 717.2234503088861 "$node_(389) setdest 125273 6553 14.0" 
$ns at 812.9506198984881 "$node_(389) setdest 62309 38196 13.0" 
$ns at 866.4494616313488 "$node_(389) setdest 74316 2053 4.0" 
$ns at 354.22737099824315 "$node_(390) setdest 24610 13717 13.0" 
$ns at 464.4059934267665 "$node_(390) setdest 521 40461 2.0" 
$ns at 513.5787450737182 "$node_(390) setdest 107278 22335 11.0" 
$ns at 627.2140966862974 "$node_(390) setdest 52820 44532 13.0" 
$ns at 777.1297610969666 "$node_(390) setdest 15843 30175 14.0" 
$ns at 817.9228368238861 "$node_(390) setdest 129884 27710 8.0" 
$ns at 338.4324493850154 "$node_(391) setdest 18031 12254 10.0" 
$ns at 408.4720114921972 "$node_(391) setdest 24895 13033 1.0" 
$ns at 444.9460599295467 "$node_(391) setdest 121645 23354 9.0" 
$ns at 502.2579589364957 "$node_(391) setdest 21473 40778 19.0" 
$ns at 538.5589780936955 "$node_(391) setdest 18432 13246 13.0" 
$ns at 668.35693069626 "$node_(391) setdest 6124 11100 16.0" 
$ns at 756.5766651343 "$node_(391) setdest 71963 36293 11.0" 
$ns at 867.0448316366688 "$node_(391) setdest 91092 29406 14.0" 
$ns at 310.42485707872396 "$node_(392) setdest 73536 6049 13.0" 
$ns at 434.3223144426161 "$node_(392) setdest 39927 39472 8.0" 
$ns at 481.6550683021219 "$node_(392) setdest 108075 37029 12.0" 
$ns at 603.2062104608731 "$node_(392) setdest 12695 32442 4.0" 
$ns at 643.4529623344201 "$node_(392) setdest 5260 1658 8.0" 
$ns at 748.1819317314146 "$node_(392) setdest 61225 44095 4.0" 
$ns at 794.5757282326996 "$node_(392) setdest 32225 6718 9.0" 
$ns at 898.8151335174778 "$node_(392) setdest 28312 26791 8.0" 
$ns at 310.75480893834754 "$node_(393) setdest 122059 19108 16.0" 
$ns at 362.83992701687146 "$node_(393) setdest 102315 29778 11.0" 
$ns at 481.5468378502466 "$node_(393) setdest 103632 26539 16.0" 
$ns at 536.8141890713786 "$node_(393) setdest 35113 9398 2.0" 
$ns at 567.5891181403631 "$node_(393) setdest 45011 3687 13.0" 
$ns at 712.5820145535237 "$node_(393) setdest 129594 28266 2.0" 
$ns at 742.7447776605856 "$node_(393) setdest 83638 42398 18.0" 
$ns at 815.5396635842961 "$node_(393) setdest 66520 3977 3.0" 
$ns at 865.699918854787 "$node_(393) setdest 12605 26994 16.0" 
$ns at 334.06518041971583 "$node_(394) setdest 37333 17917 5.0" 
$ns at 381.4794422377728 "$node_(394) setdest 35860 17803 13.0" 
$ns at 442.8457162835491 "$node_(394) setdest 96044 5073 12.0" 
$ns at 473.71555247322794 "$node_(394) setdest 79394 36706 18.0" 
$ns at 667.4570320550172 "$node_(394) setdest 122388 4081 19.0" 
$ns at 855.8367995410123 "$node_(394) setdest 35685 17164 18.0" 
$ns at 313.44507468259127 "$node_(395) setdest 41030 39617 15.0" 
$ns at 407.58186357776833 "$node_(395) setdest 28918 26506 18.0" 
$ns at 524.4267053148794 "$node_(395) setdest 92914 42276 6.0" 
$ns at 604.7153859447283 "$node_(395) setdest 33632 15640 18.0" 
$ns at 758.9173387276496 "$node_(395) setdest 52463 41203 17.0" 
$ns at 790.3372579903653 "$node_(395) setdest 25387 3807 2.0" 
$ns at 834.9371869298712 "$node_(395) setdest 5878 28986 10.0" 
$ns at 327.16139515480563 "$node_(396) setdest 14881 6126 9.0" 
$ns at 387.7707534793501 "$node_(396) setdest 92339 2810 2.0" 
$ns at 425.2777765692001 "$node_(396) setdest 104524 17650 9.0" 
$ns at 499.619111733269 "$node_(396) setdest 8989 4321 10.0" 
$ns at 538.4341228735669 "$node_(396) setdest 24197 40444 11.0" 
$ns at 621.9147636776299 "$node_(396) setdest 89001 39155 17.0" 
$ns at 763.313693158892 "$node_(396) setdest 29607 16966 2.0" 
$ns at 801.9971877312913 "$node_(396) setdest 52424 17268 9.0" 
$ns at 853.7104909983977 "$node_(396) setdest 24682 13653 13.0" 
$ns at 375.8787142419783 "$node_(397) setdest 52223 39501 4.0" 
$ns at 442.3645568107488 "$node_(397) setdest 79209 8647 4.0" 
$ns at 493.5181348247443 "$node_(397) setdest 116411 31406 4.0" 
$ns at 544.4954171794111 "$node_(397) setdest 103337 7442 10.0" 
$ns at 656.6456544896537 "$node_(397) setdest 70469 34482 11.0" 
$ns at 689.3877078930747 "$node_(397) setdest 98128 18382 1.0" 
$ns at 722.3170384945213 "$node_(397) setdest 85986 31537 8.0" 
$ns at 773.2343039192039 "$node_(397) setdest 74706 25511 9.0" 
$ns at 838.9688699888056 "$node_(397) setdest 17132 19858 17.0" 
$ns at 357.46161231930137 "$node_(398) setdest 12236 9499 2.0" 
$ns at 397.3858415630411 "$node_(398) setdest 33066 33429 6.0" 
$ns at 455.8132035986846 "$node_(398) setdest 27031 16996 16.0" 
$ns at 525.6717286499172 "$node_(398) setdest 120362 8479 15.0" 
$ns at 579.4670497592166 "$node_(398) setdest 124556 42527 16.0" 
$ns at 658.7239088307514 "$node_(398) setdest 98719 38560 4.0" 
$ns at 695.3879887464956 "$node_(398) setdest 121296 28162 16.0" 
$ns at 779.5603354398194 "$node_(398) setdest 129535 8941 7.0" 
$ns at 864.3499221228918 "$node_(398) setdest 31681 25389 8.0" 
$ns at 336.9046504121647 "$node_(399) setdest 6964 3962 7.0" 
$ns at 391.0949288984697 "$node_(399) setdest 42753 9494 1.0" 
$ns at 428.5963681953911 "$node_(399) setdest 1124 16393 11.0" 
$ns at 497.7418620542244 "$node_(399) setdest 79576 5468 7.0" 
$ns at 590.0436423441469 "$node_(399) setdest 13179 24781 11.0" 
$ns at 623.1728409499901 "$node_(399) setdest 107713 34598 14.0" 
$ns at 771.73302530983 "$node_(399) setdest 133760 32669 14.0" 
$ns at 429.3255385711475 "$node_(400) setdest 39139 15592 19.0" 
$ns at 477.3819447213717 "$node_(400) setdest 112952 44122 12.0" 
$ns at 525.5224657501667 "$node_(400) setdest 38230 16782 11.0" 
$ns at 641.3618212233241 "$node_(400) setdest 71342 20379 11.0" 
$ns at 714.110173129271 "$node_(400) setdest 85904 26116 7.0" 
$ns at 746.7332995818481 "$node_(400) setdest 18911 38712 10.0" 
$ns at 875.0681646666837 "$node_(400) setdest 77975 2562 16.0" 
$ns at 426.5909711976971 "$node_(401) setdest 3013 6095 8.0" 
$ns at 512.9898860268652 "$node_(401) setdest 109063 38944 16.0" 
$ns at 698.2164544749635 "$node_(401) setdest 77465 40271 15.0" 
$ns at 858.1708859160302 "$node_(401) setdest 90021 37238 19.0" 
$ns at 438.87991516631683 "$node_(402) setdest 38688 9279 2.0" 
$ns at 473.3343420051895 "$node_(402) setdest 41269 17010 6.0" 
$ns at 541.5521541404879 "$node_(402) setdest 46613 526 13.0" 
$ns at 602.7924080329303 "$node_(402) setdest 5015 8602 9.0" 
$ns at 720.0939829775253 "$node_(402) setdest 58765 40561 13.0" 
$ns at 771.2660298319381 "$node_(402) setdest 91259 640 10.0" 
$ns at 401.5184735748133 "$node_(403) setdest 59415 16107 14.0" 
$ns at 457.0631613376613 "$node_(403) setdest 47826 27065 9.0" 
$ns at 500.42598467606547 "$node_(403) setdest 80120 7336 17.0" 
$ns at 556.680541886605 "$node_(403) setdest 34764 894 12.0" 
$ns at 688.7861985318254 "$node_(403) setdest 4725 13641 14.0" 
$ns at 796.362965651091 "$node_(403) setdest 90744 25193 14.0" 
$ns at 878.9360091682731 "$node_(403) setdest 54146 25803 17.0" 
$ns at 489.9474612951397 "$node_(404) setdest 46744 24417 7.0" 
$ns at 552.6343135428002 "$node_(404) setdest 21928 9735 11.0" 
$ns at 602.2459240651003 "$node_(404) setdest 47333 33858 16.0" 
$ns at 752.6052155704392 "$node_(404) setdest 46895 34330 13.0" 
$ns at 831.1231399721453 "$node_(404) setdest 31459 41122 14.0" 
$ns at 481.2940354742628 "$node_(405) setdest 64945 44707 2.0" 
$ns at 529.503360607501 "$node_(405) setdest 53410 9074 12.0" 
$ns at 650.4653357141704 "$node_(405) setdest 36525 36160 16.0" 
$ns at 770.5261796484798 "$node_(405) setdest 87797 19825 10.0" 
$ns at 822.6139589241857 "$node_(405) setdest 129937 36519 15.0" 
$ns at 433.697611707456 "$node_(406) setdest 70084 18302 19.0" 
$ns at 465.8755331192681 "$node_(406) setdest 127863 18224 15.0" 
$ns at 615.6412293565459 "$node_(406) setdest 63779 44444 18.0" 
$ns at 707.7754491540562 "$node_(406) setdest 3186 29642 1.0" 
$ns at 745.9941553156602 "$node_(406) setdest 9941 23038 12.0" 
$ns at 833.3965677549293 "$node_(406) setdest 6090 20247 19.0" 
$ns at 874.9843908820492 "$node_(406) setdest 118740 34071 10.0" 
$ns at 574.6311783467194 "$node_(407) setdest 63454 18368 8.0" 
$ns at 627.8489711490192 "$node_(407) setdest 57679 34460 20.0" 
$ns at 822.8906256310556 "$node_(407) setdest 96691 13954 2.0" 
$ns at 858.4158078322658 "$node_(407) setdest 121260 21305 2.0" 
$ns at 534.5497056856992 "$node_(408) setdest 35041 27372 4.0" 
$ns at 566.6014539811979 "$node_(408) setdest 79083 8711 11.0" 
$ns at 706.3463540435821 "$node_(408) setdest 112498 16691 1.0" 
$ns at 745.0921555459378 "$node_(408) setdest 104198 25451 16.0" 
$ns at 819.0998130489188 "$node_(408) setdest 124438 25494 13.0" 
$ns at 416.5330775544295 "$node_(409) setdest 109154 33194 3.0" 
$ns at 468.563937530262 "$node_(409) setdest 122914 1524 16.0" 
$ns at 543.1540970875968 "$node_(409) setdest 128255 24338 11.0" 
$ns at 614.391876186362 "$node_(409) setdest 5810 37552 9.0" 
$ns at 707.3437308137495 "$node_(409) setdest 130221 6707 18.0" 
$ns at 805.8135280694404 "$node_(409) setdest 32193 6394 9.0" 
$ns at 495.3330621746045 "$node_(410) setdest 23499 15066 15.0" 
$ns at 596.9808803895469 "$node_(410) setdest 88078 21928 5.0" 
$ns at 650.6521576596533 "$node_(410) setdest 37244 33863 17.0" 
$ns at 730.4028392675145 "$node_(410) setdest 30294 12347 13.0" 
$ns at 813.8433475049227 "$node_(410) setdest 67682 17909 12.0" 
$ns at 403.5347275220958 "$node_(411) setdest 50822 40829 18.0" 
$ns at 602.7361749994119 "$node_(411) setdest 54012 819 7.0" 
$ns at 637.4106118425673 "$node_(411) setdest 91862 38386 9.0" 
$ns at 680.5595015366425 "$node_(411) setdest 77350 30982 2.0" 
$ns at 723.8329046594116 "$node_(411) setdest 124939 18547 13.0" 
$ns at 787.6278972941031 "$node_(411) setdest 31668 25308 7.0" 
$ns at 830.3071329615111 "$node_(411) setdest 33326 6834 7.0" 
$ns at 877.9275794240226 "$node_(411) setdest 20532 25224 8.0" 
$ns at 427.7120372493006 "$node_(412) setdest 65386 36672 5.0" 
$ns at 458.15351246641484 "$node_(412) setdest 66373 30667 4.0" 
$ns at 502.2514219368723 "$node_(412) setdest 93737 16892 12.0" 
$ns at 602.6593756329131 "$node_(412) setdest 3213 21070 5.0" 
$ns at 678.5092430923844 "$node_(412) setdest 57338 11237 11.0" 
$ns at 771.8291043612942 "$node_(412) setdest 53202 2201 20.0" 
$ns at 845.5015479600321 "$node_(412) setdest 116283 3906 10.0" 
$ns at 481.98987801873454 "$node_(413) setdest 26206 18699 5.0" 
$ns at 531.7237548377383 "$node_(413) setdest 6473 13872 4.0" 
$ns at 564.9758192524562 "$node_(413) setdest 17522 10030 4.0" 
$ns at 602.1823386338854 "$node_(413) setdest 61999 2041 13.0" 
$ns at 699.7967913676841 "$node_(413) setdest 29596 36918 11.0" 
$ns at 786.5113286382096 "$node_(413) setdest 114552 20047 14.0" 
$ns at 842.0149197112491 "$node_(413) setdest 60501 36379 11.0" 
$ns at 403.3015217575337 "$node_(414) setdest 42193 28337 18.0" 
$ns at 434.1771696729255 "$node_(414) setdest 57512 11091 18.0" 
$ns at 555.94612366603 "$node_(414) setdest 62189 12203 13.0" 
$ns at 598.3247341392952 "$node_(414) setdest 33056 34594 10.0" 
$ns at 695.3746302244424 "$node_(414) setdest 94514 39889 6.0" 
$ns at 750.7793140676345 "$node_(414) setdest 52600 41845 11.0" 
$ns at 825.2168240287797 "$node_(414) setdest 99327 36049 8.0" 
$ns at 878.0166533329203 "$node_(414) setdest 100532 13026 20.0" 
$ns at 401.2497265375945 "$node_(415) setdest 129645 21957 20.0" 
$ns at 517.5267454842893 "$node_(415) setdest 107803 41592 2.0" 
$ns at 564.7624668134525 "$node_(415) setdest 5768 20652 13.0" 
$ns at 673.186250813787 "$node_(415) setdest 65800 3589 3.0" 
$ns at 716.1486734796416 "$node_(415) setdest 108156 6673 18.0" 
$ns at 881.1779308012059 "$node_(415) setdest 28524 35247 13.0" 
$ns at 413.43667322057115 "$node_(416) setdest 123665 14128 14.0" 
$ns at 455.8389336113678 "$node_(416) setdest 70936 2378 4.0" 
$ns at 500.20003978372864 "$node_(416) setdest 125479 10910 9.0" 
$ns at 586.2505423488238 "$node_(416) setdest 114067 9418 2.0" 
$ns at 635.6192400905204 "$node_(416) setdest 9559 41960 10.0" 
$ns at 699.4172958662759 "$node_(416) setdest 57033 4548 4.0" 
$ns at 741.6949356896107 "$node_(416) setdest 91632 11999 19.0" 
$ns at 883.0702929867603 "$node_(416) setdest 116301 18543 5.0" 
$ns at 459.00605792934596 "$node_(417) setdest 69147 29800 1.0" 
$ns at 490.5888623137345 "$node_(417) setdest 2552 1286 1.0" 
$ns at 527.457852891461 "$node_(417) setdest 83063 36593 6.0" 
$ns at 561.5134084711644 "$node_(417) setdest 27913 15757 3.0" 
$ns at 595.2269466681443 "$node_(417) setdest 103979 21102 19.0" 
$ns at 788.314510510397 "$node_(417) setdest 56249 21289 11.0" 
$ns at 898.7859554329624 "$node_(417) setdest 125150 13853 10.0" 
$ns at 400.2100051843337 "$node_(418) setdest 21915 19356 17.0" 
$ns at 483.300765205517 "$node_(418) setdest 13704 14001 16.0" 
$ns at 526.0112631738078 "$node_(418) setdest 38005 3202 13.0" 
$ns at 628.3467347880191 "$node_(418) setdest 80307 31321 9.0" 
$ns at 696.9344300140381 "$node_(418) setdest 103954 43475 9.0" 
$ns at 746.8643599672303 "$node_(418) setdest 117019 16308 15.0" 
$ns at 419.6387026918908 "$node_(419) setdest 100415 21103 13.0" 
$ns at 470.8290995948913 "$node_(419) setdest 34323 36332 10.0" 
$ns at 509.70141223816546 "$node_(419) setdest 55915 41816 10.0" 
$ns at 628.3527775406145 "$node_(419) setdest 62436 38807 6.0" 
$ns at 684.6146514289479 "$node_(419) setdest 50867 15566 15.0" 
$ns at 820.2156873030701 "$node_(419) setdest 96212 39309 12.0" 
$ns at 852.0182466160937 "$node_(419) setdest 79156 22673 1.0" 
$ns at 885.5741986269747 "$node_(419) setdest 78072 40630 15.0" 
$ns at 456.734920722895 "$node_(420) setdest 102242 5561 9.0" 
$ns at 510.2838176602027 "$node_(420) setdest 7866 44455 4.0" 
$ns at 543.1900530362926 "$node_(420) setdest 2273 22496 17.0" 
$ns at 622.703043073423 "$node_(420) setdest 44324 23903 6.0" 
$ns at 695.2767796167972 "$node_(420) setdest 13755 12913 1.0" 
$ns at 728.1494750801546 "$node_(420) setdest 48951 12848 20.0" 
$ns at 778.6057794367852 "$node_(420) setdest 67591 43079 8.0" 
$ns at 872.3509007871796 "$node_(420) setdest 2873 17806 8.0" 
$ns at 411.81364634663856 "$node_(421) setdest 39569 13420 16.0" 
$ns at 525.0572037122166 "$node_(421) setdest 2640 7699 1.0" 
$ns at 563.0566156549534 "$node_(421) setdest 41850 28437 3.0" 
$ns at 595.9346960873598 "$node_(421) setdest 76796 33676 1.0" 
$ns at 627.349244075496 "$node_(421) setdest 27194 6073 8.0" 
$ns at 727.2230131238017 "$node_(421) setdest 2386 31541 11.0" 
$ns at 852.4104523293075 "$node_(421) setdest 98298 2330 17.0" 
$ns at 450.2487499310512 "$node_(422) setdest 69272 23658 10.0" 
$ns at 516.86049012955 "$node_(422) setdest 112542 5728 2.0" 
$ns at 557.4079435807852 "$node_(422) setdest 75443 30703 15.0" 
$ns at 684.1418995121253 "$node_(422) setdest 57117 6334 10.0" 
$ns at 781.8257023377912 "$node_(422) setdest 2269 9984 17.0" 
$ns at 818.802933847159 "$node_(422) setdest 92701 6920 8.0" 
$ns at 886.2624565251141 "$node_(422) setdest 48074 31312 9.0" 
$ns at 419.4388756245069 "$node_(423) setdest 130583 40838 13.0" 
$ns at 484.16405783254936 "$node_(423) setdest 3068 18044 1.0" 
$ns at 520.6697303761867 "$node_(423) setdest 113782 44115 12.0" 
$ns at 634.2341551801621 "$node_(423) setdest 70663 29765 17.0" 
$ns at 792.475538091035 "$node_(423) setdest 10983 11907 16.0" 
$ns at 840.6199777985768 "$node_(423) setdest 12088 42646 1.0" 
$ns at 878.764334589915 "$node_(423) setdest 53238 32803 2.0" 
$ns at 488.72232622201943 "$node_(424) setdest 15509 3391 11.0" 
$ns at 569.4883651246887 "$node_(424) setdest 105650 24936 1.0" 
$ns at 605.481104259072 "$node_(424) setdest 58482 43415 5.0" 
$ns at 653.0716069360819 "$node_(424) setdest 2385 380 13.0" 
$ns at 799.3644671223059 "$node_(424) setdest 68217 22647 3.0" 
$ns at 833.9791411772826 "$node_(424) setdest 19271 24134 10.0" 
$ns at 895.6436512173796 "$node_(424) setdest 31143 37503 15.0" 
$ns at 478.20834958005753 "$node_(425) setdest 82706 19690 8.0" 
$ns at 579.7907903110485 "$node_(425) setdest 113826 23000 10.0" 
$ns at 706.0977550434682 "$node_(425) setdest 82898 27096 9.0" 
$ns at 775.0342100931916 "$node_(425) setdest 84118 33177 17.0" 
$ns at 435.1098826870202 "$node_(426) setdest 117061 42237 1.0" 
$ns at 471.63193753598676 "$node_(426) setdest 55260 37749 17.0" 
$ns at 502.8034650879275 "$node_(426) setdest 113979 22817 6.0" 
$ns at 539.1475624442282 "$node_(426) setdest 111240 31367 11.0" 
$ns at 589.8534943062145 "$node_(426) setdest 76552 4326 15.0" 
$ns at 656.0745946051834 "$node_(426) setdest 52570 42320 18.0" 
$ns at 695.0299826396893 "$node_(426) setdest 126153 22172 4.0" 
$ns at 752.9920617551551 "$node_(426) setdest 68242 654 1.0" 
$ns at 792.7707256378463 "$node_(426) setdest 25393 28868 17.0" 
$ns at 490.82977751068404 "$node_(427) setdest 121865 4554 6.0" 
$ns at 526.6165062215954 "$node_(427) setdest 98292 15465 7.0" 
$ns at 600.86153779525 "$node_(427) setdest 46958 20092 14.0" 
$ns at 656.9550459590519 "$node_(427) setdest 61907 14202 1.0" 
$ns at 688.0410878784069 "$node_(427) setdest 9949 33818 3.0" 
$ns at 743.3484645046586 "$node_(427) setdest 115828 23985 7.0" 
$ns at 774.8752953761469 "$node_(427) setdest 12237 21558 3.0" 
$ns at 805.1033057448763 "$node_(427) setdest 41968 28222 1.0" 
$ns at 838.7569273486561 "$node_(427) setdest 9495 11237 4.0" 
$ns at 426.5141820746868 "$node_(428) setdest 70810 38144 15.0" 
$ns at 487.6125232841887 "$node_(428) setdest 55657 18534 19.0" 
$ns at 648.8504873963025 "$node_(428) setdest 122884 38221 5.0" 
$ns at 716.9548752741898 "$node_(428) setdest 96115 28519 18.0" 
$ns at 899.4960918283675 "$node_(428) setdest 114763 33074 6.0" 
$ns at 410.11799868973344 "$node_(429) setdest 42090 43580 8.0" 
$ns at 443.61874077277577 "$node_(429) setdest 110753 31161 12.0" 
$ns at 580.9408415955071 "$node_(429) setdest 133694 5969 17.0" 
$ns at 646.1078702621505 "$node_(429) setdest 81786 21120 10.0" 
$ns at 716.4299095575313 "$node_(429) setdest 96916 3068 11.0" 
$ns at 785.6422473100886 "$node_(429) setdest 4879 44087 19.0" 
$ns at 881.947245996152 "$node_(429) setdest 38978 41152 2.0" 
$ns at 425.64109231705197 "$node_(430) setdest 86156 12192 5.0" 
$ns at 457.5572961752615 "$node_(430) setdest 13190 11197 12.0" 
$ns at 576.6650862673447 "$node_(430) setdest 58279 11558 4.0" 
$ns at 614.6326599901815 "$node_(430) setdest 114459 17892 16.0" 
$ns at 748.5054863580558 "$node_(430) setdest 60098 33087 18.0" 
$ns at 884.1702753057375 "$node_(430) setdest 33226 43708 5.0" 
$ns at 426.12333609666126 "$node_(431) setdest 30298 13345 8.0" 
$ns at 475.64739527894125 "$node_(431) setdest 42221 1915 6.0" 
$ns at 523.2091737324366 "$node_(431) setdest 33332 34533 13.0" 
$ns at 612.1371656878575 "$node_(431) setdest 72565 23784 9.0" 
$ns at 672.523916624339 "$node_(431) setdest 79063 25943 9.0" 
$ns at 703.0706828776981 "$node_(431) setdest 12422 31742 13.0" 
$ns at 798.9407346813341 "$node_(431) setdest 103607 28165 20.0" 
$ns at 418.6895577860368 "$node_(432) setdest 77577 8453 8.0" 
$ns at 473.79263831692714 "$node_(432) setdest 51680 15179 15.0" 
$ns at 625.0808071461202 "$node_(432) setdest 97614 42147 16.0" 
$ns at 739.7132532105776 "$node_(432) setdest 100214 31898 14.0" 
$ns at 835.85612616173 "$node_(432) setdest 123636 35103 17.0" 
$ns at 522.8938082695627 "$node_(433) setdest 70276 34639 7.0" 
$ns at 605.2032725152256 "$node_(433) setdest 130750 15490 18.0" 
$ns at 693.1204153750327 "$node_(433) setdest 28677 13484 9.0" 
$ns at 760.0599337063416 "$node_(433) setdest 41127 5255 16.0" 
$ns at 897.9465011553074 "$node_(433) setdest 46089 42208 4.0" 
$ns at 562.119957396851 "$node_(434) setdest 41708 12621 1.0" 
$ns at 598.8075301852831 "$node_(434) setdest 112528 37467 3.0" 
$ns at 640.0226445501789 "$node_(434) setdest 73296 903 9.0" 
$ns at 748.4142814209567 "$node_(434) setdest 17397 15319 2.0" 
$ns at 785.3025901926192 "$node_(434) setdest 96228 43064 15.0" 
$ns at 836.46271641099 "$node_(434) setdest 90389 15065 8.0" 
$ns at 426.8272759192556 "$node_(435) setdest 47171 34989 19.0" 
$ns at 485.8550925879438 "$node_(435) setdest 35057 34327 4.0" 
$ns at 527.8960479270663 "$node_(435) setdest 73511 13261 10.0" 
$ns at 623.953433560756 "$node_(435) setdest 86284 23610 9.0" 
$ns at 720.4602556128297 "$node_(435) setdest 1122 25049 2.0" 
$ns at 751.8328060279257 "$node_(435) setdest 99747 32549 6.0" 
$ns at 810.404942807453 "$node_(435) setdest 33157 9500 11.0" 
$ns at 420.4605167835198 "$node_(436) setdest 90726 12629 12.0" 
$ns at 566.5497613325979 "$node_(436) setdest 32138 11526 7.0" 
$ns at 620.5749612995431 "$node_(436) setdest 112635 30316 2.0" 
$ns at 666.0374253702765 "$node_(436) setdest 109103 18788 18.0" 
$ns at 813.8997858740167 "$node_(436) setdest 102710 36085 3.0" 
$ns at 860.65729258871 "$node_(436) setdest 4325 1303 6.0" 
$ns at 418.6714162557872 "$node_(437) setdest 109779 20148 10.0" 
$ns at 515.3797884351321 "$node_(437) setdest 43268 13763 8.0" 
$ns at 553.80073518773 "$node_(437) setdest 62899 4079 1.0" 
$ns at 585.7241693592156 "$node_(437) setdest 93894 4931 19.0" 
$ns at 652.4998069385593 "$node_(437) setdest 93054 23169 9.0" 
$ns at 732.1154714379318 "$node_(437) setdest 14998 4673 15.0" 
$ns at 797.5938280887019 "$node_(437) setdest 19536 1528 18.0" 
$ns at 421.3379711958413 "$node_(438) setdest 618 35525 14.0" 
$ns at 475.00214482856063 "$node_(438) setdest 111274 33229 14.0" 
$ns at 575.6063757798717 "$node_(438) setdest 68356 37006 11.0" 
$ns at 694.1119703927137 "$node_(438) setdest 109319 406 6.0" 
$ns at 772.4316252322901 "$node_(438) setdest 77560 9349 11.0" 
$ns at 835.5506221021778 "$node_(438) setdest 46210 23736 15.0" 
$ns at 506.02664529882594 "$node_(439) setdest 37946 39414 17.0" 
$ns at 557.5996940729783 "$node_(439) setdest 36119 37646 13.0" 
$ns at 617.8890581696314 "$node_(439) setdest 10249 20342 16.0" 
$ns at 664.4391754451311 "$node_(439) setdest 45791 6446 14.0" 
$ns at 723.4917269411087 "$node_(439) setdest 63434 4950 5.0" 
$ns at 758.8541421397857 "$node_(439) setdest 55114 37692 11.0" 
$ns at 883.0616471708294 "$node_(439) setdest 9876 43885 10.0" 
$ns at 445.97955758971057 "$node_(440) setdest 117740 4174 4.0" 
$ns at 494.2814242177249 "$node_(440) setdest 30348 42731 2.0" 
$ns at 535.480185815309 "$node_(440) setdest 12262 6888 11.0" 
$ns at 589.2444003507778 "$node_(440) setdest 640 25859 7.0" 
$ns at 665.4655969857989 "$node_(440) setdest 124991 44203 7.0" 
$ns at 706.9482105945943 "$node_(440) setdest 112475 18626 3.0" 
$ns at 754.2805785918296 "$node_(440) setdest 132302 26099 6.0" 
$ns at 797.0054790541923 "$node_(440) setdest 81434 31129 3.0" 
$ns at 842.9119712965729 "$node_(440) setdest 133801 16459 17.0" 
$ns at 460.22034131054 "$node_(441) setdest 69949 40670 13.0" 
$ns at 519.219473245865 "$node_(441) setdest 127995 3369 3.0" 
$ns at 577.7291306102446 "$node_(441) setdest 21399 44691 3.0" 
$ns at 619.3699485411545 "$node_(441) setdest 20637 21136 13.0" 
$ns at 706.4200040640085 "$node_(441) setdest 91485 16133 14.0" 
$ns at 855.3952250079594 "$node_(441) setdest 67243 40160 1.0" 
$ns at 889.8535068553641 "$node_(441) setdest 60685 5023 7.0" 
$ns at 515.5622873693455 "$node_(442) setdest 47265 6120 12.0" 
$ns at 574.0137269283672 "$node_(442) setdest 70394 20695 1.0" 
$ns at 613.1291272051425 "$node_(442) setdest 64158 19775 13.0" 
$ns at 646.9978747928892 "$node_(442) setdest 106421 5042 6.0" 
$ns at 718.8974458422668 "$node_(442) setdest 38394 37107 16.0" 
$ns at 407.57574199741805 "$node_(443) setdest 3745 39401 1.0" 
$ns at 445.13826600258017 "$node_(443) setdest 115934 28432 9.0" 
$ns at 504.24936944656395 "$node_(443) setdest 50757 13589 20.0" 
$ns at 570.8730915137464 "$node_(443) setdest 121667 36409 15.0" 
$ns at 729.6302404406852 "$node_(443) setdest 109212 7734 4.0" 
$ns at 775.0166884347202 "$node_(443) setdest 130176 10769 15.0" 
$ns at 831.9081790278206 "$node_(443) setdest 32503 5291 13.0" 
$ns at 494.0577088575867 "$node_(444) setdest 63095 1095 17.0" 
$ns at 636.2772598707758 "$node_(444) setdest 20715 29471 8.0" 
$ns at 683.2554722274732 "$node_(444) setdest 27983 41820 16.0" 
$ns at 869.9648621783854 "$node_(444) setdest 10389 26705 5.0" 
$ns at 529.9605945266238 "$node_(445) setdest 18253 2007 13.0" 
$ns at 632.4659294620792 "$node_(445) setdest 76304 26087 20.0" 
$ns at 705.1276558373256 "$node_(445) setdest 36505 386 7.0" 
$ns at 802.0717143816813 "$node_(445) setdest 125035 22712 14.0" 
$ns at 427.6608592524845 "$node_(446) setdest 105223 40695 12.0" 
$ns at 542.418700387388 "$node_(446) setdest 43318 29488 8.0" 
$ns at 632.4194820449616 "$node_(446) setdest 6904 617 7.0" 
$ns at 666.0675560709545 "$node_(446) setdest 133774 6060 12.0" 
$ns at 705.0442354902616 "$node_(446) setdest 103743 43384 14.0" 
$ns at 849.9761361188055 "$node_(446) setdest 21318 38914 2.0" 
$ns at 889.6534065233271 "$node_(446) setdest 97258 25775 1.0" 
$ns at 410.7045903377826 "$node_(447) setdest 674 7334 14.0" 
$ns at 497.295391103269 "$node_(447) setdest 3427 4661 9.0" 
$ns at 584.122749084981 "$node_(447) setdest 75313 40606 4.0" 
$ns at 631.8803941391434 "$node_(447) setdest 104681 25531 18.0" 
$ns at 722.6986845220379 "$node_(447) setdest 108168 42501 20.0" 
$ns at 895.0471902403001 "$node_(447) setdest 21824 12196 12.0" 
$ns at 430.26625500474745 "$node_(448) setdest 112386 43724 18.0" 
$ns at 626.1707771695501 "$node_(448) setdest 28934 38414 3.0" 
$ns at 683.717006335519 "$node_(448) setdest 25956 19214 6.0" 
$ns at 731.1680591698671 "$node_(448) setdest 13367 33797 7.0" 
$ns at 807.9284190495221 "$node_(448) setdest 74848 18948 1.0" 
$ns at 842.7847276588584 "$node_(448) setdest 7259 3209 3.0" 
$ns at 876.6712954256889 "$node_(448) setdest 9194 1413 6.0" 
$ns at 440.9367258650944 "$node_(449) setdest 116869 17487 18.0" 
$ns at 490.0961213180785 "$node_(449) setdest 119524 17617 18.0" 
$ns at 539.5303146965659 "$node_(449) setdest 67252 37368 14.0" 
$ns at 583.9247924256953 "$node_(449) setdest 109937 42149 9.0" 
$ns at 695.2524801700758 "$node_(449) setdest 30907 34914 19.0" 
$ns at 834.4467681890953 "$node_(449) setdest 64299 28767 15.0" 
$ns at 439.46635567268004 "$node_(450) setdest 129190 9451 1.0" 
$ns at 476.1852454046892 "$node_(450) setdest 51756 27667 7.0" 
$ns at 523.0938089567767 "$node_(450) setdest 58973 30513 18.0" 
$ns at 716.8010155433966 "$node_(450) setdest 90787 30511 9.0" 
$ns at 835.3579455940123 "$node_(450) setdest 99300 30882 12.0" 
$ns at 464.30978711017866 "$node_(451) setdest 124311 26315 16.0" 
$ns at 510.2525760334935 "$node_(451) setdest 67078 36321 9.0" 
$ns at 571.5433019085776 "$node_(451) setdest 21284 44650 14.0" 
$ns at 634.519137414373 "$node_(451) setdest 50939 42418 11.0" 
$ns at 672.4565991556225 "$node_(451) setdest 75983 35303 13.0" 
$ns at 809.4389657602301 "$node_(451) setdest 6893 9496 16.0" 
$ns at 860.1936546873475 "$node_(451) setdest 13553 28410 6.0" 
$ns at 460.8033077210524 "$node_(452) setdest 117061 4406 3.0" 
$ns at 502.2676539351962 "$node_(452) setdest 60031 1799 1.0" 
$ns at 540.0689487460535 "$node_(452) setdest 93388 26916 16.0" 
$ns at 669.0608346239102 "$node_(452) setdest 50522 41045 11.0" 
$ns at 747.3174434582231 "$node_(452) setdest 100392 24262 15.0" 
$ns at 781.8714269087027 "$node_(452) setdest 34604 28586 16.0" 
$ns at 416.7323794400881 "$node_(453) setdest 114543 5212 15.0" 
$ns at 582.9822240002113 "$node_(453) setdest 60764 28926 14.0" 
$ns at 716.5271546857283 "$node_(453) setdest 3416 23490 8.0" 
$ns at 760.434090428407 "$node_(453) setdest 63097 24356 1.0" 
$ns at 792.9222150267811 "$node_(453) setdest 130051 18485 9.0" 
$ns at 860.7157413725143 "$node_(453) setdest 64007 31893 16.0" 
$ns at 443.5197565203565 "$node_(454) setdest 132318 10717 1.0" 
$ns at 479.73072411599605 "$node_(454) setdest 12654 29524 2.0" 
$ns at 523.2302294911478 "$node_(454) setdest 86411 4460 2.0" 
$ns at 572.1893039250093 "$node_(454) setdest 16631 7878 4.0" 
$ns at 604.3085109594809 "$node_(454) setdest 67937 23358 7.0" 
$ns at 663.295497434236 "$node_(454) setdest 68065 19352 18.0" 
$ns at 841.8465809779104 "$node_(454) setdest 107763 39763 3.0" 
$ns at 882.6212273552012 "$node_(454) setdest 96808 34235 8.0" 
$ns at 404.7451586335728 "$node_(455) setdest 29711 39050 4.0" 
$ns at 464.61516676931274 "$node_(455) setdest 67532 15256 15.0" 
$ns at 516.0004401375224 "$node_(455) setdest 114562 34363 17.0" 
$ns at 625.1903989968904 "$node_(455) setdest 121487 7000 17.0" 
$ns at 700.353325382715 "$node_(455) setdest 70019 21888 7.0" 
$ns at 742.0879089480655 "$node_(455) setdest 78016 6438 2.0" 
$ns at 781.6334482390738 "$node_(455) setdest 66308 16668 5.0" 
$ns at 834.1277213205987 "$node_(455) setdest 12008 16751 4.0" 
$ns at 897.021329218322 "$node_(455) setdest 111501 13101 3.0" 
$ns at 435.5911113077003 "$node_(456) setdest 2007 41690 3.0" 
$ns at 474.0836178123052 "$node_(456) setdest 85816 22770 1.0" 
$ns at 505.5909440009834 "$node_(456) setdest 97737 36436 5.0" 
$ns at 552.9974831815928 "$node_(456) setdest 20021 36834 1.0" 
$ns at 588.4950762235753 "$node_(456) setdest 133227 28996 15.0" 
$ns at 742.6722397764966 "$node_(456) setdest 103320 18996 7.0" 
$ns at 818.3065522646759 "$node_(456) setdest 18002 1684 13.0" 
$ns at 419.44652783860477 "$node_(457) setdest 97895 5955 11.0" 
$ns at 462.30220013154315 "$node_(457) setdest 17985 14710 14.0" 
$ns at 544.4226730415198 "$node_(457) setdest 13081 20613 17.0" 
$ns at 649.6812886527022 "$node_(457) setdest 53783 911 19.0" 
$ns at 681.5813634029605 "$node_(457) setdest 14788 15010 15.0" 
$ns at 761.6446451944404 "$node_(457) setdest 37949 27939 16.0" 
$ns at 879.5070960655337 "$node_(457) setdest 132270 40876 10.0" 
$ns at 412.8419285441967 "$node_(458) setdest 102544 24819 10.0" 
$ns at 478.59713605492556 "$node_(458) setdest 117810 10024 13.0" 
$ns at 522.8689876771547 "$node_(458) setdest 99137 14751 1.0" 
$ns at 552.959336976701 "$node_(458) setdest 93941 21670 10.0" 
$ns at 616.6975231185991 "$node_(458) setdest 66010 28734 18.0" 
$ns at 803.579557606575 "$node_(458) setdest 116007 21040 15.0" 
$ns at 871.6113907495719 "$node_(458) setdest 4195 17022 6.0" 
$ns at 436.4417020892329 "$node_(459) setdest 126320 38739 13.0" 
$ns at 539.1043180646706 "$node_(459) setdest 14423 32186 13.0" 
$ns at 658.3940668367653 "$node_(459) setdest 68173 37560 16.0" 
$ns at 823.45298455223 "$node_(459) setdest 58915 11658 19.0" 
$ns at 883.9685001052661 "$node_(459) setdest 73722 35930 10.0" 
$ns at 418.23419596833656 "$node_(460) setdest 33220 11528 20.0" 
$ns at 511.36191149300794 "$node_(460) setdest 47619 11451 8.0" 
$ns at 570.8336471160881 "$node_(460) setdest 122360 11826 10.0" 
$ns at 658.8533268549728 "$node_(460) setdest 66750 27572 11.0" 
$ns at 774.031047580308 "$node_(460) setdest 132692 23757 16.0" 
$ns at 489.04859615973965 "$node_(461) setdest 23955 33269 6.0" 
$ns at 553.7354677388635 "$node_(461) setdest 105828 4928 17.0" 
$ns at 645.2961169195806 "$node_(461) setdest 28456 13538 11.0" 
$ns at 738.8064105369879 "$node_(461) setdest 18067 42615 1.0" 
$ns at 776.2547934575115 "$node_(461) setdest 114986 6968 8.0" 
$ns at 839.6449992883571 "$node_(461) setdest 64711 11035 11.0" 
$ns at 893.4504508107028 "$node_(461) setdest 102032 31330 18.0" 
$ns at 422.47593587555576 "$node_(462) setdest 46361 6865 5.0" 
$ns at 459.5422221922579 "$node_(462) setdest 122273 12180 17.0" 
$ns at 529.253750652686 "$node_(462) setdest 81334 22231 1.0" 
$ns at 567.1088050856933 "$node_(462) setdest 80556 39991 2.0" 
$ns at 603.5322502357094 "$node_(462) setdest 104559 36901 11.0" 
$ns at 722.6352423481552 "$node_(462) setdest 101372 412 9.0" 
$ns at 840.8001760495256 "$node_(462) setdest 57208 11797 13.0" 
$ns at 877.1756502437693 "$node_(462) setdest 81540 33956 5.0" 
$ns at 475.58865626493775 "$node_(463) setdest 132917 15285 2.0" 
$ns at 508.5005588036463 "$node_(463) setdest 91360 26776 6.0" 
$ns at 559.860656932981 "$node_(463) setdest 72113 11476 10.0" 
$ns at 643.7879750297266 "$node_(463) setdest 67703 41429 3.0" 
$ns at 702.5571343429505 "$node_(463) setdest 19124 17397 19.0" 
$ns at 894.6075233922033 "$node_(463) setdest 61625 15319 6.0" 
$ns at 454.6727682030537 "$node_(464) setdest 97088 11723 5.0" 
$ns at 520.5812776501906 "$node_(464) setdest 61066 5177 4.0" 
$ns at 583.2936378735127 "$node_(464) setdest 9975 31672 2.0" 
$ns at 630.7019506411056 "$node_(464) setdest 28167 41653 16.0" 
$ns at 690.298089322263 "$node_(464) setdest 29538 19501 8.0" 
$ns at 722.3372145220726 "$node_(464) setdest 133399 13927 20.0" 
$ns at 763.6426845780695 "$node_(464) setdest 40980 20725 19.0" 
$ns at 418.5406204032872 "$node_(465) setdest 8573 24195 8.0" 
$ns at 460.3885042469103 "$node_(465) setdest 76046 30570 1.0" 
$ns at 497.643566152283 "$node_(465) setdest 40550 8248 13.0" 
$ns at 633.5130773682441 "$node_(465) setdest 114333 8271 5.0" 
$ns at 674.0339279507986 "$node_(465) setdest 76143 33649 10.0" 
$ns at 758.2158561994391 "$node_(465) setdest 14581 8210 6.0" 
$ns at 803.3540307682815 "$node_(465) setdest 10625 4057 11.0" 
$ns at 886.3835216612744 "$node_(465) setdest 108470 30068 19.0" 
$ns at 408.34853681161826 "$node_(466) setdest 41490 41933 15.0" 
$ns at 499.5723057950707 "$node_(466) setdest 32692 32106 6.0" 
$ns at 575.8459575944551 "$node_(466) setdest 31030 7896 5.0" 
$ns at 635.3325631605223 "$node_(466) setdest 132929 10644 9.0" 
$ns at 715.037352916188 "$node_(466) setdest 128959 39059 18.0" 
$ns at 762.8588887654475 "$node_(466) setdest 25346 32351 20.0" 
$ns at 456.9526891542348 "$node_(467) setdest 45099 36028 17.0" 
$ns at 580.6879181978185 "$node_(467) setdest 53249 30960 20.0" 
$ns at 664.4072916072541 "$node_(467) setdest 97735 15866 1.0" 
$ns at 696.6738578745518 "$node_(467) setdest 34257 8736 11.0" 
$ns at 797.9401378002635 "$node_(467) setdest 53358 3400 3.0" 
$ns at 833.9237215269588 "$node_(467) setdest 16295 24654 9.0" 
$ns at 499.7732039384607 "$node_(468) setdest 53789 29429 1.0" 
$ns at 534.0393741139031 "$node_(468) setdest 11428 18984 8.0" 
$ns at 610.9474508659712 "$node_(468) setdest 36657 299 11.0" 
$ns at 661.6234860416275 "$node_(468) setdest 99328 19502 8.0" 
$ns at 757.0611881801403 "$node_(468) setdest 79371 19511 15.0" 
$ns at 896.7542572671164 "$node_(468) setdest 43287 43718 6.0" 
$ns at 464.41042378152486 "$node_(469) setdest 108784 21292 8.0" 
$ns at 510.34397364747986 "$node_(469) setdest 128653 4773 4.0" 
$ns at 576.989916860492 "$node_(469) setdest 76683 18013 3.0" 
$ns at 634.6393099797007 "$node_(469) setdest 68558 12064 7.0" 
$ns at 722.576297212415 "$node_(469) setdest 11149 1508 17.0" 
$ns at 892.5743160034933 "$node_(469) setdest 73032 7071 6.0" 
$ns at 428.2306420879264 "$node_(470) setdest 20900 33111 17.0" 
$ns at 533.8633514810422 "$node_(470) setdest 41667 37545 7.0" 
$ns at 625.8649983408077 "$node_(470) setdest 45989 27533 5.0" 
$ns at 681.2850140387163 "$node_(470) setdest 12271 25246 20.0" 
$ns at 831.6720714266874 "$node_(470) setdest 112873 17677 15.0" 
$ns at 451.6981992080483 "$node_(471) setdest 123660 4125 18.0" 
$ns at 493.38921968795177 "$node_(471) setdest 515 26413 20.0" 
$ns at 626.7648487868001 "$node_(471) setdest 64714 6320 19.0" 
$ns at 777.5936648057719 "$node_(471) setdest 22801 19563 8.0" 
$ns at 840.4216652186278 "$node_(471) setdest 17181 39646 7.0" 
$ns at 444.42937441977824 "$node_(472) setdest 1245 1906 18.0" 
$ns at 485.33556830672893 "$node_(472) setdest 97555 6948 20.0" 
$ns at 541.0259527204431 "$node_(472) setdest 97535 5631 1.0" 
$ns at 572.6991176604622 "$node_(472) setdest 90599 9609 7.0" 
$ns at 656.8635900558369 "$node_(472) setdest 92916 25708 5.0" 
$ns at 696.117032421216 "$node_(472) setdest 99673 31958 20.0" 
$ns at 414.31561474553274 "$node_(473) setdest 115748 9221 10.0" 
$ns at 530.3077700227678 "$node_(473) setdest 47340 12426 13.0" 
$ns at 676.636417492336 "$node_(473) setdest 15773 16836 4.0" 
$ns at 716.3155970955908 "$node_(473) setdest 2303 43645 12.0" 
$ns at 786.0462314884124 "$node_(473) setdest 6790 31333 5.0" 
$ns at 840.4420950293664 "$node_(473) setdest 129183 15029 4.0" 
$ns at 400.96225509452637 "$node_(474) setdest 49780 4501 18.0" 
$ns at 537.9607623496639 "$node_(474) setdest 115210 11148 18.0" 
$ns at 709.0532359613624 "$node_(474) setdest 34866 42122 13.0" 
$ns at 764.9655142040602 "$node_(474) setdest 6381 31714 10.0" 
$ns at 888.2244956560205 "$node_(474) setdest 76548 29486 3.0" 
$ns at 411.72749588518303 "$node_(475) setdest 61172 26185 14.0" 
$ns at 532.7446459957234 "$node_(475) setdest 75398 5853 6.0" 
$ns at 577.0399824237004 "$node_(475) setdest 130483 24091 19.0" 
$ns at 616.268040070711 "$node_(475) setdest 37550 5331 11.0" 
$ns at 732.6070684232785 "$node_(475) setdest 113641 17336 4.0" 
$ns at 781.8959291989895 "$node_(475) setdest 6864 24781 15.0" 
$ns at 443.8551304794307 "$node_(476) setdest 52770 24528 9.0" 
$ns at 476.7090799624424 "$node_(476) setdest 84810 31542 11.0" 
$ns at 597.1370710573947 "$node_(476) setdest 61624 33931 19.0" 
$ns at 797.6270177569847 "$node_(476) setdest 132932 24374 10.0" 
$ns at 471.29140510279836 "$node_(477) setdest 75026 5925 2.0" 
$ns at 501.93998718159247 "$node_(477) setdest 120518 22139 3.0" 
$ns at 558.9437576428663 "$node_(477) setdest 53509 36900 7.0" 
$ns at 598.8404157653513 "$node_(477) setdest 130608 3271 2.0" 
$ns at 640.0301149013475 "$node_(477) setdest 100035 21068 7.0" 
$ns at 739.8173704612757 "$node_(477) setdest 67099 32200 9.0" 
$ns at 804.5653611261013 "$node_(477) setdest 36372 8045 4.0" 
$ns at 872.7516457475159 "$node_(477) setdest 80950 23050 12.0" 
$ns at 434.19605799369515 "$node_(478) setdest 68908 22234 7.0" 
$ns at 484.53852863080954 "$node_(478) setdest 106196 34161 19.0" 
$ns at 522.0994751064349 "$node_(478) setdest 110693 11519 11.0" 
$ns at 596.5516625697468 "$node_(478) setdest 94483 12721 5.0" 
$ns at 630.125669056565 "$node_(478) setdest 123220 13136 16.0" 
$ns at 696.7179626570982 "$node_(478) setdest 92724 24196 14.0" 
$ns at 820.6689500704395 "$node_(478) setdest 10325 7524 9.0" 
$ns at 416.34197298923056 "$node_(479) setdest 4047 13905 15.0" 
$ns at 458.82752582262276 "$node_(479) setdest 67735 31506 17.0" 
$ns at 533.3492222006626 "$node_(479) setdest 117392 34727 2.0" 
$ns at 578.1377876035244 "$node_(479) setdest 124744 30911 5.0" 
$ns at 642.0535081981894 "$node_(479) setdest 65137 33963 16.0" 
$ns at 773.1829976140899 "$node_(479) setdest 128779 38136 2.0" 
$ns at 821.9431526345664 "$node_(479) setdest 15284 43026 4.0" 
$ns at 878.9272864063969 "$node_(479) setdest 12691 40426 18.0" 
$ns at 405.2969664820384 "$node_(480) setdest 50572 24626 18.0" 
$ns at 506.2887824596212 "$node_(480) setdest 55447 14968 19.0" 
$ns at 629.8696432969547 "$node_(480) setdest 104263 30565 5.0" 
$ns at 679.3066779655841 "$node_(480) setdest 106552 12883 18.0" 
$ns at 818.9492991907784 "$node_(480) setdest 99921 35582 14.0" 
$ns at 886.6993949627902 "$node_(480) setdest 74813 15456 4.0" 
$ns at 434.8790433855416 "$node_(481) setdest 131495 27996 18.0" 
$ns at 510.3919537355946 "$node_(481) setdest 65140 6255 14.0" 
$ns at 545.1003635930786 "$node_(481) setdest 17909 44421 15.0" 
$ns at 607.6806360320421 "$node_(481) setdest 30751 2735 2.0" 
$ns at 643.0880193057394 "$node_(481) setdest 129236 38001 12.0" 
$ns at 678.3608963371828 "$node_(481) setdest 107605 19953 10.0" 
$ns at 769.5604875576331 "$node_(481) setdest 12157 32942 7.0" 
$ns at 864.1428756947977 "$node_(481) setdest 20756 22075 16.0" 
$ns at 421.6949309017432 "$node_(482) setdest 9954 21260 15.0" 
$ns at 502.2108196628255 "$node_(482) setdest 64428 30815 8.0" 
$ns at 539.8070981429304 "$node_(482) setdest 19233 23857 6.0" 
$ns at 594.1032055556276 "$node_(482) setdest 11075 31084 12.0" 
$ns at 644.3432254141627 "$node_(482) setdest 7008 15001 2.0" 
$ns at 675.578615115162 "$node_(482) setdest 108873 37026 12.0" 
$ns at 817.504029143394 "$node_(482) setdest 116225 14102 8.0" 
$ns at 404.387738998599 "$node_(483) setdest 21597 16771 16.0" 
$ns at 456.1958397121351 "$node_(483) setdest 32826 33031 15.0" 
$ns at 508.19729444513575 "$node_(483) setdest 14055 35615 17.0" 
$ns at 594.9780440173312 "$node_(483) setdest 60207 1665 3.0" 
$ns at 631.5832181321286 "$node_(483) setdest 10868 25772 5.0" 
$ns at 708.7517237617251 "$node_(483) setdest 89910 44252 11.0" 
$ns at 835.5258519455315 "$node_(483) setdest 60839 38016 12.0" 
$ns at 428.4435059659276 "$node_(484) setdest 28759 13403 19.0" 
$ns at 498.0226012511807 "$node_(484) setdest 233 15946 9.0" 
$ns at 543.0897930892747 "$node_(484) setdest 106148 42932 12.0" 
$ns at 628.3933693332804 "$node_(484) setdest 22928 13179 3.0" 
$ns at 666.484841068644 "$node_(484) setdest 72470 825 6.0" 
$ns at 744.1450716702823 "$node_(484) setdest 58006 19826 2.0" 
$ns at 788.1186394552296 "$node_(484) setdest 59248 28066 15.0" 
$ns at 497.39647781187614 "$node_(485) setdest 76110 24898 6.0" 
$ns at 545.9496395991961 "$node_(485) setdest 93834 8977 9.0" 
$ns at 645.2000467010323 "$node_(485) setdest 45262 44470 3.0" 
$ns at 699.222023951718 "$node_(485) setdest 41066 36102 12.0" 
$ns at 806.1583915333628 "$node_(485) setdest 103806 39236 1.0" 
$ns at 842.8915595352087 "$node_(485) setdest 13212 43486 15.0" 
$ns at 412.4987301937325 "$node_(486) setdest 11901 27724 9.0" 
$ns at 494.2109914228523 "$node_(486) setdest 49446 677 5.0" 
$ns at 572.0675879125779 "$node_(486) setdest 96999 31912 20.0" 
$ns at 650.8294918088895 "$node_(486) setdest 111288 12330 5.0" 
$ns at 695.3158394695669 "$node_(486) setdest 37748 14361 14.0" 
$ns at 744.3771302546533 "$node_(486) setdest 126519 40188 5.0" 
$ns at 806.8905603929245 "$node_(486) setdest 114333 7557 8.0" 
$ns at 867.7647958121918 "$node_(486) setdest 8170 3375 8.0" 
$ns at 527.2609282450354 "$node_(487) setdest 102379 16465 8.0" 
$ns at 611.9202100027167 "$node_(487) setdest 100848 41992 12.0" 
$ns at 745.1513162585667 "$node_(487) setdest 56330 666 18.0" 
$ns at 405.3095103727837 "$node_(488) setdest 63779 37526 20.0" 
$ns at 563.374049710214 "$node_(488) setdest 124946 30352 7.0" 
$ns at 611.3614889666031 "$node_(488) setdest 105403 30945 12.0" 
$ns at 642.9245264868628 "$node_(488) setdest 73293 833 1.0" 
$ns at 678.6768661575043 "$node_(488) setdest 39424 30438 5.0" 
$ns at 734.8710628723596 "$node_(488) setdest 100940 33843 8.0" 
$ns at 812.8184280022522 "$node_(488) setdest 21294 26522 6.0" 
$ns at 878.5359518462226 "$node_(488) setdest 93442 22223 15.0" 
$ns at 419.8783728410074 "$node_(489) setdest 92892 6632 7.0" 
$ns at 462.67165217714916 "$node_(489) setdest 124943 6480 3.0" 
$ns at 503.0047133233908 "$node_(489) setdest 84491 41243 16.0" 
$ns at 617.4547785313085 "$node_(489) setdest 92254 21698 4.0" 
$ns at 673.1178270213803 "$node_(489) setdest 89153 15257 17.0" 
$ns at 729.0023224061006 "$node_(489) setdest 4470 7901 6.0" 
$ns at 759.8323949106959 "$node_(489) setdest 58238 43384 4.0" 
$ns at 813.0251650852522 "$node_(489) setdest 59106 14673 17.0" 
$ns at 467.92912066350596 "$node_(490) setdest 75868 672 9.0" 
$ns at 504.45559716416204 "$node_(490) setdest 90766 20960 16.0" 
$ns at 601.8090881128722 "$node_(490) setdest 65103 26143 3.0" 
$ns at 643.4949656494083 "$node_(490) setdest 90877 24330 7.0" 
$ns at 695.262751074445 "$node_(490) setdest 10470 40018 14.0" 
$ns at 818.8630136953464 "$node_(490) setdest 21477 5692 18.0" 
$ns at 457.1664561193192 "$node_(491) setdest 42323 4650 12.0" 
$ns at 532.7910569341003 "$node_(491) setdest 67283 14767 1.0" 
$ns at 568.5436865915564 "$node_(491) setdest 49171 40350 6.0" 
$ns at 629.1084833588569 "$node_(491) setdest 57717 16096 16.0" 
$ns at 708.6682809106841 "$node_(491) setdest 50488 11201 20.0" 
$ns at 810.7150924711227 "$node_(491) setdest 16377 29804 7.0" 
$ns at 518.0366482657403 "$node_(492) setdest 40081 19803 1.0" 
$ns at 549.2204036337907 "$node_(492) setdest 106340 42706 6.0" 
$ns at 596.8814047156397 "$node_(492) setdest 132419 7988 4.0" 
$ns at 638.9285144146447 "$node_(492) setdest 8015 21133 4.0" 
$ns at 679.508251885433 "$node_(492) setdest 86237 38995 19.0" 
$ns at 836.4493660750834 "$node_(492) setdest 103745 19547 10.0" 
$ns at 437.9334095379982 "$node_(493) setdest 75087 27508 20.0" 
$ns at 553.3515070605597 "$node_(493) setdest 76617 42169 16.0" 
$ns at 708.0261837537857 "$node_(493) setdest 13979 11515 4.0" 
$ns at 774.4167249193424 "$node_(493) setdest 80139 24522 4.0" 
$ns at 841.6966007024843 "$node_(493) setdest 95781 11648 12.0" 
$ns at 472.51477511994597 "$node_(494) setdest 61344 5730 17.0" 
$ns at 528.2341564702514 "$node_(494) setdest 56955 14582 1.0" 
$ns at 568.101593538383 "$node_(494) setdest 16224 559 1.0" 
$ns at 599.490797553776 "$node_(494) setdest 39232 26683 10.0" 
$ns at 647.7320072844102 "$node_(494) setdest 62602 37880 7.0" 
$ns at 687.4607601418161 "$node_(494) setdest 49168 36738 7.0" 
$ns at 723.7317817885495 "$node_(494) setdest 118280 29374 6.0" 
$ns at 790.9257623412286 "$node_(494) setdest 45554 9135 8.0" 
$ns at 898.0271516170641 "$node_(494) setdest 98075 29837 1.0" 
$ns at 537.8491626749079 "$node_(495) setdest 112980 36050 7.0" 
$ns at 587.1909861291352 "$node_(495) setdest 26299 548 5.0" 
$ns at 637.6385639409793 "$node_(495) setdest 77431 12785 1.0" 
$ns at 673.5319975102857 "$node_(495) setdest 20245 38704 10.0" 
$ns at 715.7056692278613 "$node_(495) setdest 6694 33174 20.0" 
$ns at 810.7809885588647 "$node_(495) setdest 131070 14913 17.0" 
$ns at 463.98380282559253 "$node_(496) setdest 110270 43648 7.0" 
$ns at 525.1742393256156 "$node_(496) setdest 108977 42953 8.0" 
$ns at 579.8075150089107 "$node_(496) setdest 83730 44046 18.0" 
$ns at 732.9328603270565 "$node_(496) setdest 8028 33300 1.0" 
$ns at 765.5894028607281 "$node_(496) setdest 19588 2517 4.0" 
$ns at 813.2143013156668 "$node_(496) setdest 124585 22161 20.0" 
$ns at 431.92260526509597 "$node_(497) setdest 81798 32955 4.0" 
$ns at 492.51509268483676 "$node_(497) setdest 24982 8292 11.0" 
$ns at 557.9898591893225 "$node_(497) setdest 121360 14809 11.0" 
$ns at 615.2601855168057 "$node_(497) setdest 82766 41993 12.0" 
$ns at 728.6979290154807 "$node_(497) setdest 119589 18816 3.0" 
$ns at 774.7895843580334 "$node_(497) setdest 53580 5043 4.0" 
$ns at 805.8687708873406 "$node_(497) setdest 95630 22858 15.0" 
$ns at 410.10100691283424 "$node_(498) setdest 52314 19566 15.0" 
$ns at 471.6209863116852 "$node_(498) setdest 48117 13655 16.0" 
$ns at 558.2032069461095 "$node_(498) setdest 66421 18798 1.0" 
$ns at 591.4486323441351 "$node_(498) setdest 10525 9574 8.0" 
$ns at 688.0634640793432 "$node_(498) setdest 85249 19860 19.0" 
$ns at 750.5168504734033 "$node_(498) setdest 63688 36829 7.0" 
$ns at 805.5668262046996 "$node_(498) setdest 73320 14171 4.0" 
$ns at 870.4653428930928 "$node_(498) setdest 10930 42098 9.0" 
$ns at 447.31218062024783 "$node_(499) setdest 26947 18287 18.0" 
$ns at 504.980582353215 "$node_(499) setdest 68404 40560 9.0" 
$ns at 583.3015392285188 "$node_(499) setdest 123092 33219 2.0" 
$ns at 619.4171217825161 "$node_(499) setdest 4028 12465 10.0" 
$ns at 665.9232163519923 "$node_(499) setdest 62740 23122 13.0" 
$ns at 777.0217838059202 "$node_(499) setdest 9624 15794 15.0" 
$ns at 882.4072874612386 "$node_(499) setdest 132674 29565 7.0" 
$ns at 679.2206229866604 "$node_(500) setdest 124205 31716 16.0" 
$ns at 844.5331238155484 "$node_(500) setdest 40415 3658 3.0" 
$ns at 562.7471793481772 "$node_(501) setdest 74486 41042 9.0" 
$ns at 642.6812909977166 "$node_(501) setdest 123177 5541 1.0" 
$ns at 673.2000626083814 "$node_(501) setdest 86466 3492 16.0" 
$ns at 786.1640985501665 "$node_(501) setdest 24014 7608 13.0" 
$ns at 876.5004266073609 "$node_(501) setdest 54318 6738 10.0" 
$ns at 610.8148176824685 "$node_(502) setdest 86876 3245 12.0" 
$ns at 749.6791208353884 "$node_(502) setdest 57126 22 15.0" 
$ns at 523.1582634030442 "$node_(503) setdest 38160 19185 5.0" 
$ns at 586.9244910337271 "$node_(503) setdest 49812 10102 9.0" 
$ns at 641.5203524161677 "$node_(503) setdest 48942 40476 12.0" 
$ns at 707.8836756476874 "$node_(503) setdest 24187 21670 3.0" 
$ns at 741.6012719436784 "$node_(503) setdest 103035 25666 1.0" 
$ns at 780.3394835192938 "$node_(503) setdest 62736 26690 17.0" 
$ns at 834.7805845424257 "$node_(503) setdest 2666 284 6.0" 
$ns at 897.1679123777394 "$node_(503) setdest 92909 24096 16.0" 
$ns at 586.8468434985082 "$node_(504) setdest 92841 33521 8.0" 
$ns at 622.4365852324222 "$node_(504) setdest 95178 16499 2.0" 
$ns at 668.1370317523613 "$node_(504) setdest 93576 7616 8.0" 
$ns at 711.7347608845712 "$node_(504) setdest 27906 20647 6.0" 
$ns at 762.6720754686535 "$node_(504) setdest 102683 37599 15.0" 
$ns at 870.9509313478053 "$node_(504) setdest 31423 33756 1.0" 
$ns at 535.1968752738152 "$node_(505) setdest 45505 6648 18.0" 
$ns at 580.1207295935003 "$node_(505) setdest 60975 20098 8.0" 
$ns at 665.8561686744516 "$node_(505) setdest 54383 20101 6.0" 
$ns at 730.2093410956383 "$node_(505) setdest 17198 39945 9.0" 
$ns at 809.9361092875822 "$node_(505) setdest 98298 42008 11.0" 
$ns at 867.1872229592401 "$node_(505) setdest 103 26381 12.0" 
$ns at 587.2406898330578 "$node_(506) setdest 13427 23308 10.0" 
$ns at 637.3545400944615 "$node_(506) setdest 94625 43837 2.0" 
$ns at 680.7766374815997 "$node_(506) setdest 31525 44706 17.0" 
$ns at 749.5811265680915 "$node_(506) setdest 129142 22521 10.0" 
$ns at 877.4004748770251 "$node_(506) setdest 79152 37643 4.0" 
$ns at 520.2962425807766 "$node_(507) setdest 66633 40569 5.0" 
$ns at 585.3139721909986 "$node_(507) setdest 110542 7575 15.0" 
$ns at 624.0864850083454 "$node_(507) setdest 71023 16706 14.0" 
$ns at 655.8396065924278 "$node_(507) setdest 54087 17732 6.0" 
$ns at 742.5665228326131 "$node_(507) setdest 103078 37911 15.0" 
$ns at 774.7918496919038 "$node_(507) setdest 72555 13795 13.0" 
$ns at 863.2877020525124 "$node_(507) setdest 131608 24488 16.0" 
$ns at 546.6631052821797 "$node_(508) setdest 85190 23834 1.0" 
$ns at 581.5570526424294 "$node_(508) setdest 73499 23132 16.0" 
$ns at 668.1689106883445 "$node_(508) setdest 99430 14310 16.0" 
$ns at 745.9599220236124 "$node_(508) setdest 47184 2667 1.0" 
$ns at 784.27758640061 "$node_(508) setdest 89795 42196 2.0" 
$ns at 818.6947966613318 "$node_(508) setdest 10444 20173 6.0" 
$ns at 898.6189958418397 "$node_(508) setdest 46615 39441 14.0" 
$ns at 530.3204577490039 "$node_(509) setdest 117856 778 11.0" 
$ns at 570.5666117666823 "$node_(509) setdest 3440 28951 1.0" 
$ns at 608.8485847912671 "$node_(509) setdest 20440 39913 1.0" 
$ns at 640.2461370918561 "$node_(509) setdest 132535 15889 9.0" 
$ns at 694.8011243859642 "$node_(509) setdest 71725 20880 1.0" 
$ns at 729.2796734701735 "$node_(509) setdest 125518 24289 11.0" 
$ns at 851.4322247235967 "$node_(509) setdest 49727 7020 12.0" 
$ns at 534.628094311408 "$node_(510) setdest 130623 42340 14.0" 
$ns at 608.1486701671394 "$node_(510) setdest 68923 18371 9.0" 
$ns at 722.4828297457605 "$node_(510) setdest 33406 21270 12.0" 
$ns at 868.2514191575954 "$node_(510) setdest 54972 39671 10.0" 
$ns at 507.4871570203979 "$node_(511) setdest 75626 40317 11.0" 
$ns at 629.8336350983643 "$node_(511) setdest 36228 17029 3.0" 
$ns at 688.9877165743864 "$node_(511) setdest 41497 2598 18.0" 
$ns at 885.5958978865839 "$node_(511) setdest 41611 7309 14.0" 
$ns at 510.3187182877856 "$node_(512) setdest 5765 25064 15.0" 
$ns at 568.4461438479836 "$node_(512) setdest 102857 23316 5.0" 
$ns at 634.3499159800119 "$node_(512) setdest 86167 33522 9.0" 
$ns at 671.1372104448484 "$node_(512) setdest 78170 10667 16.0" 
$ns at 727.0106877602178 "$node_(512) setdest 90387 32439 6.0" 
$ns at 776.6400257832604 "$node_(512) setdest 52689 7452 11.0" 
$ns at 809.1550768915664 "$node_(512) setdest 68782 2828 5.0" 
$ns at 861.7290404435048 "$node_(512) setdest 126094 5997 13.0" 
$ns at 511.3620272287761 "$node_(513) setdest 80829 42384 7.0" 
$ns at 606.6656347467864 "$node_(513) setdest 14296 30479 20.0" 
$ns at 797.3562510379484 "$node_(513) setdest 83528 23846 4.0" 
$ns at 845.1198672137648 "$node_(513) setdest 80656 31192 17.0" 
$ns at 890.6084234468996 "$node_(513) setdest 97765 11257 2.0" 
$ns at 553.7659113819507 "$node_(514) setdest 113612 25038 10.0" 
$ns at 650.1492921432282 "$node_(514) setdest 133301 29303 10.0" 
$ns at 697.3036308871854 "$node_(514) setdest 56008 40021 2.0" 
$ns at 735.0939284355644 "$node_(514) setdest 35511 34118 1.0" 
$ns at 770.1443415709861 "$node_(514) setdest 27558 27706 6.0" 
$ns at 838.423842724117 "$node_(514) setdest 10998 36464 4.0" 
$ns at 876.6329868958475 "$node_(514) setdest 2636 3558 14.0" 
$ns at 518.5509426572087 "$node_(515) setdest 7271 36019 2.0" 
$ns at 550.9029913265649 "$node_(515) setdest 11819 43787 7.0" 
$ns at 581.8798469936661 "$node_(515) setdest 103783 38094 5.0" 
$ns at 645.2637609615024 "$node_(515) setdest 4086 26492 3.0" 
$ns at 684.9025209781867 "$node_(515) setdest 1017 20889 20.0" 
$ns at 740.5733756704283 "$node_(515) setdest 92550 28360 20.0" 
$ns at 529.7621240749019 "$node_(516) setdest 74382 32805 5.0" 
$ns at 591.9082227575625 "$node_(516) setdest 58694 44502 18.0" 
$ns at 696.9248575969328 "$node_(516) setdest 2001 2397 5.0" 
$ns at 773.8611509355042 "$node_(516) setdest 24870 30975 7.0" 
$ns at 837.6921665322062 "$node_(516) setdest 67319 4058 18.0" 
$ns at 579.3949670543558 "$node_(517) setdest 65186 24029 17.0" 
$ns at 725.3780881678277 "$node_(517) setdest 112488 21640 2.0" 
$ns at 771.6527231921738 "$node_(517) setdest 122886 9823 2.0" 
$ns at 820.9622663748828 "$node_(517) setdest 42401 14861 3.0" 
$ns at 877.1864907990105 "$node_(517) setdest 87459 11353 7.0" 
$ns at 507.0857734787336 "$node_(518) setdest 38053 25570 10.0" 
$ns at 576.5187807371683 "$node_(518) setdest 8353 9979 18.0" 
$ns at 746.1960735549409 "$node_(518) setdest 119206 40193 20.0" 
$ns at 806.7278667145918 "$node_(518) setdest 131023 23321 19.0" 
$ns at 625.8308695508451 "$node_(519) setdest 83593 2126 9.0" 
$ns at 671.8162793559388 "$node_(519) setdest 104794 37817 1.0" 
$ns at 701.867347921879 "$node_(519) setdest 82721 41410 9.0" 
$ns at 762.1882297318014 "$node_(519) setdest 97876 20169 3.0" 
$ns at 803.3263735450474 "$node_(519) setdest 81601 18362 15.0" 
$ns at 871.7180494187946 "$node_(519) setdest 72566 42777 16.0" 
$ns at 547.1883506319398 "$node_(520) setdest 118456 7424 20.0" 
$ns at 642.4042191097668 "$node_(520) setdest 12038 27115 19.0" 
$ns at 767.8589290899347 "$node_(520) setdest 49030 2730 1.0" 
$ns at 799.3438912304141 "$node_(520) setdest 67132 43354 5.0" 
$ns at 854.7205639327893 "$node_(520) setdest 101485 4078 13.0" 
$ns at 896.3368502664605 "$node_(520) setdest 120675 6039 13.0" 
$ns at 563.5179854600526 "$node_(521) setdest 75904 33548 4.0" 
$ns at 624.8550428055634 "$node_(521) setdest 38250 42746 11.0" 
$ns at 734.1581540087986 "$node_(521) setdest 49671 22356 8.0" 
$ns at 816.974575485179 "$node_(521) setdest 8284 4170 11.0" 
$ns at 681.2455287215596 "$node_(522) setdest 85370 4116 16.0" 
$ns at 753.9039306036715 "$node_(522) setdest 48573 9846 18.0" 
$ns at 839.0047933194137 "$node_(522) setdest 30709 43962 16.0" 
$ns at 889.2840796652373 "$node_(522) setdest 32618 1756 7.0" 
$ns at 507.54989925324935 "$node_(523) setdest 22726 41300 18.0" 
$ns at 583.5641488751414 "$node_(523) setdest 130779 19931 8.0" 
$ns at 678.2971841835343 "$node_(523) setdest 94179 4087 2.0" 
$ns at 709.5850208943804 "$node_(523) setdest 77903 6496 5.0" 
$ns at 768.735774339179 "$node_(523) setdest 32498 52 14.0" 
$ns at 538.0117715451009 "$node_(524) setdest 9002 2176 1.0" 
$ns at 576.0281026090368 "$node_(524) setdest 47519 26140 4.0" 
$ns at 617.9421365192582 "$node_(524) setdest 81007 25246 13.0" 
$ns at 652.1662448973739 "$node_(524) setdest 1359 7757 19.0" 
$ns at 819.129624679215 "$node_(524) setdest 10323 14703 17.0" 
$ns at 566.0823498866577 "$node_(525) setdest 83132 21681 10.0" 
$ns at 635.5140182500118 "$node_(525) setdest 72295 40498 20.0" 
$ns at 791.6073190131624 "$node_(525) setdest 61372 19970 8.0" 
$ns at 844.7589858044151 "$node_(525) setdest 43637 7168 5.0" 
$ns at 504.2793574030788 "$node_(526) setdest 87618 13448 5.0" 
$ns at 541.3882027055756 "$node_(526) setdest 25090 21590 7.0" 
$ns at 606.1365355756616 "$node_(526) setdest 25665 3498 9.0" 
$ns at 646.9227324495648 "$node_(526) setdest 83000 43486 3.0" 
$ns at 681.1348266649119 "$node_(526) setdest 65621 10817 15.0" 
$ns at 771.4435107015461 "$node_(526) setdest 97801 14099 2.0" 
$ns at 810.5981003931329 "$node_(526) setdest 7849 14040 9.0" 
$ns at 562.4003636315205 "$node_(527) setdest 83086 24447 13.0" 
$ns at 647.3637636683983 "$node_(527) setdest 95306 26859 19.0" 
$ns at 690.6999532068719 "$node_(527) setdest 82300 43450 6.0" 
$ns at 736.7022920041504 "$node_(527) setdest 88925 36398 17.0" 
$ns at 586.8840266682663 "$node_(528) setdest 63272 41443 17.0" 
$ns at 686.0283460060818 "$node_(528) setdest 19191 35336 9.0" 
$ns at 727.8484635873971 "$node_(528) setdest 109066 38224 6.0" 
$ns at 781.9819681283602 "$node_(528) setdest 37268 13335 13.0" 
$ns at 871.308160498823 "$node_(528) setdest 121057 19140 12.0" 
$ns at 501.1637487880699 "$node_(529) setdest 63218 20849 5.0" 
$ns at 535.6522038213078 "$node_(529) setdest 33504 13232 11.0" 
$ns at 634.5532049634048 "$node_(529) setdest 31830 31246 11.0" 
$ns at 667.5009831280662 "$node_(529) setdest 35832 47 16.0" 
$ns at 830.3475867641895 "$node_(529) setdest 112429 24724 1.0" 
$ns at 860.5221154764154 "$node_(529) setdest 127710 19757 10.0" 
$ns at 507.44210595405826 "$node_(530) setdest 666 925 11.0" 
$ns at 560.169652585984 "$node_(530) setdest 31133 28942 17.0" 
$ns at 615.6217343066667 "$node_(530) setdest 106194 43800 11.0" 
$ns at 707.9103909245796 "$node_(530) setdest 108670 11013 11.0" 
$ns at 793.0950047143062 "$node_(530) setdest 30301 35483 17.0" 
$ns at 858.8503531300444 "$node_(530) setdest 21624 17968 17.0" 
$ns at 502.06934931110226 "$node_(531) setdest 100393 16162 19.0" 
$ns at 641.6374751897089 "$node_(531) setdest 31838 3505 6.0" 
$ns at 678.3082347631383 "$node_(531) setdest 56117 27258 2.0" 
$ns at 709.1849313032344 "$node_(531) setdest 71603 14285 6.0" 
$ns at 763.4032115172126 "$node_(531) setdest 119577 32131 6.0" 
$ns at 806.2561953752481 "$node_(531) setdest 29655 34032 14.0" 
$ns at 883.4981005062783 "$node_(531) setdest 113345 42033 2.0" 
$ns at 622.8893005269384 "$node_(532) setdest 26632 44258 5.0" 
$ns at 695.512673229754 "$node_(532) setdest 130219 23629 3.0" 
$ns at 740.0439205468367 "$node_(532) setdest 81102 360 13.0" 
$ns at 849.3154016294649 "$node_(532) setdest 80232 19637 7.0" 
$ns at 524.4946821406392 "$node_(533) setdest 14670 9609 9.0" 
$ns at 619.0970949981121 "$node_(533) setdest 66699 28221 14.0" 
$ns at 768.9614356966871 "$node_(533) setdest 21332 11781 15.0" 
$ns at 870.3657206245603 "$node_(533) setdest 20529 17951 10.0" 
$ns at 518.788176089737 "$node_(534) setdest 7960 8849 15.0" 
$ns at 554.4922021177963 "$node_(534) setdest 76039 23194 5.0" 
$ns at 619.1623455502792 "$node_(534) setdest 121511 28880 9.0" 
$ns at 708.8693706929157 "$node_(534) setdest 42842 9867 5.0" 
$ns at 753.2574387210884 "$node_(534) setdest 44573 24085 8.0" 
$ns at 824.4314266459728 "$node_(534) setdest 110842 9239 4.0" 
$ns at 884.9260807810672 "$node_(534) setdest 110054 34568 3.0" 
$ns at 518.6591145115636 "$node_(535) setdest 104309 37719 17.0" 
$ns at 625.0938606348093 "$node_(535) setdest 67580 38173 17.0" 
$ns at 799.389253100172 "$node_(535) setdest 38063 37251 14.0" 
$ns at 514.2495218496123 "$node_(536) setdest 26634 25413 2.0" 
$ns at 547.9172054716967 "$node_(536) setdest 130266 30142 11.0" 
$ns at 589.0120924456893 "$node_(536) setdest 87916 31389 1.0" 
$ns at 623.1875999913264 "$node_(536) setdest 120329 27462 10.0" 
$ns at 743.5733149654332 "$node_(536) setdest 22465 37458 17.0" 
$ns at 828.6999475920027 "$node_(536) setdest 12384 34926 20.0" 
$ns at 520.4056265811067 "$node_(537) setdest 7957 1467 9.0" 
$ns at 603.9003088318168 "$node_(537) setdest 67376 37879 14.0" 
$ns at 716.6071314448468 "$node_(537) setdest 82451 43489 10.0" 
$ns at 791.9957698941198 "$node_(537) setdest 55812 3364 5.0" 
$ns at 857.0848680546706 "$node_(537) setdest 2222 23006 6.0" 
$ns at 576.3214435805015 "$node_(538) setdest 72474 42124 19.0" 
$ns at 766.2526073031954 "$node_(538) setdest 5470 42517 17.0" 
$ns at 527.096342208156 "$node_(539) setdest 12125 40843 1.0" 
$ns at 560.4649186609797 "$node_(539) setdest 41865 3562 20.0" 
$ns at 632.5260506932059 "$node_(539) setdest 40876 5162 1.0" 
$ns at 666.4841962974004 "$node_(539) setdest 134070 4487 1.0" 
$ns at 703.654553897903 "$node_(539) setdest 130770 14582 19.0" 
$ns at 528.9022189913749 "$node_(540) setdest 77463 41196 19.0" 
$ns at 699.1711151784081 "$node_(540) setdest 127622 35607 13.0" 
$ns at 813.5810924247226 "$node_(540) setdest 63857 41759 10.0" 
$ns at 579.9721106218207 "$node_(541) setdest 104874 36442 14.0" 
$ns at 738.5943864114679 "$node_(541) setdest 85639 39006 1.0" 
$ns at 771.1529855045748 "$node_(541) setdest 102203 39040 4.0" 
$ns at 831.7513978036383 "$node_(541) setdest 39330 3752 5.0" 
$ns at 889.184093274002 "$node_(541) setdest 12937 39524 3.0" 
$ns at 557.3175007351043 "$node_(542) setdest 117414 3056 11.0" 
$ns at 592.8846812686735 "$node_(542) setdest 115316 11436 6.0" 
$ns at 649.095309997117 "$node_(542) setdest 10371 23779 3.0" 
$ns at 699.4870374262722 "$node_(542) setdest 120229 39993 10.0" 
$ns at 751.2405343077708 "$node_(542) setdest 114375 10427 12.0" 
$ns at 809.326423159258 "$node_(542) setdest 118643 27449 14.0" 
$ns at 854.8041230058678 "$node_(542) setdest 122799 735 19.0" 
$ns at 558.8024689778623 "$node_(543) setdest 6502 15825 8.0" 
$ns at 611.4035178452727 "$node_(543) setdest 81841 3021 6.0" 
$ns at 666.3578521888732 "$node_(543) setdest 122872 19713 3.0" 
$ns at 725.8227541083502 "$node_(543) setdest 8056 10589 1.0" 
$ns at 760.1479337224233 "$node_(543) setdest 138 32938 13.0" 
$ns at 794.0300587096948 "$node_(543) setdest 93345 43357 1.0" 
$ns at 831.0304055264193 "$node_(543) setdest 94685 8333 16.0" 
$ns at 605.9903862577044 "$node_(544) setdest 129357 4651 14.0" 
$ns at 773.077967764064 "$node_(544) setdest 57958 37751 3.0" 
$ns at 813.0361955134783 "$node_(544) setdest 126548 35787 14.0" 
$ns at 520.0582641298354 "$node_(545) setdest 126672 29165 16.0" 
$ns at 623.449670896634 "$node_(545) setdest 108956 4530 6.0" 
$ns at 707.8302027537226 "$node_(545) setdest 82967 11985 13.0" 
$ns at 739.5553015871342 "$node_(545) setdest 98237 12422 16.0" 
$ns at 821.0054951324036 "$node_(545) setdest 101648 4312 2.0" 
$ns at 859.8024413451501 "$node_(545) setdest 39928 78 3.0" 
$ns at 899.9421917751635 "$node_(545) setdest 38303 30041 19.0" 
$ns at 598.8033383896592 "$node_(546) setdest 24834 39427 2.0" 
$ns at 629.3748450998935 "$node_(546) setdest 106334 6645 2.0" 
$ns at 669.1111405093482 "$node_(546) setdest 122923 8215 5.0" 
$ns at 714.7947850992164 "$node_(546) setdest 118902 29843 16.0" 
$ns at 823.2614500922185 "$node_(546) setdest 28920 28797 12.0" 
$ns at 869.3532223635541 "$node_(546) setdest 2259 22829 12.0" 
$ns at 659.3363089952084 "$node_(547) setdest 103333 40364 2.0" 
$ns at 692.3859951269661 "$node_(547) setdest 73937 1350 17.0" 
$ns at 733.2436665629143 "$node_(547) setdest 31944 33167 1.0" 
$ns at 764.8654166325931 "$node_(547) setdest 75619 25334 16.0" 
$ns at 853.9379539153172 "$node_(547) setdest 132133 24120 8.0" 
$ns at 885.0193555852718 "$node_(547) setdest 104607 19150 5.0" 
$ns at 506.6662671093895 "$node_(548) setdest 65298 9132 19.0" 
$ns at 670.667560330741 "$node_(548) setdest 5802 37825 17.0" 
$ns at 742.4061626932474 "$node_(548) setdest 82493 17463 12.0" 
$ns at 811.7513663057862 "$node_(548) setdest 2365 24556 18.0" 
$ns at 507.09527097936393 "$node_(549) setdest 41416 29618 11.0" 
$ns at 568.2771123152161 "$node_(549) setdest 127117 3439 12.0" 
$ns at 685.4251792193943 "$node_(549) setdest 73639 20803 8.0" 
$ns at 769.9600419259722 "$node_(549) setdest 23572 35413 13.0" 
$ns at 856.9002790427426 "$node_(549) setdest 3993 40404 2.0" 
$ns at 651.0248482582676 "$node_(550) setdest 77227 26737 20.0" 
$ns at 795.5437992597017 "$node_(550) setdest 106870 38855 7.0" 
$ns at 895.0442704459033 "$node_(550) setdest 54039 38649 18.0" 
$ns at 579.115522212112 "$node_(551) setdest 132095 43682 11.0" 
$ns at 695.6403799960015 "$node_(551) setdest 114733 8618 9.0" 
$ns at 761.1510971998189 "$node_(551) setdest 89143 34724 3.0" 
$ns at 800.3413802771521 "$node_(551) setdest 76760 2425 19.0" 
$ns at 833.5826412350555 "$node_(551) setdest 83358 13004 11.0" 
$ns at 607.9748254381974 "$node_(552) setdest 47267 7538 15.0" 
$ns at 640.1498865732896 "$node_(552) setdest 110467 9341 3.0" 
$ns at 691.661688891088 "$node_(552) setdest 80129 27353 14.0" 
$ns at 757.5602925940618 "$node_(552) setdest 99426 17679 16.0" 
$ns at 609.3394407191297 "$node_(553) setdest 53738 32971 4.0" 
$ns at 668.8303168353233 "$node_(553) setdest 94398 11176 9.0" 
$ns at 712.8440330236809 "$node_(553) setdest 129237 37373 4.0" 
$ns at 747.3289211408049 "$node_(553) setdest 93929 29127 17.0" 
$ns at 813.3866818008116 "$node_(553) setdest 107109 11178 3.0" 
$ns at 853.5706123172372 "$node_(553) setdest 128139 41130 3.0" 
$ns at 889.9210459231967 "$node_(553) setdest 119717 10183 16.0" 
$ns at 672.9488188128652 "$node_(554) setdest 12630 27641 13.0" 
$ns at 714.3188768058709 "$node_(554) setdest 105347 23088 19.0" 
$ns at 893.0920613195399 "$node_(554) setdest 7476 22428 10.0" 
$ns at 520.981641304855 "$node_(555) setdest 96018 5268 8.0" 
$ns at 628.4829175361791 "$node_(555) setdest 34165 9718 8.0" 
$ns at 704.8397556599951 "$node_(555) setdest 2135 20424 20.0" 
$ns at 761.72047534082 "$node_(555) setdest 134003 1641 11.0" 
$ns at 812.3260314827548 "$node_(555) setdest 40429 42183 11.0" 
$ns at 845.2023908998542 "$node_(555) setdest 87283 25775 19.0" 
$ns at 884.1442513615402 "$node_(555) setdest 25201 4535 11.0" 
$ns at 502.5257721542333 "$node_(556) setdest 21480 36381 6.0" 
$ns at 566.7876284882233 "$node_(556) setdest 37367 32495 17.0" 
$ns at 725.917246081181 "$node_(556) setdest 114097 15646 6.0" 
$ns at 794.6290201019668 "$node_(556) setdest 41107 42142 14.0" 
$ns at 842.4736946034988 "$node_(556) setdest 75195 6449 19.0" 
$ns at 517.9555541547221 "$node_(557) setdest 98706 37483 19.0" 
$ns at 624.8193076015297 "$node_(557) setdest 72278 28232 20.0" 
$ns at 783.2879462566445 "$node_(557) setdest 34954 41509 11.0" 
$ns at 846.146490006039 "$node_(557) setdest 7584 31888 8.0" 
$ns at 891.1418977377515 "$node_(557) setdest 33506 868 13.0" 
$ns at 621.4123907390325 "$node_(558) setdest 127270 42607 11.0" 
$ns at 665.129667617987 "$node_(558) setdest 45191 40687 7.0" 
$ns at 737.8923810147347 "$node_(558) setdest 66144 7371 14.0" 
$ns at 551.5149889088826 "$node_(559) setdest 107583 27791 8.0" 
$ns at 605.1912951872758 "$node_(559) setdest 55028 37988 4.0" 
$ns at 659.2945455148268 "$node_(559) setdest 23570 34475 1.0" 
$ns at 693.5041851261244 "$node_(559) setdest 83713 27383 12.0" 
$ns at 808.9703904781338 "$node_(559) setdest 6333 33572 19.0" 
$ns at 501.50926294996066 "$node_(560) setdest 113812 33605 11.0" 
$ns at 610.7550017441772 "$node_(560) setdest 66036 16586 7.0" 
$ns at 654.2537277258903 "$node_(560) setdest 128214 34369 10.0" 
$ns at 749.4172590713441 "$node_(560) setdest 111120 14025 6.0" 
$ns at 816.4794271353 "$node_(560) setdest 125667 2186 11.0" 
$ns at 537.8053195478153 "$node_(561) setdest 32209 11135 15.0" 
$ns at 598.3554325051767 "$node_(561) setdest 40356 42753 5.0" 
$ns at 637.9302362551994 "$node_(561) setdest 105361 32124 20.0" 
$ns at 693.7341528216006 "$node_(561) setdest 100718 43762 9.0" 
$ns at 732.275600089906 "$node_(561) setdest 119721 12559 16.0" 
$ns at 837.6013858379583 "$node_(561) setdest 14417 24419 7.0" 
$ns at 874.8784291829697 "$node_(561) setdest 1499 38092 18.0" 
$ns at 590.5308147570838 "$node_(562) setdest 39411 1040 11.0" 
$ns at 680.6817919743007 "$node_(562) setdest 119767 6656 19.0" 
$ns at 871.0269124211636 "$node_(562) setdest 17064 35446 15.0" 
$ns at 568.1073877956227 "$node_(563) setdest 117688 15280 2.0" 
$ns at 605.8688302371805 "$node_(563) setdest 10915 29746 1.0" 
$ns at 643.4207732833959 "$node_(563) setdest 57438 10006 20.0" 
$ns at 868.7982159684681 "$node_(563) setdest 106710 16664 19.0" 
$ns at 592.0360608422067 "$node_(564) setdest 94832 30120 9.0" 
$ns at 696.2837053670504 "$node_(564) setdest 121623 39774 7.0" 
$ns at 741.7536928571081 "$node_(564) setdest 115204 36580 5.0" 
$ns at 808.1802615177478 "$node_(564) setdest 12516 28740 7.0" 
$ns at 860.4261725120095 "$node_(564) setdest 38450 8672 8.0" 
$ns at 562.5735577226892 "$node_(565) setdest 97308 1551 16.0" 
$ns at 721.6588768306898 "$node_(565) setdest 3554 42276 11.0" 
$ns at 760.1792130135714 "$node_(565) setdest 50155 36385 3.0" 
$ns at 792.4235666539645 "$node_(565) setdest 132323 37751 1.0" 
$ns at 826.0167572102372 "$node_(565) setdest 49842 9324 9.0" 
$ns at 594.0018698950203 "$node_(566) setdest 69812 38015 12.0" 
$ns at 674.7095880969456 "$node_(566) setdest 77008 23924 10.0" 
$ns at 713.8582282529167 "$node_(566) setdest 59789 41838 12.0" 
$ns at 796.3343360669604 "$node_(566) setdest 121927 36792 7.0" 
$ns at 869.6677292862298 "$node_(566) setdest 124090 13203 6.0" 
$ns at 577.6401438645902 "$node_(567) setdest 85320 28636 2.0" 
$ns at 610.1565423643658 "$node_(567) setdest 33169 21886 12.0" 
$ns at 697.5180767745185 "$node_(567) setdest 21428 30911 2.0" 
$ns at 728.6881165589638 "$node_(567) setdest 42851 23658 13.0" 
$ns at 858.2863757130463 "$node_(567) setdest 133687 10992 13.0" 
$ns at 532.4114796560597 "$node_(568) setdest 67559 41819 12.0" 
$ns at 665.2201496339444 "$node_(568) setdest 627 20524 2.0" 
$ns at 701.9117177521639 "$node_(568) setdest 25767 13303 12.0" 
$ns at 762.1276591908778 "$node_(568) setdest 98964 4456 17.0" 
$ns at 523.1402034061747 "$node_(569) setdest 92224 29055 4.0" 
$ns at 590.1310116576389 "$node_(569) setdest 123358 22504 9.0" 
$ns at 707.241597078343 "$node_(569) setdest 52381 29816 1.0" 
$ns at 738.4801165800372 "$node_(569) setdest 4004 39771 9.0" 
$ns at 791.8633213851225 "$node_(569) setdest 48032 41783 2.0" 
$ns at 830.2540942671101 "$node_(569) setdest 47328 39770 19.0" 
$ns at 896.3197316241133 "$node_(569) setdest 129940 42239 7.0" 
$ns at 508.517575263618 "$node_(570) setdest 116046 20411 17.0" 
$ns at 552.0643448752962 "$node_(570) setdest 7502 14149 16.0" 
$ns at 620.3437347611373 "$node_(570) setdest 71416 42404 9.0" 
$ns at 719.6953226347752 "$node_(570) setdest 50616 12926 7.0" 
$ns at 777.4535317347486 "$node_(570) setdest 115687 15841 2.0" 
$ns at 821.7629777529197 "$node_(570) setdest 26851 15141 18.0" 
$ns at 573.217978461785 "$node_(571) setdest 99037 10444 9.0" 
$ns at 646.4842582190176 "$node_(571) setdest 27408 14236 6.0" 
$ns at 693.8368776144341 "$node_(571) setdest 92232 35648 19.0" 
$ns at 867.147767513728 "$node_(571) setdest 21315 44603 1.0" 
$ns at 622.585890788393 "$node_(572) setdest 118633 37442 10.0" 
$ns at 733.4556608872531 "$node_(572) setdest 111761 11717 11.0" 
$ns at 852.6002638969229 "$node_(572) setdest 38175 22951 11.0" 
$ns at 509.56501484907926 "$node_(573) setdest 122514 32414 10.0" 
$ns at 556.7798632953401 "$node_(573) setdest 74112 26426 12.0" 
$ns at 671.4963568529814 "$node_(573) setdest 22157 2729 12.0" 
$ns at 718.2953632430725 "$node_(573) setdest 100458 4435 6.0" 
$ns at 777.906791936386 "$node_(573) setdest 105684 39899 1.0" 
$ns at 811.4965829536476 "$node_(573) setdest 116930 4212 13.0" 
$ns at 869.4504417445844 "$node_(573) setdest 27537 23264 13.0" 
$ns at 503.7606757253407 "$node_(574) setdest 85060 9929 5.0" 
$ns at 562.0939483364224 "$node_(574) setdest 86225 20048 12.0" 
$ns at 601.0756344601164 "$node_(574) setdest 97622 19065 16.0" 
$ns at 785.5286555855345 "$node_(574) setdest 24053 28079 17.0" 
$ns at 558.8220683111942 "$node_(575) setdest 93818 32011 2.0" 
$ns at 604.1994660441857 "$node_(575) setdest 112019 2075 1.0" 
$ns at 635.7597520133585 "$node_(575) setdest 2508 35213 15.0" 
$ns at 711.098358498899 "$node_(575) setdest 29743 27982 17.0" 
$ns at 537.5196671381655 "$node_(576) setdest 84919 40657 11.0" 
$ns at 659.664803283632 "$node_(576) setdest 118084 12149 18.0" 
$ns at 799.0812708131936 "$node_(576) setdest 6522 5708 8.0" 
$ns at 845.3403886848536 "$node_(576) setdest 11166 26402 1.0" 
$ns at 884.9896806228292 "$node_(576) setdest 76225 20382 15.0" 
$ns at 654.1449173770401 "$node_(577) setdest 105192 26346 18.0" 
$ns at 852.0359962644636 "$node_(577) setdest 20860 9614 17.0" 
$ns at 508.8644955256424 "$node_(578) setdest 32320 35836 6.0" 
$ns at 588.145094124334 "$node_(578) setdest 91108 26969 1.0" 
$ns at 625.2882882553766 "$node_(578) setdest 106064 7782 7.0" 
$ns at 722.0913161384474 "$node_(578) setdest 48870 29638 11.0" 
$ns at 753.0797122444611 "$node_(578) setdest 9041 31906 1.0" 
$ns at 789.4884339211674 "$node_(578) setdest 27807 42261 1.0" 
$ns at 820.7699066782815 "$node_(578) setdest 77799 4862 17.0" 
$ns at 550.4494238134516 "$node_(579) setdest 67816 10610 16.0" 
$ns at 703.3108528296991 "$node_(579) setdest 76159 2343 15.0" 
$ns at 753.8759244093005 "$node_(579) setdest 27759 40774 5.0" 
$ns at 795.9805651491789 "$node_(579) setdest 29129 38985 1.0" 
$ns at 831.9918290647568 "$node_(579) setdest 108667 43884 14.0" 
$ns at 621.6413586563904 "$node_(580) setdest 53414 33776 18.0" 
$ns at 821.2467793797713 "$node_(580) setdest 64451 12888 5.0" 
$ns at 874.0985602580361 "$node_(580) setdest 79809 10053 16.0" 
$ns at 560.5711964794905 "$node_(581) setdest 74556 18589 11.0" 
$ns at 674.1492060097628 "$node_(581) setdest 12053 4031 7.0" 
$ns at 734.0924941479777 "$node_(581) setdest 78466 25658 9.0" 
$ns at 805.4218177419581 "$node_(581) setdest 88253 26324 12.0" 
$ns at 515.0510774524057 "$node_(582) setdest 126372 36328 15.0" 
$ns at 695.0352812958945 "$node_(582) setdest 85049 15844 12.0" 
$ns at 840.7528798930189 "$node_(582) setdest 71941 1338 11.0" 
$ns at 553.1310180367609 "$node_(583) setdest 47996 36729 13.0" 
$ns at 618.0032698048466 "$node_(583) setdest 70239 43122 18.0" 
$ns at 659.4590229787161 "$node_(583) setdest 104923 15296 14.0" 
$ns at 713.2959646222638 "$node_(583) setdest 52649 17047 7.0" 
$ns at 747.9986530157892 "$node_(583) setdest 72996 7527 17.0" 
$ns at 865.3007987659647 "$node_(583) setdest 134007 44303 6.0" 
$ns at 517.9267153697422 "$node_(584) setdest 34614 14327 4.0" 
$ns at 559.1553241125937 "$node_(584) setdest 104047 21515 16.0" 
$ns at 734.797712058821 "$node_(584) setdest 110086 16125 20.0" 
$ns at 811.6245454699213 "$node_(584) setdest 53086 15419 17.0" 
$ns at 886.1064706146608 "$node_(584) setdest 72064 30646 14.0" 
$ns at 546.8170959472722 "$node_(585) setdest 27224 659 13.0" 
$ns at 630.1009181983634 "$node_(585) setdest 119064 7799 11.0" 
$ns at 741.1291807012274 "$node_(585) setdest 66234 19529 11.0" 
$ns at 879.744946667377 "$node_(585) setdest 67090 2402 15.0" 
$ns at 542.429244968993 "$node_(586) setdest 57446 38365 1.0" 
$ns at 578.4703320679778 "$node_(586) setdest 73074 35211 20.0" 
$ns at 751.0938893341646 "$node_(586) setdest 10425 23134 18.0" 
$ns at 812.3634743735053 "$node_(586) setdest 118586 5960 2.0" 
$ns at 850.6254072997087 "$node_(586) setdest 84196 6722 13.0" 
$ns at 624.5837353391993 "$node_(587) setdest 54776 42548 5.0" 
$ns at 658.6215288030546 "$node_(587) setdest 34043 6241 1.0" 
$ns at 690.6137135490006 "$node_(587) setdest 69084 36577 3.0" 
$ns at 737.0412212706515 "$node_(587) setdest 113185 1266 17.0" 
$ns at 782.2490533949203 "$node_(587) setdest 87321 15432 12.0" 
$ns at 546.8901884935303 "$node_(588) setdest 115849 34599 2.0" 
$ns at 590.1732621271934 "$node_(588) setdest 100153 37500 13.0" 
$ns at 665.8017388737846 "$node_(588) setdest 83343 38674 17.0" 
$ns at 741.4901278203265 "$node_(588) setdest 115260 1672 12.0" 
$ns at 847.2453153733449 "$node_(588) setdest 106823 3359 16.0" 
$ns at 558.2581609926118 "$node_(589) setdest 122443 4333 17.0" 
$ns at 697.1898717723924 "$node_(589) setdest 50793 17388 5.0" 
$ns at 776.7347468556853 "$node_(589) setdest 11848 17861 17.0" 
$ns at 843.05632624509 "$node_(589) setdest 31329 23262 7.0" 
$ns at 507.5847218990583 "$node_(590) setdest 113236 20547 12.0" 
$ns at 609.3065496288592 "$node_(590) setdest 12331 12365 8.0" 
$ns at 687.9769785002043 "$node_(590) setdest 8825 33483 8.0" 
$ns at 747.8368995665069 "$node_(590) setdest 23875 43178 6.0" 
$ns at 817.2587959330733 "$node_(590) setdest 47261 38845 15.0" 
$ns at 503.802910921902 "$node_(591) setdest 116332 43141 4.0" 
$ns at 563.5021338798 "$node_(591) setdest 1641 22647 17.0" 
$ns at 625.8411858409394 "$node_(591) setdest 79311 20659 3.0" 
$ns at 683.4960942961529 "$node_(591) setdest 129057 26145 5.0" 
$ns at 728.9949637025481 "$node_(591) setdest 111452 34765 19.0" 
$ns at 549.4592805639514 "$node_(592) setdest 130527 27602 18.0" 
$ns at 595.7406831873229 "$node_(592) setdest 111471 27233 20.0" 
$ns at 644.2423753843917 "$node_(592) setdest 127925 4980 18.0" 
$ns at 760.3723272809042 "$node_(592) setdest 78276 17880 8.0" 
$ns at 861.1291853974237 "$node_(592) setdest 54774 1525 4.0" 
$ns at 896.6491750710593 "$node_(592) setdest 52559 23550 13.0" 
$ns at 531.6219940464487 "$node_(593) setdest 93116 8677 14.0" 
$ns at 673.536000920448 "$node_(593) setdest 102638 1885 4.0" 
$ns at 727.9845085043565 "$node_(593) setdest 95542 10859 7.0" 
$ns at 759.2794057178562 "$node_(593) setdest 7467 8807 3.0" 
$ns at 803.8806014836094 "$node_(593) setdest 71039 40150 12.0" 
$ns at 865.041980811504 "$node_(593) setdest 38974 9230 11.0" 
$ns at 527.0385278017108 "$node_(594) setdest 74520 27477 10.0" 
$ns at 606.1677228913693 "$node_(594) setdest 110715 2266 5.0" 
$ns at 677.1419663789452 "$node_(594) setdest 123621 19982 4.0" 
$ns at 718.9566568144401 "$node_(594) setdest 82589 5462 14.0" 
$ns at 816.2846853870537 "$node_(594) setdest 34943 31765 8.0" 
$ns at 881.2814633856972 "$node_(594) setdest 39208 15592 16.0" 
$ns at 530.6363012005229 "$node_(595) setdest 58003 42164 15.0" 
$ns at 664.2061755756299 "$node_(595) setdest 36057 3031 8.0" 
$ns at 698.7517050140639 "$node_(595) setdest 77049 34039 4.0" 
$ns at 728.9568087196909 "$node_(595) setdest 69978 19290 5.0" 
$ns at 774.1717611963194 "$node_(595) setdest 50959 18342 8.0" 
$ns at 841.7172567410288 "$node_(595) setdest 18011 20669 6.0" 
$ns at 520.6985871093104 "$node_(596) setdest 115252 7455 15.0" 
$ns at 586.4509779951777 "$node_(596) setdest 1471 37006 5.0" 
$ns at 641.9028347396564 "$node_(596) setdest 55038 15856 12.0" 
$ns at 765.1228342974649 "$node_(596) setdest 53800 39223 19.0" 
$ns at 651.7073756119728 "$node_(597) setdest 97352 43416 16.0" 
$ns at 745.7678427602974 "$node_(597) setdest 113321 28409 10.0" 
$ns at 831.9738791440736 "$node_(597) setdest 81758 9673 16.0" 
$ns at 513.871126207435 "$node_(598) setdest 3716 8120 18.0" 
$ns at 639.9212932276996 "$node_(598) setdest 98259 19041 10.0" 
$ns at 757.8163541578444 "$node_(598) setdest 5032 7882 5.0" 
$ns at 813.8906475557818 "$node_(598) setdest 12501 21146 16.0" 
$ns at 845.2508086912072 "$node_(598) setdest 101114 19490 17.0" 
$ns at 877.4637656001155 "$node_(598) setdest 34960 23928 5.0" 
$ns at 550.3451647170099 "$node_(599) setdest 109633 2937 3.0" 
$ns at 606.7904482440222 "$node_(599) setdest 115443 25689 4.0" 
$ns at 665.6380203449172 "$node_(599) setdest 67947 1246 17.0" 
$ns at 729.1289397235582 "$node_(599) setdest 105509 38193 2.0" 
$ns at 759.7208747473805 "$node_(599) setdest 68011 33465 2.0" 
$ns at 805.5026795667424 "$node_(599) setdest 113003 5023 14.0" 
$ns at 862.5231648728598 "$node_(599) setdest 24526 7485 19.0" 
$ns at 623.6236894359446 "$node_(600) setdest 18197 20180 11.0" 
$ns at 707.4771581791509 "$node_(600) setdest 67760 31986 5.0" 
$ns at 765.6099815250957 "$node_(600) setdest 40172 19102 18.0" 
$ns at 836.9838961711399 "$node_(600) setdest 67243 38296 7.0" 
$ns at 607.8444590192913 "$node_(601) setdest 127712 44593 10.0" 
$ns at 677.9701697448758 "$node_(601) setdest 61835 40758 17.0" 
$ns at 823.9910833874559 "$node_(601) setdest 71417 26176 9.0" 
$ns at 865.1473997631705 "$node_(601) setdest 101290 27215 12.0" 
$ns at 639.804422952662 "$node_(602) setdest 131011 28148 9.0" 
$ns at 723.4925544467643 "$node_(602) setdest 78051 24049 13.0" 
$ns at 803.7423611483625 "$node_(602) setdest 122335 10664 13.0" 
$ns at 849.8744182908524 "$node_(602) setdest 125119 17734 8.0" 
$ns at 634.1944280743703 "$node_(603) setdest 90598 12141 11.0" 
$ns at 719.9364288716588 "$node_(603) setdest 27182 24564 7.0" 
$ns at 784.1557255485911 "$node_(603) setdest 85430 18405 11.0" 
$ns at 877.4296200658137 "$node_(603) setdest 57233 37644 17.0" 
$ns at 646.484569507485 "$node_(604) setdest 74137 37902 2.0" 
$ns at 691.3098894659522 "$node_(604) setdest 56378 27506 11.0" 
$ns at 808.2354523464727 "$node_(604) setdest 13934 37147 6.0" 
$ns at 841.9159607137246 "$node_(604) setdest 14658 6658 4.0" 
$ns at 880.9741792780618 "$node_(604) setdest 40638 25370 1.0" 
$ns at 635.8838411611247 "$node_(605) setdest 65352 34191 1.0" 
$ns at 668.1593845898235 "$node_(605) setdest 71388 39072 7.0" 
$ns at 732.480404238342 "$node_(605) setdest 91721 26637 2.0" 
$ns at 772.8199522764515 "$node_(605) setdest 4609 18037 15.0" 
$ns at 670.8172077535204 "$node_(606) setdest 48341 42014 1.0" 
$ns at 708.2683402595858 "$node_(606) setdest 42570 4002 7.0" 
$ns at 797.4166103206067 "$node_(606) setdest 33572 29482 9.0" 
$ns at 881.6090491155333 "$node_(606) setdest 20436 38202 1.0" 
$ns at 621.5630529745306 "$node_(607) setdest 67038 28664 8.0" 
$ns at 722.3254528895675 "$node_(607) setdest 131533 33962 4.0" 
$ns at 761.1526626702722 "$node_(607) setdest 52457 9396 1.0" 
$ns at 799.6520391966071 "$node_(607) setdest 117173 6377 14.0" 
$ns at 633.0027111849089 "$node_(608) setdest 37438 44044 18.0" 
$ns at 681.11004717358 "$node_(608) setdest 71047 23507 16.0" 
$ns at 869.5536166253014 "$node_(608) setdest 41036 39658 8.0" 
$ns at 615.9326941709484 "$node_(609) setdest 86545 44109 14.0" 
$ns at 651.1769034540221 "$node_(609) setdest 78701 35989 3.0" 
$ns at 696.4287435070298 "$node_(609) setdest 106114 37302 8.0" 
$ns at 774.9566557764349 "$node_(609) setdest 46515 3541 9.0" 
$ns at 807.487837849497 "$node_(609) setdest 62553 1106 8.0" 
$ns at 875.0293843243986 "$node_(609) setdest 92134 8530 20.0" 
$ns at 669.9098160943919 "$node_(610) setdest 133110 35201 9.0" 
$ns at 711.7680167851304 "$node_(610) setdest 114350 43245 13.0" 
$ns at 795.1331873192496 "$node_(610) setdest 100865 27834 3.0" 
$ns at 829.9491492873385 "$node_(610) setdest 102726 1539 16.0" 
$ns at 862.8691381716803 "$node_(610) setdest 110343 40325 10.0" 
$ns at 622.431553112185 "$node_(611) setdest 105918 32439 7.0" 
$ns at 698.3356014160544 "$node_(611) setdest 93518 23931 8.0" 
$ns at 801.3876762519221 "$node_(611) setdest 39920 23284 6.0" 
$ns at 869.7058875794252 "$node_(611) setdest 5947 12637 17.0" 
$ns at 628.4666742001393 "$node_(612) setdest 87056 4672 19.0" 
$ns at 823.6872399704238 "$node_(612) setdest 11503 31306 5.0" 
$ns at 857.5662056073231 "$node_(612) setdest 43919 39345 7.0" 
$ns at 632.4102602256733 "$node_(613) setdest 105079 26563 1.0" 
$ns at 667.7101800349212 "$node_(613) setdest 75556 31431 9.0" 
$ns at 752.0606659861061 "$node_(613) setdest 120090 33834 10.0" 
$ns at 797.5536506600828 "$node_(613) setdest 76104 13554 6.0" 
$ns at 865.1218024243436 "$node_(613) setdest 62516 1352 8.0" 
$ns at 711.2275273226247 "$node_(614) setdest 101550 39837 6.0" 
$ns at 780.8325820422617 "$node_(614) setdest 109622 10883 12.0" 
$ns at 775.5021886053951 "$node_(615) setdest 14167 32342 7.0" 
$ns at 872.8064642215008 "$node_(615) setdest 79926 6850 17.0" 
$ns at 624.2612521210774 "$node_(616) setdest 57320 26721 7.0" 
$ns at 678.0745367698934 "$node_(616) setdest 27119 34627 6.0" 
$ns at 765.7244704600705 "$node_(616) setdest 26009 41315 3.0" 
$ns at 799.7621581838142 "$node_(616) setdest 40917 43579 9.0" 
$ns at 844.7070498979199 "$node_(616) setdest 56604 2682 18.0" 
$ns at 885.2598839606709 "$node_(616) setdest 31722 13174 2.0" 
$ns at 600.0723007805441 "$node_(617) setdest 20324 26967 18.0" 
$ns at 722.1944187641753 "$node_(617) setdest 116414 40070 8.0" 
$ns at 829.7852236566154 "$node_(617) setdest 10593 1908 7.0" 
$ns at 876.586104701842 "$node_(617) setdest 85557 11004 9.0" 
$ns at 634.1162786674165 "$node_(618) setdest 99895 41270 15.0" 
$ns at 694.1535185644817 "$node_(618) setdest 11464 6998 1.0" 
$ns at 729.123252905348 "$node_(618) setdest 58679 28087 15.0" 
$ns at 640.6461002446897 "$node_(619) setdest 79470 21659 4.0" 
$ns at 671.4138716138148 "$node_(619) setdest 62956 11140 19.0" 
$ns at 788.181450596297 "$node_(619) setdest 76742 4033 14.0" 
$ns at 713.199385361741 "$node_(620) setdest 110460 14565 1.0" 
$ns at 748.0678915165364 "$node_(620) setdest 118878 10342 15.0" 
$ns at 847.8421463339632 "$node_(620) setdest 35835 13383 17.0" 
$ns at 879.3531543980564 "$node_(620) setdest 72038 32183 6.0" 
$ns at 721.3048075396723 "$node_(621) setdest 4661 16616 10.0" 
$ns at 768.2448688781734 "$node_(621) setdest 112026 21994 10.0" 
$ns at 823.1240289196732 "$node_(621) setdest 89864 1865 10.0" 
$ns at 633.4779057142775 "$node_(622) setdest 33216 2650 12.0" 
$ns at 750.1316945666089 "$node_(622) setdest 45792 31234 3.0" 
$ns at 809.1574686847298 "$node_(622) setdest 14205 6053 17.0" 
$ns at 679.5727906316612 "$node_(623) setdest 113786 12517 20.0" 
$ns at 892.5985137206027 "$node_(623) setdest 31835 19262 7.0" 
$ns at 670.6425200939854 "$node_(624) setdest 11062 39843 8.0" 
$ns at 723.0639638113911 "$node_(624) setdest 73458 36840 20.0" 
$ns at 629.3674695820856 "$node_(625) setdest 15077 2302 17.0" 
$ns at 822.5836220405133 "$node_(625) setdest 72308 15077 15.0" 
$ns at 669.5027434234986 "$node_(626) setdest 9469 31376 2.0" 
$ns at 712.4366704909405 "$node_(626) setdest 86508 15493 11.0" 
$ns at 744.4327309763867 "$node_(626) setdest 28028 31193 5.0" 
$ns at 801.5342856741461 "$node_(626) setdest 100024 33847 8.0" 
$ns at 857.2405395670932 "$node_(626) setdest 83932 40723 5.0" 
$ns at 897.5765311416328 "$node_(626) setdest 20335 4455 17.0" 
$ns at 648.1389439817148 "$node_(627) setdest 117951 26272 10.0" 
$ns at 751.5427908416528 "$node_(627) setdest 126513 14180 8.0" 
$ns at 789.6365135123489 "$node_(627) setdest 98291 3195 17.0" 
$ns at 701.1689456435671 "$node_(628) setdest 66422 11684 4.0" 
$ns at 757.1353909035929 "$node_(628) setdest 58003 45 9.0" 
$ns at 873.1214391793291 "$node_(628) setdest 121646 37705 15.0" 
$ns at 621.3360239332635 "$node_(629) setdest 40198 4368 15.0" 
$ns at 767.6248256889545 "$node_(629) setdest 52939 39186 15.0" 
$ns at 881.1828513937251 "$node_(629) setdest 77376 28779 3.0" 
$ns at 672.2800129503867 "$node_(630) setdest 132449 40000 12.0" 
$ns at 810.3656267092623 "$node_(630) setdest 46368 1330 14.0" 
$ns at 845.2604034038957 "$node_(630) setdest 21650 20086 18.0" 
$ns at 721.2694058639431 "$node_(631) setdest 49294 42861 17.0" 
$ns at 778.8572482174262 "$node_(631) setdest 21390 36089 19.0" 
$ns at 609.9021270906962 "$node_(632) setdest 30162 832 11.0" 
$ns at 651.2861910612513 "$node_(632) setdest 121458 26521 6.0" 
$ns at 729.2405185227964 "$node_(632) setdest 53525 20987 17.0" 
$ns at 875.0791632867767 "$node_(632) setdest 115692 24494 14.0" 
$ns at 649.9969084005962 "$node_(633) setdest 126837 41438 10.0" 
$ns at 701.3822855542295 "$node_(633) setdest 43322 6719 15.0" 
$ns at 794.7167140849051 "$node_(633) setdest 42378 37168 3.0" 
$ns at 848.0673674309872 "$node_(633) setdest 15918 6608 16.0" 
$ns at 736.6442793528129 "$node_(634) setdest 125008 10289 16.0" 
$ns at 794.6631180961464 "$node_(634) setdest 14004 44076 13.0" 
$ns at 615.7643318181093 "$node_(635) setdest 98518 39668 5.0" 
$ns at 693.3288907051325 "$node_(635) setdest 127498 26988 15.0" 
$ns at 854.420117538972 "$node_(635) setdest 119938 29211 2.0" 
$ns at 886.813272857656 "$node_(635) setdest 6306 40078 17.0" 
$ns at 610.0940676638942 "$node_(636) setdest 109498 10861 10.0" 
$ns at 733.2614212784845 "$node_(636) setdest 89194 17385 1.0" 
$ns at 771.751350775796 "$node_(636) setdest 72651 39720 9.0" 
$ns at 839.0859662724064 "$node_(636) setdest 90151 15427 17.0" 
$ns at 609.8841029410421 "$node_(637) setdest 68704 31145 17.0" 
$ns at 734.1047031313431 "$node_(637) setdest 68915 3718 3.0" 
$ns at 774.2369584615582 "$node_(637) setdest 66736 19660 18.0" 
$ns at 643.39646249214 "$node_(638) setdest 89434 6705 19.0" 
$ns at 690.6599021927766 "$node_(638) setdest 119964 10457 14.0" 
$ns at 749.3770108412534 "$node_(638) setdest 115478 7237 6.0" 
$ns at 833.051013228017 "$node_(638) setdest 65425 16480 17.0" 
$ns at 654.6611779932099 "$node_(639) setdest 23149 30048 19.0" 
$ns at 708.5006130295088 "$node_(639) setdest 110455 5192 20.0" 
$ns at 759.7642622642921 "$node_(639) setdest 109042 30514 7.0" 
$ns at 851.1803523213692 "$node_(639) setdest 132872 33138 19.0" 
$ns at 681.1845014284328 "$node_(640) setdest 37902 40740 6.0" 
$ns at 757.4487820075841 "$node_(640) setdest 86974 37243 2.0" 
$ns at 787.5587964171666 "$node_(640) setdest 54574 3583 18.0" 
$ns at 697.225327257024 "$node_(641) setdest 73417 12390 15.0" 
$ns at 818.4561310285789 "$node_(641) setdest 96665 129 14.0" 
$ns at 894.6447794462094 "$node_(641) setdest 113986 28430 9.0" 
$ns at 722.9097806323258 "$node_(642) setdest 8064 12553 3.0" 
$ns at 760.3121957160546 "$node_(642) setdest 52630 21098 8.0" 
$ns at 867.8585538158959 "$node_(642) setdest 18366 39636 9.0" 
$ns at 624.1836971946998 "$node_(643) setdest 26383 14639 1.0" 
$ns at 657.1212616578327 "$node_(643) setdest 42994 18950 9.0" 
$ns at 767.9014221764636 "$node_(643) setdest 3720 42701 18.0" 
$ns at 805.7438127818469 "$node_(643) setdest 3474 11973 10.0" 
$ns at 850.7536627377301 "$node_(643) setdest 54768 4129 11.0" 
$ns at 685.9628626782707 "$node_(644) setdest 50448 43548 20.0" 
$ns at 865.2766172403506 "$node_(644) setdest 42834 1008 18.0" 
$ns at 606.1193064323988 "$node_(645) setdest 79791 23526 15.0" 
$ns at 748.3643308798528 "$node_(645) setdest 68266 24211 9.0" 
$ns at 816.3039653141605 "$node_(645) setdest 24384 17299 12.0" 
$ns at 629.9489027688966 "$node_(646) setdest 31230 39722 10.0" 
$ns at 662.4144226213257 "$node_(646) setdest 88262 32583 2.0" 
$ns at 706.5818833996126 "$node_(646) setdest 26846 28727 1.0" 
$ns at 744.751785798529 "$node_(646) setdest 70874 25944 3.0" 
$ns at 791.0857104289628 "$node_(646) setdest 46188 2507 14.0" 
$ns at 666.7804463159638 "$node_(647) setdest 37141 1302 11.0" 
$ns at 738.9591763439153 "$node_(647) setdest 43885 23946 9.0" 
$ns at 787.8460888919437 "$node_(647) setdest 55328 35250 11.0" 
$ns at 866.1308482372608 "$node_(647) setdest 129812 23473 14.0" 
$ns at 613.2778860744422 "$node_(648) setdest 64215 17512 19.0" 
$ns at 783.9406232148015 "$node_(648) setdest 5141 15565 1.0" 
$ns at 820.0061376505087 "$node_(648) setdest 7468 9869 5.0" 
$ns at 890.4244820367962 "$node_(648) setdest 97571 32909 11.0" 
$ns at 666.5795584142182 "$node_(649) setdest 26253 5479 16.0" 
$ns at 847.6558353561477 "$node_(649) setdest 89857 25787 11.0" 
$ns at 646.965554752506 "$node_(650) setdest 69599 19335 10.0" 
$ns at 773.9591269894587 "$node_(650) setdest 63889 19113 2.0" 
$ns at 816.7394619723228 "$node_(650) setdest 105576 4666 4.0" 
$ns at 881.939356686251 "$node_(650) setdest 58727 2065 4.0" 
$ns at 613.5986013902589 "$node_(651) setdest 66563 7108 5.0" 
$ns at 686.8327741900591 "$node_(651) setdest 61240 38966 5.0" 
$ns at 734.8971594242369 "$node_(651) setdest 73318 12619 10.0" 
$ns at 810.5903308418799 "$node_(651) setdest 7311 14972 16.0" 
$ns at 600.308261804106 "$node_(652) setdest 74055 6143 7.0" 
$ns at 684.1928673376904 "$node_(652) setdest 65957 34647 11.0" 
$ns at 723.061206740214 "$node_(652) setdest 114298 33991 18.0" 
$ns at 759.7471605939148 "$node_(652) setdest 133741 35591 16.0" 
$ns at 870.0147268133328 "$node_(652) setdest 114478 1667 16.0" 
$ns at 681.7737780223894 "$node_(653) setdest 47985 44041 17.0" 
$ns at 845.8629063297924 "$node_(653) setdest 37129 38755 4.0" 
$ns at 896.5760672536144 "$node_(653) setdest 24024 29993 8.0" 
$ns at 632.8773783591025 "$node_(654) setdest 72174 24521 15.0" 
$ns at 678.1631889357933 "$node_(654) setdest 28858 7873 7.0" 
$ns at 711.1859244519279 "$node_(654) setdest 59305 26320 3.0" 
$ns at 742.5650100767351 "$node_(654) setdest 43571 1448 14.0" 
$ns at 835.3895513808989 "$node_(654) setdest 9609 8372 14.0" 
$ns at 899.5726307655912 "$node_(654) setdest 32722 22014 8.0" 
$ns at 649.9940599123773 "$node_(655) setdest 62946 37850 11.0" 
$ns at 743.322910034812 "$node_(655) setdest 109380 40392 20.0" 
$ns at 883.5094147740976 "$node_(655) setdest 129606 30251 15.0" 
$ns at 648.1321966819977 "$node_(656) setdest 82651 4038 4.0" 
$ns at 708.9913797264625 "$node_(656) setdest 93858 16347 19.0" 
$ns at 650.7017293242509 "$node_(657) setdest 92589 10812 14.0" 
$ns at 705.8709333525215 "$node_(657) setdest 22262 24096 20.0" 
$ns at 886.6303345069606 "$node_(657) setdest 49445 18086 11.0" 
$ns at 626.7264360085852 "$node_(658) setdest 95308 2240 12.0" 
$ns at 764.3970644798485 "$node_(658) setdest 43515 43788 20.0" 
$ns at 618.5680863981651 "$node_(659) setdest 76165 43327 7.0" 
$ns at 669.0577758776682 "$node_(659) setdest 68859 40931 9.0" 
$ns at 730.2669618075034 "$node_(659) setdest 34281 18684 7.0" 
$ns at 778.2000271215165 "$node_(659) setdest 88203 29991 11.0" 
$ns at 857.9513805214098 "$node_(659) setdest 129739 24778 1.0" 
$ns at 894.1565315424062 "$node_(659) setdest 39644 2808 9.0" 
$ns at 693.0862612881162 "$node_(660) setdest 59228 23083 14.0" 
$ns at 765.5480068943885 "$node_(660) setdest 16292 32711 4.0" 
$ns at 819.7396682373121 "$node_(660) setdest 118818 39385 4.0" 
$ns at 875.0379568671681 "$node_(660) setdest 45414 19547 13.0" 
$ns at 610.4546235553402 "$node_(661) setdest 79407 3468 2.0" 
$ns at 642.5974217846738 "$node_(661) setdest 55547 17939 10.0" 
$ns at 687.8038943832732 "$node_(661) setdest 78387 7837 9.0" 
$ns at 746.005969634646 "$node_(661) setdest 47341 32188 8.0" 
$ns at 842.4812619410238 "$node_(661) setdest 48626 3167 1.0" 
$ns at 882.3606145738988 "$node_(661) setdest 37169 43234 11.0" 
$ns at 644.8097859308643 "$node_(662) setdest 60596 2676 4.0" 
$ns at 712.9951310624423 "$node_(662) setdest 101086 4430 12.0" 
$ns at 806.0971248139139 "$node_(662) setdest 37112 22068 15.0" 
$ns at 879.0591929522116 "$node_(662) setdest 27283 2802 5.0" 
$ns at 777.9877795511885 "$node_(663) setdest 45060 15916 5.0" 
$ns at 835.4216290060638 "$node_(663) setdest 108691 19797 19.0" 
$ns at 650.4738371503091 "$node_(664) setdest 12020 11953 2.0" 
$ns at 681.4587619195618 "$node_(664) setdest 121699 6393 20.0" 
$ns at 645.8355477412592 "$node_(665) setdest 24173 18821 10.0" 
$ns at 735.0848448685684 "$node_(665) setdest 117332 17570 4.0" 
$ns at 795.53919677838 "$node_(665) setdest 38770 34869 4.0" 
$ns at 846.6735772959707 "$node_(665) setdest 110692 6160 18.0" 
$ns at 618.9146029539015 "$node_(666) setdest 1648 4019 19.0" 
$ns at 665.4977214714783 "$node_(666) setdest 3176 41624 12.0" 
$ns at 755.8181418511722 "$node_(666) setdest 33027 38583 3.0" 
$ns at 797.2955051933566 "$node_(666) setdest 101074 41766 2.0" 
$ns at 842.1129034558372 "$node_(666) setdest 40755 42733 11.0" 
$ns at 618.0576184823489 "$node_(667) setdest 28962 43847 5.0" 
$ns at 656.7775759447162 "$node_(667) setdest 13346 26798 2.0" 
$ns at 700.1127814334209 "$node_(667) setdest 60690 23136 12.0" 
$ns at 733.088213769958 "$node_(667) setdest 46862 30525 8.0" 
$ns at 786.1129656531169 "$node_(667) setdest 35202 25473 4.0" 
$ns at 826.7346689443153 "$node_(667) setdest 39184 10961 16.0" 
$ns at 883.1888701502949 "$node_(667) setdest 68521 26433 11.0" 
$ns at 653.1898929495388 "$node_(668) setdest 122002 39692 6.0" 
$ns at 742.4224929719898 "$node_(668) setdest 89508 16638 11.0" 
$ns at 823.9414823637966 "$node_(668) setdest 30155 35725 11.0" 
$ns at 867.0744846995697 "$node_(668) setdest 131191 40878 19.0" 
$ns at 605.1327702856049 "$node_(669) setdest 88719 41563 9.0" 
$ns at 658.1710018022061 "$node_(669) setdest 61368 3054 4.0" 
$ns at 716.9159683178137 "$node_(669) setdest 17960 33342 17.0" 
$ns at 749.6740097817238 "$node_(669) setdest 15280 23712 11.0" 
$ns at 843.7603458643491 "$node_(669) setdest 90141 1410 9.0" 
$ns at 874.8111317603667 "$node_(669) setdest 35633 38929 19.0" 
$ns at 679.691283568185 "$node_(670) setdest 24610 12296 19.0" 
$ns at 748.5696991996269 "$node_(670) setdest 21391 13293 17.0" 
$ns at 785.7586499604519 "$node_(670) setdest 36776 731 4.0" 
$ns at 822.3928595266318 "$node_(670) setdest 23571 12180 12.0" 
$ns at 853.3401015522732 "$node_(670) setdest 98537 28768 19.0" 
$ns at 669.9958810403621 "$node_(671) setdest 87819 32331 15.0" 
$ns at 730.0622952918502 "$node_(671) setdest 6008 18836 18.0" 
$ns at 806.4683295663116 "$node_(671) setdest 47207 25141 14.0" 
$ns at 709.7050360651672 "$node_(672) setdest 50341 6654 19.0" 
$ns at 836.3883657559046 "$node_(672) setdest 28439 5337 6.0" 
$ns at 866.774956285206 "$node_(672) setdest 13330 6080 5.0" 
$ns at 683.5796268613293 "$node_(673) setdest 10007 39454 15.0" 
$ns at 827.6610035195451 "$node_(673) setdest 5041 28183 13.0" 
$ns at 623.6294980179798 "$node_(674) setdest 21486 18461 10.0" 
$ns at 699.596280850056 "$node_(674) setdest 39751 30751 1.0" 
$ns at 734.0409431103843 "$node_(674) setdest 13754 31677 6.0" 
$ns at 768.8985871176394 "$node_(674) setdest 109159 18991 1.0" 
$ns at 806.8750171779329 "$node_(674) setdest 12256 22227 18.0" 
$ns at 616.7516240819433 "$node_(675) setdest 124141 25799 16.0" 
$ns at 749.525880487254 "$node_(675) setdest 67215 18091 14.0" 
$ns at 802.4119513522305 "$node_(675) setdest 46787 39656 17.0" 
$ns at 631.2229540146247 "$node_(676) setdest 54219 6974 3.0" 
$ns at 675.0021664023753 "$node_(676) setdest 79081 12205 9.0" 
$ns at 746.2745701970751 "$node_(676) setdest 116711 31334 15.0" 
$ns at 865.377241450728 "$node_(676) setdest 13983 19735 2.0" 
$ns at 686.3216346543048 "$node_(677) setdest 58803 40100 13.0" 
$ns at 739.6465133731322 "$node_(677) setdest 104893 34257 2.0" 
$ns at 788.4613853063571 "$node_(677) setdest 29993 24448 2.0" 
$ns at 831.2873304694216 "$node_(677) setdest 73407 7171 1.0" 
$ns at 869.5803541873851 "$node_(677) setdest 27246 15987 14.0" 
$ns at 607.6146894159352 "$node_(678) setdest 77780 16005 12.0" 
$ns at 649.9868495541186 "$node_(678) setdest 71883 3058 1.0" 
$ns at 689.1511880647771 "$node_(678) setdest 42549 37380 4.0" 
$ns at 719.3784001861213 "$node_(678) setdest 89493 1533 11.0" 
$ns at 761.9188896441631 "$node_(678) setdest 103590 7796 17.0" 
$ns at 834.3404325842322 "$node_(678) setdest 92875 41492 9.0" 
$ns at 899.9036780031372 "$node_(678) setdest 109960 31873 19.0" 
$ns at 642.565182979746 "$node_(679) setdest 127210 15302 12.0" 
$ns at 709.7977098643678 "$node_(679) setdest 86667 22018 19.0" 
$ns at 663.6687484074845 "$node_(680) setdest 87880 1389 6.0" 
$ns at 703.8997586936534 "$node_(680) setdest 15137 41856 7.0" 
$ns at 790.78711082551 "$node_(680) setdest 13438 3636 8.0" 
$ns at 850.3971324899683 "$node_(680) setdest 37064 17229 9.0" 
$ns at 684.0911162832023 "$node_(681) setdest 93867 42171 3.0" 
$ns at 723.3432349762235 "$node_(681) setdest 90008 8029 12.0" 
$ns at 789.3204429390094 "$node_(681) setdest 2114 39392 17.0" 
$ns at 620.0083286469768 "$node_(682) setdest 87614 19421 8.0" 
$ns at 707.4599017739255 "$node_(682) setdest 41862 3870 17.0" 
$ns at 865.4352256642803 "$node_(682) setdest 2320 3832 18.0" 
$ns at 672.070805358043 "$node_(683) setdest 4076 24986 3.0" 
$ns at 729.5092116005014 "$node_(683) setdest 56388 39155 11.0" 
$ns at 835.1519275462779 "$node_(683) setdest 107300 29189 5.0" 
$ns at 869.8864261778871 "$node_(683) setdest 72444 25261 8.0" 
$ns at 628.6057853482586 "$node_(684) setdest 49812 4818 5.0" 
$ns at 678.0574773059851 "$node_(684) setdest 5411 35207 12.0" 
$ns at 726.6907734433912 "$node_(684) setdest 57976 5978 9.0" 
$ns at 810.4855972343454 "$node_(684) setdest 122642 19759 1.0" 
$ns at 845.507043457927 "$node_(684) setdest 91399 22059 8.0" 
$ns at 892.730247391479 "$node_(684) setdest 48507 41410 14.0" 
$ns at 625.7431323167616 "$node_(685) setdest 40115 31035 19.0" 
$ns at 837.4441920970919 "$node_(685) setdest 85100 30873 4.0" 
$ns at 870.280442608704 "$node_(685) setdest 70840 5148 4.0" 
$ns at 726.8881276627956 "$node_(686) setdest 124625 4112 16.0" 
$ns at 843.1343453630233 "$node_(686) setdest 28724 3652 6.0" 
$ns at 701.7820141309971 "$node_(687) setdest 32752 23057 10.0" 
$ns at 793.8635625027177 "$node_(687) setdest 45681 17658 2.0" 
$ns at 838.8250726329737 "$node_(687) setdest 94748 43020 9.0" 
$ns at 633.9098311547646 "$node_(688) setdest 28640 39481 2.0" 
$ns at 679.6783476997352 "$node_(688) setdest 46452 12668 15.0" 
$ns at 826.5066059909145 "$node_(688) setdest 7550 9654 1.0" 
$ns at 865.8465861427894 "$node_(688) setdest 28151 1225 17.0" 
$ns at 695.5039238381207 "$node_(689) setdest 30047 34568 2.0" 
$ns at 725.8547406150003 "$node_(689) setdest 2010 41741 16.0" 
$ns at 841.1526525068268 "$node_(689) setdest 75329 9685 14.0" 
$ns at 699.5395932109259 "$node_(690) setdest 42781 37226 4.0" 
$ns at 730.2323700973211 "$node_(690) setdest 73345 13145 6.0" 
$ns at 765.3837211514381 "$node_(690) setdest 101856 16647 1.0" 
$ns at 798.8540862294706 "$node_(690) setdest 51345 24690 16.0" 
$ns at 841.9859075468743 "$node_(690) setdest 79903 40106 7.0" 
$ns at 874.55133072047 "$node_(690) setdest 74376 15853 15.0" 
$ns at 608.0706223377232 "$node_(691) setdest 52959 44286 16.0" 
$ns at 716.9466393857276 "$node_(691) setdest 39390 31322 16.0" 
$ns at 771.0053102122652 "$node_(691) setdest 22296 14148 18.0" 
$ns at 819.9010292384245 "$node_(691) setdest 30699 3837 7.0" 
$ns at 899.1241401314953 "$node_(691) setdest 90528 41439 12.0" 
$ns at 738.6095050210365 "$node_(692) setdest 79935 45 20.0" 
$ns at 667.4512454653682 "$node_(693) setdest 35571 27948 9.0" 
$ns at 728.2504393829429 "$node_(693) setdest 41392 22748 3.0" 
$ns at 785.7317052083616 "$node_(693) setdest 98046 28266 18.0" 
$ns at 854.2578364225027 "$node_(693) setdest 33240 22211 6.0" 
$ns at 789.2304487577316 "$node_(694) setdest 27249 18472 6.0" 
$ns at 851.5401557040213 "$node_(694) setdest 117656 36141 1.0" 
$ns at 891.3271893308145 "$node_(694) setdest 14570 5622 11.0" 
$ns at 663.136781453109 "$node_(695) setdest 4839 26196 5.0" 
$ns at 710.9601213079842 "$node_(695) setdest 33051 39 5.0" 
$ns at 747.4527872389865 "$node_(695) setdest 64427 2224 17.0" 
$ns at 849.7000595297603 "$node_(695) setdest 1155 36730 18.0" 
$ns at 655.6520394129141 "$node_(696) setdest 37714 24953 2.0" 
$ns at 688.1150987890278 "$node_(696) setdest 58606 14599 14.0" 
$ns at 809.7518970386599 "$node_(696) setdest 104717 31641 19.0" 
$ns at 618.263723172816 "$node_(697) setdest 33138 33843 12.0" 
$ns at 740.8721253125874 "$node_(697) setdest 29596 24659 8.0" 
$ns at 813.2779033085594 "$node_(697) setdest 4836 41388 1.0" 
$ns at 851.1131319859542 "$node_(697) setdest 26009 10396 20.0" 
$ns at 611.2971778030103 "$node_(698) setdest 25769 23498 10.0" 
$ns at 715.8354209822429 "$node_(698) setdest 51209 39792 7.0" 
$ns at 798.3928826960775 "$node_(698) setdest 47598 523 8.0" 
$ns at 646.3108130332791 "$node_(699) setdest 18390 24190 19.0" 
$ns at 780.4795933067514 "$node_(699) setdest 52499 31230 4.0" 
$ns at 828.4063568025863 "$node_(699) setdest 113391 16725 14.0" 
$ns at 705.2135836184322 "$node_(700) setdest 49528 9552 4.0" 
$ns at 756.2043028751784 "$node_(700) setdest 107676 16532 17.0" 
$ns at 842.5993461060117 "$node_(700) setdest 1627 32531 11.0" 
$ns at 757.4063353321955 "$node_(701) setdest 69591 31272 11.0" 
$ns at 861.0961031666118 "$node_(701) setdest 126186 2995 19.0" 
$ns at 741.2485180956244 "$node_(702) setdest 33313 27567 16.0" 
$ns at 847.9376627243996 "$node_(702) setdest 39439 39749 12.0" 
$ns at 728.2031466818752 "$node_(703) setdest 9638 10309 8.0" 
$ns at 782.4872196859051 "$node_(703) setdest 86503 26181 15.0" 
$ns at 857.7248713683468 "$node_(703) setdest 113566 15120 5.0" 
$ns at 711.1685116065315 "$node_(704) setdest 23714 35513 13.0" 
$ns at 851.602991717848 "$node_(704) setdest 2690 20405 10.0" 
$ns at 752.5987735969951 "$node_(705) setdest 71314 40622 10.0" 
$ns at 835.5144946583468 "$node_(705) setdest 78312 18873 16.0" 
$ns at 728.9095953001063 "$node_(706) setdest 3644 25031 18.0" 
$ns at 774.2332929610259 "$node_(706) setdest 8004 26146 14.0" 
$ns at 874.8022701778425 "$node_(706) setdest 61260 12651 6.0" 
$ns at 730.4039918387347 "$node_(707) setdest 109445 39320 16.0" 
$ns at 765.4503994624537 "$node_(707) setdest 76734 42772 15.0" 
$ns at 802.9836064506377 "$node_(708) setdest 60106 13683 17.0" 
$ns at 875.3578330961976 "$node_(708) setdest 17481 2678 12.0" 
$ns at 743.4046332035239 "$node_(709) setdest 45527 34418 5.0" 
$ns at 793.9991507672565 "$node_(709) setdest 45778 15646 5.0" 
$ns at 848.8626314272741 "$node_(709) setdest 122930 11161 10.0" 
$ns at 743.7467645395614 "$node_(710) setdest 86023 28974 4.0" 
$ns at 813.5770007678183 "$node_(710) setdest 43577 37349 11.0" 
$ns at 713.4646903935031 "$node_(711) setdest 113972 35293 6.0" 
$ns at 762.827108419989 "$node_(711) setdest 119712 30587 6.0" 
$ns at 826.8796782239367 "$node_(711) setdest 14473 43556 15.0" 
$ns at 872.2836986564809 "$node_(711) setdest 33111 33589 15.0" 
$ns at 707.2391813007507 "$node_(712) setdest 3637 4112 12.0" 
$ns at 754.3104691999064 "$node_(712) setdest 7592 37990 6.0" 
$ns at 823.112955337679 "$node_(712) setdest 111697 21881 16.0" 
$ns at 752.390270870982 "$node_(713) setdest 100617 13627 9.0" 
$ns at 782.5678713984072 "$node_(713) setdest 91491 37591 1.0" 
$ns at 816.756705788127 "$node_(713) setdest 31881 44550 1.0" 
$ns at 846.96750204129 "$node_(713) setdest 25319 6558 8.0" 
$ns at 829.5545481791481 "$node_(714) setdest 4139 5079 19.0" 
$ns at 847.3655257672483 "$node_(715) setdest 40978 36490 3.0" 
$ns at 884.9126986454592 "$node_(715) setdest 52928 36953 4.0" 
$ns at 719.2915035561675 "$node_(716) setdest 53064 19236 8.0" 
$ns at 749.639093860624 "$node_(716) setdest 30764 19954 16.0" 
$ns at 885.48328329417 "$node_(716) setdest 18539 41802 2.0" 
$ns at 762.749304520777 "$node_(717) setdest 50556 12925 17.0" 
$ns at 716.5858483476569 "$node_(718) setdest 39383 8872 4.0" 
$ns at 771.9861220001728 "$node_(718) setdest 93651 31865 18.0" 
$ns at 862.8656967440138 "$node_(718) setdest 121365 6671 16.0" 
$ns at 741.4360478169706 "$node_(719) setdest 128391 25661 13.0" 
$ns at 897.7691803276346 "$node_(719) setdest 117133 40640 16.0" 
$ns at 747.800504815159 "$node_(720) setdest 95340 31170 13.0" 
$ns at 782.3618845635795 "$node_(720) setdest 37684 6910 10.0" 
$ns at 896.4334350605584 "$node_(720) setdest 93746 36806 8.0" 
$ns at 754.231285248096 "$node_(721) setdest 27902 26882 16.0" 
$ns at 828.9150903383348 "$node_(721) setdest 16759 27610 7.0" 
$ns at 738.9360521113415 "$node_(722) setdest 30397 4181 12.0" 
$ns at 861.7000807148416 "$node_(722) setdest 79344 35155 14.0" 
$ns at 700.1690236042425 "$node_(723) setdest 101858 1970 5.0" 
$ns at 767.5889992971007 "$node_(723) setdest 107397 40926 2.0" 
$ns at 815.4986509694605 "$node_(723) setdest 19452 33199 1.0" 
$ns at 851.5098659000846 "$node_(723) setdest 53420 19438 16.0" 
$ns at 762.191677663755 "$node_(724) setdest 27590 38440 11.0" 
$ns at 813.5721442040136 "$node_(724) setdest 129211 16308 1.0" 
$ns at 852.4955950131085 "$node_(724) setdest 134107 18384 9.0" 
$ns at 754.0470065486772 "$node_(725) setdest 21123 30592 4.0" 
$ns at 818.7132526888869 "$node_(725) setdest 75556 17353 5.0" 
$ns at 874.7434939060738 "$node_(725) setdest 60520 38 1.0" 
$ns at 786.639215906242 "$node_(726) setdest 105938 39353 8.0" 
$ns at 855.3373371388801 "$node_(726) setdest 54787 10259 12.0" 
$ns at 711.9761018741432 "$node_(727) setdest 53057 13414 11.0" 
$ns at 808.6264843966045 "$node_(727) setdest 87391 21254 17.0" 
$ns at 837.1727147147326 "$node_(728) setdest 38475 29792 14.0" 
$ns at 731.6436562848473 "$node_(729) setdest 30935 39533 15.0" 
$ns at 777.3241919542037 "$node_(729) setdest 39847 41311 11.0" 
$ns at 820.1191155785024 "$node_(729) setdest 42405 33824 20.0" 
$ns at 751.9355701790782 "$node_(730) setdest 67068 17522 8.0" 
$ns at 841.8210267623602 "$node_(730) setdest 1346 13074 17.0" 
$ns at 767.6304688567454 "$node_(731) setdest 17403 43931 6.0" 
$ns at 851.8069265219991 "$node_(731) setdest 103849 34546 6.0" 
$ns at 723.1529435736353 "$node_(732) setdest 103594 15479 10.0" 
$ns at 813.2142721674102 "$node_(732) setdest 56885 18896 6.0" 
$ns at 766.5439301937512 "$node_(733) setdest 81884 22700 9.0" 
$ns at 818.0897042500037 "$node_(733) setdest 76818 1812 5.0" 
$ns at 895.1700165028369 "$node_(733) setdest 126553 44124 11.0" 
$ns at 722.4046031466668 "$node_(734) setdest 93715 9513 8.0" 
$ns at 826.6159249871098 "$node_(734) setdest 88013 18265 8.0" 
$ns at 786.1025078581445 "$node_(735) setdest 31420 40271 14.0" 
$ns at 857.8230430372153 "$node_(735) setdest 58224 4685 4.0" 
$ns at 714.1918035067819 "$node_(736) setdest 117166 13124 2.0" 
$ns at 744.717562265815 "$node_(736) setdest 93618 35884 14.0" 
$ns at 888.6039108591165 "$node_(736) setdest 663 30352 4.0" 
$ns at 743.7873291829509 "$node_(737) setdest 115155 15278 12.0" 
$ns at 782.117379729608 "$node_(737) setdest 43856 38219 12.0" 
$ns at 753.173323111724 "$node_(738) setdest 63134 13018 7.0" 
$ns at 808.5521041892007 "$node_(738) setdest 111840 34558 17.0" 
$ns at 859.5301494670409 "$node_(738) setdest 80464 31389 16.0" 
$ns at 727.3639947474784 "$node_(739) setdest 23717 43996 19.0" 
$ns at 785.7399249422687 "$node_(739) setdest 62504 32657 7.0" 
$ns at 828.9533104918106 "$node_(739) setdest 102310 39967 13.0" 
$ns at 898.9220289427448 "$node_(739) setdest 25835 8299 4.0" 
$ns at 852.0854788666609 "$node_(740) setdest 42029 36878 15.0" 
$ns at 735.5903436849487 "$node_(741) setdest 26124 22531 13.0" 
$ns at 860.0668826525476 "$node_(741) setdest 133024 26547 12.0" 
$ns at 809.778569159319 "$node_(742) setdest 28738 34696 13.0" 
$ns at 785.5400133809997 "$node_(743) setdest 35638 21122 20.0" 
$ns at 878.8876926900103 "$node_(743) setdest 36234 6136 12.0" 
$ns at 728.8765840386793 "$node_(744) setdest 115465 38939 11.0" 
$ns at 844.4004592933965 "$node_(744) setdest 81801 776 2.0" 
$ns at 893.9656177636015 "$node_(744) setdest 1594 30355 14.0" 
$ns at 730.0087302290676 "$node_(745) setdest 13011 6075 3.0" 
$ns at 775.7760796074367 "$node_(745) setdest 69387 44017 1.0" 
$ns at 811.6871847821754 "$node_(745) setdest 67284 23598 6.0" 
$ns at 875.9122470616333 "$node_(745) setdest 56517 17774 17.0" 
$ns at 734.6477688984264 "$node_(746) setdest 56312 10929 9.0" 
$ns at 850.5656601680674 "$node_(746) setdest 117740 34780 10.0" 
$ns at 883.5103814347908 "$node_(746) setdest 69818 42832 9.0" 
$ns at 723.653817952318 "$node_(747) setdest 52535 27877 16.0" 
$ns at 827.3489242180889 "$node_(747) setdest 53769 18800 8.0" 
$ns at 735.7026628590829 "$node_(748) setdest 62497 23534 7.0" 
$ns at 811.560202666847 "$node_(748) setdest 80699 9992 2.0" 
$ns at 852.6611024719606 "$node_(748) setdest 33606 42145 3.0" 
$ns at 757.6567295086635 "$node_(749) setdest 86967 23059 15.0" 
$ns at 861.1668437472824 "$node_(749) setdest 31070 41576 9.0" 
$ns at 702.4551595921596 "$node_(750) setdest 46514 38728 19.0" 
$ns at 726.4447947051952 "$node_(751) setdest 106948 13693 16.0" 
$ns at 799.6787155452475 "$node_(751) setdest 128639 41522 4.0" 
$ns at 843.413071258046 "$node_(751) setdest 75886 1904 7.0" 
$ns at 723.159528115181 "$node_(752) setdest 42628 2588 11.0" 
$ns at 806.8085050866543 "$node_(752) setdest 97338 32775 2.0" 
$ns at 855.6718841330245 "$node_(752) setdest 52182 9334 13.0" 
$ns at 896.0266913237883 "$node_(752) setdest 38402 19834 1.0" 
$ns at 746.4712783950213 "$node_(753) setdest 33971 35791 4.0" 
$ns at 813.3511738955542 "$node_(753) setdest 131495 33808 1.0" 
$ns at 852.3462438831618 "$node_(753) setdest 99060 29040 15.0" 
$ns at 747.0724693809912 "$node_(754) setdest 6083 31319 5.0" 
$ns at 822.1501950516993 "$node_(754) setdest 122406 34470 4.0" 
$ns at 854.0095781104203 "$node_(754) setdest 15705 24078 18.0" 
$ns at 781.3772032809298 "$node_(755) setdest 23045 12082 18.0" 
$ns at 767.4486699032279 "$node_(756) setdest 87392 5320 11.0" 
$ns at 812.4719407580935 "$node_(756) setdest 63756 35980 1.0" 
$ns at 849.6579632998854 "$node_(756) setdest 86375 36905 8.0" 
$ns at 716.8690333896925 "$node_(757) setdest 64973 43913 15.0" 
$ns at 840.9503023671475 "$node_(757) setdest 18092 26975 17.0" 
$ns at 888.2194231131245 "$node_(757) setdest 103834 21401 7.0" 
$ns at 758.7261054360739 "$node_(758) setdest 105715 7228 19.0" 
$ns at 890.8555717194547 "$node_(758) setdest 55491 12609 16.0" 
$ns at 721.1327694099316 "$node_(759) setdest 103406 16605 15.0" 
$ns at 893.4654434009923 "$node_(759) setdest 61857 22255 11.0" 
$ns at 800.8637752709299 "$node_(760) setdest 123334 25151 5.0" 
$ns at 845.9310429075988 "$node_(760) setdest 73756 43846 2.0" 
$ns at 889.7801407396305 "$node_(760) setdest 100360 22161 9.0" 
$ns at 738.1073126469837 "$node_(761) setdest 60764 21707 1.0" 
$ns at 773.1235130999427 "$node_(761) setdest 80625 6435 2.0" 
$ns at 809.3584338680039 "$node_(761) setdest 118489 41433 5.0" 
$ns at 855.52692783966 "$node_(761) setdest 68598 16367 6.0" 
$ns at 733.0214200237232 "$node_(762) setdest 5931 13045 13.0" 
$ns at 815.3171053743552 "$node_(762) setdest 78389 19620 18.0" 
$ns at 710.0488062847967 "$node_(763) setdest 33882 20554 1.0" 
$ns at 747.7844737389269 "$node_(763) setdest 13992 29498 12.0" 
$ns at 779.4584017276619 "$node_(763) setdest 122941 33894 2.0" 
$ns at 822.9177089490537 "$node_(763) setdest 73943 13225 6.0" 
$ns at 884.403908453812 "$node_(763) setdest 11137 23950 1.0" 
$ns at 827.7912990454884 "$node_(764) setdest 27310 7689 16.0" 
$ns at 730.0449178549223 "$node_(765) setdest 88422 18524 10.0" 
$ns at 852.8110058523185 "$node_(765) setdest 61644 14204 1.0" 
$ns at 892.2303529812939 "$node_(765) setdest 2925 5566 4.0" 
$ns at 707.1741996822931 "$node_(766) setdest 58226 231 16.0" 
$ns at 753.3607068757124 "$node_(766) setdest 57043 11586 6.0" 
$ns at 806.0559158723263 "$node_(766) setdest 124217 26756 20.0" 
$ns at 850.777952687843 "$node_(766) setdest 42888 19433 4.0" 
$ns at 888.8848502727734 "$node_(766) setdest 122384 1884 14.0" 
$ns at 727.3021209121704 "$node_(767) setdest 106424 25791 1.0" 
$ns at 760.3194393804771 "$node_(767) setdest 94136 14013 20.0" 
$ns at 869.1752947085836 "$node_(767) setdest 79556 43889 8.0" 
$ns at 744.8613510433322 "$node_(768) setdest 120596 36442 7.0" 
$ns at 804.9119724141079 "$node_(768) setdest 90438 28966 14.0" 
$ns at 859.2142307738379 "$node_(768) setdest 64001 43400 10.0" 
$ns at 717.069894029763 "$node_(769) setdest 22157 5834 19.0" 
$ns at 724.0863439920731 "$node_(770) setdest 769 19540 10.0" 
$ns at 850.7243750847672 "$node_(770) setdest 133624 24811 13.0" 
$ns at 740.1000191818208 "$node_(771) setdest 52950 535 18.0" 
$ns at 838.9898499877871 "$node_(771) setdest 74802 10104 7.0" 
$ns at 888.1272207026911 "$node_(771) setdest 11804 11517 3.0" 
$ns at 824.2170824482225 "$node_(772) setdest 54393 38046 8.0" 
$ns at 895.2355578469995 "$node_(772) setdest 66612 3904 18.0" 
$ns at 742.7836302957351 "$node_(773) setdest 103748 30817 3.0" 
$ns at 789.8722598069725 "$node_(773) setdest 97681 31989 12.0" 
$ns at 837.2386037066138 "$node_(773) setdest 132915 42173 16.0" 
$ns at 889.9962215821631 "$node_(773) setdest 66590 26466 1.0" 
$ns at 714.659486407783 "$node_(774) setdest 110607 16179 14.0" 
$ns at 876.5074744864396 "$node_(774) setdest 105620 40345 10.0" 
$ns at 746.2344455871904 "$node_(775) setdest 65357 26772 6.0" 
$ns at 822.3247650479877 "$node_(775) setdest 6494 7459 13.0" 
$ns at 795.8099663711871 "$node_(776) setdest 62394 36321 16.0" 
$ns at 707.186283856329 "$node_(777) setdest 92202 37181 13.0" 
$ns at 786.5076045979804 "$node_(777) setdest 96223 26366 12.0" 
$ns at 853.0119709115584 "$node_(777) setdest 124691 32549 4.0" 
$ns at 751.4946015335995 "$node_(778) setdest 64878 4617 9.0" 
$ns at 825.0380641895026 "$node_(778) setdest 27694 1221 2.0" 
$ns at 866.4718730497575 "$node_(778) setdest 129465 22774 10.0" 
$ns at 712.3942338866741 "$node_(779) setdest 115468 23091 13.0" 
$ns at 865.8518743737282 "$node_(779) setdest 69775 13993 9.0" 
$ns at 716.9550179833653 "$node_(780) setdest 60379 17612 15.0" 
$ns at 869.4379229594128 "$node_(780) setdest 106703 16525 18.0" 
$ns at 700.611826837121 "$node_(781) setdest 28418 2854 13.0" 
$ns at 834.2186604198461 "$node_(781) setdest 34838 5917 3.0" 
$ns at 872.2537199354136 "$node_(781) setdest 28716 10350 8.0" 
$ns at 730.8156345319711 "$node_(782) setdest 37109 29154 16.0" 
$ns at 827.3693554962955 "$node_(782) setdest 43638 21093 8.0" 
$ns at 880.791160336008 "$node_(782) setdest 71560 29652 16.0" 
$ns at 766.8992018688722 "$node_(783) setdest 10734 2811 5.0" 
$ns at 817.018412705037 "$node_(783) setdest 8273 26767 3.0" 
$ns at 862.7465546603518 "$node_(783) setdest 65118 13266 18.0" 
$ns at 733.4729597890257 "$node_(784) setdest 66257 43025 18.0" 
$ns at 705.246067521106 "$node_(785) setdest 124205 20646 8.0" 
$ns at 773.9893128592719 "$node_(785) setdest 49738 22937 4.0" 
$ns at 815.6800216558613 "$node_(785) setdest 130708 16972 13.0" 
$ns at 703.7044254589553 "$node_(786) setdest 70508 8495 5.0" 
$ns at 759.8339644810476 "$node_(786) setdest 81617 7668 17.0" 
$ns at 853.1727048355089 "$node_(786) setdest 34890 40156 8.0" 
$ns at 731.5790031859065 "$node_(787) setdest 83275 22019 3.0" 
$ns at 779.2551646319993 "$node_(787) setdest 118484 16048 11.0" 
$ns at 882.8508099167404 "$node_(787) setdest 93488 1869 11.0" 
$ns at 707.8173840821162 "$node_(788) setdest 99688 29271 1.0" 
$ns at 745.1107626283438 "$node_(788) setdest 55963 5736 16.0" 
$ns at 856.9244465709575 "$node_(788) setdest 24023 18121 6.0" 
$ns at 895.6258743279827 "$node_(788) setdest 19837 1640 12.0" 
$ns at 726.1976222309432 "$node_(789) setdest 99260 26698 15.0" 
$ns at 853.1199105782687 "$node_(789) setdest 89342 37962 8.0" 
$ns at 738.0439052069124 "$node_(790) setdest 71954 28019 1.0" 
$ns at 772.2045822440407 "$node_(790) setdest 97043 38148 1.0" 
$ns at 808.0501989593419 "$node_(790) setdest 65468 42184 2.0" 
$ns at 849.6532937605562 "$node_(790) setdest 25773 27849 12.0" 
$ns at 749.0569693620796 "$node_(791) setdest 91818 10729 7.0" 
$ns at 805.3375348851004 "$node_(791) setdest 128102 13575 3.0" 
$ns at 847.657259038909 "$node_(791) setdest 93648 41302 18.0" 
$ns at 700.2309341055693 "$node_(792) setdest 80620 29473 19.0" 
$ns at 771.1170818048602 "$node_(792) setdest 72426 22172 13.0" 
$ns at 805.1561485349115 "$node_(792) setdest 11000 4234 5.0" 
$ns at 872.710957388257 "$node_(792) setdest 118306 1235 4.0" 
$ns at 832.3305227132919 "$node_(793) setdest 128443 929 4.0" 
$ns at 894.0321562462645 "$node_(793) setdest 83632 32404 18.0" 
$ns at 782.9195357066577 "$node_(794) setdest 104340 33713 14.0" 
$ns at 857.783328088477 "$node_(794) setdest 75742 44642 18.0" 
$ns at 716.7337519393415 "$node_(795) setdest 56259 13119 4.0" 
$ns at 755.7665373819356 "$node_(795) setdest 92040 42994 15.0" 
$ns at 821.7949400215499 "$node_(795) setdest 102279 20034 12.0" 
$ns at 804.4116915012789 "$node_(796) setdest 71935 2800 18.0" 
$ns at 734.3840197282462 "$node_(797) setdest 43724 1659 11.0" 
$ns at 806.145720895413 "$node_(797) setdest 22478 30833 20.0" 
$ns at 723.0938556125187 "$node_(798) setdest 96736 7439 1.0" 
$ns at 758.4416893830498 "$node_(798) setdest 38180 24177 14.0" 
$ns at 829.7279994909818 "$node_(798) setdest 133769 31028 8.0" 
$ns at 738.4497873977836 "$node_(799) setdest 79443 21780 2.0" 
$ns at 772.0391389543947 "$node_(799) setdest 60207 36116 12.0" 
$ns at 883.2943156463684 "$node_(799) setdest 76509 30475 2.0" 


#Set a TCP connection between node_(27) and node_(60)
set tcp_(0) [new Agent/TCP/Newreno]
$tcp_(0) set class_ 2
set sink_(0) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(0)
$ns attach-agent $node_(60) $sink_(0)
$ns connect $tcp_(0) $sink_(0)
set ftp_(0) [new Application/FTP]
$ftp_(0) attach-agent $tcp_(0)
$ns at 0.2 "$ftp_(0) start"
$ns at 180.0 "$ftp_(0) stop"

#Set a TCP connection between node_(71) and node_(13)
set tcp_(1) [new Agent/TCP/Newreno]
$tcp_(1) set class_ 2
set sink_(1) [new Agent/TCPSink]
$ns attach-agent $node_(71) $tcp_(1)
$ns attach-agent $node_(13) $sink_(1)
$ns connect $tcp_(1) $sink_(1)
set ftp_(1) [new Application/FTP]
$ftp_(1) attach-agent $tcp_(1)
$ns at 180.2 "$ftp_(1) start"
$ns at 360.0 "$ftp_(1) stop"

#Set a TCP connection between node_(18) and node_(55)
set tcp_(2) [new Agent/TCP/Newreno]
$tcp_(2) set class_ 2
set sink_(2) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(2)
$ns attach-agent $node_(55) $sink_(2)
$ns connect $tcp_(2) $sink_(2)
set ftp_(2) [new Application/FTP]
$ftp_(2) attach-agent $tcp_(2)
$ns at 360.2 "$ftp_(2) start"
$ns at 540.0 "$ftp_(2) stop"

#Set a TCP connection between node_(67) and node_(44)
set tcp_(3) [new Agent/TCP/Newreno]
$tcp_(3) set class_ 2
set sink_(3) [new Agent/TCPSink]
$ns attach-agent $node_(67) $tcp_(3)
$ns attach-agent $node_(44) $sink_(3)
$ns connect $tcp_(3) $sink_(3)
set ftp_(3) [new Application/FTP]
$ftp_(3) attach-agent $tcp_(3)
$ns at 540.2 "$ftp_(3) start"
$ns at 720.0 "$ftp_(3) stop"

#Set a TCP connection between node_(26) and node_(97)
set tcp_(4) [new Agent/TCP/Newreno]
$tcp_(4) set class_ 2
set sink_(4) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(4)
$ns attach-agent $node_(97) $sink_(4)
$ns connect $tcp_(4) $sink_(4)
set ftp_(4) [new Application/FTP]
$ftp_(4) attach-agent $tcp_(4)
$ns at 720.2 "$ftp_(4) start"
$ns at 900.0 "$ftp_(4) stop"

#Set a TCP connection between node_(1) and node_(37)
set tcp_(5) [new Agent/TCP/Newreno]
$tcp_(5) set class_ 2
set sink_(5) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(5)
$ns attach-agent $node_(37) $sink_(5)
$ns connect $tcp_(5) $sink_(5)
set ftp_(5) [new Application/FTP]
$ftp_(5) attach-agent $tcp_(5)
$ns at 0.2 "$ftp_(5) start"
$ns at 180.0 "$ftp_(5) stop"

#Set a TCP connection between node_(93) and node_(13)
set tcp_(6) [new Agent/TCP/Newreno]
$tcp_(6) set class_ 2
set sink_(6) [new Agent/TCPSink]
$ns attach-agent $node_(93) $tcp_(6)
$ns attach-agent $node_(13) $sink_(6)
$ns connect $tcp_(6) $sink_(6)
set ftp_(6) [new Application/FTP]
$ftp_(6) attach-agent $tcp_(6)
$ns at 180.2 "$ftp_(6) start"
$ns at 360.0 "$ftp_(6) stop"

#Set a TCP connection between node_(43) and node_(11)
set tcp_(7) [new Agent/TCP/Newreno]
$tcp_(7) set class_ 2
set sink_(7) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(7)
$ns attach-agent $node_(11) $sink_(7)
$ns connect $tcp_(7) $sink_(7)
set ftp_(7) [new Application/FTP]
$ftp_(7) attach-agent $tcp_(7)
$ns at 360.2 "$ftp_(7) start"
$ns at 540.0 "$ftp_(7) stop"

#Set a TCP connection between node_(5) and node_(24)
set tcp_(8) [new Agent/TCP/Newreno]
$tcp_(8) set class_ 2
set sink_(8) [new Agent/TCPSink]
$ns attach-agent $node_(5) $tcp_(8)
$ns attach-agent $node_(24) $sink_(8)
$ns connect $tcp_(8) $sink_(8)
set ftp_(8) [new Application/FTP]
$ftp_(8) attach-agent $tcp_(8)
$ns at 540.2 "$ftp_(8) start"
$ns at 720.0 "$ftp_(8) stop"

#Set a TCP connection between node_(80) and node_(84)
set tcp_(9) [new Agent/TCP/Newreno]
$tcp_(9) set class_ 2
set sink_(9) [new Agent/TCPSink]
$ns attach-agent $node_(80) $tcp_(9)
$ns attach-agent $node_(84) $sink_(9)
$ns connect $tcp_(9) $sink_(9)
set ftp_(9) [new Application/FTP]
$ftp_(9) attach-agent $tcp_(9)
$ns at 720.2 "$ftp_(9) start"
$ns at 900.0 "$ftp_(9) stop"

#Set a TCP connection between node_(67) and node_(80)
set tcp_(10) [new Agent/TCP/Newreno]
$tcp_(10) set class_ 2
set sink_(10) [new Agent/TCPSink]
$ns attach-agent $node_(67) $tcp_(10)
$ns attach-agent $node_(80) $sink_(10)
$ns connect $tcp_(10) $sink_(10)
set ftp_(10) [new Application/FTP]
$ftp_(10) attach-agent $tcp_(10)
$ns at 0.2 "$ftp_(10) start"
$ns at 180.0 "$ftp_(10) stop"

#Set a TCP connection between node_(11) and node_(68)
set tcp_(11) [new Agent/TCP/Newreno]
$tcp_(11) set class_ 2
set sink_(11) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(11)
$ns attach-agent $node_(68) $sink_(11)
$ns connect $tcp_(11) $sink_(11)
set ftp_(11) [new Application/FTP]
$ftp_(11) attach-agent $tcp_(11)
$ns at 180.2 "$ftp_(11) start"
$ns at 360.0 "$ftp_(11) stop"

#Set a TCP connection between node_(55) and node_(74)
set tcp_(12) [new Agent/TCP/Newreno]
$tcp_(12) set class_ 2
set sink_(12) [new Agent/TCPSink]
$ns attach-agent $node_(55) $tcp_(12)
$ns attach-agent $node_(74) $sink_(12)
$ns connect $tcp_(12) $sink_(12)
set ftp_(12) [new Application/FTP]
$ftp_(12) attach-agent $tcp_(12)
$ns at 360.2 "$ftp_(12) start"
$ns at 540.0 "$ftp_(12) stop"

#Set a TCP connection between node_(6) and node_(17)
set tcp_(13) [new Agent/TCP/Newreno]
$tcp_(13) set class_ 2
set sink_(13) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(13)
$ns attach-agent $node_(17) $sink_(13)
$ns connect $tcp_(13) $sink_(13)
set ftp_(13) [new Application/FTP]
$ftp_(13) attach-agent $tcp_(13)
$ns at 540.2 "$ftp_(13) start"
$ns at 720.0 "$ftp_(13) stop"

#Set a TCP connection between node_(77) and node_(98)
set tcp_(14) [new Agent/TCP/Newreno]
$tcp_(14) set class_ 2
set sink_(14) [new Agent/TCPSink]
$ns attach-agent $node_(77) $tcp_(14)
$ns attach-agent $node_(98) $sink_(14)
$ns connect $tcp_(14) $sink_(14)
set ftp_(14) [new Application/FTP]
$ftp_(14) attach-agent $tcp_(14)
$ns at 720.2 "$ftp_(14) start"
$ns at 900.0 "$ftp_(14) stop"

#Set a TCP connection between node_(12) and node_(88)
set tcp_(15) [new Agent/TCP/Newreno]
$tcp_(15) set class_ 2
set sink_(15) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(15)
$ns attach-agent $node_(88) $sink_(15)
$ns connect $tcp_(15) $sink_(15)
set ftp_(15) [new Application/FTP]
$ftp_(15) attach-agent $tcp_(15)
$ns at 0.2 "$ftp_(15) start"
$ns at 180.0 "$ftp_(15) stop"

#Set a TCP connection between node_(4) and node_(28)
set tcp_(16) [new Agent/TCP/Newreno]
$tcp_(16) set class_ 2
set sink_(16) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(16)
$ns attach-agent $node_(28) $sink_(16)
$ns connect $tcp_(16) $sink_(16)
set ftp_(16) [new Application/FTP]
$ftp_(16) attach-agent $tcp_(16)
$ns at 180.2 "$ftp_(16) start"
$ns at 360.0 "$ftp_(16) stop"

#Set a TCP connection between node_(96) and node_(93)
set tcp_(17) [new Agent/TCP/Newreno]
$tcp_(17) set class_ 2
set sink_(17) [new Agent/TCPSink]
$ns attach-agent $node_(96) $tcp_(17)
$ns attach-agent $node_(93) $sink_(17)
$ns connect $tcp_(17) $sink_(17)
set ftp_(17) [new Application/FTP]
$ftp_(17) attach-agent $tcp_(17)
$ns at 360.2 "$ftp_(17) start"
$ns at 540.0 "$ftp_(17) stop"

#Set a TCP connection between node_(52) and node_(80)
set tcp_(18) [new Agent/TCP/Newreno]
$tcp_(18) set class_ 2
set sink_(18) [new Agent/TCPSink]
$ns attach-agent $node_(52) $tcp_(18)
$ns attach-agent $node_(80) $sink_(18)
$ns connect $tcp_(18) $sink_(18)
set ftp_(18) [new Application/FTP]
$ftp_(18) attach-agent $tcp_(18)
$ns at 540.2 "$ftp_(18) start"
$ns at 720.0 "$ftp_(18) stop"

#Set a TCP connection between node_(44) and node_(28)
set tcp_(19) [new Agent/TCP/Newreno]
$tcp_(19) set class_ 2
set sink_(19) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(19)
$ns attach-agent $node_(28) $sink_(19)
$ns connect $tcp_(19) $sink_(19)
set ftp_(19) [new Application/FTP]
$ftp_(19) attach-agent $tcp_(19)
$ns at 720.2 "$ftp_(19) start"
$ns at 900.0 "$ftp_(19) stop"

#Set a TCP connection between node_(86) and node_(71)
set tcp_(20) [new Agent/TCP/Newreno]
$tcp_(20) set class_ 2
set sink_(20) [new Agent/TCPSink]
$ns attach-agent $node_(86) $tcp_(20)
$ns attach-agent $node_(71) $sink_(20)
$ns connect $tcp_(20) $sink_(20)
set ftp_(20) [new Application/FTP]
$ftp_(20) attach-agent $tcp_(20)
$ns at 0.2 "$ftp_(20) start"
$ns at 180.0 "$ftp_(20) stop"

#Set a TCP connection between node_(47) and node_(56)
set tcp_(21) [new Agent/TCP/Newreno]
$tcp_(21) set class_ 2
set sink_(21) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(21)
$ns attach-agent $node_(56) $sink_(21)
$ns connect $tcp_(21) $sink_(21)
set ftp_(21) [new Application/FTP]
$ftp_(21) attach-agent $tcp_(21)
$ns at 180.2 "$ftp_(21) start"
$ns at 360.0 "$ftp_(21) stop"

#Set a TCP connection between node_(14) and node_(22)
set tcp_(22) [new Agent/TCP/Newreno]
$tcp_(22) set class_ 2
set sink_(22) [new Agent/TCPSink]
$ns attach-agent $node_(14) $tcp_(22)
$ns attach-agent $node_(22) $sink_(22)
$ns connect $tcp_(22) $sink_(22)
set ftp_(22) [new Application/FTP]
$ftp_(22) attach-agent $tcp_(22)
$ns at 360.2 "$ftp_(22) start"
$ns at 540.0 "$ftp_(22) stop"

#Set a TCP connection between node_(18) and node_(73)
set tcp_(23) [new Agent/TCP/Newreno]
$tcp_(23) set class_ 2
set sink_(23) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(23)
$ns attach-agent $node_(73) $sink_(23)
$ns connect $tcp_(23) $sink_(23)
set ftp_(23) [new Application/FTP]
$ftp_(23) attach-agent $tcp_(23)
$ns at 540.2 "$ftp_(23) start"
$ns at 720.0 "$ftp_(23) stop"

#Set a TCP connection between node_(29) and node_(2)
set tcp_(24) [new Agent/TCP/Newreno]
$tcp_(24) set class_ 2
set sink_(24) [new Agent/TCPSink]
$ns attach-agent $node_(29) $tcp_(24)
$ns attach-agent $node_(2) $sink_(24)
$ns connect $tcp_(24) $sink_(24)
set ftp_(24) [new Application/FTP]
$ftp_(24) attach-agent $tcp_(24)
$ns at 720.2 "$ftp_(24) start"
$ns at 900.0 "$ftp_(24) stop"

#Set a TCP connection between node_(51) and node_(26)
set tcp_(25) [new Agent/TCP/Newreno]
$tcp_(25) set class_ 2
set sink_(25) [new Agent/TCPSink]
$ns attach-agent $node_(51) $tcp_(25)
$ns attach-agent $node_(26) $sink_(25)
$ns connect $tcp_(25) $sink_(25)
set ftp_(25) [new Application/FTP]
$ftp_(25) attach-agent $tcp_(25)
$ns at 0.2 "$ftp_(25) start"
$ns at 180.0 "$ftp_(25) stop"

#Set a TCP connection between node_(39) and node_(32)
set tcp_(26) [new Agent/TCP/Newreno]
$tcp_(26) set class_ 2
set sink_(26) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(26)
$ns attach-agent $node_(32) $sink_(26)
$ns connect $tcp_(26) $sink_(26)
set ftp_(26) [new Application/FTP]
$ftp_(26) attach-agent $tcp_(26)
$ns at 180.2 "$ftp_(26) start"
$ns at 360.0 "$ftp_(26) stop"

#Set a TCP connection between node_(44) and node_(17)
set tcp_(27) [new Agent/TCP/Newreno]
$tcp_(27) set class_ 2
set sink_(27) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(27)
$ns attach-agent $node_(17) $sink_(27)
$ns connect $tcp_(27) $sink_(27)
set ftp_(27) [new Application/FTP]
$ftp_(27) attach-agent $tcp_(27)
$ns at 360.2 "$ftp_(27) start"
$ns at 540.0 "$ftp_(27) stop"

#Set a TCP connection between node_(68) and node_(93)
set tcp_(28) [new Agent/TCP/Newreno]
$tcp_(28) set class_ 2
set sink_(28) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(28)
$ns attach-agent $node_(93) $sink_(28)
$ns connect $tcp_(28) $sink_(28)
set ftp_(28) [new Application/FTP]
$ftp_(28) attach-agent $tcp_(28)
$ns at 540.2 "$ftp_(28) start"
$ns at 720.0 "$ftp_(28) stop"

#Set a TCP connection between node_(55) and node_(92)
set tcp_(29) [new Agent/TCP/Newreno]
$tcp_(29) set class_ 2
set sink_(29) [new Agent/TCPSink]
$ns attach-agent $node_(55) $tcp_(29)
$ns attach-agent $node_(92) $sink_(29)
$ns connect $tcp_(29) $sink_(29)
set ftp_(29) [new Application/FTP]
$ftp_(29) attach-agent $tcp_(29)
$ns at 720.2 "$ftp_(29) start"
$ns at 900.0 "$ftp_(29) stop"

#Set a TCP connection between node_(90) and node_(52)
set tcp_(30) [new Agent/TCP/Newreno]
$tcp_(30) set class_ 2
set sink_(30) [new Agent/TCPSink]
$ns attach-agent $node_(90) $tcp_(30)
$ns attach-agent $node_(52) $sink_(30)
$ns connect $tcp_(30) $sink_(30)
set ftp_(30) [new Application/FTP]
$ftp_(30) attach-agent $tcp_(30)
$ns at 0.2 "$ftp_(30) start"
$ns at 180.0 "$ftp_(30) stop"

#Set a TCP connection between node_(56) and node_(54)
set tcp_(31) [new Agent/TCP/Newreno]
$tcp_(31) set class_ 2
set sink_(31) [new Agent/TCPSink]
$ns attach-agent $node_(56) $tcp_(31)
$ns attach-agent $node_(54) $sink_(31)
$ns connect $tcp_(31) $sink_(31)
set ftp_(31) [new Application/FTP]
$ftp_(31) attach-agent $tcp_(31)
$ns at 180.2 "$ftp_(31) start"
$ns at 360.0 "$ftp_(31) stop"

#Set a TCP connection between node_(98) and node_(85)
set tcp_(32) [new Agent/TCP/Newreno]
$tcp_(32) set class_ 2
set sink_(32) [new Agent/TCPSink]
$ns attach-agent $node_(98) $tcp_(32)
$ns attach-agent $node_(85) $sink_(32)
$ns connect $tcp_(32) $sink_(32)
set ftp_(32) [new Application/FTP]
$ftp_(32) attach-agent $tcp_(32)
$ns at 360.2 "$ftp_(32) start"
$ns at 540.0 "$ftp_(32) stop"

#Set a TCP connection between node_(73) and node_(71)
set tcp_(33) [new Agent/TCP/Newreno]
$tcp_(33) set class_ 2
set sink_(33) [new Agent/TCPSink]
$ns attach-agent $node_(73) $tcp_(33)
$ns attach-agent $node_(71) $sink_(33)
$ns connect $tcp_(33) $sink_(33)
set ftp_(33) [new Application/FTP]
$ftp_(33) attach-agent $tcp_(33)
$ns at 540.2 "$ftp_(33) start"
$ns at 720.0 "$ftp_(33) stop"

#Set a TCP connection between node_(48) and node_(92)
set tcp_(34) [new Agent/TCP/Newreno]
$tcp_(34) set class_ 2
set sink_(34) [new Agent/TCPSink]
$ns attach-agent $node_(48) $tcp_(34)
$ns attach-agent $node_(92) $sink_(34)
$ns connect $tcp_(34) $sink_(34)
set ftp_(34) [new Application/FTP]
$ftp_(34) attach-agent $tcp_(34)
$ns at 720.2 "$ftp_(34) start"
$ns at 900.0 "$ftp_(34) stop"

#Set a TCP connection between node_(70) and node_(64)
set tcp_(35) [new Agent/TCP/Newreno]
$tcp_(35) set class_ 2
set sink_(35) [new Agent/TCPSink]
$ns attach-agent $node_(70) $tcp_(35)
$ns attach-agent $node_(64) $sink_(35)
$ns connect $tcp_(35) $sink_(35)
set ftp_(35) [new Application/FTP]
$ftp_(35) attach-agent $tcp_(35)
$ns at 0.2 "$ftp_(35) start"
$ns at 180.0 "$ftp_(35) stop"

#Set a TCP connection between node_(35) and node_(48)
set tcp_(36) [new Agent/TCP/Newreno]
$tcp_(36) set class_ 2
set sink_(36) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(36)
$ns attach-agent $node_(48) $sink_(36)
$ns connect $tcp_(36) $sink_(36)
set ftp_(36) [new Application/FTP]
$ftp_(36) attach-agent $tcp_(36)
$ns at 180.2 "$ftp_(36) start"
$ns at 360.0 "$ftp_(36) stop"

#Set a TCP connection between node_(59) and node_(26)
set tcp_(37) [new Agent/TCP/Newreno]
$tcp_(37) set class_ 2
set sink_(37) [new Agent/TCPSink]
$ns attach-agent $node_(59) $tcp_(37)
$ns attach-agent $node_(26) $sink_(37)
$ns connect $tcp_(37) $sink_(37)
set ftp_(37) [new Application/FTP]
$ftp_(37) attach-agent $tcp_(37)
$ns at 360.2 "$ftp_(37) start"
$ns at 540.0 "$ftp_(37) stop"

#Set a TCP connection between node_(13) and node_(20)
set tcp_(38) [new Agent/TCP/Newreno]
$tcp_(38) set class_ 2
set sink_(38) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(38)
$ns attach-agent $node_(20) $sink_(38)
$ns connect $tcp_(38) $sink_(38)
set ftp_(38) [new Application/FTP]
$ftp_(38) attach-agent $tcp_(38)
$ns at 540.2 "$ftp_(38) start"
$ns at 720.0 "$ftp_(38) stop"

#Set a TCP connection between node_(44) and node_(48)
set tcp_(39) [new Agent/TCP/Newreno]
$tcp_(39) set class_ 2
set sink_(39) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(39)
$ns attach-agent $node_(48) $sink_(39)
$ns connect $tcp_(39) $sink_(39)
set ftp_(39) [new Application/FTP]
$ftp_(39) attach-agent $tcp_(39)
$ns at 720.2 "$ftp_(39) start"
$ns at 900.0 "$ftp_(39) stop"

#Set a TCP connection between node_(22) and node_(59)
set tcp_(40) [new Agent/TCP/Newreno]
$tcp_(40) set class_ 2
set sink_(40) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(40)
$ns attach-agent $node_(59) $sink_(40)
$ns connect $tcp_(40) $sink_(40)
set ftp_(40) [new Application/FTP]
$ftp_(40) attach-agent $tcp_(40)
$ns at 0.2 "$ftp_(40) start"
$ns at 180.0 "$ftp_(40) stop"

#Set a TCP connection between node_(35) and node_(9)
set tcp_(41) [new Agent/TCP/Newreno]
$tcp_(41) set class_ 2
set sink_(41) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(41)
$ns attach-agent $node_(9) $sink_(41)
$ns connect $tcp_(41) $sink_(41)
set ftp_(41) [new Application/FTP]
$ftp_(41) attach-agent $tcp_(41)
$ns at 180.2 "$ftp_(41) start"
$ns at 360.0 "$ftp_(41) stop"

#Set a TCP connection between node_(57) and node_(68)
set tcp_(42) [new Agent/TCP/Newreno]
$tcp_(42) set class_ 2
set sink_(42) [new Agent/TCPSink]
$ns attach-agent $node_(57) $tcp_(42)
$ns attach-agent $node_(68) $sink_(42)
$ns connect $tcp_(42) $sink_(42)
set ftp_(42) [new Application/FTP]
$ftp_(42) attach-agent $tcp_(42)
$ns at 360.2 "$ftp_(42) start"
$ns at 540.0 "$ftp_(42) stop"

#Set a TCP connection between node_(76) and node_(4)
set tcp_(43) [new Agent/TCP/Newreno]
$tcp_(43) set class_ 2
set sink_(43) [new Agent/TCPSink]
$ns attach-agent $node_(76) $tcp_(43)
$ns attach-agent $node_(4) $sink_(43)
$ns connect $tcp_(43) $sink_(43)
set ftp_(43) [new Application/FTP]
$ftp_(43) attach-agent $tcp_(43)
$ns at 540.2 "$ftp_(43) start"
$ns at 720.0 "$ftp_(43) stop"

#Set a TCP connection between node_(32) and node_(89)
set tcp_(44) [new Agent/TCP/Newreno]
$tcp_(44) set class_ 2
set sink_(44) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(44)
$ns attach-agent $node_(89) $sink_(44)
$ns connect $tcp_(44) $sink_(44)
set ftp_(44) [new Application/FTP]
$ftp_(44) attach-agent $tcp_(44)
$ns at 720.2 "$ftp_(44) start"
$ns at 900.0 "$ftp_(44) stop"

#Set a TCP connection between node_(1) and node_(61)
set tcp_(45) [new Agent/TCP/Newreno]
$tcp_(45) set class_ 2
set sink_(45) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(45)
$ns attach-agent $node_(61) $sink_(45)
$ns connect $tcp_(45) $sink_(45)
set ftp_(45) [new Application/FTP]
$ftp_(45) attach-agent $tcp_(45)
$ns at 0.2 "$ftp_(45) start"
$ns at 180.0 "$ftp_(45) stop"

#Set a TCP connection between node_(40) and node_(45)
set tcp_(46) [new Agent/TCP/Newreno]
$tcp_(46) set class_ 2
set sink_(46) [new Agent/TCPSink]
$ns attach-agent $node_(40) $tcp_(46)
$ns attach-agent $node_(45) $sink_(46)
$ns connect $tcp_(46) $sink_(46)
set ftp_(46) [new Application/FTP]
$ftp_(46) attach-agent $tcp_(46)
$ns at 180.2 "$ftp_(46) start"
$ns at 360.0 "$ftp_(46) stop"

#Set a TCP connection between node_(72) and node_(77)
set tcp_(47) [new Agent/TCP/Newreno]
$tcp_(47) set class_ 2
set sink_(47) [new Agent/TCPSink]
$ns attach-agent $node_(72) $tcp_(47)
$ns attach-agent $node_(77) $sink_(47)
$ns connect $tcp_(47) $sink_(47)
set ftp_(47) [new Application/FTP]
$ftp_(47) attach-agent $tcp_(47)
$ns at 360.2 "$ftp_(47) start"
$ns at 540.0 "$ftp_(47) stop"

#Set a TCP connection between node_(32) and node_(69)
set tcp_(48) [new Agent/TCP/Newreno]
$tcp_(48) set class_ 2
set sink_(48) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(48)
$ns attach-agent $node_(69) $sink_(48)
$ns connect $tcp_(48) $sink_(48)
set ftp_(48) [new Application/FTP]
$ftp_(48) attach-agent $tcp_(48)
$ns at 540.2 "$ftp_(48) start"
$ns at 720.0 "$ftp_(48) stop"

#Set a TCP connection between node_(91) and node_(68)
set tcp_(49) [new Agent/TCP/Newreno]
$tcp_(49) set class_ 2
set sink_(49) [new Agent/TCPSink]
$ns attach-agent $node_(91) $tcp_(49)
$ns attach-agent $node_(68) $sink_(49)
$ns connect $tcp_(49) $sink_(49)
set ftp_(49) [new Application/FTP]
$ftp_(49) attach-agent $tcp_(49)
$ns at 720.2 "$ftp_(49) start"
$ns at 900.0 "$ftp_(49) stop"

#Set a TCP connection between node_(27) and node_(70)
set tcp_(50) [new Agent/TCP/Newreno]
$tcp_(50) set class_ 2
set sink_(50) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(50)
$ns attach-agent $node_(70) $sink_(50)
$ns connect $tcp_(50) $sink_(50)
set ftp_(50) [new Application/FTP]
$ftp_(50) attach-agent $tcp_(50)
$ns at 0.2 "$ftp_(50) start"
$ns at 180.0 "$ftp_(50) stop"

#Set a TCP connection between node_(63) and node_(17)
set tcp_(51) [new Agent/TCP/Newreno]
$tcp_(51) set class_ 2
set sink_(51) [new Agent/TCPSink]
$ns attach-agent $node_(63) $tcp_(51)
$ns attach-agent $node_(17) $sink_(51)
$ns connect $tcp_(51) $sink_(51)
set ftp_(51) [new Application/FTP]
$ftp_(51) attach-agent $tcp_(51)
$ns at 180.2 "$ftp_(51) start"
$ns at 360.0 "$ftp_(51) stop"

#Set a TCP connection between node_(17) and node_(2)
set tcp_(52) [new Agent/TCP/Newreno]
$tcp_(52) set class_ 2
set sink_(52) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(52)
$ns attach-agent $node_(2) $sink_(52)
$ns connect $tcp_(52) $sink_(52)
set ftp_(52) [new Application/FTP]
$ftp_(52) attach-agent $tcp_(52)
$ns at 360.2 "$ftp_(52) start"
$ns at 540.0 "$ftp_(52) stop"

#Set a TCP connection between node_(55) and node_(69)
set tcp_(53) [new Agent/TCP/Newreno]
$tcp_(53) set class_ 2
set sink_(53) [new Agent/TCPSink]
$ns attach-agent $node_(55) $tcp_(53)
$ns attach-agent $node_(69) $sink_(53)
$ns connect $tcp_(53) $sink_(53)
set ftp_(53) [new Application/FTP]
$ftp_(53) attach-agent $tcp_(53)
$ns at 540.2 "$ftp_(53) start"
$ns at 720.0 "$ftp_(53) stop"

#Set a TCP connection between node_(63) and node_(67)
set tcp_(54) [new Agent/TCP/Newreno]
$tcp_(54) set class_ 2
set sink_(54) [new Agent/TCPSink]
$ns attach-agent $node_(63) $tcp_(54)
$ns attach-agent $node_(67) $sink_(54)
$ns connect $tcp_(54) $sink_(54)
set ftp_(54) [new Application/FTP]
$ftp_(54) attach-agent $tcp_(54)
$ns at 720.2 "$ftp_(54) start"
$ns at 900.0 "$ftp_(54) stop"

#Set a TCP connection between node_(38) and node_(21)
set tcp_(55) [new Agent/TCP/Newreno]
$tcp_(55) set class_ 2
set sink_(55) [new Agent/TCPSink]
$ns attach-agent $node_(38) $tcp_(55)
$ns attach-agent $node_(21) $sink_(55)
$ns connect $tcp_(55) $sink_(55)
set ftp_(55) [new Application/FTP]
$ftp_(55) attach-agent $tcp_(55)
$ns at 0.2 "$ftp_(55) start"
$ns at 180.0 "$ftp_(55) stop"

#Set a TCP connection between node_(27) and node_(28)
set tcp_(56) [new Agent/TCP/Newreno]
$tcp_(56) set class_ 2
set sink_(56) [new Agent/TCPSink]
$ns attach-agent $node_(27) $tcp_(56)
$ns attach-agent $node_(28) $sink_(56)
$ns connect $tcp_(56) $sink_(56)
set ftp_(56) [new Application/FTP]
$ftp_(56) attach-agent $tcp_(56)
$ns at 180.2 "$ftp_(56) start"
$ns at 360.0 "$ftp_(56) stop"

#Set a TCP connection between node_(52) and node_(54)
set tcp_(57) [new Agent/TCP/Newreno]
$tcp_(57) set class_ 2
set sink_(57) [new Agent/TCPSink]
$ns attach-agent $node_(52) $tcp_(57)
$ns attach-agent $node_(54) $sink_(57)
$ns connect $tcp_(57) $sink_(57)
set ftp_(57) [new Application/FTP]
$ftp_(57) attach-agent $tcp_(57)
$ns at 360.2 "$ftp_(57) start"
$ns at 540.0 "$ftp_(57) stop"

#Set a TCP connection between node_(99) and node_(83)
set tcp_(58) [new Agent/TCP/Newreno]
$tcp_(58) set class_ 2
set sink_(58) [new Agent/TCPSink]
$ns attach-agent $node_(99) $tcp_(58)
$ns attach-agent $node_(83) $sink_(58)
$ns connect $tcp_(58) $sink_(58)
set ftp_(58) [new Application/FTP]
$ftp_(58) attach-agent $tcp_(58)
$ns at 540.2 "$ftp_(58) start"
$ns at 720.0 "$ftp_(58) stop"

#Set a TCP connection between node_(51) and node_(60)
set tcp_(59) [new Agent/TCP/Newreno]
$tcp_(59) set class_ 2
set sink_(59) [new Agent/TCPSink]
$ns attach-agent $node_(51) $tcp_(59)
$ns attach-agent $node_(60) $sink_(59)
$ns connect $tcp_(59) $sink_(59)
set ftp_(59) [new Application/FTP]
$ftp_(59) attach-agent $tcp_(59)
$ns at 720.2 "$ftp_(59) start"
$ns at 900.0 "$ftp_(59) stop"

#Set a TCP connection between node_(6) and node_(70)
set tcp_(60) [new Agent/TCP/Newreno]
$tcp_(60) set class_ 2
set sink_(60) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(60)
$ns attach-agent $node_(70) $sink_(60)
$ns connect $tcp_(60) $sink_(60)
set ftp_(60) [new Application/FTP]
$ftp_(60) attach-agent $tcp_(60)
$ns at 0.2 "$ftp_(60) start"
$ns at 180.0 "$ftp_(60) stop"

#Set a TCP connection between node_(23) and node_(19)
set tcp_(61) [new Agent/TCP/Newreno]
$tcp_(61) set class_ 2
set sink_(61) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(61)
$ns attach-agent $node_(19) $sink_(61)
$ns connect $tcp_(61) $sink_(61)
set ftp_(61) [new Application/FTP]
$ftp_(61) attach-agent $tcp_(61)
$ns at 180.2 "$ftp_(61) start"
$ns at 360.0 "$ftp_(61) stop"

#Set a TCP connection between node_(77) and node_(26)
set tcp_(62) [new Agent/TCP/Newreno]
$tcp_(62) set class_ 2
set sink_(62) [new Agent/TCPSink]
$ns attach-agent $node_(77) $tcp_(62)
$ns attach-agent $node_(26) $sink_(62)
$ns connect $tcp_(62) $sink_(62)
set ftp_(62) [new Application/FTP]
$ftp_(62) attach-agent $tcp_(62)
$ns at 360.2 "$ftp_(62) start"
$ns at 540.0 "$ftp_(62) stop"

#Set a TCP connection between node_(98) and node_(0)
set tcp_(63) [new Agent/TCP/Newreno]
$tcp_(63) set class_ 2
set sink_(63) [new Agent/TCPSink]
$ns attach-agent $node_(98) $tcp_(63)
$ns attach-agent $node_(0) $sink_(63)
$ns connect $tcp_(63) $sink_(63)
set ftp_(63) [new Application/FTP]
$ftp_(63) attach-agent $tcp_(63)
$ns at 540.2 "$ftp_(63) start"
$ns at 720.0 "$ftp_(63) stop"

#Set a TCP connection between node_(70) and node_(15)
set tcp_(64) [new Agent/TCP/Newreno]
$tcp_(64) set class_ 2
set sink_(64) [new Agent/TCPSink]
$ns attach-agent $node_(70) $tcp_(64)
$ns attach-agent $node_(15) $sink_(64)
$ns connect $tcp_(64) $sink_(64)
set ftp_(64) [new Application/FTP]
$ftp_(64) attach-agent $tcp_(64)
$ns at 720.2 "$ftp_(64) start"
$ns at 900.0 "$ftp_(64) stop"

#Set a TCP connection between node_(50) and node_(43)
set tcp_(65) [new Agent/TCP/Newreno]
$tcp_(65) set class_ 2
set sink_(65) [new Agent/TCPSink]
$ns attach-agent $node_(50) $tcp_(65)
$ns attach-agent $node_(43) $sink_(65)
$ns connect $tcp_(65) $sink_(65)
set ftp_(65) [new Application/FTP]
$ftp_(65) attach-agent $tcp_(65)
$ns at 0.2 "$ftp_(65) start"
$ns at 180.0 "$ftp_(65) stop"

#Set a TCP connection between node_(8) and node_(20)
set tcp_(66) [new Agent/TCP/Newreno]
$tcp_(66) set class_ 2
set sink_(66) [new Agent/TCPSink]
$ns attach-agent $node_(8) $tcp_(66)
$ns attach-agent $node_(20) $sink_(66)
$ns connect $tcp_(66) $sink_(66)
set ftp_(66) [new Application/FTP]
$ftp_(66) attach-agent $tcp_(66)
$ns at 180.2 "$ftp_(66) start"
$ns at 360.0 "$ftp_(66) stop"

#Set a TCP connection between node_(84) and node_(68)
set tcp_(67) [new Agent/TCP/Newreno]
$tcp_(67) set class_ 2
set sink_(67) [new Agent/TCPSink]
$ns attach-agent $node_(84) $tcp_(67)
$ns attach-agent $node_(68) $sink_(67)
$ns connect $tcp_(67) $sink_(67)
set ftp_(67) [new Application/FTP]
$ftp_(67) attach-agent $tcp_(67)
$ns at 360.2 "$ftp_(67) start"
$ns at 540.0 "$ftp_(67) stop"

#Set a TCP connection between node_(90) and node_(85)
set tcp_(68) [new Agent/TCP/Newreno]
$tcp_(68) set class_ 2
set sink_(68) [new Agent/TCPSink]
$ns attach-agent $node_(90) $tcp_(68)
$ns attach-agent $node_(85) $sink_(68)
$ns connect $tcp_(68) $sink_(68)
set ftp_(68) [new Application/FTP]
$ftp_(68) attach-agent $tcp_(68)
$ns at 540.2 "$ftp_(68) start"
$ns at 720.0 "$ftp_(68) stop"

#Set a TCP connection between node_(34) and node_(18)
set tcp_(69) [new Agent/TCP/Newreno]
$tcp_(69) set class_ 2
set sink_(69) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(69)
$ns attach-agent $node_(18) $sink_(69)
$ns connect $tcp_(69) $sink_(69)
set ftp_(69) [new Application/FTP]
$ftp_(69) attach-agent $tcp_(69)
$ns at 720.2 "$ftp_(69) start"
$ns at 900.0 "$ftp_(69) stop"

#Set a TCP connection between node_(6) and node_(42)
set tcp_(70) [new Agent/TCP/Newreno]
$tcp_(70) set class_ 2
set sink_(70) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(70)
$ns attach-agent $node_(42) $sink_(70)
$ns connect $tcp_(70) $sink_(70)
set ftp_(70) [new Application/FTP]
$ftp_(70) attach-agent $tcp_(70)
$ns at 0.2 "$ftp_(70) start"
$ns at 180.0 "$ftp_(70) stop"

#Set a TCP connection between node_(9) and node_(42)
set tcp_(71) [new Agent/TCP/Newreno]
$tcp_(71) set class_ 2
set sink_(71) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(71)
$ns attach-agent $node_(42) $sink_(71)
$ns connect $tcp_(71) $sink_(71)
set ftp_(71) [new Application/FTP]
$ftp_(71) attach-agent $tcp_(71)
$ns at 180.2 "$ftp_(71) start"
$ns at 360.0 "$ftp_(71) stop"

#Set a TCP connection between node_(1) and node_(47)
set tcp_(72) [new Agent/TCP/Newreno]
$tcp_(72) set class_ 2
set sink_(72) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(72)
$ns attach-agent $node_(47) $sink_(72)
$ns connect $tcp_(72) $sink_(72)
set ftp_(72) [new Application/FTP]
$ftp_(72) attach-agent $tcp_(72)
$ns at 360.2 "$ftp_(72) start"
$ns at 540.0 "$ftp_(72) stop"

#Set a TCP connection between node_(45) and node_(36)
set tcp_(73) [new Agent/TCP/Newreno]
$tcp_(73) set class_ 2
set sink_(73) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(73)
$ns attach-agent $node_(36) $sink_(73)
$ns connect $tcp_(73) $sink_(73)
set ftp_(73) [new Application/FTP]
$ftp_(73) attach-agent $tcp_(73)
$ns at 540.2 "$ftp_(73) start"
$ns at 720.0 "$ftp_(73) stop"

#Set a TCP connection between node_(69) and node_(83)
set tcp_(74) [new Agent/TCP/Newreno]
$tcp_(74) set class_ 2
set sink_(74) [new Agent/TCPSink]
$ns attach-agent $node_(69) $tcp_(74)
$ns attach-agent $node_(83) $sink_(74)
$ns connect $tcp_(74) $sink_(74)
set ftp_(74) [new Application/FTP]
$ftp_(74) attach-agent $tcp_(74)
$ns at 720.2 "$ftp_(74) start"
$ns at 900.0 "$ftp_(74) stop"

#Set a TCP connection between node_(56) and node_(46)
set tcp_(75) [new Agent/TCP/Newreno]
$tcp_(75) set class_ 2
set sink_(75) [new Agent/TCPSink]
$ns attach-agent $node_(56) $tcp_(75)
$ns attach-agent $node_(46) $sink_(75)
$ns connect $tcp_(75) $sink_(75)
set ftp_(75) [new Application/FTP]
$ftp_(75) attach-agent $tcp_(75)
$ns at 0.2 "$ftp_(75) start"
$ns at 180.0 "$ftp_(75) stop"

#Set a TCP connection between node_(98) and node_(32)
set tcp_(76) [new Agent/TCP/Newreno]
$tcp_(76) set class_ 2
set sink_(76) [new Agent/TCPSink]
$ns attach-agent $node_(98) $tcp_(76)
$ns attach-agent $node_(32) $sink_(76)
$ns connect $tcp_(76) $sink_(76)
set ftp_(76) [new Application/FTP]
$ftp_(76) attach-agent $tcp_(76)
$ns at 180.2 "$ftp_(76) start"
$ns at 360.0 "$ftp_(76) stop"

#Set a TCP connection between node_(17) and node_(29)
set tcp_(77) [new Agent/TCP/Newreno]
$tcp_(77) set class_ 2
set sink_(77) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(77)
$ns attach-agent $node_(29) $sink_(77)
$ns connect $tcp_(77) $sink_(77)
set ftp_(77) [new Application/FTP]
$ftp_(77) attach-agent $tcp_(77)
$ns at 360.2 "$ftp_(77) start"
$ns at 540.0 "$ftp_(77) stop"

#Set a TCP connection between node_(12) and node_(37)
set tcp_(78) [new Agent/TCP/Newreno]
$tcp_(78) set class_ 2
set sink_(78) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(78)
$ns attach-agent $node_(37) $sink_(78)
$ns connect $tcp_(78) $sink_(78)
set ftp_(78) [new Application/FTP]
$ftp_(78) attach-agent $tcp_(78)
$ns at 540.2 "$ftp_(78) start"
$ns at 720.0 "$ftp_(78) stop"

#Set a TCP connection between node_(78) and node_(77)
set tcp_(79) [new Agent/TCP/Newreno]
$tcp_(79) set class_ 2
set sink_(79) [new Agent/TCPSink]
$ns attach-agent $node_(78) $tcp_(79)
$ns attach-agent $node_(77) $sink_(79)
$ns connect $tcp_(79) $sink_(79)
set ftp_(79) [new Application/FTP]
$ftp_(79) attach-agent $tcp_(79)
$ns at 720.2 "$ftp_(79) start"
$ns at 900.0 "$ftp_(79) stop"

#Set a TCP connection between node_(95) and node_(58)
set tcp_(80) [new Agent/TCP/Newreno]
$tcp_(80) set class_ 2
set sink_(80) [new Agent/TCPSink]
$ns attach-agent $node_(95) $tcp_(80)
$ns attach-agent $node_(58) $sink_(80)
$ns connect $tcp_(80) $sink_(80)
set ftp_(80) [new Application/FTP]
$ftp_(80) attach-agent $tcp_(80)
$ns at 0.2 "$ftp_(80) start"
$ns at 180.0 "$ftp_(80) stop"

#Set a TCP connection between node_(18) and node_(1)
set tcp_(81) [new Agent/TCP/Newreno]
$tcp_(81) set class_ 2
set sink_(81) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(81)
$ns attach-agent $node_(1) $sink_(81)
$ns connect $tcp_(81) $sink_(81)
set ftp_(81) [new Application/FTP]
$ftp_(81) attach-agent $tcp_(81)
$ns at 180.2 "$ftp_(81) start"
$ns at 360.0 "$ftp_(81) stop"

#Set a TCP connection between node_(87) and node_(20)
set tcp_(82) [new Agent/TCP/Newreno]
$tcp_(82) set class_ 2
set sink_(82) [new Agent/TCPSink]
$ns attach-agent $node_(87) $tcp_(82)
$ns attach-agent $node_(20) $sink_(82)
$ns connect $tcp_(82) $sink_(82)
set ftp_(82) [new Application/FTP]
$ftp_(82) attach-agent $tcp_(82)
$ns at 360.2 "$ftp_(82) start"
$ns at 540.0 "$ftp_(82) stop"

#Set a TCP connection between node_(71) and node_(23)
set tcp_(83) [new Agent/TCP/Newreno]
$tcp_(83) set class_ 2
set sink_(83) [new Agent/TCPSink]
$ns attach-agent $node_(71) $tcp_(83)
$ns attach-agent $node_(23) $sink_(83)
$ns connect $tcp_(83) $sink_(83)
set ftp_(83) [new Application/FTP]
$ftp_(83) attach-agent $tcp_(83)
$ns at 540.2 "$ftp_(83) start"
$ns at 720.0 "$ftp_(83) stop"

#Set a TCP connection between node_(30) and node_(20)
set tcp_(84) [new Agent/TCP/Newreno]
$tcp_(84) set class_ 2
set sink_(84) [new Agent/TCPSink]
$ns attach-agent $node_(30) $tcp_(84)
$ns attach-agent $node_(20) $sink_(84)
$ns connect $tcp_(84) $sink_(84)
set ftp_(84) [new Application/FTP]
$ftp_(84) attach-agent $tcp_(84)
$ns at 720.2 "$ftp_(84) start"
$ns at 900.0 "$ftp_(84) stop"

#Set a TCP connection between node_(80) and node_(2)
set tcp_(85) [new Agent/TCP/Newreno]
$tcp_(85) set class_ 2
set sink_(85) [new Agent/TCPSink]
$ns attach-agent $node_(80) $tcp_(85)
$ns attach-agent $node_(2) $sink_(85)
$ns connect $tcp_(85) $sink_(85)
set ftp_(85) [new Application/FTP]
$ftp_(85) attach-agent $tcp_(85)
$ns at 0.2 "$ftp_(85) start"
$ns at 180.0 "$ftp_(85) stop"

#Set a TCP connection between node_(64) and node_(69)
set tcp_(86) [new Agent/TCP/Newreno]
$tcp_(86) set class_ 2
set sink_(86) [new Agent/TCPSink]
$ns attach-agent $node_(64) $tcp_(86)
$ns attach-agent $node_(69) $sink_(86)
$ns connect $tcp_(86) $sink_(86)
set ftp_(86) [new Application/FTP]
$ftp_(86) attach-agent $tcp_(86)
$ns at 180.2 "$ftp_(86) start"
$ns at 360.0 "$ftp_(86) stop"

#Set a TCP connection between node_(15) and node_(11)
set tcp_(87) [new Agent/TCP/Newreno]
$tcp_(87) set class_ 2
set sink_(87) [new Agent/TCPSink]
$ns attach-agent $node_(15) $tcp_(87)
$ns attach-agent $node_(11) $sink_(87)
$ns connect $tcp_(87) $sink_(87)
set ftp_(87) [new Application/FTP]
$ftp_(87) attach-agent $tcp_(87)
$ns at 360.2 "$ftp_(87) start"
$ns at 540.0 "$ftp_(87) stop"

#Set a TCP connection between node_(49) and node_(34)
set tcp_(88) [new Agent/TCP/Newreno]
$tcp_(88) set class_ 2
set sink_(88) [new Agent/TCPSink]
$ns attach-agent $node_(49) $tcp_(88)
$ns attach-agent $node_(34) $sink_(88)
$ns connect $tcp_(88) $sink_(88)
set ftp_(88) [new Application/FTP]
$ftp_(88) attach-agent $tcp_(88)
$ns at 540.2 "$ftp_(88) start"
$ns at 720.0 "$ftp_(88) stop"

#Set a TCP connection between node_(6) and node_(50)
set tcp_(89) [new Agent/TCP/Newreno]
$tcp_(89) set class_ 2
set sink_(89) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(89)
$ns attach-agent $node_(50) $sink_(89)
$ns connect $tcp_(89) $sink_(89)
set ftp_(89) [new Application/FTP]
$ftp_(89) attach-agent $tcp_(89)
$ns at 720.2 "$ftp_(89) start"
$ns at 900.0 "$ftp_(89) stop"

#Set a TCP connection between node_(37) and node_(84)
set tcp_(90) [new Agent/TCP/Newreno]
$tcp_(90) set class_ 2
set sink_(90) [new Agent/TCPSink]
$ns attach-agent $node_(37) $tcp_(90)
$ns attach-agent $node_(84) $sink_(90)
$ns connect $tcp_(90) $sink_(90)
set ftp_(90) [new Application/FTP]
$ftp_(90) attach-agent $tcp_(90)
$ns at 0.2 "$ftp_(90) start"
$ns at 180.0 "$ftp_(90) stop"

#Set a TCP connection between node_(19) and node_(15)
set tcp_(91) [new Agent/TCP/Newreno]
$tcp_(91) set class_ 2
set sink_(91) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(91)
$ns attach-agent $node_(15) $sink_(91)
$ns connect $tcp_(91) $sink_(91)
set ftp_(91) [new Application/FTP]
$ftp_(91) attach-agent $tcp_(91)
$ns at 180.2 "$ftp_(91) start"
$ns at 360.0 "$ftp_(91) stop"

#Set a TCP connection between node_(32) and node_(95)
set tcp_(92) [new Agent/TCP/Newreno]
$tcp_(92) set class_ 2
set sink_(92) [new Agent/TCPSink]
$ns attach-agent $node_(32) $tcp_(92)
$ns attach-agent $node_(95) $sink_(92)
$ns connect $tcp_(92) $sink_(92)
set ftp_(92) [new Application/FTP]
$ftp_(92) attach-agent $tcp_(92)
$ns at 360.2 "$ftp_(92) start"
$ns at 540.0 "$ftp_(92) stop"

#Set a TCP connection between node_(59) and node_(69)
set tcp_(93) [new Agent/TCP/Newreno]
$tcp_(93) set class_ 2
set sink_(93) [new Agent/TCPSink]
$ns attach-agent $node_(59) $tcp_(93)
$ns attach-agent $node_(69) $sink_(93)
$ns connect $tcp_(93) $sink_(93)
set ftp_(93) [new Application/FTP]
$ftp_(93) attach-agent $tcp_(93)
$ns at 540.2 "$ftp_(93) start"
$ns at 720.0 "$ftp_(93) stop"

#Set a TCP connection between node_(91) and node_(98)
set tcp_(94) [new Agent/TCP/Newreno]
$tcp_(94) set class_ 2
set sink_(94) [new Agent/TCPSink]
$ns attach-agent $node_(91) $tcp_(94)
$ns attach-agent $node_(98) $sink_(94)
$ns connect $tcp_(94) $sink_(94)
set ftp_(94) [new Application/FTP]
$ftp_(94) attach-agent $tcp_(94)
$ns at 720.2 "$ftp_(94) start"
$ns at 900.0 "$ftp_(94) stop"

#Set a TCP connection between node_(84) and node_(26)
set tcp_(95) [new Agent/TCP/Newreno]
$tcp_(95) set class_ 2
set sink_(95) [new Agent/TCPSink]
$ns attach-agent $node_(84) $tcp_(95)
$ns attach-agent $node_(26) $sink_(95)
$ns connect $tcp_(95) $sink_(95)
set ftp_(95) [new Application/FTP]
$ftp_(95) attach-agent $tcp_(95)
$ns at 0.2 "$ftp_(95) start"
$ns at 180.0 "$ftp_(95) stop"

#Set a TCP connection between node_(2) and node_(66)
set tcp_(96) [new Agent/TCP/Newreno]
$tcp_(96) set class_ 2
set sink_(96) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(96)
$ns attach-agent $node_(66) $sink_(96)
$ns connect $tcp_(96) $sink_(96)
set ftp_(96) [new Application/FTP]
$ftp_(96) attach-agent $tcp_(96)
$ns at 180.2 "$ftp_(96) start"
$ns at 360.0 "$ftp_(96) stop"

#Set a TCP connection between node_(24) and node_(26)
set tcp_(97) [new Agent/TCP/Newreno]
$tcp_(97) set class_ 2
set sink_(97) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(97)
$ns attach-agent $node_(26) $sink_(97)
$ns connect $tcp_(97) $sink_(97)
set ftp_(97) [new Application/FTP]
$ftp_(97) attach-agent $tcp_(97)
$ns at 360.2 "$ftp_(97) start"
$ns at 540.0 "$ftp_(97) stop"

#Set a TCP connection between node_(55) and node_(86)
set tcp_(98) [new Agent/TCP/Newreno]
$tcp_(98) set class_ 2
set sink_(98) [new Agent/TCPSink]
$ns attach-agent $node_(55) $tcp_(98)
$ns attach-agent $node_(86) $sink_(98)
$ns connect $tcp_(98) $sink_(98)
set ftp_(98) [new Application/FTP]
$ftp_(98) attach-agent $tcp_(98)
$ns at 540.2 "$ftp_(98) start"
$ns at 720.0 "$ftp_(98) stop"

#Set a TCP connection between node_(92) and node_(31)
set tcp_(99) [new Agent/TCP/Newreno]
$tcp_(99) set class_ 2
set sink_(99) [new Agent/TCPSink]
$ns attach-agent $node_(92) $tcp_(99)
$ns attach-agent $node_(31) $sink_(99)
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
