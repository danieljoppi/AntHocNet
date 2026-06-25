#sim-scn1-2.tcl 
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
set val(nn)             100                        ;# number of mobilenodes
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
set tracefd       [open sim-scn1-2-$val(rp)-trace.tr w]
set windowVsTime2 [open sim-scn1-2-$val(rp)-win-.tr w]
set namtrace      [open sim-scn1-2-$val(rp).nam w]

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
$node_(0) set X_ 358 
$node_(0) set Y_ 23 
$node_(0) set Z_ 0.0 
$node_(1) set X_ 569 
$node_(1) set Y_ 563 
$node_(1) set Z_ 0.0 
$node_(2) set X_ 1536 
$node_(2) set Y_ 54 
$node_(2) set Z_ 0.0 
$node_(3) set X_ 970 
$node_(3) set Y_ 252 
$node_(3) set Z_ 0.0 
$node_(4) set X_ 534 
$node_(4) set Y_ 500 
$node_(4) set Z_ 0.0 
$node_(5) set X_ 1651 
$node_(5) set Y_ 588 
$node_(5) set Z_ 0.0 
$node_(6) set X_ 1034 
$node_(6) set Y_ 16 
$node_(6) set Z_ 0.0 
$node_(7) set X_ 415 
$node_(7) set Y_ 57 
$node_(7) set Z_ 0.0 
$node_(8) set X_ 2938 
$node_(8) set Y_ 77 
$node_(8) set Z_ 0.0 
$node_(9) set X_ 1463 
$node_(9) set Y_ 808 
$node_(9) set Z_ 0.0 
$node_(10) set X_ 882 
$node_(10) set Y_ 168 
$node_(10) set Z_ 0.0 
$node_(11) set X_ 1536 
$node_(11) set Y_ 577 
$node_(11) set Z_ 0.0 
$node_(12) set X_ 2403 
$node_(12) set Y_ 721 
$node_(12) set Z_ 0.0 
$node_(13) set X_ 1657 
$node_(13) set Y_ 352 
$node_(13) set Z_ 0.0 
$node_(14) set X_ 180 
$node_(14) set Y_ 716 
$node_(14) set Z_ 0.0 
$node_(15) set X_ 116 
$node_(15) set Y_ 829 
$node_(15) set Z_ 0.0 
$node_(16) set X_ 470 
$node_(16) set Y_ 436 
$node_(16) set Z_ 0.0 
$node_(17) set X_ 352 
$node_(17) set Y_ 443 
$node_(17) set Z_ 0.0 
$node_(18) set X_ 778 
$node_(18) set Y_ 990 
$node_(18) set Z_ 0.0 
$node_(19) set X_ 937 
$node_(19) set Y_ 644 
$node_(19) set Z_ 0.0 
$node_(20) set X_ 888 
$node_(20) set Y_ 110 
$node_(20) set Z_ 0.0 
$node_(21) set X_ 295 
$node_(21) set Y_ 137 
$node_(21) set Z_ 0.0 
$node_(22) set X_ 2769 
$node_(22) set Y_ 198 
$node_(22) set Z_ 0.0 
$node_(23) set X_ 2831 
$node_(23) set Y_ 990 
$node_(23) set Z_ 0.0 
$node_(24) set X_ 1393 
$node_(24) set Y_ 751 
$node_(24) set Z_ 0.0 
$node_(25) set X_ 2941 
$node_(25) set Y_ 893 
$node_(25) set Z_ 0.0 
$node_(26) set X_ 1307 
$node_(26) set Y_ 131 
$node_(26) set Z_ 0.0 
$node_(27) set X_ 2916 
$node_(27) set Y_ 344 
$node_(27) set Z_ 0.0 
$node_(28) set X_ 1788 
$node_(28) set Y_ 61 
$node_(28) set Z_ 0.0 
$node_(29) set X_ 1938 
$node_(29) set Y_ 219 
$node_(29) set Z_ 0.0 
$node_(30) set X_ 638 
$node_(30) set Y_ 411 
$node_(30) set Z_ 0.0 
$node_(31) set X_ 2377 
$node_(31) set Y_ 3 
$node_(31) set Z_ 0.0 
$node_(32) set X_ 1096 
$node_(32) set Y_ 561 
$node_(32) set Z_ 0.0 
$node_(33) set X_ 2215 
$node_(33) set Y_ 936 
$node_(33) set Z_ 0.0 
$node_(34) set X_ 2017 
$node_(34) set Y_ 103 
$node_(34) set Z_ 0.0 
$node_(35) set X_ 2855 
$node_(35) set Y_ 484 
$node_(35) set Z_ 0.0 
$node_(36) set X_ 2331 
$node_(36) set Y_ 715 
$node_(36) set Z_ 0.0 
$node_(37) set X_ 1646 
$node_(37) set Y_ 810 
$node_(37) set Z_ 0.0 
$node_(38) set X_ 891 
$node_(38) set Y_ 784 
$node_(38) set Z_ 0.0 
$node_(39) set X_ 1314 
$node_(39) set Y_ 400 
$node_(39) set Z_ 0.0 
$node_(40) set X_ 2138 
$node_(40) set Y_ 774 
$node_(40) set Z_ 0.0 
$node_(41) set X_ 2007 
$node_(41) set Y_ 585 
$node_(41) set Z_ 0.0 
$node_(42) set X_ 2516 
$node_(42) set Y_ 390 
$node_(42) set Z_ 0.0 
$node_(43) set X_ 950 
$node_(43) set Y_ 466 
$node_(43) set Z_ 0.0 
$node_(44) set X_ 360 
$node_(44) set Y_ 280 
$node_(44) set Z_ 0.0 
$node_(45) set X_ 2676 
$node_(45) set Y_ 682 
$node_(45) set Z_ 0.0 
$node_(46) set X_ 2903 
$node_(46) set Y_ 438 
$node_(46) set Z_ 0.0 
$node_(47) set X_ 2496 
$node_(47) set Y_ 517 
$node_(47) set Z_ 0.0 
$node_(48) set X_ 2278 
$node_(48) set Y_ 451 
$node_(48) set Z_ 0.0 
$node_(49) set X_ 315 
$node_(49) set Y_ 81 
$node_(49) set Z_ 0.0 
$node_(50) set X_ 2748 
$node_(50) set Y_ 440 
$node_(50) set Z_ 0.0 
$node_(51) set X_ 1011 
$node_(51) set Y_ 698 
$node_(51) set Z_ 0.0 
$node_(52) set X_ 2079 
$node_(52) set Y_ 899 
$node_(52) set Z_ 0.0 
$node_(53) set X_ 476 
$node_(53) set Y_ 158 
$node_(53) set Z_ 0.0 
$node_(54) set X_ 2749 
$node_(54) set Y_ 595 
$node_(54) set Z_ 0.0 
$node_(55) set X_ 1987 
$node_(55) set Y_ 208 
$node_(55) set Z_ 0.0 
$node_(56) set X_ 2811 
$node_(56) set Y_ 385 
$node_(56) set Z_ 0.0 
$node_(57) set X_ 2859 
$node_(57) set Y_ 501 
$node_(57) set Z_ 0.0 
$node_(58) set X_ 1457 
$node_(58) set Y_ 97 
$node_(58) set Z_ 0.0 
$node_(59) set X_ 2374 
$node_(59) set Y_ 247 
$node_(59) set Z_ 0.0 
$node_(60) set X_ 2859 
$node_(60) set Y_ 573 
$node_(60) set Z_ 0.0 
$node_(61) set X_ 684 
$node_(61) set Y_ 962 
$node_(61) set Z_ 0.0 
$node_(62) set X_ 2572 
$node_(62) set Y_ 640 
$node_(62) set Z_ 0.0 
$node_(63) set X_ 2854 
$node_(63) set Y_ 60 
$node_(63) set Z_ 0.0 
$node_(64) set X_ 2718 
$node_(64) set Y_ 988 
$node_(64) set Z_ 0.0 
$node_(65) set X_ 2388 
$node_(65) set Y_ 482 
$node_(65) set Z_ 0.0 
$node_(66) set X_ 329 
$node_(66) set Y_ 940 
$node_(66) set Z_ 0.0 
$node_(67) set X_ 1450 
$node_(67) set Y_ 228 
$node_(67) set Z_ 0.0 
$node_(68) set X_ 2597 
$node_(68) set Y_ 630 
$node_(68) set Z_ 0.0 
$node_(69) set X_ 617 
$node_(69) set Y_ 437 
$node_(69) set Z_ 0.0 
$node_(70) set X_ 2381 
$node_(70) set Y_ 378 
$node_(70) set Z_ 0.0 
$node_(71) set X_ 330 
$node_(71) set Y_ 588 
$node_(71) set Z_ 0.0 
$node_(72) set X_ 1117 
$node_(72) set Y_ 968 
$node_(72) set Z_ 0.0 
$node_(73) set X_ 230 
$node_(73) set Y_ 551 
$node_(73) set Z_ 0.0 
$node_(74) set X_ 325 
$node_(74) set Y_ 67 
$node_(74) set Z_ 0.0 
$node_(75) set X_ 1373 
$node_(75) set Y_ 437 
$node_(75) set Z_ 0.0 
$node_(76) set X_ 143 
$node_(76) set Y_ 246 
$node_(76) set Z_ 0.0 
$node_(77) set X_ 1762 
$node_(77) set Y_ 620 
$node_(77) set Z_ 0.0 
$node_(78) set X_ 2785 
$node_(78) set Y_ 957 
$node_(78) set Z_ 0.0 
$node_(79) set X_ 2848 
$node_(79) set Y_ 917 
$node_(79) set Z_ 0.0 
$node_(80) set X_ 526 
$node_(80) set Y_ 324 
$node_(80) set Z_ 0.0 
$node_(81) set X_ 2593 
$node_(81) set Y_ 580 
$node_(81) set Z_ 0.0 
$node_(82) set X_ 690 
$node_(82) set Y_ 787 
$node_(82) set Z_ 0.0 
$node_(83) set X_ 1294 
$node_(83) set Y_ 711 
$node_(83) set Z_ 0.0 
$node_(84) set X_ 1274 
$node_(84) set Y_ 517 
$node_(84) set Z_ 0.0 
$node_(85) set X_ 754 
$node_(85) set Y_ 689 
$node_(85) set Z_ 0.0 
$node_(86) set X_ 2160 
$node_(86) set Y_ 969 
$node_(86) set Z_ 0.0 
$node_(87) set X_ 444 
$node_(87) set Y_ 460 
$node_(87) set Z_ 0.0 
$node_(88) set X_ 439 
$node_(88) set Y_ 119 
$node_(88) set Z_ 0.0 
$node_(89) set X_ 2109 
$node_(89) set Y_ 839 
$node_(89) set Z_ 0.0 
$node_(90) set X_ 2150 
$node_(90) set Y_ 751 
$node_(90) set Z_ 0.0 
$node_(91) set X_ 2775 
$node_(91) set Y_ 538 
$node_(91) set Z_ 0.0 
$node_(92) set X_ 2739 
$node_(92) set Y_ 586 
$node_(92) set Z_ 0.0 
$node_(93) set X_ 2361 
$node_(93) set Y_ 264 
$node_(93) set Z_ 0.0 
$node_(94) set X_ 1749 
$node_(94) set Y_ 222 
$node_(94) set Z_ 0.0 
$node_(95) set X_ 2032 
$node_(95) set Y_ 77 
$node_(95) set Z_ 0.0 
$node_(96) set X_ 703 
$node_(96) set Y_ 577 
$node_(96) set Z_ 0.0 
$node_(97) set X_ 119 
$node_(97) set Y_ 175 
$node_(97) set Z_ 0.0 
$node_(98) set X_ 793 
$node_(98) set Y_ 3 
$node_(98) set Z_ 0.0 
$node_(99) set X_ 1814 
$node_(99) set Y_ 399 
$node_(99) set Z_ 0.0 

# Generation of movements
$ns at 0.0 "$node_(0) setdest 1852 313 13.0" 
$ns at 25.026497341892338 "$node_(0) setdest 2194 701 14.0" 
$ns at 86.95907199346667 "$node_(0) setdest 1209 962 15.0" 
$ns at 267.0248366189476 "$node_(0) setdest 1130 458 7.0" 
$ns at 411.6235492050376 "$node_(0) setdest 150 1 13.0" 
$ns at 717.4163374879914 "$node_(0) setdest 2008 187 7.0" 
$ns at 0.0 "$node_(1) setdest 2388 770 4.0" 
$ns at 22.694356173387217 "$node_(1) setdest 1844 304 8.0" 
$ns at 80.31020397328933 "$node_(1) setdest 2606 671 6.0" 
$ns at 168.33008839551593 "$node_(1) setdest 2471 68 2.0" 
$ns at 303.7305950679404 "$node_(1) setdest 2020 716 8.0" 
$ns at 592.280965190281 "$node_(1) setdest 717 832 12.0" 
$ns at 0.0 "$node_(2) setdest 1905 390 9.0" 
$ns at 30.657333230238848 "$node_(2) setdest 2468 814 20.0" 
$ns at 111.50691219884143 "$node_(2) setdest 1847 24 19.0" 
$ns at 305.9026924162946 "$node_(2) setdest 2249 192 2.0" 
$ns at 442.3576217866904 "$node_(2) setdest 271 148 15.0" 
$ns at 721.4653773754185 "$node_(2) setdest 2756 635 7.0" 
$ns at 0.0 "$node_(3) setdest 1497 517 12.0" 
$ns at 111.60129127772248 "$node_(3) setdest 2452 573 16.0" 
$ns at 285.2821920832241 "$node_(3) setdest 1365 782 10.0" 
$ns at 421.8341764621629 "$node_(3) setdest 167 812 9.0" 
$ns at 570.8505097106257 "$node_(3) setdest 2215 4 17.0" 
$ns at 847.0925436029381 "$node_(3) setdest 330 308 18.0" 
$ns at 0.0 "$node_(4) setdest 724 461 5.0" 
$ns at 38.976214650922046 "$node_(4) setdest 242 200 11.0" 
$ns at 149.94506622388036 "$node_(4) setdest 906 478 8.0" 
$ns at 227.1206800094188 "$node_(4) setdest 1548 411 2.0" 
$ns at 351.32623260417006 "$node_(4) setdest 278 209 19.0" 
$ns at 621.4091875273784 "$node_(4) setdest 1800 419 3.0" 
$ns at 0.0 "$node_(5) setdest 2985 604 5.0" 
$ns at 22.1283368212138 "$node_(5) setdest 777 28 7.0" 
$ns at 114.75226180762243 "$node_(5) setdest 408 992 10.0" 
$ns at 184.4372975571222 "$node_(5) setdest 2944 204 8.0" 
$ns at 359.2168956063075 "$node_(5) setdest 1529 13 18.0" 
$ns at 612.5474822640962 "$node_(5) setdest 1228 330 12.0" 
$ns at 0.0 "$node_(6) setdest 1079 840 3.0" 
$ns at 32.02323986282964 "$node_(6) setdest 2991 444 13.0" 
$ns at 142.1241000923656 "$node_(6) setdest 2253 897 1.0" 
$ns at 208.50338668457937 "$node_(6) setdest 865 313 16.0" 
$ns at 407.4339133454686 "$node_(6) setdest 1515 540 6.0" 
$ns at 684.7141288713312 "$node_(6) setdest 1848 392 7.0" 
$ns at 0.0 "$node_(7) setdest 2774 401 8.0" 
$ns at 49.799822309920394 "$node_(7) setdest 808 41 10.0" 
$ns at 114.73165290122179 "$node_(7) setdest 2948 358 17.0" 
$ns at 302.80047122592885 "$node_(7) setdest 1312 548 1.0" 
$ns at 427.57952365115847 "$node_(7) setdest 2706 323 5.0" 
$ns at 696.1793210466069 "$node_(7) setdest 1412 806 11.0" 
$ns at 0.0 "$node_(8) setdest 912 330 10.0" 
$ns at 107.98380200741606 "$node_(8) setdest 808 725 11.0" 
$ns at 145.51099871706364 "$node_(8) setdest 1042 605 13.0" 
$ns at 310.640230930332 "$node_(8) setdest 2534 710 15.0" 
$ns at 537.6178458325877 "$node_(8) setdest 1608 591 19.0" 
$ns at 868.8195821691802 "$node_(8) setdest 1060 782 13.0" 
$ns at 0.0 "$node_(9) setdest 364 133 17.0" 
$ns at 154.10630157792255 "$node_(9) setdest 485 183 12.0" 
$ns at 263.63208279628486 "$node_(9) setdest 820 265 8.0" 
$ns at 351.6664145701475 "$node_(9) setdest 2194 541 10.0" 
$ns at 554.4515762252366 "$node_(9) setdest 1346 335 6.0" 
$ns at 798.1166658448566 "$node_(9) setdest 1162 922 13.0" 
$ns at 0.0 "$node_(10) setdest 1887 395 4.0" 
$ns at 23.91479611697902 "$node_(10) setdest 777 373 10.0" 
$ns at 102.4129622205691 "$node_(10) setdest 1074 80 5.0" 
$ns at 200.99053685985552 "$node_(10) setdest 2865 752 6.0" 
$ns at 341.9110036838248 "$node_(10) setdest 2245 433 4.0" 
$ns at 621.7276048822506 "$node_(10) setdest 2289 965 9.0" 
$ns at 0.0 "$node_(11) setdest 2674 373 18.0" 
$ns at 115.52046849275351 "$node_(11) setdest 1299 916 19.0" 
$ns at 221.45166599833325 "$node_(11) setdest 1014 777 13.0" 
$ns at 297.94224771539797 "$node_(11) setdest 2524 760 19.0" 
$ns at 447.7980024036049 "$node_(11) setdest 1746 363 11.0" 
$ns at 700.824704656579 "$node_(11) setdest 256 296 16.0" 
$ns at 0.0 "$node_(12) setdest 2154 859 15.0" 
$ns at 66.65062900094358 "$node_(12) setdest 2436 573 12.0" 
$ns at 207.0368316946604 "$node_(12) setdest 2107 135 1.0" 
$ns at 272.6651164051513 "$node_(12) setdest 2486 50 19.0" 
$ns at 468.38706098742955 "$node_(12) setdest 2675 282 14.0" 
$ns at 738.3981075718175 "$node_(12) setdest 902 882 18.0" 
$ns at 0.0 "$node_(13) setdest 2347 819 3.0" 
$ns at 40.73364756861182 "$node_(13) setdest 244 180 19.0" 
$ns at 122.77934773901563 "$node_(13) setdest 404 512 10.0" 
$ns at 190.4776909978727 "$node_(13) setdest 2936 300 1.0" 
$ns at 314.81166652923065 "$node_(13) setdest 2686 488 8.0" 
$ns at 625.0191831668585 "$node_(13) setdest 29 528 1.0" 
$ns at 0.0 "$node_(14) setdest 1818 618 1.0" 
$ns at 23.433240260001686 "$node_(14) setdest 2823 712 2.0" 
$ns at 63.23375172113576 "$node_(14) setdest 646 365 19.0" 
$ns at 231.79072556361513 "$node_(14) setdest 2004 693 8.0" 
$ns at 405.47057345535575 "$node_(14) setdest 1424 561 19.0" 
$ns at 675.1850851056811 "$node_(14) setdest 696 602 6.0" 
$ns at 0.0 "$node_(15) setdest 1026 821 10.0" 
$ns at 89.29254829854192 "$node_(15) setdest 1591 375 8.0" 
$ns at 186.5160191987947 "$node_(15) setdest 208 539 5.0" 
$ns at 267.27339936586895 "$node_(15) setdest 38 42 10.0" 
$ns at 424.76369527163575 "$node_(15) setdest 2696 689 9.0" 
$ns at 749.7370400781167 "$node_(15) setdest 2766 649 19.0" 
$ns at 0.0 "$node_(16) setdest 1638 877 1.0" 
$ns at 16.61863759418904 "$node_(16) setdest 2627 868 19.0" 
$ns at 90.88657220837894 "$node_(16) setdest 2684 360 12.0" 
$ns at 268.6461810736566 "$node_(16) setdest 2521 658 4.0" 
$ns at 419.85883810320206 "$node_(16) setdest 1726 973 4.0" 
$ns at 673.1695809920171 "$node_(16) setdest 2404 523 5.0" 
$ns at 0.0 "$node_(17) setdest 1085 196 2.0" 
$ns at 25.700710683498595 "$node_(17) setdest 2022 237 3.0" 
$ns at 67.49784142271926 "$node_(17) setdest 1649 790 16.0" 
$ns at 267.01249145062434 "$node_(17) setdest 787 82 11.0" 
$ns at 399.45450115839975 "$node_(17) setdest 2272 734 13.0" 
$ns at 690.563668235189 "$node_(17) setdest 942 961 9.0" 
$ns at 0.0 "$node_(18) setdest 2428 402 7.0" 
$ns at 29.604963432465436 "$node_(18) setdest 2908 948 13.0" 
$ns at 179.4612874528602 "$node_(18) setdest 1920 196 2.0" 
$ns at 255.4055038073102 "$node_(18) setdest 484 117 6.0" 
$ns at 396.42716966163465 "$node_(18) setdest 1165 91 12.0" 
$ns at 648.132577540598 "$node_(18) setdest 2286 729 17.0" 
$ns at 0.0 "$node_(19) setdest 330 796 11.0" 
$ns at 59.22638344061733 "$node_(19) setdest 1584 107 14.0" 
$ns at 169.43993439654483 "$node_(19) setdest 2343 492 3.0" 
$ns at 239.12256718641862 "$node_(19) setdest 440 788 10.0" 
$ns at 440.3489706410593 "$node_(19) setdest 1573 351 7.0" 
$ns at 704.7590410729256 "$node_(19) setdest 2798 771 5.0" 
$ns at 0.0 "$node_(20) setdest 678 292 4.0" 
$ns at 45.5891080473139 "$node_(20) setdest 2926 964 3.0" 
$ns at 85.72076271005142 "$node_(20) setdest 2934 689 19.0" 
$ns at 326.3329726645996 "$node_(20) setdest 2372 137 18.0" 
$ns at 612.8740293248941 "$node_(20) setdest 34 975 8.0" 
$ns at 879.3242844578324 "$node_(20) setdest 2316 980 10.0" 
$ns at 0.0 "$node_(21) setdest 169 363 12.0" 
$ns at 74.15308701690114 "$node_(21) setdest 2999 100 1.0" 
$ns at 105.9360726335552 "$node_(21) setdest 894 126 11.0" 
$ns at 193.20889452403276 "$node_(21) setdest 604 17 1.0" 
$ns at 320.6692485263563 "$node_(21) setdest 1068 161 17.0" 
$ns at 670.4263725246913 "$node_(21) setdest 2757 524 2.0" 
$ns at 0.0 "$node_(22) setdest 2894 776 18.0" 
$ns at 54.839889188322 "$node_(22) setdest 550 964 6.0" 
$ns at 114.69070691080435 "$node_(22) setdest 829 919 19.0" 
$ns at 362.62838170487487 "$node_(22) setdest 728 272 8.0" 
$ns at 489.5791771274669 "$node_(22) setdest 2909 305 2.0" 
$ns at 748.6368975674274 "$node_(22) setdest 456 855 3.0" 
$ns at 0.0 "$node_(23) setdest 1739 136 17.0" 
$ns at 41.16738813131412 "$node_(23) setdest 806 657 16.0" 
$ns at 181.05174203026215 "$node_(23) setdest 2205 393 5.0" 
$ns at 267.3262690140898 "$node_(23) setdest 2875 966 5.0" 
$ns at 403.8848764044593 "$node_(23) setdest 662 884 11.0" 
$ns at 651.9090071613447 "$node_(23) setdest 184 824 10.0" 
$ns at 0.0 "$node_(24) setdest 141 522 6.0" 
$ns at 23.976525501278775 "$node_(24) setdest 2755 97 12.0" 
$ns at 94.91473844110077 "$node_(24) setdest 2841 528 8.0" 
$ns at 222.72261855131774 "$node_(24) setdest 30 556 10.0" 
$ns at 370.7073490462607 "$node_(24) setdest 2939 529 4.0" 
$ns at 641.6387712056687 "$node_(24) setdest 1517 534 18.0" 
$ns at 0.0 "$node_(25) setdest 502 740 9.0" 
$ns at 80.4158355807688 "$node_(25) setdest 839 7 7.0" 
$ns at 179.12538404954546 "$node_(25) setdest 1006 709 9.0" 
$ns at 244.11547110168556 "$node_(25) setdest 562 172 3.0" 
$ns at 382.661355797399 "$node_(25) setdest 1772 312 6.0" 
$ns at 664.6402849716994 "$node_(25) setdest 1976 854 9.0" 
$ns at 0.0 "$node_(26) setdest 315 970 12.0" 
$ns at 39.29648809523265 "$node_(26) setdest 2718 328 9.0" 
$ns at 102.95713690812242 "$node_(26) setdest 404 281 19.0" 
$ns at 201.0928874710022 "$node_(26) setdest 897 386 16.0" 
$ns at 455.95476429401214 "$node_(26) setdest 1349 539 12.0" 
$ns at 716.1221387091928 "$node_(26) setdest 2117 727 1.0" 
$ns at 0.0 "$node_(27) setdest 1805 838 12.0" 
$ns at 66.53578087109314 "$node_(27) setdest 2557 11 7.0" 
$ns at 151.52483426465477 "$node_(27) setdest 2099 717 13.0" 
$ns at 304.65371221056614 "$node_(27) setdest 6 154 13.0" 
$ns at 520.7400743006708 "$node_(27) setdest 1883 556 20.0" 
$ns at 0.0 "$node_(28) setdest 1503 690 9.0" 
$ns at 29.846454659052206 "$node_(28) setdest 2621 185 18.0" 
$ns at 212.56803271561347 "$node_(28) setdest 2993 296 17.0" 
$ns at 402.97235474278745 "$node_(28) setdest 1195 401 16.0" 
$ns at 666.705146886922 "$node_(28) setdest 1142 798 1.0" 
$ns at 0.0 "$node_(29) setdest 658 363 4.0" 
$ns at 18.676639351494636 "$node_(29) setdest 2222 249 14.0" 
$ns at 69.33882645375854 "$node_(29) setdest 1906 60 15.0" 
$ns at 252.01992708245507 "$node_(29) setdest 2705 909 5.0" 
$ns at 387.1427155160229 "$node_(29) setdest 808 319 19.0" 
$ns at 656.3942903068017 "$node_(29) setdest 988 205 12.0" 
$ns at 0.0 "$node_(30) setdest 1055 56 17.0" 
$ns at 143.33820466231572 "$node_(30) setdest 1384 11 10.0" 
$ns at 239.8738552981863 "$node_(30) setdest 2766 726 7.0" 
$ns at 330.50571368554296 "$node_(30) setdest 2285 817 12.0" 
$ns at 500.20000684081117 "$node_(30) setdest 2632 176 17.0" 
$ns at 0.0 "$node_(31) setdest 160 641 17.0" 
$ns at 107.65468531137681 "$node_(31) setdest 111 372 20.0" 
$ns at 321.90473028715473 "$node_(31) setdest 2778 735 7.0" 
$ns at 412.6246269737956 "$node_(31) setdest 1964 688 3.0" 
$ns at 542.550554548429 "$node_(31) setdest 811 451 1.0" 
$ns at 788.1993156750129 "$node_(31) setdest 158 724 9.0" 
$ns at 0.0 "$node_(32) setdest 723 819 14.0" 
$ns at 127.53443224672621 "$node_(32) setdest 904 868 4.0" 
$ns at 189.5520525999674 "$node_(32) setdest 600 695 15.0" 
$ns at 256.1633241518807 "$node_(32) setdest 371 36 4.0" 
$ns at 380.13823092366533 "$node_(32) setdest 1310 533 12.0" 
$ns at 673.6233693098552 "$node_(32) setdest 1338 325 18.0" 
$ns at 0.0 "$node_(33) setdest 2158 146 16.0" 
$ns at 17.6814084857825 "$node_(33) setdest 829 513 3.0" 
$ns at 66.56420491258801 "$node_(33) setdest 2941 5 13.0" 
$ns at 178.09645010483172 "$node_(33) setdest 2491 624 15.0" 
$ns at 360.5529544648923 "$node_(33) setdest 2036 936 1.0" 
$ns at 610.4479489661185 "$node_(33) setdest 254 21 15.0" 
$ns at 0.0 "$node_(34) setdest 1949 273 11.0" 
$ns at 108.17509934544445 "$node_(34) setdest 547 713 14.0" 
$ns at 208.8361160082831 "$node_(34) setdest 1453 823 8.0" 
$ns at 343.8013606995354 "$node_(34) setdest 1095 857 16.0" 
$ns at 619.420669196361 "$node_(34) setdest 2241 201 1.0" 
$ns at 866.4254229132789 "$node_(34) setdest 1077 648 1.0" 
$ns at 0.0 "$node_(35) setdest 1720 385 3.0" 
$ns at 16.09383080658448 "$node_(35) setdest 1174 58 13.0" 
$ns at 149.32191670672165 "$node_(35) setdest 1380 569 18.0" 
$ns at 229.46066906064965 "$node_(35) setdest 776 125 7.0" 
$ns at 401.258212039054 "$node_(35) setdest 852 635 6.0" 
$ns at 679.6129616611495 "$node_(35) setdest 389 767 3.0" 
$ns at 0.0 "$node_(36) setdest 2599 846 4.0" 
$ns at 35.711237432122694 "$node_(36) setdest 6 302 6.0" 
$ns at 71.24891572761166 "$node_(36) setdest 1858 568 2.0" 
$ns at 150.8916703807671 "$node_(36) setdest 2975 153 1.0" 
$ns at 273.56709505775615 "$node_(36) setdest 252 131 12.0" 
$ns at 591.9572483230138 "$node_(36) setdest 2647 434 16.0" 
$ns at 0.0 "$node_(37) setdest 1223 131 7.0" 
$ns at 24.512675923369635 "$node_(37) setdest 1821 374 3.0" 
$ns at 82.60330958254625 "$node_(37) setdest 188 778 5.0" 
$ns at 145.4763042540064 "$node_(37) setdest 1767 798 8.0" 
$ns at 343.499645510591 "$node_(37) setdest 1065 115 14.0" 
$ns at 680.4472078182499 "$node_(37) setdest 356 97 15.0" 
$ns at 0.0 "$node_(38) setdest 1576 184 7.0" 
$ns at 54.722651532671705 "$node_(38) setdest 582 427 17.0" 
$ns at 211.23407698977377 "$node_(38) setdest 1482 480 1.0" 
$ns at 278.139216819341 "$node_(38) setdest 1479 64 2.0" 
$ns at 411.33337571405684 "$node_(38) setdest 1645 270 8.0" 
$ns at 675.3581448418097 "$node_(38) setdest 1242 140 10.0" 
$ns at 0.0 "$node_(39) setdest 1578 604 6.0" 
$ns at 31.738897718096307 "$node_(39) setdest 1056 214 19.0" 
$ns at 193.301845829883 "$node_(39) setdest 873 121 8.0" 
$ns at 303.17180673938253 "$node_(39) setdest 1918 375 4.0" 
$ns at 450.23811194376265 "$node_(39) setdest 1677 950 8.0" 
$ns at 739.7791797209982 "$node_(39) setdest 2480 853 2.0" 
$ns at 0.0 "$node_(40) setdest 1099 316 9.0" 
$ns at 70.17372070125576 "$node_(40) setdest 694 321 13.0" 
$ns at 164.88682930251292 "$node_(40) setdest 2216 668 11.0" 
$ns at 282.6821184005622 "$node_(40) setdest 2776 371 5.0" 
$ns at 428.4871271842089 "$node_(40) setdest 1072 420 2.0" 
$ns at 678.5194332820918 "$node_(40) setdest 1777 850 16.0" 
$ns at 0.0 "$node_(41) setdest 825 623 18.0" 
$ns at 76.69048067304611 "$node_(41) setdest 2780 21 13.0" 
$ns at 147.86999509852845 "$node_(41) setdest 2939 167 13.0" 
$ns at 287.4999215014831 "$node_(41) setdest 1507 758 17.0" 
$ns at 532.2050442667777 "$node_(41) setdest 1088 337 9.0" 
$ns at 823.0188880174913 "$node_(41) setdest 862 232 1.0" 
$ns at 0.0 "$node_(42) setdest 1156 802 17.0" 
$ns at 63.259462736114386 "$node_(42) setdest 681 791 9.0" 
$ns at 113.8514190977167 "$node_(42) setdest 1493 375 19.0" 
$ns at 304.5063573123067 "$node_(42) setdest 1722 990 11.0" 
$ns at 474.35729331055074 "$node_(42) setdest 341 117 12.0" 
$ns at 747.9706932356178 "$node_(42) setdest 2680 989 4.0" 
$ns at 0.0 "$node_(43) setdest 2056 638 18.0" 
$ns at 159.93117193376756 "$node_(43) setdest 2732 759 16.0" 
$ns at 192.73762877015957 "$node_(43) setdest 559 645 2.0" 
$ns at 256.5809284769127 "$node_(43) setdest 1915 820 11.0" 
$ns at 476.38193438004174 "$node_(43) setdest 138 98 14.0" 
$ns at 777.8077262671027 "$node_(43) setdest 1345 455 20.0" 
$ns at 0.0 "$node_(44) setdest 2536 541 17.0" 
$ns at 70.37958706666298 "$node_(44) setdest 67 617 4.0" 
$ns at 108.9834775938436 "$node_(44) setdest 942 445 3.0" 
$ns at 172.23345479472258 "$node_(44) setdest 1056 973 2.0" 
$ns at 306.774333333174 "$node_(44) setdest 1316 640 4.0" 
$ns at 569.8958366207352 "$node_(44) setdest 648 815 6.0" 
$ns at 0.0 "$node_(45) setdest 2189 173 13.0" 
$ns at 33.2528502543744 "$node_(45) setdest 2430 762 1.0" 
$ns at 69.49437561805536 "$node_(45) setdest 2837 178 1.0" 
$ns at 137.5187202711321 "$node_(45) setdest 1366 496 14.0" 
$ns at 390.4512531059846 "$node_(45) setdest 2488 578 14.0" 
$ns at 660.4944939839272 "$node_(45) setdest 1682 954 6.0" 
$ns at 0.0 "$node_(46) setdest 1959 707 10.0" 
$ns at 31.188599986593932 "$node_(46) setdest 796 721 17.0" 
$ns at 194.2575652379107 "$node_(46) setdest 1880 194 18.0" 
$ns at 280.97831189232363 "$node_(46) setdest 1313 540 2.0" 
$ns at 420.08747643301524 "$node_(46) setdest 1407 669 1.0" 
$ns at 669.7902353381403 "$node_(46) setdest 2864 179 14.0" 
$ns at 0.0 "$node_(47) setdest 2069 148 8.0" 
$ns at 48.64457994717678 "$node_(47) setdest 1317 98 4.0" 
$ns at 82.11125277742134 "$node_(47) setdest 1164 157 15.0" 
$ns at 220.43840114565046 "$node_(47) setdest 2639 622 2.0" 
$ns at 356.4988801950956 "$node_(47) setdest 1840 942 18.0" 
$ns at 764.2460974973293 "$node_(47) setdest 2432 578 2.0" 
$ns at 0.0 "$node_(48) setdest 1784 344 15.0" 
$ns at 76.63423506327113 "$node_(48) setdest 2927 610 11.0" 
$ns at 165.37770624847366 "$node_(48) setdest 1151 161 17.0" 
$ns at 311.33928164617794 "$node_(48) setdest 1957 623 5.0" 
$ns at 464.94583056820017 "$node_(48) setdest 2149 96 18.0" 
$ns at 855.1977620546448 "$node_(48) setdest 187 55 6.0" 
$ns at 0.0 "$node_(49) setdest 424 608 10.0" 
$ns at 77.48614245229022 "$node_(49) setdest 1631 958 5.0" 
$ns at 122.85283574056902 "$node_(49) setdest 2154 255 12.0" 
$ns at 229.84704278467103 "$node_(49) setdest 1239 63 10.0" 
$ns at 388.277212689139 "$node_(49) setdest 2501 362 19.0" 
$ns at 800.9725718885564 "$node_(49) setdest 2062 319 8.0" 
$ns at 0.0 "$node_(50) setdest 2823 95 19.0" 
$ns at 178.7704549230657 "$node_(50) setdest 297 581 5.0" 
$ns at 241.63884837152264 "$node_(50) setdest 800 266 3.0" 
$ns at 326.47836949265104 "$node_(50) setdest 220 434 16.0" 
$ns at 480.5360211354363 "$node_(50) setdest 2370 465 19.0" 
$ns at 811.688456624963 "$node_(50) setdest 1797 338 5.0" 
$ns at 0.0 "$node_(51) setdest 144 336 15.0" 
$ns at 38.36125074183565 "$node_(51) setdest 488 559 3.0" 
$ns at 92.48526870417317 "$node_(51) setdest 1680 94 1.0" 
$ns at 154.4062140765791 "$node_(51) setdest 540 598 13.0" 
$ns at 332.68725380676915 "$node_(51) setdest 2782 599 5.0" 
$ns at 605.7131122694867 "$node_(51) setdest 1771 61 7.0" 
$ns at 0.0 "$node_(52) setdest 2730 584 17.0" 
$ns at 84.16043493600337 "$node_(52) setdest 1647 200 2.0" 
$ns at 130.5500836350394 "$node_(52) setdest 81 857 12.0" 
$ns at 254.70305315768272 "$node_(52) setdest 1163 552 17.0" 
$ns at 448.44498154368057 "$node_(52) setdest 1448 568 1.0" 
$ns at 695.7304160427766 "$node_(52) setdest 814 412 11.0" 
$ns at 0.0 "$node_(53) setdest 1417 871 4.0" 
$ns at 17.476846355425117 "$node_(53) setdest 676 76 19.0" 
$ns at 181.68367224519727 "$node_(53) setdest 495 554 6.0" 
$ns at 252.6562967063734 "$node_(53) setdest 1382 74 18.0" 
$ns at 378.99935493475937 "$node_(53) setdest 2740 483 11.0" 
$ns at 621.6268937287405 "$node_(53) setdest 519 844 2.0" 
$ns at 0.0 "$node_(54) setdest 1489 935 19.0" 
$ns at 96.51827335235467 "$node_(54) setdest 713 553 7.0" 
$ns at 136.27934877200536 "$node_(54) setdest 1321 150 1.0" 
$ns at 199.71589052154283 "$node_(54) setdest 1448 25 5.0" 
$ns at 357.79598980539197 "$node_(54) setdest 2161 685 5.0" 
$ns at 620.8300802542386 "$node_(54) setdest 1377 988 15.0" 
$ns at 0.0 "$node_(55) setdest 1191 411 16.0" 
$ns at 89.97101818008227 "$node_(55) setdest 2665 79 11.0" 
$ns at 184.01112070926314 "$node_(55) setdest 2943 219 4.0" 
$ns at 255.8099432833199 "$node_(55) setdest 642 343 13.0" 
$ns at 505.7101814855786 "$node_(55) setdest 1757 782 19.0" 
$ns at 0.0 "$node_(56) setdest 2779 149 14.0" 
$ns at 120.22520668564786 "$node_(56) setdest 487 942 8.0" 
$ns at 162.2273702204571 "$node_(56) setdest 1783 761 9.0" 
$ns at 289.25905918908836 "$node_(56) setdest 1105 569 13.0" 
$ns at 410.17300809968197 "$node_(56) setdest 2325 999 18.0" 
$ns at 663.8439716427869 "$node_(56) setdest 2626 960 9.0" 
$ns at 0.0 "$node_(57) setdest 685 712 16.0" 
$ns at 80.1472252465475 "$node_(57) setdest 481 116 9.0" 
$ns at 174.4500782052168 "$node_(57) setdest 340 7 7.0" 
$ns at 276.33602491032957 "$node_(57) setdest 260 481 18.0" 
$ns at 447.089721032978 "$node_(57) setdest 269 451 14.0" 
$ns at 703.785073558013 "$node_(57) setdest 2465 970 15.0" 
$ns at 0.0 "$node_(58) setdest 1506 701 7.0" 
$ns at 15.69488296520755 "$node_(58) setdest 2680 377 5.0" 
$ns at 67.30982238538547 "$node_(58) setdest 218 267 8.0" 
$ns at 160.08686454263346 "$node_(58) setdest 1317 478 8.0" 
$ns at 340.27014018274576 "$node_(58) setdest 2336 359 16.0" 
$ns at 728.0531486201784 "$node_(58) setdest 2824 434 6.0" 
$ns at 0.0 "$node_(59) setdest 2512 43 4.0" 
$ns at 28.848411741191505 "$node_(59) setdest 21 306 4.0" 
$ns at 86.6989879564959 "$node_(59) setdest 2935 142 15.0" 
$ns at 223.48038416073874 "$node_(59) setdest 2967 774 11.0" 
$ns at 379.5510617230225 "$node_(59) setdest 1278 607 1.0" 
$ns at 622.4699873162515 "$node_(59) setdest 1498 390 19.0" 
$ns at 0.0 "$node_(60) setdest 808 297 1.0" 
$ns at 15.0694814641876 "$node_(60) setdest 348 948 20.0" 
$ns at 153.0098112991971 "$node_(60) setdest 438 394 19.0" 
$ns at 360.2938452911537 "$node_(60) setdest 2509 801 4.0" 
$ns at 517.5551122445052 "$node_(60) setdest 1234 894 14.0" 
$ns at 836.6659342253952 "$node_(60) setdest 220 210 16.0" 
$ns at 0.0 "$node_(61) setdest 677 895 8.0" 
$ns at 92.82584137301362 "$node_(61) setdest 747 50 9.0" 
$ns at 205.59201639356115 "$node_(61) setdest 691 624 2.0" 
$ns at 285.4635371344896 "$node_(61) setdest 850 467 13.0" 
$ns at 485.0563139138428 "$node_(61) setdest 2213 424 4.0" 
$ns at 737.3065167193356 "$node_(61) setdest 1601 306 4.0" 
$ns at 0.0 "$node_(62) setdest 1849 147 8.0" 
$ns at 82.30698022295755 "$node_(62) setdest 2937 401 18.0" 
$ns at 176.1446812102917 "$node_(62) setdest 873 670 14.0" 
$ns at 327.313959682027 "$node_(62) setdest 2116 51 9.0" 
$ns at 481.2724348745721 "$node_(62) setdest 1612 483 15.0" 
$ns at 774.1624213585819 "$node_(62) setdest 2972 271 3.0" 
$ns at 0.0 "$node_(63) setdest 2986 559 5.0" 
$ns at 48.03143053168893 "$node_(63) setdest 1623 650 12.0" 
$ns at 168.94167149853948 "$node_(63) setdest 1729 965 19.0" 
$ns at 377.9009565604571 "$node_(63) setdest 2030 887 17.0" 
$ns at 554.2941113441977 "$node_(63) setdest 578 916 3.0" 
$ns at 815.3197356021512 "$node_(63) setdest 1567 357 19.0" 
$ns at 0.0 "$node_(64) setdest 1450 236 1.0" 
$ns at 20.84880029855782 "$node_(64) setdest 1496 263 9.0" 
$ns at 100.56794364838291 "$node_(64) setdest 1378 424 14.0" 
$ns at 286.7209118394108 "$node_(64) setdest 2008 237 7.0" 
$ns at 474.3153432171798 "$node_(64) setdest 755 794 16.0" 
$ns at 864.8651628830861 "$node_(64) setdest 2224 442 4.0" 
$ns at 0.0 "$node_(65) setdest 1132 384 17.0" 
$ns at 153.7484734508667 "$node_(65) setdest 2311 524 13.0" 
$ns at 237.80490536662063 "$node_(65) setdest 632 597 14.0" 
$ns at 323.15504236171864 "$node_(65) setdest 2625 1 18.0" 
$ns at 565.4420789409781 "$node_(65) setdest 1725 783 17.0" 
$ns at 839.8755997322587 "$node_(65) setdest 1514 896 10.0" 
$ns at 0.0 "$node_(66) setdest 1918 211 13.0" 
$ns at 86.18662958569479 "$node_(66) setdest 201 731 2.0" 
$ns at 120.83668148033709 "$node_(66) setdest 1615 152 15.0" 
$ns at 241.9875811605467 "$node_(66) setdest 2889 179 5.0" 
$ns at 406.2821387148433 "$node_(66) setdest 1195 11 13.0" 
$ns at 754.1348808635876 "$node_(66) setdest 997 988 1.0" 
$ns at 0.0 "$node_(67) setdest 2069 734 10.0" 
$ns at 102.2522002630197 "$node_(67) setdest 176 980 1.0" 
$ns at 133.30188723202053 "$node_(67) setdest 249 933 6.0" 
$ns at 214.898563734297 "$node_(67) setdest 2501 228 8.0" 
$ns at 357.3411454211356 "$node_(67) setdest 714 446 2.0" 
$ns at 602.2914457390368 "$node_(67) setdest 1009 738 12.0" 
$ns at 0.0 "$node_(68) setdest 585 280 6.0" 
$ns at 67.49058260432415 "$node_(68) setdest 2464 208 20.0" 
$ns at 198.85887353186635 "$node_(68) setdest 896 150 14.0" 
$ns at 345.89057467296846 "$node_(68) setdest 2020 711 2.0" 
$ns at 468.2490773822342 "$node_(68) setdest 2497 71 1.0" 
$ns at 715.6246391760274 "$node_(68) setdest 2167 372 6.0" 
$ns at 0.0 "$node_(69) setdest 2341 711 1.0" 
$ns at 18.649695496265903 "$node_(69) setdest 1131 380 16.0" 
$ns at 195.8524834193416 "$node_(69) setdest 1209 450 12.0" 
$ns at 258.826323559334 "$node_(69) setdest 2611 909 17.0" 
$ns at 478.4245974731764 "$node_(69) setdest 1633 372 5.0" 
$ns at 722.636066489124 "$node_(69) setdest 524 784 1.0" 
$ns at 0.0 "$node_(70) setdest 2557 635 3.0" 
$ns at 44.29654736385005 "$node_(70) setdest 1145 981 10.0" 
$ns at 128.83079346812661 "$node_(70) setdest 996 920 4.0" 
$ns at 196.50874425597354 "$node_(70) setdest 1802 276 17.0" 
$ns at 421.23942250475307 "$node_(70) setdest 2744 933 5.0" 
$ns at 676.7079311557407 "$node_(70) setdest 2029 641 16.0" 
$ns at 0.0 "$node_(71) setdest 2884 153 18.0" 
$ns at 120.96002735877431 "$node_(71) setdest 826 212 9.0" 
$ns at 234.36122046179216 "$node_(71) setdest 2648 288 10.0" 
$ns at 383.62512679787903 "$node_(71) setdest 427 911 16.0" 
$ns at 619.0586299683373 "$node_(71) setdest 885 150 4.0" 
$ns at 897.39904821917 "$node_(71) setdest 1740 57 3.0" 
$ns at 0.0 "$node_(72) setdest 1187 894 19.0" 
$ns at 69.78824116711411 "$node_(72) setdest 1338 545 15.0" 
$ns at 186.5203159780649 "$node_(72) setdest 1425 844 3.0" 
$ns at 251.8614615285453 "$node_(72) setdest 682 425 14.0" 
$ns at 469.8894113218154 "$node_(72) setdest 2245 351 18.0" 
$ns at 827.6302006875553 "$node_(72) setdest 2955 968 12.0" 
$ns at 0.0 "$node_(73) setdest 2788 392 8.0" 
$ns at 42.069241667219934 "$node_(73) setdest 671 540 19.0" 
$ns at 253.48706273287394 "$node_(73) setdest 659 875 5.0" 
$ns at 338.95421808243225 "$node_(73) setdest 2961 884 19.0" 
$ns at 515.1673490423167 "$node_(73) setdest 1941 845 3.0" 
$ns at 781.5844894112654 "$node_(73) setdest 2182 621 4.0" 
$ns at 0.0 "$node_(74) setdest 2757 58 19.0" 
$ns at 179.3261034085288 "$node_(74) setdest 2260 68 17.0" 
$ns at 269.74805295392963 "$node_(74) setdest 671 624 1.0" 
$ns at 333.191910561496 "$node_(74) setdest 909 700 16.0" 
$ns at 477.8182195397088 "$node_(74) setdest 1961 679 3.0" 
$ns at 724.2912158741751 "$node_(74) setdest 1641 831 6.0" 
$ns at 0.0 "$node_(75) setdest 523 291 1.0" 
$ns at 17.3015900206069 "$node_(75) setdest 204 360 11.0" 
$ns at 113.18732842573068 "$node_(75) setdest 950 63 17.0" 
$ns at 325.74752245714285 "$node_(75) setdest 1869 653 8.0" 
$ns at 498.8884442669513 "$node_(75) setdest 56 126 15.0" 
$ns at 810.0052070084604 "$node_(75) setdest 700 898 19.0" 
$ns at 0.0 "$node_(76) setdest 874 498 8.0" 
$ns at 39.394570878714816 "$node_(76) setdest 2720 508 7.0" 
$ns at 108.81654848105205 "$node_(76) setdest 1902 999 3.0" 
$ns at 169.92254470210128 "$node_(76) setdest 1626 418 10.0" 
$ns at 342.88400914982475 "$node_(76) setdest 1134 193 1.0" 
$ns at 587.642421410211 "$node_(76) setdest 2444 346 1.0" 
$ns at 0.0 "$node_(77) setdest 1136 48 12.0" 
$ns at 27.63126952997618 "$node_(77) setdest 296 348 4.0" 
$ns at 94.65805682357052 "$node_(77) setdest 2216 294 18.0" 
$ns at 251.13960877080433 "$node_(77) setdest 2159 267 4.0" 
$ns at 377.12552891730377 "$node_(77) setdest 1448 656 20.0" 
$ns at 698.6134703659656 "$node_(77) setdest 287 882 11.0" 
$ns at 0.0 "$node_(78) setdest 1086 450 7.0" 
$ns at 50.622219948482886 "$node_(78) setdest 1685 863 14.0" 
$ns at 178.25756797011377 "$node_(78) setdest 639 226 13.0" 
$ns at 256.61794454204585 "$node_(78) setdest 2798 848 14.0" 
$ns at 399.1177522535776 "$node_(78) setdest 1644 426 6.0" 
$ns at 698.4000618635242 "$node_(78) setdest 308 232 20.0" 
$ns at 0.0 "$node_(79) setdest 906 263 19.0" 
$ns at 18.00438791207086 "$node_(79) setdest 696 501 20.0" 
$ns at 125.6404383762613 "$node_(79) setdest 2732 272 19.0" 
$ns at 218.49393174993781 "$node_(79) setdest 976 179 15.0" 
$ns at 446.64061078164013 "$node_(79) setdest 449 250 4.0" 
$ns at 722.9055976710004 "$node_(79) setdest 740 746 10.0" 
$ns at 0.0 "$node_(80) setdest 1209 535 19.0" 
$ns at 160.90971620348162 "$node_(80) setdest 1432 80 19.0" 
$ns at 360.8280835268295 "$node_(80) setdest 886 830 14.0" 
$ns at 508.1342228677194 "$node_(80) setdest 493 281 10.0" 
$ns at 666.2176919575352 "$node_(80) setdest 2574 33 6.0" 
$ns at 0.0 "$node_(81) setdest 781 934 15.0" 
$ns at 118.27031777531626 "$node_(81) setdest 1967 784 2.0" 
$ns at 154.12486082768692 "$node_(81) setdest 2419 169 8.0" 
$ns at 249.95649054463007 "$node_(81) setdest 1657 669 17.0" 
$ns at 534.6090298558605 "$node_(81) setdest 1983 79 19.0" 
$ns at 894.0077916636085 "$node_(81) setdest 110 315 9.0" 
$ns at 0.0 "$node_(82) setdest 657 337 13.0" 
$ns at 38.05742839367334 "$node_(82) setdest 867 802 9.0" 
$ns at 129.7530035523392 "$node_(82) setdest 2792 96 8.0" 
$ns at 207.1896724165504 "$node_(82) setdest 1232 128 4.0" 
$ns at 333.311373427202 "$node_(82) setdest 1986 497 13.0" 
$ns at 631.8188424490577 "$node_(82) setdest 1488 665 7.0" 
$ns at 0.0 "$node_(83) setdest 618 376 17.0" 
$ns at 125.23223197463162 "$node_(83) setdest 1399 817 16.0" 
$ns at 186.52151120257642 "$node_(83) setdest 1467 993 14.0" 
$ns at 302.9384545700552 "$node_(83) setdest 2551 341 10.0" 
$ns at 470.13835249147945 "$node_(83) setdest 828 873 13.0" 
$ns at 774.5636894072823 "$node_(83) setdest 2782 42 6.0" 
$ns at 0.0 "$node_(84) setdest 1276 81 17.0" 
$ns at 109.84180434138769 "$node_(84) setdest 2752 780 8.0" 
$ns at 174.28683194768266 "$node_(84) setdest 2978 529 5.0" 
$ns at 279.52879980594605 "$node_(84) setdest 416 20 13.0" 
$ns at 439.3099626235278 "$node_(84) setdest 2212 125 14.0" 
$ns at 775.6552744800523 "$node_(84) setdest 930 370 9.0" 
$ns at 0.0 "$node_(85) setdest 2482 873 2.0" 
$ns at 30.295316961366588 "$node_(85) setdest 1275 807 4.0" 
$ns at 86.07145309190395 "$node_(85) setdest 2397 224 1.0" 
$ns at 155.31111832429647 "$node_(85) setdest 2610 566 17.0" 
$ns at 433.2627915846325 "$node_(85) setdest 207 298 13.0" 
$ns at 721.2117847598305 "$node_(85) setdest 2154 884 7.0" 
$ns at 0.0 "$node_(86) setdest 1652 765 19.0" 
$ns at 128.1517035369171 "$node_(86) setdest 1098 61 2.0" 
$ns at 174.6140138113103 "$node_(86) setdest 516 514 15.0" 
$ns at 244.44040658111132 "$node_(86) setdest 2853 547 18.0" 
$ns at 517.991381961163 "$node_(86) setdest 1062 399 16.0" 
$ns at 808.3958665176767 "$node_(86) setdest 635 9 5.0" 
$ns at 0.0 "$node_(87) setdest 2225 677 16.0" 
$ns at 78.44637605893593 "$node_(87) setdest 2181 589 5.0" 
$ns at 135.13841013229555 "$node_(87) setdest 2225 946 11.0" 
$ns at 282.74443296086224 "$node_(87) setdest 2117 802 9.0" 
$ns at 440.78205905043853 "$node_(87) setdest 2012 689 17.0" 
$ns at 718.7971081040091 "$node_(87) setdest 2258 793 9.0" 
$ns at 0.0 "$node_(88) setdest 1677 724 19.0" 
$ns at 188.6164156384508 "$node_(88) setdest 863 898 7.0" 
$ns at 271.2299949625541 "$node_(88) setdest 2748 182 1.0" 
$ns at 334.6625608480245 "$node_(88) setdest 1631 722 5.0" 
$ns at 486.03355063229924 "$node_(88) setdest 11 804 5.0" 
$ns at 750.9224979155754 "$node_(88) setdest 950 196 20.0" 
$ns at 0.0 "$node_(89) setdest 1267 672 1.0" 
$ns at 15.899739305577839 "$node_(89) setdest 2698 305 9.0" 
$ns at 57.49998441415224 "$node_(89) setdest 172 689 12.0" 
$ns at 161.97057405027417 "$node_(89) setdest 2601 464 19.0" 
$ns at 347.3771539730909 "$node_(89) setdest 2066 389 4.0" 
$ns at 604.4873312044213 "$node_(89) setdest 1942 729 19.0" 
$ns at 0.0 "$node_(90) setdest 2439 923 11.0" 
$ns at 28.078523795007648 "$node_(90) setdest 137 318 16.0" 
$ns at 125.67551263525499 "$node_(90) setdest 1442 284 19.0" 
$ns at 191.33584678466454 "$node_(90) setdest 466 133 10.0" 
$ns at 358.8992942002935 "$node_(90) setdest 589 123 11.0" 
$ns at 610.4860101161571 "$node_(90) setdest 979 254 7.0" 
$ns at 0.0 "$node_(91) setdest 560 715 15.0" 
$ns at 141.97648662178713 "$node_(91) setdest 350 598 11.0" 
$ns at 176.7086192568424 "$node_(91) setdest 1748 936 3.0" 
$ns at 243.2526666189217 "$node_(91) setdest 1222 222 3.0" 
$ns at 384.2171459923055 "$node_(91) setdest 958 301 13.0" 
$ns at 710.2606865393566 "$node_(91) setdest 303 941 19.0" 
$ns at 0.0 "$node_(92) setdest 2417 424 9.0" 
$ns at 92.3168944971123 "$node_(92) setdest 253 263 19.0" 
$ns at 301.2095039291829 "$node_(92) setdest 1979 460 17.0" 
$ns at 384.6640816834766 "$node_(92) setdest 1131 807 15.0" 
$ns at 623.2040188728301 "$node_(92) setdest 195 374 7.0" 
$ns at 0.0 "$node_(93) setdest 1936 690 5.0" 
$ns at 20.047199476968046 "$node_(93) setdest 1644 116 14.0" 
$ns at 168.74919898224204 "$node_(93) setdest 1514 568 4.0" 
$ns at 240.67546457116538 "$node_(93) setdest 673 31 16.0" 
$ns at 440.0131466206481 "$node_(93) setdest 858 316 5.0" 
$ns at 717.0427815245014 "$node_(93) setdest 2457 89 5.0" 
$ns at 0.0 "$node_(94) setdest 588 514 1.0" 
$ns at 17.382471617629783 "$node_(94) setdest 20 763 2.0" 
$ns at 49.191106139244845 "$node_(94) setdest 123 243 4.0" 
$ns at 138.2968280979141 "$node_(94) setdest 2636 651 3.0" 
$ns at 286.24307714053623 "$node_(94) setdest 2837 852 17.0" 
$ns at 547.4257633450975 "$node_(94) setdest 1744 145 15.0" 
$ns at 0.0 "$node_(95) setdest 2216 693 14.0" 
$ns at 102.37536504116386 "$node_(95) setdest 1291 768 12.0" 
$ns at 148.954858579628 "$node_(95) setdest 2796 1 14.0" 
$ns at 344.30192075060893 "$node_(95) setdest 150 974 1.0" 
$ns at 469.466728307388 "$node_(95) setdest 1418 393 6.0" 
$ns at 735.9514761091023 "$node_(95) setdest 1022 514 6.0" 
$ns at 0.0 "$node_(96) setdest 2058 691 9.0" 
$ns at 72.90831318201748 "$node_(96) setdest 965 705 12.0" 
$ns at 108.92577398216024 "$node_(96) setdest 284 13 14.0" 
$ns at 205.07436028672055 "$node_(96) setdest 460 156 1.0" 
$ns at 329.19387757688014 "$node_(96) setdest 93 363 6.0" 
$ns at 592.558558860843 "$node_(96) setdest 2662 819 17.0" 
$ns at 0.0 "$node_(97) setdest 677 149 12.0" 
$ns at 39.17770158161633 "$node_(97) setdest 2240 419 1.0" 
$ns at 76.8076693567524 "$node_(97) setdest 2376 365 1.0" 
$ns at 145.76691309724714 "$node_(97) setdest 2958 610 15.0" 
$ns at 269.73088620076373 "$node_(97) setdest 861 363 7.0" 
$ns at 530.0989377818954 "$node_(97) setdest 1901 432 19.0" 
$ns at 0.0 "$node_(98) setdest 2319 455 18.0" 
$ns at 109.33387635247279 "$node_(98) setdest 1995 904 18.0" 
$ns at 217.92437016596324 "$node_(98) setdest 156 770 12.0" 
$ns at 355.5420314264852 "$node_(98) setdest 1228 838 15.0" 
$ns at 514.8631559640803 "$node_(98) setdest 1520 101 10.0" 
$ns at 768.0335931410033 "$node_(98) setdest 715 196 4.0" 
$ns at 0.0 "$node_(99) setdest 644 677 4.0" 
$ns at 37.42003421607872 "$node_(99) setdest 2525 589 19.0" 
$ns at 231.8952541647169 "$node_(99) setdest 809 82 13.0" 
$ns at 293.6447229904927 "$node_(99) setdest 1905 724 20.0" 
$ns at 551.7799991710771 "$node_(99) setdest 1440 772 6.0" 
$ns at 847.5273241767122 "$node_(99) setdest 317 915 18.0" 


#Set a TCP connection between node_(86) and node_(88)
set tcp_(0) [new Agent/TCP/Newreno]
$tcp_(0) set class_ 2
set sink_(0) [new Agent/TCPSink]
$ns attach-agent $node_(86) $tcp_(0)
$ns attach-agent $node_(88) $sink_(0)
$ns connect $tcp_(0) $sink_(0)
set ftp_(0) [new Application/FTP]
$ftp_(0) attach-agent $tcp_(0)
$ns at 0.2 "$ftp_(0) start"
$ns at 180.0 "$ftp_(0) stop"

#Set a TCP connection between node_(73) and node_(45)
set tcp_(1) [new Agent/TCP/Newreno]
$tcp_(1) set class_ 2
set sink_(1) [new Agent/TCPSink]
$ns attach-agent $node_(73) $tcp_(1)
$ns attach-agent $node_(45) $sink_(1)
$ns connect $tcp_(1) $sink_(1)
set ftp_(1) [new Application/FTP]
$ftp_(1) attach-agent $tcp_(1)
$ns at 180.2 "$ftp_(1) start"
$ns at 360.0 "$ftp_(1) stop"

#Set a TCP connection between node_(14) and node_(95)
set tcp_(2) [new Agent/TCP/Newreno]
$tcp_(2) set class_ 2
set sink_(2) [new Agent/TCPSink]
$ns attach-agent $node_(14) $tcp_(2)
$ns attach-agent $node_(95) $sink_(2)
$ns connect $tcp_(2) $sink_(2)
set ftp_(2) [new Application/FTP]
$ftp_(2) attach-agent $tcp_(2)
$ns at 360.2 "$ftp_(2) start"
$ns at 540.0 "$ftp_(2) stop"

#Set a TCP connection between node_(65) and node_(29)
set tcp_(3) [new Agent/TCP/Newreno]
$tcp_(3) set class_ 2
set sink_(3) [new Agent/TCPSink]
$ns attach-agent $node_(65) $tcp_(3)
$ns attach-agent $node_(29) $sink_(3)
$ns connect $tcp_(3) $sink_(3)
set ftp_(3) [new Application/FTP]
$ftp_(3) attach-agent $tcp_(3)
$ns at 540.2 "$ftp_(3) start"
$ns at 720.0 "$ftp_(3) stop"

#Set a TCP connection between node_(67) and node_(36)
set tcp_(4) [new Agent/TCP/Newreno]
$tcp_(4) set class_ 2
set sink_(4) [new Agent/TCPSink]
$ns attach-agent $node_(67) $tcp_(4)
$ns attach-agent $node_(36) $sink_(4)
$ns connect $tcp_(4) $sink_(4)
set ftp_(4) [new Application/FTP]
$ftp_(4) attach-agent $tcp_(4)
$ns at 720.2 "$ftp_(4) start"
$ns at 900.0 "$ftp_(4) stop"

#Set a TCP connection between node_(83) and node_(55)
set tcp_(5) [new Agent/TCP/Newreno]
$tcp_(5) set class_ 2
set sink_(5) [new Agent/TCPSink]
$ns attach-agent $node_(83) $tcp_(5)
$ns attach-agent $node_(55) $sink_(5)
$ns connect $tcp_(5) $sink_(5)
set ftp_(5) [new Application/FTP]
$ftp_(5) attach-agent $tcp_(5)
$ns at 0.2 "$ftp_(5) start"
$ns at 180.0 "$ftp_(5) stop"

#Set a TCP connection between node_(66) and node_(96)
set tcp_(6) [new Agent/TCP/Newreno]
$tcp_(6) set class_ 2
set sink_(6) [new Agent/TCPSink]
$ns attach-agent $node_(66) $tcp_(6)
$ns attach-agent $node_(96) $sink_(6)
$ns connect $tcp_(6) $sink_(6)
set ftp_(6) [new Application/FTP]
$ftp_(6) attach-agent $tcp_(6)
$ns at 180.2 "$ftp_(6) start"
$ns at 360.0 "$ftp_(6) stop"

#Set a TCP connection between node_(50) and node_(74)
set tcp_(7) [new Agent/TCP/Newreno]
$tcp_(7) set class_ 2
set sink_(7) [new Agent/TCPSink]
$ns attach-agent $node_(50) $tcp_(7)
$ns attach-agent $node_(74) $sink_(7)
$ns connect $tcp_(7) $sink_(7)
set ftp_(7) [new Application/FTP]
$ftp_(7) attach-agent $tcp_(7)
$ns at 360.2 "$ftp_(7) start"
$ns at 540.0 "$ftp_(7) stop"

#Set a TCP connection between node_(70) and node_(44)
set tcp_(8) [new Agent/TCP/Newreno]
$tcp_(8) set class_ 2
set sink_(8) [new Agent/TCPSink]
$ns attach-agent $node_(70) $tcp_(8)
$ns attach-agent $node_(44) $sink_(8)
$ns connect $tcp_(8) $sink_(8)
set ftp_(8) [new Application/FTP]
$ftp_(8) attach-agent $tcp_(8)
$ns at 540.2 "$ftp_(8) start"
$ns at 720.0 "$ftp_(8) stop"

#Set a TCP connection between node_(8) and node_(39)
set tcp_(9) [new Agent/TCP/Newreno]
$tcp_(9) set class_ 2
set sink_(9) [new Agent/TCPSink]
$ns attach-agent $node_(8) $tcp_(9)
$ns attach-agent $node_(39) $sink_(9)
$ns connect $tcp_(9) $sink_(9)
set ftp_(9) [new Application/FTP]
$ftp_(9) attach-agent $tcp_(9)
$ns at 720.2 "$ftp_(9) start"
$ns at 900.0 "$ftp_(9) stop"

#Set a TCP connection between node_(6) and node_(1)
set tcp_(10) [new Agent/TCP/Newreno]
$tcp_(10) set class_ 2
set sink_(10) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(10)
$ns attach-agent $node_(1) $sink_(10)
$ns connect $tcp_(10) $sink_(10)
set ftp_(10) [new Application/FTP]
$ftp_(10) attach-agent $tcp_(10)
$ns at 0.2 "$ftp_(10) start"
$ns at 180.0 "$ftp_(10) stop"

#Set a TCP connection between node_(57) and node_(37)
set tcp_(11) [new Agent/TCP/Newreno]
$tcp_(11) set class_ 2
set sink_(11) [new Agent/TCPSink]
$ns attach-agent $node_(57) $tcp_(11)
$ns attach-agent $node_(37) $sink_(11)
$ns connect $tcp_(11) $sink_(11)
set ftp_(11) [new Application/FTP]
$ftp_(11) attach-agent $tcp_(11)
$ns at 180.2 "$ftp_(11) start"
$ns at 360.0 "$ftp_(11) stop"

#Set a TCP connection between node_(18) and node_(36)
set tcp_(12) [new Agent/TCP/Newreno]
$tcp_(12) set class_ 2
set sink_(12) [new Agent/TCPSink]
$ns attach-agent $node_(18) $tcp_(12)
$ns attach-agent $node_(36) $sink_(12)
$ns connect $tcp_(12) $sink_(12)
set ftp_(12) [new Application/FTP]
$ftp_(12) attach-agent $tcp_(12)
$ns at 360.2 "$ftp_(12) start"
$ns at 540.0 "$ftp_(12) stop"

#Set a TCP connection between node_(79) and node_(29)
set tcp_(13) [new Agent/TCP/Newreno]
$tcp_(13) set class_ 2
set sink_(13) [new Agent/TCPSink]
$ns attach-agent $node_(79) $tcp_(13)
$ns attach-agent $node_(29) $sink_(13)
$ns connect $tcp_(13) $sink_(13)
set ftp_(13) [new Application/FTP]
$ftp_(13) attach-agent $tcp_(13)
$ns at 540.2 "$ftp_(13) start"
$ns at 720.0 "$ftp_(13) stop"

#Set a TCP connection between node_(62) and node_(97)
set tcp_(14) [new Agent/TCP/Newreno]
$tcp_(14) set class_ 2
set sink_(14) [new Agent/TCPSink]
$ns attach-agent $node_(62) $tcp_(14)
$ns attach-agent $node_(97) $sink_(14)
$ns connect $tcp_(14) $sink_(14)
set ftp_(14) [new Application/FTP]
$ftp_(14) attach-agent $tcp_(14)
$ns at 720.2 "$ftp_(14) start"
$ns at 900.0 "$ftp_(14) stop"

#Set a TCP connection between node_(24) and node_(59)
set tcp_(15) [new Agent/TCP/Newreno]
$tcp_(15) set class_ 2
set sink_(15) [new Agent/TCPSink]
$ns attach-agent $node_(24) $tcp_(15)
$ns attach-agent $node_(59) $sink_(15)
$ns connect $tcp_(15) $sink_(15)
set ftp_(15) [new Application/FTP]
$ftp_(15) attach-agent $tcp_(15)
$ns at 0.2 "$ftp_(15) start"
$ns at 180.0 "$ftp_(15) stop"

#Set a TCP connection between node_(56) and node_(28)
set tcp_(16) [new Agent/TCP/Newreno]
$tcp_(16) set class_ 2
set sink_(16) [new Agent/TCPSink]
$ns attach-agent $node_(56) $tcp_(16)
$ns attach-agent $node_(28) $sink_(16)
$ns connect $tcp_(16) $sink_(16)
set ftp_(16) [new Application/FTP]
$ftp_(16) attach-agent $tcp_(16)
$ns at 180.2 "$ftp_(16) start"
$ns at 360.0 "$ftp_(16) stop"

#Set a TCP connection between node_(71) and node_(70)
set tcp_(17) [new Agent/TCP/Newreno]
$tcp_(17) set class_ 2
set sink_(17) [new Agent/TCPSink]
$ns attach-agent $node_(71) $tcp_(17)
$ns attach-agent $node_(70) $sink_(17)
$ns connect $tcp_(17) $sink_(17)
set ftp_(17) [new Application/FTP]
$ftp_(17) attach-agent $tcp_(17)
$ns at 360.2 "$ftp_(17) start"
$ns at 540.0 "$ftp_(17) stop"

#Set a TCP connection between node_(51) and node_(63)
set tcp_(18) [new Agent/TCP/Newreno]
$tcp_(18) set class_ 2
set sink_(18) [new Agent/TCPSink]
$ns attach-agent $node_(51) $tcp_(18)
$ns attach-agent $node_(63) $sink_(18)
$ns connect $tcp_(18) $sink_(18)
set ftp_(18) [new Application/FTP]
$ftp_(18) attach-agent $tcp_(18)
$ns at 540.2 "$ftp_(18) start"
$ns at 720.0 "$ftp_(18) stop"

#Set a TCP connection between node_(28) and node_(54)
set tcp_(19) [new Agent/TCP/Newreno]
$tcp_(19) set class_ 2
set sink_(19) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(19)
$ns attach-agent $node_(54) $sink_(19)
$ns connect $tcp_(19) $sink_(19)
set ftp_(19) [new Application/FTP]
$ftp_(19) attach-agent $tcp_(19)
$ns at 720.2 "$ftp_(19) start"
$ns at 900.0 "$ftp_(19) stop"

#Set a TCP connection between node_(19) and node_(52)
set tcp_(20) [new Agent/TCP/Newreno]
$tcp_(20) set class_ 2
set sink_(20) [new Agent/TCPSink]
$ns attach-agent $node_(19) $tcp_(20)
$ns attach-agent $node_(52) $sink_(20)
$ns connect $tcp_(20) $sink_(20)
set ftp_(20) [new Application/FTP]
$ftp_(20) attach-agent $tcp_(20)
$ns at 0.2 "$ftp_(20) start"
$ns at 180.0 "$ftp_(20) stop"

#Set a TCP connection between node_(11) and node_(74)
set tcp_(21) [new Agent/TCP/Newreno]
$tcp_(21) set class_ 2
set sink_(21) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(21)
$ns attach-agent $node_(74) $sink_(21)
$ns connect $tcp_(21) $sink_(21)
set ftp_(21) [new Application/FTP]
$ftp_(21) attach-agent $tcp_(21)
$ns at 180.2 "$ftp_(21) start"
$ns at 360.0 "$ftp_(21) stop"

#Set a TCP connection between node_(3) and node_(87)
set tcp_(22) [new Agent/TCP/Newreno]
$tcp_(22) set class_ 2
set sink_(22) [new Agent/TCPSink]
$ns attach-agent $node_(3) $tcp_(22)
$ns attach-agent $node_(87) $sink_(22)
$ns connect $tcp_(22) $sink_(22)
set ftp_(22) [new Application/FTP]
$ftp_(22) attach-agent $tcp_(22)
$ns at 360.2 "$ftp_(22) start"
$ns at 540.0 "$ftp_(22) stop"

#Set a TCP connection between node_(93) and node_(86)
set tcp_(23) [new Agent/TCP/Newreno]
$tcp_(23) set class_ 2
set sink_(23) [new Agent/TCPSink]
$ns attach-agent $node_(93) $tcp_(23)
$ns attach-agent $node_(86) $sink_(23)
$ns connect $tcp_(23) $sink_(23)
set ftp_(23) [new Application/FTP]
$ftp_(23) attach-agent $tcp_(23)
$ns at 540.2 "$ftp_(23) start"
$ns at 720.0 "$ftp_(23) stop"

#Set a TCP connection between node_(81) and node_(2)
set tcp_(24) [new Agent/TCP/Newreno]
$tcp_(24) set class_ 2
set sink_(24) [new Agent/TCPSink]
$ns attach-agent $node_(81) $tcp_(24)
$ns attach-agent $node_(2) $sink_(24)
$ns connect $tcp_(24) $sink_(24)
set ftp_(24) [new Application/FTP]
$ftp_(24) attach-agent $tcp_(24)
$ns at 720.2 "$ftp_(24) start"
$ns at 900.0 "$ftp_(24) stop"

#Set a TCP connection between node_(62) and node_(36)
set tcp_(25) [new Agent/TCP/Newreno]
$tcp_(25) set class_ 2
set sink_(25) [new Agent/TCPSink]
$ns attach-agent $node_(62) $tcp_(25)
$ns attach-agent $node_(36) $sink_(25)
$ns connect $tcp_(25) $sink_(25)
set ftp_(25) [new Application/FTP]
$ftp_(25) attach-agent $tcp_(25)
$ns at 0.2 "$ftp_(25) start"
$ns at 180.0 "$ftp_(25) stop"

#Set a TCP connection between node_(34) and node_(12)
set tcp_(26) [new Agent/TCP/Newreno]
$tcp_(26) set class_ 2
set sink_(26) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(26)
$ns attach-agent $node_(12) $sink_(26)
$ns connect $tcp_(26) $sink_(26)
set ftp_(26) [new Application/FTP]
$ftp_(26) attach-agent $tcp_(26)
$ns at 180.2 "$ftp_(26) start"
$ns at 360.0 "$ftp_(26) stop"

#Set a TCP connection between node_(12) and node_(73)
set tcp_(27) [new Agent/TCP/Newreno]
$tcp_(27) set class_ 2
set sink_(27) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(27)
$ns attach-agent $node_(73) $sink_(27)
$ns connect $tcp_(27) $sink_(27)
set ftp_(27) [new Application/FTP]
$ftp_(27) attach-agent $tcp_(27)
$ns at 360.2 "$ftp_(27) start"
$ns at 540.0 "$ftp_(27) stop"

#Set a TCP connection between node_(4) and node_(83)
set tcp_(28) [new Agent/TCP/Newreno]
$tcp_(28) set class_ 2
set sink_(28) [new Agent/TCPSink]
$ns attach-agent $node_(4) $tcp_(28)
$ns attach-agent $node_(83) $sink_(28)
$ns connect $tcp_(28) $sink_(28)
set ftp_(28) [new Application/FTP]
$ftp_(28) attach-agent $tcp_(28)
$ns at 540.2 "$ftp_(28) start"
$ns at 720.0 "$ftp_(28) stop"

#Set a TCP connection between node_(91) and node_(58)
set tcp_(29) [new Agent/TCP/Newreno]
$tcp_(29) set class_ 2
set sink_(29) [new Agent/TCPSink]
$ns attach-agent $node_(91) $tcp_(29)
$ns attach-agent $node_(58) $sink_(29)
$ns connect $tcp_(29) $sink_(29)
set ftp_(29) [new Application/FTP]
$ftp_(29) attach-agent $tcp_(29)
$ns at 720.2 "$ftp_(29) start"
$ns at 900.0 "$ftp_(29) stop"

#Set a TCP connection between node_(20) and node_(36)
set tcp_(30) [new Agent/TCP/Newreno]
$tcp_(30) set class_ 2
set sink_(30) [new Agent/TCPSink]
$ns attach-agent $node_(20) $tcp_(30)
$ns attach-agent $node_(36) $sink_(30)
$ns connect $tcp_(30) $sink_(30)
set ftp_(30) [new Application/FTP]
$ftp_(30) attach-agent $tcp_(30)
$ns at 0.2 "$ftp_(30) start"
$ns at 180.0 "$ftp_(30) stop"

#Set a TCP connection between node_(7) and node_(20)
set tcp_(31) [new Agent/TCP/Newreno]
$tcp_(31) set class_ 2
set sink_(31) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(31)
$ns attach-agent $node_(20) $sink_(31)
$ns connect $tcp_(31) $sink_(31)
set ftp_(31) [new Application/FTP]
$ftp_(31) attach-agent $tcp_(31)
$ns at 180.2 "$ftp_(31) start"
$ns at 360.0 "$ftp_(31) stop"

#Set a TCP connection between node_(9) and node_(14)
set tcp_(32) [new Agent/TCP/Newreno]
$tcp_(32) set class_ 2
set sink_(32) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(32)
$ns attach-agent $node_(14) $sink_(32)
$ns connect $tcp_(32) $sink_(32)
set ftp_(32) [new Application/FTP]
$ftp_(32) attach-agent $tcp_(32)
$ns at 360.2 "$ftp_(32) start"
$ns at 540.0 "$ftp_(32) stop"

#Set a TCP connection between node_(66) and node_(61)
set tcp_(33) [new Agent/TCP/Newreno]
$tcp_(33) set class_ 2
set sink_(33) [new Agent/TCPSink]
$ns attach-agent $node_(66) $tcp_(33)
$ns attach-agent $node_(61) $sink_(33)
$ns connect $tcp_(33) $sink_(33)
set ftp_(33) [new Application/FTP]
$ftp_(33) attach-agent $tcp_(33)
$ns at 540.2 "$ftp_(33) start"
$ns at 720.0 "$ftp_(33) stop"

#Set a TCP connection between node_(84) and node_(18)
set tcp_(34) [new Agent/TCP/Newreno]
$tcp_(34) set class_ 2
set sink_(34) [new Agent/TCPSink]
$ns attach-agent $node_(84) $tcp_(34)
$ns attach-agent $node_(18) $sink_(34)
$ns connect $tcp_(34) $sink_(34)
set ftp_(34) [new Application/FTP]
$ftp_(34) attach-agent $tcp_(34)
$ns at 720.2 "$ftp_(34) start"
$ns at 900.0 "$ftp_(34) stop"

#Set a TCP connection between node_(49) and node_(24)
set tcp_(35) [new Agent/TCP/Newreno]
$tcp_(35) set class_ 2
set sink_(35) [new Agent/TCPSink]
$ns attach-agent $node_(49) $tcp_(35)
$ns attach-agent $node_(24) $sink_(35)
$ns connect $tcp_(35) $sink_(35)
set ftp_(35) [new Application/FTP]
$ftp_(35) attach-agent $tcp_(35)
$ns at 0.2 "$ftp_(35) start"
$ns at 180.0 "$ftp_(35) stop"

#Set a TCP connection between node_(42) and node_(61)
set tcp_(36) [new Agent/TCP/Newreno]
$tcp_(36) set class_ 2
set sink_(36) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(36)
$ns attach-agent $node_(61) $sink_(36)
$ns connect $tcp_(36) $sink_(36)
set ftp_(36) [new Application/FTP]
$ftp_(36) attach-agent $tcp_(36)
$ns at 180.2 "$ftp_(36) start"
$ns at 360.0 "$ftp_(36) stop"

#Set a TCP connection between node_(38) and node_(58)
set tcp_(37) [new Agent/TCP/Newreno]
$tcp_(37) set class_ 2
set sink_(37) [new Agent/TCPSink]
$ns attach-agent $node_(38) $tcp_(37)
$ns attach-agent $node_(58) $sink_(37)
$ns connect $tcp_(37) $sink_(37)
set ftp_(37) [new Application/FTP]
$ftp_(37) attach-agent $tcp_(37)
$ns at 360.2 "$ftp_(37) start"
$ns at 540.0 "$ftp_(37) stop"

#Set a TCP connection between node_(43) and node_(54)
set tcp_(38) [new Agent/TCP/Newreno]
$tcp_(38) set class_ 2
set sink_(38) [new Agent/TCPSink]
$ns attach-agent $node_(43) $tcp_(38)
$ns attach-agent $node_(54) $sink_(38)
$ns connect $tcp_(38) $sink_(38)
set ftp_(38) [new Application/FTP]
$ftp_(38) attach-agent $tcp_(38)
$ns at 540.2 "$ftp_(38) start"
$ns at 720.0 "$ftp_(38) stop"

#Set a TCP connection between node_(83) and node_(81)
set tcp_(39) [new Agent/TCP/Newreno]
$tcp_(39) set class_ 2
set sink_(39) [new Agent/TCPSink]
$ns attach-agent $node_(83) $tcp_(39)
$ns attach-agent $node_(81) $sink_(39)
$ns connect $tcp_(39) $sink_(39)
set ftp_(39) [new Application/FTP]
$ftp_(39) attach-agent $tcp_(39)
$ns at 720.2 "$ftp_(39) start"
$ns at 900.0 "$ftp_(39) stop"

#Set a TCP connection between node_(51) and node_(15)
set tcp_(40) [new Agent/TCP/Newreno]
$tcp_(40) set class_ 2
set sink_(40) [new Agent/TCPSink]
$ns attach-agent $node_(51) $tcp_(40)
$ns attach-agent $node_(15) $sink_(40)
$ns connect $tcp_(40) $sink_(40)
set ftp_(40) [new Application/FTP]
$ftp_(40) attach-agent $tcp_(40)
$ns at 0.2 "$ftp_(40) start"
$ns at 180.0 "$ftp_(40) stop"

#Set a TCP connection between node_(83) and node_(53)
set tcp_(41) [new Agent/TCP/Newreno]
$tcp_(41) set class_ 2
set sink_(41) [new Agent/TCPSink]
$ns attach-agent $node_(83) $tcp_(41)
$ns attach-agent $node_(53) $sink_(41)
$ns connect $tcp_(41) $sink_(41)
set ftp_(41) [new Application/FTP]
$ftp_(41) attach-agent $tcp_(41)
$ns at 180.2 "$ftp_(41) start"
$ns at 360.0 "$ftp_(41) stop"

#Set a TCP connection between node_(96) and node_(61)
set tcp_(42) [new Agent/TCP/Newreno]
$tcp_(42) set class_ 2
set sink_(42) [new Agent/TCPSink]
$ns attach-agent $node_(96) $tcp_(42)
$ns attach-agent $node_(61) $sink_(42)
$ns connect $tcp_(42) $sink_(42)
set ftp_(42) [new Application/FTP]
$ftp_(42) attach-agent $tcp_(42)
$ns at 360.2 "$ftp_(42) start"
$ns at 540.0 "$ftp_(42) stop"

#Set a TCP connection between node_(9) and node_(79)
set tcp_(43) [new Agent/TCP/Newreno]
$tcp_(43) set class_ 2
set sink_(43) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(43)
$ns attach-agent $node_(79) $sink_(43)
$ns connect $tcp_(43) $sink_(43)
set ftp_(43) [new Application/FTP]
$ftp_(43) attach-agent $tcp_(43)
$ns at 540.2 "$ftp_(43) start"
$ns at 720.0 "$ftp_(43) stop"

#Set a TCP connection between node_(16) and node_(74)
set tcp_(44) [new Agent/TCP/Newreno]
$tcp_(44) set class_ 2
set sink_(44) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(44)
$ns attach-agent $node_(74) $sink_(44)
$ns connect $tcp_(44) $sink_(44)
set ftp_(44) [new Application/FTP]
$ftp_(44) attach-agent $tcp_(44)
$ns at 720.2 "$ftp_(44) start"
$ns at 900.0 "$ftp_(44) stop"

#Set a TCP connection between node_(49) and node_(43)
set tcp_(45) [new Agent/TCP/Newreno]
$tcp_(45) set class_ 2
set sink_(45) [new Agent/TCPSink]
$ns attach-agent $node_(49) $tcp_(45)
$ns attach-agent $node_(43) $sink_(45)
$ns connect $tcp_(45) $sink_(45)
set ftp_(45) [new Application/FTP]
$ftp_(45) attach-agent $tcp_(45)
$ns at 0.2 "$ftp_(45) start"
$ns at 180.0 "$ftp_(45) stop"

#Set a TCP connection between node_(77) and node_(26)
set tcp_(46) [new Agent/TCP/Newreno]
$tcp_(46) set class_ 2
set sink_(46) [new Agent/TCPSink]
$ns attach-agent $node_(77) $tcp_(46)
$ns attach-agent $node_(26) $sink_(46)
$ns connect $tcp_(46) $sink_(46)
set ftp_(46) [new Application/FTP]
$ftp_(46) attach-agent $tcp_(46)
$ns at 180.2 "$ftp_(46) start"
$ns at 360.0 "$ftp_(46) stop"

#Set a TCP connection between node_(30) and node_(33)
set tcp_(47) [new Agent/TCP/Newreno]
$tcp_(47) set class_ 2
set sink_(47) [new Agent/TCPSink]
$ns attach-agent $node_(30) $tcp_(47)
$ns attach-agent $node_(33) $sink_(47)
$ns connect $tcp_(47) $sink_(47)
set ftp_(47) [new Application/FTP]
$ftp_(47) attach-agent $tcp_(47)
$ns at 360.2 "$ftp_(47) start"
$ns at 540.0 "$ftp_(47) stop"

#Set a TCP connection between node_(16) and node_(86)
set tcp_(48) [new Agent/TCP/Newreno]
$tcp_(48) set class_ 2
set sink_(48) [new Agent/TCPSink]
$ns attach-agent $node_(16) $tcp_(48)
$ns attach-agent $node_(86) $sink_(48)
$ns connect $tcp_(48) $sink_(48)
set ftp_(48) [new Application/FTP]
$ftp_(48) attach-agent $tcp_(48)
$ns at 540.2 "$ftp_(48) start"
$ns at 720.0 "$ftp_(48) stop"

#Set a TCP connection between node_(34) and node_(32)
set tcp_(49) [new Agent/TCP/Newreno]
$tcp_(49) set class_ 2
set sink_(49) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(49)
$ns attach-agent $node_(32) $sink_(49)
$ns connect $tcp_(49) $sink_(49)
set ftp_(49) [new Application/FTP]
$ftp_(49) attach-agent $tcp_(49)
$ns at 720.2 "$ftp_(49) start"
$ns at 900.0 "$ftp_(49) stop"

#Set a TCP connection between node_(77) and node_(22)
set tcp_(50) [new Agent/TCP/Newreno]
$tcp_(50) set class_ 2
set sink_(50) [new Agent/TCPSink]
$ns attach-agent $node_(77) $tcp_(50)
$ns attach-agent $node_(22) $sink_(50)
$ns connect $tcp_(50) $sink_(50)
set ftp_(50) [new Application/FTP]
$ftp_(50) attach-agent $tcp_(50)
$ns at 0.2 "$ftp_(50) start"
$ns at 180.0 "$ftp_(50) stop"

#Set a TCP connection between node_(63) and node_(35)
set tcp_(51) [new Agent/TCP/Newreno]
$tcp_(51) set class_ 2
set sink_(51) [new Agent/TCPSink]
$ns attach-agent $node_(63) $tcp_(51)
$ns attach-agent $node_(35) $sink_(51)
$ns connect $tcp_(51) $sink_(51)
set ftp_(51) [new Application/FTP]
$ftp_(51) attach-agent $tcp_(51)
$ns at 180.2 "$ftp_(51) start"
$ns at 360.0 "$ftp_(51) stop"

#Set a TCP connection between node_(17) and node_(81)
set tcp_(52) [new Agent/TCP/Newreno]
$tcp_(52) set class_ 2
set sink_(52) [new Agent/TCPSink]
$ns attach-agent $node_(17) $tcp_(52)
$ns attach-agent $node_(81) $sink_(52)
$ns connect $tcp_(52) $sink_(52)
set ftp_(52) [new Application/FTP]
$ftp_(52) attach-agent $tcp_(52)
$ns at 360.2 "$ftp_(52) start"
$ns at 540.0 "$ftp_(52) stop"

#Set a TCP connection between node_(7) and node_(86)
set tcp_(53) [new Agent/TCP/Newreno]
$tcp_(53) set class_ 2
set sink_(53) [new Agent/TCPSink]
$ns attach-agent $node_(7) $tcp_(53)
$ns attach-agent $node_(86) $sink_(53)
$ns connect $tcp_(53) $sink_(53)
set ftp_(53) [new Application/FTP]
$ftp_(53) attach-agent $tcp_(53)
$ns at 540.2 "$ftp_(53) start"
$ns at 720.0 "$ftp_(53) stop"

#Set a TCP connection between node_(26) and node_(75)
set tcp_(54) [new Agent/TCP/Newreno]
$tcp_(54) set class_ 2
set sink_(54) [new Agent/TCPSink]
$ns attach-agent $node_(26) $tcp_(54)
$ns attach-agent $node_(75) $sink_(54)
$ns connect $tcp_(54) $sink_(54)
set ftp_(54) [new Application/FTP]
$ftp_(54) attach-agent $tcp_(54)
$ns at 720.2 "$ftp_(54) start"
$ns at 900.0 "$ftp_(54) stop"

#Set a TCP connection between node_(69) and node_(97)
set tcp_(55) [new Agent/TCP/Newreno]
$tcp_(55) set class_ 2
set sink_(55) [new Agent/TCPSink]
$ns attach-agent $node_(69) $tcp_(55)
$ns attach-agent $node_(97) $sink_(55)
$ns connect $tcp_(55) $sink_(55)
set ftp_(55) [new Application/FTP]
$ftp_(55) attach-agent $tcp_(55)
$ns at 0.2 "$ftp_(55) start"
$ns at 180.0 "$ftp_(55) stop"

#Set a TCP connection between node_(6) and node_(68)
set tcp_(56) [new Agent/TCP/Newreno]
$tcp_(56) set class_ 2
set sink_(56) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(56)
$ns attach-agent $node_(68) $sink_(56)
$ns connect $tcp_(56) $sink_(56)
set ftp_(56) [new Application/FTP]
$ftp_(56) attach-agent $tcp_(56)
$ns at 180.2 "$ftp_(56) start"
$ns at 360.0 "$ftp_(56) stop"

#Set a TCP connection between node_(38) and node_(79)
set tcp_(57) [new Agent/TCP/Newreno]
$tcp_(57) set class_ 2
set sink_(57) [new Agent/TCPSink]
$ns attach-agent $node_(38) $tcp_(57)
$ns attach-agent $node_(79) $sink_(57)
$ns connect $tcp_(57) $sink_(57)
set ftp_(57) [new Application/FTP]
$ftp_(57) attach-agent $tcp_(57)
$ns at 360.2 "$ftp_(57) start"
$ns at 540.0 "$ftp_(57) stop"

#Set a TCP connection between node_(93) and node_(50)
set tcp_(58) [new Agent/TCP/Newreno]
$tcp_(58) set class_ 2
set sink_(58) [new Agent/TCPSink]
$ns attach-agent $node_(93) $tcp_(58)
$ns attach-agent $node_(50) $sink_(58)
$ns connect $tcp_(58) $sink_(58)
set ftp_(58) [new Application/FTP]
$ftp_(58) attach-agent $tcp_(58)
$ns at 540.2 "$ftp_(58) start"
$ns at 720.0 "$ftp_(58) stop"

#Set a TCP connection between node_(41) and node_(26)
set tcp_(59) [new Agent/TCP/Newreno]
$tcp_(59) set class_ 2
set sink_(59) [new Agent/TCPSink]
$ns attach-agent $node_(41) $tcp_(59)
$ns attach-agent $node_(26) $sink_(59)
$ns connect $tcp_(59) $sink_(59)
set ftp_(59) [new Application/FTP]
$ftp_(59) attach-agent $tcp_(59)
$ns at 720.2 "$ftp_(59) start"
$ns at 900.0 "$ftp_(59) stop"

#Set a TCP connection between node_(13) and node_(11)
set tcp_(60) [new Agent/TCP/Newreno]
$tcp_(60) set class_ 2
set sink_(60) [new Agent/TCPSink]
$ns attach-agent $node_(13) $tcp_(60)
$ns attach-agent $node_(11) $sink_(60)
$ns connect $tcp_(60) $sink_(60)
set ftp_(60) [new Application/FTP]
$ftp_(60) attach-agent $tcp_(60)
$ns at 0.2 "$ftp_(60) start"
$ns at 180.0 "$ftp_(60) stop"

#Set a TCP connection between node_(6) and node_(15)
set tcp_(61) [new Agent/TCP/Newreno]
$tcp_(61) set class_ 2
set sink_(61) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(61)
$ns attach-agent $node_(15) $sink_(61)
$ns connect $tcp_(61) $sink_(61)
set ftp_(61) [new Application/FTP]
$ftp_(61) attach-agent $tcp_(61)
$ns at 180.2 "$ftp_(61) start"
$ns at 360.0 "$ftp_(61) stop"

#Set a TCP connection between node_(28) and node_(86)
set tcp_(62) [new Agent/TCP/Newreno]
$tcp_(62) set class_ 2
set sink_(62) [new Agent/TCPSink]
$ns attach-agent $node_(28) $tcp_(62)
$ns attach-agent $node_(86) $sink_(62)
$ns connect $tcp_(62) $sink_(62)
set ftp_(62) [new Application/FTP]
$ftp_(62) attach-agent $tcp_(62)
$ns at 360.2 "$ftp_(62) start"
$ns at 540.0 "$ftp_(62) stop"

#Set a TCP connection between node_(75) and node_(47)
set tcp_(63) [new Agent/TCP/Newreno]
$tcp_(63) set class_ 2
set sink_(63) [new Agent/TCPSink]
$ns attach-agent $node_(75) $tcp_(63)
$ns attach-agent $node_(47) $sink_(63)
$ns connect $tcp_(63) $sink_(63)
set ftp_(63) [new Application/FTP]
$ftp_(63) attach-agent $tcp_(63)
$ns at 540.2 "$ftp_(63) start"
$ns at 720.0 "$ftp_(63) stop"

#Set a TCP connection between node_(1) and node_(85)
set tcp_(64) [new Agent/TCP/Newreno]
$tcp_(64) set class_ 2
set sink_(64) [new Agent/TCPSink]
$ns attach-agent $node_(1) $tcp_(64)
$ns attach-agent $node_(85) $sink_(64)
$ns connect $tcp_(64) $sink_(64)
set ftp_(64) [new Application/FTP]
$ftp_(64) attach-agent $tcp_(64)
$ns at 720.2 "$ftp_(64) start"
$ns at 900.0 "$ftp_(64) stop"

#Set a TCP connection between node_(70) and node_(29)
set tcp_(65) [new Agent/TCP/Newreno]
$tcp_(65) set class_ 2
set sink_(65) [new Agent/TCPSink]
$ns attach-agent $node_(70) $tcp_(65)
$ns attach-agent $node_(29) $sink_(65)
$ns connect $tcp_(65) $sink_(65)
set ftp_(65) [new Application/FTP]
$ftp_(65) attach-agent $tcp_(65)
$ns at 0.2 "$ftp_(65) start"
$ns at 180.0 "$ftp_(65) stop"

#Set a TCP connection between node_(65) and node_(98)
set tcp_(66) [new Agent/TCP/Newreno]
$tcp_(66) set class_ 2
set sink_(66) [new Agent/TCPSink]
$ns attach-agent $node_(65) $tcp_(66)
$ns attach-agent $node_(98) $sink_(66)
$ns connect $tcp_(66) $sink_(66)
set ftp_(66) [new Application/FTP]
$ftp_(66) attach-agent $tcp_(66)
$ns at 180.2 "$ftp_(66) start"
$ns at 360.0 "$ftp_(66) stop"

#Set a TCP connection between node_(2) and node_(61)
set tcp_(67) [new Agent/TCP/Newreno]
$tcp_(67) set class_ 2
set sink_(67) [new Agent/TCPSink]
$ns attach-agent $node_(2) $tcp_(67)
$ns attach-agent $node_(61) $sink_(67)
$ns connect $tcp_(67) $sink_(67)
set ftp_(67) [new Application/FTP]
$ftp_(67) attach-agent $tcp_(67)
$ns at 360.2 "$ftp_(67) start"
$ns at 540.0 "$ftp_(67) stop"

#Set a TCP connection between node_(6) and node_(84)
set tcp_(68) [new Agent/TCP/Newreno]
$tcp_(68) set class_ 2
set sink_(68) [new Agent/TCPSink]
$ns attach-agent $node_(6) $tcp_(68)
$ns attach-agent $node_(84) $sink_(68)
$ns connect $tcp_(68) $sink_(68)
set ftp_(68) [new Application/FTP]
$ftp_(68) attach-agent $tcp_(68)
$ns at 540.2 "$ftp_(68) start"
$ns at 720.0 "$ftp_(68) stop"

#Set a TCP connection between node_(79) and node_(5)
set tcp_(69) [new Agent/TCP/Newreno]
$tcp_(69) set class_ 2
set sink_(69) [new Agent/TCPSink]
$ns attach-agent $node_(79) $tcp_(69)
$ns attach-agent $node_(5) $sink_(69)
$ns connect $tcp_(69) $sink_(69)
set ftp_(69) [new Application/FTP]
$ftp_(69) attach-agent $tcp_(69)
$ns at 720.2 "$ftp_(69) start"
$ns at 900.0 "$ftp_(69) stop"

#Set a TCP connection between node_(61) and node_(22)
set tcp_(70) [new Agent/TCP/Newreno]
$tcp_(70) set class_ 2
set sink_(70) [new Agent/TCPSink]
$ns attach-agent $node_(61) $tcp_(70)
$ns attach-agent $node_(22) $sink_(70)
$ns connect $tcp_(70) $sink_(70)
set ftp_(70) [new Application/FTP]
$ftp_(70) attach-agent $tcp_(70)
$ns at 0.2 "$ftp_(70) start"
$ns at 180.0 "$ftp_(70) stop"

#Set a TCP connection between node_(51) and node_(31)
set tcp_(71) [new Agent/TCP/Newreno]
$tcp_(71) set class_ 2
set sink_(71) [new Agent/TCPSink]
$ns attach-agent $node_(51) $tcp_(71)
$ns attach-agent $node_(31) $sink_(71)
$ns connect $tcp_(71) $sink_(71)
set ftp_(71) [new Application/FTP]
$ftp_(71) attach-agent $tcp_(71)
$ns at 180.2 "$ftp_(71) start"
$ns at 360.0 "$ftp_(71) stop"

#Set a TCP connection between node_(65) and node_(36)
set tcp_(72) [new Agent/TCP/Newreno]
$tcp_(72) set class_ 2
set sink_(72) [new Agent/TCPSink]
$ns attach-agent $node_(65) $tcp_(72)
$ns attach-agent $node_(36) $sink_(72)
$ns connect $tcp_(72) $sink_(72)
set ftp_(72) [new Application/FTP]
$ftp_(72) attach-agent $tcp_(72)
$ns at 360.2 "$ftp_(72) start"
$ns at 540.0 "$ftp_(72) stop"

#Set a TCP connection between node_(9) and node_(47)
set tcp_(73) [new Agent/TCP/Newreno]
$tcp_(73) set class_ 2
set sink_(73) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(73)
$ns attach-agent $node_(47) $sink_(73)
$ns connect $tcp_(73) $sink_(73)
set ftp_(73) [new Application/FTP]
$ftp_(73) attach-agent $tcp_(73)
$ns at 540.2 "$ftp_(73) start"
$ns at 720.0 "$ftp_(73) stop"

#Set a TCP connection between node_(42) and node_(77)
set tcp_(74) [new Agent/TCP/Newreno]
$tcp_(74) set class_ 2
set sink_(74) [new Agent/TCPSink]
$ns attach-agent $node_(42) $tcp_(74)
$ns attach-agent $node_(77) $sink_(74)
$ns connect $tcp_(74) $sink_(74)
set ftp_(74) [new Application/FTP]
$ftp_(74) attach-agent $tcp_(74)
$ns at 720.2 "$ftp_(74) start"
$ns at 900.0 "$ftp_(74) stop"

#Set a TCP connection between node_(83) and node_(95)
set tcp_(75) [new Agent/TCP/Newreno]
$tcp_(75) set class_ 2
set sink_(75) [new Agent/TCPSink]
$ns attach-agent $node_(83) $tcp_(75)
$ns attach-agent $node_(95) $sink_(75)
$ns connect $tcp_(75) $sink_(75)
set ftp_(75) [new Application/FTP]
$ftp_(75) attach-agent $tcp_(75)
$ns at 0.2 "$ftp_(75) start"
$ns at 180.0 "$ftp_(75) stop"

#Set a TCP connection between node_(57) and node_(31)
set tcp_(76) [new Agent/TCP/Newreno]
$tcp_(76) set class_ 2
set sink_(76) [new Agent/TCPSink]
$ns attach-agent $node_(57) $tcp_(76)
$ns attach-agent $node_(31) $sink_(76)
$ns connect $tcp_(76) $sink_(76)
set ftp_(76) [new Application/FTP]
$ftp_(76) attach-agent $tcp_(76)
$ns at 180.2 "$ftp_(76) start"
$ns at 360.0 "$ftp_(76) stop"

#Set a TCP connection between node_(55) and node_(6)
set tcp_(77) [new Agent/TCP/Newreno]
$tcp_(77) set class_ 2
set sink_(77) [new Agent/TCPSink]
$ns attach-agent $node_(55) $tcp_(77)
$ns attach-agent $node_(6) $sink_(77)
$ns connect $tcp_(77) $sink_(77)
set ftp_(77) [new Application/FTP]
$ftp_(77) attach-agent $tcp_(77)
$ns at 360.2 "$ftp_(77) start"
$ns at 540.0 "$ftp_(77) stop"

#Set a TCP connection between node_(66) and node_(74)
set tcp_(78) [new Agent/TCP/Newreno]
$tcp_(78) set class_ 2
set sink_(78) [new Agent/TCPSink]
$ns attach-agent $node_(66) $tcp_(78)
$ns attach-agent $node_(74) $sink_(78)
$ns connect $tcp_(78) $sink_(78)
set ftp_(78) [new Application/FTP]
$ftp_(78) attach-agent $tcp_(78)
$ns at 540.2 "$ftp_(78) start"
$ns at 720.0 "$ftp_(78) stop"

#Set a TCP connection between node_(12) and node_(72)
set tcp_(79) [new Agent/TCP/Newreno]
$tcp_(79) set class_ 2
set sink_(79) [new Agent/TCPSink]
$ns attach-agent $node_(12) $tcp_(79)
$ns attach-agent $node_(72) $sink_(79)
$ns connect $tcp_(79) $sink_(79)
set ftp_(79) [new Application/FTP]
$ftp_(79) attach-agent $tcp_(79)
$ns at 720.2 "$ftp_(79) start"
$ns at 900.0 "$ftp_(79) stop"

#Set a TCP connection between node_(45) and node_(92)
set tcp_(80) [new Agent/TCP/Newreno]
$tcp_(80) set class_ 2
set sink_(80) [new Agent/TCPSink]
$ns attach-agent $node_(45) $tcp_(80)
$ns attach-agent $node_(92) $sink_(80)
$ns connect $tcp_(80) $sink_(80)
set ftp_(80) [new Application/FTP]
$ftp_(80) attach-agent $tcp_(80)
$ns at 0.2 "$ftp_(80) start"
$ns at 180.0 "$ftp_(80) stop"

#Set a TCP connection between node_(58) and node_(51)
set tcp_(81) [new Agent/TCP/Newreno]
$tcp_(81) set class_ 2
set sink_(81) [new Agent/TCPSink]
$ns attach-agent $node_(58) $tcp_(81)
$ns attach-agent $node_(51) $sink_(81)
$ns connect $tcp_(81) $sink_(81)
set ftp_(81) [new Application/FTP]
$ftp_(81) attach-agent $tcp_(81)
$ns at 180.2 "$ftp_(81) start"
$ns at 360.0 "$ftp_(81) stop"

#Set a TCP connection between node_(37) and node_(79)
set tcp_(82) [new Agent/TCP/Newreno]
$tcp_(82) set class_ 2
set sink_(82) [new Agent/TCPSink]
$ns attach-agent $node_(37) $tcp_(82)
$ns attach-agent $node_(79) $sink_(82)
$ns connect $tcp_(82) $sink_(82)
set ftp_(82) [new Application/FTP]
$ftp_(82) attach-agent $tcp_(82)
$ns at 360.2 "$ftp_(82) start"
$ns at 540.0 "$ftp_(82) stop"

#Set a TCP connection between node_(81) and node_(12)
set tcp_(83) [new Agent/TCP/Newreno]
$tcp_(83) set class_ 2
set sink_(83) [new Agent/TCPSink]
$ns attach-agent $node_(81) $tcp_(83)
$ns attach-agent $node_(12) $sink_(83)
$ns connect $tcp_(83) $sink_(83)
set ftp_(83) [new Application/FTP]
$ftp_(83) attach-agent $tcp_(83)
$ns at 540.2 "$ftp_(83) start"
$ns at 720.0 "$ftp_(83) stop"

#Set a TCP connection between node_(9) and node_(31)
set tcp_(84) [new Agent/TCP/Newreno]
$tcp_(84) set class_ 2
set sink_(84) [new Agent/TCPSink]
$ns attach-agent $node_(9) $tcp_(84)
$ns attach-agent $node_(31) $sink_(84)
$ns connect $tcp_(84) $sink_(84)
set ftp_(84) [new Application/FTP]
$ftp_(84) attach-agent $tcp_(84)
$ns at 720.2 "$ftp_(84) start"
$ns at 900.0 "$ftp_(84) stop"

#Set a TCP connection between node_(93) and node_(21)
set tcp_(85) [new Agent/TCP/Newreno]
$tcp_(85) set class_ 2
set sink_(85) [new Agent/TCPSink]
$ns attach-agent $node_(93) $tcp_(85)
$ns attach-agent $node_(21) $sink_(85)
$ns connect $tcp_(85) $sink_(85)
set ftp_(85) [new Application/FTP]
$ftp_(85) attach-agent $tcp_(85)
$ns at 0.2 "$ftp_(85) start"
$ns at 180.0 "$ftp_(85) stop"

#Set a TCP connection between node_(35) and node_(27)
set tcp_(86) [new Agent/TCP/Newreno]
$tcp_(86) set class_ 2
set sink_(86) [new Agent/TCPSink]
$ns attach-agent $node_(35) $tcp_(86)
$ns attach-agent $node_(27) $sink_(86)
$ns connect $tcp_(86) $sink_(86)
set ftp_(86) [new Application/FTP]
$ftp_(86) attach-agent $tcp_(86)
$ns at 180.2 "$ftp_(86) start"
$ns at 360.0 "$ftp_(86) stop"

#Set a TCP connection between node_(11) and node_(87)
set tcp_(87) [new Agent/TCP/Newreno]
$tcp_(87) set class_ 2
set sink_(87) [new Agent/TCPSink]
$ns attach-agent $node_(11) $tcp_(87)
$ns attach-agent $node_(87) $sink_(87)
$ns connect $tcp_(87) $sink_(87)
set ftp_(87) [new Application/FTP]
$ftp_(87) attach-agent $tcp_(87)
$ns at 360.2 "$ftp_(87) start"
$ns at 540.0 "$ftp_(87) stop"

#Set a TCP connection between node_(83) and node_(56)
set tcp_(88) [new Agent/TCP/Newreno]
$tcp_(88) set class_ 2
set sink_(88) [new Agent/TCPSink]
$ns attach-agent $node_(83) $tcp_(88)
$ns attach-agent $node_(56) $sink_(88)
$ns connect $tcp_(88) $sink_(88)
set ftp_(88) [new Application/FTP]
$ftp_(88) attach-agent $tcp_(88)
$ns at 540.2 "$ftp_(88) start"
$ns at 720.0 "$ftp_(88) stop"

#Set a TCP connection between node_(78) and node_(18)
set tcp_(89) [new Agent/TCP/Newreno]
$tcp_(89) set class_ 2
set sink_(89) [new Agent/TCPSink]
$ns attach-agent $node_(78) $tcp_(89)
$ns attach-agent $node_(18) $sink_(89)
$ns connect $tcp_(89) $sink_(89)
set ftp_(89) [new Application/FTP]
$ftp_(89) attach-agent $tcp_(89)
$ns at 720.2 "$ftp_(89) start"
$ns at 900.0 "$ftp_(89) stop"

#Set a TCP connection between node_(34) and node_(31)
set tcp_(90) [new Agent/TCP/Newreno]
$tcp_(90) set class_ 2
set sink_(90) [new Agent/TCPSink]
$ns attach-agent $node_(34) $tcp_(90)
$ns attach-agent $node_(31) $sink_(90)
$ns connect $tcp_(90) $sink_(90)
set ftp_(90) [new Application/FTP]
$ftp_(90) attach-agent $tcp_(90)
$ns at 0.2 "$ftp_(90) start"
$ns at 180.0 "$ftp_(90) stop"

#Set a TCP connection between node_(87) and node_(54)
set tcp_(91) [new Agent/TCP/Newreno]
$tcp_(91) set class_ 2
set sink_(91) [new Agent/TCPSink]
$ns attach-agent $node_(87) $tcp_(91)
$ns attach-agent $node_(54) $sink_(91)
$ns connect $tcp_(91) $sink_(91)
set ftp_(91) [new Application/FTP]
$ftp_(91) attach-agent $tcp_(91)
$ns at 180.2 "$ftp_(91) start"
$ns at 360.0 "$ftp_(91) stop"

#Set a TCP connection between node_(64) and node_(48)
set tcp_(92) [new Agent/TCP/Newreno]
$tcp_(92) set class_ 2
set sink_(92) [new Agent/TCPSink]
$ns attach-agent $node_(64) $tcp_(92)
$ns attach-agent $node_(48) $sink_(92)
$ns connect $tcp_(92) $sink_(92)
set ftp_(92) [new Application/FTP]
$ftp_(92) attach-agent $tcp_(92)
$ns at 360.2 "$ftp_(92) start"
$ns at 540.0 "$ftp_(92) stop"

#Set a TCP connection between node_(71) and node_(3)
set tcp_(93) [new Agent/TCP/Newreno]
$tcp_(93) set class_ 2
set sink_(93) [new Agent/TCPSink]
$ns attach-agent $node_(71) $tcp_(93)
$ns attach-agent $node_(3) $sink_(93)
$ns connect $tcp_(93) $sink_(93)
set ftp_(93) [new Application/FTP]
$ftp_(93) attach-agent $tcp_(93)
$ns at 540.2 "$ftp_(93) start"
$ns at 720.0 "$ftp_(93) stop"

#Set a TCP connection between node_(22) and node_(51)
set tcp_(94) [new Agent/TCP/Newreno]
$tcp_(94) set class_ 2
set sink_(94) [new Agent/TCPSink]
$ns attach-agent $node_(22) $tcp_(94)
$ns attach-agent $node_(51) $sink_(94)
$ns connect $tcp_(94) $sink_(94)
set ftp_(94) [new Application/FTP]
$ftp_(94) attach-agent $tcp_(94)
$ns at 720.2 "$ftp_(94) start"
$ns at 900.0 "$ftp_(94) stop"

#Set a TCP connection between node_(71) and node_(98)
set tcp_(95) [new Agent/TCP/Newreno]
$tcp_(95) set class_ 2
set sink_(95) [new Agent/TCPSink]
$ns attach-agent $node_(71) $tcp_(95)
$ns attach-agent $node_(98) $sink_(95)
$ns connect $tcp_(95) $sink_(95)
set ftp_(95) [new Application/FTP]
$ftp_(95) attach-agent $tcp_(95)
$ns at 0.2 "$ftp_(95) start"
$ns at 180.0 "$ftp_(95) stop"

#Set a TCP connection between node_(25) and node_(18)
set tcp_(96) [new Agent/TCP/Newreno]
$tcp_(96) set class_ 2
set sink_(96) [new Agent/TCPSink]
$ns attach-agent $node_(25) $tcp_(96)
$ns attach-agent $node_(18) $sink_(96)
$ns connect $tcp_(96) $sink_(96)
set ftp_(96) [new Application/FTP]
$ftp_(96) attach-agent $tcp_(96)
$ns at 180.2 "$ftp_(96) start"
$ns at 360.0 "$ftp_(96) stop"

#Set a TCP connection between node_(74) and node_(31)
set tcp_(97) [new Agent/TCP/Newreno]
$tcp_(97) set class_ 2
set sink_(97) [new Agent/TCPSink]
$ns attach-agent $node_(74) $tcp_(97)
$ns attach-agent $node_(31) $sink_(97)
$ns connect $tcp_(97) $sink_(97)
set ftp_(97) [new Application/FTP]
$ftp_(97) attach-agent $tcp_(97)
$ns at 360.2 "$ftp_(97) start"
$ns at 540.0 "$ftp_(97) stop"

#Set a TCP connection between node_(56) and node_(2)
set tcp_(98) [new Agent/TCP/Newreno]
$tcp_(98) set class_ 2
set sink_(98) [new Agent/TCPSink]
$ns attach-agent $node_(56) $tcp_(98)
$ns attach-agent $node_(2) $sink_(98)
$ns connect $tcp_(98) $sink_(98)
set ftp_(98) [new Application/FTP]
$ftp_(98) attach-agent $tcp_(98)
$ns at 540.2 "$ftp_(98) start"
$ns at 720.0 "$ftp_(98) stop"

#Set a TCP connection between node_(67) and node_(65)
set tcp_(99) [new Agent/TCP/Newreno]
$tcp_(99) set class_ 2
set sink_(99) [new Agent/TCPSink]
$ns attach-agent $node_(67) $tcp_(99)
$ns attach-agent $node_(65) $sink_(99)
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
