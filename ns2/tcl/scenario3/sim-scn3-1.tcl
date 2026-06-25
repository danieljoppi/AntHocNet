#sim-scn3-1.tcl 
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
set tracefd       [open sim-scn3-1-$val(rp)-trace.tr w]
set windowVsTime2 [open sim-scn3-1-$val(rp)-win-.tr w]
set namtrace      [open sim-scn3-1-$val(rp).nam w]

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
$node_(0) set X_ 1653 
$node_(0) set Y_ 714 
$node_(0) set Z_ 0.0 
$node_(1) set X_ 928 
$node_(1) set Y_ 123 
$node_(1) set Z_ 0.0 
$node_(2) set X_ 434 
$node_(2) set Y_ 488 
$node_(2) set Z_ 0.0 
$node_(3) set X_ 970 
$node_(3) set Y_ 984 
$node_(3) set Z_ 0.0 
$node_(4) set X_ 2673 
$node_(4) set Y_ 47 
$node_(4) set Z_ 0.0 
$node_(5) set X_ 2262 
$node_(5) set Y_ 202 
$node_(5) set Z_ 0.0 
$node_(6) set X_ 497 
$node_(6) set Y_ 710 
$node_(6) set Z_ 0.0 
$node_(7) set X_ 337 
$node_(7) set Y_ 819 
$node_(7) set Z_ 0.0 
$node_(8) set X_ 797 
$node_(8) set Y_ 122 
$node_(8) set Z_ 0.0 
$node_(9) set X_ 566 
$node_(9) set Y_ 366 
$node_(9) set Z_ 0.0 
$node_(10) set X_ 611 
$node_(10) set Y_ 95 
$node_(10) set Z_ 0.0 
$node_(11) set X_ 1131 
$node_(11) set Y_ 620 
$node_(11) set Z_ 0.0 
$node_(12) set X_ 2750 
$node_(12) set Y_ 971 
$node_(12) set Z_ 0.0 
$node_(13) set X_ 2098 
$node_(13) set Y_ 13 
$node_(13) set Z_ 0.0 
$node_(14) set X_ 2365 
$node_(14) set Y_ 674 
$node_(14) set Z_ 0.0 
$node_(15) set X_ 1744 
$node_(15) set Y_ 928 
$node_(15) set Z_ 0.0 
$node_(16) set X_ 1440 
$node_(16) set Y_ 617 
$node_(16) set Z_ 0.0 
$node_(17) set X_ 2175 
$node_(17) set Y_ 489 
$node_(17) set Z_ 0.0 
$node_(18) set X_ 2433 
$node_(18) set Y_ 611 
$node_(18) set Z_ 0.0 
$node_(19) set X_ 2644 
$node_(19) set Y_ 242 
$node_(19) set Z_ 0.0 
$node_(20) set X_ 2492 
$node_(20) set Y_ 748 
$node_(20) set Z_ 0.0 
$node_(21) set X_ 2761 
$node_(21) set Y_ 259 
$node_(21) set Z_ 0.0 
$node_(22) set X_ 861 
$node_(22) set Y_ 2 
$node_(22) set Z_ 0.0 
$node_(23) set X_ 1108 
$node_(23) set Y_ 826 
$node_(23) set Z_ 0.0 
$node_(24) set X_ 1226 
$node_(24) set Y_ 934 
$node_(24) set Z_ 0.0 
$node_(25) set X_ 1507 
$node_(25) set Y_ 833 
$node_(25) set Z_ 0.0 
$node_(26) set X_ 886 
$node_(26) set Y_ 465 
$node_(26) set Z_ 0.0 
$node_(27) set X_ 438 
$node_(27) set Y_ 391 
$node_(27) set Z_ 0.0 
$node_(28) set X_ 694 
$node_(28) set Y_ 165 
$node_(28) set Z_ 0.0 
$node_(29) set X_ 1765 
$node_(29) set Y_ 3 
$node_(29) set Z_ 0.0 
$node_(30) set X_ 2791 
$node_(30) set Y_ 859 
$node_(30) set Z_ 0.0 
$node_(31) set X_ 1120 
$node_(31) set Y_ 830 
$node_(31) set Z_ 0.0 
$node_(32) set X_ 161 
$node_(32) set Y_ 666 
$node_(32) set Z_ 0.0 
$node_(33) set X_ 920 
$node_(33) set Y_ 183 
$node_(33) set Z_ 0.0 
$node_(34) set X_ 1036 
$node_(34) set Y_ 761 
$node_(34) set Z_ 0.0 
$node_(35) set X_ 2081 
$node_(35) set Y_ 431 
$node_(35) set Z_ 0.0 
$node_(36) set X_ 1137 
$node_(36) set Y_ 249 
$node_(36) set Z_ 0.0 
$node_(37) set X_ 2074 
$node_(37) set Y_ 907 
$node_(37) set Z_ 0.0 
$node_(38) set X_ 663 
$node_(38) set Y_ 561 
$node_(38) set Z_ 0.0 
$node_(39) set X_ 2005 
$node_(39) set Y_ 241 
$node_(39) set Z_ 0.0 
$node_(40) set X_ 841 
$node_(40) set Y_ 675 
$node_(40) set Z_ 0.0 
$node_(41) set X_ 1902 
$node_(41) set Y_ 795 
$node_(41) set Z_ 0.0 
$node_(42) set X_ 719 
$node_(42) set Y_ 283 
$node_(42) set Z_ 0.0 
$node_(43) set X_ 372 
$node_(43) set Y_ 508 
$node_(43) set Z_ 0.0 
$node_(44) set X_ 710 
$node_(44) set Y_ 776 
$node_(44) set Z_ 0.0 
$node_(45) set X_ 1236 
$node_(45) set Y_ 517 
$node_(45) set Z_ 0.0 
$node_(46) set X_ 1201 
$node_(46) set Y_ 499 
$node_(46) set Z_ 0.0 
$node_(47) set X_ 1661 
$node_(47) set Y_ 377 
$node_(47) set Z_ 0.0 
$node_(48) set X_ 1333 
$node_(48) set Y_ 320 
$node_(48) set Z_ 0.0 
$node_(49) set X_ 1685 
$node_(49) set Y_ 574 
$node_(49) set Z_ 0.0 
$node_(50) set X_ 755 
$node_(50) set Y_ 954 
$node_(50) set Z_ 0.0 
$node_(51) set X_ 2902 
$node_(51) set Y_ 270 
$node_(51) set Z_ 0.0 
$node_(52) set X_ 924 
$node_(52) set Y_ 857 
$node_(52) set Z_ 0.0 
$node_(53) set X_ 352 
$node_(53) set Y_ 944 
$node_(53) set Z_ 0.0 
$node_(54) set X_ 1140 
$node_(54) set Y_ 756 
$node_(54) set Z_ 0.0 
$node_(55) set X_ 2510 
$node_(55) set Y_ 616 
$node_(55) set Z_ 0.0 
$node_(56) set X_ 208 
$node_(56) set Y_ 33 
$node_(56) set Z_ 0.0 
$node_(57) set X_ 1452 
$node_(57) set Y_ 885 
$node_(57) set Z_ 0.0 
$node_(58) set X_ 2193 
$node_(58) set Y_ 254 
$node_(58) set Z_ 0.0 
$node_(59) set X_ 78 
$node_(59) set Y_ 866 
$node_(59) set Z_ 0.0 
$node_(60) set X_ 2341 
$node_(60) set Y_ 116 
$node_(60) set Z_ 0.0 
$node_(61) set X_ 1393 
$node_(61) set Y_ 448 
$node_(61) set Z_ 0.0 
$node_(62) set X_ 1794 
$node_(62) set Y_ 952 
$node_(62) set Z_ 0.0 
$node_(63) set X_ 2573 
$node_(63) set Y_ 964 
$node_(63) set Z_ 0.0 
$node_(64) set X_ 231 
$node_(64) set Y_ 716 
$node_(64) set Z_ 0.0 
$node_(65) set X_ 630 
$node_(65) set Y_ 518 
$node_(65) set Z_ 0.0 
$node_(66) set X_ 1080 
$node_(66) set Y_ 95 
$node_(66) set Z_ 0.0 
$node_(67) set X_ 2112 
$node_(67) set Y_ 704 
$node_(67) set Z_ 0.0 
$node_(68) set X_ 1392 
$node_(68) set Y_ 941 
$node_(68) set Z_ 0.0 
$node_(69) set X_ 346 
$node_(69) set Y_ 402 
$node_(69) set Z_ 0.0 
$node_(70) set X_ 901 
$node_(70) set Y_ 773 
$node_(70) set Z_ 0.0 
$node_(71) set X_ 2251 
$node_(71) set Y_ 641 
$node_(71) set Z_ 0.0 
$node_(72) set X_ 192 
$node_(72) set Y_ 475 
$node_(72) set Z_ 0.0 
$node_(73) set X_ 2775 
$node_(73) set Y_ 296 
$node_(73) set Z_ 0.0 
$node_(74) set X_ 263 
$node_(74) set Y_ 653 
$node_(74) set Z_ 0.0 
$node_(75) set X_ 2477 
$node_(75) set Y_ 490 
$node_(75) set Z_ 0.0 
$node_(76) set X_ 111 
$node_(76) set Y_ 320 
$node_(76) set Z_ 0.0 
$node_(77) set X_ 1714 
$node_(77) set Y_ 161 
$node_(77) set Z_ 0.0 
$node_(78) set X_ 2255 
$node_(78) set Y_ 727 
$node_(78) set Z_ 0.0 
$node_(79) set X_ 1325 
$node_(79) set Y_ 185 
$node_(79) set Z_ 0.0 
$node_(80) set X_ 404 
$node_(80) set Y_ 184 
$node_(80) set Z_ 0.0 
$node_(81) set X_ 1550 
$node_(81) set Y_ 822 
$node_(81) set Z_ 0.0 
$node_(82) set X_ 712 
$node_(82) set Y_ 654 
$node_(82) set Z_ 0.0 
$node_(83) set X_ 1322 
$node_(83) set Y_ 25 
$node_(83) set Z_ 0.0 
$node_(84) set X_ 259 
$node_(84) set Y_ 760 
$node_(84) set Z_ 0.0 
$node_(85) set X_ 1842 
$node_(85) set Y_ 325 
$node_(85) set Z_ 0.0 
$node_(86) set X_ 2599 
$node_(86) set Y_ 594 
$node_(86) set Z_ 0.0 
$node_(87) set X_ 2668 
$node_(87) set Y_ 579 
$node_(87) set Z_ 0.0 
$node_(88) set X_ 2343 
$node_(88) set Y_ 382 
$node_(88) set Z_ 0.0 
$node_(89) set X_ 2284 
$node_(89) set Y_ 877 
$node_(89) set Z_ 0.0 
$node_(90) set X_ 872 
$node_(90) set Y_ 621 
$node_(90) set Z_ 0.0 
$node_(91) set X_ 360 
$node_(91) set Y_ 282 
$node_(91) set Z_ 0.0 
$node_(92) set X_ 1355 
$node_(92) set Y_ 789 
$node_(92) set Z_ 0.0 
$node_(93) set X_ 2591 
$node_(93) set Y_ 891 
$node_(93) set Z_ 0.0 
$node_(94) set X_ 2308 
$node_(94) set Y_ 91 
$node_(94) set Z_ 0.0 
$node_(95) set X_ 177 
$node_(95) set Y_ 894 
$node_(95) set Z_ 0.0 
$node_(96) set X_ 942 
$node_(96) set Y_ 3 
$node_(96) set Z_ 0.0 
$node_(97) set X_ 2631 
$node_(97) set Y_ 960 
$node_(97) set Z_ 0.0 
$node_(98) set X_ 2547 
$node_(98) set Y_ 578 
$node_(98) set Z_ 0.0 
$node_(99) set X_ 715 
$node_(99) set Y_ 245 
$node_(99) set Z_ 0.0 
$node_(100) set X_ 1117 
$node_(100) set Y_ 537 
$node_(100) set Z_ 0.0 
$node_(101) set X_ 2850 
$node_(101) set Y_ 802 
$node_(101) set Z_ 0.0 
$ns at 0.0 "$node_(101) off" 
$ns at 100.0 "$node_(101) on" 
$node_(102) set X_ 2349 
$node_(102) set Y_ 235 
$node_(102) set Z_ 0.0 
$ns at 0.0 "$node_(102) off" 
$ns at 100.0 "$node_(102) on" 
$node_(103) set X_ 412 
$node_(103) set Y_ 952 
$node_(103) set Z_ 0.0 
$ns at 0.0 "$node_(103) off" 
$ns at 100.0 "$node_(103) on" 
$node_(104) set X_ 1041 
$node_(104) set Y_ 438 
$node_(104) set Z_ 0.0 
$ns at 0.0 "$node_(104) off" 
$ns at 100.0 "$node_(104) on" 
$node_(105) set X_ 2810 
$node_(105) set Y_ 470 
$node_(105) set Z_ 0.0 
$ns at 0.0 "$node_(105) off" 
$ns at 100.0 "$node_(105) on" 
$node_(106) set X_ 805 
$node_(106) set Y_ 705 
$node_(106) set Z_ 0.0 
$ns at 0.0 "$node_(106) off" 
$ns at 100.0 "$node_(106) on" 
$node_(107) set X_ 2233 
$node_(107) set Y_ 20 
$node_(107) set Z_ 0.0 
$ns at 0.0 "$node_(107) off" 
$ns at 100.0 "$node_(107) on" 
$node_(108) set X_ 2791 
$node_(108) set Y_ 898 
$node_(108) set Z_ 0.0 
$ns at 0.0 "$node_(108) off" 
$ns at 100.0 "$node_(108) on" 
$node_(109) set X_ 2387 
$node_(109) set Y_ 395 
$node_(109) set Z_ 0.0 
$ns at 0.0 "$node_(109) off" 
$ns at 100.0 "$node_(109) on" 
$node_(110) set X_ 1006 
$node_(110) set Y_ 926 
$node_(110) set Z_ 0.0 
$ns at 0.0 "$node_(110) off" 
$ns at 100.0 "$node_(110) on" 
$node_(111) set X_ 1460 
$node_(111) set Y_ 513 
$node_(111) set Z_ 0.0 
$ns at 0.0 "$node_(111) off" 
$ns at 100.0 "$node_(111) on" 
$node_(112) set X_ 2487 
$node_(112) set Y_ 422 
$node_(112) set Z_ 0.0 
$ns at 0.0 "$node_(112) off" 
$ns at 100.0 "$node_(112) on" 
$node_(113) set X_ 1943 
$node_(113) set Y_ 39 
$node_(113) set Z_ 0.0 
$ns at 0.0 "$node_(113) off" 
$ns at 100.0 "$node_(113) on" 
$node_(114) set X_ 1411 
$node_(114) set Y_ 463 
$node_(114) set Z_ 0.0 
$ns at 0.0 "$node_(114) off" 
$ns at 100.0 "$node_(114) on" 
$node_(115) set X_ 2764 
$node_(115) set Y_ 718 
$node_(115) set Z_ 0.0 
$ns at 0.0 "$node_(115) off" 
$ns at 100.0 "$node_(115) on" 
$node_(116) set X_ 894 
$node_(116) set Y_ 783 
$node_(116) set Z_ 0.0 
$ns at 0.0 "$node_(116) off" 
$ns at 100.0 "$node_(116) on" 
$node_(117) set X_ 1538 
$node_(117) set Y_ 237 
$node_(117) set Z_ 0.0 
$ns at 0.0 "$node_(117) off" 
$ns at 100.0 "$node_(117) on" 
$node_(118) set X_ 902 
$node_(118) set Y_ 222 
$node_(118) set Z_ 0.0 
$ns at 0.0 "$node_(118) off" 
$ns at 100.0 "$node_(118) on" 
$node_(119) set X_ 2502 
$node_(119) set Y_ 475 
$node_(119) set Z_ 0.0 
$ns at 0.0 "$node_(119) off" 
$ns at 100.0 "$node_(119) on" 
$node_(120) set X_ 383 
$node_(120) set Y_ 268 
$node_(120) set Z_ 0.0 
$ns at 0.0 "$node_(120) off" 
$ns at 100.0 "$node_(120) on" 
$node_(121) set X_ 2975 
$node_(121) set Y_ 502 
$node_(121) set Z_ 0.0 
$ns at 0.0 "$node_(121) off" 
$ns at 100.0 "$node_(121) on" 
$node_(122) set X_ 1296 
$node_(122) set Y_ 657 
$node_(122) set Z_ 0.0 
$ns at 0.0 "$node_(122) off" 
$ns at 100.0 "$node_(122) on" 
$node_(123) set X_ 1904 
$node_(123) set Y_ 602 
$node_(123) set Z_ 0.0 
$ns at 0.0 "$node_(123) off" 
$ns at 100.0 "$node_(123) on" 
$node_(124) set X_ 852 
$node_(124) set Y_ 941 
$node_(124) set Z_ 0.0 
$ns at 0.0 "$node_(124) off" 
$ns at 100.0 "$node_(124) on" 
$node_(125) set X_ 1246 
$node_(125) set Y_ 860 
$node_(125) set Z_ 0.0 
$ns at 0.0 "$node_(125) off" 
$ns at 100.0 "$node_(125) on" 
$node_(126) set X_ 779 
$node_(126) set Y_ 835 
$node_(126) set Z_ 0.0 
$ns at 0.0 "$node_(126) off" 
$ns at 100.0 "$node_(126) on" 
$node_(127) set X_ 607 
$node_(127) set Y_ 595 
$node_(127) set Z_ 0.0 
$ns at 0.0 "$node_(127) off" 
$ns at 100.0 "$node_(127) on" 
$node_(128) set X_ 1997 
$node_(128) set Y_ 916 
$node_(128) set Z_ 0.0 
$ns at 0.0 "$node_(128) off" 
$ns at 100.0 "$node_(128) on" 
$node_(129) set X_ 691 
$node_(129) set Y_ 16 
$node_(129) set Z_ 0.0 
$ns at 0.0 "$node_(129) off" 
$ns at 100.0 "$node_(129) on" 
$node_(130) set X_ 2539 
$node_(130) set Y_ 975 
$node_(130) set Z_ 0.0 
$ns at 0.0 "$node_(130) off" 
$ns at 100.0 "$node_(130) on" 
$node_(131) set X_ 1701 
$node_(131) set Y_ 11 
$node_(131) set Z_ 0.0 
$ns at 0.0 "$node_(131) off" 
$ns at 100.0 "$node_(131) on" 
$node_(132) set X_ 2046 
$node_(132) set Y_ 876 
$node_(132) set Z_ 0.0 
$ns at 0.0 "$node_(132) off" 
$ns at 100.0 "$node_(132) on" 
$node_(133) set X_ 1921 
$node_(133) set Y_ 887 
$node_(133) set Z_ 0.0 
$ns at 0.0 "$node_(133) off" 
$ns at 100.0 "$node_(133) on" 
$node_(134) set X_ 568 
$node_(134) set Y_ 323 
$node_(134) set Z_ 0.0 
$ns at 0.0 "$node_(134) off" 
$ns at 100.0 "$node_(134) on" 
$node_(135) set X_ 230 
$node_(135) set Y_ 237 
$node_(135) set Z_ 0.0 
$ns at 0.0 "$node_(135) off" 
$ns at 100.0 "$node_(135) on" 
$node_(136) set X_ 1819 
$node_(136) set Y_ 327 
$node_(136) set Z_ 0.0 
$ns at 0.0 "$node_(136) off" 
$ns at 100.0 "$node_(136) on" 
$node_(137) set X_ 2316 
$node_(137) set Y_ 824 
$node_(137) set Z_ 0.0 
$ns at 0.0 "$node_(137) off" 
$ns at 100.0 "$node_(137) on" 
$node_(138) set X_ 1391 
$node_(138) set Y_ 473 
$node_(138) set Z_ 0.0 
$ns at 0.0 "$node_(138) off" 
$ns at 100.0 "$node_(138) on" 
$node_(139) set X_ 2830 
$node_(139) set Y_ 545 
$node_(139) set Z_ 0.0 
$ns at 0.0 "$node_(139) off" 
$ns at 100.0 "$node_(139) on" 
$node_(140) set X_ 2758 
$node_(140) set Y_ 333 
$node_(140) set Z_ 0.0 
$ns at 0.0 "$node_(140) off" 
$ns at 100.0 "$node_(140) on" 
$node_(141) set X_ 2660 
$node_(141) set Y_ 55 
$node_(141) set Z_ 0.0 
$ns at 0.0 "$node_(141) off" 
$ns at 100.0 "$node_(141) on" 
$node_(142) set X_ 229 
$node_(142) set Y_ 498 
$node_(142) set Z_ 0.0 
$ns at 0.0 "$node_(142) off" 
$ns at 100.0 "$node_(142) on" 
$node_(143) set X_ 933 
$node_(143) set Y_ 628 
$node_(143) set Z_ 0.0 
$ns at 0.0 "$node_(143) off" 
$ns at 100.0 "$node_(143) on" 
$node_(144) set X_ 267 
$node_(144) set Y_ 702 
$node_(144) set Z_ 0.0 
$ns at 0.0 "$node_(144) off" 
$ns at 100.0 "$node_(144) on" 
$node_(145) set X_ 1213 
$node_(145) set Y_ 162 
$node_(145) set Z_ 0.0 
$ns at 0.0 "$node_(145) off" 
$ns at 100.0 "$node_(145) on" 
$node_(146) set X_ 1814 
$node_(146) set Y_ 517 
$node_(146) set Z_ 0.0 
$ns at 0.0 "$node_(146) off" 
$ns at 100.0 "$node_(146) on" 
$node_(147) set X_ 730 
$node_(147) set Y_ 28 
$node_(147) set Z_ 0.0 
$ns at 0.0 "$node_(147) off" 
$ns at 100.0 "$node_(147) on" 
$node_(148) set X_ 1516 
$node_(148) set Y_ 881 
$node_(148) set Z_ 0.0 
$ns at 0.0 "$node_(148) off" 
$ns at 100.0 "$node_(148) on" 
$node_(149) set X_ 2293 
$node_(149) set Y_ 633 
$node_(149) set Z_ 0.0 
$ns at 0.0 "$node_(149) off" 
$ns at 100.0 "$node_(149) on" 
$node_(150) set X_ 2879 
$node_(150) set Y_ 533 
$node_(150) set Z_ 0.0 
$ns at 0.0 "$node_(150) off" 
$ns at 100.0 "$node_(150) on" 
$node_(151) set X_ 817 
$node_(151) set Y_ 143 
$node_(151) set Z_ 0.0 
$ns at 0.0 "$node_(151) off" 
$ns at 100.0 "$node_(151) on" 
$node_(152) set X_ 1551 
$node_(152) set Y_ 36 
$node_(152) set Z_ 0.0 
$ns at 0.0 "$node_(152) off" 
$ns at 100.0 "$node_(152) on" 
$node_(153) set X_ 1161 
$node_(153) set Y_ 807 
$node_(153) set Z_ 0.0 
$ns at 0.0 "$node_(153) off" 
$ns at 100.0 "$node_(153) on" 
$node_(154) set X_ 1055 
$node_(154) set Y_ 689 
$node_(154) set Z_ 0.0 
$ns at 0.0 "$node_(154) off" 
$ns at 100.0 "$node_(154) on" 
$node_(155) set X_ 1208 
$node_(155) set Y_ 732 
$node_(155) set Z_ 0.0 
$ns at 0.0 "$node_(155) off" 
$ns at 100.0 "$node_(155) on" 
$node_(156) set X_ 2349 
$node_(156) set Y_ 61 
$node_(156) set Z_ 0.0 
$ns at 0.0 "$node_(156) off" 
$ns at 100.0 "$node_(156) on" 
$node_(157) set X_ 777 
$node_(157) set Y_ 732 
$node_(157) set Z_ 0.0 
$ns at 0.0 "$node_(157) off" 
$ns at 100.0 "$node_(157) on" 
$node_(158) set X_ 2678 
$node_(158) set Y_ 280 
$node_(158) set Z_ 0.0 
$ns at 0.0 "$node_(158) off" 
$ns at 100.0 "$node_(158) on" 
$node_(159) set X_ 2166 
$node_(159) set Y_ 101 
$node_(159) set Z_ 0.0 
$ns at 0.0 "$node_(159) off" 
$ns at 100.0 "$node_(159) on" 
$node_(160) set X_ 1186 
$node_(160) set Y_ 501 
$node_(160) set Z_ 0.0 
$ns at 0.0 "$node_(160) off" 
$ns at 100.0 "$node_(160) on" 
$node_(161) set X_ 2732 
$node_(161) set Y_ 778 
$node_(161) set Z_ 0.0 
$ns at 0.0 "$node_(161) off" 
$ns at 100.0 "$node_(161) on" 
$node_(162) set X_ 2745 
$node_(162) set Y_ 145 
$node_(162) set Z_ 0.0 
$ns at 0.0 "$node_(162) off" 
$ns at 100.0 "$node_(162) on" 
$node_(163) set X_ 4 
$node_(163) set Y_ 380 
$node_(163) set Z_ 0.0 
$ns at 0.0 "$node_(163) off" 
$ns at 100.0 "$node_(163) on" 
$node_(164) set X_ 1435 
$node_(164) set Y_ 630 
$node_(164) set Z_ 0.0 
$ns at 0.0 "$node_(164) off" 
$ns at 100.0 "$node_(164) on" 
$node_(165) set X_ 2421 
$node_(165) set Y_ 12 
$node_(165) set Z_ 0.0 
$ns at 0.0 "$node_(165) off" 
$ns at 100.0 "$node_(165) on" 
$node_(166) set X_ 1018 
$node_(166) set Y_ 299 
$node_(166) set Z_ 0.0 
$ns at 0.0 "$node_(166) off" 
$ns at 100.0 "$node_(166) on" 
$node_(167) set X_ 2817 
$node_(167) set Y_ 591 
$node_(167) set Z_ 0.0 
$ns at 0.0 "$node_(167) off" 
$ns at 100.0 "$node_(167) on" 
$node_(168) set X_ 662 
$node_(168) set Y_ 168 
$node_(168) set Z_ 0.0 
$ns at 0.0 "$node_(168) off" 
$ns at 100.0 "$node_(168) on" 
$node_(169) set X_ 1252 
$node_(169) set Y_ 675 
$node_(169) set Z_ 0.0 
$ns at 0.0 "$node_(169) off" 
$ns at 100.0 "$node_(169) on" 
$node_(170) set X_ 2026 
$node_(170) set Y_ 927 
$node_(170) set Z_ 0.0 
$ns at 0.0 "$node_(170) off" 
$ns at 100.0 "$node_(170) on" 
$node_(171) set X_ 2821 
$node_(171) set Y_ 409 
$node_(171) set Z_ 0.0 
$ns at 0.0 "$node_(171) off" 
$ns at 100.0 "$node_(171) on" 
$node_(172) set X_ 1659 
$node_(172) set Y_ 381 
$node_(172) set Z_ 0.0 
$ns at 0.0 "$node_(172) off" 
$ns at 100.0 "$node_(172) on" 
$node_(173) set X_ 1463 
$node_(173) set Y_ 281 
$node_(173) set Z_ 0.0 
$ns at 0.0 "$node_(173) off" 
$ns at 100.0 "$node_(173) on" 
$node_(174) set X_ 1462 
$node_(174) set Y_ 86 
$node_(174) set Z_ 0.0 
$ns at 0.0 "$node_(174) off" 
$ns at 100.0 "$node_(174) on" 
$node_(175) set X_ 1727 
$node_(175) set Y_ 808 
$node_(175) set Z_ 0.0 
$ns at 0.0 "$node_(175) off" 
$ns at 100.0 "$node_(175) on" 
$node_(176) set X_ 2757 
$node_(176) set Y_ 550 
$node_(176) set Z_ 0.0 
$ns at 0.0 "$node_(176) off" 
$ns at 100.0 "$node_(176) on" 
$node_(177) set X_ 852 
$node_(177) set Y_ 162 
$node_(177) set Z_ 0.0 
$ns at 0.0 "$node_(177) off" 
$ns at 100.0 "$node_(177) on" 
$node_(178) set X_ 1204 
$node_(178) set Y_ 743 
$node_(178) set Z_ 0.0 
$ns at 0.0 "$node_(178) off" 
$ns at 100.0 "$node_(178) on" 
$node_(179) set X_ 331 
$node_(179) set Y_ 9 
$node_(179) set Z_ 0.0 
$ns at 0.0 "$node_(179) off" 
$ns at 100.0 "$node_(179) on" 
$node_(180) set X_ 2570 
$node_(180) set Y_ 44 
$node_(180) set Z_ 0.0 
$ns at 0.0 "$node_(180) off" 
$ns at 100.0 "$node_(180) on" 
$node_(181) set X_ 2474 
$node_(181) set Y_ 492 
$node_(181) set Z_ 0.0 
$ns at 0.0 "$node_(181) off" 
$ns at 100.0 "$node_(181) on" 
$node_(182) set X_ 2985 
$node_(182) set Y_ 10 
$node_(182) set Z_ 0.0 
$ns at 0.0 "$node_(182) off" 
$ns at 100.0 "$node_(182) on" 
$node_(183) set X_ 2274 
$node_(183) set Y_ 412 
$node_(183) set Z_ 0.0 
$ns at 0.0 "$node_(183) off" 
$ns at 100.0 "$node_(183) on" 
$node_(184) set X_ 1013 
$node_(184) set Y_ 489 
$node_(184) set Z_ 0.0 
$ns at 0.0 "$node_(184) off" 
$ns at 100.0 "$node_(184) on" 
$node_(185) set X_ 1116 
$node_(185) set Y_ 102 
$node_(185) set Z_ 0.0 
$ns at 0.0 "$node_(185) off" 
$ns at 100.0 "$node_(185) on" 
$node_(186) set X_ 430 
$node_(186) set Y_ 687 
$node_(186) set Z_ 0.0 
$ns at 0.0 "$node_(186) off" 
$ns at 100.0 "$node_(186) on" 
$node_(187) set X_ 1626 
$node_(187) set Y_ 430 
$node_(187) set Z_ 0.0 
$ns at 0.0 "$node_(187) off" 
$ns at 100.0 "$node_(187) on" 
$node_(188) set X_ 241 
$node_(188) set Y_ 773 
$node_(188) set Z_ 0.0 
$ns at 0.0 "$node_(188) off" 
$ns at 100.0 "$node_(188) on" 
$node_(189) set X_ 2113 
$node_(189) set Y_ 633 
$node_(189) set Z_ 0.0 
$ns at 0.0 "$node_(189) off" 
$ns at 100.0 "$node_(189) on" 
$node_(190) set X_ 1976 
$node_(190) set Y_ 467 
$node_(190) set Z_ 0.0 
$ns at 0.0 "$node_(190) off" 
$ns at 100.0 "$node_(190) on" 
$node_(191) set X_ 2758 
$node_(191) set Y_ 410 
$node_(191) set Z_ 0.0 
$ns at 0.0 "$node_(191) off" 
$ns at 100.0 "$node_(191) on" 
$node_(192) set X_ 858 
$node_(192) set Y_ 866 
$node_(192) set Z_ 0.0 
$ns at 0.0 "$node_(192) off" 
$ns at 100.0 "$node_(192) on" 
$node_(193) set X_ 2808 
$node_(193) set Y_ 826 
$node_(193) set Z_ 0.0 
$ns at 0.0 "$node_(193) off" 
$ns at 100.0 "$node_(193) on" 
$node_(194) set X_ 909 
$node_(194) set Y_ 437 
$node_(194) set Z_ 0.0 
$ns at 0.0 "$node_(194) off" 
$ns at 100.0 "$node_(194) on" 
$node_(195) set X_ 1653 
$node_(195) set Y_ 58 
$node_(195) set Z_ 0.0 
$ns at 0.0 "$node_(195) off" 
$ns at 100.0 "$node_(195) on" 
$node_(196) set X_ 1532 
$node_(196) set Y_ 710 
$node_(196) set Z_ 0.0 
$ns at 0.0 "$node_(196) off" 
$ns at 100.0 "$node_(196) on" 
$node_(197) set X_ 2714 
$node_(197) set Y_ 6 
$node_(197) set Z_ 0.0 
$ns at 0.0 "$node_(197) off" 
$ns at 100.0 "$node_(197) on" 
$node_(198) set X_ 1522 
$node_(198) set Y_ 722 
$node_(198) set Z_ 0.0 
$ns at 0.0 "$node_(198) off" 
$ns at 100.0 "$node_(198) on" 
$node_(199) set X_ 2625 
$node_(199) set Y_ 52 
$node_(199) set Z_ 0.0 
$ns at 0.0 "$node_(199) off" 
$ns at 100.0 "$node_(199) on" 
$node_(200) set X_ 1881 
$node_(200) set Y_ 646 
$node_(200) set Z_ 0.0 
$ns at 0.0 "$node_(200) off" 
$ns at 200.0 "$node_(200) on" 
$node_(201) set X_ 1195 
$node_(201) set Y_ 53 
$node_(201) set Z_ 0.0 
$ns at 0.0 "$node_(201) off" 
$ns at 200.0 "$node_(201) on" 
$node_(202) set X_ 1135 
$node_(202) set Y_ 389 
$node_(202) set Z_ 0.0 
$ns at 0.0 "$node_(202) off" 
$ns at 200.0 "$node_(202) on" 
$node_(203) set X_ 1100 
$node_(203) set Y_ 759 
$node_(203) set Z_ 0.0 
$ns at 0.0 "$node_(203) off" 
$ns at 200.0 "$node_(203) on" 
$node_(204) set X_ 251 
$node_(204) set Y_ 137 
$node_(204) set Z_ 0.0 
$ns at 0.0 "$node_(204) off" 
$ns at 200.0 "$node_(204) on" 
$node_(205) set X_ 2215 
$node_(205) set Y_ 413 
$node_(205) set Z_ 0.0 
$ns at 0.0 "$node_(205) off" 
$ns at 200.0 "$node_(205) on" 
$node_(206) set X_ 2474 
$node_(206) set Y_ 978 
$node_(206) set Z_ 0.0 
$ns at 0.0 "$node_(206) off" 
$ns at 200.0 "$node_(206) on" 
$node_(207) set X_ 1905 
$node_(207) set Y_ 247 
$node_(207) set Z_ 0.0 
$ns at 0.0 "$node_(207) off" 
$ns at 200.0 "$node_(207) on" 
$node_(208) set X_ 2760 
$node_(208) set Y_ 758 
$node_(208) set Z_ 0.0 
$ns at 0.0 "$node_(208) off" 
$ns at 200.0 "$node_(208) on" 
$node_(209) set X_ 1464 
$node_(209) set Y_ 956 
$node_(209) set Z_ 0.0 
$ns at 0.0 "$node_(209) off" 
$ns at 200.0 "$node_(209) on" 
$node_(210) set X_ 2656 
$node_(210) set Y_ 266 
$node_(210) set Z_ 0.0 
$ns at 0.0 "$node_(210) off" 
$ns at 200.0 "$node_(210) on" 
$node_(211) set X_ 2256 
$node_(211) set Y_ 996 
$node_(211) set Z_ 0.0 
$ns at 0.0 "$node_(211) off" 
$ns at 200.0 "$node_(211) on" 
$node_(212) set X_ 724 
$node_(212) set Y_ 704 
$node_(212) set Z_ 0.0 
$ns at 0.0 "$node_(212) off" 
$ns at 200.0 "$node_(212) on" 
$node_(213) set X_ 930 
$node_(213) set Y_ 724 
$node_(213) set Z_ 0.0 
$ns at 0.0 "$node_(213) off" 
$ns at 200.0 "$node_(213) on" 
$node_(214) set X_ 1780 
$node_(214) set Y_ 139 
$node_(214) set Z_ 0.0 
$ns at 0.0 "$node_(214) off" 
$ns at 200.0 "$node_(214) on" 
$node_(215) set X_ 1359 
$node_(215) set Y_ 5 
$node_(215) set Z_ 0.0 
$ns at 0.0 "$node_(215) off" 
$ns at 200.0 "$node_(215) on" 
$node_(216) set X_ 345 
$node_(216) set Y_ 301 
$node_(216) set Z_ 0.0 
$ns at 0.0 "$node_(216) off" 
$ns at 200.0 "$node_(216) on" 
$node_(217) set X_ 716 
$node_(217) set Y_ 869 
$node_(217) set Z_ 0.0 
$ns at 0.0 "$node_(217) off" 
$ns at 200.0 "$node_(217) on" 
$node_(218) set X_ 2860 
$node_(218) set Y_ 670 
$node_(218) set Z_ 0.0 
$ns at 0.0 "$node_(218) off" 
$ns at 200.0 "$node_(218) on" 
$node_(219) set X_ 331 
$node_(219) set Y_ 211 
$node_(219) set Z_ 0.0 
$ns at 0.0 "$node_(219) off" 
$ns at 200.0 "$node_(219) on" 
$node_(220) set X_ 266 
$node_(220) set Y_ 246 
$node_(220) set Z_ 0.0 
$ns at 0.0 "$node_(220) off" 
$ns at 200.0 "$node_(220) on" 
$node_(221) set X_ 2658 
$node_(221) set Y_ 345 
$node_(221) set Z_ 0.0 
$ns at 0.0 "$node_(221) off" 
$ns at 200.0 "$node_(221) on" 
$node_(222) set X_ 2609 
$node_(222) set Y_ 784 
$node_(222) set Z_ 0.0 
$ns at 0.0 "$node_(222) off" 
$ns at 200.0 "$node_(222) on" 
$node_(223) set X_ 1849 
$node_(223) set Y_ 392 
$node_(223) set Z_ 0.0 
$ns at 0.0 "$node_(223) off" 
$ns at 200.0 "$node_(223) on" 
$node_(224) set X_ 2388 
$node_(224) set Y_ 589 
$node_(224) set Z_ 0.0 
$ns at 0.0 "$node_(224) off" 
$ns at 200.0 "$node_(224) on" 
$node_(225) set X_ 1065 
$node_(225) set Y_ 136 
$node_(225) set Z_ 0.0 
$ns at 0.0 "$node_(225) off" 
$ns at 200.0 "$node_(225) on" 
$node_(226) set X_ 301 
$node_(226) set Y_ 102 
$node_(226) set Z_ 0.0 
$ns at 0.0 "$node_(226) off" 
$ns at 200.0 "$node_(226) on" 
$node_(227) set X_ 1741 
$node_(227) set Y_ 985 
$node_(227) set Z_ 0.0 
$ns at 0.0 "$node_(227) off" 
$ns at 200.0 "$node_(227) on" 
$node_(228) set X_ 1046 
$node_(228) set Y_ 671 
$node_(228) set Z_ 0.0 
$ns at 0.0 "$node_(228) off" 
$ns at 200.0 "$node_(228) on" 
$node_(229) set X_ 2628 
$node_(229) set Y_ 84 
$node_(229) set Z_ 0.0 
$ns at 0.0 "$node_(229) off" 
$ns at 200.0 "$node_(229) on" 
$node_(230) set X_ 1739 
$node_(230) set Y_ 850 
$node_(230) set Z_ 0.0 
$ns at 0.0 "$node_(230) off" 
$ns at 200.0 "$node_(230) on" 
$node_(231) set X_ 1418 
$node_(231) set Y_ 503 
$node_(231) set Z_ 0.0 
$ns at 0.0 "$node_(231) off" 
$ns at 200.0 "$node_(231) on" 
$node_(232) set X_ 1430 
$node_(232) set Y_ 521 
$node_(232) set Z_ 0.0 
$ns at 0.0 "$node_(232) off" 
$ns at 200.0 "$node_(232) on" 
$node_(233) set X_ 1314 
$node_(233) set Y_ 614 
$node_(233) set Z_ 0.0 
$ns at 0.0 "$node_(233) off" 
$ns at 200.0 "$node_(233) on" 
$node_(234) set X_ 2036 
$node_(234) set Y_ 928 
$node_(234) set Z_ 0.0 
$ns at 0.0 "$node_(234) off" 
$ns at 200.0 "$node_(234) on" 
$node_(235) set X_ 1862 
$node_(235) set Y_ 454 
$node_(235) set Z_ 0.0 
$ns at 0.0 "$node_(235) off" 
$ns at 200.0 "$node_(235) on" 
$node_(236) set X_ 1868 
$node_(236) set Y_ 444 
$node_(236) set Z_ 0.0 
$ns at 0.0 "$node_(236) off" 
$ns at 200.0 "$node_(236) on" 
$node_(237) set X_ 2795 
$node_(237) set Y_ 904 
$node_(237) set Z_ 0.0 
$ns at 0.0 "$node_(237) off" 
$ns at 200.0 "$node_(237) on" 
$node_(238) set X_ 734 
$node_(238) set Y_ 517 
$node_(238) set Z_ 0.0 
$ns at 0.0 "$node_(238) off" 
$ns at 200.0 "$node_(238) on" 
$node_(239) set X_ 584 
$node_(239) set Y_ 964 
$node_(239) set Z_ 0.0 
$ns at 0.0 "$node_(239) off" 
$ns at 200.0 "$node_(239) on" 
$node_(240) set X_ 1339 
$node_(240) set Y_ 790 
$node_(240) set Z_ 0.0 
$ns at 0.0 "$node_(240) off" 
$ns at 200.0 "$node_(240) on" 
$node_(241) set X_ 1732 
$node_(241) set Y_ 308 
$node_(241) set Z_ 0.0 
$ns at 0.0 "$node_(241) off" 
$ns at 200.0 "$node_(241) on" 
$node_(242) set X_ 1500 
$node_(242) set Y_ 816 
$node_(242) set Z_ 0.0 
$ns at 0.0 "$node_(242) off" 
$ns at 200.0 "$node_(242) on" 
$node_(243) set X_ 1742 
$node_(243) set Y_ 509 
$node_(243) set Z_ 0.0 
$ns at 0.0 "$node_(243) off" 
$ns at 200.0 "$node_(243) on" 
$node_(244) set X_ 1344 
$node_(244) set Y_ 143 
$node_(244) set Z_ 0.0 
$ns at 0.0 "$node_(244) off" 
$ns at 200.0 "$node_(244) on" 
$node_(245) set X_ 1963 
$node_(245) set Y_ 74 
$node_(245) set Z_ 0.0 
$ns at 0.0 "$node_(245) off" 
$ns at 200.0 "$node_(245) on" 
$node_(246) set X_ 386 
$node_(246) set Y_ 805 
$node_(246) set Z_ 0.0 
$ns at 0.0 "$node_(246) off" 
$ns at 200.0 "$node_(246) on" 
$node_(247) set X_ 2353 
$node_(247) set Y_ 444 
$node_(247) set Z_ 0.0 
$ns at 0.0 "$node_(247) off" 
$ns at 200.0 "$node_(247) on" 
$node_(248) set X_ 1998 
$node_(248) set Y_ 417 
$node_(248) set Z_ 0.0 
$ns at 0.0 "$node_(248) off" 
$ns at 200.0 "$node_(248) on" 
$node_(249) set X_ 2410 
$node_(249) set Y_ 662 
$node_(249) set Z_ 0.0 
$ns at 0.0 "$node_(249) off" 
$ns at 200.0 "$node_(249) on" 
$node_(250) set X_ 409 
$node_(250) set Y_ 114 
$node_(250) set Z_ 0.0 
$ns at 0.0 "$node_(250) off" 
$ns at 200.0 "$node_(250) on" 
$node_(251) set X_ 2284 
$node_(251) set Y_ 253 
$node_(251) set Z_ 0.0 
$ns at 0.0 "$node_(251) off" 
$ns at 200.0 "$node_(251) on" 
$node_(252) set X_ 1971 
$node_(252) set Y_ 598 
$node_(252) set Z_ 0.0 
$ns at 0.0 "$node_(252) off" 
$ns at 200.0 "$node_(252) on" 
$node_(253) set X_ 1257 
$node_(253) set Y_ 217 
$node_(253) set Z_ 0.0 
$ns at 0.0 "$node_(253) off" 
$ns at 200.0 "$node_(253) on" 
$node_(254) set X_ 947 
$node_(254) set Y_ 379 
$node_(254) set Z_ 0.0 
$ns at 0.0 "$node_(254) off" 
$ns at 200.0 "$node_(254) on" 
$node_(255) set X_ 2446 
$node_(255) set Y_ 690 
$node_(255) set Z_ 0.0 
$ns at 0.0 "$node_(255) off" 
$ns at 200.0 "$node_(255) on" 
$node_(256) set X_ 646 
$node_(256) set Y_ 122 
$node_(256) set Z_ 0.0 
$ns at 0.0 "$node_(256) off" 
$ns at 200.0 "$node_(256) on" 
$node_(257) set X_ 2716 
$node_(257) set Y_ 988 
$node_(257) set Z_ 0.0 
$ns at 0.0 "$node_(257) off" 
$ns at 200.0 "$node_(257) on" 
$node_(258) set X_ 1184 
$node_(258) set Y_ 699 
$node_(258) set Z_ 0.0 
$ns at 0.0 "$node_(258) off" 
$ns at 200.0 "$node_(258) on" 
$node_(259) set X_ 1392 
$node_(259) set Y_ 240 
$node_(259) set Z_ 0.0 
$ns at 0.0 "$node_(259) off" 
$ns at 200.0 "$node_(259) on" 
$node_(260) set X_ 1615 
$node_(260) set Y_ 120 
$node_(260) set Z_ 0.0 
$ns at 0.0 "$node_(260) off" 
$ns at 200.0 "$node_(260) on" 
$node_(261) set X_ 2430 
$node_(261) set Y_ 752 
$node_(261) set Z_ 0.0 
$ns at 0.0 "$node_(261) off" 
$ns at 200.0 "$node_(261) on" 
$node_(262) set X_ 628 
$node_(262) set Y_ 51 
$node_(262) set Z_ 0.0 
$ns at 0.0 "$node_(262) off" 
$ns at 200.0 "$node_(262) on" 
$node_(263) set X_ 1234 
$node_(263) set Y_ 582 
$node_(263) set Z_ 0.0 
$ns at 0.0 "$node_(263) off" 
$ns at 200.0 "$node_(263) on" 
$node_(264) set X_ 2380 
$node_(264) set Y_ 28 
$node_(264) set Z_ 0.0 
$ns at 0.0 "$node_(264) off" 
$ns at 200.0 "$node_(264) on" 
$node_(265) set X_ 332 
$node_(265) set Y_ 540 
$node_(265) set Z_ 0.0 
$ns at 0.0 "$node_(265) off" 
$ns at 200.0 "$node_(265) on" 
$node_(266) set X_ 1407 
$node_(266) set Y_ 775 
$node_(266) set Z_ 0.0 
$ns at 0.0 "$node_(266) off" 
$ns at 200.0 "$node_(266) on" 
$node_(267) set X_ 1578 
$node_(267) set Y_ 969 
$node_(267) set Z_ 0.0 
$ns at 0.0 "$node_(267) off" 
$ns at 200.0 "$node_(267) on" 
$node_(268) set X_ 893 
$node_(268) set Y_ 298 
$node_(268) set Z_ 0.0 
$ns at 0.0 "$node_(268) off" 
$ns at 200.0 "$node_(268) on" 
$node_(269) set X_ 510 
$node_(269) set Y_ 222 
$node_(269) set Z_ 0.0 
$ns at 0.0 "$node_(269) off" 
$ns at 200.0 "$node_(269) on" 
$node_(270) set X_ 2883 
$node_(270) set Y_ 503 
$node_(270) set Z_ 0.0 
$ns at 0.0 "$node_(270) off" 
$ns at 200.0 "$node_(270) on" 
$node_(271) set X_ 2898 
$node_(271) set Y_ 708 
$node_(271) set Z_ 0.0 
$ns at 0.0 "$node_(271) off" 
$ns at 200.0 "$node_(271) on" 
$node_(272) set X_ 2291 
$node_(272) set Y_ 189 
$node_(272) set Z_ 0.0 
$ns at 0.0 "$node_(272) off" 
$ns at 200.0 "$node_(272) on" 
$node_(273) set X_ 390 
$node_(273) set Y_ 736 
$node_(273) set Z_ 0.0 
$ns at 0.0 "$node_(273) off" 
$ns at 200.0 "$node_(273) on" 
$node_(274) set X_ 799 
$node_(274) set Y_ 131 
$node_(274) set Z_ 0.0 
$ns at 0.0 "$node_(274) off" 
$ns at 200.0 "$node_(274) on" 
$node_(275) set X_ 2542 
$node_(275) set Y_ 163 
$node_(275) set Z_ 0.0 
$ns at 0.0 "$node_(275) off" 
$ns at 200.0 "$node_(275) on" 
$node_(276) set X_ 957 
$node_(276) set Y_ 893 
$node_(276) set Z_ 0.0 
$ns at 0.0 "$node_(276) off" 
$ns at 200.0 "$node_(276) on" 
$node_(277) set X_ 2295 
$node_(277) set Y_ 32 
$node_(277) set Z_ 0.0 
$ns at 0.0 "$node_(277) off" 
$ns at 200.0 "$node_(277) on" 
$node_(278) set X_ 966 
$node_(278) set Y_ 708 
$node_(278) set Z_ 0.0 
$ns at 0.0 "$node_(278) off" 
$ns at 200.0 "$node_(278) on" 
$node_(279) set X_ 298 
$node_(279) set Y_ 958 
$node_(279) set Z_ 0.0 
$ns at 0.0 "$node_(279) off" 
$ns at 200.0 "$node_(279) on" 
$node_(280) set X_ 773 
$node_(280) set Y_ 463 
$node_(280) set Z_ 0.0 
$ns at 0.0 "$node_(280) off" 
$ns at 200.0 "$node_(280) on" 
$node_(281) set X_ 189 
$node_(281) set Y_ 19 
$node_(281) set Z_ 0.0 
$ns at 0.0 "$node_(281) off" 
$ns at 200.0 "$node_(281) on" 
$node_(282) set X_ 1237 
$node_(282) set Y_ 354 
$node_(282) set Z_ 0.0 
$ns at 0.0 "$node_(282) off" 
$ns at 200.0 "$node_(282) on" 
$node_(283) set X_ 1207 
$node_(283) set Y_ 305 
$node_(283) set Z_ 0.0 
$ns at 0.0 "$node_(283) off" 
$ns at 200.0 "$node_(283) on" 
$node_(284) set X_ 2187 
$node_(284) set Y_ 304 
$node_(284) set Z_ 0.0 
$ns at 0.0 "$node_(284) off" 
$ns at 200.0 "$node_(284) on" 
$node_(285) set X_ 171 
$node_(285) set Y_ 66 
$node_(285) set Z_ 0.0 
$ns at 0.0 "$node_(285) off" 
$ns at 200.0 "$node_(285) on" 
$node_(286) set X_ 1265 
$node_(286) set Y_ 559 
$node_(286) set Z_ 0.0 
$ns at 0.0 "$node_(286) off" 
$ns at 200.0 "$node_(286) on" 
$node_(287) set X_ 1056 
$node_(287) set Y_ 634 
$node_(287) set Z_ 0.0 
$ns at 0.0 "$node_(287) off" 
$ns at 200.0 "$node_(287) on" 
$node_(288) set X_ 2469 
$node_(288) set Y_ 201 
$node_(288) set Z_ 0.0 
$ns at 0.0 "$node_(288) off" 
$ns at 200.0 "$node_(288) on" 
$node_(289) set X_ 2007 
$node_(289) set Y_ 868 
$node_(289) set Z_ 0.0 
$ns at 0.0 "$node_(289) off" 
$ns at 200.0 "$node_(289) on" 
$node_(290) set X_ 1284 
$node_(290) set Y_ 499 
$node_(290) set Z_ 0.0 
$ns at 0.0 "$node_(290) off" 
$ns at 200.0 "$node_(290) on" 
$node_(291) set X_ 729 
$node_(291) set Y_ 949 
$node_(291) set Z_ 0.0 
$ns at 0.0 "$node_(291) off" 
$ns at 200.0 "$node_(291) on" 
$node_(292) set X_ 2274 
$node_(292) set Y_ 120 
$node_(292) set Z_ 0.0 
$ns at 0.0 "$node_(292) off" 
$ns at 200.0 "$node_(292) on" 
$node_(293) set X_ 1788 
$node_(293) set Y_ 710 
$node_(293) set Z_ 0.0 
$ns at 0.0 "$node_(293) off" 
$ns at 200.0 "$node_(293) on" 
$node_(294) set X_ 2918 
$node_(294) set Y_ 207 
$node_(294) set Z_ 0.0 
$ns at 0.0 "$node_(294) off" 
$ns at 200.0 "$node_(294) on" 
$node_(295) set X_ 360 
$node_(295) set Y_ 586 
$node_(295) set Z_ 0.0 
$ns at 0.0 "$node_(295) off" 
$ns at 200.0 "$node_(295) on" 
$node_(296) set X_ 378 
$node_(296) set Y_ 285 
$node_(296) set Z_ 0.0 
$ns at 0.0 "$node_(296) off" 
$ns at 200.0 "$node_(296) on" 
$node_(297) set X_ 1498 
$node_(297) set Y_ 451 
$node_(297) set Z_ 0.0 
$ns at 0.0 "$node_(297) off" 
$ns at 200.0 "$node_(297) on" 
$node_(298) set X_ 1756 
$node_(298) set Y_ 724 
$node_(298) set Z_ 0.0 
$ns at 0.0 "$node_(298) off" 
$ns at 200.0 "$node_(298) on" 
$node_(299) set X_ 2961 
$node_(299) set Y_ 302 
$node_(299) set Z_ 0.0 
$ns at 0.0 "$node_(299) off" 
$ns at 200.0 "$node_(299) on" 
$node_(300) set X_ 1219 
$node_(300) set Y_ 252 
$node_(300) set Z_ 0.0 
$ns at 0.0 "$node_(300) off" 
$ns at 300.0 "$node_(300) on" 
$node_(301) set X_ 65 
$node_(301) set Y_ 761 
$node_(301) set Z_ 0.0 
$ns at 0.0 "$node_(301) off" 
$ns at 300.0 "$node_(301) on" 
$node_(302) set X_ 1198 
$node_(302) set Y_ 606 
$node_(302) set Z_ 0.0 
$ns at 0.0 "$node_(302) off" 
$ns at 300.0 "$node_(302) on" 
$node_(303) set X_ 972 
$node_(303) set Y_ 864 
$node_(303) set Z_ 0.0 
$ns at 0.0 "$node_(303) off" 
$ns at 300.0 "$node_(303) on" 
$node_(304) set X_ 608 
$node_(304) set Y_ 984 
$node_(304) set Z_ 0.0 
$ns at 0.0 "$node_(304) off" 
$ns at 300.0 "$node_(304) on" 
$node_(305) set X_ 1190 
$node_(305) set Y_ 422 
$node_(305) set Z_ 0.0 
$ns at 0.0 "$node_(305) off" 
$ns at 300.0 "$node_(305) on" 
$node_(306) set X_ 2810 
$node_(306) set Y_ 367 
$node_(306) set Z_ 0.0 
$ns at 0.0 "$node_(306) off" 
$ns at 300.0 "$node_(306) on" 
$node_(307) set X_ 893 
$node_(307) set Y_ 572 
$node_(307) set Z_ 0.0 
$ns at 0.0 "$node_(307) off" 
$ns at 300.0 "$node_(307) on" 
$node_(308) set X_ 2725 
$node_(308) set Y_ 150 
$node_(308) set Z_ 0.0 
$ns at 0.0 "$node_(308) off" 
$ns at 300.0 "$node_(308) on" 
$node_(309) set X_ 2035 
$node_(309) set Y_ 739 
$node_(309) set Z_ 0.0 
$ns at 0.0 "$node_(309) off" 
$ns at 300.0 "$node_(309) on" 
$node_(310) set X_ 1186 
$node_(310) set Y_ 764 
$node_(310) set Z_ 0.0 
$ns at 0.0 "$node_(310) off" 
$ns at 300.0 "$node_(310) on" 
$node_(311) set X_ 965 
$node_(311) set Y_ 387 
$node_(311) set Z_ 0.0 
$ns at 0.0 "$node_(311) off" 
$ns at 300.0 "$node_(311) on" 
$node_(312) set X_ 2287 
$node_(312) set Y_ 151 
$node_(312) set Z_ 0.0 
$ns at 0.0 "$node_(312) off" 
$ns at 300.0 "$node_(312) on" 
$node_(313) set X_ 2555 
$node_(313) set Y_ 365 
$node_(313) set Z_ 0.0 
$ns at 0.0 "$node_(313) off" 
$ns at 300.0 "$node_(313) on" 
$node_(314) set X_ 68 
$node_(314) set Y_ 994 
$node_(314) set Z_ 0.0 
$ns at 0.0 "$node_(314) off" 
$ns at 300.0 "$node_(314) on" 
$node_(315) set X_ 2548 
$node_(315) set Y_ 589 
$node_(315) set Z_ 0.0 
$ns at 0.0 "$node_(315) off" 
$ns at 300.0 "$node_(315) on" 
$node_(316) set X_ 1493 
$node_(316) set Y_ 599 
$node_(316) set Z_ 0.0 
$ns at 0.0 "$node_(316) off" 
$ns at 300.0 "$node_(316) on" 
$node_(317) set X_ 1040 
$node_(317) set Y_ 86 
$node_(317) set Z_ 0.0 
$ns at 0.0 "$node_(317) off" 
$ns at 300.0 "$node_(317) on" 
$node_(318) set X_ 1212 
$node_(318) set Y_ 202 
$node_(318) set Z_ 0.0 
$ns at 0.0 "$node_(318) off" 
$ns at 300.0 "$node_(318) on" 
$node_(319) set X_ 1662 
$node_(319) set Y_ 140 
$node_(319) set Z_ 0.0 
$ns at 0.0 "$node_(319) off" 
$ns at 300.0 "$node_(319) on" 
$node_(320) set X_ 125 
$node_(320) set Y_ 247 
$node_(320) set Z_ 0.0 
$ns at 0.0 "$node_(320) off" 
$ns at 300.0 "$node_(320) on" 
$node_(321) set X_ 2187 
$node_(321) set Y_ 377 
$node_(321) set Z_ 0.0 
$ns at 0.0 "$node_(321) off" 
$ns at 300.0 "$node_(321) on" 
$node_(322) set X_ 2258 
$node_(322) set Y_ 894 
$node_(322) set Z_ 0.0 
$ns at 0.0 "$node_(322) off" 
$ns at 300.0 "$node_(322) on" 
$node_(323) set X_ 847 
$node_(323) set Y_ 189 
$node_(323) set Z_ 0.0 
$ns at 0.0 "$node_(323) off" 
$ns at 300.0 "$node_(323) on" 
$node_(324) set X_ 2926 
$node_(324) set Y_ 599 
$node_(324) set Z_ 0.0 
$ns at 0.0 "$node_(324) off" 
$ns at 300.0 "$node_(324) on" 
$node_(325) set X_ 1747 
$node_(325) set Y_ 763 
$node_(325) set Z_ 0.0 
$ns at 0.0 "$node_(325) off" 
$ns at 300.0 "$node_(325) on" 
$node_(326) set X_ 1580 
$node_(326) set Y_ 118 
$node_(326) set Z_ 0.0 
$ns at 0.0 "$node_(326) off" 
$ns at 300.0 "$node_(326) on" 
$node_(327) set X_ 1296 
$node_(327) set Y_ 377 
$node_(327) set Z_ 0.0 
$ns at 0.0 "$node_(327) off" 
$ns at 300.0 "$node_(327) on" 
$node_(328) set X_ 2125 
$node_(328) set Y_ 699 
$node_(328) set Z_ 0.0 
$ns at 0.0 "$node_(328) off" 
$ns at 300.0 "$node_(328) on" 
$node_(329) set X_ 2558 
$node_(329) set Y_ 305 
$node_(329) set Z_ 0.0 
$ns at 0.0 "$node_(329) off" 
$ns at 300.0 "$node_(329) on" 
$node_(330) set X_ 2890 
$node_(330) set Y_ 541 
$node_(330) set Z_ 0.0 
$ns at 0.0 "$node_(330) off" 
$ns at 300.0 "$node_(330) on" 
$node_(331) set X_ 1937 
$node_(331) set Y_ 878 
$node_(331) set Z_ 0.0 
$ns at 0.0 "$node_(331) off" 
$ns at 300.0 "$node_(331) on" 
$node_(332) set X_ 1728 
$node_(332) set Y_ 826 
$node_(332) set Z_ 0.0 
$ns at 0.0 "$node_(332) off" 
$ns at 300.0 "$node_(332) on" 
$node_(333) set X_ 527 
$node_(333) set Y_ 742 
$node_(333) set Z_ 0.0 
$ns at 0.0 "$node_(333) off" 
$ns at 300.0 "$node_(333) on" 
$node_(334) set X_ 1063 
$node_(334) set Y_ 762 
$node_(334) set Z_ 0.0 
$ns at 0.0 "$node_(334) off" 
$ns at 300.0 "$node_(334) on" 
$node_(335) set X_ 2887 
$node_(335) set Y_ 357 
$node_(335) set Z_ 0.0 
$ns at 0.0 "$node_(335) off" 
$ns at 300.0 "$node_(335) on" 
$node_(336) set X_ 950 
$node_(336) set Y_ 92 
$node_(336) set Z_ 0.0 
$ns at 0.0 "$node_(336) off" 
$ns at 300.0 "$node_(336) on" 
$node_(337) set X_ 2869 
$node_(337) set Y_ 115 
$node_(337) set Z_ 0.0 
$ns at 0.0 "$node_(337) off" 
$ns at 300.0 "$node_(337) on" 
$node_(338) set X_ 455 
$node_(338) set Y_ 502 
$node_(338) set Z_ 0.0 
$ns at 0.0 "$node_(338) off" 
$ns at 300.0 "$node_(338) on" 
$node_(339) set X_ 2488 
$node_(339) set Y_ 255 
$node_(339) set Z_ 0.0 
$ns at 0.0 "$node_(339) off" 
$ns at 300.0 "$node_(339) on" 
$node_(340) set X_ 1907 
$node_(340) set Y_ 176 
$node_(340) set Z_ 0.0 
$ns at 0.0 "$node_(340) off" 
$ns at 300.0 "$node_(340) on" 
$node_(341) set X_ 654 
$node_(341) set Y_ 891 
$node_(341) set Z_ 0.0 
$ns at 0.0 "$node_(341) off" 
$ns at 300.0 "$node_(341) on" 
$node_(342) set X_ 687 
$node_(342) set Y_ 511 
$node_(342) set Z_ 0.0 
$ns at 0.0 "$node_(342) off" 
$ns at 300.0 "$node_(342) on" 
$node_(343) set X_ 1827 
$node_(343) set Y_ 93 
$node_(343) set Z_ 0.0 
$ns at 0.0 "$node_(343) off" 
$ns at 300.0 "$node_(343) on" 
$node_(344) set X_ 2440 
$node_(344) set Y_ 686 
$node_(344) set Z_ 0.0 
$ns at 0.0 "$node_(344) off" 
$ns at 300.0 "$node_(344) on" 
$node_(345) set X_ 1486 
$node_(345) set Y_ 920 
$node_(345) set Z_ 0.0 
$ns at 0.0 "$node_(345) off" 
$ns at 300.0 "$node_(345) on" 
$node_(346) set X_ 2657 
$node_(346) set Y_ 312 
$node_(346) set Z_ 0.0 
$ns at 0.0 "$node_(346) off" 
$ns at 300.0 "$node_(346) on" 
$node_(347) set X_ 1450 
$node_(347) set Y_ 712 
$node_(347) set Z_ 0.0 
$ns at 0.0 "$node_(347) off" 
$ns at 300.0 "$node_(347) on" 
$node_(348) set X_ 1686 
$node_(348) set Y_ 888 
$node_(348) set Z_ 0.0 
$ns at 0.0 "$node_(348) off" 
$ns at 300.0 "$node_(348) on" 
$node_(349) set X_ 854 
$node_(349) set Y_ 754 
$node_(349) set Z_ 0.0 
$ns at 0.0 "$node_(349) off" 
$ns at 300.0 "$node_(349) on" 
$node_(350) set X_ 1276 
$node_(350) set Y_ 160 
$node_(350) set Z_ 0.0 
$ns at 0.0 "$node_(350) off" 
$ns at 300.0 "$node_(350) on" 
$node_(351) set X_ 2686 
$node_(351) set Y_ 621 
$node_(351) set Z_ 0.0 
$ns at 0.0 "$node_(351) off" 
$ns at 300.0 "$node_(351) on" 
$node_(352) set X_ 1783 
$node_(352) set Y_ 777 
$node_(352) set Z_ 0.0 
$ns at 0.0 "$node_(352) off" 
$ns at 300.0 "$node_(352) on" 
$node_(353) set X_ 2476 
$node_(353) set Y_ 138 
$node_(353) set Z_ 0.0 
$ns at 0.0 "$node_(353) off" 
$ns at 300.0 "$node_(353) on" 
$node_(354) set X_ 1161 
$node_(354) set Y_ 799 
$node_(354) set Z_ 0.0 
$ns at 0.0 "$node_(354) off" 
$ns at 300.0 "$node_(354) on" 
$node_(355) set X_ 2776 
$node_(355) set Y_ 898 
$node_(355) set Z_ 0.0 
$ns at 0.0 "$node_(355) off" 
$ns at 300.0 "$node_(355) on" 
$node_(356) set X_ 1808 
$node_(356) set Y_ 755 
$node_(356) set Z_ 0.0 
$ns at 0.0 "$node_(356) off" 
$ns at 300.0 "$node_(356) on" 
$node_(357) set X_ 693 
$node_(357) set Y_ 726 
$node_(357) set Z_ 0.0 
$ns at 0.0 "$node_(357) off" 
$ns at 300.0 "$node_(357) on" 
$node_(358) set X_ 2292 
$node_(358) set Y_ 914 
$node_(358) set Z_ 0.0 
$ns at 0.0 "$node_(358) off" 
$ns at 300.0 "$node_(358) on" 
$node_(359) set X_ 730 
$node_(359) set Y_ 289 
$node_(359) set Z_ 0.0 
$ns at 0.0 "$node_(359) off" 
$ns at 300.0 "$node_(359) on" 
$node_(360) set X_ 1840 
$node_(360) set Y_ 375 
$node_(360) set Z_ 0.0 
$ns at 0.0 "$node_(360) off" 
$ns at 300.0 "$node_(360) on" 
$node_(361) set X_ 718 
$node_(361) set Y_ 308 
$node_(361) set Z_ 0.0 
$ns at 0.0 "$node_(361) off" 
$ns at 300.0 "$node_(361) on" 
$node_(362) set X_ 2382 
$node_(362) set Y_ 367 
$node_(362) set Z_ 0.0 
$ns at 0.0 "$node_(362) off" 
$ns at 300.0 "$node_(362) on" 
$node_(363) set X_ 1609 
$node_(363) set Y_ 460 
$node_(363) set Z_ 0.0 
$ns at 0.0 "$node_(363) off" 
$ns at 300.0 "$node_(363) on" 
$node_(364) set X_ 2751 
$node_(364) set Y_ 911 
$node_(364) set Z_ 0.0 
$ns at 0.0 "$node_(364) off" 
$ns at 300.0 "$node_(364) on" 
$node_(365) set X_ 302 
$node_(365) set Y_ 123 
$node_(365) set Z_ 0.0 
$ns at 0.0 "$node_(365) off" 
$ns at 300.0 "$node_(365) on" 
$node_(366) set X_ 440 
$node_(366) set Y_ 589 
$node_(366) set Z_ 0.0 
$ns at 0.0 "$node_(366) off" 
$ns at 300.0 "$node_(366) on" 
$node_(367) set X_ 1652 
$node_(367) set Y_ 563 
$node_(367) set Z_ 0.0 
$ns at 0.0 "$node_(367) off" 
$ns at 300.0 "$node_(367) on" 
$node_(368) set X_ 114 
$node_(368) set Y_ 729 
$node_(368) set Z_ 0.0 
$ns at 0.0 "$node_(368) off" 
$ns at 300.0 "$node_(368) on" 
$node_(369) set X_ 1120 
$node_(369) set Y_ 37 
$node_(369) set Z_ 0.0 
$ns at 0.0 "$node_(369) off" 
$ns at 300.0 "$node_(369) on" 
$node_(370) set X_ 1793 
$node_(370) set Y_ 742 
$node_(370) set Z_ 0.0 
$ns at 0.0 "$node_(370) off" 
$ns at 300.0 "$node_(370) on" 
$node_(371) set X_ 440 
$node_(371) set Y_ 542 
$node_(371) set Z_ 0.0 
$ns at 0.0 "$node_(371) off" 
$ns at 300.0 "$node_(371) on" 
$node_(372) set X_ 1336 
$node_(372) set Y_ 704 
$node_(372) set Z_ 0.0 
$ns at 0.0 "$node_(372) off" 
$ns at 300.0 "$node_(372) on" 
$node_(373) set X_ 1945 
$node_(373) set Y_ 645 
$node_(373) set Z_ 0.0 
$ns at 0.0 "$node_(373) off" 
$ns at 300.0 "$node_(373) on" 
$node_(374) set X_ 1552 
$node_(374) set Y_ 517 
$node_(374) set Z_ 0.0 
$ns at 0.0 "$node_(374) off" 
$ns at 300.0 "$node_(374) on" 
$node_(375) set X_ 26 
$node_(375) set Y_ 860 
$node_(375) set Z_ 0.0 
$ns at 0.0 "$node_(375) off" 
$ns at 300.0 "$node_(375) on" 
$node_(376) set X_ 2885 
$node_(376) set Y_ 172 
$node_(376) set Z_ 0.0 
$ns at 0.0 "$node_(376) off" 
$ns at 300.0 "$node_(376) on" 
$node_(377) set X_ 1411 
$node_(377) set Y_ 604 
$node_(377) set Z_ 0.0 
$ns at 0.0 "$node_(377) off" 
$ns at 300.0 "$node_(377) on" 
$node_(378) set X_ 2263 
$node_(378) set Y_ 669 
$node_(378) set Z_ 0.0 
$ns at 0.0 "$node_(378) off" 
$ns at 300.0 "$node_(378) on" 
$node_(379) set X_ 2722 
$node_(379) set Y_ 568 
$node_(379) set Z_ 0.0 
$ns at 0.0 "$node_(379) off" 
$ns at 300.0 "$node_(379) on" 
$node_(380) set X_ 251 
$node_(380) set Y_ 148 
$node_(380) set Z_ 0.0 
$ns at 0.0 "$node_(380) off" 
$ns at 300.0 "$node_(380) on" 
$node_(381) set X_ 2923 
$node_(381) set Y_ 733 
$node_(381) set Z_ 0.0 
$ns at 0.0 "$node_(381) off" 
$ns at 300.0 "$node_(381) on" 
$node_(382) set X_ 2255 
$node_(382) set Y_ 666 
$node_(382) set Z_ 0.0 
$ns at 0.0 "$node_(382) off" 
$ns at 300.0 "$node_(382) on" 
$node_(383) set X_ 1964 
$node_(383) set Y_ 893 
$node_(383) set Z_ 0.0 
$ns at 0.0 "$node_(383) off" 
$ns at 300.0 "$node_(383) on" 
$node_(384) set X_ 1985 
$node_(384) set Y_ 807 
$node_(384) set Z_ 0.0 
$ns at 0.0 "$node_(384) off" 
$ns at 300.0 "$node_(384) on" 
$node_(385) set X_ 33 
$node_(385) set Y_ 701 
$node_(385) set Z_ 0.0 
$ns at 0.0 "$node_(385) off" 
$ns at 300.0 "$node_(385) on" 
$node_(386) set X_ 2919 
$node_(386) set Y_ 63 
$node_(386) set Z_ 0.0 
$ns at 0.0 "$node_(386) off" 
$ns at 300.0 "$node_(386) on" 
$node_(387) set X_ 454 
$node_(387) set Y_ 778 
$node_(387) set Z_ 0.0 
$ns at 0.0 "$node_(387) off" 
$ns at 300.0 "$node_(387) on" 
$node_(388) set X_ 1963 
$node_(388) set Y_ 460 
$node_(388) set Z_ 0.0 
$ns at 0.0 "$node_(388) off" 
$ns at 300.0 "$node_(388) on" 
$node_(389) set X_ 2322 
$node_(389) set Y_ 326 
$node_(389) set Z_ 0.0 
$ns at 0.0 "$node_(389) off" 
$ns at 300.0 "$node_(389) on" 
$node_(390) set X_ 2911 
$node_(390) set Y_ 455 
$node_(390) set Z_ 0.0 
$ns at 0.0 "$node_(390) off" 
$ns at 300.0 "$node_(390) on" 
$node_(391) set X_ 498 
$node_(391) set Y_ 35 
$node_(391) set Z_ 0.0 
$ns at 0.0 "$node_(391) off" 
$ns at 300.0 "$node_(391) on" 
$node_(392) set X_ 2728 
$node_(392) set Y_ 517 
$node_(392) set Z_ 0.0 
$ns at 0.0 "$node_(392) off" 
$ns at 300.0 "$node_(392) on" 
$node_(393) set X_ 619 
$node_(393) set Y_ 821 
$node_(393) set Z_ 0.0 
$ns at 0.0 "$node_(393) off" 
$ns at 300.0 "$node_(393) on" 
$node_(394) set X_ 2041 
$node_(394) set Y_ 130 
$node_(394) set Z_ 0.0 
$ns at 0.0 "$node_(394) off" 
$ns at 300.0 "$node_(394) on" 
$node_(395) set X_ 2231 
$node_(395) set Y_ 51 
$node_(395) set Z_ 0.0 
$ns at 0.0 "$node_(395) off" 
$ns at 300.0 "$node_(395) on" 
$node_(396) set X_ 541 
$node_(396) set Y_ 175 
$node_(396) set Z_ 0.0 
$ns at 0.0 "$node_(396) off" 
$ns at 300.0 "$node_(396) on" 
$node_(397) set X_ 2097 
$node_(397) set Y_ 502 
$node_(397) set Z_ 0.0 
$ns at 0.0 "$node_(397) off" 
$ns at 300.0 "$node_(397) on" 
$node_(398) set X_ 2331 
$node_(398) set Y_ 788 
$node_(398) set Z_ 0.0 
$ns at 0.0 "$node_(398) off" 
$ns at 300.0 "$node_(398) on" 
$node_(399) set X_ 1169 
$node_(399) set Y_ 213 
$node_(399) set Z_ 0.0 
$ns at 0.0 "$node_(399) off" 
$ns at 300.0 "$node_(399) on" 
$node_(400) set X_ 2503 
$node_(400) set Y_ 814 
$node_(400) set Z_ 0.0 
$ns at 0.0 "$node_(400) off" 
$ns at 400.0 "$node_(400) on" 
$node_(401) set X_ 2563 
$node_(401) set Y_ 790 
$node_(401) set Z_ 0.0 
$ns at 0.0 "$node_(401) off" 
$ns at 400.0 "$node_(401) on" 
$node_(402) set X_ 483 
$node_(402) set Y_ 930 
$node_(402) set Z_ 0.0 
$ns at 0.0 "$node_(402) off" 
$ns at 400.0 "$node_(402) on" 
$node_(403) set X_ 1253 
$node_(403) set Y_ 484 
$node_(403) set Z_ 0.0 
$ns at 0.0 "$node_(403) off" 
$ns at 400.0 "$node_(403) on" 
$node_(404) set X_ 2881 
$node_(404) set Y_ 350 
$node_(404) set Z_ 0.0 
$ns at 0.0 "$node_(404) off" 
$ns at 400.0 "$node_(404) on" 
$node_(405) set X_ 1000 
$node_(405) set Y_ 527 
$node_(405) set Z_ 0.0 
$ns at 0.0 "$node_(405) off" 
$ns at 400.0 "$node_(405) on" 
$node_(406) set X_ 2776 
$node_(406) set Y_ 788 
$node_(406) set Z_ 0.0 
$ns at 0.0 "$node_(406) off" 
$ns at 400.0 "$node_(406) on" 
$node_(407) set X_ 338 
$node_(407) set Y_ 806 
$node_(407) set Z_ 0.0 
$ns at 0.0 "$node_(407) off" 
$ns at 400.0 "$node_(407) on" 
$node_(408) set X_ 2500 
$node_(408) set Y_ 17 
$node_(408) set Z_ 0.0 
$ns at 0.0 "$node_(408) off" 
$ns at 400.0 "$node_(408) on" 
$node_(409) set X_ 173 
$node_(409) set Y_ 943 
$node_(409) set Z_ 0.0 
$ns at 0.0 "$node_(409) off" 
$ns at 400.0 "$node_(409) on" 
$node_(410) set X_ 1113 
$node_(410) set Y_ 907 
$node_(410) set Z_ 0.0 
$ns at 0.0 "$node_(410) off" 
$ns at 400.0 "$node_(410) on" 
$node_(411) set X_ 1804 
$node_(411) set Y_ 246 
$node_(411) set Z_ 0.0 
$ns at 0.0 "$node_(411) off" 
$ns at 400.0 "$node_(411) on" 
$node_(412) set X_ 2827 
$node_(412) set Y_ 341 
$node_(412) set Z_ 0.0 
$ns at 0.0 "$node_(412) off" 
$ns at 400.0 "$node_(412) on" 
$node_(413) set X_ 845 
$node_(413) set Y_ 785 
$node_(413) set Z_ 0.0 
$ns at 0.0 "$node_(413) off" 
$ns at 400.0 "$node_(413) on" 
$node_(414) set X_ 2727 
$node_(414) set Y_ 740 
$node_(414) set Z_ 0.0 
$ns at 0.0 "$node_(414) off" 
$ns at 400.0 "$node_(414) on" 
$node_(415) set X_ 1709 
$node_(415) set Y_ 76 
$node_(415) set Z_ 0.0 
$ns at 0.0 "$node_(415) off" 
$ns at 400.0 "$node_(415) on" 
$node_(416) set X_ 109 
$node_(416) set Y_ 261 
$node_(416) set Z_ 0.0 
$ns at 0.0 "$node_(416) off" 
$ns at 400.0 "$node_(416) on" 
$node_(417) set X_ 926 
$node_(417) set Y_ 446 
$node_(417) set Z_ 0.0 
$ns at 0.0 "$node_(417) off" 
$ns at 400.0 "$node_(417) on" 
$node_(418) set X_ 2794 
$node_(418) set Y_ 873 
$node_(418) set Z_ 0.0 
$ns at 0.0 "$node_(418) off" 
$ns at 400.0 "$node_(418) on" 
$node_(419) set X_ 696 
$node_(419) set Y_ 201 
$node_(419) set Z_ 0.0 
$ns at 0.0 "$node_(419) off" 
$ns at 400.0 "$node_(419) on" 
$node_(420) set X_ 2704 
$node_(420) set Y_ 670 
$node_(420) set Z_ 0.0 
$ns at 0.0 "$node_(420) off" 
$ns at 400.0 "$node_(420) on" 
$node_(421) set X_ 2611 
$node_(421) set Y_ 114 
$node_(421) set Z_ 0.0 
$ns at 0.0 "$node_(421) off" 
$ns at 400.0 "$node_(421) on" 
$node_(422) set X_ 2937 
$node_(422) set Y_ 740 
$node_(422) set Z_ 0.0 
$ns at 0.0 "$node_(422) off" 
$ns at 400.0 "$node_(422) on" 
$node_(423) set X_ 560 
$node_(423) set Y_ 613 
$node_(423) set Z_ 0.0 
$ns at 0.0 "$node_(423) off" 
$ns at 400.0 "$node_(423) on" 
$node_(424) set X_ 2454 
$node_(424) set Y_ 838 
$node_(424) set Z_ 0.0 
$ns at 0.0 "$node_(424) off" 
$ns at 400.0 "$node_(424) on" 
$node_(425) set X_ 1301 
$node_(425) set Y_ 263 
$node_(425) set Z_ 0.0 
$ns at 0.0 "$node_(425) off" 
$ns at 400.0 "$node_(425) on" 
$node_(426) set X_ 2382 
$node_(426) set Y_ 945 
$node_(426) set Z_ 0.0 
$ns at 0.0 "$node_(426) off" 
$ns at 400.0 "$node_(426) on" 
$node_(427) set X_ 175 
$node_(427) set Y_ 803 
$node_(427) set Z_ 0.0 
$ns at 0.0 "$node_(427) off" 
$ns at 400.0 "$node_(427) on" 
$node_(428) set X_ 2743 
$node_(428) set Y_ 470 
$node_(428) set Z_ 0.0 
$ns at 0.0 "$node_(428) off" 
$ns at 400.0 "$node_(428) on" 
$node_(429) set X_ 2891 
$node_(429) set Y_ 28 
$node_(429) set Z_ 0.0 
$ns at 0.0 "$node_(429) off" 
$ns at 400.0 "$node_(429) on" 
$node_(430) set X_ 254 
$node_(430) set Y_ 551 
$node_(430) set Z_ 0.0 
$ns at 0.0 "$node_(430) off" 
$ns at 400.0 "$node_(430) on" 
$node_(431) set X_ 204 
$node_(431) set Y_ 297 
$node_(431) set Z_ 0.0 
$ns at 0.0 "$node_(431) off" 
$ns at 400.0 "$node_(431) on" 
$node_(432) set X_ 2591 
$node_(432) set Y_ 377 
$node_(432) set Z_ 0.0 
$ns at 0.0 "$node_(432) off" 
$ns at 400.0 "$node_(432) on" 
$node_(433) set X_ 2707 
$node_(433) set Y_ 263 
$node_(433) set Z_ 0.0 
$ns at 0.0 "$node_(433) off" 
$ns at 400.0 "$node_(433) on" 
$node_(434) set X_ 256 
$node_(434) set Y_ 948 
$node_(434) set Z_ 0.0 
$ns at 0.0 "$node_(434) off" 
$ns at 400.0 "$node_(434) on" 
$node_(435) set X_ 2791 
$node_(435) set Y_ 753 
$node_(435) set Z_ 0.0 
$ns at 0.0 "$node_(435) off" 
$ns at 400.0 "$node_(435) on" 
$node_(436) set X_ 1919 
$node_(436) set Y_ 11 
$node_(436) set Z_ 0.0 
$ns at 0.0 "$node_(436) off" 
$ns at 400.0 "$node_(436) on" 
$node_(437) set X_ 1174 
$node_(437) set Y_ 339 
$node_(437) set Z_ 0.0 
$ns at 0.0 "$node_(437) off" 
$ns at 400.0 "$node_(437) on" 
$node_(438) set X_ 735 
$node_(438) set Y_ 170 
$node_(438) set Z_ 0.0 
$ns at 0.0 "$node_(438) off" 
$ns at 400.0 "$node_(438) on" 
$node_(439) set X_ 2149 
$node_(439) set Y_ 283 
$node_(439) set Z_ 0.0 
$ns at 0.0 "$node_(439) off" 
$ns at 400.0 "$node_(439) on" 
$node_(440) set X_ 852 
$node_(440) set Y_ 341 
$node_(440) set Z_ 0.0 
$ns at 0.0 "$node_(440) off" 
$ns at 400.0 "$node_(440) on" 
$node_(441) set X_ 2 
$node_(441) set Y_ 978 
$node_(441) set Z_ 0.0 
$ns at 0.0 "$node_(441) off" 
$ns at 400.0 "$node_(441) on" 
$node_(442) set X_ 1874 
$node_(442) set Y_ 767 
$node_(442) set Z_ 0.0 
$ns at 0.0 "$node_(442) off" 
$ns at 400.0 "$node_(442) on" 
$node_(443) set X_ 1740 
$node_(443) set Y_ 936 
$node_(443) set Z_ 0.0 
$ns at 0.0 "$node_(443) off" 
$ns at 400.0 "$node_(443) on" 
$node_(444) set X_ 2679 
$node_(444) set Y_ 811 
$node_(444) set Z_ 0.0 
$ns at 0.0 "$node_(444) off" 
$ns at 400.0 "$node_(444) on" 
$node_(445) set X_ 1472 
$node_(445) set Y_ 671 
$node_(445) set Z_ 0.0 
$ns at 0.0 "$node_(445) off" 
$ns at 400.0 "$node_(445) on" 
$node_(446) set X_ 2517 
$node_(446) set Y_ 598 
$node_(446) set Z_ 0.0 
$ns at 0.0 "$node_(446) off" 
$ns at 400.0 "$node_(446) on" 
$node_(447) set X_ 1482 
$node_(447) set Y_ 508 
$node_(447) set Z_ 0.0 
$ns at 0.0 "$node_(447) off" 
$ns at 400.0 "$node_(447) on" 
$node_(448) set X_ 845 
$node_(448) set Y_ 374 
$node_(448) set Z_ 0.0 
$ns at 0.0 "$node_(448) off" 
$ns at 400.0 "$node_(448) on" 
$node_(449) set X_ 1102 
$node_(449) set Y_ 498 
$node_(449) set Z_ 0.0 
$ns at 0.0 "$node_(449) off" 
$ns at 400.0 "$node_(449) on" 
$node_(450) set X_ 1855 
$node_(450) set Y_ 159 
$node_(450) set Z_ 0.0 
$ns at 0.0 "$node_(450) off" 
$ns at 400.0 "$node_(450) on" 
$node_(451) set X_ 1158 
$node_(451) set Y_ 118 
$node_(451) set Z_ 0.0 
$ns at 0.0 "$node_(451) off" 
$ns at 400.0 "$node_(451) on" 
$node_(452) set X_ 88 
$node_(452) set Y_ 830 
$node_(452) set Z_ 0.0 
$ns at 0.0 "$node_(452) off" 
$ns at 400.0 "$node_(452) on" 
$node_(453) set X_ 785 
$node_(453) set Y_ 369 
$node_(453) set Z_ 0.0 
$ns at 0.0 "$node_(453) off" 
$ns at 400.0 "$node_(453) on" 
$node_(454) set X_ 986 
$node_(454) set Y_ 314 
$node_(454) set Z_ 0.0 
$ns at 0.0 "$node_(454) off" 
$ns at 400.0 "$node_(454) on" 
$node_(455) set X_ 968 
$node_(455) set Y_ 210 
$node_(455) set Z_ 0.0 
$ns at 0.0 "$node_(455) off" 
$ns at 400.0 "$node_(455) on" 
$node_(456) set X_ 2605 
$node_(456) set Y_ 967 
$node_(456) set Z_ 0.0 
$ns at 0.0 "$node_(456) off" 
$ns at 400.0 "$node_(456) on" 
$node_(457) set X_ 1174 
$node_(457) set Y_ 22 
$node_(457) set Z_ 0.0 
$ns at 0.0 "$node_(457) off" 
$ns at 400.0 "$node_(457) on" 
$node_(458) set X_ 91 
$node_(458) set Y_ 524 
$node_(458) set Z_ 0.0 
$ns at 0.0 "$node_(458) off" 
$ns at 400.0 "$node_(458) on" 
$node_(459) set X_ 1897 
$node_(459) set Y_ 920 
$node_(459) set Z_ 0.0 
$ns at 0.0 "$node_(459) off" 
$ns at 400.0 "$node_(459) on" 
$node_(460) set X_ 1859 
$node_(460) set Y_ 239 
$node_(460) set Z_ 0.0 
$ns at 0.0 "$node_(460) off" 
$ns at 400.0 "$node_(460) on" 
$node_(461) set X_ 1902 
$node_(461) set Y_ 303 
$node_(461) set Z_ 0.0 
$ns at 0.0 "$node_(461) off" 
$ns at 400.0 "$node_(461) on" 
$node_(462) set X_ 2710 
$node_(462) set Y_ 966 
$node_(462) set Z_ 0.0 
$ns at 0.0 "$node_(462) off" 
$ns at 400.0 "$node_(462) on" 
$node_(463) set X_ 357 
$node_(463) set Y_ 974 
$node_(463) set Z_ 0.0 
$ns at 0.0 "$node_(463) off" 
$ns at 400.0 "$node_(463) on" 
$node_(464) set X_ 396 
$node_(464) set Y_ 961 
$node_(464) set Z_ 0.0 
$ns at 0.0 "$node_(464) off" 
$ns at 400.0 "$node_(464) on" 
$node_(465) set X_ 2925 
$node_(465) set Y_ 540 
$node_(465) set Z_ 0.0 
$ns at 0.0 "$node_(465) off" 
$ns at 400.0 "$node_(465) on" 
$node_(466) set X_ 386 
$node_(466) set Y_ 127 
$node_(466) set Z_ 0.0 
$ns at 0.0 "$node_(466) off" 
$ns at 400.0 "$node_(466) on" 
$node_(467) set X_ 2249 
$node_(467) set Y_ 553 
$node_(467) set Z_ 0.0 
$ns at 0.0 "$node_(467) off" 
$ns at 400.0 "$node_(467) on" 
$node_(468) set X_ 2802 
$node_(468) set Y_ 279 
$node_(468) set Z_ 0.0 
$ns at 0.0 "$node_(468) off" 
$ns at 400.0 "$node_(468) on" 
$node_(469) set X_ 1053 
$node_(469) set Y_ 64 
$node_(469) set Z_ 0.0 
$ns at 0.0 "$node_(469) off" 
$ns at 400.0 "$node_(469) on" 
$node_(470) set X_ 1652 
$node_(470) set Y_ 758 
$node_(470) set Z_ 0.0 
$ns at 0.0 "$node_(470) off" 
$ns at 400.0 "$node_(470) on" 
$node_(471) set X_ 1415 
$node_(471) set Y_ 792 
$node_(471) set Z_ 0.0 
$ns at 0.0 "$node_(471) off" 
$ns at 400.0 "$node_(471) on" 
$node_(472) set X_ 1666 
$node_(472) set Y_ 380 
$node_(472) set Z_ 0.0 
$ns at 0.0 "$node_(472) off" 
$ns at 400.0 "$node_(472) on" 
$node_(473) set X_ 482 
$node_(473) set Y_ 167 
$node_(473) set Z_ 0.0 
$ns at 0.0 "$node_(473) off" 
$ns at 400.0 "$node_(473) on" 
$node_(474) set X_ 2121 
$node_(474) set Y_ 285 
$node_(474) set Z_ 0.0 
$ns at 0.0 "$node_(474) off" 
$ns at 400.0 "$node_(474) on" 
$node_(475) set X_ 143 
$node_(475) set Y_ 835 
$node_(475) set Z_ 0.0 
$ns at 0.0 "$node_(475) off" 
$ns at 400.0 "$node_(475) on" 
$node_(476) set X_ 2165 
$node_(476) set Y_ 700 
$node_(476) set Z_ 0.0 
$ns at 0.0 "$node_(476) off" 
$ns at 400.0 "$node_(476) on" 
$node_(477) set X_ 2883 
$node_(477) set Y_ 60 
$node_(477) set Z_ 0.0 
$ns at 0.0 "$node_(477) off" 
$ns at 400.0 "$node_(477) on" 
$node_(478) set X_ 166 
$node_(478) set Y_ 52 
$node_(478) set Z_ 0.0 
$ns at 0.0 "$node_(478) off" 
$ns at 400.0 "$node_(478) on" 
$node_(479) set X_ 162 
$node_(479) set Y_ 646 
$node_(479) set Z_ 0.0 
$ns at 0.0 "$node_(479) off" 
$ns at 400.0 "$node_(479) on" 
$node_(480) set X_ 2657 
$node_(480) set Y_ 102 
$node_(480) set Z_ 0.0 
$ns at 0.0 "$node_(480) off" 
$ns at 400.0 "$node_(480) on" 
$node_(481) set X_ 352 
$node_(481) set Y_ 624 
$node_(481) set Z_ 0.0 
$ns at 0.0 "$node_(481) off" 
$ns at 400.0 "$node_(481) on" 
$node_(482) set X_ 1445 
$node_(482) set Y_ 5 
$node_(482) set Z_ 0.0 
$ns at 0.0 "$node_(482) off" 
$ns at 400.0 "$node_(482) on" 
$node_(483) set X_ 1312 
$node_(483) set Y_ 964 
$node_(483) set Z_ 0.0 
$ns at 0.0 "$node_(483) off" 
$ns at 400.0 "$node_(483) on" 
$node_(484) set X_ 2382 
$node_(484) set Y_ 278 
$node_(484) set Z_ 0.0 
$ns at 0.0 "$node_(484) off" 
$ns at 400.0 "$node_(484) on" 
$node_(485) set X_ 1285 
$node_(485) set Y_ 3 
$node_(485) set Z_ 0.0 
$ns at 0.0 "$node_(485) off" 
$ns at 400.0 "$node_(485) on" 
$node_(486) set X_ 1260 
$node_(486) set Y_ 674 
$node_(486) set Z_ 0.0 
$ns at 0.0 "$node_(486) off" 
$ns at 400.0 "$node_(486) on" 
$node_(487) set X_ 828 
$node_(487) set Y_ 112 
$node_(487) set Z_ 0.0 
$ns at 0.0 "$node_(487) off" 
$ns at 400.0 "$node_(487) on" 
$node_(488) set X_ 164 
$node_(488) set Y_ 852 
$node_(488) set Z_ 0.0 
$ns at 0.0 "$node_(488) off" 
$ns at 400.0 "$node_(488) on" 
$node_(489) set X_ 2986 
$node_(489) set Y_ 355 
$node_(489) set Z_ 0.0 
$ns at 0.0 "$node_(489) off" 
$ns at 400.0 "$node_(489) on" 
$node_(490) set X_ 497 
$node_(490) set Y_ 582 
$node_(490) set Z_ 0.0 
$ns at 0.0 "$node_(490) off" 
$ns at 400.0 "$node_(490) on" 
$node_(491) set X_ 1912 
$node_(491) set Y_ 568 
$node_(491) set Z_ 0.0 
$ns at 0.0 "$node_(491) off" 
$ns at 400.0 "$node_(491) on" 
$node_(492) set X_ 2719 
$node_(492) set Y_ 920 
$node_(492) set Z_ 0.0 
$ns at 0.0 "$node_(492) off" 
$ns at 400.0 "$node_(492) on" 
$node_(493) set X_ 2562 
$node_(493) set Y_ 288 
$node_(493) set Z_ 0.0 
$ns at 0.0 "$node_(493) off" 
$ns at 400.0 "$node_(493) on" 
$node_(494) set X_ 648 
$node_(494) set Y_ 424 
$node_(494) set Z_ 0.0 
$ns at 0.0 "$node_(494) off" 
$ns at 400.0 "$node_(494) on" 
$node_(495) set X_ 2027 
$node_(495) set Y_ 476 
$node_(495) set Z_ 0.0 
$ns at 0.0 "$node_(495) off" 
$ns at 400.0 "$node_(495) on" 
$node_(496) set X_ 1947 
$node_(496) set Y_ 34 
$node_(496) set Z_ 0.0 
$ns at 0.0 "$node_(496) off" 
$ns at 400.0 "$node_(496) on" 
$node_(497) set X_ 421 
$node_(497) set Y_ 799 
$node_(497) set Z_ 0.0 
$ns at 0.0 "$node_(497) off" 
$ns at 400.0 "$node_(497) on" 
$node_(498) set X_ 2154 
$node_(498) set Y_ 652 
$node_(498) set Z_ 0.0 
$ns at 0.0 "$node_(498) off" 
$ns at 400.0 "$node_(498) on" 
$node_(499) set X_ 1115 
$node_(499) set Y_ 526 
$node_(499) set Z_ 0.0 
$ns at 0.0 "$node_(499) off" 
$ns at 400.0 "$node_(499) on" 
$node_(500) set X_ 1329 
$node_(500) set Y_ 843 
$node_(500) set Z_ 0.0 
$ns at 0.0 "$node_(500) off" 
$ns at 500.0 "$node_(500) on" 
$node_(501) set X_ 2426 
$node_(501) set Y_ 769 
$node_(501) set Z_ 0.0 
$ns at 0.0 "$node_(501) off" 
$ns at 500.0 "$node_(501) on" 
$node_(502) set X_ 1071 
$node_(502) set Y_ 301 
$node_(502) set Z_ 0.0 
$ns at 0.0 "$node_(502) off" 
$ns at 500.0 "$node_(502) on" 
$node_(503) set X_ 1639 
$node_(503) set Y_ 878 
$node_(503) set Z_ 0.0 
$ns at 0.0 "$node_(503) off" 
$ns at 500.0 "$node_(503) on" 
$node_(504) set X_ 1298 
$node_(504) set Y_ 897 
$node_(504) set Z_ 0.0 
$ns at 0.0 "$node_(504) off" 
$ns at 500.0 "$node_(504) on" 
$node_(505) set X_ 516 
$node_(505) set Y_ 295 
$node_(505) set Z_ 0.0 
$ns at 0.0 "$node_(505) off" 
$ns at 500.0 "$node_(505) on" 
$node_(506) set X_ 804 
$node_(506) set Y_ 204 
$node_(506) set Z_ 0.0 
$ns at 0.0 "$node_(506) off" 
$ns at 500.0 "$node_(506) on" 
$node_(507) set X_ 168 
$node_(507) set Y_ 54 
$node_(507) set Z_ 0.0 
$ns at 0.0 "$node_(507) off" 
$ns at 500.0 "$node_(507) on" 
$node_(508) set X_ 1205 
$node_(508) set Y_ 346 
$node_(508) set Z_ 0.0 
$ns at 0.0 "$node_(508) off" 
$ns at 500.0 "$node_(508) on" 
$node_(509) set X_ 2349 
$node_(509) set Y_ 435 
$node_(509) set Z_ 0.0 
$ns at 0.0 "$node_(509) off" 
$ns at 500.0 "$node_(509) on" 
$node_(510) set X_ 2400 
$node_(510) set Y_ 924 
$node_(510) set Z_ 0.0 
$ns at 0.0 "$node_(510) off" 
$ns at 500.0 "$node_(510) on" 
$node_(511) set X_ 913 
$node_(511) set Y_ 973 
$node_(511) set Z_ 0.0 
$ns at 0.0 "$node_(511) off" 
$ns at 500.0 "$node_(511) on" 
$node_(512) set X_ 1255 
$node_(512) set Y_ 525 
$node_(512) set Z_ 0.0 
$ns at 0.0 "$node_(512) off" 
$ns at 500.0 "$node_(512) on" 
$node_(513) set X_ 1282 
$node_(513) set Y_ 143 
$node_(513) set Z_ 0.0 
$ns at 0.0 "$node_(513) off" 
$ns at 500.0 "$node_(513) on" 
$node_(514) set X_ 651 
$node_(514) set Y_ 48 
$node_(514) set Z_ 0.0 
$ns at 0.0 "$node_(514) off" 
$ns at 500.0 "$node_(514) on" 
$node_(515) set X_ 1409 
$node_(515) set Y_ 561 
$node_(515) set Z_ 0.0 
$ns at 0.0 "$node_(515) off" 
$ns at 500.0 "$node_(515) on" 
$node_(516) set X_ 531 
$node_(516) set Y_ 656 
$node_(516) set Z_ 0.0 
$ns at 0.0 "$node_(516) off" 
$ns at 500.0 "$node_(516) on" 
$node_(517) set X_ 741 
$node_(517) set Y_ 469 
$node_(517) set Z_ 0.0 
$ns at 0.0 "$node_(517) off" 
$ns at 500.0 "$node_(517) on" 
$node_(518) set X_ 2009 
$node_(518) set Y_ 674 
$node_(518) set Z_ 0.0 
$ns at 0.0 "$node_(518) off" 
$ns at 500.0 "$node_(518) on" 
$node_(519) set X_ 280 
$node_(519) set Y_ 606 
$node_(519) set Z_ 0.0 
$ns at 0.0 "$node_(519) off" 
$ns at 500.0 "$node_(519) on" 
$node_(520) set X_ 2975 
$node_(520) set Y_ 166 
$node_(520) set Z_ 0.0 
$ns at 0.0 "$node_(520) off" 
$ns at 500.0 "$node_(520) on" 
$node_(521) set X_ 793 
$node_(521) set Y_ 300 
$node_(521) set Z_ 0.0 
$ns at 0.0 "$node_(521) off" 
$ns at 500.0 "$node_(521) on" 
$node_(522) set X_ 40 
$node_(522) set Y_ 241 
$node_(522) set Z_ 0.0 
$ns at 0.0 "$node_(522) off" 
$ns at 500.0 "$node_(522) on" 
$node_(523) set X_ 2754 
$node_(523) set Y_ 779 
$node_(523) set Z_ 0.0 
$ns at 0.0 "$node_(523) off" 
$ns at 500.0 "$node_(523) on" 
$node_(524) set X_ 1949 
$node_(524) set Y_ 355 
$node_(524) set Z_ 0.0 
$ns at 0.0 "$node_(524) off" 
$ns at 500.0 "$node_(524) on" 
$node_(525) set X_ 2476 
$node_(525) set Y_ 213 
$node_(525) set Z_ 0.0 
$ns at 0.0 "$node_(525) off" 
$ns at 500.0 "$node_(525) on" 
$node_(526) set X_ 937 
$node_(526) set Y_ 28 
$node_(526) set Z_ 0.0 
$ns at 0.0 "$node_(526) off" 
$ns at 500.0 "$node_(526) on" 
$node_(527) set X_ 386 
$node_(527) set Y_ 14 
$node_(527) set Z_ 0.0 
$ns at 0.0 "$node_(527) off" 
$ns at 500.0 "$node_(527) on" 
$node_(528) set X_ 1753 
$node_(528) set Y_ 391 
$node_(528) set Z_ 0.0 
$ns at 0.0 "$node_(528) off" 
$ns at 500.0 "$node_(528) on" 
$node_(529) set X_ 2196 
$node_(529) set Y_ 228 
$node_(529) set Z_ 0.0 
$ns at 0.0 "$node_(529) off" 
$ns at 500.0 "$node_(529) on" 
$node_(530) set X_ 319 
$node_(530) set Y_ 966 
$node_(530) set Z_ 0.0 
$ns at 0.0 "$node_(530) off" 
$ns at 500.0 "$node_(530) on" 
$node_(531) set X_ 1147 
$node_(531) set Y_ 655 
$node_(531) set Z_ 0.0 
$ns at 0.0 "$node_(531) off" 
$ns at 500.0 "$node_(531) on" 
$node_(532) set X_ 211 
$node_(532) set Y_ 896 
$node_(532) set Z_ 0.0 
$ns at 0.0 "$node_(532) off" 
$ns at 500.0 "$node_(532) on" 
$node_(533) set X_ 255 
$node_(533) set Y_ 518 
$node_(533) set Z_ 0.0 
$ns at 0.0 "$node_(533) off" 
$ns at 500.0 "$node_(533) on" 
$node_(534) set X_ 2320 
$node_(534) set Y_ 609 
$node_(534) set Z_ 0.0 
$ns at 0.0 "$node_(534) off" 
$ns at 500.0 "$node_(534) on" 
$node_(535) set X_ 836 
$node_(535) set Y_ 49 
$node_(535) set Z_ 0.0 
$ns at 0.0 "$node_(535) off" 
$ns at 500.0 "$node_(535) on" 
$node_(536) set X_ 1200 
$node_(536) set Y_ 581 
$node_(536) set Z_ 0.0 
$ns at 0.0 "$node_(536) off" 
$ns at 500.0 "$node_(536) on" 
$node_(537) set X_ 304 
$node_(537) set Y_ 379 
$node_(537) set Z_ 0.0 
$ns at 0.0 "$node_(537) off" 
$ns at 500.0 "$node_(537) on" 
$node_(538) set X_ 1720 
$node_(538) set Y_ 378 
$node_(538) set Z_ 0.0 
$ns at 0.0 "$node_(538) off" 
$ns at 500.0 "$node_(538) on" 
$node_(539) set X_ 476 
$node_(539) set Y_ 522 
$node_(539) set Z_ 0.0 
$ns at 0.0 "$node_(539) off" 
$ns at 500.0 "$node_(539) on" 
$node_(540) set X_ 747 
$node_(540) set Y_ 695 
$node_(540) set Z_ 0.0 
$ns at 0.0 "$node_(540) off" 
$ns at 500.0 "$node_(540) on" 
$node_(541) set X_ 1307 
$node_(541) set Y_ 998 
$node_(541) set Z_ 0.0 
$ns at 0.0 "$node_(541) off" 
$ns at 500.0 "$node_(541) on" 
$node_(542) set X_ 598 
$node_(542) set Y_ 447 
$node_(542) set Z_ 0.0 
$ns at 0.0 "$node_(542) off" 
$ns at 500.0 "$node_(542) on" 
$node_(543) set X_ 1153 
$node_(543) set Y_ 905 
$node_(543) set Z_ 0.0 
$ns at 0.0 "$node_(543) off" 
$ns at 500.0 "$node_(543) on" 
$node_(544) set X_ 2064 
$node_(544) set Y_ 255 
$node_(544) set Z_ 0.0 
$ns at 0.0 "$node_(544) off" 
$ns at 500.0 "$node_(544) on" 
$node_(545) set X_ 2283 
$node_(545) set Y_ 835 
$node_(545) set Z_ 0.0 
$ns at 0.0 "$node_(545) off" 
$ns at 500.0 "$node_(545) on" 
$node_(546) set X_ 2772 
$node_(546) set Y_ 890 
$node_(546) set Z_ 0.0 
$ns at 0.0 "$node_(546) off" 
$ns at 500.0 "$node_(546) on" 
$node_(547) set X_ 1452 
$node_(547) set Y_ 31 
$node_(547) set Z_ 0.0 
$ns at 0.0 "$node_(547) off" 
$ns at 500.0 "$node_(547) on" 
$node_(548) set X_ 1630 
$node_(548) set Y_ 310 
$node_(548) set Z_ 0.0 
$ns at 0.0 "$node_(548) off" 
$ns at 500.0 "$node_(548) on" 
$node_(549) set X_ 1935 
$node_(549) set Y_ 666 
$node_(549) set Z_ 0.0 
$ns at 0.0 "$node_(549) off" 
$ns at 500.0 "$node_(549) on" 
$node_(550) set X_ 2006 
$node_(550) set Y_ 932 
$node_(550) set Z_ 0.0 
$ns at 0.0 "$node_(550) off" 
$ns at 500.0 "$node_(550) on" 
$node_(551) set X_ 2455 
$node_(551) set Y_ 889 
$node_(551) set Z_ 0.0 
$ns at 0.0 "$node_(551) off" 
$ns at 500.0 "$node_(551) on" 
$node_(552) set X_ 215 
$node_(552) set Y_ 720 
$node_(552) set Z_ 0.0 
$ns at 0.0 "$node_(552) off" 
$ns at 500.0 "$node_(552) on" 
$node_(553) set X_ 2927 
$node_(553) set Y_ 579 
$node_(553) set Z_ 0.0 
$ns at 0.0 "$node_(553) off" 
$ns at 500.0 "$node_(553) on" 
$node_(554) set X_ 1739 
$node_(554) set Y_ 438 
$node_(554) set Z_ 0.0 
$ns at 0.0 "$node_(554) off" 
$ns at 500.0 "$node_(554) on" 
$node_(555) set X_ 1954 
$node_(555) set Y_ 357 
$node_(555) set Z_ 0.0 
$ns at 0.0 "$node_(555) off" 
$ns at 500.0 "$node_(555) on" 
$node_(556) set X_ 441 
$node_(556) set Y_ 194 
$node_(556) set Z_ 0.0 
$ns at 0.0 "$node_(556) off" 
$ns at 500.0 "$node_(556) on" 
$node_(557) set X_ 1400 
$node_(557) set Y_ 481 
$node_(557) set Z_ 0.0 
$ns at 0.0 "$node_(557) off" 
$ns at 500.0 "$node_(557) on" 
$node_(558) set X_ 2836 
$node_(558) set Y_ 992 
$node_(558) set Z_ 0.0 
$ns at 0.0 "$node_(558) off" 
$ns at 500.0 "$node_(558) on" 
$node_(559) set X_ 2341 
$node_(559) set Y_ 688 
$node_(559) set Z_ 0.0 
$ns at 0.0 "$node_(559) off" 
$ns at 500.0 "$node_(559) on" 
$node_(560) set X_ 1272 
$node_(560) set Y_ 562 
$node_(560) set Z_ 0.0 
$ns at 0.0 "$node_(560) off" 
$ns at 500.0 "$node_(560) on" 
$node_(561) set X_ 22 
$node_(561) set Y_ 923 
$node_(561) set Z_ 0.0 
$ns at 0.0 "$node_(561) off" 
$ns at 500.0 "$node_(561) on" 
$node_(562) set X_ 1588 
$node_(562) set Y_ 182 
$node_(562) set Z_ 0.0 
$ns at 0.0 "$node_(562) off" 
$ns at 500.0 "$node_(562) on" 
$node_(563) set X_ 336 
$node_(563) set Y_ 173 
$node_(563) set Z_ 0.0 
$ns at 0.0 "$node_(563) off" 
$ns at 500.0 "$node_(563) on" 
$node_(564) set X_ 541 
$node_(564) set Y_ 541 
$node_(564) set Z_ 0.0 
$ns at 0.0 "$node_(564) off" 
$ns at 500.0 "$node_(564) on" 
$node_(565) set X_ 2635 
$node_(565) set Y_ 274 
$node_(565) set Z_ 0.0 
$ns at 0.0 "$node_(565) off" 
$ns at 500.0 "$node_(565) on" 
$node_(566) set X_ 1984 
$node_(566) set Y_ 961 
$node_(566) set Z_ 0.0 
$ns at 0.0 "$node_(566) off" 
$ns at 500.0 "$node_(566) on" 
$node_(567) set X_ 2499 
$node_(567) set Y_ 669 
$node_(567) set Z_ 0.0 
$ns at 0.0 "$node_(567) off" 
$ns at 500.0 "$node_(567) on" 
$node_(568) set X_ 2390 
$node_(568) set Y_ 460 
$node_(568) set Z_ 0.0 
$ns at 0.0 "$node_(568) off" 
$ns at 500.0 "$node_(568) on" 
$node_(569) set X_ 303 
$node_(569) set Y_ 573 
$node_(569) set Z_ 0.0 
$ns at 0.0 "$node_(569) off" 
$ns at 500.0 "$node_(569) on" 
$node_(570) set X_ 1978 
$node_(570) set Y_ 179 
$node_(570) set Z_ 0.0 
$ns at 0.0 "$node_(570) off" 
$ns at 500.0 "$node_(570) on" 
$node_(571) set X_ 206 
$node_(571) set Y_ 896 
$node_(571) set Z_ 0.0 
$ns at 0.0 "$node_(571) off" 
$ns at 500.0 "$node_(571) on" 
$node_(572) set X_ 244 
$node_(572) set Y_ 704 
$node_(572) set Z_ 0.0 
$ns at 0.0 "$node_(572) off" 
$ns at 500.0 "$node_(572) on" 
$node_(573) set X_ 1320 
$node_(573) set Y_ 578 
$node_(573) set Z_ 0.0 
$ns at 0.0 "$node_(573) off" 
$ns at 500.0 "$node_(573) on" 
$node_(574) set X_ 1265 
$node_(574) set Y_ 671 
$node_(574) set Z_ 0.0 
$ns at 0.0 "$node_(574) off" 
$ns at 500.0 "$node_(574) on" 
$node_(575) set X_ 524 
$node_(575) set Y_ 699 
$node_(575) set Z_ 0.0 
$ns at 0.0 "$node_(575) off" 
$ns at 500.0 "$node_(575) on" 
$node_(576) set X_ 2692 
$node_(576) set Y_ 841 
$node_(576) set Z_ 0.0 
$ns at 0.0 "$node_(576) off" 
$ns at 500.0 "$node_(576) on" 
$node_(577) set X_ 2498 
$node_(577) set Y_ 842 
$node_(577) set Z_ 0.0 
$ns at 0.0 "$node_(577) off" 
$ns at 500.0 "$node_(577) on" 
$node_(578) set X_ 789 
$node_(578) set Y_ 504 
$node_(578) set Z_ 0.0 
$ns at 0.0 "$node_(578) off" 
$ns at 500.0 "$node_(578) on" 
$node_(579) set X_ 164 
$node_(579) set Y_ 696 
$node_(579) set Z_ 0.0 
$ns at 0.0 "$node_(579) off" 
$ns at 500.0 "$node_(579) on" 
$node_(580) set X_ 2389 
$node_(580) set Y_ 701 
$node_(580) set Z_ 0.0 
$ns at 0.0 "$node_(580) off" 
$ns at 500.0 "$node_(580) on" 
$node_(581) set X_ 774 
$node_(581) set Y_ 847 
$node_(581) set Z_ 0.0 
$ns at 0.0 "$node_(581) off" 
$ns at 500.0 "$node_(581) on" 
$node_(582) set X_ 1014 
$node_(582) set Y_ 237 
$node_(582) set Z_ 0.0 
$ns at 0.0 "$node_(582) off" 
$ns at 500.0 "$node_(582) on" 
$node_(583) set X_ 452 
$node_(583) set Y_ 976 
$node_(583) set Z_ 0.0 
$ns at 0.0 "$node_(583) off" 
$ns at 500.0 "$node_(583) on" 
$node_(584) set X_ 1860 
$node_(584) set Y_ 861 
$node_(584) set Z_ 0.0 
$ns at 0.0 "$node_(584) off" 
$ns at 500.0 "$node_(584) on" 
$node_(585) set X_ 963 
$node_(585) set Y_ 504 
$node_(585) set Z_ 0.0 
$ns at 0.0 "$node_(585) off" 
$ns at 500.0 "$node_(585) on" 
$node_(586) set X_ 663 
$node_(586) set Y_ 333 
$node_(586) set Z_ 0.0 
$ns at 0.0 "$node_(586) off" 
$ns at 500.0 "$node_(586) on" 
$node_(587) set X_ 1 
$node_(587) set Y_ 787 
$node_(587) set Z_ 0.0 
$ns at 0.0 "$node_(587) off" 
$ns at 500.0 "$node_(587) on" 
$node_(588) set X_ 820 
$node_(588) set Y_ 303 
$node_(588) set Z_ 0.0 
$ns at 0.0 "$node_(588) off" 
$ns at 500.0 "$node_(588) on" 
$node_(589) set X_ 202 
$node_(589) set Y_ 575 
$node_(589) set Z_ 0.0 
$ns at 0.0 "$node_(589) off" 
$ns at 500.0 "$node_(589) on" 
$node_(590) set X_ 1458 
$node_(590) set Y_ 55 
$node_(590) set Z_ 0.0 
$ns at 0.0 "$node_(590) off" 
$ns at 500.0 "$node_(590) on" 
$node_(591) set X_ 1508 
$node_(591) set Y_ 385 
$node_(591) set Z_ 0.0 
$ns at 0.0 "$node_(591) off" 
$ns at 500.0 "$node_(591) on" 
$node_(592) set X_ 378 
$node_(592) set Y_ 218 
$node_(592) set Z_ 0.0 
$ns at 0.0 "$node_(592) off" 
$ns at 500.0 "$node_(592) on" 
$node_(593) set X_ 2405 
$node_(593) set Y_ 799 
$node_(593) set Z_ 0.0 
$ns at 0.0 "$node_(593) off" 
$ns at 500.0 "$node_(593) on" 
$node_(594) set X_ 1082 
$node_(594) set Y_ 483 
$node_(594) set Z_ 0.0 
$ns at 0.0 "$node_(594) off" 
$ns at 500.0 "$node_(594) on" 
$node_(595) set X_ 876 
$node_(595) set Y_ 470 
$node_(595) set Z_ 0.0 
$ns at 0.0 "$node_(595) off" 
$ns at 500.0 "$node_(595) on" 
$node_(596) set X_ 2264 
$node_(596) set Y_ 198 
$node_(596) set Z_ 0.0 
$ns at 0.0 "$node_(596) off" 
$ns at 500.0 "$node_(596) on" 
$node_(597) set X_ 2776 
$node_(597) set Y_ 805 
$node_(597) set Z_ 0.0 
$ns at 0.0 "$node_(597) off" 
$ns at 500.0 "$node_(597) on" 
$node_(598) set X_ 2369 
$node_(598) set Y_ 507 
$node_(598) set Z_ 0.0 
$ns at 0.0 "$node_(598) off" 
$ns at 500.0 "$node_(598) on" 
$node_(599) set X_ 2573 
$node_(599) set Y_ 876 
$node_(599) set Z_ 0.0 
$ns at 0.0 "$node_(599) off" 
$ns at 500.0 "$node_(599) on" 
$node_(600) set X_ 2920 
$node_(600) set Y_ 304 
$node_(600) set Z_ 0.0 
$ns at 0.0 "$node_(600) off" 
$ns at 600.0 "$node_(600) on" 
$node_(601) set X_ 199 
$node_(601) set Y_ 75 
$node_(601) set Z_ 0.0 
$ns at 0.0 "$node_(601) off" 
$ns at 600.0 "$node_(601) on" 
$node_(602) set X_ 1472 
$node_(602) set Y_ 904 
$node_(602) set Z_ 0.0 
$ns at 0.0 "$node_(602) off" 
$ns at 600.0 "$node_(602) on" 
$node_(603) set X_ 942 
$node_(603) set Y_ 463 
$node_(603) set Z_ 0.0 
$ns at 0.0 "$node_(603) off" 
$ns at 600.0 "$node_(603) on" 
$node_(604) set X_ 1111 
$node_(604) set Y_ 747 
$node_(604) set Z_ 0.0 
$ns at 0.0 "$node_(604) off" 
$ns at 600.0 "$node_(604) on" 
$node_(605) set X_ 56 
$node_(605) set Y_ 537 
$node_(605) set Z_ 0.0 
$ns at 0.0 "$node_(605) off" 
$ns at 600.0 "$node_(605) on" 
$node_(606) set X_ 2492 
$node_(606) set Y_ 874 
$node_(606) set Z_ 0.0 
$ns at 0.0 "$node_(606) off" 
$ns at 600.0 "$node_(606) on" 
$node_(607) set X_ 2859 
$node_(607) set Y_ 356 
$node_(607) set Z_ 0.0 
$ns at 0.0 "$node_(607) off" 
$ns at 600.0 "$node_(607) on" 
$node_(608) set X_ 2397 
$node_(608) set Y_ 178 
$node_(608) set Z_ 0.0 
$ns at 0.0 "$node_(608) off" 
$ns at 600.0 "$node_(608) on" 
$node_(609) set X_ 790 
$node_(609) set Y_ 578 
$node_(609) set Z_ 0.0 
$ns at 0.0 "$node_(609) off" 
$ns at 600.0 "$node_(609) on" 
$node_(610) set X_ 1832 
$node_(610) set Y_ 635 
$node_(610) set Z_ 0.0 
$ns at 0.0 "$node_(610) off" 
$ns at 600.0 "$node_(610) on" 
$node_(611) set X_ 2953 
$node_(611) set Y_ 988 
$node_(611) set Z_ 0.0 
$ns at 0.0 "$node_(611) off" 
$ns at 600.0 "$node_(611) on" 
$node_(612) set X_ 1603 
$node_(612) set Y_ 811 
$node_(612) set Z_ 0.0 
$ns at 0.0 "$node_(612) off" 
$ns at 600.0 "$node_(612) on" 
$node_(613) set X_ 256 
$node_(613) set Y_ 522 
$node_(613) set Z_ 0.0 
$ns at 0.0 "$node_(613) off" 
$ns at 600.0 "$node_(613) on" 
$node_(614) set X_ 254 
$node_(614) set Y_ 953 
$node_(614) set Z_ 0.0 
$ns at 0.0 "$node_(614) off" 
$ns at 600.0 "$node_(614) on" 
$node_(615) set X_ 304 
$node_(615) set Y_ 602 
$node_(615) set Z_ 0.0 
$ns at 0.0 "$node_(615) off" 
$ns at 600.0 "$node_(615) on" 
$node_(616) set X_ 157 
$node_(616) set Y_ 881 
$node_(616) set Z_ 0.0 
$ns at 0.0 "$node_(616) off" 
$ns at 600.0 "$node_(616) on" 
$node_(617) set X_ 1690 
$node_(617) set Y_ 887 
$node_(617) set Z_ 0.0 
$ns at 0.0 "$node_(617) off" 
$ns at 600.0 "$node_(617) on" 
$node_(618) set X_ 2395 
$node_(618) set Y_ 711 
$node_(618) set Z_ 0.0 
$ns at 0.0 "$node_(618) off" 
$ns at 600.0 "$node_(618) on" 
$node_(619) set X_ 2317 
$node_(619) set Y_ 137 
$node_(619) set Z_ 0.0 
$ns at 0.0 "$node_(619) off" 
$ns at 600.0 "$node_(619) on" 
$node_(620) set X_ 1914 
$node_(620) set Y_ 168 
$node_(620) set Z_ 0.0 
$ns at 0.0 "$node_(620) off" 
$ns at 600.0 "$node_(620) on" 
$node_(621) set X_ 2837 
$node_(621) set Y_ 961 
$node_(621) set Z_ 0.0 
$ns at 0.0 "$node_(621) off" 
$ns at 600.0 "$node_(621) on" 
$node_(622) set X_ 244 
$node_(622) set Y_ 883 
$node_(622) set Z_ 0.0 
$ns at 0.0 "$node_(622) off" 
$ns at 600.0 "$node_(622) on" 
$node_(623) set X_ 1182 
$node_(623) set Y_ 696 
$node_(623) set Z_ 0.0 
$ns at 0.0 "$node_(623) off" 
$ns at 600.0 "$node_(623) on" 
$node_(624) set X_ 833 
$node_(624) set Y_ 578 
$node_(624) set Z_ 0.0 
$ns at 0.0 "$node_(624) off" 
$ns at 600.0 "$node_(624) on" 
$node_(625) set X_ 557 
$node_(625) set Y_ 497 
$node_(625) set Z_ 0.0 
$ns at 0.0 "$node_(625) off" 
$ns at 600.0 "$node_(625) on" 
$node_(626) set X_ 807 
$node_(626) set Y_ 530 
$node_(626) set Z_ 0.0 
$ns at 0.0 "$node_(626) off" 
$ns at 600.0 "$node_(626) on" 
$node_(627) set X_ 2134 
$node_(627) set Y_ 995 
$node_(627) set Z_ 0.0 
$ns at 0.0 "$node_(627) off" 
$ns at 600.0 "$node_(627) on" 
$node_(628) set X_ 1643 
$node_(628) set Y_ 12 
$node_(628) set Z_ 0.0 
$ns at 0.0 "$node_(628) off" 
$ns at 600.0 "$node_(628) on" 
$node_(629) set X_ 1958 
$node_(629) set Y_ 592 
$node_(629) set Z_ 0.0 
$ns at 0.0 "$node_(629) off" 
$ns at 600.0 "$node_(629) on" 
$node_(630) set X_ 2977 
$node_(630) set Y_ 677 
$node_(630) set Z_ 0.0 
$ns at 0.0 "$node_(630) off" 
$ns at 600.0 "$node_(630) on" 
$node_(631) set X_ 422 
$node_(631) set Y_ 481 
$node_(631) set Z_ 0.0 
$ns at 0.0 "$node_(631) off" 
$ns at 600.0 "$node_(631) on" 
$node_(632) set X_ 1347 
$node_(632) set Y_ 31 
$node_(632) set Z_ 0.0 
$ns at 0.0 "$node_(632) off" 
$ns at 600.0 "$node_(632) on" 
$node_(633) set X_ 875 
$node_(633) set Y_ 34 
$node_(633) set Z_ 0.0 
$ns at 0.0 "$node_(633) off" 
$ns at 600.0 "$node_(633) on" 
$node_(634) set X_ 343 
$node_(634) set Y_ 180 
$node_(634) set Z_ 0.0 
$ns at 0.0 "$node_(634) off" 
$ns at 600.0 "$node_(634) on" 
$node_(635) set X_ 2684 
$node_(635) set Y_ 50 
$node_(635) set Z_ 0.0 
$ns at 0.0 "$node_(635) off" 
$ns at 600.0 "$node_(635) on" 
$node_(636) set X_ 1205 
$node_(636) set Y_ 26 
$node_(636) set Z_ 0.0 
$ns at 0.0 "$node_(636) off" 
$ns at 600.0 "$node_(636) on" 
$node_(637) set X_ 2250 
$node_(637) set Y_ 676 
$node_(637) set Z_ 0.0 
$ns at 0.0 "$node_(637) off" 
$ns at 600.0 "$node_(637) on" 
$node_(638) set X_ 434 
$node_(638) set Y_ 962 
$node_(638) set Z_ 0.0 
$ns at 0.0 "$node_(638) off" 
$ns at 600.0 "$node_(638) on" 
$node_(639) set X_ 152 
$node_(639) set Y_ 528 
$node_(639) set Z_ 0.0 
$ns at 0.0 "$node_(639) off" 
$ns at 600.0 "$node_(639) on" 
$node_(640) set X_ 2561 
$node_(640) set Y_ 909 
$node_(640) set Z_ 0.0 
$ns at 0.0 "$node_(640) off" 
$ns at 600.0 "$node_(640) on" 
$node_(641) set X_ 713 
$node_(641) set Y_ 633 
$node_(641) set Z_ 0.0 
$ns at 0.0 "$node_(641) off" 
$ns at 600.0 "$node_(641) on" 
$node_(642) set X_ 650 
$node_(642) set Y_ 213 
$node_(642) set Z_ 0.0 
$ns at 0.0 "$node_(642) off" 
$ns at 600.0 "$node_(642) on" 
$node_(643) set X_ 2886 
$node_(643) set Y_ 354 
$node_(643) set Z_ 0.0 
$ns at 0.0 "$node_(643) off" 
$ns at 600.0 "$node_(643) on" 
$node_(644) set X_ 622 
$node_(644) set Y_ 546 
$node_(644) set Z_ 0.0 
$ns at 0.0 "$node_(644) off" 
$ns at 600.0 "$node_(644) on" 
$node_(645) set X_ 440 
$node_(645) set Y_ 368 
$node_(645) set Z_ 0.0 
$ns at 0.0 "$node_(645) off" 
$ns at 600.0 "$node_(645) on" 
$node_(646) set X_ 2873 
$node_(646) set Y_ 428 
$node_(646) set Z_ 0.0 
$ns at 0.0 "$node_(646) off" 
$ns at 600.0 "$node_(646) on" 
$node_(647) set X_ 1947 
$node_(647) set Y_ 129 
$node_(647) set Z_ 0.0 
$ns at 0.0 "$node_(647) off" 
$ns at 600.0 "$node_(647) on" 
$node_(648) set X_ 88 
$node_(648) set Y_ 426 
$node_(648) set Z_ 0.0 
$ns at 0.0 "$node_(648) off" 
$ns at 600.0 "$node_(648) on" 
$node_(649) set X_ 2079 
$node_(649) set Y_ 942 
$node_(649) set Z_ 0.0 
$ns at 0.0 "$node_(649) off" 
$ns at 600.0 "$node_(649) on" 
$node_(650) set X_ 2506 
$node_(650) set Y_ 391 
$node_(650) set Z_ 0.0 
$ns at 0.0 "$node_(650) off" 
$ns at 600.0 "$node_(650) on" 
$node_(651) set X_ 220 
$node_(651) set Y_ 968 
$node_(651) set Z_ 0.0 
$ns at 0.0 "$node_(651) off" 
$ns at 600.0 "$node_(651) on" 
$node_(652) set X_ 2222 
$node_(652) set Y_ 305 
$node_(652) set Z_ 0.0 
$ns at 0.0 "$node_(652) off" 
$ns at 600.0 "$node_(652) on" 
$node_(653) set X_ 313 
$node_(653) set Y_ 999 
$node_(653) set Z_ 0.0 
$ns at 0.0 "$node_(653) off" 
$ns at 600.0 "$node_(653) on" 
$node_(654) set X_ 2427 
$node_(654) set Y_ 477 
$node_(654) set Z_ 0.0 
$ns at 0.0 "$node_(654) off" 
$ns at 600.0 "$node_(654) on" 
$node_(655) set X_ 1298 
$node_(655) set Y_ 814 
$node_(655) set Z_ 0.0 
$ns at 0.0 "$node_(655) off" 
$ns at 600.0 "$node_(655) on" 
$node_(656) set X_ 753 
$node_(656) set Y_ 812 
$node_(656) set Z_ 0.0 
$ns at 0.0 "$node_(656) off" 
$ns at 600.0 "$node_(656) on" 
$node_(657) set X_ 367 
$node_(657) set Y_ 284 
$node_(657) set Z_ 0.0 
$ns at 0.0 "$node_(657) off" 
$ns at 600.0 "$node_(657) on" 
$node_(658) set X_ 1122 
$node_(658) set Y_ 872 
$node_(658) set Z_ 0.0 
$ns at 0.0 "$node_(658) off" 
$ns at 600.0 "$node_(658) on" 
$node_(659) set X_ 2619 
$node_(659) set Y_ 168 
$node_(659) set Z_ 0.0 
$ns at 0.0 "$node_(659) off" 
$ns at 600.0 "$node_(659) on" 
$node_(660) set X_ 732 
$node_(660) set Y_ 254 
$node_(660) set Z_ 0.0 
$ns at 0.0 "$node_(660) off" 
$ns at 600.0 "$node_(660) on" 
$node_(661) set X_ 2511 
$node_(661) set Y_ 734 
$node_(661) set Z_ 0.0 
$ns at 0.0 "$node_(661) off" 
$ns at 600.0 "$node_(661) on" 
$node_(662) set X_ 971 
$node_(662) set Y_ 587 
$node_(662) set Z_ 0.0 
$ns at 0.0 "$node_(662) off" 
$ns at 600.0 "$node_(662) on" 
$node_(663) set X_ 795 
$node_(663) set Y_ 877 
$node_(663) set Z_ 0.0 
$ns at 0.0 "$node_(663) off" 
$ns at 600.0 "$node_(663) on" 
$node_(664) set X_ 198 
$node_(664) set Y_ 114 
$node_(664) set Z_ 0.0 
$ns at 0.0 "$node_(664) off" 
$ns at 600.0 "$node_(664) on" 
$node_(665) set X_ 384 
$node_(665) set Y_ 457 
$node_(665) set Z_ 0.0 
$ns at 0.0 "$node_(665) off" 
$ns at 600.0 "$node_(665) on" 
$node_(666) set X_ 2458 
$node_(666) set Y_ 369 
$node_(666) set Z_ 0.0 
$ns at 0.0 "$node_(666) off" 
$ns at 600.0 "$node_(666) on" 
$node_(667) set X_ 2813 
$node_(667) set Y_ 928 
$node_(667) set Z_ 0.0 
$ns at 0.0 "$node_(667) off" 
$ns at 600.0 "$node_(667) on" 
$node_(668) set X_ 1286 
$node_(668) set Y_ 970 
$node_(668) set Z_ 0.0 
$ns at 0.0 "$node_(668) off" 
$ns at 600.0 "$node_(668) on" 
$node_(669) set X_ 673 
$node_(669) set Y_ 139 
$node_(669) set Z_ 0.0 
$ns at 0.0 "$node_(669) off" 
$ns at 600.0 "$node_(669) on" 
$node_(670) set X_ 1773 
$node_(670) set Y_ 881 
$node_(670) set Z_ 0.0 
$ns at 0.0 "$node_(670) off" 
$ns at 600.0 "$node_(670) on" 
$node_(671) set X_ 1527 
$node_(671) set Y_ 426 
$node_(671) set Z_ 0.0 
$ns at 0.0 "$node_(671) off" 
$ns at 600.0 "$node_(671) on" 
$node_(672) set X_ 1151 
$node_(672) set Y_ 835 
$node_(672) set Z_ 0.0 
$ns at 0.0 "$node_(672) off" 
$ns at 600.0 "$node_(672) on" 
$node_(673) set X_ 479 
$node_(673) set Y_ 683 
$node_(673) set Z_ 0.0 
$ns at 0.0 "$node_(673) off" 
$ns at 600.0 "$node_(673) on" 
$node_(674) set X_ 1078 
$node_(674) set Y_ 756 
$node_(674) set Z_ 0.0 
$ns at 0.0 "$node_(674) off" 
$ns at 600.0 "$node_(674) on" 
$node_(675) set X_ 655 
$node_(675) set Y_ 159 
$node_(675) set Z_ 0.0 
$ns at 0.0 "$node_(675) off" 
$ns at 600.0 "$node_(675) on" 
$node_(676) set X_ 820 
$node_(676) set Y_ 146 
$node_(676) set Z_ 0.0 
$ns at 0.0 "$node_(676) off" 
$ns at 600.0 "$node_(676) on" 
$node_(677) set X_ 417 
$node_(677) set Y_ 134 
$node_(677) set Z_ 0.0 
$ns at 0.0 "$node_(677) off" 
$ns at 600.0 "$node_(677) on" 
$node_(678) set X_ 2417 
$node_(678) set Y_ 398 
$node_(678) set Z_ 0.0 
$ns at 0.0 "$node_(678) off" 
$ns at 600.0 "$node_(678) on" 
$node_(679) set X_ 1187 
$node_(679) set Y_ 457 
$node_(679) set Z_ 0.0 
$ns at 0.0 "$node_(679) off" 
$ns at 600.0 "$node_(679) on" 
$node_(680) set X_ 1844 
$node_(680) set Y_ 899 
$node_(680) set Z_ 0.0 
$ns at 0.0 "$node_(680) off" 
$ns at 600.0 "$node_(680) on" 
$node_(681) set X_ 254 
$node_(681) set Y_ 192 
$node_(681) set Z_ 0.0 
$ns at 0.0 "$node_(681) off" 
$ns at 600.0 "$node_(681) on" 
$node_(682) set X_ 2021 
$node_(682) set Y_ 632 
$node_(682) set Z_ 0.0 
$ns at 0.0 "$node_(682) off" 
$ns at 600.0 "$node_(682) on" 
$node_(683) set X_ 2899 
$node_(683) set Y_ 237 
$node_(683) set Z_ 0.0 
$ns at 0.0 "$node_(683) off" 
$ns at 600.0 "$node_(683) on" 
$node_(684) set X_ 383 
$node_(684) set Y_ 661 
$node_(684) set Z_ 0.0 
$ns at 0.0 "$node_(684) off" 
$ns at 600.0 "$node_(684) on" 
$node_(685) set X_ 2659 
$node_(685) set Y_ 847 
$node_(685) set Z_ 0.0 
$ns at 0.0 "$node_(685) off" 
$ns at 600.0 "$node_(685) on" 
$node_(686) set X_ 2506 
$node_(686) set Y_ 577 
$node_(686) set Z_ 0.0 
$ns at 0.0 "$node_(686) off" 
$ns at 600.0 "$node_(686) on" 
$node_(687) set X_ 408 
$node_(687) set Y_ 444 
$node_(687) set Z_ 0.0 
$ns at 0.0 "$node_(687) off" 
$ns at 600.0 "$node_(687) on" 
$node_(688) set X_ 1077 
$node_(688) set Y_ 452 
$node_(688) set Z_ 0.0 
$ns at 0.0 "$node_(688) off" 
$ns at 600.0 "$node_(688) on" 
$node_(689) set X_ 363 
$node_(689) set Y_ 966 
$node_(689) set Z_ 0.0 
$ns at 0.0 "$node_(689) off" 
$ns at 600.0 "$node_(689) on" 
$node_(690) set X_ 1207 
$node_(690) set Y_ 347 
$node_(690) set Z_ 0.0 
$ns at 0.0 "$node_(690) off" 
$ns at 600.0 "$node_(690) on" 
$node_(691) set X_ 1948 
$node_(691) set Y_ 282 
$node_(691) set Z_ 0.0 
$ns at 0.0 "$node_(691) off" 
$ns at 600.0 "$node_(691) on" 
$node_(692) set X_ 1841 
$node_(692) set Y_ 732 
$node_(692) set Z_ 0.0 
$ns at 0.0 "$node_(692) off" 
$ns at 600.0 "$node_(692) on" 
$node_(693) set X_ 777 
$node_(693) set Y_ 855 
$node_(693) set Z_ 0.0 
$ns at 0.0 "$node_(693) off" 
$ns at 600.0 "$node_(693) on" 
$node_(694) set X_ 644 
$node_(694) set Y_ 446 
$node_(694) set Z_ 0.0 
$ns at 0.0 "$node_(694) off" 
$ns at 600.0 "$node_(694) on" 
$node_(695) set X_ 799 
$node_(695) set Y_ 942 
$node_(695) set Z_ 0.0 
$ns at 0.0 "$node_(695) off" 
$ns at 600.0 "$node_(695) on" 
$node_(696) set X_ 442 
$node_(696) set Y_ 988 
$node_(696) set Z_ 0.0 
$ns at 0.0 "$node_(696) off" 
$ns at 600.0 "$node_(696) on" 
$node_(697) set X_ 1910 
$node_(697) set Y_ 112 
$node_(697) set Z_ 0.0 
$ns at 0.0 "$node_(697) off" 
$ns at 600.0 "$node_(697) on" 
$node_(698) set X_ 869 
$node_(698) set Y_ 979 
$node_(698) set Z_ 0.0 
$ns at 0.0 "$node_(698) off" 
$ns at 600.0 "$node_(698) on" 
$node_(699) set X_ 1063 
$node_(699) set Y_ 719 
$node_(699) set Z_ 0.0 
$ns at 0.0 "$node_(699) off" 
$ns at 600.0 "$node_(699) on" 
$node_(700) set X_ 2488 
$node_(700) set Y_ 648 
$node_(700) set Z_ 0.0 
$ns at 0.0 "$node_(700) off" 
$ns at 700.0 "$node_(700) on" 
$node_(701) set X_ 2104 
$node_(701) set Y_ 324 
$node_(701) set Z_ 0.0 
$ns at 0.0 "$node_(701) off" 
$ns at 700.0 "$node_(701) on" 
$node_(702) set X_ 189 
$node_(702) set Y_ 19 
$node_(702) set Z_ 0.0 
$ns at 0.0 "$node_(702) off" 
$ns at 700.0 "$node_(702) on" 
$node_(703) set X_ 2204 
$node_(703) set Y_ 724 
$node_(703) set Z_ 0.0 
$ns at 0.0 "$node_(703) off" 
$ns at 700.0 "$node_(703) on" 
$node_(704) set X_ 2197 
$node_(704) set Y_ 319 
$node_(704) set Z_ 0.0 
$ns at 0.0 "$node_(704) off" 
$ns at 700.0 "$node_(704) on" 
$node_(705) set X_ 928 
$node_(705) set Y_ 389 
$node_(705) set Z_ 0.0 
$ns at 0.0 "$node_(705) off" 
$ns at 700.0 "$node_(705) on" 
$node_(706) set X_ 1510 
$node_(706) set Y_ 775 
$node_(706) set Z_ 0.0 
$ns at 0.0 "$node_(706) off" 
$ns at 700.0 "$node_(706) on" 
$node_(707) set X_ 546 
$node_(707) set Y_ 601 
$node_(707) set Z_ 0.0 
$ns at 0.0 "$node_(707) off" 
$ns at 700.0 "$node_(707) on" 
$node_(708) set X_ 1060 
$node_(708) set Y_ 589 
$node_(708) set Z_ 0.0 
$ns at 0.0 "$node_(708) off" 
$ns at 700.0 "$node_(708) on" 
$node_(709) set X_ 273 
$node_(709) set Y_ 546 
$node_(709) set Z_ 0.0 
$ns at 0.0 "$node_(709) off" 
$ns at 700.0 "$node_(709) on" 
$node_(710) set X_ 1294 
$node_(710) set Y_ 395 
$node_(710) set Z_ 0.0 
$ns at 0.0 "$node_(710) off" 
$ns at 700.0 "$node_(710) on" 
$node_(711) set X_ 672 
$node_(711) set Y_ 924 
$node_(711) set Z_ 0.0 
$ns at 0.0 "$node_(711) off" 
$ns at 700.0 "$node_(711) on" 
$node_(712) set X_ 1289 
$node_(712) set Y_ 868 
$node_(712) set Z_ 0.0 
$ns at 0.0 "$node_(712) off" 
$ns at 700.0 "$node_(712) on" 
$node_(713) set X_ 454 
$node_(713) set Y_ 378 
$node_(713) set Z_ 0.0 
$ns at 0.0 "$node_(713) off" 
$ns at 700.0 "$node_(713) on" 
$node_(714) set X_ 1889 
$node_(714) set Y_ 539 
$node_(714) set Z_ 0.0 
$ns at 0.0 "$node_(714) off" 
$ns at 700.0 "$node_(714) on" 
$node_(715) set X_ 376 
$node_(715) set Y_ 209 
$node_(715) set Z_ 0.0 
$ns at 0.0 "$node_(715) off" 
$ns at 700.0 "$node_(715) on" 
$node_(716) set X_ 1645 
$node_(716) set Y_ 26 
$node_(716) set Z_ 0.0 
$ns at 0.0 "$node_(716) off" 
$ns at 700.0 "$node_(716) on" 
$node_(717) set X_ 1896 
$node_(717) set Y_ 368 
$node_(717) set Z_ 0.0 
$ns at 0.0 "$node_(717) off" 
$ns at 700.0 "$node_(717) on" 
$node_(718) set X_ 1711 
$node_(718) set Y_ 72 
$node_(718) set Z_ 0.0 
$ns at 0.0 "$node_(718) off" 
$ns at 700.0 "$node_(718) on" 
$node_(719) set X_ 646 
$node_(719) set Y_ 706 
$node_(719) set Z_ 0.0 
$ns at 0.0 "$node_(719) off" 
$ns at 700.0 "$node_(719) on" 
$node_(720) set X_ 37 
$node_(720) set Y_ 795 
$node_(720) set Z_ 0.0 
$ns at 0.0 "$node_(720) off" 
$ns at 700.0 "$node_(720) on" 
$node_(721) set X_ 2687 
$node_(721) set Y_ 792 
$node_(721) set Z_ 0.0 
$ns at 0.0 "$node_(721) off" 
$ns at 700.0 "$node_(721) on" 
$node_(722) set X_ 2535 
$node_(722) set Y_ 490 
$node_(722) set Z_ 0.0 
$ns at 0.0 "$node_(722) off" 
$ns at 700.0 "$node_(722) on" 
$node_(723) set X_ 2817 
$node_(723) set Y_ 411 
$node_(723) set Z_ 0.0 
$ns at 0.0 "$node_(723) off" 
$ns at 700.0 "$node_(723) on" 
$node_(724) set X_ 2005 
$node_(724) set Y_ 195 
$node_(724) set Z_ 0.0 
$ns at 0.0 "$node_(724) off" 
$ns at 700.0 "$node_(724) on" 
$node_(725) set X_ 1081 
$node_(725) set Y_ 9 
$node_(725) set Z_ 0.0 
$ns at 0.0 "$node_(725) off" 
$ns at 700.0 "$node_(725) on" 
$node_(726) set X_ 1887 
$node_(726) set Y_ 961 
$node_(726) set Z_ 0.0 
$ns at 0.0 "$node_(726) off" 
$ns at 700.0 "$node_(726) on" 
$node_(727) set X_ 864 
$node_(727) set Y_ 952 
$node_(727) set Z_ 0.0 
$ns at 0.0 "$node_(727) off" 
$ns at 700.0 "$node_(727) on" 
$node_(728) set X_ 1958 
$node_(728) set Y_ 455 
$node_(728) set Z_ 0.0 
$ns at 0.0 "$node_(728) off" 
$ns at 700.0 "$node_(728) on" 
$node_(729) set X_ 743 
$node_(729) set Y_ 437 
$node_(729) set Z_ 0.0 
$ns at 0.0 "$node_(729) off" 
$ns at 700.0 "$node_(729) on" 
$node_(730) set X_ 2287 
$node_(730) set Y_ 64 
$node_(730) set Z_ 0.0 
$ns at 0.0 "$node_(730) off" 
$ns at 700.0 "$node_(730) on" 
$node_(731) set X_ 1490 
$node_(731) set Y_ 302 
$node_(731) set Z_ 0.0 
$ns at 0.0 "$node_(731) off" 
$ns at 700.0 "$node_(731) on" 
$node_(732) set X_ 791 
$node_(732) set Y_ 170 
$node_(732) set Z_ 0.0 
$ns at 0.0 "$node_(732) off" 
$ns at 700.0 "$node_(732) on" 
$node_(733) set X_ 2296 
$node_(733) set Y_ 784 
$node_(733) set Z_ 0.0 
$ns at 0.0 "$node_(733) off" 
$ns at 700.0 "$node_(733) on" 
$node_(734) set X_ 829 
$node_(734) set Y_ 615 
$node_(734) set Z_ 0.0 
$ns at 0.0 "$node_(734) off" 
$ns at 700.0 "$node_(734) on" 
$node_(735) set X_ 471 
$node_(735) set Y_ 469 
$node_(735) set Z_ 0.0 
$ns at 0.0 "$node_(735) off" 
$ns at 700.0 "$node_(735) on" 
$node_(736) set X_ 1251 
$node_(736) set Y_ 695 
$node_(736) set Z_ 0.0 
$ns at 0.0 "$node_(736) off" 
$ns at 700.0 "$node_(736) on" 
$node_(737) set X_ 1496 
$node_(737) set Y_ 313 
$node_(737) set Z_ 0.0 
$ns at 0.0 "$node_(737) off" 
$ns at 700.0 "$node_(737) on" 
$node_(738) set X_ 1361 
$node_(738) set Y_ 182 
$node_(738) set Z_ 0.0 
$ns at 0.0 "$node_(738) off" 
$ns at 700.0 "$node_(738) on" 
$node_(739) set X_ 409 
$node_(739) set Y_ 608 
$node_(739) set Z_ 0.0 
$ns at 0.0 "$node_(739) off" 
$ns at 700.0 "$node_(739) on" 
$node_(740) set X_ 1168 
$node_(740) set Y_ 998 
$node_(740) set Z_ 0.0 
$ns at 0.0 "$node_(740) off" 
$ns at 700.0 "$node_(740) on" 
$node_(741) set X_ 64 
$node_(741) set Y_ 214 
$node_(741) set Z_ 0.0 
$ns at 0.0 "$node_(741) off" 
$ns at 700.0 "$node_(741) on" 
$node_(742) set X_ 2245 
$node_(742) set Y_ 152 
$node_(742) set Z_ 0.0 
$ns at 0.0 "$node_(742) off" 
$ns at 700.0 "$node_(742) on" 
$node_(743) set X_ 2857 
$node_(743) set Y_ 216 
$node_(743) set Z_ 0.0 
$ns at 0.0 "$node_(743) off" 
$ns at 700.0 "$node_(743) on" 
$node_(744) set X_ 2433 
$node_(744) set Y_ 472 
$node_(744) set Z_ 0.0 
$ns at 0.0 "$node_(744) off" 
$ns at 700.0 "$node_(744) on" 
$node_(745) set X_ 11 
$node_(745) set Y_ 363 
$node_(745) set Z_ 0.0 
$ns at 0.0 "$node_(745) off" 
$ns at 700.0 "$node_(745) on" 
$node_(746) set X_ 449 
$node_(746) set Y_ 471 
$node_(746) set Z_ 0.0 
$ns at 0.0 "$node_(746) off" 
$ns at 700.0 "$node_(746) on" 
$node_(747) set X_ 1481 
$node_(747) set Y_ 354 
$node_(747) set Z_ 0.0 
$ns at 0.0 "$node_(747) off" 
$ns at 700.0 "$node_(747) on" 
$node_(748) set X_ 335 
$node_(748) set Y_ 433 
$node_(748) set Z_ 0.0 
$ns at 0.0 "$node_(748) off" 
$ns at 700.0 "$node_(748) on" 
$node_(749) set X_ 1001 
$node_(749) set Y_ 33 
$node_(749) set Z_ 0.0 
$ns at 0.0 "$node_(749) off" 
$ns at 700.0 "$node_(749) on" 
$node_(750) set X_ 2470 
$node_(750) set Y_ 402 
$node_(750) set Z_ 0.0 
$ns at 0.0 "$node_(750) off" 
$ns at 700.0 "$node_(750) on" 
$node_(751) set X_ 697 
$node_(751) set Y_ 47 
$node_(751) set Z_ 0.0 
$ns at 0.0 "$node_(751) off" 
$ns at 700.0 "$node_(751) on" 
$node_(752) set X_ 2628 
$node_(752) set Y_ 310 
$node_(752) set Z_ 0.0 
$ns at 0.0 "$node_(752) off" 
$ns at 700.0 "$node_(752) on" 
$node_(753) set X_ 61 
$node_(753) set Y_ 359 
$node_(753) set Z_ 0.0 
$ns at 0.0 "$node_(753) off" 
$ns at 700.0 "$node_(753) on" 
$node_(754) set X_ 334 
$node_(754) set Y_ 944 
$node_(754) set Z_ 0.0 
$ns at 0.0 "$node_(754) off" 
$ns at 700.0 "$node_(754) on" 
$node_(755) set X_ 971 
$node_(755) set Y_ 314 
$node_(755) set Z_ 0.0 
$ns at 0.0 "$node_(755) off" 
$ns at 700.0 "$node_(755) on" 
$node_(756) set X_ 2456 
$node_(756) set Y_ 742 
$node_(756) set Z_ 0.0 
$ns at 0.0 "$node_(756) off" 
$ns at 700.0 "$node_(756) on" 
$node_(757) set X_ 2701 
$node_(757) set Y_ 589 
$node_(757) set Z_ 0.0 
$ns at 0.0 "$node_(757) off" 
$ns at 700.0 "$node_(757) on" 
$node_(758) set X_ 660 
$node_(758) set Y_ 743 
$node_(758) set Z_ 0.0 
$ns at 0.0 "$node_(758) off" 
$ns at 700.0 "$node_(758) on" 
$node_(759) set X_ 713 
$node_(759) set Y_ 481 
$node_(759) set Z_ 0.0 
$ns at 0.0 "$node_(759) off" 
$ns at 700.0 "$node_(759) on" 
$node_(760) set X_ 1003 
$node_(760) set Y_ 91 
$node_(760) set Z_ 0.0 
$ns at 0.0 "$node_(760) off" 
$ns at 700.0 "$node_(760) on" 
$node_(761) set X_ 1245 
$node_(761) set Y_ 446 
$node_(761) set Z_ 0.0 
$ns at 0.0 "$node_(761) off" 
$ns at 700.0 "$node_(761) on" 
$node_(762) set X_ 548 
$node_(762) set Y_ 636 
$node_(762) set Z_ 0.0 
$ns at 0.0 "$node_(762) off" 
$ns at 700.0 "$node_(762) on" 
$node_(763) set X_ 2438 
$node_(763) set Y_ 720 
$node_(763) set Z_ 0.0 
$ns at 0.0 "$node_(763) off" 
$ns at 700.0 "$node_(763) on" 
$node_(764) set X_ 2485 
$node_(764) set Y_ 97 
$node_(764) set Z_ 0.0 
$ns at 0.0 "$node_(764) off" 
$ns at 700.0 "$node_(764) on" 
$node_(765) set X_ 2948 
$node_(765) set Y_ 138 
$node_(765) set Z_ 0.0 
$ns at 0.0 "$node_(765) off" 
$ns at 700.0 "$node_(765) on" 
$node_(766) set X_ 2772 
$node_(766) set Y_ 163 
$node_(766) set Z_ 0.0 
$ns at 0.0 "$node_(766) off" 
$ns at 700.0 "$node_(766) on" 
$node_(767) set X_ 2653 
$node_(767) set Y_ 983 
$node_(767) set Z_ 0.0 
$ns at 0.0 "$node_(767) off" 
$ns at 700.0 "$node_(767) on" 
$node_(768) set X_ 863 
$node_(768) set Y_ 669 
$node_(768) set Z_ 0.0 
$ns at 0.0 "$node_(768) off" 
$ns at 700.0 "$node_(768) on" 
$node_(769) set X_ 2183 
$node_(769) set Y_ 816 
$node_(769) set Z_ 0.0 
$ns at 0.0 "$node_(769) off" 
$ns at 700.0 "$node_(769) on" 
$node_(770) set X_ 1544 
$node_(770) set Y_ 697 
$node_(770) set Z_ 0.0 
$ns at 0.0 "$node_(770) off" 
$ns at 700.0 "$node_(770) on" 
$node_(771) set X_ 2623 
$node_(771) set Y_ 747 
$node_(771) set Z_ 0.0 
$ns at 0.0 "$node_(771) off" 
$ns at 700.0 "$node_(771) on" 
$node_(772) set X_ 2397 
$node_(772) set Y_ 46 
$node_(772) set Z_ 0.0 
$ns at 0.0 "$node_(772) off" 
$ns at 700.0 "$node_(772) on" 
$node_(773) set X_ 1780 
$node_(773) set Y_ 539 
$node_(773) set Z_ 0.0 
$ns at 0.0 "$node_(773) off" 
$ns at 700.0 "$node_(773) on" 
$node_(774) set X_ 2816 
$node_(774) set Y_ 11 
$node_(774) set Z_ 0.0 
$ns at 0.0 "$node_(774) off" 
$ns at 700.0 "$node_(774) on" 
$node_(775) set X_ 2977 
$node_(775) set Y_ 271 
$node_(775) set Z_ 0.0 
$ns at 0.0 "$node_(775) off" 
$ns at 700.0 "$node_(775) on" 
$node_(776) set X_ 2897 
$node_(776) set Y_ 824 
$node_(776) set Z_ 0.0 
$ns at 0.0 "$node_(776) off" 
$ns at 700.0 "$node_(776) on" 
$node_(777) set X_ 311 
$node_(777) set Y_ 37 
$node_(777) set Z_ 0.0 
$ns at 0.0 "$node_(777) off" 
$ns at 700.0 "$node_(777) on" 
$node_(778) set X_ 2902 
$node_(778) set Y_ 441 
$node_(778) set Z_ 0.0 
$ns at 0.0 "$node_(778) off" 
$ns at 700.0 "$node_(778) on" 
$node_(779) set X_ 2814 
$node_(779) set Y_ 262 
$node_(779) set Z_ 0.0 
$ns at 0.0 "$node_(779) off" 
$ns at 700.0 "$node_(779) on" 
$node_(780) set X_ 1324 
$node_(780) set Y_ 572 
$node_(780) set Z_ 0.0 
$ns at 0.0 "$node_(780) off" 
$ns at 700.0 "$node_(780) on" 
$node_(781) set X_ 884 
$node_(781) set Y_ 834 
$node_(781) set Z_ 0.0 
$ns at 0.0 "$node_(781) off" 
$ns at 700.0 "$node_(781) on" 
$node_(782) set X_ 2884 
$node_(782) set Y_ 967 
$node_(782) set Z_ 0.0 
$ns at 0.0 "$node_(782) off" 
$ns at 700.0 "$node_(782) on" 
$node_(783) set X_ 764 
$node_(783) set Y_ 142 
$node_(783) set Z_ 0.0 
$ns at 0.0 "$node_(783) off" 
$ns at 700.0 "$node_(783) on" 
$node_(784) set X_ 71 
$node_(784) set Y_ 46 
$node_(784) set Z_ 0.0 
$ns at 0.0 "$node_(784) off" 
$ns at 700.0 "$node_(784) on" 
$node_(785) set X_ 1758 
$node_(785) set Y_ 519 
$node_(785) set Z_ 0.0 
$ns at 0.0 "$node_(785) off" 
$ns at 700.0 "$node_(785) on" 
$node_(786) set X_ 2063 
$node_(786) set Y_ 856 
$node_(786) set Z_ 0.0 
$ns at 0.0 "$node_(786) off" 
$ns at 700.0 "$node_(786) on" 
$node_(787) set X_ 2170 
$node_(787) set Y_ 345 
$node_(787) set Z_ 0.0 
$ns at 0.0 "$node_(787) off" 
$ns at 700.0 "$node_(787) on" 
$node_(788) set X_ 87 
$node_(788) set Y_ 225 
$node_(788) set Z_ 0.0 
$ns at 0.0 "$node_(788) off" 
$ns at 700.0 "$node_(788) on" 
$node_(789) set X_ 1833 
$node_(789) set Y_ 230 
$node_(789) set Z_ 0.0 
$ns at 0.0 "$node_(789) off" 
$ns at 700.0 "$node_(789) on" 
$node_(790) set X_ 1460 
$node_(790) set Y_ 715 
$node_(790) set Z_ 0.0 
$ns at 0.0 "$node_(790) off" 
$ns at 700.0 "$node_(790) on" 
$node_(791) set X_ 1334 
$node_(791) set Y_ 308 
$node_(791) set Z_ 0.0 
$ns at 0.0 "$node_(791) off" 
$ns at 700.0 "$node_(791) on" 
$node_(792) set X_ 2680 
$node_(792) set Y_ 652 
$node_(792) set Z_ 0.0 
$ns at 0.0 "$node_(792) off" 
$ns at 700.0 "$node_(792) on" 
$node_(793) set X_ 822 
$node_(793) set Y_ 634 
$node_(793) set Z_ 0.0 
$ns at 0.0 "$node_(793) off" 
$ns at 700.0 "$node_(793) on" 
$node_(794) set X_ 1085 
$node_(794) set Y_ 66 
$node_(794) set Z_ 0.0 
$ns at 0.0 "$node_(794) off" 
$ns at 700.0 "$node_(794) on" 
$node_(795) set X_ 1510 
$node_(795) set Y_ 85 
$node_(795) set Z_ 0.0 
$ns at 0.0 "$node_(795) off" 
$ns at 700.0 "$node_(795) on" 
$node_(796) set X_ 639 
$node_(796) set Y_ 846 
$node_(796) set Z_ 0.0 
$ns at 0.0 "$node_(796) off" 
$ns at 700.0 "$node_(796) on" 
$node_(797) set X_ 1669 
$node_(797) set Y_ 974 
$node_(797) set Z_ 0.0 
$ns at 0.0 "$node_(797) off" 
$ns at 700.0 "$node_(797) on" 
$node_(798) set X_ 2505 
$node_(798) set Y_ 821 
$node_(798) set Z_ 0.0 
$ns at 0.0 "$node_(798) off" 
$ns at 700.0 "$node_(798) on" 
$node_(799) set X_ 1077 
$node_(799) set Y_ 769 
$node_(799) set Z_ 0.0 
$ns at 0.0 "$node_(799) off" 
$ns at 700.0 "$node_(799) on" 

# Generation of movements
$ns at 0.0 "$node_(0) setdest 64770 23112 17.0" 
$ns at 194.41570958036652 "$node_(0) setdest 86298 11257 7.0" 
$ns at 233.88310240818947 "$node_(0) setdest 84914 16335 15.0" 
$ns at 356.37756966888276 "$node_(0) setdest 115200 20633 1.0" 
$ns at 388.2710327397889 "$node_(0) setdest 24355 26758 18.0" 
$ns at 459.02449198699 "$node_(0) setdest 55156 37586 18.0" 
$ns at 587.0345506998417 "$node_(0) setdest 193510 14508 16.0" 
$ns at 646.0805003172078 "$node_(0) setdest 14664 41318 10.0" 
$ns at 756.2009283928606 "$node_(0) setdest 25892 3127 17.0" 
$ns at 834.973553128642 "$node_(0) setdest 78511 26373 1.0" 
$ns at 868.5533217807815 "$node_(0) setdest 261724 58503 17.0" 
$ns at 0.0 "$node_(1) setdest 88129 16257 6.0" 
$ns at 49.65895051181399 "$node_(1) setdest 12944 15199 6.0" 
$ns at 132.71191944322254 "$node_(1) setdest 12453 15657 4.0" 
$ns at 182.12020930309114 "$node_(1) setdest 115175 4196 20.0" 
$ns at 363.1528082552839 "$node_(1) setdest 24317 51530 1.0" 
$ns at 397.38252047457024 "$node_(1) setdest 110837 35299 4.0" 
$ns at 445.42743434539716 "$node_(1) setdest 115335 25242 7.0" 
$ns at 499.1498659974925 "$node_(1) setdest 155031 67167 10.0" 
$ns at 543.967532908271 "$node_(1) setdest 199164 61707 11.0" 
$ns at 588.6796305020296 "$node_(1) setdest 166542 43171 12.0" 
$ns at 690.5470452094874 "$node_(1) setdest 201706 24562 2.0" 
$ns at 735.4073233245196 "$node_(1) setdest 102888 41164 14.0" 
$ns at 880.1159827032621 "$node_(1) setdest 20700 57086 1.0" 
$ns at 0.0 "$node_(2) setdest 43388 22128 18.0" 
$ns at 163.77830532850746 "$node_(2) setdest 4376 29001 18.0" 
$ns at 303.66507888358854 "$node_(2) setdest 32851 33403 6.0" 
$ns at 387.2914869211628 "$node_(2) setdest 39070 57213 20.0" 
$ns at 507.5278075911863 "$node_(2) setdest 27970 64376 19.0" 
$ns at 608.6969836142706 "$node_(2) setdest 116472 18412 10.0" 
$ns at 727.7274665379766 "$node_(2) setdest 27776 15750 14.0" 
$ns at 859.8614381984784 "$node_(2) setdest 99191 75507 19.0" 
$ns at 0.0 "$node_(3) setdest 73521 13337 5.0" 
$ns at 53.66227801820817 "$node_(3) setdest 13576 22656 3.0" 
$ns at 92.19114547403005 "$node_(3) setdest 83222 17858 5.0" 
$ns at 139.30992409347232 "$node_(3) setdest 81107 7973 15.0" 
$ns at 205.44316862842498 "$node_(3) setdest 65502 31736 12.0" 
$ns at 303.6914665973293 "$node_(3) setdest 21394 8542 1.0" 
$ns at 336.02456000307956 "$node_(3) setdest 46100 31156 4.0" 
$ns at 395.02504309393095 "$node_(3) setdest 185311 63057 8.0" 
$ns at 439.2423243302416 "$node_(3) setdest 66053 16523 7.0" 
$ns at 535.3090723125607 "$node_(3) setdest 118660 2473 1.0" 
$ns at 572.0391769959926 "$node_(3) setdest 62400 49871 10.0" 
$ns at 658.1236031131945 "$node_(3) setdest 72836 14925 20.0" 
$ns at 791.275568377216 "$node_(3) setdest 98056 60387 7.0" 
$ns at 855.0877975289457 "$node_(3) setdest 218643 16858 18.0" 
$ns at 895.738719950343 "$node_(3) setdest 101460 49198 16.0" 
$ns at 0.0 "$node_(4) setdest 69168 15544 10.0" 
$ns at 89.1906259585223 "$node_(4) setdest 94391 18761 8.0" 
$ns at 172.45701463481566 "$node_(4) setdest 14280 9542 3.0" 
$ns at 207.33216415289047 "$node_(4) setdest 128550 6731 18.0" 
$ns at 385.587466921849 "$node_(4) setdest 32051 18911 20.0" 
$ns at 520.6314518421048 "$node_(4) setdest 147727 68240 6.0" 
$ns at 562.877932045965 "$node_(4) setdest 158865 64372 19.0" 
$ns at 618.1521068320931 "$node_(4) setdest 161018 60301 7.0" 
$ns at 649.4388764343188 "$node_(4) setdest 212971 70450 5.0" 
$ns at 697.117419621281 "$node_(4) setdest 11451 12002 18.0" 
$ns at 875.5053071340221 "$node_(4) setdest 60475 63260 9.0" 
$ns at 0.0 "$node_(5) setdest 87893 21729 13.0" 
$ns at 80.84890696746984 "$node_(5) setdest 59303 17819 18.0" 
$ns at 145.01162445694692 "$node_(5) setdest 85110 9904 18.0" 
$ns at 300.00761116782223 "$node_(5) setdest 148799 12538 2.0" 
$ns at 338.9085176271875 "$node_(5) setdest 47310 4443 11.0" 
$ns at 434.2607328107184 "$node_(5) setdest 25728 39595 1.0" 
$ns at 473.23446598235256 "$node_(5) setdest 20583 53086 7.0" 
$ns at 572.8494149376775 "$node_(5) setdest 147443 57138 10.0" 
$ns at 636.4263233378927 "$node_(5) setdest 27237 17842 3.0" 
$ns at 682.5657248314975 "$node_(5) setdest 186490 40716 9.0" 
$ns at 783.2763798110952 "$node_(5) setdest 66213 37275 17.0" 
$ns at 835.8974262791728 "$node_(5) setdest 261894 64480 2.0" 
$ns at 870.0484929295026 "$node_(5) setdest 51502 14811 18.0" 
$ns at 0.0 "$node_(6) setdest 36912 21062 20.0" 
$ns at 194.93663834128824 "$node_(6) setdest 2395 16996 1.0" 
$ns at 226.00699790633934 "$node_(6) setdest 32256 20556 11.0" 
$ns at 311.65920564546633 "$node_(6) setdest 41871 24993 4.0" 
$ns at 374.912252949809 "$node_(6) setdest 53274 39851 20.0" 
$ns at 580.7721693022264 "$node_(6) setdest 120192 44468 19.0" 
$ns at 707.0224326754146 "$node_(6) setdest 63537 52984 20.0" 
$ns at 757.4331811991499 "$node_(6) setdest 225920 51016 4.0" 
$ns at 789.3094903388351 "$node_(6) setdest 116486 72508 11.0" 
$ns at 870.255601122207 "$node_(6) setdest 54569 34438 1.0" 
$ns at 0.0 "$node_(7) setdest 28391 12067 18.0" 
$ns at 73.88229643567672 "$node_(7) setdest 86511 9989 7.0" 
$ns at 150.02955266497958 "$node_(7) setdest 86433 14920 17.0" 
$ns at 267.05558891303275 "$node_(7) setdest 140213 31344 11.0" 
$ns at 346.53199743064164 "$node_(7) setdest 122221 17729 13.0" 
$ns at 477.45372392052593 "$node_(7) setdest 164514 61162 16.0" 
$ns at 570.6027166285946 "$node_(7) setdest 88528 73876 11.0" 
$ns at 674.9908543607976 "$node_(7) setdest 20160 1728 15.0" 
$ns at 735.9806790491123 "$node_(7) setdest 207765 2839 20.0" 
$ns at 792.4381311034767 "$node_(7) setdest 221796 76895 10.0" 
$ns at 823.3386238224936 "$node_(7) setdest 29603 62316 18.0" 
$ns at 0.0 "$node_(8) setdest 85614 26086 12.0" 
$ns at 70.39100358970269 "$node_(8) setdest 13269 15023 20.0" 
$ns at 218.68428426078327 "$node_(8) setdest 76899 4474 11.0" 
$ns at 318.0004696057855 "$node_(8) setdest 89010 38791 5.0" 
$ns at 394.1465165131157 "$node_(8) setdest 163520 13031 4.0" 
$ns at 425.21260792644966 "$node_(8) setdest 50157 56172 1.0" 
$ns at 458.3123636442566 "$node_(8) setdest 99676 22174 1.0" 
$ns at 493.26623161370344 "$node_(8) setdest 63823 57273 4.0" 
$ns at 554.8903953482005 "$node_(8) setdest 45238 58853 15.0" 
$ns at 678.0139928876742 "$node_(8) setdest 26152 53522 8.0" 
$ns at 757.534684395444 "$node_(8) setdest 13620 45414 17.0" 
$ns at 886.6611329616355 "$node_(8) setdest 141886 23498 18.0" 
$ns at 0.0 "$node_(9) setdest 52390 16983 2.0" 
$ns at 32.73630963245952 "$node_(9) setdest 36086 16627 10.0" 
$ns at 72.04671408676062 "$node_(9) setdest 81879 12761 10.0" 
$ns at 165.94864910190262 "$node_(9) setdest 121570 10577 5.0" 
$ns at 198.6665836783946 "$node_(9) setdest 103628 20416 1.0" 
$ns at 232.93700381514935 "$node_(9) setdest 108251 1480 19.0" 
$ns at 431.64633607765376 "$node_(9) setdest 133169 28575 14.0" 
$ns at 475.2365993177052 "$node_(9) setdest 128066 34490 6.0" 
$ns at 531.4604596088436 "$node_(9) setdest 42865 38823 18.0" 
$ns at 648.6160688827102 "$node_(9) setdest 102527 4434 9.0" 
$ns at 754.9076329338651 "$node_(9) setdest 173113 83278 13.0" 
$ns at 836.2175821574886 "$node_(9) setdest 176697 66498 4.0" 
$ns at 874.6823776530769 "$node_(9) setdest 18893 47791 7.0" 
$ns at 0.0 "$node_(10) setdest 67475 18274 4.0" 
$ns at 65.27264500076697 "$node_(10) setdest 37014 19852 9.0" 
$ns at 111.71495685085496 "$node_(10) setdest 26152 9247 16.0" 
$ns at 243.4077515817644 "$node_(10) setdest 55385 10263 20.0" 
$ns at 356.7324792168793 "$node_(10) setdest 117124 50021 7.0" 
$ns at 394.5416748160959 "$node_(10) setdest 74017 37841 6.0" 
$ns at 480.32225444170376 "$node_(10) setdest 117970 20043 8.0" 
$ns at 526.022105732273 "$node_(10) setdest 9687 20483 10.0" 
$ns at 631.2488595118818 "$node_(10) setdest 141806 15323 15.0" 
$ns at 704.1170147694646 "$node_(10) setdest 73253 42937 10.0" 
$ns at 776.2132172890928 "$node_(10) setdest 40280 20632 8.0" 
$ns at 854.1225509808264 "$node_(10) setdest 24654 69834 8.0" 
$ns at 0.0 "$node_(11) setdest 61229 4805 1.0" 
$ns at 39.66479425460264 "$node_(11) setdest 16542 2633 3.0" 
$ns at 89.22620935584371 "$node_(11) setdest 31917 7143 3.0" 
$ns at 142.4563307831318 "$node_(11) setdest 52863 2657 9.0" 
$ns at 234.6867474248782 "$node_(11) setdest 122392 16179 16.0" 
$ns at 422.0802469998968 "$node_(11) setdest 16689 4288 5.0" 
$ns at 482.91041857056894 "$node_(11) setdest 5826 25303 7.0" 
$ns at 541.3635946725426 "$node_(11) setdest 97040 44748 13.0" 
$ns at 698.2954620413427 "$node_(11) setdest 185668 71230 1.0" 
$ns at 734.8971015087344 "$node_(11) setdest 98946 30531 20.0" 
$ns at 862.6975138835526 "$node_(11) setdest 53655 75008 19.0" 
$ns at 0.0 "$node_(12) setdest 94501 31037 15.0" 
$ns at 168.69075602345933 "$node_(12) setdest 23810 39248 18.0" 
$ns at 253.62508435116428 "$node_(12) setdest 66844 37449 9.0" 
$ns at 346.74845939399654 "$node_(12) setdest 41358 18462 12.0" 
$ns at 417.6432866101468 "$node_(12) setdest 55664 44642 14.0" 
$ns at 586.9928862893883 "$node_(12) setdest 174961 23613 16.0" 
$ns at 693.5334985703455 "$node_(12) setdest 209097 24983 17.0" 
$ns at 794.1144466829045 "$node_(12) setdest 210317 1718 11.0" 
$ns at 0.0 "$node_(13) setdest 15678 20125 4.0" 
$ns at 51.69086911660364 "$node_(13) setdest 85752 29602 7.0" 
$ns at 118.27779989940524 "$node_(13) setdest 48981 12196 15.0" 
$ns at 281.38361207188507 "$node_(13) setdest 50770 43584 18.0" 
$ns at 436.7739691074727 "$node_(13) setdest 86149 58372 9.0" 
$ns at 472.55243753480613 "$node_(13) setdest 124599 21338 18.0" 
$ns at 658.6131051833951 "$node_(13) setdest 245717 36898 1.0" 
$ns at 690.9230240797252 "$node_(13) setdest 96725 23130 12.0" 
$ns at 791.6976172166691 "$node_(13) setdest 109806 38585 17.0" 
$ns at 838.8067142662311 "$node_(13) setdest 151220 36220 5.0" 
$ns at 898.7310510509473 "$node_(13) setdest 71494 25149 5.0" 
$ns at 0.0 "$node_(14) setdest 64161 29470 16.0" 
$ns at 164.51515537310706 "$node_(14) setdest 83085 43509 3.0" 
$ns at 202.66480727609672 "$node_(14) setdest 114879 41328 10.0" 
$ns at 313.0750956447931 "$node_(14) setdest 97257 6874 15.0" 
$ns at 431.7131471136169 "$node_(14) setdest 82710 60834 11.0" 
$ns at 550.515073039897 "$node_(14) setdest 231048 66974 4.0" 
$ns at 619.0104440657475 "$node_(14) setdest 206486 28870 5.0" 
$ns at 658.1078186122303 "$node_(14) setdest 70672 21810 18.0" 
$ns at 775.083319856482 "$node_(14) setdest 246917 33173 6.0" 
$ns at 836.3695433719229 "$node_(14) setdest 80285 28874 8.0" 
$ns at 878.533060825744 "$node_(14) setdest 213240 64000 19.0" 
$ns at 0.0 "$node_(15) setdest 49442 24894 6.0" 
$ns at 46.9116280348417 "$node_(15) setdest 21278 23750 11.0" 
$ns at 120.05199919962573 "$node_(15) setdest 70027 5938 14.0" 
$ns at 274.2971569634052 "$node_(15) setdest 66929 51633 10.0" 
$ns at 389.93722957931027 "$node_(15) setdest 76429 59949 8.0" 
$ns at 467.8482183675815 "$node_(15) setdest 9589 19193 7.0" 
$ns at 527.8230736497546 "$node_(15) setdest 18912 34003 4.0" 
$ns at 593.8698370425536 "$node_(15) setdest 97801 7750 3.0" 
$ns at 650.2496162161123 "$node_(15) setdest 193989 45041 9.0" 
$ns at 747.8783160344259 "$node_(15) setdest 218488 31381 18.0" 
$ns at 864.2682690937056 "$node_(15) setdest 238805 26266 8.0" 
$ns at 0.0 "$node_(16) setdest 21873 8760 12.0" 
$ns at 106.35657373611784 "$node_(16) setdest 36099 28453 19.0" 
$ns at 190.35162547962574 "$node_(16) setdest 12426 30518 18.0" 
$ns at 220.56453102075548 "$node_(16) setdest 23415 22760 2.0" 
$ns at 267.4066297822045 "$node_(16) setdest 155634 2805 6.0" 
$ns at 326.3946815549961 "$node_(16) setdest 135915 54405 6.0" 
$ns at 409.5721797126887 "$node_(16) setdest 104213 38086 8.0" 
$ns at 505.9932916908713 "$node_(16) setdest 55185 60379 17.0" 
$ns at 578.3087121478154 "$node_(16) setdest 20353 68967 3.0" 
$ns at 629.7376754019778 "$node_(16) setdest 189744 4408 19.0" 
$ns at 698.2637592266713 "$node_(16) setdest 248266 12480 19.0" 
$ns at 821.5057163721502 "$node_(16) setdest 22988 70239 1.0" 
$ns at 852.9159539880509 "$node_(16) setdest 118407 980 19.0" 
$ns at 894.4918909260936 "$node_(16) setdest 55190 30759 16.0" 
$ns at 0.0 "$node_(17) setdest 91436 14831 8.0" 
$ns at 70.9309562649805 "$node_(17) setdest 56941 22346 10.0" 
$ns at 101.83910038653063 "$node_(17) setdest 58091 6140 1.0" 
$ns at 136.4218276711719 "$node_(17) setdest 33835 14031 19.0" 
$ns at 255.45510048810195 "$node_(17) setdest 106046 31217 2.0" 
$ns at 290.7977945914527 "$node_(17) setdest 115482 952 19.0" 
$ns at 467.67078945310175 "$node_(17) setdest 156431 4143 2.0" 
$ns at 509.3256545301819 "$node_(17) setdest 61304 48406 4.0" 
$ns at 551.873194235521 "$node_(17) setdest 16147 59021 13.0" 
$ns at 690.5430760438887 "$node_(17) setdest 58420 41351 19.0" 
$ns at 798.7901928937324 "$node_(17) setdest 236001 25968 17.0" 
$ns at 0.0 "$node_(18) setdest 12618 3744 2.0" 
$ns at 40.984357425234236 "$node_(18) setdest 28905 9562 3.0" 
$ns at 82.3836461488818 "$node_(18) setdest 48462 15952 3.0" 
$ns at 134.52093050726347 "$node_(18) setdest 56672 10426 16.0" 
$ns at 169.83844081162547 "$node_(18) setdest 51501 26274 6.0" 
$ns at 204.61784082419922 "$node_(18) setdest 6333 33495 15.0" 
$ns at 316.0550868108903 "$node_(18) setdest 153021 30181 16.0" 
$ns at 476.6000430571177 "$node_(18) setdest 40474 1084 7.0" 
$ns at 508.3078905397013 "$node_(18) setdest 96818 26410 9.0" 
$ns at 576.0270172915787 "$node_(18) setdest 32908 40272 20.0" 
$ns at 679.6019101250519 "$node_(18) setdest 26185 54402 5.0" 
$ns at 735.9065141656802 "$node_(18) setdest 30539 57319 17.0" 
$ns at 856.6397248112614 "$node_(18) setdest 10935 83002 4.0" 
$ns at 0.0 "$node_(19) setdest 50023 5081 9.0" 
$ns at 51.14258651402646 "$node_(19) setdest 4746 1292 11.0" 
$ns at 166.09478354176827 "$node_(19) setdest 14871 10469 6.0" 
$ns at 252.02780032709134 "$node_(19) setdest 124675 10173 18.0" 
$ns at 455.35890959299775 "$node_(19) setdest 23464 57858 18.0" 
$ns at 542.5941930042422 "$node_(19) setdest 199887 51315 3.0" 
$ns at 597.6240819961861 "$node_(19) setdest 95435 48784 16.0" 
$ns at 741.909924804247 "$node_(19) setdest 155895 80269 1.0" 
$ns at 780.6567331052 "$node_(19) setdest 16905 37739 18.0" 
$ns at 821.6924569506342 "$node_(19) setdest 242577 30853 16.0" 
$ns at 0.0 "$node_(20) setdest 71486 12142 18.0" 
$ns at 105.86868132931588 "$node_(20) setdest 74508 28983 2.0" 
$ns at 148.4492013469273 "$node_(20) setdest 4238 2269 19.0" 
$ns at 211.80012611905914 "$node_(20) setdest 47373 39431 12.0" 
$ns at 305.59062686468786 "$node_(20) setdest 78184 26396 6.0" 
$ns at 355.73919282774466 "$node_(20) setdest 21777 40384 9.0" 
$ns at 410.5871052490211 "$node_(20) setdest 162074 8431 4.0" 
$ns at 466.7118160578269 "$node_(20) setdest 84602 49462 16.0" 
$ns at 625.0160095922038 "$node_(20) setdest 73908 20806 14.0" 
$ns at 716.9554801923755 "$node_(20) setdest 9425 21907 17.0" 
$ns at 803.4745372734066 "$node_(20) setdest 1053 48302 10.0" 
$ns at 863.8231548148625 "$node_(20) setdest 211830 36826 6.0" 
$ns at 0.0 "$node_(21) setdest 38001 25036 5.0" 
$ns at 38.10354806671081 "$node_(21) setdest 19679 6349 7.0" 
$ns at 118.61489944762354 "$node_(21) setdest 68399 25376 1.0" 
$ns at 151.69076854747772 "$node_(21) setdest 122139 3729 18.0" 
$ns at 227.68939504919675 "$node_(21) setdest 117398 4561 13.0" 
$ns at 303.56457443800406 "$node_(21) setdest 76353 24799 9.0" 
$ns at 388.33880251112976 "$node_(21) setdest 165893 14182 8.0" 
$ns at 441.7013059412274 "$node_(21) setdest 63202 16728 10.0" 
$ns at 569.1956725906151 "$node_(21) setdest 174689 805 1.0" 
$ns at 600.0137385035192 "$node_(21) setdest 138939 76324 9.0" 
$ns at 686.6905950232582 "$node_(21) setdest 82155 69076 3.0" 
$ns at 729.3730923244574 "$node_(21) setdest 104168 29776 18.0" 
$ns at 0.0 "$node_(22) setdest 38204 25373 11.0" 
$ns at 103.2041390113786 "$node_(22) setdest 38592 22307 12.0" 
$ns at 135.15904116362685 "$node_(22) setdest 20515 14975 19.0" 
$ns at 168.6136844844589 "$node_(22) setdest 60360 36079 5.0" 
$ns at 224.23126904588494 "$node_(22) setdest 32269 18297 1.0" 
$ns at 259.0390706895551 "$node_(22) setdest 92929 27951 5.0" 
$ns at 294.6903490158214 "$node_(22) setdest 107563 39385 1.0" 
$ns at 326.5103291801323 "$node_(22) setdest 142837 35295 18.0" 
$ns at 450.39979768418004 "$node_(22) setdest 15484 37908 12.0" 
$ns at 485.7605184122259 "$node_(22) setdest 166947 65138 8.0" 
$ns at 579.058143752982 "$node_(22) setdest 84377 65194 9.0" 
$ns at 695.0395191040373 "$node_(22) setdest 249628 69939 7.0" 
$ns at 774.252329010356 "$node_(22) setdest 170013 22189 3.0" 
$ns at 830.1679543620262 "$node_(22) setdest 211363 71378 19.0" 
$ns at 0.0 "$node_(23) setdest 68822 18991 4.0" 
$ns at 49.54605216912927 "$node_(23) setdest 79669 31055 1.0" 
$ns at 85.24512925655756 "$node_(23) setdest 74725 16184 6.0" 
$ns at 148.46957160548368 "$node_(23) setdest 52527 20147 12.0" 
$ns at 268.37830650681553 "$node_(23) setdest 126526 10580 16.0" 
$ns at 415.6428602420758 "$node_(23) setdest 88331 53304 11.0" 
$ns at 502.21314349339985 "$node_(23) setdest 193969 13801 5.0" 
$ns at 568.5661488936787 "$node_(23) setdest 94580 73599 4.0" 
$ns at 624.3448988545834 "$node_(23) setdest 134121 71312 5.0" 
$ns at 661.8713383854921 "$node_(23) setdest 96172 16354 18.0" 
$ns at 788.7771490907819 "$node_(23) setdest 258804 2147 10.0" 
$ns at 833.9735097501663 "$node_(23) setdest 100105 20199 3.0" 
$ns at 877.1637706681711 "$node_(23) setdest 164334 5374 9.0" 
$ns at 0.0 "$node_(24) setdest 48390 16579 14.0" 
$ns at 48.26223690275508 "$node_(24) setdest 65840 31471 17.0" 
$ns at 193.80591833278748 "$node_(24) setdest 46796 43511 7.0" 
$ns at 233.7538616443391 "$node_(24) setdest 65133 19870 11.0" 
$ns at 298.35094986883445 "$node_(24) setdest 28895 2325 15.0" 
$ns at 446.1365709971237 "$node_(24) setdest 108788 47271 17.0" 
$ns at 551.2142106733609 "$node_(24) setdest 132799 26798 16.0" 
$ns at 668.9988521671579 "$node_(24) setdest 159325 20767 14.0" 
$ns at 728.9467013423157 "$node_(24) setdest 170399 45680 9.0" 
$ns at 819.1456083058415 "$node_(24) setdest 234148 34761 3.0" 
$ns at 873.6334199426296 "$node_(24) setdest 238409 76238 16.0" 
$ns at 0.0 "$node_(25) setdest 41564 15254 19.0" 
$ns at 58.7184950645092 "$node_(25) setdest 84819 18963 13.0" 
$ns at 209.40795433427374 "$node_(25) setdest 56666 12551 9.0" 
$ns at 299.27018801591566 "$node_(25) setdest 53859 35173 9.0" 
$ns at 378.98803288372386 "$node_(25) setdest 47245 43871 18.0" 
$ns at 497.5600835205378 "$node_(25) setdest 91456 39245 3.0" 
$ns at 531.9299571212013 "$node_(25) setdest 116747 19850 5.0" 
$ns at 578.8697266986169 "$node_(25) setdest 108990 68116 12.0" 
$ns at 697.2553625973229 "$node_(25) setdest 215488 31192 2.0" 
$ns at 743.0385608952964 "$node_(25) setdest 211763 75326 16.0" 
$ns at 842.8103414646156 "$node_(25) setdest 186218 84096 9.0" 
$ns at 0.0 "$node_(26) setdest 10980 21993 3.0" 
$ns at 48.61978318109202 "$node_(26) setdest 83803 17999 5.0" 
$ns at 110.07715911486503 "$node_(26) setdest 36931 13998 12.0" 
$ns at 223.05407954335107 "$node_(26) setdest 25299 7168 12.0" 
$ns at 304.49618661534015 "$node_(26) setdest 126212 12326 10.0" 
$ns at 380.59968934048857 "$node_(26) setdest 109926 13428 6.0" 
$ns at 440.60372114150846 "$node_(26) setdest 159383 51983 10.0" 
$ns at 517.3875485201937 "$node_(26) setdest 155125 56889 12.0" 
$ns at 645.3174804713678 "$node_(26) setdest 92125 17298 13.0" 
$ns at 775.3934582519598 "$node_(26) setdest 155879 57311 14.0" 
$ns at 830.2997905180181 "$node_(26) setdest 226481 76653 18.0" 
$ns at 863.429528620391 "$node_(26) setdest 5624 68759 16.0" 
$ns at 0.0 "$node_(27) setdest 1492 24217 15.0" 
$ns at 158.53597894258843 "$node_(27) setdest 8889 37464 9.0" 
$ns at 200.48265909998594 "$node_(27) setdest 45324 10012 16.0" 
$ns at 384.9239838373339 "$node_(27) setdest 14007 490 3.0" 
$ns at 441.99617968780757 "$node_(27) setdest 106372 33515 8.0" 
$ns at 493.30916819493024 "$node_(27) setdest 179942 61798 5.0" 
$ns at 546.0324053408183 "$node_(27) setdest 108014 68290 10.0" 
$ns at 589.1023462350626 "$node_(27) setdest 166075 1477 12.0" 
$ns at 729.0029585026376 "$node_(27) setdest 140936 13273 1.0" 
$ns at 765.0789199886746 "$node_(27) setdest 239179 5138 14.0" 
$ns at 0.0 "$node_(28) setdest 76949 10603 19.0" 
$ns at 218.63204540960376 "$node_(28) setdest 99832 12694 17.0" 
$ns at 415.99082957443477 "$node_(28) setdest 22976 13047 4.0" 
$ns at 457.20586112665416 "$node_(28) setdest 159956 20532 4.0" 
$ns at 521.1228162527998 "$node_(28) setdest 111673 33151 10.0" 
$ns at 581.1979172672042 "$node_(28) setdest 65401 12755 3.0" 
$ns at 638.8521809755939 "$node_(28) setdest 160813 12876 11.0" 
$ns at 734.3405893215545 "$node_(28) setdest 114724 11118 8.0" 
$ns at 828.5836763644578 "$node_(28) setdest 102792 35115 14.0" 
$ns at 0.0 "$node_(29) setdest 74322 24048 11.0" 
$ns at 53.22853346753548 "$node_(29) setdest 14713 2549 15.0" 
$ns at 201.48120985616586 "$node_(29) setdest 37260 3314 18.0" 
$ns at 299.8624085228253 "$node_(29) setdest 118372 47162 7.0" 
$ns at 349.09464587617913 "$node_(29) setdest 39227 11961 6.0" 
$ns at 391.49565565605235 "$node_(29) setdest 132492 14686 6.0" 
$ns at 447.26815821803586 "$node_(29) setdest 183959 32252 12.0" 
$ns at 577.6225482905181 "$node_(29) setdest 164044 40840 4.0" 
$ns at 619.8406655853254 "$node_(29) setdest 8873 221 9.0" 
$ns at 704.196465643211 "$node_(29) setdest 250168 34994 3.0" 
$ns at 756.0072215470972 "$node_(29) setdest 243675 83021 13.0" 
$ns at 852.8391939965976 "$node_(29) setdest 27734 84521 9.0" 
$ns at 0.0 "$node_(30) setdest 1980 19652 13.0" 
$ns at 118.42325906508836 "$node_(30) setdest 18313 9687 3.0" 
$ns at 155.173293205424 "$node_(30) setdest 88875 35797 10.0" 
$ns at 225.3422466716008 "$node_(30) setdest 12184 40402 14.0" 
$ns at 381.52340868363274 "$node_(30) setdest 37173 19474 8.0" 
$ns at 475.8303337326013 "$node_(30) setdest 38007 26314 10.0" 
$ns at 545.4749305812736 "$node_(30) setdest 104392 48161 19.0" 
$ns at 616.4945983847126 "$node_(30) setdest 146466 45963 11.0" 
$ns at 652.8330324397342 "$node_(30) setdest 160680 13581 6.0" 
$ns at 725.6660390195584 "$node_(30) setdest 170220 76941 1.0" 
$ns at 761.9693019616783 "$node_(30) setdest 72569 1210 5.0" 
$ns at 817.1405156141188 "$node_(30) setdest 238187 9461 19.0" 
$ns at 862.40862039437 "$node_(30) setdest 19185 22185 13.0" 
$ns at 0.0 "$node_(31) setdest 59519 21591 2.0" 
$ns at 32.26686410441558 "$node_(31) setdest 31608 4524 18.0" 
$ns at 109.41156413780593 "$node_(31) setdest 19316 24101 16.0" 
$ns at 170.2291951007347 "$node_(31) setdest 80239 6522 4.0" 
$ns at 230.76231269567407 "$node_(31) setdest 48584 22794 16.0" 
$ns at 277.75557650130133 "$node_(31) setdest 123738 2036 19.0" 
$ns at 418.0391965328985 "$node_(31) setdest 21847 49145 13.0" 
$ns at 497.93733059954207 "$node_(31) setdest 30381 32888 8.0" 
$ns at 569.4836563356984 "$node_(31) setdest 23284 48691 12.0" 
$ns at 613.2174907024133 "$node_(31) setdest 125514 16468 15.0" 
$ns at 763.1548704201655 "$node_(31) setdest 249045 67333 11.0" 
$ns at 899.3485789423069 "$node_(31) setdest 12413 72623 11.0" 
$ns at 0.0 "$node_(32) setdest 21558 31491 2.0" 
$ns at 39.07497552510991 "$node_(32) setdest 25426 11687 2.0" 
$ns at 82.89555819186504 "$node_(32) setdest 32298 15996 1.0" 
$ns at 120.60260200250448 "$node_(32) setdest 32156 22592 7.0" 
$ns at 195.30061773011985 "$node_(32) setdest 118438 10109 13.0" 
$ns at 317.5767307208271 "$node_(32) setdest 102807 12761 1.0" 
$ns at 349.14371019673956 "$node_(32) setdest 101211 39731 19.0" 
$ns at 474.10739400865236 "$node_(32) setdest 41969 336 14.0" 
$ns at 592.8245616068381 "$node_(32) setdest 80672 46803 10.0" 
$ns at 682.1029803346069 "$node_(32) setdest 99178 8423 20.0" 
$ns at 0.0 "$node_(33) setdest 76772 30490 18.0" 
$ns at 157.5464667007385 "$node_(33) setdest 9700 7094 14.0" 
$ns at 189.8152337898703 "$node_(33) setdest 97818 30404 9.0" 
$ns at 281.5680788683963 "$node_(33) setdest 58340 32789 12.0" 
$ns at 419.68950939613967 "$node_(33) setdest 102700 29156 7.0" 
$ns at 515.6613710689289 "$node_(33) setdest 209675 6467 18.0" 
$ns at 704.7853770022002 "$node_(33) setdest 114004 78910 14.0" 
$ns at 817.4136863303493 "$node_(33) setdest 163631 12834 13.0" 
$ns at 873.4437273064707 "$node_(33) setdest 221520 26423 19.0" 
$ns at 0.0 "$node_(34) setdest 50152 28832 18.0" 
$ns at 92.51837110661528 "$node_(34) setdest 5139 2631 1.0" 
$ns at 132.11924680908234 "$node_(34) setdest 80137 19341 1.0" 
$ns at 163.61718339063322 "$node_(34) setdest 59753 16750 4.0" 
$ns at 210.75927251572455 "$node_(34) setdest 132453 5873 16.0" 
$ns at 241.2463362786719 "$node_(34) setdest 101530 14678 11.0" 
$ns at 374.45537167637804 "$node_(34) setdest 1273 45264 15.0" 
$ns at 550.446630639073 "$node_(34) setdest 88674 58230 18.0" 
$ns at 750.7118018895825 "$node_(34) setdest 54048 74502 11.0" 
$ns at 855.3925965925987 "$node_(34) setdest 101048 32902 9.0" 
$ns at 0.0 "$node_(35) setdest 86422 18594 11.0" 
$ns at 44.2341439047943 "$node_(35) setdest 75078 24585 3.0" 
$ns at 83.16639851523641 "$node_(35) setdest 52973 9315 15.0" 
$ns at 255.2249982713242 "$node_(35) setdest 1095 19579 12.0" 
$ns at 295.17587342588985 "$node_(35) setdest 44916 3883 2.0" 
$ns at 338.1337723211209 "$node_(35) setdest 6192 31875 13.0" 
$ns at 373.4761540222522 "$node_(35) setdest 128661 36098 9.0" 
$ns at 485.11312907286464 "$node_(35) setdest 2286 35672 2.0" 
$ns at 522.8572712259607 "$node_(35) setdest 141808 15155 12.0" 
$ns at 671.0395349720296 "$node_(35) setdest 67600 32656 7.0" 
$ns at 740.2333619630252 "$node_(35) setdest 68226 44454 12.0" 
$ns at 858.8802008247852 "$node_(35) setdest 219109 65891 8.0" 
$ns at 0.0 "$node_(36) setdest 86689 15187 18.0" 
$ns at 191.57727623679452 "$node_(36) setdest 6997 7565 17.0" 
$ns at 257.3461683321713 "$node_(36) setdest 111148 46924 1.0" 
$ns at 292.58670092220956 "$node_(36) setdest 1556 52183 15.0" 
$ns at 383.09644794503583 "$node_(36) setdest 71928 9753 3.0" 
$ns at 438.278244034669 "$node_(36) setdest 104506 6683 2.0" 
$ns at 480.49857487452283 "$node_(36) setdest 119761 34693 15.0" 
$ns at 636.3695201400233 "$node_(36) setdest 52831 27459 18.0" 
$ns at 708.5337221515025 "$node_(36) setdest 181279 38809 17.0" 
$ns at 801.9216797636507 "$node_(36) setdest 204248 37428 5.0" 
$ns at 860.7663195284646 "$node_(36) setdest 88682 4431 20.0" 
$ns at 0.0 "$node_(37) setdest 33775 11433 9.0" 
$ns at 74.98934002987616 "$node_(37) setdest 52205 28605 8.0" 
$ns at 113.31502282699734 "$node_(37) setdest 27891 19 11.0" 
$ns at 165.19370461125214 "$node_(37) setdest 87452 30827 4.0" 
$ns at 225.98996985981466 "$node_(37) setdest 70499 27174 2.0" 
$ns at 259.11328941445936 "$node_(37) setdest 83254 14903 2.0" 
$ns at 301.8175262076296 "$node_(37) setdest 34296 21614 5.0" 
$ns at 360.17502332646006 "$node_(37) setdest 137925 58750 18.0" 
$ns at 409.36285664976737 "$node_(37) setdest 77195 32838 16.0" 
$ns at 566.2325671525233 "$node_(37) setdest 65981 69881 20.0" 
$ns at 603.6930673632354 "$node_(37) setdest 92626 46437 18.0" 
$ns at 748.7313566476411 "$node_(37) setdest 172727 77892 8.0" 
$ns at 857.547461193383 "$node_(37) setdest 83278 87301 17.0" 
$ns at 0.0 "$node_(38) setdest 5928 19518 9.0" 
$ns at 60.80176455485835 "$node_(38) setdest 2498 6634 10.0" 
$ns at 166.015362398035 "$node_(38) setdest 92701 33075 13.0" 
$ns at 229.95055766002912 "$node_(38) setdest 78321 24762 10.0" 
$ns at 329.82299150446545 "$node_(38) setdest 143760 48202 4.0" 
$ns at 382.0007887922011 "$node_(38) setdest 96871 24458 14.0" 
$ns at 451.29956854600266 "$node_(38) setdest 37875 68939 10.0" 
$ns at 580.6841449953616 "$node_(38) setdest 188654 65703 1.0" 
$ns at 612.5891683746551 "$node_(38) setdest 92057 50712 20.0" 
$ns at 778.9895086652427 "$node_(38) setdest 151096 14422 16.0" 
$ns at 0.0 "$node_(39) setdest 78038 15343 14.0" 
$ns at 89.66487336317662 "$node_(39) setdest 30018 12104 2.0" 
$ns at 126.39719864096992 "$node_(39) setdest 62576 14990 4.0" 
$ns at 167.89185488127808 "$node_(39) setdest 104252 25460 10.0" 
$ns at 220.10507322038887 "$node_(39) setdest 85805 20355 15.0" 
$ns at 359.8117837205686 "$node_(39) setdest 86793 37711 4.0" 
$ns at 408.0112185612155 "$node_(39) setdest 37716 13582 18.0" 
$ns at 448.37539795525964 "$node_(39) setdest 50382 7525 10.0" 
$ns at 529.0643806020043 "$node_(39) setdest 166050 33391 12.0" 
$ns at 562.7915205360414 "$node_(39) setdest 54513 32081 1.0" 
$ns at 594.6165767768156 "$node_(39) setdest 26678 6124 5.0" 
$ns at 669.3173814134991 "$node_(39) setdest 213690 7504 9.0" 
$ns at 724.2449200753225 "$node_(39) setdest 128126 4113 12.0" 
$ns at 776.099603366445 "$node_(39) setdest 185100 80601 15.0" 
$ns at 839.1101651540432 "$node_(39) setdest 152900 25375 10.0" 
$ns at 871.2778311134125 "$node_(39) setdest 82483 14622 15.0" 
$ns at 0.0 "$node_(40) setdest 78685 3290 19.0" 
$ns at 188.32777006809468 "$node_(40) setdest 81929 22176 16.0" 
$ns at 373.8689421075254 "$node_(40) setdest 39096 60445 10.0" 
$ns at 465.6683981244238 "$node_(40) setdest 31339 62813 14.0" 
$ns at 522.241306891515 "$node_(40) setdest 66703 63433 3.0" 
$ns at 559.7790854659712 "$node_(40) setdest 7945 25398 4.0" 
$ns at 613.0106405942365 "$node_(40) setdest 230212 56971 11.0" 
$ns at 693.7410437802766 "$node_(40) setdest 117878 39606 9.0" 
$ns at 813.5020812958822 "$node_(40) setdest 161980 82710 11.0" 
$ns at 889.2809581257362 "$node_(40) setdest 13943 10401 15.0" 
$ns at 0.0 "$node_(41) setdest 93584 18551 19.0" 
$ns at 48.64356998305348 "$node_(41) setdest 32851 13169 10.0" 
$ns at 88.84575471034029 "$node_(41) setdest 6602 8554 17.0" 
$ns at 269.6181232708646 "$node_(41) setdest 68288 8257 4.0" 
$ns at 323.24813615383 "$node_(41) setdest 90094 17148 16.0" 
$ns at 358.3284877349546 "$node_(41) setdest 51275 29295 18.0" 
$ns at 411.84352792382606 "$node_(41) setdest 31481 57751 13.0" 
$ns at 563.475993883829 "$node_(41) setdest 102978 66177 9.0" 
$ns at 664.9997048517594 "$node_(41) setdest 111766 23678 10.0" 
$ns at 737.8015925935209 "$node_(41) setdest 37106 33361 18.0" 
$ns at 815.976028643611 "$node_(41) setdest 254955 43956 13.0" 
$ns at 0.0 "$node_(42) setdest 68909 13549 19.0" 
$ns at 85.18747611083626 "$node_(42) setdest 38789 27194 14.0" 
$ns at 233.11661759746028 "$node_(42) setdest 46171 7646 5.0" 
$ns at 288.2199698712644 "$node_(42) setdest 46343 1461 13.0" 
$ns at 333.4880456518303 "$node_(42) setdest 22773 4371 1.0" 
$ns at 365.7705262166599 "$node_(42) setdest 115083 2587 11.0" 
$ns at 446.99265069912735 "$node_(42) setdest 52913 53512 9.0" 
$ns at 478.71295941810473 "$node_(42) setdest 41927 7164 2.0" 
$ns at 515.656081369203 "$node_(42) setdest 136511 23290 18.0" 
$ns at 723.0715526160965 "$node_(42) setdest 135897 67053 13.0" 
$ns at 803.7525173253412 "$node_(42) setdest 19604 80145 18.0" 
$ns at 876.2554174433379 "$node_(42) setdest 257441 89037 17.0" 
$ns at 0.0 "$node_(43) setdest 38398 28569 8.0" 
$ns at 107.06789933322712 "$node_(43) setdest 83262 20487 10.0" 
$ns at 176.36227120818322 "$node_(43) setdest 100137 14228 10.0" 
$ns at 304.6816811973996 "$node_(43) setdest 46323 15328 18.0" 
$ns at 493.30857601161887 "$node_(43) setdest 147663 49969 7.0" 
$ns at 577.5973002518838 "$node_(43) setdest 160683 67880 4.0" 
$ns at 637.3412748289944 "$node_(43) setdest 108159 6711 3.0" 
$ns at 677.1887126719718 "$node_(43) setdest 58535 30632 15.0" 
$ns at 850.05942598312 "$node_(43) setdest 30213 33733 13.0" 
$ns at 0.0 "$node_(44) setdest 61487 1240 17.0" 
$ns at 119.30019209606942 "$node_(44) setdest 32512 13794 7.0" 
$ns at 187.56920512974645 "$node_(44) setdest 41906 22988 13.0" 
$ns at 268.9151634612981 "$node_(44) setdest 95719 50585 3.0" 
$ns at 308.85453918665667 "$node_(44) setdest 99349 6473 9.0" 
$ns at 427.0514768192002 "$node_(44) setdest 54322 30209 4.0" 
$ns at 486.4757744476093 "$node_(44) setdest 42920 56268 6.0" 
$ns at 539.2599777612231 "$node_(44) setdest 144235 66769 17.0" 
$ns at 672.4656767834963 "$node_(44) setdest 34664 75686 4.0" 
$ns at 717.3135075758005 "$node_(44) setdest 100525 54019 19.0" 
$ns at 856.063566977485 "$node_(44) setdest 187559 46250 14.0" 
$ns at 0.0 "$node_(45) setdest 70023 29361 10.0" 
$ns at 122.4214281343319 "$node_(45) setdest 47455 2746 4.0" 
$ns at 187.0990041266811 "$node_(45) setdest 58645 21391 7.0" 
$ns at 267.3558144226182 "$node_(45) setdest 51872 32639 9.0" 
$ns at 365.89966240559806 "$node_(45) setdest 50056 8829 4.0" 
$ns at 421.01585879757704 "$node_(45) setdest 94311 34437 16.0" 
$ns at 601.6997601047383 "$node_(45) setdest 185333 17736 12.0" 
$ns at 675.4597033364946 "$node_(45) setdest 15978 33248 14.0" 
$ns at 756.1019683117312 "$node_(45) setdest 40860 51904 1.0" 
$ns at 793.142481468397 "$node_(45) setdest 213327 31293 11.0" 
$ns at 0.0 "$node_(46) setdest 55565 25611 10.0" 
$ns at 72.84282203694755 "$node_(46) setdest 86168 16650 3.0" 
$ns at 114.20612022259597 "$node_(46) setdest 19253 17072 4.0" 
$ns at 173.45643822781005 "$node_(46) setdest 20447 43665 5.0" 
$ns at 218.9751415990125 "$node_(46) setdest 28399 25408 2.0" 
$ns at 266.6873379577239 "$node_(46) setdest 65904 4241 14.0" 
$ns at 331.75622901747516 "$node_(46) setdest 71652 12241 8.0" 
$ns at 379.9510186055599 "$node_(46) setdest 14565 13531 14.0" 
$ns at 547.1670905574994 "$node_(46) setdest 9787 27815 17.0" 
$ns at 705.4115338288224 "$node_(46) setdest 247832 70268 9.0" 
$ns at 763.6891895764657 "$node_(46) setdest 190515 86189 1.0" 
$ns at 802.5983598089971 "$node_(46) setdest 109508 26070 4.0" 
$ns at 849.4832419052403 "$node_(46) setdest 167875 58816 5.0" 
$ns at 890.5126399668446 "$node_(46) setdest 131488 86108 4.0" 
$ns at 0.0 "$node_(47) setdest 13227 16233 16.0" 
$ns at 67.77838735736479 "$node_(47) setdest 31101 22338 1.0" 
$ns at 106.3930250591991 "$node_(47) setdest 86194 15405 13.0" 
$ns at 189.4575336766855 "$node_(47) setdest 36032 25691 15.0" 
$ns at 249.46593614827225 "$node_(47) setdest 109225 41217 14.0" 
$ns at 296.7834530051236 "$node_(47) setdest 48209 14298 17.0" 
$ns at 352.87845998610044 "$node_(47) setdest 15554 54810 1.0" 
$ns at 385.8202645904348 "$node_(47) setdest 105201 54442 19.0" 
$ns at 537.6315853210424 "$node_(47) setdest 67606 34726 17.0" 
$ns at 684.1326604909506 "$node_(47) setdest 100119 67477 6.0" 
$ns at 763.50391015317 "$node_(47) setdest 112469 6685 15.0" 
$ns at 833.7173771927421 "$node_(47) setdest 123946 8863 10.0" 
$ns at 885.2073678736306 "$node_(47) setdest 148420 28358 14.0" 
$ns at 0.0 "$node_(48) setdest 62734 6100 4.0" 
$ns at 54.87658459966987 "$node_(48) setdest 65264 30117 18.0" 
$ns at 235.3527811165065 "$node_(48) setdest 23430 6714 6.0" 
$ns at 284.06233334835963 "$node_(48) setdest 58152 49804 14.0" 
$ns at 317.13949520344977 "$node_(48) setdest 120360 50784 8.0" 
$ns at 355.848999313411 "$node_(48) setdest 115726 31782 19.0" 
$ns at 569.9566883535897 "$node_(48) setdest 187803 70229 1.0" 
$ns at 603.2635549366244 "$node_(48) setdest 96692 30635 8.0" 
$ns at 654.1468224514367 "$node_(48) setdest 134852 3160 14.0" 
$ns at 788.4842717048762 "$node_(48) setdest 233534 28830 10.0" 
$ns at 878.1249564014847 "$node_(48) setdest 120284 17806 14.0" 
$ns at 0.0 "$node_(49) setdest 1534 25514 14.0" 
$ns at 129.8536988349865 "$node_(49) setdest 31948 20434 16.0" 
$ns at 161.95304085375415 "$node_(49) setdest 23975 16425 8.0" 
$ns at 251.4154396117316 "$node_(49) setdest 142104 36050 15.0" 
$ns at 402.89451040650056 "$node_(49) setdest 6752 59792 13.0" 
$ns at 503.6615124359362 "$node_(49) setdest 152307 52738 5.0" 
$ns at 536.2378018622962 "$node_(49) setdest 186762 38687 6.0" 
$ns at 614.9902212505542 "$node_(49) setdest 93337 2699 6.0" 
$ns at 681.6408779227409 "$node_(49) setdest 197066 27953 12.0" 
$ns at 714.5918325394784 "$node_(49) setdest 2252 57534 3.0" 
$ns at 753.9765564416831 "$node_(49) setdest 166068 58504 2.0" 
$ns at 794.2100774867955 "$node_(49) setdest 145490 42644 8.0" 
$ns at 0.0 "$node_(50) setdest 12343 23657 10.0" 
$ns at 51.49552783641748 "$node_(50) setdest 58797 27609 6.0" 
$ns at 125.7930795690986 "$node_(50) setdest 52059 3893 17.0" 
$ns at 312.8608471007446 "$node_(50) setdest 106936 14371 20.0" 
$ns at 460.54413061650234 "$node_(50) setdest 88300 58581 17.0" 
$ns at 498.7516626213242 "$node_(50) setdest 171661 10860 18.0" 
$ns at 700.3570522680524 "$node_(50) setdest 150472 10366 11.0" 
$ns at 754.9991050050695 "$node_(50) setdest 104586 43962 14.0" 
$ns at 798.0184064033558 "$node_(50) setdest 186880 24869 1.0" 
$ns at 831.0652603865899 "$node_(50) setdest 101265 39160 9.0" 
$ns at 0.0 "$node_(51) setdest 27530 15345 20.0" 
$ns at 137.6823375940958 "$node_(51) setdest 29647 7380 17.0" 
$ns at 214.038030131018 "$node_(51) setdest 101734 6221 11.0" 
$ns at 352.0156183804463 "$node_(51) setdest 148758 331 11.0" 
$ns at 490.1306840048633 "$node_(51) setdest 126189 67263 15.0" 
$ns at 587.6462275783261 "$node_(51) setdest 30687 48910 4.0" 
$ns at 651.562381851464 "$node_(51) setdest 113493 54642 2.0" 
$ns at 692.7301031579681 "$node_(51) setdest 48328 2270 18.0" 
$ns at 812.6155614177096 "$node_(51) setdest 96229 24113 11.0" 
$ns at 0.0 "$node_(52) setdest 15714 14711 6.0" 
$ns at 84.24500255717514 "$node_(52) setdest 77847 6403 17.0" 
$ns at 225.64351217486148 "$node_(52) setdest 126112 35533 16.0" 
$ns at 373.5258340209804 "$node_(52) setdest 145085 38702 8.0" 
$ns at 421.1658499423668 "$node_(52) setdest 86316 42339 11.0" 
$ns at 518.5118882580094 "$node_(52) setdest 111963 59012 5.0" 
$ns at 577.8710103459036 "$node_(52) setdest 216719 11871 9.0" 
$ns at 639.6577164969653 "$node_(52) setdest 81784 63993 20.0" 
$ns at 688.5417711234917 "$node_(52) setdest 15585 25924 2.0" 
$ns at 732.924241014657 "$node_(52) setdest 22726 72568 12.0" 
$ns at 800.3262270276304 "$node_(52) setdest 125417 57753 4.0" 
$ns at 841.2215654128247 "$node_(52) setdest 22469 1858 4.0" 
$ns at 875.9164230433267 "$node_(52) setdest 11176 46180 11.0" 
$ns at 0.0 "$node_(53) setdest 38838 2450 19.0" 
$ns at 81.64411086450608 "$node_(53) setdest 92898 27198 17.0" 
$ns at 114.31171209194832 "$node_(53) setdest 91728 31037 16.0" 
$ns at 189.98794134684533 "$node_(53) setdest 78895 39033 4.0" 
$ns at 232.88480178301305 "$node_(53) setdest 13543 43384 7.0" 
$ns at 307.2102262355602 "$node_(53) setdest 35150 26641 18.0" 
$ns at 346.83889555318206 "$node_(53) setdest 118634 50351 19.0" 
$ns at 493.7448515361962 "$node_(53) setdest 182238 54065 3.0" 
$ns at 535.0183996298359 "$node_(53) setdest 27750 44609 8.0" 
$ns at 598.2936204685712 "$node_(53) setdest 75978 44892 19.0" 
$ns at 756.7751404113191 "$node_(53) setdest 1077 4595 8.0" 
$ns at 799.6016585416273 "$node_(53) setdest 261633 16293 1.0" 
$ns at 832.6895638460118 "$node_(53) setdest 66371 59021 5.0" 
$ns at 863.7221106879254 "$node_(53) setdest 109515 47356 14.0" 
$ns at 0.0 "$node_(54) setdest 63963 16232 1.0" 
$ns at 36.72080946646742 "$node_(54) setdest 65813 15259 18.0" 
$ns at 72.59673014601024 "$node_(54) setdest 67942 21749 19.0" 
$ns at 225.99984817790687 "$node_(54) setdest 125022 10651 11.0" 
$ns at 344.12745733962765 "$node_(54) setdest 102273 5680 4.0" 
$ns at 390.3513294898404 "$node_(54) setdest 49548 38413 1.0" 
$ns at 421.70439259154523 "$node_(54) setdest 162319 61584 19.0" 
$ns at 474.76873073277824 "$node_(54) setdest 134339 294 9.0" 
$ns at 513.4942706715467 "$node_(54) setdest 135794 25511 19.0" 
$ns at 651.7177012001646 "$node_(54) setdest 235430 21594 9.0" 
$ns at 749.9696617178939 "$node_(54) setdest 218916 48992 7.0" 
$ns at 820.7063794322305 "$node_(54) setdest 83236 54865 7.0" 
$ns at 0.0 "$node_(55) setdest 80139 14892 1.0" 
$ns at 39.21098618200158 "$node_(55) setdest 66598 16707 6.0" 
$ns at 83.81364832516668 "$node_(55) setdest 47306 20931 8.0" 
$ns at 162.44085713813485 "$node_(55) setdest 6814 6160 8.0" 
$ns at 270.85972985387866 "$node_(55) setdest 25318 27900 13.0" 
$ns at 301.4556482085041 "$node_(55) setdest 102879 26994 13.0" 
$ns at 337.6819970067218 "$node_(55) setdest 152900 14031 19.0" 
$ns at 406.7677394277564 "$node_(55) setdest 73433 59459 20.0" 
$ns at 597.2825801459278 "$node_(55) setdest 72516 39728 12.0" 
$ns at 691.5663861152955 "$node_(55) setdest 108460 21269 12.0" 
$ns at 773.2644115436789 "$node_(55) setdest 151612 23521 16.0" 
$ns at 836.1762512301038 "$node_(55) setdest 234513 34602 3.0" 
$ns at 880.277024665646 "$node_(55) setdest 258935 79095 6.0" 
$ns at 0.0 "$node_(56) setdest 68354 29911 5.0" 
$ns at 50.371440887347745 "$node_(56) setdest 3819 29288 3.0" 
$ns at 96.85260215233231 "$node_(56) setdest 56430 24257 12.0" 
$ns at 190.84333453714632 "$node_(56) setdest 38731 28151 6.0" 
$ns at 279.2301142772759 "$node_(56) setdest 61756 10549 13.0" 
$ns at 370.8383702542245 "$node_(56) setdest 14256 27139 13.0" 
$ns at 527.2363993674102 "$node_(56) setdest 19447 64980 16.0" 
$ns at 570.1815435909891 "$node_(56) setdest 154837 71716 3.0" 
$ns at 619.4785331880578 "$node_(56) setdest 150545 40886 18.0" 
$ns at 757.7270574996845 "$node_(56) setdest 163737 5992 6.0" 
$ns at 822.5904908097448 "$node_(56) setdest 59611 5659 7.0" 
$ns at 874.0043367844414 "$node_(56) setdest 246087 46810 9.0" 
$ns at 0.0 "$node_(57) setdest 38760 8481 13.0" 
$ns at 159.93316764202783 "$node_(57) setdest 100516 22412 5.0" 
$ns at 231.17760356574104 "$node_(57) setdest 59276 15373 19.0" 
$ns at 278.5324366094702 "$node_(57) setdest 94615 26135 17.0" 
$ns at 415.995478470934 "$node_(57) setdest 16136 21808 18.0" 
$ns at 472.90615015370213 "$node_(57) setdest 284 42092 14.0" 
$ns at 553.5518215364187 "$node_(57) setdest 2851 44505 11.0" 
$ns at 596.2875348906489 "$node_(57) setdest 167980 55199 10.0" 
$ns at 649.3329275288751 "$node_(57) setdest 178441 45849 17.0" 
$ns at 782.5211740495098 "$node_(57) setdest 87075 29866 5.0" 
$ns at 828.4721348922174 "$node_(57) setdest 170424 62140 11.0" 
$ns at 0.0 "$node_(58) setdest 82108 29156 17.0" 
$ns at 142.30723238195787 "$node_(58) setdest 94450 31379 1.0" 
$ns at 173.04673820685323 "$node_(58) setdest 62939 14437 12.0" 
$ns at 256.8815476568436 "$node_(58) setdest 1932 23546 14.0" 
$ns at 404.84191641397626 "$node_(58) setdest 70094 18563 13.0" 
$ns at 456.2235906005304 "$node_(58) setdest 151607 26856 16.0" 
$ns at 524.7115479409614 "$node_(58) setdest 26054 26258 11.0" 
$ns at 629.159521699599 "$node_(58) setdest 192582 51167 10.0" 
$ns at 669.3099462098453 "$node_(58) setdest 236317 47878 2.0" 
$ns at 711.5527427405627 "$node_(58) setdest 229806 8288 17.0" 
$ns at 893.931157434136 "$node_(58) setdest 95506 58760 7.0" 
$ns at 0.0 "$node_(59) setdest 63484 31558 19.0" 
$ns at 136.41198456419806 "$node_(59) setdest 62903 30140 14.0" 
$ns at 282.7714066315058 "$node_(59) setdest 73000 6679 5.0" 
$ns at 353.3238889630561 "$node_(59) setdest 164639 61456 12.0" 
$ns at 391.1539350329167 "$node_(59) setdest 66367 4203 18.0" 
$ns at 536.1124899556921 "$node_(59) setdest 15693 21627 19.0" 
$ns at 676.2898305005597 "$node_(59) setdest 122941 10147 10.0" 
$ns at 794.7743573507087 "$node_(59) setdest 143134 49256 6.0" 
$ns at 849.992332662786 "$node_(59) setdest 49288 88854 15.0" 
$ns at 894.3372552964178 "$node_(59) setdest 216733 20757 3.0" 
$ns at 0.0 "$node_(60) setdest 23482 47 19.0" 
$ns at 42.95767424247111 "$node_(60) setdest 71346 31078 9.0" 
$ns at 84.17309501539006 "$node_(60) setdest 63475 19155 1.0" 
$ns at 121.86666703382754 "$node_(60) setdest 26271 14367 12.0" 
$ns at 236.78932005165842 "$node_(60) setdest 34619 17276 5.0" 
$ns at 294.35073901499095 "$node_(60) setdest 15603 38499 15.0" 
$ns at 328.8772254416129 "$node_(60) setdest 17033 45657 17.0" 
$ns at 501.65347797714145 "$node_(60) setdest 193032 2631 10.0" 
$ns at 535.9907440661841 "$node_(60) setdest 195596 39845 5.0" 
$ns at 602.1207452042356 "$node_(60) setdest 175502 43922 18.0" 
$ns at 766.524145016247 "$node_(60) setdest 167639 73452 6.0" 
$ns at 803.1233072800459 "$node_(60) setdest 117565 84121 4.0" 
$ns at 844.3567756492321 "$node_(60) setdest 185409 34582 6.0" 
$ns at 898.2335629882572 "$node_(60) setdest 79932 761 6.0" 
$ns at 0.0 "$node_(61) setdest 16635 7738 7.0" 
$ns at 86.42583645165567 "$node_(61) setdest 69613 12786 15.0" 
$ns at 265.62977743251406 "$node_(61) setdest 71193 34722 3.0" 
$ns at 320.1645304867628 "$node_(61) setdest 34624 15167 17.0" 
$ns at 367.69401470573234 "$node_(61) setdest 169974 21294 16.0" 
$ns at 461.410377718111 "$node_(61) setdest 148292 47113 19.0" 
$ns at 504.1128637759397 "$node_(61) setdest 101090 22908 17.0" 
$ns at 689.6975495156283 "$node_(61) setdest 189767 21644 6.0" 
$ns at 721.2944378308281 "$node_(61) setdest 110820 9905 6.0" 
$ns at 807.692692458163 "$node_(61) setdest 189316 45685 7.0" 
$ns at 849.7186237641738 "$node_(61) setdest 221523 43704 7.0" 
$ns at 0.0 "$node_(62) setdest 59129 12015 19.0" 
$ns at 205.51124914163177 "$node_(62) setdest 97396 15130 7.0" 
$ns at 265.4452884198718 "$node_(62) setdest 13909 8228 12.0" 
$ns at 404.2076487035512 "$node_(62) setdest 10607 57111 13.0" 
$ns at 541.851154469303 "$node_(62) setdest 187114 6444 15.0" 
$ns at 610.091715190816 "$node_(62) setdest 137110 47888 4.0" 
$ns at 667.255442091209 "$node_(62) setdest 42366 78504 8.0" 
$ns at 702.3771498612743 "$node_(62) setdest 96244 22774 1.0" 
$ns at 733.8999233959695 "$node_(62) setdest 184855 36305 11.0" 
$ns at 766.6409421761841 "$node_(62) setdest 240659 27378 18.0" 
$ns at 838.4327168971332 "$node_(62) setdest 102852 37150 4.0" 
$ns at 890.5862140864474 "$node_(62) setdest 109921 33584 8.0" 
$ns at 0.0 "$node_(63) setdest 55002 6011 20.0" 
$ns at 222.26306254113354 "$node_(63) setdest 74129 23973 1.0" 
$ns at 259.8879846138938 "$node_(63) setdest 146113 10167 12.0" 
$ns at 345.53786834516825 "$node_(63) setdest 7004 36534 7.0" 
$ns at 444.9853635033491 "$node_(63) setdest 161283 7096 14.0" 
$ns at 487.27903928080167 "$node_(63) setdest 202010 70382 1.0" 
$ns at 522.48765081845 "$node_(63) setdest 58700 8964 1.0" 
$ns at 560.1729956269487 "$node_(63) setdest 21828 64611 17.0" 
$ns at 615.1631215234847 "$node_(63) setdest 43360 57065 10.0" 
$ns at 664.3461527264953 "$node_(63) setdest 88614 75171 11.0" 
$ns at 726.2738726002985 "$node_(63) setdest 203178 36075 5.0" 
$ns at 765.3863802316694 "$node_(63) setdest 13740 72638 13.0" 
$ns at 0.0 "$node_(64) setdest 36730 8815 14.0" 
$ns at 126.14406819727691 "$node_(64) setdest 63680 21127 16.0" 
$ns at 214.10437449676598 "$node_(64) setdest 96564 43801 13.0" 
$ns at 329.2815838197069 "$node_(64) setdest 86524 41437 12.0" 
$ns at 467.39470714372874 "$node_(64) setdest 141257 7720 18.0" 
$ns at 563.7462246439683 "$node_(64) setdest 48023 63771 6.0" 
$ns at 595.7303590962103 "$node_(64) setdest 12579 42276 16.0" 
$ns at 628.2090774599174 "$node_(64) setdest 204675 36574 8.0" 
$ns at 667.7873008535264 "$node_(64) setdest 178713 26230 16.0" 
$ns at 788.5870430717634 "$node_(64) setdest 212505 51388 15.0" 
$ns at 836.446823921741 "$node_(64) setdest 153035 30026 15.0" 
$ns at 0.0 "$node_(65) setdest 49636 25273 15.0" 
$ns at 178.52592103142595 "$node_(65) setdest 6630 37249 2.0" 
$ns at 212.38986903926258 "$node_(65) setdest 116466 27994 16.0" 
$ns at 401.0813802346623 "$node_(65) setdest 35000 22475 2.0" 
$ns at 450.2806077171963 "$node_(65) setdest 82216 32273 1.0" 
$ns at 483.29875662995687 "$node_(65) setdest 41785 48609 16.0" 
$ns at 541.4027810681288 "$node_(65) setdest 209024 48403 3.0" 
$ns at 590.3848370885144 "$node_(65) setdest 109066 8770 8.0" 
$ns at 651.2784431130885 "$node_(65) setdest 20944 70392 6.0" 
$ns at 727.471138462686 "$node_(65) setdest 32532 65326 19.0" 
$ns at 0.0 "$node_(66) setdest 21853 5569 3.0" 
$ns at 36.21429293141427 "$node_(66) setdest 66731 4859 12.0" 
$ns at 147.63250276264574 "$node_(66) setdest 21210 9095 9.0" 
$ns at 205.23253611232445 "$node_(66) setdest 72471 35231 10.0" 
$ns at 278.7204499712018 "$node_(66) setdest 12929 36639 15.0" 
$ns at 407.41808714064666 "$node_(66) setdest 184142 58345 8.0" 
$ns at 496.22325658657763 "$node_(66) setdest 90568 19729 7.0" 
$ns at 565.5975110575478 "$node_(66) setdest 93429 48277 20.0" 
$ns at 627.3142444723053 "$node_(66) setdest 40294 39023 6.0" 
$ns at 706.4534983803949 "$node_(66) setdest 203417 38892 1.0" 
$ns at 738.6139985829961 "$node_(66) setdest 124913 10123 20.0" 
$ns at 815.8365093537399 "$node_(66) setdest 89278 88845 20.0" 
$ns at 0.0 "$node_(67) setdest 50209 4150 7.0" 
$ns at 68.3175156496934 "$node_(67) setdest 87302 14376 2.0" 
$ns at 102.25340777233333 "$node_(67) setdest 26524 17989 14.0" 
$ns at 223.91839404565337 "$node_(67) setdest 34590 23639 9.0" 
$ns at 319.5453737083874 "$node_(67) setdest 108900 35935 8.0" 
$ns at 379.6417092881594 "$node_(67) setdest 77108 3564 5.0" 
$ns at 457.9228890783129 "$node_(67) setdest 145686 64574 17.0" 
$ns at 508.93121444495745 "$node_(67) setdest 185877 70670 4.0" 
$ns at 555.4012091234542 "$node_(67) setdest 34379 6874 18.0" 
$ns at 618.8760163589308 "$node_(67) setdest 20351 9214 6.0" 
$ns at 676.8435380472899 "$node_(67) setdest 102816 1862 14.0" 
$ns at 783.1138056290478 "$node_(67) setdest 114267 10120 11.0" 
$ns at 853.1335813997155 "$node_(67) setdest 26317 71872 14.0" 
$ns at 0.0 "$node_(68) setdest 33056 6370 5.0" 
$ns at 74.19870212939995 "$node_(68) setdest 75608 26603 9.0" 
$ns at 176.75314064208555 "$node_(68) setdest 33556 17593 18.0" 
$ns at 363.74422454945113 "$node_(68) setdest 13835 44543 1.0" 
$ns at 395.50149480836143 "$node_(68) setdest 8349 58871 11.0" 
$ns at 522.112639291809 "$node_(68) setdest 87773 60039 11.0" 
$ns at 600.4229063539448 "$node_(68) setdest 154615 49685 19.0" 
$ns at 717.950239197367 "$node_(68) setdest 228893 49912 4.0" 
$ns at 754.9117998890854 "$node_(68) setdest 256225 17168 9.0" 
$ns at 871.0859636801301 "$node_(68) setdest 207861 86890 4.0" 
$ns at 0.0 "$node_(69) setdest 59668 15164 18.0" 
$ns at 169.6575910715114 "$node_(69) setdest 133256 11961 6.0" 
$ns at 215.87190744943496 "$node_(69) setdest 39361 29037 8.0" 
$ns at 285.85394369132894 "$node_(69) setdest 123784 24743 7.0" 
$ns at 315.8571641716824 "$node_(69) setdest 116368 26092 12.0" 
$ns at 389.9275982957076 "$node_(69) setdest 79365 48817 19.0" 
$ns at 580.0891587420326 "$node_(69) setdest 176638 7822 10.0" 
$ns at 701.8895964458638 "$node_(69) setdest 42071 14919 10.0" 
$ns at 822.4719708380757 "$node_(69) setdest 228071 31702 6.0" 
$ns at 0.0 "$node_(70) setdest 59051 13478 3.0" 
$ns at 31.77670332518739 "$node_(70) setdest 61836 5208 8.0" 
$ns at 99.31361876172329 "$node_(70) setdest 3831 30648 2.0" 
$ns at 136.15509726908257 "$node_(70) setdest 42809 24650 14.0" 
$ns at 170.87150173013035 "$node_(70) setdest 122254 399 12.0" 
$ns at 282.8293048966073 "$node_(70) setdest 85355 43578 16.0" 
$ns at 346.2065214347347 "$node_(70) setdest 5952 17176 18.0" 
$ns at 441.73993954831104 "$node_(70) setdest 43700 14682 5.0" 
$ns at 485.1019499824371 "$node_(70) setdest 89589 47249 18.0" 
$ns at 677.6615993675623 "$node_(70) setdest 220262 11420 13.0" 
$ns at 784.1174757338932 "$node_(70) setdest 153990 6322 2.0" 
$ns at 819.7101561729901 "$node_(70) setdest 107012 41250 1.0" 
$ns at 858.8705226455335 "$node_(70) setdest 3635 3262 16.0" 
$ns at 0.0 "$node_(71) setdest 44018 6313 17.0" 
$ns at 63.91075004280132 "$node_(71) setdest 10867 19769 16.0" 
$ns at 124.93816497744584 "$node_(71) setdest 60195 612 15.0" 
$ns at 163.2414579088951 "$node_(71) setdest 77328 2338 3.0" 
$ns at 196.76956597675775 "$node_(71) setdest 73899 39395 13.0" 
$ns at 247.8010651545054 "$node_(71) setdest 16877 44718 11.0" 
$ns at 368.4221189805985 "$node_(71) setdest 67350 24080 8.0" 
$ns at 408.79164771493026 "$node_(71) setdest 52253 62541 7.0" 
$ns at 462.6031129890952 "$node_(71) setdest 170889 56997 10.0" 
$ns at 557.9714653327807 "$node_(71) setdest 51466 32994 16.0" 
$ns at 601.0690001559154 "$node_(71) setdest 184001 10887 18.0" 
$ns at 810.0425251485199 "$node_(71) setdest 57295 16989 4.0" 
$ns at 856.3731361276048 "$node_(71) setdest 54670 45490 19.0" 
$ns at 0.0 "$node_(72) setdest 92707 27477 11.0" 
$ns at 132.25185059940895 "$node_(72) setdest 34720 25193 10.0" 
$ns at 247.48559564158938 "$node_(72) setdest 3076 561 7.0" 
$ns at 329.2561485596974 "$node_(72) setdest 80782 24104 10.0" 
$ns at 403.55943225121734 "$node_(72) setdest 174910 821 4.0" 
$ns at 433.5784592680807 "$node_(72) setdest 163854 38790 4.0" 
$ns at 486.9835815527488 "$node_(72) setdest 187057 33711 19.0" 
$ns at 622.4475584766417 "$node_(72) setdest 162726 24193 12.0" 
$ns at 677.4157037330632 "$node_(72) setdest 51337 16885 18.0" 
$ns at 796.0874297316949 "$node_(72) setdest 244896 5981 17.0" 
$ns at 0.0 "$node_(73) setdest 43345 3876 9.0" 
$ns at 105.93877460261726 "$node_(73) setdest 19923 8588 4.0" 
$ns at 156.4933988899913 "$node_(73) setdest 58715 37396 17.0" 
$ns at 327.68130343630907 "$node_(73) setdest 42837 20456 6.0" 
$ns at 378.09447993867116 "$node_(73) setdest 51586 36289 19.0" 
$ns at 474.024325383825 "$node_(73) setdest 183692 28622 11.0" 
$ns at 600.5313679571863 "$node_(73) setdest 50084 56476 19.0" 
$ns at 743.9105407082995 "$node_(73) setdest 88554 50104 2.0" 
$ns at 774.302742057222 "$node_(73) setdest 362 27630 17.0" 
$ns at 814.8892275883986 "$node_(73) setdest 172794 6965 1.0" 
$ns at 845.9181057494641 "$node_(73) setdest 217074 82063 14.0" 
$ns at 0.0 "$node_(74) setdest 67442 26886 14.0" 
$ns at 73.62051376483598 "$node_(74) setdest 18099 4398 12.0" 
$ns at 195.60943514117162 "$node_(74) setdest 49355 27106 6.0" 
$ns at 275.1859349381971 "$node_(74) setdest 87998 23625 11.0" 
$ns at 306.3567482059759 "$node_(74) setdest 100804 2731 11.0" 
$ns at 365.25931387849863 "$node_(74) setdest 171177 56482 18.0" 
$ns at 405.92594642791795 "$node_(74) setdest 185364 47841 7.0" 
$ns at 450.13517976659983 "$node_(74) setdest 64793 36740 15.0" 
$ns at 595.7992268542677 "$node_(74) setdest 133901 61298 4.0" 
$ns at 660.5651797392568 "$node_(74) setdest 197154 67697 15.0" 
$ns at 754.2346448848555 "$node_(74) setdest 226630 52036 18.0" 
$ns at 827.6455431835072 "$node_(74) setdest 226353 74520 12.0" 
$ns at 0.0 "$node_(75) setdest 12661 24575 20.0" 
$ns at 63.76804163067448 "$node_(75) setdest 7193 4247 9.0" 
$ns at 166.94163028254545 "$node_(75) setdest 86878 3916 9.0" 
$ns at 222.057285723509 "$node_(75) setdest 11673 2908 16.0" 
$ns at 297.26727663970814 "$node_(75) setdest 69065 18545 20.0" 
$ns at 473.1005982157678 "$node_(75) setdest 3504 30422 12.0" 
$ns at 532.3844090456429 "$node_(75) setdest 60665 16270 3.0" 
$ns at 565.5938043598247 "$node_(75) setdest 60056 42391 14.0" 
$ns at 595.6433757073265 "$node_(75) setdest 12934 41676 11.0" 
$ns at 628.776788253167 "$node_(75) setdest 48302 6689 4.0" 
$ns at 695.8036733112151 "$node_(75) setdest 88939 62505 1.0" 
$ns at 728.1419431652897 "$node_(75) setdest 28950 25529 15.0" 
$ns at 833.3616182741722 "$node_(75) setdest 221608 31537 11.0" 
$ns at 888.9306889306953 "$node_(75) setdest 102414 48302 12.0" 
$ns at 0.0 "$node_(76) setdest 62900 10121 2.0" 
$ns at 45.96274155319219 "$node_(76) setdest 83001 2160 17.0" 
$ns at 163.064158481302 "$node_(76) setdest 89812 19692 1.0" 
$ns at 201.71211230933233 "$node_(76) setdest 13641 31468 11.0" 
$ns at 251.78927460451615 "$node_(76) setdest 51065 31167 14.0" 
$ns at 369.0994089109488 "$node_(76) setdest 59736 46733 4.0" 
$ns at 436.3157221766224 "$node_(76) setdest 87667 62502 6.0" 
$ns at 518.678746514587 "$node_(76) setdest 188708 6992 19.0" 
$ns at 640.3739783099098 "$node_(76) setdest 187728 29354 15.0" 
$ns at 808.2818212489855 "$node_(76) setdest 147527 73061 10.0" 
$ns at 0.0 "$node_(77) setdest 9768 4501 14.0" 
$ns at 112.1380844542283 "$node_(77) setdest 26282 6256 5.0" 
$ns at 160.22930016022622 "$node_(77) setdest 100633 2611 15.0" 
$ns at 208.88038482776966 "$node_(77) setdest 131989 12610 1.0" 
$ns at 248.5062199285726 "$node_(77) setdest 53895 23247 19.0" 
$ns at 292.74515750959756 "$node_(77) setdest 46557 25817 18.0" 
$ns at 497.88314373412095 "$node_(77) setdest 115298 58696 18.0" 
$ns at 599.269837604688 "$node_(77) setdest 218008 33569 6.0" 
$ns at 672.1895713467966 "$node_(77) setdest 66703 25362 12.0" 
$ns at 749.2625466892216 "$node_(77) setdest 205522 53902 15.0" 
$ns at 823.4039745868488 "$node_(77) setdest 182492 13748 5.0" 
$ns at 865.7554567729766 "$node_(77) setdest 122227 16602 12.0" 
$ns at 0.0 "$node_(78) setdest 65361 13162 16.0" 
$ns at 65.78163496954858 "$node_(78) setdest 48780 20797 13.0" 
$ns at 211.08436921185802 "$node_(78) setdest 8576 17015 9.0" 
$ns at 314.66576323889694 "$node_(78) setdest 128060 17644 5.0" 
$ns at 350.8405464796499 "$node_(78) setdest 7748 17879 17.0" 
$ns at 452.5898066102776 "$node_(78) setdest 100874 59280 13.0" 
$ns at 505.02572186415017 "$node_(78) setdest 188433 16963 14.0" 
$ns at 577.5757740644768 "$node_(78) setdest 2202 15923 14.0" 
$ns at 655.8384147009788 "$node_(78) setdest 39271 55730 9.0" 
$ns at 770.5451067338307 "$node_(78) setdest 124802 69326 12.0" 
$ns at 888.1336132670845 "$node_(78) setdest 151250 58902 18.0" 
$ns at 0.0 "$node_(79) setdest 41099 14077 18.0" 
$ns at 148.27016757227764 "$node_(79) setdest 68998 2915 19.0" 
$ns at 304.11845274400173 "$node_(79) setdest 1316 22024 7.0" 
$ns at 341.89161878571156 "$node_(79) setdest 32271 22502 19.0" 
$ns at 490.4862347564604 "$node_(79) setdest 6881 1493 5.0" 
$ns at 547.1180952789178 "$node_(79) setdest 104538 24972 10.0" 
$ns at 638.7354948751072 "$node_(79) setdest 214828 61152 7.0" 
$ns at 716.155249178965 "$node_(79) setdest 29620 8519 19.0" 
$ns at 0.0 "$node_(80) setdest 63204 11579 6.0" 
$ns at 57.5653078626148 "$node_(80) setdest 69503 18787 1.0" 
$ns at 88.55143603833054 "$node_(80) setdest 74763 4445 17.0" 
$ns at 280.9212888029108 "$node_(80) setdest 158659 53792 16.0" 
$ns at 314.06996193129555 "$node_(80) setdest 70587 49509 1.0" 
$ns at 354.0077065285242 "$node_(80) setdest 106235 30436 20.0" 
$ns at 420.34690080766154 "$node_(80) setdest 153622 31407 8.0" 
$ns at 451.12744993950326 "$node_(80) setdest 172384 6692 11.0" 
$ns at 558.9707107318336 "$node_(80) setdest 159778 42177 7.0" 
$ns at 594.7563078810174 "$node_(80) setdest 119684 73776 1.0" 
$ns at 625.9429268745404 "$node_(80) setdest 150368 50203 1.0" 
$ns at 659.352776172311 "$node_(80) setdest 213616 21226 8.0" 
$ns at 729.4228798363562 "$node_(80) setdest 71692 53298 12.0" 
$ns at 778.0595813844627 "$node_(80) setdest 257708 4433 13.0" 
$ns at 826.7380558570331 "$node_(80) setdest 171917 67409 18.0" 
$ns at 0.0 "$node_(81) setdest 11727 11251 1.0" 
$ns at 39.49473052688877 "$node_(81) setdest 41296 27802 12.0" 
$ns at 127.6377176729731 "$node_(81) setdest 73609 10529 8.0" 
$ns at 170.92555239213715 "$node_(81) setdest 130762 7386 5.0" 
$ns at 201.1823446586495 "$node_(81) setdest 108303 23374 3.0" 
$ns at 238.46083931045237 "$node_(81) setdest 104112 30582 12.0" 
$ns at 306.54850150478234 "$node_(81) setdest 140503 20701 8.0" 
$ns at 405.28540935808235 "$node_(81) setdest 50073 60764 18.0" 
$ns at 584.8200892480207 "$node_(81) setdest 127180 44640 15.0" 
$ns at 679.6209082453574 "$node_(81) setdest 28231 42059 17.0" 
$ns at 756.4749474000689 "$node_(81) setdest 242082 76326 7.0" 
$ns at 831.525317578238 "$node_(81) setdest 18029 61211 12.0" 
$ns at 0.0 "$node_(82) setdest 32482 10938 17.0" 
$ns at 165.99147705658496 "$node_(82) setdest 44000 27144 2.0" 
$ns at 206.49726835648528 "$node_(82) setdest 4035 30500 11.0" 
$ns at 243.63037650780043 "$node_(82) setdest 110755 35433 6.0" 
$ns at 322.5011528294523 "$node_(82) setdest 78896 16816 8.0" 
$ns at 422.25910909591823 "$node_(82) setdest 184670 52181 10.0" 
$ns at 473.89338065140043 "$node_(82) setdest 139730 55394 14.0" 
$ns at 513.1528212226156 "$node_(82) setdest 154148 21720 6.0" 
$ns at 556.5419157029824 "$node_(82) setdest 5489 4081 16.0" 
$ns at 678.3745348888747 "$node_(82) setdest 7950 61684 11.0" 
$ns at 784.4251908475317 "$node_(82) setdest 57554 80341 14.0" 
$ns at 0.0 "$node_(83) setdest 94424 5642 14.0" 
$ns at 140.941546742474 "$node_(83) setdest 33074 3050 7.0" 
$ns at 173.3060639950803 "$node_(83) setdest 48197 37013 14.0" 
$ns at 338.27695610606975 "$node_(83) setdest 21456 54508 5.0" 
$ns at 391.50345753040165 "$node_(83) setdest 20698 53777 10.0" 
$ns at 425.2655256349272 "$node_(83) setdest 43973 32102 15.0" 
$ns at 534.3985792961294 "$node_(83) setdest 63943 6556 12.0" 
$ns at 680.4673462575083 "$node_(83) setdest 162556 63535 5.0" 
$ns at 745.9652056215555 "$node_(83) setdest 110502 44885 1.0" 
$ns at 784.3332560730104 "$node_(83) setdest 265420 78556 16.0" 
$ns at 825.5852844279277 "$node_(83) setdest 264347 54319 3.0" 
$ns at 857.6906559942697 "$node_(83) setdest 245698 59330 2.0" 
$ns at 888.4610833989814 "$node_(83) setdest 220905 62797 19.0" 
$ns at 0.0 "$node_(84) setdest 15769 3887 7.0" 
$ns at 40.593971528358445 "$node_(84) setdest 74635 17311 8.0" 
$ns at 99.85706112297962 "$node_(84) setdest 85044 3779 20.0" 
$ns at 284.81809936438947 "$node_(84) setdest 90063 13828 14.0" 
$ns at 452.29841321159967 "$node_(84) setdest 58948 43081 1.0" 
$ns at 483.4368959559211 "$node_(84) setdest 100865 12029 18.0" 
$ns at 554.3112026128674 "$node_(84) setdest 131723 16667 16.0" 
$ns at 593.947960372891 "$node_(84) setdest 64916 71966 11.0" 
$ns at 712.3873898794243 "$node_(84) setdest 25071 10182 9.0" 
$ns at 803.5335370897158 "$node_(84) setdest 143125 22404 3.0" 
$ns at 852.5313771747077 "$node_(84) setdest 247630 47334 1.0" 
$ns at 886.4028049395279 "$node_(84) setdest 107624 36893 18.0" 
$ns at 0.0 "$node_(85) setdest 1010 4956 5.0" 
$ns at 35.83656732906733 "$node_(85) setdest 14255 15037 9.0" 
$ns at 134.71841440191204 "$node_(85) setdest 26987 16789 16.0" 
$ns at 169.1084997761053 "$node_(85) setdest 38578 28276 7.0" 
$ns at 214.97761081805658 "$node_(85) setdest 118603 2240 9.0" 
$ns at 294.9385276294645 "$node_(85) setdest 64870 16162 15.0" 
$ns at 380.6379929310297 "$node_(85) setdest 76127 3850 1.0" 
$ns at 419.1950526661499 "$node_(85) setdest 189645 49593 1.0" 
$ns at 457.99972422573643 "$node_(85) setdest 6962 30857 14.0" 
$ns at 619.925424170538 "$node_(85) setdest 14263 56549 2.0" 
$ns at 657.9411996565988 "$node_(85) setdest 215532 32954 7.0" 
$ns at 692.6252859633863 "$node_(85) setdest 227567 46331 12.0" 
$ns at 770.0727791000684 "$node_(85) setdest 188662 48324 16.0" 
$ns at 823.5960552657863 "$node_(85) setdest 185905 56995 16.0" 
$ns at 0.0 "$node_(86) setdest 27098 12137 6.0" 
$ns at 47.31764019309838 "$node_(86) setdest 69765 1519 13.0" 
$ns at 132.46818161522705 "$node_(86) setdest 58745 25300 9.0" 
$ns at 225.98789685446613 "$node_(86) setdest 37383 41657 11.0" 
$ns at 281.4477456406593 "$node_(86) setdest 141630 10443 10.0" 
$ns at 370.221555937887 "$node_(86) setdest 102986 59012 9.0" 
$ns at 489.63597283263283 "$node_(86) setdest 16917 22844 17.0" 
$ns at 641.1124437896389 "$node_(86) setdest 30029 20517 18.0" 
$ns at 747.7019401138562 "$node_(86) setdest 157469 7485 16.0" 
$ns at 0.0 "$node_(87) setdest 11011 8831 9.0" 
$ns at 54.2077752952771 "$node_(87) setdest 9866 21290 7.0" 
$ns at 109.74562425082584 "$node_(87) setdest 40404 20957 17.0" 
$ns at 307.1562725350541 "$node_(87) setdest 14978 47178 6.0" 
$ns at 348.23279608524336 "$node_(87) setdest 48960 33607 5.0" 
$ns at 420.27497271094416 "$node_(87) setdest 24585 31030 17.0" 
$ns at 556.3549863768412 "$node_(87) setdest 219960 47776 20.0" 
$ns at 750.4963316518172 "$node_(87) setdest 172327 23846 18.0" 
$ns at 851.9525932790234 "$node_(87) setdest 197993 60703 12.0" 
$ns at 885.3386450517914 "$node_(87) setdest 204054 39617 8.0" 
$ns at 0.0 "$node_(88) setdest 44326 4288 8.0" 
$ns at 71.1663335148979 "$node_(88) setdest 24697 3154 7.0" 
$ns at 156.54876414646932 "$node_(88) setdest 76306 17848 15.0" 
$ns at 292.04338819255213 "$node_(88) setdest 10859 502 12.0" 
$ns at 419.7409114046876 "$node_(88) setdest 64399 15906 7.0" 
$ns at 508.4620686779765 "$node_(88) setdest 5925 23091 9.0" 
$ns at 542.1106943314281 "$node_(88) setdest 108140 39213 6.0" 
$ns at 580.212339145775 "$node_(88) setdest 216351 46107 15.0" 
$ns at 716.5191149131949 "$node_(88) setdest 186506 40582 10.0" 
$ns at 801.3413834577793 "$node_(88) setdest 252980 71862 13.0" 
$ns at 842.1785075279448 "$node_(88) setdest 240121 59048 5.0" 
$ns at 889.7925268533311 "$node_(88) setdest 256407 43078 11.0" 
$ns at 0.0 "$node_(89) setdest 10961 24231 7.0" 
$ns at 95.7900997942659 "$node_(89) setdest 50424 2478 4.0" 
$ns at 141.4445449220958 "$node_(89) setdest 12043 17515 8.0" 
$ns at 213.5710819159598 "$node_(89) setdest 54612 4610 2.0" 
$ns at 250.3606084044686 "$node_(89) setdest 42101 17138 15.0" 
$ns at 382.90062892924266 "$node_(89) setdest 144890 48965 8.0" 
$ns at 423.51416614563016 "$node_(89) setdest 10985 12054 19.0" 
$ns at 619.6427055612147 "$node_(89) setdest 167768 12423 1.0" 
$ns at 651.6403055125787 "$node_(89) setdest 152342 80817 15.0" 
$ns at 744.845889066223 "$node_(89) setdest 192442 4513 11.0" 
$ns at 855.0756618077456 "$node_(89) setdest 213176 12864 16.0" 
$ns at 0.0 "$node_(90) setdest 5576 2024 18.0" 
$ns at 154.08242307967842 "$node_(90) setdest 27931 21550 19.0" 
$ns at 304.9692385605597 "$node_(90) setdest 138362 36587 13.0" 
$ns at 375.2057586608278 "$node_(90) setdest 81549 19849 11.0" 
$ns at 430.59606952958484 "$node_(90) setdest 76220 13278 4.0" 
$ns at 493.7246951299092 "$node_(90) setdest 176297 19949 7.0" 
$ns at 544.0973434866097 "$node_(90) setdest 59670 5897 7.0" 
$ns at 612.8619327396625 "$node_(90) setdest 46681 26591 10.0" 
$ns at 671.9207453731732 "$node_(90) setdest 179495 49165 5.0" 
$ns at 728.9920196348511 "$node_(90) setdest 197070 13347 7.0" 
$ns at 810.5400514749491 "$node_(90) setdest 129802 17466 8.0" 
$ns at 875.462649112299 "$node_(90) setdest 153389 21423 9.0" 
$ns at 0.0 "$node_(91) setdest 61545 6946 6.0" 
$ns at 47.100025668220745 "$node_(91) setdest 85562 13972 7.0" 
$ns at 104.29347432789555 "$node_(91) setdest 82962 3798 2.0" 
$ns at 141.52333122244653 "$node_(91) setdest 70386 22269 3.0" 
$ns at 193.09531575489308 "$node_(91) setdest 39400 41754 15.0" 
$ns at 270.5471965002499 "$node_(91) setdest 31902 6143 19.0" 
$ns at 429.0015980466525 "$node_(91) setdest 23404 36123 13.0" 
$ns at 483.95157761843296 "$node_(91) setdest 17442 47363 13.0" 
$ns at 614.4418973008137 "$node_(91) setdest 113685 74851 8.0" 
$ns at 653.1775890163325 "$node_(91) setdest 173464 32347 18.0" 
$ns at 819.5037596202664 "$node_(91) setdest 44123 28257 5.0" 
$ns at 883.270584745357 "$node_(91) setdest 266747 48578 19.0" 
$ns at 0.0 "$node_(92) setdest 17119 28438 17.0" 
$ns at 100.22582911184112 "$node_(92) setdest 90054 7868 1.0" 
$ns at 135.2871355041172 "$node_(92) setdest 49024 6817 5.0" 
$ns at 203.42431449754073 "$node_(92) setdest 93463 29332 6.0" 
$ns at 280.883765127915 "$node_(92) setdest 53656 23390 1.0" 
$ns at 315.45772822075736 "$node_(92) setdest 121450 24183 14.0" 
$ns at 382.9097042607085 "$node_(92) setdest 76917 21912 19.0" 
$ns at 474.1706550392105 "$node_(92) setdest 92977 29874 14.0" 
$ns at 588.1851657911258 "$node_(92) setdest 199825 35405 1.0" 
$ns at 626.1834074447999 "$node_(92) setdest 94725 32163 2.0" 
$ns at 673.8501725029681 "$node_(92) setdest 46061 58865 8.0" 
$ns at 763.7097323210907 "$node_(92) setdest 170379 63008 7.0" 
$ns at 806.1021215807034 "$node_(92) setdest 52633 3738 11.0" 
$ns at 871.250036336512 "$node_(92) setdest 111730 65642 2.0" 
$ns at 0.0 "$node_(93) setdest 52675 31186 19.0" 
$ns at 212.87051929050844 "$node_(93) setdest 58153 39455 1.0" 
$ns at 251.5378997883692 "$node_(93) setdest 130587 35198 17.0" 
$ns at 426.8349075971155 "$node_(93) setdest 105440 27680 1.0" 
$ns at 462.50948053721766 "$node_(93) setdest 21047 68262 18.0" 
$ns at 548.8828731251285 "$node_(93) setdest 42623 9477 10.0" 
$ns at 619.8367728583845 "$node_(93) setdest 62847 17516 1.0" 
$ns at 659.68341949014 "$node_(93) setdest 83936 72161 6.0" 
$ns at 737.9160145915134 "$node_(93) setdest 148820 78116 13.0" 
$ns at 880.5119279136043 "$node_(93) setdest 118107 37677 19.0" 
$ns at 0.0 "$node_(94) setdest 52722 21888 14.0" 
$ns at 93.93060841844328 "$node_(94) setdest 4302 13187 7.0" 
$ns at 135.71175935304765 "$node_(94) setdest 60515 23296 1.0" 
$ns at 171.6233247484238 "$node_(94) setdest 84583 30480 8.0" 
$ns at 237.54714920817264 "$node_(94) setdest 82332 5990 8.0" 
$ns at 328.0960649535659 "$node_(94) setdest 1129 44710 16.0" 
$ns at 485.9342816677987 "$node_(94) setdest 18166 62705 10.0" 
$ns at 610.2581989602548 "$node_(94) setdest 114879 56436 17.0" 
$ns at 794.3333644616603 "$node_(94) setdest 54149 38493 19.0" 
$ns at 886.3295213451876 "$node_(94) setdest 128767 24388 18.0" 
$ns at 0.0 "$node_(95) setdest 72513 8185 16.0" 
$ns at 84.06367187764639 "$node_(95) setdest 18056 11345 19.0" 
$ns at 123.14738920014379 "$node_(95) setdest 17718 21191 17.0" 
$ns at 309.71066984687957 "$node_(95) setdest 125016 7862 5.0" 
$ns at 383.07522365243574 "$node_(95) setdest 1216 54888 17.0" 
$ns at 416.6898300424015 "$node_(95) setdest 176626 10448 4.0" 
$ns at 479.6364742024099 "$node_(95) setdest 192972 64205 13.0" 
$ns at 589.8050136263955 "$node_(95) setdest 220839 41550 14.0" 
$ns at 625.7027996662753 "$node_(95) setdest 110761 17734 14.0" 
$ns at 772.5497149192605 "$node_(95) setdest 141379 49963 4.0" 
$ns at 814.9236187568808 "$node_(95) setdest 27447 67368 1.0" 
$ns at 854.5078057428217 "$node_(95) setdest 240903 33150 6.0" 
$ns at 889.9254741719496 "$node_(95) setdest 215033 71457 11.0" 
$ns at 0.0 "$node_(96) setdest 33888 15660 2.0" 
$ns at 39.578774218853326 "$node_(96) setdest 81011 9158 1.0" 
$ns at 77.12002396851028 "$node_(96) setdest 77936 12537 1.0" 
$ns at 107.2064950101369 "$node_(96) setdest 47277 7 14.0" 
$ns at 142.99232193883466 "$node_(96) setdest 25100 13020 20.0" 
$ns at 272.59933123126126 "$node_(96) setdest 21241 45359 9.0" 
$ns at 303.7807369863005 "$node_(96) setdest 17238 36755 1.0" 
$ns at 337.36135738455437 "$node_(96) setdest 116205 17902 6.0" 
$ns at 397.21109414684406 "$node_(96) setdest 166385 54860 18.0" 
$ns at 433.7182953077863 "$node_(96) setdest 63902 62689 10.0" 
$ns at 516.6225238662611 "$node_(96) setdest 162955 70101 16.0" 
$ns at 630.320700434885 "$node_(96) setdest 51359 2485 17.0" 
$ns at 660.3429598920875 "$node_(96) setdest 214509 32878 8.0" 
$ns at 698.2357609962779 "$node_(96) setdest 112475 52624 1.0" 
$ns at 734.3080511106153 "$node_(96) setdest 29126 65626 1.0" 
$ns at 771.7208397404546 "$node_(96) setdest 85439 80374 19.0" 
$ns at 828.9407585151268 "$node_(96) setdest 151205 4178 14.0" 
$ns at 0.0 "$node_(97) setdest 15942 2150 18.0" 
$ns at 108.61717544903027 "$node_(97) setdest 5795 30167 5.0" 
$ns at 158.70087901668757 "$node_(97) setdest 120285 26400 6.0" 
$ns at 218.01548826492348 "$node_(97) setdest 90379 7944 1.0" 
$ns at 249.27547259856345 "$node_(97) setdest 87939 8565 1.0" 
$ns at 285.34491634163305 "$node_(97) setdest 102360 10143 18.0" 
$ns at 335.74296463528873 "$node_(97) setdest 66525 4733 4.0" 
$ns at 389.4106068822105 "$node_(97) setdest 34894 56640 13.0" 
$ns at 489.83964345629283 "$node_(97) setdest 62562 60253 20.0" 
$ns at 573.5092192038386 "$node_(97) setdest 23991 15901 14.0" 
$ns at 609.5227195552521 "$node_(97) setdest 18489 54017 9.0" 
$ns at 722.5893127598696 "$node_(97) setdest 93448 62597 12.0" 
$ns at 834.7153809885262 "$node_(97) setdest 5125 10381 15.0" 
$ns at 0.0 "$node_(98) setdest 41397 15874 5.0" 
$ns at 31.1166579703181 "$node_(98) setdest 92878 5153 9.0" 
$ns at 77.57080470046955 "$node_(98) setdest 16332 3333 5.0" 
$ns at 152.63179900584657 "$node_(98) setdest 91496 37572 1.0" 
$ns at 192.14597789330324 "$node_(98) setdest 28972 44657 13.0" 
$ns at 342.41224234645074 "$node_(98) setdest 52546 18208 14.0" 
$ns at 444.0441318159092 "$node_(98) setdest 89923 47462 3.0" 
$ns at 497.3624714023257 "$node_(98) setdest 208487 5659 9.0" 
$ns at 577.166887744323 "$node_(98) setdest 208489 14423 17.0" 
$ns at 745.4251908246003 "$node_(98) setdest 153978 77522 19.0" 
$ns at 793.3206929159684 "$node_(98) setdest 228893 15932 15.0" 
$ns at 0.0 "$node_(99) setdest 41832 26280 19.0" 
$ns at 151.783419392377 "$node_(99) setdest 90556 9532 8.0" 
$ns at 210.02180647142293 "$node_(99) setdest 14009 39435 3.0" 
$ns at 259.7744510873467 "$node_(99) setdest 36671 5488 20.0" 
$ns at 363.1425522274875 "$node_(99) setdest 174805 37995 7.0" 
$ns at 403.3133169246366 "$node_(99) setdest 102004 27264 9.0" 
$ns at 433.31800214541875 "$node_(99) setdest 1546 49106 6.0" 
$ns at 485.4645126974211 "$node_(99) setdest 194247 46496 1.0" 
$ns at 523.0065999257697 "$node_(99) setdest 44698 22182 4.0" 
$ns at 555.4137567081298 "$node_(99) setdest 231600 69591 4.0" 
$ns at 603.6136537773392 "$node_(99) setdest 11745 64978 8.0" 
$ns at 682.8722582980441 "$node_(99) setdest 171827 70248 1.0" 
$ns at 719.7072569323082 "$node_(99) setdest 36403 4024 1.0" 
$ns at 750.8557341421802 "$node_(99) setdest 266229 30470 1.0" 
$ns at 789.7306063829653 "$node_(99) setdest 216772 3378 18.0" 
$ns at 854.837879166631 "$node_(99) setdest 36834 54629 15.0" 
$ns at 0.0 "$node_(100) setdest 105594 4679 13.0" 
$ns at 41.8641590152747 "$node_(100) setdest 63604 3033 11.0" 
$ns at 119.20996093937828 "$node_(100) setdest 32967 23858 5.0" 
$ns at 168.61484788641036 "$node_(100) setdest 12247 10896 19.0" 
$ns at 347.864290247971 "$node_(100) setdest 25491 49688 19.0" 
$ns at 432.19105653870554 "$node_(100) setdest 30170 22057 7.0" 
$ns at 493.23492935225374 "$node_(100) setdest 142041 37975 1.0" 
$ns at 527.5537038409078 "$node_(100) setdest 75638 25434 8.0" 
$ns at 634.303232368008 "$node_(100) setdest 617 18259 20.0" 
$ns at 787.5546621212961 "$node_(100) setdest 258448 66429 3.0" 
$ns at 818.9437916975071 "$node_(100) setdest 120553 39084 14.0" 
$ns at 120.65854264488438 "$node_(101) setdest 57954 28073 11.0" 
$ns at 196.97411370103057 "$node_(101) setdest 77800 19104 19.0" 
$ns at 301.1269966701192 "$node_(101) setdest 114629 25328 3.0" 
$ns at 336.24032515097184 "$node_(101) setdest 140807 5034 15.0" 
$ns at 457.4191083909555 "$node_(101) setdest 194921 17418 5.0" 
$ns at 506.6505247391238 "$node_(101) setdest 3572 28471 4.0" 
$ns at 549.6949815377876 "$node_(101) setdest 75902 49361 15.0" 
$ns at 703.4972556792452 "$node_(101) setdest 193665 58860 17.0" 
$ns at 765.6391321049985 "$node_(101) setdest 68799 27527 6.0" 
$ns at 839.4619696947549 "$node_(101) setdest 113311 23496 2.0" 
$ns at 886.6616835209649 "$node_(101) setdest 11633 84505 10.0" 
$ns at 141.6085681305292 "$node_(102) setdest 10493 18202 8.0" 
$ns at 242.87459159558213 "$node_(102) setdest 22059 41161 9.0" 
$ns at 322.8256704942666 "$node_(102) setdest 20943 2823 1.0" 
$ns at 359.0974508903278 "$node_(102) setdest 47636 2872 19.0" 
$ns at 400.67261488589105 "$node_(102) setdest 150773 20551 2.0" 
$ns at 438.4355452449389 "$node_(102) setdest 144065 49439 5.0" 
$ns at 500.42070932071204 "$node_(102) setdest 178627 60862 14.0" 
$ns at 618.6027513493092 "$node_(102) setdest 2654 4344 7.0" 
$ns at 674.0387829081292 "$node_(102) setdest 158818 19930 8.0" 
$ns at 754.0679608225738 "$node_(102) setdest 69018 10209 7.0" 
$ns at 820.6712500271674 "$node_(102) setdest 7648 81235 14.0" 
$ns at 131.60322751971142 "$node_(103) setdest 63282 19878 19.0" 
$ns at 262.4802568287645 "$node_(103) setdest 77945 2611 9.0" 
$ns at 326.3509211723527 "$node_(103) setdest 144312 36354 9.0" 
$ns at 443.2779251809595 "$node_(103) setdest 3721 14622 9.0" 
$ns at 526.7567184445941 "$node_(103) setdest 146722 4593 1.0" 
$ns at 557.4571322406829 "$node_(103) setdest 116752 1970 3.0" 
$ns at 596.9460378880532 "$node_(103) setdest 83988 32276 4.0" 
$ns at 663.8311240278099 "$node_(103) setdest 187426 49396 6.0" 
$ns at 694.752729522989 "$node_(103) setdest 67290 67182 8.0" 
$ns at 757.3595350153096 "$node_(103) setdest 203385 47749 10.0" 
$ns at 882.6767095720669 "$node_(103) setdest 132520 3677 11.0" 
$ns at 249.68716549129763 "$node_(104) setdest 73367 4310 12.0" 
$ns at 386.4346135596698 "$node_(104) setdest 137189 23838 13.0" 
$ns at 523.891913351793 "$node_(104) setdest 201598 29501 17.0" 
$ns at 553.9958253004102 "$node_(104) setdest 50490 39952 10.0" 
$ns at 651.6493024559672 "$node_(104) setdest 56280 23828 17.0" 
$ns at 834.4193714483827 "$node_(104) setdest 161032 16112 17.0" 
$ns at 248.7717149943734 "$node_(105) setdest 18014 34365 1.0" 
$ns at 287.86622138184595 "$node_(105) setdest 81820 21685 19.0" 
$ns at 411.7302240493371 "$node_(105) setdest 60048 7485 18.0" 
$ns at 463.9338344027433 "$node_(105) setdest 9875 24948 3.0" 
$ns at 512.3243932278142 "$node_(105) setdest 127382 49170 9.0" 
$ns at 599.6209647887335 "$node_(105) setdest 1082 30080 13.0" 
$ns at 709.5624183356759 "$node_(105) setdest 71443 14980 18.0" 
$ns at 748.6718618222629 "$node_(105) setdest 24295 44126 19.0" 
$ns at 823.0220683860545 "$node_(105) setdest 125283 81015 4.0" 
$ns at 867.2138698057745 "$node_(105) setdest 132367 56111 7.0" 
$ns at 199.6120224782173 "$node_(106) setdest 92577 21343 14.0" 
$ns at 274.0444253643748 "$node_(106) setdest 60305 18223 5.0" 
$ns at 311.1298063083501 "$node_(106) setdest 67480 4098 13.0" 
$ns at 385.37766888877326 "$node_(106) setdest 121293 8821 15.0" 
$ns at 468.84889155848015 "$node_(106) setdest 102155 7220 1.0" 
$ns at 502.0487545428017 "$node_(106) setdest 101837 40663 9.0" 
$ns at 581.2370864847256 "$node_(106) setdest 29345 19002 10.0" 
$ns at 660.6900856584384 "$node_(106) setdest 238508 21425 11.0" 
$ns at 722.4573005708519 "$node_(106) setdest 125985 66666 13.0" 
$ns at 870.5444451364517 "$node_(106) setdest 62995 29855 10.0" 
$ns at 131.64154845705826 "$node_(107) setdest 81020 385 4.0" 
$ns at 198.53282242081127 "$node_(107) setdest 13940 27600 13.0" 
$ns at 270.290123479478 "$node_(107) setdest 79947 11034 13.0" 
$ns at 408.3880822917025 "$node_(107) setdest 119719 41911 1.0" 
$ns at 443.73918921627984 "$node_(107) setdest 62563 57518 7.0" 
$ns at 513.5307486869099 "$node_(107) setdest 46952 36081 12.0" 
$ns at 594.3149204832155 "$node_(107) setdest 72657 68505 4.0" 
$ns at 642.8210076564162 "$node_(107) setdest 175817 40298 15.0" 
$ns at 719.349308157843 "$node_(107) setdest 137292 12538 3.0" 
$ns at 750.4424171223241 "$node_(107) setdest 186953 13933 10.0" 
$ns at 855.2936890545325 "$node_(107) setdest 6436 66389 17.0" 
$ns at 133.7715447389922 "$node_(108) setdest 61627 25290 8.0" 
$ns at 171.78597285878328 "$node_(108) setdest 65746 33533 13.0" 
$ns at 290.28101782292396 "$node_(108) setdest 99837 37861 14.0" 
$ns at 431.4631182354224 "$node_(108) setdest 35646 3568 20.0" 
$ns at 628.4448589337426 "$node_(108) setdest 224005 43977 18.0" 
$ns at 823.0797201982748 "$node_(108) setdest 22624 27769 5.0" 
$ns at 167.63001495223676 "$node_(109) setdest 57168 38315 3.0" 
$ns at 224.51141907168463 "$node_(109) setdest 33460 34435 18.0" 
$ns at 271.8970061188321 "$node_(109) setdest 100411 25871 3.0" 
$ns at 313.28143958986834 "$node_(109) setdest 13411 32591 16.0" 
$ns at 406.88634344487514 "$node_(109) setdest 97502 20626 5.0" 
$ns at 437.56441684960726 "$node_(109) setdest 114403 18241 15.0" 
$ns at 504.8234657632141 "$node_(109) setdest 139613 60222 7.0" 
$ns at 541.0757343346729 "$node_(109) setdest 133903 28329 11.0" 
$ns at 616.4943813169518 "$node_(109) setdest 189895 50099 9.0" 
$ns at 706.9212276516325 "$node_(109) setdest 168620 45668 9.0" 
$ns at 808.3836118899133 "$node_(109) setdest 234866 68242 5.0" 
$ns at 886.4734554590383 "$node_(109) setdest 29997 81685 11.0" 
$ns at 143.11902737403867 "$node_(110) setdest 64375 1784 7.0" 
$ns at 180.6599858368332 "$node_(110) setdest 132275 42642 3.0" 
$ns at 226.48040374341383 "$node_(110) setdest 72056 30675 18.0" 
$ns at 401.85229483237646 "$node_(110) setdest 147216 35572 8.0" 
$ns at 501.92783248384717 "$node_(110) setdest 186736 11468 3.0" 
$ns at 533.4868321172577 "$node_(110) setdest 136850 27106 12.0" 
$ns at 654.7976021137007 "$node_(110) setdest 232971 60743 12.0" 
$ns at 748.0471647327923 "$node_(110) setdest 158335 62113 4.0" 
$ns at 778.326529754142 "$node_(110) setdest 199859 75289 16.0" 
$ns at 111.30986069287984 "$node_(111) setdest 6750 16299 8.0" 
$ns at 159.7852411015207 "$node_(111) setdest 130182 6548 4.0" 
$ns at 191.99494785589383 "$node_(111) setdest 120396 2726 6.0" 
$ns at 224.22588339954225 "$node_(111) setdest 31176 8738 1.0" 
$ns at 260.2468530019661 "$node_(111) setdest 158027 50229 10.0" 
$ns at 314.98225309456564 "$node_(111) setdest 15760 4526 4.0" 
$ns at 380.0990846067752 "$node_(111) setdest 75495 9080 19.0" 
$ns at 481.37829877080736 "$node_(111) setdest 136407 62165 9.0" 
$ns at 548.756872089839 "$node_(111) setdest 86932 39683 18.0" 
$ns at 597.8551553712981 "$node_(111) setdest 194040 37529 1.0" 
$ns at 637.5292679174875 "$node_(111) setdest 199392 64522 15.0" 
$ns at 689.5739877382128 "$node_(111) setdest 56670 66450 1.0" 
$ns at 724.8913823509774 "$node_(111) setdest 234232 57191 13.0" 
$ns at 831.989781761816 "$node_(111) setdest 223839 53067 7.0" 
$ns at 889.0216172434943 "$node_(111) setdest 234201 66637 10.0" 
$ns at 165.0977405362757 "$node_(112) setdest 48022 37746 11.0" 
$ns at 242.8777089449805 "$node_(112) setdest 6055 8047 7.0" 
$ns at 303.4399484318261 "$node_(112) setdest 17074 29090 2.0" 
$ns at 340.2942780083698 "$node_(112) setdest 155153 13643 11.0" 
$ns at 408.8784675966874 "$node_(112) setdest 75722 22699 2.0" 
$ns at 447.65543000836266 "$node_(112) setdest 112599 19498 10.0" 
$ns at 575.7636727365484 "$node_(112) setdest 227739 22923 2.0" 
$ns at 609.0945270774148 "$node_(112) setdest 56767 62842 3.0" 
$ns at 665.1208093081693 "$node_(112) setdest 179521 54211 11.0" 
$ns at 701.9039245828901 "$node_(112) setdest 128031 15807 18.0" 
$ns at 871.6185974163348 "$node_(112) setdest 238096 18275 6.0" 
$ns at 163.12643583571779 "$node_(113) setdest 103361 5323 1.0" 
$ns at 194.2308517952602 "$node_(113) setdest 97391 41285 9.0" 
$ns at 244.59532838225093 "$node_(113) setdest 119384 41754 18.0" 
$ns at 440.2425043040529 "$node_(113) setdest 137423 11437 5.0" 
$ns at 518.948811097483 "$node_(113) setdest 19661 57710 6.0" 
$ns at 595.4733499554026 "$node_(113) setdest 135435 63574 17.0" 
$ns at 667.8851212058787 "$node_(113) setdest 178336 69514 9.0" 
$ns at 779.758279922888 "$node_(113) setdest 11603 52572 1.0" 
$ns at 812.8957484223914 "$node_(113) setdest 200934 83377 14.0" 
$ns at 123.99083975739805 "$node_(114) setdest 41962 29899 4.0" 
$ns at 179.00580343456355 "$node_(114) setdest 124221 17872 6.0" 
$ns at 223.9656874664737 "$node_(114) setdest 79757 11845 12.0" 
$ns at 349.8298317119319 "$node_(114) setdest 122508 25305 11.0" 
$ns at 461.2478845564184 "$node_(114) setdest 95275 32401 14.0" 
$ns at 499.38353787051676 "$node_(114) setdest 29330 7749 11.0" 
$ns at 569.8520884319673 "$node_(114) setdest 95999 27425 9.0" 
$ns at 600.1323099277572 "$node_(114) setdest 73303 48736 17.0" 
$ns at 773.6140435599007 "$node_(114) setdest 4048 24083 13.0" 
$ns at 170.139225637335 "$node_(115) setdest 51632 9737 4.0" 
$ns at 225.37637023651524 "$node_(115) setdest 35490 1000 5.0" 
$ns at 297.76190026190494 "$node_(115) setdest 5284 33452 8.0" 
$ns at 352.58899666004066 "$node_(115) setdest 36522 494 10.0" 
$ns at 478.5939315239894 "$node_(115) setdest 107623 39737 19.0" 
$ns at 509.17249835120975 "$node_(115) setdest 52212 38177 4.0" 
$ns at 556.0523462953537 "$node_(115) setdest 180190 12438 14.0" 
$ns at 615.4851025269504 "$node_(115) setdest 28196 40523 11.0" 
$ns at 695.374932274406 "$node_(115) setdest 96904 27260 5.0" 
$ns at 758.1236904345845 "$node_(115) setdest 215347 55526 8.0" 
$ns at 818.1109208677484 "$node_(115) setdest 206971 9494 15.0" 
$ns at 899.2740646987058 "$node_(115) setdest 117924 55069 11.0" 
$ns at 221.38721873042533 "$node_(116) setdest 79413 18576 5.0" 
$ns at 275.4526563853485 "$node_(116) setdest 42635 41783 17.0" 
$ns at 396.1283667733708 "$node_(116) setdest 30557 39215 16.0" 
$ns at 485.81652521472256 "$node_(116) setdest 111189 47529 4.0" 
$ns at 548.4638662029607 "$node_(116) setdest 15807 57600 12.0" 
$ns at 629.7135000277193 "$node_(116) setdest 130418 34249 14.0" 
$ns at 748.6691918541928 "$node_(116) setdest 214451 56285 11.0" 
$ns at 868.3983311607569 "$node_(116) setdest 114586 55605 3.0" 
$ns at 110.2854362816575 "$node_(117) setdest 91051 4223 5.0" 
$ns at 163.71948416702213 "$node_(117) setdest 109277 8258 5.0" 
$ns at 193.81955032909494 "$node_(117) setdest 72531 32305 6.0" 
$ns at 271.6288260526968 "$node_(117) setdest 327 21755 10.0" 
$ns at 330.19584437050054 "$node_(117) setdest 86050 35811 15.0" 
$ns at 395.795493235395 "$node_(117) setdest 186317 45782 6.0" 
$ns at 480.1057133493548 "$node_(117) setdest 114908 28524 14.0" 
$ns at 605.0650455062269 "$node_(117) setdest 90256 40682 7.0" 
$ns at 660.4942819758357 "$node_(117) setdest 36259 27024 5.0" 
$ns at 732.4354129726812 "$node_(117) setdest 164191 6381 1.0" 
$ns at 770.8908476497187 "$node_(117) setdest 128092 46839 4.0" 
$ns at 804.9151027443859 "$node_(117) setdest 198601 48073 13.0" 
$ns at 122.63260295955233 "$node_(118) setdest 14052 30793 8.0" 
$ns at 179.33753485841433 "$node_(118) setdest 56626 16438 11.0" 
$ns at 252.55874678499111 "$node_(118) setdest 50652 39819 9.0" 
$ns at 325.1765635852089 "$node_(118) setdest 16737 26986 3.0" 
$ns at 382.6666791145003 "$node_(118) setdest 55288 22759 16.0" 
$ns at 564.4240330653604 "$node_(118) setdest 75542 32741 19.0" 
$ns at 737.0450793777053 "$node_(118) setdest 196605 63938 12.0" 
$ns at 837.7323982213973 "$node_(118) setdest 213383 78390 18.0" 
$ns at 118.79292315438971 "$node_(119) setdest 6311 16157 12.0" 
$ns at 154.48998264467176 "$node_(119) setdest 103745 31845 6.0" 
$ns at 224.6102593715203 "$node_(119) setdest 114672 8587 10.0" 
$ns at 335.41575288264033 "$node_(119) setdest 55631 34035 11.0" 
$ns at 423.3647729435811 "$node_(119) setdest 116928 30065 2.0" 
$ns at 461.4850392866099 "$node_(119) setdest 21399 1706 10.0" 
$ns at 571.1891845449433 "$node_(119) setdest 227244 31848 20.0" 
$ns at 679.3948586469403 "$node_(119) setdest 67080 49520 7.0" 
$ns at 719.5041214886168 "$node_(119) setdest 213007 2959 13.0" 
$ns at 821.7350087481967 "$node_(119) setdest 52016 11464 12.0" 
$ns at 128.09426675448196 "$node_(120) setdest 65558 19943 5.0" 
$ns at 196.3779147876654 "$node_(120) setdest 69783 14970 7.0" 
$ns at 264.9567257308667 "$node_(120) setdest 50899 22844 1.0" 
$ns at 299.8972211383471 "$node_(120) setdest 82655 3563 12.0" 
$ns at 365.3356803412776 "$node_(120) setdest 154853 3364 4.0" 
$ns at 412.005767495372 "$node_(120) setdest 32794 44090 16.0" 
$ns at 443.76413791101794 "$node_(120) setdest 59107 4510 1.0" 
$ns at 476.7576081864507 "$node_(120) setdest 33392 37902 13.0" 
$ns at 547.8945396857126 "$node_(120) setdest 149491 50710 14.0" 
$ns at 629.3048529081057 "$node_(120) setdest 107764 6831 5.0" 
$ns at 678.0569681136876 "$node_(120) setdest 123928 17885 10.0" 
$ns at 761.9219489576952 "$node_(120) setdest 178150 47641 8.0" 
$ns at 820.8344937097669 "$node_(120) setdest 17175 25104 3.0" 
$ns at 855.8746109169583 "$node_(120) setdest 112626 70217 10.0" 
$ns at 124.60174933988509 "$node_(121) setdest 79354 17159 5.0" 
$ns at 158.79949777598995 "$node_(121) setdest 15887 33658 15.0" 
$ns at 243.5320806070847 "$node_(121) setdest 6685 18732 20.0" 
$ns at 444.4665764072279 "$node_(121) setdest 130332 55577 16.0" 
$ns at 555.4158600285466 "$node_(121) setdest 21015 28259 3.0" 
$ns at 598.0419577031053 "$node_(121) setdest 68491 17587 9.0" 
$ns at 679.3481840456119 "$node_(121) setdest 80117 40133 15.0" 
$ns at 765.122288344576 "$node_(121) setdest 138803 4159 13.0" 
$ns at 876.8921101924897 "$node_(121) setdest 190969 60495 14.0" 
$ns at 102.48873412897103 "$node_(122) setdest 49083 18416 2.0" 
$ns at 134.88121424287087 "$node_(122) setdest 37558 1896 4.0" 
$ns at 165.2672328314606 "$node_(122) setdest 57253 42330 3.0" 
$ns at 201.92466010809508 "$node_(122) setdest 56604 32728 12.0" 
$ns at 319.4730435164877 "$node_(122) setdest 109407 52791 14.0" 
$ns at 406.98376674463117 "$node_(122) setdest 83786 26582 10.0" 
$ns at 491.47015932036373 "$node_(122) setdest 118633 11946 14.0" 
$ns at 610.8627340287289 "$node_(122) setdest 223494 24677 4.0" 
$ns at 665.5649787595456 "$node_(122) setdest 214850 69498 17.0" 
$ns at 834.0051675544764 "$node_(122) setdest 226513 20970 5.0" 
$ns at 108.63873562522099 "$node_(123) setdest 86032 11392 14.0" 
$ns at 250.34512286410472 "$node_(123) setdest 99576 23956 16.0" 
$ns at 298.38460395021696 "$node_(123) setdest 31309 48433 1.0" 
$ns at 328.89273112699357 "$node_(123) setdest 151496 23861 13.0" 
$ns at 397.62693365405585 "$node_(123) setdest 160649 58899 1.0" 
$ns at 428.1848197981982 "$node_(123) setdest 84383 3978 6.0" 
$ns at 483.3978520684064 "$node_(123) setdest 181294 40368 2.0" 
$ns at 518.5997648311012 "$node_(123) setdest 198614 55000 16.0" 
$ns at 600.6660360991534 "$node_(123) setdest 5706 68320 12.0" 
$ns at 652.1065605563268 "$node_(123) setdest 118830 73379 20.0" 
$ns at 844.8258622879179 "$node_(123) setdest 266600 27834 7.0" 
$ns at 118.87435849302702 "$node_(124) setdest 16283 25738 15.0" 
$ns at 250.84844318452616 "$node_(124) setdest 99109 41865 9.0" 
$ns at 301.78222647997416 "$node_(124) setdest 138805 28279 15.0" 
$ns at 411.0214219203838 "$node_(124) setdest 14516 26686 17.0" 
$ns at 504.4808019724462 "$node_(124) setdest 189207 62678 11.0" 
$ns at 607.7877431565735 "$node_(124) setdest 224958 46825 5.0" 
$ns at 645.2700272834476 "$node_(124) setdest 191392 50522 1.0" 
$ns at 683.5507425964847 "$node_(124) setdest 82560 47376 12.0" 
$ns at 830.1710890012866 "$node_(124) setdest 26284 85515 8.0" 
$ns at 888.3419028001437 "$node_(124) setdest 3864 45642 5.0" 
$ns at 153.57012964348414 "$node_(125) setdest 133792 24495 18.0" 
$ns at 312.134996293893 "$node_(125) setdest 125752 28598 3.0" 
$ns at 355.24035702436635 "$node_(125) setdest 172482 24795 11.0" 
$ns at 487.32549725475906 "$node_(125) setdest 43132 54556 15.0" 
$ns at 612.372250472197 "$node_(125) setdest 30099 12200 17.0" 
$ns at 777.5839811367807 "$node_(125) setdest 204302 23250 12.0" 
$ns at 833.6622386323567 "$node_(125) setdest 222205 26423 1.0" 
$ns at 871.896106138999 "$node_(125) setdest 139951 10999 6.0" 
$ns at 115.82499157089863 "$node_(126) setdest 58075 30871 3.0" 
$ns at 152.4441650583223 "$node_(126) setdest 66093 18587 1.0" 
$ns at 191.77586189109155 "$node_(126) setdest 82235 40266 6.0" 
$ns at 223.60652413055638 "$node_(126) setdest 17157 40116 10.0" 
$ns at 325.21825386757195 "$node_(126) setdest 89205 30632 2.0" 
$ns at 370.20829972839124 "$node_(126) setdest 96875 18314 4.0" 
$ns at 405.80714895582923 "$node_(126) setdest 11996 12937 3.0" 
$ns at 436.0816476336222 "$node_(126) setdest 131015 23719 16.0" 
$ns at 517.199347743309 "$node_(126) setdest 49117 68308 5.0" 
$ns at 559.6443957337343 "$node_(126) setdest 177962 43636 8.0" 
$ns at 628.1277205817038 "$node_(126) setdest 130117 3139 17.0" 
$ns at 756.0585913121207 "$node_(126) setdest 175772 26278 18.0" 
$ns at 199.14656177494402 "$node_(127) setdest 63920 8121 9.0" 
$ns at 298.1105954336857 "$node_(127) setdest 122336 2143 13.0" 
$ns at 353.29154318076456 "$node_(127) setdest 144169 9914 13.0" 
$ns at 485.61635394709936 "$node_(127) setdest 127572 3891 9.0" 
$ns at 599.4843559034065 "$node_(127) setdest 47177 58701 2.0" 
$ns at 633.2384228241108 "$node_(127) setdest 12887 24928 6.0" 
$ns at 664.2904999808711 "$node_(127) setdest 209015 36309 5.0" 
$ns at 729.4000826609731 "$node_(127) setdest 163769 77591 16.0" 
$ns at 765.752322380866 "$node_(127) setdest 22093 81756 11.0" 
$ns at 862.2343058891266 "$node_(127) setdest 17363 88358 8.0" 
$ns at 149.98880005954356 "$node_(128) setdest 74054 11962 8.0" 
$ns at 209.87042883196762 "$node_(128) setdest 62713 12377 16.0" 
$ns at 384.0888165437526 "$node_(128) setdest 45990 34186 8.0" 
$ns at 437.8732998881366 "$node_(128) setdest 54979 54242 16.0" 
$ns at 548.2604362824285 "$node_(128) setdest 108994 69464 15.0" 
$ns at 676.425729947931 "$node_(128) setdest 131545 71312 14.0" 
$ns at 707.7681947708904 "$node_(128) setdest 203301 27608 4.0" 
$ns at 753.2617157125596 "$node_(128) setdest 92131 53401 14.0" 
$ns at 786.7008384301605 "$node_(128) setdest 126482 4318 16.0" 
$ns at 876.1261775678564 "$node_(128) setdest 64058 22722 20.0" 
$ns at 119.00281181474224 "$node_(129) setdest 46064 15166 14.0" 
$ns at 288.4712654851141 "$node_(129) setdest 121275 43682 16.0" 
$ns at 434.39442358915755 "$node_(129) setdest 43113 694 9.0" 
$ns at 468.7023165803928 "$node_(129) setdest 5512 55875 1.0" 
$ns at 504.14013118229565 "$node_(129) setdest 28444 46751 18.0" 
$ns at 693.0512503172017 "$node_(129) setdest 229414 41893 8.0" 
$ns at 790.0725771649445 "$node_(129) setdest 226576 41065 18.0" 
$ns at 838.5243638042241 "$node_(129) setdest 205830 15551 18.0" 
$ns at 124.73337074446867 "$node_(130) setdest 8948 22590 19.0" 
$ns at 193.44101865580404 "$node_(130) setdest 21454 1411 13.0" 
$ns at 295.0852705604354 "$node_(130) setdest 91666 7167 18.0" 
$ns at 466.33957180426154 "$node_(130) setdest 326 43328 12.0" 
$ns at 571.1900335936253 "$node_(130) setdest 195531 17630 14.0" 
$ns at 671.6940876514263 "$node_(130) setdest 76577 13387 17.0" 
$ns at 803.9349095646126 "$node_(130) setdest 107567 45036 15.0" 
$ns at 116.40782663568811 "$node_(131) setdest 50706 7699 1.0" 
$ns at 152.44749752944483 "$node_(131) setdest 42370 44591 17.0" 
$ns at 227.75626536627584 "$node_(131) setdest 128619 40763 3.0" 
$ns at 278.8514634831332 "$node_(131) setdest 112952 11026 8.0" 
$ns at 359.91223844454777 "$node_(131) setdest 105300 61795 2.0" 
$ns at 396.6633558541113 "$node_(131) setdest 137539 22925 8.0" 
$ns at 445.41323539095345 "$node_(131) setdest 89209 50798 12.0" 
$ns at 573.675422788142 "$node_(131) setdest 132309 26379 1.0" 
$ns at 609.6159679476149 "$node_(131) setdest 173173 41494 3.0" 
$ns at 643.8686191410856 "$node_(131) setdest 96123 42279 9.0" 
$ns at 762.6344535373989 "$node_(131) setdest 77606 51818 13.0" 
$ns at 108.71169388660009 "$node_(132) setdest 7281 17946 13.0" 
$ns at 183.29655402508502 "$node_(132) setdest 101224 16270 9.0" 
$ns at 277.43761237851004 "$node_(132) setdest 45303 3467 5.0" 
$ns at 337.17337025587926 "$node_(132) setdest 1530 27891 10.0" 
$ns at 376.5313513707144 "$node_(132) setdest 49839 30433 8.0" 
$ns at 463.9516029935385 "$node_(132) setdest 76997 15872 3.0" 
$ns at 521.9535380396047 "$node_(132) setdest 155451 68342 14.0" 
$ns at 662.6523059825295 "$node_(132) setdest 136139 78683 19.0" 
$ns at 713.5700342958557 "$node_(132) setdest 90689 18555 18.0" 
$ns at 892.9199184102528 "$node_(132) setdest 195847 33674 9.0" 
$ns at 108.55573804313349 "$node_(133) setdest 40858 11966 17.0" 
$ns at 140.3943929226976 "$node_(133) setdest 50177 3663 8.0" 
$ns at 225.2270321500357 "$node_(133) setdest 92325 30197 1.0" 
$ns at 262.7967838533551 "$node_(133) setdest 24612 32625 16.0" 
$ns at 411.2466787251374 "$node_(133) setdest 139209 7856 14.0" 
$ns at 509.459084877994 "$node_(133) setdest 21273 31756 12.0" 
$ns at 659.273261629937 "$node_(133) setdest 216407 35011 19.0" 
$ns at 702.7040724257992 "$node_(133) setdest 133097 42788 14.0" 
$ns at 795.6718769000039 "$node_(133) setdest 266771 43665 6.0" 
$ns at 834.6615517970101 "$node_(133) setdest 163681 63867 14.0" 
$ns at 111.13635554426074 "$node_(134) setdest 19329 14519 18.0" 
$ns at 225.56964926759167 "$node_(134) setdest 51660 29392 3.0" 
$ns at 279.83493940946056 "$node_(134) setdest 143199 1504 5.0" 
$ns at 315.4981890451852 "$node_(134) setdest 118745 4120 2.0" 
$ns at 349.26916455983667 "$node_(134) setdest 78736 23087 16.0" 
$ns at 387.9934982813545 "$node_(134) setdest 175361 29626 5.0" 
$ns at 457.13263816476905 "$node_(134) setdest 27251 53222 2.0" 
$ns at 504.84631223471933 "$node_(134) setdest 141020 35303 12.0" 
$ns at 608.1334191611918 "$node_(134) setdest 109443 32808 9.0" 
$ns at 670.4293994491724 "$node_(134) setdest 21300 22791 8.0" 
$ns at 757.6979144851027 "$node_(134) setdest 236130 84397 1.0" 
$ns at 790.3275596641041 "$node_(134) setdest 131386 24825 6.0" 
$ns at 845.2422979377096 "$node_(134) setdest 220676 69510 14.0" 
$ns at 878.9273902494042 "$node_(134) setdest 253631 51649 14.0" 
$ns at 122.8559929855245 "$node_(135) setdest 17026 15493 20.0" 
$ns at 230.05001421012423 "$node_(135) setdest 113078 8098 9.0" 
$ns at 339.1207224070231 "$node_(135) setdest 5326 37075 9.0" 
$ns at 402.61233008068575 "$node_(135) setdest 102651 39244 20.0" 
$ns at 534.9828635245703 "$node_(135) setdest 53354 2076 14.0" 
$ns at 647.4588405806866 "$node_(135) setdest 20541 2536 7.0" 
$ns at 683.1704005209335 "$node_(135) setdest 211048 27332 5.0" 
$ns at 744.4521773059564 "$node_(135) setdest 237782 15678 19.0" 
$ns at 841.596599187437 "$node_(135) setdest 113446 82181 14.0" 
$ns at 151.25007180383693 "$node_(136) setdest 94 16883 15.0" 
$ns at 326.59445392098337 "$node_(136) setdest 68141 36460 15.0" 
$ns at 443.61198494135397 "$node_(136) setdest 141736 57738 12.0" 
$ns at 565.8282854035133 "$node_(136) setdest 178536 41455 11.0" 
$ns at 598.4128539221231 "$node_(136) setdest 174194 12765 4.0" 
$ns at 666.6296715675089 "$node_(136) setdest 125198 43635 10.0" 
$ns at 701.0377414727838 "$node_(136) setdest 134226 63812 1.0" 
$ns at 732.4704174961905 "$node_(136) setdest 146179 32930 17.0" 
$ns at 766.489216292974 "$node_(136) setdest 236248 73783 13.0" 
$ns at 805.6332651067356 "$node_(136) setdest 204118 51379 1.0" 
$ns at 840.5400342196749 "$node_(136) setdest 155199 82971 7.0" 
$ns at 872.8352708444953 "$node_(136) setdest 94623 53324 7.0" 
$ns at 115.20854580912888 "$node_(137) setdest 86766 21281 2.0" 
$ns at 161.31781773107997 "$node_(137) setdest 55999 24750 18.0" 
$ns at 275.11538202971917 "$node_(137) setdest 74969 34552 19.0" 
$ns at 447.81512761457236 "$node_(137) setdest 152443 45744 5.0" 
$ns at 519.1894494208533 "$node_(137) setdest 35788 48270 15.0" 
$ns at 557.7535400495854 "$node_(137) setdest 9299 16385 1.0" 
$ns at 591.3585859615729 "$node_(137) setdest 202727 60899 5.0" 
$ns at 630.1782506478429 "$node_(137) setdest 4456 40153 8.0" 
$ns at 725.6886152043547 "$node_(137) setdest 160987 48035 18.0" 
$ns at 782.0836287733027 "$node_(137) setdest 87949 41244 1.0" 
$ns at 821.8656794416703 "$node_(137) setdest 83541 8360 5.0" 
$ns at 882.6005552929682 "$node_(137) setdest 262411 4371 3.0" 
$ns at 165.3297155945359 "$node_(138) setdest 86427 38024 9.0" 
$ns at 200.5404560943093 "$node_(138) setdest 128650 37676 2.0" 
$ns at 231.2721623725302 "$node_(138) setdest 83092 34209 13.0" 
$ns at 328.02708173486144 "$node_(138) setdest 129519 26335 17.0" 
$ns at 396.2573895062078 "$node_(138) setdest 25347 14322 9.0" 
$ns at 459.30749541907 "$node_(138) setdest 89292 68954 6.0" 
$ns at 510.3820710328718 "$node_(138) setdest 78202 68903 9.0" 
$ns at 596.3967610215287 "$node_(138) setdest 151388 59145 6.0" 
$ns at 681.3465807282482 "$node_(138) setdest 242235 37825 13.0" 
$ns at 726.4120039335044 "$node_(138) setdest 188223 35155 17.0" 
$ns at 773.0051815809196 "$node_(138) setdest 137511 79327 11.0" 
$ns at 862.7012247383797 "$node_(138) setdest 182557 88201 15.0" 
$ns at 137.41837721000525 "$node_(139) setdest 40952 3295 18.0" 
$ns at 291.7444719306896 "$node_(139) setdest 39419 24330 12.0" 
$ns at 338.06542459029185 "$node_(139) setdest 6941 3896 8.0" 
$ns at 397.86200687648085 "$node_(139) setdest 57869 55301 15.0" 
$ns at 443.13016395125635 "$node_(139) setdest 28627 10769 1.0" 
$ns at 481.55176238228034 "$node_(139) setdest 151379 49200 10.0" 
$ns at 514.2953034102811 "$node_(139) setdest 33111 63507 4.0" 
$ns at 571.5945516893788 "$node_(139) setdest 184190 52011 1.0" 
$ns at 603.1237613134277 "$node_(139) setdest 73307 73439 9.0" 
$ns at 673.6928320676899 "$node_(139) setdest 85719 59500 1.0" 
$ns at 706.3590725979071 "$node_(139) setdest 92214 5407 19.0" 
$ns at 849.3432935601735 "$node_(139) setdest 200993 86660 10.0" 
$ns at 119.59149779918644 "$node_(140) setdest 44851 15403 18.0" 
$ns at 217.95026683693732 "$node_(140) setdest 47918 29536 1.0" 
$ns at 248.45236124423258 "$node_(140) setdest 121142 9422 14.0" 
$ns at 360.71691889990507 "$node_(140) setdest 166435 41903 11.0" 
$ns at 397.0867260795905 "$node_(140) setdest 130920 22559 15.0" 
$ns at 467.9742233644932 "$node_(140) setdest 74014 57756 3.0" 
$ns at 499.85161196866613 "$node_(140) setdest 7225 56221 12.0" 
$ns at 633.5623614285324 "$node_(140) setdest 8108 9904 3.0" 
$ns at 693.4741756712657 "$node_(140) setdest 48085 31847 14.0" 
$ns at 750.003867012222 "$node_(140) setdest 12044 1597 18.0" 
$ns at 868.7358287913604 "$node_(140) setdest 164571 44089 9.0" 
$ns at 143.98705561775643 "$node_(141) setdest 73103 27776 8.0" 
$ns at 180.37621496232637 "$node_(141) setdest 32277 36858 6.0" 
$ns at 223.42302274243326 "$node_(141) setdest 16991 35002 5.0" 
$ns at 292.3244447923699 "$node_(141) setdest 130455 2510 15.0" 
$ns at 449.81937721685955 "$node_(141) setdest 182294 38701 10.0" 
$ns at 574.125068523529 "$node_(141) setdest 126321 50444 5.0" 
$ns at 606.7584416221176 "$node_(141) setdest 325 47287 4.0" 
$ns at 662.131697112572 "$node_(141) setdest 18242 6919 4.0" 
$ns at 724.2195542857114 "$node_(141) setdest 19040 24614 6.0" 
$ns at 761.2075266660416 "$node_(141) setdest 235792 61608 15.0" 
$ns at 131.26758107735156 "$node_(142) setdest 4688 5667 10.0" 
$ns at 257.07026705323847 "$node_(142) setdest 68815 28884 4.0" 
$ns at 295.36273927170083 "$node_(142) setdest 10743 41412 7.0" 
$ns at 347.7260329091308 "$node_(142) setdest 162380 19764 12.0" 
$ns at 433.89552180056785 "$node_(142) setdest 109235 14821 11.0" 
$ns at 510.45561803425346 "$node_(142) setdest 93576 70108 5.0" 
$ns at 575.7258838968296 "$node_(142) setdest 49837 46137 14.0" 
$ns at 633.8268067423644 "$node_(142) setdest 194333 70472 1.0" 
$ns at 673.6883471567096 "$node_(142) setdest 12867 33015 2.0" 
$ns at 704.4269373176036 "$node_(142) setdest 153126 56916 6.0" 
$ns at 783.8506437449399 "$node_(142) setdest 41008 13448 11.0" 
$ns at 873.8466013272749 "$node_(142) setdest 233536 88822 15.0" 
$ns at 118.20233643697766 "$node_(143) setdest 89973 17474 1.0" 
$ns at 153.05201471990347 "$node_(143) setdest 27119 31712 18.0" 
$ns at 227.25109711781408 "$node_(143) setdest 87852 8622 17.0" 
$ns at 357.92540861906997 "$node_(143) setdest 17178 11349 12.0" 
$ns at 507.09816869574473 "$node_(143) setdest 141157 2150 8.0" 
$ns at 553.6022658198845 "$node_(143) setdest 201388 690 6.0" 
$ns at 583.8203151095591 "$node_(143) setdest 68899 65820 16.0" 
$ns at 728.1921927282998 "$node_(143) setdest 8225 78747 8.0" 
$ns at 829.8900057189364 "$node_(143) setdest 84104 6379 3.0" 
$ns at 873.3713110758526 "$node_(143) setdest 254192 70466 5.0" 
$ns at 150.87528697890048 "$node_(144) setdest 75725 35006 14.0" 
$ns at 263.1205671353716 "$node_(144) setdest 85026 9984 17.0" 
$ns at 409.8550700560302 "$node_(144) setdest 95365 31932 6.0" 
$ns at 488.5454678495523 "$node_(144) setdest 209577 17788 12.0" 
$ns at 570.3932762954748 "$node_(144) setdest 209010 27603 19.0" 
$ns at 617.6724748635712 "$node_(144) setdest 10950 65778 6.0" 
$ns at 668.5160901742669 "$node_(144) setdest 190497 69881 13.0" 
$ns at 705.1890023688983 "$node_(144) setdest 134243 42672 19.0" 
$ns at 891.1980741291871 "$node_(144) setdest 201088 8106 19.0" 
$ns at 155.80903449733538 "$node_(145) setdest 88252 22302 18.0" 
$ns at 278.4845621729134 "$node_(145) setdest 139312 40909 20.0" 
$ns at 435.6460558514277 "$node_(145) setdest 181871 15663 6.0" 
$ns at 467.82975916941047 "$node_(145) setdest 209108 41535 16.0" 
$ns at 515.5666901721445 "$node_(145) setdest 43149 12041 19.0" 
$ns at 659.8063375442024 "$node_(145) setdest 237547 4765 19.0" 
$ns at 725.9916568087951 "$node_(145) setdest 47515 26104 18.0" 
$ns at 130.0741946691307 "$node_(146) setdest 10579 30765 8.0" 
$ns at 182.23918893686655 "$node_(146) setdest 58849 21905 8.0" 
$ns at 261.63977164513085 "$node_(146) setdest 26115 11605 11.0" 
$ns at 314.9222347788305 "$node_(146) setdest 15990 53350 6.0" 
$ns at 360.3720452267327 "$node_(146) setdest 49072 3269 5.0" 
$ns at 415.02686880842333 "$node_(146) setdest 106496 10167 2.0" 
$ns at 448.0037122905305 "$node_(146) setdest 175825 55163 15.0" 
$ns at 525.5088052712396 "$node_(146) setdest 175707 50704 10.0" 
$ns at 612.8461820585758 "$node_(146) setdest 100437 56628 2.0" 
$ns at 652.7644395660055 "$node_(146) setdest 36599 47553 3.0" 
$ns at 710.2558784332728 "$node_(146) setdest 183700 50180 3.0" 
$ns at 751.5482489183503 "$node_(146) setdest 38278 53951 12.0" 
$ns at 813.1101433708216 "$node_(146) setdest 236558 67355 9.0" 
$ns at 891.1471450836534 "$node_(146) setdest 2728 55411 19.0" 
$ns at 208.5321100549101 "$node_(147) setdest 22773 4389 12.0" 
$ns at 293.37234615452996 "$node_(147) setdest 45394 47161 2.0" 
$ns at 335.95189124206547 "$node_(147) setdest 32209 28954 10.0" 
$ns at 419.62708154464474 "$node_(147) setdest 111296 9091 2.0" 
$ns at 453.2900405413506 "$node_(147) setdest 175147 62796 16.0" 
$ns at 597.4179781781588 "$node_(147) setdest 26335 32435 11.0" 
$ns at 717.3838865000691 "$node_(147) setdest 122308 30786 9.0" 
$ns at 806.1930261921233 "$node_(147) setdest 15514 54526 9.0" 
$ns at 898.7377347999802 "$node_(147) setdest 79896 77856 16.0" 
$ns at 132.6424630823963 "$node_(148) setdest 72003 23982 20.0" 
$ns at 267.78948637804615 "$node_(148) setdest 116316 53992 16.0" 
$ns at 415.1274374902114 "$node_(148) setdest 162080 29267 14.0" 
$ns at 572.2193597948512 "$node_(148) setdest 129772 75525 5.0" 
$ns at 610.0842545001624 "$node_(148) setdest 91764 58121 10.0" 
$ns at 674.614625996734 "$node_(148) setdest 227438 43170 13.0" 
$ns at 816.0299888898044 "$node_(148) setdest 264000 39665 19.0" 
$ns at 860.3946764808894 "$node_(148) setdest 23722 12340 2.0" 
$ns at 149.3220754643658 "$node_(149) setdest 57222 17587 8.0" 
$ns at 256.48159517397744 "$node_(149) setdest 71103 15842 10.0" 
$ns at 310.7374418930668 "$node_(149) setdest 142198 32665 18.0" 
$ns at 477.79110864973484 "$node_(149) setdest 30404 44162 15.0" 
$ns at 610.6797791562115 "$node_(149) setdest 39512 50373 6.0" 
$ns at 645.2108483560846 "$node_(149) setdest 124222 38765 7.0" 
$ns at 677.3629060164707 "$node_(149) setdest 163442 49632 12.0" 
$ns at 797.674407435129 "$node_(149) setdest 61267 86123 11.0" 
$ns at 891.3492341534093 "$node_(149) setdest 158560 56823 15.0" 
$ns at 124.3749326387316 "$node_(150) setdest 89624 11648 10.0" 
$ns at 193.38116181411925 "$node_(150) setdest 89557 24301 19.0" 
$ns at 407.0083389913899 "$node_(150) setdest 58145 55548 11.0" 
$ns at 465.79733818524363 "$node_(150) setdest 111578 10862 6.0" 
$ns at 532.9920678701693 "$node_(150) setdest 134133 17658 19.0" 
$ns at 662.7654139743414 "$node_(150) setdest 14370 51964 16.0" 
$ns at 741.3586916973525 "$node_(150) setdest 83441 36899 16.0" 
$ns at 120.36299074524928 "$node_(151) setdest 25220 4986 14.0" 
$ns at 280.3139636836547 "$node_(151) setdest 104095 52309 4.0" 
$ns at 347.799309698349 "$node_(151) setdest 158637 45461 8.0" 
$ns at 436.9461828389624 "$node_(151) setdest 18960 18567 12.0" 
$ns at 561.1420540550124 "$node_(151) setdest 172170 3767 15.0" 
$ns at 605.6970773564153 "$node_(151) setdest 54619 891 16.0" 
$ns at 700.8447460608709 "$node_(151) setdest 196044 76021 14.0" 
$ns at 842.8190665850784 "$node_(151) setdest 160606 20235 6.0" 
$ns at 139.2578518103764 "$node_(152) setdest 43137 15471 12.0" 
$ns at 214.65038280254603 "$node_(152) setdest 32643 21265 17.0" 
$ns at 392.7318963209659 "$node_(152) setdest 28026 62428 6.0" 
$ns at 431.2838610454238 "$node_(152) setdest 19769 1805 9.0" 
$ns at 464.7282004785146 "$node_(152) setdest 192075 54370 10.0" 
$ns at 561.5315614754279 "$node_(152) setdest 40214 74473 6.0" 
$ns at 604.935593974607 "$node_(152) setdest 210061 28225 16.0" 
$ns at 694.5182316979074 "$node_(152) setdest 140811 74487 5.0" 
$ns at 724.7367654108223 "$node_(152) setdest 169269 33822 3.0" 
$ns at 758.309397186111 "$node_(152) setdest 154097 16997 16.0" 
$ns at 801.184562315199 "$node_(152) setdest 49533 9653 10.0" 
$ns at 860.062960258609 "$node_(152) setdest 207506 33931 20.0" 
$ns at 141.87787141613285 "$node_(153) setdest 56707 14964 11.0" 
$ns at 271.8037697602409 "$node_(153) setdest 150800 30406 19.0" 
$ns at 423.3505421237102 "$node_(153) setdest 36022 3147 10.0" 
$ns at 478.3644823565536 "$node_(153) setdest 107868 1074 15.0" 
$ns at 634.7623283219158 "$node_(153) setdest 138997 36628 7.0" 
$ns at 669.8098659138711 "$node_(153) setdest 231452 21996 7.0" 
$ns at 737.3042020264871 "$node_(153) setdest 138602 39593 2.0" 
$ns at 773.4649185649128 "$node_(153) setdest 119843 29715 9.0" 
$ns at 862.0908307810213 "$node_(153) setdest 259948 29969 3.0" 
$ns at 103.10691281233136 "$node_(154) setdest 94761 16110 15.0" 
$ns at 218.72601065690466 "$node_(154) setdest 97695 29916 3.0" 
$ns at 269.21274973701316 "$node_(154) setdest 24954 3940 1.0" 
$ns at 300.01033698173904 "$node_(154) setdest 161741 53540 17.0" 
$ns at 458.5549218792013 "$node_(154) setdest 119522 33477 5.0" 
$ns at 522.3924655349023 "$node_(154) setdest 204434 59196 17.0" 
$ns at 595.1733545487141 "$node_(154) setdest 99126 14381 2.0" 
$ns at 630.1663162442495 "$node_(154) setdest 204359 64045 10.0" 
$ns at 691.2249701268607 "$node_(154) setdest 180361 47967 7.0" 
$ns at 748.8373163940475 "$node_(154) setdest 22691 2943 20.0" 
$ns at 796.4556475947979 "$node_(154) setdest 166684 50799 1.0" 
$ns at 833.2499958754884 "$node_(154) setdest 246336 10853 7.0" 
$ns at 884.609135459078 "$node_(154) setdest 51401 63165 3.0" 
$ns at 224.7834087363466 "$node_(155) setdest 68897 36239 1.0" 
$ns at 257.8106073353047 "$node_(155) setdest 103243 28732 5.0" 
$ns at 297.2072581736476 "$node_(155) setdest 139679 48952 7.0" 
$ns at 377.3136232001697 "$node_(155) setdest 80828 16996 1.0" 
$ns at 412.4613701669048 "$node_(155) setdest 108785 7856 4.0" 
$ns at 475.0343121572258 "$node_(155) setdest 140839 15965 1.0" 
$ns at 508.5819537424822 "$node_(155) setdest 51554 51194 13.0" 
$ns at 610.5885800867379 "$node_(155) setdest 141766 36654 18.0" 
$ns at 712.4443567869603 "$node_(155) setdest 234861 26455 12.0" 
$ns at 839.008902295722 "$node_(155) setdest 213002 37876 12.0" 
$ns at 134.5268061640101 "$node_(156) setdest 51784 19011 1.0" 
$ns at 173.86797641070834 "$node_(156) setdest 80176 5168 9.0" 
$ns at 242.95864711220761 "$node_(156) setdest 64719 1363 9.0" 
$ns at 360.26382611448435 "$node_(156) setdest 80720 6979 1.0" 
$ns at 397.9752706657634 "$node_(156) setdest 85971 40974 4.0" 
$ns at 460.9694992033088 "$node_(156) setdest 13155 30552 9.0" 
$ns at 537.2545354896235 "$node_(156) setdest 29939 15131 12.0" 
$ns at 674.4538665219029 "$node_(156) setdest 68812 33960 8.0" 
$ns at 726.1375385984843 "$node_(156) setdest 82192 81610 4.0" 
$ns at 769.3261172885017 "$node_(156) setdest 178101 55805 4.0" 
$ns at 837.6986972518024 "$node_(156) setdest 110555 33629 14.0" 
$ns at 189.27240660165143 "$node_(157) setdest 114725 11440 8.0" 
$ns at 259.91734910403227 "$node_(157) setdest 139408 14524 12.0" 
$ns at 391.8762850470771 "$node_(157) setdest 135386 20650 10.0" 
$ns at 501.7604490851663 "$node_(157) setdest 77653 36467 15.0" 
$ns at 613.0922258922584 "$node_(157) setdest 94525 58664 2.0" 
$ns at 657.7676239500952 "$node_(157) setdest 204223 54369 16.0" 
$ns at 712.5942874006955 "$node_(157) setdest 234848 83382 14.0" 
$ns at 880.2112783279724 "$node_(157) setdest 59396 33452 17.0" 
$ns at 132.1116568386051 "$node_(158) setdest 93403 7197 11.0" 
$ns at 183.1786199992994 "$node_(158) setdest 10532 5084 10.0" 
$ns at 304.49511448961596 "$node_(158) setdest 47916 28355 17.0" 
$ns at 482.9245946386184 "$node_(158) setdest 99159 68013 2.0" 
$ns at 526.3359375305954 "$node_(158) setdest 203388 70484 9.0" 
$ns at 607.722725014749 "$node_(158) setdest 180006 69444 12.0" 
$ns at 697.7218570497669 "$node_(158) setdest 9406 28718 4.0" 
$ns at 736.1652634940438 "$node_(158) setdest 203495 22057 14.0" 
$ns at 874.0853563902915 "$node_(158) setdest 61149 4039 12.0" 
$ns at 172.8400357716342 "$node_(159) setdest 103832 29261 9.0" 
$ns at 213.3721651800225 "$node_(159) setdest 17032 30826 14.0" 
$ns at 355.75426829273727 "$node_(159) setdest 112907 43411 11.0" 
$ns at 467.61057499772835 "$node_(159) setdest 149080 10587 1.0" 
$ns at 500.04643136131403 "$node_(159) setdest 210658 19348 9.0" 
$ns at 600.5706664121625 "$node_(159) setdest 75939 45727 3.0" 
$ns at 651.4195164401222 "$node_(159) setdest 99000 52040 4.0" 
$ns at 716.2629354547701 "$node_(159) setdest 46769 23663 1.0" 
$ns at 754.940984361821 "$node_(159) setdest 69452 72859 12.0" 
$ns at 795.9125491961311 "$node_(159) setdest 101988 87649 5.0" 
$ns at 853.3467097533302 "$node_(159) setdest 145771 7839 4.0" 
$ns at 142.28241080680277 "$node_(160) setdest 89476 26669 2.0" 
$ns at 180.07373580649772 "$node_(160) setdest 48414 33059 17.0" 
$ns at 248.4171326089894 "$node_(160) setdest 1594 43248 12.0" 
$ns at 373.50261865682137 "$node_(160) setdest 62240 2401 10.0" 
$ns at 432.270890997695 "$node_(160) setdest 32945 35375 4.0" 
$ns at 485.41520175033895 "$node_(160) setdest 64994 32750 6.0" 
$ns at 548.1408131655562 "$node_(160) setdest 111021 67071 18.0" 
$ns at 663.7037124020661 "$node_(160) setdest 152216 3520 6.0" 
$ns at 709.7937247073301 "$node_(160) setdest 201741 41616 14.0" 
$ns at 860.314935042667 "$node_(160) setdest 231247 42775 1.0" 
$ns at 893.6159616689541 "$node_(160) setdest 149682 8939 15.0" 
$ns at 123.67266167767436 "$node_(161) setdest 20461 16437 8.0" 
$ns at 158.0807604040222 "$node_(161) setdest 89259 13346 6.0" 
$ns at 192.3032954028987 "$node_(161) setdest 24548 15552 3.0" 
$ns at 246.5248384068459 "$node_(161) setdest 31692 33665 6.0" 
$ns at 323.607261009766 "$node_(161) setdest 40695 33162 20.0" 
$ns at 509.72882864168366 "$node_(161) setdest 3546 52871 16.0" 
$ns at 590.9658335667976 "$node_(161) setdest 121454 71282 18.0" 
$ns at 738.1928059783042 "$node_(161) setdest 124979 44722 12.0" 
$ns at 774.0462243387926 "$node_(161) setdest 84203 79029 14.0" 
$ns at 834.399144677179 "$node_(161) setdest 142242 10047 17.0" 
$ns at 139.8937765560105 "$node_(162) setdest 31560 1989 17.0" 
$ns at 286.1312472356143 "$node_(162) setdest 151580 47041 3.0" 
$ns at 336.0474337244091 "$node_(162) setdest 25358 36864 1.0" 
$ns at 372.3852693664528 "$node_(162) setdest 183511 388 9.0" 
$ns at 436.05260346500603 "$node_(162) setdest 127540 58505 3.0" 
$ns at 480.02537281670544 "$node_(162) setdest 39785 21505 16.0" 
$ns at 527.2396143903644 "$node_(162) setdest 172890 68124 8.0" 
$ns at 561.379064847422 "$node_(162) setdest 22990 71025 5.0" 
$ns at 612.9771421931306 "$node_(162) setdest 78386 32404 9.0" 
$ns at 648.4091932532095 "$node_(162) setdest 232179 67432 12.0" 
$ns at 795.6412836774764 "$node_(162) setdest 172413 85158 3.0" 
$ns at 845.1469398456117 "$node_(162) setdest 248512 45252 6.0" 
$ns at 890.0035136221896 "$node_(162) setdest 257185 74617 3.0" 
$ns at 259.84032721473193 "$node_(163) setdest 13264 30970 3.0" 
$ns at 304.80184047853277 "$node_(163) setdest 42619 30947 10.0" 
$ns at 395.1020837527211 "$node_(163) setdest 164505 5201 14.0" 
$ns at 476.43975732883484 "$node_(163) setdest 15844 12925 10.0" 
$ns at 533.1457267054861 "$node_(163) setdest 53845 66897 16.0" 
$ns at 589.9223215025023 "$node_(163) setdest 11307 20262 12.0" 
$ns at 656.4017586009411 "$node_(163) setdest 137318 22675 5.0" 
$ns at 711.0027507390892 "$node_(163) setdest 73920 83416 18.0" 
$ns at 128.89161695014724 "$node_(164) setdest 34800 22841 2.0" 
$ns at 160.72078842996456 "$node_(164) setdest 113366 32826 3.0" 
$ns at 203.0784727822248 "$node_(164) setdest 16154 14103 1.0" 
$ns at 240.84320706105234 "$node_(164) setdest 94183 14935 9.0" 
$ns at 316.97622095313324 "$node_(164) setdest 15627 26874 6.0" 
$ns at 351.0416335490267 "$node_(164) setdest 106928 5229 12.0" 
$ns at 448.6574868240271 "$node_(164) setdest 181696 24688 17.0" 
$ns at 550.2447045909219 "$node_(164) setdest 38699 57752 9.0" 
$ns at 644.2370267260928 "$node_(164) setdest 196444 29263 8.0" 
$ns at 693.4662290247768 "$node_(164) setdest 203962 6222 16.0" 
$ns at 749.9548940009647 "$node_(164) setdest 230579 45360 12.0" 
$ns at 791.0471607550755 "$node_(164) setdest 65626 9895 6.0" 
$ns at 833.6301985230498 "$node_(164) setdest 55438 7092 15.0" 
$ns at 104.72757385126152 "$node_(165) setdest 63558 23077 7.0" 
$ns at 141.8242960695536 "$node_(165) setdest 87772 5175 10.0" 
$ns at 177.11201488853214 "$node_(165) setdest 47992 11402 8.0" 
$ns at 278.09150203648977 "$node_(165) setdest 61577 46387 16.0" 
$ns at 429.11921575030084 "$node_(165) setdest 122967 7785 9.0" 
$ns at 486.4138669662749 "$node_(165) setdest 135224 27093 2.0" 
$ns at 535.3462823312573 "$node_(165) setdest 146549 32805 13.0" 
$ns at 578.107976675631 "$node_(165) setdest 127623 43657 16.0" 
$ns at 621.3329278634669 "$node_(165) setdest 4001 66290 1.0" 
$ns at 661.2398012025717 "$node_(165) setdest 38394 68345 7.0" 
$ns at 730.2887425188285 "$node_(165) setdest 144608 52897 10.0" 
$ns at 803.7173265003318 "$node_(165) setdest 106784 35384 13.0" 
$ns at 162.4161657748536 "$node_(166) setdest 25697 44559 5.0" 
$ns at 229.8046998175974 "$node_(166) setdest 119931 10205 12.0" 
$ns at 265.94602895578186 "$node_(166) setdest 41775 52542 13.0" 
$ns at 398.55678479533935 "$node_(166) setdest 83581 18144 20.0" 
$ns at 435.36696418224403 "$node_(166) setdest 28087 55342 3.0" 
$ns at 483.43594651326845 "$node_(166) setdest 138892 39056 14.0" 
$ns at 547.034952336064 "$node_(166) setdest 124478 27948 12.0" 
$ns at 606.2428760242908 "$node_(166) setdest 33997 51015 11.0" 
$ns at 725.9492270380234 "$node_(166) setdest 83270 11616 14.0" 
$ns at 756.9350216883349 "$node_(166) setdest 31162 61287 19.0" 
$ns at 796.345474508256 "$node_(166) setdest 171301 54574 11.0" 
$ns at 854.1065048235571 "$node_(166) setdest 56740 61968 10.0" 
$ns at 184.40432311672282 "$node_(167) setdest 82217 26059 7.0" 
$ns at 233.55155296102464 "$node_(167) setdest 48445 28861 1.0" 
$ns at 272.1683721312696 "$node_(167) setdest 60148 42272 12.0" 
$ns at 387.8444969740734 "$node_(167) setdest 90898 25637 9.0" 
$ns at 499.422887976032 "$node_(167) setdest 32580 67099 20.0" 
$ns at 657.2128001335053 "$node_(167) setdest 24762 53220 12.0" 
$ns at 703.2960835806779 "$node_(167) setdest 219477 14904 8.0" 
$ns at 751.4095977271842 "$node_(167) setdest 213734 13173 14.0" 
$ns at 870.2903139494153 "$node_(167) setdest 129595 86693 5.0" 
$ns at 112.2971400477029 "$node_(168) setdest 78576 19085 8.0" 
$ns at 183.58311223008081 "$node_(168) setdest 114803 34160 13.0" 
$ns at 214.38117337312391 "$node_(168) setdest 12273 14664 13.0" 
$ns at 347.55440885879716 "$node_(168) setdest 28263 21026 19.0" 
$ns at 432.27206536656445 "$node_(168) setdest 100379 41489 19.0" 
$ns at 586.7017295909371 "$node_(168) setdest 163169 2915 12.0" 
$ns at 646.4802197591151 "$node_(168) setdest 111134 20451 1.0" 
$ns at 678.0817815644598 "$node_(168) setdest 104115 48402 8.0" 
$ns at 752.564875577374 "$node_(168) setdest 223340 19682 9.0" 
$ns at 850.805843520248 "$node_(168) setdest 146319 39262 1.0" 
$ns at 888.3666902135892 "$node_(168) setdest 118670 47852 19.0" 
$ns at 137.05646204306603 "$node_(169) setdest 9768 7234 3.0" 
$ns at 174.2784557761479 "$node_(169) setdest 56919 31833 13.0" 
$ns at 211.98405260063853 "$node_(169) setdest 38778 23548 3.0" 
$ns at 259.72879395257246 "$node_(169) setdest 125644 15627 18.0" 
$ns at 404.205105333128 "$node_(169) setdest 165499 48610 14.0" 
$ns at 489.7017296918988 "$node_(169) setdest 84738 21663 9.0" 
$ns at 528.1630085552456 "$node_(169) setdest 143124 37529 3.0" 
$ns at 560.1967912519156 "$node_(169) setdest 212849 54111 12.0" 
$ns at 666.7038323070142 "$node_(169) setdest 207300 44978 7.0" 
$ns at 737.8858662472127 "$node_(169) setdest 206106 19312 17.0" 
$ns at 788.8661433410745 "$node_(169) setdest 175922 64492 4.0" 
$ns at 840.0505593104618 "$node_(169) setdest 60748 88663 1.0" 
$ns at 876.038933357827 "$node_(169) setdest 9267 31894 15.0" 
$ns at 100.76914727519865 "$node_(170) setdest 23254 28149 14.0" 
$ns at 181.6922206762673 "$node_(170) setdest 120580 36775 1.0" 
$ns at 214.23348831054614 "$node_(170) setdest 95880 14269 15.0" 
$ns at 267.8497141361902 "$node_(170) setdest 36731 43831 19.0" 
$ns at 394.6015016051461 "$node_(170) setdest 36483 15198 2.0" 
$ns at 428.86337316895793 "$node_(170) setdest 42883 47957 15.0" 
$ns at 459.40884624124715 "$node_(170) setdest 42938 65712 10.0" 
$ns at 497.3847501851775 "$node_(170) setdest 149203 3815 12.0" 
$ns at 577.1611203492688 "$node_(170) setdest 198956 4846 1.0" 
$ns at 611.3611697901433 "$node_(170) setdest 209170 6369 12.0" 
$ns at 679.1312235258356 "$node_(170) setdest 88657 79275 14.0" 
$ns at 798.7386971590548 "$node_(170) setdest 233537 8770 9.0" 
$ns at 171.09649043644527 "$node_(171) setdest 66792 16012 10.0" 
$ns at 254.07870477531486 "$node_(171) setdest 48608 265 19.0" 
$ns at 439.7080720876889 "$node_(171) setdest 96655 2417 7.0" 
$ns at 539.4679806393187 "$node_(171) setdest 8402 38764 14.0" 
$ns at 672.7961330112955 "$node_(171) setdest 141731 32518 15.0" 
$ns at 710.4883286989277 "$node_(171) setdest 42200 55294 18.0" 
$ns at 169.1099088612069 "$node_(172) setdest 58923 19462 20.0" 
$ns at 228.19666864727384 "$node_(172) setdest 74343 29404 7.0" 
$ns at 277.271892126906 "$node_(172) setdest 152663 22925 17.0" 
$ns at 411.3523953186907 "$node_(172) setdest 80237 12510 8.0" 
$ns at 480.23909305745553 "$node_(172) setdest 1999 69202 16.0" 
$ns at 605.9034118003816 "$node_(172) setdest 186766 51173 1.0" 
$ns at 640.6249563150145 "$node_(172) setdest 58700 15116 20.0" 
$ns at 712.708236661047 "$node_(172) setdest 171827 63310 13.0" 
$ns at 842.4580071881909 "$node_(172) setdest 26219 57361 11.0" 
$ns at 889.4986483880481 "$node_(172) setdest 108875 77837 3.0" 
$ns at 152.20068272089833 "$node_(173) setdest 21283 642 11.0" 
$ns at 201.51357985638825 "$node_(173) setdest 16099 7063 6.0" 
$ns at 252.23999826483188 "$node_(173) setdest 131060 2374 5.0" 
$ns at 308.2656252874337 "$node_(173) setdest 145969 46062 4.0" 
$ns at 371.01391582986554 "$node_(173) setdest 13084 11926 1.0" 
$ns at 404.4644042951039 "$node_(173) setdest 64187 60353 18.0" 
$ns at 508.5227572272792 "$node_(173) setdest 28916 42188 17.0" 
$ns at 555.6746159700149 "$node_(173) setdest 121209 4597 19.0" 
$ns at 731.7850847796662 "$node_(173) setdest 227010 25079 2.0" 
$ns at 773.0736547743902 "$node_(173) setdest 189084 55235 10.0" 
$ns at 897.6748756374832 "$node_(173) setdest 223317 82615 11.0" 
$ns at 174.24403055432535 "$node_(174) setdest 124710 32369 3.0" 
$ns at 218.10676523151375 "$node_(174) setdest 29497 23043 5.0" 
$ns at 255.64951946851255 "$node_(174) setdest 120925 22964 15.0" 
$ns at 286.6956944528328 "$node_(174) setdest 147858 217 13.0" 
$ns at 344.4286875659906 "$node_(174) setdest 90496 31334 6.0" 
$ns at 424.6486891475485 "$node_(174) setdest 53177 56403 4.0" 
$ns at 460.7697433373789 "$node_(174) setdest 153701 33457 2.0" 
$ns at 498.11284860876094 "$node_(174) setdest 18570 7748 17.0" 
$ns at 592.3834448796058 "$node_(174) setdest 213137 26941 1.0" 
$ns at 632.2846178297601 "$node_(174) setdest 130016 30727 4.0" 
$ns at 668.8639414125633 "$node_(174) setdest 194488 62018 2.0" 
$ns at 708.4510735989984 "$node_(174) setdest 180012 32552 7.0" 
$ns at 805.6101845718657 "$node_(174) setdest 227584 21772 14.0" 
$ns at 164.5761737352793 "$node_(175) setdest 58035 3726 2.0" 
$ns at 213.06807100494314 "$node_(175) setdest 62836 1604 17.0" 
$ns at 408.1924119209816 "$node_(175) setdest 170169 38833 12.0" 
$ns at 534.1764701804176 "$node_(175) setdest 141397 1140 4.0" 
$ns at 597.1300723170426 "$node_(175) setdest 5188 68144 13.0" 
$ns at 658.7425549522538 "$node_(175) setdest 180438 51973 17.0" 
$ns at 811.2509490204243 "$node_(175) setdest 92650 37265 11.0" 
$ns at 192.0803472321095 "$node_(176) setdest 31500 30811 14.0" 
$ns at 312.2930404601401 "$node_(176) setdest 159152 5788 12.0" 
$ns at 459.9021636380635 "$node_(176) setdest 43374 49567 18.0" 
$ns at 615.7694789326704 "$node_(176) setdest 174982 19880 9.0" 
$ns at 693.9353827214861 "$node_(176) setdest 184433 55275 10.0" 
$ns at 734.0503509071771 "$node_(176) setdest 6805 71299 11.0" 
$ns at 827.7303094527197 "$node_(176) setdest 7330 36227 8.0" 
$ns at 885.4518220621239 "$node_(176) setdest 150161 80850 18.0" 
$ns at 171.1661270043206 "$node_(177) setdest 99482 21206 3.0" 
$ns at 212.39350777926444 "$node_(177) setdest 34357 34247 19.0" 
$ns at 431.8878729874512 "$node_(177) setdest 150816 19397 9.0" 
$ns at 464.41245807024563 "$node_(177) setdest 46133 36601 1.0" 
$ns at 502.2373868676641 "$node_(177) setdest 114397 1358 9.0" 
$ns at 605.0352523686701 "$node_(177) setdest 126519 28151 15.0" 
$ns at 647.6235193818067 "$node_(177) setdest 185312 36496 11.0" 
$ns at 748.1790814661651 "$node_(177) setdest 221889 78950 3.0" 
$ns at 789.4760495884727 "$node_(177) setdest 207316 15184 19.0" 
$ns at 886.6661660895876 "$node_(177) setdest 242244 72708 5.0" 
$ns at 102.8796164548934 "$node_(178) setdest 45382 19981 3.0" 
$ns at 157.26227062116232 "$node_(178) setdest 75041 19501 11.0" 
$ns at 207.41335418932016 "$node_(178) setdest 55165 1081 13.0" 
$ns at 281.1410708886971 "$node_(178) setdest 10929 25461 17.0" 
$ns at 446.6368412663237 "$node_(178) setdest 68979 21324 14.0" 
$ns at 489.2737073503712 "$node_(178) setdest 10503 3950 14.0" 
$ns at 641.2399683920199 "$node_(178) setdest 228484 61533 17.0" 
$ns at 801.7904450546396 "$node_(178) setdest 4650 28598 15.0" 
$ns at 897.5960460438265 "$node_(178) setdest 112256 69624 19.0" 
$ns at 120.75233909077912 "$node_(179) setdest 64580 7339 5.0" 
$ns at 187.88745203607104 "$node_(179) setdest 15328 36953 19.0" 
$ns at 264.0982336421444 "$node_(179) setdest 92808 22804 10.0" 
$ns at 391.27447651720377 "$node_(179) setdest 91773 18514 4.0" 
$ns at 438.0787359346949 "$node_(179) setdest 14984 32474 20.0" 
$ns at 632.5034342940439 "$node_(179) setdest 170363 40284 20.0" 
$ns at 758.2669745402729 "$node_(179) setdest 160051 72731 1.0" 
$ns at 797.1118214781814 "$node_(179) setdest 67470 1762 8.0" 
$ns at 159.7760055639037 "$node_(180) setdest 38584 4471 13.0" 
$ns at 286.4435346507301 "$node_(180) setdest 132683 4076 14.0" 
$ns at 341.5922048725327 "$node_(180) setdest 145294 3769 7.0" 
$ns at 386.8798372915387 "$node_(180) setdest 74820 32388 15.0" 
$ns at 463.8643268202794 "$node_(180) setdest 180168 31642 7.0" 
$ns at 506.8897089549803 "$node_(180) setdest 195665 61725 16.0" 
$ns at 686.9173942244132 "$node_(180) setdest 149999 46747 12.0" 
$ns at 824.2715134253116 "$node_(180) setdest 7823 33524 2.0" 
$ns at 857.1979043344793 "$node_(180) setdest 253324 9162 15.0" 
$ns at 145.4636504165914 "$node_(181) setdest 17213 18411 18.0" 
$ns at 291.2828655626439 "$node_(181) setdest 145641 11436 3.0" 
$ns at 334.72833170485325 "$node_(181) setdest 3873 38128 16.0" 
$ns at 390.464456752046 "$node_(181) setdest 113583 52230 11.0" 
$ns at 521.6494038119595 "$node_(181) setdest 52416 3890 2.0" 
$ns at 570.4156793338512 "$node_(181) setdest 85288 38226 15.0" 
$ns at 696.8123578675189 "$node_(181) setdest 28365 70390 8.0" 
$ns at 766.9205831121715 "$node_(181) setdest 91418 46923 3.0" 
$ns at 811.4135534275646 "$node_(181) setdest 241615 24339 20.0" 
$ns at 123.47205689427376 "$node_(182) setdest 29711 30717 2.0" 
$ns at 164.59913972753378 "$node_(182) setdest 45707 29995 18.0" 
$ns at 329.6862604278962 "$node_(182) setdest 63343 16567 8.0" 
$ns at 437.4931284257381 "$node_(182) setdest 77133 43277 1.0" 
$ns at 469.4136075986901 "$node_(182) setdest 184066 28518 11.0" 
$ns at 554.9770209530742 "$node_(182) setdest 205620 23265 10.0" 
$ns at 588.745433455436 "$node_(182) setdest 121078 25468 2.0" 
$ns at 633.0992483029227 "$node_(182) setdest 190137 71560 8.0" 
$ns at 692.1813235279003 "$node_(182) setdest 171100 82882 7.0" 
$ns at 780.7151170095661 "$node_(182) setdest 246378 44727 14.0" 
$ns at 108.1888242473421 "$node_(183) setdest 25647 8938 4.0" 
$ns at 176.9768393930629 "$node_(183) setdest 1351 31784 17.0" 
$ns at 296.8960493881552 "$node_(183) setdest 41692 6206 15.0" 
$ns at 451.76850796185556 "$node_(183) setdest 199378 10365 15.0" 
$ns at 506.5957965932721 "$node_(183) setdest 109700 65460 4.0" 
$ns at 565.604783731204 "$node_(183) setdest 47756 27448 3.0" 
$ns at 607.7398250987922 "$node_(183) setdest 220092 55506 7.0" 
$ns at 705.6739820779947 "$node_(183) setdest 173193 1036 9.0" 
$ns at 798.1838579225258 "$node_(183) setdest 190076 24170 5.0" 
$ns at 831.8463332723178 "$node_(183) setdest 101486 65589 3.0" 
$ns at 869.917768726452 "$node_(183) setdest 53608 34231 1.0" 
$ns at 176.45669194027403 "$node_(184) setdest 2855 10078 16.0" 
$ns at 251.2845861893099 "$node_(184) setdest 22201 43647 15.0" 
$ns at 428.9858356346915 "$node_(184) setdest 6278 29204 14.0" 
$ns at 480.8735245658302 "$node_(184) setdest 186661 53577 3.0" 
$ns at 532.7232893765782 "$node_(184) setdest 178136 69381 2.0" 
$ns at 578.5469541727007 "$node_(184) setdest 10248 1000 6.0" 
$ns at 620.7099887954075 "$node_(184) setdest 65215 28041 18.0" 
$ns at 673.1752668457985 "$node_(184) setdest 18381 65296 1.0" 
$ns at 706.6988093793582 "$node_(184) setdest 190599 35797 10.0" 
$ns at 812.44851868774 "$node_(184) setdest 204247 9339 15.0" 
$ns at 847.924172920652 "$node_(184) setdest 132466 45659 12.0" 
$ns at 126.6286035668298 "$node_(185) setdest 19764 3746 5.0" 
$ns at 175.56124356426852 "$node_(185) setdest 70071 12083 12.0" 
$ns at 252.37924351101296 "$node_(185) setdest 41387 54496 10.0" 
$ns at 381.1158493294364 "$node_(185) setdest 161975 26565 5.0" 
$ns at 460.6828087254929 "$node_(185) setdest 64095 23120 6.0" 
$ns at 512.4560947510695 "$node_(185) setdest 57784 22246 17.0" 
$ns at 679.0132849863908 "$node_(185) setdest 88163 5196 2.0" 
$ns at 717.8298076935931 "$node_(185) setdest 71377 76873 19.0" 
$ns at 768.7678997026718 "$node_(185) setdest 196778 41085 12.0" 
$ns at 855.2157432157517 "$node_(185) setdest 37177 85790 6.0" 
$ns at 201.38991569764443 "$node_(186) setdest 82169 42469 9.0" 
$ns at 319.0969420104909 "$node_(186) setdest 106522 9200 18.0" 
$ns at 472.50798308466756 "$node_(186) setdest 124900 35293 19.0" 
$ns at 629.6725940374404 "$node_(186) setdest 63523 32757 9.0" 
$ns at 737.7165736569409 "$node_(186) setdest 142385 17385 5.0" 
$ns at 778.4540995815877 "$node_(186) setdest 261763 56342 4.0" 
$ns at 839.7330165044045 "$node_(186) setdest 109974 89278 15.0" 
$ns at 138.77282722895524 "$node_(187) setdest 68099 1067 10.0" 
$ns at 226.10479142575628 "$node_(187) setdest 20789 41816 13.0" 
$ns at 349.8870512165451 "$node_(187) setdest 43725 39601 19.0" 
$ns at 546.689278134688 "$node_(187) setdest 138769 53897 10.0" 
$ns at 578.1492463731853 "$node_(187) setdest 175772 20583 11.0" 
$ns at 620.7079306649438 "$node_(187) setdest 113634 72278 8.0" 
$ns at 699.599227854223 "$node_(187) setdest 181175 8760 6.0" 
$ns at 736.6194431387014 "$node_(187) setdest 46693 50690 19.0" 
$ns at 281.7978636949674 "$node_(188) setdest 124629 47364 10.0" 
$ns at 372.6609805130985 "$node_(188) setdest 95452 14793 16.0" 
$ns at 403.5738893075173 "$node_(188) setdest 132841 40949 1.0" 
$ns at 437.31185217430976 "$node_(188) setdest 107315 51888 4.0" 
$ns at 482.8950038330228 "$node_(188) setdest 114029 351 12.0" 
$ns at 556.1098859101339 "$node_(188) setdest 187035 76577 9.0" 
$ns at 653.0725605324694 "$node_(188) setdest 140903 83533 3.0" 
$ns at 692.5586677401125 "$node_(188) setdest 147997 74460 20.0" 
$ns at 783.8153722927698 "$node_(188) setdest 158095 45086 11.0" 
$ns at 832.9213168011863 "$node_(188) setdest 34560 43433 1.0" 
$ns at 867.1369609270669 "$node_(188) setdest 60388 15758 5.0" 
$ns at 185.72406376620114 "$node_(189) setdest 11609 14974 6.0" 
$ns at 232.53844149787002 "$node_(189) setdest 129031 26782 13.0" 
$ns at 380.1221853157871 "$node_(189) setdest 141923 59400 11.0" 
$ns at 517.99654461248 "$node_(189) setdest 124387 35908 14.0" 
$ns at 654.3319562983847 "$node_(189) setdest 163472 16217 19.0" 
$ns at 764.5508199266803 "$node_(189) setdest 7049 24844 17.0" 
$ns at 865.3925236674825 "$node_(189) setdest 268124 42806 2.0" 
$ns at 140.0023293845537 "$node_(190) setdest 43784 8624 10.0" 
$ns at 220.3318781503151 "$node_(190) setdest 47835 11681 9.0" 
$ns at 260.36025217028225 "$node_(190) setdest 62715 24738 1.0" 
$ns at 291.23437797612286 "$node_(190) setdest 156683 28740 6.0" 
$ns at 350.5776070866584 "$node_(190) setdest 18612 6271 2.0" 
$ns at 399.1962669027554 "$node_(190) setdest 90869 17824 11.0" 
$ns at 483.8343597566992 "$node_(190) setdest 20752 37453 6.0" 
$ns at 550.1034025836367 "$node_(190) setdest 214604 7388 18.0" 
$ns at 687.3189258366706 "$node_(190) setdest 152560 56673 7.0" 
$ns at 751.9243609470545 "$node_(190) setdest 2230 13360 18.0" 
$ns at 866.1589947254306 "$node_(190) setdest 121307 36340 12.0" 
$ns at 897.0653731261649 "$node_(190) setdest 146885 38473 14.0" 
$ns at 118.93089297824524 "$node_(191) setdest 77008 12481 14.0" 
$ns at 153.61430158064906 "$node_(191) setdest 1681 1278 1.0" 
$ns at 184.9314261335651 "$node_(191) setdest 32297 29861 7.0" 
$ns at 221.7989052332099 "$node_(191) setdest 16900 12917 3.0" 
$ns at 274.17060447856034 "$node_(191) setdest 114300 8048 19.0" 
$ns at 327.80458885068555 "$node_(191) setdest 135616 26926 17.0" 
$ns at 507.38798220136886 "$node_(191) setdest 4918 130 6.0" 
$ns at 586.1149291566039 "$node_(191) setdest 39125 43479 11.0" 
$ns at 709.1375071169833 "$node_(191) setdest 230108 2632 5.0" 
$ns at 788.7038412202999 "$node_(191) setdest 62389 55685 19.0" 
$ns at 115.40221780844163 "$node_(192) setdest 73627 26638 11.0" 
$ns at 235.81156858558836 "$node_(192) setdest 42640 21698 12.0" 
$ns at 327.32314554679647 "$node_(192) setdest 96335 51375 17.0" 
$ns at 451.2823838451384 "$node_(192) setdest 192753 38785 5.0" 
$ns at 518.2857821523468 "$node_(192) setdest 171087 24100 9.0" 
$ns at 605.2449106459223 "$node_(192) setdest 63828 71150 1.0" 
$ns at 641.5932014408585 "$node_(192) setdest 50539 23564 5.0" 
$ns at 684.6172400514406 "$node_(192) setdest 16668 48770 11.0" 
$ns at 822.216493417059 "$node_(192) setdest 152437 11504 6.0" 
$ns at 868.2434268946015 "$node_(192) setdest 95138 833 12.0" 
$ns at 125.26375117232655 "$node_(193) setdest 64972 12284 2.0" 
$ns at 170.08536014766025 "$node_(193) setdest 133350 15810 18.0" 
$ns at 296.4004202637119 "$node_(193) setdest 162873 1136 18.0" 
$ns at 501.24390655703536 "$node_(193) setdest 139325 20882 1.0" 
$ns at 541.0686861019554 "$node_(193) setdest 148273 50221 7.0" 
$ns at 593.2443794722539 "$node_(193) setdest 182820 57849 18.0" 
$ns at 623.4076126103216 "$node_(193) setdest 139559 21599 2.0" 
$ns at 664.2850162573897 "$node_(193) setdest 111218 73093 9.0" 
$ns at 717.3270851954836 "$node_(193) setdest 84207 47219 10.0" 
$ns at 823.6665488824908 "$node_(193) setdest 98278 44087 12.0" 
$ns at 163.3260647960758 "$node_(194) setdest 88334 20684 1.0" 
$ns at 197.83131230255964 "$node_(194) setdest 15323 11051 13.0" 
$ns at 288.100637377348 "$node_(194) setdest 142553 23593 11.0" 
$ns at 403.7727319065393 "$node_(194) setdest 159815 10679 19.0" 
$ns at 619.7899200478769 "$node_(194) setdest 158396 53058 9.0" 
$ns at 668.7121340002236 "$node_(194) setdest 194468 46104 9.0" 
$ns at 716.6186087428667 "$node_(194) setdest 173152 7328 19.0" 
$ns at 762.8178446619638 "$node_(194) setdest 235615 12543 13.0" 
$ns at 867.7728793525782 "$node_(194) setdest 246389 30172 13.0" 
$ns at 103.61662587766605 "$node_(195) setdest 81858 11331 16.0" 
$ns at 253.2145633057373 "$node_(195) setdest 138260 23075 15.0" 
$ns at 429.69746184980136 "$node_(195) setdest 69273 8488 15.0" 
$ns at 488.28078465551766 "$node_(195) setdest 54734 49655 13.0" 
$ns at 596.0588763609254 "$node_(195) setdest 223720 68188 8.0" 
$ns at 652.054113620166 "$node_(195) setdest 32470 75218 4.0" 
$ns at 702.7078072603359 "$node_(195) setdest 248365 81193 14.0" 
$ns at 782.782457804106 "$node_(195) setdest 142960 55989 3.0" 
$ns at 826.1286610217619 "$node_(195) setdest 209811 77143 2.0" 
$ns at 876.1074995852923 "$node_(195) setdest 106572 62829 10.0" 
$ns at 153.2000840625455 "$node_(196) setdest 129641 36051 12.0" 
$ns at 269.5443655207966 "$node_(196) setdest 129798 32607 17.0" 
$ns at 318.6671289673518 "$node_(196) setdest 151657 40888 3.0" 
$ns at 372.98171506088227 "$node_(196) setdest 139815 8873 6.0" 
$ns at 428.88969275073566 "$node_(196) setdest 96635 3278 19.0" 
$ns at 634.823555506498 "$node_(196) setdest 156962 37394 10.0" 
$ns at 671.2681318720066 "$node_(196) setdest 206197 19730 15.0" 
$ns at 835.8559614394705 "$node_(196) setdest 24066 43008 1.0" 
$ns at 866.3319983051547 "$node_(196) setdest 219654 14207 8.0" 
$ns at 107.89595002571156 "$node_(197) setdest 7902 27398 6.0" 
$ns at 166.29990640208882 "$node_(197) setdest 118072 34337 11.0" 
$ns at 301.07968005551226 "$node_(197) setdest 142544 54129 20.0" 
$ns at 494.3440494617895 "$node_(197) setdest 120409 30580 13.0" 
$ns at 597.0161804817444 "$node_(197) setdest 102734 10619 16.0" 
$ns at 783.9520447272525 "$node_(197) setdest 226437 18453 14.0" 
$ns at 178.35811720613623 "$node_(198) setdest 4520 3895 6.0" 
$ns at 220.80211928652878 "$node_(198) setdest 7318 38590 17.0" 
$ns at 333.31004092970414 "$node_(198) setdest 37549 20772 11.0" 
$ns at 469.0877013589185 "$node_(198) setdest 76211 11966 5.0" 
$ns at 507.79595060394104 "$node_(198) setdest 12175 45539 3.0" 
$ns at 547.2722296327232 "$node_(198) setdest 181694 20104 19.0" 
$ns at 600.2754278692237 "$node_(198) setdest 35402 24577 19.0" 
$ns at 812.9029848743456 "$node_(198) setdest 179024 45730 12.0" 
$ns at 123.94622626056656 "$node_(199) setdest 1270 396 17.0" 
$ns at 251.12125878491884 "$node_(199) setdest 83813 13068 18.0" 
$ns at 371.2389731116628 "$node_(199) setdest 51039 20637 10.0" 
$ns at 462.65707226049074 "$node_(199) setdest 203916 19536 9.0" 
$ns at 534.8687333308069 "$node_(199) setdest 37010 17493 19.0" 
$ns at 694.0221816729986 "$node_(199) setdest 81294 79651 15.0" 
$ns at 762.7795870778513 "$node_(199) setdest 57834 85319 8.0" 
$ns at 871.7727038346065 "$node_(199) setdest 225432 51958 15.0" 
$ns at 233.7162116491753 "$node_(200) setdest 95889 8876 15.0" 
$ns at 285.46303935918144 "$node_(200) setdest 58326 43138 9.0" 
$ns at 318.38756966078296 "$node_(200) setdest 92847 15341 11.0" 
$ns at 355.2165367545496 "$node_(200) setdest 34279 17408 17.0" 
$ns at 516.3831712719679 "$node_(200) setdest 69992 6146 4.0" 
$ns at 557.0938240462453 "$node_(200) setdest 63188 21172 6.0" 
$ns at 618.4022734279781 "$node_(200) setdest 24963 42083 4.0" 
$ns at 686.3234463566403 "$node_(200) setdest 1895 40167 8.0" 
$ns at 737.1594777962722 "$node_(200) setdest 68891 8766 13.0" 
$ns at 791.0660138740857 "$node_(200) setdest 5530 9553 2.0" 
$ns at 832.7878152583392 "$node_(200) setdest 28247 29048 7.0" 
$ns at 242.09729326451398 "$node_(201) setdest 25639 29362 17.0" 
$ns at 345.39323171466367 "$node_(201) setdest 18889 21286 8.0" 
$ns at 416.87174894920065 "$node_(201) setdest 109252 22686 17.0" 
$ns at 494.0091464337315 "$node_(201) setdest 129900 2771 7.0" 
$ns at 575.3765628755239 "$node_(201) setdest 49214 12364 1.0" 
$ns at 612.8993734535434 "$node_(201) setdest 78823 13737 16.0" 
$ns at 764.2093372776271 "$node_(201) setdest 61093 14576 6.0" 
$ns at 837.1523315448042 "$node_(201) setdest 132526 9498 12.0" 
$ns at 227.05703598364136 "$node_(202) setdest 63355 5328 3.0" 
$ns at 262.2809879145621 "$node_(202) setdest 17536 23718 3.0" 
$ns at 304.5028122668869 "$node_(202) setdest 94177 31142 19.0" 
$ns at 378.673344238743 "$node_(202) setdest 52909 21935 6.0" 
$ns at 432.9481704543099 "$node_(202) setdest 72275 21849 11.0" 
$ns at 539.7038587458076 "$node_(202) setdest 51075 39405 10.0" 
$ns at 659.3289109128725 "$node_(202) setdest 21142 33889 7.0" 
$ns at 734.2599274188669 "$node_(202) setdest 49690 15151 11.0" 
$ns at 799.643703686074 "$node_(202) setdest 38203 2120 18.0" 
$ns at 887.9910105304023 "$node_(202) setdest 63414 24108 18.0" 
$ns at 331.8152474302768 "$node_(203) setdest 111923 12017 17.0" 
$ns at 461.5917381325677 "$node_(203) setdest 5525 39151 13.0" 
$ns at 583.3542416264496 "$node_(203) setdest 5839 34194 5.0" 
$ns at 624.6797331428755 "$node_(203) setdest 65180 41684 13.0" 
$ns at 706.890309300118 "$node_(203) setdest 7940 2452 13.0" 
$ns at 745.2306621152611 "$node_(203) setdest 73526 12204 16.0" 
$ns at 793.0589528012837 "$node_(203) setdest 70878 25633 1.0" 
$ns at 823.3202908906549 "$node_(203) setdest 54379 43413 15.0" 
$ns at 879.7839440609739 "$node_(203) setdest 64061 39242 8.0" 
$ns at 252.48086133735865 "$node_(204) setdest 110845 39127 18.0" 
$ns at 307.8752518676411 "$node_(204) setdest 20628 24138 13.0" 
$ns at 379.23343135036254 "$node_(204) setdest 26455 17744 14.0" 
$ns at 470.9753568181869 "$node_(204) setdest 60881 27947 12.0" 
$ns at 591.1586551468158 "$node_(204) setdest 108772 18148 3.0" 
$ns at 635.5411321292778 "$node_(204) setdest 7485 36698 1.0" 
$ns at 669.0719390951616 "$node_(204) setdest 64983 34906 3.0" 
$ns at 722.4994113117838 "$node_(204) setdest 76352 13820 16.0" 
$ns at 833.1217577016208 "$node_(204) setdest 71093 25073 14.0" 
$ns at 210.0148318854464 "$node_(205) setdest 10265 5803 14.0" 
$ns at 355.98519516442116 "$node_(205) setdest 113344 34124 8.0" 
$ns at 445.46441580793345 "$node_(205) setdest 95676 27863 14.0" 
$ns at 524.6660847026635 "$node_(205) setdest 133077 26105 1.0" 
$ns at 564.0901032959948 "$node_(205) setdest 109210 23636 11.0" 
$ns at 633.5938652738753 "$node_(205) setdest 34380 1956 9.0" 
$ns at 709.0868155904155 "$node_(205) setdest 10814 34954 14.0" 
$ns at 824.8168834119831 "$node_(205) setdest 112498 19287 11.0" 
$ns at 277.158701634899 "$node_(206) setdest 49321 44399 11.0" 
$ns at 314.65624510863665 "$node_(206) setdest 102811 31636 20.0" 
$ns at 368.7471964474771 "$node_(206) setdest 7769 38115 17.0" 
$ns at 534.9228576696662 "$node_(206) setdest 105493 39660 13.0" 
$ns at 646.0256792785458 "$node_(206) setdest 118030 12423 1.0" 
$ns at 677.2045814801097 "$node_(206) setdest 118093 23896 3.0" 
$ns at 732.7146452270831 "$node_(206) setdest 79660 20512 12.0" 
$ns at 789.4904928438316 "$node_(206) setdest 121725 33799 19.0" 
$ns at 893.2007981845484 "$node_(206) setdest 110891 6772 17.0" 
$ns at 246.20570182635913 "$node_(207) setdest 77342 13037 10.0" 
$ns at 362.42501122422397 "$node_(207) setdest 109599 23961 5.0" 
$ns at 425.2076200942515 "$node_(207) setdest 104881 36328 14.0" 
$ns at 483.1039866228367 "$node_(207) setdest 116128 38670 17.0" 
$ns at 681.7716911078003 "$node_(207) setdest 45329 40929 11.0" 
$ns at 818.8038601162909 "$node_(207) setdest 102297 20269 15.0" 
$ns at 286.4755548253039 "$node_(208) setdest 102686 16211 2.0" 
$ns at 328.94319922903924 "$node_(208) setdest 73296 39217 11.0" 
$ns at 395.66748084935557 "$node_(208) setdest 113709 19988 17.0" 
$ns at 435.38995495737817 "$node_(208) setdest 23604 11557 3.0" 
$ns at 465.5425149162208 "$node_(208) setdest 133152 17283 1.0" 
$ns at 497.24036897229394 "$node_(208) setdest 54463 37395 10.0" 
$ns at 565.7094608655693 "$node_(208) setdest 18356 32664 8.0" 
$ns at 633.0476446920949 "$node_(208) setdest 50287 3289 4.0" 
$ns at 688.3975058149863 "$node_(208) setdest 79087 29111 13.0" 
$ns at 763.6677615305954 "$node_(208) setdest 59433 29437 13.0" 
$ns at 807.0377361443193 "$node_(208) setdest 94175 26779 8.0" 
$ns at 871.7453805211982 "$node_(208) setdest 60122 37346 4.0" 
$ns at 256.4335799298934 "$node_(209) setdest 107495 26767 6.0" 
$ns at 308.3601274899444 "$node_(209) setdest 79011 24331 11.0" 
$ns at 361.6525524486195 "$node_(209) setdest 15177 17984 8.0" 
$ns at 456.97902105831497 "$node_(209) setdest 50015 20261 11.0" 
$ns at 558.98255993007 "$node_(209) setdest 130148 41401 16.0" 
$ns at 598.7894913088254 "$node_(209) setdest 120893 19199 14.0" 
$ns at 662.13069092191 "$node_(209) setdest 27226 42473 7.0" 
$ns at 739.2232418444249 "$node_(209) setdest 67839 42288 8.0" 
$ns at 784.7556536944021 "$node_(209) setdest 109566 35750 16.0" 
$ns at 366.61613917721036 "$node_(210) setdest 122913 13983 7.0" 
$ns at 421.48339142010764 "$node_(210) setdest 70476 27704 3.0" 
$ns at 475.8089932525053 "$node_(210) setdest 109202 32139 2.0" 
$ns at 524.3140600978523 "$node_(210) setdest 14184 18335 9.0" 
$ns at 601.7885778180422 "$node_(210) setdest 30597 35970 4.0" 
$ns at 640.3330537746477 "$node_(210) setdest 120695 34964 2.0" 
$ns at 682.3907754243445 "$node_(210) setdest 13611 9677 15.0" 
$ns at 757.8961120286677 "$node_(210) setdest 85374 13544 11.0" 
$ns at 867.0291650411015 "$node_(210) setdest 77457 777 9.0" 
$ns at 226.38917744375226 "$node_(211) setdest 94052 5959 2.0" 
$ns at 272.6080094658169 "$node_(211) setdest 113229 10785 20.0" 
$ns at 339.0263934891467 "$node_(211) setdest 109733 38581 6.0" 
$ns at 372.5520932915597 "$node_(211) setdest 20685 43747 4.0" 
$ns at 432.1163461605869 "$node_(211) setdest 27124 27396 14.0" 
$ns at 570.5852195447062 "$node_(211) setdest 275 29700 16.0" 
$ns at 617.1293868881104 "$node_(211) setdest 103843 27681 13.0" 
$ns at 674.622215990908 "$node_(211) setdest 67821 27295 15.0" 
$ns at 782.4821618545802 "$node_(211) setdest 65788 37886 14.0" 
$ns at 892.6949321723735 "$node_(211) setdest 94105 40809 6.0" 
$ns at 214.47678175466723 "$node_(212) setdest 120487 12006 2.0" 
$ns at 252.8070984473931 "$node_(212) setdest 110693 18351 2.0" 
$ns at 284.59653502365194 "$node_(212) setdest 10119 29646 1.0" 
$ns at 319.6490923107079 "$node_(212) setdest 89517 34770 10.0" 
$ns at 425.67020567182396 "$node_(212) setdest 63433 18502 20.0" 
$ns at 539.2576714825117 "$node_(212) setdest 130656 12124 2.0" 
$ns at 584.0411645217225 "$node_(212) setdest 46114 19191 9.0" 
$ns at 678.5183271503314 "$node_(212) setdest 15555 43657 3.0" 
$ns at 728.4122519834701 "$node_(212) setdest 126798 20064 1.0" 
$ns at 762.1930817057573 "$node_(212) setdest 116600 42516 3.0" 
$ns at 809.6473355748865 "$node_(212) setdest 5636 3605 1.0" 
$ns at 843.7027641524401 "$node_(212) setdest 16393 42466 16.0" 
$ns at 237.89742509832323 "$node_(213) setdest 121017 9036 5.0" 
$ns at 286.58426428178944 "$node_(213) setdest 33076 8563 15.0" 
$ns at 435.3282755653975 "$node_(213) setdest 128429 14731 20.0" 
$ns at 651.1117814642073 "$node_(213) setdest 54523 35446 19.0" 
$ns at 765.8425928690825 "$node_(213) setdest 74929 26592 18.0" 
$ns at 216.57427718637967 "$node_(214) setdest 42927 3838 10.0" 
$ns at 275.4835083413624 "$node_(214) setdest 106153 18136 10.0" 
$ns at 333.62052402094884 "$node_(214) setdest 39373 20947 19.0" 
$ns at 483.58362959520633 "$node_(214) setdest 48180 18009 18.0" 
$ns at 649.6669171636366 "$node_(214) setdest 48988 2083 5.0" 
$ns at 694.6174126153633 "$node_(214) setdest 35011 23641 6.0" 
$ns at 760.2799444928962 "$node_(214) setdest 2478 27802 4.0" 
$ns at 812.0735494159346 "$node_(214) setdest 12424 1149 7.0" 
$ns at 874.2815399492487 "$node_(214) setdest 116068 5152 10.0" 
$ns at 207.78805109910752 "$node_(215) setdest 71302 28109 14.0" 
$ns at 260.2337780551664 "$node_(215) setdest 129712 28975 5.0" 
$ns at 300.75978740913877 "$node_(215) setdest 103761 16586 2.0" 
$ns at 339.4055882383285 "$node_(215) setdest 104756 8567 2.0" 
$ns at 382.63773401093715 "$node_(215) setdest 12055 11625 10.0" 
$ns at 461.6126536417142 "$node_(215) setdest 126134 35080 1.0" 
$ns at 496.82413608606123 "$node_(215) setdest 42341 18928 14.0" 
$ns at 623.1069082521228 "$node_(215) setdest 13831 13034 1.0" 
$ns at 657.8388319888284 "$node_(215) setdest 24123 16302 19.0" 
$ns at 874.7175644441274 "$node_(215) setdest 2656 9938 2.0" 
$ns at 278.7078744206634 "$node_(216) setdest 120342 23682 16.0" 
$ns at 452.1319954997606 "$node_(216) setdest 86468 34994 2.0" 
$ns at 486.72426380801363 "$node_(216) setdest 46223 10127 15.0" 
$ns at 603.1688833984316 "$node_(216) setdest 61580 37652 3.0" 
$ns at 633.6142076852932 "$node_(216) setdest 65460 20333 17.0" 
$ns at 733.4925208804749 "$node_(216) setdest 40121 6408 1.0" 
$ns at 765.3568105709143 "$node_(216) setdest 17686 29176 6.0" 
$ns at 849.3361822464191 "$node_(216) setdest 74202 15113 2.0" 
$ns at 884.5587896549613 "$node_(216) setdest 98320 9366 20.0" 
$ns at 214.59493288186883 "$node_(217) setdest 103034 8629 7.0" 
$ns at 297.60436580992155 "$node_(217) setdest 59802 3802 14.0" 
$ns at 378.5720872137464 "$node_(217) setdest 118800 42150 10.0" 
$ns at 414.14075164715325 "$node_(217) setdest 10403 36999 8.0" 
$ns at 490.2640872035323 "$node_(217) setdest 94967 4180 11.0" 
$ns at 611.3470955949808 "$node_(217) setdest 95918 40225 4.0" 
$ns at 675.2519287024677 "$node_(217) setdest 114062 2202 9.0" 
$ns at 749.057572399161 "$node_(217) setdest 82019 41626 15.0" 
$ns at 892.7558099026899 "$node_(217) setdest 30779 14583 6.0" 
$ns at 240.27027942475104 "$node_(218) setdest 121501 34073 14.0" 
$ns at 376.22317506363436 "$node_(218) setdest 25549 4498 4.0" 
$ns at 433.9600715902835 "$node_(218) setdest 108076 28721 2.0" 
$ns at 464.93361583329164 "$node_(218) setdest 55459 18223 12.0" 
$ns at 498.6276297477785 "$node_(218) setdest 92718 33898 1.0" 
$ns at 531.4291710589325 "$node_(218) setdest 75848 23452 10.0" 
$ns at 596.4162459178061 "$node_(218) setdest 13071 1242 10.0" 
$ns at 692.9200589465369 "$node_(218) setdest 80670 22993 7.0" 
$ns at 754.2967840818654 "$node_(218) setdest 55987 13804 8.0" 
$ns at 801.3014885872426 "$node_(218) setdest 35160 30739 13.0" 
$ns at 305.9493808607177 "$node_(219) setdest 29130 14904 3.0" 
$ns at 363.71339897592514 "$node_(219) setdest 117793 44064 4.0" 
$ns at 428.6549734160692 "$node_(219) setdest 123069 40876 8.0" 
$ns at 499.31691610275465 "$node_(219) setdest 24777 22415 16.0" 
$ns at 615.597962779302 "$node_(219) setdest 56816 1926 11.0" 
$ns at 694.4003355267897 "$node_(219) setdest 74828 314 14.0" 
$ns at 757.1053412848687 "$node_(219) setdest 22762 39111 17.0" 
$ns at 216.99874838778098 "$node_(220) setdest 61665 43835 6.0" 
$ns at 300.16899512412823 "$node_(220) setdest 51350 25813 9.0" 
$ns at 332.5576307244916 "$node_(220) setdest 103713 39617 4.0" 
$ns at 379.3807831248028 "$node_(220) setdest 93596 2854 2.0" 
$ns at 420.09926782667065 "$node_(220) setdest 121798 43786 12.0" 
$ns at 569.5155437790353 "$node_(220) setdest 69356 22907 8.0" 
$ns at 601.9004992319889 "$node_(220) setdest 89251 25508 9.0" 
$ns at 721.4933714032193 "$node_(220) setdest 16670 31114 17.0" 
$ns at 894.9085843364209 "$node_(220) setdest 97612 34893 8.0" 
$ns at 202.590894447194 "$node_(221) setdest 128406 23261 20.0" 
$ns at 376.6661025082458 "$node_(221) setdest 95672 20879 13.0" 
$ns at 519.6917058431704 "$node_(221) setdest 21866 14136 2.0" 
$ns at 569.4102270409252 "$node_(221) setdest 58057 12802 4.0" 
$ns at 622.1467746766014 "$node_(221) setdest 65153 25036 17.0" 
$ns at 720.2452311167496 "$node_(221) setdest 127016 23495 6.0" 
$ns at 795.362481178076 "$node_(221) setdest 53502 11883 13.0" 
$ns at 262.13636049293416 "$node_(222) setdest 69157 4033 13.0" 
$ns at 309.05500919753416 "$node_(222) setdest 963 5492 17.0" 
$ns at 353.0987567034364 "$node_(222) setdest 24977 1182 11.0" 
$ns at 392.3980239664402 "$node_(222) setdest 74963 33216 18.0" 
$ns at 548.7113410658886 "$node_(222) setdest 113030 13338 15.0" 
$ns at 595.6039042376519 "$node_(222) setdest 133066 43770 2.0" 
$ns at 638.3535445202681 "$node_(222) setdest 37756 14785 2.0" 
$ns at 681.2943473219007 "$node_(222) setdest 112424 18392 17.0" 
$ns at 826.3974603695883 "$node_(222) setdest 97546 16642 5.0" 
$ns at 884.6812969227203 "$node_(222) setdest 9930 1108 13.0" 
$ns at 225.26711701980696 "$node_(223) setdest 118889 31563 15.0" 
$ns at 396.85068017297135 "$node_(223) setdest 11214 1553 8.0" 
$ns at 485.6228353631887 "$node_(223) setdest 77337 14690 8.0" 
$ns at 532.3330775825976 "$node_(223) setdest 17270 13963 13.0" 
$ns at 567.0571707334755 "$node_(223) setdest 123233 13140 19.0" 
$ns at 601.1067372475287 "$node_(223) setdest 53296 6684 15.0" 
$ns at 773.3595752598467 "$node_(223) setdest 92867 3834 17.0" 
$ns at 851.5473915942596 "$node_(223) setdest 91690 14555 10.0" 
$ns at 217.27527177807679 "$node_(224) setdest 48526 14547 2.0" 
$ns at 248.73222443960248 "$node_(224) setdest 81290 35691 6.0" 
$ns at 294.3128024415716 "$node_(224) setdest 108099 7866 1.0" 
$ns at 330.70992724407415 "$node_(224) setdest 125311 8098 5.0" 
$ns at 378.68231877251026 "$node_(224) setdest 81745 29090 5.0" 
$ns at 436.79480467614104 "$node_(224) setdest 100199 32649 13.0" 
$ns at 579.7774632289434 "$node_(224) setdest 21209 7527 2.0" 
$ns at 611.1222449221683 "$node_(224) setdest 34819 23859 19.0" 
$ns at 724.7740352579357 "$node_(224) setdest 23422 22272 10.0" 
$ns at 786.6399136264615 "$node_(224) setdest 38897 24887 1.0" 
$ns at 826.4542772326146 "$node_(224) setdest 102331 30133 9.0" 
$ns at 220.51309165883504 "$node_(225) setdest 80083 41704 11.0" 
$ns at 256.8066091113186 "$node_(225) setdest 29047 29174 17.0" 
$ns at 445.5791695017956 "$node_(225) setdest 10557 28689 16.0" 
$ns at 589.6332602899276 "$node_(225) setdest 124535 18368 1.0" 
$ns at 625.098878079246 "$node_(225) setdest 29354 8365 3.0" 
$ns at 668.8349759293441 "$node_(225) setdest 33011 31898 4.0" 
$ns at 706.6002515702784 "$node_(225) setdest 7992 8886 6.0" 
$ns at 791.4675748657752 "$node_(225) setdest 6957 7324 6.0" 
$ns at 880.3690520193983 "$node_(225) setdest 11954 37217 8.0" 
$ns at 253.4087900494402 "$node_(226) setdest 117815 33532 4.0" 
$ns at 323.1358672097889 "$node_(226) setdest 27676 40557 12.0" 
$ns at 451.2723302848598 "$node_(226) setdest 11684 12084 11.0" 
$ns at 530.6706003443278 "$node_(226) setdest 130687 25294 4.0" 
$ns at 589.8023234485968 "$node_(226) setdest 72518 42183 5.0" 
$ns at 653.4187814519231 "$node_(226) setdest 105689 28898 13.0" 
$ns at 686.7144389460196 "$node_(226) setdest 111956 11219 6.0" 
$ns at 721.365784406685 "$node_(226) setdest 25184 43313 11.0" 
$ns at 829.0957872806548 "$node_(226) setdest 18453 12614 19.0" 
$ns at 280.3256218457241 "$node_(227) setdest 90911 9577 18.0" 
$ns at 476.75965429310816 "$node_(227) setdest 3546 8516 20.0" 
$ns at 605.006336729302 "$node_(227) setdest 75219 8524 3.0" 
$ns at 655.7361685763483 "$node_(227) setdest 94478 22187 12.0" 
$ns at 772.7240604910871 "$node_(227) setdest 62511 14115 12.0" 
$ns at 241.71925659349284 "$node_(228) setdest 54711 41923 3.0" 
$ns at 272.6817559546876 "$node_(228) setdest 19763 18649 9.0" 
$ns at 345.95415038202816 "$node_(228) setdest 20626 17071 8.0" 
$ns at 401.2355547793085 "$node_(228) setdest 11691 1883 8.0" 
$ns at 438.83207660884335 "$node_(228) setdest 29872 9036 1.0" 
$ns at 474.08903136405934 "$node_(228) setdest 118889 11659 1.0" 
$ns at 508.0444043395449 "$node_(228) setdest 6150 33956 9.0" 
$ns at 611.4949975358554 "$node_(228) setdest 127800 26815 1.0" 
$ns at 642.481104083038 "$node_(228) setdest 134122 35145 19.0" 
$ns at 791.0749135112068 "$node_(228) setdest 121883 7608 5.0" 
$ns at 847.7155672484678 "$node_(228) setdest 125450 9779 16.0" 
$ns at 209.3515089985189 "$node_(229) setdest 54781 29477 6.0" 
$ns at 291.6961331453289 "$node_(229) setdest 44678 23460 7.0" 
$ns at 348.3770789627178 "$node_(229) setdest 122225 28738 15.0" 
$ns at 463.7430084852498 "$node_(229) setdest 83880 37542 4.0" 
$ns at 506.67153862108256 "$node_(229) setdest 40169 41433 20.0" 
$ns at 550.7986974766766 "$node_(229) setdest 3567 23604 17.0" 
$ns at 656.3379620034136 "$node_(229) setdest 61917 30794 18.0" 
$ns at 730.3599282607644 "$node_(229) setdest 60543 17932 2.0" 
$ns at 769.1995515720323 "$node_(229) setdest 13397 22553 9.0" 
$ns at 809.4885792638352 "$node_(229) setdest 18889 28512 18.0" 
$ns at 248.05866606038927 "$node_(230) setdest 78023 44484 17.0" 
$ns at 418.7306579148809 "$node_(230) setdest 15084 2705 5.0" 
$ns at 462.7699993203714 "$node_(230) setdest 128324 28699 7.0" 
$ns at 498.7730222428905 "$node_(230) setdest 40325 33718 2.0" 
$ns at 548.0112013747214 "$node_(230) setdest 37553 11477 9.0" 
$ns at 660.5416255712938 "$node_(230) setdest 128848 38136 5.0" 
$ns at 718.6078894024857 "$node_(230) setdest 40465 24969 10.0" 
$ns at 776.4069118416235 "$node_(230) setdest 67379 30973 3.0" 
$ns at 806.442758364649 "$node_(230) setdest 58803 19837 4.0" 
$ns at 843.9320158993755 "$node_(230) setdest 117009 43626 20.0" 
$ns at 311.9298671832882 "$node_(231) setdest 127193 26524 10.0" 
$ns at 395.4907401728477 "$node_(231) setdest 26064 24075 10.0" 
$ns at 447.9683191183153 "$node_(231) setdest 125462 24636 5.0" 
$ns at 514.6313260922406 "$node_(231) setdest 84241 12525 17.0" 
$ns at 646.9177035110812 "$node_(231) setdest 68719 20532 5.0" 
$ns at 698.3215482217234 "$node_(231) setdest 108684 23647 4.0" 
$ns at 745.64599394718 "$node_(231) setdest 71281 1368 4.0" 
$ns at 785.9362574595636 "$node_(231) setdest 42020 30932 9.0" 
$ns at 865.4623770081321 "$node_(231) setdest 121874 73 1.0" 
$ns at 233.57456152178082 "$node_(232) setdest 90885 26084 1.0" 
$ns at 272.6389317927597 "$node_(232) setdest 134145 36077 18.0" 
$ns at 464.5846953476567 "$node_(232) setdest 82605 6159 3.0" 
$ns at 523.5578459438677 "$node_(232) setdest 83878 2218 2.0" 
$ns at 557.6050217115684 "$node_(232) setdest 98970 16686 1.0" 
$ns at 591.2792072934573 "$node_(232) setdest 66040 5929 16.0" 
$ns at 632.9305208671816 "$node_(232) setdest 105553 29267 10.0" 
$ns at 666.8194118240999 "$node_(232) setdest 90139 10786 19.0" 
$ns at 749.8065837322754 "$node_(232) setdest 57070 20458 14.0" 
$ns at 872.970391132953 "$node_(232) setdest 85708 32961 2.0" 
$ns at 223.68037094302696 "$node_(233) setdest 61778 7041 4.0" 
$ns at 287.2025641849309 "$node_(233) setdest 6171 44436 8.0" 
$ns at 343.5370794202362 "$node_(233) setdest 93843 42877 13.0" 
$ns at 389.3890224104774 "$node_(233) setdest 19741 43135 14.0" 
$ns at 518.7954047937582 "$node_(233) setdest 45406 2419 10.0" 
$ns at 560.7527012074364 "$node_(233) setdest 57423 21311 8.0" 
$ns at 634.4285362132385 "$node_(233) setdest 113695 33080 1.0" 
$ns at 667.7681348408529 "$node_(233) setdest 60396 36018 11.0" 
$ns at 805.3918399898466 "$node_(233) setdest 86914 9835 3.0" 
$ns at 843.8209573890204 "$node_(233) setdest 6267 22799 17.0" 
$ns at 319.987719685739 "$node_(234) setdest 27090 2175 1.0" 
$ns at 357.4853664776749 "$node_(234) setdest 108065 31894 1.0" 
$ns at 391.8591563138857 "$node_(234) setdest 131984 753 2.0" 
$ns at 441.5620344441056 "$node_(234) setdest 102761 42383 10.0" 
$ns at 540.1114252119238 "$node_(234) setdest 36563 17561 7.0" 
$ns at 606.7143982174563 "$node_(234) setdest 11532 35832 12.0" 
$ns at 706.9020492845199 "$node_(234) setdest 10874 12140 17.0" 
$ns at 828.2897909417605 "$node_(234) setdest 4800 4374 10.0" 
$ns at 290.48574105591496 "$node_(235) setdest 103948 27114 9.0" 
$ns at 373.8039585190868 "$node_(235) setdest 23303 23295 2.0" 
$ns at 421.96380480531104 "$node_(235) setdest 28387 21852 12.0" 
$ns at 517.2348288805542 "$node_(235) setdest 43883 9881 15.0" 
$ns at 580.6058023739367 "$node_(235) setdest 27120 32532 15.0" 
$ns at 721.9552455008736 "$node_(235) setdest 32078 31056 17.0" 
$ns at 870.475515472169 "$node_(235) setdest 123979 38615 6.0" 
$ns at 260.9946838019196 "$node_(236) setdest 70892 28148 10.0" 
$ns at 307.6794204018721 "$node_(236) setdest 133499 29408 10.0" 
$ns at 388.3913156717968 "$node_(236) setdest 1082 17347 5.0" 
$ns at 429.43039165346465 "$node_(236) setdest 32237 30539 8.0" 
$ns at 496.0013223395505 "$node_(236) setdest 68101 37867 14.0" 
$ns at 593.8579087632789 "$node_(236) setdest 15445 2592 18.0" 
$ns at 703.3257359530368 "$node_(236) setdest 126500 30808 4.0" 
$ns at 755.9995147739775 "$node_(236) setdest 58134 42060 4.0" 
$ns at 799.6443855534528 "$node_(236) setdest 73277 25453 7.0" 
$ns at 874.2337792064409 "$node_(236) setdest 41052 32962 10.0" 
$ns at 225.94093763819424 "$node_(237) setdest 105837 4525 1.0" 
$ns at 261.4619569166267 "$node_(237) setdest 67071 20283 13.0" 
$ns at 401.83012539341587 "$node_(237) setdest 28068 35077 17.0" 
$ns at 507.47718963434454 "$node_(237) setdest 35439 33102 4.0" 
$ns at 540.6477488901963 "$node_(237) setdest 77800 8591 4.0" 
$ns at 582.1446609854347 "$node_(237) setdest 121839 26266 11.0" 
$ns at 681.2971081807793 "$node_(237) setdest 96842 25047 10.0" 
$ns at 781.0636121290421 "$node_(237) setdest 44804 27518 18.0" 
$ns at 839.054429818376 "$node_(237) setdest 82650 28728 11.0" 
$ns at 357.3022564059777 "$node_(238) setdest 42262 30718 7.0" 
$ns at 410.7359575504459 "$node_(238) setdest 67647 32623 18.0" 
$ns at 445.6894493633087 "$node_(238) setdest 93680 10052 4.0" 
$ns at 502.372145181266 "$node_(238) setdest 36187 2102 1.0" 
$ns at 539.3727616664088 "$node_(238) setdest 98089 17141 11.0" 
$ns at 639.6772431365002 "$node_(238) setdest 82450 11425 19.0" 
$ns at 670.3774101469925 "$node_(238) setdest 18650 27558 3.0" 
$ns at 701.3286462962578 "$node_(238) setdest 79814 1924 16.0" 
$ns at 765.9181325458328 "$node_(238) setdest 45815 43158 5.0" 
$ns at 843.8688705709312 "$node_(238) setdest 125453 7850 11.0" 
$ns at 262.1111508764547 "$node_(239) setdest 52701 17279 12.0" 
$ns at 394.2227809175668 "$node_(239) setdest 13701 30554 8.0" 
$ns at 452.8674981014156 "$node_(239) setdest 61881 4627 10.0" 
$ns at 526.7090492847251 "$node_(239) setdest 53959 36781 15.0" 
$ns at 624.5262923733375 "$node_(239) setdest 123724 21866 3.0" 
$ns at 683.9196903232258 "$node_(239) setdest 14293 11305 2.0" 
$ns at 719.6136549826666 "$node_(239) setdest 29010 7267 3.0" 
$ns at 760.2765407080642 "$node_(239) setdest 90214 31429 2.0" 
$ns at 795.5980284012895 "$node_(239) setdest 81942 1240 2.0" 
$ns at 839.7115564982058 "$node_(239) setdest 23568 6205 14.0" 
$ns at 876.5346462740156 "$node_(239) setdest 117787 38171 4.0" 
$ns at 203.58910596868793 "$node_(240) setdest 124289 10214 6.0" 
$ns at 281.3987880664335 "$node_(240) setdest 22282 17431 1.0" 
$ns at 321.3574462062064 "$node_(240) setdest 52035 43786 1.0" 
$ns at 355.3351189710854 "$node_(240) setdest 16420 43580 15.0" 
$ns at 453.2566668618388 "$node_(240) setdest 75239 16240 15.0" 
$ns at 506.207726763711 "$node_(240) setdest 23702 32200 17.0" 
$ns at 698.2242026219442 "$node_(240) setdest 60763 15584 10.0" 
$ns at 814.7322441092089 "$node_(240) setdest 4832 10171 10.0" 
$ns at 848.0424390129792 "$node_(240) setdest 89672 21613 1.0" 
$ns at 886.9819674156157 "$node_(240) setdest 125291 21669 4.0" 
$ns at 215.86937149808426 "$node_(241) setdest 79427 26532 7.0" 
$ns at 305.421730689141 "$node_(241) setdest 6583 33023 1.0" 
$ns at 338.2511941676563 "$node_(241) setdest 28323 6979 3.0" 
$ns at 383.02420876845224 "$node_(241) setdest 107086 28632 18.0" 
$ns at 517.8085858332469 "$node_(241) setdest 129624 29865 17.0" 
$ns at 550.2904785531897 "$node_(241) setdest 127777 29361 6.0" 
$ns at 596.5287794695174 "$node_(241) setdest 106264 8245 18.0" 
$ns at 769.6001129128194 "$node_(241) setdest 72862 22982 2.0" 
$ns at 814.1377887294607 "$node_(241) setdest 90337 41481 10.0" 
$ns at 884.8216220101242 "$node_(241) setdest 18120 19931 7.0" 
$ns at 265.90957171731714 "$node_(242) setdest 75369 18994 1.0" 
$ns at 305.06864913026163 "$node_(242) setdest 102802 11245 5.0" 
$ns at 337.10419855397083 "$node_(242) setdest 11187 22371 7.0" 
$ns at 411.3183078140095 "$node_(242) setdest 45169 18887 4.0" 
$ns at 458.1836063195121 "$node_(242) setdest 104886 11358 8.0" 
$ns at 552.1123958538786 "$node_(242) setdest 101174 38690 6.0" 
$ns at 612.652492441383 "$node_(242) setdest 80255 26802 1.0" 
$ns at 647.4176001574959 "$node_(242) setdest 41566 19240 11.0" 
$ns at 710.4394024668173 "$node_(242) setdest 9219 22574 4.0" 
$ns at 769.7092009357351 "$node_(242) setdest 32604 44249 3.0" 
$ns at 818.8021740434606 "$node_(242) setdest 67926 39897 17.0" 
$ns at 292.6397971730963 "$node_(243) setdest 84378 32638 17.0" 
$ns at 416.9888036446799 "$node_(243) setdest 84631 38384 19.0" 
$ns at 514.1679601523922 "$node_(243) setdest 35303 19398 14.0" 
$ns at 659.3769877494535 "$node_(243) setdest 48028 35232 8.0" 
$ns at 764.9041316191078 "$node_(243) setdest 106037 41518 1.0" 
$ns at 797.9614665931307 "$node_(243) setdest 9137 23100 1.0" 
$ns at 830.3627242851044 "$node_(243) setdest 32892 28725 8.0" 
$ns at 268.50304315379617 "$node_(244) setdest 103920 36838 13.0" 
$ns at 306.8760890863824 "$node_(244) setdest 42668 27791 15.0" 
$ns at 450.791795181359 "$node_(244) setdest 86093 41473 8.0" 
$ns at 489.1061003418898 "$node_(244) setdest 51720 4358 1.0" 
$ns at 523.2678143774034 "$node_(244) setdest 43980 434 18.0" 
$ns at 723.6986719842275 "$node_(244) setdest 30638 17044 10.0" 
$ns at 777.0967992047831 "$node_(244) setdest 45354 10944 18.0" 
$ns at 820.2856846572076 "$node_(244) setdest 69897 11272 17.0" 
$ns at 858.3980204011389 "$node_(244) setdest 53693 39175 1.0" 
$ns at 891.4018529713184 "$node_(244) setdest 8092 40573 12.0" 
$ns at 242.21278547684926 "$node_(245) setdest 85037 1862 18.0" 
$ns at 382.23288674870616 "$node_(245) setdest 1200 18526 6.0" 
$ns at 429.78256110632674 "$node_(245) setdest 65931 3314 10.0" 
$ns at 488.66252107467284 "$node_(245) setdest 4375 34458 1.0" 
$ns at 520.2395702986367 "$node_(245) setdest 24546 27499 13.0" 
$ns at 637.5101032176082 "$node_(245) setdest 88822 9912 12.0" 
$ns at 740.0768009089865 "$node_(245) setdest 8080 22034 15.0" 
$ns at 865.5809747200836 "$node_(245) setdest 69721 20430 13.0" 
$ns at 222.71417798820642 "$node_(246) setdest 80053 6044 7.0" 
$ns at 267.55505029840594 "$node_(246) setdest 90192 8663 13.0" 
$ns at 329.425143975035 "$node_(246) setdest 61426 15133 15.0" 
$ns at 442.7713410283355 "$node_(246) setdest 131614 28916 11.0" 
$ns at 538.6288337046998 "$node_(246) setdest 123720 16607 7.0" 
$ns at 629.7683645281564 "$node_(246) setdest 7976 870 8.0" 
$ns at 731.0789123791528 "$node_(246) setdest 26452 38366 1.0" 
$ns at 770.8707567362557 "$node_(246) setdest 36054 11209 11.0" 
$ns at 871.6230932554771 "$node_(246) setdest 115955 21567 16.0" 
$ns at 284.14164780842725 "$node_(247) setdest 26999 43063 3.0" 
$ns at 337.90968014670756 "$node_(247) setdest 95287 21690 4.0" 
$ns at 393.1997600717115 "$node_(247) setdest 56683 15249 17.0" 
$ns at 478.038347611601 "$node_(247) setdest 52140 11096 11.0" 
$ns at 607.8789181471285 "$node_(247) setdest 33188 27763 20.0" 
$ns at 682.8835872000164 "$node_(247) setdest 531 43591 19.0" 
$ns at 772.1006846868386 "$node_(247) setdest 118878 34799 19.0" 
$ns at 847.4120554883997 "$node_(247) setdest 133497 1013 8.0" 
$ns at 208.14176583711208 "$node_(248) setdest 19100 626 3.0" 
$ns at 263.9003225050378 "$node_(248) setdest 116813 39682 16.0" 
$ns at 414.0548283873218 "$node_(248) setdest 95523 32844 3.0" 
$ns at 446.40433753741684 "$node_(248) setdest 16115 42350 2.0" 
$ns at 484.5657110829099 "$node_(248) setdest 53222 1438 1.0" 
$ns at 518.1621058681367 "$node_(248) setdest 31066 24879 12.0" 
$ns at 602.2303848178334 "$node_(248) setdest 133125 33876 14.0" 
$ns at 690.8605191337153 "$node_(248) setdest 1096 21020 17.0" 
$ns at 868.1931691032959 "$node_(248) setdest 54180 479 12.0" 
$ns at 241.38266191734414 "$node_(249) setdest 127869 3481 9.0" 
$ns at 306.0398366638718 "$node_(249) setdest 2215 44511 4.0" 
$ns at 356.7343078676305 "$node_(249) setdest 51133 904 14.0" 
$ns at 435.2479509848299 "$node_(249) setdest 17268 12826 3.0" 
$ns at 476.0228692868512 "$node_(249) setdest 9132 14616 20.0" 
$ns at 665.5705430805474 "$node_(249) setdest 54074 9116 8.0" 
$ns at 726.495397643618 "$node_(249) setdest 120690 33126 3.0" 
$ns at 757.5391971115349 "$node_(249) setdest 110621 15893 18.0" 
$ns at 818.2620204314924 "$node_(249) setdest 15207 40228 10.0" 
$ns at 855.1854008011371 "$node_(249) setdest 8680 30494 11.0" 
$ns at 340.11665608159734 "$node_(250) setdest 43839 34740 12.0" 
$ns at 476.6486159540602 "$node_(250) setdest 27863 41747 13.0" 
$ns at 542.2188409603244 "$node_(250) setdest 76363 17387 2.0" 
$ns at 582.3226578013833 "$node_(250) setdest 81105 26736 12.0" 
$ns at 726.1267539237198 "$node_(250) setdest 37246 34700 11.0" 
$ns at 762.651546432213 "$node_(250) setdest 56590 13930 17.0" 
$ns at 298.0607545739148 "$node_(251) setdest 100705 11408 16.0" 
$ns at 469.2691316784552 "$node_(251) setdest 108874 7338 18.0" 
$ns at 558.8158595827671 "$node_(251) setdest 83863 40795 16.0" 
$ns at 717.7601320705919 "$node_(251) setdest 46046 29390 15.0" 
$ns at 820.3556454684107 "$node_(251) setdest 74539 1120 1.0" 
$ns at 850.7883589704843 "$node_(251) setdest 90918 36403 17.0" 
$ns at 222.17305383533773 "$node_(252) setdest 102364 43269 17.0" 
$ns at 341.9958154020853 "$node_(252) setdest 33561 38876 16.0" 
$ns at 417.5893777918431 "$node_(252) setdest 29674 16598 2.0" 
$ns at 455.2686434898342 "$node_(252) setdest 82381 34280 7.0" 
$ns at 493.4298961576957 "$node_(252) setdest 116075 38501 17.0" 
$ns at 533.5181961096018 "$node_(252) setdest 130300 16385 18.0" 
$ns at 716.2766843589105 "$node_(252) setdest 43668 12595 13.0" 
$ns at 844.070431531526 "$node_(252) setdest 111706 43429 12.0" 
$ns at 883.4512574242731 "$node_(252) setdest 48768 40823 1.0" 
$ns at 205.0621905439028 "$node_(253) setdest 37718 22353 4.0" 
$ns at 237.28799708721954 "$node_(253) setdest 32908 29310 17.0" 
$ns at 268.55308133668524 "$node_(253) setdest 28248 7122 16.0" 
$ns at 344.3344686233853 "$node_(253) setdest 29190 1405 3.0" 
$ns at 385.9411241089989 "$node_(253) setdest 13646 27460 1.0" 
$ns at 424.06043883515093 "$node_(253) setdest 762 26701 10.0" 
$ns at 500.2967614569748 "$node_(253) setdest 1422 35666 9.0" 
$ns at 545.7145644898586 "$node_(253) setdest 55812 12414 4.0" 
$ns at 584.8312425204333 "$node_(253) setdest 85024 23115 10.0" 
$ns at 684.8045015670916 "$node_(253) setdest 100835 17450 9.0" 
$ns at 780.0752462136661 "$node_(253) setdest 76403 28836 18.0" 
$ns at 242.45066528249004 "$node_(254) setdest 64564 32586 4.0" 
$ns at 273.5266418571429 "$node_(254) setdest 106158 9211 8.0" 
$ns at 327.0008206551199 "$node_(254) setdest 47938 20232 9.0" 
$ns at 396.43617172393624 "$node_(254) setdest 108068 2917 1.0" 
$ns at 430.66574829953436 "$node_(254) setdest 54653 13074 8.0" 
$ns at 465.9544750690567 "$node_(254) setdest 81827 13810 16.0" 
$ns at 510.3727822099621 "$node_(254) setdest 71219 6100 12.0" 
$ns at 571.2848742960674 "$node_(254) setdest 100945 3514 14.0" 
$ns at 716.9207574330527 "$node_(254) setdest 49498 16123 16.0" 
$ns at 778.3758175196631 "$node_(254) setdest 69989 17354 17.0" 
$ns at 211.9791215864158 "$node_(255) setdest 22495 11065 5.0" 
$ns at 287.02978874344416 "$node_(255) setdest 44691 31672 1.0" 
$ns at 318.4982740932636 "$node_(255) setdest 54291 38384 15.0" 
$ns at 447.0894533097498 "$node_(255) setdest 102492 4938 1.0" 
$ns at 478.2102924218539 "$node_(255) setdest 37861 25426 18.0" 
$ns at 656.5043223256471 "$node_(255) setdest 69397 20347 7.0" 
$ns at 755.5827939691817 "$node_(255) setdest 55757 20821 19.0" 
$ns at 889.3454419267646 "$node_(255) setdest 17125 10711 13.0" 
$ns at 225.98436469596857 "$node_(256) setdest 94198 26779 6.0" 
$ns at 261.5764425217813 "$node_(256) setdest 86570 8724 2.0" 
$ns at 303.5702286436331 "$node_(256) setdest 131561 17300 10.0" 
$ns at 395.70817248110205 "$node_(256) setdest 28852 21009 20.0" 
$ns at 588.7163305688539 "$node_(256) setdest 45729 4635 6.0" 
$ns at 673.0918582335087 "$node_(256) setdest 116567 658 5.0" 
$ns at 741.1189411901815 "$node_(256) setdest 102558 5729 9.0" 
$ns at 814.4924269613477 "$node_(256) setdest 90414 33297 19.0" 
$ns at 211.65610275420153 "$node_(257) setdest 41384 11066 9.0" 
$ns at 325.5825144879295 "$node_(257) setdest 102892 37868 18.0" 
$ns at 513.541322720016 "$node_(257) setdest 118713 9831 10.0" 
$ns at 595.246851411784 "$node_(257) setdest 45941 38984 8.0" 
$ns at 690.9888239147516 "$node_(257) setdest 37595 16920 13.0" 
$ns at 744.2909572289466 "$node_(257) setdest 73352 13561 8.0" 
$ns at 830.6732787692966 "$node_(257) setdest 115402 1891 6.0" 
$ns at 240.70451696456564 "$node_(258) setdest 127236 10863 19.0" 
$ns at 404.36731656995494 "$node_(258) setdest 39332 28039 10.0" 
$ns at 466.76456901496226 "$node_(258) setdest 78856 29270 3.0" 
$ns at 496.76815131980874 "$node_(258) setdest 38840 12161 16.0" 
$ns at 571.6601578688422 "$node_(258) setdest 111154 30059 2.0" 
$ns at 609.4450650370312 "$node_(258) setdest 10130 43576 15.0" 
$ns at 646.0260560270958 "$node_(258) setdest 38593 24812 15.0" 
$ns at 754.7603800515317 "$node_(258) setdest 6551 7928 15.0" 
$ns at 264.52592254475144 "$node_(259) setdest 97447 41287 11.0" 
$ns at 403.5900348677294 "$node_(259) setdest 101319 41405 3.0" 
$ns at 439.1355869381551 "$node_(259) setdest 30693 43896 2.0" 
$ns at 486.62133759492633 "$node_(259) setdest 19328 40141 2.0" 
$ns at 522.6351246215103 "$node_(259) setdest 15159 11792 8.0" 
$ns at 558.3592199938273 "$node_(259) setdest 116756 33298 12.0" 
$ns at 705.1135464169402 "$node_(259) setdest 86094 39942 4.0" 
$ns at 739.2330322292946 "$node_(259) setdest 22485 33760 3.0" 
$ns at 779.1465457777033 "$node_(259) setdest 73316 4583 1.0" 
$ns at 813.9276871426405 "$node_(259) setdest 12693 27355 15.0" 
$ns at 202.266172393082 "$node_(260) setdest 4045 38744 13.0" 
$ns at 335.7634388313272 "$node_(260) setdest 97658 13870 1.0" 
$ns at 374.475408816862 "$node_(260) setdest 81987 33607 13.0" 
$ns at 469.64028187325084 "$node_(260) setdest 5278 2823 9.0" 
$ns at 512.3252854749802 "$node_(260) setdest 68101 43509 14.0" 
$ns at 673.4032031170029 "$node_(260) setdest 79277 40292 7.0" 
$ns at 755.9954057129587 "$node_(260) setdest 28264 17476 9.0" 
$ns at 789.6398530616591 "$node_(260) setdest 106493 1152 2.0" 
$ns at 822.2201400799931 "$node_(260) setdest 19173 7426 11.0" 
$ns at 209.87520965556143 "$node_(261) setdest 37161 36150 19.0" 
$ns at 395.8186082568659 "$node_(261) setdest 65116 34305 16.0" 
$ns at 531.3769316714312 "$node_(261) setdest 95476 30759 4.0" 
$ns at 591.7239223636832 "$node_(261) setdest 124472 38473 4.0" 
$ns at 649.5420274303218 "$node_(261) setdest 75065 28193 1.0" 
$ns at 682.1250457978358 "$node_(261) setdest 27205 6784 8.0" 
$ns at 739.7772356539119 "$node_(261) setdest 26865 307 9.0" 
$ns at 831.801222286507 "$node_(261) setdest 124377 31868 1.0" 
$ns at 862.0098309317179 "$node_(261) setdest 101516 19564 1.0" 
$ns at 896.5204570271546 "$node_(261) setdest 61145 21818 4.0" 
$ns at 307.805316486396 "$node_(262) setdest 128922 41232 19.0" 
$ns at 364.0828774536717 "$node_(262) setdest 7869 8180 16.0" 
$ns at 507.68840838983647 "$node_(262) setdest 16030 24048 1.0" 
$ns at 545.2730662861103 "$node_(262) setdest 74967 4285 17.0" 
$ns at 612.8490836575686 "$node_(262) setdest 70995 21882 12.0" 
$ns at 734.2152538067227 "$node_(262) setdest 35054 30366 10.0" 
$ns at 796.7844238838803 "$node_(262) setdest 17591 25512 5.0" 
$ns at 843.4045096286703 "$node_(262) setdest 98045 16331 10.0" 
$ns at 885.6262592044635 "$node_(262) setdest 70909 25822 15.0" 
$ns at 213.0651310483059 "$node_(263) setdest 1275 41451 17.0" 
$ns at 285.7663136094229 "$node_(263) setdest 17429 28397 14.0" 
$ns at 424.2131769844899 "$node_(263) setdest 55409 25831 18.0" 
$ns at 622.1433221065142 "$node_(263) setdest 72078 6003 18.0" 
$ns at 663.2901704916402 "$node_(263) setdest 7426 14002 1.0" 
$ns at 699.1661497561973 "$node_(263) setdest 68048 27684 4.0" 
$ns at 746.003636871826 "$node_(263) setdest 92335 14650 7.0" 
$ns at 796.8118597506092 "$node_(263) setdest 75372 37611 4.0" 
$ns at 834.9630607101274 "$node_(263) setdest 19416 26352 4.0" 
$ns at 871.085345588502 "$node_(263) setdest 25807 28161 16.0" 
$ns at 257.1707992284641 "$node_(264) setdest 94443 15270 1.0" 
$ns at 295.4963444602 "$node_(264) setdest 78859 21077 4.0" 
$ns at 363.8083189734158 "$node_(264) setdest 70286 20642 3.0" 
$ns at 409.66027465371883 "$node_(264) setdest 36327 19656 9.0" 
$ns at 462.4114475089666 "$node_(264) setdest 61188 27873 6.0" 
$ns at 512.134945380082 "$node_(264) setdest 37397 31989 19.0" 
$ns at 611.4998886617936 "$node_(264) setdest 79768 26011 15.0" 
$ns at 720.8992993101629 "$node_(264) setdest 48758 16427 15.0" 
$ns at 845.7742665880476 "$node_(264) setdest 62470 30093 19.0" 
$ns at 292.95723138405583 "$node_(265) setdest 81465 21811 17.0" 
$ns at 388.4586577131564 "$node_(265) setdest 8680 16759 3.0" 
$ns at 421.0540534452052 "$node_(265) setdest 33182 18561 14.0" 
$ns at 572.0504928676417 "$node_(265) setdest 32818 34363 16.0" 
$ns at 682.2866271304181 "$node_(265) setdest 108698 28204 12.0" 
$ns at 765.8444883755732 "$node_(265) setdest 44143 35773 9.0" 
$ns at 877.0742432818777 "$node_(265) setdest 20930 43477 9.0" 
$ns at 255.29124925827966 "$node_(266) setdest 35425 4481 6.0" 
$ns at 333.44580654339006 "$node_(266) setdest 13632 19841 13.0" 
$ns at 426.5736657968415 "$node_(266) setdest 16759 21282 1.0" 
$ns at 462.67312860747705 "$node_(266) setdest 78680 2176 19.0" 
$ns at 584.608580729411 "$node_(266) setdest 118271 42962 16.0" 
$ns at 636.4543348531369 "$node_(266) setdest 17544 6531 19.0" 
$ns at 767.7909055416151 "$node_(266) setdest 64862 17127 16.0" 
$ns at 254.64898665854423 "$node_(267) setdest 112896 20072 3.0" 
$ns at 287.2803323688411 "$node_(267) setdest 91248 33421 1.0" 
$ns at 325.90308808016664 "$node_(267) setdest 27820 17171 15.0" 
$ns at 430.9423068159414 "$node_(267) setdest 75440 22162 2.0" 
$ns at 479.16086534830856 "$node_(267) setdest 48605 17329 15.0" 
$ns at 628.4999368350885 "$node_(267) setdest 50359 26860 10.0" 
$ns at 743.3131582663899 "$node_(267) setdest 36869 31565 7.0" 
$ns at 811.0535708637328 "$node_(267) setdest 122291 43166 5.0" 
$ns at 890.8759403132754 "$node_(267) setdest 25891 4378 16.0" 
$ns at 237.26555387710897 "$node_(268) setdest 24973 28987 13.0" 
$ns at 377.34247646415866 "$node_(268) setdest 53476 34709 9.0" 
$ns at 464.9415672761447 "$node_(268) setdest 51974 41558 1.0" 
$ns at 502.2968702687077 "$node_(268) setdest 121800 11648 15.0" 
$ns at 650.1311664852349 "$node_(268) setdest 89247 15971 19.0" 
$ns at 860.322529818066 "$node_(268) setdest 14355 35456 10.0" 
$ns at 273.14577828483664 "$node_(269) setdest 68412 22716 12.0" 
$ns at 387.034401562793 "$node_(269) setdest 44376 35379 18.0" 
$ns at 431.4544294515345 "$node_(269) setdest 100040 6779 16.0" 
$ns at 588.0963030630742 "$node_(269) setdest 81749 8115 2.0" 
$ns at 634.5625307448394 "$node_(269) setdest 95384 2338 17.0" 
$ns at 754.690749638579 "$node_(269) setdest 64515 37045 13.0" 
$ns at 786.008945368074 "$node_(269) setdest 121645 43669 14.0" 
$ns at 893.0816131728168 "$node_(269) setdest 8251 32406 19.0" 
$ns at 231.1325028172734 "$node_(270) setdest 39298 43670 3.0" 
$ns at 266.06515100803915 "$node_(270) setdest 26925 22915 1.0" 
$ns at 303.5163326130769 "$node_(270) setdest 52263 12317 15.0" 
$ns at 381.94194444554665 "$node_(270) setdest 105735 6718 20.0" 
$ns at 580.2609737237947 "$node_(270) setdest 59833 41737 18.0" 
$ns at 634.7316367110561 "$node_(270) setdest 102615 4609 9.0" 
$ns at 690.9676182701386 "$node_(270) setdest 95747 3931 16.0" 
$ns at 805.0178615732028 "$node_(270) setdest 56413 29463 3.0" 
$ns at 846.9995130416868 "$node_(270) setdest 108977 35723 5.0" 
$ns at 888.6354386039218 "$node_(270) setdest 121831 1289 17.0" 
$ns at 257.513461576456 "$node_(271) setdest 104133 13931 8.0" 
$ns at 359.9475228507483 "$node_(271) setdest 26180 34545 14.0" 
$ns at 440.97579207323525 "$node_(271) setdest 52414 38971 19.0" 
$ns at 591.1465364155713 "$node_(271) setdest 100532 4860 11.0" 
$ns at 727.1876246340403 "$node_(271) setdest 71683 34883 3.0" 
$ns at 782.6359688699902 "$node_(271) setdest 29984 26959 8.0" 
$ns at 864.844582191097 "$node_(271) setdest 1823 9549 3.0" 
$ns at 287.2420333631396 "$node_(272) setdest 12143 3630 15.0" 
$ns at 352.02230233224566 "$node_(272) setdest 74642 11565 18.0" 
$ns at 417.71848844815395 "$node_(272) setdest 33313 17607 18.0" 
$ns at 615.7789659071117 "$node_(272) setdest 112745 25475 3.0" 
$ns at 661.4766929844213 "$node_(272) setdest 95946 13094 1.0" 
$ns at 696.402370088907 "$node_(272) setdest 42231 14783 1.0" 
$ns at 729.2501908294903 "$node_(272) setdest 22142 8746 8.0" 
$ns at 798.8584559874087 "$node_(272) setdest 107166 38875 7.0" 
$ns at 887.954100097618 "$node_(272) setdest 65566 33025 17.0" 
$ns at 279.4093850373455 "$node_(273) setdest 102019 9070 1.0" 
$ns at 310.0572577263268 "$node_(273) setdest 124151 29557 3.0" 
$ns at 340.1086505515258 "$node_(273) setdest 103370 37237 13.0" 
$ns at 423.7637375248288 "$node_(273) setdest 9796 10709 1.0" 
$ns at 454.2676875046705 "$node_(273) setdest 33360 37120 1.0" 
$ns at 490.4043053967731 "$node_(273) setdest 17600 39893 5.0" 
$ns at 570.2245955940353 "$node_(273) setdest 92730 7842 3.0" 
$ns at 605.7511208211896 "$node_(273) setdest 59915 8549 1.0" 
$ns at 636.6553006706397 "$node_(273) setdest 117807 40537 11.0" 
$ns at 744.2293732570306 "$node_(273) setdest 50641 9551 5.0" 
$ns at 795.2902352847968 "$node_(273) setdest 17401 27864 15.0" 
$ns at 869.3788281076883 "$node_(273) setdest 115062 26865 19.0" 
$ns at 296.53123028859505 "$node_(274) setdest 129919 23369 11.0" 
$ns at 398.43088462517585 "$node_(274) setdest 39328 40597 17.0" 
$ns at 566.8908164494707 "$node_(274) setdest 68361 22970 8.0" 
$ns at 630.1619814660345 "$node_(274) setdest 124399 32224 4.0" 
$ns at 665.6430213271098 "$node_(274) setdest 128934 16153 7.0" 
$ns at 698.8885043101859 "$node_(274) setdest 60884 2599 4.0" 
$ns at 745.7455613342861 "$node_(274) setdest 78229 15356 13.0" 
$ns at 793.9693876057139 "$node_(274) setdest 54250 22541 18.0" 
$ns at 207.26722146844588 "$node_(275) setdest 123186 8386 12.0" 
$ns at 288.63807460712576 "$node_(275) setdest 110946 3789 14.0" 
$ns at 412.10355592310543 "$node_(275) setdest 79041 16130 2.0" 
$ns at 460.03681092633815 "$node_(275) setdest 67181 36431 19.0" 
$ns at 660.2771215873454 "$node_(275) setdest 53059 36524 18.0" 
$ns at 862.1367998424108 "$node_(275) setdest 5081 27347 8.0" 
$ns at 224.91886847114333 "$node_(276) setdest 24550 31534 4.0" 
$ns at 290.9259152986419 "$node_(276) setdest 48967 35270 18.0" 
$ns at 484.2831994756652 "$node_(276) setdest 33503 9272 16.0" 
$ns at 556.5817533834215 "$node_(276) setdest 89941 2828 2.0" 
$ns at 592.4588616990252 "$node_(276) setdest 109911 11980 14.0" 
$ns at 739.0744440172894 "$node_(276) setdest 81976 2589 20.0" 
$ns at 244.93012385321867 "$node_(277) setdest 131307 16234 2.0" 
$ns at 285.29979673916836 "$node_(277) setdest 27048 39239 14.0" 
$ns at 340.51843940415887 "$node_(277) setdest 108848 19661 18.0" 
$ns at 381.5110924263447 "$node_(277) setdest 92021 35115 1.0" 
$ns at 420.03657055971064 "$node_(277) setdest 89313 22492 3.0" 
$ns at 466.557634682122 "$node_(277) setdest 81068 20855 13.0" 
$ns at 580.1737953669967 "$node_(277) setdest 29787 17811 3.0" 
$ns at 629.5307522264072 "$node_(277) setdest 127482 2720 12.0" 
$ns at 688.4020591446928 "$node_(277) setdest 51675 30932 11.0" 
$ns at 744.9867913936353 "$node_(277) setdest 8881 15408 2.0" 
$ns at 793.9140561117564 "$node_(277) setdest 4731 32820 9.0" 
$ns at 845.546296658276 "$node_(277) setdest 5566 1454 14.0" 
$ns at 230.9034982544838 "$node_(278) setdest 128297 42743 15.0" 
$ns at 297.1898397176774 "$node_(278) setdest 27418 14509 5.0" 
$ns at 374.5315389002202 "$node_(278) setdest 44123 11412 10.0" 
$ns at 430.3493572140592 "$node_(278) setdest 82926 41447 1.0" 
$ns at 461.3367883299516 "$node_(278) setdest 61561 21134 17.0" 
$ns at 645.6145750749299 "$node_(278) setdest 49864 29027 16.0" 
$ns at 830.3769462302544 "$node_(278) setdest 64970 26380 18.0" 
$ns at 231.64546938636192 "$node_(279) setdest 96781 12871 5.0" 
$ns at 292.27159375681305 "$node_(279) setdest 62353 38 13.0" 
$ns at 393.35645958935703 "$node_(279) setdest 87365 43085 2.0" 
$ns at 431.04113120514114 "$node_(279) setdest 71831 42194 16.0" 
$ns at 494.0547628916064 "$node_(279) setdest 101009 6969 7.0" 
$ns at 593.6968560744101 "$node_(279) setdest 70303 13624 9.0" 
$ns at 692.354138173881 "$node_(279) setdest 9967 17431 1.0" 
$ns at 724.4165674354082 "$node_(279) setdest 26365 39798 3.0" 
$ns at 783.1483702291251 "$node_(279) setdest 96829 32331 3.0" 
$ns at 832.2711307415639 "$node_(279) setdest 21823 3368 19.0" 
$ns at 236.2380361986418 "$node_(280) setdest 109218 28999 2.0" 
$ns at 275.12561795761917 "$node_(280) setdest 67163 16054 8.0" 
$ns at 319.293921220273 "$node_(280) setdest 26832 1715 9.0" 
$ns at 403.4612757822627 "$node_(280) setdest 120400 10826 8.0" 
$ns at 456.7631761532975 "$node_(280) setdest 62642 8670 8.0" 
$ns at 495.35939486675335 "$node_(280) setdest 91065 13168 12.0" 
$ns at 614.392615031789 "$node_(280) setdest 85361 2195 15.0" 
$ns at 686.831018940615 "$node_(280) setdest 103425 15867 11.0" 
$ns at 768.3879836626364 "$node_(280) setdest 116196 16807 2.0" 
$ns at 816.4055908275866 "$node_(280) setdest 77278 19108 3.0" 
$ns at 861.7369474984403 "$node_(280) setdest 75150 17266 17.0" 
$ns at 892.0010006803045 "$node_(280) setdest 88983 6850 14.0" 
$ns at 269.9883218549114 "$node_(281) setdest 76476 16490 12.0" 
$ns at 398.3535752464278 "$node_(281) setdest 1251 23360 19.0" 
$ns at 482.48578667644915 "$node_(281) setdest 55917 32176 14.0" 
$ns at 525.7131733112853 "$node_(281) setdest 60422 40047 5.0" 
$ns at 595.7168225723908 "$node_(281) setdest 69359 34323 9.0" 
$ns at 672.2264138625217 "$node_(281) setdest 84102 32577 8.0" 
$ns at 709.7700768101447 "$node_(281) setdest 133250 30141 1.0" 
$ns at 745.1952056729514 "$node_(281) setdest 70358 6822 8.0" 
$ns at 794.4404666904962 "$node_(281) setdest 72674 4848 18.0" 
$ns at 854.457761586745 "$node_(281) setdest 119967 12238 19.0" 
$ns at 241.94601562127912 "$node_(282) setdest 118680 23872 15.0" 
$ns at 414.11484388160625 "$node_(282) setdest 96 14093 7.0" 
$ns at 494.83696894845116 "$node_(282) setdest 6680 2133 10.0" 
$ns at 619.6188110366687 "$node_(282) setdest 54177 36505 4.0" 
$ns at 661.9148425711381 "$node_(282) setdest 26118 40089 12.0" 
$ns at 757.2867245641183 "$node_(282) setdest 50414 36499 18.0" 
$ns at 817.4816394134328 "$node_(282) setdest 71337 10723 20.0" 
$ns at 283.20627200067815 "$node_(283) setdest 88220 10168 6.0" 
$ns at 365.41367253935965 "$node_(283) setdest 106916 13315 6.0" 
$ns at 415.9702171698169 "$node_(283) setdest 42702 39517 1.0" 
$ns at 455.36294986076126 "$node_(283) setdest 48753 22411 1.0" 
$ns at 487.57633647030895 "$node_(283) setdest 121110 37533 15.0" 
$ns at 529.4572702404523 "$node_(283) setdest 105968 23212 20.0" 
$ns at 718.8466356889323 "$node_(283) setdest 9295 10910 5.0" 
$ns at 758.2708138911873 "$node_(283) setdest 45554 19407 3.0" 
$ns at 810.9085601413541 "$node_(283) setdest 79900 11222 2.0" 
$ns at 850.0155762033982 "$node_(283) setdest 33907 28997 20.0" 
$ns at 243.30422267018463 "$node_(284) setdest 78455 27350 1.0" 
$ns at 274.0796958109092 "$node_(284) setdest 12982 11140 8.0" 
$ns at 346.6280181006293 "$node_(284) setdest 60348 9292 8.0" 
$ns at 388.9262666628234 "$node_(284) setdest 9730 12446 3.0" 
$ns at 446.4678917386291 "$node_(284) setdest 93366 36632 1.0" 
$ns at 483.65511682575215 "$node_(284) setdest 9946 29370 17.0" 
$ns at 520.6712278962032 "$node_(284) setdest 1795 35535 16.0" 
$ns at 562.7129892626167 "$node_(284) setdest 38624 28765 3.0" 
$ns at 615.9360827953434 "$node_(284) setdest 69706 7874 4.0" 
$ns at 681.5588861738179 "$node_(284) setdest 33655 653 1.0" 
$ns at 720.9886343947353 "$node_(284) setdest 33546 42515 11.0" 
$ns at 794.9900918867285 "$node_(284) setdest 74322 36915 19.0" 
$ns at 846.1792834962523 "$node_(284) setdest 117446 89 12.0" 
$ns at 895.1287416913408 "$node_(284) setdest 104689 39862 17.0" 
$ns at 302.2083995280401 "$node_(285) setdest 122835 42816 8.0" 
$ns at 405.5159803898672 "$node_(285) setdest 94310 19776 12.0" 
$ns at 438.64687025215284 "$node_(285) setdest 16417 35796 18.0" 
$ns at 518.488714248018 "$node_(285) setdest 93256 17104 5.0" 
$ns at 592.678849322226 "$node_(285) setdest 107235 33217 8.0" 
$ns at 636.4130903104234 "$node_(285) setdest 39575 8563 19.0" 
$ns at 800.1262587429403 "$node_(285) setdest 58418 18368 16.0" 
$ns at 850.3698456127189 "$node_(285) setdest 133826 43268 19.0" 
$ns at 257.47888230292756 "$node_(286) setdest 18703 14409 17.0" 
$ns at 402.6505402370855 "$node_(286) setdest 113581 28461 12.0" 
$ns at 540.4145890483869 "$node_(286) setdest 24786 35036 17.0" 
$ns at 654.3128228240623 "$node_(286) setdest 99663 32675 7.0" 
$ns at 728.127951145172 "$node_(286) setdest 113026 34736 15.0" 
$ns at 822.0957343261962 "$node_(286) setdest 34384 18598 9.0" 
$ns at 882.1867666955591 "$node_(286) setdest 104810 9500 8.0" 
$ns at 235.2013247591063 "$node_(287) setdest 35433 36819 3.0" 
$ns at 266.3907866689976 "$node_(287) setdest 104823 42495 16.0" 
$ns at 343.52325436309684 "$node_(287) setdest 3749 32656 14.0" 
$ns at 455.7196936596296 "$node_(287) setdest 123990 34230 10.0" 
$ns at 493.3189626146561 "$node_(287) setdest 117394 10993 1.0" 
$ns at 532.1880701199016 "$node_(287) setdest 105935 5520 18.0" 
$ns at 700.8819564084567 "$node_(287) setdest 132220 1482 15.0" 
$ns at 811.2069725357248 "$node_(287) setdest 105965 3430 12.0" 
$ns at 857.708978862118 "$node_(287) setdest 11154 32064 16.0" 
$ns at 279.1235814991014 "$node_(288) setdest 47092 30046 9.0" 
$ns at 341.3781006204499 "$node_(288) setdest 59473 36176 18.0" 
$ns at 484.86063243961723 "$node_(288) setdest 84993 28823 9.0" 
$ns at 586.8975752927643 "$node_(288) setdest 11241 9259 12.0" 
$ns at 699.3430079035857 "$node_(288) setdest 114640 39663 20.0" 
$ns at 749.7697350658077 "$node_(288) setdest 76210 32704 5.0" 
$ns at 810.3057342865185 "$node_(288) setdest 9272 19807 6.0" 
$ns at 868.9063762082294 "$node_(288) setdest 102823 21120 11.0" 
$ns at 309.5348920983575 "$node_(289) setdest 40323 12835 19.0" 
$ns at 429.3246749780398 "$node_(289) setdest 42232 6124 12.0" 
$ns at 556.8181805212007 "$node_(289) setdest 39771 16194 9.0" 
$ns at 625.7745678126909 "$node_(289) setdest 51111 35393 7.0" 
$ns at 715.8915540693952 "$node_(289) setdest 41800 35695 13.0" 
$ns at 840.303998996236 "$node_(289) setdest 119018 756 14.0" 
$ns at 881.1576472307742 "$node_(289) setdest 17281 14210 6.0" 
$ns at 309.39483459971495 "$node_(290) setdest 49359 23768 6.0" 
$ns at 381.82805383690817 "$node_(290) setdest 53970 14627 17.0" 
$ns at 498.53514874174243 "$node_(290) setdest 28825 32149 3.0" 
$ns at 556.5419695075132 "$node_(290) setdest 89858 4065 18.0" 
$ns at 696.888373133867 "$node_(290) setdest 67553 43502 4.0" 
$ns at 764.8517057760552 "$node_(290) setdest 67892 21820 20.0" 
$ns at 834.700474416019 "$node_(290) setdest 131186 16903 5.0" 
$ns at 314.5221888796174 "$node_(291) setdest 112045 33158 18.0" 
$ns at 523.4524702634461 "$node_(291) setdest 52754 19077 13.0" 
$ns at 675.5996743312226 "$node_(291) setdest 39686 3893 1.0" 
$ns at 712.7370722924271 "$node_(291) setdest 17712 11042 11.0" 
$ns at 811.8130144616141 "$node_(291) setdest 121230 33824 19.0" 
$ns at 842.1303996027865 "$node_(291) setdest 127951 34242 16.0" 
$ns at 873.7871405730618 "$node_(291) setdest 96353 43169 12.0" 
$ns at 250.9559798791488 "$node_(292) setdest 24377 28678 9.0" 
$ns at 321.10265712746815 "$node_(292) setdest 88873 1035 8.0" 
$ns at 351.68279956454876 "$node_(292) setdest 130301 1666 3.0" 
$ns at 384.6061058480565 "$node_(292) setdest 90275 8902 1.0" 
$ns at 419.63218326711734 "$node_(292) setdest 94570 7588 11.0" 
$ns at 546.9425535885409 "$node_(292) setdest 67121 8974 10.0" 
$ns at 583.8563464944539 "$node_(292) setdest 43107 4905 6.0" 
$ns at 626.0922966440176 "$node_(292) setdest 23586 34037 7.0" 
$ns at 708.2644617028869 "$node_(292) setdest 75280 4147 12.0" 
$ns at 753.1957966515761 "$node_(292) setdest 108346 31486 15.0" 
$ns at 820.3934367200266 "$node_(292) setdest 131364 40272 15.0" 
$ns at 206.87784181806853 "$node_(293) setdest 7462 443 3.0" 
$ns at 259.772033210925 "$node_(293) setdest 105579 5291 9.0" 
$ns at 298.0802130343431 "$node_(293) setdest 27819 933 16.0" 
$ns at 453.7308841176221 "$node_(293) setdest 25849 41193 8.0" 
$ns at 512.1018722264796 "$node_(293) setdest 81005 20192 5.0" 
$ns at 575.389138812515 "$node_(293) setdest 109071 10455 3.0" 
$ns at 628.4908706506142 "$node_(293) setdest 132666 3389 11.0" 
$ns at 667.9497826229634 "$node_(293) setdest 4884 15318 17.0" 
$ns at 734.3531839899371 "$node_(293) setdest 66064 39682 13.0" 
$ns at 874.773218836568 "$node_(293) setdest 98661 30609 9.0" 
$ns at 224.04530582721904 "$node_(294) setdest 20393 12791 12.0" 
$ns at 316.6527968480799 "$node_(294) setdest 110798 6151 8.0" 
$ns at 352.5168637258643 "$node_(294) setdest 69925 19852 3.0" 
$ns at 408.6433315904074 "$node_(294) setdest 29806 17226 9.0" 
$ns at 499.11769724311836 "$node_(294) setdest 42371 15701 4.0" 
$ns at 553.1060335769665 "$node_(294) setdest 65224 17000 9.0" 
$ns at 658.1686560543891 "$node_(294) setdest 22737 27006 9.0" 
$ns at 719.0721828482148 "$node_(294) setdest 120527 42633 14.0" 
$ns at 879.2056715557383 "$node_(294) setdest 106826 653 5.0" 
$ns at 269.390556120118 "$node_(295) setdest 104236 19621 15.0" 
$ns at 372.66788756073015 "$node_(295) setdest 75964 11923 17.0" 
$ns at 459.7849181081849 "$node_(295) setdest 89518 3986 9.0" 
$ns at 536.2611140151366 "$node_(295) setdest 34599 42712 4.0" 
$ns at 584.4967909724966 "$node_(295) setdest 30551 9929 19.0" 
$ns at 694.8782086584844 "$node_(295) setdest 2014 8576 17.0" 
$ns at 764.6221337821685 "$node_(295) setdest 38650 33771 20.0" 
$ns at 835.4712508184707 "$node_(295) setdest 23103 3391 3.0" 
$ns at 865.6324619601575 "$node_(295) setdest 117630 42108 12.0" 
$ns at 263.30446611748135 "$node_(296) setdest 19541 34034 10.0" 
$ns at 383.12673901673503 "$node_(296) setdest 85549 26135 16.0" 
$ns at 534.9710184775396 "$node_(296) setdest 19507 6826 6.0" 
$ns at 589.8045829632773 "$node_(296) setdest 100229 25522 1.0" 
$ns at 621.0327361783756 "$node_(296) setdest 102559 4619 15.0" 
$ns at 774.2977177284831 "$node_(296) setdest 46593 19053 13.0" 
$ns at 871.2941612235788 "$node_(296) setdest 89319 6847 3.0" 
$ns at 207.9638809394706 "$node_(297) setdest 61528 3176 15.0" 
$ns at 276.75213112829647 "$node_(297) setdest 92035 38541 8.0" 
$ns at 309.08236860308057 "$node_(297) setdest 32845 8096 15.0" 
$ns at 386.73415876441413 "$node_(297) setdest 59777 4956 18.0" 
$ns at 487.70171414562355 "$node_(297) setdest 2493 41075 16.0" 
$ns at 613.6358523739714 "$node_(297) setdest 57523 19796 19.0" 
$ns at 768.6421166927034 "$node_(297) setdest 23284 26605 8.0" 
$ns at 814.7219580360776 "$node_(297) setdest 43430 2496 7.0" 
$ns at 862.411058300147 "$node_(297) setdest 108986 30755 10.0" 
$ns at 309.11683538839327 "$node_(298) setdest 4390 10216 1.0" 
$ns at 344.88524280736397 "$node_(298) setdest 123733 37157 8.0" 
$ns at 378.062596594887 "$node_(298) setdest 62902 43262 6.0" 
$ns at 445.3512484140956 "$node_(298) setdest 130549 13907 3.0" 
$ns at 490.98609503925775 "$node_(298) setdest 20989 4272 1.0" 
$ns at 528.4239865350354 "$node_(298) setdest 116181 8811 3.0" 
$ns at 578.6802644003208 "$node_(298) setdest 64441 3005 18.0" 
$ns at 613.3769436426618 "$node_(298) setdest 11919 13784 10.0" 
$ns at 664.8084089785602 "$node_(298) setdest 131360 4018 7.0" 
$ns at 764.4044996978337 "$node_(298) setdest 12289 41416 1.0" 
$ns at 797.2729900035797 "$node_(298) setdest 117837 24773 1.0" 
$ns at 834.4398446663834 "$node_(298) setdest 58524 35102 13.0" 
$ns at 226.30101820817285 "$node_(299) setdest 102907 5225 17.0" 
$ns at 349.9783913392516 "$node_(299) setdest 71881 24580 6.0" 
$ns at 431.32900664245767 "$node_(299) setdest 130795 332 6.0" 
$ns at 513.961338206163 "$node_(299) setdest 130105 40844 1.0" 
$ns at 551.6203947834556 "$node_(299) setdest 12212 29110 19.0" 
$ns at 714.5795083782925 "$node_(299) setdest 29710 27823 10.0" 
$ns at 747.9418271746586 "$node_(299) setdest 55049 27901 3.0" 
$ns at 782.0520844254524 "$node_(299) setdest 30801 29599 6.0" 
$ns at 846.1060946653091 "$node_(299) setdest 116827 10279 2.0" 
$ns at 885.4297374453253 "$node_(299) setdest 113281 40280 13.0" 
$ns at 385.0207070874619 "$node_(300) setdest 124419 3446 15.0" 
$ns at 515.2015324804081 "$node_(300) setdest 88432 19262 13.0" 
$ns at 560.2134159316677 "$node_(300) setdest 51848 21711 13.0" 
$ns at 702.4887510346157 "$node_(300) setdest 97064 36941 10.0" 
$ns at 781.472480080603 "$node_(300) setdest 89412 645 19.0" 
$ns at 400.933379814271 "$node_(301) setdest 122336 43125 20.0" 
$ns at 553.614627207736 "$node_(301) setdest 104916 38637 3.0" 
$ns at 585.0170317616954 "$node_(301) setdest 85870 24943 14.0" 
$ns at 745.1051251795357 "$node_(301) setdest 6482 21434 17.0" 
$ns at 419.04689763880333 "$node_(302) setdest 114801 21796 16.0" 
$ns at 504.5266968522198 "$node_(302) setdest 71993 14270 10.0" 
$ns at 585.408054823089 "$node_(302) setdest 98084 21629 18.0" 
$ns at 758.5791477348107 "$node_(302) setdest 109725 9730 2.0" 
$ns at 791.5366344502902 "$node_(302) setdest 18326 42471 20.0" 
$ns at 303.42942863460473 "$node_(303) setdest 53406 9988 17.0" 
$ns at 413.70130592432105 "$node_(303) setdest 89010 42525 1.0" 
$ns at 443.8667593218917 "$node_(303) setdest 70729 24443 10.0" 
$ns at 526.0548760368492 "$node_(303) setdest 23029 14875 8.0" 
$ns at 558.8105053520477 "$node_(303) setdest 127866 28170 15.0" 
$ns at 702.8863954470822 "$node_(303) setdest 132193 26999 12.0" 
$ns at 820.6137103223036 "$node_(303) setdest 4816 32874 14.0" 
$ns at 383.30660614216004 "$node_(304) setdest 120637 12173 13.0" 
$ns at 507.87359615525133 "$node_(304) setdest 81144 25633 4.0" 
$ns at 548.4774232106374 "$node_(304) setdest 127881 37741 12.0" 
$ns at 674.794626143199 "$node_(304) setdest 33400 16398 11.0" 
$ns at 729.880634966138 "$node_(304) setdest 111719 41735 10.0" 
$ns at 828.8772718471587 "$node_(304) setdest 53592 1134 17.0" 
$ns at 861.100915874961 "$node_(304) setdest 64342 13121 14.0" 
$ns at 369.88901032275703 "$node_(305) setdest 50264 20257 4.0" 
$ns at 435.19179510267145 "$node_(305) setdest 60827 22647 12.0" 
$ns at 508.3351777112405 "$node_(305) setdest 81928 18977 19.0" 
$ns at 661.6194720482727 "$node_(305) setdest 25324 11321 16.0" 
$ns at 787.6505643458315 "$node_(305) setdest 45776 13919 4.0" 
$ns at 828.0197885566504 "$node_(305) setdest 26395 2347 1.0" 
$ns at 862.2481458314508 "$node_(305) setdest 67869 42132 14.0" 
$ns at 392.0282508797868 "$node_(306) setdest 106131 25098 13.0" 
$ns at 477.99454866961116 "$node_(306) setdest 125879 21374 20.0" 
$ns at 688.9054949306861 "$node_(306) setdest 15789 1288 8.0" 
$ns at 760.184797163259 "$node_(306) setdest 61490 12206 4.0" 
$ns at 813.7236294311282 "$node_(306) setdest 112383 36182 9.0" 
$ns at 322.62924207345947 "$node_(307) setdest 84097 20393 7.0" 
$ns at 406.7125005263897 "$node_(307) setdest 37219 37328 8.0" 
$ns at 454.24531565442095 "$node_(307) setdest 97649 42526 15.0" 
$ns at 533.3435153137602 "$node_(307) setdest 27962 14228 5.0" 
$ns at 588.484646180409 "$node_(307) setdest 106756 26461 11.0" 
$ns at 715.5098579705059 "$node_(307) setdest 62568 9696 14.0" 
$ns at 838.3469196405241 "$node_(307) setdest 116053 36220 9.0" 
$ns at 888.3630408289544 "$node_(307) setdest 23747 31088 12.0" 
$ns at 355.2611703837558 "$node_(308) setdest 127724 4958 5.0" 
$ns at 407.8966392431014 "$node_(308) setdest 51266 27059 14.0" 
$ns at 543.0984198703231 "$node_(308) setdest 692 33034 6.0" 
$ns at 595.4826765828368 "$node_(308) setdest 131986 30020 15.0" 
$ns at 657.7748053898641 "$node_(308) setdest 10046 30823 7.0" 
$ns at 712.4534855454544 "$node_(308) setdest 94309 13072 16.0" 
$ns at 868.0330031423026 "$node_(308) setdest 93514 24663 14.0" 
$ns at 335.7731992070865 "$node_(309) setdest 25611 9045 1.0" 
$ns at 375.658973289095 "$node_(309) setdest 105658 32454 1.0" 
$ns at 411.3862196028285 "$node_(309) setdest 101068 39307 10.0" 
$ns at 480.50451826802947 "$node_(309) setdest 41448 26608 9.0" 
$ns at 529.8081748863821 "$node_(309) setdest 27964 40514 1.0" 
$ns at 563.4892990480814 "$node_(309) setdest 119777 44574 13.0" 
$ns at 683.5302602977221 "$node_(309) setdest 89416 42016 4.0" 
$ns at 716.0289548438733 "$node_(309) setdest 105096 827 5.0" 
$ns at 787.2657003115468 "$node_(309) setdest 18330 2645 16.0" 
$ns at 368.1819880887802 "$node_(310) setdest 47 24753 13.0" 
$ns at 481.8265492834812 "$node_(310) setdest 113708 27982 2.0" 
$ns at 518.7720968758279 "$node_(310) setdest 76097 21072 8.0" 
$ns at 587.7027711407793 "$node_(310) setdest 10346 44351 14.0" 
$ns at 715.8306365953983 "$node_(310) setdest 78131 23790 8.0" 
$ns at 797.0687472588886 "$node_(310) setdest 56986 35837 13.0" 
$ns at 358.17391265701315 "$node_(311) setdest 126302 42955 14.0" 
$ns at 399.9451892294515 "$node_(311) setdest 26557 9412 9.0" 
$ns at 457.3007720444831 "$node_(311) setdest 98033 25554 5.0" 
$ns at 503.936516570191 "$node_(311) setdest 124213 44254 9.0" 
$ns at 599.3124529771633 "$node_(311) setdest 53525 3724 8.0" 
$ns at 646.9249208699202 "$node_(311) setdest 67956 1002 19.0" 
$ns at 862.3647983734198 "$node_(311) setdest 785 15732 8.0" 
$ns at 336.22491049969096 "$node_(312) setdest 81987 5969 1.0" 
$ns at 373.53477308799705 "$node_(312) setdest 84344 19674 10.0" 
$ns at 466.88429399190454 "$node_(312) setdest 84525 29375 5.0" 
$ns at 511.3726967003596 "$node_(312) setdest 119915 39487 2.0" 
$ns at 552.3833303699598 "$node_(312) setdest 102353 38347 5.0" 
$ns at 612.4273169732775 "$node_(312) setdest 38987 40163 17.0" 
$ns at 733.9432934920997 "$node_(312) setdest 26725 30619 14.0" 
$ns at 849.2024442578806 "$node_(312) setdest 96433 16564 14.0" 
$ns at 385.15675052264766 "$node_(313) setdest 37248 38301 8.0" 
$ns at 469.23743824983046 "$node_(313) setdest 46819 28439 3.0" 
$ns at 505.8147795268334 "$node_(313) setdest 40029 13787 16.0" 
$ns at 593.6051294749398 "$node_(313) setdest 4728 18278 16.0" 
$ns at 731.6709563153333 "$node_(313) setdest 66870 15189 7.0" 
$ns at 794.4744160939679 "$node_(313) setdest 102428 27943 12.0" 
$ns at 384.83110830299734 "$node_(314) setdest 101237 10599 6.0" 
$ns at 437.6963575156367 "$node_(314) setdest 2203 18017 19.0" 
$ns at 601.2514421560062 "$node_(314) setdest 62788 13750 5.0" 
$ns at 655.1893036867373 "$node_(314) setdest 45647 5244 4.0" 
$ns at 692.7487460764578 "$node_(314) setdest 6645 13897 18.0" 
$ns at 772.4604252622105 "$node_(314) setdest 120534 40184 1.0" 
$ns at 803.5123855260119 "$node_(314) setdest 32812 37491 13.0" 
$ns at 889.1502972064105 "$node_(314) setdest 73077 31617 19.0" 
$ns at 343.7371654377812 "$node_(315) setdest 108080 7205 1.0" 
$ns at 382.1517891014379 "$node_(315) setdest 60935 10039 14.0" 
$ns at 504.4371463153476 "$node_(315) setdest 44464 36090 14.0" 
$ns at 597.9125881799066 "$node_(315) setdest 87523 12293 18.0" 
$ns at 764.7315452741545 "$node_(315) setdest 17087 6050 14.0" 
$ns at 896.662140815177 "$node_(315) setdest 57670 35097 4.0" 
$ns at 313.1209045880431 "$node_(316) setdest 67130 21869 17.0" 
$ns at 431.92794321102053 "$node_(316) setdest 9605 299 17.0" 
$ns at 477.283178479944 "$node_(316) setdest 78812 21081 17.0" 
$ns at 665.3699711840916 "$node_(316) setdest 70436 32760 1.0" 
$ns at 696.5556642919603 "$node_(316) setdest 57311 20759 3.0" 
$ns at 748.446598491879 "$node_(316) setdest 82947 24905 17.0" 
$ns at 373.57335679290804 "$node_(317) setdest 69885 2537 1.0" 
$ns at 410.2059126094481 "$node_(317) setdest 28129 1910 6.0" 
$ns at 478.3274636302217 "$node_(317) setdest 78445 4210 3.0" 
$ns at 517.0747656630928 "$node_(317) setdest 27595 41536 16.0" 
$ns at 591.3858080118711 "$node_(317) setdest 27343 18125 12.0" 
$ns at 698.0522024994289 "$node_(317) setdest 102580 5960 5.0" 
$ns at 746.797165450389 "$node_(317) setdest 17547 9500 6.0" 
$ns at 784.1509967894021 "$node_(317) setdest 125863 36670 18.0" 
$ns at 314.9426654924987 "$node_(318) setdest 122341 154 14.0" 
$ns at 424.11956829660403 "$node_(318) setdest 13242 2823 11.0" 
$ns at 539.6663136798378 "$node_(318) setdest 117382 18426 12.0" 
$ns at 677.3690949931469 "$node_(318) setdest 69546 4066 7.0" 
$ns at 730.0190759094003 "$node_(318) setdest 48949 37774 13.0" 
$ns at 762.7384567731496 "$node_(318) setdest 65960 35236 1.0" 
$ns at 794.6073589080931 "$node_(318) setdest 39206 37535 18.0" 
$ns at 862.8241831595301 "$node_(318) setdest 88150 17430 1.0" 
$ns at 897.7826243728208 "$node_(318) setdest 75953 31553 7.0" 
$ns at 306.47447340658795 "$node_(319) setdest 104052 41062 14.0" 
$ns at 473.30403179488246 "$node_(319) setdest 44593 22010 11.0" 
$ns at 531.8215556516315 "$node_(319) setdest 101959 27141 6.0" 
$ns at 609.8720671554222 "$node_(319) setdest 89028 36564 16.0" 
$ns at 645.9949435187564 "$node_(319) setdest 72032 24448 12.0" 
$ns at 777.5358232429353 "$node_(319) setdest 132964 26860 12.0" 
$ns at 860.963477251202 "$node_(319) setdest 97904 25554 14.0" 
$ns at 899.2085878370598 "$node_(319) setdest 34023 12820 7.0" 
$ns at 393.2375292325506 "$node_(320) setdest 21808 2041 1.0" 
$ns at 433.15825199903645 "$node_(320) setdest 64773 20676 10.0" 
$ns at 497.9130255561173 "$node_(320) setdest 118707 4406 9.0" 
$ns at 582.056341793274 "$node_(320) setdest 128141 5363 13.0" 
$ns at 672.0630849563258 "$node_(320) setdest 80002 19522 15.0" 
$ns at 837.9005125128172 "$node_(320) setdest 43343 41950 18.0" 
$ns at 317.84535032192815 "$node_(321) setdest 105961 4042 15.0" 
$ns at 392.3179607414261 "$node_(321) setdest 114353 12978 10.0" 
$ns at 445.0705005026438 "$node_(321) setdest 90455 27302 16.0" 
$ns at 525.5602037003284 "$node_(321) setdest 78019 41624 15.0" 
$ns at 663.440991995859 "$node_(321) setdest 107507 10762 16.0" 
$ns at 798.5963059600023 "$node_(321) setdest 71856 32274 12.0" 
$ns at 316.014738466341 "$node_(322) setdest 34594 9648 11.0" 
$ns at 372.5606823973612 "$node_(322) setdest 57603 30921 2.0" 
$ns at 421.1759281195427 "$node_(322) setdest 99862 42227 1.0" 
$ns at 458.7780858000035 "$node_(322) setdest 56837 44410 17.0" 
$ns at 548.4237055934678 "$node_(322) setdest 126599 8256 14.0" 
$ns at 698.3966024456627 "$node_(322) setdest 72430 28675 3.0" 
$ns at 746.5510610865921 "$node_(322) setdest 49096 6728 18.0" 
$ns at 876.8734780484548 "$node_(322) setdest 56149 26547 12.0" 
$ns at 304.31107227494215 "$node_(323) setdest 71972 39736 14.0" 
$ns at 365.51692786379135 "$node_(323) setdest 123108 25270 9.0" 
$ns at 464.2939015491635 "$node_(323) setdest 57534 20857 1.0" 
$ns at 494.54376092325646 "$node_(323) setdest 62954 42163 13.0" 
$ns at 544.7931476890732 "$node_(323) setdest 54149 40948 15.0" 
$ns at 633.7777746516829 "$node_(323) setdest 113152 9803 16.0" 
$ns at 768.5223803511024 "$node_(323) setdest 130353 29489 18.0" 
$ns at 439.0132265549854 "$node_(324) setdest 130064 2823 1.0" 
$ns at 469.2035927245474 "$node_(324) setdest 93289 4210 19.0" 
$ns at 639.6347801860879 "$node_(324) setdest 103875 12943 11.0" 
$ns at 759.4913468707987 "$node_(324) setdest 22418 32342 14.0" 
$ns at 886.4486015690031 "$node_(324) setdest 34402 3750 19.0" 
$ns at 320.825981442418 "$node_(325) setdest 117993 2994 16.0" 
$ns at 358.37745914658575 "$node_(325) setdest 85044 14290 15.0" 
$ns at 522.7525962796477 "$node_(325) setdest 124362 20480 4.0" 
$ns at 561.0825179858714 "$node_(325) setdest 131080 38017 1.0" 
$ns at 596.3483471964531 "$node_(325) setdest 130729 25978 9.0" 
$ns at 653.0022669567843 "$node_(325) setdest 91654 7967 5.0" 
$ns at 684.765160311586 "$node_(325) setdest 55867 37689 7.0" 
$ns at 766.274241276052 "$node_(325) setdest 37694 5274 2.0" 
$ns at 812.0331802674366 "$node_(325) setdest 27999 33549 19.0" 
$ns at 337.9854757203078 "$node_(326) setdest 52418 7624 13.0" 
$ns at 446.67309938945675 "$node_(326) setdest 29021 1957 6.0" 
$ns at 520.6076762582877 "$node_(326) setdest 99819 31453 17.0" 
$ns at 585.4262358533401 "$node_(326) setdest 97789 11947 18.0" 
$ns at 774.0107057980289 "$node_(326) setdest 52445 22818 18.0" 
$ns at 329.9677510393511 "$node_(327) setdest 72923 14842 11.0" 
$ns at 399.871924075387 "$node_(327) setdest 132900 16088 12.0" 
$ns at 483.41184931665293 "$node_(327) setdest 41483 31644 17.0" 
$ns at 681.9068467378987 "$node_(327) setdest 14819 14287 2.0" 
$ns at 717.5471856103028 "$node_(327) setdest 55074 36340 3.0" 
$ns at 754.3617354881914 "$node_(327) setdest 23516 7185 19.0" 
$ns at 322.58276883304404 "$node_(328) setdest 106646 31923 9.0" 
$ns at 408.3486041230269 "$node_(328) setdest 103168 17785 13.0" 
$ns at 468.1480786123427 "$node_(328) setdest 103663 12260 2.0" 
$ns at 505.12834869494253 "$node_(328) setdest 70565 20435 14.0" 
$ns at 659.6533920667655 "$node_(328) setdest 54139 8979 7.0" 
$ns at 692.1075367632004 "$node_(328) setdest 5085 14320 6.0" 
$ns at 740.8625083704976 "$node_(328) setdest 108151 1995 9.0" 
$ns at 850.366828732832 "$node_(328) setdest 16609 32114 16.0" 
$ns at 332.705143501759 "$node_(329) setdest 9555 948 15.0" 
$ns at 410.7794206945114 "$node_(329) setdest 116170 25348 9.0" 
$ns at 445.58967214809167 "$node_(329) setdest 25363 10331 14.0" 
$ns at 601.199927728684 "$node_(329) setdest 128853 44149 16.0" 
$ns at 647.4329902493566 "$node_(329) setdest 47944 1052 2.0" 
$ns at 686.6649375724525 "$node_(329) setdest 106251 28248 5.0" 
$ns at 764.2360597303675 "$node_(329) setdest 24123 21222 19.0" 
$ns at 800.7836888764698 "$node_(329) setdest 30882 32932 2.0" 
$ns at 832.9671117826614 "$node_(329) setdest 39808 7291 17.0" 
$ns at 365.6624979436609 "$node_(330) setdest 22525 40255 11.0" 
$ns at 461.26126168873304 "$node_(330) setdest 23501 38452 2.0" 
$ns at 503.7408717557261 "$node_(330) setdest 110459 230 15.0" 
$ns at 657.4190101323959 "$node_(330) setdest 78610 8895 12.0" 
$ns at 787.1656093146989 "$node_(330) setdest 27001 15871 19.0" 
$ns at 368.9786336708214 "$node_(331) setdest 7246 20843 18.0" 
$ns at 572.0388592094205 "$node_(331) setdest 59832 26919 7.0" 
$ns at 640.3994211062671 "$node_(331) setdest 37320 9411 12.0" 
$ns at 699.3815362072693 "$node_(331) setdest 72144 8127 14.0" 
$ns at 780.4991789198972 "$node_(331) setdest 130651 18010 5.0" 
$ns at 810.7176820961481 "$node_(331) setdest 45653 15805 4.0" 
$ns at 853.8270628171377 "$node_(331) setdest 17837 33981 5.0" 
$ns at 354.6977080461438 "$node_(332) setdest 123402 44150 4.0" 
$ns at 385.84529478035125 "$node_(332) setdest 129049 2252 10.0" 
$ns at 515.7034081268465 "$node_(332) setdest 103238 40212 5.0" 
$ns at 592.3518441608624 "$node_(332) setdest 79973 19296 20.0" 
$ns at 763.3908615669013 "$node_(332) setdest 40473 15757 4.0" 
$ns at 816.7999138063977 "$node_(332) setdest 32946 14287 3.0" 
$ns at 870.2859214643712 "$node_(332) setdest 52641 12895 1.0" 
$ns at 388.1929382970158 "$node_(333) setdest 119113 42207 16.0" 
$ns at 547.5570222330044 "$node_(333) setdest 34270 22800 15.0" 
$ns at 699.5241047991155 "$node_(333) setdest 9349 20519 12.0" 
$ns at 848.2942489838076 "$node_(333) setdest 55749 21261 15.0" 
$ns at 336.212175234832 "$node_(334) setdest 26048 25473 5.0" 
$ns at 380.9164808756089 "$node_(334) setdest 86037 20191 3.0" 
$ns at 423.0065268333246 "$node_(334) setdest 85177 44621 4.0" 
$ns at 473.6128755199313 "$node_(334) setdest 96122 37646 5.0" 
$ns at 552.1280560057143 "$node_(334) setdest 113693 9218 2.0" 
$ns at 590.0560352104117 "$node_(334) setdest 128821 34623 7.0" 
$ns at 668.6768798761718 "$node_(334) setdest 41792 11429 17.0" 
$ns at 699.5063188695184 "$node_(334) setdest 71072 7584 16.0" 
$ns at 885.1650295120237 "$node_(334) setdest 99921 2885 2.0" 
$ns at 354.2818827488494 "$node_(335) setdest 133945 43631 1.0" 
$ns at 385.94901865106885 "$node_(335) setdest 100127 41493 10.0" 
$ns at 483.2335727654732 "$node_(335) setdest 118191 12439 3.0" 
$ns at 535.9444297065385 "$node_(335) setdest 40746 16500 20.0" 
$ns at 589.1569857714717 "$node_(335) setdest 117648 13640 1.0" 
$ns at 620.495273967173 "$node_(335) setdest 87950 31459 6.0" 
$ns at 673.0118524720405 "$node_(335) setdest 107874 22684 2.0" 
$ns at 715.6584006546884 "$node_(335) setdest 49203 22721 5.0" 
$ns at 790.6839177081629 "$node_(335) setdest 58171 35423 3.0" 
$ns at 822.50327427406 "$node_(335) setdest 36276 35567 15.0" 
$ns at 367.29554333996765 "$node_(336) setdest 35003 42204 1.0" 
$ns at 399.21864114483014 "$node_(336) setdest 29000 35844 1.0" 
$ns at 430.5126710715071 "$node_(336) setdest 30001 15106 2.0" 
$ns at 474.2093213852115 "$node_(336) setdest 28564 12658 12.0" 
$ns at 615.2172224942569 "$node_(336) setdest 133226 39594 7.0" 
$ns at 656.5692133864304 "$node_(336) setdest 78491 27908 9.0" 
$ns at 775.613605724722 "$node_(336) setdest 58676 26589 13.0" 
$ns at 378.2071756377416 "$node_(337) setdest 126751 21409 16.0" 
$ns at 476.724503275254 "$node_(337) setdest 126956 8757 8.0" 
$ns at 563.1620272129219 "$node_(337) setdest 30151 16593 15.0" 
$ns at 731.8928777894876 "$node_(337) setdest 106503 35547 10.0" 
$ns at 851.30734914447 "$node_(337) setdest 61047 1084 20.0" 
$ns at 327.5805821654104 "$node_(338) setdest 19533 12895 20.0" 
$ns at 373.12075449579453 "$node_(338) setdest 123605 27870 2.0" 
$ns at 405.9684273339151 "$node_(338) setdest 132020 37397 19.0" 
$ns at 518.5257197887101 "$node_(338) setdest 38044 11416 1.0" 
$ns at 549.8636290914485 "$node_(338) setdest 90966 20213 9.0" 
$ns at 644.8237403837802 "$node_(338) setdest 45517 43338 14.0" 
$ns at 686.039700736025 "$node_(338) setdest 128824 19688 4.0" 
$ns at 738.9558517946501 "$node_(338) setdest 102595 4965 10.0" 
$ns at 835.7438148985086 "$node_(338) setdest 42741 43077 17.0" 
$ns at 322.8610107377247 "$node_(339) setdest 23444 3880 18.0" 
$ns at 463.9844967868262 "$node_(339) setdest 123190 3464 19.0" 
$ns at 593.0343896180245 "$node_(339) setdest 91275 24073 2.0" 
$ns at 636.5857583321036 "$node_(339) setdest 109381 479 7.0" 
$ns at 725.5720003568597 "$node_(339) setdest 67632 17586 15.0" 
$ns at 864.02329517309 "$node_(339) setdest 43717 8075 8.0" 
$ns at 326.69465633743937 "$node_(340) setdest 130378 15224 11.0" 
$ns at 451.3589398781505 "$node_(340) setdest 39486 5829 14.0" 
$ns at 577.6492403069489 "$node_(340) setdest 120069 2568 14.0" 
$ns at 723.1301621690982 "$node_(340) setdest 110375 39516 9.0" 
$ns at 837.4222433177222 "$node_(340) setdest 52734 36612 4.0" 
$ns at 301.8399901659707 "$node_(341) setdest 101516 4814 7.0" 
$ns at 363.40985430346586 "$node_(341) setdest 33156 10843 12.0" 
$ns at 477.8332318500956 "$node_(341) setdest 95314 30887 3.0" 
$ns at 518.8635200899265 "$node_(341) setdest 50436 43996 5.0" 
$ns at 592.1625379206191 "$node_(341) setdest 8379 9122 16.0" 
$ns at 719.6279165656804 "$node_(341) setdest 53672 40143 14.0" 
$ns at 755.102294896915 "$node_(341) setdest 113199 34112 1.0" 
$ns at 787.9605740076867 "$node_(341) setdest 118575 43278 4.0" 
$ns at 824.7499680814226 "$node_(341) setdest 68471 2577 12.0" 
$ns at 321.15640041109657 "$node_(342) setdest 91154 14399 7.0" 
$ns at 409.03741218588794 "$node_(342) setdest 123574 43098 3.0" 
$ns at 441.26773212770996 "$node_(342) setdest 76546 26320 4.0" 
$ns at 482.2168118979357 "$node_(342) setdest 62864 35777 1.0" 
$ns at 521.4109750580739 "$node_(342) setdest 13038 7621 4.0" 
$ns at 554.7843983299522 "$node_(342) setdest 95711 13341 10.0" 
$ns at 585.9297289747766 "$node_(342) setdest 24030 30055 19.0" 
$ns at 673.208121452641 "$node_(342) setdest 76833 7465 4.0" 
$ns at 729.7420410016948 "$node_(342) setdest 114235 39505 12.0" 
$ns at 868.0416494974216 "$node_(342) setdest 90713 36655 12.0" 
$ns at 323.90098730613715 "$node_(343) setdest 36067 17589 17.0" 
$ns at 406.2399968131931 "$node_(343) setdest 132426 19973 5.0" 
$ns at 442.46254904486983 "$node_(343) setdest 6640 41145 7.0" 
$ns at 492.9710031813976 "$node_(343) setdest 122911 40945 3.0" 
$ns at 541.8981492550344 "$node_(343) setdest 63236 20658 9.0" 
$ns at 658.978168291364 "$node_(343) setdest 33185 39525 2.0" 
$ns at 691.744399808397 "$node_(343) setdest 47532 13574 14.0" 
$ns at 792.189576656503 "$node_(343) setdest 121423 41648 8.0" 
$ns at 824.9561886169314 "$node_(343) setdest 54717 8020 11.0" 
$ns at 879.9483490225613 "$node_(343) setdest 126134 41216 2.0" 
$ns at 328.89421521763217 "$node_(344) setdest 59773 19707 13.0" 
$ns at 374.7680373423679 "$node_(344) setdest 133929 1186 11.0" 
$ns at 417.1715837797422 "$node_(344) setdest 56430 42439 5.0" 
$ns at 449.42064435188666 "$node_(344) setdest 129746 42100 17.0" 
$ns at 529.8297831475275 "$node_(344) setdest 112014 13205 15.0" 
$ns at 631.000023812808 "$node_(344) setdest 8324 31847 16.0" 
$ns at 770.1516375653684 "$node_(344) setdest 62082 28173 11.0" 
$ns at 833.7756161542391 "$node_(344) setdest 63855 13705 18.0" 
$ns at 362.8866858478777 "$node_(345) setdest 126159 38469 2.0" 
$ns at 393.7783280600169 "$node_(345) setdest 104059 23183 17.0" 
$ns at 532.9248292433517 "$node_(345) setdest 110899 39557 2.0" 
$ns at 574.075999086782 "$node_(345) setdest 107075 37065 10.0" 
$ns at 606.8734869616954 "$node_(345) setdest 99738 1626 4.0" 
$ns at 654.2128581961796 "$node_(345) setdest 79659 42236 5.0" 
$ns at 699.0182916838728 "$node_(345) setdest 66031 28426 19.0" 
$ns at 786.9596452297369 "$node_(345) setdest 73442 30996 2.0" 
$ns at 829.4208957013348 "$node_(345) setdest 3525 39047 5.0" 
$ns at 327.9874030585335 "$node_(346) setdest 74789 29322 17.0" 
$ns at 365.4538412003592 "$node_(346) setdest 62140 8322 15.0" 
$ns at 398.9092453156934 "$node_(346) setdest 105314 11825 6.0" 
$ns at 468.52706577682727 "$node_(346) setdest 45372 28682 15.0" 
$ns at 556.8472931669518 "$node_(346) setdest 119130 23880 15.0" 
$ns at 729.5302008096395 "$node_(346) setdest 94644 6961 19.0" 
$ns at 881.4806378707735 "$node_(346) setdest 10096 29697 2.0" 
$ns at 354.5560037953454 "$node_(347) setdest 90831 22698 18.0" 
$ns at 527.9400134131723 "$node_(347) setdest 31582 32889 16.0" 
$ns at 645.8562323019717 "$node_(347) setdest 24930 16670 14.0" 
$ns at 758.7486546111513 "$node_(347) setdest 132917 15807 2.0" 
$ns at 791.7375563662201 "$node_(347) setdest 77998 42955 10.0" 
$ns at 888.4099497867487 "$node_(347) setdest 61391 4674 12.0" 
$ns at 345.2502350375671 "$node_(348) setdest 33551 552 15.0" 
$ns at 486.75736729683854 "$node_(348) setdest 60780 27716 10.0" 
$ns at 553.7839532685177 "$node_(348) setdest 7935 29602 15.0" 
$ns at 731.509686794082 "$node_(348) setdest 89410 39789 13.0" 
$ns at 827.6720197674138 "$node_(348) setdest 84597 20681 10.0" 
$ns at 302.70813280843504 "$node_(349) setdest 89136 40308 20.0" 
$ns at 506.2250971381219 "$node_(349) setdest 39445 2240 10.0" 
$ns at 596.2504301806244 "$node_(349) setdest 77285 13224 1.0" 
$ns at 629.4777998951304 "$node_(349) setdest 84737 29500 15.0" 
$ns at 767.288301505318 "$node_(349) setdest 45032 40099 4.0" 
$ns at 807.1628531493834 "$node_(349) setdest 43259 21276 3.0" 
$ns at 838.621980167873 "$node_(349) setdest 31699 5957 14.0" 
$ns at 389.0622788574343 "$node_(350) setdest 3563 3283 4.0" 
$ns at 432.81767601484785 "$node_(350) setdest 87669 10482 6.0" 
$ns at 492.80106340317093 "$node_(350) setdest 79995 41082 14.0" 
$ns at 606.0146333602647 "$node_(350) setdest 107406 18532 14.0" 
$ns at 671.2815285609713 "$node_(350) setdest 9232 8930 12.0" 
$ns at 805.8110518428189 "$node_(350) setdest 43801 18275 8.0" 
$ns at 340.94338556022274 "$node_(351) setdest 15187 13823 12.0" 
$ns at 432.4111801730534 "$node_(351) setdest 119788 43557 8.0" 
$ns at 493.11920560918674 "$node_(351) setdest 134084 20437 17.0" 
$ns at 634.0804588816775 "$node_(351) setdest 28827 15345 19.0" 
$ns at 829.3083441657351 "$node_(351) setdest 361 17735 19.0" 
$ns at 324.4580098136327 "$node_(352) setdest 34333 34259 13.0" 
$ns at 426.557529511924 "$node_(352) setdest 46176 29832 20.0" 
$ns at 621.3350246085482 "$node_(352) setdest 63566 42513 6.0" 
$ns at 685.643540224541 "$node_(352) setdest 117072 4324 19.0" 
$ns at 719.9375636416161 "$node_(352) setdest 63440 10943 4.0" 
$ns at 759.321832163813 "$node_(352) setdest 26318 26451 8.0" 
$ns at 866.0059396628942 "$node_(352) setdest 87248 8881 14.0" 
$ns at 899.0151571738625 "$node_(352) setdest 109742 23472 3.0" 
$ns at 403.3166605748715 "$node_(353) setdest 97541 24560 7.0" 
$ns at 487.87844564735354 "$node_(353) setdest 123731 42489 6.0" 
$ns at 529.5309735254692 "$node_(353) setdest 50052 7333 4.0" 
$ns at 565.2923078628157 "$node_(353) setdest 24209 15828 1.0" 
$ns at 599.962816994372 "$node_(353) setdest 122975 17152 18.0" 
$ns at 701.1824718680155 "$node_(353) setdest 29640 31589 2.0" 
$ns at 736.4245350254007 "$node_(353) setdest 69029 25870 14.0" 
$ns at 840.806626126043 "$node_(353) setdest 8855 18095 15.0" 
$ns at 885.1457521549927 "$node_(353) setdest 106598 28078 8.0" 
$ns at 322.7286884858119 "$node_(354) setdest 31785 24358 17.0" 
$ns at 359.0514829140052 "$node_(354) setdest 902 13895 15.0" 
$ns at 391.7064759073862 "$node_(354) setdest 125243 43514 2.0" 
$ns at 424.2983195930532 "$node_(354) setdest 54691 40972 11.0" 
$ns at 454.5113612806344 "$node_(354) setdest 3920 12031 10.0" 
$ns at 494.40211955215534 "$node_(354) setdest 128274 18915 8.0" 
$ns at 531.724524765869 "$node_(354) setdest 5450 13234 19.0" 
$ns at 595.8475857604515 "$node_(354) setdest 22568 27876 14.0" 
$ns at 630.5477885176883 "$node_(354) setdest 120164 41861 15.0" 
$ns at 695.7025884149807 "$node_(354) setdest 111050 7703 3.0" 
$ns at 746.7923411768155 "$node_(354) setdest 22509 2790 14.0" 
$ns at 865.3861055091926 "$node_(354) setdest 71309 23464 1.0" 
$ns at 399.5959219858751 "$node_(355) setdest 47091 23199 6.0" 
$ns at 430.52031421864734 "$node_(355) setdest 29755 36961 3.0" 
$ns at 465.02090343648456 "$node_(355) setdest 24359 25229 18.0" 
$ns at 646.0879159876431 "$node_(355) setdest 24315 43477 2.0" 
$ns at 689.6896407553728 "$node_(355) setdest 95129 6730 7.0" 
$ns at 724.2737624186177 "$node_(355) setdest 17301 27948 11.0" 
$ns at 768.1731985140024 "$node_(355) setdest 24704 15443 6.0" 
$ns at 831.1555061715449 "$node_(355) setdest 129719 4618 18.0" 
$ns at 312.2067536115724 "$node_(356) setdest 113416 31668 4.0" 
$ns at 376.938868684848 "$node_(356) setdest 59149 34484 4.0" 
$ns at 421.3931194994291 "$node_(356) setdest 74272 2234 10.0" 
$ns at 537.8277010536855 "$node_(356) setdest 117592 32572 16.0" 
$ns at 579.4945461677186 "$node_(356) setdest 102406 2383 13.0" 
$ns at 695.9268732193871 "$node_(356) setdest 31391 35743 4.0" 
$ns at 760.919676964095 "$node_(356) setdest 131760 36117 1.0" 
$ns at 793.6830216461094 "$node_(356) setdest 3717 3653 16.0" 
$ns at 303.23545087488446 "$node_(357) setdest 45732 42155 10.0" 
$ns at 389.83883843111 "$node_(357) setdest 61568 18010 9.0" 
$ns at 461.4247447268684 "$node_(357) setdest 48637 9366 13.0" 
$ns at 621.1941787337056 "$node_(357) setdest 46588 41566 5.0" 
$ns at 684.2662650458816 "$node_(357) setdest 117478 19897 19.0" 
$ns at 796.7679347347062 "$node_(357) setdest 9715 31084 2.0" 
$ns at 840.4677602733009 "$node_(357) setdest 123955 35784 4.0" 
$ns at 896.9907730518929 "$node_(357) setdest 105582 24540 4.0" 
$ns at 376.53899593611425 "$node_(358) setdest 118835 20923 10.0" 
$ns at 496.92721971728685 "$node_(358) setdest 31699 42334 16.0" 
$ns at 650.5091018609114 "$node_(358) setdest 76062 19820 19.0" 
$ns at 859.228763666063 "$node_(358) setdest 66879 15045 13.0" 
$ns at 426.0978002697949 "$node_(359) setdest 67030 18091 17.0" 
$ns at 480.60333949475 "$node_(359) setdest 62065 11033 1.0" 
$ns at 520.0050554268371 "$node_(359) setdest 127663 4705 7.0" 
$ns at 613.3508785304347 "$node_(359) setdest 122789 18673 20.0" 
$ns at 690.4858493921606 "$node_(359) setdest 78175 29985 4.0" 
$ns at 741.7042049728285 "$node_(359) setdest 23437 5643 18.0" 
$ns at 898.5575938184788 "$node_(359) setdest 108992 24080 15.0" 
$ns at 429.776352104382 "$node_(360) setdest 33622 36904 5.0" 
$ns at 468.0296832003839 "$node_(360) setdest 63101 17204 2.0" 
$ns at 516.9834944139081 "$node_(360) setdest 60316 6163 16.0" 
$ns at 648.4525213352301 "$node_(360) setdest 127734 22815 17.0" 
$ns at 822.321394822102 "$node_(360) setdest 24487 12987 19.0" 
$ns at 895.5875446018615 "$node_(360) setdest 49069 17943 14.0" 
$ns at 371.3090138854828 "$node_(361) setdest 18453 14853 9.0" 
$ns at 446.21032075078676 "$node_(361) setdest 103894 36359 11.0" 
$ns at 513.1391177160878 "$node_(361) setdest 16294 31572 3.0" 
$ns at 551.6188106052406 "$node_(361) setdest 128311 39764 12.0" 
$ns at 645.2193962079698 "$node_(361) setdest 22147 21707 16.0" 
$ns at 796.2141200294337 "$node_(361) setdest 124520 24863 7.0" 
$ns at 888.3144565102351 "$node_(361) setdest 66232 32796 8.0" 
$ns at 419.2066269305157 "$node_(362) setdest 85997 9083 8.0" 
$ns at 512.4982711366275 "$node_(362) setdest 77255 43481 1.0" 
$ns at 542.5082207695636 "$node_(362) setdest 124693 21522 10.0" 
$ns at 624.1535086824293 "$node_(362) setdest 86986 42813 8.0" 
$ns at 678.3437310624674 "$node_(362) setdest 46356 1720 1.0" 
$ns at 709.5870059547115 "$node_(362) setdest 83272 23116 10.0" 
$ns at 744.0920183340475 "$node_(362) setdest 86702 2443 16.0" 
$ns at 840.0669375534261 "$node_(362) setdest 33459 3528 15.0" 
$ns at 304.6914973377309 "$node_(363) setdest 41478 31255 18.0" 
$ns at 336.89469555709763 "$node_(363) setdest 54800 42728 5.0" 
$ns at 404.9598342467776 "$node_(363) setdest 123098 21150 10.0" 
$ns at 476.5789255116953 "$node_(363) setdest 123678 7887 11.0" 
$ns at 615.2083405186481 "$node_(363) setdest 51278 40906 18.0" 
$ns at 697.4954383681384 "$node_(363) setdest 83048 1711 4.0" 
$ns at 750.2875402342374 "$node_(363) setdest 103606 12124 6.0" 
$ns at 803.7315172925827 "$node_(363) setdest 33030 31648 15.0" 
$ns at 878.033475396847 "$node_(363) setdest 52968 9200 15.0" 
$ns at 332.7770545570423 "$node_(364) setdest 51119 35155 15.0" 
$ns at 477.1669507789819 "$node_(364) setdest 39276 11638 8.0" 
$ns at 523.2538111546111 "$node_(364) setdest 73238 34293 4.0" 
$ns at 584.6741067594777 "$node_(364) setdest 2307 22179 16.0" 
$ns at 664.6153416635448 "$node_(364) setdest 55545 24813 16.0" 
$ns at 753.2389238364625 "$node_(364) setdest 9685 15280 20.0" 
$ns at 839.2508927037479 "$node_(364) setdest 28621 42884 9.0" 
$ns at 348.737505190717 "$node_(365) setdest 73062 36459 3.0" 
$ns at 400.75352000627083 "$node_(365) setdest 24641 14083 17.0" 
$ns at 520.5995862928056 "$node_(365) setdest 75638 4986 15.0" 
$ns at 679.8823533873556 "$node_(365) setdest 55833 19107 6.0" 
$ns at 746.2661161942995 "$node_(365) setdest 132322 25407 16.0" 
$ns at 815.5398595075843 "$node_(365) setdest 105460 31979 2.0" 
$ns at 848.9312770061329 "$node_(365) setdest 131209 11902 20.0" 
$ns at 316.7352587387909 "$node_(366) setdest 49220 4287 10.0" 
$ns at 436.4211351540694 "$node_(366) setdest 79847 10257 19.0" 
$ns at 646.684613539024 "$node_(366) setdest 83699 44560 13.0" 
$ns at 698.660961521546 "$node_(366) setdest 45102 2966 19.0" 
$ns at 797.0665944720861 "$node_(366) setdest 25427 15576 8.0" 
$ns at 854.4806095239821 "$node_(366) setdest 59320 31158 5.0" 
$ns at 324.68817482956274 "$node_(367) setdest 44302 12864 11.0" 
$ns at 395.8155914128159 "$node_(367) setdest 88903 28711 10.0" 
$ns at 439.5725062898538 "$node_(367) setdest 65205 20595 18.0" 
$ns at 501.21933821174844 "$node_(367) setdest 107162 1395 18.0" 
$ns at 614.6098241367301 "$node_(367) setdest 19318 27513 2.0" 
$ns at 648.6117207739748 "$node_(367) setdest 120084 4027 1.0" 
$ns at 682.5068256763525 "$node_(367) setdest 15242 41737 6.0" 
$ns at 768.8825687084111 "$node_(367) setdest 1079 36904 3.0" 
$ns at 818.6528699693906 "$node_(367) setdest 14824 8221 7.0" 
$ns at 305.6771980692029 "$node_(368) setdest 86964 23451 10.0" 
$ns at 416.33552576219375 "$node_(368) setdest 42923 21006 17.0" 
$ns at 589.8984785315236 "$node_(368) setdest 36353 24345 15.0" 
$ns at 629.951562363769 "$node_(368) setdest 86104 3561 20.0" 
$ns at 766.910492751756 "$node_(368) setdest 129479 43859 3.0" 
$ns at 824.9185812591173 "$node_(368) setdest 125637 32426 2.0" 
$ns at 863.0630664183344 "$node_(368) setdest 37903 33664 8.0" 
$ns at 309.1876196663084 "$node_(369) setdest 123875 2125 13.0" 
$ns at 444.6380857345947 "$node_(369) setdest 99185 40996 8.0" 
$ns at 527.0257660730957 "$node_(369) setdest 78114 11829 15.0" 
$ns at 635.6715676440572 "$node_(369) setdest 131568 29150 12.0" 
$ns at 709.1258403026178 "$node_(369) setdest 86619 40052 4.0" 
$ns at 778.166453028382 "$node_(369) setdest 103671 32371 18.0" 
$ns at 394.1164965106537 "$node_(370) setdest 133142 31684 12.0" 
$ns at 494.0803618027975 "$node_(370) setdest 129543 507 12.0" 
$ns at 636.3534462074766 "$node_(370) setdest 8388 23978 4.0" 
$ns at 683.8827817532249 "$node_(370) setdest 66522 20736 15.0" 
$ns at 824.6647329824934 "$node_(370) setdest 41120 38081 18.0" 
$ns at 314.6284923710263 "$node_(371) setdest 116449 6258 1.0" 
$ns at 344.99082308628454 "$node_(371) setdest 84240 38 3.0" 
$ns at 376.5162400417638 "$node_(371) setdest 105011 36557 16.0" 
$ns at 422.7946151114541 "$node_(371) setdest 119702 9159 1.0" 
$ns at 459.04822402256 "$node_(371) setdest 12210 2907 11.0" 
$ns at 539.9695180095466 "$node_(371) setdest 93749 29672 5.0" 
$ns at 584.3644504285676 "$node_(371) setdest 129585 141 15.0" 
$ns at 622.652269208095 "$node_(371) setdest 88167 5763 9.0" 
$ns at 663.3374458413979 "$node_(371) setdest 14783 27917 15.0" 
$ns at 711.4342199403848 "$node_(371) setdest 133645 4429 8.0" 
$ns at 791.2654120854625 "$node_(371) setdest 34577 40594 19.0" 
$ns at 415.22536818378313 "$node_(372) setdest 106907 42669 7.0" 
$ns at 492.48781096549834 "$node_(372) setdest 103853 27244 13.0" 
$ns at 606.1970544403899 "$node_(372) setdest 12368 40665 13.0" 
$ns at 701.3741948935437 "$node_(372) setdest 50250 30564 10.0" 
$ns at 783.7104307327168 "$node_(372) setdest 21638 18115 2.0" 
$ns at 820.5120540861843 "$node_(372) setdest 40980 33569 12.0" 
$ns at 409.34068220094605 "$node_(373) setdest 6504 20496 3.0" 
$ns at 440.20488230413565 "$node_(373) setdest 106323 27524 17.0" 
$ns at 612.5134206759246 "$node_(373) setdest 41805 29007 4.0" 
$ns at 668.9816915555316 "$node_(373) setdest 104607 31376 4.0" 
$ns at 702.7476098477347 "$node_(373) setdest 107979 31887 7.0" 
$ns at 751.1210470208764 "$node_(373) setdest 84847 37968 10.0" 
$ns at 796.9707827324584 "$node_(373) setdest 97826 28330 1.0" 
$ns at 835.9255778690545 "$node_(373) setdest 4038 14185 6.0" 
$ns at 894.856583672483 "$node_(373) setdest 17218 9728 3.0" 
$ns at 302.6068494672295 "$node_(374) setdest 81560 15770 15.0" 
$ns at 476.14949894741494 "$node_(374) setdest 29534 26090 17.0" 
$ns at 608.8029902791656 "$node_(374) setdest 28024 2438 5.0" 
$ns at 640.6041620521352 "$node_(374) setdest 129569 35862 7.0" 
$ns at 684.1282474208615 "$node_(374) setdest 41252 35187 14.0" 
$ns at 808.7989426485939 "$node_(374) setdest 11313 12996 12.0" 
$ns at 386.8663779067556 "$node_(375) setdest 38240 11236 7.0" 
$ns at 448.17852389702426 "$node_(375) setdest 108784 10339 4.0" 
$ns at 508.6449257945008 "$node_(375) setdest 118469 8269 17.0" 
$ns at 635.2810058303035 "$node_(375) setdest 63749 31409 18.0" 
$ns at 735.157092142373 "$node_(375) setdest 82231 23977 2.0" 
$ns at 782.2773850624632 "$node_(375) setdest 4661 6297 6.0" 
$ns at 835.8896686997715 "$node_(375) setdest 60611 10181 3.0" 
$ns at 889.3455825287595 "$node_(375) setdest 99815 27670 1.0" 
$ns at 375.1910524040054 "$node_(376) setdest 95530 3879 7.0" 
$ns at 417.7971035219714 "$node_(376) setdest 15733 6782 9.0" 
$ns at 452.8957273112738 "$node_(376) setdest 21988 40507 2.0" 
$ns at 493.3613940578924 "$node_(376) setdest 106269 28876 20.0" 
$ns at 552.5277164786011 "$node_(376) setdest 23767 34293 12.0" 
$ns at 696.2303998869977 "$node_(376) setdest 3600 2962 4.0" 
$ns at 762.133744911135 "$node_(376) setdest 27417 1149 1.0" 
$ns at 801.7907589737838 "$node_(376) setdest 39113 21373 13.0" 
$ns at 832.3022097376122 "$node_(376) setdest 44071 39246 14.0" 
$ns at 305.79860456866135 "$node_(377) setdest 95921 8893 16.0" 
$ns at 411.6770286331591 "$node_(377) setdest 25437 1704 15.0" 
$ns at 448.68473759396835 "$node_(377) setdest 15922 31155 6.0" 
$ns at 483.9254666944381 "$node_(377) setdest 117017 16674 16.0" 
$ns at 514.7794887941064 "$node_(377) setdest 56371 43127 16.0" 
$ns at 602.612729536507 "$node_(377) setdest 123278 15166 3.0" 
$ns at 638.7133316771819 "$node_(377) setdest 109887 34770 5.0" 
$ns at 713.9626577677943 "$node_(377) setdest 51670 13567 10.0" 
$ns at 829.0513265718866 "$node_(377) setdest 89508 9824 1.0" 
$ns at 861.3784636473214 "$node_(377) setdest 104337 29922 10.0" 
$ns at 389.43641330318223 "$node_(378) setdest 127621 33080 16.0" 
$ns at 440.85324842247775 "$node_(378) setdest 114715 9203 6.0" 
$ns at 498.88163164164234 "$node_(378) setdest 23144 19026 19.0" 
$ns at 627.8918887485922 "$node_(378) setdest 22158 31046 4.0" 
$ns at 662.5819789791261 "$node_(378) setdest 121 25047 9.0" 
$ns at 700.917594579176 "$node_(378) setdest 78606 22840 8.0" 
$ns at 806.7142738356944 "$node_(378) setdest 5088 28779 10.0" 
$ns at 852.6744724826971 "$node_(378) setdest 119872 16248 10.0" 
$ns at 891.1100381302742 "$node_(378) setdest 106477 11267 17.0" 
$ns at 382.4207656332277 "$node_(379) setdest 34907 41524 13.0" 
$ns at 515.6053825892931 "$node_(379) setdest 24682 35439 12.0" 
$ns at 551.2254266227058 "$node_(379) setdest 114525 33389 11.0" 
$ns at 673.2442194714544 "$node_(379) setdest 53250 20428 7.0" 
$ns at 753.7233105335583 "$node_(379) setdest 97266 10835 4.0" 
$ns at 802.2782020190076 "$node_(379) setdest 126923 11122 19.0" 
$ns at 403.32830998592436 "$node_(380) setdest 939 37434 16.0" 
$ns at 581.7298958036242 "$node_(380) setdest 55414 4824 12.0" 
$ns at 691.4373918465915 "$node_(380) setdest 84338 5319 6.0" 
$ns at 774.2470599564758 "$node_(380) setdest 45774 2718 6.0" 
$ns at 815.6233101848795 "$node_(380) setdest 99151 4477 10.0" 
$ns at 896.8129922095109 "$node_(380) setdest 101085 26891 17.0" 
$ns at 373.06115735745834 "$node_(381) setdest 94908 8895 15.0" 
$ns at 426.9550742563322 "$node_(381) setdest 75429 26877 14.0" 
$ns at 474.11580772664763 "$node_(381) setdest 94084 21141 16.0" 
$ns at 660.0058357960861 "$node_(381) setdest 94913 14141 15.0" 
$ns at 715.1924361630166 "$node_(381) setdest 80913 7551 2.0" 
$ns at 750.9723348038063 "$node_(381) setdest 110339 4795 6.0" 
$ns at 828.3049170495152 "$node_(381) setdest 47307 5755 10.0" 
$ns at 360.4605589481925 "$node_(382) setdest 94930 43123 3.0" 
$ns at 401.79417149209746 "$node_(382) setdest 38890 24711 11.0" 
$ns at 493.1111013004718 "$node_(382) setdest 54296 30198 5.0" 
$ns at 570.1806000806774 "$node_(382) setdest 34777 40517 6.0" 
$ns at 608.1116425502681 "$node_(382) setdest 68748 33880 1.0" 
$ns at 638.6396409671981 "$node_(382) setdest 46806 5496 12.0" 
$ns at 712.5221686900569 "$node_(382) setdest 65111 33234 8.0" 
$ns at 774.124833419866 "$node_(382) setdest 63520 11374 5.0" 
$ns at 832.6646912867108 "$node_(382) setdest 67539 6686 1.0" 
$ns at 867.9370845337771 "$node_(382) setdest 54863 30684 11.0" 
$ns at 369.0965430955395 "$node_(383) setdest 78608 21125 8.0" 
$ns at 452.7673879341236 "$node_(383) setdest 13937 12189 15.0" 
$ns at 510.9314664098895 "$node_(383) setdest 33707 2167 1.0" 
$ns at 548.5358719625864 "$node_(383) setdest 107378 807 9.0" 
$ns at 613.8644297162688 "$node_(383) setdest 111472 5845 4.0" 
$ns at 678.6942192910398 "$node_(383) setdest 41740 22844 13.0" 
$ns at 733.4573988150825 "$node_(383) setdest 126625 3756 3.0" 
$ns at 781.5375799344049 "$node_(383) setdest 21182 39584 13.0" 
$ns at 898.6479001368216 "$node_(383) setdest 109100 41492 2.0" 
$ns at 319.80418906140017 "$node_(384) setdest 104188 19536 8.0" 
$ns at 354.9368128336357 "$node_(384) setdest 64918 14397 10.0" 
$ns at 409.0947004657573 "$node_(384) setdest 121624 14351 17.0" 
$ns at 605.986097709382 "$node_(384) setdest 19968 14218 5.0" 
$ns at 679.917419544344 "$node_(384) setdest 92390 43060 3.0" 
$ns at 728.2026455558492 "$node_(384) setdest 106006 19440 2.0" 
$ns at 764.501306825764 "$node_(384) setdest 43091 37027 14.0" 
$ns at 845.8344362953353 "$node_(384) setdest 51645 1451 7.0" 
$ns at 891.2468194106926 "$node_(384) setdest 98506 10357 4.0" 
$ns at 391.43207970401363 "$node_(385) setdest 47554 40767 7.0" 
$ns at 485.3378867317157 "$node_(385) setdest 133067 3854 12.0" 
$ns at 553.1277554554875 "$node_(385) setdest 29604 6799 3.0" 
$ns at 589.8500574052281 "$node_(385) setdest 120291 21437 3.0" 
$ns at 648.0091464132805 "$node_(385) setdest 95932 23300 18.0" 
$ns at 808.4851213993472 "$node_(385) setdest 8114 14549 19.0" 
$ns at 384.1977429807413 "$node_(386) setdest 103380 5732 14.0" 
$ns at 492.4422147336639 "$node_(386) setdest 28510 37613 1.0" 
$ns at 524.2193959101485 "$node_(386) setdest 8433 35680 9.0" 
$ns at 596.9573504157801 "$node_(386) setdest 90956 26095 8.0" 
$ns at 628.798448216815 "$node_(386) setdest 108849 35064 2.0" 
$ns at 665.9544374231438 "$node_(386) setdest 75210 15034 4.0" 
$ns at 696.5667826902602 "$node_(386) setdest 95456 11139 7.0" 
$ns at 740.4128521597498 "$node_(386) setdest 45680 24328 14.0" 
$ns at 854.3867468998475 "$node_(386) setdest 109448 43894 11.0" 
$ns at 395.15229965421037 "$node_(387) setdest 47801 12254 15.0" 
$ns at 430.8755344323486 "$node_(387) setdest 16130 40025 5.0" 
$ns at 478.1626679863807 "$node_(387) setdest 119446 15973 14.0" 
$ns at 509.5992048361522 "$node_(387) setdest 119521 20509 7.0" 
$ns at 583.0592095607526 "$node_(387) setdest 48479 36964 17.0" 
$ns at 627.1917306859123 "$node_(387) setdest 26927 16316 11.0" 
$ns at 744.8490594241023 "$node_(387) setdest 12204 16133 18.0" 
$ns at 889.820105659291 "$node_(387) setdest 82320 26568 11.0" 
$ns at 354.8506561741561 "$node_(388) setdest 14307 30456 4.0" 
$ns at 409.2889504140078 "$node_(388) setdest 2995 38011 20.0" 
$ns at 638.9857091045197 "$node_(388) setdest 59982 21926 4.0" 
$ns at 707.2391153637727 "$node_(388) setdest 113114 7249 14.0" 
$ns at 831.7488897190899 "$node_(388) setdest 92389 7161 13.0" 
$ns at 333.69530535663176 "$node_(389) setdest 61806 5805 13.0" 
$ns at 400.11363548166867 "$node_(389) setdest 105607 12935 7.0" 
$ns at 472.16080808419815 "$node_(389) setdest 90729 6361 2.0" 
$ns at 516.7084915929415 "$node_(389) setdest 3201 25578 20.0" 
$ns at 660.0325400207885 "$node_(389) setdest 100081 25481 16.0" 
$ns at 753.1941093302879 "$node_(389) setdest 127077 5261 7.0" 
$ns at 811.6898005400601 "$node_(389) setdest 13494 19633 7.0" 
$ns at 883.3447154198095 "$node_(389) setdest 67979 5429 18.0" 
$ns at 305.3765687564271 "$node_(390) setdest 57320 33682 19.0" 
$ns at 496.7215805276131 "$node_(390) setdest 112450 24835 19.0" 
$ns at 601.4621964617482 "$node_(390) setdest 128254 30374 13.0" 
$ns at 694.2988515943192 "$node_(390) setdest 47057 5163 17.0" 
$ns at 786.3164481441597 "$node_(390) setdest 117172 18214 1.0" 
$ns at 825.5105452538556 "$node_(390) setdest 75343 43356 1.0" 
$ns at 865.0201427118642 "$node_(390) setdest 68205 23919 6.0" 
$ns at 896.3550847622048 "$node_(390) setdest 77096 37117 8.0" 
$ns at 312.0673595422799 "$node_(391) setdest 53780 41490 19.0" 
$ns at 499.0401675268972 "$node_(391) setdest 92133 3385 11.0" 
$ns at 576.3164577783099 "$node_(391) setdest 95623 31079 10.0" 
$ns at 607.6038723543704 "$node_(391) setdest 55685 19148 20.0" 
$ns at 722.8615378632641 "$node_(391) setdest 133426 774 17.0" 
$ns at 825.8526856328515 "$node_(391) setdest 85947 35070 8.0" 
$ns at 338.1325578079692 "$node_(392) setdest 106658 11694 18.0" 
$ns at 546.3913920390779 "$node_(392) setdest 65389 14189 6.0" 
$ns at 609.7505512785349 "$node_(392) setdest 20234 24619 2.0" 
$ns at 643.1890366954594 "$node_(392) setdest 81619 26707 15.0" 
$ns at 820.2333662547318 "$node_(392) setdest 293 32609 18.0" 
$ns at 855.5585206900564 "$node_(392) setdest 88005 39851 15.0" 
$ns at 891.0668185031459 "$node_(392) setdest 74272 31520 12.0" 
$ns at 305.4725981392032 "$node_(393) setdest 20674 32047 17.0" 
$ns at 426.924625540837 "$node_(393) setdest 62466 27810 16.0" 
$ns at 519.2211844418223 "$node_(393) setdest 49699 37066 2.0" 
$ns at 550.4433519366082 "$node_(393) setdest 42475 11571 6.0" 
$ns at 626.0660126069986 "$node_(393) setdest 64474 36887 20.0" 
$ns at 823.7029376877482 "$node_(393) setdest 83161 16449 3.0" 
$ns at 869.141638259433 "$node_(393) setdest 25365 40397 15.0" 
$ns at 346.2860193199525 "$node_(394) setdest 74508 3336 4.0" 
$ns at 412.18575599125046 "$node_(394) setdest 16378 284 19.0" 
$ns at 586.6300522638672 "$node_(394) setdest 74143 36664 3.0" 
$ns at 621.5166815643356 "$node_(394) setdest 125946 31545 7.0" 
$ns at 693.9417407561974 "$node_(394) setdest 125515 7779 13.0" 
$ns at 798.2985857525495 "$node_(394) setdest 28699 36593 13.0" 
$ns at 409.94725659165937 "$node_(395) setdest 84239 4590 11.0" 
$ns at 456.5736757165145 "$node_(395) setdest 121293 1200 18.0" 
$ns at 641.4678358218755 "$node_(395) setdest 71309 8780 19.0" 
$ns at 717.8394847580637 "$node_(395) setdest 68502 31069 13.0" 
$ns at 790.777279351192 "$node_(395) setdest 106857 16643 8.0" 
$ns at 870.7699847112134 "$node_(395) setdest 126048 24673 14.0" 
$ns at 346.0980159378936 "$node_(396) setdest 132114 12142 1.0" 
$ns at 380.7629662315717 "$node_(396) setdest 116914 34691 8.0" 
$ns at 420.16665987800775 "$node_(396) setdest 19454 38005 13.0" 
$ns at 488.36911052810694 "$node_(396) setdest 116878 34826 7.0" 
$ns at 568.8923574993694 "$node_(396) setdest 85562 3719 18.0" 
$ns at 679.3648861344969 "$node_(396) setdest 118541 27492 8.0" 
$ns at 742.191238031194 "$node_(396) setdest 23329 41467 7.0" 
$ns at 810.8602049612759 "$node_(396) setdest 20868 10487 18.0" 
$ns at 367.39381566276813 "$node_(397) setdest 44007 17342 19.0" 
$ns at 469.4711559106095 "$node_(397) setdest 16212 16108 5.0" 
$ns at 528.1949692319873 "$node_(397) setdest 125111 4611 11.0" 
$ns at 564.2583912055056 "$node_(397) setdest 38920 9410 8.0" 
$ns at 657.583434936902 "$node_(397) setdest 13786 25572 14.0" 
$ns at 780.4524903358518 "$node_(397) setdest 68214 21783 18.0" 
$ns at 871.8889221243609 "$node_(397) setdest 112322 43811 15.0" 
$ns at 368.57577280247045 "$node_(398) setdest 87300 1289 6.0" 
$ns at 422.6376786737553 "$node_(398) setdest 16698 10435 17.0" 
$ns at 478.1413072010648 "$node_(398) setdest 54516 36782 19.0" 
$ns at 623.7709795173388 "$node_(398) setdest 118735 26894 9.0" 
$ns at 733.3023658263025 "$node_(398) setdest 113550 33067 3.0" 
$ns at 792.6082723792698 "$node_(398) setdest 46877 33767 19.0" 
$ns at 315.8652153357592 "$node_(399) setdest 21291 6042 1.0" 
$ns at 351.28746911604173 "$node_(399) setdest 66229 19351 8.0" 
$ns at 390.71218437539125 "$node_(399) setdest 105707 19782 5.0" 
$ns at 435.3341378439291 "$node_(399) setdest 65772 4573 12.0" 
$ns at 485.5135826566895 "$node_(399) setdest 70325 1492 12.0" 
$ns at 521.8095160967706 "$node_(399) setdest 67300 41413 11.0" 
$ns at 637.6616695468481 "$node_(399) setdest 107819 27199 3.0" 
$ns at 675.1919074720433 "$node_(399) setdest 84502 38688 1.0" 
$ns at 705.4621018597386 "$node_(399) setdest 78391 22033 6.0" 
$ns at 770.8704922534995 "$node_(399) setdest 65355 17169 18.0" 
$ns at 415.9173386431947 "$node_(400) setdest 112248 42602 13.0" 
$ns at 460.87741898088615 "$node_(400) setdest 111544 30355 6.0" 
$ns at 518.331665806981 "$node_(400) setdest 93742 44328 2.0" 
$ns at 564.2462085414057 "$node_(400) setdest 99989 15828 18.0" 
$ns at 626.2816198568471 "$node_(400) setdest 63115 8616 19.0" 
$ns at 828.0364950645201 "$node_(400) setdest 12451 12240 13.0" 
$ns at 424.89272436614283 "$node_(401) setdest 31287 36202 16.0" 
$ns at 524.2041040334831 "$node_(401) setdest 86346 21665 10.0" 
$ns at 588.5487062788401 "$node_(401) setdest 104372 25037 6.0" 
$ns at 662.0311069353817 "$node_(401) setdest 88007 4057 11.0" 
$ns at 760.2379963578048 "$node_(401) setdest 85657 41795 1.0" 
$ns at 799.4014701033025 "$node_(401) setdest 15118 12369 7.0" 
$ns at 893.7295038412971 "$node_(401) setdest 113768 4420 6.0" 
$ns at 444.1094063291852 "$node_(402) setdest 69305 33128 3.0" 
$ns at 493.5679590105343 "$node_(402) setdest 125666 1947 8.0" 
$ns at 539.1782374401853 "$node_(402) setdest 99281 42630 15.0" 
$ns at 606.0563259142997 "$node_(402) setdest 120886 19786 1.0" 
$ns at 645.220763243658 "$node_(402) setdest 127713 28343 7.0" 
$ns at 742.3648956877271 "$node_(402) setdest 31321 31583 10.0" 
$ns at 840.8855956263072 "$node_(402) setdest 104807 6040 18.0" 
$ns at 401.64278698266855 "$node_(403) setdest 9552 24320 16.0" 
$ns at 498.77491043842707 "$node_(403) setdest 57444 26471 7.0" 
$ns at 538.0494801193644 "$node_(403) setdest 59914 37804 16.0" 
$ns at 626.3938815221306 "$node_(403) setdest 22398 41710 2.0" 
$ns at 667.918250013369 "$node_(403) setdest 82173 28282 1.0" 
$ns at 703.9803989973825 "$node_(403) setdest 111704 28978 7.0" 
$ns at 756.4473250439636 "$node_(403) setdest 55964 7374 15.0" 
$ns at 795.7954643829306 "$node_(403) setdest 78392 38616 6.0" 
$ns at 870.1670041794566 "$node_(403) setdest 25719 22477 9.0" 
$ns at 418.94497874276374 "$node_(404) setdest 126181 14854 7.0" 
$ns at 497.98798576989844 "$node_(404) setdest 94895 37092 17.0" 
$ns at 634.3354498832085 "$node_(404) setdest 103155 11104 1.0" 
$ns at 671.4672809675836 "$node_(404) setdest 114435 19943 9.0" 
$ns at 738.2803389394159 "$node_(404) setdest 4942 37433 6.0" 
$ns at 798.2066725752356 "$node_(404) setdest 44694 20117 1.0" 
$ns at 837.8682605869744 "$node_(404) setdest 114416 16084 1.0" 
$ns at 873.8038998940706 "$node_(404) setdest 75300 24479 4.0" 
$ns at 421.54830581509077 "$node_(405) setdest 131530 20297 17.0" 
$ns at 571.5644413201003 "$node_(405) setdest 11693 9772 18.0" 
$ns at 768.0035381445142 "$node_(405) setdest 35123 157 10.0" 
$ns at 833.8429174136568 "$node_(405) setdest 30612 3532 1.0" 
$ns at 870.436288217865 "$node_(405) setdest 82949 1222 18.0" 
$ns at 439.7855229509355 "$node_(406) setdest 25780 18954 19.0" 
$ns at 586.6674543476433 "$node_(406) setdest 21867 32918 8.0" 
$ns at 630.5734748398119 "$node_(406) setdest 106212 1600 18.0" 
$ns at 733.3976610769898 "$node_(406) setdest 98560 914 12.0" 
$ns at 766.4321890007727 "$node_(406) setdest 116571 28392 17.0" 
$ns at 406.1113306121616 "$node_(407) setdest 57481 8569 13.0" 
$ns at 525.9223662007936 "$node_(407) setdest 8094 14449 19.0" 
$ns at 719.7395090089749 "$node_(407) setdest 84191 9101 7.0" 
$ns at 770.7059290802534 "$node_(407) setdest 119978 16901 6.0" 
$ns at 853.6562641651822 "$node_(407) setdest 70504 34089 13.0" 
$ns at 441.628739934362 "$node_(408) setdest 97691 32718 9.0" 
$ns at 481.9908828464447 "$node_(408) setdest 24710 35473 8.0" 
$ns at 577.0501556188217 "$node_(408) setdest 72650 5868 17.0" 
$ns at 684.1781875663769 "$node_(408) setdest 121907 18975 9.0" 
$ns at 802.1196406538974 "$node_(408) setdest 17474 23914 8.0" 
$ns at 836.5530600184078 "$node_(408) setdest 118283 22019 17.0" 
$ns at 411.6326936913205 "$node_(409) setdest 104421 34579 10.0" 
$ns at 460.9175399860744 "$node_(409) setdest 77216 32973 19.0" 
$ns at 537.758647608874 "$node_(409) setdest 115060 7515 1.0" 
$ns at 571.5761663115555 "$node_(409) setdest 95898 29656 19.0" 
$ns at 603.4195885448606 "$node_(409) setdest 127831 8667 7.0" 
$ns at 653.3538651501367 "$node_(409) setdest 100210 1843 14.0" 
$ns at 805.6518067670452 "$node_(409) setdest 60762 42983 8.0" 
$ns at 863.3307794887038 "$node_(409) setdest 66008 34365 1.0" 
$ns at 896.6425659284923 "$node_(409) setdest 4947 1615 8.0" 
$ns at 459.4896344133004 "$node_(410) setdest 106159 6676 1.0" 
$ns at 493.14030130166867 "$node_(410) setdest 79561 12765 8.0" 
$ns at 565.7509646025007 "$node_(410) setdest 92235 30749 7.0" 
$ns at 605.0830562125909 "$node_(410) setdest 85357 6795 4.0" 
$ns at 647.7210985107866 "$node_(410) setdest 71357 22513 8.0" 
$ns at 701.977153493719 "$node_(410) setdest 128119 8808 16.0" 
$ns at 743.6530770524028 "$node_(410) setdest 55032 12824 17.0" 
$ns at 842.1199716071043 "$node_(410) setdest 115777 34975 5.0" 
$ns at 896.9884594925122 "$node_(410) setdest 40971 18487 7.0" 
$ns at 402.0778643564013 "$node_(411) setdest 104546 2944 13.0" 
$ns at 450.66444092966896 "$node_(411) setdest 127878 5478 6.0" 
$ns at 525.6358835365824 "$node_(411) setdest 93481 1925 3.0" 
$ns at 565.1981339559771 "$node_(411) setdest 5881 36325 13.0" 
$ns at 675.4066677849879 "$node_(411) setdest 10125 18899 13.0" 
$ns at 770.8311979134903 "$node_(411) setdest 84107 12595 15.0" 
$ns at 896.5062183341131 "$node_(411) setdest 27315 25571 2.0" 
$ns at 437.55311697289534 "$node_(412) setdest 54233 26394 7.0" 
$ns at 529.635492512816 "$node_(412) setdest 86925 34515 1.0" 
$ns at 569.6080068475071 "$node_(412) setdest 17182 29333 20.0" 
$ns at 742.6024378160364 "$node_(412) setdest 126308 20846 14.0" 
$ns at 835.4919963563981 "$node_(412) setdest 33940 5373 15.0" 
$ns at 413.24627499659596 "$node_(413) setdest 67749 12702 2.0" 
$ns at 461.0825397653878 "$node_(413) setdest 95645 23226 16.0" 
$ns at 550.0638373773814 "$node_(413) setdest 41677 4098 8.0" 
$ns at 585.2861392390755 "$node_(413) setdest 97206 23654 11.0" 
$ns at 617.3678598371882 "$node_(413) setdest 60883 43354 12.0" 
$ns at 747.4852376667114 "$node_(413) setdest 125314 4185 13.0" 
$ns at 887.0174556958374 "$node_(413) setdest 27298 31362 11.0" 
$ns at 436.0165459848776 "$node_(414) setdest 40288 27872 9.0" 
$ns at 551.6181671929756 "$node_(414) setdest 72508 2046 15.0" 
$ns at 591.1005481285525 "$node_(414) setdest 113444 29736 7.0" 
$ns at 659.4606854011257 "$node_(414) setdest 53078 9592 17.0" 
$ns at 855.1605074893557 "$node_(414) setdest 125550 7425 20.0" 
$ns at 429.58669190166484 "$node_(415) setdest 97987 8774 12.0" 
$ns at 559.1914821043972 "$node_(415) setdest 81103 27574 18.0" 
$ns at 687.5329229199208 "$node_(415) setdest 124205 33145 10.0" 
$ns at 787.106554454078 "$node_(415) setdest 105544 10544 10.0" 
$ns at 843.5247825437647 "$node_(415) setdest 62042 22411 3.0" 
$ns at 899.1352890563829 "$node_(415) setdest 132994 8432 7.0" 
$ns at 430.6574140583246 "$node_(416) setdest 122765 386 9.0" 
$ns at 507.2353059072707 "$node_(416) setdest 13987 43826 7.0" 
$ns at 565.59372350007 "$node_(416) setdest 19270 693 12.0" 
$ns at 678.9236110319187 "$node_(416) setdest 17953 31534 11.0" 
$ns at 809.9888708942285 "$node_(416) setdest 35981 38782 15.0" 
$ns at 482.91606712749194 "$node_(417) setdest 51562 30077 7.0" 
$ns at 546.2777914366752 "$node_(417) setdest 47845 8032 1.0" 
$ns at 583.8014201755615 "$node_(417) setdest 62378 13516 5.0" 
$ns at 617.831450412753 "$node_(417) setdest 119480 3683 11.0" 
$ns at 736.5560712546861 "$node_(417) setdest 44593 30521 8.0" 
$ns at 820.8362929532416 "$node_(417) setdest 54548 6696 3.0" 
$ns at 860.0145422331028 "$node_(417) setdest 3411 6837 19.0" 
$ns at 898.7866104931611 "$node_(417) setdest 94060 15956 5.0" 
$ns at 497.7901171977811 "$node_(418) setdest 3375 11269 7.0" 
$ns at 566.7019137723524 "$node_(418) setdest 77268 8812 13.0" 
$ns at 707.4566216021664 "$node_(418) setdest 78166 31644 8.0" 
$ns at 812.8460080906118 "$node_(418) setdest 67064 44666 3.0" 
$ns at 847.2647820382809 "$node_(418) setdest 117451 1447 2.0" 
$ns at 890.604973615178 "$node_(418) setdest 59481 33173 19.0" 
$ns at 508.2480410733324 "$node_(419) setdest 116128 20638 17.0" 
$ns at 703.9533382694499 "$node_(419) setdest 4944 5060 8.0" 
$ns at 776.727916974628 "$node_(419) setdest 132767 1276 7.0" 
$ns at 858.5801839548535 "$node_(419) setdest 84968 33595 14.0" 
$ns at 482.3590683526949 "$node_(420) setdest 111687 443 8.0" 
$ns at 588.722907515771 "$node_(420) setdest 72058 33442 11.0" 
$ns at 654.6612508360845 "$node_(420) setdest 88542 7748 8.0" 
$ns at 734.0648940560877 "$node_(420) setdest 127248 38431 1.0" 
$ns at 772.326721398168 "$node_(420) setdest 32566 30618 6.0" 
$ns at 824.9702401535084 "$node_(420) setdest 67949 37963 10.0" 
$ns at 891.0338042818161 "$node_(420) setdest 48479 11748 1.0" 
$ns at 528.1882880673508 "$node_(421) setdest 123425 44552 9.0" 
$ns at 628.8559477035083 "$node_(421) setdest 59620 38889 10.0" 
$ns at 735.5946957889314 "$node_(421) setdest 62859 35166 11.0" 
$ns at 859.1158967489469 "$node_(421) setdest 122662 36102 16.0" 
$ns at 445.819113530441 "$node_(422) setdest 66455 41348 17.0" 
$ns at 598.4101329912676 "$node_(422) setdest 85746 28617 1.0" 
$ns at 634.4779862245133 "$node_(422) setdest 93256 3887 4.0" 
$ns at 689.6464166940292 "$node_(422) setdest 60746 29455 6.0" 
$ns at 762.0889885672136 "$node_(422) setdest 45974 40275 19.0" 
$ns at 417.7936663875956 "$node_(423) setdest 89594 7620 15.0" 
$ns at 547.4991319063132 "$node_(423) setdest 14014 4813 16.0" 
$ns at 636.8649326743264 "$node_(423) setdest 20413 5577 15.0" 
$ns at 766.4674145556685 "$node_(423) setdest 99686 43938 15.0" 
$ns at 442.45671099109677 "$node_(424) setdest 54746 6455 15.0" 
$ns at 567.0418884016871 "$node_(424) setdest 117757 20385 6.0" 
$ns at 602.6874165688852 "$node_(424) setdest 80638 34000 1.0" 
$ns at 635.405880831569 "$node_(424) setdest 37439 11588 9.0" 
$ns at 737.9489560179128 "$node_(424) setdest 44107 4650 6.0" 
$ns at 800.8784202535692 "$node_(424) setdest 80272 5769 12.0" 
$ns at 890.108555670788 "$node_(424) setdest 72457 39424 1.0" 
$ns at 493.71157555578515 "$node_(425) setdest 53280 37699 18.0" 
$ns at 633.5496749240253 "$node_(425) setdest 98104 34792 15.0" 
$ns at 753.1025801594852 "$node_(425) setdest 32647 31941 8.0" 
$ns at 796.0291587276884 "$node_(425) setdest 80791 19658 7.0" 
$ns at 830.9968197782621 "$node_(425) setdest 87236 38295 15.0" 
$ns at 442.8808554450742 "$node_(426) setdest 47661 16982 2.0" 
$ns at 491.6788102431396 "$node_(426) setdest 48577 38080 17.0" 
$ns at 620.4872958442279 "$node_(426) setdest 12073 41173 19.0" 
$ns at 793.935706922203 "$node_(426) setdest 46698 4758 16.0" 
$ns at 428.2079343602484 "$node_(427) setdest 59731 7289 15.0" 
$ns at 572.7261626920913 "$node_(427) setdest 44968 12979 2.0" 
$ns at 617.6905824966348 "$node_(427) setdest 80184 17051 19.0" 
$ns at 790.0381197174551 "$node_(427) setdest 114895 5582 6.0" 
$ns at 822.1121787690541 "$node_(427) setdest 94105 14177 9.0" 
$ns at 414.2404940497578 "$node_(428) setdest 32616 43707 19.0" 
$ns at 562.4513547235501 "$node_(428) setdest 108526 39888 5.0" 
$ns at 608.0717614799747 "$node_(428) setdest 117513 5151 19.0" 
$ns at 776.611887106691 "$node_(428) setdest 105081 28213 13.0" 
$ns at 868.3212108942364 "$node_(428) setdest 18501 9259 14.0" 
$ns at 432.52791647393025 "$node_(429) setdest 108518 44125 12.0" 
$ns at 478.61430171197776 "$node_(429) setdest 48188 17583 2.0" 
$ns at 523.0809390318963 "$node_(429) setdest 21887 23813 4.0" 
$ns at 588.2018895030772 "$node_(429) setdest 30057 1835 1.0" 
$ns at 619.9349570536012 "$node_(429) setdest 130968 19315 15.0" 
$ns at 762.1857082422302 "$node_(429) setdest 31231 4731 8.0" 
$ns at 809.5948232367036 "$node_(429) setdest 52752 31047 18.0" 
$ns at 422.40142876638953 "$node_(430) setdest 103466 31639 7.0" 
$ns at 463.63136346650464 "$node_(430) setdest 70902 3863 8.0" 
$ns at 553.7038471777279 "$node_(430) setdest 129570 525 11.0" 
$ns at 643.4599028486547 "$node_(430) setdest 89378 797 10.0" 
$ns at 731.8839935925367 "$node_(430) setdest 46149 22184 19.0" 
$ns at 801.3835673752302 "$node_(430) setdest 80619 23109 20.0" 
$ns at 471.7776769387176 "$node_(431) setdest 114506 16838 14.0" 
$ns at 608.5112240006832 "$node_(431) setdest 8731 44607 1.0" 
$ns at 645.1722286168362 "$node_(431) setdest 90428 36207 3.0" 
$ns at 684.5386849603404 "$node_(431) setdest 95423 21998 20.0" 
$ns at 849.608017788227 "$node_(431) setdest 110997 29688 3.0" 
$ns at 879.693448877195 "$node_(431) setdest 50897 25724 2.0" 
$ns at 413.4723693424545 "$node_(432) setdest 80070 11053 9.0" 
$ns at 478.1868513761711 "$node_(432) setdest 5322 12697 18.0" 
$ns at 593.0524485484873 "$node_(432) setdest 58202 21771 5.0" 
$ns at 669.3014726306152 "$node_(432) setdest 25539 10291 11.0" 
$ns at 789.1876677951341 "$node_(432) setdest 34169 34788 1.0" 
$ns at 826.1031539932291 "$node_(432) setdest 119214 27418 3.0" 
$ns at 876.2938206753015 "$node_(432) setdest 73416 21900 10.0" 
$ns at 409.126606025715 "$node_(433) setdest 17016 22422 4.0" 
$ns at 476.83824557445195 "$node_(433) setdest 51371 41403 1.0" 
$ns at 508.56463816781417 "$node_(433) setdest 37536 34413 3.0" 
$ns at 559.2690152118254 "$node_(433) setdest 66839 44324 19.0" 
$ns at 772.9098010676184 "$node_(433) setdest 53171 14040 2.0" 
$ns at 807.9346493874983 "$node_(433) setdest 109097 8863 4.0" 
$ns at 841.3155117753199 "$node_(433) setdest 64295 6154 14.0" 
$ns at 426.5791462071 "$node_(434) setdest 72961 44002 3.0" 
$ns at 476.7355451391698 "$node_(434) setdest 36769 43841 6.0" 
$ns at 560.1457347589352 "$node_(434) setdest 54362 37665 2.0" 
$ns at 604.2858928264063 "$node_(434) setdest 81378 41940 10.0" 
$ns at 722.0593061245087 "$node_(434) setdest 2243 30467 17.0" 
$ns at 880.4248574477178 "$node_(434) setdest 5227 20724 9.0" 
$ns at 524.0258149701458 "$node_(435) setdest 93398 1369 13.0" 
$ns at 554.1446158004835 "$node_(435) setdest 60502 2779 3.0" 
$ns at 584.9664314112861 "$node_(435) setdest 53884 35956 10.0" 
$ns at 694.9062068873104 "$node_(435) setdest 32133 39669 1.0" 
$ns at 731.3819983369135 "$node_(435) setdest 56016 15185 5.0" 
$ns at 800.2401653365557 "$node_(435) setdest 16158 18376 3.0" 
$ns at 835.0077084341082 "$node_(435) setdest 18663 10754 16.0" 
$ns at 542.2936336653735 "$node_(436) setdest 39405 21368 1.0" 
$ns at 573.0613598514002 "$node_(436) setdest 127099 18254 10.0" 
$ns at 612.5849485450549 "$node_(436) setdest 60440 25445 10.0" 
$ns at 675.879343268298 "$node_(436) setdest 4784 1164 16.0" 
$ns at 829.9526839053915 "$node_(436) setdest 36325 31778 12.0" 
$ns at 492.2778101870475 "$node_(437) setdest 91732 43243 13.0" 
$ns at 619.4544684309076 "$node_(437) setdest 115815 2039 1.0" 
$ns at 656.7521770480128 "$node_(437) setdest 73975 16703 7.0" 
$ns at 755.046237075225 "$node_(437) setdest 3990 37806 11.0" 
$ns at 894.7155106010091 "$node_(437) setdest 65652 16305 3.0" 
$ns at 405.94555583774655 "$node_(438) setdest 85490 30772 3.0" 
$ns at 457.18518778629294 "$node_(438) setdest 14465 20487 10.0" 
$ns at 536.7127925516693 "$node_(438) setdest 67814 36563 8.0" 
$ns at 637.7023609867481 "$node_(438) setdest 68780 42755 11.0" 
$ns at 727.4256980108831 "$node_(438) setdest 6896 35749 1.0" 
$ns at 757.8281432551889 "$node_(438) setdest 124981 39911 7.0" 
$ns at 792.2116267472309 "$node_(438) setdest 82745 23004 16.0" 
$ns at 829.3197762146895 "$node_(438) setdest 13439 27382 10.0" 
$ns at 433.76715921928053 "$node_(439) setdest 86313 42308 18.0" 
$ns at 544.6133827601179 "$node_(439) setdest 16167 13077 15.0" 
$ns at 602.2689956120032 "$node_(439) setdest 108723 963 8.0" 
$ns at 638.109061935931 "$node_(439) setdest 21128 745 1.0" 
$ns at 676.4199968386712 "$node_(439) setdest 57608 8148 14.0" 
$ns at 800.1473225486461 "$node_(439) setdest 104426 33291 18.0" 
$ns at 430.61786305820794 "$node_(440) setdest 129368 43737 1.0" 
$ns at 462.49194024559296 "$node_(440) setdest 114802 8771 16.0" 
$ns at 587.801628506607 "$node_(440) setdest 53251 22916 3.0" 
$ns at 634.8532546992249 "$node_(440) setdest 53163 10050 19.0" 
$ns at 748.264052048048 "$node_(440) setdest 24350 38583 1.0" 
$ns at 786.9697865111057 "$node_(440) setdest 118733 2396 8.0" 
$ns at 877.7366751657041 "$node_(440) setdest 105828 10376 6.0" 
$ns at 446.08898609264924 "$node_(441) setdest 82787 17213 1.0" 
$ns at 479.9949740008658 "$node_(441) setdest 73878 43274 6.0" 
$ns at 557.7531505771675 "$node_(441) setdest 5004 30469 12.0" 
$ns at 597.3047594021552 "$node_(441) setdest 120609 19526 2.0" 
$ns at 637.4064745455264 "$node_(441) setdest 75930 12616 10.0" 
$ns at 751.5830690956233 "$node_(441) setdest 46299 9865 4.0" 
$ns at 784.4818509781779 "$node_(441) setdest 11965 2313 2.0" 
$ns at 827.2631720763433 "$node_(441) setdest 131944 13774 17.0" 
$ns at 440.1561013754798 "$node_(442) setdest 92009 24524 19.0" 
$ns at 625.6580898085336 "$node_(442) setdest 85151 34384 12.0" 
$ns at 716.9690731363166 "$node_(442) setdest 114854 34588 1.0" 
$ns at 751.256646927225 "$node_(442) setdest 17194 30605 10.0" 
$ns at 861.3917105601332 "$node_(442) setdest 67819 13794 2.0" 
$ns at 894.1709384736107 "$node_(442) setdest 37398 36583 9.0" 
$ns at 401.76042867136374 "$node_(443) setdest 13057 39330 5.0" 
$ns at 453.49048934327885 "$node_(443) setdest 81512 11459 6.0" 
$ns at 508.7022901635987 "$node_(443) setdest 44058 8817 9.0" 
$ns at 624.6375121040114 "$node_(443) setdest 86578 31515 2.0" 
$ns at 657.0478008086984 "$node_(443) setdest 94148 5614 6.0" 
$ns at 712.4879245205246 "$node_(443) setdest 38347 22021 12.0" 
$ns at 829.057166061164 "$node_(443) setdest 32628 16392 13.0" 
$ns at 898.9965095302173 "$node_(443) setdest 24989 44284 17.0" 
$ns at 435.0812778062803 "$node_(444) setdest 50739 4588 16.0" 
$ns at 575.6794345809689 "$node_(444) setdest 118841 33654 12.0" 
$ns at 610.4132372628769 "$node_(444) setdest 109581 25337 8.0" 
$ns at 642.630579902112 "$node_(444) setdest 99146 571 18.0" 
$ns at 733.632308791579 "$node_(444) setdest 41521 35676 15.0" 
$ns at 812.0702088737978 "$node_(444) setdest 32225 28195 15.0" 
$ns at 877.7375830739599 "$node_(444) setdest 2315 42905 14.0" 
$ns at 550.0693172618173 "$node_(445) setdest 127335 9764 16.0" 
$ns at 659.4173561297864 "$node_(445) setdest 4322 40671 13.0" 
$ns at 713.2608114435309 "$node_(445) setdest 6423 2384 14.0" 
$ns at 840.4190927275819 "$node_(445) setdest 29598 43854 18.0" 
$ns at 427.0876302436076 "$node_(446) setdest 4343 14686 3.0" 
$ns at 477.0257563143929 "$node_(446) setdest 44145 10082 16.0" 
$ns at 654.586825931917 "$node_(446) setdest 25314 39894 16.0" 
$ns at 808.2579185271904 "$node_(446) setdest 84729 39774 5.0" 
$ns at 884.7179810889171 "$node_(446) setdest 32224 33032 9.0" 
$ns at 544.1780103924407 "$node_(447) setdest 52499 27611 13.0" 
$ns at 703.6935292008379 "$node_(447) setdest 112216 15741 14.0" 
$ns at 802.0539954557973 "$node_(447) setdest 19346 17024 19.0" 
$ns at 864.5708229133678 "$node_(447) setdest 47075 1280 4.0" 
$ns at 411.0854696270232 "$node_(448) setdest 1301 17757 17.0" 
$ns at 457.9781376104132 "$node_(448) setdest 125924 3708 13.0" 
$ns at 510.4776451955886 "$node_(448) setdest 59230 4845 4.0" 
$ns at 547.4497020555627 "$node_(448) setdest 107945 24967 10.0" 
$ns at 673.1105365996809 "$node_(448) setdest 93960 31712 18.0" 
$ns at 797.7354948993648 "$node_(448) setdest 35778 5209 10.0" 
$ns at 875.7809540390922 "$node_(448) setdest 126468 25293 18.0" 
$ns at 402.02534704622076 "$node_(449) setdest 103300 34551 6.0" 
$ns at 484.2743821566877 "$node_(449) setdest 8369 215 5.0" 
$ns at 531.5774883012299 "$node_(449) setdest 47887 28416 16.0" 
$ns at 617.9834681880325 "$node_(449) setdest 99752 41901 7.0" 
$ns at 655.240742164614 "$node_(449) setdest 101029 19190 19.0" 
$ns at 705.2024033117746 "$node_(449) setdest 84164 7528 15.0" 
$ns at 740.8969906876774 "$node_(449) setdest 48868 37378 18.0" 
$ns at 872.1389829359789 "$node_(449) setdest 63406 29538 13.0" 
$ns at 438.0894766859291 "$node_(450) setdest 117061 40980 1.0" 
$ns at 475.20221370033886 "$node_(450) setdest 119527 31581 15.0" 
$ns at 637.6689481372996 "$node_(450) setdest 3640 15687 7.0" 
$ns at 709.6030848343883 "$node_(450) setdest 101387 30377 2.0" 
$ns at 748.4273889467646 "$node_(450) setdest 61113 3571 17.0" 
$ns at 496.3189361887612 "$node_(451) setdest 54204 12247 7.0" 
$ns at 587.7489344484713 "$node_(451) setdest 12686 34842 10.0" 
$ns at 646.733770426856 "$node_(451) setdest 118624 13960 6.0" 
$ns at 725.3157669575997 "$node_(451) setdest 5522 33701 16.0" 
$ns at 815.9237859910941 "$node_(451) setdest 84522 17256 3.0" 
$ns at 871.6766466161445 "$node_(451) setdest 28547 7825 19.0" 
$ns at 439.72774646744523 "$node_(452) setdest 132710 4995 6.0" 
$ns at 504.9302746824229 "$node_(452) setdest 36428 3774 2.0" 
$ns at 553.9309075335752 "$node_(452) setdest 16739 40861 1.0" 
$ns at 586.3741995543023 "$node_(452) setdest 49373 22821 14.0" 
$ns at 660.6304532792046 "$node_(452) setdest 42611 37157 5.0" 
$ns at 697.2337337288388 "$node_(452) setdest 68531 12331 17.0" 
$ns at 863.752598284978 "$node_(452) setdest 29048 41541 4.0" 
$ns at 566.7922352701387 "$node_(453) setdest 5709 24016 3.0" 
$ns at 615.9348376679294 "$node_(453) setdest 113251 22881 12.0" 
$ns at 709.4738930511346 "$node_(453) setdest 57134 3536 19.0" 
$ns at 809.3529307622574 "$node_(453) setdest 52338 37260 18.0" 
$ns at 859.5272412117725 "$node_(453) setdest 31582 26833 18.0" 
$ns at 501.7867448634406 "$node_(454) setdest 31663 24422 16.0" 
$ns at 547.0229147294331 "$node_(454) setdest 14978 25293 6.0" 
$ns at 581.5703913039285 "$node_(454) setdest 111867 25512 7.0" 
$ns at 648.484159365276 "$node_(454) setdest 81201 23299 10.0" 
$ns at 748.6833443790126 "$node_(454) setdest 118660 14786 17.0" 
$ns at 412.34917157433154 "$node_(455) setdest 22263 19170 2.0" 
$ns at 450.2460964135927 "$node_(455) setdest 64352 6175 16.0" 
$ns at 484.21682637512885 "$node_(455) setdest 65648 34707 2.0" 
$ns at 528.0189214738954 "$node_(455) setdest 86126 44392 19.0" 
$ns at 660.8722293873961 "$node_(455) setdest 85943 18913 19.0" 
$ns at 694.7112997399437 "$node_(455) setdest 47016 31816 18.0" 
$ns at 749.6515494523377 "$node_(455) setdest 122152 30050 13.0" 
$ns at 825.6039310046048 "$node_(455) setdest 51302 38133 8.0" 
$ns at 877.6630050481157 "$node_(455) setdest 14777 25187 9.0" 
$ns at 545.7299142009717 "$node_(456) setdest 68752 37284 12.0" 
$ns at 665.8848602154511 "$node_(456) setdest 57317 26667 12.0" 
$ns at 792.354512180878 "$node_(456) setdest 2152 19893 16.0" 
$ns at 552.1298550423168 "$node_(457) setdest 77265 20342 1.0" 
$ns at 586.415827623931 "$node_(457) setdest 45479 34086 6.0" 
$ns at 670.6875934993618 "$node_(457) setdest 67661 11999 7.0" 
$ns at 727.2957437689486 "$node_(457) setdest 70408 9839 17.0" 
$ns at 831.3249639150296 "$node_(457) setdest 43284 5935 8.0" 
$ns at 866.5775359865222 "$node_(457) setdest 104491 599 4.0" 
$ns at 521.32154923028 "$node_(458) setdest 91731 20716 1.0" 
$ns at 560.5595218070093 "$node_(458) setdest 5880 13932 5.0" 
$ns at 616.466795994352 "$node_(458) setdest 91395 19752 5.0" 
$ns at 682.0919074292289 "$node_(458) setdest 78145 14764 16.0" 
$ns at 740.5896809776726 "$node_(458) setdest 19890 33558 7.0" 
$ns at 810.2343370279482 "$node_(458) setdest 20642 13593 2.0" 
$ns at 842.2269912385009 "$node_(458) setdest 121993 12765 8.0" 
$ns at 417.21926173109654 "$node_(459) setdest 84536 4434 8.0" 
$ns at 481.3765649495643 "$node_(459) setdest 60128 42234 8.0" 
$ns at 562.9708393489035 "$node_(459) setdest 84765 5008 17.0" 
$ns at 724.3676789306102 "$node_(459) setdest 82480 31710 15.0" 
$ns at 860.2648923430559 "$node_(459) setdest 48012 7868 2.0" 
$ns at 423.9470756375096 "$node_(460) setdest 18961 1770 1.0" 
$ns at 458.1237509625043 "$node_(460) setdest 117348 10942 9.0" 
$ns at 515.47867745488 "$node_(460) setdest 112199 250 5.0" 
$ns at 564.481677203728 "$node_(460) setdest 91910 1337 11.0" 
$ns at 637.5301006247768 "$node_(460) setdest 13313 42744 1.0" 
$ns at 670.1481668272754 "$node_(460) setdest 35589 43213 3.0" 
$ns at 728.2768335681649 "$node_(460) setdest 44361 20920 20.0" 
$ns at 873.9580915044277 "$node_(460) setdest 60994 12861 19.0" 
$ns at 429.5200983073867 "$node_(461) setdest 49599 10738 14.0" 
$ns at 522.1010524550661 "$node_(461) setdest 125627 30904 13.0" 
$ns at 650.3789314749945 "$node_(461) setdest 129627 42839 15.0" 
$ns at 783.0728017878132 "$node_(461) setdest 93501 8263 18.0" 
$ns at 877.7832643372736 "$node_(461) setdest 112414 21525 18.0" 
$ns at 449.38043824081603 "$node_(462) setdest 80213 4821 13.0" 
$ns at 572.1858725399692 "$node_(462) setdest 108996 31679 8.0" 
$ns at 680.8065956543276 "$node_(462) setdest 3136 36651 17.0" 
$ns at 799.0097119010907 "$node_(462) setdest 126449 24741 14.0" 
$ns at 892.3853213596559 "$node_(462) setdest 14816 44575 13.0" 
$ns at 506.0115614211944 "$node_(463) setdest 75798 37927 15.0" 
$ns at 666.2222928779421 "$node_(463) setdest 129709 36605 12.0" 
$ns at 731.954376092339 "$node_(463) setdest 50394 7177 9.0" 
$ns at 788.5943642033774 "$node_(463) setdest 86214 42499 8.0" 
$ns at 891.9369989348208 "$node_(463) setdest 27157 16777 2.0" 
$ns at 506.4576447527845 "$node_(464) setdest 106301 14011 9.0" 
$ns at 599.5388774570912 "$node_(464) setdest 117740 6272 8.0" 
$ns at 663.6773966365902 "$node_(464) setdest 19881 42355 5.0" 
$ns at 714.3546817439706 "$node_(464) setdest 25752 9659 1.0" 
$ns at 744.8222425211865 "$node_(464) setdest 105245 15730 8.0" 
$ns at 828.0709524382542 "$node_(464) setdest 39677 15525 1.0" 
$ns at 861.2485140958659 "$node_(464) setdest 7764 16991 20.0" 
$ns at 502.9627207580666 "$node_(465) setdest 40469 6266 5.0" 
$ns at 577.6587842329875 "$node_(465) setdest 108334 25636 2.0" 
$ns at 610.8905105847032 "$node_(465) setdest 58316 29768 5.0" 
$ns at 646.283174752075 "$node_(465) setdest 4027 25107 11.0" 
$ns at 757.711598284707 "$node_(465) setdest 74844 9488 2.0" 
$ns at 791.0466451366186 "$node_(465) setdest 120431 43625 15.0" 
$ns at 893.4405975884243 "$node_(465) setdest 126040 4570 1.0" 
$ns at 431.7599827101993 "$node_(466) setdest 89721 18363 16.0" 
$ns at 533.9589727178774 "$node_(466) setdest 54216 27459 6.0" 
$ns at 622.8236544376205 "$node_(466) setdest 54671 27008 16.0" 
$ns at 725.2588343477355 "$node_(466) setdest 13369 38977 3.0" 
$ns at 765.9777115947375 "$node_(466) setdest 866 9936 20.0" 
$ns at 464.30590668758214 "$node_(467) setdest 38318 39296 15.0" 
$ns at 551.5330302250516 "$node_(467) setdest 35014 36199 10.0" 
$ns at 633.7022507716223 "$node_(467) setdest 132301 13466 9.0" 
$ns at 718.6123059860163 "$node_(467) setdest 84373 26919 17.0" 
$ns at 898.5140321203447 "$node_(467) setdest 92080 28895 5.0" 
$ns at 456.39313912477013 "$node_(468) setdest 42837 23664 12.0" 
$ns at 528.9168611919105 "$node_(468) setdest 17910 33947 7.0" 
$ns at 584.2556150932955 "$node_(468) setdest 132910 20079 5.0" 
$ns at 656.5098258356038 "$node_(468) setdest 95037 11417 8.0" 
$ns at 765.9888874516603 "$node_(468) setdest 130009 11075 9.0" 
$ns at 830.5282114785359 "$node_(468) setdest 63834 17675 1.0" 
$ns at 864.7336318236332 "$node_(468) setdest 53080 14040 15.0" 
$ns at 467.5231048602035 "$node_(469) setdest 109368 42341 19.0" 
$ns at 511.40796403187323 "$node_(469) setdest 127884 21997 6.0" 
$ns at 594.5033948711181 "$node_(469) setdest 71563 7572 14.0" 
$ns at 628.7673559791529 "$node_(469) setdest 8702 10519 16.0" 
$ns at 750.8836274358417 "$node_(469) setdest 73685 24289 12.0" 
$ns at 867.2965649282738 "$node_(469) setdest 39917 14383 4.0" 
$ns at 498.6588834293544 "$node_(470) setdest 114501 40707 1.0" 
$ns at 538.5193837835691 "$node_(470) setdest 105733 27200 14.0" 
$ns at 604.7473769090346 "$node_(470) setdest 67405 7967 15.0" 
$ns at 649.6813257845449 "$node_(470) setdest 89840 25101 4.0" 
$ns at 681.5214655336791 "$node_(470) setdest 106648 40381 3.0" 
$ns at 735.0114712887626 "$node_(470) setdest 28058 42436 7.0" 
$ns at 794.6955082197743 "$node_(470) setdest 23604 9226 4.0" 
$ns at 833.5223527294764 "$node_(470) setdest 109767 40804 2.0" 
$ns at 869.8988265744432 "$node_(470) setdest 84462 27167 5.0" 
$ns at 472.5785844333843 "$node_(471) setdest 97071 44680 17.0" 
$ns at 667.9869772588023 "$node_(471) setdest 5819 17209 11.0" 
$ns at 718.2837988893721 "$node_(471) setdest 43867 15053 3.0" 
$ns at 752.8120962880591 "$node_(471) setdest 58822 14176 9.0" 
$ns at 846.5685582018498 "$node_(471) setdest 106381 23578 8.0" 
$ns at 400.17490200807447 "$node_(472) setdest 124565 3600 18.0" 
$ns at 522.7802597540758 "$node_(472) setdest 18963 3983 13.0" 
$ns at 671.5198729185678 "$node_(472) setdest 115552 24717 6.0" 
$ns at 752.4727230061696 "$node_(472) setdest 128476 20254 11.0" 
$ns at 811.3217153388526 "$node_(472) setdest 113040 1412 15.0" 
$ns at 899.2769781493009 "$node_(472) setdest 131283 42028 1.0" 
$ns at 457.86201432195963 "$node_(473) setdest 8230 4782 15.0" 
$ns at 631.1806686859117 "$node_(473) setdest 17130 20509 18.0" 
$ns at 679.577198583131 "$node_(473) setdest 55290 12660 11.0" 
$ns at 720.7377521950325 "$node_(473) setdest 71504 26331 6.0" 
$ns at 773.669661065352 "$node_(473) setdest 10981 41837 13.0" 
$ns at 491.29592991822403 "$node_(474) setdest 99894 22996 10.0" 
$ns at 530.0227927743202 "$node_(474) setdest 97391 29911 3.0" 
$ns at 586.7721259082057 "$node_(474) setdest 24247 24944 12.0" 
$ns at 725.9483669097929 "$node_(474) setdest 19481 27363 3.0" 
$ns at 780.2971699027825 "$node_(474) setdest 123169 9260 6.0" 
$ns at 841.4344916701351 "$node_(474) setdest 83339 28909 3.0" 
$ns at 897.203101295552 "$node_(474) setdest 119310 1608 15.0" 
$ns at 409.38884817193974 "$node_(475) setdest 16258 29231 15.0" 
$ns at 487.6247684501907 "$node_(475) setdest 46266 17863 19.0" 
$ns at 629.0477830258048 "$node_(475) setdest 79315 22644 11.0" 
$ns at 716.830297499496 "$node_(475) setdest 103236 38079 15.0" 
$ns at 810.2693372535884 "$node_(475) setdest 121094 11924 8.0" 
$ns at 872.7407914210482 "$node_(475) setdest 116231 7429 15.0" 
$ns at 433.758048070049 "$node_(476) setdest 78767 31381 6.0" 
$ns at 518.4744607217756 "$node_(476) setdest 81757 6575 15.0" 
$ns at 627.8075019893618 "$node_(476) setdest 96653 5661 6.0" 
$ns at 661.2388864055588 "$node_(476) setdest 119961 13681 1.0" 
$ns at 700.2384292647068 "$node_(476) setdest 5023 14711 18.0" 
$ns at 896.3553644527259 "$node_(476) setdest 21267 18127 6.0" 
$ns at 445.2972590251794 "$node_(477) setdest 73819 30025 11.0" 
$ns at 493.0050265688477 "$node_(477) setdest 43592 25760 1.0" 
$ns at 525.0669829866201 "$node_(477) setdest 35593 33740 11.0" 
$ns at 657.6199990019252 "$node_(477) setdest 114064 12191 6.0" 
$ns at 727.3565766105266 "$node_(477) setdest 33904 24280 18.0" 
$ns at 878.70430201612 "$node_(477) setdest 71315 44517 16.0" 
$ns at 422.7785516119978 "$node_(478) setdest 102280 3661 6.0" 
$ns at 467.1693700869113 "$node_(478) setdest 47470 42734 5.0" 
$ns at 534.9560804579982 "$node_(478) setdest 78606 10354 10.0" 
$ns at 570.5484170877644 "$node_(478) setdest 86053 33686 10.0" 
$ns at 646.7891730709033 "$node_(478) setdest 80267 12190 7.0" 
$ns at 728.4978374402108 "$node_(478) setdest 31291 7221 11.0" 
$ns at 783.0800367674402 "$node_(478) setdest 90590 34554 3.0" 
$ns at 825.8018572485785 "$node_(478) setdest 50914 12493 3.0" 
$ns at 865.8859202778106 "$node_(478) setdest 90088 2157 2.0" 
$ns at 427.647655277112 "$node_(479) setdest 57721 19412 10.0" 
$ns at 552.2723056757842 "$node_(479) setdest 10324 9291 14.0" 
$ns at 689.7202722016998 "$node_(479) setdest 19634 30182 2.0" 
$ns at 721.2961678074001 "$node_(479) setdest 110769 6586 6.0" 
$ns at 754.7088922801355 "$node_(479) setdest 113206 10176 18.0" 
$ns at 433.42587908580606 "$node_(480) setdest 109966 41845 17.0" 
$ns at 485.8475475638803 "$node_(480) setdest 101110 3278 13.0" 
$ns at 636.0116339010931 "$node_(480) setdest 24628 29687 9.0" 
$ns at 728.1825980994397 "$node_(480) setdest 2267 3984 8.0" 
$ns at 772.252424925315 "$node_(480) setdest 115777 66 9.0" 
$ns at 803.3560701439809 "$node_(480) setdest 110727 38467 2.0" 
$ns at 841.2075975321454 "$node_(480) setdest 77639 36453 10.0" 
$ns at 564.5210536327663 "$node_(481) setdest 66712 33486 7.0" 
$ns at 631.1912523437004 "$node_(481) setdest 3375 4429 8.0" 
$ns at 724.3531922586856 "$node_(481) setdest 33221 6890 16.0" 
$ns at 768.462902352744 "$node_(481) setdest 124482 24397 4.0" 
$ns at 826.1005739400365 "$node_(481) setdest 7461 33827 2.0" 
$ns at 871.5064460066484 "$node_(481) setdest 132065 11712 18.0" 
$ns at 480.29292677114597 "$node_(482) setdest 24902 8371 11.0" 
$ns at 558.3059241709922 "$node_(482) setdest 6299 42818 8.0" 
$ns at 594.2352390378292 "$node_(482) setdest 68861 21209 6.0" 
$ns at 632.3495480352279 "$node_(482) setdest 68753 9799 15.0" 
$ns at 736.1533518492784 "$node_(482) setdest 85456 32480 15.0" 
$ns at 778.9720075798102 "$node_(482) setdest 87261 2305 10.0" 
$ns at 832.8578460528477 "$node_(482) setdest 67959 32944 19.0" 
$ns at 871.5206838651299 "$node_(482) setdest 1459 18603 3.0" 
$ns at 417.98396855820835 "$node_(483) setdest 33349 7552 14.0" 
$ns at 498.8991537458552 "$node_(483) setdest 65382 9329 8.0" 
$ns at 542.7082247341789 "$node_(483) setdest 58177 39308 8.0" 
$ns at 600.3139021655777 "$node_(483) setdest 98310 19751 13.0" 
$ns at 687.0487075798802 "$node_(483) setdest 38145 7866 11.0" 
$ns at 768.1682366332489 "$node_(483) setdest 15289 34880 19.0" 
$ns at 443.6395035953868 "$node_(484) setdest 21030 31356 9.0" 
$ns at 514.7712971029139 "$node_(484) setdest 72298 38526 6.0" 
$ns at 547.1562524304006 "$node_(484) setdest 61439 14651 1.0" 
$ns at 585.2902117459068 "$node_(484) setdest 67647 40071 10.0" 
$ns at 615.5986985085389 "$node_(484) setdest 27553 10315 10.0" 
$ns at 696.2110796845491 "$node_(484) setdest 44197 7206 14.0" 
$ns at 737.8911584568747 "$node_(484) setdest 63289 1230 16.0" 
$ns at 793.1974654341709 "$node_(484) setdest 116016 23174 19.0" 
$ns at 863.7982417794699 "$node_(484) setdest 46429 28636 11.0" 
$ns at 425.9702316189838 "$node_(485) setdest 89067 19317 6.0" 
$ns at 488.6538494028168 "$node_(485) setdest 18015 33654 9.0" 
$ns at 595.6995725260815 "$node_(485) setdest 3772 29150 2.0" 
$ns at 633.3664281707375 "$node_(485) setdest 2711 30136 19.0" 
$ns at 833.081079793788 "$node_(485) setdest 119454 40579 17.0" 
$ns at 485.08660438090413 "$node_(486) setdest 38439 44613 16.0" 
$ns at 672.3164933333205 "$node_(486) setdest 79750 23690 18.0" 
$ns at 869.2880180836737 "$node_(486) setdest 126370 1462 6.0" 
$ns at 546.383832983985 "$node_(487) setdest 21734 41278 7.0" 
$ns at 637.5805704197747 "$node_(487) setdest 122156 21052 2.0" 
$ns at 680.7873253647366 "$node_(487) setdest 45475 19006 4.0" 
$ns at 749.5251916557125 "$node_(487) setdest 60273 4746 6.0" 
$ns at 794.8252743667806 "$node_(487) setdest 95765 28162 16.0" 
$ns at 829.6612848359247 "$node_(487) setdest 51589 12297 18.0" 
$ns at 866.2565666032331 "$node_(487) setdest 89207 35707 13.0" 
$ns at 425.1045288468365 "$node_(488) setdest 68938 9943 6.0" 
$ns at 457.9854735543093 "$node_(488) setdest 105977 35964 3.0" 
$ns at 496.5527984722042 "$node_(488) setdest 43073 22064 14.0" 
$ns at 590.9854220903894 "$node_(488) setdest 88956 2921 10.0" 
$ns at 706.3372700402836 "$node_(488) setdest 4686 1526 2.0" 
$ns at 753.2446892351544 "$node_(488) setdest 19094 27780 11.0" 
$ns at 870.727592398693 "$node_(488) setdest 125400 41266 11.0" 
$ns at 485.64781560831557 "$node_(489) setdest 62218 12948 19.0" 
$ns at 700.6057179287722 "$node_(489) setdest 74409 19156 2.0" 
$ns at 748.6332325628646 "$node_(489) setdest 90878 36072 18.0" 
$ns at 434.2333681800366 "$node_(490) setdest 30975 15649 15.0" 
$ns at 525.1253844832526 "$node_(490) setdest 49183 12791 3.0" 
$ns at 564.8362806476098 "$node_(490) setdest 70000 22703 16.0" 
$ns at 744.8455845900811 "$node_(490) setdest 16032 43713 4.0" 
$ns at 785.6159762248393 "$node_(490) setdest 51437 18125 13.0" 
$ns at 857.0622653810909 "$node_(490) setdest 132117 20678 8.0" 
$ns at 408.8276029856241 "$node_(491) setdest 133089 36635 16.0" 
$ns at 588.0984703909008 "$node_(491) setdest 117088 25273 1.0" 
$ns at 618.6034234908283 "$node_(491) setdest 89008 7369 15.0" 
$ns at 753.7379394645066 "$node_(491) setdest 102053 17977 16.0" 
$ns at 532.2004647746699 "$node_(492) setdest 58406 29180 1.0" 
$ns at 564.8162169120174 "$node_(492) setdest 126985 38057 17.0" 
$ns at 599.2497328851613 "$node_(492) setdest 20805 30198 10.0" 
$ns at 717.8775076683781 "$node_(492) setdest 51396 7843 3.0" 
$ns at 758.2286152925095 "$node_(492) setdest 123291 7535 13.0" 
$ns at 877.6778459670821 "$node_(492) setdest 95442 8174 12.0" 
$ns at 427.96530607223036 "$node_(493) setdest 125179 4522 14.0" 
$ns at 588.860355271602 "$node_(493) setdest 19525 6847 7.0" 
$ns at 628.9642419861354 "$node_(493) setdest 91162 44409 20.0" 
$ns at 699.2960409006338 "$node_(493) setdest 64721 21978 18.0" 
$ns at 818.9526225129981 "$node_(493) setdest 38744 22092 2.0" 
$ns at 849.2454531025448 "$node_(493) setdest 4300 25921 14.0" 
$ns at 443.7568689441628 "$node_(494) setdest 7300 8780 19.0" 
$ns at 502.4720348302326 "$node_(494) setdest 73239 2525 9.0" 
$ns at 539.4355333336833 "$node_(494) setdest 43275 13222 16.0" 
$ns at 677.6433165430647 "$node_(494) setdest 16756 43797 11.0" 
$ns at 762.973212818852 "$node_(494) setdest 15736 34285 17.0" 
$ns at 891.3565202920081 "$node_(494) setdest 47431 17498 18.0" 
$ns at 424.0771099662823 "$node_(495) setdest 15750 19767 8.0" 
$ns at 474.91288165616214 "$node_(495) setdest 45339 14878 1.0" 
$ns at 514.3039660773248 "$node_(495) setdest 23309 26578 4.0" 
$ns at 567.7970390446736 "$node_(495) setdest 65483 41857 6.0" 
$ns at 638.9693679964953 "$node_(495) setdest 76588 10825 1.0" 
$ns at 676.1729410762653 "$node_(495) setdest 101 11566 11.0" 
$ns at 778.3094711083767 "$node_(495) setdest 85567 29976 10.0" 
$ns at 812.1598149240832 "$node_(495) setdest 116381 30838 5.0" 
$ns at 863.5420797965271 "$node_(495) setdest 41400 14119 17.0" 
$ns at 404.6950380341224 "$node_(496) setdest 120406 7041 3.0" 
$ns at 440.91375185856015 "$node_(496) setdest 90589 7600 10.0" 
$ns at 528.3805383100745 "$node_(496) setdest 89599 24660 11.0" 
$ns at 561.6612714812726 "$node_(496) setdest 99888 26207 13.0" 
$ns at 613.5666363483372 "$node_(496) setdest 90775 5249 17.0" 
$ns at 793.7871735863703 "$node_(496) setdest 106040 14462 16.0" 
$ns at 882.8728488125585 "$node_(496) setdest 93773 37631 7.0" 
$ns at 560.5284437561172 "$node_(497) setdest 58534 39119 20.0" 
$ns at 785.1702957398743 "$node_(497) setdest 30033 11704 8.0" 
$ns at 868.0201118667627 "$node_(497) setdest 112756 8143 13.0" 
$ns at 408.26636954755236 "$node_(498) setdest 248 12455 3.0" 
$ns at 440.54495405746496 "$node_(498) setdest 90172 42939 16.0" 
$ns at 478.49815259837527 "$node_(498) setdest 130503 1707 17.0" 
$ns at 550.4036159394855 "$node_(498) setdest 78418 22254 13.0" 
$ns at 670.3799971471931 "$node_(498) setdest 48498 28097 14.0" 
$ns at 747.0934995137466 "$node_(498) setdest 99382 4010 17.0" 
$ns at 843.5923267022824 "$node_(498) setdest 43089 14763 3.0" 
$ns at 894.1290195323087 "$node_(498) setdest 77569 12492 7.0" 
$ns at 510.7686630863609 "$node_(499) setdest 114923 28063 5.0" 
$ns at 572.3921037368881 "$node_(499) setdest 107977 38717 13.0" 
$ns at 638.4501267575046 "$node_(499) setdest 67056 32492 10.0" 
$ns at 730.2362409286844 "$node_(499) setdest 64120 32290 12.0" 
$ns at 834.9423563226799 "$node_(499) setdest 107675 27967 11.0" 
$ns at 518.1794527834194 "$node_(500) setdest 79374 36516 16.0" 
$ns at 661.0580658020531 "$node_(500) setdest 49253 4186 2.0" 
$ns at 703.9288327397597 "$node_(500) setdest 32091 43930 12.0" 
$ns at 768.8017594125848 "$node_(500) setdest 103551 9853 1.0" 
$ns at 799.2057160992248 "$node_(500) setdest 32595 10461 7.0" 
$ns at 844.0435293483446 "$node_(500) setdest 22220 43439 2.0" 
$ns at 880.661374859814 "$node_(500) setdest 125103 15200 20.0" 
$ns at 577.1597479086714 "$node_(501) setdest 77493 19836 8.0" 
$ns at 633.4940994383325 "$node_(501) setdest 473 42597 15.0" 
$ns at 763.0383217710571 "$node_(501) setdest 93284 17831 12.0" 
$ns at 880.5847791343878 "$node_(501) setdest 56653 40846 6.0" 
$ns at 547.9976780417286 "$node_(502) setdest 16304 38639 4.0" 
$ns at 612.0943444329623 "$node_(502) setdest 16776 23640 14.0" 
$ns at 656.9555766717685 "$node_(502) setdest 77453 24878 7.0" 
$ns at 720.9313415704034 "$node_(502) setdest 37698 28603 16.0" 
$ns at 786.8658670800571 "$node_(502) setdest 112726 38481 15.0" 
$ns at 576.0592944263265 "$node_(503) setdest 32277 28181 10.0" 
$ns at 653.9465745217299 "$node_(503) setdest 42113 25099 14.0" 
$ns at 776.332373536957 "$node_(503) setdest 133977 41772 5.0" 
$ns at 828.1397102265746 "$node_(503) setdest 98450 1055 9.0" 
$ns at 509.34199437776846 "$node_(504) setdest 15754 7581 19.0" 
$ns at 592.3413434392636 "$node_(504) setdest 56542 40882 1.0" 
$ns at 624.9304593035711 "$node_(504) setdest 124083 6409 9.0" 
$ns at 673.181680645439 "$node_(504) setdest 72724 41325 17.0" 
$ns at 811.0033066505023 "$node_(504) setdest 51171 20383 10.0" 
$ns at 517.2832317758721 "$node_(505) setdest 45960 40145 20.0" 
$ns at 706.1220135722015 "$node_(505) setdest 127997 12927 7.0" 
$ns at 747.0500477783651 "$node_(505) setdest 12821 36328 15.0" 
$ns at 835.9779978393332 "$node_(505) setdest 106777 1747 6.0" 
$ns at 529.4748728547523 "$node_(506) setdest 105089 27881 12.0" 
$ns at 605.5260181505021 "$node_(506) setdest 105337 10601 18.0" 
$ns at 641.5368158046801 "$node_(506) setdest 92785 42637 4.0" 
$ns at 672.3347267125872 "$node_(506) setdest 125244 14966 11.0" 
$ns at 714.9130397028201 "$node_(506) setdest 12989 28074 20.0" 
$ns at 503.74457679010527 "$node_(507) setdest 104382 34332 7.0" 
$ns at 569.9047306035181 "$node_(507) setdest 121316 33496 4.0" 
$ns at 605.2415972459411 "$node_(507) setdest 85232 12021 16.0" 
$ns at 748.5297059758137 "$node_(507) setdest 104544 26070 11.0" 
$ns at 808.110735678447 "$node_(507) setdest 89054 35556 11.0" 
$ns at 894.1169945883623 "$node_(507) setdest 26447 6114 13.0" 
$ns at 564.1843483664502 "$node_(508) setdest 73928 39765 11.0" 
$ns at 690.8420428957853 "$node_(508) setdest 52669 15008 19.0" 
$ns at 839.2383265656982 "$node_(508) setdest 18860 8918 19.0" 
$ns at 531.7332499418305 "$node_(509) setdest 40935 20796 19.0" 
$ns at 595.0908234022291 "$node_(509) setdest 111002 11316 3.0" 
$ns at 644.8374244046581 "$node_(509) setdest 40028 3402 11.0" 
$ns at 739.9017372711764 "$node_(509) setdest 61083 8561 18.0" 
$ns at 564.6696562210612 "$node_(510) setdest 6982 9901 4.0" 
$ns at 617.0387167157652 "$node_(510) setdest 41628 33812 6.0" 
$ns at 682.4545376889125 "$node_(510) setdest 131601 32923 13.0" 
$ns at 815.2775789426994 "$node_(510) setdest 40784 2575 20.0" 
$ns at 593.201560692278 "$node_(511) setdest 87528 29722 3.0" 
$ns at 637.7613485346701 "$node_(511) setdest 8928 17423 19.0" 
$ns at 753.1813968423645 "$node_(511) setdest 113637 24947 1.0" 
$ns at 786.3401779887548 "$node_(511) setdest 123537 29003 13.0" 
$ns at 876.4989228878358 "$node_(511) setdest 107096 40558 3.0" 
$ns at 511.7650587819856 "$node_(512) setdest 127646 11416 14.0" 
$ns at 544.620641920574 "$node_(512) setdest 76139 12076 10.0" 
$ns at 641.8756005521969 "$node_(512) setdest 99730 435 14.0" 
$ns at 754.6131092971152 "$node_(512) setdest 5242 33412 17.0" 
$ns at 825.4604262436117 "$node_(512) setdest 42278 18484 15.0" 
$ns at 521.9677025929542 "$node_(513) setdest 6664 4794 20.0" 
$ns at 694.5470097831937 "$node_(513) setdest 33296 39981 5.0" 
$ns at 762.0679448725513 "$node_(513) setdest 41608 35113 17.0" 
$ns at 880.9120111725305 "$node_(513) setdest 71858 22987 19.0" 
$ns at 622.5214531956376 "$node_(514) setdest 93682 20405 9.0" 
$ns at 709.4808180484702 "$node_(514) setdest 69466 35606 8.0" 
$ns at 791.9452226757015 "$node_(514) setdest 86398 5741 18.0" 
$ns at 507.47040154909394 "$node_(515) setdest 94482 23548 13.0" 
$ns at 650.9805547106502 "$node_(515) setdest 129456 38 6.0" 
$ns at 711.9776740862841 "$node_(515) setdest 57842 1552 18.0" 
$ns at 890.8563155594755 "$node_(515) setdest 75699 19505 3.0" 
$ns at 655.6733207806535 "$node_(516) setdest 87168 4239 8.0" 
$ns at 741.7283252926745 "$node_(516) setdest 13786 15233 6.0" 
$ns at 826.6878538351806 "$node_(516) setdest 111708 22788 3.0" 
$ns at 862.8449344191375 "$node_(516) setdest 40316 33016 3.0" 
$ns at 597.0850878818694 "$node_(517) setdest 1334 8759 17.0" 
$ns at 744.4593784346896 "$node_(517) setdest 3388 20817 12.0" 
$ns at 790.4700874265302 "$node_(517) setdest 29417 40620 16.0" 
$ns at 874.258136922672 "$node_(517) setdest 123284 4310 6.0" 
$ns at 543.7277055621105 "$node_(518) setdest 109672 3541 1.0" 
$ns at 576.753762170127 "$node_(518) setdest 126846 11420 20.0" 
$ns at 688.2317550775372 "$node_(518) setdest 49276 30764 11.0" 
$ns at 822.4313089575819 "$node_(518) setdest 69844 12718 13.0" 
$ns at 527.8679535576434 "$node_(519) setdest 45836 34088 4.0" 
$ns at 595.1759961255558 "$node_(519) setdest 53220 7681 14.0" 
$ns at 657.8541359133496 "$node_(519) setdest 204 25099 10.0" 
$ns at 768.4095334411961 "$node_(519) setdest 14396 8712 19.0" 
$ns at 501.3186001942017 "$node_(520) setdest 103159 12224 13.0" 
$ns at 601.1232560630582 "$node_(520) setdest 93436 3144 9.0" 
$ns at 719.0290998720292 "$node_(520) setdest 120309 29045 3.0" 
$ns at 760.1202346897173 "$node_(520) setdest 62284 5118 11.0" 
$ns at 865.6066902481133 "$node_(520) setdest 14085 41519 18.0" 
$ns at 567.6674361893549 "$node_(521) setdest 106979 20299 17.0" 
$ns at 661.49745601012 "$node_(521) setdest 74965 9155 7.0" 
$ns at 744.9357696357932 "$node_(521) setdest 70120 14331 1.0" 
$ns at 778.0732930576572 "$node_(521) setdest 23025 31497 16.0" 
$ns at 815.5785609457562 "$node_(521) setdest 86571 39880 9.0" 
$ns at 596.5295930005803 "$node_(522) setdest 84022 29278 8.0" 
$ns at 652.105637534391 "$node_(522) setdest 77658 36365 14.0" 
$ns at 743.2196297479934 "$node_(522) setdest 109795 32902 6.0" 
$ns at 781.4451224655169 "$node_(522) setdest 6057 38286 13.0" 
$ns at 517.3066484784101 "$node_(523) setdest 20561 29406 7.0" 
$ns at 594.1844549241112 "$node_(523) setdest 26819 20635 11.0" 
$ns at 652.0057543824664 "$node_(523) setdest 10835 39076 12.0" 
$ns at 696.3172641681076 "$node_(523) setdest 80216 10420 18.0" 
$ns at 836.2997087639849 "$node_(523) setdest 83456 17921 9.0" 
$ns at 875.810097948807 "$node_(523) setdest 133491 24540 10.0" 
$ns at 529.672617688316 "$node_(524) setdest 85605 43372 14.0" 
$ns at 689.071470156026 "$node_(524) setdest 80886 26064 15.0" 
$ns at 818.2009279483252 "$node_(524) setdest 4852 15855 12.0" 
$ns at 529.8895508560805 "$node_(525) setdest 71645 2404 10.0" 
$ns at 578.8072224713759 "$node_(525) setdest 114937 37547 19.0" 
$ns at 725.3993266014077 "$node_(525) setdest 73421 23789 8.0" 
$ns at 775.9600389072396 "$node_(525) setdest 125454 22585 7.0" 
$ns at 843.0435993288553 "$node_(525) setdest 74693 13040 1.0" 
$ns at 882.6911016750612 "$node_(525) setdest 34511 26106 5.0" 
$ns at 536.4860374483112 "$node_(526) setdest 116793 32812 7.0" 
$ns at 571.3636836118056 "$node_(526) setdest 99303 25448 11.0" 
$ns at 609.0043667536471 "$node_(526) setdest 71761 34888 10.0" 
$ns at 734.0867583151912 "$node_(526) setdest 40621 39494 3.0" 
$ns at 771.9607857924063 "$node_(526) setdest 93261 9078 18.0" 
$ns at 841.7426173570741 "$node_(526) setdest 58087 15360 15.0" 
$ns at 514.7781337061682 "$node_(527) setdest 87141 34687 17.0" 
$ns at 667.5708280930169 "$node_(527) setdest 113382 17214 7.0" 
$ns at 719.7435658843162 "$node_(527) setdest 7020 23769 1.0" 
$ns at 758.0480441266478 "$node_(527) setdest 79499 5395 17.0" 
$ns at 896.5477641818496 "$node_(527) setdest 60113 42863 18.0" 
$ns at 510.23453092762446 "$node_(528) setdest 6176 40056 4.0" 
$ns at 551.6325518795528 "$node_(528) setdest 109918 8713 19.0" 
$ns at 600.6081717721354 "$node_(528) setdest 121238 322 19.0" 
$ns at 678.2147849375051 "$node_(528) setdest 48529 32082 12.0" 
$ns at 770.2110205175815 "$node_(528) setdest 59169 23454 14.0" 
$ns at 512.5474486563468 "$node_(529) setdest 94887 17152 10.0" 
$ns at 573.3624551322147 "$node_(529) setdest 96518 14193 7.0" 
$ns at 612.7176566909992 "$node_(529) setdest 109097 27055 3.0" 
$ns at 659.9807343862557 "$node_(529) setdest 47696 24572 1.0" 
$ns at 690.2675975498635 "$node_(529) setdest 93747 19496 1.0" 
$ns at 725.4203731695532 "$node_(529) setdest 10216 9052 4.0" 
$ns at 764.1011418962106 "$node_(529) setdest 7336 6085 16.0" 
$ns at 556.3071076104591 "$node_(530) setdest 85000 12071 10.0" 
$ns at 602.0498446885032 "$node_(530) setdest 82217 43177 12.0" 
$ns at 648.6841599757195 "$node_(530) setdest 115491 28523 15.0" 
$ns at 712.7948205604416 "$node_(530) setdest 60370 27863 17.0" 
$ns at 769.1278062759851 "$node_(530) setdest 35437 41369 10.0" 
$ns at 869.5776146038082 "$node_(530) setdest 100382 36410 7.0" 
$ns at 502.5644913706917 "$node_(531) setdest 111062 4745 10.0" 
$ns at 542.0519719767444 "$node_(531) setdest 79049 18217 19.0" 
$ns at 669.3527950845705 "$node_(531) setdest 128683 20926 17.0" 
$ns at 766.0827311738096 "$node_(531) setdest 23191 10057 12.0" 
$ns at 812.1212627553177 "$node_(531) setdest 117008 30789 18.0" 
$ns at 568.1824477603288 "$node_(532) setdest 48336 43401 13.0" 
$ns at 617.4483496994018 "$node_(532) setdest 85395 38687 12.0" 
$ns at 729.0735301519456 "$node_(532) setdest 15431 5354 5.0" 
$ns at 793.3679202148959 "$node_(532) setdest 71233 22065 2.0" 
$ns at 828.6589039871044 "$node_(532) setdest 13952 3691 1.0" 
$ns at 861.6236482834483 "$node_(532) setdest 43195 9195 2.0" 
$ns at 516.4437944959797 "$node_(533) setdest 95799 32289 4.0" 
$ns at 578.9848461485793 "$node_(533) setdest 16912 2180 19.0" 
$ns at 710.5185272622009 "$node_(533) setdest 58368 1870 19.0" 
$ns at 740.854022997222 "$node_(533) setdest 113827 17429 6.0" 
$ns at 795.9861981050244 "$node_(533) setdest 75293 39431 8.0" 
$ns at 871.0597209122442 "$node_(533) setdest 70314 3639 8.0" 
$ns at 554.9131239906808 "$node_(534) setdest 31295 4511 11.0" 
$ns at 608.6265763772203 "$node_(534) setdest 58383 40876 16.0" 
$ns at 655.7018629031393 "$node_(534) setdest 50848 1415 20.0" 
$ns at 822.1170698414718 "$node_(534) setdest 1116 39808 10.0" 
$ns at 579.5599413954717 "$node_(535) setdest 113136 38194 19.0" 
$ns at 793.5402949795435 "$node_(535) setdest 57161 41045 6.0" 
$ns at 858.0418846803631 "$node_(535) setdest 60540 8623 10.0" 
$ns at 530.1752139778738 "$node_(536) setdest 50300 36572 15.0" 
$ns at 619.9672207951274 "$node_(536) setdest 47082 31834 7.0" 
$ns at 690.3168775687354 "$node_(536) setdest 14761 28014 13.0" 
$ns at 740.9243949749781 "$node_(536) setdest 46754 27725 11.0" 
$ns at 814.1154122647855 "$node_(536) setdest 93269 43665 9.0" 
$ns at 873.762674987107 "$node_(536) setdest 131329 22031 18.0" 
$ns at 544.335980278031 "$node_(537) setdest 63155 5848 3.0" 
$ns at 603.1199032050706 "$node_(537) setdest 19899 27462 1.0" 
$ns at 634.2455319819221 "$node_(537) setdest 22724 22854 9.0" 
$ns at 721.4139692820245 "$node_(537) setdest 104019 35232 12.0" 
$ns at 775.3184200863279 "$node_(537) setdest 53385 35840 14.0" 
$ns at 818.7028144237339 "$node_(537) setdest 53840 28605 18.0" 
$ns at 854.2024816275818 "$node_(537) setdest 71979 13004 16.0" 
$ns at 654.569417037925 "$node_(538) setdest 21644 35643 18.0" 
$ns at 802.4581189920048 "$node_(538) setdest 41725 17230 4.0" 
$ns at 853.7748125510759 "$node_(538) setdest 81143 29842 10.0" 
$ns at 523.5767636688066 "$node_(539) setdest 81581 34303 16.0" 
$ns at 563.7462085128911 "$node_(539) setdest 76284 9891 7.0" 
$ns at 648.7387309476371 "$node_(539) setdest 18225 38209 2.0" 
$ns at 687.1870985671129 "$node_(539) setdest 114754 40657 6.0" 
$ns at 756.5193086705167 "$node_(539) setdest 14035 21031 6.0" 
$ns at 790.7180887620586 "$node_(539) setdest 9943 11326 8.0" 
$ns at 857.0520943381347 "$node_(539) setdest 72916 26828 4.0" 
$ns at 577.3468491753595 "$node_(540) setdest 82521 35738 4.0" 
$ns at 624.536332055704 "$node_(540) setdest 39991 15198 18.0" 
$ns at 828.7560863698302 "$node_(540) setdest 74660 29257 1.0" 
$ns at 867.6127540520233 "$node_(540) setdest 58433 44503 13.0" 
$ns at 538.2073815455642 "$node_(541) setdest 1422 20018 5.0" 
$ns at 570.5398442554722 "$node_(541) setdest 110568 13269 16.0" 
$ns at 748.0884684915854 "$node_(541) setdest 113372 35921 19.0" 
$ns at 894.4801702186971 "$node_(541) setdest 64469 22603 1.0" 
$ns at 506.0154883717692 "$node_(542) setdest 120982 38854 10.0" 
$ns at 623.2143107328014 "$node_(542) setdest 56008 12847 8.0" 
$ns at 684.5540615873671 "$node_(542) setdest 86107 35389 5.0" 
$ns at 741.5683158151945 "$node_(542) setdest 110359 2753 14.0" 
$ns at 798.0301391423263 "$node_(542) setdest 43718 19998 2.0" 
$ns at 830.1230157549434 "$node_(542) setdest 133936 10792 6.0" 
$ns at 863.116338368201 "$node_(542) setdest 128381 18497 6.0" 
$ns at 635.2816318080595 "$node_(543) setdest 89804 35054 18.0" 
$ns at 682.36311149581 "$node_(543) setdest 75928 28060 20.0" 
$ns at 879.1954449237619 "$node_(543) setdest 4982 26834 13.0" 
$ns at 516.7151712165293 "$node_(544) setdest 86547 8968 5.0" 
$ns at 554.0710715525079 "$node_(544) setdest 21554 22465 16.0" 
$ns at 671.3008289029831 "$node_(544) setdest 113700 22597 2.0" 
$ns at 701.8072508537459 "$node_(544) setdest 82812 18936 4.0" 
$ns at 732.9650690068222 "$node_(544) setdest 83061 627 5.0" 
$ns at 809.3258566503429 "$node_(544) setdest 24210 38908 8.0" 
$ns at 846.443468455014 "$node_(544) setdest 43304 40649 4.0" 
$ns at 506.48279333813156 "$node_(545) setdest 15154 26309 1.0" 
$ns at 538.4557862267982 "$node_(545) setdest 73480 33316 6.0" 
$ns at 614.6672320560803 "$node_(545) setdest 80441 34232 19.0" 
$ns at 805.7153315440504 "$node_(545) setdest 79196 42123 7.0" 
$ns at 862.2530569412606 "$node_(545) setdest 71558 9674 16.0" 
$ns at 896.7984697993608 "$node_(545) setdest 133694 21437 9.0" 
$ns at 511.86170703509487 "$node_(546) setdest 18647 39751 7.0" 
$ns at 572.9901790646087 "$node_(546) setdest 72975 14058 5.0" 
$ns at 649.3143502135241 "$node_(546) setdest 80706 5312 2.0" 
$ns at 694.7229637368829 "$node_(546) setdest 9947 19723 9.0" 
$ns at 761.6589741887337 "$node_(546) setdest 15064 18457 19.0" 
$ns at 831.8874936892848 "$node_(546) setdest 81953 42443 10.0" 
$ns at 883.1751177616636 "$node_(546) setdest 19297 40361 16.0" 
$ns at 614.6301650565417 "$node_(547) setdest 38010 22052 18.0" 
$ns at 689.4021971896052 "$node_(547) setdest 126875 11364 16.0" 
$ns at 800.6306930389378 "$node_(547) setdest 19806 26020 4.0" 
$ns at 864.9371364453368 "$node_(547) setdest 17528 35020 12.0" 
$ns at 518.655871858031 "$node_(548) setdest 41271 6562 18.0" 
$ns at 725.6327591442457 "$node_(548) setdest 65806 6168 14.0" 
$ns at 886.9064736816512 "$node_(548) setdest 39334 32260 9.0" 
$ns at 577.2124164821846 "$node_(549) setdest 32023 23809 14.0" 
$ns at 645.8202571368508 "$node_(549) setdest 53110 1847 7.0" 
$ns at 736.4412447605437 "$node_(549) setdest 36264 38809 9.0" 
$ns at 834.3950552992276 "$node_(549) setdest 36582 32157 6.0" 
$ns at 891.3675858918881 "$node_(549) setdest 125166 21174 12.0" 
$ns at 507.2613586775288 "$node_(550) setdest 100917 20082 7.0" 
$ns at 569.9019032681907 "$node_(550) setdest 54269 29231 17.0" 
$ns at 668.1783606877502 "$node_(550) setdest 18362 11555 13.0" 
$ns at 760.8539091369894 "$node_(550) setdest 87059 41540 6.0" 
$ns at 848.2944046718112 "$node_(550) setdest 5447 38827 9.0" 
$ns at 897.7203520447193 "$node_(550) setdest 132711 3590 4.0" 
$ns at 573.7360531283862 "$node_(551) setdest 76424 30048 14.0" 
$ns at 738.0328730504299 "$node_(551) setdest 110305 37819 13.0" 
$ns at 892.4981790989463 "$node_(551) setdest 79106 40000 4.0" 
$ns at 531.7966287572651 "$node_(552) setdest 29800 26063 4.0" 
$ns at 584.1021028682965 "$node_(552) setdest 126685 27535 2.0" 
$ns at 617.5304854378866 "$node_(552) setdest 95480 33884 14.0" 
$ns at 726.2915799821784 "$node_(552) setdest 132413 16112 8.0" 
$ns at 823.4177158972202 "$node_(552) setdest 34207 14717 6.0" 
$ns at 884.1753171688789 "$node_(552) setdest 51332 37419 1.0" 
$ns at 553.1824024488313 "$node_(553) setdest 86405 41788 18.0" 
$ns at 621.8576247832688 "$node_(553) setdest 83572 42466 2.0" 
$ns at 658.7054839805089 "$node_(553) setdest 97067 24482 16.0" 
$ns at 791.0601594267362 "$node_(553) setdest 35475 1724 13.0" 
$ns at 836.6932834131701 "$node_(553) setdest 18459 2477 19.0" 
$ns at 558.0548355269268 "$node_(554) setdest 60763 8234 11.0" 
$ns at 606.1903480777594 "$node_(554) setdest 80602 15854 7.0" 
$ns at 662.4518754088014 "$node_(554) setdest 56087 42344 18.0" 
$ns at 817.7017847571263 "$node_(554) setdest 24450 17356 15.0" 
$ns at 524.427860854936 "$node_(555) setdest 128222 30420 8.0" 
$ns at 616.628331364931 "$node_(555) setdest 72610 36308 9.0" 
$ns at 675.9420623641126 "$node_(555) setdest 47414 37303 4.0" 
$ns at 716.8083818801999 "$node_(555) setdest 55057 14106 9.0" 
$ns at 825.2048203703102 "$node_(555) setdest 45274 15105 2.0" 
$ns at 870.3474373245525 "$node_(555) setdest 52646 12901 5.0" 
$ns at 557.1872687048063 "$node_(556) setdest 50502 14926 2.0" 
$ns at 590.5342761732104 "$node_(556) setdest 98775 33435 19.0" 
$ns at 672.7928683885439 "$node_(556) setdest 61745 9181 17.0" 
$ns at 812.657425133473 "$node_(556) setdest 45743 13185 19.0" 
$ns at 862.6456477883492 "$node_(556) setdest 56884 1340 4.0" 
$ns at 571.0392794835309 "$node_(557) setdest 55538 29208 20.0" 
$ns at 684.9147424187703 "$node_(557) setdest 87199 11895 14.0" 
$ns at 727.4569566772002 "$node_(557) setdest 33513 17415 11.0" 
$ns at 791.8479503486568 "$node_(557) setdest 58087 8372 16.0" 
$ns at 602.8322942257241 "$node_(558) setdest 77244 23812 16.0" 
$ns at 664.9658034960714 "$node_(558) setdest 61276 7157 4.0" 
$ns at 707.2825147302335 "$node_(558) setdest 109575 19672 20.0" 
$ns at 530.8934692751307 "$node_(559) setdest 129534 103 17.0" 
$ns at 595.0622815904319 "$node_(559) setdest 44807 19843 10.0" 
$ns at 722.3012666021184 "$node_(559) setdest 1279 35985 15.0" 
$ns at 879.9304116697658 "$node_(559) setdest 53609 41603 12.0" 
$ns at 655.0523978766946 "$node_(560) setdest 27262 30968 20.0" 
$ns at 701.1094755509569 "$node_(560) setdest 109514 12563 6.0" 
$ns at 756.2455647374182 "$node_(560) setdest 17221 41806 11.0" 
$ns at 811.7385372976813 "$node_(560) setdest 72542 20577 18.0" 
$ns at 569.1980662547226 "$node_(561) setdest 27248 43758 2.0" 
$ns at 603.1029749358072 "$node_(561) setdest 43838 22503 16.0" 
$ns at 743.4159896362448 "$node_(561) setdest 97535 18414 14.0" 
$ns at 821.1605660806201 "$node_(561) setdest 98935 31775 8.0" 
$ns at 882.1700326848735 "$node_(561) setdest 57714 5519 2.0" 
$ns at 530.4540474552093 "$node_(562) setdest 53749 37517 15.0" 
$ns at 677.0600507326895 "$node_(562) setdest 48644 37649 1.0" 
$ns at 709.304967031831 "$node_(562) setdest 16361 15493 5.0" 
$ns at 765.5099008853584 "$node_(562) setdest 87625 23569 5.0" 
$ns at 842.036354400479 "$node_(562) setdest 82203 28747 17.0" 
$ns at 570.0762402593789 "$node_(563) setdest 95176 29999 14.0" 
$ns at 703.579039210892 "$node_(563) setdest 121549 10257 12.0" 
$ns at 790.7058296096934 "$node_(563) setdest 4572 9831 18.0" 
$ns at 569.4755536320896 "$node_(564) setdest 114182 12981 7.0" 
$ns at 624.7549958514874 "$node_(564) setdest 10644 4547 16.0" 
$ns at 809.6174319687516 "$node_(564) setdest 83990 33180 16.0" 
$ns at 553.4453016725731 "$node_(565) setdest 113064 9990 5.0" 
$ns at 628.0806284671442 "$node_(565) setdest 68493 39179 19.0" 
$ns at 665.5587748206509 "$node_(565) setdest 15306 1892 10.0" 
$ns at 757.8095479217167 "$node_(565) setdest 7017 23015 4.0" 
$ns at 800.9167628554899 "$node_(565) setdest 5928 2030 13.0" 
$ns at 881.0341851828224 "$node_(565) setdest 131044 38875 13.0" 
$ns at 572.0805788522125 "$node_(566) setdest 129635 24791 9.0" 
$ns at 669.4703653199404 "$node_(566) setdest 104782 23415 13.0" 
$ns at 788.1078386158342 "$node_(566) setdest 71396 19226 17.0" 
$ns at 862.5523819488866 "$node_(566) setdest 52132 22017 19.0" 
$ns at 521.1232007914185 "$node_(567) setdest 3194 11069 17.0" 
$ns at 624.6604628992992 "$node_(567) setdest 115485 14942 9.0" 
$ns at 681.5262122429606 "$node_(567) setdest 51995 3178 11.0" 
$ns at 794.6207873148219 "$node_(567) setdest 76573 19658 4.0" 
$ns at 862.3978579965034 "$node_(567) setdest 72618 19207 15.0" 
$ns at 566.4948971540202 "$node_(568) setdest 64292 12218 7.0" 
$ns at 665.7336359258777 "$node_(568) setdest 37591 17194 5.0" 
$ns at 699.4667884468887 "$node_(568) setdest 96846 21048 16.0" 
$ns at 746.2825066448823 "$node_(568) setdest 48497 33783 9.0" 
$ns at 845.4521554736793 "$node_(568) setdest 126910 5824 8.0" 
$ns at 579.8208850652259 "$node_(569) setdest 102946 4926 2.0" 
$ns at 612.9068372103368 "$node_(569) setdest 35877 12150 18.0" 
$ns at 787.6459892894086 "$node_(569) setdest 97817 15862 10.0" 
$ns at 875.4213494387845 "$node_(569) setdest 115913 21766 11.0" 
$ns at 505.67531977470856 "$node_(570) setdest 68368 22579 14.0" 
$ns at 636.7708601865254 "$node_(570) setdest 9675 20571 1.0" 
$ns at 674.9018540852222 "$node_(570) setdest 54226 199 9.0" 
$ns at 710.5082221084097 "$node_(570) setdest 2598 32786 17.0" 
$ns at 817.3094278180293 "$node_(570) setdest 61628 5009 2.0" 
$ns at 855.9065704612719 "$node_(570) setdest 64933 2614 9.0" 
$ns at 608.7437588000604 "$node_(571) setdest 57052 18891 16.0" 
$ns at 728.329433607423 "$node_(571) setdest 105866 57 13.0" 
$ns at 823.2648861018325 "$node_(571) setdest 10387 20415 5.0" 
$ns at 885.027217373312 "$node_(571) setdest 39075 18420 4.0" 
$ns at 557.8753851370425 "$node_(572) setdest 113131 35881 20.0" 
$ns at 615.4309836437492 "$node_(572) setdest 104184 20557 14.0" 
$ns at 760.6820509358212 "$node_(572) setdest 49354 39595 4.0" 
$ns at 808.4940633057488 "$node_(572) setdest 16678 31773 12.0" 
$ns at 879.6480011261642 "$node_(572) setdest 91464 42264 15.0" 
$ns at 536.9160073811689 "$node_(573) setdest 29997 44498 16.0" 
$ns at 582.9822652073485 "$node_(573) setdest 118310 29590 3.0" 
$ns at 624.9082744922906 "$node_(573) setdest 33071 6680 5.0" 
$ns at 658.9001410832657 "$node_(573) setdest 104480 15156 11.0" 
$ns at 747.3947926341763 "$node_(573) setdest 8237 4120 7.0" 
$ns at 816.5959952583839 "$node_(573) setdest 110880 22906 3.0" 
$ns at 862.9231953755848 "$node_(573) setdest 11999 39775 19.0" 
$ns at 503.698824704441 "$node_(574) setdest 35301 23037 5.0" 
$ns at 554.8683314993007 "$node_(574) setdest 42651 8679 8.0" 
$ns at 622.2541653228492 "$node_(574) setdest 39802 3303 10.0" 
$ns at 679.208528530481 "$node_(574) setdest 130 33973 18.0" 
$ns at 854.5609448666164 "$node_(574) setdest 58842 13479 14.0" 
$ns at 538.5456026542741 "$node_(575) setdest 14836 12288 11.0" 
$ns at 622.9184076098261 "$node_(575) setdest 57556 31579 11.0" 
$ns at 701.0541564175276 "$node_(575) setdest 117302 26526 17.0" 
$ns at 803.428886041927 "$node_(575) setdest 94220 5102 16.0" 
$ns at 863.2209605076049 "$node_(575) setdest 81887 36505 8.0" 
$ns at 536.580271548953 "$node_(576) setdest 57001 26891 14.0" 
$ns at 677.3183438693886 "$node_(576) setdest 70707 29310 6.0" 
$ns at 757.3133433068047 "$node_(576) setdest 84661 38864 17.0" 
$ns at 874.3021392434198 "$node_(576) setdest 105383 26071 20.0" 
$ns at 566.2524513258782 "$node_(577) setdest 76261 18623 2.0" 
$ns at 607.0146032842273 "$node_(577) setdest 19974 14596 15.0" 
$ns at 650.6441548250639 "$node_(577) setdest 64941 16360 17.0" 
$ns at 698.7875032958787 "$node_(577) setdest 39386 42286 9.0" 
$ns at 738.5577697110216 "$node_(577) setdest 61442 42221 1.0" 
$ns at 770.5541540996994 "$node_(577) setdest 70503 20063 8.0" 
$ns at 876.7660408465144 "$node_(577) setdest 43654 39359 17.0" 
$ns at 522.908994076193 "$node_(578) setdest 109051 29607 8.0" 
$ns at 598.6851629844739 "$node_(578) setdest 3130 36013 1.0" 
$ns at 638.5816970904764 "$node_(578) setdest 43800 43082 20.0" 
$ns at 746.6216266243159 "$node_(578) setdest 11154 7987 6.0" 
$ns at 814.1449287727711 "$node_(578) setdest 62242 10156 3.0" 
$ns at 871.0534949258911 "$node_(578) setdest 762 44598 1.0" 
$ns at 603.1134226235165 "$node_(579) setdest 46801 12550 5.0" 
$ns at 651.1352172651431 "$node_(579) setdest 105029 31813 12.0" 
$ns at 774.811208874396 "$node_(579) setdest 104112 24552 17.0" 
$ns at 513.472236947059 "$node_(580) setdest 78844 30332 2.0" 
$ns at 562.9873309690719 "$node_(580) setdest 70566 16510 1.0" 
$ns at 601.186758917613 "$node_(580) setdest 37668 12917 15.0" 
$ns at 780.7311786919532 "$node_(580) setdest 122882 19451 1.0" 
$ns at 814.378076274119 "$node_(580) setdest 46897 32361 2.0" 
$ns at 857.5185293111297 "$node_(580) setdest 5240 19537 12.0" 
$ns at 585.7839375596883 "$node_(581) setdest 50777 9916 17.0" 
$ns at 664.6361241799151 "$node_(581) setdest 74568 17796 7.0" 
$ns at 748.0630476006277 "$node_(581) setdest 100097 3864 13.0" 
$ns at 525.1846356114552 "$node_(582) setdest 91656 15525 12.0" 
$ns at 666.7458241907079 "$node_(582) setdest 80457 7565 5.0" 
$ns at 701.2611792990139 "$node_(582) setdest 128595 42610 10.0" 
$ns at 807.7370367097833 "$node_(582) setdest 88434 41879 16.0" 
$ns at 527.7317221264861 "$node_(583) setdest 104116 32874 20.0" 
$ns at 574.9747696214661 "$node_(583) setdest 30244 30875 12.0" 
$ns at 667.2740828750264 "$node_(583) setdest 107558 43229 5.0" 
$ns at 723.7434030928973 "$node_(583) setdest 47958 12552 7.0" 
$ns at 817.8073553498527 "$node_(583) setdest 59395 10943 13.0" 
$ns at 506.7566595471008 "$node_(584) setdest 109228 4947 15.0" 
$ns at 608.3009890653512 "$node_(584) setdest 61572 41723 18.0" 
$ns at 771.8236619447463 "$node_(584) setdest 26584 11658 14.0" 
$ns at 886.0286900759146 "$node_(584) setdest 91875 32042 15.0" 
$ns at 607.908047387043 "$node_(585) setdest 2252 6444 9.0" 
$ns at 670.5757395377601 "$node_(585) setdest 39946 41865 9.0" 
$ns at 732.7091918263001 "$node_(585) setdest 119499 38349 8.0" 
$ns at 764.7546261520222 "$node_(585) setdest 130701 2042 11.0" 
$ns at 888.6661693843434 "$node_(585) setdest 92336 40022 15.0" 
$ns at 566.2050981630186 "$node_(586) setdest 98198 6969 2.0" 
$ns at 611.5566712915704 "$node_(586) setdest 18057 20789 1.0" 
$ns at 648.3896371891938 "$node_(586) setdest 101233 33131 9.0" 
$ns at 716.3947675534813 "$node_(586) setdest 122180 22017 6.0" 
$ns at 801.0475436247633 "$node_(586) setdest 119378 1886 10.0" 
$ns at 651.8767620352999 "$node_(587) setdest 75993 34959 14.0" 
$ns at 744.9453290808785 "$node_(587) setdest 121801 32225 11.0" 
$ns at 825.6584039290697 "$node_(587) setdest 126330 29544 16.0" 
$ns at 507.10183359494135 "$node_(588) setdest 81357 37814 13.0" 
$ns at 636.3857123773072 "$node_(588) setdest 34082 12307 14.0" 
$ns at 760.866400899316 "$node_(588) setdest 80659 27430 6.0" 
$ns at 846.6674370179823 "$node_(588) setdest 77918 27181 16.0" 
$ns at 553.4070012004639 "$node_(589) setdest 66414 12618 10.0" 
$ns at 634.4604753767134 "$node_(589) setdest 40162 9910 5.0" 
$ns at 675.6475571156059 "$node_(589) setdest 67695 40794 19.0" 
$ns at 752.4197272269652 "$node_(589) setdest 116725 37660 9.0" 
$ns at 812.4845644249364 "$node_(589) setdest 50597 19772 16.0" 
$ns at 582.3660528527479 "$node_(590) setdest 97570 19012 15.0" 
$ns at 728.4905338086662 "$node_(590) setdest 42915 38182 11.0" 
$ns at 857.2280529899723 "$node_(590) setdest 104913 21282 3.0" 
$ns at 890.7596366157555 "$node_(590) setdest 65288 4431 18.0" 
$ns at 545.7750491734987 "$node_(591) setdest 5721 17221 18.0" 
$ns at 616.0651047919278 "$node_(591) setdest 90265 5792 4.0" 
$ns at 651.1669806604623 "$node_(591) setdest 44537 11938 8.0" 
$ns at 735.9769736188284 "$node_(591) setdest 20987 33302 1.0" 
$ns at 766.5075127471465 "$node_(591) setdest 42154 34618 8.0" 
$ns at 808.3251887762527 "$node_(591) setdest 131763 34684 18.0" 
$ns at 608.2451541623069 "$node_(592) setdest 50023 25087 4.0" 
$ns at 657.3007431953907 "$node_(592) setdest 52087 2775 12.0" 
$ns at 719.2983025452442 "$node_(592) setdest 9073 26963 19.0" 
$ns at 832.3164571937741 "$node_(592) setdest 94470 28457 6.0" 
$ns at 516.5851905816961 "$node_(593) setdest 79643 21170 18.0" 
$ns at 672.377102249945 "$node_(593) setdest 3090 36880 1.0" 
$ns at 707.1797692534909 "$node_(593) setdest 131626 31453 20.0" 
$ns at 869.2762603490363 "$node_(593) setdest 130600 33947 12.0" 
$ns at 507.60440864701326 "$node_(594) setdest 36695 25859 20.0" 
$ns at 544.2272374432891 "$node_(594) setdest 114748 24196 5.0" 
$ns at 584.1333422372647 "$node_(594) setdest 94232 24387 9.0" 
$ns at 699.6904126342872 "$node_(594) setdest 52741 4959 2.0" 
$ns at 731.5525629723857 "$node_(594) setdest 64078 44005 18.0" 
$ns at 524.9885553622303 "$node_(595) setdest 3043 14451 13.0" 
$ns at 650.3945858103189 "$node_(595) setdest 118655 14350 3.0" 
$ns at 692.9333227732542 "$node_(595) setdest 31991 41871 3.0" 
$ns at 746.185630860576 "$node_(595) setdest 125950 26695 13.0" 
$ns at 778.2342349867167 "$node_(595) setdest 12668 12216 10.0" 
$ns at 875.1832918621292 "$node_(595) setdest 44199 8531 2.0" 
$ns at 603.0638432912199 "$node_(596) setdest 97101 30098 19.0" 
$ns at 745.4896238260544 "$node_(596) setdest 59365 21177 16.0" 
$ns at 808.9421401068997 "$node_(596) setdest 10773 17208 1.0" 
$ns at 840.4722369382788 "$node_(596) setdest 79526 33517 6.0" 
$ns at 879.5940346937382 "$node_(596) setdest 8038 27446 9.0" 
$ns at 536.3115918480728 "$node_(597) setdest 127663 5171 5.0" 
$ns at 574.0604465587087 "$node_(597) setdest 59980 21460 5.0" 
$ns at 610.2590566282418 "$node_(597) setdest 19334 4326 14.0" 
$ns at 690.7695337411327 "$node_(597) setdest 70880 17108 10.0" 
$ns at 811.551994849963 "$node_(597) setdest 84437 22376 10.0" 
$ns at 850.9750402966065 "$node_(597) setdest 90864 11797 17.0" 
$ns at 510.59909823653004 "$node_(598) setdest 56783 29360 1.0" 
$ns at 549.7351849828082 "$node_(598) setdest 18486 16542 5.0" 
$ns at 583.2599022307866 "$node_(598) setdest 107266 28342 18.0" 
$ns at 752.5637410260991 "$node_(598) setdest 71956 29752 8.0" 
$ns at 800.9804892222006 "$node_(598) setdest 23226 12317 13.0" 
$ns at 896.1485871039248 "$node_(598) setdest 109869 24659 16.0" 
$ns at 535.2478135672322 "$node_(599) setdest 79931 42239 3.0" 
$ns at 579.0968596444774 "$node_(599) setdest 86579 13436 8.0" 
$ns at 628.4699605519747 "$node_(599) setdest 31952 41641 10.0" 
$ns at 748.5412878291959 "$node_(599) setdest 56683 9849 3.0" 
$ns at 800.6245852805082 "$node_(599) setdest 109281 23560 11.0" 
$ns at 849.8997462598371 "$node_(599) setdest 28904 15639 15.0" 
$ns at 602.7929791972167 "$node_(600) setdest 120830 42006 11.0" 
$ns at 637.0911501187924 "$node_(600) setdest 59024 7143 3.0" 
$ns at 682.9942537050447 "$node_(600) setdest 75132 44247 14.0" 
$ns at 736.8879756410591 "$node_(600) setdest 16974 17517 9.0" 
$ns at 793.2219530918584 "$node_(600) setdest 132892 31233 7.0" 
$ns at 882.9094766407214 "$node_(600) setdest 18318 18589 1.0" 
$ns at 663.6128405516756 "$node_(601) setdest 18258 12192 5.0" 
$ns at 738.1626542812717 "$node_(601) setdest 83693 12738 16.0" 
$ns at 870.4408482276142 "$node_(601) setdest 36198 37685 14.0" 
$ns at 661.2620023939103 "$node_(602) setdest 30634 4235 15.0" 
$ns at 753.8721940949767 "$node_(602) setdest 88010 37543 20.0" 
$ns at 839.1654849944513 "$node_(602) setdest 61297 3391 2.0" 
$ns at 870.7538795801273 "$node_(602) setdest 11002 36610 11.0" 
$ns at 634.1903648989055 "$node_(603) setdest 21448 34671 14.0" 
$ns at 770.9984618238761 "$node_(603) setdest 75293 440 2.0" 
$ns at 817.3465396108624 "$node_(603) setdest 127751 9372 5.0" 
$ns at 849.8715400651872 "$node_(603) setdest 29847 10054 1.0" 
$ns at 889.6791895438741 "$node_(603) setdest 39852 22944 1.0" 
$ns at 684.5466357836143 "$node_(604) setdest 83832 13330 16.0" 
$ns at 748.419327097053 "$node_(604) setdest 14137 2234 10.0" 
$ns at 845.5151287416137 "$node_(604) setdest 3526 4534 3.0" 
$ns at 886.0810126231756 "$node_(604) setdest 90429 37348 6.0" 
$ns at 610.6087411853372 "$node_(605) setdest 12690 40953 8.0" 
$ns at 708.7830944208365 "$node_(605) setdest 25911 20165 13.0" 
$ns at 758.0413014529978 "$node_(605) setdest 83828 44479 15.0" 
$ns at 856.3307114559755 "$node_(605) setdest 83081 26080 4.0" 
$ns at 676.4614235977854 "$node_(606) setdest 94385 17654 9.0" 
$ns at 776.8303162617548 "$node_(606) setdest 86930 40254 13.0" 
$ns at 837.6044168703249 "$node_(606) setdest 122915 24585 19.0" 
$ns at 782.6570707878344 "$node_(607) setdest 12395 16603 3.0" 
$ns at 840.4779155441859 "$node_(607) setdest 98290 21968 2.0" 
$ns at 871.0080001660489 "$node_(607) setdest 131280 33909 12.0" 
$ns at 614.990907596275 "$node_(608) setdest 114251 6412 15.0" 
$ns at 750.1884340315526 "$node_(608) setdest 48912 14038 14.0" 
$ns at 897.5083050698427 "$node_(608) setdest 123242 41270 9.0" 
$ns at 649.2125285403175 "$node_(609) setdest 20465 12785 3.0" 
$ns at 696.3641229583516 "$node_(609) setdest 14694 44434 20.0" 
$ns at 811.8136381368412 "$node_(609) setdest 48528 9253 4.0" 
$ns at 877.2395284489489 "$node_(609) setdest 97809 38800 1.0" 
$ns at 624.7098538827528 "$node_(610) setdest 45527 12502 1.0" 
$ns at 658.157182078666 "$node_(610) setdest 87878 43581 4.0" 
$ns at 699.3660276651622 "$node_(610) setdest 55227 41070 15.0" 
$ns at 794.8004107002912 "$node_(610) setdest 99118 32131 5.0" 
$ns at 868.7207138480231 "$node_(610) setdest 43060 36985 19.0" 
$ns at 608.3479870866532 "$node_(611) setdest 62458 13719 15.0" 
$ns at 779.6696205142174 "$node_(611) setdest 61296 21365 2.0" 
$ns at 828.9764988479747 "$node_(611) setdest 1122 3302 13.0" 
$ns at 881.6766593594033 "$node_(611) setdest 83297 26290 1.0" 
$ns at 628.731059918656 "$node_(612) setdest 48868 9695 12.0" 
$ns at 679.2041928157148 "$node_(612) setdest 114144 30913 4.0" 
$ns at 732.301831506695 "$node_(612) setdest 34231 26345 16.0" 
$ns at 633.6409346576102 "$node_(613) setdest 73353 14870 15.0" 
$ns at 738.3725533560406 "$node_(613) setdest 120688 16320 20.0" 
$ns at 834.4286778918492 "$node_(613) setdest 59255 15102 20.0" 
$ns at 628.7664208718359 "$node_(614) setdest 35061 40906 14.0" 
$ns at 789.1074727811441 "$node_(614) setdest 72325 39899 19.0" 
$ns at 833.1068894473285 "$node_(614) setdest 131112 36610 5.0" 
$ns at 867.9109601533314 "$node_(614) setdest 99483 1618 5.0" 
$ns at 615.8766216577519 "$node_(615) setdest 89657 42393 20.0" 
$ns at 763.234726926996 "$node_(615) setdest 72891 33329 6.0" 
$ns at 810.3057561450274 "$node_(615) setdest 29460 22012 13.0" 
$ns at 640.3145836668624 "$node_(616) setdest 3639 39869 19.0" 
$ns at 847.2640143795797 "$node_(616) setdest 37006 15670 8.0" 
$ns at 617.2571829203594 "$node_(617) setdest 96063 5080 12.0" 
$ns at 744.1513540869134 "$node_(617) setdest 112620 23415 18.0" 
$ns at 855.690114737188 "$node_(617) setdest 44295 18360 8.0" 
$ns at 603.0715897565469 "$node_(618) setdest 104339 31477 15.0" 
$ns at 689.3958605342423 "$node_(618) setdest 80599 31214 19.0" 
$ns at 729.1529562032229 "$node_(618) setdest 117865 12105 13.0" 
$ns at 855.5201392076051 "$node_(618) setdest 88992 13556 7.0" 
$ns at 668.7721260337014 "$node_(619) setdest 26493 20712 12.0" 
$ns at 805.6415431929016 "$node_(619) setdest 63924 3024 7.0" 
$ns at 881.5201001596907 "$node_(619) setdest 38221 18832 9.0" 
$ns at 648.4317911087718 "$node_(620) setdest 110804 22073 13.0" 
$ns at 688.4070069718803 "$node_(620) setdest 34829 5213 4.0" 
$ns at 756.4872414684196 "$node_(620) setdest 130229 40701 10.0" 
$ns at 828.6714083379954 "$node_(620) setdest 93562 7256 1.0" 
$ns at 860.2220110117865 "$node_(620) setdest 114744 38166 19.0" 
$ns at 623.3063555382511 "$node_(621) setdest 23521 11928 12.0" 
$ns at 661.9416753867645 "$node_(621) setdest 121095 21485 13.0" 
$ns at 794.0826476770263 "$node_(621) setdest 7501 30906 8.0" 
$ns at 839.089026609406 "$node_(621) setdest 73173 20641 11.0" 
$ns at 633.2092002020158 "$node_(622) setdest 6983 41580 3.0" 
$ns at 677.6932200615609 "$node_(622) setdest 56414 29168 1.0" 
$ns at 707.7852667344686 "$node_(622) setdest 55605 15315 6.0" 
$ns at 791.9437715577931 "$node_(622) setdest 116949 38672 2.0" 
$ns at 835.0257891972617 "$node_(622) setdest 81753 14839 5.0" 
$ns at 882.7191890579983 "$node_(622) setdest 109869 22095 9.0" 
$ns at 623.9922720461741 "$node_(623) setdest 41438 8339 6.0" 
$ns at 687.2647378537215 "$node_(623) setdest 18658 37330 15.0" 
$ns at 827.9609464295738 "$node_(623) setdest 23283 15447 4.0" 
$ns at 874.8397755840683 "$node_(623) setdest 79994 20712 1.0" 
$ns at 736.5266619720045 "$node_(624) setdest 45121 38979 7.0" 
$ns at 806.5720937968013 "$node_(624) setdest 124364 13749 1.0" 
$ns at 844.4900339762187 "$node_(624) setdest 119476 11186 14.0" 
$ns at 688.1843266921309 "$node_(625) setdest 29983 26482 13.0" 
$ns at 764.8825864364892 "$node_(625) setdest 63805 38100 14.0" 
$ns at 806.5624056580294 "$node_(625) setdest 60287 5942 5.0" 
$ns at 850.0831429101712 "$node_(625) setdest 11885 32944 15.0" 
$ns at 609.488412496333 "$node_(626) setdest 50351 17925 3.0" 
$ns at 656.717595703517 "$node_(626) setdest 23713 37737 20.0" 
$ns at 733.0092851566001 "$node_(626) setdest 119558 13996 9.0" 
$ns at 774.8580119447937 "$node_(626) setdest 10412 44672 17.0" 
$ns at 842.5267253130887 "$node_(626) setdest 88151 7154 11.0" 
$ns at 640.4811695175181 "$node_(627) setdest 22538 25601 19.0" 
$ns at 763.8275078432539 "$node_(627) setdest 31007 3496 19.0" 
$ns at 823.0873191091946 "$node_(627) setdest 86084 25532 8.0" 
$ns at 853.0910621331193 "$node_(627) setdest 116572 36138 14.0" 
$ns at 601.8273944337109 "$node_(628) setdest 121746 35789 15.0" 
$ns at 705.7489123046215 "$node_(628) setdest 90958 32199 1.0" 
$ns at 739.4430615532922 "$node_(628) setdest 33143 43177 3.0" 
$ns at 779.5290685991379 "$node_(628) setdest 63270 30147 16.0" 
$ns at 867.582351835983 "$node_(628) setdest 119210 29658 20.0" 
$ns at 637.781673214702 "$node_(629) setdest 67597 5957 14.0" 
$ns at 686.2854349863542 "$node_(629) setdest 72744 33571 9.0" 
$ns at 741.1036372054093 "$node_(629) setdest 64306 14473 9.0" 
$ns at 844.8752408872523 "$node_(629) setdest 99606 28142 1.0" 
$ns at 881.1969378967069 "$node_(629) setdest 106697 8033 20.0" 
$ns at 651.986134485028 "$node_(630) setdest 104042 42495 18.0" 
$ns at 728.4541954439668 "$node_(630) setdest 28764 34113 3.0" 
$ns at 763.4684864893013 "$node_(630) setdest 128688 40477 8.0" 
$ns at 803.250574725472 "$node_(630) setdest 69256 21842 9.0" 
$ns at 834.8945715771353 "$node_(630) setdest 89894 32633 13.0" 
$ns at 750.5921822730461 "$node_(631) setdest 113566 38422 11.0" 
$ns at 862.4086162349922 "$node_(631) setdest 85270 31584 20.0" 
$ns at 678.5885187027901 "$node_(632) setdest 81530 31978 13.0" 
$ns at 774.3611113502719 "$node_(632) setdest 110984 22641 9.0" 
$ns at 811.1894230108089 "$node_(632) setdest 21036 5560 8.0" 
$ns at 890.9722728527433 "$node_(632) setdest 15260 23650 12.0" 
$ns at 740.3550705364676 "$node_(633) setdest 22865 8920 5.0" 
$ns at 781.0836125694597 "$node_(633) setdest 66961 5709 14.0" 
$ns at 857.5470097377686 "$node_(633) setdest 94725 27235 13.0" 
$ns at 632.3606956182401 "$node_(634) setdest 70398 7252 9.0" 
$ns at 688.346732491421 "$node_(634) setdest 21288 40955 3.0" 
$ns at 746.948222400076 "$node_(634) setdest 130764 10522 12.0" 
$ns at 797.0606826435613 "$node_(634) setdest 30288 24736 4.0" 
$ns at 863.683726039427 "$node_(634) setdest 12396 8062 15.0" 
$ns at 712.0120079908163 "$node_(635) setdest 104809 6857 17.0" 
$ns at 807.7007297203656 "$node_(636) setdest 44942 14856 5.0" 
$ns at 870.5287049337329 "$node_(636) setdest 102406 37061 18.0" 
$ns at 634.1516188429159 "$node_(637) setdest 129087 4401 2.0" 
$ns at 664.3272154195283 "$node_(637) setdest 122313 29314 15.0" 
$ns at 823.6710055922546 "$node_(637) setdest 47544 40373 1.0" 
$ns at 863.0032115809232 "$node_(637) setdest 36086 41664 8.0" 
$ns at 621.2964718613667 "$node_(638) setdest 130308 40894 16.0" 
$ns at 665.1582022420826 "$node_(638) setdest 112089 41347 8.0" 
$ns at 759.763108269033 "$node_(638) setdest 55150 16159 9.0" 
$ns at 841.2109340171748 "$node_(638) setdest 48075 19661 7.0" 
$ns at 877.1915998147131 "$node_(638) setdest 89012 32176 8.0" 
$ns at 695.585536757467 "$node_(639) setdest 7383 24059 14.0" 
$ns at 825.1652368665723 "$node_(639) setdest 28251 9647 2.0" 
$ns at 873.6779158806439 "$node_(639) setdest 28971 38336 18.0" 
$ns at 610.7511068982568 "$node_(640) setdest 114553 37344 5.0" 
$ns at 686.8018727355364 "$node_(640) setdest 113170 30648 10.0" 
$ns at 750.682579827823 "$node_(640) setdest 23350 42749 6.0" 
$ns at 804.2329533203301 "$node_(640) setdest 121447 10546 1.0" 
$ns at 838.6264059525511 "$node_(640) setdest 19459 32739 1.0" 
$ns at 878.6040824086713 "$node_(640) setdest 58941 21221 13.0" 
$ns at 606.4082704673706 "$node_(641) setdest 61171 19874 15.0" 
$ns at 694.090183933484 "$node_(641) setdest 1861 15466 11.0" 
$ns at 729.2938092252981 "$node_(641) setdest 131339 5277 8.0" 
$ns at 824.7367095150763 "$node_(641) setdest 73371 42396 10.0" 
$ns at 878.6755056779231 "$node_(641) setdest 32618 36866 2.0" 
$ns at 612.3360841767575 "$node_(642) setdest 71477 39825 1.0" 
$ns at 644.3279518831815 "$node_(642) setdest 62321 28764 6.0" 
$ns at 726.433572270116 "$node_(642) setdest 131271 35707 19.0" 
$ns at 809.2837261924329 "$node_(642) setdest 88927 23344 2.0" 
$ns at 853.3551898068338 "$node_(642) setdest 73849 33567 14.0" 
$ns at 665.5306384242183 "$node_(643) setdest 66736 19777 2.0" 
$ns at 702.5586149444974 "$node_(643) setdest 128333 30809 15.0" 
$ns at 738.1344608510387 "$node_(643) setdest 61841 12688 19.0" 
$ns at 887.3772697232375 "$node_(643) setdest 59663 24638 15.0" 
$ns at 679.0361254523167 "$node_(644) setdest 40753 19197 16.0" 
$ns at 773.0511740969223 "$node_(644) setdest 34871 32130 1.0" 
$ns at 808.7519648010905 "$node_(644) setdest 53561 3345 14.0" 
$ns at 622.2940370776195 "$node_(645) setdest 57178 21695 6.0" 
$ns at 692.2649849576485 "$node_(645) setdest 12958 25638 3.0" 
$ns at 740.240078874964 "$node_(645) setdest 72961 2550 6.0" 
$ns at 779.1103148437708 "$node_(645) setdest 84901 13084 11.0" 
$ns at 818.0360190794185 "$node_(645) setdest 45480 6882 12.0" 
$ns at 895.0426618262891 "$node_(645) setdest 115671 19882 5.0" 
$ns at 615.0015472141077 "$node_(646) setdest 11943 2119 19.0" 
$ns at 663.0463923090472 "$node_(646) setdest 61913 4076 20.0" 
$ns at 696.8371499903591 "$node_(646) setdest 120807 4338 1.0" 
$ns at 732.6618330891015 "$node_(646) setdest 97785 9549 8.0" 
$ns at 803.4871610616383 "$node_(646) setdest 111828 17691 1.0" 
$ns at 836.1383661249386 "$node_(646) setdest 128340 33042 3.0" 
$ns at 886.8149718186609 "$node_(646) setdest 105649 30656 12.0" 
$ns at 667.3122613422461 "$node_(647) setdest 51352 19686 11.0" 
$ns at 740.8316133996361 "$node_(647) setdest 90070 44109 10.0" 
$ns at 801.6697488895549 "$node_(647) setdest 92998 34574 5.0" 
$ns at 861.1420118078381 "$node_(647) setdest 130952 4920 16.0" 
$ns at 653.6018179207172 "$node_(648) setdest 32549 15843 10.0" 
$ns at 765.7464245289345 "$node_(648) setdest 113494 9178 1.0" 
$ns at 804.1081423663339 "$node_(648) setdest 75878 4253 5.0" 
$ns at 873.6012822939826 "$node_(648) setdest 125573 36791 10.0" 
$ns at 601.4327051523377 "$node_(649) setdest 9871 42197 2.0" 
$ns at 639.5737033932803 "$node_(649) setdest 102143 34571 3.0" 
$ns at 686.9365251300574 "$node_(649) setdest 55098 25596 10.0" 
$ns at 764.8093787671648 "$node_(649) setdest 120468 11000 4.0" 
$ns at 812.1739012080532 "$node_(649) setdest 35059 42979 11.0" 
$ns at 624.1513519188873 "$node_(650) setdest 125743 19200 3.0" 
$ns at 658.5981860206307 "$node_(650) setdest 92221 43244 3.0" 
$ns at 699.5050463025106 "$node_(650) setdest 104231 30273 17.0" 
$ns at 832.0479148968716 "$node_(650) setdest 5256 25151 18.0" 
$ns at 722.6467678001538 "$node_(651) setdest 45763 37734 5.0" 
$ns at 800.531734926875 "$node_(651) setdest 69700 35255 11.0" 
$ns at 624.0675304649885 "$node_(652) setdest 83639 19636 11.0" 
$ns at 703.2305137078835 "$node_(652) setdest 76221 42346 8.0" 
$ns at 738.2890977702575 "$node_(652) setdest 38753 26171 18.0" 
$ns at 819.5617841680573 "$node_(652) setdest 72457 39494 19.0" 
$ns at 616.6415971029137 "$node_(653) setdest 68539 19633 3.0" 
$ns at 674.5166805685471 "$node_(653) setdest 34585 1072 16.0" 
$ns at 716.4736660047992 "$node_(653) setdest 67440 37048 4.0" 
$ns at 749.4504531521469 "$node_(653) setdest 61263 13134 3.0" 
$ns at 791.7319668793106 "$node_(653) setdest 17528 43246 8.0" 
$ns at 876.7784898680475 "$node_(653) setdest 58752 8557 10.0" 
$ns at 687.142064134641 "$node_(654) setdest 98642 31612 7.0" 
$ns at 757.2622591573066 "$node_(654) setdest 38199 22705 5.0" 
$ns at 796.5415703264321 "$node_(654) setdest 19376 27618 9.0" 
$ns at 609.4162672869355 "$node_(655) setdest 121247 25781 6.0" 
$ns at 652.7085166131392 "$node_(655) setdest 41746 15071 3.0" 
$ns at 702.1324728506025 "$node_(655) setdest 57346 7361 11.0" 
$ns at 799.2601412549586 "$node_(655) setdest 55507 30448 10.0" 
$ns at 848.4830141139113 "$node_(655) setdest 60727 29291 4.0" 
$ns at 893.3755121167337 "$node_(655) setdest 108258 18814 5.0" 
$ns at 704.3235513988194 "$node_(656) setdest 93537 15088 16.0" 
$ns at 751.8418906051716 "$node_(656) setdest 123338 4025 2.0" 
$ns at 785.8064678314119 "$node_(656) setdest 66226 39471 15.0" 
$ns at 893.8361988934581 "$node_(656) setdest 62157 2753 4.0" 
$ns at 608.6034914639303 "$node_(657) setdest 118915 40440 6.0" 
$ns at 671.4053782246598 "$node_(657) setdest 76042 40187 10.0" 
$ns at 799.8677533204904 "$node_(657) setdest 61213 761 10.0" 
$ns at 614.2345193126719 "$node_(658) setdest 60010 32703 7.0" 
$ns at 696.2877210830429 "$node_(658) setdest 59774 1559 9.0" 
$ns at 785.6516478851888 "$node_(658) setdest 66157 36330 15.0" 
$ns at 639.3939780440903 "$node_(659) setdest 133658 7478 5.0" 
$ns at 706.236567121837 "$node_(659) setdest 7795 13083 10.0" 
$ns at 797.673451118088 "$node_(659) setdest 7589 7871 9.0" 
$ns at 863.375090799092 "$node_(659) setdest 90348 37955 6.0" 
$ns at 671.6546046425206 "$node_(660) setdest 46372 3082 16.0" 
$ns at 706.2815690028992 "$node_(660) setdest 17524 20087 11.0" 
$ns at 818.4525831104507 "$node_(660) setdest 16997 22810 2.0" 
$ns at 848.6592197223958 "$node_(660) setdest 57646 24376 18.0" 
$ns at 714.8042860263398 "$node_(661) setdest 87391 17503 8.0" 
$ns at 800.0346593347607 "$node_(661) setdest 123811 40895 6.0" 
$ns at 852.8246755186376 "$node_(661) setdest 37388 9896 18.0" 
$ns at 687.4169441485086 "$node_(662) setdest 107367 35268 10.0" 
$ns at 732.4451674693001 "$node_(662) setdest 32957 27076 11.0" 
$ns at 851.8188923262293 "$node_(662) setdest 89642 32967 19.0" 
$ns at 654.149326143565 "$node_(663) setdest 70111 34764 8.0" 
$ns at 690.2725149839918 "$node_(663) setdest 21449 32994 13.0" 
$ns at 730.9008934222231 "$node_(663) setdest 133645 3872 15.0" 
$ns at 801.3651957696375 "$node_(663) setdest 22179 35895 8.0" 
$ns at 898.2297375886835 "$node_(663) setdest 43690 29423 11.0" 
$ns at 634.3778897896744 "$node_(664) setdest 90170 26117 7.0" 
$ns at 730.2768086067424 "$node_(664) setdest 131227 40864 10.0" 
$ns at 775.1500112479749 "$node_(664) setdest 126098 13464 9.0" 
$ns at 870.2433044308375 "$node_(664) setdest 130881 20372 19.0" 
$ns at 626.7607143219482 "$node_(665) setdest 36918 7515 11.0" 
$ns at 668.6909995650939 "$node_(665) setdest 20347 30414 8.0" 
$ns at 753.004406250712 "$node_(665) setdest 12092 40498 19.0" 
$ns at 733.6091736102774 "$node_(666) setdest 66411 21928 17.0" 
$ns at 840.3694481709533 "$node_(666) setdest 89371 1575 19.0" 
$ns at 658.0198263604059 "$node_(667) setdest 29239 15801 6.0" 
$ns at 719.7481421580263 "$node_(667) setdest 74339 36297 17.0" 
$ns at 752.8231014214646 "$node_(667) setdest 95147 44590 14.0" 
$ns at 840.379683147552 "$node_(667) setdest 19183 3346 15.0" 
$ns at 880.3026106903817 "$node_(667) setdest 128976 34654 11.0" 
$ns at 678.1146536914734 "$node_(668) setdest 83785 11584 4.0" 
$ns at 719.3015524525987 "$node_(668) setdest 23027 43412 10.0" 
$ns at 804.4765784805696 "$node_(668) setdest 86765 43070 6.0" 
$ns at 859.8947493235863 "$node_(668) setdest 84940 9108 8.0" 
$ns at 671.397710572933 "$node_(669) setdest 79878 22788 18.0" 
$ns at 732.2058043647048 "$node_(669) setdest 113163 25954 18.0" 
$ns at 893.29822265302 "$node_(669) setdest 98704 33522 3.0" 
$ns at 624.0270543654099 "$node_(670) setdest 93731 34491 2.0" 
$ns at 673.6063002675405 "$node_(670) setdest 50160 25451 17.0" 
$ns at 710.2092859565163 "$node_(670) setdest 3123 35681 5.0" 
$ns at 769.6079428507319 "$node_(670) setdest 35596 8970 16.0" 
$ns at 854.1754095234722 "$node_(670) setdest 87718 35915 10.0" 
$ns at 641.0145889533746 "$node_(671) setdest 119879 1066 6.0" 
$ns at 685.1152883034183 "$node_(671) setdest 123829 13231 11.0" 
$ns at 797.6420766127012 "$node_(671) setdest 81038 10792 18.0" 
$ns at 603.9635605818293 "$node_(672) setdest 93601 5136 20.0" 
$ns at 770.4624125785251 "$node_(672) setdest 102311 6391 19.0" 
$ns at 838.1992736646141 "$node_(672) setdest 36623 11231 4.0" 
$ns at 877.0421840441916 "$node_(672) setdest 82467 19044 18.0" 
$ns at 603.1837942361489 "$node_(673) setdest 90912 37768 18.0" 
$ns at 789.9398915634806 "$node_(673) setdest 89652 20483 2.0" 
$ns at 826.1811715197458 "$node_(673) setdest 57765 13433 10.0" 
$ns at 611.7963169601359 "$node_(674) setdest 34319 16033 2.0" 
$ns at 651.3266129862523 "$node_(674) setdest 56613 38143 14.0" 
$ns at 759.2169804336145 "$node_(674) setdest 116015 19369 15.0" 
$ns at 893.0233308036748 "$node_(674) setdest 22977 37865 17.0" 
$ns at 600.6795515706441 "$node_(675) setdest 119623 17585 4.0" 
$ns at 668.9331333508208 "$node_(675) setdest 113754 38515 1.0" 
$ns at 706.4466031213533 "$node_(675) setdest 121288 5578 18.0" 
$ns at 742.3481247446618 "$node_(675) setdest 41736 19489 18.0" 
$ns at 898.9142808951187 "$node_(675) setdest 132042 29617 14.0" 
$ns at 732.6875289800926 "$node_(676) setdest 58383 40873 1.0" 
$ns at 769.9238147799416 "$node_(676) setdest 123137 3480 6.0" 
$ns at 800.6908646492899 "$node_(676) setdest 86668 36169 20.0" 
$ns at 674.0648776376593 "$node_(677) setdest 32350 28136 7.0" 
$ns at 750.6313152599427 "$node_(677) setdest 124487 14070 17.0" 
$ns at 609.8244480464891 "$node_(678) setdest 127916 13735 7.0" 
$ns at 649.4323353301285 "$node_(678) setdest 99363 3826 6.0" 
$ns at 718.3557074139948 "$node_(678) setdest 52041 30880 8.0" 
$ns at 768.7164201734367 "$node_(678) setdest 102701 5711 11.0" 
$ns at 821.3792568868603 "$node_(678) setdest 113124 39382 18.0" 
$ns at 669.7328228445581 "$node_(679) setdest 30002 31418 7.0" 
$ns at 710.5459969727332 "$node_(679) setdest 124551 28361 17.0" 
$ns at 742.711165865908 "$node_(679) setdest 32732 5205 7.0" 
$ns at 799.0897828123587 "$node_(679) setdest 27339 24804 17.0" 
$ns at 839.5853178121886 "$node_(679) setdest 123573 38962 19.0" 
$ns at 624.859561021362 "$node_(680) setdest 58300 41158 17.0" 
$ns at 659.3340677225301 "$node_(680) setdest 50708 38673 11.0" 
$ns at 727.095378978312 "$node_(680) setdest 25298 15630 13.0" 
$ns at 847.1563773716606 "$node_(680) setdest 17167 8264 17.0" 
$ns at 891.1988079871942 "$node_(680) setdest 103509 30255 10.0" 
$ns at 707.5943012015102 "$node_(681) setdest 129941 36181 7.0" 
$ns at 744.6551084875525 "$node_(681) setdest 57715 35603 10.0" 
$ns at 830.6020288175207 "$node_(681) setdest 69206 33956 12.0" 
$ns at 707.1410527700955 "$node_(682) setdest 15949 29614 15.0" 
$ns at 760.4435656572701 "$node_(682) setdest 37495 34101 9.0" 
$ns at 842.3874896177435 "$node_(682) setdest 47108 41819 17.0" 
$ns at 692.3038536928651 "$node_(683) setdest 47942 4248 17.0" 
$ns at 849.5149529566665 "$node_(683) setdest 119636 5673 2.0" 
$ns at 897.8173278373765 "$node_(683) setdest 108368 43945 6.0" 
$ns at 672.3415872419007 "$node_(684) setdest 110711 37908 2.0" 
$ns at 704.0603499806892 "$node_(684) setdest 98229 42904 14.0" 
$ns at 784.4327346632964 "$node_(684) setdest 45754 35140 3.0" 
$ns at 822.2241053108164 "$node_(684) setdest 132159 21924 1.0" 
$ns at 858.7334142042065 "$node_(684) setdest 79420 44072 3.0" 
$ns at 622.0167674647881 "$node_(685) setdest 116929 22976 5.0" 
$ns at 701.7759498177946 "$node_(685) setdest 34141 22353 6.0" 
$ns at 742.9101793051485 "$node_(685) setdest 56334 33411 14.0" 
$ns at 890.6297666422946 "$node_(685) setdest 81809 2716 9.0" 
$ns at 652.7185233012516 "$node_(686) setdest 114149 44578 1.0" 
$ns at 692.2593916838252 "$node_(686) setdest 3162 35486 1.0" 
$ns at 731.9045264231221 "$node_(686) setdest 46364 19061 19.0" 
$ns at 611.5373579981815 "$node_(687) setdest 55044 7474 9.0" 
$ns at 710.7184879265054 "$node_(687) setdest 134106 3051 16.0" 
$ns at 787.941484763689 "$node_(687) setdest 130520 40304 15.0" 
$ns at 824.7492343549461 "$node_(687) setdest 119008 40427 12.0" 
$ns at 861.2236246568939 "$node_(687) setdest 50781 13892 3.0" 
$ns at 626.2736959024971 "$node_(688) setdest 19617 4301 6.0" 
$ns at 665.2765256822987 "$node_(688) setdest 40639 32534 20.0" 
$ns at 755.2238410371194 "$node_(688) setdest 22621 27965 9.0" 
$ns at 810.8778108184567 "$node_(688) setdest 17728 4670 5.0" 
$ns at 866.1594068281534 "$node_(688) setdest 68872 12063 20.0" 
$ns at 762.7449665664252 "$node_(689) setdest 125113 3856 6.0" 
$ns at 795.029009126925 "$node_(689) setdest 79315 30972 9.0" 
$ns at 843.7314544360088 "$node_(689) setdest 122770 16945 19.0" 
$ns at 617.4754838260978 "$node_(690) setdest 122882 32880 9.0" 
$ns at 716.6413877866707 "$node_(690) setdest 22742 15656 2.0" 
$ns at 757.2369458281356 "$node_(690) setdest 7153 2935 19.0" 
$ns at 644.5719114623287 "$node_(691) setdest 100818 5424 10.0" 
$ns at 724.9938755204378 "$node_(691) setdest 57642 15110 6.0" 
$ns at 803.3375816624812 "$node_(691) setdest 89829 16044 11.0" 
$ns at 867.6174075774921 "$node_(691) setdest 48271 12331 10.0" 
$ns at 606.8647090940938 "$node_(692) setdest 87734 24890 10.0" 
$ns at 670.404491367423 "$node_(692) setdest 93427 10831 19.0" 
$ns at 807.4718061767055 "$node_(692) setdest 52506 28470 17.0" 
$ns at 600.1929928354891 "$node_(693) setdest 124154 7875 9.0" 
$ns at 649.8228678380159 "$node_(693) setdest 117188 27532 11.0" 
$ns at 688.7844371673814 "$node_(693) setdest 50892 43115 9.0" 
$ns at 770.7431972369429 "$node_(693) setdest 61213 1270 7.0" 
$ns at 810.8683660317835 "$node_(693) setdest 45866 5376 8.0" 
$ns at 637.4756376838012 "$node_(694) setdest 130296 3761 7.0" 
$ns at 677.8234842861281 "$node_(694) setdest 101975 17693 6.0" 
$ns at 715.9840152885099 "$node_(694) setdest 66936 35114 11.0" 
$ns at 848.7256333284042 "$node_(694) setdest 51377 5231 5.0" 
$ns at 643.1202676921991 "$node_(695) setdest 93542 33715 4.0" 
$ns at 694.6122601594859 "$node_(695) setdest 108090 26835 4.0" 
$ns at 757.402990709933 "$node_(695) setdest 12806 15780 9.0" 
$ns at 851.6584461123625 "$node_(695) setdest 29610 2852 10.0" 
$ns at 642.7039855704716 "$node_(696) setdest 119560 40810 13.0" 
$ns at 754.119071226786 "$node_(696) setdest 96874 9206 5.0" 
$ns at 822.5158360078125 "$node_(696) setdest 96317 2076 14.0" 
$ns at 613.677463248038 "$node_(697) setdest 126076 19390 10.0" 
$ns at 716.9747981876934 "$node_(697) setdest 2988 13457 9.0" 
$ns at 807.1348150116362 "$node_(697) setdest 82589 31471 10.0" 
$ns at 852.8099414724574 "$node_(697) setdest 120160 13784 5.0" 
$ns at 714.9047042815023 "$node_(698) setdest 97543 6252 2.0" 
$ns at 763.7471146739151 "$node_(698) setdest 54098 28717 11.0" 
$ns at 896.3248444365754 "$node_(698) setdest 87007 20497 16.0" 
$ns at 614.9988587940354 "$node_(699) setdest 36179 35376 19.0" 
$ns at 662.8829477879751 "$node_(699) setdest 133923 29028 18.0" 
$ns at 740.1834090901995 "$node_(699) setdest 22457 21724 10.0" 
$ns at 793.0617071640823 "$node_(699) setdest 109528 8318 1.0" 
$ns at 825.0592206829664 "$node_(699) setdest 42568 32125 14.0" 
$ns at 745.1411196871634 "$node_(700) setdest 59357 7526 6.0" 
$ns at 798.7831619688598 "$node_(700) setdest 116912 42024 8.0" 
$ns at 861.2167651130687 "$node_(700) setdest 97053 29325 1.0" 
$ns at 895.100480111316 "$node_(700) setdest 46299 21907 12.0" 
$ns at 708.7453477613113 "$node_(701) setdest 116499 20992 2.0" 
$ns at 756.3021527889035 "$node_(701) setdest 64736 29125 10.0" 
$ns at 799.2622910679014 "$node_(701) setdest 122177 2915 5.0" 
$ns at 830.9261578397192 "$node_(701) setdest 83853 9387 5.0" 
$ns at 864.1633095990757 "$node_(701) setdest 113152 14962 5.0" 
$ns at 755.4992019076965 "$node_(702) setdest 119730 5436 12.0" 
$ns at 843.1043849963991 "$node_(702) setdest 6164 32315 15.0" 
$ns at 747.9597879750165 "$node_(703) setdest 90441 8617 12.0" 
$ns at 804.0398584859901 "$node_(703) setdest 54203 4934 11.0" 
$ns at 717.1178306631523 "$node_(704) setdest 29721 25387 12.0" 
$ns at 757.1699566666194 "$node_(704) setdest 111927 3212 6.0" 
$ns at 840.4824671450408 "$node_(704) setdest 8917 21663 14.0" 
$ns at 877.0179640240208 "$node_(704) setdest 83047 11246 15.0" 
$ns at 821.8942082846474 "$node_(705) setdest 86719 18398 11.0" 
$ns at 880.3479489715705 "$node_(705) setdest 27826 44659 8.0" 
$ns at 713.7288816561711 "$node_(706) setdest 36416 2400 5.0" 
$ns at 791.3638389946093 "$node_(706) setdest 101067 30854 19.0" 
$ns at 829.5426271689516 "$node_(706) setdest 66448 17189 17.0" 
$ns at 892.8182019306527 "$node_(706) setdest 103622 43212 20.0" 
$ns at 827.0646190538747 "$node_(707) setdest 77600 11745 1.0" 
$ns at 862.1977153816365 "$node_(707) setdest 47600 35218 3.0" 
$ns at 898.4655391077695 "$node_(707) setdest 90500 18849 11.0" 
$ns at 764.1480071121423 "$node_(708) setdest 102542 14445 12.0" 
$ns at 805.1583202089702 "$node_(708) setdest 94454 40317 8.0" 
$ns at 805.3249714836466 "$node_(709) setdest 61263 10766 5.0" 
$ns at 883.382465916539 "$node_(709) setdest 10012 1944 19.0" 
$ns at 734.2624512031239 "$node_(710) setdest 56514 27342 9.0" 
$ns at 798.3494596604731 "$node_(710) setdest 124488 11076 18.0" 
$ns at 880.6715535890274 "$node_(710) setdest 32516 13808 8.0" 
$ns at 704.668927263205 "$node_(711) setdest 41494 41749 20.0" 
$ns at 824.771120171086 "$node_(711) setdest 7434 5917 16.0" 
$ns at 777.20514299044 "$node_(712) setdest 109004 4448 19.0" 
$ns at 810.5504269152801 "$node_(712) setdest 113041 39687 19.0" 
$ns at 878.5386130296758 "$node_(712) setdest 49321 33081 15.0" 
$ns at 714.5750029889435 "$node_(713) setdest 126365 38500 4.0" 
$ns at 761.747798046558 "$node_(713) setdest 48245 40821 14.0" 
$ns at 843.8039121406148 "$node_(713) setdest 54127 30356 5.0" 
$ns at 791.0149569448979 "$node_(714) setdest 9625 19851 18.0" 
$ns at 783.5765743061556 "$node_(715) setdest 90902 5675 18.0" 
$ns at 769.3964343482673 "$node_(716) setdest 68492 32700 10.0" 
$ns at 871.4781119209688 "$node_(716) setdest 79083 26861 1.0" 
$ns at 712.0748700603895 "$node_(717) setdest 41730 30226 2.0" 
$ns at 749.5046526185895 "$node_(717) setdest 16709 10933 14.0" 
$ns at 819.3775173499974 "$node_(717) setdest 60424 20596 14.0" 
$ns at 772.189486245456 "$node_(718) setdest 21943 3037 8.0" 
$ns at 847.5088061811628 "$node_(718) setdest 37630 44450 1.0" 
$ns at 881.1208693745749 "$node_(718) setdest 60634 43896 15.0" 
$ns at 729.5117106297462 "$node_(719) setdest 61133 8436 18.0" 
$ns at 783.0924549549654 "$node_(719) setdest 115289 20314 4.0" 
$ns at 821.3453210164029 "$node_(719) setdest 76608 20975 1.0" 
$ns at 854.8309033045979 "$node_(719) setdest 112358 9748 3.0" 
$ns at 890.7892081385289 "$node_(719) setdest 124252 8996 1.0" 
$ns at 813.1435061123409 "$node_(720) setdest 72789 28530 12.0" 
$ns at 896.5032978659608 "$node_(720) setdest 108629 43354 16.0" 
$ns at 726.3310915041596 "$node_(721) setdest 64862 3303 1.0" 
$ns at 759.4731226478234 "$node_(721) setdest 121378 26476 2.0" 
$ns at 795.9019522828081 "$node_(721) setdest 111298 16765 20.0" 
$ns at 734.9808920833277 "$node_(722) setdest 85493 34435 19.0" 
$ns at 827.0586783906112 "$node_(722) setdest 132404 10452 3.0" 
$ns at 860.8098535409279 "$node_(722) setdest 62783 23507 12.0" 
$ns at 703.466217504173 "$node_(723) setdest 72456 29986 1.0" 
$ns at 742.9298141430312 "$node_(723) setdest 119745 26857 16.0" 
$ns at 763.5584251961551 "$node_(724) setdest 60312 4010 16.0" 
$ns at 718.1520539591234 "$node_(725) setdest 68687 29779 4.0" 
$ns at 780.3272005331423 "$node_(725) setdest 27878 8146 7.0" 
$ns at 832.0959628910863 "$node_(725) setdest 38262 7102 16.0" 
$ns at 721.397381193096 "$node_(726) setdest 97475 25999 1.0" 
$ns at 757.4752825504642 "$node_(726) setdest 49273 3024 1.0" 
$ns at 791.6299801394813 "$node_(726) setdest 120441 23525 12.0" 
$ns at 776.0420487233708 "$node_(727) setdest 4702 29601 19.0" 
$ns at 839.9362339082825 "$node_(728) setdest 15260 32791 3.0" 
$ns at 882.9563501845806 "$node_(728) setdest 45411 25428 19.0" 
$ns at 730.9783171052633 "$node_(729) setdest 54009 2393 6.0" 
$ns at 788.0075153610663 "$node_(729) setdest 128429 26867 10.0" 
$ns at 850.4075874713461 "$node_(729) setdest 46414 20154 10.0" 
$ns at 720.6368425073897 "$node_(730) setdest 42455 2743 5.0" 
$ns at 799.500164858271 "$node_(730) setdest 78847 21231 20.0" 
$ns at 708.4400865221353 "$node_(731) setdest 64036 5150 15.0" 
$ns at 803.8938280273304 "$node_(731) setdest 23046 29155 3.0" 
$ns at 837.9878214729669 "$node_(731) setdest 27348 20053 15.0" 
$ns at 716.3600171034243 "$node_(732) setdest 72496 16523 14.0" 
$ns at 834.6462661914549 "$node_(732) setdest 25609 39439 14.0" 
$ns at 888.6597858071875 "$node_(732) setdest 36935 23263 19.0" 
$ns at 713.4117838964139 "$node_(733) setdest 68145 38406 12.0" 
$ns at 807.4630176342735 "$node_(733) setdest 54821 3239 9.0" 
$ns at 851.4467893708791 "$node_(733) setdest 74596 3762 16.0" 
$ns at 771.7372631196345 "$node_(734) setdest 72716 27037 17.0" 
$ns at 733.5520512009965 "$node_(735) setdest 46941 29644 7.0" 
$ns at 799.8241755568553 "$node_(735) setdest 134134 9592 12.0" 
$ns at 891.9815488363322 "$node_(735) setdest 71631 21800 19.0" 
$ns at 740.1504136020751 "$node_(736) setdest 46771 766 3.0" 
$ns at 771.8929150760574 "$node_(736) setdest 110350 15716 6.0" 
$ns at 859.7700364257526 "$node_(736) setdest 129575 43678 13.0" 
$ns at 706.7522380699098 "$node_(737) setdest 97885 43132 17.0" 
$ns at 786.3063135734612 "$node_(737) setdest 45041 3292 1.0" 
$ns at 819.1079674442778 "$node_(737) setdest 58113 16227 12.0" 
$ns at 727.9906245811335 "$node_(738) setdest 12712 42633 17.0" 
$ns at 773.1310969834199 "$node_(738) setdest 70650 23456 14.0" 
$ns at 741.3253816573634 "$node_(739) setdest 59756 16689 11.0" 
$ns at 868.6250936441123 "$node_(739) setdest 63933 41629 16.0" 
$ns at 739.5801934767255 "$node_(740) setdest 64478 13097 8.0" 
$ns at 832.5829638711144 "$node_(740) setdest 26272 27964 3.0" 
$ns at 886.6895378544419 "$node_(740) setdest 97824 23311 19.0" 
$ns at 764.9809739368986 "$node_(741) setdest 19886 3703 4.0" 
$ns at 819.6934203773533 "$node_(741) setdest 96799 9675 7.0" 
$ns at 859.132191025659 "$node_(741) setdest 60952 27185 17.0" 
$ns at 757.0603410625848 "$node_(742) setdest 9269 17779 7.0" 
$ns at 839.4658311560005 "$node_(742) setdest 59868 42221 1.0" 
$ns at 878.177618089869 "$node_(742) setdest 47375 43379 6.0" 
$ns at 702.8895783990055 "$node_(743) setdest 19001 34929 17.0" 
$ns at 770.334674050069 "$node_(743) setdest 74557 19887 1.0" 
$ns at 804.5910883711351 "$node_(743) setdest 66770 42339 9.0" 
$ns at 850.7861958935663 "$node_(743) setdest 8666 535 3.0" 
$ns at 847.1828434619104 "$node_(744) setdest 80862 7908 1.0" 
$ns at 885.2690832777927 "$node_(744) setdest 110760 27403 9.0" 
$ns at 755.5063070181455 "$node_(745) setdest 126221 32810 14.0" 
$ns at 804.0372524406827 "$node_(745) setdest 245 43576 12.0" 
$ns at 805.624526821727 "$node_(746) setdest 45737 3045 14.0" 
$ns at 855.9502278396905 "$node_(746) setdest 63711 40346 17.0" 
$ns at 736.5050760786488 "$node_(747) setdest 112893 27170 5.0" 
$ns at 788.6618902477126 "$node_(747) setdest 43784 687 10.0" 
$ns at 834.3602930854869 "$node_(747) setdest 42549 12233 14.0" 
$ns at 715.6849902747723 "$node_(748) setdest 76104 17395 7.0" 
$ns at 773.3598893703693 "$node_(748) setdest 44796 8007 20.0" 
$ns at 836.7627400083268 "$node_(748) setdest 106199 27035 13.0" 
$ns at 801.3283082524861 "$node_(749) setdest 110183 31143 4.0" 
$ns at 860.1784042553571 "$node_(749) setdest 5806 27320 1.0" 
$ns at 899.4227075452551 "$node_(749) setdest 107436 16084 1.0" 
$ns at 815.6596397360722 "$node_(750) setdest 72784 35607 6.0" 
$ns at 847.3374904555201 "$node_(750) setdest 103752 39041 12.0" 
$ns at 710.437523101345 "$node_(751) setdest 4451 36641 12.0" 
$ns at 834.7868373127916 "$node_(751) setdest 72010 8396 9.0" 
$ns at 773.6384577125264 "$node_(752) setdest 105861 27303 14.0" 
$ns at 710.9847870663441 "$node_(753) setdest 5065 1778 15.0" 
$ns at 755.285114626494 "$node_(753) setdest 8559 33206 2.0" 
$ns at 786.4138405455686 "$node_(753) setdest 88656 23695 16.0" 
$ns at 886.2992321480816 "$node_(753) setdest 69345 4869 3.0" 
$ns at 734.0507519277432 "$node_(754) setdest 41470 32614 16.0" 
$ns at 776.0528357185206 "$node_(754) setdest 18309 9806 12.0" 
$ns at 762.7551700205105 "$node_(755) setdest 28852 37519 4.0" 
$ns at 828.0222870932287 "$node_(755) setdest 103948 39393 12.0" 
$ns at 710.6429076247442 "$node_(756) setdest 36099 29142 16.0" 
$ns at 775.351459477193 "$node_(756) setdest 76360 5041 17.0" 
$ns at 717.1778489904254 "$node_(757) setdest 62288 21191 1.0" 
$ns at 751.7061591128643 "$node_(757) setdest 104732 4466 2.0" 
$ns at 790.892056831566 "$node_(757) setdest 28395 5149 1.0" 
$ns at 823.0917243432305 "$node_(757) setdest 130032 35941 10.0" 
$ns at 860.4289488743478 "$node_(757) setdest 16379 16834 7.0" 
$ns at 705.5271744598479 "$node_(758) setdest 104363 14491 13.0" 
$ns at 746.3816827579933 "$node_(758) setdest 62154 4276 19.0" 
$ns at 833.6419228752685 "$node_(758) setdest 108276 27750 10.0" 
$ns at 875.3276629796604 "$node_(758) setdest 123799 31760 16.0" 
$ns at 763.6179172135834 "$node_(759) setdest 32473 13127 3.0" 
$ns at 800.4840269081719 "$node_(759) setdest 95856 8541 8.0" 
$ns at 887.3642992405915 "$node_(759) setdest 35331 28678 12.0" 
$ns at 728.4767445232237 "$node_(760) setdest 22880 9985 19.0" 
$ns at 772.2722152008446 "$node_(761) setdest 62965 44101 18.0" 
$ns at 708.0828487254911 "$node_(762) setdest 7310 26559 13.0" 
$ns at 761.2754144871882 "$node_(762) setdest 2305 27869 3.0" 
$ns at 809.5193441453386 "$node_(762) setdest 14760 39299 4.0" 
$ns at 876.2487522505896 "$node_(762) setdest 96267 26774 7.0" 
$ns at 749.7362516316009 "$node_(763) setdest 126534 28575 14.0" 
$ns at 820.2308018873405 "$node_(763) setdest 132312 33738 14.0" 
$ns at 754.6502487136222 "$node_(764) setdest 77013 4493 12.0" 
$ns at 753.0788533399765 "$node_(765) setdest 95079 38327 10.0" 
$ns at 879.3700505854525 "$node_(765) setdest 82835 2187 13.0" 
$ns at 715.0322830442536 "$node_(766) setdest 25127 657 9.0" 
$ns at 803.042330381133 "$node_(766) setdest 14721 42395 1.0" 
$ns at 842.6280620539407 "$node_(766) setdest 9350 8660 12.0" 
$ns at 716.3406979485898 "$node_(767) setdest 48997 3974 17.0" 
$ns at 757.4567547201434 "$node_(767) setdest 81760 5352 13.0" 
$ns at 819.8269331594893 "$node_(768) setdest 28242 1405 16.0" 
$ns at 718.0718317724443 "$node_(769) setdest 61348 24342 12.0" 
$ns at 803.4450612795724 "$node_(769) setdest 133891 37078 12.0" 
$ns at 858.8530945125808 "$node_(769) setdest 2908 7171 20.0" 
$ns at 701.7019471372029 "$node_(770) setdest 34322 29582 4.0" 
$ns at 759.3542791218536 "$node_(770) setdest 57979 33783 16.0" 
$ns at 721.011834846686 "$node_(771) setdest 72093 40659 16.0" 
$ns at 816.9598152751495 "$node_(771) setdest 67132 44694 11.0" 
$ns at 714.759697768017 "$node_(772) setdest 127116 18088 12.0" 
$ns at 756.03124650623 "$node_(772) setdest 123656 4944 5.0" 
$ns at 797.1752073606783 "$node_(772) setdest 124411 10613 13.0" 
$ns at 829.7870751528429 "$node_(772) setdest 92596 20546 4.0" 
$ns at 886.9575525485424 "$node_(772) setdest 35353 35587 13.0" 
$ns at 878.3484561671189 "$node_(773) setdest 54345 42990 11.0" 
$ns at 793.8040554523157 "$node_(774) setdest 78257 43881 19.0" 
$ns at 759.6287662516561 "$node_(775) setdest 7113 38502 3.0" 
$ns at 810.1403766837918 "$node_(775) setdest 9995 41169 1.0" 
$ns at 849.0670401203039 "$node_(775) setdest 31618 2953 3.0" 
$ns at 772.2308770160537 "$node_(776) setdest 5835 34616 2.0" 
$ns at 816.5059724004303 "$node_(776) setdest 18033 35912 14.0" 
$ns at 877.6237349242318 "$node_(776) setdest 61878 21355 7.0" 
$ns at 710.0113582967664 "$node_(777) setdest 107677 22732 6.0" 
$ns at 745.4552568306136 "$node_(777) setdest 74725 5733 3.0" 
$ns at 796.8556879396382 "$node_(777) setdest 67851 13776 6.0" 
$ns at 829.4046030535179 "$node_(777) setdest 72929 20942 14.0" 
$ns at 769.0752140993476 "$node_(778) setdest 129389 43769 6.0" 
$ns at 810.767461252234 "$node_(778) setdest 10229 24751 1.0" 
$ns at 849.9841557035543 "$node_(778) setdest 72148 22989 19.0" 
$ns at 892.8511925424026 "$node_(778) setdest 95559 21281 17.0" 
$ns at 729.0839253406338 "$node_(779) setdest 76008 38530 8.0" 
$ns at 790.1383279814437 "$node_(779) setdest 96255 12453 12.0" 
$ns at 778.5483965567985 "$node_(780) setdest 18568 15237 10.0" 
$ns at 703.5433876385657 "$node_(781) setdest 91231 21766 12.0" 
$ns at 746.0828239853568 "$node_(781) setdest 64230 25333 1.0" 
$ns at 776.2251779957808 "$node_(781) setdest 67039 42268 17.0" 
$ns at 765.6203639666329 "$node_(782) setdest 5161 8680 16.0" 
$ns at 736.5972803028974 "$node_(783) setdest 84349 29051 8.0" 
$ns at 834.9880437267021 "$node_(783) setdest 11594 44560 12.0" 
$ns at 719.5574252844186 "$node_(784) setdest 118227 621 13.0" 
$ns at 816.7397571386817 "$node_(784) setdest 82550 16580 14.0" 
$ns at 872.0897795210332 "$node_(784) setdest 4615 17184 5.0" 
$ns at 712.3788119764132 "$node_(785) setdest 13705 39273 11.0" 
$ns at 799.5079148815003 "$node_(785) setdest 68912 11846 11.0" 
$ns at 739.0581685409528 "$node_(786) setdest 113443 3571 11.0" 
$ns at 865.8738865559717 "$node_(786) setdest 132204 28201 11.0" 
$ns at 716.8153971448013 "$node_(787) setdest 58766 19011 9.0" 
$ns at 781.2010339441937 "$node_(787) setdest 86352 13820 16.0" 
$ns at 757.0174602496395 "$node_(788) setdest 22843 32569 9.0" 
$ns at 850.5364027483733 "$node_(788) setdest 64472 25799 19.0" 
$ns at 740.9106883380473 "$node_(789) setdest 91885 7718 2.0" 
$ns at 778.2625409504009 "$node_(789) setdest 106829 36888 5.0" 
$ns at 811.4110867826819 "$node_(789) setdest 47323 18226 2.0" 
$ns at 861.3528292527703 "$node_(789) setdest 45744 33016 10.0" 
$ns at 731.2989674013577 "$node_(790) setdest 84178 12900 3.0" 
$ns at 771.4503904228734 "$node_(790) setdest 34781 7412 17.0" 
$ns at 760.4791062612151 "$node_(791) setdest 58631 27286 1.0" 
$ns at 798.0548479406654 "$node_(791) setdest 11621 35002 9.0" 
$ns at 814.123497893687 "$node_(792) setdest 117733 4589 8.0" 
$ns at 877.0293740690441 "$node_(792) setdest 95423 1386 12.0" 
$ns at 782.0279791302119 "$node_(793) setdest 61106 35077 19.0" 
$ns at 855.6962119051897 "$node_(793) setdest 95095 2701 9.0" 
$ns at 757.232686861193 "$node_(794) setdest 90090 41363 5.0" 
$ns at 797.2743326756233 "$node_(794) setdest 11913 36746 19.0" 
$ns at 840.2638888183171 "$node_(794) setdest 93168 29691 13.0" 
$ns at 793.0199676274033 "$node_(795) setdest 52 21616 17.0" 
$ns at 726.201107072256 "$node_(796) setdest 21025 43384 10.0" 
$ns at 809.9260815620262 "$node_(796) setdest 9606 247 20.0" 
$ns at 812.7658111103012 "$node_(797) setdest 62605 4889 18.0" 
$ns at 827.3046421098738 "$node_(798) setdest 77826 40489 16.0" 
$ns at 700.6416156668056 "$node_(799) setdest 60340 17494 4.0" 
$ns at 733.4681873707387 "$node_(799) setdest 42395 9182 10.0" 
$ns at 771.5985019295508 "$node_(799) setdest 81394 32566 10.0" 
$ns at 868.5944863985069 "$node_(799) setdest 93020 34053 8.0" 


#Set a TCP connection between node_(92) and node_(40)
set tcp_(0) [new Agent/TCP/Newreno]
$tcp_(0) set class_ 2
set sink_(0) [new Agent/TCPSink]
$ns attach-agent $node_(92) $tcp_(0)
$ns attach-agent $node_(40) $sink_(0)
$ns connect $tcp_(0) $sink_(0)
set ftp_(0) [new Application/FTP]
$ftp_(0) attach-agent $tcp_(0)
$ns at 0.2 "$ftp_(0) start"
$ns at 180.0 "$ftp_(0) stop"

#Set a TCP connection between node_(68) and node_(59)
set tcp_(1) [new Agent/TCP/Newreno]
$tcp_(1) set class_ 2
set sink_(1) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(1)
$ns attach-agent $node_(59) $sink_(1)
$ns connect $tcp_(1) $sink_(1)
set ftp_(1) [new Application/FTP]
$ftp_(1) attach-agent $tcp_(1)
$ns at 180.2 "$ftp_(1) start"
$ns at 360.0 "$ftp_(1) stop"

#Set a TCP connection between node_(79) and node_(33)
set tcp_(2) [new Agent/TCP/Newreno]
$tcp_(2) set class_ 2
set sink_(2) [new Agent/TCPSink]
$ns attach-agent $node_(79) $tcp_(2)
$ns attach-agent $node_(33) $sink_(2)
$ns connect $tcp_(2) $sink_(2)
set ftp_(2) [new Application/FTP]
$ftp_(2) attach-agent $tcp_(2)
$ns at 360.2 "$ftp_(2) start"
$ns at 540.0 "$ftp_(2) stop"

#Set a TCP connection between node_(52) and node_(9)
set tcp_(3) [new Agent/TCP/Newreno]
$tcp_(3) set class_ 2
set sink_(3) [new Agent/TCPSink]
$ns attach-agent $node_(52) $tcp_(3)
$ns attach-agent $node_(9) $sink_(3)
$ns connect $tcp_(3) $sink_(3)
set ftp_(3) [new Application/FTP]
$ftp_(3) attach-agent $tcp_(3)
$ns at 540.2 "$ftp_(3) start"
$ns at 720.0 "$ftp_(3) stop"

#Set a TCP connection between node_(1) and node_(68)
set tcp_(4) [new Agent/TCP/Newreno]
$tcp_(4) set class_ 2
set sink_(4) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(4)
$ns attach-agent $node_(68) $sink_(4)
$ns connect $tcp_(4) $sink_(4)
set ftp_(4) [new Application/FTP]
$ftp_(4) attach-agent $tcp_(4)
$ns at 720.2 "$ftp_(4) start"
$ns at 900.0 "$ftp_(4) stop"

#Set a TCP connection between node_(89) and node_(92)
set tcp_(5) [new Agent/TCP/Newreno]
$tcp_(5) set class_ 2
set sink_(5) [new Agent/TCPSink]
$ns attach-agent $node_(89) $tcp_(5)
$ns attach-agent $node_(92) $sink_(5)
$ns connect $tcp_(5) $sink_(5)
set ftp_(5) [new Application/FTP]
$ftp_(5) attach-agent $tcp_(5)
$ns at 0.2 "$ftp_(5) start"
$ns at 180.0 "$ftp_(5) stop"

#Set a TCP connection between node_(11) and node_(56)
set tcp_(6) [new Agent/TCP/Newreno]
$tcp_(6) set class_ 2
set sink_(6) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(6)
$ns attach-agent $node_(56) $sink_(6)
$ns connect $tcp_(6) $sink_(6)
set ftp_(6) [new Application/FTP]
$ftp_(6) attach-agent $tcp_(6)
$ns at 180.2 "$ftp_(6) start"
$ns at 360.0 "$ftp_(6) stop"

#Set a TCP connection between node_(82) and node_(16)
set tcp_(7) [new Agent/TCP/Newreno]
$tcp_(7) set class_ 2
set sink_(7) [new Agent/TCPSink]
$ns attach-agent $node_(82) $tcp_(7)
$ns attach-agent $node_(16) $sink_(7)
$ns connect $tcp_(7) $sink_(7)
set ftp_(7) [new Application/FTP]
$ftp_(7) attach-agent $tcp_(7)
$ns at 360.2 "$ftp_(7) start"
$ns at 540.0 "$ftp_(7) stop"

#Set a TCP connection between node_(88) and node_(4)
set tcp_(8) [new Agent/TCP/Newreno]
$tcp_(8) set class_ 2
set sink_(8) [new Agent/TCPSink]
$ns attach-agent $node_(88) $tcp_(8)
$ns attach-agent $node_(4) $sink_(8)
$ns connect $tcp_(8) $sink_(8)
set ftp_(8) [new Application/FTP]
$ftp_(8) attach-agent $tcp_(8)
$ns at 540.2 "$ftp_(8) start"
$ns at 720.0 "$ftp_(8) stop"

#Set a TCP connection between node_(90) and node_(40)
set tcp_(9) [new Agent/TCP/Newreno]
$tcp_(9) set class_ 2
set sink_(9) [new Agent/TCPSink]
$ns attach-agent $node_(90) $tcp_(9)
$ns attach-agent $node_(40) $sink_(9)
$ns connect $tcp_(9) $sink_(9)
set ftp_(9) [new Application/FTP]
$ftp_(9) attach-agent $tcp_(9)
$ns at 720.2 "$ftp_(9) start"
$ns at 900.0 "$ftp_(9) stop"

#Set a TCP connection between node_(53) and node_(25)
set tcp_(10) [new Agent/TCP/Newreno]
$tcp_(10) set class_ 2
set sink_(10) [new Agent/TCPSink]
$ns attach-agent $node_(53) $tcp_(10)
$ns attach-agent $node_(25) $sink_(10)
$ns connect $tcp_(10) $sink_(10)
set ftp_(10) [new Application/FTP]
$ftp_(10) attach-agent $tcp_(10)
$ns at 0.2 "$ftp_(10) start"
$ns at 180.0 "$ftp_(10) stop"

#Set a TCP connection between node_(86) and node_(76)
set tcp_(11) [new Agent/TCP/Newreno]
$tcp_(11) set class_ 2
set sink_(11) [new Agent/TCPSink]
$ns attach-agent $node_(86) $tcp_(11)
$ns attach-agent $node_(76) $sink_(11)
$ns connect $tcp_(11) $sink_(11)
set ftp_(11) [new Application/FTP]
$ftp_(11) attach-agent $tcp_(11)
$ns at 180.2 "$ftp_(11) start"
$ns at 360.0 "$ftp_(11) stop"

#Set a TCP connection between node_(81) and node_(77)
set tcp_(12) [new Agent/TCP/Newreno]
$tcp_(12) set class_ 2
set sink_(12) [new Agent/TCPSink]
$ns attach-agent $node_(81) $tcp_(12)
$ns attach-agent $node_(77) $sink_(12)
$ns connect $tcp_(12) $sink_(12)
set ftp_(12) [new Application/FTP]
$ftp_(12) attach-agent $tcp_(12)
$ns at 360.2 "$ftp_(12) start"
$ns at 540.0 "$ftp_(12) stop"

#Set a TCP connection between node_(25) and node_(26)
set tcp_(13) [new Agent/TCP/Newreno]
$tcp_(13) set class_ 2
set sink_(13) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(13)
$ns attach-agent $node_(26) $sink_(13)
$ns connect $tcp_(13) $sink_(13)
set ftp_(13) [new Application/FTP]
$ftp_(13) attach-agent $tcp_(13)
$ns at 540.2 "$ftp_(13) start"
$ns at 720.0 "$ftp_(13) stop"

#Set a TCP connection between node_(10) and node_(20)
set tcp_(14) [new Agent/TCP/Newreno]
$tcp_(14) set class_ 2
set sink_(14) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(14)
$ns attach-agent $node_(20) $sink_(14)
$ns connect $tcp_(14) $sink_(14)
set ftp_(14) [new Application/FTP]
$ftp_(14) attach-agent $tcp_(14)
$ns at 720.2 "$ftp_(14) start"
$ns at 900.0 "$ftp_(14) stop"

#Set a TCP connection between node_(80) and node_(99)
set tcp_(15) [new Agent/TCP/Newreno]
$tcp_(15) set class_ 2
set sink_(15) [new Agent/TCPSink]
$ns attach-agent $node_(80) $tcp_(15)
$ns attach-agent $node_(99) $sink_(15)
$ns connect $tcp_(15) $sink_(15)
set ftp_(15) [new Application/FTP]
$ftp_(15) attach-agent $tcp_(15)
$ns at 0.2 "$ftp_(15) start"
$ns at 180.0 "$ftp_(15) stop"

#Set a TCP connection between node_(96) and node_(5)
set tcp_(16) [new Agent/TCP/Newreno]
$tcp_(16) set class_ 2
set sink_(16) [new Agent/TCPSink]
$ns attach-agent $node_(96) $tcp_(16)
$ns attach-agent $node_(5) $sink_(16)
$ns connect $tcp_(16) $sink_(16)
set ftp_(16) [new Application/FTP]
$ftp_(16) attach-agent $tcp_(16)
$ns at 180.2 "$ftp_(16) start"
$ns at 360.0 "$ftp_(16) stop"

#Set a TCP connection between node_(98) and node_(82)
set tcp_(17) [new Agent/TCP/Newreno]
$tcp_(17) set class_ 2
set sink_(17) [new Agent/TCPSink]
$ns attach-agent $node_(98) $tcp_(17)
$ns attach-agent $node_(82) $sink_(17)
$ns connect $tcp_(17) $sink_(17)
set ftp_(17) [new Application/FTP]
$ftp_(17) attach-agent $tcp_(17)
$ns at 360.2 "$ftp_(17) start"
$ns at 540.0 "$ftp_(17) stop"

#Set a TCP connection between node_(98) and node_(1)
set tcp_(18) [new Agent/TCP/Newreno]
$tcp_(18) set class_ 2
set sink_(18) [new Agent/TCPSink]
$ns attach-agent $node_(98) $tcp_(18)
$ns attach-agent $node_(1) $sink_(18)
$ns connect $tcp_(18) $sink_(18)
set ftp_(18) [new Application/FTP]
$ftp_(18) attach-agent $tcp_(18)
$ns at 540.2 "$ftp_(18) start"
$ns at 720.0 "$ftp_(18) stop"

#Set a TCP connection between node_(91) and node_(43)
set tcp_(19) [new Agent/TCP/Newreno]
$tcp_(19) set class_ 2
set sink_(19) [new Agent/TCPSink]
$ns attach-agent $node_(91) $tcp_(19)
$ns attach-agent $node_(43) $sink_(19)
$ns connect $tcp_(19) $sink_(19)
set ftp_(19) [new Application/FTP]
$ftp_(19) attach-agent $tcp_(19)
$ns at 720.2 "$ftp_(19) start"
$ns at 900.0 "$ftp_(19) stop"

#Set a TCP connection between node_(2) and node_(89)
set tcp_(20) [new Agent/TCP/Newreno]
$tcp_(20) set class_ 2
set sink_(20) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(20)
$ns attach-agent $node_(89) $sink_(20)
$ns connect $tcp_(20) $sink_(20)
set ftp_(20) [new Application/FTP]
$ftp_(20) attach-agent $tcp_(20)
$ns at 0.2 "$ftp_(20) start"
$ns at 180.0 "$ftp_(20) stop"

#Set a TCP connection between node_(66) and node_(76)
set tcp_(21) [new Agent/TCP/Newreno]
$tcp_(21) set class_ 2
set sink_(21) [new Agent/TCPSink]
$ns attach-agent $node_(66) $tcp_(21)
$ns attach-agent $node_(76) $sink_(21)
$ns connect $tcp_(21) $sink_(21)
set ftp_(21) [new Application/FTP]
$ftp_(21) attach-agent $tcp_(21)
$ns at 180.2 "$ftp_(21) start"
$ns at 360.0 "$ftp_(21) stop"

#Set a TCP connection between node_(76) and node_(26)
set tcp_(22) [new Agent/TCP/Newreno]
$tcp_(22) set class_ 2
set sink_(22) [new Agent/TCPSink]
$ns attach-agent $node_(76) $tcp_(22)
$ns attach-agent $node_(26) $sink_(22)
$ns connect $tcp_(22) $sink_(22)
set ftp_(22) [new Application/FTP]
$ftp_(22) attach-agent $tcp_(22)
$ns at 360.2 "$ftp_(22) start"
$ns at 540.0 "$ftp_(22) stop"

#Set a TCP connection between node_(6) and node_(36)
set tcp_(23) [new Agent/TCP/Newreno]
$tcp_(23) set class_ 2
set sink_(23) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(23)
$ns attach-agent $node_(36) $sink_(23)
$ns connect $tcp_(23) $sink_(23)
set ftp_(23) [new Application/FTP]
$ftp_(23) attach-agent $tcp_(23)
$ns at 540.2 "$ftp_(23) start"
$ns at 720.0 "$ftp_(23) stop"

#Set a TCP connection between node_(59) and node_(22)
set tcp_(24) [new Agent/TCP/Newreno]
$tcp_(24) set class_ 2
set sink_(24) [new Agent/TCPSink]
$ns attach-agent $node_(59) $tcp_(24)
$ns attach-agent $node_(22) $sink_(24)
$ns connect $tcp_(24) $sink_(24)
set ftp_(24) [new Application/FTP]
$ftp_(24) attach-agent $tcp_(24)
$ns at 720.2 "$ftp_(24) start"
$ns at 900.0 "$ftp_(24) stop"

#Set a TCP connection between node_(38) and node_(35)
set tcp_(25) [new Agent/TCP/Newreno]
$tcp_(25) set class_ 2
set sink_(25) [new Agent/TCPSink]
$ns attach-agent $node_(38) $tcp_(25)
$ns attach-agent $node_(35) $sink_(25)
$ns connect $tcp_(25) $sink_(25)
set ftp_(25) [new Application/FTP]
$ftp_(25) attach-agent $tcp_(25)
$ns at 0.2 "$ftp_(25) start"
$ns at 180.0 "$ftp_(25) stop"

#Set a TCP connection between node_(18) and node_(10)
set tcp_(26) [new Agent/TCP/Newreno]
$tcp_(26) set class_ 2
set sink_(26) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(26)
$ns attach-agent $node_(10) $sink_(26)
$ns connect $tcp_(26) $sink_(26)
set ftp_(26) [new Application/FTP]
$ftp_(26) attach-agent $tcp_(26)
$ns at 180.2 "$ftp_(26) start"
$ns at 360.0 "$ftp_(26) stop"

#Set a TCP connection between node_(57) and node_(12)
set tcp_(27) [new Agent/TCP/Newreno]
$tcp_(27) set class_ 2
set sink_(27) [new Agent/TCPSink]
$ns attach-agent $node_(57) $tcp_(27)
$ns attach-agent $node_(12) $sink_(27)
$ns connect $tcp_(27) $sink_(27)
set ftp_(27) [new Application/FTP]
$ftp_(27) attach-agent $tcp_(27)
$ns at 360.2 "$ftp_(27) start"
$ns at 540.0 "$ftp_(27) stop"

#Set a TCP connection between node_(14) and node_(19)
set tcp_(28) [new Agent/TCP/Newreno]
$tcp_(28) set class_ 2
set sink_(28) [new Agent/TCPSink]
$ns attach-agent $node_(14) $tcp_(28)
$ns attach-agent $node_(19) $sink_(28)
$ns connect $tcp_(28) $sink_(28)
set ftp_(28) [new Application/FTP]
$ftp_(28) attach-agent $tcp_(28)
$ns at 540.2 "$ftp_(28) start"
$ns at 720.0 "$ftp_(28) stop"

#Set a TCP connection between node_(33) and node_(16)
set tcp_(29) [new Agent/TCP/Newreno]
$tcp_(29) set class_ 2
set sink_(29) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(29)
$ns attach-agent $node_(16) $sink_(29)
$ns connect $tcp_(29) $sink_(29)
set ftp_(29) [new Application/FTP]
$ftp_(29) attach-agent $tcp_(29)
$ns at 720.2 "$ftp_(29) start"
$ns at 900.0 "$ftp_(29) stop"

#Set a TCP connection between node_(50) and node_(85)
set tcp_(30) [new Agent/TCP/Newreno]
$tcp_(30) set class_ 2
set sink_(30) [new Agent/TCPSink]
$ns attach-agent $node_(50) $tcp_(30)
$ns attach-agent $node_(85) $sink_(30)
$ns connect $tcp_(30) $sink_(30)
set ftp_(30) [new Application/FTP]
$ftp_(30) attach-agent $tcp_(30)
$ns at 0.2 "$ftp_(30) start"
$ns at 180.0 "$ftp_(30) stop"

#Set a TCP connection between node_(94) and node_(60)
set tcp_(31) [new Agent/TCP/Newreno]
$tcp_(31) set class_ 2
set sink_(31) [new Agent/TCPSink]
$ns attach-agent $node_(94) $tcp_(31)
$ns attach-agent $node_(60) $sink_(31)
$ns connect $tcp_(31) $sink_(31)
set ftp_(31) [new Application/FTP]
$ftp_(31) attach-agent $tcp_(31)
$ns at 180.2 "$ftp_(31) start"
$ns at 360.0 "$ftp_(31) stop"

#Set a TCP connection between node_(86) and node_(85)
set tcp_(32) [new Agent/TCP/Newreno]
$tcp_(32) set class_ 2
set sink_(32) [new Agent/TCPSink]
$ns attach-agent $node_(86) $tcp_(32)
$ns attach-agent $node_(85) $sink_(32)
$ns connect $tcp_(32) $sink_(32)
set ftp_(32) [new Application/FTP]
$ftp_(32) attach-agent $tcp_(32)
$ns at 360.2 "$ftp_(32) start"
$ns at 540.0 "$ftp_(32) stop"

#Set a TCP connection between node_(84) and node_(30)
set tcp_(33) [new Agent/TCP/Newreno]
$tcp_(33) set class_ 2
set sink_(33) [new Agent/TCPSink]
$ns attach-agent $node_(84) $tcp_(33)
$ns attach-agent $node_(30) $sink_(33)
$ns connect $tcp_(33) $sink_(33)
set ftp_(33) [new Application/FTP]
$ftp_(33) attach-agent $tcp_(33)
$ns at 540.2 "$ftp_(33) start"
$ns at 720.0 "$ftp_(33) stop"

#Set a TCP connection between node_(44) and node_(95)
set tcp_(34) [new Agent/TCP/Newreno]
$tcp_(34) set class_ 2
set sink_(34) [new Agent/TCPSink]
$ns attach-agent $node_(44) $tcp_(34)
$ns attach-agent $node_(95) $sink_(34)
$ns connect $tcp_(34) $sink_(34)
set ftp_(34) [new Application/FTP]
$ftp_(34) attach-agent $tcp_(34)
$ns at 720.2 "$ftp_(34) start"
$ns at 900.0 "$ftp_(34) stop"

#Set a TCP connection between node_(34) and node_(38)
set tcp_(35) [new Agent/TCP/Newreno]
$tcp_(35) set class_ 2
set sink_(35) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(35)
$ns attach-agent $node_(38) $sink_(35)
$ns connect $tcp_(35) $sink_(35)
set ftp_(35) [new Application/FTP]
$ftp_(35) attach-agent $tcp_(35)
$ns at 0.2 "$ftp_(35) start"
$ns at 180.0 "$ftp_(35) stop"

#Set a TCP connection between node_(98) and node_(91)
set tcp_(36) [new Agent/TCP/Newreno]
$tcp_(36) set class_ 2
set sink_(36) [new Agent/TCPSink]
$ns attach-agent $node_(98) $tcp_(36)
$ns attach-agent $node_(91) $sink_(36)
$ns connect $tcp_(36) $sink_(36)
set ftp_(36) [new Application/FTP]
$ftp_(36) attach-agent $tcp_(36)
$ns at 180.2 "$ftp_(36) start"
$ns at 360.0 "$ftp_(36) stop"

#Set a TCP connection between node_(68) and node_(95)
set tcp_(37) [new Agent/TCP/Newreno]
$tcp_(37) set class_ 2
set sink_(37) [new Agent/TCPSink]
$ns attach-agent $node_(68) $tcp_(37)
$ns attach-agent $node_(95) $sink_(37)
$ns connect $tcp_(37) $sink_(37)
set ftp_(37) [new Application/FTP]
$ftp_(37) attach-agent $tcp_(37)
$ns at 360.2 "$ftp_(37) start"
$ns at 540.0 "$ftp_(37) stop"

#Set a TCP connection between node_(83) and node_(78)
set tcp_(38) [new Agent/TCP/Newreno]
$tcp_(38) set class_ 2
set sink_(38) [new Agent/TCPSink]
$ns attach-agent $node_(83) $tcp_(38)
$ns attach-agent $node_(78) $sink_(38)
$ns connect $tcp_(38) $sink_(38)
set ftp_(38) [new Application/FTP]
$ftp_(38) attach-agent $tcp_(38)
$ns at 540.2 "$ftp_(38) start"
$ns at 720.0 "$ftp_(38) stop"

#Set a TCP connection between node_(25) and node_(10)
set tcp_(39) [new Agent/TCP/Newreno]
$tcp_(39) set class_ 2
set sink_(39) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(39)
$ns attach-agent $node_(10) $sink_(39)
$ns connect $tcp_(39) $sink_(39)
set ftp_(39) [new Application/FTP]
$ftp_(39) attach-agent $tcp_(39)
$ns at 720.2 "$ftp_(39) start"
$ns at 900.0 "$ftp_(39) stop"

#Set a TCP connection between node_(79) and node_(70)
set tcp_(40) [new Agent/TCP/Newreno]
$tcp_(40) set class_ 2
set sink_(40) [new Agent/TCPSink]
$ns attach-agent $node_(79) $tcp_(40)
$ns attach-agent $node_(70) $sink_(40)
$ns connect $tcp_(40) $sink_(40)
set ftp_(40) [new Application/FTP]
$ftp_(40) attach-agent $tcp_(40)
$ns at 0.2 "$ftp_(40) start"
$ns at 180.0 "$ftp_(40) stop"

#Set a TCP connection between node_(86) and node_(17)
set tcp_(41) [new Agent/TCP/Newreno]
$tcp_(41) set class_ 2
set sink_(41) [new Agent/TCPSink]
$ns attach-agent $node_(86) $tcp_(41)
$ns attach-agent $node_(17) $sink_(41)
$ns connect $tcp_(41) $sink_(41)
set ftp_(41) [new Application/FTP]
$ftp_(41) attach-agent $tcp_(41)
$ns at 180.2 "$ftp_(41) start"
$ns at 360.0 "$ftp_(41) stop"

#Set a TCP connection between node_(76) and node_(41)
set tcp_(42) [new Agent/TCP/Newreno]
$tcp_(42) set class_ 2
set sink_(42) [new Agent/TCPSink]
$ns attach-agent $node_(76) $tcp_(42)
$ns attach-agent $node_(41) $sink_(42)
$ns connect $tcp_(42) $sink_(42)
set ftp_(42) [new Application/FTP]
$ftp_(42) attach-agent $tcp_(42)
$ns at 360.2 "$ftp_(42) start"
$ns at 540.0 "$ftp_(42) stop"

#Set a TCP connection between node_(79) and node_(35)
set tcp_(43) [new Agent/TCP/Newreno]
$tcp_(43) set class_ 2
set sink_(43) [new Agent/TCPSink]
$ns attach-agent $node_(79) $tcp_(43)
$ns attach-agent $node_(35) $sink_(43)
$ns connect $tcp_(43) $sink_(43)
set ftp_(43) [new Application/FTP]
$ftp_(43) attach-agent $tcp_(43)
$ns at 540.2 "$ftp_(43) start"
$ns at 720.0 "$ftp_(43) stop"

#Set a TCP connection between node_(18) and node_(46)
set tcp_(44) [new Agent/TCP/Newreno]
$tcp_(44) set class_ 2
set sink_(44) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(44)
$ns attach-agent $node_(46) $sink_(44)
$ns connect $tcp_(44) $sink_(44)
set ftp_(44) [new Application/FTP]
$ftp_(44) attach-agent $tcp_(44)
$ns at 720.2 "$ftp_(44) start"
$ns at 900.0 "$ftp_(44) stop"

#Set a TCP connection between node_(7) and node_(74)
set tcp_(45) [new Agent/TCP/Newreno]
$tcp_(45) set class_ 2
set sink_(45) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(45)
$ns attach-agent $node_(74) $sink_(45)
$ns connect $tcp_(45) $sink_(45)
set ftp_(45) [new Application/FTP]
$ftp_(45) attach-agent $tcp_(45)
$ns at 0.2 "$ftp_(45) start"
$ns at 180.0 "$ftp_(45) stop"

#Set a TCP connection between node_(42) and node_(14)
set tcp_(46) [new Agent/TCP/Newreno]
$tcp_(46) set class_ 2
set sink_(46) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(46)
$ns attach-agent $node_(14) $sink_(46)
$ns connect $tcp_(46) $sink_(46)
set ftp_(46) [new Application/FTP]
$ftp_(46) attach-agent $tcp_(46)
$ns at 180.2 "$ftp_(46) start"
$ns at 360.0 "$ftp_(46) stop"

#Set a TCP connection between node_(92) and node_(4)
set tcp_(47) [new Agent/TCP/Newreno]
$tcp_(47) set class_ 2
set sink_(47) [new Agent/TCPSink]
$ns attach-agent $node_(92) $tcp_(47)
$ns attach-agent $node_(4) $sink_(47)
$ns connect $tcp_(47) $sink_(47)
set ftp_(47) [new Application/FTP]
$ftp_(47) attach-agent $tcp_(47)
$ns at 360.2 "$ftp_(47) start"
$ns at 540.0 "$ftp_(47) stop"

#Set a TCP connection between node_(33) and node_(59)
set tcp_(48) [new Agent/TCP/Newreno]
$tcp_(48) set class_ 2
set sink_(48) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(48)
$ns attach-agent $node_(59) $sink_(48)
$ns connect $tcp_(48) $sink_(48)
set ftp_(48) [new Application/FTP]
$ftp_(48) attach-agent $tcp_(48)
$ns at 540.2 "$ftp_(48) start"
$ns at 720.0 "$ftp_(48) stop"

#Set a TCP connection between node_(33) and node_(1)
set tcp_(49) [new Agent/TCP/Newreno]
$tcp_(49) set class_ 2
set sink_(49) [new Agent/TCPSink]
$ns attach-agent $node_(33) $tcp_(49)
$ns attach-agent $node_(1) $sink_(49)
$ns connect $tcp_(49) $sink_(49)
set ftp_(49) [new Application/FTP]
$ftp_(49) attach-agent $tcp_(49)
$ns at 720.2 "$ftp_(49) start"
$ns at 900.0 "$ftp_(49) stop"

#Set a TCP connection between node_(87) and node_(76)
set tcp_(50) [new Agent/TCP/Newreno]
$tcp_(50) set class_ 2
set sink_(50) [new Agent/TCPSink]
$ns attach-agent $node_(87) $tcp_(50)
$ns attach-agent $node_(76) $sink_(50)
$ns connect $tcp_(50) $sink_(50)
set ftp_(50) [new Application/FTP]
$ftp_(50) attach-agent $tcp_(50)
$ns at 0.2 "$ftp_(50) start"
$ns at 180.0 "$ftp_(50) stop"

#Set a TCP connection between node_(43) and node_(78)
set tcp_(51) [new Agent/TCP/Newreno]
$tcp_(51) set class_ 2
set sink_(51) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(51)
$ns attach-agent $node_(78) $sink_(51)
$ns connect $tcp_(51) $sink_(51)
set ftp_(51) [new Application/FTP]
$ftp_(51) attach-agent $tcp_(51)
$ns at 180.2 "$ftp_(51) start"
$ns at 360.0 "$ftp_(51) stop"

#Set a TCP connection between node_(60) and node_(41)
set tcp_(52) [new Agent/TCP/Newreno]
$tcp_(52) set class_ 2
set sink_(52) [new Agent/TCPSink]
$ns attach-agent $node_(60) $tcp_(52)
$ns attach-agent $node_(41) $sink_(52)
$ns connect $tcp_(52) $sink_(52)
set ftp_(52) [new Application/FTP]
$ftp_(52) attach-agent $tcp_(52)
$ns at 360.2 "$ftp_(52) start"
$ns at 540.0 "$ftp_(52) stop"

#Set a TCP connection between node_(56) and node_(51)
set tcp_(53) [new Agent/TCP/Newreno]
$tcp_(53) set class_ 2
set sink_(53) [new Agent/TCPSink]
$ns attach-agent $node_(56) $tcp_(53)
$ns attach-agent $node_(51) $sink_(53)
$ns connect $tcp_(53) $sink_(53)
set ftp_(53) [new Application/FTP]
$ftp_(53) attach-agent $tcp_(53)
$ns at 540.2 "$ftp_(53) start"
$ns at 720.0 "$ftp_(53) stop"

#Set a TCP connection between node_(60) and node_(20)
set tcp_(54) [new Agent/TCP/Newreno]
$tcp_(54) set class_ 2
set sink_(54) [new Agent/TCPSink]
$ns attach-agent $node_(60) $tcp_(54)
$ns attach-agent $node_(20) $sink_(54)
$ns connect $tcp_(54) $sink_(54)
set ftp_(54) [new Application/FTP]
$ftp_(54) attach-agent $tcp_(54)
$ns at 720.2 "$ftp_(54) start"
$ns at 900.0 "$ftp_(54) stop"

#Set a TCP connection between node_(38) and node_(6)
set tcp_(55) [new Agent/TCP/Newreno]
$tcp_(55) set class_ 2
set sink_(55) [new Agent/TCPSink]
$ns attach-agent $node_(38) $tcp_(55)
$ns attach-agent $node_(6) $sink_(55)
$ns connect $tcp_(55) $sink_(55)
set ftp_(55) [new Application/FTP]
$ftp_(55) attach-agent $tcp_(55)
$ns at 0.2 "$ftp_(55) start"
$ns at 180.0 "$ftp_(55) stop"

#Set a TCP connection between node_(79) and node_(67)
set tcp_(56) [new Agent/TCP/Newreno]
$tcp_(56) set class_ 2
set sink_(56) [new Agent/TCPSink]
$ns attach-agent $node_(79) $tcp_(56)
$ns attach-agent $node_(67) $sink_(56)
$ns connect $tcp_(56) $sink_(56)
set ftp_(56) [new Application/FTP]
$ftp_(56) attach-agent $tcp_(56)
$ns at 180.2 "$ftp_(56) start"
$ns at 360.0 "$ftp_(56) stop"

#Set a TCP connection between node_(25) and node_(12)
set tcp_(57) [new Agent/TCP/Newreno]
$tcp_(57) set class_ 2
set sink_(57) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(57)
$ns attach-agent $node_(12) $sink_(57)
$ns connect $tcp_(57) $sink_(57)
set ftp_(57) [new Application/FTP]
$ftp_(57) attach-agent $tcp_(57)
$ns at 360.2 "$ftp_(57) start"
$ns at 540.0 "$ftp_(57) stop"

#Set a TCP connection between node_(39) and node_(91)
set tcp_(58) [new Agent/TCP/Newreno]
$tcp_(58) set class_ 2
set sink_(58) [new Agent/TCPSink]
$ns attach-agent $node_(39) $tcp_(58)
$ns attach-agent $node_(91) $sink_(58)
$ns connect $tcp_(58) $sink_(58)
set ftp_(58) [new Application/FTP]
$ftp_(58) attach-agent $tcp_(58)
$ns at 540.2 "$ftp_(58) start"
$ns at 720.0 "$ftp_(58) stop"

#Set a TCP connection between node_(58) and node_(2)
set tcp_(59) [new Agent/TCP/Newreno]
$tcp_(59) set class_ 2
set sink_(59) [new Agent/TCPSink]
$ns attach-agent $node_(58) $tcp_(59)
$ns attach-agent $node_(2) $sink_(59)
$ns connect $tcp_(59) $sink_(59)
set ftp_(59) [new Application/FTP]
$ftp_(59) attach-agent $tcp_(59)
$ns at 720.2 "$ftp_(59) start"
$ns at 900.0 "$ftp_(59) stop"

#Set a TCP connection between node_(28) and node_(97)
set tcp_(60) [new Agent/TCP/Newreno]
$tcp_(60) set class_ 2
set sink_(60) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(60)
$ns attach-agent $node_(97) $sink_(60)
$ns connect $tcp_(60) $sink_(60)
set ftp_(60) [new Application/FTP]
$ftp_(60) attach-agent $tcp_(60)
$ns at 0.2 "$ftp_(60) start"
$ns at 180.0 "$ftp_(60) stop"

#Set a TCP connection between node_(42) and node_(84)
set tcp_(61) [new Agent/TCP/Newreno]
$tcp_(61) set class_ 2
set sink_(61) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(61)
$ns attach-agent $node_(84) $sink_(61)
$ns connect $tcp_(61) $sink_(61)
set ftp_(61) [new Application/FTP]
$ftp_(61) attach-agent $tcp_(61)
$ns at 180.2 "$ftp_(61) start"
$ns at 360.0 "$ftp_(61) stop"

#Set a TCP connection between node_(89) and node_(23)
set tcp_(62) [new Agent/TCP/Newreno]
$tcp_(62) set class_ 2
set sink_(62) [new Agent/TCPSink]
$ns attach-agent $node_(89) $tcp_(62)
$ns attach-agent $node_(23) $sink_(62)
$ns connect $tcp_(62) $sink_(62)
set ftp_(62) [new Application/FTP]
$ftp_(62) attach-agent $tcp_(62)
$ns at 360.2 "$ftp_(62) start"
$ns at 540.0 "$ftp_(62) stop"

#Set a TCP connection between node_(91) and node_(21)
set tcp_(63) [new Agent/TCP/Newreno]
$tcp_(63) set class_ 2
set sink_(63) [new Agent/TCPSink]
$ns attach-agent $node_(91) $tcp_(63)
$ns attach-agent $node_(21) $sink_(63)
$ns connect $tcp_(63) $sink_(63)
set ftp_(63) [new Application/FTP]
$ftp_(63) attach-agent $tcp_(63)
$ns at 540.2 "$ftp_(63) start"
$ns at 720.0 "$ftp_(63) stop"

#Set a TCP connection between node_(83) and node_(66)
set tcp_(64) [new Agent/TCP/Newreno]
$tcp_(64) set class_ 2
set sink_(64) [new Agent/TCPSink]
$ns attach-agent $node_(83) $tcp_(64)
$ns attach-agent $node_(66) $sink_(64)
$ns connect $tcp_(64) $sink_(64)
set ftp_(64) [new Application/FTP]
$ftp_(64) attach-agent $tcp_(64)
$ns at 720.2 "$ftp_(64) start"
$ns at 900.0 "$ftp_(64) stop"

#Set a TCP connection between node_(47) and node_(53)
set tcp_(65) [new Agent/TCP/Newreno]
$tcp_(65) set class_ 2
set sink_(65) [new Agent/TCPSink]
$ns attach-agent $node_(47) $tcp_(65)
$ns attach-agent $node_(53) $sink_(65)
$ns connect $tcp_(65) $sink_(65)
set ftp_(65) [new Application/FTP]
$ftp_(65) attach-agent $tcp_(65)
$ns at 0.2 "$ftp_(65) start"
$ns at 180.0 "$ftp_(65) stop"

#Set a TCP connection between node_(20) and node_(42)
set tcp_(66) [new Agent/TCP/Newreno]
$tcp_(66) set class_ 2
set sink_(66) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(66)
$ns attach-agent $node_(42) $sink_(66)
$ns connect $tcp_(66) $sink_(66)
set ftp_(66) [new Application/FTP]
$ftp_(66) attach-agent $tcp_(66)
$ns at 180.2 "$ftp_(66) start"
$ns at 360.0 "$ftp_(66) stop"

#Set a TCP connection between node_(91) and node_(61)
set tcp_(67) [new Agent/TCP/Newreno]
$tcp_(67) set class_ 2
set sink_(67) [new Agent/TCPSink]
$ns attach-agent $node_(91) $tcp_(67)
$ns attach-agent $node_(61) $sink_(67)
$ns connect $tcp_(67) $sink_(67)
set ftp_(67) [new Application/FTP]
$ftp_(67) attach-agent $tcp_(67)
$ns at 360.2 "$ftp_(67) start"
$ns at 540.0 "$ftp_(67) stop"

#Set a TCP connection between node_(3) and node_(85)
set tcp_(68) [new Agent/TCP/Newreno]
$tcp_(68) set class_ 2
set sink_(68) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(68)
$ns attach-agent $node_(85) $sink_(68)
$ns connect $tcp_(68) $sink_(68)
set ftp_(68) [new Application/FTP]
$ftp_(68) attach-agent $tcp_(68)
$ns at 540.2 "$ftp_(68) start"
$ns at 720.0 "$ftp_(68) stop"

#Set a TCP connection between node_(73) and node_(24)
set tcp_(69) [new Agent/TCP/Newreno]
$tcp_(69) set class_ 2
set sink_(69) [new Agent/TCPSink]
$ns attach-agent $node_(73) $tcp_(69)
$ns attach-agent $node_(24) $sink_(69)
$ns connect $tcp_(69) $sink_(69)
set ftp_(69) [new Application/FTP]
$ftp_(69) attach-agent $tcp_(69)
$ns at 720.2 "$ftp_(69) start"
$ns at 900.0 "$ftp_(69) stop"

#Set a TCP connection between node_(85) and node_(30)
set tcp_(70) [new Agent/TCP/Newreno]
$tcp_(70) set class_ 2
set sink_(70) [new Agent/TCPSink]
$ns attach-agent $node_(85) $tcp_(70)
$ns attach-agent $node_(30) $sink_(70)
$ns connect $tcp_(70) $sink_(70)
set ftp_(70) [new Application/FTP]
$ftp_(70) attach-agent $tcp_(70)
$ns at 0.2 "$ftp_(70) start"
$ns at 180.0 "$ftp_(70) stop"

#Set a TCP connection between node_(82) and node_(76)
set tcp_(71) [new Agent/TCP/Newreno]
$tcp_(71) set class_ 2
set sink_(71) [new Agent/TCPSink]
$ns attach-agent $node_(82) $tcp_(71)
$ns attach-agent $node_(76) $sink_(71)
$ns connect $tcp_(71) $sink_(71)
set ftp_(71) [new Application/FTP]
$ftp_(71) attach-agent $tcp_(71)
$ns at 180.2 "$ftp_(71) start"
$ns at 360.0 "$ftp_(71) stop"

#Set a TCP connection between node_(46) and node_(82)
set tcp_(72) [new Agent/TCP/Newreno]
$tcp_(72) set class_ 2
set sink_(72) [new Agent/TCPSink]
$ns attach-agent $node_(46) $tcp_(72)
$ns attach-agent $node_(82) $sink_(72)
$ns connect $tcp_(72) $sink_(72)
set ftp_(72) [new Application/FTP]
$ftp_(72) attach-agent $tcp_(72)
$ns at 360.2 "$ftp_(72) start"
$ns at 540.0 "$ftp_(72) stop"

#Set a TCP connection between node_(76) and node_(80)
set tcp_(73) [new Agent/TCP/Newreno]
$tcp_(73) set class_ 2
set sink_(73) [new Agent/TCPSink]
$ns attach-agent $node_(76) $tcp_(73)
$ns attach-agent $node_(80) $sink_(73)
$ns connect $tcp_(73) $sink_(73)
set ftp_(73) [new Application/FTP]
$ftp_(73) attach-agent $tcp_(73)
$ns at 540.2 "$ftp_(73) start"
$ns at 720.0 "$ftp_(73) stop"

#Set a TCP connection between node_(50) and node_(63)
set tcp_(74) [new Agent/TCP/Newreno]
$tcp_(74) set class_ 2
set sink_(74) [new Agent/TCPSink]
$ns attach-agent $node_(50) $tcp_(74)
$ns attach-agent $node_(63) $sink_(74)
$ns connect $tcp_(74) $sink_(74)
set ftp_(74) [new Application/FTP]
$ftp_(74) attach-agent $tcp_(74)
$ns at 720.2 "$ftp_(74) start"
$ns at 900.0 "$ftp_(74) stop"

#Set a TCP connection between node_(89) and node_(88)
set tcp_(75) [new Agent/TCP/Newreno]
$tcp_(75) set class_ 2
set sink_(75) [new Agent/TCPSink]
$ns attach-agent $node_(89) $tcp_(75)
$ns attach-agent $node_(88) $sink_(75)
$ns connect $tcp_(75) $sink_(75)
set ftp_(75) [new Application/FTP]
$ftp_(75) attach-agent $tcp_(75)
$ns at 0.2 "$ftp_(75) start"
$ns at 180.0 "$ftp_(75) stop"

#Set a TCP connection between node_(45) and node_(83)
set tcp_(76) [new Agent/TCP/Newreno]
$tcp_(76) set class_ 2
set sink_(76) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(76)
$ns attach-agent $node_(83) $sink_(76)
$ns connect $tcp_(76) $sink_(76)
set ftp_(76) [new Application/FTP]
$ftp_(76) attach-agent $tcp_(76)
$ns at 180.2 "$ftp_(76) start"
$ns at 360.0 "$ftp_(76) stop"

#Set a TCP connection between node_(65) and node_(12)
set tcp_(77) [new Agent/TCP/Newreno]
$tcp_(77) set class_ 2
set sink_(77) [new Agent/TCPSink]
$ns attach-agent $node_(65) $tcp_(77)
$ns attach-agent $node_(12) $sink_(77)
$ns connect $tcp_(77) $sink_(77)
set ftp_(77) [new Application/FTP]
$ftp_(77) attach-agent $tcp_(77)
$ns at 360.2 "$ftp_(77) start"
$ns at 540.0 "$ftp_(77) stop"

#Set a TCP connection between node_(91) and node_(52)
set tcp_(78) [new Agent/TCP/Newreno]
$tcp_(78) set class_ 2
set sink_(78) [new Agent/TCPSink]
$ns attach-agent $node_(91) $tcp_(78)
$ns attach-agent $node_(52) $sink_(78)
$ns connect $tcp_(78) $sink_(78)
set ftp_(78) [new Application/FTP]
$ftp_(78) attach-agent $tcp_(78)
$ns at 540.2 "$ftp_(78) start"
$ns at 720.0 "$ftp_(78) stop"

#Set a TCP connection between node_(88) and node_(24)
set tcp_(79) [new Agent/TCP/Newreno]
$tcp_(79) set class_ 2
set sink_(79) [new Agent/TCPSink]
$ns attach-agent $node_(88) $tcp_(79)
$ns attach-agent $node_(24) $sink_(79)
$ns connect $tcp_(79) $sink_(79)
set ftp_(79) [new Application/FTP]
$ftp_(79) attach-agent $tcp_(79)
$ns at 720.2 "$ftp_(79) start"
$ns at 900.0 "$ftp_(79) stop"

#Set a TCP connection between node_(64) and node_(98)
set tcp_(80) [new Agent/TCP/Newreno]
$tcp_(80) set class_ 2
set sink_(80) [new Agent/TCPSink]
$ns attach-agent $node_(64) $tcp_(80)
$ns attach-agent $node_(98) $sink_(80)
$ns connect $tcp_(80) $sink_(80)
set ftp_(80) [new Application/FTP]
$ftp_(80) attach-agent $tcp_(80)
$ns at 0.2 "$ftp_(80) start"
$ns at 180.0 "$ftp_(80) stop"

#Set a TCP connection between node_(90) and node_(87)
set tcp_(81) [new Agent/TCP/Newreno]
$tcp_(81) set class_ 2
set sink_(81) [new Agent/TCPSink]
$ns attach-agent $node_(90) $tcp_(81)
$ns attach-agent $node_(87) $sink_(81)
$ns connect $tcp_(81) $sink_(81)
set ftp_(81) [new Application/FTP]
$ftp_(81) attach-agent $tcp_(81)
$ns at 180.2 "$ftp_(81) start"
$ns at 360.0 "$ftp_(81) stop"

#Set a TCP connection between node_(10) and node_(70)
set tcp_(82) [new Agent/TCP/Newreno]
$tcp_(82) set class_ 2
set sink_(82) [new Agent/TCPSink]
$ns attach-agent $node_(10) $tcp_(82)
$ns attach-agent $node_(70) $sink_(82)
$ns connect $tcp_(82) $sink_(82)
set ftp_(82) [new Application/FTP]
$ftp_(82) attach-agent $tcp_(82)
$ns at 360.2 "$ftp_(82) start"
$ns at 540.0 "$ftp_(82) stop"

#Set a TCP connection between node_(80) and node_(14)
set tcp_(83) [new Agent/TCP/Newreno]
$tcp_(83) set class_ 2
set sink_(83) [new Agent/TCPSink]
$ns attach-agent $node_(80) $tcp_(83)
$ns attach-agent $node_(14) $sink_(83)
$ns connect $tcp_(83) $sink_(83)
set ftp_(83) [new Application/FTP]
$ftp_(83) attach-agent $tcp_(83)
$ns at 540.2 "$ftp_(83) start"
$ns at 720.0 "$ftp_(83) stop"

#Set a TCP connection between node_(82) and node_(89)
set tcp_(84) [new Agent/TCP/Newreno]
$tcp_(84) set class_ 2
set sink_(84) [new Agent/TCPSink]
$ns attach-agent $node_(82) $tcp_(84)
$ns attach-agent $node_(89) $sink_(84)
$ns connect $tcp_(84) $sink_(84)
set ftp_(84) [new Application/FTP]
$ftp_(84) attach-agent $tcp_(84)
$ns at 720.2 "$ftp_(84) start"
$ns at 900.0 "$ftp_(84) stop"

#Set a TCP connection between node_(77) and node_(6)
set tcp_(85) [new Agent/TCP/Newreno]
$tcp_(85) set class_ 2
set sink_(85) [new Agent/TCPSink]
$ns attach-agent $node_(77) $tcp_(85)
$ns attach-agent $node_(6) $sink_(85)
$ns connect $tcp_(85) $sink_(85)
set ftp_(85) [new Application/FTP]
$ftp_(85) attach-agent $tcp_(85)
$ns at 0.2 "$ftp_(85) start"
$ns at 180.0 "$ftp_(85) stop"

#Set a TCP connection between node_(76) and node_(35)
set tcp_(86) [new Agent/TCP/Newreno]
$tcp_(86) set class_ 2
set sink_(86) [new Agent/TCPSink]
$ns attach-agent $node_(76) $tcp_(86)
$ns attach-agent $node_(35) $sink_(86)
$ns connect $tcp_(86) $sink_(86)
set ftp_(86) [new Application/FTP]
$ftp_(86) attach-agent $tcp_(86)
$ns at 180.2 "$ftp_(86) start"
$ns at 360.0 "$ftp_(86) stop"

#Set a TCP connection between node_(52) and node_(36)
set tcp_(87) [new Agent/TCP/Newreno]
$tcp_(87) set class_ 2
set sink_(87) [new Agent/TCPSink]
$ns attach-agent $node_(52) $tcp_(87)
$ns attach-agent $node_(36) $sink_(87)
$ns connect $tcp_(87) $sink_(87)
set ftp_(87) [new Application/FTP]
$ftp_(87) attach-agent $tcp_(87)
$ns at 360.2 "$ftp_(87) start"
$ns at 540.0 "$ftp_(87) stop"

#Set a TCP connection between node_(0) and node_(19)
set tcp_(88) [new Agent/TCP/Newreno]
$tcp_(88) set class_ 2
set sink_(88) [new Agent/TCPSink]
$ns attach-agent $node_(0) $tcp_(88)
$ns attach-agent $node_(19) $sink_(88)
$ns connect $tcp_(88) $sink_(88)
set ftp_(88) [new Application/FTP]
$ftp_(88) attach-agent $tcp_(88)
$ns at 540.2 "$ftp_(88) start"
$ns at 720.0 "$ftp_(88) stop"

#Set a TCP connection between node_(99) and node_(25)
set tcp_(89) [new Agent/TCP/Newreno]
$tcp_(89) set class_ 2
set sink_(89) [new Agent/TCPSink]
$ns attach-agent $node_(99) $tcp_(89)
$ns attach-agent $node_(25) $sink_(89)
$ns connect $tcp_(89) $sink_(89)
set ftp_(89) [new Application/FTP]
$ftp_(89) attach-agent $tcp_(89)
$ns at 720.2 "$ftp_(89) start"
$ns at 900.0 "$ftp_(89) stop"

#Set a TCP connection between node_(36) and node_(80)
set tcp_(90) [new Agent/TCP/Newreno]
$tcp_(90) set class_ 2
set sink_(90) [new Agent/TCPSink]
$ns attach-agent $node_(36) $tcp_(90)
$ns attach-agent $node_(80) $sink_(90)
$ns connect $tcp_(90) $sink_(90)
set ftp_(90) [new Application/FTP]
$ftp_(90) attach-agent $tcp_(90)
$ns at 0.2 "$ftp_(90) start"
$ns at 180.0 "$ftp_(90) stop"

#Set a TCP connection between node_(73) and node_(86)
set tcp_(91) [new Agent/TCP/Newreno]
$tcp_(91) set class_ 2
set sink_(91) [new Agent/TCPSink]
$ns attach-agent $node_(73) $tcp_(91)
$ns attach-agent $node_(86) $sink_(91)
$ns connect $tcp_(91) $sink_(91)
set ftp_(91) [new Application/FTP]
$ftp_(91) attach-agent $tcp_(91)
$ns at 180.2 "$ftp_(91) start"
$ns at 360.0 "$ftp_(91) stop"

#Set a TCP connection between node_(23) and node_(5)
set tcp_(92) [new Agent/TCP/Newreno]
$tcp_(92) set class_ 2
set sink_(92) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(92)
$ns attach-agent $node_(5) $sink_(92)
$ns connect $tcp_(92) $sink_(92)
set ftp_(92) [new Application/FTP]
$ftp_(92) attach-agent $tcp_(92)
$ns at 360.2 "$ftp_(92) start"
$ns at 540.0 "$ftp_(92) stop"

#Set a TCP connection between node_(23) and node_(61)
set tcp_(93) [new Agent/TCP/Newreno]
$tcp_(93) set class_ 2
set sink_(93) [new Agent/TCPSink]
$ns attach-agent $node_(23) $tcp_(93)
$ns attach-agent $node_(61) $sink_(93)
$ns connect $tcp_(93) $sink_(93)
set ftp_(93) [new Application/FTP]
$ftp_(93) attach-agent $tcp_(93)
$ns at 540.2 "$ftp_(93) start"
$ns at 720.0 "$ftp_(93) stop"

#Set a TCP connection between node_(52) and node_(34)
set tcp_(94) [new Agent/TCP/Newreno]
$tcp_(94) set class_ 2
set sink_(94) [new Agent/TCPSink]
$ns attach-agent $node_(52) $tcp_(94)
$ns attach-agent $node_(34) $sink_(94)
$ns connect $tcp_(94) $sink_(94)
set ftp_(94) [new Application/FTP]
$ftp_(94) attach-agent $tcp_(94)
$ns at 720.2 "$ftp_(94) start"
$ns at 900.0 "$ftp_(94) stop"

#Set a TCP connection between node_(31) and node_(14)
set tcp_(95) [new Agent/TCP/Newreno]
$tcp_(95) set class_ 2
set sink_(95) [new Agent/TCPSink]
$ns attach-agent $node_(31) $tcp_(95)
$ns attach-agent $node_(14) $sink_(95)
$ns connect $tcp_(95) $sink_(95)
set ftp_(95) [new Application/FTP]
$ftp_(95) attach-agent $tcp_(95)
$ns at 0.2 "$ftp_(95) start"
$ns at 180.0 "$ftp_(95) stop"

#Set a TCP connection between node_(8) and node_(45)
set tcp_(96) [new Agent/TCP/Newreno]
$tcp_(96) set class_ 2
set sink_(96) [new Agent/TCPSink]
$ns attach-agent $node_(8) $tcp_(96)
$ns attach-agent $node_(45) $sink_(96)
$ns connect $tcp_(96) $sink_(96)
set ftp_(96) [new Application/FTP]
$ftp_(96) attach-agent $tcp_(96)
$ns at 180.2 "$ftp_(96) start"
$ns at 360.0 "$ftp_(96) stop"

#Set a TCP connection between node_(84) and node_(15)
set tcp_(97) [new Agent/TCP/Newreno]
$tcp_(97) set class_ 2
set sink_(97) [new Agent/TCPSink]
$ns attach-agent $node_(84) $tcp_(97)
$ns attach-agent $node_(15) $sink_(97)
$ns connect $tcp_(97) $sink_(97)
set ftp_(97) [new Application/FTP]
$ftp_(97) attach-agent $tcp_(97)
$ns at 360.2 "$ftp_(97) start"
$ns at 540.0 "$ftp_(97) stop"

#Set a TCP connection between node_(42) and node_(98)
set tcp_(98) [new Agent/TCP/Newreno]
$tcp_(98) set class_ 2
set sink_(98) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(98)
$ns attach-agent $node_(98) $sink_(98)
$ns connect $tcp_(98) $sink_(98)
set ftp_(98) [new Application/FTP]
$ftp_(98) attach-agent $tcp_(98)
$ns at 540.2 "$ftp_(98) start"
$ns at 720.0 "$ftp_(98) stop"

#Set a TCP connection between node_(18) and node_(47)
set tcp_(99) [new Agent/TCP/Newreno]
$tcp_(99) set class_ 2
set sink_(99) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(99)
$ns attach-agent $node_(47) $sink_(99)
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
